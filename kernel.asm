
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
80100028:	bc 00 f6 10 80       	mov    $0x8010f600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 36 10 80       	mov    $0x801036d0,%eax
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
80100048:	bb 34 f6 10 80       	mov    $0x8010f634,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 83 10 80       	push   $0x80108360
80100055:	68 00 f6 10 80       	push   $0x8010f600
8010005a:	e8 d1 4c 00 00       	call   80104d30 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 3c 11 80       	mov    $0x80113cfc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 3d 11 80 fc 	movl   $0x80113cfc,0x80113d4c
8010006e:	3c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 3d 11 80 fc 	movl   $0x80113cfc,0x80113d50
80100078:	3c 11 80 
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
8010008b:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 83 10 80       	push   $0x80108367
80100097:	50                   	push   %eax
80100098:	e8 53 4b 00 00       	call   80104bf0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 3d 11 80       	mov    0x80113d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 3a 11 80    	cmp    $0x80113aa0,%ebx
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
801000e3:	68 00 f6 10 80       	push   $0x8010f600
801000e8:	e8 c3 4d 00 00       	call   80104eb0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 3d 11 80    	mov    0x80113d50,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
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
80100120:	8b 1d 4c 3d 11 80    	mov    0x80113d4c,%ebx
80100126:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
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
8010015d:	68 00 f6 10 80       	push   $0x8010f600
80100162:	e8 09 4e 00 00       	call   80104f70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 4a 00 00       	call   80104c30 <acquiresleep>
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
801001a3:	68 6e 83 10 80       	push   $0x8010836e
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
801001c2:	e8 09 4b 00 00       	call   80104cd0 <holdingsleep>
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
801001e0:	68 7f 83 10 80       	push   $0x8010837f
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
80100203:	e8 c8 4a 00 00       	call   80104cd0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 4a 00 00       	call   80104c90 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 f6 10 80 	movl   $0x8010f600,(%esp)
8010021f:	e8 8c 4c 00 00       	call   80104eb0 <acquire>
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
80100246:	a1 50 3d 11 80       	mov    0x80113d50,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 3d 11 80       	mov    0x80113d50,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 f6 10 80 	movl   $0x8010f600,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 4c 00 00       	jmp    80104f70 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 83 10 80       	push   $0x80108386
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
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 fa 4b 00 00       	call   80104eb0 <acquire>
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
801002c6:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801002cb:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 e0 3f 11 80       	push   $0x80113fe0
801002e5:	e8 f6 44 00 00       	call   801047e0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 d1 3d 00 00       	call   801040d0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 5d 4c 00 00       	call   80104f70 <release>
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
80100333:	89 15 e0 3f 11 80    	mov    %edx,0x80113fe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 3f 11 80 	movsbl -0x7feec0a0(%edx),%ecx
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
80100365:	e8 06 4c 00 00       	call   80104f70 <release>
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
80100386:	a3 e0 3f 11 80       	mov    %eax,0x80113fe0
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
801003ad:	e8 3e 2b 00 00       	call   80102ef0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 83 10 80       	push   $0x8010838d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 fa 8d 10 80 	movl   $0x80108dfa,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 49 00 00       	call   80104d50 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 83 10 80       	push   $0x801083a1
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
8010042a:	e8 41 62 00 00       	call   80106670 <uartputc>
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
80100515:	e8 56 61 00 00       	call   80106670 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 4a 61 00 00       	call   80106670 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 3e 61 00 00       	call   80106670 <uartputc>
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
80100561:	e8 fa 4a 00 00       	call   80105060 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 4a 00 00       	call   80104fc0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 83 10 80       	push   $0x801083a5
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
801005c9:	0f b6 92 d0 83 10 80 	movzbl -0x7fef7c30(%edx),%edx
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
80100653:	e8 28 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 4c 48 00 00       	call   80104eb0 <acquire>
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
80100697:	e8 d4 48 00 00       	call   80104f70 <release>
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
8010077d:	bb b8 83 10 80       	mov    $0x801083b8,%ebx
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
801007bd:	e8 ee 46 00 00       	call   80104eb0 <acquire>
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
80100828:	e8 43 47 00 00       	call   80104f70 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 83 10 80       	push   $0x801083bf
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
80100877:	e8 34 46 00 00       	call   80104eb0 <acquire>
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
801008b4:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 3f 11 80    	sub    0x80113fe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 3f 11 80    	mov    %ecx,0x80113fe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 3f 11 80    	mov    %bl,-0x7feec0a0(%eax)
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
80100908:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 3f 11 80    	cmp    %eax,0x80113fe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100925:	39 05 e4 3f 11 80    	cmp    %eax,0x80113fe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 3f 11 80 0a 	cmpb   $0xa,-0x7feec0a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
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
8010096a:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
8010096f:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100985:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
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
801009cf:	e8 9c 45 00 00       	call   80104f70 <release>
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
801009e3:	c6 80 60 3f 11 80 0a 	movb   $0xa,-0x7feec0a0(%eax)
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
801009ff:	e9 dc 40 00 00       	jmp    80104ae0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 3f 11 80       	mov    %eax,0x80113fe4
          wakeup(&input.r);
80100a1b:	68 e0 3f 11 80       	push   $0x80113fe0
80100a20:	e8 bb 3f 00 00       	call   801049e0 <wakeup>
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
80100a3a:	68 c8 83 10 80       	push   $0x801083c8
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 e7 42 00 00       	call   80104d30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 49 11 80 40 	movl   $0x80100640,0x801149ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 49 11 80 90 	movl   $0x80100290,0x801149a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
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
80100a90:	e8 3b 36 00 00       	call   801040d0 <myproc>
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
80100ae3:	e8 48 29 00 00       	call   80103430 <end_op>
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
80100b0c:	e8 0f 70 00 00       	call   80107b20 <setupkvm>
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
80100b73:	e8 28 6c 00 00       	call   801077a0 <allocuvm>
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
80100ba9:	e8 42 69 00 00       	call   801074f0 <loaduvm>
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
80100beb:	e8 b0 6e 00 00       	call   80107aa0 <freevm>
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
80100c21:	e8 0a 28 00 00       	call   80103430 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 69 6b 00 00       	call   801077a0 <allocuvm>
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
80100c53:	e8 78 6f 00 00       	call   80107bd0 <clearpteu>
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
80100ca3:	e8 18 45 00 00       	call   801051c0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 05 45 00 00       	call   801051c0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 c4 75 00 00       	call   80108290 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ba 6d 00 00       	call   80107aa0 <freevm>
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
80100d33:	e8 58 75 00 00       	call   80108290 <copyout>
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
80100d6f:	e8 0c 44 00 00       	call   80105180 <safestrcpy>
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
80100ddc:	e8 7f 65 00 00       	call   80107360 <switchuvm>
  freevm(oldpgdir);
80100de1:	89 3c 24             	mov    %edi,(%esp)
80100de4:	e8 b7 6c 00 00       	call   80107aa0 <freevm>
  return 0;
80100de9:	83 c4 10             	add    $0x10,%esp
80100dec:	31 c0                	xor    %eax,%eax
80100dee:	e9 fd fc ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100df3:	e8 38 26 00 00       	call   80103430 <end_op>
    cprintf("exec: fail\n");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 e1 83 10 80       	push   $0x801083e1
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
80100e2a:	68 ed 83 10 80       	push   $0x801083ed
80100e2f:	68 00 40 11 80       	push   $0x80114000
80100e34:	e8 f7 3e 00 00       	call   80104d30 <initlock>
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
80100e48:	bb 34 40 11 80       	mov    $0x80114034,%ebx
{
80100e4d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e50:	68 00 40 11 80       	push   $0x80114000
80100e55:	e8 56 40 00 00       	call   80104eb0 <acquire>
80100e5a:	83 c4 10             	add    $0x10,%esp
80100e5d:	eb 0c                	jmp    80100e6b <filealloc+0x2b>
80100e5f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb 94 49 11 80    	cmp    $0x80114994,%ebx
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
80100e7c:	68 00 40 11 80       	push   $0x80114000
80100e81:	e8 ea 40 00 00       	call   80104f70 <release>
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
80100e95:	68 00 40 11 80       	push   $0x80114000
80100e9a:	e8 d1 40 00 00       	call   80104f70 <release>
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
80100ebe:	68 00 40 11 80       	push   $0x80114000
80100ec3:	e8 e8 3f 00 00       	call   80104eb0 <acquire>
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
80100edb:	68 00 40 11 80       	push   $0x80114000
80100ee0:	e8 8b 40 00 00       	call   80104f70 <release>
  return f;
}
80100ee5:	89 d8                	mov    %ebx,%eax
80100ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eea:	c9                   	leave  
80100eeb:	c3                   	ret    
    panic("filedup");
80100eec:	83 ec 0c             	sub    $0xc,%esp
80100eef:	68 f4 83 10 80       	push   $0x801083f4
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
80100f10:	68 00 40 11 80       	push   $0x80114000
80100f15:	e8 96 3f 00 00       	call   80104eb0 <acquire>
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
80100f48:	68 00 40 11 80       	push   $0x80114000
  ff = *f;
80100f4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f50:	e8 1b 40 00 00       	call   80104f70 <release>

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
80100f70:	c7 45 08 00 40 11 80 	movl   $0x80114000,0x8(%ebp)
}
80100f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7a:	5b                   	pop    %ebx
80100f7b:	5e                   	pop    %esi
80100f7c:	5f                   	pop    %edi
80100f7d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f7e:	e9 ed 3f 00 00       	jmp    80104f70 <release>
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
80100fa2:	e9 89 24 00 00       	jmp    80103430 <end_op>
80100fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fae:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fb0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fb4:	83 ec 08             	sub    $0x8,%esp
80100fb7:	53                   	push   %ebx
80100fb8:	56                   	push   %esi
80100fb9:	e8 d2 2b 00 00       	call   80103b90 <pipeclose>
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
80100fcc:	68 fc 83 10 80       	push   $0x801083fc
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
801010a5:	e9 86 2c 00 00       	jmp    80103d30 <piperead>
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010b5:	eb d3                	jmp    8010108a <fileread+0x5a>
  panic("fileread");
801010b7:	83 ec 0c             	sub    $0xc,%esp
801010ba:	68 06 84 10 80       	push   $0x80108406
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
80101131:	e8 fa 22 00 00       	call   80103430 <end_op>
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
80101191:	e8 9a 22 00 00       	call   80103430 <end_op>
      if(r < 0)
80101196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101199:	83 c4 10             	add    $0x10,%esp
8010119c:	85 c0                	test   %eax,%eax
8010119e:	75 17                	jne    801011b7 <filewrite+0xe7>
        panic("short filewrite");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 0f 84 10 80       	push   $0x8010840f
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
801011d1:	e9 5a 2a 00 00       	jmp    80103c30 <pipewrite>
  panic("filewrite");
801011d6:	83 ec 0c             	sub    $0xc,%esp
801011d9:	68 15 84 10 80       	push   $0x80108415
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
801011f8:	03 05 18 4a 11 80    	add    0x80114a18,%eax
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
8010123d:	e8 5e 23 00 00       	call   801035a0 <log_write>
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
80101257:	68 1f 84 10 80       	push   $0x8010841f
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
80101279:	8b 0d 00 4a 11 80    	mov    0x80114a00,%ecx
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
8010129c:	03 05 18 4a 11 80    	add    0x80114a18,%eax
801012a2:	50                   	push   %eax
801012a3:	ff 75 d8             	pushl  -0x28(%ebp)
801012a6:	e8 25 ee ff ff       	call   801000d0 <bread>
801012ab:	83 c4 10             	add    $0x10,%esp
801012ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012b1:	a1 00 4a 11 80       	mov    0x80114a00,%eax
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
80101309:	39 05 00 4a 11 80    	cmp    %eax,0x80114a00
8010130f:	77 80                	ja     80101291 <balloc+0x21>
  panic("balloc: out of blocks");
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	68 32 84 10 80       	push   $0x80108432
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
8010132d:	e8 6e 22 00 00       	call   801035a0 <log_write>
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
80101355:	e8 66 3c 00 00       	call   80104fc0 <memset>
  log_write(bp);
8010135a:	89 1c 24             	mov    %ebx,(%esp)
8010135d:	e8 3e 22 00 00       	call   801035a0 <log_write>
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
8010138a:	bb 54 4a 11 80       	mov    $0x80114a54,%ebx
{
8010138f:	83 ec 28             	sub    $0x28,%esp
80101392:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101395:	68 20 4a 11 80       	push   $0x80114a20
8010139a:	e8 11 3b 00 00       	call   80104eb0 <acquire>
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
801013ba:	81 fb 74 66 11 80    	cmp    $0x80116674,%ebx
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
801013db:	81 fb 74 66 11 80    	cmp    $0x80116674,%ebx
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
80101402:	68 20 4a 11 80       	push   $0x80114a20
80101407:	e8 64 3b 00 00       	call   80104f70 <release>

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
8010142d:	68 20 4a 11 80       	push   $0x80114a20
      ip->ref++;
80101432:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101435:	e8 36 3b 00 00       	call   80104f70 <release>
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
80101447:	81 fb 74 66 11 80    	cmp    $0x80116674,%ebx
8010144d:	73 10                	jae    8010145f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010144f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101452:	85 c9                	test   %ecx,%ecx
80101454:	0f 8f 56 ff ff ff    	jg     801013b0 <iget+0x30>
8010145a:	e9 6e ff ff ff       	jmp    801013cd <iget+0x4d>
    panic("iget: no inodes");
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	68 48 84 10 80       	push   $0x80108448
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
801014e5:	e8 b6 20 00 00       	call   801035a0 <log_write>
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
8010152b:	68 58 84 10 80       	push   $0x80108458
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
80101565:	e8 f6 3a 00 00       	call   80105060 <memmove>
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
80101588:	bb 60 4a 11 80       	mov    $0x80114a60,%ebx
8010158d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101590:	68 6b 84 10 80       	push   $0x8010846b
80101595:	68 20 4a 11 80       	push   $0x80114a20
8010159a:	e8 91 37 00 00       	call   80104d30 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159f:	83 c4 10             	add    $0x10,%esp
801015a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	68 72 84 10 80       	push   $0x80108472
801015b0:	53                   	push   %ebx
801015b1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015b7:	e8 34 36 00 00       	call   80104bf0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015bc:	83 c4 10             	add    $0x10,%esp
801015bf:	81 fb 80 66 11 80    	cmp    $0x80116680,%ebx
801015c5:	75 e1                	jne    801015a8 <iinit+0x28>
  readsb(dev, &sb);
801015c7:	83 ec 08             	sub    $0x8,%esp
801015ca:	68 00 4a 11 80       	push   $0x80114a00
801015cf:	ff 75 08             	pushl  0x8(%ebp)
801015d2:	e8 69 ff ff ff       	call   80101540 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015d7:	ff 35 18 4a 11 80    	pushl  0x80114a18
801015dd:	ff 35 14 4a 11 80    	pushl  0x80114a14
801015e3:	ff 35 10 4a 11 80    	pushl  0x80114a10
801015e9:	ff 35 0c 4a 11 80    	pushl  0x80114a0c
801015ef:	ff 35 08 4a 11 80    	pushl  0x80114a08
801015f5:	ff 35 04 4a 11 80    	pushl  0x80114a04
801015fb:	ff 35 00 4a 11 80    	pushl  0x80114a00
80101601:	68 1c 85 10 80       	push   $0x8010851c
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
80101630:	83 3d 08 4a 11 80 01 	cmpl   $0x1,0x80114a08
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
8010165f:	3b 3d 08 4a 11 80    	cmp    0x80114a08,%edi
80101665:	73 69                	jae    801016d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101667:	89 f8                	mov    %edi,%eax
80101669:	83 ec 08             	sub    $0x8,%esp
8010166c:	c1 e8 03             	shr    $0x3,%eax
8010166f:	03 05 14 4a 11 80    	add    0x80114a14,%eax
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
8010169e:	e8 1d 39 00 00       	call   80104fc0 <memset>
      dip->type = type;
801016a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ad:	89 1c 24             	mov    %ebx,(%esp)
801016b0:	e8 eb 1e 00 00       	call   801035a0 <log_write>
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
801016d3:	68 78 84 10 80       	push   $0x80108478
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
801016f8:	03 05 14 4a 11 80    	add    0x80114a14,%eax
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
80101745:	e8 16 39 00 00       	call   80105060 <memmove>
  log_write(bp);
8010174a:	89 34 24             	mov    %esi,(%esp)
8010174d:	e8 4e 1e 00 00       	call   801035a0 <log_write>
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
8010177e:	68 20 4a 11 80       	push   $0x80114a20
80101783:	e8 28 37 00 00       	call   80104eb0 <acquire>
  ip->ref++;
80101788:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010178c:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101793:	e8 d8 37 00 00       	call   80104f70 <release>
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
801017c6:	e8 65 34 00 00       	call   80104c30 <acquiresleep>
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
801017e9:	03 05 14 4a 11 80    	add    0x80114a14,%eax
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
80101838:	e8 23 38 00 00       	call   80105060 <memmove>
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
8010185d:	68 90 84 10 80       	push   $0x80108490
80101862:	e8 29 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 8a 84 10 80       	push   $0x8010848a
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
80101897:	e8 34 34 00 00       	call   80104cd0 <holdingsleep>
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
801018b3:	e9 d8 33 00 00       	jmp    80104c90 <releasesleep>
    panic("iunlock");
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 9f 84 10 80       	push   $0x8010849f
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
801018e4:	e8 47 33 00 00       	call   80104c30 <acquiresleep>
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
801018fe:	e8 8d 33 00 00       	call   80104c90 <releasesleep>
  acquire(&icache.lock);
80101903:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
8010190a:	e8 a1 35 00 00       	call   80104eb0 <acquire>
  ip->ref--;
8010190f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	c7 45 08 20 4a 11 80 	movl   $0x80114a20,0x8(%ebp)
}
8010191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101920:	5b                   	pop    %ebx
80101921:	5e                   	pop    %esi
80101922:	5f                   	pop    %edi
80101923:	5d                   	pop    %ebp
  release(&icache.lock);
80101924:	e9 47 36 00 00       	jmp    80104f70 <release>
80101929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101930:	83 ec 0c             	sub    $0xc,%esp
80101933:	68 20 4a 11 80       	push   $0x80114a20
80101938:	e8 73 35 00 00       	call   80104eb0 <acquire>
    int r = ip->ref;
8010193d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101940:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101947:	e8 24 36 00 00       	call   80104f70 <release>
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
80101b47:	e8 14 35 00 00       	call   80105060 <memmove>
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
80101b7a:	8b 04 c5 a0 49 11 80 	mov    -0x7feeb660(,%eax,8),%eax
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
80101c43:	e8 18 34 00 00       	call   80105060 <memmove>
    log_write(bp);
80101c48:	89 3c 24             	mov    %edi,(%esp)
80101c4b:	e8 50 19 00 00       	call   801035a0 <log_write>
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
80101c8a:	8b 04 c5 a4 49 11 80 	mov    -0x7feeb65c(,%eax,8),%eax
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
80101ce2:	e8 e9 33 00 00       	call   801050d0 <strncmp>
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
80101d45:	e8 86 33 00 00       	call   801050d0 <strncmp>
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
80101d8a:	68 b9 84 10 80       	push   $0x801084b9
80101d8f:	e8 fc e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	68 a7 84 10 80       	push   $0x801084a7
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
80101dca:	e8 01 23 00 00       	call   801040d0 <myproc>
  acquire(&icache.lock);
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101dd4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dd7:	68 20 4a 11 80       	push   $0x80114a20
80101ddc:	e8 cf 30 00 00       	call   80104eb0 <acquire>
  ip->ref++;
80101de1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101de5:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101dec:	e8 7f 31 00 00       	call   80104f70 <release>
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
80101e57:	e8 04 32 00 00       	call   80105060 <memmove>
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
80101ee3:	e8 78 31 00 00       	call   80105060 <memmove>
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
80102015:	e8 06 31 00 00       	call   80105120 <strncpy>
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
80102053:	68 c8 84 10 80       	push   $0x801084c8
80102058:	e8 33 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010205d:	83 ec 0c             	sub    $0xc,%esp
80102060:	68 b5 8b 10 80       	push   $0x80108bb5
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
80102155:	68 d5 84 10 80       	push   $0x801084d5
8010215a:	56                   	push   %esi
8010215b:	e8 00 2f 00 00       	call   80105060 <memmove>
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
801021b6:	68 dd 84 10 80       	push   $0x801084dd
801021bb:	53                   	push   %ebx
801021bc:	e8 0f 2f 00 00       	call   801050d0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801021c1:	83 c4 10             	add    $0x10,%esp
801021c4:	85 c0                	test   %eax,%eax
801021c6:	0f 84 f4 00 00 00    	je     801022c0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	6a 0e                	push   $0xe
801021d1:	68 dc 84 10 80       	push   $0x801084dc
801021d6:	53                   	push   %ebx
801021d7:	e8 f4 2e 00 00       	call   801050d0 <strncmp>
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
8010222b:	e8 90 2d 00 00       	call   80104fc0 <memset>
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
80102281:	e8 aa 11 00 00       	call   80103430 <end_op>

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
8010229c:	e8 ef 34 00 00       	call   80105790 <isdirempty>
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
801022d1:	e8 5a 11 00 00       	call   80103430 <end_op>
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
801022fd:	e8 2e 11 00 00       	call   80103430 <end_op>
    return -1;
80102302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102307:	e9 7f ff ff ff       	jmp    8010228b <removeSwapFile+0x14b>
    panic("unlink: writei");
8010230c:	83 ec 0c             	sub    $0xc,%esp
8010230f:	68 f1 84 10 80       	push   $0x801084f1
80102314:	e8 77 e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102319:	83 ec 0c             	sub    $0xc,%esp
8010231c:	68 df 84 10 80       	push   $0x801084df
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
80102344:	68 d5 84 10 80       	push   $0x801084d5
80102349:	56                   	push   %esi
8010234a:	e8 11 2d 00 00       	call   80105060 <memmove>
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
80102369:	e8 42 36 00 00       	call   801059b0 <create>
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
801023ac:	e8 7f 10 00 00       	call   80103430 <end_op>

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
801023bd:	68 00 85 10 80       	push   $0x80108500
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
801024eb:	68 78 85 10 80       	push   $0x80108578
801024f0:	e8 9b de ff ff       	call   80100390 <panic>
    panic("idestart");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 6f 85 10 80       	push   $0x8010856f
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
8010251a:	68 8a 85 10 80       	push   $0x8010858a
8010251f:	68 80 c5 10 80       	push   $0x8010c580
80102524:	e8 07 28 00 00       	call   80104d30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102529:	58                   	pop    %eax
8010252a:	a1 40 6d 18 80       	mov    0x80186d40,%eax
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
8010257a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
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
801025ad:	68 80 c5 10 80       	push   $0x8010c580
801025b2:	e8 f9 28 00 00       	call   80104eb0 <acquire>

  if((b = idequeue) == 0){
801025b7:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	85 db                	test   %ebx,%ebx
801025c2:	74 5f                	je     80102623 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025c4:	8b 43 58             	mov    0x58(%ebx),%eax
801025c7:	a3 64 c5 10 80       	mov    %eax,0x8010c564

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
8010260d:	e8 ce 23 00 00       	call   801049e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102612:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	85 c0                	test   %eax,%eax
8010261c:	74 05                	je     80102623 <ideintr+0x83>
    idestart(idequeue);
8010261e:	e8 0d fe ff ff       	call   80102430 <idestart>
    release(&idelock);
80102623:	83 ec 0c             	sub    $0xc,%esp
80102626:	68 80 c5 10 80       	push   $0x8010c580
8010262b:	e8 40 29 00 00       	call   80104f70 <release>

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
80102652:	e8 79 26 00 00       	call   80104cd0 <holdingsleep>
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
80102677:	a1 60 c5 10 80       	mov    0x8010c560,%eax
8010267c:	85 c0                	test   %eax,%eax
8010267e:	0f 84 93 00 00 00    	je     80102717 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	68 80 c5 10 80       	push   $0x8010c580
8010268c:	e8 1f 28 00 00       	call   80104eb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102691:	a1 64 c5 10 80       	mov    0x8010c564,%eax
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
801026b6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
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
801026d3:	68 80 c5 10 80       	push   $0x8010c580
801026d8:	53                   	push   %ebx
801026d9:	e8 02 21 00 00       	call   801047e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026de:	8b 03                	mov    (%ebx),%eax
801026e0:	83 c4 10             	add    $0x10,%esp
801026e3:	83 e0 06             	and    $0x6,%eax
801026e6:	83 f8 02             	cmp    $0x2,%eax
801026e9:	75 e5                	jne    801026d0 <iderw+0x90>
  }


  release(&idelock);
801026eb:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
801026f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f5:	c9                   	leave  
  release(&idelock);
801026f6:	e9 75 28 00 00       	jmp    80104f70 <release>
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop
    idestart(b);
80102700:	89 d8                	mov    %ebx,%eax
80102702:	e8 29 fd ff ff       	call   80102430 <idestart>
80102707:	eb b5                	jmp    801026be <iderw+0x7e>
80102709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102710:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102715:	eb 9d                	jmp    801026b4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102717:	83 ec 0c             	sub    $0xc,%esp
8010271a:	68 b9 85 10 80       	push   $0x801085b9
8010271f:	e8 6c dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102724:	83 ec 0c             	sub    $0xc,%esp
80102727:	68 a4 85 10 80       	push   $0x801085a4
8010272c:	e8 5f dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102731:	83 ec 0c             	sub    $0xc,%esp
80102734:	68 8e 85 10 80       	push   $0x8010858e
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
80102745:	c7 05 74 66 11 80 00 	movl   $0xfec00000,0x80116674
8010274c:	00 c0 fe 
{
8010274f:	89 e5                	mov    %esp,%ebp
80102751:	56                   	push   %esi
80102752:	53                   	push   %ebx
  ioapic->reg = reg;
80102753:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010275a:	00 00 00 
  return ioapic->data;
8010275d:	8b 15 74 66 11 80    	mov    0x80116674,%edx
80102763:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102766:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010276c:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102772:	0f b6 15 a0 67 18 80 	movzbl 0x801867a0,%edx
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
8010278e:	68 d8 85 10 80       	push   $0x801085d8
80102793:	e8 18 df ff ff       	call   801006b0 <cprintf>
80102798:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
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
801027b4:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
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
801027ce:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
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
801027f5:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
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
80102809:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010280f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102812:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102815:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102818:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010281a:	a1 74 66 11 80       	mov    0x80116674,%eax
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
80102849:	3d e8 1b 19 80       	cmp    $0x80191be8,%eax
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
80102871:	e8 4a 27 00 00       	call   80104fc0 <memset>

  if(kmem.use_lock) 
80102876:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
8010287c:	83 c4 10             	add    $0x10,%esp
8010287f:	85 d2                	test   %edx,%edx
80102881:	75 4d                	jne    801028d0 <kfree+0xa0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102883:	89 d8                	mov    %ebx,%eax
80102885:	c1 e8 0c             	shr    $0xc,%eax

  if(r->refcount != 1)
80102888:	83 3c c5 c0 66 11 80 	cmpl   $0x1,-0x7fee9940(,%eax,8)
8010288f:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102890:	8d 50 06             	lea    0x6(%eax),%edx
80102893:	8d 0c c5 bc 66 11 80 	lea    -0x7fee9944(,%eax,8),%ecx
  if(r->refcount != 1)
8010289a:	75 69                	jne    80102905 <kfree+0xd5>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
8010289c:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  r->refcount = 0;
801028a1:	c7 04 d5 90 66 11 80 	movl   $0x0,-0x7fee9970(,%edx,8)
801028a8:	00 00 00 00 
  kmem.freelist = r;
801028ac:	89 0d b8 66 11 80    	mov    %ecx,0x801166b8
  r->next = kmem.freelist;
801028b2:	89 04 d5 8c 66 11 80 	mov    %eax,-0x7fee9974(,%edx,8)
  if(kmem.use_lock)
801028b9:	a1 b4 66 11 80       	mov    0x801166b4,%eax
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
801028d3:	68 80 66 11 80       	push   $0x80116680
801028d8:	e8 d3 25 00 00       	call   80104eb0 <acquire>
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	eb a1                	jmp    80102883 <kfree+0x53>
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028e8:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
801028ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028f2:	c9                   	leave  
    release(&kmem.lock);
801028f3:	e9 78 26 00 00       	jmp    80104f70 <release>
    panic("kfree");
801028f8:	83 ec 0c             	sub    $0xc,%esp
801028fb:	68 0a 86 10 80       	push   $0x8010860a
80102900:	e8 8b da ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102905:	83 ec 0c             	sub    $0xc,%esp
80102908:	68 10 86 10 80       	push   $0x80108610
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
80102939:	3d e8 1b 19 80       	cmp    $0x80191be8,%eax
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
80102961:	e8 5a 26 00 00       	call   80104fc0 <memset>

  if(kmem.use_lock) 
80102966:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
8010296c:	83 c4 10             	add    $0x10,%esp
8010296f:	85 d2                	test   %edx,%edx
80102971:	75 35                	jne    801029a8 <kfree_nocheck+0x88>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102973:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102978:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
8010297b:	83 c3 06             	add    $0x6,%ebx
8010297e:	89 04 dd 8c 66 11 80 	mov    %eax,-0x7fee9974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102985:	8d 04 dd 8c 66 11 80 	lea    -0x7fee9974(,%ebx,8),%eax
  r->refcount = 0;
8010298c:	c7 04 dd 90 66 11 80 	movl   $0x0,-0x7fee9970(,%ebx,8)
80102993:	00 00 00 00 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102997:	a3 b8 66 11 80       	mov    %eax,0x801166b8
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
801029ae:	68 80 66 11 80       	push   $0x80116680
  r->next = kmem.freelist;
801029b3:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
801029b6:	e8 f5 24 00 00       	call   80104eb0 <acquire>
  r->next = kmem.freelist;
801029bb:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(kmem.use_lock)
801029c0:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
801029c3:	c7 04 dd 90 66 11 80 	movl   $0x0,-0x7fee9970(,%ebx,8)
801029ca:	00 00 00 00 
  r->next = kmem.freelist;
801029ce:	89 04 dd 8c 66 11 80 	mov    %eax,-0x7fee9974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
801029d5:	8d 04 dd 8c 66 11 80 	lea    -0x7fee9974(,%ebx,8),%eax
801029dc:	a3 b8 66 11 80       	mov    %eax,0x801166b8
  if(kmem.use_lock)
801029e1:	a1 b4 66 11 80       	mov    0x801166b4,%eax
801029e6:	85 c0                	test   %eax,%eax
801029e8:	74 b2                	je     8010299c <kfree_nocheck+0x7c>
    release(&kmem.lock);
801029ea:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
801029f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029f4:	c9                   	leave  
    release(&kmem.lock);
801029f5:	e9 76 25 00 00       	jmp    80104f70 <release>
    panic("kfree_nocheck");
801029fa:	83 ec 0c             	sub    $0xc,%esp
801029fd:	68 2d 86 10 80       	push   $0x8010862d
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
80102a6f:	68 3b 86 10 80       	push   $0x8010863b
80102a74:	68 80 66 11 80       	push   $0x80116680
80102a79:	e8 b2 22 00 00       	call   80104d30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a81:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a84:	c7 05 b4 66 11 80 00 	movl   $0x0,0x801166b4
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
80102b14:	c7 05 b4 66 11 80 01 	movl   $0x1,0x801166b4
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
80102b3a:	a1 b4 66 11 80       	mov    0x801166b4,%eax
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	75 65                	jne    80102ba8 <kalloc+0x78>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b43:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(r)
80102b48:	85 c0                	test   %eax,%eax
80102b4a:	74 54                	je     80102ba0 <kalloc+0x70>
  {
    kmem.freelist = r->next;
80102b4c:	8b 10                	mov    (%eax),%edx
80102b4e:	89 15 b8 66 11 80    	mov    %edx,0x801166b8
    r->refcount = 1;
80102b54:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102b5b:	8b 0d b4 66 11 80    	mov    0x801166b4,%ecx
80102b61:	85 c9                	test   %ecx,%ecx
80102b63:	75 13                	jne    80102b78 <kalloc+0x48>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b65:	2d bc 66 11 80       	sub    $0x801166bc,%eax
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
80102b7e:	68 80 66 11 80       	push   $0x80116680
80102b83:	e8 e8 23 00 00       	call   80104f70 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b8b:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b8e:	2d bc 66 11 80       	sub    $0x801166bc,%eax
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
80102bab:	68 80 66 11 80       	push   $0x80116680
80102bb0:	e8 fb 22 00 00       	call   80104eb0 <acquire>
  r = kmem.freelist;
80102bb5:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(r)
80102bba:	83 c4 10             	add    $0x10,%esp
80102bbd:	85 c0                	test   %eax,%eax
80102bbf:	75 8b                	jne    80102b4c <kalloc+0x1c>
  if(kmem.use_lock)
80102bc1:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
80102bc7:	85 d2                	test   %edx,%edx
80102bc9:	74 d5                	je     80102ba0 <kalloc+0x70>
    release(&kmem.lock);
80102bcb:	83 ec 0c             	sub    $0xc,%esp
80102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bd1:	68 80 66 11 80       	push   $0x80116680
80102bd6:	e8 95 23 00 00       	call   80104f70 <release>
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
80102bfb:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
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
80102c11:	83 2c c5 c0 66 11 80 	subl   $0x1,-0x7fee9940(,%eax,8)
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
80102c29:	68 80 66 11 80       	push   $0x80116680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c2e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c31:	e8 7a 22 00 00       	call   80104eb0 <acquire>
  if(kmem.use_lock)
80102c36:	a1 b4 66 11 80       	mov    0x801166b4,%eax
  r->refcount -= 1;
80102c3b:	83 2c dd c0 66 11 80 	subl   $0x1,-0x7fee9940(,%ebx,8)
80102c42:	01 
  if(kmem.use_lock)
80102c43:	83 c4 10             	add    $0x10,%esp
80102c46:	85 c0                	test   %eax,%eax
80102c48:	74 cf                	je     80102c19 <refDec+0x29>
    release(&kmem.lock);
80102c4a:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
80102c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c54:	c9                   	leave  
    release(&kmem.lock);
80102c55:	e9 16 23 00 00       	jmp    80104f70 <release>
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
80102c6b:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
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
80102c81:	83 04 c5 c0 66 11 80 	addl   $0x1,-0x7fee9940(,%eax,8)
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
80102c99:	68 80 66 11 80       	push   $0x80116680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c9e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ca1:	e8 0a 22 00 00       	call   80104eb0 <acquire>
  if(kmem.use_lock)
80102ca6:	a1 b4 66 11 80       	mov    0x801166b4,%eax
  r->refcount += 1;
80102cab:	83 04 dd c0 66 11 80 	addl   $0x1,-0x7fee9940(,%ebx,8)
80102cb2:	01 
  if(kmem.use_lock)
80102cb3:	83 c4 10             	add    $0x10,%esp
80102cb6:	85 c0                	test   %eax,%eax
80102cb8:	74 cf                	je     80102c89 <refInc+0x29>
    release(&kmem.lock);
80102cba:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
80102cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc4:	c9                   	leave  
    release(&kmem.lock);
80102cc5:	e9 a6 22 00 00       	jmp    80104f70 <release>
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
80102ce3:	8b 04 c5 c0 66 11 80 	mov    -0x7fee9940(,%eax,8),%eax
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
80102d0c:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
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
80102d2f:	0f b6 8a 60 87 10 80 	movzbl -0x7fef78a0(%edx),%ecx
  shift ^= togglecode[data];
80102d36:	0f b6 82 60 86 10 80 	movzbl -0x7fef79a0(%edx),%eax
  shift |= shiftcode[data];
80102d3d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d3f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d41:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d43:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d49:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d4c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d4f:	8b 04 85 40 86 10 80 	mov    -0x7fef79c0(,%eax,4),%eax
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
80102d75:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
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
80102d8a:	0f b6 8a 60 87 10 80 	movzbl -0x7fef78a0(%edx),%ecx
80102d91:	83 c9 40             	or     $0x40,%ecx
80102d94:	0f b6 c9             	movzbl %cl,%ecx
80102d97:	f7 d1                	not    %ecx
80102d99:	21 d9                	and    %ebx,%ecx
}
80102d9b:	5b                   	pop    %ebx
80102d9c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102d9d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
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
80102df4:	a1 bc 66 18 80       	mov    0x801866bc,%eax
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
80102ef4:	a1 bc 66 18 80       	mov    0x801866bc,%eax
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
80102f14:	a1 bc 66 18 80       	mov    0x801866bc,%eax
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
80102f82:	a1 bc 66 18 80       	mov    0x801866bc,%eax
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
8010310f:	e8 fc 1e 00 00       	call   80105010 <memcmp>
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
801031e0:	8b 0d 08 67 18 80    	mov    0x80186708,%ecx
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
80103200:	a1 f4 66 18 80       	mov    0x801866f4,%eax
80103205:	83 ec 08             	sub    $0x8,%esp
80103208:	01 f8                	add    %edi,%eax
8010320a:	83 c0 01             	add    $0x1,%eax
8010320d:	50                   	push   %eax
8010320e:	ff 35 04 67 18 80    	pushl  0x80186704
80103214:	e8 b7 ce ff ff       	call   801000d0 <bread>
80103219:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010321b:	58                   	pop    %eax
8010321c:	5a                   	pop    %edx
8010321d:	ff 34 bd 0c 67 18 80 	pushl  -0x7fe798f4(,%edi,4)
80103224:	ff 35 04 67 18 80    	pushl  0x80186704
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
80103244:	e8 17 1e 00 00       	call   80105060 <memmove>
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
80103264:	39 3d 08 67 18 80    	cmp    %edi,0x80186708
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
80103287:	ff 35 f4 66 18 80    	pushl  0x801866f4
8010328d:	ff 35 04 67 18 80    	pushl  0x80186704
80103293:	e8 38 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103298:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010329b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010329d:	a1 08 67 18 80       	mov    0x80186708,%eax
801032a2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801032a5:	85 c0                	test   %eax,%eax
801032a7:	7e 19                	jle    801032c2 <write_head+0x42>
801032a9:	31 d2                	xor    %edx,%edx
801032ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032af:	90                   	nop
    hb->block[i] = log.lh.block[i];
801032b0:	8b 0c 95 0c 67 18 80 	mov    -0x7fe798f4(,%edx,4),%ecx
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
801032ee:	68 60 88 10 80       	push   $0x80108860
801032f3:	68 c0 66 18 80       	push   $0x801866c0
801032f8:	e8 33 1a 00 00       	call   80104d30 <initlock>
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
8010330d:	89 1d 04 67 18 80    	mov    %ebx,0x80186704
  log.size = sb.nlog;
80103313:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103316:	a3 f4 66 18 80       	mov    %eax,0x801866f4
  log.size = sb.nlog;
8010331b:	89 15 f8 66 18 80    	mov    %edx,0x801866f8
  struct buf *buf = bread(log.dev, log.start);
80103321:	5a                   	pop    %edx
80103322:	50                   	push   %eax
80103323:	53                   	push   %ebx
80103324:	e8 a7 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103329:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010332c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010332f:	89 0d 08 67 18 80    	mov    %ecx,0x80186708
  for (i = 0; i < log.lh.n; i++) {
80103335:	85 c9                	test   %ecx,%ecx
80103337:	7e 19                	jle    80103352 <initlog+0x72>
80103339:	31 d2                	xor    %edx,%edx
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103340:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103344:	89 1c 95 0c 67 18 80 	mov    %ebx,-0x7fe798f4(,%edx,4)
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
80103360:	c7 05 08 67 18 80 00 	movl   $0x0,0x80186708
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
8010338a:	68 c0 66 18 80       	push   $0x801866c0
8010338f:	e8 1c 1b 00 00       	call   80104eb0 <acquire>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339e:	66 90                	xchg   %ax,%ax
  while(1){
    if(log.committing){
801033a0:	8b 0d 00 67 18 80    	mov    0x80186700,%ecx
801033a6:	85 c9                	test   %ecx,%ecx
801033a8:	75 50                	jne    801033fa <begin_op+0x7a>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033aa:	a1 fc 66 18 80       	mov    0x801866fc,%eax
801033af:	8b 15 08 67 18 80    	mov    0x80186708,%edx
801033b5:	83 c0 01             	add    $0x1,%eax
801033b8:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801033bb:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801033be:	83 fa 1e             	cmp    $0x1e,%edx
801033c1:	7e 55                	jle    80103418 <begin_op+0x98>
      // this op might exhaust log space; wait for commit.
      cprintf("before sleep\n");
801033c3:	83 ec 0c             	sub    $0xc,%esp
801033c6:	68 64 88 10 80       	push   $0x80108864
801033cb:	e8 e0 d2 ff ff       	call   801006b0 <cprintf>
      sleep(&log, &log.lock); // deadlock
801033d0:	58                   	pop    %eax
801033d1:	5a                   	pop    %edx
801033d2:	68 c0 66 18 80       	push   $0x801866c0
801033d7:	68 c0 66 18 80       	push   $0x801866c0
801033dc:	e8 ff 13 00 00       	call   801047e0 <sleep>
      cprintf("after sleep\n");
801033e1:	c7 04 24 72 88 10 80 	movl   $0x80108872,(%esp)
801033e8:	e8 c3 d2 ff ff       	call   801006b0 <cprintf>
    if(log.committing){
801033ed:	8b 0d 00 67 18 80    	mov    0x80186700,%ecx
801033f3:	83 c4 10             	add    $0x10,%esp
801033f6:	85 c9                	test   %ecx,%ecx
801033f8:	74 b0                	je     801033aa <begin_op+0x2a>
      sleep(&log, &log.lock);
801033fa:	83 ec 08             	sub    $0x8,%esp
801033fd:	68 c0 66 18 80       	push   $0x801866c0
80103402:	68 c0 66 18 80       	push   $0x801866c0
80103407:	e8 d4 13 00 00       	call   801047e0 <sleep>
8010340c:	83 c4 10             	add    $0x10,%esp
8010340f:	eb 8f                	jmp    801033a0 <begin_op+0x20>
80103411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103418:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010341b:	a3 fc 66 18 80       	mov    %eax,0x801866fc
      release(&log.lock);
80103420:	68 c0 66 18 80       	push   $0x801866c0
80103425:	e8 46 1b 00 00       	call   80104f70 <release>
      break;
    }
  }
}
8010342a:	83 c4 10             	add    $0x10,%esp
8010342d:	c9                   	leave  
8010342e:	c3                   	ret    
8010342f:	90                   	nop

80103430 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	55                   	push   %ebp
80103435:	89 e5                	mov    %esp,%ebp
80103437:	57                   	push   %edi
80103438:	56                   	push   %esi
80103439:	53                   	push   %ebx
8010343a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010343d:	68 c0 66 18 80       	push   $0x801866c0
80103442:	e8 69 1a 00 00       	call   80104eb0 <acquire>
  log.outstanding -= 1;
80103447:	a1 fc 66 18 80       	mov    0x801866fc,%eax
  if(log.committing)
8010344c:	8b 35 00 67 18 80    	mov    0x80186700,%esi
80103452:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103455:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103458:	89 1d fc 66 18 80    	mov    %ebx,0x801866fc
  if(log.committing)
8010345e:	85 f6                	test   %esi,%esi
80103460:	0f 85 1e 01 00 00    	jne    80103584 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103466:	85 db                	test   %ebx,%ebx
80103468:	0f 85 f2 00 00 00    	jne    80103560 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010346e:	c7 05 00 67 18 80 01 	movl   $0x1,0x80186700
80103475:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103478:	83 ec 0c             	sub    $0xc,%esp
8010347b:	68 c0 66 18 80       	push   $0x801866c0
80103480:	e8 eb 1a 00 00       	call   80104f70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103485:	8b 0d 08 67 18 80    	mov    0x80186708,%ecx
8010348b:	83 c4 10             	add    $0x10,%esp
8010348e:	85 c9                	test   %ecx,%ecx
80103490:	7f 3e                	jg     801034d0 <end_op+0xa0>
    acquire(&log.lock);
80103492:	83 ec 0c             	sub    $0xc,%esp
80103495:	68 c0 66 18 80       	push   $0x801866c0
8010349a:	e8 11 1a 00 00       	call   80104eb0 <acquire>
    wakeup(&log);
8010349f:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
    log.committing = 0;
801034a6:	c7 05 00 67 18 80 00 	movl   $0x0,0x80186700
801034ad:	00 00 00 
    wakeup(&log);
801034b0:	e8 2b 15 00 00       	call   801049e0 <wakeup>
    release(&log.lock);
801034b5:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
801034bc:	e8 af 1a 00 00       	call   80104f70 <release>
801034c1:	83 c4 10             	add    $0x10,%esp
}
801034c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034d0:	a1 f4 66 18 80       	mov    0x801866f4,%eax
801034d5:	83 ec 08             	sub    $0x8,%esp
801034d8:	01 d8                	add    %ebx,%eax
801034da:	83 c0 01             	add    $0x1,%eax
801034dd:	50                   	push   %eax
801034de:	ff 35 04 67 18 80    	pushl  0x80186704
801034e4:	e8 e7 cb ff ff       	call   801000d0 <bread>
801034e9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034eb:	58                   	pop    %eax
801034ec:	5a                   	pop    %edx
801034ed:	ff 34 9d 0c 67 18 80 	pushl  -0x7fe798f4(,%ebx,4)
801034f4:	ff 35 04 67 18 80    	pushl  0x80186704
  for (tail = 0; tail < log.lh.n; tail++) {
801034fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034fd:	e8 ce cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103502:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103505:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010350a:	68 00 02 00 00       	push   $0x200
8010350f:	50                   	push   %eax
80103510:	8d 46 5c             	lea    0x5c(%esi),%eax
80103513:	50                   	push   %eax
80103514:	e8 47 1b 00 00       	call   80105060 <memmove>
    bwrite(to);  // write the log
80103519:	89 34 24             	mov    %esi,(%esp)
8010351c:	e8 8f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103521:	89 3c 24             	mov    %edi,(%esp)
80103524:	e8 c7 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103529:	89 34 24             	mov    %esi,(%esp)
8010352c:	e8 bf cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103531:	83 c4 10             	add    $0x10,%esp
80103534:	3b 1d 08 67 18 80    	cmp    0x80186708,%ebx
8010353a:	7c 94                	jl     801034d0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010353c:	e8 3f fd ff ff       	call   80103280 <write_head>
    install_trans(); // Now install writes to home locations
80103541:	e8 9a fc ff ff       	call   801031e0 <install_trans>
    log.lh.n = 0;
80103546:	c7 05 08 67 18 80 00 	movl   $0x0,0x80186708
8010354d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103550:	e8 2b fd ff ff       	call   80103280 <write_head>
80103555:	e9 38 ff ff ff       	jmp    80103492 <end_op+0x62>
8010355a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	68 c0 66 18 80       	push   $0x801866c0
80103568:	e8 73 14 00 00       	call   801049e0 <wakeup>
  release(&log.lock);
8010356d:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
80103574:	e8 f7 19 00 00       	call   80104f70 <release>
80103579:	83 c4 10             	add    $0x10,%esp
}
8010357c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357f:	5b                   	pop    %ebx
80103580:	5e                   	pop    %esi
80103581:	5f                   	pop    %edi
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
    panic("log.committing");
80103584:	83 ec 0c             	sub    $0xc,%esp
80103587:	68 7f 88 10 80       	push   $0x8010887f
8010358c:	e8 ff cd ff ff       	call   80100390 <panic>
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010359f:	90                   	nop

801035a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	53                   	push   %ebx
801035a8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035ab:	8b 15 08 67 18 80    	mov    0x80186708,%edx
{
801035b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035b4:	83 fa 1d             	cmp    $0x1d,%edx
801035b7:	0f 8f 91 00 00 00    	jg     8010364e <log_write+0xae>
801035bd:	a1 f8 66 18 80       	mov    0x801866f8,%eax
801035c2:	83 e8 01             	sub    $0x1,%eax
801035c5:	39 c2                	cmp    %eax,%edx
801035c7:	0f 8d 81 00 00 00    	jge    8010364e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035cd:	a1 fc 66 18 80       	mov    0x801866fc,%eax
801035d2:	85 c0                	test   %eax,%eax
801035d4:	0f 8e 81 00 00 00    	jle    8010365b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035da:	83 ec 0c             	sub    $0xc,%esp
801035dd:	68 c0 66 18 80       	push   $0x801866c0
801035e2:	e8 c9 18 00 00       	call   80104eb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035e7:	8b 15 08 67 18 80    	mov    0x80186708,%edx
801035ed:	83 c4 10             	add    $0x10,%esp
801035f0:	85 d2                	test   %edx,%edx
801035f2:	7e 4e                	jle    80103642 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035f4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801035f7:	31 c0                	xor    %eax,%eax
801035f9:	eb 0c                	jmp    80103607 <log_write+0x67>
801035fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035ff:	90                   	nop
80103600:	83 c0 01             	add    $0x1,%eax
80103603:	39 c2                	cmp    %eax,%edx
80103605:	74 29                	je     80103630 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103607:	39 0c 85 0c 67 18 80 	cmp    %ecx,-0x7fe798f4(,%eax,4)
8010360e:	75 f0                	jne    80103600 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103610:	89 0c 85 0c 67 18 80 	mov    %ecx,-0x7fe798f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103617:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010361a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010361d:	c7 45 08 c0 66 18 80 	movl   $0x801866c0,0x8(%ebp)
}
80103624:	c9                   	leave  
  release(&log.lock);
80103625:	e9 46 19 00 00       	jmp    80104f70 <release>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103630:	89 0c 95 0c 67 18 80 	mov    %ecx,-0x7fe798f4(,%edx,4)
    log.lh.n++;
80103637:	83 c2 01             	add    $0x1,%edx
8010363a:	89 15 08 67 18 80    	mov    %edx,0x80186708
80103640:	eb d5                	jmp    80103617 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103642:	8b 43 08             	mov    0x8(%ebx),%eax
80103645:	a3 0c 67 18 80       	mov    %eax,0x8018670c
  if (i == log.lh.n)
8010364a:	75 cb                	jne    80103617 <log_write+0x77>
8010364c:	eb e9                	jmp    80103637 <log_write+0x97>
    panic("too big a transaction");
8010364e:	83 ec 0c             	sub    $0xc,%esp
80103651:	68 8e 88 10 80       	push   $0x8010888e
80103656:	e8 35 cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	68 a4 88 10 80       	push   $0x801088a4
80103663:	e8 28 cd ff ff       	call   80100390 <panic>
80103668:	66 90                	xchg   %ax,%ax
8010366a:	66 90                	xchg   %ax,%ax
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
80103674:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103677:	e8 34 0a 00 00       	call   801040b0 <cpuid>
8010367c:	89 c3                	mov    %eax,%ebx
8010367e:	e8 2d 0a 00 00       	call   801040b0 <cpuid>
80103683:	83 ec 04             	sub    $0x4,%esp
80103686:	53                   	push   %ebx
80103687:	50                   	push   %eax
80103688:	68 bf 88 10 80       	push   $0x801088bf
8010368d:	e8 1e d0 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103692:	e8 19 2c 00 00       	call   801062b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103697:	e8 a4 09 00 00       	call   80104040 <mycpu>
8010369c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010369e:	b8 01 00 00 00       	mov    $0x1,%eax
801036a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036aa:	e8 11 0e 00 00       	call   801044c0 <scheduler>
801036af:	90                   	nop

801036b0 <mpenter>:
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036ba:	e8 81 3c 00 00       	call   80107340 <switchkvm>
  seginit();
801036bf:	e8 ec 3b 00 00       	call   801072b0 <seginit>
  lapicinit();
801036c4:	e8 27 f7 ff ff       	call   80102df0 <lapicinit>
  mpmain();
801036c9:	e8 a2 ff ff ff       	call   80103670 <mpmain>
801036ce:	66 90                	xchg   %ax,%ax

801036d0 <main>:
{
801036d0:	f3 0f 1e fb          	endbr32 
801036d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036d8:	83 e4 f0             	and    $0xfffffff0,%esp
801036db:	ff 71 fc             	pushl  -0x4(%ecx)
801036de:	55                   	push   %ebp
801036df:	89 e5                	mov    %esp,%ebp
801036e1:	53                   	push   %ebx
801036e2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801036e3:	83 ec 08             	sub    $0x8,%esp
801036e6:	68 00 00 40 80       	push   $0x80400000
801036eb:	68 e8 1b 19 80       	push   $0x80191be8
801036f0:	e8 6b f3 ff ff       	call   80102a60 <kinit1>
  kvmalloc();      // kernel page table
801036f5:	e8 b6 44 00 00       	call   80107bb0 <kvmalloc>
  mpinit();        // detect other processors
801036fa:	e8 81 01 00 00       	call   80103880 <mpinit>
  lapicinit();     // interrupt controller
801036ff:	e8 ec f6 ff ff       	call   80102df0 <lapicinit>
  seginit();       // segment descriptors
80103704:	e8 a7 3b 00 00       	call   801072b0 <seginit>
  picinit();       // disable pic
80103709:	e8 52 03 00 00       	call   80103a60 <picinit>
  ioapicinit();    // another interrupt controller
8010370e:	e8 2d f0 ff ff       	call   80102740 <ioapicinit>
  consoleinit();   // console hardware
80103713:	e8 18 d3 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103718:	e8 93 2e 00 00       	call   801065b0 <uartinit>
  pinit();         // process table
8010371d:	e8 fe 08 00 00       	call   80104020 <pinit>
  tvinit();        // trap vectors
80103722:	e8 09 2b 00 00       	call   80106230 <tvinit>
  binit();         // buffer cache
80103727:	e8 14 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010372c:	e8 ef d6 ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
80103731:	e8 da ed ff ff       	call   80102510 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103736:	83 c4 0c             	add    $0xc,%esp
80103739:	68 8a 00 00 00       	push   $0x8a
8010373e:	68 8c c4 10 80       	push   $0x8010c48c
80103743:	68 00 70 00 80       	push   $0x80007000
80103748:	e8 13 19 00 00       	call   80105060 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010374d:	83 c4 10             	add    $0x10,%esp
80103750:	69 05 40 6d 18 80 b0 	imul   $0xb0,0x80186d40,%eax
80103757:	00 00 00 
8010375a:	05 c0 67 18 80       	add    $0x801867c0,%eax
8010375f:	3d c0 67 18 80       	cmp    $0x801867c0,%eax
80103764:	76 7a                	jbe    801037e0 <main+0x110>
80103766:	bb c0 67 18 80       	mov    $0x801867c0,%ebx
8010376b:	eb 1c                	jmp    80103789 <main+0xb9>
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
80103770:	69 05 40 6d 18 80 b0 	imul   $0xb0,0x80186d40,%eax
80103777:	00 00 00 
8010377a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103780:	05 c0 67 18 80       	add    $0x801867c0,%eax
80103785:	39 c3                	cmp    %eax,%ebx
80103787:	73 57                	jae    801037e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103789:	e8 b2 08 00 00       	call   80104040 <mycpu>
8010378e:	39 c3                	cmp    %eax,%ebx
80103790:	74 de                	je     80103770 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103792:	e8 99 f3 ff ff       	call   80102b30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103797:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010379a:	c7 05 f8 6f 00 80 b0 	movl   $0x801036b0,0x80006ff8
801037a1:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037a4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801037ab:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037ae:	05 00 10 00 00       	add    $0x1000,%eax
801037b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801037b8:	0f b6 03             	movzbl (%ebx),%eax
801037bb:	68 00 70 00 00       	push   $0x7000
801037c0:	50                   	push   %eax
801037c1:	e8 7a f7 ff ff       	call   80102f40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037d6:	85 c0                	test   %eax,%eax
801037d8:	74 f6                	je     801037d0 <main+0x100>
801037da:	eb 94                	jmp    80103770 <main+0xa0>
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037e0:	83 ec 08             	sub    $0x8,%esp
801037e3:	68 00 00 00 8e       	push   $0x8e000000
801037e8:	68 00 00 40 80       	push   $0x80400000
801037ed:	e8 de f2 ff ff       	call   80102ad0 <kinit2>
  userinit();      // first user process
801037f2:	e8 09 09 00 00       	call   80104100 <userinit>
  mpmain();        // finish this processor's setup
801037f7:	e8 74 fe ff ff       	call   80103670 <mpmain>
801037fc:	66 90                	xchg   %ax,%ax
801037fe:	66 90                	xchg   %ax,%ax

80103800 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103805:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010380b:	53                   	push   %ebx
  e = addr+len;
8010380c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010380f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103812:	39 de                	cmp    %ebx,%esi
80103814:	72 10                	jb     80103826 <mpsearch1+0x26>
80103816:	eb 50                	jmp    80103868 <mpsearch1+0x68>
80103818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010381f:	90                   	nop
80103820:	89 fe                	mov    %edi,%esi
80103822:	39 fb                	cmp    %edi,%ebx
80103824:	76 42                	jbe    80103868 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103826:	83 ec 04             	sub    $0x4,%esp
80103829:	8d 7e 10             	lea    0x10(%esi),%edi
8010382c:	6a 04                	push   $0x4
8010382e:	68 d3 88 10 80       	push   $0x801088d3
80103833:	56                   	push   %esi
80103834:	e8 d7 17 00 00       	call   80105010 <memcmp>
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	85 c0                	test   %eax,%eax
8010383e:	75 e0                	jne    80103820 <mpsearch1+0x20>
80103840:	89 f2                	mov    %esi,%edx
80103842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103848:	0f b6 0a             	movzbl (%edx),%ecx
8010384b:	83 c2 01             	add    $0x1,%edx
8010384e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103850:	39 fa                	cmp    %edi,%edx
80103852:	75 f4                	jne    80103848 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103854:	84 c0                	test   %al,%al
80103856:	75 c8                	jne    80103820 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010385b:	89 f0                	mov    %esi,%eax
8010385d:	5b                   	pop    %ebx
8010385e:	5e                   	pop    %esi
8010385f:	5f                   	pop    %edi
80103860:	5d                   	pop    %ebp
80103861:	c3                   	ret    
80103862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010386b:	31 f6                	xor    %esi,%esi
}
8010386d:	5b                   	pop    %ebx
8010386e:	89 f0                	mov    %esi,%eax
80103870:	5e                   	pop    %esi
80103871:	5f                   	pop    %edi
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	57                   	push   %edi
80103888:	56                   	push   %esi
80103889:	53                   	push   %ebx
8010388a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010388d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103894:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010389b:	c1 e0 08             	shl    $0x8,%eax
8010389e:	09 d0                	or     %edx,%eax
801038a0:	c1 e0 04             	shl    $0x4,%eax
801038a3:	75 1b                	jne    801038c0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038a5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038ac:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038b3:	c1 e0 08             	shl    $0x8,%eax
801038b6:	09 d0                	or     %edx,%eax
801038b8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038bb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038c0:	ba 00 04 00 00       	mov    $0x400,%edx
801038c5:	e8 36 ff ff ff       	call   80103800 <mpsearch1>
801038ca:	89 c6                	mov    %eax,%esi
801038cc:	85 c0                	test   %eax,%eax
801038ce:	0f 84 4c 01 00 00    	je     80103a20 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038d4:	8b 5e 04             	mov    0x4(%esi),%ebx
801038d7:	85 db                	test   %ebx,%ebx
801038d9:	0f 84 61 01 00 00    	je     80103a40 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801038df:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038e2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801038e8:	6a 04                	push   $0x4
801038ea:	68 d8 88 10 80       	push   $0x801088d8
801038ef:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801038f3:	e8 18 17 00 00       	call   80105010 <memcmp>
801038f8:	83 c4 10             	add    $0x10,%esp
801038fb:	85 c0                	test   %eax,%eax
801038fd:	0f 85 3d 01 00 00    	jne    80103a40 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103903:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010390a:	3c 01                	cmp    $0x1,%al
8010390c:	74 08                	je     80103916 <mpinit+0x96>
8010390e:	3c 04                	cmp    $0x4,%al
80103910:	0f 85 2a 01 00 00    	jne    80103a40 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103916:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010391d:	66 85 d2             	test   %dx,%dx
80103920:	74 26                	je     80103948 <mpinit+0xc8>
80103922:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103925:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103927:	31 d2                	xor    %edx,%edx
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103930:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103937:	83 c0 01             	add    $0x1,%eax
8010393a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010393c:	39 f8                	cmp    %edi,%eax
8010393e:	75 f0                	jne    80103930 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103940:	84 d2                	test   %dl,%dl
80103942:	0f 85 f8 00 00 00    	jne    80103a40 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103948:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010394e:	a3 bc 66 18 80       	mov    %eax,0x801866bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103953:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103959:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103960:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103965:	03 55 e4             	add    -0x1c(%ebp),%edx
80103968:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010396b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop
80103970:	39 c2                	cmp    %eax,%edx
80103972:	76 15                	jbe    80103989 <mpinit+0x109>
    switch(*p){
80103974:	0f b6 08             	movzbl (%eax),%ecx
80103977:	80 f9 02             	cmp    $0x2,%cl
8010397a:	74 5c                	je     801039d8 <mpinit+0x158>
8010397c:	77 42                	ja     801039c0 <mpinit+0x140>
8010397e:	84 c9                	test   %cl,%cl
80103980:	74 6e                	je     801039f0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103982:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103985:	39 c2                	cmp    %eax,%edx
80103987:	77 eb                	ja     80103974 <mpinit+0xf4>
80103989:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010398c:	85 db                	test   %ebx,%ebx
8010398e:	0f 84 b9 00 00 00    	je     80103a4d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103994:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103998:	74 15                	je     801039af <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010399a:	b8 70 00 00 00       	mov    $0x70,%eax
8010399f:	ba 22 00 00 00       	mov    $0x22,%edx
801039a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039a5:	ba 23 00 00 00       	mov    $0x23,%edx
801039aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039ab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039ae:	ee                   	out    %al,(%dx)
  }
}
801039af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b2:	5b                   	pop    %ebx
801039b3:	5e                   	pop    %esi
801039b4:	5f                   	pop    %edi
801039b5:	5d                   	pop    %ebp
801039b6:	c3                   	ret    
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax
    switch(*p){
801039c0:	83 e9 03             	sub    $0x3,%ecx
801039c3:	80 f9 01             	cmp    $0x1,%cl
801039c6:	76 ba                	jbe    80103982 <mpinit+0x102>
801039c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801039cf:	eb 9f                	jmp    80103970 <mpinit+0xf0>
801039d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039d8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801039dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039df:	88 0d a0 67 18 80    	mov    %cl,0x801867a0
      continue;
801039e5:	eb 89                	jmp    80103970 <mpinit+0xf0>
801039e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ee:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801039f0:	8b 0d 40 6d 18 80    	mov    0x80186d40,%ecx
801039f6:	83 f9 07             	cmp    $0x7,%ecx
801039f9:	7f 19                	jg     80103a14 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039fb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103a01:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103a05:	83 c1 01             	add    $0x1,%ecx
80103a08:	89 0d 40 6d 18 80    	mov    %ecx,0x80186d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a0e:	88 9f c0 67 18 80    	mov    %bl,-0x7fe79840(%edi)
      p += sizeof(struct mpproc);
80103a14:	83 c0 14             	add    $0x14,%eax
      continue;
80103a17:	e9 54 ff ff ff       	jmp    80103970 <mpinit+0xf0>
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a2a:	e8 d1 fd ff ff       	call   80103800 <mpsearch1>
80103a2f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a31:	85 c0                	test   %eax,%eax
80103a33:	0f 85 9b fe ff ff    	jne    801038d4 <mpinit+0x54>
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 dd 88 10 80       	push   $0x801088dd
80103a48:	e8 43 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 f8 88 10 80       	push   $0x801088f8
80103a55:	e8 36 c9 ff ff       	call   80100390 <panic>
80103a5a:	66 90                	xchg   %ax,%ax
80103a5c:	66 90                	xchg   %ax,%ax
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a69:	ba 21 00 00 00       	mov    $0x21,%edx
80103a6e:	ee                   	out    %al,(%dx)
80103a6f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a74:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a75:	c3                   	ret    
80103a76:	66 90                	xchg   %ax,%ax
80103a78:	66 90                	xchg   %ax,%ax
80103a7a:	66 90                	xchg   %ax,%ax
80103a7c:	66 90                	xchg   %ax,%ax
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	57                   	push   %edi
80103a88:	56                   	push   %esi
80103a89:	53                   	push   %ebx
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a90:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a93:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a99:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a9f:	e8 9c d3 ff ff       	call   80100e40 <filealloc>
80103aa4:	89 03                	mov    %eax,(%ebx)
80103aa6:	85 c0                	test   %eax,%eax
80103aa8:	0f 84 ac 00 00 00    	je     80103b5a <pipealloc+0xda>
80103aae:	e8 8d d3 ff ff       	call   80100e40 <filealloc>
80103ab3:	89 06                	mov    %eax,(%esi)
80103ab5:	85 c0                	test   %eax,%eax
80103ab7:	0f 84 8b 00 00 00    	je     80103b48 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103abd:	e8 6e f0 ff ff       	call   80102b30 <kalloc>
80103ac2:	89 c7                	mov    %eax,%edi
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	0f 84 b4 00 00 00    	je     80103b80 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103acc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ad3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ad6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ad9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ae0:	00 00 00 
  p->nwrite = 0;
80103ae3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103aea:	00 00 00 
  p->nread = 0;
80103aed:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103af4:	00 00 00 
  initlock(&p->lock, "pipe");
80103af7:	68 17 89 10 80       	push   $0x80108917
80103afc:	50                   	push   %eax
80103afd:	e8 2e 12 00 00       	call   80104d30 <initlock>
  (*f0)->type = FD_PIPE;
80103b02:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b04:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b07:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b0d:	8b 03                	mov    (%ebx),%eax
80103b0f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b13:	8b 03                	mov    (%ebx),%eax
80103b15:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b19:	8b 03                	mov    (%ebx),%eax
80103b1b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b1e:	8b 06                	mov    (%esi),%eax
80103b20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b26:	8b 06                	mov    (%esi),%eax
80103b28:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b2c:	8b 06                	mov    (%esi),%eax
80103b2e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b32:	8b 06                	mov    (%esi),%eax
80103b34:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b3a:	31 c0                	xor    %eax,%eax
}
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b48:	8b 03                	mov    (%ebx),%eax
80103b4a:	85 c0                	test   %eax,%eax
80103b4c:	74 1e                	je     80103b6c <pipealloc+0xec>
    fileclose(*f0);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	50                   	push   %eax
80103b52:	e8 a9 d3 ff ff       	call   80100f00 <fileclose>
80103b57:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b5a:	8b 06                	mov    (%esi),%eax
80103b5c:	85 c0                	test   %eax,%eax
80103b5e:	74 0c                	je     80103b6c <pipealloc+0xec>
    fileclose(*f1);
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	50                   	push   %eax
80103b64:	e8 97 d3 ff ff       	call   80100f00 <fileclose>
80103b69:	83 c4 10             	add    $0x10,%esp
}
80103b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b74:	5b                   	pop    %ebx
80103b75:	5e                   	pop    %esi
80103b76:	5f                   	pop    %edi
80103b77:	5d                   	pop    %ebp
80103b78:	c3                   	ret    
80103b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b80:	8b 03                	mov    (%ebx),%eax
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 c8                	jne    80103b4e <pipealloc+0xce>
80103b86:	eb d2                	jmp    80103b5a <pipealloc+0xda>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	56                   	push   %esi
80103b98:	53                   	push   %ebx
80103b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b9f:	83 ec 0c             	sub    $0xc,%esp
80103ba2:	53                   	push   %ebx
80103ba3:	e8 08 13 00 00       	call   80104eb0 <acquire>
  if(writable){
80103ba8:	83 c4 10             	add    $0x10,%esp
80103bab:	85 f6                	test   %esi,%esi
80103bad:	74 41                	je     80103bf0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103baf:	83 ec 0c             	sub    $0xc,%esp
80103bb2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103bb8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bbf:	00 00 00 
    wakeup(&p->nread);
80103bc2:	50                   	push   %eax
80103bc3:	e8 18 0e 00 00       	call   801049e0 <wakeup>
80103bc8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bcb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bd1:	85 d2                	test   %edx,%edx
80103bd3:	75 0a                	jne    80103bdf <pipeclose+0x4f>
80103bd5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	74 31                	je     80103c10 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103bdf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103be2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be5:	5b                   	pop    %ebx
80103be6:	5e                   	pop    %esi
80103be7:	5d                   	pop    %ebp
    release(&p->lock);
80103be8:	e9 83 13 00 00       	jmp    80104f70 <release>
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103bf9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c00:	00 00 00 
    wakeup(&p->nwrite);
80103c03:	50                   	push   %eax
80103c04:	e8 d7 0d 00 00       	call   801049e0 <wakeup>
80103c09:	83 c4 10             	add    $0x10,%esp
80103c0c:	eb bd                	jmp    80103bcb <pipeclose+0x3b>
80103c0e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	53                   	push   %ebx
80103c14:	e8 57 13 00 00       	call   80104f70 <release>
    kfree((char*)p);
80103c19:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c1c:	83 c4 10             	add    $0x10,%esp
}
80103c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c22:	5b                   	pop    %ebx
80103c23:	5e                   	pop    %esi
80103c24:	5d                   	pop    %ebp
    kfree((char*)p);
80103c25:	e9 06 ec ff ff       	jmp    80102830 <kfree>
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	57                   	push   %edi
80103c38:	56                   	push   %esi
80103c39:	53                   	push   %ebx
80103c3a:	83 ec 28             	sub    $0x28,%esp
80103c3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c40:	53                   	push   %ebx
80103c41:	e8 6a 12 00 00       	call   80104eb0 <acquire>
  for(i = 0; i < n; i++){
80103c46:	8b 45 10             	mov    0x10(%ebp),%eax
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	85 c0                	test   %eax,%eax
80103c4e:	0f 8e bc 00 00 00    	jle    80103d10 <pipewrite+0xe0>
80103c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c57:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c5d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c66:	03 45 10             	add    0x10(%ebp),%eax
80103c69:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c6c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c72:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c78:	89 ca                	mov    %ecx,%edx
80103c7a:	05 00 02 00 00       	add    $0x200,%eax
80103c7f:	39 c1                	cmp    %eax,%ecx
80103c81:	74 3b                	je     80103cbe <pipewrite+0x8e>
80103c83:	eb 63                	jmp    80103ce8 <pipewrite+0xb8>
80103c85:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c88:	e8 43 04 00 00       	call   801040d0 <myproc>
80103c8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c90:	85 c9                	test   %ecx,%ecx
80103c92:	75 34                	jne    80103cc8 <pipewrite+0x98>
      wakeup(&p->nread);
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	57                   	push   %edi
80103c98:	e8 43 0d 00 00       	call   801049e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c9d:	58                   	pop    %eax
80103c9e:	5a                   	pop    %edx
80103c9f:	53                   	push   %ebx
80103ca0:	56                   	push   %esi
80103ca1:	e8 3a 0b 00 00       	call   801047e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ca6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cb2:	83 c4 10             	add    $0x10,%esp
80103cb5:	05 00 02 00 00       	add    $0x200,%eax
80103cba:	39 c2                	cmp    %eax,%edx
80103cbc:	75 2a                	jne    80103ce8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103cbe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cc4:	85 c0                	test   %eax,%eax
80103cc6:	75 c0                	jne    80103c88 <pipewrite+0x58>
        release(&p->lock);
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	53                   	push   %ebx
80103ccc:	e8 9f 12 00 00       	call   80104f70 <release>
        return -1;
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cdc:	5b                   	pop    %ebx
80103cdd:	5e                   	pop    %esi
80103cde:	5f                   	pop    %edi
80103cdf:	5d                   	pop    %ebp
80103ce0:	c3                   	ret    
80103ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ce8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ceb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cf4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103cfa:	0f b6 06             	movzbl (%esi),%eax
80103cfd:	83 c6 01             	add    $0x1,%esi
80103d00:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103d03:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d07:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d0a:	0f 85 5c ff ff ff    	jne    80103c6c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d19:	50                   	push   %eax
80103d1a:	e8 c1 0c 00 00       	call   801049e0 <wakeup>
  release(&p->lock);
80103d1f:	89 1c 24             	mov    %ebx,(%esp)
80103d22:	e8 49 12 00 00       	call   80104f70 <release>
  return n;
80103d27:	8b 45 10             	mov    0x10(%ebp),%eax
80103d2a:	83 c4 10             	add    $0x10,%esp
80103d2d:	eb aa                	jmp    80103cd9 <pipewrite+0xa9>
80103d2f:	90                   	nop

80103d30 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d30:	f3 0f 1e fb          	endbr32 
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	57                   	push   %edi
80103d38:	56                   	push   %esi
80103d39:	53                   	push   %ebx
80103d3a:	83 ec 18             	sub    $0x18,%esp
80103d3d:	8b 75 08             	mov    0x8(%ebp),%esi
80103d40:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d43:	56                   	push   %esi
80103d44:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d4a:	e8 61 11 00 00       	call   80104eb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d4f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103d5e:	74 33                	je     80103d93 <piperead+0x63>
80103d60:	eb 3b                	jmp    80103d9d <piperead+0x6d>
80103d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103d68:	e8 63 03 00 00       	call   801040d0 <myproc>
80103d6d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d70:	85 c9                	test   %ecx,%ecx
80103d72:	0f 85 88 00 00 00    	jne    80103e00 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d78:	83 ec 08             	sub    $0x8,%esp
80103d7b:	56                   	push   %esi
80103d7c:	53                   	push   %ebx
80103d7d:	e8 5e 0a 00 00       	call   801047e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d82:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d91:	75 0a                	jne    80103d9d <piperead+0x6d>
80103d93:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d99:	85 c0                	test   %eax,%eax
80103d9b:	75 cb                	jne    80103d68 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d9d:	8b 55 10             	mov    0x10(%ebp),%edx
80103da0:	31 db                	xor    %ebx,%ebx
80103da2:	85 d2                	test   %edx,%edx
80103da4:	7f 28                	jg     80103dce <piperead+0x9e>
80103da6:	eb 34                	jmp    80103ddc <piperead+0xac>
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103db0:	8d 48 01             	lea    0x1(%eax),%ecx
80103db3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103db8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103dbe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103dc3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103dc6:	83 c3 01             	add    $0x1,%ebx
80103dc9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103dcc:	74 0e                	je     80103ddc <piperead+0xac>
    if(p->nread == p->nwrite)
80103dce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103dd4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103dda:	75 d4                	jne    80103db0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103ddc:	83 ec 0c             	sub    $0xc,%esp
80103ddf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103de5:	50                   	push   %eax
80103de6:	e8 f5 0b 00 00       	call   801049e0 <wakeup>
  release(&p->lock);
80103deb:	89 34 24             	mov    %esi,(%esp)
80103dee:	e8 7d 11 00 00       	call   80104f70 <release>
  return i;
80103df3:	83 c4 10             	add    $0x10,%esp
}
80103df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df9:	89 d8                	mov    %ebx,%eax
80103dfb:	5b                   	pop    %ebx
80103dfc:	5e                   	pop    %esi
80103dfd:	5f                   	pop    %edi
80103dfe:	5d                   	pop    %ebp
80103dff:	c3                   	ret    
      release(&p->lock);
80103e00:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e08:	56                   	push   %esi
80103e09:	e8 62 11 00 00       	call   80104f70 <release>
      return -1;
80103e0e:	83 c4 10             	add    $0x10,%esp
}
80103e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e14:	89 d8                	mov    %ebx,%eax
80103e16:	5b                   	pop    %ebx
80103e17:	5e                   	pop    %esi
80103e18:	5f                   	pop    %edi
80103e19:	5d                   	pop    %ebp
80103e1a:	c3                   	ret    
80103e1b:	66 90                	xchg   %ax,%ax
80103e1d:	66 90                	xchg   %ax,%ax
80103e1f:	90                   	nop

80103e20 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e26:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
{
80103e2b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103e2e:	68 60 6d 18 80       	push   $0x80186d60
80103e33:	e8 78 10 00 00       	call   80104eb0 <acquire>
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	eb 15                	jmp    80103e52 <allocproc+0x32>
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e40:	81 c3 98 02 00 00    	add    $0x298,%ebx
80103e46:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80103e4c:	0f 84 3e 01 00 00    	je     80103f90 <allocproc+0x170>
    if(p->state == UNUSED)
80103e52:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e55:	85 c0                	test   %eax,%eax
80103e57:	75 e7                	jne    80103e40 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e59:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103e5e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e68:	89 43 10             	mov    %eax,0x10(%ebx)
80103e6b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103e6e:	68 60 6d 18 80       	push   $0x80186d60
  p->pid = nextpid++;
80103e73:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103e79:	e8 f2 10 00 00       	call   80104f70 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e7e:	e8 ad ec ff ff       	call   80102b30 <kalloc>
80103e83:	83 c4 10             	add    $0x10,%esp
80103e86:	89 43 08             	mov    %eax,0x8(%ebx)
80103e89:	85 c0                	test   %eax,%eax
80103e8b:	0f 84 1b 01 00 00    	je     80103fac <allocproc+0x18c>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e91:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e97:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e9a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e9f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ea2:	c7 40 14 21 62 10 80 	movl   $0x80106221,0x14(%eax)
  p->context = (struct context*)sp;
80103ea9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103eac:	6a 14                	push   $0x14
80103eae:	6a 00                	push   $0x0
80103eb0:	50                   	push   %eax
80103eb1:	e8 0a 11 00 00       	call   80104fc0 <memset>
  p->context->eip = (uint)forkret;
80103eb6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80103eb9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ebc:	c7 40 10 d0 3f 10 80 	movl   $0x80103fd0,0x10(%eax)
  if(p->pid > 2) {
80103ec3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103ec7:	7f 0f                	jg     80103ed8 <allocproc+0xb8>
    }
  }


  return p;
}
80103ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ecc:	89 d8                	mov    %ebx,%eax
80103ece:	5b                   	pop    %ebx
80103ecf:	5e                   	pop    %esi
80103ed0:	5f                   	pop    %edi
80103ed1:	5d                   	pop    %ebp
80103ed2:	c3                   	ret    
80103ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed7:	90                   	nop
    if(createSwapFile(p) != 0)
80103ed8:	83 ec 0c             	sub    $0xc,%esp
80103edb:	53                   	push   %ebx
80103edc:	e8 4f e4 ff ff       	call   80102330 <createSwapFile>
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	85 c0                	test   %eax,%eax
80103ee6:	0f 85 d3 00 00 00    	jne    80103fbf <allocproc+0x19f>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103eec:	83 ec 04             	sub    $0x4,%esp
80103eef:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
    p->num_ram = 0;
80103ef5:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103efc:	00 00 00 
    p->num_swap = 0;
80103eff:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80103f06:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103f09:	68 00 01 00 00       	push   $0x100
80103f0e:	6a 00                	push   $0x0
80103f10:	50                   	push   %eax
80103f11:	e8 aa 10 00 00       	call   80104fc0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103f16:	83 c4 0c             	add    $0xc,%esp
80103f19:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103f1f:	68 00 01 00 00       	push   $0x100
80103f24:	6a 00                	push   $0x0
80103f26:	50                   	push   %eax
80103f27:	e8 94 10 00 00       	call   80104fc0 <memset>
    if(p->pid > 2)
80103f2c:	83 c4 10             	add    $0x10,%esp
80103f2f:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103f33:	7e 94                	jle    80103ec9 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80103f35:	e8 f6 eb ff ff       	call   80102b30 <kalloc>
      struct fblock *prev = p->free_head;
80103f3a:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head = (struct fblock*)kalloc();
80103f3f:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
      p->free_head->prev = 0;
80103f45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      p->free_head->off = 0 * PGSIZE;
80103f4c:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80103f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80103f58:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103f5e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80103f60:	89 c7                	mov    %eax,%edi
80103f62:	e8 c9 eb ff ff       	call   80102b30 <kalloc>
        curr->off = i * PGSIZE;
80103f67:	89 30                	mov    %esi,(%eax)
        curr->prev = prev;
80103f69:	81 c6 00 10 00 00    	add    $0x1000,%esi
80103f6f:	89 78 08             	mov    %edi,0x8(%eax)
        curr->prev->next = curr;
80103f72:	89 47 04             	mov    %eax,0x4(%edi)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103f75:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
80103f7b:	75 e3                	jne    80103f60 <allocproc+0x140>
      p->free_tail = prev;
80103f7d:	89 83 94 02 00 00    	mov    %eax,0x294(%ebx)
      p->free_tail->next = 0;
80103f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80103f8a:	e9 3a ff ff ff       	jmp    80103ec9 <allocproc+0xa9>
80103f8f:	90                   	nop
  release(&ptable.lock);
80103f90:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f93:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f95:	68 60 6d 18 80       	push   $0x80186d60
80103f9a:	e8 d1 0f 00 00       	call   80104f70 <release>
  return 0;
80103f9f:	83 c4 10             	add    $0x10,%esp
}
80103fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fa5:	89 d8                	mov    %ebx,%eax
80103fa7:	5b                   	pop    %ebx
80103fa8:	5e                   	pop    %esi
80103fa9:	5f                   	pop    %edi
80103faa:	5d                   	pop    %ebp
80103fab:	c3                   	ret    
    p->state = UNUSED;
80103fac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103fb6:	31 db                	xor    %ebx,%ebx
}
80103fb8:	89 d8                	mov    %ebx,%eax
80103fba:	5b                   	pop    %ebx
80103fbb:	5e                   	pop    %esi
80103fbc:	5f                   	pop    %edi
80103fbd:	5d                   	pop    %ebp
80103fbe:	c3                   	ret    
      panic("allocproc: createSwapFile");
80103fbf:	83 ec 0c             	sub    $0xc,%esp
80103fc2:	68 1c 89 10 80       	push   $0x8010891c
80103fc7:	e8 c4 c3 ff ff       	call   80100390 <panic>
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fd0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103fd0:	f3 0f 1e fb          	endbr32 
80103fd4:	55                   	push   %ebp
80103fd5:	89 e5                	mov    %esp,%ebp
80103fd7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103fda:	68 60 6d 18 80       	push   $0x80186d60
80103fdf:	e8 8c 0f 00 00       	call   80104f70 <release>

  if (first) {
80103fe4:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103fe9:	83 c4 10             	add    $0x10,%esp
80103fec:	85 c0                	test   %eax,%eax
80103fee:	75 08                	jne    80103ff8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ff0:	c9                   	leave  
80103ff1:	c3                   	ret    
80103ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103ff8:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103fff:	00 00 00 
    iinit(ROOTDEV);
80104002:	83 ec 0c             	sub    $0xc,%esp
80104005:	6a 01                	push   $0x1
80104007:	e8 74 d5 ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
8010400c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104013:	e8 c8 f2 ff ff       	call   801032e0 <initlog>
}
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	c9                   	leave  
8010401c:	c3                   	ret    
8010401d:	8d 76 00             	lea    0x0(%esi),%esi

80104020 <pinit>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010402a:	68 36 89 10 80       	push   $0x80108936
8010402f:	68 60 6d 18 80       	push   $0x80186d60
80104034:	e8 f7 0c 00 00       	call   80104d30 <initlock>
}
80104039:	83 c4 10             	add    $0x10,%esp
8010403c:	c9                   	leave  
8010403d:	c3                   	ret    
8010403e:	66 90                	xchg   %ax,%ax

80104040 <mycpu>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	56                   	push   %esi
80104048:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104049:	9c                   	pushf  
8010404a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010404b:	f6 c4 02             	test   $0x2,%ah
8010404e:	75 4a                	jne    8010409a <mycpu+0x5a>
  apicid = lapicid();
80104050:	e8 9b ee ff ff       	call   80102ef0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104055:	8b 35 40 6d 18 80    	mov    0x80186d40,%esi
  apicid = lapicid();
8010405b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010405d:	85 f6                	test   %esi,%esi
8010405f:	7e 2c                	jle    8010408d <mycpu+0x4d>
80104061:	31 d2                	xor    %edx,%edx
80104063:	eb 0a                	jmp    8010406f <mycpu+0x2f>
80104065:	8d 76 00             	lea    0x0(%esi),%esi
80104068:	83 c2 01             	add    $0x1,%edx
8010406b:	39 f2                	cmp    %esi,%edx
8010406d:	74 1e                	je     8010408d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010406f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104075:	0f b6 81 c0 67 18 80 	movzbl -0x7fe79840(%ecx),%eax
8010407c:	39 d8                	cmp    %ebx,%eax
8010407e:	75 e8                	jne    80104068 <mycpu+0x28>
}
80104080:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104083:	8d 81 c0 67 18 80    	lea    -0x7fe79840(%ecx),%eax
}
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
  panic("unknown apicid\n");
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	68 3d 89 10 80       	push   $0x8010893d
80104095:	e8 f6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 58 8a 10 80       	push   $0x80108a58
801040a2:	e8 e9 c2 ff ff       	call   80100390 <panic>
801040a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ae:	66 90                	xchg   %ax,%ax

801040b0 <cpuid>:
cpuid() {
801040b0:	f3 0f 1e fb          	endbr32 
801040b4:	55                   	push   %ebp
801040b5:	89 e5                	mov    %esp,%ebp
801040b7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040ba:	e8 81 ff ff ff       	call   80104040 <mycpu>
}
801040bf:	c9                   	leave  
  return mycpu()-cpus;
801040c0:	2d c0 67 18 80       	sub    $0x801867c0,%eax
801040c5:	c1 f8 04             	sar    $0x4,%eax
801040c8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040ce:	c3                   	ret    
801040cf:	90                   	nop

801040d0 <myproc>:
myproc(void) {
801040d0:	f3 0f 1e fb          	endbr32 
801040d4:	55                   	push   %ebp
801040d5:	89 e5                	mov    %esp,%ebp
801040d7:	53                   	push   %ebx
801040d8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801040db:	e8 d0 0c 00 00       	call   80104db0 <pushcli>
  c = mycpu();
801040e0:	e8 5b ff ff ff       	call   80104040 <mycpu>
  p = c->proc;
801040e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040eb:	e8 10 0d 00 00       	call   80104e00 <popcli>
}
801040f0:	83 c4 04             	add    $0x4,%esp
801040f3:	89 d8                	mov    %ebx,%eax
801040f5:	5b                   	pop    %ebx
801040f6:	5d                   	pop    %ebp
801040f7:	c3                   	ret    
801040f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop

80104100 <userinit>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010410b:	e8 10 fd ff ff       	call   80103e20 <allocproc>
80104110:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104112:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  if((p->pgdir = setupkvm()) == 0)
80104117:	e8 04 3a 00 00       	call   80107b20 <setupkvm>
8010411c:	89 43 04             	mov    %eax,0x4(%ebx)
8010411f:	85 c0                	test   %eax,%eax
80104121:	0f 84 bd 00 00 00    	je     801041e4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104127:	83 ec 04             	sub    $0x4,%esp
8010412a:	68 2c 00 00 00       	push   $0x2c
8010412f:	68 60 c4 10 80       	push   $0x8010c460
80104134:	50                   	push   %eax
80104135:	e8 36 33 00 00       	call   80107470 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010413a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010413d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104143:	6a 4c                	push   $0x4c
80104145:	6a 00                	push   $0x0
80104147:	ff 73 18             	pushl  0x18(%ebx)
8010414a:	e8 71 0e 00 00       	call   80104fc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010414f:	8b 43 18             	mov    0x18(%ebx),%eax
80104152:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104157:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010415a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010415f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104163:	8b 43 18             	mov    0x18(%ebx),%eax
80104166:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010416a:	8b 43 18             	mov    0x18(%ebx),%eax
8010416d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104171:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104175:	8b 43 18             	mov    0x18(%ebx),%eax
80104178:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010417c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104180:	8b 43 18             	mov    0x18(%ebx),%eax
80104183:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010418a:	8b 43 18             	mov    0x18(%ebx),%eax
8010418d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104194:	8b 43 18             	mov    0x18(%ebx),%eax
80104197:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010419e:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041a1:	6a 10                	push   $0x10
801041a3:	68 66 89 10 80       	push   $0x80108966
801041a8:	50                   	push   %eax
801041a9:	e8 d2 0f 00 00       	call   80105180 <safestrcpy>
  p->cwd = namei("/");
801041ae:	c7 04 24 6f 89 10 80 	movl   $0x8010896f,(%esp)
801041b5:	e8 b6 de ff ff       	call   80102070 <namei>
801041ba:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041bd:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801041c4:	e8 e7 0c 00 00       	call   80104eb0 <acquire>
  p->state = RUNNABLE;
801041c9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801041d0:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801041d7:	e8 94 0d 00 00       	call   80104f70 <release>
}
801041dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	c9                   	leave  
801041e3:	c3                   	ret    
    panic("userinit: out of memory?");
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	68 4d 89 10 80       	push   $0x8010894d
801041ec:	e8 9f c1 ff ff       	call   80100390 <panic>
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ff:	90                   	nop

80104200 <growproc>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	57                   	push   %edi
80104208:	56                   	push   %esi
80104209:	53                   	push   %ebx
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104210:	e8 9b 0b 00 00       	call   80104db0 <pushcli>
  c = mycpu();
80104215:	e8 26 fe ff ff       	call   80104040 <mycpu>
  p = c->proc;
8010421a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104220:	e8 db 0b 00 00       	call   80104e00 <popcli>
  sz = curproc->sz;
80104225:	8b 1e                	mov    (%esi),%ebx
  if(n > 0){
80104227:	85 ff                	test   %edi,%edi
80104229:	7f 1d                	jg     80104248 <growproc+0x48>
  } else if(n < 0){
8010422b:	75 43                	jne    80104270 <growproc+0x70>
  switchuvm(curproc);
8010422d:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104230:	89 1e                	mov    %ebx,(%esi)
  switchuvm(curproc);
80104232:	56                   	push   %esi
80104233:	e8 28 31 00 00       	call   80107360 <switchuvm>
  return 0;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	31 c0                	xor    %eax,%eax
}
8010423d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104240:	5b                   	pop    %ebx
80104241:	5e                   	pop    %esi
80104242:	5f                   	pop    %edi
80104243:	5d                   	pop    %ebp
80104244:	c3                   	ret    
80104245:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104248:	83 ec 04             	sub    $0x4,%esp
8010424b:	01 df                	add    %ebx,%edi
8010424d:	57                   	push   %edi
8010424e:	53                   	push   %ebx
8010424f:	ff 76 04             	pushl  0x4(%esi)
80104252:	e8 49 35 00 00       	call   801077a0 <allocuvm>
80104257:	83 c4 10             	add    $0x10,%esp
8010425a:	89 c3                	mov    %eax,%ebx
8010425c:	85 c0                	test   %eax,%eax
8010425e:	75 cd                	jne    8010422d <growproc+0x2d>
      return -1;
80104260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104265:	eb d6                	jmp    8010423d <growproc+0x3d>
80104267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426e:	66 90                	xchg   %ax,%ax
    cprintf("growproc: n < 0\n");
80104270:	83 ec 0c             	sub    $0xc,%esp
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104273:	01 df                	add    %ebx,%edi
    cprintf("growproc: n < 0\n");
80104275:	68 71 89 10 80       	push   $0x80108971
8010427a:	e8 31 c4 ff ff       	call   801006b0 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010427f:	83 c4 0c             	add    $0xc,%esp
80104282:	57                   	push   %edi
80104283:	53                   	push   %ebx
80104284:	ff 76 04             	pushl  0x4(%esi)
80104287:	e8 44 33 00 00       	call   801075d0 <deallocuvm>
8010428c:	83 c4 10             	add    $0x10,%esp
8010428f:	89 c3                	mov    %eax,%ebx
80104291:	85 c0                	test   %eax,%eax
80104293:	75 98                	jne    8010422d <growproc+0x2d>
80104295:	eb c9                	jmp    80104260 <growproc+0x60>
80104297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <fork>:
{ 
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	57                   	push   %edi
801042a8:	56                   	push   %esi
801042a9:	53                   	push   %ebx
801042aa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042ad:	e8 fe 0a 00 00       	call   80104db0 <pushcli>
  c = mycpu();
801042b2:	e8 89 fd ff ff       	call   80104040 <mycpu>
  p = c->proc;
801042b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042bd:	e8 3e 0b 00 00       	call   80104e00 <popcli>
  if((np = allocproc()) == 0){
801042c2:	e8 59 fb ff ff       	call   80103e20 <allocproc>
801042c7:	85 c0                	test   %eax,%eax
801042c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042cc:	0f 84 a4 01 00 00    	je     80104476 <fork+0x1d6>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801042d2:	83 ec 08             	sub    $0x8,%esp
801042d5:	ff 33                	pushl  (%ebx)
801042d7:	ff 73 04             	pushl  0x4(%ebx)
801042da:	e8 21 3e 00 00       	call   80108100 <copyuvm>
801042df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pgdir == 0){
801042e2:	83 c4 10             	add    $0x10,%esp
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801042e5:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
801042e8:	85 c0                	test   %eax,%eax
801042ea:	0f 84 90 01 00 00    	je     80104480 <fork+0x1e0>
  np->sz = curproc->sz;
801042f0:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801042f2:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801042f5:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801042f8:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801042fd:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801042ff:	8b 73 18             	mov    0x18(%ebx),%esi
80104302:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
80104304:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104308:	0f 8f 9a 00 00 00    	jg     801043a8 <fork+0x108>
  np->tf->eax = 0;
8010430e:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80104311:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104313:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104320:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104324:	85 c0                	test   %eax,%eax
80104326:	74 16                	je     8010433e <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010432e:	50                   	push   %eax
8010432f:	e8 7c cb ff ff       	call   80100eb0 <filedup>
80104334:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010433e:	83 c6 01             	add    $0x1,%esi
80104341:	83 fe 10             	cmp    $0x10,%esi
80104344:	75 da                	jne    80104320 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010434c:	83 c3 6c             	add    $0x6c,%ebx
8010434f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->cwd = idup(curproc->cwd);
80104352:	e8 19 d4 ff ff       	call   80101770 <idup>
80104357:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010435a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010435d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104360:	8d 42 6c             	lea    0x6c(%edx),%eax
80104363:	6a 10                	push   $0x10
80104365:	53                   	push   %ebx
80104366:	50                   	push   %eax
80104367:	e8 14 0e 00 00       	call   80105180 <safestrcpy>
  pid = np->pid;
8010436c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010436f:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80104372:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104379:	e8 32 0b 00 00       	call   80104eb0 <acquire>
  np->state = RUNNABLE;
8010437e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104381:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104388:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
8010438f:	e8 dc 0b 00 00       	call   80104f70 <release>
  return pid;
80104394:	83 c4 10             	add    $0x10,%esp
}
80104397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010439a:	89 d8                	mov    %ebx,%eax
8010439c:	5b                   	pop    %ebx
8010439d:	5e                   	pop    %esi
8010439e:	5f                   	pop    %edi
8010439f:	5d                   	pop    %ebp
801043a0:	c3                   	ret    
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
801043a8:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
801043ae:	85 c0                	test   %eax,%eax
801043b0:	74 1f                	je     801043d1 <fork+0x131>
        np->ramPages[i].isused = 1;
801043b2:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
801043b9:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
801043bc:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
801043c2:	89 82 90 01 00 00    	mov    %eax,0x190(%edx)
        np->ramPages[i].pgdir = np->pgdir;
801043c8:	8b 42 04             	mov    0x4(%edx),%eax
801043cb:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
{ 
801043d1:	31 f6                	xor    %esi,%esi
801043d3:	eb 12                	jmp    801043e7 <fork+0x147>
801043d5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801043d8:	83 c6 10             	add    $0x10,%esi
801043db:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801043e1:	0f 84 27 ff ff ff    	je     8010430e <fork+0x6e>
      if(curproc->swappedPages[i].isused)
801043e7:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
801043ee:	85 c9                	test   %ecx,%ecx
801043f0:	74 e6                	je     801043d8 <fork+0x138>
      np->swappedPages[i].isused = 1;
801043f2:	c7 84 32 8c 00 00 00 	movl   $0x1,0x8c(%edx,%esi,1)
801043f9:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801043fd:	8b 84 33 90 00 00 00 	mov    0x90(%ebx,%esi,1),%eax
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104404:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104407:	89 84 32 90 00 00 00 	mov    %eax,0x90(%edx,%esi,1)
      np->swappedPages[i].pgdir = np->pgdir;
8010440e:	8b 42 04             	mov    0x4(%edx),%eax
80104411:	89 84 32 88 00 00 00 	mov    %eax,0x88(%edx,%esi,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104418:	8b 84 33 94 00 00 00 	mov    0x94(%ebx,%esi,1),%eax
8010441f:	89 84 32 94 00 00 00 	mov    %eax,0x94(%edx,%esi,1)
      if(readFromSwapFile((void*)curproc, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104426:	68 00 10 00 00       	push   $0x1000
8010442b:	50                   	push   %eax
8010442c:	68 e0 c5 10 80       	push   $0x8010c5e0
80104431:	53                   	push   %ebx
80104432:	e8 c9 df ff ff       	call   80102400 <readFromSwapFile>
80104437:	83 c4 10             	add    $0x10,%esp
8010443a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010443d:	85 c0                	test   %eax,%eax
8010443f:	78 68                	js     801044a9 <fork+0x209>
      if(writeToSwapFile((void*)np, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104441:	68 00 10 00 00       	push   $0x1000
80104446:	ff b4 32 94 00 00 00 	pushl  0x94(%edx,%esi,1)
8010444d:	68 e0 c5 10 80       	push   $0x8010c5e0
80104452:	52                   	push   %edx
80104453:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104456:	e8 75 df ff ff       	call   801023d0 <writeToSwapFile>
8010445b:	83 c4 10             	add    $0x10,%esp
8010445e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104461:	85 c0                	test   %eax,%eax
80104463:	0f 89 6f ff ff ff    	jns    801043d8 <fork+0x138>
        panic("fork: writeToSwapFile");
80104469:	83 ec 0c             	sub    $0xc,%esp
8010446c:	68 99 89 10 80       	push   $0x80108999
80104471:	e8 1a bf ff ff       	call   80100390 <panic>
    return -1;
80104476:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010447b:	e9 17 ff ff ff       	jmp    80104397 <fork+0xf7>
    kfree(np->kstack);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80104486:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010448b:	e8 a0 e3 ff ff       	call   80102830 <kfree>
    np->kstack = 0;
80104490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104493:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104496:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010449d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
801044a4:	e9 ee fe ff ff       	jmp    80104397 <fork+0xf7>
        panic("fork: readFromSwapFile");
801044a9:	83 ec 0c             	sub    $0xc,%esp
801044ac:	68 82 89 10 80       	push   $0x80108982
801044b1:	e8 da be ff ff       	call   80100390 <panic>
801044b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <scheduler>:
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	57                   	push   %edi
801044c8:	56                   	push   %esi
801044c9:	53                   	push   %ebx
801044ca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801044cd:	e8 6e fb ff ff       	call   80104040 <mycpu>
  c->proc = 0;
801044d2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044d9:	00 00 00 
  struct cpu *c = mycpu();
801044dc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801044de:	8d 78 04             	lea    0x4(%eax),%edi
801044e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801044e8:	fb                   	sti    
    acquire(&ptable.lock);
801044e9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ec:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
    acquire(&ptable.lock);
801044f1:	68 60 6d 18 80       	push   $0x80186d60
801044f6:	e8 b5 09 00 00       	call   80104eb0 <acquire>
801044fb:	83 c4 10             	add    $0x10,%esp
801044fe:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104500:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104504:	75 33                	jne    80104539 <scheduler+0x79>
      switchuvm(p);
80104506:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104509:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010450f:	53                   	push   %ebx
80104510:	e8 4b 2e 00 00       	call   80107360 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104515:	58                   	pop    %eax
80104516:	5a                   	pop    %edx
80104517:	ff 73 1c             	pushl  0x1c(%ebx)
8010451a:	57                   	push   %edi
      p->state = RUNNING;
8010451b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104522:	e8 bc 0c 00 00       	call   801051e3 <swtch>
      switchkvm();
80104527:	e8 14 2e 00 00       	call   80107340 <switchkvm>
      c->proc = 0;
8010452c:	83 c4 10             	add    $0x10,%esp
8010452f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104536:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104539:	81 c3 98 02 00 00    	add    $0x298,%ebx
8010453f:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104545:	75 b9                	jne    80104500 <scheduler+0x40>
    release(&ptable.lock);
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 60 6d 18 80       	push   $0x80186d60
8010454f:	e8 1c 0a 00 00       	call   80104f70 <release>
    sti();
80104554:	83 c4 10             	add    $0x10,%esp
80104557:	eb 8f                	jmp    801044e8 <scheduler+0x28>
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <sched>:
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	56                   	push   %esi
80104568:	53                   	push   %ebx
  pushcli();
80104569:	e8 42 08 00 00       	call   80104db0 <pushcli>
  c = mycpu();
8010456e:	e8 cd fa ff ff       	call   80104040 <mycpu>
  p = c->proc;
80104573:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104579:	e8 82 08 00 00       	call   80104e00 <popcli>
  if(!holding(&ptable.lock))
8010457e:	83 ec 0c             	sub    $0xc,%esp
80104581:	68 60 6d 18 80       	push   $0x80186d60
80104586:	e8 d5 08 00 00       	call   80104e60 <holding>
8010458b:	83 c4 10             	add    $0x10,%esp
8010458e:	85 c0                	test   %eax,%eax
80104590:	74 4f                	je     801045e1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104592:	e8 a9 fa ff ff       	call   80104040 <mycpu>
80104597:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010459e:	75 68                	jne    80104608 <sched+0xa8>
  if(p->state == RUNNING)
801045a0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801045a4:	74 55                	je     801045fb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045a6:	9c                   	pushf  
801045a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045a8:	f6 c4 02             	test   $0x2,%ah
801045ab:	75 41                	jne    801045ee <sched+0x8e>
  intena = mycpu()->intena;
801045ad:	e8 8e fa ff ff       	call   80104040 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801045b2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801045b5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801045bb:	e8 80 fa ff ff       	call   80104040 <mycpu>
801045c0:	83 ec 08             	sub    $0x8,%esp
801045c3:	ff 70 04             	pushl  0x4(%eax)
801045c6:	53                   	push   %ebx
801045c7:	e8 17 0c 00 00       	call   801051e3 <swtch>
  mycpu()->intena = intena;
801045cc:	e8 6f fa ff ff       	call   80104040 <mycpu>
}
801045d1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801045d4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801045da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045dd:	5b                   	pop    %ebx
801045de:	5e                   	pop    %esi
801045df:	5d                   	pop    %ebp
801045e0:	c3                   	ret    
    panic("sched ptable.lock");
801045e1:	83 ec 0c             	sub    $0xc,%esp
801045e4:	68 af 89 10 80       	push   $0x801089af
801045e9:	e8 a2 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801045ee:	83 ec 0c             	sub    $0xc,%esp
801045f1:	68 db 89 10 80       	push   $0x801089db
801045f6:	e8 95 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045fb:	83 ec 0c             	sub    $0xc,%esp
801045fe:	68 cd 89 10 80       	push   $0x801089cd
80104603:	e8 88 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	68 c1 89 10 80       	push   $0x801089c1
80104610:	e8 7b bd ff ff       	call   80100390 <panic>
80104615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <exit>:
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	57                   	push   %edi
80104628:	56                   	push   %esi
80104629:	53                   	push   %ebx
8010462a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010462d:	e8 7e 07 00 00       	call   80104db0 <pushcli>
  c = mycpu();
80104632:	e8 09 fa ff ff       	call   80104040 <mycpu>
  p = c->proc;
80104637:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010463d:	e8 be 07 00 00       	call   80104e00 <popcli>
  if(curproc == initproc)
80104642:	8d 5e 28             	lea    0x28(%esi),%ebx
80104645:	8d 7e 68             	lea    0x68(%esi),%edi
80104648:	39 35 c0 c5 10 80    	cmp    %esi,0x8010c5c0
8010464e:	0f 84 2e 01 00 00    	je     80104782 <exit+0x162>
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104658:	8b 03                	mov    (%ebx),%eax
8010465a:	85 c0                	test   %eax,%eax
8010465c:	74 12                	je     80104670 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010465e:	83 ec 0c             	sub    $0xc,%esp
80104661:	50                   	push   %eax
80104662:	e8 99 c8 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80104667:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010466d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104670:	83 c3 04             	add    $0x4,%ebx
80104673:	39 df                	cmp    %ebx,%edi
80104675:	75 e1                	jne    80104658 <exit+0x38>
  begin_op();
80104677:	e8 04 ed ff ff       	call   80103380 <begin_op>
  iput(curproc->cwd);
8010467c:	83 ec 0c             	sub    $0xc,%esp
8010467f:	ff 76 68             	pushl  0x68(%esi)
80104682:	e8 49 d2 ff ff       	call   801018d0 <iput>
  end_op();
80104687:	e8 a4 ed ff ff       	call   80103430 <end_op>
  if(curproc->pid > 2) {
8010468c:	83 c4 10             	add    $0x10,%esp
8010468f:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
  curproc->cwd = 0;
80104693:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  if(curproc->pid > 2) {
8010469a:	0f 8f c1 00 00 00    	jg     80104761 <exit+0x141>
  acquire(&ptable.lock);
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	68 60 6d 18 80       	push   $0x80186d60
801046a8:	e8 03 08 00 00       	call   80104eb0 <acquire>
  wakeup1(curproc->parent);
801046ad:	8b 56 14             	mov    0x14(%esi),%edx
801046b0:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046b3:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
801046b8:	eb 12                	jmp    801046cc <exit+0xac>
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c0:	05 98 02 00 00       	add    $0x298,%eax
801046c5:	3d 94 13 19 80       	cmp    $0x80191394,%eax
801046ca:	74 1e                	je     801046ea <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
801046cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046d0:	75 ee                	jne    801046c0 <exit+0xa0>
801046d2:	3b 50 20             	cmp    0x20(%eax),%edx
801046d5:	75 e9                	jne    801046c0 <exit+0xa0>
      p->state = RUNNABLE;
801046d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046de:	05 98 02 00 00       	add    $0x298,%eax
801046e3:	3d 94 13 19 80       	cmp    $0x80191394,%eax
801046e8:	75 e2                	jne    801046cc <exit+0xac>
      p->parent = initproc;
801046ea:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f0:	ba 94 6d 18 80       	mov    $0x80186d94,%edx
801046f5:	eb 17                	jmp    8010470e <exit+0xee>
801046f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fe:	66 90                	xchg   %ax,%ax
80104700:	81 c2 98 02 00 00    	add    $0x298,%edx
80104706:	81 fa 94 13 19 80    	cmp    $0x80191394,%edx
8010470c:	74 3a                	je     80104748 <exit+0x128>
    if(p->parent == curproc){
8010470e:	39 72 14             	cmp    %esi,0x14(%edx)
80104711:	75 ed                	jne    80104700 <exit+0xe0>
      if(p->state == ZOMBIE)
80104713:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104717:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010471a:	75 e4                	jne    80104700 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010471c:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104721:	eb 11                	jmp    80104734 <exit+0x114>
80104723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104727:	90                   	nop
80104728:	05 98 02 00 00       	add    $0x298,%eax
8010472d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104732:	74 cc                	je     80104700 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104734:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104738:	75 ee                	jne    80104728 <exit+0x108>
8010473a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010473d:	75 e9                	jne    80104728 <exit+0x108>
      p->state = RUNNABLE;
8010473f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104746:	eb e0                	jmp    80104728 <exit+0x108>
  curproc->state = ZOMBIE;
80104748:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010474f:	e8 0c fe ff ff       	call   80104560 <sched>
  panic("zombie exit");
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	68 fc 89 10 80       	push   $0x801089fc
8010475c:	e8 2f bc ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104761:	83 ec 0c             	sub    $0xc,%esp
80104764:	56                   	push   %esi
80104765:	e8 d6 d9 ff ff       	call   80102140 <removeSwapFile>
8010476a:	83 c4 10             	add    $0x10,%esp
8010476d:	85 c0                	test   %eax,%eax
8010476f:	0f 84 2b ff ff ff    	je     801046a0 <exit+0x80>
      panic("exit: error deleting swap file");
80104775:	83 ec 0c             	sub    $0xc,%esp
80104778:	68 80 8a 10 80       	push   $0x80108a80
8010477d:	e8 0e bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104782:	83 ec 0c             	sub    $0xc,%esp
80104785:	68 ef 89 10 80       	push   $0x801089ef
8010478a:	e8 01 bc ff ff       	call   80100390 <panic>
8010478f:	90                   	nop

80104790 <yield>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	53                   	push   %ebx
80104798:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010479b:	68 60 6d 18 80       	push   $0x80186d60
801047a0:	e8 0b 07 00 00       	call   80104eb0 <acquire>
  pushcli();
801047a5:	e8 06 06 00 00       	call   80104db0 <pushcli>
  c = mycpu();
801047aa:	e8 91 f8 ff ff       	call   80104040 <mycpu>
  p = c->proc;
801047af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047b5:	e8 46 06 00 00       	call   80104e00 <popcli>
  myproc()->state = RUNNABLE;
801047ba:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801047c1:	e8 9a fd ff ff       	call   80104560 <sched>
  release(&ptable.lock);
801047c6:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801047cd:	e8 9e 07 00 00       	call   80104f70 <release>
}
801047d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d5:	83 c4 10             	add    $0x10,%esp
801047d8:	c9                   	leave  
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <sleep>:
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	56                   	push   %esi
801047e9:	53                   	push   %ebx
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801047f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047f3:	e8 b8 05 00 00       	call   80104db0 <pushcli>
  c = mycpu();
801047f8:	e8 43 f8 ff ff       	call   80104040 <mycpu>
  p = c->proc;
801047fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104803:	e8 f8 05 00 00       	call   80104e00 <popcli>
  if(p == 0)
80104808:	85 db                	test   %ebx,%ebx
8010480a:	0f 84 83 00 00 00    	je     80104893 <sleep+0xb3>
  if(lk == 0)
80104810:	85 f6                	test   %esi,%esi
80104812:	74 72                	je     80104886 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104814:	81 fe 60 6d 18 80    	cmp    $0x80186d60,%esi
8010481a:	74 4c                	je     80104868 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 60 6d 18 80       	push   $0x80186d60
80104824:	e8 87 06 00 00       	call   80104eb0 <acquire>
    release(lk);
80104829:	89 34 24             	mov    %esi,(%esp)
8010482c:	e8 3f 07 00 00       	call   80104f70 <release>
  p->chan = chan;
80104831:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104834:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010483b:	e8 20 fd ff ff       	call   80104560 <sched>
  p->chan = 0;
80104840:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104847:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
8010484e:	e8 1d 07 00 00       	call   80104f70 <release>
    acquire(lk);
80104853:	89 75 08             	mov    %esi,0x8(%ebp)
80104856:	83 c4 10             	add    $0x10,%esp
}
80104859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5f                   	pop    %edi
8010485f:	5d                   	pop    %ebp
    acquire(lk);
80104860:	e9 4b 06 00 00       	jmp    80104eb0 <acquire>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104868:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010486b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104872:	e8 e9 fc ff ff       	call   80104560 <sched>
  p->chan = 0;
80104877:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010487e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104881:	5b                   	pop    %ebx
80104882:	5e                   	pop    %esi
80104883:	5f                   	pop    %edi
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret    
    panic("sleep without lk");
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	68 0e 8a 10 80       	push   $0x80108a0e
8010488e:	e8 fd ba ff ff       	call   80100390 <panic>
    panic("sleep");
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	68 08 8a 10 80       	push   $0x80108a08
8010489b:	e8 f0 ba ff ff       	call   80100390 <panic>

801048a0 <wait>:
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
  pushcli();
801048a9:	e8 02 05 00 00       	call   80104db0 <pushcli>
  c = mycpu();
801048ae:	e8 8d f7 ff ff       	call   80104040 <mycpu>
  p = c->proc;
801048b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048b9:	e8 42 05 00 00       	call   80104e00 <popcli>
  acquire(&ptable.lock);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	68 60 6d 18 80       	push   $0x80186d60
801048c6:	e8 e5 05 00 00       	call   80104eb0 <acquire>
801048cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801048ce:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d0:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
801048d5:	eb 17                	jmp    801048ee <wait+0x4e>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax
801048e0:	81 c3 98 02 00 00    	add    $0x298,%ebx
801048e6:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
801048ec:	74 1e                	je     8010490c <wait+0x6c>
      if(p->parent != curproc)
801048ee:	39 73 14             	cmp    %esi,0x14(%ebx)
801048f1:	75 ed                	jne    801048e0 <wait+0x40>
      if(p->state == ZOMBIE){
801048f3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048f7:	74 3f                	je     80104938 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f9:	81 c3 98 02 00 00    	add    $0x298,%ebx
      havekids = 1;
801048ff:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104904:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
8010490a:	75 e2                	jne    801048ee <wait+0x4e>
    if(!havekids || curproc->killed){
8010490c:	85 c0                	test   %eax,%eax
8010490e:	0f 84 a6 00 00 00    	je     801049ba <wait+0x11a>
80104914:	8b 46 24             	mov    0x24(%esi),%eax
80104917:	85 c0                	test   %eax,%eax
80104919:	0f 85 9b 00 00 00    	jne    801049ba <wait+0x11a>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010491f:	83 ec 08             	sub    $0x8,%esp
80104922:	68 60 6d 18 80       	push   $0x80186d60
80104927:	56                   	push   %esi
80104928:	e8 b3 fe ff ff       	call   801047e0 <sleep>
    havekids = 0;
8010492d:	83 c4 10             	add    $0x10,%esp
80104930:	eb 9c                	jmp    801048ce <wait+0x2e>
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104938:	83 ec 0c             	sub    $0xc,%esp
8010493b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010493e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104941:	e8 ea de ff ff       	call   80102830 <kfree>
        freevm(p->pgdir); // panic: kfree
80104946:	5a                   	pop    %edx
80104947:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010494a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104951:	e8 4a 31 00 00       	call   80107aa0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104956:	83 c4 0c             	add    $0xc,%esp
        p->name[0] = 0;
80104959:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
8010495d:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80104963:	68 00 01 00 00       	push   $0x100
80104968:	6a 00                	push   $0x0
8010496a:	50                   	push   %eax
        p->pid = 0;
8010496b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104972:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104979:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104980:	e8 3b 06 00 00       	call   80104fc0 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104985:	83 c4 0c             	add    $0xc,%esp
80104988:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
8010498e:	68 00 01 00 00       	push   $0x100
80104993:	6a 00                	push   $0x0
80104995:	50                   	push   %eax
80104996:	e8 25 06 00 00       	call   80104fc0 <memset>
        release(&ptable.lock);
8010499b:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
        p->state = UNUSED;
801049a2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801049a9:	e8 c2 05 00 00       	call   80104f70 <release>
        return pid;
801049ae:	83 c4 10             	add    $0x10,%esp
}
801049b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b4:	89 f0                	mov    %esi,%eax
801049b6:	5b                   	pop    %ebx
801049b7:	5e                   	pop    %esi
801049b8:	5d                   	pop    %ebp
801049b9:	c3                   	ret    
      release(&ptable.lock);
801049ba:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801049bd:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801049c2:	68 60 6d 18 80       	push   $0x80186d60
801049c7:	e8 a4 05 00 00       	call   80104f70 <release>
      return -1;
801049cc:	83 c4 10             	add    $0x10,%esp
801049cf:	eb e0                	jmp    801049b1 <wait+0x111>
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049df:	90                   	nop

801049e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	53                   	push   %ebx
801049e8:	83 ec 10             	sub    $0x10,%esp
801049eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ee:	68 60 6d 18 80       	push   $0x80186d60
801049f3:	e8 b8 04 00 00       	call   80104eb0 <acquire>
801049f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049fb:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104a00:	eb 12                	jmp    80104a14 <wakeup+0x34>
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a08:	05 98 02 00 00       	add    $0x298,%eax
80104a0d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104a12:	74 1e                	je     80104a32 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104a14:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a18:	75 ee                	jne    80104a08 <wakeup+0x28>
80104a1a:	3b 58 20             	cmp    0x20(%eax),%ebx
80104a1d:	75 e9                	jne    80104a08 <wakeup+0x28>
      p->state = RUNNABLE;
80104a1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a26:	05 98 02 00 00       	add    $0x298,%eax
80104a2b:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104a30:	75 e2                	jne    80104a14 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104a32:	c7 45 08 60 6d 18 80 	movl   $0x80186d60,0x8(%ebp)
}
80104a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a3c:	c9                   	leave  
  release(&ptable.lock);
80104a3d:	e9 2e 05 00 00       	jmp    80104f70 <release>
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	53                   	push   %ebx
80104a58:	83 ec 10             	sub    $0x10,%esp
80104a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a5e:	68 60 6d 18 80       	push   $0x80186d60
80104a63:	e8 48 04 00 00       	call   80104eb0 <acquire>
80104a68:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a6b:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104a70:	eb 12                	jmp    80104a84 <kill+0x34>
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a78:	05 98 02 00 00       	add    $0x298,%eax
80104a7d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104a82:	74 34                	je     80104ab8 <kill+0x68>
    if(p->pid == pid){
80104a84:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a87:	75 ef                	jne    80104a78 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a89:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a8d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a94:	75 07                	jne    80104a9d <kill+0x4d>
        p->state = RUNNABLE;
80104a96:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a9d:	83 ec 0c             	sub    $0xc,%esp
80104aa0:	68 60 6d 18 80       	push   $0x80186d60
80104aa5:	e8 c6 04 00 00       	call   80104f70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	31 c0                	xor    %eax,%eax
}
80104ab2:	c9                   	leave  
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	68 60 6d 18 80       	push   $0x80186d60
80104ac0:	e8 ab 04 00 00       	call   80104f70 <release>
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104ac8:	83 c4 10             	add    $0x10,%esp
80104acb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ad0:	c9                   	leave  
80104ad1:	c3                   	ret    
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	57                   	push   %edi
80104ae8:	56                   	push   %esi
80104ae9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104aec:	53                   	push   %ebx
80104aed:	bb 00 6e 18 80       	mov    $0x80186e00,%ebx
80104af2:	83 ec 3c             	sub    $0x3c,%esp
80104af5:	eb 2b                	jmp    80104b22 <procdump+0x42>
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	68 fa 8d 10 80       	push   $0x80108dfa
80104b08:	e8 a3 bb ff ff       	call   801006b0 <cprintf>
80104b0d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b10:	81 c3 98 02 00 00    	add    $0x298,%ebx
80104b16:	81 fb 00 14 19 80    	cmp    $0x80191400,%ebx
80104b1c:	0f 84 8e 00 00 00    	je     80104bb0 <procdump+0xd0>
    if(p->state == UNUSED)
80104b22:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104b25:	85 c0                	test   %eax,%eax
80104b27:	74 e7                	je     80104b10 <procdump+0x30>
      state = "???";
80104b29:	ba 1f 8a 10 80       	mov    $0x80108a1f,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b2e:	83 f8 05             	cmp    $0x5,%eax
80104b31:	77 11                	ja     80104b44 <procdump+0x64>
80104b33:	8b 14 85 a0 8a 10 80 	mov    -0x7fef7560(,%eax,4),%edx
      state = "???";
80104b3a:	b8 1f 8a 10 80       	mov    $0x80108a1f,%eax
80104b3f:	85 d2                	test   %edx,%edx
80104b41:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b44:	53                   	push   %ebx
80104b45:	52                   	push   %edx
80104b46:	ff 73 a4             	pushl  -0x5c(%ebx)
80104b49:	68 23 8a 10 80       	push   $0x80108a23
80104b4e:	e8 5d bb ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104b53:	83 c4 10             	add    $0x10,%esp
80104b56:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104b5a:	75 a4                	jne    80104b00 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b5c:	83 ec 08             	sub    $0x8,%esp
80104b5f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b62:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b65:	50                   	push   %eax
80104b66:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104b69:	8b 40 0c             	mov    0xc(%eax),%eax
80104b6c:	83 c0 08             	add    $0x8,%eax
80104b6f:	50                   	push   %eax
80104b70:	e8 db 01 00 00       	call   80104d50 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b75:	83 c4 10             	add    $0x10,%esp
80104b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop
80104b80:	8b 17                	mov    (%edi),%edx
80104b82:	85 d2                	test   %edx,%edx
80104b84:	0f 84 76 ff ff ff    	je     80104b00 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104b8a:	83 ec 08             	sub    $0x8,%esp
80104b8d:	83 c7 04             	add    $0x4,%edi
80104b90:	52                   	push   %edx
80104b91:	68 a1 83 10 80       	push   $0x801083a1
80104b96:	e8 15 bb ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	39 fe                	cmp    %edi,%esi
80104ba0:	75 de                	jne    80104b80 <procdump+0xa0>
80104ba2:	e9 59 ff ff ff       	jmp    80104b00 <procdump+0x20>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax
  }
}
80104bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb3:	5b                   	pop    %ebx
80104bb4:	5e                   	pop    %esi
80104bb5:	5f                   	pop    %edi
80104bb6:	5d                   	pop    %ebp
80104bb7:	c3                   	ret    
80104bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop

80104bc0 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104bca:	68 60 6d 18 80       	push   $0x80186d60
80104bcf:	e8 dc 02 00 00       	call   80104eb0 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104bd4:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104bdb:	e8 90 03 00 00       	call   80104f70 <release>
  return sum;
80104be0:	31 c0                	xor    %eax,%eax
80104be2:	c9                   	leave  
80104be3:	c3                   	ret    
80104be4:	66 90                	xchg   %ax,%ax
80104be6:	66 90                	xchg   %ax,%ax
80104be8:	66 90                	xchg   %ax,%ax
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	53                   	push   %ebx
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bfe:	68 b8 8a 10 80       	push   $0x80108ab8
80104c03:	8d 43 04             	lea    0x4(%ebx),%eax
80104c06:	50                   	push   %eax
80104c07:	e8 24 01 00 00       	call   80104d30 <initlock>
  lk->name = name;
80104c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c15:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c18:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c1f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
80104c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c3c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	56                   	push   %esi
80104c43:	e8 68 02 00 00       	call   80104eb0 <acquire>
  while (lk->locked) {
80104c48:	8b 13                	mov    (%ebx),%edx
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	85 d2                	test   %edx,%edx
80104c4f:	74 1a                	je     80104c6b <acquiresleep+0x3b>
80104c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104c58:	83 ec 08             	sub    $0x8,%esp
80104c5b:	56                   	push   %esi
80104c5c:	53                   	push   %ebx
80104c5d:	e8 7e fb ff ff       	call   801047e0 <sleep>
  while (lk->locked) {
80104c62:	8b 03                	mov    (%ebx),%eax
80104c64:	83 c4 10             	add    $0x10,%esp
80104c67:	85 c0                	test   %eax,%eax
80104c69:	75 ed                	jne    80104c58 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104c6b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c71:	e8 5a f4 ff ff       	call   801040d0 <myproc>
80104c76:	8b 40 10             	mov    0x10(%eax),%eax
80104c79:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c7c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c82:	5b                   	pop    %ebx
80104c83:	5e                   	pop    %esi
80104c84:	5d                   	pop    %ebp
  release(&lk->lk);
80104c85:	e9 e6 02 00 00       	jmp    80104f70 <release>
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	56                   	push   %esi
80104c98:	53                   	push   %ebx
80104c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c9c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c9f:	83 ec 0c             	sub    $0xc,%esp
80104ca2:	56                   	push   %esi
80104ca3:	e8 08 02 00 00       	call   80104eb0 <acquire>
  lk->locked = 0;
80104ca8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104cb5:	89 1c 24             	mov    %ebx,(%esp)
80104cb8:	e8 23 fd ff ff       	call   801049e0 <wakeup>
  release(&lk->lk);
80104cbd:	89 75 08             	mov    %esi,0x8(%ebp)
80104cc0:	83 c4 10             	add    $0x10,%esp
}
80104cc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc6:	5b                   	pop    %ebx
80104cc7:	5e                   	pop    %esi
80104cc8:	5d                   	pop    %ebp
  release(&lk->lk);
80104cc9:	e9 a2 02 00 00       	jmp    80104f70 <release>
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	57                   	push   %edi
80104cd8:	31 ff                	xor    %edi,%edi
80104cda:	56                   	push   %esi
80104cdb:	53                   	push   %ebx
80104cdc:	83 ec 18             	sub    $0x18,%esp
80104cdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ce2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ce5:	56                   	push   %esi
80104ce6:	e8 c5 01 00 00       	call   80104eb0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ceb:	8b 03                	mov    (%ebx),%eax
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	75 1c                	jne    80104d10 <holdingsleep+0x40>
  release(&lk->lk);
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	56                   	push   %esi
80104cf8:	e8 73 02 00 00       	call   80104f70 <release>
  return r;
}
80104cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d00:	89 f8                	mov    %edi,%eax
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5f                   	pop    %edi
80104d05:	5d                   	pop    %ebp
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104d10:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d13:	e8 b8 f3 ff ff       	call   801040d0 <myproc>
80104d18:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d1b:	0f 94 c0             	sete   %al
80104d1e:	0f b6 c0             	movzbl %al,%eax
80104d21:	89 c7                	mov    %eax,%edi
80104d23:	eb cf                	jmp    80104cf4 <holdingsleep+0x24>
80104d25:	66 90                	xchg   %ax,%ax
80104d27:	66 90                	xchg   %ax,%ax
80104d29:	66 90                	xchg   %ax,%ax
80104d2b:	66 90                	xchg   %ax,%ax
80104d2d:	66 90                	xchg   %ax,%ax
80104d2f:	90                   	nop

80104d30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d43:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d4d:	5d                   	pop    %ebp
80104d4e:	c3                   	ret    
80104d4f:	90                   	nop

80104d50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d55:	31 d2                	xor    %edx,%edx
{
80104d57:	89 e5                	mov    %esp,%ebp
80104d59:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d5a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d60:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d67:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d74:	77 1a                	ja     80104d90 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d76:	8b 58 04             	mov    0x4(%eax),%ebx
80104d79:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d7c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d81:	83 fa 0a             	cmp    $0xa,%edx
80104d84:	75 e2                	jne    80104d68 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d86:	5b                   	pop    %ebx
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d90:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d93:	8d 51 28             	lea    0x28(%ecx),%edx
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104da6:	83 c0 04             	add    $0x4,%eax
80104da9:	39 d0                	cmp    %edx,%eax
80104dab:	75 f3                	jne    80104da0 <getcallerpcs+0x50>
}
80104dad:	5b                   	pop    %ebx
80104dae:	5d                   	pop    %ebp
80104daf:	c3                   	ret    

80104db0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	53                   	push   %ebx
80104db8:	83 ec 04             	sub    $0x4,%esp
80104dbb:	9c                   	pushf  
80104dbc:	5b                   	pop    %ebx
  asm volatile("cli");
80104dbd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dbe:	e8 7d f2 ff ff       	call   80104040 <mycpu>
80104dc3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	74 13                	je     80104de0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104dcd:	e8 6e f2 ff ff       	call   80104040 <mycpu>
80104dd2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104dd9:	83 c4 04             	add    $0x4,%esp
80104ddc:	5b                   	pop    %ebx
80104ddd:	5d                   	pop    %ebp
80104dde:	c3                   	ret    
80104ddf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104de0:	e8 5b f2 ff ff       	call   80104040 <mycpu>
80104de5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104deb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104df1:	eb da                	jmp    80104dcd <pushcli+0x1d>
80104df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e00 <popcli>:

void
popcli(void)
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e0a:	9c                   	pushf  
80104e0b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e0c:	f6 c4 02             	test   $0x2,%ah
80104e0f:	75 31                	jne    80104e42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e11:	e8 2a f2 ff ff       	call   80104040 <mycpu>
80104e16:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e1d:	78 30                	js     80104e4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e1f:	e8 1c f2 ff ff       	call   80104040 <mycpu>
80104e24:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e2a:	85 d2                	test   %edx,%edx
80104e2c:	74 02                	je     80104e30 <popcli+0x30>
    sti();
}
80104e2e:	c9                   	leave  
80104e2f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e30:	e8 0b f2 ff ff       	call   80104040 <mycpu>
80104e35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e3b:	85 c0                	test   %eax,%eax
80104e3d:	74 ef                	je     80104e2e <popcli+0x2e>
  asm volatile("sti");
80104e3f:	fb                   	sti    
}
80104e40:	c9                   	leave  
80104e41:	c3                   	ret    
    panic("popcli - interruptible");
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 c3 8a 10 80       	push   $0x80108ac3
80104e4a:	e8 41 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e4f:	83 ec 0c             	sub    $0xc,%esp
80104e52:	68 da 8a 10 80       	push   $0x80108ada
80104e57:	e8 34 b5 ff ff       	call   80100390 <panic>
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e60 <holding>:
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	56                   	push   %esi
80104e68:	53                   	push   %ebx
80104e69:	8b 75 08             	mov    0x8(%ebp),%esi
80104e6c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e6e:	e8 3d ff ff ff       	call   80104db0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e73:	8b 06                	mov    (%esi),%eax
80104e75:	85 c0                	test   %eax,%eax
80104e77:	75 0f                	jne    80104e88 <holding+0x28>
  popcli();
80104e79:	e8 82 ff ff ff       	call   80104e00 <popcli>
}
80104e7e:	89 d8                	mov    %ebx,%eax
80104e80:	5b                   	pop    %ebx
80104e81:	5e                   	pop    %esi
80104e82:	5d                   	pop    %ebp
80104e83:	c3                   	ret    
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e88:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e8b:	e8 b0 f1 ff ff       	call   80104040 <mycpu>
80104e90:	39 c3                	cmp    %eax,%ebx
80104e92:	0f 94 c3             	sete   %bl
  popcli();
80104e95:	e8 66 ff ff ff       	call   80104e00 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e9a:	0f b6 db             	movzbl %bl,%ebx
}
80104e9d:	89 d8                	mov    %ebx,%eax
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104eb0 <acquire>:
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	56                   	push   %esi
80104eb8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104eb9:	e8 f2 fe ff ff       	call   80104db0 <pushcli>
  if(holding(lk))
80104ebe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	53                   	push   %ebx
80104ec5:	e8 96 ff ff ff       	call   80104e60 <holding>
80104eca:	83 c4 10             	add    $0x10,%esp
80104ecd:	85 c0                	test   %eax,%eax
80104ecf:	0f 85 7f 00 00 00    	jne    80104f54 <acquire+0xa4>
80104ed5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ed7:	ba 01 00 00 00       	mov    $0x1,%edx
80104edc:	eb 05                	jmp    80104ee3 <acquire+0x33>
80104ede:	66 90                	xchg   %ax,%ax
80104ee0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ee3:	89 d0                	mov    %edx,%eax
80104ee5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	75 f4                	jne    80104ee0 <acquire+0x30>
  __sync_synchronize();
80104eec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ef1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ef4:	e8 47 f1 ff ff       	call   80104040 <mycpu>
80104ef9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104efc:	89 e8                	mov    %ebp,%eax
80104efe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f00:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104f06:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104f0c:	77 22                	ja     80104f30 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f0e:	8b 50 04             	mov    0x4(%eax),%edx
80104f11:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104f15:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104f18:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f1a:	83 fe 0a             	cmp    $0xa,%esi
80104f1d:	75 e1                	jne    80104f00 <acquire+0x50>
}
80104f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f22:	5b                   	pop    %ebx
80104f23:	5e                   	pop    %esi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104f30:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104f34:	83 c3 34             	add    $0x34,%ebx
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f46:	83 c0 04             	add    $0x4,%eax
80104f49:	39 d8                	cmp    %ebx,%eax
80104f4b:	75 f3                	jne    80104f40 <acquire+0x90>
}
80104f4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f50:	5b                   	pop    %ebx
80104f51:	5e                   	pop    %esi
80104f52:	5d                   	pop    %ebp
80104f53:	c3                   	ret    
    panic("acquire");
80104f54:	83 ec 0c             	sub    $0xc,%esp
80104f57:	68 e1 8a 10 80       	push   $0x80108ae1
80104f5c:	e8 2f b4 ff ff       	call   80100390 <panic>
80104f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop

80104f70 <release>:
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	53                   	push   %ebx
80104f78:	83 ec 10             	sub    $0x10,%esp
80104f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f7e:	53                   	push   %ebx
80104f7f:	e8 dc fe ff ff       	call   80104e60 <holding>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	74 22                	je     80104fad <release+0x3d>
  lk->pcs[0] = 0;
80104f8b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f99:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f9e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fa7:	c9                   	leave  
  popcli();
80104fa8:	e9 53 fe ff ff       	jmp    80104e00 <popcli>
    panic("release");
80104fad:	83 ec 0c             	sub    $0xc,%esp
80104fb0:	68 e9 8a 10 80       	push   $0x80108ae9
80104fb5:	e8 d6 b3 ff ff       	call   80100390 <panic>
80104fba:	66 90                	xchg   %ax,%ax
80104fbc:	66 90                	xchg   %ax,%ax
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	57                   	push   %edi
80104fc8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fce:	53                   	push   %ebx
80104fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104fd2:	89 d7                	mov    %edx,%edi
80104fd4:	09 cf                	or     %ecx,%edi
80104fd6:	83 e7 03             	and    $0x3,%edi
80104fd9:	75 25                	jne    80105000 <memset+0x40>
    c &= 0xFF;
80104fdb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fde:	c1 e0 18             	shl    $0x18,%eax
80104fe1:	89 fb                	mov    %edi,%ebx
80104fe3:	c1 e9 02             	shr    $0x2,%ecx
80104fe6:	c1 e3 10             	shl    $0x10,%ebx
80104fe9:	09 d8                	or     %ebx,%eax
80104feb:	09 f8                	or     %edi,%eax
80104fed:	c1 e7 08             	shl    $0x8,%edi
80104ff0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ff2:	89 d7                	mov    %edx,%edi
80104ff4:	fc                   	cld    
80104ff5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ff7:	5b                   	pop    %ebx
80104ff8:	89 d0                	mov    %edx,%eax
80104ffa:	5f                   	pop    %edi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105000:	89 d7                	mov    %edx,%edi
80105002:	fc                   	cld    
80105003:	f3 aa                	rep stos %al,%es:(%edi)
80105005:	5b                   	pop    %ebx
80105006:	89 d0                	mov    %edx,%eax
80105008:	5f                   	pop    %edi
80105009:	5d                   	pop    %ebp
8010500a:	c3                   	ret    
8010500b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010500f:	90                   	nop

80105010 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	56                   	push   %esi
80105018:	8b 75 10             	mov    0x10(%ebp),%esi
8010501b:	8b 55 08             	mov    0x8(%ebp),%edx
8010501e:	53                   	push   %ebx
8010501f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105022:	85 f6                	test   %esi,%esi
80105024:	74 2a                	je     80105050 <memcmp+0x40>
80105026:	01 c6                	add    %eax,%esi
80105028:	eb 10                	jmp    8010503a <memcmp+0x2a>
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105030:	83 c0 01             	add    $0x1,%eax
80105033:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105036:	39 f0                	cmp    %esi,%eax
80105038:	74 16                	je     80105050 <memcmp+0x40>
    if(*s1 != *s2)
8010503a:	0f b6 0a             	movzbl (%edx),%ecx
8010503d:	0f b6 18             	movzbl (%eax),%ebx
80105040:	38 d9                	cmp    %bl,%cl
80105042:	74 ec                	je     80105030 <memcmp+0x20>
      return *s1 - *s2;
80105044:	0f b6 c1             	movzbl %cl,%eax
80105047:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105049:	5b                   	pop    %ebx
8010504a:	5e                   	pop    %esi
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
80105050:	5b                   	pop    %ebx
  return 0;
80105051:	31 c0                	xor    %eax,%eax
}
80105053:	5e                   	pop    %esi
80105054:	5d                   	pop    %ebp
80105055:	c3                   	ret    
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi

80105060 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	57                   	push   %edi
80105068:	8b 55 08             	mov    0x8(%ebp),%edx
8010506b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010506e:	56                   	push   %esi
8010506f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105072:	39 d6                	cmp    %edx,%esi
80105074:	73 2a                	jae    801050a0 <memmove+0x40>
80105076:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105079:	39 fa                	cmp    %edi,%edx
8010507b:	73 23                	jae    801050a0 <memmove+0x40>
8010507d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105080:	85 c9                	test   %ecx,%ecx
80105082:	74 13                	je     80105097 <memmove+0x37>
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105088:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010508c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010508f:	83 e8 01             	sub    $0x1,%eax
80105092:	83 f8 ff             	cmp    $0xffffffff,%eax
80105095:	75 f1                	jne    80105088 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105097:	5e                   	pop    %esi
80105098:	89 d0                	mov    %edx,%eax
8010509a:	5f                   	pop    %edi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801050a0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801050a3:	89 d7                	mov    %edx,%edi
801050a5:	85 c9                	test   %ecx,%ecx
801050a7:	74 ee                	je     80105097 <memmove+0x37>
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801050b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801050b1:	39 f0                	cmp    %esi,%eax
801050b3:	75 fb                	jne    801050b0 <memmove+0x50>
}
801050b5:	5e                   	pop    %esi
801050b6:	89 d0                	mov    %edx,%eax
801050b8:	5f                   	pop    %edi
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    
801050bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop

801050c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801050c0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801050c4:	eb 9a                	jmp    80105060 <memmove>
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
801050d5:	89 e5                	mov    %esp,%ebp
801050d7:	56                   	push   %esi
801050d8:	8b 75 10             	mov    0x10(%ebp),%esi
801050db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050de:	53                   	push   %ebx
801050df:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801050e2:	85 f6                	test   %esi,%esi
801050e4:	74 32                	je     80105118 <strncmp+0x48>
801050e6:	01 c6                	add    %eax,%esi
801050e8:	eb 14                	jmp    801050fe <strncmp+0x2e>
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050f0:	38 da                	cmp    %bl,%dl
801050f2:	75 14                	jne    80105108 <strncmp+0x38>
    n--, p++, q++;
801050f4:	83 c0 01             	add    $0x1,%eax
801050f7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050fa:	39 f0                	cmp    %esi,%eax
801050fc:	74 1a                	je     80105118 <strncmp+0x48>
801050fe:	0f b6 11             	movzbl (%ecx),%edx
80105101:	0f b6 18             	movzbl (%eax),%ebx
80105104:	84 d2                	test   %dl,%dl
80105106:	75 e8                	jne    801050f0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105108:	0f b6 c2             	movzbl %dl,%eax
8010510b:	29 d8                	sub    %ebx,%eax
}
8010510d:	5b                   	pop    %ebx
8010510e:	5e                   	pop    %esi
8010510f:	5d                   	pop    %ebp
80105110:	c3                   	ret    
80105111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105118:	5b                   	pop    %ebx
    return 0;
80105119:	31 c0                	xor    %eax,%eax
}
8010511b:	5e                   	pop    %esi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax

80105120 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	57                   	push   %edi
80105128:	56                   	push   %esi
80105129:	8b 75 08             	mov    0x8(%ebp),%esi
8010512c:	53                   	push   %ebx
8010512d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105130:	89 f2                	mov    %esi,%edx
80105132:	eb 1b                	jmp    8010514f <strncpy+0x2f>
80105134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105138:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010513c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010513f:	83 c2 01             	add    $0x1,%edx
80105142:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105146:	89 f9                	mov    %edi,%ecx
80105148:	88 4a ff             	mov    %cl,-0x1(%edx)
8010514b:	84 c9                	test   %cl,%cl
8010514d:	74 09                	je     80105158 <strncpy+0x38>
8010514f:	89 c3                	mov    %eax,%ebx
80105151:	83 e8 01             	sub    $0x1,%eax
80105154:	85 db                	test   %ebx,%ebx
80105156:	7f e0                	jg     80105138 <strncpy+0x18>
    ;
  while(n-- > 0)
80105158:	89 d1                	mov    %edx,%ecx
8010515a:	85 c0                	test   %eax,%eax
8010515c:	7e 15                	jle    80105173 <strncpy+0x53>
8010515e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105160:	83 c1 01             	add    $0x1,%ecx
80105163:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105167:	89 c8                	mov    %ecx,%eax
80105169:	f7 d0                	not    %eax
8010516b:	01 d0                	add    %edx,%eax
8010516d:	01 d8                	add    %ebx,%eax
8010516f:	85 c0                	test   %eax,%eax
80105171:	7f ed                	jg     80105160 <strncpy+0x40>
  return os;
}
80105173:	5b                   	pop    %ebx
80105174:	89 f0                	mov    %esi,%eax
80105176:	5e                   	pop    %esi
80105177:	5f                   	pop    %edi
80105178:	5d                   	pop    %ebp
80105179:	c3                   	ret    
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105180 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	56                   	push   %esi
80105188:	8b 55 10             	mov    0x10(%ebp),%edx
8010518b:	8b 75 08             	mov    0x8(%ebp),%esi
8010518e:	53                   	push   %ebx
8010518f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105192:	85 d2                	test   %edx,%edx
80105194:	7e 21                	jle    801051b7 <safestrcpy+0x37>
80105196:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010519a:	89 f2                	mov    %esi,%edx
8010519c:	eb 12                	jmp    801051b0 <safestrcpy+0x30>
8010519e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801051a0:	0f b6 08             	movzbl (%eax),%ecx
801051a3:	83 c0 01             	add    $0x1,%eax
801051a6:	83 c2 01             	add    $0x1,%edx
801051a9:	88 4a ff             	mov    %cl,-0x1(%edx)
801051ac:	84 c9                	test   %cl,%cl
801051ae:	74 04                	je     801051b4 <safestrcpy+0x34>
801051b0:	39 d8                	cmp    %ebx,%eax
801051b2:	75 ec                	jne    801051a0 <safestrcpy+0x20>
    ;
  *s = 0;
801051b4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801051b7:	89 f0                	mov    %esi,%eax
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi

801051c0 <strlen>:

int
strlen(const char *s)
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801051c5:	31 c0                	xor    %eax,%eax
{
801051c7:	89 e5                	mov    %esp,%ebp
801051c9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801051cc:	80 3a 00             	cmpb   $0x0,(%edx)
801051cf:	74 10                	je     801051e1 <strlen+0x21>
801051d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051d8:	83 c0 01             	add    $0x1,%eax
801051db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051df:	75 f7                	jne    801051d8 <strlen+0x18>
    ;
  return n;
}
801051e1:	5d                   	pop    %ebp
801051e2:	c3                   	ret    

801051e3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051e3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051e7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051eb:	55                   	push   %ebp
  pushl %ebx
801051ec:	53                   	push   %ebx
  pushl %esi
801051ed:	56                   	push   %esi
  pushl %edi
801051ee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051ef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051f1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051f3:	5f                   	pop    %edi
  popl %esi
801051f4:	5e                   	pop    %esi
  popl %ebx
801051f5:	5b                   	pop    %ebx
  popl %ebp
801051f6:	5d                   	pop    %ebp
  ret
801051f7:	c3                   	ret    
801051f8:	66 90                	xchg   %ax,%ax
801051fa:	66 90                	xchg   %ax,%ax
801051fc:	66 90                	xchg   %ax,%ax
801051fe:	66 90                	xchg   %ax,%ax

80105200 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	53                   	push   %ebx
80105208:	83 ec 04             	sub    $0x4,%esp
8010520b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010520e:	e8 bd ee ff ff       	call   801040d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105213:	8b 00                	mov    (%eax),%eax
80105215:	39 d8                	cmp    %ebx,%eax
80105217:	76 17                	jbe    80105230 <fetchint+0x30>
80105219:	8d 53 04             	lea    0x4(%ebx),%edx
8010521c:	39 d0                	cmp    %edx,%eax
8010521e:	72 10                	jb     80105230 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105220:	8b 45 0c             	mov    0xc(%ebp),%eax
80105223:	8b 13                	mov    (%ebx),%edx
80105225:	89 10                	mov    %edx,(%eax)
  return 0;
80105227:	31 c0                	xor    %eax,%eax
}
80105229:	83 c4 04             	add    $0x4,%esp
8010522c:	5b                   	pop    %ebx
8010522d:	5d                   	pop    %ebp
8010522e:	c3                   	ret    
8010522f:	90                   	nop
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105235:	eb f2                	jmp    80105229 <fetchint+0x29>
80105237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523e:	66 90                	xchg   %ax,%ax

80105240 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	53                   	push   %ebx
80105248:	83 ec 04             	sub    $0x4,%esp
8010524b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010524e:	e8 7d ee ff ff       	call   801040d0 <myproc>

  if(addr >= curproc->sz)
80105253:	39 18                	cmp    %ebx,(%eax)
80105255:	76 31                	jbe    80105288 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105257:	8b 55 0c             	mov    0xc(%ebp),%edx
8010525a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010525c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010525e:	39 d3                	cmp    %edx,%ebx
80105260:	73 26                	jae    80105288 <fetchstr+0x48>
80105262:	89 d8                	mov    %ebx,%eax
80105264:	eb 11                	jmp    80105277 <fetchstr+0x37>
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c0 01             	add    $0x1,%eax
80105273:	39 c2                	cmp    %eax,%edx
80105275:	76 11                	jbe    80105288 <fetchstr+0x48>
    if(*s == 0)
80105277:	80 38 00             	cmpb   $0x0,(%eax)
8010527a:	75 f4                	jne    80105270 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010527c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010527f:	29 d8                	sub    %ebx,%eax
}
80105281:	5b                   	pop    %ebx
80105282:	5d                   	pop    %ebp
80105283:	c3                   	ret    
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105288:	83 c4 04             	add    $0x4,%esp
    return -1;
8010528b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105290:	5b                   	pop    %ebx
80105291:	5d                   	pop    %ebp
80105292:	c3                   	ret    
80105293:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052a0:	f3 0f 1e fb          	endbr32 
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	56                   	push   %esi
801052a8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052a9:	e8 22 ee ff ff       	call   801040d0 <myproc>
801052ae:	8b 55 08             	mov    0x8(%ebp),%edx
801052b1:	8b 40 18             	mov    0x18(%eax),%eax
801052b4:	8b 40 44             	mov    0x44(%eax),%eax
801052b7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052ba:	e8 11 ee ff ff       	call   801040d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052bf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052c2:	8b 00                	mov    (%eax),%eax
801052c4:	39 c6                	cmp    %eax,%esi
801052c6:	73 18                	jae    801052e0 <argint+0x40>
801052c8:	8d 53 08             	lea    0x8(%ebx),%edx
801052cb:	39 d0                	cmp    %edx,%eax
801052cd:	72 11                	jb     801052e0 <argint+0x40>
  *ip = *(int*)(addr);
801052cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d2:	8b 53 04             	mov    0x4(%ebx),%edx
801052d5:	89 10                	mov    %edx,(%eax)
  return 0;
801052d7:	31 c0                	xor    %eax,%eax
}
801052d9:	5b                   	pop    %ebx
801052da:	5e                   	pop    %esi
801052db:	5d                   	pop    %ebp
801052dc:	c3                   	ret    
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052e5:	eb f2                	jmp    801052d9 <argint+0x39>
801052e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	56                   	push   %esi
801052f8:	53                   	push   %ebx
801052f9:	83 ec 10             	sub    $0x10,%esp
801052fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801052ff:	e8 cc ed ff ff       	call   801040d0 <myproc>
 
  if(argint(n, &i) < 0)
80105304:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105307:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105309:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530c:	50                   	push   %eax
8010530d:	ff 75 08             	pushl  0x8(%ebp)
80105310:	e8 8b ff ff ff       	call   801052a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105315:	83 c4 10             	add    $0x10,%esp
80105318:	85 c0                	test   %eax,%eax
8010531a:	78 24                	js     80105340 <argptr+0x50>
8010531c:	85 db                	test   %ebx,%ebx
8010531e:	78 20                	js     80105340 <argptr+0x50>
80105320:	8b 16                	mov    (%esi),%edx
80105322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105325:	39 c2                	cmp    %eax,%edx
80105327:	76 17                	jbe    80105340 <argptr+0x50>
80105329:	01 c3                	add    %eax,%ebx
8010532b:	39 da                	cmp    %ebx,%edx
8010532d:	72 11                	jb     80105340 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010532f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105332:	89 02                	mov    %eax,(%edx)
  return 0;
80105334:	31 c0                	xor    %eax,%eax
}
80105336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5d                   	pop    %ebp
8010533c:	c3                   	ret    
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105345:	eb ef                	jmp    80105336 <argptr+0x46>
80105347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534e:	66 90                	xchg   %ax,%ax

80105350 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010535a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535d:	50                   	push   %eax
8010535e:	ff 75 08             	pushl  0x8(%ebp)
80105361:	e8 3a ff ff ff       	call   801052a0 <argint>
80105366:	83 c4 10             	add    $0x10,%esp
80105369:	85 c0                	test   %eax,%eax
8010536b:	78 13                	js     80105380 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010536d:	83 ec 08             	sub    $0x8,%esp
80105370:	ff 75 0c             	pushl  0xc(%ebp)
80105373:	ff 75 f4             	pushl  -0xc(%ebp)
80105376:	e8 c5 fe ff ff       	call   80105240 <fetchstr>
8010537b:	83 c4 10             	add    $0x10,%esp
}
8010537e:	c9                   	leave  
8010537f:	c3                   	ret    
80105380:	c9                   	leave  
    return -1;
80105381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105386:	c3                   	ret    
80105387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538e:	66 90                	xchg   %ax,%ax

80105390 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	53                   	push   %ebx
80105398:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010539b:	e8 30 ed ff ff       	call   801040d0 <myproc>
801053a0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801053a2:	8b 40 18             	mov    0x18(%eax),%eax
801053a5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053a8:	8d 50 ff             	lea    -0x1(%eax),%edx
801053ab:	83 fa 16             	cmp    $0x16,%edx
801053ae:	77 20                	ja     801053d0 <syscall+0x40>
801053b0:	8b 14 85 20 8b 10 80 	mov    -0x7fef74e0(,%eax,4),%edx
801053b7:	85 d2                	test   %edx,%edx
801053b9:	74 15                	je     801053d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801053bb:	ff d2                	call   *%edx
801053bd:	89 c2                	mov    %eax,%edx
801053bf:	8b 43 18             	mov    0x18(%ebx),%eax
801053c2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801053c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c8:	c9                   	leave  
801053c9:	c3                   	ret    
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801053d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801053d1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801053d4:	50                   	push   %eax
801053d5:	ff 73 10             	pushl  0x10(%ebx)
801053d8:	68 f1 8a 10 80       	push   $0x80108af1
801053dd:	e8 ce b2 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801053e2:	8b 43 18             	mov    0x18(%ebx),%eax
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053f2:	c9                   	leave  
801053f3:	c3                   	ret    
801053f4:	66 90                	xchg   %ax,%ax
801053f6:	66 90                	xchg   %ax,%ax
801053f8:	66 90                	xchg   %ax,%ax
801053fa:	66 90                	xchg   %ax,%ax
801053fc:	66 90                	xchg   %ax,%ax
801053fe:	66 90                	xchg   %ax,%ax

80105400 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	56                   	push   %esi
80105404:	89 d6                	mov    %edx,%esi
80105406:	53                   	push   %ebx
80105407:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105409:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010540c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010540f:	50                   	push   %eax
80105410:	6a 00                	push   $0x0
80105412:	e8 89 fe ff ff       	call   801052a0 <argint>
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	78 2a                	js     80105448 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010541e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105422:	77 24                	ja     80105448 <argfd.constprop.0+0x48>
80105424:	e8 a7 ec ff ff       	call   801040d0 <myproc>
80105429:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010542c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105430:	85 c0                	test   %eax,%eax
80105432:	74 14                	je     80105448 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105434:	85 db                	test   %ebx,%ebx
80105436:	74 02                	je     8010543a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105438:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010543a:	89 06                	mov    %eax,(%esi)
  return 0;
8010543c:	31 c0                	xor    %eax,%eax
}
8010543e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105441:	5b                   	pop    %ebx
80105442:	5e                   	pop    %esi
80105443:	5d                   	pop    %ebp
80105444:	c3                   	ret    
80105445:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	eb ef                	jmp    8010543e <argfd.constprop.0+0x3e>
8010544f:	90                   	nop

80105450 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105455:	31 c0                	xor    %eax,%eax
{
80105457:	89 e5                	mov    %esp,%ebp
80105459:	56                   	push   %esi
8010545a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010545b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010545e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105461:	e8 9a ff ff ff       	call   80105400 <argfd.constprop.0>
80105466:	85 c0                	test   %eax,%eax
80105468:	78 1e                	js     80105488 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010546a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010546d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010546f:	e8 5c ec ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105478:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010547c:	85 d2                	test   %edx,%edx
8010547e:	74 20                	je     801054a0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105480:	83 c3 01             	add    $0x1,%ebx
80105483:	83 fb 10             	cmp    $0x10,%ebx
80105486:	75 f0                	jne    80105478 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105488:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010548b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105490:	89 d8                	mov    %ebx,%eax
80105492:	5b                   	pop    %ebx
80105493:	5e                   	pop    %esi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret    
80105496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801054a0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	ff 75 f4             	pushl  -0xc(%ebp)
801054aa:	e8 01 ba ff ff       	call   80100eb0 <filedup>
  return fd;
801054af:	83 c4 10             	add    $0x10,%esp
}
801054b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b5:	89 d8                	mov    %ebx,%eax
801054b7:	5b                   	pop    %ebx
801054b8:	5e                   	pop    %esi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop

801054c0 <sys_read>:

int
sys_read(void)
{
801054c0:	f3 0f 1e fb          	endbr32 
801054c4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054c5:	31 c0                	xor    %eax,%eax
{
801054c7:	89 e5                	mov    %esp,%ebp
801054c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054cf:	e8 2c ff ff ff       	call   80105400 <argfd.constprop.0>
801054d4:	85 c0                	test   %eax,%eax
801054d6:	78 48                	js     80105520 <sys_read+0x60>
801054d8:	83 ec 08             	sub    $0x8,%esp
801054db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054de:	50                   	push   %eax
801054df:	6a 02                	push   $0x2
801054e1:	e8 ba fd ff ff       	call   801052a0 <argint>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	85 c0                	test   %eax,%eax
801054eb:	78 33                	js     80105520 <sys_read+0x60>
801054ed:	83 ec 04             	sub    $0x4,%esp
801054f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f3:	ff 75 f0             	pushl  -0x10(%ebp)
801054f6:	50                   	push   %eax
801054f7:	6a 01                	push   $0x1
801054f9:	e8 f2 fd ff ff       	call   801052f0 <argptr>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	78 1b                	js     80105520 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105505:	83 ec 04             	sub    $0x4,%esp
80105508:	ff 75 f0             	pushl  -0x10(%ebp)
8010550b:	ff 75 f4             	pushl  -0xc(%ebp)
8010550e:	ff 75 ec             	pushl  -0x14(%ebp)
80105511:	e8 1a bb ff ff       	call   80101030 <fileread>
80105516:	83 c4 10             	add    $0x10,%esp
}
80105519:	c9                   	leave  
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
80105520:	c9                   	leave  
    return -1;
80105521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105526:	c3                   	ret    
80105527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552e:	66 90                	xchg   %ax,%ax

80105530 <sys_write>:

int
sys_write(void)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105535:	31 c0                	xor    %eax,%eax
{
80105537:	89 e5                	mov    %esp,%ebp
80105539:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010553c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010553f:	e8 bc fe ff ff       	call   80105400 <argfd.constprop.0>
80105544:	85 c0                	test   %eax,%eax
80105546:	78 48                	js     80105590 <sys_write+0x60>
80105548:	83 ec 08             	sub    $0x8,%esp
8010554b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010554e:	50                   	push   %eax
8010554f:	6a 02                	push   $0x2
80105551:	e8 4a fd ff ff       	call   801052a0 <argint>
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	85 c0                	test   %eax,%eax
8010555b:	78 33                	js     80105590 <sys_write+0x60>
8010555d:	83 ec 04             	sub    $0x4,%esp
80105560:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105563:	ff 75 f0             	pushl  -0x10(%ebp)
80105566:	50                   	push   %eax
80105567:	6a 01                	push   $0x1
80105569:	e8 82 fd ff ff       	call   801052f0 <argptr>
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 1b                	js     80105590 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105575:	83 ec 04             	sub    $0x4,%esp
80105578:	ff 75 f0             	pushl  -0x10(%ebp)
8010557b:	ff 75 f4             	pushl  -0xc(%ebp)
8010557e:	ff 75 ec             	pushl  -0x14(%ebp)
80105581:	e8 4a bb ff ff       	call   801010d0 <filewrite>
80105586:	83 c4 10             	add    $0x10,%esp
}
80105589:	c9                   	leave  
8010558a:	c3                   	ret    
8010558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop
80105590:	c9                   	leave  
    return -1;
80105591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105596:	c3                   	ret    
80105597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559e:	66 90                	xchg   %ax,%ax

801055a0 <sys_close>:

int
sys_close(void)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801055aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
801055ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b0:	e8 4b fe ff ff       	call   80105400 <argfd.constprop.0>
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 27                	js     801055e0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801055b9:	e8 12 eb ff ff       	call   801040d0 <myproc>
801055be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801055c1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801055c4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801055cb:	00 
  fileclose(f);
801055cc:	ff 75 f4             	pushl  -0xc(%ebp)
801055cf:	e8 2c b9 ff ff       	call   80100f00 <fileclose>
  return 0;
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	31 c0                	xor    %eax,%eax
}
801055d9:	c9                   	leave  
801055da:	c3                   	ret    
801055db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055df:	90                   	nop
801055e0:	c9                   	leave  
    return -1;
801055e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e6:	c3                   	ret    
801055e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <sys_fstat>:

int
sys_fstat(void)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055f5:	31 c0                	xor    %eax,%eax
{
801055f7:	89 e5                	mov    %esp,%ebp
801055f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801055ff:	e8 fc fd ff ff       	call   80105400 <argfd.constprop.0>
80105604:	85 c0                	test   %eax,%eax
80105606:	78 30                	js     80105638 <sys_fstat+0x48>
80105608:	83 ec 04             	sub    $0x4,%esp
8010560b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560e:	6a 14                	push   $0x14
80105610:	50                   	push   %eax
80105611:	6a 01                	push   $0x1
80105613:	e8 d8 fc ff ff       	call   801052f0 <argptr>
80105618:	83 c4 10             	add    $0x10,%esp
8010561b:	85 c0                	test   %eax,%eax
8010561d:	78 19                	js     80105638 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010561f:	83 ec 08             	sub    $0x8,%esp
80105622:	ff 75 f4             	pushl  -0xc(%ebp)
80105625:	ff 75 f0             	pushl  -0x10(%ebp)
80105628:	e8 b3 b9 ff ff       	call   80100fe0 <filestat>
8010562d:	83 c4 10             	add    $0x10,%esp
}
80105630:	c9                   	leave  
80105631:	c3                   	ret    
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105638:	c9                   	leave  
    return -1;
80105639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010563e:	c3                   	ret    
8010563f:	90                   	nop

80105640 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	57                   	push   %edi
80105648:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105649:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010564c:	53                   	push   %ebx
8010564d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105650:	50                   	push   %eax
80105651:	6a 00                	push   $0x0
80105653:	e8 f8 fc ff ff       	call   80105350 <argstr>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	85 c0                	test   %eax,%eax
8010565d:	0f 88 ff 00 00 00    	js     80105762 <sys_link+0x122>
80105663:	83 ec 08             	sub    $0x8,%esp
80105666:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105669:	50                   	push   %eax
8010566a:	6a 01                	push   $0x1
8010566c:	e8 df fc ff ff       	call   80105350 <argstr>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	0f 88 e6 00 00 00    	js     80105762 <sys_link+0x122>
    return -1;

  begin_op();
8010567c:	e8 ff dc ff ff       	call   80103380 <begin_op>
  if((ip = namei(old)) == 0){
80105681:	83 ec 0c             	sub    $0xc,%esp
80105684:	ff 75 d4             	pushl  -0x2c(%ebp)
80105687:	e8 e4 c9 ff ff       	call   80102070 <namei>
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	89 c3                	mov    %eax,%ebx
80105691:	85 c0                	test   %eax,%eax
80105693:	0f 84 e8 00 00 00    	je     80105781 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105699:	83 ec 0c             	sub    $0xc,%esp
8010569c:	50                   	push   %eax
8010569d:	e8 fe c0 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056aa:	0f 84 b9 00 00 00    	je     80105769 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801056b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801056b8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056bb:	53                   	push   %ebx
801056bc:	e8 1f c0 ff ff       	call   801016e0 <iupdate>
  iunlock(ip);
801056c1:	89 1c 24             	mov    %ebx,(%esp)
801056c4:	e8 b7 c1 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801056c9:	58                   	pop    %eax
801056ca:	5a                   	pop    %edx
801056cb:	57                   	push   %edi
801056cc:	ff 75 d0             	pushl  -0x30(%ebp)
801056cf:	e8 bc c9 ff ff       	call   80102090 <nameiparent>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	89 c6                	mov    %eax,%esi
801056d9:	85 c0                	test   %eax,%eax
801056db:	74 5f                	je     8010573c <sys_link+0xfc>
    goto bad;
  ilock(dp);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	50                   	push   %eax
801056e1:	e8 ba c0 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056e6:	8b 03                	mov    (%ebx),%eax
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	39 06                	cmp    %eax,(%esi)
801056ed:	75 41                	jne    80105730 <sys_link+0xf0>
801056ef:	83 ec 04             	sub    $0x4,%esp
801056f2:	ff 73 04             	pushl  0x4(%ebx)
801056f5:	57                   	push   %edi
801056f6:	56                   	push   %esi
801056f7:	e8 b4 c8 ff ff       	call   80101fb0 <dirlink>
801056fc:	83 c4 10             	add    $0x10,%esp
801056ff:	85 c0                	test   %eax,%eax
80105701:	78 2d                	js     80105730 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105703:	83 ec 0c             	sub    $0xc,%esp
80105706:	56                   	push   %esi
80105707:	e8 34 c3 ff ff       	call   80101a40 <iunlockput>
  iput(ip);
8010570c:	89 1c 24             	mov    %ebx,(%esp)
8010570f:	e8 bc c1 ff ff       	call   801018d0 <iput>

  end_op();
80105714:	e8 17 dd ff ff       	call   80103430 <end_op>

  return 0;
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010571e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105721:	5b                   	pop    %ebx
80105722:	5e                   	pop    %esi
80105723:	5f                   	pop    %edi
80105724:	5d                   	pop    %ebp
80105725:	c3                   	ret    
80105726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	56                   	push   %esi
80105734:	e8 07 c3 ff ff       	call   80101a40 <iunlockput>
    goto bad;
80105739:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010573c:	83 ec 0c             	sub    $0xc,%esp
8010573f:	53                   	push   %ebx
80105740:	e8 5b c0 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
80105745:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010574a:	89 1c 24             	mov    %ebx,(%esp)
8010574d:	e8 8e bf ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
80105752:	89 1c 24             	mov    %ebx,(%esp)
80105755:	e8 e6 c2 ff ff       	call   80101a40 <iunlockput>
  end_op();
8010575a:	e8 d1 dc ff ff       	call   80103430 <end_op>
  return -1;
8010575f:	83 c4 10             	add    $0x10,%esp
80105762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105767:	eb b5                	jmp    8010571e <sys_link+0xde>
    iunlockput(ip);
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	53                   	push   %ebx
8010576d:	e8 ce c2 ff ff       	call   80101a40 <iunlockput>
    end_op();
80105772:	e8 b9 dc ff ff       	call   80103430 <end_op>
    return -1;
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577f:	eb 9d                	jmp    8010571e <sys_link+0xde>
    end_op();
80105781:	e8 aa dc ff ff       	call   80103430 <end_op>
    return -1;
80105786:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010578b:	eb 91                	jmp    8010571e <sys_link+0xde>
8010578d:	8d 76 00             	lea    0x0(%esi),%esi

80105790 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	57                   	push   %edi
80105798:	56                   	push   %esi
80105799:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010579c:	53                   	push   %ebx
8010579d:	bb 20 00 00 00       	mov    $0x20,%ebx
801057a2:	83 ec 1c             	sub    $0x1c,%esp
801057a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057a8:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801057ac:	77 0a                	ja     801057b8 <isdirempty+0x28>
801057ae:	eb 30                	jmp    801057e0 <isdirempty+0x50>
801057b0:	83 c3 10             	add    $0x10,%ebx
801057b3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801057b6:	76 28                	jbe    801057e0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057b8:	6a 10                	push   $0x10
801057ba:	53                   	push   %ebx
801057bb:	57                   	push   %edi
801057bc:	56                   	push   %esi
801057bd:	e8 de c2 ff ff       	call   80101aa0 <readi>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	83 f8 10             	cmp    $0x10,%eax
801057c8:	75 23                	jne    801057ed <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801057ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057cf:	74 df                	je     801057b0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801057d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801057d4:	31 c0                	xor    %eax,%eax
}
801057d6:	5b                   	pop    %ebx
801057d7:	5e                   	pop    %esi
801057d8:	5f                   	pop    %edi
801057d9:	5d                   	pop    %ebp
801057da:	c3                   	ret    
801057db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop
801057e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801057e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057e8:	5b                   	pop    %ebx
801057e9:	5e                   	pop    %esi
801057ea:	5f                   	pop    %edi
801057eb:	5d                   	pop    %ebp
801057ec:	c3                   	ret    
      panic("isdirempty: readi");
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	68 80 8b 10 80       	push   $0x80108b80
801057f5:	e8 96 ab ff ff       	call   80100390 <panic>
801057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105800 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105800:	f3 0f 1e fb          	endbr32 
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	57                   	push   %edi
80105808:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105809:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010580c:	53                   	push   %ebx
8010580d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105810:	50                   	push   %eax
80105811:	6a 00                	push   $0x0
80105813:	e8 38 fb ff ff       	call   80105350 <argstr>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	0f 88 5d 01 00 00    	js     80105980 <sys_unlink+0x180>
    return -1;

  begin_op();
80105823:	e8 58 db ff ff       	call   80103380 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105828:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010582b:	83 ec 08             	sub    $0x8,%esp
8010582e:	53                   	push   %ebx
8010582f:	ff 75 c0             	pushl  -0x40(%ebp)
80105832:	e8 59 c8 ff ff       	call   80102090 <nameiparent>
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	89 c6                	mov    %eax,%esi
8010583c:	85 c0                	test   %eax,%eax
8010583e:	0f 84 43 01 00 00    	je     80105987 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	50                   	push   %eax
80105848:	e8 53 bf ff ff       	call   801017a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010584d:	58                   	pop    %eax
8010584e:	5a                   	pop    %edx
8010584f:	68 dd 84 10 80       	push   $0x801084dd
80105854:	53                   	push   %ebx
80105855:	e8 76 c4 ff ff       	call   80101cd0 <namecmp>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	0f 84 db 00 00 00    	je     80105940 <sys_unlink+0x140>
80105865:	83 ec 08             	sub    $0x8,%esp
80105868:	68 dc 84 10 80       	push   $0x801084dc
8010586d:	53                   	push   %ebx
8010586e:	e8 5d c4 ff ff       	call   80101cd0 <namecmp>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	0f 84 c2 00 00 00    	je     80105940 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010587e:	83 ec 04             	sub    $0x4,%esp
80105881:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105884:	50                   	push   %eax
80105885:	53                   	push   %ebx
80105886:	56                   	push   %esi
80105887:	e8 64 c4 ff ff       	call   80101cf0 <dirlookup>
8010588c:	83 c4 10             	add    $0x10,%esp
8010588f:	89 c3                	mov    %eax,%ebx
80105891:	85 c0                	test   %eax,%eax
80105893:	0f 84 a7 00 00 00    	je     80105940 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	50                   	push   %eax
8010589d:	e8 fe be ff ff       	call   801017a0 <ilock>

  if(ip->nlink < 1)
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058aa:	0f 8e f3 00 00 00    	jle    801059a3 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801058b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058b5:	74 69                	je     80105920 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801058b7:	83 ec 04             	sub    $0x4,%esp
801058ba:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058bd:	6a 10                	push   $0x10
801058bf:	6a 00                	push   $0x0
801058c1:	57                   	push   %edi
801058c2:	e8 f9 f6 ff ff       	call   80104fc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058c7:	6a 10                	push   $0x10
801058c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058cc:	57                   	push   %edi
801058cd:	56                   	push   %esi
801058ce:	e8 cd c2 ff ff       	call   80101ba0 <writei>
801058d3:	83 c4 20             	add    $0x20,%esp
801058d6:	83 f8 10             	cmp    $0x10,%eax
801058d9:	0f 85 b7 00 00 00    	jne    80105996 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801058df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058e4:	74 7a                	je     80105960 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801058e6:	83 ec 0c             	sub    $0xc,%esp
801058e9:	56                   	push   %esi
801058ea:	e8 51 c1 ff ff       	call   80101a40 <iunlockput>

  ip->nlink--;
801058ef:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058f4:	89 1c 24             	mov    %ebx,(%esp)
801058f7:	e8 e4 bd ff ff       	call   801016e0 <iupdate>
  iunlockput(ip);
801058fc:	89 1c 24             	mov    %ebx,(%esp)
801058ff:	e8 3c c1 ff ff       	call   80101a40 <iunlockput>

  end_op();
80105904:	e8 27 db ff ff       	call   80103430 <end_op>

  return 0;
80105909:	83 c4 10             	add    $0x10,%esp
8010590c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010590e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105911:	5b                   	pop    %ebx
80105912:	5e                   	pop    %esi
80105913:	5f                   	pop    %edi
80105914:	5d                   	pop    %ebp
80105915:	c3                   	ret    
80105916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	53                   	push   %ebx
80105924:	e8 67 fe ff ff       	call   80105790 <isdirempty>
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	85 c0                	test   %eax,%eax
8010592e:	75 87                	jne    801058b7 <sys_unlink+0xb7>
    iunlockput(ip);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	53                   	push   %ebx
80105934:	e8 07 c1 ff ff       	call   80101a40 <iunlockput>
    goto bad;
80105939:	83 c4 10             	add    $0x10,%esp
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	56                   	push   %esi
80105944:	e8 f7 c0 ff ff       	call   80101a40 <iunlockput>
  end_op();
80105949:	e8 e2 da ff ff       	call   80103430 <end_op>
  return -1;
8010594e:	83 c4 10             	add    $0x10,%esp
80105951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105956:	eb b6                	jmp    8010590e <sys_unlink+0x10e>
80105958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop
    iupdate(dp);
80105960:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105963:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105968:	56                   	push   %esi
80105969:	e8 72 bd ff ff       	call   801016e0 <iupdate>
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	e9 70 ff ff ff       	jmp    801058e6 <sys_unlink+0xe6>
80105976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105985:	eb 87                	jmp    8010590e <sys_unlink+0x10e>
    end_op();
80105987:	e8 a4 da ff ff       	call   80103430 <end_op>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105991:	e9 78 ff ff ff       	jmp    8010590e <sys_unlink+0x10e>
    panic("unlink: writei");
80105996:	83 ec 0c             	sub    $0xc,%esp
80105999:	68 f1 84 10 80       	push   $0x801084f1
8010599e:	e8 ed a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059a3:	83 ec 0c             	sub    $0xc,%esp
801059a6:	68 df 84 10 80       	push   $0x801084df
801059ab:	e8 e0 a9 ff ff       	call   80100390 <panic>

801059b0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	56                   	push   %esi
801059b9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059ba:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801059bd:	83 ec 34             	sub    $0x34,%esp
801059c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801059c3:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
801059c6:	53                   	push   %ebx
{
801059c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801059ca:	ff 75 08             	pushl  0x8(%ebp)
{
801059cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801059d0:	89 55 d0             	mov    %edx,-0x30(%ebp)
801059d3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801059d6:	e8 b5 c6 ff ff       	call   80102090 <nameiparent>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 84 3a 01 00 00    	je     80105b20 <create+0x170>
    return 0;
  ilock(dp);
801059e6:	83 ec 0c             	sub    $0xc,%esp
801059e9:	89 c6                	mov    %eax,%esi
801059eb:	50                   	push   %eax
801059ec:	e8 af bd ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801059f1:	83 c4 0c             	add    $0xc,%esp
801059f4:	6a 00                	push   $0x0
801059f6:	53                   	push   %ebx
801059f7:	56                   	push   %esi
801059f8:	e8 f3 c2 ff ff       	call   80101cf0 <dirlookup>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	89 c7                	mov    %eax,%edi
80105a02:	85 c0                	test   %eax,%eax
80105a04:	74 4a                	je     80105a50 <create+0xa0>
    iunlockput(dp);
80105a06:	83 ec 0c             	sub    $0xc,%esp
80105a09:	56                   	push   %esi
80105a0a:	e8 31 c0 ff ff       	call   80101a40 <iunlockput>
    ilock(ip);
80105a0f:	89 3c 24             	mov    %edi,(%esp)
80105a12:	e8 89 bd ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a1f:	75 17                	jne    80105a38 <create+0x88>
80105a21:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105a26:	75 10                	jne    80105a38 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2b:	89 f8                	mov    %edi,%eax
80105a2d:	5b                   	pop    %ebx
80105a2e:	5e                   	pop    %esi
80105a2f:	5f                   	pop    %edi
80105a30:	5d                   	pop    %ebp
80105a31:	c3                   	ret    
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	57                   	push   %edi
    return 0;
80105a3c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a3e:	e8 fd bf ff ff       	call   80101a40 <iunlockput>
    return 0;
80105a43:	83 c4 10             	add    $0x10,%esp
}
80105a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a49:	89 f8                	mov    %edi,%eax
80105a4b:	5b                   	pop    %ebx
80105a4c:	5e                   	pop    %esi
80105a4d:	5f                   	pop    %edi
80105a4e:	5d                   	pop    %ebp
80105a4f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105a50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a54:	83 ec 08             	sub    $0x8,%esp
80105a57:	50                   	push   %eax
80105a58:	ff 36                	pushl  (%esi)
80105a5a:	e8 c1 bb ff ff       	call   80101620 <ialloc>
80105a5f:	83 c4 10             	add    $0x10,%esp
80105a62:	89 c7                	mov    %eax,%edi
80105a64:	85 c0                	test   %eax,%eax
80105a66:	0f 84 cd 00 00 00    	je     80105b39 <create+0x189>
  ilock(ip);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	50                   	push   %eax
80105a70:	e8 2b bd ff ff       	call   801017a0 <ilock>
  ip->major = major;
80105a75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105a79:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105a7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105a81:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105a85:	b8 01 00 00 00       	mov    $0x1,%eax
80105a8a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105a8e:	89 3c 24             	mov    %edi,(%esp)
80105a91:	e8 4a bc ff ff       	call   801016e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a96:	83 c4 10             	add    $0x10,%esp
80105a99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a9e:	74 30                	je     80105ad0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105aa0:	83 ec 04             	sub    $0x4,%esp
80105aa3:	ff 77 04             	pushl  0x4(%edi)
80105aa6:	53                   	push   %ebx
80105aa7:	56                   	push   %esi
80105aa8:	e8 03 c5 ff ff       	call   80101fb0 <dirlink>
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	85 c0                	test   %eax,%eax
80105ab2:	78 78                	js     80105b2c <create+0x17c>
  iunlockput(dp);
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	56                   	push   %esi
80105ab8:	e8 83 bf ff ff       	call   80101a40 <iunlockput>
  return ip;
80105abd:	83 c4 10             	add    $0x10,%esp
}
80105ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac3:	89 f8                	mov    %edi,%eax
80105ac5:	5b                   	pop    %ebx
80105ac6:	5e                   	pop    %esi
80105ac7:	5f                   	pop    %edi
80105ac8:	5d                   	pop    %ebp
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105ad3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105ad8:	56                   	push   %esi
80105ad9:	e8 02 bc ff ff       	call   801016e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ade:	83 c4 0c             	add    $0xc,%esp
80105ae1:	ff 77 04             	pushl  0x4(%edi)
80105ae4:	68 dd 84 10 80       	push   $0x801084dd
80105ae9:	57                   	push   %edi
80105aea:	e8 c1 c4 ff ff       	call   80101fb0 <dirlink>
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	85 c0                	test   %eax,%eax
80105af4:	78 18                	js     80105b0e <create+0x15e>
80105af6:	83 ec 04             	sub    $0x4,%esp
80105af9:	ff 76 04             	pushl  0x4(%esi)
80105afc:	68 dc 84 10 80       	push   $0x801084dc
80105b01:	57                   	push   %edi
80105b02:	e8 a9 c4 ff ff       	call   80101fb0 <dirlink>
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	79 92                	jns    80105aa0 <create+0xf0>
      panic("create dots");
80105b0e:	83 ec 0c             	sub    $0xc,%esp
80105b11:	68 a1 8b 10 80       	push   $0x80108ba1
80105b16:	e8 75 a8 ff ff       	call   80100390 <panic>
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
}
80105b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105b23:	31 ff                	xor    %edi,%edi
}
80105b25:	5b                   	pop    %ebx
80105b26:	89 f8                	mov    %edi,%eax
80105b28:	5e                   	pop    %esi
80105b29:	5f                   	pop    %edi
80105b2a:	5d                   	pop    %ebp
80105b2b:	c3                   	ret    
    panic("create: dirlink");
80105b2c:	83 ec 0c             	sub    $0xc,%esp
80105b2f:	68 ad 8b 10 80       	push   $0x80108bad
80105b34:	e8 57 a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	68 92 8b 10 80       	push   $0x80108b92
80105b41:	e8 4a a8 ff ff       	call   80100390 <panic>
80105b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi

80105b50 <sys_open>:

int
sys_open(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
80105b55:	89 e5                	mov    %esp,%ebp
80105b57:	57                   	push   %edi
80105b58:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b59:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b5c:	53                   	push   %ebx
80105b5d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b60:	50                   	push   %eax
80105b61:	6a 00                	push   $0x0
80105b63:	e8 e8 f7 ff ff       	call   80105350 <argstr>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	0f 88 8a 00 00 00    	js     80105bfd <sys_open+0xad>
80105b73:	83 ec 08             	sub    $0x8,%esp
80105b76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 01                	push   $0x1
80105b7c:	e8 1f f7 ff ff       	call   801052a0 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 75                	js     80105bfd <sys_open+0xad>
    return -1;

  begin_op();
80105b88:	e8 f3 d7 ff ff       	call   80103380 <begin_op>

  if(omode & O_CREATE){
80105b8d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b91:	75 75                	jne    80105c08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b93:	83 ec 0c             	sub    $0xc,%esp
80105b96:	ff 75 e0             	pushl  -0x20(%ebp)
80105b99:	e8 d2 c4 ff ff       	call   80102070 <namei>
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	89 c6                	mov    %eax,%esi
80105ba3:	85 c0                	test   %eax,%eax
80105ba5:	74 78                	je     80105c1f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105ba7:	83 ec 0c             	sub    $0xc,%esp
80105baa:	50                   	push   %eax
80105bab:	e8 f0 bb ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bb0:	83 c4 10             	add    $0x10,%esp
80105bb3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105bb8:	0f 84 ba 00 00 00    	je     80105c78 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105bbe:	e8 7d b2 ff ff       	call   80100e40 <filealloc>
80105bc3:	89 c7                	mov    %eax,%edi
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 23                	je     80105bec <sys_open+0x9c>
  struct proc *curproc = myproc();
80105bc9:	e8 02 e5 ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105bd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bd4:	85 d2                	test   %edx,%edx
80105bd6:	74 58                	je     80105c30 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105bd8:	83 c3 01             	add    $0x1,%ebx
80105bdb:	83 fb 10             	cmp    $0x10,%ebx
80105bde:	75 f0                	jne    80105bd0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	57                   	push   %edi
80105be4:	e8 17 b3 ff ff       	call   80100f00 <fileclose>
80105be9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105bec:	83 ec 0c             	sub    $0xc,%esp
80105bef:	56                   	push   %esi
80105bf0:	e8 4b be ff ff       	call   80101a40 <iunlockput>
    end_op();
80105bf5:	e8 36 d8 ff ff       	call   80103430 <end_op>
    return -1;
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c02:	eb 65                	jmp    80105c69 <sys_open+0x119>
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c08:	6a 00                	push   $0x0
80105c0a:	6a 00                	push   $0x0
80105c0c:	6a 02                	push   $0x2
80105c0e:	ff 75 e0             	pushl  -0x20(%ebp)
80105c11:	e8 9a fd ff ff       	call   801059b0 <create>
    if(ip == 0){
80105c16:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105c19:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	75 9f                	jne    80105bbe <sys_open+0x6e>
      end_op();
80105c1f:	e8 0c d8 ff ff       	call   80103430 <end_op>
      return -1;
80105c24:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c29:	eb 3e                	jmp    80105c69 <sys_open+0x119>
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
  }
  iunlock(ip);
80105c30:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c33:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c37:	56                   	push   %esi
80105c38:	e8 43 bc ff ff       	call   80101880 <iunlock>
  end_op();
80105c3d:	e8 ee d7 ff ff       	call   80103430 <end_op>

  f->type = FD_INODE;
80105c42:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c4b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c4e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105c51:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105c53:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c5a:	f7 d0                	not    %eax
80105c5c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c5f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105c62:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c65:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c6c:	89 d8                	mov    %ebx,%eax
80105c6e:	5b                   	pop    %ebx
80105c6f:	5e                   	pop    %esi
80105c70:	5f                   	pop    %edi
80105c71:	5d                   	pop    %ebp
80105c72:	c3                   	ret    
80105c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c77:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c78:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c7b:	85 c9                	test   %ecx,%ecx
80105c7d:	0f 84 3b ff ff ff    	je     80105bbe <sys_open+0x6e>
80105c83:	e9 64 ff ff ff       	jmp    80105bec <sys_open+0x9c>
80105c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop

80105c90 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c9a:	e8 e1 d6 ff ff       	call   80103380 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c9f:	83 ec 08             	sub    $0x8,%esp
80105ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca5:	50                   	push   %eax
80105ca6:	6a 00                	push   $0x0
80105ca8:	e8 a3 f6 ff ff       	call   80105350 <argstr>
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	78 2c                	js     80105ce0 <sys_mkdir+0x50>
80105cb4:	6a 00                	push   $0x0
80105cb6:	6a 00                	push   $0x0
80105cb8:	6a 01                	push   $0x1
80105cba:	ff 75 f4             	pushl  -0xc(%ebp)
80105cbd:	e8 ee fc ff ff       	call   801059b0 <create>
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	74 17                	je     80105ce0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cc9:	83 ec 0c             	sub    $0xc,%esp
80105ccc:	50                   	push   %eax
80105ccd:	e8 6e bd ff ff       	call   80101a40 <iunlockput>
  end_op();
80105cd2:	e8 59 d7 ff ff       	call   80103430 <end_op>
  return 0;
80105cd7:	83 c4 10             	add    $0x10,%esp
80105cda:	31 c0                	xor    %eax,%eax
}
80105cdc:	c9                   	leave  
80105cdd:	c3                   	ret    
80105cde:	66 90                	xchg   %ax,%ax
    end_op();
80105ce0:	e8 4b d7 ff ff       	call   80103430 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cea:	c9                   	leave  
80105ceb:	c3                   	ret    
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_mknod>:

int
sys_mknod(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105cfa:	e8 81 d6 ff ff       	call   80103380 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105cff:	83 ec 08             	sub    $0x8,%esp
80105d02:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d05:	50                   	push   %eax
80105d06:	6a 00                	push   $0x0
80105d08:	e8 43 f6 ff ff       	call   80105350 <argstr>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	78 5c                	js     80105d70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d14:	83 ec 08             	sub    $0x8,%esp
80105d17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d1a:	50                   	push   %eax
80105d1b:	6a 01                	push   $0x1
80105d1d:	e8 7e f5 ff ff       	call   801052a0 <argint>
  if((argstr(0, &path)) < 0 ||
80105d22:	83 c4 10             	add    $0x10,%esp
80105d25:	85 c0                	test   %eax,%eax
80105d27:	78 47                	js     80105d70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105d29:	83 ec 08             	sub    $0x8,%esp
80105d2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d2f:	50                   	push   %eax
80105d30:	6a 02                	push   $0x2
80105d32:	e8 69 f5 ff ff       	call   801052a0 <argint>
     argint(1, &major) < 0 ||
80105d37:	83 c4 10             	add    $0x10,%esp
80105d3a:	85 c0                	test   %eax,%eax
80105d3c:	78 32                	js     80105d70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d3e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105d42:	50                   	push   %eax
80105d43:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105d47:	50                   	push   %eax
80105d48:	6a 03                	push   $0x3
80105d4a:	ff 75 ec             	pushl  -0x14(%ebp)
80105d4d:	e8 5e fc ff ff       	call   801059b0 <create>
     argint(2, &minor) < 0 ||
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 17                	je     80105d70 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	50                   	push   %eax
80105d5d:	e8 de bc ff ff       	call   80101a40 <iunlockput>
  end_op();
80105d62:	e8 c9 d6 ff ff       	call   80103430 <end_op>
  return 0;
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	31 c0                	xor    %eax,%eax
}
80105d6c:	c9                   	leave  
80105d6d:	c3                   	ret    
80105d6e:	66 90                	xchg   %ax,%ax
    end_op();
80105d70:	e8 bb d6 ff ff       	call   80103430 <end_op>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7a:	c9                   	leave  
80105d7b:	c3                   	ret    
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_chdir>:

int
sys_chdir(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	56                   	push   %esi
80105d88:	53                   	push   %ebx
80105d89:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d8c:	e8 3f e3 ff ff       	call   801040d0 <myproc>
80105d91:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d93:	e8 e8 d5 ff ff       	call   80103380 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d9e:	50                   	push   %eax
80105d9f:	6a 00                	push   $0x0
80105da1:	e8 aa f5 ff ff       	call   80105350 <argstr>
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	85 c0                	test   %eax,%eax
80105dab:	78 73                	js     80105e20 <sys_chdir+0xa0>
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	ff 75 f4             	pushl  -0xc(%ebp)
80105db3:	e8 b8 c2 ff ff       	call   80102070 <namei>
80105db8:	83 c4 10             	add    $0x10,%esp
80105dbb:	89 c3                	mov    %eax,%ebx
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	74 5f                	je     80105e20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	50                   	push   %eax
80105dc5:	e8 d6 b9 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105dca:	83 c4 10             	add    $0x10,%esp
80105dcd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dd2:	75 2c                	jne    80105e00 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105dd4:	83 ec 0c             	sub    $0xc,%esp
80105dd7:	53                   	push   %ebx
80105dd8:	e8 a3 ba ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105ddd:	58                   	pop    %eax
80105dde:	ff 76 68             	pushl  0x68(%esi)
80105de1:	e8 ea ba ff ff       	call   801018d0 <iput>
  end_op();
80105de6:	e8 45 d6 ff ff       	call   80103430 <end_op>
  curproc->cwd = ip;
80105deb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dee:	83 c4 10             	add    $0x10,%esp
80105df1:	31 c0                	xor    %eax,%eax
}
80105df3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105df6:	5b                   	pop    %ebx
80105df7:	5e                   	pop    %esi
80105df8:	5d                   	pop    %ebp
80105df9:	c3                   	ret    
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	53                   	push   %ebx
80105e04:	e8 37 bc ff ff       	call   80101a40 <iunlockput>
    end_op();
80105e09:	e8 22 d6 ff ff       	call   80103430 <end_op>
    return -1;
80105e0e:	83 c4 10             	add    $0x10,%esp
80105e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e16:	eb db                	jmp    80105df3 <sys_chdir+0x73>
80105e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop
    end_op();
80105e20:	e8 0b d6 ff ff       	call   80103430 <end_op>
    return -1;
80105e25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2a:	eb c7                	jmp    80105df3 <sys_chdir+0x73>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_exec>:

int
sys_exec(void)
{
80105e30:	f3 0f 1e fb          	endbr32 
80105e34:	55                   	push   %ebp
80105e35:	89 e5                	mov    %esp,%ebp
80105e37:	57                   	push   %edi
80105e38:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e39:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e3f:	53                   	push   %ebx
80105e40:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e46:	50                   	push   %eax
80105e47:	6a 00                	push   $0x0
80105e49:	e8 02 f5 ff ff       	call   80105350 <argstr>
80105e4e:	83 c4 10             	add    $0x10,%esp
80105e51:	85 c0                	test   %eax,%eax
80105e53:	0f 88 8b 00 00 00    	js     80105ee4 <sys_exec+0xb4>
80105e59:	83 ec 08             	sub    $0x8,%esp
80105e5c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e62:	50                   	push   %eax
80105e63:	6a 01                	push   $0x1
80105e65:	e8 36 f4 ff ff       	call   801052a0 <argint>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	78 73                	js     80105ee4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e71:	83 ec 04             	sub    $0x4,%esp
80105e74:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105e7a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e7c:	68 80 00 00 00       	push   $0x80
80105e81:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e87:	6a 00                	push   $0x0
80105e89:	50                   	push   %eax
80105e8a:	e8 31 f1 ff ff       	call   80104fc0 <memset>
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e98:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e9e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ea5:	83 ec 08             	sub    $0x8,%esp
80105ea8:	57                   	push   %edi
80105ea9:	01 f0                	add    %esi,%eax
80105eab:	50                   	push   %eax
80105eac:	e8 4f f3 ff ff       	call   80105200 <fetchint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 2c                	js     80105ee4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105eb8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ebe:	85 c0                	test   %eax,%eax
80105ec0:	74 36                	je     80105ef8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ec2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ec8:	83 ec 08             	sub    $0x8,%esp
80105ecb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105ece:	52                   	push   %edx
80105ecf:	50                   	push   %eax
80105ed0:	e8 6b f3 ff ff       	call   80105240 <fetchstr>
80105ed5:	83 c4 10             	add    $0x10,%esp
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	78 08                	js     80105ee4 <sys_exec+0xb4>
  for(i=0;; i++){
80105edc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105edf:	83 fb 20             	cmp    $0x20,%ebx
80105ee2:	75 b4                	jne    80105e98 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eec:	5b                   	pop    %ebx
80105eed:	5e                   	pop    %esi
80105eee:	5f                   	pop    %edi
80105eef:	5d                   	pop    %ebp
80105ef0:	c3                   	ret    
80105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ef8:	83 ec 08             	sub    $0x8,%esp
80105efb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105f01:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f08:	00 00 00 00 
  return exec(path, argv);
80105f0c:	50                   	push   %eax
80105f0d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105f13:	e8 68 ab ff ff       	call   80100a80 <exec>
80105f18:	83 c4 10             	add    $0x10,%esp
}
80105f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f1e:	5b                   	pop    %ebx
80105f1f:	5e                   	pop    %esi
80105f20:	5f                   	pop    %edi
80105f21:	5d                   	pop    %ebp
80105f22:	c3                   	ret    
80105f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f30 <sys_pipe>:

int
sys_pipe(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	57                   	push   %edi
80105f38:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f39:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105f3c:	53                   	push   %ebx
80105f3d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f40:	6a 08                	push   $0x8
80105f42:	50                   	push   %eax
80105f43:	6a 00                	push   $0x0
80105f45:	e8 a6 f3 ff ff       	call   801052f0 <argptr>
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	78 4e                	js     80105f9f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f51:	83 ec 08             	sub    $0x8,%esp
80105f54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f57:	50                   	push   %eax
80105f58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f5b:	50                   	push   %eax
80105f5c:	e8 1f db ff ff       	call   80103a80 <pipealloc>
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	85 c0                	test   %eax,%eax
80105f66:	78 37                	js     80105f9f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f68:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f6b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f6d:	e8 5e e1 ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105f78:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f7c:	85 f6                	test   %esi,%esi
80105f7e:	74 30                	je     80105fb0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105f80:	83 c3 01             	add    $0x1,%ebx
80105f83:	83 fb 10             	cmp    $0x10,%ebx
80105f86:	75 f0                	jne    80105f78 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f8e:	e8 6d af ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
80105f93:	58                   	pop    %eax
80105f94:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f97:	e8 64 af ff ff       	call   80100f00 <fileclose>
    return -1;
80105f9c:	83 c4 10             	add    $0x10,%esp
80105f9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa4:	eb 5b                	jmp    80106001 <sys_pipe+0xd1>
80105fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105fb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105fb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105fba:	e8 11 e1 ff ff       	call   801040d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105fbf:	31 d2                	xor    %edx,%edx
80105fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105fc8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105fcc:	85 c9                	test   %ecx,%ecx
80105fce:	74 20                	je     80105ff0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105fd0:	83 c2 01             	add    $0x1,%edx
80105fd3:	83 fa 10             	cmp    $0x10,%edx
80105fd6:	75 f0                	jne    80105fc8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105fd8:	e8 f3 e0 ff ff       	call   801040d0 <myproc>
80105fdd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fe4:	00 
80105fe5:	eb a1                	jmp    80105f88 <sys_pipe+0x58>
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ff0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ff7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ffc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105fff:	31 c0                	xor    %eax,%eax
}
80106001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106004:	5b                   	pop    %ebx
80106005:	5e                   	pop    %esi
80106006:	5f                   	pop    %edi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	66 90                	xchg   %ax,%ax
8010600b:	66 90                	xchg   %ax,%ax
8010600d:	66 90                	xchg   %ax,%ax
8010600f:	90                   	nop

80106010 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106010:	f3 0f 1e fb          	endbr32 
  return fork();
80106014:	e9 87 e2 ff ff       	jmp    801042a0 <fork>
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_exit>:
}

int
sys_exit(void)
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	83 ec 08             	sub    $0x8,%esp
  exit();
8010602a:	e8 f1 e5 ff ff       	call   80104620 <exit>
  return 0;  // not reached
}
8010602f:	31 c0                	xor    %eax,%eax
80106031:	c9                   	leave  
80106032:	c3                   	ret    
80106033:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106040 <sys_wait>:

int
sys_wait(void)
{
80106040:	f3 0f 1e fb          	endbr32 
  return wait();
80106044:	e9 57 e8 ff ff       	jmp    801048a0 <wait>
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_kill>:
}

int
sys_kill(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010605a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010605d:	50                   	push   %eax
8010605e:	6a 00                	push   $0x0
80106060:	e8 3b f2 ff ff       	call   801052a0 <argint>
80106065:	83 c4 10             	add    $0x10,%esp
80106068:	85 c0                	test   %eax,%eax
8010606a:	78 14                	js     80106080 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010606c:	83 ec 0c             	sub    $0xc,%esp
8010606f:	ff 75 f4             	pushl  -0xc(%ebp)
80106072:	e8 d9 e9 ff ff       	call   80104a50 <kill>
80106077:	83 c4 10             	add    $0x10,%esp
}
8010607a:	c9                   	leave  
8010607b:	c3                   	ret    
8010607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106080:	c9                   	leave  
    return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106086:	c3                   	ret    
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax

80106090 <sys_getpid>:

int
sys_getpid(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010609a:	e8 31 e0 ff ff       	call   801040d0 <myproc>
8010609f:	8b 40 10             	mov    0x10(%eax),%eax
}
801060a2:	c9                   	leave  
801060a3:	c3                   	ret    
801060a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060af:	90                   	nop

801060b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060bb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060be:	50                   	push   %eax
801060bf:	6a 00                	push   $0x0
801060c1:	e8 da f1 ff ff       	call   801052a0 <argint>
801060c6:	83 c4 10             	add    $0x10,%esp
801060c9:	85 c0                	test   %eax,%eax
801060cb:	78 23                	js     801060f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801060cd:	e8 fe df ff ff       	call   801040d0 <myproc>
  if(growproc(n) < 0)
801060d2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801060d5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801060d7:	ff 75 f4             	pushl  -0xc(%ebp)
801060da:	e8 21 e1 ff ff       	call   80104200 <growproc>
801060df:	83 c4 10             	add    $0x10,%esp
801060e2:	85 c0                	test   %eax,%eax
801060e4:	78 0a                	js     801060f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060e6:	89 d8                	mov    %ebx,%eax
801060e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060eb:	c9                   	leave  
801060ec:	c3                   	ret    
801060ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060f5:	eb ef                	jmp    801060e6 <sys_sbrk+0x36>
801060f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fe:	66 90                	xchg   %ax,%ax

80106100 <sys_sleep>:

int
sys_sleep(void)
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106108:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010610b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010610e:	50                   	push   %eax
8010610f:	6a 00                	push   $0x0
80106111:	e8 8a f1 ff ff       	call   801052a0 <argint>
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	85 c0                	test   %eax,%eax
8010611b:	0f 88 86 00 00 00    	js     801061a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106121:	83 ec 0c             	sub    $0xc,%esp
80106124:	68 a0 13 19 80       	push   $0x801913a0
80106129:	e8 82 ed ff ff       	call   80104eb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010612e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106131:	8b 1d e0 1b 19 80    	mov    0x80191be0,%ebx
  while(ticks - ticks0 < n){
80106137:	83 c4 10             	add    $0x10,%esp
8010613a:	85 d2                	test   %edx,%edx
8010613c:	75 23                	jne    80106161 <sys_sleep+0x61>
8010613e:	eb 50                	jmp    80106190 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106140:	83 ec 08             	sub    $0x8,%esp
80106143:	68 a0 13 19 80       	push   $0x801913a0
80106148:	68 e0 1b 19 80       	push   $0x80191be0
8010614d:	e8 8e e6 ff ff       	call   801047e0 <sleep>
  while(ticks - ticks0 < n){
80106152:	a1 e0 1b 19 80       	mov    0x80191be0,%eax
80106157:	83 c4 10             	add    $0x10,%esp
8010615a:	29 d8                	sub    %ebx,%eax
8010615c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010615f:	73 2f                	jae    80106190 <sys_sleep+0x90>
    if(myproc()->killed){
80106161:	e8 6a df ff ff       	call   801040d0 <myproc>
80106166:	8b 40 24             	mov    0x24(%eax),%eax
80106169:	85 c0                	test   %eax,%eax
8010616b:	74 d3                	je     80106140 <sys_sleep+0x40>
      release(&tickslock);
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	68 a0 13 19 80       	push   $0x801913a0
80106175:	e8 f6 ed ff ff       	call   80104f70 <release>
  }
  release(&tickslock);
  return 0;
}
8010617a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010617d:	83 c4 10             	add    $0x10,%esp
80106180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106185:	c9                   	leave  
80106186:	c3                   	ret    
80106187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	68 a0 13 19 80       	push   $0x801913a0
80106198:	e8 d3 ed ff ff       	call   80104f70 <release>
  return 0;
8010619d:	83 c4 10             	add    $0x10,%esp
801061a0:	31 c0                	xor    %eax,%eax
}
801061a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061a5:	c9                   	leave  
801061a6:	c3                   	ret    
    return -1;
801061a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ac:	eb f4                	jmp    801061a2 <sys_sleep+0xa2>
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061b0:	f3 0f 1e fb          	endbr32 
801061b4:	55                   	push   %ebp
801061b5:	89 e5                	mov    %esp,%ebp
801061b7:	53                   	push   %ebx
801061b8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801061bb:	68 a0 13 19 80       	push   $0x801913a0
801061c0:	e8 eb ec ff ff       	call   80104eb0 <acquire>
  xticks = ticks;
801061c5:	8b 1d e0 1b 19 80    	mov    0x80191be0,%ebx
  release(&tickslock);
801061cb:	c7 04 24 a0 13 19 80 	movl   $0x801913a0,(%esp)
801061d2:	e8 99 ed ff ff       	call   80104f70 <release>
  return xticks;
}
801061d7:	89 d8                	mov    %ebx,%eax
801061d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061dc:	c9                   	leave  
801061dd:	c3                   	ret    
801061de:	66 90                	xchg   %ax,%ax

801061e0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801061ea:	e8 e1 de ff ff       	call   801040d0 <myproc>
801061ef:	89 c2                	mov    %eax,%edx
801061f1:	b8 10 00 00 00       	mov    $0x10,%eax
801061f6:	2b 82 80 00 00 00    	sub    0x80(%edx),%eax
}
801061fc:	c9                   	leave  
801061fd:	c3                   	ret    
801061fe:	66 90                	xchg   %ax,%ax

80106200 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106200:	f3 0f 1e fb          	endbr32 
  return getTotalFreePages();
80106204:	e9 b7 e9 ff ff       	jmp    80104bc0 <getTotalFreePages>

80106209 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106209:	1e                   	push   %ds
  pushl %es
8010620a:	06                   	push   %es
  pushl %fs
8010620b:	0f a0                	push   %fs
  pushl %gs
8010620d:	0f a8                	push   %gs
  pushal
8010620f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106210:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106214:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106216:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106218:	54                   	push   %esp
  call trap
80106219:	e8 c2 00 00 00       	call   801062e0 <trap>
  addl $4, %esp
8010621e:	83 c4 04             	add    $0x4,%esp

80106221 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106221:	61                   	popa   
  popl %gs
80106222:	0f a9                	pop    %gs
  popl %fs
80106224:	0f a1                	pop    %fs
  popl %es
80106226:	07                   	pop    %es
  popl %ds
80106227:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106228:	83 c4 08             	add    $0x8,%esp
  iret
8010622b:	cf                   	iret   
8010622c:	66 90                	xchg   %ax,%ax
8010622e:	66 90                	xchg   %ax,%ax

80106230 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106235:	31 c0                	xor    %eax,%eax
{
80106237:	89 e5                	mov    %esp,%ebp
80106239:	83 ec 08             	sub    $0x8,%esp
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106240:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106247:	c7 04 c5 e2 13 19 80 	movl   $0x8e000008,-0x7fe6ec1e(,%eax,8)
8010624e:	08 00 00 8e 
80106252:	66 89 14 c5 e0 13 19 	mov    %dx,-0x7fe6ec20(,%eax,8)
80106259:	80 
8010625a:	c1 ea 10             	shr    $0x10,%edx
8010625d:	66 89 14 c5 e6 13 19 	mov    %dx,-0x7fe6ec1a(,%eax,8)
80106264:	80 
  for(i = 0; i < 256; i++)
80106265:	83 c0 01             	add    $0x1,%eax
80106268:	3d 00 01 00 00       	cmp    $0x100,%eax
8010626d:	75 d1                	jne    80106240 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010626f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106272:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106277:	c7 05 e2 15 19 80 08 	movl   $0xef000008,0x801915e2
8010627e:	00 00 ef 
  initlock(&tickslock, "time");
80106281:	68 bd 8b 10 80       	push   $0x80108bbd
80106286:	68 a0 13 19 80       	push   $0x801913a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010628b:	66 a3 e0 15 19 80    	mov    %ax,0x801915e0
80106291:	c1 e8 10             	shr    $0x10,%eax
80106294:	66 a3 e6 15 19 80    	mov    %ax,0x801915e6
  initlock(&tickslock, "time");
8010629a:	e8 91 ea ff ff       	call   80104d30 <initlock>
}
8010629f:	83 c4 10             	add    $0x10,%esp
801062a2:	c9                   	leave  
801062a3:	c3                   	ret    
801062a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062af:	90                   	nop

801062b0 <idtinit>:

void
idtinit(void)
{
801062b0:	f3 0f 1e fb          	endbr32 
801062b4:	55                   	push   %ebp
  pd[0] = size-1;
801062b5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062ba:	89 e5                	mov    %esp,%ebp
801062bc:	83 ec 10             	sub    $0x10,%esp
801062bf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062c3:	b8 e0 13 19 80       	mov    $0x801913e0,%eax
801062c8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062cc:	c1 e8 10             	shr    $0x10,%eax
801062cf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062d3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062d6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062d9:	c9                   	leave  
801062da:	c3                   	ret    
801062db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062df:	90                   	nop

801062e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062e0:	f3 0f 1e fb          	endbr32 
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	57                   	push   %edi
801062e8:	56                   	push   %esi
801062e9:	53                   	push   %ebx
801062ea:	83 ec 1c             	sub    $0x1c,%esp
801062ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("at trap");
  struct proc* curproc = myproc();
801062f0:	e8 db dd ff ff       	call   801040d0 <myproc>
801062f5:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
801062f7:	8b 43 30             	mov    0x30(%ebx),%eax
801062fa:	83 f8 40             	cmp    $0x40,%eax
801062fd:	0f 84 ed 00 00 00    	je     801063f0 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106303:	83 e8 0e             	sub    $0xe,%eax
80106306:	83 f8 31             	cmp    $0x31,%eax
80106309:	77 08                	ja     80106313 <trap+0x33>
8010630b:	3e ff 24 85 64 8c 10 	notrack jmp *-0x7fef739c(,%eax,4)
80106312:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106313:	e8 b8 dd ff ff       	call   801040d0 <myproc>
80106318:	85 c0                	test   %eax,%eax
8010631a:	0f 84 e2 01 00 00    	je     80106502 <trap+0x222>
80106320:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106324:	0f 84 d8 01 00 00    	je     80106502 <trap+0x222>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010632a:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010632d:	8b 53 38             	mov    0x38(%ebx),%edx
80106330:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106333:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106336:	e8 75 dd ff ff       	call   801040b0 <cpuid>
8010633b:	8b 73 30             	mov    0x30(%ebx),%esi
8010633e:	89 c7                	mov    %eax,%edi
80106340:	8b 43 34             	mov    0x34(%ebx),%eax
80106343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106346:	e8 85 dd ff ff       	call   801040d0 <myproc>
8010634b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010634e:	e8 7d dd ff ff       	call   801040d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106353:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106356:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106359:	51                   	push   %ecx
8010635a:	52                   	push   %edx
8010635b:	57                   	push   %edi
8010635c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010635f:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106360:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106363:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106366:	56                   	push   %esi
80106367:	ff 70 10             	pushl  0x10(%eax)
8010636a:	68 20 8c 10 80       	push   $0x80108c20
8010636f:	e8 3c a3 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106374:	83 c4 20             	add    $0x20,%esp
80106377:	e8 54 dd ff ff       	call   801040d0 <myproc>
8010637c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106383:	e8 48 dd ff ff       	call   801040d0 <myproc>
80106388:	85 c0                	test   %eax,%eax
8010638a:	74 1d                	je     801063a9 <trap+0xc9>
8010638c:	e8 3f dd ff ff       	call   801040d0 <myproc>
80106391:	8b 50 24             	mov    0x24(%eax),%edx
80106394:	85 d2                	test   %edx,%edx
80106396:	74 11                	je     801063a9 <trap+0xc9>
80106398:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010639c:	83 e0 03             	and    $0x3,%eax
8010639f:	66 83 f8 03          	cmp    $0x3,%ax
801063a3:	0f 84 4f 01 00 00    	je     801064f8 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063a9:	e8 22 dd ff ff       	call   801040d0 <myproc>
801063ae:	85 c0                	test   %eax,%eax
801063b0:	74 0f                	je     801063c1 <trap+0xe1>
801063b2:	e8 19 dd ff ff       	call   801040d0 <myproc>
801063b7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063bb:	0f 84 0f 01 00 00    	je     801064d0 <trap+0x1f0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c1:	e8 0a dd ff ff       	call   801040d0 <myproc>
801063c6:	85 c0                	test   %eax,%eax
801063c8:	74 19                	je     801063e3 <trap+0x103>
801063ca:	e8 01 dd ff ff       	call   801040d0 <myproc>
801063cf:	8b 40 24             	mov    0x24(%eax),%eax
801063d2:	85 c0                	test   %eax,%eax
801063d4:	74 0d                	je     801063e3 <trap+0x103>
801063d6:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063da:	83 e0 03             	and    $0x3,%eax
801063dd:	66 83 f8 03          	cmp    $0x3,%ax
801063e1:	74 2c                	je     8010640f <trap+0x12f>
    exit();
}
801063e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e6:	5b                   	pop    %ebx
801063e7:	5e                   	pop    %esi
801063e8:	5f                   	pop    %edi
801063e9:	5d                   	pop    %ebp
801063ea:	c3                   	ret    
801063eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop
    if(curproc->killed)
801063f0:	8b 7e 24             	mov    0x24(%esi),%edi
801063f3:	85 ff                	test   %edi,%edi
801063f5:	0f 85 ed 00 00 00    	jne    801064e8 <trap+0x208>
    curproc->tf = tf;
801063fb:	89 5e 18             	mov    %ebx,0x18(%esi)
    syscall();
801063fe:	e8 8d ef ff ff       	call   80105390 <syscall>
    if(myproc()->killed)
80106403:	e8 c8 dc ff ff       	call   801040d0 <myproc>
80106408:	8b 48 24             	mov    0x24(%eax),%ecx
8010640b:	85 c9                	test   %ecx,%ecx
8010640d:	74 d4                	je     801063e3 <trap+0x103>
}
8010640f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106412:	5b                   	pop    %ebx
80106413:	5e                   	pop    %esi
80106414:	5f                   	pop    %edi
80106415:	5d                   	pop    %ebp
      exit();
80106416:	e9 05 e2 ff ff       	jmp    80104620 <exit>
    ideintr();
8010641b:	e8 80 c1 ff ff       	call   801025a0 <ideintr>
    lapiceoi();
80106420:	e8 eb ca ff ff       	call   80102f10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106425:	e8 a6 dc ff ff       	call   801040d0 <myproc>
8010642a:	85 c0                	test   %eax,%eax
8010642c:	0f 85 5a ff ff ff    	jne    8010638c <trap+0xac>
80106432:	e9 72 ff ff ff       	jmp    801063a9 <trap+0xc9>
    if(myproc()->pid > 2) 
80106437:	e8 94 dc ff ff       	call   801040d0 <myproc>
8010643c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106440:	0f 8e 3d ff ff ff    	jle    80106383 <trap+0xa3>
    pagefault();
80106446:	e8 e5 18 00 00       	call   80107d30 <pagefault>
8010644b:	e9 33 ff ff ff       	jmp    80106383 <trap+0xa3>
    if(cpuid() == 0){
80106450:	e8 5b dc ff ff       	call   801040b0 <cpuid>
80106455:	85 c0                	test   %eax,%eax
80106457:	75 c7                	jne    80106420 <trap+0x140>
      acquire(&tickslock);
80106459:	83 ec 0c             	sub    $0xc,%esp
8010645c:	68 a0 13 19 80       	push   $0x801913a0
80106461:	e8 4a ea ff ff       	call   80104eb0 <acquire>
      wakeup(&ticks);
80106466:	c7 04 24 e0 1b 19 80 	movl   $0x80191be0,(%esp)
      ticks++;
8010646d:	83 05 e0 1b 19 80 01 	addl   $0x1,0x80191be0
      wakeup(&ticks);
80106474:	e8 67 e5 ff ff       	call   801049e0 <wakeup>
      release(&tickslock);
80106479:	c7 04 24 a0 13 19 80 	movl   $0x801913a0,(%esp)
80106480:	e8 eb ea ff ff       	call   80104f70 <release>
80106485:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106488:	eb 96                	jmp    80106420 <trap+0x140>
    kbdintr();
8010648a:	e8 41 c9 ff ff       	call   80102dd0 <kbdintr>
    lapiceoi();
8010648f:	e8 7c ca ff ff       	call   80102f10 <lapiceoi>
    break;
80106494:	e9 ea fe ff ff       	jmp    80106383 <trap+0xa3>
    uartintr();
80106499:	e8 02 02 00 00       	call   801066a0 <uartintr>
    lapiceoi();
8010649e:	e8 6d ca ff ff       	call   80102f10 <lapiceoi>
    break;
801064a3:	e9 db fe ff ff       	jmp    80106383 <trap+0xa3>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064a8:	8b 7b 38             	mov    0x38(%ebx),%edi
801064ab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064af:	e8 fc db ff ff       	call   801040b0 <cpuid>
801064b4:	57                   	push   %edi
801064b5:	56                   	push   %esi
801064b6:	50                   	push   %eax
801064b7:	68 c8 8b 10 80       	push   $0x80108bc8
801064bc:	e8 ef a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064c1:	e8 4a ca ff ff       	call   80102f10 <lapiceoi>
    break;
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	e9 b5 fe ff ff       	jmp    80106383 <trap+0xa3>
801064ce:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
801064d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801064d4:	0f 85 e7 fe ff ff    	jne    801063c1 <trap+0xe1>
    yield();
801064da:	e8 b1 e2 ff ff       	call   80104790 <yield>
801064df:	e9 dd fe ff ff       	jmp    801063c1 <trap+0xe1>
801064e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
801064e8:	e8 33 e1 ff ff       	call   80104620 <exit>
801064ed:	e9 09 ff ff ff       	jmp    801063fb <trap+0x11b>
801064f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801064f8:	e8 23 e1 ff ff       	call   80104620 <exit>
801064fd:	e9 a7 fe ff ff       	jmp    801063a9 <trap+0xc9>
80106502:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106505:	8b 73 38             	mov    0x38(%ebx),%esi
80106508:	e8 a3 db ff ff       	call   801040b0 <cpuid>
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	57                   	push   %edi
80106511:	56                   	push   %esi
80106512:	50                   	push   %eax
80106513:	ff 73 30             	pushl  0x30(%ebx)
80106516:	68 ec 8b 10 80       	push   $0x80108bec
8010651b:	e8 90 a1 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106520:	83 c4 14             	add    $0x14,%esp
80106523:	68 c2 8b 10 80       	push   $0x80108bc2
80106528:	e8 63 9e ff ff       	call   80100390 <panic>
8010652d:	66 90                	xchg   %ax,%ax
8010652f:	90                   	nop

80106530 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106530:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106534:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
80106539:	85 c0                	test   %eax,%eax
8010653b:	74 1b                	je     80106558 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010653d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106542:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106543:	a8 01                	test   $0x1,%al
80106545:	74 11                	je     80106558 <uartgetc+0x28>
80106547:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010654d:	0f b6 c0             	movzbl %al,%eax
80106550:	c3                   	ret    
80106551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010655d:	c3                   	ret    
8010655e:	66 90                	xchg   %ax,%ax

80106560 <uartputc.part.0>:
uartputc(int c)
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	89 c7                	mov    %eax,%edi
80106566:	56                   	push   %esi
80106567:	be fd 03 00 00       	mov    $0x3fd,%esi
8010656c:	53                   	push   %ebx
8010656d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106572:	83 ec 0c             	sub    $0xc,%esp
80106575:	eb 1b                	jmp    80106592 <uartputc.part.0+0x32>
80106577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106580:	83 ec 0c             	sub    $0xc,%esp
80106583:	6a 0a                	push   $0xa
80106585:	e8 a6 c9 ff ff       	call   80102f30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	83 eb 01             	sub    $0x1,%ebx
80106590:	74 07                	je     80106599 <uartputc.part.0+0x39>
80106592:	89 f2                	mov    %esi,%edx
80106594:	ec                   	in     (%dx),%al
80106595:	a8 20                	test   $0x20,%al
80106597:	74 e7                	je     80106580 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106599:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010659e:	89 f8                	mov    %edi,%eax
801065a0:	ee                   	out    %al,(%dx)
}
801065a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a4:	5b                   	pop    %ebx
801065a5:	5e                   	pop    %esi
801065a6:	5f                   	pop    %edi
801065a7:	5d                   	pop    %ebp
801065a8:	c3                   	ret    
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065b0 <uartinit>:
{
801065b0:	f3 0f 1e fb          	endbr32 
801065b4:	55                   	push   %ebp
801065b5:	31 c9                	xor    %ecx,%ecx
801065b7:	89 c8                	mov    %ecx,%eax
801065b9:	89 e5                	mov    %esp,%ebp
801065bb:	57                   	push   %edi
801065bc:	56                   	push   %esi
801065bd:	53                   	push   %ebx
801065be:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065c3:	89 da                	mov    %ebx,%edx
801065c5:	83 ec 0c             	sub    $0xc,%esp
801065c8:	ee                   	out    %al,(%dx)
801065c9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065ce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065d3:	89 fa                	mov    %edi,%edx
801065d5:	ee                   	out    %al,(%dx)
801065d6:	b8 0c 00 00 00       	mov    $0xc,%eax
801065db:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065e0:	ee                   	out    %al,(%dx)
801065e1:	be f9 03 00 00       	mov    $0x3f9,%esi
801065e6:	89 c8                	mov    %ecx,%eax
801065e8:	89 f2                	mov    %esi,%edx
801065ea:	ee                   	out    %al,(%dx)
801065eb:	b8 03 00 00 00       	mov    $0x3,%eax
801065f0:	89 fa                	mov    %edi,%edx
801065f2:	ee                   	out    %al,(%dx)
801065f3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065f8:	89 c8                	mov    %ecx,%eax
801065fa:	ee                   	out    %al,(%dx)
801065fb:	b8 01 00 00 00       	mov    $0x1,%eax
80106600:	89 f2                	mov    %esi,%edx
80106602:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106603:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106608:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106609:	3c ff                	cmp    $0xff,%al
8010660b:	74 52                	je     8010665f <uartinit+0xaf>
  uart = 1;
8010660d:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
80106614:	00 00 00 
80106617:	89 da                	mov    %ebx,%edx
80106619:	ec                   	in     (%dx),%al
8010661a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010661f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106620:	83 ec 08             	sub    $0x8,%esp
80106623:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106628:	bb 2c 8d 10 80       	mov    $0x80108d2c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010662d:	6a 00                	push   $0x0
8010662f:	6a 04                	push   $0x4
80106631:	e8 ba c1 ff ff       	call   801027f0 <ioapicenable>
80106636:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106639:	b8 78 00 00 00       	mov    $0x78,%eax
8010663e:	eb 04                	jmp    80106644 <uartinit+0x94>
80106640:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106644:	8b 15 e0 d5 10 80    	mov    0x8010d5e0,%edx
8010664a:	85 d2                	test   %edx,%edx
8010664c:	74 08                	je     80106656 <uartinit+0xa6>
    uartputc(*p);
8010664e:	0f be c0             	movsbl %al,%eax
80106651:	e8 0a ff ff ff       	call   80106560 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106656:	89 f0                	mov    %esi,%eax
80106658:	83 c3 01             	add    $0x1,%ebx
8010665b:	84 c0                	test   %al,%al
8010665d:	75 e1                	jne    80106640 <uartinit+0x90>
}
8010665f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106662:	5b                   	pop    %ebx
80106663:	5e                   	pop    %esi
80106664:	5f                   	pop    %edi
80106665:	5d                   	pop    %ebp
80106666:	c3                   	ret    
80106667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666e:	66 90                	xchg   %ax,%ax

80106670 <uartputc>:
{
80106670:	f3 0f 1e fb          	endbr32 
80106674:	55                   	push   %ebp
  if(!uart)
80106675:	8b 15 e0 d5 10 80    	mov    0x8010d5e0,%edx
{
8010667b:	89 e5                	mov    %esp,%ebp
8010667d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106680:	85 d2                	test   %edx,%edx
80106682:	74 0c                	je     80106690 <uartputc+0x20>
}
80106684:	5d                   	pop    %ebp
80106685:	e9 d6 fe ff ff       	jmp    80106560 <uartputc.part.0>
8010668a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106690:	5d                   	pop    %ebp
80106691:	c3                   	ret    
80106692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066a0 <uartintr>:

void
uartintr(void)
{
801066a0:	f3 0f 1e fb          	endbr32 
801066a4:	55                   	push   %ebp
801066a5:	89 e5                	mov    %esp,%ebp
801066a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066aa:	68 30 65 10 80       	push   $0x80106530
801066af:	e8 ac a1 ff ff       	call   80100860 <consoleintr>
}
801066b4:	83 c4 10             	add    $0x10,%esp
801066b7:	c9                   	leave  
801066b8:	c3                   	ret    

801066b9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $0
801066bb:	6a 00                	push   $0x0
  jmp alltraps
801066bd:	e9 47 fb ff ff       	jmp    80106209 <alltraps>

801066c2 <vector1>:
.globl vector1
vector1:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $1
801066c4:	6a 01                	push   $0x1
  jmp alltraps
801066c6:	e9 3e fb ff ff       	jmp    80106209 <alltraps>

801066cb <vector2>:
.globl vector2
vector2:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $2
801066cd:	6a 02                	push   $0x2
  jmp alltraps
801066cf:	e9 35 fb ff ff       	jmp    80106209 <alltraps>

801066d4 <vector3>:
.globl vector3
vector3:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $3
801066d6:	6a 03                	push   $0x3
  jmp alltraps
801066d8:	e9 2c fb ff ff       	jmp    80106209 <alltraps>

801066dd <vector4>:
.globl vector4
vector4:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $4
801066df:	6a 04                	push   $0x4
  jmp alltraps
801066e1:	e9 23 fb ff ff       	jmp    80106209 <alltraps>

801066e6 <vector5>:
.globl vector5
vector5:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $5
801066e8:	6a 05                	push   $0x5
  jmp alltraps
801066ea:	e9 1a fb ff ff       	jmp    80106209 <alltraps>

801066ef <vector6>:
.globl vector6
vector6:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $6
801066f1:	6a 06                	push   $0x6
  jmp alltraps
801066f3:	e9 11 fb ff ff       	jmp    80106209 <alltraps>

801066f8 <vector7>:
.globl vector7
vector7:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $7
801066fa:	6a 07                	push   $0x7
  jmp alltraps
801066fc:	e9 08 fb ff ff       	jmp    80106209 <alltraps>

80106701 <vector8>:
.globl vector8
vector8:
  pushl $8
80106701:	6a 08                	push   $0x8
  jmp alltraps
80106703:	e9 01 fb ff ff       	jmp    80106209 <alltraps>

80106708 <vector9>:
.globl vector9
vector9:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $9
8010670a:	6a 09                	push   $0x9
  jmp alltraps
8010670c:	e9 f8 fa ff ff       	jmp    80106209 <alltraps>

80106711 <vector10>:
.globl vector10
vector10:
  pushl $10
80106711:	6a 0a                	push   $0xa
  jmp alltraps
80106713:	e9 f1 fa ff ff       	jmp    80106209 <alltraps>

80106718 <vector11>:
.globl vector11
vector11:
  pushl $11
80106718:	6a 0b                	push   $0xb
  jmp alltraps
8010671a:	e9 ea fa ff ff       	jmp    80106209 <alltraps>

8010671f <vector12>:
.globl vector12
vector12:
  pushl $12
8010671f:	6a 0c                	push   $0xc
  jmp alltraps
80106721:	e9 e3 fa ff ff       	jmp    80106209 <alltraps>

80106726 <vector13>:
.globl vector13
vector13:
  pushl $13
80106726:	6a 0d                	push   $0xd
  jmp alltraps
80106728:	e9 dc fa ff ff       	jmp    80106209 <alltraps>

8010672d <vector14>:
.globl vector14
vector14:
  pushl $14
8010672d:	6a 0e                	push   $0xe
  jmp alltraps
8010672f:	e9 d5 fa ff ff       	jmp    80106209 <alltraps>

80106734 <vector15>:
.globl vector15
vector15:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $15
80106736:	6a 0f                	push   $0xf
  jmp alltraps
80106738:	e9 cc fa ff ff       	jmp    80106209 <alltraps>

8010673d <vector16>:
.globl vector16
vector16:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $16
8010673f:	6a 10                	push   $0x10
  jmp alltraps
80106741:	e9 c3 fa ff ff       	jmp    80106209 <alltraps>

80106746 <vector17>:
.globl vector17
vector17:
  pushl $17
80106746:	6a 11                	push   $0x11
  jmp alltraps
80106748:	e9 bc fa ff ff       	jmp    80106209 <alltraps>

8010674d <vector18>:
.globl vector18
vector18:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $18
8010674f:	6a 12                	push   $0x12
  jmp alltraps
80106751:	e9 b3 fa ff ff       	jmp    80106209 <alltraps>

80106756 <vector19>:
.globl vector19
vector19:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $19
80106758:	6a 13                	push   $0x13
  jmp alltraps
8010675a:	e9 aa fa ff ff       	jmp    80106209 <alltraps>

8010675f <vector20>:
.globl vector20
vector20:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $20
80106761:	6a 14                	push   $0x14
  jmp alltraps
80106763:	e9 a1 fa ff ff       	jmp    80106209 <alltraps>

80106768 <vector21>:
.globl vector21
vector21:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $21
8010676a:	6a 15                	push   $0x15
  jmp alltraps
8010676c:	e9 98 fa ff ff       	jmp    80106209 <alltraps>

80106771 <vector22>:
.globl vector22
vector22:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $22
80106773:	6a 16                	push   $0x16
  jmp alltraps
80106775:	e9 8f fa ff ff       	jmp    80106209 <alltraps>

8010677a <vector23>:
.globl vector23
vector23:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $23
8010677c:	6a 17                	push   $0x17
  jmp alltraps
8010677e:	e9 86 fa ff ff       	jmp    80106209 <alltraps>

80106783 <vector24>:
.globl vector24
vector24:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $24
80106785:	6a 18                	push   $0x18
  jmp alltraps
80106787:	e9 7d fa ff ff       	jmp    80106209 <alltraps>

8010678c <vector25>:
.globl vector25
vector25:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $25
8010678e:	6a 19                	push   $0x19
  jmp alltraps
80106790:	e9 74 fa ff ff       	jmp    80106209 <alltraps>

80106795 <vector26>:
.globl vector26
vector26:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $26
80106797:	6a 1a                	push   $0x1a
  jmp alltraps
80106799:	e9 6b fa ff ff       	jmp    80106209 <alltraps>

8010679e <vector27>:
.globl vector27
vector27:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $27
801067a0:	6a 1b                	push   $0x1b
  jmp alltraps
801067a2:	e9 62 fa ff ff       	jmp    80106209 <alltraps>

801067a7 <vector28>:
.globl vector28
vector28:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $28
801067a9:	6a 1c                	push   $0x1c
  jmp alltraps
801067ab:	e9 59 fa ff ff       	jmp    80106209 <alltraps>

801067b0 <vector29>:
.globl vector29
vector29:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $29
801067b2:	6a 1d                	push   $0x1d
  jmp alltraps
801067b4:	e9 50 fa ff ff       	jmp    80106209 <alltraps>

801067b9 <vector30>:
.globl vector30
vector30:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $30
801067bb:	6a 1e                	push   $0x1e
  jmp alltraps
801067bd:	e9 47 fa ff ff       	jmp    80106209 <alltraps>

801067c2 <vector31>:
.globl vector31
vector31:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $31
801067c4:	6a 1f                	push   $0x1f
  jmp alltraps
801067c6:	e9 3e fa ff ff       	jmp    80106209 <alltraps>

801067cb <vector32>:
.globl vector32
vector32:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $32
801067cd:	6a 20                	push   $0x20
  jmp alltraps
801067cf:	e9 35 fa ff ff       	jmp    80106209 <alltraps>

801067d4 <vector33>:
.globl vector33
vector33:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $33
801067d6:	6a 21                	push   $0x21
  jmp alltraps
801067d8:	e9 2c fa ff ff       	jmp    80106209 <alltraps>

801067dd <vector34>:
.globl vector34
vector34:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $34
801067df:	6a 22                	push   $0x22
  jmp alltraps
801067e1:	e9 23 fa ff ff       	jmp    80106209 <alltraps>

801067e6 <vector35>:
.globl vector35
vector35:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $35
801067e8:	6a 23                	push   $0x23
  jmp alltraps
801067ea:	e9 1a fa ff ff       	jmp    80106209 <alltraps>

801067ef <vector36>:
.globl vector36
vector36:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $36
801067f1:	6a 24                	push   $0x24
  jmp alltraps
801067f3:	e9 11 fa ff ff       	jmp    80106209 <alltraps>

801067f8 <vector37>:
.globl vector37
vector37:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $37
801067fa:	6a 25                	push   $0x25
  jmp alltraps
801067fc:	e9 08 fa ff ff       	jmp    80106209 <alltraps>

80106801 <vector38>:
.globl vector38
vector38:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $38
80106803:	6a 26                	push   $0x26
  jmp alltraps
80106805:	e9 ff f9 ff ff       	jmp    80106209 <alltraps>

8010680a <vector39>:
.globl vector39
vector39:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $39
8010680c:	6a 27                	push   $0x27
  jmp alltraps
8010680e:	e9 f6 f9 ff ff       	jmp    80106209 <alltraps>

80106813 <vector40>:
.globl vector40
vector40:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $40
80106815:	6a 28                	push   $0x28
  jmp alltraps
80106817:	e9 ed f9 ff ff       	jmp    80106209 <alltraps>

8010681c <vector41>:
.globl vector41
vector41:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $41
8010681e:	6a 29                	push   $0x29
  jmp alltraps
80106820:	e9 e4 f9 ff ff       	jmp    80106209 <alltraps>

80106825 <vector42>:
.globl vector42
vector42:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $42
80106827:	6a 2a                	push   $0x2a
  jmp alltraps
80106829:	e9 db f9 ff ff       	jmp    80106209 <alltraps>

8010682e <vector43>:
.globl vector43
vector43:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $43
80106830:	6a 2b                	push   $0x2b
  jmp alltraps
80106832:	e9 d2 f9 ff ff       	jmp    80106209 <alltraps>

80106837 <vector44>:
.globl vector44
vector44:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $44
80106839:	6a 2c                	push   $0x2c
  jmp alltraps
8010683b:	e9 c9 f9 ff ff       	jmp    80106209 <alltraps>

80106840 <vector45>:
.globl vector45
vector45:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $45
80106842:	6a 2d                	push   $0x2d
  jmp alltraps
80106844:	e9 c0 f9 ff ff       	jmp    80106209 <alltraps>

80106849 <vector46>:
.globl vector46
vector46:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $46
8010684b:	6a 2e                	push   $0x2e
  jmp alltraps
8010684d:	e9 b7 f9 ff ff       	jmp    80106209 <alltraps>

80106852 <vector47>:
.globl vector47
vector47:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $47
80106854:	6a 2f                	push   $0x2f
  jmp alltraps
80106856:	e9 ae f9 ff ff       	jmp    80106209 <alltraps>

8010685b <vector48>:
.globl vector48
vector48:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $48
8010685d:	6a 30                	push   $0x30
  jmp alltraps
8010685f:	e9 a5 f9 ff ff       	jmp    80106209 <alltraps>

80106864 <vector49>:
.globl vector49
vector49:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $49
80106866:	6a 31                	push   $0x31
  jmp alltraps
80106868:	e9 9c f9 ff ff       	jmp    80106209 <alltraps>

8010686d <vector50>:
.globl vector50
vector50:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $50
8010686f:	6a 32                	push   $0x32
  jmp alltraps
80106871:	e9 93 f9 ff ff       	jmp    80106209 <alltraps>

80106876 <vector51>:
.globl vector51
vector51:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $51
80106878:	6a 33                	push   $0x33
  jmp alltraps
8010687a:	e9 8a f9 ff ff       	jmp    80106209 <alltraps>

8010687f <vector52>:
.globl vector52
vector52:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $52
80106881:	6a 34                	push   $0x34
  jmp alltraps
80106883:	e9 81 f9 ff ff       	jmp    80106209 <alltraps>

80106888 <vector53>:
.globl vector53
vector53:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $53
8010688a:	6a 35                	push   $0x35
  jmp alltraps
8010688c:	e9 78 f9 ff ff       	jmp    80106209 <alltraps>

80106891 <vector54>:
.globl vector54
vector54:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $54
80106893:	6a 36                	push   $0x36
  jmp alltraps
80106895:	e9 6f f9 ff ff       	jmp    80106209 <alltraps>

8010689a <vector55>:
.globl vector55
vector55:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $55
8010689c:	6a 37                	push   $0x37
  jmp alltraps
8010689e:	e9 66 f9 ff ff       	jmp    80106209 <alltraps>

801068a3 <vector56>:
.globl vector56
vector56:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $56
801068a5:	6a 38                	push   $0x38
  jmp alltraps
801068a7:	e9 5d f9 ff ff       	jmp    80106209 <alltraps>

801068ac <vector57>:
.globl vector57
vector57:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $57
801068ae:	6a 39                	push   $0x39
  jmp alltraps
801068b0:	e9 54 f9 ff ff       	jmp    80106209 <alltraps>

801068b5 <vector58>:
.globl vector58
vector58:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $58
801068b7:	6a 3a                	push   $0x3a
  jmp alltraps
801068b9:	e9 4b f9 ff ff       	jmp    80106209 <alltraps>

801068be <vector59>:
.globl vector59
vector59:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $59
801068c0:	6a 3b                	push   $0x3b
  jmp alltraps
801068c2:	e9 42 f9 ff ff       	jmp    80106209 <alltraps>

801068c7 <vector60>:
.globl vector60
vector60:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $60
801068c9:	6a 3c                	push   $0x3c
  jmp alltraps
801068cb:	e9 39 f9 ff ff       	jmp    80106209 <alltraps>

801068d0 <vector61>:
.globl vector61
vector61:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $61
801068d2:	6a 3d                	push   $0x3d
  jmp alltraps
801068d4:	e9 30 f9 ff ff       	jmp    80106209 <alltraps>

801068d9 <vector62>:
.globl vector62
vector62:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $62
801068db:	6a 3e                	push   $0x3e
  jmp alltraps
801068dd:	e9 27 f9 ff ff       	jmp    80106209 <alltraps>

801068e2 <vector63>:
.globl vector63
vector63:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $63
801068e4:	6a 3f                	push   $0x3f
  jmp alltraps
801068e6:	e9 1e f9 ff ff       	jmp    80106209 <alltraps>

801068eb <vector64>:
.globl vector64
vector64:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $64
801068ed:	6a 40                	push   $0x40
  jmp alltraps
801068ef:	e9 15 f9 ff ff       	jmp    80106209 <alltraps>

801068f4 <vector65>:
.globl vector65
vector65:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $65
801068f6:	6a 41                	push   $0x41
  jmp alltraps
801068f8:	e9 0c f9 ff ff       	jmp    80106209 <alltraps>

801068fd <vector66>:
.globl vector66
vector66:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $66
801068ff:	6a 42                	push   $0x42
  jmp alltraps
80106901:	e9 03 f9 ff ff       	jmp    80106209 <alltraps>

80106906 <vector67>:
.globl vector67
vector67:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $67
80106908:	6a 43                	push   $0x43
  jmp alltraps
8010690a:	e9 fa f8 ff ff       	jmp    80106209 <alltraps>

8010690f <vector68>:
.globl vector68
vector68:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $68
80106911:	6a 44                	push   $0x44
  jmp alltraps
80106913:	e9 f1 f8 ff ff       	jmp    80106209 <alltraps>

80106918 <vector69>:
.globl vector69
vector69:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $69
8010691a:	6a 45                	push   $0x45
  jmp alltraps
8010691c:	e9 e8 f8 ff ff       	jmp    80106209 <alltraps>

80106921 <vector70>:
.globl vector70
vector70:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $70
80106923:	6a 46                	push   $0x46
  jmp alltraps
80106925:	e9 df f8 ff ff       	jmp    80106209 <alltraps>

8010692a <vector71>:
.globl vector71
vector71:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $71
8010692c:	6a 47                	push   $0x47
  jmp alltraps
8010692e:	e9 d6 f8 ff ff       	jmp    80106209 <alltraps>

80106933 <vector72>:
.globl vector72
vector72:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $72
80106935:	6a 48                	push   $0x48
  jmp alltraps
80106937:	e9 cd f8 ff ff       	jmp    80106209 <alltraps>

8010693c <vector73>:
.globl vector73
vector73:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $73
8010693e:	6a 49                	push   $0x49
  jmp alltraps
80106940:	e9 c4 f8 ff ff       	jmp    80106209 <alltraps>

80106945 <vector74>:
.globl vector74
vector74:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $74
80106947:	6a 4a                	push   $0x4a
  jmp alltraps
80106949:	e9 bb f8 ff ff       	jmp    80106209 <alltraps>

8010694e <vector75>:
.globl vector75
vector75:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $75
80106950:	6a 4b                	push   $0x4b
  jmp alltraps
80106952:	e9 b2 f8 ff ff       	jmp    80106209 <alltraps>

80106957 <vector76>:
.globl vector76
vector76:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $76
80106959:	6a 4c                	push   $0x4c
  jmp alltraps
8010695b:	e9 a9 f8 ff ff       	jmp    80106209 <alltraps>

80106960 <vector77>:
.globl vector77
vector77:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $77
80106962:	6a 4d                	push   $0x4d
  jmp alltraps
80106964:	e9 a0 f8 ff ff       	jmp    80106209 <alltraps>

80106969 <vector78>:
.globl vector78
vector78:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $78
8010696b:	6a 4e                	push   $0x4e
  jmp alltraps
8010696d:	e9 97 f8 ff ff       	jmp    80106209 <alltraps>

80106972 <vector79>:
.globl vector79
vector79:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $79
80106974:	6a 4f                	push   $0x4f
  jmp alltraps
80106976:	e9 8e f8 ff ff       	jmp    80106209 <alltraps>

8010697b <vector80>:
.globl vector80
vector80:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $80
8010697d:	6a 50                	push   $0x50
  jmp alltraps
8010697f:	e9 85 f8 ff ff       	jmp    80106209 <alltraps>

80106984 <vector81>:
.globl vector81
vector81:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $81
80106986:	6a 51                	push   $0x51
  jmp alltraps
80106988:	e9 7c f8 ff ff       	jmp    80106209 <alltraps>

8010698d <vector82>:
.globl vector82
vector82:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $82
8010698f:	6a 52                	push   $0x52
  jmp alltraps
80106991:	e9 73 f8 ff ff       	jmp    80106209 <alltraps>

80106996 <vector83>:
.globl vector83
vector83:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $83
80106998:	6a 53                	push   $0x53
  jmp alltraps
8010699a:	e9 6a f8 ff ff       	jmp    80106209 <alltraps>

8010699f <vector84>:
.globl vector84
vector84:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $84
801069a1:	6a 54                	push   $0x54
  jmp alltraps
801069a3:	e9 61 f8 ff ff       	jmp    80106209 <alltraps>

801069a8 <vector85>:
.globl vector85
vector85:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $85
801069aa:	6a 55                	push   $0x55
  jmp alltraps
801069ac:	e9 58 f8 ff ff       	jmp    80106209 <alltraps>

801069b1 <vector86>:
.globl vector86
vector86:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $86
801069b3:	6a 56                	push   $0x56
  jmp alltraps
801069b5:	e9 4f f8 ff ff       	jmp    80106209 <alltraps>

801069ba <vector87>:
.globl vector87
vector87:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $87
801069bc:	6a 57                	push   $0x57
  jmp alltraps
801069be:	e9 46 f8 ff ff       	jmp    80106209 <alltraps>

801069c3 <vector88>:
.globl vector88
vector88:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $88
801069c5:	6a 58                	push   $0x58
  jmp alltraps
801069c7:	e9 3d f8 ff ff       	jmp    80106209 <alltraps>

801069cc <vector89>:
.globl vector89
vector89:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $89
801069ce:	6a 59                	push   $0x59
  jmp alltraps
801069d0:	e9 34 f8 ff ff       	jmp    80106209 <alltraps>

801069d5 <vector90>:
.globl vector90
vector90:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $90
801069d7:	6a 5a                	push   $0x5a
  jmp alltraps
801069d9:	e9 2b f8 ff ff       	jmp    80106209 <alltraps>

801069de <vector91>:
.globl vector91
vector91:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $91
801069e0:	6a 5b                	push   $0x5b
  jmp alltraps
801069e2:	e9 22 f8 ff ff       	jmp    80106209 <alltraps>

801069e7 <vector92>:
.globl vector92
vector92:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $92
801069e9:	6a 5c                	push   $0x5c
  jmp alltraps
801069eb:	e9 19 f8 ff ff       	jmp    80106209 <alltraps>

801069f0 <vector93>:
.globl vector93
vector93:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $93
801069f2:	6a 5d                	push   $0x5d
  jmp alltraps
801069f4:	e9 10 f8 ff ff       	jmp    80106209 <alltraps>

801069f9 <vector94>:
.globl vector94
vector94:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $94
801069fb:	6a 5e                	push   $0x5e
  jmp alltraps
801069fd:	e9 07 f8 ff ff       	jmp    80106209 <alltraps>

80106a02 <vector95>:
.globl vector95
vector95:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $95
80106a04:	6a 5f                	push   $0x5f
  jmp alltraps
80106a06:	e9 fe f7 ff ff       	jmp    80106209 <alltraps>

80106a0b <vector96>:
.globl vector96
vector96:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $96
80106a0d:	6a 60                	push   $0x60
  jmp alltraps
80106a0f:	e9 f5 f7 ff ff       	jmp    80106209 <alltraps>

80106a14 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $97
80106a16:	6a 61                	push   $0x61
  jmp alltraps
80106a18:	e9 ec f7 ff ff       	jmp    80106209 <alltraps>

80106a1d <vector98>:
.globl vector98
vector98:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $98
80106a1f:	6a 62                	push   $0x62
  jmp alltraps
80106a21:	e9 e3 f7 ff ff       	jmp    80106209 <alltraps>

80106a26 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $99
80106a28:	6a 63                	push   $0x63
  jmp alltraps
80106a2a:	e9 da f7 ff ff       	jmp    80106209 <alltraps>

80106a2f <vector100>:
.globl vector100
vector100:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $100
80106a31:	6a 64                	push   $0x64
  jmp alltraps
80106a33:	e9 d1 f7 ff ff       	jmp    80106209 <alltraps>

80106a38 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $101
80106a3a:	6a 65                	push   $0x65
  jmp alltraps
80106a3c:	e9 c8 f7 ff ff       	jmp    80106209 <alltraps>

80106a41 <vector102>:
.globl vector102
vector102:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $102
80106a43:	6a 66                	push   $0x66
  jmp alltraps
80106a45:	e9 bf f7 ff ff       	jmp    80106209 <alltraps>

80106a4a <vector103>:
.globl vector103
vector103:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $103
80106a4c:	6a 67                	push   $0x67
  jmp alltraps
80106a4e:	e9 b6 f7 ff ff       	jmp    80106209 <alltraps>

80106a53 <vector104>:
.globl vector104
vector104:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $104
80106a55:	6a 68                	push   $0x68
  jmp alltraps
80106a57:	e9 ad f7 ff ff       	jmp    80106209 <alltraps>

80106a5c <vector105>:
.globl vector105
vector105:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $105
80106a5e:	6a 69                	push   $0x69
  jmp alltraps
80106a60:	e9 a4 f7 ff ff       	jmp    80106209 <alltraps>

80106a65 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $106
80106a67:	6a 6a                	push   $0x6a
  jmp alltraps
80106a69:	e9 9b f7 ff ff       	jmp    80106209 <alltraps>

80106a6e <vector107>:
.globl vector107
vector107:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $107
80106a70:	6a 6b                	push   $0x6b
  jmp alltraps
80106a72:	e9 92 f7 ff ff       	jmp    80106209 <alltraps>

80106a77 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $108
80106a79:	6a 6c                	push   $0x6c
  jmp alltraps
80106a7b:	e9 89 f7 ff ff       	jmp    80106209 <alltraps>

80106a80 <vector109>:
.globl vector109
vector109:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $109
80106a82:	6a 6d                	push   $0x6d
  jmp alltraps
80106a84:	e9 80 f7 ff ff       	jmp    80106209 <alltraps>

80106a89 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $110
80106a8b:	6a 6e                	push   $0x6e
  jmp alltraps
80106a8d:	e9 77 f7 ff ff       	jmp    80106209 <alltraps>

80106a92 <vector111>:
.globl vector111
vector111:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $111
80106a94:	6a 6f                	push   $0x6f
  jmp alltraps
80106a96:	e9 6e f7 ff ff       	jmp    80106209 <alltraps>

80106a9b <vector112>:
.globl vector112
vector112:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $112
80106a9d:	6a 70                	push   $0x70
  jmp alltraps
80106a9f:	e9 65 f7 ff ff       	jmp    80106209 <alltraps>

80106aa4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $113
80106aa6:	6a 71                	push   $0x71
  jmp alltraps
80106aa8:	e9 5c f7 ff ff       	jmp    80106209 <alltraps>

80106aad <vector114>:
.globl vector114
vector114:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $114
80106aaf:	6a 72                	push   $0x72
  jmp alltraps
80106ab1:	e9 53 f7 ff ff       	jmp    80106209 <alltraps>

80106ab6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $115
80106ab8:	6a 73                	push   $0x73
  jmp alltraps
80106aba:	e9 4a f7 ff ff       	jmp    80106209 <alltraps>

80106abf <vector116>:
.globl vector116
vector116:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $116
80106ac1:	6a 74                	push   $0x74
  jmp alltraps
80106ac3:	e9 41 f7 ff ff       	jmp    80106209 <alltraps>

80106ac8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $117
80106aca:	6a 75                	push   $0x75
  jmp alltraps
80106acc:	e9 38 f7 ff ff       	jmp    80106209 <alltraps>

80106ad1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $118
80106ad3:	6a 76                	push   $0x76
  jmp alltraps
80106ad5:	e9 2f f7 ff ff       	jmp    80106209 <alltraps>

80106ada <vector119>:
.globl vector119
vector119:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $119
80106adc:	6a 77                	push   $0x77
  jmp alltraps
80106ade:	e9 26 f7 ff ff       	jmp    80106209 <alltraps>

80106ae3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $120
80106ae5:	6a 78                	push   $0x78
  jmp alltraps
80106ae7:	e9 1d f7 ff ff       	jmp    80106209 <alltraps>

80106aec <vector121>:
.globl vector121
vector121:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $121
80106aee:	6a 79                	push   $0x79
  jmp alltraps
80106af0:	e9 14 f7 ff ff       	jmp    80106209 <alltraps>

80106af5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $122
80106af7:	6a 7a                	push   $0x7a
  jmp alltraps
80106af9:	e9 0b f7 ff ff       	jmp    80106209 <alltraps>

80106afe <vector123>:
.globl vector123
vector123:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $123
80106b00:	6a 7b                	push   $0x7b
  jmp alltraps
80106b02:	e9 02 f7 ff ff       	jmp    80106209 <alltraps>

80106b07 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $124
80106b09:	6a 7c                	push   $0x7c
  jmp alltraps
80106b0b:	e9 f9 f6 ff ff       	jmp    80106209 <alltraps>

80106b10 <vector125>:
.globl vector125
vector125:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $125
80106b12:	6a 7d                	push   $0x7d
  jmp alltraps
80106b14:	e9 f0 f6 ff ff       	jmp    80106209 <alltraps>

80106b19 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $126
80106b1b:	6a 7e                	push   $0x7e
  jmp alltraps
80106b1d:	e9 e7 f6 ff ff       	jmp    80106209 <alltraps>

80106b22 <vector127>:
.globl vector127
vector127:
  pushl $0
80106b22:	6a 00                	push   $0x0
  pushl $127
80106b24:	6a 7f                	push   $0x7f
  jmp alltraps
80106b26:	e9 de f6 ff ff       	jmp    80106209 <alltraps>

80106b2b <vector128>:
.globl vector128
vector128:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $128
80106b2d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b32:	e9 d2 f6 ff ff       	jmp    80106209 <alltraps>

80106b37 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $129
80106b39:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b3e:	e9 c6 f6 ff ff       	jmp    80106209 <alltraps>

80106b43 <vector130>:
.globl vector130
vector130:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $130
80106b45:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b4a:	e9 ba f6 ff ff       	jmp    80106209 <alltraps>

80106b4f <vector131>:
.globl vector131
vector131:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $131
80106b51:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b56:	e9 ae f6 ff ff       	jmp    80106209 <alltraps>

80106b5b <vector132>:
.globl vector132
vector132:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $132
80106b5d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b62:	e9 a2 f6 ff ff       	jmp    80106209 <alltraps>

80106b67 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $133
80106b69:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b6e:	e9 96 f6 ff ff       	jmp    80106209 <alltraps>

80106b73 <vector134>:
.globl vector134
vector134:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $134
80106b75:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b7a:	e9 8a f6 ff ff       	jmp    80106209 <alltraps>

80106b7f <vector135>:
.globl vector135
vector135:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $135
80106b81:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b86:	e9 7e f6 ff ff       	jmp    80106209 <alltraps>

80106b8b <vector136>:
.globl vector136
vector136:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $136
80106b8d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b92:	e9 72 f6 ff ff       	jmp    80106209 <alltraps>

80106b97 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $137
80106b99:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b9e:	e9 66 f6 ff ff       	jmp    80106209 <alltraps>

80106ba3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $138
80106ba5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106baa:	e9 5a f6 ff ff       	jmp    80106209 <alltraps>

80106baf <vector139>:
.globl vector139
vector139:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $139
80106bb1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106bb6:	e9 4e f6 ff ff       	jmp    80106209 <alltraps>

80106bbb <vector140>:
.globl vector140
vector140:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $140
80106bbd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bc2:	e9 42 f6 ff ff       	jmp    80106209 <alltraps>

80106bc7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $141
80106bc9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bce:	e9 36 f6 ff ff       	jmp    80106209 <alltraps>

80106bd3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $142
80106bd5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106bda:	e9 2a f6 ff ff       	jmp    80106209 <alltraps>

80106bdf <vector143>:
.globl vector143
vector143:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $143
80106be1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106be6:	e9 1e f6 ff ff       	jmp    80106209 <alltraps>

80106beb <vector144>:
.globl vector144
vector144:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $144
80106bed:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bf2:	e9 12 f6 ff ff       	jmp    80106209 <alltraps>

80106bf7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $145
80106bf9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bfe:	e9 06 f6 ff ff       	jmp    80106209 <alltraps>

80106c03 <vector146>:
.globl vector146
vector146:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $146
80106c05:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c0a:	e9 fa f5 ff ff       	jmp    80106209 <alltraps>

80106c0f <vector147>:
.globl vector147
vector147:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $147
80106c11:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c16:	e9 ee f5 ff ff       	jmp    80106209 <alltraps>

80106c1b <vector148>:
.globl vector148
vector148:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $148
80106c1d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c22:	e9 e2 f5 ff ff       	jmp    80106209 <alltraps>

80106c27 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $149
80106c29:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c2e:	e9 d6 f5 ff ff       	jmp    80106209 <alltraps>

80106c33 <vector150>:
.globl vector150
vector150:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $150
80106c35:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c3a:	e9 ca f5 ff ff       	jmp    80106209 <alltraps>

80106c3f <vector151>:
.globl vector151
vector151:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $151
80106c41:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c46:	e9 be f5 ff ff       	jmp    80106209 <alltraps>

80106c4b <vector152>:
.globl vector152
vector152:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $152
80106c4d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c52:	e9 b2 f5 ff ff       	jmp    80106209 <alltraps>

80106c57 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $153
80106c59:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c5e:	e9 a6 f5 ff ff       	jmp    80106209 <alltraps>

80106c63 <vector154>:
.globl vector154
vector154:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $154
80106c65:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c6a:	e9 9a f5 ff ff       	jmp    80106209 <alltraps>

80106c6f <vector155>:
.globl vector155
vector155:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $155
80106c71:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c76:	e9 8e f5 ff ff       	jmp    80106209 <alltraps>

80106c7b <vector156>:
.globl vector156
vector156:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $156
80106c7d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c82:	e9 82 f5 ff ff       	jmp    80106209 <alltraps>

80106c87 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $157
80106c89:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c8e:	e9 76 f5 ff ff       	jmp    80106209 <alltraps>

80106c93 <vector158>:
.globl vector158
vector158:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $158
80106c95:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c9a:	e9 6a f5 ff ff       	jmp    80106209 <alltraps>

80106c9f <vector159>:
.globl vector159
vector159:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $159
80106ca1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106ca6:	e9 5e f5 ff ff       	jmp    80106209 <alltraps>

80106cab <vector160>:
.globl vector160
vector160:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $160
80106cad:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106cb2:	e9 52 f5 ff ff       	jmp    80106209 <alltraps>

80106cb7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $161
80106cb9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106cbe:	e9 46 f5 ff ff       	jmp    80106209 <alltraps>

80106cc3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $162
80106cc5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cca:	e9 3a f5 ff ff       	jmp    80106209 <alltraps>

80106ccf <vector163>:
.globl vector163
vector163:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $163
80106cd1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106cd6:	e9 2e f5 ff ff       	jmp    80106209 <alltraps>

80106cdb <vector164>:
.globl vector164
vector164:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $164
80106cdd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106ce2:	e9 22 f5 ff ff       	jmp    80106209 <alltraps>

80106ce7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $165
80106ce9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cee:	e9 16 f5 ff ff       	jmp    80106209 <alltraps>

80106cf3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $166
80106cf5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cfa:	e9 0a f5 ff ff       	jmp    80106209 <alltraps>

80106cff <vector167>:
.globl vector167
vector167:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $167
80106d01:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d06:	e9 fe f4 ff ff       	jmp    80106209 <alltraps>

80106d0b <vector168>:
.globl vector168
vector168:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $168
80106d0d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d12:	e9 f2 f4 ff ff       	jmp    80106209 <alltraps>

80106d17 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $169
80106d19:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d1e:	e9 e6 f4 ff ff       	jmp    80106209 <alltraps>

80106d23 <vector170>:
.globl vector170
vector170:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $170
80106d25:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d2a:	e9 da f4 ff ff       	jmp    80106209 <alltraps>

80106d2f <vector171>:
.globl vector171
vector171:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $171
80106d31:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d36:	e9 ce f4 ff ff       	jmp    80106209 <alltraps>

80106d3b <vector172>:
.globl vector172
vector172:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $172
80106d3d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d42:	e9 c2 f4 ff ff       	jmp    80106209 <alltraps>

80106d47 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $173
80106d49:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d4e:	e9 b6 f4 ff ff       	jmp    80106209 <alltraps>

80106d53 <vector174>:
.globl vector174
vector174:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $174
80106d55:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d5a:	e9 aa f4 ff ff       	jmp    80106209 <alltraps>

80106d5f <vector175>:
.globl vector175
vector175:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $175
80106d61:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d66:	e9 9e f4 ff ff       	jmp    80106209 <alltraps>

80106d6b <vector176>:
.globl vector176
vector176:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $176
80106d6d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d72:	e9 92 f4 ff ff       	jmp    80106209 <alltraps>

80106d77 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $177
80106d79:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d7e:	e9 86 f4 ff ff       	jmp    80106209 <alltraps>

80106d83 <vector178>:
.globl vector178
vector178:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $178
80106d85:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d8a:	e9 7a f4 ff ff       	jmp    80106209 <alltraps>

80106d8f <vector179>:
.globl vector179
vector179:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $179
80106d91:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d96:	e9 6e f4 ff ff       	jmp    80106209 <alltraps>

80106d9b <vector180>:
.globl vector180
vector180:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $180
80106d9d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106da2:	e9 62 f4 ff ff       	jmp    80106209 <alltraps>

80106da7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $181
80106da9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106dae:	e9 56 f4 ff ff       	jmp    80106209 <alltraps>

80106db3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $182
80106db5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106dba:	e9 4a f4 ff ff       	jmp    80106209 <alltraps>

80106dbf <vector183>:
.globl vector183
vector183:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $183
80106dc1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106dc6:	e9 3e f4 ff ff       	jmp    80106209 <alltraps>

80106dcb <vector184>:
.globl vector184
vector184:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $184
80106dcd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dd2:	e9 32 f4 ff ff       	jmp    80106209 <alltraps>

80106dd7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $185
80106dd9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dde:	e9 26 f4 ff ff       	jmp    80106209 <alltraps>

80106de3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $186
80106de5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106dea:	e9 1a f4 ff ff       	jmp    80106209 <alltraps>

80106def <vector187>:
.globl vector187
vector187:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $187
80106df1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106df6:	e9 0e f4 ff ff       	jmp    80106209 <alltraps>

80106dfb <vector188>:
.globl vector188
vector188:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $188
80106dfd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e02:	e9 02 f4 ff ff       	jmp    80106209 <alltraps>

80106e07 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $189
80106e09:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e0e:	e9 f6 f3 ff ff       	jmp    80106209 <alltraps>

80106e13 <vector190>:
.globl vector190
vector190:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $190
80106e15:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e1a:	e9 ea f3 ff ff       	jmp    80106209 <alltraps>

80106e1f <vector191>:
.globl vector191
vector191:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $191
80106e21:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e26:	e9 de f3 ff ff       	jmp    80106209 <alltraps>

80106e2b <vector192>:
.globl vector192
vector192:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $192
80106e2d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e32:	e9 d2 f3 ff ff       	jmp    80106209 <alltraps>

80106e37 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $193
80106e39:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e3e:	e9 c6 f3 ff ff       	jmp    80106209 <alltraps>

80106e43 <vector194>:
.globl vector194
vector194:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $194
80106e45:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e4a:	e9 ba f3 ff ff       	jmp    80106209 <alltraps>

80106e4f <vector195>:
.globl vector195
vector195:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $195
80106e51:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e56:	e9 ae f3 ff ff       	jmp    80106209 <alltraps>

80106e5b <vector196>:
.globl vector196
vector196:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $196
80106e5d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e62:	e9 a2 f3 ff ff       	jmp    80106209 <alltraps>

80106e67 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $197
80106e69:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e6e:	e9 96 f3 ff ff       	jmp    80106209 <alltraps>

80106e73 <vector198>:
.globl vector198
vector198:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $198
80106e75:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e7a:	e9 8a f3 ff ff       	jmp    80106209 <alltraps>

80106e7f <vector199>:
.globl vector199
vector199:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $199
80106e81:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e86:	e9 7e f3 ff ff       	jmp    80106209 <alltraps>

80106e8b <vector200>:
.globl vector200
vector200:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $200
80106e8d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e92:	e9 72 f3 ff ff       	jmp    80106209 <alltraps>

80106e97 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $201
80106e99:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e9e:	e9 66 f3 ff ff       	jmp    80106209 <alltraps>

80106ea3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $202
80106ea5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106eaa:	e9 5a f3 ff ff       	jmp    80106209 <alltraps>

80106eaf <vector203>:
.globl vector203
vector203:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $203
80106eb1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106eb6:	e9 4e f3 ff ff       	jmp    80106209 <alltraps>

80106ebb <vector204>:
.globl vector204
vector204:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $204
80106ebd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ec2:	e9 42 f3 ff ff       	jmp    80106209 <alltraps>

80106ec7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $205
80106ec9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106ece:	e9 36 f3 ff ff       	jmp    80106209 <alltraps>

80106ed3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $206
80106ed5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106eda:	e9 2a f3 ff ff       	jmp    80106209 <alltraps>

80106edf <vector207>:
.globl vector207
vector207:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $207
80106ee1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ee6:	e9 1e f3 ff ff       	jmp    80106209 <alltraps>

80106eeb <vector208>:
.globl vector208
vector208:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $208
80106eed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ef2:	e9 12 f3 ff ff       	jmp    80106209 <alltraps>

80106ef7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $209
80106ef9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106efe:	e9 06 f3 ff ff       	jmp    80106209 <alltraps>

80106f03 <vector210>:
.globl vector210
vector210:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $210
80106f05:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f0a:	e9 fa f2 ff ff       	jmp    80106209 <alltraps>

80106f0f <vector211>:
.globl vector211
vector211:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $211
80106f11:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f16:	e9 ee f2 ff ff       	jmp    80106209 <alltraps>

80106f1b <vector212>:
.globl vector212
vector212:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $212
80106f1d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f22:	e9 e2 f2 ff ff       	jmp    80106209 <alltraps>

80106f27 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $213
80106f29:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f2e:	e9 d6 f2 ff ff       	jmp    80106209 <alltraps>

80106f33 <vector214>:
.globl vector214
vector214:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $214
80106f35:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f3a:	e9 ca f2 ff ff       	jmp    80106209 <alltraps>

80106f3f <vector215>:
.globl vector215
vector215:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $215
80106f41:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f46:	e9 be f2 ff ff       	jmp    80106209 <alltraps>

80106f4b <vector216>:
.globl vector216
vector216:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $216
80106f4d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f52:	e9 b2 f2 ff ff       	jmp    80106209 <alltraps>

80106f57 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $217
80106f59:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f5e:	e9 a6 f2 ff ff       	jmp    80106209 <alltraps>

80106f63 <vector218>:
.globl vector218
vector218:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $218
80106f65:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f6a:	e9 9a f2 ff ff       	jmp    80106209 <alltraps>

80106f6f <vector219>:
.globl vector219
vector219:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $219
80106f71:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f76:	e9 8e f2 ff ff       	jmp    80106209 <alltraps>

80106f7b <vector220>:
.globl vector220
vector220:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $220
80106f7d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f82:	e9 82 f2 ff ff       	jmp    80106209 <alltraps>

80106f87 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $221
80106f89:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f8e:	e9 76 f2 ff ff       	jmp    80106209 <alltraps>

80106f93 <vector222>:
.globl vector222
vector222:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $222
80106f95:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f9a:	e9 6a f2 ff ff       	jmp    80106209 <alltraps>

80106f9f <vector223>:
.globl vector223
vector223:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $223
80106fa1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106fa6:	e9 5e f2 ff ff       	jmp    80106209 <alltraps>

80106fab <vector224>:
.globl vector224
vector224:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $224
80106fad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106fb2:	e9 52 f2 ff ff       	jmp    80106209 <alltraps>

80106fb7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $225
80106fb9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106fbe:	e9 46 f2 ff ff       	jmp    80106209 <alltraps>

80106fc3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $226
80106fc5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fca:	e9 3a f2 ff ff       	jmp    80106209 <alltraps>

80106fcf <vector227>:
.globl vector227
vector227:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $227
80106fd1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fd6:	e9 2e f2 ff ff       	jmp    80106209 <alltraps>

80106fdb <vector228>:
.globl vector228
vector228:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $228
80106fdd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fe2:	e9 22 f2 ff ff       	jmp    80106209 <alltraps>

80106fe7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $229
80106fe9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fee:	e9 16 f2 ff ff       	jmp    80106209 <alltraps>

80106ff3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $230
80106ff5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ffa:	e9 0a f2 ff ff       	jmp    80106209 <alltraps>

80106fff <vector231>:
.globl vector231
vector231:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $231
80107001:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107006:	e9 fe f1 ff ff       	jmp    80106209 <alltraps>

8010700b <vector232>:
.globl vector232
vector232:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $232
8010700d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107012:	e9 f2 f1 ff ff       	jmp    80106209 <alltraps>

80107017 <vector233>:
.globl vector233
vector233:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $233
80107019:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010701e:	e9 e6 f1 ff ff       	jmp    80106209 <alltraps>

80107023 <vector234>:
.globl vector234
vector234:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $234
80107025:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010702a:	e9 da f1 ff ff       	jmp    80106209 <alltraps>

8010702f <vector235>:
.globl vector235
vector235:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $235
80107031:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107036:	e9 ce f1 ff ff       	jmp    80106209 <alltraps>

8010703b <vector236>:
.globl vector236
vector236:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $236
8010703d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107042:	e9 c2 f1 ff ff       	jmp    80106209 <alltraps>

80107047 <vector237>:
.globl vector237
vector237:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $237
80107049:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010704e:	e9 b6 f1 ff ff       	jmp    80106209 <alltraps>

80107053 <vector238>:
.globl vector238
vector238:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $238
80107055:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010705a:	e9 aa f1 ff ff       	jmp    80106209 <alltraps>

8010705f <vector239>:
.globl vector239
vector239:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $239
80107061:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107066:	e9 9e f1 ff ff       	jmp    80106209 <alltraps>

8010706b <vector240>:
.globl vector240
vector240:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $240
8010706d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107072:	e9 92 f1 ff ff       	jmp    80106209 <alltraps>

80107077 <vector241>:
.globl vector241
vector241:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $241
80107079:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010707e:	e9 86 f1 ff ff       	jmp    80106209 <alltraps>

80107083 <vector242>:
.globl vector242
vector242:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $242
80107085:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010708a:	e9 7a f1 ff ff       	jmp    80106209 <alltraps>

8010708f <vector243>:
.globl vector243
vector243:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $243
80107091:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107096:	e9 6e f1 ff ff       	jmp    80106209 <alltraps>

8010709b <vector244>:
.globl vector244
vector244:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $244
8010709d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801070a2:	e9 62 f1 ff ff       	jmp    80106209 <alltraps>

801070a7 <vector245>:
.globl vector245
vector245:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $245
801070a9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801070ae:	e9 56 f1 ff ff       	jmp    80106209 <alltraps>

801070b3 <vector246>:
.globl vector246
vector246:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $246
801070b5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070ba:	e9 4a f1 ff ff       	jmp    80106209 <alltraps>

801070bf <vector247>:
.globl vector247
vector247:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $247
801070c1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070c6:	e9 3e f1 ff ff       	jmp    80106209 <alltraps>

801070cb <vector248>:
.globl vector248
vector248:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $248
801070cd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070d2:	e9 32 f1 ff ff       	jmp    80106209 <alltraps>

801070d7 <vector249>:
.globl vector249
vector249:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $249
801070d9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070de:	e9 26 f1 ff ff       	jmp    80106209 <alltraps>

801070e3 <vector250>:
.globl vector250
vector250:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $250
801070e5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070ea:	e9 1a f1 ff ff       	jmp    80106209 <alltraps>

801070ef <vector251>:
.globl vector251
vector251:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $251
801070f1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070f6:	e9 0e f1 ff ff       	jmp    80106209 <alltraps>

801070fb <vector252>:
.globl vector252
vector252:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $252
801070fd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107102:	e9 02 f1 ff ff       	jmp    80106209 <alltraps>

80107107 <vector253>:
.globl vector253
vector253:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $253
80107109:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010710e:	e9 f6 f0 ff ff       	jmp    80106209 <alltraps>

80107113 <vector254>:
.globl vector254
vector254:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $254
80107115:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010711a:	e9 ea f0 ff ff       	jmp    80106209 <alltraps>

8010711f <vector255>:
.globl vector255
vector255:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $255
80107121:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107126:	e9 de f0 ff ff       	jmp    80106209 <alltraps>
8010712b:	66 90                	xchg   %ax,%ax
8010712d:	66 90                	xchg   %ax,%ax
8010712f:	90                   	nop

80107130 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80107137:	c1 ea 16             	shr    $0x16,%edx
{
8010713a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010713b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010713e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107141:	8b 1f                	mov    (%edi),%ebx
80107143:	f6 c3 01             	test   $0x1,%bl
80107146:	74 28                	je     80107170 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107148:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010714e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107154:	89 f0                	mov    %esi,%eax
}
80107156:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107159:	c1 e8 0a             	shr    $0xa,%eax
8010715c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107161:	01 d8                	add    %ebx,%eax
}
80107163:	5b                   	pop    %ebx
80107164:	5e                   	pop    %esi
80107165:	5f                   	pop    %edi
80107166:	5d                   	pop    %ebp
80107167:	c3                   	ret    
80107168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107170:	85 c9                	test   %ecx,%ecx
80107172:	74 2c                	je     801071a0 <walkpgdir+0x70>
80107174:	e8 b7 b9 ff ff       	call   80102b30 <kalloc>
80107179:	89 c3                	mov    %eax,%ebx
8010717b:	85 c0                	test   %eax,%eax
8010717d:	74 21                	je     801071a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010717f:	83 ec 04             	sub    $0x4,%esp
80107182:	68 00 10 00 00       	push   $0x1000
80107187:	6a 00                	push   $0x0
80107189:	50                   	push   %eax
8010718a:	e8 31 de ff ff       	call   80104fc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010718f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107195:	83 c4 10             	add    $0x10,%esp
80107198:	83 c8 07             	or     $0x7,%eax
8010719b:	89 07                	mov    %eax,(%edi)
8010719d:	eb b5                	jmp    80107154 <walkpgdir+0x24>
8010719f:	90                   	nop
}
801071a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801071a3:	31 c0                	xor    %eax,%eax
}
801071a5:	5b                   	pop    %ebx
801071a6:	5e                   	pop    %esi
801071a7:	5f                   	pop    %edi
801071a8:	5d                   	pop    %ebp
801071a9:	c3                   	ret    
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801071ba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801071c0:	89 d6                	mov    %edx,%esi
{
801071c2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801071c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071cf:	8b 45 08             	mov    0x8(%ebp),%eax
801071d2:	29 f0                	sub    %esi,%eax
801071d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d7:	eb 1f                	jmp    801071f8 <mappages+0x48>
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801071e0:	f6 00 01             	testb  $0x1,(%eax)
801071e3:	75 45                	jne    8010722a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801071e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801071e8:	83 cb 01             	or     $0x1,%ebx
801071eb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801071ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801071f0:	74 2e                	je     80107220 <mappages+0x70>
      break;
    a += PGSIZE;
801071f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801071f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80107200:	89 f2                	mov    %esi,%edx
80107202:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107205:	89 f8                	mov    %edi,%eax
80107207:	e8 24 ff ff ff       	call   80107130 <walkpgdir>
8010720c:	85 c0                	test   %eax,%eax
8010720e:	75 d0                	jne    801071e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107218:	5b                   	pop    %ebx
80107219:	5e                   	pop    %esi
8010721a:	5f                   	pop    %edi
8010721b:	5d                   	pop    %ebp
8010721c:	c3                   	ret    
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
80107220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107223:	31 c0                	xor    %eax,%eax
}
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
      panic("remap");
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	68 34 8d 10 80       	push   $0x80108d34
80107232:	e8 59 91 ff ff       	call   80100390 <panic>
80107237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723e:	66 90                	xchg   %ax,%ax

80107240 <printlist>:
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	56                   	push   %esi
  struct fblock *curr = myproc()->free_head;
80107248:	be 10 00 00 00       	mov    $0x10,%esi
{
8010724d:	53                   	push   %ebx
  cprintf("printing list:\n");
8010724e:	83 ec 0c             	sub    $0xc,%esp
80107251:	68 3a 8d 10 80       	push   $0x80108d3a
80107256:	e8 55 94 ff ff       	call   801006b0 <cprintf>
  struct fblock *curr = myproc()->free_head;
8010725b:	e8 70 ce ff ff       	call   801040d0 <myproc>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	8b 98 90 02 00 00    	mov    0x290(%eax),%ebx
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d -> ", curr->off);
80107270:	83 ec 08             	sub    $0x8,%esp
80107273:	ff 33                	pushl  (%ebx)
80107275:	68 4a 8d 10 80       	push   $0x80108d4a
8010727a:	e8 31 94 ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
8010727f:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107282:	83 c4 10             	add    $0x10,%esp
80107285:	85 db                	test   %ebx,%ebx
80107287:	74 05                	je     8010728e <printlist+0x4e>
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107289:	83 ee 01             	sub    $0x1,%esi
8010728c:	75 e2                	jne    80107270 <printlist+0x30>
  cprintf("\n");
8010728e:	83 ec 0c             	sub    $0xc,%esp
80107291:	68 fa 8d 10 80       	push   $0x80108dfa
80107296:	e8 15 94 ff ff       	call   801006b0 <cprintf>
}
8010729b:	83 c4 10             	add    $0x10,%esp
8010729e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a1:	5b                   	pop    %ebx
801072a2:	5e                   	pop    %esi
801072a3:	5d                   	pop    %ebp
801072a4:	c3                   	ret    
801072a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072b0 <seginit>:
{
801072b0:	f3 0f 1e fb          	endbr32 
801072b4:	55                   	push   %ebp
801072b5:	89 e5                	mov    %esp,%ebp
801072b7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072ba:	e8 f1 cd ff ff       	call   801040b0 <cpuid>
  pd[0] = size-1;
801072bf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072c4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072ca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072ce:	c7 80 38 68 18 80 ff 	movl   $0xffff,-0x7fe797c8(%eax)
801072d5:	ff 00 00 
801072d8:	c7 80 3c 68 18 80 00 	movl   $0xcf9a00,-0x7fe797c4(%eax)
801072df:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072e2:	c7 80 40 68 18 80 ff 	movl   $0xffff,-0x7fe797c0(%eax)
801072e9:	ff 00 00 
801072ec:	c7 80 44 68 18 80 00 	movl   $0xcf9200,-0x7fe797bc(%eax)
801072f3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072f6:	c7 80 48 68 18 80 ff 	movl   $0xffff,-0x7fe797b8(%eax)
801072fd:	ff 00 00 
80107300:	c7 80 4c 68 18 80 00 	movl   $0xcffa00,-0x7fe797b4(%eax)
80107307:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010730a:	c7 80 50 68 18 80 ff 	movl   $0xffff,-0x7fe797b0(%eax)
80107311:	ff 00 00 
80107314:	c7 80 54 68 18 80 00 	movl   $0xcff200,-0x7fe797ac(%eax)
8010731b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010731e:	05 30 68 18 80       	add    $0x80186830,%eax
  pd[1] = (uint)p;
80107323:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107327:	c1 e8 10             	shr    $0x10,%eax
8010732a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010732e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107331:	0f 01 10             	lgdtl  (%eax)
}
80107334:	c9                   	leave  
80107335:	c3                   	ret    
80107336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733d:	8d 76 00             	lea    0x0(%esi),%esi

80107340 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107340:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107344:	a1 e4 1b 19 80       	mov    0x80191be4,%eax
80107349:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010734e:	0f 22 d8             	mov    %eax,%cr3
}
80107351:	c3                   	ret    
80107352:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107360 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
80107365:	89 e5                	mov    %esp,%ebp
80107367:	57                   	push   %edi
80107368:	56                   	push   %esi
80107369:	53                   	push   %ebx
8010736a:	83 ec 1c             	sub    $0x1c,%esp
8010736d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107370:	85 f6                	test   %esi,%esi
80107372:	0f 84 cb 00 00 00    	je     80107443 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107378:	8b 46 08             	mov    0x8(%esi),%eax
8010737b:	85 c0                	test   %eax,%eax
8010737d:	0f 84 da 00 00 00    	je     8010745d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107383:	8b 46 04             	mov    0x4(%esi),%eax
80107386:	85 c0                	test   %eax,%eax
80107388:	0f 84 c2 00 00 00    	je     80107450 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
8010738e:	e8 1d da ff ff       	call   80104db0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107393:	e8 a8 cc ff ff       	call   80104040 <mycpu>
80107398:	89 c3                	mov    %eax,%ebx
8010739a:	e8 a1 cc ff ff       	call   80104040 <mycpu>
8010739f:	89 c7                	mov    %eax,%edi
801073a1:	e8 9a cc ff ff       	call   80104040 <mycpu>
801073a6:	83 c7 08             	add    $0x8,%edi
801073a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073ac:	e8 8f cc ff ff       	call   80104040 <mycpu>
801073b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073b4:	ba 67 00 00 00       	mov    $0x67,%edx
801073b9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801073c0:	83 c0 08             	add    $0x8,%eax
801073c3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073ca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073cf:	83 c1 08             	add    $0x8,%ecx
801073d2:	c1 e8 18             	shr    $0x18,%eax
801073d5:	c1 e9 10             	shr    $0x10,%ecx
801073d8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073de:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073e4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073e9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073f5:	e8 46 cc ff ff       	call   80104040 <mycpu>
801073fa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107401:	e8 3a cc ff ff       	call   80104040 <mycpu>
80107406:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010740a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010740d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107413:	e8 28 cc ff ff       	call   80104040 <mycpu>
80107418:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010741b:	e8 20 cc ff ff       	call   80104040 <mycpu>
80107420:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107424:	b8 28 00 00 00       	mov    $0x28,%eax
80107429:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010742c:	8b 46 04             	mov    0x4(%esi),%eax
8010742f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107434:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107437:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010743a:	5b                   	pop    %ebx
8010743b:	5e                   	pop    %esi
8010743c:	5f                   	pop    %edi
8010743d:	5d                   	pop    %ebp
  popcli();
8010743e:	e9 bd d9 ff ff       	jmp    80104e00 <popcli>
    panic("switchuvm: no process");
80107443:	83 ec 0c             	sub    $0xc,%esp
80107446:	68 51 8d 10 80       	push   $0x80108d51
8010744b:	e8 40 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	68 7c 8d 10 80       	push   $0x80108d7c
80107458:	e8 33 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010745d:	83 ec 0c             	sub    $0xc,%esp
80107460:	68 67 8d 10 80       	push   $0x80108d67
80107465:	e8 26 8f ff ff       	call   80100390 <panic>
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107470 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107470:	f3 0f 1e fb          	endbr32 
80107474:	55                   	push   %ebp
80107475:	89 e5                	mov    %esp,%ebp
80107477:	57                   	push   %edi
80107478:	56                   	push   %esi
80107479:	53                   	push   %ebx
8010747a:	83 ec 1c             	sub    $0x1c,%esp
8010747d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107480:	8b 75 10             	mov    0x10(%ebp),%esi
80107483:	8b 7d 08             	mov    0x8(%ebp),%edi
80107486:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107489:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010748f:	77 4b                	ja     801074dc <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107491:	e8 9a b6 ff ff       	call   80102b30 <kalloc>
  memset(mem, 0, PGSIZE);
80107496:	83 ec 04             	sub    $0x4,%esp
80107499:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010749e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801074a0:	6a 00                	push   $0x0
801074a2:	50                   	push   %eax
801074a3:	e8 18 db ff ff       	call   80104fc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801074a8:	58                   	pop    %eax
801074a9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074af:	5a                   	pop    %edx
801074b0:	6a 06                	push   $0x6
801074b2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074b7:	31 d2                	xor    %edx,%edx
801074b9:	50                   	push   %eax
801074ba:	89 f8                	mov    %edi,%eax
801074bc:	e8 ef fc ff ff       	call   801071b0 <mappages>
  memmove(mem, init, sz);
801074c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074c4:	89 75 10             	mov    %esi,0x10(%ebp)
801074c7:	83 c4 10             	add    $0x10,%esp
801074ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
801074cd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801074d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d3:	5b                   	pop    %ebx
801074d4:	5e                   	pop    %esi
801074d5:	5f                   	pop    %edi
801074d6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074d7:	e9 84 db ff ff       	jmp    80105060 <memmove>
    panic("inituvm: more than a page");
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	68 90 8d 10 80       	push   $0x80108d90
801074e4:	e8 a7 8e ff ff       	call   80100390 <panic>
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074f0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801074f0:	f3 0f 1e fb          	endbr32 
801074f4:	55                   	push   %ebp
801074f5:	89 e5                	mov    %esp,%ebp
801074f7:	57                   	push   %edi
801074f8:	56                   	push   %esi
801074f9:	53                   	push   %ebx
801074fa:	83 ec 1c             	sub    $0x1c,%esp
801074fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107500:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107503:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107508:	0f 85 99 00 00 00    	jne    801075a7 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010750e:	01 f0                	add    %esi,%eax
80107510:	89 f3                	mov    %esi,%ebx
80107512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107515:	8b 45 14             	mov    0x14(%ebp),%eax
80107518:	01 f0                	add    %esi,%eax
8010751a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010751d:	85 f6                	test   %esi,%esi
8010751f:	75 15                	jne    80107536 <loaduvm+0x46>
80107521:	eb 6d                	jmp    80107590 <loaduvm+0xa0>
80107523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107527:	90                   	nop
80107528:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010752e:	89 f0                	mov    %esi,%eax
80107530:	29 d8                	sub    %ebx,%eax
80107532:	39 c6                	cmp    %eax,%esi
80107534:	76 5a                	jbe    80107590 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107536:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107539:	8b 45 08             	mov    0x8(%ebp),%eax
8010753c:	31 c9                	xor    %ecx,%ecx
8010753e:	29 da                	sub    %ebx,%edx
80107540:	e8 eb fb ff ff       	call   80107130 <walkpgdir>
80107545:	85 c0                	test   %eax,%eax
80107547:	74 51                	je     8010759a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107549:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010754b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010754e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107558:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010755e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107561:	29 d9                	sub    %ebx,%ecx
80107563:	05 00 00 00 80       	add    $0x80000000,%eax
80107568:	57                   	push   %edi
80107569:	51                   	push   %ecx
8010756a:	50                   	push   %eax
8010756b:	ff 75 10             	pushl  0x10(%ebp)
8010756e:	e8 2d a5 ff ff       	call   80101aa0 <readi>
80107573:	83 c4 10             	add    $0x10,%esp
80107576:	39 f8                	cmp    %edi,%eax
80107578:	74 ae                	je     80107528 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
8010757a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010757d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107582:	5b                   	pop    %ebx
80107583:	5e                   	pop    %esi
80107584:	5f                   	pop    %edi
80107585:	5d                   	pop    %ebp
80107586:	c3                   	ret    
80107587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758e:	66 90                	xchg   %ax,%ax
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107593:	31 c0                	xor    %eax,%eax
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
      panic("loaduvm: address should exist");
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	68 aa 8d 10 80       	push   $0x80108daa
801075a2:	e8 e9 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801075a7:	83 ec 0c             	sub    $0xc,%esp
801075aa:	68 f8 8e 10 80       	push   $0x80108ef8
801075af:	e8 dc 8d ff ff       	call   80100390 <panic>
801075b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075bf:	90                   	nop

801075c0 <indexToSwap>:
  }
  return newsz;
}

uint indexToSwap()
{
801075c0:	f3 0f 1e fb          	endbr32 
  return 15;
}
801075c4:	b8 0f 00 00 00       	mov    $0xf,%eax
801075c9:	c3                   	ret    
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801075d0:	f3 0f 1e fb          	endbr32 
801075d4:	55                   	push   %ebp
801075d5:	89 e5                	mov    %esp,%ebp
801075d7:	57                   	push   %edi
801075d8:	56                   	push   %esi
801075d9:	53                   	push   %ebx
801075da:	83 ec 3c             	sub    $0x3c,%esp
801075dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
801075e0:	e8 eb ca ff ff       	call   801040d0 <myproc>
801075e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)

  if(newsz >= oldsz)
801075e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801075eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ee:	0f 83 9b 00 00 00    	jae    8010768f <deallocuvm+0xbf>
    return oldsz;

  a = PGROUNDUP(newsz);
801075f4:	8b 45 10             	mov    0x10(%ebp),%eax
801075f7:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075fd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107603:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107606:	77 64                	ja     8010766c <deallocuvm+0x9c>
80107608:	e9 7f 00 00 00       	jmp    8010768c <deallocuvm+0xbc>
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107610:	8b 18                	mov    (%eax),%ebx
80107612:	f6 c3 01             	test   $0x1,%bl
80107615:	74 4a                	je     80107661 <deallocuvm+0x91>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107617:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010761d:	0f 84 6f 01 00 00    	je     80107792 <deallocuvm+0x1c2>
        panic("kfree");
      char *v = P2V(pa);
      
      if(getRefs(v) == 1)
80107623:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107626:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010762c:	89 45 c0             	mov    %eax,-0x40(%ebp)
      if(getRefs(v) == 1)
8010762f:	53                   	push   %ebx
80107630:	e8 9b b6 ff ff       	call   80102cd0 <getRefs>
80107635:	83 c4 10             	add    $0x10,%esp
80107638:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010763b:	83 f8 01             	cmp    $0x1,%eax
8010763e:	74 60                	je     801076a0 <deallocuvm+0xd0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107640:	83 ec 0c             	sub    $0xc,%esp
80107643:	89 55 c0             	mov    %edx,-0x40(%ebp)
80107646:	53                   	push   %ebx
80107647:	e8 a4 b5 ff ff       	call   80102bf0 <refDec>
      }

      if(curproc->pid >2)
8010764c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
        refDec(v);
8010764f:	83 c4 10             	add    $0x10,%esp
80107652:	8b 55 c0             	mov    -0x40(%ebp),%edx
      if(curproc->pid >2)
80107655:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107659:	7f 5d                	jg     801076b8 <deallocuvm+0xe8>
          }
        }

      }
     
      *pte = 0;
8010765b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107661:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107667:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010766a:	76 20                	jbe    8010768c <deallocuvm+0xbc>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010766c:	31 c9                	xor    %ecx,%ecx
8010766e:	89 f2                	mov    %esi,%edx
80107670:	89 f8                	mov    %edi,%eax
80107672:	e8 b9 fa ff ff       	call   80107130 <walkpgdir>
    if(!pte)
80107677:	85 c0                	test   %eax,%eax
80107679:	75 95                	jne    80107610 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
8010767b:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107681:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107687:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010768a:	77 e0                	ja     8010766c <deallocuvm+0x9c>
    }
  }
  return newsz;
8010768c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010768f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107692:	5b                   	pop    %ebx
80107693:	5e                   	pop    %esi
80107694:	5f                   	pop    %edi
80107695:	5d                   	pop    %ebp
80107696:	c3                   	ret    
80107697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010769e:	66 90                	xchg   %ax,%ax
        kfree(v);
801076a0:	83 ec 0c             	sub    $0xc,%esp
801076a3:	53                   	push   %ebx
801076a4:	e8 87 b1 ff ff       	call   80102830 <kfree>
      if(curproc->pid >2)
801076a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801076ac:	83 c4 10             	add    $0x10,%esp
801076af:	8b 55 c0             	mov    -0x40(%ebp),%edx
801076b2:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801076b6:	7e a3                	jle    8010765b <deallocuvm+0x8b>
801076b8:	8d 88 88 01 00 00    	lea    0x188(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801076be:	89 55 c0             	mov    %edx,-0x40(%ebp)
801076c1:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
801076c7:	89 fa                	mov    %edi,%edx
801076c9:	89 cf                	mov    %ecx,%edi
801076cb:	eb 13                	jmp    801076e0 <deallocuvm+0x110>
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801076d0:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801076d3:	74 7b                	je     80107750 <deallocuvm+0x180>
        for(i = 0; i < MAX_PSYC_PAGES; i++)
801076d5:	83 c3 10             	add    $0x10,%ebx
801076d8:	39 fb                	cmp    %edi,%ebx
801076da:	0f 84 a8 00 00 00    	je     80107788 <deallocuvm+0x1b8>
          struct page p_ram = curproc->ramPages[i];
801076e0:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
801076e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801076e9:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
801076ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
801076f2:	8b 83 08 01 00 00    	mov    0x108(%ebx),%eax
801076f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
801076fb:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
80107701:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107704:	8b 03                	mov    (%ebx),%eax
80107706:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107709:	8b 43 04             	mov    0x4(%ebx),%eax
8010770c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010770f:	8b 43 08             	mov    0x8(%ebx),%eax
80107712:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107715:	8b 43 0c             	mov    0xc(%ebx),%eax
80107718:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
8010771b:	39 75 d0             	cmp    %esi,-0x30(%ebp)
8010771e:	75 b0                	jne    801076d0 <deallocuvm+0x100>
80107720:	39 55 c8             	cmp    %edx,-0x38(%ebp)
80107723:	75 ab                	jne    801076d0 <deallocuvm+0x100>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107725:	83 ec 04             	sub    $0x4,%esp
80107728:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010772b:	89 55 08             	mov    %edx,0x8(%ebp)
8010772e:	6a 10                	push   $0x10
80107730:	6a 00                	push   $0x0
80107732:	50                   	push   %eax
80107733:	e8 88 d8 ff ff       	call   80104fc0 <memset>
            curproc->num_ram -- ;
80107738:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010773b:	8b 55 08             	mov    0x8(%ebp),%edx
8010773e:	83 c4 10             	add    $0x10,%esp
80107741:	83 a8 88 02 00 00 01 	subl   $0x1,0x288(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107748:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010774b:	75 88                	jne    801076d5 <deallocuvm+0x105>
8010774d:	8d 76 00             	lea    0x0(%esi),%esi
80107750:	39 55 d8             	cmp    %edx,-0x28(%ebp)
80107753:	75 80                	jne    801076d5 <deallocuvm+0x105>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107755:	83 ec 04             	sub    $0x4,%esp
80107758:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010775b:	89 55 08             	mov    %edx,0x8(%ebp)
8010775e:	83 c3 10             	add    $0x10,%ebx
80107761:	6a 10                	push   $0x10
80107763:	6a 00                	push   $0x0
80107765:	50                   	push   %eax
80107766:	e8 55 d8 ff ff       	call   80104fc0 <memset>
            curproc->num_swap --;
8010776b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010776e:	8b 55 08             	mov    0x8(%ebp),%edx
80107771:	83 c4 10             	add    $0x10,%esp
80107774:	83 a8 8c 02 00 00 01 	subl   $0x1,0x28c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
8010777b:	39 fb                	cmp    %edi,%ebx
8010777d:	0f 85 5d ff ff ff    	jne    801076e0 <deallocuvm+0x110>
80107783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107787:	90                   	nop
80107788:	89 d7                	mov    %edx,%edi
8010778a:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010778d:	e9 c9 fe ff ff       	jmp    8010765b <deallocuvm+0x8b>
        panic("kfree");
80107792:	83 ec 0c             	sub    $0xc,%esp
80107795:	68 0a 86 10 80       	push   $0x8010860a
8010779a:	e8 f1 8b ff ff       	call   80100390 <panic>
8010779f:	90                   	nop

801077a0 <allocuvm>:
{
801077a0:	f3 0f 1e fb          	endbr32 
801077a4:	55                   	push   %ebp
801077a5:	89 e5                	mov    %esp,%ebp
801077a7:	57                   	push   %edi
801077a8:	56                   	push   %esi
801077a9:	53                   	push   %ebx
801077aa:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
801077ad:	e8 1e c9 ff ff       	call   801040d0 <myproc>
801077b2:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
801077b4:	8b 45 10             	mov    0x10(%ebp),%eax
801077b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077ba:	85 c0                	test   %eax,%eax
801077bc:	0f 88 36 02 00 00    	js     801079f8 <allocuvm+0x258>
  if(newsz < oldsz)
801077c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801077c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801077c8:	0f 82 ea 01 00 00    	jb     801079b8 <allocuvm+0x218>
  a = PGROUNDUP(oldsz);
801077ce:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
801077d4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; a < newsz; a += PGSIZE){
801077da:	39 7d 10             	cmp    %edi,0x10(%ebp)
801077dd:	0f 87 18 01 00 00    	ja     801078fb <allocuvm+0x15b>
801077e3:	e9 d3 01 00 00       	jmp    801079bb <allocuvm+0x21b>
801077e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
        curproc->swappedPages[curproc->num_swap].isused = 1;
801077f0:	8b 8b 8c 02 00 00    	mov    0x28c(%ebx),%ecx
        int swap_offset = curproc->free_head->off;
801077f6:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
801077fc:	8b 30                	mov    (%eax),%esi
        curproc->swappedPages[curproc->num_swap].isused = 1;
801077fe:	89 c8                	mov    %ecx,%eax
        curproc->num_swap ++;
80107800:	83 c1 01             	add    $0x1,%ecx
80107803:	c1 e0 04             	shl    $0x4,%eax
80107806:	01 d8                	add    %ebx,%eax
        curproc->swappedPages[curproc->num_swap].isused = 1;
80107808:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
8010780f:	00 00 00 
        curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107812:	8b 93 80 02 00 00    	mov    0x280(%ebx),%edx
80107818:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
8010781e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
80107821:	8b 53 04             	mov    0x4(%ebx),%edx
        curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107824:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
8010782a:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107830:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        curproc->num_swap ++;
80107833:	89 8b 8c 02 00 00    	mov    %ecx,0x28c(%ebx)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107839:	8b 83 78 02 00 00    	mov    0x278(%ebx),%eax
8010783f:	31 c9                	xor    %ecx,%ecx
80107841:	e8 ea f8 ff ff       	call   80107130 <walkpgdir>
        if(!(*evicted_pte & PTE_P))
80107846:	8b 10                	mov    (%eax),%edx
80107848:	f6 c2 01             	test   $0x1,%dl
8010784b:	0f 84 3f 02 00 00    	je     80107a90 <allocuvm+0x2f0>
        char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107851:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        kfree(P2V(evicted_pa));
80107857:	83 ec 0c             	sub    $0xc,%esp
8010785a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010785d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107863:	52                   	push   %edx
80107864:	e8 c7 af ff ff       	call   80102830 <kfree>
        *evicted_pte &= ~PTE_P;
80107869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010786c:	8b 10                	mov    (%eax),%edx
8010786e:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
80107874:	80 ce 02             	or     $0x2,%dh
80107877:	89 10                	mov    %edx,(%eax)
        newpage->pgdir = pgdir; // ??? 
80107879:	8b 45 08             	mov    0x8(%ebp),%eax
        newpage->isused = 1;
8010787c:	c7 83 7c 02 00 00 01 	movl   $0x1,0x27c(%ebx)
80107883:	00 00 00 
        newpage->pgdir = pgdir; // ??? 
80107886:	89 83 78 02 00 00    	mov    %eax,0x278(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
8010788c:	8b 43 04             	mov    0x4(%ebx),%eax
        newpage->swap_offset = -1;
8010788f:	c7 83 84 02 00 00 ff 	movl   $0xffffffff,0x284(%ebx)
80107896:	ff ff ff 
        newpage->virt_addr = (char*)a;
80107899:	89 bb 80 02 00 00    	mov    %edi,0x280(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
8010789f:	05 00 00 00 80       	add    $0x80000000,%eax
801078a4:	0f 22 d8             	mov    %eax,%cr3
        if(curproc->free_head->next == 0)
801078a7:	8b 93 90 02 00 00    	mov    0x290(%ebx),%edx
801078ad:	83 c4 10             	add    $0x10,%esp
801078b0:	8b 42 04             	mov    0x4(%edx),%eax
801078b3:	85 c0                	test   %eax,%eax
801078b5:	0f 84 15 01 00 00    	je     801079d0 <allocuvm+0x230>
          kfree((char*)curproc->free_head->prev);
801078bb:	83 ec 0c             	sub    $0xc,%esp
          curproc->free_head = curproc->free_head->next;
801078be:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
          kfree((char*)curproc->free_head->prev);
801078c4:	ff 70 08             	pushl  0x8(%eax)
801078c7:	e8 64 af ff ff       	call   80102830 <kfree>
801078cc:	83 c4 10             	add    $0x10,%esp
        if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
801078cf:	68 00 10 00 00       	push   $0x1000
801078d4:	56                   	push   %esi
801078d5:	ff b3 80 02 00 00    	pushl  0x280(%ebx)
801078db:	53                   	push   %ebx
801078dc:	e8 ef aa ff ff       	call   801023d0 <writeToSwapFile>
801078e1:	83 c4 10             	add    $0x10,%esp
801078e4:	85 c0                	test   %eax,%eax
801078e6:	0f 88 97 01 00 00    	js     80107a83 <allocuvm+0x2e3>
  for(; a < newsz; a += PGSIZE){
801078ec:	81 c7 00 10 00 00    	add    $0x1000,%edi
801078f2:	39 7d 10             	cmp    %edi,0x10(%ebp)
801078f5:	0f 86 c0 00 00 00    	jbe    801079bb <allocuvm+0x21b>
    mem = kalloc();
801078fb:	e8 30 b2 ff ff       	call   80102b30 <kalloc>
80107900:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107902:	85 c0                	test   %eax,%eax
80107904:	0f 84 06 01 00 00    	je     80107a10 <allocuvm+0x270>
    memset(mem, 0, PGSIZE);
8010790a:	83 ec 04             	sub    $0x4,%esp
8010790d:	68 00 10 00 00       	push   $0x1000
80107912:	6a 00                	push   $0x0
80107914:	50                   	push   %eax
80107915:	e8 a6 d6 ff ff       	call   80104fc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010791a:	58                   	pop    %eax
8010791b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107921:	5a                   	pop    %edx
80107922:	6a 06                	push   $0x6
80107924:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107929:	89 fa                	mov    %edi,%edx
8010792b:	50                   	push   %eax
8010792c:	8b 45 08             	mov    0x8(%ebp),%eax
8010792f:	e8 7c f8 ff ff       	call   801071b0 <mappages>
80107934:	83 c4 10             	add    $0x10,%esp
80107937:	85 c0                	test   %eax,%eax
80107939:	0f 88 09 01 00 00    	js     80107a48 <allocuvm+0x2a8>
    if(curproc->pid > 2) {
8010793f:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80107943:	7e a7                	jle    801078ec <allocuvm+0x14c>
      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107945:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
8010794c:	0f 8f 9e fe ff ff    	jg     801077f0 <allocuvm+0x50>

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80107952:	e8 79 c7 ff ff       	call   801040d0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107957:	31 d2                	xor    %edx,%edx
80107959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107960:	89 d1                	mov    %edx,%ecx
80107962:	c1 e1 04             	shl    $0x4,%ecx
80107965:	8b 8c 08 8c 01 00 00 	mov    0x18c(%eax,%ecx,1),%ecx
8010796c:	85 c9                	test   %ecx,%ecx
8010796e:	74 0d                	je     8010797d <allocuvm+0x1dd>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107970:	83 c2 01             	add    $0x1,%edx
80107973:	83 fa 10             	cmp    $0x10,%edx
80107976:	75 e8                	jne    80107960 <allocuvm+0x1c0>
      return i;
  }
  return -1;
80107978:	ba ff ff ff ff       	mov    $0xffffffff,%edx
          page->pgdir = pgdir;
8010797d:	8b 45 08             	mov    0x8(%ebp),%eax
80107980:	c1 e2 04             	shl    $0x4,%edx
80107983:	01 da                	add    %ebx,%edx
          page->isused = 1;
80107985:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
8010798c:	00 00 00 
          page->pgdir = pgdir;
8010798f:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
          page->swap_offset = -1;
80107995:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
8010799c:	ff ff ff 
          page->virt_addr = (char*)a;
8010799f:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
          curproc->num_ram++;
801079a5:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
801079ac:	e9 3b ff ff ff       	jmp    801078ec <allocuvm+0x14c>
801079b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801079b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
801079bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079c1:	5b                   	pop    %ebx
801079c2:	5e                   	pop    %esi
801079c3:	5f                   	pop    %edi
801079c4:	5d                   	pop    %ebp
801079c5:	c3                   	ret    
801079c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
          curproc->free_tail = 0;
801079d0:	c7 83 94 02 00 00 00 	movl   $0x0,0x294(%ebx)
801079d7:	00 00 00 
          kfree((char*)curproc->free_head);
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	52                   	push   %edx
801079de:	e8 4d ae ff ff       	call   80102830 <kfree>
          curproc->free_head = 0;
801079e3:	83 c4 10             	add    $0x10,%esp
801079e6:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
801079ed:	00 00 00 
801079f0:	e9 da fe ff ff       	jmp    801078cf <allocuvm+0x12f>
801079f5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801079f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801079ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107a10:	83 ec 0c             	sub    $0xc,%esp
80107a13:	68 c8 8d 10 80       	push   $0x80108dc8
80107a18:	e8 93 8c ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107a1d:	83 c4 0c             	add    $0xc,%esp
80107a20:	ff 75 0c             	pushl  0xc(%ebp)
80107a23:	ff 75 10             	pushl  0x10(%ebp)
80107a26:	ff 75 08             	pushl  0x8(%ebp)
80107a29:	e8 a2 fb ff ff       	call   801075d0 <deallocuvm>
      return 0;
80107a2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a35:	83 c4 10             	add    $0x10,%esp
}
80107a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a3e:	5b                   	pop    %ebx
80107a3f:	5e                   	pop    %esi
80107a40:	5f                   	pop    %edi
80107a41:	5d                   	pop    %ebp
80107a42:	c3                   	ret    
80107a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a47:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80107a48:	83 ec 0c             	sub    $0xc,%esp
80107a4b:	68 e0 8d 10 80       	push   $0x80108de0
80107a50:	e8 5b 8c ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107a55:	83 c4 0c             	add    $0xc,%esp
80107a58:	ff 75 0c             	pushl  0xc(%ebp)
80107a5b:	ff 75 10             	pushl  0x10(%ebp)
80107a5e:	ff 75 08             	pushl  0x8(%ebp)
80107a61:	e8 6a fb ff ff       	call   801075d0 <deallocuvm>
      kfree(mem);
80107a66:	89 34 24             	mov    %esi,(%esp)
80107a69:	e8 c2 ad ff ff       	call   80102830 <kfree>
      return 0;
80107a6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a75:	83 c4 10             	add    $0x10,%esp
}
80107a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a7e:	5b                   	pop    %ebx
80107a7f:	5e                   	pop    %esi
80107a80:	5f                   	pop    %edi
80107a81:	5d                   	pop    %ebp
80107a82:	c3                   	ret    
          panic("allocuvm: writeToSwapFile");
80107a83:	83 ec 0c             	sub    $0xc,%esp
80107a86:	68 fc 8d 10 80       	push   $0x80108dfc
80107a8b:	e8 00 89 ff ff       	call   80100390 <panic>
          panic("allocuvm: swap: ram page not present");
80107a90:	83 ec 0c             	sub    $0xc,%esp
80107a93:	68 1c 8f 10 80       	push   $0x80108f1c
80107a98:	e8 f3 88 ff ff       	call   80100390 <panic>
80107a9d:	8d 76 00             	lea    0x0(%esi),%esi

80107aa0 <freevm>:
{
80107aa0:	f3 0f 1e fb          	endbr32 
80107aa4:	55                   	push   %ebp
80107aa5:	89 e5                	mov    %esp,%ebp
80107aa7:	57                   	push   %edi
80107aa8:	56                   	push   %esi
80107aa9:	53                   	push   %ebx
80107aaa:	83 ec 0c             	sub    $0xc,%esp
80107aad:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
80107ab0:	85 f6                	test   %esi,%esi
80107ab2:	74 5d                	je     80107b11 <freevm+0x71>
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107ab4:	83 ec 04             	sub    $0x4,%esp
80107ab7:	89 f3                	mov    %esi,%ebx
80107ab9:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107abf:	6a 00                	push   $0x0
80107ac1:	68 00 00 00 80       	push   $0x80000000
80107ac6:	56                   	push   %esi
80107ac7:	e8 04 fb ff ff       	call   801075d0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107acc:	83 c4 10             	add    $0x10,%esp
80107acf:	eb 0e                	jmp    80107adf <freevm+0x3f>
80107ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ad8:	83 c3 04             	add    $0x4,%ebx
80107adb:	39 df                	cmp    %ebx,%edi
80107add:	74 23                	je     80107b02 <freevm+0x62>
    if(pgdir[i] & PTE_P){
80107adf:	8b 03                	mov    (%ebx),%eax
80107ae1:	a8 01                	test   $0x1,%al
80107ae3:	74 f3                	je     80107ad8 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107aea:	83 ec 0c             	sub    $0xc,%esp
80107aed:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107af0:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107af5:	50                   	push   %eax
80107af6:	e8 35 ad ff ff       	call   80102830 <kfree>
80107afb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107afe:	39 df                	cmp    %ebx,%edi
80107b00:	75 dd                	jne    80107adf <freevm+0x3f>
  kfree((char*)pgdir);
80107b02:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b08:	5b                   	pop    %ebx
80107b09:	5e                   	pop    %esi
80107b0a:	5f                   	pop    %edi
80107b0b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107b0c:	e9 1f ad ff ff       	jmp    80102830 <kfree>
    panic("freevm: no pgdir");
80107b11:	83 ec 0c             	sub    $0xc,%esp
80107b14:	68 16 8e 10 80       	push   $0x80108e16
80107b19:	e8 72 88 ff ff       	call   80100390 <panic>
80107b1e:	66 90                	xchg   %ax,%ax

80107b20 <setupkvm>:
{
80107b20:	f3 0f 1e fb          	endbr32 
80107b24:	55                   	push   %ebp
80107b25:	89 e5                	mov    %esp,%ebp
80107b27:	56                   	push   %esi
80107b28:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107b29:	e8 02 b0 ff ff       	call   80102b30 <kalloc>
80107b2e:	89 c6                	mov    %eax,%esi
80107b30:	85 c0                	test   %eax,%eax
80107b32:	74 42                	je     80107b76 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107b34:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b37:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107b3c:	68 00 10 00 00       	push   $0x1000
80107b41:	6a 00                	push   $0x0
80107b43:	50                   	push   %eax
80107b44:	e8 77 d4 ff ff       	call   80104fc0 <memset>
80107b49:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107b4c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b4f:	83 ec 08             	sub    $0x8,%esp
80107b52:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107b55:	ff 73 0c             	pushl  0xc(%ebx)
80107b58:	8b 13                	mov    (%ebx),%edx
80107b5a:	50                   	push   %eax
80107b5b:	29 c1                	sub    %eax,%ecx
80107b5d:	89 f0                	mov    %esi,%eax
80107b5f:	e8 4c f6 ff ff       	call   801071b0 <mappages>
80107b64:	83 c4 10             	add    $0x10,%esp
80107b67:	85 c0                	test   %eax,%eax
80107b69:	78 15                	js     80107b80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b6b:	83 c3 10             	add    $0x10,%ebx
80107b6e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107b74:	75 d6                	jne    80107b4c <setupkvm+0x2c>
}
80107b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b79:	89 f0                	mov    %esi,%eax
80107b7b:	5b                   	pop    %ebx
80107b7c:	5e                   	pop    %esi
80107b7d:	5d                   	pop    %ebp
80107b7e:	c3                   	ret    
80107b7f:	90                   	nop
      cprintf("mappages failed on setupkvm");
80107b80:	83 ec 0c             	sub    $0xc,%esp
80107b83:	68 27 8e 10 80       	push   $0x80108e27
80107b88:	e8 23 8b ff ff       	call   801006b0 <cprintf>
      freevm(pgdir);
80107b8d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107b90:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b92:	e8 09 ff ff ff       	call   80107aa0 <freevm>
      return 0;
80107b97:	83 c4 10             	add    $0x10,%esp
}
80107b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b9d:	89 f0                	mov    %esi,%eax
80107b9f:	5b                   	pop    %ebx
80107ba0:	5e                   	pop    %esi
80107ba1:	5d                   	pop    %ebp
80107ba2:	c3                   	ret    
80107ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107bb0 <kvmalloc>:
{
80107bb0:	f3 0f 1e fb          	endbr32 
80107bb4:	55                   	push   %ebp
80107bb5:	89 e5                	mov    %esp,%ebp
80107bb7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107bba:	e8 61 ff ff ff       	call   80107b20 <setupkvm>
80107bbf:	a3 e4 1b 19 80       	mov    %eax,0x80191be4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80107bc9:	0f 22 d8             	mov    %eax,%cr3
}
80107bcc:	c9                   	leave  
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax

80107bd0 <clearpteu>:
{
80107bd0:	f3 0f 1e fb          	endbr32 
80107bd4:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107bd5:	31 c9                	xor    %ecx,%ecx
{
80107bd7:	89 e5                	mov    %esp,%ebp
80107bd9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80107be2:	e8 49 f5 ff ff       	call   80107130 <walkpgdir>
  if(pte == 0)
80107be7:	85 c0                	test   %eax,%eax
80107be9:	74 05                	je     80107bf0 <clearpteu+0x20>
  *pte &= ~PTE_U;
80107beb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107bee:	c9                   	leave  
80107bef:	c3                   	ret    
    panic("clearpteu");
80107bf0:	83 ec 0c             	sub    $0xc,%esp
80107bf3:	68 43 8e 10 80       	push   $0x80108e43
80107bf8:	e8 93 87 ff ff       	call   80100390 <panic>
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi

80107c00 <cowuvm>:
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	57                   	push   %edi
80107c08:	56                   	push   %esi
80107c09:	53                   	push   %ebx
80107c0a:	83 ec 0c             	sub    $0xc,%esp
  if((d = setupkvm()) == 0)
80107c0d:	e8 0e ff ff ff       	call   80107b20 <setupkvm>
80107c12:	89 c6                	mov    %eax,%esi
80107c14:	85 c0                	test   %eax,%eax
80107c16:	0f 84 9a 00 00 00    	je     80107cb6 <cowuvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE)
80107c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c1f:	85 c0                	test   %eax,%eax
80107c21:	0f 84 8f 00 00 00    	je     80107cb6 <cowuvm+0xb6>
80107c27:	31 ff                	xor    %edi,%edi
80107c29:	eb 25                	jmp    80107c50 <cowuvm+0x50>
80107c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c2f:	90                   	nop
    refInc(virt_addr);
80107c30:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107c33:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    refInc(virt_addr);
80107c39:	53                   	push   %ebx
80107c3a:	e8 21 b0 ff ff       	call   80102c60 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107c3f:	0f 01 3f             	invlpg (%edi)
  for(i = 0; i < sz; i += PGSIZE)
80107c42:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107c48:	83 c4 10             	add    $0x10,%esp
80107c4b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107c4e:	76 66                	jbe    80107cb6 <cowuvm+0xb6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c50:	8b 45 08             	mov    0x8(%ebp),%eax
80107c53:	31 c9                	xor    %ecx,%ecx
80107c55:	89 fa                	mov    %edi,%edx
80107c57:	e8 d4 f4 ff ff       	call   80107130 <walkpgdir>
80107c5c:	85 c0                	test   %eax,%eax
80107c5e:	74 6d                	je     80107ccd <cowuvm+0xcd>
    if(!(*pte & PTE_P))
80107c60:	8b 08                	mov    (%eax),%ecx
80107c62:	f6 c1 01             	test   $0x1,%cl
80107c65:	74 59                	je     80107cc0 <cowuvm+0xc0>
    *pte &= ~PTE_W;
80107c67:	89 cb                	mov    %ecx,%ebx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c69:	83 ec 08             	sub    $0x8,%esp
80107c6c:	89 fa                	mov    %edi,%edx
    *pte &= ~PTE_W;
80107c6e:	83 e3 fd             	and    $0xfffffffd,%ebx
80107c71:	80 cf 04             	or     $0x4,%bh
80107c74:	89 18                	mov    %ebx,(%eax)
    pa = PTE_ADDR(*pte);
80107c76:	89 cb                	mov    %ecx,%ebx
    flags = PTE_FLAGS(*pte);
80107c78:	81 e1 fd 0f 00 00    	and    $0xffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c7e:	89 f0                	mov    %esi,%eax
    flags = PTE_FLAGS(*pte);
80107c80:	80 cd 04             	or     $0x4,%ch
80107c83:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c89:	51                   	push   %ecx
80107c8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c8f:	53                   	push   %ebx
80107c90:	e8 1b f5 ff ff       	call   801071b0 <mappages>
80107c95:	83 c4 10             	add    $0x10,%esp
80107c98:	85 c0                	test   %eax,%eax
80107c9a:	79 94                	jns    80107c30 <cowuvm+0x30>
  cprintf("bad: cowuvm\n");
80107c9c:	83 ec 0c             	sub    $0xc,%esp
80107c9f:	68 75 8e 10 80       	push   $0x80108e75
80107ca4:	e8 07 8a ff ff       	call   801006b0 <cprintf>
  freevm(d);
80107ca9:	89 34 24             	mov    %esi,(%esp)
  return 0;
80107cac:	31 f6                	xor    %esi,%esi
  freevm(d);
80107cae:	e8 ed fd ff ff       	call   80107aa0 <freevm>
  return 0;
80107cb3:	83 c4 10             	add    $0x10,%esp
}
80107cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb9:	89 f0                	mov    %esi,%eax
80107cbb:	5b                   	pop    %ebx
80107cbc:	5e                   	pop    %esi
80107cbd:	5f                   	pop    %edi
80107cbe:	5d                   	pop    %ebp
80107cbf:	c3                   	ret    
      panic("cowuvm: page not present");
80107cc0:	83 ec 0c             	sub    $0xc,%esp
80107cc3:	68 5c 8e 10 80       	push   $0x80108e5c
80107cc8:	e8 c3 86 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107ccd:	83 ec 0c             	sub    $0xc,%esp
80107cd0:	68 4d 8e 10 80       	push   $0x80108e4d
80107cd5:	e8 b6 86 ff ff       	call   80100390 <panic>
80107cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ce0 <getSwappedPageIndex>:
{
80107ce0:	f3 0f 1e fb          	endbr32 
80107ce4:	55                   	push   %ebp
80107ce5:	89 e5                	mov    %esp,%ebp
80107ce7:	53                   	push   %ebx
80107ce8:	83 ec 04             	sub    $0x4,%esp
80107ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107cee:	e8 dd c3 ff ff       	call   801040d0 <myproc>
80107cf3:	89 c1                	mov    %eax,%ecx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107cf5:	31 c0                	xor    %eax,%eax
80107cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cfe:	66 90                	xchg   %ax,%ax
    if(curproc->swappedPages[i].virt_addr == va)
80107d00:	89 c2                	mov    %eax,%edx
80107d02:	c1 e2 04             	shl    $0x4,%edx
80107d05:	39 9c 11 90 00 00 00 	cmp    %ebx,0x90(%ecx,%edx,1)
80107d0c:	74 0d                	je     80107d1b <getSwappedPageIndex+0x3b>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d0e:	83 c0 01             	add    $0x1,%eax
80107d11:	83 f8 10             	cmp    $0x10,%eax
80107d14:	75 ea                	jne    80107d00 <getSwappedPageIndex+0x20>
  return -1;
80107d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d1b:	83 c4 04             	add    $0x4,%esp
80107d1e:	5b                   	pop    %ebx
80107d1f:	5d                   	pop    %ebp
80107d20:	c3                   	ret    
80107d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2f:	90                   	nop

80107d30 <pagefault>:
{
80107d30:	f3 0f 1e fb          	endbr32 
80107d34:	55                   	push   %ebp
80107d35:	89 e5                	mov    %esp,%ebp
80107d37:	57                   	push   %edi
80107d38:	56                   	push   %esi
80107d39:	53                   	push   %ebx
80107d3a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107d3d:	e8 8e c3 ff ff       	call   801040d0 <myproc>
80107d42:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107d44:	0f 20 d3             	mov    %cr2,%ebx
  uint err = curproc->tf->err;
80107d47:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107d4a:	89 df                	mov    %ebx,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d4c:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107d4e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  uint err = curproc->tf->err;
80107d54:	8b 40 34             	mov    0x34(%eax),%eax
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d57:	89 fa                	mov    %edi,%edx
  uint err = curproc->tf->err;
80107d59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d5c:	8b 46 04             	mov    0x4(%esi),%eax
80107d5f:	e8 cc f3 ff ff       	call   80107130 <walkpgdir>
  if(*pte & PTE_PG) // page was paged out
80107d64:	f7 00 00 02 00 00    	testl  $0x200,(%eax)
80107d6a:	0f 84 c0 01 00 00    	je     80107f30 <pagefault+0x200>
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80107d70:	83 ec 04             	sub    $0x4,%esp
80107d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d76:	8d 46 6c             	lea    0x6c(%esi),%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d79:	31 db                	xor    %ebx,%ebx
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80107d7b:	ff 76 10             	pushl  0x10(%esi)
80107d7e:	50                   	push   %eax
80107d7f:	68 44 8f 10 80       	push   $0x80108f44
80107d84:	e8 27 89 ff ff       	call   801006b0 <cprintf>
    new_page = kalloc();
80107d89:	e8 a2 ad ff ff       	call   80102b30 <kalloc>
    *pte |= V2P(new_page);
80107d8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    new_page = kalloc();
80107d91:	89 c1                	mov    %eax,%ecx
    *pte |= V2P(new_page);
80107d93:	8b 02                	mov    (%edx),%eax
80107d95:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107d9b:	25 ff 0d 00 00       	and    $0xdff,%eax
80107da0:	09 c8                	or     %ecx,%eax
80107da2:	83 c8 07             	or     $0x7,%eax
80107da5:	89 02                	mov    %eax,(%edx)
  struct proc* curproc = myproc();
80107da7:	e8 24 c3 ff ff       	call   801040d0 <myproc>
80107dac:	83 c4 10             	add    $0x10,%esp
80107daf:	90                   	nop
    if(curproc->swappedPages[i].virt_addr == va)
80107db0:	89 da                	mov    %ebx,%edx
80107db2:	c1 e2 04             	shl    $0x4,%edx
80107db5:	3b bc 10 90 00 00 00 	cmp    0x90(%eax,%edx,1),%edi
80107dbc:	0f 84 ae 01 00 00    	je     80107f70 <pagefault+0x240>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107dc2:	83 c3 01             	add    $0x1,%ebx
80107dc5:	83 fb 10             	cmp    $0x10,%ebx
80107dc8:	75 e6                	jne    80107db0 <pagefault+0x80>
80107dca:	b8 78 00 00 00       	mov    $0x78,%eax
  return -1;
80107dcf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    struct page *swap_page = &curproc->swappedPages[index];
80107dd4:	c1 e3 04             	shl    $0x4,%ebx
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107dd7:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80107ddc:	01 f0                	add    %esi,%eax
80107dde:	01 f3                	add    %esi,%ebx
80107de0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107de3:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80107de9:	68 00 d6 10 80       	push   $0x8010d600
80107dee:	56                   	push   %esi
80107def:	e8 0c a6 ff ff       	call   80102400 <readFromSwapFile>
80107df4:	83 c4 10             	add    $0x10,%esp
80107df7:	85 c0                	test   %eax,%eax
80107df9:	0f 88 d7 02 00 00    	js     801080d6 <pagefault+0x3a6>
    struct fblock *new_block = (struct fblock*)kalloc();
80107dff:	e8 2c ad ff ff       	call   80102b30 <kalloc>
    new_block->off = swap_page->swap_offset;
80107e04:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
    new_block->next = 0;
80107e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80107e11:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80107e13:	8b 96 94 02 00 00    	mov    0x294(%esi),%edx
80107e19:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80107e1c:	85 d2                	test   %edx,%edx
80107e1e:	0f 84 cc 01 00 00    	je     80107ff0 <pagefault+0x2c0>
      curproc->free_tail->next = new_block;
80107e24:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80107e27:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80107e2a:	89 86 94 02 00 00    	mov    %eax,0x294(%esi)
    memmove((void*)start_page, buffer, PGSIZE);
80107e30:	68 00 10 00 00       	push   $0x1000
80107e35:	68 00 d6 10 80       	push   $0x8010d600
80107e3a:	57                   	push   %edi
80107e3b:	e8 20 d2 ff ff       	call   80105060 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80107e40:	83 c4 0c             	add    $0xc,%esp
80107e43:	6a 10                	push   $0x10
80107e45:	6a 00                	push   $0x0
80107e47:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e4a:	e8 71 d1 ff ff       	call   80104fc0 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80107e4f:	83 c4 10             	add    $0x10,%esp
80107e52:	83 be 88 02 00 00 0f 	cmpl   $0xf,0x288(%esi)
80107e59:	0f 8e c9 01 00 00    	jle    80108028 <pagefault+0x2f8>
      int swap_offset = curproc->free_head->off;
80107e5f:	8b 96 90 02 00 00    	mov    0x290(%esi),%edx
80107e65:	8b 02                	mov    (%edx),%eax
80107e67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80107e6a:	8b 42 04             	mov    0x4(%edx),%eax
80107e6d:	85 c0                	test   %eax,%eax
80107e6f:	0f 84 8b 01 00 00    	je     80108000 <pagefault+0x2d0>
        kfree((char*)curproc->free_head->prev);
80107e75:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107e78:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
        kfree((char*)curproc->free_head->prev);
80107e7e:	ff 70 08             	pushl  0x8(%eax)
80107e81:	e8 aa a9 ff ff       	call   80102830 <kfree>
80107e86:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80107e89:	68 00 10 00 00       	push   $0x1000
80107e8e:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e91:	ff b6 80 02 00 00    	pushl  0x280(%esi)
80107e97:	56                   	push   %esi
80107e98:	e8 33 a5 ff ff       	call   801023d0 <writeToSwapFile>
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	0f 88 3b 02 00 00    	js     801080e3 <pagefault+0x3b3>
      swap_page->virt_addr = ram_page->virt_addr;
80107ea8:	8b 96 80 02 00 00    	mov    0x280(%esi),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107eae:	31 c9                	xor    %ecx,%ecx
      swap_page->virt_addr = ram_page->virt_addr;
80107eb0:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
      swap_page->pgdir = ram_page->pgdir;
80107eb6:	8b 86 78 02 00 00    	mov    0x278(%esi),%eax
      swap_page->isused = 1;
80107ebc:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80107ec3:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80107ec6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
      swap_page->swap_offset = swap_offset;
80107ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ecf:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107ed5:	8b 46 04             	mov    0x4(%esi),%eax
80107ed8:	e8 53 f2 ff ff       	call   80107130 <walkpgdir>
      if(!(*pte & PTE_P))
80107edd:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107edf:	89 c3                	mov    %eax,%ebx
      if(!(*pte & PTE_P))
80107ee1:	f6 c2 01             	test   $0x1,%dl
80107ee4:	0f 84 06 02 00 00    	je     801080f0 <pagefault+0x3c0>
      ramPa = (void*)PTE_ADDR(*pte);
80107eea:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80107ef0:	83 ec 0c             	sub    $0xc,%esp
80107ef3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107ef9:	52                   	push   %edx
80107efa:	e8 31 a9 ff ff       	call   80102830 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80107eff:	8b 03                	mov    (%ebx),%eax
80107f01:	25 fe 0f 00 00       	and    $0xffe,%eax
80107f06:	80 cc 02             	or     $0x2,%ah
80107f09:	89 03                	mov    %eax,(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107f0b:	8b 46 04             	mov    0x4(%esi),%eax
80107f0e:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f13:	0f 22 d8             	mov    %eax,%cr3
      ram_page->virt_addr = start_page;
80107f16:	89 be 80 02 00 00    	mov    %edi,0x280(%esi)
80107f1c:	83 c4 10             	add    $0x10,%esp
}
80107f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f22:	5b                   	pop    %ebx
80107f23:	5e                   	pop    %esi
80107f24:	5f                   	pop    %edi
80107f25:	5d                   	pop    %ebp
80107f26:	c3                   	ret    
80107f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f2e:	66 90                	xchg   %ax,%ax
      cprintf("page was not paged out\n");
80107f30:	83 ec 0c             	sub    $0xc,%esp
80107f33:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f36:	68 9d 8e 10 80       	push   $0x80108e9d
80107f3b:	e8 70 87 ff ff       	call   801006b0 <cprintf>
    if(va >= KERNBASE || pte == 0)
80107f40:	83 c4 10             	add    $0x10,%esp
80107f43:	85 db                	test   %ebx,%ebx
80107f45:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107f48:	78 76                	js     80107fc0 <pagefault+0x290>
  if(err & FEC_WR)
80107f4a:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
80107f4e:	74 0a                	je     80107f5a <pagefault+0x22a>
    if(!(*pte & PTE_COW)) 
80107f50:	8b 3a                	mov    (%edx),%edi
80107f52:	f7 c7 00 04 00 00    	test   $0x400,%edi
80107f58:	75 26                	jne    80107f80 <pagefault+0x250>
    curproc->killed = 1;
80107f5a:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
}
80107f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f64:	5b                   	pop    %ebx
80107f65:	5e                   	pop    %esi
80107f66:	5f                   	pop    %edi
80107f67:	5d                   	pop    %ebp
80107f68:	c3                   	ret    
80107f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f70:	89 d8                	mov    %ebx,%eax
80107f72:	c1 e0 04             	shl    $0x4,%eax
80107f75:	05 88 00 00 00       	add    $0x88,%eax
80107f7a:	e9 55 fe ff ff       	jmp    80107dd4 <pagefault+0xa4>
80107f7f:	90                   	nop
      pa = PTE_ADDR(*pte);
80107f80:	89 fe                	mov    %edi,%esi
      ref_count = getRefs(virt_addr);
80107f82:	83 ec 0c             	sub    $0xc,%esp
80107f85:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107f88:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      char *virt_addr = P2V(pa);
80107f8e:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      ref_count = getRefs(virt_addr);
80107f94:	56                   	push   %esi
80107f95:	e8 36 ad ff ff       	call   80102cd0 <getRefs>
      if (ref_count > 1) // more than one reference
80107f9a:	83 c4 10             	add    $0x10,%esp
80107f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fa0:	83 f8 01             	cmp    $0x1,%eax
80107fa3:	0f 8f e7 00 00 00    	jg     80108090 <pagefault+0x360>
        *pte &= ~PTE_COW; // turn COW off
80107fa9:	8b 02                	mov    (%edx),%eax
80107fab:	80 e4 fb             	and    $0xfb,%ah
80107fae:	83 c8 02             	or     $0x2,%eax
80107fb1:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107fb3:	0f 01 3b             	invlpg (%ebx)
}  
80107fb6:	e9 64 ff ff ff       	jmp    80107f1f <pagefault+0x1ef>
80107fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fbf:	90                   	nop
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80107fc0:	83 ec 04             	sub    $0x4,%esp
80107fc3:	8d 46 6c             	lea    0x6c(%esi),%eax
80107fc6:	50                   	push   %eax
80107fc7:	ff 76 10             	pushl  0x10(%esi)
80107fca:	68 98 8f 10 80       	push   $0x80108f98
80107fcf:	e8 dc 86 ff ff       	call   801006b0 <cprintf>
      curproc->killed = 1;
80107fd4:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
      return;
80107fdb:	83 c4 10             	add    $0x10,%esp
}
80107fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fe1:	5b                   	pop    %ebx
80107fe2:	5e                   	pop    %esi
80107fe3:	5f                   	pop    %edi
80107fe4:	5d                   	pop    %ebp
80107fe5:	c3                   	ret    
80107fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->free_head = new_block;
80107ff0:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
80107ff6:	e9 2c fe ff ff       	jmp    80107e27 <pagefault+0xf7>
80107ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fff:	90                   	nop
        curproc->free_tail = 0;
80108000:	c7 86 94 02 00 00 00 	movl   $0x0,0x294(%esi)
80108007:	00 00 00 
        kfree((char*)curproc->free_head);
8010800a:	83 ec 0c             	sub    $0xc,%esp
8010800d:	52                   	push   %edx
8010800e:	e8 1d a8 ff ff       	call   80102830 <kfree>
        curproc->free_head = 0;
80108013:	83 c4 10             	add    $0x10,%esp
80108016:	c7 86 90 02 00 00 00 	movl   $0x0,0x290(%esi)
8010801d:	00 00 00 
80108020:	e9 64 fe ff ff       	jmp    80107e89 <pagefault+0x159>
80108025:	8d 76 00             	lea    0x0(%esi),%esi
  struct proc * currproc = myproc();
80108028:	e8 a3 c0 ff ff       	call   801040d0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
8010802d:	31 d2                	xor    %edx,%edx
8010802f:	90                   	nop
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108030:	89 d1                	mov    %edx,%ecx
80108032:	c1 e1 04             	shl    $0x4,%ecx
80108035:	8b 8c 08 8c 01 00 00 	mov    0x18c(%eax,%ecx,1),%ecx
8010803c:	85 c9                	test   %ecx,%ecx
8010803e:	74 0d                	je     8010804d <pagefault+0x31d>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108040:	83 c2 01             	add    $0x1,%edx
80108043:	83 fa 10             	cmp    $0x10,%edx
80108046:	75 e8                	jne    80108030 <pagefault+0x300>
  return -1;
80108048:	ba ff ff ff ff       	mov    $0xffffffff,%edx
      curproc->ramPages[new_indx].virt_addr = start_page;
8010804d:	c1 e2 04             	shl    $0x4,%edx
80108050:	01 f2                	add    %esi,%edx
80108052:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
      curproc->ramPages[new_indx].isused = 1;
80108058:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
8010805f:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108062:	8b 46 04             	mov    0x4(%esi),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108065:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
8010806c:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
8010806f:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
      curproc->num_ram++;      
80108075:	83 86 88 02 00 00 01 	addl   $0x1,0x288(%esi)
      curproc->num_swap--;
8010807c:	83 ae 8c 02 00 00 01 	subl   $0x1,0x28c(%esi)
}
80108083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108086:	5b                   	pop    %ebx
80108087:	5e                   	pop    %esi
80108088:	5f                   	pop    %edi
80108089:	5d                   	pop    %ebp
8010808a:	c3                   	ret    
8010808b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010808f:	90                   	nop
80108090:	89 55 e0             	mov    %edx,-0x20(%ebp)
      flags = PTE_FLAGS(*pte);
80108093:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
        new_page = kalloc();
80108099:	e8 92 aa ff ff       	call   80102b30 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
8010809e:	83 ec 04             	sub    $0x4,%esp
801080a1:	68 00 10 00 00       	push   $0x1000
801080a6:	56                   	push   %esi
801080a7:	50                   	push   %eax
801080a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080ab:	e8 b0 cf ff ff       	call   80105060 <memmove>
        new_pa = V2P(new_page);
801080b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801080b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
        new_pa = V2P(new_page);
801080b6:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801080bc:	09 cf                	or     %ecx,%edi
801080be:	83 cf 03             	or     $0x3,%edi
801080c1:	89 3a                	mov    %edi,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801080c3:	0f 01 3b             	invlpg (%ebx)
        refDec(virt_addr); // decrement old page's ref count
801080c6:	89 34 24             	mov    %esi,(%esp)
801080c9:	e8 22 ab ff ff       	call   80102bf0 <refDec>
801080ce:	83 c4 10             	add    $0x10,%esp
801080d1:	e9 49 fe ff ff       	jmp    80107f1f <pagefault+0x1ef>
      panic("allocuvm: readFromSwapFile");
801080d6:	83 ec 0c             	sub    $0xc,%esp
801080d9:	68 82 8e 10 80       	push   $0x80108e82
801080de:	e8 ad 82 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801080e3:	83 ec 0c             	sub    $0xc,%esp
801080e6:	68 fc 8d 10 80       	push   $0x80108dfc
801080eb:	e8 a0 82 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
801080f0:	83 ec 0c             	sub    $0xc,%esp
801080f3:	68 74 8f 10 80       	push   $0x80108f74
801080f8:	e8 93 82 ff ff       	call   80100390 <panic>
801080fd:	8d 76 00             	lea    0x0(%esi),%esi

80108100 <copyuvm>:
{
80108100:	f3 0f 1e fb          	endbr32 
80108104:	55                   	push   %ebp
80108105:	89 e5                	mov    %esp,%ebp
80108107:	57                   	push   %edi
80108108:	56                   	push   %esi
80108109:	53                   	push   %ebx
8010810a:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
8010810d:	e8 0e fa ff ff       	call   80107b20 <setupkvm>
80108112:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108115:	85 c0                	test   %eax,%eax
80108117:	0f 84 ba 00 00 00    	je     801081d7 <copyuvm+0xd7>
  for(i = 0; i < sz; i += PGSIZE){
8010811d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80108120:	85 db                	test   %ebx,%ebx
80108122:	0f 84 af 00 00 00    	je     801081d7 <copyuvm+0xd7>
80108128:	31 f6                	xor    %esi,%esi
8010812a:	eb 65                	jmp    80108191 <copyuvm+0x91>
8010812c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
80108130:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108132:	25 ff 0f 00 00       	and    $0xfff,%eax
80108137:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010813a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108140:	e8 eb a9 ff ff       	call   80102b30 <kalloc>
80108145:	89 c3                	mov    %eax,%ebx
80108147:	85 c0                	test   %eax,%eax
80108149:	0f 84 b1 00 00 00    	je     80108200 <copyuvm+0x100>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010814f:	83 ec 04             	sub    $0x4,%esp
80108152:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108158:	68 00 10 00 00       	push   $0x1000
8010815d:	57                   	push   %edi
8010815e:	50                   	push   %eax
8010815f:	e8 fc ce ff ff       	call   80105060 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108164:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010816a:	5a                   	pop    %edx
8010816b:	59                   	pop    %ecx
8010816c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010816f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108174:	89 f2                	mov    %esi,%edx
80108176:	50                   	push   %eax
80108177:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010817a:	e8 31 f0 ff ff       	call   801071b0 <mappages>
8010817f:	83 c4 10             	add    $0x10,%esp
80108182:	85 c0                	test   %eax,%eax
80108184:	78 62                	js     801081e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108186:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010818c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010818f:	76 46                	jbe    801081d7 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108191:	8b 45 08             	mov    0x8(%ebp),%eax
80108194:	31 c9                	xor    %ecx,%ecx
80108196:	89 f2                	mov    %esi,%edx
80108198:	e8 93 ef ff ff       	call   80107130 <walkpgdir>
8010819d:	85 c0                	test   %eax,%eax
8010819f:	0f 84 93 00 00 00    	je     80108238 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801081a5:	8b 00                	mov    (%eax),%eax
801081a7:	a9 01 02 00 00       	test   $0x201,%eax
801081ac:	74 7d                	je     8010822b <copyuvm+0x12b>
    if (*pte & PTE_PG) {
801081ae:	f6 c4 02             	test   $0x2,%ah
801081b1:	0f 84 79 ff ff ff    	je     80108130 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
801081b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081ba:	89 f2                	mov    %esi,%edx
801081bc:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801081c1:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801081c7:	e8 64 ef ff ff       	call   80107130 <walkpgdir>
      *pte = PTE_U | PTE_W | PTE_PG;
801081cc:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801081d2:	39 75 0c             	cmp    %esi,0xc(%ebp)
801081d5:	77 ba                	ja     80108191 <copyuvm+0x91>
}
801081d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081dd:	5b                   	pop    %ebx
801081de:	5e                   	pop    %esi
801081df:	5f                   	pop    %edi
801081e0:	5d                   	pop    %ebp
801081e1:	c3                   	ret    
801081e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
801081e8:	83 ec 0c             	sub    $0xc,%esp
801081eb:	68 cf 8e 10 80       	push   $0x80108ecf
801081f0:	e8 bb 84 ff ff       	call   801006b0 <cprintf>
      kfree(mem);
801081f5:	89 1c 24             	mov    %ebx,(%esp)
801081f8:	e8 33 a6 ff ff       	call   80102830 <kfree>
      goto bad;
801081fd:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
80108200:	83 ec 0c             	sub    $0xc,%esp
80108203:	68 e9 8e 10 80       	push   $0x80108ee9
80108208:	e8 a3 84 ff ff       	call   801006b0 <cprintf>
  freevm(d);
8010820d:	58                   	pop    %eax
8010820e:	ff 75 e0             	pushl  -0x20(%ebp)
80108211:	e8 8a f8 ff ff       	call   80107aa0 <freevm>
  return 0;
80108216:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010821d:	83 c4 10             	add    $0x10,%esp
}
80108220:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108226:	5b                   	pop    %ebx
80108227:	5e                   	pop    %esi
80108228:	5f                   	pop    %edi
80108229:	5d                   	pop    %ebp
8010822a:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
8010822b:	83 ec 0c             	sub    $0xc,%esp
8010822e:	68 cc 8f 10 80       	push   $0x80108fcc
80108233:	e8 58 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108238:	83 ec 0c             	sub    $0xc,%esp
8010823b:	68 b5 8e 10 80       	push   $0x80108eb5
80108240:	e8 4b 81 ff ff       	call   80100390 <panic>
80108245:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010824c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108250 <uva2ka>:
{
80108250:	f3 0f 1e fb          	endbr32 
80108254:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80108255:	31 c9                	xor    %ecx,%ecx
{
80108257:	89 e5                	mov    %esp,%ebp
80108259:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010825c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010825f:	8b 45 08             	mov    0x8(%ebp),%eax
80108262:	e8 c9 ee ff ff       	call   80107130 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108267:	8b 00                	mov    (%eax),%eax
}
80108269:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010826a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010826c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108271:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108274:	05 00 00 00 80       	add    $0x80000000,%eax
80108279:	83 fa 05             	cmp    $0x5,%edx
8010827c:	ba 00 00 00 00       	mov    $0x0,%edx
80108281:	0f 45 c2             	cmovne %edx,%eax
}
80108284:	c3                   	ret    
80108285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010828c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108290 <copyout>:
{
80108290:	f3 0f 1e fb          	endbr32 
80108294:	55                   	push   %ebp
80108295:	89 e5                	mov    %esp,%ebp
80108297:	57                   	push   %edi
80108298:	56                   	push   %esi
80108299:	53                   	push   %ebx
8010829a:	83 ec 0c             	sub    $0xc,%esp
8010829d:	8b 75 14             	mov    0x14(%ebp),%esi
801082a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(len > 0){
801082a3:	85 f6                	test   %esi,%esi
801082a5:	75 3c                	jne    801082e3 <copyout+0x53>
801082a7:	eb 67                	jmp    80108310 <copyout+0x80>
801082a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
801082b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801082b3:	89 fb                	mov    %edi,%ebx
801082b5:	29 d3                	sub    %edx,%ebx
801082b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801082bd:	39 f3                	cmp    %esi,%ebx
801082bf:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801082c2:	29 fa                	sub    %edi,%edx
801082c4:	83 ec 04             	sub    $0x4,%esp
801082c7:	01 c2                	add    %eax,%edx
801082c9:	53                   	push   %ebx
801082ca:	ff 75 10             	pushl  0x10(%ebp)
801082cd:	52                   	push   %edx
801082ce:	e8 8d cd ff ff       	call   80105060 <memmove>
    buf += n;
801082d3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801082d6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801082dc:	83 c4 10             	add    $0x10,%esp
801082df:	29 de                	sub    %ebx,%esi
801082e1:	74 2d                	je     80108310 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801082e3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801082e5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801082e8:	89 55 0c             	mov    %edx,0xc(%ebp)
801082eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801082f1:	57                   	push   %edi
801082f2:	ff 75 08             	pushl  0x8(%ebp)
801082f5:	e8 56 ff ff ff       	call   80108250 <uva2ka>
    if(pa0 == 0)
801082fa:	83 c4 10             	add    $0x10,%esp
801082fd:	85 c0                	test   %eax,%eax
801082ff:	75 af                	jne    801082b0 <copyout+0x20>
}
80108301:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108309:	5b                   	pop    %ebx
8010830a:	5e                   	pop    %esi
8010830b:	5f                   	pop    %edi
8010830c:	5d                   	pop    %ebp
8010830d:	c3                   	ret    
8010830e:	66 90                	xchg   %ax,%ax
80108310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108313:	31 c0                	xor    %eax,%eax
}
80108315:	5b                   	pop    %ebx
80108316:	5e                   	pop    %esi
80108317:	5f                   	pop    %edi
80108318:	5d                   	pop    %ebp
80108319:	c3                   	ret    
8010831a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108320 <getNextFreeRamIndex>:
{ 
80108320:	f3 0f 1e fb          	endbr32 
80108324:	55                   	push   %ebp
80108325:	89 e5                	mov    %esp,%ebp
80108327:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
8010832a:	e8 a1 bd ff ff       	call   801040d0 <myproc>
8010832f:	89 c1                	mov    %eax,%ecx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108331:	31 c0                	xor    %eax,%eax
80108333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108337:	90                   	nop
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108338:	89 c2                	mov    %eax,%edx
8010833a:	c1 e2 04             	shl    $0x4,%edx
8010833d:	8b 94 11 8c 01 00 00 	mov    0x18c(%ecx,%edx,1),%edx
80108344:	85 d2                	test   %edx,%edx
80108346:	74 0d                	je     80108355 <getNextFreeRamIndex+0x35>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108348:	83 c0 01             	add    $0x1,%eax
8010834b:	83 f8 10             	cmp    $0x10,%eax
8010834e:	75 e8                	jne    80108338 <getNextFreeRamIndex+0x18>
  return -1;
80108350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108355:	c9                   	leave  
80108356:	c3                   	ret    
