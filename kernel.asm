
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
8010004c:	68 a0 90 10 80       	push   $0x801090a0
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 f5 4f 00 00       	call   80105050 <initlock>
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
80100092:	68 a7 90 10 80       	push   $0x801090a7
80100097:	50                   	push   %eax
80100098:	e8 83 4e 00 00       	call   80104f20 <initsleeplock>
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
801000e4:	e8 a7 50 00 00       	call   80105190 <acquire>
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
80100193:	68 ae 90 10 80       	push   $0x801090ae
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
801001cc:	68 bf 90 10 80       	push   $0x801090bf
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
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
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
8010025c:	e9 ef 4f 00 00       	jmp    80105250 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 90 10 80       	push   $0x801090c6
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
8010028c:	e8 ff 4e 00 00       	call   80105190 <acquire>
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
801002c5:	e8 26 48 00 00       	call   80104af0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 2f 11 80    	cmp    0x80112fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 40 00 00       	call   801042e0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 5c 4f 00 00       	call   80105250 <release>
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
8010034d:	e8 fe 4e 00 00       	call   80105250 <release>
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
801003b2:	68 cd 90 10 80       	push   $0x801090cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c7 9d 10 80 	movl   $0x80109dc7,(%esp)
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
801003e8:	68 e1 90 10 80       	push   $0x801090e1
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
8010043a:	e8 81 65 00 00       	call   801069c0 <uartputc>
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
801004ec:	e8 cf 64 00 00       	call   801069c0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 64 00 00       	call   801069c0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 64 00 00       	call   801069c0 <uartputc>
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
80100551:	68 e5 90 10 80       	push   $0x801090e5
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
801005b1:	0f b6 92 10 91 10 80 	movzbl -0x7fef6ef0(%edx),%edx
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
801007d0:	ba f8 90 10 80       	mov    $0x801090f8,%edx
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
80100800:	68 ff 90 10 80       	push   $0x801090ff
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
80100916:	e8 15 44 00 00       	call   80104d30 <wakeup>
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
80100997:	e9 74 44 00 00       	jmp    80104e10 <procdump>
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
801009c6:	68 08 91 10 80       	push   $0x80109108
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
80100a1a:	68 21 91 10 80       	push   $0x80109121
80100a1f:	e8 3c fc ff ff       	call   80100660 <cprintf>
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a24:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a2a:	83 c4 0c             	add    $0xc,%esp
80100a2d:	68 c0 01 00 00       	push   $0x1c0
80100a32:	50                   	push   %eax
80100a33:	68 e0 2f 11 80       	push   $0x80112fe0
80100a38:	e8 13 49 00 00       	call   80105350 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a3d:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a43:	83 c4 0c             	add    $0xc,%esp
80100a46:	68 c0 01 00 00       	push   $0x1c0
80100a4b:	50                   	push   %eax
80100a4c:	68 c0 31 11 80       	push   $0x801131c0
80100a51:	e8 fa 48 00 00       	call   80105350 <memmove>
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
80100ad8:	e8 c3 47 00 00       	call   801052a0 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100add:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ae3:	83 c4 0c             	add    $0xc,%esp
80100ae6:	68 c0 01 00 00       	push   $0x1c0
80100aeb:	6a 00                	push   $0x0
80100aed:	50                   	push   %eax
80100aee:	e8 ad 47 00 00       	call   801052a0 <memset>
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
80100bc7:	68 2b 91 10 80       	push   $0x8010912b
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
80100c47:	68 2b 91 10 80       	push   $0x8010912b
80100c4c:	e8 0f fa ff ff       	call   80100660 <cprintf>
80100c51:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	eb ba                	jmp    80100c16 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c5c:	83 ec 0c             	sub    $0xc,%esp
80100c5f:	68 58 91 10 80       	push   $0x80109158
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
80100c7c:	e8 5f 36 00 00       	call   801042e0 <myproc>
  
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
80100cdf:	68 4c 91 10 80       	push   $0x8010914c
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
80100d54:	e8 f7 45 00 00       	call   80105350 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d59:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d5f:	83 c4 0c             	add    $0xc,%esp
80100d62:	68 c0 01 00 00       	push   $0x1c0
80100d67:	68 c0 31 11 80       	push   $0x801131c0
80100d6c:	50                   	push   %eax
80100d6d:	e8 de 45 00 00       	call   80105350 <memmove>
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
80100dd0:	e8 0b 70 00 00       	call   80107de0 <setupkvm>
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
80100e3e:	e8 7d 7b 00 00       	call   801089c0 <allocuvm>
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
80100e70:	e8 9b 6a 00 00       	call   80107910 <loaduvm>
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
80100eba:	68 4c 91 10 80       	push   $0x8010914c
80100ebf:	e8 9c f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100ec4:	58                   	pop    %eax
80100ec5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ecb:	e8 90 6e 00 00       	call   80107d60 <freevm>
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
80100f20:	e8 9b 7a 00 00       	call   801089c0 <allocuvm>
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
80100f4e:	e8 3d 6f 00 00       	call   80107e90 <clearpteu>
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
80100f9b:	e8 20 45 00 00       	call   801054c0 <strlen>
80100fa0:	f7 d0                	not    %eax
80100fa2:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa4:	58                   	pop    %eax
80100fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fa8:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fab:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fae:	e8 0d 45 00 00       	call   801054c0 <strlen>
80100fb3:	83 c0 01             	add    $0x1,%eax
80100fb6:	50                   	push   %eax
80100fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fba:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fbd:	56                   	push   %esi
80100fbe:	57                   	push   %edi
80100fbf:	e8 6c 73 00 00       	call   80108330 <copyout>
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
80100fe5:	68 40 91 10 80       	push   $0x80109140
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
80101039:	e8 f2 72 00 00       	call   80108330 <copyout>
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
80101071:	e8 0a 44 00 00       	call   80105480 <safestrcpy>
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
801010e2:	e8 99 66 00 00       	call   80107780 <switchuvm>
  freevm(oldpgdir);
801010e7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010ed:	89 04 24             	mov    %eax,(%esp)
801010f0:	e8 6b 6c 00 00       	call   80107d60 <freevm>
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
80101126:	68 83 91 10 80       	push   $0x80109183
8010112b:	68 a0 33 11 80       	push   $0x801133a0
80101130:	e8 1b 3f 00 00       	call   80105050 <initlock>
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
80101151:	e8 3a 40 00 00       	call   80105190 <acquire>
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
80101181:	e8 ca 40 00 00       	call   80105250 <release>
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
8010119a:	e8 b1 40 00 00       	call   80105250 <release>
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
801011bf:	e8 cc 3f 00 00       	call   80105190 <acquire>
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
801011dc:	e8 6f 40 00 00       	call   80105250 <release>
  return f;
}
801011e1:	89 d8                	mov    %ebx,%eax
801011e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011e6:	c9                   	leave  
801011e7:	c3                   	ret    
    panic("filedup");
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	68 8a 91 10 80       	push   $0x8010918a
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
80101211:	e8 7a 3f 00 00       	call   80105190 <acquire>
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
8010123c:	e9 0f 40 00 00       	jmp    80105250 <release>
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
80101268:	e8 e3 3f 00 00       	call   80105250 <release>
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
801012c2:	68 92 91 10 80       	push   $0x80109192
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
801013a2:	68 9c 91 10 80       	push   $0x8010919c
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
801014b5:	68 a5 91 10 80       	push   $0x801091a5
801014ba:	e8 d1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	68 ab 91 10 80       	push   $0x801091ab
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
80101533:	68 b5 91 10 80       	push   $0x801091b5
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
801015e4:	68 c8 91 10 80       	push   $0x801091c8
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
80101625:	e8 76 3c 00 00       	call   801052a0 <memset>
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
8010166a:	e8 21 3b 00 00       	call   80105190 <acquire>
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
801016cf:	e8 7c 3b 00 00       	call   80105250 <release>

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
801016fd:	e8 4e 3b 00 00       	call   80105250 <release>
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
80101712:	68 de 91 10 80       	push   $0x801091de
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
801017e7:	68 ee 91 10 80       	push   $0x801091ee
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
80101821:	e8 2a 3b 00 00       	call   80105350 <memmove>
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
8010184c:	68 01 92 10 80       	push   $0x80109201
80101851:	68 c0 3d 11 80       	push   $0x80113dc0
80101856:	e8 f5 37 00 00       	call   80105050 <initlock>
8010185b:	83 c4 10             	add    $0x10,%esp
8010185e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101860:	83 ec 08             	sub    $0x8,%esp
80101863:	68 08 92 10 80       	push   $0x80109208
80101868:	53                   	push   %ebx
80101869:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010186f:	e8 ac 36 00 00       	call   80104f20 <initsleeplock>
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
801018b9:	68 b4 92 10 80       	push   $0x801092b4
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
8010194e:	e8 4d 39 00 00       	call   801052a0 <memset>
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
80101983:	68 0e 92 10 80       	push   $0x8010920e
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
801019f1:	e8 5a 39 00 00       	call   80105350 <memmove>
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
80101a1f:	e8 6c 37 00 00       	call   80105190 <acquire>
  ip->ref++;
80101a24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a28:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a2f:	e8 1c 38 00 00       	call   80105250 <release>
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
80101a62:	e8 f9 34 00 00       	call   80104f60 <acquiresleep>
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
80101ad8:	e8 73 38 00 00       	call   80105350 <memmove>
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
80101afd:	68 26 92 10 80       	push   $0x80109226
80101b02:	e8 89 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b07:	83 ec 0c             	sub    $0xc,%esp
80101b0a:	68 20 92 10 80       	push   $0x80109220
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
80101b33:	e8 c8 34 00 00       	call   80105000 <holdingsleep>
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
80101b4f:	e9 6c 34 00 00       	jmp    80104fc0 <releasesleep>
    panic("iunlock");
80101b54:	83 ec 0c             	sub    $0xc,%esp
80101b57:	68 35 92 10 80       	push   $0x80109235
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
80101b80:	e8 db 33 00 00       	call   80104f60 <acquiresleep>
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
80101b9a:	e8 21 34 00 00       	call   80104fc0 <releasesleep>
  acquire(&icache.lock);
80101b9f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101ba6:	e8 e5 35 00 00       	call   80105190 <acquire>
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
80101bc0:	e9 8b 36 00 00       	jmp    80105250 <release>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bd0:	e8 bb 35 00 00       	call   80105190 <acquire>
    int r = ip->ref;
80101bd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bd8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bdf:	e8 6c 36 00 00       	call   80105250 <release>
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
80101dc7:	e8 84 35 00 00       	call   80105350 <memmove>
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
80101ec3:	e8 88 34 00 00       	call   80105350 <memmove>
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
80101f5e:	e8 5d 34 00 00       	call   801053c0 <strncmp>
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
80101fbd:	e8 fe 33 00 00       	call   801053c0 <strncmp>
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
80102002:	68 4f 92 10 80       	push   $0x8010924f
80102007:	e8 84 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010200c:	83 ec 0c             	sub    $0xc,%esp
8010200f:	68 3d 92 10 80       	push   $0x8010923d
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
80102039:	e8 a2 22 00 00       	call   801042e0 <myproc>
  acquire(&icache.lock);
8010203e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102041:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102044:	68 c0 3d 11 80       	push   $0x80113dc0
80102049:	e8 42 31 00 00       	call   80105190 <acquire>
  ip->ref++;
8010204e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102052:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102059:	e8 f2 31 00 00       	call   80105250 <release>
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
801020b5:	e8 96 32 00 00       	call   80105350 <memmove>
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
80102148:	e8 03 32 00 00       	call   80105350 <memmove>
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
8010223d:	e8 de 31 00 00       	call   80105420 <strncpy>
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
8010227b:	68 5e 92 10 80       	push   $0x8010925e
80102280:	e8 0b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	68 b5 99 10 80       	push   $0x801099b5
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
80102381:	68 6b 92 10 80       	push   $0x8010926b
80102386:	56                   	push   %esi
80102387:	e8 c4 2f 00 00       	call   80105350 <memmove>
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
801023e2:	68 73 92 10 80       	push   $0x80109273
801023e7:	53                   	push   %ebx
801023e8:	e8 d3 2f 00 00       	call   801053c0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 c0                	test   %eax,%eax
801023f2:	0f 84 f8 00 00 00    	je     801024f0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023f8:	83 ec 04             	sub    $0x4,%esp
801023fb:	6a 0e                	push   $0xe
801023fd:	68 72 92 10 80       	push   $0x80109272
80102402:	53                   	push   %ebx
80102403:	e8 b8 2f 00 00       	call   801053c0 <strncmp>
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
80102457:	e8 44 2e 00 00       	call   801052a0 <memset>
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
801024c4:	e8 b7 35 00 00       	call   80105a80 <isdirempty>
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
8010254c:	68 87 92 10 80       	push   $0x80109287
80102551:	e8 3a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	68 75 92 10 80       	push   $0x80109275
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
80102580:	68 6b 92 10 80       	push   $0x8010926b
80102585:	56                   	push   %esi
80102586:	e8 c5 2d 00 00       	call   80105350 <memmove>
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
801025a5:	e8 e6 36 00 00       	call   80105c90 <create>
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
801025f9:	68 96 92 10 80       	push   $0x80109296
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
8010272b:	68 10 93 10 80       	push   $0x80109310
80102730:	e8 5b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102735:	83 ec 0c             	sub    $0xc,%esp
80102738:	68 07 93 10 80       	push   $0x80109307
8010273d:	e8 4e dc ff ff       	call   80100390 <panic>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <ideinit>:
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102756:	68 22 93 10 80       	push   $0x80109322
8010275b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102760:	e8 eb 28 00 00       	call   80105050 <initlock>
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
80102841:	e8 ea 24 00 00       	call   80104d30 <wakeup>

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
80102909:	e8 e2 21 00 00       	call   80104af0 <sleep>
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
8010294a:	68 3c 93 10 80       	push   $0x8010933c
8010294f:	e8 3c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 26 93 10 80       	push   $0x80109326
8010295c:	e8 2f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	68 51 93 10 80       	push   $0x80109351
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
801029b7:	68 70 93 10 80       	push   $0x80109370
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
80102a9d:	e8 fe 27 00 00       	call   801052a0 <memset>

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
80102b03:	e9 48 27 00 00       	jmp    80105250 <release>
80102b08:	90                   	nop
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	68 20 5a 11 80       	push   $0x80115a20
80102b18:	e8 73 26 00 00       	call   80105190 <acquire>
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	eb 8d                	jmp    80102aaf <kfree+0x4f>
    panic("kfree");
80102b22:	83 ec 0c             	sub    $0xc,%esp
80102b25:	68 a2 93 10 80       	push   $0x801093a2
80102b2a:	e8 61 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b2f:	83 ec 0c             	sub    $0xc,%esp
80102b32:	68 a8 93 10 80       	push   $0x801093a8
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
80102b7d:	e8 1e 27 00 00       	call   801052a0 <memset>

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
80102bce:	e8 bd 25 00 00       	call   80105190 <acquire>
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
80102c0d:	e9 3e 26 00 00       	jmp    80105250 <release>
    panic("kfree_nocheck");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 c5 93 10 80       	push   $0x801093c5
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
80102c7b:	68 d3 93 10 80       	push   $0x801093d3
80102c80:	68 20 5a 11 80       	push   $0x80115a20
80102c85:	e8 c6 23 00 00       	call   80105050 <initlock>
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
80102d8b:	e8 c0 24 00 00       	call   80105250 <release>
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
80102db0:	e8 db 23 00 00       	call   80105190 <acquire>
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
80102e31:	e8 5a 23 00 00       	call   80105190 <acquire>
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
80102ea1:	e8 ea 22 00 00       	call   80105190 <acquire>
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
80102f33:	0f b6 82 00 95 10 80 	movzbl -0x7fef6b00(%edx),%eax
80102f3a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f3c:	0f b6 82 00 94 10 80 	movzbl -0x7fef6c00(%edx),%eax
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
80102f53:	8b 04 85 e0 93 10 80 	mov    -0x7fef6c20(,%eax,4),%eax
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
80102f78:	0f b6 82 00 95 10 80 	movzbl -0x7fef6b00(%edx),%eax
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
801032f7:	e8 f4 1f 00 00       	call   801052f0 <memcmp>
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
80103424:	e8 27 1f 00 00       	call   80105350 <memmove>
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
801034ca:	68 00 96 10 80       	push   $0x80109600
801034cf:	68 60 5a 18 80       	push   $0x80185a60
801034d4:	e8 77 1b 00 00       	call   80105050 <initlock>
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
8010356b:	e8 20 1c 00 00       	call   80105190 <acquire>
80103570:	83 c4 10             	add    $0x10,%esp
80103573:	eb 18                	jmp    8010358d <begin_op+0x2d>
80103575:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103578:	83 ec 08             	sub    $0x8,%esp
8010357b:	68 60 5a 18 80       	push   $0x80185a60
80103580:	68 60 5a 18 80       	push   $0x80185a60
80103585:	e8 66 15 00 00       	call   80104af0 <sleep>
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
801035bc:	e8 8f 1c 00 00       	call   80105250 <release>
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
801035de:	e8 ad 1b 00 00       	call   80105190 <acquire>
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
8010361c:	e8 2f 1c 00 00       	call   80105250 <release>
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
80103676:	e8 d5 1c 00 00       	call   80105350 <memmove>
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
801036bf:	e8 cc 1a 00 00       	call   80105190 <acquire>
    wakeup(&log);
801036c4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036cb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036d2:	00 00 00 
    wakeup(&log);
801036d5:	e8 56 16 00 00       	call   80104d30 <wakeup>
    release(&log.lock);
801036da:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036e1:	e8 6a 1b 00 00       	call   80105250 <release>
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
80103700:	e8 2b 16 00 00       	call   80104d30 <wakeup>
  release(&log.lock);
80103705:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
8010370c:	e8 3f 1b 00 00       	call   80105250 <release>
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
8010371f:	68 04 96 10 80       	push   $0x80109604
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
8010376e:	e8 1d 1a 00 00       	call   80105190 <acquire>
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
801037bd:	e9 8e 1a 00 00       	jmp    80105250 <release>
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
801037e9:	68 13 96 10 80       	push   $0x80109613
801037ee:	e8 9d cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	68 29 96 10 80       	push   $0x80109629
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
80103807:	e8 b4 0a 00 00       	call   801042c0 <cpuid>
8010380c:	89 c3                	mov    %eax,%ebx
8010380e:	e8 ad 0a 00 00       	call   801042c0 <cpuid>
80103813:	83 ec 04             	sub    $0x4,%esp
80103816:	53                   	push   %ebx
80103817:	50                   	push   %eax
80103818:	68 44 96 10 80       	push   $0x80109644
8010381d:	e8 3e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103822:	e8 69 2d 00 00       	call   80106590 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103827:	e8 14 0a 00 00       	call   80104240 <mycpu>
8010382c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010382e:	b8 01 00 00 00       	mov    $0x1,%eax
80103833:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010383a:	e8 a1 0f 00 00       	call   801047e0 <scheduler>
8010383f:	90                   	nop

80103840 <mpenter>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103846:	e8 15 3f 00 00       	call   80107760 <switchkvm>
  seginit();
8010384b:	e8 80 3e 00 00       	call   801076d0 <seginit>
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
80103881:	e8 ea 45 00 00       	call   80107e70 <kvmalloc>
  mpinit();        // detect other processors
80103886:	e8 75 01 00 00       	call   80103a00 <mpinit>
  lapicinit();     // interrupt controller
8010388b:	e8 60 f7 ff ff       	call   80102ff0 <lapicinit>
  seginit();       // segment descriptors
80103890:	e8 3b 3e 00 00       	call   801076d0 <seginit>
  picinit();       // disable pic
80103895:	e8 46 03 00 00       	call   80103be0 <picinit>
  ioapicinit();    // another interrupt controller
8010389a:	e8 d1 f0 ff ff       	call   80102970 <ioapicinit>
  consoleinit();   // console hardware
8010389f:	e8 1c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801038a4:	e8 57 30 00 00       	call   80106900 <uartinit>
  pinit();         // process table
801038a9:	e8 72 09 00 00       	call   80104220 <pinit>
  tvinit();        // trap vectors
801038ae:	e8 5d 2c 00 00       	call   80106510 <tvinit>
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
801038d4:	e8 77 1a 00 00       	call   80105350 <memmove>

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
80103900:	e8 3b 09 00 00       	call   80104240 <mycpu>
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
80103975:	e8 96 09 00 00       	call   80104310 <userinit>
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
801039ae:	68 58 96 10 80       	push   $0x80109658
801039b3:	56                   	push   %esi
801039b4:	e8 37 19 00 00       	call   801052f0 <memcmp>
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
80103a6c:	68 75 96 10 80       	push   $0x80109675
80103a71:	56                   	push   %esi
80103a72:	e8 79 18 00 00       	call   801052f0 <memcmp>
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
80103b00:	ff 24 95 9c 96 10 80 	jmp    *-0x7fef6964(,%edx,4)
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
80103bb3:	68 5d 96 10 80       	push   $0x8010965d
80103bb8:	e8 d3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 7c 96 10 80       	push   $0x8010967c
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
80103cbb:	68 b0 96 10 80       	push   $0x801096b0
80103cc0:	50                   	push   %eax
80103cc1:	e8 8a 13 00 00       	call   80105050 <initlock>
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
80103d1f:	e8 6c 14 00 00       	call   80105190 <acquire>
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
80103d3f:	e8 ec 0f 00 00       	call   80104d30 <wakeup>
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
80103d64:	e9 e7 14 00 00       	jmp    80105250 <release>
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d70:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d76:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d79:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d80:	00 00 00 
    wakeup(&p->nwrite);
80103d83:	50                   	push   %eax
80103d84:	e8 a7 0f 00 00       	call   80104d30 <wakeup>
80103d89:	83 c4 10             	add    $0x10,%esp
80103d8c:	eb b9                	jmp    80103d47 <pipeclose+0x37>
80103d8e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	53                   	push   %ebx
80103d94:	e8 b7 14 00 00       	call   80105250 <release>
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
80103dbd:	e8 ce 13 00 00       	call   80105190 <acquire>
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
80103e14:	e8 17 0f 00 00       	call   80104d30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e19:	5a                   	pop    %edx
80103e1a:	59                   	pop    %ecx
80103e1b:	53                   	push   %ebx
80103e1c:	56                   	push   %esi
80103e1d:	e8 ce 0c 00 00       	call   80104af0 <sleep>
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
80103e44:	e8 97 04 00 00       	call   801042e0 <myproc>
80103e49:	8b 40 24             	mov    0x24(%eax),%eax
80103e4c:	85 c0                	test   %eax,%eax
80103e4e:	74 c0                	je     80103e10 <pipewrite+0x60>
        release(&p->lock);
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	53                   	push   %ebx
80103e54:	e8 f7 13 00 00       	call   80105250 <release>
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
80103ea3:	e8 88 0e 00 00       	call   80104d30 <wakeup>
  release(&p->lock);
80103ea8:	89 1c 24             	mov    %ebx,(%esp)
80103eab:	e8 a0 13 00 00       	call   80105250 <release>
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
80103ed0:	e8 bb 12 00 00       	call   80105190 <acquire>
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
80103f05:	e8 e6 0b 00 00       	call   80104af0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0a:	83 c4 10             	add    $0x10,%esp
80103f0d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f13:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f19:	75 35                	jne    80103f50 <piperead+0x90>
80103f1b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103f21:	85 d2                	test   %edx,%edx
80103f23:	0f 84 8f 00 00 00    	je     80103fb8 <piperead+0xf8>
    if(myproc()->killed){
80103f29:	e8 b2 03 00 00       	call   801042e0 <myproc>
80103f2e:	8b 48 24             	mov    0x24(%eax),%ecx
80103f31:	85 c9                	test   %ecx,%ecx
80103f33:	74 cb                	je     80103f00 <piperead+0x40>
      release(&p->lock);
80103f35:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f3d:	56                   	push   %esi
80103f3e:	e8 0d 13 00 00       	call   80105250 <release>
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
80103f97:	e8 94 0d 00 00       	call   80104d30 <wakeup>
  release(&p->lock);
80103f9c:	89 34 24             	mov    %esi,(%esp)
80103f9f:	e8 ac 12 00 00       	call   80105250 <release>
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
80103fd3:	e8 b8 11 00 00       	call   80105190 <acquire>
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb 15                	jmp    80103ff2 <allocproc+0x32>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe0:	81 c3 30 04 00 00    	add    $0x430,%ebx
80103fe6:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80103fec:	0f 83 a6 01 00 00    	jae    80104198 <allocproc+0x1d8>
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
80104019:	e8 32 12 00 00       	call   80105250 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010401e:	e8 1d ed ff ff       	call   80102d40 <kalloc>
80104023:	83 c4 10             	add    $0x10,%esp
80104026:	85 c0                	test   %eax,%eax
80104028:	89 43 08             	mov    %eax,0x8(%ebx)
8010402b:	0f 84 83 01 00 00    	je     801041b4 <allocproc+0x1f4>
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
80104042:	c7 40 14 01 65 10 80 	movl   $0x80106501,0x14(%eax)
  p->context = (struct context*)sp;
80104049:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010404c:	6a 14                	push   $0x14
8010404e:	6a 00                	push   $0x0
80104050:	50                   	push   %eax
80104051:	e8 4a 12 00 00       	call   801052a0 <memset>
  p->context->eip = (uint)forkret;
80104056:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80104059:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010405c:	c7 40 10 d0 41 10 80 	movl   $0x801041d0,0x10(%eax)
  if(p->pid > 2) {
80104063:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104067:	7f 0f                	jg     80104078 <allocproc+0xb8>
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
    p->selection = AQ;  //TODO: update dynamically
8010407b:	c7 83 24 04 00 00 04 	movl   $0x4,0x424(%ebx)
80104082:	00 00 00 
    if(createSwapFile(p) != 0)
80104085:	53                   	push   %ebx
80104086:	e8 e5 e4 ff ff       	call   80102570 <createSwapFile>
8010408b:	83 c4 10             	add    $0x10,%esp
8010408e:	85 c0                	test   %eax,%eax
80104090:	0f 85 2c 01 00 00    	jne    801041c2 <allocproc+0x202>
    if(p->selection == SCFIFO)
80104096:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
    p->num_ram = 0;
8010409c:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
801040a3:	00 00 00 
    p->num_swap = 0;
801040a6:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
801040ad:	00 00 00 
    p->totalPgfltCount = 0;
801040b0:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
801040b7:	00 00 00 
    p->totalPgoutCount = 0;
801040ba:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
801040c1:	00 00 00 
    if(p->selection == SCFIFO)
801040c4:	83 f8 03             	cmp    $0x3,%eax
801040c7:	0f 84 b7 00 00 00    	je     80104184 <allocproc+0x1c4>
    if(p->selection == AQ)
801040cd:	83 f8 04             	cmp    $0x4,%eax
801040d0:	75 14                	jne    801040e6 <allocproc+0x126>
      p->queue_head = 0;
801040d2:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
801040d9:	00 00 00 
      p->queue_tail = 0;
801040dc:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
801040e3:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040e6:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
801040ec:	83 ec 04             	sub    $0x4,%esp
801040ef:	68 c0 01 00 00       	push   $0x1c0
801040f4:	6a 00                	push   $0x0
801040f6:	50                   	push   %eax
801040f7:	e8 a4 11 00 00       	call   801052a0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040fc:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104102:	83 c4 0c             	add    $0xc,%esp
80104105:	68 c0 01 00 00       	push   $0x1c0
8010410a:	6a 00                	push   $0x0
8010410c:	50                   	push   %eax
8010410d:	e8 8e 11 00 00       	call   801052a0 <memset>
    if(p->pid > 2)
80104112:	83 c4 10             	add    $0x10,%esp
80104115:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104119:	0f 8e 4a ff ff ff    	jle    80104069 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
8010411f:	e8 1c ec ff ff       	call   80102d40 <kalloc>
80104124:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
8010412a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80104131:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
80104136:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
8010413c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80104142:	8b bb 14 04 00 00    	mov    0x414(%ebx),%edi
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        struct fblock *curr = (struct fblock*)kalloc();
80104150:	e8 eb eb ff ff       	call   80102d40 <kalloc>
        curr->off = i * PGSIZE;
80104155:	89 30                	mov    %esi,(%eax)
80104157:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
8010415d:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104160:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80104166:	89 47 04             	mov    %eax,0x4(%edi)
80104169:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
8010416b:	75 e3                	jne    80104150 <allocproc+0x190>
      p->free_tail = prev;
8010416d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010417a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010417d:	89 d8                	mov    %ebx,%eax
8010417f:	5b                   	pop    %ebx
80104180:	5e                   	pop    %esi
80104181:	5f                   	pop    %edi
80104182:	5d                   	pop    %ebp
80104183:	c3                   	ret    
      p->clockHand = 0;
80104184:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
8010418b:	00 00 00 
8010418e:	e9 53 ff ff ff       	jmp    801040e6 <allocproc+0x126>
80104193:	90                   	nop
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104198:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010419b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010419d:	68 00 61 18 80       	push   $0x80186100
801041a2:	e8 a9 10 00 00       	call   80105250 <release>
  return 0;
801041a7:	83 c4 10             	add    $0x10,%esp
}
801041aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041ad:	89 d8                	mov    %ebx,%eax
801041af:	5b                   	pop    %ebx
801041b0:	5e                   	pop    %esi
801041b1:	5f                   	pop    %edi
801041b2:	5d                   	pop    %ebp
801041b3:	c3                   	ret    
    p->state = UNUSED;
801041b4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801041bb:	31 db                	xor    %ebx,%ebx
801041bd:	e9 a7 fe ff ff       	jmp    80104069 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
801041c2:	83 ec 0c             	sub    $0xc,%esp
801041c5:	68 b5 96 10 80       	push   $0x801096b5
801041ca:	e8 c1 c1 ff ff       	call   80100390 <panic>
801041cf:	90                   	nop

801041d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041d6:	68 00 61 18 80       	push   $0x80186100
801041db:	e8 70 10 00 00       	call   80105250 <release>

  if (first) {
801041e0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	85 c0                	test   %eax,%eax
801041ea:	75 04                	jne    801041f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801041ec:	c9                   	leave  
801041ed:	c3                   	ret    
801041ee:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801041f0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801041f3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801041fa:	00 00 00 
    iinit(ROOTDEV);
801041fd:	6a 01                	push   $0x1
801041ff:	e8 3c d6 ff ff       	call   80101840 <iinit>
    initlog(ROOTDEV);
80104204:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010420b:	e8 b0 f2 ff ff       	call   801034c0 <initlog>
80104210:	83 c4 10             	add    $0x10,%esp
}
80104213:	c9                   	leave  
80104214:	c3                   	ret    
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <pinit>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104226:	68 cf 96 10 80       	push   $0x801096cf
8010422b:	68 00 61 18 80       	push   $0x80186100
80104230:	e8 1b 0e 00 00       	call   80105050 <initlock>
}
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <mycpu>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104245:	9c                   	pushf  
80104246:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104247:	f6 c4 02             	test   $0x2,%ah
8010424a:	75 5e                	jne    801042aa <mycpu+0x6a>
  apicid = lapicid();
8010424c:	e8 9f ee ff ff       	call   801030f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104251:	8b 35 e0 60 18 80    	mov    0x801860e0,%esi
80104257:	85 f6                	test   %esi,%esi
80104259:	7e 42                	jle    8010429d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010425b:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
80104262:	39 d0                	cmp    %edx,%eax
80104264:	74 30                	je     80104296 <mycpu+0x56>
80104266:	b9 10 5c 18 80       	mov    $0x80185c10,%ecx
  for (i = 0; i < ncpu; ++i) {
8010426b:	31 d2                	xor    %edx,%edx
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
80104270:	83 c2 01             	add    $0x1,%edx
80104273:	39 f2                	cmp    %esi,%edx
80104275:	74 26                	je     8010429d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104277:	0f b6 19             	movzbl (%ecx),%ebx
8010427a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104280:	39 c3                	cmp    %eax,%ebx
80104282:	75 ec                	jne    80104270 <mycpu+0x30>
80104284:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010428a:	05 60 5b 18 80       	add    $0x80185b60,%eax
}
8010428f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104292:	5b                   	pop    %ebx
80104293:	5e                   	pop    %esi
80104294:	5d                   	pop    %ebp
80104295:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104296:	b8 60 5b 18 80       	mov    $0x80185b60,%eax
      return &cpus[i];
8010429b:	eb f2                	jmp    8010428f <mycpu+0x4f>
  panic("unknown apicid\n");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 d6 96 10 80       	push   $0x801096d6
801042a5:	e8 e6 c0 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 bc 97 10 80       	push   $0x801097bc
801042b2:	e8 d9 c0 ff ff       	call   80100390 <panic>
801042b7:	89 f6                	mov    %esi,%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <cpuid>:
cpuid() {
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042c6:	e8 75 ff ff ff       	call   80104240 <mycpu>
801042cb:	2d 60 5b 18 80       	sub    $0x80185b60,%eax
}
801042d0:	c9                   	leave  
  return mycpu()-cpus;
