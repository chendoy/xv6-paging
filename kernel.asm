
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
8010002d:	b8 00 39 10 80       	mov    $0x80103900,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 34 e6 10 80       	mov    $0x8010e634,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 c0 8b 10 80       	push   $0x80108bc0
80100055:	68 00 e6 10 80       	push   $0x8010e600
8010005a:	e8 11 4e 00 00       	call   80104e70 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 2c 11 80       	mov    $0x80112cfc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 2d 11 80 fc 	movl   $0x80112cfc,0x80112d4c
8010006e:	2c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 2d 11 80 fc 	movl   $0x80112cfc,0x80112d50
80100078:	2c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 2c 11 80 	movl   $0x80112cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 8b 10 80       	push   $0x80108bc7
80100097:	50                   	push   %eax
80100098:	e8 93 4c 00 00       	call   80104d30 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 2d 11 80       	mov    0x80112d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 2d 11 80    	mov    %ebx,0x80112d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 2a 11 80    	cmp    $0x80112aa0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 00 e6 10 80       	push   $0x8010e600
801000e8:	e8 03 4f 00 00       	call   80104ff0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 2d 11 80    	mov    0x80112d50,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 2d 11 80    	mov    0x80112d4c,%ebx
80100126:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 e6 10 80       	push   $0x8010e600
80100162:	e8 49 4f 00 00       	call   801050b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 4b 00 00       	call   80104d70 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 26 00 00       	call   80102890 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 8b 10 80       	push   $0x80108bce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 49 4c 00 00       	call   80104e10 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 26 00 00       	jmp    80102890 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 8b 10 80       	push   $0x80108bdf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 08 4c 00 00       	call   80104e10 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 4b 00 00       	call   80104dd0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 e6 10 80 	movl   $0x8010e600,(%esp)
8010021f:	e8 cc 4d 00 00       	call   80104ff0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 50 2d 11 80       	mov    0x80112d50,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 2c 11 80 	movl   $0x80112cfc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 2d 11 80       	mov    0x80112d50,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 2d 11 80    	mov    %ebx,0x80112d50
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 e6 10 80 	movl   $0x8010e600,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 4e 00 00       	jmp    801050b0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 8b 10 80       	push   $0x80108be6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 06 18 00 00       	call   80101ab0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 3a 4d 00 00       	call   80104ff0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
801002cb:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 e0 2f 11 80       	push   $0x80112fe0
801002e5:	e8 06 46 00 00       	call   801048f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 41 3f 00 00       	call   80104240 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 9d 4d 00 00       	call   801050b0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 b4 16 00 00       	call   801019d0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 e0 2f 11 80    	mov    %edx,0x80112fe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 2f 11 80 	movsbl -0x7feed0a0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 46 4d 00 00       	call   801050b0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 5d 16 00 00       	call   801019d0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 e0 2f 11 80       	mov    %eax,0x80112fe0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ae 2d 00 00       	call   80103160 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 8b 10 80       	push   $0x80108bed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 f6 96 10 80 	movl   $0x801096f6,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 4a 00 00       	call   80104e90 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 8c 10 80       	push   $0x80108c01
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 c1 63 00 00       	call   801067f0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 d6 62 00 00       	call   801067f0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 62 00 00       	call   801067f0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 62 00 00       	call   801067f0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 3a 4c 00 00       	call   801051a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 4b 00 00       	call   80105100 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 8c 10 80       	push   $0x80108c05
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 30 8c 10 80 	movzbl -0x7fef73d0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 58 14 00 00       	call   80101ab0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 8c 49 00 00       	call   80104ff0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 c5 10 80       	push   $0x8010c520
80100697:	e8 14 4a 00 00       	call   801050b0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 2b 13 00 00       	call   801019d0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 18 8c 10 80       	mov    $0x80108c18,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 c5 10 80       	push   $0x8010c520
801007bd:	e8 2e 48 00 00       	call   80104ff0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 c5 10 80       	push   $0x8010c520
80100828:	e8 83 48 00 00       	call   801050b0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 8c 10 80       	push   $0x80108c1f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 c5 10 80       	push   $0x8010c520
80100877:	e8 74 47 00 00       	call   80104ff0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 2f 11 80    	sub    0x80112fe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 2f 11 80    	mov    %ecx,0x80112fe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 2f 11 80    	mov    %bl,-0x7feed0a0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 2f 11 80    	cmp    %eax,0x80112fe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
80100925:	39 05 e4 2f 11 80    	cmp    %eax,0x80112fe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 2f 11 80 0a 	cmpb   $0xa,-0x7feed0a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 e8 2f 11 80       	mov    %eax,0x80112fe8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
8010096f:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
80100985:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 2f 11 80       	mov    %eax,0x80112fe8
  if(panicked){
80100999:	a1 58 c5 10 80       	mov    0x8010c558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 c5 10 80       	push   $0x8010c520
801009cf:	e8 dc 46 00 00       	call   801050b0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 60 2f 11 80 0a 	movb   $0xa,-0x7feed0a0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 fc 41 00 00       	jmp    80104c00 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 2f 11 80       	mov    %eax,0x80112fe4
          wakeup(&input.r);
80100a1b:	68 e0 2f 11 80       	push   $0x80112fe0
80100a20:	e8 db 40 00 00       	call   80104b00 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 28 8c 10 80       	push   $0x80108c28
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 27 44 00 00       	call   80104e70 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 3d 11 80 40 	movl   $0x80100640,0x80113d6c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 3d 11 80 90 	movl   $0x80100290,0x80113d68
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 1f 00 00       	call   80102a40 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <backup>:
struct queue_node* queue_tail_backup;
struct file* swapfile_backup;

void 
backup(struct proc* curproc)
{  
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	53                   	push   %ebx
80100a88:	83 ec 08             	sub    $0x8,%esp
80100a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a8e:	68 c0 01 00 00       	push   $0x1c0
80100a93:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a99:	50                   	push   %eax
80100a9a:	68 00 30 11 80       	push   $0x80113000
80100a9f:	e8 fc 46 00 00       	call   801051a0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100aa4:	83 c4 0c             	add    $0xc,%esp
80100aa7:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100aad:	68 c0 01 00 00       	push   $0x1c0
80100ab2:	50                   	push   %eax
80100ab3:	68 e0 31 11 80       	push   $0x801131e0
80100ab8:	e8 e3 46 00 00       	call   801051a0 <memmove>
  num_ram_backup = curproc->num_ram; 
80100abd:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
  free_tail_backup = curproc->free_tail;
  swapfile_backup = curproc->swapFile;
  queue_head_backup = curproc->queue_head;
  queue_tail_backup = curproc->queue_tail;
  clockhand_backup = curproc->clockHand;
}
80100ac3:	83 c4 10             	add    $0x10,%esp
  num_ram_backup = curproc->num_ram; 
80100ac6:	a3 6c c5 10 80       	mov    %eax,0x8010c56c
  num_swap_backup = curproc->num_swap;
80100acb:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80100ad1:	a3 68 c5 10 80       	mov    %eax,0x8010c568
  free_head_backup = curproc->free_head;
80100ad6:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80100adc:	a3 60 c5 10 80       	mov    %eax,0x8010c560
  free_tail_backup = curproc->free_tail;
80100ae1:	8b 83 18 04 00 00    	mov    0x418(%ebx),%eax
80100ae7:	a3 5c c5 10 80       	mov    %eax,0x8010c55c
  swapfile_backup = curproc->swapFile;
80100aec:	8b 43 7c             	mov    0x7c(%ebx),%eax
80100aef:	a3 c0 31 11 80       	mov    %eax,0x801131c0
  queue_head_backup = curproc->queue_head;
80100af4:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80100afa:	a3 a0 33 11 80       	mov    %eax,0x801133a0
  queue_tail_backup = curproc->queue_tail;
80100aff:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80100b05:	a3 a4 33 11 80       	mov    %eax,0x801133a4
  clockhand_backup = curproc->clockHand;
80100b0a:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
}
80100b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  clockhand_backup = curproc->clockHand;
80100b13:	a3 64 c5 10 80       	mov    %eax,0x8010c564
}
80100b18:	c9                   	leave  
80100b19:	c3                   	ret    
80100b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b20 <clean_arrays>:

void 
clean_arrays(struct proc* curproc)
{
80100b20:	f3 0f 1e fb          	endbr32 
80100b24:	55                   	push   %ebp
80100b25:	89 e5                	mov    %esp,%ebp
80100b27:	53                   	push   %ebx
80100b28:	83 ec 08             	sub    $0x8,%esp
80100b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100b2e:	68 c0 01 00 00       	push   $0x1c0
80100b33:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100b39:	6a 00                	push   $0x0
80100b3b:	50                   	push   %eax
80100b3c:	e8 bf 45 00 00       	call   80105100 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100b41:	83 c4 0c             	add    $0xc,%esp
80100b44:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100b4a:	68 c0 01 00 00       	push   $0x1c0
80100b4f:	6a 00                	push   $0x0
80100b51:	50                   	push   %eax
80100b52:	e8 a9 45 00 00       	call   80105100 <memset>
  curproc->num_ram = 0;
  curproc->num_swap = 0;
}
80100b57:	83 c4 10             	add    $0x10,%esp
  curproc->num_ram = 0;
80100b5a:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80100b61:	00 00 00 
  curproc->num_swap = 0;
80100b64:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80100b6b:	00 00 00 
}
80100b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b71:	c9                   	leave  
80100b72:	c3                   	ret    
80100b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <alloc_fresh_fblocklst>:

void
alloc_fresh_fblocklst(struct proc* curproc)
{
80100b80:	f3 0f 1e fb          	endbr32 
80100b84:	55                   	push   %ebp
80100b85:	89 e5                	mov    %esp,%ebp
80100b87:	57                   	push   %edi
80100b88:	56                   	push   %esi
 /*allocating fresh fblock list */
  curproc->free_head = (struct fblock*)kalloc();
  curproc->free_head->prev = 0;
  curproc->free_head->off = 0 * PGSIZE;
  struct fblock *prev = curproc->free_head;
80100b89:	be 00 10 00 00       	mov    $0x1000,%esi
{
80100b8e:	53                   	push   %ebx
80100b8f:	83 ec 0c             	sub    $0xc,%esp
80100b92:	8b 5d 08             	mov    0x8(%ebp),%ebx
  curproc->free_head = (struct fblock*)kalloc();
80100b95:	e8 e6 21 00 00       	call   80102d80 <kalloc>
80100b9a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
  curproc->free_head->prev = 0;
80100ba0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  curproc->free_head->off = 0 * PGSIZE;
80100ba7:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80100bad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  struct fblock *prev = curproc->free_head;
80100bb3:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax

  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    struct fblock *curr = (struct fblock*)kalloc();
80100bc0:	89 c7                	mov    %eax,%edi
80100bc2:	e8 b9 21 00 00       	call   80102d80 <kalloc>
    curr->off = i * PGSIZE;
80100bc7:	89 30                	mov    %esi,(%eax)
    curr->prev = prev;
80100bc9:	81 c6 00 10 00 00    	add    $0x1000,%esi
80100bcf:	89 78 08             	mov    %edi,0x8(%eax)
    curr->prev->next = curr;
80100bd2:	89 47 04             	mov    %eax,0x4(%edi)
  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100bd5:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
80100bdb:	75 e3                	jne    80100bc0 <alloc_fresh_fblocklst+0x40>
    prev = curr;
  }
  curproc->free_tail = prev;
80100bdd:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
  curproc->free_tail->next = 0;
80100be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
80100bea:	83 c4 0c             	add    $0xc,%esp
80100bed:	5b                   	pop    %ebx
80100bee:	5e                   	pop    %esi
80100bef:	5f                   	pop    %edi
80100bf0:	5d                   	pop    %ebp
80100bf1:	c3                   	ret    
80100bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100c00 <clean_by_selection>:

void
clean_by_selection(struct proc* curproc)
{
80100c00:	f3 0f 1e fb          	endbr32 
80100c04:	55                   	push   %ebp
80100c05:	89 e5                	mov    %esp,%ebp
80100c07:	53                   	push   %ebx
80100c08:	83 ec 04             	sub    $0x4,%esp
80100c0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(curproc->selection == AQ)
80100c0e:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c14:	83 f8 04             	cmp    $0x4,%eax
80100c17:	74 17                	je     80100c30 <clean_by_selection+0x30>
    curproc->queue_head = 0;
    curproc->queue_tail = 0;
    cprintf("cleaning exec queue\n");
  }

  if(curproc->selection == SCFIFO)
80100c19:	83 f8 03             	cmp    $0x3,%eax
80100c1c:	75 0a                	jne    80100c28 <clean_by_selection+0x28>
  {
    curproc->clockHand = 0;
80100c1e:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100c25:	00 00 00 
  }
}
80100c28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c2b:	c9                   	leave  
80100c2c:	c3                   	ret    
80100c2d:	8d 76 00             	lea    0x0(%esi),%esi
    curproc->queue_head = 0;
80100c30:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100c37:	00 00 00 
    cprintf("cleaning exec queue\n");
80100c3a:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_tail = 0;
80100c3d:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100c44:	00 00 00 
    cprintf("cleaning exec queue\n");
80100c47:	68 41 8c 10 80       	push   $0x80108c41
80100c4c:	e8 5f fa ff ff       	call   801006b0 <cprintf>
80100c51:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	eb bd                	jmp    80100c19 <clean_by_selection+0x19>
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c60 <allocate_fresh>:
void 
allocate_fresh(struct proc* curproc)
{
80100c60:	f3 0f 1e fb          	endbr32 
80100c64:	55                   	push   %ebp
80100c65:	89 e5                	mov    %esp,%ebp
80100c67:	53                   	push   %ebx
80100c68:	83 ec 10             	sub    $0x10,%esp
80100c6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(createSwapFile(curproc) != 0)
80100c6e:	53                   	push   %ebx
80100c6f:	e8 ec 18 00 00       	call   80102560 <createSwapFile>
80100c74:	83 c4 10             	add    $0x10,%esp
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 61                	jne    80100cdc <allocate_fresh+0x7c>
    panic("exec: create swapfile for exec proc failed");
  clean_arrays(curproc);
80100c7b:	83 ec 0c             	sub    $0xc,%esp
80100c7e:	53                   	push   %ebx
80100c7f:	e8 9c fe ff ff       	call   80100b20 <clean_arrays>
  alloc_fresh_fblocklst(curproc);
80100c84:	89 1c 24             	mov    %ebx,(%esp)
80100c87:	e8 f4 fe ff ff       	call   80100b80 <alloc_fresh_fblocklst>
  if(curproc->selection == AQ)
80100c8c:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c92:	83 c4 10             	add    $0x10,%esp
80100c95:	83 f8 04             	cmp    $0x4,%eax
80100c98:	74 16                	je     80100cb0 <allocate_fresh+0x50>
  if(curproc->selection == SCFIFO)
80100c9a:	83 f8 03             	cmp    $0x3,%eax
80100c9d:	75 0a                	jne    80100ca9 <allocate_fresh+0x49>
    curproc->clockHand = 0;
80100c9f:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100ca6:	00 00 00 
  clean_by_selection(curproc);

}
80100ca9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cac:	c9                   	leave  
80100cad:	c3                   	ret    
80100cae:	66 90                	xchg   %ax,%ax
    curproc->queue_head = 0;
80100cb0:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100cb7:	00 00 00 
    cprintf("cleaning exec queue\n");
80100cba:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_tail = 0;
80100cbd:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100cc4:	00 00 00 
    cprintf("cleaning exec queue\n");
80100cc7:	68 41 8c 10 80       	push   $0x80108c41
80100ccc:	e8 df f9 ff ff       	call   801006b0 <cprintf>
80100cd1:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	eb be                	jmp    80100c9a <allocate_fresh+0x3a>
    panic("exec: create swapfile for exec proc failed");
80100cdc:	83 ec 0c             	sub    $0xc,%esp
80100cdf:	68 64 8c 10 80       	push   $0x80108c64
80100ce4:	e8 a7 f6 ff ff       	call   80100390 <panic>
80100ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100cf0 <exec>:

int
exec(char *path, char **argv)
{
80100cf0:	f3 0f 1e fb          	endbr32 
80100cf4:	55                   	push   %ebp
80100cf5:	89 e5                	mov    %esp,%ebp
80100cf7:	57                   	push   %edi
80100cf8:	56                   	push   %esi
80100cf9:	53                   	push   %ebx
80100cfa:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d00:	e8 3b 35 00 00       	call   80104240 <myproc>
80100d05:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
    backup(curproc);
    allocate_fresh(curproc);
  }
  #endif

  begin_op();
80100d0b:	e8 e0 28 00 00       	call   801035f0 <begin_op>

  if((ip = namei(path)) == 0){
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	ff 75 08             	pushl  0x8(%ebp)
80100d16:	e8 85 15 00 00       	call   801022a0 <namei>
80100d1b:	83 c4 10             	add    $0x10,%esp
80100d1e:	85 c0                	test   %eax,%eax
80100d20:	0f 84 fe 02 00 00    	je     80101024 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d26:	83 ec 0c             	sub    $0xc,%esp
80100d29:	89 c3                	mov    %eax,%ebx
80100d2b:	50                   	push   %eax
80100d2c:	e8 9f 0c 00 00       	call   801019d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d31:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d37:	6a 34                	push   $0x34
80100d39:	6a 00                	push   $0x0
80100d3b:	50                   	push   %eax
80100d3c:	53                   	push   %ebx
80100d3d:	e8 8e 0f 00 00       	call   80101cd0 <readi>
80100d42:	83 c4 20             	add    $0x20,%esp
80100d45:	83 f8 34             	cmp    $0x34,%eax
80100d48:	74 26                	je     80100d70 <exec+0x80>
  }
  #endif
  

  if(ip){
    iunlockput(ip);
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	53                   	push   %ebx
80100d4e:	e8 1d 0f 00 00       	call   80101c70 <iunlockput>
    end_op();
80100d53:	e8 08 29 00 00       	call   80103660 <end_op>
80100d58:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d63:	5b                   	pop    %ebx
80100d64:	5e                   	pop    %esi
80100d65:	5f                   	pop    %edi
80100d66:	5d                   	pop    %ebp
80100d67:	c3                   	ret    
80100d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d6f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100d70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d77:	45 4c 46 
80100d7a:	75 ce                	jne    80100d4a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100d7c:	e8 cf 6f 00 00       	call   80107d50 <setupkvm>
80100d81:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d87:	85 c0                	test   %eax,%eax
80100d89:	74 bf                	je     80100d4a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d92:	00 
80100d93:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100d99:	0f 84 a4 02 00 00    	je     80101043 <exec+0x353>
  sz = 0;
80100d9f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100da6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100da9:	31 ff                	xor    %edi,%edi
80100dab:	e9 86 00 00 00       	jmp    80100e36 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100db0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100db7:	75 6c                	jne    80100e25 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100db9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100dbf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100dc5:	0f 82 87 00 00 00    	jb     80100e52 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100dcb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100dd1:	72 7f                	jb     80100e52 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100dd3:	83 ec 04             	sub    $0x4,%esp
80100dd6:	50                   	push   %eax
80100dd7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ddd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100de3:	e8 08 6b 00 00       	call   801078f0 <allocuvm>
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100df1:	85 c0                	test   %eax,%eax
80100df3:	74 5d                	je     80100e52 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100df5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100dfb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e00:	75 50                	jne    80100e52 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e02:	83 ec 0c             	sub    $0xc,%esp
80100e05:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e0b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e11:	53                   	push   %ebx
80100e12:	50                   	push   %eax
80100e13:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e19:	e8 02 6a 00 00       	call   80107820 <loaduvm>
80100e1e:	83 c4 20             	add    $0x20,%esp
80100e21:	85 c0                	test   %eax,%eax
80100e23:	78 2d                	js     80100e52 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e25:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e2c:	83 c7 01             	add    $0x1,%edi
80100e2f:	83 c6 20             	add    $0x20,%esi
80100e32:	39 f8                	cmp    %edi,%eax
80100e34:	7e 3a                	jle    80100e70 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e36:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e3c:	6a 20                	push   $0x20
80100e3e:	56                   	push   %esi
80100e3f:	50                   	push   %eax
80100e40:	53                   	push   %ebx
80100e41:	e8 8a 0e 00 00       	call   80101cd0 <readi>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	83 f8 20             	cmp    $0x20,%eax
80100e4c:	0f 84 5e ff ff ff    	je     80100db0 <exec+0xc0>
    freevm(pgdir);
80100e52:	83 ec 0c             	sub    $0xc,%esp
80100e55:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e5b:	e8 40 6e 00 00       	call   80107ca0 <freevm>
  if(ip){
80100e60:	83 c4 10             	add    $0x10,%esp
80100e63:	e9 e2 fe ff ff       	jmp    80100d4a <exec+0x5a>
80100e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e6f:	90                   	nop
80100e70:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e76:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100e7c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100e82:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100e88:	83 ec 0c             	sub    $0xc,%esp
80100e8b:	53                   	push   %ebx
80100e8c:	e8 df 0d 00 00       	call   80101c70 <iunlockput>
  end_op();
80100e91:	e8 ca 27 00 00       	call   80103660 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e96:	83 c4 0c             	add    $0xc,%esp
80100e99:	56                   	push   %esi
80100e9a:	57                   	push   %edi
80100e9b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ea1:	57                   	push   %edi
80100ea2:	e8 49 6a 00 00       	call   801078f0 <allocuvm>
80100ea7:	83 c4 10             	add    $0x10,%esp
80100eaa:	89 c6                	mov    %eax,%esi
80100eac:	85 c0                	test   %eax,%eax
80100eae:	0f 84 94 00 00 00    	je     80100f48 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100eb4:	83 ec 08             	sub    $0x8,%esp
80100eb7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100ebd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ebf:	50                   	push   %eax
80100ec0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100ec1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ec3:	e8 38 6f 00 00       	call   80107e00 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ecb:	83 c4 10             	add    $0x10,%esp
80100ece:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100ed4:	8b 00                	mov    (%eax),%eax
80100ed6:	85 c0                	test   %eax,%eax
80100ed8:	0f 84 8b 00 00 00    	je     80100f69 <exec+0x279>
80100ede:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ee4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100eea:	eb 23                	jmp    80100f0f <exec+0x21f>
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ef3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100efa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100efd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100f03:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100f06:	85 c0                	test   %eax,%eax
80100f08:	74 59                	je     80100f63 <exec+0x273>
    if(argc >= MAXARG)
80100f0a:	83 ff 20             	cmp    $0x20,%edi
80100f0d:	74 39                	je     80100f48 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	50                   	push   %eax
80100f13:	e8 e8 43 00 00       	call   80105300 <strlen>
80100f18:	f7 d0                	not    %eax
80100f1a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f1c:	58                   	pop    %eax
80100f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f20:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f23:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f26:	e8 d5 43 00 00       	call   80105300 <strlen>
80100f2b:	83 c0 01             	add    $0x1,%eax
80100f2e:	50                   	push   %eax
80100f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f32:	ff 34 b8             	pushl  (%eax,%edi,4)
80100f35:	53                   	push   %ebx
80100f36:	56                   	push   %esi
80100f37:	e8 e4 75 00 00       	call   80108520 <copyout>
80100f3c:	83 c4 20             	add    $0x20,%esp
80100f3f:	85 c0                	test   %eax,%eax
80100f41:	79 ad                	jns    80100ef0 <exec+0x200>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    freevm(pgdir);
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f51:	e8 4a 6d 00 00       	call   80107ca0 <freevm>
80100f56:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f5e:	e9 fd fd ff ff       	jmp    80100d60 <exec+0x70>
80100f63:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f69:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100f70:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100f72:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100f79:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f7d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100f7f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100f82:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100f88:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f8a:	50                   	push   %eax
80100f8b:	52                   	push   %edx
80100f8c:	53                   	push   %ebx
80100f8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100f93:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100f9a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f9d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fa3:	e8 78 75 00 00       	call   80108520 <copyout>
80100fa8:	83 c4 10             	add    $0x10,%esp
80100fab:	85 c0                	test   %eax,%eax
80100fad:	78 99                	js     80100f48 <exec+0x258>
  for(last=s=path; *s; s++)
80100faf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb2:	8b 55 08             	mov    0x8(%ebp),%edx
80100fb5:	0f b6 00             	movzbl (%eax),%eax
80100fb8:	84 c0                	test   %al,%al
80100fba:	74 13                	je     80100fcf <exec+0x2df>
80100fbc:	89 d1                	mov    %edx,%ecx
80100fbe:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100fc0:	83 c1 01             	add    $0x1,%ecx
80100fc3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100fc5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100fc8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100fcb:	84 c0                	test   %al,%al
80100fcd:	75 f1                	jne    80100fc0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fcf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100fd5:	83 ec 04             	sub    $0x4,%esp
80100fd8:	6a 10                	push   $0x10
80100fda:	89 f8                	mov    %edi,%eax
80100fdc:	52                   	push   %edx
80100fdd:	83 c0 6c             	add    $0x6c,%eax
80100fe0:	50                   	push   %eax
80100fe1:	e8 da 42 00 00       	call   801052c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100fe6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100fec:	89 f8                	mov    %edi,%eax
80100fee:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ff1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ff3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ff6:	89 c1                	mov    %eax,%ecx
80100ff8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ffe:	8b 40 18             	mov    0x18(%eax),%eax
80101001:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101004:	8b 41 18             	mov    0x18(%ecx),%eax
80101007:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010100a:	89 0c 24             	mov    %ecx,(%esp)
8010100d:	e8 7e 66 00 00       	call   80107690 <switchuvm>
  freevm(oldpgdir);
80101012:	89 3c 24             	mov    %edi,(%esp)
80101015:	e8 86 6c 00 00       	call   80107ca0 <freevm>
  return 0;
8010101a:	83 c4 10             	add    $0x10,%esp
8010101d:	31 c0                	xor    %eax,%eax
8010101f:	e9 3c fd ff ff       	jmp    80100d60 <exec+0x70>
    end_op();
80101024:	e8 37 26 00 00       	call   80103660 <end_op>
    cprintf("exec: fail\n");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 56 8c 10 80       	push   $0x80108c56
80101031:	e8 7a f6 ff ff       	call   801006b0 <cprintf>
    return -1;
80101036:	83 c4 10             	add    $0x10,%esp
80101039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010103e:	e9 1d fd ff ff       	jmp    80100d60 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101043:	31 ff                	xor    %edi,%edi
80101045:	be 00 20 00 00       	mov    $0x2000,%esi
8010104a:	e9 39 fe ff ff       	jmp    80100e88 <exec+0x198>
8010104f:	90                   	nop

80101050 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101050:	f3 0f 1e fb          	endbr32 
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010105a:	68 8f 8c 10 80       	push   $0x80108c8f
8010105f:	68 c0 33 11 80       	push   $0x801133c0
80101064:	e8 07 3e 00 00       	call   80104e70 <initlock>
}
80101069:	83 c4 10             	add    $0x10,%esp
8010106c:	c9                   	leave  
8010106d:	c3                   	ret    
8010106e:	66 90                	xchg   %ax,%ax

80101070 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101070:	f3 0f 1e fb          	endbr32 
80101074:	55                   	push   %ebp
80101075:	89 e5                	mov    %esp,%ebp
80101077:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101078:	bb f4 33 11 80       	mov    $0x801133f4,%ebx
{
8010107d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101080:	68 c0 33 11 80       	push   $0x801133c0
80101085:	e8 66 3f 00 00       	call   80104ff0 <acquire>
8010108a:	83 c4 10             	add    $0x10,%esp
8010108d:	eb 0c                	jmp    8010109b <filealloc+0x2b>
8010108f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101090:	83 c3 18             	add    $0x18,%ebx
80101093:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80101099:	74 25                	je     801010c0 <filealloc+0x50>
    if(f->ref == 0){
8010109b:	8b 43 04             	mov    0x4(%ebx),%eax
8010109e:	85 c0                	test   %eax,%eax
801010a0:	75 ee                	jne    80101090 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801010a2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801010a5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801010ac:	68 c0 33 11 80       	push   $0x801133c0
801010b1:	e8 fa 3f 00 00       	call   801050b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801010b6:	89 d8                	mov    %ebx,%eax
      return f;
801010b8:	83 c4 10             	add    $0x10,%esp
}
801010bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010be:	c9                   	leave  
801010bf:	c3                   	ret    
  release(&ftable.lock);
801010c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801010c3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801010c5:	68 c0 33 11 80       	push   $0x801133c0
801010ca:	e8 e1 3f 00 00       	call   801050b0 <release>
}
801010cf:	89 d8                	mov    %ebx,%eax
  return 0;
801010d1:	83 c4 10             	add    $0x10,%esp
}
801010d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010d7:	c9                   	leave  
801010d8:	c3                   	ret    
801010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010e0:	f3 0f 1e fb          	endbr32 
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	53                   	push   %ebx
801010e8:	83 ec 10             	sub    $0x10,%esp
801010eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801010ee:	68 c0 33 11 80       	push   $0x801133c0
801010f3:	e8 f8 3e 00 00       	call   80104ff0 <acquire>
  if(f->ref < 1)
801010f8:	8b 43 04             	mov    0x4(%ebx),%eax
801010fb:	83 c4 10             	add    $0x10,%esp
801010fe:	85 c0                	test   %eax,%eax
80101100:	7e 1a                	jle    8010111c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101102:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101105:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101108:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010110b:	68 c0 33 11 80       	push   $0x801133c0
80101110:	e8 9b 3f 00 00       	call   801050b0 <release>
  return f;
}
80101115:	89 d8                	mov    %ebx,%eax
80101117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010111a:	c9                   	leave  
8010111b:	c3                   	ret    
    panic("filedup");
8010111c:	83 ec 0c             	sub    $0xc,%esp
8010111f:	68 96 8c 10 80       	push   $0x80108c96
80101124:	e8 67 f2 ff ff       	call   80100390 <panic>
80101129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101130 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101130:	f3 0f 1e fb          	endbr32 
80101134:	55                   	push   %ebp
80101135:	89 e5                	mov    %esp,%ebp
80101137:	57                   	push   %edi
80101138:	56                   	push   %esi
80101139:	53                   	push   %ebx
8010113a:	83 ec 28             	sub    $0x28,%esp
8010113d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101140:	68 c0 33 11 80       	push   $0x801133c0
80101145:	e8 a6 3e 00 00       	call   80104ff0 <acquire>
  if(f->ref < 1)
8010114a:	8b 53 04             	mov    0x4(%ebx),%edx
8010114d:	83 c4 10             	add    $0x10,%esp
80101150:	85 d2                	test   %edx,%edx
80101152:	0f 8e a1 00 00 00    	jle    801011f9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101158:	83 ea 01             	sub    $0x1,%edx
8010115b:	89 53 04             	mov    %edx,0x4(%ebx)
8010115e:	75 40                	jne    801011a0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101160:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101164:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101167:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101169:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010116f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101172:	88 45 e7             	mov    %al,-0x19(%ebp)
80101175:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101178:	68 c0 33 11 80       	push   $0x801133c0
  ff = *f;
8010117d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101180:	e8 2b 3f 00 00       	call   801050b0 <release>

  if(ff.type == FD_PIPE)
80101185:	83 c4 10             	add    $0x10,%esp
80101188:	83 ff 01             	cmp    $0x1,%edi
8010118b:	74 53                	je     801011e0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010118d:	83 ff 02             	cmp    $0x2,%edi
80101190:	74 26                	je     801011b8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101192:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101195:	5b                   	pop    %ebx
80101196:	5e                   	pop    %esi
80101197:	5f                   	pop    %edi
80101198:	5d                   	pop    %ebp
80101199:	c3                   	ret    
8010119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801011a0:	c7 45 08 c0 33 11 80 	movl   $0x801133c0,0x8(%ebp)
}
801011a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011aa:	5b                   	pop    %ebx
801011ab:	5e                   	pop    %esi
801011ac:	5f                   	pop    %edi
801011ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801011ae:	e9 fd 3e 00 00       	jmp    801050b0 <release>
801011b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011b7:	90                   	nop
    begin_op();
801011b8:	e8 33 24 00 00       	call   801035f0 <begin_op>
    iput(ff.ip);
801011bd:	83 ec 0c             	sub    $0xc,%esp
801011c0:	ff 75 e0             	pushl  -0x20(%ebp)
801011c3:	e8 38 09 00 00       	call   80101b00 <iput>
    end_op();
801011c8:	83 c4 10             	add    $0x10,%esp
}
801011cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ce:	5b                   	pop    %ebx
801011cf:	5e                   	pop    %esi
801011d0:	5f                   	pop    %edi
801011d1:	5d                   	pop    %ebp
    end_op();
801011d2:	e9 89 24 00 00       	jmp    80103660 <end_op>
801011d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011de:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801011e0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	53                   	push   %ebx
801011e8:	56                   	push   %esi
801011e9:	e8 e2 2b 00 00       	call   80103dd0 <pipeclose>
801011ee:	83 c4 10             	add    $0x10,%esp
}
801011f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f4:	5b                   	pop    %ebx
801011f5:	5e                   	pop    %esi
801011f6:	5f                   	pop    %edi
801011f7:	5d                   	pop    %ebp
801011f8:	c3                   	ret    
    panic("fileclose");
801011f9:	83 ec 0c             	sub    $0xc,%esp
801011fc:	68 9e 8c 10 80       	push   $0x80108c9e
80101201:	e8 8a f1 ff ff       	call   80100390 <panic>
80101206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010120d:	8d 76 00             	lea    0x0(%esi),%esi

80101210 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101210:	f3 0f 1e fb          	endbr32 
80101214:	55                   	push   %ebp
80101215:	89 e5                	mov    %esp,%ebp
80101217:	53                   	push   %ebx
80101218:	83 ec 04             	sub    $0x4,%esp
8010121b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010121e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101221:	75 2d                	jne    80101250 <filestat+0x40>
    ilock(f->ip);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	ff 73 10             	pushl  0x10(%ebx)
80101229:	e8 a2 07 00 00       	call   801019d0 <ilock>
    stati(f->ip, st);
8010122e:	58                   	pop    %eax
8010122f:	5a                   	pop    %edx
80101230:	ff 75 0c             	pushl  0xc(%ebp)
80101233:	ff 73 10             	pushl  0x10(%ebx)
80101236:	e8 65 0a 00 00       	call   80101ca0 <stati>
    iunlock(f->ip);
8010123b:	59                   	pop    %ecx
8010123c:	ff 73 10             	pushl  0x10(%ebx)
8010123f:	e8 6c 08 00 00       	call   80101ab0 <iunlock>
    return 0;
  }
  return -1;
}
80101244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101247:	83 c4 10             	add    $0x10,%esp
8010124a:	31 c0                	xor    %eax,%eax
}
8010124c:	c9                   	leave  
8010124d:	c3                   	ret    
8010124e:	66 90                	xchg   %ax,%ax
80101250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101258:	c9                   	leave  
80101259:	c3                   	ret    
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101260 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101260:	f3 0f 1e fb          	endbr32 
80101264:	55                   	push   %ebp
80101265:	89 e5                	mov    %esp,%ebp
80101267:	57                   	push   %edi
80101268:	56                   	push   %esi
80101269:	53                   	push   %ebx
8010126a:	83 ec 0c             	sub    $0xc,%esp
8010126d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101270:	8b 75 0c             	mov    0xc(%ebp),%esi
80101273:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101276:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010127a:	74 64                	je     801012e0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010127c:	8b 03                	mov    (%ebx),%eax
8010127e:	83 f8 01             	cmp    $0x1,%eax
80101281:	74 45                	je     801012c8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101283:	83 f8 02             	cmp    $0x2,%eax
80101286:	75 5f                	jne    801012e7 <fileread+0x87>
    ilock(f->ip);
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	ff 73 10             	pushl  0x10(%ebx)
8010128e:	e8 3d 07 00 00       	call   801019d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101293:	57                   	push   %edi
80101294:	ff 73 14             	pushl  0x14(%ebx)
80101297:	56                   	push   %esi
80101298:	ff 73 10             	pushl  0x10(%ebx)
8010129b:	e8 30 0a 00 00       	call   80101cd0 <readi>
801012a0:	83 c4 20             	add    $0x20,%esp
801012a3:	89 c6                	mov    %eax,%esi
801012a5:	85 c0                	test   %eax,%eax
801012a7:	7e 03                	jle    801012ac <fileread+0x4c>
      f->off += r;
801012a9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801012ac:	83 ec 0c             	sub    $0xc,%esp
801012af:	ff 73 10             	pushl  0x10(%ebx)
801012b2:	e8 f9 07 00 00       	call   80101ab0 <iunlock>
    return r;
801012b7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801012c8:	8b 43 0c             	mov    0xc(%ebx),%eax
801012cb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d1:	5b                   	pop    %ebx
801012d2:	5e                   	pop    %esi
801012d3:	5f                   	pop    %edi
801012d4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801012d5:	e9 96 2c 00 00       	jmp    80103f70 <piperead>
801012da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801012e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801012e5:	eb d3                	jmp    801012ba <fileread+0x5a>
  panic("fileread");
801012e7:	83 ec 0c             	sub    $0xc,%esp
801012ea:	68 a8 8c 10 80       	push   $0x80108ca8
801012ef:	e8 9c f0 ff ff       	call   80100390 <panic>
801012f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012ff:	90                   	nop

80101300 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101300:	f3 0f 1e fb          	endbr32 
80101304:	55                   	push   %ebp
80101305:	89 e5                	mov    %esp,%ebp
80101307:	57                   	push   %edi
80101308:	56                   	push   %esi
80101309:	53                   	push   %ebx
8010130a:	83 ec 1c             	sub    $0x1c,%esp
8010130d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101310:	8b 75 08             	mov    0x8(%ebp),%esi
80101313:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101316:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101319:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010131d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101320:	0f 84 c1 00 00 00    	je     801013e7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101326:	8b 06                	mov    (%esi),%eax
80101328:	83 f8 01             	cmp    $0x1,%eax
8010132b:	0f 84 c3 00 00 00    	je     801013f4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101331:	83 f8 02             	cmp    $0x2,%eax
80101334:	0f 85 cc 00 00 00    	jne    80101406 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010133a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010133d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010133f:	85 c0                	test   %eax,%eax
80101341:	7f 34                	jg     80101377 <filewrite+0x77>
80101343:	e9 98 00 00 00       	jmp    801013e0 <filewrite+0xe0>
80101348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101350:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101353:	83 ec 0c             	sub    $0xc,%esp
80101356:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101359:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010135c:	e8 4f 07 00 00       	call   80101ab0 <iunlock>
      end_op();
80101361:	e8 fa 22 00 00       	call   80103660 <end_op>
      if(r < 0)
        break;
      if(r != n1)
80101366:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101369:	83 c4 10             	add    $0x10,%esp
8010136c:	39 c3                	cmp    %eax,%ebx
8010136e:	75 60                	jne    801013d0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101370:	01 df                	add    %ebx,%edi
    while(i < n){
80101372:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101375:	7e 69                	jle    801013e0 <filewrite+0xe0>
      int n1 = n - i;
80101377:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010137a:	b8 00 06 00 00       	mov    $0x600,%eax
8010137f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101381:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101387:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010138a:	e8 61 22 00 00       	call   801035f0 <begin_op>
      ilock(f->ip);
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	ff 76 10             	pushl  0x10(%esi)
80101395:	e8 36 06 00 00       	call   801019d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010139a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010139d:	53                   	push   %ebx
8010139e:	ff 76 14             	pushl  0x14(%esi)
801013a1:	01 f8                	add    %edi,%eax
801013a3:	50                   	push   %eax
801013a4:	ff 76 10             	pushl  0x10(%esi)
801013a7:	e8 24 0a 00 00       	call   80101dd0 <writei>
801013ac:	83 c4 20             	add    $0x20,%esp
801013af:	85 c0                	test   %eax,%eax
801013b1:	7f 9d                	jg     80101350 <filewrite+0x50>
      iunlock(f->ip);
801013b3:	83 ec 0c             	sub    $0xc,%esp
801013b6:	ff 76 10             	pushl  0x10(%esi)
801013b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801013bc:	e8 ef 06 00 00       	call   80101ab0 <iunlock>
      end_op();
801013c1:	e8 9a 22 00 00       	call   80103660 <end_op>
      if(r < 0)
801013c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013c9:	83 c4 10             	add    $0x10,%esp
801013cc:	85 c0                	test   %eax,%eax
801013ce:	75 17                	jne    801013e7 <filewrite+0xe7>
        panic("short filewrite");
801013d0:	83 ec 0c             	sub    $0xc,%esp
801013d3:	68 b1 8c 10 80       	push   $0x80108cb1
801013d8:	e8 b3 ef ff ff       	call   80100390 <panic>
801013dd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801013e5:	74 05                	je     801013ec <filewrite+0xec>
801013e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801013ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ef:	5b                   	pop    %ebx
801013f0:	5e                   	pop    %esi
801013f1:	5f                   	pop    %edi
801013f2:	5d                   	pop    %ebp
801013f3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801013f4:	8b 46 0c             	mov    0xc(%esi),%eax
801013f7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5f                   	pop    %edi
80101400:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101401:	e9 6a 2a 00 00       	jmp    80103e70 <pipewrite>
  panic("filewrite");
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	68 b7 8c 10 80       	push   $0x80108cb7
8010140e:	e8 7d ef ff ff       	call   80100390 <panic>
80101413:	66 90                	xchg   %ax,%ax
80101415:	66 90                	xchg   %ax,%ax
80101417:	66 90                	xchg   %ax,%ax
80101419:	66 90                	xchg   %ax,%ax
8010141b:	66 90                	xchg   %ax,%ax
8010141d:	66 90                	xchg   %ax,%ax
8010141f:	90                   	nop

80101420 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
80101428:	03 05 d8 3d 11 80    	add    0x80113dd8,%eax
{
8010142e:	89 e5                	mov    %esp,%ebp
80101430:	56                   	push   %esi
80101431:	53                   	push   %ebx
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101443:	ba 01 00 00 00       	mov    $0x1,%edx
80101448:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010144b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101451:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101454:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101456:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010145b:	85 d1                	test   %edx,%ecx
8010145d:	74 25                	je     80101484 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010145f:	f7 d2                	not    %edx
  log_write(bp);
80101461:	83 ec 0c             	sub    $0xc,%esp
80101464:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101466:	21 ca                	and    %ecx,%edx
80101468:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010146c:	50                   	push   %eax
8010146d:	e8 5e 23 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret    
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 c1 8c 10 80       	push   $0x80108cc1
8010148c:	e8 ff ee ff ff       	call   80100390 <panic>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop

801014a0 <balloc>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	53                   	push   %ebx
801014a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801014a9:	8b 0d c0 3d 11 80    	mov    0x80113dc0,%ecx
{
801014af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014b2:	85 c9                	test   %ecx,%ecx
801014b4:	0f 84 87 00 00 00    	je     80101541 <balloc+0xa1>
801014ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801014c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801014c4:	83 ec 08             	sub    $0x8,%esp
801014c7:	89 f0                	mov    %esi,%eax
801014c9:	c1 f8 0c             	sar    $0xc,%eax
801014cc:	03 05 d8 3d 11 80    	add    0x80113dd8,%eax
801014d2:	50                   	push   %eax
801014d3:	ff 75 d8             	pushl  -0x28(%ebp)
801014d6:	e8 f5 eb ff ff       	call   801000d0 <bread>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014e1:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
801014e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014e9:	31 c0                	xor    %eax,%eax
801014eb:	eb 2f                	jmp    8010151c <balloc+0x7c>
801014ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801014f0:	89 c1                	mov    %eax,%ecx
801014f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801014fa:	83 e1 07             	and    $0x7,%ecx
801014fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014ff:	89 c1                	mov    %eax,%ecx
80101501:	c1 f9 03             	sar    $0x3,%ecx
80101504:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101509:	89 fa                	mov    %edi,%edx
8010150b:	85 df                	test   %ebx,%edi
8010150d:	74 41                	je     80101550 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010150f:	83 c0 01             	add    $0x1,%eax
80101512:	83 c6 01             	add    $0x1,%esi
80101515:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010151a:	74 05                	je     80101521 <balloc+0x81>
8010151c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010151f:	77 cf                	ja     801014f0 <balloc+0x50>
    brelse(bp);
80101521:	83 ec 0c             	sub    $0xc,%esp
80101524:	ff 75 e4             	pushl  -0x1c(%ebp)
80101527:	e8 c4 ec ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010152c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101533:	83 c4 10             	add    $0x10,%esp
80101536:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101539:	39 05 c0 3d 11 80    	cmp    %eax,0x80113dc0
8010153f:	77 80                	ja     801014c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101541:	83 ec 0c             	sub    $0xc,%esp
80101544:	68 d4 8c 10 80       	push   $0x80108cd4
80101549:	e8 42 ee ff ff       	call   80100390 <panic>
8010154e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101550:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101553:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101556:	09 da                	or     %ebx,%edx
80101558:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010155c:	57                   	push   %edi
8010155d:	e8 6e 22 00 00       	call   801037d0 <log_write>
        brelse(bp);
80101562:	89 3c 24             	mov    %edi,(%esp)
80101565:	e8 86 ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010156a:	58                   	pop    %eax
8010156b:	5a                   	pop    %edx
8010156c:	56                   	push   %esi
8010156d:	ff 75 d8             	pushl  -0x28(%ebp)
80101570:	e8 5b eb ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101575:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101578:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010157a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010157d:	68 00 02 00 00       	push   $0x200
80101582:	6a 00                	push   $0x0
80101584:	50                   	push   %eax
80101585:	e8 76 3b 00 00       	call   80105100 <memset>
  log_write(bp);
8010158a:	89 1c 24             	mov    %ebx,(%esp)
8010158d:	e8 3e 22 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101592:	89 1c 24             	mov    %ebx,(%esp)
80101595:	e8 56 ec ff ff       	call   801001f0 <brelse>
}
8010159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159d:	89 f0                	mov    %esi,%eax
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5f                   	pop    %edi
801015a2:	5d                   	pop    %ebp
801015a3:	c3                   	ret    
801015a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop

801015b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	89 c7                	mov    %eax,%edi
801015b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801015b7:	31 f6                	xor    %esi,%esi
{
801015b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015ba:	bb 14 3e 11 80       	mov    $0x80113e14,%ebx
{
801015bf:	83 ec 28             	sub    $0x28,%esp
801015c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801015c5:	68 e0 3d 11 80       	push   $0x80113de0
801015ca:	e8 21 3a 00 00       	call   80104ff0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801015d2:	83 c4 10             	add    $0x10,%esp
801015d5:	eb 1b                	jmp    801015f2 <iget+0x42>
801015d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015e0:	39 3b                	cmp    %edi,(%ebx)
801015e2:	74 6c                	je     80101650 <iget+0xa0>
801015e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015ea:	81 fb 34 5a 11 80    	cmp    $0x80115a34,%ebx
801015f0:	73 26                	jae    80101618 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801015f5:	85 c9                	test   %ecx,%ecx
801015f7:	7f e7                	jg     801015e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801015f9:	85 f6                	test   %esi,%esi
801015fb:	75 e7                	jne    801015e4 <iget+0x34>
801015fd:	89 d8                	mov    %ebx,%eax
801015ff:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101605:	85 c9                	test   %ecx,%ecx
80101607:	75 6e                	jne    80101677 <iget+0xc7>
80101609:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010160b:	81 fb 34 5a 11 80    	cmp    $0x80115a34,%ebx
80101611:	72 df                	jb     801015f2 <iget+0x42>
80101613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101617:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101618:	85 f6                	test   %esi,%esi
8010161a:	74 73                	je     8010168f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010161c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010161f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101621:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101624:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010162b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101632:	68 e0 3d 11 80       	push   $0x80113de0
80101637:	e8 74 3a 00 00       	call   801050b0 <release>

  return ip;
8010163c:	83 c4 10             	add    $0x10,%esp
}
8010163f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101642:	89 f0                	mov    %esi,%eax
80101644:	5b                   	pop    %ebx
80101645:	5e                   	pop    %esi
80101646:	5f                   	pop    %edi
80101647:	5d                   	pop    %ebp
80101648:	c3                   	ret    
80101649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101650:	39 53 04             	cmp    %edx,0x4(%ebx)
80101653:	75 8f                	jne    801015e4 <iget+0x34>
      release(&icache.lock);
80101655:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101658:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010165b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010165d:	68 e0 3d 11 80       	push   $0x80113de0
      ip->ref++;
80101662:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101665:	e8 46 3a 00 00       	call   801050b0 <release>
      return ip;
8010166a:	83 c4 10             	add    $0x10,%esp
}
8010166d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101670:	89 f0                	mov    %esi,%eax
80101672:	5b                   	pop    %ebx
80101673:	5e                   	pop    %esi
80101674:	5f                   	pop    %edi
80101675:	5d                   	pop    %ebp
80101676:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101677:	81 fb 34 5a 11 80    	cmp    $0x80115a34,%ebx
8010167d:	73 10                	jae    8010168f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010167f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101682:	85 c9                	test   %ecx,%ecx
80101684:	0f 8f 56 ff ff ff    	jg     801015e0 <iget+0x30>
8010168a:	e9 6e ff ff ff       	jmp    801015fd <iget+0x4d>
    panic("iget: no inodes");
8010168f:	83 ec 0c             	sub    $0xc,%esp
80101692:	68 ea 8c 10 80       	push   $0x80108cea
80101697:	e8 f4 ec ff ff       	call   80100390 <panic>
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	89 c6                	mov    %eax,%esi
801016a7:	53                   	push   %ebx
801016a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801016ab:	83 fa 0b             	cmp    $0xb,%edx
801016ae:	0f 86 84 00 00 00    	jbe    80101738 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801016b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801016b7:	83 fb 7f             	cmp    $0x7f,%ebx
801016ba:	0f 87 98 00 00 00    	ja     80101758 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801016c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801016c6:	8b 16                	mov    (%esi),%edx
801016c8:	85 c0                	test   %eax,%eax
801016ca:	74 54                	je     80101720 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801016cc:	83 ec 08             	sub    $0x8,%esp
801016cf:	50                   	push   %eax
801016d0:	52                   	push   %edx
801016d1:	e8 fa e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801016d6:	83 c4 10             	add    $0x10,%esp
801016d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801016dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801016df:	8b 1a                	mov    (%edx),%ebx
801016e1:	85 db                	test   %ebx,%ebx
801016e3:	74 1b                	je     80101700 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801016e5:	83 ec 0c             	sub    $0xc,%esp
801016e8:	57                   	push   %edi
801016e9:	e8 02 eb ff ff       	call   801001f0 <brelse>
    return addr;
801016ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801016f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016f4:	89 d8                	mov    %ebx,%eax
801016f6:	5b                   	pop    %ebx
801016f7:	5e                   	pop    %esi
801016f8:	5f                   	pop    %edi
801016f9:	5d                   	pop    %ebp
801016fa:	c3                   	ret    
801016fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ff:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101700:	8b 06                	mov    (%esi),%eax
80101702:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101705:	e8 96 fd ff ff       	call   801014a0 <balloc>
8010170a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010170d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101710:	89 c3                	mov    %eax,%ebx
80101712:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101714:	57                   	push   %edi
80101715:	e8 b6 20 00 00       	call   801037d0 <log_write>
8010171a:	83 c4 10             	add    $0x10,%esp
8010171d:	eb c6                	jmp    801016e5 <bmap+0x45>
8010171f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101720:	89 d0                	mov    %edx,%eax
80101722:	e8 79 fd ff ff       	call   801014a0 <balloc>
80101727:	8b 16                	mov    (%esi),%edx
80101729:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010172f:	eb 9b                	jmp    801016cc <bmap+0x2c>
80101731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101738:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010173b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010173e:	85 db                	test   %ebx,%ebx
80101740:	75 af                	jne    801016f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101742:	8b 00                	mov    (%eax),%eax
80101744:	e8 57 fd ff ff       	call   801014a0 <balloc>
80101749:	89 47 5c             	mov    %eax,0x5c(%edi)
8010174c:	89 c3                	mov    %eax,%ebx
}
8010174e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101751:	89 d8                	mov    %ebx,%eax
80101753:	5b                   	pop    %ebx
80101754:	5e                   	pop    %esi
80101755:	5f                   	pop    %edi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
  panic("bmap: out of range");
80101758:	83 ec 0c             	sub    $0xc,%esp
8010175b:	68 fa 8c 10 80       	push   $0x80108cfa
80101760:	e8 2b ec ff ff       	call   80100390 <panic>
80101765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101770 <readsb>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010177c:	83 ec 08             	sub    $0x8,%esp
8010177f:	6a 01                	push   $0x1
80101781:	ff 75 08             	pushl  0x8(%ebp)
80101784:	e8 47 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101789:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010178c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010178e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101791:	6a 1c                	push   $0x1c
80101793:	50                   	push   %eax
80101794:	56                   	push   %esi
80101795:	e8 06 3a 00 00       	call   801051a0 <memmove>
  brelse(bp);
8010179a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010179d:	83 c4 10             	add    $0x10,%esp
}
801017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a3:	5b                   	pop    %ebx
801017a4:	5e                   	pop    %esi
801017a5:	5d                   	pop    %ebp
  brelse(bp);
801017a6:	e9 45 ea ff ff       	jmp    801001f0 <brelse>
801017ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017af:	90                   	nop

801017b0 <iinit>:
{
801017b0:	f3 0f 1e fb          	endbr32 
801017b4:	55                   	push   %ebp
801017b5:	89 e5                	mov    %esp,%ebp
801017b7:	53                   	push   %ebx
801017b8:	bb 20 3e 11 80       	mov    $0x80113e20,%ebx
801017bd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801017c0:	68 0d 8d 10 80       	push   $0x80108d0d
801017c5:	68 e0 3d 11 80       	push   $0x80113de0
801017ca:	e8 a1 36 00 00       	call   80104e70 <initlock>
  for(i = 0; i < NINODE; i++) {
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801017d8:	83 ec 08             	sub    $0x8,%esp
801017db:	68 14 8d 10 80       	push   $0x80108d14
801017e0:	53                   	push   %ebx
801017e1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801017e7:	e8 44 35 00 00       	call   80104d30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801017ec:	83 c4 10             	add    $0x10,%esp
801017ef:	81 fb 40 5a 11 80    	cmp    $0x80115a40,%ebx
801017f5:	75 e1                	jne    801017d8 <iinit+0x28>
  readsb(dev, &sb);
801017f7:	83 ec 08             	sub    $0x8,%esp
801017fa:	68 c0 3d 11 80       	push   $0x80113dc0
801017ff:	ff 75 08             	pushl  0x8(%ebp)
80101802:	e8 69 ff ff ff       	call   80101770 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101807:	ff 35 d8 3d 11 80    	pushl  0x80113dd8
8010180d:	ff 35 d4 3d 11 80    	pushl  0x80113dd4
80101813:	ff 35 d0 3d 11 80    	pushl  0x80113dd0
80101819:	ff 35 cc 3d 11 80    	pushl  0x80113dcc
8010181f:	ff 35 c8 3d 11 80    	pushl  0x80113dc8
80101825:	ff 35 c4 3d 11 80    	pushl  0x80113dc4
8010182b:	ff 35 c0 3d 11 80    	pushl  0x80113dc0
80101831:	68 c0 8d 10 80       	push   $0x80108dc0
80101836:	e8 75 ee ff ff       	call   801006b0 <cprintf>
}
8010183b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010183e:	83 c4 30             	add    $0x30,%esp
80101841:	c9                   	leave  
80101842:	c3                   	ret    
80101843:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101850 <ialloc>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	57                   	push   %edi
80101858:	56                   	push   %esi
80101859:	53                   	push   %ebx
8010185a:	83 ec 1c             	sub    $0x1c,%esp
8010185d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101860:	83 3d c8 3d 11 80 01 	cmpl   $0x1,0x80113dc8
{
80101867:	8b 75 08             	mov    0x8(%ebp),%esi
8010186a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010186d:	0f 86 8d 00 00 00    	jbe    80101900 <ialloc+0xb0>
80101873:	bf 01 00 00 00       	mov    $0x1,%edi
80101878:	eb 1d                	jmp    80101897 <ialloc+0x47>
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101880:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101883:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101886:	53                   	push   %ebx
80101887:	e8 64 e9 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010188c:	83 c4 10             	add    $0x10,%esp
8010188f:	3b 3d c8 3d 11 80    	cmp    0x80113dc8,%edi
80101895:	73 69                	jae    80101900 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101897:	89 f8                	mov    %edi,%eax
80101899:	83 ec 08             	sub    $0x8,%esp
8010189c:	c1 e8 03             	shr    $0x3,%eax
8010189f:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
801018a5:	50                   	push   %eax
801018a6:	56                   	push   %esi
801018a7:	e8 24 e8 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801018ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801018af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801018b1:	89 f8                	mov    %edi,%eax
801018b3:	83 e0 07             	and    $0x7,%eax
801018b6:	c1 e0 06             	shl    $0x6,%eax
801018b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801018bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801018c1:	75 bd                	jne    80101880 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801018c3:	83 ec 04             	sub    $0x4,%esp
801018c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801018c9:	6a 40                	push   $0x40
801018cb:	6a 00                	push   $0x0
801018cd:	51                   	push   %ecx
801018ce:	e8 2d 38 00 00       	call   80105100 <memset>
      dip->type = type;
801018d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801018d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801018da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801018dd:	89 1c 24             	mov    %ebx,(%esp)
801018e0:	e8 eb 1e 00 00       	call   801037d0 <log_write>
      brelse(bp);
801018e5:	89 1c 24             	mov    %ebx,(%esp)
801018e8:	e8 03 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801018ed:	83 c4 10             	add    $0x10,%esp
}
801018f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801018f3:	89 fa                	mov    %edi,%edx
}
801018f5:	5b                   	pop    %ebx
      return iget(dev, inum);
801018f6:	89 f0                	mov    %esi,%eax
}
801018f8:	5e                   	pop    %esi
801018f9:	5f                   	pop    %edi
801018fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801018fb:	e9 b0 fc ff ff       	jmp    801015b0 <iget>
  panic("ialloc: no inodes");
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 1a 8d 10 80       	push   $0x80108d1a
80101908:	e8 83 ea ff ff       	call   80100390 <panic>
8010190d:	8d 76 00             	lea    0x0(%esi),%esi

80101910 <iupdate>:
{
80101910:	f3 0f 1e fb          	endbr32 
80101914:	55                   	push   %ebp
80101915:	89 e5                	mov    %esp,%ebp
80101917:	56                   	push   %esi
80101918:	53                   	push   %ebx
80101919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010191c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010191f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101922:	83 ec 08             	sub    $0x8,%esp
80101925:	c1 e8 03             	shr    $0x3,%eax
80101928:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
8010192e:	50                   	push   %eax
8010192f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101932:	e8 99 e7 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101937:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010193b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010193e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101940:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101943:	83 e0 07             	and    $0x7,%eax
80101946:	c1 e0 06             	shl    $0x6,%eax
80101949:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010194d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101950:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101954:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101957:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010195b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010195f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101963:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101967:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010196b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010196e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101971:	6a 34                	push   $0x34
80101973:	53                   	push   %ebx
80101974:	50                   	push   %eax
80101975:	e8 26 38 00 00       	call   801051a0 <memmove>
  log_write(bp);
8010197a:	89 34 24             	mov    %esi,(%esp)
8010197d:	e8 4e 1e 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101982:	89 75 08             	mov    %esi,0x8(%ebp)
80101985:	83 c4 10             	add    $0x10,%esp
}
80101988:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010198b:	5b                   	pop    %ebx
8010198c:	5e                   	pop    %esi
8010198d:	5d                   	pop    %ebp
  brelse(bp);
8010198e:	e9 5d e8 ff ff       	jmp    801001f0 <brelse>
80101993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019a0 <idup>:
{
801019a0:	f3 0f 1e fb          	endbr32 
801019a4:	55                   	push   %ebp
801019a5:	89 e5                	mov    %esp,%ebp
801019a7:	53                   	push   %ebx
801019a8:	83 ec 10             	sub    $0x10,%esp
801019ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019ae:	68 e0 3d 11 80       	push   $0x80113de0
801019b3:	e8 38 36 00 00       	call   80104ff0 <acquire>
  ip->ref++;
801019b8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019bc:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801019c3:	e8 e8 36 00 00       	call   801050b0 <release>
}
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019cd:	c9                   	leave  
801019ce:	c3                   	ret    
801019cf:	90                   	nop

801019d0 <ilock>:
{
801019d0:	f3 0f 1e fb          	endbr32 
801019d4:	55                   	push   %ebp
801019d5:	89 e5                	mov    %esp,%ebp
801019d7:	56                   	push   %esi
801019d8:	53                   	push   %ebx
801019d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801019dc:	85 db                	test   %ebx,%ebx
801019de:	0f 84 b3 00 00 00    	je     80101a97 <ilock+0xc7>
801019e4:	8b 53 08             	mov    0x8(%ebx),%edx
801019e7:	85 d2                	test   %edx,%edx
801019e9:	0f 8e a8 00 00 00    	jle    80101a97 <ilock+0xc7>
  acquiresleep(&ip->lock);
801019ef:	83 ec 0c             	sub    $0xc,%esp
801019f2:	8d 43 0c             	lea    0xc(%ebx),%eax
801019f5:	50                   	push   %eax
801019f6:	e8 75 33 00 00       	call   80104d70 <acquiresleep>
  if(ip->valid == 0){
801019fb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801019fe:	83 c4 10             	add    $0x10,%esp
80101a01:	85 c0                	test   %eax,%eax
80101a03:	74 0b                	je     80101a10 <ilock+0x40>
}
80101a05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a08:	5b                   	pop    %ebx
80101a09:	5e                   	pop    %esi
80101a0a:	5d                   	pop    %ebp
80101a0b:	c3                   	ret    
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a10:	8b 43 04             	mov    0x4(%ebx),%eax
80101a13:	83 ec 08             	sub    $0x8,%esp
80101a16:	c1 e8 03             	shr    $0x3,%eax
80101a19:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
80101a1f:	50                   	push   %eax
80101a20:	ff 33                	pushl  (%ebx)
80101a22:	e8 a9 e6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a27:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a2a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a2c:	8b 43 04             	mov    0x4(%ebx),%eax
80101a2f:	83 e0 07             	and    $0x7,%eax
80101a32:	c1 e0 06             	shl    $0x6,%eax
80101a35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a61:	6a 34                	push   $0x34
80101a63:	50                   	push   %eax
80101a64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a67:	50                   	push   %eax
80101a68:	e8 33 37 00 00       	call   801051a0 <memmove>
    brelse(bp);
80101a6d:	89 34 24             	mov    %esi,(%esp)
80101a70:	e8 7b e7 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101a75:	83 c4 10             	add    $0x10,%esp
80101a78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a84:	0f 85 7b ff ff ff    	jne    80101a05 <ilock+0x35>
      panic("ilock: no type");
80101a8a:	83 ec 0c             	sub    $0xc,%esp
80101a8d:	68 32 8d 10 80       	push   $0x80108d32
80101a92:	e8 f9 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101a97:	83 ec 0c             	sub    $0xc,%esp
80101a9a:	68 2c 8d 10 80       	push   $0x80108d2c
80101a9f:	e8 ec e8 ff ff       	call   80100390 <panic>
80101aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <iunlock>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	56                   	push   %esi
80101ab8:	53                   	push   %ebx
80101ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101abc:	85 db                	test   %ebx,%ebx
80101abe:	74 28                	je     80101ae8 <iunlock+0x38>
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ac6:	56                   	push   %esi
80101ac7:	e8 44 33 00 00       	call   80104e10 <holdingsleep>
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	85 c0                	test   %eax,%eax
80101ad1:	74 15                	je     80101ae8 <iunlock+0x38>
80101ad3:	8b 43 08             	mov    0x8(%ebx),%eax
80101ad6:	85 c0                	test   %eax,%eax
80101ad8:	7e 0e                	jle    80101ae8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101ada:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101add:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae0:	5b                   	pop    %ebx
80101ae1:	5e                   	pop    %esi
80101ae2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101ae3:	e9 e8 32 00 00       	jmp    80104dd0 <releasesleep>
    panic("iunlock");
80101ae8:	83 ec 0c             	sub    $0xc,%esp
80101aeb:	68 41 8d 10 80       	push   $0x80108d41
80101af0:	e8 9b e8 ff ff       	call   80100390 <panic>
80101af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b00 <iput>:
{
80101b00:	f3 0f 1e fb          	endbr32 
80101b04:	55                   	push   %ebp
80101b05:	89 e5                	mov    %esp,%ebp
80101b07:	57                   	push   %edi
80101b08:	56                   	push   %esi
80101b09:	53                   	push   %ebx
80101b0a:	83 ec 28             	sub    $0x28,%esp
80101b0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b10:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b13:	57                   	push   %edi
80101b14:	e8 57 32 00 00       	call   80104d70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b19:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b1c:	83 c4 10             	add    $0x10,%esp
80101b1f:	85 d2                	test   %edx,%edx
80101b21:	74 07                	je     80101b2a <iput+0x2a>
80101b23:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b28:	74 36                	je     80101b60 <iput+0x60>
  releasesleep(&ip->lock);
80101b2a:	83 ec 0c             	sub    $0xc,%esp
80101b2d:	57                   	push   %edi
80101b2e:	e8 9d 32 00 00       	call   80104dd0 <releasesleep>
  acquire(&icache.lock);
80101b33:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80101b3a:	e8 b1 34 00 00       	call   80104ff0 <acquire>
  ip->ref--;
80101b3f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	c7 45 08 e0 3d 11 80 	movl   $0x80113de0,0x8(%ebp)
}
80101b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b50:	5b                   	pop    %ebx
80101b51:	5e                   	pop    %esi
80101b52:	5f                   	pop    %edi
80101b53:	5d                   	pop    %ebp
  release(&icache.lock);
80101b54:	e9 57 35 00 00       	jmp    801050b0 <release>
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 e0 3d 11 80       	push   $0x80113de0
80101b68:	e8 83 34 00 00       	call   80104ff0 <acquire>
    int r = ip->ref;
80101b6d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b70:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80101b77:	e8 34 35 00 00       	call   801050b0 <release>
    if(r == 1){
80101b7c:	83 c4 10             	add    $0x10,%esp
80101b7f:	83 fe 01             	cmp    $0x1,%esi
80101b82:	75 a6                	jne    80101b2a <iput+0x2a>
80101b84:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b8a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b8d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b90:	89 cf                	mov    %ecx,%edi
80101b92:	eb 0b                	jmp    80101b9f <iput+0x9f>
80101b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b98:	83 c6 04             	add    $0x4,%esi
80101b9b:	39 fe                	cmp    %edi,%esi
80101b9d:	74 19                	je     80101bb8 <iput+0xb8>
    if(ip->addrs[i]){
80101b9f:	8b 16                	mov    (%esi),%edx
80101ba1:	85 d2                	test   %edx,%edx
80101ba3:	74 f3                	je     80101b98 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101ba5:	8b 03                	mov    (%ebx),%eax
80101ba7:	e8 74 f8 ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101bac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101bb2:	eb e4                	jmp    80101b98 <iput+0x98>
80101bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101bb8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101bbe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	75 33                	jne    80101bf8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101bc5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101bc8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101bcf:	53                   	push   %ebx
80101bd0:	e8 3b fd ff ff       	call   80101910 <iupdate>
      ip->type = 0;
80101bd5:	31 c0                	xor    %eax,%eax
80101bd7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101bdb:	89 1c 24             	mov    %ebx,(%esp)
80101bde:	e8 2d fd ff ff       	call   80101910 <iupdate>
      ip->valid = 0;
80101be3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	e9 38 ff ff ff       	jmp    80101b2a <iput+0x2a>
80101bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101bf8:	83 ec 08             	sub    $0x8,%esp
80101bfb:	50                   	push   %eax
80101bfc:	ff 33                	pushl  (%ebx)
80101bfe:	e8 cd e4 ff ff       	call   801000d0 <bread>
80101c03:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c06:	83 c4 10             	add    $0x10,%esp
80101c09:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c12:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c15:	89 cf                	mov    %ecx,%edi
80101c17:	eb 0e                	jmp    80101c27 <iput+0x127>
80101c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c20:	83 c6 04             	add    $0x4,%esi
80101c23:	39 f7                	cmp    %esi,%edi
80101c25:	74 19                	je     80101c40 <iput+0x140>
      if(a[j])
80101c27:	8b 16                	mov    (%esi),%edx
80101c29:	85 d2                	test   %edx,%edx
80101c2b:	74 f3                	je     80101c20 <iput+0x120>
        bfree(ip->dev, a[j]);
80101c2d:	8b 03                	mov    (%ebx),%eax
80101c2f:	e8 ec f7 ff ff       	call   80101420 <bfree>
80101c34:	eb ea                	jmp    80101c20 <iput+0x120>
80101c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101c40:	83 ec 0c             	sub    $0xc,%esp
80101c43:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c46:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c49:	e8 a2 e5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c4e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c54:	8b 03                	mov    (%ebx),%eax
80101c56:	e8 c5 f7 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c65:	00 00 00 
80101c68:	e9 58 ff ff ff       	jmp    80101bc5 <iput+0xc5>
80101c6d:	8d 76 00             	lea    0x0(%esi),%esi

80101c70 <iunlockput>:
{
80101c70:	f3 0f 1e fb          	endbr32 
80101c74:	55                   	push   %ebp
80101c75:	89 e5                	mov    %esp,%ebp
80101c77:	53                   	push   %ebx
80101c78:	83 ec 10             	sub    $0x10,%esp
80101c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c7e:	53                   	push   %ebx
80101c7f:	e8 2c fe ff ff       	call   80101ab0 <iunlock>
  iput(ip);
80101c84:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c87:	83 c4 10             	add    $0x10,%esp
}
80101c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c8d:	c9                   	leave  
  iput(ip);
80101c8e:	e9 6d fe ff ff       	jmp    80101b00 <iput>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	8b 55 08             	mov    0x8(%ebp),%edx
80101caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cad:	8b 0a                	mov    (%edx),%ecx
80101caf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cb2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101cb5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101cb8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101cbc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101cbf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cc3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cc7:	8b 52 58             	mov    0x58(%edx),%edx
80101cca:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ccd:	5d                   	pop    %ebp
80101cce:	c3                   	ret    
80101ccf:	90                   	nop

80101cd0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	57                   	push   %edi
80101cd8:	56                   	push   %esi
80101cd9:	53                   	push   %ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
80101cdd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce3:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ce9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cec:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cf4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101cf7:	0f 84 a3 00 00 00    	je     80101da0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101cfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d00:	8b 40 58             	mov    0x58(%eax),%eax
80101d03:	39 c6                	cmp    %eax,%esi
80101d05:	0f 87 b6 00 00 00    	ja     80101dc1 <readi+0xf1>
80101d0b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d0e:	31 c9                	xor    %ecx,%ecx
80101d10:	89 da                	mov    %ebx,%edx
80101d12:	01 f2                	add    %esi,%edx
80101d14:	0f 92 c1             	setb   %cl
80101d17:	89 cf                	mov    %ecx,%edi
80101d19:	0f 82 a2 00 00 00    	jb     80101dc1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d1f:	89 c1                	mov    %eax,%ecx
80101d21:	29 f1                	sub    %esi,%ecx
80101d23:	39 d0                	cmp    %edx,%eax
80101d25:	0f 43 cb             	cmovae %ebx,%ecx
80101d28:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d2b:	85 c9                	test   %ecx,%ecx
80101d2d:	74 63                	je     80101d92 <readi+0xc2>
80101d2f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d33:	89 f2                	mov    %esi,%edx
80101d35:	c1 ea 09             	shr    $0x9,%edx
80101d38:	89 d8                	mov    %ebx,%eax
80101d3a:	e8 61 f9 ff ff       	call   801016a0 <bmap>
80101d3f:	83 ec 08             	sub    $0x8,%esp
80101d42:	50                   	push   %eax
80101d43:	ff 33                	pushl  (%ebx)
80101d45:	e8 86 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101d4d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d52:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d55:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d57:	89 f0                	mov    %esi,%eax
80101d59:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d5e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d60:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d63:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d65:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d69:	39 d9                	cmp    %ebx,%ecx
80101d6b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d6e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d6f:	01 df                	add    %ebx,%edi
80101d71:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d73:	50                   	push   %eax
80101d74:	ff 75 e0             	pushl  -0x20(%ebp)
80101d77:	e8 24 34 00 00       	call   801051a0 <memmove>
    brelse(bp);
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	89 14 24             	mov    %edx,(%esp)
80101d82:	e8 69 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d87:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d8a:	83 c4 10             	add    $0x10,%esp
80101d8d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d90:	77 9e                	ja     80101d30 <readi+0x60>
  }
  return n;
80101d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d98:	5b                   	pop    %ebx
80101d99:	5e                   	pop    %esi
80101d9a:	5f                   	pop    %edi
80101d9b:	5d                   	pop    %ebp
80101d9c:	c3                   	ret    
80101d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 17                	ja     80101dc1 <readi+0xf1>
80101daa:	8b 04 c5 60 3d 11 80 	mov    -0x7feec2a0(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 0c                	je     80101dc1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101db5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101dbf:	ff e0                	jmp    *%eax
      return -1;
80101dc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc6:	eb cd                	jmp    80101d95 <readi+0xc5>
80101dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcf:	90                   	nop

80101dd0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101dd0:	f3 0f 1e fb          	endbr32 
80101dd4:	55                   	push   %ebp
80101dd5:	89 e5                	mov    %esp,%ebp
80101dd7:	57                   	push   %edi
80101dd8:	56                   	push   %esi
80101dd9:	53                   	push   %ebx
80101dda:	83 ec 1c             	sub    $0x1c,%esp
80101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80101de0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101de3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101de6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101deb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101dee:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101df1:	8b 75 10             	mov    0x10(%ebp),%esi
80101df4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101df7:	0f 84 b3 00 00 00    	je     80101eb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101dfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e00:	39 70 58             	cmp    %esi,0x58(%eax)
80101e03:	0f 82 e3 00 00 00    	jb     80101eec <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e09:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e0c:	89 f8                	mov    %edi,%eax
80101e0e:	01 f0                	add    %esi,%eax
80101e10:	0f 82 d6 00 00 00    	jb     80101eec <writei+0x11c>
80101e16:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e1b:	0f 87 cb 00 00 00    	ja     80101eec <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e28:	85 ff                	test   %edi,%edi
80101e2a:	74 75                	je     80101ea1 <writei+0xd1>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e33:	89 f2                	mov    %esi,%edx
80101e35:	c1 ea 09             	shr    $0x9,%edx
80101e38:	89 f8                	mov    %edi,%eax
80101e3a:	e8 61 f8 ff ff       	call   801016a0 <bmap>
80101e3f:	83 ec 08             	sub    $0x8,%esp
80101e42:	50                   	push   %eax
80101e43:	ff 37                	pushl  (%edi)
80101e45:	e8 86 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e4a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e4f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e52:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e55:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e57:	89 f0                	mov    %esi,%eax
80101e59:	83 c4 0c             	add    $0xc,%esp
80101e5c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e61:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e63:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e67:	39 d9                	cmp    %ebx,%ecx
80101e69:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e6c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e6d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e6f:	ff 75 dc             	pushl  -0x24(%ebp)
80101e72:	50                   	push   %eax
80101e73:	e8 28 33 00 00       	call   801051a0 <memmove>
    log_write(bp);
80101e78:	89 3c 24             	mov    %edi,(%esp)
80101e7b:	e8 50 19 00 00       	call   801037d0 <log_write>
    brelse(bp);
80101e80:	89 3c 24             	mov    %edi,(%esp)
80101e83:	e8 68 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e88:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e8b:	83 c4 10             	add    $0x10,%esp
80101e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e91:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e94:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e97:	77 97                	ja     80101e30 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e9c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e9f:	77 37                	ja     80101ed8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret    
80101eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101eb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101eb4:	66 83 f8 09          	cmp    $0x9,%ax
80101eb8:	77 32                	ja     80101eec <writei+0x11c>
80101eba:	8b 04 c5 64 3d 11 80 	mov    -0x7feec29c(,%eax,8),%eax
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	74 27                	je     80101eec <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ec5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecb:	5b                   	pop    %ebx
80101ecc:	5e                   	pop    %esi
80101ecd:	5f                   	pop    %edi
80101ece:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101ecf:	ff e0                	jmp    *%eax
80101ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ed8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101edb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ede:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ee1:	50                   	push   %eax
80101ee2:	e8 29 fa ff ff       	call   80101910 <iupdate>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	eb b5                	jmp    80101ea1 <writei+0xd1>
      return -1;
80101eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef1:	eb b1                	jmp    80101ea4 <writei+0xd4>
80101ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f00:	f3 0f 1e fb          	endbr32 
80101f04:	55                   	push   %ebp
80101f05:	89 e5                	mov    %esp,%ebp
80101f07:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f0a:	6a 0e                	push   $0xe
80101f0c:	ff 75 0c             	pushl  0xc(%ebp)
80101f0f:	ff 75 08             	pushl  0x8(%ebp)
80101f12:	e8 f9 32 00 00       	call   80105210 <strncmp>
}
80101f17:	c9                   	leave  
80101f18:	c3                   	ret    
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
80101f2a:	83 ec 1c             	sub    $0x1c,%esp
80101f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f35:	0f 85 89 00 00 00    	jne    80101fc4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f3b:	8b 53 58             	mov    0x58(%ebx),%edx
80101f3e:	31 ff                	xor    %edi,%edi
80101f40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f43:	85 d2                	test   %edx,%edx
80101f45:	74 42                	je     80101f89 <dirlookup+0x69>
80101f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f50:	6a 10                	push   $0x10
80101f52:	57                   	push   %edi
80101f53:	56                   	push   %esi
80101f54:	53                   	push   %ebx
80101f55:	e8 76 fd ff ff       	call   80101cd0 <readi>
80101f5a:	83 c4 10             	add    $0x10,%esp
80101f5d:	83 f8 10             	cmp    $0x10,%eax
80101f60:	75 55                	jne    80101fb7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101f62:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f67:	74 18                	je     80101f81 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101f69:	83 ec 04             	sub    $0x4,%esp
80101f6c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f6f:	6a 0e                	push   $0xe
80101f71:	50                   	push   %eax
80101f72:	ff 75 0c             	pushl  0xc(%ebp)
80101f75:	e8 96 32 00 00       	call   80105210 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 17                	je     80101f98 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f81:	83 c7 10             	add    $0x10,%edi
80101f84:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f87:	72 c7                	jb     80101f50 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f8c:	31 c0                	xor    %eax,%eax
}
80101f8e:	5b                   	pop    %ebx
80101f8f:	5e                   	pop    %esi
80101f90:	5f                   	pop    %edi
80101f91:	5d                   	pop    %ebp
80101f92:	c3                   	ret    
80101f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f97:	90                   	nop
      if(poff)
80101f98:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9b:	85 c0                	test   %eax,%eax
80101f9d:	74 05                	je     80101fa4 <dirlookup+0x84>
        *poff = off;
80101f9f:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101fa4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101fa8:	8b 03                	mov    (%ebx),%eax
80101faa:	e8 01 f6 ff ff       	call   801015b0 <iget>
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	5b                   	pop    %ebx
80101fb3:	5e                   	pop    %esi
80101fb4:	5f                   	pop    %edi
80101fb5:	5d                   	pop    %ebp
80101fb6:	c3                   	ret    
      panic("dirlookup read");
80101fb7:	83 ec 0c             	sub    $0xc,%esp
80101fba:	68 5b 8d 10 80       	push   $0x80108d5b
80101fbf:	e8 cc e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101fc4:	83 ec 0c             	sub    $0xc,%esp
80101fc7:	68 49 8d 10 80       	push   $0x80108d49
80101fcc:	e8 bf e3 ff ff       	call   80100390 <panic>
80101fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdf:	90                   	nop

80101fe0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	89 c3                	mov    %eax,%ebx
80101fe8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101feb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101fee:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ff1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ff4:	0f 84 86 01 00 00    	je     80102180 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ffa:	e8 41 22 00 00       	call   80104240 <myproc>
  acquire(&icache.lock);
80101fff:	83 ec 0c             	sub    $0xc,%esp
80102002:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102004:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102007:	68 e0 3d 11 80       	push   $0x80113de0
8010200c:	e8 df 2f 00 00       	call   80104ff0 <acquire>
  ip->ref++;
80102011:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102015:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
8010201c:	e8 8f 30 00 00       	call   801050b0 <release>
80102021:	83 c4 10             	add    $0x10,%esp
80102024:	eb 0d                	jmp    80102033 <namex+0x53>
80102026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102030:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102033:	0f b6 07             	movzbl (%edi),%eax
80102036:	3c 2f                	cmp    $0x2f,%al
80102038:	74 f6                	je     80102030 <namex+0x50>
  if(*path == 0)
8010203a:	84 c0                	test   %al,%al
8010203c:	0f 84 ee 00 00 00    	je     80102130 <namex+0x150>
  while(*path != '/' && *path != 0)
80102042:	0f b6 07             	movzbl (%edi),%eax
80102045:	84 c0                	test   %al,%al
80102047:	0f 84 fb 00 00 00    	je     80102148 <namex+0x168>
8010204d:	89 fb                	mov    %edi,%ebx
8010204f:	3c 2f                	cmp    $0x2f,%al
80102051:	0f 84 f1 00 00 00    	je     80102148 <namex+0x168>
80102057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205e:	66 90                	xchg   %ax,%ax
80102060:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102064:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102067:	3c 2f                	cmp    $0x2f,%al
80102069:	74 04                	je     8010206f <namex+0x8f>
8010206b:	84 c0                	test   %al,%al
8010206d:	75 f1                	jne    80102060 <namex+0x80>
  len = path - s;
8010206f:	89 d8                	mov    %ebx,%eax
80102071:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102073:	83 f8 0d             	cmp    $0xd,%eax
80102076:	0f 8e 84 00 00 00    	jle    80102100 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010207c:	83 ec 04             	sub    $0x4,%esp
8010207f:	6a 0e                	push   $0xe
80102081:	57                   	push   %edi
    path++;
80102082:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102084:	ff 75 e4             	pushl  -0x1c(%ebp)
80102087:	e8 14 31 00 00       	call   801051a0 <memmove>
8010208c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010208f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102092:	75 0c                	jne    801020a0 <namex+0xc0>
80102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102098:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010209b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010209e:	74 f8                	je     80102098 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020a0:	83 ec 0c             	sub    $0xc,%esp
801020a3:	56                   	push   %esi
801020a4:	e8 27 f9 ff ff       	call   801019d0 <ilock>
    if(ip->type != T_DIR){
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020b1:	0f 85 a1 00 00 00    	jne    80102158 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020ba:	85 d2                	test   %edx,%edx
801020bc:	74 09                	je     801020c7 <namex+0xe7>
801020be:	80 3f 00             	cmpb   $0x0,(%edi)
801020c1:	0f 84 d9 00 00 00    	je     801021a0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020c7:	83 ec 04             	sub    $0x4,%esp
801020ca:	6a 00                	push   $0x0
801020cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801020cf:	56                   	push   %esi
801020d0:	e8 4b fe ff ff       	call   80101f20 <dirlookup>
801020d5:	83 c4 10             	add    $0x10,%esp
801020d8:	89 c3                	mov    %eax,%ebx
801020da:	85 c0                	test   %eax,%eax
801020dc:	74 7a                	je     80102158 <namex+0x178>
  iunlock(ip);
801020de:	83 ec 0c             	sub    $0xc,%esp
801020e1:	56                   	push   %esi
801020e2:	e8 c9 f9 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
801020e7:	89 34 24             	mov    %esi,(%esp)
801020ea:	89 de                	mov    %ebx,%esi
801020ec:	e8 0f fa ff ff       	call   80101b00 <iput>
801020f1:	83 c4 10             	add    $0x10,%esp
801020f4:	e9 3a ff ff ff       	jmp    80102033 <namex+0x53>
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102100:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102103:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102106:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102109:	83 ec 04             	sub    $0x4,%esp
8010210c:	50                   	push   %eax
8010210d:	57                   	push   %edi
    name[len] = 0;
8010210e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102110:	ff 75 e4             	pushl  -0x1c(%ebp)
80102113:	e8 88 30 00 00       	call   801051a0 <memmove>
    name[len] = 0;
80102118:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	c6 00 00             	movb   $0x0,(%eax)
80102121:	e9 69 ff ff ff       	jmp    8010208f <namex+0xaf>
80102126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102130:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102133:	85 c0                	test   %eax,%eax
80102135:	0f 85 85 00 00 00    	jne    801021c0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010213b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213e:	89 f0                	mov    %esi,%eax
80102140:	5b                   	pop    %ebx
80102141:	5e                   	pop    %esi
80102142:	5f                   	pop    %edi
80102143:	5d                   	pop    %ebp
80102144:	c3                   	ret    
80102145:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010214b:	89 fb                	mov    %edi,%ebx
8010214d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102150:	31 c0                	xor    %eax,%eax
80102152:	eb b5                	jmp    80102109 <namex+0x129>
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	56                   	push   %esi
8010215c:	e8 4f f9 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
80102161:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102164:	31 f6                	xor    %esi,%esi
  iput(ip);
80102166:	e8 95 f9 ff ff       	call   80101b00 <iput>
      return 0;
8010216b:	83 c4 10             	add    $0x10,%esp
}
8010216e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102171:	89 f0                	mov    %esi,%eax
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret    
80102178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102180:	ba 01 00 00 00       	mov    $0x1,%edx
80102185:	b8 01 00 00 00       	mov    $0x1,%eax
8010218a:	89 df                	mov    %ebx,%edi
8010218c:	e8 1f f4 ff ff       	call   801015b0 <iget>
80102191:	89 c6                	mov    %eax,%esi
80102193:	e9 9b fe ff ff       	jmp    80102033 <namex+0x53>
80102198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219f:	90                   	nop
      iunlock(ip);
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	56                   	push   %esi
801021a4:	e8 07 f9 ff ff       	call   80101ab0 <iunlock>
      return ip;
801021a9:	83 c4 10             	add    $0x10,%esp
}
801021ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021af:	89 f0                	mov    %esi,%eax
801021b1:	5b                   	pop    %ebx
801021b2:	5e                   	pop    %esi
801021b3:	5f                   	pop    %edi
801021b4:	5d                   	pop    %ebp
801021b5:	c3                   	ret    
801021b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021bd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	56                   	push   %esi
    return 0;
801021c4:	31 f6                	xor    %esi,%esi
    iput(ip);
801021c6:	e8 35 f9 ff ff       	call   80101b00 <iput>
    return 0;
801021cb:	83 c4 10             	add    $0x10,%esp
801021ce:	e9 68 ff ff ff       	jmp    8010213b <namex+0x15b>
801021d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021e0 <dirlink>:
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 20             	sub    $0x20,%esp
801021ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021f0:	6a 00                	push   $0x0
801021f2:	ff 75 0c             	pushl  0xc(%ebp)
801021f5:	53                   	push   %ebx
801021f6:	e8 25 fd ff ff       	call   80101f20 <dirlookup>
801021fb:	83 c4 10             	add    $0x10,%esp
801021fe:	85 c0                	test   %eax,%eax
80102200:	75 6b                	jne    8010226d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102202:	8b 7b 58             	mov    0x58(%ebx),%edi
80102205:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102208:	85 ff                	test   %edi,%edi
8010220a:	74 2d                	je     80102239 <dirlink+0x59>
8010220c:	31 ff                	xor    %edi,%edi
8010220e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102211:	eb 0d                	jmp    80102220 <dirlink+0x40>
80102213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102217:	90                   	nop
80102218:	83 c7 10             	add    $0x10,%edi
8010221b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010221e:	73 19                	jae    80102239 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102220:	6a 10                	push   $0x10
80102222:	57                   	push   %edi
80102223:	56                   	push   %esi
80102224:	53                   	push   %ebx
80102225:	e8 a6 fa ff ff       	call   80101cd0 <readi>
8010222a:	83 c4 10             	add    $0x10,%esp
8010222d:	83 f8 10             	cmp    $0x10,%eax
80102230:	75 4e                	jne    80102280 <dirlink+0xa0>
    if(de.inum == 0)
80102232:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102237:	75 df                	jne    80102218 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102239:	83 ec 04             	sub    $0x4,%esp
8010223c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010223f:	6a 0e                	push   $0xe
80102241:	ff 75 0c             	pushl  0xc(%ebp)
80102244:	50                   	push   %eax
80102245:	e8 16 30 00 00       	call   80105260 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224a:	6a 10                	push   $0x10
  de.inum = inum;
8010224c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224f:	57                   	push   %edi
80102250:	56                   	push   %esi
80102251:	53                   	push   %ebx
  de.inum = inum;
80102252:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102256:	e8 75 fb ff ff       	call   80101dd0 <writei>
8010225b:	83 c4 20             	add    $0x20,%esp
8010225e:	83 f8 10             	cmp    $0x10,%eax
80102261:	75 2a                	jne    8010228d <dirlink+0xad>
  return 0;
80102263:	31 c0                	xor    %eax,%eax
}
80102265:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102268:	5b                   	pop    %ebx
80102269:	5e                   	pop    %esi
8010226a:	5f                   	pop    %edi
8010226b:	5d                   	pop    %ebp
8010226c:	c3                   	ret    
    iput(ip);
8010226d:	83 ec 0c             	sub    $0xc,%esp
80102270:	50                   	push   %eax
80102271:	e8 8a f8 ff ff       	call   80101b00 <iput>
    return -1;
80102276:	83 c4 10             	add    $0x10,%esp
80102279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010227e:	eb e5                	jmp    80102265 <dirlink+0x85>
      panic("dirlink read");
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 6a 8d 10 80       	push   $0x80108d6a
80102288:	e8 03 e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010228d:	83 ec 0c             	sub    $0xc,%esp
80102290:	68 79 94 10 80       	push   $0x80109479
80102295:	e8 f6 e0 ff ff       	call   80100390 <panic>
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <namei>:

struct inode*
namei(char *path)
{
801022a0:	f3 0f 1e fb          	endbr32 
801022a4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022a5:	31 d2                	xor    %edx,%edx
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801022ac:	8b 45 08             	mov    0x8(%ebp),%eax
801022af:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022b2:	e8 29 fd ff ff       	call   80101fe0 <namex>
}
801022b7:	c9                   	leave  
801022b8:	c3                   	ret    
801022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
  return namex(path, 1, name);
801022c5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022ca:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022d2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022d3:	e9 08 fd ff ff       	jmp    80101fe0 <namex>
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801022e0:	f3 0f 1e fb          	endbr32 
801022e4:	55                   	push   %ebp
    char const digit[] = "0123456789";
801022e5:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801022ea:	89 e5                	mov    %esp,%ebp
801022ec:	57                   	push   %edi
801022ed:	56                   	push   %esi
801022ee:	53                   	push   %ebx
801022ef:	83 ec 10             	sub    $0x10,%esp
801022f2:	8b 7d 0c             	mov    0xc(%ebp),%edi
801022f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801022f8:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801022ff:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102306:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010230a:	89 fb                	mov    %edi,%ebx
8010230c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102310:	85 c9                	test   %ecx,%ecx
80102312:	79 08                	jns    8010231c <itoa+0x3c>
        *p++ = '-';
80102314:	c6 07 2d             	movb   $0x2d,(%edi)
80102317:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010231a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010231c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010231e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102327:	90                   	nop
80102328:	89 d0                	mov    %edx,%eax
        ++p;
8010232a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010232d:	f7 e6                	mul    %esi
    }while(shifter);
8010232f:	c1 ea 03             	shr    $0x3,%edx
80102332:	75 f4                	jne    80102328 <itoa+0x48>
    *p = '\0';
80102334:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102337:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102340:	89 c8                	mov    %ecx,%eax
80102342:	83 eb 01             	sub    $0x1,%ebx
80102345:	f7 e6                	mul    %esi
80102347:	c1 ea 03             	shr    $0x3,%edx
8010234a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010234d:	01 c0                	add    %eax,%eax
8010234f:	29 c1                	sub    %eax,%ecx
80102351:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102356:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102358:	88 03                	mov    %al,(%ebx)
    }while(i);
8010235a:	85 d2                	test   %edx,%edx
8010235c:	75 e2                	jne    80102340 <itoa+0x60>
    return b;
}
8010235e:	83 c4 10             	add    $0x10,%esp
80102361:	89 f8                	mov    %edi,%eax
80102363:	5b                   	pop    %ebx
80102364:	5e                   	pop    %esi
80102365:	5f                   	pop    %edi
80102366:	5d                   	pop    %ebp
80102367:	c3                   	ret    
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102370:	f3 0f 1e fb          	endbr32 
80102374:	55                   	push   %ebp
80102375:	89 e5                	mov    %esp,%ebp
80102377:	57                   	push   %edi
80102378:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102379:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010237c:	53                   	push   %ebx
8010237d:	83 ec 40             	sub    $0x40,%esp
80102380:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102383:	6a 06                	push   $0x6
80102385:	68 77 8d 10 80       	push   $0x80108d77
8010238a:	56                   	push   %esi
8010238b:	e8 10 2e 00 00       	call   801051a0 <memmove>
  itoa(p->pid, path+ 6);
80102390:	58                   	pop    %eax
80102391:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102394:	5a                   	pop    %edx
80102395:	50                   	push   %eax
80102396:	ff 73 10             	pushl  0x10(%ebx)
80102399:	e8 42 ff ff ff       	call   801022e0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010239e:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023a1:	83 c4 10             	add    $0x10,%esp
801023a4:	85 c0                	test   %eax,%eax
801023a6:	0f 84 7a 01 00 00    	je     80102526 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
801023ac:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801023af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801023b2:	50                   	push   %eax
801023b3:	e8 78 ed ff ff       	call   80101130 <fileclose>

  begin_op();
801023b8:	e8 33 12 00 00       	call   801035f0 <begin_op>
  return namex(path, 1, name);
801023bd:	89 f0                	mov    %esi,%eax
801023bf:	89 d9                	mov    %ebx,%ecx
801023c1:	ba 01 00 00 00       	mov    $0x1,%edx
801023c6:	e8 15 fc ff ff       	call   80101fe0 <namex>
  if((dp = nameiparent(path, name)) == 0)
801023cb:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
801023ce:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801023d0:	85 c0                	test   %eax,%eax
801023d2:	0f 84 55 01 00 00    	je     8010252d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801023d8:	83 ec 0c             	sub    $0xc,%esp
801023db:	50                   	push   %eax
801023dc:	e8 ef f5 ff ff       	call   801019d0 <ilock>
  return strncmp(s, t, DIRSIZ);
801023e1:	83 c4 0c             	add    $0xc,%esp
801023e4:	6a 0e                	push   $0xe
801023e6:	68 7f 8d 10 80       	push   $0x80108d7f
801023eb:	53                   	push   %ebx
801023ec:	e8 1f 2e 00 00       	call   80105210 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023f1:	83 c4 10             	add    $0x10,%esp
801023f4:	85 c0                	test   %eax,%eax
801023f6:	0f 84 f4 00 00 00    	je     801024f0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023fc:	83 ec 04             	sub    $0x4,%esp
801023ff:	6a 0e                	push   $0xe
80102401:	68 7e 8d 10 80       	push   $0x80108d7e
80102406:	53                   	push   %ebx
80102407:	e8 04 2e 00 00       	call   80105210 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010240c:	83 c4 10             	add    $0x10,%esp
8010240f:	85 c0                	test   %eax,%eax
80102411:	0f 84 d9 00 00 00    	je     801024f0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102417:	83 ec 04             	sub    $0x4,%esp
8010241a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010241d:	50                   	push   %eax
8010241e:	53                   	push   %ebx
8010241f:	56                   	push   %esi
80102420:	e8 fb fa ff ff       	call   80101f20 <dirlookup>
80102425:	83 c4 10             	add    $0x10,%esp
80102428:	89 c3                	mov    %eax,%ebx
8010242a:	85 c0                	test   %eax,%eax
8010242c:	0f 84 be 00 00 00    	je     801024f0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102432:	83 ec 0c             	sub    $0xc,%esp
80102435:	50                   	push   %eax
80102436:	e8 95 f5 ff ff       	call   801019d0 <ilock>

  if(ip->nlink < 1)
8010243b:	83 c4 10             	add    $0x10,%esp
8010243e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102443:	0f 8e 00 01 00 00    	jle    80102549 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102449:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010244e:	74 78                	je     801024c8 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80102450:	83 ec 04             	sub    $0x4,%esp
80102453:	8d 7d d8             	lea    -0x28(%ebp),%edi
80102456:	6a 10                	push   $0x10
80102458:	6a 00                	push   $0x0
8010245a:	57                   	push   %edi
8010245b:	e8 a0 2c 00 00       	call   80105100 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102460:	6a 10                	push   $0x10
80102462:	ff 75 b8             	pushl  -0x48(%ebp)
80102465:	57                   	push   %edi
80102466:	56                   	push   %esi
80102467:	e8 64 f9 ff ff       	call   80101dd0 <writei>
8010246c:	83 c4 20             	add    $0x20,%esp
8010246f:	83 f8 10             	cmp    $0x10,%eax
80102472:	0f 85 c4 00 00 00    	jne    8010253c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102478:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010247d:	0f 84 8d 00 00 00    	je     80102510 <removeSwapFile+0x1a0>
  iunlock(ip);
80102483:	83 ec 0c             	sub    $0xc,%esp
80102486:	56                   	push   %esi
80102487:	e8 24 f6 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
8010248c:	89 34 24             	mov    %esi,(%esp)
8010248f:	e8 6c f6 ff ff       	call   80101b00 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102494:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102499:	89 1c 24             	mov    %ebx,(%esp)
8010249c:	e8 6f f4 ff ff       	call   80101910 <iupdate>
  iunlock(ip);
801024a1:	89 1c 24             	mov    %ebx,(%esp)
801024a4:	e8 07 f6 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
801024a9:	89 1c 24             	mov    %ebx,(%esp)
801024ac:	e8 4f f6 ff ff       	call   80101b00 <iput>
  iunlockput(ip);

  end_op();
801024b1:	e8 aa 11 00 00       	call   80103660 <end_op>

  return 0;
801024b6:	83 c4 10             	add    $0x10,%esp
801024b9:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801024bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024be:	5b                   	pop    %ebx
801024bf:	5e                   	pop    %esi
801024c0:	5f                   	pop    %edi
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c7:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	53                   	push   %ebx
801024cc:	e8 ff 33 00 00       	call   801058d0 <isdirempty>
801024d1:	83 c4 10             	add    $0x10,%esp
801024d4:	85 c0                	test   %eax,%eax
801024d6:	0f 85 74 ff ff ff    	jne    80102450 <removeSwapFile+0xe0>
  iunlock(ip);
801024dc:	83 ec 0c             	sub    $0xc,%esp
801024df:	53                   	push   %ebx
801024e0:	e8 cb f5 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
801024e5:	89 1c 24             	mov    %ebx,(%esp)
801024e8:	e8 13 f6 ff ff       	call   80101b00 <iput>
    goto bad;
801024ed:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	56                   	push   %esi
801024f4:	e8 b7 f5 ff ff       	call   80101ab0 <iunlock>
  iput(ip);
801024f9:	89 34 24             	mov    %esi,(%esp)
801024fc:	e8 ff f5 ff ff       	call   80101b00 <iput>
    end_op();
80102501:	e8 5a 11 00 00       	call   80103660 <end_op>
    return -1;
80102506:	83 c4 10             	add    $0x10,%esp
80102509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010250e:	eb ab                	jmp    801024bb <removeSwapFile+0x14b>
    iupdate(dp);
80102510:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102513:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102518:	56                   	push   %esi
80102519:	e8 f2 f3 ff ff       	call   80101910 <iupdate>
8010251e:	83 c4 10             	add    $0x10,%esp
80102521:	e9 5d ff ff ff       	jmp    80102483 <removeSwapFile+0x113>
    return -1;
80102526:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010252b:	eb 8e                	jmp    801024bb <removeSwapFile+0x14b>
    end_op();
8010252d:	e8 2e 11 00 00       	call   80103660 <end_op>
    return -1;
80102532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102537:	e9 7f ff ff ff       	jmp    801024bb <removeSwapFile+0x14b>
    panic("unlink: writei");
8010253c:	83 ec 0c             	sub    $0xc,%esp
8010253f:	68 93 8d 10 80       	push   $0x80108d93
80102544:	e8 47 de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102549:	83 ec 0c             	sub    $0xc,%esp
8010254c:	68 81 8d 10 80       	push   $0x80108d81
80102551:	e8 3a de ff ff       	call   80100390 <panic>
80102556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255d:	8d 76 00             	lea    0x0(%esi),%esi

80102560 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102569:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
8010256c:	83 ec 14             	sub    $0x14,%esp
8010256f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102572:	6a 06                	push   $0x6
80102574:	68 77 8d 10 80       	push   $0x80108d77
80102579:	56                   	push   %esi
8010257a:	e8 21 2c 00 00       	call   801051a0 <memmove>
  itoa(p->pid, path+ 6);
8010257f:	58                   	pop    %eax
80102580:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102583:	5a                   	pop    %edx
80102584:	50                   	push   %eax
80102585:	ff 73 10             	pushl  0x10(%ebx)
80102588:	e8 53 fd ff ff       	call   801022e0 <itoa>

    begin_op();
8010258d:	e8 5e 10 00 00       	call   801035f0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
80102592:	6a 00                	push   $0x0
80102594:	6a 00                	push   $0x0
80102596:	6a 02                	push   $0x2
80102598:	56                   	push   %esi
80102599:	e8 52 35 00 00       	call   80105af0 <create>
  iunlock(in);
8010259e:	83 c4 14             	add    $0x14,%esp
801025a1:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
801025a2:	89 c6                	mov    %eax,%esi
  iunlock(in);
801025a4:	e8 07 f5 ff ff       	call   80101ab0 <iunlock>

  p->swapFile = filealloc();
801025a9:	e8 c2 ea ff ff       	call   80101070 <filealloc>
  if (p->swapFile == 0)
801025ae:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
801025b1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801025b4:	85 c0                	test   %eax,%eax
801025b6:	74 32                	je     801025ea <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801025b8:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801025bb:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025be:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801025c4:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025c7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801025ce:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025d1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801025d5:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025d8:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801025dc:	e8 7f 10 00 00       	call   80103660 <end_op>

    return 0;
}
801025e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e4:	31 c0                	xor    %eax,%eax
801025e6:	5b                   	pop    %ebx
801025e7:	5e                   	pop    %esi
801025e8:	5d                   	pop    %ebp
801025e9:	c3                   	ret    
    panic("no slot for files on /store");
801025ea:	83 ec 0c             	sub    $0xc,%esp
801025ed:	68 a2 8d 10 80       	push   $0x80108da2
801025f2:	e8 99 dd ff ff       	call   80100390 <panic>
801025f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025fe:	66 90                	xchg   %ax,%ax

80102600 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	57                   	push   %edi
80102608:	56                   	push   %esi
80102609:	53                   	push   %ebx
8010260a:	83 ec 28             	sub    $0x28,%esp
8010260d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102610:	8b 55 10             	mov    0x10(%ebp),%edx
80102613:	8b 75 0c             	mov    0xc(%ebp),%esi
80102616:	8b 7d 14             	mov    0x14(%ebp),%edi
  cprintf("a page has been written to swap\n");
80102619:	68 14 8e 10 80       	push   $0x80108e14
{
8010261e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  cprintf("a page has been written to swap\n");
80102621:	e8 8a e0 ff ff       	call   801006b0 <cprintf>
  p->swapFile->off = placeOnFile;
80102626:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102629:	8b 55 e4             	mov    -0x1c(%ebp),%edx

  return filewrite(p->swapFile, buffer, size);
8010262c:	83 c4 10             	add    $0x10,%esp
  p->swapFile->off = placeOnFile;
8010262f:	89 50 14             	mov    %edx,0x14(%eax)
  return filewrite(p->swapFile, buffer, size);
80102632:	89 7d 10             	mov    %edi,0x10(%ebp)
80102635:	89 75 0c             	mov    %esi,0xc(%ebp)
80102638:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010263b:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010263e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102641:	5b                   	pop    %ebx
80102642:	5e                   	pop    %esi
80102643:	5f                   	pop    %edi
80102644:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102645:	e9 b6 ec ff ff       	jmp    80101300 <filewrite>
8010264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102650 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102650:	f3 0f 1e fb          	endbr32 
80102654:	55                   	push   %ebp
80102655:	89 e5                	mov    %esp,%ebp
80102657:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010265a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010265d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102660:	89 4a 14             	mov    %ecx,0x14(%edx)
  return fileread(p->swapFile, buffer,  size);
80102663:	8b 55 14             	mov    0x14(%ebp),%edx
80102666:	89 55 10             	mov    %edx,0x10(%ebp)
80102669:	8b 40 7c             	mov    0x7c(%eax),%eax
8010266c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010266f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
80102670:	e9 eb eb ff ff       	jmp    80101260 <fileread>
80102675:	66 90                	xchg   %ax,%ax
80102677:	66 90                	xchg   %ax,%ax
80102679:	66 90                	xchg   %ax,%ax
8010267b:	66 90                	xchg   %ax,%ax
8010267d:	66 90                	xchg   %ax,%ax
8010267f:	90                   	nop

80102680 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102689:	85 c0                	test   %eax,%eax
8010268b:	0f 84 b4 00 00 00    	je     80102745 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102691:	8b 70 08             	mov    0x8(%eax),%esi
80102694:	89 c3                	mov    %eax,%ebx
80102696:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010269c:	0f 87 96 00 00 00    	ja     80102738 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801026a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ae:	66 90                	xchg   %ax,%ax
801026b0:	89 ca                	mov    %ecx,%edx
801026b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026b3:	83 e0 c0             	and    $0xffffffc0,%eax
801026b6:	3c 40                	cmp    $0x40,%al
801026b8:	75 f6                	jne    801026b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ba:	31 ff                	xor    %edi,%edi
801026bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801026c1:	89 f8                	mov    %edi,%eax
801026c3:	ee                   	out    %al,(%dx)
801026c4:	b8 01 00 00 00       	mov    $0x1,%eax
801026c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801026ce:	ee                   	out    %al,(%dx)
801026cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026d4:	89 f0                	mov    %esi,%eax
801026d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026d7:	89 f0                	mov    %esi,%eax
801026d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026de:	c1 f8 08             	sar    $0x8,%eax
801026e1:	ee                   	out    %al,(%dx)
801026e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026e7:	89 f8                	mov    %edi,%eax
801026e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801026ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026f3:	c1 e0 04             	shl    $0x4,%eax
801026f6:	83 e0 10             	and    $0x10,%eax
801026f9:	83 c8 e0             	or     $0xffffffe0,%eax
801026fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026fd:	f6 03 04             	testb  $0x4,(%ebx)
80102700:	75 16                	jne    80102718 <idestart+0x98>
80102702:	b8 20 00 00 00       	mov    $0x20,%eax
80102707:	89 ca                	mov    %ecx,%edx
80102709:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010270a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010270d:	5b                   	pop    %ebx
8010270e:	5e                   	pop    %esi
8010270f:	5f                   	pop    %edi
80102710:	5d                   	pop    %ebp
80102711:	c3                   	ret    
80102712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102718:	b8 30 00 00 00       	mov    $0x30,%eax
8010271d:	89 ca                	mov    %ecx,%edx
8010271f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102720:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102725:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102728:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010272d:	fc                   	cld    
8010272e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102730:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102733:	5b                   	pop    %ebx
80102734:	5e                   	pop    %esi
80102735:	5f                   	pop    %edi
80102736:	5d                   	pop    %ebp
80102737:	c3                   	ret    
    panic("incorrect blockno");
80102738:	83 ec 0c             	sub    $0xc,%esp
8010273b:	68 3e 8e 10 80       	push   $0x80108e3e
80102740:	e8 4b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102745:	83 ec 0c             	sub    $0xc,%esp
80102748:	68 35 8e 10 80       	push   $0x80108e35
8010274d:	e8 3e dc ff ff       	call   80100390 <panic>
80102752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102760 <ideinit>:
{
80102760:	f3 0f 1e fb          	endbr32 
80102764:	55                   	push   %ebp
80102765:	89 e5                	mov    %esp,%ebp
80102767:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010276a:	68 50 8e 10 80       	push   $0x80108e50
8010276f:	68 a0 c5 10 80       	push   $0x8010c5a0
80102774:	e8 f7 26 00 00       	call   80104e70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102779:	58                   	pop    %eax
8010277a:	a1 00 61 18 80       	mov    0x80186100,%eax
8010277f:	5a                   	pop    %edx
80102780:	83 e8 01             	sub    $0x1,%eax
80102783:	50                   	push   %eax
80102784:	6a 0e                	push   $0xe
80102786:	e8 b5 02 00 00       	call   80102a40 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010278b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010278e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102797:	90                   	nop
80102798:	ec                   	in     (%dx),%al
80102799:	83 e0 c0             	and    $0xffffffc0,%eax
8010279c:	3c 40                	cmp    $0x40,%al
8010279e:	75 f8                	jne    80102798 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801027a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027aa:	ee                   	out    %al,(%dx)
801027ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027b5:	eb 0e                	jmp    801027c5 <ideinit+0x65>
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801027c0:	83 e9 01             	sub    $0x1,%ecx
801027c3:	74 0f                	je     801027d4 <ideinit+0x74>
801027c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801027c6:	84 c0                	test   %al,%al
801027c8:	74 f6                	je     801027c0 <ideinit+0x60>
      havedisk1 = 1;
801027ca:	c7 05 80 c5 10 80 01 	movl   $0x1,0x8010c580
801027d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801027d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027de:	ee                   	out    %al,(%dx)
}
801027df:	c9                   	leave  
801027e0:	c3                   	ret    
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop

801027f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	57                   	push   %edi
801027f8:	56                   	push   %esi
801027f9:	53                   	push   %ebx
801027fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027fd:	68 a0 c5 10 80       	push   $0x8010c5a0
80102802:	e8 e9 27 00 00       	call   80104ff0 <acquire>

  if((b = idequeue) == 0){
80102807:	8b 1d 84 c5 10 80    	mov    0x8010c584,%ebx
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	85 db                	test   %ebx,%ebx
80102812:	74 5f                	je     80102873 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102814:	8b 43 58             	mov    0x58(%ebx),%eax
80102817:	a3 84 c5 10 80       	mov    %eax,0x8010c584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010281c:	8b 33                	mov    (%ebx),%esi
8010281e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102824:	75 2b                	jne    80102851 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102826:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
80102830:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102831:	89 c1                	mov    %eax,%ecx
80102833:	83 e1 c0             	and    $0xffffffc0,%ecx
80102836:	80 f9 40             	cmp    $0x40,%cl
80102839:	75 f5                	jne    80102830 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010283b:	a8 21                	test   $0x21,%al
8010283d:	75 12                	jne    80102851 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010283f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102842:	b9 80 00 00 00       	mov    $0x80,%ecx
80102847:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010284c:	fc                   	cld    
8010284d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010284f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102851:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102854:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102857:	83 ce 02             	or     $0x2,%esi
8010285a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010285c:	53                   	push   %ebx
8010285d:	e8 9e 22 00 00       	call   80104b00 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102862:	a1 84 c5 10 80       	mov    0x8010c584,%eax
80102867:	83 c4 10             	add    $0x10,%esp
8010286a:	85 c0                	test   %eax,%eax
8010286c:	74 05                	je     80102873 <ideintr+0x83>
    idestart(idequeue);
8010286e:	e8 0d fe ff ff       	call   80102680 <idestart>
    release(&idelock);
80102873:	83 ec 0c             	sub    $0xc,%esp
80102876:	68 a0 c5 10 80       	push   $0x8010c5a0
8010287b:	e8 30 28 00 00       	call   801050b0 <release>

  release(&idelock);
}
80102880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102883:	5b                   	pop    %ebx
80102884:	5e                   	pop    %esi
80102885:	5f                   	pop    %edi
80102886:	5d                   	pop    %ebp
80102887:	c3                   	ret    
80102888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010288f:	90                   	nop

80102890 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	53                   	push   %ebx
80102898:	83 ec 10             	sub    $0x10,%esp
8010289b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010289e:	8d 43 0c             	lea    0xc(%ebx),%eax
801028a1:	50                   	push   %eax
801028a2:	e8 69 25 00 00       	call   80104e10 <holdingsleep>
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	85 c0                	test   %eax,%eax
801028ac:	0f 84 cf 00 00 00    	je     80102981 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028b2:	8b 03                	mov    (%ebx),%eax
801028b4:	83 e0 06             	and    $0x6,%eax
801028b7:	83 f8 02             	cmp    $0x2,%eax
801028ba:	0f 84 b4 00 00 00    	je     80102974 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801028c0:	8b 53 04             	mov    0x4(%ebx),%edx
801028c3:	85 d2                	test   %edx,%edx
801028c5:	74 0d                	je     801028d4 <iderw+0x44>
801028c7:	a1 80 c5 10 80       	mov    0x8010c580,%eax
801028cc:	85 c0                	test   %eax,%eax
801028ce:	0f 84 93 00 00 00    	je     80102967 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801028d4:	83 ec 0c             	sub    $0xc,%esp
801028d7:	68 a0 c5 10 80       	push   $0x8010c5a0
801028dc:	e8 0f 27 00 00       	call   80104ff0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028e1:	a1 84 c5 10 80       	mov    0x8010c584,%eax
  b->qnext = 0;
801028e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	85 c0                	test   %eax,%eax
801028f2:	74 6c                	je     80102960 <iderw+0xd0>
801028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028f8:	89 c2                	mov    %eax,%edx
801028fa:	8b 40 58             	mov    0x58(%eax),%eax
801028fd:	85 c0                	test   %eax,%eax
801028ff:	75 f7                	jne    801028f8 <iderw+0x68>
80102901:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102904:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102906:	39 1d 84 c5 10 80    	cmp    %ebx,0x8010c584
8010290c:	74 42                	je     80102950 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010290e:	8b 03                	mov    (%ebx),%eax
80102910:	83 e0 06             	and    $0x6,%eax
80102913:	83 f8 02             	cmp    $0x2,%eax
80102916:	74 23                	je     8010293b <iderw+0xab>
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop
    sleep(b, &idelock);
80102920:	83 ec 08             	sub    $0x8,%esp
80102923:	68 a0 c5 10 80       	push   $0x8010c5a0
80102928:	53                   	push   %ebx
80102929:	e8 c2 1f 00 00       	call   801048f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010292e:	8b 03                	mov    (%ebx),%eax
80102930:	83 c4 10             	add    $0x10,%esp
80102933:	83 e0 06             	and    $0x6,%eax
80102936:	83 f8 02             	cmp    $0x2,%eax
80102939:	75 e5                	jne    80102920 <iderw+0x90>
  }


  release(&idelock);
8010293b:	c7 45 08 a0 c5 10 80 	movl   $0x8010c5a0,0x8(%ebp)
}
80102942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102945:	c9                   	leave  
  release(&idelock);
80102946:	e9 65 27 00 00       	jmp    801050b0 <release>
8010294b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
    idestart(b);
80102950:	89 d8                	mov    %ebx,%eax
80102952:	e8 29 fd ff ff       	call   80102680 <idestart>
80102957:	eb b5                	jmp    8010290e <iderw+0x7e>
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102960:	ba 84 c5 10 80       	mov    $0x8010c584,%edx
80102965:	eb 9d                	jmp    80102904 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102967:	83 ec 0c             	sub    $0xc,%esp
8010296a:	68 7f 8e 10 80       	push   $0x80108e7f
8010296f:	e8 1c da ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102974:	83 ec 0c             	sub    $0xc,%esp
80102977:	68 6a 8e 10 80       	push   $0x80108e6a
8010297c:	e8 0f da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102981:	83 ec 0c             	sub    $0xc,%esp
80102984:	68 54 8e 10 80       	push   $0x80108e54
80102989:	e8 02 da ff ff       	call   80100390 <panic>
8010298e:	66 90                	xchg   %ax,%ax

80102990 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102995:	c7 05 34 5a 11 80 00 	movl   $0xfec00000,0x80115a34
8010299c:	00 c0 fe 
{
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	56                   	push   %esi
801029a2:	53                   	push   %ebx
  ioapic->reg = reg;
801029a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801029aa:	00 00 00 
  return ioapic->data;
801029ad:	8b 15 34 5a 11 80    	mov    0x80115a34,%edx
801029b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801029b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801029bc:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801029c2:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029c9:	c1 ee 10             	shr    $0x10,%esi
801029cc:	89 f0                	mov    %esi,%eax
801029ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801029d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801029d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801029d7:	39 c2                	cmp    %eax,%edx
801029d9:	74 16                	je     801029f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029db:	83 ec 0c             	sub    $0xc,%esp
801029de:	68 a0 8e 10 80       	push   $0x80108ea0
801029e3:	e8 c8 dc ff ff       	call   801006b0 <cprintf>
801029e8:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
801029ee:	83 c4 10             	add    $0x10,%esp
801029f1:	83 c6 21             	add    $0x21,%esi
{
801029f4:	ba 10 00 00 00       	mov    $0x10,%edx
801029f9:	b8 20 00 00 00       	mov    $0x20,%eax
801029fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102a00:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a02:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102a04:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
80102a0a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a0d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102a13:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102a16:	8d 5a 01             	lea    0x1(%edx),%ebx
80102a19:	83 c2 02             	add    $0x2,%edx
80102a1c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102a1e:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
80102a24:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102a2b:	39 f0                	cmp    %esi,%eax
80102a2d:	75 d1                	jne    80102a00 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a32:	5b                   	pop    %ebx
80102a33:	5e                   	pop    %esi
80102a34:	5d                   	pop    %ebp
80102a35:	c3                   	ret    
80102a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3d:	8d 76 00             	lea    0x0(%esi),%esi

80102a40 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a40:	f3 0f 1e fb          	endbr32 
80102a44:	55                   	push   %ebp
  ioapic->reg = reg;
80102a45:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
{
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a50:	8d 50 20             	lea    0x20(%eax),%edx
80102a53:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a57:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a59:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a62:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a68:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a6a:	a1 34 5a 11 80       	mov    0x80115a34,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a6f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a72:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a75:	5d                   	pop    %ebp
80102a76:	c3                   	ret    
80102a77:	66 90                	xchg   %ax,%ax
80102a79:	66 90                	xchg   %ax,%ax
80102a7b:	66 90                	xchg   %ax,%ax
80102a7d:	66 90                	xchg   %ax,%ax
80102a7f:	90                   	nop

80102a80 <kfree>:
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)

void
kfree(char *v)
{
80102a80:	f3 0f 1e fb          	endbr32 
80102a84:	55                   	push   %ebp
80102a85:	89 e5                	mov    %esp,%ebp
80102a87:	53                   	push   %ebx
80102a88:	83 ec 04             	sub    $0x4,%esp
80102a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a8e:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102a93:	0f 85 af 00 00 00    	jne    80102b48 <kfree+0xc8>
80102a99:	3d a8 75 19 80       	cmp    $0x801975a8,%eax
80102a9e:	0f 82 a4 00 00 00    	jb     80102b48 <kfree+0xc8>
80102aa4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102aaa:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102ab0:	0f 87 92 00 00 00    	ja     80102b48 <kfree+0xc8>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ab6:	83 ec 04             	sub    $0x4,%esp
80102ab9:	68 00 10 00 00       	push   $0x1000
80102abe:	6a 01                	push   $0x1
80102ac0:	50                   	push   %eax
80102ac1:	e8 3a 26 00 00       	call   80105100 <memset>

  if(kmem.use_lock) 
80102ac6:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
80102acc:	83 c4 10             	add    $0x10,%esp
80102acf:	85 d2                	test   %edx,%edx
80102ad1:	75 4d                	jne    80102b20 <kfree+0xa0>
    acquire(&kmem.lock);
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102ad3:	89 d8                	mov    %ebx,%eax
80102ad5:	c1 e8 0c             	shr    $0xc,%eax

  if(r->refcount != 1)
80102ad8:	83 3c c5 80 5a 11 80 	cmpl   $0x1,-0x7feea580(,%eax,8)
80102adf:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102ae0:	8d 50 06             	lea    0x6(%eax),%edx
80102ae3:	8d 0c c5 7c 5a 11 80 	lea    -0x7feea584(,%eax,8),%ecx
  if(r->refcount != 1)
80102aea:	75 69                	jne    80102b55 <kfree+0xd5>
    // cprintf("ref count is %d", r->refcount);
    panic("kfree: freeing a shared page");
  }


  r->next = kmem.freelist;
80102aec:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  r->refcount = 0;
80102af1:	c7 04 d5 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%edx,8)
80102af8:	00 00 00 00 
  kmem.freelist = r;
80102afc:	89 0d 78 5a 11 80    	mov    %ecx,0x80115a78
  r->next = kmem.freelist;
80102b02:	89 04 d5 4c 5a 11 80 	mov    %eax,-0x7feea5b4(,%edx,8)
  if(kmem.use_lock)
80102b09:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102b0e:	85 c0                	test   %eax,%eax
80102b10:	75 26                	jne    80102b38 <kfree+0xb8>
    release(&kmem.lock);
}
80102b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b15:	c9                   	leave  
80102b16:	c3                   	ret    
80102b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102b20:	83 ec 0c             	sub    $0xc,%esp
80102b23:	68 40 5a 11 80       	push   $0x80115a40
80102b28:	e8 c3 24 00 00       	call   80104ff0 <acquire>
80102b2d:	83 c4 10             	add    $0x10,%esp
80102b30:	eb a1                	jmp    80102ad3 <kfree+0x53>
80102b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102b38:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b42:	c9                   	leave  
    release(&kmem.lock);
80102b43:	e9 68 25 00 00       	jmp    801050b0 <release>
    panic("kfree");
80102b48:	83 ec 0c             	sub    $0xc,%esp
80102b4b:	68 d2 8e 10 80       	push   $0x80108ed2
80102b50:	e8 3b d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b55:	83 ec 0c             	sub    $0xc,%esp
80102b58:	68 d8 8e 10 80       	push   $0x80108ed8
80102b5d:	e8 2e d8 ff ff       	call   80100390 <panic>
80102b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b70 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102b70:	f3 0f 1e fb          	endbr32 
80102b74:	55                   	push   %ebp
80102b75:	89 e5                	mov    %esp,%ebp
80102b77:	53                   	push   %ebx
80102b78:	83 ec 04             	sub    $0x4,%esp
80102b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b7e:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102b83:	0f 85 c1 00 00 00    	jne    80102c4a <kfree_nocheck+0xda>
80102b89:	3d a8 75 19 80       	cmp    $0x801975a8,%eax
80102b8e:	0f 82 b6 00 00 00    	jb     80102c4a <kfree_nocheck+0xda>
80102b94:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102b9a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102ba0:	0f 87 a4 00 00 00    	ja     80102c4a <kfree_nocheck+0xda>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ba6:	83 ec 04             	sub    $0x4,%esp
80102ba9:	68 00 10 00 00       	push   $0x1000
80102bae:	6a 01                	push   $0x1
80102bb0:	50                   	push   %eax
80102bb1:	e8 4a 25 00 00       	call   80105100 <memset>

  if(kmem.use_lock) 
80102bb6:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
80102bbc:	83 c4 10             	add    $0x10,%esp
80102bbf:	85 d2                	test   %edx,%edx
80102bc1:	75 35                	jne    80102bf8 <kfree_nocheck+0x88>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102bc3:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bc8:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102bcb:	83 c3 06             	add    $0x6,%ebx
80102bce:	89 04 dd 4c 5a 11 80 	mov    %eax,-0x7feea5b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bd5:	8d 04 dd 4c 5a 11 80 	lea    -0x7feea5b4(,%ebx,8),%eax
  r->refcount = 0;
80102bdc:	c7 04 dd 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%ebx,8)
80102be3:	00 00 00 00 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102be7:	a3 78 5a 11 80       	mov    %eax,0x80115a78
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bef:	c9                   	leave  
80102bf0:	c3                   	ret    
80102bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102bf8:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bfb:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102bfe:	68 40 5a 11 80       	push   $0x80115a40
  r->next = kmem.freelist;
80102c03:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102c06:	e8 e5 23 00 00       	call   80104ff0 <acquire>
  r->next = kmem.freelist;
80102c0b:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(kmem.use_lock)
80102c10:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102c13:	c7 04 dd 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%ebx,8)
80102c1a:	00 00 00 00 
  r->next = kmem.freelist;
80102c1e:	89 04 dd 4c 5a 11 80 	mov    %eax,-0x7feea5b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102c25:	8d 04 dd 4c 5a 11 80 	lea    -0x7feea5b4(,%ebx,8),%eax
80102c2c:	a3 78 5a 11 80       	mov    %eax,0x80115a78
  if(kmem.use_lock)
80102c31:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102c36:	85 c0                	test   %eax,%eax
80102c38:	74 b2                	je     80102bec <kfree_nocheck+0x7c>
    release(&kmem.lock);
80102c3a:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c44:	c9                   	leave  
    release(&kmem.lock);
80102c45:	e9 66 24 00 00       	jmp    801050b0 <release>
    panic("kfree_nocheck");
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	68 f5 8e 10 80       	push   $0x80108ef5
80102c52:	e8 39 d7 ff ff       	call   80100390 <panic>
80102c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5e:	66 90                	xchg   %ax,%ax

80102c60 <freerange>:
{
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
80102c65:	89 e5                	mov    %esp,%ebp
80102c67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c81:	39 de                	cmp    %ebx,%esi
80102c83:	72 1f                	jb     80102ca4 <freerange+0x44>
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102c97:	50                   	push   %eax
80102c98:	e8 d3 fe ff ff       	call   80102b70 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	39 f3                	cmp    %esi,%ebx
80102ca2:	76 e4                	jbe    80102c88 <freerange+0x28>
}
80102ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ca7:	5b                   	pop    %ebx
80102ca8:	5e                   	pop    %esi
80102ca9:	5d                   	pop    %ebp
80102caa:	c3                   	ret    
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop

80102cb0 <kinit1>:
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	56                   	push   %esi
80102cb8:	53                   	push   %ebx
80102cb9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102cbc:	83 ec 08             	sub    $0x8,%esp
80102cbf:	68 03 8f 10 80       	push   $0x80108f03
80102cc4:	68 40 5a 11 80       	push   $0x80115a40
80102cc9:	e8 a2 21 00 00       	call   80104e70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102cce:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cd1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cd4:	c7 05 74 5a 11 80 00 	movl   $0x0,0x80115a74
80102cdb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102cde:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ce4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cf0:	39 de                	cmp    %ebx,%esi
80102cf2:	72 20                	jb     80102d14 <kinit1+0x64>
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102cf8:	83 ec 0c             	sub    $0xc,%esp
80102cfb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102d07:	50                   	push   %eax
80102d08:	e8 63 fe ff ff       	call   80102b70 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d0d:	83 c4 10             	add    $0x10,%esp
80102d10:	39 de                	cmp    %ebx,%esi
80102d12:	73 e4                	jae    80102cf8 <kinit1+0x48>
}
80102d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d17:	5b                   	pop    %ebx
80102d18:	5e                   	pop    %esi
80102d19:	5d                   	pop    %ebp
80102d1a:	c3                   	ret    
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <kinit2>:
{
80102d20:	f3 0f 1e fb          	endbr32 
80102d24:	55                   	push   %ebp
80102d25:	89 e5                	mov    %esp,%ebp
80102d27:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d28:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d2b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d2e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d2f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d35:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d41:	39 de                	cmp    %ebx,%esi
80102d43:	72 1f                	jb     80102d64 <kinit2+0x44>
80102d45:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102d57:	50                   	push   %eax
80102d58:	e8 13 fe ff ff       	call   80102b70 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d5d:	83 c4 10             	add    $0x10,%esp
80102d60:	39 de                	cmp    %ebx,%esi
80102d62:	73 e4                	jae    80102d48 <kinit2+0x28>
  kmem.use_lock = 1;
80102d64:	c7 05 74 5a 11 80 01 	movl   $0x1,0x80115a74
80102d6b:	00 00 00 
}
80102d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d71:	5b                   	pop    %ebx
80102d72:	5e                   	pop    %esi
80102d73:	5d                   	pop    %ebp
80102d74:	c3                   	ret    
80102d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d80 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102d8a:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102d8f:	85 c0                	test   %eax,%eax
80102d91:	75 65                	jne    80102df8 <kalloc+0x78>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d93:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(r)
80102d98:	85 c0                	test   %eax,%eax
80102d9a:	74 54                	je     80102df0 <kalloc+0x70>
  {
    kmem.freelist = r->next;
80102d9c:	8b 10                	mov    (%eax),%edx
80102d9e:	89 15 78 5a 11 80    	mov    %edx,0x80115a78
    r->refcount = 1;
80102da4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102dab:	8b 0d 74 5a 11 80    	mov    0x80115a74,%ecx
80102db1:	85 c9                	test   %ecx,%ecx
80102db3:	75 13                	jne    80102dc8 <kalloc+0x48>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102db5:	2d 7c 5a 11 80       	sub    $0x80115a7c,%eax
80102dba:	c1 e0 09             	shl    $0x9,%eax
80102dbd:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102dc2:	c9                   	leave  
80102dc3:	c3                   	ret    
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102dc8:	83 ec 0c             	sub    $0xc,%esp
80102dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102dce:	68 40 5a 11 80       	push   $0x80115a40
80102dd3:	e8 d8 22 00 00       	call   801050b0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102ddb:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102dde:	2d 7c 5a 11 80       	sub    $0x80115a7c,%eax
80102de3:	c1 e0 09             	shl    $0x9,%eax
80102de6:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
80102deb:	eb d5                	jmp    80102dc2 <kalloc+0x42>
80102ded:	8d 76 00             	lea    0x0(%esi),%esi
}
80102df0:	c9                   	leave  
{
80102df1:	31 c0                	xor    %eax,%eax
}
80102df3:	c3                   	ret    
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 40 5a 11 80       	push   $0x80115a40
80102e00:	e8 eb 21 00 00       	call   80104ff0 <acquire>
  r = kmem.freelist;
80102e05:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(r)
80102e0a:	83 c4 10             	add    $0x10,%esp
80102e0d:	85 c0                	test   %eax,%eax
80102e0f:	75 8b                	jne    80102d9c <kalloc+0x1c>
  if(kmem.use_lock)
80102e11:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
80102e17:	85 d2                	test   %edx,%edx
80102e19:	74 d5                	je     80102df0 <kalloc+0x70>
    release(&kmem.lock);
80102e1b:	83 ec 0c             	sub    $0xc,%esp
80102e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e21:	68 40 5a 11 80       	push   $0x80115a40
80102e26:	e8 85 22 00 00       	call   801050b0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102e2e:	83 c4 10             	add    $0x10,%esp
}
80102e31:	c9                   	leave  
80102e32:	c3                   	ret    
80102e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e40 <refDec>:

void
refDec(char *v)
{
80102e40:	f3 0f 1e fb          	endbr32 
80102e44:	55                   	push   %ebp
80102e45:	89 e5                	mov    %esp,%ebp
80102e47:	53                   	push   %ebx
80102e48:	83 ec 04             	sub    $0x4,%esp
  struct run *r;
  if(kmem.use_lock)
80102e4b:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
{
80102e51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102e54:	85 d2                	test   %edx,%edx
80102e56:	75 18                	jne    80102e70 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e58:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e5e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102e61:	83 2c c5 80 5a 11 80 	subl   $0x1,-0x7feea580(,%eax,8)
80102e68:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6c:	c9                   	leave  
80102e6d:	c3                   	ret    
80102e6e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102e70:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e73:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e79:	68 40 5a 11 80       	push   $0x80115a40
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e7e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e81:	e8 6a 21 00 00       	call   80104ff0 <acquire>
  if(kmem.use_lock)
80102e86:	a1 74 5a 11 80       	mov    0x80115a74,%eax
  r->refcount -= 1;
80102e8b:	83 2c dd 80 5a 11 80 	subl   $0x1,-0x7feea580(,%ebx,8)
80102e92:	01 
  if(kmem.use_lock)
80102e93:	83 c4 10             	add    $0x10,%esp
80102e96:	85 c0                	test   %eax,%eax
80102e98:	74 cf                	je     80102e69 <refDec+0x29>
    release(&kmem.lock);
80102e9a:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ea4:	c9                   	leave  
    release(&kmem.lock);
80102ea5:	e9 06 22 00 00       	jmp    801050b0 <release>
80102eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102eb0 <refInc>:

void
refInc(char *v)
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	53                   	push   %ebx
80102eb8:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102ebb:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
{
80102ec1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102ec4:	85 d2                	test   %edx,%edx
80102ec6:	75 18                	jne    80102ee0 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ec8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102ece:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102ed1:	83 04 c5 80 5a 11 80 	addl   $0x1,-0x7feea580(,%eax,8)
80102ed8:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102ed9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102edc:	c9                   	leave  
80102edd:	c3                   	ret    
80102ede:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ee3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102ee9:	68 40 5a 11 80       	push   $0x80115a40
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102eee:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ef1:	e8 fa 20 00 00       	call   80104ff0 <acquire>
  if(kmem.use_lock)
80102ef6:	a1 74 5a 11 80       	mov    0x80115a74,%eax
  r->refcount += 1;
80102efb:	83 04 dd 80 5a 11 80 	addl   $0x1,-0x7feea580(,%ebx,8)
80102f02:	01 
  if(kmem.use_lock)
80102f03:	83 c4 10             	add    $0x10,%esp
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 cf                	je     80102ed9 <refInc+0x29>
    release(&kmem.lock);
80102f0a:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102f11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f14:	c9                   	leave  
    release(&kmem.lock);
80102f15:	e9 96 21 00 00       	jmp    801050b0 <release>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f20 <getRefs>:

int
getRefs(char *v)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102f27:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
}
80102f2a:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102f2b:	05 00 00 00 80       	add    $0x80000000,%eax
80102f30:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102f33:	8b 04 c5 80 5a 11 80 	mov    -0x7feea580(,%eax,8),%eax
}
80102f3a:	c3                   	ret    
80102f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <getNumOfFreePages>:

int getNumOfFreePages(void) {
80102f40:	f3 0f 1e fb          	endbr32 
  int c = 0;
  struct run *r = kmem.freelist;
80102f44:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  int c = 0;
80102f49:	31 d2                	xor    %edx,%edx
  while(r) {
80102f4b:	85 c0                	test   %eax,%eax
80102f4d:	74 0a                	je     80102f59 <getNumOfFreePages+0x19>
80102f4f:	90                   	nop
    c++;
    r = r->next;
80102f50:	8b 00                	mov    (%eax),%eax
    c++;
80102f52:	83 c2 01             	add    $0x1,%edx
  while(r) {
80102f55:	85 c0                	test   %eax,%eax
80102f57:	75 f7                	jne    80102f50 <getNumOfFreePages+0x10>
  }
  return c;
80102f59:	89 d0                	mov    %edx,%eax
80102f5b:	c3                   	ret    
80102f5c:	66 90                	xchg   %ax,%ax
80102f5e:	66 90                	xchg   %ax,%ax

80102f60 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f60:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f64:	ba 64 00 00 00       	mov    $0x64,%edx
80102f69:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f6a:	a8 01                	test   $0x1,%al
80102f6c:	0f 84 be 00 00 00    	je     80103030 <kbdgetc+0xd0>
{
80102f72:	55                   	push   %ebp
80102f73:	ba 60 00 00 00       	mov    $0x60,%edx
80102f78:	89 e5                	mov    %esp,%ebp
80102f7a:	53                   	push   %ebx
80102f7b:	ec                   	in     (%dx),%al
  return data;
80102f7c:	8b 1d d4 c5 10 80    	mov    0x8010c5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102f82:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102f85:	3c e0                	cmp    $0xe0,%al
80102f87:	74 57                	je     80102fe0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f89:	89 d9                	mov    %ebx,%ecx
80102f8b:	83 e1 40             	and    $0x40,%ecx
80102f8e:	84 c0                	test   %al,%al
80102f90:	78 5e                	js     80102ff0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f92:	85 c9                	test   %ecx,%ecx
80102f94:	74 09                	je     80102f9f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f96:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f99:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f9c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f9f:	0f b6 8a 40 90 10 80 	movzbl -0x7fef6fc0(%edx),%ecx
  shift ^= togglecode[data];
80102fa6:	0f b6 82 40 8f 10 80 	movzbl -0x7fef70c0(%edx),%eax
  shift |= shiftcode[data];
80102fad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102faf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fb1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102fb3:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102fb9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102fbc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fbf:	8b 04 85 20 8f 10 80 	mov    -0x7fef70e0(,%eax,4),%eax
80102fc6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102fca:	74 0b                	je     80102fd7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102fcc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102fcf:	83 fa 19             	cmp    $0x19,%edx
80102fd2:	77 44                	ja     80103018 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102fd4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102fd7:	5b                   	pop    %ebx
80102fd8:	5d                   	pop    %ebp
80102fd9:	c3                   	ret    
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102fe0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102fe3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fe5:	89 1d d4 c5 10 80    	mov    %ebx,0x8010c5d4
}
80102feb:	5b                   	pop    %ebx
80102fec:	5d                   	pop    %ebp
80102fed:	c3                   	ret    
80102fee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ff0:	83 e0 7f             	and    $0x7f,%eax
80102ff3:	85 c9                	test   %ecx,%ecx
80102ff5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ff8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102ffa:	0f b6 8a 40 90 10 80 	movzbl -0x7fef6fc0(%edx),%ecx
80103001:	83 c9 40             	or     $0x40,%ecx
80103004:	0f b6 c9             	movzbl %cl,%ecx
80103007:	f7 d1                	not    %ecx
80103009:	21 d9                	and    %ebx,%ecx
}
8010300b:	5b                   	pop    %ebx
8010300c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010300d:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
80103013:	c3                   	ret    
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103018:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010301b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010301e:	5b                   	pop    %ebx
8010301f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103020:	83 f9 1a             	cmp    $0x1a,%ecx
80103023:	0f 42 c2             	cmovb  %edx,%eax
}
80103026:	c3                   	ret    
80103027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302e:	66 90                	xchg   %ax,%ax
    return -1;
80103030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103035:	c3                   	ret    
80103036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010303d:	8d 76 00             	lea    0x0(%esi),%esi

80103040 <kbdintr>:

void
kbdintr(void)
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	55                   	push   %ebp
80103045:	89 e5                	mov    %esp,%ebp
80103047:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010304a:	68 60 2f 10 80       	push   $0x80102f60
8010304f:	e8 0c d8 ff ff       	call   80100860 <consoleintr>
}
80103054:	83 c4 10             	add    $0x10,%esp
80103057:	c9                   	leave  
80103058:	c3                   	ret    
80103059:	66 90                	xchg   %ax,%ax
8010305b:	66 90                	xchg   %ax,%ax
8010305d:	66 90                	xchg   %ax,%ax
8010305f:	90                   	nop

80103060 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103060:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103064:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
80103069:	85 c0                	test   %eax,%eax
8010306b:	0f 84 c7 00 00 00    	je     80103138 <lapicinit+0xd8>
  lapic[index] = value;
80103071:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103078:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010307b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103085:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103088:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010308b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103092:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103095:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103098:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010309f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801030a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801030ac:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030af:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801030b9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030bc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030bf:	8b 50 30             	mov    0x30(%eax),%edx
801030c2:	c1 ea 10             	shr    $0x10,%edx
801030c5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801030cb:	75 73                	jne    80103140 <lapicinit+0xe0>
  lapic[index] = value;
801030cd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801030d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030da:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030e7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ee:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030f4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030fb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103101:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103108:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010310b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010310e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103115:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103118:	8b 50 20             	mov    0x20(%eax),%edx
8010311b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103120:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103126:	80 e6 10             	and    $0x10,%dh
80103129:	75 f5                	jne    80103120 <lapicinit+0xc0>
  lapic[index] = value;
8010312b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103132:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103135:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103138:	c3                   	ret    
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103140:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103147:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010314a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010314d:	e9 7b ff ff ff       	jmp    801030cd <lapicinit+0x6d>
80103152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103160 <lapicid>:

int
lapicid(void)
{
80103160:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103164:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
80103169:	85 c0                	test   %eax,%eax
8010316b:	74 0b                	je     80103178 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010316d:	8b 40 20             	mov    0x20(%eax),%eax
80103170:	c1 e8 18             	shr    $0x18,%eax
80103173:	c3                   	ret    
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103178:	31 c0                	xor    %eax,%eax
}
8010317a:	c3                   	ret    
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103180:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103184:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
80103189:	85 c0                	test   %eax,%eax
8010318b:	74 0d                	je     8010319a <lapiceoi+0x1a>
  lapic[index] = value;
8010318d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103194:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103197:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010319a:	c3                   	ret    
8010319b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop

801031a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031a0:	f3 0f 1e fb          	endbr32 
}
801031a4:	c3                   	ret    
801031a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031b0:	f3 0f 1e fb          	endbr32 
801031b4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801031ba:	ba 70 00 00 00       	mov    $0x70,%edx
801031bf:	89 e5                	mov    %esp,%ebp
801031c1:	53                   	push   %ebx
801031c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031c8:	ee                   	out    %al,(%dx)
801031c9:	b8 0a 00 00 00       	mov    $0xa,%eax
801031ce:	ba 71 00 00 00       	mov    $0x71,%edx
801031d3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801031d4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031d6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801031d9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801031df:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031e1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801031e4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801031e6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801031e9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801031ec:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801031f2:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
801031f7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031fd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103200:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103207:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010320a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010320d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103214:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103217:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010321a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103220:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103223:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103229:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010322c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103232:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103235:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010323b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010323c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010323f:	5d                   	pop    %ebp
80103240:	c3                   	ret    
80103241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	b8 0b 00 00 00       	mov    $0xb,%eax
8010325a:	ba 70 00 00 00       	mov    $0x70,%edx
8010325f:	89 e5                	mov    %esp,%ebp
80103261:	57                   	push   %edi
80103262:	56                   	push   %esi
80103263:	53                   	push   %ebx
80103264:	83 ec 4c             	sub    $0x4c,%esp
80103267:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103268:	ba 71 00 00 00       	mov    $0x71,%edx
8010326d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010326e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103271:	bb 70 00 00 00       	mov    $0x70,%ebx
80103276:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103280:	31 c0                	xor    %eax,%eax
80103282:	89 da                	mov    %ebx,%edx
80103284:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103285:	b9 71 00 00 00       	mov    $0x71,%ecx
8010328a:	89 ca                	mov    %ecx,%edx
8010328c:	ec                   	in     (%dx),%al
8010328d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103290:	89 da                	mov    %ebx,%edx
80103292:	b8 02 00 00 00       	mov    $0x2,%eax
80103297:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103298:	89 ca                	mov    %ecx,%edx
8010329a:	ec                   	in     (%dx),%al
8010329b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010329e:	89 da                	mov    %ebx,%edx
801032a0:	b8 04 00 00 00       	mov    $0x4,%eax
801032a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032a6:	89 ca                	mov    %ecx,%edx
801032a8:	ec                   	in     (%dx),%al
801032a9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ac:	89 da                	mov    %ebx,%edx
801032ae:	b8 07 00 00 00       	mov    $0x7,%eax
801032b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b4:	89 ca                	mov    %ecx,%edx
801032b6:	ec                   	in     (%dx),%al
801032b7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ba:	89 da                	mov    %ebx,%edx
801032bc:	b8 08 00 00 00       	mov    $0x8,%eax
801032c1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c2:	89 ca                	mov    %ecx,%edx
801032c4:	ec                   	in     (%dx),%al
801032c5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c7:	89 da                	mov    %ebx,%edx
801032c9:	b8 09 00 00 00       	mov    $0x9,%eax
801032ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032cf:	89 ca                	mov    %ecx,%edx
801032d1:	ec                   	in     (%dx),%al
801032d2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d4:	89 da                	mov    %ebx,%edx
801032d6:	b8 0a 00 00 00       	mov    $0xa,%eax
801032db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032dc:	89 ca                	mov    %ecx,%edx
801032de:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801032df:	84 c0                	test   %al,%al
801032e1:	78 9d                	js     80103280 <cmostime+0x30>
  return inb(CMOS_RETURN);
801032e3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801032e7:	89 fa                	mov    %edi,%edx
801032e9:	0f b6 fa             	movzbl %dl,%edi
801032ec:	89 f2                	mov    %esi,%edx
801032ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
801032f1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801032f5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f8:	89 da                	mov    %ebx,%edx
801032fa:	89 7d c8             	mov    %edi,-0x38(%ebp)
801032fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103300:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103304:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103307:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010330a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010330e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103311:	31 c0                	xor    %eax,%eax
80103313:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103314:	89 ca                	mov    %ecx,%edx
80103316:	ec                   	in     (%dx),%al
80103317:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	89 da                	mov    %ebx,%edx
8010331c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010331f:	b8 02 00 00 00       	mov    $0x2,%eax
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	89 ca                	mov    %ecx,%edx
80103327:	ec                   	in     (%dx),%al
80103328:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332b:	89 da                	mov    %ebx,%edx
8010332d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103330:	b8 04 00 00 00       	mov    $0x4,%eax
80103335:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103336:	89 ca                	mov    %ecx,%edx
80103338:	ec                   	in     (%dx),%al
80103339:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333c:	89 da                	mov    %ebx,%edx
8010333e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103341:	b8 07 00 00 00       	mov    $0x7,%eax
80103346:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103347:	89 ca                	mov    %ecx,%edx
80103349:	ec                   	in     (%dx),%al
8010334a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334d:	89 da                	mov    %ebx,%edx
8010334f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103352:	b8 08 00 00 00       	mov    $0x8,%eax
80103357:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103358:	89 ca                	mov    %ecx,%edx
8010335a:	ec                   	in     (%dx),%al
8010335b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335e:	89 da                	mov    %ebx,%edx
80103360:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103363:	b8 09 00 00 00       	mov    $0x9,%eax
80103368:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103369:	89 ca                	mov    %ecx,%edx
8010336b:	ec                   	in     (%dx),%al
8010336c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010336f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103372:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103375:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103378:	6a 18                	push   $0x18
8010337a:	50                   	push   %eax
8010337b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010337e:	50                   	push   %eax
8010337f:	e8 cc 1d 00 00       	call   80105150 <memcmp>
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 c0                	test   %eax,%eax
80103389:	0f 85 f1 fe ff ff    	jne    80103280 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010338f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103393:	75 78                	jne    8010340d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103395:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103398:	89 c2                	mov    %eax,%edx
8010339a:	83 e0 0f             	and    $0xf,%eax
8010339d:	c1 ea 04             	shr    $0x4,%edx
801033a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801033a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033ac:	89 c2                	mov    %eax,%edx
801033ae:	83 e0 0f             	and    $0xf,%eax
801033b1:	c1 ea 04             	shr    $0x4,%edx
801033b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801033bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033c0:	89 c2                	mov    %eax,%edx
801033c2:	83 e0 0f             	and    $0xf,%eax
801033c5:	c1 ea 04             	shr    $0x4,%edx
801033c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801033d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033d4:	89 c2                	mov    %eax,%edx
801033d6:	83 e0 0f             	and    $0xf,%eax
801033d9:	c1 ea 04             	shr    $0x4,%edx
801033dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801033e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033e8:	89 c2                	mov    %eax,%edx
801033ea:	83 e0 0f             	and    $0xf,%eax
801033ed:	c1 ea 04             	shr    $0x4,%edx
801033f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801033f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033fc:	89 c2                	mov    %eax,%edx
801033fe:	83 e0 0f             	and    $0xf,%eax
80103401:	c1 ea 04             	shr    $0x4,%edx
80103404:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103407:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010340a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010340d:	8b 75 08             	mov    0x8(%ebp),%esi
80103410:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103413:	89 06                	mov    %eax,(%esi)
80103415:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103418:	89 46 04             	mov    %eax,0x4(%esi)
8010341b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010341e:	89 46 08             	mov    %eax,0x8(%esi)
80103421:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103424:	89 46 0c             	mov    %eax,0xc(%esi)
80103427:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010342a:	89 46 10             	mov    %eax,0x10(%esi)
8010342d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103430:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103433:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343d:	5b                   	pop    %ebx
8010343e:	5e                   	pop    %esi
8010343f:	5f                   	pop    %edi
80103440:	5d                   	pop    %ebp
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103450:	8b 0d c8 5a 18 80    	mov    0x80185ac8,%ecx
80103456:	85 c9                	test   %ecx,%ecx
80103458:	0f 8e 8a 00 00 00    	jle    801034e8 <install_trans+0x98>
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
80103461:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103462:	31 ff                	xor    %edi,%edi
{
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103470:	a1 b4 5a 18 80       	mov    0x80185ab4,%eax
80103475:	83 ec 08             	sub    $0x8,%esp
80103478:	01 f8                	add    %edi,%eax
8010347a:	83 c0 01             	add    $0x1,%eax
8010347d:	50                   	push   %eax
8010347e:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103484:	e8 47 cc ff ff       	call   801000d0 <bread>
80103489:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010348b:	58                   	pop    %eax
8010348c:	5a                   	pop    %edx
8010348d:	ff 34 bd cc 5a 18 80 	pushl  -0x7fe7a534(,%edi,4)
80103494:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
  for (tail = 0; tail < log.lh.n; tail++) {
8010349a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010349d:	e8 2e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034a5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a7:	8d 46 5c             	lea    0x5c(%esi),%eax
801034aa:	68 00 02 00 00       	push   $0x200
801034af:	50                   	push   %eax
801034b0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801034b3:	50                   	push   %eax
801034b4:	e8 e7 1c 00 00       	call   801051a0 <memmove>
    bwrite(dbuf);  // write dst to disk
801034b9:	89 1c 24             	mov    %ebx,(%esp)
801034bc:	e8 ef cc ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801034c1:	89 34 24             	mov    %esi,(%esp)
801034c4:	e8 27 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801034c9:	89 1c 24             	mov    %ebx,(%esp)
801034cc:	e8 1f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	39 3d c8 5a 18 80    	cmp    %edi,0x80185ac8
801034da:	7f 94                	jg     80103470 <install_trans+0x20>
  }
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	53                   	push   %ebx
801034f4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801034f7:	ff 35 b4 5a 18 80    	pushl  0x80185ab4
801034fd:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103503:	e8 c8 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103508:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010350b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010350d:	a1 c8 5a 18 80       	mov    0x80185ac8,%eax
80103512:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103515:	85 c0                	test   %eax,%eax
80103517:	7e 19                	jle    80103532 <write_head+0x42>
80103519:	31 d2                	xor    %edx,%edx
8010351b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103520:	8b 0c 95 cc 5a 18 80 	mov    -0x7fe7a534(,%edx,4),%ecx
80103527:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010352b:	83 c2 01             	add    $0x1,%edx
8010352e:	39 d0                	cmp    %edx,%eax
80103530:	75 ee                	jne    80103520 <write_head+0x30>
  }
  bwrite(buf);
80103532:	83 ec 0c             	sub    $0xc,%esp
80103535:	53                   	push   %ebx
80103536:	e8 75 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010353b:	89 1c 24             	mov    %ebx,(%esp)
8010353e:	e8 ad cc ff ff       	call   801001f0 <brelse>
}
80103543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103546:	83 c4 10             	add    $0x10,%esp
80103549:	c9                   	leave  
8010354a:	c3                   	ret    
8010354b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <initlog>:
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	53                   	push   %ebx
80103558:	83 ec 2c             	sub    $0x2c,%esp
8010355b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010355e:	68 40 91 10 80       	push   $0x80109140
80103563:	68 80 5a 18 80       	push   $0x80185a80
80103568:	e8 03 19 00 00       	call   80104e70 <initlock>
  readsb(dev, &sb);
8010356d:	58                   	pop    %eax
8010356e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103571:	5a                   	pop    %edx
80103572:	50                   	push   %eax
80103573:	53                   	push   %ebx
80103574:	e8 f7 e1 ff ff       	call   80101770 <readsb>
  log.start = sb.logstart;
80103579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010357c:	59                   	pop    %ecx
  log.dev = dev;
8010357d:	89 1d c4 5a 18 80    	mov    %ebx,0x80185ac4
  log.size = sb.nlog;
80103583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103586:	a3 b4 5a 18 80       	mov    %eax,0x80185ab4
  log.size = sb.nlog;
8010358b:	89 15 b8 5a 18 80    	mov    %edx,0x80185ab8
  struct buf *buf = bread(log.dev, log.start);
80103591:	5a                   	pop    %edx
80103592:	50                   	push   %eax
80103593:	53                   	push   %ebx
80103594:	e8 37 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103599:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010359c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010359f:	89 0d c8 5a 18 80    	mov    %ecx,0x80185ac8
  for (i = 0; i < log.lh.n; i++) {
801035a5:	85 c9                	test   %ecx,%ecx
801035a7:	7e 19                	jle    801035c2 <initlog+0x72>
801035a9:	31 d2                	xor    %edx,%edx
801035ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop
    log.lh.block[i] = lh->block[i];
801035b0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801035b4:	89 1c 95 cc 5a 18 80 	mov    %ebx,-0x7fe7a534(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035bb:	83 c2 01             	add    $0x1,%edx
801035be:	39 d1                	cmp    %edx,%ecx
801035c0:	75 ee                	jne    801035b0 <initlog+0x60>
  brelse(buf);
801035c2:	83 ec 0c             	sub    $0xc,%esp
801035c5:	50                   	push   %eax
801035c6:	e8 25 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801035cb:	e8 80 fe ff ff       	call   80103450 <install_trans>
  log.lh.n = 0;
801035d0:	c7 05 c8 5a 18 80 00 	movl   $0x0,0x80185ac8
801035d7:	00 00 00 
  write_head(); // clear the log
801035da:	e8 11 ff ff ff       	call   801034f0 <write_head>
}
801035df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035e2:	83 c4 10             	add    $0x10,%esp
801035e5:	c9                   	leave  
801035e6:	c3                   	ret    
801035e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035fa:	68 80 5a 18 80       	push   $0x80185a80
801035ff:	e8 ec 19 00 00       	call   80104ff0 <acquire>
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	eb 1c                	jmp    80103625 <begin_op+0x35>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103610:	83 ec 08             	sub    $0x8,%esp
80103613:	68 80 5a 18 80       	push   $0x80185a80
80103618:	68 80 5a 18 80       	push   $0x80185a80
8010361d:	e8 ce 12 00 00       	call   801048f0 <sleep>
80103622:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103625:	a1 c0 5a 18 80       	mov    0x80185ac0,%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	75 e2                	jne    80103610 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010362e:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
80103633:	8b 15 c8 5a 18 80    	mov    0x80185ac8,%edx
80103639:	83 c0 01             	add    $0x1,%eax
8010363c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010363f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103642:	83 fa 1e             	cmp    $0x1e,%edx
80103645:	7f c9                	jg     80103610 <begin_op+0x20>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103647:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010364a:	a3 bc 5a 18 80       	mov    %eax,0x80185abc
      release(&log.lock);
8010364f:	68 80 5a 18 80       	push   $0x80185a80
80103654:	e8 57 1a 00 00       	call   801050b0 <release>
      break;
    }
  }
}
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax

80103660 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103660:	f3 0f 1e fb          	endbr32 
80103664:	55                   	push   %ebp
80103665:	89 e5                	mov    %esp,%ebp
80103667:	57                   	push   %edi
80103668:	56                   	push   %esi
80103669:	53                   	push   %ebx
8010366a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010366d:	68 80 5a 18 80       	push   $0x80185a80
80103672:	e8 79 19 00 00       	call   80104ff0 <acquire>
  log.outstanding -= 1;
80103677:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
  if(log.committing)
8010367c:	8b 35 c0 5a 18 80    	mov    0x80185ac0,%esi
80103682:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103685:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103688:	89 1d bc 5a 18 80    	mov    %ebx,0x80185abc
  if(log.committing)
8010368e:	85 f6                	test   %esi,%esi
80103690:	0f 85 1e 01 00 00    	jne    801037b4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103696:	85 db                	test   %ebx,%ebx
80103698:	0f 85 f2 00 00 00    	jne    80103790 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010369e:	c7 05 c0 5a 18 80 01 	movl   $0x1,0x80185ac0
801036a5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801036a8:	83 ec 0c             	sub    $0xc,%esp
801036ab:	68 80 5a 18 80       	push   $0x80185a80
801036b0:	e8 fb 19 00 00       	call   801050b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801036b5:	8b 0d c8 5a 18 80    	mov    0x80185ac8,%ecx
801036bb:	83 c4 10             	add    $0x10,%esp
801036be:	85 c9                	test   %ecx,%ecx
801036c0:	7f 3e                	jg     80103700 <end_op+0xa0>
    acquire(&log.lock);
801036c2:	83 ec 0c             	sub    $0xc,%esp
801036c5:	68 80 5a 18 80       	push   $0x80185a80
801036ca:	e8 21 19 00 00       	call   80104ff0 <acquire>
    wakeup(&log);
801036cf:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
    log.committing = 0;
801036d6:	c7 05 c0 5a 18 80 00 	movl   $0x0,0x80185ac0
801036dd:	00 00 00 
    wakeup(&log);
801036e0:	e8 1b 14 00 00       	call   80104b00 <wakeup>
    release(&log.lock);
801036e5:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
801036ec:	e8 bf 19 00 00       	call   801050b0 <release>
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036f7:	5b                   	pop    %ebx
801036f8:	5e                   	pop    %esi
801036f9:	5f                   	pop    %edi
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103700:	a1 b4 5a 18 80       	mov    0x80185ab4,%eax
80103705:	83 ec 08             	sub    $0x8,%esp
80103708:	01 d8                	add    %ebx,%eax
8010370a:	83 c0 01             	add    $0x1,%eax
8010370d:	50                   	push   %eax
8010370e:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103714:	e8 b7 c9 ff ff       	call   801000d0 <bread>
80103719:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010371b:	58                   	pop    %eax
8010371c:	5a                   	pop    %edx
8010371d:	ff 34 9d cc 5a 18 80 	pushl  -0x7fe7a534(,%ebx,4)
80103724:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
  for (tail = 0; tail < log.lh.n; tail++) {
8010372a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010372d:	e8 9e c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103732:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103735:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103737:	8d 40 5c             	lea    0x5c(%eax),%eax
8010373a:	68 00 02 00 00       	push   $0x200
8010373f:	50                   	push   %eax
80103740:	8d 46 5c             	lea    0x5c(%esi),%eax
80103743:	50                   	push   %eax
80103744:	e8 57 1a 00 00       	call   801051a0 <memmove>
    bwrite(to);  // write the log
80103749:	89 34 24             	mov    %esi,(%esp)
8010374c:	e8 5f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103751:	89 3c 24             	mov    %edi,(%esp)
80103754:	e8 97 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103759:	89 34 24             	mov    %esi,(%esp)
8010375c:	e8 8f ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	3b 1d c8 5a 18 80    	cmp    0x80185ac8,%ebx
8010376a:	7c 94                	jl     80103700 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010376c:	e8 7f fd ff ff       	call   801034f0 <write_head>
    install_trans(); // Now install writes to home locations
80103771:	e8 da fc ff ff       	call   80103450 <install_trans>
    log.lh.n = 0;
80103776:	c7 05 c8 5a 18 80 00 	movl   $0x0,0x80185ac8
8010377d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103780:	e8 6b fd ff ff       	call   801034f0 <write_head>
80103785:	e9 38 ff ff ff       	jmp    801036c2 <end_op+0x62>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	68 80 5a 18 80       	push   $0x80185a80
80103798:	e8 63 13 00 00       	call   80104b00 <wakeup>
  release(&log.lock);
8010379d:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
801037a4:	e8 07 19 00 00       	call   801050b0 <release>
801037a9:	83 c4 10             	add    $0x10,%esp
}
801037ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037af:	5b                   	pop    %ebx
801037b0:	5e                   	pop    %esi
801037b1:	5f                   	pop    %edi
801037b2:	5d                   	pop    %ebp
801037b3:	c3                   	ret    
    panic("log.committing");
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 44 91 10 80       	push   $0x80109144
801037bc:	e8 cf cb ff ff       	call   80100390 <panic>
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop

801037d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037d0:	f3 0f 1e fb          	endbr32 
801037d4:	55                   	push   %ebp
801037d5:	89 e5                	mov    %esp,%ebp
801037d7:	53                   	push   %ebx
801037d8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037db:	8b 15 c8 5a 18 80    	mov    0x80185ac8,%edx
{
801037e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037e4:	83 fa 1d             	cmp    $0x1d,%edx
801037e7:	0f 8f 91 00 00 00    	jg     8010387e <log_write+0xae>
801037ed:	a1 b8 5a 18 80       	mov    0x80185ab8,%eax
801037f2:	83 e8 01             	sub    $0x1,%eax
801037f5:	39 c2                	cmp    %eax,%edx
801037f7:	0f 8d 81 00 00 00    	jge    8010387e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037fd:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
80103802:	85 c0                	test   %eax,%eax
80103804:	0f 8e 81 00 00 00    	jle    8010388b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010380a:	83 ec 0c             	sub    $0xc,%esp
8010380d:	68 80 5a 18 80       	push   $0x80185a80
80103812:	e8 d9 17 00 00       	call   80104ff0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103817:	8b 15 c8 5a 18 80    	mov    0x80185ac8,%edx
8010381d:	83 c4 10             	add    $0x10,%esp
80103820:	85 d2                	test   %edx,%edx
80103822:	7e 4e                	jle    80103872 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103824:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103827:	31 c0                	xor    %eax,%eax
80103829:	eb 0c                	jmp    80103837 <log_write+0x67>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
80103830:	83 c0 01             	add    $0x1,%eax
80103833:	39 c2                	cmp    %eax,%edx
80103835:	74 29                	je     80103860 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103837:	39 0c 85 cc 5a 18 80 	cmp    %ecx,-0x7fe7a534(,%eax,4)
8010383e:	75 f0                	jne    80103830 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103840:	89 0c 85 cc 5a 18 80 	mov    %ecx,-0x7fe7a534(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103847:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010384d:	c7 45 08 80 5a 18 80 	movl   $0x80185a80,0x8(%ebp)
}
80103854:	c9                   	leave  
  release(&log.lock);
80103855:	e9 56 18 00 00       	jmp    801050b0 <release>
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103860:	89 0c 95 cc 5a 18 80 	mov    %ecx,-0x7fe7a534(,%edx,4)
    log.lh.n++;
80103867:	83 c2 01             	add    $0x1,%edx
8010386a:	89 15 c8 5a 18 80    	mov    %edx,0x80185ac8
80103870:	eb d5                	jmp    80103847 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103872:	8b 43 08             	mov    0x8(%ebx),%eax
80103875:	a3 cc 5a 18 80       	mov    %eax,0x80185acc
  if (i == log.lh.n)
8010387a:	75 cb                	jne    80103847 <log_write+0x77>
8010387c:	eb e9                	jmp    80103867 <log_write+0x97>
    panic("too big a transaction");
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	68 53 91 10 80       	push   $0x80109153
80103886:	e8 05 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010388b:	83 ec 0c             	sub    $0xc,%esp
8010388e:	68 69 91 10 80       	push   $0x80109169
80103893:	e8 f8 ca ff ff       	call   80100390 <panic>
80103898:	66 90                	xchg   %ax,%ax
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038a7:	e8 74 09 00 00       	call   80104220 <cpuid>
801038ac:	89 c3                	mov    %eax,%ebx
801038ae:	e8 6d 09 00 00       	call   80104220 <cpuid>
801038b3:	83 ec 04             	sub    $0x4,%esp
801038b6:	53                   	push   %ebx
801038b7:	50                   	push   %eax
801038b8:	68 84 91 10 80       	push   $0x80109184
801038bd:	e8 ee cd ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801038c2:	e8 49 2b 00 00       	call   80106410 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038c7:	e8 e4 08 00 00       	call   801041b0 <mycpu>
801038cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038ce:	b8 01 00 00 00       	mov    $0x1,%eax
801038d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801038da:	e8 21 0d 00 00       	call   80104600 <scheduler>
801038df:	90                   	nop

801038e0 <mpenter>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038ea:	e8 81 3d 00 00       	call   80107670 <switchkvm>
  seginit();
801038ef:	e8 ec 3c 00 00       	call   801075e0 <seginit>
  lapicinit();
801038f4:	e8 67 f7 ff ff       	call   80103060 <lapicinit>
  mpmain();
801038f9:	e8 a2 ff ff ff       	call   801038a0 <mpmain>
801038fe:	66 90                	xchg   %ax,%ax

80103900 <main>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103908:	83 e4 f0             	and    $0xfffffff0,%esp
8010390b:	ff 71 fc             	pushl  -0x4(%ecx)
8010390e:	55                   	push   %ebp
8010390f:	89 e5                	mov    %esp,%ebp
80103911:	53                   	push   %ebx
80103912:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103913:	83 ec 08             	sub    $0x8,%esp
80103916:	68 00 00 40 80       	push   $0x80400000
8010391b:	68 a8 75 19 80       	push   $0x801975a8
80103920:	e8 8b f3 ff ff       	call   80102cb0 <kinit1>
  kvmalloc();      // kernel page table
80103925:	e8 b6 44 00 00       	call   80107de0 <kvmalloc>
  mpinit();        // detect other processors
8010392a:	e8 91 01 00 00       	call   80103ac0 <mpinit>
  lapicinit();     // interrupt controller
8010392f:	e8 2c f7 ff ff       	call   80103060 <lapicinit>
  seginit();       // segment descriptors
80103934:	e8 a7 3c 00 00       	call   801075e0 <seginit>
  picinit();       // disable pic
80103939:	e8 62 03 00 00       	call   80103ca0 <picinit>
  ioapicinit();    // another interrupt controller
8010393e:	e8 4d f0 ff ff       	call   80102990 <ioapicinit>
  consoleinit();   // console hardware
80103943:	e8 e8 d0 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103948:	e8 e3 2d 00 00       	call   80106730 <uartinit>
  pinit();         // process table
8010394d:	e8 3e 08 00 00       	call   80104190 <pinit>
  tvinit();        // trap vectors
80103952:	e8 39 2a 00 00       	call   80106390 <tvinit>
  binit();         // buffer cache
80103957:	e8 e4 c6 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010395c:	e8 ef d6 ff ff       	call   80101050 <fileinit>
  ideinit();       // disk 
80103961:	e8 fa ed ff ff       	call   80102760 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103966:	83 c4 0c             	add    $0xc,%esp
80103969:	68 8a 00 00 00       	push   $0x8a
8010396e:	68 8c c4 10 80       	push   $0x8010c48c
80103973:	68 00 70 00 80       	push   $0x80007000
80103978:	e8 23 18 00 00       	call   801051a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010397d:	83 c4 10             	add    $0x10,%esp
80103980:	69 05 00 61 18 80 b0 	imul   $0xb0,0x80186100,%eax
80103987:	00 00 00 
8010398a:	05 80 5b 18 80       	add    $0x80185b80,%eax
8010398f:	3d 80 5b 18 80       	cmp    $0x80185b80,%eax
80103994:	76 7a                	jbe    80103a10 <main+0x110>
80103996:	bb 80 5b 18 80       	mov    $0x80185b80,%ebx
8010399b:	eb 1c                	jmp    801039b9 <main+0xb9>
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
801039a0:	69 05 00 61 18 80 b0 	imul   $0xb0,0x80186100,%eax
801039a7:	00 00 00 
801039aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039b0:	05 80 5b 18 80       	add    $0x80185b80,%eax
801039b5:	39 c3                	cmp    %eax,%ebx
801039b7:	73 57                	jae    80103a10 <main+0x110>
    if(c == mycpu())  // We've started already.
801039b9:	e8 f2 07 00 00       	call   801041b0 <mycpu>
801039be:	39 c3                	cmp    %eax,%ebx
801039c0:	74 de                	je     801039a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039c2:	e8 b9 f3 ff ff       	call   80102d80 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801039c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801039ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801038e0,0x80006ff8
801039d1:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039d4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801039db:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801039de:	05 00 10 00 00       	add    $0x1000,%eax
801039e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801039e8:	0f b6 03             	movzbl (%ebx),%eax
801039eb:	68 00 70 00 00       	push   $0x7000
801039f0:	50                   	push   %eax
801039f1:	e8 ba f7 ff ff       	call   801031b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039f6:	83 c4 10             	add    $0x10,%esp
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103a06:	85 c0                	test   %eax,%eax
80103a08:	74 f6                	je     80103a00 <main+0x100>
80103a0a:	eb 94                	jmp    801039a0 <main+0xa0>
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a10:	83 ec 08             	sub    $0x8,%esp
80103a13:	68 00 00 00 8e       	push   $0x8e000000
80103a18:	68 00 00 40 80       	push   $0x80400000
80103a1d:	e8 fe f2 ff ff       	call   80102d20 <kinit2>
  userinit();      // first user process
80103a22:	e8 49 08 00 00       	call   80104270 <userinit>
  initialNumOfFreePages = getNumberOfFreePages();
80103a27:	e8 e4 12 00 00       	call   80104d10 <getNumberOfFreePages>
80103a2c:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  mpmain();        // finish this processor's setup
80103a31:	e8 6a fe ff ff       	call   801038a0 <mpmain>
80103a36:	66 90                	xchg   %ax,%ax
80103a38:	66 90                	xchg   %ax,%ax
80103a3a:	66 90                	xchg   %ax,%ax
80103a3c:	66 90                	xchg   %ax,%ax
80103a3e:	66 90                	xchg   %ax,%ax

80103a40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	57                   	push   %edi
80103a44:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a45:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a4b:	53                   	push   %ebx
  e = addr+len;
80103a4c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a4f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a52:	39 de                	cmp    %ebx,%esi
80103a54:	72 10                	jb     80103a66 <mpsearch1+0x26>
80103a56:	eb 50                	jmp    80103aa8 <mpsearch1+0x68>
80103a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop
80103a60:	89 fe                	mov    %edi,%esi
80103a62:	39 fb                	cmp    %edi,%ebx
80103a64:	76 42                	jbe    80103aa8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a66:	83 ec 04             	sub    $0x4,%esp
80103a69:	8d 7e 10             	lea    0x10(%esi),%edi
80103a6c:	6a 04                	push   $0x4
80103a6e:	68 98 91 10 80       	push   $0x80109198
80103a73:	56                   	push   %esi
80103a74:	e8 d7 16 00 00       	call   80105150 <memcmp>
80103a79:	83 c4 10             	add    $0x10,%esp
80103a7c:	85 c0                	test   %eax,%eax
80103a7e:	75 e0                	jne    80103a60 <mpsearch1+0x20>
80103a80:	89 f2                	mov    %esi,%edx
80103a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a88:	0f b6 0a             	movzbl (%edx),%ecx
80103a8b:	83 c2 01             	add    $0x1,%edx
80103a8e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a90:	39 fa                	cmp    %edi,%edx
80103a92:	75 f4                	jne    80103a88 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a94:	84 c0                	test   %al,%al
80103a96:	75 c8                	jne    80103a60 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a9b:	89 f0                	mov    %esi,%eax
80103a9d:	5b                   	pop    %ebx
80103a9e:	5e                   	pop    %esi
80103a9f:	5f                   	pop    %edi
80103aa0:	5d                   	pop    %ebp
80103aa1:	c3                   	ret    
80103aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103aab:	31 f6                	xor    %esi,%esi
}
80103aad:	5b                   	pop    %ebx
80103aae:	89 f0                	mov    %esi,%eax
80103ab0:	5e                   	pop    %esi
80103ab1:	5f                   	pop    %edi
80103ab2:	5d                   	pop    %ebp
80103ab3:	c3                   	ret    
80103ab4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	57                   	push   %edi
80103ac8:	56                   	push   %esi
80103ac9:	53                   	push   %ebx
80103aca:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103acd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103ad4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103adb:	c1 e0 08             	shl    $0x8,%eax
80103ade:	09 d0                	or     %edx,%eax
80103ae0:	c1 e0 04             	shl    $0x4,%eax
80103ae3:	75 1b                	jne    80103b00 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ae5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103aec:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103af3:	c1 e0 08             	shl    $0x8,%eax
80103af6:	09 d0                	or     %edx,%eax
80103af8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103afb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103b00:	ba 00 04 00 00       	mov    $0x400,%edx
80103b05:	e8 36 ff ff ff       	call   80103a40 <mpsearch1>
80103b0a:	89 c6                	mov    %eax,%esi
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	0f 84 4c 01 00 00    	je     80103c60 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b14:	8b 5e 04             	mov    0x4(%esi),%ebx
80103b17:	85 db                	test   %ebx,%ebx
80103b19:	0f 84 61 01 00 00    	je     80103c80 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103b1f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b22:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103b28:	6a 04                	push   $0x4
80103b2a:	68 9d 91 10 80       	push   $0x8010919d
80103b2f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b33:	e8 18 16 00 00       	call   80105150 <memcmp>
80103b38:	83 c4 10             	add    $0x10,%esp
80103b3b:	85 c0                	test   %eax,%eax
80103b3d:	0f 85 3d 01 00 00    	jne    80103c80 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103b43:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b4a:	3c 01                	cmp    $0x1,%al
80103b4c:	74 08                	je     80103b56 <mpinit+0x96>
80103b4e:	3c 04                	cmp    $0x4,%al
80103b50:	0f 85 2a 01 00 00    	jne    80103c80 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b56:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103b5d:	66 85 d2             	test   %dx,%dx
80103b60:	74 26                	je     80103b88 <mpinit+0xc8>
80103b62:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103b65:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103b67:	31 d2                	xor    %edx,%edx
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b70:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b77:	83 c0 01             	add    $0x1,%eax
80103b7a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b7c:	39 f8                	cmp    %edi,%eax
80103b7e:	75 f0                	jne    80103b70 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b80:	84 d2                	test   %dl,%dl
80103b82:	0f 85 f8 00 00 00    	jne    80103c80 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b88:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b8e:	a3 7c 5a 18 80       	mov    %eax,0x80185a7c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b93:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103b99:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103ba0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ba5:	03 55 e4             	add    -0x1c(%ebp),%edx
80103ba8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103baf:	90                   	nop
80103bb0:	39 c2                	cmp    %eax,%edx
80103bb2:	76 15                	jbe    80103bc9 <mpinit+0x109>
    switch(*p){
80103bb4:	0f b6 08             	movzbl (%eax),%ecx
80103bb7:	80 f9 02             	cmp    $0x2,%cl
80103bba:	74 5c                	je     80103c18 <mpinit+0x158>
80103bbc:	77 42                	ja     80103c00 <mpinit+0x140>
80103bbe:	84 c9                	test   %cl,%cl
80103bc0:	74 6e                	je     80103c30 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103bc2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bc5:	39 c2                	cmp    %eax,%edx
80103bc7:	77 eb                	ja     80103bb4 <mpinit+0xf4>
80103bc9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103bcc:	85 db                	test   %ebx,%ebx
80103bce:	0f 84 b9 00 00 00    	je     80103c8d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103bd4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103bd8:	74 15                	je     80103bef <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bda:	b8 70 00 00 00       	mov    $0x70,%eax
80103bdf:	ba 22 00 00 00       	mov    $0x22,%edx
80103be4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103be5:	ba 23 00 00 00       	mov    $0x23,%edx
80103bea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103beb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bee:	ee                   	out    %al,(%dx)
  }
}
80103bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5f                   	pop    %edi
80103bf5:	5d                   	pop    %ebp
80103bf6:	c3                   	ret    
80103bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bfe:	66 90                	xchg   %ax,%ax
    switch(*p){
80103c00:	83 e9 03             	sub    $0x3,%ecx
80103c03:	80 f9 01             	cmp    $0x1,%cl
80103c06:	76 ba                	jbe    80103bc2 <mpinit+0x102>
80103c08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103c0f:	eb 9f                	jmp    80103bb0 <mpinit+0xf0>
80103c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103c18:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103c1c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103c1f:	88 0d 60 5b 18 80    	mov    %cl,0x80185b60
      continue;
80103c25:	eb 89                	jmp    80103bb0 <mpinit+0xf0>
80103c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103c30:	8b 0d 00 61 18 80    	mov    0x80186100,%ecx
80103c36:	83 f9 07             	cmp    $0x7,%ecx
80103c39:	7f 19                	jg     80103c54 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c3b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103c41:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103c45:	83 c1 01             	add    $0x1,%ecx
80103c48:	89 0d 00 61 18 80    	mov    %ecx,0x80186100
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c4e:	88 9f 80 5b 18 80    	mov    %bl,-0x7fe7a480(%edi)
      p += sizeof(struct mpproc);
80103c54:	83 c0 14             	add    $0x14,%eax
      continue;
80103c57:	e9 54 ff ff ff       	jmp    80103bb0 <mpinit+0xf0>
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c60:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c65:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c6a:	e8 d1 fd ff ff       	call   80103a40 <mpsearch1>
80103c6f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c71:	85 c0                	test   %eax,%eax
80103c73:	0f 85 9b fe ff ff    	jne    80103b14 <mpinit+0x54>
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	68 a2 91 10 80       	push   $0x801091a2
80103c88:	e8 03 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103c8d:	83 ec 0c             	sub    $0xc,%esp
80103c90:	68 bc 91 10 80       	push   $0x801091bc
80103c95:	e8 f6 c6 ff ff       	call   80100390 <panic>
80103c9a:	66 90                	xchg   %ax,%ax
80103c9c:	66 90                	xchg   %ax,%ax
80103c9e:	66 90                	xchg   %ax,%ax

80103ca0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103ca0:	f3 0f 1e fb          	endbr32 
80103ca4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ca9:	ba 21 00 00 00       	mov    $0x21,%edx
80103cae:	ee                   	out    %al,(%dx)
80103caf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103cb4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103cb5:	c3                   	ret    
80103cb6:	66 90                	xchg   %ax,%ax
80103cb8:	66 90                	xchg   %ax,%ax
80103cba:	66 90                	xchg   %ax,%ax
80103cbc:	66 90                	xchg   %ax,%ax
80103cbe:	66 90                	xchg   %ax,%ax

80103cc0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103cc0:	f3 0f 1e fb          	endbr32 
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	57                   	push   %edi
80103cc8:	56                   	push   %esi
80103cc9:	53                   	push   %ebx
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cd0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103cd3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103cd9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103cdf:	e8 8c d3 ff ff       	call   80101070 <filealloc>
80103ce4:	89 03                	mov    %eax,(%ebx)
80103ce6:	85 c0                	test   %eax,%eax
80103ce8:	0f 84 ac 00 00 00    	je     80103d9a <pipealloc+0xda>
80103cee:	e8 7d d3 ff ff       	call   80101070 <filealloc>
80103cf3:	89 06                	mov    %eax,(%esi)
80103cf5:	85 c0                	test   %eax,%eax
80103cf7:	0f 84 8b 00 00 00    	je     80103d88 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103cfd:	e8 7e f0 ff ff       	call   80102d80 <kalloc>
80103d02:	89 c7                	mov    %eax,%edi
80103d04:	85 c0                	test   %eax,%eax
80103d06:	0f 84 b4 00 00 00    	je     80103dc0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103d0c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d13:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103d16:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103d19:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d20:	00 00 00 
  p->nwrite = 0;
80103d23:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d2a:	00 00 00 
  p->nread = 0;
80103d2d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d34:	00 00 00 
  initlock(&p->lock, "pipe");
80103d37:	68 db 91 10 80       	push   $0x801091db
80103d3c:	50                   	push   %eax
80103d3d:	e8 2e 11 00 00       	call   80104e70 <initlock>
  (*f0)->type = FD_PIPE;
80103d42:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103d44:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d47:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d4d:	8b 03                	mov    (%ebx),%eax
80103d4f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d53:	8b 03                	mov    (%ebx),%eax
80103d55:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d59:	8b 03                	mov    (%ebx),%eax
80103d5b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d5e:	8b 06                	mov    (%esi),%eax
80103d60:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d66:	8b 06                	mov    (%esi),%eax
80103d68:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d6c:	8b 06                	mov    (%esi),%eax
80103d6e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d72:	8b 06                	mov    (%esi),%eax
80103d74:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d7a:	31 c0                	xor    %eax,%eax
}
80103d7c:	5b                   	pop    %ebx
80103d7d:	5e                   	pop    %esi
80103d7e:	5f                   	pop    %edi
80103d7f:	5d                   	pop    %ebp
80103d80:	c3                   	ret    
80103d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d88:	8b 03                	mov    (%ebx),%eax
80103d8a:	85 c0                	test   %eax,%eax
80103d8c:	74 1e                	je     80103dac <pipealloc+0xec>
    fileclose(*f0);
80103d8e:	83 ec 0c             	sub    $0xc,%esp
80103d91:	50                   	push   %eax
80103d92:	e8 99 d3 ff ff       	call   80101130 <fileclose>
80103d97:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d9a:	8b 06                	mov    (%esi),%eax
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	74 0c                	je     80103dac <pipealloc+0xec>
    fileclose(*f1);
80103da0:	83 ec 0c             	sub    $0xc,%esp
80103da3:	50                   	push   %eax
80103da4:	e8 87 d3 ff ff       	call   80101130 <fileclose>
80103da9:	83 c4 10             	add    $0x10,%esp
}
80103dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103daf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103db4:	5b                   	pop    %ebx
80103db5:	5e                   	pop    %esi
80103db6:	5f                   	pop    %edi
80103db7:	5d                   	pop    %ebp
80103db8:	c3                   	ret    
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103dc0:	8b 03                	mov    (%ebx),%eax
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 c8                	jne    80103d8e <pipealloc+0xce>
80103dc6:	eb d2                	jmp    80103d9a <pipealloc+0xda>
80103dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop

80103dd0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	56                   	push   %esi
80103dd8:	53                   	push   %ebx
80103dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103ddf:	83 ec 0c             	sub    $0xc,%esp
80103de2:	53                   	push   %ebx
80103de3:	e8 08 12 00 00       	call   80104ff0 <acquire>
  if(writable){
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	85 f6                	test   %esi,%esi
80103ded:	74 41                	je     80103e30 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103df8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103dff:	00 00 00 
    wakeup(&p->nread);
80103e02:	50                   	push   %eax
80103e03:	e8 f8 0c 00 00       	call   80104b00 <wakeup>
80103e08:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e0b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103e11:	85 d2                	test   %edx,%edx
80103e13:	75 0a                	jne    80103e1f <pipeclose+0x4f>
80103e15:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103e1b:	85 c0                	test   %eax,%eax
80103e1d:	74 31                	je     80103e50 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103e1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e25:	5b                   	pop    %ebx
80103e26:	5e                   	pop    %esi
80103e27:	5d                   	pop    %ebp
    release(&p->lock);
80103e28:	e9 83 12 00 00       	jmp    801050b0 <release>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103e30:	83 ec 0c             	sub    $0xc,%esp
80103e33:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103e39:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e40:	00 00 00 
    wakeup(&p->nwrite);
80103e43:	50                   	push   %eax
80103e44:	e8 b7 0c 00 00       	call   80104b00 <wakeup>
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	eb bd                	jmp    80103e0b <pipeclose+0x3b>
80103e4e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	53                   	push   %ebx
80103e54:	e8 57 12 00 00       	call   801050b0 <release>
    kfree((char*)p);
80103e59:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e5c:	83 c4 10             	add    $0x10,%esp
}
80103e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e62:	5b                   	pop    %ebx
80103e63:	5e                   	pop    %esi
80103e64:	5d                   	pop    %ebp
    kfree((char*)p);
80103e65:	e9 16 ec ff ff       	jmp    80102a80 <kfree>
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	57                   	push   %edi
80103e78:	56                   	push   %esi
80103e79:	53                   	push   %ebx
80103e7a:	83 ec 28             	sub    $0x28,%esp
80103e7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e80:	53                   	push   %ebx
80103e81:	e8 6a 11 00 00       	call   80104ff0 <acquire>
  for(i = 0; i < n; i++){
80103e86:	8b 45 10             	mov    0x10(%ebp),%eax
80103e89:	83 c4 10             	add    $0x10,%esp
80103e8c:	85 c0                	test   %eax,%eax
80103e8e:	0f 8e bc 00 00 00    	jle    80103f50 <pipewrite+0xe0>
80103e94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e97:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e9d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103ea3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ea6:	03 45 10             	add    0x10(%ebp),%eax
80103ea9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103eac:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103eb2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103eb8:	89 ca                	mov    %ecx,%edx
80103eba:	05 00 02 00 00       	add    $0x200,%eax
80103ebf:	39 c1                	cmp    %eax,%ecx
80103ec1:	74 3b                	je     80103efe <pipewrite+0x8e>
80103ec3:	eb 63                	jmp    80103f28 <pipewrite+0xb8>
80103ec5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ec8:	e8 73 03 00 00       	call   80104240 <myproc>
80103ecd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ed0:	85 c9                	test   %ecx,%ecx
80103ed2:	75 34                	jne    80103f08 <pipewrite+0x98>
      wakeup(&p->nread);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	57                   	push   %edi
80103ed8:	e8 23 0c 00 00       	call   80104b00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103edd:	58                   	pop    %eax
80103ede:	5a                   	pop    %edx
80103edf:	53                   	push   %ebx
80103ee0:	56                   	push   %esi
80103ee1:	e8 0a 0a 00 00       	call   801048f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ee6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103eec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ef2:	83 c4 10             	add    $0x10,%esp
80103ef5:	05 00 02 00 00       	add    $0x200,%eax
80103efa:	39 c2                	cmp    %eax,%edx
80103efc:	75 2a                	jne    80103f28 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103efe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	75 c0                	jne    80103ec8 <pipewrite+0x58>
        release(&p->lock);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	53                   	push   %ebx
80103f0c:	e8 9f 11 00 00       	call   801050b0 <release>
        return -1;
80103f11:	83 c4 10             	add    $0x10,%esp
80103f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f1c:	5b                   	pop    %ebx
80103f1d:	5e                   	pop    %esi
80103f1e:	5f                   	pop    %edi
80103f1f:	5d                   	pop    %ebp
80103f20:	c3                   	ret    
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103f2b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103f2e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103f34:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103f3a:	0f b6 06             	movzbl (%esi),%eax
80103f3d:	83 c6 01             	add    $0x1,%esi
80103f40:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103f43:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103f47:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103f4a:	0f 85 5c ff ff ff    	jne    80103eac <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f50:	83 ec 0c             	sub    $0xc,%esp
80103f53:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f59:	50                   	push   %eax
80103f5a:	e8 a1 0b 00 00       	call   80104b00 <wakeup>
  release(&p->lock);
80103f5f:	89 1c 24             	mov    %ebx,(%esp)
80103f62:	e8 49 11 00 00       	call   801050b0 <release>
  return n;
80103f67:	8b 45 10             	mov    0x10(%ebp),%eax
80103f6a:	83 c4 10             	add    $0x10,%esp
80103f6d:	eb aa                	jmp    80103f19 <pipewrite+0xa9>
80103f6f:	90                   	nop

80103f70 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	57                   	push   %edi
80103f78:	56                   	push   %esi
80103f79:	53                   	push   %ebx
80103f7a:	83 ec 18             	sub    $0x18,%esp
80103f7d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f80:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f83:	56                   	push   %esi
80103f84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f8a:	e8 61 10 00 00       	call   80104ff0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f8f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f95:	83 c4 10             	add    $0x10,%esp
80103f98:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f9e:	74 33                	je     80103fd3 <piperead+0x63>
80103fa0:	eb 3b                	jmp    80103fdd <piperead+0x6d>
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103fa8:	e8 93 02 00 00       	call   80104240 <myproc>
80103fad:	8b 48 24             	mov    0x24(%eax),%ecx
80103fb0:	85 c9                	test   %ecx,%ecx
80103fb2:	0f 85 88 00 00 00    	jne    80104040 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fb8:	83 ec 08             	sub    $0x8,%esp
80103fbb:	56                   	push   %esi
80103fbc:	53                   	push   %ebx
80103fbd:	e8 2e 09 00 00       	call   801048f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fc2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103fd1:	75 0a                	jne    80103fdd <piperead+0x6d>
80103fd3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103fd9:	85 c0                	test   %eax,%eax
80103fdb:	75 cb                	jne    80103fa8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fdd:	8b 55 10             	mov    0x10(%ebp),%edx
80103fe0:	31 db                	xor    %ebx,%ebx
80103fe2:	85 d2                	test   %edx,%edx
80103fe4:	7f 28                	jg     8010400e <piperead+0x9e>
80103fe6:	eb 34                	jmp    8010401c <piperead+0xac>
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ff0:	8d 48 01             	lea    0x1(%eax),%ecx
80103ff3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103ff8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103ffe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104003:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104006:	83 c3 01             	add    $0x1,%ebx
80104009:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010400c:	74 0e                	je     8010401c <piperead+0xac>
    if(p->nread == p->nwrite)
8010400e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104014:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010401a:	75 d4                	jne    80103ff0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104025:	50                   	push   %eax
80104026:	e8 d5 0a 00 00       	call   80104b00 <wakeup>
  release(&p->lock);
8010402b:	89 34 24             	mov    %esi,(%esp)
8010402e:	e8 7d 10 00 00       	call   801050b0 <release>
  return i;
80104033:	83 c4 10             	add    $0x10,%esp
}
80104036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104039:	89 d8                	mov    %ebx,%eax
8010403b:	5b                   	pop    %ebx
8010403c:	5e                   	pop    %esi
8010403d:	5f                   	pop    %edi
8010403e:	5d                   	pop    %ebp
8010403f:	c3                   	ret    
      release(&p->lock);
80104040:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104043:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104048:	56                   	push   %esi
80104049:	e8 62 10 00 00       	call   801050b0 <release>
      return -1;
8010404e:	83 c4 10             	add    $0x10,%esp
}
80104051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104054:	89 d8                	mov    %ebx,%eax
80104056:	5b                   	pop    %ebx
80104057:	5e                   	pop    %esi
80104058:	5f                   	pop    %edi
80104059:	5d                   	pop    %ebp
8010405a:	c3                   	ret    
8010405b:	66 90                	xchg   %ax,%ax
8010405d:	66 90                	xchg   %ax,%ax
8010405f:	90                   	nop

80104060 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104064:	bb 54 61 18 80       	mov    $0x80186154,%ebx
{
80104069:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010406c:	68 20 61 18 80       	push   $0x80186120
80104071:	e8 7a 0f 00 00       	call   80104ff0 <acquire>
80104076:	83 c4 10             	add    $0x10,%esp
80104079:	eb 13                	jmp    8010408e <allocproc+0x2e>
8010407b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010407f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104080:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104086:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
8010408c:	74 7a                	je     80104108 <allocproc+0xa8>
    if(p->state == UNUSED)
8010408e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104091:	85 c0                	test   %eax,%eax
80104093:	75 eb                	jne    80104080 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104095:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
8010409a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010409d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801040a4:	89 43 10             	mov    %eax,0x10(%ebx)
801040a7:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801040aa:	68 20 61 18 80       	push   $0x80186120
  p->pid = nextpid++;
801040af:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
801040b5:	e8 f6 0f 00 00       	call   801050b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040ba:	e8 c1 ec ff ff       	call   80102d80 <kalloc>
801040bf:	83 c4 10             	add    $0x10,%esp
801040c2:	89 43 08             	mov    %eax,0x8(%ebx)
801040c5:	85 c0                	test   %eax,%eax
801040c7:	74 58                	je     80104121 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040c9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801040cf:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801040d2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801040d7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801040da:	c7 40 14 7f 63 10 80 	movl   $0x8010637f,0x14(%eax)
  p->context = (struct context*)sp;
801040e1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801040e4:	6a 14                	push   $0x14
801040e6:	6a 00                	push   $0x0
801040e8:	50                   	push   %eax
801040e9:	e8 12 10 00 00       	call   80105100 <memset>
  p->context->eip = (uint)forkret;
801040ee:	8b 43 1c             	mov    0x1c(%ebx),%eax

    }
  }
#endif
  
  return p;
801040f1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801040f4:	c7 40 10 40 41 10 80 	movl   $0x80104140,0x10(%eax)
}
801040fb:	89 d8                	mov    %ebx,%eax
801040fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104100:	c9                   	leave  
80104101:	c3                   	ret    
80104102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104108:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010410b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010410d:	68 20 61 18 80       	push   $0x80186120
80104112:	e8 99 0f 00 00       	call   801050b0 <release>
}
80104117:	89 d8                	mov    %ebx,%eax
  return 0;
80104119:	83 c4 10             	add    $0x10,%esp
}
8010411c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010411f:	c9                   	leave  
80104120:	c3                   	ret    
    p->state = UNUSED;
80104121:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104128:	31 db                	xor    %ebx,%ebx
}
8010412a:	89 d8                	mov    %ebx,%eax
8010412c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010412f:	c9                   	leave  
80104130:	c3                   	ret    
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010414a:	68 20 61 18 80       	push   $0x80186120
8010414f:	e8 5c 0f 00 00       	call   801050b0 <release>

  if (first) {
80104154:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104159:	83 c4 10             	add    $0x10,%esp
8010415c:	85 c0                	test   %eax,%eax
8010415e:	75 08                	jne    80104168 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104160:	c9                   	leave  
80104161:	c3                   	ret    
80104162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104168:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
8010416f:	00 00 00 
    iinit(ROOTDEV);
80104172:	83 ec 0c             	sub    $0xc,%esp
80104175:	6a 01                	push   $0x1
80104177:	e8 34 d6 ff ff       	call   801017b0 <iinit>
    initlog(ROOTDEV);
8010417c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104183:	e8 c8 f3 ff ff       	call   80103550 <initlog>
}
80104188:	83 c4 10             	add    $0x10,%esp
8010418b:	c9                   	leave  
8010418c:	c3                   	ret    
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <pinit>:
{
80104190:	f3 0f 1e fb          	endbr32 
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010419a:	68 e0 91 10 80       	push   $0x801091e0
8010419f:	68 20 61 18 80       	push   $0x80186120
801041a4:	e8 c7 0c 00 00       	call   80104e70 <initlock>
}
801041a9:	83 c4 10             	add    $0x10,%esp
801041ac:	c9                   	leave  
801041ad:	c3                   	ret    
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <mycpu>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b9:	9c                   	pushf  
801041ba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041bb:	f6 c4 02             	test   $0x2,%ah
801041be:	75 4a                	jne    8010420a <mycpu+0x5a>
  apicid = lapicid();
801041c0:	e8 9b ef ff ff       	call   80103160 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801041c5:	8b 35 00 61 18 80    	mov    0x80186100,%esi
  apicid = lapicid();
801041cb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801041cd:	85 f6                	test   %esi,%esi
801041cf:	7e 2c                	jle    801041fd <mycpu+0x4d>
801041d1:	31 d2                	xor    %edx,%edx
801041d3:	eb 0a                	jmp    801041df <mycpu+0x2f>
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
801041d8:	83 c2 01             	add    $0x1,%edx
801041db:	39 f2                	cmp    %esi,%edx
801041dd:	74 1e                	je     801041fd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801041df:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801041e5:	0f b6 81 80 5b 18 80 	movzbl -0x7fe7a480(%ecx),%eax
801041ec:	39 d8                	cmp    %ebx,%eax
801041ee:	75 e8                	jne    801041d8 <mycpu+0x28>
}
801041f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801041f3:	8d 81 80 5b 18 80    	lea    -0x7fe7a480(%ecx),%eax
}
801041f9:	5b                   	pop    %ebx
801041fa:	5e                   	pop    %esi
801041fb:	5d                   	pop    %ebp
801041fc:	c3                   	ret    
  panic("unknown apicid\n");
801041fd:	83 ec 0c             	sub    $0xc,%esp
80104200:	68 e7 91 10 80       	push   $0x801091e7
80104205:	e8 86 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	68 d8 92 10 80       	push   $0x801092d8
80104212:	e8 79 c1 ff ff       	call   80100390 <panic>
80104217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010421e:	66 90                	xchg   %ax,%ax

80104220 <cpuid>:
cpuid() {
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010422a:	e8 81 ff ff ff       	call   801041b0 <mycpu>
}
8010422f:	c9                   	leave  
  return mycpu()-cpus;
80104230:	2d 80 5b 18 80       	sub    $0x80185b80,%eax
80104235:	c1 f8 04             	sar    $0x4,%eax
80104238:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010423e:	c3                   	ret    
8010423f:	90                   	nop

80104240 <myproc>:
myproc(void) {
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	53                   	push   %ebx
80104248:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010424b:	e8 a0 0c 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104250:	e8 5b ff ff ff       	call   801041b0 <mycpu>
  p = c->proc;
80104255:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425b:	e8 e0 0c 00 00       	call   80104f40 <popcli>
}
80104260:	83 c4 04             	add    $0x4,%esp
80104263:	89 d8                	mov    %ebx,%eax
80104265:	5b                   	pop    %ebx
80104266:	5d                   	pop    %ebp
80104267:	c3                   	ret    
80104268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <userinit>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	53                   	push   %ebx
80104278:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010427b:	e8 e0 fd ff ff       	call   80104060 <allocproc>
80104280:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104282:	a3 dc c5 10 80       	mov    %eax,0x8010c5dc
  if((p->pgdir = setupkvm()) == 0)
80104287:	e8 c4 3a 00 00       	call   80107d50 <setupkvm>
8010428c:	89 43 04             	mov    %eax,0x4(%ebx)
8010428f:	85 c0                	test   %eax,%eax
80104291:	0f 84 bd 00 00 00    	je     80104354 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104297:	83 ec 04             	sub    $0x4,%esp
8010429a:	68 2c 00 00 00       	push   $0x2c
8010429f:	68 60 c4 10 80       	push   $0x8010c460
801042a4:	50                   	push   %eax
801042a5:	e8 f6 34 00 00       	call   801077a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801042aa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801042ad:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801042b3:	6a 4c                	push   $0x4c
801042b5:	6a 00                	push   $0x0
801042b7:	ff 73 18             	pushl  0x18(%ebx)
801042ba:	e8 41 0e 00 00       	call   80105100 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042bf:	8b 43 18             	mov    0x18(%ebx),%eax
801042c2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042c7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ca:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042cf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042d3:	8b 43 18             	mov    0x18(%ebx),%eax
801042d6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042da:	8b 43 18             	mov    0x18(%ebx),%eax
801042dd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042e1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042e5:	8b 43 18             	mov    0x18(%ebx),%eax
801042e8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042ec:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042f0:	8b 43 18             	mov    0x18(%ebx),%eax
801042f3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042fa:	8b 43 18             	mov    0x18(%ebx),%eax
801042fd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104304:	8b 43 18             	mov    0x18(%ebx),%eax
80104307:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010430e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104311:	6a 10                	push   $0x10
80104313:	68 10 92 10 80       	push   $0x80109210
80104318:	50                   	push   %eax
80104319:	e8 a2 0f 00 00       	call   801052c0 <safestrcpy>
  p->cwd = namei("/");
8010431e:	c7 04 24 19 92 10 80 	movl   $0x80109219,(%esp)
80104325:	e8 76 df ff ff       	call   801022a0 <namei>
8010432a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010432d:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104334:	e8 b7 0c 00 00       	call   80104ff0 <acquire>
  p->state = RUNNABLE;
80104339:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104340:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104347:	e8 64 0d 00 00       	call   801050b0 <release>
}
8010434c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010434f:	83 c4 10             	add    $0x10,%esp
80104352:	c9                   	leave  
80104353:	c3                   	ret    
    panic("userinit: out of memory?");
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	68 f7 91 10 80       	push   $0x801091f7
8010435c:	e8 2f c0 ff ff       	call   80100390 <panic>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436f:	90                   	nop

80104370 <growproc>:
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	57                   	push   %edi
80104378:	56                   	push   %esi
80104379:	53                   	push   %ebx
8010437a:	83 ec 0c             	sub    $0xc,%esp
8010437d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104380:	e8 6b 0b 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104385:	e8 26 fe ff ff       	call   801041b0 <mycpu>
  p = c->proc;
8010438a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104390:	e8 ab 0b 00 00       	call   80104f40 <popcli>
  sz = curproc->sz;
80104395:	8b 1e                	mov    (%esi),%ebx
  if(n > 0){
80104397:	85 ff                	test   %edi,%edi
80104399:	7f 1d                	jg     801043b8 <growproc+0x48>
  } else if(n < 0){
8010439b:	75 43                	jne    801043e0 <growproc+0x70>
  switchuvm(curproc);
8010439d:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801043a0:	89 1e                	mov    %ebx,(%esi)
  switchuvm(curproc);
801043a2:	56                   	push   %esi
801043a3:	e8 e8 32 00 00       	call   80107690 <switchuvm>
  return 0;
801043a8:	83 c4 10             	add    $0x10,%esp
801043ab:	31 c0                	xor    %eax,%eax
}
801043ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b0:	5b                   	pop    %ebx
801043b1:	5e                   	pop    %esi
801043b2:	5f                   	pop    %edi
801043b3:	5d                   	pop    %ebp
801043b4:	c3                   	ret    
801043b5:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043b8:	83 ec 04             	sub    $0x4,%esp
801043bb:	01 df                	add    %ebx,%edi
801043bd:	57                   	push   %edi
801043be:	53                   	push   %ebx
801043bf:	ff 76 04             	pushl  0x4(%esi)
801043c2:	e8 29 35 00 00       	call   801078f0 <allocuvm>
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	89 c3                	mov    %eax,%ebx
801043cc:	85 c0                	test   %eax,%eax
801043ce:	75 cd                	jne    8010439d <growproc+0x2d>
      return -1;
801043d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d5:	eb d6                	jmp    801043ad <growproc+0x3d>
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
    cprintf("growproc: n < 0\n");
801043e0:	83 ec 0c             	sub    $0xc,%esp
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043e3:	01 df                	add    %ebx,%edi
    cprintf("growproc: n < 0\n");
801043e5:	68 1b 92 10 80       	push   $0x8010921b
801043ea:	e8 c1 c2 ff ff       	call   801006b0 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043ef:	83 c4 0c             	add    $0xc,%esp
801043f2:	57                   	push   %edi
801043f3:	53                   	push   %ebx
801043f4:	ff 76 04             	pushl  0x4(%esi)
801043f7:	e8 74 38 00 00       	call   80107c70 <deallocuvm>
801043fc:	83 c4 10             	add    $0x10,%esp
801043ff:	89 c3                	mov    %eax,%ebx
80104401:	85 c0                	test   %eax,%eax
80104403:	75 98                	jne    8010439d <growproc+0x2d>
80104405:	eb c9                	jmp    801043d0 <growproc+0x60>
80104407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440e:	66 90                	xchg   %ax,%ax

80104410 <fork>:
{ 
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	57                   	push   %edi
80104418:	56                   	push   %esi
80104419:	53                   	push   %ebx
8010441a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010441d:	e8 ce 0a 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104422:	e8 89 fd ff ff       	call   801041b0 <mycpu>
  p = c->proc;
80104427:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010442d:	e8 0e 0b 00 00       	call   80104f40 <popcli>
  if((np = allocproc()) == 0){
80104432:	e8 29 fc ff ff       	call   80104060 <allocproc>
80104437:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010443a:	85 c0                	test   %eax,%eax
8010443c:	0f 84 e3 00 00 00    	je     80104525 <fork+0x115>
  if(curproc->pid <= 2) // init, shell
80104442:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104446:	89 c7                	mov    %eax,%edi
80104448:	8b 13                	mov    (%ebx),%edx
8010444a:	8b 43 04             	mov    0x4(%ebx),%eax
8010444d:	0f 8e bd 00 00 00    	jle    80104510 <fork+0x100>
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
80104453:	83 ec 08             	sub    $0x8,%esp
80104456:	52                   	push   %edx
80104457:	50                   	push   %eax
80104458:	e8 d3 39 00 00       	call   80107e30 <cowuvm>
8010445d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	89 41 04             	mov    %eax,0x4(%ecx)
  if(np->pgdir == 0){
80104466:	85 c0                	test   %eax,%eax
80104468:	0f 84 be 00 00 00    	je     8010452c <fork+0x11c>
  np->sz = curproc->sz;
8010446e:	8b 03                	mov    (%ebx),%eax
80104470:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104473:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104475:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104478:	89 c8                	mov    %ecx,%eax
8010447a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010447d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104482:	8b 73 18             	mov    0x18(%ebx),%esi
80104485:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104487:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104489:	8b 40 18             	mov    0x18(%eax),%eax
8010448c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104497:	90                   	nop
    if(curproc->ofile[i])
80104498:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010449c:	85 c0                	test   %eax,%eax
8010449e:	74 13                	je     801044b3 <fork+0xa3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	50                   	push   %eax
801044a4:	e8 37 cc ff ff       	call   801010e0 <filedup>
801044a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801044b3:	83 c6 01             	add    $0x1,%esi
801044b6:	83 fe 10             	cmp    $0x10,%esi
801044b9:	75 dd                	jne    80104498 <fork+0x88>
  np->cwd = idup(curproc->cwd);
801044bb:	83 ec 0c             	sub    $0xc,%esp
801044be:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044c1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801044c4:	e8 d7 d4 ff ff       	call   801019a0 <idup>
801044c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044cc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801044cf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044d2:	8d 47 6c             	lea    0x6c(%edi),%eax
801044d5:	6a 10                	push   $0x10
801044d7:	53                   	push   %ebx
801044d8:	50                   	push   %eax
801044d9:	e8 e2 0d 00 00       	call   801052c0 <safestrcpy>
  pid = np->pid;
801044de:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801044e1:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
801044e8:	e8 03 0b 00 00       	call   80104ff0 <acquire>
  np->state = RUNNABLE;
801044ed:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801044f4:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
801044fb:	e8 b0 0b 00 00       	call   801050b0 <release>
  return pid;
80104500:	83 c4 10             	add    $0x10,%esp
}
80104503:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104506:	89 d8                	mov    %ebx,%eax
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104510:	83 ec 08             	sub    $0x8,%esp
80104513:	52                   	push   %edx
80104514:	50                   	push   %eax
80104515:	e8 c6 3e 00 00       	call   801083e0 <copyuvm>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	89 47 04             	mov    %eax,0x4(%edi)
80104520:	e9 41 ff ff ff       	jmp    80104466 <fork+0x56>
    return -1;
80104525:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010452a:	eb d7                	jmp    80104503 <fork+0xf3>
    kfree(np->kstack);
8010452c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010452f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80104532:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80104537:	ff 77 08             	pushl  0x8(%edi)
8010453a:	e8 41 e5 ff ff       	call   80102a80 <kfree>
    np->kstack = 0;
8010453f:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80104546:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104549:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104550:	eb b1                	jmp    80104503 <fork+0xf3>
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <copyAQ>:
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	57                   	push   %edi
80104568:	56                   	push   %esi
80104569:	53                   	push   %ebx
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104570:	e8 7b 09 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104575:	e8 36 fc ff ff       	call   801041b0 <mycpu>
  p = c->proc;
8010457a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104580:	e8 bb 09 00 00       	call   80104f40 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
80104585:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
8010458b:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
80104592:	00 00 00 
  np->queue_tail = 0;
80104595:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
8010459c:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
8010459f:	85 db                	test   %ebx,%ebx
801045a1:	74 53                	je     801045f6 <copyAQ+0x96>
    np_curr = (struct queue_node*)kalloc();
801045a3:	e8 d8 e7 ff ff       	call   80102d80 <kalloc>
    np_curr->page_index = old_curr->page_index;
801045a8:	8b 53 08             	mov    0x8(%ebx),%edx
801045ab:	89 50 08             	mov    %edx,0x8(%eax)
    np->queue_head =np_curr;
801045ae:	89 86 1c 04 00 00    	mov    %eax,0x41c(%esi)
    np_curr->prev = 0;
801045b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    old_curr = old_curr->next;
801045bb:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801045bd:	85 db                	test   %ebx,%ebx
801045bf:	74 1f                	je     801045e0 <copyAQ+0x80>
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np_curr = (struct queue_node*)kalloc();
801045c8:	89 c7                	mov    %eax,%edi
801045ca:	e8 b1 e7 ff ff       	call   80102d80 <kalloc>
    np_curr->page_index = old_curr->page_index;
801045cf:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
801045d2:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
801045d5:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
801045d8:	89 07                	mov    %eax,(%edi)
    old_curr = old_curr->next;
801045da:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801045dc:	85 db                	test   %ebx,%ebx
801045de:	75 e8                	jne    801045c8 <copyAQ+0x68>
  if(np->queue_head != 0) // if the queue wasn't empty
801045e0:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
801045e6:	85 d2                	test   %edx,%edx
801045e8:	74 0c                	je     801045f6 <copyAQ+0x96>
    np_curr->next = 0;
801045ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
801045f0:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
801045f6:	83 c4 0c             	add    $0xc,%esp
801045f9:	5b                   	pop    %ebx
801045fa:	5e                   	pop    %esi
801045fb:	5f                   	pop    %edi
801045fc:	5d                   	pop    %ebp
801045fd:	c3                   	ret    
801045fe:	66 90                	xchg   %ax,%ax

80104600 <scheduler>:
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	57                   	push   %edi
80104608:	56                   	push   %esi
80104609:	53                   	push   %ebx
8010460a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010460d:	e8 9e fb ff ff       	call   801041b0 <mycpu>
  c->proc = 0;
80104612:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104619:	00 00 00 
  struct cpu *c = mycpu();
8010461c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010461e:	8d 78 04             	lea    0x4(%eax),%edi
80104621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104628:	fb                   	sti    
    acquire(&ptable.lock);
80104629:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010462c:	bb 54 61 18 80       	mov    $0x80186154,%ebx
    acquire(&ptable.lock);
80104631:	68 20 61 18 80       	push   $0x80186120
80104636:	e8 b5 09 00 00       	call   80104ff0 <acquire>
8010463b:	83 c4 10             	add    $0x10,%esp
8010463e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104640:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104644:	75 33                	jne    80104679 <scheduler+0x79>
      switchuvm(p);
80104646:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104649:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010464f:	53                   	push   %ebx
80104650:	e8 3b 30 00 00       	call   80107690 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104655:	58                   	pop    %eax
80104656:	5a                   	pop    %edx
80104657:	ff 73 1c             	pushl  0x1c(%ebx)
8010465a:	57                   	push   %edi
      p->state = RUNNING;
8010465b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104662:	e8 bc 0c 00 00       	call   80105323 <swtch>
      switchkvm();
80104667:	e8 04 30 00 00       	call   80107670 <switchkvm>
      c->proc = 0;
8010466c:	83 c4 10             	add    $0x10,%esp
8010466f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104676:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104679:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010467f:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
80104685:	75 b9                	jne    80104640 <scheduler+0x40>
    release(&ptable.lock);
80104687:	83 ec 0c             	sub    $0xc,%esp
8010468a:	68 20 61 18 80       	push   $0x80186120
8010468f:	e8 1c 0a 00 00       	call   801050b0 <release>
    sti();
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	eb 8f                	jmp    80104628 <scheduler+0x28>
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <sched>:
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	56                   	push   %esi
801046a8:	53                   	push   %ebx
  pushcli();
801046a9:	e8 42 08 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801046ae:	e8 fd fa ff ff       	call   801041b0 <mycpu>
  p = c->proc;
801046b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046b9:	e8 82 08 00 00       	call   80104f40 <popcli>
  if(!holding(&ptable.lock))
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	68 20 61 18 80       	push   $0x80186120
801046c6:	e8 d5 08 00 00       	call   80104fa0 <holding>
801046cb:	83 c4 10             	add    $0x10,%esp
801046ce:	85 c0                	test   %eax,%eax
801046d0:	74 4f                	je     80104721 <sched+0x81>
  if(mycpu()->ncli != 1)
801046d2:	e8 d9 fa ff ff       	call   801041b0 <mycpu>
801046d7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801046de:	75 68                	jne    80104748 <sched+0xa8>
  if(p->state == RUNNING)
801046e0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801046e4:	74 55                	je     8010473b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046e6:	9c                   	pushf  
801046e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046e8:	f6 c4 02             	test   $0x2,%ah
801046eb:	75 41                	jne    8010472e <sched+0x8e>
  intena = mycpu()->intena;
801046ed:	e8 be fa ff ff       	call   801041b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801046f2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801046f5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801046fb:	e8 b0 fa ff ff       	call   801041b0 <mycpu>
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	ff 70 04             	pushl  0x4(%eax)
80104706:	53                   	push   %ebx
80104707:	e8 17 0c 00 00       	call   80105323 <swtch>
  mycpu()->intena = intena;
8010470c:	e8 9f fa ff ff       	call   801041b0 <mycpu>
}
80104711:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104714:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010471a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010471d:	5b                   	pop    %ebx
8010471e:	5e                   	pop    %esi
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
    panic("sched ptable.lock");
80104721:	83 ec 0c             	sub    $0xc,%esp
80104724:	68 2c 92 10 80       	push   $0x8010922c
80104729:	e8 62 bc ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010472e:	83 ec 0c             	sub    $0xc,%esp
80104731:	68 58 92 10 80       	push   $0x80109258
80104736:	e8 55 bc ff ff       	call   80100390 <panic>
    panic("sched running");
8010473b:	83 ec 0c             	sub    $0xc,%esp
8010473e:	68 4a 92 10 80       	push   $0x8010924a
80104743:	e8 48 bc ff ff       	call   80100390 <panic>
    panic("sched locks");
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	68 3e 92 10 80       	push   $0x8010923e
80104750:	e8 3b bc ff ff       	call   80100390 <panic>
80104755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <exit>:
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	57                   	push   %edi
80104768:	56                   	push   %esi
80104769:	53                   	push   %ebx
8010476a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010476d:	e8 7e 07 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104772:	e8 39 fa ff ff       	call   801041b0 <mycpu>
  p = c->proc;
80104777:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010477d:	e8 be 07 00 00       	call   80104f40 <popcli>
  if(curproc == initproc)
80104782:	8d 5e 28             	lea    0x28(%esi),%ebx
80104785:	8d 7e 68             	lea    0x68(%esi),%edi
80104788:	39 35 dc c5 10 80    	cmp    %esi,0x8010c5dc
8010478e:	0f 84 fd 00 00 00    	je     80104891 <exit+0x131>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104798:	8b 03                	mov    (%ebx),%eax
8010479a:	85 c0                	test   %eax,%eax
8010479c:	74 12                	je     801047b0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010479e:	83 ec 0c             	sub    $0xc,%esp
801047a1:	50                   	push   %eax
801047a2:	e8 89 c9 ff ff       	call   80101130 <fileclose>
      curproc->ofile[fd] = 0;
801047a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801047ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801047b0:	83 c3 04             	add    $0x4,%ebx
801047b3:	39 df                	cmp    %ebx,%edi
801047b5:	75 e1                	jne    80104798 <exit+0x38>
  begin_op();
801047b7:	e8 34 ee ff ff       	call   801035f0 <begin_op>
  iput(curproc->cwd);
801047bc:	83 ec 0c             	sub    $0xc,%esp
801047bf:	ff 76 68             	pushl  0x68(%esi)
801047c2:	e8 39 d3 ff ff       	call   80101b00 <iput>
  end_op();
801047c7:	e8 94 ee ff ff       	call   80103660 <end_op>
  curproc->cwd = 0;
801047cc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801047d3:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
801047da:	e8 11 08 00 00       	call   80104ff0 <acquire>
  wakeup1(curproc->parent);
801047df:	8b 56 14             	mov    0x14(%esi),%edx
801047e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047e5:	b8 54 61 18 80       	mov    $0x80186154,%eax
801047ea:	eb 10                	jmp    801047fc <exit+0x9c>
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f0:	05 30 04 00 00       	add    $0x430,%eax
801047f5:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
801047fa:	74 1e                	je     8010481a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801047fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104800:	75 ee                	jne    801047f0 <exit+0x90>
80104802:	3b 50 20             	cmp    0x20(%eax),%edx
80104805:	75 e9                	jne    801047f0 <exit+0x90>
      p->state = RUNNABLE;
80104807:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010480e:	05 30 04 00 00       	add    $0x430,%eax
80104813:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104818:	75 e2                	jne    801047fc <exit+0x9c>
      p->parent = initproc;
8010481a:	8b 0d dc c5 10 80    	mov    0x8010c5dc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104820:	ba 54 61 18 80       	mov    $0x80186154,%edx
80104825:	eb 17                	jmp    8010483e <exit+0xde>
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
80104830:	81 c2 30 04 00 00    	add    $0x430,%edx
80104836:	81 fa 54 6d 19 80    	cmp    $0x80196d54,%edx
8010483c:	74 3a                	je     80104878 <exit+0x118>
    if(p->parent == curproc){
8010483e:	39 72 14             	cmp    %esi,0x14(%edx)
80104841:	75 ed                	jne    80104830 <exit+0xd0>
      if(p->state == ZOMBIE)
80104843:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104847:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010484a:	75 e4                	jne    80104830 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010484c:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104851:	eb 11                	jmp    80104864 <exit+0x104>
80104853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104857:	90                   	nop
80104858:	05 30 04 00 00       	add    $0x430,%eax
8010485d:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104862:	74 cc                	je     80104830 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104864:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104868:	75 ee                	jne    80104858 <exit+0xf8>
8010486a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010486d:	75 e9                	jne    80104858 <exit+0xf8>
      p->state = RUNNABLE;
8010486f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104876:	eb e0                	jmp    80104858 <exit+0xf8>
  curproc->state = ZOMBIE;
80104878:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010487f:	e8 1c fe ff ff       	call   801046a0 <sched>
  panic("zombie exit");
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	68 79 92 10 80       	push   $0x80109279
8010488c:	e8 ff ba ff ff       	call   80100390 <panic>
    panic("init exiting");
80104891:	83 ec 0c             	sub    $0xc,%esp
80104894:	68 6c 92 10 80       	push   $0x8010926c
80104899:	e8 f2 ba ff ff       	call   80100390 <panic>
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <yield>:
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	53                   	push   %ebx
801048a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801048ab:	68 20 61 18 80       	push   $0x80186120
801048b0:	e8 3b 07 00 00       	call   80104ff0 <acquire>
  pushcli();
801048b5:	e8 36 06 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801048ba:	e8 f1 f8 ff ff       	call   801041b0 <mycpu>
  p = c->proc;
801048bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048c5:	e8 76 06 00 00       	call   80104f40 <popcli>
  myproc()->state = RUNNABLE;
801048ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801048d1:	e8 ca fd ff ff       	call   801046a0 <sched>
  release(&ptable.lock);
801048d6:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
801048dd:	e8 ce 07 00 00       	call   801050b0 <release>
}
801048e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e5:	83 c4 10             	add    $0x10,%esp
801048e8:	c9                   	leave  
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <sleep>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	57                   	push   %edi
801048f8:	56                   	push   %esi
801048f9:	53                   	push   %ebx
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104900:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104903:	e8 e8 05 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
80104908:	e8 a3 f8 ff ff       	call   801041b0 <mycpu>
  p = c->proc;
8010490d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104913:	e8 28 06 00 00       	call   80104f40 <popcli>
  if(p == 0)
80104918:	85 db                	test   %ebx,%ebx
8010491a:	0f 84 83 00 00 00    	je     801049a3 <sleep+0xb3>
  if(lk == 0)
80104920:	85 f6                	test   %esi,%esi
80104922:	74 72                	je     80104996 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104924:	81 fe 20 61 18 80    	cmp    $0x80186120,%esi
8010492a:	74 4c                	je     80104978 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	68 20 61 18 80       	push   $0x80186120
80104934:	e8 b7 06 00 00       	call   80104ff0 <acquire>
    release(lk);
80104939:	89 34 24             	mov    %esi,(%esp)
8010493c:	e8 6f 07 00 00       	call   801050b0 <release>
  p->chan = chan;
80104941:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104944:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010494b:	e8 50 fd ff ff       	call   801046a0 <sched>
  p->chan = 0;
80104950:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104957:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
8010495e:	e8 4d 07 00 00       	call   801050b0 <release>
    acquire(lk);
80104963:	89 75 08             	mov    %esi,0x8(%ebp)
80104966:	83 c4 10             	add    $0x10,%esp
}
80104969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010496c:	5b                   	pop    %ebx
8010496d:	5e                   	pop    %esi
8010496e:	5f                   	pop    %edi
8010496f:	5d                   	pop    %ebp
    acquire(lk);
80104970:	e9 7b 06 00 00       	jmp    80104ff0 <acquire>
80104975:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104978:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010497b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104982:	e8 19 fd ff ff       	call   801046a0 <sched>
  p->chan = 0;
80104987:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010498e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104991:	5b                   	pop    %ebx
80104992:	5e                   	pop    %esi
80104993:	5f                   	pop    %edi
80104994:	5d                   	pop    %ebp
80104995:	c3                   	ret    
    panic("sleep without lk");
80104996:	83 ec 0c             	sub    $0xc,%esp
80104999:	68 8b 92 10 80       	push   $0x8010928b
8010499e:	e8 ed b9 ff ff       	call   80100390 <panic>
    panic("sleep");
801049a3:	83 ec 0c             	sub    $0xc,%esp
801049a6:	68 85 92 10 80       	push   $0x80109285
801049ab:	e8 e0 b9 ff ff       	call   80100390 <panic>

801049b0 <wait>:
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	53                   	push   %ebx
  pushcli();
801049b9:	e8 32 05 00 00       	call   80104ef0 <pushcli>
  c = mycpu();
801049be:	e8 ed f7 ff ff       	call   801041b0 <mycpu>
  p = c->proc;
801049c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049c9:	e8 72 05 00 00       	call   80104f40 <popcli>
  acquire(&ptable.lock);
801049ce:	83 ec 0c             	sub    $0xc,%esp
801049d1:	68 20 61 18 80       	push   $0x80186120
801049d6:	e8 15 06 00 00       	call   80104ff0 <acquire>
801049db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801049de:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e0:	bb 54 61 18 80       	mov    $0x80186154,%ebx
801049e5:	eb 17                	jmp    801049fe <wait+0x4e>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax
801049f0:	81 c3 30 04 00 00    	add    $0x430,%ebx
801049f6:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
801049fc:	74 1e                	je     80104a1c <wait+0x6c>
      if(p->parent != curproc)
801049fe:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a01:	75 ed                	jne    801049f0 <wait+0x40>
      if(p->state == ZOMBIE){
80104a03:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a07:	74 3f                	je     80104a48 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a09:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104a0f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a14:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
80104a1a:	75 e2                	jne    801049fe <wait+0x4e>
    if(!havekids || curproc->killed){
80104a1c:	85 c0                	test   %eax,%eax
80104a1e:	0f 84 c0 00 00 00    	je     80104ae4 <wait+0x134>
80104a24:	8b 46 24             	mov    0x24(%esi),%eax
80104a27:	85 c0                	test   %eax,%eax
80104a29:	0f 85 b5 00 00 00    	jne    80104ae4 <wait+0x134>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a2f:	83 ec 08             	sub    $0x8,%esp
80104a32:	68 20 61 18 80       	push   $0x80186120
80104a37:	56                   	push   %esi
80104a38:	e8 b3 fe ff ff       	call   801048f0 <sleep>
    havekids = 0;
80104a3d:	83 c4 10             	add    $0x10,%esp
80104a40:	eb 9c                	jmp    801049de <wait+0x2e>
80104a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104a4e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a51:	e8 2a e0 ff ff       	call   80102a80 <kfree>
        freevm(p->pgdir);
80104a56:	5a                   	pop    %edx
80104a57:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a61:	e8 3a 32 00 00       	call   80107ca0 <freevm>
        release(&ptable.lock);
80104a66:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
        p->pid = 0;
80104a6d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a74:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a7b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a7f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104a86:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104a8d:	00 00 00 
        p->free_head = 0;
80104a90:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104a97:	00 00 00 
        p->free_tail = 0;
80104a9a:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104aa1:	00 00 00 
        p->queue_head = 0;
80104aa4:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104aab:	00 00 00 
        p->queue_tail = 0;
80104aae:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104ab5:	00 00 00 
        p->numswappages = 0;
80104ab8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104abf:	00 00 00 
        p-> nummemorypages = 0;
80104ac2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104ac9:	00 00 00 
        p->state = UNUSED;
80104acc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104ad3:	e8 d8 05 00 00       	call   801050b0 <release>
        return pid;
80104ad8:	83 c4 10             	add    $0x10,%esp
}
80104adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ade:	89 f0                	mov    %esi,%eax
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5d                   	pop    %ebp
80104ae3:	c3                   	ret    
      release(&ptable.lock);
80104ae4:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ae7:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104aec:	68 20 61 18 80       	push   $0x80186120
80104af1:	e8 ba 05 00 00       	call   801050b0 <release>
      return -1;
80104af6:	83 c4 10             	add    $0x10,%esp
80104af9:	eb e0                	jmp    80104adb <wait+0x12b>
80104afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop

80104b00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	53                   	push   %ebx
80104b08:	83 ec 10             	sub    $0x10,%esp
80104b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104b0e:	68 20 61 18 80       	push   $0x80186120
80104b13:	e8 d8 04 00 00       	call   80104ff0 <acquire>
80104b18:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b1b:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104b20:	eb 12                	jmp    80104b34 <wakeup+0x34>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	05 30 04 00 00       	add    $0x430,%eax
80104b2d:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104b32:	74 1e                	je     80104b52 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104b34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b38:	75 ee                	jne    80104b28 <wakeup+0x28>
80104b3a:	3b 58 20             	cmp    0x20(%eax),%ebx
80104b3d:	75 e9                	jne    80104b28 <wakeup+0x28>
      p->state = RUNNABLE;
80104b3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b46:	05 30 04 00 00       	add    $0x430,%eax
80104b4b:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104b50:	75 e2                	jne    80104b34 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104b52:	c7 45 08 20 61 18 80 	movl   $0x80186120,0x8(%ebp)
}
80104b59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b5c:	c9                   	leave  
  release(&ptable.lock);
80104b5d:	e9 4e 05 00 00       	jmp    801050b0 <release>
80104b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	53                   	push   %ebx
80104b78:	83 ec 10             	sub    $0x10,%esp
80104b7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b7e:	68 20 61 18 80       	push   $0x80186120
80104b83:	e8 68 04 00 00       	call   80104ff0 <acquire>
80104b88:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b8b:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104b90:	eb 12                	jmp    80104ba4 <kill+0x34>
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b98:	05 30 04 00 00       	add    $0x430,%eax
80104b9d:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104ba2:	74 34                	je     80104bd8 <kill+0x68>
    if(p->pid == pid){
80104ba4:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ba7:	75 ef                	jne    80104b98 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ba9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104bad:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104bb4:	75 07                	jne    80104bbd <kill+0x4d>
        p->state = RUNNABLE;
80104bb6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	68 20 61 18 80       	push   $0x80186120
80104bc5:	e8 e6 04 00 00       	call   801050b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	31 c0                	xor    %eax,%eax
}
80104bd2:	c9                   	leave  
80104bd3:	c3                   	ret    
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	68 20 61 18 80       	push   $0x80186120
80104be0:	e8 cb 04 00 00       	call   801050b0 <release>
}
80104be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104be8:	83 c4 10             	add    $0x10,%esp
80104beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bf0:	c9                   	leave  
80104bf1:	c3                   	ret    
80104bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c00 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	57                   	push   %edi
80104c08:	56                   	push   %esi
80104c09:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104c0c:	53                   	push   %ebx
80104c0d:	bb c0 61 18 80       	mov    $0x801861c0,%ebx
80104c12:	83 ec 3c             	sub    $0x3c,%esp
80104c15:	eb 44                	jmp    80104c5b <procdump+0x5b>
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n<%d / %d>", getNumberOfFreePages(), initialNumOfFreePages);
80104c20:	8b 3d d8 c5 10 80    	mov    0x8010c5d8,%edi
}

int
getNumberOfFreePages(void)
{
  return getNumOfFreePages();
80104c26:	e8 15 e3 ff ff       	call   80102f40 <getNumOfFreePages>
    cprintf("\n<%d / %d>", getNumberOfFreePages(), initialNumOfFreePages);
80104c2b:	83 ec 04             	sub    $0x4,%esp
80104c2e:	57                   	push   %edi
80104c2f:	50                   	push   %eax
80104c30:	68 a0 92 10 80       	push   $0x801092a0
80104c35:	e8 76 ba ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
80104c3a:	c7 04 24 f6 96 10 80 	movl   $0x801096f6,(%esp)
80104c41:	e8 6a ba ff ff       	call   801006b0 <cprintf>
80104c46:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c49:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104c4f:	81 fb c0 6d 19 80    	cmp    $0x80196dc0,%ebx
80104c55:	0f 84 a5 00 00 00    	je     80104d00 <procdump+0x100>
    if(p->state == UNUSED)
80104c5b:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104c5e:	85 c0                	test   %eax,%eax
80104c60:	74 e7                	je     80104c49 <procdump+0x49>
      state = "???";
80104c62:	ba 9c 92 10 80       	mov    $0x8010929c,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c67:	83 f8 05             	cmp    $0x5,%eax
80104c6a:	77 11                	ja     80104c7d <procdump+0x7d>
80104c6c:	8b 14 85 68 93 10 80 	mov    -0x7fef6c98(,%eax,4),%edx
      state = "???";
80104c73:	b8 9c 92 10 80       	mov    $0x8010929c,%eax
80104c78:	85 d2                	test   %edx,%edx
80104c7a:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104c7d:	ff b3 c0 03 00 00    	pushl  0x3c0(%ebx)
80104c83:	ff b3 bc 03 00 00    	pushl  0x3bc(%ebx)
80104c89:	ff b3 a0 03 00 00    	pushl  0x3a0(%ebx)
80104c8f:	ff b3 9c 03 00 00    	pushl  0x39c(%ebx)
80104c95:	53                   	push   %ebx
80104c96:	52                   	push   %edx
80104c97:	ff 73 a4             	pushl  -0x5c(%ebx)
80104c9a:	68 00 93 10 80       	push   $0x80109300
80104c9f:	e8 0c ba ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104ca4:	83 c4 20             	add    $0x20,%esp
80104ca7:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104cab:	0f 85 6f ff ff ff    	jne    80104c20 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104cb1:	83 ec 08             	sub    $0x8,%esp
80104cb4:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cb7:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104cba:	50                   	push   %eax
80104cbb:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104cbe:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc1:	83 c0 08             	add    $0x8,%eax
80104cc4:	50                   	push   %eax
80104cc5:	e8 c6 01 00 00       	call   80104e90 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cca:	83 c4 10             	add    $0x10,%esp
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
80104cd0:	8b 17                	mov    (%edi),%edx
80104cd2:	85 d2                	test   %edx,%edx
80104cd4:	0f 84 46 ff ff ff    	je     80104c20 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104cda:	83 ec 08             	sub    $0x8,%esp
80104cdd:	83 c7 04             	add    $0x4,%edi
80104ce0:	52                   	push   %edx
80104ce1:	68 01 8c 10 80       	push   $0x80108c01
80104ce6:	e8 c5 b9 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ceb:	83 c4 10             	add    $0x10,%esp
80104cee:	39 fe                	cmp    %edi,%esi
80104cf0:	75 de                	jne    80104cd0 <procdump+0xd0>
80104cf2:	e9 29 ff ff ff       	jmp    80104c20 <procdump+0x20>
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
}
80104d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d03:	5b                   	pop    %ebx
80104d04:	5e                   	pop    %esi
80104d05:	5f                   	pop    %edi
80104d06:	5d                   	pop    %ebp
80104d07:	c3                   	ret    
80104d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <getNumberOfFreePages>:
{
80104d10:	f3 0f 1e fb          	endbr32 
  return getNumOfFreePages();
80104d14:	e9 27 e2 ff ff       	jmp    80102f40 <getNumOfFreePages>
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d20 <getNumRefs>:
}

int
getNumRefs(int arrindx)
{ 
80104d20:	f3 0f 1e fb          	endbr32 
  return getNumRefsWarpper(arrindx);
80104d24:	e9 37 3e 00 00       	jmp    80108b60 <getNumRefsWarpper>
80104d29:	66 90                	xchg   %ax,%ax
80104d2b:	66 90                	xchg   %ax,%ax
80104d2d:	66 90                	xchg   %ax,%ax
80104d2f:	90                   	nop

80104d30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	53                   	push   %ebx
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d3e:	68 80 93 10 80       	push   $0x80109380
80104d43:	8d 43 04             	lea    0x4(%ebx),%eax
80104d46:	50                   	push   %eax
80104d47:	e8 24 01 00 00       	call   80104e70 <initlock>
  lk->name = name;
80104d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d55:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d5f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	56                   	push   %esi
80104d78:	53                   	push   %ebx
80104d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d7f:	83 ec 0c             	sub    $0xc,%esp
80104d82:	56                   	push   %esi
80104d83:	e8 68 02 00 00       	call   80104ff0 <acquire>
  while (lk->locked) {
80104d88:	8b 13                	mov    (%ebx),%edx
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 d2                	test   %edx,%edx
80104d8f:	74 1a                	je     80104dab <acquiresleep+0x3b>
80104d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104d98:	83 ec 08             	sub    $0x8,%esp
80104d9b:	56                   	push   %esi
80104d9c:	53                   	push   %ebx
80104d9d:	e8 4e fb ff ff       	call   801048f0 <sleep>
  while (lk->locked) {
80104da2:	8b 03                	mov    (%ebx),%eax
80104da4:	83 c4 10             	add    $0x10,%esp
80104da7:	85 c0                	test   %eax,%eax
80104da9:	75 ed                	jne    80104d98 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104dab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104db1:	e8 8a f4 ff ff       	call   80104240 <myproc>
80104db6:	8b 40 10             	mov    0x10(%eax),%eax
80104db9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104dbc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dc5:	e9 e6 02 00 00       	jmp    801050b0 <release>
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	56                   	push   %esi
80104dd8:	53                   	push   %ebx
80104dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ddc:	8d 73 04             	lea    0x4(%ebx),%esi
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	56                   	push   %esi
80104de3:	e8 08 02 00 00       	call   80104ff0 <acquire>
  lk->locked = 0;
80104de8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104dee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104df5:	89 1c 24             	mov    %ebx,(%esp)
80104df8:	e8 03 fd ff ff       	call   80104b00 <wakeup>
  release(&lk->lk);
80104dfd:	89 75 08             	mov    %esi,0x8(%ebp)
80104e00:	83 c4 10             	add    $0x10,%esp
}
80104e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e06:	5b                   	pop    %ebx
80104e07:	5e                   	pop    %esi
80104e08:	5d                   	pop    %ebp
  release(&lk->lk);
80104e09:	e9 a2 02 00 00       	jmp    801050b0 <release>
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e10:	f3 0f 1e fb          	endbr32 
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	57                   	push   %edi
80104e18:	31 ff                	xor    %edi,%edi
80104e1a:	56                   	push   %esi
80104e1b:	53                   	push   %ebx
80104e1c:	83 ec 18             	sub    $0x18,%esp
80104e1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e22:	8d 73 04             	lea    0x4(%ebx),%esi
80104e25:	56                   	push   %esi
80104e26:	e8 c5 01 00 00       	call   80104ff0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e2b:	8b 03                	mov    (%ebx),%eax
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	85 c0                	test   %eax,%eax
80104e32:	75 1c                	jne    80104e50 <holdingsleep+0x40>
  release(&lk->lk);
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	56                   	push   %esi
80104e38:	e8 73 02 00 00       	call   801050b0 <release>
  return r;
}
80104e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e40:	89 f8                	mov    %edi,%eax
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5f                   	pop    %edi
80104e45:	5d                   	pop    %ebp
80104e46:	c3                   	ret    
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104e50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e53:	e8 e8 f3 ff ff       	call   80104240 <myproc>
80104e58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e5b:	0f 94 c0             	sete   %al
80104e5e:	0f b6 c0             	movzbl %al,%eax
80104e61:	89 c7                	mov    %eax,%edi
80104e63:	eb cf                	jmp    80104e34 <holdingsleep+0x24>
80104e65:	66 90                	xchg   %ax,%ax
80104e67:	66 90                	xchg   %ax,%ax
80104e69:	66 90                	xchg   %ax,%ax
80104e6b:	66 90                	xchg   %ax,%ax
80104e6d:	66 90                	xchg   %ax,%ax
80104e6f:	90                   	nop

80104e70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e83:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e8d:	5d                   	pop    %ebp
80104e8e:	c3                   	ret    
80104e8f:	90                   	nop

80104e90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e95:	31 d2                	xor    %edx,%edx
{
80104e97:	89 e5                	mov    %esp,%ebp
80104e99:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e9a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ea0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ea8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104eae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104eb4:	77 1a                	ja     80104ed0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104eb6:	8b 58 04             	mov    0x4(%eax),%ebx
80104eb9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ebc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ebf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ec1:	83 fa 0a             	cmp    $0xa,%edx
80104ec4:	75 e2                	jne    80104ea8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ec6:	5b                   	pop    %ebx
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104ed0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ed3:	8d 51 28             	lea    0x28(%ecx),%edx
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ee6:	83 c0 04             	add    $0x4,%eax
80104ee9:	39 d0                	cmp    %edx,%eax
80104eeb:	75 f3                	jne    80104ee0 <getcallerpcs+0x50>
}
80104eed:	5b                   	pop    %ebx
80104eee:	5d                   	pop    %ebp
80104eef:	c3                   	ret    

80104ef0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	53                   	push   %ebx
80104ef8:	83 ec 04             	sub    $0x4,%esp
80104efb:	9c                   	pushf  
80104efc:	5b                   	pop    %ebx
  asm volatile("cli");
80104efd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104efe:	e8 ad f2 ff ff       	call   801041b0 <mycpu>
80104f03:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	74 13                	je     80104f20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104f0d:	e8 9e f2 ff ff       	call   801041b0 <mycpu>
80104f12:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f19:	83 c4 04             	add    $0x4,%esp
80104f1c:	5b                   	pop    %ebx
80104f1d:	5d                   	pop    %ebp
80104f1e:	c3                   	ret    
80104f1f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104f20:	e8 8b f2 ff ff       	call   801041b0 <mycpu>
80104f25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104f31:	eb da                	jmp    80104f0d <pushcli+0x1d>
80104f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <popcli>:

void
popcli(void)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f4a:	9c                   	pushf  
80104f4b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f4c:	f6 c4 02             	test   $0x2,%ah
80104f4f:	75 31                	jne    80104f82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f51:	e8 5a f2 ff ff       	call   801041b0 <mycpu>
80104f56:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f5d:	78 30                	js     80104f8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f5f:	e8 4c f2 ff ff       	call   801041b0 <mycpu>
80104f64:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f6a:	85 d2                	test   %edx,%edx
80104f6c:	74 02                	je     80104f70 <popcli+0x30>
    sti();
}
80104f6e:	c9                   	leave  
80104f6f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f70:	e8 3b f2 ff ff       	call   801041b0 <mycpu>
80104f75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	74 ef                	je     80104f6e <popcli+0x2e>
  asm volatile("sti");
80104f7f:	fb                   	sti    
}
80104f80:	c9                   	leave  
80104f81:	c3                   	ret    
    panic("popcli - interruptible");
80104f82:	83 ec 0c             	sub    $0xc,%esp
80104f85:	68 8b 93 10 80       	push   $0x8010938b
80104f8a:	e8 01 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f8f:	83 ec 0c             	sub    $0xc,%esp
80104f92:	68 a2 93 10 80       	push   $0x801093a2
80104f97:	e8 f4 b3 ff ff       	call   80100390 <panic>
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fa0 <holding>:
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	56                   	push   %esi
80104fa8:	53                   	push   %ebx
80104fa9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fac:	31 db                	xor    %ebx,%ebx
  pushcli();
80104fae:	e8 3d ff ff ff       	call   80104ef0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fb3:	8b 06                	mov    (%esi),%eax
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	75 0f                	jne    80104fc8 <holding+0x28>
  popcli();
80104fb9:	e8 82 ff ff ff       	call   80104f40 <popcli>
}
80104fbe:	89 d8                	mov    %ebx,%eax
80104fc0:	5b                   	pop    %ebx
80104fc1:	5e                   	pop    %esi
80104fc2:	5d                   	pop    %ebp
80104fc3:	c3                   	ret    
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104fc8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104fcb:	e8 e0 f1 ff ff       	call   801041b0 <mycpu>
80104fd0:	39 c3                	cmp    %eax,%ebx
80104fd2:	0f 94 c3             	sete   %bl
  popcli();
80104fd5:	e8 66 ff ff ff       	call   80104f40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104fda:	0f b6 db             	movzbl %bl,%ebx
}
80104fdd:	89 d8                	mov    %ebx,%eax
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ff0 <acquire>:
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	56                   	push   %esi
80104ff8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ff9:	e8 f2 fe ff ff       	call   80104ef0 <pushcli>
  if(holding(lk))
80104ffe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105001:	83 ec 0c             	sub    $0xc,%esp
80105004:	53                   	push   %ebx
80105005:	e8 96 ff ff ff       	call   80104fa0 <holding>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	85 c0                	test   %eax,%eax
8010500f:	0f 85 7f 00 00 00    	jne    80105094 <acquire+0xa4>
80105015:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105017:	ba 01 00 00 00       	mov    $0x1,%edx
8010501c:	eb 05                	jmp    80105023 <acquire+0x33>
8010501e:	66 90                	xchg   %ax,%ax
80105020:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105023:	89 d0                	mov    %edx,%eax
80105025:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105028:	85 c0                	test   %eax,%eax
8010502a:	75 f4                	jne    80105020 <acquire+0x30>
  __sync_synchronize();
8010502c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105031:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105034:	e8 77 f1 ff ff       	call   801041b0 <mycpu>
80105039:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010503c:	89 e8                	mov    %ebp,%eax
8010503e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105040:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105046:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010504c:	77 22                	ja     80105070 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010504e:	8b 50 04             	mov    0x4(%eax),%edx
80105051:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105055:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105058:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010505a:	83 fe 0a             	cmp    $0xa,%esi
8010505d:	75 e1                	jne    80105040 <acquire+0x50>
}
8010505f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105062:	5b                   	pop    %ebx
80105063:	5e                   	pop    %esi
80105064:	5d                   	pop    %ebp
80105065:	c3                   	ret    
80105066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105070:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105074:	83 c3 34             	add    $0x34,%ebx
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105086:	83 c0 04             	add    $0x4,%eax
80105089:	39 d8                	cmp    %ebx,%eax
8010508b:	75 f3                	jne    80105080 <acquire+0x90>
}
8010508d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105090:	5b                   	pop    %ebx
80105091:	5e                   	pop    %esi
80105092:	5d                   	pop    %ebp
80105093:	c3                   	ret    
    panic("acquire");
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	68 a9 93 10 80       	push   $0x801093a9
8010509c:	e8 ef b2 ff ff       	call   80100390 <panic>
801050a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050af:	90                   	nop

801050b0 <release>:
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	53                   	push   %ebx
801050b8:	83 ec 10             	sub    $0x10,%esp
801050bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801050be:	53                   	push   %ebx
801050bf:	e8 dc fe ff ff       	call   80104fa0 <holding>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	74 22                	je     801050ed <release+0x3d>
  lk->pcs[0] = 0;
801050cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801050d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801050d9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801050de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801050e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e7:	c9                   	leave  
  popcli();
801050e8:	e9 53 fe ff ff       	jmp    80104f40 <popcli>
    panic("release");
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	68 b1 93 10 80       	push   $0x801093b1
801050f5:	e8 96 b2 ff ff       	call   80100390 <panic>
801050fa:	66 90                	xchg   %ax,%ax
801050fc:	66 90                	xchg   %ax,%ax
801050fe:	66 90                	xchg   %ax,%ax

80105100 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	57                   	push   %edi
80105108:	8b 55 08             	mov    0x8(%ebp),%edx
8010510b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010510e:	53                   	push   %ebx
8010510f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105112:	89 d7                	mov    %edx,%edi
80105114:	09 cf                	or     %ecx,%edi
80105116:	83 e7 03             	and    $0x3,%edi
80105119:	75 25                	jne    80105140 <memset+0x40>
    c &= 0xFF;
8010511b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010511e:	c1 e0 18             	shl    $0x18,%eax
80105121:	89 fb                	mov    %edi,%ebx
80105123:	c1 e9 02             	shr    $0x2,%ecx
80105126:	c1 e3 10             	shl    $0x10,%ebx
80105129:	09 d8                	or     %ebx,%eax
8010512b:	09 f8                	or     %edi,%eax
8010512d:	c1 e7 08             	shl    $0x8,%edi
80105130:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105132:	89 d7                	mov    %edx,%edi
80105134:	fc                   	cld    
80105135:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105137:	5b                   	pop    %ebx
80105138:	89 d0                	mov    %edx,%eax
8010513a:	5f                   	pop    %edi
8010513b:	5d                   	pop    %ebp
8010513c:	c3                   	ret    
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105140:	89 d7                	mov    %edx,%edi
80105142:	fc                   	cld    
80105143:	f3 aa                	rep stos %al,%es:(%edi)
80105145:	5b                   	pop    %ebx
80105146:	89 d0                	mov    %edx,%eax
80105148:	5f                   	pop    %edi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop

80105150 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	56                   	push   %esi
80105158:	8b 75 10             	mov    0x10(%ebp),%esi
8010515b:	8b 55 08             	mov    0x8(%ebp),%edx
8010515e:	53                   	push   %ebx
8010515f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105162:	85 f6                	test   %esi,%esi
80105164:	74 2a                	je     80105190 <memcmp+0x40>
80105166:	01 c6                	add    %eax,%esi
80105168:	eb 10                	jmp    8010517a <memcmp+0x2a>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105170:	83 c0 01             	add    $0x1,%eax
80105173:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105176:	39 f0                	cmp    %esi,%eax
80105178:	74 16                	je     80105190 <memcmp+0x40>
    if(*s1 != *s2)
8010517a:	0f b6 0a             	movzbl (%edx),%ecx
8010517d:	0f b6 18             	movzbl (%eax),%ebx
80105180:	38 d9                	cmp    %bl,%cl
80105182:	74 ec                	je     80105170 <memcmp+0x20>
      return *s1 - *s2;
80105184:	0f b6 c1             	movzbl %cl,%eax
80105187:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret    
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
80105190:	5b                   	pop    %ebx
  return 0;
80105191:	31 c0                	xor    %eax,%eax
}
80105193:	5e                   	pop    %esi
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi

801051a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	8b 55 08             	mov    0x8(%ebp),%edx
801051ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051ae:	56                   	push   %esi
801051af:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051b2:	39 d6                	cmp    %edx,%esi
801051b4:	73 2a                	jae    801051e0 <memmove+0x40>
801051b6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801051b9:	39 fa                	cmp    %edi,%edx
801051bb:	73 23                	jae    801051e0 <memmove+0x40>
801051bd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801051c0:	85 c9                	test   %ecx,%ecx
801051c2:	74 13                	je     801051d7 <memmove+0x37>
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801051c8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801051cc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801051cf:	83 e8 01             	sub    $0x1,%eax
801051d2:	83 f8 ff             	cmp    $0xffffffff,%eax
801051d5:	75 f1                	jne    801051c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801051d7:	5e                   	pop    %esi
801051d8:	89 d0                	mov    %edx,%eax
801051da:	5f                   	pop    %edi
801051db:	5d                   	pop    %ebp
801051dc:	c3                   	ret    
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801051e0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801051e3:	89 d7                	mov    %edx,%edi
801051e5:	85 c9                	test   %ecx,%ecx
801051e7:	74 ee                	je     801051d7 <memmove+0x37>
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801051f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801051f1:	39 f0                	cmp    %esi,%eax
801051f3:	75 fb                	jne    801051f0 <memmove+0x50>
}
801051f5:	5e                   	pop    %esi
801051f6:	89 d0                	mov    %edx,%eax
801051f8:	5f                   	pop    %edi
801051f9:	5d                   	pop    %ebp
801051fa:	c3                   	ret    
801051fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ff:	90                   	nop

80105200 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105200:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105204:	eb 9a                	jmp    801051a0 <memmove>
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi

80105210 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	8b 75 10             	mov    0x10(%ebp),%esi
8010521b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010521e:	53                   	push   %ebx
8010521f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105222:	85 f6                	test   %esi,%esi
80105224:	74 32                	je     80105258 <strncmp+0x48>
80105226:	01 c6                	add    %eax,%esi
80105228:	eb 14                	jmp    8010523e <strncmp+0x2e>
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105230:	38 da                	cmp    %bl,%dl
80105232:	75 14                	jne    80105248 <strncmp+0x38>
    n--, p++, q++;
80105234:	83 c0 01             	add    $0x1,%eax
80105237:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010523a:	39 f0                	cmp    %esi,%eax
8010523c:	74 1a                	je     80105258 <strncmp+0x48>
8010523e:	0f b6 11             	movzbl (%ecx),%edx
80105241:	0f b6 18             	movzbl (%eax),%ebx
80105244:	84 d2                	test   %dl,%dl
80105246:	75 e8                	jne    80105230 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105248:	0f b6 c2             	movzbl %dl,%eax
8010524b:	29 d8                	sub    %ebx,%eax
}
8010524d:	5b                   	pop    %ebx
8010524e:	5e                   	pop    %esi
8010524f:	5d                   	pop    %ebp
80105250:	c3                   	ret    
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105258:	5b                   	pop    %ebx
    return 0;
80105259:	31 c0                	xor    %eax,%eax
}
8010525b:	5e                   	pop    %esi
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax

80105260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	57                   	push   %edi
80105268:	56                   	push   %esi
80105269:	8b 75 08             	mov    0x8(%ebp),%esi
8010526c:	53                   	push   %ebx
8010526d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105270:	89 f2                	mov    %esi,%edx
80105272:	eb 1b                	jmp    8010528f <strncpy+0x2f>
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105278:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010527c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010527f:	83 c2 01             	add    $0x1,%edx
80105282:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105286:	89 f9                	mov    %edi,%ecx
80105288:	88 4a ff             	mov    %cl,-0x1(%edx)
8010528b:	84 c9                	test   %cl,%cl
8010528d:	74 09                	je     80105298 <strncpy+0x38>
8010528f:	89 c3                	mov    %eax,%ebx
80105291:	83 e8 01             	sub    $0x1,%eax
80105294:	85 db                	test   %ebx,%ebx
80105296:	7f e0                	jg     80105278 <strncpy+0x18>
    ;
  while(n-- > 0)
80105298:	89 d1                	mov    %edx,%ecx
8010529a:	85 c0                	test   %eax,%eax
8010529c:	7e 15                	jle    801052b3 <strncpy+0x53>
8010529e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801052a0:	83 c1 01             	add    $0x1,%ecx
801052a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801052a7:	89 c8                	mov    %ecx,%eax
801052a9:	f7 d0                	not    %eax
801052ab:	01 d0                	add    %edx,%eax
801052ad:	01 d8                	add    %ebx,%eax
801052af:	85 c0                	test   %eax,%eax
801052b1:	7f ed                	jg     801052a0 <strncpy+0x40>
  return os;
}
801052b3:	5b                   	pop    %ebx
801052b4:	89 f0                	mov    %esi,%eax
801052b6:	5e                   	pop    %esi
801052b7:	5f                   	pop    %edi
801052b8:	5d                   	pop    %ebp
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	56                   	push   %esi
801052c8:	8b 55 10             	mov    0x10(%ebp),%edx
801052cb:	8b 75 08             	mov    0x8(%ebp),%esi
801052ce:	53                   	push   %ebx
801052cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801052d2:	85 d2                	test   %edx,%edx
801052d4:	7e 21                	jle    801052f7 <safestrcpy+0x37>
801052d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801052da:	89 f2                	mov    %esi,%edx
801052dc:	eb 12                	jmp    801052f0 <safestrcpy+0x30>
801052de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801052e0:	0f b6 08             	movzbl (%eax),%ecx
801052e3:	83 c0 01             	add    $0x1,%eax
801052e6:	83 c2 01             	add    $0x1,%edx
801052e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801052ec:	84 c9                	test   %cl,%cl
801052ee:	74 04                	je     801052f4 <safestrcpy+0x34>
801052f0:	39 d8                	cmp    %ebx,%eax
801052f2:	75 ec                	jne    801052e0 <safestrcpy+0x20>
    ;
  *s = 0;
801052f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801052f7:	89 f0                	mov    %esi,%eax
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5d                   	pop    %ebp
801052fc:	c3                   	ret    
801052fd:	8d 76 00             	lea    0x0(%esi),%esi

80105300 <strlen>:

int
strlen(const char *s)
{
80105300:	f3 0f 1e fb          	endbr32 
80105304:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105305:	31 c0                	xor    %eax,%eax
{
80105307:	89 e5                	mov    %esp,%ebp
80105309:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010530c:	80 3a 00             	cmpb   $0x0,(%edx)
8010530f:	74 10                	je     80105321 <strlen+0x21>
80105311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105318:	83 c0 01             	add    $0x1,%eax
8010531b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010531f:	75 f7                	jne    80105318 <strlen+0x18>
    ;
  return n;
}
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    

80105323 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105323:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105327:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010532b:	55                   	push   %ebp
  pushl %ebx
8010532c:	53                   	push   %ebx
  pushl %esi
8010532d:	56                   	push   %esi
  pushl %edi
8010532e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010532f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105331:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105333:	5f                   	pop    %edi
  popl %esi
80105334:	5e                   	pop    %esi
  popl %ebx
80105335:	5b                   	pop    %ebx
  popl %ebp
80105336:	5d                   	pop    %ebp
  ret
80105337:	c3                   	ret    
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105340:	f3 0f 1e fb          	endbr32 
80105344:	55                   	push   %ebp
80105345:	89 e5                	mov    %esp,%ebp
80105347:	53                   	push   %ebx
80105348:	83 ec 04             	sub    $0x4,%esp
8010534b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010534e:	e8 ed ee ff ff       	call   80104240 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105353:	8b 00                	mov    (%eax),%eax
80105355:	39 d8                	cmp    %ebx,%eax
80105357:	76 17                	jbe    80105370 <fetchint+0x30>
80105359:	8d 53 04             	lea    0x4(%ebx),%edx
8010535c:	39 d0                	cmp    %edx,%eax
8010535e:	72 10                	jb     80105370 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105360:	8b 45 0c             	mov    0xc(%ebp),%eax
80105363:	8b 13                	mov    (%ebx),%edx
80105365:	89 10                	mov    %edx,(%eax)
  return 0;
80105367:	31 c0                	xor    %eax,%eax
}
80105369:	83 c4 04             	add    $0x4,%esp
8010536c:	5b                   	pop    %ebx
8010536d:	5d                   	pop    %ebp
8010536e:	c3                   	ret    
8010536f:	90                   	nop
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105375:	eb f2                	jmp    80105369 <fetchint+0x29>
80105377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537e:	66 90                	xchg   %ax,%ax

80105380 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	53                   	push   %ebx
80105388:	83 ec 04             	sub    $0x4,%esp
8010538b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010538e:	e8 ad ee ff ff       	call   80104240 <myproc>

  if(addr >= curproc->sz)
80105393:	39 18                	cmp    %ebx,(%eax)
80105395:	76 31                	jbe    801053c8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105397:	8b 55 0c             	mov    0xc(%ebp),%edx
8010539a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010539c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010539e:	39 d3                	cmp    %edx,%ebx
801053a0:	73 26                	jae    801053c8 <fetchstr+0x48>
801053a2:	89 d8                	mov    %ebx,%eax
801053a4:	eb 11                	jmp    801053b7 <fetchstr+0x37>
801053a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
801053b0:	83 c0 01             	add    $0x1,%eax
801053b3:	39 c2                	cmp    %eax,%edx
801053b5:	76 11                	jbe    801053c8 <fetchstr+0x48>
    if(*s == 0)
801053b7:	80 38 00             	cmpb   $0x0,(%eax)
801053ba:	75 f4                	jne    801053b0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801053bc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801053bf:	29 d8                	sub    %ebx,%eax
}
801053c1:	5b                   	pop    %ebx
801053c2:	5d                   	pop    %ebp
801053c3:	c3                   	ret    
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c8:	83 c4 04             	add    $0x4,%esp
    return -1;
801053cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d0:	5b                   	pop    %ebx
801053d1:	5d                   	pop    %ebp
801053d2:	c3                   	ret    
801053d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	56                   	push   %esi
801053e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053e9:	e8 52 ee ff ff       	call   80104240 <myproc>
801053ee:	8b 55 08             	mov    0x8(%ebp),%edx
801053f1:	8b 40 18             	mov    0x18(%eax),%eax
801053f4:	8b 40 44             	mov    0x44(%eax),%eax
801053f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801053fa:	e8 41 ee ff ff       	call   80104240 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053ff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105402:	8b 00                	mov    (%eax),%eax
80105404:	39 c6                	cmp    %eax,%esi
80105406:	73 18                	jae    80105420 <argint+0x40>
80105408:	8d 53 08             	lea    0x8(%ebx),%edx
8010540b:	39 d0                	cmp    %edx,%eax
8010540d:	72 11                	jb     80105420 <argint+0x40>
  *ip = *(int*)(addr);
8010540f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105412:	8b 53 04             	mov    0x4(%ebx),%edx
80105415:	89 10                	mov    %edx,(%eax)
  return 0;
80105417:	31 c0                	xor    %eax,%eax
}
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105425:	eb f2                	jmp    80105419 <argint+0x39>
80105427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542e:	66 90                	xchg   %ax,%ax

80105430 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	56                   	push   %esi
80105438:	53                   	push   %ebx
80105439:	83 ec 10             	sub    $0x10,%esp
8010543c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010543f:	e8 fc ed ff ff       	call   80104240 <myproc>
 
  if(argint(n, &i) < 0)
80105444:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105447:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	50                   	push   %eax
8010544d:	ff 75 08             	pushl  0x8(%ebp)
80105450:	e8 8b ff ff ff       	call   801053e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105455:	83 c4 10             	add    $0x10,%esp
80105458:	85 c0                	test   %eax,%eax
8010545a:	78 24                	js     80105480 <argptr+0x50>
8010545c:	85 db                	test   %ebx,%ebx
8010545e:	78 20                	js     80105480 <argptr+0x50>
80105460:	8b 16                	mov    (%esi),%edx
80105462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105465:	39 c2                	cmp    %eax,%edx
80105467:	76 17                	jbe    80105480 <argptr+0x50>
80105469:	01 c3                	add    %eax,%ebx
8010546b:	39 da                	cmp    %ebx,%edx
8010546d:	72 11                	jb     80105480 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010546f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105472:	89 02                	mov    %eax,(%edx)
  return 0;
80105474:	31 c0                	xor    %eax,%eax
}
80105476:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105479:	5b                   	pop    %ebx
8010547a:	5e                   	pop    %esi
8010547b:	5d                   	pop    %ebp
8010547c:	c3                   	ret    
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ef                	jmp    80105476 <argptr+0x46>
80105487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548e:	66 90                	xchg   %ax,%ax

80105490 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010549a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549d:	50                   	push   %eax
8010549e:	ff 75 08             	pushl  0x8(%ebp)
801054a1:	e8 3a ff ff ff       	call   801053e0 <argint>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	78 13                	js     801054c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801054ad:	83 ec 08             	sub    $0x8,%esp
801054b0:	ff 75 0c             	pushl  0xc(%ebp)
801054b3:	ff 75 f4             	pushl  -0xc(%ebp)
801054b6:	e8 c5 fe ff ff       	call   80105380 <fetchstr>
801054bb:	83 c4 10             	add    $0x10,%esp
}
801054be:	c9                   	leave  
801054bf:	c3                   	ret    
801054c0:	c9                   	leave  
    return -1;
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c6:	c3                   	ret    
801054c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <syscall>:
[SYS_getNumRefs]           sys_getNumRefs
};

void
syscall(void)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
801054d5:	89 e5                	mov    %esp,%ebp
801054d7:	53                   	push   %ebx
801054d8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801054db:	e8 60 ed ff ff       	call   80104240 <myproc>
801054e0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801054e2:	8b 40 18             	mov    0x18(%eax),%eax
801054e5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801054eb:	83 fa 17             	cmp    $0x17,%edx
801054ee:	77 20                	ja     80105510 <syscall+0x40>
801054f0:	8b 14 85 e0 93 10 80 	mov    -0x7fef6c20(,%eax,4),%edx
801054f7:	85 d2                	test   %edx,%edx
801054f9:	74 15                	je     80105510 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801054fb:	ff d2                	call   *%edx
801054fd:	89 c2                	mov    %eax,%edx
801054ff:	8b 43 18             	mov    0x18(%ebx),%eax
80105502:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105508:	c9                   	leave  
80105509:	c3                   	ret    
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105510:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105511:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105514:	50                   	push   %eax
80105515:	ff 73 10             	pushl  0x10(%ebx)
80105518:	68 b9 93 10 80       	push   $0x801093b9
8010551d:	e8 8e b1 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105522:	8b 43 18             	mov    0x18(%ebx),%eax
80105525:	83 c4 10             	add    $0x10,%esp
80105528:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010552f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105532:	c9                   	leave  
80105533:	c3                   	ret    
80105534:	66 90                	xchg   %ax,%ax
80105536:	66 90                	xchg   %ax,%ax
80105538:	66 90                	xchg   %ax,%ax
8010553a:	66 90                	xchg   %ax,%ax
8010553c:	66 90                	xchg   %ax,%ax
8010553e:	66 90                	xchg   %ax,%ax

80105540 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	89 d6                	mov    %edx,%esi
80105546:	53                   	push   %ebx
80105547:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105549:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010554c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010554f:	50                   	push   %eax
80105550:	6a 00                	push   $0x0
80105552:	e8 89 fe ff ff       	call   801053e0 <argint>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	78 2a                	js     80105588 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010555e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105562:	77 24                	ja     80105588 <argfd.constprop.0+0x48>
80105564:	e8 d7 ec ff ff       	call   80104240 <myproc>
80105569:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010556c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105570:	85 c0                	test   %eax,%eax
80105572:	74 14                	je     80105588 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105574:	85 db                	test   %ebx,%ebx
80105576:	74 02                	je     8010557a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105578:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010557a:	89 06                	mov    %eax,(%esi)
  return 0;
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105581:	5b                   	pop    %ebx
80105582:	5e                   	pop    %esi
80105583:	5d                   	pop    %ebp
80105584:	c3                   	ret    
80105585:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	eb ef                	jmp    8010557e <argfd.constprop.0+0x3e>
8010558f:	90                   	nop

80105590 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105595:	31 c0                	xor    %eax,%eax
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	56                   	push   %esi
8010559a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010559b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010559e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801055a1:	e8 9a ff ff ff       	call   80105540 <argfd.constprop.0>
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 1e                	js     801055c8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801055aa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055ad:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055af:	e8 8c ec ff ff       	call   80104240 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055bc:	85 d2                	test   %edx,%edx
801055be:	74 20                	je     801055e0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c3 01             	add    $0x1,%ebx
801055c3:	83 fb 10             	cmp    $0x10,%ebx
801055c6:	75 f0                	jne    801055b8 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
801055c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055d0:	89 d8                	mov    %ebx,%eax
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ea:	e8 f1 ba ff ff       	call   801010e0 <filedup>
  return fd;
801055ef:	83 c4 10             	add    $0x10,%esp
}
801055f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f5:	89 d8                	mov    %ebx,%eax
801055f7:	5b                   	pop    %ebx
801055f8:	5e                   	pop    %esi
801055f9:	5d                   	pop    %ebp
801055fa:	c3                   	ret    
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop

80105600 <sys_read>:

int
sys_read(void)
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105605:	31 c0                	xor    %eax,%eax
{
80105607:	89 e5                	mov    %esp,%ebp
80105609:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010560c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010560f:	e8 2c ff ff ff       	call   80105540 <argfd.constprop.0>
80105614:	85 c0                	test   %eax,%eax
80105616:	78 48                	js     80105660 <sys_read+0x60>
80105618:	83 ec 08             	sub    $0x8,%esp
8010561b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010561e:	50                   	push   %eax
8010561f:	6a 02                	push   $0x2
80105621:	e8 ba fd ff ff       	call   801053e0 <argint>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 33                	js     80105660 <sys_read+0x60>
8010562d:	83 ec 04             	sub    $0x4,%esp
80105630:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105633:	ff 75 f0             	pushl  -0x10(%ebp)
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 f2 fd ff ff       	call   80105430 <argptr>
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 1b                	js     80105660 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105645:	83 ec 04             	sub    $0x4,%esp
80105648:	ff 75 f0             	pushl  -0x10(%ebp)
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	ff 75 ec             	pushl  -0x14(%ebp)
80105651:	e8 0a bc ff ff       	call   80101260 <fileread>
80105656:	83 c4 10             	add    $0x10,%esp
}
80105659:	c9                   	leave  
8010565a:	c3                   	ret    
8010565b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_write>:

int
sys_write(void)
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105675:	31 c0                	xor    %eax,%eax
{
80105677:	89 e5                	mov    %esp,%ebp
80105679:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010567c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010567f:	e8 bc fe ff ff       	call   80105540 <argfd.constprop.0>
80105684:	85 c0                	test   %eax,%eax
80105686:	78 48                	js     801056d0 <sys_write+0x60>
80105688:	83 ec 08             	sub    $0x8,%esp
8010568b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010568e:	50                   	push   %eax
8010568f:	6a 02                	push   $0x2
80105691:	e8 4a fd ff ff       	call   801053e0 <argint>
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	85 c0                	test   %eax,%eax
8010569b:	78 33                	js     801056d0 <sys_write+0x60>
8010569d:	83 ec 04             	sub    $0x4,%esp
801056a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a3:	ff 75 f0             	pushl  -0x10(%ebp)
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 82 fd ff ff       	call   80105430 <argptr>
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 1b                	js     801056d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801056b5:	83 ec 04             	sub    $0x4,%esp
801056b8:	ff 75 f0             	pushl  -0x10(%ebp)
801056bb:	ff 75 f4             	pushl  -0xc(%ebp)
801056be:	ff 75 ec             	pushl  -0x14(%ebp)
801056c1:	e8 3a bc ff ff       	call   80101300 <filewrite>
801056c6:	83 c4 10             	add    $0x10,%esp
}
801056c9:	c9                   	leave  
801056ca:	c3                   	ret    
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
801056d0:	c9                   	leave  
    return -1;
801056d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d6:	c3                   	ret    
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax

801056e0 <sys_close>:

int
sys_close(void)
{
801056e0:	f3 0f 1e fb          	endbr32 
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801056ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056f0:	e8 4b fe ff ff       	call   80105540 <argfd.constprop.0>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 27                	js     80105720 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801056f9:	e8 42 eb ff ff       	call   80104240 <myproc>
801056fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105701:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105704:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010570b:	00 
  fileclose(f);
8010570c:	ff 75 f4             	pushl  -0xc(%ebp)
8010570f:	e8 1c ba ff ff       	call   80101130 <fileclose>
  return 0;
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	31 c0                	xor    %eax,%eax
}
80105719:	c9                   	leave  
8010571a:	c3                   	ret    
8010571b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
80105720:	c9                   	leave  
    return -1;
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105726:	c3                   	ret    
80105727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572e:	66 90                	xchg   %ax,%ax

80105730 <sys_fstat>:

int
sys_fstat(void)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105735:	31 c0                	xor    %eax,%eax
{
80105737:	89 e5                	mov    %esp,%ebp
80105739:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010573c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010573f:	e8 fc fd ff ff       	call   80105540 <argfd.constprop.0>
80105744:	85 c0                	test   %eax,%eax
80105746:	78 30                	js     80105778 <sys_fstat+0x48>
80105748:	83 ec 04             	sub    $0x4,%esp
8010574b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574e:	6a 14                	push   $0x14
80105750:	50                   	push   %eax
80105751:	6a 01                	push   $0x1
80105753:	e8 d8 fc ff ff       	call   80105430 <argptr>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	78 19                	js     80105778 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010575f:	83 ec 08             	sub    $0x8,%esp
80105762:	ff 75 f4             	pushl  -0xc(%ebp)
80105765:	ff 75 f0             	pushl  -0x10(%ebp)
80105768:	e8 a3 ba ff ff       	call   80101210 <filestat>
8010576d:	83 c4 10             	add    $0x10,%esp
}
80105770:	c9                   	leave  
80105771:	c3                   	ret    
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105778:	c9                   	leave  
    return -1;
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	57                   	push   %edi
80105788:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105789:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010578c:	53                   	push   %ebx
8010578d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105790:	50                   	push   %eax
80105791:	6a 00                	push   $0x0
80105793:	e8 f8 fc ff ff       	call   80105490 <argstr>
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	85 c0                	test   %eax,%eax
8010579d:	0f 88 ff 00 00 00    	js     801058a2 <sys_link+0x122>
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 01                	push   $0x1
801057ac:	e8 df fc ff ff       	call   80105490 <argstr>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	0f 88 e6 00 00 00    	js     801058a2 <sys_link+0x122>
    return -1;

  begin_op();
801057bc:	e8 2f de ff ff       	call   801035f0 <begin_op>
  if((ip = namei(old)) == 0){
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	ff 75 d4             	pushl  -0x2c(%ebp)
801057c7:	e8 d4 ca ff ff       	call   801022a0 <namei>
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	89 c3                	mov    %eax,%ebx
801057d1:	85 c0                	test   %eax,%eax
801057d3:	0f 84 e8 00 00 00    	je     801058c1 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	50                   	push   %eax
801057dd:	e8 ee c1 ff ff       	call   801019d0 <ilock>
  if(ip->type == T_DIR){
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ea:	0f 84 b9 00 00 00    	je     801058a9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801057f8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057fb:	53                   	push   %ebx
801057fc:	e8 0f c1 ff ff       	call   80101910 <iupdate>
  iunlock(ip);
80105801:	89 1c 24             	mov    %ebx,(%esp)
80105804:	e8 a7 c2 ff ff       	call   80101ab0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105809:	58                   	pop    %eax
8010580a:	5a                   	pop    %edx
8010580b:	57                   	push   %edi
8010580c:	ff 75 d0             	pushl  -0x30(%ebp)
8010580f:	e8 ac ca ff ff       	call   801022c0 <nameiparent>
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	89 c6                	mov    %eax,%esi
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 5f                	je     8010587c <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	50                   	push   %eax
80105821:	e8 aa c1 ff ff       	call   801019d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105826:	8b 03                	mov    (%ebx),%eax
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	39 06                	cmp    %eax,(%esi)
8010582d:	75 41                	jne    80105870 <sys_link+0xf0>
8010582f:	83 ec 04             	sub    $0x4,%esp
80105832:	ff 73 04             	pushl  0x4(%ebx)
80105835:	57                   	push   %edi
80105836:	56                   	push   %esi
80105837:	e8 a4 c9 ff ff       	call   801021e0 <dirlink>
8010583c:	83 c4 10             	add    $0x10,%esp
8010583f:	85 c0                	test   %eax,%eax
80105841:	78 2d                	js     80105870 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105843:	83 ec 0c             	sub    $0xc,%esp
80105846:	56                   	push   %esi
80105847:	e8 24 c4 ff ff       	call   80101c70 <iunlockput>
  iput(ip);
8010584c:	89 1c 24             	mov    %ebx,(%esp)
8010584f:	e8 ac c2 ff ff       	call   80101b00 <iput>

  end_op();
80105854:	e8 07 de ff ff       	call   80103660 <end_op>

  return 0;
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010585e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105861:	5b                   	pop    %ebx
80105862:	5e                   	pop    %esi
80105863:	5f                   	pop    %edi
80105864:	5d                   	pop    %ebp
80105865:	c3                   	ret    
80105866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	56                   	push   %esi
80105874:	e8 f7 c3 ff ff       	call   80101c70 <iunlockput>
    goto bad;
80105879:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010587c:	83 ec 0c             	sub    $0xc,%esp
8010587f:	53                   	push   %ebx
80105880:	e8 4b c1 ff ff       	call   801019d0 <ilock>
  ip->nlink--;
80105885:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010588a:	89 1c 24             	mov    %ebx,(%esp)
8010588d:	e8 7e c0 ff ff       	call   80101910 <iupdate>
  iunlockput(ip);
80105892:	89 1c 24             	mov    %ebx,(%esp)
80105895:	e8 d6 c3 ff ff       	call   80101c70 <iunlockput>
  end_op();
8010589a:	e8 c1 dd ff ff       	call   80103660 <end_op>
  return -1;
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a7:	eb b5                	jmp    8010585e <sys_link+0xde>
    iunlockput(ip);
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	53                   	push   %ebx
801058ad:	e8 be c3 ff ff       	call   80101c70 <iunlockput>
    end_op();
801058b2:	e8 a9 dd ff ff       	call   80103660 <end_op>
    return -1;
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bf:	eb 9d                	jmp    8010585e <sys_link+0xde>
    end_op();
801058c1:	e8 9a dd ff ff       	call   80103660 <end_op>
    return -1;
801058c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cb:	eb 91                	jmp    8010585e <sys_link+0xde>
801058cd:	8d 76 00             	lea    0x0(%esi),%esi

801058d0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	57                   	push   %edi
801058d8:	56                   	push   %esi
801058d9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058dc:	53                   	push   %ebx
801058dd:	bb 20 00 00 00       	mov    $0x20,%ebx
801058e2:	83 ec 1c             	sub    $0x1c,%esp
801058e5:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058e8:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801058ec:	77 0a                	ja     801058f8 <isdirempty+0x28>
801058ee:	eb 30                	jmp    80105920 <isdirempty+0x50>
801058f0:	83 c3 10             	add    $0x10,%ebx
801058f3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801058f6:	76 28                	jbe    80105920 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058f8:	6a 10                	push   $0x10
801058fa:	53                   	push   %ebx
801058fb:	57                   	push   %edi
801058fc:	56                   	push   %esi
801058fd:	e8 ce c3 ff ff       	call   80101cd0 <readi>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	83 f8 10             	cmp    $0x10,%eax
80105908:	75 23                	jne    8010592d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010590a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010590f:	74 df                	je     801058f0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105911:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105914:	31 c0                	xor    %eax,%eax
}
80105916:	5b                   	pop    %ebx
80105917:	5e                   	pop    %esi
80105918:	5f                   	pop    %edi
80105919:	5d                   	pop    %ebp
8010591a:	c3                   	ret    
8010591b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105923:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105928:	5b                   	pop    %ebx
80105929:	5e                   	pop    %esi
8010592a:	5f                   	pop    %edi
8010592b:	5d                   	pop    %ebp
8010592c:	c3                   	ret    
      panic("isdirempty: readi");
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	68 44 94 10 80       	push   $0x80109444
80105935:	e8 56 aa ff ff       	call   80100390 <panic>
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105940 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	57                   	push   %edi
80105948:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105949:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010594c:	53                   	push   %ebx
8010594d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105950:	50                   	push   %eax
80105951:	6a 00                	push   $0x0
80105953:	e8 38 fb ff ff       	call   80105490 <argstr>
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	85 c0                	test   %eax,%eax
8010595d:	0f 88 5d 01 00 00    	js     80105ac0 <sys_unlink+0x180>
    return -1;

  begin_op();
80105963:	e8 88 dc ff ff       	call   801035f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105968:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	53                   	push   %ebx
8010596f:	ff 75 c0             	pushl  -0x40(%ebp)
80105972:	e8 49 c9 ff ff       	call   801022c0 <nameiparent>
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	89 c6                	mov    %eax,%esi
8010597c:	85 c0                	test   %eax,%eax
8010597e:	0f 84 43 01 00 00    	je     80105ac7 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105984:	83 ec 0c             	sub    $0xc,%esp
80105987:	50                   	push   %eax
80105988:	e8 43 c0 ff ff       	call   801019d0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010598d:	58                   	pop    %eax
8010598e:	5a                   	pop    %edx
8010598f:	68 7f 8d 10 80       	push   $0x80108d7f
80105994:	53                   	push   %ebx
80105995:	e8 66 c5 ff ff       	call   80101f00 <namecmp>
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	85 c0                	test   %eax,%eax
8010599f:	0f 84 db 00 00 00    	je     80105a80 <sys_unlink+0x140>
801059a5:	83 ec 08             	sub    $0x8,%esp
801059a8:	68 7e 8d 10 80       	push   $0x80108d7e
801059ad:	53                   	push   %ebx
801059ae:	e8 4d c5 ff ff       	call   80101f00 <namecmp>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	0f 84 c2 00 00 00    	je     80105a80 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801059be:	83 ec 04             	sub    $0x4,%esp
801059c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801059c4:	50                   	push   %eax
801059c5:	53                   	push   %ebx
801059c6:	56                   	push   %esi
801059c7:	e8 54 c5 ff ff       	call   80101f20 <dirlookup>
801059cc:	83 c4 10             	add    $0x10,%esp
801059cf:	89 c3                	mov    %eax,%ebx
801059d1:	85 c0                	test   %eax,%eax
801059d3:	0f 84 a7 00 00 00    	je     80105a80 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
801059d9:	83 ec 0c             	sub    $0xc,%esp
801059dc:	50                   	push   %eax
801059dd:	e8 ee bf ff ff       	call   801019d0 <ilock>

  if(ip->nlink < 1)
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059ea:	0f 8e f3 00 00 00    	jle    80105ae3 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801059f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059f5:	74 69                	je     80105a60 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801059f7:	83 ec 04             	sub    $0x4,%esp
801059fa:	8d 7d d8             	lea    -0x28(%ebp),%edi
801059fd:	6a 10                	push   $0x10
801059ff:	6a 00                	push   $0x0
80105a01:	57                   	push   %edi
80105a02:	e8 f9 f6 ff ff       	call   80105100 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a07:	6a 10                	push   $0x10
80105a09:	ff 75 c4             	pushl  -0x3c(%ebp)
80105a0c:	57                   	push   %edi
80105a0d:	56                   	push   %esi
80105a0e:	e8 bd c3 ff ff       	call   80101dd0 <writei>
80105a13:	83 c4 20             	add    $0x20,%esp
80105a16:	83 f8 10             	cmp    $0x10,%eax
80105a19:	0f 85 b7 00 00 00    	jne    80105ad6 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105a1f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a24:	74 7a                	je     80105aa0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105a26:	83 ec 0c             	sub    $0xc,%esp
80105a29:	56                   	push   %esi
80105a2a:	e8 41 c2 ff ff       	call   80101c70 <iunlockput>

  ip->nlink--;
80105a2f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a34:	89 1c 24             	mov    %ebx,(%esp)
80105a37:	e8 d4 be ff ff       	call   80101910 <iupdate>
  iunlockput(ip);
80105a3c:	89 1c 24             	mov    %ebx,(%esp)
80105a3f:	e8 2c c2 ff ff       	call   80101c70 <iunlockput>

  end_op();
80105a44:	e8 17 dc ff ff       	call   80103660 <end_op>

  return 0;
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a51:	5b                   	pop    %ebx
80105a52:	5e                   	pop    %esi
80105a53:	5f                   	pop    %edi
80105a54:	5d                   	pop    %ebp
80105a55:	c3                   	ret    
80105a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	53                   	push   %ebx
80105a64:	e8 67 fe ff ff       	call   801058d0 <isdirempty>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	75 87                	jne    801059f7 <sys_unlink+0xb7>
    iunlockput(ip);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	53                   	push   %ebx
80105a74:	e8 f7 c1 ff ff       	call   80101c70 <iunlockput>
    goto bad;
80105a79:	83 c4 10             	add    $0x10,%esp
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	56                   	push   %esi
80105a84:	e8 e7 c1 ff ff       	call   80101c70 <iunlockput>
  end_op();
80105a89:	e8 d2 db ff ff       	call   80103660 <end_op>
  return -1;
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a96:	eb b6                	jmp    80105a4e <sys_unlink+0x10e>
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
    iupdate(dp);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105aa3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105aa8:	56                   	push   %esi
80105aa9:	e8 62 be ff ff       	call   80101910 <iupdate>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	e9 70 ff ff ff       	jmp    80105a26 <sys_unlink+0xe6>
80105ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac5:	eb 87                	jmp    80105a4e <sys_unlink+0x10e>
    end_op();
80105ac7:	e8 94 db ff ff       	call   80103660 <end_op>
    return -1;
80105acc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad1:	e9 78 ff ff ff       	jmp    80105a4e <sys_unlink+0x10e>
    panic("unlink: writei");
80105ad6:	83 ec 0c             	sub    $0xc,%esp
80105ad9:	68 93 8d 10 80       	push   $0x80108d93
80105ade:	e8 ad a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105ae3:	83 ec 0c             	sub    $0xc,%esp
80105ae6:	68 81 8d 10 80       	push   $0x80108d81
80105aeb:	e8 a0 a8 ff ff       	call   80100390 <panic>

80105af0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105af0:	f3 0f 1e fb          	endbr32 
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	57                   	push   %edi
80105af8:	56                   	push   %esi
80105af9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105afa:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105afd:	83 ec 34             	sub    $0x34,%esp
80105b00:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b03:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105b06:	53                   	push   %ebx
{
80105b07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105b0a:	ff 75 08             	pushl  0x8(%ebp)
{
80105b0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105b10:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105b13:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105b16:	e8 a5 c7 ff ff       	call   801022c0 <nameiparent>
80105b1b:	83 c4 10             	add    $0x10,%esp
80105b1e:	85 c0                	test   %eax,%eax
80105b20:	0f 84 3a 01 00 00    	je     80105c60 <create+0x170>
    return 0;
  ilock(dp);
80105b26:	83 ec 0c             	sub    $0xc,%esp
80105b29:	89 c6                	mov    %eax,%esi
80105b2b:	50                   	push   %eax
80105b2c:	e8 9f be ff ff       	call   801019d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105b31:	83 c4 0c             	add    $0xc,%esp
80105b34:	6a 00                	push   $0x0
80105b36:	53                   	push   %ebx
80105b37:	56                   	push   %esi
80105b38:	e8 e3 c3 ff ff       	call   80101f20 <dirlookup>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	89 c7                	mov    %eax,%edi
80105b42:	85 c0                	test   %eax,%eax
80105b44:	74 4a                	je     80105b90 <create+0xa0>
    iunlockput(dp);
80105b46:	83 ec 0c             	sub    $0xc,%esp
80105b49:	56                   	push   %esi
80105b4a:	e8 21 c1 ff ff       	call   80101c70 <iunlockput>
    ilock(ip);
80105b4f:	89 3c 24             	mov    %edi,(%esp)
80105b52:	e8 79 be ff ff       	call   801019d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105b57:	83 c4 10             	add    $0x10,%esp
80105b5a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b5f:	75 17                	jne    80105b78 <create+0x88>
80105b61:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105b66:	75 10                	jne    80105b78 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6b:	89 f8                	mov    %edi,%eax
80105b6d:	5b                   	pop    %ebx
80105b6e:	5e                   	pop    %esi
80105b6f:	5f                   	pop    %edi
80105b70:	5d                   	pop    %ebp
80105b71:	c3                   	ret    
80105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b78:	83 ec 0c             	sub    $0xc,%esp
80105b7b:	57                   	push   %edi
    return 0;
80105b7c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105b7e:	e8 ed c0 ff ff       	call   80101c70 <iunlockput>
    return 0;
80105b83:	83 c4 10             	add    $0x10,%esp
}
80105b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b89:	89 f8                	mov    %edi,%eax
80105b8b:	5b                   	pop    %ebx
80105b8c:	5e                   	pop    %esi
80105b8d:	5f                   	pop    %edi
80105b8e:	5d                   	pop    %ebp
80105b8f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105b90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105b94:	83 ec 08             	sub    $0x8,%esp
80105b97:	50                   	push   %eax
80105b98:	ff 36                	pushl  (%esi)
80105b9a:	e8 b1 bc ff ff       	call   80101850 <ialloc>
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	89 c7                	mov    %eax,%edi
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	0f 84 cd 00 00 00    	je     80105c79 <create+0x189>
  ilock(ip);
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	50                   	push   %eax
80105bb0:	e8 1b be ff ff       	call   801019d0 <ilock>
  ip->major = major;
80105bb5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105bb9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105bbd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105bc1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105bc5:	b8 01 00 00 00       	mov    $0x1,%eax
80105bca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105bce:	89 3c 24             	mov    %edi,(%esp)
80105bd1:	e8 3a bd ff ff       	call   80101910 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105bde:	74 30                	je     80105c10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105be0:	83 ec 04             	sub    $0x4,%esp
80105be3:	ff 77 04             	pushl  0x4(%edi)
80105be6:	53                   	push   %ebx
80105be7:	56                   	push   %esi
80105be8:	e8 f3 c5 ff ff       	call   801021e0 <dirlink>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	78 78                	js     80105c6c <create+0x17c>
  iunlockput(dp);
80105bf4:	83 ec 0c             	sub    $0xc,%esp
80105bf7:	56                   	push   %esi
80105bf8:	e8 73 c0 ff ff       	call   80101c70 <iunlockput>
  return ip;
80105bfd:	83 c4 10             	add    $0x10,%esp
}
80105c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c03:	89 f8                	mov    %edi,%eax
80105c05:	5b                   	pop    %ebx
80105c06:	5e                   	pop    %esi
80105c07:	5f                   	pop    %edi
80105c08:	5d                   	pop    %ebp
80105c09:	c3                   	ret    
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105c10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105c13:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105c18:	56                   	push   %esi
80105c19:	e8 f2 bc ff ff       	call   80101910 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c1e:	83 c4 0c             	add    $0xc,%esp
80105c21:	ff 77 04             	pushl  0x4(%edi)
80105c24:	68 7f 8d 10 80       	push   $0x80108d7f
80105c29:	57                   	push   %edi
80105c2a:	e8 b1 c5 ff ff       	call   801021e0 <dirlink>
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	85 c0                	test   %eax,%eax
80105c34:	78 18                	js     80105c4e <create+0x15e>
80105c36:	83 ec 04             	sub    $0x4,%esp
80105c39:	ff 76 04             	pushl  0x4(%esi)
80105c3c:	68 7e 8d 10 80       	push   $0x80108d7e
80105c41:	57                   	push   %edi
80105c42:	e8 99 c5 ff ff       	call   801021e0 <dirlink>
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	85 c0                	test   %eax,%eax
80105c4c:	79 92                	jns    80105be0 <create+0xf0>
      panic("create dots");
80105c4e:	83 ec 0c             	sub    $0xc,%esp
80105c51:	68 65 94 10 80       	push   $0x80109465
80105c56:	e8 35 a7 ff ff       	call   80100390 <panic>
80105c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c5f:	90                   	nop
}
80105c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105c63:	31 ff                	xor    %edi,%edi
}
80105c65:	5b                   	pop    %ebx
80105c66:	89 f8                	mov    %edi,%eax
80105c68:	5e                   	pop    %esi
80105c69:	5f                   	pop    %edi
80105c6a:	5d                   	pop    %ebp
80105c6b:	c3                   	ret    
    panic("create: dirlink");
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	68 71 94 10 80       	push   $0x80109471
80105c74:	e8 17 a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105c79:	83 ec 0c             	sub    $0xc,%esp
80105c7c:	68 56 94 10 80       	push   $0x80109456
80105c81:	e8 0a a7 ff ff       	call   80100390 <panic>
80105c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi

80105c90 <sys_open>:

int
sys_open(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	57                   	push   %edi
80105c98:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c99:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c9c:	53                   	push   %ebx
80105c9d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ca0:	50                   	push   %eax
80105ca1:	6a 00                	push   $0x0
80105ca3:	e8 e8 f7 ff ff       	call   80105490 <argstr>
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	85 c0                	test   %eax,%eax
80105cad:	0f 88 8a 00 00 00    	js     80105d3d <sys_open+0xad>
80105cb3:	83 ec 08             	sub    $0x8,%esp
80105cb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cb9:	50                   	push   %eax
80105cba:	6a 01                	push   $0x1
80105cbc:	e8 1f f7 ff ff       	call   801053e0 <argint>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	78 75                	js     80105d3d <sys_open+0xad>
    return -1;

  begin_op();
80105cc8:	e8 23 d9 ff ff       	call   801035f0 <begin_op>

  if(omode & O_CREATE){
80105ccd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105cd1:	75 75                	jne    80105d48 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105cd3:	83 ec 0c             	sub    $0xc,%esp
80105cd6:	ff 75 e0             	pushl  -0x20(%ebp)
80105cd9:	e8 c2 c5 ff ff       	call   801022a0 <namei>
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	89 c6                	mov    %eax,%esi
80105ce3:	85 c0                	test   %eax,%eax
80105ce5:	74 78                	je     80105d5f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105ce7:	83 ec 0c             	sub    $0xc,%esp
80105cea:	50                   	push   %eax
80105ceb:	e8 e0 bc ff ff       	call   801019d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105cf8:	0f 84 ba 00 00 00    	je     80105db8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cfe:	e8 6d b3 ff ff       	call   80101070 <filealloc>
80105d03:	89 c7                	mov    %eax,%edi
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 23                	je     80105d2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d09:	e8 32 e5 ff ff       	call   80104240 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d0e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105d10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d14:	85 d2                	test   %edx,%edx
80105d16:	74 58                	je     80105d70 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105d18:	83 c3 01             	add    $0x1,%ebx
80105d1b:	83 fb 10             	cmp    $0x10,%ebx
80105d1e:	75 f0                	jne    80105d10 <sys_open+0x80>
    if(f)
      fileclose(f);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	57                   	push   %edi
80105d24:	e8 07 b4 ff ff       	call   80101130 <fileclose>
80105d29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d2c:	83 ec 0c             	sub    $0xc,%esp
80105d2f:	56                   	push   %esi
80105d30:	e8 3b bf ff ff       	call   80101c70 <iunlockput>
    end_op();
80105d35:	e8 26 d9 ff ff       	call   80103660 <end_op>
    return -1;
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d42:	eb 65                	jmp    80105da9 <sys_open+0x119>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105d48:	6a 00                	push   $0x0
80105d4a:	6a 00                	push   $0x0
80105d4c:	6a 02                	push   $0x2
80105d4e:	ff 75 e0             	pushl  -0x20(%ebp)
80105d51:	e8 9a fd ff ff       	call   80105af0 <create>
    if(ip == 0){
80105d56:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d59:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	75 9f                	jne    80105cfe <sys_open+0x6e>
      end_op();
80105d5f:	e8 fc d8 ff ff       	call   80103660 <end_op>
      return -1;
80105d64:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d69:	eb 3e                	jmp    80105da9 <sys_open+0x119>
80105d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
  }
  iunlock(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d73:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105d77:	56                   	push   %esi
80105d78:	e8 33 bd ff ff       	call   80101ab0 <iunlock>
  end_op();
80105d7d:	e8 de d8 ff ff       	call   80103660 <end_op>

  f->type = FD_INODE;
80105d82:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d8b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d8e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d91:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d93:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d9a:	f7 d0                	not    %eax
80105d9c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d9f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105da2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105da5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dac:	89 d8                	mov    %ebx,%eax
80105dae:	5b                   	pop    %ebx
80105daf:	5e                   	pop    %esi
80105db0:	5f                   	pop    %edi
80105db1:	5d                   	pop    %ebp
80105db2:	c3                   	ret    
80105db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105db7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105db8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105dbb:	85 c9                	test   %ecx,%ecx
80105dbd:	0f 84 3b ff ff ff    	je     80105cfe <sys_open+0x6e>
80105dc3:	e9 64 ff ff ff       	jmp    80105d2c <sys_open+0x9c>
80105dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop

80105dd0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105dda:	e8 11 d8 ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ddf:	83 ec 08             	sub    $0x8,%esp
80105de2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de5:	50                   	push   %eax
80105de6:	6a 00                	push   $0x0
80105de8:	e8 a3 f6 ff ff       	call   80105490 <argstr>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	78 2c                	js     80105e20 <sys_mkdir+0x50>
80105df4:	6a 00                	push   $0x0
80105df6:	6a 00                	push   $0x0
80105df8:	6a 01                	push   $0x1
80105dfa:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfd:	e8 ee fc ff ff       	call   80105af0 <create>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	85 c0                	test   %eax,%eax
80105e07:	74 17                	je     80105e20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e09:	83 ec 0c             	sub    $0xc,%esp
80105e0c:	50                   	push   %eax
80105e0d:	e8 5e be ff ff       	call   80101c70 <iunlockput>
  end_op();
80105e12:	e8 49 d8 ff ff       	call   80103660 <end_op>
  return 0;
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	31 c0                	xor    %eax,%eax
}
80105e1c:	c9                   	leave  
80105e1d:	c3                   	ret    
80105e1e:	66 90                	xchg   %ax,%ax
    end_op();
80105e20:	e8 3b d8 ff ff       	call   80103660 <end_op>
    return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_mknod>:

int
sys_mknod(void)
{
80105e30:	f3 0f 1e fb          	endbr32 
80105e34:	55                   	push   %ebp
80105e35:	89 e5                	mov    %esp,%ebp
80105e37:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e3a:	e8 b1 d7 ff ff       	call   801035f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e3f:	83 ec 08             	sub    $0x8,%esp
80105e42:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e45:	50                   	push   %eax
80105e46:	6a 00                	push   $0x0
80105e48:	e8 43 f6 ff ff       	call   80105490 <argstr>
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 5c                	js     80105eb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e54:	83 ec 08             	sub    $0x8,%esp
80105e57:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e5a:	50                   	push   %eax
80105e5b:	6a 01                	push   $0x1
80105e5d:	e8 7e f5 ff ff       	call   801053e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105e62:	83 c4 10             	add    $0x10,%esp
80105e65:	85 c0                	test   %eax,%eax
80105e67:	78 47                	js     80105eb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e69:	83 ec 08             	sub    $0x8,%esp
80105e6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e6f:	50                   	push   %eax
80105e70:	6a 02                	push   $0x2
80105e72:	e8 69 f5 ff ff       	call   801053e0 <argint>
     argint(1, &major) < 0 ||
80105e77:	83 c4 10             	add    $0x10,%esp
80105e7a:	85 c0                	test   %eax,%eax
80105e7c:	78 32                	js     80105eb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e7e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e82:	50                   	push   %eax
80105e83:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105e87:	50                   	push   %eax
80105e88:	6a 03                	push   $0x3
80105e8a:	ff 75 ec             	pushl  -0x14(%ebp)
80105e8d:	e8 5e fc ff ff       	call   80105af0 <create>
     argint(2, &minor) < 0 ||
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	85 c0                	test   %eax,%eax
80105e97:	74 17                	je     80105eb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e99:	83 ec 0c             	sub    $0xc,%esp
80105e9c:	50                   	push   %eax
80105e9d:	e8 ce bd ff ff       	call   80101c70 <iunlockput>
  end_op();
80105ea2:	e8 b9 d7 ff ff       	call   80103660 <end_op>
  return 0;
80105ea7:	83 c4 10             	add    $0x10,%esp
80105eaa:	31 c0                	xor    %eax,%eax
}
80105eac:	c9                   	leave  
80105ead:	c3                   	ret    
80105eae:	66 90                	xchg   %ax,%ax
    end_op();
80105eb0:	e8 ab d7 ff ff       	call   80103660 <end_op>
    return -1;
80105eb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_chdir>:

int
sys_chdir(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	56                   	push   %esi
80105ec8:	53                   	push   %ebx
80105ec9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ecc:	e8 6f e3 ff ff       	call   80104240 <myproc>
80105ed1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ed3:	e8 18 d7 ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ed8:	83 ec 08             	sub    $0x8,%esp
80105edb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ede:	50                   	push   %eax
80105edf:	6a 00                	push   $0x0
80105ee1:	e8 aa f5 ff ff       	call   80105490 <argstr>
80105ee6:	83 c4 10             	add    $0x10,%esp
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	78 73                	js     80105f60 <sys_chdir+0xa0>
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ef3:	e8 a8 c3 ff ff       	call   801022a0 <namei>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	89 c3                	mov    %eax,%ebx
80105efd:	85 c0                	test   %eax,%eax
80105eff:	74 5f                	je     80105f60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f01:	83 ec 0c             	sub    $0xc,%esp
80105f04:	50                   	push   %eax
80105f05:	e8 c6 ba ff ff       	call   801019d0 <ilock>
  if(ip->type != T_DIR){
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f12:	75 2c                	jne    80105f40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f14:	83 ec 0c             	sub    $0xc,%esp
80105f17:	53                   	push   %ebx
80105f18:	e8 93 bb ff ff       	call   80101ab0 <iunlock>
  iput(curproc->cwd);
80105f1d:	58                   	pop    %eax
80105f1e:	ff 76 68             	pushl  0x68(%esi)
80105f21:	e8 da bb ff ff       	call   80101b00 <iput>
  end_op();
80105f26:	e8 35 d7 ff ff       	call   80103660 <end_op>
  curproc->cwd = ip;
80105f2b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	31 c0                	xor    %eax,%eax
}
80105f33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f36:	5b                   	pop    %ebx
80105f37:	5e                   	pop    %esi
80105f38:	5d                   	pop    %ebp
80105f39:	c3                   	ret    
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	53                   	push   %ebx
80105f44:	e8 27 bd ff ff       	call   80101c70 <iunlockput>
    end_op();
80105f49:	e8 12 d7 ff ff       	call   80103660 <end_op>
    return -1;
80105f4e:	83 c4 10             	add    $0x10,%esp
80105f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f56:	eb db                	jmp    80105f33 <sys_chdir+0x73>
80105f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5f:	90                   	nop
    end_op();
80105f60:	e8 fb d6 ff ff       	call   80103660 <end_op>
    return -1;
80105f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f6a:	eb c7                	jmp    80105f33 <sys_chdir+0x73>
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f70 <sys_exec>:

int
sys_exec(void)
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	57                   	push   %edi
80105f78:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f79:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f7f:	53                   	push   %ebx
80105f80:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f86:	50                   	push   %eax
80105f87:	6a 00                	push   $0x0
80105f89:	e8 02 f5 ff ff       	call   80105490 <argstr>
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	85 c0                	test   %eax,%eax
80105f93:	0f 88 8b 00 00 00    	js     80106024 <sys_exec+0xb4>
80105f99:	83 ec 08             	sub    $0x8,%esp
80105f9c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105fa2:	50                   	push   %eax
80105fa3:	6a 01                	push   $0x1
80105fa5:	e8 36 f4 ff ff       	call   801053e0 <argint>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	85 c0                	test   %eax,%eax
80105faf:	78 73                	js     80106024 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105fb1:	83 ec 04             	sub    $0x4,%esp
80105fb4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105fba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fbc:	68 80 00 00 00       	push   $0x80
80105fc1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105fc7:	6a 00                	push   $0x0
80105fc9:	50                   	push   %eax
80105fca:	e8 31 f1 ff ff       	call   80105100 <memset>
80105fcf:	83 c4 10             	add    $0x10,%esp
80105fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fd8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105fde:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105fe5:	83 ec 08             	sub    $0x8,%esp
80105fe8:	57                   	push   %edi
80105fe9:	01 f0                	add    %esi,%eax
80105feb:	50                   	push   %eax
80105fec:	e8 4f f3 ff ff       	call   80105340 <fetchint>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	78 2c                	js     80106024 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ff8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ffe:	85 c0                	test   %eax,%eax
80106000:	74 36                	je     80106038 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106002:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106008:	83 ec 08             	sub    $0x8,%esp
8010600b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010600e:	52                   	push   %edx
8010600f:	50                   	push   %eax
80106010:	e8 6b f3 ff ff       	call   80105380 <fetchstr>
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	85 c0                	test   %eax,%eax
8010601a:	78 08                	js     80106024 <sys_exec+0xb4>
  for(i=0;; i++){
8010601c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010601f:	83 fb 20             	cmp    $0x20,%ebx
80106022:	75 b4                	jne    80105fd8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106024:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010602c:	5b                   	pop    %ebx
8010602d:	5e                   	pop    %esi
8010602e:	5f                   	pop    %edi
8010602f:	5d                   	pop    %ebp
80106030:	c3                   	ret    
80106031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106038:	83 ec 08             	sub    $0x8,%esp
8010603b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106041:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106048:	00 00 00 00 
  return exec(path, argv);
8010604c:	50                   	push   %eax
8010604d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106053:	e8 98 ac ff ff       	call   80100cf0 <exec>
80106058:	83 c4 10             	add    $0x10,%esp
}
8010605b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010605e:	5b                   	pop    %ebx
8010605f:	5e                   	pop    %esi
80106060:	5f                   	pop    %edi
80106061:	5d                   	pop    %ebp
80106062:	c3                   	ret    
80106063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106070 <sys_pipe>:

int
sys_pipe(void)
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	57                   	push   %edi
80106078:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106079:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010607c:	53                   	push   %ebx
8010607d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106080:	6a 08                	push   $0x8
80106082:	50                   	push   %eax
80106083:	6a 00                	push   $0x0
80106085:	e8 a6 f3 ff ff       	call   80105430 <argptr>
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	85 c0                	test   %eax,%eax
8010608f:	78 4e                	js     801060df <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106091:	83 ec 08             	sub    $0x8,%esp
80106094:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106097:	50                   	push   %eax
80106098:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010609b:	50                   	push   %eax
8010609c:	e8 1f dc ff ff       	call   80103cc0 <pipealloc>
801060a1:	83 c4 10             	add    $0x10,%esp
801060a4:	85 c0                	test   %eax,%eax
801060a6:	78 37                	js     801060df <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801060ab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801060ad:	e8 8e e1 ff ff       	call   80104240 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801060b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801060bc:	85 f6                	test   %esi,%esi
801060be:	74 30                	je     801060f0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801060c0:	83 c3 01             	add    $0x1,%ebx
801060c3:	83 fb 10             	cmp    $0x10,%ebx
801060c6:	75 f0                	jne    801060b8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801060c8:	83 ec 0c             	sub    $0xc,%esp
801060cb:	ff 75 e0             	pushl  -0x20(%ebp)
801060ce:	e8 5d b0 ff ff       	call   80101130 <fileclose>
    fileclose(wf);
801060d3:	58                   	pop    %eax
801060d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801060d7:	e8 54 b0 ff ff       	call   80101130 <fileclose>
    return -1;
801060dc:	83 c4 10             	add    $0x10,%esp
801060df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e4:	eb 5b                	jmp    80106141 <sys_pipe+0xd1>
801060e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801060f0:	8d 73 08             	lea    0x8(%ebx),%esi
801060f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801060fa:	e8 41 e1 ff ff       	call   80104240 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ff:	31 d2                	xor    %edx,%edx
80106101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106108:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010610c:	85 c9                	test   %ecx,%ecx
8010610e:	74 20                	je     80106130 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106110:	83 c2 01             	add    $0x1,%edx
80106113:	83 fa 10             	cmp    $0x10,%edx
80106116:	75 f0                	jne    80106108 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106118:	e8 23 e1 ff ff       	call   80104240 <myproc>
8010611d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106124:	00 
80106125:	eb a1                	jmp    801060c8 <sys_pipe+0x58>
80106127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106130:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106134:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106137:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106139:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010613c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010613f:	31 c0                	xor    %eax,%eax
}
80106141:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106144:	5b                   	pop    %ebx
80106145:	5e                   	pop    %esi
80106146:	5f                   	pop    %edi
80106147:	5d                   	pop    %ebp
80106148:	c3                   	ret    
80106149:	66 90                	xchg   %ax,%ax
8010614b:	66 90                	xchg   %ax,%ax
8010614d:	66 90                	xchg   %ax,%ax
8010614f:	90                   	nop

80106150 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106150:	f3 0f 1e fb          	endbr32 
  return fork();
80106154:	e9 b7 e2 ff ff       	jmp    80104410 <fork>
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106160 <sys_exit>:
}

int
sys_exit(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 08             	sub    $0x8,%esp
  exit();
8010616a:	e8 f1 e5 ff ff       	call   80104760 <exit>
  return 0;  // not reached
}
8010616f:	31 c0                	xor    %eax,%eax
80106171:	c9                   	leave  
80106172:	c3                   	ret    
80106173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106180 <sys_wait>:

int
sys_wait(void)
{
80106180:	f3 0f 1e fb          	endbr32 
  return wait();
80106184:	e9 27 e8 ff ff       	jmp    801049b0 <wait>
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_kill>:
}

int
sys_kill(void)
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010619a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010619d:	50                   	push   %eax
8010619e:	6a 00                	push   $0x0
801061a0:	e8 3b f2 ff ff       	call   801053e0 <argint>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	85 c0                	test   %eax,%eax
801061aa:	78 14                	js     801061c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801061ac:	83 ec 0c             	sub    $0xc,%esp
801061af:	ff 75 f4             	pushl  -0xc(%ebp)
801061b2:	e8 b9 e9 ff ff       	call   80104b70 <kill>
801061b7:	83 c4 10             	add    $0x10,%esp
}
801061ba:	c9                   	leave  
801061bb:	c3                   	ret    
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061c0:	c9                   	leave  
    return -1;
801061c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061c6:	c3                   	ret    
801061c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ce:	66 90                	xchg   %ax,%ax

801061d0 <sys_getpid>:

int
sys_getpid(void)
{
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
801061d5:	89 e5                	mov    %esp,%ebp
801061d7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801061da:	e8 61 e0 ff ff       	call   80104240 <myproc>
801061df:	8b 40 10             	mov    0x10(%eax),%eax
}
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop

801061f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801061f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061fe:	50                   	push   %eax
801061ff:	6a 00                	push   $0x0
80106201:	e8 da f1 ff ff       	call   801053e0 <argint>
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	85 c0                	test   %eax,%eax
8010620b:	78 23                	js     80106230 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010620d:	e8 2e e0 ff ff       	call   80104240 <myproc>
  if(growproc(n) < 0)
80106212:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106215:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106217:	ff 75 f4             	pushl  -0xc(%ebp)
8010621a:	e8 51 e1 ff ff       	call   80104370 <growproc>
8010621f:	83 c4 10             	add    $0x10,%esp
80106222:	85 c0                	test   %eax,%eax
80106224:	78 0a                	js     80106230 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106226:	89 d8                	mov    %ebx,%eax
80106228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010622b:	c9                   	leave  
8010622c:	c3                   	ret    
8010622d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106230:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106235:	eb ef                	jmp    80106226 <sys_sbrk+0x36>
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax

80106240 <sys_sleep>:

int
sys_sleep(void)
{
80106240:	f3 0f 1e fb          	endbr32 
80106244:	55                   	push   %ebp
80106245:	89 e5                	mov    %esp,%ebp
80106247:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106248:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010624b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010624e:	50                   	push   %eax
8010624f:	6a 00                	push   $0x0
80106251:	e8 8a f1 ff ff       	call   801053e0 <argint>
80106256:	83 c4 10             	add    $0x10,%esp
80106259:	85 c0                	test   %eax,%eax
8010625b:	0f 88 86 00 00 00    	js     801062e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106261:	83 ec 0c             	sub    $0xc,%esp
80106264:	68 60 6d 19 80       	push   $0x80196d60
80106269:	e8 82 ed ff ff       	call   80104ff0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010626e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106271:	8b 1d a0 75 19 80    	mov    0x801975a0,%ebx
  while(ticks - ticks0 < n){
80106277:	83 c4 10             	add    $0x10,%esp
8010627a:	85 d2                	test   %edx,%edx
8010627c:	75 23                	jne    801062a1 <sys_sleep+0x61>
8010627e:	eb 50                	jmp    801062d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106280:	83 ec 08             	sub    $0x8,%esp
80106283:	68 60 6d 19 80       	push   $0x80196d60
80106288:	68 a0 75 19 80       	push   $0x801975a0
8010628d:	e8 5e e6 ff ff       	call   801048f0 <sleep>
  while(ticks - ticks0 < n){
80106292:	a1 a0 75 19 80       	mov    0x801975a0,%eax
80106297:	83 c4 10             	add    $0x10,%esp
8010629a:	29 d8                	sub    %ebx,%eax
8010629c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010629f:	73 2f                	jae    801062d0 <sys_sleep+0x90>
    if(myproc()->killed){
801062a1:	e8 9a df ff ff       	call   80104240 <myproc>
801062a6:	8b 40 24             	mov    0x24(%eax),%eax
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 d3                	je     80106280 <sys_sleep+0x40>
      release(&tickslock);
801062ad:	83 ec 0c             	sub    $0xc,%esp
801062b0:	68 60 6d 19 80       	push   $0x80196d60
801062b5:	e8 f6 ed ff ff       	call   801050b0 <release>
  }
  release(&tickslock);
  return 0;
}
801062ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801062bd:	83 c4 10             	add    $0x10,%esp
801062c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062c5:	c9                   	leave  
801062c6:	c3                   	ret    
801062c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	68 60 6d 19 80       	push   $0x80196d60
801062d8:	e8 d3 ed ff ff       	call   801050b0 <release>
  return 0;
801062dd:	83 c4 10             	add    $0x10,%esp
801062e0:	31 c0                	xor    %eax,%eax
}
801062e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
    return -1;
801062e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ec:	eb f4                	jmp    801062e2 <sys_sleep+0xa2>
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801062f0:	f3 0f 1e fb          	endbr32 
801062f4:	55                   	push   %ebp
801062f5:	89 e5                	mov    %esp,%ebp
801062f7:	53                   	push   %ebx
801062f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062fb:	68 60 6d 19 80       	push   $0x80196d60
80106300:	e8 eb ec ff ff       	call   80104ff0 <acquire>
  xticks = ticks;
80106305:	8b 1d a0 75 19 80    	mov    0x801975a0,%ebx
  release(&tickslock);
8010630b:	c7 04 24 60 6d 19 80 	movl   $0x80196d60,(%esp)
80106312:	e8 99 ed ff ff       	call   801050b0 <release>
  return xticks;
}
80106317:	89 d8                	mov    %ebx,%eax
80106319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010631c:	c9                   	leave  
8010631d:	c3                   	ret    
8010631e:	66 90                	xchg   %ax,%ax

80106320 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106320:	f3 0f 1e fb          	endbr32 
  return getNumberOfFreePages();
80106324:	e9 e7 e9 ff ff       	jmp    80104d10 <getNumberOfFreePages>
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106330 <sys_getNumRefs>:
}

int
sys_getNumRefs(void)
{
80106330:	f3 0f 1e fb          	endbr32 
80106334:	55                   	push   %ebp
80106335:	89 e5                	mov    %esp,%ebp
80106337:	83 ec 20             	sub    $0x20,%esp
  int arrindx;

  if(argint(0, &arrindx) < 0)
8010633a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010633d:	50                   	push   %eax
8010633e:	6a 00                	push   $0x0
80106340:	e8 9b f0 ff ff       	call   801053e0 <argint>
80106345:	83 c4 10             	add    $0x10,%esp
80106348:	85 c0                	test   %eax,%eax
8010634a:	78 14                	js     80106360 <sys_getNumRefs+0x30>
    return -1;
  return getNumRefs(arrindx);
8010634c:	83 ec 0c             	sub    $0xc,%esp
8010634f:	ff 75 f4             	pushl  -0xc(%ebp)
80106352:	e8 c9 e9 ff ff       	call   80104d20 <getNumRefs>
80106357:	83 c4 10             	add    $0x10,%esp
8010635a:	c9                   	leave  
8010635b:	c3                   	ret    
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106360:	c9                   	leave  
    return -1;
80106361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106366:	c3                   	ret    

80106367 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106367:	1e                   	push   %ds
  pushl %es
80106368:	06                   	push   %es
  pushl %fs
80106369:	0f a0                	push   %fs
  pushl %gs
8010636b:	0f a8                	push   %gs
  pushal
8010636d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010636e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106372:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106374:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106376:	54                   	push   %esp
  call trap
80106377:	e8 c4 00 00 00       	call   80106440 <trap>
  addl $4, %esp
8010637c:	83 c4 04             	add    $0x4,%esp

8010637f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010637f:	61                   	popa   
  popl %gs
80106380:	0f a9                	pop    %gs
  popl %fs
80106382:	0f a1                	pop    %fs
  popl %es
80106384:	07                   	pop    %es
  popl %ds
80106385:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106386:	83 c4 08             	add    $0x8,%esp
  iret
80106389:	cf                   	iret   
8010638a:	66 90                	xchg   %ax,%ax
8010638c:	66 90                	xchg   %ax,%ax
8010638e:	66 90                	xchg   %ax,%ax

80106390 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106390:	f3 0f 1e fb          	endbr32 
80106394:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106395:	31 c0                	xor    %eax,%eax
{
80106397:	89 e5                	mov    %esp,%ebp
80106399:	83 ec 08             	sub    $0x8,%esp
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063a0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801063a7:	c7 04 c5 a2 6d 19 80 	movl   $0x8e000008,-0x7fe6925e(,%eax,8)
801063ae:	08 00 00 8e 
801063b2:	66 89 14 c5 a0 6d 19 	mov    %dx,-0x7fe69260(,%eax,8)
801063b9:	80 
801063ba:	c1 ea 10             	shr    $0x10,%edx
801063bd:	66 89 14 c5 a6 6d 19 	mov    %dx,-0x7fe6925a(,%eax,8)
801063c4:	80 
  for(i = 0; i < 256; i++)
801063c5:	83 c0 01             	add    $0x1,%eax
801063c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801063cd:	75 d1                	jne    801063a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801063cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063d2:	a1 08 c1 10 80       	mov    0x8010c108,%eax
801063d7:	c7 05 a2 6f 19 80 08 	movl   $0xef000008,0x80196fa2
801063de:	00 00 ef 
  initlock(&tickslock, "time");
801063e1:	68 81 94 10 80       	push   $0x80109481
801063e6:	68 60 6d 19 80       	push   $0x80196d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063eb:	66 a3 a0 6f 19 80    	mov    %ax,0x80196fa0
801063f1:	c1 e8 10             	shr    $0x10,%eax
801063f4:	66 a3 a6 6f 19 80    	mov    %ax,0x80196fa6
  initlock(&tickslock, "time");
801063fa:	e8 71 ea ff ff       	call   80104e70 <initlock>
}
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	c9                   	leave  
80106403:	c3                   	ret    
80106404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010640f:	90                   	nop

80106410 <idtinit>:

void
idtinit(void)
{
80106410:	f3 0f 1e fb          	endbr32 
80106414:	55                   	push   %ebp
  pd[0] = size-1;
80106415:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010641a:	89 e5                	mov    %esp,%ebp
8010641c:	83 ec 10             	sub    $0x10,%esp
8010641f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106423:	b8 a0 6d 19 80       	mov    $0x80196da0,%eax
80106428:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010642c:	c1 e8 10             	shr    $0x10,%eax
8010642f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106433:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106436:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106439:	c9                   	leave  
8010643a:	c3                   	ret    
8010643b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010643f:	90                   	nop

80106440 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106440:	f3 0f 1e fb          	endbr32 
80106444:	55                   	push   %ebp
80106445:	89 e5                	mov    %esp,%ebp
80106447:	57                   	push   %edi
80106448:	56                   	push   %esi
80106449:	53                   	push   %ebx
8010644a:	83 ec 1c             	sub    $0x1c,%esp
8010644d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("at trap");
  struct proc* curproc = myproc();
80106450:	e8 eb dd ff ff       	call   80104240 <myproc>
80106455:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
80106457:	8b 43 30             	mov    0x30(%ebx),%eax
8010645a:	83 f8 40             	cmp    $0x40,%eax
8010645d:	0f 84 ed 00 00 00    	je     80106550 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106463:	83 e8 0e             	sub    $0xe,%eax
80106466:	83 f8 31             	cmp    $0x31,%eax
80106469:	77 08                	ja     80106473 <trap+0x33>
8010646b:	3e ff 24 85 28 95 10 	notrack jmp *-0x7fef6ad8(,%eax,4)
80106472:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106473:	e8 c8 dd ff ff       	call   80104240 <myproc>
80106478:	85 c0                	test   %eax,%eax
8010647a:	0f 84 fa 01 00 00    	je     8010667a <trap+0x23a>
80106480:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106484:	0f 84 f0 01 00 00    	je     8010667a <trap+0x23a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010648a:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010648d:	8b 53 38             	mov    0x38(%ebx),%edx
80106490:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106493:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106496:	e8 85 dd ff ff       	call   80104220 <cpuid>
8010649b:	8b 73 30             	mov    0x30(%ebx),%esi
8010649e:	89 c7                	mov    %eax,%edi
801064a0:	8b 43 34             	mov    0x34(%ebx),%eax
801064a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801064a6:	e8 95 dd ff ff       	call   80104240 <myproc>
801064ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
801064ae:	e8 8d dd ff ff       	call   80104240 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064b3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064b9:	51                   	push   %ecx
801064ba:	52                   	push   %edx
801064bb:	57                   	push   %edi
801064bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801064bf:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801064c0:	8b 75 e0             	mov    -0x20(%ebp),%esi
801064c3:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064c6:	56                   	push   %esi
801064c7:	ff 70 10             	pushl  0x10(%eax)
801064ca:	68 e4 94 10 80       	push   $0x801094e4
801064cf:	e8 dc a1 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801064d4:	83 c4 20             	add    $0x20,%esp
801064d7:	e8 64 dd ff ff       	call   80104240 <myproc>
801064dc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064e3:	e8 58 dd ff ff       	call   80104240 <myproc>
801064e8:	85 c0                	test   %eax,%eax
801064ea:	74 1d                	je     80106509 <trap+0xc9>
801064ec:	e8 4f dd ff ff       	call   80104240 <myproc>
801064f1:	8b 50 24             	mov    0x24(%eax),%edx
801064f4:	85 d2                	test   %edx,%edx
801064f6:	74 11                	je     80106509 <trap+0xc9>
801064f8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064fc:	83 e0 03             	and    $0x3,%eax
801064ff:	66 83 f8 03          	cmp    $0x3,%ax
80106503:	0f 84 67 01 00 00    	je     80106670 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106509:	e8 32 dd ff ff       	call   80104240 <myproc>
8010650e:	85 c0                	test   %eax,%eax
80106510:	74 0f                	je     80106521 <trap+0xe1>
80106512:	e8 29 dd ff ff       	call   80104240 <myproc>
80106517:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010651b:	0f 84 1f 01 00 00    	je     80106640 <trap+0x200>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106521:	e8 1a dd ff ff       	call   80104240 <myproc>
80106526:	85 c0                	test   %eax,%eax
80106528:	74 19                	je     80106543 <trap+0x103>
8010652a:	e8 11 dd ff ff       	call   80104240 <myproc>
8010652f:	8b 40 24             	mov    0x24(%eax),%eax
80106532:	85 c0                	test   %eax,%eax
80106534:	74 0d                	je     80106543 <trap+0x103>
80106536:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010653a:	83 e0 03             	and    $0x3,%eax
8010653d:	66 83 f8 03          	cmp    $0x3,%ax
80106541:	74 2c                	je     8010656f <trap+0x12f>
    exit();
80106543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106546:	5b                   	pop    %ebx
80106547:	5e                   	pop    %esi
80106548:	5f                   	pop    %edi
80106549:	5d                   	pop    %ebp
8010654a:	c3                   	ret    
8010654b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010654f:	90                   	nop
    if(curproc->killed)
80106550:	8b 7e 24             	mov    0x24(%esi),%edi
80106553:	85 ff                	test   %edi,%edi
80106555:	0f 85 05 01 00 00    	jne    80106660 <trap+0x220>
    curproc->tf = tf;
8010655b:	89 5e 18             	mov    %ebx,0x18(%esi)
    syscall();
8010655e:	e8 6d ef ff ff       	call   801054d0 <syscall>
    if(myproc()->killed)
80106563:	e8 d8 dc ff ff       	call   80104240 <myproc>
80106568:	8b 58 24             	mov    0x24(%eax),%ebx
8010656b:	85 db                	test   %ebx,%ebx
8010656d:	74 d4                	je     80106543 <trap+0x103>
8010656f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106572:	5b                   	pop    %ebx
80106573:	5e                   	pop    %esi
80106574:	5f                   	pop    %edi
80106575:	5d                   	pop    %ebp
      exit();
80106576:	e9 e5 e1 ff ff       	jmp    80104760 <exit>
    ideintr();
8010657b:	e8 70 c2 ff ff       	call   801027f0 <ideintr>
    lapiceoi();
80106580:	e8 fb cb ff ff       	call   80103180 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106585:	e8 b6 dc ff ff       	call   80104240 <myproc>
8010658a:	85 c0                	test   %eax,%eax
8010658c:	0f 85 5a ff ff ff    	jne    801064ec <trap+0xac>
80106592:	e9 72 ff ff ff       	jmp    80106509 <trap+0xc9>
    if(myproc()->pid > 2) 
80106597:	e8 a4 dc ff ff       	call   80104240 <myproc>
8010659c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801065a0:	0f 8e 3d ff ff ff    	jle    801064e3 <trap+0xa3>
    pagefault();
801065a6:	e8 75 1d 00 00       	call   80108320 <pagefault>
    if(curproc->killed) 
801065ab:	8b 4e 24             	mov    0x24(%esi),%ecx
801065ae:	85 c9                	test   %ecx,%ecx
801065b0:	0f 84 2d ff ff ff    	je     801064e3 <trap+0xa3>
        exit();
801065b6:	e8 a5 e1 ff ff       	call   80104760 <exit>
801065bb:	e9 23 ff ff ff       	jmp    801064e3 <trap+0xa3>
    if(cpuid() == 0){
801065c0:	e8 5b dc ff ff       	call   80104220 <cpuid>
801065c5:	85 c0                	test   %eax,%eax
801065c7:	75 b7                	jne    80106580 <trap+0x140>
      acquire(&tickslock);
801065c9:	83 ec 0c             	sub    $0xc,%esp
801065cc:	68 60 6d 19 80       	push   $0x80196d60
801065d1:	e8 1a ea ff ff       	call   80104ff0 <acquire>
      wakeup(&ticks);
801065d6:	c7 04 24 a0 75 19 80 	movl   $0x801975a0,(%esp)
      ticks++;
801065dd:	83 05 a0 75 19 80 01 	addl   $0x1,0x801975a0
      wakeup(&ticks);
801065e4:	e8 17 e5 ff ff       	call   80104b00 <wakeup>
      release(&tickslock);
801065e9:	c7 04 24 60 6d 19 80 	movl   $0x80196d60,(%esp)
801065f0:	e8 bb ea ff ff       	call   801050b0 <release>
801065f5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065f8:	eb 86                	jmp    80106580 <trap+0x140>
    kbdintr();
801065fa:	e8 41 ca ff ff       	call   80103040 <kbdintr>
    lapiceoi();
801065ff:	e8 7c cb ff ff       	call   80103180 <lapiceoi>
    break;
80106604:	e9 da fe ff ff       	jmp    801064e3 <trap+0xa3>
    uartintr();
80106609:	e8 12 02 00 00       	call   80106820 <uartintr>
    lapiceoi();
8010660e:	e8 6d cb ff ff       	call   80103180 <lapiceoi>
    break;
80106613:	e9 cb fe ff ff       	jmp    801064e3 <trap+0xa3>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106618:	8b 7b 38             	mov    0x38(%ebx),%edi
8010661b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010661f:	e8 fc db ff ff       	call   80104220 <cpuid>
80106624:	57                   	push   %edi
80106625:	56                   	push   %esi
80106626:	50                   	push   %eax
80106627:	68 8c 94 10 80       	push   $0x8010948c
8010662c:	e8 7f a0 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106631:	e8 4a cb ff ff       	call   80103180 <lapiceoi>
    break;
80106636:	83 c4 10             	add    $0x10,%esp
80106639:	e9 a5 fe ff ff       	jmp    801064e3 <trap+0xa3>
8010663e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80106640:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106644:	0f 85 d7 fe ff ff    	jne    80106521 <trap+0xe1>
      if(myproc()->pid > 2) 
8010664a:	e8 f1 db ff ff       	call   80104240 <myproc>
      yield();
8010664f:	e8 4c e2 ff ff       	call   801048a0 <yield>
80106654:	e9 c8 fe ff ff       	jmp    80106521 <trap+0xe1>
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exit();
80106660:	e8 fb e0 ff ff       	call   80104760 <exit>
80106665:	e9 f1 fe ff ff       	jmp    8010655b <trap+0x11b>
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106670:	e8 eb e0 ff ff       	call   80104760 <exit>
80106675:	e9 8f fe ff ff       	jmp    80106509 <trap+0xc9>
8010667a:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010667d:	8b 73 38             	mov    0x38(%ebx),%esi
80106680:	e8 9b db ff ff       	call   80104220 <cpuid>
80106685:	83 ec 0c             	sub    $0xc,%esp
80106688:	57                   	push   %edi
80106689:	56                   	push   %esi
8010668a:	50                   	push   %eax
8010668b:	ff 73 30             	pushl  0x30(%ebx)
8010668e:	68 b0 94 10 80       	push   $0x801094b0
80106693:	e8 18 a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106698:	83 c4 14             	add    $0x14,%esp
8010669b:	68 86 94 10 80       	push   $0x80109486
801066a0:	e8 eb 9c ff ff       	call   80100390 <panic>
801066a5:	66 90                	xchg   %ax,%ax
801066a7:	66 90                	xchg   %ax,%ax
801066a9:	66 90                	xchg   %ax,%ax
801066ab:	66 90                	xchg   %ax,%ax
801066ad:	66 90                	xchg   %ax,%ax
801066af:	90                   	nop

801066b0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801066b0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801066b4:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
801066b9:	85 c0                	test   %eax,%eax
801066bb:	74 1b                	je     801066d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066bd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066c2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801066c3:	a8 01                	test   $0x1,%al
801066c5:	74 11                	je     801066d8 <uartgetc+0x28>
801066c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066cc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801066cd:	0f b6 c0             	movzbl %al,%eax
801066d0:	c3                   	ret    
801066d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066dd:	c3                   	ret    
801066de:	66 90                	xchg   %ax,%ax

801066e0 <uartputc.part.0>:
uartputc(int c)
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	89 c7                	mov    %eax,%edi
801066e6:	56                   	push   %esi
801066e7:	be fd 03 00 00       	mov    $0x3fd,%esi
801066ec:	53                   	push   %ebx
801066ed:	bb 80 00 00 00       	mov    $0x80,%ebx
801066f2:	83 ec 0c             	sub    $0xc,%esp
801066f5:	eb 1b                	jmp    80106712 <uartputc.part.0+0x32>
801066f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066fe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106700:	83 ec 0c             	sub    $0xc,%esp
80106703:	6a 0a                	push   $0xa
80106705:	e8 96 ca ff ff       	call   801031a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	83 eb 01             	sub    $0x1,%ebx
80106710:	74 07                	je     80106719 <uartputc.part.0+0x39>
80106712:	89 f2                	mov    %esi,%edx
80106714:	ec                   	in     (%dx),%al
80106715:	a8 20                	test   $0x20,%al
80106717:	74 e7                	je     80106700 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106719:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010671e:	89 f8                	mov    %edi,%eax
80106720:	ee                   	out    %al,(%dx)
}
80106721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106724:	5b                   	pop    %ebx
80106725:	5e                   	pop    %esi
80106726:	5f                   	pop    %edi
80106727:	5d                   	pop    %ebp
80106728:	c3                   	ret    
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106730 <uartinit>:
{
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	31 c9                	xor    %ecx,%ecx
80106737:	89 c8                	mov    %ecx,%eax
80106739:	89 e5                	mov    %esp,%ebp
8010673b:	57                   	push   %edi
8010673c:	56                   	push   %esi
8010673d:	53                   	push   %ebx
8010673e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106743:	89 da                	mov    %ebx,%edx
80106745:	83 ec 0c             	sub    $0xc,%esp
80106748:	ee                   	out    %al,(%dx)
80106749:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010674e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106753:	89 fa                	mov    %edi,%edx
80106755:	ee                   	out    %al,(%dx)
80106756:	b8 0c 00 00 00       	mov    $0xc,%eax
8010675b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106760:	ee                   	out    %al,(%dx)
80106761:	be f9 03 00 00       	mov    $0x3f9,%esi
80106766:	89 c8                	mov    %ecx,%eax
80106768:	89 f2                	mov    %esi,%edx
8010676a:	ee                   	out    %al,(%dx)
8010676b:	b8 03 00 00 00       	mov    $0x3,%eax
80106770:	89 fa                	mov    %edi,%edx
80106772:	ee                   	out    %al,(%dx)
80106773:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106778:	89 c8                	mov    %ecx,%eax
8010677a:	ee                   	out    %al,(%dx)
8010677b:	b8 01 00 00 00       	mov    $0x1,%eax
80106780:	89 f2                	mov    %esi,%edx
80106782:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106783:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106788:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106789:	3c ff                	cmp    $0xff,%al
8010678b:	74 52                	je     801067df <uartinit+0xaf>
  uart = 1;
8010678d:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
80106794:	00 00 00 
80106797:	89 da                	mov    %ebx,%edx
80106799:	ec                   	in     (%dx),%al
8010679a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010679f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801067a0:	83 ec 08             	sub    $0x8,%esp
801067a3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801067a8:	bb f0 95 10 80       	mov    $0x801095f0,%ebx
  ioapicenable(IRQ_COM1, 0);
801067ad:	6a 00                	push   $0x0
801067af:	6a 04                	push   $0x4
801067b1:	e8 8a c2 ff ff       	call   80102a40 <ioapicenable>
801067b6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801067b9:	b8 78 00 00 00       	mov    $0x78,%eax
801067be:	eb 04                	jmp    801067c4 <uartinit+0x94>
801067c0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801067c4:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
801067ca:	85 d2                	test   %edx,%edx
801067cc:	74 08                	je     801067d6 <uartinit+0xa6>
    uartputc(*p);
801067ce:	0f be c0             	movsbl %al,%eax
801067d1:	e8 0a ff ff ff       	call   801066e0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801067d6:	89 f0                	mov    %esi,%eax
801067d8:	83 c3 01             	add    $0x1,%ebx
801067db:	84 c0                	test   %al,%al
801067dd:	75 e1                	jne    801067c0 <uartinit+0x90>
}
801067df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067e2:	5b                   	pop    %ebx
801067e3:	5e                   	pop    %esi
801067e4:	5f                   	pop    %edi
801067e5:	5d                   	pop    %ebp
801067e6:	c3                   	ret    
801067e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ee:	66 90                	xchg   %ax,%ax

801067f0 <uartputc>:
{
801067f0:	f3 0f 1e fb          	endbr32 
801067f4:	55                   	push   %ebp
  if(!uart)
801067f5:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
{
801067fb:	89 e5                	mov    %esp,%ebp
801067fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106800:	85 d2                	test   %edx,%edx
80106802:	74 0c                	je     80106810 <uartputc+0x20>
}
80106804:	5d                   	pop    %ebp
80106805:	e9 d6 fe ff ff       	jmp    801066e0 <uartputc.part.0>
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106810:	5d                   	pop    %ebp
80106811:	c3                   	ret    
80106812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106820 <uartintr>:

void
uartintr(void)
{
80106820:	f3 0f 1e fb          	endbr32 
80106824:	55                   	push   %ebp
80106825:	89 e5                	mov    %esp,%ebp
80106827:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010682a:	68 b0 66 10 80       	push   $0x801066b0
8010682f:	e8 2c a0 ff ff       	call   80100860 <consoleintr>
}
80106834:	83 c4 10             	add    $0x10,%esp
80106837:	c9                   	leave  
80106838:	c3                   	ret    

80106839 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $0
8010683b:	6a 00                	push   $0x0
  jmp alltraps
8010683d:	e9 25 fb ff ff       	jmp    80106367 <alltraps>

80106842 <vector1>:
.globl vector1
vector1:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $1
80106844:	6a 01                	push   $0x1
  jmp alltraps
80106846:	e9 1c fb ff ff       	jmp    80106367 <alltraps>

8010684b <vector2>:
.globl vector2
vector2:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $2
8010684d:	6a 02                	push   $0x2
  jmp alltraps
8010684f:	e9 13 fb ff ff       	jmp    80106367 <alltraps>

80106854 <vector3>:
.globl vector3
vector3:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $3
80106856:	6a 03                	push   $0x3
  jmp alltraps
80106858:	e9 0a fb ff ff       	jmp    80106367 <alltraps>

8010685d <vector4>:
.globl vector4
vector4:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $4
8010685f:	6a 04                	push   $0x4
  jmp alltraps
80106861:	e9 01 fb ff ff       	jmp    80106367 <alltraps>

80106866 <vector5>:
.globl vector5
vector5:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $5
80106868:	6a 05                	push   $0x5
  jmp alltraps
8010686a:	e9 f8 fa ff ff       	jmp    80106367 <alltraps>

8010686f <vector6>:
.globl vector6
vector6:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $6
80106871:	6a 06                	push   $0x6
  jmp alltraps
80106873:	e9 ef fa ff ff       	jmp    80106367 <alltraps>

80106878 <vector7>:
.globl vector7
vector7:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $7
8010687a:	6a 07                	push   $0x7
  jmp alltraps
8010687c:	e9 e6 fa ff ff       	jmp    80106367 <alltraps>

80106881 <vector8>:
.globl vector8
vector8:
  pushl $8
80106881:	6a 08                	push   $0x8
  jmp alltraps
80106883:	e9 df fa ff ff       	jmp    80106367 <alltraps>

80106888 <vector9>:
.globl vector9
vector9:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $9
8010688a:	6a 09                	push   $0x9
  jmp alltraps
8010688c:	e9 d6 fa ff ff       	jmp    80106367 <alltraps>

80106891 <vector10>:
.globl vector10
vector10:
  pushl $10
80106891:	6a 0a                	push   $0xa
  jmp alltraps
80106893:	e9 cf fa ff ff       	jmp    80106367 <alltraps>

80106898 <vector11>:
.globl vector11
vector11:
  pushl $11
80106898:	6a 0b                	push   $0xb
  jmp alltraps
8010689a:	e9 c8 fa ff ff       	jmp    80106367 <alltraps>

8010689f <vector12>:
.globl vector12
vector12:
  pushl $12
8010689f:	6a 0c                	push   $0xc
  jmp alltraps
801068a1:	e9 c1 fa ff ff       	jmp    80106367 <alltraps>

801068a6 <vector13>:
.globl vector13
vector13:
  pushl $13
801068a6:	6a 0d                	push   $0xd
  jmp alltraps
801068a8:	e9 ba fa ff ff       	jmp    80106367 <alltraps>

801068ad <vector14>:
.globl vector14
vector14:
  pushl $14
801068ad:	6a 0e                	push   $0xe
  jmp alltraps
801068af:	e9 b3 fa ff ff       	jmp    80106367 <alltraps>

801068b4 <vector15>:
.globl vector15
vector15:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $15
801068b6:	6a 0f                	push   $0xf
  jmp alltraps
801068b8:	e9 aa fa ff ff       	jmp    80106367 <alltraps>

801068bd <vector16>:
.globl vector16
vector16:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $16
801068bf:	6a 10                	push   $0x10
  jmp alltraps
801068c1:	e9 a1 fa ff ff       	jmp    80106367 <alltraps>

801068c6 <vector17>:
.globl vector17
vector17:
  pushl $17
801068c6:	6a 11                	push   $0x11
  jmp alltraps
801068c8:	e9 9a fa ff ff       	jmp    80106367 <alltraps>

801068cd <vector18>:
.globl vector18
vector18:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $18
801068cf:	6a 12                	push   $0x12
  jmp alltraps
801068d1:	e9 91 fa ff ff       	jmp    80106367 <alltraps>

801068d6 <vector19>:
.globl vector19
vector19:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $19
801068d8:	6a 13                	push   $0x13
  jmp alltraps
801068da:	e9 88 fa ff ff       	jmp    80106367 <alltraps>

801068df <vector20>:
.globl vector20
vector20:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $20
801068e1:	6a 14                	push   $0x14
  jmp alltraps
801068e3:	e9 7f fa ff ff       	jmp    80106367 <alltraps>

801068e8 <vector21>:
.globl vector21
vector21:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $21
801068ea:	6a 15                	push   $0x15
  jmp alltraps
801068ec:	e9 76 fa ff ff       	jmp    80106367 <alltraps>

801068f1 <vector22>:
.globl vector22
vector22:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $22
801068f3:	6a 16                	push   $0x16
  jmp alltraps
801068f5:	e9 6d fa ff ff       	jmp    80106367 <alltraps>

801068fa <vector23>:
.globl vector23
vector23:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $23
801068fc:	6a 17                	push   $0x17
  jmp alltraps
801068fe:	e9 64 fa ff ff       	jmp    80106367 <alltraps>

80106903 <vector24>:
.globl vector24
vector24:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $24
80106905:	6a 18                	push   $0x18
  jmp alltraps
80106907:	e9 5b fa ff ff       	jmp    80106367 <alltraps>

8010690c <vector25>:
.globl vector25
vector25:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $25
8010690e:	6a 19                	push   $0x19
  jmp alltraps
80106910:	e9 52 fa ff ff       	jmp    80106367 <alltraps>

80106915 <vector26>:
.globl vector26
vector26:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $26
80106917:	6a 1a                	push   $0x1a
  jmp alltraps
80106919:	e9 49 fa ff ff       	jmp    80106367 <alltraps>

8010691e <vector27>:
.globl vector27
vector27:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $27
80106920:	6a 1b                	push   $0x1b
  jmp alltraps
80106922:	e9 40 fa ff ff       	jmp    80106367 <alltraps>

80106927 <vector28>:
.globl vector28
vector28:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $28
80106929:	6a 1c                	push   $0x1c
  jmp alltraps
8010692b:	e9 37 fa ff ff       	jmp    80106367 <alltraps>

80106930 <vector29>:
.globl vector29
vector29:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $29
80106932:	6a 1d                	push   $0x1d
  jmp alltraps
80106934:	e9 2e fa ff ff       	jmp    80106367 <alltraps>

80106939 <vector30>:
.globl vector30
vector30:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $30
8010693b:	6a 1e                	push   $0x1e
  jmp alltraps
8010693d:	e9 25 fa ff ff       	jmp    80106367 <alltraps>

80106942 <vector31>:
.globl vector31
vector31:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $31
80106944:	6a 1f                	push   $0x1f
  jmp alltraps
80106946:	e9 1c fa ff ff       	jmp    80106367 <alltraps>

8010694b <vector32>:
.globl vector32
vector32:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $32
8010694d:	6a 20                	push   $0x20
  jmp alltraps
8010694f:	e9 13 fa ff ff       	jmp    80106367 <alltraps>

80106954 <vector33>:
.globl vector33
vector33:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $33
80106956:	6a 21                	push   $0x21
  jmp alltraps
80106958:	e9 0a fa ff ff       	jmp    80106367 <alltraps>

8010695d <vector34>:
.globl vector34
vector34:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $34
8010695f:	6a 22                	push   $0x22
  jmp alltraps
80106961:	e9 01 fa ff ff       	jmp    80106367 <alltraps>

80106966 <vector35>:
.globl vector35
vector35:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $35
80106968:	6a 23                	push   $0x23
  jmp alltraps
8010696a:	e9 f8 f9 ff ff       	jmp    80106367 <alltraps>

8010696f <vector36>:
.globl vector36
vector36:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $36
80106971:	6a 24                	push   $0x24
  jmp alltraps
80106973:	e9 ef f9 ff ff       	jmp    80106367 <alltraps>

80106978 <vector37>:
.globl vector37
vector37:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $37
8010697a:	6a 25                	push   $0x25
  jmp alltraps
8010697c:	e9 e6 f9 ff ff       	jmp    80106367 <alltraps>

80106981 <vector38>:
.globl vector38
vector38:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $38
80106983:	6a 26                	push   $0x26
  jmp alltraps
80106985:	e9 dd f9 ff ff       	jmp    80106367 <alltraps>

8010698a <vector39>:
.globl vector39
vector39:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $39
8010698c:	6a 27                	push   $0x27
  jmp alltraps
8010698e:	e9 d4 f9 ff ff       	jmp    80106367 <alltraps>

80106993 <vector40>:
.globl vector40
vector40:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $40
80106995:	6a 28                	push   $0x28
  jmp alltraps
80106997:	e9 cb f9 ff ff       	jmp    80106367 <alltraps>

8010699c <vector41>:
.globl vector41
vector41:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $41
8010699e:	6a 29                	push   $0x29
  jmp alltraps
801069a0:	e9 c2 f9 ff ff       	jmp    80106367 <alltraps>

801069a5 <vector42>:
.globl vector42
vector42:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $42
801069a7:	6a 2a                	push   $0x2a
  jmp alltraps
801069a9:	e9 b9 f9 ff ff       	jmp    80106367 <alltraps>

801069ae <vector43>:
.globl vector43
vector43:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $43
801069b0:	6a 2b                	push   $0x2b
  jmp alltraps
801069b2:	e9 b0 f9 ff ff       	jmp    80106367 <alltraps>

801069b7 <vector44>:
.globl vector44
vector44:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $44
801069b9:	6a 2c                	push   $0x2c
  jmp alltraps
801069bb:	e9 a7 f9 ff ff       	jmp    80106367 <alltraps>

801069c0 <vector45>:
.globl vector45
vector45:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $45
801069c2:	6a 2d                	push   $0x2d
  jmp alltraps
801069c4:	e9 9e f9 ff ff       	jmp    80106367 <alltraps>

801069c9 <vector46>:
.globl vector46
vector46:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $46
801069cb:	6a 2e                	push   $0x2e
  jmp alltraps
801069cd:	e9 95 f9 ff ff       	jmp    80106367 <alltraps>

801069d2 <vector47>:
.globl vector47
vector47:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $47
801069d4:	6a 2f                	push   $0x2f
  jmp alltraps
801069d6:	e9 8c f9 ff ff       	jmp    80106367 <alltraps>

801069db <vector48>:
.globl vector48
vector48:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $48
801069dd:	6a 30                	push   $0x30
  jmp alltraps
801069df:	e9 83 f9 ff ff       	jmp    80106367 <alltraps>

801069e4 <vector49>:
.globl vector49
vector49:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $49
801069e6:	6a 31                	push   $0x31
  jmp alltraps
801069e8:	e9 7a f9 ff ff       	jmp    80106367 <alltraps>

801069ed <vector50>:
.globl vector50
vector50:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $50
801069ef:	6a 32                	push   $0x32
  jmp alltraps
801069f1:	e9 71 f9 ff ff       	jmp    80106367 <alltraps>

801069f6 <vector51>:
.globl vector51
vector51:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $51
801069f8:	6a 33                	push   $0x33
  jmp alltraps
801069fa:	e9 68 f9 ff ff       	jmp    80106367 <alltraps>

801069ff <vector52>:
.globl vector52
vector52:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $52
80106a01:	6a 34                	push   $0x34
  jmp alltraps
80106a03:	e9 5f f9 ff ff       	jmp    80106367 <alltraps>

80106a08 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $53
80106a0a:	6a 35                	push   $0x35
  jmp alltraps
80106a0c:	e9 56 f9 ff ff       	jmp    80106367 <alltraps>

80106a11 <vector54>:
.globl vector54
vector54:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $54
80106a13:	6a 36                	push   $0x36
  jmp alltraps
80106a15:	e9 4d f9 ff ff       	jmp    80106367 <alltraps>

80106a1a <vector55>:
.globl vector55
vector55:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $55
80106a1c:	6a 37                	push   $0x37
  jmp alltraps
80106a1e:	e9 44 f9 ff ff       	jmp    80106367 <alltraps>

80106a23 <vector56>:
.globl vector56
vector56:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $56
80106a25:	6a 38                	push   $0x38
  jmp alltraps
80106a27:	e9 3b f9 ff ff       	jmp    80106367 <alltraps>

80106a2c <vector57>:
.globl vector57
vector57:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $57
80106a2e:	6a 39                	push   $0x39
  jmp alltraps
80106a30:	e9 32 f9 ff ff       	jmp    80106367 <alltraps>

80106a35 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $58
80106a37:	6a 3a                	push   $0x3a
  jmp alltraps
80106a39:	e9 29 f9 ff ff       	jmp    80106367 <alltraps>

80106a3e <vector59>:
.globl vector59
vector59:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $59
80106a40:	6a 3b                	push   $0x3b
  jmp alltraps
80106a42:	e9 20 f9 ff ff       	jmp    80106367 <alltraps>

80106a47 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $60
80106a49:	6a 3c                	push   $0x3c
  jmp alltraps
80106a4b:	e9 17 f9 ff ff       	jmp    80106367 <alltraps>

80106a50 <vector61>:
.globl vector61
vector61:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $61
80106a52:	6a 3d                	push   $0x3d
  jmp alltraps
80106a54:	e9 0e f9 ff ff       	jmp    80106367 <alltraps>

80106a59 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $62
80106a5b:	6a 3e                	push   $0x3e
  jmp alltraps
80106a5d:	e9 05 f9 ff ff       	jmp    80106367 <alltraps>

80106a62 <vector63>:
.globl vector63
vector63:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $63
80106a64:	6a 3f                	push   $0x3f
  jmp alltraps
80106a66:	e9 fc f8 ff ff       	jmp    80106367 <alltraps>

80106a6b <vector64>:
.globl vector64
vector64:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $64
80106a6d:	6a 40                	push   $0x40
  jmp alltraps
80106a6f:	e9 f3 f8 ff ff       	jmp    80106367 <alltraps>

80106a74 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $65
80106a76:	6a 41                	push   $0x41
  jmp alltraps
80106a78:	e9 ea f8 ff ff       	jmp    80106367 <alltraps>

80106a7d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $66
80106a7f:	6a 42                	push   $0x42
  jmp alltraps
80106a81:	e9 e1 f8 ff ff       	jmp    80106367 <alltraps>

80106a86 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $67
80106a88:	6a 43                	push   $0x43
  jmp alltraps
80106a8a:	e9 d8 f8 ff ff       	jmp    80106367 <alltraps>

80106a8f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $68
80106a91:	6a 44                	push   $0x44
  jmp alltraps
80106a93:	e9 cf f8 ff ff       	jmp    80106367 <alltraps>

80106a98 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $69
80106a9a:	6a 45                	push   $0x45
  jmp alltraps
80106a9c:	e9 c6 f8 ff ff       	jmp    80106367 <alltraps>

80106aa1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $70
80106aa3:	6a 46                	push   $0x46
  jmp alltraps
80106aa5:	e9 bd f8 ff ff       	jmp    80106367 <alltraps>

80106aaa <vector71>:
.globl vector71
vector71:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $71
80106aac:	6a 47                	push   $0x47
  jmp alltraps
80106aae:	e9 b4 f8 ff ff       	jmp    80106367 <alltraps>

80106ab3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $72
80106ab5:	6a 48                	push   $0x48
  jmp alltraps
80106ab7:	e9 ab f8 ff ff       	jmp    80106367 <alltraps>

80106abc <vector73>:
.globl vector73
vector73:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $73
80106abe:	6a 49                	push   $0x49
  jmp alltraps
80106ac0:	e9 a2 f8 ff ff       	jmp    80106367 <alltraps>

80106ac5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $74
80106ac7:	6a 4a                	push   $0x4a
  jmp alltraps
80106ac9:	e9 99 f8 ff ff       	jmp    80106367 <alltraps>

80106ace <vector75>:
.globl vector75
vector75:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $75
80106ad0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ad2:	e9 90 f8 ff ff       	jmp    80106367 <alltraps>

80106ad7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $76
80106ad9:	6a 4c                	push   $0x4c
  jmp alltraps
80106adb:	e9 87 f8 ff ff       	jmp    80106367 <alltraps>

80106ae0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $77
80106ae2:	6a 4d                	push   $0x4d
  jmp alltraps
80106ae4:	e9 7e f8 ff ff       	jmp    80106367 <alltraps>

80106ae9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $78
80106aeb:	6a 4e                	push   $0x4e
  jmp alltraps
80106aed:	e9 75 f8 ff ff       	jmp    80106367 <alltraps>

80106af2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106af2:	6a 00                	push   $0x0
  pushl $79
80106af4:	6a 4f                	push   $0x4f
  jmp alltraps
80106af6:	e9 6c f8 ff ff       	jmp    80106367 <alltraps>

80106afb <vector80>:
.globl vector80
vector80:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $80
80106afd:	6a 50                	push   $0x50
  jmp alltraps
80106aff:	e9 63 f8 ff ff       	jmp    80106367 <alltraps>

80106b04 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b04:	6a 00                	push   $0x0
  pushl $81
80106b06:	6a 51                	push   $0x51
  jmp alltraps
80106b08:	e9 5a f8 ff ff       	jmp    80106367 <alltraps>

80106b0d <vector82>:
.globl vector82
vector82:
  pushl $0
80106b0d:	6a 00                	push   $0x0
  pushl $82
80106b0f:	6a 52                	push   $0x52
  jmp alltraps
80106b11:	e9 51 f8 ff ff       	jmp    80106367 <alltraps>

80106b16 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b16:	6a 00                	push   $0x0
  pushl $83
80106b18:	6a 53                	push   $0x53
  jmp alltraps
80106b1a:	e9 48 f8 ff ff       	jmp    80106367 <alltraps>

80106b1f <vector84>:
.globl vector84
vector84:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $84
80106b21:	6a 54                	push   $0x54
  jmp alltraps
80106b23:	e9 3f f8 ff ff       	jmp    80106367 <alltraps>

80106b28 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $85
80106b2a:	6a 55                	push   $0x55
  jmp alltraps
80106b2c:	e9 36 f8 ff ff       	jmp    80106367 <alltraps>

80106b31 <vector86>:
.globl vector86
vector86:
  pushl $0
80106b31:	6a 00                	push   $0x0
  pushl $86
80106b33:	6a 56                	push   $0x56
  jmp alltraps
80106b35:	e9 2d f8 ff ff       	jmp    80106367 <alltraps>

80106b3a <vector87>:
.globl vector87
vector87:
  pushl $0
80106b3a:	6a 00                	push   $0x0
  pushl $87
80106b3c:	6a 57                	push   $0x57
  jmp alltraps
80106b3e:	e9 24 f8 ff ff       	jmp    80106367 <alltraps>

80106b43 <vector88>:
.globl vector88
vector88:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $88
80106b45:	6a 58                	push   $0x58
  jmp alltraps
80106b47:	e9 1b f8 ff ff       	jmp    80106367 <alltraps>

80106b4c <vector89>:
.globl vector89
vector89:
  pushl $0
80106b4c:	6a 00                	push   $0x0
  pushl $89
80106b4e:	6a 59                	push   $0x59
  jmp alltraps
80106b50:	e9 12 f8 ff ff       	jmp    80106367 <alltraps>

80106b55 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b55:	6a 00                	push   $0x0
  pushl $90
80106b57:	6a 5a                	push   $0x5a
  jmp alltraps
80106b59:	e9 09 f8 ff ff       	jmp    80106367 <alltraps>

80106b5e <vector91>:
.globl vector91
vector91:
  pushl $0
80106b5e:	6a 00                	push   $0x0
  pushl $91
80106b60:	6a 5b                	push   $0x5b
  jmp alltraps
80106b62:	e9 00 f8 ff ff       	jmp    80106367 <alltraps>

80106b67 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $92
80106b69:	6a 5c                	push   $0x5c
  jmp alltraps
80106b6b:	e9 f7 f7 ff ff       	jmp    80106367 <alltraps>

80106b70 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b70:	6a 00                	push   $0x0
  pushl $93
80106b72:	6a 5d                	push   $0x5d
  jmp alltraps
80106b74:	e9 ee f7 ff ff       	jmp    80106367 <alltraps>

80106b79 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $94
80106b7b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b7d:	e9 e5 f7 ff ff       	jmp    80106367 <alltraps>

80106b82 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $95
80106b84:	6a 5f                	push   $0x5f
  jmp alltraps
80106b86:	e9 dc f7 ff ff       	jmp    80106367 <alltraps>

80106b8b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $96
80106b8d:	6a 60                	push   $0x60
  jmp alltraps
80106b8f:	e9 d3 f7 ff ff       	jmp    80106367 <alltraps>

80106b94 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b94:	6a 00                	push   $0x0
  pushl $97
80106b96:	6a 61                	push   $0x61
  jmp alltraps
80106b98:	e9 ca f7 ff ff       	jmp    80106367 <alltraps>

80106b9d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b9d:	6a 00                	push   $0x0
  pushl $98
80106b9f:	6a 62                	push   $0x62
  jmp alltraps
80106ba1:	e9 c1 f7 ff ff       	jmp    80106367 <alltraps>

80106ba6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ba6:	6a 00                	push   $0x0
  pushl $99
80106ba8:	6a 63                	push   $0x63
  jmp alltraps
80106baa:	e9 b8 f7 ff ff       	jmp    80106367 <alltraps>

80106baf <vector100>:
.globl vector100
vector100:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $100
80106bb1:	6a 64                	push   $0x64
  jmp alltraps
80106bb3:	e9 af f7 ff ff       	jmp    80106367 <alltraps>

80106bb8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106bb8:	6a 00                	push   $0x0
  pushl $101
80106bba:	6a 65                	push   $0x65
  jmp alltraps
80106bbc:	e9 a6 f7 ff ff       	jmp    80106367 <alltraps>

80106bc1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106bc1:	6a 00                	push   $0x0
  pushl $102
80106bc3:	6a 66                	push   $0x66
  jmp alltraps
80106bc5:	e9 9d f7 ff ff       	jmp    80106367 <alltraps>

80106bca <vector103>:
.globl vector103
vector103:
  pushl $0
80106bca:	6a 00                	push   $0x0
  pushl $103
80106bcc:	6a 67                	push   $0x67
  jmp alltraps
80106bce:	e9 94 f7 ff ff       	jmp    80106367 <alltraps>

80106bd3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $104
80106bd5:	6a 68                	push   $0x68
  jmp alltraps
80106bd7:	e9 8b f7 ff ff       	jmp    80106367 <alltraps>

80106bdc <vector105>:
.globl vector105
vector105:
  pushl $0
80106bdc:	6a 00                	push   $0x0
  pushl $105
80106bde:	6a 69                	push   $0x69
  jmp alltraps
80106be0:	e9 82 f7 ff ff       	jmp    80106367 <alltraps>

80106be5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106be5:	6a 00                	push   $0x0
  pushl $106
80106be7:	6a 6a                	push   $0x6a
  jmp alltraps
80106be9:	e9 79 f7 ff ff       	jmp    80106367 <alltraps>

80106bee <vector107>:
.globl vector107
vector107:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $107
80106bf0:	6a 6b                	push   $0x6b
  jmp alltraps
80106bf2:	e9 70 f7 ff ff       	jmp    80106367 <alltraps>

80106bf7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $108
80106bf9:	6a 6c                	push   $0x6c
  jmp alltraps
80106bfb:	e9 67 f7 ff ff       	jmp    80106367 <alltraps>

80106c00 <vector109>:
.globl vector109
vector109:
  pushl $0
80106c00:	6a 00                	push   $0x0
  pushl $109
80106c02:	6a 6d                	push   $0x6d
  jmp alltraps
80106c04:	e9 5e f7 ff ff       	jmp    80106367 <alltraps>

80106c09 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c09:	6a 00                	push   $0x0
  pushl $110
80106c0b:	6a 6e                	push   $0x6e
  jmp alltraps
80106c0d:	e9 55 f7 ff ff       	jmp    80106367 <alltraps>

80106c12 <vector111>:
.globl vector111
vector111:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $111
80106c14:	6a 6f                	push   $0x6f
  jmp alltraps
80106c16:	e9 4c f7 ff ff       	jmp    80106367 <alltraps>

80106c1b <vector112>:
.globl vector112
vector112:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $112
80106c1d:	6a 70                	push   $0x70
  jmp alltraps
80106c1f:	e9 43 f7 ff ff       	jmp    80106367 <alltraps>

80106c24 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c24:	6a 00                	push   $0x0
  pushl $113
80106c26:	6a 71                	push   $0x71
  jmp alltraps
80106c28:	e9 3a f7 ff ff       	jmp    80106367 <alltraps>

80106c2d <vector114>:
.globl vector114
vector114:
  pushl $0
80106c2d:	6a 00                	push   $0x0
  pushl $114
80106c2f:	6a 72                	push   $0x72
  jmp alltraps
80106c31:	e9 31 f7 ff ff       	jmp    80106367 <alltraps>

80106c36 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c36:	6a 00                	push   $0x0
  pushl $115
80106c38:	6a 73                	push   $0x73
  jmp alltraps
80106c3a:	e9 28 f7 ff ff       	jmp    80106367 <alltraps>

80106c3f <vector116>:
.globl vector116
vector116:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $116
80106c41:	6a 74                	push   $0x74
  jmp alltraps
80106c43:	e9 1f f7 ff ff       	jmp    80106367 <alltraps>

80106c48 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c48:	6a 00                	push   $0x0
  pushl $117
80106c4a:	6a 75                	push   $0x75
  jmp alltraps
80106c4c:	e9 16 f7 ff ff       	jmp    80106367 <alltraps>

80106c51 <vector118>:
.globl vector118
vector118:
  pushl $0
80106c51:	6a 00                	push   $0x0
  pushl $118
80106c53:	6a 76                	push   $0x76
  jmp alltraps
80106c55:	e9 0d f7 ff ff       	jmp    80106367 <alltraps>

80106c5a <vector119>:
.globl vector119
vector119:
  pushl $0
80106c5a:	6a 00                	push   $0x0
  pushl $119
80106c5c:	6a 77                	push   $0x77
  jmp alltraps
80106c5e:	e9 04 f7 ff ff       	jmp    80106367 <alltraps>

80106c63 <vector120>:
.globl vector120
vector120:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $120
80106c65:	6a 78                	push   $0x78
  jmp alltraps
80106c67:	e9 fb f6 ff ff       	jmp    80106367 <alltraps>

80106c6c <vector121>:
.globl vector121
vector121:
  pushl $0
80106c6c:	6a 00                	push   $0x0
  pushl $121
80106c6e:	6a 79                	push   $0x79
  jmp alltraps
80106c70:	e9 f2 f6 ff ff       	jmp    80106367 <alltraps>

80106c75 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c75:	6a 00                	push   $0x0
  pushl $122
80106c77:	6a 7a                	push   $0x7a
  jmp alltraps
80106c79:	e9 e9 f6 ff ff       	jmp    80106367 <alltraps>

80106c7e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c7e:	6a 00                	push   $0x0
  pushl $123
80106c80:	6a 7b                	push   $0x7b
  jmp alltraps
80106c82:	e9 e0 f6 ff ff       	jmp    80106367 <alltraps>

80106c87 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $124
80106c89:	6a 7c                	push   $0x7c
  jmp alltraps
80106c8b:	e9 d7 f6 ff ff       	jmp    80106367 <alltraps>

80106c90 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c90:	6a 00                	push   $0x0
  pushl $125
80106c92:	6a 7d                	push   $0x7d
  jmp alltraps
80106c94:	e9 ce f6 ff ff       	jmp    80106367 <alltraps>

80106c99 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c99:	6a 00                	push   $0x0
  pushl $126
80106c9b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c9d:	e9 c5 f6 ff ff       	jmp    80106367 <alltraps>

80106ca2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106ca2:	6a 00                	push   $0x0
  pushl $127
80106ca4:	6a 7f                	push   $0x7f
  jmp alltraps
80106ca6:	e9 bc f6 ff ff       	jmp    80106367 <alltraps>

80106cab <vector128>:
.globl vector128
vector128:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $128
80106cad:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cb2:	e9 b0 f6 ff ff       	jmp    80106367 <alltraps>

80106cb7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $129
80106cb9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cbe:	e9 a4 f6 ff ff       	jmp    80106367 <alltraps>

80106cc3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $130
80106cc5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cca:	e9 98 f6 ff ff       	jmp    80106367 <alltraps>

80106ccf <vector131>:
.globl vector131
vector131:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $131
80106cd1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106cd6:	e9 8c f6 ff ff       	jmp    80106367 <alltraps>

80106cdb <vector132>:
.globl vector132
vector132:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $132
80106cdd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ce2:	e9 80 f6 ff ff       	jmp    80106367 <alltraps>

80106ce7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $133
80106ce9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cee:	e9 74 f6 ff ff       	jmp    80106367 <alltraps>

80106cf3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $134
80106cf5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cfa:	e9 68 f6 ff ff       	jmp    80106367 <alltraps>

80106cff <vector135>:
.globl vector135
vector135:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $135
80106d01:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d06:	e9 5c f6 ff ff       	jmp    80106367 <alltraps>

80106d0b <vector136>:
.globl vector136
vector136:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $136
80106d0d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d12:	e9 50 f6 ff ff       	jmp    80106367 <alltraps>

80106d17 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $137
80106d19:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d1e:	e9 44 f6 ff ff       	jmp    80106367 <alltraps>

80106d23 <vector138>:
.globl vector138
vector138:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $138
80106d25:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d2a:	e9 38 f6 ff ff       	jmp    80106367 <alltraps>

80106d2f <vector139>:
.globl vector139
vector139:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $139
80106d31:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d36:	e9 2c f6 ff ff       	jmp    80106367 <alltraps>

80106d3b <vector140>:
.globl vector140
vector140:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $140
80106d3d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d42:	e9 20 f6 ff ff       	jmp    80106367 <alltraps>

80106d47 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $141
80106d49:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d4e:	e9 14 f6 ff ff       	jmp    80106367 <alltraps>

80106d53 <vector142>:
.globl vector142
vector142:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $142
80106d55:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d5a:	e9 08 f6 ff ff       	jmp    80106367 <alltraps>

80106d5f <vector143>:
.globl vector143
vector143:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $143
80106d61:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d66:	e9 fc f5 ff ff       	jmp    80106367 <alltraps>

80106d6b <vector144>:
.globl vector144
vector144:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $144
80106d6d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d72:	e9 f0 f5 ff ff       	jmp    80106367 <alltraps>

80106d77 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $145
80106d79:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d7e:	e9 e4 f5 ff ff       	jmp    80106367 <alltraps>

80106d83 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $146
80106d85:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d8a:	e9 d8 f5 ff ff       	jmp    80106367 <alltraps>

80106d8f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $147
80106d91:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d96:	e9 cc f5 ff ff       	jmp    80106367 <alltraps>

80106d9b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $148
80106d9d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106da2:	e9 c0 f5 ff ff       	jmp    80106367 <alltraps>

80106da7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $149
80106da9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106dae:	e9 b4 f5 ff ff       	jmp    80106367 <alltraps>

80106db3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $150
80106db5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106dba:	e9 a8 f5 ff ff       	jmp    80106367 <alltraps>

80106dbf <vector151>:
.globl vector151
vector151:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $151
80106dc1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106dc6:	e9 9c f5 ff ff       	jmp    80106367 <alltraps>

80106dcb <vector152>:
.globl vector152
vector152:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $152
80106dcd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106dd2:	e9 90 f5 ff ff       	jmp    80106367 <alltraps>

80106dd7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $153
80106dd9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106dde:	e9 84 f5 ff ff       	jmp    80106367 <alltraps>

80106de3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $154
80106de5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106dea:	e9 78 f5 ff ff       	jmp    80106367 <alltraps>

80106def <vector155>:
.globl vector155
vector155:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $155
80106df1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106df6:	e9 6c f5 ff ff       	jmp    80106367 <alltraps>

80106dfb <vector156>:
.globl vector156
vector156:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $156
80106dfd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e02:	e9 60 f5 ff ff       	jmp    80106367 <alltraps>

80106e07 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $157
80106e09:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e0e:	e9 54 f5 ff ff       	jmp    80106367 <alltraps>

80106e13 <vector158>:
.globl vector158
vector158:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $158
80106e15:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e1a:	e9 48 f5 ff ff       	jmp    80106367 <alltraps>

80106e1f <vector159>:
.globl vector159
vector159:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $159
80106e21:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e26:	e9 3c f5 ff ff       	jmp    80106367 <alltraps>

80106e2b <vector160>:
.globl vector160
vector160:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $160
80106e2d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e32:	e9 30 f5 ff ff       	jmp    80106367 <alltraps>

80106e37 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $161
80106e39:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e3e:	e9 24 f5 ff ff       	jmp    80106367 <alltraps>

80106e43 <vector162>:
.globl vector162
vector162:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $162
80106e45:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e4a:	e9 18 f5 ff ff       	jmp    80106367 <alltraps>

80106e4f <vector163>:
.globl vector163
vector163:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $163
80106e51:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e56:	e9 0c f5 ff ff       	jmp    80106367 <alltraps>

80106e5b <vector164>:
.globl vector164
vector164:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $164
80106e5d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e62:	e9 00 f5 ff ff       	jmp    80106367 <alltraps>

80106e67 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $165
80106e69:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e6e:	e9 f4 f4 ff ff       	jmp    80106367 <alltraps>

80106e73 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $166
80106e75:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e7a:	e9 e8 f4 ff ff       	jmp    80106367 <alltraps>

80106e7f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $167
80106e81:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e86:	e9 dc f4 ff ff       	jmp    80106367 <alltraps>

80106e8b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $168
80106e8d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e92:	e9 d0 f4 ff ff       	jmp    80106367 <alltraps>

80106e97 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $169
80106e99:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e9e:	e9 c4 f4 ff ff       	jmp    80106367 <alltraps>

80106ea3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $170
80106ea5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106eaa:	e9 b8 f4 ff ff       	jmp    80106367 <alltraps>

80106eaf <vector171>:
.globl vector171
vector171:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $171
80106eb1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106eb6:	e9 ac f4 ff ff       	jmp    80106367 <alltraps>

80106ebb <vector172>:
.globl vector172
vector172:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $172
80106ebd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ec2:	e9 a0 f4 ff ff       	jmp    80106367 <alltraps>

80106ec7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $173
80106ec9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106ece:	e9 94 f4 ff ff       	jmp    80106367 <alltraps>

80106ed3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $174
80106ed5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106eda:	e9 88 f4 ff ff       	jmp    80106367 <alltraps>

80106edf <vector175>:
.globl vector175
vector175:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $175
80106ee1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ee6:	e9 7c f4 ff ff       	jmp    80106367 <alltraps>

80106eeb <vector176>:
.globl vector176
vector176:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $176
80106eed:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ef2:	e9 70 f4 ff ff       	jmp    80106367 <alltraps>

80106ef7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $177
80106ef9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106efe:	e9 64 f4 ff ff       	jmp    80106367 <alltraps>

80106f03 <vector178>:
.globl vector178
vector178:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $178
80106f05:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f0a:	e9 58 f4 ff ff       	jmp    80106367 <alltraps>

80106f0f <vector179>:
.globl vector179
vector179:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $179
80106f11:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f16:	e9 4c f4 ff ff       	jmp    80106367 <alltraps>

80106f1b <vector180>:
.globl vector180
vector180:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $180
80106f1d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f22:	e9 40 f4 ff ff       	jmp    80106367 <alltraps>

80106f27 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $181
80106f29:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f2e:	e9 34 f4 ff ff       	jmp    80106367 <alltraps>

80106f33 <vector182>:
.globl vector182
vector182:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $182
80106f35:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f3a:	e9 28 f4 ff ff       	jmp    80106367 <alltraps>

80106f3f <vector183>:
.globl vector183
vector183:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $183
80106f41:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f46:	e9 1c f4 ff ff       	jmp    80106367 <alltraps>

80106f4b <vector184>:
.globl vector184
vector184:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $184
80106f4d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f52:	e9 10 f4 ff ff       	jmp    80106367 <alltraps>

80106f57 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $185
80106f59:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f5e:	e9 04 f4 ff ff       	jmp    80106367 <alltraps>

80106f63 <vector186>:
.globl vector186
vector186:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $186
80106f65:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f6a:	e9 f8 f3 ff ff       	jmp    80106367 <alltraps>

80106f6f <vector187>:
.globl vector187
vector187:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $187
80106f71:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f76:	e9 ec f3 ff ff       	jmp    80106367 <alltraps>

80106f7b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $188
80106f7d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f82:	e9 e0 f3 ff ff       	jmp    80106367 <alltraps>

80106f87 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $189
80106f89:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f8e:	e9 d4 f3 ff ff       	jmp    80106367 <alltraps>

80106f93 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $190
80106f95:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f9a:	e9 c8 f3 ff ff       	jmp    80106367 <alltraps>

80106f9f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $191
80106fa1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fa6:	e9 bc f3 ff ff       	jmp    80106367 <alltraps>

80106fab <vector192>:
.globl vector192
vector192:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $192
80106fad:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fb2:	e9 b0 f3 ff ff       	jmp    80106367 <alltraps>

80106fb7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $193
80106fb9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106fbe:	e9 a4 f3 ff ff       	jmp    80106367 <alltraps>

80106fc3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $194
80106fc5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106fca:	e9 98 f3 ff ff       	jmp    80106367 <alltraps>

80106fcf <vector195>:
.globl vector195
vector195:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $195
80106fd1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fd6:	e9 8c f3 ff ff       	jmp    80106367 <alltraps>

80106fdb <vector196>:
.globl vector196
vector196:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $196
80106fdd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fe2:	e9 80 f3 ff ff       	jmp    80106367 <alltraps>

80106fe7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $197
80106fe9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fee:	e9 74 f3 ff ff       	jmp    80106367 <alltraps>

80106ff3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $198
80106ff5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ffa:	e9 68 f3 ff ff       	jmp    80106367 <alltraps>

80106fff <vector199>:
.globl vector199
vector199:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $199
80107001:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107006:	e9 5c f3 ff ff       	jmp    80106367 <alltraps>

8010700b <vector200>:
.globl vector200
vector200:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $200
8010700d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107012:	e9 50 f3 ff ff       	jmp    80106367 <alltraps>

80107017 <vector201>:
.globl vector201
vector201:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $201
80107019:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010701e:	e9 44 f3 ff ff       	jmp    80106367 <alltraps>

80107023 <vector202>:
.globl vector202
vector202:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $202
80107025:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010702a:	e9 38 f3 ff ff       	jmp    80106367 <alltraps>

8010702f <vector203>:
.globl vector203
vector203:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $203
80107031:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107036:	e9 2c f3 ff ff       	jmp    80106367 <alltraps>

8010703b <vector204>:
.globl vector204
vector204:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $204
8010703d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107042:	e9 20 f3 ff ff       	jmp    80106367 <alltraps>

80107047 <vector205>:
.globl vector205
vector205:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $205
80107049:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010704e:	e9 14 f3 ff ff       	jmp    80106367 <alltraps>

80107053 <vector206>:
.globl vector206
vector206:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $206
80107055:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010705a:	e9 08 f3 ff ff       	jmp    80106367 <alltraps>

8010705f <vector207>:
.globl vector207
vector207:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $207
80107061:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107066:	e9 fc f2 ff ff       	jmp    80106367 <alltraps>

8010706b <vector208>:
.globl vector208
vector208:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $208
8010706d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107072:	e9 f0 f2 ff ff       	jmp    80106367 <alltraps>

80107077 <vector209>:
.globl vector209
vector209:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $209
80107079:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010707e:	e9 e4 f2 ff ff       	jmp    80106367 <alltraps>

80107083 <vector210>:
.globl vector210
vector210:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $210
80107085:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010708a:	e9 d8 f2 ff ff       	jmp    80106367 <alltraps>

8010708f <vector211>:
.globl vector211
vector211:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $211
80107091:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107096:	e9 cc f2 ff ff       	jmp    80106367 <alltraps>

8010709b <vector212>:
.globl vector212
vector212:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $212
8010709d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070a2:	e9 c0 f2 ff ff       	jmp    80106367 <alltraps>

801070a7 <vector213>:
.globl vector213
vector213:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $213
801070a9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070ae:	e9 b4 f2 ff ff       	jmp    80106367 <alltraps>

801070b3 <vector214>:
.globl vector214
vector214:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $214
801070b5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070ba:	e9 a8 f2 ff ff       	jmp    80106367 <alltraps>

801070bf <vector215>:
.globl vector215
vector215:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $215
801070c1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070c6:	e9 9c f2 ff ff       	jmp    80106367 <alltraps>

801070cb <vector216>:
.globl vector216
vector216:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $216
801070cd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070d2:	e9 90 f2 ff ff       	jmp    80106367 <alltraps>

801070d7 <vector217>:
.globl vector217
vector217:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $217
801070d9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070de:	e9 84 f2 ff ff       	jmp    80106367 <alltraps>

801070e3 <vector218>:
.globl vector218
vector218:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $218
801070e5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070ea:	e9 78 f2 ff ff       	jmp    80106367 <alltraps>

801070ef <vector219>:
.globl vector219
vector219:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $219
801070f1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070f6:	e9 6c f2 ff ff       	jmp    80106367 <alltraps>

801070fb <vector220>:
.globl vector220
vector220:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $220
801070fd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107102:	e9 60 f2 ff ff       	jmp    80106367 <alltraps>

80107107 <vector221>:
.globl vector221
vector221:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $221
80107109:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010710e:	e9 54 f2 ff ff       	jmp    80106367 <alltraps>

80107113 <vector222>:
.globl vector222
vector222:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $222
80107115:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010711a:	e9 48 f2 ff ff       	jmp    80106367 <alltraps>

8010711f <vector223>:
.globl vector223
vector223:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $223
80107121:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107126:	e9 3c f2 ff ff       	jmp    80106367 <alltraps>

8010712b <vector224>:
.globl vector224
vector224:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $224
8010712d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107132:	e9 30 f2 ff ff       	jmp    80106367 <alltraps>

80107137 <vector225>:
.globl vector225
vector225:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $225
80107139:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010713e:	e9 24 f2 ff ff       	jmp    80106367 <alltraps>

80107143 <vector226>:
.globl vector226
vector226:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $226
80107145:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010714a:	e9 18 f2 ff ff       	jmp    80106367 <alltraps>

8010714f <vector227>:
.globl vector227
vector227:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $227
80107151:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107156:	e9 0c f2 ff ff       	jmp    80106367 <alltraps>

8010715b <vector228>:
.globl vector228
vector228:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $228
8010715d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107162:	e9 00 f2 ff ff       	jmp    80106367 <alltraps>

80107167 <vector229>:
.globl vector229
vector229:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $229
80107169:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010716e:	e9 f4 f1 ff ff       	jmp    80106367 <alltraps>

80107173 <vector230>:
.globl vector230
vector230:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $230
80107175:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010717a:	e9 e8 f1 ff ff       	jmp    80106367 <alltraps>

8010717f <vector231>:
.globl vector231
vector231:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $231
80107181:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107186:	e9 dc f1 ff ff       	jmp    80106367 <alltraps>

8010718b <vector232>:
.globl vector232
vector232:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $232
8010718d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107192:	e9 d0 f1 ff ff       	jmp    80106367 <alltraps>

80107197 <vector233>:
.globl vector233
vector233:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $233
80107199:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010719e:	e9 c4 f1 ff ff       	jmp    80106367 <alltraps>

801071a3 <vector234>:
.globl vector234
vector234:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $234
801071a5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071aa:	e9 b8 f1 ff ff       	jmp    80106367 <alltraps>

801071af <vector235>:
.globl vector235
vector235:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $235
801071b1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071b6:	e9 ac f1 ff ff       	jmp    80106367 <alltraps>

801071bb <vector236>:
.globl vector236
vector236:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $236
801071bd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071c2:	e9 a0 f1 ff ff       	jmp    80106367 <alltraps>

801071c7 <vector237>:
.globl vector237
vector237:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $237
801071c9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071ce:	e9 94 f1 ff ff       	jmp    80106367 <alltraps>

801071d3 <vector238>:
.globl vector238
vector238:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $238
801071d5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071da:	e9 88 f1 ff ff       	jmp    80106367 <alltraps>

801071df <vector239>:
.globl vector239
vector239:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $239
801071e1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071e6:	e9 7c f1 ff ff       	jmp    80106367 <alltraps>

801071eb <vector240>:
.globl vector240
vector240:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $240
801071ed:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071f2:	e9 70 f1 ff ff       	jmp    80106367 <alltraps>

801071f7 <vector241>:
.globl vector241
vector241:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $241
801071f9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071fe:	e9 64 f1 ff ff       	jmp    80106367 <alltraps>

80107203 <vector242>:
.globl vector242
vector242:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $242
80107205:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010720a:	e9 58 f1 ff ff       	jmp    80106367 <alltraps>

8010720f <vector243>:
.globl vector243
vector243:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $243
80107211:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107216:	e9 4c f1 ff ff       	jmp    80106367 <alltraps>

8010721b <vector244>:
.globl vector244
vector244:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $244
8010721d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107222:	e9 40 f1 ff ff       	jmp    80106367 <alltraps>

80107227 <vector245>:
.globl vector245
vector245:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $245
80107229:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010722e:	e9 34 f1 ff ff       	jmp    80106367 <alltraps>

80107233 <vector246>:
.globl vector246
vector246:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $246
80107235:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010723a:	e9 28 f1 ff ff       	jmp    80106367 <alltraps>

8010723f <vector247>:
.globl vector247
vector247:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $247
80107241:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107246:	e9 1c f1 ff ff       	jmp    80106367 <alltraps>

8010724b <vector248>:
.globl vector248
vector248:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $248
8010724d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107252:	e9 10 f1 ff ff       	jmp    80106367 <alltraps>

80107257 <vector249>:
.globl vector249
vector249:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $249
80107259:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010725e:	e9 04 f1 ff ff       	jmp    80106367 <alltraps>

80107263 <vector250>:
.globl vector250
vector250:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $250
80107265:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010726a:	e9 f8 f0 ff ff       	jmp    80106367 <alltraps>

8010726f <vector251>:
.globl vector251
vector251:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $251
80107271:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107276:	e9 ec f0 ff ff       	jmp    80106367 <alltraps>

8010727b <vector252>:
.globl vector252
vector252:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $252
8010727d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107282:	e9 e0 f0 ff ff       	jmp    80106367 <alltraps>

80107287 <vector253>:
.globl vector253
vector253:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $253
80107289:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010728e:	e9 d4 f0 ff ff       	jmp    80106367 <alltraps>

80107293 <vector254>:
.globl vector254
vector254:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $254
80107295:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010729a:	e9 c8 f0 ff ff       	jmp    80106367 <alltraps>

8010729f <vector255>:
.globl vector255
vector255:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $255
801072a1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072a6:	e9 bc f0 ff ff       	jmp    80106367 <alltraps>
801072ab:	66 90                	xchg   %ax,%ax
801072ad:	66 90                	xchg   %ax,%ax
801072af:	90                   	nop

801072b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801072b7:	c1 ea 16             	shr    $0x16,%edx
{
801072ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801072bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801072be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801072c1:	8b 1f                	mov    (%edi),%ebx
801072c3:	f6 c3 01             	test   $0x1,%bl
801072c6:	74 28                	je     801072f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072ce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801072d4:	89 f0                	mov    %esi,%eax
}
801072d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801072d9:	c1 e8 0a             	shr    $0xa,%eax
801072dc:	25 fc 0f 00 00       	and    $0xffc,%eax
801072e1:	01 d8                	add    %ebx,%eax
}
801072e3:	5b                   	pop    %ebx
801072e4:	5e                   	pop    %esi
801072e5:	5f                   	pop    %edi
801072e6:	5d                   	pop    %ebp
801072e7:	c3                   	ret    
801072e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072f0:	85 c9                	test   %ecx,%ecx
801072f2:	74 2c                	je     80107320 <walkpgdir+0x70>
801072f4:	e8 87 ba ff ff       	call   80102d80 <kalloc>
801072f9:	89 c3                	mov    %eax,%ebx
801072fb:	85 c0                	test   %eax,%eax
801072fd:	74 21                	je     80107320 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801072ff:	83 ec 04             	sub    $0x4,%esp
80107302:	68 00 10 00 00       	push   $0x1000
80107307:	6a 00                	push   $0x0
80107309:	50                   	push   %eax
8010730a:	e8 f1 dd ff ff       	call   80105100 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010730f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107315:	83 c4 10             	add    $0x10,%esp
80107318:	83 c8 07             	or     $0x7,%eax
8010731b:	89 07                	mov    %eax,(%edi)
8010731d:	eb b5                	jmp    801072d4 <walkpgdir+0x24>
8010731f:	90                   	nop
}
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107330 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107336:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010733a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010733b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107340:	89 d6                	mov    %edx,%esi
{
80107342:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107343:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107349:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010734c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010734f:	8b 45 08             	mov    0x8(%ebp),%eax
80107352:	29 f0                	sub    %esi,%eax
80107354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107357:	eb 1f                	jmp    80107378 <mappages+0x48>
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107360:	f6 00 01             	testb  $0x1,(%eax)
80107363:	75 45                	jne    801073aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107365:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107368:	83 cb 01             	or     $0x1,%ebx
8010736b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010736d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107370:	74 2e                	je     801073a0 <mappages+0x70>
      break;
    a += PGSIZE;
80107372:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010737b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107380:	89 f2                	mov    %esi,%edx
80107382:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107385:	89 f8                	mov    %edi,%eax
80107387:	e8 24 ff ff ff       	call   801072b0 <walkpgdir>
8010738c:	85 c0                	test   %eax,%eax
8010738e:	75 d0                	jne    80107360 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107390:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107398:	5b                   	pop    %ebx
80107399:	5e                   	pop    %esi
8010739a:	5f                   	pop    %edi
8010739b:	5d                   	pop    %ebp
8010739c:	c3                   	ret    
8010739d:	8d 76 00             	lea    0x0(%esi),%esi
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073a3:	31 c0                	xor    %eax,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
      panic("remap");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 f8 95 10 80       	push   $0x801095f8
801073b2:	e8 d9 8f ff ff       	call   80100390 <panic>
801073b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073be:	66 90                	xchg   %ax,%ax

801073c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	89 c7                	mov    %eax,%edi
801073c6:	56                   	push   %esi
801073c7:	53                   	push   %ebx
801073c8:	89 d3                	mov    %edx,%ebx
801073ca:	83 ec 1c             	sub    $0x1c,%esp
801073cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  #endif

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801073d0:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801073d6:	89 d6                	mov    %edx,%esi
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073d8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
801073db:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
801073e1:	39 de                	cmp    %ebx,%esi
801073e3:	72 52                	jb     80107437 <deallocuvm.part.0+0x77>
801073e5:	eb 72                	jmp    80107459 <deallocuvm.part.0+0x99>
801073e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ee:	66 90                	xchg   %ax,%ax
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
801073f0:	8b 00                	mov    (%eax),%eax
801073f2:	a8 01                	test   $0x1,%al
801073f4:	74 36                	je     8010742c <deallocuvm.part.0+0x6c>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801073f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073fb:	74 79                	je     80107476 <deallocuvm.part.0+0xb6>
        panic("kfree");
      char *v = P2V(pa);
801073fd:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
      
      if(getRefs(v) == 1)
80107403:	83 ec 0c             	sub    $0xc,%esp
80107406:	51                   	push   %ecx
80107407:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010740a:	e8 11 bb ff ff       	call   80102f20 <getRefs>
8010740f:	83 c4 10             	add    $0x10,%esp
80107412:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107415:	83 f8 01             	cmp    $0x1,%eax
80107418:	74 4e                	je     80107468 <deallocuvm.part.0+0xa8>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
8010741a:	83 ec 0c             	sub    $0xc,%esp
8010741d:	51                   	push   %ecx
8010741e:	e8 1d ba ff ff       	call   80102e40 <refDec>
80107423:	83 c4 10             	add    $0x10,%esp
          }
        }

      }
     #endif
      *pte = 0;
80107426:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  for(; a  < oldsz; a += PGSIZE){
8010742c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107432:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80107435:	73 22                	jae    80107459 <deallocuvm.part.0+0x99>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107437:	31 c9                	xor    %ecx,%ecx
80107439:	89 f2                	mov    %esi,%edx
8010743b:	89 f8                	mov    %edi,%eax
8010743d:	e8 6e fe ff ff       	call   801072b0 <walkpgdir>
80107442:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107444:	85 c0                	test   %eax,%eax
80107446:	75 a8                	jne    801073f0 <deallocuvm.part.0+0x30>
      a += (NPTENTRIES - 1) * PGSIZE;
80107448:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
8010744e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107454:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80107457:	72 de                	jb     80107437 <deallocuvm.part.0+0x77>
    }
  }
  return newsz;
}
80107459:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010745c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010745f:	5b                   	pop    %ebx
80107460:	5e                   	pop    %esi
80107461:	5f                   	pop    %edi
80107462:	5d                   	pop    %ebp
80107463:	c3                   	ret    
80107464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(v);
80107468:	83 ec 0c             	sub    $0xc,%esp
8010746b:	51                   	push   %ecx
8010746c:	e8 0f b6 ff ff       	call   80102a80 <kfree>
80107471:	83 c4 10             	add    $0x10,%esp
80107474:	eb b0                	jmp    80107426 <deallocuvm.part.0+0x66>
        panic("kfree");
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	68 d2 8e 10 80       	push   $0x80108ed2
8010747e:	e8 0d 8f ff ff       	call   80100390 <panic>
80107483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <printlist>:
{
80107490:	f3 0f 1e fb          	endbr32 
80107494:	55                   	push   %ebp
80107495:	89 e5                	mov    %esp,%ebp
80107497:	56                   	push   %esi
  struct fblock *curr = myproc()->free_head;
80107498:	be 10 00 00 00       	mov    $0x10,%esi
{
8010749d:	53                   	push   %ebx
  cprintf("printing list:\n");
8010749e:	83 ec 0c             	sub    $0xc,%esp
801074a1:	68 fe 95 10 80       	push   $0x801095fe
801074a6:	e8 05 92 ff ff       	call   801006b0 <cprintf>
  struct fblock *curr = myproc()->free_head;
801074ab:	e8 90 cd ff ff       	call   80104240 <myproc>
801074b0:	83 c4 10             	add    $0x10,%esp
801074b3:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d -> ", curr->off);
801074c0:	83 ec 08             	sub    $0x8,%esp
801074c3:	ff 33                	pushl  (%ebx)
801074c5:	68 0e 96 10 80       	push   $0x8010960e
801074ca:	e8 e1 91 ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
801074cf:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
801074d2:	83 c4 10             	add    $0x10,%esp
801074d5:	85 db                	test   %ebx,%ebx
801074d7:	74 05                	je     801074de <printlist+0x4e>
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
801074d9:	83 ee 01             	sub    $0x1,%esi
801074dc:	75 e2                	jne    801074c0 <printlist+0x30>
  cprintf("\n");
801074de:	83 ec 0c             	sub    $0xc,%esp
801074e1:	68 f6 96 10 80       	push   $0x801096f6
801074e6:	e8 c5 91 ff ff       	call   801006b0 <cprintf>
}
801074eb:	83 c4 10             	add    $0x10,%esp
801074ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074f1:	5b                   	pop    %ebx
801074f2:	5e                   	pop    %esi
801074f3:	5d                   	pop    %ebp
801074f4:	c3                   	ret    
801074f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107500 <printaq>:
{
80107500:	f3 0f 1e fb          	endbr32 
80107504:	55                   	push   %ebp
80107505:	89 e5                	mov    %esp,%ebp
80107507:	53                   	push   %ebx
80107508:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
8010750b:	68 15 96 10 80       	push   $0x80109615
80107510:	e8 9b 91 ff ff       	call   801006b0 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107515:	e8 26 cd ff ff       	call   80104240 <myproc>
8010751a:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107520:	8b 58 08             	mov    0x8(%eax),%ebx
80107523:	e8 18 cd ff ff       	call   80104240 <myproc>
80107528:	83 c4 0c             	add    $0xc,%esp
8010752b:	53                   	push   %ebx
8010752c:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107532:	ff 70 08             	pushl  0x8(%eax)
80107535:	68 27 96 10 80       	push   $0x80109627
8010753a:	e8 71 91 ff ff       	call   801006b0 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010753f:	e8 fc cc ff ff       	call   80104240 <myproc>
80107544:	83 c4 10             	add    $0x10,%esp
80107547:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010754d:	8b 50 04             	mov    0x4(%eax),%edx
80107550:	85 d2                	test   %edx,%edx
80107552:	74 5c                	je     801075b0 <printaq+0xb0>
  struct queue_node *curr = myproc()->queue_head;
80107554:	e8 e7 cc ff ff       	call   80104240 <myproc>
80107559:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010755f:	85 db                	test   %ebx,%ebx
80107561:	74 1e                	je     80107581 <printaq+0x81>
80107563:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107567:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107568:	83 ec 08             	sub    $0x8,%esp
8010756b:	ff 73 08             	pushl  0x8(%ebx)
8010756e:	68 45 96 10 80       	push   $0x80109645
80107573:	e8 38 91 ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
80107578:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
8010757a:	83 c4 10             	add    $0x10,%esp
8010757d:	85 db                	test   %ebx,%ebx
8010757f:	75 e7                	jne    80107568 <printaq+0x68>
  if(myproc()->queue_tail->next == 0)
80107581:	e8 ba cc ff ff       	call   80104240 <myproc>
80107586:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010758c:	8b 00                	mov    (%eax),%eax
8010758e:	85 c0                	test   %eax,%eax
80107590:	74 36                	je     801075c8 <printaq+0xc8>
  cprintf("\n");
80107592:	83 ec 0c             	sub    $0xc,%esp
80107595:	68 f6 96 10 80       	push   $0x801096f6
8010759a:	e8 11 91 ff ff       	call   801006b0 <cprintf>
}
8010759f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075a2:	83 c4 10             	add    $0x10,%esp
801075a5:	c9                   	leave  
801075a6:	c3                   	ret    
801075a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ae:	66 90                	xchg   %ax,%ax
    cprintf("null <-> ");
801075b0:	83 ec 0c             	sub    $0xc,%esp
801075b3:	68 3b 96 10 80       	push   $0x8010963b
801075b8:	e8 f3 90 ff ff       	call   801006b0 <cprintf>
801075bd:	83 c4 10             	add    $0x10,%esp
801075c0:	eb 92                	jmp    80107554 <printaq+0x54>
801075c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801075c8:	83 ec 0c             	sub    $0xc,%esp
801075cb:	68 3b 96 10 80       	push   $0x8010963b
801075d0:	e8 db 90 ff ff       	call   801006b0 <cprintf>
801075d5:	83 c4 10             	add    $0x10,%esp
801075d8:	eb b8                	jmp    80107592 <printaq+0x92>
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <seginit>:
{
801075e0:	f3 0f 1e fb          	endbr32 
801075e4:	55                   	push   %ebp
801075e5:	89 e5                	mov    %esp,%ebp
801075e7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801075ea:	e8 31 cc ff ff       	call   80104220 <cpuid>
  pd[0] = size-1;
801075ef:	ba 2f 00 00 00       	mov    $0x2f,%edx
801075f4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801075fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801075fe:	c7 80 f8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a408(%eax)
80107605:	ff 00 00 
80107608:	c7 80 fc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a404(%eax)
8010760f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107612:	c7 80 00 5c 18 80 ff 	movl   $0xffff,-0x7fe7a400(%eax)
80107619:	ff 00 00 
8010761c:	c7 80 04 5c 18 80 00 	movl   $0xcf9200,-0x7fe7a3fc(%eax)
80107623:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107626:	c7 80 08 5c 18 80 ff 	movl   $0xffff,-0x7fe7a3f8(%eax)
8010762d:	ff 00 00 
80107630:	c7 80 0c 5c 18 80 00 	movl   $0xcffa00,-0x7fe7a3f4(%eax)
80107637:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010763a:	c7 80 10 5c 18 80 ff 	movl   $0xffff,-0x7fe7a3f0(%eax)
80107641:	ff 00 00 
80107644:	c7 80 14 5c 18 80 00 	movl   $0xcff200,-0x7fe7a3ec(%eax)
8010764b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010764e:	05 f0 5b 18 80       	add    $0x80185bf0,%eax
  pd[1] = (uint)p;
80107653:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107657:	c1 e8 10             	shr    $0x10,%eax
8010765a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010765e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107661:	0f 01 10             	lgdtl  (%eax)
}
80107664:	c9                   	leave  
80107665:	c3                   	ret    
80107666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010766d:	8d 76 00             	lea    0x0(%esi),%esi

80107670 <switchkvm>:
{
80107670:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107674:	a1 a4 75 19 80       	mov    0x801975a4,%eax
80107679:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010767e:	0f 22 d8             	mov    %eax,%cr3
}
80107681:	c3                   	ret    
80107682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107690 <switchuvm>:
{
80107690:	f3 0f 1e fb          	endbr32 
80107694:	55                   	push   %ebp
80107695:	89 e5                	mov    %esp,%ebp
80107697:	57                   	push   %edi
80107698:	56                   	push   %esi
80107699:	53                   	push   %ebx
8010769a:	83 ec 1c             	sub    $0x1c,%esp
8010769d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801076a0:	85 f6                	test   %esi,%esi
801076a2:	0f 84 cb 00 00 00    	je     80107773 <switchuvm+0xe3>
  if(p->kstack == 0)
801076a8:	8b 46 08             	mov    0x8(%esi),%eax
801076ab:	85 c0                	test   %eax,%eax
801076ad:	0f 84 da 00 00 00    	je     8010778d <switchuvm+0xfd>
  if(p->pgdir == 0)
801076b3:	8b 46 04             	mov    0x4(%esi),%eax
801076b6:	85 c0                	test   %eax,%eax
801076b8:	0f 84 c2 00 00 00    	je     80107780 <switchuvm+0xf0>
  pushcli();
801076be:	e8 2d d8 ff ff       	call   80104ef0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076c3:	e8 e8 ca ff ff       	call   801041b0 <mycpu>
801076c8:	89 c3                	mov    %eax,%ebx
801076ca:	e8 e1 ca ff ff       	call   801041b0 <mycpu>
801076cf:	89 c7                	mov    %eax,%edi
801076d1:	e8 da ca ff ff       	call   801041b0 <mycpu>
801076d6:	83 c7 08             	add    $0x8,%edi
801076d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076dc:	e8 cf ca ff ff       	call   801041b0 <mycpu>
801076e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801076e4:	ba 67 00 00 00       	mov    $0x67,%edx
801076e9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801076f0:	83 c0 08             	add    $0x8,%eax
801076f3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076fa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801076ff:	83 c1 08             	add    $0x8,%ecx
80107702:	c1 e8 18             	shr    $0x18,%eax
80107705:	c1 e9 10             	shr    $0x10,%ecx
80107708:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010770e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107714:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107719:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107720:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107725:	e8 86 ca ff ff       	call   801041b0 <mycpu>
8010772a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107731:	e8 7a ca ff ff       	call   801041b0 <mycpu>
80107736:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010773a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010773d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107743:	e8 68 ca ff ff       	call   801041b0 <mycpu>
80107748:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010774b:	e8 60 ca ff ff       	call   801041b0 <mycpu>
80107750:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107754:	b8 28 00 00 00       	mov    $0x28,%eax
80107759:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010775c:	8b 46 04             	mov    0x4(%esi),%eax
8010775f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107764:	0f 22 d8             	mov    %eax,%cr3
}
80107767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776a:	5b                   	pop    %ebx
8010776b:	5e                   	pop    %esi
8010776c:	5f                   	pop    %edi
8010776d:	5d                   	pop    %ebp
  popcli();
8010776e:	e9 cd d7 ff ff       	jmp    80104f40 <popcli>
    panic("switchuvm: no process");
80107773:	83 ec 0c             	sub    $0xc,%esp
80107776:	68 4d 96 10 80       	push   $0x8010964d
8010777b:	e8 10 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107780:	83 ec 0c             	sub    $0xc,%esp
80107783:	68 78 96 10 80       	push   $0x80109678
80107788:	e8 03 8c ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010778d:	83 ec 0c             	sub    $0xc,%esp
80107790:	68 63 96 10 80       	push   $0x80109663
80107795:	e8 f6 8b ff ff       	call   80100390 <panic>
8010779a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077a0 <inituvm>:
{
801077a0:	f3 0f 1e fb          	endbr32 
801077a4:	55                   	push   %ebp
801077a5:	89 e5                	mov    %esp,%ebp
801077a7:	57                   	push   %edi
801077a8:	56                   	push   %esi
801077a9:	53                   	push   %ebx
801077aa:	83 ec 1c             	sub    $0x1c,%esp
801077ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801077b0:	8b 75 10             	mov    0x10(%ebp),%esi
801077b3:	8b 7d 08             	mov    0x8(%ebp),%edi
801077b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801077b9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801077bf:	77 4b                	ja     8010780c <inituvm+0x6c>
  mem = kalloc();
801077c1:	e8 ba b5 ff ff       	call   80102d80 <kalloc>
  memset(mem, 0, PGSIZE);
801077c6:	83 ec 04             	sub    $0x4,%esp
801077c9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801077ce:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801077d0:	6a 00                	push   $0x0
801077d2:	50                   	push   %eax
801077d3:	e8 28 d9 ff ff       	call   80105100 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801077d8:	58                   	pop    %eax
801077d9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077df:	5a                   	pop    %edx
801077e0:	6a 06                	push   $0x6
801077e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077e7:	31 d2                	xor    %edx,%edx
801077e9:	50                   	push   %eax
801077ea:	89 f8                	mov    %edi,%eax
801077ec:	e8 3f fb ff ff       	call   80107330 <mappages>
  memmove(mem, init, sz);
801077f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077f4:	89 75 10             	mov    %esi,0x10(%ebp)
801077f7:	83 c4 10             	add    $0x10,%esp
801077fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801077fd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107800:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5f                   	pop    %edi
80107806:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107807:	e9 94 d9 ff ff       	jmp    801051a0 <memmove>
    panic("inituvm: more than a page");
8010780c:	83 ec 0c             	sub    $0xc,%esp
8010780f:	68 8c 96 10 80       	push   $0x8010968c
80107814:	e8 77 8b ff ff       	call   80100390 <panic>
80107819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107820 <loaduvm>:
{
80107820:	f3 0f 1e fb          	endbr32 
80107824:	55                   	push   %ebp
80107825:	89 e5                	mov    %esp,%ebp
80107827:	57                   	push   %edi
80107828:	56                   	push   %esi
80107829:	53                   	push   %ebx
8010782a:	83 ec 1c             	sub    $0x1c,%esp
8010782d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107830:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107833:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107838:	0f 85 99 00 00 00    	jne    801078d7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010783e:	01 f0                	add    %esi,%eax
80107840:	89 f3                	mov    %esi,%ebx
80107842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107845:	8b 45 14             	mov    0x14(%ebp),%eax
80107848:	01 f0                	add    %esi,%eax
8010784a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010784d:	85 f6                	test   %esi,%esi
8010784f:	75 15                	jne    80107866 <loaduvm+0x46>
80107851:	eb 6d                	jmp    801078c0 <loaduvm+0xa0>
80107853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107857:	90                   	nop
80107858:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010785e:	89 f0                	mov    %esi,%eax
80107860:	29 d8                	sub    %ebx,%eax
80107862:	39 c6                	cmp    %eax,%esi
80107864:	76 5a                	jbe    801078c0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107866:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107869:	8b 45 08             	mov    0x8(%ebp),%eax
8010786c:	31 c9                	xor    %ecx,%ecx
8010786e:	29 da                	sub    %ebx,%edx
80107870:	e8 3b fa ff ff       	call   801072b0 <walkpgdir>
80107875:	85 c0                	test   %eax,%eax
80107877:	74 51                	je     801078ca <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107879:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010787b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010787e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107883:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107888:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010788e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107891:	29 d9                	sub    %ebx,%ecx
80107893:	05 00 00 00 80       	add    $0x80000000,%eax
80107898:	57                   	push   %edi
80107899:	51                   	push   %ecx
8010789a:	50                   	push   %eax
8010789b:	ff 75 10             	pushl  0x10(%ebp)
8010789e:	e8 2d a4 ff ff       	call   80101cd0 <readi>
801078a3:	83 c4 10             	add    $0x10,%esp
801078a6:	39 f8                	cmp    %edi,%eax
801078a8:	74 ae                	je     80107858 <loaduvm+0x38>
}
801078aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078b2:	5b                   	pop    %ebx
801078b3:	5e                   	pop    %esi
801078b4:	5f                   	pop    %edi
801078b5:	5d                   	pop    %ebp
801078b6:	c3                   	ret    
801078b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078be:	66 90                	xchg   %ax,%ax
801078c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078c3:	31 c0                	xor    %eax,%eax
}
801078c5:	5b                   	pop    %ebx
801078c6:	5e                   	pop    %esi
801078c7:	5f                   	pop    %edi
801078c8:	5d                   	pop    %ebp
801078c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801078ca:	83 ec 0c             	sub    $0xc,%esp
801078cd:	68 a6 96 10 80       	push   $0x801096a6
801078d2:	e8 b9 8a ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801078d7:	83 ec 0c             	sub    $0xc,%esp
801078da:	68 3c 98 10 80       	push   $0x8010983c
801078df:	e8 ac 8a ff ff       	call   80100390 <panic>
801078e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078ef:	90                   	nop

801078f0 <allocuvm>:
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
801078f5:	89 e5                	mov    %esp,%ebp
801078f7:	57                   	push   %edi
801078f8:	56                   	push   %esi
801078f9:	53                   	push   %ebx
801078fa:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801078fd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107900:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107906:	85 c0                	test   %eax,%eax
80107908:	0f 88 b2 00 00 00    	js     801079c0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010790e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107911:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107914:	0f 82 96 00 00 00    	jb     801079b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010791a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107920:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107926:	39 75 10             	cmp    %esi,0x10(%ebp)
80107929:	77 40                	ja     8010796b <allocuvm+0x7b>
8010792b:	e9 83 00 00 00       	jmp    801079b3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107930:	83 ec 04             	sub    $0x4,%esp
80107933:	68 00 10 00 00       	push   $0x1000
80107938:	6a 00                	push   $0x0
8010793a:	50                   	push   %eax
8010793b:	e8 c0 d7 ff ff       	call   80105100 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107940:	58                   	pop    %eax
80107941:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107947:	5a                   	pop    %edx
80107948:	6a 06                	push   $0x6
8010794a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010794f:	89 f2                	mov    %esi,%edx
80107951:	50                   	push   %eax
80107952:	89 f8                	mov    %edi,%eax
80107954:	e8 d7 f9 ff ff       	call   80107330 <mappages>
80107959:	83 c4 10             	add    $0x10,%esp
8010795c:	85 c0                	test   %eax,%eax
8010795e:	78 78                	js     801079d8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107960:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107966:	39 75 10             	cmp    %esi,0x10(%ebp)
80107969:	76 48                	jbe    801079b3 <allocuvm+0xc3>
    mem = kalloc();
8010796b:	e8 10 b4 ff ff       	call   80102d80 <kalloc>
80107970:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107972:	85 c0                	test   %eax,%eax
80107974:	75 ba                	jne    80107930 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	68 c4 96 10 80       	push   $0x801096c4
8010797e:	e8 2d 8d ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107983:	8b 45 0c             	mov    0xc(%ebp),%eax
80107986:	83 c4 10             	add    $0x10,%esp
80107989:	39 45 10             	cmp    %eax,0x10(%ebp)
8010798c:	74 32                	je     801079c0 <allocuvm+0xd0>
8010798e:	8b 55 10             	mov    0x10(%ebp),%edx
80107991:	89 c1                	mov    %eax,%ecx
80107993:	89 f8                	mov    %edi,%eax
80107995:	e8 26 fa ff ff       	call   801073c0 <deallocuvm.part.0>
      return 0;
8010799a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801079a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a7:	5b                   	pop    %ebx
801079a8:	5e                   	pop    %esi
801079a9:	5f                   	pop    %edi
801079aa:	5d                   	pop    %ebp
801079ab:	c3                   	ret    
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801079b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801079b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079b9:	5b                   	pop    %ebx
801079ba:	5e                   	pop    %esi
801079bb:	5f                   	pop    %edi
801079bc:	5d                   	pop    %ebp
801079bd:	c3                   	ret    
801079be:	66 90                	xchg   %ax,%ax
    return 0;
801079c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801079c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079cd:	5b                   	pop    %ebx
801079ce:	5e                   	pop    %esi
801079cf:	5f                   	pop    %edi
801079d0:	5d                   	pop    %ebp
801079d1:	c3                   	ret    
801079d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801079d8:	83 ec 0c             	sub    $0xc,%esp
801079db:	68 dc 96 10 80       	push   $0x801096dc
801079e0:	e8 cb 8c ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801079e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e8:	83 c4 10             	add    $0x10,%esp
801079eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801079ee:	74 0c                	je     801079fc <allocuvm+0x10c>
801079f0:	8b 55 10             	mov    0x10(%ebp),%edx
801079f3:	89 c1                	mov    %eax,%ecx
801079f5:	89 f8                	mov    %edi,%eax
801079f7:	e8 c4 f9 ff ff       	call   801073c0 <deallocuvm.part.0>
      kfree(mem);
801079fc:	83 ec 0c             	sub    $0xc,%esp
801079ff:	53                   	push   %ebx
80107a00:	e8 7b b0 ff ff       	call   80102a80 <kfree>
      return 0;
80107a05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107a0c:	83 c4 10             	add    $0x10,%esp
}
80107a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a20 <allocuvm_noswap>:
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	53                   	push   %ebx
80107a28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  page->pgdir = pgdir;
80107a2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a2e:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107a34:	6b c2 1c             	imul   $0x1c,%edx,%eax
  curproc->num_ram++;
80107a37:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107a3a:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107a3c:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a42:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107a45:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a4c:	00 00 00 
  page->swap_offset = -1;
80107a4f:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a56:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107a59:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107a5f:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
}
80107a65:	5b                   	pop    %ebx
80107a66:	5d                   	pop    %ebp
80107a67:	c3                   	ret    
80107a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6f:	90                   	nop

80107a70 <allocuvm_withswap>:
{
80107a70:	f3 0f 1e fb          	endbr32 
80107a74:	55                   	push   %ebp
80107a75:	89 e5                	mov    %esp,%ebp
80107a77:	57                   	push   %edi
80107a78:	56                   	push   %esi
80107a79:	53                   	push   %ebx
80107a7a:	83 ec 0c             	sub    $0xc,%esp
80107a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107a80:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107a87:	0f 8f 48 01 00 00    	jg     80107bd5 <allocuvm_withswap+0x165>
      int swap_offset = curproc->free_head->off;
80107a8d:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
      if(curproc->free_head->next == 0)
80107a93:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107a96:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107a98:	85 c0                	test   %eax,%eax
80107a9a:	0f 84 10 01 00 00    	je     80107bb0 <allocuvm_withswap+0x140>
        kfree((char*)curproc->free_head->prev);
80107aa0:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107aa3:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107aa9:	ff 70 08             	pushl  0x8(%eax)
80107aac:	e8 cf af ff ff       	call   80102a80 <kfree>
80107ab1:	83 c4 10             	add    $0x10,%esp
      cprintf("writing a page to swap\n");
80107ab4:	83 ec 0c             	sub    $0xc,%esp
80107ab7:	68 0c 97 10 80       	push   $0x8010970c
80107abc:	e8 ef 8b ff ff       	call   801006b0 <cprintf>
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107ac1:	68 00 10 00 00       	push   $0x1000
80107ac6:	56                   	push   %esi
80107ac7:	ff b3 84 03 00 00    	pushl  0x384(%ebx)
80107acd:	53                   	push   %ebx
80107ace:	e8 2d ab ff ff       	call   80102600 <writeToSwapFile>
80107ad3:	83 c4 20             	add    $0x20,%esp
80107ad6:	85 c0                	test   %eax,%eax
80107ad8:	0f 88 11 01 00 00    	js     80107bef <allocuvm_withswap+0x17f>
      curproc->swappedPages[curproc->num_swap].isused = 1;
80107ade:	8b 8b 0c 04 00 00    	mov    0x40c(%ebx),%ecx
80107ae4:	6b c1 1c             	imul   $0x1c,%ecx,%eax
80107ae7:	01 d8                	add    %ebx,%eax
80107ae9:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80107af0:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107af3:	8b 93 84 03 00 00    	mov    0x384(%ebx),%edx
80107af9:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107aff:	8b bb 7c 03 00 00    	mov    0x37c(%ebx),%edi
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107b05:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107b0b:	89 b8 88 00 00 00    	mov    %edi,0x88(%eax)
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107b11:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107b17:	0f 22 d8             	mov    %eax,%cr3
      curproc->num_swap ++;
80107b1a:	83 c1 01             	add    $0x1,%ecx
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b1d:	89 f8                	mov    %edi,%eax
      curproc->num_swap ++;
80107b1f:	89 8b 0c 04 00 00    	mov    %ecx,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b25:	31 c9                	xor    %ecx,%ecx
80107b27:	e8 84 f7 ff ff       	call   801072b0 <walkpgdir>
80107b2c:	89 c7                	mov    %eax,%edi
      if(!(*evicted_pte & PTE_P))
80107b2e:	8b 00                	mov    (%eax),%eax
80107b30:	a8 01                	test   $0x1,%al
80107b32:	0f 84 aa 00 00 00    	je     80107be2 <allocuvm_withswap+0x172>
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107b38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(P2V(evicted_pa)) == 1)
80107b3d:	83 ec 0c             	sub    $0xc,%esp
80107b40:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107b46:	56                   	push   %esi
80107b47:	e8 d4 b3 ff ff       	call   80102f20 <getRefs>
80107b4c:	83 c4 10             	add    $0x10,%esp
80107b4f:	83 f8 01             	cmp    $0x1,%eax
80107b52:	74 4c                	je     80107ba0 <allocuvm_withswap+0x130>
        refDec(P2V(evicted_pa));
80107b54:	83 ec 0c             	sub    $0xc,%esp
80107b57:	56                   	push   %esi
80107b58:	e8 e3 b2 ff ff       	call   80102e40 <refDec>
80107b5d:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80107b60:	8b 07                	mov    (%edi),%eax
80107b62:	25 fe 0f 00 00       	and    $0xffe,%eax
80107b67:	80 cc 02             	or     $0x2,%ah
80107b6a:	89 07                	mov    %eax,(%edi)
      newpage->pgdir = pgdir;
80107b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->isused = 1;
80107b6f:	c7 83 80 03 00 00 01 	movl   $0x1,0x380(%ebx)
80107b76:	00 00 00 
      newpage->pgdir = pgdir;
80107b79:	89 83 7c 03 00 00    	mov    %eax,0x37c(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80107b7f:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->swap_offset = -1;
80107b82:	c7 83 88 03 00 00 ff 	movl   $0xffffffff,0x388(%ebx)
80107b89:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
80107b8c:	89 83 84 03 00 00    	mov    %eax,0x384(%ebx)
}
80107b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b95:	5b                   	pop    %ebx
80107b96:	5e                   	pop    %esi
80107b97:	5f                   	pop    %edi
80107b98:	5d                   	pop    %ebp
80107b99:	c3                   	ret    
80107b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(P2V(evicted_pa));
80107ba0:	83 ec 0c             	sub    $0xc,%esp
80107ba3:	56                   	push   %esi
80107ba4:	e8 d7 ae ff ff       	call   80102a80 <kfree>
80107ba9:	83 c4 10             	add    $0x10,%esp
80107bac:	eb b2                	jmp    80107b60 <allocuvm_withswap+0xf0>
80107bae:	66 90                	xchg   %ax,%ax
        curproc->free_tail = 0;
80107bb0:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107bb7:	00 00 00 
        kfree((char*)curproc->free_head);
80107bba:	83 ec 0c             	sub    $0xc,%esp
80107bbd:	52                   	push   %edx
80107bbe:	e8 bd ae ff ff       	call   80102a80 <kfree>
        curproc->free_head = 0;
80107bc3:	83 c4 10             	add    $0x10,%esp
80107bc6:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107bcd:	00 00 00 
80107bd0:	e9 df fe ff ff       	jmp    80107ab4 <allocuvm_withswap+0x44>
        panic("page limit exceeded");
80107bd5:	83 ec 0c             	sub    $0xc,%esp
80107bd8:	68 f8 96 10 80       	push   $0x801096f8
80107bdd:	e8 ae 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107be2:	83 ec 0c             	sub    $0xc,%esp
80107be5:	68 60 98 10 80       	push   $0x80109860
80107bea:	e8 a1 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107bef:	83 ec 0c             	sub    $0xc,%esp
80107bf2:	68 24 97 10 80       	push   $0x80109724
80107bf7:	e8 94 87 ff ff       	call   80100390 <panic>
80107bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c00 <allocuvm_paging>:
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	56                   	push   %esi
80107c08:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107c0b:	8b 75 0c             	mov    0xc(%ebp),%esi
80107c0e:	53                   	push   %ebx
80107c0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107c12:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
80107c18:	83 fa 0f             	cmp    $0xf,%edx
80107c1b:	7f 33                	jg     80107c50 <allocuvm_paging+0x50>
  page->isused = 1;
80107c1d:	6b c2 1c             	imul   $0x1c,%edx,%eax
  curproc->num_ram++;
80107c20:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107c23:	01 c8                	add    %ecx,%eax
80107c25:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107c2c:	00 00 00 
  page->pgdir = pgdir;
80107c2f:	89 b0 48 02 00 00    	mov    %esi,0x248(%eax)
  page->swap_offset = -1;
80107c35:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107c3c:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107c3f:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107c45:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
}
80107c4b:	5b                   	pop    %ebx
80107c4c:	5e                   	pop    %esi
80107c4d:	5d                   	pop    %ebp
80107c4e:	c3                   	ret    
80107c4f:	90                   	nop
80107c50:	5b                   	pop    %ebx
80107c51:	5e                   	pop    %esi
80107c52:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107c53:	e9 18 fe ff ff       	jmp    80107a70 <allocuvm_withswap>
80107c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5f:	90                   	nop

80107c60 <update_selectionfiled_allocuvm>:
{
80107c60:	f3 0f 1e fb          	endbr32 
}
80107c64:	c3                   	ret    
80107c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c70 <deallocuvm>:
{
80107c70:	f3 0f 1e fb          	endbr32 
80107c74:	55                   	push   %ebp
80107c75:	89 e5                	mov    %esp,%ebp
80107c77:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107c80:	39 d1                	cmp    %edx,%ecx
80107c82:	73 0c                	jae    80107c90 <deallocuvm+0x20>
}
80107c84:	5d                   	pop    %ebp
80107c85:	e9 36 f7 ff ff       	jmp    801073c0 <deallocuvm.part.0>
80107c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c90:	89 d0                	mov    %edx,%eax
80107c92:	5d                   	pop    %ebp
80107c93:	c3                   	ret    
80107c94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c9f:	90                   	nop

80107ca0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ca0:	f3 0f 1e fb          	endbr32 
80107ca4:	55                   	push   %ebp
80107ca5:	89 e5                	mov    %esp,%ebp
80107ca7:	57                   	push   %edi
80107ca8:	56                   	push   %esi
80107ca9:	53                   	push   %ebx
80107caa:	83 ec 1c             	sub    $0x1c,%esp
80107cad:	8b 45 08             	mov    0x8(%ebp),%eax
80107cb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint i;

  if(pgdir == 0)
80107cb3:	85 c0                	test   %eax,%eax
80107cb5:	0f 84 83 00 00 00    	je     80107d3e <freevm+0x9e>
  if(newsz >= oldsz)
80107cbb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107cbe:	31 c9                	xor    %ecx,%ecx
80107cc0:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107cc5:	89 f8                	mov    %edi,%eax
80107cc7:	89 fb                	mov    %edi,%ebx
80107cc9:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80107ccf:	e8 ec f6 ff ff       	call   801073c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
  for(i = 0; i < NPDENTRIES; i++){
80107cd4:	eb 11                	jmp    80107ce7 <freevm+0x47>
80107cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cdd:	8d 76 00             	lea    0x0(%esi),%esi
80107ce0:	83 c3 04             	add    $0x4,%ebx
80107ce3:	39 de                	cmp    %ebx,%esi
80107ce5:	74 35                	je     80107d1c <freevm+0x7c>
    if(pgdir[i] & PTE_P){
80107ce7:	8b 03                	mov    (%ebx),%eax
80107ce9:	a8 01                	test   $0x1,%al
80107ceb:	74 f3                	je     80107ce0 <freevm+0x40>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(v) == 1)
80107cf2:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cf5:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
      if(getRefs(v) == 1)
80107cfb:	57                   	push   %edi
80107cfc:	e8 1f b2 ff ff       	call   80102f20 <getRefs>
80107d01:	83 c4 10             	add    $0x10,%esp
80107d04:	83 f8 01             	cmp    $0x1,%eax
80107d07:	74 27                	je     80107d30 <freevm+0x90>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107d09:	83 ec 0c             	sub    $0xc,%esp
80107d0c:	83 c3 04             	add    $0x4,%ebx
80107d0f:	57                   	push   %edi
80107d10:	e8 2b b1 ff ff       	call   80102e40 <refDec>
80107d15:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d18:	39 de                	cmp    %ebx,%esi
80107d1a:	75 cb                	jne    80107ce7 <freevm+0x47>
      }
    }
  }
  kfree((char*)pgdir);
80107d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d1f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107d22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d25:	5b                   	pop    %ebx
80107d26:	5e                   	pop    %esi
80107d27:	5f                   	pop    %edi
80107d28:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d29:	e9 52 ad ff ff       	jmp    80102a80 <kfree>
80107d2e:	66 90                	xchg   %ax,%ax
        kfree(v);
80107d30:	83 ec 0c             	sub    $0xc,%esp
80107d33:	57                   	push   %edi
80107d34:	e8 47 ad ff ff       	call   80102a80 <kfree>
80107d39:	83 c4 10             	add    $0x10,%esp
80107d3c:	eb a2                	jmp    80107ce0 <freevm+0x40>
    panic("freevm: no pgdir");
80107d3e:	83 ec 0c             	sub    $0xc,%esp
80107d41:	68 3e 97 10 80       	push   $0x8010973e
80107d46:	e8 45 86 ff ff       	call   80100390 <panic>
80107d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d4f:	90                   	nop

80107d50 <setupkvm>:
{
80107d50:	f3 0f 1e fb          	endbr32 
80107d54:	55                   	push   %ebp
80107d55:	89 e5                	mov    %esp,%ebp
80107d57:	56                   	push   %esi
80107d58:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107d59:	e8 22 b0 ff ff       	call   80102d80 <kalloc>
80107d5e:	89 c6                	mov    %eax,%esi
80107d60:	85 c0                	test   %eax,%eax
80107d62:	74 42                	je     80107da6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107d64:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d67:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d6c:	68 00 10 00 00       	push   $0x1000
80107d71:	6a 00                	push   $0x0
80107d73:	50                   	push   %eax
80107d74:	e8 87 d3 ff ff       	call   80105100 <memset>
80107d79:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d7c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d7f:	83 ec 08             	sub    $0x8,%esp
80107d82:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d85:	ff 73 0c             	pushl  0xc(%ebx)
80107d88:	8b 13                	mov    (%ebx),%edx
80107d8a:	50                   	push   %eax
80107d8b:	29 c1                	sub    %eax,%ecx
80107d8d:	89 f0                	mov    %esi,%eax
80107d8f:	e8 9c f5 ff ff       	call   80107330 <mappages>
80107d94:	83 c4 10             	add    $0x10,%esp
80107d97:	85 c0                	test   %eax,%eax
80107d99:	78 15                	js     80107db0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d9b:	83 c3 10             	add    $0x10,%ebx
80107d9e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107da4:	75 d6                	jne    80107d7c <setupkvm+0x2c>
}
80107da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107da9:	89 f0                	mov    %esi,%eax
80107dab:	5b                   	pop    %ebx
80107dac:	5e                   	pop    %esi
80107dad:	5d                   	pop    %ebp
80107dae:	c3                   	ret    
80107daf:	90                   	nop
      cprintf("mappages failed on setupkvm");
80107db0:	83 ec 0c             	sub    $0xc,%esp
80107db3:	68 4f 97 10 80       	push   $0x8010974f
80107db8:	e8 f3 88 ff ff       	call   801006b0 <cprintf>
      freevm(pgdir);
80107dbd:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107dc0:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107dc2:	e8 d9 fe ff ff       	call   80107ca0 <freevm>
      return 0;
80107dc7:	83 c4 10             	add    $0x10,%esp
}
80107dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107dcd:	89 f0                	mov    %esi,%eax
80107dcf:	5b                   	pop    %ebx
80107dd0:	5e                   	pop    %esi
80107dd1:	5d                   	pop    %ebp
80107dd2:	c3                   	ret    
80107dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107de0 <kvmalloc>:
{
80107de0:	f3 0f 1e fb          	endbr32 
80107de4:	55                   	push   %ebp
80107de5:	89 e5                	mov    %esp,%ebp
80107de7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dea:	e8 61 ff ff ff       	call   80107d50 <setupkvm>
80107def:	a3 a4 75 19 80       	mov    %eax,0x801975a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107df4:	05 00 00 00 80       	add    $0x80000000,%eax
80107df9:	0f 22 d8             	mov    %eax,%cr3
}
80107dfc:	c9                   	leave  
80107dfd:	c3                   	ret    
80107dfe:	66 90                	xchg   %ax,%ax

80107e00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e00:	f3 0f 1e fb          	endbr32 
80107e04:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e05:	31 c9                	xor    %ecx,%ecx
{
80107e07:	89 e5                	mov    %esp,%ebp
80107e09:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107e12:	e8 99 f4 ff ff       	call   801072b0 <walkpgdir>
  if(pte == 0)
80107e17:	85 c0                	test   %eax,%eax
80107e19:	74 05                	je     80107e20 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e1b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e1e:	c9                   	leave  
80107e1f:	c3                   	ret    
    panic("clearpteu");
80107e20:	83 ec 0c             	sub    $0xc,%esp
80107e23:	68 6b 97 10 80       	push   $0x8010976b
80107e28:	e8 63 85 ff ff       	call   80100390 <panic>
80107e2d:	8d 76 00             	lea    0x0(%esi),%esi

80107e30 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107e30:	f3 0f 1e fb          	endbr32 
80107e34:	55                   	push   %ebp
80107e35:	89 e5                	mov    %esp,%ebp
80107e37:	57                   	push   %edi
80107e38:	56                   	push   %esi
80107e39:	53                   	push   %ebx
80107e3a:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107e3d:	e8 0e ff ff ff       	call   80107d50 <setupkvm>
80107e42:	89 c6                	mov    %eax,%esi
80107e44:	85 c0                	test   %eax,%eax
80107e46:	0f 84 a9 00 00 00    	je     80107ef5 <cowuvm+0xc5>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80107e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e4f:	85 c0                	test   %eax,%eax
80107e51:	0f 84 a9 00 00 00    	je     80107f00 <cowuvm+0xd0>
80107e57:	31 ff                	xor    %edi,%edi
80107e59:	eb 29                	jmp    80107e84 <cowuvm+0x54>
80107e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e5f:	90                   	nop
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107e60:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107e63:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    refInc(virt_addr);
80107e69:	53                   	push   %ebx
80107e6a:	e8 41 b0 ff ff       	call   80102eb0 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107e6f:	0f 01 3f             	invlpg (%edi)
  for(i = 0; i < sz; i += PGSIZE)
80107e72:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107e78:	83 c4 10             	add    $0x10,%esp
80107e7b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107e7e:	0f 86 7c 00 00 00    	jbe    80107f00 <cowuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e84:	8b 45 08             	mov    0x8(%ebp),%eax
80107e87:	31 c9                	xor    %ecx,%ecx
80107e89:	89 fa                	mov    %edi,%edx
80107e8b:	e8 20 f4 ff ff       	call   801072b0 <walkpgdir>
80107e90:	85 c0                	test   %eax,%eax
80107e92:	0f 84 7e 00 00 00    	je     80107f16 <cowuvm+0xe6>
    *pte |= PTE_COW;
80107e98:	8b 08                	mov    (%eax),%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107e9a:	83 ec 08             	sub    $0x8,%esp
80107e9d:	89 fa                	mov    %edi,%edx
    *pte &= ~PTE_W; 
80107e9f:	89 cb                	mov    %ecx,%ebx
80107ea1:	83 e3 fd             	and    $0xfffffffd,%ebx
80107ea4:	80 cf 04             	or     $0x4,%bh
80107ea7:	89 18                	mov    %ebx,(%eax)
    pa = PTE_ADDR(*pte);
80107ea9:	89 cb                	mov    %ecx,%ebx
    flags = PTE_FLAGS(*pte);
80107eab:	81 e1 fd 0f 00 00    	and    $0xffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107eb1:	89 f0                	mov    %esi,%eax
    flags = PTE_FLAGS(*pte);
80107eb3:	80 cd 04             	or     $0x4,%ch
80107eb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ebc:	51                   	push   %ecx
80107ebd:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ec2:	53                   	push   %ebx
80107ec3:	e8 68 f4 ff ff       	call   80107330 <mappages>
80107ec8:	83 c4 10             	add    $0x10,%esp
80107ecb:	85 c0                	test   %eax,%eax
80107ecd:	79 91                	jns    80107e60 <cowuvm+0x30>
  }
  lcr3(V2P(pgdir));
  return d;

bad:
  cprintf("bad: cowuvm\n");
80107ecf:	83 ec 0c             	sub    $0xc,%esp
80107ed2:	68 84 97 10 80       	push   $0x80109784
80107ed7:	e8 d4 87 ff ff       	call   801006b0 <cprintf>
  freevm(d);
80107edc:	89 34 24             	mov    %esi,(%esp)
80107edf:	e8 bc fd ff ff       	call   80107ca0 <freevm>
  lcr3(V2P(pgdir));  // flush tlb
80107ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee7:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107eed:	0f 22 df             	mov    %edi,%cr3
  return 0;
80107ef0:	31 f6                	xor    %esi,%esi
80107ef2:	83 c4 10             	add    $0x10,%esp
}
80107ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ef8:	89 f0                	mov    %esi,%eax
80107efa:	5b                   	pop    %ebx
80107efb:	5e                   	pop    %esi
80107efc:	5f                   	pop    %edi
80107efd:	5d                   	pop    %ebp
80107efe:	c3                   	ret    
80107eff:	90                   	nop
  lcr3(V2P(pgdir));
80107f00:	8b 45 08             	mov    0x8(%ebp),%eax
80107f03:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
80107f09:	0f 22 df             	mov    %edi,%cr3
}
80107f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f0f:	89 f0                	mov    %esi,%eax
80107f11:	5b                   	pop    %ebx
80107f12:	5e                   	pop    %esi
80107f13:	5f                   	pop    %edi
80107f14:	5d                   	pop    %ebp
80107f15:	c3                   	ret    
      panic("cowuvm: no pte");
80107f16:	83 ec 0c             	sub    $0xc,%esp
80107f19:	68 75 97 10 80       	push   $0x80109775
80107f1e:	e8 6d 84 ff ff       	call   80100390 <panic>
80107f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f30 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80107f30:	f3 0f 1e fb          	endbr32 
80107f34:	55                   	push   %ebp
80107f35:	89 e5                	mov    %esp,%ebp
80107f37:	53                   	push   %ebx
80107f38:	83 ec 04             	sub    $0x4,%esp
80107f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107f3e:	e8 fd c2 ff ff       	call   80104240 <myproc>
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107f43:	31 d2                	xor    %edx,%edx
80107f45:	05 90 00 00 00       	add    $0x90,%eax
80107f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    if(curproc->swappedPages[i].virt_addr == va)
80107f50:	39 18                	cmp    %ebx,(%eax)
80107f52:	74 10                	je     80107f64 <getSwappedPageIndex+0x34>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107f54:	83 c2 01             	add    $0x1,%edx
80107f57:	83 c0 1c             	add    $0x1c,%eax
80107f5a:	83 fa 10             	cmp    $0x10,%edx
80107f5d:	75 f1                	jne    80107f50 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
80107f5f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80107f64:	83 c4 04             	add    $0x4,%esp
80107f67:	89 d0                	mov    %edx,%eax
80107f69:	5b                   	pop    %ebx
80107f6a:	5d                   	pop    %ebp
80107f6b:	c3                   	ret    
80107f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107f70 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc * curproc, pte_t* pte, char* va)
{
80107f70:	f3 0f 1e fb          	endbr32 
80107f74:	55                   	push   %ebp
80107f75:	89 e5                	mov    %esp,%ebp
80107f77:	57                   	push   %edi
80107f78:	56                   	push   %esi
80107f79:	53                   	push   %ebx
80107f7a:	83 ec 1c             	sub    $0x1c,%esp
80107f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f80:	8b 75 0c             	mov    0xc(%ebp),%esi
80107f83:	8b 55 10             	mov    0x10(%ebp),%edx
  uint err = curproc->tf->err;
80107f86:	8b 48 18             	mov    0x18(%eax),%ecx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80107f89:	f6 41 34 02          	testb  $0x2,0x34(%ecx)
80107f8d:	74 07                	je     80107f96 <handle_cow_pagefault+0x26>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
80107f8f:	8b 1e                	mov    (%esi),%ebx
80107f91:	f6 c7 04             	test   $0x4,%bh
80107f94:	75 12                	jne    80107fa8 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80107f96:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80107f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fa0:	5b                   	pop    %ebx
80107fa1:	5e                   	pop    %esi
80107fa2:	5f                   	pop    %edi
80107fa3:	5d                   	pop    %ebp
80107fa4:	c3                   	ret    
80107fa5:	8d 76 00             	lea    0x0(%esi),%esi
      pa = PTE_ADDR(*pte);
80107fa8:	89 df                	mov    %ebx,%edi
      ref_count = getRefs(virt_addr);
80107faa:	83 ec 0c             	sub    $0xc,%esp
80107fad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107fb0:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80107fb6:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
80107fbc:	57                   	push   %edi
80107fbd:	e8 5e af ff ff       	call   80102f20 <getRefs>
      if (ref_count > 1) // more than one reference
80107fc2:	83 c4 10             	add    $0x10,%esp
80107fc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fc8:	83 f8 01             	cmp    $0x1,%eax
80107fcb:	7f 1b                	jg     80107fe8 <handle_cow_pagefault+0x78>
        *pte &= ~PTE_COW; // turn COW off
80107fcd:	8b 06                	mov    (%esi),%eax
80107fcf:	80 e4 fb             	and    $0xfb,%ah
80107fd2:	83 c8 02             	or     $0x2,%eax
80107fd5:	89 06                	mov    %eax,(%esi)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107fd7:	0f 01 3a             	invlpg (%edx)
}
80107fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fdd:	5b                   	pop    %ebx
80107fde:	5e                   	pop    %esi
80107fdf:	5f                   	pop    %edi
80107fe0:	5d                   	pop    %ebp
80107fe1:	c3                   	ret    
80107fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107fe8:	89 55 e0             	mov    %edx,-0x20(%ebp)
      flags = PTE_FLAGS(*pte);
80107feb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        new_page = kalloc();
80107ff1:	e8 8a ad ff ff       	call   80102d80 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80107ff6:	83 ec 04             	sub    $0x4,%esp
80107ff9:	68 00 10 00 00       	push   $0x1000
80107ffe:	57                   	push   %edi
80107fff:	50                   	push   %eax
80108000:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108003:	e8 98 d1 ff ff       	call   801051a0 <memmove>
        new_pa = V2P(new_page);
80108008:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010800b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010800e:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108014:	09 cb                	or     %ecx,%ebx
80108016:	83 cb 03             	or     $0x3,%ebx
80108019:	89 1e                	mov    %ebx,(%esi)
8010801b:	0f 01 3a             	invlpg (%edx)
        refDec(virt_addr); // decrement old page's ref count
8010801e:	89 7d 08             	mov    %edi,0x8(%ebp)
80108021:	83 c4 10             	add    $0x10,%esp
}
80108024:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108027:	5b                   	pop    %ebx
80108028:	5e                   	pop    %esi
80108029:	5f                   	pop    %edi
8010802a:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
8010802b:	e9 10 ae ff ff       	jmp    80102e40 <refDec>

80108030 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
80108030:	f3 0f 1e fb          	endbr32 
80108034:	55                   	push   %ebp
80108035:	89 e5                	mov    %esp,%ebp
80108037:	57                   	push   %edi
80108038:	56                   	push   %esi
80108039:	53                   	push   %ebx
8010803a:	83 ec 20             	sub    $0x20,%esp
8010803d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108040:	8b 7d 10             	mov    0x10(%ebp),%edi
80108043:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108046:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108049:	ff 73 10             	pushl  0x10(%ebx)
8010804c:	50                   	push   %eax
8010804d:	68 88 98 10 80       	push   $0x80109888
80108052:	e8 59 86 ff ff       	call   801006b0 <cprintf>

    new_page = kalloc();
80108057:	e8 24 ad ff ff       	call   80102d80 <kalloc>
8010805c:	89 c2                	mov    %eax,%edx
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
    *pte |= V2P(new_page);
8010805e:	8b 07                	mov    (%edi),%eax
80108060:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108066:	25 ff 0d 00 00       	and    $0xdff,%eax
8010806b:	09 d0                	or     %edx,%eax
8010806d:	83 c8 07             	or     $0x7,%eax
80108070:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108072:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
80108074:	e8 c7 c1 ff ff       	call   80104240 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108079:	83 c4 10             	add    $0x10,%esp
8010807c:	05 90 00 00 00       	add    $0x90,%eax
80108081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->swappedPages[i].virt_addr == va)
80108088:	3b 30                	cmp    (%eax),%esi
8010808a:	0f 84 b8 01 00 00    	je     80108248 <handle_pagedout+0x218>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108090:	83 c7 01             	add    $0x1,%edi
80108093:	83 c0 1c             	add    $0x1c,%eax
80108096:	83 ff 10             	cmp    $0x10,%edi
80108099:	75 ed                	jne    80108088 <handle_pagedout+0x58>
8010809b:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
801080a0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
801080a5:	01 d8                	add    %ebx,%eax

    

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801080a7:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
801080ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801080af:	6b c7 1c             	imul   $0x1c,%edi,%eax
801080b2:	01 d8                	add    %ebx,%eax
801080b4:	ff b0 94 00 00 00    	pushl  0x94(%eax)
801080ba:	68 00 c6 10 80       	push   $0x8010c600
801080bf:	53                   	push   %ebx
801080c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080c3:	e8 88 a5 ff ff       	call   80102650 <readFromSwapFile>
801080c8:	83 c4 10             	add    $0x10,%esp
801080cb:	85 c0                	test   %eax,%eax
801080cd:	0f 88 2b 02 00 00    	js     801082fe <handle_pagedout+0x2ce>
      panic("allocuvm: readFromSwapFile1");

    struct fblock *new_block = (struct fblock*)kalloc();
801080d3:	e8 a8 ac ff ff       	call   80102d80 <kalloc>
    new_block->off = swap_page->swap_offset;
801080d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801080db:	8b 89 94 00 00 00    	mov    0x94(%ecx),%ecx
    new_block->next = 0;
801080e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
801080e8:	89 08                	mov    %ecx,(%eax)
    new_block->prev = curproc->free_tail;
801080ea:	8b 8b 18 04 00 00    	mov    0x418(%ebx),%ecx
801080f0:	89 48 08             	mov    %ecx,0x8(%eax)

    if(curproc->free_tail != 0)
801080f3:	85 c9                	test   %ecx,%ecx
801080f5:	0f 84 d5 01 00 00    	je     801082d0 <handle_pagedout+0x2a0>
      curproc->free_tail->next = new_block;
801080fb:	89 41 04             	mov    %eax,0x4(%ecx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
801080fe:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80108101:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108107:	68 00 10 00 00       	push   $0x1000
8010810c:	68 00 c6 10 80       	push   $0x8010c600
80108111:	56                   	push   %esi
80108112:	e8 89 d0 ff ff       	call   801051a0 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
80108117:	83 c4 0c             	add    $0xc,%esp
8010811a:	6a 1c                	push   $0x1c
8010811c:	6a 00                	push   $0x0
8010811e:	ff 75 e4             	pushl  -0x1c(%ebp)
80108121:	e8 da cf ff ff       	call   80105100 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108126:	83 c4 10             	add    $0x10,%esp
80108129:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
80108130:	0f 8e 22 01 00 00    	jle    80108258 <handle_pagedout+0x228>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
80108136:	8b 8b 14 04 00 00    	mov    0x414(%ebx),%ecx
8010813c:	8b 01                	mov    (%ecx),%eax
8010813e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
80108141:	8b 41 04             	mov    0x4(%ecx),%eax
80108144:	85 c0                	test   %eax,%eax
80108146:	0f 84 d4 00 00 00    	je     80108220 <handle_pagedout+0x1f0>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
8010814c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
8010814f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108155:	ff 70 08             	pushl  0x8(%eax)
80108158:	e8 23 a9 ff ff       	call   80102a80 <kfree>
8010815d:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108160:	68 00 10 00 00       	push   $0x1000
80108165:	ff 75 e4             	pushl  -0x1c(%ebp)
80108168:	ff b3 84 03 00 00    	pushl  0x384(%ebx)
8010816e:	53                   	push   %ebx
8010816f:	e8 8c a4 ff ff       	call   80102600 <writeToSwapFile>
80108174:	83 c4 10             	add    $0x10,%esp
80108177:	85 c0                	test   %eax,%eax
80108179:	0f 88 8c 01 00 00    	js     8010830b <handle_pagedout+0x2db>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
8010817f:	6b d7 1c             	imul   $0x1c,%edi,%edx
80108182:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
80108188:	01 da                	add    %ebx,%edx
8010818a:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
      swap_page->pgdir = ram_page->pgdir;
80108190:	8b 8b 7c 03 00 00    	mov    0x37c(%ebx),%ecx
      swap_page->isused = 1;
80108196:	c7 82 8c 00 00 00 01 	movl   $0x1,0x8c(%edx)
8010819d:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
801081a0:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
      swap_page->swap_offset = swap_offset;
801081a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801081a9:	89 8a 94 00 00 00    	mov    %ecx,0x94(%edx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
801081af:	8b 7b 04             	mov    0x4(%ebx),%edi
801081b2:	89 c2                	mov    %eax,%edx
801081b4:	31 c9                	xor    %ecx,%ecx
801081b6:	89 f8                	mov    %edi,%eax
801081b8:	e8 f3 f0 ff ff       	call   801072b0 <walkpgdir>
801081bd:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
801081bf:	8b 00                	mov    (%eax),%eax
801081c1:	a8 01                	test   $0x1,%al
801081c3:	0f 84 28 01 00 00    	je     801082f1 <handle_pagedout+0x2c1>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
801081c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      

       if(getRefs(P2V(ramPa)) == 1)
801081ce:	83 ec 0c             	sub    $0xc,%esp
801081d1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801081d7:	52                   	push   %edx
801081d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801081db:	e8 40 ad ff ff       	call   80102f20 <getRefs>
801081e0:	83 c4 10             	add    $0x10,%esp
801081e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081e6:	83 f8 01             	cmp    $0x1,%eax
801081e9:	0f 84 f1 00 00 00    	je     801082e0 <handle_pagedout+0x2b0>
      {
           kfree(P2V(ramPa));
      }
      else
      {
           refDec(P2V(ramPa));
801081ef:	83 ec 0c             	sub    $0xc,%esp
801081f2:	52                   	push   %edx
801081f3:	e8 48 ac ff ff       	call   80102e40 <refDec>
801081f8:	83 c4 10             	add    $0x10,%esp
      
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
801081fb:	8b 07                	mov    (%edi),%eax
801081fd:	25 fe 0f 00 00       	and    $0xffe,%eax
80108202:	80 cc 02             	or     $0x2,%ah
80108205:	89 07                	mov    %eax,(%edi)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108207:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
8010820a:	89 b3 84 03 00 00    	mov    %esi,0x384(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108210:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108215:	0f 22 d8             	mov    %eax,%cr3
    }
    return;
}
80108218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010821b:	5b                   	pop    %ebx
8010821c:	5e                   	pop    %esi
8010821d:	5f                   	pop    %edi
8010821e:	5d                   	pop    %ebp
8010821f:	c3                   	ret    
        curproc->free_tail = 0;
80108220:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108227:	00 00 00 
        kfree((char*)curproc->free_head);
8010822a:	83 ec 0c             	sub    $0xc,%esp
8010822d:	51                   	push   %ecx
8010822e:	e8 4d a8 ff ff       	call   80102a80 <kfree>
        curproc->free_head = 0;
80108233:	83 c4 10             	add    $0x10,%esp
80108236:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
8010823d:	00 00 00 
80108240:	e9 1b ff ff ff       	jmp    80108160 <handle_pagedout+0x130>
80108245:	8d 76 00             	lea    0x0(%esi),%esi
80108248:	6b c7 1c             	imul   $0x1c,%edi,%eax
8010824b:	05 88 00 00 00       	add    $0x88,%eax
80108250:	e9 50 fe ff ff       	jmp    801080a5 <handle_pagedout+0x75>
80108255:	8d 76 00             	lea    0x0(%esi),%esi

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80108258:	e8 e3 bf ff ff       	call   80104240 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
8010825d:	31 ff                	xor    %edi,%edi
8010825f:	05 4c 02 00 00       	add    $0x24c,%eax
80108264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108268:	8b 10                	mov    (%eax),%edx
8010826a:	85 d2                	test   %edx,%edx
8010826c:	74 10                	je     8010827e <handle_pagedout+0x24e>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
8010826e:	83 c7 01             	add    $0x1,%edi
80108271:	83 c0 1c             	add    $0x1c,%eax
80108274:	83 ff 10             	cmp    $0x10,%edi
80108277:	75 ef                	jne    80108268 <handle_pagedout+0x238>
      return i;
  }
  return -1;
80108279:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010827e:	83 ec 08             	sub    $0x8,%esp
80108281:	57                   	push   %edi
      curproc->ramPages[new_indx].virt_addr = start_page;
80108282:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
80108285:	68 ad 97 10 80       	push   $0x801097ad
      curproc->ramPages[new_indx].virt_addr = start_page;
8010828a:	01 df                	add    %ebx,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010828c:	e8 1f 84 ff ff       	call   801006b0 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
80108291:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
80108297:	83 c4 10             	add    $0x10,%esp
8010829a:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
801082a1:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801082a4:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
801082a7:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
801082ae:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801082b1:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
801082b7:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
801082be:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
801082c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c8:	5b                   	pop    %ebx
801082c9:	5e                   	pop    %esi
801082ca:	5f                   	pop    %edi
801082cb:	5d                   	pop    %ebp
801082cc:	c3                   	ret    
801082cd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->free_head = new_block;
801082d0:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
801082d6:	e9 23 fe ff ff       	jmp    801080fe <handle_pagedout+0xce>
801082db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082df:	90                   	nop
           kfree(P2V(ramPa));
801082e0:	83 ec 0c             	sub    $0xc,%esp
801082e3:	52                   	push   %edx
801082e4:	e8 97 a7 ff ff       	call   80102a80 <kfree>
801082e9:	83 c4 10             	add    $0x10,%esp
801082ec:	e9 0a ff ff ff       	jmp    801081fb <handle_pagedout+0x1cb>
        panic("pagefault: ram page is not present");
801082f1:	83 ec 0c             	sub    $0xc,%esp
801082f4:	68 b8 98 10 80       	push   $0x801098b8
801082f9:	e8 92 80 ff ff       	call   80100390 <panic>
      panic("allocuvm: readFromSwapFile1");
801082fe:	83 ec 0c             	sub    $0xc,%esp
80108301:	68 91 97 10 80       	push   $0x80109791
80108306:	e8 85 80 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
8010830b:	83 ec 0c             	sub    $0xc,%esp
8010830e:	68 24 97 10 80       	push   $0x80109724
80108313:	e8 78 80 ff ff       	call   80100390 <panic>
80108318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010831f:	90                   	nop

80108320 <pagefault>:
{
80108320:	f3 0f 1e fb          	endbr32 
80108324:	55                   	push   %ebp
80108325:	89 e5                	mov    %esp,%ebp
80108327:	57                   	push   %edi
80108328:	56                   	push   %esi
80108329:	53                   	push   %ebx
8010832a:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
8010832d:	e8 0e bf ff ff       	call   80104240 <myproc>
80108332:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108334:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108337:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010833e:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108340:	8b 40 04             	mov    0x4(%eax),%eax
80108343:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108345:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
8010834b:	89 fa                	mov    %edi,%edx
8010834d:	e8 5e ef ff ff       	call   801072b0 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
80108352:	8b 10                	mov    (%eax),%edx
80108354:	81 e2 00 06 00 00    	and    $0x600,%edx
8010835a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80108360:	74 4e                	je     801083b0 <pagefault+0x90>
    if(va >= KERNBASE || pte == 0)
80108362:	85 f6                	test   %esi,%esi
80108364:	78 1a                	js     80108380 <pagefault+0x60>
    handle_cow_pagefault(curproc, pte, start_page);
80108366:	83 ec 04             	sub    $0x4,%esp
80108369:	57                   	push   %edi
8010836a:	50                   	push   %eax
8010836b:	53                   	push   %ebx
8010836c:	e8 ff fb ff ff       	call   80107f70 <handle_cow_pagefault>
80108371:	83 c4 10             	add    $0x10,%esp
}
80108374:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108377:	5b                   	pop    %ebx
80108378:	5e                   	pop    %esi
80108379:	5f                   	pop    %edi
8010837a:	5d                   	pop    %ebp
8010837b:	c3                   	ret    
8010837c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108380:	83 ec 04             	sub    $0x4,%esp
80108383:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108386:	50                   	push   %eax
80108387:	ff 73 10             	pushl  0x10(%ebx)
8010838a:	68 dc 98 10 80       	push   $0x801098dc
8010838f:	e8 1c 83 ff ff       	call   801006b0 <cprintf>
      curproc->killed = 1;
80108394:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
8010839b:	83 c4 10             	add    $0x10,%esp
}
8010839e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083a1:	5b                   	pop    %ebx
801083a2:	5e                   	pop    %esi
801083a3:	5f                   	pop    %edi
801083a4:	5d                   	pop    %ebp
801083a5:	c3                   	ret    
801083a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083ad:	8d 76 00             	lea    0x0(%esi),%esi
      handle_pagedout(curproc, start_page, pte);
801083b0:	83 ec 04             	sub    $0x4,%esp
801083b3:	50                   	push   %eax
801083b4:	57                   	push   %edi
801083b5:	53                   	push   %ebx
801083b6:	e8 75 fc ff ff       	call   80108030 <handle_pagedout>
801083bb:	83 c4 10             	add    $0x10,%esp
}
801083be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083c1:	5b                   	pop    %ebx
801083c2:	5e                   	pop    %esi
801083c3:	5f                   	pop    %edi
801083c4:	5d                   	pop    %ebp
801083c5:	c3                   	ret    
801083c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083cd:	8d 76 00             	lea    0x0(%esi),%esi

801083d0 <update_selectionfiled_pagefault>:
801083d0:	f3 0f 1e fb          	endbr32 
801083d4:	c3                   	ret    
801083d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801083e0 <copyuvm>:
{
801083e0:	f3 0f 1e fb          	endbr32 
801083e4:	55                   	push   %ebp
801083e5:	89 e5                	mov    %esp,%ebp
801083e7:	57                   	push   %edi
801083e8:	56                   	push   %esi
801083e9:	53                   	push   %ebx
801083ea:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801083ed:	e8 5e f9 ff ff       	call   80107d50 <setupkvm>
801083f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083f5:	85 c0                	test   %eax,%eax
801083f7:	0f 84 a6 00 00 00    	je     801084a3 <copyuvm+0xc3>
  for(i = 0; i < sz; i += PGSIZE){
801083fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80108400:	85 db                	test   %ebx,%ebx
80108402:	0f 84 9b 00 00 00    	je     801084a3 <copyuvm+0xc3>
80108408:	31 f6                	xor    %esi,%esi
8010840a:	eb 46                	jmp    80108452 <copyuvm+0x72>
8010840c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108410:	83 ec 04             	sub    $0x4,%esp
80108413:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108419:	68 00 10 00 00       	push   $0x1000
8010841e:	57                   	push   %edi
8010841f:	50                   	push   %eax
80108420:	e8 7b cd ff ff       	call   801051a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108425:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010842b:	5a                   	pop    %edx
8010842c:	59                   	pop    %ecx
8010842d:	ff 75 e4             	pushl  -0x1c(%ebp)
80108430:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108435:	89 f2                	mov    %esi,%edx
80108437:	50                   	push   %eax
80108438:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010843b:	e8 f0 ee ff ff       	call   80107330 <mappages>
80108440:	83 c4 10             	add    $0x10,%esp
80108443:	85 c0                	test   %eax,%eax
80108445:	78 69                	js     801084b0 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80108447:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010844d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108450:	76 51                	jbe    801084a3 <copyuvm+0xc3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108452:	8b 45 08             	mov    0x8(%ebp),%eax
80108455:	31 c9                	xor    %ecx,%ecx
80108457:	89 f2                	mov    %esi,%edx
80108459:	e8 52 ee ff ff       	call   801072b0 <walkpgdir>
8010845e:	85 c0                	test   %eax,%eax
80108460:	74 69                	je     801084cb <copyuvm+0xeb>
    if(!(*pte & PTE_P))
80108462:	8b 00                	mov    (%eax),%eax
80108464:	a8 01                	test   $0x1,%al
80108466:	74 56                	je     801084be <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80108468:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010846a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010846f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108472:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108478:	e8 03 a9 ff ff       	call   80102d80 <kalloc>
8010847d:	89 c3                	mov    %eax,%ebx
8010847f:	85 c0                	test   %eax,%eax
80108481:	75 8d                	jne    80108410 <copyuvm+0x30>
  cprintf("bad: copyuvm\n");
80108483:	83 ec 0c             	sub    $0xc,%esp
80108486:	68 f7 97 10 80       	push   $0x801097f7
8010848b:	e8 20 82 ff ff       	call   801006b0 <cprintf>
  freevm(d);
80108490:	58                   	pop    %eax
80108491:	ff 75 e0             	pushl  -0x20(%ebp)
80108494:	e8 07 f8 ff ff       	call   80107ca0 <freevm>
  return 0;
80108499:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801084a0:	83 c4 10             	add    $0x10,%esp
}
801084a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084a9:	5b                   	pop    %ebx
801084aa:	5e                   	pop    %esi
801084ab:	5f                   	pop    %edi
801084ac:	5d                   	pop    %ebp
801084ad:	c3                   	ret    
801084ae:	66 90                	xchg   %ax,%ax
      kfree(mem);
801084b0:	83 ec 0c             	sub    $0xc,%esp
801084b3:	53                   	push   %ebx
801084b4:	e8 c7 a5 ff ff       	call   80102a80 <kfree>
      goto bad;
801084b9:	83 c4 10             	add    $0x10,%esp
801084bc:	eb c5                	jmp    80108483 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801084be:	83 ec 0c             	sub    $0xc,%esp
801084c1:	68 dd 97 10 80       	push   $0x801097dd
801084c6:	e8 c5 7e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801084cb:	83 ec 0c             	sub    $0xc,%esp
801084ce:	68 c3 97 10 80       	push   $0x801097c3
801084d3:	e8 b8 7e ff ff       	call   80100390 <panic>
801084d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084df:	90                   	nop

801084e0 <uva2ka>:
{
801084e0:	f3 0f 1e fb          	endbr32 
801084e4:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801084e5:	31 c9                	xor    %ecx,%ecx
{
801084e7:	89 e5                	mov    %esp,%ebp
801084e9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801084ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ef:	8b 45 08             	mov    0x8(%ebp),%eax
801084f2:	e8 b9 ed ff ff       	call   801072b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801084f7:	8b 00                	mov    (%eax),%eax
}
801084f9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801084fa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801084fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108501:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108504:	05 00 00 00 80       	add    $0x80000000,%eax
80108509:	83 fa 05             	cmp    $0x5,%edx
8010850c:	ba 00 00 00 00       	mov    $0x0,%edx
80108511:	0f 45 c2             	cmovne %edx,%eax
}
80108514:	c3                   	ret    
80108515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010851c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108520 <copyout>:
{
80108520:	f3 0f 1e fb          	endbr32 
80108524:	55                   	push   %ebp
80108525:	89 e5                	mov    %esp,%ebp
80108527:	57                   	push   %edi
80108528:	56                   	push   %esi
80108529:	53                   	push   %ebx
8010852a:	83 ec 0c             	sub    $0xc,%esp
8010852d:	8b 75 14             	mov    0x14(%ebp),%esi
80108530:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(len > 0){
80108533:	85 f6                	test   %esi,%esi
80108535:	75 3c                	jne    80108573 <copyout+0x53>
80108537:	eb 67                	jmp    801085a0 <copyout+0x80>
80108539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108540:	8b 55 0c             	mov    0xc(%ebp),%edx
80108543:	89 fb                	mov    %edi,%ebx
80108545:	29 d3                	sub    %edx,%ebx
80108547:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010854d:	39 f3                	cmp    %esi,%ebx
8010854f:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108552:	29 fa                	sub    %edi,%edx
80108554:	83 ec 04             	sub    $0x4,%esp
80108557:	01 c2                	add    %eax,%edx
80108559:	53                   	push   %ebx
8010855a:	ff 75 10             	pushl  0x10(%ebp)
8010855d:	52                   	push   %edx
8010855e:	e8 3d cc ff ff       	call   801051a0 <memmove>
    buf += n;
80108563:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108566:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010856c:	83 c4 10             	add    $0x10,%esp
8010856f:	29 de                	sub    %ebx,%esi
80108571:	74 2d                	je     801085a0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108573:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108575:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108578:	89 55 0c             	mov    %edx,0xc(%ebp)
8010857b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108581:	57                   	push   %edi
80108582:	ff 75 08             	pushl  0x8(%ebp)
80108585:	e8 56 ff ff ff       	call   801084e0 <uva2ka>
    if(pa0 == 0)
8010858a:	83 c4 10             	add    $0x10,%esp
8010858d:	85 c0                	test   %eax,%eax
8010858f:	75 af                	jne    80108540 <copyout+0x20>
}
80108591:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108599:	5b                   	pop    %ebx
8010859a:	5e                   	pop    %esi
8010859b:	5f                   	pop    %edi
8010859c:	5d                   	pop    %ebp
8010859d:	c3                   	ret    
8010859e:	66 90                	xchg   %ax,%ax
801085a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801085a3:	31 c0                	xor    %eax,%eax
}
801085a5:	5b                   	pop    %ebx
801085a6:	5e                   	pop    %esi
801085a7:	5f                   	pop    %edi
801085a8:	5d                   	pop    %ebp
801085a9:	c3                   	ret    
801085aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801085b0 <getNextFreeRamIndex>:
{ 
801085b0:	f3 0f 1e fb          	endbr32 
801085b4:	55                   	push   %ebp
801085b5:	89 e5                	mov    %esp,%ebp
801085b7:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
801085ba:	e8 81 bc ff ff       	call   80104240 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801085bf:	31 d2                	xor    %edx,%edx
801085c1:	05 4c 02 00 00       	add    $0x24c,%eax
801085c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(((struct page)currproc->ramPages[i]).isused == 0)
801085d0:	8b 08                	mov    (%eax),%ecx
801085d2:	85 c9                	test   %ecx,%ecx
801085d4:	74 10                	je     801085e6 <getNextFreeRamIndex+0x36>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801085d6:	83 c2 01             	add    $0x1,%edx
801085d9:	83 c0 1c             	add    $0x1c,%eax
801085dc:	83 fa 10             	cmp    $0x10,%edx
801085df:	75 ef                	jne    801085d0 <getNextFreeRamIndex+0x20>
  return -1;
801085e1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
801085e6:	c9                   	leave  
801085e7:	89 d0                	mov    %edx,%eax
801085e9:	c3                   	ret    
801085ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801085f0 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
801085f0:	f3 0f 1e fb          	endbr32 
801085f4:	55                   	push   %ebp
801085f5:	89 e5                	mov    %esp,%ebp
801085f7:	56                   	push   %esi
801085f8:	8b 75 08             	mov    0x8(%ebp),%esi
801085fb:	53                   	push   %ebx
801085fc:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108602:	81 c6 08 04 00 00    	add    $0x408,%esi
80108608:	eb 19                	jmp    80108623 <updateLapa+0x33>
8010860a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108610:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108616:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108619:	83 20 df             	andl   $0xffffffdf,(%eax)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010861c:	83 c3 1c             	add    $0x1c,%ebx
8010861f:	39 f3                	cmp    %esi,%ebx
80108621:	74 2b                	je     8010864e <updateLapa+0x5e>
    if(!cur_page->isused)
80108623:	8b 43 04             	mov    0x4(%ebx),%eax
80108626:	85 c0                	test   %eax,%eax
80108628:	74 f2                	je     8010861c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010862a:	8b 53 08             	mov    0x8(%ebx),%edx
8010862d:	8b 03                	mov    (%ebx),%eax
8010862f:	31 c9                	xor    %ecx,%ecx
80108631:	e8 7a ec ff ff       	call   801072b0 <walkpgdir>
80108636:	85 c0                	test   %eax,%eax
80108638:	74 1b                	je     80108655 <updateLapa+0x65>
    if(*pte & PTE_A) // if accessed
8010863a:	8b 53 18             	mov    0x18(%ebx),%edx
8010863d:	d1 ea                	shr    %edx
8010863f:	f6 00 20             	testb  $0x20,(%eax)
80108642:	75 cc                	jne    80108610 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
80108644:	89 53 18             	mov    %edx,0x18(%ebx)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108647:	83 c3 1c             	add    $0x1c,%ebx
8010864a:	39 f3                	cmp    %esi,%ebx
8010864c:	75 d5                	jne    80108623 <updateLapa+0x33>
    }
  }
}
8010864e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108651:	5b                   	pop    %ebx
80108652:	5e                   	pop    %esi
80108653:	5d                   	pop    %ebp
80108654:	c3                   	ret    
      panic("updateLapa: no pte");
80108655:	83 ec 0c             	sub    $0xc,%esp
80108658:	68 05 98 10 80       	push   $0x80109805
8010865d:	e8 2e 7d ff ff       	call   80100390 <panic>
80108662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108670 <updateNfua>:

void updateNfua(struct proc* p)
{
80108670:	f3 0f 1e fb          	endbr32 
80108674:	55                   	push   %ebp
80108675:	89 e5                	mov    %esp,%ebp
80108677:	56                   	push   %esi
80108678:	8b 75 08             	mov    0x8(%ebp),%esi
8010867b:	53                   	push   %ebx
8010867c:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108682:	81 c6 08 04 00 00    	add    $0x408,%esi
80108688:	eb 19                	jmp    801086a3 <updateNfua+0x33>
8010868a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108690:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108696:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108699:	83 20 df             	andl   $0xffffffdf,(%eax)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010869c:	83 c3 1c             	add    $0x1c,%ebx
8010869f:	39 f3                	cmp    %esi,%ebx
801086a1:	74 2b                	je     801086ce <updateNfua+0x5e>
    if(!cur_page->isused)
801086a3:	8b 43 04             	mov    0x4(%ebx),%eax
801086a6:	85 c0                	test   %eax,%eax
801086a8:	74 f2                	je     8010869c <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
801086aa:	8b 53 08             	mov    0x8(%ebx),%edx
801086ad:	8b 03                	mov    (%ebx),%eax
801086af:	31 c9                	xor    %ecx,%ecx
801086b1:	e8 fa eb ff ff       	call   801072b0 <walkpgdir>
801086b6:	85 c0                	test   %eax,%eax
801086b8:	74 1b                	je     801086d5 <updateNfua+0x65>
    if(*pte & PTE_A) // if accessed
801086ba:	8b 53 14             	mov    0x14(%ebx),%edx
801086bd:	d1 ea                	shr    %edx
801086bf:	f6 00 20             	testb  $0x20,(%eax)
801086c2:	75 cc                	jne    80108690 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
801086c4:	89 53 14             	mov    %edx,0x14(%ebx)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801086c7:	83 c3 1c             	add    $0x1c,%ebx
801086ca:	39 f3                	cmp    %esi,%ebx
801086cc:	75 d5                	jne    801086a3 <updateNfua+0x33>
    }
  }
}
801086ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801086d1:	5b                   	pop    %ebx
801086d2:	5e                   	pop    %esi
801086d3:	5d                   	pop    %ebp
801086d4:	c3                   	ret    
      panic("updateNfua: no pte");
801086d5:	83 ec 0c             	sub    $0xc,%esp
801086d8:	68 18 98 10 80       	push   $0x80109818
801086dd:	e8 ae 7c ff ff       	call   80100390 <panic>
801086e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801086f0 <indexToEvict>:
uint indexToEvict()
{  
801086f0:	f3 0f 1e fb          	endbr32 
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
801086f4:	b8 0b 00 00 00       	mov    $0xb,%eax
801086f9:	c3                   	ret    
801086fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108700 <aq>:

uint aq()
{
80108700:	f3 0f 1e fb          	endbr32 
80108704:	55                   	push   %ebp
80108705:	89 e5                	mov    %esp,%ebp
80108707:	57                   	push   %edi
80108708:	56                   	push   %esi
80108709:	53                   	push   %ebx
8010870a:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
8010870d:	e8 2e bb ff ff       	call   80104240 <myproc>
80108712:	89 c3                	mov    %eax,%ebx
  int res = curproc->queue_tail->page_index;
80108714:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
8010871a:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
  int res = curproc->queue_tail->page_index;
80108720:	8b 78 08             	mov    0x8(%eax),%edi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108723:	85 d2                	test   %edx,%edx
80108725:	74 47                	je     8010876e <aq+0x6e>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108727:	39 d0                	cmp    %edx,%eax
80108729:	74 35                	je     80108760 <aq+0x60>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
8010872b:	8b 40 04             	mov    0x4(%eax),%eax
8010872e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108734:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
8010873a:	8b 70 04             	mov    0x4(%eax),%esi
  }

  kfree((char*)curproc->queue_tail);
8010873d:	83 ec 0c             	sub    $0xc,%esp
80108740:	50                   	push   %eax
80108741:	e8 3a a3 ff ff       	call   80102a80 <kfree>
  curproc->queue_tail = new_tail;
80108746:	89 b3 20 04 00 00    	mov    %esi,0x420(%ebx)
  
  return  res;


}
8010874c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010874f:	89 f8                	mov    %edi,%eax
80108751:	5b                   	pop    %ebx
80108752:	5e                   	pop    %esi
80108753:	5f                   	pop    %edi
80108754:	5d                   	pop    %ebp
80108755:	c3                   	ret    
80108756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010875d:	8d 76 00             	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108760:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80108767:	00 00 00 
    new_tail = 0;
8010876a:	31 f6                	xor    %esi,%esi
8010876c:	eb cf                	jmp    8010873d <aq+0x3d>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
8010876e:	83 ec 0c             	sub    $0xc,%esp
80108771:	68 10 99 10 80       	push   $0x80109910
80108776:	e8 15 7c ff ff       	call   80100390 <panic>
8010877b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010877f:	90                   	nop

80108780 <lapa>:
uint lapa()
{
80108780:	f3 0f 1e fb          	endbr32 
80108784:	55                   	push   %ebp
80108785:	89 e5                	mov    %esp,%ebp
80108787:	57                   	push   %edi
80108788:	56                   	push   %esi
80108789:	53                   	push   %ebx
8010878a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010878d:	e8 ae ba ff ff       	call   80104240 <myproc>
80108792:	89 c1                	mov    %eax,%ecx
  struct page *ramPages = curproc->ramPages;
80108794:	05 48 02 00 00       	add    $0x248,%eax
80108799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
8010879c:	8b 81 60 02 00 00    	mov    0x260(%ecx),%eax
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
801087a2:	85 c0                	test   %eax,%eax
801087a4:	0f 84 df 00 00 00    	je     80108889 <lapa+0x109>
    uint count = 0;
801087aa:	31 d2                	xor    %edx,%edx
801087ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
801087b0:	89 c3                	mov    %eax,%ebx
801087b2:	83 e3 01             	and    $0x1,%ebx
801087b5:	01 da                	add    %ebx,%edx
    while (n) {
801087b7:	d1 e8                	shr    %eax
801087b9:	75 f5                	jne    801087b0 <lapa+0x30>
801087bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801087be:	8d 81 7c 02 00 00    	lea    0x27c(%ecx),%eax
  uint minloc = 0;
801087c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  uint instances = 0;
801087cb:	31 ff                	xor    %edi,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
801087cd:	bb 01 00 00 00       	mov    $0x1,%ebx
801087d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uint count = 0;
801087d5:	89 c6                	mov    %eax,%esi
801087d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087de:	66 90                	xchg   %ax,%ax
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
801087e0:	8b 06                	mov    (%esi),%eax
    uint count = 0;
801087e2:	31 d2                	xor    %edx,%edx
    while (n) {
801087e4:	85 c0                	test   %eax,%eax
801087e6:	74 13                	je     801087fb <lapa+0x7b>
801087e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087ef:	90                   	nop
        count += n & 1;
801087f0:	89 c1                	mov    %eax,%ecx
801087f2:	83 e1 01             	and    $0x1,%ecx
801087f5:	01 ca                	add    %ecx,%edx
    while (n) {
801087f7:	d1 e8                	shr    %eax
801087f9:	75 f5                	jne    801087f0 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
801087fb:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
801087fe:	72 78                	jb     80108878 <lapa+0xf8>
      instances++;
80108800:	0f 94 c0             	sete   %al
80108803:	0f b6 c0             	movzbl %al,%eax
80108806:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108808:	83 c3 01             	add    $0x1,%ebx
8010880b:	83 c6 1c             	add    $0x1c,%esi
8010880e:	83 fb 10             	cmp    $0x10,%ebx
80108811:	75 cd                	jne    801087e0 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108813:	83 ff 01             	cmp    $0x1,%edi
80108816:	76 52                	jbe    8010886a <lapa+0xea>
      uint minvalue = ramPages[minloc].lapa_counter;
80108818:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
8010881c:	8b 7d d8             	mov    -0x28(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
8010881f:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108824:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010882f:	90                   	nop
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108830:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108833:	8b 18                	mov    (%eax),%ebx
    while (n) {
80108835:	85 db                	test   %ebx,%ebx
80108837:	74 4c                	je     80108885 <lapa+0x105>
80108839:	89 d8                	mov    %ebx,%eax
    uint count = 0;
8010883b:	31 d2                	xor    %edx,%edx
8010883d:	8d 76 00             	lea    0x0(%esi),%esi
        count += n & 1;
80108840:	89 c1                	mov    %eax,%ecx
80108842:	83 e1 01             	and    $0x1,%ecx
80108845:	01 ca                	add    %ecx,%edx
    while (n) {
80108847:	d1 e8                	shr    %eax
80108849:	75 f5                	jne    80108840 <lapa+0xc0>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
8010884b:	39 fb                	cmp    %edi,%ebx
8010884d:	73 0f                	jae    8010885e <lapa+0xde>
8010884f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108852:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108855:	0f 44 fb             	cmove  %ebx,%edi
80108858:	0f 44 c6             	cmove  %esi,%eax
8010885b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
8010885e:	83 c6 01             	add    $0x1,%esi
80108861:	83 45 dc 1c          	addl   $0x1c,-0x24(%ebp)
80108865:	83 fe 10             	cmp    $0x10,%esi
80108868:	75 c6                	jne    80108830 <lapa+0xb0>
}
8010886a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010886d:	83 c4 1c             	add    $0x1c,%esp
80108870:	5b                   	pop    %ebx
80108871:	5e                   	pop    %esi
80108872:	5f                   	pop    %edi
80108873:	5d                   	pop    %ebp
80108874:	c3                   	ret    
80108875:	8d 76 00             	lea    0x0(%esi),%esi
      minloc = i;
80108878:	89 5d e0             	mov    %ebx,-0x20(%ebp)
      instances = 1;
8010887b:	bf 01 00 00 00       	mov    $0x1,%edi
80108880:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108883:	eb 83                	jmp    80108808 <lapa+0x88>
    uint count = 0;
80108885:	31 d2                	xor    %edx,%edx
80108887:	eb c2                	jmp    8010884b <lapa+0xcb>
80108889:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108890:	e9 29 ff ff ff       	jmp    801087be <lapa+0x3e>
80108895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010889c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801088a0 <nfua>:
{
801088a0:	f3 0f 1e fb          	endbr32 
801088a4:	55                   	push   %ebp
801088a5:	89 e5                	mov    %esp,%ebp
801088a7:	56                   	push   %esi
  uint minloc = 0;
801088a8:	31 f6                	xor    %esi,%esi
{
801088aa:	53                   	push   %ebx
  struct proc *curproc = myproc();
801088ab:	e8 90 b9 ff ff       	call   80104240 <myproc>
  uint minval = ramPages[0].nfua_counter;
801088b0:	8b 98 5c 02 00 00    	mov    0x25c(%eax),%ebx
  for(i = 1; i < MAX_PSYC_PAGES; i++)
801088b6:	8d 90 78 02 00 00    	lea    0x278(%eax),%edx
801088bc:	b8 01 00 00 00       	mov    $0x1,%eax
801088c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ramPages[i].nfua_counter < minval)
801088c8:	8b 0a                	mov    (%edx),%ecx
801088ca:	39 d9                	cmp    %ebx,%ecx
801088cc:	73 04                	jae    801088d2 <nfua+0x32>
      minloc = i;
801088ce:	89 c6                	mov    %eax,%esi
    if(ramPages[i].nfua_counter < minval)
801088d0:	89 cb                	mov    %ecx,%ebx
  for(i = 1; i < MAX_PSYC_PAGES; i++)
801088d2:	83 c0 01             	add    $0x1,%eax
801088d5:	83 c2 1c             	add    $0x1c,%edx
801088d8:	83 f8 10             	cmp    $0x10,%eax
801088db:	75 eb                	jne    801088c8 <nfua+0x28>
}
801088dd:	89 f0                	mov    %esi,%eax
801088df:	5b                   	pop    %ebx
801088e0:	5e                   	pop    %esi
801088e1:	5d                   	pop    %ebp
801088e2:	c3                   	ret    
801088e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801088ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801088f0 <scfifo>:
{
801088f0:	f3 0f 1e fb          	endbr32 
801088f4:	55                   	push   %ebp
801088f5:	89 e5                	mov    %esp,%ebp
801088f7:	57                   	push   %edi
801088f8:	56                   	push   %esi
801088f9:	53                   	push   %ebx
801088fa:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801088fd:	e8 3e b9 ff ff       	call   80104240 <myproc>
80108902:	89 c7                	mov    %eax,%edi
80108904:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010890a:	89 c6                	mov    %eax,%esi
8010890c:	83 f8 0f             	cmp    $0xf,%eax
8010890f:	7f 6b                	jg     8010897c <scfifo+0x8c>
80108911:	6b d8 1c             	imul   $0x1c,%eax,%ebx
80108914:	01 fb                	add    %edi,%ebx
80108916:	eb 18                	jmp    80108930 <scfifo+0x40>
80108918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010891f:	90                   	nop
          *pte &= ~PTE_A; 
80108920:	83 e2 df             	and    $0xffffffdf,%edx
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108923:	83 c6 01             	add    $0x1,%esi
80108926:	83 c3 1c             	add    $0x1c,%ebx
          *pte &= ~PTE_A; 
80108929:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010892b:	83 fe 10             	cmp    $0x10,%esi
8010892e:	74 40                	je     80108970 <scfifo+0x80>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108930:	8b 93 50 02 00 00    	mov    0x250(%ebx),%edx
80108936:	8b 83 48 02 00 00    	mov    0x248(%ebx),%eax
8010893c:	31 c9                	xor    %ecx,%ecx
8010893e:	e8 6d e9 ff ff       	call   801072b0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108943:	8b 10                	mov    (%eax),%edx
80108945:	89 d1                	mov    %edx,%ecx
80108947:	83 e1 20             	and    $0x20,%ecx
8010894a:	75 d4                	jne    80108920 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
8010894c:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108953:	74 03                	je     80108958 <scfifo+0x68>
            curproc->clockHand = i + 1;
80108955:	8d 4e 01             	lea    0x1(%esi),%ecx
          curproc->clockHand = j + 1;
80108958:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
8010895e:	83 c4 0c             	add    $0xc,%esp
80108961:	89 f0                	mov    %esi,%eax
80108963:	5b                   	pop    %ebx
80108964:	5e                   	pop    %esi
80108965:	5f                   	pop    %edi
80108966:	5d                   	pop    %ebp
80108967:	c3                   	ret    
80108968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010896f:	90                   	nop
80108970:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108976:	31 f6                	xor    %esi,%esi
    for(j=0; j< curproc->clockHand ;j++)
80108978:	85 c0                	test   %eax,%eax
8010897a:	74 95                	je     80108911 <scfifo+0x21>
8010897c:	8d 9f 48 02 00 00    	lea    0x248(%edi),%ebx
80108982:	31 c9                	xor    %ecx,%ecx
80108984:	eb 20                	jmp    801089a6 <scfifo+0xb6>
80108986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010898d:	8d 76 00             	lea    0x0(%esi),%esi
          *pte &= ~PTE_A;  
80108990:	83 e2 df             	and    $0xffffffdf,%edx
80108993:	83 c3 1c             	add    $0x1c,%ebx
80108996:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108998:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
8010899e:	39 c1                	cmp    %eax,%ecx
801089a0:	0f 83 64 ff ff ff    	jae    8010890a <scfifo+0x1a>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
801089a6:	8b 53 08             	mov    0x8(%ebx),%edx
801089a9:	8b 03                	mov    (%ebx),%eax
801089ab:	89 ce                	mov    %ecx,%esi
801089ad:	31 c9                	xor    %ecx,%ecx
801089af:	e8 fc e8 ff ff       	call   801072b0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
801089b4:	8d 4e 01             	lea    0x1(%esi),%ecx
801089b7:	8b 10                	mov    (%eax),%edx
801089b9:	f6 c2 20             	test   $0x20,%dl
801089bc:	75 d2                	jne    80108990 <scfifo+0xa0>
          curproc->clockHand = j + 1;
801089be:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
801089c4:	83 c4 0c             	add    $0xc,%esp
801089c7:	89 f0                	mov    %esi,%eax
801089c9:	5b                   	pop    %ebx
801089ca:	5e                   	pop    %esi
801089cb:	5f                   	pop    %edi
801089cc:	5d                   	pop    %ebp
801089cd:	c3                   	ret    
801089ce:	66 90                	xchg   %ax,%ax

801089d0 <countSetBits>:
{
801089d0:	f3 0f 1e fb          	endbr32 
801089d4:	55                   	push   %ebp
    uint count = 0;
801089d5:	31 d2                	xor    %edx,%edx
{
801089d7:	89 e5                	mov    %esp,%ebp
801089d9:	8b 45 08             	mov    0x8(%ebp),%eax
    while (n) {
801089dc:	85 c0                	test   %eax,%eax
801089de:	74 0b                	je     801089eb <countSetBits+0x1b>
        count += n & 1;
801089e0:	89 c1                	mov    %eax,%ecx
801089e2:	83 e1 01             	and    $0x1,%ecx
801089e5:	01 ca                	add    %ecx,%edx
    while (n) {
801089e7:	d1 e8                	shr    %eax
801089e9:	75 f5                	jne    801089e0 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
801089eb:	89 d0                	mov    %edx,%eax
801089ed:	5d                   	pop    %ebp
801089ee:	c3                   	ret    
801089ef:	90                   	nop

801089f0 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
801089f0:	f3 0f 1e fb          	endbr32 
801089f4:	55                   	push   %ebp
801089f5:	89 e5                	mov    %esp,%ebp
801089f7:	56                   	push   %esi
801089f8:	53                   	push   %ebx
801089f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
801089fc:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
801089ff:	e8 3c b8 ff ff       	call   80104240 <myproc>
80108a04:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108a0a:	74 34                	je     80108a40 <swapAQ+0x50>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108a0c:	e8 2f b8 ff ff       	call   80104240 <myproc>
80108a11:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108a17:	74 57                	je     80108a70 <swapAQ+0x80>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108a19:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108a1c:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108a1e:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108a20:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108a23:	85 d2                	test   %edx,%edx
80108a25:	74 05                	je     80108a2c <swapAQ+0x3c>
  {
    curr_node->prev = maybeLeft;
80108a27:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108a2a:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108a2c:	85 c0                	test   %eax,%eax
80108a2e:	74 05                	je     80108a35 <swapAQ+0x45>
  {
    prev_node->next = maybeRight;
80108a30:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108a32:	89 70 04             	mov    %esi,0x4(%eax)
  }
}
80108a35:	5b                   	pop    %ebx
80108a36:	5e                   	pop    %esi
80108a37:	5d                   	pop    %ebp
80108a38:	c3                   	ret    
80108a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_tail = prev_node;
80108a40:	e8 fb b7 ff ff       	call   80104240 <myproc>
80108a45:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108a4b:	e8 f0 b7 ff ff       	call   80104240 <myproc>
80108a50:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108a5c:	e8 df b7 ff ff       	call   80104240 <myproc>
80108a61:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108a67:	75 b0                	jne    80108a19 <swapAQ+0x29>
80108a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108a70:	e8 cb b7 ff ff       	call   80104240 <myproc>
80108a75:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108a7b:	e8 c0 b7 ff ff       	call   80104240 <myproc>
80108a80:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108a8d:	eb 8a                	jmp    80108a19 <swapAQ+0x29>
80108a8f:	90                   	nop

80108a90 <updateAQ>:
{
80108a90:	f3 0f 1e fb          	endbr32 
80108a94:	55                   	push   %ebp
80108a95:	89 e5                	mov    %esp,%ebp
80108a97:	57                   	push   %edi
80108a98:	56                   	push   %esi
80108a99:	53                   	push   %ebx
80108a9a:	83 ec 1c             	sub    $0x1c,%esp
80108a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108aa0:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108aa6:	85 d2                	test   %edx,%edx
80108aa8:	0f 84 92 00 00 00    	je     80108b40 <updateAQ+0xb0>
  struct queue_node *curr_node = p->queue_tail;
80108aae:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108ab4:	8b 56 04             	mov    0x4(%esi),%edx
80108ab7:	85 d2                	test   %edx,%edx
80108ab9:	0f 84 81 00 00 00    	je     80108b40 <updateAQ+0xb0>
  prev_page = &ramPages[curr_node->prev->page_index];
80108abf:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *ramPages = p->ramPages;
80108ac3:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  struct page *curr_page = &ramPages[curr_node->page_index];
80108ac9:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108acd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108ad0:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108ad2:	01 d8                	add    %ebx,%eax
  while(curr_node != 0)
80108ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108ad8:	8b 50 08             	mov    0x8(%eax),%edx
80108adb:	8b 00                	mov    (%eax),%eax
80108add:	31 c9                	xor    %ecx,%ecx
80108adf:	e8 cc e7 ff ff       	call   801072b0 <walkpgdir>
80108ae4:	89 c3                	mov    %eax,%ebx
80108ae6:	85 c0                	test   %eax,%eax
80108ae8:	74 5e                	je     80108b48 <updateAQ+0xb8>
    if(*pte_curr & PTE_A) // an accessed page
80108aea:	8b 00                	mov    (%eax),%eax
80108aec:	8b 56 04             	mov    0x4(%esi),%edx
80108aef:	a8 20                	test   $0x20,%al
80108af1:	74 23                	je     80108b16 <updateAQ+0x86>
      if(curr_node->prev != 0) // there is a page behind it
80108af3:	85 d2                	test   %edx,%edx
80108af5:	74 17                	je     80108b0e <updateAQ+0x7e>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108af7:	8b 57 08             	mov    0x8(%edi),%edx
80108afa:	8b 07                	mov    (%edi),%eax
80108afc:	31 c9                	xor    %ecx,%ecx
80108afe:	e8 ad e7 ff ff       	call   801072b0 <walkpgdir>
80108b03:	85 c0                	test   %eax,%eax
80108b05:	74 41                	je     80108b48 <updateAQ+0xb8>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108b07:	f6 00 20             	testb  $0x20,(%eax)
80108b0a:	74 24                	je     80108b30 <updateAQ+0xa0>
80108b0c:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108b0e:	83 e0 df             	and    $0xffffffdf,%eax
80108b11:	89 03                	mov    %eax,(%ebx)
80108b13:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108b16:	85 d2                	test   %edx,%edx
80108b18:	74 26                	je     80108b40 <updateAQ+0xb0>
      curr_page = &ramPages[curr_node->page_index];
80108b1a:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
80108b1e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108b21:	89 d6                	mov    %edx,%esi
80108b23:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108b27:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108b29:	01 cf                	add    %ecx,%edi
  while(curr_node != 0)
80108b2b:	eb ab                	jmp    80108ad8 <updateAQ+0x48>
80108b2d:	8d 76 00             	lea    0x0(%esi),%esi
          swapAQ(curr_node);
80108b30:	83 ec 0c             	sub    $0xc,%esp
80108b33:	56                   	push   %esi
80108b34:	e8 b7 fe ff ff       	call   801089f0 <swapAQ>
80108b39:	8b 03                	mov    (%ebx),%eax
80108b3b:	83 c4 10             	add    $0x10,%esp
80108b3e:	eb ce                	jmp    80108b0e <updateAQ+0x7e>
}
80108b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b43:	5b                   	pop    %ebx
80108b44:	5e                   	pop    %esi
80108b45:	5f                   	pop    %edi
80108b46:	5d                   	pop    %ebp
80108b47:	c3                   	ret    
      panic("updateAQ: no pte");
80108b48:	83 ec 0c             	sub    $0xc,%esp
80108b4b:	68 2b 98 10 80       	push   $0x8010982b
80108b50:	e8 3b 78 ff ff       	call   80100390 <panic>
80108b55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108b60 <getNumRefsWarpper>:

 int
  getNumRefsWarpper(int idx)
  {
80108b60:	f3 0f 1e fb          	endbr32 
80108b64:	55                   	push   %ebp
80108b65:	89 e5                	mov    %esp,%ebp
80108b67:	53                   	push   %ebx
80108b68:	83 ec 04             	sub    $0x4,%esp
80108b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc * curproc = myproc();
80108b6e:	e8 cd b6 ff ff       	call   80104240 <myproc>
    pte_t *evicted_pte = walkpgdir(curproc->ramPages[idx].pgdir, (void*)curproc->ramPages[idx].virt_addr, 0);
80108b73:	31 c9                	xor    %ecx,%ecx
80108b75:	6b db 1c             	imul   $0x1c,%ebx,%ebx
80108b78:	01 d8                	add    %ebx,%eax
80108b7a:	8b 90 50 02 00 00    	mov    0x250(%eax),%edx
80108b80:	8b 80 48 02 00 00    	mov    0x248(%eax),%eax
80108b86:	e8 25 e7 ff ff       	call   801072b0 <walkpgdir>
    char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80108b8b:	8b 00                	mov    (%eax),%eax
80108b8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return getRefs(P2V(evicted_pa));
80108b92:	05 00 00 00 80       	add    $0x80000000,%eax
80108b97:	89 45 08             	mov    %eax,0x8(%ebp)

  }
80108b9a:	83 c4 04             	add    $0x4,%esp
80108b9d:	5b                   	pop    %ebx
80108b9e:	5d                   	pop    %ebp
    return getRefs(P2V(evicted_pa));
80108b9f:	e9 7c a3 ff ff       	jmp    80102f20 <getRefs>
80108ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108baf:	90                   	nop

80108bb0 <getRamPageIndexByVirtAddr>:
80108bb0:	f3 0f 1e fb          	endbr32 
80108bb4:	e9 77 f3 ff ff       	jmp    80107f30 <getSwappedPageIndex>
