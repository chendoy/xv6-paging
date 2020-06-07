
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
8010002d:	b8 90 36 10 80       	mov    $0x80103690,%eax
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
80100050:	68 00 83 10 80       	push   $0x80108300
80100055:	68 00 e6 10 80       	push   $0x8010e600
8010005a:	e8 91 4c 00 00       	call   80104cf0 <initlock>
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
80100092:	68 07 83 10 80       	push   $0x80108307
80100097:	50                   	push   %eax
80100098:	e8 13 4b 00 00       	call   80104bb0 <initsleeplock>
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
801000e8:	e8 83 4d 00 00       	call   80104e70 <acquire>
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
80100162:	e8 c9 4d 00 00       	call   80104f30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 4a 00 00       	call   80104bf0 <acquiresleep>
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
8010018c:	e8 af 24 00 00       	call   80102640 <iderw>
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
801001a3:	68 0e 83 10 80       	push   $0x8010830e
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
801001c2:	e8 c9 4a 00 00       	call   80104c90 <holdingsleep>
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
801001d8:	e9 63 24 00 00       	jmp    80102640 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 83 10 80       	push   $0x8010831f
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
80100203:	e8 88 4a 00 00       	call   80104c90 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 38 4a 00 00       	call   80104c50 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 e6 10 80 	movl   $0x8010e600,(%esp)
8010021f:	e8 4c 4c 00 00       	call   80104e70 <acquire>
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
80100270:	e9 bb 4c 00 00       	jmp    80104f30 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 83 10 80       	push   $0x80108326
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
801002a5:	e8 d6 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ba 4b 00 00       	call   80104e70 <acquire>
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
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 e0 2f 11 80       	push   $0x80112fe0
801002e5:	e8 b6 44 00 00       	call   801047a0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 91 3d 00 00       	call   80104090 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 1d 4c 00 00       	call   80104f30 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 84 14 00 00       	call   801017a0 <ilock>
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
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 c6 4b 00 00       	call   80104f30 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 2d 14 00 00       	call   801017a0 <ilock>
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
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 3e 2b 00 00       	call   80102ef0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 83 10 80       	push   $0x8010832d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 7a 8d 10 80 	movl   $0x80108d7a,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 2f 49 00 00       	call   80104d10 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 83 10 80       	push   $0x80108341
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
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
8010042a:	e8 01 62 00 00       	call   80106630 <uartputc>
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
80100515:	e8 16 61 00 00       	call   80106630 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 0a 61 00 00       	call   80106630 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 fe 60 00 00       	call   80106630 <uartputc>
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
80100561:	e8 ba 4a 00 00       	call   80105020 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 4a 00 00       	call   80104f80 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 83 10 80       	push   $0x80108345
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
801005c9:	0f b6 92 70 83 10 80 	movzbl -0x7fef7c90(%edx),%edx
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
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100653:	e8 28 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 0c 48 00 00       	call   80104e70 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 94 48 00 00       	call   80104f30 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 fb 10 00 00       	call   801017a0 <ilock>

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
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010077d:	bb 58 83 10 80       	mov    $0x80108358,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 ae 46 00 00       	call   80104e70 <acquire>
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
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 03 47 00 00       	call   80104f30 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 83 10 80       	push   $0x8010835f
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
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 f4 45 00 00       	call   80104e70 <acquire>
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
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
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
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 5c 45 00 00       	call   80104f30 <release>
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
801009ff:	e9 9c 40 00 00       	jmp    80104aa0 <procdump>
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
80100a20:	e8 7b 3f 00 00       	call   801049a0 <wakeup>
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
80100a3a:	68 68 83 10 80       	push   $0x80108368
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 a7 42 00 00       	call   80104cf0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 39 11 80 40 	movl   $0x80100640,0x801139ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 39 11 80 90 	movl   $0x80100290,0x801139a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 7e 1d 00 00       	call   801027f0 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 fb 35 00 00       	call   80104090 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 e0 28 00 00       	call   80103380 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 c5 15 00 00       	call   80102070 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 3d 03 00 00    	je     80100df3 <exec+0x373>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 df 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 ce 0f 00 00       	call   80101aa0 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 5d 0f 00 00       	call   80101a40 <iunlockput>
    end_op();
80100ae3:	e8 08 29 00 00       	call   801033f0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 af 6f 00 00       	call   80107ac0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 e3 02 00 00    	je     80100e12 <exec+0x392>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 d8 6b 00 00       	call   80107750 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 02 69 00 00       	call   801074b0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 ca 0e 00 00       	call   80101aa0 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 50 6e 00 00       	call   80107a40 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 1f 0e 00 00       	call   80101a40 <iunlockput>
  end_op();
80100c21:	e8 ca 27 00 00       	call   801033f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 6b 00 00       	call   80107750 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 18 6f 00 00       	call   80107b70 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 d8 44 00 00       	call   80105180 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 c5 44 00 00       	call   80105180 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 75 00 00       	call   80108230 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 5a 6d 00 00       	call   80107a40 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 74 00 00       	call   80108230 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d6d:	52                   	push   %edx
80100d6e:	50                   	push   %eax
80100d6f:	e8 cc 43 00 00       	call   80105140 <safestrcpy>
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
80100d74:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d7a:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
80100d80:	83 c4 10             	add    $0x10,%esp
80100d83:	8d 97 88 01 00 00    	lea    0x188(%edi),%edx
80100d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ramPages[ind].isused)
80100d90:	8b b8 04 01 00 00    	mov    0x104(%eax),%edi
80100d96:	85 ff                	test   %edi,%edi
80100d98:	74 06                	je     80100da0 <exec+0x320>
      curproc->ramPages[ind].pgdir = pgdir;
80100d9a:	89 88 00 01 00 00    	mov    %ecx,0x100(%eax)
    if(curproc->swappedPages[ind].isused)
80100da0:	8b 78 04             	mov    0x4(%eax),%edi
80100da3:	85 ff                	test   %edi,%edi
80100da5:	74 02                	je     80100da9 <exec+0x329>
      curproc->swappedPages[ind].pgdir = pgdir;
80100da7:	89 08                	mov    %ecx,(%eax)
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
80100da9:	83 c0 10             	add    $0x10,%eax
80100dac:	39 d0                	cmp    %edx,%eax
80100dae:	75 e0                	jne    80100d90 <exec+0x310>
  oldpgdir = curproc->pgdir;
80100db0:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100db6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  switchuvm(curproc);
80100dbc:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80100dbf:	89 30                	mov    %esi,(%eax)
  oldpgdir = curproc->pgdir;
80100dc1:	8b 78 04             	mov    0x4(%eax),%edi
  curproc->pgdir = pgdir;
80100dc4:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dc7:	89 c1                	mov    %eax,%ecx
80100dc9:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dcf:	8b 40 18             	mov    0x18(%eax),%eax
80100dd2:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd5:	8b 41 18             	mov    0x18(%ecx),%eax
80100dd8:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100ddb:	51                   	push   %ecx
80100ddc:	e8 3f 65 00 00       	call   80107320 <switchuvm>
  freevm(oldpgdir);
80100de1:	89 3c 24             	mov    %edi,(%esp)
80100de4:	e8 57 6c 00 00       	call   80107a40 <freevm>
  return 0;
80100de9:	83 c4 10             	add    $0x10,%esp
80100dec:	31 c0                	xor    %eax,%eax
80100dee:	e9 fd fc ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100df3:	e8 f8 25 00 00       	call   801033f0 <end_op>
    cprintf("exec: fail\n");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 81 83 10 80       	push   $0x80108381
80100e00:	e8 ab f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0d:	e9 de fc ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	31 ff                	xor    %edi,%edi
80100e14:	be 00 20 00 00       	mov    $0x2000,%esi
80100e19:	e9 fa fd ff ff       	jmp    80100c18 <exec+0x198>
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	f3 0f 1e fb          	endbr32 
80100e24:	55                   	push   %ebp
80100e25:	89 e5                	mov    %esp,%ebp
80100e27:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e2a:	68 8d 83 10 80       	push   $0x8010838d
80100e2f:	68 00 30 11 80       	push   $0x80113000
80100e34:	e8 b7 3e 00 00       	call   80104cf0 <initlock>
}
80100e39:	83 c4 10             	add    $0x10,%esp
80100e3c:	c9                   	leave  
80100e3d:	c3                   	ret    
80100e3e:	66 90                	xchg   %ax,%ax

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	f3 0f 1e fb          	endbr32 
80100e44:	55                   	push   %ebp
80100e45:	89 e5                	mov    %esp,%ebp
80100e47:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e48:	bb 34 30 11 80       	mov    $0x80113034,%ebx
{
80100e4d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e50:	68 00 30 11 80       	push   $0x80113000
80100e55:	e8 16 40 00 00       	call   80104e70 <acquire>
80100e5a:	83 c4 10             	add    $0x10,%esp
80100e5d:	eb 0c                	jmp    80100e6b <filealloc+0x2b>
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb 94 39 11 80    	cmp    $0x80113994,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 00 30 11 80       	push   $0x80113000
80100e81:	e8 aa 40 00 00       	call   80104f30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e86:	89 d8                	mov    %ebx,%eax
      return f;
80100e88:	83 c4 10             	add    $0x10,%esp
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e93:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e95:	68 00 30 11 80       	push   $0x80113000
80100e9a:	e8 91 40 00 00       	call   80104f30 <release>
}
80100e9f:	89 d8                	mov    %ebx,%eax
  return 0;
80100ea1:	83 c4 10             	add    $0x10,%esp
}
80100ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea7:	c9                   	leave  
80100ea8:	c3                   	ret    
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	f3 0f 1e fb          	endbr32 
80100eb4:	55                   	push   %ebp
80100eb5:	89 e5                	mov    %esp,%ebp
80100eb7:	53                   	push   %ebx
80100eb8:	83 ec 10             	sub    $0x10,%esp
80100ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ebe:	68 00 30 11 80       	push   $0x80113000
80100ec3:	e8 a8 3f 00 00       	call   80104e70 <acquire>
  if(f->ref < 1)
80100ec8:	8b 43 04             	mov    0x4(%ebx),%eax
80100ecb:	83 c4 10             	add    $0x10,%esp
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	7e 1a                	jle    80100eec <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ed2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ed8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100edb:	68 00 30 11 80       	push   $0x80113000
80100ee0:	e8 4b 40 00 00       	call   80104f30 <release>
  return f;
}
80100ee5:	89 d8                	mov    %ebx,%eax
80100ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eea:	c9                   	leave  
80100eeb:	c3                   	ret    
    panic("filedup");
80100eec:	83 ec 0c             	sub    $0xc,%esp
80100eef:	68 94 83 10 80       	push   $0x80108394
80100ef4:	e8 97 f4 ff ff       	call   80100390 <panic>
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	f3 0f 1e fb          	endbr32 
80100f04:	55                   	push   %ebp
80100f05:	89 e5                	mov    %esp,%ebp
80100f07:	57                   	push   %edi
80100f08:	56                   	push   %esi
80100f09:	53                   	push   %ebx
80100f0a:	83 ec 28             	sub    $0x28,%esp
80100f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f10:	68 00 30 11 80       	push   $0x80113000
80100f15:	e8 56 3f 00 00       	call   80104e70 <acquire>
  if(f->ref < 1)
80100f1a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f1d:	83 c4 10             	add    $0x10,%esp
80100f20:	85 d2                	test   %edx,%edx
80100f22:	0f 8e a1 00 00 00    	jle    80100fc9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f28:	83 ea 01             	sub    $0x1,%edx
80100f2b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f2e:	75 40                	jne    80100f70 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f30:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f34:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f37:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f39:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f42:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f45:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f48:	68 00 30 11 80       	push   $0x80113000
  ff = *f;
80100f4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f50:	e8 db 3f 00 00       	call   80104f30 <release>

  if(ff.type == FD_PIPE)
80100f55:	83 c4 10             	add    $0x10,%esp
80100f58:	83 ff 01             	cmp    $0x1,%edi
80100f5b:	74 53                	je     80100fb0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f5d:	83 ff 02             	cmp    $0x2,%edi
80100f60:	74 26                	je     80100f88 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f65:	5b                   	pop    %ebx
80100f66:	5e                   	pop    %esi
80100f67:	5f                   	pop    %edi
80100f68:	5d                   	pop    %ebp
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f70:	c7 45 08 00 30 11 80 	movl   $0x80113000,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 ad 3f 00 00       	jmp    80104f30 <release>
80100f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f87:	90                   	nop
    begin_op();
80100f88:	e8 f3 23 00 00       	call   80103380 <begin_op>
    iput(ff.ip);
80100f8d:	83 ec 0c             	sub    $0xc,%esp
80100f90:	ff 75 e0             	pushl  -0x20(%ebp)
80100f93:	e8 38 09 00 00       	call   801018d0 <iput>
    end_op();
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9e:	5b                   	pop    %ebx
80100f9f:	5e                   	pop    %esi
80100fa0:	5f                   	pop    %edi
80100fa1:	5d                   	pop    %ebp
    end_op();
80100fa2:	e9 49 24 00 00       	jmp    801033f0 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 92 2b 00 00       	call   80103b50 <pipeclose>
80100fbe:	83 c4 10             	add    $0x10,%esp
}
80100fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc4:	5b                   	pop    %ebx
80100fc5:	5e                   	pop    %esi
80100fc6:	5f                   	pop    %edi
80100fc7:	5d                   	pop    %ebp
80100fc8:	c3                   	ret    
    panic("fileclose");
80100fc9:	83 ec 0c             	sub    $0xc,%esp
80100fcc:	68 9c 83 10 80       	push   $0x8010839c
80100fd1:	e8 ba f3 ff ff       	call   80100390 <panic>
80100fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fdd:	8d 76 00             	lea    0x0(%esi),%esi

80100fe0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	f3 0f 1e fb          	endbr32 
80100fe4:	55                   	push   %ebp
80100fe5:	89 e5                	mov    %esp,%ebp
80100fe7:	53                   	push   %ebx
80100fe8:	83 ec 04             	sub    $0x4,%esp
80100feb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fee:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ff1:	75 2d                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100ff3:	83 ec 0c             	sub    $0xc,%esp
80100ff6:	ff 73 10             	pushl  0x10(%ebx)
80100ff9:	e8 a2 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
80100ffe:	58                   	pop    %eax
80100fff:	5a                   	pop    %edx
80101000:	ff 75 0c             	pushl  0xc(%ebp)
80101003:	ff 73 10             	pushl  0x10(%ebx)
80101006:	e8 65 0a 00 00       	call   80101a70 <stati>
    iunlock(f->ip);
8010100b:	59                   	pop    %ecx
8010100c:	ff 73 10             	pushl  0x10(%ebx)
8010100f:	e8 6c 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101017:	83 c4 10             	add    $0x10,%esp
8010101a:	31 c0                	xor    %eax,%eax
}
8010101c:	c9                   	leave  
8010101d:	c3                   	ret    
8010101e:	66 90                	xchg   %ax,%ax
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	f3 0f 1e fb          	endbr32 
80101034:	55                   	push   %ebp
80101035:	89 e5                	mov    %esp,%ebp
80101037:	57                   	push   %edi
80101038:	56                   	push   %esi
80101039:	53                   	push   %ebx
8010103a:	83 ec 0c             	sub    $0xc,%esp
8010103d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101040:	8b 75 0c             	mov    0xc(%ebp),%esi
80101043:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101046:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010104a:	74 64                	je     801010b0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010104c:	8b 03                	mov    (%ebx),%eax
8010104e:	83 f8 01             	cmp    $0x1,%eax
80101051:	74 45                	je     80101098 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101053:	83 f8 02             	cmp    $0x2,%eax
80101056:	75 5f                	jne    801010b7 <fileread+0x87>
    ilock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 3d 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101063:	57                   	push   %edi
80101064:	ff 73 14             	pushl  0x14(%ebx)
80101067:	56                   	push   %esi
80101068:	ff 73 10             	pushl  0x10(%ebx)
8010106b:	e8 30 0a 00 00       	call   80101aa0 <readi>
80101070:	83 c4 20             	add    $0x20,%esp
80101073:	89 c6                	mov    %eax,%esi
80101075:	85 c0                	test   %eax,%eax
80101077:	7e 03                	jle    8010107c <fileread+0x4c>
      f->off += r;
80101079:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010107c:	83 ec 0c             	sub    $0xc,%esp
8010107f:	ff 73 10             	pushl  0x10(%ebx)
80101082:	e8 f9 07 00 00       	call   80101880 <iunlock>
    return r;
80101087:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010108a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108d:	89 f0                	mov    %esi,%eax
8010108f:	5b                   	pop    %ebx
80101090:	5e                   	pop    %esi
80101091:	5f                   	pop    %edi
80101092:	5d                   	pop    %ebp
80101093:	c3                   	ret    
80101094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101098:	8b 43 0c             	mov    0xc(%ebx),%eax
8010109b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010a5:	e9 46 2c 00 00       	jmp    80103cf0 <piperead>
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010b5:	eb d3                	jmp    8010108a <fileread+0x5a>
  panic("fileread");
801010b7:	83 ec 0c             	sub    $0xc,%esp
801010ba:	68 a6 83 10 80       	push   $0x801083a6
801010bf:	e8 cc f2 ff ff       	call   80100390 <panic>
801010c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	f3 0f 1e fb          	endbr32 
801010d4:	55                   	push   %ebp
801010d5:	89 e5                	mov    %esp,%ebp
801010d7:	57                   	push   %edi
801010d8:	56                   	push   %esi
801010d9:	53                   	push   %ebx
801010da:	83 ec 1c             	sub    $0x1c,%esp
801010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801010e0:	8b 75 08             	mov    0x8(%ebp),%esi
801010e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010f0:	0f 84 c1 00 00 00    	je     801011b7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010f6:	8b 06                	mov    (%esi),%eax
801010f8:	83 f8 01             	cmp    $0x1,%eax
801010fb:	0f 84 c3 00 00 00    	je     801011c4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101101:	83 f8 02             	cmp    $0x2,%eax
80101104:	0f 85 cc 00 00 00    	jne    801011d6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010110a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010110d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010110f:	85 c0                	test   %eax,%eax
80101111:	7f 34                	jg     80101147 <filewrite+0x77>
80101113:	e9 98 00 00 00       	jmp    801011b0 <filewrite+0xe0>
80101118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101120:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101123:	83 ec 0c             	sub    $0xc,%esp
80101126:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101129:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010112c:	e8 4f 07 00 00       	call   80101880 <iunlock>
      end_op();
80101131:	e8 ba 22 00 00       	call   801033f0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101136:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	39 c3                	cmp    %eax,%ebx
8010113e:	75 60                	jne    801011a0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101140:	01 df                	add    %ebx,%edi
    while(i < n){
80101142:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101145:	7e 69                	jle    801011b0 <filewrite+0xe0>
      int n1 = n - i;
80101147:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010114a:	b8 00 06 00 00       	mov    $0x600,%eax
8010114f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101151:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101157:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010115a:	e8 21 22 00 00       	call   80103380 <begin_op>
      ilock(f->ip);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 76 10             	pushl  0x10(%esi)
80101165:	e8 36 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010116a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010116d:	53                   	push   %ebx
8010116e:	ff 76 14             	pushl  0x14(%esi)
80101171:	01 f8                	add    %edi,%eax
80101173:	50                   	push   %eax
80101174:	ff 76 10             	pushl  0x10(%esi)
80101177:	e8 24 0a 00 00       	call   80101ba0 <writei>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	85 c0                	test   %eax,%eax
80101181:	7f 9d                	jg     80101120 <filewrite+0x50>
      iunlock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 76 10             	pushl  0x10(%esi)
80101189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010118c:	e8 ef 06 00 00       	call   80101880 <iunlock>
      end_op();
80101191:	e8 5a 22 00 00       	call   801033f0 <end_op>
      if(r < 0)
80101196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101199:	83 c4 10             	add    $0x10,%esp
8010119c:	85 c0                	test   %eax,%eax
8010119e:	75 17                	jne    801011b7 <filewrite+0xe7>
        panic("short filewrite");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 af 83 10 80       	push   $0x801083af
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011b0:	89 f8                	mov    %edi,%eax
801011b2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011b5:	74 05                	je     801011bc <filewrite+0xec>
801011b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bf:	5b                   	pop    %ebx
801011c0:	5e                   	pop    %esi
801011c1:	5f                   	pop    %edi
801011c2:	5d                   	pop    %ebp
801011c3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011c4:	8b 46 0c             	mov    0xc(%esi),%eax
801011c7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cd:	5b                   	pop    %ebx
801011ce:	5e                   	pop    %esi
801011cf:	5f                   	pop    %edi
801011d0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011d1:	e9 1a 2a 00 00       	jmp    80103bf0 <pipewrite>
  panic("filewrite");
801011d6:	83 ec 0c             	sub    $0xc,%esp
801011d9:	68 b5 83 10 80       	push   $0x801083b5
801011de:	e8 ad f1 ff ff       	call   80100390 <panic>
801011e3:	66 90                	xchg   %ax,%ax
801011e5:	66 90                	xchg   %ax,%ax
801011e7:	66 90                	xchg   %ax,%ax
801011e9:	66 90                	xchg   %ax,%ax
801011eb:	66 90                	xchg   %ax,%ax
801011ed:	66 90                	xchg   %ax,%ax
801011ef:	90                   	nop

801011f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011f0:	55                   	push   %ebp
801011f1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011f3:	89 d0                	mov    %edx,%eax
801011f5:	c1 e8 0c             	shr    $0xc,%eax
801011f8:	03 05 18 3a 11 80    	add    0x80113a18,%eax
{
801011fe:	89 e5                	mov    %esp,%ebp
80101200:	56                   	push   %esi
80101201:	53                   	push   %ebx
80101202:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	50                   	push   %eax
80101208:	51                   	push   %ecx
80101209:	e8 c2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010120e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101210:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101213:	ba 01 00 00 00       	mov    $0x1,%edx
80101218:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010121b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101221:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101224:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101226:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010122b:	85 d1                	test   %edx,%ecx
8010122d:	74 25                	je     80101254 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010122f:	f7 d2                	not    %edx
  log_write(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101236:	21 ca                	and    %ecx,%edx
80101238:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010123c:	50                   	push   %eax
8010123d:	e8 1e 23 00 00       	call   80103560 <log_write>
  brelse(bp);
80101242:	89 34 24             	mov    %esi,(%esp)
80101245:	e8 a6 ef ff ff       	call   801001f0 <brelse>
}
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101250:	5b                   	pop    %ebx
80101251:	5e                   	pop    %esi
80101252:	5d                   	pop    %ebp
80101253:	c3                   	ret    
    panic("freeing free block");
80101254:	83 ec 0c             	sub    $0xc,%esp
80101257:	68 bf 83 10 80       	push   $0x801083bf
8010125c:	e8 2f f1 ff ff       	call   80100390 <panic>
80101261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010126f:	90                   	nop

80101270 <balloc>:
{
80101270:	55                   	push   %ebp
80101271:	89 e5                	mov    %esp,%ebp
80101273:	57                   	push   %edi
80101274:	56                   	push   %esi
80101275:	53                   	push   %ebx
80101276:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101279:	8b 0d 00 3a 11 80    	mov    0x80113a00,%ecx
{
8010127f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101282:	85 c9                	test   %ecx,%ecx
80101284:	0f 84 87 00 00 00    	je     80101311 <balloc+0xa1>
8010128a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101291:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101294:	83 ec 08             	sub    $0x8,%esp
80101297:	89 f0                	mov    %esi,%eax
80101299:	c1 f8 0c             	sar    $0xc,%eax
8010129c:	03 05 18 3a 11 80    	add    0x80113a18,%eax
801012a2:	50                   	push   %eax
801012a3:	ff 75 d8             	pushl  -0x28(%ebp)
801012a6:	e8 25 ee ff ff       	call   801000d0 <bread>
801012ab:	83 c4 10             	add    $0x10,%esp
801012ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012b1:	a1 00 3a 11 80       	mov    0x80113a00,%eax
801012b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012b9:	31 c0                	xor    %eax,%eax
801012bb:	eb 2f                	jmp    801012ec <balloc+0x7c>
801012bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012c0:	89 c1                	mov    %eax,%ecx
801012c2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ca:	83 e1 07             	and    $0x7,%ecx
801012cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012cf:	89 c1                	mov    %eax,%ecx
801012d1:	c1 f9 03             	sar    $0x3,%ecx
801012d4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012d9:	89 fa                	mov    %edi,%edx
801012db:	85 df                	test   %ebx,%edi
801012dd:	74 41                	je     80101320 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012df:	83 c0 01             	add    $0x1,%eax
801012e2:	83 c6 01             	add    $0x1,%esi
801012e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ea:	74 05                	je     801012f1 <balloc+0x81>
801012ec:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012ef:	77 cf                	ja     801012c0 <balloc+0x50>
    brelse(bp);
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012f7:	e8 f4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012fc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101303:	83 c4 10             	add    $0x10,%esp
80101306:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101309:	39 05 00 3a 11 80    	cmp    %eax,0x80113a00
8010130f:	77 80                	ja     80101291 <balloc+0x21>
  panic("balloc: out of blocks");
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	68 d2 83 10 80       	push   $0x801083d2
80101319:	e8 72 f0 ff ff       	call   80100390 <panic>
8010131e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101323:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101326:	09 da                	or     %ebx,%edx
80101328:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 2e 22 00 00       	call   80103560 <log_write>
        brelse(bp);
80101332:	89 3c 24             	mov    %edi,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010133a:	58                   	pop    %eax
8010133b:	5a                   	pop    %edx
8010133c:	56                   	push   %esi
8010133d:	ff 75 d8             	pushl  -0x28(%ebp)
80101340:	e8 8b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101345:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101348:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010134a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010134d:	68 00 02 00 00       	push   $0x200
80101352:	6a 00                	push   $0x0
80101354:	50                   	push   %eax
80101355:	e8 26 3c 00 00       	call   80104f80 <memset>
  log_write(bp);
8010135a:	89 1c 24             	mov    %ebx,(%esp)
8010135d:	e8 fe 21 00 00       	call   80103560 <log_write>
  brelse(bp);
80101362:	89 1c 24             	mov    %ebx,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	89 f0                	mov    %esi,%eax
8010136f:	5b                   	pop    %ebx
80101370:	5e                   	pop    %esi
80101371:	5f                   	pop    %edi
80101372:	5d                   	pop    %ebp
80101373:	c3                   	ret    
80101374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010137f:	90                   	nop

80101380 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	89 c7                	mov    %eax,%edi
80101386:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101387:	31 f6                	xor    %esi,%esi
{
80101389:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	bb 54 3a 11 80       	mov    $0x80113a54,%ebx
{
8010138f:	83 ec 28             	sub    $0x28,%esp
80101392:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101395:	68 20 3a 11 80       	push   $0x80113a20
8010139a:	e8 d1 3a 00 00       	call   80104e70 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013a2:	83 c4 10             	add    $0x10,%esp
801013a5:	eb 1b                	jmp    801013c2 <iget+0x42>
801013a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ae:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b0:	39 3b                	cmp    %edi,(%ebx)
801013b2:	74 6c                	je     80101420 <iget+0xa0>
801013b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ba:	81 fb 74 56 11 80    	cmp    $0x80115674,%ebx
801013c0:	73 26                	jae    801013e8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013c5:	85 c9                	test   %ecx,%ecx
801013c7:	7f e7                	jg     801013b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013c9:	85 f6                	test   %esi,%esi
801013cb:	75 e7                	jne    801013b4 <iget+0x34>
801013cd:	89 d8                	mov    %ebx,%eax
801013cf:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013d5:	85 c9                	test   %ecx,%ecx
801013d7:	75 6e                	jne    80101447 <iget+0xc7>
801013d9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013db:	81 fb 74 56 11 80    	cmp    $0x80115674,%ebx
801013e1:	72 df                	jb     801013c2 <iget+0x42>
801013e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013e8:	85 f6                	test   %esi,%esi
801013ea:	74 73                	je     8010145f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ec:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013ef:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013f1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013f4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013fb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101402:	68 20 3a 11 80       	push   $0x80113a20
80101407:	e8 24 3b 00 00       	call   80104f30 <release>

  return ip;
8010140c:	83 c4 10             	add    $0x10,%esp
}
8010140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101412:	89 f0                	mov    %esi,%eax
80101414:	5b                   	pop    %ebx
80101415:	5e                   	pop    %esi
80101416:	5f                   	pop    %edi
80101417:	5d                   	pop    %ebp
80101418:	c3                   	ret    
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101420:	39 53 04             	cmp    %edx,0x4(%ebx)
80101423:	75 8f                	jne    801013b4 <iget+0x34>
      release(&icache.lock);
80101425:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101428:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010142b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010142d:	68 20 3a 11 80       	push   $0x80113a20
      ip->ref++;
80101432:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101435:	e8 f6 3a 00 00       	call   80104f30 <release>
      return ip;
8010143a:	83 c4 10             	add    $0x10,%esp
}
8010143d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101440:	89 f0                	mov    %esi,%eax
80101442:	5b                   	pop    %ebx
80101443:	5e                   	pop    %esi
80101444:	5f                   	pop    %edi
80101445:	5d                   	pop    %ebp
80101446:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101447:	81 fb 74 56 11 80    	cmp    $0x80115674,%ebx
8010144d:	73 10                	jae    8010145f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010144f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101452:	85 c9                	test   %ecx,%ecx
80101454:	0f 8f 56 ff ff ff    	jg     801013b0 <iget+0x30>
8010145a:	e9 6e ff ff ff       	jmp    801013cd <iget+0x4d>
    panic("iget: no inodes");
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	68 e8 83 10 80       	push   $0x801083e8
80101467:	e8 24 ef ff ff       	call   80100390 <panic>
8010146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 84 00 00 00    	jbe    80101508 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 98 00 00 00    	ja     80101528 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	8b 16                	mov    (%esi),%edx
80101498:	85 c0                	test   %eax,%eax
8010149a:	74 54                	je     801014f0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149c:	83 ec 08             	sub    $0x8,%esp
8010149f:	50                   	push   %eax
801014a0:	52                   	push   %edx
801014a1:	e8 2a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a6:	83 c4 10             	add    $0x10,%esp
801014a9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801014ad:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014af:	8b 1a                	mov    (%edx),%ebx
801014b1:	85 db                	test   %ebx,%ebx
801014b3:	74 1b                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b5:	83 ec 0c             	sub    $0xc,%esp
801014b8:	57                   	push   %edi
801014b9:	e8 32 ed ff ff       	call   801001f0 <brelse>
    return addr;
801014be:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c4:	89 d8                	mov    %ebx,%eax
801014c6:	5b                   	pop    %ebx
801014c7:	5e                   	pop    %esi
801014c8:	5f                   	pop    %edi
801014c9:	5d                   	pop    %ebp
801014ca:	c3                   	ret    
801014cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014cf:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014d0:	8b 06                	mov    (%esi),%eax
801014d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014d5:	e8 96 fd ff ff       	call   80101270 <balloc>
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 c3                	mov    %eax,%ebx
801014e2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014e4:	57                   	push   %edi
801014e5:	e8 76 20 00 00       	call   80103560 <log_write>
801014ea:	83 c4 10             	add    $0x10,%esp
801014ed:	eb c6                	jmp    801014b5 <bmap+0x45>
801014ef:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f0:	89 d0                	mov    %edx,%eax
801014f2:	e8 79 fd ff ff       	call   80101270 <balloc>
801014f7:	8b 16                	mov    (%esi),%edx
801014f9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014ff:	eb 9b                	jmp    8010149c <bmap+0x2c>
80101501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101508:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010150b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010150e:	85 db                	test   %ebx,%ebx
80101510:	75 af                	jne    801014c1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101512:	8b 00                	mov    (%eax),%eax
80101514:	e8 57 fd ff ff       	call   80101270 <balloc>
80101519:	89 47 5c             	mov    %eax,0x5c(%edi)
8010151c:	89 c3                	mov    %eax,%ebx
}
8010151e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101521:	89 d8                	mov    %ebx,%eax
80101523:	5b                   	pop    %ebx
80101524:	5e                   	pop    %esi
80101525:	5f                   	pop    %edi
80101526:	5d                   	pop    %ebp
80101527:	c3                   	ret    
  panic("bmap: out of range");
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	68 f8 83 10 80       	push   $0x801083f8
80101530:	e8 5b ee ff ff       	call   80100390 <panic>
80101535:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <readsb>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	56                   	push   %esi
80101548:	53                   	push   %ebx
80101549:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010154c:	83 ec 08             	sub    $0x8,%esp
8010154f:	6a 01                	push   $0x1
80101551:	ff 75 08             	pushl  0x8(%ebp)
80101554:	e8 77 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101559:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010155c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101561:	6a 1c                	push   $0x1c
80101563:	50                   	push   %eax
80101564:	56                   	push   %esi
80101565:	e8 b6 3a 00 00       	call   80105020 <memmove>
  brelse(bp);
8010156a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010156d:	83 c4 10             	add    $0x10,%esp
}
80101570:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101573:	5b                   	pop    %ebx
80101574:	5e                   	pop    %esi
80101575:	5d                   	pop    %ebp
  brelse(bp);
80101576:	e9 75 ec ff ff       	jmp    801001f0 <brelse>
8010157b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	f3 0f 1e fb          	endbr32 
80101584:	55                   	push   %ebp
80101585:	89 e5                	mov    %esp,%ebp
80101587:	53                   	push   %ebx
80101588:	bb 60 3a 11 80       	mov    $0x80113a60,%ebx
8010158d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101590:	68 0b 84 10 80       	push   $0x8010840b
80101595:	68 20 3a 11 80       	push   $0x80113a20
8010159a:	e8 51 37 00 00       	call   80104cf0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159f:	83 c4 10             	add    $0x10,%esp
801015a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	68 12 84 10 80       	push   $0x80108412
801015b0:	53                   	push   %ebx
801015b1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015b7:	e8 f4 35 00 00       	call   80104bb0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015bc:	83 c4 10             	add    $0x10,%esp
801015bf:	81 fb 80 56 11 80    	cmp    $0x80115680,%ebx
801015c5:	75 e1                	jne    801015a8 <iinit+0x28>
  readsb(dev, &sb);
801015c7:	83 ec 08             	sub    $0x8,%esp
801015ca:	68 00 3a 11 80       	push   $0x80113a00
801015cf:	ff 75 08             	pushl  0x8(%ebp)
801015d2:	e8 69 ff ff ff       	call   80101540 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d7:	ff 35 18 3a 11 80    	pushl  0x80113a18
801015dd:	ff 35 14 3a 11 80    	pushl  0x80113a14
801015e3:	ff 35 10 3a 11 80    	pushl  0x80113a10
801015e9:	ff 35 0c 3a 11 80    	pushl  0x80113a0c
801015ef:	ff 35 08 3a 11 80    	pushl  0x80113a08
801015f5:	ff 35 04 3a 11 80    	pushl  0x80113a04
801015fb:	ff 35 00 3a 11 80    	pushl  0x80113a00
80101601:	68 bc 84 10 80       	push   $0x801084bc
80101606:	e8 a5 f0 ff ff       	call   801006b0 <cprintf>
}
8010160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010160e:	83 c4 30             	add    $0x30,%esp
80101611:	c9                   	leave  
80101612:	c3                   	ret    
80101613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101620 <ialloc>:
{
80101620:	f3 0f 1e fb          	endbr32 
80101624:	55                   	push   %ebp
80101625:	89 e5                	mov    %esp,%ebp
80101627:	57                   	push   %edi
80101628:	56                   	push   %esi
80101629:	53                   	push   %ebx
8010162a:	83 ec 1c             	sub    $0x1c,%esp
8010162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101630:	83 3d 08 3a 11 80 01 	cmpl   $0x1,0x80113a08
{
80101637:	8b 75 08             	mov    0x8(%ebp),%esi
8010163a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010163d:	0f 86 8d 00 00 00    	jbe    801016d0 <ialloc+0xb0>
80101643:	bf 01 00 00 00       	mov    $0x1,%edi
80101648:	eb 1d                	jmp    80101667 <ialloc+0x47>
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101653:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101656:	53                   	push   %ebx
80101657:	e8 94 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010165c:	83 c4 10             	add    $0x10,%esp
8010165f:	3b 3d 08 3a 11 80    	cmp    0x80113a08,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 14 3a 11 80    	add    0x80113a14,%eax
80101675:	50                   	push   %eax
80101676:	56                   	push   %esi
80101677:	e8 54 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010167c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010167f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101681:	89 f8                	mov    %edi,%eax
80101683:	83 e0 07             	and    $0x7,%eax
80101686:	c1 e0 06             	shl    $0x6,%eax
80101689:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010168d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101691:	75 bd                	jne    80101650 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101693:	83 ec 04             	sub    $0x4,%esp
80101696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101699:	6a 40                	push   $0x40
8010169b:	6a 00                	push   $0x0
8010169d:	51                   	push   %ecx
8010169e:	e8 dd 38 00 00       	call   80104f80 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 ab 1e 00 00       	call   80103560 <log_write>
      brelse(bp);
801016b5:	89 1c 24             	mov    %ebx,(%esp)
801016b8:	e8 33 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016bd:	83 c4 10             	add    $0x10,%esp
}
801016c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016c3:	89 fa                	mov    %edi,%edx
}
801016c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016c6:	89 f0                	mov    %esi,%eax
}
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801016cb:	e9 b0 fc ff ff       	jmp    80101380 <iget>
  panic("ialloc: no inodes");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 18 84 10 80       	push   $0x80108418
801016d8:	e8 b3 ec ff ff       	call   80100390 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi

801016e0 <iupdate>:
{
801016e0:	f3 0f 1e fb          	endbr32 
801016e4:	55                   	push   %ebp
801016e5:	89 e5                	mov    %esp,%ebp
801016e7:	56                   	push   %esi
801016e8:	53                   	push   %ebx
801016e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ec:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ef:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f2:	83 ec 08             	sub    $0x8,%esp
801016f5:	c1 e8 03             	shr    $0x3,%eax
801016f8:	03 05 14 3a 11 80    	add    0x80113a14,%eax
801016fe:	50                   	push   %eax
801016ff:	ff 73 a4             	pushl  -0x5c(%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101707:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101710:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101713:	83 e0 07             	and    $0x7,%eax
80101716:	c1 e0 06             	shl    $0x6,%eax
80101719:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010171d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101720:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101724:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101727:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010172b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010172f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101733:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101737:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010173b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010173e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	53                   	push   %ebx
80101744:	50                   	push   %eax
80101745:	e8 d6 38 00 00       	call   80105020 <memmove>
  log_write(bp);
8010174a:	89 34 24             	mov    %esi,(%esp)
8010174d:	e8 0e 1e 00 00       	call   80103560 <log_write>
  brelse(bp);
80101752:	89 75 08             	mov    %esi,0x8(%ebp)
80101755:	83 c4 10             	add    $0x10,%esp
}
80101758:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175b:	5b                   	pop    %ebx
8010175c:	5e                   	pop    %esi
8010175d:	5d                   	pop    %ebp
  brelse(bp);
8010175e:	e9 8d ea ff ff       	jmp    801001f0 <brelse>
80101763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101770 <idup>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	53                   	push   %ebx
80101778:	83 ec 10             	sub    $0x10,%esp
8010177b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177e:	68 20 3a 11 80       	push   $0x80113a20
80101783:	e8 e8 36 00 00       	call   80104e70 <acquire>
  ip->ref++;
80101788:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010178c:	c7 04 24 20 3a 11 80 	movl   $0x80113a20,(%esp)
80101793:	e8 98 37 00 00       	call   80104f30 <release>
}
80101798:	89 d8                	mov    %ebx,%eax
8010179a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179d:	c9                   	leave  
8010179e:	c3                   	ret    
8010179f:	90                   	nop

801017a0 <ilock>:
{
801017a0:	f3 0f 1e fb          	endbr32 
801017a4:	55                   	push   %ebp
801017a5:	89 e5                	mov    %esp,%ebp
801017a7:	56                   	push   %esi
801017a8:	53                   	push   %ebx
801017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017ac:	85 db                	test   %ebx,%ebx
801017ae:	0f 84 b3 00 00 00    	je     80101867 <ilock+0xc7>
801017b4:	8b 53 08             	mov    0x8(%ebx),%edx
801017b7:	85 d2                	test   %edx,%edx
801017b9:	0f 8e a8 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bf:	83 ec 0c             	sub    $0xc,%esp
801017c2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c5:	50                   	push   %eax
801017c6:	e8 25 34 00 00       	call   80104bf0 <acquiresleep>
  if(ip->valid == 0){
801017cb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	85 c0                	test   %eax,%eax
801017d3:	74 0b                	je     801017e0 <ilock+0x40>
}
801017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d8:	5b                   	pop    %ebx
801017d9:	5e                   	pop    %esi
801017da:	5d                   	pop    %ebp
801017db:	c3                   	ret    
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 14 3a 11 80    	add    0x80113a14,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	pushl  (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 e3 37 00 00       	call   80105020 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 7b ff ff ff    	jne    801017d5 <ilock+0x35>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 30 84 10 80       	push   $0x80108430
80101862:	e8 29 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 2a 84 10 80       	push   $0x8010842a
8010186f:	e8 1c eb ff ff       	call   80100390 <panic>
80101874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010187b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010187f:	90                   	nop

80101880 <iunlock>:
{
80101880:	f3 0f 1e fb          	endbr32 
80101884:	55                   	push   %ebp
80101885:	89 e5                	mov    %esp,%ebp
80101887:	56                   	push   %esi
80101888:	53                   	push   %ebx
80101889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010188c:	85 db                	test   %ebx,%ebx
8010188e:	74 28                	je     801018b8 <iunlock+0x38>
80101890:	83 ec 0c             	sub    $0xc,%esp
80101893:	8d 73 0c             	lea    0xc(%ebx),%esi
80101896:	56                   	push   %esi
80101897:	e8 f4 33 00 00       	call   80104c90 <holdingsleep>
8010189c:	83 c4 10             	add    $0x10,%esp
8010189f:	85 c0                	test   %eax,%eax
801018a1:	74 15                	je     801018b8 <iunlock+0x38>
801018a3:	8b 43 08             	mov    0x8(%ebx),%eax
801018a6:	85 c0                	test   %eax,%eax
801018a8:	7e 0e                	jle    801018b8 <iunlock+0x38>
  releasesleep(&ip->lock);
801018aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018b3:	e9 98 33 00 00       	jmp    80104c50 <releasesleep>
    panic("iunlock");
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 3f 84 10 80       	push   $0x8010843f
801018c0:	e8 cb ea ff ff       	call   80100390 <panic>
801018c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	57                   	push   %edi
801018d8:	56                   	push   %esi
801018d9:	53                   	push   %ebx
801018da:	83 ec 28             	sub    $0x28,%esp
801018dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018e0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018e3:	57                   	push   %edi
801018e4:	e8 07 33 00 00       	call   80104bf0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	85 d2                	test   %edx,%edx
801018f1:	74 07                	je     801018fa <iput+0x2a>
801018f3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f8:	74 36                	je     80101930 <iput+0x60>
  releasesleep(&ip->lock);
801018fa:	83 ec 0c             	sub    $0xc,%esp
801018fd:	57                   	push   %edi
801018fe:	e8 4d 33 00 00       	call   80104c50 <releasesleep>
  acquire(&icache.lock);
80101903:	c7 04 24 20 3a 11 80 	movl   $0x80113a20,(%esp)
8010190a:	e8 61 35 00 00       	call   80104e70 <acquire>
  ip->ref--;
8010190f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	c7 45 08 20 3a 11 80 	movl   $0x80113a20,0x8(%ebp)
}
8010191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101920:	5b                   	pop    %ebx
80101921:	5e                   	pop    %esi
80101922:	5f                   	pop    %edi
80101923:	5d                   	pop    %ebp
  release(&icache.lock);
80101924:	e9 07 36 00 00       	jmp    80104f30 <release>
80101929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 20 3a 11 80       	push   $0x80113a20
80101938:	e8 33 35 00 00       	call   80104e70 <acquire>
    int r = ip->ref;
8010193d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101940:	c7 04 24 20 3a 11 80 	movl   $0x80113a20,(%esp)
80101947:	e8 e4 35 00 00       	call   80104f30 <release>
    if(r == 1){
8010194c:	83 c4 10             	add    $0x10,%esp
8010194f:	83 fe 01             	cmp    $0x1,%esi
80101952:	75 a6                	jne    801018fa <iput+0x2a>
80101954:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010195a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010195d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101960:	89 cf                	mov    %ecx,%edi
80101962:	eb 0b                	jmp    8010196f <iput+0x9f>
80101964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101968:	83 c6 04             	add    $0x4,%esi
8010196b:	39 fe                	cmp    %edi,%esi
8010196d:	74 19                	je     80101988 <iput+0xb8>
    if(ip->addrs[i]){
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 74 f8 ff ff       	call   801011f0 <bfree>
      ip->addrs[i] = 0;
8010197c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101982:	eb e4                	jmp    80101968 <iput+0x98>
80101984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101988:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101991:	85 c0                	test   %eax,%eax
80101993:	75 33                	jne    801019c8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101995:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101998:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010199f:	53                   	push   %ebx
801019a0:	e8 3b fd ff ff       	call   801016e0 <iupdate>
      ip->type = 0;
801019a5:	31 c0                	xor    %eax,%eax
801019a7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019ab:	89 1c 24             	mov    %ebx,(%esp)
801019ae:	e8 2d fd ff ff       	call   801016e0 <iupdate>
      ip->valid = 0;
801019b3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019ba:	83 c4 10             	add    $0x10,%esp
801019bd:	e9 38 ff ff ff       	jmp    801018fa <iput+0x2a>
801019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019c8:	83 ec 08             	sub    $0x8,%esp
801019cb:	50                   	push   %eax
801019cc:	ff 33                	pushl  (%ebx)
801019ce:	e8 fd e6 ff ff       	call   801000d0 <bread>
801019d3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019d6:	83 c4 10             	add    $0x10,%esp
801019d9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019e2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019e5:	89 cf                	mov    %ecx,%edi
801019e7:	eb 0e                	jmp    801019f7 <iput+0x127>
801019e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019f0:	83 c6 04             	add    $0x4,%esi
801019f3:	39 f7                	cmp    %esi,%edi
801019f5:	74 19                	je     80101a10 <iput+0x140>
      if(a[j])
801019f7:	8b 16                	mov    (%esi),%edx
801019f9:	85 d2                	test   %edx,%edx
801019fb:	74 f3                	je     801019f0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019fd:	8b 03                	mov    (%ebx),%eax
801019ff:	e8 ec f7 ff ff       	call   801011f0 <bfree>
80101a04:	eb ea                	jmp    801019f0 <iput+0x120>
80101a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a10:	83 ec 0c             	sub    $0xc,%esp
80101a13:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a16:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a19:	e8 d2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a1e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a24:	8b 03                	mov    (%ebx),%eax
80101a26:	e8 c5 f7 ff ff       	call   801011f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a2b:	83 c4 10             	add    $0x10,%esp
80101a2e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a35:	00 00 00 
80101a38:	e9 58 ff ff ff       	jmp    80101995 <iput+0xc5>
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi

80101a40 <iunlockput>:
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	53                   	push   %ebx
80101a48:	83 ec 10             	sub    $0x10,%esp
80101a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a4e:	53                   	push   %ebx
80101a4f:	e8 2c fe ff ff       	call   80101880 <iunlock>
  iput(ip);
80101a54:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a57:	83 c4 10             	add    $0x10,%esp
}
80101a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a5d:	c9                   	leave  
  iput(ip);
80101a5e:	e9 6d fe ff ff       	jmp    801018d0 <iput>
80101a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	8b 55 08             	mov    0x8(%ebp),%edx
80101a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a7d:	8b 0a                	mov    (%edx),%ecx
80101a7f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a82:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a85:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a88:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a8c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a8f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a93:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a97:	8b 52 58             	mov    0x58(%edx),%edx
80101a9a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a9d:	5d                   	pop    %ebp
80101a9e:	c3                   	ret    
80101a9f:	90                   	nop

80101aa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101aa0:	f3 0f 1e fb          	endbr32 
80101aa4:	55                   	push   %ebp
80101aa5:	89 e5                	mov    %esp,%ebp
80101aa7:	57                   	push   %edi
80101aa8:	56                   	push   %esi
80101aa9:	53                   	push   %ebx
80101aaa:	83 ec 1c             	sub    $0x1c,%esp
80101aad:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101abc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ac1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ac4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ac7:	0f 84 a3 00 00 00    	je     80101b70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101acd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ad0:	8b 40 58             	mov    0x58(%eax),%eax
80101ad3:	39 c6                	cmp    %eax,%esi
80101ad5:	0f 87 b6 00 00 00    	ja     80101b91 <readi+0xf1>
80101adb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ade:	31 c9                	xor    %ecx,%ecx
80101ae0:	89 da                	mov    %ebx,%edx
80101ae2:	01 f2                	add    %esi,%edx
80101ae4:	0f 92 c1             	setb   %cl
80101ae7:	89 cf                	mov    %ecx,%edi
80101ae9:	0f 82 a2 00 00 00    	jb     80101b91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aef:	89 c1                	mov    %eax,%ecx
80101af1:	29 f1                	sub    %esi,%ecx
80101af3:	39 d0                	cmp    %edx,%eax
80101af5:	0f 43 cb             	cmovae %ebx,%ecx
80101af8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101afb:	85 c9                	test   %ecx,%ecx
80101afd:	74 63                	je     80101b62 <readi+0xc2>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	e8 61 f9 ff ff       	call   80101470 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 33                	pushl  (%ebx)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b1d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b22:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b25:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	89 f0                	mov    %esi,%eax
80101b29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b2e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b30:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b35:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b39:	39 d9                	cmp    %ebx,%ecx
80101b3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b3f:	01 df                	add    %ebx,%edi
80101b41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b43:	50                   	push   %eax
80101b44:	ff 75 e0             	pushl  -0x20(%ebp)
80101b47:	e8 d4 34 00 00       	call   80105020 <memmove>
    brelse(bp);
80101b4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b4f:	89 14 24             	mov    %edx,(%esp)
80101b52:	e8 99 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b60:	77 9e                	ja     80101b00 <readi+0x60>
  }
  return n;
80101b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5f                   	pop    %edi
80101b6b:	5d                   	pop    %ebp
80101b6c:	c3                   	ret    
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 17                	ja     80101b91 <readi+0xf1>
80101b7a:	8b 04 c5 a0 39 11 80 	mov    -0x7feec660(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 0c                	je     80101b91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b8f:	ff e0                	jmp    *%eax
      return -1;
80101b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b96:	eb cd                	jmp    80101b65 <readi+0xc5>
80101b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ba0:	f3 0f 1e fb          	endbr32 
80101ba4:	55                   	push   %ebp
80101ba5:	89 e5                	mov    %esp,%ebp
80101ba7:	57                   	push   %edi
80101ba8:	56                   	push   %esi
80101ba9:	53                   	push   %ebx
80101baa:	83 ec 1c             	sub    $0x1c,%esp
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bb3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bbb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc1:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bc7:	0f 84 b3 00 00 00    	je     80101c80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bcd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bd0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bd3:	0f 82 e3 00 00 00    	jb     80101cbc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bdc:	89 f8                	mov    %edi,%eax
80101bde:	01 f0                	add    %esi,%eax
80101be0:	0f 82 d6 00 00 00    	jb     80101cbc <writei+0x11c>
80101be6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101beb:	0f 87 cb 00 00 00    	ja     80101cbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bf8:	85 ff                	test   %edi,%edi
80101bfa:	74 75                	je     80101c71 <writei+0xd1>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 f8                	mov    %edi,%eax
80101c0a:	e8 61 f8 ff ff       	call   80101470 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 37                	pushl  (%edi)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	39 d9                	cmp    %ebx,%ecx
80101c39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c3f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c42:	50                   	push   %eax
80101c43:	e8 d8 33 00 00       	call   80105020 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 10 19 00 00       	call   80103560 <log_write>
    brelse(bp);
80101c50:	89 3c 24             	mov    %edi,(%esp)
80101c53:	e8 98 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c67:	77 97                	ja     80101c00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	77 37                	ja     80101ca8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
80101c7b:	c3                   	ret    
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c84:	66 83 f8 09          	cmp    $0x9,%ax
80101c88:	77 32                	ja     80101cbc <writei+0x11c>
80101c8a:	8b 04 c5 a4 39 11 80 	mov    -0x7feec65c(,%eax,8),%eax
80101c91:	85 c0                	test   %eax,%eax
80101c93:	74 27                	je     80101cbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c9f:	ff e0                	jmp    *%eax
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ca8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cb1:	50                   	push   %eax
80101cb2:	e8 29 fa ff ff       	call   801016e0 <iupdate>
80101cb7:	83 c4 10             	add    $0x10,%esp
80101cba:	eb b5                	jmp    80101c71 <writei+0xd1>
      return -1;
80101cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cc1:	eb b1                	jmp    80101c74 <writei+0xd4>
80101cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cda:	6a 0e                	push   $0xe
80101cdc:	ff 75 0c             	pushl  0xc(%ebp)
80101cdf:	ff 75 08             	pushl  0x8(%ebp)
80101ce2:	e8 a9 33 00 00       	call   80105090 <strncmp>
}
80101ce7:	c9                   	leave  
80101ce8:	c3                   	ret    
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	f3 0f 1e fb          	endbr32 
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	57                   	push   %edi
80101cf8:	56                   	push   %esi
80101cf9:	53                   	push   %ebx
80101cfa:	83 ec 1c             	sub    $0x1c,%esp
80101cfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d00:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d05:	0f 85 89 00 00 00    	jne    80101d94 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d0b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0e:	31 ff                	xor    %edi,%edi
80101d10:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d13:	85 d2                	test   %edx,%edx
80101d15:	74 42                	je     80101d59 <dirlookup+0x69>
80101d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d20:	6a 10                	push   $0x10
80101d22:	57                   	push   %edi
80101d23:	56                   	push   %esi
80101d24:	53                   	push   %ebx
80101d25:	e8 76 fd ff ff       	call   80101aa0 <readi>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	83 f8 10             	cmp    $0x10,%eax
80101d30:	75 55                	jne    80101d87 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d32:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d37:	74 18                	je     80101d51 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d39:	83 ec 04             	sub    $0x4,%esp
80101d3c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d3f:	6a 0e                	push   $0xe
80101d41:	50                   	push   %eax
80101d42:	ff 75 0c             	pushl  0xc(%ebp)
80101d45:	e8 46 33 00 00       	call   80105090 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	85 c0                	test   %eax,%eax
80101d4f:	74 17                	je     80101d68 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d51:	83 c7 10             	add    $0x10,%edi
80101d54:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d57:	72 c7                	jb     80101d20 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d5c:	31 c0                	xor    %eax,%eax
}
80101d5e:	5b                   	pop    %ebx
80101d5f:	5e                   	pop    %esi
80101d60:	5f                   	pop    %edi
80101d61:	5d                   	pop    %ebp
80101d62:	c3                   	ret    
80101d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d67:	90                   	nop
      if(poff)
80101d68:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6b:	85 c0                	test   %eax,%eax
80101d6d:	74 05                	je     80101d74 <dirlookup+0x84>
        *poff = off;
80101d6f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d72:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d74:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d78:	8b 03                	mov    (%ebx),%eax
80101d7a:	e8 01 f6 ff ff       	call   80101380 <iget>
}
80101d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d82:	5b                   	pop    %ebx
80101d83:	5e                   	pop    %esi
80101d84:	5f                   	pop    %edi
80101d85:	5d                   	pop    %ebp
80101d86:	c3                   	ret    
      panic("dirlookup read");
80101d87:	83 ec 0c             	sub    $0xc,%esp
80101d8a:	68 59 84 10 80       	push   $0x80108459
80101d8f:	e8 fc e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	68 47 84 10 80       	push   $0x80108447
80101d9c:	e8 ef e5 ff ff       	call   80100390 <panic>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop

80101db0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	89 c3                	mov    %eax,%ebx
80101db8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dbb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dbe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dc4:	0f 84 86 01 00 00    	je     80101f50 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dca:	e8 c1 22 00 00       	call   80104090 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101dd4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd7:	68 20 3a 11 80       	push   $0x80113a20
80101ddc:	e8 8f 30 00 00       	call   80104e70 <acquire>
  ip->ref++;
80101de1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de5:	c7 04 24 20 3a 11 80 	movl   $0x80113a20,(%esp)
80101dec:	e8 3f 31 00 00       	call   80104f30 <release>
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	eb 0d                	jmp    80101e03 <namex+0x53>
80101df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e00:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e03:	0f b6 07             	movzbl (%edi),%eax
80101e06:	3c 2f                	cmp    $0x2f,%al
80101e08:	74 f6                	je     80101e00 <namex+0x50>
  if(*path == 0)
80101e0a:	84 c0                	test   %al,%al
80101e0c:	0f 84 ee 00 00 00    	je     80101f00 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e12:	0f b6 07             	movzbl (%edi),%eax
80101e15:	84 c0                	test   %al,%al
80101e17:	0f 84 fb 00 00 00    	je     80101f18 <namex+0x168>
80101e1d:	89 fb                	mov    %edi,%ebx
80101e1f:	3c 2f                	cmp    $0x2f,%al
80101e21:	0f 84 f1 00 00 00    	je     80101f18 <namex+0x168>
80101e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e2e:	66 90                	xchg   %ax,%ax
80101e30:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e34:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e37:	3c 2f                	cmp    $0x2f,%al
80101e39:	74 04                	je     80101e3f <namex+0x8f>
80101e3b:	84 c0                	test   %al,%al
80101e3d:	75 f1                	jne    80101e30 <namex+0x80>
  len = path - s;
80101e3f:	89 d8                	mov    %ebx,%eax
80101e41:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e43:	83 f8 0d             	cmp    $0xd,%eax
80101e46:	0f 8e 84 00 00 00    	jle    80101ed0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e4c:	83 ec 04             	sub    $0x4,%esp
80101e4f:	6a 0e                	push   $0xe
80101e51:	57                   	push   %edi
    path++;
80101e52:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e54:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e57:	e8 c4 31 00 00       	call   80105020 <memmove>
80101e5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e5f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e62:	75 0c                	jne    80101e70 <namex+0xc0>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e68:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e6b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e6e:	74 f8                	je     80101e68 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	56                   	push   %esi
80101e74:	e8 27 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e79:	83 c4 10             	add    $0x10,%esp
80101e7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e81:	0f 85 a1 00 00 00    	jne    80101f28 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e8a:	85 d2                	test   %edx,%edx
80101e8c:	74 09                	je     80101e97 <namex+0xe7>
80101e8e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e91:	0f 84 d9 00 00 00    	je     80101f70 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e97:	83 ec 04             	sub    $0x4,%esp
80101e9a:	6a 00                	push   $0x0
80101e9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e9f:	56                   	push   %esi
80101ea0:	e8 4b fe ff ff       	call   80101cf0 <dirlookup>
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	89 c3                	mov    %eax,%ebx
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	74 7a                	je     80101f28 <namex+0x178>
  iunlock(ip);
80101eae:	83 ec 0c             	sub    $0xc,%esp
80101eb1:	56                   	push   %esi
80101eb2:	e8 c9 f9 ff ff       	call   80101880 <iunlock>
  iput(ip);
80101eb7:	89 34 24             	mov    %esi,(%esp)
80101eba:	89 de                	mov    %ebx,%esi
80101ebc:	e8 0f fa ff ff       	call   801018d0 <iput>
80101ec1:	83 c4 10             	add    $0x10,%esp
80101ec4:	e9 3a ff ff ff       	jmp    80101e03 <namex+0x53>
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ed3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ed6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ed9:	83 ec 04             	sub    $0x4,%esp
80101edc:	50                   	push   %eax
80101edd:	57                   	push   %edi
    name[len] = 0;
80101ede:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ee0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ee3:	e8 38 31 00 00       	call   80105020 <memmove>
    name[len] = 0;
80101ee8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	c6 00 00             	movb   $0x0,(%eax)
80101ef1:	e9 69 ff ff ff       	jmp    80101e5f <namex+0xaf>
80101ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 85 00 00 00    	jne    80101f90 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
80101f15:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f1b:	89 fb                	mov    %edi,%ebx
80101f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f20:	31 c0                	xor    %eax,%eax
80101f22:	eb b5                	jmp    80101ed9 <namex+0x129>
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	56                   	push   %esi
80101f2c:	e8 4f f9 ff ff       	call   80101880 <iunlock>
  iput(ip);
80101f31:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f34:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f36:	e8 95 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f3b:	83 c4 10             	add    $0x10,%esp
}
80101f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f41:	89 f0                	mov    %esi,%eax
80101f43:	5b                   	pop    %ebx
80101f44:	5e                   	pop    %esi
80101f45:	5f                   	pop    %edi
80101f46:	5d                   	pop    %ebp
80101f47:	c3                   	ret    
80101f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f50:	ba 01 00 00 00       	mov    $0x1,%edx
80101f55:	b8 01 00 00 00       	mov    $0x1,%eax
80101f5a:	89 df                	mov    %ebx,%edi
80101f5c:	e8 1f f4 ff ff       	call   80101380 <iget>
80101f61:	89 c6                	mov    %eax,%esi
80101f63:	e9 9b fe ff ff       	jmp    80101e03 <namex+0x53>
80101f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6f:	90                   	nop
      iunlock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 07 f9 ff ff       	call   80101880 <iunlock>
      return ip;
80101f79:	83 c4 10             	add    $0x10,%esp
}
80101f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7f:	89 f0                	mov    %esi,%eax
80101f81:	5b                   	pop    %ebx
80101f82:	5e                   	pop    %esi
80101f83:	5f                   	pop    %edi
80101f84:	5d                   	pop    %ebp
80101f85:	c3                   	ret    
80101f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	56                   	push   %esi
    return 0;
80101f94:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f96:	e8 35 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	e9 68 ff ff ff       	jmp    80101f0b <namex+0x15b>
80101fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fb0 <dirlink>:
{
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	57                   	push   %edi
80101fb8:	56                   	push   %esi
80101fb9:	53                   	push   %ebx
80101fba:	83 ec 20             	sub    $0x20,%esp
80101fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fc0:	6a 00                	push   $0x0
80101fc2:	ff 75 0c             	pushl  0xc(%ebp)
80101fc5:	53                   	push   %ebx
80101fc6:	e8 25 fd ff ff       	call   80101cf0 <dirlookup>
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	85 c0                	test   %eax,%eax
80101fd0:	75 6b                	jne    8010203d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fd2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fd5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fd8:	85 ff                	test   %edi,%edi
80101fda:	74 2d                	je     80102009 <dirlink+0x59>
80101fdc:	31 ff                	xor    %edi,%edi
80101fde:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe1:	eb 0d                	jmp    80101ff0 <dirlink+0x40>
80101fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe7:	90                   	nop
80101fe8:	83 c7 10             	add    $0x10,%edi
80101feb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fee:	73 19                	jae    80102009 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff0:	6a 10                	push   $0x10
80101ff2:	57                   	push   %edi
80101ff3:	56                   	push   %esi
80101ff4:	53                   	push   %ebx
80101ff5:	e8 a6 fa ff ff       	call   80101aa0 <readi>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	83 f8 10             	cmp    $0x10,%eax
80102000:	75 4e                	jne    80102050 <dirlink+0xa0>
    if(de.inum == 0)
80102002:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102007:	75 df                	jne    80101fe8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102009:	83 ec 04             	sub    $0x4,%esp
8010200c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010200f:	6a 0e                	push   $0xe
80102011:	ff 75 0c             	pushl  0xc(%ebp)
80102014:	50                   	push   %eax
80102015:	e8 c6 30 00 00       	call   801050e0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010201a:	6a 10                	push   $0x10
  de.inum = inum;
8010201c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010201f:	57                   	push   %edi
80102020:	56                   	push   %esi
80102021:	53                   	push   %ebx
  de.inum = inum;
80102022:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102026:	e8 75 fb ff ff       	call   80101ba0 <writei>
8010202b:	83 c4 20             	add    $0x20,%esp
8010202e:	83 f8 10             	cmp    $0x10,%eax
80102031:	75 2a                	jne    8010205d <dirlink+0xad>
  return 0;
80102033:	31 c0                	xor    %eax,%eax
}
80102035:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102038:	5b                   	pop    %ebx
80102039:	5e                   	pop    %esi
8010203a:	5f                   	pop    %edi
8010203b:	5d                   	pop    %ebp
8010203c:	c3                   	ret    
    iput(ip);
8010203d:	83 ec 0c             	sub    $0xc,%esp
80102040:	50                   	push   %eax
80102041:	e8 8a f8 ff ff       	call   801018d0 <iput>
    return -1;
80102046:	83 c4 10             	add    $0x10,%esp
80102049:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010204e:	eb e5                	jmp    80102035 <dirlink+0x85>
      panic("dirlink read");
80102050:	83 ec 0c             	sub    $0xc,%esp
80102053:	68 68 84 10 80       	push   $0x80108468
80102058:	e8 33 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010205d:	83 ec 0c             	sub    $0xc,%esp
80102060:	68 35 8b 10 80       	push   $0x80108b35
80102065:	e8 26 e3 ff ff       	call   80100390 <panic>
8010206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102070 <namei>:

struct inode*
namei(char *path)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102075:	31 d2                	xor    %edx,%edx
{
80102077:	89 e5                	mov    %esp,%ebp
80102079:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102082:	e8 29 fd ff ff       	call   80101db0 <namex>
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102090:	f3 0f 1e fb          	endbr32 
80102094:	55                   	push   %ebp
  return namex(path, 1, name);
80102095:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010209a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010209c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010209f:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020a2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020a3:	e9 08 fd ff ff       	jmp    80101db0 <namex>
801020a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020af:	90                   	nop

801020b0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801020b0:	f3 0f 1e fb          	endbr32 
801020b4:	55                   	push   %ebp
    char const digit[] = "0123456789";
801020b5:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801020ba:	89 e5                	mov    %esp,%ebp
801020bc:	57                   	push   %edi
801020bd:	56                   	push   %esi
801020be:	53                   	push   %ebx
801020bf:	83 ec 10             	sub    $0x10,%esp
801020c2:	8b 7d 0c             	mov    0xc(%ebp),%edi
801020c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801020c8:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801020cf:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801020d6:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801020da:	89 fb                	mov    %edi,%ebx
801020dc:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
801020e0:	85 c9                	test   %ecx,%ecx
801020e2:	79 08                	jns    801020ec <itoa+0x3c>
        *p++ = '-';
801020e4:	c6 07 2d             	movb   $0x2d,(%edi)
801020e7:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
801020ea:	f7 d9                	neg    %ecx
    }
    int shifter = i;
801020ec:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801020ee:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f7:	90                   	nop
801020f8:	89 d0                	mov    %edx,%eax
        ++p;
801020fa:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
801020fd:	f7 e6                	mul    %esi
    }while(shifter);
801020ff:	c1 ea 03             	shr    $0x3,%edx
80102102:	75 f4                	jne    801020f8 <itoa+0x48>
    *p = '\0';
80102104:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102107:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102110:	89 c8                	mov    %ecx,%eax
80102112:	83 eb 01             	sub    $0x1,%ebx
80102115:	f7 e6                	mul    %esi
80102117:	c1 ea 03             	shr    $0x3,%edx
8010211a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010211d:	01 c0                	add    %eax,%eax
8010211f:	29 c1                	sub    %eax,%ecx
80102121:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102126:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102128:	88 03                	mov    %al,(%ebx)
    }while(i);
8010212a:	85 d2                	test   %edx,%edx
8010212c:	75 e2                	jne    80102110 <itoa+0x60>
    return b;
}
8010212e:	83 c4 10             	add    $0x10,%esp
80102131:	89 f8                	mov    %edi,%eax
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
80102138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213f:	90                   	nop

80102140 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102140:	f3 0f 1e fb          	endbr32 
80102144:	55                   	push   %ebp
80102145:	89 e5                	mov    %esp,%ebp
80102147:	57                   	push   %edi
80102148:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102149:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010214c:	53                   	push   %ebx
8010214d:	83 ec 40             	sub    $0x40,%esp
80102150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102153:	6a 06                	push   $0x6
80102155:	68 75 84 10 80       	push   $0x80108475
8010215a:	56                   	push   %esi
8010215b:	e8 c0 2e 00 00       	call   80105020 <memmove>
  itoa(p->pid, path+ 6);
80102160:	58                   	pop    %eax
80102161:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102164:	5a                   	pop    %edx
80102165:	50                   	push   %eax
80102166:	ff 73 10             	pushl  0x10(%ebx)
80102169:	e8 42 ff ff ff       	call   801020b0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010216e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102171:	83 c4 10             	add    $0x10,%esp
80102174:	85 c0                	test   %eax,%eax
80102176:	0f 84 7a 01 00 00    	je     801022f6 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
8010217c:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010217f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80102182:	50                   	push   %eax
80102183:	e8 78 ed ff ff       	call   80100f00 <fileclose>

  begin_op();
80102188:	e8 f3 11 00 00       	call   80103380 <begin_op>
  return namex(path, 1, name);
8010218d:	89 f0                	mov    %esi,%eax
8010218f:	89 d9                	mov    %ebx,%ecx
80102191:	ba 01 00 00 00       	mov    $0x1,%edx
80102196:	e8 15 fc ff ff       	call   80101db0 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010219b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010219e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801021a0:	85 c0                	test   %eax,%eax
801021a2:	0f 84 55 01 00 00    	je     801022fd <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	50                   	push   %eax
801021ac:	e8 ef f5 ff ff       	call   801017a0 <ilock>
  return strncmp(s, t, DIRSIZ);
801021b1:	83 c4 0c             	add    $0xc,%esp
801021b4:	6a 0e                	push   $0xe
801021b6:	68 7d 84 10 80       	push   $0x8010847d
801021bb:	53                   	push   %ebx
801021bc:	e8 cf 2e 00 00       	call   80105090 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801021c1:	83 c4 10             	add    $0x10,%esp
801021c4:	85 c0                	test   %eax,%eax
801021c6:	0f 84 f4 00 00 00    	je     801022c0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	6a 0e                	push   $0xe
801021d1:	68 7c 84 10 80       	push   $0x8010847c
801021d6:	53                   	push   %ebx
801021d7:	e8 b4 2e 00 00       	call   80105090 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801021dc:	83 c4 10             	add    $0x10,%esp
801021df:	85 c0                	test   %eax,%eax
801021e1:	0f 84 d9 00 00 00    	je     801022c0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801021e7:	83 ec 04             	sub    $0x4,%esp
801021ea:	8d 45 b8             	lea    -0x48(%ebp),%eax
801021ed:	50                   	push   %eax
801021ee:	53                   	push   %ebx
801021ef:	56                   	push   %esi
801021f0:	e8 fb fa ff ff       	call   80101cf0 <dirlookup>
801021f5:	83 c4 10             	add    $0x10,%esp
801021f8:	89 c3                	mov    %eax,%ebx
801021fa:	85 c0                	test   %eax,%eax
801021fc:	0f 84 be 00 00 00    	je     801022c0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102202:	83 ec 0c             	sub    $0xc,%esp
80102205:	50                   	push   %eax
80102206:	e8 95 f5 ff ff       	call   801017a0 <ilock>

  if(ip->nlink < 1)
8010220b:	83 c4 10             	add    $0x10,%esp
8010220e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102213:	0f 8e 00 01 00 00    	jle    80102319 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102219:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010221e:	74 78                	je     80102298 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80102220:	83 ec 04             	sub    $0x4,%esp
80102223:	8d 7d d8             	lea    -0x28(%ebp),%edi
80102226:	6a 10                	push   $0x10
80102228:	6a 00                	push   $0x0
8010222a:	57                   	push   %edi
8010222b:	e8 50 2d 00 00       	call   80104f80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102230:	6a 10                	push   $0x10
80102232:	ff 75 b8             	pushl  -0x48(%ebp)
80102235:	57                   	push   %edi
80102236:	56                   	push   %esi
80102237:	e8 64 f9 ff ff       	call   80101ba0 <writei>
8010223c:	83 c4 20             	add    $0x20,%esp
8010223f:	83 f8 10             	cmp    $0x10,%eax
80102242:	0f 85 c4 00 00 00    	jne    8010230c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102248:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010224d:	0f 84 8d 00 00 00    	je     801022e0 <removeSwapFile+0x1a0>
  iunlock(ip);
80102253:	83 ec 0c             	sub    $0xc,%esp
80102256:	56                   	push   %esi
80102257:	e8 24 f6 ff ff       	call   80101880 <iunlock>
  iput(ip);
8010225c:	89 34 24             	mov    %esi,(%esp)
8010225f:	e8 6c f6 ff ff       	call   801018d0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102264:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102269:	89 1c 24             	mov    %ebx,(%esp)
8010226c:	e8 6f f4 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
80102271:	89 1c 24             	mov    %ebx,(%esp)
80102274:	e8 07 f6 ff ff       	call   80101880 <iunlock>
  iput(ip);
80102279:	89 1c 24             	mov    %ebx,(%esp)
8010227c:	e8 4f f6 ff ff       	call   801018d0 <iput>
  iunlockput(ip);

  end_op();
80102281:	e8 6a 11 00 00       	call   801033f0 <end_op>

  return 0;
80102286:	83 c4 10             	add    $0x10,%esp
80102289:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
8010228b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010228e:	5b                   	pop    %ebx
8010228f:	5e                   	pop    %esi
80102290:	5f                   	pop    %edi
80102291:	5d                   	pop    %ebp
80102292:	c3                   	ret    
80102293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102297:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	53                   	push   %ebx
8010229c:	e8 af 34 00 00       	call   80105750 <isdirempty>
801022a1:	83 c4 10             	add    $0x10,%esp
801022a4:	85 c0                	test   %eax,%eax
801022a6:	0f 85 74 ff ff ff    	jne    80102220 <removeSwapFile+0xe0>
  iunlock(ip);
801022ac:	83 ec 0c             	sub    $0xc,%esp
801022af:	53                   	push   %ebx
801022b0:	e8 cb f5 ff ff       	call   80101880 <iunlock>
  iput(ip);
801022b5:	89 1c 24             	mov    %ebx,(%esp)
801022b8:	e8 13 f6 ff ff       	call   801018d0 <iput>
    goto bad;
801022bd:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801022c0:	83 ec 0c             	sub    $0xc,%esp
801022c3:	56                   	push   %esi
801022c4:	e8 b7 f5 ff ff       	call   80101880 <iunlock>
  iput(ip);
801022c9:	89 34 24             	mov    %esi,(%esp)
801022cc:	e8 ff f5 ff ff       	call   801018d0 <iput>
    end_op();
801022d1:	e8 1a 11 00 00       	call   801033f0 <end_op>
    return -1;
801022d6:	83 c4 10             	add    $0x10,%esp
801022d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022de:	eb ab                	jmp    8010228b <removeSwapFile+0x14b>
    iupdate(dp);
801022e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801022e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801022e8:	56                   	push   %esi
801022e9:	e8 f2 f3 ff ff       	call   801016e0 <iupdate>
801022ee:	83 c4 10             	add    $0x10,%esp
801022f1:	e9 5d ff ff ff       	jmp    80102253 <removeSwapFile+0x113>
    return -1;
801022f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022fb:	eb 8e                	jmp    8010228b <removeSwapFile+0x14b>
    end_op();
801022fd:	e8 ee 10 00 00       	call   801033f0 <end_op>
    return -1;
80102302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102307:	e9 7f ff ff ff       	jmp    8010228b <removeSwapFile+0x14b>
    panic("unlink: writei");
8010230c:	83 ec 0c             	sub    $0xc,%esp
8010230f:	68 91 84 10 80       	push   $0x80108491
80102314:	e8 77 e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102319:	83 ec 0c             	sub    $0xc,%esp
8010231c:	68 7f 84 10 80       	push   $0x8010847f
80102321:	e8 6a e0 ff ff       	call   80100390 <panic>
80102326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232d:	8d 76 00             	lea    0x0(%esi),%esi

80102330 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102330:	f3 0f 1e fb          	endbr32 
80102334:	55                   	push   %ebp
80102335:	89 e5                	mov    %esp,%ebp
80102337:	56                   	push   %esi
80102338:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102339:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
8010233c:	83 ec 14             	sub    $0x14,%esp
8010233f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102342:	6a 06                	push   $0x6
80102344:	68 75 84 10 80       	push   $0x80108475
80102349:	56                   	push   %esi
8010234a:	e8 d1 2c 00 00       	call   80105020 <memmove>
  itoa(p->pid, path+ 6);
8010234f:	58                   	pop    %eax
80102350:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102353:	5a                   	pop    %edx
80102354:	50                   	push   %eax
80102355:	ff 73 10             	pushl  0x10(%ebx)
80102358:	e8 53 fd ff ff       	call   801020b0 <itoa>

    begin_op();
8010235d:	e8 1e 10 00 00       	call   80103380 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
80102362:	6a 00                	push   $0x0
80102364:	6a 00                	push   $0x0
80102366:	6a 02                	push   $0x2
80102368:	56                   	push   %esi
80102369:	e8 02 36 00 00       	call   80105970 <create>
  iunlock(in);
8010236e:	83 c4 14             	add    $0x14,%esp
80102371:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
80102372:	89 c6                	mov    %eax,%esi
  iunlock(in);
80102374:	e8 07 f5 ff ff       	call   80101880 <iunlock>

  p->swapFile = filealloc();
80102379:	e8 c2 ea ff ff       	call   80100e40 <filealloc>
  if (p->swapFile == 0)
8010237e:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
80102381:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102384:	85 c0                	test   %eax,%eax
80102386:	74 32                	je     801023ba <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102388:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
8010238b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010238e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102394:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102397:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010239e:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023a1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801023a5:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023a8:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801023ac:	e8 3f 10 00 00       	call   801033f0 <end_op>

    return 0;
}
801023b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b4:	31 c0                	xor    %eax,%eax
801023b6:	5b                   	pop    %ebx
801023b7:	5e                   	pop    %esi
801023b8:	5d                   	pop    %ebp
801023b9:	c3                   	ret    
    panic("no slot for files on /store");
801023ba:	83 ec 0c             	sub    $0xc,%esp
801023bd:	68 a0 84 10 80       	push   $0x801084a0
801023c2:	e8 c9 df ff ff       	call   80100390 <panic>
801023c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023d0:	f3 0f 1e fb          	endbr32 
801023d4:	55                   	push   %ebp
801023d5:	89 e5                	mov    %esp,%ebp
801023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801023da:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023dd:	8b 50 7c             	mov    0x7c(%eax),%edx
801023e0:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801023e3:	8b 55 14             	mov    0x14(%ebp),%edx
801023e6:	89 55 10             	mov    %edx,0x10(%ebp)
801023e9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023ec:	89 45 08             	mov    %eax,0x8(%ebp)

}
801023ef:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801023f0:	e9 db ec ff ff       	jmp    801010d0 <filewrite>
801023f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102400:	f3 0f 1e fb          	endbr32 
80102404:	55                   	push   %ebp
80102405:	89 e5                	mov    %esp,%ebp
80102407:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010240a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010240d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102410:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
80102413:	8b 55 14             	mov    0x14(%ebp),%edx
80102416:	89 55 10             	mov    %edx,0x10(%ebp)
80102419:	8b 40 7c             	mov    0x7c(%eax),%eax
8010241c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010241f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
80102420:	e9 0b ec ff ff       	jmp    80101030 <fileread>
80102425:	66 90                	xchg   %ax,%ax
80102427:	66 90                	xchg   %ax,%ax
80102429:	66 90                	xchg   %ax,%ax
8010242b:	66 90                	xchg   %ax,%ax
8010242d:	66 90                	xchg   %ax,%ax
8010242f:	90                   	nop

80102430 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102439:	85 c0                	test   %eax,%eax
8010243b:	0f 84 b4 00 00 00    	je     801024f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102441:	8b 70 08             	mov    0x8(%eax),%esi
80102444:	89 c3                	mov    %eax,%ebx
80102446:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010244c:	0f 87 96 00 00 00    	ja     801024e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245e:	66 90                	xchg   %ax,%ax
80102460:	89 ca                	mov    %ecx,%edx
80102462:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102463:	83 e0 c0             	and    $0xffffffc0,%eax
80102466:	3c 40                	cmp    $0x40,%al
80102468:	75 f6                	jne    80102460 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010246a:	31 ff                	xor    %edi,%edi
8010246c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102471:	89 f8                	mov    %edi,%eax
80102473:	ee                   	out    %al,(%dx)
80102474:	b8 01 00 00 00       	mov    $0x1,%eax
80102479:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010247e:	ee                   	out    %al,(%dx)
8010247f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102484:	89 f0                	mov    %esi,%eax
80102486:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102487:	89 f0                	mov    %esi,%eax
80102489:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010248e:	c1 f8 08             	sar    $0x8,%eax
80102491:	ee                   	out    %al,(%dx)
80102492:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102497:	89 f8                	mov    %edi,%eax
80102499:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010249a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010249e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024a3:	c1 e0 04             	shl    $0x4,%eax
801024a6:	83 e0 10             	and    $0x10,%eax
801024a9:	83 c8 e0             	or     $0xffffffe0,%eax
801024ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024ad:	f6 03 04             	testb  $0x4,(%ebx)
801024b0:	75 16                	jne    801024c8 <idestart+0x98>
801024b2:	b8 20 00 00 00       	mov    $0x20,%eax
801024b7:	89 ca                	mov    %ecx,%edx
801024b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801024ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024bd:	5b                   	pop    %ebx
801024be:	5e                   	pop    %esi
801024bf:	5f                   	pop    %edi
801024c0:	5d                   	pop    %ebp
801024c1:	c3                   	ret    
801024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024c8:	b8 30 00 00 00       	mov    $0x30,%eax
801024cd:	89 ca                	mov    %ecx,%edx
801024cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801024d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801024d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801024d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024dd:	fc                   	cld    
801024de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e3:	5b                   	pop    %ebx
801024e4:	5e                   	pop    %esi
801024e5:	5f                   	pop    %edi
801024e6:	5d                   	pop    %ebp
801024e7:	c3                   	ret    
    panic("incorrect blockno");
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 18 85 10 80       	push   $0x80108518
801024f0:	e8 9b de ff ff       	call   80100390 <panic>
    panic("idestart");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 0f 85 10 80       	push   $0x8010850f
801024fd:	e8 8e de ff ff       	call   80100390 <panic>
80102502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102510 <ideinit>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010251a:	68 2a 85 10 80       	push   $0x8010852a
8010251f:	68 80 b5 10 80       	push   $0x8010b580
80102524:	e8 c7 27 00 00       	call   80104cf0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102529:	58                   	pop    %eax
8010252a:	a1 40 5d 18 80       	mov    0x80185d40,%eax
8010252f:	5a                   	pop    %edx
80102530:	83 e8 01             	sub    $0x1,%eax
80102533:	50                   	push   %eax
80102534:	6a 0e                	push   $0xe
80102536:	e8 b5 02 00 00       	call   801027f0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010253b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010253e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102547:	90                   	nop
80102548:	ec                   	in     (%dx),%al
80102549:	83 e0 c0             	and    $0xffffffc0,%eax
8010254c:	3c 40                	cmp    $0x40,%al
8010254e:	75 f8                	jne    80102548 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102550:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102555:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010255a:	ee                   	out    %al,(%dx)
8010255b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102560:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102565:	eb 0e                	jmp    80102575 <ideinit+0x65>
80102567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102570:	83 e9 01             	sub    $0x1,%ecx
80102573:	74 0f                	je     80102584 <ideinit+0x74>
80102575:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102576:	84 c0                	test   %al,%al
80102578:	74 f6                	je     80102570 <ideinit+0x60>
      havedisk1 = 1;
8010257a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102581:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102584:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102589:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010258e:	ee                   	out    %al,(%dx)
}
8010258f:	c9                   	leave  
80102590:	c3                   	ret    
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop

801025a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	57                   	push   %edi
801025a8:	56                   	push   %esi
801025a9:	53                   	push   %ebx
801025aa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025ad:	68 80 b5 10 80       	push   $0x8010b580
801025b2:	e8 b9 28 00 00       	call   80104e70 <acquire>

  if((b = idequeue) == 0){
801025b7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	85 db                	test   %ebx,%ebx
801025c2:	74 5f                	je     80102623 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025c4:	8b 43 58             	mov    0x58(%ebx),%eax
801025c7:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801025cc:	8b 33                	mov    (%ebx),%esi
801025ce:	f7 c6 04 00 00 00    	test   $0x4,%esi
801025d4:	75 2b                	jne    80102601 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop
801025e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801025e6:	80 f9 40             	cmp    $0x40,%cl
801025e9:	75 f5                	jne    801025e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025eb:	a8 21                	test   $0x21,%al
801025ed:	75 12                	jne    80102601 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801025ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801025f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025fc:	fc                   	cld    
801025fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801025ff:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102601:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102604:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102607:	83 ce 02             	or     $0x2,%esi
8010260a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010260c:	53                   	push   %ebx
8010260d:	e8 8e 23 00 00       	call   801049a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102612:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	85 c0                	test   %eax,%eax
8010261c:	74 05                	je     80102623 <ideintr+0x83>
    idestart(idequeue);
8010261e:	e8 0d fe ff ff       	call   80102430 <idestart>
    release(&idelock);
80102623:	83 ec 0c             	sub    $0xc,%esp
80102626:	68 80 b5 10 80       	push   $0x8010b580
8010262b:	e8 00 29 00 00       	call   80104f30 <release>

  release(&idelock);
}
80102630:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102633:	5b                   	pop    %ebx
80102634:	5e                   	pop    %esi
80102635:	5f                   	pop    %edi
80102636:	5d                   	pop    %ebp
80102637:	c3                   	ret    
80102638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263f:	90                   	nop

80102640 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102640:	f3 0f 1e fb          	endbr32 
80102644:	55                   	push   %ebp
80102645:	89 e5                	mov    %esp,%ebp
80102647:	53                   	push   %ebx
80102648:	83 ec 10             	sub    $0x10,%esp
8010264b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010264e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102651:	50                   	push   %eax
80102652:	e8 39 26 00 00       	call   80104c90 <holdingsleep>
80102657:	83 c4 10             	add    $0x10,%esp
8010265a:	85 c0                	test   %eax,%eax
8010265c:	0f 84 cf 00 00 00    	je     80102731 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102662:	8b 03                	mov    (%ebx),%eax
80102664:	83 e0 06             	and    $0x6,%eax
80102667:	83 f8 02             	cmp    $0x2,%eax
8010266a:	0f 84 b4 00 00 00    	je     80102724 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102670:	8b 53 04             	mov    0x4(%ebx),%edx
80102673:	85 d2                	test   %edx,%edx
80102675:	74 0d                	je     80102684 <iderw+0x44>
80102677:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010267c:	85 c0                	test   %eax,%eax
8010267e:	0f 84 93 00 00 00    	je     80102717 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	68 80 b5 10 80       	push   $0x8010b580
8010268c:	e8 df 27 00 00       	call   80104e70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102691:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102696:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	85 c0                	test   %eax,%eax
801026a2:	74 6c                	je     80102710 <iderw+0xd0>
801026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026a8:	89 c2                	mov    %eax,%edx
801026aa:	8b 40 58             	mov    0x58(%eax),%eax
801026ad:	85 c0                	test   %eax,%eax
801026af:	75 f7                	jne    801026a8 <iderw+0x68>
801026b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026b6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801026bc:	74 42                	je     80102700 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026be:	8b 03                	mov    (%ebx),%eax
801026c0:	83 e0 06             	and    $0x6,%eax
801026c3:	83 f8 02             	cmp    $0x2,%eax
801026c6:	74 23                	je     801026eb <iderw+0xab>
801026c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop
    sleep(b, &idelock);
801026d0:	83 ec 08             	sub    $0x8,%esp
801026d3:	68 80 b5 10 80       	push   $0x8010b580
801026d8:	53                   	push   %ebx
801026d9:	e8 c2 20 00 00       	call   801047a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026de:	8b 03                	mov    (%ebx),%eax
801026e0:	83 c4 10             	add    $0x10,%esp
801026e3:	83 e0 06             	and    $0x6,%eax
801026e6:	83 f8 02             	cmp    $0x2,%eax
801026e9:	75 e5                	jne    801026d0 <iderw+0x90>
  }


  release(&idelock);
801026eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801026f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f5:	c9                   	leave  
  release(&idelock);
801026f6:	e9 35 28 00 00       	jmp    80104f30 <release>
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop
    idestart(b);
80102700:	89 d8                	mov    %ebx,%eax
80102702:	e8 29 fd ff ff       	call   80102430 <idestart>
80102707:	eb b5                	jmp    801026be <iderw+0x7e>
80102709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102710:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102715:	eb 9d                	jmp    801026b4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102717:	83 ec 0c             	sub    $0xc,%esp
8010271a:	68 59 85 10 80       	push   $0x80108559
8010271f:	e8 6c dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102724:	83 ec 0c             	sub    $0xc,%esp
80102727:	68 44 85 10 80       	push   $0x80108544
8010272c:	e8 5f dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102731:	83 ec 0c             	sub    $0xc,%esp
80102734:	68 2e 85 10 80       	push   $0x8010852e
80102739:	e8 52 dc ff ff       	call   80100390 <panic>
8010273e:	66 90                	xchg   %ax,%ax

80102740 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102745:	c7 05 74 56 11 80 00 	movl   $0xfec00000,0x80115674
8010274c:	00 c0 fe 
{
8010274f:	89 e5                	mov    %esp,%ebp
80102751:	56                   	push   %esi
80102752:	53                   	push   %ebx
  ioapic->reg = reg;
80102753:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010275a:	00 00 00 
  return ioapic->data;
8010275d:	8b 15 74 56 11 80    	mov    0x80115674,%edx
80102763:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102766:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010276c:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102772:	0f b6 15 a0 57 18 80 	movzbl 0x801857a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102779:	c1 ee 10             	shr    $0x10,%esi
8010277c:	89 f0                	mov    %esi,%eax
8010277e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102781:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102784:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102787:	39 c2                	cmp    %eax,%edx
80102789:	74 16                	je     801027a1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010278b:	83 ec 0c             	sub    $0xc,%esp
8010278e:	68 78 85 10 80       	push   $0x80108578
80102793:	e8 18 df ff ff       	call   801006b0 <cprintf>
80102798:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
8010279e:	83 c4 10             	add    $0x10,%esp
801027a1:	83 c6 21             	add    $0x21,%esi
{
801027a4:	ba 10 00 00 00       	mov    $0x10,%edx
801027a9:	b8 20 00 00 00       	mov    $0x20,%eax
801027ae:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801027b0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027b2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801027b4:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
801027ba:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027bd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801027c3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801027c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801027c9:	83 c2 02             	add    $0x2,%edx
801027cc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801027ce:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
801027d4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801027db:	39 f0                	cmp    %esi,%eax
801027dd:	75 d1                	jne    801027b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801027df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e2:	5b                   	pop    %ebx
801027e3:	5e                   	pop    %esi
801027e4:	5d                   	pop    %ebp
801027e5:	c3                   	ret    
801027e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ed:	8d 76 00             	lea    0x0(%esi),%esi

801027f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
  ioapic->reg = reg;
801027f5:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
{
801027fb:	89 e5                	mov    %esp,%ebp
801027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102800:	8d 50 20             	lea    0x20(%eax),%edx
80102803:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102807:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102809:	8b 0d 74 56 11 80    	mov    0x80115674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010280f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102812:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102815:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102818:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010281a:	a1 74 56 11 80       	mov    0x80115674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010281f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102822:	89 50 10             	mov    %edx,0x10(%eax)
}
80102825:	5d                   	pop    %ebp
80102826:	c3                   	ret    
80102827:	66 90                	xchg   %ax,%ax
80102829:	66 90                	xchg   %ax,%ax
8010282b:	66 90                	xchg   %ax,%ax
8010282d:	66 90                	xchg   %ax,%ax
8010282f:	90                   	nop

80102830 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	53                   	push   %ebx
80102838:	83 ec 04             	sub    $0x4,%esp
8010283b:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010283e:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102843:	0f 85 af 00 00 00    	jne    801028f8 <kfree+0xc8>
80102849:	3d e8 0b 19 80       	cmp    $0x80190be8,%eax
8010284e:	0f 82 a4 00 00 00    	jb     801028f8 <kfree+0xc8>
80102854:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010285a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102860:	0f 87 92 00 00 00    	ja     801028f8 <kfree+0xc8>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102866:	83 ec 04             	sub    $0x4,%esp
80102869:	68 00 10 00 00       	push   $0x1000
8010286e:	6a 01                	push   $0x1
80102870:	50                   	push   %eax
80102871:	e8 0a 27 00 00       	call   80104f80 <memset>

  if(kmem.use_lock) 
80102876:	8b 15 b4 56 11 80    	mov    0x801156b4,%edx
8010287c:	83 c4 10             	add    $0x10,%esp
8010287f:	85 d2                	test   %edx,%edx
80102881:	75 4d                	jne    801028d0 <kfree+0xa0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102883:	89 d8                	mov    %ebx,%eax
80102885:	c1 e8 0c             	shr    $0xc,%eax

  if(r->refcount != 1)
80102888:	83 3c c5 c0 56 11 80 	cmpl   $0x1,-0x7feea940(,%eax,8)
8010288f:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102890:	8d 50 06             	lea    0x6(%eax),%edx
80102893:	8d 0c c5 bc 56 11 80 	lea    -0x7feea944(,%eax,8),%ecx
  if(r->refcount != 1)
8010289a:	75 69                	jne    80102905 <kfree+0xd5>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
8010289c:	a1 b8 56 11 80       	mov    0x801156b8,%eax
  r->refcount = 0;
801028a1:	c7 04 d5 90 56 11 80 	movl   $0x0,-0x7feea970(,%edx,8)
801028a8:	00 00 00 00 
  kmem.freelist = r;
801028ac:	89 0d b8 56 11 80    	mov    %ecx,0x801156b8
  r->next = kmem.freelist;
801028b2:	89 04 d5 8c 56 11 80 	mov    %eax,-0x7feea974(,%edx,8)
  if(kmem.use_lock)
801028b9:	a1 b4 56 11 80       	mov    0x801156b4,%eax
801028be:	85 c0                	test   %eax,%eax
801028c0:	75 26                	jne    801028e8 <kfree+0xb8>
    release(&kmem.lock);
}
801028c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c5:	c9                   	leave  
801028c6:	c3                   	ret    
801028c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ce:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 80 56 11 80       	push   $0x80115680
801028d8:	e8 93 25 00 00       	call   80104e70 <acquire>
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb a1                	jmp    80102883 <kfree+0x53>
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028e8:	c7 45 08 80 56 11 80 	movl   $0x80115680,0x8(%ebp)
}
801028ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028f2:	c9                   	leave  
    release(&kmem.lock);
801028f3:	e9 38 26 00 00       	jmp    80104f30 <release>
    panic("kfree");
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	68 aa 85 10 80       	push   $0x801085aa
80102900:	e8 8b da ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102905:	83 ec 0c             	sub    $0xc,%esp
80102908:	68 b0 85 10 80       	push   $0x801085b0
8010290d:	e8 7e da ff ff       	call   80100390 <panic>
80102912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	53                   	push   %ebx
80102928:	83 ec 04             	sub    $0x4,%esp
8010292b:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010292e:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102933:	0f 85 c1 00 00 00    	jne    801029fa <kfree_nocheck+0xda>
80102939:	3d e8 0b 19 80       	cmp    $0x80190be8,%eax
8010293e:	0f 82 b6 00 00 00    	jb     801029fa <kfree_nocheck+0xda>
80102944:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010294a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102950:	0f 87 a4 00 00 00    	ja     801029fa <kfree_nocheck+0xda>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102956:	83 ec 04             	sub    $0x4,%esp
80102959:	68 00 10 00 00       	push   $0x1000
8010295e:	6a 01                	push   $0x1
80102960:	50                   	push   %eax
80102961:	e8 1a 26 00 00       	call   80104f80 <memset>

  if(kmem.use_lock) 
80102966:	8b 15 b4 56 11 80    	mov    0x801156b4,%edx
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 d2                	test   %edx,%edx
80102971:	75 35                	jne    801029a8 <kfree_nocheck+0x88>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102973:	a1 b8 56 11 80       	mov    0x801156b8,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102978:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
8010297b:	83 c3 06             	add    $0x6,%ebx
8010297e:	89 04 dd 8c 56 11 80 	mov    %eax,-0x7feea974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102985:	8d 04 dd 8c 56 11 80 	lea    -0x7feea974(,%ebx,8),%eax
  r->refcount = 0;
8010298c:	c7 04 dd 90 56 11 80 	movl   $0x0,-0x7feea970(,%ebx,8)
80102993:	00 00 00 00 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102997:	a3 b8 56 11 80       	mov    %eax,0x801156b8
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
8010299c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299f:	c9                   	leave  
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801029a8:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
801029ab:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
801029ae:	68 80 56 11 80       	push   $0x80115680
  r->next = kmem.freelist;
801029b3:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
801029b6:	e8 b5 24 00 00       	call   80104e70 <acquire>
  r->next = kmem.freelist;
801029bb:	a1 b8 56 11 80       	mov    0x801156b8,%eax
  if(kmem.use_lock)
801029c0:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
801029c3:	c7 04 dd 90 56 11 80 	movl   $0x0,-0x7feea970(,%ebx,8)
801029ca:	00 00 00 00 
  r->next = kmem.freelist;
801029ce:	89 04 dd 8c 56 11 80 	mov    %eax,-0x7feea974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
801029d5:	8d 04 dd 8c 56 11 80 	lea    -0x7feea974(,%ebx,8),%eax
801029dc:	a3 b8 56 11 80       	mov    %eax,0x801156b8
  if(kmem.use_lock)
801029e1:	a1 b4 56 11 80       	mov    0x801156b4,%eax
801029e6:	85 c0                	test   %eax,%eax
801029e8:	74 b2                	je     8010299c <kfree_nocheck+0x7c>
    release(&kmem.lock);
801029ea:	c7 45 08 80 56 11 80 	movl   $0x80115680,0x8(%ebp)
}
801029f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029f4:	c9                   	leave  
    release(&kmem.lock);
801029f5:	e9 36 25 00 00       	jmp    80104f30 <release>
    panic("kfree_nocheck");
801029fa:	83 ec 0c             	sub    $0xc,%esp
801029fd:	68 cd 85 10 80       	push   $0x801085cd
80102a02:	e8 89 d9 ff ff       	call   80100390 <panic>
80102a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <freerange>:
{
80102a10:	f3 0f 1e fb          	endbr32 
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a18:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a1b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a1e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a1f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a25:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a31:	39 de                	cmp    %ebx,%esi
80102a33:	72 1f                	jb     80102a54 <freerange+0x44>
80102a35:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102a38:	83 ec 0c             	sub    $0xc,%esp
80102a3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102a47:	50                   	push   %eax
80102a48:	e8 d3 fe ff ff       	call   80102920 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a4d:	83 c4 10             	add    $0x10,%esp
80102a50:	39 f3                	cmp    %esi,%ebx
80102a52:	76 e4                	jbe    80102a38 <freerange+0x28>
}
80102a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a57:	5b                   	pop    %ebx
80102a58:	5e                   	pop    %esi
80102a59:	5d                   	pop    %ebp
80102a5a:	c3                   	ret    
80102a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop

80102a60 <kinit1>:
{
80102a60:	f3 0f 1e fb          	endbr32 
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	56                   	push   %esi
80102a68:	53                   	push   %ebx
80102a69:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a6c:	83 ec 08             	sub    $0x8,%esp
80102a6f:	68 db 85 10 80       	push   $0x801085db
80102a74:	68 80 56 11 80       	push   $0x80115680
80102a79:	e8 72 22 00 00       	call   80104cf0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a81:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a84:	c7 05 b4 56 11 80 00 	movl   $0x0,0x801156b4
80102a8b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a8e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a94:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aa0:	39 de                	cmp    %ebx,%esi
80102aa2:	72 20                	jb     80102ac4 <kinit1+0x64>
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102ab7:	50                   	push   %eax
80102ab8:	e8 63 fe ff ff       	call   80102920 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	39 de                	cmp    %ebx,%esi
80102ac2:	73 e4                	jae    80102aa8 <kinit1+0x48>
}
80102ac4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac7:	5b                   	pop    %ebx
80102ac8:	5e                   	pop    %esi
80102ac9:	5d                   	pop    %ebp
80102aca:	c3                   	ret    
80102acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop

80102ad0 <kinit2>:
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
80102ad5:	89 e5                	mov    %esp,%ebp
80102ad7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ad8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102adb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102ade:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102adf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ae5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aeb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102af1:	39 de                	cmp    %ebx,%esi
80102af3:	72 1f                	jb     80102b14 <kinit2+0x44>
80102af5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102af8:	83 ec 0c             	sub    $0xc,%esp
80102afb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102b07:	50                   	push   %eax
80102b08:	e8 13 fe ff ff       	call   80102920 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	39 de                	cmp    %ebx,%esi
80102b12:	73 e4                	jae    80102af8 <kinit2+0x28>
  kmem.use_lock = 1;
80102b14:	c7 05 b4 56 11 80 01 	movl   $0x1,0x801156b4
80102b1b:	00 00 00 
}
80102b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b21:	5b                   	pop    %ebx
80102b22:	5e                   	pop    %esi
80102b23:	5d                   	pop    %ebp
80102b24:	c3                   	ret    
80102b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b30:	f3 0f 1e fb          	endbr32 
80102b34:	55                   	push   %ebp
80102b35:	89 e5                	mov    %esp,%ebp
80102b37:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102b3a:	a1 b4 56 11 80       	mov    0x801156b4,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	75 65                	jne    80102ba8 <kalloc+0x78>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b43:	a1 b8 56 11 80       	mov    0x801156b8,%eax
  if(r)
80102b48:	85 c0                	test   %eax,%eax
80102b4a:	74 54                	je     80102ba0 <kalloc+0x70>
  {
    kmem.freelist = r->next;
80102b4c:	8b 10                	mov    (%eax),%edx
80102b4e:	89 15 b8 56 11 80    	mov    %edx,0x801156b8
    r->refcount = 1;
80102b54:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102b5b:	8b 0d b4 56 11 80    	mov    0x801156b4,%ecx
80102b61:	85 c9                	test   %ecx,%ecx
80102b63:	75 13                	jne    80102b78 <kalloc+0x48>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b65:	2d bc 56 11 80       	sub    $0x801156bc,%eax
80102b6a:	c1 e0 09             	shl    $0x9,%eax
80102b6d:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102b72:	c9                   	leave  
80102b73:	c3                   	ret    
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102b78:	83 ec 0c             	sub    $0xc,%esp
80102b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b7e:	68 80 56 11 80       	push   $0x80115680
80102b83:	e8 a8 23 00 00       	call   80104f30 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b8b:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b8e:	2d bc 56 11 80       	sub    $0x801156bc,%eax
80102b93:	c1 e0 09             	shl    $0x9,%eax
80102b96:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
80102b9b:	eb d5                	jmp    80102b72 <kalloc+0x42>
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi
}
80102ba0:	c9                   	leave  
{
80102ba1:	31 c0                	xor    %eax,%eax
}
80102ba3:	c3                   	ret    
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102ba8:	83 ec 0c             	sub    $0xc,%esp
80102bab:	68 80 56 11 80       	push   $0x80115680
80102bb0:	e8 bb 22 00 00       	call   80104e70 <acquire>
  r = kmem.freelist;
80102bb5:	a1 b8 56 11 80       	mov    0x801156b8,%eax
  if(r)
80102bba:	83 c4 10             	add    $0x10,%esp
80102bbd:	85 c0                	test   %eax,%eax
80102bbf:	75 8b                	jne    80102b4c <kalloc+0x1c>
  if(kmem.use_lock)
80102bc1:	8b 15 b4 56 11 80    	mov    0x801156b4,%edx
80102bc7:	85 d2                	test   %edx,%edx
80102bc9:	74 d5                	je     80102ba0 <kalloc+0x70>
    release(&kmem.lock);
80102bcb:	83 ec 0c             	sub    $0xc,%esp
80102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bd1:	68 80 56 11 80       	push   $0x80115680
80102bd6:	e8 55 23 00 00       	call   80104f30 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102bde:	83 c4 10             	add    $0x10,%esp
}
80102be1:	c9                   	leave  
80102be2:	c3                   	ret    
80102be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bf0 <refDec>:

void
refDec(char *v)
{
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	53                   	push   %ebx
80102bf8:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102bfb:	8b 15 b4 56 11 80    	mov    0x801156b4,%edx
{
80102c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102c04:	85 d2                	test   %edx,%edx
80102c06:	75 18                	jne    80102c20 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c08:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c0e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102c11:	83 2c c5 c0 56 11 80 	subl   $0x1,-0x7feea940(,%eax,8)
80102c18:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c1c:	c9                   	leave  
80102c1d:	c3                   	ret    
80102c1e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102c20:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c23:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102c29:	68 80 56 11 80       	push   $0x80115680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c2e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c31:	e8 3a 22 00 00       	call   80104e70 <acquire>
  if(kmem.use_lock)
80102c36:	a1 b4 56 11 80       	mov    0x801156b4,%eax
  r->refcount -= 1;
80102c3b:	83 2c dd c0 56 11 80 	subl   $0x1,-0x7feea940(,%ebx,8)
80102c42:	01 
  if(kmem.use_lock)
80102c43:	83 c4 10             	add    $0x10,%esp
80102c46:	85 c0                	test   %eax,%eax
80102c48:	74 cf                	je     80102c19 <refDec+0x29>
    release(&kmem.lock);
80102c4a:	c7 45 08 80 56 11 80 	movl   $0x80115680,0x8(%ebp)
}
80102c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c54:	c9                   	leave  
    release(&kmem.lock);
80102c55:	e9 d6 22 00 00       	jmp    80104f30 <release>
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c60 <refInc>:

void
refInc(char *v)
{
80102c60:	f3 0f 1e fb          	endbr32 
80102c64:	55                   	push   %ebp
80102c65:	89 e5                	mov    %esp,%ebp
80102c67:	53                   	push   %ebx
80102c68:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102c6b:	8b 15 b4 56 11 80    	mov    0x801156b4,%edx
{
80102c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102c74:	85 d2                	test   %edx,%edx
80102c76:	75 18                	jne    80102c90 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c78:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c7e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102c81:	83 04 c5 c0 56 11 80 	addl   $0x1,-0x7feea940(,%eax,8)
80102c88:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102c89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c8c:	c9                   	leave  
80102c8d:	c3                   	ret    
80102c8e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102c90:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c93:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102c99:	68 80 56 11 80       	push   $0x80115680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c9e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ca1:	e8 ca 21 00 00       	call   80104e70 <acquire>
  if(kmem.use_lock)
80102ca6:	a1 b4 56 11 80       	mov    0x801156b4,%eax
  r->refcount += 1;
80102cab:	83 04 dd c0 56 11 80 	addl   $0x1,-0x7feea940(,%ebx,8)
80102cb2:	01 
  if(kmem.use_lock)
80102cb3:	83 c4 10             	add    $0x10,%esp
80102cb6:	85 c0                	test   %eax,%eax
80102cb8:	74 cf                	je     80102c89 <refInc+0x29>
    release(&kmem.lock);
80102cba:	c7 45 08 80 56 11 80 	movl   $0x80115680,0x8(%ebp)
}
80102cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc4:	c9                   	leave  
    release(&kmem.lock);
80102cc5:	e9 66 22 00 00       	jmp    80104f30 <release>
80102cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102cd0 <getRefs>:

int
getRefs(char *v)
{
80102cd0:	f3 0f 1e fb          	endbr32 
80102cd4:	55                   	push   %ebp
80102cd5:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102cda:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102cdb:	05 00 00 00 80       	add    $0x80000000,%eax
80102ce0:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102ce3:	8b 04 c5 c0 56 11 80 	mov    -0x7feea940(,%eax,8),%eax
80102cea:	c3                   	ret    
80102ceb:	66 90                	xchg   %ax,%ax
80102ced:	66 90                	xchg   %ax,%ax
80102cef:	90                   	nop

80102cf0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cf0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf4:	ba 64 00 00 00       	mov    $0x64,%edx
80102cf9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102cfa:	a8 01                	test   $0x1,%al
80102cfc:	0f 84 be 00 00 00    	je     80102dc0 <kbdgetc+0xd0>
{
80102d02:	55                   	push   %ebp
80102d03:	ba 60 00 00 00       	mov    $0x60,%edx
80102d08:	89 e5                	mov    %esp,%ebp
80102d0a:	53                   	push   %ebx
80102d0b:	ec                   	in     (%dx),%al
  return data;
80102d0c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102d12:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102d15:	3c e0                	cmp    $0xe0,%al
80102d17:	74 57                	je     80102d70 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d19:	89 d9                	mov    %ebx,%ecx
80102d1b:	83 e1 40             	and    $0x40,%ecx
80102d1e:	84 c0                	test   %al,%al
80102d20:	78 5e                	js     80102d80 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d22:	85 c9                	test   %ecx,%ecx
80102d24:	74 09                	je     80102d2f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d26:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d29:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102d2c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d2f:	0f b6 8a 00 87 10 80 	movzbl -0x7fef7900(%edx),%ecx
  shift ^= togglecode[data];
80102d36:	0f b6 82 00 86 10 80 	movzbl -0x7fef7a00(%edx),%eax
  shift |= shiftcode[data];
80102d3d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d3f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d41:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d43:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d49:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d4c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d4f:	8b 04 85 e0 85 10 80 	mov    -0x7fef7a20(,%eax,4),%eax
80102d56:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d5a:	74 0b                	je     80102d67 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102d5c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d5f:	83 fa 19             	cmp    $0x19,%edx
80102d62:	77 44                	ja     80102da8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d64:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d67:	5b                   	pop    %ebx
80102d68:	5d                   	pop    %ebp
80102d69:	c3                   	ret    
80102d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102d70:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102d73:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102d75:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102d7b:	5b                   	pop    %ebx
80102d7c:	5d                   	pop    %ebp
80102d7d:	c3                   	ret    
80102d7e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102d80:	83 e0 7f             	and    $0x7f,%eax
80102d83:	85 c9                	test   %ecx,%ecx
80102d85:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102d88:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102d8a:	0f b6 8a 00 87 10 80 	movzbl -0x7fef7900(%edx),%ecx
80102d91:	83 c9 40             	or     $0x40,%ecx
80102d94:	0f b6 c9             	movzbl %cl,%ecx
80102d97:	f7 d1                	not    %ecx
80102d99:	21 d9                	and    %ebx,%ecx
}
80102d9b:	5b                   	pop    %ebx
80102d9c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102d9d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102da3:	c3                   	ret    
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102da8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102dab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102dae:	5b                   	pop    %ebx
80102daf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102db0:	83 f9 1a             	cmp    $0x1a,%ecx
80102db3:	0f 42 c2             	cmovb  %edx,%eax
}
80102db6:	c3                   	ret    
80102db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbe:	66 90                	xchg   %ax,%ax
    return -1;
80102dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <kbdintr>:

void
kbdintr(void)
{
80102dd0:	f3 0f 1e fb          	endbr32 
80102dd4:	55                   	push   %ebp
80102dd5:	89 e5                	mov    %esp,%ebp
80102dd7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102dda:	68 f0 2c 10 80       	push   $0x80102cf0
80102ddf:	e8 7c da ff ff       	call   80100860 <consoleintr>
}
80102de4:	83 c4 10             	add    $0x10,%esp
80102de7:	c9                   	leave  
80102de8:	c3                   	ret    
80102de9:	66 90                	xchg   %ax,%ax
80102deb:	66 90                	xchg   %ax,%ax
80102ded:	66 90                	xchg   %ax,%ax
80102def:	90                   	nop

80102df0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102df0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102df4:	a1 bc 56 18 80       	mov    0x801856bc,%eax
80102df9:	85 c0                	test   %eax,%eax
80102dfb:	0f 84 c7 00 00 00    	je     80102ec8 <lapicinit+0xd8>
  lapic[index] = value;
80102e01:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e08:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e0e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e15:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e18:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e1b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e22:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e25:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e28:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e2f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e32:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e35:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e3c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e3f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e42:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e49:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e4c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e4f:	8b 50 30             	mov    0x30(%eax),%edx
80102e52:	c1 ea 10             	shr    $0x10,%edx
80102e55:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102e5b:	75 73                	jne    80102ed0 <lapicinit+0xe0>
  lapic[index] = value;
80102e5d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e6a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e77:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e7e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e81:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e84:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e8b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e91:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102e98:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e9e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ea5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea8:	8b 50 20             	mov    0x20(%eax),%edx
80102eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102eb0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102eb6:	80 e6 10             	and    $0x10,%dh
80102eb9:	75 f5                	jne    80102eb0 <lapicinit+0xc0>
  lapic[index] = value;
80102ebb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ec2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ec8:	c3                   	ret    
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ed0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ed7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eda:	8b 50 20             	mov    0x20(%eax),%edx
}
80102edd:	e9 7b ff ff ff       	jmp    80102e5d <lapicinit+0x6d>
80102ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ef0 <lapicid>:

int
lapicid(void)
{
80102ef0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102ef4:	a1 bc 56 18 80       	mov    0x801856bc,%eax
80102ef9:	85 c0                	test   %eax,%eax
80102efb:	74 0b                	je     80102f08 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102efd:	8b 40 20             	mov    0x20(%eax),%eax
80102f00:	c1 e8 18             	shr    $0x18,%eax
80102f03:	c3                   	ret    
80102f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102f08:	31 c0                	xor    %eax,%eax
}
80102f0a:	c3                   	ret    
80102f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f10:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102f14:	a1 bc 56 18 80       	mov    0x801856bc,%eax
80102f19:	85 c0                	test   %eax,%eax
80102f1b:	74 0d                	je     80102f2a <lapiceoi+0x1a>
  lapic[index] = value;
80102f1d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f27:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f2a:	c3                   	ret    
80102f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f2f:	90                   	nop

80102f30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f30:	f3 0f 1e fb          	endbr32 
}
80102f34:	c3                   	ret    
80102f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f40:	f3 0f 1e fb          	endbr32 
80102f44:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f45:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f4a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f4f:	89 e5                	mov    %esp,%ebp
80102f51:	53                   	push   %ebx
80102f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f55:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f58:	ee                   	out    %al,(%dx)
80102f59:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f5e:	ba 71 00 00 00       	mov    $0x71,%edx
80102f63:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f64:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f66:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f69:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f6f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f71:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102f74:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102f76:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f79:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102f7c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102f82:	a1 bc 56 18 80       	mov    0x801856bc,%eax
80102f87:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f8d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f90:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102f97:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f9a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f9d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102fa4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fa7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102faa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fb0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fb3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fbc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fc2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fc5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102fcb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102fcc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102fcf:	5d                   	pop    %ebp
80102fd0:	c3                   	ret    
80102fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fdf:	90                   	nop

80102fe0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102fe0:	f3 0f 1e fb          	endbr32 
80102fe4:	55                   	push   %ebp
80102fe5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102fea:	ba 70 00 00 00       	mov    $0x70,%edx
80102fef:	89 e5                	mov    %esp,%ebp
80102ff1:	57                   	push   %edi
80102ff2:	56                   	push   %esi
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 4c             	sub    $0x4c,%esp
80102ff7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff8:	ba 71 00 00 00       	mov    $0x71,%edx
80102ffd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102ffe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103001:	bb 70 00 00 00       	mov    $0x70,%ebx
80103006:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103010:	31 c0                	xor    %eax,%eax
80103012:	89 da                	mov    %ebx,%edx
80103014:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103015:	b9 71 00 00 00       	mov    $0x71,%ecx
8010301a:	89 ca                	mov    %ecx,%edx
8010301c:	ec                   	in     (%dx),%al
8010301d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103020:	89 da                	mov    %ebx,%edx
80103022:	b8 02 00 00 00       	mov    $0x2,%eax
80103027:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103028:	89 ca                	mov    %ecx,%edx
8010302a:	ec                   	in     (%dx),%al
8010302b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010302e:	89 da                	mov    %ebx,%edx
80103030:	b8 04 00 00 00       	mov    $0x4,%eax
80103035:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103036:	89 ca                	mov    %ecx,%edx
80103038:	ec                   	in     (%dx),%al
80103039:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303c:	89 da                	mov    %ebx,%edx
8010303e:	b8 07 00 00 00       	mov    $0x7,%eax
80103043:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103044:	89 ca                	mov    %ecx,%edx
80103046:	ec                   	in     (%dx),%al
80103047:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010304a:	89 da                	mov    %ebx,%edx
8010304c:	b8 08 00 00 00       	mov    $0x8,%eax
80103051:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103052:	89 ca                	mov    %ecx,%edx
80103054:	ec                   	in     (%dx),%al
80103055:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103057:	89 da                	mov    %ebx,%edx
80103059:	b8 09 00 00 00       	mov    $0x9,%eax
8010305e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010305f:	89 ca                	mov    %ecx,%edx
80103061:	ec                   	in     (%dx),%al
80103062:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103064:	89 da                	mov    %ebx,%edx
80103066:	b8 0a 00 00 00       	mov    $0xa,%eax
8010306b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010306c:	89 ca                	mov    %ecx,%edx
8010306e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010306f:	84 c0                	test   %al,%al
80103071:	78 9d                	js     80103010 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103073:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103077:	89 fa                	mov    %edi,%edx
80103079:	0f b6 fa             	movzbl %dl,%edi
8010307c:	89 f2                	mov    %esi,%edx
8010307e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103081:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103085:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103088:	89 da                	mov    %ebx,%edx
8010308a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010308d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103090:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103094:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103097:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010309a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010309e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030a1:	31 c0                	xor    %eax,%eax
801030a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a4:	89 ca                	mov    %ecx,%edx
801030a6:	ec                   	in     (%dx),%al
801030a7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030aa:	89 da                	mov    %ebx,%edx
801030ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030af:	b8 02 00 00 00       	mov    $0x2,%eax
801030b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b5:	89 ca                	mov    %ecx,%edx
801030b7:	ec                   	in     (%dx),%al
801030b8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bb:	89 da                	mov    %ebx,%edx
801030bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801030c0:	b8 04 00 00 00       	mov    $0x4,%eax
801030c5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c6:	89 ca                	mov    %ecx,%edx
801030c8:	ec                   	in     (%dx),%al
801030c9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cc:	89 da                	mov    %ebx,%edx
801030ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
801030d1:	b8 07 00 00 00       	mov    $0x7,%eax
801030d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d7:	89 ca                	mov    %ecx,%edx
801030d9:	ec                   	in     (%dx),%al
801030da:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dd:	89 da                	mov    %ebx,%edx
801030df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030e2:	b8 08 00 00 00       	mov    $0x8,%eax
801030e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e8:	89 ca                	mov    %ecx,%edx
801030ea:	ec                   	in     (%dx),%al
801030eb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ee:	89 da                	mov    %ebx,%edx
801030f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801030f3:	b8 09 00 00 00       	mov    $0x9,%eax
801030f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f9:	89 ca                	mov    %ecx,%edx
801030fb:	ec                   	in     (%dx),%al
801030fc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801030ff:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103105:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103108:	6a 18                	push   $0x18
8010310a:	50                   	push   %eax
8010310b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010310e:	50                   	push   %eax
8010310f:	e8 bc 1e 00 00       	call   80104fd0 <memcmp>
80103114:	83 c4 10             	add    $0x10,%esp
80103117:	85 c0                	test   %eax,%eax
80103119:	0f 85 f1 fe ff ff    	jne    80103010 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010311f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103123:	75 78                	jne    8010319d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103125:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103128:	89 c2                	mov    %eax,%edx
8010312a:	83 e0 0f             	and    $0xf,%eax
8010312d:	c1 ea 04             	shr    $0x4,%edx
80103130:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103133:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103136:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103139:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010313c:	89 c2                	mov    %eax,%edx
8010313e:	83 e0 0f             	and    $0xf,%eax
80103141:	c1 ea 04             	shr    $0x4,%edx
80103144:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103147:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010314a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010314d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103150:	89 c2                	mov    %eax,%edx
80103152:	83 e0 0f             	and    $0xf,%eax
80103155:	c1 ea 04             	shr    $0x4,%edx
80103158:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010315b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010315e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103161:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103164:	89 c2                	mov    %eax,%edx
80103166:	83 e0 0f             	and    $0xf,%eax
80103169:	c1 ea 04             	shr    $0x4,%edx
8010316c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010316f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103172:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103175:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103178:	89 c2                	mov    %eax,%edx
8010317a:	83 e0 0f             	and    $0xf,%eax
8010317d:	c1 ea 04             	shr    $0x4,%edx
80103180:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103183:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103186:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103189:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	83 e0 0f             	and    $0xf,%eax
80103191:	c1 ea 04             	shr    $0x4,%edx
80103194:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103197:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010319a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010319d:	8b 75 08             	mov    0x8(%ebp),%esi
801031a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031a3:	89 06                	mov    %eax,(%esi)
801031a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031a8:	89 46 04             	mov    %eax,0x4(%esi)
801031ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031ae:	89 46 08             	mov    %eax,0x8(%esi)
801031b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031b4:	89 46 0c             	mov    %eax,0xc(%esi)
801031b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031ba:	89 46 10             	mov    %eax,0x10(%esi)
801031bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031c0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801031c3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801031ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	66 90                	xchg   %ax,%ax
801031d4:	66 90                	xchg   %ax,%ax
801031d6:	66 90                	xchg   %ax,%ax
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031e0:	8b 0d 08 57 18 80    	mov    0x80185708,%ecx
801031e6:	85 c9                	test   %ecx,%ecx
801031e8:	0f 8e 8a 00 00 00    	jle    80103278 <install_trans+0x98>
{
801031ee:	55                   	push   %ebp
801031ef:	89 e5                	mov    %esp,%ebp
801031f1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801031f2:	31 ff                	xor    %edi,%edi
{
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103200:	a1 f4 56 18 80       	mov    0x801856f4,%eax
80103205:	83 ec 08             	sub    $0x8,%esp
80103208:	01 f8                	add    %edi,%eax
8010320a:	83 c0 01             	add    $0x1,%eax
8010320d:	50                   	push   %eax
8010320e:	ff 35 04 57 18 80    	pushl  0x80185704
80103214:	e8 b7 ce ff ff       	call   801000d0 <bread>
80103219:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010321b:	58                   	pop    %eax
8010321c:	5a                   	pop    %edx
8010321d:	ff 34 bd 0c 57 18 80 	pushl  -0x7fe7a8f4(,%edi,4)
80103224:	ff 35 04 57 18 80    	pushl  0x80185704
  for (tail = 0; tail < log.lh.n; tail++) {
8010322a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010322d:	e8 9e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103232:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103235:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103237:	8d 46 5c             	lea    0x5c(%esi),%eax
8010323a:	68 00 02 00 00       	push   $0x200
8010323f:	50                   	push   %eax
80103240:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103243:	50                   	push   %eax
80103244:	e8 d7 1d 00 00       	call   80105020 <memmove>
    bwrite(dbuf);  // write dst to disk
80103249:	89 1c 24             	mov    %ebx,(%esp)
8010324c:	e8 5f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103251:	89 34 24             	mov    %esi,(%esp)
80103254:	e8 97 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103259:	89 1c 24             	mov    %ebx,(%esp)
8010325c:	e8 8f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103261:	83 c4 10             	add    $0x10,%esp
80103264:	39 3d 08 57 18 80    	cmp    %edi,0x80185708
8010326a:	7f 94                	jg     80103200 <install_trans+0x20>
  }
}
8010326c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326f:	5b                   	pop    %ebx
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
80103274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103278:	c3                   	ret    
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103280 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	53                   	push   %ebx
80103284:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103287:	ff 35 f4 56 18 80    	pushl  0x801856f4
8010328d:	ff 35 04 57 18 80    	pushl  0x80185704
80103293:	e8 38 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103298:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010329b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010329d:	a1 08 57 18 80       	mov    0x80185708,%eax
801032a2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032a5:	85 c0                	test   %eax,%eax
801032a7:	7e 19                	jle    801032c2 <write_head+0x42>
801032a9:	31 d2                	xor    %edx,%edx
801032ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032af:	90                   	nop
    hb->block[i] = log.lh.block[i];
801032b0:	8b 0c 95 0c 57 18 80 	mov    -0x7fe7a8f4(,%edx,4),%ecx
801032b7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801032bb:	83 c2 01             	add    $0x1,%edx
801032be:	39 d0                	cmp    %edx,%eax
801032c0:	75 ee                	jne    801032b0 <write_head+0x30>
  }
  bwrite(buf);
801032c2:	83 ec 0c             	sub    $0xc,%esp
801032c5:	53                   	push   %ebx
801032c6:	e8 e5 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801032cb:	89 1c 24             	mov    %ebx,(%esp)
801032ce:	e8 1d cf ff ff       	call   801001f0 <brelse>
}
801032d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032d6:	83 c4 10             	add    $0x10,%esp
801032d9:	c9                   	leave  
801032da:	c3                   	ret    
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop

801032e0 <initlog>:
{
801032e0:	f3 0f 1e fb          	endbr32 
801032e4:	55                   	push   %ebp
801032e5:	89 e5                	mov    %esp,%ebp
801032e7:	53                   	push   %ebx
801032e8:	83 ec 2c             	sub    $0x2c,%esp
801032eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801032ee:	68 00 88 10 80       	push   $0x80108800
801032f3:	68 c0 56 18 80       	push   $0x801856c0
801032f8:	e8 f3 19 00 00       	call   80104cf0 <initlock>
  readsb(dev, &sb);
801032fd:	58                   	pop    %eax
801032fe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103301:	5a                   	pop    %edx
80103302:	50                   	push   %eax
80103303:	53                   	push   %ebx
80103304:	e8 37 e2 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80103309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010330c:	59                   	pop    %ecx
  log.dev = dev;
8010330d:	89 1d 04 57 18 80    	mov    %ebx,0x80185704
  log.size = sb.nlog;
80103313:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103316:	a3 f4 56 18 80       	mov    %eax,0x801856f4
  log.size = sb.nlog;
8010331b:	89 15 f8 56 18 80    	mov    %edx,0x801856f8
  struct buf *buf = bread(log.dev, log.start);
80103321:	5a                   	pop    %edx
80103322:	50                   	push   %eax
80103323:	53                   	push   %ebx
80103324:	e8 a7 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103329:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010332c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010332f:	89 0d 08 57 18 80    	mov    %ecx,0x80185708
  for (i = 0; i < log.lh.n; i++) {
80103335:	85 c9                	test   %ecx,%ecx
80103337:	7e 19                	jle    80103352 <initlog+0x72>
80103339:	31 d2                	xor    %edx,%edx
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103340:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103344:	89 1c 95 0c 57 18 80 	mov    %ebx,-0x7fe7a8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010334b:	83 c2 01             	add    $0x1,%edx
8010334e:	39 d1                	cmp    %edx,%ecx
80103350:	75 ee                	jne    80103340 <initlog+0x60>
  brelse(buf);
80103352:	83 ec 0c             	sub    $0xc,%esp
80103355:	50                   	push   %eax
80103356:	e8 95 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010335b:	e8 80 fe ff ff       	call   801031e0 <install_trans>
  log.lh.n = 0;
80103360:	c7 05 08 57 18 80 00 	movl   $0x0,0x80185708
80103367:	00 00 00 
  write_head(); // clear the log
8010336a:	e8 11 ff ff ff       	call   80103280 <write_head>
}
8010336f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103372:	83 c4 10             	add    $0x10,%esp
80103375:	c9                   	leave  
80103376:	c3                   	ret    
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax

80103380 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103380:	f3 0f 1e fb          	endbr32 
80103384:	55                   	push   %ebp
80103385:	89 e5                	mov    %esp,%ebp
80103387:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010338a:	68 c0 56 18 80       	push   $0x801856c0
8010338f:	e8 dc 1a 00 00       	call   80104e70 <acquire>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	eb 1c                	jmp    801033b5 <begin_op+0x35>
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033a0:	83 ec 08             	sub    $0x8,%esp
801033a3:	68 c0 56 18 80       	push   $0x801856c0
801033a8:	68 c0 56 18 80       	push   $0x801856c0
801033ad:	e8 ee 13 00 00       	call   801047a0 <sleep>
801033b2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801033b5:	a1 00 57 18 80       	mov    0x80185700,%eax
801033ba:	85 c0                	test   %eax,%eax
801033bc:	75 e2                	jne    801033a0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033be:	a1 fc 56 18 80       	mov    0x801856fc,%eax
801033c3:	8b 15 08 57 18 80    	mov    0x80185708,%edx
801033c9:	83 c0 01             	add    $0x1,%eax
801033cc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801033cf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801033d2:	83 fa 1e             	cmp    $0x1e,%edx
801033d5:	7f c9                	jg     801033a0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801033d7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801033da:	a3 fc 56 18 80       	mov    %eax,0x801856fc
      release(&log.lock);
801033df:	68 c0 56 18 80       	push   $0x801856c0
801033e4:	e8 47 1b 00 00       	call   80104f30 <release>
      break;
    }
  }
}
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	c9                   	leave  
801033ed:	c3                   	ret    
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801033fd:	68 c0 56 18 80       	push   $0x801856c0
80103402:	e8 69 1a 00 00       	call   80104e70 <acquire>
  log.outstanding -= 1;
80103407:	a1 fc 56 18 80       	mov    0x801856fc,%eax
  if(log.committing)
8010340c:	8b 35 00 57 18 80    	mov    0x80185700,%esi
80103412:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103415:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103418:	89 1d fc 56 18 80    	mov    %ebx,0x801856fc
  if(log.committing)
8010341e:	85 f6                	test   %esi,%esi
80103420:	0f 85 1e 01 00 00    	jne    80103544 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103426:	85 db                	test   %ebx,%ebx
80103428:	0f 85 f2 00 00 00    	jne    80103520 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010342e:	c7 05 00 57 18 80 01 	movl   $0x1,0x80185700
80103435:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	68 c0 56 18 80       	push   $0x801856c0
80103440:	e8 eb 1a 00 00       	call   80104f30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103445:	8b 0d 08 57 18 80    	mov    0x80185708,%ecx
8010344b:	83 c4 10             	add    $0x10,%esp
8010344e:	85 c9                	test   %ecx,%ecx
80103450:	7f 3e                	jg     80103490 <end_op+0xa0>
    acquire(&log.lock);
80103452:	83 ec 0c             	sub    $0xc,%esp
80103455:	68 c0 56 18 80       	push   $0x801856c0
8010345a:	e8 11 1a 00 00       	call   80104e70 <acquire>
    wakeup(&log);
8010345f:	c7 04 24 c0 56 18 80 	movl   $0x801856c0,(%esp)
    log.committing = 0;
80103466:	c7 05 00 57 18 80 00 	movl   $0x0,0x80185700
8010346d:	00 00 00 
    wakeup(&log);
80103470:	e8 2b 15 00 00       	call   801049a0 <wakeup>
    release(&log.lock);
80103475:	c7 04 24 c0 56 18 80 	movl   $0x801856c0,(%esp)
8010347c:	e8 af 1a 00 00       	call   80104f30 <release>
80103481:	83 c4 10             	add    $0x10,%esp
}
80103484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103487:	5b                   	pop    %ebx
80103488:	5e                   	pop    %esi
80103489:	5f                   	pop    %edi
8010348a:	5d                   	pop    %ebp
8010348b:	c3                   	ret    
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103490:	a1 f4 56 18 80       	mov    0x801856f4,%eax
80103495:	83 ec 08             	sub    $0x8,%esp
80103498:	01 d8                	add    %ebx,%eax
8010349a:	83 c0 01             	add    $0x1,%eax
8010349d:	50                   	push   %eax
8010349e:	ff 35 04 57 18 80    	pushl  0x80185704
801034a4:	e8 27 cc ff ff       	call   801000d0 <bread>
801034a9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034ab:	58                   	pop    %eax
801034ac:	5a                   	pop    %edx
801034ad:	ff 34 9d 0c 57 18 80 	pushl  -0x7fe7a8f4(,%ebx,4)
801034b4:	ff 35 04 57 18 80    	pushl  0x80185704
  for (tail = 0; tail < log.lh.n; tail++) {
801034ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034bd:	e8 0e cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801034c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034c5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801034c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801034ca:	68 00 02 00 00       	push   $0x200
801034cf:	50                   	push   %eax
801034d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801034d3:	50                   	push   %eax
801034d4:	e8 47 1b 00 00       	call   80105020 <memmove>
    bwrite(to);  // write the log
801034d9:	89 34 24             	mov    %esi,(%esp)
801034dc:	e8 cf cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
801034e1:	89 3c 24             	mov    %edi,(%esp)
801034e4:	e8 07 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
801034e9:	89 34 24             	mov    %esi,(%esp)
801034ec:	e8 ff cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034f1:	83 c4 10             	add    $0x10,%esp
801034f4:	3b 1d 08 57 18 80    	cmp    0x80185708,%ebx
801034fa:	7c 94                	jl     80103490 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801034fc:	e8 7f fd ff ff       	call   80103280 <write_head>
    install_trans(); // Now install writes to home locations
80103501:	e8 da fc ff ff       	call   801031e0 <install_trans>
    log.lh.n = 0;
80103506:	c7 05 08 57 18 80 00 	movl   $0x0,0x80185708
8010350d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103510:	e8 6b fd ff ff       	call   80103280 <write_head>
80103515:	e9 38 ff ff ff       	jmp    80103452 <end_op+0x62>
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	68 c0 56 18 80       	push   $0x801856c0
80103528:	e8 73 14 00 00       	call   801049a0 <wakeup>
  release(&log.lock);
8010352d:	c7 04 24 c0 56 18 80 	movl   $0x801856c0,(%esp)
80103534:	e8 f7 19 00 00       	call   80104f30 <release>
80103539:	83 c4 10             	add    $0x10,%esp
}
8010353c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010353f:	5b                   	pop    %ebx
80103540:	5e                   	pop    %esi
80103541:	5f                   	pop    %edi
80103542:	5d                   	pop    %ebp
80103543:	c3                   	ret    
    panic("log.committing");
80103544:	83 ec 0c             	sub    $0xc,%esp
80103547:	68 04 88 10 80       	push   $0x80108804
8010354c:	e8 3f ce ff ff       	call   80100390 <panic>
80103551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	53                   	push   %ebx
80103568:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010356b:	8b 15 08 57 18 80    	mov    0x80185708,%edx
{
80103571:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103574:	83 fa 1d             	cmp    $0x1d,%edx
80103577:	0f 8f 91 00 00 00    	jg     8010360e <log_write+0xae>
8010357d:	a1 f8 56 18 80       	mov    0x801856f8,%eax
80103582:	83 e8 01             	sub    $0x1,%eax
80103585:	39 c2                	cmp    %eax,%edx
80103587:	0f 8d 81 00 00 00    	jge    8010360e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010358d:	a1 fc 56 18 80       	mov    0x801856fc,%eax
80103592:	85 c0                	test   %eax,%eax
80103594:	0f 8e 81 00 00 00    	jle    8010361b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010359a:	83 ec 0c             	sub    $0xc,%esp
8010359d:	68 c0 56 18 80       	push   $0x801856c0
801035a2:	e8 c9 18 00 00       	call   80104e70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035a7:	8b 15 08 57 18 80    	mov    0x80185708,%edx
801035ad:	83 c4 10             	add    $0x10,%esp
801035b0:	85 d2                	test   %edx,%edx
801035b2:	7e 4e                	jle    80103602 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035b4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801035b7:	31 c0                	xor    %eax,%eax
801035b9:	eb 0c                	jmp    801035c7 <log_write+0x67>
801035bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035bf:	90                   	nop
801035c0:	83 c0 01             	add    $0x1,%eax
801035c3:	39 c2                	cmp    %eax,%edx
801035c5:	74 29                	je     801035f0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035c7:	39 0c 85 0c 57 18 80 	cmp    %ecx,-0x7fe7a8f4(,%eax,4)
801035ce:	75 f0                	jne    801035c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801035d0:	89 0c 85 0c 57 18 80 	mov    %ecx,-0x7fe7a8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801035d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801035da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801035dd:	c7 45 08 c0 56 18 80 	movl   $0x801856c0,0x8(%ebp)
}
801035e4:	c9                   	leave  
  release(&log.lock);
801035e5:	e9 46 19 00 00       	jmp    80104f30 <release>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801035f0:	89 0c 95 0c 57 18 80 	mov    %ecx,-0x7fe7a8f4(,%edx,4)
    log.lh.n++;
801035f7:	83 c2 01             	add    $0x1,%edx
801035fa:	89 15 08 57 18 80    	mov    %edx,0x80185708
80103600:	eb d5                	jmp    801035d7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103602:	8b 43 08             	mov    0x8(%ebx),%eax
80103605:	a3 0c 57 18 80       	mov    %eax,0x8018570c
  if (i == log.lh.n)
8010360a:	75 cb                	jne    801035d7 <log_write+0x77>
8010360c:	eb e9                	jmp    801035f7 <log_write+0x97>
    panic("too big a transaction");
8010360e:	83 ec 0c             	sub    $0xc,%esp
80103611:	68 13 88 10 80       	push   $0x80108813
80103616:	e8 75 cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010361b:	83 ec 0c             	sub    $0xc,%esp
8010361e:	68 29 88 10 80       	push   $0x80108829
80103623:	e8 68 cd ff ff       	call   80100390 <panic>
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
80103634:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103637:	e8 34 0a 00 00       	call   80104070 <cpuid>
8010363c:	89 c3                	mov    %eax,%ebx
8010363e:	e8 2d 0a 00 00       	call   80104070 <cpuid>
80103643:	83 ec 04             	sub    $0x4,%esp
80103646:	53                   	push   %ebx
80103647:	50                   	push   %eax
80103648:	68 44 88 10 80       	push   $0x80108844
8010364d:	e8 5e d0 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103652:	e8 19 2c 00 00       	call   80106270 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103657:	e8 a4 09 00 00       	call   80104000 <mycpu>
8010365c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010365e:	b8 01 00 00 00       	mov    $0x1,%eax
80103663:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010366a:	e8 11 0e 00 00       	call   80104480 <scheduler>
8010366f:	90                   	nop

80103670 <mpenter>:
{
80103670:	f3 0f 1e fb          	endbr32 
80103674:	55                   	push   %ebp
80103675:	89 e5                	mov    %esp,%ebp
80103677:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010367a:	e8 81 3c 00 00       	call   80107300 <switchkvm>
  seginit();
8010367f:	e8 ec 3b 00 00       	call   80107270 <seginit>
  lapicinit();
80103684:	e8 67 f7 ff ff       	call   80102df0 <lapicinit>
  mpmain();
80103689:	e8 a2 ff ff ff       	call   80103630 <mpmain>
8010368e:	66 90                	xchg   %ax,%ax

80103690 <main>:
{
80103690:	f3 0f 1e fb          	endbr32 
80103694:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103698:	83 e4 f0             	and    $0xfffffff0,%esp
8010369b:	ff 71 fc             	pushl  -0x4(%ecx)
8010369e:	55                   	push   %ebp
8010369f:	89 e5                	mov    %esp,%ebp
801036a1:	53                   	push   %ebx
801036a2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036a3:	83 ec 08             	sub    $0x8,%esp
801036a6:	68 00 00 40 80       	push   $0x80400000
801036ab:	68 e8 0b 19 80       	push   $0x80190be8
801036b0:	e8 ab f3 ff ff       	call   80102a60 <kinit1>
  kvmalloc();      // kernel page table
801036b5:	e8 96 44 00 00       	call   80107b50 <kvmalloc>
  mpinit();        // detect other processors
801036ba:	e8 81 01 00 00       	call   80103840 <mpinit>
  lapicinit();     // interrupt controller
801036bf:	e8 2c f7 ff ff       	call   80102df0 <lapicinit>
  seginit();       // segment descriptors
801036c4:	e8 a7 3b 00 00       	call   80107270 <seginit>
  picinit();       // disable pic
801036c9:	e8 52 03 00 00       	call   80103a20 <picinit>
  ioapicinit();    // another interrupt controller
801036ce:	e8 6d f0 ff ff       	call   80102740 <ioapicinit>
  consoleinit();   // console hardware
801036d3:	e8 58 d3 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801036d8:	e8 93 2e 00 00       	call   80106570 <uartinit>
  pinit();         // process table
801036dd:	e8 fe 08 00 00       	call   80103fe0 <pinit>
  tvinit();        // trap vectors
801036e2:	e8 09 2b 00 00       	call   801061f0 <tvinit>
  binit();         // buffer cache
801036e7:	e8 54 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801036ec:	e8 2f d7 ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
801036f1:	e8 1a ee ff ff       	call   80102510 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801036f6:	83 c4 0c             	add    $0xc,%esp
801036f9:	68 8a 00 00 00       	push   $0x8a
801036fe:	68 8c b4 10 80       	push   $0x8010b48c
80103703:	68 00 70 00 80       	push   $0x80007000
80103708:	e8 13 19 00 00       	call   80105020 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010370d:	83 c4 10             	add    $0x10,%esp
80103710:	69 05 40 5d 18 80 b0 	imul   $0xb0,0x80185d40,%eax
80103717:	00 00 00 
8010371a:	05 c0 57 18 80       	add    $0x801857c0,%eax
8010371f:	3d c0 57 18 80       	cmp    $0x801857c0,%eax
80103724:	76 7a                	jbe    801037a0 <main+0x110>
80103726:	bb c0 57 18 80       	mov    $0x801857c0,%ebx
8010372b:	eb 1c                	jmp    80103749 <main+0xb9>
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
80103730:	69 05 40 5d 18 80 b0 	imul   $0xb0,0x80185d40,%eax
80103737:	00 00 00 
8010373a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103740:	05 c0 57 18 80       	add    $0x801857c0,%eax
80103745:	39 c3                	cmp    %eax,%ebx
80103747:	73 57                	jae    801037a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103749:	e8 b2 08 00 00       	call   80104000 <mycpu>
8010374e:	39 c3                	cmp    %eax,%ebx
80103750:	74 de                	je     80103730 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103752:	e8 d9 f3 ff ff       	call   80102b30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103757:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010375a:	c7 05 f8 6f 00 80 70 	movl   $0x80103670,0x80006ff8
80103761:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103764:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010376b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010376e:	05 00 10 00 00       	add    $0x1000,%eax
80103773:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103778:	0f b6 03             	movzbl (%ebx),%eax
8010377b:	68 00 70 00 00       	push   $0x7000
80103780:	50                   	push   %eax
80103781:	e8 ba f7 ff ff       	call   80102f40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103786:	83 c4 10             	add    $0x10,%esp
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103790:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103796:	85 c0                	test   %eax,%eax
80103798:	74 f6                	je     80103790 <main+0x100>
8010379a:	eb 94                	jmp    80103730 <main+0xa0>
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037a0:	83 ec 08             	sub    $0x8,%esp
801037a3:	68 00 00 00 8e       	push   $0x8e000000
801037a8:	68 00 00 40 80       	push   $0x80400000
801037ad:	e8 1e f3 ff ff       	call   80102ad0 <kinit2>
  userinit();      // first user process
801037b2:	e8 09 09 00 00       	call   801040c0 <userinit>
  mpmain();        // finish this processor's setup
801037b7:	e8 74 fe ff ff       	call   80103630 <mpmain>
801037bc:	66 90                	xchg   %ax,%ax
801037be:	66 90                	xchg   %ax,%ax

801037c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801037c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801037cb:	53                   	push   %ebx
  e = addr+len;
801037cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801037cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801037d2:	39 de                	cmp    %ebx,%esi
801037d4:	72 10                	jb     801037e6 <mpsearch1+0x26>
801037d6:	eb 50                	jmp    80103828 <mpsearch1+0x68>
801037d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037df:	90                   	nop
801037e0:	89 fe                	mov    %edi,%esi
801037e2:	39 fb                	cmp    %edi,%ebx
801037e4:	76 42                	jbe    80103828 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037e6:	83 ec 04             	sub    $0x4,%esp
801037e9:	8d 7e 10             	lea    0x10(%esi),%edi
801037ec:	6a 04                	push   $0x4
801037ee:	68 58 88 10 80       	push   $0x80108858
801037f3:	56                   	push   %esi
801037f4:	e8 d7 17 00 00       	call   80104fd0 <memcmp>
801037f9:	83 c4 10             	add    $0x10,%esp
801037fc:	85 c0                	test   %eax,%eax
801037fe:	75 e0                	jne    801037e0 <mpsearch1+0x20>
80103800:	89 f2                	mov    %esi,%edx
80103802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103808:	0f b6 0a             	movzbl (%edx),%ecx
8010380b:	83 c2 01             	add    $0x1,%edx
8010380e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103810:	39 fa                	cmp    %edi,%edx
80103812:	75 f4                	jne    80103808 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103814:	84 c0                	test   %al,%al
80103816:	75 c8                	jne    801037e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103818:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010381b:	89 f0                	mov    %esi,%eax
8010381d:	5b                   	pop    %ebx
8010381e:	5e                   	pop    %esi
8010381f:	5f                   	pop    %edi
80103820:	5d                   	pop    %ebp
80103821:	c3                   	ret    
80103822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103828:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010382b:	31 f6                	xor    %esi,%esi
}
8010382d:	5b                   	pop    %ebx
8010382e:	89 f0                	mov    %esi,%eax
80103830:	5e                   	pop    %esi
80103831:	5f                   	pop    %edi
80103832:	5d                   	pop    %ebp
80103833:	c3                   	ret    
80103834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010383b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010383f:	90                   	nop

80103840 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103840:	f3 0f 1e fb          	endbr32 
80103844:	55                   	push   %ebp
80103845:	89 e5                	mov    %esp,%ebp
80103847:	57                   	push   %edi
80103848:	56                   	push   %esi
80103849:	53                   	push   %ebx
8010384a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010384d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103854:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010385b:	c1 e0 08             	shl    $0x8,%eax
8010385e:	09 d0                	or     %edx,%eax
80103860:	c1 e0 04             	shl    $0x4,%eax
80103863:	75 1b                	jne    80103880 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103865:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010386c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103873:	c1 e0 08             	shl    $0x8,%eax
80103876:	09 d0                	or     %edx,%eax
80103878:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010387b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103880:	ba 00 04 00 00       	mov    $0x400,%edx
80103885:	e8 36 ff ff ff       	call   801037c0 <mpsearch1>
8010388a:	89 c6                	mov    %eax,%esi
8010388c:	85 c0                	test   %eax,%eax
8010388e:	0f 84 4c 01 00 00    	je     801039e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103894:	8b 5e 04             	mov    0x4(%esi),%ebx
80103897:	85 db                	test   %ebx,%ebx
80103899:	0f 84 61 01 00 00    	je     80103a00 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010389f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038a8:	6a 04                	push   $0x4
801038aa:	68 5d 88 10 80       	push   $0x8010885d
801038af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038b3:	e8 18 17 00 00       	call   80104fd0 <memcmp>
801038b8:	83 c4 10             	add    $0x10,%esp
801038bb:	85 c0                	test   %eax,%eax
801038bd:	0f 85 3d 01 00 00    	jne    80103a00 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801038c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801038ca:	3c 01                	cmp    $0x1,%al
801038cc:	74 08                	je     801038d6 <mpinit+0x96>
801038ce:	3c 04                	cmp    $0x4,%al
801038d0:	0f 85 2a 01 00 00    	jne    80103a00 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801038d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801038dd:	66 85 d2             	test   %dx,%dx
801038e0:	74 26                	je     80103908 <mpinit+0xc8>
801038e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801038e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801038e7:	31 d2                	xor    %edx,%edx
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801038f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801038f7:	83 c0 01             	add    $0x1,%eax
801038fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801038fc:	39 f8                	cmp    %edi,%eax
801038fe:	75 f0                	jne    801038f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103900:	84 d2                	test   %dl,%dl
80103902:	0f 85 f8 00 00 00    	jne    80103a00 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103908:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010390e:	a3 bc 56 18 80       	mov    %eax,0x801856bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103913:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103919:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103920:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103925:	03 55 e4             	add    -0x1c(%ebp),%edx
80103928:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop
80103930:	39 c2                	cmp    %eax,%edx
80103932:	76 15                	jbe    80103949 <mpinit+0x109>
    switch(*p){
80103934:	0f b6 08             	movzbl (%eax),%ecx
80103937:	80 f9 02             	cmp    $0x2,%cl
8010393a:	74 5c                	je     80103998 <mpinit+0x158>
8010393c:	77 42                	ja     80103980 <mpinit+0x140>
8010393e:	84 c9                	test   %cl,%cl
80103940:	74 6e                	je     801039b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103942:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103945:	39 c2                	cmp    %eax,%edx
80103947:	77 eb                	ja     80103934 <mpinit+0xf4>
80103949:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010394c:	85 db                	test   %ebx,%ebx
8010394e:	0f 84 b9 00 00 00    	je     80103a0d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103954:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103958:	74 15                	je     8010396f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010395a:	b8 70 00 00 00       	mov    $0x70,%eax
8010395f:	ba 22 00 00 00       	mov    $0x22,%edx
80103964:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103965:	ba 23 00 00 00       	mov    $0x23,%edx
8010396a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010396b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010396e:	ee                   	out    %al,(%dx)
  }
}
8010396f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103972:	5b                   	pop    %ebx
80103973:	5e                   	pop    %esi
80103974:	5f                   	pop    %edi
80103975:	5d                   	pop    %ebp
80103976:	c3                   	ret    
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103980:	83 e9 03             	sub    $0x3,%ecx
80103983:	80 f9 01             	cmp    $0x1,%cl
80103986:	76 ba                	jbe    80103942 <mpinit+0x102>
80103988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010398f:	eb 9f                	jmp    80103930 <mpinit+0xf0>
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103998:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010399c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010399f:	88 0d a0 57 18 80    	mov    %cl,0x801857a0
      continue;
801039a5:	eb 89                	jmp    80103930 <mpinit+0xf0>
801039a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801039b0:	8b 0d 40 5d 18 80    	mov    0x80185d40,%ecx
801039b6:	83 f9 07             	cmp    $0x7,%ecx
801039b9:	7f 19                	jg     801039d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801039c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801039c5:	83 c1 01             	add    $0x1,%ecx
801039c8:	89 0d 40 5d 18 80    	mov    %ecx,0x80185d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039ce:	88 9f c0 57 18 80    	mov    %bl,-0x7fe7a840(%edi)
      p += sizeof(struct mpproc);
801039d4:	83 c0 14             	add    $0x14,%eax
      continue;
801039d7:	e9 54 ff ff ff       	jmp    80103930 <mpinit+0xf0>
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801039e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801039e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801039ea:	e8 d1 fd ff ff       	call   801037c0 <mpsearch1>
801039ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801039f1:	85 c0                	test   %eax,%eax
801039f3:	0f 85 9b fe ff ff    	jne    80103894 <mpinit+0x54>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	68 62 88 10 80       	push   $0x80108862
80103a08:	e8 83 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a0d:	83 ec 0c             	sub    $0xc,%esp
80103a10:	68 7c 88 10 80       	push   $0x8010887c
80103a15:	e8 76 c9 ff ff       	call   80100390 <panic>
80103a1a:	66 90                	xchg   %ax,%ax
80103a1c:	66 90                	xchg   %ax,%ax
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a29:	ba 21 00 00 00       	mov    $0x21,%edx
80103a2e:	ee                   	out    %al,(%dx)
80103a2f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a34:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a35:	c3                   	ret    
80103a36:	66 90                	xchg   %ax,%ax
80103a38:	66 90                	xchg   %ax,%ax
80103a3a:	66 90                	xchg   %ax,%ax
80103a3c:	66 90                	xchg   %ax,%ax
80103a3e:	66 90                	xchg   %ax,%ax

80103a40 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	57                   	push   %edi
80103a48:	56                   	push   %esi
80103a49:	53                   	push   %ebx
80103a4a:	83 ec 0c             	sub    $0xc,%esp
80103a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a50:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a53:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a5f:	e8 dc d3 ff ff       	call   80100e40 <filealloc>
80103a64:	89 03                	mov    %eax,(%ebx)
80103a66:	85 c0                	test   %eax,%eax
80103a68:	0f 84 ac 00 00 00    	je     80103b1a <pipealloc+0xda>
80103a6e:	e8 cd d3 ff ff       	call   80100e40 <filealloc>
80103a73:	89 06                	mov    %eax,(%esi)
80103a75:	85 c0                	test   %eax,%eax
80103a77:	0f 84 8b 00 00 00    	je     80103b08 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a7d:	e8 ae f0 ff ff       	call   80102b30 <kalloc>
80103a82:	89 c7                	mov    %eax,%edi
80103a84:	85 c0                	test   %eax,%eax
80103a86:	0f 84 b4 00 00 00    	je     80103b40 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103a8c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103a93:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103a96:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103a99:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103aa0:	00 00 00 
  p->nwrite = 0;
80103aa3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103aaa:	00 00 00 
  p->nread = 0;
80103aad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ab4:	00 00 00 
  initlock(&p->lock, "pipe");
80103ab7:	68 9b 88 10 80       	push   $0x8010889b
80103abc:	50                   	push   %eax
80103abd:	e8 2e 12 00 00       	call   80104cf0 <initlock>
  (*f0)->type = FD_PIPE;
80103ac2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103ac4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103ac7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103acd:	8b 03                	mov    (%ebx),%eax
80103acf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ad3:	8b 03                	mov    (%ebx),%eax
80103ad5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ad9:	8b 03                	mov    (%ebx),%eax
80103adb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ade:	8b 06                	mov    (%esi),%eax
80103ae0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ae6:	8b 06                	mov    (%esi),%eax
80103ae8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103aec:	8b 06                	mov    (%esi),%eax
80103aee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103af2:	8b 06                	mov    (%esi),%eax
80103af4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103afa:	31 c0                	xor    %eax,%eax
}
80103afc:	5b                   	pop    %ebx
80103afd:	5e                   	pop    %esi
80103afe:	5f                   	pop    %edi
80103aff:	5d                   	pop    %ebp
80103b00:	c3                   	ret    
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b08:	8b 03                	mov    (%ebx),%eax
80103b0a:	85 c0                	test   %eax,%eax
80103b0c:	74 1e                	je     80103b2c <pipealloc+0xec>
    fileclose(*f0);
80103b0e:	83 ec 0c             	sub    $0xc,%esp
80103b11:	50                   	push   %eax
80103b12:	e8 e9 d3 ff ff       	call   80100f00 <fileclose>
80103b17:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b1a:	8b 06                	mov    (%esi),%eax
80103b1c:	85 c0                	test   %eax,%eax
80103b1e:	74 0c                	je     80103b2c <pipealloc+0xec>
    fileclose(*f1);
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	50                   	push   %eax
80103b24:	e8 d7 d3 ff ff       	call   80100f00 <fileclose>
80103b29:	83 c4 10             	add    $0x10,%esp
}
80103b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b34:	5b                   	pop    %ebx
80103b35:	5e                   	pop    %esi
80103b36:	5f                   	pop    %edi
80103b37:	5d                   	pop    %ebp
80103b38:	c3                   	ret    
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b40:	8b 03                	mov    (%ebx),%eax
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 c8                	jne    80103b0e <pipealloc+0xce>
80103b46:	eb d2                	jmp    80103b1a <pipealloc+0xda>
80103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	56                   	push   %esi
80103b58:	53                   	push   %ebx
80103b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b5f:	83 ec 0c             	sub    $0xc,%esp
80103b62:	53                   	push   %ebx
80103b63:	e8 08 13 00 00       	call   80104e70 <acquire>
  if(writable){
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	85 f6                	test   %esi,%esi
80103b6d:	74 41                	je     80103bb0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b6f:	83 ec 0c             	sub    $0xc,%esp
80103b72:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103b78:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b7f:	00 00 00 
    wakeup(&p->nread);
80103b82:	50                   	push   %eax
80103b83:	e8 18 0e 00 00       	call   801049a0 <wakeup>
80103b88:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b8b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103b91:	85 d2                	test   %edx,%edx
80103b93:	75 0a                	jne    80103b9f <pipeclose+0x4f>
80103b95:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b9b:	85 c0                	test   %eax,%eax
80103b9d:	74 31                	je     80103bd0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103b9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ba5:	5b                   	pop    %ebx
80103ba6:	5e                   	pop    %esi
80103ba7:	5d                   	pop    %ebp
    release(&p->lock);
80103ba8:	e9 83 13 00 00       	jmp    80104f30 <release>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103bb9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103bc0:	00 00 00 
    wakeup(&p->nwrite);
80103bc3:	50                   	push   %eax
80103bc4:	e8 d7 0d 00 00       	call   801049a0 <wakeup>
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	eb bd                	jmp    80103b8b <pipeclose+0x3b>
80103bce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	53                   	push   %ebx
80103bd4:	e8 57 13 00 00       	call   80104f30 <release>
    kfree((char*)p);
80103bd9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103bdc:	83 c4 10             	add    $0x10,%esp
}
80103bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be2:	5b                   	pop    %ebx
80103be3:	5e                   	pop    %esi
80103be4:	5d                   	pop    %ebp
    kfree((char*)p);
80103be5:	e9 46 ec ff ff       	jmp    80102830 <kfree>
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bf0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103bf0:	f3 0f 1e fb          	endbr32 
80103bf4:	55                   	push   %ebp
80103bf5:	89 e5                	mov    %esp,%ebp
80103bf7:	57                   	push   %edi
80103bf8:	56                   	push   %esi
80103bf9:	53                   	push   %ebx
80103bfa:	83 ec 28             	sub    $0x28,%esp
80103bfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c00:	53                   	push   %ebx
80103c01:	e8 6a 12 00 00       	call   80104e70 <acquire>
  for(i = 0; i < n; i++){
80103c06:	8b 45 10             	mov    0x10(%ebp),%eax
80103c09:	83 c4 10             	add    $0x10,%esp
80103c0c:	85 c0                	test   %eax,%eax
80103c0e:	0f 8e bc 00 00 00    	jle    80103cd0 <pipewrite+0xe0>
80103c14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c17:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c1d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c26:	03 45 10             	add    0x10(%ebp),%eax
80103c29:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c2c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c32:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c38:	89 ca                	mov    %ecx,%edx
80103c3a:	05 00 02 00 00       	add    $0x200,%eax
80103c3f:	39 c1                	cmp    %eax,%ecx
80103c41:	74 3b                	je     80103c7e <pipewrite+0x8e>
80103c43:	eb 63                	jmp    80103ca8 <pipewrite+0xb8>
80103c45:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c48:	e8 43 04 00 00       	call   80104090 <myproc>
80103c4d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c50:	85 c9                	test   %ecx,%ecx
80103c52:	75 34                	jne    80103c88 <pipewrite+0x98>
      wakeup(&p->nread);
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	57                   	push   %edi
80103c58:	e8 43 0d 00 00       	call   801049a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c5d:	58                   	pop    %eax
80103c5e:	5a                   	pop    %edx
80103c5f:	53                   	push   %ebx
80103c60:	56                   	push   %esi
80103c61:	e8 3a 0b 00 00       	call   801047a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c66:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c6c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c72:	83 c4 10             	add    $0x10,%esp
80103c75:	05 00 02 00 00       	add    $0x200,%eax
80103c7a:	39 c2                	cmp    %eax,%edx
80103c7c:	75 2a                	jne    80103ca8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103c7e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c84:	85 c0                	test   %eax,%eax
80103c86:	75 c0                	jne    80103c48 <pipewrite+0x58>
        release(&p->lock);
80103c88:	83 ec 0c             	sub    $0xc,%esp
80103c8b:	53                   	push   %ebx
80103c8c:	e8 9f 12 00 00       	call   80104f30 <release>
        return -1;
80103c91:	83 c4 10             	add    $0x10,%esp
80103c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c9c:	5b                   	pop    %ebx
80103c9d:	5e                   	pop    %esi
80103c9e:	5f                   	pop    %edi
80103c9f:	5d                   	pop    %ebp
80103ca0:	c3                   	ret    
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ca8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103cab:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cb4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103cba:	0f b6 06             	movzbl (%esi),%eax
80103cbd:	83 c6 01             	add    $0x1,%esi
80103cc0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103cc3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103cc7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103cca:	0f 85 5c ff ff ff    	jne    80103c2c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103cd9:	50                   	push   %eax
80103cda:	e8 c1 0c 00 00       	call   801049a0 <wakeup>
  release(&p->lock);
80103cdf:	89 1c 24             	mov    %ebx,(%esp)
80103ce2:	e8 49 12 00 00       	call   80104f30 <release>
  return n;
80103ce7:	8b 45 10             	mov    0x10(%ebp),%eax
80103cea:	83 c4 10             	add    $0x10,%esp
80103ced:	eb aa                	jmp    80103c99 <pipewrite+0xa9>
80103cef:	90                   	nop

80103cf0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	57                   	push   %edi
80103cf8:	56                   	push   %esi
80103cf9:	53                   	push   %ebx
80103cfa:	83 ec 18             	sub    $0x18,%esp
80103cfd:	8b 75 08             	mov    0x8(%ebp),%esi
80103d00:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d03:	56                   	push   %esi
80103d04:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d0a:	e8 61 11 00 00       	call   80104e70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d0f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103d1e:	74 33                	je     80103d53 <piperead+0x63>
80103d20:	eb 3b                	jmp    80103d5d <piperead+0x6d>
80103d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103d28:	e8 63 03 00 00       	call   80104090 <myproc>
80103d2d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d30:	85 c9                	test   %ecx,%ecx
80103d32:	0f 85 88 00 00 00    	jne    80103dc0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d38:	83 ec 08             	sub    $0x8,%esp
80103d3b:	56                   	push   %esi
80103d3c:	53                   	push   %ebx
80103d3d:	e8 5e 0a 00 00       	call   801047a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d42:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d51:	75 0a                	jne    80103d5d <piperead+0x6d>
80103d53:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d59:	85 c0                	test   %eax,%eax
80103d5b:	75 cb                	jne    80103d28 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d5d:	8b 55 10             	mov    0x10(%ebp),%edx
80103d60:	31 db                	xor    %ebx,%ebx
80103d62:	85 d2                	test   %edx,%edx
80103d64:	7f 28                	jg     80103d8e <piperead+0x9e>
80103d66:	eb 34                	jmp    80103d9c <piperead+0xac>
80103d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d6f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d70:	8d 48 01             	lea    0x1(%eax),%ecx
80103d73:	25 ff 01 00 00       	and    $0x1ff,%eax
80103d78:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103d7e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103d83:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d86:	83 c3 01             	add    $0x1,%ebx
80103d89:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d8c:	74 0e                	je     80103d9c <piperead+0xac>
    if(p->nread == p->nwrite)
80103d8e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d94:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103d9a:	75 d4                	jne    80103d70 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103d9c:	83 ec 0c             	sub    $0xc,%esp
80103d9f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103da5:	50                   	push   %eax
80103da6:	e8 f5 0b 00 00       	call   801049a0 <wakeup>
  release(&p->lock);
80103dab:	89 34 24             	mov    %esi,(%esp)
80103dae:	e8 7d 11 00 00       	call   80104f30 <release>
  return i;
80103db3:	83 c4 10             	add    $0x10,%esp
}
80103db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db9:	89 d8                	mov    %ebx,%eax
80103dbb:	5b                   	pop    %ebx
80103dbc:	5e                   	pop    %esi
80103dbd:	5f                   	pop    %edi
80103dbe:	5d                   	pop    %ebp
80103dbf:	c3                   	ret    
      release(&p->lock);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103dc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103dc8:	56                   	push   %esi
80103dc9:	e8 62 11 00 00       	call   80104f30 <release>
      return -1;
80103dce:	83 c4 10             	add    $0x10,%esp
}
80103dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dd4:	89 d8                	mov    %ebx,%eax
80103dd6:	5b                   	pop    %ebx
80103dd7:	5e                   	pop    %esi
80103dd8:	5f                   	pop    %edi
80103dd9:	5d                   	pop    %ebp
80103dda:	c3                   	ret    
80103ddb:	66 90                	xchg   %ax,%ax
80103ddd:	66 90                	xchg   %ax,%ax
80103ddf:	90                   	nop

80103de0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de6:	bb 94 5d 18 80       	mov    $0x80185d94,%ebx
{
80103deb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103dee:	68 60 5d 18 80       	push   $0x80185d60
80103df3:	e8 78 10 00 00       	call   80104e70 <acquire>
80103df8:	83 c4 10             	add    $0x10,%esp
80103dfb:	eb 15                	jmp    80103e12 <allocproc+0x32>
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e00:	81 c3 98 02 00 00    	add    $0x298,%ebx
80103e06:	81 fb 94 03 19 80    	cmp    $0x80190394,%ebx
80103e0c:	0f 84 3e 01 00 00    	je     80103f50 <allocproc+0x170>
    if(p->state == UNUSED)
80103e12:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e15:	85 c0                	test   %eax,%eax
80103e17:	75 e7                	jne    80103e00 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e19:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103e1e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e21:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e28:	89 43 10             	mov    %eax,0x10(%ebx)
80103e2b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103e2e:	68 60 5d 18 80       	push   $0x80185d60
  p->pid = nextpid++;
80103e33:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103e39:	e8 f2 10 00 00       	call   80104f30 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e3e:	e8 ed ec ff ff       	call   80102b30 <kalloc>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	89 43 08             	mov    %eax,0x8(%ebx)
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	0f 84 1b 01 00 00    	je     80103f6c <allocproc+0x18c>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e51:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e57:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e5a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e5f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e62:	c7 40 14 e1 61 10 80 	movl   $0x801061e1,0x14(%eax)
  p->context = (struct context*)sp;
80103e69:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e6c:	6a 14                	push   $0x14
80103e6e:	6a 00                	push   $0x0
80103e70:	50                   	push   %eax
80103e71:	e8 0a 11 00 00       	call   80104f80 <memset>
  p->context->eip = (uint)forkret;
80103e76:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80103e79:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103e7c:	c7 40 10 90 3f 10 80 	movl   $0x80103f90,0x10(%eax)
  if(p->pid > 2) {
80103e83:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103e87:	7f 0f                	jg     80103e98 <allocproc+0xb8>
    }
  }


  return p;
}
80103e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e8c:	89 d8                	mov    %ebx,%eax
80103e8e:	5b                   	pop    %ebx
80103e8f:	5e                   	pop    %esi
80103e90:	5f                   	pop    %edi
80103e91:	5d                   	pop    %ebp
80103e92:	c3                   	ret    
80103e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e97:	90                   	nop
    if(createSwapFile(p) != 0)
80103e98:	83 ec 0c             	sub    $0xc,%esp
80103e9b:	53                   	push   %ebx
80103e9c:	e8 8f e4 ff ff       	call   80102330 <createSwapFile>
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	85 c0                	test   %eax,%eax
80103ea6:	0f 85 d3 00 00 00    	jne    80103f7f <allocproc+0x19f>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103eac:	83 ec 04             	sub    $0x4,%esp
80103eaf:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
    p->num_ram = 0;
80103eb5:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103ebc:	00 00 00 
    p->num_swap = 0;
80103ebf:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80103ec6:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103ec9:	68 00 01 00 00       	push   $0x100
80103ece:	6a 00                	push   $0x0
80103ed0:	50                   	push   %eax
80103ed1:	e8 aa 10 00 00       	call   80104f80 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103ed6:	83 c4 0c             	add    $0xc,%esp
80103ed9:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103edf:	68 00 01 00 00       	push   $0x100
80103ee4:	6a 00                	push   $0x0
80103ee6:	50                   	push   %eax
80103ee7:	e8 94 10 00 00       	call   80104f80 <memset>
    if(p->pid > 2)
80103eec:	83 c4 10             	add    $0x10,%esp
80103eef:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103ef3:	7e 94                	jle    80103e89 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80103ef5:	e8 36 ec ff ff       	call   80102b30 <kalloc>
      struct fblock *prev = p->free_head;
80103efa:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head = (struct fblock*)kalloc();
80103eff:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
      p->free_head->prev = 0;
80103f05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      p->free_head->off = 0 * PGSIZE;
80103f0c:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80103f12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80103f18:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103f1e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80103f20:	89 c7                	mov    %eax,%edi
80103f22:	e8 09 ec ff ff       	call   80102b30 <kalloc>
        curr->off = i * PGSIZE;
80103f27:	89 30                	mov    %esi,(%eax)
        curr->prev = prev;
80103f29:	81 c6 00 10 00 00    	add    $0x1000,%esi
80103f2f:	89 78 08             	mov    %edi,0x8(%eax)
        curr->prev->next = curr;
80103f32:	89 47 04             	mov    %eax,0x4(%edi)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103f35:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
80103f3b:	75 e3                	jne    80103f20 <allocproc+0x140>
      p->free_tail = prev;
80103f3d:	89 83 94 02 00 00    	mov    %eax,0x294(%ebx)
      p->free_tail->next = 0;
80103f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80103f4a:	e9 3a ff ff ff       	jmp    80103e89 <allocproc+0xa9>
80103f4f:	90                   	nop
  release(&ptable.lock);
80103f50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f53:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f55:	68 60 5d 18 80       	push   $0x80185d60
80103f5a:	e8 d1 0f 00 00       	call   80104f30 <release>
  return 0;
80103f5f:	83 c4 10             	add    $0x10,%esp
}
80103f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f65:	89 d8                	mov    %ebx,%eax
80103f67:	5b                   	pop    %ebx
80103f68:	5e                   	pop    %esi
80103f69:	5f                   	pop    %edi
80103f6a:	5d                   	pop    %ebp
80103f6b:	c3                   	ret    
    p->state = UNUSED;
80103f6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103f76:	31 db                	xor    %ebx,%ebx
}
80103f78:	89 d8                	mov    %ebx,%eax
80103f7a:	5b                   	pop    %ebx
80103f7b:	5e                   	pop    %esi
80103f7c:	5f                   	pop    %edi
80103f7d:	5d                   	pop    %ebp
80103f7e:	c3                   	ret    
      panic("allocproc: createSwapFile");
80103f7f:	83 ec 0c             	sub    $0xc,%esp
80103f82:	68 a0 88 10 80       	push   $0x801088a0
80103f87:	e8 04 c4 ff ff       	call   80100390 <panic>
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f9a:	68 60 5d 18 80       	push   $0x80185d60
80103f9f:	e8 8c 0f 00 00       	call   80104f30 <release>

  if (first) {
80103fa4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103fa9:	83 c4 10             	add    $0x10,%esp
80103fac:	85 c0                	test   %eax,%eax
80103fae:	75 08                	jne    80103fb8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103fb0:	c9                   	leave  
80103fb1:	c3                   	ret    
80103fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103fb8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103fbf:	00 00 00 
    iinit(ROOTDEV);
80103fc2:	83 ec 0c             	sub    $0xc,%esp
80103fc5:	6a 01                	push   $0x1
80103fc7:	e8 b4 d5 ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103fcc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103fd3:	e8 08 f3 ff ff       	call   801032e0 <initlog>
}
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	c9                   	leave  
80103fdc:	c3                   	ret    
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi

80103fe0 <pinit>:
{
80103fe0:	f3 0f 1e fb          	endbr32 
80103fe4:	55                   	push   %ebp
80103fe5:	89 e5                	mov    %esp,%ebp
80103fe7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103fea:	68 ba 88 10 80       	push   $0x801088ba
80103fef:	68 60 5d 18 80       	push   $0x80185d60
80103ff4:	e8 f7 0c 00 00       	call   80104cf0 <initlock>
}
80103ff9:	83 c4 10             	add    $0x10,%esp
80103ffc:	c9                   	leave  
80103ffd:	c3                   	ret    
80103ffe:	66 90                	xchg   %ax,%ax

80104000 <mycpu>:
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	56                   	push   %esi
80104008:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104009:	9c                   	pushf  
8010400a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010400b:	f6 c4 02             	test   $0x2,%ah
8010400e:	75 4a                	jne    8010405a <mycpu+0x5a>
  apicid = lapicid();
80104010:	e8 db ee ff ff       	call   80102ef0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104015:	8b 35 40 5d 18 80    	mov    0x80185d40,%esi
  apicid = lapicid();
8010401b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010401d:	85 f6                	test   %esi,%esi
8010401f:	7e 2c                	jle    8010404d <mycpu+0x4d>
80104021:	31 d2                	xor    %edx,%edx
80104023:	eb 0a                	jmp    8010402f <mycpu+0x2f>
80104025:	8d 76 00             	lea    0x0(%esi),%esi
80104028:	83 c2 01             	add    $0x1,%edx
8010402b:	39 f2                	cmp    %esi,%edx
8010402d:	74 1e                	je     8010404d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010402f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104035:	0f b6 81 c0 57 18 80 	movzbl -0x7fe7a840(%ecx),%eax
8010403c:	39 d8                	cmp    %ebx,%eax
8010403e:	75 e8                	jne    80104028 <mycpu+0x28>
}
80104040:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104043:	8d 81 c0 57 18 80    	lea    -0x7fe7a840(%ecx),%eax
}
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5d                   	pop    %ebp
8010404c:	c3                   	ret    
  panic("unknown apicid\n");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 c1 88 10 80       	push   $0x801088c1
80104055:	e8 36 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 dc 89 10 80       	push   $0x801089dc
80104062:	e8 29 c3 ff ff       	call   80100390 <panic>
80104067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406e:	66 90                	xchg   %ax,%ax

80104070 <cpuid>:
cpuid() {
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010407a:	e8 81 ff ff ff       	call   80104000 <mycpu>
}
8010407f:	c9                   	leave  
  return mycpu()-cpus;
80104080:	2d c0 57 18 80       	sub    $0x801857c0,%eax
80104085:	c1 f8 04             	sar    $0x4,%eax
80104088:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010408e:	c3                   	ret    
8010408f:	90                   	nop

80104090 <myproc>:
myproc(void) {
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	53                   	push   %ebx
80104098:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010409b:	e8 d0 0c 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801040a0:	e8 5b ff ff ff       	call   80104000 <mycpu>
  p = c->proc;
801040a5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040ab:	e8 10 0d 00 00       	call   80104dc0 <popcli>
}
801040b0:	83 c4 04             	add    $0x4,%esp
801040b3:	89 d8                	mov    %ebx,%eax
801040b5:	5b                   	pop    %ebx
801040b6:	5d                   	pop    %ebp
801040b7:	c3                   	ret    
801040b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040bf:	90                   	nop

801040c0 <userinit>:
{
801040c0:	f3 0f 1e fb          	endbr32 
801040c4:	55                   	push   %ebp
801040c5:	89 e5                	mov    %esp,%ebp
801040c7:	53                   	push   %ebx
801040c8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801040cb:	e8 10 fd ff ff       	call   80103de0 <allocproc>
801040d0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801040d2:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  if((p->pgdir = setupkvm()) == 0)
801040d7:	e8 e4 39 00 00       	call   80107ac0 <setupkvm>
801040dc:	89 43 04             	mov    %eax,0x4(%ebx)
801040df:	85 c0                	test   %eax,%eax
801040e1:	0f 84 bd 00 00 00    	je     801041a4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801040e7:	83 ec 04             	sub    $0x4,%esp
801040ea:	68 2c 00 00 00       	push   $0x2c
801040ef:	68 60 b4 10 80       	push   $0x8010b460
801040f4:	50                   	push   %eax
801040f5:	e8 36 33 00 00       	call   80107430 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801040fa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801040fd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104103:	6a 4c                	push   $0x4c
80104105:	6a 00                	push   $0x0
80104107:	ff 73 18             	pushl  0x18(%ebx)
8010410a:	e8 71 0e 00 00       	call   80104f80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010410f:	8b 43 18             	mov    0x18(%ebx),%eax
80104112:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104117:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010411a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010411f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104123:	8b 43 18             	mov    0x18(%ebx),%eax
80104126:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010412a:	8b 43 18             	mov    0x18(%ebx),%eax
8010412d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104131:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104135:	8b 43 18             	mov    0x18(%ebx),%eax
80104138:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010413c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104140:	8b 43 18             	mov    0x18(%ebx),%eax
80104143:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010414a:	8b 43 18             	mov    0x18(%ebx),%eax
8010414d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104154:	8b 43 18             	mov    0x18(%ebx),%eax
80104157:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010415e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104161:	6a 10                	push   $0x10
80104163:	68 ea 88 10 80       	push   $0x801088ea
80104168:	50                   	push   %eax
80104169:	e8 d2 0f 00 00       	call   80105140 <safestrcpy>
  p->cwd = namei("/");
8010416e:	c7 04 24 f3 88 10 80 	movl   $0x801088f3,(%esp)
80104175:	e8 f6 de ff ff       	call   80102070 <namei>
8010417a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010417d:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
80104184:	e8 e7 0c 00 00       	call   80104e70 <acquire>
  p->state = RUNNABLE;
80104189:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104190:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
80104197:	e8 94 0d 00 00       	call   80104f30 <release>
}
8010419c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010419f:	83 c4 10             	add    $0x10,%esp
801041a2:	c9                   	leave  
801041a3:	c3                   	ret    
    panic("userinit: out of memory?");
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	68 d1 88 10 80       	push   $0x801088d1
801041ac:	e8 df c1 ff ff       	call   80100390 <panic>
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop

801041c0 <growproc>:
{
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	57                   	push   %edi
801041c8:	56                   	push   %esi
801041c9:	53                   	push   %ebx
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801041d0:	e8 9b 0b 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801041d5:	e8 26 fe ff ff       	call   80104000 <mycpu>
  p = c->proc;
801041da:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041e0:	e8 db 0b 00 00       	call   80104dc0 <popcli>
  sz = curproc->sz;
801041e5:	8b 1e                	mov    (%esi),%ebx
  if(n > 0){
801041e7:	85 ff                	test   %edi,%edi
801041e9:	7f 1d                	jg     80104208 <growproc+0x48>
  } else if(n < 0){
801041eb:	75 43                	jne    80104230 <growproc+0x70>
  switchuvm(curproc);
801041ed:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041f0:	89 1e                	mov    %ebx,(%esi)
  switchuvm(curproc);
801041f2:	56                   	push   %esi
801041f3:	e8 28 31 00 00       	call   80107320 <switchuvm>
  return 0;
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	31 c0                	xor    %eax,%eax
}
801041fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104200:	5b                   	pop    %ebx
80104201:	5e                   	pop    %esi
80104202:	5f                   	pop    %edi
80104203:	5d                   	pop    %ebp
80104204:	c3                   	ret    
80104205:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104208:	83 ec 04             	sub    $0x4,%esp
8010420b:	01 df                	add    %ebx,%edi
8010420d:	57                   	push   %edi
8010420e:	53                   	push   %ebx
8010420f:	ff 76 04             	pushl  0x4(%esi)
80104212:	e8 39 35 00 00       	call   80107750 <allocuvm>
80104217:	83 c4 10             	add    $0x10,%esp
8010421a:	89 c3                	mov    %eax,%ebx
8010421c:	85 c0                	test   %eax,%eax
8010421e:	75 cd                	jne    801041ed <growproc+0x2d>
      return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	eb d6                	jmp    801041fd <growproc+0x3d>
80104227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422e:	66 90                	xchg   %ax,%ax
    cprintf("growproc: n < 0\n");
80104230:	83 ec 0c             	sub    $0xc,%esp
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104233:	01 df                	add    %ebx,%edi
    cprintf("growproc: n < 0\n");
80104235:	68 f5 88 10 80       	push   $0x801088f5
8010423a:	e8 71 c4 ff ff       	call   801006b0 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010423f:	83 c4 0c             	add    $0xc,%esp
80104242:	57                   	push   %edi
80104243:	53                   	push   %ebx
80104244:	ff 76 04             	pushl  0x4(%esi)
80104247:	e8 44 33 00 00       	call   80107590 <deallocuvm>
8010424c:	83 c4 10             	add    $0x10,%esp
8010424f:	89 c3                	mov    %eax,%ebx
80104251:	85 c0                	test   %eax,%eax
80104253:	75 98                	jne    801041ed <growproc+0x2d>
80104255:	eb c9                	jmp    80104220 <growproc+0x60>
80104257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425e:	66 90                	xchg   %ax,%ax

80104260 <fork>:
{ 
80104260:	f3 0f 1e fb          	endbr32 
80104264:	55                   	push   %ebp
80104265:	89 e5                	mov    %esp,%ebp
80104267:	57                   	push   %edi
80104268:	56                   	push   %esi
80104269:	53                   	push   %ebx
8010426a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010426d:	e8 fe 0a 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104272:	e8 89 fd ff ff       	call   80104000 <mycpu>
  p = c->proc;
80104277:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010427d:	e8 3e 0b 00 00       	call   80104dc0 <popcli>
  if((np = allocproc()) == 0){
80104282:	e8 59 fb ff ff       	call   80103de0 <allocproc>
80104287:	85 c0                	test   %eax,%eax
80104289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010428c:	0f 84 a4 01 00 00    	je     80104436 <fork+0x1d6>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104292:	83 ec 08             	sub    $0x8,%esp
80104295:	ff 33                	pushl  (%ebx)
80104297:	ff 73 04             	pushl  0x4(%ebx)
8010429a:	e8 01 3e 00 00       	call   801080a0 <copyuvm>
8010429f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pgdir == 0){
801042a2:	83 c4 10             	add    $0x10,%esp
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801042a5:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
801042a8:	85 c0                	test   %eax,%eax
801042aa:	0f 84 90 01 00 00    	je     80104440 <fork+0x1e0>
  np->sz = curproc->sz;
801042b0:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801042b2:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801042b5:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801042b8:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801042bd:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801042bf:	8b 73 18             	mov    0x18(%ebx),%esi
801042c2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801042c4:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801042c8:	0f 8f 9a 00 00 00    	jg     80104368 <fork+0x108>
  np->tf->eax = 0;
801042ce:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
801042d1:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801042d3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
801042e0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801042e4:	85 c0                	test   %eax,%eax
801042e6:	74 16                	je     801042fe <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801042ee:	50                   	push   %eax
801042ef:	e8 bc cb ff ff       	call   80100eb0 <filedup>
801042f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042f7:	83 c4 10             	add    $0x10,%esp
801042fa:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801042fe:	83 c6 01             	add    $0x1,%esi
80104301:	83 fe 10             	cmp    $0x10,%esi
80104304:	75 da                	jne    801042e0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010430c:	83 c3 6c             	add    $0x6c,%ebx
8010430f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->cwd = idup(curproc->cwd);
80104312:	e8 59 d4 ff ff       	call   80101770 <idup>
80104317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010431a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010431d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104320:	8d 42 6c             	lea    0x6c(%edx),%eax
80104323:	6a 10                	push   $0x10
80104325:	53                   	push   %ebx
80104326:	50                   	push   %eax
80104327:	e8 14 0e 00 00       	call   80105140 <safestrcpy>
  pid = np->pid;
8010432c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010432f:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80104332:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
80104339:	e8 32 0b 00 00       	call   80104e70 <acquire>
  np->state = RUNNABLE;
8010433e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104341:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104348:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
8010434f:	e8 dc 0b 00 00       	call   80104f30 <release>
  return pid;
80104354:	83 c4 10             	add    $0x10,%esp
}
80104357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435a:	89 d8                	mov    %ebx,%eax
8010435c:	5b                   	pop    %ebx
8010435d:	5e                   	pop    %esi
8010435e:	5f                   	pop    %edi
8010435f:	5d                   	pop    %ebp
80104360:	c3                   	ret    
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
80104368:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
8010436e:	85 c0                	test   %eax,%eax
80104370:	74 1f                	je     80104391 <fork+0x131>
        np->ramPages[i].isused = 1;
80104372:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80104379:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010437c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
80104382:	89 82 90 01 00 00    	mov    %eax,0x190(%edx)
        np->ramPages[i].pgdir = np->pgdir;
80104388:	8b 42 04             	mov    0x4(%edx),%eax
8010438b:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
{ 
80104391:	31 f6                	xor    %esi,%esi
80104393:	eb 12                	jmp    801043a7 <fork+0x147>
80104395:	8d 76 00             	lea    0x0(%esi),%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++)
80104398:	83 c6 10             	add    $0x10,%esi
8010439b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801043a1:	0f 84 27 ff ff ff    	je     801042ce <fork+0x6e>
      if(curproc->swappedPages[i].isused)
801043a7:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
801043ae:	85 c9                	test   %ecx,%ecx
801043b0:	74 e6                	je     80104398 <fork+0x138>
      np->swappedPages[i].isused = 1;
801043b2:	c7 84 32 8c 00 00 00 	movl   $0x1,0x8c(%edx,%esi,1)
801043b9:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801043bd:	8b 84 33 90 00 00 00 	mov    0x90(%ebx,%esi,1),%eax
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801043c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801043c7:	89 84 32 90 00 00 00 	mov    %eax,0x90(%edx,%esi,1)
      np->swappedPages[i].pgdir = np->pgdir;
801043ce:	8b 42 04             	mov    0x4(%edx),%eax
801043d1:	89 84 32 88 00 00 00 	mov    %eax,0x88(%edx,%esi,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801043d8:	8b 84 33 94 00 00 00 	mov    0x94(%ebx,%esi,1),%eax
801043df:	89 84 32 94 00 00 00 	mov    %eax,0x94(%edx,%esi,1)
      if(readFromSwapFile((void*)curproc, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
801043e6:	68 00 10 00 00       	push   $0x1000
801043eb:	50                   	push   %eax
801043ec:	68 e0 b5 10 80       	push   $0x8010b5e0
801043f1:	53                   	push   %ebx
801043f2:	e8 09 e0 ff ff       	call   80102400 <readFromSwapFile>
801043f7:	83 c4 10             	add    $0x10,%esp
801043fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043fd:	85 c0                	test   %eax,%eax
801043ff:	78 68                	js     80104469 <fork+0x209>
      if(writeToSwapFile((void*)np, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104401:	68 00 10 00 00       	push   $0x1000
80104406:	ff b4 32 94 00 00 00 	pushl  0x94(%edx,%esi,1)
8010440d:	68 e0 b5 10 80       	push   $0x8010b5e0
80104412:	52                   	push   %edx
80104413:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104416:	e8 b5 df ff ff       	call   801023d0 <writeToSwapFile>
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104421:	85 c0                	test   %eax,%eax
80104423:	0f 89 6f ff ff ff    	jns    80104398 <fork+0x138>
        panic("fork: writeToSwapFile");
80104429:	83 ec 0c             	sub    $0xc,%esp
8010442c:	68 1d 89 10 80       	push   $0x8010891d
80104431:	e8 5a bf ff ff       	call   80100390 <panic>
    return -1;
80104436:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010443b:	e9 17 ff ff ff       	jmp    80104357 <fork+0xf7>
    kfree(np->kstack);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80104446:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010444b:	e8 e0 e3 ff ff       	call   80102830 <kfree>
    np->kstack = 0;
80104450:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104453:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104456:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010445d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104464:	e9 ee fe ff ff       	jmp    80104357 <fork+0xf7>
        panic("fork: readFromSwapFile");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 06 89 10 80       	push   $0x80108906
80104471:	e8 1a bf ff ff       	call   80100390 <panic>
80104476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447d:	8d 76 00             	lea    0x0(%esi),%esi

80104480 <scheduler>:
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	57                   	push   %edi
80104488:	56                   	push   %esi
80104489:	53                   	push   %ebx
8010448a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010448d:	e8 6e fb ff ff       	call   80104000 <mycpu>
  c->proc = 0;
80104492:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104499:	00 00 00 
  struct cpu *c = mycpu();
8010449c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010449e:	8d 78 04             	lea    0x4(%eax),%edi
801044a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801044a8:	fb                   	sti    
    acquire(&ptable.lock);
801044a9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ac:	bb 94 5d 18 80       	mov    $0x80185d94,%ebx
    acquire(&ptable.lock);
801044b1:	68 60 5d 18 80       	push   $0x80185d60
801044b6:	e8 b5 09 00 00       	call   80104e70 <acquire>
801044bb:	83 c4 10             	add    $0x10,%esp
801044be:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801044c0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044c4:	75 33                	jne    801044f9 <scheduler+0x79>
      switchuvm(p);
801044c6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044cf:	53                   	push   %ebx
801044d0:	e8 4b 2e 00 00       	call   80107320 <switchuvm>
      swtch(&(c->scheduler), p->context);
801044d5:	58                   	pop    %eax
801044d6:	5a                   	pop    %edx
801044d7:	ff 73 1c             	pushl  0x1c(%ebx)
801044da:	57                   	push   %edi
      p->state = RUNNING;
801044db:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044e2:	e8 bc 0c 00 00       	call   801051a3 <swtch>
      switchkvm();
801044e7:	e8 14 2e 00 00       	call   80107300 <switchkvm>
      c->proc = 0;
801044ec:	83 c4 10             	add    $0x10,%esp
801044ef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044f6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f9:	81 c3 98 02 00 00    	add    $0x298,%ebx
801044ff:	81 fb 94 03 19 80    	cmp    $0x80190394,%ebx
80104505:	75 b9                	jne    801044c0 <scheduler+0x40>
    release(&ptable.lock);
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	68 60 5d 18 80       	push   $0x80185d60
8010450f:	e8 1c 0a 00 00       	call   80104f30 <release>
    sti();
80104514:	83 c4 10             	add    $0x10,%esp
80104517:	eb 8f                	jmp    801044a8 <scheduler+0x28>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <sched>:
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	56                   	push   %esi
80104528:	53                   	push   %ebx
  pushcli();
80104529:	e8 42 08 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010452e:	e8 cd fa ff ff       	call   80104000 <mycpu>
  p = c->proc;
80104533:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104539:	e8 82 08 00 00       	call   80104dc0 <popcli>
  if(!holding(&ptable.lock))
8010453e:	83 ec 0c             	sub    $0xc,%esp
80104541:	68 60 5d 18 80       	push   $0x80185d60
80104546:	e8 d5 08 00 00       	call   80104e20 <holding>
8010454b:	83 c4 10             	add    $0x10,%esp
8010454e:	85 c0                	test   %eax,%eax
80104550:	74 4f                	je     801045a1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104552:	e8 a9 fa ff ff       	call   80104000 <mycpu>
80104557:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010455e:	75 68                	jne    801045c8 <sched+0xa8>
  if(p->state == RUNNING)
80104560:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104564:	74 55                	je     801045bb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104566:	9c                   	pushf  
80104567:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104568:	f6 c4 02             	test   $0x2,%ah
8010456b:	75 41                	jne    801045ae <sched+0x8e>
  intena = mycpu()->intena;
8010456d:	e8 8e fa ff ff       	call   80104000 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104572:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104575:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010457b:	e8 80 fa ff ff       	call   80104000 <mycpu>
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	ff 70 04             	pushl  0x4(%eax)
80104586:	53                   	push   %ebx
80104587:	e8 17 0c 00 00       	call   801051a3 <swtch>
  mycpu()->intena = intena;
8010458c:	e8 6f fa ff ff       	call   80104000 <mycpu>
}
80104591:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104594:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010459a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010459d:	5b                   	pop    %ebx
8010459e:	5e                   	pop    %esi
8010459f:	5d                   	pop    %ebp
801045a0:	c3                   	ret    
    panic("sched ptable.lock");
801045a1:	83 ec 0c             	sub    $0xc,%esp
801045a4:	68 33 89 10 80       	push   $0x80108933
801045a9:	e8 e2 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 5f 89 10 80       	push   $0x8010895f
801045b6:	e8 d5 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045bb:	83 ec 0c             	sub    $0xc,%esp
801045be:	68 51 89 10 80       	push   $0x80108951
801045c3:	e8 c8 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 45 89 10 80       	push   $0x80108945
801045d0:	e8 bb bd ff ff       	call   80100390 <panic>
801045d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <exit>:
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	57                   	push   %edi
801045e8:	56                   	push   %esi
801045e9:	53                   	push   %ebx
801045ea:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045ed:	e8 7e 07 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801045f2:	e8 09 fa ff ff       	call   80104000 <mycpu>
  p = c->proc;
801045f7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045fd:	e8 be 07 00 00       	call   80104dc0 <popcli>
  if(curproc == initproc)
80104602:	8d 5e 28             	lea    0x28(%esi),%ebx
80104605:	8d 7e 68             	lea    0x68(%esi),%edi
80104608:	39 35 c0 b5 10 80    	cmp    %esi,0x8010b5c0
8010460e:	0f 84 2e 01 00 00    	je     80104742 <exit+0x162>
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104618:	8b 03                	mov    (%ebx),%eax
8010461a:	85 c0                	test   %eax,%eax
8010461c:	74 12                	je     80104630 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010461e:	83 ec 0c             	sub    $0xc,%esp
80104621:	50                   	push   %eax
80104622:	e8 d9 c8 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104627:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010462d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104630:	83 c3 04             	add    $0x4,%ebx
80104633:	39 df                	cmp    %ebx,%edi
80104635:	75 e1                	jne    80104618 <exit+0x38>
  begin_op();
80104637:	e8 44 ed ff ff       	call   80103380 <begin_op>
  iput(curproc->cwd);
8010463c:	83 ec 0c             	sub    $0xc,%esp
8010463f:	ff 76 68             	pushl  0x68(%esi)
80104642:	e8 89 d2 ff ff       	call   801018d0 <iput>
  end_op();
80104647:	e8 a4 ed ff ff       	call   801033f0 <end_op>
  if(curproc->pid > 2) {
8010464c:	83 c4 10             	add    $0x10,%esp
8010464f:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
  curproc->cwd = 0;
80104653:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  if(curproc->pid > 2) {
8010465a:	0f 8f c1 00 00 00    	jg     80104721 <exit+0x141>
  acquire(&ptable.lock);
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	68 60 5d 18 80       	push   $0x80185d60
80104668:	e8 03 08 00 00       	call   80104e70 <acquire>
  wakeup1(curproc->parent);
8010466d:	8b 56 14             	mov    0x14(%esi),%edx
80104670:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104673:	b8 94 5d 18 80       	mov    $0x80185d94,%eax
80104678:	eb 12                	jmp    8010468c <exit+0xac>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104680:	05 98 02 00 00       	add    $0x298,%eax
80104685:	3d 94 03 19 80       	cmp    $0x80190394,%eax
8010468a:	74 1e                	je     801046aa <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010468c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104690:	75 ee                	jne    80104680 <exit+0xa0>
80104692:	3b 50 20             	cmp    0x20(%eax),%edx
80104695:	75 e9                	jne    80104680 <exit+0xa0>
      p->state = RUNNABLE;
80104697:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010469e:	05 98 02 00 00       	add    $0x298,%eax
801046a3:	3d 94 03 19 80       	cmp    $0x80190394,%eax
801046a8:	75 e2                	jne    8010468c <exit+0xac>
      p->parent = initproc;
801046aa:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046b0:	ba 94 5d 18 80       	mov    $0x80185d94,%edx
801046b5:	eb 17                	jmp    801046ce <exit+0xee>
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
801046c0:	81 c2 98 02 00 00    	add    $0x298,%edx
801046c6:	81 fa 94 03 19 80    	cmp    $0x80190394,%edx
801046cc:	74 3a                	je     80104708 <exit+0x128>
    if(p->parent == curproc){
801046ce:	39 72 14             	cmp    %esi,0x14(%edx)
801046d1:	75 ed                	jne    801046c0 <exit+0xe0>
      if(p->state == ZOMBIE)
801046d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046da:	75 e4                	jne    801046c0 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046dc:	b8 94 5d 18 80       	mov    $0x80185d94,%eax
801046e1:	eb 11                	jmp    801046f4 <exit+0x114>
801046e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e7:	90                   	nop
801046e8:	05 98 02 00 00       	add    $0x298,%eax
801046ed:	3d 94 03 19 80       	cmp    $0x80190394,%eax
801046f2:	74 cc                	je     801046c0 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
801046f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046f8:	75 ee                	jne    801046e8 <exit+0x108>
801046fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801046fd:	75 e9                	jne    801046e8 <exit+0x108>
      p->state = RUNNABLE;
801046ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104706:	eb e0                	jmp    801046e8 <exit+0x108>
  curproc->state = ZOMBIE;
80104708:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010470f:	e8 0c fe ff ff       	call   80104520 <sched>
  panic("zombie exit");
80104714:	83 ec 0c             	sub    $0xc,%esp
80104717:	68 80 89 10 80       	push   $0x80108980
8010471c:	e8 6f bc ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104721:	83 ec 0c             	sub    $0xc,%esp
80104724:	56                   	push   %esi
80104725:	e8 16 da ff ff       	call   80102140 <removeSwapFile>
8010472a:	83 c4 10             	add    $0x10,%esp
8010472d:	85 c0                	test   %eax,%eax
8010472f:	0f 84 2b ff ff ff    	je     80104660 <exit+0x80>
      panic("exit: error deleting swap file");
80104735:	83 ec 0c             	sub    $0xc,%esp
80104738:	68 04 8a 10 80       	push   $0x80108a04
8010473d:	e8 4e bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104742:	83 ec 0c             	sub    $0xc,%esp
80104745:	68 73 89 10 80       	push   $0x80108973
8010474a:	e8 41 bc ff ff       	call   80100390 <panic>
8010474f:	90                   	nop

80104750 <yield>:
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	53                   	push   %ebx
80104758:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010475b:	68 60 5d 18 80       	push   $0x80185d60
80104760:	e8 0b 07 00 00       	call   80104e70 <acquire>
  pushcli();
80104765:	e8 06 06 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010476a:	e8 91 f8 ff ff       	call   80104000 <mycpu>
  p = c->proc;
8010476f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104775:	e8 46 06 00 00       	call   80104dc0 <popcli>
  myproc()->state = RUNNABLE;
8010477a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104781:	e8 9a fd ff ff       	call   80104520 <sched>
  release(&ptable.lock);
80104786:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
8010478d:	e8 9e 07 00 00       	call   80104f30 <release>
}
80104792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104795:	83 c4 10             	add    $0x10,%esp
80104798:	c9                   	leave  
80104799:	c3                   	ret    
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <sleep>:
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	57                   	push   %edi
801047a8:	56                   	push   %esi
801047a9:	53                   	push   %ebx
801047aa:	83 ec 0c             	sub    $0xc,%esp
801047ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801047b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047b3:	e8 b8 05 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801047b8:	e8 43 f8 ff ff       	call   80104000 <mycpu>
  p = c->proc;
801047bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047c3:	e8 f8 05 00 00       	call   80104dc0 <popcli>
  if(p == 0)
801047c8:	85 db                	test   %ebx,%ebx
801047ca:	0f 84 83 00 00 00    	je     80104853 <sleep+0xb3>
  if(lk == 0)
801047d0:	85 f6                	test   %esi,%esi
801047d2:	74 72                	je     80104846 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047d4:	81 fe 60 5d 18 80    	cmp    $0x80185d60,%esi
801047da:	74 4c                	je     80104828 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	68 60 5d 18 80       	push   $0x80185d60
801047e4:	e8 87 06 00 00       	call   80104e70 <acquire>
    release(lk);
801047e9:	89 34 24             	mov    %esi,(%esp)
801047ec:	e8 3f 07 00 00       	call   80104f30 <release>
  p->chan = chan;
801047f1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047f4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047fb:	e8 20 fd ff ff       	call   80104520 <sched>
  p->chan = 0;
80104800:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104807:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
8010480e:	e8 1d 07 00 00       	call   80104f30 <release>
    acquire(lk);
80104813:	89 75 08             	mov    %esi,0x8(%ebp)
80104816:	83 c4 10             	add    $0x10,%esp
}
80104819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481c:	5b                   	pop    %ebx
8010481d:	5e                   	pop    %esi
8010481e:	5f                   	pop    %edi
8010481f:	5d                   	pop    %ebp
    acquire(lk);
80104820:	e9 4b 06 00 00       	jmp    80104e70 <acquire>
80104825:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104828:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010482b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104832:	e8 e9 fc ff ff       	call   80104520 <sched>
  p->chan = 0;
80104837:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010483e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104841:	5b                   	pop    %ebx
80104842:	5e                   	pop    %esi
80104843:	5f                   	pop    %edi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
    panic("sleep without lk");
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	68 92 89 10 80       	push   $0x80108992
8010484e:	e8 3d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104853:	83 ec 0c             	sub    $0xc,%esp
80104856:	68 8c 89 10 80       	push   $0x8010898c
8010485b:	e8 30 bb ff ff       	call   80100390 <panic>

80104860 <wait>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
  pushcli();
80104869:	e8 02 05 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010486e:	e8 8d f7 ff ff       	call   80104000 <mycpu>
  p = c->proc;
80104873:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104879:	e8 42 05 00 00       	call   80104dc0 <popcli>
  acquire(&ptable.lock);
8010487e:	83 ec 0c             	sub    $0xc,%esp
80104881:	68 60 5d 18 80       	push   $0x80185d60
80104886:	e8 e5 05 00 00       	call   80104e70 <acquire>
8010488b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010488e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104890:	bb 94 5d 18 80       	mov    $0x80185d94,%ebx
80104895:	eb 17                	jmp    801048ae <wait+0x4e>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax
801048a0:	81 c3 98 02 00 00    	add    $0x298,%ebx
801048a6:	81 fb 94 03 19 80    	cmp    $0x80190394,%ebx
801048ac:	74 1e                	je     801048cc <wait+0x6c>
      if(p->parent != curproc)
801048ae:	39 73 14             	cmp    %esi,0x14(%ebx)
801048b1:	75 ed                	jne    801048a0 <wait+0x40>
      if(p->state == ZOMBIE){
801048b3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048b7:	74 3f                	je     801048f8 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048b9:	81 c3 98 02 00 00    	add    $0x298,%ebx
      havekids = 1;
801048bf:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048c4:	81 fb 94 03 19 80    	cmp    $0x80190394,%ebx
801048ca:	75 e2                	jne    801048ae <wait+0x4e>
    if(!havekids || curproc->killed){
801048cc:	85 c0                	test   %eax,%eax
801048ce:	0f 84 a6 00 00 00    	je     8010497a <wait+0x11a>
801048d4:	8b 46 24             	mov    0x24(%esi),%eax
801048d7:	85 c0                	test   %eax,%eax
801048d9:	0f 85 9b 00 00 00    	jne    8010497a <wait+0x11a>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801048df:	83 ec 08             	sub    $0x8,%esp
801048e2:	68 60 5d 18 80       	push   $0x80185d60
801048e7:	56                   	push   %esi
801048e8:	e8 b3 fe ff ff       	call   801047a0 <sleep>
    havekids = 0;
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	eb 9c                	jmp    8010488e <wait+0x2e>
801048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104901:	e8 2a df ff ff       	call   80102830 <kfree>
        freevm(p->pgdir); // panic: kfree
80104906:	5a                   	pop    %edx
80104907:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010490a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104911:	e8 2a 31 00 00       	call   80107a40 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104916:	83 c4 0c             	add    $0xc,%esp
        p->name[0] = 0;
80104919:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
8010491d:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80104923:	68 00 01 00 00       	push   $0x100
80104928:	6a 00                	push   $0x0
8010492a:	50                   	push   %eax
        p->pid = 0;
8010492b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104932:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104939:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104940:	e8 3b 06 00 00       	call   80104f80 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104945:	83 c4 0c             	add    $0xc,%esp
80104948:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
8010494e:	68 00 01 00 00       	push   $0x100
80104953:	6a 00                	push   $0x0
80104955:	50                   	push   %eax
80104956:	e8 25 06 00 00       	call   80104f80 <memset>
        release(&ptable.lock);
8010495b:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
        p->state = UNUSED;
80104962:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104969:	e8 c2 05 00 00       	call   80104f30 <release>
        return pid;
8010496e:	83 c4 10             	add    $0x10,%esp
}
80104971:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104974:	89 f0                	mov    %esi,%eax
80104976:	5b                   	pop    %ebx
80104977:	5e                   	pop    %esi
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
      release(&ptable.lock);
8010497a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010497d:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104982:	68 60 5d 18 80       	push   $0x80185d60
80104987:	e8 a4 05 00 00       	call   80104f30 <release>
      return -1;
8010498c:	83 c4 10             	add    $0x10,%esp
8010498f:	eb e0                	jmp    80104971 <wait+0x111>
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop

801049a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	53                   	push   %ebx
801049a8:	83 ec 10             	sub    $0x10,%esp
801049ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ae:	68 60 5d 18 80       	push   $0x80185d60
801049b3:	e8 b8 04 00 00       	call   80104e70 <acquire>
801049b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049bb:	b8 94 5d 18 80       	mov    $0x80185d94,%eax
801049c0:	eb 12                	jmp    801049d4 <wakeup+0x34>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	05 98 02 00 00       	add    $0x298,%eax
801049cd:	3d 94 03 19 80       	cmp    $0x80190394,%eax
801049d2:	74 1e                	je     801049f2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801049d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049d8:	75 ee                	jne    801049c8 <wakeup+0x28>
801049da:	3b 58 20             	cmp    0x20(%eax),%ebx
801049dd:	75 e9                	jne    801049c8 <wakeup+0x28>
      p->state = RUNNABLE;
801049df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e6:	05 98 02 00 00       	add    $0x298,%eax
801049eb:	3d 94 03 19 80       	cmp    $0x80190394,%eax
801049f0:	75 e2                	jne    801049d4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801049f2:	c7 45 08 60 5d 18 80 	movl   $0x80185d60,0x8(%ebp)
}
801049f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049fc:	c9                   	leave  
  release(&ptable.lock);
801049fd:	e9 2e 05 00 00       	jmp    80104f30 <release>
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	53                   	push   %ebx
80104a18:	83 ec 10             	sub    $0x10,%esp
80104a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a1e:	68 60 5d 18 80       	push   $0x80185d60
80104a23:	e8 48 04 00 00       	call   80104e70 <acquire>
80104a28:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2b:	b8 94 5d 18 80       	mov    $0x80185d94,%eax
80104a30:	eb 12                	jmp    80104a44 <kill+0x34>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a38:	05 98 02 00 00       	add    $0x298,%eax
80104a3d:	3d 94 03 19 80       	cmp    $0x80190394,%eax
80104a42:	74 34                	je     80104a78 <kill+0x68>
    if(p->pid == pid){
80104a44:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a47:	75 ef                	jne    80104a38 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a49:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a4d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a54:	75 07                	jne    80104a5d <kill+0x4d>
        p->state = RUNNABLE;
80104a56:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a5d:	83 ec 0c             	sub    $0xc,%esp
80104a60:	68 60 5d 18 80       	push   $0x80185d60
80104a65:	e8 c6 04 00 00       	call   80104f30 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	31 c0                	xor    %eax,%eax
}
80104a72:	c9                   	leave  
80104a73:	c3                   	ret    
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 60 5d 18 80       	push   $0x80185d60
80104a80:	e8 ab 04 00 00       	call   80104f30 <release>
}
80104a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a88:	83 c4 10             	add    $0x10,%esp
80104a8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a90:	c9                   	leave  
80104a91:	c3                   	ret    
80104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	57                   	push   %edi
80104aa8:	56                   	push   %esi
80104aa9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104aac:	53                   	push   %ebx
80104aad:	bb 00 5e 18 80       	mov    $0x80185e00,%ebx
80104ab2:	83 ec 3c             	sub    $0x3c,%esp
80104ab5:	eb 2b                	jmp    80104ae2 <procdump+0x42>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ac0:	83 ec 0c             	sub    $0xc,%esp
80104ac3:	68 7a 8d 10 80       	push   $0x80108d7a
80104ac8:	e8 e3 bb ff ff       	call   801006b0 <cprintf>
80104acd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad0:	81 c3 98 02 00 00    	add    $0x298,%ebx
80104ad6:	81 fb 00 04 19 80    	cmp    $0x80190400,%ebx
80104adc:	0f 84 8e 00 00 00    	je     80104b70 <procdump+0xd0>
    if(p->state == UNUSED)
80104ae2:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	74 e7                	je     80104ad0 <procdump+0x30>
      state = "???";
80104ae9:	ba a3 89 10 80       	mov    $0x801089a3,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104aee:	83 f8 05             	cmp    $0x5,%eax
80104af1:	77 11                	ja     80104b04 <procdump+0x64>
80104af3:	8b 14 85 24 8a 10 80 	mov    -0x7fef75dc(,%eax,4),%edx
      state = "???";
80104afa:	b8 a3 89 10 80       	mov    $0x801089a3,%eax
80104aff:	85 d2                	test   %edx,%edx
80104b01:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b04:	53                   	push   %ebx
80104b05:	52                   	push   %edx
80104b06:	ff 73 a4             	pushl  -0x5c(%ebx)
80104b09:	68 a7 89 10 80       	push   $0x801089a7
80104b0e:	e8 9d bb ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104b1a:	75 a4                	jne    80104ac0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b1c:	83 ec 08             	sub    $0x8,%esp
80104b1f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b22:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b25:	50                   	push   %eax
80104b26:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104b29:	8b 40 0c             	mov    0xc(%eax),%eax
80104b2c:	83 c0 08             	add    $0x8,%eax
80104b2f:	50                   	push   %eax
80104b30:	e8 db 01 00 00       	call   80104d10 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b35:	83 c4 10             	add    $0x10,%esp
80104b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3f:	90                   	nop
80104b40:	8b 17                	mov    (%edi),%edx
80104b42:	85 d2                	test   %edx,%edx
80104b44:	0f 84 76 ff ff ff    	je     80104ac0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104b4a:	83 ec 08             	sub    $0x8,%esp
80104b4d:	83 c7 04             	add    $0x4,%edi
80104b50:	52                   	push   %edx
80104b51:	68 41 83 10 80       	push   $0x80108341
80104b56:	e8 55 bb ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	39 fe                	cmp    %edi,%esi
80104b60:	75 de                	jne    80104b40 <procdump+0xa0>
80104b62:	e9 59 ff ff ff       	jmp    80104ac0 <procdump+0x20>
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax
  }
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	5b                   	pop    %ebx
80104b74:	5e                   	pop    %esi
80104b75:	5f                   	pop    %edi
80104b76:	5d                   	pop    %ebp
80104b77:	c3                   	ret    
80104b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop

80104b80 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104b8a:	68 60 5d 18 80       	push   $0x80185d60
80104b8f:	e8 dc 02 00 00       	call   80104e70 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104b94:	c7 04 24 60 5d 18 80 	movl   $0x80185d60,(%esp)
80104b9b:	e8 90 03 00 00       	call   80104f30 <release>
  return sum;
80104ba0:	31 c0                	xor    %eax,%eax
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    
80104ba4:	66 90                	xchg   %ax,%ax
80104ba6:	66 90                	xchg   %ax,%ax
80104ba8:	66 90                	xchg   %ax,%ax
80104baa:	66 90                	xchg   %ax,%ax
80104bac:	66 90                	xchg   %ax,%ax
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	53                   	push   %ebx
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bbe:	68 3c 8a 10 80       	push   $0x80108a3c
80104bc3:	8d 43 04             	lea    0x4(%ebx),%eax
80104bc6:	50                   	push   %eax
80104bc7:	e8 24 01 00 00       	call   80104cf0 <initlock>
  lk->name = name;
80104bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104bcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104bd5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104bd8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bdf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be5:	c9                   	leave  
80104be6:	c3                   	ret    
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	56                   	push   %esi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bfc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bff:	83 ec 0c             	sub    $0xc,%esp
80104c02:	56                   	push   %esi
80104c03:	e8 68 02 00 00       	call   80104e70 <acquire>
  while (lk->locked) {
80104c08:	8b 13                	mov    (%ebx),%edx
80104c0a:	83 c4 10             	add    $0x10,%esp
80104c0d:	85 d2                	test   %edx,%edx
80104c0f:	74 1a                	je     80104c2b <acquiresleep+0x3b>
80104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104c18:	83 ec 08             	sub    $0x8,%esp
80104c1b:	56                   	push   %esi
80104c1c:	53                   	push   %ebx
80104c1d:	e8 7e fb ff ff       	call   801047a0 <sleep>
  while (lk->locked) {
80104c22:	8b 03                	mov    (%ebx),%eax
80104c24:	83 c4 10             	add    $0x10,%esp
80104c27:	85 c0                	test   %eax,%eax
80104c29:	75 ed                	jne    80104c18 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104c2b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c31:	e8 5a f4 ff ff       	call   80104090 <myproc>
80104c36:	8b 40 10             	mov    0x10(%eax),%eax
80104c39:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c3c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c42:	5b                   	pop    %ebx
80104c43:	5e                   	pop    %esi
80104c44:	5d                   	pop    %ebp
  release(&lk->lk);
80104c45:	e9 e6 02 00 00       	jmp    80104f30 <release>
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
80104c55:	89 e5                	mov    %esp,%ebp
80104c57:	56                   	push   %esi
80104c58:	53                   	push   %ebx
80104c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c5c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	56                   	push   %esi
80104c63:	e8 08 02 00 00       	call   80104e70 <acquire>
  lk->locked = 0;
80104c68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c6e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c75:	89 1c 24             	mov    %ebx,(%esp)
80104c78:	e8 23 fd ff ff       	call   801049a0 <wakeup>
  release(&lk->lk);
80104c7d:	89 75 08             	mov    %esi,0x8(%ebp)
80104c80:	83 c4 10             	add    $0x10,%esp
}
80104c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c86:	5b                   	pop    %ebx
80104c87:	5e                   	pop    %esi
80104c88:	5d                   	pop    %ebp
  release(&lk->lk);
80104c89:	e9 a2 02 00 00       	jmp    80104f30 <release>
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	57                   	push   %edi
80104c98:	31 ff                	xor    %edi,%edi
80104c9a:	56                   	push   %esi
80104c9b:	53                   	push   %ebx
80104c9c:	83 ec 18             	sub    $0x18,%esp
80104c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ca2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ca5:	56                   	push   %esi
80104ca6:	e8 c5 01 00 00       	call   80104e70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104cab:	8b 03                	mov    (%ebx),%eax
80104cad:	83 c4 10             	add    $0x10,%esp
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	75 1c                	jne    80104cd0 <holdingsleep+0x40>
  release(&lk->lk);
80104cb4:	83 ec 0c             	sub    $0xc,%esp
80104cb7:	56                   	push   %esi
80104cb8:	e8 73 02 00 00       	call   80104f30 <release>
  return r;
}
80104cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc0:	89 f8                	mov    %edi,%eax
80104cc2:	5b                   	pop    %ebx
80104cc3:	5e                   	pop    %esi
80104cc4:	5f                   	pop    %edi
80104cc5:	5d                   	pop    %ebp
80104cc6:	c3                   	ret    
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104cd0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cd3:	e8 b8 f3 ff ff       	call   80104090 <myproc>
80104cd8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cdb:	0f 94 c0             	sete   %al
80104cde:	0f b6 c0             	movzbl %al,%eax
80104ce1:	89 c7                	mov    %eax,%edi
80104ce3:	eb cf                	jmp    80104cb4 <holdingsleep+0x24>
80104ce5:	66 90                	xchg   %ax,%ax
80104ce7:	66 90                	xchg   %ax,%ax
80104ce9:	66 90                	xchg   %ax,%ax
80104ceb:	66 90                	xchg   %ax,%ax
80104ced:	66 90                	xchg   %ax,%ax
80104cef:	90                   	nop

80104cf0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d03:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d0d:	5d                   	pop    %ebp
80104d0e:	c3                   	ret    
80104d0f:	90                   	nop

80104d10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d15:	31 d2                	xor    %edx,%edx
{
80104d17:	89 e5                	mov    %esp,%ebp
80104d19:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d1a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d20:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d27:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d34:	77 1a                	ja     80104d50 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d36:	8b 58 04             	mov    0x4(%eax),%ebx
80104d39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d41:	83 fa 0a             	cmp    $0xa,%edx
80104d44:	75 e2                	jne    80104d28 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d46:	5b                   	pop    %ebx
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d53:	8d 51 28             	lea    0x28(%ecx),%edx
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d66:	83 c0 04             	add    $0x4,%eax
80104d69:	39 d0                	cmp    %edx,%eax
80104d6b:	75 f3                	jne    80104d60 <getcallerpcs+0x50>
}
80104d6d:	5b                   	pop    %ebx
80104d6e:	5d                   	pop    %ebp
80104d6f:	c3                   	ret    

80104d70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	53                   	push   %ebx
80104d78:	83 ec 04             	sub    $0x4,%esp
80104d7b:	9c                   	pushf  
80104d7c:	5b                   	pop    %ebx
  asm volatile("cli");
80104d7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d7e:	e8 7d f2 ff ff       	call   80104000 <mycpu>
80104d83:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d89:	85 c0                	test   %eax,%eax
80104d8b:	74 13                	je     80104da0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d8d:	e8 6e f2 ff ff       	call   80104000 <mycpu>
80104d92:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d99:	83 c4 04             	add    $0x4,%esp
80104d9c:	5b                   	pop    %ebx
80104d9d:	5d                   	pop    %ebp
80104d9e:	c3                   	ret    
80104d9f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104da0:	e8 5b f2 ff ff       	call   80104000 <mycpu>
80104da5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104dab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104db1:	eb da                	jmp    80104d8d <pushcli+0x1d>
80104db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <popcli>:

void
popcli(void)
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104dca:	9c                   	pushf  
80104dcb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104dcc:	f6 c4 02             	test   $0x2,%ah
80104dcf:	75 31                	jne    80104e02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104dd1:	e8 2a f2 ff ff       	call   80104000 <mycpu>
80104dd6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ddd:	78 30                	js     80104e0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ddf:	e8 1c f2 ff ff       	call   80104000 <mycpu>
80104de4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dea:	85 d2                	test   %edx,%edx
80104dec:	74 02                	je     80104df0 <popcli+0x30>
    sti();
}
80104dee:	c9                   	leave  
80104def:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104df0:	e8 0b f2 ff ff       	call   80104000 <mycpu>
80104df5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104dfb:	85 c0                	test   %eax,%eax
80104dfd:	74 ef                	je     80104dee <popcli+0x2e>
  asm volatile("sti");
80104dff:	fb                   	sti    
}
80104e00:	c9                   	leave  
80104e01:	c3                   	ret    
    panic("popcli - interruptible");
80104e02:	83 ec 0c             	sub    $0xc,%esp
80104e05:	68 47 8a 10 80       	push   $0x80108a47
80104e0a:	e8 81 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e0f:	83 ec 0c             	sub    $0xc,%esp
80104e12:	68 5e 8a 10 80       	push   $0x80108a5e
80104e17:	e8 74 b5 ff ff       	call   80100390 <panic>
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e20 <holding>:
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	56                   	push   %esi
80104e28:	53                   	push   %ebx
80104e29:	8b 75 08             	mov    0x8(%ebp),%esi
80104e2c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e2e:	e8 3d ff ff ff       	call   80104d70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e33:	8b 06                	mov    (%esi),%eax
80104e35:	85 c0                	test   %eax,%eax
80104e37:	75 0f                	jne    80104e48 <holding+0x28>
  popcli();
80104e39:	e8 82 ff ff ff       	call   80104dc0 <popcli>
}
80104e3e:	89 d8                	mov    %ebx,%eax
80104e40:	5b                   	pop    %ebx
80104e41:	5e                   	pop    %esi
80104e42:	5d                   	pop    %ebp
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e48:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e4b:	e8 b0 f1 ff ff       	call   80104000 <mycpu>
80104e50:	39 c3                	cmp    %eax,%ebx
80104e52:	0f 94 c3             	sete   %bl
  popcli();
80104e55:	e8 66 ff ff ff       	call   80104dc0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e5a:	0f b6 db             	movzbl %bl,%ebx
}
80104e5d:	89 d8                	mov    %ebx,%eax
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret    
80104e63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e70 <acquire>:
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	56                   	push   %esi
80104e78:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e79:	e8 f2 fe ff ff       	call   80104d70 <pushcli>
  if(holding(lk))
80104e7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	53                   	push   %ebx
80104e85:	e8 96 ff ff ff       	call   80104e20 <holding>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	0f 85 7f 00 00 00    	jne    80104f14 <acquire+0xa4>
80104e95:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e97:	ba 01 00 00 00       	mov    $0x1,%edx
80104e9c:	eb 05                	jmp    80104ea3 <acquire+0x33>
80104e9e:	66 90                	xchg   %ax,%ax
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
80104eb4:	e8 47 f1 ff ff       	call   80104000 <mycpu>
80104eb9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104ebc:	89 e8                	mov    %ebp,%eax
80104ebe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ec0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104ec6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104ecc:	77 22                	ja     80104ef0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ece:	8b 50 04             	mov    0x4(%eax),%edx
80104ed1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ed5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ed8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104eda:	83 fe 0a             	cmp    $0xa,%esi
80104edd:	75 e1                	jne    80104ec0 <acquire+0x50>
}
80104edf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee2:	5b                   	pop    %ebx
80104ee3:	5e                   	pop    %esi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ef0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ef4:	83 c3 34             	add    $0x34,%ebx
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f06:	83 c0 04             	add    $0x4,%eax
80104f09:	39 d8                	cmp    %ebx,%eax
80104f0b:	75 f3                	jne    80104f00 <acquire+0x90>
}
80104f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f10:	5b                   	pop    %ebx
80104f11:	5e                   	pop    %esi
80104f12:	5d                   	pop    %ebp
80104f13:	c3                   	ret    
    panic("acquire");
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	68 65 8a 10 80       	push   $0x80108a65
80104f1c:	e8 6f b4 ff ff       	call   80100390 <panic>
80104f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop

80104f30 <release>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	53                   	push   %ebx
80104f38:	83 ec 10             	sub    $0x10,%esp
80104f3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f3e:	53                   	push   %ebx
80104f3f:	e8 dc fe ff ff       	call   80104e20 <holding>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	74 22                	je     80104f6d <release+0x3d>
  lk->pcs[0] = 0;
80104f4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f59:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f67:	c9                   	leave  
  popcli();
80104f68:	e9 53 fe ff ff       	jmp    80104dc0 <popcli>
    panic("release");
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	68 6d 8a 10 80       	push   $0x80108a6d
80104f75:	e8 16 b4 ff ff       	call   80100390 <panic>
80104f7a:	66 90                	xchg   %ax,%ax
80104f7c:	66 90                	xchg   %ax,%ax
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	57                   	push   %edi
80104f88:	8b 55 08             	mov    0x8(%ebp),%edx
80104f8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f8e:	53                   	push   %ebx
80104f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f92:	89 d7                	mov    %edx,%edi
80104f94:	09 cf                	or     %ecx,%edi
80104f96:	83 e7 03             	and    $0x3,%edi
80104f99:	75 25                	jne    80104fc0 <memset+0x40>
    c &= 0xFF;
80104f9b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f9e:	c1 e0 18             	shl    $0x18,%eax
80104fa1:	89 fb                	mov    %edi,%ebx
80104fa3:	c1 e9 02             	shr    $0x2,%ecx
80104fa6:	c1 e3 10             	shl    $0x10,%ebx
80104fa9:	09 d8                	or     %ebx,%eax
80104fab:	09 f8                	or     %edi,%eax
80104fad:	c1 e7 08             	shl    $0x8,%edi
80104fb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104fb2:	89 d7                	mov    %edx,%edi
80104fb4:	fc                   	cld    
80104fb5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104fb7:	5b                   	pop    %ebx
80104fb8:	89 d0                	mov    %edx,%eax
80104fba:	5f                   	pop    %edi
80104fbb:	5d                   	pop    %ebp
80104fbc:	c3                   	ret    
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104fc0:	89 d7                	mov    %edx,%edi
80104fc2:	fc                   	cld    
80104fc3:	f3 aa                	rep stos %al,%es:(%edi)
80104fc5:	5b                   	pop    %ebx
80104fc6:	89 d0                	mov    %edx,%eax
80104fc8:	5f                   	pop    %edi
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	56                   	push   %esi
80104fd8:	8b 75 10             	mov    0x10(%ebp),%esi
80104fdb:	8b 55 08             	mov    0x8(%ebp),%edx
80104fde:	53                   	push   %ebx
80104fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fe2:	85 f6                	test   %esi,%esi
80104fe4:	74 2a                	je     80105010 <memcmp+0x40>
80104fe6:	01 c6                	add    %eax,%esi
80104fe8:	eb 10                	jmp    80104ffa <memcmp+0x2a>
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ff0:	83 c0 01             	add    $0x1,%eax
80104ff3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ff6:	39 f0                	cmp    %esi,%eax
80104ff8:	74 16                	je     80105010 <memcmp+0x40>
    if(*s1 != *s2)
80104ffa:	0f b6 0a             	movzbl (%edx),%ecx
80104ffd:	0f b6 18             	movzbl (%eax),%ebx
80105000:	38 d9                	cmp    %bl,%cl
80105002:	74 ec                	je     80104ff0 <memcmp+0x20>
      return *s1 - *s2;
80105004:	0f b6 c1             	movzbl %cl,%eax
80105007:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105009:	5b                   	pop    %ebx
8010500a:	5e                   	pop    %esi
8010500b:	5d                   	pop    %ebp
8010500c:	c3                   	ret    
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
80105010:	5b                   	pop    %ebx
  return 0;
80105011:	31 c0                	xor    %eax,%eax
}
80105013:	5e                   	pop    %esi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi

80105020 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	57                   	push   %edi
80105028:	8b 55 08             	mov    0x8(%ebp),%edx
8010502b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010502e:	56                   	push   %esi
8010502f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105032:	39 d6                	cmp    %edx,%esi
80105034:	73 2a                	jae    80105060 <memmove+0x40>
80105036:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105039:	39 fa                	cmp    %edi,%edx
8010503b:	73 23                	jae    80105060 <memmove+0x40>
8010503d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105040:	85 c9                	test   %ecx,%ecx
80105042:	74 13                	je     80105057 <memmove+0x37>
80105044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105048:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010504c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010504f:	83 e8 01             	sub    $0x1,%eax
80105052:	83 f8 ff             	cmp    $0xffffffff,%eax
80105055:	75 f1                	jne    80105048 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105057:	5e                   	pop    %esi
80105058:	89 d0                	mov    %edx,%eax
8010505a:	5f                   	pop    %edi
8010505b:	5d                   	pop    %ebp
8010505c:	c3                   	ret    
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105060:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105063:	89 d7                	mov    %edx,%edi
80105065:	85 c9                	test   %ecx,%ecx
80105067:	74 ee                	je     80105057 <memmove+0x37>
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105070:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105071:	39 f0                	cmp    %esi,%eax
80105073:	75 fb                	jne    80105070 <memmove+0x50>
}
80105075:	5e                   	pop    %esi
80105076:	89 d0                	mov    %edx,%eax
80105078:	5f                   	pop    %edi
80105079:	5d                   	pop    %ebp
8010507a:	c3                   	ret    
8010507b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop

80105080 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105080:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105084:	eb 9a                	jmp    80105020 <memmove>
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi

80105090 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	8b 75 10             	mov    0x10(%ebp),%esi
8010509b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010509e:	53                   	push   %ebx
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801050a2:	85 f6                	test   %esi,%esi
801050a4:	74 32                	je     801050d8 <strncmp+0x48>
801050a6:	01 c6                	add    %eax,%esi
801050a8:	eb 14                	jmp    801050be <strncmp+0x2e>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050b0:	38 da                	cmp    %bl,%dl
801050b2:	75 14                	jne    801050c8 <strncmp+0x38>
    n--, p++, q++;
801050b4:	83 c0 01             	add    $0x1,%eax
801050b7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050ba:	39 f0                	cmp    %esi,%eax
801050bc:	74 1a                	je     801050d8 <strncmp+0x48>
801050be:	0f b6 11             	movzbl (%ecx),%edx
801050c1:	0f b6 18             	movzbl (%eax),%ebx
801050c4:	84 d2                	test   %dl,%dl
801050c6:	75 e8                	jne    801050b0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801050c8:	0f b6 c2             	movzbl %dl,%eax
801050cb:	29 d8                	sub    %ebx,%eax
}
801050cd:	5b                   	pop    %ebx
801050ce:	5e                   	pop    %esi
801050cf:	5d                   	pop    %ebp
801050d0:	c3                   	ret    
801050d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050d8:	5b                   	pop    %ebx
    return 0;
801050d9:	31 c0                	xor    %eax,%eax
}
801050db:	5e                   	pop    %esi
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    
801050de:	66 90                	xchg   %ax,%ax

801050e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	57                   	push   %edi
801050e8:	56                   	push   %esi
801050e9:	8b 75 08             	mov    0x8(%ebp),%esi
801050ec:	53                   	push   %ebx
801050ed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050f0:	89 f2                	mov    %esi,%edx
801050f2:	eb 1b                	jmp    8010510f <strncpy+0x2f>
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801050ff:	83 c2 01             	add    $0x1,%edx
80105102:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105106:	89 f9                	mov    %edi,%ecx
80105108:	88 4a ff             	mov    %cl,-0x1(%edx)
8010510b:	84 c9                	test   %cl,%cl
8010510d:	74 09                	je     80105118 <strncpy+0x38>
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	83 e8 01             	sub    $0x1,%eax
80105114:	85 db                	test   %ebx,%ebx
80105116:	7f e0                	jg     801050f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105118:	89 d1                	mov    %edx,%ecx
8010511a:	85 c0                	test   %eax,%eax
8010511c:	7e 15                	jle    80105133 <strncpy+0x53>
8010511e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105120:	83 c1 01             	add    $0x1,%ecx
80105123:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105127:	89 c8                	mov    %ecx,%eax
80105129:	f7 d0                	not    %eax
8010512b:	01 d0                	add    %edx,%eax
8010512d:	01 d8                	add    %ebx,%eax
8010512f:	85 c0                	test   %eax,%eax
80105131:	7f ed                	jg     80105120 <strncpy+0x40>
  return os;
}
80105133:	5b                   	pop    %ebx
80105134:	89 f0                	mov    %esi,%eax
80105136:	5e                   	pop    %esi
80105137:	5f                   	pop    %edi
80105138:	5d                   	pop    %ebp
80105139:	c3                   	ret    
8010513a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105140 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	56                   	push   %esi
80105148:	8b 55 10             	mov    0x10(%ebp),%edx
8010514b:	8b 75 08             	mov    0x8(%ebp),%esi
8010514e:	53                   	push   %ebx
8010514f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105152:	85 d2                	test   %edx,%edx
80105154:	7e 21                	jle    80105177 <safestrcpy+0x37>
80105156:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010515a:	89 f2                	mov    %esi,%edx
8010515c:	eb 12                	jmp    80105170 <safestrcpy+0x30>
8010515e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105160:	0f b6 08             	movzbl (%eax),%ecx
80105163:	83 c0 01             	add    $0x1,%eax
80105166:	83 c2 01             	add    $0x1,%edx
80105169:	88 4a ff             	mov    %cl,-0x1(%edx)
8010516c:	84 c9                	test   %cl,%cl
8010516e:	74 04                	je     80105174 <safestrcpy+0x34>
80105170:	39 d8                	cmp    %ebx,%eax
80105172:	75 ec                	jne    80105160 <safestrcpy+0x20>
    ;
  *s = 0;
80105174:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105177:	89 f0                	mov    %esi,%eax
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi

80105180 <strlen>:

int
strlen(const char *s)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105185:	31 c0                	xor    %eax,%eax
{
80105187:	89 e5                	mov    %esp,%ebp
80105189:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010518c:	80 3a 00             	cmpb   $0x0,(%edx)
8010518f:	74 10                	je     801051a1 <strlen+0x21>
80105191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105198:	83 c0 01             	add    $0x1,%eax
8010519b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010519f:	75 f7                	jne    80105198 <strlen+0x18>
    ;
  return n;
}
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    

801051a3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051a7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051ab:	55                   	push   %ebp
  pushl %ebx
801051ac:	53                   	push   %ebx
  pushl %esi
801051ad:	56                   	push   %esi
  pushl %edi
801051ae:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051af:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051b1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051b3:	5f                   	pop    %edi
  popl %esi
801051b4:	5e                   	pop    %esi
  popl %ebx
801051b5:	5b                   	pop    %ebx
  popl %ebp
801051b6:	5d                   	pop    %ebp
  ret
801051b7:	c3                   	ret    
801051b8:	66 90                	xchg   %ax,%ax
801051ba:	66 90                	xchg   %ax,%ax
801051bc:	66 90                	xchg   %ax,%ax
801051be:	66 90                	xchg   %ax,%ax

801051c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	53                   	push   %ebx
801051c8:	83 ec 04             	sub    $0x4,%esp
801051cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051ce:	e8 bd ee ff ff       	call   80104090 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051d3:	8b 00                	mov    (%eax),%eax
801051d5:	39 d8                	cmp    %ebx,%eax
801051d7:	76 17                	jbe    801051f0 <fetchint+0x30>
801051d9:	8d 53 04             	lea    0x4(%ebx),%edx
801051dc:	39 d0                	cmp    %edx,%eax
801051de:	72 10                	jb     801051f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e3:	8b 13                	mov    (%ebx),%edx
801051e5:	89 10                	mov    %edx,(%eax)
  return 0;
801051e7:	31 c0                	xor    %eax,%eax
}
801051e9:	83 c4 04             	add    $0x4,%esp
801051ec:	5b                   	pop    %ebx
801051ed:	5d                   	pop    %ebp
801051ee:	c3                   	ret    
801051ef:	90                   	nop
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	eb f2                	jmp    801051e9 <fetchint+0x29>
801051f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fe:	66 90                	xchg   %ax,%ax

80105200 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	53                   	push   %ebx
80105208:	83 ec 04             	sub    $0x4,%esp
8010520b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010520e:	e8 7d ee ff ff       	call   80104090 <myproc>

  if(addr >= curproc->sz)
80105213:	39 18                	cmp    %ebx,(%eax)
80105215:	76 31                	jbe    80105248 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105217:	8b 55 0c             	mov    0xc(%ebp),%edx
8010521a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010521c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010521e:	39 d3                	cmp    %edx,%ebx
80105220:	73 26                	jae    80105248 <fetchstr+0x48>
80105222:	89 d8                	mov    %ebx,%eax
80105224:	eb 11                	jmp    80105237 <fetchstr+0x37>
80105226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	83 c0 01             	add    $0x1,%eax
80105233:	39 c2                	cmp    %eax,%edx
80105235:	76 11                	jbe    80105248 <fetchstr+0x48>
    if(*s == 0)
80105237:	80 38 00             	cmpb   $0x0,(%eax)
8010523a:	75 f4                	jne    80105230 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010523c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010523f:	29 d8                	sub    %ebx,%eax
}
80105241:	5b                   	pop    %ebx
80105242:	5d                   	pop    %ebp
80105243:	c3                   	ret    
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105248:	83 c4 04             	add    $0x4,%esp
    return -1;
8010524b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105250:	5b                   	pop    %ebx
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret    
80105253:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105260 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	56                   	push   %esi
80105268:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105269:	e8 22 ee ff ff       	call   80104090 <myproc>
8010526e:	8b 55 08             	mov    0x8(%ebp),%edx
80105271:	8b 40 18             	mov    0x18(%eax),%eax
80105274:	8b 40 44             	mov    0x44(%eax),%eax
80105277:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010527a:	e8 11 ee ff ff       	call   80104090 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010527f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105282:	8b 00                	mov    (%eax),%eax
80105284:	39 c6                	cmp    %eax,%esi
80105286:	73 18                	jae    801052a0 <argint+0x40>
80105288:	8d 53 08             	lea    0x8(%ebx),%edx
8010528b:	39 d0                	cmp    %edx,%eax
8010528d:	72 11                	jb     801052a0 <argint+0x40>
  *ip = *(int*)(addr);
8010528f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105292:	8b 53 04             	mov    0x4(%ebx),%edx
80105295:	89 10                	mov    %edx,(%eax)
  return 0;
80105297:	31 c0                	xor    %eax,%eax
}
80105299:	5b                   	pop    %ebx
8010529a:	5e                   	pop    %esi
8010529b:	5d                   	pop    %ebp
8010529c:	c3                   	ret    
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052a5:	eb f2                	jmp    80105299 <argint+0x39>
801052a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	56                   	push   %esi
801052b8:	53                   	push   %ebx
801052b9:	83 ec 10             	sub    $0x10,%esp
801052bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801052bf:	e8 cc ed ff ff       	call   80104090 <myproc>
 
  if(argint(n, &i) < 0)
801052c4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801052c7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801052c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cc:	50                   	push   %eax
801052cd:	ff 75 08             	pushl  0x8(%ebp)
801052d0:	e8 8b ff ff ff       	call   80105260 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	85 c0                	test   %eax,%eax
801052da:	78 24                	js     80105300 <argptr+0x50>
801052dc:	85 db                	test   %ebx,%ebx
801052de:	78 20                	js     80105300 <argptr+0x50>
801052e0:	8b 16                	mov    (%esi),%edx
801052e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e5:	39 c2                	cmp    %eax,%edx
801052e7:	76 17                	jbe    80105300 <argptr+0x50>
801052e9:	01 c3                	add    %eax,%ebx
801052eb:	39 da                	cmp    %ebx,%edx
801052ed:	72 11                	jb     80105300 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801052f2:	89 02                	mov    %eax,(%edx)
  return 0;
801052f4:	31 c0                	xor    %eax,%eax
}
801052f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5d                   	pop    %ebp
801052fc:	c3                   	ret    
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb ef                	jmp    801052f6 <argptr+0x46>
80105307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010530e:	66 90                	xchg   %ax,%ax

80105310 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010531a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531d:	50                   	push   %eax
8010531e:	ff 75 08             	pushl  0x8(%ebp)
80105321:	e8 3a ff ff ff       	call   80105260 <argint>
80105326:	83 c4 10             	add    $0x10,%esp
80105329:	85 c0                	test   %eax,%eax
8010532b:	78 13                	js     80105340 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010532d:	83 ec 08             	sub    $0x8,%esp
80105330:	ff 75 0c             	pushl  0xc(%ebp)
80105333:	ff 75 f4             	pushl  -0xc(%ebp)
80105336:	e8 c5 fe ff ff       	call   80105200 <fetchstr>
8010533b:	83 c4 10             	add    $0x10,%esp
}
8010533e:	c9                   	leave  
8010533f:	c3                   	ret    
80105340:	c9                   	leave  
    return -1;
80105341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105346:	c3                   	ret    
80105347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534e:	66 90                	xchg   %ax,%ax

80105350 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	53                   	push   %ebx
80105358:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010535b:	e8 30 ed ff ff       	call   80104090 <myproc>
80105360:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105362:	8b 40 18             	mov    0x18(%eax),%eax
80105365:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105368:	8d 50 ff             	lea    -0x1(%eax),%edx
8010536b:	83 fa 16             	cmp    $0x16,%edx
8010536e:	77 20                	ja     80105390 <syscall+0x40>
80105370:	8b 14 85 a0 8a 10 80 	mov    -0x7fef7560(,%eax,4),%edx
80105377:	85 d2                	test   %edx,%edx
80105379:	74 15                	je     80105390 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010537b:	ff d2                	call   *%edx
8010537d:	89 c2                	mov    %eax,%edx
8010537f:	8b 43 18             	mov    0x18(%ebx),%eax
80105382:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105388:	c9                   	leave  
80105389:	c3                   	ret    
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105390:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105391:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105394:	50                   	push   %eax
80105395:	ff 73 10             	pushl  0x10(%ebx)
80105398:	68 75 8a 10 80       	push   $0x80108a75
8010539d:	e8 0e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801053a2:	8b 43 18             	mov    0x18(%ebx),%eax
801053a5:	83 c4 10             	add    $0x10,%esp
801053a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	66 90                	xchg   %ax,%ax
801053b6:	66 90                	xchg   %ax,%ax
801053b8:	66 90                	xchg   %ax,%ax
801053ba:	66 90                	xchg   %ax,%ax
801053bc:	66 90                	xchg   %ax,%ax
801053be:	66 90                	xchg   %ax,%ax

801053c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	89 d6                	mov    %edx,%esi
801053c6:	53                   	push   %ebx
801053c7:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801053cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053cf:	50                   	push   %eax
801053d0:	6a 00                	push   $0x0
801053d2:	e8 89 fe ff ff       	call   80105260 <argint>
801053d7:	83 c4 10             	add    $0x10,%esp
801053da:	85 c0                	test   %eax,%eax
801053dc:	78 2a                	js     80105408 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053e2:	77 24                	ja     80105408 <argfd.constprop.0+0x48>
801053e4:	e8 a7 ec ff ff       	call   80104090 <myproc>
801053e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053f0:	85 c0                	test   %eax,%eax
801053f2:	74 14                	je     80105408 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801053f4:	85 db                	test   %ebx,%ebx
801053f6:	74 02                	je     801053fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801053f8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801053fa:	89 06                	mov    %eax,(%esi)
  return 0;
801053fc:	31 c0                	xor    %eax,%eax
}
801053fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105401:	5b                   	pop    %ebx
80105402:	5e                   	pop    %esi
80105403:	5d                   	pop    %ebp
80105404:	c3                   	ret    
80105405:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540d:	eb ef                	jmp    801053fe <argfd.constprop.0+0x3e>
8010540f:	90                   	nop

80105410 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105415:	31 c0                	xor    %eax,%eax
{
80105417:	89 e5                	mov    %esp,%ebp
80105419:	56                   	push   %esi
8010541a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010541b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010541e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105421:	e8 9a ff ff ff       	call   801053c0 <argfd.constprop.0>
80105426:	85 c0                	test   %eax,%eax
80105428:	78 1e                	js     80105448 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010542a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010542d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010542f:	e8 5c ec ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105438:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010543c:	85 d2                	test   %edx,%edx
8010543e:	74 20                	je     80105460 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105440:	83 c3 01             	add    $0x1,%ebx
80105443:	83 fb 10             	cmp    $0x10,%ebx
80105446:	75 f0                	jne    80105438 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105448:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010544b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105450:	89 d8                	mov    %ebx,%eax
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5d                   	pop    %ebp
80105455:	c3                   	ret    
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105460:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	ff 75 f4             	pushl  -0xc(%ebp)
8010546a:	e8 41 ba ff ff       	call   80100eb0 <filedup>
  return fd;
8010546f:	83 c4 10             	add    $0x10,%esp
}
80105472:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105475:	89 d8                	mov    %ebx,%eax
80105477:	5b                   	pop    %ebx
80105478:	5e                   	pop    %esi
80105479:	5d                   	pop    %ebp
8010547a:	c3                   	ret    
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop

80105480 <sys_read>:

int
sys_read(void)
{
80105480:	f3 0f 1e fb          	endbr32 
80105484:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105485:	31 c0                	xor    %eax,%eax
{
80105487:	89 e5                	mov    %esp,%ebp
80105489:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010548c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010548f:	e8 2c ff ff ff       	call   801053c0 <argfd.constprop.0>
80105494:	85 c0                	test   %eax,%eax
80105496:	78 48                	js     801054e0 <sys_read+0x60>
80105498:	83 ec 08             	sub    $0x8,%esp
8010549b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010549e:	50                   	push   %eax
8010549f:	6a 02                	push   $0x2
801054a1:	e8 ba fd ff ff       	call   80105260 <argint>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	78 33                	js     801054e0 <sys_read+0x60>
801054ad:	83 ec 04             	sub    $0x4,%esp
801054b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b3:	ff 75 f0             	pushl  -0x10(%ebp)
801054b6:	50                   	push   %eax
801054b7:	6a 01                	push   $0x1
801054b9:	e8 f2 fd ff ff       	call   801052b0 <argptr>
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	85 c0                	test   %eax,%eax
801054c3:	78 1b                	js     801054e0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801054c5:	83 ec 04             	sub    $0x4,%esp
801054c8:	ff 75 f0             	pushl  -0x10(%ebp)
801054cb:	ff 75 f4             	pushl  -0xc(%ebp)
801054ce:	ff 75 ec             	pushl  -0x14(%ebp)
801054d1:	e8 5a bb ff ff       	call   80101030 <fileread>
801054d6:	83 c4 10             	add    $0x10,%esp
}
801054d9:	c9                   	leave  
801054da:	c3                   	ret    
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop
801054e0:	c9                   	leave  
    return -1;
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e6:	c3                   	ret    
801054e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <sys_write>:

int
sys_write(void)
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054f5:	31 c0                	xor    %eax,%eax
{
801054f7:	89 e5                	mov    %esp,%ebp
801054f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054ff:	e8 bc fe ff ff       	call   801053c0 <argfd.constprop.0>
80105504:	85 c0                	test   %eax,%eax
80105506:	78 48                	js     80105550 <sys_write+0x60>
80105508:	83 ec 08             	sub    $0x8,%esp
8010550b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550e:	50                   	push   %eax
8010550f:	6a 02                	push   $0x2
80105511:	e8 4a fd ff ff       	call   80105260 <argint>
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 c0                	test   %eax,%eax
8010551b:	78 33                	js     80105550 <sys_write+0x60>
8010551d:	83 ec 04             	sub    $0x4,%esp
80105520:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105523:	ff 75 f0             	pushl  -0x10(%ebp)
80105526:	50                   	push   %eax
80105527:	6a 01                	push   $0x1
80105529:	e8 82 fd ff ff       	call   801052b0 <argptr>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	78 1b                	js     80105550 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105535:	83 ec 04             	sub    $0x4,%esp
80105538:	ff 75 f0             	pushl  -0x10(%ebp)
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	ff 75 ec             	pushl  -0x14(%ebp)
80105541:	e8 8a bb ff ff       	call   801010d0 <filewrite>
80105546:	83 c4 10             	add    $0x10,%esp
}
80105549:	c9                   	leave  
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
80105550:	c9                   	leave  
    return -1;
80105551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105556:	c3                   	ret    
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <sys_close>:

int
sys_close(void)
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
80105565:	89 e5                	mov    %esp,%ebp
80105567:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010556a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010556d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105570:	e8 4b fe ff ff       	call   801053c0 <argfd.constprop.0>
80105575:	85 c0                	test   %eax,%eax
80105577:	78 27                	js     801055a0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105579:	e8 12 eb ff ff       	call   80104090 <myproc>
8010557e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105581:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105584:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010558b:	00 
  fileclose(f);
8010558c:	ff 75 f4             	pushl  -0xc(%ebp)
8010558f:	e8 6c b9 ff ff       	call   80100f00 <fileclose>
  return 0;
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	31 c0                	xor    %eax,%eax
}
80105599:	c9                   	leave  
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
801055a0:	c9                   	leave  
    return -1;
801055a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a6:	c3                   	ret    
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <sys_fstat>:

int
sys_fstat(void)
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055b5:	31 c0                	xor    %eax,%eax
{
801055b7:	89 e5                	mov    %esp,%ebp
801055b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055bc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801055bf:	e8 fc fd ff ff       	call   801053c0 <argfd.constprop.0>
801055c4:	85 c0                	test   %eax,%eax
801055c6:	78 30                	js     801055f8 <sys_fstat+0x48>
801055c8:	83 ec 04             	sub    $0x4,%esp
801055cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055ce:	6a 14                	push   $0x14
801055d0:	50                   	push   %eax
801055d1:	6a 01                	push   $0x1
801055d3:	e8 d8 fc ff ff       	call   801052b0 <argptr>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	85 c0                	test   %eax,%eax
801055dd:	78 19                	js     801055f8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
801055df:	83 ec 08             	sub    $0x8,%esp
801055e2:	ff 75 f4             	pushl  -0xc(%ebp)
801055e5:	ff 75 f0             	pushl  -0x10(%ebp)
801055e8:	e8 f3 b9 ff ff       	call   80100fe0 <filestat>
801055ed:	83 c4 10             	add    $0x10,%esp
}
801055f0:	c9                   	leave  
801055f1:	c3                   	ret    
801055f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055f8:	c9                   	leave  
    return -1;
801055f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fe:	c3                   	ret    
801055ff:	90                   	nop

80105600 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
80105605:	89 e5                	mov    %esp,%ebp
80105607:	57                   	push   %edi
80105608:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105609:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010560c:	53                   	push   %ebx
8010560d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105610:	50                   	push   %eax
80105611:	6a 00                	push   $0x0
80105613:	e8 f8 fc ff ff       	call   80105310 <argstr>
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	85 c0                	test   %eax,%eax
8010561d:	0f 88 ff 00 00 00    	js     80105722 <sys_link+0x122>
80105623:	83 ec 08             	sub    $0x8,%esp
80105626:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105629:	50                   	push   %eax
8010562a:	6a 01                	push   $0x1
8010562c:	e8 df fc ff ff       	call   80105310 <argstr>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	85 c0                	test   %eax,%eax
80105636:	0f 88 e6 00 00 00    	js     80105722 <sys_link+0x122>
    return -1;

  begin_op();
8010563c:	e8 3f dd ff ff       	call   80103380 <begin_op>
  if((ip = namei(old)) == 0){
80105641:	83 ec 0c             	sub    $0xc,%esp
80105644:	ff 75 d4             	pushl  -0x2c(%ebp)
80105647:	e8 24 ca ff ff       	call   80102070 <namei>
8010564c:	83 c4 10             	add    $0x10,%esp
8010564f:	89 c3                	mov    %eax,%ebx
80105651:	85 c0                	test   %eax,%eax
80105653:	0f 84 e8 00 00 00    	je     80105741 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	50                   	push   %eax
8010565d:	e8 3e c1 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010566a:	0f 84 b9 00 00 00    	je     80105729 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105673:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105678:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010567b:	53                   	push   %ebx
8010567c:	e8 5f c0 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
80105681:	89 1c 24             	mov    %ebx,(%esp)
80105684:	e8 f7 c1 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105689:	58                   	pop    %eax
8010568a:	5a                   	pop    %edx
8010568b:	57                   	push   %edi
8010568c:	ff 75 d0             	pushl  -0x30(%ebp)
8010568f:	e8 fc c9 ff ff       	call   80102090 <nameiparent>
80105694:	83 c4 10             	add    $0x10,%esp
80105697:	89 c6                	mov    %eax,%esi
80105699:	85 c0                	test   %eax,%eax
8010569b:	74 5f                	je     801056fc <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	50                   	push   %eax
801056a1:	e8 fa c0 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056a6:	8b 03                	mov    (%ebx),%eax
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	39 06                	cmp    %eax,(%esi)
801056ad:	75 41                	jne    801056f0 <sys_link+0xf0>
801056af:	83 ec 04             	sub    $0x4,%esp
801056b2:	ff 73 04             	pushl  0x4(%ebx)
801056b5:	57                   	push   %edi
801056b6:	56                   	push   %esi
801056b7:	e8 f4 c8 ff ff       	call   80101fb0 <dirlink>
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	85 c0                	test   %eax,%eax
801056c1:	78 2d                	js     801056f0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801056c3:	83 ec 0c             	sub    $0xc,%esp
801056c6:	56                   	push   %esi
801056c7:	e8 74 c3 ff ff       	call   80101a40 <iunlockput>
  iput(ip);
801056cc:	89 1c 24             	mov    %ebx,(%esp)
801056cf:	e8 fc c1 ff ff       	call   801018d0 <iput>

  end_op();
801056d4:	e8 17 dd ff ff       	call   801033f0 <end_op>

  return 0;
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801056de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e1:	5b                   	pop    %ebx
801056e2:	5e                   	pop    %esi
801056e3:	5f                   	pop    %edi
801056e4:	5d                   	pop    %ebp
801056e5:	c3                   	ret    
801056e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	56                   	push   %esi
801056f4:	e8 47 c3 ff ff       	call   80101a40 <iunlockput>
    goto bad;
801056f9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056fc:	83 ec 0c             	sub    $0xc,%esp
801056ff:	53                   	push   %ebx
80105700:	e8 9b c0 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80105705:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010570a:	89 1c 24             	mov    %ebx,(%esp)
8010570d:	e8 ce bf ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105712:	89 1c 24             	mov    %ebx,(%esp)
80105715:	e8 26 c3 ff ff       	call   80101a40 <iunlockput>
  end_op();
8010571a:	e8 d1 dc ff ff       	call   801033f0 <end_op>
  return -1;
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105727:	eb b5                	jmp    801056de <sys_link+0xde>
    iunlockput(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	53                   	push   %ebx
8010572d:	e8 0e c3 ff ff       	call   80101a40 <iunlockput>
    end_op();
80105732:	e8 b9 dc ff ff       	call   801033f0 <end_op>
    return -1;
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573f:	eb 9d                	jmp    801056de <sys_link+0xde>
    end_op();
80105741:	e8 aa dc ff ff       	call   801033f0 <end_op>
    return -1;
80105746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574b:	eb 91                	jmp    801056de <sys_link+0xde>
8010574d:	8d 76 00             	lea    0x0(%esi),%esi

80105750 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105750:	f3 0f 1e fb          	endbr32 
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
80105757:	57                   	push   %edi
80105758:	56                   	push   %esi
80105759:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010575c:	53                   	push   %ebx
8010575d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105762:	83 ec 1c             	sub    $0x1c,%esp
80105765:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105768:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010576c:	77 0a                	ja     80105778 <isdirempty+0x28>
8010576e:	eb 30                	jmp    801057a0 <isdirempty+0x50>
80105770:	83 c3 10             	add    $0x10,%ebx
80105773:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105776:	76 28                	jbe    801057a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105778:	6a 10                	push   $0x10
8010577a:	53                   	push   %ebx
8010577b:	57                   	push   %edi
8010577c:	56                   	push   %esi
8010577d:	e8 1e c3 ff ff       	call   80101aa0 <readi>
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	83 f8 10             	cmp    $0x10,%eax
80105788:	75 23                	jne    801057ad <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010578a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010578f:	74 df                	je     80105770 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105791:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105794:	31 c0                	xor    %eax,%eax
}
80105796:	5b                   	pop    %ebx
80105797:	5e                   	pop    %esi
80105798:	5f                   	pop    %edi
80105799:	5d                   	pop    %ebp
8010579a:	c3                   	ret    
8010579b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010579f:	90                   	nop
801057a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801057a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057a8:	5b                   	pop    %ebx
801057a9:	5e                   	pop    %esi
801057aa:	5f                   	pop    %edi
801057ab:	5d                   	pop    %ebp
801057ac:	c3                   	ret    
      panic("isdirempty: readi");
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	68 00 8b 10 80       	push   $0x80108b00
801057b5:	e8 d6 ab ff ff       	call   80100390 <panic>
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057c0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	57                   	push   %edi
801057c8:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801057c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057cc:	53                   	push   %ebx
801057cd:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801057d0:	50                   	push   %eax
801057d1:	6a 00                	push   $0x0
801057d3:	e8 38 fb ff ff       	call   80105310 <argstr>
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	85 c0                	test   %eax,%eax
801057dd:	0f 88 5d 01 00 00    	js     80105940 <sys_unlink+0x180>
    return -1;

  begin_op();
801057e3:	e8 98 db ff ff       	call   80103380 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	53                   	push   %ebx
801057ef:	ff 75 c0             	pushl  -0x40(%ebp)
801057f2:	e8 99 c8 ff ff       	call   80102090 <nameiparent>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	89 c6                	mov    %eax,%esi
801057fc:	85 c0                	test   %eax,%eax
801057fe:	0f 84 43 01 00 00    	je     80105947 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	50                   	push   %eax
80105808:	e8 93 bf ff ff       	call   801017a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010580d:	58                   	pop    %eax
8010580e:	5a                   	pop    %edx
8010580f:	68 7d 84 10 80       	push   $0x8010847d
80105814:	53                   	push   %ebx
80105815:	e8 b6 c4 ff ff       	call   80101cd0 <namecmp>
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 84 db 00 00 00    	je     80105900 <sys_unlink+0x140>
80105825:	83 ec 08             	sub    $0x8,%esp
80105828:	68 7c 84 10 80       	push   $0x8010847c
8010582d:	53                   	push   %ebx
8010582e:	e8 9d c4 ff ff       	call   80101cd0 <namecmp>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	0f 84 c2 00 00 00    	je     80105900 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010583e:	83 ec 04             	sub    $0x4,%esp
80105841:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105844:	50                   	push   %eax
80105845:	53                   	push   %ebx
80105846:	56                   	push   %esi
80105847:	e8 a4 c4 ff ff       	call   80101cf0 <dirlookup>
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	89 c3                	mov    %eax,%ebx
80105851:	85 c0                	test   %eax,%eax
80105853:	0f 84 a7 00 00 00    	je     80105900 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	50                   	push   %eax
8010585d:	e8 3e bf ff ff       	call   801017a0 <ilock>

  if(ip->nlink < 1)
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010586a:	0f 8e f3 00 00 00    	jle    80105963 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105870:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105875:	74 69                	je     801058e0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105877:	83 ec 04             	sub    $0x4,%esp
8010587a:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010587d:	6a 10                	push   $0x10
8010587f:	6a 00                	push   $0x0
80105881:	57                   	push   %edi
80105882:	e8 f9 f6 ff ff       	call   80104f80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105887:	6a 10                	push   $0x10
80105889:	ff 75 c4             	pushl  -0x3c(%ebp)
8010588c:	57                   	push   %edi
8010588d:	56                   	push   %esi
8010588e:	e8 0d c3 ff ff       	call   80101ba0 <writei>
80105893:	83 c4 20             	add    $0x20,%esp
80105896:	83 f8 10             	cmp    $0x10,%eax
80105899:	0f 85 b7 00 00 00    	jne    80105956 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010589f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a4:	74 7a                	je     80105920 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801058a6:	83 ec 0c             	sub    $0xc,%esp
801058a9:	56                   	push   %esi
801058aa:	e8 91 c1 ff ff       	call   80101a40 <iunlockput>

  ip->nlink--;
801058af:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058b4:	89 1c 24             	mov    %ebx,(%esp)
801058b7:	e8 24 be ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
801058bc:	89 1c 24             	mov    %ebx,(%esp)
801058bf:	e8 7c c1 ff ff       	call   80101a40 <iunlockput>

  end_op();
801058c4:	e8 27 db ff ff       	call   801033f0 <end_op>

  return 0;
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801058ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d1:	5b                   	pop    %ebx
801058d2:	5e                   	pop    %esi
801058d3:	5f                   	pop    %edi
801058d4:	5d                   	pop    %ebp
801058d5:	c3                   	ret    
801058d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 67 fe ff ff       	call   80105750 <isdirempty>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	85 c0                	test   %eax,%eax
801058ee:	75 87                	jne    80105877 <sys_unlink+0xb7>
    iunlockput(ip);
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	53                   	push   %ebx
801058f4:	e8 47 c1 ff ff       	call   80101a40 <iunlockput>
    goto bad;
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	56                   	push   %esi
80105904:	e8 37 c1 ff ff       	call   80101a40 <iunlockput>
  end_op();
80105909:	e8 e2 da ff ff       	call   801033f0 <end_op>
  return -1;
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb b6                	jmp    801058ce <sys_unlink+0x10e>
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
    iupdate(dp);
80105920:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105923:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105928:	56                   	push   %esi
80105929:	e8 b2 bd ff ff       	call   801016e0 <iupdate>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	e9 70 ff ff ff       	jmp    801058a6 <sys_unlink+0xe6>
80105936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105945:	eb 87                	jmp    801058ce <sys_unlink+0x10e>
    end_op();
80105947:	e8 a4 da ff ff       	call   801033f0 <end_op>
    return -1;
8010594c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105951:	e9 78 ff ff ff       	jmp    801058ce <sys_unlink+0x10e>
    panic("unlink: writei");
80105956:	83 ec 0c             	sub    $0xc,%esp
80105959:	68 91 84 10 80       	push   $0x80108491
8010595e:	e8 2d aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105963:	83 ec 0c             	sub    $0xc,%esp
80105966:	68 7f 84 10 80       	push   $0x8010847f
8010596b:	e8 20 aa ff ff       	call   80100390 <panic>

80105970 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	57                   	push   %edi
80105978:	56                   	push   %esi
80105979:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010597a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
8010597d:	83 ec 34             	sub    $0x34,%esp
80105980:	8b 45 0c             	mov    0xc(%ebp),%eax
80105983:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105986:	53                   	push   %ebx
{
80105987:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
8010598a:	ff 75 08             	pushl  0x8(%ebp)
{
8010598d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105990:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105993:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105996:	e8 f5 c6 ff ff       	call   80102090 <nameiparent>
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	85 c0                	test   %eax,%eax
801059a0:	0f 84 3a 01 00 00    	je     80105ae0 <create+0x170>
    return 0;
  ilock(dp);
801059a6:	83 ec 0c             	sub    $0xc,%esp
801059a9:	89 c6                	mov    %eax,%esi
801059ab:	50                   	push   %eax
801059ac:	e8 ef bd ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801059b1:	83 c4 0c             	add    $0xc,%esp
801059b4:	6a 00                	push   $0x0
801059b6:	53                   	push   %ebx
801059b7:	56                   	push   %esi
801059b8:	e8 33 c3 ff ff       	call   80101cf0 <dirlookup>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	89 c7                	mov    %eax,%edi
801059c2:	85 c0                	test   %eax,%eax
801059c4:	74 4a                	je     80105a10 <create+0xa0>
    iunlockput(dp);
801059c6:	83 ec 0c             	sub    $0xc,%esp
801059c9:	56                   	push   %esi
801059ca:	e8 71 c0 ff ff       	call   80101a40 <iunlockput>
    ilock(ip);
801059cf:	89 3c 24             	mov    %edi,(%esp)
801059d2:	e8 c9 bd ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801059d7:	83 c4 10             	add    $0x10,%esp
801059da:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801059df:	75 17                	jne    801059f8 <create+0x88>
801059e1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801059e6:	75 10                	jne    801059f8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059eb:	89 f8                	mov    %edi,%eax
801059ed:	5b                   	pop    %ebx
801059ee:	5e                   	pop    %esi
801059ef:	5f                   	pop    %edi
801059f0:	5d                   	pop    %ebp
801059f1:	c3                   	ret    
801059f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	57                   	push   %edi
    return 0;
801059fc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801059fe:	e8 3d c0 ff ff       	call   80101a40 <iunlockput>
    return 0;
80105a03:	83 c4 10             	add    $0x10,%esp
}
80105a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a09:	89 f8                	mov    %edi,%eax
80105a0b:	5b                   	pop    %ebx
80105a0c:	5e                   	pop    %esi
80105a0d:	5f                   	pop    %edi
80105a0e:	5d                   	pop    %ebp
80105a0f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105a10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a14:	83 ec 08             	sub    $0x8,%esp
80105a17:	50                   	push   %eax
80105a18:	ff 36                	pushl  (%esi)
80105a1a:	e8 01 bc ff ff       	call   80101620 <ialloc>
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	89 c7                	mov    %eax,%edi
80105a24:	85 c0                	test   %eax,%eax
80105a26:	0f 84 cd 00 00 00    	je     80105af9 <create+0x189>
  ilock(ip);
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	50                   	push   %eax
80105a30:	e8 6b bd ff ff       	call   801017a0 <ilock>
  ip->major = major;
80105a35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105a39:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105a3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105a41:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105a45:	b8 01 00 00 00       	mov    $0x1,%eax
80105a4a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105a4e:	89 3c 24             	mov    %edi,(%esp)
80105a51:	e8 8a bc ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a5e:	74 30                	je     80105a90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105a60:	83 ec 04             	sub    $0x4,%esp
80105a63:	ff 77 04             	pushl  0x4(%edi)
80105a66:	53                   	push   %ebx
80105a67:	56                   	push   %esi
80105a68:	e8 43 c5 ff ff       	call   80101fb0 <dirlink>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 78                	js     80105aec <create+0x17c>
  iunlockput(dp);
80105a74:	83 ec 0c             	sub    $0xc,%esp
80105a77:	56                   	push   %esi
80105a78:	e8 c3 bf ff ff       	call   80101a40 <iunlockput>
  return ip;
80105a7d:	83 c4 10             	add    $0x10,%esp
}
80105a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a83:	89 f8                	mov    %edi,%eax
80105a85:	5b                   	pop    %ebx
80105a86:	5e                   	pop    %esi
80105a87:	5f                   	pop    %edi
80105a88:	5d                   	pop    %ebp
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105a90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105a93:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105a98:	56                   	push   %esi
80105a99:	e8 42 bc ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a9e:	83 c4 0c             	add    $0xc,%esp
80105aa1:	ff 77 04             	pushl  0x4(%edi)
80105aa4:	68 7d 84 10 80       	push   $0x8010847d
80105aa9:	57                   	push   %edi
80105aaa:	e8 01 c5 ff ff       	call   80101fb0 <dirlink>
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	85 c0                	test   %eax,%eax
80105ab4:	78 18                	js     80105ace <create+0x15e>
80105ab6:	83 ec 04             	sub    $0x4,%esp
80105ab9:	ff 76 04             	pushl  0x4(%esi)
80105abc:	68 7c 84 10 80       	push   $0x8010847c
80105ac1:	57                   	push   %edi
80105ac2:	e8 e9 c4 ff ff       	call   80101fb0 <dirlink>
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	85 c0                	test   %eax,%eax
80105acc:	79 92                	jns    80105a60 <create+0xf0>
      panic("create dots");
80105ace:	83 ec 0c             	sub    $0xc,%esp
80105ad1:	68 21 8b 10 80       	push   $0x80108b21
80105ad6:	e8 b5 a8 ff ff       	call   80100390 <panic>
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
}
80105ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ae3:	31 ff                	xor    %edi,%edi
}
80105ae5:	5b                   	pop    %ebx
80105ae6:	89 f8                	mov    %edi,%eax
80105ae8:	5e                   	pop    %esi
80105ae9:	5f                   	pop    %edi
80105aea:	5d                   	pop    %ebp
80105aeb:	c3                   	ret    
    panic("create: dirlink");
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	68 2d 8b 10 80       	push   $0x80108b2d
80105af4:	e8 97 a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	68 12 8b 10 80       	push   $0x80108b12
80105b01:	e8 8a a8 ff ff       	call   80100390 <panic>
80105b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <sys_open>:

int
sys_open(void)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	57                   	push   %edi
80105b18:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b19:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b1c:	53                   	push   %ebx
80105b1d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b20:	50                   	push   %eax
80105b21:	6a 00                	push   $0x0
80105b23:	e8 e8 f7 ff ff       	call   80105310 <argstr>
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	85 c0                	test   %eax,%eax
80105b2d:	0f 88 8a 00 00 00    	js     80105bbd <sys_open+0xad>
80105b33:	83 ec 08             	sub    $0x8,%esp
80105b36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 01                	push   $0x1
80105b3c:	e8 1f f7 ff ff       	call   80105260 <argint>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 75                	js     80105bbd <sys_open+0xad>
    return -1;

  begin_op();
80105b48:	e8 33 d8 ff ff       	call   80103380 <begin_op>

  if(omode & O_CREATE){
80105b4d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b51:	75 75                	jne    80105bc8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b53:	83 ec 0c             	sub    $0xc,%esp
80105b56:	ff 75 e0             	pushl  -0x20(%ebp)
80105b59:	e8 12 c5 ff ff       	call   80102070 <namei>
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	89 c6                	mov    %eax,%esi
80105b63:	85 c0                	test   %eax,%eax
80105b65:	74 78                	je     80105bdf <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105b67:	83 ec 0c             	sub    $0xc,%esp
80105b6a:	50                   	push   %eax
80105b6b:	e8 30 bc ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b70:	83 c4 10             	add    $0x10,%esp
80105b73:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b78:	0f 84 ba 00 00 00    	je     80105c38 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b7e:	e8 bd b2 ff ff       	call   80100e40 <filealloc>
80105b83:	89 c7                	mov    %eax,%edi
80105b85:	85 c0                	test   %eax,%eax
80105b87:	74 23                	je     80105bac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b89:	e8 02 e5 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b8e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b94:	85 d2                	test   %edx,%edx
80105b96:	74 58                	je     80105bf0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105b98:	83 c3 01             	add    $0x1,%ebx
80105b9b:	83 fb 10             	cmp    $0x10,%ebx
80105b9e:	75 f0                	jne    80105b90 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	57                   	push   %edi
80105ba4:	e8 57 b3 ff ff       	call   80100f00 <fileclose>
80105ba9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	56                   	push   %esi
80105bb0:	e8 8b be ff ff       	call   80101a40 <iunlockput>
    end_op();
80105bb5:	e8 36 d8 ff ff       	call   801033f0 <end_op>
    return -1;
80105bba:	83 c4 10             	add    $0x10,%esp
80105bbd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bc2:	eb 65                	jmp    80105c29 <sys_open+0x119>
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105bc8:	6a 00                	push   $0x0
80105bca:	6a 00                	push   $0x0
80105bcc:	6a 02                	push   $0x2
80105bce:	ff 75 e0             	pushl  -0x20(%ebp)
80105bd1:	e8 9a fd ff ff       	call   80105970 <create>
    if(ip == 0){
80105bd6:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105bd9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105bdb:	85 c0                	test   %eax,%eax
80105bdd:	75 9f                	jne    80105b7e <sys_open+0x6e>
      end_op();
80105bdf:	e8 0c d8 ff ff       	call   801033f0 <end_op>
      return -1;
80105be4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be9:	eb 3e                	jmp    80105c29 <sys_open+0x119>
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
  }
  iunlock(ip);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105bf3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bf7:	56                   	push   %esi
80105bf8:	e8 83 bc ff ff       	call   80101880 <iunlock>
  end_op();
80105bfd:	e8 ee d7 ff ff       	call   801033f0 <end_op>

  f->type = FD_INODE;
80105c02:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c0b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c0e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105c11:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105c13:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c1a:	f7 d0                	not    %eax
80105c1c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c1f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105c22:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c25:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2c:	89 d8                	mov    %ebx,%eax
80105c2e:	5b                   	pop    %ebx
80105c2f:	5e                   	pop    %esi
80105c30:	5f                   	pop    %edi
80105c31:	5d                   	pop    %ebp
80105c32:	c3                   	ret    
80105c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c37:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c3b:	85 c9                	test   %ecx,%ecx
80105c3d:	0f 84 3b ff ff ff    	je     80105b7e <sys_open+0x6e>
80105c43:	e9 64 ff ff ff       	jmp    80105bac <sys_open+0x9c>
80105c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4f:	90                   	nop

80105c50 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c5a:	e8 21 d7 ff ff       	call   80103380 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c5f:	83 ec 08             	sub    $0x8,%esp
80105c62:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c65:	50                   	push   %eax
80105c66:	6a 00                	push   $0x0
80105c68:	e8 a3 f6 ff ff       	call   80105310 <argstr>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	78 2c                	js     80105ca0 <sys_mkdir+0x50>
80105c74:	6a 00                	push   $0x0
80105c76:	6a 00                	push   $0x0
80105c78:	6a 01                	push   $0x1
80105c7a:	ff 75 f4             	pushl  -0xc(%ebp)
80105c7d:	e8 ee fc ff ff       	call   80105970 <create>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 17                	je     80105ca0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	50                   	push   %eax
80105c8d:	e8 ae bd ff ff       	call   80101a40 <iunlockput>
  end_op();
80105c92:	e8 59 d7 ff ff       	call   801033f0 <end_op>
  return 0;
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	31 c0                	xor    %eax,%eax
}
80105c9c:	c9                   	leave  
80105c9d:	c3                   	ret    
80105c9e:	66 90                	xchg   %ax,%ax
    end_op();
80105ca0:	e8 4b d7 ff ff       	call   801033f0 <end_op>
    return -1;
80105ca5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105caa:	c9                   	leave  
80105cab:	c3                   	ret    
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_mknod>:

int
sys_mknod(void)
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cba:	e8 c1 d6 ff ff       	call   80103380 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105cbf:	83 ec 08             	sub    $0x8,%esp
80105cc2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cc5:	50                   	push   %eax
80105cc6:	6a 00                	push   $0x0
80105cc8:	e8 43 f6 ff ff       	call   80105310 <argstr>
80105ccd:	83 c4 10             	add    $0x10,%esp
80105cd0:	85 c0                	test   %eax,%eax
80105cd2:	78 5c                	js     80105d30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105cd4:	83 ec 08             	sub    $0x8,%esp
80105cd7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cda:	50                   	push   %eax
80105cdb:	6a 01                	push   $0x1
80105cdd:	e8 7e f5 ff ff       	call   80105260 <argint>
  if((argstr(0, &path)) < 0 ||
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 47                	js     80105d30 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ce9:	83 ec 08             	sub    $0x8,%esp
80105cec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cef:	50                   	push   %eax
80105cf0:	6a 02                	push   $0x2
80105cf2:	e8 69 f5 ff ff       	call   80105260 <argint>
     argint(1, &major) < 0 ||
80105cf7:	83 c4 10             	add    $0x10,%esp
80105cfa:	85 c0                	test   %eax,%eax
80105cfc:	78 32                	js     80105d30 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cfe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105d02:	50                   	push   %eax
80105d03:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105d07:	50                   	push   %eax
80105d08:	6a 03                	push   $0x3
80105d0a:	ff 75 ec             	pushl  -0x14(%ebp)
80105d0d:	e8 5e fc ff ff       	call   80105970 <create>
     argint(2, &minor) < 0 ||
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	74 17                	je     80105d30 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	50                   	push   %eax
80105d1d:	e8 1e bd ff ff       	call   80101a40 <iunlockput>
  end_op();
80105d22:	e8 c9 d6 ff ff       	call   801033f0 <end_op>
  return 0;
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	31 c0                	xor    %eax,%eax
}
80105d2c:	c9                   	leave  
80105d2d:	c3                   	ret    
80105d2e:	66 90                	xchg   %ax,%ax
    end_op();
80105d30:	e8 bb d6 ff ff       	call   801033f0 <end_op>
    return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d3a:	c9                   	leave  
80105d3b:	c3                   	ret    
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_chdir>:

int
sys_chdir(void)
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	56                   	push   %esi
80105d48:	53                   	push   %ebx
80105d49:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d4c:	e8 3f e3 ff ff       	call   80104090 <myproc>
80105d51:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d53:	e8 28 d6 ff ff       	call   80103380 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d58:	83 ec 08             	sub    $0x8,%esp
80105d5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d5e:	50                   	push   %eax
80105d5f:	6a 00                	push   $0x0
80105d61:	e8 aa f5 ff ff       	call   80105310 <argstr>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	78 73                	js     80105de0 <sys_chdir+0xa0>
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	ff 75 f4             	pushl  -0xc(%ebp)
80105d73:	e8 f8 c2 ff ff       	call   80102070 <namei>
80105d78:	83 c4 10             	add    $0x10,%esp
80105d7b:	89 c3                	mov    %eax,%ebx
80105d7d:	85 c0                	test   %eax,%eax
80105d7f:	74 5f                	je     80105de0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d81:	83 ec 0c             	sub    $0xc,%esp
80105d84:	50                   	push   %eax
80105d85:	e8 16 ba ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d92:	75 2c                	jne    80105dc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d94:	83 ec 0c             	sub    $0xc,%esp
80105d97:	53                   	push   %ebx
80105d98:	e8 e3 ba ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105d9d:	58                   	pop    %eax
80105d9e:	ff 76 68             	pushl  0x68(%esi)
80105da1:	e8 2a bb ff ff       	call   801018d0 <iput>
  end_op();
80105da6:	e8 45 d6 ff ff       	call   801033f0 <end_op>
  curproc->cwd = ip;
80105dab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	31 c0                	xor    %eax,%eax
}
80105db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105db6:	5b                   	pop    %ebx
80105db7:	5e                   	pop    %esi
80105db8:	5d                   	pop    %ebp
80105db9:	c3                   	ret    
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	53                   	push   %ebx
80105dc4:	e8 77 bc ff ff       	call   80101a40 <iunlockput>
    end_op();
80105dc9:	e8 22 d6 ff ff       	call   801033f0 <end_op>
    return -1;
80105dce:	83 c4 10             	add    $0x10,%esp
80105dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd6:	eb db                	jmp    80105db3 <sys_chdir+0x73>
80105dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop
    end_op();
80105de0:	e8 0b d6 ff ff       	call   801033f0 <end_op>
    return -1;
80105de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dea:	eb c7                	jmp    80105db3 <sys_chdir+0x73>
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105df0 <sys_exec>:

int
sys_exec(void)
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105df9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dff:	53                   	push   %ebx
80105e00:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e06:	50                   	push   %eax
80105e07:	6a 00                	push   $0x0
80105e09:	e8 02 f5 ff ff       	call   80105310 <argstr>
80105e0e:	83 c4 10             	add    $0x10,%esp
80105e11:	85 c0                	test   %eax,%eax
80105e13:	0f 88 8b 00 00 00    	js     80105ea4 <sys_exec+0xb4>
80105e19:	83 ec 08             	sub    $0x8,%esp
80105e1c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e22:	50                   	push   %eax
80105e23:	6a 01                	push   $0x1
80105e25:	e8 36 f4 ff ff       	call   80105260 <argint>
80105e2a:	83 c4 10             	add    $0x10,%esp
80105e2d:	85 c0                	test   %eax,%eax
80105e2f:	78 73                	js     80105ea4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e31:	83 ec 04             	sub    $0x4,%esp
80105e34:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105e3a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e3c:	68 80 00 00 00       	push   $0x80
80105e41:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e47:	6a 00                	push   $0x0
80105e49:	50                   	push   %eax
80105e4a:	e8 31 f1 ff ff       	call   80104f80 <memset>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e58:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e5e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e65:	83 ec 08             	sub    $0x8,%esp
80105e68:	57                   	push   %edi
80105e69:	01 f0                	add    %esi,%eax
80105e6b:	50                   	push   %eax
80105e6c:	e8 4f f3 ff ff       	call   801051c0 <fetchint>
80105e71:	83 c4 10             	add    $0x10,%esp
80105e74:	85 c0                	test   %eax,%eax
80105e76:	78 2c                	js     80105ea4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105e78:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e7e:	85 c0                	test   %eax,%eax
80105e80:	74 36                	je     80105eb8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e82:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e88:	83 ec 08             	sub    $0x8,%esp
80105e8b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e8e:	52                   	push   %edx
80105e8f:	50                   	push   %eax
80105e90:	e8 6b f3 ff ff       	call   80105200 <fetchstr>
80105e95:	83 c4 10             	add    $0x10,%esp
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	78 08                	js     80105ea4 <sys_exec+0xb4>
  for(i=0;; i++){
80105e9c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e9f:	83 fb 20             	cmp    $0x20,%ebx
80105ea2:	75 b4                	jne    80105e58 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eac:	5b                   	pop    %ebx
80105ead:	5e                   	pop    %esi
80105eae:	5f                   	pop    %edi
80105eaf:	5d                   	pop    %ebp
80105eb0:	c3                   	ret    
80105eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105eb8:	83 ec 08             	sub    $0x8,%esp
80105ebb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105ec1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ec8:	00 00 00 00 
  return exec(path, argv);
80105ecc:	50                   	push   %eax
80105ecd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105ed3:	e8 a8 ab ff ff       	call   80100a80 <exec>
80105ed8:	83 c4 10             	add    $0x10,%esp
}
80105edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ede:	5b                   	pop    %ebx
80105edf:	5e                   	pop    %esi
80105ee0:	5f                   	pop    %edi
80105ee1:	5d                   	pop    %ebp
80105ee2:	c3                   	ret    
80105ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ef0 <sys_pipe>:

int
sys_pipe(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	57                   	push   %edi
80105ef8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ef9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105efc:	53                   	push   %ebx
80105efd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f00:	6a 08                	push   $0x8
80105f02:	50                   	push   %eax
80105f03:	6a 00                	push   $0x0
80105f05:	e8 a6 f3 ff ff       	call   801052b0 <argptr>
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	78 4e                	js     80105f5f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f11:	83 ec 08             	sub    $0x8,%esp
80105f14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f17:	50                   	push   %eax
80105f18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f1b:	50                   	push   %eax
80105f1c:	e8 1f db ff ff       	call   80103a40 <pipealloc>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	78 37                	js     80105f5f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f28:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f2b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f2d:	e8 5e e1 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105f38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f3c:	85 f6                	test   %esi,%esi
80105f3e:	74 30                	je     80105f70 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105f40:	83 c3 01             	add    $0x1,%ebx
80105f43:	83 fb 10             	cmp    $0x10,%ebx
80105f46:	75 f0                	jne    80105f38 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f4e:	e8 ad af ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
80105f53:	58                   	pop    %eax
80105f54:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f57:	e8 a4 af ff ff       	call   80100f00 <fileclose>
    return -1;
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f64:	eb 5b                	jmp    80105fc1 <sys_pipe+0xd1>
80105f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105f70:	8d 73 08             	lea    0x8(%ebx),%esi
80105f73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f7a:	e8 11 e1 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f7f:	31 d2                	xor    %edx,%edx
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f8c:	85 c9                	test   %ecx,%ecx
80105f8e:	74 20                	je     80105fb0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f90:	83 c2 01             	add    $0x1,%edx
80105f93:	83 fa 10             	cmp    $0x10,%edx
80105f96:	75 f0                	jne    80105f88 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f98:	e8 f3 e0 ff ff       	call   80104090 <myproc>
80105f9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fa4:	00 
80105fa5:	eb a1                	jmp    80105f48 <sys_pipe+0x58>
80105fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105fb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105fb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fbc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105fbf:	31 c0                	xor    %eax,%eax
}
80105fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc4:	5b                   	pop    %ebx
80105fc5:	5e                   	pop    %esi
80105fc6:	5f                   	pop    %edi
80105fc7:	5d                   	pop    %ebp
80105fc8:	c3                   	ret    
80105fc9:	66 90                	xchg   %ax,%ax
80105fcb:	66 90                	xchg   %ax,%ax
80105fcd:	66 90                	xchg   %ax,%ax
80105fcf:	90                   	nop

80105fd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
  return fork();
80105fd4:	e9 87 e2 ff ff       	jmp    80104260 <fork>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exit>:
}

int
sys_exit(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fea:	e8 f1 e5 ff ff       	call   801045e0 <exit>
  return 0;  // not reached
}
80105fef:	31 c0                	xor    %eax,%eax
80105ff1:	c9                   	leave  
80105ff2:	c3                   	ret    
80105ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106000 <sys_wait>:

int
sys_wait(void)
{
80106000:	f3 0f 1e fb          	endbr32 
  return wait();
80106004:	e9 57 e8 ff ff       	jmp    80104860 <wait>
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <sys_kill>:
}

int
sys_kill(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010601a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010601d:	50                   	push   %eax
8010601e:	6a 00                	push   $0x0
80106020:	e8 3b f2 ff ff       	call   80105260 <argint>
80106025:	83 c4 10             	add    $0x10,%esp
80106028:	85 c0                	test   %eax,%eax
8010602a:	78 14                	js     80106040 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010602c:	83 ec 0c             	sub    $0xc,%esp
8010602f:	ff 75 f4             	pushl  -0xc(%ebp)
80106032:	e8 d9 e9 ff ff       	call   80104a10 <kill>
80106037:	83 c4 10             	add    $0x10,%esp
}
8010603a:	c9                   	leave  
8010603b:	c3                   	ret    
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106040:	c9                   	leave  
    return -1;
80106041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106046:	c3                   	ret    
80106047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_getpid>:

int
sys_getpid(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010605a:	e8 31 e0 ff ff       	call   80104090 <myproc>
8010605f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106062:	c9                   	leave  
80106063:	c3                   	ret    
80106064:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <sys_sbrk>:

int
sys_sbrk(void)
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106078:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010607b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010607e:	50                   	push   %eax
8010607f:	6a 00                	push   $0x0
80106081:	e8 da f1 ff ff       	call   80105260 <argint>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	85 c0                	test   %eax,%eax
8010608b:	78 23                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010608d:	e8 fe df ff ff       	call   80104090 <myproc>
  if(growproc(n) < 0)
80106092:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106095:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106097:	ff 75 f4             	pushl  -0xc(%ebp)
8010609a:	e8 21 e1 ff ff       	call   801041c0 <growproc>
8010609f:	83 c4 10             	add    $0x10,%esp
801060a2:	85 c0                	test   %eax,%eax
801060a4:	78 0a                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060a6:	89 d8                	mov    %ebx,%eax
801060a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060ab:	c9                   	leave  
801060ac:	c3                   	ret    
801060ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060b5:	eb ef                	jmp    801060a6 <sys_sbrk+0x36>
801060b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060be:	66 90                	xchg   %ax,%ax

801060c0 <sys_sleep>:

int
sys_sleep(void)
{
801060c0:	f3 0f 1e fb          	endbr32 
801060c4:	55                   	push   %ebp
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801060c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060ce:	50                   	push   %eax
801060cf:	6a 00                	push   $0x0
801060d1:	e8 8a f1 ff ff       	call   80105260 <argint>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	0f 88 86 00 00 00    	js     80106167 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060e1:	83 ec 0c             	sub    $0xc,%esp
801060e4:	68 a0 03 19 80       	push   $0x801903a0
801060e9:	e8 82 ed ff ff       	call   80104e70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801060f1:	8b 1d e0 0b 19 80    	mov    0x80190be0,%ebx
  while(ticks - ticks0 < n){
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	85 d2                	test   %edx,%edx
801060fc:	75 23                	jne    80106121 <sys_sleep+0x61>
801060fe:	eb 50                	jmp    80106150 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106100:	83 ec 08             	sub    $0x8,%esp
80106103:	68 a0 03 19 80       	push   $0x801903a0
80106108:	68 e0 0b 19 80       	push   $0x80190be0
8010610d:	e8 8e e6 ff ff       	call   801047a0 <sleep>
  while(ticks - ticks0 < n){
80106112:	a1 e0 0b 19 80       	mov    0x80190be0,%eax
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	29 d8                	sub    %ebx,%eax
8010611c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010611f:	73 2f                	jae    80106150 <sys_sleep+0x90>
    if(myproc()->killed){
80106121:	e8 6a df ff ff       	call   80104090 <myproc>
80106126:	8b 40 24             	mov    0x24(%eax),%eax
80106129:	85 c0                	test   %eax,%eax
8010612b:	74 d3                	je     80106100 <sys_sleep+0x40>
      release(&tickslock);
8010612d:	83 ec 0c             	sub    $0xc,%esp
80106130:	68 a0 03 19 80       	push   $0x801903a0
80106135:	e8 f6 ed ff ff       	call   80104f30 <release>
  }
  release(&tickslock);
  return 0;
}
8010613a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 a0 03 19 80       	push   $0x801903a0
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
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	53                   	push   %ebx
80106178:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010617b:	68 a0 03 19 80       	push   $0x801903a0
80106180:	e8 eb ec ff ff       	call   80104e70 <acquire>
  xticks = ticks;
80106185:	8b 1d e0 0b 19 80    	mov    0x80190be0,%ebx
  release(&tickslock);
8010618b:	c7 04 24 a0 03 19 80 	movl   $0x801903a0,(%esp)
80106192:	e8 99 ed ff ff       	call   80104f30 <release>
  return xticks;
}
80106197:	89 d8                	mov    %ebx,%eax
80106199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010619c:	c9                   	leave  
8010619d:	c3                   	ret    
8010619e:	66 90                	xchg   %ax,%ax

801061a0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801061aa:	e8 e1 de ff ff       	call   80104090 <myproc>
801061af:	89 c2                	mov    %eax,%edx
801061b1:	b8 10 00 00 00       	mov    $0x10,%eax
801061b6:	2b 82 80 00 00 00    	sub    0x80(%edx),%eax
}
801061bc:	c9                   	leave  
801061bd:	c3                   	ret    
801061be:	66 90                	xchg   %ax,%ax

801061c0 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
  return getTotalFreePages();
801061c4:	e9 b7 e9 ff ff       	jmp    80104b80 <getTotalFreePages>

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
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061f5:	31 c0                	xor    %eax,%eax
{
801061f7:	89 e5                	mov    %esp,%ebp
801061f9:	83 ec 08             	sub    $0x8,%esp
801061fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106200:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106207:	c7 04 c5 e2 03 19 80 	movl   $0x8e000008,-0x7fe6fc1e(,%eax,8)
8010620e:	08 00 00 8e 
80106212:	66 89 14 c5 e0 03 19 	mov    %dx,-0x7fe6fc20(,%eax,8)
80106219:	80 
8010621a:	c1 ea 10             	shr    $0x10,%edx
8010621d:	66 89 14 c5 e6 03 19 	mov    %dx,-0x7fe6fc1a(,%eax,8)
80106224:	80 
  for(i = 0; i < 256; i++)
80106225:	83 c0 01             	add    $0x1,%eax
80106228:	3d 00 01 00 00       	cmp    $0x100,%eax
8010622d:	75 d1                	jne    80106200 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010622f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106232:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106237:	c7 05 e2 05 19 80 08 	movl   $0xef000008,0x801905e2
8010623e:	00 00 ef 
  initlock(&tickslock, "time");
80106241:	68 3d 8b 10 80       	push   $0x80108b3d
80106246:	68 a0 03 19 80       	push   $0x801903a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010624b:	66 a3 e0 05 19 80    	mov    %ax,0x801905e0
80106251:	c1 e8 10             	shr    $0x10,%eax
80106254:	66 a3 e6 05 19 80    	mov    %ax,0x801905e6
  initlock(&tickslock, "time");
8010625a:	e8 91 ea ff ff       	call   80104cf0 <initlock>
}
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	c9                   	leave  
80106263:	c3                   	ret    
80106264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010626f:	90                   	nop

80106270 <idtinit>:

void
idtinit(void)
{
80106270:	f3 0f 1e fb          	endbr32 
80106274:	55                   	push   %ebp
  pd[0] = size-1;
80106275:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010627a:	89 e5                	mov    %esp,%ebp
8010627c:	83 ec 10             	sub    $0x10,%esp
8010627f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106283:	b8 e0 03 19 80       	mov    $0x801903e0,%eax
80106288:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010628c:	c1 e8 10             	shr    $0x10,%eax
8010628f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106293:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106296:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106299:	c9                   	leave  
8010629a:	c3                   	ret    
8010629b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010629f:	90                   	nop

801062a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062a0:	f3 0f 1e fb          	endbr32 
801062a4:	55                   	push   %ebp
801062a5:	89 e5                	mov    %esp,%ebp
801062a7:	57                   	push   %edi
801062a8:	56                   	push   %esi
801062a9:	53                   	push   %ebx
801062aa:	83 ec 1c             	sub    $0x1c,%esp
801062ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("at trap");
  struct proc* curproc = myproc();
801062b0:	e8 db dd ff ff       	call   80104090 <myproc>
801062b5:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
801062b7:	8b 43 30             	mov    0x30(%ebx),%eax
801062ba:	83 f8 40             	cmp    $0x40,%eax
801062bd:	0f 84 ed 00 00 00    	je     801063b0 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062c3:	83 e8 0e             	sub    $0xe,%eax
801062c6:	83 f8 31             	cmp    $0x31,%eax
801062c9:	77 08                	ja     801062d3 <trap+0x33>
801062cb:	3e ff 24 85 e4 8b 10 	notrack jmp *-0x7fef741c(,%eax,4)
801062d2:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062d3:	e8 b8 dd ff ff       	call   80104090 <myproc>
801062d8:	85 c0                	test   %eax,%eax
801062da:	0f 84 e2 01 00 00    	je     801064c2 <trap+0x222>
801062e0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062e4:	0f 84 d8 01 00 00    	je     801064c2 <trap+0x222>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062ea:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ed:	8b 53 38             	mov    0x38(%ebx),%edx
801062f0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801062f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801062f6:	e8 75 dd ff ff       	call   80104070 <cpuid>
801062fb:	8b 73 30             	mov    0x30(%ebx),%esi
801062fe:	89 c7                	mov    %eax,%edi
80106300:	8b 43 34             	mov    0x34(%ebx),%eax
80106303:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106306:	e8 85 dd ff ff       	call   80104090 <myproc>
8010630b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010630e:	e8 7d dd ff ff       	call   80104090 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106313:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106316:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106319:	51                   	push   %ecx
8010631a:	52                   	push   %edx
8010631b:	57                   	push   %edi
8010631c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010631f:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106320:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106323:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106326:	56                   	push   %esi
80106327:	ff 70 10             	pushl  0x10(%eax)
8010632a:	68 a0 8b 10 80       	push   $0x80108ba0
8010632f:	e8 7c a3 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106334:	83 c4 20             	add    $0x20,%esp
80106337:	e8 54 dd ff ff       	call   80104090 <myproc>
8010633c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106343:	e8 48 dd ff ff       	call   80104090 <myproc>
80106348:	85 c0                	test   %eax,%eax
8010634a:	74 1d                	je     80106369 <trap+0xc9>
8010634c:	e8 3f dd ff ff       	call   80104090 <myproc>
80106351:	8b 50 24             	mov    0x24(%eax),%edx
80106354:	85 d2                	test   %edx,%edx
80106356:	74 11                	je     80106369 <trap+0xc9>
80106358:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010635c:	83 e0 03             	and    $0x3,%eax
8010635f:	66 83 f8 03          	cmp    $0x3,%ax
80106363:	0f 84 4f 01 00 00    	je     801064b8 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106369:	e8 22 dd ff ff       	call   80104090 <myproc>
8010636e:	85 c0                	test   %eax,%eax
80106370:	74 0f                	je     80106381 <trap+0xe1>
80106372:	e8 19 dd ff ff       	call   80104090 <myproc>
80106377:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010637b:	0f 84 0f 01 00 00    	je     80106490 <trap+0x1f0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106381:	e8 0a dd ff ff       	call   80104090 <myproc>
80106386:	85 c0                	test   %eax,%eax
80106388:	74 19                	je     801063a3 <trap+0x103>
8010638a:	e8 01 dd ff ff       	call   80104090 <myproc>
8010638f:	8b 40 24             	mov    0x24(%eax),%eax
80106392:	85 c0                	test   %eax,%eax
80106394:	74 0d                	je     801063a3 <trap+0x103>
80106396:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010639a:	83 e0 03             	and    $0x3,%eax
8010639d:	66 83 f8 03          	cmp    $0x3,%ax
801063a1:	74 2c                	je     801063cf <trap+0x12f>
    exit();
}
801063a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a6:	5b                   	pop    %ebx
801063a7:	5e                   	pop    %esi
801063a8:	5f                   	pop    %edi
801063a9:	5d                   	pop    %ebp
801063aa:	c3                   	ret    
801063ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063af:	90                   	nop
    if(curproc->killed)
801063b0:	8b 7e 24             	mov    0x24(%esi),%edi
801063b3:	85 ff                	test   %edi,%edi
801063b5:	0f 85 ed 00 00 00    	jne    801064a8 <trap+0x208>
    curproc->tf = tf;
801063bb:	89 5e 18             	mov    %ebx,0x18(%esi)
    syscall();
801063be:	e8 8d ef ff ff       	call   80105350 <syscall>
    if(myproc()->killed)
801063c3:	e8 c8 dc ff ff       	call   80104090 <myproc>
801063c8:	8b 48 24             	mov    0x24(%eax),%ecx
801063cb:	85 c9                	test   %ecx,%ecx
801063cd:	74 d4                	je     801063a3 <trap+0x103>
}
801063cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d2:	5b                   	pop    %ebx
801063d3:	5e                   	pop    %esi
801063d4:	5f                   	pop    %edi
801063d5:	5d                   	pop    %ebp
      exit();
801063d6:	e9 05 e2 ff ff       	jmp    801045e0 <exit>
    ideintr();
801063db:	e8 c0 c1 ff ff       	call   801025a0 <ideintr>
    lapiceoi();
801063e0:	e8 2b cb ff ff       	call   80102f10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063e5:	e8 a6 dc ff ff       	call   80104090 <myproc>
801063ea:	85 c0                	test   %eax,%eax
801063ec:	0f 85 5a ff ff ff    	jne    8010634c <trap+0xac>
801063f2:	e9 72 ff ff ff       	jmp    80106369 <trap+0xc9>
    if(myproc()->pid > 2) 
801063f7:	e8 94 dc ff ff       	call   80104090 <myproc>
801063fc:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106400:	0f 8e 3d ff ff ff    	jle    80106343 <trap+0xa3>
    pagefault();
80106406:	e8 c5 18 00 00       	call   80107cd0 <pagefault>
8010640b:	e9 33 ff ff ff       	jmp    80106343 <trap+0xa3>
    if(cpuid() == 0){
80106410:	e8 5b dc ff ff       	call   80104070 <cpuid>
80106415:	85 c0                	test   %eax,%eax
80106417:	75 c7                	jne    801063e0 <trap+0x140>
      acquire(&tickslock);
80106419:	83 ec 0c             	sub    $0xc,%esp
8010641c:	68 a0 03 19 80       	push   $0x801903a0
80106421:	e8 4a ea ff ff       	call   80104e70 <acquire>
      wakeup(&ticks);
80106426:	c7 04 24 e0 0b 19 80 	movl   $0x80190be0,(%esp)
      ticks++;
8010642d:	83 05 e0 0b 19 80 01 	addl   $0x1,0x80190be0
      wakeup(&ticks);
80106434:	e8 67 e5 ff ff       	call   801049a0 <wakeup>
      release(&tickslock);
80106439:	c7 04 24 a0 03 19 80 	movl   $0x801903a0,(%esp)
80106440:	e8 eb ea ff ff       	call   80104f30 <release>
80106445:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106448:	eb 96                	jmp    801063e0 <trap+0x140>
    kbdintr();
8010644a:	e8 81 c9 ff ff       	call   80102dd0 <kbdintr>
    lapiceoi();
8010644f:	e8 bc ca ff ff       	call   80102f10 <lapiceoi>
    break;
80106454:	e9 ea fe ff ff       	jmp    80106343 <trap+0xa3>
    uartintr();
80106459:	e8 02 02 00 00       	call   80106660 <uartintr>
    lapiceoi();
8010645e:	e8 ad ca ff ff       	call   80102f10 <lapiceoi>
    break;
80106463:	e9 db fe ff ff       	jmp    80106343 <trap+0xa3>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106468:	8b 7b 38             	mov    0x38(%ebx),%edi
8010646b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010646f:	e8 fc db ff ff       	call   80104070 <cpuid>
80106474:	57                   	push   %edi
80106475:	56                   	push   %esi
80106476:	50                   	push   %eax
80106477:	68 48 8b 10 80       	push   $0x80108b48
8010647c:	e8 2f a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106481:	e8 8a ca ff ff       	call   80102f10 <lapiceoi>
    break;
80106486:	83 c4 10             	add    $0x10,%esp
80106489:	e9 b5 fe ff ff       	jmp    80106343 <trap+0xa3>
8010648e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80106490:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106494:	0f 85 e7 fe ff ff    	jne    80106381 <trap+0xe1>
    yield();
8010649a:	e8 b1 e2 ff ff       	call   80104750 <yield>
8010649f:	e9 dd fe ff ff       	jmp    80106381 <trap+0xe1>
801064a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
801064a8:	e8 33 e1 ff ff       	call   801045e0 <exit>
801064ad:	e9 09 ff ff ff       	jmp    801063bb <trap+0x11b>
801064b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801064b8:	e8 23 e1 ff ff       	call   801045e0 <exit>
801064bd:	e9 a7 fe ff ff       	jmp    80106369 <trap+0xc9>
801064c2:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064c5:	8b 73 38             	mov    0x38(%ebx),%esi
801064c8:	e8 a3 db ff ff       	call   80104070 <cpuid>
801064cd:	83 ec 0c             	sub    $0xc,%esp
801064d0:	57                   	push   %edi
801064d1:	56                   	push   %esi
801064d2:	50                   	push   %eax
801064d3:	ff 73 30             	pushl  0x30(%ebx)
801064d6:	68 6c 8b 10 80       	push   $0x80108b6c
801064db:	e8 d0 a1 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801064e0:	83 c4 14             	add    $0x14,%esp
801064e3:	68 42 8b 10 80       	push   $0x80108b42
801064e8:	e8 a3 9e ff ff       	call   80100390 <panic>
801064ed:	66 90                	xchg   %ax,%ax
801064ef:	90                   	nop

801064f0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801064f0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801064f4:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
801064f9:	85 c0                	test   %eax,%eax
801064fb:	74 1b                	je     80106518 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064fd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106502:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106503:	a8 01                	test   $0x1,%al
80106505:	74 11                	je     80106518 <uartgetc+0x28>
80106507:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010650d:	0f b6 c0             	movzbl %al,%eax
80106510:	c3                   	ret    
80106511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010651d:	c3                   	ret    
8010651e:	66 90                	xchg   %ax,%ax

80106520 <uartputc.part.0>:
uartputc(int c)
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	89 c7                	mov    %eax,%edi
80106526:	56                   	push   %esi
80106527:	be fd 03 00 00       	mov    $0x3fd,%esi
8010652c:	53                   	push   %ebx
8010652d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106532:	83 ec 0c             	sub    $0xc,%esp
80106535:	eb 1b                	jmp    80106552 <uartputc.part.0+0x32>
80106537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	6a 0a                	push   $0xa
80106545:	e8 e6 c9 ff ff       	call   80102f30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010654a:	83 c4 10             	add    $0x10,%esp
8010654d:	83 eb 01             	sub    $0x1,%ebx
80106550:	74 07                	je     80106559 <uartputc.part.0+0x39>
80106552:	89 f2                	mov    %esi,%edx
80106554:	ec                   	in     (%dx),%al
80106555:	a8 20                	test   $0x20,%al
80106557:	74 e7                	je     80106540 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106559:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655e:	89 f8                	mov    %edi,%eax
80106560:	ee                   	out    %al,(%dx)
}
80106561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
80106568:	c3                   	ret    
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106570 <uartinit>:
{
80106570:	f3 0f 1e fb          	endbr32 
80106574:	55                   	push   %ebp
80106575:	31 c9                	xor    %ecx,%ecx
80106577:	89 c8                	mov    %ecx,%eax
80106579:	89 e5                	mov    %esp,%ebp
8010657b:	57                   	push   %edi
8010657c:	56                   	push   %esi
8010657d:	53                   	push   %ebx
8010657e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106583:	89 da                	mov    %ebx,%edx
80106585:	83 ec 0c             	sub    $0xc,%esp
80106588:	ee                   	out    %al,(%dx)
80106589:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010658e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106593:	89 fa                	mov    %edi,%edx
80106595:	ee                   	out    %al,(%dx)
80106596:	b8 0c 00 00 00       	mov    $0xc,%eax
8010659b:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065a0:	ee                   	out    %al,(%dx)
801065a1:	be f9 03 00 00       	mov    $0x3f9,%esi
801065a6:	89 c8                	mov    %ecx,%eax
801065a8:	89 f2                	mov    %esi,%edx
801065aa:	ee                   	out    %al,(%dx)
801065ab:	b8 03 00 00 00       	mov    $0x3,%eax
801065b0:	89 fa                	mov    %edi,%edx
801065b2:	ee                   	out    %al,(%dx)
801065b3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065b8:	89 c8                	mov    %ecx,%eax
801065ba:	ee                   	out    %al,(%dx)
801065bb:	b8 01 00 00 00       	mov    $0x1,%eax
801065c0:	89 f2                	mov    %esi,%edx
801065c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065c3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065c8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801065c9:	3c ff                	cmp    $0xff,%al
801065cb:	74 52                	je     8010661f <uartinit+0xaf>
  uart = 1;
801065cd:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
801065d4:	00 00 00 
801065d7:	89 da                	mov    %ebx,%edx
801065d9:	ec                   	in     (%dx),%al
801065da:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801065e0:	83 ec 08             	sub    $0x8,%esp
801065e3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801065e8:	bb ac 8c 10 80       	mov    $0x80108cac,%ebx
  ioapicenable(IRQ_COM1, 0);
801065ed:	6a 00                	push   $0x0
801065ef:	6a 04                	push   $0x4
801065f1:	e8 fa c1 ff ff       	call   801027f0 <ioapicenable>
801065f6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065f9:	b8 78 00 00 00       	mov    $0x78,%eax
801065fe:	eb 04                	jmp    80106604 <uartinit+0x94>
80106600:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106604:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
8010660a:	85 d2                	test   %edx,%edx
8010660c:	74 08                	je     80106616 <uartinit+0xa6>
    uartputc(*p);
8010660e:	0f be c0             	movsbl %al,%eax
80106611:	e8 0a ff ff ff       	call   80106520 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106616:	89 f0                	mov    %esi,%eax
80106618:	83 c3 01             	add    $0x1,%ebx
8010661b:	84 c0                	test   %al,%al
8010661d:	75 e1                	jne    80106600 <uartinit+0x90>
}
8010661f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106622:	5b                   	pop    %ebx
80106623:	5e                   	pop    %esi
80106624:	5f                   	pop    %edi
80106625:	5d                   	pop    %ebp
80106626:	c3                   	ret    
80106627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662e:	66 90                	xchg   %ax,%ax

80106630 <uartputc>:
{
80106630:	f3 0f 1e fb          	endbr32 
80106634:	55                   	push   %ebp
  if(!uart)
80106635:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
{
8010663b:	89 e5                	mov    %esp,%ebp
8010663d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106640:	85 d2                	test   %edx,%edx
80106642:	74 0c                	je     80106650 <uartputc+0x20>
}
80106644:	5d                   	pop    %ebp
80106645:	e9 d6 fe ff ff       	jmp    80106520 <uartputc.part.0>
8010664a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106650:	5d                   	pop    %ebp
80106651:	c3                   	ret    
80106652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106660 <uartintr>:

void
uartintr(void)
{
80106660:	f3 0f 1e fb          	endbr32 
80106664:	55                   	push   %ebp
80106665:	89 e5                	mov    %esp,%ebp
80106667:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010666a:	68 f0 64 10 80       	push   $0x801064f0
8010666f:	e8 ec a1 ff ff       	call   80100860 <consoleintr>
}
80106674:	83 c4 10             	add    $0x10,%esp
80106677:	c9                   	leave  
80106678:	c3                   	ret    

80106679 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $0
8010667b:	6a 00                	push   $0x0
  jmp alltraps
8010667d:	e9 47 fb ff ff       	jmp    801061c9 <alltraps>

80106682 <vector1>:
.globl vector1
vector1:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $1
80106684:	6a 01                	push   $0x1
  jmp alltraps
80106686:	e9 3e fb ff ff       	jmp    801061c9 <alltraps>

8010668b <vector2>:
.globl vector2
vector2:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $2
8010668d:	6a 02                	push   $0x2
  jmp alltraps
8010668f:	e9 35 fb ff ff       	jmp    801061c9 <alltraps>

80106694 <vector3>:
.globl vector3
vector3:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $3
80106696:	6a 03                	push   $0x3
  jmp alltraps
80106698:	e9 2c fb ff ff       	jmp    801061c9 <alltraps>

8010669d <vector4>:
.globl vector4
vector4:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $4
8010669f:	6a 04                	push   $0x4
  jmp alltraps
801066a1:	e9 23 fb ff ff       	jmp    801061c9 <alltraps>

801066a6 <vector5>:
.globl vector5
vector5:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $5
801066a8:	6a 05                	push   $0x5
  jmp alltraps
801066aa:	e9 1a fb ff ff       	jmp    801061c9 <alltraps>

801066af <vector6>:
.globl vector6
vector6:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $6
801066b1:	6a 06                	push   $0x6
  jmp alltraps
801066b3:	e9 11 fb ff ff       	jmp    801061c9 <alltraps>

801066b8 <vector7>:
.globl vector7
vector7:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $7
801066ba:	6a 07                	push   $0x7
  jmp alltraps
801066bc:	e9 08 fb ff ff       	jmp    801061c9 <alltraps>

801066c1 <vector8>:
.globl vector8
vector8:
  pushl $8
801066c1:	6a 08                	push   $0x8
  jmp alltraps
801066c3:	e9 01 fb ff ff       	jmp    801061c9 <alltraps>

801066c8 <vector9>:
.globl vector9
vector9:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $9
801066ca:	6a 09                	push   $0x9
  jmp alltraps
801066cc:	e9 f8 fa ff ff       	jmp    801061c9 <alltraps>

801066d1 <vector10>:
.globl vector10
vector10:
  pushl $10
801066d1:	6a 0a                	push   $0xa
  jmp alltraps
801066d3:	e9 f1 fa ff ff       	jmp    801061c9 <alltraps>

801066d8 <vector11>:
.globl vector11
vector11:
  pushl $11
801066d8:	6a 0b                	push   $0xb
  jmp alltraps
801066da:	e9 ea fa ff ff       	jmp    801061c9 <alltraps>

801066df <vector12>:
.globl vector12
vector12:
  pushl $12
801066df:	6a 0c                	push   $0xc
  jmp alltraps
801066e1:	e9 e3 fa ff ff       	jmp    801061c9 <alltraps>

801066e6 <vector13>:
.globl vector13
vector13:
  pushl $13
801066e6:	6a 0d                	push   $0xd
  jmp alltraps
801066e8:	e9 dc fa ff ff       	jmp    801061c9 <alltraps>

801066ed <vector14>:
.globl vector14
vector14:
  pushl $14
801066ed:	6a 0e                	push   $0xe
  jmp alltraps
801066ef:	e9 d5 fa ff ff       	jmp    801061c9 <alltraps>

801066f4 <vector15>:
.globl vector15
vector15:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $15
801066f6:	6a 0f                	push   $0xf
  jmp alltraps
801066f8:	e9 cc fa ff ff       	jmp    801061c9 <alltraps>

801066fd <vector16>:
.globl vector16
vector16:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $16
801066ff:	6a 10                	push   $0x10
  jmp alltraps
80106701:	e9 c3 fa ff ff       	jmp    801061c9 <alltraps>

80106706 <vector17>:
.globl vector17
vector17:
  pushl $17
80106706:	6a 11                	push   $0x11
  jmp alltraps
80106708:	e9 bc fa ff ff       	jmp    801061c9 <alltraps>

8010670d <vector18>:
.globl vector18
vector18:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $18
8010670f:	6a 12                	push   $0x12
  jmp alltraps
80106711:	e9 b3 fa ff ff       	jmp    801061c9 <alltraps>

80106716 <vector19>:
.globl vector19
vector19:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $19
80106718:	6a 13                	push   $0x13
  jmp alltraps
8010671a:	e9 aa fa ff ff       	jmp    801061c9 <alltraps>

8010671f <vector20>:
.globl vector20
vector20:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $20
80106721:	6a 14                	push   $0x14
  jmp alltraps
80106723:	e9 a1 fa ff ff       	jmp    801061c9 <alltraps>

80106728 <vector21>:
.globl vector21
vector21:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $21
8010672a:	6a 15                	push   $0x15
  jmp alltraps
8010672c:	e9 98 fa ff ff       	jmp    801061c9 <alltraps>

80106731 <vector22>:
.globl vector22
vector22:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $22
80106733:	6a 16                	push   $0x16
  jmp alltraps
80106735:	e9 8f fa ff ff       	jmp    801061c9 <alltraps>

8010673a <vector23>:
.globl vector23
vector23:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $23
8010673c:	6a 17                	push   $0x17
  jmp alltraps
8010673e:	e9 86 fa ff ff       	jmp    801061c9 <alltraps>

80106743 <vector24>:
.globl vector24
vector24:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $24
80106745:	6a 18                	push   $0x18
  jmp alltraps
80106747:	e9 7d fa ff ff       	jmp    801061c9 <alltraps>

8010674c <vector25>:
.globl vector25
vector25:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $25
8010674e:	6a 19                	push   $0x19
  jmp alltraps
80106750:	e9 74 fa ff ff       	jmp    801061c9 <alltraps>

80106755 <vector26>:
.globl vector26
vector26:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $26
80106757:	6a 1a                	push   $0x1a
  jmp alltraps
80106759:	e9 6b fa ff ff       	jmp    801061c9 <alltraps>

8010675e <vector27>:
.globl vector27
vector27:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $27
80106760:	6a 1b                	push   $0x1b
  jmp alltraps
80106762:	e9 62 fa ff ff       	jmp    801061c9 <alltraps>

80106767 <vector28>:
.globl vector28
vector28:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $28
80106769:	6a 1c                	push   $0x1c
  jmp alltraps
8010676b:	e9 59 fa ff ff       	jmp    801061c9 <alltraps>

80106770 <vector29>:
.globl vector29
vector29:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $29
80106772:	6a 1d                	push   $0x1d
  jmp alltraps
80106774:	e9 50 fa ff ff       	jmp    801061c9 <alltraps>

80106779 <vector30>:
.globl vector30
vector30:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $30
8010677b:	6a 1e                	push   $0x1e
  jmp alltraps
8010677d:	e9 47 fa ff ff       	jmp    801061c9 <alltraps>

80106782 <vector31>:
.globl vector31
vector31:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $31
80106784:	6a 1f                	push   $0x1f
  jmp alltraps
80106786:	e9 3e fa ff ff       	jmp    801061c9 <alltraps>

8010678b <vector32>:
.globl vector32
vector32:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $32
8010678d:	6a 20                	push   $0x20
  jmp alltraps
8010678f:	e9 35 fa ff ff       	jmp    801061c9 <alltraps>

80106794 <vector33>:
.globl vector33
vector33:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $33
80106796:	6a 21                	push   $0x21
  jmp alltraps
80106798:	e9 2c fa ff ff       	jmp    801061c9 <alltraps>

8010679d <vector34>:
.globl vector34
vector34:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $34
8010679f:	6a 22                	push   $0x22
  jmp alltraps
801067a1:	e9 23 fa ff ff       	jmp    801061c9 <alltraps>

801067a6 <vector35>:
.globl vector35
vector35:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $35
801067a8:	6a 23                	push   $0x23
  jmp alltraps
801067aa:	e9 1a fa ff ff       	jmp    801061c9 <alltraps>

801067af <vector36>:
.globl vector36
vector36:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $36
801067b1:	6a 24                	push   $0x24
  jmp alltraps
801067b3:	e9 11 fa ff ff       	jmp    801061c9 <alltraps>

801067b8 <vector37>:
.globl vector37
vector37:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $37
801067ba:	6a 25                	push   $0x25
  jmp alltraps
801067bc:	e9 08 fa ff ff       	jmp    801061c9 <alltraps>

801067c1 <vector38>:
.globl vector38
vector38:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $38
801067c3:	6a 26                	push   $0x26
  jmp alltraps
801067c5:	e9 ff f9 ff ff       	jmp    801061c9 <alltraps>

801067ca <vector39>:
.globl vector39
vector39:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $39
801067cc:	6a 27                	push   $0x27
  jmp alltraps
801067ce:	e9 f6 f9 ff ff       	jmp    801061c9 <alltraps>

801067d3 <vector40>:
.globl vector40
vector40:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $40
801067d5:	6a 28                	push   $0x28
  jmp alltraps
801067d7:	e9 ed f9 ff ff       	jmp    801061c9 <alltraps>

801067dc <vector41>:
.globl vector41
vector41:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $41
801067de:	6a 29                	push   $0x29
  jmp alltraps
801067e0:	e9 e4 f9 ff ff       	jmp    801061c9 <alltraps>

801067e5 <vector42>:
.globl vector42
vector42:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $42
801067e7:	6a 2a                	push   $0x2a
  jmp alltraps
801067e9:	e9 db f9 ff ff       	jmp    801061c9 <alltraps>

801067ee <vector43>:
.globl vector43
vector43:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $43
801067f0:	6a 2b                	push   $0x2b
  jmp alltraps
801067f2:	e9 d2 f9 ff ff       	jmp    801061c9 <alltraps>

801067f7 <vector44>:
.globl vector44
vector44:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $44
801067f9:	6a 2c                	push   $0x2c
  jmp alltraps
801067fb:	e9 c9 f9 ff ff       	jmp    801061c9 <alltraps>

80106800 <vector45>:
.globl vector45
vector45:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $45
80106802:	6a 2d                	push   $0x2d
  jmp alltraps
80106804:	e9 c0 f9 ff ff       	jmp    801061c9 <alltraps>

80106809 <vector46>:
.globl vector46
vector46:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $46
8010680b:	6a 2e                	push   $0x2e
  jmp alltraps
8010680d:	e9 b7 f9 ff ff       	jmp    801061c9 <alltraps>

80106812 <vector47>:
.globl vector47
vector47:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $47
80106814:	6a 2f                	push   $0x2f
  jmp alltraps
80106816:	e9 ae f9 ff ff       	jmp    801061c9 <alltraps>

8010681b <vector48>:
.globl vector48
vector48:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $48
8010681d:	6a 30                	push   $0x30
  jmp alltraps
8010681f:	e9 a5 f9 ff ff       	jmp    801061c9 <alltraps>

80106824 <vector49>:
.globl vector49
vector49:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $49
80106826:	6a 31                	push   $0x31
  jmp alltraps
80106828:	e9 9c f9 ff ff       	jmp    801061c9 <alltraps>

8010682d <vector50>:
.globl vector50
vector50:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $50
8010682f:	6a 32                	push   $0x32
  jmp alltraps
80106831:	e9 93 f9 ff ff       	jmp    801061c9 <alltraps>

80106836 <vector51>:
.globl vector51
vector51:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $51
80106838:	6a 33                	push   $0x33
  jmp alltraps
8010683a:	e9 8a f9 ff ff       	jmp    801061c9 <alltraps>

8010683f <vector52>:
.globl vector52
vector52:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $52
80106841:	6a 34                	push   $0x34
  jmp alltraps
80106843:	e9 81 f9 ff ff       	jmp    801061c9 <alltraps>

80106848 <vector53>:
.globl vector53
vector53:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $53
8010684a:	6a 35                	push   $0x35
  jmp alltraps
8010684c:	e9 78 f9 ff ff       	jmp    801061c9 <alltraps>

80106851 <vector54>:
.globl vector54
vector54:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $54
80106853:	6a 36                	push   $0x36
  jmp alltraps
80106855:	e9 6f f9 ff ff       	jmp    801061c9 <alltraps>

8010685a <vector55>:
.globl vector55
vector55:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $55
8010685c:	6a 37                	push   $0x37
  jmp alltraps
8010685e:	e9 66 f9 ff ff       	jmp    801061c9 <alltraps>

80106863 <vector56>:
.globl vector56
vector56:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $56
80106865:	6a 38                	push   $0x38
  jmp alltraps
80106867:	e9 5d f9 ff ff       	jmp    801061c9 <alltraps>

8010686c <vector57>:
.globl vector57
vector57:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $57
8010686e:	6a 39                	push   $0x39
  jmp alltraps
80106870:	e9 54 f9 ff ff       	jmp    801061c9 <alltraps>

80106875 <vector58>:
.globl vector58
vector58:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $58
80106877:	6a 3a                	push   $0x3a
  jmp alltraps
80106879:	e9 4b f9 ff ff       	jmp    801061c9 <alltraps>

8010687e <vector59>:
.globl vector59
vector59:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $59
80106880:	6a 3b                	push   $0x3b
  jmp alltraps
80106882:	e9 42 f9 ff ff       	jmp    801061c9 <alltraps>

80106887 <vector60>:
.globl vector60
vector60:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $60
80106889:	6a 3c                	push   $0x3c
  jmp alltraps
8010688b:	e9 39 f9 ff ff       	jmp    801061c9 <alltraps>

80106890 <vector61>:
.globl vector61
vector61:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $61
80106892:	6a 3d                	push   $0x3d
  jmp alltraps
80106894:	e9 30 f9 ff ff       	jmp    801061c9 <alltraps>

80106899 <vector62>:
.globl vector62
vector62:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $62
8010689b:	6a 3e                	push   $0x3e
  jmp alltraps
8010689d:	e9 27 f9 ff ff       	jmp    801061c9 <alltraps>

801068a2 <vector63>:
.globl vector63
vector63:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $63
801068a4:	6a 3f                	push   $0x3f
  jmp alltraps
801068a6:	e9 1e f9 ff ff       	jmp    801061c9 <alltraps>

801068ab <vector64>:
.globl vector64
vector64:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $64
801068ad:	6a 40                	push   $0x40
  jmp alltraps
801068af:	e9 15 f9 ff ff       	jmp    801061c9 <alltraps>

801068b4 <vector65>:
.globl vector65
vector65:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $65
801068b6:	6a 41                	push   $0x41
  jmp alltraps
801068b8:	e9 0c f9 ff ff       	jmp    801061c9 <alltraps>

801068bd <vector66>:
.globl vector66
vector66:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $66
801068bf:	6a 42                	push   $0x42
  jmp alltraps
801068c1:	e9 03 f9 ff ff       	jmp    801061c9 <alltraps>

801068c6 <vector67>:
.globl vector67
vector67:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $67
801068c8:	6a 43                	push   $0x43
  jmp alltraps
801068ca:	e9 fa f8 ff ff       	jmp    801061c9 <alltraps>

801068cf <vector68>:
.globl vector68
vector68:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $68
801068d1:	6a 44                	push   $0x44
  jmp alltraps
801068d3:	e9 f1 f8 ff ff       	jmp    801061c9 <alltraps>

801068d8 <vector69>:
.globl vector69
vector69:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $69
801068da:	6a 45                	push   $0x45
  jmp alltraps
801068dc:	e9 e8 f8 ff ff       	jmp    801061c9 <alltraps>

801068e1 <vector70>:
.globl vector70
vector70:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $70
801068e3:	6a 46                	push   $0x46
  jmp alltraps
801068e5:	e9 df f8 ff ff       	jmp    801061c9 <alltraps>

801068ea <vector71>:
.globl vector71
vector71:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $71
801068ec:	6a 47                	push   $0x47
  jmp alltraps
801068ee:	e9 d6 f8 ff ff       	jmp    801061c9 <alltraps>

801068f3 <vector72>:
.globl vector72
vector72:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $72
801068f5:	6a 48                	push   $0x48
  jmp alltraps
801068f7:	e9 cd f8 ff ff       	jmp    801061c9 <alltraps>

801068fc <vector73>:
.globl vector73
vector73:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $73
801068fe:	6a 49                	push   $0x49
  jmp alltraps
80106900:	e9 c4 f8 ff ff       	jmp    801061c9 <alltraps>

80106905 <vector74>:
.globl vector74
vector74:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $74
80106907:	6a 4a                	push   $0x4a
  jmp alltraps
80106909:	e9 bb f8 ff ff       	jmp    801061c9 <alltraps>

8010690e <vector75>:
.globl vector75
vector75:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $75
80106910:	6a 4b                	push   $0x4b
  jmp alltraps
80106912:	e9 b2 f8 ff ff       	jmp    801061c9 <alltraps>

80106917 <vector76>:
.globl vector76
vector76:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $76
80106919:	6a 4c                	push   $0x4c
  jmp alltraps
8010691b:	e9 a9 f8 ff ff       	jmp    801061c9 <alltraps>

80106920 <vector77>:
.globl vector77
vector77:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $77
80106922:	6a 4d                	push   $0x4d
  jmp alltraps
80106924:	e9 a0 f8 ff ff       	jmp    801061c9 <alltraps>

80106929 <vector78>:
.globl vector78
vector78:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $78
8010692b:	6a 4e                	push   $0x4e
  jmp alltraps
8010692d:	e9 97 f8 ff ff       	jmp    801061c9 <alltraps>

80106932 <vector79>:
.globl vector79
vector79:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $79
80106934:	6a 4f                	push   $0x4f
  jmp alltraps
80106936:	e9 8e f8 ff ff       	jmp    801061c9 <alltraps>

8010693b <vector80>:
.globl vector80
vector80:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $80
8010693d:	6a 50                	push   $0x50
  jmp alltraps
8010693f:	e9 85 f8 ff ff       	jmp    801061c9 <alltraps>

80106944 <vector81>:
.globl vector81
vector81:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $81
80106946:	6a 51                	push   $0x51
  jmp alltraps
80106948:	e9 7c f8 ff ff       	jmp    801061c9 <alltraps>

8010694d <vector82>:
.globl vector82
vector82:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $82
8010694f:	6a 52                	push   $0x52
  jmp alltraps
80106951:	e9 73 f8 ff ff       	jmp    801061c9 <alltraps>

80106956 <vector83>:
.globl vector83
vector83:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $83
80106958:	6a 53                	push   $0x53
  jmp alltraps
8010695a:	e9 6a f8 ff ff       	jmp    801061c9 <alltraps>

8010695f <vector84>:
.globl vector84
vector84:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $84
80106961:	6a 54                	push   $0x54
  jmp alltraps
80106963:	e9 61 f8 ff ff       	jmp    801061c9 <alltraps>

80106968 <vector85>:
.globl vector85
vector85:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $85
8010696a:	6a 55                	push   $0x55
  jmp alltraps
8010696c:	e9 58 f8 ff ff       	jmp    801061c9 <alltraps>

80106971 <vector86>:
.globl vector86
vector86:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $86
80106973:	6a 56                	push   $0x56
  jmp alltraps
80106975:	e9 4f f8 ff ff       	jmp    801061c9 <alltraps>

8010697a <vector87>:
.globl vector87
vector87:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $87
8010697c:	6a 57                	push   $0x57
  jmp alltraps
8010697e:	e9 46 f8 ff ff       	jmp    801061c9 <alltraps>

80106983 <vector88>:
.globl vector88
vector88:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $88
80106985:	6a 58                	push   $0x58
  jmp alltraps
80106987:	e9 3d f8 ff ff       	jmp    801061c9 <alltraps>

8010698c <vector89>:
.globl vector89
vector89:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $89
8010698e:	6a 59                	push   $0x59
  jmp alltraps
80106990:	e9 34 f8 ff ff       	jmp    801061c9 <alltraps>

80106995 <vector90>:
.globl vector90
vector90:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $90
80106997:	6a 5a                	push   $0x5a
  jmp alltraps
80106999:	e9 2b f8 ff ff       	jmp    801061c9 <alltraps>

8010699e <vector91>:
.globl vector91
vector91:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $91
801069a0:	6a 5b                	push   $0x5b
  jmp alltraps
801069a2:	e9 22 f8 ff ff       	jmp    801061c9 <alltraps>

801069a7 <vector92>:
.globl vector92
vector92:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $92
801069a9:	6a 5c                	push   $0x5c
  jmp alltraps
801069ab:	e9 19 f8 ff ff       	jmp    801061c9 <alltraps>

801069b0 <vector93>:
.globl vector93
vector93:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $93
801069b2:	6a 5d                	push   $0x5d
  jmp alltraps
801069b4:	e9 10 f8 ff ff       	jmp    801061c9 <alltraps>

801069b9 <vector94>:
.globl vector94
vector94:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $94
801069bb:	6a 5e                	push   $0x5e
  jmp alltraps
801069bd:	e9 07 f8 ff ff       	jmp    801061c9 <alltraps>

801069c2 <vector95>:
.globl vector95
vector95:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $95
801069c4:	6a 5f                	push   $0x5f
  jmp alltraps
801069c6:	e9 fe f7 ff ff       	jmp    801061c9 <alltraps>

801069cb <vector96>:
.globl vector96
vector96:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $96
801069cd:	6a 60                	push   $0x60
  jmp alltraps
801069cf:	e9 f5 f7 ff ff       	jmp    801061c9 <alltraps>

801069d4 <vector97>:
.globl vector97
vector97:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $97
801069d6:	6a 61                	push   $0x61
  jmp alltraps
801069d8:	e9 ec f7 ff ff       	jmp    801061c9 <alltraps>

801069dd <vector98>:
.globl vector98
vector98:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $98
801069df:	6a 62                	push   $0x62
  jmp alltraps
801069e1:	e9 e3 f7 ff ff       	jmp    801061c9 <alltraps>

801069e6 <vector99>:
.globl vector99
vector99:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $99
801069e8:	6a 63                	push   $0x63
  jmp alltraps
801069ea:	e9 da f7 ff ff       	jmp    801061c9 <alltraps>

801069ef <vector100>:
.globl vector100
vector100:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $100
801069f1:	6a 64                	push   $0x64
  jmp alltraps
801069f3:	e9 d1 f7 ff ff       	jmp    801061c9 <alltraps>

801069f8 <vector101>:
.globl vector101
vector101:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $101
801069fa:	6a 65                	push   $0x65
  jmp alltraps
801069fc:	e9 c8 f7 ff ff       	jmp    801061c9 <alltraps>

80106a01 <vector102>:
.globl vector102
vector102:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $102
80106a03:	6a 66                	push   $0x66
  jmp alltraps
80106a05:	e9 bf f7 ff ff       	jmp    801061c9 <alltraps>

80106a0a <vector103>:
.globl vector103
vector103:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $103
80106a0c:	6a 67                	push   $0x67
  jmp alltraps
80106a0e:	e9 b6 f7 ff ff       	jmp    801061c9 <alltraps>

80106a13 <vector104>:
.globl vector104
vector104:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $104
80106a15:	6a 68                	push   $0x68
  jmp alltraps
80106a17:	e9 ad f7 ff ff       	jmp    801061c9 <alltraps>

80106a1c <vector105>:
.globl vector105
vector105:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $105
80106a1e:	6a 69                	push   $0x69
  jmp alltraps
80106a20:	e9 a4 f7 ff ff       	jmp    801061c9 <alltraps>

80106a25 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $106
80106a27:	6a 6a                	push   $0x6a
  jmp alltraps
80106a29:	e9 9b f7 ff ff       	jmp    801061c9 <alltraps>

80106a2e <vector107>:
.globl vector107
vector107:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $107
80106a30:	6a 6b                	push   $0x6b
  jmp alltraps
80106a32:	e9 92 f7 ff ff       	jmp    801061c9 <alltraps>

80106a37 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $108
80106a39:	6a 6c                	push   $0x6c
  jmp alltraps
80106a3b:	e9 89 f7 ff ff       	jmp    801061c9 <alltraps>

80106a40 <vector109>:
.globl vector109
vector109:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $109
80106a42:	6a 6d                	push   $0x6d
  jmp alltraps
80106a44:	e9 80 f7 ff ff       	jmp    801061c9 <alltraps>

80106a49 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $110
80106a4b:	6a 6e                	push   $0x6e
  jmp alltraps
80106a4d:	e9 77 f7 ff ff       	jmp    801061c9 <alltraps>

80106a52 <vector111>:
.globl vector111
vector111:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $111
80106a54:	6a 6f                	push   $0x6f
  jmp alltraps
80106a56:	e9 6e f7 ff ff       	jmp    801061c9 <alltraps>

80106a5b <vector112>:
.globl vector112
vector112:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $112
80106a5d:	6a 70                	push   $0x70
  jmp alltraps
80106a5f:	e9 65 f7 ff ff       	jmp    801061c9 <alltraps>

80106a64 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $113
80106a66:	6a 71                	push   $0x71
  jmp alltraps
80106a68:	e9 5c f7 ff ff       	jmp    801061c9 <alltraps>

80106a6d <vector114>:
.globl vector114
vector114:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $114
80106a6f:	6a 72                	push   $0x72
  jmp alltraps
80106a71:	e9 53 f7 ff ff       	jmp    801061c9 <alltraps>

80106a76 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $115
80106a78:	6a 73                	push   $0x73
  jmp alltraps
80106a7a:	e9 4a f7 ff ff       	jmp    801061c9 <alltraps>

80106a7f <vector116>:
.globl vector116
vector116:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $116
80106a81:	6a 74                	push   $0x74
  jmp alltraps
80106a83:	e9 41 f7 ff ff       	jmp    801061c9 <alltraps>

80106a88 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $117
80106a8a:	6a 75                	push   $0x75
  jmp alltraps
80106a8c:	e9 38 f7 ff ff       	jmp    801061c9 <alltraps>

80106a91 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $118
80106a93:	6a 76                	push   $0x76
  jmp alltraps
80106a95:	e9 2f f7 ff ff       	jmp    801061c9 <alltraps>

80106a9a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $119
80106a9c:	6a 77                	push   $0x77
  jmp alltraps
80106a9e:	e9 26 f7 ff ff       	jmp    801061c9 <alltraps>

80106aa3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $120
80106aa5:	6a 78                	push   $0x78
  jmp alltraps
80106aa7:	e9 1d f7 ff ff       	jmp    801061c9 <alltraps>

80106aac <vector121>:
.globl vector121
vector121:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $121
80106aae:	6a 79                	push   $0x79
  jmp alltraps
80106ab0:	e9 14 f7 ff ff       	jmp    801061c9 <alltraps>

80106ab5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $122
80106ab7:	6a 7a                	push   $0x7a
  jmp alltraps
80106ab9:	e9 0b f7 ff ff       	jmp    801061c9 <alltraps>

80106abe <vector123>:
.globl vector123
vector123:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $123
80106ac0:	6a 7b                	push   $0x7b
  jmp alltraps
80106ac2:	e9 02 f7 ff ff       	jmp    801061c9 <alltraps>

80106ac7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $124
80106ac9:	6a 7c                	push   $0x7c
  jmp alltraps
80106acb:	e9 f9 f6 ff ff       	jmp    801061c9 <alltraps>

80106ad0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $125
80106ad2:	6a 7d                	push   $0x7d
  jmp alltraps
80106ad4:	e9 f0 f6 ff ff       	jmp    801061c9 <alltraps>

80106ad9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $126
80106adb:	6a 7e                	push   $0x7e
  jmp alltraps
80106add:	e9 e7 f6 ff ff       	jmp    801061c9 <alltraps>

80106ae2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $127
80106ae4:	6a 7f                	push   $0x7f
  jmp alltraps
80106ae6:	e9 de f6 ff ff       	jmp    801061c9 <alltraps>

80106aeb <vector128>:
.globl vector128
vector128:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $128
80106aed:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106af2:	e9 d2 f6 ff ff       	jmp    801061c9 <alltraps>

80106af7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $129
80106af9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106afe:	e9 c6 f6 ff ff       	jmp    801061c9 <alltraps>

80106b03 <vector130>:
.globl vector130
vector130:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $130
80106b05:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b0a:	e9 ba f6 ff ff       	jmp    801061c9 <alltraps>

80106b0f <vector131>:
.globl vector131
vector131:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $131
80106b11:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b16:	e9 ae f6 ff ff       	jmp    801061c9 <alltraps>

80106b1b <vector132>:
.globl vector132
vector132:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $132
80106b1d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b22:	e9 a2 f6 ff ff       	jmp    801061c9 <alltraps>

80106b27 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $133
80106b29:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b2e:	e9 96 f6 ff ff       	jmp    801061c9 <alltraps>

80106b33 <vector134>:
.globl vector134
vector134:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $134
80106b35:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b3a:	e9 8a f6 ff ff       	jmp    801061c9 <alltraps>

80106b3f <vector135>:
.globl vector135
vector135:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $135
80106b41:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b46:	e9 7e f6 ff ff       	jmp    801061c9 <alltraps>

80106b4b <vector136>:
.globl vector136
vector136:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $136
80106b4d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b52:	e9 72 f6 ff ff       	jmp    801061c9 <alltraps>

80106b57 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $137
80106b59:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b5e:	e9 66 f6 ff ff       	jmp    801061c9 <alltraps>

80106b63 <vector138>:
.globl vector138
vector138:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $138
80106b65:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b6a:	e9 5a f6 ff ff       	jmp    801061c9 <alltraps>

80106b6f <vector139>:
.globl vector139
vector139:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $139
80106b71:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b76:	e9 4e f6 ff ff       	jmp    801061c9 <alltraps>

80106b7b <vector140>:
.globl vector140
vector140:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $140
80106b7d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b82:	e9 42 f6 ff ff       	jmp    801061c9 <alltraps>

80106b87 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $141
80106b89:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b8e:	e9 36 f6 ff ff       	jmp    801061c9 <alltraps>

80106b93 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $142
80106b95:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b9a:	e9 2a f6 ff ff       	jmp    801061c9 <alltraps>

80106b9f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $143
80106ba1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ba6:	e9 1e f6 ff ff       	jmp    801061c9 <alltraps>

80106bab <vector144>:
.globl vector144
vector144:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $144
80106bad:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bb2:	e9 12 f6 ff ff       	jmp    801061c9 <alltraps>

80106bb7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $145
80106bb9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bbe:	e9 06 f6 ff ff       	jmp    801061c9 <alltraps>

80106bc3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $146
80106bc5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bca:	e9 fa f5 ff ff       	jmp    801061c9 <alltraps>

80106bcf <vector147>:
.globl vector147
vector147:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $147
80106bd1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bd6:	e9 ee f5 ff ff       	jmp    801061c9 <alltraps>

80106bdb <vector148>:
.globl vector148
vector148:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $148
80106bdd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106be2:	e9 e2 f5 ff ff       	jmp    801061c9 <alltraps>

80106be7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $149
80106be9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bee:	e9 d6 f5 ff ff       	jmp    801061c9 <alltraps>

80106bf3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $150
80106bf5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bfa:	e9 ca f5 ff ff       	jmp    801061c9 <alltraps>

80106bff <vector151>:
.globl vector151
vector151:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $151
80106c01:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c06:	e9 be f5 ff ff       	jmp    801061c9 <alltraps>

80106c0b <vector152>:
.globl vector152
vector152:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $152
80106c0d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c12:	e9 b2 f5 ff ff       	jmp    801061c9 <alltraps>

80106c17 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $153
80106c19:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c1e:	e9 a6 f5 ff ff       	jmp    801061c9 <alltraps>

80106c23 <vector154>:
.globl vector154
vector154:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $154
80106c25:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c2a:	e9 9a f5 ff ff       	jmp    801061c9 <alltraps>

80106c2f <vector155>:
.globl vector155
vector155:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $155
80106c31:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c36:	e9 8e f5 ff ff       	jmp    801061c9 <alltraps>

80106c3b <vector156>:
.globl vector156
vector156:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $156
80106c3d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c42:	e9 82 f5 ff ff       	jmp    801061c9 <alltraps>

80106c47 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $157
80106c49:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c4e:	e9 76 f5 ff ff       	jmp    801061c9 <alltraps>

80106c53 <vector158>:
.globl vector158
vector158:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $158
80106c55:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c5a:	e9 6a f5 ff ff       	jmp    801061c9 <alltraps>

80106c5f <vector159>:
.globl vector159
vector159:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $159
80106c61:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c66:	e9 5e f5 ff ff       	jmp    801061c9 <alltraps>

80106c6b <vector160>:
.globl vector160
vector160:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $160
80106c6d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c72:	e9 52 f5 ff ff       	jmp    801061c9 <alltraps>

80106c77 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $161
80106c79:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c7e:	e9 46 f5 ff ff       	jmp    801061c9 <alltraps>

80106c83 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $162
80106c85:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c8a:	e9 3a f5 ff ff       	jmp    801061c9 <alltraps>

80106c8f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $163
80106c91:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c96:	e9 2e f5 ff ff       	jmp    801061c9 <alltraps>

80106c9b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $164
80106c9d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ca2:	e9 22 f5 ff ff       	jmp    801061c9 <alltraps>

80106ca7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $165
80106ca9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cae:	e9 16 f5 ff ff       	jmp    801061c9 <alltraps>

80106cb3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $166
80106cb5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cba:	e9 0a f5 ff ff       	jmp    801061c9 <alltraps>

80106cbf <vector167>:
.globl vector167
vector167:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $167
80106cc1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cc6:	e9 fe f4 ff ff       	jmp    801061c9 <alltraps>

80106ccb <vector168>:
.globl vector168
vector168:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $168
80106ccd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cd2:	e9 f2 f4 ff ff       	jmp    801061c9 <alltraps>

80106cd7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $169
80106cd9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cde:	e9 e6 f4 ff ff       	jmp    801061c9 <alltraps>

80106ce3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $170
80106ce5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cea:	e9 da f4 ff ff       	jmp    801061c9 <alltraps>

80106cef <vector171>:
.globl vector171
vector171:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $171
80106cf1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cf6:	e9 ce f4 ff ff       	jmp    801061c9 <alltraps>

80106cfb <vector172>:
.globl vector172
vector172:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $172
80106cfd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d02:	e9 c2 f4 ff ff       	jmp    801061c9 <alltraps>

80106d07 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $173
80106d09:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d0e:	e9 b6 f4 ff ff       	jmp    801061c9 <alltraps>

80106d13 <vector174>:
.globl vector174
vector174:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $174
80106d15:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d1a:	e9 aa f4 ff ff       	jmp    801061c9 <alltraps>

80106d1f <vector175>:
.globl vector175
vector175:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $175
80106d21:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d26:	e9 9e f4 ff ff       	jmp    801061c9 <alltraps>

80106d2b <vector176>:
.globl vector176
vector176:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $176
80106d2d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d32:	e9 92 f4 ff ff       	jmp    801061c9 <alltraps>

80106d37 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $177
80106d39:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d3e:	e9 86 f4 ff ff       	jmp    801061c9 <alltraps>

80106d43 <vector178>:
.globl vector178
vector178:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $178
80106d45:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d4a:	e9 7a f4 ff ff       	jmp    801061c9 <alltraps>

80106d4f <vector179>:
.globl vector179
vector179:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $179
80106d51:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d56:	e9 6e f4 ff ff       	jmp    801061c9 <alltraps>

80106d5b <vector180>:
.globl vector180
vector180:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $180
80106d5d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d62:	e9 62 f4 ff ff       	jmp    801061c9 <alltraps>

80106d67 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $181
80106d69:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d6e:	e9 56 f4 ff ff       	jmp    801061c9 <alltraps>

80106d73 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $182
80106d75:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d7a:	e9 4a f4 ff ff       	jmp    801061c9 <alltraps>

80106d7f <vector183>:
.globl vector183
vector183:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $183
80106d81:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d86:	e9 3e f4 ff ff       	jmp    801061c9 <alltraps>

80106d8b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $184
80106d8d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d92:	e9 32 f4 ff ff       	jmp    801061c9 <alltraps>

80106d97 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $185
80106d99:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d9e:	e9 26 f4 ff ff       	jmp    801061c9 <alltraps>

80106da3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $186
80106da5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106daa:	e9 1a f4 ff ff       	jmp    801061c9 <alltraps>

80106daf <vector187>:
.globl vector187
vector187:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $187
80106db1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106db6:	e9 0e f4 ff ff       	jmp    801061c9 <alltraps>

80106dbb <vector188>:
.globl vector188
vector188:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $188
80106dbd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dc2:	e9 02 f4 ff ff       	jmp    801061c9 <alltraps>

80106dc7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $189
80106dc9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dce:	e9 f6 f3 ff ff       	jmp    801061c9 <alltraps>

80106dd3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $190
80106dd5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106dda:	e9 ea f3 ff ff       	jmp    801061c9 <alltraps>

80106ddf <vector191>:
.globl vector191
vector191:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $191
80106de1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106de6:	e9 de f3 ff ff       	jmp    801061c9 <alltraps>

80106deb <vector192>:
.globl vector192
vector192:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $192
80106ded:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106df2:	e9 d2 f3 ff ff       	jmp    801061c9 <alltraps>

80106df7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $193
80106df9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dfe:	e9 c6 f3 ff ff       	jmp    801061c9 <alltraps>

80106e03 <vector194>:
.globl vector194
vector194:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $194
80106e05:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e0a:	e9 ba f3 ff ff       	jmp    801061c9 <alltraps>

80106e0f <vector195>:
.globl vector195
vector195:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $195
80106e11:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e16:	e9 ae f3 ff ff       	jmp    801061c9 <alltraps>

80106e1b <vector196>:
.globl vector196
vector196:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $196
80106e1d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e22:	e9 a2 f3 ff ff       	jmp    801061c9 <alltraps>

80106e27 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $197
80106e29:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e2e:	e9 96 f3 ff ff       	jmp    801061c9 <alltraps>

80106e33 <vector198>:
.globl vector198
vector198:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $198
80106e35:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e3a:	e9 8a f3 ff ff       	jmp    801061c9 <alltraps>

80106e3f <vector199>:
.globl vector199
vector199:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $199
80106e41:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e46:	e9 7e f3 ff ff       	jmp    801061c9 <alltraps>

80106e4b <vector200>:
.globl vector200
vector200:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $200
80106e4d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e52:	e9 72 f3 ff ff       	jmp    801061c9 <alltraps>

80106e57 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $201
80106e59:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e5e:	e9 66 f3 ff ff       	jmp    801061c9 <alltraps>

80106e63 <vector202>:
.globl vector202
vector202:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $202
80106e65:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e6a:	e9 5a f3 ff ff       	jmp    801061c9 <alltraps>

80106e6f <vector203>:
.globl vector203
vector203:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $203
80106e71:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e76:	e9 4e f3 ff ff       	jmp    801061c9 <alltraps>

80106e7b <vector204>:
.globl vector204
vector204:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $204
80106e7d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e82:	e9 42 f3 ff ff       	jmp    801061c9 <alltraps>

80106e87 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $205
80106e89:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e8e:	e9 36 f3 ff ff       	jmp    801061c9 <alltraps>

80106e93 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $206
80106e95:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e9a:	e9 2a f3 ff ff       	jmp    801061c9 <alltraps>

80106e9f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $207
80106ea1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ea6:	e9 1e f3 ff ff       	jmp    801061c9 <alltraps>

80106eab <vector208>:
.globl vector208
vector208:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $208
80106ead:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106eb2:	e9 12 f3 ff ff       	jmp    801061c9 <alltraps>

80106eb7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $209
80106eb9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106ebe:	e9 06 f3 ff ff       	jmp    801061c9 <alltraps>

80106ec3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $210
80106ec5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106eca:	e9 fa f2 ff ff       	jmp    801061c9 <alltraps>

80106ecf <vector211>:
.globl vector211
vector211:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $211
80106ed1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ed6:	e9 ee f2 ff ff       	jmp    801061c9 <alltraps>

80106edb <vector212>:
.globl vector212
vector212:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $212
80106edd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ee2:	e9 e2 f2 ff ff       	jmp    801061c9 <alltraps>

80106ee7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $213
80106ee9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eee:	e9 d6 f2 ff ff       	jmp    801061c9 <alltraps>

80106ef3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $214
80106ef5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106efa:	e9 ca f2 ff ff       	jmp    801061c9 <alltraps>

80106eff <vector215>:
.globl vector215
vector215:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $215
80106f01:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f06:	e9 be f2 ff ff       	jmp    801061c9 <alltraps>

80106f0b <vector216>:
.globl vector216
vector216:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $216
80106f0d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f12:	e9 b2 f2 ff ff       	jmp    801061c9 <alltraps>

80106f17 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $217
80106f19:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f1e:	e9 a6 f2 ff ff       	jmp    801061c9 <alltraps>

80106f23 <vector218>:
.globl vector218
vector218:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $218
80106f25:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f2a:	e9 9a f2 ff ff       	jmp    801061c9 <alltraps>

80106f2f <vector219>:
.globl vector219
vector219:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $219
80106f31:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f36:	e9 8e f2 ff ff       	jmp    801061c9 <alltraps>

80106f3b <vector220>:
.globl vector220
vector220:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $220
80106f3d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f42:	e9 82 f2 ff ff       	jmp    801061c9 <alltraps>

80106f47 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $221
80106f49:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f4e:	e9 76 f2 ff ff       	jmp    801061c9 <alltraps>

80106f53 <vector222>:
.globl vector222
vector222:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $222
80106f55:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f5a:	e9 6a f2 ff ff       	jmp    801061c9 <alltraps>

80106f5f <vector223>:
.globl vector223
vector223:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $223
80106f61:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f66:	e9 5e f2 ff ff       	jmp    801061c9 <alltraps>

80106f6b <vector224>:
.globl vector224
vector224:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $224
80106f6d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f72:	e9 52 f2 ff ff       	jmp    801061c9 <alltraps>

80106f77 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $225
80106f79:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f7e:	e9 46 f2 ff ff       	jmp    801061c9 <alltraps>

80106f83 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $226
80106f85:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f8a:	e9 3a f2 ff ff       	jmp    801061c9 <alltraps>

80106f8f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $227
80106f91:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f96:	e9 2e f2 ff ff       	jmp    801061c9 <alltraps>

80106f9b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $228
80106f9d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fa2:	e9 22 f2 ff ff       	jmp    801061c9 <alltraps>

80106fa7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $229
80106fa9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fae:	e9 16 f2 ff ff       	jmp    801061c9 <alltraps>

80106fb3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $230
80106fb5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fba:	e9 0a f2 ff ff       	jmp    801061c9 <alltraps>

80106fbf <vector231>:
.globl vector231
vector231:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $231
80106fc1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fc6:	e9 fe f1 ff ff       	jmp    801061c9 <alltraps>

80106fcb <vector232>:
.globl vector232
vector232:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $232
80106fcd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fd2:	e9 f2 f1 ff ff       	jmp    801061c9 <alltraps>

80106fd7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $233
80106fd9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fde:	e9 e6 f1 ff ff       	jmp    801061c9 <alltraps>

80106fe3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $234
80106fe5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fea:	e9 da f1 ff ff       	jmp    801061c9 <alltraps>

80106fef <vector235>:
.globl vector235
vector235:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $235
80106ff1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ff6:	e9 ce f1 ff ff       	jmp    801061c9 <alltraps>

80106ffb <vector236>:
.globl vector236
vector236:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $236
80106ffd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107002:	e9 c2 f1 ff ff       	jmp    801061c9 <alltraps>

80107007 <vector237>:
.globl vector237
vector237:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $237
80107009:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010700e:	e9 b6 f1 ff ff       	jmp    801061c9 <alltraps>

80107013 <vector238>:
.globl vector238
vector238:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $238
80107015:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010701a:	e9 aa f1 ff ff       	jmp    801061c9 <alltraps>

8010701f <vector239>:
.globl vector239
vector239:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $239
80107021:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107026:	e9 9e f1 ff ff       	jmp    801061c9 <alltraps>

8010702b <vector240>:
.globl vector240
vector240:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $240
8010702d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107032:	e9 92 f1 ff ff       	jmp    801061c9 <alltraps>

80107037 <vector241>:
.globl vector241
vector241:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $241
80107039:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010703e:	e9 86 f1 ff ff       	jmp    801061c9 <alltraps>

80107043 <vector242>:
.globl vector242
vector242:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $242
80107045:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010704a:	e9 7a f1 ff ff       	jmp    801061c9 <alltraps>

8010704f <vector243>:
.globl vector243
vector243:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $243
80107051:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107056:	e9 6e f1 ff ff       	jmp    801061c9 <alltraps>

8010705b <vector244>:
.globl vector244
vector244:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $244
8010705d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107062:	e9 62 f1 ff ff       	jmp    801061c9 <alltraps>

80107067 <vector245>:
.globl vector245
vector245:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $245
80107069:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010706e:	e9 56 f1 ff ff       	jmp    801061c9 <alltraps>

80107073 <vector246>:
.globl vector246
vector246:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $246
80107075:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010707a:	e9 4a f1 ff ff       	jmp    801061c9 <alltraps>

8010707f <vector247>:
.globl vector247
vector247:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $247
80107081:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107086:	e9 3e f1 ff ff       	jmp    801061c9 <alltraps>

8010708b <vector248>:
.globl vector248
vector248:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $248
8010708d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107092:	e9 32 f1 ff ff       	jmp    801061c9 <alltraps>

80107097 <vector249>:
.globl vector249
vector249:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $249
80107099:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010709e:	e9 26 f1 ff ff       	jmp    801061c9 <alltraps>

801070a3 <vector250>:
.globl vector250
vector250:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $250
801070a5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070aa:	e9 1a f1 ff ff       	jmp    801061c9 <alltraps>

801070af <vector251>:
.globl vector251
vector251:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $251
801070b1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070b6:	e9 0e f1 ff ff       	jmp    801061c9 <alltraps>

801070bb <vector252>:
.globl vector252
vector252:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $252
801070bd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070c2:	e9 02 f1 ff ff       	jmp    801061c9 <alltraps>

801070c7 <vector253>:
.globl vector253
vector253:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $253
801070c9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ce:	e9 f6 f0 ff ff       	jmp    801061c9 <alltraps>

801070d3 <vector254>:
.globl vector254
vector254:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $254
801070d5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070da:	e9 ea f0 ff ff       	jmp    801061c9 <alltraps>

801070df <vector255>:
.globl vector255
vector255:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $255
801070e1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070e6:	e9 de f0 ff ff       	jmp    801061c9 <alltraps>
801070eb:	66 90                	xchg   %ax,%ax
801070ed:	66 90                	xchg   %ax,%ax
801070ef:	90                   	nop

801070f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801070f7:	c1 ea 16             	shr    $0x16,%edx
{
801070fa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801070fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801070fe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107101:	8b 1f                	mov    (%edi),%ebx
80107103:	f6 c3 01             	test   $0x1,%bl
80107106:	74 28                	je     80107130 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107108:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010710e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107114:	89 f0                	mov    %esi,%eax
}
80107116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107119:	c1 e8 0a             	shr    $0xa,%eax
8010711c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107121:	01 d8                	add    %ebx,%eax
}
80107123:	5b                   	pop    %ebx
80107124:	5e                   	pop    %esi
80107125:	5f                   	pop    %edi
80107126:	5d                   	pop    %ebp
80107127:	c3                   	ret    
80107128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107130:	85 c9                	test   %ecx,%ecx
80107132:	74 2c                	je     80107160 <walkpgdir+0x70>
80107134:	e8 f7 b9 ff ff       	call   80102b30 <kalloc>
80107139:	89 c3                	mov    %eax,%ebx
8010713b:	85 c0                	test   %eax,%eax
8010713d:	74 21                	je     80107160 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010713f:	83 ec 04             	sub    $0x4,%esp
80107142:	68 00 10 00 00       	push   $0x1000
80107147:	6a 00                	push   $0x0
80107149:	50                   	push   %eax
8010714a:	e8 31 de ff ff       	call   80104f80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010714f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107155:	83 c4 10             	add    $0x10,%esp
80107158:	83 c8 07             	or     $0x7,%eax
8010715b:	89 07                	mov    %eax,(%edi)
8010715d:	eb b5                	jmp    80107114 <walkpgdir+0x24>
8010715f:	90                   	nop
}
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107170 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107176:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010717a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010717b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107180:	89 d6                	mov    %edx,%esi
{
80107182:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107183:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107189:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010718c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010718f:	8b 45 08             	mov    0x8(%ebp),%eax
80107192:	29 f0                	sub    %esi,%eax
80107194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107197:	eb 1f                	jmp    801071b8 <mappages+0x48>
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801071a0:	f6 00 01             	testb  $0x1,(%eax)
801071a3:	75 45                	jne    801071ea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801071a5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801071a8:	83 cb 01             	or     $0x1,%ebx
801071ab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801071ad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801071b0:	74 2e                	je     801071e0 <mappages+0x70>
      break;
    a += PGSIZE;
801071b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801071b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071bb:	b9 01 00 00 00       	mov    $0x1,%ecx
801071c0:	89 f2                	mov    %esi,%edx
801071c2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801071c5:	89 f8                	mov    %edi,%eax
801071c7:	e8 24 ff ff ff       	call   801070f0 <walkpgdir>
801071cc:	85 c0                	test   %eax,%eax
801071ce:	75 d0                	jne    801071a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071d8:	5b                   	pop    %ebx
801071d9:	5e                   	pop    %esi
801071da:	5f                   	pop    %edi
801071db:	5d                   	pop    %ebp
801071dc:	c3                   	ret    
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
      panic("remap");
801071ea:	83 ec 0c             	sub    $0xc,%esp
801071ed:	68 b4 8c 10 80       	push   $0x80108cb4
801071f2:	e8 99 91 ff ff       	call   80100390 <panic>
801071f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fe:	66 90                	xchg   %ax,%ax

80107200 <printlist>:
{
80107200:	f3 0f 1e fb          	endbr32 
80107204:	55                   	push   %ebp
80107205:	89 e5                	mov    %esp,%ebp
80107207:	56                   	push   %esi
  struct fblock *curr = myproc()->free_head;
80107208:	be 10 00 00 00       	mov    $0x10,%esi
{
8010720d:	53                   	push   %ebx
  cprintf("printing list:\n");
8010720e:	83 ec 0c             	sub    $0xc,%esp
80107211:	68 ba 8c 10 80       	push   $0x80108cba
80107216:	e8 95 94 ff ff       	call   801006b0 <cprintf>
  struct fblock *curr = myproc()->free_head;
8010721b:	e8 70 ce ff ff       	call   80104090 <myproc>
80107220:	83 c4 10             	add    $0x10,%esp
80107223:	8b 98 90 02 00 00    	mov    0x290(%eax),%ebx
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d -> ", curr->off);
80107230:	83 ec 08             	sub    $0x8,%esp
80107233:	ff 33                	pushl  (%ebx)
80107235:	68 ca 8c 10 80       	push   $0x80108cca
8010723a:	e8 71 94 ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
8010723f:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107242:	83 c4 10             	add    $0x10,%esp
80107245:	85 db                	test   %ebx,%ebx
80107247:	74 05                	je     8010724e <printlist+0x4e>
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107249:	83 ee 01             	sub    $0x1,%esi
8010724c:	75 e2                	jne    80107230 <printlist+0x30>
  cprintf("\n");
8010724e:	83 ec 0c             	sub    $0xc,%esp
80107251:	68 7a 8d 10 80       	push   $0x80108d7a
80107256:	e8 55 94 ff ff       	call   801006b0 <cprintf>
}
8010725b:	83 c4 10             	add    $0x10,%esp
8010725e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107261:	5b                   	pop    %ebx
80107262:	5e                   	pop    %esi
80107263:	5d                   	pop    %ebp
80107264:	c3                   	ret    
80107265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107270 <seginit>:
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010727a:	e8 f1 cd ff ff       	call   80104070 <cpuid>
  pd[0] = size-1;
8010727f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107284:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010728a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010728e:	c7 80 38 58 18 80 ff 	movl   $0xffff,-0x7fe7a7c8(%eax)
80107295:	ff 00 00 
80107298:	c7 80 3c 58 18 80 00 	movl   $0xcf9a00,-0x7fe7a7c4(%eax)
8010729f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072a2:	c7 80 40 58 18 80 ff 	movl   $0xffff,-0x7fe7a7c0(%eax)
801072a9:	ff 00 00 
801072ac:	c7 80 44 58 18 80 00 	movl   $0xcf9200,-0x7fe7a7bc(%eax)
801072b3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072b6:	c7 80 48 58 18 80 ff 	movl   $0xffff,-0x7fe7a7b8(%eax)
801072bd:	ff 00 00 
801072c0:	c7 80 4c 58 18 80 00 	movl   $0xcffa00,-0x7fe7a7b4(%eax)
801072c7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072ca:	c7 80 50 58 18 80 ff 	movl   $0xffff,-0x7fe7a7b0(%eax)
801072d1:	ff 00 00 
801072d4:	c7 80 54 58 18 80 00 	movl   $0xcff200,-0x7fe7a7ac(%eax)
801072db:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072de:	05 30 58 18 80       	add    $0x80185830,%eax
  pd[1] = (uint)p;
801072e3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072e7:	c1 e8 10             	shr    $0x10,%eax
801072ea:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072ee:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072f1:	0f 01 10             	lgdtl  (%eax)
}
801072f4:	c9                   	leave  
801072f5:	c3                   	ret    
801072f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fd:	8d 76 00             	lea    0x0(%esi),%esi

80107300 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107300:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107304:	a1 e4 0b 19 80       	mov    0x80190be4,%eax
80107309:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010730e:	0f 22 d8             	mov    %eax,%cr3
}
80107311:	c3                   	ret    
80107312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107320:	f3 0f 1e fb          	endbr32 
80107324:	55                   	push   %ebp
80107325:	89 e5                	mov    %esp,%ebp
80107327:	57                   	push   %edi
80107328:	56                   	push   %esi
80107329:	53                   	push   %ebx
8010732a:	83 ec 1c             	sub    $0x1c,%esp
8010732d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107330:	85 f6                	test   %esi,%esi
80107332:	0f 84 cb 00 00 00    	je     80107403 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107338:	8b 46 08             	mov    0x8(%esi),%eax
8010733b:	85 c0                	test   %eax,%eax
8010733d:	0f 84 da 00 00 00    	je     8010741d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107343:	8b 46 04             	mov    0x4(%esi),%eax
80107346:	85 c0                	test   %eax,%eax
80107348:	0f 84 c2 00 00 00    	je     80107410 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
8010734e:	e8 1d da ff ff       	call   80104d70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107353:	e8 a8 cc ff ff       	call   80104000 <mycpu>
80107358:	89 c3                	mov    %eax,%ebx
8010735a:	e8 a1 cc ff ff       	call   80104000 <mycpu>
8010735f:	89 c7                	mov    %eax,%edi
80107361:	e8 9a cc ff ff       	call   80104000 <mycpu>
80107366:	83 c7 08             	add    $0x8,%edi
80107369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010736c:	e8 8f cc ff ff       	call   80104000 <mycpu>
80107371:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107374:	ba 67 00 00 00       	mov    $0x67,%edx
80107379:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107380:	83 c0 08             	add    $0x8,%eax
80107383:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010738a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010738f:	83 c1 08             	add    $0x8,%ecx
80107392:	c1 e8 18             	shr    $0x18,%eax
80107395:	c1 e9 10             	shr    $0x10,%ecx
80107398:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010739e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073a4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073a9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073b0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073b5:	e8 46 cc ff ff       	call   80104000 <mycpu>
801073ba:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073c1:	e8 3a cc ff ff       	call   80104000 <mycpu>
801073c6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073ca:	8b 5e 08             	mov    0x8(%esi),%ebx
801073cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073d3:	e8 28 cc ff ff       	call   80104000 <mycpu>
801073d8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073db:	e8 20 cc ff ff       	call   80104000 <mycpu>
801073e0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073e4:	b8 28 00 00 00       	mov    $0x28,%eax
801073e9:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073ec:	8b 46 04             	mov    0x4(%esi),%eax
801073ef:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073f4:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801073f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073fa:	5b                   	pop    %ebx
801073fb:	5e                   	pop    %esi
801073fc:	5f                   	pop    %edi
801073fd:	5d                   	pop    %ebp
  popcli();
801073fe:	e9 bd d9 ff ff       	jmp    80104dc0 <popcli>
    panic("switchuvm: no process");
80107403:	83 ec 0c             	sub    $0xc,%esp
80107406:	68 d1 8c 10 80       	push   $0x80108cd1
8010740b:	e8 80 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107410:	83 ec 0c             	sub    $0xc,%esp
80107413:	68 fc 8c 10 80       	push   $0x80108cfc
80107418:	e8 73 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010741d:	83 ec 0c             	sub    $0xc,%esp
80107420:	68 e7 8c 10 80       	push   $0x80108ce7
80107425:	e8 66 8f ff ff       	call   80100390 <panic>
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107430 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107430:	f3 0f 1e fb          	endbr32 
80107434:	55                   	push   %ebp
80107435:	89 e5                	mov    %esp,%ebp
80107437:	57                   	push   %edi
80107438:	56                   	push   %esi
80107439:	53                   	push   %ebx
8010743a:	83 ec 1c             	sub    $0x1c,%esp
8010743d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107440:	8b 75 10             	mov    0x10(%ebp),%esi
80107443:	8b 7d 08             	mov    0x8(%ebp),%edi
80107446:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107449:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010744f:	77 4b                	ja     8010749c <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107451:	e8 da b6 ff ff       	call   80102b30 <kalloc>
  memset(mem, 0, PGSIZE);
80107456:	83 ec 04             	sub    $0x4,%esp
80107459:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010745e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107460:	6a 00                	push   $0x0
80107462:	50                   	push   %eax
80107463:	e8 18 db ff ff       	call   80104f80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107468:	58                   	pop    %eax
80107469:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010746f:	5a                   	pop    %edx
80107470:	6a 06                	push   $0x6
80107472:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107477:	31 d2                	xor    %edx,%edx
80107479:	50                   	push   %eax
8010747a:	89 f8                	mov    %edi,%eax
8010747c:	e8 ef fc ff ff       	call   80107170 <mappages>
  memmove(mem, init, sz);
80107481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107484:	89 75 10             	mov    %esi,0x10(%ebp)
80107487:	83 c4 10             	add    $0x10,%esp
8010748a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010748d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107493:	5b                   	pop    %ebx
80107494:	5e                   	pop    %esi
80107495:	5f                   	pop    %edi
80107496:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107497:	e9 84 db ff ff       	jmp    80105020 <memmove>
    panic("inituvm: more than a page");
8010749c:	83 ec 0c             	sub    $0xc,%esp
8010749f:	68 10 8d 10 80       	push   $0x80108d10
801074a4:	e8 e7 8e ff ff       	call   80100390 <panic>
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074b0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 1c             	sub    $0x1c,%esp
801074bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801074c0:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801074c3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074c8:	0f 85 99 00 00 00    	jne    80107567 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801074ce:	01 f0                	add    %esi,%eax
801074d0:	89 f3                	mov    %esi,%ebx
801074d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074d5:	8b 45 14             	mov    0x14(%ebp),%eax
801074d8:	01 f0                	add    %esi,%eax
801074da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074dd:	85 f6                	test   %esi,%esi
801074df:	75 15                	jne    801074f6 <loaduvm+0x46>
801074e1:	eb 6d                	jmp    80107550 <loaduvm+0xa0>
801074e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074e7:	90                   	nop
801074e8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074ee:	89 f0                	mov    %esi,%eax
801074f0:	29 d8                	sub    %ebx,%eax
801074f2:	39 c6                	cmp    %eax,%esi
801074f4:	76 5a                	jbe    80107550 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074f9:	8b 45 08             	mov    0x8(%ebp),%eax
801074fc:	31 c9                	xor    %ecx,%ecx
801074fe:	29 da                	sub    %ebx,%edx
80107500:	e8 eb fb ff ff       	call   801070f0 <walkpgdir>
80107505:	85 c0                	test   %eax,%eax
80107507:	74 51                	je     8010755a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107509:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010750b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010750e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107518:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010751e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107521:	29 d9                	sub    %ebx,%ecx
80107523:	05 00 00 00 80       	add    $0x80000000,%eax
80107528:	57                   	push   %edi
80107529:	51                   	push   %ecx
8010752a:	50                   	push   %eax
8010752b:	ff 75 10             	pushl  0x10(%ebp)
8010752e:	e8 6d a5 ff ff       	call   80101aa0 <readi>
80107533:	83 c4 10             	add    $0x10,%esp
80107536:	39 f8                	cmp    %edi,%eax
80107538:	74 ae                	je     801074e8 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
8010753a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010753d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107542:	5b                   	pop    %ebx
80107543:	5e                   	pop    %esi
80107544:	5f                   	pop    %edi
80107545:	5d                   	pop    %ebp
80107546:	c3                   	ret    
80107547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754e:	66 90                	xchg   %ax,%ax
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
      panic("loaduvm: address should exist");
8010755a:	83 ec 0c             	sub    $0xc,%esp
8010755d:	68 2a 8d 10 80       	push   $0x80108d2a
80107562:	e8 29 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107567:	83 ec 0c             	sub    $0xc,%esp
8010756a:	68 78 8e 10 80       	push   $0x80108e78
8010756f:	e8 1c 8e ff ff       	call   80100390 <panic>
80107574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010757b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010757f:	90                   	nop

80107580 <indexToSwap>:
  }
  return newsz;
}

uint indexToSwap()
{
80107580:	f3 0f 1e fb          	endbr32 
  return 15;
}
80107584:	b8 0f 00 00 00       	mov    $0xf,%eax
80107589:	c3                   	ret    
8010758a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107590 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107590:	f3 0f 1e fb          	endbr32 
80107594:	55                   	push   %ebp
80107595:	89 e5                	mov    %esp,%ebp
80107597:	57                   	push   %edi
80107598:	56                   	push   %esi
80107599:	53                   	push   %ebx
8010759a:	83 ec 3c             	sub    $0x3c,%esp
8010759d:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
801075a0:	e8 eb ca ff ff       	call   80104090 <myproc>
801075a5:	89 45 c0             	mov    %eax,-0x40(%ebp)

  if(newsz >= oldsz)
801075a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801075ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ae:	0f 83 9b 00 00 00    	jae    8010764f <deallocuvm+0xbf>
    return oldsz;

  a = PGROUNDUP(newsz);
801075b4:	8b 45 10             	mov    0x10(%ebp),%eax
801075b7:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075bd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
801075c3:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075c6:	77 64                	ja     8010762c <deallocuvm+0x9c>
801075c8:	e9 7f 00 00 00       	jmp    8010764c <deallocuvm+0xbc>
801075cd:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
801075d0:	8b 18                	mov    (%eax),%ebx
801075d2:	f6 c3 01             	test   $0x1,%bl
801075d5:	74 4a                	je     80107621 <deallocuvm+0x91>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801075d7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075dd:	0f 84 5f 01 00 00    	je     80107742 <deallocuvm+0x1b2>
        panic("kfree");
      char *v = P2V(pa);
      
      if(getRefs(v) == 1)
801075e3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801075e6:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801075ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
      if(getRefs(v) == 1)
801075ef:	53                   	push   %ebx
801075f0:	e8 db b6 ff ff       	call   80102cd0 <getRefs>
801075f5:	83 c4 10             	add    $0x10,%esp
801075f8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801075fb:	83 f8 01             	cmp    $0x1,%eax
801075fe:	74 60                	je     80107660 <deallocuvm+0xd0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107600:	83 ec 0c             	sub    $0xc,%esp
80107603:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107606:	53                   	push   %ebx
80107607:	e8 e4 b5 ff ff       	call   80102bf0 <refDec>
      }

      if(curproc->pid >2)
8010760c:	8b 45 c0             	mov    -0x40(%ebp),%eax
        refDec(v);
8010760f:	83 c4 10             	add    $0x10,%esp
80107612:	8b 55 c4             	mov    -0x3c(%ebp),%edx
      if(curproc->pid >2)
80107615:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107619:	7f 5d                	jg     80107678 <deallocuvm+0xe8>
          }
        }

      }
     
      *pte = 0;
8010761b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107621:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107627:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010762a:	76 20                	jbe    8010764c <deallocuvm+0xbc>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010762c:	31 c9                	xor    %ecx,%ecx
8010762e:	89 f2                	mov    %esi,%edx
80107630:	89 f8                	mov    %edi,%eax
80107632:	e8 b9 fa ff ff       	call   801070f0 <walkpgdir>
    if(!pte)
80107637:	85 c0                	test   %eax,%eax
80107639:	75 95                	jne    801075d0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
8010763b:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107641:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107647:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010764a:	77 e0                	ja     8010762c <deallocuvm+0x9c>
    }
  }
  return newsz;
8010764c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010764f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107652:	5b                   	pop    %ebx
80107653:	5e                   	pop    %esi
80107654:	5f                   	pop    %edi
80107655:	5d                   	pop    %ebp
80107656:	c3                   	ret    
80107657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765e:	66 90                	xchg   %ax,%ax
        kfree(v);
80107660:	83 ec 0c             	sub    $0xc,%esp
80107663:	53                   	push   %ebx
80107664:	e8 c7 b1 ff ff       	call   80102830 <kfree>
      if(curproc->pid >2)
80107669:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010766c:	83 c4 10             	add    $0x10,%esp
8010766f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80107672:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107676:	7e a3                	jle    8010761b <deallocuvm+0x8b>
80107678:	8d 88 88 01 00 00    	lea    0x188(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
8010767e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107681:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107687:	89 fa                	mov    %edi,%edx
80107689:	89 cf                	mov    %ecx,%edi
8010768b:	eb 13                	jmp    801076a0 <deallocuvm+0x110>
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107690:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80107693:	74 73                	je     80107708 <deallocuvm+0x178>
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107695:	83 c3 10             	add    $0x10,%ebx
80107698:	39 fb                	cmp    %edi,%ebx
8010769a:	0f 84 98 00 00 00    	je     80107738 <deallocuvm+0x1a8>
          struct page p_ram = curproc->ramPages[i];
801076a0:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
801076a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801076a9:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
801076af:	89 45 cc             	mov    %eax,-0x34(%ebp)
801076b2:	8b 83 08 01 00 00    	mov    0x108(%ebx),%eax
801076b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
801076bb:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
801076c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          struct page p_swap = curproc->swappedPages[i];
801076c4:	8b 03                	mov    (%ebx),%eax
801076c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801076c9:	8b 43 04             	mov    0x4(%ebx),%eax
801076cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
801076cf:	8b 43 08             	mov    0x8(%ebx),%eax
801076d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076d5:	8b 43 0c             	mov    0xc(%ebx),%eax
801076d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801076db:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801076de:	75 b0                	jne    80107690 <deallocuvm+0x100>
801076e0:	39 55 c8             	cmp    %edx,-0x38(%ebp)
801076e3:	75 ab                	jne    80107690 <deallocuvm+0x100>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801076e5:	83 ec 04             	sub    $0x4,%esp
801076e8:	8d 45 c8             	lea    -0x38(%ebp),%eax
801076eb:	89 55 08             	mov    %edx,0x8(%ebp)
801076ee:	6a 10                	push   $0x10
801076f0:	6a 00                	push   $0x0
801076f2:	50                   	push   %eax
801076f3:	e8 88 d8 ff ff       	call   80104f80 <memset>
801076f8:	8b 55 08             	mov    0x8(%ebp),%edx
801076fb:	83 c4 10             	add    $0x10,%esp
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801076fe:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80107701:	75 92                	jne    80107695 <deallocuvm+0x105>
80107703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107707:	90                   	nop
80107708:	39 55 d8             	cmp    %edx,-0x28(%ebp)
8010770b:	75 88                	jne    80107695 <deallocuvm+0x105>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
8010770d:	83 ec 04             	sub    $0x4,%esp
80107710:	8d 45 d8             	lea    -0x28(%ebp),%eax
80107713:	83 c3 10             	add    $0x10,%ebx
80107716:	89 55 08             	mov    %edx,0x8(%ebp)
80107719:	6a 10                	push   $0x10
8010771b:	6a 00                	push   $0x0
8010771d:	50                   	push   %eax
8010771e:	e8 5d d8 ff ff       	call   80104f80 <memset>
80107723:	8b 55 08             	mov    0x8(%ebp),%edx
80107726:	83 c4 10             	add    $0x10,%esp
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107729:	39 fb                	cmp    %edi,%ebx
8010772b:	0f 85 6f ff ff ff    	jne    801076a0 <deallocuvm+0x110>
80107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107738:	89 d7                	mov    %edx,%edi
8010773a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010773d:	e9 d9 fe ff ff       	jmp    8010761b <deallocuvm+0x8b>
        panic("kfree");
80107742:	83 ec 0c             	sub    $0xc,%esp
80107745:	68 aa 85 10 80       	push   $0x801085aa
8010774a:	e8 41 8c ff ff       	call   80100390 <panic>
8010774f:	90                   	nop

80107750 <allocuvm>:
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	57                   	push   %edi
80107758:	56                   	push   %esi
80107759:	53                   	push   %ebx
8010775a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
8010775d:	e8 2e c9 ff ff       	call   80104090 <myproc>
80107762:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80107764:	8b 45 10             	mov    0x10(%ebp),%eax
80107767:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010776a:	85 c0                	test   %eax,%eax
8010776c:	0f 88 26 02 00 00    	js     80107998 <allocuvm+0x248>
  if(newsz < oldsz)
80107772:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107775:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107778:	0f 82 a2 01 00 00    	jb     80107920 <allocuvm+0x1d0>
  a = PGROUNDUP(oldsz);
8010777e:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
80107784:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; a < newsz; a += PGSIZE){
8010778a:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010778d:	0f 87 fa 00 00 00    	ja     8010788d <allocuvm+0x13d>
80107793:	e9 8b 01 00 00       	jmp    80107923 <allocuvm+0x1d3>
80107798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779f:	90                   	nop
          kfree((char*)curproc->free_head->prev);
801077a0:	83 ec 0c             	sub    $0xc,%esp
          curproc->free_head = curproc->free_head->next;
801077a3:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
          kfree((char*)curproc->free_head->prev);
801077a9:	ff 70 08             	pushl  0x8(%eax)
801077ac:	e8 7f b0 ff ff       	call   80102830 <kfree>
801077b1:	83 c4 10             	add    $0x10,%esp
        if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
801077b4:	68 00 10 00 00       	push   $0x1000
801077b9:	56                   	push   %esi
801077ba:	ff b3 80 02 00 00    	pushl  0x280(%ebx)
801077c0:	53                   	push   %ebx
801077c1:	e8 0a ac ff ff       	call   801023d0 <writeToSwapFile>
801077c6:	83 c4 10             	add    $0x10,%esp
801077c9:	85 c0                	test   %eax,%eax
801077cb:	0f 88 5f 02 00 00    	js     80107a30 <allocuvm+0x2e0>
        curproc->swappedPages[curproc->num_swap].isused = 1;
801077d1:	8b 8b 8c 02 00 00    	mov    0x28c(%ebx),%ecx
801077d7:	89 c8                	mov    %ecx,%eax
        curproc->num_swap ++;
801077d9:	83 c1 01             	add    $0x1,%ecx
801077dc:	c1 e0 04             	shl    $0x4,%eax
801077df:	01 d8                	add    %ebx,%eax
        curproc->swappedPages[curproc->num_swap].isused = 1;
801077e1:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
801077e8:	00 00 00 
        curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
801077eb:	8b 93 80 02 00 00    	mov    0x280(%ebx),%edx
801077f1:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
801077f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
801077fa:	8b 53 04             	mov    0x4(%ebx),%edx
        curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
801077fd:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
80107803:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107809:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        curproc->num_swap ++;
8010780c:	89 8b 8c 02 00 00    	mov    %ecx,0x28c(%ebx)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107812:	8b 83 78 02 00 00    	mov    0x278(%ebx),%eax
80107818:	31 c9                	xor    %ecx,%ecx
8010781a:	e8 d1 f8 ff ff       	call   801070f0 <walkpgdir>
        if(!(*evicted_pte & PTE_P))
8010781f:	8b 10                	mov    (%eax),%edx
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107821:	89 c6                	mov    %eax,%esi
        if(!(*evicted_pte & PTE_P))
80107823:	f6 c2 01             	test   $0x1,%dl
80107826:	0f 84 f7 01 00 00    	je     80107a23 <allocuvm+0x2d3>
        char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
8010782c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        kfree(P2V(evicted_pa));
80107832:	83 ec 0c             	sub    $0xc,%esp
80107835:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010783b:	52                   	push   %edx
8010783c:	e8 ef af ff ff       	call   80102830 <kfree>
        *evicted_pte &= ~PTE_P;
80107841:	8b 06                	mov    (%esi),%eax
80107843:	25 fe 0f 00 00       	and    $0xffe,%eax
80107848:	80 cc 02             	or     $0x2,%ah
8010784b:	89 06                	mov    %eax,(%esi)
        newpage->pgdir = pgdir; // ??? 
8010784d:	8b 45 08             	mov    0x8(%ebp),%eax
        newpage->isused = 1;
80107850:	c7 83 7c 02 00 00 01 	movl   $0x1,0x27c(%ebx)
80107857:	00 00 00 
        newpage->pgdir = pgdir; // ??? 
8010785a:	89 83 78 02 00 00    	mov    %eax,0x278(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
80107860:	8b 43 04             	mov    0x4(%ebx),%eax
        newpage->swap_offset = -1;
80107863:	c7 83 84 02 00 00 ff 	movl   $0xffffffff,0x284(%ebx)
8010786a:	ff ff ff 
        newpage->virt_addr = (char*)a;
8010786d:	89 bb 80 02 00 00    	mov    %edi,0x280(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
80107873:	05 00 00 00 80       	add    $0x80000000,%eax
80107878:	0f 22 d8             	mov    %eax,%cr3
}
8010787b:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
8010787e:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107884:	39 7d 10             	cmp    %edi,0x10(%ebp)
80107887:	0f 86 96 00 00 00    	jbe    80107923 <allocuvm+0x1d3>
    mem = kalloc();
8010788d:	e8 9e b2 ff ff       	call   80102b30 <kalloc>
80107892:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107894:	85 c0                	test   %eax,%eax
80107896:	0f 84 14 01 00 00    	je     801079b0 <allocuvm+0x260>
    memset(mem, 0, PGSIZE);
8010789c:	83 ec 04             	sub    $0x4,%esp
8010789f:	68 00 10 00 00       	push   $0x1000
801078a4:	6a 00                	push   $0x0
801078a6:	50                   	push   %eax
801078a7:	e8 d4 d6 ff ff       	call   80104f80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078ac:	58                   	pop    %eax
801078ad:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801078b3:	5a                   	pop    %edx
801078b4:	6a 06                	push   $0x6
801078b6:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078bb:	89 fa                	mov    %edi,%edx
801078bd:	50                   	push   %eax
801078be:	8b 45 08             	mov    0x8(%ebp),%eax
801078c1:	e8 aa f8 ff ff       	call   80107170 <mappages>
801078c6:	83 c4 10             	add    $0x10,%esp
801078c9:	85 c0                	test   %eax,%eax
801078cb:	0f 88 17 01 00 00    	js     801079e8 <allocuvm+0x298>
    if(curproc->pid > 2) {
801078d1:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801078d5:	7e a7                	jle    8010787e <allocuvm+0x12e>
      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801078d7:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
801078de:	7e 50                	jle    80107930 <allocuvm+0x1e0>
        int swap_offset = curproc->free_head->off;
801078e0:	8b 93 90 02 00 00    	mov    0x290(%ebx),%edx
        if(curproc->free_head->next == 0)
801078e6:	8b 42 04             	mov    0x4(%edx),%eax
        int swap_offset = curproc->free_head->off;
801078e9:	8b 32                	mov    (%edx),%esi
        if(curproc->free_head->next == 0)
801078eb:	85 c0                	test   %eax,%eax
801078ed:	0f 85 ad fe ff ff    	jne    801077a0 <allocuvm+0x50>
          curproc->free_tail = 0;
801078f3:	c7 83 94 02 00 00 00 	movl   $0x0,0x294(%ebx)
801078fa:	00 00 00 
          kfree((char*)curproc->free_head);
801078fd:	83 ec 0c             	sub    $0xc,%esp
80107900:	52                   	push   %edx
80107901:	e8 2a af ff ff       	call   80102830 <kfree>
          curproc->free_head = 0;
80107906:	83 c4 10             	add    $0x10,%esp
80107909:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
80107910:	00 00 00 
80107913:	e9 9c fe ff ff       	jmp    801077b4 <allocuvm+0x64>
80107918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010791f:	90                   	nop
    return oldsz;
80107920:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
80107923:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107926:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107929:	5b                   	pop    %ebx
8010792a:	5e                   	pop    %esi
8010792b:	5f                   	pop    %edi
8010792c:	5d                   	pop    %ebp
8010792d:	c3                   	ret    
8010792e:	66 90                	xchg   %ax,%ax

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80107930:	e8 5b c7 ff ff       	call   80104090 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107935:	31 d2                	xor    %edx,%edx
80107937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010793e:	66 90                	xchg   %ax,%ax
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107940:	89 d1                	mov    %edx,%ecx
80107942:	c1 e1 04             	shl    $0x4,%ecx
80107945:	8b 8c 08 8c 01 00 00 	mov    0x18c(%eax,%ecx,1),%ecx
8010794c:	85 c9                	test   %ecx,%ecx
8010794e:	74 0d                	je     8010795d <allocuvm+0x20d>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107950:	83 c2 01             	add    $0x1,%edx
80107953:	83 fa 10             	cmp    $0x10,%edx
80107956:	75 e8                	jne    80107940 <allocuvm+0x1f0>
      return i;
  }
  return -1;
80107958:	ba ff ff ff ff       	mov    $0xffffffff,%edx
          page->pgdir = pgdir;
8010795d:	8b 45 08             	mov    0x8(%ebp),%eax
80107960:	c1 e2 04             	shl    $0x4,%edx
80107963:	01 da                	add    %ebx,%edx
          page->isused = 1;
80107965:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
8010796c:	00 00 00 
          page->pgdir = pgdir;
8010796f:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
          page->swap_offset = -1;
80107975:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
8010797c:	ff ff ff 
          page->virt_addr = (char*)a;
8010797f:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
          curproc->num_ram++;
80107985:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
8010798c:	e9 ed fe ff ff       	jmp    8010787e <allocuvm+0x12e>
80107991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80107998:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010799f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a5:	5b                   	pop    %ebx
801079a6:	5e                   	pop    %esi
801079a7:	5f                   	pop    %edi
801079a8:	5d                   	pop    %ebp
801079a9:	c3                   	ret    
801079aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	68 48 8d 10 80       	push   $0x80108d48
801079b8:	e8 f3 8c ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801079bd:	83 c4 0c             	add    $0xc,%esp
801079c0:	ff 75 0c             	pushl  0xc(%ebp)
801079c3:	ff 75 10             	pushl  0x10(%ebp)
801079c6:	ff 75 08             	pushl  0x8(%ebp)
801079c9:	e8 c2 fb ff ff       	call   80107590 <deallocuvm>
      return 0;
801079ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079d5:	83 c4 10             	add    $0x10,%esp
}
801079d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079de:	5b                   	pop    %ebx
801079df:	5e                   	pop    %esi
801079e0:	5f                   	pop    %edi
801079e1:	5d                   	pop    %ebp
801079e2:	c3                   	ret    
801079e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079e7:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
801079e8:	83 ec 0c             	sub    $0xc,%esp
801079eb:	68 60 8d 10 80       	push   $0x80108d60
801079f0:	e8 bb 8c ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801079f5:	83 c4 0c             	add    $0xc,%esp
801079f8:	ff 75 0c             	pushl  0xc(%ebp)
801079fb:	ff 75 10             	pushl  0x10(%ebp)
801079fe:	ff 75 08             	pushl  0x8(%ebp)
80107a01:	e8 8a fb ff ff       	call   80107590 <deallocuvm>
      kfree(mem);
80107a06:	89 34 24             	mov    %esi,(%esp)
80107a09:	e8 22 ae ff ff       	call   80102830 <kfree>
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
          panic("allocuvm: swap: ram page not present");
80107a23:	83 ec 0c             	sub    $0xc,%esp
80107a26:	68 9c 8e 10 80       	push   $0x80108e9c
80107a2b:	e8 60 89 ff ff       	call   80100390 <panic>
          panic("allocuvm: writeToSwapFile");
80107a30:	83 ec 0c             	sub    $0xc,%esp
80107a33:	68 7c 8d 10 80       	push   $0x80108d7c
80107a38:	e8 53 89 ff ff       	call   80100390 <panic>
80107a3d:	8d 76 00             	lea    0x0(%esi),%esi

80107a40 <freevm>:
{
80107a40:	f3 0f 1e fb          	endbr32 
80107a44:	55                   	push   %ebp
80107a45:	89 e5                	mov    %esp,%ebp
80107a47:	57                   	push   %edi
80107a48:	56                   	push   %esi
80107a49:	53                   	push   %ebx
80107a4a:	83 ec 0c             	sub    $0xc,%esp
80107a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
80107a50:	85 f6                	test   %esi,%esi
80107a52:	74 5d                	je     80107ab1 <freevm+0x71>
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107a54:	83 ec 04             	sub    $0x4,%esp
80107a57:	89 f3                	mov    %esi,%ebx
80107a59:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a5f:	6a 00                	push   $0x0
80107a61:	68 00 00 00 80       	push   $0x80000000
80107a66:	56                   	push   %esi
80107a67:	e8 24 fb ff ff       	call   80107590 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107a6c:	83 c4 10             	add    $0x10,%esp
80107a6f:	eb 0e                	jmp    80107a7f <freevm+0x3f>
80107a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a78:	83 c3 04             	add    $0x4,%ebx
80107a7b:	39 df                	cmp    %ebx,%edi
80107a7d:	74 23                	je     80107aa2 <freevm+0x62>
    if(pgdir[i] & PTE_P){
80107a7f:	8b 03                	mov    (%ebx),%eax
80107a81:	a8 01                	test   $0x1,%al
80107a83:	74 f3                	je     80107a78 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107a8a:	83 ec 0c             	sub    $0xc,%esp
80107a8d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a90:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107a95:	50                   	push   %eax
80107a96:	e8 95 ad ff ff       	call   80102830 <kfree>
80107a9b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a9e:	39 df                	cmp    %ebx,%edi
80107aa0:	75 dd                	jne    80107a7f <freevm+0x3f>
  kfree((char*)pgdir);
80107aa2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aa8:	5b                   	pop    %ebx
80107aa9:	5e                   	pop    %esi
80107aaa:	5f                   	pop    %edi
80107aab:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107aac:	e9 7f ad ff ff       	jmp    80102830 <kfree>
    panic("freevm: no pgdir");
80107ab1:	83 ec 0c             	sub    $0xc,%esp
80107ab4:	68 96 8d 10 80       	push   $0x80108d96
80107ab9:	e8 d2 88 ff ff       	call   80100390 <panic>
80107abe:	66 90                	xchg   %ax,%ax

80107ac0 <setupkvm>:
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	56                   	push   %esi
80107ac8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ac9:	e8 62 b0 ff ff       	call   80102b30 <kalloc>
80107ace:	89 c6                	mov    %eax,%esi
80107ad0:	85 c0                	test   %eax,%eax
80107ad2:	74 42                	je     80107b16 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107ad4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ad7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107adc:	68 00 10 00 00       	push   $0x1000
80107ae1:	6a 00                	push   $0x0
80107ae3:	50                   	push   %eax
80107ae4:	e8 97 d4 ff ff       	call   80104f80 <memset>
80107ae9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107aec:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107aef:	83 ec 08             	sub    $0x8,%esp
80107af2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107af5:	ff 73 0c             	pushl  0xc(%ebx)
80107af8:	8b 13                	mov    (%ebx),%edx
80107afa:	50                   	push   %eax
80107afb:	29 c1                	sub    %eax,%ecx
80107afd:	89 f0                	mov    %esi,%eax
80107aff:	e8 6c f6 ff ff       	call   80107170 <mappages>
80107b04:	83 c4 10             	add    $0x10,%esp
80107b07:	85 c0                	test   %eax,%eax
80107b09:	78 15                	js     80107b20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b0b:	83 c3 10             	add    $0x10,%ebx
80107b0e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107b14:	75 d6                	jne    80107aec <setupkvm+0x2c>
}
80107b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b19:	89 f0                	mov    %esi,%eax
80107b1b:	5b                   	pop    %ebx
80107b1c:	5e                   	pop    %esi
80107b1d:	5d                   	pop    %ebp
80107b1e:	c3                   	ret    
80107b1f:	90                   	nop
      cprintf("mappages failed on setupkvm");
80107b20:	83 ec 0c             	sub    $0xc,%esp
80107b23:	68 a7 8d 10 80       	push   $0x80108da7
80107b28:	e8 83 8b ff ff       	call   801006b0 <cprintf>
      freevm(pgdir);
80107b2d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107b30:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b32:	e8 09 ff ff ff       	call   80107a40 <freevm>
      return 0;
80107b37:	83 c4 10             	add    $0x10,%esp
}
80107b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b3d:	89 f0                	mov    %esi,%eax
80107b3f:	5b                   	pop    %ebx
80107b40:	5e                   	pop    %esi
80107b41:	5d                   	pop    %ebp
80107b42:	c3                   	ret    
80107b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <kvmalloc>:
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b5a:	e8 61 ff ff ff       	call   80107ac0 <setupkvm>
80107b5f:	a3 e4 0b 19 80       	mov    %eax,0x80190be4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b64:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b69:	0f 22 d8             	mov    %eax,%cr3
}
80107b6c:	c9                   	leave  
80107b6d:	c3                   	ret    
80107b6e:	66 90                	xchg   %ax,%ax

80107b70 <clearpteu>:
{
80107b70:	f3 0f 1e fb          	endbr32 
80107b74:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107b75:	31 c9                	xor    %ecx,%ecx
{
80107b77:	89 e5                	mov    %esp,%ebp
80107b79:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b82:	e8 69 f5 ff ff       	call   801070f0 <walkpgdir>
  if(pte == 0)
80107b87:	85 c0                	test   %eax,%eax
80107b89:	74 05                	je     80107b90 <clearpteu+0x20>
  *pte &= ~PTE_U;
80107b8b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b8e:	c9                   	leave  
80107b8f:	c3                   	ret    
    panic("clearpteu");
80107b90:	83 ec 0c             	sub    $0xc,%esp
80107b93:	68 c3 8d 10 80       	push   $0x80108dc3
80107b98:	e8 f3 87 ff ff       	call   80100390 <panic>
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi

80107ba0 <cowuvm>:
{
80107ba0:	f3 0f 1e fb          	endbr32 
80107ba4:	55                   	push   %ebp
80107ba5:	89 e5                	mov    %esp,%ebp
80107ba7:	57                   	push   %edi
80107ba8:	56                   	push   %esi
80107ba9:	53                   	push   %ebx
80107baa:	83 ec 0c             	sub    $0xc,%esp
  if((d = setupkvm()) == 0)
80107bad:	e8 0e ff ff ff       	call   80107ac0 <setupkvm>
80107bb2:	89 c6                	mov    %eax,%esi
80107bb4:	85 c0                	test   %eax,%eax
80107bb6:	0f 84 9a 00 00 00    	je     80107c56 <cowuvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE)
80107bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bbf:	85 c0                	test   %eax,%eax
80107bc1:	0f 84 8f 00 00 00    	je     80107c56 <cowuvm+0xb6>
80107bc7:	31 ff                	xor    %edi,%edi
80107bc9:	eb 25                	jmp    80107bf0 <cowuvm+0x50>
80107bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bcf:	90                   	nop
    refInc(virt_addr);
80107bd0:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107bd3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    refInc(virt_addr);
80107bd9:	53                   	push   %ebx
80107bda:	e8 81 b0 ff ff       	call   80102c60 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107bdf:	0f 01 3f             	invlpg (%edi)
  for(i = 0; i < sz; i += PGSIZE)
80107be2:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107be8:	83 c4 10             	add    $0x10,%esp
80107beb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107bee:	76 66                	jbe    80107c56 <cowuvm+0xb6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf3:	31 c9                	xor    %ecx,%ecx
80107bf5:	89 fa                	mov    %edi,%edx
80107bf7:	e8 f4 f4 ff ff       	call   801070f0 <walkpgdir>
80107bfc:	85 c0                	test   %eax,%eax
80107bfe:	74 6d                	je     80107c6d <cowuvm+0xcd>
    if(!(*pte & PTE_P))
80107c00:	8b 08                	mov    (%eax),%ecx
80107c02:	f6 c1 01             	test   $0x1,%cl
80107c05:	74 59                	je     80107c60 <cowuvm+0xc0>
    *pte &= ~PTE_W;
80107c07:	89 cb                	mov    %ecx,%ebx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c09:	83 ec 08             	sub    $0x8,%esp
80107c0c:	89 fa                	mov    %edi,%edx
    *pte &= ~PTE_W;
80107c0e:	83 e3 fd             	and    $0xfffffffd,%ebx
80107c11:	80 cf 04             	or     $0x4,%bh
80107c14:	89 18                	mov    %ebx,(%eax)
    pa = PTE_ADDR(*pte);
80107c16:	89 cb                	mov    %ecx,%ebx
    flags = PTE_FLAGS(*pte);
80107c18:	81 e1 fd 0f 00 00    	and    $0xffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c1e:	89 f0                	mov    %esi,%eax
    flags = PTE_FLAGS(*pte);
80107c20:	80 cd 04             	or     $0x4,%ch
80107c23:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c29:	51                   	push   %ecx
80107c2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c2f:	53                   	push   %ebx
80107c30:	e8 3b f5 ff ff       	call   80107170 <mappages>
80107c35:	83 c4 10             	add    $0x10,%esp
80107c38:	85 c0                	test   %eax,%eax
80107c3a:	79 94                	jns    80107bd0 <cowuvm+0x30>
  cprintf("bad: cowuvm\n");
80107c3c:	83 ec 0c             	sub    $0xc,%esp
80107c3f:	68 f5 8d 10 80       	push   $0x80108df5
80107c44:	e8 67 8a ff ff       	call   801006b0 <cprintf>
  freevm(d);
80107c49:	89 34 24             	mov    %esi,(%esp)
  return 0;
80107c4c:	31 f6                	xor    %esi,%esi
  freevm(d);
80107c4e:	e8 ed fd ff ff       	call   80107a40 <freevm>
  return 0;
80107c53:	83 c4 10             	add    $0x10,%esp
}
80107c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c59:	89 f0                	mov    %esi,%eax
80107c5b:	5b                   	pop    %ebx
80107c5c:	5e                   	pop    %esi
80107c5d:	5f                   	pop    %edi
80107c5e:	5d                   	pop    %ebp
80107c5f:	c3                   	ret    
      panic("cowuvm: page not present");
80107c60:	83 ec 0c             	sub    $0xc,%esp
80107c63:	68 dc 8d 10 80       	push   $0x80108ddc
80107c68:	e8 23 87 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107c6d:	83 ec 0c             	sub    $0xc,%esp
80107c70:	68 cd 8d 10 80       	push   $0x80108dcd
80107c75:	e8 16 87 ff ff       	call   80100390 <panic>
80107c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c80 <getSwappedPageIndex>:
{
80107c80:	f3 0f 1e fb          	endbr32 
80107c84:	55                   	push   %ebp
80107c85:	89 e5                	mov    %esp,%ebp
80107c87:	53                   	push   %ebx
80107c88:	83 ec 04             	sub    $0x4,%esp
80107c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107c8e:	e8 fd c3 ff ff       	call   80104090 <myproc>
80107c93:	89 c1                	mov    %eax,%ecx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107c95:	31 c0                	xor    %eax,%eax
80107c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c9e:	66 90                	xchg   %ax,%ax
    if(curproc->swappedPages[i].virt_addr == va)
80107ca0:	89 c2                	mov    %eax,%edx
80107ca2:	c1 e2 04             	shl    $0x4,%edx
80107ca5:	39 9c 11 90 00 00 00 	cmp    %ebx,0x90(%ecx,%edx,1)
80107cac:	74 0d                	je     80107cbb <getSwappedPageIndex+0x3b>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107cae:	83 c0 01             	add    $0x1,%eax
80107cb1:	83 f8 10             	cmp    $0x10,%eax
80107cb4:	75 ea                	jne    80107ca0 <getSwappedPageIndex+0x20>
  return -1;
80107cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107cbb:	83 c4 04             	add    $0x4,%esp
80107cbe:	5b                   	pop    %ebx
80107cbf:	5d                   	pop    %ebp
80107cc0:	c3                   	ret    
80107cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ccf:	90                   	nop

80107cd0 <pagefault>:
{
80107cd0:	f3 0f 1e fb          	endbr32 
80107cd4:	55                   	push   %ebp
80107cd5:	89 e5                	mov    %esp,%ebp
80107cd7:	57                   	push   %edi
80107cd8:	56                   	push   %esi
80107cd9:	53                   	push   %ebx
80107cda:	83 ec 1c             	sub    $0x1c,%esp
  printlist();
80107cdd:	e8 1e f5 ff ff       	call   80107200 <printlist>
  struct proc* curproc = myproc();
80107ce2:	e8 a9 c3 ff ff       	call   80104090 <myproc>
80107ce7:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107ce9:	0f 20 d3             	mov    %cr2,%ebx
  uint err = curproc->tf->err;
80107cec:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107cef:	89 df                	mov    %ebx,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107cf1:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107cf3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  uint err = curproc->tf->err;
80107cf9:	8b 40 34             	mov    0x34(%eax),%eax
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107cfc:	89 fa                	mov    %edi,%edx
  uint err = curproc->tf->err;
80107cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d01:	8b 46 04             	mov    0x4(%esi),%eax
80107d04:	e8 e7 f3 ff ff       	call   801070f0 <walkpgdir>
  if(*pte & PTE_PG) // page was paged out
80107d09:	f7 00 00 02 00 00    	testl  $0x200,(%eax)
80107d0f:	0f 84 bb 01 00 00    	je     80107ed0 <pagefault+0x200>
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80107d15:	83 ec 04             	sub    $0x4,%esp
80107d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d1b:	8d 46 6c             	lea    0x6c(%esi),%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d1e:	31 db                	xor    %ebx,%ebx
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80107d20:	ff 76 10             	pushl  0x10(%esi)
80107d23:	50                   	push   %eax
80107d24:	68 c4 8e 10 80       	push   $0x80108ec4
80107d29:	e8 82 89 ff ff       	call   801006b0 <cprintf>
    new_page = kalloc();
80107d2e:	e8 fd ad ff ff       	call   80102b30 <kalloc>
    *pte |= V2P(new_page);
80107d33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    new_page = kalloc();
80107d36:	89 c1                	mov    %eax,%ecx
    *pte |= V2P(new_page);
80107d38:	8b 02                	mov    (%edx),%eax
80107d3a:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107d40:	25 ff 0d 00 00       	and    $0xdff,%eax
80107d45:	09 c8                	or     %ecx,%eax
80107d47:	83 c8 07             	or     $0x7,%eax
80107d4a:	89 02                	mov    %eax,(%edx)
  struct proc* curproc = myproc();
80107d4c:	e8 3f c3 ff ff       	call   80104090 <myproc>
80107d51:	83 c4 10             	add    $0x10,%esp
80107d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->swappedPages[i].virt_addr == va)
80107d58:	89 da                	mov    %ebx,%edx
80107d5a:	c1 e2 04             	shl    $0x4,%edx
80107d5d:	3b bc 10 90 00 00 00 	cmp    0x90(%eax,%edx,1),%edi
80107d64:	0f 84 a6 01 00 00    	je     80107f10 <pagefault+0x240>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d6a:	83 c3 01             	add    $0x1,%ebx
80107d6d:	83 fb 10             	cmp    $0x10,%ebx
80107d70:	75 e6                	jne    80107d58 <pagefault+0x88>
80107d72:	b8 78 00 00 00       	mov    $0x78,%eax
  return -1;
80107d77:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    struct page *swap_page = &curproc->swappedPages[index];
80107d7c:	c1 e3 04             	shl    $0x4,%ebx
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107d7f:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80107d84:	01 f0                	add    %esi,%eax
80107d86:	01 f3                	add    %esi,%ebx
80107d88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107d8b:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80107d91:	68 00 c6 10 80       	push   $0x8010c600
80107d96:	56                   	push   %esi
80107d97:	e8 64 a6 ff ff       	call   80102400 <readFromSwapFile>
80107d9c:	83 c4 10             	add    $0x10,%esp
80107d9f:	85 c0                	test   %eax,%eax
80107da1:	0f 88 cf 02 00 00    	js     80108076 <pagefault+0x3a6>
    struct fblock *new_block = (struct fblock*)kalloc();
80107da7:	e8 84 ad ff ff       	call   80102b30 <kalloc>
    new_block->off = swap_page->swap_offset;
80107dac:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
    new_block->next = 0;
80107db2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80107db9:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80107dbb:	8b 96 94 02 00 00    	mov    0x294(%esi),%edx
80107dc1:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80107dc4:	85 d2                	test   %edx,%edx
80107dc6:	0f 84 c4 01 00 00    	je     80107f90 <pagefault+0x2c0>
      curproc->free_tail->next = new_block;
80107dcc:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80107dcf:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80107dd2:	89 86 94 02 00 00    	mov    %eax,0x294(%esi)
    memmove((void*)start_page, buffer, PGSIZE);
80107dd8:	68 00 10 00 00       	push   $0x1000
80107ddd:	68 00 c6 10 80       	push   $0x8010c600
80107de2:	57                   	push   %edi
80107de3:	e8 38 d2 ff ff       	call   80105020 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80107de8:	83 c4 0c             	add    $0xc,%esp
80107deb:	6a 10                	push   $0x10
80107ded:	6a 00                	push   $0x0
80107def:	ff 75 e4             	pushl  -0x1c(%ebp)
80107df2:	e8 89 d1 ff ff       	call   80104f80 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80107df7:	83 c4 10             	add    $0x10,%esp
80107dfa:	83 be 88 02 00 00 0f 	cmpl   $0xf,0x288(%esi)
80107e01:	0f 8e c1 01 00 00    	jle    80107fc8 <pagefault+0x2f8>
      int swap_offset = curproc->free_head->off;
80107e07:	8b 96 90 02 00 00    	mov    0x290(%esi),%edx
80107e0d:	8b 02                	mov    (%edx),%eax
80107e0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80107e12:	8b 42 04             	mov    0x4(%edx),%eax
80107e15:	85 c0                	test   %eax,%eax
80107e17:	0f 84 83 01 00 00    	je     80107fa0 <pagefault+0x2d0>
        kfree((char*)curproc->free_head->prev);
80107e1d:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107e20:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
        kfree((char*)curproc->free_head->prev);
80107e26:	ff 70 08             	pushl  0x8(%eax)
80107e29:	e8 02 aa ff ff       	call   80102830 <kfree>
80107e2e:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80107e31:	68 00 10 00 00       	push   $0x1000
80107e36:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e39:	ff b6 80 02 00 00    	pushl  0x280(%esi)
80107e3f:	56                   	push   %esi
80107e40:	e8 8b a5 ff ff       	call   801023d0 <writeToSwapFile>
80107e45:	83 c4 10             	add    $0x10,%esp
80107e48:	85 c0                	test   %eax,%eax
80107e4a:	0f 88 33 02 00 00    	js     80108083 <pagefault+0x3b3>
      swap_page->virt_addr = ram_page->virt_addr;
80107e50:	8b 96 80 02 00 00    	mov    0x280(%esi),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107e56:	31 c9                	xor    %ecx,%ecx
      swap_page->virt_addr = ram_page->virt_addr;
80107e58:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
      swap_page->pgdir = ram_page->pgdir;
80107e5e:	8b 86 78 02 00 00    	mov    0x278(%esi),%eax
      swap_page->isused = 1;
80107e64:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80107e6b:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80107e6e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
      swap_page->swap_offset = swap_offset;
80107e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e77:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107e7d:	8b 46 04             	mov    0x4(%esi),%eax
80107e80:	e8 6b f2 ff ff       	call   801070f0 <walkpgdir>
      if(!(*pte & PTE_P))
80107e85:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107e87:	89 c3                	mov    %eax,%ebx
      if(!(*pte & PTE_P))
80107e89:	f6 c2 01             	test   $0x1,%dl
80107e8c:	0f 84 fe 01 00 00    	je     80108090 <pagefault+0x3c0>
      ramPa = (void*)PTE_ADDR(*pte);
80107e92:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80107e98:	83 ec 0c             	sub    $0xc,%esp
80107e9b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107ea1:	52                   	push   %edx
80107ea2:	e8 89 a9 ff ff       	call   80102830 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80107ea7:	8b 03                	mov    (%ebx),%eax
80107ea9:	25 fe 0f 00 00       	and    $0xffe,%eax
80107eae:	80 cc 02             	or     $0x2,%ah
80107eb1:	89 03                	mov    %eax,(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107eb3:	8b 46 04             	mov    0x4(%esi),%eax
80107eb6:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ebb:	0f 22 d8             	mov    %eax,%cr3
      ram_page->virt_addr = start_page;
80107ebe:	89 be 80 02 00 00    	mov    %edi,0x280(%esi)
80107ec4:	83 c4 10             	add    $0x10,%esp
}
80107ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eca:	5b                   	pop    %ebx
80107ecb:	5e                   	pop    %esi
80107ecc:	5f                   	pop    %edi
80107ecd:	5d                   	pop    %ebp
80107ece:	c3                   	ret    
80107ecf:	90                   	nop
      cprintf("page was not paged out\n");
80107ed0:	83 ec 0c             	sub    $0xc,%esp
80107ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ed6:	68 1d 8e 10 80       	push   $0x80108e1d
80107edb:	e8 d0 87 ff ff       	call   801006b0 <cprintf>
    if(va >= KERNBASE || pte == 0)
80107ee0:	83 c4 10             	add    $0x10,%esp
80107ee3:	85 db                	test   %ebx,%ebx
80107ee5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107ee8:	78 76                	js     80107f60 <pagefault+0x290>
  if(err & FEC_WR)
80107eea:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
80107eee:	74 0a                	je     80107efa <pagefault+0x22a>
    if(!(*pte & PTE_COW)) 
80107ef0:	8b 3a                	mov    (%edx),%edi
80107ef2:	f7 c7 00 04 00 00    	test   $0x400,%edi
80107ef8:	75 26                	jne    80107f20 <pagefault+0x250>
    curproc->killed = 1;
80107efa:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
}
80107f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f04:	5b                   	pop    %ebx
80107f05:	5e                   	pop    %esi
80107f06:	5f                   	pop    %edi
80107f07:	5d                   	pop    %ebp
80107f08:	c3                   	ret    
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f10:	89 d8                	mov    %ebx,%eax
80107f12:	c1 e0 04             	shl    $0x4,%eax
80107f15:	05 88 00 00 00       	add    $0x88,%eax
80107f1a:	e9 5d fe ff ff       	jmp    80107d7c <pagefault+0xac>
80107f1f:	90                   	nop
      pa = PTE_ADDR(*pte);
80107f20:	89 fe                	mov    %edi,%esi
      ref_count = getRefs(virt_addr);
80107f22:	83 ec 0c             	sub    $0xc,%esp
80107f25:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107f28:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      char *virt_addr = P2V(pa);
80107f2e:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      ref_count = getRefs(virt_addr);
80107f34:	56                   	push   %esi
80107f35:	e8 96 ad ff ff       	call   80102cd0 <getRefs>
      if (ref_count > 1) // more than one reference
80107f3a:	83 c4 10             	add    $0x10,%esp
80107f3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f40:	83 f8 01             	cmp    $0x1,%eax
80107f43:	0f 8f e7 00 00 00    	jg     80108030 <pagefault+0x360>
        *pte &= ~PTE_COW; // turn COW off
80107f49:	8b 02                	mov    (%edx),%eax
80107f4b:	80 e4 fb             	and    $0xfb,%ah
80107f4e:	83 c8 02             	or     $0x2,%eax
80107f51:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107f53:	0f 01 3b             	invlpg (%ebx)
}  
80107f56:	e9 6c ff ff ff       	jmp    80107ec7 <pagefault+0x1f7>
80107f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f5f:	90                   	nop
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80107f60:	83 ec 04             	sub    $0x4,%esp
80107f63:	8d 46 6c             	lea    0x6c(%esi),%eax
80107f66:	50                   	push   %eax
80107f67:	ff 76 10             	pushl  0x10(%esi)
80107f6a:	68 18 8f 10 80       	push   $0x80108f18
80107f6f:	e8 3c 87 ff ff       	call   801006b0 <cprintf>
      curproc->killed = 1;
80107f74:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
      return;
80107f7b:	83 c4 10             	add    $0x10,%esp
}
80107f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f81:	5b                   	pop    %ebx
80107f82:	5e                   	pop    %esi
80107f83:	5f                   	pop    %edi
80107f84:	5d                   	pop    %ebp
80107f85:	c3                   	ret    
80107f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f8d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->free_head = new_block;
80107f90:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
80107f96:	e9 34 fe ff ff       	jmp    80107dcf <pagefault+0xff>
80107f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f9f:	90                   	nop
        curproc->free_tail = 0;
80107fa0:	c7 86 94 02 00 00 00 	movl   $0x0,0x294(%esi)
80107fa7:	00 00 00 
        kfree((char*)curproc->free_head);
80107faa:	83 ec 0c             	sub    $0xc,%esp
80107fad:	52                   	push   %edx
80107fae:	e8 7d a8 ff ff       	call   80102830 <kfree>
        curproc->free_head = 0;
80107fb3:	83 c4 10             	add    $0x10,%esp
80107fb6:	c7 86 90 02 00 00 00 	movl   $0x0,0x290(%esi)
80107fbd:	00 00 00 
80107fc0:	e9 6c fe ff ff       	jmp    80107e31 <pagefault+0x161>
80107fc5:	8d 76 00             	lea    0x0(%esi),%esi
  struct proc * currproc = myproc();
80107fc8:	e8 c3 c0 ff ff       	call   80104090 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107fcd:	31 d2                	xor    %edx,%edx
80107fcf:	90                   	nop
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107fd0:	89 d1                	mov    %edx,%ecx
80107fd2:	c1 e1 04             	shl    $0x4,%ecx
80107fd5:	8b 8c 08 8c 01 00 00 	mov    0x18c(%eax,%ecx,1),%ecx
80107fdc:	85 c9                	test   %ecx,%ecx
80107fde:	74 0d                	je     80107fed <pagefault+0x31d>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107fe0:	83 c2 01             	add    $0x1,%edx
80107fe3:	83 fa 10             	cmp    $0x10,%edx
80107fe6:	75 e8                	jne    80107fd0 <pagefault+0x300>
  return -1;
80107fe8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
      curproc->ramPages[new_indx].virt_addr = start_page;
80107fed:	c1 e2 04             	shl    $0x4,%edx
80107ff0:	01 f2                	add    %esi,%edx
80107ff2:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
      curproc->ramPages[new_indx].isused = 1;
80107ff8:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107fff:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108002:	8b 46 04             	mov    0x4(%esi),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108005:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
8010800c:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
8010800f:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
      curproc->num_ram++;      
80108015:	83 86 88 02 00 00 01 	addl   $0x1,0x288(%esi)
      curproc->num_swap--;
8010801c:	83 ae 8c 02 00 00 01 	subl   $0x1,0x28c(%esi)
}
80108023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108026:	5b                   	pop    %ebx
80108027:	5e                   	pop    %esi
80108028:	5f                   	pop    %edi
80108029:	5d                   	pop    %ebp
8010802a:	c3                   	ret    
8010802b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010802f:	90                   	nop
80108030:	89 55 e0             	mov    %edx,-0x20(%ebp)
      flags = PTE_FLAGS(*pte);
80108033:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
        new_page = kalloc();
80108039:	e8 f2 aa ff ff       	call   80102b30 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
8010803e:	83 ec 04             	sub    $0x4,%esp
80108041:	68 00 10 00 00       	push   $0x1000
80108046:	56                   	push   %esi
80108047:	50                   	push   %eax
80108048:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010804b:	e8 d0 cf ff ff       	call   80105020 <memmove>
        new_pa = V2P(new_page);
80108050:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108053:	8b 55 e0             	mov    -0x20(%ebp),%edx
        new_pa = V2P(new_page);
80108056:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
8010805c:	09 cf                	or     %ecx,%edi
8010805e:	83 cf 03             	or     $0x3,%edi
80108061:	89 3a                	mov    %edi,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108063:	0f 01 3b             	invlpg (%ebx)
        refDec(virt_addr); // decrement old page's ref count
80108066:	89 34 24             	mov    %esi,(%esp)
80108069:	e8 82 ab ff ff       	call   80102bf0 <refDec>
8010806e:	83 c4 10             	add    $0x10,%esp
80108071:	e9 51 fe ff ff       	jmp    80107ec7 <pagefault+0x1f7>
      panic("allocuvm: readFromSwapFile");
80108076:	83 ec 0c             	sub    $0xc,%esp
80108079:	68 02 8e 10 80       	push   $0x80108e02
8010807e:	e8 0d 83 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108083:	83 ec 0c             	sub    $0xc,%esp
80108086:	68 7c 8d 10 80       	push   $0x80108d7c
8010808b:	e8 00 83 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108090:	83 ec 0c             	sub    $0xc,%esp
80108093:	68 f4 8e 10 80       	push   $0x80108ef4
80108098:	e8 f3 82 ff ff       	call   80100390 <panic>
8010809d:	8d 76 00             	lea    0x0(%esi),%esi

801080a0 <copyuvm>:
{
801080a0:	f3 0f 1e fb          	endbr32 
801080a4:	55                   	push   %ebp
801080a5:	89 e5                	mov    %esp,%ebp
801080a7:	57                   	push   %edi
801080a8:	56                   	push   %esi
801080a9:	53                   	push   %ebx
801080aa:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801080ad:	e8 0e fa ff ff       	call   80107ac0 <setupkvm>
801080b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080b5:	85 c0                	test   %eax,%eax
801080b7:	0f 84 ba 00 00 00    	je     80108177 <copyuvm+0xd7>
  for(i = 0; i < sz; i += PGSIZE){
801080bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801080c0:	85 db                	test   %ebx,%ebx
801080c2:	0f 84 af 00 00 00    	je     80108177 <copyuvm+0xd7>
801080c8:	31 f6                	xor    %esi,%esi
801080ca:	eb 65                	jmp    80108131 <copyuvm+0x91>
801080cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
801080d0:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801080d2:	25 ff 0f 00 00       	and    $0xfff,%eax
801080d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801080da:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801080e0:	e8 4b aa ff ff       	call   80102b30 <kalloc>
801080e5:	89 c3                	mov    %eax,%ebx
801080e7:	85 c0                	test   %eax,%eax
801080e9:	0f 84 b1 00 00 00    	je     801081a0 <copyuvm+0x100>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801080ef:	83 ec 04             	sub    $0x4,%esp
801080f2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801080f8:	68 00 10 00 00       	push   $0x1000
801080fd:	57                   	push   %edi
801080fe:	50                   	push   %eax
801080ff:	e8 1c cf ff ff       	call   80105020 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108104:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010810a:	5a                   	pop    %edx
8010810b:	59                   	pop    %ecx
8010810c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010810f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108114:	89 f2                	mov    %esi,%edx
80108116:	50                   	push   %eax
80108117:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010811a:	e8 51 f0 ff ff       	call   80107170 <mappages>
8010811f:	83 c4 10             	add    $0x10,%esp
80108122:	85 c0                	test   %eax,%eax
80108124:	78 62                	js     80108188 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108126:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010812c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010812f:	76 46                	jbe    80108177 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108131:	8b 45 08             	mov    0x8(%ebp),%eax
80108134:	31 c9                	xor    %ecx,%ecx
80108136:	89 f2                	mov    %esi,%edx
80108138:	e8 b3 ef ff ff       	call   801070f0 <walkpgdir>
8010813d:	85 c0                	test   %eax,%eax
8010813f:	0f 84 93 00 00 00    	je     801081d8 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108145:	8b 00                	mov    (%eax),%eax
80108147:	a9 01 02 00 00       	test   $0x201,%eax
8010814c:	74 7d                	je     801081cb <copyuvm+0x12b>
    if (*pte & PTE_PG) {
8010814e:	f6 c4 02             	test   $0x2,%ah
80108151:	0f 84 79 ff ff ff    	je     801080d0 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108157:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010815a:	89 f2                	mov    %esi,%edx
8010815c:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108161:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108167:	e8 84 ef ff ff       	call   801070f0 <walkpgdir>
      *pte = PTE_U | PTE_W | PTE_PG;
8010816c:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108172:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108175:	77 ba                	ja     80108131 <copyuvm+0x91>
}
80108177:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010817a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010817d:	5b                   	pop    %ebx
8010817e:	5e                   	pop    %esi
8010817f:	5f                   	pop    %edi
80108180:	5d                   	pop    %ebp
80108181:	c3                   	ret    
80108182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
80108188:	83 ec 0c             	sub    $0xc,%esp
8010818b:	68 4f 8e 10 80       	push   $0x80108e4f
80108190:	e8 1b 85 ff ff       	call   801006b0 <cprintf>
      kfree(mem);
80108195:	89 1c 24             	mov    %ebx,(%esp)
80108198:	e8 93 a6 ff ff       	call   80102830 <kfree>
      goto bad;
8010819d:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801081a0:	83 ec 0c             	sub    $0xc,%esp
801081a3:	68 69 8e 10 80       	push   $0x80108e69
801081a8:	e8 03 85 ff ff       	call   801006b0 <cprintf>
  freevm(d);
801081ad:	58                   	pop    %eax
801081ae:	ff 75 e0             	pushl  -0x20(%ebp)
801081b1:	e8 8a f8 ff ff       	call   80107a40 <freevm>
  return 0;
801081b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801081bd:	83 c4 10             	add    $0x10,%esp
}
801081c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081c6:	5b                   	pop    %ebx
801081c7:	5e                   	pop    %esi
801081c8:	5f                   	pop    %edi
801081c9:	5d                   	pop    %ebp
801081ca:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
801081cb:	83 ec 0c             	sub    $0xc,%esp
801081ce:	68 4c 8f 10 80       	push   $0x80108f4c
801081d3:	e8 b8 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801081d8:	83 ec 0c             	sub    $0xc,%esp
801081db:	68 35 8e 10 80       	push   $0x80108e35
801081e0:	e8 ab 81 ff ff       	call   80100390 <panic>
801081e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801081f0 <uva2ka>:
{
801081f0:	f3 0f 1e fb          	endbr32 
801081f4:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801081f5:	31 c9                	xor    %ecx,%ecx
{
801081f7:	89 e5                	mov    %esp,%ebp
801081f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801081fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801081ff:	8b 45 08             	mov    0x8(%ebp),%eax
80108202:	e8 e9 ee ff ff       	call   801070f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108207:	8b 00                	mov    (%eax),%eax
}
80108209:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010820a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010820c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108211:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108214:	05 00 00 00 80       	add    $0x80000000,%eax
80108219:	83 fa 05             	cmp    $0x5,%edx
8010821c:	ba 00 00 00 00       	mov    $0x0,%edx
80108221:	0f 45 c2             	cmovne %edx,%eax
}
80108224:	c3                   	ret    
80108225:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010822c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108230 <copyout>:
{
80108230:	f3 0f 1e fb          	endbr32 
80108234:	55                   	push   %ebp
80108235:	89 e5                	mov    %esp,%ebp
80108237:	57                   	push   %edi
80108238:	56                   	push   %esi
80108239:	53                   	push   %ebx
8010823a:	83 ec 0c             	sub    $0xc,%esp
8010823d:	8b 75 14             	mov    0x14(%ebp),%esi
80108240:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(len > 0){
80108243:	85 f6                	test   %esi,%esi
80108245:	75 3c                	jne    80108283 <copyout+0x53>
80108247:	eb 67                	jmp    801082b0 <copyout+0x80>
80108249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108250:	8b 55 0c             	mov    0xc(%ebp),%edx
80108253:	89 fb                	mov    %edi,%ebx
80108255:	29 d3                	sub    %edx,%ebx
80108257:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010825d:	39 f3                	cmp    %esi,%ebx
8010825f:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108262:	29 fa                	sub    %edi,%edx
80108264:	83 ec 04             	sub    $0x4,%esp
80108267:	01 c2                	add    %eax,%edx
80108269:	53                   	push   %ebx
8010826a:	ff 75 10             	pushl  0x10(%ebp)
8010826d:	52                   	push   %edx
8010826e:	e8 ad cd ff ff       	call   80105020 <memmove>
    buf += n;
80108273:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108276:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010827c:	83 c4 10             	add    $0x10,%esp
8010827f:	29 de                	sub    %ebx,%esi
80108281:	74 2d                	je     801082b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108283:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108285:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108288:	89 55 0c             	mov    %edx,0xc(%ebp)
8010828b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108291:	57                   	push   %edi
80108292:	ff 75 08             	pushl  0x8(%ebp)
80108295:	e8 56 ff ff ff       	call   801081f0 <uva2ka>
    if(pa0 == 0)
8010829a:	83 c4 10             	add    $0x10,%esp
8010829d:	85 c0                	test   %eax,%eax
8010829f:	75 af                	jne    80108250 <copyout+0x20>
}
801082a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082a9:	5b                   	pop    %ebx
801082aa:	5e                   	pop    %esi
801082ab:	5f                   	pop    %edi
801082ac:	5d                   	pop    %ebp
801082ad:	c3                   	ret    
801082ae:	66 90                	xchg   %ax,%ax
801082b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082b3:	31 c0                	xor    %eax,%eax
}
801082b5:	5b                   	pop    %ebx
801082b6:	5e                   	pop    %esi
801082b7:	5f                   	pop    %edi
801082b8:	5d                   	pop    %ebp
801082b9:	c3                   	ret    
801082ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801082c0 <getNextFreeRamIndex>:
{ 
801082c0:	f3 0f 1e fb          	endbr32 
801082c4:	55                   	push   %ebp
801082c5:	89 e5                	mov    %esp,%ebp
801082c7:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
801082ca:	e8 c1 bd ff ff       	call   80104090 <myproc>
801082cf:	89 c1                	mov    %eax,%ecx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801082d1:	31 c0                	xor    %eax,%eax
801082d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082d7:	90                   	nop
    if(((struct page)currproc->ramPages[i]).isused == 0)
801082d8:	89 c2                	mov    %eax,%edx
801082da:	c1 e2 04             	shl    $0x4,%edx
801082dd:	8b 94 11 8c 01 00 00 	mov    0x18c(%ecx,%edx,1),%edx
801082e4:	85 d2                	test   %edx,%edx
801082e6:	74 0d                	je     801082f5 <getNextFreeRamIndex+0x35>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801082e8:	83 c0 01             	add    $0x1,%eax
801082eb:	83 f8 10             	cmp    $0x10,%eax
801082ee:	75 e8                	jne    801082d8 <getNextFreeRamIndex+0x18>
  return -1;
801082f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082f5:	c9                   	leave  
801082f6:	c3                   	ret    