801042d1:	c1 f8 04             	sar    $0x4,%eax
801042d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042da:	c3                   	ret    
801042db:	90                   	nop
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042e0 <myproc>:
myproc(void) {
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042e7:	e8 d4 0d 00 00       	call   801050c0 <pushcli>
  c = mycpu();
801042ec:	e8 4f ff ff ff       	call   80104240 <mycpu>
  p = c->proc;
801042f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042f7:	e8 04 0e 00 00       	call   80105100 <popcli>
}
801042fc:	83 c4 04             	add    $0x4,%esp
801042ff:	89 d8                	mov    %ebx,%eax
80104301:	5b                   	pop    %ebx
80104302:	5d                   	pop    %ebp
80104303:	c3                   	ret    
80104304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010430a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104310 <userinit>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104317:	e8 a4 fc ff ff       	call   80103fc0 <allocproc>
8010431c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010431e:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  if((p->pgdir = setupkvm()) == 0)
80104323:	e8 b8 3a 00 00       	call   80107de0 <setupkvm>
80104328:	85 c0                	test   %eax,%eax
8010432a:	89 43 04             	mov    %eax,0x4(%ebx)
8010432d:	0f 84 bd 00 00 00    	je     801043f0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104333:	83 ec 04             	sub    $0x4,%esp
80104336:	68 2c 00 00 00       	push   $0x2c
8010433b:	68 60 c4 10 80       	push   $0x8010c460
80104340:	50                   	push   %eax
80104341:	e8 4a 35 00 00       	call   80107890 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104346:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104349:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010434f:	6a 4c                	push   $0x4c
80104351:	6a 00                	push   $0x0
80104353:	ff 73 18             	pushl  0x18(%ebx)
80104356:	e8 45 0f 00 00       	call   801052a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010435b:	8b 43 18             	mov    0x18(%ebx),%eax
8010435e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104363:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104368:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010436b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010436f:	8b 43 18             	mov    0x18(%ebx),%eax
80104372:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104376:	8b 43 18             	mov    0x18(%ebx),%eax
80104379:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010437d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104381:	8b 43 18             	mov    0x18(%ebx),%eax
80104384:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104388:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010438c:	8b 43 18             	mov    0x18(%ebx),%eax
8010438f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104396:	8b 43 18             	mov    0x18(%ebx),%eax
80104399:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043a0:	8b 43 18             	mov    0x18(%ebx),%eax
801043a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801043aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043ad:	6a 10                	push   $0x10
801043af:	68 ff 96 10 80       	push   $0x801096ff
801043b4:	50                   	push   %eax
801043b5:	e8 c6 10 00 00       	call   80105480 <safestrcpy>
  p->cwd = namei("/");
801043ba:	c7 04 24 08 97 10 80 	movl   $0x80109708,(%esp)
801043c1:	e8 da de ff ff       	call   801022a0 <namei>
801043c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043c9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043d0:	e8 bb 0d 00 00       	call   80105190 <acquire>
  p->state = RUNNABLE;
801043d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043dc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043e3:	e8 68 0e 00 00       	call   80105250 <release>
}
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ee:	c9                   	leave  
801043ef:	c3                   	ret    
    panic("userinit: out of memory?");
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 e6 96 10 80       	push   $0x801096e6
801043f8:	e8 93 bf ff ff       	call   80100390 <panic>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <growproc>:
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	83 ec 10             	sub    $0x10,%esp
80104408:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010440b:	e8 b0 0c 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104410:	e8 2b fe ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104415:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010441b:	e8 e0 0c 00 00       	call   80105100 <popcli>
  if(n > 0){
80104420:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104423:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104425:	7f 19                	jg     80104440 <growproc+0x40>
  } else if(n < 0){
80104427:	75 37                	jne    80104460 <growproc+0x60>
  switchuvm(curproc);
80104429:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010442c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010442e:	53                   	push   %ebx
8010442f:	e8 4c 33 00 00       	call   80107780 <switchuvm>
  return 0;
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	31 c0                	xor    %eax,%eax
}
80104439:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010443c:	5b                   	pop    %ebx
8010443d:	5e                   	pop    %esi
8010443e:	5d                   	pop    %ebp
8010443f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104440:	83 ec 04             	sub    $0x4,%esp
80104443:	01 c6                	add    %eax,%esi
80104445:	56                   	push   %esi
80104446:	50                   	push   %eax
80104447:	ff 73 04             	pushl  0x4(%ebx)
8010444a:	e8 71 45 00 00       	call   801089c0 <allocuvm>
8010444f:	83 c4 10             	add    $0x10,%esp
80104452:	85 c0                	test   %eax,%eax
80104454:	75 d3                	jne    80104429 <growproc+0x29>
      return -1;
80104456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445b:	eb dc                	jmp    80104439 <growproc+0x39>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104466:	68 0a 97 10 80       	push   $0x8010970a
8010446b:	e8 f0 c1 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104473:	83 c4 0c             	add    $0xc,%esp
80104476:	01 c6                	add    %eax,%esi
80104478:	56                   	push   %esi
80104479:	50                   	push   %eax
8010447a:	ff 73 04             	pushl  0x4(%ebx)
8010447d:	e8 be 36 00 00       	call   80107b40 <deallocuvm>
80104482:	83 c4 10             	add    $0x10,%esp
80104485:	85 c0                	test   %eax,%eax
80104487:	75 a0                	jne    80104429 <growproc+0x29>
80104489:	eb cb                	jmp    80104456 <growproc+0x56>
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <copyAQ>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010449c:	e8 1f 0c 00 00       	call   801050c0 <pushcli>
  c = mycpu();
801044a1:	e8 9a fd ff ff       	call   80104240 <mycpu>
  p = c->proc;
801044a6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044ac:	e8 4f 0c 00 00       	call   80105100 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
801044b1:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
801044b7:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
801044be:	00 00 00 
  np->queue_tail = 0;
801044c1:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
801044c8:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
801044cb:	85 db                	test   %ebx,%ebx
801044cd:	74 4f                	je     8010451e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
801044cf:	e8 6c e8 ff ff       	call   80102d40 <kalloc>
801044d4:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
801044d6:	8b 43 08             	mov    0x8(%ebx),%eax
801044d9:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
801044dc:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
801044e2:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
801044e9:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801044eb:	85 db                	test   %ebx,%ebx
801044ed:	74 37                	je     80104526 <copyAQ+0x96>
801044ef:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
801044f0:	e8 4b e8 ff ff       	call   80102d40 <kalloc>
    np_curr->page_index = old_curr->page_index;
801044f5:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
801044f8:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
801044fb:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
801044fe:	89 07                	mov    %eax,(%edi)
80104500:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
80104502:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
80104504:	85 db                	test   %ebx,%ebx
80104506:	75 e8                	jne    801044f0 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
80104508:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
8010450e:	85 d2                	test   %edx,%edx
80104510:	74 0c                	je     8010451e <copyAQ+0x8e>
    np_curr->next = 0;
80104512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104518:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010451e:	83 c4 0c             	add    $0xc,%esp
80104521:	5b                   	pop    %ebx
80104522:	5e                   	pop    %esi
80104523:	5f                   	pop    %edi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    
  while(old_curr != 0)
80104526:	89 f8                	mov    %edi,%eax
80104528:	eb de                	jmp    80104508 <copyAQ+0x78>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <fork>:
{ 
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	53                   	push   %ebx
80104536:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010453c:	e8 7f 0b 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104541:	e8 fa fc ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104546:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
8010454c:	89 b5 e4 f7 ff ff    	mov    %esi,-0x81c(%ebp)
  popcli();
80104552:	e8 a9 0b 00 00       	call   80105100 <popcli>
  if((np = allocproc()) == 0){
80104557:	e8 64 fa ff ff       	call   80103fc0 <allocproc>
8010455c:	85 c0                	test   %eax,%eax
8010455e:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
80104564:	0f 84 48 02 00 00    	je     801047b2 <fork+0x282>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010456a:	83 ec 08             	sub    $0x8,%esp
8010456d:	ff 36                	pushl  (%esi)
8010456f:	ff 76 04             	pushl  0x4(%esi)
80104572:	89 c3                	mov    %eax,%ebx
80104574:	e8 27 3c 00 00       	call   801081a0 <copyuvm>
  if(np->pgdir == 0){
80104579:	83 c4 10             	add    $0x10,%esp
8010457c:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010457e:	89 43 04             	mov    %eax,0x4(%ebx)
  if(np->pgdir == 0){
80104581:	0f 84 32 02 00 00    	je     801047b9 <fork+0x289>
  np->sz = curproc->sz;
80104587:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010458d:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
80104593:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80104595:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104598:	89 51 14             	mov    %edx,0x14(%ecx)
  np->sz = curproc->sz;
8010459b:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010459d:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
8010459f:	8b 72 18             	mov    0x18(%edx),%esi
801045a2:	b9 13 00 00 00       	mov    $0x13,%ecx
801045a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801045a9:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
801045ad:	0f 8e 1c 01 00 00    	jle    801046cf <fork+0x19f>
    np->totalPgfltCount = 0;
801045b3:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801045ba:	00 00 00 
    np->totalPgoutCount = 0;
801045bd:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801045c4:	00 00 00 
    np->totalPgfltCount = 0;
801045c7:	89 c1                	mov    %eax,%ecx
    np->num_ram = curproc->num_ram;
801045c9:	8b 82 08 04 00 00    	mov    0x408(%edx),%eax
801045cf:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
    np->num_swap = curproc->num_swap;
801045d5:	8b 82 0c 04 00 00    	mov    0x40c(%edx),%eax
801045db:	89 81 0c 04 00 00    	mov    %eax,0x40c(%ecx)
      if(curproc->ramPages[i].isused)
801045e1:	8b 9a 4c 02 00 00    	mov    0x24c(%edx),%ebx
801045e7:	85 db                	test   %ebx,%ebx
801045e9:	0f 85 86 01 00 00    	jne    80104775 <fork+0x245>
801045ef:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
{ 
801045f5:	c7 85 dc f7 ff ff 00 	movl   $0x0,-0x824(%ebp)
801045fc:	00 00 00 
801045ff:	90                   	nop
      if(curproc->swappedPages[i].isused)
80104600:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
80104606:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
8010460c:	8b 84 11 8c 00 00 00 	mov    0x8c(%ecx,%edx,1),%eax
80104613:	85 c0                	test   %eax,%eax
80104615:	74 45                	je     8010465c <fork+0x12c>
      np->swappedPages[i].isused = 1;
80104617:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
8010461d:	c7 84 17 8c 00 00 00 	movl   $0x1,0x8c(%edi,%edx,1)
80104624:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104628:	8b 84 11 90 00 00 00 	mov    0x90(%ecx,%edx,1),%eax
8010462f:	89 84 17 90 00 00 00 	mov    %eax,0x90(%edi,%edx,1)
      np->swappedPages[i].pgdir = np->pgdir;
80104636:	8b 47 04             	mov    0x4(%edi),%eax
80104639:	89 84 17 88 00 00 00 	mov    %eax,0x88(%edi,%edx,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104640:	8b 84 11 94 00 00 00 	mov    0x94(%ecx,%edx,1),%eax
80104647:	89 84 17 94 00 00 00 	mov    %eax,0x94(%edi,%edx,1)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
8010464e:	8b 84 11 98 00 00 00 	mov    0x98(%ecx,%edx,1),%eax
80104655:	89 84 17 98 00 00 00 	mov    %eax,0x98(%edi,%edx,1)
        char buffer[PGSIZE / 2] = "";
8010465c:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104662:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104667:	31 c0                	xor    %eax,%eax
80104669:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104670:	00 00 00 
80104673:	f3 ab                	rep stos %eax,%es:(%edi)
        int offset = 0;
80104675:	31 ff                	xor    %edi,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
80104677:	eb 23                	jmp    8010469c <fork+0x16c>
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
80104680:	53                   	push   %ebx
80104681:	57                   	push   %edi
80104682:	56                   	push   %esi
80104683:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
80104689:	e8 82 df ff ff       	call   80102610 <writeToSwapFile>
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	83 f8 ff             	cmp    $0xffffffff,%eax
80104694:	0f 84 0b 01 00 00    	je     801047a5 <fork+0x275>
        offset += nread;
8010469a:	01 df                	add    %ebx,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
8010469c:	68 00 08 00 00       	push   $0x800
801046a1:	57                   	push   %edi
801046a2:	56                   	push   %esi
801046a3:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
801046a9:	e8 92 df ff ff       	call   80102640 <readFromSwapFile>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	85 c0                	test   %eax,%eax
801046b3:	89 c3                	mov    %eax,%ebx
801046b5:	75 c9                	jne    80104680 <fork+0x150>
801046b7:	83 85 dc f7 ff ff 1c 	addl   $0x1c,-0x824(%ebp)
801046be:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801046c4:	3d c0 01 00 00       	cmp    $0x1c0,%eax
801046c9:	0f 85 31 ff ff ff    	jne    80104600 <fork+0xd0>
  np->tf->eax = 0;
801046cf:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801046d5:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
801046db:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801046dd:	8b 47 18             	mov    0x18(%edi),%eax
801046e0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801046e7:	89 f6                	mov    %esi,%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801046f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801046f4:	85 c0                	test   %eax,%eax
801046f6:	74 10                	je     80104708 <fork+0x1d8>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046f8:	83 ec 0c             	sub    $0xc,%esp
801046fb:	50                   	push   %eax
801046fc:	e8 af ca ff ff       	call   801011b0 <filedup>
80104701:	83 c4 10             	add    $0x10,%esp
80104704:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104708:	83 c6 01             	add    $0x1,%esi
8010470b:	83 fe 10             	cmp    $0x10,%esi
8010470e:	75 e0                	jne    801046f0 <fork+0x1c0>
  np->cwd = idup(curproc->cwd);
80104710:	8b b5 e4 f7 ff ff    	mov    -0x81c(%ebp),%esi
80104716:	83 ec 0c             	sub    $0xc,%esp
80104719:	ff 76 68             	pushl  0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010471c:	8d 5e 6c             	lea    0x6c(%esi),%ebx
  np->cwd = idup(curproc->cwd);
8010471f:	e8 ec d2 ff ff       	call   80101a10 <idup>
80104724:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010472a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010472d:	89 41 68             	mov    %eax,0x68(%ecx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104730:	8d 41 6c             	lea    0x6c(%ecx),%eax
80104733:	6a 10                	push   $0x10
80104735:	53                   	push   %ebx
80104736:	89 ce                	mov    %ecx,%esi
80104738:	50                   	push   %eax
80104739:	e8 42 0d 00 00       	call   80105480 <safestrcpy>
  pid = np->pid;
8010473e:	8b 5e 10             	mov    0x10(%esi),%ebx
  copyAQ(np);
80104741:	89 34 24             	mov    %esi,(%esp)
80104744:	e8 47 fd ff ff       	call   80104490 <copyAQ>
  acquire(&ptable.lock);
80104749:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104750:	e8 3b 0a 00 00       	call   80105190 <acquire>
  np->state = RUNNABLE;
80104755:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
8010475c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
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
        np->ramPages[i].isused = 1;
80104775:	c7 81 4c 02 00 00 01 	movl   $0x1,0x24c(%ecx)
8010477c:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010477f:	8b 82 50 02 00 00    	mov    0x250(%edx),%eax
80104785:	89 81 50 02 00 00    	mov    %eax,0x250(%ecx)
        np->ramPages[i].pgdir = np->pgdir;
8010478b:	8b 41 04             	mov    0x4(%ecx),%eax
8010478e:	89 81 48 02 00 00    	mov    %eax,0x248(%ecx)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104794:	8b 82 58 02 00 00    	mov    0x258(%edx),%eax
8010479a:	89 81 58 02 00 00    	mov    %eax,0x258(%ecx)
801047a0:	e9 4a fe ff ff       	jmp    801045ef <fork+0xbf>
          panic("fork: error copying parent's swap file");
801047a5:	83 ec 0c             	sub    $0xc,%esp
801047a8:	68 e4 97 10 80       	push   $0x801097e4
801047ad:	e8 de bb ff ff       	call   80100390 <panic>
    return -1;
801047b2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047b7:	eb b2                	jmp    8010476b <fork+0x23b>
    kfree(np->kstack);
801047b9:	8b b5 e0 f7 ff ff    	mov    -0x820(%ebp),%esi
801047bf:	83 ec 0c             	sub    $0xc,%esp
    return -1;
801047c2:	83 cb ff             	or     $0xffffffff,%ebx
    kfree(np->kstack);
801047c5:	ff 76 08             	pushl  0x8(%esi)
801047c8:	e8 93 e2 ff ff       	call   80102a60 <kfree>
    np->kstack = 0;
801047cd:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
801047d4:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
801047db:	83 c4 10             	add    $0x10,%esp
801047de:	eb 8b                	jmp    8010476b <fork+0x23b>

801047e0 <scheduler>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047e9:	e8 52 fa ff ff       	call   80104240 <mycpu>
801047ee:	8d 78 04             	lea    0x4(%eax),%edi
801047f1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047f3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047fa:	00 00 00 
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104800:	fb                   	sti    
    acquire(&ptable.lock);
80104801:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104804:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
80104809:	68 00 61 18 80       	push   $0x80186100
8010480e:	e8 7d 09 00 00       	call   80105190 <acquire>
80104813:	83 c4 10             	add    $0x10,%esp
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104820:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104824:	75 33                	jne    80104859 <scheduler+0x79>
      switchuvm(p);
80104826:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104829:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010482f:	53                   	push   %ebx
80104830:	e8 4b 2f 00 00       	call   80107780 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104835:	58                   	pop    %eax
80104836:	5a                   	pop    %edx
80104837:	ff 73 1c             	pushl  0x1c(%ebx)
8010483a:	57                   	push   %edi
      p->state = RUNNING;
8010483b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104842:	e8 94 0c 00 00       	call   801054db <swtch>
      switchkvm();
80104847:	e8 14 2f 00 00       	call   80107760 <switchkvm>
      c->proc = 0;
8010484c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104853:	00 00 00 
80104856:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104859:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010485f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104865:	72 b9                	jb     80104820 <scheduler+0x40>
    release(&ptable.lock);
80104867:	83 ec 0c             	sub    $0xc,%esp
8010486a:	68 00 61 18 80       	push   $0x80186100
8010486f:	e8 dc 09 00 00       	call   80105250 <release>
    sti();
80104874:	83 c4 10             	add    $0x10,%esp
80104877:	eb 87                	jmp    80104800 <scheduler+0x20>
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104880 <sched>:
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
  pushcli();
80104885:	e8 36 08 00 00       	call   801050c0 <pushcli>
  c = mycpu();
8010488a:	e8 b1 f9 ff ff       	call   80104240 <mycpu>
  p = c->proc;
8010488f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104895:	e8 66 08 00 00       	call   80105100 <popcli>
  if(!holding(&ptable.lock))
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	68 00 61 18 80       	push   $0x80186100
801048a2:	e8 b9 08 00 00       	call   80105160 <holding>
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	85 c0                	test   %eax,%eax
801048ac:	74 4f                	je     801048fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801048ae:	e8 8d f9 ff ff       	call   80104240 <mycpu>
801048b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801048ba:	75 68                	jne    80104924 <sched+0xa4>
  if(p->state == RUNNING)
801048bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048c0:	74 55                	je     80104917 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048c2:	9c                   	pushf  
801048c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048c4:	f6 c4 02             	test   $0x2,%ah
801048c7:	75 41                	jne    8010490a <sched+0x8a>
  intena = mycpu()->intena;
801048c9:	e8 72 f9 ff ff       	call   80104240 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048d7:	e8 64 f9 ff ff       	call   80104240 <mycpu>
801048dc:	83 ec 08             	sub    $0x8,%esp
801048df:	ff 70 04             	pushl  0x4(%eax)
801048e2:	53                   	push   %ebx
801048e3:	e8 f3 0b 00 00       	call   801054db <swtch>
  mycpu()->intena = intena;
801048e8:	e8 53 f9 ff ff       	call   80104240 <mycpu>
}
801048ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret    
    panic("sched ptable.lock");
801048fd:	83 ec 0c             	sub    $0xc,%esp
80104900:	68 1b 97 10 80       	push   $0x8010971b
80104905:	e8 86 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	68 47 97 10 80       	push   $0x80109747
80104912:	e8 79 ba ff ff       	call   80100390 <panic>
    panic("sched running");
80104917:	83 ec 0c             	sub    $0xc,%esp
8010491a:	68 39 97 10 80       	push   $0x80109739
8010491f:	e8 6c ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	68 2d 97 10 80       	push   $0x8010972d
8010492c:	e8 5f ba ff ff       	call   80100390 <panic>
80104931:	eb 0d                	jmp    80104940 <exit>
80104933:	90                   	nop
80104934:	90                   	nop
80104935:	90                   	nop
80104936:	90                   	nop
80104937:	90                   	nop
80104938:	90                   	nop
80104939:	90                   	nop
8010493a:	90                   	nop
8010493b:	90                   	nop
8010493c:	90                   	nop
8010493d:	90                   	nop
8010493e:	90                   	nop
8010493f:	90                   	nop

80104940 <exit>:
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
80104946:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104949:	e8 72 07 00 00       	call   801050c0 <pushcli>
  c = mycpu();
8010494e:	e8 ed f8 ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104953:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104959:	e8 a2 07 00 00       	call   80105100 <popcli>
  if(curproc == initproc)
8010495e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104964:	8d 73 28             	lea    0x28(%ebx),%esi
80104967:	8d 7b 68             	lea    0x68(%ebx),%edi
8010496a:	0f 84 22 01 00 00    	je     80104a92 <exit+0x152>
    if(curproc->ofile[fd]){
80104970:	8b 06                	mov    (%esi),%eax
80104972:	85 c0                	test   %eax,%eax
80104974:	74 12                	je     80104988 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104976:	83 ec 0c             	sub    $0xc,%esp
80104979:	50                   	push   %eax
8010497a:	e8 81 c8 ff ff       	call   80101200 <fileclose>
      curproc->ofile[fd] = 0;
8010497f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010498b:	39 fe                	cmp    %edi,%esi
8010498d:	75 e1                	jne    80104970 <exit+0x30>
  begin_op();
8010498f:	e8 cc eb ff ff       	call   80103560 <begin_op>
  iput(curproc->cwd);
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	ff 73 68             	pushl  0x68(%ebx)
8010499a:	e8 d1 d1 ff ff       	call   80101b70 <iput>
  end_op();
8010499f:	e8 2c ec ff ff       	call   801035d0 <end_op>
  if(curproc->pid > 2) {
801049a4:	83 c4 10             	add    $0x10,%esp
801049a7:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
801049ab:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
801049b2:	0f 8f b9 00 00 00    	jg     80104a71 <exit+0x131>
  acquire(&ptable.lock);
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 00 61 18 80       	push   $0x80186100
801049c0:	e8 cb 07 00 00       	call   80105190 <acquire>
  wakeup1(curproc->parent);
801049c5:	8b 53 14             	mov    0x14(%ebx),%edx
801049c8:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049cb:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049d0:	eb 12                	jmp    801049e4 <exit+0xa4>
801049d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d8:	05 30 04 00 00       	add    $0x430,%eax
801049dd:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049e2:	73 1e                	jae    80104a02 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
801049e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049e8:	75 ee                	jne    801049d8 <exit+0x98>
801049ea:	3b 50 20             	cmp    0x20(%eax),%edx
801049ed:	75 e9                	jne    801049d8 <exit+0x98>
      p->state = RUNNABLE;
801049ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049f6:	05 30 04 00 00       	add    $0x430,%eax
801049fb:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a00:	72 e2                	jb     801049e4 <exit+0xa4>
      p->parent = initproc;
80104a02:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a08:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104a0d:	eb 0f                	jmp    80104a1e <exit+0xde>
80104a0f:	90                   	nop
80104a10:	81 c2 30 04 00 00    	add    $0x430,%edx
80104a16:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104a1c:	73 3a                	jae    80104a58 <exit+0x118>
    if(p->parent == curproc){
80104a1e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104a21:	75 ed                	jne    80104a10 <exit+0xd0>
      if(p->state == ZOMBIE)
80104a23:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104a27:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104a2a:	75 e4                	jne    80104a10 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a2c:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104a31:	eb 11                	jmp    80104a44 <exit+0x104>
80104a33:	90                   	nop
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a38:	05 30 04 00 00       	add    $0x430,%eax
80104a3d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a42:	73 cc                	jae    80104a10 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104a44:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a48:	75 ee                	jne    80104a38 <exit+0xf8>
80104a4a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a4d:	75 e9                	jne    80104a38 <exit+0xf8>
      p->state = RUNNABLE;
80104a4f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a56:	eb e0                	jmp    80104a38 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a58:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a5f:	e8 1c fe ff ff       	call   80104880 <sched>
  panic("zombie exit");
80104a64:	83 ec 0c             	sub    $0xc,%esp
80104a67:	68 68 97 10 80       	push   $0x80109768
80104a6c:	e8 1f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a71:	83 ec 0c             	sub    $0xc,%esp
80104a74:	53                   	push   %ebx
80104a75:	e8 f6 d8 ff ff       	call   80102370 <removeSwapFile>
80104a7a:	83 c4 10             	add    $0x10,%esp
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	0f 84 33 ff ff ff    	je     801049b8 <exit+0x78>
      panic("exit: error deleting swap file");
80104a85:	83 ec 0c             	sub    $0xc,%esp
80104a88:	68 0c 98 10 80       	push   $0x8010980c
80104a8d:	e8 fe b8 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a92:	83 ec 0c             	sub    $0xc,%esp
80104a95:	68 5b 97 10 80       	push   $0x8010975b
80104a9a:	e8 f1 b8 ff ff       	call   80100390 <panic>
80104a9f:	90                   	nop

80104aa0 <yield>:
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104aa7:	68 00 61 18 80       	push   $0x80186100
80104aac:	e8 df 06 00 00       	call   80105190 <acquire>
  pushcli();
80104ab1:	e8 0a 06 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104ab6:	e8 85 f7 ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104abb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ac1:	e8 3a 06 00 00       	call   80105100 <popcli>
  myproc()->state = RUNNABLE;
80104ac6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104acd:	e8 ae fd ff ff       	call   80104880 <sched>
  release(&ptable.lock);
80104ad2:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104ad9:	e8 72 07 00 00       	call   80105250 <release>
}
80104ade:	83 c4 10             	add    $0x10,%esp
80104ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae4:	c9                   	leave  
80104ae5:	c3                   	ret    
80104ae6:	8d 76 00             	lea    0x0(%esi),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <sleep>:
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	83 ec 0c             	sub    $0xc,%esp
80104af9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104aff:	e8 bc 05 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104b04:	e8 37 f7 ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104b09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b0f:	e8 ec 05 00 00       	call   80105100 <popcli>
  if(p == 0)
80104b14:	85 db                	test   %ebx,%ebx
80104b16:	0f 84 87 00 00 00    	je     80104ba3 <sleep+0xb3>
  if(lk == 0)
80104b1c:	85 f6                	test   %esi,%esi
80104b1e:	74 76                	je     80104b96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b20:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104b26:	74 50                	je     80104b78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 00 61 18 80       	push   $0x80186100
80104b30:	e8 5b 06 00 00       	call   80105190 <acquire>
    release(lk);
80104b35:	89 34 24             	mov    %esi,(%esp)
80104b38:	e8 13 07 00 00       	call   80105250 <release>
  p->chan = chan;
80104b3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b47:	e8 34 fd ff ff       	call   80104880 <sched>
  p->chan = 0;
80104b4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b53:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b5a:	e8 f1 06 00 00       	call   80105250 <release>
    acquire(lk);
80104b5f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b62:	83 c4 10             	add    $0x10,%esp
}
80104b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5f                   	pop    %edi
80104b6b:	5d                   	pop    %ebp
    acquire(lk);
80104b6c:	e9 1f 06 00 00       	jmp    80105190 <acquire>
80104b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b82:	e8 f9 fc ff ff       	call   80104880 <sched>
  p->chan = 0;
80104b87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b91:	5b                   	pop    %ebx
80104b92:	5e                   	pop    %esi
80104b93:	5f                   	pop    %edi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret    
    panic("sleep without lk");
80104b96:	83 ec 0c             	sub    $0xc,%esp
80104b99:	68 7a 97 10 80       	push   $0x8010977a
80104b9e:	e8 ed b7 ff ff       	call   80100390 <panic>
    panic("sleep");
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	68 74 97 10 80       	push   $0x80109774
80104bab:	e8 e0 b7 ff ff       	call   80100390 <panic>

80104bb0 <wait>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  pushcli();
80104bb5:	e8 06 05 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104bba:	e8 81 f6 ff ff       	call   80104240 <mycpu>
  p = c->proc;
80104bbf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bc5:	e8 36 05 00 00       	call   80105100 <popcli>
  acquire(&ptable.lock);
80104bca:	83 ec 0c             	sub    $0xc,%esp
80104bcd:	68 00 61 18 80       	push   $0x80186100
80104bd2:	e8 b9 05 00 00       	call   80105190 <acquire>
80104bd7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bdc:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104be1:	eb 13                	jmp    80104bf6 <wait+0x46>
80104be3:	90                   	nop
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bee:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bf4:	73 1e                	jae    80104c14 <wait+0x64>
      if(p->parent != curproc)
80104bf6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104bf9:	75 ed                	jne    80104be8 <wait+0x38>
      if(p->state == ZOMBIE){
80104bfb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104bff:	74 3f                	je     80104c40 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c01:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104c07:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c0c:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104c12:	72 e2                	jb     80104bf6 <wait+0x46>
    if(!havekids || curproc->killed){
80104c14:	85 c0                	test   %eax,%eax
80104c16:	0f 84 f3 00 00 00    	je     80104d0f <wait+0x15f>
80104c1c:	8b 46 24             	mov    0x24(%esi),%eax
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	0f 85 e8 00 00 00    	jne    80104d0f <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c27:	83 ec 08             	sub    $0x8,%esp
80104c2a:	68 00 61 18 80       	push   $0x80186100
80104c2f:	56                   	push   %esi
80104c30:	e8 bb fe ff ff       	call   80104af0 <sleep>
    havekids = 0;
80104c35:	83 c4 10             	add    $0x10,%esp
80104c38:	eb a0                	jmp    80104bda <wait+0x2a>
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104c46:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c49:	e8 12 de ff ff       	call   80102a60 <kfree>
        freevm(p->pgdir); // panic: kfree
80104c4e:	5a                   	pop    %edx
80104c4f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c59:	e8 02 31 00 00       	call   80107d60 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c5e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c64:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c67:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c6e:	68 c0 01 00 00       	push   $0x1c0
80104c73:	6a 00                	push   $0x0
80104c75:	50                   	push   %eax
        p->parent = 0;
80104c76:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c7d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c81:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c88:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c8f:	00 00 00 
        p->swapFile = 0;
80104c92:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c99:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104ca0:	00 00 00 
        p->free_tail = 0;
80104ca3:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104caa:	00 00 00 
        p->queue_head = 0;
80104cad:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104cb4:	00 00 00 
        p->queue_tail = 0;
80104cb7:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104cbe:	00 00 00 
        p->numswappages = 0;
80104cc1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104cc8:	00 00 00 
        p-> nummemorypages = 0;
80104ccb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104cd2:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104cd5:	e8 c6 05 00 00       	call   801052a0 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104cda:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104ce0:	83 c4 0c             	add    $0xc,%esp
80104ce3:	68 c0 01 00 00       	push   $0x1c0
80104ce8:	6a 00                	push   $0x0
80104cea:	50                   	push   %eax
80104ceb:	e8 b0 05 00 00       	call   801052a0 <memset>
        release(&ptable.lock);
80104cf0:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104cf7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104cfe:	e8 4d 05 00 00       	call   80105250 <release>
        return pid;
80104d03:	83 c4 10             	add    $0x10,%esp
}
80104d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d09:	89 f0                	mov    %esi,%eax
80104d0b:	5b                   	pop    %ebx
80104d0c:	5e                   	pop    %esi
80104d0d:	5d                   	pop    %ebp
80104d0e:	c3                   	ret    
      release(&ptable.lock);
80104d0f:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104d12:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104d17:	68 00 61 18 80       	push   $0x80186100
80104d1c:	e8 2f 05 00 00       	call   80105250 <release>
      return -1;
80104d21:	83 c4 10             	add    $0x10,%esp
80104d24:	eb e0                	jmp    80104d06 <wait+0x156>
80104d26:	8d 76 00             	lea    0x0(%esi),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 10             	sub    $0x10,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104d3a:	68 00 61 18 80       	push   $0x80186100
80104d3f:	e8 4c 04 00 00       	call   80105190 <acquire>
80104d44:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d47:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d4c:	eb 0e                	jmp    80104d5c <wakeup+0x2c>
80104d4e:	66 90                	xchg   %ax,%ax
80104d50:	05 30 04 00 00       	add    $0x430,%eax
80104d55:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d5a:	73 1e                	jae    80104d7a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d60:	75 ee                	jne    80104d50 <wakeup+0x20>
80104d62:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d65:	75 e9                	jne    80104d50 <wakeup+0x20>
      p->state = RUNNABLE;
80104d67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d6e:	05 30 04 00 00       	add    $0x430,%eax
80104d73:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d78:	72 e2                	jb     80104d5c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d7a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d84:	c9                   	leave  
  release(&ptable.lock);
80104d85:	e9 c6 04 00 00       	jmp    80105250 <release>
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 10             	sub    $0x10,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d9a:	68 00 61 18 80       	push   $0x80186100
80104d9f:	e8 ec 03 00 00       	call   80105190 <acquire>
80104da4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da7:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104dac:	eb 0e                	jmp    80104dbc <kill+0x2c>
80104dae:	66 90                	xchg   %ax,%ax
80104db0:	05 30 04 00 00       	add    $0x430,%eax
80104db5:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104dba:	73 34                	jae    80104df0 <kill+0x60>
    if(p->pid == pid){
80104dbc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dbf:	75 ef                	jne    80104db0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dc1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104dc5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104dcc:	75 07                	jne    80104dd5 <kill+0x45>
        p->state = RUNNABLE;
80104dce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dd5:	83 ec 0c             	sub    $0xc,%esp
80104dd8:	68 00 61 18 80       	push   $0x80186100
80104ddd:	e8 6e 04 00 00       	call   80105250 <release>
      return 0;
80104de2:	83 c4 10             	add    $0x10,%esp
80104de5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dea:	c9                   	leave  
80104deb:	c3                   	ret    
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	68 00 61 18 80       	push   $0x80186100
80104df8:	e8 53 04 00 00       	call   80105250 <release>
  return -1;
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
80104e16:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e19:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104e1e:	83 ec 3c             	sub    $0x3c,%esp
80104e21:	eb 27                	jmp    80104e4a <procdump+0x3a>
80104e23:	90                   	nop
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	68 c7 9d 10 80       	push   $0x80109dc7
80104e30:	e8 2b b8 ff ff       	call   80100660 <cprintf>
80104e35:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e38:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104e3e:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104e44:	0f 83 a6 00 00 00    	jae    80104ef0 <procdump+0xe0>
    if(p->state == UNUSED)
80104e4a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	74 e7                	je     80104e38 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e51:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104e54:	ba 8b 97 10 80       	mov    $0x8010978b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e59:	77 11                	ja     80104e6c <procdump+0x5c>
80104e5b:	8b 14 85 94 98 10 80 	mov    -0x7fef676c(,%eax,4),%edx
      state = "???";
80104e62:	b8 8b 97 10 80       	mov    $0x8010978b,%eax
80104e67:	85 d2                	test   %edx,%edx
80104e69:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d>  <state: %s>  <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>",
80104e6c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e6f:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104e75:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104e7b:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104e81:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104e87:	50                   	push   %eax
80104e88:	52                   	push   %edx
80104e89:	ff 73 10             	pushl  0x10(%ebx)
80104e8c:	68 2c 98 10 80       	push   $0x8010982c
80104e91:	e8 ca b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104e96:	83 c4 20             	add    $0x20,%esp
80104e99:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104e9d:	75 89                	jne    80104e28 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e9f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104ea2:	83 ec 08             	sub    $0x8,%esp
80104ea5:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ea8:	50                   	push   %eax
80104ea9:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104eac:	8b 40 0c             	mov    0xc(%eax),%eax
80104eaf:	83 c0 08             	add    $0x8,%eax
80104eb2:	50                   	push   %eax
80104eb3:	e8 b8 01 00 00       	call   80105070 <getcallerpcs>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	90                   	nop
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104ec0:	8b 17                	mov    (%edi),%edx
80104ec2:	85 d2                	test   %edx,%edx
80104ec4:	0f 84 5e ff ff ff    	je     80104e28 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104eca:	83 ec 08             	sub    $0x8,%esp
80104ecd:	83 c7 04             	add    $0x4,%edi
80104ed0:	52                   	push   %edx
80104ed1:	68 e1 90 10 80       	push   $0x801090e1
80104ed6:	e8 85 b7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104edb:	83 c4 10             	add    $0x10,%esp
80104ede:	39 fe                	cmp    %edi,%esi
80104ee0:	75 de                	jne    80104ec0 <procdump+0xb0>
80104ee2:	e9 41 ff ff ff       	jmp    80104e28 <procdump+0x18>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef3:	5b                   	pop    %ebx
80104ef4:	5e                   	pop    %esi
80104ef5:	5f                   	pop    %edi
80104ef6:	5d                   	pop    %ebp
80104ef7:	c3                   	ret    
80104ef8:	90                   	nop
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f00 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104f06:	68 00 61 18 80       	push   $0x80186100
80104f0b:	e8 80 02 00 00       	call   80105190 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104f10:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104f17:	e8 34 03 00 00       	call   80105250 <release>
  return sum;
80104f1c:	31 c0                	xor    %eax,%eax
80104f1e:	c9                   	leave  
80104f1f:	c3                   	ret    

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
80104f2a:	68 ac 98 10 80       	push   $0x801098ac
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
80104f85:	e8 66 fb ff ff       	call   80104af0 <sleep>
  while (lk->locked) {
80104f8a:	8b 03                	mov    (%ebx),%eax
80104f8c:	83 c4 10             	add    $0x10,%esp
80104f8f:	85 c0                	test   %eax,%eax
80104f91:	75 ed                	jne    80104f80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f99:	e8 42 f3 ff ff       	call   801042e0 <myproc>
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
80104fe4:	e8 47 fd ff ff       	call   80104d30 <wakeup>
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
80105023:	e8 b8 f2 ff ff       	call   801042e0 <myproc>
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
801050ca:	e8 71 f1 ff ff       	call   80104240 <mycpu>
801050cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050d5:	85 c0                	test   %eax,%eax
801050d7:	75 11                	jne    801050ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801050d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801050df:	e8 5c f1 ff ff       	call   80104240 <mycpu>
801050e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801050ea:	e8 51 f1 ff ff       	call   80104240 <mycpu>
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
8010510d:	e8 2e f1 ff ff       	call   80104240 <mycpu>
80105112:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105119:	78 34                	js     8010514f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010511b:	e8 20 f1 ff ff       	call   80104240 <mycpu>
80105120:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105126:	85 d2                	test   %edx,%edx
80105128:	74 06                	je     80105130 <popcli+0x30>
    sti();
}
8010512a:	c9                   	leave  
8010512b:	c3                   	ret    
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105130:	e8 0b f1 ff ff       	call   80104240 <mycpu>
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
80105145:	68 b7 98 10 80       	push   $0x801098b7
8010514a:	e8 41 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010514f:	83 ec 0c             	sub    $0xc,%esp
80105152:	68 ce 98 10 80       	push   $0x801098ce
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
80105178:	e8 c3 f0 ff ff       	call   80104240 <mycpu>
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
801051d4:	e8 67 f0 ff ff       	call   80104240 <mycpu>
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
80105237:	68 d5 98 10 80       	push   $0x801098d5
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
8010528c:	68 dd 98 10 80       	push   $0x801098dd
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
801054fa:	e8 e1 ed ff ff       	call   801042e0 <myproc>

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
8010553a:	e8 a1 ed ff ff       	call   801042e0 <myproc>

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
801055a5:	e8 36 ed ff ff       	call   801042e0 <myproc>
801055aa:	8b 40 18             	mov    0x18(%eax),%eax
801055ad:	8b 55 08             	mov    0x8(%ebp),%edx
801055b0:	8b 40 44             	mov    0x44(%eax),%eax
801055b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055b6:	e8 25 ed ff ff       	call   801042e0 <myproc>
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
801055fb:	e8 e0 ec ff ff       	call   801042e0 <myproc>
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
[SYS_getTotalFreePages]    sys_getTotalFreePages
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
80105697:	e8 44 ec ff ff       	call   801042e0 <myproc>
8010569c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010569e:	8b 40 18             	mov    0x18(%eax),%eax
801056a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801056a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056a7:	83 fa 16             	cmp    $0x16,%edx
801056aa:	77 1c                	ja     801056c8 <syscall+0x38>
801056ac:	8b 14 85 20 99 10 80 	mov    -0x7fef66e0(,%eax,4),%edx
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
801056d0:	68 e5 98 10 80       	push   $0x801098e5
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
80105714:	e8 c7 eb ff ff       	call   801042e0 <myproc>
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
8010575b:	e8 80 eb ff ff       	call   801042e0 <myproc>
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
80105782:	e8 29 ba ff ff       	call   801011b0 <filedup>
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
801057fd:	e8 1e bb ff ff       	call   80101320 <fileread>
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
8010586d:	e8 3e bb ff ff       	call   801013b0 <filewrite>
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
801058a5:	e8 36 ea ff ff       	call   801042e0 <myproc>
801058aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801058ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801058b7:	00 
  fileclose(f);
801058b8:	ff 75 f4             	pushl  -0xc(%ebp)
801058bb:	e8 40 b9 ff ff       	call   80101200 <fileclose>
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
80105914:	e8 b7 b9 ff ff       	call   801012d0 <filestat>
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
80105968:	e8 f3 db ff ff       	call   80103560 <begin_op>
  if((ip = namei(old)) == 0){
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	ff 75 d4             	pushl  -0x2c(%ebp)
80105973:	e8 28 c9 ff ff       	call   801022a0 <namei>
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
80105989:	e8 b2 c0 ff ff       	call   80101a40 <ilock>
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
801059a8:	e8 e3 bf ff ff       	call   80101990 <iupdate>
  iunlock(ip);
801059ad:	89 1c 24             	mov    %ebx,(%esp)
801059b0:	e8 6b c1 ff ff       	call   80101b20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801059b5:	58                   	pop    %eax
801059b6:	5a                   	pop    %edx
801059b7:	57                   	push   %edi
801059b8:	ff 75 d0             	pushl  -0x30(%ebp)
801059bb:	e8 00 c9 ff ff       	call   801022c0 <nameiparent>
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	85 c0                	test   %eax,%eax
801059c5:	89 c6                	mov    %eax,%esi
801059c7:	74 5b                	je     80105a24 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801059c9:	83 ec 0c             	sub    $0xc,%esp
801059cc:	50                   	push   %eax
801059cd:	e8 6e c0 ff ff       	call   80101a40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	8b 03                	mov    (%ebx),%eax
801059d7:	39 06                	cmp    %eax,(%esi)
801059d9:	75 3d                	jne    80105a18 <sys_link+0xe8>
801059db:	83 ec 04             	sub    $0x4,%esp
801059de:	ff 73 04             	pushl  0x4(%ebx)
801059e1:	57                   	push   %edi
801059e2:	56                   	push   %esi
801059e3:	e8 f8 c7 ff ff       	call   801021e0 <dirlink>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	78 29                	js     80105a18 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801059ef:	83 ec 0c             	sub    $0xc,%esp
801059f2:	56                   	push   %esi
801059f3:	e8 d8 c2 ff ff       	call   80101cd0 <iunlockput>
  iput(ip);
801059f8:	89 1c 24             	mov    %ebx,(%esp)
801059fb:	e8 70 c1 ff ff       	call   80101b70 <iput>

  end_op();
80105a00:	e8 cb db ff ff       	call   801035d0 <end_op>

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
80105a1c:	e8 af c2 ff ff       	call   80101cd0 <iunlockput>
    goto bad;
80105a21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	53                   	push   %ebx
80105a28:	e8 13 c0 ff ff       	call   80101a40 <ilock>
  ip->nlink--;
80105a2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a32:	89 1c 24             	mov    %ebx,(%esp)
80105a35:	e8 56 bf ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
80105a3a:	89 1c 24             	mov    %ebx,(%esp)
80105a3d:	e8 8e c2 ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105a42:	e8 89 db ff ff       	call   801035d0 <end_op>
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
80105a5b:	e8 70 c2 ff ff       	call   80101cd0 <iunlockput>
    end_op();
80105a60:	e8 6b db ff ff       	call   801035d0 <end_op>
    return -1;
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6d:	eb 9b                	jmp    80105a0a <sys_link+0xda>
    end_op();
80105a6f:	e8 5c db ff ff       	call   801035d0 <end_op>
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
80105aad:	e8 6e c2 ff ff       	call   80101d20 <readi>
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
80105ae0:	68 80 99 10 80       	push   $0x80109980
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
80105b12:	e8 49 da ff ff       	call   80103560 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b17:	83 ec 08             	sub    $0x8,%esp
80105b1a:	53                   	push   %ebx
80105b1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b1e:	e8 9d c7 ff ff       	call   801022c0 <nameiparent>
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
80105b34:	e8 07 bf ff ff       	call   80101a40 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b39:	58                   	pop    %eax
80105b3a:	5a                   	pop    %edx
80105b3b:	68 73 92 10 80       	push   $0x80109273
80105b40:	53                   	push   %ebx
80105b41:	e8 0a c4 ff ff       	call   80101f50 <namecmp>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	0f 84 d7 00 00 00    	je     80105c28 <sys_unlink+0x138>
80105b51:	83 ec 08             	sub    $0x8,%esp
80105b54:	68 72 92 10 80       	push   $0x80109272
80105b59:	53                   	push   %ebx
80105b5a:	e8 f1 c3 ff ff       	call   80101f50 <namecmp>
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
80105b73:	e8 f8 c3 ff ff       	call   80101f70 <dirlookup>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c3                	mov    %eax,%ebx
80105b7f:	0f 84 a3 00 00 00    	je     80105c28 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105b85:	83 ec 0c             	sub    $0xc,%esp
80105b88:	50                   	push   %eax
80105b89:	e8 b2 be ff ff       	call   80101a40 <ilock>

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
80105bba:	e8 61 c2 ff ff       	call   80101e20 <writei>
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
80105bd6:	e8 f5 c0 ff ff       	call   80101cd0 <iunlockput>

  ip->nlink--;
80105bdb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105be0:	89 1c 24             	mov    %ebx,(%esp)
80105be3:	e8 a8 bd ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
80105be8:	89 1c 24             	mov    %ebx,(%esp)
80105beb:	e8 e0 c0 ff ff       	call   80101cd0 <iunlockput>

  end_op();
80105bf0:	e8 db d9 ff ff       	call   801035d0 <end_op>

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
80105c1c:	e8 af c0 ff ff       	call   80101cd0 <iunlockput>
    goto bad;
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	56                   	push   %esi
80105c2c:	e8 9f c0 ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105c31:	e8 9a d9 ff ff       	call   801035d0 <end_op>
  return -1;
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3e:	eb ba                	jmp    80105bfa <sys_unlink+0x10a>
    dp->nlink--;
80105c40:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c45:	83 ec 0c             	sub    $0xc,%esp
80105c48:	56                   	push   %esi
80105c49:	e8 42 bd ff ff       	call   80101990 <iupdate>
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	e9 7c ff ff ff       	jmp    80105bd2 <sys_unlink+0xe2>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c65:	eb 93                	jmp    80105bfa <sys_unlink+0x10a>
    end_op();
80105c67:	e8 64 d9 ff ff       	call   801035d0 <end_op>
    return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	eb 87                	jmp    80105bfa <sys_unlink+0x10a>
    panic("unlink: writei");
80105c73:	83 ec 0c             	sub    $0xc,%esp
80105c76:	68 87 92 10 80       	push   $0x80109287
80105c7b:	e8 10 a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 75 92 10 80       	push   $0x80109275
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
80105cb2:	e8 09 c6 ff ff       	call   801022c0 <nameiparent>
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	0f 84 4e 01 00 00    	je     80105e10 <create+0x180>
    return 0;
  ilock(dp);
80105cc2:	83 ec 0c             	sub    $0xc,%esp
80105cc5:	89 c3                	mov    %eax,%ebx
80105cc7:	50                   	push   %eax
80105cc8:	e8 73 bd ff ff       	call   80101a40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105ccd:	83 c4 0c             	add    $0xc,%esp
80105cd0:	6a 00                	push   $0x0
80105cd2:	56                   	push   %esi
80105cd3:	53                   	push   %ebx
80105cd4:	e8 97 c2 ff ff       	call   80101f70 <dirlookup>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	85 c0                	test   %eax,%eax
80105cde:	89 c7                	mov    %eax,%edi
80105ce0:	74 3e                	je     80105d20 <create+0x90>
    iunlockput(dp);
80105ce2:	83 ec 0c             	sub    $0xc,%esp
80105ce5:	53                   	push   %ebx
80105ce6:	e8 e5 bf ff ff       	call   80101cd0 <iunlockput>
    ilock(ip);
80105ceb:	89 3c 24             	mov    %edi,(%esp)
80105cee:	e8 4d bd ff ff       	call   80101a40 <ilock>
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
80105d2a:	e8 a1 bb ff ff       	call   801018d0 <ialloc>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	89 c7                	mov    %eax,%edi
80105d36:	0f 84 e8 00 00 00    	je     80105e24 <create+0x194>
  ilock(ip);
80105d3c:	83 ec 0c             	sub    $0xc,%esp
80105d3f:	50                   	push   %eax
80105d40:	e8 fb bc ff ff       	call   80101a40 <ilock>
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
80105d61:	e8 2a bc ff ff       	call   80101990 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d6e:	74 50                	je     80105dc0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105d70:	83 ec 04             	sub    $0x4,%esp
80105d73:	ff 77 04             	pushl  0x4(%edi)
80105d76:	56                   	push   %esi
80105d77:	53                   	push   %ebx
80105d78:	e8 63 c4 ff ff       	call   801021e0 <dirlink>
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	85 c0                	test   %eax,%eax
80105d82:	0f 88 8f 00 00 00    	js     80105e17 <create+0x187>
  iunlockput(dp);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	53                   	push   %ebx
80105d8c:	e8 3f bf ff ff       	call   80101cd0 <iunlockput>
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
80105da6:	e8 25 bf ff ff       	call   80101cd0 <iunlockput>
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
80105dc9:	e8 c2 bb ff ff       	call   80101990 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105dce:	83 c4 0c             	add    $0xc,%esp
80105dd1:	ff 77 04             	pushl  0x4(%edi)
80105dd4:	68 73 92 10 80       	push   $0x80109273
80105dd9:	57                   	push   %edi
80105dda:	e8 01 c4 ff ff       	call   801021e0 <dirlink>
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	85 c0                	test   %eax,%eax
80105de4:	78 1c                	js     80105e02 <create+0x172>
80105de6:	83 ec 04             	sub    $0x4,%esp
80105de9:	ff 73 04             	pushl  0x4(%ebx)
80105dec:	68 72 92 10 80       	push   $0x80109272
80105df1:	57                   	push   %edi
80105df2:	e8 e9 c3 ff ff       	call   801021e0 <dirlink>
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	0f 89 6e ff ff ff    	jns    80105d70 <create+0xe0>
      panic("create dots");
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	68 a1 99 10 80       	push   $0x801099a1
80105e0a:	e8 81 a5 ff ff       	call   80100390 <panic>
80105e0f:	90                   	nop
    return 0;
80105e10:	31 ff                	xor    %edi,%edi
80105e12:	e9 f5 fe ff ff       	jmp    80105d0c <create+0x7c>
    panic("create: dirlink");
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	68 ad 99 10 80       	push   $0x801099ad
80105e1f:	e8 6c a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105e24:	83 ec 0c             	sub    $0xc,%esp
80105e27:	68 92 99 10 80       	push   $0x80109992
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
80105e78:	e8 e3 d6 ff ff       	call   80103560 <begin_op>

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
80105e8d:	e8 0e c4 ff ff       	call   801022a0 <namei>
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
80105ea3:	e8 98 bb ff ff       	call   80101a40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ea8:	83 c4 10             	add    $0x10,%esp
80105eab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105eb0:	0f 84 aa 00 00 00    	je     80105f60 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105eb6:	e8 85 b2 ff ff       	call   80101140 <filealloc>
80105ebb:	85 c0                	test   %eax,%eax
80105ebd:	89 c7                	mov    %eax,%edi
80105ebf:	0f 84 a6 00 00 00    	je     80105f6b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105ec5:	e8 16 e4 ff ff       	call   801042e0 <myproc>
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
80105eec:	e8 2f bc ff ff       	call   80101b20 <iunlock>
  end_op();
80105ef1:	e8 da d6 ff ff       	call   801035d0 <end_op>

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
80105f4b:	e8 80 d6 ff ff       	call   801035d0 <end_op>
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
80105f6f:	e8 5c bd ff ff       	call   80101cd0 <iunlockput>
    end_op();
80105f74:	e8 57 d6 ff ff       	call   801035d0 <end_op>
    return -1;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f81:	eb 9a                	jmp    80105f1d <sys_open+0xdd>
80105f83:	90                   	nop
80105f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	57                   	push   %edi
80105f8c:	e8 6f b2 ff ff       	call   80101200 <fileclose>
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
80105fa6:	e8 b5 d5 ff ff       	call   80103560 <begin_op>
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
80105fd9:	e8 f2 bc ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105fde:	e8 ed d5 ff ff       	call   801035d0 <end_op>
  return 0;
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	31 c0                	xor    %eax,%eax
}
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105ff0:	e8 db d5 ff ff       	call   801035d0 <end_op>
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
80106006:	e8 55 d5 ff ff       	call   80103560 <begin_op>
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
80106069:	e8 62 bc ff ff       	call   80101cd0 <iunlockput>
  end_op();
8010606e:	e8 5d d5 ff ff       	call   801035d0 <end_op>
  return 0;
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	31 c0                	xor    %eax,%eax
}
80106078:	c9                   	leave  
80106079:	c3                   	ret    
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106080:	e8 4b d5 ff ff       	call   801035d0 <end_op>
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
80106098:	e8 43 e2 ff ff       	call   801042e0 <myproc>
8010609d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010609f:	e8 bc d4 ff ff       	call   80103560 <begin_op>
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
801060bf:	e8 dc c1 ff ff       	call   801022a0 <namei>
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
801060d1:	e8 6a b9 ff ff       	call   80101a40 <ilock>
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
801060e4:	e8 37 ba ff ff       	call   80101b20 <iunlock>
  iput(curproc->cwd);
801060e9:	58                   	pop    %eax
801060ea:	ff 76 68             	pushl  0x68(%esi)
801060ed:	e8 7e ba ff ff       	call   80101b70 <iput>
  end_op();
801060f2:	e8 d9 d4 ff ff       	call   801035d0 <end_op>
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
80106114:	e8 b7 bb ff ff       	call   80101cd0 <iunlockput>
    end_op();
80106119:	e8 b2 d4 ff ff       	call   801035d0 <end_op>
    return -1;
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106126:	eb d7                	jmp    801060ff <sys_chdir+0x6f>
80106128:	90                   	nop
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106130:	e8 9b d4 ff ff       	call   801035d0 <end_op>
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
8010621b:	e8 50 aa ff ff       	call   80100c70 <exec>
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
8010625c:	e8 9f d9 ff ff       	call   80103c00 <pipealloc>
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
80106271:	e8 6a e0 ff ff       	call   801042e0 <myproc>
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
8010629a:	e8 41 e0 ff ff       	call   801042e0 <myproc>
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
801062d8:	e8 03 e0 ff ff       	call   801042e0 <myproc>
801062dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801062e4:	00 
801062e5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 e0             	pushl  -0x20(%ebp)
801062ee:	e8 0d af ff ff       	call   80101200 <fileclose>
    fileclose(wf);
801062f3:	58                   	pop    %eax
801062f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801062f7:	e8 04 af ff ff       	call   80101200 <fileclose>
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
80106314:	e9 17 e2 ff ff       	jmp    80104530 <fork>
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <sys_exit>:

int
sys_exit(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 08             	sub    $0x8,%esp
  exit();
80106326:	e8 15 e6 ff ff       	call   80104940 <exit>
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
80106334:	e9 77 e8 ff ff       	jmp    80104bb0 <wait>
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
8010635e:	e8 2d ea ff ff       	call   80104d90 <kill>
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
80106386:	e8 55 df ff ff       	call   801042e0 <myproc>
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
801063a9:	e8 32 df ff ff       	call   801042e0 <myproc>
  if(growproc(n) < 0)
801063ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801063b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801063b3:	ff 75 f4             	pushl  -0xc(%ebp)
801063b6:	e8 45 e0 ff ff       	call   80104400 <growproc>
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
80106400:	68 40 6d 19 80       	push   $0x80196d40
80106405:	e8 86 ed ff ff       	call   80105190 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010640a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106410:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
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
80106423:	68 40 6d 19 80       	push   $0x80196d40
80106428:	68 80 75 19 80       	push   $0x80197580
8010642d:	e8 be e6 ff ff       	call   80104af0 <sleep>
  while(ticks - ticks0 < n){
80106432:	a1 80 75 19 80       	mov    0x80197580,%eax
80106437:	83 c4 10             	add    $0x10,%esp
8010643a:	29 d8                	sub    %ebx,%eax
8010643c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010643f:	73 2f                	jae    80106470 <sys_sleep+0x90>
    if(myproc()->killed){
80106441:	e8 9a de ff ff       	call   801042e0 <myproc>
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 d3                	je     80106420 <sys_sleep+0x40>
      release(&tickslock);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 40 6d 19 80       	push   $0x80196d40
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
80106473:	68 40 6d 19 80       	push   $0x80196d40
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
80106497:	68 40 6d 19 80       	push   $0x80196d40
8010649c:	e8 ef ec ff ff       	call   80105190 <acquire>
  xticks = ticks;
801064a1:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
801064a7:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
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
801064c3:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801064c6:	e8 15 de ff ff       	call   801042e0 <myproc>
801064cb:	ba 10 00 00 00       	mov    $0x10,%edx
801064d0:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
801064d6:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801064d7:	89 d0                	mov    %edx,%eax
}
801064d9:	c3                   	ret    
801064da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064e0 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
801064e3:	5d                   	pop    %ebp
  return getTotalFreePages();
801064e4:	e9 17 ea ff ff       	jmp    80104f00 <getTotalFreePages>

801064e9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801064e9:	1e                   	push   %ds
  pushl %es
801064ea:	06                   	push   %es
  pushl %fs
801064eb:	0f a0                	push   %fs
  pushl %gs
801064ed:	0f a8                	push   %gs
  pushal
801064ef:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801064f0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801064f4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801064f6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801064f8:	54                   	push   %esp
  call trap
801064f9:	e8 c2 00 00 00       	call   801065c0 <trap>
  addl $4, %esp
801064fe:	83 c4 04             	add    $0x4,%esp

80106501 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106501:	61                   	popa   
  popl %gs
80106502:	0f a9                	pop    %gs
  popl %fs
80106504:	0f a1                	pop    %fs
  popl %es
80106506:	07                   	pop    %es
  popl %ds
80106507:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106508:	83 c4 08             	add    $0x8,%esp
  iret
8010650b:	cf                   	iret   
8010650c:	66 90                	xchg   %ax,%ax
8010650e:	66 90                	xchg   %ax,%ax

80106510 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106510:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106511:	31 c0                	xor    %eax,%eax
{
80106513:	89 e5                	mov    %esp,%ebp
80106515:	83 ec 08             	sub    $0x8,%esp
80106518:	90                   	nop
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106520:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106527:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
8010652e:	08 00 00 8e 
80106532:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
80106539:	80 
8010653a:	c1 ea 10             	shr    $0x10,%edx
8010653d:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
80106544:	80 
  for(i = 0; i < 256; i++)
80106545:	83 c0 01             	add    $0x1,%eax
80106548:	3d 00 01 00 00       	cmp    $0x100,%eax
8010654d:	75 d1                	jne    80106520 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010654f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106554:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106557:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
8010655e:	00 00 ef 
  initlock(&tickslock, "time");
80106561:	68 bd 99 10 80       	push   $0x801099bd
80106566:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010656b:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
80106571:	c1 e8 10             	shr    $0x10,%eax
80106574:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
8010657a:	e8 d1 ea ff ff       	call   80105050 <initlock>
}
8010657f:	83 c4 10             	add    $0x10,%esp
80106582:	c9                   	leave  
80106583:	c3                   	ret    
80106584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010658a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106590 <idtinit>:

void
idtinit(void)
{
80106590:	55                   	push   %ebp
  pd[0] = size-1;
80106591:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106596:	89 e5                	mov    %esp,%ebp
80106598:	83 ec 10             	sub    $0x10,%esp
8010659b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010659f:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
801065a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065a8:	c1 e8 10             	shr    $0x10,%eax
801065ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    
801065b7:	89 f6                	mov    %esi,%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	57                   	push   %edi
801065c4:	56                   	push   %esi
801065c5:	53                   	push   %ebx
801065c6:	83 ec 1c             	sub    $0x1c,%esp
801065c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
801065cc:	e8 0f dd ff ff       	call   801042e0 <myproc>
801065d1:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
801065d3:	8b 47 30             	mov    0x30(%edi),%eax
801065d6:	83 f8 40             	cmp    $0x40,%eax
801065d9:	0f 84 e9 00 00 00    	je     801066c8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801065df:	83 e8 0e             	sub    $0xe,%eax
801065e2:	83 f8 31             	cmp    $0x31,%eax
801065e5:	77 09                	ja     801065f0 <trap+0x30>
801065e7:	ff 24 85 64 9a 10 80 	jmp    *-0x7fef659c(,%eax,4)
801065ee:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801065f0:	e8 eb dc ff ff       	call   801042e0 <myproc>
801065f5:	85 c0                	test   %eax,%eax
801065f7:	0f 84 57 02 00 00    	je     80106854 <trap+0x294>
801065fd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106601:	0f 84 4d 02 00 00    	je     80106854 <trap+0x294>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106607:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010660a:	8b 57 38             	mov    0x38(%edi),%edx
8010660d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106610:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106613:	e8 a8 dc ff ff       	call   801042c0 <cpuid>
80106618:	8b 77 34             	mov    0x34(%edi),%esi
8010661b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010661e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106621:	e8 ba dc ff ff       	call   801042e0 <myproc>
80106626:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106629:	e8 b2 dc ff ff       	call   801042e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010662e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106631:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106634:	51                   	push   %ecx
80106635:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106636:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106639:	ff 75 e4             	pushl  -0x1c(%ebp)
8010663c:	56                   	push   %esi
8010663d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010663e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106641:	52                   	push   %edx
80106642:	ff 70 10             	pushl  0x10(%eax)
80106645:	68 20 9a 10 80       	push   $0x80109a20
8010664a:	e8 11 a0 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010664f:	83 c4 20             	add    $0x20,%esp
80106652:	e8 89 dc ff ff       	call   801042e0 <myproc>
80106657:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010665e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106660:	e8 7b dc ff ff       	call   801042e0 <myproc>
80106665:	85 c0                	test   %eax,%eax
80106667:	74 1d                	je     80106686 <trap+0xc6>
80106669:	e8 72 dc ff ff       	call   801042e0 <myproc>
8010666e:	8b 50 24             	mov    0x24(%eax),%edx
80106671:	85 d2                	test   %edx,%edx
80106673:	74 11                	je     80106686 <trap+0xc6>
80106675:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106679:	83 e0 03             	and    $0x3,%eax
8010667c:	66 83 f8 03          	cmp    $0x3,%ax
80106680:	0f 84 5a 01 00 00    	je     801067e0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106686:	e8 55 dc ff ff       	call   801042e0 <myproc>
8010668b:	85 c0                	test   %eax,%eax
8010668d:	74 0b                	je     8010669a <trap+0xda>
8010668f:	e8 4c dc ff ff       	call   801042e0 <myproc>
80106694:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106698:	74 5e                	je     801066f8 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010669a:	e8 41 dc ff ff       	call   801042e0 <myproc>
8010669f:	85 c0                	test   %eax,%eax
801066a1:	74 19                	je     801066bc <trap+0xfc>
801066a3:	e8 38 dc ff ff       	call   801042e0 <myproc>
801066a8:	8b 40 24             	mov    0x24(%eax),%eax
801066ab:	85 c0                	test   %eax,%eax
801066ad:	74 0d                	je     801066bc <trap+0xfc>
801066af:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066b3:	83 e0 03             	and    $0x3,%eax
801066b6:	66 83 f8 03          	cmp    $0x3,%ax
801066ba:	74 2b                	je     801066e7 <trap+0x127>
    exit();
801066bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066bf:	5b                   	pop    %ebx
801066c0:	5e                   	pop    %esi
801066c1:	5f                   	pop    %edi
801066c2:	5d                   	pop    %ebp
801066c3:	c3                   	ret    
801066c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
801066c8:	8b 73 24             	mov    0x24(%ebx),%esi
801066cb:	85 f6                	test   %esi,%esi
801066cd:	0f 85 fd 00 00 00    	jne    801067d0 <trap+0x210>
    curproc->tf = tf;
801066d3:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
801066d6:	e8 b5 ef ff ff       	call   80105690 <syscall>
    if(myproc()->killed)
801066db:	e8 00 dc ff ff       	call   801042e0 <myproc>
801066e0:	8b 58 24             	mov    0x24(%eax),%ebx
801066e3:	85 db                	test   %ebx,%ebx
801066e5:	74 d5                	je     801066bc <trap+0xfc>
801066e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066ea:	5b                   	pop    %ebx
801066eb:	5e                   	pop    %esi
801066ec:	5f                   	pop    %edi
801066ed:	5d                   	pop    %ebp
      exit();
801066ee:	e9 4d e2 ff ff       	jmp    80104940 <exit>
801066f3:	90                   	nop
801066f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801066f8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801066fc:	75 9c                	jne    8010669a <trap+0xda>
      if(myproc()->pid > 2) 
801066fe:	e8 dd db ff ff       	call   801042e0 <myproc>
80106703:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106707:	0f 8f 17 01 00 00    	jg     80106824 <trap+0x264>
      yield();
8010670d:	e8 8e e3 ff ff       	call   80104aa0 <yield>
80106712:	eb 86                	jmp    8010669a <trap+0xda>
80106714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->pid > 2) 
80106718:	e8 c3 db ff ff       	call   801042e0 <myproc>
8010671d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106721:	0f 8e 39 ff ff ff    	jle    80106660 <trap+0xa0>
    pagefault();
80106727:	e8 24 27 00 00       	call   80108e50 <pagefault>
      if(curproc->killed) {
8010672c:	8b 4b 24             	mov    0x24(%ebx),%ecx
8010672f:	85 c9                	test   %ecx,%ecx
80106731:	0f 84 29 ff ff ff    	je     80106660 <trap+0xa0>
        exit();
80106737:	e8 04 e2 ff ff       	call   80104940 <exit>
8010673c:	e9 1f ff ff ff       	jmp    80106660 <trap+0xa0>
80106741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106748:	e8 73 db ff ff       	call   801042c0 <cpuid>
8010674d:	85 c0                	test   %eax,%eax
8010674f:	0f 84 9b 00 00 00    	je     801067f0 <trap+0x230>
    lapiceoi();
80106755:	e8 b6 c9 ff ff       	call   80103110 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010675a:	e8 81 db ff ff       	call   801042e0 <myproc>
8010675f:	85 c0                	test   %eax,%eax
80106761:	0f 85 02 ff ff ff    	jne    80106669 <trap+0xa9>
80106767:	e9 1a ff ff ff       	jmp    80106686 <trap+0xc6>
8010676c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106770:	e8 5b c8 ff ff       	call   80102fd0 <kbdintr>
    lapiceoi();
80106775:	e8 96 c9 ff ff       	call   80103110 <lapiceoi>
    break;
8010677a:	e9 e1 fe ff ff       	jmp    80106660 <trap+0xa0>
8010677f:	90                   	nop
    uartintr();
80106780:	e8 6b 02 00 00       	call   801069f0 <uartintr>
    lapiceoi();
80106785:	e8 86 c9 ff ff       	call   80103110 <lapiceoi>
    break;
8010678a:	e9 d1 fe ff ff       	jmp    80106660 <trap+0xa0>
8010678f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106790:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106794:	8b 77 38             	mov    0x38(%edi),%esi
80106797:	e8 24 db ff ff       	call   801042c0 <cpuid>
8010679c:	56                   	push   %esi
8010679d:	53                   	push   %ebx
8010679e:	50                   	push   %eax
8010679f:	68 c8 99 10 80       	push   $0x801099c8
801067a4:	e8 b7 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
801067a9:	e8 62 c9 ff ff       	call   80103110 <lapiceoi>
    break;
801067ae:	83 c4 10             	add    $0x10,%esp
801067b1:	e9 aa fe ff ff       	jmp    80106660 <trap+0xa0>
801067b6:	8d 76 00             	lea    0x0(%esi),%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801067c0:	e8 0b c0 ff ff       	call   801027d0 <ideintr>
801067c5:	eb 8e                	jmp    80106755 <trap+0x195>
801067c7:	89 f6                	mov    %esi,%esi
801067c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
801067d0:	e8 6b e1 ff ff       	call   80104940 <exit>
801067d5:	e9 f9 fe ff ff       	jmp    801066d3 <trap+0x113>
801067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801067e0:	e8 5b e1 ff ff       	call   80104940 <exit>
801067e5:	e9 9c fe ff ff       	jmp    80106686 <trap+0xc6>
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	68 40 6d 19 80       	push   $0x80196d40
801067f8:	e8 93 e9 ff ff       	call   80105190 <acquire>
      wakeup(&ticks);
801067fd:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
80106804:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
8010680b:	e8 20 e5 ff ff       	call   80104d30 <wakeup>
      release(&tickslock);
80106810:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
80106817:	e8 34 ea ff ff       	call   80105250 <release>
8010681c:	83 c4 10             	add    $0x10,%esp
8010681f:	e9 31 ff ff ff       	jmp    80106755 <trap+0x195>
        updateNfua(myproc());
80106824:	e8 b7 da ff ff       	call   801042e0 <myproc>
80106829:	83 ec 0c             	sub    $0xc,%esp
8010682c:	50                   	push   %eax
8010682d:	e8 4e 1c 00 00       	call   80108480 <updateNfua>
        updateLapa(myproc());
80106832:	e8 a9 da ff ff       	call   801042e0 <myproc>
80106837:	89 04 24             	mov    %eax,(%esp)
8010683a:	e8 d1 1b 00 00       	call   80108410 <updateLapa>
        updateAQ(myproc());
8010683f:	e8 9c da ff ff       	call   801042e0 <myproc>
80106844:	89 04 24             	mov    %eax,(%esp)
80106847:	e8 94 27 00 00       	call   80108fe0 <updateAQ>
8010684c:	83 c4 10             	add    $0x10,%esp
8010684f:	e9 b9 fe ff ff       	jmp    8010670d <trap+0x14d>
80106854:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106857:	8b 5f 38             	mov    0x38(%edi),%ebx
8010685a:	e8 61 da ff ff       	call   801042c0 <cpuid>
8010685f:	83 ec 0c             	sub    $0xc,%esp
80106862:	56                   	push   %esi
80106863:	53                   	push   %ebx
80106864:	50                   	push   %eax
80106865:	ff 77 30             	pushl  0x30(%edi)
80106868:	68 ec 99 10 80       	push   $0x801099ec
8010686d:	e8 ee 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
80106872:	83 c4 14             	add    $0x14,%esp
80106875:	68 c2 99 10 80       	push   $0x801099c2
8010687a:	e8 11 9b ff ff       	call   80100390 <panic>
8010687f:	90                   	nop

80106880 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106880:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
80106885:	55                   	push   %ebp
80106886:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106888:	85 c0                	test   %eax,%eax
8010688a:	74 1c                	je     801068a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010688c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106891:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106892:	a8 01                	test   $0x1,%al
80106894:	74 12                	je     801068a8 <uartgetc+0x28>
80106896:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010689b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010689c:	0f b6 c0             	movzbl %al,%eax
}
8010689f:	5d                   	pop    %ebp
801068a0:	c3                   	ret    
801068a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ad:	5d                   	pop    %ebp
801068ae:	c3                   	ret    
801068af:	90                   	nop

801068b0 <uartputc.part.0>:
uartputc(int c)
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
801068b6:	89 c7                	mov    %eax,%edi
801068b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801068bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801068c2:	83 ec 0c             	sub    $0xc,%esp
801068c5:	eb 1b                	jmp    801068e2 <uartputc.part.0+0x32>
801068c7:	89 f6                	mov    %esi,%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801068d0:	83 ec 0c             	sub    $0xc,%esp
801068d3:	6a 0a                	push   $0xa
801068d5:	e8 56 c8 ff ff       	call   80103130 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068da:	83 c4 10             	add    $0x10,%esp
801068dd:	83 eb 01             	sub    $0x1,%ebx
801068e0:	74 07                	je     801068e9 <uartputc.part.0+0x39>
801068e2:	89 f2                	mov    %esi,%edx
801068e4:	ec                   	in     (%dx),%al
801068e5:	a8 20                	test   $0x20,%al
801068e7:	74 e7                	je     801068d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068ee:	89 f8                	mov    %edi,%eax
801068f0:	ee                   	out    %al,(%dx)
}
801068f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f4:	5b                   	pop    %ebx
801068f5:	5e                   	pop    %esi
801068f6:	5f                   	pop    %edi
801068f7:	5d                   	pop    %ebp
801068f8:	c3                   	ret    
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106900 <uartinit>:
{
80106900:	55                   	push   %ebp
80106901:	31 c9                	xor    %ecx,%ecx
80106903:	89 c8                	mov    %ecx,%eax
80106905:	89 e5                	mov    %esp,%ebp
80106907:	57                   	push   %edi
80106908:	56                   	push   %esi
80106909:	53                   	push   %ebx
8010690a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010690f:	89 da                	mov    %ebx,%edx
80106911:	83 ec 0c             	sub    $0xc,%esp
80106914:	ee                   	out    %al,(%dx)
80106915:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010691a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010691f:	89 fa                	mov    %edi,%edx
80106921:	ee                   	out    %al,(%dx)
80106922:	b8 0c 00 00 00       	mov    $0xc,%eax
80106927:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010692c:	ee                   	out    %al,(%dx)
8010692d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106932:	89 c8                	mov    %ecx,%eax
80106934:	89 f2                	mov    %esi,%edx
80106936:	ee                   	out    %al,(%dx)
80106937:	b8 03 00 00 00       	mov    $0x3,%eax
8010693c:	89 fa                	mov    %edi,%edx
8010693e:	ee                   	out    %al,(%dx)
8010693f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106944:	89 c8                	mov    %ecx,%eax
80106946:	ee                   	out    %al,(%dx)
80106947:	b8 01 00 00 00       	mov    $0x1,%eax
8010694c:	89 f2                	mov    %esi,%edx
8010694e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010694f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106954:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106955:	3c ff                	cmp    $0xff,%al
80106957:	74 5a                	je     801069b3 <uartinit+0xb3>
  uart = 1;
80106959:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
80106960:	00 00 00 
80106963:	89 da                	mov    %ebx,%edx
80106965:	ec                   	in     (%dx),%al
80106966:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010696b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010696c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010696f:	bb 2c 9b 10 80       	mov    $0x80109b2c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106974:	6a 00                	push   $0x0
80106976:	6a 04                	push   $0x4
80106978:	e8 a3 c0 ff ff       	call   80102a20 <ioapicenable>
8010697d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106980:	b8 78 00 00 00       	mov    $0x78,%eax
80106985:	eb 13                	jmp    8010699a <uartinit+0x9a>
80106987:	89 f6                	mov    %esi,%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106990:	83 c3 01             	add    $0x1,%ebx
80106993:	0f be 03             	movsbl (%ebx),%eax
80106996:	84 c0                	test   %al,%al
80106998:	74 19                	je     801069b3 <uartinit+0xb3>
  if(!uart)
8010699a:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
801069a0:	85 d2                	test   %edx,%edx
801069a2:	74 ec                	je     80106990 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801069a4:	83 c3 01             	add    $0x1,%ebx
801069a7:	e8 04 ff ff ff       	call   801068b0 <uartputc.part.0>
801069ac:	0f be 03             	movsbl (%ebx),%eax
801069af:	84 c0                	test   %al,%al
801069b1:	75 e7                	jne    8010699a <uartinit+0x9a>
}
801069b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b6:	5b                   	pop    %ebx
801069b7:	5e                   	pop    %esi
801069b8:	5f                   	pop    %edi
801069b9:	5d                   	pop    %ebp
801069ba:	c3                   	ret    
801069bb:	90                   	nop
801069bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069c0 <uartputc>:
  if(!uart)
801069c0:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
801069c6:	55                   	push   %ebp
801069c7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069c9:	85 d2                	test   %edx,%edx
{
801069cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069ce:	74 10                	je     801069e0 <uartputc+0x20>
}
801069d0:	5d                   	pop    %ebp
801069d1:	e9 da fe ff ff       	jmp    801068b0 <uartputc.part.0>
801069d6:	8d 76 00             	lea    0x0(%esi),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069e0:	5d                   	pop    %ebp
801069e1:	c3                   	ret    
801069e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <uartintr>:

void
uartintr(void)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801069f6:	68 80 68 10 80       	push   $0x80106880
801069fb:	e8 10 9e ff ff       	call   80100810 <consoleintr>
}
80106a00:	83 c4 10             	add    $0x10,%esp
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $0
80106a07:	6a 00                	push   $0x0
  jmp alltraps
80106a09:	e9 db fa ff ff       	jmp    801064e9 <alltraps>

80106a0e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $1
80106a10:	6a 01                	push   $0x1
  jmp alltraps
80106a12:	e9 d2 fa ff ff       	jmp    801064e9 <alltraps>

80106a17 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $2
80106a19:	6a 02                	push   $0x2
  jmp alltraps
80106a1b:	e9 c9 fa ff ff       	jmp    801064e9 <alltraps>

80106a20 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $3
80106a22:	6a 03                	push   $0x3
  jmp alltraps
80106a24:	e9 c0 fa ff ff       	jmp    801064e9 <alltraps>

80106a29 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $4
80106a2b:	6a 04                	push   $0x4
  jmp alltraps
80106a2d:	e9 b7 fa ff ff       	jmp    801064e9 <alltraps>

80106a32 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $5
80106a34:	6a 05                	push   $0x5
  jmp alltraps
80106a36:	e9 ae fa ff ff       	jmp    801064e9 <alltraps>

80106a3b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $6
80106a3d:	6a 06                	push   $0x6
  jmp alltraps
80106a3f:	e9 a5 fa ff ff       	jmp    801064e9 <alltraps>

80106a44 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $7
80106a46:	6a 07                	push   $0x7
  jmp alltraps
80106a48:	e9 9c fa ff ff       	jmp    801064e9 <alltraps>

80106a4d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a4d:	6a 08                	push   $0x8
  jmp alltraps
80106a4f:	e9 95 fa ff ff       	jmp    801064e9 <alltraps>

80106a54 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $9
80106a56:	6a 09                	push   $0x9
  jmp alltraps
80106a58:	e9 8c fa ff ff       	jmp    801064e9 <alltraps>

80106a5d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a5d:	6a 0a                	push   $0xa
  jmp alltraps
80106a5f:	e9 85 fa ff ff       	jmp    801064e9 <alltraps>

80106a64 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a64:	6a 0b                	push   $0xb
  jmp alltraps
80106a66:	e9 7e fa ff ff       	jmp    801064e9 <alltraps>

80106a6b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a6b:	6a 0c                	push   $0xc
  jmp alltraps
80106a6d:	e9 77 fa ff ff       	jmp    801064e9 <alltraps>

80106a72 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a72:	6a 0d                	push   $0xd
  jmp alltraps
80106a74:	e9 70 fa ff ff       	jmp    801064e9 <alltraps>

80106a79 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a79:	6a 0e                	push   $0xe
  jmp alltraps
80106a7b:	e9 69 fa ff ff       	jmp    801064e9 <alltraps>

80106a80 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $15
80106a82:	6a 0f                	push   $0xf
  jmp alltraps
80106a84:	e9 60 fa ff ff       	jmp    801064e9 <alltraps>

80106a89 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $16
80106a8b:	6a 10                	push   $0x10
  jmp alltraps
80106a8d:	e9 57 fa ff ff       	jmp    801064e9 <alltraps>

80106a92 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a92:	6a 11                	push   $0x11
  jmp alltraps
80106a94:	e9 50 fa ff ff       	jmp    801064e9 <alltraps>

80106a99 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $18
80106a9b:	6a 12                	push   $0x12
  jmp alltraps
80106a9d:	e9 47 fa ff ff       	jmp    801064e9 <alltraps>

80106aa2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $19
80106aa4:	6a 13                	push   $0x13
  jmp alltraps
80106aa6:	e9 3e fa ff ff       	jmp    801064e9 <alltraps>

80106aab <vector20>:
.globl vector20
vector20:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $20
80106aad:	6a 14                	push   $0x14
  jmp alltraps
80106aaf:	e9 35 fa ff ff       	jmp    801064e9 <alltraps>

80106ab4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $21
80106ab6:	6a 15                	push   $0x15
  jmp alltraps
80106ab8:	e9 2c fa ff ff       	jmp    801064e9 <alltraps>

80106abd <vector22>:
.globl vector22
vector22:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $22
80106abf:	6a 16                	push   $0x16
  jmp alltraps
80106ac1:	e9 23 fa ff ff       	jmp    801064e9 <alltraps>

80106ac6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $23
80106ac8:	6a 17                	push   $0x17
  jmp alltraps
80106aca:	e9 1a fa ff ff       	jmp    801064e9 <alltraps>

80106acf <vector24>:
.globl vector24
vector24:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $24
80106ad1:	6a 18                	push   $0x18
  jmp alltraps
80106ad3:	e9 11 fa ff ff       	jmp    801064e9 <alltraps>

80106ad8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $25
80106ada:	6a 19                	push   $0x19
  jmp alltraps
80106adc:	e9 08 fa ff ff       	jmp    801064e9 <alltraps>

80106ae1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $26
80106ae3:	6a 1a                	push   $0x1a
  jmp alltraps
80106ae5:	e9 ff f9 ff ff       	jmp    801064e9 <alltraps>

80106aea <vector27>:
.globl vector27
vector27:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $27
80106aec:	6a 1b                	push   $0x1b
  jmp alltraps
80106aee:	e9 f6 f9 ff ff       	jmp    801064e9 <alltraps>

80106af3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $28
80106af5:	6a 1c                	push   $0x1c
  jmp alltraps
80106af7:	e9 ed f9 ff ff       	jmp    801064e9 <alltraps>

80106afc <vector29>:
.globl vector29
vector29:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $29
80106afe:	6a 1d                	push   $0x1d
  jmp alltraps
80106b00:	e9 e4 f9 ff ff       	jmp    801064e9 <alltraps>

80106b05 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $30
80106b07:	6a 1e                	push   $0x1e
  jmp alltraps
80106b09:	e9 db f9 ff ff       	jmp    801064e9 <alltraps>

80106b0e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $31
80106b10:	6a 1f                	push   $0x1f
  jmp alltraps
80106b12:	e9 d2 f9 ff ff       	jmp    801064e9 <alltraps>

80106b17 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $32
80106b19:	6a 20                	push   $0x20
  jmp alltraps
80106b1b:	e9 c9 f9 ff ff       	jmp    801064e9 <alltraps>

80106b20 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $33
80106b22:	6a 21                	push   $0x21
  jmp alltraps
80106b24:	e9 c0 f9 ff ff       	jmp    801064e9 <alltraps>

80106b29 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $34
80106b2b:	6a 22                	push   $0x22
  jmp alltraps
80106b2d:	e9 b7 f9 ff ff       	jmp    801064e9 <alltraps>

80106b32 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $35
80106b34:	6a 23                	push   $0x23
  jmp alltraps
80106b36:	e9 ae f9 ff ff       	jmp    801064e9 <alltraps>

80106b3b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $36
80106b3d:	6a 24                	push   $0x24
  jmp alltraps
80106b3f:	e9 a5 f9 ff ff       	jmp    801064e9 <alltraps>

80106b44 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $37
80106b46:	6a 25                	push   $0x25
  jmp alltraps
80106b48:	e9 9c f9 ff ff       	jmp    801064e9 <alltraps>

80106b4d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $38
80106b4f:	6a 26                	push   $0x26
  jmp alltraps
80106b51:	e9 93 f9 ff ff       	jmp    801064e9 <alltraps>

80106b56 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $39
80106b58:	6a 27                	push   $0x27
  jmp alltraps
80106b5a:	e9 8a f9 ff ff       	jmp    801064e9 <alltraps>

80106b5f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $40
80106b61:	6a 28                	push   $0x28
  jmp alltraps
80106b63:	e9 81 f9 ff ff       	jmp    801064e9 <alltraps>

80106b68 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $41
80106b6a:	6a 29                	push   $0x29
  jmp alltraps
80106b6c:	e9 78 f9 ff ff       	jmp    801064e9 <alltraps>

80106b71 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $42
80106b73:	6a 2a                	push   $0x2a
  jmp alltraps
80106b75:	e9 6f f9 ff ff       	jmp    801064e9 <alltraps>

80106b7a <vector43>:
.globl vector43
vector43:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $43
80106b7c:	6a 2b                	push   $0x2b
  jmp alltraps
80106b7e:	e9 66 f9 ff ff       	jmp    801064e9 <alltraps>

80106b83 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $44
80106b85:	6a 2c                	push   $0x2c
  jmp alltraps
80106b87:	e9 5d f9 ff ff       	jmp    801064e9 <alltraps>

80106b8c <vector45>:
.globl vector45
vector45:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $45
80106b8e:	6a 2d                	push   $0x2d
  jmp alltraps
80106b90:	e9 54 f9 ff ff       	jmp    801064e9 <alltraps>

80106b95 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $46
80106b97:	6a 2e                	push   $0x2e
  jmp alltraps
80106b99:	e9 4b f9 ff ff       	jmp    801064e9 <alltraps>

80106b9e <vector47>:
.globl vector47
vector47:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $47
80106ba0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ba2:	e9 42 f9 ff ff       	jmp    801064e9 <alltraps>

80106ba7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $48
80106ba9:	6a 30                	push   $0x30
  jmp alltraps
80106bab:	e9 39 f9 ff ff       	jmp    801064e9 <alltraps>

80106bb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $49
80106bb2:	6a 31                	push   $0x31
  jmp alltraps
80106bb4:	e9 30 f9 ff ff       	jmp    801064e9 <alltraps>

80106bb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $50
80106bbb:	6a 32                	push   $0x32
  jmp alltraps
80106bbd:	e9 27 f9 ff ff       	jmp    801064e9 <alltraps>

80106bc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $51
80106bc4:	6a 33                	push   $0x33
  jmp alltraps
80106bc6:	e9 1e f9 ff ff       	jmp    801064e9 <alltraps>

80106bcb <vector52>:
.globl vector52
vector52:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $52
80106bcd:	6a 34                	push   $0x34
  jmp alltraps
80106bcf:	e9 15 f9 ff ff       	jmp    801064e9 <alltraps>

80106bd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $53
80106bd6:	6a 35                	push   $0x35
  jmp alltraps
80106bd8:	e9 0c f9 ff ff       	jmp    801064e9 <alltraps>

80106bdd <vector54>:
.globl vector54
vector54:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $54
80106bdf:	6a 36                	push   $0x36
  jmp alltraps
80106be1:	e9 03 f9 ff ff       	jmp    801064e9 <alltraps>

80106be6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $55
80106be8:	6a 37                	push   $0x37
  jmp alltraps
80106bea:	e9 fa f8 ff ff       	jmp    801064e9 <alltraps>

80106bef <vector56>:
.globl vector56
vector56:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $56
80106bf1:	6a 38                	push   $0x38
  jmp alltraps
80106bf3:	e9 f1 f8 ff ff       	jmp    801064e9 <alltraps>

80106bf8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $57
80106bfa:	6a 39                	push   $0x39
  jmp alltraps
80106bfc:	e9 e8 f8 ff ff       	jmp    801064e9 <alltraps>

80106c01 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $58
80106c03:	6a 3a                	push   $0x3a
  jmp alltraps
80106c05:	e9 df f8 ff ff       	jmp    801064e9 <alltraps>

80106c0a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $59
80106c0c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c0e:	e9 d6 f8 ff ff       	jmp    801064e9 <alltraps>

80106c13 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $60
80106c15:	6a 3c                	push   $0x3c
  jmp alltraps
80106c17:	e9 cd f8 ff ff       	jmp    801064e9 <alltraps>

80106c1c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $61
80106c1e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c20:	e9 c4 f8 ff ff       	jmp    801064e9 <alltraps>

80106c25 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $62
80106c27:	6a 3e                	push   $0x3e
  jmp alltraps
80106c29:	e9 bb f8 ff ff       	jmp    801064e9 <alltraps>

80106c2e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $63
80106c30:	6a 3f                	push   $0x3f
  jmp alltraps
80106c32:	e9 b2 f8 ff ff       	jmp    801064e9 <alltraps>

80106c37 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $64
80106c39:	6a 40                	push   $0x40
  jmp alltraps
80106c3b:	e9 a9 f8 ff ff       	jmp    801064e9 <alltraps>

80106c40 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $65
80106c42:	6a 41                	push   $0x41
  jmp alltraps
80106c44:	e9 a0 f8 ff ff       	jmp    801064e9 <alltraps>

80106c49 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $66
80106c4b:	6a 42                	push   $0x42
  jmp alltraps
80106c4d:	e9 97 f8 ff ff       	jmp    801064e9 <alltraps>

80106c52 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $67
80106c54:	6a 43                	push   $0x43
  jmp alltraps
80106c56:	e9 8e f8 ff ff       	jmp    801064e9 <alltraps>

80106c5b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $68
80106c5d:	6a 44                	push   $0x44
  jmp alltraps
80106c5f:	e9 85 f8 ff ff       	jmp    801064e9 <alltraps>

80106c64 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $69
80106c66:	6a 45                	push   $0x45
  jmp alltraps
80106c68:	e9 7c f8 ff ff       	jmp    801064e9 <alltraps>

80106c6d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $70
80106c6f:	6a 46                	push   $0x46
  jmp alltraps
80106c71:	e9 73 f8 ff ff       	jmp    801064e9 <alltraps>

80106c76 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $71
80106c78:	6a 47                	push   $0x47
  jmp alltraps
80106c7a:	e9 6a f8 ff ff       	jmp    801064e9 <alltraps>

80106c7f <vector72>:
.globl vector72
vector72:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $72
80106c81:	6a 48                	push   $0x48
  jmp alltraps
80106c83:	e9 61 f8 ff ff       	jmp    801064e9 <alltraps>

80106c88 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $73
80106c8a:	6a 49                	push   $0x49
  jmp alltraps
80106c8c:	e9 58 f8 ff ff       	jmp    801064e9 <alltraps>

80106c91 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $74
80106c93:	6a 4a                	push   $0x4a
  jmp alltraps
80106c95:	e9 4f f8 ff ff       	jmp    801064e9 <alltraps>

80106c9a <vector75>:
.globl vector75
vector75:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $75
80106c9c:	6a 4b                	push   $0x4b
  jmp alltraps
80106c9e:	e9 46 f8 ff ff       	jmp    801064e9 <alltraps>

80106ca3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $76
80106ca5:	6a 4c                	push   $0x4c
  jmp alltraps
80106ca7:	e9 3d f8 ff ff       	jmp    801064e9 <alltraps>

80106cac <vector77>:
.globl vector77
vector77:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $77
80106cae:	6a 4d                	push   $0x4d
  jmp alltraps
80106cb0:	e9 34 f8 ff ff       	jmp    801064e9 <alltraps>

80106cb5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $78
80106cb7:	6a 4e                	push   $0x4e
  jmp alltraps
80106cb9:	e9 2b f8 ff ff       	jmp    801064e9 <alltraps>

80106cbe <vector79>:
.globl vector79
vector79:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $79
80106cc0:	6a 4f                	push   $0x4f
  jmp alltraps
80106cc2:	e9 22 f8 ff ff       	jmp    801064e9 <alltraps>

80106cc7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $80
80106cc9:	6a 50                	push   $0x50
  jmp alltraps
80106ccb:	e9 19 f8 ff ff       	jmp    801064e9 <alltraps>

80106cd0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $81
80106cd2:	6a 51                	push   $0x51
  jmp alltraps
80106cd4:	e9 10 f8 ff ff       	jmp    801064e9 <alltraps>

80106cd9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $82
80106cdb:	6a 52                	push   $0x52
  jmp alltraps
80106cdd:	e9 07 f8 ff ff       	jmp    801064e9 <alltraps>

80106ce2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $83
80106ce4:	6a 53                	push   $0x53
  jmp alltraps
80106ce6:	e9 fe f7 ff ff       	jmp    801064e9 <alltraps>

80106ceb <vector84>:
.globl vector84
vector84:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $84
80106ced:	6a 54                	push   $0x54
  jmp alltraps
80106cef:	e9 f5 f7 ff ff       	jmp    801064e9 <alltraps>

80106cf4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $85
80106cf6:	6a 55                	push   $0x55
  jmp alltraps
80106cf8:	e9 ec f7 ff ff       	jmp    801064e9 <alltraps>

80106cfd <vector86>:
.globl vector86
vector86:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $86
80106cff:	6a 56                	push   $0x56
  jmp alltraps
80106d01:	e9 e3 f7 ff ff       	jmp    801064e9 <alltraps>

80106d06 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $87
80106d08:	6a 57                	push   $0x57
  jmp alltraps
80106d0a:	e9 da f7 ff ff       	jmp    801064e9 <alltraps>

80106d0f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $88
80106d11:	6a 58                	push   $0x58
  jmp alltraps
80106d13:	e9 d1 f7 ff ff       	jmp    801064e9 <alltraps>

80106d18 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $89
80106d1a:	6a 59                	push   $0x59
  jmp alltraps
80106d1c:	e9 c8 f7 ff ff       	jmp    801064e9 <alltraps>

80106d21 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $90
80106d23:	6a 5a                	push   $0x5a
  jmp alltraps
80106d25:	e9 bf f7 ff ff       	jmp    801064e9 <alltraps>

80106d2a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $91
80106d2c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d2e:	e9 b6 f7 ff ff       	jmp    801064e9 <alltraps>

80106d33 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $92
80106d35:	6a 5c                	push   $0x5c
  jmp alltraps
80106d37:	e9 ad f7 ff ff       	jmp    801064e9 <alltraps>

80106d3c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $93
80106d3e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d40:	e9 a4 f7 ff ff       	jmp    801064e9 <alltraps>

80106d45 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $94
80106d47:	6a 5e                	push   $0x5e
  jmp alltraps
80106d49:	e9 9b f7 ff ff       	jmp    801064e9 <alltraps>

80106d4e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $95
80106d50:	6a 5f                	push   $0x5f
  jmp alltraps
80106d52:	e9 92 f7 ff ff       	jmp    801064e9 <alltraps>

80106d57 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $96
80106d59:	6a 60                	push   $0x60
  jmp alltraps
80106d5b:	e9 89 f7 ff ff       	jmp    801064e9 <alltraps>

80106d60 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $97
80106d62:	6a 61                	push   $0x61
  jmp alltraps
80106d64:	e9 80 f7 ff ff       	jmp    801064e9 <alltraps>

80106d69 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $98
80106d6b:	6a 62                	push   $0x62
  jmp alltraps
80106d6d:	e9 77 f7 ff ff       	jmp    801064e9 <alltraps>

80106d72 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $99
80106d74:	6a 63                	push   $0x63
  jmp alltraps
80106d76:	e9 6e f7 ff ff       	jmp    801064e9 <alltraps>

80106d7b <vector100>:
.globl vector100
vector100:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $100
80106d7d:	6a 64                	push   $0x64
  jmp alltraps
80106d7f:	e9 65 f7 ff ff       	jmp    801064e9 <alltraps>

80106d84 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $101
80106d86:	6a 65                	push   $0x65
  jmp alltraps
80106d88:	e9 5c f7 ff ff       	jmp    801064e9 <alltraps>

80106d8d <vector102>:
.globl vector102
vector102:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $102
80106d8f:	6a 66                	push   $0x66
  jmp alltraps
80106d91:	e9 53 f7 ff ff       	jmp    801064e9 <alltraps>

80106d96 <vector103>:
.globl vector103
vector103:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $103
80106d98:	6a 67                	push   $0x67
  jmp alltraps
80106d9a:	e9 4a f7 ff ff       	jmp    801064e9 <alltraps>

80106d9f <vector104>:
.globl vector104
vector104:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $104
80106da1:	6a 68                	push   $0x68
  jmp alltraps
80106da3:	e9 41 f7 ff ff       	jmp    801064e9 <alltraps>

80106da8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $105
80106daa:	6a 69                	push   $0x69
  jmp alltraps
80106dac:	e9 38 f7 ff ff       	jmp    801064e9 <alltraps>

80106db1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $106
80106db3:	6a 6a                	push   $0x6a
  jmp alltraps
80106db5:	e9 2f f7 ff ff       	jmp    801064e9 <alltraps>

80106dba <vector107>:
.globl vector107
vector107:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $107
80106dbc:	6a 6b                	push   $0x6b
  jmp alltraps
80106dbe:	e9 26 f7 ff ff       	jmp    801064e9 <alltraps>

80106dc3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $108
80106dc5:	6a 6c                	push   $0x6c
  jmp alltraps
80106dc7:	e9 1d f7 ff ff       	jmp    801064e9 <alltraps>

80106dcc <vector109>:
.globl vector109
vector109:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $109
80106dce:	6a 6d                	push   $0x6d
  jmp alltraps
80106dd0:	e9 14 f7 ff ff       	jmp    801064e9 <alltraps>

80106dd5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $110
80106dd7:	6a 6e                	push   $0x6e
  jmp alltraps
80106dd9:	e9 0b f7 ff ff       	jmp    801064e9 <alltraps>

80106dde <vector111>:
.globl vector111
vector111:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $111
80106de0:	6a 6f                	push   $0x6f
  jmp alltraps
80106de2:	e9 02 f7 ff ff       	jmp    801064e9 <alltraps>

80106de7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $112
80106de9:	6a 70                	push   $0x70
  jmp alltraps
80106deb:	e9 f9 f6 ff ff       	jmp    801064e9 <alltraps>

80106df0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $113
80106df2:	6a 71                	push   $0x71
  jmp alltraps
80106df4:	e9 f0 f6 ff ff       	jmp    801064e9 <alltraps>

80106df9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $114
80106dfb:	6a 72                	push   $0x72
  jmp alltraps
80106dfd:	e9 e7 f6 ff ff       	jmp    801064e9 <alltraps>

80106e02 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $115
80106e04:	6a 73                	push   $0x73
  jmp alltraps
80106e06:	e9 de f6 ff ff       	jmp    801064e9 <alltraps>

80106e0b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $116
80106e0d:	6a 74                	push   $0x74
  jmp alltraps
80106e0f:	e9 d5 f6 ff ff       	jmp    801064e9 <alltraps>

80106e14 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $117
80106e16:	6a 75                	push   $0x75
  jmp alltraps
80106e18:	e9 cc f6 ff ff       	jmp    801064e9 <alltraps>

80106e1d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $118
80106e1f:	6a 76                	push   $0x76
  jmp alltraps
80106e21:	e9 c3 f6 ff ff       	jmp    801064e9 <alltraps>

80106e26 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $119
80106e28:	6a 77                	push   $0x77
  jmp alltraps
80106e2a:	e9 ba f6 ff ff       	jmp    801064e9 <alltraps>

80106e2f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $120
80106e31:	6a 78                	push   $0x78
  jmp alltraps
80106e33:	e9 b1 f6 ff ff       	jmp    801064e9 <alltraps>

80106e38 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $121
80106e3a:	6a 79                	push   $0x79
  jmp alltraps
80106e3c:	e9 a8 f6 ff ff       	jmp    801064e9 <alltraps>

80106e41 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $122
80106e43:	6a 7a                	push   $0x7a
  jmp alltraps
80106e45:	e9 9f f6 ff ff       	jmp    801064e9 <alltraps>

80106e4a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $123
80106e4c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e4e:	e9 96 f6 ff ff       	jmp    801064e9 <alltraps>

80106e53 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $124
80106e55:	6a 7c                	push   $0x7c
  jmp alltraps
80106e57:	e9 8d f6 ff ff       	jmp    801064e9 <alltraps>

80106e5c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $125
80106e5e:	6a 7d                	push   $0x7d
  jmp alltraps
80106e60:	e9 84 f6 ff ff       	jmp    801064e9 <alltraps>

80106e65 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $126
80106e67:	6a 7e                	push   $0x7e
  jmp alltraps
80106e69:	e9 7b f6 ff ff       	jmp    801064e9 <alltraps>

80106e6e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $127
80106e70:	6a 7f                	push   $0x7f
  jmp alltraps
80106e72:	e9 72 f6 ff ff       	jmp    801064e9 <alltraps>

80106e77 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $128
80106e79:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e7e:	e9 66 f6 ff ff       	jmp    801064e9 <alltraps>

80106e83 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $129
80106e85:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e8a:	e9 5a f6 ff ff       	jmp    801064e9 <alltraps>

80106e8f <vector130>:
.globl vector130
vector130:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $130
80106e91:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e96:	e9 4e f6 ff ff       	jmp    801064e9 <alltraps>

80106e9b <vector131>:
.globl vector131
vector131:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $131
80106e9d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ea2:	e9 42 f6 ff ff       	jmp    801064e9 <alltraps>

80106ea7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $132
80106ea9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106eae:	e9 36 f6 ff ff       	jmp    801064e9 <alltraps>

80106eb3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $133
80106eb5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106eba:	e9 2a f6 ff ff       	jmp    801064e9 <alltraps>

80106ebf <vector134>:
.globl vector134
vector134:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $134
80106ec1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ec6:	e9 1e f6 ff ff       	jmp    801064e9 <alltraps>

80106ecb <vector135>:
.globl vector135
vector135:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $135
80106ecd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ed2:	e9 12 f6 ff ff       	jmp    801064e9 <alltraps>

80106ed7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $136
80106ed9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ede:	e9 06 f6 ff ff       	jmp    801064e9 <alltraps>

80106ee3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $137
80106ee5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106eea:	e9 fa f5 ff ff       	jmp    801064e9 <alltraps>

80106eef <vector138>:
.globl vector138
vector138:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $138
80106ef1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ef6:	e9 ee f5 ff ff       	jmp    801064e9 <alltraps>

80106efb <vector139>:
.globl vector139
vector139:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $139
80106efd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f02:	e9 e2 f5 ff ff       	jmp    801064e9 <alltraps>

80106f07 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $140
80106f09:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f0e:	e9 d6 f5 ff ff       	jmp    801064e9 <alltraps>

80106f13 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $141
80106f15:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f1a:	e9 ca f5 ff ff       	jmp    801064e9 <alltraps>

80106f1f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $142
80106f21:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f26:	e9 be f5 ff ff       	jmp    801064e9 <alltraps>

80106f2b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $143
80106f2d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f32:	e9 b2 f5 ff ff       	jmp    801064e9 <alltraps>

80106f37 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $144
80106f39:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f3e:	e9 a6 f5 ff ff       	jmp    801064e9 <alltraps>

80106f43 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $145
80106f45:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f4a:	e9 9a f5 ff ff       	jmp    801064e9 <alltraps>

80106f4f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $146
80106f51:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f56:	e9 8e f5 ff ff       	jmp    801064e9 <alltraps>

80106f5b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $147
80106f5d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f62:	e9 82 f5 ff ff       	jmp    801064e9 <alltraps>

80106f67 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $148
80106f69:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f6e:	e9 76 f5 ff ff       	jmp    801064e9 <alltraps>

80106f73 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $149
80106f75:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f7a:	e9 6a f5 ff ff       	jmp    801064e9 <alltraps>

80106f7f <vector150>:
.globl vector150
vector150:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $150
80106f81:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f86:	e9 5e f5 ff ff       	jmp    801064e9 <alltraps>

80106f8b <vector151>:
.globl vector151
vector151:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $151
80106f8d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f92:	e9 52 f5 ff ff       	jmp    801064e9 <alltraps>

80106f97 <vector152>:
.globl vector152
vector152:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $152
80106f99:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f9e:	e9 46 f5 ff ff       	jmp    801064e9 <alltraps>

80106fa3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $153
80106fa5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106faa:	e9 3a f5 ff ff       	jmp    801064e9 <alltraps>

80106faf <vector154>:
.globl vector154
vector154:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $154
80106fb1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fb6:	e9 2e f5 ff ff       	jmp    801064e9 <alltraps>

80106fbb <vector155>:
.globl vector155
vector155:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $155
80106fbd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fc2:	e9 22 f5 ff ff       	jmp    801064e9 <alltraps>

80106fc7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $156
80106fc9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fce:	e9 16 f5 ff ff       	jmp    801064e9 <alltraps>

80106fd3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $157
80106fd5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fda:	e9 0a f5 ff ff       	jmp    801064e9 <alltraps>

80106fdf <vector158>:
.globl vector158
vector158:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $158
80106fe1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106fe6:	e9 fe f4 ff ff       	jmp    801064e9 <alltraps>

80106feb <vector159>:
.globl vector159
vector159:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $159
80106fed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ff2:	e9 f2 f4 ff ff       	jmp    801064e9 <alltraps>

80106ff7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $160
80106ff9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ffe:	e9 e6 f4 ff ff       	jmp    801064e9 <alltraps>

80107003 <vector161>:
.globl vector161
vector161:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $161
80107005:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010700a:	e9 da f4 ff ff       	jmp    801064e9 <alltraps>

8010700f <vector162>:
.globl vector162
vector162:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $162
80107011:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107016:	e9 ce f4 ff ff       	jmp    801064e9 <alltraps>

8010701b <vector163>:
.globl vector163
vector163:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $163
8010701d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107022:	e9 c2 f4 ff ff       	jmp    801064e9 <alltraps>

80107027 <vector164>:
.globl vector164
vector164:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $164
80107029:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010702e:	e9 b6 f4 ff ff       	jmp    801064e9 <alltraps>

80107033 <vector165>:
.globl vector165
vector165:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $165
80107035:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010703a:	e9 aa f4 ff ff       	jmp    801064e9 <alltraps>

8010703f <vector166>:
.globl vector166
vector166:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $166
80107041:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107046:	e9 9e f4 ff ff       	jmp    801064e9 <alltraps>

8010704b <vector167>:
.globl vector167
vector167:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $167
8010704d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107052:	e9 92 f4 ff ff       	jmp    801064e9 <alltraps>

80107057 <vector168>:
.globl vector168
vector168:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $168
80107059:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010705e:	e9 86 f4 ff ff       	jmp    801064e9 <alltraps>

80107063 <vector169>:
.globl vector169
vector169:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $169
80107065:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010706a:	e9 7a f4 ff ff       	jmp    801064e9 <alltraps>

8010706f <vector170>:
.globl vector170
vector170:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $170
80107071:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107076:	e9 6e f4 ff ff       	jmp    801064e9 <alltraps>

8010707b <vector171>:
.globl vector171
vector171:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $171
8010707d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107082:	e9 62 f4 ff ff       	jmp    801064e9 <alltraps>

80107087 <vector172>:
.globl vector172
vector172:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $172
80107089:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010708e:	e9 56 f4 ff ff       	jmp    801064e9 <alltraps>

80107093 <vector173>:
.globl vector173
vector173:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $173
80107095:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010709a:	e9 4a f4 ff ff       	jmp    801064e9 <alltraps>

8010709f <vector174>:
.globl vector174
vector174:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $174
801070a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070a6:	e9 3e f4 ff ff       	jmp    801064e9 <alltraps>

801070ab <vector175>:
.globl vector175
vector175:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $175
801070ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070b2:	e9 32 f4 ff ff       	jmp    801064e9 <alltraps>

801070b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $176
801070b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070be:	e9 26 f4 ff ff       	jmp    801064e9 <alltraps>

801070c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $177
801070c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070ca:	e9 1a f4 ff ff       	jmp    801064e9 <alltraps>

801070cf <vector178>:
.globl vector178
vector178:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $178
801070d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070d6:	e9 0e f4 ff ff       	jmp    801064e9 <alltraps>

801070db <vector179>:
.globl vector179
vector179:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $179
801070dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070e2:	e9 02 f4 ff ff       	jmp    801064e9 <alltraps>

801070e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $180
801070e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070ee:	e9 f6 f3 ff ff       	jmp    801064e9 <alltraps>

801070f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $181
801070f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801070fa:	e9 ea f3 ff ff       	jmp    801064e9 <alltraps>

801070ff <vector182>:
.globl vector182
vector182:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $182
80107101:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107106:	e9 de f3 ff ff       	jmp    801064e9 <alltraps>

8010710b <vector183>:
.globl vector183
vector183:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $183
8010710d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107112:	e9 d2 f3 ff ff       	jmp    801064e9 <alltraps>

80107117 <vector184>:
.globl vector184
vector184:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $184
80107119:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010711e:	e9 c6 f3 ff ff       	jmp    801064e9 <alltraps>

80107123 <vector185>:
.globl vector185
vector185:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $185
80107125:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010712a:	e9 ba f3 ff ff       	jmp    801064e9 <alltraps>

8010712f <vector186>:
.globl vector186
vector186:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $186
80107131:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107136:	e9 ae f3 ff ff       	jmp    801064e9 <alltraps>

8010713b <vector187>:
.globl vector187
vector187:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $187
8010713d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107142:	e9 a2 f3 ff ff       	jmp    801064e9 <alltraps>

80107147 <vector188>:
.globl vector188
vector188:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $188
80107149:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010714e:	e9 96 f3 ff ff       	jmp    801064e9 <alltraps>

80107153 <vector189>:
.globl vector189
vector189:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $189
80107155:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010715a:	e9 8a f3 ff ff       	jmp    801064e9 <alltraps>

8010715f <vector190>:
.globl vector190
vector190:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $190
80107161:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107166:	e9 7e f3 ff ff       	jmp    801064e9 <alltraps>

8010716b <vector191>:
.globl vector191
vector191:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $191
8010716d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107172:	e9 72 f3 ff ff       	jmp    801064e9 <alltraps>

80107177 <vector192>:
.globl vector192
vector192:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $192
80107179:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010717e:	e9 66 f3 ff ff       	jmp    801064e9 <alltraps>

80107183 <vector193>:
.globl vector193
vector193:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $193
80107185:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010718a:	e9 5a f3 ff ff       	jmp    801064e9 <alltraps>

8010718f <vector194>:
.globl vector194
vector194:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $194
80107191:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107196:	e9 4e f3 ff ff       	jmp    801064e9 <alltraps>

8010719b <vector195>:
.globl vector195
vector195:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $195
8010719d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071a2:	e9 42 f3 ff ff       	jmp    801064e9 <alltraps>

801071a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $196
801071a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071ae:	e9 36 f3 ff ff       	jmp    801064e9 <alltraps>

801071b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $197
801071b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071ba:	e9 2a f3 ff ff       	jmp    801064e9 <alltraps>

801071bf <vector198>:
.globl vector198
vector198:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $198
801071c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071c6:	e9 1e f3 ff ff       	jmp    801064e9 <alltraps>

801071cb <vector199>:
.globl vector199
vector199:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $199
801071cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071d2:	e9 12 f3 ff ff       	jmp    801064e9 <alltraps>

801071d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $200
801071d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071de:	e9 06 f3 ff ff       	jmp    801064e9 <alltraps>

801071e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $201
801071e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071ea:	e9 fa f2 ff ff       	jmp    801064e9 <alltraps>

801071ef <vector202>:
.globl vector202
vector202:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $202
801071f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801071f6:	e9 ee f2 ff ff       	jmp    801064e9 <alltraps>

801071fb <vector203>:
.globl vector203
vector203:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $203
801071fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107202:	e9 e2 f2 ff ff       	jmp    801064e9 <alltraps>

80107207 <vector204>:
.globl vector204
vector204:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $204
80107209:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010720e:	e9 d6 f2 ff ff       	jmp    801064e9 <alltraps>

80107213 <vector205>:
.globl vector205
vector205:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $205
80107215:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010721a:	e9 ca f2 ff ff       	jmp    801064e9 <alltraps>

8010721f <vector206>:
.globl vector206
vector206:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $206
80107221:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107226:	e9 be f2 ff ff       	jmp    801064e9 <alltraps>

8010722b <vector207>:
.globl vector207
vector207:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $207
8010722d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107232:	e9 b2 f2 ff ff       	jmp    801064e9 <alltraps>

80107237 <vector208>:
.globl vector208
vector208:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $208
80107239:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010723e:	e9 a6 f2 ff ff       	jmp    801064e9 <alltraps>

80107243 <vector209>:
.globl vector209
vector209:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $209
80107245:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010724a:	e9 9a f2 ff ff       	jmp    801064e9 <alltraps>

8010724f <vector210>:
.globl vector210
vector210:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $210
80107251:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107256:	e9 8e f2 ff ff       	jmp    801064e9 <alltraps>

8010725b <vector211>:
.globl vector211
vector211:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $211
8010725d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107262:	e9 82 f2 ff ff       	jmp    801064e9 <alltraps>

80107267 <vector212>:
.globl vector212
vector212:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $212
80107269:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010726e:	e9 76 f2 ff ff       	jmp    801064e9 <alltraps>

80107273 <vector213>:
.globl vector213
vector213:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $213
80107275:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010727a:	e9 6a f2 ff ff       	jmp    801064e9 <alltraps>

8010727f <vector214>:
.globl vector214
vector214:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $214
80107281:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107286:	e9 5e f2 ff ff       	jmp    801064e9 <alltraps>

8010728b <vector215>:
.globl vector215
vector215:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $215
8010728d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107292:	e9 52 f2 ff ff       	jmp    801064e9 <alltraps>

80107297 <vector216>:
.globl vector216
vector216:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $216
80107299:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010729e:	e9 46 f2 ff ff       	jmp    801064e9 <alltraps>

801072a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $217
801072a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072aa:	e9 3a f2 ff ff       	jmp    801064e9 <alltraps>

801072af <vector218>:
.globl vector218
vector218:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $218
801072b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072b6:	e9 2e f2 ff ff       	jmp    801064e9 <alltraps>

801072bb <vector219>:
.globl vector219
vector219:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $219
801072bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072c2:	e9 22 f2 ff ff       	jmp    801064e9 <alltraps>

801072c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $220
801072c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072ce:	e9 16 f2 ff ff       	jmp    801064e9 <alltraps>

801072d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $221
801072d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072da:	e9 0a f2 ff ff       	jmp    801064e9 <alltraps>

801072df <vector222>:
.globl vector222
vector222:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $222
801072e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072e6:	e9 fe f1 ff ff       	jmp    801064e9 <alltraps>

801072eb <vector223>:
.globl vector223
vector223:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $223
801072ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801072f2:	e9 f2 f1 ff ff       	jmp    801064e9 <alltraps>

801072f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $224
801072f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801072fe:	e9 e6 f1 ff ff       	jmp    801064e9 <alltraps>

80107303 <vector225>:
.globl vector225
vector225:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $225
80107305:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010730a:	e9 da f1 ff ff       	jmp    801064e9 <alltraps>

8010730f <vector226>:
.globl vector226
vector226:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $226
80107311:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107316:	e9 ce f1 ff ff       	jmp    801064e9 <alltraps>

8010731b <vector227>:
.globl vector227
vector227:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $227
8010731d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107322:	e9 c2 f1 ff ff       	jmp    801064e9 <alltraps>

80107327 <vector228>:
.globl vector228
vector228:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $228
80107329:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010732e:	e9 b6 f1 ff ff       	jmp    801064e9 <alltraps>

80107333 <vector229>:
.globl vector229
vector229:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $229
80107335:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010733a:	e9 aa f1 ff ff       	jmp    801064e9 <alltraps>

8010733f <vector230>:
.globl vector230
vector230:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $230
80107341:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107346:	e9 9e f1 ff ff       	jmp    801064e9 <alltraps>

8010734b <vector231>:
.globl vector231
vector231:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $231
8010734d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107352:	e9 92 f1 ff ff       	jmp    801064e9 <alltraps>

80107357 <vector232>:
.globl vector232
vector232:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $232
80107359:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010735e:	e9 86 f1 ff ff       	jmp    801064e9 <alltraps>

80107363 <vector233>:
.globl vector233
vector233:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $233
80107365:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010736a:	e9 7a f1 ff ff       	jmp    801064e9 <alltraps>

8010736f <vector234>:
.globl vector234
vector234:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $234
80107371:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107376:	e9 6e f1 ff ff       	jmp    801064e9 <alltraps>

8010737b <vector235>:
.globl vector235
vector235:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $235
8010737d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107382:	e9 62 f1 ff ff       	jmp    801064e9 <alltraps>

80107387 <vector236>:
.globl vector236
vector236:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $236
80107389:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010738e:	e9 56 f1 ff ff       	jmp    801064e9 <alltraps>

80107393 <vector237>:
.globl vector237
vector237:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $237
80107395:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010739a:	e9 4a f1 ff ff       	jmp    801064e9 <alltraps>

8010739f <vector238>:
.globl vector238
vector238:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $238
801073a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073a6:	e9 3e f1 ff ff       	jmp    801064e9 <alltraps>

801073ab <vector239>:
.globl vector239
vector239:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $239
801073ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073b2:	e9 32 f1 ff ff       	jmp    801064e9 <alltraps>

801073b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $240
801073b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073be:	e9 26 f1 ff ff       	jmp    801064e9 <alltraps>

801073c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $241
801073c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073ca:	e9 1a f1 ff ff       	jmp    801064e9 <alltraps>

801073cf <vector242>:
.globl vector242
vector242:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $242
801073d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073d6:	e9 0e f1 ff ff       	jmp    801064e9 <alltraps>

801073db <vector243>:
.globl vector243
vector243:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $243
801073dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073e2:	e9 02 f1 ff ff       	jmp    801064e9 <alltraps>

801073e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $244
801073e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073ee:	e9 f6 f0 ff ff       	jmp    801064e9 <alltraps>

801073f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $245
801073f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801073fa:	e9 ea f0 ff ff       	jmp    801064e9 <alltraps>

801073ff <vector246>:
.globl vector246
vector246:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $246
80107401:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107406:	e9 de f0 ff ff       	jmp    801064e9 <alltraps>

8010740b <vector247>:
.globl vector247
vector247:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $247
8010740d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107412:	e9 d2 f0 ff ff       	jmp    801064e9 <alltraps>

80107417 <vector248>:
.globl vector248
vector248:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $248
80107419:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010741e:	e9 c6 f0 ff ff       	jmp    801064e9 <alltraps>

80107423 <vector249>:
.globl vector249
vector249:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $249
80107425:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010742a:	e9 ba f0 ff ff       	jmp    801064e9 <alltraps>

8010742f <vector250>:
.globl vector250
vector250:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $250
80107431:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107436:	e9 ae f0 ff ff       	jmp    801064e9 <alltraps>

8010743b <vector251>:
.globl vector251
vector251:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $251
8010743d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107442:	e9 a2 f0 ff ff       	jmp    801064e9 <alltraps>

80107447 <vector252>:
.globl vector252
vector252:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $252
80107449:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010744e:	e9 96 f0 ff ff       	jmp    801064e9 <alltraps>

80107453 <vector253>:
.globl vector253
vector253:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $253
80107455:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010745a:	e9 8a f0 ff ff       	jmp    801064e9 <alltraps>

8010745f <vector254>:
.globl vector254
vector254:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $254
80107461:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107466:	e9 7e f0 ff ff       	jmp    801064e9 <alltraps>

8010746b <vector255>:
.globl vector255
vector255:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $255
8010746d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107472:	e9 72 f0 ff ff       	jmp    801064e9 <alltraps>
80107477:	66 90                	xchg   %ax,%ax
80107479:	66 90                	xchg   %ax,%ax
8010747b:	66 90                	xchg   %ax,%ax
8010747d:	66 90                	xchg   %ax,%ax
8010747f:	90                   	nop

80107480 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80107486:	89 d3                	mov    %edx,%ebx
{
80107488:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010748a:	c1 eb 16             	shr    $0x16,%ebx
8010748d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107490:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107493:	8b 06                	mov    (%esi),%eax
80107495:	a8 01                	test   $0x1,%al
80107497:	74 27                	je     801074c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107499:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010749e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801074a4:	c1 ef 0a             	shr    $0xa,%edi
}
801074a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801074aa:	89 fa                	mov    %edi,%edx
801074ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801074b5:	5b                   	pop    %ebx
801074b6:	5e                   	pop    %esi
801074b7:	5f                   	pop    %edi
801074b8:	5d                   	pop    %ebp
801074b9:	c3                   	ret    
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074c0:	85 c9                	test   %ecx,%ecx
801074c2:	74 2c                	je     801074f0 <walkpgdir+0x70>
801074c4:	e8 77 b8 ff ff       	call   80102d40 <kalloc>
801074c9:	85 c0                	test   %eax,%eax
801074cb:	89 c3                	mov    %eax,%ebx
801074cd:	74 21                	je     801074f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074cf:	83 ec 04             	sub    $0x4,%esp
801074d2:	68 00 10 00 00       	push   $0x1000
801074d7:	6a 00                	push   $0x0
801074d9:	50                   	push   %eax
801074da:	e8 c1 dd ff ff       	call   801052a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074e5:	83 c4 10             	add    $0x10,%esp
801074e8:	83 c8 07             	or     $0x7,%eax
801074eb:	89 06                	mov    %eax,(%esi)
801074ed:	eb b5                	jmp    801074a4 <walkpgdir+0x24>
801074ef:	90                   	nop
}
801074f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801074f3:	31 c0                	xor    %eax,%eax
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107506:	89 d3                	mov    %edx,%ebx
80107508:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010750e:	83 ec 1c             	sub    $0x1c,%esp
80107511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107514:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107518:	8b 7d 08             	mov    0x8(%ebp),%edi
8010751b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107520:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107523:	8b 45 0c             	mov    0xc(%ebp),%eax
80107526:	29 df                	sub    %ebx,%edi
80107528:	83 c8 01             	or     $0x1,%eax
8010752b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010752e:	eb 15                	jmp    80107545 <mappages+0x45>
    if(*pte & PTE_P)
80107530:	f6 00 01             	testb  $0x1,(%eax)
80107533:	75 45                	jne    8010757a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107535:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107538:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010753b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010753d:	74 31                	je     80107570 <mappages+0x70>
      break;
    a += PGSIZE;
8010753f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107548:	b9 01 00 00 00       	mov    $0x1,%ecx
8010754d:	89 da                	mov    %ebx,%edx
8010754f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107552:	e8 29 ff ff ff       	call   80107480 <walkpgdir>
80107557:	85 c0                	test   %eax,%eax
80107559:	75 d5                	jne    80107530 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010755b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010755e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107563:	5b                   	pop    %ebx
80107564:	5e                   	pop    %esi
80107565:	5f                   	pop    %edi
80107566:	5d                   	pop    %ebp
80107567:	c3                   	ret    
80107568:	90                   	nop
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107573:	31 c0                	xor    %eax,%eax
}
80107575:	5b                   	pop    %ebx
80107576:	5e                   	pop    %esi
80107577:	5f                   	pop    %edi
80107578:	5d                   	pop    %ebp
80107579:	c3                   	ret    
      panic("remap");
8010757a:	83 ec 0c             	sub    $0xc,%esp
8010757d:	68 34 9b 10 80       	push   $0x80109b34
80107582:	e8 09 8e ff ff       	call   80100390 <panic>
80107587:	89 f6                	mov    %esi,%esi
80107589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107590 <printlist>:
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	56                   	push   %esi
80107594:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
80107595:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	68 3a 9b 10 80       	push   $0x80109b3a
801075a2:	e8 b9 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
801075a7:	e8 34 cd ff ff       	call   801042e0 <myproc>
801075ac:	83 c4 10             	add    $0x10,%esp
801075af:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
801075b5:	eb 0e                	jmp    801075c5 <printlist+0x35>
801075b7:	89 f6                	mov    %esi,%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
801075c0:	83 ee 01             	sub    $0x1,%esi
801075c3:	74 19                	je     801075de <printlist+0x4e>
    cprintf("%d -> ", curr->off);
801075c5:	83 ec 08             	sub    $0x8,%esp
801075c8:	ff 33                	pushl  (%ebx)
801075ca:	68 4a 9b 10 80       	push   $0x80109b4a
801075cf:	e8 8c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801075d4:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
801075d7:	83 c4 10             	add    $0x10,%esp
801075da:	85 db                	test   %ebx,%ebx
801075dc:	75 e2                	jne    801075c0 <printlist+0x30>
  cprintf("\n");
801075de:	83 ec 0c             	sub    $0xc,%esp
801075e1:	68 c7 9d 10 80       	push   $0x80109dc7
801075e6:	e8 75 90 ff ff       	call   80100660 <cprintf>
}
801075eb:	83 c4 10             	add    $0x10,%esp
801075ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075f1:	5b                   	pop    %ebx
801075f2:	5e                   	pop    %esi
801075f3:	5d                   	pop    %ebp
801075f4:	c3                   	ret    
801075f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107600 <printaq>:
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	53                   	push   %ebx
80107604:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107607:	68 51 9b 10 80       	push   $0x80109b51
8010760c:	e8 4f 90 ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107611:	e8 ca cc ff ff       	call   801042e0 <myproc>
80107616:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010761c:	8b 58 08             	mov    0x8(%eax),%ebx
8010761f:	e8 bc cc ff ff       	call   801042e0 <myproc>
80107624:	83 c4 0c             	add    $0xc,%esp
80107627:	53                   	push   %ebx
80107628:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010762e:	ff 70 08             	pushl  0x8(%eax)
80107631:	68 63 9b 10 80       	push   $0x80109b63
80107636:	e8 25 90 ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010763b:	e8 a0 cc ff ff       	call   801042e0 <myproc>
80107640:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107646:	83 c4 10             	add    $0x10,%esp
80107649:	8b 50 04             	mov    0x4(%eax),%edx
8010764c:	85 d2                	test   %edx,%edx
8010764e:	74 68                	je     801076b8 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107650:	e8 8b cc ff ff       	call   801042e0 <myproc>
80107655:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010765b:	85 db                	test   %ebx,%ebx
8010765d:	74 1a                	je     80107679 <printaq+0x79>
8010765f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107660:	83 ec 08             	sub    $0x8,%esp
80107663:	ff 73 08             	pushl  0x8(%ebx)
80107666:	68 81 9b 10 80       	push   $0x80109b81
8010766b:	e8 f0 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107670:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
80107672:	83 c4 10             	add    $0x10,%esp
80107675:	85 db                	test   %ebx,%ebx
80107677:	75 e7                	jne    80107660 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
80107679:	e8 62 cc ff ff       	call   801042e0 <myproc>
8010767e:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107684:	8b 00                	mov    (%eax),%eax
80107686:	85 c0                	test   %eax,%eax
80107688:	74 16                	je     801076a0 <printaq+0xa0>
  cprintf("\n");
8010768a:	83 ec 0c             	sub    $0xc,%esp
8010768d:	68 c7 9d 10 80       	push   $0x80109dc7
80107692:	e8 c9 8f ff ff       	call   80100660 <cprintf>
}
80107697:	83 c4 10             	add    $0x10,%esp
8010769a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010769d:	c9                   	leave  
8010769e:	c3                   	ret    
8010769f:	90                   	nop
    cprintf("null <-> ");
801076a0:	83 ec 0c             	sub    $0xc,%esp
801076a3:	68 77 9b 10 80       	push   $0x80109b77
801076a8:	e8 b3 8f ff ff       	call   80100660 <cprintf>
801076ad:	83 c4 10             	add    $0x10,%esp
801076b0:	eb d8                	jmp    8010768a <printaq+0x8a>
801076b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801076b8:	83 ec 0c             	sub    $0xc,%esp
801076bb:	68 77 9b 10 80       	push   $0x80109b77
801076c0:	e8 9b 8f ff ff       	call   80100660 <cprintf>
801076c5:	83 c4 10             	add    $0x10,%esp
801076c8:	eb 86                	jmp    80107650 <printaq+0x50>
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076d0 <seginit>:
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801076d6:	e8 e5 cb ff ff       	call   801042c0 <cpuid>
801076db:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801076e1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801076e6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076ea:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
801076f1:	ff 00 00 
801076f4:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
801076fb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801076fe:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107705:	ff 00 00 
80107708:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010770f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107712:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107719:	ff 00 00 
8010771c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107723:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107726:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010772d:	ff 00 00 
80107730:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107737:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010773a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
8010773f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107743:	c1 e8 10             	shr    $0x10,%eax
80107746:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010774a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010774d:	0f 01 10             	lgdtl  (%eax)
}
80107750:	c9                   	leave  
80107751:	c3                   	ret    
80107752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107760 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107760:	a1 84 75 19 80       	mov    0x80197584,%eax
{
80107765:	55                   	push   %ebp
80107766:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107768:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010776d:	0f 22 d8             	mov    %eax,%cr3
}
80107770:	5d                   	pop    %ebp
80107771:	c3                   	ret    
80107772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107780 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
80107786:	83 ec 1c             	sub    $0x1c,%esp
80107789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010778c:	85 db                	test   %ebx,%ebx
8010778e:	0f 84 cb 00 00 00    	je     8010785f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107794:	8b 43 08             	mov    0x8(%ebx),%eax
80107797:	85 c0                	test   %eax,%eax
80107799:	0f 84 da 00 00 00    	je     80107879 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010779f:	8b 43 04             	mov    0x4(%ebx),%eax
801077a2:	85 c0                	test   %eax,%eax
801077a4:	0f 84 c2 00 00 00    	je     8010786c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801077aa:	e8 11 d9 ff ff       	call   801050c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077af:	e8 8c ca ff ff       	call   80104240 <mycpu>
801077b4:	89 c6                	mov    %eax,%esi
801077b6:	e8 85 ca ff ff       	call   80104240 <mycpu>
801077bb:	89 c7                	mov    %eax,%edi
801077bd:	e8 7e ca ff ff       	call   80104240 <mycpu>
801077c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077c5:	83 c7 08             	add    $0x8,%edi
801077c8:	e8 73 ca ff ff       	call   80104240 <mycpu>
801077cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801077d0:	83 c0 08             	add    $0x8,%eax
801077d3:	ba 67 00 00 00       	mov    $0x67,%edx
801077d8:	c1 e8 18             	shr    $0x18,%eax
801077db:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801077e2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801077e9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801077ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077f4:	83 c1 08             	add    $0x8,%ecx
801077f7:	c1 e9 10             	shr    $0x10,%ecx
801077fa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107800:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107805:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010780c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107811:	e8 2a ca ff ff       	call   80104240 <mycpu>
80107816:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010781d:	e8 1e ca ff ff       	call   80104240 <mycpu>
80107822:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107826:	8b 73 08             	mov    0x8(%ebx),%esi
80107829:	e8 12 ca ff ff       	call   80104240 <mycpu>
8010782e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107834:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107837:	e8 04 ca ff ff       	call   80104240 <mycpu>
8010783c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107840:	b8 28 00 00 00       	mov    $0x28,%eax
80107845:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107848:	8b 43 04             	mov    0x4(%ebx),%eax
8010784b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107850:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	5b                   	pop    %ebx
80107857:	5e                   	pop    %esi
80107858:	5f                   	pop    %edi
80107859:	5d                   	pop    %ebp
  popcli();
8010785a:	e9 a1 d8 ff ff       	jmp    80105100 <popcli>
    panic("switchuvm: no process");
8010785f:	83 ec 0c             	sub    $0xc,%esp
80107862:	68 89 9b 10 80       	push   $0x80109b89
80107867:	e8 24 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010786c:	83 ec 0c             	sub    $0xc,%esp
8010786f:	68 b4 9b 10 80       	push   $0x80109bb4
80107874:	e8 17 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	68 9f 9b 10 80       	push   $0x80109b9f
80107881:	e8 0a 8b ff ff       	call   80100390 <panic>
80107886:	8d 76 00             	lea    0x0(%esi),%esi
80107889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107890 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 1c             	sub    $0x1c,%esp
80107899:	8b 75 10             	mov    0x10(%ebp),%esi
8010789c:	8b 45 08             	mov    0x8(%ebp),%eax
8010789f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801078a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801078a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801078ab:	77 49                	ja     801078f6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801078ad:	e8 8e b4 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
801078b2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801078b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801078b7:	68 00 10 00 00       	push   $0x1000
801078bc:	6a 00                	push   $0x0
801078be:	50                   	push   %eax
801078bf:	e8 dc d9 ff ff       	call   801052a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078c4:	58                   	pop    %eax
801078c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078d0:	5a                   	pop    %edx
801078d1:	6a 06                	push   $0x6
801078d3:	50                   	push   %eax
801078d4:	31 d2                	xor    %edx,%edx
801078d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078d9:	e8 22 fc ff ff       	call   80107500 <mappages>
  memmove(mem, init, sz);
801078de:	89 75 10             	mov    %esi,0x10(%ebp)
801078e1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801078e4:	83 c4 10             	add    $0x10,%esp
801078e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801078ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ed:	5b                   	pop    %ebx
801078ee:	5e                   	pop    %esi
801078ef:	5f                   	pop    %edi
801078f0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801078f1:	e9 5a da ff ff       	jmp    80105350 <memmove>
    panic("inituvm: more than a page");
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	68 c8 9b 10 80       	push   $0x80109bc8
801078fe:	e8 8d 8a ff ff       	call   80100390 <panic>
80107903:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107910 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
80107915:	53                   	push   %ebx
80107916:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107919:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107920:	0f 85 91 00 00 00    	jne    801079b7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107926:	8b 75 18             	mov    0x18(%ebp),%esi
80107929:	31 db                	xor    %ebx,%ebx
8010792b:	85 f6                	test   %esi,%esi
8010792d:	75 1a                	jne    80107949 <loaduvm+0x39>
8010792f:	eb 6f                	jmp    801079a0 <loaduvm+0x90>
80107931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107938:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010793e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107944:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107947:	76 57                	jbe    801079a0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107949:	8b 55 0c             	mov    0xc(%ebp),%edx
8010794c:	8b 45 08             	mov    0x8(%ebp),%eax
8010794f:	31 c9                	xor    %ecx,%ecx
80107951:	01 da                	add    %ebx,%edx
80107953:	e8 28 fb ff ff       	call   80107480 <walkpgdir>
80107958:	85 c0                	test   %eax,%eax
8010795a:	74 4e                	je     801079aa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010795c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010795e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107961:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107966:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010796b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107971:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107974:	01 d9                	add    %ebx,%ecx
80107976:	05 00 00 00 80       	add    $0x80000000,%eax
8010797b:	57                   	push   %edi
8010797c:	51                   	push   %ecx
8010797d:	50                   	push   %eax
8010797e:	ff 75 10             	pushl  0x10(%ebp)
80107981:	e8 9a a3 ff ff       	call   80101d20 <readi>
80107986:	83 c4 10             	add    $0x10,%esp
80107989:	39 f8                	cmp    %edi,%eax
8010798b:	74 ab                	je     80107938 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010798d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107995:	5b                   	pop    %ebx
80107996:	5e                   	pop    %esi
80107997:	5f                   	pop    %edi
80107998:	5d                   	pop    %ebp
80107999:	c3                   	ret    
8010799a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079a3:	31 c0                	xor    %eax,%eax
}
801079a5:	5b                   	pop    %ebx
801079a6:	5e                   	pop    %esi
801079a7:	5f                   	pop    %edi
801079a8:	5d                   	pop    %ebp
801079a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801079aa:	83 ec 0c             	sub    $0xc,%esp
801079ad:	68 e2 9b 10 80       	push   $0x80109be2
801079b2:	e8 d9 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801079b7:	83 ec 0c             	sub    $0xc,%esp
801079ba:	68 20 9e 10 80       	push   $0x80109e20
801079bf:	e8 cc 89 ff ff       	call   80100390 <panic>
801079c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079d0 <update_selectionfiled_allocuvm>:
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
}

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	56                   	push   %esi
801079d4:	53                   	push   %ebx
801079d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801079d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(curproc->selection == SCFIFO)
801079db:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
801079e1:	83 f8 03             	cmp    $0x3,%eax
801079e4:	75 0d                	jne    801079f3 <update_selectionfiled_allocuvm+0x23>
  {
    page->ref_bit = 0;
801079e6:	c7 42 10 00 00 00 00 	movl   $0x0,0x10(%edx)
801079ed:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }
  if(curproc->selection == NFUA)
801079f3:	83 f8 01             	cmp    $0x1,%eax
801079f6:	75 0d                	jne    80107a05 <update_selectionfiled_allocuvm+0x35>
  {
    page->nfua_counter = 0;
801079f8:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
801079ff:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }
  if(curproc->selection == LAPA)
80107a05:	83 f8 02             	cmp    $0x2,%eax
80107a08:	75 0d                	jne    80107a17 <update_selectionfiled_allocuvm+0x47>
  {
    page->lapa_counter = 0xFFFFFFFF;
80107a0a:	c7 42 18 ff ff ff ff 	movl   $0xffffffff,0x18(%edx)
80107a11:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }
  if(curproc -> selection == AQ)
80107a17:	83 f8 04             	cmp    $0x4,%eax
80107a1a:	74 0c                	je     80107a28 <update_selectionfiled_allocuvm+0x58>
      curproc->queue_head = node;
      curproc->queue_head->prev = 0;
    }
  }

}
80107a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a1f:	5b                   	pop    %ebx
80107a20:	5e                   	pop    %esi
80107a21:	5d                   	pop    %ebp
80107a22:	c3                   	ret    
80107a23:	90                   	nop
80107a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct queue_node * node = (struct queue_node*)kalloc();
80107a28:	e8 13 b3 ff ff       	call   80102d40 <kalloc>
80107a2d:	89 c6                	mov    %eax,%esi
    node->page_index = page_ramindex;
80107a2f:	8b 45 10             	mov    0x10(%ebp),%eax
    cprintf("page ram index is: %d\n", page_ramindex);
80107a32:	83 ec 08             	sub    $0x8,%esp
    node->page_index = page_ramindex;
80107a35:	89 46 08             	mov    %eax,0x8(%esi)
    cprintf("page ram index is: %d\n", page_ramindex);
80107a38:	50                   	push   %eax
80107a39:	68 00 9c 10 80       	push   $0x80109c00
80107a3e:	e8 1d 8c ff ff       	call   80100660 <cprintf>
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
80107a43:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a49:	83 c4 10             	add    $0x10,%esp
80107a4c:	85 c0                	test   %eax,%eax
80107a4e:	74 20                	je     80107a70 <update_selectionfiled_allocuvm+0xa0>
      curproc->queue_head->prev = node;
80107a50:	89 70 04             	mov    %esi,0x4(%eax)
      node->next = curproc->queue_head;
80107a53:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a59:	89 06                	mov    %eax,(%esi)
      curproc->queue_head = node;
80107a5b:	89 b3 1c 04 00 00    	mov    %esi,0x41c(%ebx)
      curproc->queue_head->prev = 0;
80107a61:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
}
80107a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a6b:	5b                   	pop    %ebx
80107a6c:	5e                   	pop    %esi
80107a6d:	5d                   	pop    %ebp
80107a6e:	c3                   	ret    
80107a6f:	90                   	nop
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
80107a70:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80107a76:	85 d2                	test   %edx,%edx
80107a78:	75 d6                	jne    80107a50 <update_selectionfiled_allocuvm+0x80>
      curproc-> queue_head = node;
80107a7a:	89 b3 1c 04 00 00    	mov    %esi,0x41c(%ebx)
      curproc-> queue_tail = node;
80107a80:	89 b3 20 04 00 00    	mov    %esi,0x420(%ebx)
      curproc-> queue_head->next = 0;
80107a86:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      curproc-> queue_head->prev = 0;
80107a8c:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      curproc-> queue_head->next = 0;
80107a99:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc-> queue_head->prev = 0;
80107aa5:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80107ab2:	e9 65 ff ff ff       	jmp    80107a1c <update_selectionfiled_allocuvm+0x4c>
80107ab7:	89 f6                	mov    %esi,%esi
80107ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ac0 <allocuvm_noswap>:
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 10             	sub    $0x10,%esp
80107ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107acc:	8b 75 10             	mov    0x10(%ebp),%esi
  page->pgdir = pgdir;
80107acf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107ad2:	8b 8b 08 04 00 00    	mov    0x408(%ebx),%ecx
  page->isused = 1;
80107ad8:	6b d1 1c             	imul   $0x1c,%ecx,%edx
80107adb:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  page->pgdir = pgdir;
80107ade:	89 b8 48 02 00 00    	mov    %edi,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107ae4:	89 b0 50 02 00 00    	mov    %esi,0x250(%eax)
  page->isused = 1;
80107aea:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107af1:	00 00 00 
  page->swap_offset = -1;
80107af4:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107afb:	ff ff ff 
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107afe:	8d 84 13 48 02 00 00 	lea    0x248(%ebx,%edx,1),%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
80107b05:	51                   	push   %ecx
80107b06:	50                   	push   %eax
80107b07:	53                   	push   %ebx
80107b08:	e8 c3 fe ff ff       	call   801079d0 <update_selectionfiled_allocuvm>
  cprintf("filling ram slot: %d\n", curproc->num_ram);
80107b0d:	58                   	pop    %eax
80107b0e:	5a                   	pop    %edx
80107b0f:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80107b15:	68 17 9c 10 80       	push   $0x80109c17
80107b1a:	e8 41 8b ff ff       	call   80100660 <cprintf>
  cprintf("allocating addr : %p\n", rounded_virtaddr);
80107b1f:	59                   	pop    %ecx
80107b20:	5f                   	pop    %edi
80107b21:	56                   	push   %esi
80107b22:	68 2d 9c 10 80       	push   $0x80109c2d
80107b27:	e8 34 8b ff ff       	call   80100660 <cprintf>
  curproc->num_ram++;
80107b2c:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
}
80107b33:	83 c4 10             	add    $0x10,%esp
80107b36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b39:	5b                   	pop    %ebx
80107b3a:	5e                   	pop    %esi
80107b3b:	5f                   	pop    %edi
80107b3c:	5d                   	pop    %ebp
80107b3d:	c3                   	ret    
80107b3e:	66 90                	xchg   %ax,%ax

80107b40 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	56                   	push   %esi
80107b45:	53                   	push   %ebx
80107b46:	83 ec 5c             	sub    $0x5c,%esp
80107b49:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107b4c:	e8 8f c7 ff ff       	call   801042e0 <myproc>
80107b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107b54:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b57:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b5a:	0f 83 a3 00 00 00    	jae    80107c03 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107b60:	8b 45 10             	mov    0x10(%ebp),%eax
80107b63:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107b69:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107b6f:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b72:	77 6a                	ja     80107bde <deallocuvm+0x9e>
80107b74:	e9 87 00 00 00       	jmp    80107c00 <deallocuvm+0xc0>
80107b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107b80:	8b 00                	mov    (%eax),%eax
80107b82:	a8 01                	test   $0x1,%al
80107b84:	74 4d                	je     80107bd3 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b8b:	0f 84 b3 01 00 00    	je     80107d44 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107b91:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107b97:	83 ec 0c             	sub    $0xc,%esp
80107b9a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b9d:	53                   	push   %ebx
80107b9e:	e8 2d b3 ff ff       	call   80102ed0 <getRefs>
80107ba3:	83 c4 10             	add    $0x10,%esp
80107ba6:	83 f8 01             	cmp    $0x1,%eax
80107ba9:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107bac:	0f 84 7e 01 00 00    	je     80107d30 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107bb2:	83 ec 0c             	sub    $0xc,%esp
80107bb5:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107bb8:	53                   	push   %ebx
80107bb9:	e8 32 b2 ff ff       	call   80102df0 <refDec>
80107bbe:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107bc1:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107bc4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107bc7:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107bcb:	7f 43                	jg     80107c10 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107bcd:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107bd3:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107bd9:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107bdc:	76 22                	jbe    80107c00 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107bde:	31 c9                	xor    %ecx,%ecx
80107be0:	89 f2                	mov    %esi,%edx
80107be2:	89 f8                	mov    %edi,%eax
80107be4:	e8 97 f8 ff ff       	call   80107480 <walkpgdir>
    if(!pte)
80107be9:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107beb:	89 c2                	mov    %eax,%edx
    if(!pte)
80107bed:	75 91                	jne    80107b80 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107bef:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107bf5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107bfb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107bfe:	77 de                	ja     80107bde <deallocuvm+0x9e>
    }
  }
  return newsz;
80107c00:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c06:	5b                   	pop    %ebx
80107c07:	5e                   	pop    %esi
80107c08:	5f                   	pop    %edi
80107c09:	5d                   	pop    %ebp
80107c0a:	c3                   	ret    
80107c0b:	90                   	nop
80107c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c10:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107c16:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107c19:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107c1f:	89 fa                	mov    %edi,%edx
80107c21:	89 cf                	mov    %ecx,%edi
80107c23:	eb 17                	jmp    80107c3c <deallocuvm+0xfc>
80107c25:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107c28:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107c2b:	0f 84 b7 00 00 00    	je     80107ce8 <deallocuvm+0x1a8>
80107c31:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107c34:	39 fb                	cmp    %edi,%ebx
80107c36:	0f 84 e4 00 00 00    	je     80107d20 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107c3c:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107c42:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107c45:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107c4b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107c4e:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107c54:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107c57:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107c5d:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107c60:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107c63:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107c69:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107c6c:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107c72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107c75:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107c7b:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107c7e:	8b 03                	mov    (%ebx),%eax
80107c80:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107c83:	8b 43 04             	mov    0x4(%ebx),%eax
80107c86:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107c89:	8b 43 08             	mov    0x8(%ebx),%eax
80107c8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107c8f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107c92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107c95:	8b 43 10             	mov    0x10(%ebx),%eax
80107c98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107c9b:	8b 43 14             	mov    0x14(%ebx),%eax
80107c9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ca1:	8b 43 18             	mov    0x18(%ebx),%eax
80107ca4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107ca7:	0f 85 7b ff ff ff    	jne    80107c28 <deallocuvm+0xe8>
80107cad:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107cb0:	0f 85 72 ff ff ff    	jne    80107c28 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107cb6:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107cb9:	83 ec 04             	sub    $0x4,%esp
80107cbc:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107cbf:	6a 1c                	push   $0x1c
80107cc1:	6a 00                	push   $0x0
80107cc3:	50                   	push   %eax
80107cc4:	e8 d7 d5 ff ff       	call   801052a0 <memset>
            curproc->num_ram -- ;
80107cc9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107ccc:	83 c4 10             	add    $0x10,%esp
80107ccf:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107cd2:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107cd9:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107cdc:	0f 85 4f ff ff ff    	jne    80107c31 <deallocuvm+0xf1>
80107ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ce8:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107ceb:	0f 85 40 ff ff ff    	jne    80107c31 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107cf1:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107cf4:	83 ec 04             	sub    $0x4,%esp
80107cf7:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107cfa:	6a 1c                	push   $0x1c
80107cfc:	6a 00                	push   $0x0
80107cfe:	83 c3 1c             	add    $0x1c,%ebx
80107d01:	50                   	push   %eax
80107d02:	e8 99 d5 ff ff       	call   801052a0 <memset>
            curproc->num_swap --;
80107d07:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107d0a:	83 c4 10             	add    $0x10,%esp
80107d0d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107d10:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d17:	39 fb                	cmp    %edi,%ebx
80107d19:	0f 85 1d ff ff ff    	jne    80107c3c <deallocuvm+0xfc>
80107d1f:	90                   	nop
80107d20:	89 d7                	mov    %edx,%edi
80107d22:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107d25:	e9 a3 fe ff ff       	jmp    80107bcd <deallocuvm+0x8d>
80107d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107d30:	83 ec 0c             	sub    $0xc,%esp
80107d33:	53                   	push   %ebx
80107d34:	e8 27 ad ff ff       	call   80102a60 <kfree>
80107d39:	83 c4 10             	add    $0x10,%esp
80107d3c:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107d3f:	e9 80 fe ff ff       	jmp    80107bc4 <deallocuvm+0x84>
        panic("kfree");
80107d44:	83 ec 0c             	sub    $0xc,%esp
80107d47:	68 a2 93 10 80       	push   $0x801093a2
80107d4c:	e8 3f 86 ff ff       	call   80100390 <panic>
80107d51:	eb 0d                	jmp    80107d60 <freevm>
80107d53:	90                   	nop
80107d54:	90                   	nop
80107d55:	90                   	nop
80107d56:	90                   	nop
80107d57:	90                   	nop
80107d58:	90                   	nop
80107d59:	90                   	nop
80107d5a:	90                   	nop
80107d5b:	90                   	nop
80107d5c:	90                   	nop
80107d5d:	90                   	nop
80107d5e:	90                   	nop
80107d5f:	90                   	nop

80107d60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	57                   	push   %edi
80107d64:	56                   	push   %esi
80107d65:	53                   	push   %ebx
80107d66:	83 ec 0c             	sub    $0xc,%esp
80107d69:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107d6c:	85 f6                	test   %esi,%esi
80107d6e:	74 59                	je     80107dc9 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107d70:	83 ec 04             	sub    $0x4,%esp
80107d73:	89 f3                	mov    %esi,%ebx
80107d75:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107d7b:	6a 00                	push   $0x0
80107d7d:	68 00 00 00 80       	push   $0x80000000
80107d82:	56                   	push   %esi
80107d83:	e8 b8 fd ff ff       	call   80107b40 <deallocuvm>
80107d88:	83 c4 10             	add    $0x10,%esp
80107d8b:	eb 0a                	jmp    80107d97 <freevm+0x37>
80107d8d:	8d 76 00             	lea    0x0(%esi),%esi
80107d90:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107d93:	39 fb                	cmp    %edi,%ebx
80107d95:	74 23                	je     80107dba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d97:	8b 03                	mov    (%ebx),%eax
80107d99:	a8 01                	test   $0x1,%al
80107d9b:	74 f3                	je     80107d90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107da2:	83 ec 0c             	sub    $0xc,%esp
80107da5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107da8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107dad:	50                   	push   %eax
80107dae:	e8 ad ac ff ff       	call   80102a60 <kfree>
80107db3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107db6:	39 fb                	cmp    %edi,%ebx
80107db8:	75 dd                	jne    80107d97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107dba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dc0:	5b                   	pop    %ebx
80107dc1:	5e                   	pop    %esi
80107dc2:	5f                   	pop    %edi
80107dc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107dc4:	e9 97 ac ff ff       	jmp    80102a60 <kfree>
    panic("freevm: no pgdir");
80107dc9:	83 ec 0c             	sub    $0xc,%esp
80107dcc:	68 43 9c 10 80       	push   $0x80109c43
80107dd1:	e8 ba 85 ff ff       	call   80100390 <panic>
80107dd6:	8d 76 00             	lea    0x0(%esi),%esi
80107dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107de0 <setupkvm>:
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	56                   	push   %esi
80107de4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107de5:	e8 56 af ff ff       	call   80102d40 <kalloc>
80107dea:	85 c0                	test   %eax,%eax
80107dec:	89 c6                	mov    %eax,%esi
80107dee:	74 42                	je     80107e32 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107df0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107df3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107df8:	68 00 10 00 00       	push   $0x1000
80107dfd:	6a 00                	push   $0x0
80107dff:	50                   	push   %eax
80107e00:	e8 9b d4 ff ff       	call   801052a0 <memset>
80107e05:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107e08:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107e0b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107e0e:	83 ec 08             	sub    $0x8,%esp
80107e11:	8b 13                	mov    (%ebx),%edx
80107e13:	ff 73 0c             	pushl  0xc(%ebx)
80107e16:	50                   	push   %eax
80107e17:	29 c1                	sub    %eax,%ecx
80107e19:	89 f0                	mov    %esi,%eax
80107e1b:	e8 e0 f6 ff ff       	call   80107500 <mappages>
80107e20:	83 c4 10             	add    $0x10,%esp
80107e23:	85 c0                	test   %eax,%eax
80107e25:	78 19                	js     80107e40 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107e27:	83 c3 10             	add    $0x10,%ebx
80107e2a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107e30:	75 d6                	jne    80107e08 <setupkvm+0x28>
}
80107e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e35:	89 f0                	mov    %esi,%eax
80107e37:	5b                   	pop    %ebx
80107e38:	5e                   	pop    %esi
80107e39:	5d                   	pop    %ebp
80107e3a:	c3                   	ret    
80107e3b:	90                   	nop
80107e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80107e40:	83 ec 0c             	sub    $0xc,%esp
80107e43:	68 54 9c 10 80       	push   $0x80109c54
80107e48:	e8 13 88 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
80107e4d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107e50:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e52:	e8 09 ff ff ff       	call   80107d60 <freevm>
      return 0;
80107e57:	83 c4 10             	add    $0x10,%esp
}
80107e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e5d:	89 f0                	mov    %esi,%eax
80107e5f:	5b                   	pop    %ebx
80107e60:	5e                   	pop    %esi
80107e61:	5d                   	pop    %ebp
80107e62:	c3                   	ret    
80107e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e70 <kvmalloc>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e76:	e8 65 ff ff ff       	call   80107de0 <setupkvm>
80107e7b:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e80:	05 00 00 00 80       	add    $0x80000000,%eax
80107e85:	0f 22 d8             	mov    %eax,%cr3
}
80107e88:	c9                   	leave  
80107e89:	c3                   	ret    
80107e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e91:	31 c9                	xor    %ecx,%ecx
{
80107e93:	89 e5                	mov    %esp,%ebp
80107e95:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9e:	e8 dd f5 ff ff       	call   80107480 <walkpgdir>
  if(pte == 0)
80107ea3:	85 c0                	test   %eax,%eax
80107ea5:	74 05                	je     80107eac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ea7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107eaa:	c9                   	leave  
80107eab:	c3                   	ret    
    panic("clearpteu");
80107eac:	83 ec 0c             	sub    $0xc,%esp
80107eaf:	68 70 9c 10 80       	push   $0x80109c70
80107eb4:	e8 d7 84 ff ff       	call   80100390 <panic>
80107eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ec0 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107ec9:	e8 12 ff ff ff       	call   80107de0 <setupkvm>
80107ece:	85 c0                	test   %eax,%eax
80107ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ed3:	0f 84 b2 00 00 00    	je     80107f8b <cowuvm+0xcb>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80107ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107edc:	85 d2                	test   %edx,%edx
80107ede:	0f 84 a7 00 00 00    	je     80107f8b <cowuvm+0xcb>
80107ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee7:	31 db                	xor    %ebx,%ebx
80107ee9:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
80107eef:	eb 27                	jmp    80107f18 <cowuvm+0x58>
80107ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107ef8:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107efb:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
80107f01:	56                   	push   %esi
80107f02:	e8 59 af ff ff       	call   80102e60 <refInc>
80107f07:	0f 22 df             	mov    %edi,%cr3
  for(i = 0; i < sz; i += PGSIZE)
80107f0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f10:	83 c4 10             	add    $0x10,%esp
80107f13:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107f16:	76 73                	jbe    80107f8b <cowuvm+0xcb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f18:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1b:	31 c9                	xor    %ecx,%ecx
80107f1d:	89 da                	mov    %ebx,%edx
80107f1f:	e8 5c f5 ff ff       	call   80107480 <walkpgdir>
80107f24:	85 c0                	test   %eax,%eax
80107f26:	74 7b                	je     80107fa3 <cowuvm+0xe3>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107f28:	8b 10                	mov    (%eax),%edx
80107f2a:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107f30:	74 64                	je     80107f96 <cowuvm+0xd6>
    *pte &= ~PTE_W;
80107f32:	89 d1                	mov    %edx,%ecx
80107f34:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
80107f36:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80107f3c:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107f3f:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107f42:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
80107f45:	80 cd 04             	or     $0x4,%ch
80107f48:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107f4e:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f53:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f58:	52                   	push   %edx
80107f59:	56                   	push   %esi
80107f5a:	89 da                	mov    %ebx,%edx
80107f5c:	e8 9f f5 ff ff       	call   80107500 <mappages>
80107f61:	83 c4 10             	add    $0x10,%esp
80107f64:	85 c0                	test   %eax,%eax
80107f66:	79 90                	jns    80107ef8 <cowuvm+0x38>
    // invlpg((void*)i); // flush TLB
  }
  return d;

bad:
  cprintf("bad: cowuvm\n");
80107f68:	83 ec 0c             	sub    $0xc,%esp
80107f6b:	68 89 9c 10 80       	push   $0x80109c89
80107f70:	e8 eb 86 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107f75:	58                   	pop    %eax
80107f76:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f79:	e8 e2 fd ff ff       	call   80107d60 <freevm>
80107f7e:	0f 22 df             	mov    %edi,%cr3
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
80107f81:	83 c4 10             	add    $0x10,%esp
80107f84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f91:	5b                   	pop    %ebx
80107f92:	5e                   	pop    %esi
80107f93:	5f                   	pop    %edi
80107f94:	5d                   	pop    %ebp
80107f95:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
80107f96:	83 ec 0c             	sub    $0xc,%esp
80107f99:	68 44 9e 10 80       	push   $0x80109e44
80107f9e:	e8 ed 83 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107fa3:	83 ec 0c             	sub    $0xc,%esp
80107fa6:	68 7a 9c 10 80       	push   $0x80109c7a
80107fab:	e8 e0 83 ff ff       	call   80100390 <panic>

80107fb0 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80107fb0:	55                   	push   %ebp
80107fb1:	89 e5                	mov    %esp,%ebp
80107fb3:	53                   	push   %ebx
80107fb4:	83 ec 04             	sub    $0x4,%esp
80107fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107fba:	e8 21 c3 ff ff       	call   801042e0 <myproc>
80107fbf:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107fc5:	31 c0                	xor    %eax,%eax
80107fc7:	eb 12                	jmp    80107fdb <getSwappedPageIndex+0x2b>
80107fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fd0:	83 c0 01             	add    $0x1,%eax
80107fd3:	83 c2 1c             	add    $0x1c,%edx
80107fd6:	83 f8 10             	cmp    $0x10,%eax
80107fd9:	74 0d                	je     80107fe8 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
80107fdb:	39 1a                	cmp    %ebx,(%edx)
80107fdd:	75 f1                	jne    80107fd0 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
80107fdf:	83 c4 04             	add    $0x4,%esp
80107fe2:	5b                   	pop    %ebx
80107fe3:	5d                   	pop    %ebp
80107fe4:	c3                   	ret    
80107fe5:	8d 76 00             	lea    0x0(%esi),%esi
80107fe8:	83 c4 04             	add    $0x4,%esp
  return -1;
80107feb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ff0:	5b                   	pop    %ebx
80107ff1:	5d                   	pop    %ebp
80107ff2:	c3                   	ret    
80107ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108000 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80108000:	55                   	push   %ebp
80108001:	89 e5                	mov    %esp,%ebp
80108003:	57                   	push   %edi
80108004:	56                   	push   %esi
80108005:	53                   	push   %ebx
80108006:	83 ec 1c             	sub    $0x1c,%esp
80108009:	8b 45 08             	mov    0x8(%ebp),%eax
8010800c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010800f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
80108012:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80108015:	f6 42 34 02          	testb  $0x2,0x34(%edx)
80108019:	74 07                	je     80108022 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
8010801b:	8b 13                	mov    (%ebx),%edx
8010801d:	f6 c6 04             	test   $0x4,%dh
80108020:	75 16                	jne    80108038 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80108022:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80108029:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010802c:	5b                   	pop    %ebx
8010802d:	5e                   	pop    %esi
8010802e:	5f                   	pop    %edi
8010802f:	5d                   	pop    %ebp
80108030:	c3                   	ret    
80108031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80108038:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
8010803a:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
8010803d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108040:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108046:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010804c:	57                   	push   %edi
8010804d:	e8 7e ae ff ff       	call   80102ed0 <getRefs>
      if (ref_count > 1) // more than one reference
80108052:	83 c4 10             	add    $0x10,%esp
80108055:	83 f8 01             	cmp    $0x1,%eax
80108058:	7f 16                	jg     80108070 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
8010805a:	8b 03                	mov    (%ebx),%eax
8010805c:	80 e4 fb             	and    $0xfb,%ah
8010805f:	83 c8 02             	or     $0x2,%eax
80108062:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108064:	0f 01 3e             	invlpg (%esi)
80108067:	eb c0                	jmp    80108029 <handle_cow_pagefault+0x29>
80108069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80108070:	e8 cb ac ff ff       	call   80102d40 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108075:	83 ec 04             	sub    $0x4,%esp
80108078:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010807b:	68 00 10 00 00       	push   $0x1000
80108080:	57                   	push   %edi
80108081:	50                   	push   %eax
80108082:	e8 c9 d2 ff ff       	call   80105350 <memmove>
      flags = PTE_FLAGS(*pte);
80108087:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010808a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010808d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
80108093:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108099:	83 ca 03             	or     $0x3,%edx
8010809c:	09 ca                	or     %ecx,%edx
8010809e:	89 13                	mov    %edx,(%ebx)
801080a0:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
801080a3:	89 7d 08             	mov    %edi,0x8(%ebp)
801080a6:	83 c4 10             	add    $0x10,%esp
}
801080a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080ac:	5b                   	pop    %ebx
801080ad:	5e                   	pop    %esi
801080ae:	5f                   	pop    %edi
801080af:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
801080b0:	e9 3b ad ff ff       	jmp    80102df0 <refDec>
801080b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080c0 <update_selectionfiled_pagefault>:
}


void
update_selectionfiled_pagefault(struct proc* curproc, struct page* page, int page_ramindex)
{
801080c0:	55                   	push   %ebp
801080c1:	89 e5                	mov    %esp,%ebp
801080c3:	53                   	push   %ebx
801080c4:	83 ec 04             	sub    $0x4,%esp
801080c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801080ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(curproc->selection == SCFIFO)
801080cd:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
801080d3:	83 f8 03             	cmp    $0x3,%eax
801080d6:	75 0d                	jne    801080e5 <update_selectionfiled_pagefault+0x25>
  {
    page->ref_bit = 1;
801080d8:	c7 42 10 01 00 00 00 	movl   $0x1,0x10(%edx)
801080df:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }

  if(curproc -> selection == NFUA)
801080e5:	83 f8 01             	cmp    $0x1,%eax
801080e8:	75 0d                	jne    801080f7 <update_selectionfiled_pagefault+0x37>
  {
    page->nfua_counter = 0;
801080ea:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
801080f1:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }

  if(curproc -> selection == LAPA)
801080f7:	83 f8 02             	cmp    $0x2,%eax
801080fa:	75 0d                	jne    80108109 <update_selectionfiled_pagefault+0x49>
  {
    page->lapa_counter =  0xFFFFFFFF;
801080fc:	c7 42 18 ff ff ff ff 	movl   $0xffffffff,0x18(%edx)
80108103:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
  }

  if(curproc -> selection == AQ)
80108109:	83 f8 04             	cmp    $0x4,%eax
8010810c:	74 0a                	je     80108118 <update_selectionfiled_pagefault+0x58>
      node->next = curproc->queue_head;
      curproc->queue_head = node;
      curproc->queue_head->prev = 0;
    }
  }
}
8010810e:	83 c4 04             	add    $0x4,%esp
80108111:	5b                   	pop    %ebx
80108112:	5d                   	pop    %ebp
80108113:	c3                   	ret    
80108114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct queue_node * node = (struct queue_node*)kalloc();
80108118:	e8 23 ac ff ff       	call   80102d40 <kalloc>
    node->page_index = page_ramindex;
8010811d:	8b 55 10             	mov    0x10(%ebp),%edx
80108120:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
80108123:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
80108129:	85 d2                	test   %edx,%edx
8010812b:	74 23                	je     80108150 <update_selectionfiled_pagefault+0x90>
      curproc->queue_head->prev = node;
8010812d:	89 42 04             	mov    %eax,0x4(%edx)
      node->next = curproc->queue_head;
80108130:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
80108136:	89 10                	mov    %edx,(%eax)
      curproc->queue_head = node;
80108138:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
      curproc->queue_head->prev = 0;
8010813e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
80108145:	83 c4 04             	add    $0x4,%esp
80108148:	5b                   	pop    %ebx
80108149:	5d                   	pop    %ebp
8010814a:	c3                   	ret    
8010814b:	90                   	nop
8010814c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
80108150:	8b 8b 20 04 00 00    	mov    0x420(%ebx),%ecx
80108156:	85 c9                	test   %ecx,%ecx
80108158:	75 d3                	jne    8010812d <update_selectionfiled_pagefault+0x6d>
      curproc-> queue_head = node;
8010815a:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
      curproc-> queue_tail = node;
80108160:	89 83 20 04 00 00    	mov    %eax,0x420(%ebx)
      curproc-> queue_head->next = 0;
80108166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc-> queue_head->prev = 0;
8010816c:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80108172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      curproc-> queue_head->next = 0;
80108179:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
8010817f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc-> queue_head->prev = 0;
80108185:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
8010818b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108192:	e9 77 ff ff ff       	jmp    8010810e <update_selectionfiled_pagefault+0x4e>
80108197:	89 f6                	mov    %esi,%esi
80108199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081a0 <copyuvm>:

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	57                   	push   %edi
801081a4:	56                   	push   %esi
801081a5:	53                   	push   %ebx
801081a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801081a9:	e8 32 fc ff ff       	call   80107de0 <setupkvm>
801081ae:	85 c0                	test   %eax,%eax
801081b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801081b3:	0f 84 be 00 00 00    	je     80108277 <copyuvm+0xd7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801081b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801081bc:	85 db                	test   %ebx,%ebx
801081be:	0f 84 b3 00 00 00    	je     80108277 <copyuvm+0xd7>
801081c4:	31 f6                	xor    %esi,%esi
801081c6:	eb 69                	jmp    80108231 <copyuvm+0x91>
801081c8:	90                   	nop
801081c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }

    pa = PTE_ADDR(*pte);
801081d0:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801081d2:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801081d7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
801081dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    {
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
        panic("copyuvm: mappages failed");
      continue;
    }
    if((mem = kalloc()) == 0)
801081e0:	e8 5b ab ff ff       	call   80102d40 <kalloc>
801081e5:	85 c0                	test   %eax,%eax
801081e7:	89 c3                	mov    %eax,%ebx
801081e9:	0f 84 b1 00 00 00    	je     801082a0 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801081ef:	83 ec 04             	sub    $0x4,%esp
801081f2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801081f8:	68 00 10 00 00       	push   $0x1000
801081fd:	57                   	push   %edi
801081fe:	50                   	push   %eax
801081ff:	e8 4c d1 ff ff       	call   80105350 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108204:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010820a:	5a                   	pop    %edx
8010820b:	59                   	pop    %ecx
8010820c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010820f:	50                   	push   %eax
80108210:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108215:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108218:	89 f2                	mov    %esi,%edx
8010821a:	e8 e1 f2 ff ff       	call   80107500 <mappages>
8010821f:	83 c4 10             	add    $0x10,%esp
80108222:	85 c0                	test   %eax,%eax
80108224:	78 62                	js     80108288 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108226:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010822c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010822f:	76 46                	jbe    80108277 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108231:	8b 45 08             	mov    0x8(%ebp),%eax
80108234:	31 c9                	xor    %ecx,%ecx
80108236:	89 f2                	mov    %esi,%edx
80108238:	e8 43 f2 ff ff       	call   80107480 <walkpgdir>
8010823d:	85 c0                	test   %eax,%eax
8010823f:	0f 84 93 00 00 00    	je     801082d8 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108245:	8b 00                	mov    (%eax),%eax
80108247:	a9 01 02 00 00       	test   $0x201,%eax
8010824c:	74 7d                	je     801082cb <copyuvm+0x12b>
    if (*pte & PTE_PG) {
8010824e:	f6 c4 02             	test   $0x2,%ah
80108251:	0f 84 79 ff ff ff    	je     801081d0 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108257:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010825a:	89 f2                	mov    %esi,%edx
8010825c:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108261:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108267:	e8 14 f2 ff ff       	call   80107480 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
8010826c:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
8010826f:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108275:	77 ba                	ja     80108231 <copyuvm+0x91>

bad:
  cprintf("bad: copyuvm\n");
  freevm(d);
  return 0;
}
80108277:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010827a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010827d:	5b                   	pop    %ebx
8010827e:	5e                   	pop    %esi
8010827f:	5f                   	pop    %edi
80108280:	5d                   	pop    %ebp
80108281:	c3                   	ret    
80108282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
80108288:	83 ec 0c             	sub    $0xc,%esp
8010828b:	68 b0 9c 10 80       	push   $0x80109cb0
80108290:	e8 cb 83 ff ff       	call   80100660 <cprintf>
      kfree(mem);
80108295:	89 1c 24             	mov    %ebx,(%esp)
80108298:	e8 c3 a7 ff ff       	call   80102a60 <kfree>
      goto bad;
8010829d:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801082a0:	83 ec 0c             	sub    $0xc,%esp
801082a3:	68 ca 9c 10 80       	push   $0x80109cca
801082a8:	e8 b3 83 ff ff       	call   80100660 <cprintf>
  freevm(d);
801082ad:	58                   	pop    %eax
801082ae:	ff 75 e0             	pushl  -0x20(%ebp)
801082b1:	e8 aa fa ff ff       	call   80107d60 <freevm>
  return 0;
801082b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801082bd:	83 c4 10             	add    $0x10,%esp
}
801082c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c6:	5b                   	pop    %ebx
801082c7:	5e                   	pop    %esi
801082c8:	5f                   	pop    %edi
801082c9:	5d                   	pop    %ebp
801082ca:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
801082cb:	83 ec 0c             	sub    $0xc,%esp
801082ce:	68 74 9e 10 80       	push   $0x80109e74
801082d3:	e8 b8 80 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801082d8:	83 ec 0c             	sub    $0xc,%esp
801082db:	68 96 9c 10 80       	push   $0x80109c96
801082e0:	e8 ab 80 ff ff       	call   80100390 <panic>
801082e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801082f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082f1:	31 c9                	xor    %ecx,%ecx
{
801082f3:	89 e5                	mov    %esp,%ebp
801082f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801082f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801082fb:	8b 45 08             	mov    0x8(%ebp),%eax
801082fe:	e8 7d f1 ff ff       	call   80107480 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108303:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108305:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108306:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108308:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010830d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108310:	05 00 00 00 80       	add    $0x80000000,%eax
80108315:	83 fa 05             	cmp    $0x5,%edx
80108318:	ba 00 00 00 00       	mov    $0x0,%edx
8010831d:	0f 45 c2             	cmovne %edx,%eax
}
80108320:	c3                   	ret    
80108321:	eb 0d                	jmp    80108330 <copyout>
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

80108330 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108330:	55                   	push   %ebp
80108331:	89 e5                	mov    %esp,%ebp
80108333:	57                   	push   %edi
80108334:	56                   	push   %esi
80108335:	53                   	push   %ebx
80108336:	83 ec 1c             	sub    $0x1c,%esp
80108339:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010833c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010833f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108342:	85 db                	test   %ebx,%ebx
80108344:	75 40                	jne    80108386 <copyout+0x56>
80108346:	eb 70                	jmp    801083b8 <copyout+0x88>
80108348:	90                   	nop
80108349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108353:	89 f1                	mov    %esi,%ecx
80108355:	29 d1                	sub    %edx,%ecx
80108357:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010835d:	39 d9                	cmp    %ebx,%ecx
8010835f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108362:	29 f2                	sub    %esi,%edx
80108364:	83 ec 04             	sub    $0x4,%esp
80108367:	01 d0                	add    %edx,%eax
80108369:	51                   	push   %ecx
8010836a:	57                   	push   %edi
8010836b:	50                   	push   %eax
8010836c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010836f:	e8 dc cf ff ff       	call   80105350 <memmove>
    len -= n;
    buf += n;
80108374:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108377:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010837a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108380:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108382:	29 cb                	sub    %ecx,%ebx
80108384:	74 32                	je     801083b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108386:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108388:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010838b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010838e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108394:	56                   	push   %esi
80108395:	ff 75 08             	pushl  0x8(%ebp)
80108398:	e8 53 ff ff ff       	call   801082f0 <uva2ka>
    if(pa0 == 0)
8010839d:	83 c4 10             	add    $0x10,%esp
801083a0:	85 c0                	test   %eax,%eax
801083a2:	75 ac                	jne    80108350 <copyout+0x20>
  }
  return 0;
}
801083a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801083a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801083ac:	5b                   	pop    %ebx
801083ad:	5e                   	pop    %esi
801083ae:	5f                   	pop    %edi
801083af:	5d                   	pop    %ebp
801083b0:	c3                   	ret    
801083b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801083bb:	31 c0                	xor    %eax,%eax
}
801083bd:	5b                   	pop    %ebx
801083be:	5e                   	pop    %esi
801083bf:	5f                   	pop    %edi
801083c0:	5d                   	pop    %ebp
801083c1:	c3                   	ret    
801083c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083d0 <getNextFreeRamIndex>:

int
getNextFreeRamIndex()
{ 
801083d0:	55                   	push   %ebp
801083d1:	89 e5                	mov    %esp,%ebp
801083d3:	83 ec 08             	sub    $0x8,%esp
  int i;
  struct proc * currproc = myproc();
801083d6:	e8 05 bf ff ff       	call   801042e0 <myproc>
801083db:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801083e1:	31 c0                	xor    %eax,%eax
801083e3:	eb 0e                	jmp    801083f3 <getNextFreeRamIndex+0x23>
801083e5:	8d 76 00             	lea    0x0(%esi),%esi
801083e8:	83 c0 01             	add    $0x1,%eax
801083eb:	83 c2 1c             	add    $0x1c,%edx
801083ee:	83 f8 10             	cmp    $0x10,%eax
801083f1:	74 0d                	je     80108400 <getNextFreeRamIndex+0x30>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
801083f3:	8b 0a                	mov    (%edx),%ecx
801083f5:	85 c9                	test   %ecx,%ecx
801083f7:	75 ef                	jne    801083e8 <getNextFreeRamIndex+0x18>
      return i;
  }
  return -1;
}
801083f9:	c9                   	leave  
801083fa:	c3                   	ret    
801083fb:	90                   	nop
801083fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108405:	c9                   	leave  
80108406:	c3                   	ret    
80108407:	89 f6                	mov    %esi,%esi
80108409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108410 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108410:	55                   	push   %ebp
80108411:	89 e5                	mov    %esp,%ebp
80108413:	56                   	push   %esi
80108414:	53                   	push   %ebx
80108415:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108418:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010841e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  pte_t *pte;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
  {
    struct page *cur_page = &ramPages[i];
    if(!cur_page->isused)
80108428:	8b 43 04             	mov    0x4(%ebx),%eax
8010842b:	85 c0                	test   %eax,%eax
8010842d:	74 27                	je     80108456 <updateLapa+0x46>
      continue;
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010842f:	8b 53 08             	mov    0x8(%ebx),%edx
80108432:	8b 03                	mov    (%ebx),%eax
80108434:	31 c9                	xor    %ecx,%ecx
80108436:	e8 45 f0 ff ff       	call   80107480 <walkpgdir>
8010843b:	85 c0                	test   %eax,%eax
8010843d:	74 25                	je     80108464 <updateLapa+0x54>
8010843f:	8b 4b 18             	mov    0x18(%ebx),%ecx
80108442:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter << 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108445:	89 d1                	mov    %edx,%ecx
80108447:	81 c9 00 00 00 80    	or     $0x80000000,%ecx
8010844d:	f6 00 20             	testb  $0x20,(%eax)
80108450:	0f 45 d1             	cmovne %ecx,%edx
80108453:	89 53 18             	mov    %edx,0x18(%ebx)
80108456:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108459:	39 f3                	cmp    %esi,%ebx
8010845b:	75 cb                	jne    80108428 <updateLapa+0x18>
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter << 1; // just shit right one bit
    }
  }
}
8010845d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108460:	5b                   	pop    %ebx
80108461:	5e                   	pop    %esi
80108462:	5d                   	pop    %ebp
80108463:	c3                   	ret    
      panic("updateLapa: no pte");
80108464:	83 ec 0c             	sub    $0xc,%esp
80108467:	68 d8 9c 10 80       	push   $0x80109cd8
8010846c:	e8 1f 7f ff ff       	call   80100390 <panic>
80108471:	eb 0d                	jmp    80108480 <updateNfua>
80108473:	90                   	nop
80108474:	90                   	nop
80108475:	90                   	nop
80108476:	90                   	nop
80108477:	90                   	nop
80108478:	90                   	nop
80108479:	90                   	nop
8010847a:	90                   	nop
8010847b:	90                   	nop
8010847c:	90                   	nop
8010847d:	90                   	nop
8010847e:	90                   	nop
8010847f:	90                   	nop

80108480 <updateNfua>:

void updateNfua(struct proc* p)
{
80108480:	55                   	push   %ebp
80108481:	89 e5                	mov    %esp,%ebp
80108483:	56                   	push   %esi
80108484:	53                   	push   %ebx
80108485:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108488:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010848e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  pte_t *pte;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
  {
    struct page *cur_page = &ramPages[i];
    if(!cur_page->isused)
80108498:	8b 43 04             	mov    0x4(%ebx),%eax
8010849b:	85 c0                	test   %eax,%eax
8010849d:	74 27                	je     801084c6 <updateNfua+0x46>
      continue;
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010849f:	8b 53 08             	mov    0x8(%ebx),%edx
801084a2:	8b 03                	mov    (%ebx),%eax
801084a4:	31 c9                	xor    %ecx,%ecx
801084a6:	e8 d5 ef ff ff       	call   80107480 <walkpgdir>
801084ab:	85 c0                	test   %eax,%eax
801084ad:	74 25                	je     801084d4 <updateNfua+0x54>
801084af:	8b 4b 14             	mov    0x14(%ebx),%ecx
801084b2:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter << 1; // shift right one bit
      cur_page->nfua_counter |= 1 << 31; // turn on MSB
801084b5:	89 d1                	mov    %edx,%ecx
801084b7:	81 c9 00 00 00 80    	or     $0x80000000,%ecx
801084bd:	f6 00 20             	testb  $0x20,(%eax)
801084c0:	0f 45 d1             	cmovne %ecx,%edx
801084c3:	89 53 14             	mov    %edx,0x14(%ebx)
801084c6:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801084c9:	39 f3                	cmp    %esi,%ebx
801084cb:	75 cb                	jne    80108498 <updateNfua+0x18>
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter << 1; // just shit right one bit
    }
  }
}
801084cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801084d0:	5b                   	pop    %ebx
801084d1:	5e                   	pop    %esi
801084d2:	5d                   	pop    %ebp
801084d3:	c3                   	ret    
      panic("updateNfua: no pte");
801084d4:	83 ec 0c             	sub    $0xc,%esp
801084d7:	68 eb 9c 10 80       	push   $0x80109ceb
801084dc:	e8 af 7e ff ff       	call   80100390 <panic>
801084e1:	eb 0d                	jmp    801084f0 <aq>
801084e3:	90                   	nop
801084e4:	90                   	nop
801084e5:	90                   	nop
801084e6:	90                   	nop
801084e7:	90                   	nop
801084e8:	90                   	nop
801084e9:	90                   	nop
801084ea:	90                   	nop
801084eb:	90                   	nop
801084ec:	90                   	nop
801084ed:	90                   	nop
801084ee:	90                   	nop
801084ef:	90                   	nop

801084f0 <aq>:
  return scfifo();
  
}

uint aq()
{
801084f0:	55                   	push   %ebp
801084f1:	89 e5                	mov    %esp,%ebp
801084f3:	57                   	push   %edi
801084f4:	56                   	push   %esi
801084f5:	53                   	push   %ebx
801084f6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801084f9:	e8 e2 bd ff ff       	call   801042e0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801084fe:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
80108504:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
8010850a:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
8010850c:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
8010850f:	74 45                	je     80108556 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108511:	39 d1                	cmp    %edx,%ecx
80108513:	89 c3                	mov    %eax,%ebx
80108515:	74 31                	je     80108548 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108517:	8b 41 04             	mov    0x4(%ecx),%eax
8010851a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108520:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80108526:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
80108529:	83 ec 0c             	sub    $0xc,%esp
8010852c:	52                   	push   %edx
8010852d:	e8 2e a5 ff ff       	call   80102a60 <kfree>
  curproc->queue_tail = new_tail;
80108532:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
80108538:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010853b:	89 f0                	mov    %esi,%eax
8010853d:	5b                   	pop    %ebx
8010853e:	5e                   	pop    %esi
8010853f:	5f                   	pop    %edi
80108540:	5d                   	pop    %ebp
80108541:	c3                   	ret    
80108542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108548:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
8010854f:	00 00 00 
    new_tail = 0;
80108552:	31 ff                	xor    %edi,%edi
80108554:	eb d3                	jmp    80108529 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108556:	83 ec 0c             	sub    $0xc,%esp
80108559:	68 b0 9e 10 80       	push   $0x80109eb0
8010855e:	e8 2d 7e ff ff       	call   80100390 <panic>
80108563:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108570 <nfua>:
    minloc = nfua(); // re-use of nfua code
  
  return minloc;
}
uint nfua()
{
80108570:	55                   	push   %ebp
80108571:	89 e5                	mov    %esp,%ebp
80108573:	56                   	push   %esi
80108574:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108575:	e8 66 bd ff ff       	call   801042e0 <myproc>
  /* find the page with the minimal nfua */
  int i;
  uint minval = ramPages[0].nfua_counter;
  uint minloc = 0;

  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010857a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
8010857f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108585:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
8010858b:	31 c0                	xor    %eax,%eax
8010858d:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if(ramPages[i].nfua_counter < minval)
80108590:	8b 19                	mov    (%ecx),%ebx
80108592:	39 f3                	cmp    %esi,%ebx
80108594:	73 04                	jae    8010859a <nfua+0x2a>
    {
      minval = ramPages[i].nfua_counter;
      minloc = i;
80108596:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108598:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010859a:	83 c2 01             	add    $0x1,%edx
8010859d:	83 c1 1c             	add    $0x1c,%ecx
801085a0:	83 fa 10             	cmp    $0x10,%edx
801085a3:	75 eb                	jne    80108590 <nfua+0x20>
    }
  }
  return minloc;
}
801085a5:	5b                   	pop    %ebx
801085a6:	5e                   	pop    %esi
801085a7:	5d                   	pop    %ebp
801085a8:	c3                   	ret    
801085a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801085b0 <lapa>:
{
801085b0:	55                   	push   %ebp
801085b1:	89 e5                	mov    %esp,%ebp
801085b3:	57                   	push   %edi
801085b4:	56                   	push   %esi
801085b5:	53                   	push   %ebx
    return -1;
}

uint countSetBits(uint n)
{
    uint count = 0;
801085b6:	31 ff                	xor    %edi,%edi
{
801085b8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801085bb:	e8 20 bd ff ff       	call   801042e0 <myproc>
  uint minNumOfOnes = countSetBits(ramPages[0].nfua_counter);
801085c0:	8b 90 5c 02 00 00    	mov    0x25c(%eax),%edx
    while (n) {
801085c6:	85 d2                	test   %edx,%edx
801085c8:	74 11                	je     801085db <lapa+0x2b>
801085ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
801085d0:	89 d1                	mov    %edx,%ecx
801085d2:	83 e1 01             	and    $0x1,%ecx
801085d5:	01 cf                	add    %ecx,%edi
    while (n) {
801085d7:	d1 ea                	shr    %edx
801085d9:	75 f5                	jne    801085d0 <lapa+0x20>
801085db:	8d b0 7c 02 00 00    	lea    0x27c(%eax),%esi
  uint instances = 0;
801085e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  uint minloc = 0;
801085e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i = 1; i < MAX_PSYC_PAGES; i++)
801085ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801085f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
801085f8:	8b 06                	mov    (%esi),%eax
    uint count = 0;
801085fa:	31 d2                	xor    %edx,%edx
    while (n) {
801085fc:	85 c0                	test   %eax,%eax
801085fe:	74 0b                	je     8010860b <lapa+0x5b>
        count += n & 1;
80108600:	89 c1                	mov    %eax,%ecx
80108602:	83 e1 01             	and    $0x1,%ecx
80108605:	01 ca                	add    %ecx,%edx
    while (n) {
80108607:	d1 e8                	shr    %eax
80108609:	75 f5                	jne    80108600 <lapa+0x50>
    if(numOfOnes < minNumOfOnes)
8010860b:	39 fa                	cmp    %edi,%edx
8010860d:	72 29                	jb     80108638 <lapa+0x88>
      instances++;
8010860f:	0f 94 c0             	sete   %al
80108612:	0f b6 c0             	movzbl %al,%eax
80108615:	01 45 e4             	add    %eax,-0x1c(%ebp)
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108618:	83 c3 01             	add    $0x1,%ebx
8010861b:	83 c6 1c             	add    $0x1c,%esi
8010861e:	83 fb 10             	cmp    $0x10,%ebx
80108621:	75 d5                	jne    801085f8 <lapa+0x48>
  if(instances > 1) // more than one counter with minimal number of 1's
80108623:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
80108627:	76 1d                	jbe    80108646 <lapa+0x96>
}
80108629:	83 c4 1c             	add    $0x1c,%esp
8010862c:	5b                   	pop    %ebx
8010862d:	5e                   	pop    %esi
8010862e:	5f                   	pop    %edi
8010862f:	5d                   	pop    %ebp
    minloc = nfua(); // re-use of nfua code
80108630:	e9 3b ff ff ff       	jmp    80108570 <nfua>
80108635:	8d 76 00             	lea    0x0(%esi),%esi
      minloc = i;
80108638:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010863b:	89 d7                	mov    %edx,%edi
      instances = 1;
8010863d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80108644:	eb d2                	jmp    80108618 <lapa+0x68>
}
80108646:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108649:	83 c4 1c             	add    $0x1c,%esp
8010864c:	5b                   	pop    %ebx
8010864d:	5e                   	pop    %esi
8010864e:	5f                   	pop    %edi
8010864f:	5d                   	pop    %ebp
80108650:	c3                   	ret    
80108651:	eb 0d                	jmp    80108660 <scfifo>
80108653:	90                   	nop
80108654:	90                   	nop
80108655:	90                   	nop
80108656:	90                   	nop
80108657:	90                   	nop
80108658:	90                   	nop
80108659:	90                   	nop
8010865a:	90                   	nop
8010865b:	90                   	nop
8010865c:	90                   	nop
8010865d:	90                   	nop
8010865e:	90                   	nop
8010865f:	90                   	nop

80108660 <scfifo>:
{
80108660:	55                   	push   %ebp
80108661:	89 e5                	mov    %esp,%ebp
80108663:	57                   	push   %edi
80108664:	56                   	push   %esi
80108665:	53                   	push   %ebx
80108666:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108669:	e8 72 bc ff ff       	call   801042e0 <myproc>
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010866e:	8b 98 10 04 00 00    	mov    0x410(%eax),%ebx
  struct proc* curproc = myproc();
80108674:	89 c7                	mov    %eax,%edi
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108676:	83 fb 0f             	cmp    $0xf,%ebx
80108679:	7f 5f                	jg     801086da <scfifo+0x7a>
8010867b:	6b c3 1c             	imul   $0x1c,%ebx,%eax
8010867e:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108685:	eb 19                	jmp    801086a0 <scfifo+0x40>
80108687:	89 f6                	mov    %esi,%esi
80108689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108690:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108693:	83 e2 df             	and    $0xffffffdf,%edx
80108696:	83 c6 1c             	add    $0x1c,%esi
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108699:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
8010869c:	89 10                	mov    %edx,(%eax)
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010869e:	74 30                	je     801086d0 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
801086a0:	8b 56 08             	mov    0x8(%esi),%edx
801086a3:	8b 06                	mov    (%esi),%eax
801086a5:	31 c9                	xor    %ecx,%ecx
801086a7:	e8 d4 ed ff ff       	call   80107480 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
801086ac:	8b 10                	mov    (%eax),%edx
801086ae:	f6 c2 20             	test   $0x20,%dl
801086b1:	75 dd                	jne    80108690 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
801086b3:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
801086ba:	74 7c                	je     80108738 <scfifo+0xd8>
            curproc->clockHand = i + 1;
801086bc:	8d 43 01             	lea    0x1(%ebx),%eax
801086bf:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
801086c5:	eb 4f                	jmp    80108716 <scfifo+0xb6>
801086c7:	89 f6                	mov    %esi,%esi
801086c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(j=0; j< curproc->clockHand ;j++)
801086d0:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
801086d6:	85 c0                	test   %eax,%eax
801086d8:	74 6a                	je     80108744 <scfifo+0xe4>
801086da:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
801086e0:	31 db                	xor    %ebx,%ebx
801086e2:	eb 16                	jmp    801086fa <scfifo+0x9a>
801086e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          *pte &= ~PTE_A;  
801086e8:	83 e1 df             	and    $0xffffffdf,%ecx
801086eb:	83 c6 1c             	add    $0x1c,%esi
    for(j=0; j< curproc->clockHand ;j++)
801086ee:	89 d3                	mov    %edx,%ebx
          *pte &= ~PTE_A;  
801086f0:	89 08                	mov    %ecx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
801086f2:	39 97 10 04 00 00    	cmp    %edx,0x410(%edi)
801086f8:	76 4a                	jbe    80108744 <scfifo+0xe4>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
801086fa:	8b 56 08             	mov    0x8(%esi),%edx
801086fd:	8b 06                	mov    (%esi),%eax
801086ff:	31 c9                	xor    %ecx,%ecx
80108701:	e8 7a ed ff ff       	call   80107480 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108706:	8b 08                	mov    (%eax),%ecx
80108708:	8d 53 01             	lea    0x1(%ebx),%edx
8010870b:	f6 c1 20             	test   $0x20,%cl
8010870e:	75 d8                	jne    801086e8 <scfifo+0x88>
          curproc->clockHand = j + 1;
80108710:	89 97 10 04 00 00    	mov    %edx,0x410(%edi)
          cprintf("scfifo returned %d\n", j);
80108716:	83 ec 08             	sub    $0x8,%esp
80108719:	53                   	push   %ebx
8010871a:	68 fe 9c 10 80       	push   $0x80109cfe
8010871f:	e8 3c 7f ff ff       	call   80100660 <cprintf>
          return j;
80108724:	83 c4 10             	add    $0x10,%esp
}
80108727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010872a:	89 d8                	mov    %ebx,%eax
8010872c:	5b                   	pop    %ebx
8010872d:	5e                   	pop    %esi
8010872e:	5f                   	pop    %edi
8010872f:	5d                   	pop    %ebp
80108730:	c3                   	ret    
80108731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            curproc->clockHand = 0;
80108738:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
8010873f:	00 00 00 
80108742:	eb d2                	jmp    80108716 <scfifo+0xb6>
    panic("scfifo: not found any index!");
80108744:	83 ec 0c             	sub    $0xc,%esp
80108747:	68 12 9d 10 80       	push   $0x80109d12
8010874c:	e8 3f 7c ff ff       	call   80100390 <panic>
80108751:	eb 0d                	jmp    80108760 <indexToEvict>
80108753:	90                   	nop
80108754:	90                   	nop
80108755:	90                   	nop
80108756:	90                   	nop
80108757:	90                   	nop
80108758:	90                   	nop
80108759:	90                   	nop
8010875a:	90                   	nop
8010875b:	90                   	nop
8010875c:	90                   	nop
8010875d:	90                   	nop
8010875e:	90                   	nop
8010875f:	90                   	nop

80108760 <indexToEvict>:
{
80108760:	55                   	push   %ebp
80108761:	89 e5                	mov    %esp,%ebp
80108763:	83 ec 08             	sub    $0x8,%esp
  struct proc* curproc = myproc();
80108766:	e8 75 bb ff ff       	call   801042e0 <myproc>
  if(curproc->selection == DUMMY)
8010876b:	8b 80 24 04 00 00    	mov    0x424(%eax),%eax
80108771:	83 f8 05             	cmp    $0x5,%eax
80108774:	74 2a                	je     801087a0 <indexToEvict+0x40>
  if(curproc->selection == SCFIFO)
80108776:	83 f8 03             	cmp    $0x3,%eax
80108779:	74 0f                	je     8010878a <indexToEvict+0x2a>
  if(curproc->selection == NFUA)
8010877b:	83 f8 01             	cmp    $0x1,%eax
8010877e:	74 40                	je     801087c0 <indexToEvict+0x60>
  if(curproc->selection == LAPA)
80108780:	83 f8 02             	cmp    $0x2,%eax
80108783:	74 0b                	je     80108790 <indexToEvict+0x30>
  if(curproc->selection == AQ)
80108785:	83 f8 04             	cmp    $0x4,%eax
80108788:	74 26                	je     801087b0 <indexToEvict+0x50>
}
8010878a:	c9                   	leave  
    return scfifo();
8010878b:	e9 d0 fe ff ff       	jmp    80108660 <scfifo>
}
80108790:	c9                   	leave  
    return lapa();
80108791:	e9 1a fe ff ff       	jmp    801085b0 <lapa>
80108796:	8d 76 00             	lea    0x0(%esi),%esi
80108799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
801087a0:	b8 0b 00 00 00       	mov    $0xb,%eax
801087a5:	c9                   	leave  
801087a6:	c3                   	ret    
801087a7:	89 f6                	mov    %esi,%esi
801087a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801087b0:	c9                   	leave  
    return aq();
801087b1:	e9 3a fd ff ff       	jmp    801084f0 <aq>
801087b6:	8d 76 00             	lea    0x0(%esi),%esi
801087b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
801087c0:	c9                   	leave  
    return nfua();
801087c1:	e9 aa fd ff ff       	jmp    80108570 <nfua>
801087c6:	8d 76 00             	lea    0x0(%esi),%esi
801087c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801087d0 <allocuvm_withswap>:
{
801087d0:	55                   	push   %ebp
801087d1:	89 e5                	mov    %esp,%ebp
801087d3:	57                   	push   %edi
801087d4:	56                   	push   %esi
801087d5:	53                   	push   %ebx
801087d6:	83 ec 1c             	sub    $0x1c,%esp
801087d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801087dc:	8b 45 0c             	mov    0xc(%ebp),%eax
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
801087df:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
{
801087e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801087e9:	8b 45 10             	mov    0x10(%ebp),%eax
801087ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
801087ef:	0f 8f 80 01 00 00    	jg     80108975 <allocuvm_withswap+0x1a5>
      uint evicted_ind = indexToEvict();
801087f5:	e8 66 ff ff ff       	call   80108760 <indexToEvict>
      cprintf("index to evict: %d\n",evicted_ind);
801087fa:	83 ec 08             	sub    $0x8,%esp
      uint evicted_ind = indexToEvict();
801087fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cprintf("index to evict: %d\n",evicted_ind);
80108800:	50                   	push   %eax
80108801:	68 47 9d 10 80       	push   $0x80109d47
80108806:	e8 55 7e ff ff       	call   80100660 <cprintf>
      int swap_offset = curproc->free_head->off;
8010880b:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
      if(curproc->free_head->next == 0)
80108811:	83 c4 10             	add    $0x10,%esp
80108814:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80108817:	8b 3a                	mov    (%edx),%edi
      if(curproc->free_head->next == 0)
80108819:	85 c0                	test   %eax,%eax
8010881b:	0f 84 2f 01 00 00    	je     80108950 <allocuvm_withswap+0x180>
        kfree((char*)curproc->free_head->prev);
80108821:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80108824:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
8010882a:	ff 70 08             	pushl  0x8(%eax)
8010882d:	e8 2e a2 ff ff       	call   80102a60 <kfree>
80108832:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80108835:	6b 45 e4 1c          	imul   $0x1c,-0x1c(%ebp),%eax
80108839:	68 00 10 00 00       	push   $0x1000
8010883e:	57                   	push   %edi
8010883f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108842:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108845:	ff b6 50 02 00 00    	pushl  0x250(%esi)
8010884b:	53                   	push   %ebx
8010884c:	e8 bf 9d ff ff       	call   80102610 <writeToSwapFile>
80108851:	83 c4 10             	add    $0x10,%esp
80108854:	85 c0                	test   %eax,%eax
80108856:	0f 88 33 01 00 00    	js     8010898f <allocuvm_withswap+0x1bf>
      curproc->swappedPages[curproc->num_swap].isused = 1;
8010885c:	8b 93 0c 04 00 00    	mov    0x40c(%ebx),%edx
      cprintf("num swap: %d\n", curproc->num_swap);
80108862:	83 ec 08             	sub    $0x8,%esp
      curproc->swappedPages[curproc->num_swap].isused = 1;
80108865:	6b c2 1c             	imul   $0x1c,%edx,%eax
80108868:	01 d8                	add    %ebx,%eax
8010886a:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80108871:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80108874:	8b 8e 50 02 00 00    	mov    0x250(%esi),%ecx
8010887a:	89 88 90 00 00 00    	mov    %ecx,0x90(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80108880:	8b 8e 48 02 00 00    	mov    0x248(%esi),%ecx
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80108886:	89 b8 94 00 00 00    	mov    %edi,0x94(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
8010888c:	89 88 88 00 00 00    	mov    %ecx,0x88(%eax)
      cprintf("num swap: %d\n", curproc->num_swap);
80108892:	52                   	push   %edx
80108893:	68 75 9d 10 80       	push   $0x80109d75
80108898:	e8 c3 7d ff ff       	call   80100660 <cprintf>
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
8010889d:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
801088a3:	6b d0 1c             	imul   $0x1c,%eax,%edx
801088a6:	8b 94 13 88 00 00 00 	mov    0x88(%ebx,%edx,1),%edx
801088ad:	81 c2 00 00 00 80    	add    $0x80000000,%edx
  asm volatile("movl %0,%%cr3" : : "r" (val));
801088b3:	0f 22 da             	mov    %edx,%cr3
      curproc->num_swap ++;
801088b6:	83 c0 01             	add    $0x1,%eax
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
801088b9:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
801088bb:	89 83 0c 04 00 00    	mov    %eax,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
801088c1:	8b 96 50 02 00 00    	mov    0x250(%esi),%edx
801088c7:	8b 86 48 02 00 00    	mov    0x248(%esi),%eax
801088cd:	e8 ae eb ff ff       	call   80107480 <walkpgdir>
      if(!(*evicted_pte & PTE_P))
801088d2:	8b 10                	mov    (%eax),%edx
801088d4:	83 c4 10             	add    $0x10,%esp
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
801088d7:	89 c7                	mov    %eax,%edi
      if(!(*evicted_pte & PTE_P))
801088d9:	f6 c2 01             	test   $0x1,%dl
801088dc:	0f 84 a0 00 00 00    	je     80108982 <allocuvm_withswap+0x1b2>
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
801088e2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(evicted_pa));
801088e8:	83 ec 0c             	sub    $0xc,%esp
801088eb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801088f1:	52                   	push   %edx
801088f2:	e8 69 a1 ff ff       	call   80102a60 <kfree>
      *evicted_pte &= ~PTE_P;
801088f7:	8b 07                	mov    (%edi),%eax
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
801088f9:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
801088fc:	25 fe 0f 00 00       	and    $0xffe,%eax
80108901:	80 cc 02             	or     $0x2,%ah
80108904:	89 07                	mov    %eax,(%edi)
      newpage->pgdir = pgdir; // ??? 
80108906:	8b 45 e0             	mov    -0x20(%ebp),%eax
      newpage->isused = 1;
80108909:	c7 86 4c 02 00 00 01 	movl   $0x1,0x24c(%esi)
80108910:	00 00 00 
      newpage->swap_offset = -1;
80108913:	c7 86 54 02 00 00 ff 	movl   $0xffffffff,0x254(%esi)
8010891a:	ff ff ff 
      newpage->pgdir = pgdir; // ??? 
8010891d:	89 86 48 02 00 00    	mov    %eax,0x248(%esi)
      newpage->virt_addr = rounded_virtaddr;
80108923:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108926:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
8010892c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010892f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108932:	89 45 10             	mov    %eax,0x10(%ebp)
      struct page *newpage = &curproc->ramPages[evicted_ind];
80108935:	8b 45 d8             	mov    -0x28(%ebp),%eax
80108938:	8d 84 03 48 02 00 00 	lea    0x248(%ebx,%eax,1),%eax
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
8010893f:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108942:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108945:	5b                   	pop    %ebx
80108946:	5e                   	pop    %esi
80108947:	5f                   	pop    %edi
80108948:	5d                   	pop    %ebp
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
80108949:	e9 82 f0 ff ff       	jmp    801079d0 <update_selectionfiled_allocuvm>
8010894e:	66 90                	xchg   %ax,%ax
        kfree((char*)curproc->free_head);
80108950:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108953:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
8010895a:	00 00 00 
        kfree((char*)curproc->free_head);
8010895d:	52                   	push   %edx
8010895e:	e8 fd a0 ff ff       	call   80102a60 <kfree>
        curproc->free_head = 0;
80108963:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
8010896a:	00 00 00 
8010896d:	83 c4 10             	add    $0x10,%esp
80108970:	e9 c0 fe ff ff       	jmp    80108835 <allocuvm_withswap+0x65>
        panic("exceeded max swap pages");
80108975:	83 ec 0c             	sub    $0xc,%esp
80108978:	68 2f 9d 10 80       	push   $0x80109d2f
8010897d:	e8 0e 7a ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80108982:	83 ec 0c             	sub    $0xc,%esp
80108985:	68 f0 9e 10 80       	push   $0x80109ef0
8010898a:	e8 01 7a ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
8010898f:	83 ec 0c             	sub    $0xc,%esp
80108992:	68 5b 9d 10 80       	push   $0x80109d5b
80108997:	e8 f4 79 ff ff       	call   80100390 <panic>
8010899c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801089a0 <allocuvm_paging>:
{
801089a0:	55                   	push   %ebp
801089a1:	89 e5                	mov    %esp,%ebp
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801089a3:	8b 45 08             	mov    0x8(%ebp),%eax
801089a6:	83 b8 08 04 00 00 0f 	cmpl   $0xf,0x408(%eax)
801089ad:	7e 09                	jle    801089b8 <allocuvm_paging+0x18>
}
801089af:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
801089b0:	e9 1b fe ff ff       	jmp    801087d0 <allocuvm_withswap>
801089b5:	8d 76 00             	lea    0x0(%esi),%esi
}
801089b8:	5d                   	pop    %ebp
       allocuvm_noswap(curproc, pgdir, rounded_virtaddr); 
801089b9:	e9 02 f1 ff ff       	jmp    80107ac0 <allocuvm_noswap>
801089be:	66 90                	xchg   %ax,%ax

801089c0 <allocuvm>:
{
801089c0:	55                   	push   %ebp
801089c1:	89 e5                	mov    %esp,%ebp
801089c3:	57                   	push   %edi
801089c4:	56                   	push   %esi
801089c5:	53                   	push   %ebx
801089c6:	83 ec 28             	sub    $0x28,%esp
  cprintf("*** ALLOCUVM ***\n");
801089c9:	68 83 9d 10 80       	push   $0x80109d83
801089ce:	e8 8d 7c ff ff       	call   80100660 <cprintf>
  struct proc* curproc = myproc();
801089d3:	e8 08 b9 ff ff       	call   801042e0 <myproc>
  if(newsz >= KERNBASE)
801089d8:	8b 7d 10             	mov    0x10(%ebp),%edi
801089db:	83 c4 10             	add    $0x10,%esp
801089de:	85 ff                	test   %edi,%edi
801089e0:	0f 88 ba 00 00 00    	js     80108aa0 <allocuvm+0xe0>
  if(newsz < oldsz)
801089e6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801089e9:	0f 82 a1 00 00 00    	jb     80108a90 <allocuvm+0xd0>
801089ef:	89 c2                	mov    %eax,%edx
  a = PGROUNDUP(oldsz);
801089f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801089f4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801089fa:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80108a00:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108a03:	0f 86 8a 00 00 00    	jbe    80108a93 <allocuvm+0xd3>
80108a09:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80108a0c:	89 d7                	mov    %edx,%edi
80108a0e:	eb 0b                	jmp    80108a1b <allocuvm+0x5b>
80108a10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108a16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108a19:	76 65                	jbe    80108a80 <allocuvm+0xc0>
    mem = kalloc();
80108a1b:	e8 20 a3 ff ff       	call   80102d40 <kalloc>
    if(mem == 0){
80108a20:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108a22:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80108a24:	0f 84 86 00 00 00    	je     80108ab0 <allocuvm+0xf0>
    memset(mem, 0, PGSIZE);
80108a2a:	83 ec 04             	sub    $0x4,%esp
80108a2d:	68 00 10 00 00       	push   $0x1000
80108a32:	6a 00                	push   $0x0
80108a34:	50                   	push   %eax
80108a35:	e8 66 c8 ff ff       	call   801052a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108a3a:	58                   	pop    %eax
80108a3b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108a41:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108a46:	5a                   	pop    %edx
80108a47:	6a 06                	push   $0x6
80108a49:	50                   	push   %eax
80108a4a:	89 da                	mov    %ebx,%edx
80108a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80108a4f:	e8 ac ea ff ff       	call   80107500 <mappages>
80108a54:	83 c4 10             	add    $0x10,%esp
80108a57:	85 c0                	test   %eax,%eax
80108a59:	0f 88 81 00 00 00    	js     80108ae0 <allocuvm+0x120>
    if(curproc->pid > 2) 
80108a5f:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80108a63:	7e ab                	jle    80108a10 <allocuvm+0x50>
        allocuvm_paging(curproc, pgdir, (char *)a);
80108a65:	83 ec 04             	sub    $0x4,%esp
80108a68:	53                   	push   %ebx
80108a69:	ff 75 08             	pushl  0x8(%ebp)
  for(; a < newsz; a += PGSIZE){
80108a6c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        allocuvm_paging(curproc, pgdir, (char *)a);
80108a72:	57                   	push   %edi
80108a73:	e8 28 ff ff ff       	call   801089a0 <allocuvm_paging>
80108a78:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
80108a7b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108a7e:	77 9b                	ja     80108a1b <allocuvm+0x5b>
80108a80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
}
80108a83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a86:	5b                   	pop    %ebx
80108a87:	89 f8                	mov    %edi,%eax
80108a89:	5e                   	pop    %esi
80108a8a:	5f                   	pop    %edi
80108a8b:	5d                   	pop    %ebp
80108a8c:	c3                   	ret    
80108a8d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80108a90:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80108a93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a96:	89 f8                	mov    %edi,%eax
80108a98:	5b                   	pop    %ebx
80108a99:	5e                   	pop    %esi
80108a9a:	5f                   	pop    %edi
80108a9b:	5d                   	pop    %ebp
80108a9c:	c3                   	ret    
80108a9d:	8d 76 00             	lea    0x0(%esi),%esi
80108aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108aa3:	31 ff                	xor    %edi,%edi
}
80108aa5:	89 f8                	mov    %edi,%eax
80108aa7:	5b                   	pop    %ebx
80108aa8:	5e                   	pop    %esi
80108aa9:	5f                   	pop    %edi
80108aaa:	5d                   	pop    %ebp
80108aab:	c3                   	ret    
80108aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
80108ab0:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108ab3:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory\n");
80108ab5:	68 95 9d 10 80       	push   $0x80109d95
80108aba:	e8 a1 7b ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108abf:	83 c4 0c             	add    $0xc,%esp
80108ac2:	ff 75 0c             	pushl  0xc(%ebp)
80108ac5:	ff 75 10             	pushl  0x10(%ebp)
80108ac8:	ff 75 08             	pushl  0x8(%ebp)
80108acb:	e8 70 f0 ff ff       	call   80107b40 <deallocuvm>
      return 0;
80108ad0:	83 c4 10             	add    $0x10,%esp
}
80108ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ad6:	89 f8                	mov    %edi,%eax
80108ad8:	5b                   	pop    %ebx
80108ad9:	5e                   	pop    %esi
80108ada:	5f                   	pop    %edi
80108adb:	5d                   	pop    %ebp
80108adc:	c3                   	ret    
80108add:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108ae0:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108ae3:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory (2)\n");
80108ae5:	68 ad 9d 10 80       	push   $0x80109dad
80108aea:	e8 71 7b ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108aef:	83 c4 0c             	add    $0xc,%esp
80108af2:	ff 75 0c             	pushl  0xc(%ebp)
80108af5:	ff 75 10             	pushl  0x10(%ebp)
80108af8:	ff 75 08             	pushl  0x8(%ebp)
80108afb:	e8 40 f0 ff ff       	call   80107b40 <deallocuvm>
      kfree(mem);
80108b00:	89 34 24             	mov    %esi,(%esp)
80108b03:	e8 58 9f ff ff       	call   80102a60 <kfree>
      return 0;
80108b08:	83 c4 10             	add    $0x10,%esp
}
80108b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b0e:	89 f8                	mov    %edi,%eax
80108b10:	5b                   	pop    %ebx
80108b11:	5e                   	pop    %esi
80108b12:	5f                   	pop    %edi
80108b13:	5d                   	pop    %ebp
80108b14:	c3                   	ret    
80108b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108b20 <handle_pagedout>:
{
80108b20:	55                   	push   %ebp
80108b21:	89 e5                	mov    %esp,%ebp
80108b23:	57                   	push   %edi
80108b24:	56                   	push   %esi
80108b25:	53                   	push   %ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108b26:	31 ff                	xor    %edi,%edi
{
80108b28:	83 ec 20             	sub    $0x20,%esp
80108b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108b2e:	8b 75 10             	mov    0x10(%ebp),%esi
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108b31:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108b34:	ff 73 10             	pushl  0x10(%ebx)
80108b37:	50                   	push   %eax
80108b38:	68 18 9f 10 80       	push   $0x80109f18
80108b3d:	e8 1e 7b ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
80108b42:	e8 f9 a1 ff ff       	call   80102d40 <kalloc>
    *pte &= 0xFFF;
80108b47:	8b 16                	mov    (%esi),%edx
    *pte |= V2P(new_page);
80108b49:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
80108b4e:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108b54:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108b57:	09 d0                	or     %edx,%eax
80108b59:	89 06                	mov    %eax,(%esi)
  struct proc* curproc = myproc();
80108b5b:	e8 80 b7 ff ff       	call   801042e0 <myproc>
80108b60:	83 c4 10             	add    $0x10,%esp
80108b63:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108b68:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b6b:	eb 12                	jmp    80108b7f <handle_pagedout+0x5f>
80108b6d:	8d 76 00             	lea    0x0(%esi),%esi
80108b70:	83 c7 01             	add    $0x1,%edi
80108b73:	83 c0 1c             	add    $0x1c,%eax
80108b76:	83 ff 10             	cmp    $0x10,%edi
80108b79:	0f 84 51 02 00 00    	je     80108dd0 <handle_pagedout+0x2b0>
    if(curproc->swappedPages[i].virt_addr == va)
80108b7f:	3b 10                	cmp    (%eax),%edx
80108b81:	75 ed                	jne    80108b70 <handle_pagedout+0x50>
80108b83:	6b f7 1c             	imul   $0x1c,%edi,%esi
80108b86:	81 c6 88 00 00 00    	add    $0x88,%esi
    struct page *swap_page = &curproc->swappedPages[index];
80108b8c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108b8f:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80108b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108b97:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108b9a:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108b9d:	ff b6 94 00 00 00    	pushl  0x94(%esi)
80108ba3:	68 e0 c5 10 80       	push   $0x8010c5e0
80108ba8:	53                   	push   %ebx
80108ba9:	e8 92 9a ff ff       	call   80102640 <readFromSwapFile>
80108bae:	83 c4 10             	add    $0x10,%esp
80108bb1:	85 c0                	test   %eax,%eax
80108bb3:	0f 88 6c 02 00 00    	js     80108e25 <handle_pagedout+0x305>
    struct fblock *new_block = (struct fblock*)kalloc();
80108bb9:	e8 82 a1 ff ff       	call   80102d40 <kalloc>
    new_block->off = swap_page->swap_offset;
80108bbe:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
    new_block->next = 0;
80108bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80108bcb:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108bcd:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108bd3:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80108bd6:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108bdc:	85 d2                	test   %edx,%edx
80108bde:	0f 84 fc 01 00 00    	je     80108de0 <handle_pagedout+0x2c0>
      curproc->free_tail->next = new_block;
80108be4:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80108be7:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80108bea:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108bf0:	68 00 10 00 00       	push   $0x1000
80108bf5:	68 e0 c5 10 80       	push   $0x8010c5e0
80108bfa:	ff 75 0c             	pushl  0xc(%ebp)
80108bfd:	e8 4e c7 ff ff       	call   80105350 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80108c02:	83 c4 0c             	add    $0xc,%esp
80108c05:	6a 1c                	push   $0x1c
80108c07:	6a 00                	push   $0x0
80108c09:	ff 75 e4             	pushl  -0x1c(%ebp)
80108c0c:	e8 8f c6 ff ff       	call   801052a0 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108c11:	83 c4 10             	add    $0x10,%esp
80108c14:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
80108c1b:	0f 8f 8f 00 00 00    	jg     80108cb0 <handle_pagedout+0x190>
  struct proc * currproc = myproc();
80108c21:	e8 ba b6 ff ff       	call   801042e0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108c26:	31 ff                	xor    %edi,%edi
80108c28:	05 4c 02 00 00       	add    $0x24c,%eax
80108c2d:	eb 10                	jmp    80108c3f <handle_pagedout+0x11f>
80108c2f:	90                   	nop
80108c30:	83 c7 01             	add    $0x1,%edi
80108c33:	83 c0 1c             	add    $0x1c,%eax
80108c36:	83 ff 10             	cmp    $0x10,%edi
80108c39:	0f 84 b1 01 00 00    	je     80108df0 <handle_pagedout+0x2d0>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108c3f:	8b 10                	mov    (%eax),%edx
80108c41:	85 d2                	test   %edx,%edx
80108c43:	75 eb                	jne    80108c30 <handle_pagedout+0x110>
80108c45:	6b f7 1c             	imul   $0x1c,%edi,%esi
80108c48:	81 c6 48 02 00 00    	add    $0x248,%esi
      cprintf("filling ram slot: %d\n", new_indx);
80108c4e:	83 ec 08             	sub    $0x8,%esp
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
80108c51:	01 de                	add    %ebx,%esi
      cprintf("filling ram slot: %d\n", new_indx);
80108c53:	57                   	push   %edi
80108c54:	68 17 9c 10 80       	push   $0x80109c17
80108c59:	e8 02 7a ff ff       	call   80100660 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
80108c5e:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
80108c64:	83 c4 0c             	add    $0xc,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
80108c67:	01 d8                	add    %ebx,%eax
80108c69:	89 88 50 02 00 00    	mov    %ecx,0x250(%eax)
      curproc->ramPages[new_indx].isused = 1;
80108c6f:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80108c76:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108c79:	8b 53 04             	mov    0x4(%ebx),%edx
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108c7c:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80108c83:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108c86:	89 90 48 02 00 00    	mov    %edx,0x248(%eax)
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
80108c8c:	57                   	push   %edi
80108c8d:	56                   	push   %esi
80108c8e:	53                   	push   %ebx
80108c8f:	e8 2c f4 ff ff       	call   801080c0 <update_selectionfiled_pagefault>
      curproc->num_ram++;      
80108c94:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108c9b:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
80108ca2:	83 c4 10             	add    $0x10,%esp
}
80108ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ca8:	5b                   	pop    %ebx
80108ca9:	5e                   	pop    %esi
80108caa:	5f                   	pop    %edi
80108cab:	5d                   	pop    %ebp
80108cac:	c3                   	ret    
80108cad:	8d 76 00             	lea    0x0(%esi),%esi
      int index_to_evicet = indexToEvict();
80108cb0:	e8 ab fa ff ff       	call   80108760 <indexToEvict>
      cprintf("index to evict: %d\n", index_to_evicet);
80108cb5:	83 ec 08             	sub    $0x8,%esp
      int index_to_evicet = indexToEvict();
80108cb8:	89 c6                	mov    %eax,%esi
80108cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
      cprintf("index to evict: %d\n", index_to_evicet);
80108cbd:	50                   	push   %eax
80108cbe:	68 47 9d 10 80       	push   $0x80109d47
80108cc3:	e8 98 79 ff ff       	call   80100660 <cprintf>
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
80108cc8:	6b c6 1c             	imul   $0x1c,%esi,%eax
      int swap_offset = curproc->free_head->off;
80108ccb:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
      if(curproc->free_head->next == 0)
80108cd1:	83 c4 10             	add    $0x10,%esp
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
80108cd4:	8d 84 03 48 02 00 00 	lea    0x248(%ebx,%eax,1),%eax
80108cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
      int swap_offset = curproc->free_head->off;
80108cde:	8b 02                	mov    (%edx),%eax
80108ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80108ce3:	8b 42 04             	mov    0x4(%edx),%eax
80108ce6:	85 c0                	test   %eax,%eax
80108ce8:	0f 84 12 01 00 00    	je     80108e00 <handle_pagedout+0x2e0>
        kfree((char*)curproc->free_head->prev);
80108cee:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80108cf1:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108cf7:	ff 70 08             	pushl  0x8(%eax)
80108cfa:	e8 61 9d ff ff       	call   80102a60 <kfree>
80108cff:	83 c4 10             	add    $0x10,%esp
      cprintf("swap off : %d\n", swap_offset);
80108d02:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80108d05:	83 ec 08             	sub    $0x8,%esp
80108d08:	56                   	push   %esi
80108d09:	68 e4 9d 10 80       	push   $0x80109de4
80108d0e:	e8 4d 79 ff ff       	call   80100660 <cprintf>
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108d13:	68 00 10 00 00       	push   $0x1000
80108d18:	56                   	push   %esi
80108d19:	6b 75 e0 1c          	imul   $0x1c,-0x20(%ebp),%esi
80108d1d:	01 de                	add    %ebx,%esi
80108d1f:	ff b6 50 02 00 00    	pushl  0x250(%esi)
80108d25:	53                   	push   %ebx
80108d26:	e8 e5 98 ff ff       	call   80102610 <writeToSwapFile>
80108d2b:	83 c4 20             	add    $0x20,%esp
80108d2e:	85 c0                	test   %eax,%eax
80108d30:	0f 88 fc 00 00 00    	js     80108e32 <handle_pagedout+0x312>
      swap_page->virt_addr = ram_page->virt_addr;
80108d36:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80108d39:	8b 96 50 02 00 00    	mov    0x250(%esi),%edx
80108d3f:	01 d9                	add    %ebx,%ecx
80108d41:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
80108d47:	8b 86 48 02 00 00    	mov    0x248(%esi),%eax
      swap_page->isused = 1;
80108d4d:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108d54:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80108d57:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108d60:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108d66:	8b 43 04             	mov    0x4(%ebx),%eax
80108d69:	31 c9                	xor    %ecx,%ecx
80108d6b:	e8 10 e7 ff ff       	call   80107480 <walkpgdir>
      if(!(*pte & PTE_P))
80108d70:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108d72:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80108d74:	f6 c2 01             	test   $0x1,%dl
80108d77:	0f 84 c2 00 00 00    	je     80108e3f <handle_pagedout+0x31f>
      ramPa = (void*)PTE_ADDR(*pte);
80108d7d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80108d83:	83 ec 0c             	sub    $0xc,%esp
80108d86:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108d8c:	52                   	push   %edx
80108d8d:	e8 ce 9c ff ff       	call   80102a60 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80108d92:	8b 07                	mov    (%edi),%eax
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
80108d94:	83 c4 0c             	add    $0xc,%esp
      *pte &= ~PTE_P;                              // turn "present" flag off
80108d97:	25 fe 0f 00 00       	and    $0xffe,%eax
80108d9c:	80 cc 02             	or     $0x2,%ah
80108d9f:	89 07                	mov    %eax,(%edi)
      ram_page->virt_addr = start_page;
80108da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108da4:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
80108daa:	ff 75 e0             	pushl  -0x20(%ebp)
80108dad:	ff 75 dc             	pushl  -0x24(%ebp)
80108db0:	53                   	push   %ebx
80108db1:	e8 0a f3 ff ff       	call   801080c0 <update_selectionfiled_pagefault>
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108db6:	8b 43 04             	mov    0x4(%ebx),%eax
80108db9:	05 00 00 00 80       	add    $0x80000000,%eax
80108dbe:	0f 22 d8             	mov    %eax,%cr3
80108dc1:	83 c4 10             	add    $0x10,%esp
}
80108dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108dc7:	5b                   	pop    %ebx
80108dc8:	5e                   	pop    %esi
80108dc9:	5f                   	pop    %edi
80108dca:	5d                   	pop    %ebp
80108dcb:	c3                   	ret    
80108dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108dd0:	be 6c 00 00 00       	mov    $0x6c,%esi
  return -1;
80108dd5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108dda:	e9 ad fd ff ff       	jmp    80108b8c <handle_pagedout+0x6c>
80108ddf:	90                   	nop
      curproc->free_head = new_block;
80108de0:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108de6:	e9 fc fd ff ff       	jmp    80108be7 <handle_pagedout+0xc7>
80108deb:	90                   	nop
80108dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108df0:	be 2c 02 00 00       	mov    $0x22c,%esi
  return -1;
80108df5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108dfa:	e9 4f fe ff ff       	jmp    80108c4e <handle_pagedout+0x12e>
80108dff:	90                   	nop
        kfree((char*)curproc->free_head);
80108e00:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108e03:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108e0a:	00 00 00 
        kfree((char*)curproc->free_head);
80108e0d:	52                   	push   %edx
80108e0e:	e8 4d 9c ff ff       	call   80102a60 <kfree>
        curproc->free_head = 0;
80108e13:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80108e1a:	00 00 00 
80108e1d:	83 c4 10             	add    $0x10,%esp
80108e20:	e9 dd fe ff ff       	jmp    80108d02 <handle_pagedout+0x1e2>
      panic("allocuvm: readFromSwapFile");
80108e25:	83 ec 0c             	sub    $0xc,%esp
80108e28:	68 c9 9d 10 80       	push   $0x80109dc9
80108e2d:	e8 5e 75 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108e32:	83 ec 0c             	sub    $0xc,%esp
80108e35:	68 5b 9d 10 80       	push   $0x80109d5b
80108e3a:	e8 51 75 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108e3f:	83 ec 0c             	sub    $0xc,%esp
80108e42:	68 48 9f 10 80       	push   $0x80109f48
80108e47:	e8 44 75 ff ff       	call   80100390 <panic>
80108e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108e50 <pagefault>:
{
80108e50:	55                   	push   %ebp
80108e51:	89 e5                	mov    %esp,%ebp
80108e53:	57                   	push   %edi
80108e54:	56                   	push   %esi
80108e55:	53                   	push   %ebx
80108e56:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108e59:	e8 82 b4 ff ff       	call   801042e0 <myproc>
80108e5e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108e60:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108e63:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108e6a:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108e6c:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108e6f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108e75:	31 c9                	xor    %ecx,%ecx
80108e77:	89 fa                	mov    %edi,%edx
80108e79:	e8 02 e6 ff ff       	call   80107480 <walkpgdir>
  if((*pte & PTE_PG) && (*pte & ~PTE_COW)) // paged out, not COW todo
80108e7e:	8b 10                	mov    (%eax),%edx
80108e80:	f6 c6 02             	test   $0x2,%dh
80108e83:	74 08                	je     80108e8d <pagefault+0x3d>
80108e85:	81 e2 ff fb ff ff    	and    $0xfffffbff,%edx
80108e8b:	75 6b                	jne    80108ef8 <pagefault+0xa8>
    cprintf("pagefault - %s (pid %d) - COW\n", curproc->name, curproc->pid);
80108e8d:	8d 7b 6c             	lea    0x6c(%ebx),%edi
80108e90:	83 ec 04             	sub    $0x4,%esp
80108e93:	ff 73 10             	pushl  0x10(%ebx)
80108e96:	57                   	push   %edi
80108e97:	68 6c 9f 10 80       	push   $0x80109f6c
80108e9c:	e8 bf 77 ff ff       	call   80100660 <cprintf>
    if(va >= KERNBASE || pte == 0)
80108ea1:	83 c4 10             	add    $0x10,%esp
80108ea4:	85 f6                	test   %esi,%esi
80108ea6:	78 28                	js     80108ed0 <pagefault+0x80>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108ea8:	8b 43 04             	mov    0x4(%ebx),%eax
80108eab:	31 c9                	xor    %ecx,%ecx
80108ead:	89 f2                	mov    %esi,%edx
80108eaf:	e8 cc e5 ff ff       	call   80107480 <walkpgdir>
80108eb4:	85 c0                	test   %eax,%eax
80108eb6:	74 56                	je     80108f0e <pagefault+0xbe>
    handle_cow_pagefault(curproc, pte, va);
80108eb8:	83 ec 04             	sub    $0x4,%esp
80108ebb:	56                   	push   %esi
80108ebc:	50                   	push   %eax
80108ebd:	53                   	push   %ebx
80108ebe:	e8 3d f1 ff ff       	call   80108000 <handle_cow_pagefault>
80108ec3:	83 c4 10             	add    $0x10,%esp
}
80108ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ec9:	5b                   	pop    %ebx
80108eca:	5e                   	pop    %esi
80108ecb:	5f                   	pop    %edi
80108ecc:	5d                   	pop    %ebp
80108ecd:	c3                   	ret    
80108ece:	66 90                	xchg   %ax,%ax
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108ed0:	83 ec 04             	sub    $0x4,%esp
80108ed3:	57                   	push   %edi
80108ed4:	ff 73 10             	pushl  0x10(%ebx)
80108ed7:	68 8c 9f 10 80       	push   $0x80109f8c
80108edc:	e8 7f 77 ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108ee1:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80108ee8:	83 c4 10             	add    $0x10,%esp
}
80108eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108eee:	5b                   	pop    %ebx
80108eef:	5e                   	pop    %esi
80108ef0:	5f                   	pop    %edi
80108ef1:	5d                   	pop    %ebp
80108ef2:	c3                   	ret    
80108ef3:	90                   	nop
80108ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    handle_pagedout(curproc, start_page, pte);
80108ef8:	83 ec 04             	sub    $0x4,%esp
80108efb:	50                   	push   %eax
80108efc:	57                   	push   %edi
80108efd:	53                   	push   %ebx
80108efe:	e8 1d fc ff ff       	call   80108b20 <handle_pagedout>
80108f03:	83 c4 10             	add    $0x10,%esp
}
80108f06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108f09:	5b                   	pop    %ebx
80108f0a:	5e                   	pop    %esi
80108f0b:	5f                   	pop    %edi
80108f0c:	5d                   	pop    %ebp
80108f0d:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108f0e:	83 ec 0c             	sub    $0xc,%esp
80108f11:	68 f3 9d 10 80       	push   $0x80109df3
80108f16:	e8 75 74 ff ff       	call   80100390 <panic>
80108f1b:	90                   	nop
80108f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108f20 <countSetBits>:
{
80108f20:	55                   	push   %ebp
    uint count = 0;
80108f21:	31 c0                	xor    %eax,%eax
{
80108f23:	89 e5                	mov    %esp,%ebp
80108f25:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108f28:	85 d2                	test   %edx,%edx
80108f2a:	74 0f                	je     80108f3b <countSetBits+0x1b>
80108f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108f30:	89 d1                	mov    %edx,%ecx
80108f32:	83 e1 01             	and    $0x1,%ecx
80108f35:	01 c8                	add    %ecx,%eax
    while (n) {
80108f37:	d1 ea                	shr    %edx
80108f39:	75 f5                	jne    80108f30 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108f3b:	5d                   	pop    %ebp
80108f3c:	c3                   	ret    
80108f3d:	8d 76 00             	lea    0x0(%esi),%esi

80108f40 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108f40:	55                   	push   %ebp
80108f41:	89 e5                	mov    %esp,%ebp
80108f43:	56                   	push   %esi
80108f44:	53                   	push   %ebx
80108f45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("AQ SWAPPING: %d and its prev node!\n", curr_node->page_index);
  struct queue_node *prev_node = curr_node->prev;
80108f48:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108f4b:	e8 90 b3 ff ff       	call   801042e0 <myproc>
80108f50:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108f56:	74 30                	je     80108f88 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108f58:	e8 83 b3 ff ff       	call   801042e0 <myproc>
80108f5d:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108f63:	74 53                	je     80108fb8 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108f65:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108f68:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108f6a:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108f6c:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108f6f:	85 d2                	test   %edx,%edx
80108f71:	74 05                	je     80108f78 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108f73:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108f76:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108f78:	85 c0                	test   %eax,%eax
80108f7a:	74 05                	je     80108f81 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108f7c:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108f7e:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108f81:	5b                   	pop    %ebx
80108f82:	5e                   	pop    %esi
80108f83:	5d                   	pop    %ebp
80108f84:	c3                   	ret    
80108f85:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108f88:	e8 53 b3 ff ff       	call   801042e0 <myproc>
80108f8d:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108f93:	e8 48 b3 ff ff       	call   801042e0 <myproc>
80108f98:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108f9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108fa4:	e8 37 b3 ff ff       	call   801042e0 <myproc>
80108fa9:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108faf:	75 b4                	jne    80108f65 <swapAQ+0x25>
80108fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108fb8:	e8 23 b3 ff ff       	call   801042e0 <myproc>
80108fbd:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108fc3:	e8 18 b3 ff ff       	call   801042e0 <myproc>
80108fc8:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108fce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108fd5:	eb 8e                	jmp    80108f65 <swapAQ+0x25>
80108fd7:	89 f6                	mov    %esi,%esi
80108fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108fe0 <updateAQ>:
{
80108fe0:	55                   	push   %ebp
80108fe1:	89 e5                	mov    %esp,%ebp
80108fe3:	57                   	push   %edi
80108fe4:	56                   	push   %esi
80108fe5:	53                   	push   %ebx
80108fe6:	83 ec 1c             	sub    $0x1c,%esp
80108fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108fec:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108ff2:	85 d2                	test   %edx,%edx
80108ff4:	0f 84 7e 00 00 00    	je     80109078 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108ffa:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80109000:	8b 56 04             	mov    0x4(%esi),%edx
80109003:	85 d2                	test   %edx,%edx
80109005:	74 71                	je     80109078 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80109007:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
8010900d:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80109011:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80109015:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80109018:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
8010901a:	01 d8                	add    %ebx,%eax
8010901c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80109020:	8b 50 08             	mov    0x8(%eax),%edx
80109023:	8b 00                	mov    (%eax),%eax
80109025:	31 c9                	xor    %ecx,%ecx
80109027:	e8 54 e4 ff ff       	call   80107480 <walkpgdir>
8010902c:	85 c0                	test   %eax,%eax
8010902e:	89 c3                	mov    %eax,%ebx
80109030:	74 5e                	je     80109090 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80109032:	8b 00                	mov    (%eax),%eax
80109034:	8b 56 04             	mov    0x4(%esi),%edx
80109037:	a8 20                	test   $0x20,%al
80109039:	74 23                	je     8010905e <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
8010903b:	85 d2                	test   %edx,%edx
8010903d:	74 17                	je     80109056 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
8010903f:	8b 57 08             	mov    0x8(%edi),%edx
80109042:	8b 07                	mov    (%edi),%eax
80109044:	31 c9                	xor    %ecx,%ecx
80109046:	e8 35 e4 ff ff       	call   80107480 <walkpgdir>
8010904b:	85 c0                	test   %eax,%eax
8010904d:	74 41                	je     80109090 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
8010904f:	f6 00 20             	testb  $0x20,(%eax)
80109052:	74 2c                	je     80109080 <updateAQ+0xa0>
80109054:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80109056:	83 e0 df             	and    $0xffffffdf,%eax
80109059:	89 03                	mov    %eax,(%ebx)
8010905b:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
8010905e:	85 d2                	test   %edx,%edx
80109060:	74 16                	je     80109078 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80109062:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80109066:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
8010906a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
8010906d:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
8010906f:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80109071:	01 cf                	add    %ecx,%edi
80109073:	eb ab                	jmp    80109020 <updateAQ+0x40>
80109075:	8d 76 00             	lea    0x0(%esi),%esi
}
80109078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010907b:	5b                   	pop    %ebx
8010907c:	5e                   	pop    %esi
8010907d:	5f                   	pop    %edi
8010907e:	5d                   	pop    %ebp
8010907f:	c3                   	ret    
          swapAQ(curr_node);
80109080:	83 ec 0c             	sub    $0xc,%esp
80109083:	56                   	push   %esi
80109084:	e8 b7 fe ff ff       	call   80108f40 <swapAQ>
80109089:	8b 03                	mov    (%ebx),%eax
8010908b:	83 c4 10             	add    $0x10,%esp
8010908e:	eb c6                	jmp    80109056 <updateAQ+0x76>
      panic("updateAQ: no pte");
80109090:	83 ec 0c             	sub    $0xc,%esp
80109093:	68 0c 9e 10 80       	push   $0x80109e0c
80109098:	e8 f3 72 ff ff       	call   80100390 <panic>
