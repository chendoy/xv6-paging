
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 36 10 80       	mov    $0x80103660,%eax
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
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 e0 7b 10 80       	push   $0x80107be0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 11 4c 00 00       	call   80104c70 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 7b 10 80       	push   $0x80107be7
80100097:	50                   	push   %eax
80100098:	e8 93 4a 00 00       	call   80104b30 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 03 4d 00 00       	call   80104df0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 49 4d 00 00       	call   80104eb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 49 00 00       	call   80104b70 <acquiresleep>
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
8010018c:	e8 7f 24 00 00       	call   80102610 <iderw>
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
801001a3:	68 ee 7b 10 80       	push   $0x80107bee
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
801001c2:	e8 49 4a 00 00       	call   80104c10 <holdingsleep>
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
801001d8:	e9 33 24 00 00       	jmp    80102610 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 ff 7b 10 80       	push   $0x80107bff
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
80100203:	e8 08 4a 00 00       	call   80104c10 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 b8 49 00 00       	call   80104bd0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 cc 4b 00 00       	call   80104df0 <acquire>
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
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 3b 4c 00 00       	jmp    80104eb0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 7c 10 80       	push   $0x80107c06
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
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 3a 4b 00 00       	call   80104df0 <acquire>
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
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 46 44 00 00       	call   80104730 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 11 3d 00 00       	call   80104010 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 9d 4b 00 00       	call   80104eb0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
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
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
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
80100365:	e8 46 4b 00 00       	call   80104eb0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
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
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
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
801003ad:	e8 0e 2b 00 00       	call   80102ec0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 7c 10 80       	push   $0x80107c0d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 1b 86 10 80 	movl   $0x8010861b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 af 48 00 00       	call   80104c90 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 7c 10 80       	push   $0x80107c21
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
8010042a:	e8 81 61 00 00       	call   801065b0 <uartputc>
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
80100515:	e8 96 60 00 00       	call   801065b0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 8a 60 00 00       	call   801065b0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 7e 60 00 00       	call   801065b0 <uartputc>
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
80100561:	e8 3a 4a 00 00       	call   80104fa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 85 49 00 00       	call   80104f00 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 7c 10 80       	push   $0x80107c25
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
801005c9:	0f b6 92 50 7c 10 80 	movzbl -0x7fef83b0(%edx),%edx
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
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 8c 47 00 00       	call   80104df0 <acquire>
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
80100697:	e8 14 48 00 00       	call   80104eb0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

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
8010077d:	bb 38 7c 10 80       	mov    $0x80107c38,%ebx
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
801007bd:	e8 2e 46 00 00       	call   80104df0 <acquire>
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
80100828:	e8 83 46 00 00       	call   80104eb0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 7c 10 80       	push   $0x80107c3f
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
80100877:	e8 74 45 00 00       	call   80104df0 <acquire>
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
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
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
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
801009cf:	e8 dc 44 00 00       	call   80104eb0 <release>
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
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
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
801009ff:	e9 ec 3f 00 00       	jmp    801049f0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 cb 3e 00 00       	call   801048f0 <wakeup>
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
80100a3a:	68 48 7c 10 80       	push   $0x80107c48
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 27 42 00 00       	call   80104c70 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 4e 1d 00 00       	call   801027c0 <ioapicenable>
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
80100a90:	e8 7b 35 00 00       	call   80104010 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 b0 28 00 00       	call   80103350 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 0e 03 00 00    	je     80100dc4 <exec+0x344>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
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
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 d8 28 00 00       	call   801033c0 <end_op>
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
80100b0c:	e8 2f 6c 00 00       	call   80107740 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 b4 02 00 00    	je     80100de3 <exec+0x363>
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
80100b73:	e8 08 6a 00 00       	call   80107580 <allocuvm>
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
80100ba9:	e8 12 68 00 00       	call   801073c0 <loaduvm>
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
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 6a 00 00       	call   801076c0 <freevm>
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
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 9a 27 00 00       	call   801033c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 49 69 00 00       	call   80107580 <allocuvm>
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
80100c53:	e8 a8 6b 00 00       	call   80107800 <clearpteu>
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
80100ca3:	e8 58 44 00 00       	call   80105100 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 45 44 00 00       	call   80105100 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 84 6e 00 00       	call   80107b50 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 69 00 00       	call   801076c0 <freevm>
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
80100d33:	e8 18 6e 00 00       	call   80107b50 <copyout>
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
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 4a 43 00 00       	call   801050c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d83:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100d85:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d88:	8b 40 18             	mov    0x18(%eax),%eax
80100d8b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 46 18             	mov    0x18(%esi),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  removeSwapFile(curproc); 
80100d9a:	89 34 24             	mov    %esi,(%esp)
80100d9d:	e8 6e 13 00 00       	call   80102110 <removeSwapFile>
  createSwapFile(curproc);
80100da2:	89 34 24             	mov    %esi,(%esp)
80100da5:	e8 56 15 00 00       	call   80102300 <createSwapFile>
  switchuvm(curproc);
80100daa:	89 34 24             	mov    %esi,(%esp)
80100dad:	e8 7e 64 00 00       	call   80107230 <switchuvm>
  freevm(oldpgdir);
80100db2:	89 3c 24             	mov    %edi,(%esp)
80100db5:	e8 06 69 00 00       	call   801076c0 <freevm>
  return 0;
80100dba:	83 c4 10             	add    $0x10,%esp
80100dbd:	31 c0                	xor    %eax,%eax
80100dbf:	e9 2c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dc4:	e8 f7 25 00 00       	call   801033c0 <end_op>
    cprintf("exec: fail\n");
80100dc9:	83 ec 0c             	sub    $0xc,%esp
80100dcc:	68 61 7c 10 80       	push   $0x80107c61
80100dd1:	e8 da f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dd6:	83 c4 10             	add    $0x10,%esp
80100dd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dde:	e9 0d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de3:	31 ff                	xor    %edi,%edi
80100de5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dea:	e9 29 fe ff ff       	jmp    80100c18 <exec+0x198>
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 6d 7c 10 80       	push   $0x80107c6d
80100dff:	68 c0 0f 11 80       	push   $0x80110fc0
80100e04:	e8 67 3e 00 00       	call   80104c70 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 0f 11 80       	push   $0x80110fc0
80100e25:	e8 c6 3f 00 00       	call   80104df0 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 5a 40 00 00       	call   80104eb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 0f 11 80       	push   $0x80110fc0
80100e6a:	e8 41 40 00 00       	call   80104eb0 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e93:	e8 58 3f 00 00       	call   80104df0 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb0:	e8 fb 3f 00 00       	call   80104eb0 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 74 7c 10 80       	push   $0x80107c74
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee5:	e8 06 3f 00 00       	call   80104df0 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 8b 3f 00 00       	call   80104eb0 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 5d 3f 00 00       	jmp    80104eb0 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 f3 23 00 00       	call   80103350 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 49 24 00 00       	jmp    801033c0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 92 2b 00 00       	call   80103b20 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 7c 7c 10 80       	push   $0x80107c7c
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 46 2c 00 00       	jmp    80103cc0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 86 7c 10 80       	push   $0x80107c86
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 ba 22 00 00       	call   801033c0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 21 22 00 00       	call   80103350 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 5a 22 00 00       	call   801033c0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 8f 7c 10 80       	push   $0x80107c8f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 1a 2a 00 00       	jmp    80103bc0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 95 7c 10 80       	push   $0x80107c95
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 1e 23 00 00       	call   80103530 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 7c 10 80       	push   $0x80107c9f
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 7c 10 80       	push   $0x80107cb2
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 2e 22 00 00       	call   80103530 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 d6 3b 00 00       	call   80104f00 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 fe 21 00 00       	call   80103530 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 81 3a 00 00       	call   80104df0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 d4 3a 00 00       	call   80104eb0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 a6 3a 00 00       	call   80104eb0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 c8 7c 10 80       	push   $0x80107cc8
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 76 20 00 00       	call   80103530 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 d8 7c 10 80       	push   $0x80107cd8
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 66 3a 00 00       	call   80104fa0 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 eb 7c 10 80       	push   $0x80107ceb
80101565:	68 e0 19 11 80       	push   $0x801119e0
8010156a:	e8 01 37 00 00       	call   80104c70 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 f2 7c 10 80       	push   $0x80107cf2
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 a4 35 00 00       	call   80104b30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 19 11 80       	push   $0x801119c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015ad:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015b3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015b9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015bf:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015c5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015cb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015d1:	68 9c 7d 10 80       	push   $0x80107d9c
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 8d 38 00 00       	call   80104f00 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 ab 1e 00 00       	call   80103530 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 f8 7c 10 80       	push   $0x80107cf8
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 86 38 00 00       	call   80104fa0 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 0e 1e 00 00       	call   80103530 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 19 11 80       	push   $0x801119e0
80101753:	e8 98 36 00 00       	call   80104df0 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101763:	e8 48 37 00 00       	call   80104eb0 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 d5 33 00 00       	call   80104b70 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 93 37 00 00       	call   80104fa0 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 10 7d 10 80       	push   $0x80107d10
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 0a 7d 10 80       	push   $0x80107d0a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 a4 33 00 00       	call   80104c10 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 48 33 00 00       	jmp    80104bd0 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 1f 7d 10 80       	push   $0x80107d1f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 b7 32 00 00       	call   80104b70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 fd 32 00 00       	call   80104bd0 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018da:	e8 11 35 00 00       	call   80104df0 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 b7 35 00 00       	jmp    80104eb0 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 19 11 80       	push   $0x801119e0
80101908:	e8 e3 34 00 00       	call   80104df0 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101917:	e8 94 35 00 00       	call   80104eb0 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 84 34 00 00       	call   80104fa0 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 88 33 00 00       	call   80104fa0 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 10 19 00 00       	call   80103530 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 59 33 00 00       	call   80105010 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 f6 32 00 00       	call   80105010 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 39 7d 10 80       	push   $0x80107d39
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 27 7d 10 80       	push   $0x80107d27
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 71 22 00 00       	call   80104010 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 19 11 80       	push   $0x801119e0
80101dac:	e8 3f 30 00 00       	call   80104df0 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dbc:	e8 ef 30 00 00       	call   80104eb0 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 74 31 00 00       	call   80104fa0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 e8 30 00 00       	call   80104fa0 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 76 30 00 00       	call   80105060 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 48 7d 10 80       	push   $0x80107d48
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 d5 83 10 80       	push   $0x801083d5
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010207f:	90                   	nop

80102080 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102080:	f3 0f 1e fb          	endbr32 
80102084:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102085:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010208a:	89 e5                	mov    %esp,%ebp
8010208c:	57                   	push   %edi
8010208d:	56                   	push   %esi
8010208e:	53                   	push   %ebx
8010208f:	83 ec 10             	sub    $0x10,%esp
80102092:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102095:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102098:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010209f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801020a6:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801020aa:	89 fb                	mov    %edi,%ebx
801020ac:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
801020b0:	85 c9                	test   %ecx,%ecx
801020b2:	79 08                	jns    801020bc <itoa+0x3c>
        *p++ = '-';
801020b4:	c6 07 2d             	movb   $0x2d,(%edi)
801020b7:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
801020ba:	f7 d9                	neg    %ecx
    }
    int shifter = i;
801020bc:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801020be:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c7:	90                   	nop
801020c8:	89 d0                	mov    %edx,%eax
        ++p;
801020ca:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
801020cd:	f7 e6                	mul    %esi
    }while(shifter);
801020cf:	c1 ea 03             	shr    $0x3,%edx
801020d2:	75 f4                	jne    801020c8 <itoa+0x48>
    *p = '\0';
801020d4:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
801020d7:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020e0:	89 c8                	mov    %ecx,%eax
801020e2:	83 eb 01             	sub    $0x1,%ebx
801020e5:	f7 e6                	mul    %esi
801020e7:	c1 ea 03             	shr    $0x3,%edx
801020ea:	8d 04 92             	lea    (%edx,%edx,4),%eax
801020ed:	01 c0                	add    %eax,%eax
801020ef:	29 c1                	sub    %eax,%ecx
801020f1:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801020f6:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801020f8:	88 03                	mov    %al,(%ebx)
    }while(i);
801020fa:	85 d2                	test   %edx,%edx
801020fc:	75 e2                	jne    801020e0 <itoa+0x60>
    return b;
}
801020fe:	83 c4 10             	add    $0x10,%esp
80102101:	89 f8                	mov    %edi,%eax
80102103:	5b                   	pop    %ebx
80102104:	5e                   	pop    %esi
80102105:	5f                   	pop    %edi
80102106:	5d                   	pop    %ebp
80102107:	c3                   	ret    
80102108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210f:	90                   	nop

80102110 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	57                   	push   %edi
80102118:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102119:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010211c:	53                   	push   %ebx
8010211d:	83 ec 40             	sub    $0x40,%esp
80102120:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102123:	6a 06                	push   $0x6
80102125:	68 55 7d 10 80       	push   $0x80107d55
8010212a:	56                   	push   %esi
8010212b:	e8 70 2e 00 00       	call   80104fa0 <memmove>
  itoa(p->pid, path+ 6);
80102130:	58                   	pop    %eax
80102131:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102134:	5a                   	pop    %edx
80102135:	50                   	push   %eax
80102136:	ff 73 10             	pushl  0x10(%ebx)
80102139:	e8 42 ff ff ff       	call   80102080 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010213e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102141:	83 c4 10             	add    $0x10,%esp
80102144:	85 c0                	test   %eax,%eax
80102146:	0f 84 7a 01 00 00    	je     801022c6 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
8010214c:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010214f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80102152:	50                   	push   %eax
80102153:	e8 78 ed ff ff       	call   80100ed0 <fileclose>

  begin_op();
80102158:	e8 f3 11 00 00       	call   80103350 <begin_op>
  return namex(path, 1, name);
8010215d:	89 f0                	mov    %esi,%eax
8010215f:	89 d9                	mov    %ebx,%ecx
80102161:	ba 01 00 00 00       	mov    $0x1,%edx
80102166:	e8 15 fc ff ff       	call   80101d80 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010216b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010216e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102170:	85 c0                	test   %eax,%eax
80102172:	0f 84 55 01 00 00    	je     801022cd <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	50                   	push   %eax
8010217c:	e8 ef f5 ff ff       	call   80101770 <ilock>
  return strncmp(s, t, DIRSIZ);
80102181:	83 c4 0c             	add    $0xc,%esp
80102184:	6a 0e                	push   $0xe
80102186:	68 5d 7d 10 80       	push   $0x80107d5d
8010218b:	53                   	push   %ebx
8010218c:	e8 7f 2e 00 00       	call   80105010 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102191:	83 c4 10             	add    $0x10,%esp
80102194:	85 c0                	test   %eax,%eax
80102196:	0f 84 f4 00 00 00    	je     80102290 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010219c:	83 ec 04             	sub    $0x4,%esp
8010219f:	6a 0e                	push   $0xe
801021a1:	68 5c 7d 10 80       	push   $0x80107d5c
801021a6:	53                   	push   %ebx
801021a7:	e8 64 2e 00 00       	call   80105010 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801021ac:	83 c4 10             	add    $0x10,%esp
801021af:	85 c0                	test   %eax,%eax
801021b1:	0f 84 d9 00 00 00    	je     80102290 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801021b7:	83 ec 04             	sub    $0x4,%esp
801021ba:	8d 45 b8             	lea    -0x48(%ebp),%eax
801021bd:	50                   	push   %eax
801021be:	53                   	push   %ebx
801021bf:	56                   	push   %esi
801021c0:	e8 fb fa ff ff       	call   80101cc0 <dirlookup>
801021c5:	83 c4 10             	add    $0x10,%esp
801021c8:	89 c3                	mov    %eax,%ebx
801021ca:	85 c0                	test   %eax,%eax
801021cc:	0f 84 be 00 00 00    	je     80102290 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801021d2:	83 ec 0c             	sub    $0xc,%esp
801021d5:	50                   	push   %eax
801021d6:	e8 95 f5 ff ff       	call   80101770 <ilock>

  if(ip->nlink < 1)
801021db:	83 c4 10             	add    $0x10,%esp
801021de:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801021e3:	0f 8e 00 01 00 00    	jle    801022e9 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801021e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021ee:	74 78                	je     80102268 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801021f0:	83 ec 04             	sub    $0x4,%esp
801021f3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801021f6:	6a 10                	push   $0x10
801021f8:	6a 00                	push   $0x0
801021fa:	57                   	push   %edi
801021fb:	e8 00 2d 00 00       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102200:	6a 10                	push   $0x10
80102202:	ff 75 b8             	pushl  -0x48(%ebp)
80102205:	57                   	push   %edi
80102206:	56                   	push   %esi
80102207:	e8 64 f9 ff ff       	call   80101b70 <writei>
8010220c:	83 c4 20             	add    $0x20,%esp
8010220f:	83 f8 10             	cmp    $0x10,%eax
80102212:	0f 85 c4 00 00 00    	jne    801022dc <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102218:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010221d:	0f 84 8d 00 00 00    	je     801022b0 <removeSwapFile+0x1a0>
  iunlock(ip);
80102223:	83 ec 0c             	sub    $0xc,%esp
80102226:	56                   	push   %esi
80102227:	e8 24 f6 ff ff       	call   80101850 <iunlock>
  iput(ip);
8010222c:	89 34 24             	mov    %esi,(%esp)
8010222f:	e8 6c f6 ff ff       	call   801018a0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102234:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102239:	89 1c 24             	mov    %ebx,(%esp)
8010223c:	e8 6f f4 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80102241:	89 1c 24             	mov    %ebx,(%esp)
80102244:	e8 07 f6 ff ff       	call   80101850 <iunlock>
  iput(ip);
80102249:	89 1c 24             	mov    %ebx,(%esp)
8010224c:	e8 4f f6 ff ff       	call   801018a0 <iput>
  iunlockput(ip);

  end_op();
80102251:	e8 6a 11 00 00       	call   801033c0 <end_op>

  return 0;
80102256:	83 c4 10             	add    $0x10,%esp
80102259:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
8010225b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225e:	5b                   	pop    %ebx
8010225f:	5e                   	pop    %esi
80102260:	5f                   	pop    %edi
80102261:	5d                   	pop    %ebp
80102262:	c3                   	ret    
80102263:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102267:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102268:	83 ec 0c             	sub    $0xc,%esp
8010226b:	53                   	push   %ebx
8010226c:	e8 5f 34 00 00       	call   801056d0 <isdirempty>
80102271:	83 c4 10             	add    $0x10,%esp
80102274:	85 c0                	test   %eax,%eax
80102276:	0f 85 74 ff ff ff    	jne    801021f0 <removeSwapFile+0xe0>
  iunlock(ip);
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	53                   	push   %ebx
80102280:	e8 cb f5 ff ff       	call   80101850 <iunlock>
  iput(ip);
80102285:	89 1c 24             	mov    %ebx,(%esp)
80102288:	e8 13 f6 ff ff       	call   801018a0 <iput>
    goto bad;
8010228d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	56                   	push   %esi
80102294:	e8 b7 f5 ff ff       	call   80101850 <iunlock>
  iput(ip);
80102299:	89 34 24             	mov    %esi,(%esp)
8010229c:	e8 ff f5 ff ff       	call   801018a0 <iput>
    end_op();
801022a1:	e8 1a 11 00 00       	call   801033c0 <end_op>
    return -1;
801022a6:	83 c4 10             	add    $0x10,%esp
801022a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022ae:	eb ab                	jmp    8010225b <removeSwapFile+0x14b>
    iupdate(dp);
801022b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801022b3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801022b8:	56                   	push   %esi
801022b9:	e8 f2 f3 ff ff       	call   801016b0 <iupdate>
801022be:	83 c4 10             	add    $0x10,%esp
801022c1:	e9 5d ff ff ff       	jmp    80102223 <removeSwapFile+0x113>
    return -1;
801022c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022cb:	eb 8e                	jmp    8010225b <removeSwapFile+0x14b>
    end_op();
801022cd:	e8 ee 10 00 00       	call   801033c0 <end_op>
    return -1;
801022d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d7:	e9 7f ff ff ff       	jmp    8010225b <removeSwapFile+0x14b>
    panic("unlink: writei");
801022dc:	83 ec 0c             	sub    $0xc,%esp
801022df:	68 71 7d 10 80       	push   $0x80107d71
801022e4:	e8 a7 e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801022e9:	83 ec 0c             	sub    $0xc,%esp
801022ec:	68 5f 7d 10 80       	push   $0x80107d5f
801022f1:	e8 9a e0 ff ff       	call   80100390 <panic>
801022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022fd:	8d 76 00             	lea    0x0(%esi),%esi

80102300 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102300:	f3 0f 1e fb          	endbr32 
80102304:	55                   	push   %ebp
80102305:	89 e5                	mov    %esp,%ebp
80102307:	56                   	push   %esi
80102308:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102309:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
8010230c:	83 ec 14             	sub    $0x14,%esp
8010230f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102312:	6a 06                	push   $0x6
80102314:	68 55 7d 10 80       	push   $0x80107d55
80102319:	56                   	push   %esi
8010231a:	e8 81 2c 00 00       	call   80104fa0 <memmove>
  itoa(p->pid, path+ 6);
8010231f:	58                   	pop    %eax
80102320:	8d 45 f0             	lea    -0x10(%ebp),%eax
80102323:	5a                   	pop    %edx
80102324:	50                   	push   %eax
80102325:	ff 73 10             	pushl  0x10(%ebx)
80102328:	e8 53 fd ff ff       	call   80102080 <itoa>

    begin_op();
8010232d:	e8 1e 10 00 00       	call   80103350 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
80102332:	6a 00                	push   $0x0
80102334:	6a 00                	push   $0x0
80102336:	6a 02                	push   $0x2
80102338:	56                   	push   %esi
80102339:	e8 b2 35 00 00       	call   801058f0 <create>
  iunlock(in);
8010233e:	83 c4 14             	add    $0x14,%esp
80102341:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
80102342:	89 c6                	mov    %eax,%esi
  iunlock(in);
80102344:	e8 07 f5 ff ff       	call   80101850 <iunlock>

  p->swapFile = filealloc();
80102349:	e8 c2 ea ff ff       	call   80100e10 <filealloc>
  if (p->swapFile == 0)
8010234e:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
80102351:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102354:	85 c0                	test   %eax,%eax
80102356:	74 32                	je     8010238a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102358:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
8010235b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010235e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102364:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102367:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010236e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102371:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102375:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102378:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010237c:	e8 3f 10 00 00       	call   801033c0 <end_op>

    return 0;
}
80102381:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102384:	31 c0                	xor    %eax,%eax
80102386:	5b                   	pop    %ebx
80102387:	5e                   	pop    %esi
80102388:	5d                   	pop    %ebp
80102389:	c3                   	ret    
    panic("no slot for files on /store");
8010238a:	83 ec 0c             	sub    $0xc,%esp
8010238d:	68 80 7d 10 80       	push   $0x80107d80
80102392:	e8 f9 df ff ff       	call   80100390 <panic>
80102397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
801023a5:	89 e5                	mov    %esp,%ebp
801023a7:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801023aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023ad:	8b 50 7c             	mov    0x7c(%eax),%edx
801023b0:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801023b3:	8b 55 14             	mov    0x14(%ebp),%edx
801023b6:	89 55 10             	mov    %edx,0x10(%ebp)
801023b9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023bc:	89 45 08             	mov    %eax,0x8(%ebp)

}
801023bf:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801023c0:	e9 db ec ff ff       	jmp    801010a0 <filewrite>
801023c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023d0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801023d0:	f3 0f 1e fb          	endbr32 
801023d4:	55                   	push   %ebp
801023d5:	89 e5                	mov    %esp,%ebp
801023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801023da:	8b 4d 10             	mov    0x10(%ebp),%ecx
801023dd:	8b 50 7c             	mov    0x7c(%eax),%edx
801023e0:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801023e3:	8b 55 14             	mov    0x14(%ebp),%edx
801023e6:	89 55 10             	mov    %edx,0x10(%ebp)
801023e9:	8b 40 7c             	mov    0x7c(%eax),%eax
801023ec:	89 45 08             	mov    %eax,0x8(%ebp)
}
801023ef:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801023f0:	e9 0b ec ff ff       	jmp    80101000 <fileread>
801023f5:	66 90                	xchg   %ax,%ax
801023f7:	66 90                	xchg   %ax,%ax
801023f9:	66 90                	xchg   %ax,%ax
801023fb:	66 90                	xchg   %ax,%ax
801023fd:	66 90                	xchg   %ax,%ax
801023ff:	90                   	nop

80102400 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	57                   	push   %edi
80102404:	56                   	push   %esi
80102405:	53                   	push   %ebx
80102406:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102409:	85 c0                	test   %eax,%eax
8010240b:	0f 84 b4 00 00 00    	je     801024c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102411:	8b 70 08             	mov    0x8(%eax),%esi
80102414:	89 c3                	mov    %eax,%ebx
80102416:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010241c:	0f 87 96 00 00 00    	ja     801024b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102422:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242e:	66 90                	xchg   %ax,%ax
80102430:	89 ca                	mov    %ecx,%edx
80102432:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102433:	83 e0 c0             	and    $0xffffffc0,%eax
80102436:	3c 40                	cmp    $0x40,%al
80102438:	75 f6                	jne    80102430 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010243a:	31 ff                	xor    %edi,%edi
8010243c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102441:	89 f8                	mov    %edi,%eax
80102443:	ee                   	out    %al,(%dx)
80102444:	b8 01 00 00 00       	mov    $0x1,%eax
80102449:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010244e:	ee                   	out    %al,(%dx)
8010244f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102454:	89 f0                	mov    %esi,%eax
80102456:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102457:	89 f0                	mov    %esi,%eax
80102459:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010245e:	c1 f8 08             	sar    $0x8,%eax
80102461:	ee                   	out    %al,(%dx)
80102462:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102467:	89 f8                	mov    %edi,%eax
80102469:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010246a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010246e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102473:	c1 e0 04             	shl    $0x4,%eax
80102476:	83 e0 10             	and    $0x10,%eax
80102479:	83 c8 e0             	or     $0xffffffe0,%eax
8010247c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010247d:	f6 03 04             	testb  $0x4,(%ebx)
80102480:	75 16                	jne    80102498 <idestart+0x98>
80102482:	b8 20 00 00 00       	mov    $0x20,%eax
80102487:	89 ca                	mov    %ecx,%edx
80102489:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010248a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010248d:	5b                   	pop    %ebx
8010248e:	5e                   	pop    %esi
8010248f:	5f                   	pop    %edi
80102490:	5d                   	pop    %ebp
80102491:	c3                   	ret    
80102492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102498:	b8 30 00 00 00       	mov    $0x30,%eax
8010249d:	89 ca                	mov    %ecx,%edx
8010249f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801024a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801024a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801024a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024ad:	fc                   	cld    
801024ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b3:	5b                   	pop    %ebx
801024b4:	5e                   	pop    %esi
801024b5:	5f                   	pop    %edi
801024b6:	5d                   	pop    %ebp
801024b7:	c3                   	ret    
    panic("incorrect blockno");
801024b8:	83 ec 0c             	sub    $0xc,%esp
801024bb:	68 f8 7d 10 80       	push   $0x80107df8
801024c0:	e8 cb de ff ff       	call   80100390 <panic>
    panic("idestart");
801024c5:	83 ec 0c             	sub    $0xc,%esp
801024c8:	68 ef 7d 10 80       	push   $0x80107def
801024cd:	e8 be de ff ff       	call   80100390 <panic>
801024d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024e0 <ideinit>:
{
801024e0:	f3 0f 1e fb          	endbr32 
801024e4:	55                   	push   %ebp
801024e5:	89 e5                	mov    %esp,%ebp
801024e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024ea:	68 0a 7e 10 80       	push   $0x80107e0a
801024ef:	68 80 b5 10 80       	push   $0x8010b580
801024f4:	e8 77 27 00 00       	call   80104c70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801024f9:	58                   	pop    %eax
801024fa:	a1 00 3d 18 80       	mov    0x80183d00,%eax
801024ff:	5a                   	pop    %edx
80102500:	83 e8 01             	sub    $0x1,%eax
80102503:	50                   	push   %eax
80102504:	6a 0e                	push   $0xe
80102506:	e8 b5 02 00 00       	call   801027c0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010250b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010250e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102517:	90                   	nop
80102518:	ec                   	in     (%dx),%al
80102519:	83 e0 c0             	and    $0xffffffc0,%eax
8010251c:	3c 40                	cmp    $0x40,%al
8010251e:	75 f8                	jne    80102518 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102520:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102525:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010252a:	ee                   	out    %al,(%dx)
8010252b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102535:	eb 0e                	jmp    80102545 <ideinit+0x65>
80102537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102540:	83 e9 01             	sub    $0x1,%ecx
80102543:	74 0f                	je     80102554 <ideinit+0x74>
80102545:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102546:	84 c0                	test   %al,%al
80102548:	74 f6                	je     80102540 <ideinit+0x60>
      havedisk1 = 1;
8010254a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102551:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102554:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102559:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010255e:	ee                   	out    %al,(%dx)
}
8010255f:	c9                   	leave  
80102560:	c3                   	ret    
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	57                   	push   %edi
80102578:	56                   	push   %esi
80102579:	53                   	push   %ebx
8010257a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010257d:	68 80 b5 10 80       	push   $0x8010b580
80102582:	e8 69 28 00 00       	call   80104df0 <acquire>

  if((b = idequeue) == 0){
80102587:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	85 db                	test   %ebx,%ebx
80102592:	74 5f                	je     801025f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102594:	8b 43 58             	mov    0x58(%ebx),%eax
80102597:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010259c:	8b 33                	mov    (%ebx),%esi
8010259e:	f7 c6 04 00 00 00    	test   $0x4,%esi
801025a4:	75 2b                	jne    801025d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop
801025b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025b1:	89 c1                	mov    %eax,%ecx
801025b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801025b6:	80 f9 40             	cmp    $0x40,%cl
801025b9:	75 f5                	jne    801025b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025bb:	a8 21                	test   $0x21,%al
801025bd:	75 12                	jne    801025d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801025bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801025c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025cc:	fc                   	cld    
801025cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801025cf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801025d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025d7:	83 ce 02             	or     $0x2,%esi
801025da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801025dc:	53                   	push   %ebx
801025dd:	e8 0e 23 00 00       	call   801048f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025e2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801025e7:	83 c4 10             	add    $0x10,%esp
801025ea:	85 c0                	test   %eax,%eax
801025ec:	74 05                	je     801025f3 <ideintr+0x83>
    idestart(idequeue);
801025ee:	e8 0d fe ff ff       	call   80102400 <idestart>
    release(&idelock);
801025f3:	83 ec 0c             	sub    $0xc,%esp
801025f6:	68 80 b5 10 80       	push   $0x8010b580
801025fb:	e8 b0 28 00 00       	call   80104eb0 <release>

  release(&idelock);
}
80102600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102603:	5b                   	pop    %ebx
80102604:	5e                   	pop    %esi
80102605:	5f                   	pop    %edi
80102606:	5d                   	pop    %ebp
80102607:	c3                   	ret    
80102608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102610:	f3 0f 1e fb          	endbr32 
80102614:	55                   	push   %ebp
80102615:	89 e5                	mov    %esp,%ebp
80102617:	53                   	push   %ebx
80102618:	83 ec 10             	sub    $0x10,%esp
8010261b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010261e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102621:	50                   	push   %eax
80102622:	e8 e9 25 00 00       	call   80104c10 <holdingsleep>
80102627:	83 c4 10             	add    $0x10,%esp
8010262a:	85 c0                	test   %eax,%eax
8010262c:	0f 84 cf 00 00 00    	je     80102701 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102632:	8b 03                	mov    (%ebx),%eax
80102634:	83 e0 06             	and    $0x6,%eax
80102637:	83 f8 02             	cmp    $0x2,%eax
8010263a:	0f 84 b4 00 00 00    	je     801026f4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102640:	8b 53 04             	mov    0x4(%ebx),%edx
80102643:	85 d2                	test   %edx,%edx
80102645:	74 0d                	je     80102654 <iderw+0x44>
80102647:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010264c:	85 c0                	test   %eax,%eax
8010264e:	0f 84 93 00 00 00    	je     801026e7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102654:	83 ec 0c             	sub    $0xc,%esp
80102657:	68 80 b5 10 80       	push   $0x8010b580
8010265c:	e8 8f 27 00 00       	call   80104df0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102661:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102666:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	85 c0                	test   %eax,%eax
80102672:	74 6c                	je     801026e0 <iderw+0xd0>
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102678:	89 c2                	mov    %eax,%edx
8010267a:	8b 40 58             	mov    0x58(%eax),%eax
8010267d:	85 c0                	test   %eax,%eax
8010267f:	75 f7                	jne    80102678 <iderw+0x68>
80102681:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102684:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102686:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010268c:	74 42                	je     801026d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 e0 06             	and    $0x6,%eax
80102693:	83 f8 02             	cmp    $0x2,%eax
80102696:	74 23                	je     801026bb <iderw+0xab>
80102698:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    sleep(b, &idelock);
801026a0:	83 ec 08             	sub    $0x8,%esp
801026a3:	68 80 b5 10 80       	push   $0x8010b580
801026a8:	53                   	push   %ebx
801026a9:	e8 82 20 00 00       	call   80104730 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ae:	8b 03                	mov    (%ebx),%eax
801026b0:	83 c4 10             	add    $0x10,%esp
801026b3:	83 e0 06             	and    $0x6,%eax
801026b6:	83 f8 02             	cmp    $0x2,%eax
801026b9:	75 e5                	jne    801026a0 <iderw+0x90>
  }


  release(&idelock);
801026bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801026c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026c5:	c9                   	leave  
  release(&idelock);
801026c6:	e9 e5 27 00 00       	jmp    80104eb0 <release>
801026cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026cf:	90                   	nop
    idestart(b);
801026d0:	89 d8                	mov    %ebx,%eax
801026d2:	e8 29 fd ff ff       	call   80102400 <idestart>
801026d7:	eb b5                	jmp    8010268e <iderw+0x7e>
801026d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026e0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801026e5:	eb 9d                	jmp    80102684 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801026e7:	83 ec 0c             	sub    $0xc,%esp
801026ea:	68 39 7e 10 80       	push   $0x80107e39
801026ef:	e8 9c dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801026f4:	83 ec 0c             	sub    $0xc,%esp
801026f7:	68 24 7e 10 80       	push   $0x80107e24
801026fc:	e8 8f dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102701:	83 ec 0c             	sub    $0xc,%esp
80102704:	68 0e 7e 10 80       	push   $0x80107e0e
80102709:	e8 82 dc ff ff       	call   80100390 <panic>
8010270e:	66 90                	xchg   %ax,%ax

80102710 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102710:	f3 0f 1e fb          	endbr32 
80102714:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102715:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010271c:	00 c0 fe 
{
8010271f:	89 e5                	mov    %esp,%ebp
80102721:	56                   	push   %esi
80102722:	53                   	push   %ebx
  ioapic->reg = reg;
80102723:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010272a:	00 00 00 
  return ioapic->data;
8010272d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102733:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102736:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010273c:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102742:	0f b6 15 60 37 18 80 	movzbl 0x80183760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102749:	c1 ee 10             	shr    $0x10,%esi
8010274c:	89 f0                	mov    %esi,%eax
8010274e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102751:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102754:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102757:	39 c2                	cmp    %eax,%edx
80102759:	74 16                	je     80102771 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 58 7e 10 80       	push   $0x80107e58
80102763:	e8 48 df ff ff       	call   801006b0 <cprintf>
80102768:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010276e:	83 c4 10             	add    $0x10,%esp
80102771:	83 c6 21             	add    $0x21,%esi
{
80102774:	ba 10 00 00 00       	mov    $0x10,%edx
80102779:	b8 20 00 00 00       	mov    $0x20,%eax
8010277e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102780:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102782:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102784:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010278a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010278d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102793:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102796:	8d 5a 01             	lea    0x1(%edx),%ebx
80102799:	83 c2 02             	add    $0x2,%edx
8010279c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010279e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801027a4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801027ab:	39 f0                	cmp    %esi,%eax
801027ad:	75 d1                	jne    80102780 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801027af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b2:	5b                   	pop    %ebx
801027b3:	5e                   	pop    %esi
801027b4:	5d                   	pop    %ebp
801027b5:	c3                   	ret    
801027b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027c0:	f3 0f 1e fb          	endbr32 
801027c4:	55                   	push   %ebp
  ioapic->reg = reg;
801027c5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027d0:	8d 50 20             	lea    0x20(%eax),%edx
801027d3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027d7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027d9:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027df:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027e2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027e8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027ea:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027ef:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027f2:	89 50 10             	mov    %edx,0x10(%eax)
}
801027f5:	5d                   	pop    %ebp
801027f6:	c3                   	ret    
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102800:	f3 0f 1e fb          	endbr32 
80102804:	55                   	push   %ebp
80102805:	89 e5                	mov    %esp,%ebp
80102807:	53                   	push   %ebx
80102808:	83 ec 04             	sub    $0x4,%esp
8010280b:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010280e:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102813:	0f 85 af 00 00 00    	jne    801028c8 <kfree+0xc8>
80102819:	3d a8 d9 18 80       	cmp    $0x8018d9a8,%eax
8010281e:	0f 82 a4 00 00 00    	jb     801028c8 <kfree+0xc8>
80102824:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010282a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102830:	0f 87 92 00 00 00    	ja     801028c8 <kfree+0xc8>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102836:	83 ec 04             	sub    $0x4,%esp
80102839:	68 00 10 00 00       	push   $0x1000
8010283e:	6a 01                	push   $0x1
80102840:	50                   	push   %eax
80102841:	e8 ba 26 00 00       	call   80104f00 <memset>

  if(kmem.use_lock) 
80102846:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010284c:	83 c4 10             	add    $0x10,%esp
8010284f:	85 d2                	test   %edx,%edx
80102851:	75 4d                	jne    801028a0 <kfree+0xa0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102853:	89 d8                	mov    %ebx,%eax
80102855:	c1 e8 0c             	shr    $0xc,%eax

  if(r->refcount != 1)
80102858:	83 3c c5 80 36 11 80 	cmpl   $0x1,-0x7feec980(,%eax,8)
8010285f:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102860:	8d 50 06             	lea    0x6(%eax),%edx
80102863:	8d 0c c5 7c 36 11 80 	lea    -0x7feec984(,%eax,8),%ecx
  if(r->refcount != 1)
8010286a:	75 69                	jne    801028d5 <kfree+0xd5>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
8010286c:	a1 78 36 11 80       	mov    0x80113678,%eax
  r->refcount = 0;
80102871:	c7 04 d5 50 36 11 80 	movl   $0x0,-0x7feec9b0(,%edx,8)
80102878:	00 00 00 00 
  kmem.freelist = r;
8010287c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  r->next = kmem.freelist;
80102882:	89 04 d5 4c 36 11 80 	mov    %eax,-0x7feec9b4(,%edx,8)
  if(kmem.use_lock)
80102889:	a1 74 36 11 80       	mov    0x80113674,%eax
8010288e:	85 c0                	test   %eax,%eax
80102890:	75 26                	jne    801028b8 <kfree+0xb8>
    release(&kmem.lock);
}
80102892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102895:	c9                   	leave  
80102896:	c3                   	ret    
80102897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	68 40 36 11 80       	push   $0x80113640
801028a8:	e8 43 25 00 00       	call   80104df0 <acquire>
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	eb a1                	jmp    80102853 <kfree+0x53>
801028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028b8:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801028bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c2:	c9                   	leave  
    release(&kmem.lock);
801028c3:	e9 e8 25 00 00       	jmp    80104eb0 <release>
    panic("kfree");
801028c8:	83 ec 0c             	sub    $0xc,%esp
801028cb:	68 8a 7e 10 80       	push   $0x80107e8a
801028d0:	e8 bb da ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
801028d5:	83 ec 0c             	sub    $0xc,%esp
801028d8:	68 90 7e 10 80       	push   $0x80107e90
801028dd:	e8 ae da ff ff       	call   80100390 <panic>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
801028f5:	89 e5                	mov    %esp,%ebp
801028f7:	53                   	push   %ebx
801028f8:	83 ec 04             	sub    $0x4,%esp
801028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801028fe:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102903:	0f 85 c1 00 00 00    	jne    801029ca <kfree_nocheck+0xda>
80102909:	3d a8 d9 18 80       	cmp    $0x8018d9a8,%eax
8010290e:	0f 82 b6 00 00 00    	jb     801029ca <kfree_nocheck+0xda>
80102914:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010291a:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102920:	0f 87 a4 00 00 00    	ja     801029ca <kfree_nocheck+0xda>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102926:	83 ec 04             	sub    $0x4,%esp
80102929:	68 00 10 00 00       	push   $0x1000
8010292e:	6a 01                	push   $0x1
80102930:	50                   	push   %eax
80102931:	e8 ca 25 00 00       	call   80104f00 <memset>

  if(kmem.use_lock) 
80102936:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 d2                	test   %edx,%edx
80102941:	75 35                	jne    80102978 <kfree_nocheck+0x88>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102943:	a1 78 36 11 80       	mov    0x80113678,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102948:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
8010294b:	83 c3 06             	add    $0x6,%ebx
8010294e:	89 04 dd 4c 36 11 80 	mov    %eax,-0x7feec9b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102955:	8d 04 dd 4c 36 11 80 	lea    -0x7feec9b4(,%ebx,8),%eax
  r->refcount = 0;
8010295c:	c7 04 dd 50 36 11 80 	movl   $0x0,-0x7feec9b0(,%ebx,8)
80102963:	00 00 00 00 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102967:	a3 78 36 11 80       	mov    %eax,0x80113678
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
8010296c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010296f:	c9                   	leave  
80102970:	c3                   	ret    
80102971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102978:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010297b:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
8010297e:	68 40 36 11 80       	push   $0x80113640
  r->next = kmem.freelist;
80102983:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102986:	e8 65 24 00 00       	call   80104df0 <acquire>
  r->next = kmem.freelist;
8010298b:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(kmem.use_lock)
80102990:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102993:	c7 04 dd 50 36 11 80 	movl   $0x0,-0x7feec9b0(,%ebx,8)
8010299a:	00 00 00 00 
  r->next = kmem.freelist;
8010299e:	89 04 dd 4c 36 11 80 	mov    %eax,-0x7feec9b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
801029a5:	8d 04 dd 4c 36 11 80 	lea    -0x7feec9b4(,%ebx,8),%eax
801029ac:	a3 78 36 11 80       	mov    %eax,0x80113678
  if(kmem.use_lock)
801029b1:	a1 74 36 11 80       	mov    0x80113674,%eax
801029b6:	85 c0                	test   %eax,%eax
801029b8:	74 b2                	je     8010296c <kfree_nocheck+0x7c>
    release(&kmem.lock);
801029ba:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801029c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029c4:	c9                   	leave  
    release(&kmem.lock);
801029c5:	e9 e6 24 00 00       	jmp    80104eb0 <release>
    panic("kfree");
801029ca:	83 ec 0c             	sub    $0xc,%esp
801029cd:	68 8a 7e 10 80       	push   $0x80107e8a
801029d2:	e8 b9 d9 ff ff       	call   80100390 <panic>
801029d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029de:	66 90                	xchg   %ax,%ax

801029e0 <freerange>:
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801029ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a01:	39 de                	cmp    %ebx,%esi
80102a03:	72 1f                	jb     80102a24 <freerange+0x44>
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102a17:	50                   	push   %eax
80102a18:	e8 d3 fe ff ff       	call   801028f0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a1d:	83 c4 10             	add    $0x10,%esp
80102a20:	39 f3                	cmp    %esi,%ebx
80102a22:	76 e4                	jbe    80102a08 <freerange+0x28>
}
80102a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a27:	5b                   	pop    %ebx
80102a28:	5e                   	pop    %esi
80102a29:	5d                   	pop    %ebp
80102a2a:	c3                   	ret    
80102a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop

80102a30 <kinit1>:
{
80102a30:	f3 0f 1e fb          	endbr32 
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	56                   	push   %esi
80102a38:	53                   	push   %ebx
80102a39:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a3c:	83 ec 08             	sub    $0x8,%esp
80102a3f:	68 ad 7e 10 80       	push   $0x80107ead
80102a44:	68 40 36 11 80       	push   $0x80113640
80102a49:	e8 22 22 00 00       	call   80104c70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a54:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102a5b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a5e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a64:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a70:	39 de                	cmp    %ebx,%esi
80102a72:	72 20                	jb     80102a94 <kinit1+0x64>
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102a78:	83 ec 0c             	sub    $0xc,%esp
80102a7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102a87:	50                   	push   %eax
80102a88:	e8 63 fe ff ff       	call   801028f0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8d:	83 c4 10             	add    $0x10,%esp
80102a90:	39 de                	cmp    %ebx,%esi
80102a92:	73 e4                	jae    80102a78 <kinit1+0x48>
}
80102a94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a97:	5b                   	pop    %ebx
80102a98:	5e                   	pop    %esi
80102a99:	5d                   	pop    %ebp
80102a9a:	c3                   	ret    
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <kinit2>:
{
80102aa0:	f3 0f 1e fb          	endbr32 
80102aa4:	55                   	push   %ebp
80102aa5:	89 e5                	mov    %esp,%ebp
80102aa7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102aa8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102aab:	8b 75 0c             	mov    0xc(%ebp),%esi
80102aae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102aaf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ab5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ac1:	39 de                	cmp    %ebx,%esi
80102ac3:	72 1f                	jb     80102ae4 <kinit2+0x44>
80102ac5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102ac8:	83 ec 0c             	sub    $0xc,%esp
80102acb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102ad7:	50                   	push   %eax
80102ad8:	e8 13 fe ff ff       	call   801028f0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102add:	83 c4 10             	add    $0x10,%esp
80102ae0:	39 de                	cmp    %ebx,%esi
80102ae2:	73 e4                	jae    80102ac8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ae4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
80102aeb:	00 00 00 
}
80102aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af1:	5b                   	pop    %ebx
80102af2:	5e                   	pop    %esi
80102af3:	5d                   	pop    %ebp
80102af4:	c3                   	ret    
80102af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b00:	f3 0f 1e fb          	endbr32 
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
80102b07:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102b0a:	a1 74 36 11 80       	mov    0x80113674,%eax
80102b0f:	85 c0                	test   %eax,%eax
80102b11:	75 65                	jne    80102b78 <kalloc+0x78>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b13:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102b18:	85 c0                	test   %eax,%eax
80102b1a:	74 54                	je     80102b70 <kalloc+0x70>
  {
    kmem.freelist = r->next;
80102b1c:	8b 10                	mov    (%eax),%edx
80102b1e:	89 15 78 36 11 80    	mov    %edx,0x80113678
    r->refcount = 1;
80102b24:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102b2b:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
80102b31:	85 c9                	test   %ecx,%ecx
80102b33:	75 13                	jne    80102b48 <kalloc+0x48>
    release(&kmem.lock);


  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b35:	2d 7c 36 11 80       	sub    $0x8011367c,%eax
80102b3a:	c1 e0 09             	shl    $0x9,%eax
80102b3d:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102b42:	c9                   	leave  
80102b43:	c3                   	ret    
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102b48:	83 ec 0c             	sub    $0xc,%esp
80102b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b4e:	68 40 36 11 80       	push   $0x80113640
80102b53:	e8 58 23 00 00       	call   80104eb0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b5b:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102b5e:	2d 7c 36 11 80       	sub    $0x8011367c,%eax
80102b63:	c1 e0 09             	shl    $0x9,%eax
80102b66:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
80102b6b:	eb d5                	jmp    80102b42 <kalloc+0x42>
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi
}
80102b70:	c9                   	leave  
{
80102b71:	31 c0                	xor    %eax,%eax
}
80102b73:	c3                   	ret    
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b78:	83 ec 0c             	sub    $0xc,%esp
80102b7b:	68 40 36 11 80       	push   $0x80113640
80102b80:	e8 6b 22 00 00       	call   80104df0 <acquire>
  r = kmem.freelist;
80102b85:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102b8a:	83 c4 10             	add    $0x10,%esp
80102b8d:	85 c0                	test   %eax,%eax
80102b8f:	75 8b                	jne    80102b1c <kalloc+0x1c>
  if(kmem.use_lock)
80102b91:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102b97:	85 d2                	test   %edx,%edx
80102b99:	74 d5                	je     80102b70 <kalloc+0x70>
    release(&kmem.lock);
80102b9b:	83 ec 0c             	sub    $0xc,%esp
80102b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ba1:	68 40 36 11 80       	push   $0x80113640
80102ba6:	e8 05 23 00 00       	call   80104eb0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102bae:	83 c4 10             	add    $0x10,%esp
}
80102bb1:	c9                   	leave  
80102bb2:	c3                   	ret    
80102bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bc0 <refDec>:

void
refDec(char *v)
{
80102bc0:	f3 0f 1e fb          	endbr32 
80102bc4:	55                   	push   %ebp
80102bc5:	89 e5                	mov    %esp,%ebp
80102bc7:	53                   	push   %ebx
80102bc8:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102bcb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
{
80102bd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102bd4:	85 d2                	test   %edx,%edx
80102bd6:	75 18                	jne    80102bf0 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bd8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102bde:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102be1:	83 04 c5 80 36 11 80 	addl   $0x1,-0x7feec980(,%eax,8)
80102be8:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bec:	c9                   	leave  
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102bf0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bf3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102bf9:	68 40 36 11 80       	push   $0x80113640
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bfe:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c01:	e8 ea 21 00 00       	call   80104df0 <acquire>
  if(kmem.use_lock)
80102c06:	a1 74 36 11 80       	mov    0x80113674,%eax
  r->refcount += 1;
80102c0b:	83 04 dd 80 36 11 80 	addl   $0x1,-0x7feec980(,%ebx,8)
80102c12:	01 
  if(kmem.use_lock)
80102c13:	83 c4 10             	add    $0x10,%esp
80102c16:	85 c0                	test   %eax,%eax
80102c18:	74 cf                	je     80102be9 <refDec+0x29>
    release(&kmem.lock);
80102c1a:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c24:	c9                   	leave  
    release(&kmem.lock);
80102c25:	e9 86 22 00 00       	jmp    80104eb0 <release>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c30 <refInc>:

void
refInc(char *v)
{
80102c30:	f3 0f 1e fb          	endbr32 
80102c34:	55                   	push   %ebp
80102c35:	89 e5                	mov    %esp,%ebp
80102c37:	53                   	push   %ebx
80102c38:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102c3b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
{
80102c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102c44:	85 d2                	test   %edx,%edx
80102c46:	75 18                	jne    80102c60 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c48:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c4e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102c51:	83 2c c5 80 36 11 80 	subl   $0x1,-0x7feec980(,%eax,8)
80102c58:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c5c:	c9                   	leave  
80102c5d:	c3                   	ret    
80102c5e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c63:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102c69:	68 40 36 11 80       	push   $0x80113640
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c6e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c71:	e8 7a 21 00 00       	call   80104df0 <acquire>
  if(kmem.use_lock)
80102c76:	a1 74 36 11 80       	mov    0x80113674,%eax
  r->refcount -= 1;
80102c7b:	83 2c dd 80 36 11 80 	subl   $0x1,-0x7feec980(,%ebx,8)
80102c82:	01 
  if(kmem.use_lock)
80102c83:	83 c4 10             	add    $0x10,%esp
80102c86:	85 c0                	test   %eax,%eax
80102c88:	74 cf                	je     80102c59 <refInc+0x29>
    release(&kmem.lock);
80102c8a:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c94:	c9                   	leave  
    release(&kmem.lock);
80102c95:	e9 16 22 00 00       	jmp    80104eb0 <release>
80102c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ca0 <getRefs>:

int
getRefs(char *v)
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102caa:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102cab:	05 00 00 00 80       	add    $0x80000000,%eax
80102cb0:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102cb3:	8b 04 c5 80 36 11 80 	mov    -0x7feec980(,%eax,8),%eax
80102cba:	c3                   	ret    
80102cbb:	66 90                	xchg   %ax,%ax
80102cbd:	66 90                	xchg   %ax,%ax
80102cbf:	90                   	nop

80102cc0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cc0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc4:	ba 64 00 00 00       	mov    $0x64,%edx
80102cc9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102cca:	a8 01                	test   $0x1,%al
80102ccc:	0f 84 be 00 00 00    	je     80102d90 <kbdgetc+0xd0>
{
80102cd2:	55                   	push   %ebp
80102cd3:	ba 60 00 00 00       	mov    $0x60,%edx
80102cd8:	89 e5                	mov    %esp,%ebp
80102cda:	53                   	push   %ebx
80102cdb:	ec                   	in     (%dx),%al
  return data;
80102cdc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102ce2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102ce5:	3c e0                	cmp    $0xe0,%al
80102ce7:	74 57                	je     80102d40 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ce9:	89 d9                	mov    %ebx,%ecx
80102ceb:	83 e1 40             	and    $0x40,%ecx
80102cee:	84 c0                	test   %al,%al
80102cf0:	78 5e                	js     80102d50 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102cf2:	85 c9                	test   %ecx,%ecx
80102cf4:	74 09                	je     80102cff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cf6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102cf9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102cfc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102cff:	0f b6 8a e0 7f 10 80 	movzbl -0x7fef8020(%edx),%ecx
  shift ^= togglecode[data];
80102d06:	0f b6 82 e0 7e 10 80 	movzbl -0x7fef8120(%edx),%eax
  shift |= shiftcode[data];
80102d0d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102d0f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d11:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d13:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d19:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d1c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d1f:	8b 04 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%eax
80102d26:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d2a:	74 0b                	je     80102d37 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102d2c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d2f:	83 fa 19             	cmp    $0x19,%edx
80102d32:	77 44                	ja     80102d78 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d34:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d37:	5b                   	pop    %ebx
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    
80102d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102d40:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102d43:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102d45:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102d4b:	5b                   	pop    %ebx
80102d4c:	5d                   	pop    %ebp
80102d4d:	c3                   	ret    
80102d4e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102d50:	83 e0 7f             	and    $0x7f,%eax
80102d53:	85 c9                	test   %ecx,%ecx
80102d55:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102d58:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102d5a:	0f b6 8a e0 7f 10 80 	movzbl -0x7fef8020(%edx),%ecx
80102d61:	83 c9 40             	or     $0x40,%ecx
80102d64:	0f b6 c9             	movzbl %cl,%ecx
80102d67:	f7 d1                	not    %ecx
80102d69:	21 d9                	and    %ebx,%ecx
}
80102d6b:	5b                   	pop    %ebx
80102d6c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102d6d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102d73:	c3                   	ret    
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102d78:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102d7b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102d7e:	5b                   	pop    %ebx
80102d7f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102d80:	83 f9 1a             	cmp    $0x1a,%ecx
80102d83:	0f 42 c2             	cmovb  %edx,%eax
}
80102d86:	c3                   	ret    
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax
    return -1;
80102d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d95:	c3                   	ret    
80102d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9d:	8d 76 00             	lea    0x0(%esi),%esi

80102da0 <kbdintr>:

void
kbdintr(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102daa:	68 c0 2c 10 80       	push   $0x80102cc0
80102daf:	e8 ac da ff ff       	call   80100860 <consoleintr>
}
80102db4:	83 c4 10             	add    $0x10,%esp
80102db7:	c9                   	leave  
80102db8:	c3                   	ret    
80102db9:	66 90                	xchg   %ax,%ax
80102dbb:	66 90                	xchg   %ax,%ax
80102dbd:	66 90                	xchg   %ax,%ax
80102dbf:	90                   	nop

80102dc0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102dc0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102dc4:	a1 7c 36 18 80       	mov    0x8018367c,%eax
80102dc9:	85 c0                	test   %eax,%eax
80102dcb:	0f 84 c7 00 00 00    	je     80102e98 <lapicinit+0xd8>
  lapic[index] = value;
80102dd1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102dd8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ddb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dde:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102de5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102deb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102df2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102df5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102df8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102dff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e02:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e05:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e0c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e0f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e12:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e19:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e1c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e1f:	8b 50 30             	mov    0x30(%eax),%edx
80102e22:	c1 ea 10             	shr    $0x10,%edx
80102e25:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102e2b:	75 73                	jne    80102ea0 <lapicinit+0xe0>
  lapic[index] = value;
80102e2d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e3a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e47:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e4e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e51:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e54:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e5b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e61:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102e68:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e6e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102e75:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102e78:	8b 50 20             	mov    0x20(%eax),%edx
80102e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102e80:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102e86:	80 e6 10             	and    $0x10,%dh
80102e89:	75 f5                	jne    80102e80 <lapicinit+0xc0>
  lapic[index] = value;
80102e8b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102e92:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e95:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e98:	c3                   	ret    
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ea0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ea7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eaa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102ead:	e9 7b ff ff ff       	jmp    80102e2d <lapicinit+0x6d>
80102eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ec0 <lapicid>:

int
lapicid(void)
{
80102ec0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102ec4:	a1 7c 36 18 80       	mov    0x8018367c,%eax
80102ec9:	85 c0                	test   %eax,%eax
80102ecb:	74 0b                	je     80102ed8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102ecd:	8b 40 20             	mov    0x20(%eax),%eax
80102ed0:	c1 e8 18             	shr    $0x18,%eax
80102ed3:	c3                   	ret    
80102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102ed8:	31 c0                	xor    %eax,%eax
}
80102eda:	c3                   	ret    
80102edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop

80102ee0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102ee4:	a1 7c 36 18 80       	mov    0x8018367c,%eax
80102ee9:	85 c0                	test   %eax,%eax
80102eeb:	74 0d                	je     80102efa <lapiceoi+0x1a>
  lapic[index] = value;
80102eed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ef4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102efa:	c3                   	ret    
80102efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop

80102f00 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f00:	f3 0f 1e fb          	endbr32 
}
80102f04:	c3                   	ret    
80102f05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f15:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f1f:	89 e5                	mov    %esp,%ebp
80102f21:	53                   	push   %ebx
80102f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f28:	ee                   	out    %al,(%dx)
80102f29:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f2e:	ba 71 00 00 00       	mov    $0x71,%edx
80102f33:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f34:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f36:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f39:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f3f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f41:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102f44:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102f46:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f49:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102f4c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102f52:	a1 7c 36 18 80       	mov    0x8018367c,%eax
80102f57:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f5d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f60:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102f67:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f6d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102f74:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f77:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f7a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f80:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f83:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f8c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f92:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f95:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102f9b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102f9c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102f9f:	5d                   	pop    %ebp
80102fa0:	c3                   	ret    
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102fb0:	f3 0f 1e fb          	endbr32 
80102fb4:	55                   	push   %ebp
80102fb5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102fba:	ba 70 00 00 00       	mov    $0x70,%edx
80102fbf:	89 e5                	mov    %esp,%ebp
80102fc1:	57                   	push   %edi
80102fc2:	56                   	push   %esi
80102fc3:	53                   	push   %ebx
80102fc4:	83 ec 4c             	sub    $0x4c,%esp
80102fc7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fc8:	ba 71 00 00 00       	mov    $0x71,%edx
80102fcd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102fce:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102fd6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	31 c0                	xor    %eax,%eax
80102fe2:	89 da                	mov    %ebx,%edx
80102fe4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102fea:	89 ca                	mov    %ecx,%edx
80102fec:	ec                   	in     (%dx),%al
80102fed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ff0:	89 da                	mov    %ebx,%edx
80102ff2:	b8 02 00 00 00       	mov    $0x2,%eax
80102ff7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff8:	89 ca                	mov    %ecx,%edx
80102ffa:	ec                   	in     (%dx),%al
80102ffb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ffe:	89 da                	mov    %ebx,%edx
80103000:	b8 04 00 00 00       	mov    $0x4,%eax
80103005:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103006:	89 ca                	mov    %ecx,%edx
80103008:	ec                   	in     (%dx),%al
80103009:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010300c:	89 da                	mov    %ebx,%edx
8010300e:	b8 07 00 00 00       	mov    $0x7,%eax
80103013:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103014:	89 ca                	mov    %ecx,%edx
80103016:	ec                   	in     (%dx),%al
80103017:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010301a:	89 da                	mov    %ebx,%edx
8010301c:	b8 08 00 00 00       	mov    $0x8,%eax
80103021:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103022:	89 ca                	mov    %ecx,%edx
80103024:	ec                   	in     (%dx),%al
80103025:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103027:	89 da                	mov    %ebx,%edx
80103029:	b8 09 00 00 00       	mov    $0x9,%eax
8010302e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010302f:	89 ca                	mov    %ecx,%edx
80103031:	ec                   	in     (%dx),%al
80103032:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103034:	89 da                	mov    %ebx,%edx
80103036:	b8 0a 00 00 00       	mov    $0xa,%eax
8010303b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010303c:	89 ca                	mov    %ecx,%edx
8010303e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010303f:	84 c0                	test   %al,%al
80103041:	78 9d                	js     80102fe0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103043:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103047:	89 fa                	mov    %edi,%edx
80103049:	0f b6 fa             	movzbl %dl,%edi
8010304c:	89 f2                	mov    %esi,%edx
8010304e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103051:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103055:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103058:	89 da                	mov    %ebx,%edx
8010305a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010305d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103060:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103064:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103067:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010306a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010306e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103071:	31 c0                	xor    %eax,%eax
80103073:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103074:	89 ca                	mov    %ecx,%edx
80103076:	ec                   	in     (%dx),%al
80103077:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307a:	89 da                	mov    %ebx,%edx
8010307c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010307f:	b8 02 00 00 00       	mov    $0x2,%eax
80103084:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103085:	89 ca                	mov    %ecx,%edx
80103087:	ec                   	in     (%dx),%al
80103088:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010308b:	89 da                	mov    %ebx,%edx
8010308d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103090:	b8 04 00 00 00       	mov    $0x4,%eax
80103095:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103096:	89 ca                	mov    %ecx,%edx
80103098:	ec                   	in     (%dx),%al
80103099:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309c:	89 da                	mov    %ebx,%edx
8010309e:	89 45 d8             	mov    %eax,-0x28(%ebp)
801030a1:	b8 07 00 00 00       	mov    $0x7,%eax
801030a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a7:	89 ca                	mov    %ecx,%edx
801030a9:	ec                   	in     (%dx),%al
801030aa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ad:	89 da                	mov    %ebx,%edx
801030af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030b2:	b8 08 00 00 00       	mov    $0x8,%eax
801030b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b8:	89 ca                	mov    %ecx,%edx
801030ba:	ec                   	in     (%dx),%al
801030bb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030be:	89 da                	mov    %ebx,%edx
801030c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801030c3:	b8 09 00 00 00       	mov    $0x9,%eax
801030c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c9:	89 ca                	mov    %ecx,%edx
801030cb:	ec                   	in     (%dx),%al
801030cc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801030cf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801030d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801030d5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801030d8:	6a 18                	push   $0x18
801030da:	50                   	push   %eax
801030db:	8d 45 b8             	lea    -0x48(%ebp),%eax
801030de:	50                   	push   %eax
801030df:	e8 6c 1e 00 00       	call   80104f50 <memcmp>
801030e4:	83 c4 10             	add    $0x10,%esp
801030e7:	85 c0                	test   %eax,%eax
801030e9:	0f 85 f1 fe ff ff    	jne    80102fe0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801030ef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801030f3:	75 78                	jne    8010316d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801030f5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030f8:	89 c2                	mov    %eax,%edx
801030fa:	83 e0 0f             	and    $0xf,%eax
801030fd:	c1 ea 04             	shr    $0x4,%edx
80103100:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103103:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103106:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103109:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010310c:	89 c2                	mov    %eax,%edx
8010310e:	83 e0 0f             	and    $0xf,%eax
80103111:	c1 ea 04             	shr    $0x4,%edx
80103114:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103117:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010311a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010311d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103120:	89 c2                	mov    %eax,%edx
80103122:	83 e0 0f             	and    $0xf,%eax
80103125:	c1 ea 04             	shr    $0x4,%edx
80103128:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010312b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010312e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103131:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103134:	89 c2                	mov    %eax,%edx
80103136:	83 e0 0f             	and    $0xf,%eax
80103139:	c1 ea 04             	shr    $0x4,%edx
8010313c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010313f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103142:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103145:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103148:	89 c2                	mov    %eax,%edx
8010314a:	83 e0 0f             	and    $0xf,%eax
8010314d:	c1 ea 04             	shr    $0x4,%edx
80103150:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103153:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103156:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103159:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010315c:	89 c2                	mov    %eax,%edx
8010315e:	83 e0 0f             	and    $0xf,%eax
80103161:	c1 ea 04             	shr    $0x4,%edx
80103164:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103167:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010316a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010316d:	8b 75 08             	mov    0x8(%ebp),%esi
80103170:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103173:	89 06                	mov    %eax,(%esi)
80103175:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103178:	89 46 04             	mov    %eax,0x4(%esi)
8010317b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010317e:	89 46 08             	mov    %eax,0x8(%esi)
80103181:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103184:	89 46 0c             	mov    %eax,0xc(%esi)
80103187:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010318a:	89 46 10             	mov    %eax,0x10(%esi)
8010318d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103190:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103193:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010319a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010319d:	5b                   	pop    %ebx
8010319e:	5e                   	pop    %esi
8010319f:	5f                   	pop    %edi
801031a0:	5d                   	pop    %ebp
801031a1:	c3                   	ret    
801031a2:	66 90                	xchg   %ax,%ax
801031a4:	66 90                	xchg   %ax,%ax
801031a6:	66 90                	xchg   %ax,%ax
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031b0:	8b 0d c8 36 18 80    	mov    0x801836c8,%ecx
801031b6:	85 c9                	test   %ecx,%ecx
801031b8:	0f 8e 8a 00 00 00    	jle    80103248 <install_trans+0x98>
{
801031be:	55                   	push   %ebp
801031bf:	89 e5                	mov    %esp,%ebp
801031c1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801031c2:	31 ff                	xor    %edi,%edi
{
801031c4:	56                   	push   %esi
801031c5:	53                   	push   %ebx
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801031d0:	a1 b4 36 18 80       	mov    0x801836b4,%eax
801031d5:	83 ec 08             	sub    $0x8,%esp
801031d8:	01 f8                	add    %edi,%eax
801031da:	83 c0 01             	add    $0x1,%eax
801031dd:	50                   	push   %eax
801031de:	ff 35 c4 36 18 80    	pushl  0x801836c4
801031e4:	e8 e7 ce ff ff       	call   801000d0 <bread>
801031e9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031eb:	58                   	pop    %eax
801031ec:	5a                   	pop    %edx
801031ed:	ff 34 bd cc 36 18 80 	pushl  -0x7fe7c934(,%edi,4)
801031f4:	ff 35 c4 36 18 80    	pushl  0x801836c4
  for (tail = 0; tail < log.lh.n; tail++) {
801031fa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031fd:	e8 ce ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103202:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103205:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103207:	8d 46 5c             	lea    0x5c(%esi),%eax
8010320a:	68 00 02 00 00       	push   $0x200
8010320f:	50                   	push   %eax
80103210:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103213:	50                   	push   %eax
80103214:	e8 87 1d 00 00       	call   80104fa0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103219:	89 1c 24             	mov    %ebx,(%esp)
8010321c:	e8 8f cf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103221:	89 34 24             	mov    %esi,(%esp)
80103224:	e8 c7 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103229:	89 1c 24             	mov    %ebx,(%esp)
8010322c:	e8 bf cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103231:	83 c4 10             	add    $0x10,%esp
80103234:	39 3d c8 36 18 80    	cmp    %edi,0x801836c8
8010323a:	7f 94                	jg     801031d0 <install_trans+0x20>
  }
}
8010323c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323f:	5b                   	pop    %ebx
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103248:	c3                   	ret    
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103250 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	53                   	push   %ebx
80103254:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103257:	ff 35 b4 36 18 80    	pushl  0x801836b4
8010325d:	ff 35 c4 36 18 80    	pushl  0x801836c4
80103263:	e8 68 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103268:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010326b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010326d:	a1 c8 36 18 80       	mov    0x801836c8,%eax
80103272:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103275:	85 c0                	test   %eax,%eax
80103277:	7e 19                	jle    80103292 <write_head+0x42>
80103279:	31 d2                	xor    %edx,%edx
8010327b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103280:	8b 0c 95 cc 36 18 80 	mov    -0x7fe7c934(,%edx,4),%ecx
80103287:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010328b:	83 c2 01             	add    $0x1,%edx
8010328e:	39 d0                	cmp    %edx,%eax
80103290:	75 ee                	jne    80103280 <write_head+0x30>
  }
  bwrite(buf);
80103292:	83 ec 0c             	sub    $0xc,%esp
80103295:	53                   	push   %ebx
80103296:	e8 15 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010329b:	89 1c 24             	mov    %ebx,(%esp)
8010329e:	e8 4d cf ff ff       	call   801001f0 <brelse>
}
801032a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032a6:	83 c4 10             	add    $0x10,%esp
801032a9:	c9                   	leave  
801032aa:	c3                   	ret    
801032ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032af:	90                   	nop

801032b0 <initlog>:
{
801032b0:	f3 0f 1e fb          	endbr32 
801032b4:	55                   	push   %ebp
801032b5:	89 e5                	mov    %esp,%ebp
801032b7:	53                   	push   %ebx
801032b8:	83 ec 2c             	sub    $0x2c,%esp
801032bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801032be:	68 e0 80 10 80       	push   $0x801080e0
801032c3:	68 80 36 18 80       	push   $0x80183680
801032c8:	e8 a3 19 00 00       	call   80104c70 <initlock>
  readsb(dev, &sb);
801032cd:	58                   	pop    %eax
801032ce:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032d1:	5a                   	pop    %edx
801032d2:	50                   	push   %eax
801032d3:	53                   	push   %ebx
801032d4:	e8 37 e2 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
801032d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801032dc:	59                   	pop    %ecx
  log.dev = dev;
801032dd:	89 1d c4 36 18 80    	mov    %ebx,0x801836c4
  log.size = sb.nlog;
801032e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801032e6:	a3 b4 36 18 80       	mov    %eax,0x801836b4
  log.size = sb.nlog;
801032eb:	89 15 b8 36 18 80    	mov    %edx,0x801836b8
  struct buf *buf = bread(log.dev, log.start);
801032f1:	5a                   	pop    %edx
801032f2:	50                   	push   %eax
801032f3:	53                   	push   %ebx
801032f4:	e8 d7 cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801032f9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801032fc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801032ff:	89 0d c8 36 18 80    	mov    %ecx,0x801836c8
  for (i = 0; i < log.lh.n; i++) {
80103305:	85 c9                	test   %ecx,%ecx
80103307:	7e 19                	jle    80103322 <initlog+0x72>
80103309:	31 d2                	xor    %edx,%edx
8010330b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010330f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103310:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103314:	89 1c 95 cc 36 18 80 	mov    %ebx,-0x7fe7c934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010331b:	83 c2 01             	add    $0x1,%edx
8010331e:	39 d1                	cmp    %edx,%ecx
80103320:	75 ee                	jne    80103310 <initlog+0x60>
  brelse(buf);
80103322:	83 ec 0c             	sub    $0xc,%esp
80103325:	50                   	push   %eax
80103326:	e8 c5 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010332b:	e8 80 fe ff ff       	call   801031b0 <install_trans>
  log.lh.n = 0;
80103330:	c7 05 c8 36 18 80 00 	movl   $0x0,0x801836c8
80103337:	00 00 00 
  write_head(); // clear the log
8010333a:	e8 11 ff ff ff       	call   80103250 <write_head>
}
8010333f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103342:	83 c4 10             	add    $0x10,%esp
80103345:	c9                   	leave  
80103346:	c3                   	ret    
80103347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010334e:	66 90                	xchg   %ax,%ax

80103350 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103350:	f3 0f 1e fb          	endbr32 
80103354:	55                   	push   %ebp
80103355:	89 e5                	mov    %esp,%ebp
80103357:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010335a:	68 80 36 18 80       	push   $0x80183680
8010335f:	e8 8c 1a 00 00       	call   80104df0 <acquire>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	eb 1c                	jmp    80103385 <begin_op+0x35>
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103370:	83 ec 08             	sub    $0x8,%esp
80103373:	68 80 36 18 80       	push   $0x80183680
80103378:	68 80 36 18 80       	push   $0x80183680
8010337d:	e8 ae 13 00 00       	call   80104730 <sleep>
80103382:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103385:	a1 c0 36 18 80       	mov    0x801836c0,%eax
8010338a:	85 c0                	test   %eax,%eax
8010338c:	75 e2                	jne    80103370 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010338e:	a1 bc 36 18 80       	mov    0x801836bc,%eax
80103393:	8b 15 c8 36 18 80    	mov    0x801836c8,%edx
80103399:	83 c0 01             	add    $0x1,%eax
8010339c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010339f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801033a2:	83 fa 1e             	cmp    $0x1e,%edx
801033a5:	7f c9                	jg     80103370 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801033a7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801033aa:	a3 bc 36 18 80       	mov    %eax,0x801836bc
      release(&log.lock);
801033af:	68 80 36 18 80       	push   $0x80183680
801033b4:	e8 f7 1a 00 00       	call   80104eb0 <release>
      break;
    }
  }
}
801033b9:	83 c4 10             	add    $0x10,%esp
801033bc:	c9                   	leave  
801033bd:	c3                   	ret    
801033be:	66 90                	xchg   %ax,%ax

801033c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	55                   	push   %ebp
801033c5:	89 e5                	mov    %esp,%ebp
801033c7:	57                   	push   %edi
801033c8:	56                   	push   %esi
801033c9:	53                   	push   %ebx
801033ca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801033cd:	68 80 36 18 80       	push   $0x80183680
801033d2:	e8 19 1a 00 00       	call   80104df0 <acquire>
  log.outstanding -= 1;
801033d7:	a1 bc 36 18 80       	mov    0x801836bc,%eax
  if(log.committing)
801033dc:	8b 35 c0 36 18 80    	mov    0x801836c0,%esi
801033e2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801033e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801033e8:	89 1d bc 36 18 80    	mov    %ebx,0x801836bc
  if(log.committing)
801033ee:	85 f6                	test   %esi,%esi
801033f0:	0f 85 1e 01 00 00    	jne    80103514 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801033f6:	85 db                	test   %ebx,%ebx
801033f8:	0f 85 f2 00 00 00    	jne    801034f0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801033fe:	c7 05 c0 36 18 80 01 	movl   $0x1,0x801836c0
80103405:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103408:	83 ec 0c             	sub    $0xc,%esp
8010340b:	68 80 36 18 80       	push   $0x80183680
80103410:	e8 9b 1a 00 00       	call   80104eb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103415:	8b 0d c8 36 18 80    	mov    0x801836c8,%ecx
8010341b:	83 c4 10             	add    $0x10,%esp
8010341e:	85 c9                	test   %ecx,%ecx
80103420:	7f 3e                	jg     80103460 <end_op+0xa0>
    acquire(&log.lock);
80103422:	83 ec 0c             	sub    $0xc,%esp
80103425:	68 80 36 18 80       	push   $0x80183680
8010342a:	e8 c1 19 00 00       	call   80104df0 <acquire>
    wakeup(&log);
8010342f:	c7 04 24 80 36 18 80 	movl   $0x80183680,(%esp)
    log.committing = 0;
80103436:	c7 05 c0 36 18 80 00 	movl   $0x0,0x801836c0
8010343d:	00 00 00 
    wakeup(&log);
80103440:	e8 ab 14 00 00       	call   801048f0 <wakeup>
    release(&log.lock);
80103445:	c7 04 24 80 36 18 80 	movl   $0x80183680,(%esp)
8010344c:	e8 5f 1a 00 00       	call   80104eb0 <release>
80103451:	83 c4 10             	add    $0x10,%esp
}
80103454:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103457:	5b                   	pop    %ebx
80103458:	5e                   	pop    %esi
80103459:	5f                   	pop    %edi
8010345a:	5d                   	pop    %ebp
8010345b:	c3                   	ret    
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103460:	a1 b4 36 18 80       	mov    0x801836b4,%eax
80103465:	83 ec 08             	sub    $0x8,%esp
80103468:	01 d8                	add    %ebx,%eax
8010346a:	83 c0 01             	add    $0x1,%eax
8010346d:	50                   	push   %eax
8010346e:	ff 35 c4 36 18 80    	pushl  0x801836c4
80103474:	e8 57 cc ff ff       	call   801000d0 <bread>
80103479:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010347b:	58                   	pop    %eax
8010347c:	5a                   	pop    %edx
8010347d:	ff 34 9d cc 36 18 80 	pushl  -0x7fe7c934(,%ebx,4)
80103484:	ff 35 c4 36 18 80    	pushl  0x801836c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010348a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010348d:	e8 3e cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103492:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103495:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010349a:	68 00 02 00 00       	push   $0x200
8010349f:	50                   	push   %eax
801034a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801034a3:	50                   	push   %eax
801034a4:	e8 f7 1a 00 00       	call   80104fa0 <memmove>
    bwrite(to);  // write the log
801034a9:	89 34 24             	mov    %esi,(%esp)
801034ac:	e8 ff cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
801034b1:	89 3c 24             	mov    %edi,(%esp)
801034b4:	e8 37 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
801034b9:	89 34 24             	mov    %esi,(%esp)
801034bc:	e8 2f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034c1:	83 c4 10             	add    $0x10,%esp
801034c4:	3b 1d c8 36 18 80    	cmp    0x801836c8,%ebx
801034ca:	7c 94                	jl     80103460 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801034cc:	e8 7f fd ff ff       	call   80103250 <write_head>
    install_trans(); // Now install writes to home locations
801034d1:	e8 da fc ff ff       	call   801031b0 <install_trans>
    log.lh.n = 0;
801034d6:	c7 05 c8 36 18 80 00 	movl   $0x0,0x801836c8
801034dd:	00 00 00 
    write_head();    // Erase the transaction from the log
801034e0:	e8 6b fd ff ff       	call   80103250 <write_head>
801034e5:	e9 38 ff ff ff       	jmp    80103422 <end_op+0x62>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	68 80 36 18 80       	push   $0x80183680
801034f8:	e8 f3 13 00 00       	call   801048f0 <wakeup>
  release(&log.lock);
801034fd:	c7 04 24 80 36 18 80 	movl   $0x80183680,(%esp)
80103504:	e8 a7 19 00 00       	call   80104eb0 <release>
80103509:	83 c4 10             	add    $0x10,%esp
}
8010350c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350f:	5b                   	pop    %ebx
80103510:	5e                   	pop    %esi
80103511:	5f                   	pop    %edi
80103512:	5d                   	pop    %ebp
80103513:	c3                   	ret    
    panic("log.committing");
80103514:	83 ec 0c             	sub    $0xc,%esp
80103517:	68 e4 80 10 80       	push   $0x801080e4
8010351c:	e8 6f ce ff ff       	call   80100390 <panic>
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop

80103530 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103530:	f3 0f 1e fb          	endbr32 
80103534:	55                   	push   %ebp
80103535:	89 e5                	mov    %esp,%ebp
80103537:	53                   	push   %ebx
80103538:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010353b:	8b 15 c8 36 18 80    	mov    0x801836c8,%edx
{
80103541:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103544:	83 fa 1d             	cmp    $0x1d,%edx
80103547:	0f 8f 91 00 00 00    	jg     801035de <log_write+0xae>
8010354d:	a1 b8 36 18 80       	mov    0x801836b8,%eax
80103552:	83 e8 01             	sub    $0x1,%eax
80103555:	39 c2                	cmp    %eax,%edx
80103557:	0f 8d 81 00 00 00    	jge    801035de <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010355d:	a1 bc 36 18 80       	mov    0x801836bc,%eax
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 8e 81 00 00 00    	jle    801035eb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	68 80 36 18 80       	push   $0x80183680
80103572:	e8 79 18 00 00       	call   80104df0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103577:	8b 15 c8 36 18 80    	mov    0x801836c8,%edx
8010357d:	83 c4 10             	add    $0x10,%esp
80103580:	85 d2                	test   %edx,%edx
80103582:	7e 4e                	jle    801035d2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103584:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103587:	31 c0                	xor    %eax,%eax
80103589:	eb 0c                	jmp    80103597 <log_write+0x67>
8010358b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010358f:	90                   	nop
80103590:	83 c0 01             	add    $0x1,%eax
80103593:	39 c2                	cmp    %eax,%edx
80103595:	74 29                	je     801035c0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103597:	39 0c 85 cc 36 18 80 	cmp    %ecx,-0x7fe7c934(,%eax,4)
8010359e:	75 f0                	jne    80103590 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801035a0:	89 0c 85 cc 36 18 80 	mov    %ecx,-0x7fe7c934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801035a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801035aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801035ad:	c7 45 08 80 36 18 80 	movl   $0x80183680,0x8(%ebp)
}
801035b4:	c9                   	leave  
  release(&log.lock);
801035b5:	e9 f6 18 00 00       	jmp    80104eb0 <release>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801035c0:	89 0c 95 cc 36 18 80 	mov    %ecx,-0x7fe7c934(,%edx,4)
    log.lh.n++;
801035c7:	83 c2 01             	add    $0x1,%edx
801035ca:	89 15 c8 36 18 80    	mov    %edx,0x801836c8
801035d0:	eb d5                	jmp    801035a7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801035d2:	8b 43 08             	mov    0x8(%ebx),%eax
801035d5:	a3 cc 36 18 80       	mov    %eax,0x801836cc
  if (i == log.lh.n)
801035da:	75 cb                	jne    801035a7 <log_write+0x77>
801035dc:	eb e9                	jmp    801035c7 <log_write+0x97>
    panic("too big a transaction");
801035de:	83 ec 0c             	sub    $0xc,%esp
801035e1:	68 f3 80 10 80       	push   $0x801080f3
801035e6:	e8 a5 cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801035eb:	83 ec 0c             	sub    $0xc,%esp
801035ee:	68 09 81 10 80       	push   $0x80108109
801035f3:	e8 98 cd ff ff       	call   80100390 <panic>
801035f8:	66 90                	xchg   %ax,%ax
801035fa:	66 90                	xchg   %ax,%ax
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
80103604:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103607:	e8 e4 09 00 00       	call   80103ff0 <cpuid>
8010360c:	89 c3                	mov    %eax,%ebx
8010360e:	e8 dd 09 00 00       	call   80103ff0 <cpuid>
80103613:	83 ec 04             	sub    $0x4,%esp
80103616:	53                   	push   %ebx
80103617:	50                   	push   %eax
80103618:	68 24 81 10 80       	push   $0x80108124
8010361d:	e8 8e d0 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103622:	e8 c9 2b 00 00       	call   801061f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103627:	e8 54 09 00 00       	call   80103f80 <mycpu>
8010362c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010362e:	b8 01 00 00 00       	mov    $0x1,%eax
80103633:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010363a:	e8 e1 0d 00 00       	call   80104420 <scheduler>
8010363f:	90                   	nop

80103640 <mpenter>:
{
80103640:	f3 0f 1e fb          	endbr32 
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010364a:	e8 c1 3b 00 00       	call   80107210 <switchkvm>
  seginit();
8010364f:	e8 2c 3b 00 00       	call   80107180 <seginit>
  lapicinit();
80103654:	e8 67 f7 ff ff       	call   80102dc0 <lapicinit>
  mpmain();
80103659:	e8 a2 ff ff ff       	call   80103600 <mpmain>
8010365e:	66 90                	xchg   %ax,%ax

80103660 <main>:
{
80103660:	f3 0f 1e fb          	endbr32 
80103664:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103668:	83 e4 f0             	and    $0xfffffff0,%esp
8010366b:	ff 71 fc             	pushl  -0x4(%ecx)
8010366e:	55                   	push   %ebp
8010366f:	89 e5                	mov    %esp,%ebp
80103671:	53                   	push   %ebx
80103672:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103673:	83 ec 08             	sub    $0x8,%esp
80103676:	68 00 00 40 80       	push   $0x80400000
8010367b:	68 a8 d9 18 80       	push   $0x8018d9a8
80103680:	e8 ab f3 ff ff       	call   80102a30 <kinit1>
  kvmalloc();      // kernel page table
80103685:	e8 56 41 00 00       	call   801077e0 <kvmalloc>
  mpinit();        // detect other processors
8010368a:	e8 81 01 00 00       	call   80103810 <mpinit>
  lapicinit();     // interrupt controller
8010368f:	e8 2c f7 ff ff       	call   80102dc0 <lapicinit>
  seginit();       // segment descriptors
80103694:	e8 e7 3a 00 00       	call   80107180 <seginit>
  picinit();       // disable pic
80103699:	e8 52 03 00 00       	call   801039f0 <picinit>
  ioapicinit();    // another interrupt controller
8010369e:	e8 6d f0 ff ff       	call   80102710 <ioapicinit>
  consoleinit();   // console hardware
801036a3:	e8 88 d3 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801036a8:	e8 43 2e 00 00       	call   801064f0 <uartinit>
  pinit();         // process table
801036ad:	e8 ae 08 00 00       	call   80103f60 <pinit>
  tvinit();        // trap vectors
801036b2:	e8 b9 2a 00 00       	call   80106170 <tvinit>
  binit();         // buffer cache
801036b7:	e8 84 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801036bc:	e8 2f d7 ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801036c1:	e8 1a ee ff ff       	call   801024e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801036c6:	83 c4 0c             	add    $0xc,%esp
801036c9:	68 8a 00 00 00       	push   $0x8a
801036ce:	68 8c b4 10 80       	push   $0x8010b48c
801036d3:	68 00 70 00 80       	push   $0x80007000
801036d8:	e8 c3 18 00 00       	call   80104fa0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801036dd:	83 c4 10             	add    $0x10,%esp
801036e0:	69 05 00 3d 18 80 b0 	imul   $0xb0,0x80183d00,%eax
801036e7:	00 00 00 
801036ea:	05 80 37 18 80       	add    $0x80183780,%eax
801036ef:	3d 80 37 18 80       	cmp    $0x80183780,%eax
801036f4:	76 7a                	jbe    80103770 <main+0x110>
801036f6:	bb 80 37 18 80       	mov    $0x80183780,%ebx
801036fb:	eb 1c                	jmp    80103719 <main+0xb9>
801036fd:	8d 76 00             	lea    0x0(%esi),%esi
80103700:	69 05 00 3d 18 80 b0 	imul   $0xb0,0x80183d00,%eax
80103707:	00 00 00 
8010370a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103710:	05 80 37 18 80       	add    $0x80183780,%eax
80103715:	39 c3                	cmp    %eax,%ebx
80103717:	73 57                	jae    80103770 <main+0x110>
    if(c == mycpu())  // We've started already.
80103719:	e8 62 08 00 00       	call   80103f80 <mycpu>
8010371e:	39 c3                	cmp    %eax,%ebx
80103720:	74 de                	je     80103700 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103722:	e8 d9 f3 ff ff       	call   80102b00 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103727:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010372a:	c7 05 f8 6f 00 80 40 	movl   $0x80103640,0x80006ff8
80103731:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103734:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010373b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010373e:	05 00 10 00 00       	add    $0x1000,%eax
80103743:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103748:	0f b6 03             	movzbl (%ebx),%eax
8010374b:	68 00 70 00 00       	push   $0x7000
80103750:	50                   	push   %eax
80103751:	e8 ba f7 ff ff       	call   80102f10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103756:	83 c4 10             	add    $0x10,%esp
80103759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103760:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103766:	85 c0                	test   %eax,%eax
80103768:	74 f6                	je     80103760 <main+0x100>
8010376a:	eb 94                	jmp    80103700 <main+0xa0>
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	68 00 00 00 8e       	push   $0x8e000000
80103778:	68 00 00 40 80       	push   $0x80400000
8010377d:	e8 1e f3 ff ff       	call   80102aa0 <kinit2>
  userinit();      // first user process
80103782:	e8 b9 08 00 00       	call   80104040 <userinit>
  mpmain();        // finish this processor's setup
80103787:	e8 74 fe ff ff       	call   80103600 <mpmain>
8010378c:	66 90                	xchg   %ax,%ax
8010378e:	66 90                	xchg   %ax,%ax

80103790 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103795:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010379b:	53                   	push   %ebx
  e = addr+len;
8010379c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010379f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801037a2:	39 de                	cmp    %ebx,%esi
801037a4:	72 10                	jb     801037b6 <mpsearch1+0x26>
801037a6:	eb 50                	jmp    801037f8 <mpsearch1+0x68>
801037a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
801037b0:	89 fe                	mov    %edi,%esi
801037b2:	39 fb                	cmp    %edi,%ebx
801037b4:	76 42                	jbe    801037f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037b6:	83 ec 04             	sub    $0x4,%esp
801037b9:	8d 7e 10             	lea    0x10(%esi),%edi
801037bc:	6a 04                	push   $0x4
801037be:	68 38 81 10 80       	push   $0x80108138
801037c3:	56                   	push   %esi
801037c4:	e8 87 17 00 00       	call   80104f50 <memcmp>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	85 c0                	test   %eax,%eax
801037ce:	75 e0                	jne    801037b0 <mpsearch1+0x20>
801037d0:	89 f2                	mov    %esi,%edx
801037d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801037d8:	0f b6 0a             	movzbl (%edx),%ecx
801037db:	83 c2 01             	add    $0x1,%edx
801037de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801037e0:	39 fa                	cmp    %edi,%edx
801037e2:	75 f4                	jne    801037d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037e4:	84 c0                	test   %al,%al
801037e6:	75 c8                	jne    801037b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801037e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037eb:	89 f0                	mov    %esi,%eax
801037ed:	5b                   	pop    %ebx
801037ee:	5e                   	pop    %esi
801037ef:	5f                   	pop    %edi
801037f0:	5d                   	pop    %ebp
801037f1:	c3                   	ret    
801037f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037fb:	31 f6                	xor    %esi,%esi
}
801037fd:	5b                   	pop    %ebx
801037fe:	89 f0                	mov    %esi,%eax
80103800:	5e                   	pop    %esi
80103801:	5f                   	pop    %edi
80103802:	5d                   	pop    %ebp
80103803:	c3                   	ret    
80103804:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop

80103810 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103810:	f3 0f 1e fb          	endbr32 
80103814:	55                   	push   %ebp
80103815:	89 e5                	mov    %esp,%ebp
80103817:	57                   	push   %edi
80103818:	56                   	push   %esi
80103819:	53                   	push   %ebx
8010381a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010381d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103824:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010382b:	c1 e0 08             	shl    $0x8,%eax
8010382e:	09 d0                	or     %edx,%eax
80103830:	c1 e0 04             	shl    $0x4,%eax
80103833:	75 1b                	jne    80103850 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103835:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010383c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103843:	c1 e0 08             	shl    $0x8,%eax
80103846:	09 d0                	or     %edx,%eax
80103848:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010384b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103850:	ba 00 04 00 00       	mov    $0x400,%edx
80103855:	e8 36 ff ff ff       	call   80103790 <mpsearch1>
8010385a:	89 c6                	mov    %eax,%esi
8010385c:	85 c0                	test   %eax,%eax
8010385e:	0f 84 4c 01 00 00    	je     801039b0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103864:	8b 5e 04             	mov    0x4(%esi),%ebx
80103867:	85 db                	test   %ebx,%ebx
80103869:	0f 84 61 01 00 00    	je     801039d0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010386f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103872:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103878:	6a 04                	push   $0x4
8010387a:	68 3d 81 10 80       	push   $0x8010813d
8010387f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103883:	e8 c8 16 00 00       	call   80104f50 <memcmp>
80103888:	83 c4 10             	add    $0x10,%esp
8010388b:	85 c0                	test   %eax,%eax
8010388d:	0f 85 3d 01 00 00    	jne    801039d0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103893:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010389a:	3c 01                	cmp    $0x1,%al
8010389c:	74 08                	je     801038a6 <mpinit+0x96>
8010389e:	3c 04                	cmp    $0x4,%al
801038a0:	0f 85 2a 01 00 00    	jne    801039d0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801038a6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801038ad:	66 85 d2             	test   %dx,%dx
801038b0:	74 26                	je     801038d8 <mpinit+0xc8>
801038b2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801038b5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801038b7:	31 d2                	xor    %edx,%edx
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801038c0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801038c7:	83 c0 01             	add    $0x1,%eax
801038ca:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801038cc:	39 f8                	cmp    %edi,%eax
801038ce:	75 f0                	jne    801038c0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801038d0:	84 d2                	test   %dl,%dl
801038d2:	0f 85 f8 00 00 00    	jne    801039d0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801038d8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801038de:	a3 7c 36 18 80       	mov    %eax,0x8018367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801038e9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801038f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038f5:	03 55 e4             	add    -0x1c(%ebp),%edx
801038f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801038fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop
80103900:	39 c2                	cmp    %eax,%edx
80103902:	76 15                	jbe    80103919 <mpinit+0x109>
    switch(*p){
80103904:	0f b6 08             	movzbl (%eax),%ecx
80103907:	80 f9 02             	cmp    $0x2,%cl
8010390a:	74 5c                	je     80103968 <mpinit+0x158>
8010390c:	77 42                	ja     80103950 <mpinit+0x140>
8010390e:	84 c9                	test   %cl,%cl
80103910:	74 6e                	je     80103980 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103912:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103915:	39 c2                	cmp    %eax,%edx
80103917:	77 eb                	ja     80103904 <mpinit+0xf4>
80103919:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010391c:	85 db                	test   %ebx,%ebx
8010391e:	0f 84 b9 00 00 00    	je     801039dd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103924:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103928:	74 15                	je     8010393f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010392a:	b8 70 00 00 00       	mov    $0x70,%eax
8010392f:	ba 22 00 00 00       	mov    $0x22,%edx
80103934:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103935:	ba 23 00 00 00       	mov    $0x23,%edx
8010393a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010393b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010393e:	ee                   	out    %al,(%dx)
  }
}
8010393f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103942:	5b                   	pop    %ebx
80103943:	5e                   	pop    %esi
80103944:	5f                   	pop    %edi
80103945:	5d                   	pop    %ebp
80103946:	c3                   	ret    
80103947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103950:	83 e9 03             	sub    $0x3,%ecx
80103953:	80 f9 01             	cmp    $0x1,%cl
80103956:	76 ba                	jbe    80103912 <mpinit+0x102>
80103958:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010395f:	eb 9f                	jmp    80103900 <mpinit+0xf0>
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103968:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010396c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010396f:	88 0d 60 37 18 80    	mov    %cl,0x80183760
      continue;
80103975:	eb 89                	jmp    80103900 <mpinit+0xf0>
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103980:	8b 0d 00 3d 18 80    	mov    0x80183d00,%ecx
80103986:	83 f9 07             	cmp    $0x7,%ecx
80103989:	7f 19                	jg     801039a4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010398b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103991:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103995:	83 c1 01             	add    $0x1,%ecx
80103998:	89 0d 00 3d 18 80    	mov    %ecx,0x80183d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010399e:	88 9f 80 37 18 80    	mov    %bl,-0x7fe7c880(%edi)
      p += sizeof(struct mpproc);
801039a4:	83 c0 14             	add    $0x14,%eax
      continue;
801039a7:	e9 54 ff ff ff       	jmp    80103900 <mpinit+0xf0>
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801039b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801039b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801039ba:	e8 d1 fd ff ff       	call   80103790 <mpsearch1>
801039bf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801039c1:	85 c0                	test   %eax,%eax
801039c3:	0f 85 9b fe ff ff    	jne    80103864 <mpinit+0x54>
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801039d0:	83 ec 0c             	sub    $0xc,%esp
801039d3:	68 42 81 10 80       	push   $0x80108142
801039d8:	e8 b3 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801039dd:	83 ec 0c             	sub    $0xc,%esp
801039e0:	68 5c 81 10 80       	push   $0x8010815c
801039e5:	e8 a6 c9 ff ff       	call   80100390 <panic>
801039ea:	66 90                	xchg   %ax,%ax
801039ec:	66 90                	xchg   %ax,%ax
801039ee:	66 90                	xchg   %ax,%ax

801039f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039f9:	ba 21 00 00 00       	mov    $0x21,%edx
801039fe:	ee                   	out    %al,(%dx)
801039ff:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a04:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a05:	c3                   	ret    
80103a06:	66 90                	xchg   %ax,%ax
80103a08:	66 90                	xchg   %ax,%ax
80103a0a:	66 90                	xchg   %ax,%ax
80103a0c:	66 90                	xchg   %ax,%ax
80103a0e:	66 90                	xchg   %ax,%ax

80103a10 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	57                   	push   %edi
80103a18:	56                   	push   %esi
80103a19:	53                   	push   %ebx
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a20:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a23:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a29:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a2f:	e8 dc d3 ff ff       	call   80100e10 <filealloc>
80103a34:	89 03                	mov    %eax,(%ebx)
80103a36:	85 c0                	test   %eax,%eax
80103a38:	0f 84 ac 00 00 00    	je     80103aea <pipealloc+0xda>
80103a3e:	e8 cd d3 ff ff       	call   80100e10 <filealloc>
80103a43:	89 06                	mov    %eax,(%esi)
80103a45:	85 c0                	test   %eax,%eax
80103a47:	0f 84 8b 00 00 00    	je     80103ad8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a4d:	e8 ae f0 ff ff       	call   80102b00 <kalloc>
80103a52:	89 c7                	mov    %eax,%edi
80103a54:	85 c0                	test   %eax,%eax
80103a56:	0f 84 b4 00 00 00    	je     80103b10 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103a5c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103a63:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103a66:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103a69:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103a70:	00 00 00 
  p->nwrite = 0;
80103a73:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a7a:	00 00 00 
  p->nread = 0;
80103a7d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103a84:	00 00 00 
  initlock(&p->lock, "pipe");
80103a87:	68 7b 81 10 80       	push   $0x8010817b
80103a8c:	50                   	push   %eax
80103a8d:	e8 de 11 00 00       	call   80104c70 <initlock>
  (*f0)->type = FD_PIPE;
80103a92:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103a94:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103a97:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103a9d:	8b 03                	mov    (%ebx),%eax
80103a9f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103aa3:	8b 03                	mov    (%ebx),%eax
80103aa5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103aa9:	8b 03                	mov    (%ebx),%eax
80103aab:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103aae:	8b 06                	mov    (%esi),%eax
80103ab0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ab6:	8b 06                	mov    (%esi),%eax
80103ab8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103abc:	8b 06                	mov    (%esi),%eax
80103abe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103ac2:	8b 06                	mov    (%esi),%eax
80103ac4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103aca:	31 c0                	xor    %eax,%eax
}
80103acc:	5b                   	pop    %ebx
80103acd:	5e                   	pop    %esi
80103ace:	5f                   	pop    %edi
80103acf:	5d                   	pop    %ebp
80103ad0:	c3                   	ret    
80103ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103ad8:	8b 03                	mov    (%ebx),%eax
80103ada:	85 c0                	test   %eax,%eax
80103adc:	74 1e                	je     80103afc <pipealloc+0xec>
    fileclose(*f0);
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	50                   	push   %eax
80103ae2:	e8 e9 d3 ff ff       	call   80100ed0 <fileclose>
80103ae7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103aea:	8b 06                	mov    (%esi),%eax
80103aec:	85 c0                	test   %eax,%eax
80103aee:	74 0c                	je     80103afc <pipealloc+0xec>
    fileclose(*f1);
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	50                   	push   %eax
80103af4:	e8 d7 d3 ff ff       	call   80100ed0 <fileclose>
80103af9:	83 c4 10             	add    $0x10,%esp
}
80103afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b04:	5b                   	pop    %ebx
80103b05:	5e                   	pop    %esi
80103b06:	5f                   	pop    %edi
80103b07:	5d                   	pop    %ebp
80103b08:	c3                   	ret    
80103b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103b10:	8b 03                	mov    (%ebx),%eax
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 c8                	jne    80103ade <pipealloc+0xce>
80103b16:	eb d2                	jmp    80103aea <pipealloc+0xda>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	56                   	push   %esi
80103b28:	53                   	push   %ebx
80103b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b2f:	83 ec 0c             	sub    $0xc,%esp
80103b32:	53                   	push   %ebx
80103b33:	e8 b8 12 00 00       	call   80104df0 <acquire>
  if(writable){
80103b38:	83 c4 10             	add    $0x10,%esp
80103b3b:	85 f6                	test   %esi,%esi
80103b3d:	74 41                	je     80103b80 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b3f:	83 ec 0c             	sub    $0xc,%esp
80103b42:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103b48:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b4f:	00 00 00 
    wakeup(&p->nread);
80103b52:	50                   	push   %eax
80103b53:	e8 98 0d 00 00       	call   801048f0 <wakeup>
80103b58:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b5b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103b61:	85 d2                	test   %edx,%edx
80103b63:	75 0a                	jne    80103b6f <pipeclose+0x4f>
80103b65:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	74 31                	je     80103ba0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103b6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b75:	5b                   	pop    %ebx
80103b76:	5e                   	pop    %esi
80103b77:	5d                   	pop    %ebp
    release(&p->lock);
80103b78:	e9 33 13 00 00       	jmp    80104eb0 <release>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103b80:	83 ec 0c             	sub    $0xc,%esp
80103b83:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103b89:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b90:	00 00 00 
    wakeup(&p->nwrite);
80103b93:	50                   	push   %eax
80103b94:	e8 57 0d 00 00       	call   801048f0 <wakeup>
80103b99:	83 c4 10             	add    $0x10,%esp
80103b9c:	eb bd                	jmp    80103b5b <pipeclose+0x3b>
80103b9e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	53                   	push   %ebx
80103ba4:	e8 07 13 00 00       	call   80104eb0 <release>
    kfree((char*)p);
80103ba9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103bac:	83 c4 10             	add    $0x10,%esp
}
80103baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb2:	5b                   	pop    %ebx
80103bb3:	5e                   	pop    %esi
80103bb4:	5d                   	pop    %ebp
    kfree((char*)p);
80103bb5:	e9 46 ec ff ff       	jmp    80102800 <kfree>
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103bc0:	f3 0f 1e fb          	endbr32 
80103bc4:	55                   	push   %ebp
80103bc5:	89 e5                	mov    %esp,%ebp
80103bc7:	57                   	push   %edi
80103bc8:	56                   	push   %esi
80103bc9:	53                   	push   %ebx
80103bca:	83 ec 28             	sub    $0x28,%esp
80103bcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103bd0:	53                   	push   %ebx
80103bd1:	e8 1a 12 00 00       	call   80104df0 <acquire>
  for(i = 0; i < n; i++){
80103bd6:	8b 45 10             	mov    0x10(%ebp),%eax
80103bd9:	83 c4 10             	add    $0x10,%esp
80103bdc:	85 c0                	test   %eax,%eax
80103bde:	0f 8e bc 00 00 00    	jle    80103ca0 <pipewrite+0xe0>
80103be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103be7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103bed:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103bf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bf6:	03 45 10             	add    0x10(%ebp),%eax
80103bf9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103bfc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c02:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c08:	89 ca                	mov    %ecx,%edx
80103c0a:	05 00 02 00 00       	add    $0x200,%eax
80103c0f:	39 c1                	cmp    %eax,%ecx
80103c11:	74 3b                	je     80103c4e <pipewrite+0x8e>
80103c13:	eb 63                	jmp    80103c78 <pipewrite+0xb8>
80103c15:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103c18:	e8 f3 03 00 00       	call   80104010 <myproc>
80103c1d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c20:	85 c9                	test   %ecx,%ecx
80103c22:	75 34                	jne    80103c58 <pipewrite+0x98>
      wakeup(&p->nread);
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	57                   	push   %edi
80103c28:	e8 c3 0c 00 00       	call   801048f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c2d:	58                   	pop    %eax
80103c2e:	5a                   	pop    %edx
80103c2f:	53                   	push   %ebx
80103c30:	56                   	push   %esi
80103c31:	e8 fa 0a 00 00       	call   80104730 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c36:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c3c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c42:	83 c4 10             	add    $0x10,%esp
80103c45:	05 00 02 00 00       	add    $0x200,%eax
80103c4a:	39 c2                	cmp    %eax,%edx
80103c4c:	75 2a                	jne    80103c78 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103c4e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c54:	85 c0                	test   %eax,%eax
80103c56:	75 c0                	jne    80103c18 <pipewrite+0x58>
        release(&p->lock);
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	53                   	push   %ebx
80103c5c:	e8 4f 12 00 00       	call   80104eb0 <release>
        return -1;
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c6c:	5b                   	pop    %ebx
80103c6d:	5e                   	pop    %esi
80103c6e:	5f                   	pop    %edi
80103c6f:	5d                   	pop    %ebp
80103c70:	c3                   	ret    
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c78:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103c7b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103c7e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103c84:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103c8a:	0f b6 06             	movzbl (%esi),%eax
80103c8d:	83 c6 01             	add    $0x1,%esi
80103c90:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103c93:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103c97:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103c9a:	0f 85 5c ff ff ff    	jne    80103bfc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ca9:	50                   	push   %eax
80103caa:	e8 41 0c 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
80103caf:	89 1c 24             	mov    %ebx,(%esp)
80103cb2:	e8 f9 11 00 00       	call   80104eb0 <release>
  return n;
80103cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80103cba:	83 c4 10             	add    $0x10,%esp
80103cbd:	eb aa                	jmp    80103c69 <pipewrite+0xa9>
80103cbf:	90                   	nop

80103cc0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103cc0:	f3 0f 1e fb          	endbr32 
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	57                   	push   %edi
80103cc8:	56                   	push   %esi
80103cc9:	53                   	push   %ebx
80103cca:	83 ec 18             	sub    $0x18,%esp
80103ccd:	8b 75 08             	mov    0x8(%ebp),%esi
80103cd0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103cd3:	56                   	push   %esi
80103cd4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103cda:	e8 11 11 00 00       	call   80104df0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cdf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ce5:	83 c4 10             	add    $0x10,%esp
80103ce8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103cee:	74 33                	je     80103d23 <piperead+0x63>
80103cf0:	eb 3b                	jmp    80103d2d <piperead+0x6d>
80103cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103cf8:	e8 13 03 00 00       	call   80104010 <myproc>
80103cfd:	8b 48 24             	mov    0x24(%eax),%ecx
80103d00:	85 c9                	test   %ecx,%ecx
80103d02:	0f 85 88 00 00 00    	jne    80103d90 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d08:	83 ec 08             	sub    $0x8,%esp
80103d0b:	56                   	push   %esi
80103d0c:	53                   	push   %ebx
80103d0d:	e8 1e 0a 00 00       	call   80104730 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d12:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103d18:	83 c4 10             	add    $0x10,%esp
80103d1b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103d21:	75 0a                	jne    80103d2d <piperead+0x6d>
80103d23:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103d29:	85 c0                	test   %eax,%eax
80103d2b:	75 cb                	jne    80103cf8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d2d:	8b 55 10             	mov    0x10(%ebp),%edx
80103d30:	31 db                	xor    %ebx,%ebx
80103d32:	85 d2                	test   %edx,%edx
80103d34:	7f 28                	jg     80103d5e <piperead+0x9e>
80103d36:	eb 34                	jmp    80103d6c <piperead+0xac>
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d40:	8d 48 01             	lea    0x1(%eax),%ecx
80103d43:	25 ff 01 00 00       	and    $0x1ff,%eax
80103d48:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103d4e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103d53:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d56:	83 c3 01             	add    $0x1,%ebx
80103d59:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d5c:	74 0e                	je     80103d6c <piperead+0xac>
    if(p->nread == p->nwrite)
80103d5e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103d64:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103d6a:	75 d4                	jne    80103d40 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103d6c:	83 ec 0c             	sub    $0xc,%esp
80103d6f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103d75:	50                   	push   %eax
80103d76:	e8 75 0b 00 00       	call   801048f0 <wakeup>
  release(&p->lock);
80103d7b:	89 34 24             	mov    %esi,(%esp)
80103d7e:	e8 2d 11 00 00       	call   80104eb0 <release>
  return i;
80103d83:	83 c4 10             	add    $0x10,%esp
}
80103d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d89:	89 d8                	mov    %ebx,%eax
80103d8b:	5b                   	pop    %ebx
80103d8c:	5e                   	pop    %esi
80103d8d:	5f                   	pop    %edi
80103d8e:	5d                   	pop    %ebp
80103d8f:	c3                   	ret    
      release(&p->lock);
80103d90:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d98:	56                   	push   %esi
80103d99:	e8 12 11 00 00       	call   80104eb0 <release>
      return -1;
80103d9e:	83 c4 10             	add    $0x10,%esp
}
80103da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103da4:	89 d8                	mov    %ebx,%eax
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5f                   	pop    %edi
80103da9:	5d                   	pop    %ebp
80103daa:	c3                   	ret    
80103dab:	66 90                	xchg   %ax,%ax
80103dad:	66 90                	xchg   %ax,%ax
80103daf:	90                   	nop

80103db0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db4:	bb 54 3d 18 80       	mov    $0x80183d54,%ebx
{
80103db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103dbc:	68 20 3d 18 80       	push   $0x80183d20
80103dc1:	e8 2a 10 00 00       	call   80104df0 <acquire>
80103dc6:	83 c4 10             	add    $0x10,%esp
80103dc9:	eb 17                	jmp    80103de2 <allocproc+0x32>
80103dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dcf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd0:	81 c3 50 02 00 00    	add    $0x250,%ebx
80103dd6:	81 fb 54 d1 18 80    	cmp    $0x8018d154,%ebx
80103ddc:	0f 84 f6 00 00 00    	je     80103ed8 <allocproc+0x128>
    if(p->state == UNUSED)
80103de2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103de5:	85 c0                	test   %eax,%eax
80103de7:	75 e7                	jne    80103dd0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103de9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103dee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103df1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103df8:	89 43 10             	mov    %eax,0x10(%ebx)
80103dfb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103dfe:	68 20 3d 18 80       	push   $0x80183d20
  p->pid = nextpid++;
80103e03:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103e09:	e8 a2 10 00 00       	call   80104eb0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e0e:	e8 ed ec ff ff       	call   80102b00 <kalloc>
80103e13:	83 c4 10             	add    $0x10,%esp
80103e16:	89 43 08             	mov    %eax,0x8(%ebx)
80103e19:	85 c0                	test   %eax,%eax
80103e1b:	0f 84 d0 00 00 00    	je     80103ef1 <allocproc+0x141>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e21:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e27:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e2a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e2f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e32:	c7 40 14 61 61 10 80 	movl   $0x80106161,0x14(%eax)
  p->context = (struct context*)sp;
80103e39:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e3c:	6a 14                	push   $0x14
80103e3e:	6a 00                	push   $0x0
80103e40:	50                   	push   %eax
80103e41:	e8 ba 10 00 00       	call   80104f00 <memset>
  p->context->eip = (uint)forkret;
80103e46:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e49:	8d 93 88 00 00 00    	lea    0x88(%ebx),%edx
80103e4f:	83 c4 10             	add    $0x10,%esp
80103e52:	c7 40 10 10 3f 10 80 	movl   $0x80103f10,0x10(%eax)

  // init page data, initiaing the swapped pages and the unused pages
  for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80103e59:	8d 83 48 01 00 00    	lea    0x148(%ebx),%eax
80103e5f:	89 c1                	mov    %eax,%ecx
80103e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->swappedPages[i].virt_addr = (char*)0xffffffff;
80103e68:	c7 42 08 ff ff ff ff 	movl   $0xffffffff,0x8(%edx)
    p->unusedpages[i].virt_addr = (char*)0xffffffff;
80103e6f:	83 c2 0c             	add    $0xc,%edx
80103e72:	83 c0 10             	add    $0x10,%eax
80103e75:	c7 40 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%eax)
    p->swappedPages[i].age = 0;
80103e7c:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
    p->unusedpages[i].age = 0;
80103e83:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    p->swappedPages[i].offset = 0;
80103e8a:	c7 42 f4 00 00 00 00 	movl   $0x0,-0xc(%edx)
    p->unusedpages[i].next = 0;
80103e91:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    p->unusedpages[i].prev = 0;
80103e98:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80103e9f:	39 ca                	cmp    %ecx,%edx
80103ea1:	75 c5                	jne    80103e68 <allocproc+0xb8>
  }

  p->nummemorypages = 0;
80103ea3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103eaa:	00 00 00 
  p->numswappages = 0;
  p->head_unused = 0;
  p->tail_unused = 0;

  return p;
}
80103ead:	89 d8                	mov    %ebx,%eax
  p->numswappages = 0;
80103eaf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103eb6:	00 00 00 
  p->head_unused = 0;
80103eb9:	c7 83 48 02 00 00 00 	movl   $0x0,0x248(%ebx)
80103ec0:	00 00 00 
  p->tail_unused = 0;
80103ec3:	c7 83 4c 02 00 00 00 	movl   $0x0,0x24c(%ebx)
80103eca:	00 00 00 
}
80103ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed0:	c9                   	leave  
80103ed1:	c3                   	ret    
80103ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103ed8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103edb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103edd:	68 20 3d 18 80       	push   $0x80183d20
80103ee2:	e8 c9 0f 00 00       	call   80104eb0 <release>
}
80103ee7:	89 d8                	mov    %ebx,%eax
  return 0;
80103ee9:	83 c4 10             	add    $0x10,%esp
}
80103eec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eef:	c9                   	leave  
80103ef0:	c3                   	ret    
    p->state = UNUSED;
80103ef1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ef8:	31 db                	xor    %ebx,%ebx
}
80103efa:	89 d8                	mov    %ebx,%eax
80103efc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eff:	c9                   	leave  
80103f00:	c3                   	ret    
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f1a:	68 20 3d 18 80       	push   $0x80183d20
80103f1f:	e8 8c 0f 00 00       	call   80104eb0 <release>

  if (first) {
80103f24:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	85 c0                	test   %eax,%eax
80103f2e:	75 08                	jne    80103f38 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f30:	c9                   	leave  
80103f31:	c3                   	ret    
80103f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103f38:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103f3f:	00 00 00 
    iinit(ROOTDEV);
80103f42:	83 ec 0c             	sub    $0xc,%esp
80103f45:	6a 01                	push   $0x1
80103f47:	e8 04 d6 ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
80103f4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f53:	e8 58 f3 ff ff       	call   801032b0 <initlog>
}
80103f58:	83 c4 10             	add    $0x10,%esp
80103f5b:	c9                   	leave  
80103f5c:	c3                   	ret    
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi

80103f60 <pinit>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f6a:	68 80 81 10 80       	push   $0x80108180
80103f6f:	68 20 3d 18 80       	push   $0x80183d20
80103f74:	e8 f7 0c 00 00       	call   80104c70 <initlock>
}
80103f79:	83 c4 10             	add    $0x10,%esp
80103f7c:	c9                   	leave  
80103f7d:	c3                   	ret    
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <mycpu>:
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	56                   	push   %esi
80103f88:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f89:	9c                   	pushf  
80103f8a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f8b:	f6 c4 02             	test   $0x2,%ah
80103f8e:	75 4a                	jne    80103fda <mycpu+0x5a>
  apicid = lapicid();
80103f90:	e8 2b ef ff ff       	call   80102ec0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103f95:	8b 35 00 3d 18 80    	mov    0x80183d00,%esi
  apicid = lapicid();
80103f9b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103f9d:	85 f6                	test   %esi,%esi
80103f9f:	7e 2c                	jle    80103fcd <mycpu+0x4d>
80103fa1:	31 d2                	xor    %edx,%edx
80103fa3:	eb 0a                	jmp    80103faf <mycpu+0x2f>
80103fa5:	8d 76 00             	lea    0x0(%esi),%esi
80103fa8:	83 c2 01             	add    $0x1,%edx
80103fab:	39 f2                	cmp    %esi,%edx
80103fad:	74 1e                	je     80103fcd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103faf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103fb5:	0f b6 81 80 37 18 80 	movzbl -0x7fe7c880(%ecx),%eax
80103fbc:	39 d8                	cmp    %ebx,%eax
80103fbe:	75 e8                	jne    80103fa8 <mycpu+0x28>
}
80103fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103fc3:	8d 81 80 37 18 80    	lea    -0x7fe7c880(%ecx),%eax
}
80103fc9:	5b                   	pop    %ebx
80103fca:	5e                   	pop    %esi
80103fcb:	5d                   	pop    %ebp
80103fcc:	c3                   	ret    
  panic("unknown apicid\n");
80103fcd:	83 ec 0c             	sub    $0xc,%esp
80103fd0:	68 87 81 10 80       	push   $0x80108187
80103fd5:	e8 b6 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 88 82 10 80       	push   $0x80108288
80103fe2:	e8 a9 c3 ff ff       	call   80100390 <panic>
80103fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fee:	66 90                	xchg   %ax,%ax

80103ff0 <cpuid>:
cpuid() {
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ffa:	e8 81 ff ff ff       	call   80103f80 <mycpu>
}
80103fff:	c9                   	leave  
  return mycpu()-cpus;
80104000:	2d 80 37 18 80       	sub    $0x80183780,%eax
80104005:	c1 f8 04             	sar    $0x4,%eax
80104008:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010400e:	c3                   	ret    
8010400f:	90                   	nop

80104010 <myproc>:
myproc(void) {
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	53                   	push   %ebx
80104018:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010401b:	e8 d0 0c 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104020:	e8 5b ff ff ff       	call   80103f80 <mycpu>
  p = c->proc;
80104025:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010402b:	e8 10 0d 00 00       	call   80104d40 <popcli>
}
80104030:	83 c4 04             	add    $0x4,%esp
80104033:	89 d8                	mov    %ebx,%eax
80104035:	5b                   	pop    %ebx
80104036:	5d                   	pop    %ebp
80104037:	c3                   	ret    
80104038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403f:	90                   	nop

80104040 <userinit>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	53                   	push   %ebx
80104048:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010404b:	e8 60 fd ff ff       	call   80103db0 <allocproc>
80104050:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104052:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104057:	e8 e4 36 00 00       	call   80107740 <setupkvm>
8010405c:	89 43 04             	mov    %eax,0x4(%ebx)
8010405f:	85 c0                	test   %eax,%eax
80104061:	0f 84 bd 00 00 00    	je     80104124 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104067:	83 ec 04             	sub    $0x4,%esp
8010406a:	68 2c 00 00 00       	push   $0x2c
8010406f:	68 60 b4 10 80       	push   $0x8010b460
80104074:	50                   	push   %eax
80104075:	e8 c6 32 00 00       	call   80107340 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010407a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010407d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104083:	6a 4c                	push   $0x4c
80104085:	6a 00                	push   $0x0
80104087:	ff 73 18             	pushl  0x18(%ebx)
8010408a:	e8 71 0e 00 00       	call   80104f00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010408f:	8b 43 18             	mov    0x18(%ebx),%eax
80104092:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104097:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010409a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010409f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040a3:	8b 43 18             	mov    0x18(%ebx),%eax
801040a6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040aa:	8b 43 18             	mov    0x18(%ebx),%eax
801040ad:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040b1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040b5:	8b 43 18             	mov    0x18(%ebx),%eax
801040b8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040bc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040c0:	8b 43 18             	mov    0x18(%ebx),%eax
801040c3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040ca:	8b 43 18             	mov    0x18(%ebx),%eax
801040cd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801040d4:	8b 43 18             	mov    0x18(%ebx),%eax
801040d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040de:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040e1:	6a 10                	push   $0x10
801040e3:	68 b0 81 10 80       	push   $0x801081b0
801040e8:	50                   	push   %eax
801040e9:	e8 d2 0f 00 00       	call   801050c0 <safestrcpy>
  p->cwd = namei("/");
801040ee:	c7 04 24 b9 81 10 80 	movl   $0x801081b9,(%esp)
801040f5:	e8 46 df ff ff       	call   80102040 <namei>
801040fa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801040fd:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
80104104:	e8 e7 0c 00 00       	call   80104df0 <acquire>
  p->state = RUNNABLE;
80104109:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104110:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
80104117:	e8 94 0d 00 00       	call   80104eb0 <release>
}
8010411c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010411f:	83 c4 10             	add    $0x10,%esp
80104122:	c9                   	leave  
80104123:	c3                   	ret    
    panic("userinit: out of memory?");
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	68 97 81 10 80       	push   $0x80108197
8010412c:	e8 5f c2 ff ff       	call   80100390 <panic>
80104131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <growproc>:
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	56                   	push   %esi
80104148:	53                   	push   %ebx
80104149:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010414c:	e8 9f 0b 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104151:	e8 2a fe ff ff       	call   80103f80 <mycpu>
  p = c->proc;
80104156:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010415c:	e8 df 0b 00 00       	call   80104d40 <popcli>
  sz = curproc->sz;
80104161:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104163:	85 f6                	test   %esi,%esi
80104165:	7f 19                	jg     80104180 <growproc+0x40>
  } else if(n < 0){
80104167:	75 37                	jne    801041a0 <growproc+0x60>
  switchuvm(curproc);
80104169:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010416c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010416e:	53                   	push   %ebx
8010416f:	e8 bc 30 00 00       	call   80107230 <switchuvm>
  return 0;
80104174:	83 c4 10             	add    $0x10,%esp
80104177:	31 c0                	xor    %eax,%eax
}
80104179:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010417c:	5b                   	pop    %ebx
8010417d:	5e                   	pop    %esi
8010417e:	5d                   	pop    %ebp
8010417f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104180:	83 ec 04             	sub    $0x4,%esp
80104183:	01 c6                	add    %eax,%esi
80104185:	56                   	push   %esi
80104186:	50                   	push   %eax
80104187:	ff 73 04             	pushl  0x4(%ebx)
8010418a:	e8 f1 33 00 00       	call   80107580 <allocuvm>
8010418f:	83 c4 10             	add    $0x10,%esp
80104192:	85 c0                	test   %eax,%eax
80104194:	75 d3                	jne    80104169 <growproc+0x29>
      return -1;
80104196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419b:	eb dc                	jmp    80104179 <growproc+0x39>
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041a0:	83 ec 04             	sub    $0x4,%esp
801041a3:	01 c6                	add    %eax,%esi
801041a5:	56                   	push   %esi
801041a6:	50                   	push   %eax
801041a7:	ff 73 04             	pushl  0x4(%ebx)
801041aa:	e8 e1 32 00 00       	call   80107490 <deallocuvm>
801041af:	83 c4 10             	add    $0x10,%esp
801041b2:	85 c0                	test   %eax,%eax
801041b4:	75 b3                	jne    80104169 <growproc+0x29>
801041b6:	eb de                	jmp    80104196 <growproc+0x56>
801041b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop

801041c0 <fork>:
{ 
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	57                   	push   %edi
801041c8:	56                   	push   %esi
801041c9:	53                   	push   %ebx
801041ca:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041cd:	e8 1e 0b 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801041d2:	e8 a9 fd ff ff       	call   80103f80 <mycpu>
  p = c->proc;
801041d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041dd:	e8 5e 0b 00 00       	call   80104d40 <popcli>
  if((np = allocproc()) == 0){
801041e2:	e8 c9 fb ff ff       	call   80103db0 <allocproc>
801041e7:	85 c0                	test   %eax,%eax
801041e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801041ec:	0f 84 e6 01 00 00    	je     801043d8 <fork+0x218>
  if((np->pgdir = cowuvm(curproc->pgdir, curproc->sz)) == 0){
801041f2:	83 ec 08             	sub    $0x8,%esp
801041f5:	ff 33                	pushl  (%ebx)
801041f7:	ff 73 04             	pushl  0x4(%ebx)
801041fa:	e8 31 36 00 00       	call   80107830 <cowuvm>
801041ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104202:	83 c4 10             	add    $0x10,%esp
80104205:	89 42 04             	mov    %eax,0x4(%edx)
80104208:	85 c0                	test   %eax,%eax
8010420a:	0f 84 de 01 00 00    	je     801043ee <fork+0x22e>
  np->sz = curproc->sz;
80104210:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80104212:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80104215:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104218:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
8010421d:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010421f:	8b 73 18             	mov    0x18(%ebx),%esi
80104222:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104224:	31 f6                	xor    %esi,%esi
80104226:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104228:	8b 42 18             	mov    0x18(%edx),%eax
8010422b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104238:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010423c:	85 c0                	test   %eax,%eax
8010423e:	74 10                	je     80104250 <fork+0x90>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	50                   	push   %eax
80104244:	e8 37 cc ff ff       	call   80100e80 <filedup>
80104249:	83 c4 10             	add    $0x10,%esp
8010424c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104250:	83 c6 01             	add    $0x1,%esi
80104253:	83 fe 10             	cmp    $0x10,%esi
80104256:	75 e0                	jne    80104238 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010425e:	8d 73 6c             	lea    0x6c(%ebx),%esi
  np->cwd = idup(curproc->cwd);
80104261:	ff 73 68             	pushl  0x68(%ebx)
80104264:	e8 d7 d4 ff ff       	call   80101740 <idup>
80104269:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010426c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010426f:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104272:	8d 42 6c             	lea    0x6c(%edx),%eax
80104275:	6a 10                	push   $0x10
80104277:	56                   	push   %esi
80104278:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010427b:	50                   	push   %eax
8010427c:	e8 3f 0e 00 00       	call   801050c0 <safestrcpy>
  pid = np->pid;
80104281:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104284:	8b 42 10             	mov    0x10(%edx),%eax
80104287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  createSwapFile(np);
8010428a:	89 14 24             	mov    %edx,(%esp)
8010428d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104290:	e8 6b e0 ff ff       	call   80102300 <createSwapFile>
  char buffer[chunkSize];
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010429b:	89 65 dc             	mov    %esp,-0x24(%ebp)
8010429e:	3b 65 dc             	cmp    -0x24(%ebp),%esp
801042a1:	74 13                	je     801042b6 <fork+0xf6>
801042a3:	81 ec 00 10 00 00    	sub    $0x1000,%esp
801042a9:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
801042b0:	00 
801042b1:	3b 65 dc             	cmp    -0x24(%ebp),%esp
801042b4:	75 ed                	jne    801042a3 <fork+0xe3>
801042b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801042b9:	81 ec 00 08 00 00    	sub    $0x800,%esp
801042bf:	83 8c 24 fc 07 00 00 	orl    $0x0,0x7fc(%esp)
801042c6:	00 
801042c7:	89 e7                	mov    %esp,%edi
  if(strncmp(curproc->name, "sh", 2) != 0 && strncmp(curproc->name, "init", 4) != 0) // we don't copy 'sh' and 'init' processes
801042c9:	83 ec 04             	sub    $0x4,%esp
801042cc:	6a 02                	push   $0x2
801042ce:	68 bb 81 10 80       	push   $0x801081bb
801042d3:	56                   	push   %esi
801042d4:	e8 37 0d 00 00       	call   80105010 <strncmp>
801042d9:	83 c4 10             	add    $0x10,%esp
801042dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042df:	85 c0                	test   %eax,%eax
801042e1:	0f 85 8e 00 00 00    	jne    80104375 <fork+0x1b5>
  int offset = 0;
801042e7:	b9 48 01 00 00       	mov    $0x148,%ecx
801042ec:	b8 88 00 00 00       	mov    $0x88,%eax
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->swappedPages[i].age = curproc->swappedPages[i].age;
801042f8:	8b 74 03 04          	mov    0x4(%ebx,%eax,1),%esi
801042fc:	89 74 02 04          	mov    %esi,0x4(%edx,%eax,1)
    np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104300:	8b 74 03 08          	mov    0x8(%ebx,%eax,1),%esi
80104304:	89 74 02 08          	mov    %esi,0x8(%edx,%eax,1)
    np->swappedPages[i].offset = curproc->swappedPages[i].offset;
80104308:	8b 34 03             	mov    (%ebx,%eax,1),%esi
8010430b:	89 34 02             	mov    %esi,(%edx,%eax,1)
    np->unusedpages[i].virt_addr = curproc->unusedpages[i].virt_addr;
8010430e:	8b 34 0b             	mov    (%ebx,%ecx,1),%esi
80104311:	83 c0 0c             	add    $0xc,%eax
80104314:	89 34 0a             	mov    %esi,(%edx,%ecx,1)
    np->unusedpages[i].age = curproc->unusedpages[i].age;
80104317:	8b 74 0b 04          	mov    0x4(%ebx,%ecx,1),%esi
8010431b:	89 74 0a 04          	mov    %esi,0x4(%edx,%ecx,1)
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
8010431f:	83 c1 10             	add    $0x10,%ecx
80104322:	3d 48 01 00 00       	cmp    $0x148,%eax
80104327:	75 cf                	jne    801042f8 <fork+0x138>
  np->nummemorypages = curproc->nummemorypages;
80104329:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  acquire(&ptable.lock);
8010432f:	83 ec 0c             	sub    $0xc,%esp
  np->numswappages= curproc->numswappages;
80104332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->nummemorypages = curproc->nummemorypages;
80104335:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  np->numswappages= curproc->numswappages;
8010433b:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104341:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  acquire(&ptable.lock);
80104347:	68 20 3d 18 80       	push   $0x80183d20
8010434c:	e8 9f 0a 00 00       	call   80104df0 <acquire>
  np->state = RUNNABLE;
80104351:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104354:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
8010435b:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
80104362:	e8 49 0b 00 00       	call   80104eb0 <release>
  return pid;
80104367:	8b 65 dc             	mov    -0x24(%ebp),%esp
}
8010436a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010436d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104370:	5b                   	pop    %ebx
80104371:	5e                   	pop    %esi
80104372:	5f                   	pop    %edi
80104373:	5d                   	pop    %ebp
80104374:	c3                   	ret    
  if(strncmp(curproc->name, "sh", 2) != 0 && strncmp(curproc->name, "init", 4) != 0) // we don't copy 'sh' and 'init' processes
80104375:	83 ec 04             	sub    $0x4,%esp
80104378:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010437b:	6a 04                	push   $0x4
8010437d:	68 be 81 10 80       	push   $0x801081be
80104382:	56                   	push   %esi
80104383:	e8 88 0c 00 00       	call   80105010 <strncmp>
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010438e:	85 c0                	test   %eax,%eax
80104390:	0f 84 51 ff ff ff    	je     801042e7 <fork+0x127>
  int offset = 0;
80104396:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104399:	31 f6                	xor    %esi,%esi
8010439b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010439e:	eb 15                	jmp    801043b5 <fork+0x1f5>
      if(writeToSwapFile(np, buffer, offset, read) == -1) // writing fails for some reason
801043a0:	53                   	push   %ebx
801043a1:	56                   	push   %esi
801043a2:	57                   	push   %edi
801043a3:	ff 75 e0             	pushl  -0x20(%ebp)
801043a6:	e8 f5 df ff ff       	call   801023a0 <writeToSwapFile>
801043ab:	83 c4 10             	add    $0x10,%esp
801043ae:	83 f8 ff             	cmp    $0xffffffff,%eax
801043b1:	74 2e                	je     801043e1 <fork+0x221>
      offset += read; //advance offset by home much we read each time
801043b3:	01 de                	add    %ebx,%esi
    while((read = readFromSwapFile(curproc, buffer, offset, chunkSize)) != 0) // there is more to read
801043b5:	68 00 08 00 00       	push   $0x800
801043ba:	56                   	push   %esi
801043bb:	57                   	push   %edi
801043bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801043bf:	e8 0c e0 ff ff       	call   801023d0 <readFromSwapFile>
801043c4:	83 c4 10             	add    $0x10,%esp
801043c7:	89 c3                	mov    %eax,%ebx
801043c9:	85 c0                	test   %eax,%eax
801043cb:	75 d3                	jne    801043a0 <fork+0x1e0>
801043cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801043d3:	e9 0f ff ff ff       	jmp    801042e7 <fork+0x127>
    return -1;
801043d8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
801043df:	eb 89                	jmp    8010436a <fork+0x1aa>
        panic("writeToSwapFile fails on fork");
801043e1:	83 ec 0c             	sub    $0xc,%esp
801043e4:	68 c3 81 10 80       	push   $0x801081c3
801043e9:	e8 a2 bf ff ff       	call   80100390 <panic>
    kfree(np->kstack);
801043ee:	83 ec 0c             	sub    $0xc,%esp
801043f1:	ff 72 08             	pushl  0x8(%edx)
801043f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801043f7:	e8 04 e4 ff ff       	call   80102800 <kfree>
    np->kstack = 0;
801043fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
801043ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
80104406:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104409:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104410:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104417:	e9 4e ff ff ff       	jmp    8010436a <fork+0x1aa>
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104420 <scheduler>:
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	57                   	push   %edi
80104428:	56                   	push   %esi
80104429:	53                   	push   %ebx
8010442a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010442d:	e8 4e fb ff ff       	call   80103f80 <mycpu>
  c->proc = 0;
80104432:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104439:	00 00 00 
  struct cpu *c = mycpu();
8010443c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010443e:	8d 78 04             	lea    0x4(%eax),%edi
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104448:	fb                   	sti    
    acquire(&ptable.lock);
80104449:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444c:	bb 54 3d 18 80       	mov    $0x80183d54,%ebx
    acquire(&ptable.lock);
80104451:	68 20 3d 18 80       	push   $0x80183d20
80104456:	e8 95 09 00 00       	call   80104df0 <acquire>
8010445b:	83 c4 10             	add    $0x10,%esp
8010445e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104460:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104464:	75 33                	jne    80104499 <scheduler+0x79>
      switchuvm(p);
80104466:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104469:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010446f:	53                   	push   %ebx
80104470:	e8 bb 2d 00 00       	call   80107230 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104475:	58                   	pop    %eax
80104476:	5a                   	pop    %edx
80104477:	ff 73 1c             	pushl  0x1c(%ebx)
8010447a:	57                   	push   %edi
      p->state = RUNNING;
8010447b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104482:	e8 9c 0c 00 00       	call   80105123 <swtch>
      switchkvm();
80104487:	e8 84 2d 00 00       	call   80107210 <switchkvm>
      c->proc = 0;
8010448c:	83 c4 10             	add    $0x10,%esp
8010448f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104496:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104499:	81 c3 50 02 00 00    	add    $0x250,%ebx
8010449f:	81 fb 54 d1 18 80    	cmp    $0x8018d154,%ebx
801044a5:	75 b9                	jne    80104460 <scheduler+0x40>
    release(&ptable.lock);
801044a7:	83 ec 0c             	sub    $0xc,%esp
801044aa:	68 20 3d 18 80       	push   $0x80183d20
801044af:	e8 fc 09 00 00       	call   80104eb0 <release>
    sti();
801044b4:	83 c4 10             	add    $0x10,%esp
801044b7:	eb 8f                	jmp    80104448 <scheduler+0x28>
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044c0 <sched>:
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	56                   	push   %esi
801044c8:	53                   	push   %ebx
  pushcli();
801044c9:	e8 22 08 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801044ce:	e8 ad fa ff ff       	call   80103f80 <mycpu>
  p = c->proc;
801044d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044d9:	e8 62 08 00 00       	call   80104d40 <popcli>
  if(!holding(&ptable.lock))
801044de:	83 ec 0c             	sub    $0xc,%esp
801044e1:	68 20 3d 18 80       	push   $0x80183d20
801044e6:	e8 b5 08 00 00       	call   80104da0 <holding>
801044eb:	83 c4 10             	add    $0x10,%esp
801044ee:	85 c0                	test   %eax,%eax
801044f0:	74 4f                	je     80104541 <sched+0x81>
  if(mycpu()->ncli != 1)
801044f2:	e8 89 fa ff ff       	call   80103f80 <mycpu>
801044f7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801044fe:	75 68                	jne    80104568 <sched+0xa8>
  if(p->state == RUNNING)
80104500:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104504:	74 55                	je     8010455b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104506:	9c                   	pushf  
80104507:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104508:	f6 c4 02             	test   $0x2,%ah
8010450b:	75 41                	jne    8010454e <sched+0x8e>
  intena = mycpu()->intena;
8010450d:	e8 6e fa ff ff       	call   80103f80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104512:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104515:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010451b:	e8 60 fa ff ff       	call   80103f80 <mycpu>
80104520:	83 ec 08             	sub    $0x8,%esp
80104523:	ff 70 04             	pushl  0x4(%eax)
80104526:	53                   	push   %ebx
80104527:	e8 f7 0b 00 00       	call   80105123 <swtch>
  mycpu()->intena = intena;
8010452c:	e8 4f fa ff ff       	call   80103f80 <mycpu>
}
80104531:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104534:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010453a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010453d:	5b                   	pop    %ebx
8010453e:	5e                   	pop    %esi
8010453f:	5d                   	pop    %ebp
80104540:	c3                   	ret    
    panic("sched ptable.lock");
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	68 e1 81 10 80       	push   $0x801081e1
80104549:	e8 42 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	68 0d 82 10 80       	push   $0x8010820d
80104556:	e8 35 be ff ff       	call   80100390 <panic>
    panic("sched running");
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	68 ff 81 10 80       	push   $0x801081ff
80104563:	e8 28 be ff ff       	call   80100390 <panic>
    panic("sched locks");
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	68 f3 81 10 80       	push   $0x801081f3
80104570:	e8 1b be ff ff       	call   80100390 <panic>
80104575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <exit>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	57                   	push   %edi
80104588:	56                   	push   %esi
80104589:	53                   	push   %ebx
8010458a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010458d:	e8 5e 07 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104592:	e8 e9 f9 ff ff       	call   80103f80 <mycpu>
  p = c->proc;
80104597:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010459d:	e8 9e 07 00 00       	call   80104d40 <popcli>
  if(curproc == initproc)
801045a2:	8d 5e 28             	lea    0x28(%esi),%ebx
801045a5:	8d 7e 68             	lea    0x68(%esi),%edi
801045a8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801045ae:	0f 84 1a 01 00 00    	je     801046ce <exit+0x14e>
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801045b8:	8b 03                	mov    (%ebx),%eax
801045ba:	85 c0                	test   %eax,%eax
801045bc:	74 12                	je     801045d0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801045be:	83 ec 0c             	sub    $0xc,%esp
801045c1:	50                   	push   %eax
801045c2:	e8 09 c9 ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
801045c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801045cd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801045d0:	83 c3 04             	add    $0x4,%ebx
801045d3:	39 df                	cmp    %ebx,%edi
801045d5:	75 e1                	jne    801045b8 <exit+0x38>
  if (removeSwapFile(curproc) != 0)
801045d7:	83 ec 0c             	sub    $0xc,%esp
801045da:	56                   	push   %esi
801045db:	e8 30 db ff ff       	call   80102110 <removeSwapFile>
801045e0:	83 c4 10             	add    $0x10,%esp
801045e3:	85 c0                	test   %eax,%eax
801045e5:	0f 85 bd 00 00 00    	jne    801046a8 <exit+0x128>
  begin_op();
801045eb:	e8 60 ed ff ff       	call   80103350 <begin_op>
  iput(curproc->cwd);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	ff 76 68             	pushl  0x68(%esi)
801045f6:	e8 a5 d2 ff ff       	call   801018a0 <iput>
  end_op();
801045fb:	e8 c0 ed ff ff       	call   801033c0 <end_op>
  curproc->cwd = 0;
80104600:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104607:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
8010460e:	e8 dd 07 00 00       	call   80104df0 <acquire>
  wakeup1(curproc->parent);
80104613:	8b 56 14             	mov    0x14(%esi),%edx
80104616:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104619:	b8 54 3d 18 80       	mov    $0x80183d54,%eax
8010461e:	eb 0c                	jmp    8010462c <exit+0xac>
80104620:	05 50 02 00 00       	add    $0x250,%eax
80104625:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
8010462a:	74 1e                	je     8010464a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010462c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104630:	75 ee                	jne    80104620 <exit+0xa0>
80104632:	3b 50 20             	cmp    0x20(%eax),%edx
80104635:	75 e9                	jne    80104620 <exit+0xa0>
      p->state = RUNNABLE;
80104637:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010463e:	05 50 02 00 00       	add    $0x250,%eax
80104643:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
80104648:	75 e2                	jne    8010462c <exit+0xac>
      p->parent = initproc;
8010464a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104650:	ba 54 3d 18 80       	mov    $0x80183d54,%edx
80104655:	eb 17                	jmp    8010466e <exit+0xee>
80104657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465e:	66 90                	xchg   %ax,%ax
80104660:	81 c2 50 02 00 00    	add    $0x250,%edx
80104666:	81 fa 54 d1 18 80    	cmp    $0x8018d154,%edx
8010466c:	74 47                	je     801046b5 <exit+0x135>
    if(p->parent == curproc){
8010466e:	39 72 14             	cmp    %esi,0x14(%edx)
80104671:	75 ed                	jne    80104660 <exit+0xe0>
      if(p->state == ZOMBIE)
80104673:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104677:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010467a:	75 e4                	jne    80104660 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010467c:	b8 54 3d 18 80       	mov    $0x80183d54,%eax
80104681:	eb 11                	jmp    80104694 <exit+0x114>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	05 50 02 00 00       	add    $0x250,%eax
8010468d:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
80104692:	74 cc                	je     80104660 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104694:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104698:	75 ee                	jne    80104688 <exit+0x108>
8010469a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010469d:	75 e9                	jne    80104688 <exit+0x108>
      p->state = RUNNABLE;
8010469f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046a6:	eb e0                	jmp    80104688 <exit+0x108>
    panic("exit: error deleting swap file");
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	68 b0 82 10 80       	push   $0x801082b0
801046b0:	e8 db bc ff ff       	call   80100390 <panic>
  curproc->state = ZOMBIE;
801046b5:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801046bc:	e8 ff fd ff ff       	call   801044c0 <sched>
  panic("zombie exit");
801046c1:	83 ec 0c             	sub    $0xc,%esp
801046c4:	68 2e 82 10 80       	push   $0x8010822e
801046c9:	e8 c2 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 21 82 10 80       	push   $0x80108221
801046d6:	e8 b5 bc ff ff       	call   80100390 <panic>
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <yield>:
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	53                   	push   %ebx
801046e8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801046eb:	68 20 3d 18 80       	push   $0x80183d20
801046f0:	e8 fb 06 00 00       	call   80104df0 <acquire>
  pushcli();
801046f5:	e8 f6 05 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801046fa:	e8 81 f8 ff ff       	call   80103f80 <mycpu>
  p = c->proc;
801046ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104705:	e8 36 06 00 00       	call   80104d40 <popcli>
  myproc()->state = RUNNABLE;
8010470a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104711:	e8 aa fd ff ff       	call   801044c0 <sched>
  release(&ptable.lock);
80104716:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
8010471d:	e8 8e 07 00 00       	call   80104eb0 <release>
}
80104722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	c9                   	leave  
80104729:	c3                   	ret    
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104730 <sleep>:
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	56                   	push   %esi
80104739:	53                   	push   %ebx
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104740:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104743:	e8 a8 05 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104748:	e8 33 f8 ff ff       	call   80103f80 <mycpu>
  p = c->proc;
8010474d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104753:	e8 e8 05 00 00       	call   80104d40 <popcli>
  if(p == 0)
80104758:	85 db                	test   %ebx,%ebx
8010475a:	0f 84 83 00 00 00    	je     801047e3 <sleep+0xb3>
  if(lk == 0)
80104760:	85 f6                	test   %esi,%esi
80104762:	74 72                	je     801047d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104764:	81 fe 20 3d 18 80    	cmp    $0x80183d20,%esi
8010476a:	74 4c                	je     801047b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 20 3d 18 80       	push   $0x80183d20
80104774:	e8 77 06 00 00       	call   80104df0 <acquire>
    release(lk);
80104779:	89 34 24             	mov    %esi,(%esp)
8010477c:	e8 2f 07 00 00       	call   80104eb0 <release>
  p->chan = chan;
80104781:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104784:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010478b:	e8 30 fd ff ff       	call   801044c0 <sched>
  p->chan = 0;
80104790:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104797:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
8010479e:	e8 0d 07 00 00       	call   80104eb0 <release>
    acquire(lk);
801047a3:	89 75 08             	mov    %esi,0x8(%ebp)
801047a6:	83 c4 10             	add    $0x10,%esp
}
801047a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047ac:	5b                   	pop    %ebx
801047ad:	5e                   	pop    %esi
801047ae:	5f                   	pop    %edi
801047af:	5d                   	pop    %ebp
    acquire(lk);
801047b0:	e9 3b 06 00 00       	jmp    80104df0 <acquire>
801047b5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801047b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047c2:	e8 f9 fc ff ff       	call   801044c0 <sched>
  p->chan = 0;
801047c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d1:	5b                   	pop    %ebx
801047d2:	5e                   	pop    %esi
801047d3:	5f                   	pop    %edi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
    panic("sleep without lk");
801047d6:	83 ec 0c             	sub    $0xc,%esp
801047d9:	68 40 82 10 80       	push   $0x80108240
801047de:	e8 ad bb ff ff       	call   80100390 <panic>
    panic("sleep");
801047e3:	83 ec 0c             	sub    $0xc,%esp
801047e6:	68 3a 82 10 80       	push   $0x8010823a
801047eb:	e8 a0 bb ff ff       	call   80100390 <panic>

801047f0 <wait>:
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	56                   	push   %esi
801047f8:	53                   	push   %ebx
  pushcli();
801047f9:	e8 f2 04 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801047fe:	e8 7d f7 ff ff       	call   80103f80 <mycpu>
  p = c->proc;
80104803:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104809:	e8 32 05 00 00       	call   80104d40 <popcli>
  acquire(&ptable.lock);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	68 20 3d 18 80       	push   $0x80183d20
80104816:	e8 d5 05 00 00       	call   80104df0 <acquire>
8010481b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010481e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104820:	bb 54 3d 18 80       	mov    $0x80183d54,%ebx
80104825:	eb 17                	jmp    8010483e <wait+0x4e>
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax
80104830:	81 c3 50 02 00 00    	add    $0x250,%ebx
80104836:	81 fb 54 d1 18 80    	cmp    $0x8018d154,%ebx
8010483c:	74 1e                	je     8010485c <wait+0x6c>
      if(p->parent != curproc)
8010483e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104841:	75 ed                	jne    80104830 <wait+0x40>
      if(p->state == ZOMBIE){
80104843:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104847:	74 37                	je     80104880 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104849:	81 c3 50 02 00 00    	add    $0x250,%ebx
      havekids = 1;
8010484f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104854:	81 fb 54 d1 18 80    	cmp    $0x8018d154,%ebx
8010485a:	75 e2                	jne    8010483e <wait+0x4e>
    if(!havekids || curproc->killed){
8010485c:	85 c0                	test   %eax,%eax
8010485e:	74 76                	je     801048d6 <wait+0xe6>
80104860:	8b 46 24             	mov    0x24(%esi),%eax
80104863:	85 c0                	test   %eax,%eax
80104865:	75 6f                	jne    801048d6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104867:	83 ec 08             	sub    $0x8,%esp
8010486a:	68 20 3d 18 80       	push   $0x80183d20
8010486f:	56                   	push   %esi
80104870:	e8 bb fe ff ff       	call   80104730 <sleep>
    havekids = 0;
80104875:	83 c4 10             	add    $0x10,%esp
80104878:	eb a4                	jmp    8010481e <wait+0x2e>
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104886:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104889:	e8 72 df ff ff       	call   80102800 <kfree>
        freevm(p->pgdir);
8010488e:	5a                   	pop    %edx
8010488f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104892:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104899:	e8 22 2e 00 00       	call   801076c0 <freevm>
        release(&ptable.lock);
8010489e:	c7 04 24 20 3d 18 80 	movl   $0x80183d20,(%esp)
        p->pid = 0;
801048a5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048ac:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048b3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048b7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048be:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048c5:	e8 e6 05 00 00       	call   80104eb0 <release>
        return pid;
801048ca:	83 c4 10             	add    $0x10,%esp
}
801048cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d0:	89 f0                	mov    %esi,%eax
801048d2:	5b                   	pop    %ebx
801048d3:	5e                   	pop    %esi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
      release(&ptable.lock);
801048d6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048de:	68 20 3d 18 80       	push   $0x80183d20
801048e3:	e8 c8 05 00 00       	call   80104eb0 <release>
      return -1;
801048e8:	83 c4 10             	add    $0x10,%esp
801048eb:	eb e0                	jmp    801048cd <wait+0xdd>
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	53                   	push   %ebx
801048f8:	83 ec 10             	sub    $0x10,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048fe:	68 20 3d 18 80       	push   $0x80183d20
80104903:	e8 e8 04 00 00       	call   80104df0 <acquire>
80104908:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010490b:	b8 54 3d 18 80       	mov    $0x80183d54,%eax
80104910:	eb 12                	jmp    80104924 <wakeup+0x34>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104918:	05 50 02 00 00       	add    $0x250,%eax
8010491d:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
80104922:	74 1e                	je     80104942 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104924:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104928:	75 ee                	jne    80104918 <wakeup+0x28>
8010492a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010492d:	75 e9                	jne    80104918 <wakeup+0x28>
      p->state = RUNNABLE;
8010492f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104936:	05 50 02 00 00       	add    $0x250,%eax
8010493b:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
80104940:	75 e2                	jne    80104924 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104942:	c7 45 08 20 3d 18 80 	movl   $0x80183d20,0x8(%ebp)
}
80104949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010494c:	c9                   	leave  
  release(&ptable.lock);
8010494d:	e9 5e 05 00 00       	jmp    80104eb0 <release>
80104952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104960 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	53                   	push   %ebx
80104968:	83 ec 10             	sub    $0x10,%esp
8010496b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010496e:	68 20 3d 18 80       	push   $0x80183d20
80104973:	e8 78 04 00 00       	call   80104df0 <acquire>
80104978:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010497b:	b8 54 3d 18 80       	mov    $0x80183d54,%eax
80104980:	eb 12                	jmp    80104994 <kill+0x34>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104988:	05 50 02 00 00       	add    $0x250,%eax
8010498d:	3d 54 d1 18 80       	cmp    $0x8018d154,%eax
80104992:	74 34                	je     801049c8 <kill+0x68>
    if(p->pid == pid){
80104994:	39 58 10             	cmp    %ebx,0x10(%eax)
80104997:	75 ef                	jne    80104988 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104999:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010499d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049a4:	75 07                	jne    801049ad <kill+0x4d>
        p->state = RUNNABLE;
801049a6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	68 20 3d 18 80       	push   $0x80183d20
801049b5:	e8 f6 04 00 00       	call   80104eb0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	31 c0                	xor    %eax,%eax
}
801049c2:	c9                   	leave  
801049c3:	c3                   	ret    
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	68 20 3d 18 80       	push   $0x80183d20
801049d0:	e8 db 04 00 00       	call   80104eb0 <release>
}
801049d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801049d8:	83 c4 10             	add    $0x10,%esp
801049db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	57                   	push   %edi
801049f8:	56                   	push   %esi
801049f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801049fc:	53                   	push   %ebx
801049fd:	bb c0 3d 18 80       	mov    $0x80183dc0,%ebx
80104a02:	83 ec 3c             	sub    $0x3c,%esp
80104a05:	eb 2b                	jmp    80104a32 <procdump+0x42>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	68 1b 86 10 80       	push   $0x8010861b
80104a18:	e8 93 bc ff ff       	call   801006b0 <cprintf>
80104a1d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a20:	81 c3 50 02 00 00    	add    $0x250,%ebx
80104a26:	81 fb c0 d1 18 80    	cmp    $0x8018d1c0,%ebx
80104a2c:	0f 84 8e 00 00 00    	je     80104ac0 <procdump+0xd0>
    if(p->state == UNUSED)
80104a32:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a35:	85 c0                	test   %eax,%eax
80104a37:	74 e7                	je     80104a20 <procdump+0x30>
      state = "???";
80104a39:	ba 51 82 10 80       	mov    $0x80108251,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a3e:	83 f8 05             	cmp    $0x5,%eax
80104a41:	77 11                	ja     80104a54 <procdump+0x64>
80104a43:	8b 14 85 d0 82 10 80 	mov    -0x7fef7d30(,%eax,4),%edx
      state = "???";
80104a4a:	b8 51 82 10 80       	mov    $0x80108251,%eax
80104a4f:	85 d2                	test   %edx,%edx
80104a51:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a54:	53                   	push   %ebx
80104a55:	52                   	push   %edx
80104a56:	ff 73 a4             	pushl  -0x5c(%ebx)
80104a59:	68 55 82 10 80       	push   $0x80108255
80104a5e:	e8 4d bc ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104a63:	83 c4 10             	add    $0x10,%esp
80104a66:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a6a:	75 a4                	jne    80104a10 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a6c:	83 ec 08             	sub    $0x8,%esp
80104a6f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a72:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a75:	50                   	push   %eax
80104a76:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a79:	8b 40 0c             	mov    0xc(%eax),%eax
80104a7c:	83 c0 08             	add    $0x8,%eax
80104a7f:	50                   	push   %eax
80104a80:	e8 0b 02 00 00       	call   80104c90 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a85:	83 c4 10             	add    $0x10,%esp
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop
80104a90:	8b 17                	mov    (%edi),%edx
80104a92:	85 d2                	test   %edx,%edx
80104a94:	0f 84 76 ff ff ff    	je     80104a10 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104a9a:	83 ec 08             	sub    $0x8,%esp
80104a9d:	83 c7 04             	add    $0x4,%edi
80104aa0:	52                   	push   %edx
80104aa1:	68 21 7c 10 80       	push   $0x80107c21
80104aa6:	e8 05 bc ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104aab:	83 c4 10             	add    $0x10,%esp
80104aae:	39 fe                	cmp    %edi,%esi
80104ab0:	75 de                	jne    80104a90 <procdump+0xa0>
80104ab2:	e9 59 ff ff ff       	jmp    80104a10 <procdump+0x20>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax
  }
}
80104ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac3:	5b                   	pop    %ebx
80104ac4:	5e                   	pop    %esi
80104ac5:	5f                   	pop    %edi
80104ac6:	5d                   	pop    %ebp
80104ac7:	c3                   	ret    
80104ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop

80104ad0 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104ad8:	31 db                	xor    %ebx,%ebx
{
80104ada:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104add:	68 20 3d 18 80       	push   $0x80183d20
80104ae2:	e8 09 03 00 00       	call   80104df0 <acquire>
80104ae7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aea:	ba 54 3d 18 80       	mov    $0x80183d54,%edx
80104aef:	90                   	nop
  {
    if(p->state == UNUSED)
80104af0:	8b 42 0c             	mov    0xc(%edx),%eax
80104af3:	85 c0                	test   %eax,%eax
80104af5:	74 09                	je     80104b00 <getTotalFreePages+0x30>
      continue;
    sum += MAX_PSYC_PAGES - p->nummemorypages;
80104af7:	83 c3 10             	add    $0x10,%ebx
80104afa:	2b 9a 80 00 00 00    	sub    0x80(%edx),%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b00:	81 c2 50 02 00 00    	add    $0x250,%edx
80104b06:	81 fa 54 d1 18 80    	cmp    $0x8018d154,%edx
80104b0c:	75 e2                	jne    80104af0 <getTotalFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104b0e:	83 ec 0c             	sub    $0xc,%esp
80104b11:	68 20 3d 18 80       	push   $0x80183d20
80104b16:	e8 95 03 00 00       	call   80104eb0 <release>
  return sum;
80104b1b:	89 d8                	mov    %ebx,%eax
80104b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b20:	c9                   	leave  
80104b21:	c3                   	ret    
80104b22:	66 90                	xchg   %ax,%ax
80104b24:	66 90                	xchg   %ax,%ax
80104b26:	66 90                	xchg   %ax,%ax
80104b28:	66 90                	xchg   %ax,%ax
80104b2a:	66 90                	xchg   %ax,%ax
80104b2c:	66 90                	xchg   %ax,%ax
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	53                   	push   %ebx
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b3e:	68 e8 82 10 80       	push   $0x801082e8
80104b43:	8d 43 04             	lea    0x4(%ebx),%eax
80104b46:	50                   	push   %eax
80104b47:	e8 24 01 00 00       	call   80104c70 <initlock>
  lk->name = name;
80104b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b55:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b5f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
80104b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	56                   	push   %esi
80104b83:	e8 68 02 00 00       	call   80104df0 <acquire>
  while (lk->locked) {
80104b88:	8b 13                	mov    (%ebx),%edx
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 d2                	test   %edx,%edx
80104b8f:	74 1a                	je     80104bab <acquiresleep+0x3b>
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b98:	83 ec 08             	sub    $0x8,%esp
80104b9b:	56                   	push   %esi
80104b9c:	53                   	push   %ebx
80104b9d:	e8 8e fb ff ff       	call   80104730 <sleep>
  while (lk->locked) {
80104ba2:	8b 03                	mov    (%ebx),%eax
80104ba4:	83 c4 10             	add    $0x10,%esp
80104ba7:	85 c0                	test   %eax,%eax
80104ba9:	75 ed                	jne    80104b98 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104bab:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bb1:	e8 5a f4 ff ff       	call   80104010 <myproc>
80104bb6:	8b 40 10             	mov    0x10(%eax),%eax
80104bb9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bbc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc2:	5b                   	pop    %ebx
80104bc3:	5e                   	pop    %esi
80104bc4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bc5:	e9 e6 02 00 00       	jmp    80104eb0 <release>
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	56                   	push   %esi
80104bd8:	53                   	push   %ebx
80104bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bdc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	56                   	push   %esi
80104be3:	e8 08 02 00 00       	call   80104df0 <acquire>
  lk->locked = 0;
80104be8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bee:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104bf5:	89 1c 24             	mov    %ebx,(%esp)
80104bf8:	e8 f3 fc ff ff       	call   801048f0 <wakeup>
  release(&lk->lk);
80104bfd:	89 75 08             	mov    %esi,0x8(%ebp)
80104c00:	83 c4 10             	add    $0x10,%esp
}
80104c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c06:	5b                   	pop    %ebx
80104c07:	5e                   	pop    %esi
80104c08:	5d                   	pop    %ebp
  release(&lk->lk);
80104c09:	e9 a2 02 00 00       	jmp    80104eb0 <release>
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	57                   	push   %edi
80104c18:	31 ff                	xor    %edi,%edi
80104c1a:	56                   	push   %esi
80104c1b:	53                   	push   %ebx
80104c1c:	83 ec 18             	sub    $0x18,%esp
80104c1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c22:	8d 73 04             	lea    0x4(%ebx),%esi
80104c25:	56                   	push   %esi
80104c26:	e8 c5 01 00 00       	call   80104df0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c2b:	8b 03                	mov    (%ebx),%eax
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	75 1c                	jne    80104c50 <holdingsleep+0x40>
  release(&lk->lk);
80104c34:	83 ec 0c             	sub    $0xc,%esp
80104c37:	56                   	push   %esi
80104c38:	e8 73 02 00 00       	call   80104eb0 <release>
  return r;
}
80104c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c40:	89 f8                	mov    %edi,%eax
80104c42:	5b                   	pop    %ebx
80104c43:	5e                   	pop    %esi
80104c44:	5f                   	pop    %edi
80104c45:	5d                   	pop    %ebp
80104c46:	c3                   	ret    
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c53:	e8 b8 f3 ff ff       	call   80104010 <myproc>
80104c58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c5b:	0f 94 c0             	sete   %al
80104c5e:	0f b6 c0             	movzbl %al,%eax
80104c61:	89 c7                	mov    %eax,%edi
80104c63:	eb cf                	jmp    80104c34 <holdingsleep+0x24>
80104c65:	66 90                	xchg   %ax,%ax
80104c67:	66 90                	xchg   %ax,%ax
80104c69:	66 90                	xchg   %ax,%ax
80104c6b:	66 90                	xchg   %ax,%ax
80104c6d:	66 90                	xchg   %ax,%ax
80104c6f:	90                   	nop

80104c70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c83:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c8d:	5d                   	pop    %ebp
80104c8e:	c3                   	ret    
80104c8f:	90                   	nop

80104c90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c95:	31 d2                	xor    %edx,%edx
{
80104c97:	89 e5                	mov    %esp,%ebp
80104c99:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c9a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ca0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ca7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cb4:	77 1a                	ja     80104cd0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cb6:	8b 58 04             	mov    0x4(%eax),%ebx
80104cb9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cbc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cbf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cc1:	83 fa 0a             	cmp    $0xa,%edx
80104cc4:	75 e2                	jne    80104ca8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cc6:	5b                   	pop    %ebx
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104cd0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cd3:	8d 51 28             	lea    0x28(%ecx),%edx
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ce6:	83 c0 04             	add    $0x4,%eax
80104ce9:	39 d0                	cmp    %edx,%eax
80104ceb:	75 f3                	jne    80104ce0 <getcallerpcs+0x50>
}
80104ced:	5b                   	pop    %ebx
80104cee:	5d                   	pop    %ebp
80104cef:	c3                   	ret    

80104cf0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	53                   	push   %ebx
80104cf8:	83 ec 04             	sub    $0x4,%esp
80104cfb:	9c                   	pushf  
80104cfc:	5b                   	pop    %ebx
  asm volatile("cli");
80104cfd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cfe:	e8 7d f2 ff ff       	call   80103f80 <mycpu>
80104d03:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d09:	85 c0                	test   %eax,%eax
80104d0b:	74 13                	je     80104d20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d0d:	e8 6e f2 ff ff       	call   80103f80 <mycpu>
80104d12:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d19:	83 c4 04             	add    $0x4,%esp
80104d1c:	5b                   	pop    %ebx
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    
80104d1f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d20:	e8 5b f2 ff ff       	call   80103f80 <mycpu>
80104d25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d31:	eb da                	jmp    80104d0d <pushcli+0x1d>
80104d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d40 <popcli>:

void
popcli(void)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d4a:	9c                   	pushf  
80104d4b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d4c:	f6 c4 02             	test   $0x2,%ah
80104d4f:	75 31                	jne    80104d82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d51:	e8 2a f2 ff ff       	call   80103f80 <mycpu>
80104d56:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d5d:	78 30                	js     80104d8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d5f:	e8 1c f2 ff ff       	call   80103f80 <mycpu>
80104d64:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d6a:	85 d2                	test   %edx,%edx
80104d6c:	74 02                	je     80104d70 <popcli+0x30>
    sti();
}
80104d6e:	c9                   	leave  
80104d6f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d70:	e8 0b f2 ff ff       	call   80103f80 <mycpu>
80104d75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	74 ef                	je     80104d6e <popcli+0x2e>
  asm volatile("sti");
80104d7f:	fb                   	sti    
}
80104d80:	c9                   	leave  
80104d81:	c3                   	ret    
    panic("popcli - interruptible");
80104d82:	83 ec 0c             	sub    $0xc,%esp
80104d85:	68 f3 82 10 80       	push   $0x801082f3
80104d8a:	e8 01 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	68 0a 83 10 80       	push   $0x8010830a
80104d97:	e8 f4 b5 ff ff       	call   80100390 <panic>
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <holding>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	53                   	push   %ebx
80104da9:	8b 75 08             	mov    0x8(%ebp),%esi
80104dac:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dae:	e8 3d ff ff ff       	call   80104cf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104db3:	8b 06                	mov    (%esi),%eax
80104db5:	85 c0                	test   %eax,%eax
80104db7:	75 0f                	jne    80104dc8 <holding+0x28>
  popcli();
80104db9:	e8 82 ff ff ff       	call   80104d40 <popcli>
}
80104dbe:	89 d8                	mov    %ebx,%eax
80104dc0:	5b                   	pop    %ebx
80104dc1:	5e                   	pop    %esi
80104dc2:	5d                   	pop    %ebp
80104dc3:	c3                   	ret    
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104dc8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dcb:	e8 b0 f1 ff ff       	call   80103f80 <mycpu>
80104dd0:	39 c3                	cmp    %eax,%ebx
80104dd2:	0f 94 c3             	sete   %bl
  popcli();
80104dd5:	e8 66 ff ff ff       	call   80104d40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104dda:	0f b6 db             	movzbl %bl,%ebx
}
80104ddd:	89 d8                	mov    %ebx,%eax
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <acquire>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	56                   	push   %esi
80104df8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104df9:	e8 f2 fe ff ff       	call   80104cf0 <pushcli>
  if(holding(lk))
80104dfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e01:	83 ec 0c             	sub    $0xc,%esp
80104e04:	53                   	push   %ebx
80104e05:	e8 96 ff ff ff       	call   80104da0 <holding>
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	0f 85 7f 00 00 00    	jne    80104e94 <acquire+0xa4>
80104e15:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e17:	ba 01 00 00 00       	mov    $0x1,%edx
80104e1c:	eb 05                	jmp    80104e23 <acquire+0x33>
80104e1e:	66 90                	xchg   %ax,%ax
80104e20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e23:	89 d0                	mov    %edx,%eax
80104e25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	75 f4                	jne    80104e20 <acquire+0x30>
  __sync_synchronize();
80104e2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e34:	e8 47 f1 ff ff       	call   80103f80 <mycpu>
80104e39:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e3c:	89 e8                	mov    %ebp,%eax
80104e3e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e40:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e46:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e4c:	77 22                	ja     80104e70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e4e:	8b 50 04             	mov    0x4(%eax),%edx
80104e51:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e55:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e58:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e5a:	83 fe 0a             	cmp    $0xa,%esi
80104e5d:	75 e1                	jne    80104e40 <acquire+0x50>
}
80104e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e62:	5b                   	pop    %ebx
80104e63:	5e                   	pop    %esi
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e70:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e74:	83 c3 34             	add    $0x34,%ebx
80104e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e86:	83 c0 04             	add    $0x4,%eax
80104e89:	39 d8                	cmp    %ebx,%eax
80104e8b:	75 f3                	jne    80104e80 <acquire+0x90>
}
80104e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e90:	5b                   	pop    %ebx
80104e91:	5e                   	pop    %esi
80104e92:	5d                   	pop    %ebp
80104e93:	c3                   	ret    
    panic("acquire");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 11 83 10 80       	push   $0x80108311
80104e9c:	e8 ef b4 ff ff       	call   80100390 <panic>
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop

80104eb0 <release>:
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	53                   	push   %ebx
80104eb8:	83 ec 10             	sub    $0x10,%esp
80104ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104ebe:	53                   	push   %ebx
80104ebf:	e8 dc fe ff ff       	call   80104da0 <holding>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	74 22                	je     80104eed <release+0x3d>
  lk->pcs[0] = 0;
80104ecb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ed2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ed9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ede:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee7:	c9                   	leave  
  popcli();
80104ee8:	e9 53 fe ff ff       	jmp    80104d40 <popcli>
    panic("release");
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	68 19 83 10 80       	push   $0x80108319
80104ef5:	e8 96 b4 ff ff       	call   80100390 <panic>
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	57                   	push   %edi
80104f08:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f0e:	53                   	push   %ebx
80104f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f12:	89 d7                	mov    %edx,%edi
80104f14:	09 cf                	or     %ecx,%edi
80104f16:	83 e7 03             	and    $0x3,%edi
80104f19:	75 25                	jne    80104f40 <memset+0x40>
    c &= 0xFF;
80104f1b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f1e:	c1 e0 18             	shl    $0x18,%eax
80104f21:	89 fb                	mov    %edi,%ebx
80104f23:	c1 e9 02             	shr    $0x2,%ecx
80104f26:	c1 e3 10             	shl    $0x10,%ebx
80104f29:	09 d8                	or     %ebx,%eax
80104f2b:	09 f8                	or     %edi,%eax
80104f2d:	c1 e7 08             	shl    $0x8,%edi
80104f30:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f32:	89 d7                	mov    %edx,%edi
80104f34:	fc                   	cld    
80104f35:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f37:	5b                   	pop    %ebx
80104f38:	89 d0                	mov    %edx,%eax
80104f3a:	5f                   	pop    %edi
80104f3b:	5d                   	pop    %ebp
80104f3c:	c3                   	ret    
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f40:	89 d7                	mov    %edx,%edi
80104f42:	fc                   	cld    
80104f43:	f3 aa                	rep stos %al,%es:(%edi)
80104f45:	5b                   	pop    %ebx
80104f46:	89 d0                	mov    %edx,%eax
80104f48:	5f                   	pop    %edi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop

80104f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	8b 75 10             	mov    0x10(%ebp),%esi
80104f5b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f62:	85 f6                	test   %esi,%esi
80104f64:	74 2a                	je     80104f90 <memcmp+0x40>
80104f66:	01 c6                	add    %eax,%esi
80104f68:	eb 10                	jmp    80104f7a <memcmp+0x2a>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f76:	39 f0                	cmp    %esi,%eax
80104f78:	74 16                	je     80104f90 <memcmp+0x40>
    if(*s1 != *s2)
80104f7a:	0f b6 0a             	movzbl (%edx),%ecx
80104f7d:	0f b6 18             	movzbl (%eax),%ebx
80104f80:	38 d9                	cmp    %bl,%cl
80104f82:	74 ec                	je     80104f70 <memcmp+0x20>
      return *s1 - *s2;
80104f84:	0f b6 c1             	movzbl %cl,%eax
80104f87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
80104f90:	5b                   	pop    %ebx
  return 0;
80104f91:	31 c0                	xor    %eax,%eax
}
80104f93:	5e                   	pop    %esi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fae:	56                   	push   %esi
80104faf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fb2:	39 d6                	cmp    %edx,%esi
80104fb4:	73 2a                	jae    80104fe0 <memmove+0x40>
80104fb6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fb9:	39 fa                	cmp    %edi,%edx
80104fbb:	73 23                	jae    80104fe0 <memmove+0x40>
80104fbd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104fc0:	85 c9                	test   %ecx,%ecx
80104fc2:	74 13                	je     80104fd7 <memmove+0x37>
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104fc8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104fcc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fcf:	83 e8 01             	sub    $0x1,%eax
80104fd2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104fd5:	75 f1                	jne    80104fc8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fd7:	5e                   	pop    %esi
80104fd8:	89 d0                	mov    %edx,%eax
80104fda:	5f                   	pop    %edi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fe0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fe3:	89 d7                	mov    %edx,%edi
80104fe5:	85 c9                	test   %ecx,%ecx
80104fe7:	74 ee                	je     80104fd7 <memmove+0x37>
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ff0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ff1:	39 f0                	cmp    %esi,%eax
80104ff3:	75 fb                	jne    80104ff0 <memmove+0x50>
}
80104ff5:	5e                   	pop    %esi
80104ff6:	89 d0                	mov    %edx,%eax
80104ff8:	5f                   	pop    %edi
80104ff9:	5d                   	pop    %ebp
80104ffa:	c3                   	ret    
80104ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop

80105000 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105000:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105004:	eb 9a                	jmp    80104fa0 <memmove>
80105006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	56                   	push   %esi
80105018:	8b 75 10             	mov    0x10(%ebp),%esi
8010501b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010501e:	53                   	push   %ebx
8010501f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105022:	85 f6                	test   %esi,%esi
80105024:	74 32                	je     80105058 <strncmp+0x48>
80105026:	01 c6                	add    %eax,%esi
80105028:	eb 14                	jmp    8010503e <strncmp+0x2e>
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105030:	38 da                	cmp    %bl,%dl
80105032:	75 14                	jne    80105048 <strncmp+0x38>
    n--, p++, q++;
80105034:	83 c0 01             	add    $0x1,%eax
80105037:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010503a:	39 f0                	cmp    %esi,%eax
8010503c:	74 1a                	je     80105058 <strncmp+0x48>
8010503e:	0f b6 11             	movzbl (%ecx),%edx
80105041:	0f b6 18             	movzbl (%eax),%ebx
80105044:	84 d2                	test   %dl,%dl
80105046:	75 e8                	jne    80105030 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105048:	0f b6 c2             	movzbl %dl,%eax
8010504b:	29 d8                	sub    %ebx,%eax
}
8010504d:	5b                   	pop    %ebx
8010504e:	5e                   	pop    %esi
8010504f:	5d                   	pop    %ebp
80105050:	c3                   	ret    
80105051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105058:	5b                   	pop    %ebx
    return 0;
80105059:	31 c0                	xor    %eax,%eax
}
8010505b:	5e                   	pop    %esi
8010505c:	5d                   	pop    %ebp
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax

80105060 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	57                   	push   %edi
80105068:	56                   	push   %esi
80105069:	8b 75 08             	mov    0x8(%ebp),%esi
8010506c:	53                   	push   %ebx
8010506d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105070:	89 f2                	mov    %esi,%edx
80105072:	eb 1b                	jmp    8010508f <strncpy+0x2f>
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105078:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010507c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010507f:	83 c2 01             	add    $0x1,%edx
80105082:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105086:	89 f9                	mov    %edi,%ecx
80105088:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508b:	84 c9                	test   %cl,%cl
8010508d:	74 09                	je     80105098 <strncpy+0x38>
8010508f:	89 c3                	mov    %eax,%ebx
80105091:	83 e8 01             	sub    $0x1,%eax
80105094:	85 db                	test   %ebx,%ebx
80105096:	7f e0                	jg     80105078 <strncpy+0x18>
    ;
  while(n-- > 0)
80105098:	89 d1                	mov    %edx,%ecx
8010509a:	85 c0                	test   %eax,%eax
8010509c:	7e 15                	jle    801050b3 <strncpy+0x53>
8010509e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801050a0:	83 c1 01             	add    $0x1,%ecx
801050a3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801050a7:	89 c8                	mov    %ecx,%eax
801050a9:	f7 d0                	not    %eax
801050ab:	01 d0                	add    %edx,%eax
801050ad:	01 d8                	add    %ebx,%eax
801050af:	85 c0                	test   %eax,%eax
801050b1:	7f ed                	jg     801050a0 <strncpy+0x40>
  return os;
}
801050b3:	5b                   	pop    %ebx
801050b4:	89 f0                	mov    %esi,%eax
801050b6:	5e                   	pop    %esi
801050b7:	5f                   	pop    %edi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	56                   	push   %esi
801050c8:	8b 55 10             	mov    0x10(%ebp),%edx
801050cb:	8b 75 08             	mov    0x8(%ebp),%esi
801050ce:	53                   	push   %ebx
801050cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050d2:	85 d2                	test   %edx,%edx
801050d4:	7e 21                	jle    801050f7 <safestrcpy+0x37>
801050d6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050da:	89 f2                	mov    %esi,%edx
801050dc:	eb 12                	jmp    801050f0 <safestrcpy+0x30>
801050de:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050e0:	0f b6 08             	movzbl (%eax),%ecx
801050e3:	83 c0 01             	add    $0x1,%eax
801050e6:	83 c2 01             	add    $0x1,%edx
801050e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050ec:	84 c9                	test   %cl,%cl
801050ee:	74 04                	je     801050f4 <safestrcpy+0x34>
801050f0:	39 d8                	cmp    %ebx,%eax
801050f2:	75 ec                	jne    801050e0 <safestrcpy+0x20>
    ;
  *s = 0;
801050f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050f7:	89 f0                	mov    %esi,%eax
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi

80105100 <strlen>:

int
strlen(const char *s)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105105:	31 c0                	xor    %eax,%eax
{
80105107:	89 e5                	mov    %esp,%ebp
80105109:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010510c:	80 3a 00             	cmpb   $0x0,(%edx)
8010510f:	74 10                	je     80105121 <strlen+0x21>
80105111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105118:	83 c0 01             	add    $0x1,%eax
8010511b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010511f:	75 f7                	jne    80105118 <strlen+0x18>
    ;
  return n;
}
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret    

80105123 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105123:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105127:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010512b:	55                   	push   %ebp
  pushl %ebx
8010512c:	53                   	push   %ebx
  pushl %esi
8010512d:	56                   	push   %esi
  pushl %edi
8010512e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010512f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105131:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105133:	5f                   	pop    %edi
  popl %esi
80105134:	5e                   	pop    %esi
  popl %ebx
80105135:	5b                   	pop    %ebx
  popl %ebp
80105136:	5d                   	pop    %ebp
  ret
80105137:	c3                   	ret    
80105138:	66 90                	xchg   %ax,%ax
8010513a:	66 90                	xchg   %ax,%ax
8010513c:	66 90                	xchg   %ax,%ax
8010513e:	66 90                	xchg   %ax,%ax

80105140 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
80105145:	89 e5                	mov    %esp,%ebp
80105147:	53                   	push   %ebx
80105148:	83 ec 04             	sub    $0x4,%esp
8010514b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010514e:	e8 bd ee ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105153:	8b 00                	mov    (%eax),%eax
80105155:	39 d8                	cmp    %ebx,%eax
80105157:	76 17                	jbe    80105170 <fetchint+0x30>
80105159:	8d 53 04             	lea    0x4(%ebx),%edx
8010515c:	39 d0                	cmp    %edx,%eax
8010515e:	72 10                	jb     80105170 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105160:	8b 45 0c             	mov    0xc(%ebp),%eax
80105163:	8b 13                	mov    (%ebx),%edx
80105165:	89 10                	mov    %edx,(%eax)
  return 0;
80105167:	31 c0                	xor    %eax,%eax
}
80105169:	83 c4 04             	add    $0x4,%esp
8010516c:	5b                   	pop    %ebx
8010516d:	5d                   	pop    %ebp
8010516e:	c3                   	ret    
8010516f:	90                   	nop
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105175:	eb f2                	jmp    80105169 <fetchint+0x29>
80105177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517e:	66 90                	xchg   %ax,%ax

80105180 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	53                   	push   %ebx
80105188:	83 ec 04             	sub    $0x4,%esp
8010518b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010518e:	e8 7d ee ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz)
80105193:	39 18                	cmp    %ebx,(%eax)
80105195:	76 31                	jbe    801051c8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105197:	8b 55 0c             	mov    0xc(%ebp),%edx
8010519a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010519c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010519e:	39 d3                	cmp    %edx,%ebx
801051a0:	73 26                	jae    801051c8 <fetchstr+0x48>
801051a2:	89 d8                	mov    %ebx,%eax
801051a4:	eb 11                	jmp    801051b7 <fetchstr+0x37>
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c0 01             	add    $0x1,%eax
801051b3:	39 c2                	cmp    %eax,%edx
801051b5:	76 11                	jbe    801051c8 <fetchstr+0x48>
    if(*s == 0)
801051b7:	80 38 00             	cmpb   $0x0,(%eax)
801051ba:	75 f4                	jne    801051b0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801051bc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801051bf:	29 d8                	sub    %ebx,%eax
}
801051c1:	5b                   	pop    %ebx
801051c2:	5d                   	pop    %ebp
801051c3:	c3                   	ret    
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c8:	83 c4 04             	add    $0x4,%esp
    return -1;
801051cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d0:	5b                   	pop    %ebx
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    
801051d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	56                   	push   %esi
801051e8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051e9:	e8 22 ee ff ff       	call   80104010 <myproc>
801051ee:	8b 55 08             	mov    0x8(%ebp),%edx
801051f1:	8b 40 18             	mov    0x18(%eax),%eax
801051f4:	8b 40 44             	mov    0x44(%eax),%eax
801051f7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051fa:	e8 11 ee ff ff       	call   80104010 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ff:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105202:	8b 00                	mov    (%eax),%eax
80105204:	39 c6                	cmp    %eax,%esi
80105206:	73 18                	jae    80105220 <argint+0x40>
80105208:	8d 53 08             	lea    0x8(%ebx),%edx
8010520b:	39 d0                	cmp    %edx,%eax
8010520d:	72 11                	jb     80105220 <argint+0x40>
  *ip = *(int*)(addr);
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105212:	8b 53 04             	mov    0x4(%ebx),%edx
80105215:	89 10                	mov    %edx,(%eax)
  return 0;
80105217:	31 c0                	xor    %eax,%eax
}
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5d                   	pop    %ebp
8010521c:	c3                   	ret    
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105225:	eb f2                	jmp    80105219 <argint+0x39>
80105227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522e:	66 90                	xchg   %ax,%ax

80105230 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	56                   	push   %esi
80105238:	53                   	push   %ebx
80105239:	83 ec 10             	sub    $0x10,%esp
8010523c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010523f:	e8 cc ed ff ff       	call   80104010 <myproc>
 
  if(argint(n, &i) < 0)
80105244:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105247:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524c:	50                   	push   %eax
8010524d:	ff 75 08             	pushl  0x8(%ebp)
80105250:	e8 8b ff ff ff       	call   801051e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105255:	83 c4 10             	add    $0x10,%esp
80105258:	85 c0                	test   %eax,%eax
8010525a:	78 24                	js     80105280 <argptr+0x50>
8010525c:	85 db                	test   %ebx,%ebx
8010525e:	78 20                	js     80105280 <argptr+0x50>
80105260:	8b 16                	mov    (%esi),%edx
80105262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105265:	39 c2                	cmp    %eax,%edx
80105267:	76 17                	jbe    80105280 <argptr+0x50>
80105269:	01 c3                	add    %eax,%ebx
8010526b:	39 da                	cmp    %ebx,%edx
8010526d:	72 11                	jb     80105280 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010526f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105272:	89 02                	mov    %eax,(%edx)
  return 0;
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105285:	eb ef                	jmp    80105276 <argptr+0x46>
80105287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528e:	66 90                	xchg   %ax,%ax

80105290 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010529a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529d:	50                   	push   %eax
8010529e:	ff 75 08             	pushl  0x8(%ebp)
801052a1:	e8 3a ff ff ff       	call   801051e0 <argint>
801052a6:	83 c4 10             	add    $0x10,%esp
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052ad:	83 ec 08             	sub    $0x8,%esp
801052b0:	ff 75 0c             	pushl  0xc(%ebp)
801052b3:	ff 75 f4             	pushl  -0xc(%ebp)
801052b6:	e8 c5 fe ff ff       	call   80105180 <fetchstr>
801052bb:	83 c4 10             	add    $0x10,%esp
}
801052be:	c9                   	leave  
801052bf:	c3                   	ret    
801052c0:	c9                   	leave  
    return -1;
801052c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c6:	c3                   	ret    
801052c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ce:	66 90                	xchg   %ax,%ax

801052d0 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	53                   	push   %ebx
801052d8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052db:	e8 30 ed ff ff       	call   80104010 <myproc>
801052e0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052e2:	8b 40 18             	mov    0x18(%eax),%eax
801052e5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801052eb:	83 fa 16             	cmp    $0x16,%edx
801052ee:	77 20                	ja     80105310 <syscall+0x40>
801052f0:	8b 14 85 40 83 10 80 	mov    -0x7fef7cc0(,%eax,4),%edx
801052f7:	85 d2                	test   %edx,%edx
801052f9:	74 15                	je     80105310 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052fb:	ff d2                	call   *%edx
801052fd:	89 c2                	mov    %eax,%edx
801052ff:	8b 43 18             	mov    0x18(%ebx),%eax
80105302:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105308:	c9                   	leave  
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105310:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105311:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105314:	50                   	push   %eax
80105315:	ff 73 10             	pushl  0x10(%ebx)
80105318:	68 21 83 10 80       	push   $0x80108321
8010531d:	e8 8e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105322:	8b 43 18             	mov    0x18(%ebx),%eax
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010532f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105332:	c9                   	leave  
80105333:	c3                   	ret    
80105334:	66 90                	xchg   %ax,%ax
80105336:	66 90                	xchg   %ax,%ax
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	89 d6                	mov    %edx,%esi
80105346:	53                   	push   %ebx
80105347:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105349:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010534c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010534f:	50                   	push   %eax
80105350:	6a 00                	push   $0x0
80105352:	e8 89 fe ff ff       	call   801051e0 <argint>
80105357:	83 c4 10             	add    $0x10,%esp
8010535a:	85 c0                	test   %eax,%eax
8010535c:	78 2a                	js     80105388 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010535e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105362:	77 24                	ja     80105388 <argfd.constprop.0+0x48>
80105364:	e8 a7 ec ff ff       	call   80104010 <myproc>
80105369:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010536c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105370:	85 c0                	test   %eax,%eax
80105372:	74 14                	je     80105388 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105374:	85 db                	test   %ebx,%ebx
80105376:	74 02                	je     8010537a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105378:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010537a:	89 06                	mov    %eax,(%esi)
  return 0;
8010537c:	31 c0                	xor    %eax,%eax
}
8010537e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5d                   	pop    %ebp
80105384:	c3                   	ret    
80105385:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538d:	eb ef                	jmp    8010537e <argfd.constprop.0+0x3e>
8010538f:	90                   	nop

80105390 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105395:	31 c0                	xor    %eax,%eax
{
80105397:	89 e5                	mov    %esp,%ebp
80105399:	56                   	push   %esi
8010539a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010539b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010539e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053a1:	e8 9a ff ff ff       	call   80105340 <argfd.constprop.0>
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 1e                	js     801053c8 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801053aa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053ad:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053af:	e8 5c ec ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053b8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053bc:	85 d2                	test   %edx,%edx
801053be:	74 20                	je     801053e0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801053c0:	83 c3 01             	add    $0x1,%ebx
801053c3:	83 fb 10             	cmp    $0x10,%ebx
801053c6:	75 f0                	jne    801053b8 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
801053c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053d0:	89 d8                	mov    %ebx,%eax
801053d2:	5b                   	pop    %ebx
801053d3:	5e                   	pop    %esi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801053e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	ff 75 f4             	pushl  -0xc(%ebp)
801053ea:	e8 91 ba ff ff       	call   80100e80 <filedup>
  return fd;
801053ef:	83 c4 10             	add    $0x10,%esp
}
801053f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053f5:	89 d8                	mov    %ebx,%eax
801053f7:	5b                   	pop    %ebx
801053f8:	5e                   	pop    %esi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop

80105400 <sys_read>:

int
sys_read(void)
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105405:	31 c0                	xor    %eax,%eax
{
80105407:	89 e5                	mov    %esp,%ebp
80105409:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010540c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010540f:	e8 2c ff ff ff       	call   80105340 <argfd.constprop.0>
80105414:	85 c0                	test   %eax,%eax
80105416:	78 48                	js     80105460 <sys_read+0x60>
80105418:	83 ec 08             	sub    $0x8,%esp
8010541b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010541e:	50                   	push   %eax
8010541f:	6a 02                	push   $0x2
80105421:	e8 ba fd ff ff       	call   801051e0 <argint>
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	85 c0                	test   %eax,%eax
8010542b:	78 33                	js     80105460 <sys_read+0x60>
8010542d:	83 ec 04             	sub    $0x4,%esp
80105430:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105433:	ff 75 f0             	pushl  -0x10(%ebp)
80105436:	50                   	push   %eax
80105437:	6a 01                	push   $0x1
80105439:	e8 f2 fd ff ff       	call   80105230 <argptr>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	85 c0                	test   %eax,%eax
80105443:	78 1b                	js     80105460 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105445:	83 ec 04             	sub    $0x4,%esp
80105448:	ff 75 f0             	pushl  -0x10(%ebp)
8010544b:	ff 75 f4             	pushl  -0xc(%ebp)
8010544e:	ff 75 ec             	pushl  -0x14(%ebp)
80105451:	e8 aa bb ff ff       	call   80101000 <fileread>
80105456:	83 c4 10             	add    $0x10,%esp
}
80105459:	c9                   	leave  
8010545a:	c3                   	ret    
8010545b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
80105460:	c9                   	leave  
    return -1;
80105461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105466:	c3                   	ret    
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <sys_write>:

int
sys_write(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105475:	31 c0                	xor    %eax,%eax
{
80105477:	89 e5                	mov    %esp,%ebp
80105479:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010547c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010547f:	e8 bc fe ff ff       	call   80105340 <argfd.constprop.0>
80105484:	85 c0                	test   %eax,%eax
80105486:	78 48                	js     801054d0 <sys_write+0x60>
80105488:	83 ec 08             	sub    $0x8,%esp
8010548b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010548e:	50                   	push   %eax
8010548f:	6a 02                	push   $0x2
80105491:	e8 4a fd ff ff       	call   801051e0 <argint>
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 33                	js     801054d0 <sys_write+0x60>
8010549d:	83 ec 04             	sub    $0x4,%esp
801054a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054a3:	ff 75 f0             	pushl  -0x10(%ebp)
801054a6:	50                   	push   %eax
801054a7:	6a 01                	push   $0x1
801054a9:	e8 82 fd ff ff       	call   80105230 <argptr>
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	85 c0                	test   %eax,%eax
801054b3:	78 1b                	js     801054d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054b5:	83 ec 04             	sub    $0x4,%esp
801054b8:	ff 75 f0             	pushl  -0x10(%ebp)
801054bb:	ff 75 f4             	pushl  -0xc(%ebp)
801054be:	ff 75 ec             	pushl  -0x14(%ebp)
801054c1:	e8 da bb ff ff       	call   801010a0 <filewrite>
801054c6:	83 c4 10             	add    $0x10,%esp
}
801054c9:	c9                   	leave  
801054ca:	c3                   	ret    
801054cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
801054d0:	c9                   	leave  
    return -1;
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d6:	c3                   	ret    
801054d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054de:	66 90                	xchg   %ax,%ax

801054e0 <sys_close>:

int
sys_close(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801054ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054f0:	e8 4b fe ff ff       	call   80105340 <argfd.constprop.0>
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 27                	js     80105520 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801054f9:	e8 12 eb ff ff       	call   80104010 <myproc>
801054fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105501:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105504:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010550b:	00 
  fileclose(f);
8010550c:	ff 75 f4             	pushl  -0xc(%ebp)
8010550f:	e8 bc b9 ff ff       	call   80100ed0 <fileclose>
  return 0;
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	31 c0                	xor    %eax,%eax
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

80105530 <sys_fstat>:

int
sys_fstat(void)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105535:	31 c0                	xor    %eax,%eax
{
80105537:	89 e5                	mov    %esp,%ebp
80105539:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010553c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010553f:	e8 fc fd ff ff       	call   80105340 <argfd.constprop.0>
80105544:	85 c0                	test   %eax,%eax
80105546:	78 30                	js     80105578 <sys_fstat+0x48>
80105548:	83 ec 04             	sub    $0x4,%esp
8010554b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010554e:	6a 14                	push   $0x14
80105550:	50                   	push   %eax
80105551:	6a 01                	push   $0x1
80105553:	e8 d8 fc ff ff       	call   80105230 <argptr>
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	85 c0                	test   %eax,%eax
8010555d:	78 19                	js     80105578 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010555f:	83 ec 08             	sub    $0x8,%esp
80105562:	ff 75 f4             	pushl  -0xc(%ebp)
80105565:	ff 75 f0             	pushl  -0x10(%ebp)
80105568:	e8 43 ba ff ff       	call   80100fb0 <filestat>
8010556d:	83 c4 10             	add    $0x10,%esp
}
80105570:	c9                   	leave  
80105571:	c3                   	ret    
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105578:	c9                   	leave  
    return -1;
80105579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010557e:	c3                   	ret    
8010557f:	90                   	nop

80105580 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	57                   	push   %edi
80105588:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105589:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010558c:	53                   	push   %ebx
8010558d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105590:	50                   	push   %eax
80105591:	6a 00                	push   $0x0
80105593:	e8 f8 fc ff ff       	call   80105290 <argstr>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	0f 88 ff 00 00 00    	js     801056a2 <sys_link+0x122>
801055a3:	83 ec 08             	sub    $0x8,%esp
801055a6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055a9:	50                   	push   %eax
801055aa:	6a 01                	push   $0x1
801055ac:	e8 df fc ff ff       	call   80105290 <argstr>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	85 c0                	test   %eax,%eax
801055b6:	0f 88 e6 00 00 00    	js     801056a2 <sys_link+0x122>
    return -1;

  begin_op();
801055bc:	e8 8f dd ff ff       	call   80103350 <begin_op>
  if((ip = namei(old)) == 0){
801055c1:	83 ec 0c             	sub    $0xc,%esp
801055c4:	ff 75 d4             	pushl  -0x2c(%ebp)
801055c7:	e8 74 ca ff ff       	call   80102040 <namei>
801055cc:	83 c4 10             	add    $0x10,%esp
801055cf:	89 c3                	mov    %eax,%ebx
801055d1:	85 c0                	test   %eax,%eax
801055d3:	0f 84 e8 00 00 00    	je     801056c1 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	50                   	push   %eax
801055dd:	e8 8e c1 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055ea:	0f 84 b9 00 00 00    	je     801056a9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801055f0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801055f8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055fb:	53                   	push   %ebx
801055fc:	e8 af c0 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105601:	89 1c 24             	mov    %ebx,(%esp)
80105604:	e8 47 c2 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105609:	58                   	pop    %eax
8010560a:	5a                   	pop    %edx
8010560b:	57                   	push   %edi
8010560c:	ff 75 d0             	pushl  -0x30(%ebp)
8010560f:	e8 4c ca ff ff       	call   80102060 <nameiparent>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	89 c6                	mov    %eax,%esi
80105619:	85 c0                	test   %eax,%eax
8010561b:	74 5f                	je     8010567c <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	50                   	push   %eax
80105621:	e8 4a c1 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105626:	8b 03                	mov    (%ebx),%eax
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	39 06                	cmp    %eax,(%esi)
8010562d:	75 41                	jne    80105670 <sys_link+0xf0>
8010562f:	83 ec 04             	sub    $0x4,%esp
80105632:	ff 73 04             	pushl  0x4(%ebx)
80105635:	57                   	push   %edi
80105636:	56                   	push   %esi
80105637:	e8 44 c9 ff ff       	call   80101f80 <dirlink>
8010563c:	83 c4 10             	add    $0x10,%esp
8010563f:	85 c0                	test   %eax,%eax
80105641:	78 2d                	js     80105670 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105643:	83 ec 0c             	sub    $0xc,%esp
80105646:	56                   	push   %esi
80105647:	e8 c4 c3 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
8010564c:	89 1c 24             	mov    %ebx,(%esp)
8010564f:	e8 4c c2 ff ff       	call   801018a0 <iput>

  end_op();
80105654:	e8 67 dd ff ff       	call   801033c0 <end_op>

  return 0;
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010565e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105661:	5b                   	pop    %ebx
80105662:	5e                   	pop    %esi
80105663:	5f                   	pop    %edi
80105664:	5d                   	pop    %ebp
80105665:	c3                   	ret    
80105666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	56                   	push   %esi
80105674:	e8 97 c3 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105679:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010567c:	83 ec 0c             	sub    $0xc,%esp
8010567f:	53                   	push   %ebx
80105680:	e8 eb c0 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105685:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010568a:	89 1c 24             	mov    %ebx,(%esp)
8010568d:	e8 1e c0 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105692:	89 1c 24             	mov    %ebx,(%esp)
80105695:	e8 76 c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010569a:	e8 21 dd ff ff       	call   801033c0 <end_op>
  return -1;
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a7:	eb b5                	jmp    8010565e <sys_link+0xde>
    iunlockput(ip);
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	53                   	push   %ebx
801056ad:	e8 5e c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056b2:	e8 09 dd ff ff       	call   801033c0 <end_op>
    return -1;
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bf:	eb 9d                	jmp    8010565e <sys_link+0xde>
    end_op();
801056c1:	e8 fa dc ff ff       	call   801033c0 <end_op>
    return -1;
801056c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cb:	eb 91                	jmp    8010565e <sys_link+0xde>
801056cd:	8d 76 00             	lea    0x0(%esi),%esi

801056d0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
801056d8:	56                   	push   %esi
801056d9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056dc:	53                   	push   %ebx
801056dd:	bb 20 00 00 00       	mov    $0x20,%ebx
801056e2:	83 ec 1c             	sub    $0x1c,%esp
801056e5:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056e8:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801056ec:	77 0a                	ja     801056f8 <isdirempty+0x28>
801056ee:	eb 30                	jmp    80105720 <isdirempty+0x50>
801056f0:	83 c3 10             	add    $0x10,%ebx
801056f3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801056f6:	76 28                	jbe    80105720 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056f8:	6a 10                	push   $0x10
801056fa:	53                   	push   %ebx
801056fb:	57                   	push   %edi
801056fc:	56                   	push   %esi
801056fd:	e8 6e c3 ff ff       	call   80101a70 <readi>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	83 f8 10             	cmp    $0x10,%eax
80105708:	75 23                	jne    8010572d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010570a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010570f:	74 df                	je     801056f0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105711:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105714:	31 c0                	xor    %eax,%eax
}
80105716:	5b                   	pop    %ebx
80105717:	5e                   	pop    %esi
80105718:	5f                   	pop    %edi
80105719:	5d                   	pop    %ebp
8010571a:	c3                   	ret    
8010571b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
80105720:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105723:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105728:	5b                   	pop    %ebx
80105729:	5e                   	pop    %esi
8010572a:	5f                   	pop    %edi
8010572b:	5d                   	pop    %ebp
8010572c:	c3                   	ret    
      panic("isdirempty: readi");
8010572d:	83 ec 0c             	sub    $0xc,%esp
80105730:	68 a0 83 10 80       	push   $0x801083a0
80105735:	e8 56 ac ff ff       	call   80100390 <panic>
8010573a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105740 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	57                   	push   %edi
80105748:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105749:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010574c:	53                   	push   %ebx
8010574d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105750:	50                   	push   %eax
80105751:	6a 00                	push   $0x0
80105753:	e8 38 fb ff ff       	call   80105290 <argstr>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	0f 88 5d 01 00 00    	js     801058c0 <sys_unlink+0x180>
    return -1;

  begin_op();
80105763:	e8 e8 db ff ff       	call   80103350 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105768:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010576b:	83 ec 08             	sub    $0x8,%esp
8010576e:	53                   	push   %ebx
8010576f:	ff 75 c0             	pushl  -0x40(%ebp)
80105772:	e8 e9 c8 ff ff       	call   80102060 <nameiparent>
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	89 c6                	mov    %eax,%esi
8010577c:	85 c0                	test   %eax,%eax
8010577e:	0f 84 43 01 00 00    	je     801058c7 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105784:	83 ec 0c             	sub    $0xc,%esp
80105787:	50                   	push   %eax
80105788:	e8 e3 bf ff ff       	call   80101770 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010578d:	58                   	pop    %eax
8010578e:	5a                   	pop    %edx
8010578f:	68 5d 7d 10 80       	push   $0x80107d5d
80105794:	53                   	push   %ebx
80105795:	e8 06 c5 ff ff       	call   80101ca0 <namecmp>
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	85 c0                	test   %eax,%eax
8010579f:	0f 84 db 00 00 00    	je     80105880 <sys_unlink+0x140>
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	68 5c 7d 10 80       	push   $0x80107d5c
801057ad:	53                   	push   %ebx
801057ae:	e8 ed c4 ff ff       	call   80101ca0 <namecmp>
801057b3:	83 c4 10             	add    $0x10,%esp
801057b6:	85 c0                	test   %eax,%eax
801057b8:	0f 84 c2 00 00 00    	je     80105880 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801057be:	83 ec 04             	sub    $0x4,%esp
801057c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057c4:	50                   	push   %eax
801057c5:	53                   	push   %ebx
801057c6:	56                   	push   %esi
801057c7:	e8 f4 c4 ff ff       	call   80101cc0 <dirlookup>
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	89 c3                	mov    %eax,%ebx
801057d1:	85 c0                	test   %eax,%eax
801057d3:	0f 84 a7 00 00 00    	je     80105880 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	50                   	push   %eax
801057dd:	e8 8e bf ff ff       	call   80101770 <ilock>

  if(ip->nlink < 1)
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057ea:	0f 8e f3 00 00 00    	jle    801058e3 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801057f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057f5:	74 69                	je     80105860 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801057f7:	83 ec 04             	sub    $0x4,%esp
801057fa:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057fd:	6a 10                	push   $0x10
801057ff:	6a 00                	push   $0x0
80105801:	57                   	push   %edi
80105802:	e8 f9 f6 ff ff       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105807:	6a 10                	push   $0x10
80105809:	ff 75 c4             	pushl  -0x3c(%ebp)
8010580c:	57                   	push   %edi
8010580d:	56                   	push   %esi
8010580e:	e8 5d c3 ff ff       	call   80101b70 <writei>
80105813:	83 c4 20             	add    $0x20,%esp
80105816:	83 f8 10             	cmp    $0x10,%eax
80105819:	0f 85 b7 00 00 00    	jne    801058d6 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010581f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105824:	74 7a                	je     801058a0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105826:	83 ec 0c             	sub    $0xc,%esp
80105829:	56                   	push   %esi
8010582a:	e8 e1 c1 ff ff       	call   80101a10 <iunlockput>

  ip->nlink--;
8010582f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105834:	89 1c 24             	mov    %ebx,(%esp)
80105837:	e8 74 be ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
8010583c:	89 1c 24             	mov    %ebx,(%esp)
8010583f:	e8 cc c1 ff ff       	call   80101a10 <iunlockput>

  end_op();
80105844:	e8 77 db ff ff       	call   801033c0 <end_op>

  return 0;
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010584e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105851:	5b                   	pop    %ebx
80105852:	5e                   	pop    %esi
80105853:	5f                   	pop    %edi
80105854:	5d                   	pop    %ebp
80105855:	c3                   	ret    
80105856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	53                   	push   %ebx
80105864:	e8 67 fe ff ff       	call   801056d0 <isdirempty>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	75 87                	jne    801057f7 <sys_unlink+0xb7>
    iunlockput(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 97 c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	56                   	push   %esi
80105884:	e8 87 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105889:	e8 32 db ff ff       	call   801033c0 <end_op>
  return -1;
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105896:	eb b6                	jmp    8010584e <sys_unlink+0x10e>
80105898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589f:	90                   	nop
    iupdate(dp);
801058a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801058a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801058a8:	56                   	push   %esi
801058a9:	e8 02 be ff ff       	call   801016b0 <iupdate>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	e9 70 ff ff ff       	jmp    80105826 <sys_unlink+0xe6>
801058b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c5:	eb 87                	jmp    8010584e <sys_unlink+0x10e>
    end_op();
801058c7:	e8 f4 da ff ff       	call   801033c0 <end_op>
    return -1;
801058cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d1:	e9 78 ff ff ff       	jmp    8010584e <sys_unlink+0x10e>
    panic("unlink: writei");
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 71 7d 10 80       	push   $0x80107d71
801058de:	e8 ad aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	68 5f 7d 10 80       	push   $0x80107d5f
801058eb:	e8 a0 aa ff ff       	call   80100390 <panic>

801058f0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	57                   	push   %edi
801058f8:	56                   	push   %esi
801058f9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058fa:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801058fd:	83 ec 34             	sub    $0x34,%esp
80105900:	8b 45 0c             	mov    0xc(%ebp),%eax
80105903:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105906:	53                   	push   %ebx
{
80105907:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
8010590a:	ff 75 08             	pushl  0x8(%ebp)
{
8010590d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105910:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105913:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105916:	e8 45 c7 ff ff       	call   80102060 <nameiparent>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	85 c0                	test   %eax,%eax
80105920:	0f 84 3a 01 00 00    	je     80105a60 <create+0x170>
    return 0;
  ilock(dp);
80105926:	83 ec 0c             	sub    $0xc,%esp
80105929:	89 c6                	mov    %eax,%esi
8010592b:	50                   	push   %eax
8010592c:	e8 3f be ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105931:	83 c4 0c             	add    $0xc,%esp
80105934:	6a 00                	push   $0x0
80105936:	53                   	push   %ebx
80105937:	56                   	push   %esi
80105938:	e8 83 c3 ff ff       	call   80101cc0 <dirlookup>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	89 c7                	mov    %eax,%edi
80105942:	85 c0                	test   %eax,%eax
80105944:	74 4a                	je     80105990 <create+0xa0>
    iunlockput(dp);
80105946:	83 ec 0c             	sub    $0xc,%esp
80105949:	56                   	push   %esi
8010594a:	e8 c1 c0 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
8010594f:	89 3c 24             	mov    %edi,(%esp)
80105952:	e8 19 be ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010595f:	75 17                	jne    80105978 <create+0x88>
80105961:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105966:	75 10                	jne    80105978 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105968:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596b:	89 f8                	mov    %edi,%eax
8010596d:	5b                   	pop    %ebx
8010596e:	5e                   	pop    %esi
8010596f:	5f                   	pop    %edi
80105970:	5d                   	pop    %ebp
80105971:	c3                   	ret    
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	57                   	push   %edi
    return 0;
8010597c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
8010597e:	e8 8d c0 ff ff       	call   80101a10 <iunlockput>
    return 0;
80105983:	83 c4 10             	add    $0x10,%esp
}
80105986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105989:	89 f8                	mov    %edi,%eax
8010598b:	5b                   	pop    %ebx
8010598c:	5e                   	pop    %esi
8010598d:	5f                   	pop    %edi
8010598e:	5d                   	pop    %ebp
8010598f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105990:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105994:	83 ec 08             	sub    $0x8,%esp
80105997:	50                   	push   %eax
80105998:	ff 36                	pushl  (%esi)
8010599a:	e8 51 bc ff ff       	call   801015f0 <ialloc>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	89 c7                	mov    %eax,%edi
801059a4:	85 c0                	test   %eax,%eax
801059a6:	0f 84 cd 00 00 00    	je     80105a79 <create+0x189>
  ilock(ip);
801059ac:	83 ec 0c             	sub    $0xc,%esp
801059af:	50                   	push   %eax
801059b0:	e8 bb bd ff ff       	call   80101770 <ilock>
  ip->major = major;
801059b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801059b9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801059bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801059c1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801059c5:	b8 01 00 00 00       	mov    $0x1,%eax
801059ca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801059ce:	89 3c 24             	mov    %edi,(%esp)
801059d1:	e8 da bc ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801059de:	74 30                	je     80105a10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801059e0:	83 ec 04             	sub    $0x4,%esp
801059e3:	ff 77 04             	pushl  0x4(%edi)
801059e6:	53                   	push   %ebx
801059e7:	56                   	push   %esi
801059e8:	e8 93 c5 ff ff       	call   80101f80 <dirlink>
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c0                	test   %eax,%eax
801059f2:	78 78                	js     80105a6c <create+0x17c>
  iunlockput(dp);
801059f4:	83 ec 0c             	sub    $0xc,%esp
801059f7:	56                   	push   %esi
801059f8:	e8 13 c0 ff ff       	call   80101a10 <iunlockput>
  return ip;
801059fd:	83 c4 10             	add    $0x10,%esp
}
80105a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a03:	89 f8                	mov    %edi,%eax
80105a05:	5b                   	pop    %ebx
80105a06:	5e                   	pop    %esi
80105a07:	5f                   	pop    %edi
80105a08:	5d                   	pop    %ebp
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105a10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105a13:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105a18:	56                   	push   %esi
80105a19:	e8 92 bc ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a1e:	83 c4 0c             	add    $0xc,%esp
80105a21:	ff 77 04             	pushl  0x4(%edi)
80105a24:	68 5d 7d 10 80       	push   $0x80107d5d
80105a29:	57                   	push   %edi
80105a2a:	e8 51 c5 ff ff       	call   80101f80 <dirlink>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 c0                	test   %eax,%eax
80105a34:	78 18                	js     80105a4e <create+0x15e>
80105a36:	83 ec 04             	sub    $0x4,%esp
80105a39:	ff 76 04             	pushl  0x4(%esi)
80105a3c:	68 5c 7d 10 80       	push   $0x80107d5c
80105a41:	57                   	push   %edi
80105a42:	e8 39 c5 ff ff       	call   80101f80 <dirlink>
80105a47:	83 c4 10             	add    $0x10,%esp
80105a4a:	85 c0                	test   %eax,%eax
80105a4c:	79 92                	jns    801059e0 <create+0xf0>
      panic("create dots");
80105a4e:	83 ec 0c             	sub    $0xc,%esp
80105a51:	68 c1 83 10 80       	push   $0x801083c1
80105a56:	e8 35 a9 ff ff       	call   80100390 <panic>
80105a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
}
80105a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105a63:	31 ff                	xor    %edi,%edi
}
80105a65:	5b                   	pop    %ebx
80105a66:	89 f8                	mov    %edi,%eax
80105a68:	5e                   	pop    %esi
80105a69:	5f                   	pop    %edi
80105a6a:	5d                   	pop    %ebp
80105a6b:	c3                   	ret    
    panic("create: dirlink");
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	68 cd 83 10 80       	push   $0x801083cd
80105a74:	e8 17 a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	68 b2 83 10 80       	push   $0x801083b2
80105a81:	e8 0a a9 ff ff       	call   80100390 <panic>
80105a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi

80105a90 <sys_open>:

int
sys_open(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	57                   	push   %edi
80105a98:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a99:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a9c:	53                   	push   %ebx
80105a9d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aa0:	50                   	push   %eax
80105aa1:	6a 00                	push   $0x0
80105aa3:	e8 e8 f7 ff ff       	call   80105290 <argstr>
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	85 c0                	test   %eax,%eax
80105aad:	0f 88 8a 00 00 00    	js     80105b3d <sys_open+0xad>
80105ab3:	83 ec 08             	sub    $0x8,%esp
80105ab6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ab9:	50                   	push   %eax
80105aba:	6a 01                	push   $0x1
80105abc:	e8 1f f7 ff ff       	call   801051e0 <argint>
80105ac1:	83 c4 10             	add    $0x10,%esp
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 75                	js     80105b3d <sys_open+0xad>
    return -1;

  begin_op();
80105ac8:	e8 83 d8 ff ff       	call   80103350 <begin_op>

  if(omode & O_CREATE){
80105acd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ad1:	75 75                	jne    80105b48 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ad3:	83 ec 0c             	sub    $0xc,%esp
80105ad6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ad9:	e8 62 c5 ff ff       	call   80102040 <namei>
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	89 c6                	mov    %eax,%esi
80105ae3:	85 c0                	test   %eax,%eax
80105ae5:	74 78                	je     80105b5f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105ae7:	83 ec 0c             	sub    $0xc,%esp
80105aea:	50                   	push   %eax
80105aeb:	e8 80 bc ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105af0:	83 c4 10             	add    $0x10,%esp
80105af3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105af8:	0f 84 ba 00 00 00    	je     80105bb8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105afe:	e8 0d b3 ff ff       	call   80100e10 <filealloc>
80105b03:	89 c7                	mov    %eax,%edi
80105b05:	85 c0                	test   %eax,%eax
80105b07:	74 23                	je     80105b2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b09:	e8 02 e5 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b0e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b14:	85 d2                	test   %edx,%edx
80105b16:	74 58                	je     80105b70 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105b18:	83 c3 01             	add    $0x1,%ebx
80105b1b:	83 fb 10             	cmp    $0x10,%ebx
80105b1e:	75 f0                	jne    80105b10 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	57                   	push   %edi
80105b24:	e8 a7 b3 ff ff       	call   80100ed0 <fileclose>
80105b29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b2c:	83 ec 0c             	sub    $0xc,%esp
80105b2f:	56                   	push   %esi
80105b30:	e8 db be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b35:	e8 86 d8 ff ff       	call   801033c0 <end_op>
    return -1;
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b42:	eb 65                	jmp    80105ba9 <sys_open+0x119>
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b48:	6a 00                	push   $0x0
80105b4a:	6a 00                	push   $0x0
80105b4c:	6a 02                	push   $0x2
80105b4e:	ff 75 e0             	pushl  -0x20(%ebp)
80105b51:	e8 9a fd ff ff       	call   801058f0 <create>
    if(ip == 0){
80105b56:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b59:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b5b:	85 c0                	test   %eax,%eax
80105b5d:	75 9f                	jne    80105afe <sys_open+0x6e>
      end_op();
80105b5f:	e8 5c d8 ff ff       	call   801033c0 <end_op>
      return -1;
80105b64:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b69:	eb 3e                	jmp    80105ba9 <sys_open+0x119>
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
  }
  iunlock(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b73:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b77:	56                   	push   %esi
80105b78:	e8 d3 bc ff ff       	call   80101850 <iunlock>
  end_op();
80105b7d:	e8 3e d8 ff ff       	call   801033c0 <end_op>

  f->type = FD_INODE;
80105b82:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b8b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b8e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b91:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b93:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b9a:	f7 d0                	not    %eax
80105b9c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b9f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ba2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ba5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bac:	89 d8                	mov    %ebx,%eax
80105bae:	5b                   	pop    %ebx
80105baf:	5e                   	pop    %esi
80105bb0:	5f                   	pop    %edi
80105bb1:	5d                   	pop    %ebp
80105bb2:	c3                   	ret    
80105bb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bb7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bb8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bbb:	85 c9                	test   %ecx,%ecx
80105bbd:	0f 84 3b ff ff ff    	je     80105afe <sys_open+0x6e>
80105bc3:	e9 64 ff ff ff       	jmp    80105b2c <sys_open+0x9c>
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bda:	e8 71 d7 ff ff       	call   80103350 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bdf:	83 ec 08             	sub    $0x8,%esp
80105be2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be5:	50                   	push   %eax
80105be6:	6a 00                	push   $0x0
80105be8:	e8 a3 f6 ff ff       	call   80105290 <argstr>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	78 2c                	js     80105c20 <sys_mkdir+0x50>
80105bf4:	6a 00                	push   $0x0
80105bf6:	6a 00                	push   $0x0
80105bf8:	6a 01                	push   $0x1
80105bfa:	ff 75 f4             	pushl  -0xc(%ebp)
80105bfd:	e8 ee fc ff ff       	call   801058f0 <create>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	74 17                	je     80105c20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c09:	83 ec 0c             	sub    $0xc,%esp
80105c0c:	50                   	push   %eax
80105c0d:	e8 fe bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c12:	e8 a9 d7 ff ff       	call   801033c0 <end_op>
  return 0;
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	31 c0                	xor    %eax,%eax
}
80105c1c:	c9                   	leave  
80105c1d:	c3                   	ret    
80105c1e:	66 90                	xchg   %ax,%ax
    end_op();
80105c20:	e8 9b d7 ff ff       	call   801033c0 <end_op>
    return -1;
80105c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c2a:	c9                   	leave  
80105c2b:	c3                   	ret    
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_mknod>:

int
sys_mknod(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c3a:	e8 11 d7 ff ff       	call   80103350 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c3f:	83 ec 08             	sub    $0x8,%esp
80105c42:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c45:	50                   	push   %eax
80105c46:	6a 00                	push   $0x0
80105c48:	e8 43 f6 ff ff       	call   80105290 <argstr>
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	85 c0                	test   %eax,%eax
80105c52:	78 5c                	js     80105cb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c54:	83 ec 08             	sub    $0x8,%esp
80105c57:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c5a:	50                   	push   %eax
80105c5b:	6a 01                	push   $0x1
80105c5d:	e8 7e f5 ff ff       	call   801051e0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 47                	js     80105cb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c69:	83 ec 08             	sub    $0x8,%esp
80105c6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6f:	50                   	push   %eax
80105c70:	6a 02                	push   $0x2
80105c72:	e8 69 f5 ff ff       	call   801051e0 <argint>
     argint(1, &major) < 0 ||
80105c77:	83 c4 10             	add    $0x10,%esp
80105c7a:	85 c0                	test   %eax,%eax
80105c7c:	78 32                	js     80105cb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c7e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c82:	50                   	push   %eax
80105c83:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105c87:	50                   	push   %eax
80105c88:	6a 03                	push   $0x3
80105c8a:	ff 75 ec             	pushl  -0x14(%ebp)
80105c8d:	e8 5e fc ff ff       	call   801058f0 <create>
     argint(2, &minor) < 0 ||
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	85 c0                	test   %eax,%eax
80105c97:	74 17                	je     80105cb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c99:	83 ec 0c             	sub    $0xc,%esp
80105c9c:	50                   	push   %eax
80105c9d:	e8 6e bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ca2:	e8 19 d7 ff ff       	call   801033c0 <end_op>
  return 0;
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	31 c0                	xor    %eax,%eax
}
80105cac:	c9                   	leave  
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax
    end_op();
80105cb0:	e8 0b d7 ff ff       	call   801033c0 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_chdir>:

int
sys_chdir(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	56                   	push   %esi
80105cc8:	53                   	push   %ebx
80105cc9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ccc:	e8 3f e3 ff ff       	call   80104010 <myproc>
80105cd1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cd3:	e8 78 d6 ff ff       	call   80103350 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cd8:	83 ec 08             	sub    $0x8,%esp
80105cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cde:	50                   	push   %eax
80105cdf:	6a 00                	push   $0x0
80105ce1:	e8 aa f5 ff ff       	call   80105290 <argstr>
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	78 73                	js     80105d60 <sys_chdir+0xa0>
80105ced:	83 ec 0c             	sub    $0xc,%esp
80105cf0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf3:	e8 48 c3 ff ff       	call   80102040 <namei>
80105cf8:	83 c4 10             	add    $0x10,%esp
80105cfb:	89 c3                	mov    %eax,%ebx
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	74 5f                	je     80105d60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d01:	83 ec 0c             	sub    $0xc,%esp
80105d04:	50                   	push   %eax
80105d05:	e8 66 ba ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d12:	75 2c                	jne    80105d40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	53                   	push   %ebx
80105d18:	e8 33 bb ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
80105d1d:	58                   	pop    %eax
80105d1e:	ff 76 68             	pushl  0x68(%esi)
80105d21:	e8 7a bb ff ff       	call   801018a0 <iput>
  end_op();
80105d26:	e8 95 d6 ff ff       	call   801033c0 <end_op>
  curproc->cwd = ip;
80105d2b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d2e:	83 c4 10             	add    $0x10,%esp
80105d31:	31 c0                	xor    %eax,%eax
}
80105d33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d36:	5b                   	pop    %ebx
80105d37:	5e                   	pop    %esi
80105d38:	5d                   	pop    %ebp
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 c7 bc ff ff       	call   80101a10 <iunlockput>
    end_op();
80105d49:	e8 72 d6 ff ff       	call   801033c0 <end_op>
    return -1;
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb db                	jmp    80105d33 <sys_chdir+0x73>
80105d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
    end_op();
80105d60:	e8 5b d6 ff ff       	call   801033c0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6a:	eb c7                	jmp    80105d33 <sys_chdir+0x73>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_exec>:

int
sys_exec(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	57                   	push   %edi
80105d78:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d79:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d7f:	53                   	push   %ebx
80105d80:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d86:	50                   	push   %eax
80105d87:	6a 00                	push   $0x0
80105d89:	e8 02 f5 ff ff       	call   80105290 <argstr>
80105d8e:	83 c4 10             	add    $0x10,%esp
80105d91:	85 c0                	test   %eax,%eax
80105d93:	0f 88 8b 00 00 00    	js     80105e24 <sys_exec+0xb4>
80105d99:	83 ec 08             	sub    $0x8,%esp
80105d9c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105da2:	50                   	push   %eax
80105da3:	6a 01                	push   $0x1
80105da5:	e8 36 f4 ff ff       	call   801051e0 <argint>
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	85 c0                	test   %eax,%eax
80105daf:	78 73                	js     80105e24 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105db1:	83 ec 04             	sub    $0x4,%esp
80105db4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105dba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105dbc:	68 80 00 00 00       	push   $0x80
80105dc1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105dc7:	6a 00                	push   $0x0
80105dc9:	50                   	push   %eax
80105dca:	e8 31 f1 ff ff       	call   80104f00 <memset>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dd8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dde:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	57                   	push   %edi
80105de9:	01 f0                	add    %esi,%eax
80105deb:	50                   	push   %eax
80105dec:	e8 4f f3 ff ff       	call   80105140 <fetchint>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	78 2c                	js     80105e24 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105df8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dfe:	85 c0                	test   %eax,%eax
80105e00:	74 36                	je     80105e38 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e02:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e08:	83 ec 08             	sub    $0x8,%esp
80105e0b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e0e:	52                   	push   %edx
80105e0f:	50                   	push   %eax
80105e10:	e8 6b f3 ff ff       	call   80105180 <fetchstr>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	85 c0                	test   %eax,%eax
80105e1a:	78 08                	js     80105e24 <sys_exec+0xb4>
  for(i=0;; i++){
80105e1c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e1f:	83 fb 20             	cmp    $0x20,%ebx
80105e22:	75 b4                	jne    80105dd8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2c:	5b                   	pop    %ebx
80105e2d:	5e                   	pop    %esi
80105e2e:	5f                   	pop    %edi
80105e2f:	5d                   	pop    %ebp
80105e30:	c3                   	ret    
80105e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e41:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e48:	00 00 00 00 
  return exec(path, argv);
80105e4c:	50                   	push   %eax
80105e4d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e53:	e8 28 ac ff ff       	call   80100a80 <exec>
80105e58:	83 c4 10             	add    $0x10,%esp
}
80105e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e5e:	5b                   	pop    %ebx
80105e5f:	5e                   	pop    %esi
80105e60:	5f                   	pop    %edi
80105e61:	5d                   	pop    %ebp
80105e62:	c3                   	ret    
80105e63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e70 <sys_pipe>:

int
sys_pipe(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	57                   	push   %edi
80105e78:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e79:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e7c:	53                   	push   %ebx
80105e7d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e80:	6a 08                	push   $0x8
80105e82:	50                   	push   %eax
80105e83:	6a 00                	push   $0x0
80105e85:	e8 a6 f3 ff ff       	call   80105230 <argptr>
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	78 4e                	js     80105edf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e91:	83 ec 08             	sub    $0x8,%esp
80105e94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e97:	50                   	push   %eax
80105e98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e9b:	50                   	push   %eax
80105e9c:	e8 6f db ff ff       	call   80103a10 <pipealloc>
80105ea1:	83 c4 10             	add    $0x10,%esp
80105ea4:	85 c0                	test   %eax,%eax
80105ea6:	78 37                	js     80105edf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ea8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105eab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ead:	e8 5e e1 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105eb8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ebc:	85 f6                	test   %esi,%esi
80105ebe:	74 30                	je     80105ef0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ec0:	83 c3 01             	add    $0x1,%ebx
80105ec3:	83 fb 10             	cmp    $0x10,%ebx
80105ec6:	75 f0                	jne    80105eb8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 e0             	pushl  -0x20(%ebp)
80105ece:	e8 fd af ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105ed3:	58                   	pop    %eax
80105ed4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ed7:	e8 f4 af ff ff       	call   80100ed0 <fileclose>
    return -1;
80105edc:	83 c4 10             	add    $0x10,%esp
80105edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee4:	eb 5b                	jmp    80105f41 <sys_pipe+0xd1>
80105ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ef0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ef3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ef7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105efa:	e8 11 e1 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eff:	31 d2                	xor    %edx,%edx
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f08:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f0c:	85 c9                	test   %ecx,%ecx
80105f0e:	74 20                	je     80105f30 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f10:	83 c2 01             	add    $0x1,%edx
80105f13:	83 fa 10             	cmp    $0x10,%edx
80105f16:	75 f0                	jne    80105f08 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f18:	e8 f3 e0 ff ff       	call   80104010 <myproc>
80105f1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f24:	00 
80105f25:	eb a1                	jmp    80105ec8 <sys_pipe+0x58>
80105f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f30:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f37:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f3c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f3f:	31 c0                	xor    %eax,%eax
}
80105f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f44:	5b                   	pop    %ebx
80105f45:	5e                   	pop    %esi
80105f46:	5f                   	pop    %edi
80105f47:	5d                   	pop    %ebp
80105f48:	c3                   	ret    
80105f49:	66 90                	xchg   %ax,%ax
80105f4b:	66 90                	xchg   %ax,%ax
80105f4d:	66 90                	xchg   %ax,%ax
80105f4f:	90                   	nop

80105f50 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
  return fork();
80105f54:	e9 67 e2 ff ff       	jmp    801041c0 <fork>
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_exit>:
}

int
sys_exit(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f6a:	e8 11 e6 ff ff       	call   80104580 <exit>
  return 0;  // not reached
}
80105f6f:	31 c0                	xor    %eax,%eax
80105f71:	c9                   	leave  
80105f72:	c3                   	ret    
80105f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f80 <sys_wait>:

int
sys_wait(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
  return wait();
80105f84:	e9 67 e8 ff ff       	jmp    801047f0 <wait>
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_kill>:
}

int
sys_kill(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9d:	50                   	push   %eax
80105f9e:	6a 00                	push   $0x0
80105fa0:	e8 3b f2 ff ff       	call   801051e0 <argint>
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	78 14                	js     80105fc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fac:	83 ec 0c             	sub    $0xc,%esp
80105faf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb2:	e8 a9 e9 ff ff       	call   80104960 <kill>
80105fb7:	83 c4 10             	add    $0x10,%esp
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fc0:	c9                   	leave  
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_getpid>:

int
sys_getpid(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fda:	e8 31 e0 ff ff       	call   80104010 <myproc>
80105fdf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fe2:	c9                   	leave  
80105fe3:	c3                   	ret    
80105fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop

80105ff0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ffb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffe:	50                   	push   %eax
80105fff:	6a 00                	push   $0x0
80106001:	e8 da f1 ff ff       	call   801051e0 <argint>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	78 23                	js     80106030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010600d:	e8 fe df ff ff       	call   80104010 <myproc>
  if(growproc(n) < 0)
80106012:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106015:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106017:	ff 75 f4             	pushl  -0xc(%ebp)
8010601a:	e8 21 e1 ff ff       	call   80104140 <growproc>
8010601f:	83 c4 10             	add    $0x10,%esp
80106022:	85 c0                	test   %eax,%eax
80106024:	78 0a                	js     80106030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106026:	89 d8                	mov    %ebx,%eax
80106028:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010602b:	c9                   	leave  
8010602c:	c3                   	ret    
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106035:	eb ef                	jmp    80106026 <sys_sbrk+0x36>
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_sleep>:

int
sys_sleep(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106048:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010604b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010604e:	50                   	push   %eax
8010604f:	6a 00                	push   $0x0
80106051:	e8 8a f1 ff ff       	call   801051e0 <argint>
80106056:	83 c4 10             	add    $0x10,%esp
80106059:	85 c0                	test   %eax,%eax
8010605b:	0f 88 86 00 00 00    	js     801060e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106061:	83 ec 0c             	sub    $0xc,%esp
80106064:	68 60 d1 18 80       	push   $0x8018d160
80106069:	e8 82 ed ff ff       	call   80104df0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010606e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106071:	8b 1d a0 d9 18 80    	mov    0x8018d9a0,%ebx
  while(ticks - ticks0 < n){
80106077:	83 c4 10             	add    $0x10,%esp
8010607a:	85 d2                	test   %edx,%edx
8010607c:	75 23                	jne    801060a1 <sys_sleep+0x61>
8010607e:	eb 50                	jmp    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	68 60 d1 18 80       	push   $0x8018d160
80106088:	68 a0 d9 18 80       	push   $0x8018d9a0
8010608d:	e8 9e e6 ff ff       	call   80104730 <sleep>
  while(ticks - ticks0 < n){
80106092:	a1 a0 d9 18 80       	mov    0x8018d9a0,%eax
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	29 d8                	sub    %ebx,%eax
8010609c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010609f:	73 2f                	jae    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
801060a1:	e8 6a df ff ff       	call   80104010 <myproc>
801060a6:	8b 40 24             	mov    0x24(%eax),%eax
801060a9:	85 c0                	test   %eax,%eax
801060ab:	74 d3                	je     80106080 <sys_sleep+0x40>
      release(&tickslock);
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 60 d1 18 80       	push   $0x8018d160
801060b5:	e8 f6 ed ff ff       	call   80104eb0 <release>
  }
  release(&tickslock);
  return 0;
}
801060ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 60 d1 18 80       	push   $0x8018d160
801060d8:	e8 d3 ed ff ff       	call   80104eb0 <release>
  return 0;
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
    return -1;
801060e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ec:	eb f4                	jmp    801060e2 <sys_sleep+0xa2>
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	53                   	push   %ebx
801060f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060fb:	68 60 d1 18 80       	push   $0x8018d160
80106100:	e8 eb ec ff ff       	call   80104df0 <acquire>
  xticks = ticks;
80106105:	8b 1d a0 d9 18 80    	mov    0x8018d9a0,%ebx
  release(&tickslock);
8010610b:	c7 04 24 60 d1 18 80 	movl   $0x8018d160,(%esp)
80106112:	e8 99 ed ff ff       	call   80104eb0 <release>
  return xticks;
}
80106117:	89 d8                	mov    %ebx,%eax
80106119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
8010612a:	e8 e1 de ff ff       	call   80104010 <myproc>
8010612f:	89 c2                	mov    %eax,%edx
80106131:	b8 10 00 00 00       	mov    $0x10,%eax
80106136:	2b 82 80 00 00 00    	sub    0x80(%edx),%eax
}
8010613c:	c9                   	leave  
8010613d:	c3                   	ret    
8010613e:	66 90                	xchg   %ax,%ax

80106140 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106140:	f3 0f 1e fb          	endbr32 
  return getTotalFreePages();
80106144:	e9 87 e9 ff ff       	jmp    80104ad0 <getTotalFreePages>

80106149 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106149:	1e                   	push   %ds
  pushl %es
8010614a:	06                   	push   %es
  pushl %fs
8010614b:	0f a0                	push   %fs
  pushl %gs
8010614d:	0f a8                	push   %gs
  pushal
8010614f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106150:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106154:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106156:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106158:	54                   	push   %esp
  call trap
80106159:	e8 c2 00 00 00       	call   80106220 <trap>
  addl $4, %esp
8010615e:	83 c4 04             	add    $0x4,%esp

80106161 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106161:	61                   	popa   
  popl %gs
80106162:	0f a9                	pop    %gs
  popl %fs
80106164:	0f a1                	pop    %fs
  popl %es
80106166:	07                   	pop    %es
  popl %ds
80106167:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106168:	83 c4 08             	add    $0x8,%esp
  iret
8010616b:	cf                   	iret   
8010616c:	66 90                	xchg   %ax,%ax
8010616e:	66 90                	xchg   %ax,%ax

80106170 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106175:	31 c0                	xor    %eax,%eax
{
80106177:	89 e5                	mov    %esp,%ebp
80106179:	83 ec 08             	sub    $0x8,%esp
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106180:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106187:	c7 04 c5 a2 d1 18 80 	movl   $0x8e000008,-0x7fe72e5e(,%eax,8)
8010618e:	08 00 00 8e 
80106192:	66 89 14 c5 a0 d1 18 	mov    %dx,-0x7fe72e60(,%eax,8)
80106199:	80 
8010619a:	c1 ea 10             	shr    $0x10,%edx
8010619d:	66 89 14 c5 a6 d1 18 	mov    %dx,-0x7fe72e5a(,%eax,8)
801061a4:	80 
  for(i = 0; i < 256; i++)
801061a5:	83 c0 01             	add    $0x1,%eax
801061a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061ad:	75 d1                	jne    80106180 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061af:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061b2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061b7:	c7 05 a2 d3 18 80 08 	movl   $0xef000008,0x8018d3a2
801061be:	00 00 ef 
  initlock(&tickslock, "time");
801061c1:	68 dd 83 10 80       	push   $0x801083dd
801061c6:	68 60 d1 18 80       	push   $0x8018d160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061cb:	66 a3 a0 d3 18 80    	mov    %ax,0x8018d3a0
801061d1:	c1 e8 10             	shr    $0x10,%eax
801061d4:	66 a3 a6 d3 18 80    	mov    %ax,0x8018d3a6
  initlock(&tickslock, "time");
801061da:	e8 91 ea ff ff       	call   80104c70 <initlock>
}
801061df:	83 c4 10             	add    $0x10,%esp
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop

801061f0 <idtinit>:

void
idtinit(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
  pd[0] = size-1;
801061f5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061fa:	89 e5                	mov    %esp,%ebp
801061fc:	83 ec 10             	sub    $0x10,%esp
801061ff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106203:	b8 a0 d1 18 80       	mov    $0x8018d1a0,%eax
80106208:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010620c:	c1 e8 10             	shr    $0x10,%eax
8010620f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106213:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106216:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106219:	c9                   	leave  
8010621a:	c3                   	ret    
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop

80106220 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	57                   	push   %edi
80106228:	56                   	push   %esi
80106229:	53                   	push   %ebx
8010622a:	83 ec 1c             	sub    $0x1c,%esp
8010622d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106230:	8b 43 30             	mov    0x30(%ebx),%eax
80106233:	83 f8 40             	cmp    $0x40,%eax
80106236:	0f 84 bc 01 00 00    	je     801063f8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010623c:	83 e8 20             	sub    $0x20,%eax
8010623f:	83 f8 1f             	cmp    $0x1f,%eax
80106242:	77 08                	ja     8010624c <trap+0x2c>
80106244:	3e ff 24 85 84 84 10 	notrack jmp *-0x7fef7b7c(,%eax,4)
8010624b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010624c:	e8 bf dd ff ff       	call   80104010 <myproc>
80106251:	8b 7b 38             	mov    0x38(%ebx),%edi
80106254:	85 c0                	test   %eax,%eax
80106256:	0f 84 eb 01 00 00    	je     80106447 <trap+0x227>
8010625c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106260:	0f 84 e1 01 00 00    	je     80106447 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106266:	0f 20 d1             	mov    %cr2,%ecx
80106269:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010626c:	e8 7f dd ff ff       	call   80103ff0 <cpuid>
80106271:	8b 73 30             	mov    0x30(%ebx),%esi
80106274:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106277:	8b 43 34             	mov    0x34(%ebx),%eax
8010627a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010627d:	e8 8e dd ff ff       	call   80104010 <myproc>
80106282:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106285:	e8 86 dd ff ff       	call   80104010 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010628d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106290:	51                   	push   %ecx
80106291:	57                   	push   %edi
80106292:	52                   	push   %edx
80106293:	ff 75 e4             	pushl  -0x1c(%ebp)
80106296:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106297:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010629a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629d:	56                   	push   %esi
8010629e:	ff 70 10             	pushl  0x10(%eax)
801062a1:	68 40 84 10 80       	push   $0x80108440
801062a6:	e8 05 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062ab:	83 c4 20             	add    $0x20,%esp
801062ae:	e8 5d dd ff ff       	call   80104010 <myproc>
801062b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ba:	e8 51 dd ff ff       	call   80104010 <myproc>
801062bf:	85 c0                	test   %eax,%eax
801062c1:	74 1d                	je     801062e0 <trap+0xc0>
801062c3:	e8 48 dd ff ff       	call   80104010 <myproc>
801062c8:	8b 50 24             	mov    0x24(%eax),%edx
801062cb:	85 d2                	test   %edx,%edx
801062cd:	74 11                	je     801062e0 <trap+0xc0>
801062cf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062d3:	83 e0 03             	and    $0x3,%eax
801062d6:	66 83 f8 03          	cmp    $0x3,%ax
801062da:	0f 84 50 01 00 00    	je     80106430 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062e0:	e8 2b dd ff ff       	call   80104010 <myproc>
801062e5:	85 c0                	test   %eax,%eax
801062e7:	74 0f                	je     801062f8 <trap+0xd8>
801062e9:	e8 22 dd ff ff       	call   80104010 <myproc>
801062ee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062f2:	0f 84 e8 00 00 00    	je     801063e0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062f8:	e8 13 dd ff ff       	call   80104010 <myproc>
801062fd:	85 c0                	test   %eax,%eax
801062ff:	74 1d                	je     8010631e <trap+0xfe>
80106301:	e8 0a dd ff ff       	call   80104010 <myproc>
80106306:	8b 40 24             	mov    0x24(%eax),%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	74 11                	je     8010631e <trap+0xfe>
8010630d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106311:	83 e0 03             	and    $0x3,%eax
80106314:	66 83 f8 03          	cmp    $0x3,%ax
80106318:	0f 84 03 01 00 00    	je     80106421 <trap+0x201>
    exit();
}
8010631e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106321:	5b                   	pop    %ebx
80106322:	5e                   	pop    %esi
80106323:	5f                   	pop    %edi
80106324:	5d                   	pop    %ebp
80106325:	c3                   	ret    
    ideintr();
80106326:	e8 45 c2 ff ff       	call   80102570 <ideintr>
    lapiceoi();
8010632b:	e8 b0 cb ff ff       	call   80102ee0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106330:	e8 db dc ff ff       	call   80104010 <myproc>
80106335:	85 c0                	test   %eax,%eax
80106337:	75 8a                	jne    801062c3 <trap+0xa3>
80106339:	eb a5                	jmp    801062e0 <trap+0xc0>
    if(cpuid() == 0){
8010633b:	e8 b0 dc ff ff       	call   80103ff0 <cpuid>
80106340:	85 c0                	test   %eax,%eax
80106342:	75 e7                	jne    8010632b <trap+0x10b>
      acquire(&tickslock);
80106344:	83 ec 0c             	sub    $0xc,%esp
80106347:	68 60 d1 18 80       	push   $0x8018d160
8010634c:	e8 9f ea ff ff       	call   80104df0 <acquire>
      wakeup(&ticks);
80106351:	c7 04 24 a0 d9 18 80 	movl   $0x8018d9a0,(%esp)
      ticks++;
80106358:	83 05 a0 d9 18 80 01 	addl   $0x1,0x8018d9a0
      wakeup(&ticks);
8010635f:	e8 8c e5 ff ff       	call   801048f0 <wakeup>
      release(&tickslock);
80106364:	c7 04 24 60 d1 18 80 	movl   $0x8018d160,(%esp)
8010636b:	e8 40 eb ff ff       	call   80104eb0 <release>
80106370:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106373:	eb b6                	jmp    8010632b <trap+0x10b>
    kbdintr();
80106375:	e8 26 ca ff ff       	call   80102da0 <kbdintr>
    lapiceoi();
8010637a:	e8 61 cb ff ff       	call   80102ee0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010637f:	e8 8c dc ff ff       	call   80104010 <myproc>
80106384:	85 c0                	test   %eax,%eax
80106386:	0f 85 37 ff ff ff    	jne    801062c3 <trap+0xa3>
8010638c:	e9 4f ff ff ff       	jmp    801062e0 <trap+0xc0>
    uartintr();
80106391:	e8 4a 02 00 00       	call   801065e0 <uartintr>
    lapiceoi();
80106396:	e8 45 cb ff ff       	call   80102ee0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010639b:	e8 70 dc ff ff       	call   80104010 <myproc>
801063a0:	85 c0                	test   %eax,%eax
801063a2:	0f 85 1b ff ff ff    	jne    801062c3 <trap+0xa3>
801063a8:	e9 33 ff ff ff       	jmp    801062e0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063ad:	8b 7b 38             	mov    0x38(%ebx),%edi
801063b0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063b4:	e8 37 dc ff ff       	call   80103ff0 <cpuid>
801063b9:	57                   	push   %edi
801063ba:	56                   	push   %esi
801063bb:	50                   	push   %eax
801063bc:	68 e8 83 10 80       	push   $0x801083e8
801063c1:	e8 ea a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063c6:	e8 15 cb ff ff       	call   80102ee0 <lapiceoi>
    break;
801063cb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ce:	e8 3d dc ff ff       	call   80104010 <myproc>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	0f 85 e8 fe ff ff    	jne    801062c3 <trap+0xa3>
801063db:	e9 00 ff ff ff       	jmp    801062e0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801063e0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063e4:	0f 85 0e ff ff ff    	jne    801062f8 <trap+0xd8>
    yield();
801063ea:	e8 f1 e2 ff ff       	call   801046e0 <yield>
801063ef:	e9 04 ff ff ff       	jmp    801062f8 <trap+0xd8>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801063f8:	e8 13 dc ff ff       	call   80104010 <myproc>
801063fd:	8b 70 24             	mov    0x24(%eax),%esi
80106400:	85 f6                	test   %esi,%esi
80106402:	75 3c                	jne    80106440 <trap+0x220>
    myproc()->tf = tf;
80106404:	e8 07 dc ff ff       	call   80104010 <myproc>
80106409:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010640c:	e8 bf ee ff ff       	call   801052d0 <syscall>
    if(myproc()->killed)
80106411:	e8 fa db ff ff       	call   80104010 <myproc>
80106416:	8b 48 24             	mov    0x24(%eax),%ecx
80106419:	85 c9                	test   %ecx,%ecx
8010641b:	0f 84 fd fe ff ff    	je     8010631e <trap+0xfe>
}
80106421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106424:	5b                   	pop    %ebx
80106425:	5e                   	pop    %esi
80106426:	5f                   	pop    %edi
80106427:	5d                   	pop    %ebp
      exit();
80106428:	e9 53 e1 ff ff       	jmp    80104580 <exit>
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106430:	e8 4b e1 ff ff       	call   80104580 <exit>
80106435:	e9 a6 fe ff ff       	jmp    801062e0 <trap+0xc0>
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106440:	e8 3b e1 ff ff       	call   80104580 <exit>
80106445:	eb bd                	jmp    80106404 <trap+0x1e4>
80106447:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010644a:	e8 a1 db ff ff       	call   80103ff0 <cpuid>
8010644f:	83 ec 0c             	sub    $0xc,%esp
80106452:	56                   	push   %esi
80106453:	57                   	push   %edi
80106454:	50                   	push   %eax
80106455:	ff 73 30             	pushl  0x30(%ebx)
80106458:	68 0c 84 10 80       	push   $0x8010840c
8010645d:	e8 4e a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106462:	83 c4 14             	add    $0x14,%esp
80106465:	68 e2 83 10 80       	push   $0x801083e2
8010646a:	e8 21 9f ff ff       	call   80100390 <panic>
8010646f:	90                   	nop

80106470 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106470:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106474:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106479:	85 c0                	test   %eax,%eax
8010647b:	74 1b                	je     80106498 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010647d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106482:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106483:	a8 01                	test   $0x1,%al
80106485:	74 11                	je     80106498 <uartgetc+0x28>
80106487:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010648d:	0f b6 c0             	movzbl %al,%eax
80106490:	c3                   	ret    
80106491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010649d:	c3                   	ret    
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <uartputc.part.0>:
uartputc(int c)
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	89 c7                	mov    %eax,%edi
801064a6:	56                   	push   %esi
801064a7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064ac:	53                   	push   %ebx
801064ad:	bb 80 00 00 00       	mov    $0x80,%ebx
801064b2:	83 ec 0c             	sub    $0xc,%esp
801064b5:	eb 1b                	jmp    801064d2 <uartputc.part.0+0x32>
801064b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064be:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	6a 0a                	push   $0xa
801064c5:	e8 36 ca ff ff       	call   80102f00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	83 eb 01             	sub    $0x1,%ebx
801064d0:	74 07                	je     801064d9 <uartputc.part.0+0x39>
801064d2:	89 f2                	mov    %esi,%edx
801064d4:	ec                   	in     (%dx),%al
801064d5:	a8 20                	test   $0x20,%al
801064d7:	74 e7                	je     801064c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064de:	89 f8                	mov    %edi,%eax
801064e0:	ee                   	out    %al,(%dx)
}
801064e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e4:	5b                   	pop    %ebx
801064e5:	5e                   	pop    %esi
801064e6:	5f                   	pop    %edi
801064e7:	5d                   	pop    %ebp
801064e8:	c3                   	ret    
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <uartinit>:
{
801064f0:	f3 0f 1e fb          	endbr32 
801064f4:	55                   	push   %ebp
801064f5:	31 c9                	xor    %ecx,%ecx
801064f7:	89 c8                	mov    %ecx,%eax
801064f9:	89 e5                	mov    %esp,%ebp
801064fb:	57                   	push   %edi
801064fc:	56                   	push   %esi
801064fd:	53                   	push   %ebx
801064fe:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106503:	89 da                	mov    %ebx,%edx
80106505:	83 ec 0c             	sub    $0xc,%esp
80106508:	ee                   	out    %al,(%dx)
80106509:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010650e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106513:	89 fa                	mov    %edi,%edx
80106515:	ee                   	out    %al,(%dx)
80106516:	b8 0c 00 00 00       	mov    $0xc,%eax
8010651b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106520:	ee                   	out    %al,(%dx)
80106521:	be f9 03 00 00       	mov    $0x3f9,%esi
80106526:	89 c8                	mov    %ecx,%eax
80106528:	89 f2                	mov    %esi,%edx
8010652a:	ee                   	out    %al,(%dx)
8010652b:	b8 03 00 00 00       	mov    $0x3,%eax
80106530:	89 fa                	mov    %edi,%edx
80106532:	ee                   	out    %al,(%dx)
80106533:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106538:	89 c8                	mov    %ecx,%eax
8010653a:	ee                   	out    %al,(%dx)
8010653b:	b8 01 00 00 00       	mov    $0x1,%eax
80106540:	89 f2                	mov    %esi,%edx
80106542:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106543:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106548:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106549:	3c ff                	cmp    $0xff,%al
8010654b:	74 52                	je     8010659f <uartinit+0xaf>
  uart = 1;
8010654d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106554:	00 00 00 
80106557:	89 da                	mov    %ebx,%edx
80106559:	ec                   	in     (%dx),%al
8010655a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106560:	83 ec 08             	sub    $0x8,%esp
80106563:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106568:	bb 04 85 10 80       	mov    $0x80108504,%ebx
  ioapicenable(IRQ_COM1, 0);
8010656d:	6a 00                	push   $0x0
8010656f:	6a 04                	push   $0x4
80106571:	e8 4a c2 ff ff       	call   801027c0 <ioapicenable>
80106576:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106579:	b8 78 00 00 00       	mov    $0x78,%eax
8010657e:	eb 04                	jmp    80106584 <uartinit+0x94>
80106580:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106584:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010658a:	85 d2                	test   %edx,%edx
8010658c:	74 08                	je     80106596 <uartinit+0xa6>
    uartputc(*p);
8010658e:	0f be c0             	movsbl %al,%eax
80106591:	e8 0a ff ff ff       	call   801064a0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106596:	89 f0                	mov    %esi,%eax
80106598:	83 c3 01             	add    $0x1,%ebx
8010659b:	84 c0                	test   %al,%al
8010659d:	75 e1                	jne    80106580 <uartinit+0x90>
}
8010659f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a2:	5b                   	pop    %ebx
801065a3:	5e                   	pop    %esi
801065a4:	5f                   	pop    %edi
801065a5:	5d                   	pop    %ebp
801065a6:	c3                   	ret    
801065a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ae:	66 90                	xchg   %ax,%ax

801065b0 <uartputc>:
{
801065b0:	f3 0f 1e fb          	endbr32 
801065b4:	55                   	push   %ebp
  if(!uart)
801065b5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801065bb:	89 e5                	mov    %esp,%ebp
801065bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065c0:	85 d2                	test   %edx,%edx
801065c2:	74 0c                	je     801065d0 <uartputc+0x20>
}
801065c4:	5d                   	pop    %ebp
801065c5:	e9 d6 fe ff ff       	jmp    801064a0 <uartputc.part.0>
801065ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065e0 <uartintr>:

void
uartintr(void)
{
801065e0:	f3 0f 1e fb          	endbr32 
801065e4:	55                   	push   %ebp
801065e5:	89 e5                	mov    %esp,%ebp
801065e7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065ea:	68 70 64 10 80       	push   $0x80106470
801065ef:	e8 6c a2 ff ff       	call   80100860 <consoleintr>
}
801065f4:	83 c4 10             	add    $0x10,%esp
801065f7:	c9                   	leave  
801065f8:	c3                   	ret    

801065f9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $0
801065fb:	6a 00                	push   $0x0
  jmp alltraps
801065fd:	e9 47 fb ff ff       	jmp    80106149 <alltraps>

80106602 <vector1>:
.globl vector1
vector1:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $1
80106604:	6a 01                	push   $0x1
  jmp alltraps
80106606:	e9 3e fb ff ff       	jmp    80106149 <alltraps>

8010660b <vector2>:
.globl vector2
vector2:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $2
8010660d:	6a 02                	push   $0x2
  jmp alltraps
8010660f:	e9 35 fb ff ff       	jmp    80106149 <alltraps>

80106614 <vector3>:
.globl vector3
vector3:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $3
80106616:	6a 03                	push   $0x3
  jmp alltraps
80106618:	e9 2c fb ff ff       	jmp    80106149 <alltraps>

8010661d <vector4>:
.globl vector4
vector4:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $4
8010661f:	6a 04                	push   $0x4
  jmp alltraps
80106621:	e9 23 fb ff ff       	jmp    80106149 <alltraps>

80106626 <vector5>:
.globl vector5
vector5:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $5
80106628:	6a 05                	push   $0x5
  jmp alltraps
8010662a:	e9 1a fb ff ff       	jmp    80106149 <alltraps>

8010662f <vector6>:
.globl vector6
vector6:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $6
80106631:	6a 06                	push   $0x6
  jmp alltraps
80106633:	e9 11 fb ff ff       	jmp    80106149 <alltraps>

80106638 <vector7>:
.globl vector7
vector7:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $7
8010663a:	6a 07                	push   $0x7
  jmp alltraps
8010663c:	e9 08 fb ff ff       	jmp    80106149 <alltraps>

80106641 <vector8>:
.globl vector8
vector8:
  pushl $8
80106641:	6a 08                	push   $0x8
  jmp alltraps
80106643:	e9 01 fb ff ff       	jmp    80106149 <alltraps>

80106648 <vector9>:
.globl vector9
vector9:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $9
8010664a:	6a 09                	push   $0x9
  jmp alltraps
8010664c:	e9 f8 fa ff ff       	jmp    80106149 <alltraps>

80106651 <vector10>:
.globl vector10
vector10:
  pushl $10
80106651:	6a 0a                	push   $0xa
  jmp alltraps
80106653:	e9 f1 fa ff ff       	jmp    80106149 <alltraps>

80106658 <vector11>:
.globl vector11
vector11:
  pushl $11
80106658:	6a 0b                	push   $0xb
  jmp alltraps
8010665a:	e9 ea fa ff ff       	jmp    80106149 <alltraps>

8010665f <vector12>:
.globl vector12
vector12:
  pushl $12
8010665f:	6a 0c                	push   $0xc
  jmp alltraps
80106661:	e9 e3 fa ff ff       	jmp    80106149 <alltraps>

80106666 <vector13>:
.globl vector13
vector13:
  pushl $13
80106666:	6a 0d                	push   $0xd
  jmp alltraps
80106668:	e9 dc fa ff ff       	jmp    80106149 <alltraps>

8010666d <vector14>:
.globl vector14
vector14:
  pushl $14
8010666d:	6a 0e                	push   $0xe
  jmp alltraps
8010666f:	e9 d5 fa ff ff       	jmp    80106149 <alltraps>

80106674 <vector15>:
.globl vector15
vector15:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $15
80106676:	6a 0f                	push   $0xf
  jmp alltraps
80106678:	e9 cc fa ff ff       	jmp    80106149 <alltraps>

8010667d <vector16>:
.globl vector16
vector16:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $16
8010667f:	6a 10                	push   $0x10
  jmp alltraps
80106681:	e9 c3 fa ff ff       	jmp    80106149 <alltraps>

80106686 <vector17>:
.globl vector17
vector17:
  pushl $17
80106686:	6a 11                	push   $0x11
  jmp alltraps
80106688:	e9 bc fa ff ff       	jmp    80106149 <alltraps>

8010668d <vector18>:
.globl vector18
vector18:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $18
8010668f:	6a 12                	push   $0x12
  jmp alltraps
80106691:	e9 b3 fa ff ff       	jmp    80106149 <alltraps>

80106696 <vector19>:
.globl vector19
vector19:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $19
80106698:	6a 13                	push   $0x13
  jmp alltraps
8010669a:	e9 aa fa ff ff       	jmp    80106149 <alltraps>

8010669f <vector20>:
.globl vector20
vector20:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $20
801066a1:	6a 14                	push   $0x14
  jmp alltraps
801066a3:	e9 a1 fa ff ff       	jmp    80106149 <alltraps>

801066a8 <vector21>:
.globl vector21
vector21:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $21
801066aa:	6a 15                	push   $0x15
  jmp alltraps
801066ac:	e9 98 fa ff ff       	jmp    80106149 <alltraps>

801066b1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $22
801066b3:	6a 16                	push   $0x16
  jmp alltraps
801066b5:	e9 8f fa ff ff       	jmp    80106149 <alltraps>

801066ba <vector23>:
.globl vector23
vector23:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $23
801066bc:	6a 17                	push   $0x17
  jmp alltraps
801066be:	e9 86 fa ff ff       	jmp    80106149 <alltraps>

801066c3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $24
801066c5:	6a 18                	push   $0x18
  jmp alltraps
801066c7:	e9 7d fa ff ff       	jmp    80106149 <alltraps>

801066cc <vector25>:
.globl vector25
vector25:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $25
801066ce:	6a 19                	push   $0x19
  jmp alltraps
801066d0:	e9 74 fa ff ff       	jmp    80106149 <alltraps>

801066d5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $26
801066d7:	6a 1a                	push   $0x1a
  jmp alltraps
801066d9:	e9 6b fa ff ff       	jmp    80106149 <alltraps>

801066de <vector27>:
.globl vector27
vector27:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $27
801066e0:	6a 1b                	push   $0x1b
  jmp alltraps
801066e2:	e9 62 fa ff ff       	jmp    80106149 <alltraps>

801066e7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $28
801066e9:	6a 1c                	push   $0x1c
  jmp alltraps
801066eb:	e9 59 fa ff ff       	jmp    80106149 <alltraps>

801066f0 <vector29>:
.globl vector29
vector29:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $29
801066f2:	6a 1d                	push   $0x1d
  jmp alltraps
801066f4:	e9 50 fa ff ff       	jmp    80106149 <alltraps>

801066f9 <vector30>:
.globl vector30
vector30:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $30
801066fb:	6a 1e                	push   $0x1e
  jmp alltraps
801066fd:	e9 47 fa ff ff       	jmp    80106149 <alltraps>

80106702 <vector31>:
.globl vector31
vector31:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $31
80106704:	6a 1f                	push   $0x1f
  jmp alltraps
80106706:	e9 3e fa ff ff       	jmp    80106149 <alltraps>

8010670b <vector32>:
.globl vector32
vector32:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $32
8010670d:	6a 20                	push   $0x20
  jmp alltraps
8010670f:	e9 35 fa ff ff       	jmp    80106149 <alltraps>

80106714 <vector33>:
.globl vector33
vector33:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $33
80106716:	6a 21                	push   $0x21
  jmp alltraps
80106718:	e9 2c fa ff ff       	jmp    80106149 <alltraps>

8010671d <vector34>:
.globl vector34
vector34:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $34
8010671f:	6a 22                	push   $0x22
  jmp alltraps
80106721:	e9 23 fa ff ff       	jmp    80106149 <alltraps>

80106726 <vector35>:
.globl vector35
vector35:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $35
80106728:	6a 23                	push   $0x23
  jmp alltraps
8010672a:	e9 1a fa ff ff       	jmp    80106149 <alltraps>

8010672f <vector36>:
.globl vector36
vector36:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $36
80106731:	6a 24                	push   $0x24
  jmp alltraps
80106733:	e9 11 fa ff ff       	jmp    80106149 <alltraps>

80106738 <vector37>:
.globl vector37
vector37:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $37
8010673a:	6a 25                	push   $0x25
  jmp alltraps
8010673c:	e9 08 fa ff ff       	jmp    80106149 <alltraps>

80106741 <vector38>:
.globl vector38
vector38:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $38
80106743:	6a 26                	push   $0x26
  jmp alltraps
80106745:	e9 ff f9 ff ff       	jmp    80106149 <alltraps>

8010674a <vector39>:
.globl vector39
vector39:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $39
8010674c:	6a 27                	push   $0x27
  jmp alltraps
8010674e:	e9 f6 f9 ff ff       	jmp    80106149 <alltraps>

80106753 <vector40>:
.globl vector40
vector40:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $40
80106755:	6a 28                	push   $0x28
  jmp alltraps
80106757:	e9 ed f9 ff ff       	jmp    80106149 <alltraps>

8010675c <vector41>:
.globl vector41
vector41:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $41
8010675e:	6a 29                	push   $0x29
  jmp alltraps
80106760:	e9 e4 f9 ff ff       	jmp    80106149 <alltraps>

80106765 <vector42>:
.globl vector42
vector42:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $42
80106767:	6a 2a                	push   $0x2a
  jmp alltraps
80106769:	e9 db f9 ff ff       	jmp    80106149 <alltraps>

8010676e <vector43>:
.globl vector43
vector43:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $43
80106770:	6a 2b                	push   $0x2b
  jmp alltraps
80106772:	e9 d2 f9 ff ff       	jmp    80106149 <alltraps>

80106777 <vector44>:
.globl vector44
vector44:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $44
80106779:	6a 2c                	push   $0x2c
  jmp alltraps
8010677b:	e9 c9 f9 ff ff       	jmp    80106149 <alltraps>

80106780 <vector45>:
.globl vector45
vector45:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $45
80106782:	6a 2d                	push   $0x2d
  jmp alltraps
80106784:	e9 c0 f9 ff ff       	jmp    80106149 <alltraps>

80106789 <vector46>:
.globl vector46
vector46:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $46
8010678b:	6a 2e                	push   $0x2e
  jmp alltraps
8010678d:	e9 b7 f9 ff ff       	jmp    80106149 <alltraps>

80106792 <vector47>:
.globl vector47
vector47:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $47
80106794:	6a 2f                	push   $0x2f
  jmp alltraps
80106796:	e9 ae f9 ff ff       	jmp    80106149 <alltraps>

8010679b <vector48>:
.globl vector48
vector48:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $48
8010679d:	6a 30                	push   $0x30
  jmp alltraps
8010679f:	e9 a5 f9 ff ff       	jmp    80106149 <alltraps>

801067a4 <vector49>:
.globl vector49
vector49:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $49
801067a6:	6a 31                	push   $0x31
  jmp alltraps
801067a8:	e9 9c f9 ff ff       	jmp    80106149 <alltraps>

801067ad <vector50>:
.globl vector50
vector50:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $50
801067af:	6a 32                	push   $0x32
  jmp alltraps
801067b1:	e9 93 f9 ff ff       	jmp    80106149 <alltraps>

801067b6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $51
801067b8:	6a 33                	push   $0x33
  jmp alltraps
801067ba:	e9 8a f9 ff ff       	jmp    80106149 <alltraps>

801067bf <vector52>:
.globl vector52
vector52:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $52
801067c1:	6a 34                	push   $0x34
  jmp alltraps
801067c3:	e9 81 f9 ff ff       	jmp    80106149 <alltraps>

801067c8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $53
801067ca:	6a 35                	push   $0x35
  jmp alltraps
801067cc:	e9 78 f9 ff ff       	jmp    80106149 <alltraps>

801067d1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $54
801067d3:	6a 36                	push   $0x36
  jmp alltraps
801067d5:	e9 6f f9 ff ff       	jmp    80106149 <alltraps>

801067da <vector55>:
.globl vector55
vector55:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $55
801067dc:	6a 37                	push   $0x37
  jmp alltraps
801067de:	e9 66 f9 ff ff       	jmp    80106149 <alltraps>

801067e3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $56
801067e5:	6a 38                	push   $0x38
  jmp alltraps
801067e7:	e9 5d f9 ff ff       	jmp    80106149 <alltraps>

801067ec <vector57>:
.globl vector57
vector57:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $57
801067ee:	6a 39                	push   $0x39
  jmp alltraps
801067f0:	e9 54 f9 ff ff       	jmp    80106149 <alltraps>

801067f5 <vector58>:
.globl vector58
vector58:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $58
801067f7:	6a 3a                	push   $0x3a
  jmp alltraps
801067f9:	e9 4b f9 ff ff       	jmp    80106149 <alltraps>

801067fe <vector59>:
.globl vector59
vector59:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $59
80106800:	6a 3b                	push   $0x3b
  jmp alltraps
80106802:	e9 42 f9 ff ff       	jmp    80106149 <alltraps>

80106807 <vector60>:
.globl vector60
vector60:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $60
80106809:	6a 3c                	push   $0x3c
  jmp alltraps
8010680b:	e9 39 f9 ff ff       	jmp    80106149 <alltraps>

80106810 <vector61>:
.globl vector61
vector61:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $61
80106812:	6a 3d                	push   $0x3d
  jmp alltraps
80106814:	e9 30 f9 ff ff       	jmp    80106149 <alltraps>

80106819 <vector62>:
.globl vector62
vector62:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $62
8010681b:	6a 3e                	push   $0x3e
  jmp alltraps
8010681d:	e9 27 f9 ff ff       	jmp    80106149 <alltraps>

80106822 <vector63>:
.globl vector63
vector63:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $63
80106824:	6a 3f                	push   $0x3f
  jmp alltraps
80106826:	e9 1e f9 ff ff       	jmp    80106149 <alltraps>

8010682b <vector64>:
.globl vector64
vector64:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $64
8010682d:	6a 40                	push   $0x40
  jmp alltraps
8010682f:	e9 15 f9 ff ff       	jmp    80106149 <alltraps>

80106834 <vector65>:
.globl vector65
vector65:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $65
80106836:	6a 41                	push   $0x41
  jmp alltraps
80106838:	e9 0c f9 ff ff       	jmp    80106149 <alltraps>

8010683d <vector66>:
.globl vector66
vector66:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $66
8010683f:	6a 42                	push   $0x42
  jmp alltraps
80106841:	e9 03 f9 ff ff       	jmp    80106149 <alltraps>

80106846 <vector67>:
.globl vector67
vector67:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $67
80106848:	6a 43                	push   $0x43
  jmp alltraps
8010684a:	e9 fa f8 ff ff       	jmp    80106149 <alltraps>

8010684f <vector68>:
.globl vector68
vector68:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $68
80106851:	6a 44                	push   $0x44
  jmp alltraps
80106853:	e9 f1 f8 ff ff       	jmp    80106149 <alltraps>

80106858 <vector69>:
.globl vector69
vector69:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $69
8010685a:	6a 45                	push   $0x45
  jmp alltraps
8010685c:	e9 e8 f8 ff ff       	jmp    80106149 <alltraps>

80106861 <vector70>:
.globl vector70
vector70:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $70
80106863:	6a 46                	push   $0x46
  jmp alltraps
80106865:	e9 df f8 ff ff       	jmp    80106149 <alltraps>

8010686a <vector71>:
.globl vector71
vector71:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $71
8010686c:	6a 47                	push   $0x47
  jmp alltraps
8010686e:	e9 d6 f8 ff ff       	jmp    80106149 <alltraps>

80106873 <vector72>:
.globl vector72
vector72:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $72
80106875:	6a 48                	push   $0x48
  jmp alltraps
80106877:	e9 cd f8 ff ff       	jmp    80106149 <alltraps>

8010687c <vector73>:
.globl vector73
vector73:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $73
8010687e:	6a 49                	push   $0x49
  jmp alltraps
80106880:	e9 c4 f8 ff ff       	jmp    80106149 <alltraps>

80106885 <vector74>:
.globl vector74
vector74:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $74
80106887:	6a 4a                	push   $0x4a
  jmp alltraps
80106889:	e9 bb f8 ff ff       	jmp    80106149 <alltraps>

8010688e <vector75>:
.globl vector75
vector75:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $75
80106890:	6a 4b                	push   $0x4b
  jmp alltraps
80106892:	e9 b2 f8 ff ff       	jmp    80106149 <alltraps>

80106897 <vector76>:
.globl vector76
vector76:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $76
80106899:	6a 4c                	push   $0x4c
  jmp alltraps
8010689b:	e9 a9 f8 ff ff       	jmp    80106149 <alltraps>

801068a0 <vector77>:
.globl vector77
vector77:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $77
801068a2:	6a 4d                	push   $0x4d
  jmp alltraps
801068a4:	e9 a0 f8 ff ff       	jmp    80106149 <alltraps>

801068a9 <vector78>:
.globl vector78
vector78:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $78
801068ab:	6a 4e                	push   $0x4e
  jmp alltraps
801068ad:	e9 97 f8 ff ff       	jmp    80106149 <alltraps>

801068b2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $79
801068b4:	6a 4f                	push   $0x4f
  jmp alltraps
801068b6:	e9 8e f8 ff ff       	jmp    80106149 <alltraps>

801068bb <vector80>:
.globl vector80
vector80:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $80
801068bd:	6a 50                	push   $0x50
  jmp alltraps
801068bf:	e9 85 f8 ff ff       	jmp    80106149 <alltraps>

801068c4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $81
801068c6:	6a 51                	push   $0x51
  jmp alltraps
801068c8:	e9 7c f8 ff ff       	jmp    80106149 <alltraps>

801068cd <vector82>:
.globl vector82
vector82:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $82
801068cf:	6a 52                	push   $0x52
  jmp alltraps
801068d1:	e9 73 f8 ff ff       	jmp    80106149 <alltraps>

801068d6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $83
801068d8:	6a 53                	push   $0x53
  jmp alltraps
801068da:	e9 6a f8 ff ff       	jmp    80106149 <alltraps>

801068df <vector84>:
.globl vector84
vector84:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $84
801068e1:	6a 54                	push   $0x54
  jmp alltraps
801068e3:	e9 61 f8 ff ff       	jmp    80106149 <alltraps>

801068e8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $85
801068ea:	6a 55                	push   $0x55
  jmp alltraps
801068ec:	e9 58 f8 ff ff       	jmp    80106149 <alltraps>

801068f1 <vector86>:
.globl vector86
vector86:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $86
801068f3:	6a 56                	push   $0x56
  jmp alltraps
801068f5:	e9 4f f8 ff ff       	jmp    80106149 <alltraps>

801068fa <vector87>:
.globl vector87
vector87:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $87
801068fc:	6a 57                	push   $0x57
  jmp alltraps
801068fe:	e9 46 f8 ff ff       	jmp    80106149 <alltraps>

80106903 <vector88>:
.globl vector88
vector88:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $88
80106905:	6a 58                	push   $0x58
  jmp alltraps
80106907:	e9 3d f8 ff ff       	jmp    80106149 <alltraps>

8010690c <vector89>:
.globl vector89
vector89:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $89
8010690e:	6a 59                	push   $0x59
  jmp alltraps
80106910:	e9 34 f8 ff ff       	jmp    80106149 <alltraps>

80106915 <vector90>:
.globl vector90
vector90:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $90
80106917:	6a 5a                	push   $0x5a
  jmp alltraps
80106919:	e9 2b f8 ff ff       	jmp    80106149 <alltraps>

8010691e <vector91>:
.globl vector91
vector91:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $91
80106920:	6a 5b                	push   $0x5b
  jmp alltraps
80106922:	e9 22 f8 ff ff       	jmp    80106149 <alltraps>

80106927 <vector92>:
.globl vector92
vector92:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $92
80106929:	6a 5c                	push   $0x5c
  jmp alltraps
8010692b:	e9 19 f8 ff ff       	jmp    80106149 <alltraps>

80106930 <vector93>:
.globl vector93
vector93:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $93
80106932:	6a 5d                	push   $0x5d
  jmp alltraps
80106934:	e9 10 f8 ff ff       	jmp    80106149 <alltraps>

80106939 <vector94>:
.globl vector94
vector94:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $94
8010693b:	6a 5e                	push   $0x5e
  jmp alltraps
8010693d:	e9 07 f8 ff ff       	jmp    80106149 <alltraps>

80106942 <vector95>:
.globl vector95
vector95:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $95
80106944:	6a 5f                	push   $0x5f
  jmp alltraps
80106946:	e9 fe f7 ff ff       	jmp    80106149 <alltraps>

8010694b <vector96>:
.globl vector96
vector96:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $96
8010694d:	6a 60                	push   $0x60
  jmp alltraps
8010694f:	e9 f5 f7 ff ff       	jmp    80106149 <alltraps>

80106954 <vector97>:
.globl vector97
vector97:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $97
80106956:	6a 61                	push   $0x61
  jmp alltraps
80106958:	e9 ec f7 ff ff       	jmp    80106149 <alltraps>

8010695d <vector98>:
.globl vector98
vector98:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $98
8010695f:	6a 62                	push   $0x62
  jmp alltraps
80106961:	e9 e3 f7 ff ff       	jmp    80106149 <alltraps>

80106966 <vector99>:
.globl vector99
vector99:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $99
80106968:	6a 63                	push   $0x63
  jmp alltraps
8010696a:	e9 da f7 ff ff       	jmp    80106149 <alltraps>

8010696f <vector100>:
.globl vector100
vector100:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $100
80106971:	6a 64                	push   $0x64
  jmp alltraps
80106973:	e9 d1 f7 ff ff       	jmp    80106149 <alltraps>

80106978 <vector101>:
.globl vector101
vector101:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $101
8010697a:	6a 65                	push   $0x65
  jmp alltraps
8010697c:	e9 c8 f7 ff ff       	jmp    80106149 <alltraps>

80106981 <vector102>:
.globl vector102
vector102:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $102
80106983:	6a 66                	push   $0x66
  jmp alltraps
80106985:	e9 bf f7 ff ff       	jmp    80106149 <alltraps>

8010698a <vector103>:
.globl vector103
vector103:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $103
8010698c:	6a 67                	push   $0x67
  jmp alltraps
8010698e:	e9 b6 f7 ff ff       	jmp    80106149 <alltraps>

80106993 <vector104>:
.globl vector104
vector104:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $104
80106995:	6a 68                	push   $0x68
  jmp alltraps
80106997:	e9 ad f7 ff ff       	jmp    80106149 <alltraps>

8010699c <vector105>:
.globl vector105
vector105:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $105
8010699e:	6a 69                	push   $0x69
  jmp alltraps
801069a0:	e9 a4 f7 ff ff       	jmp    80106149 <alltraps>

801069a5 <vector106>:
.globl vector106
vector106:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $106
801069a7:	6a 6a                	push   $0x6a
  jmp alltraps
801069a9:	e9 9b f7 ff ff       	jmp    80106149 <alltraps>

801069ae <vector107>:
.globl vector107
vector107:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $107
801069b0:	6a 6b                	push   $0x6b
  jmp alltraps
801069b2:	e9 92 f7 ff ff       	jmp    80106149 <alltraps>

801069b7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $108
801069b9:	6a 6c                	push   $0x6c
  jmp alltraps
801069bb:	e9 89 f7 ff ff       	jmp    80106149 <alltraps>

801069c0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $109
801069c2:	6a 6d                	push   $0x6d
  jmp alltraps
801069c4:	e9 80 f7 ff ff       	jmp    80106149 <alltraps>

801069c9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $110
801069cb:	6a 6e                	push   $0x6e
  jmp alltraps
801069cd:	e9 77 f7 ff ff       	jmp    80106149 <alltraps>

801069d2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $111
801069d4:	6a 6f                	push   $0x6f
  jmp alltraps
801069d6:	e9 6e f7 ff ff       	jmp    80106149 <alltraps>

801069db <vector112>:
.globl vector112
vector112:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $112
801069dd:	6a 70                	push   $0x70
  jmp alltraps
801069df:	e9 65 f7 ff ff       	jmp    80106149 <alltraps>

801069e4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $113
801069e6:	6a 71                	push   $0x71
  jmp alltraps
801069e8:	e9 5c f7 ff ff       	jmp    80106149 <alltraps>

801069ed <vector114>:
.globl vector114
vector114:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $114
801069ef:	6a 72                	push   $0x72
  jmp alltraps
801069f1:	e9 53 f7 ff ff       	jmp    80106149 <alltraps>

801069f6 <vector115>:
.globl vector115
vector115:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $115
801069f8:	6a 73                	push   $0x73
  jmp alltraps
801069fa:	e9 4a f7 ff ff       	jmp    80106149 <alltraps>

801069ff <vector116>:
.globl vector116
vector116:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $116
80106a01:	6a 74                	push   $0x74
  jmp alltraps
80106a03:	e9 41 f7 ff ff       	jmp    80106149 <alltraps>

80106a08 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $117
80106a0a:	6a 75                	push   $0x75
  jmp alltraps
80106a0c:	e9 38 f7 ff ff       	jmp    80106149 <alltraps>

80106a11 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $118
80106a13:	6a 76                	push   $0x76
  jmp alltraps
80106a15:	e9 2f f7 ff ff       	jmp    80106149 <alltraps>

80106a1a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $119
80106a1c:	6a 77                	push   $0x77
  jmp alltraps
80106a1e:	e9 26 f7 ff ff       	jmp    80106149 <alltraps>

80106a23 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $120
80106a25:	6a 78                	push   $0x78
  jmp alltraps
80106a27:	e9 1d f7 ff ff       	jmp    80106149 <alltraps>

80106a2c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $121
80106a2e:	6a 79                	push   $0x79
  jmp alltraps
80106a30:	e9 14 f7 ff ff       	jmp    80106149 <alltraps>

80106a35 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $122
80106a37:	6a 7a                	push   $0x7a
  jmp alltraps
80106a39:	e9 0b f7 ff ff       	jmp    80106149 <alltraps>

80106a3e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $123
80106a40:	6a 7b                	push   $0x7b
  jmp alltraps
80106a42:	e9 02 f7 ff ff       	jmp    80106149 <alltraps>

80106a47 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $124
80106a49:	6a 7c                	push   $0x7c
  jmp alltraps
80106a4b:	e9 f9 f6 ff ff       	jmp    80106149 <alltraps>

80106a50 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $125
80106a52:	6a 7d                	push   $0x7d
  jmp alltraps
80106a54:	e9 f0 f6 ff ff       	jmp    80106149 <alltraps>

80106a59 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $126
80106a5b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a5d:	e9 e7 f6 ff ff       	jmp    80106149 <alltraps>

80106a62 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $127
80106a64:	6a 7f                	push   $0x7f
  jmp alltraps
80106a66:	e9 de f6 ff ff       	jmp    80106149 <alltraps>

80106a6b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $128
80106a6d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a72:	e9 d2 f6 ff ff       	jmp    80106149 <alltraps>

80106a77 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $129
80106a79:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a7e:	e9 c6 f6 ff ff       	jmp    80106149 <alltraps>

80106a83 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $130
80106a85:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a8a:	e9 ba f6 ff ff       	jmp    80106149 <alltraps>

80106a8f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $131
80106a91:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a96:	e9 ae f6 ff ff       	jmp    80106149 <alltraps>

80106a9b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $132
80106a9d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106aa2:	e9 a2 f6 ff ff       	jmp    80106149 <alltraps>

80106aa7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $133
80106aa9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106aae:	e9 96 f6 ff ff       	jmp    80106149 <alltraps>

80106ab3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $134
80106ab5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aba:	e9 8a f6 ff ff       	jmp    80106149 <alltraps>

80106abf <vector135>:
.globl vector135
vector135:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $135
80106ac1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ac6:	e9 7e f6 ff ff       	jmp    80106149 <alltraps>

80106acb <vector136>:
.globl vector136
vector136:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $136
80106acd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ad2:	e9 72 f6 ff ff       	jmp    80106149 <alltraps>

80106ad7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $137
80106ad9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ade:	e9 66 f6 ff ff       	jmp    80106149 <alltraps>

80106ae3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $138
80106ae5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106aea:	e9 5a f6 ff ff       	jmp    80106149 <alltraps>

80106aef <vector139>:
.globl vector139
vector139:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $139
80106af1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106af6:	e9 4e f6 ff ff       	jmp    80106149 <alltraps>

80106afb <vector140>:
.globl vector140
vector140:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $140
80106afd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b02:	e9 42 f6 ff ff       	jmp    80106149 <alltraps>

80106b07 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $141
80106b09:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b0e:	e9 36 f6 ff ff       	jmp    80106149 <alltraps>

80106b13 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $142
80106b15:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b1a:	e9 2a f6 ff ff       	jmp    80106149 <alltraps>

80106b1f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $143
80106b21:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b26:	e9 1e f6 ff ff       	jmp    80106149 <alltraps>

80106b2b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $144
80106b2d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b32:	e9 12 f6 ff ff       	jmp    80106149 <alltraps>

80106b37 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $145
80106b39:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b3e:	e9 06 f6 ff ff       	jmp    80106149 <alltraps>

80106b43 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $146
80106b45:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b4a:	e9 fa f5 ff ff       	jmp    80106149 <alltraps>

80106b4f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $147
80106b51:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b56:	e9 ee f5 ff ff       	jmp    80106149 <alltraps>

80106b5b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $148
80106b5d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b62:	e9 e2 f5 ff ff       	jmp    80106149 <alltraps>

80106b67 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $149
80106b69:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b6e:	e9 d6 f5 ff ff       	jmp    80106149 <alltraps>

80106b73 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $150
80106b75:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b7a:	e9 ca f5 ff ff       	jmp    80106149 <alltraps>

80106b7f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $151
80106b81:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b86:	e9 be f5 ff ff       	jmp    80106149 <alltraps>

80106b8b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $152
80106b8d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b92:	e9 b2 f5 ff ff       	jmp    80106149 <alltraps>

80106b97 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $153
80106b99:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b9e:	e9 a6 f5 ff ff       	jmp    80106149 <alltraps>

80106ba3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $154
80106ba5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106baa:	e9 9a f5 ff ff       	jmp    80106149 <alltraps>

80106baf <vector155>:
.globl vector155
vector155:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $155
80106bb1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bb6:	e9 8e f5 ff ff       	jmp    80106149 <alltraps>

80106bbb <vector156>:
.globl vector156
vector156:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $156
80106bbd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bc2:	e9 82 f5 ff ff       	jmp    80106149 <alltraps>

80106bc7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $157
80106bc9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bce:	e9 76 f5 ff ff       	jmp    80106149 <alltraps>

80106bd3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $158
80106bd5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bda:	e9 6a f5 ff ff       	jmp    80106149 <alltraps>

80106bdf <vector159>:
.globl vector159
vector159:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $159
80106be1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106be6:	e9 5e f5 ff ff       	jmp    80106149 <alltraps>

80106beb <vector160>:
.globl vector160
vector160:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $160
80106bed:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bf2:	e9 52 f5 ff ff       	jmp    80106149 <alltraps>

80106bf7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $161
80106bf9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bfe:	e9 46 f5 ff ff       	jmp    80106149 <alltraps>

80106c03 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $162
80106c05:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c0a:	e9 3a f5 ff ff       	jmp    80106149 <alltraps>

80106c0f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $163
80106c11:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c16:	e9 2e f5 ff ff       	jmp    80106149 <alltraps>

80106c1b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $164
80106c1d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c22:	e9 22 f5 ff ff       	jmp    80106149 <alltraps>

80106c27 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $165
80106c29:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c2e:	e9 16 f5 ff ff       	jmp    80106149 <alltraps>

80106c33 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $166
80106c35:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c3a:	e9 0a f5 ff ff       	jmp    80106149 <alltraps>

80106c3f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $167
80106c41:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c46:	e9 fe f4 ff ff       	jmp    80106149 <alltraps>

80106c4b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $168
80106c4d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c52:	e9 f2 f4 ff ff       	jmp    80106149 <alltraps>

80106c57 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $169
80106c59:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c5e:	e9 e6 f4 ff ff       	jmp    80106149 <alltraps>

80106c63 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $170
80106c65:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c6a:	e9 da f4 ff ff       	jmp    80106149 <alltraps>

80106c6f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $171
80106c71:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c76:	e9 ce f4 ff ff       	jmp    80106149 <alltraps>

80106c7b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $172
80106c7d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c82:	e9 c2 f4 ff ff       	jmp    80106149 <alltraps>

80106c87 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $173
80106c89:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c8e:	e9 b6 f4 ff ff       	jmp    80106149 <alltraps>

80106c93 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $174
80106c95:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c9a:	e9 aa f4 ff ff       	jmp    80106149 <alltraps>

80106c9f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $175
80106ca1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ca6:	e9 9e f4 ff ff       	jmp    80106149 <alltraps>

80106cab <vector176>:
.globl vector176
vector176:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $176
80106cad:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cb2:	e9 92 f4 ff ff       	jmp    80106149 <alltraps>

80106cb7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $177
80106cb9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cbe:	e9 86 f4 ff ff       	jmp    80106149 <alltraps>

80106cc3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $178
80106cc5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cca:	e9 7a f4 ff ff       	jmp    80106149 <alltraps>

80106ccf <vector179>:
.globl vector179
vector179:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $179
80106cd1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cd6:	e9 6e f4 ff ff       	jmp    80106149 <alltraps>

80106cdb <vector180>:
.globl vector180
vector180:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $180
80106cdd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ce2:	e9 62 f4 ff ff       	jmp    80106149 <alltraps>

80106ce7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $181
80106ce9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cee:	e9 56 f4 ff ff       	jmp    80106149 <alltraps>

80106cf3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $182
80106cf5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cfa:	e9 4a f4 ff ff       	jmp    80106149 <alltraps>

80106cff <vector183>:
.globl vector183
vector183:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $183
80106d01:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d06:	e9 3e f4 ff ff       	jmp    80106149 <alltraps>

80106d0b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $184
80106d0d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d12:	e9 32 f4 ff ff       	jmp    80106149 <alltraps>

80106d17 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $185
80106d19:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d1e:	e9 26 f4 ff ff       	jmp    80106149 <alltraps>

80106d23 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $186
80106d25:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d2a:	e9 1a f4 ff ff       	jmp    80106149 <alltraps>

80106d2f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $187
80106d31:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d36:	e9 0e f4 ff ff       	jmp    80106149 <alltraps>

80106d3b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $188
80106d3d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d42:	e9 02 f4 ff ff       	jmp    80106149 <alltraps>

80106d47 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $189
80106d49:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d4e:	e9 f6 f3 ff ff       	jmp    80106149 <alltraps>

80106d53 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $190
80106d55:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d5a:	e9 ea f3 ff ff       	jmp    80106149 <alltraps>

80106d5f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $191
80106d61:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d66:	e9 de f3 ff ff       	jmp    80106149 <alltraps>

80106d6b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $192
80106d6d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d72:	e9 d2 f3 ff ff       	jmp    80106149 <alltraps>

80106d77 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $193
80106d79:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d7e:	e9 c6 f3 ff ff       	jmp    80106149 <alltraps>

80106d83 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $194
80106d85:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d8a:	e9 ba f3 ff ff       	jmp    80106149 <alltraps>

80106d8f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $195
80106d91:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d96:	e9 ae f3 ff ff       	jmp    80106149 <alltraps>

80106d9b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $196
80106d9d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106da2:	e9 a2 f3 ff ff       	jmp    80106149 <alltraps>

80106da7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $197
80106da9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dae:	e9 96 f3 ff ff       	jmp    80106149 <alltraps>

80106db3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $198
80106db5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dba:	e9 8a f3 ff ff       	jmp    80106149 <alltraps>

80106dbf <vector199>:
.globl vector199
vector199:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $199
80106dc1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dc6:	e9 7e f3 ff ff       	jmp    80106149 <alltraps>

80106dcb <vector200>:
.globl vector200
vector200:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $200
80106dcd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dd2:	e9 72 f3 ff ff       	jmp    80106149 <alltraps>

80106dd7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $201
80106dd9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dde:	e9 66 f3 ff ff       	jmp    80106149 <alltraps>

80106de3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $202
80106de5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dea:	e9 5a f3 ff ff       	jmp    80106149 <alltraps>

80106def <vector203>:
.globl vector203
vector203:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $203
80106df1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106df6:	e9 4e f3 ff ff       	jmp    80106149 <alltraps>

80106dfb <vector204>:
.globl vector204
vector204:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $204
80106dfd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e02:	e9 42 f3 ff ff       	jmp    80106149 <alltraps>

80106e07 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $205
80106e09:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e0e:	e9 36 f3 ff ff       	jmp    80106149 <alltraps>

80106e13 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $206
80106e15:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e1a:	e9 2a f3 ff ff       	jmp    80106149 <alltraps>

80106e1f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $207
80106e21:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e26:	e9 1e f3 ff ff       	jmp    80106149 <alltraps>

80106e2b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $208
80106e2d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e32:	e9 12 f3 ff ff       	jmp    80106149 <alltraps>

80106e37 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $209
80106e39:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e3e:	e9 06 f3 ff ff       	jmp    80106149 <alltraps>

80106e43 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $210
80106e45:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e4a:	e9 fa f2 ff ff       	jmp    80106149 <alltraps>

80106e4f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $211
80106e51:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e56:	e9 ee f2 ff ff       	jmp    80106149 <alltraps>

80106e5b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $212
80106e5d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e62:	e9 e2 f2 ff ff       	jmp    80106149 <alltraps>

80106e67 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $213
80106e69:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e6e:	e9 d6 f2 ff ff       	jmp    80106149 <alltraps>

80106e73 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $214
80106e75:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e7a:	e9 ca f2 ff ff       	jmp    80106149 <alltraps>

80106e7f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $215
80106e81:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e86:	e9 be f2 ff ff       	jmp    80106149 <alltraps>

80106e8b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $216
80106e8d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e92:	e9 b2 f2 ff ff       	jmp    80106149 <alltraps>

80106e97 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $217
80106e99:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e9e:	e9 a6 f2 ff ff       	jmp    80106149 <alltraps>

80106ea3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $218
80106ea5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106eaa:	e9 9a f2 ff ff       	jmp    80106149 <alltraps>

80106eaf <vector219>:
.globl vector219
vector219:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $219
80106eb1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106eb6:	e9 8e f2 ff ff       	jmp    80106149 <alltraps>

80106ebb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $220
80106ebd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ec2:	e9 82 f2 ff ff       	jmp    80106149 <alltraps>

80106ec7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $221
80106ec9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ece:	e9 76 f2 ff ff       	jmp    80106149 <alltraps>

80106ed3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $222
80106ed5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eda:	e9 6a f2 ff ff       	jmp    80106149 <alltraps>

80106edf <vector223>:
.globl vector223
vector223:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $223
80106ee1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ee6:	e9 5e f2 ff ff       	jmp    80106149 <alltraps>

80106eeb <vector224>:
.globl vector224
vector224:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $224
80106eed:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ef2:	e9 52 f2 ff ff       	jmp    80106149 <alltraps>

80106ef7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $225
80106ef9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106efe:	e9 46 f2 ff ff       	jmp    80106149 <alltraps>

80106f03 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $226
80106f05:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f0a:	e9 3a f2 ff ff       	jmp    80106149 <alltraps>

80106f0f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $227
80106f11:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f16:	e9 2e f2 ff ff       	jmp    80106149 <alltraps>

80106f1b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $228
80106f1d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f22:	e9 22 f2 ff ff       	jmp    80106149 <alltraps>

80106f27 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $229
80106f29:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f2e:	e9 16 f2 ff ff       	jmp    80106149 <alltraps>

80106f33 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $230
80106f35:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f3a:	e9 0a f2 ff ff       	jmp    80106149 <alltraps>

80106f3f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $231
80106f41:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f46:	e9 fe f1 ff ff       	jmp    80106149 <alltraps>

80106f4b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $232
80106f4d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f52:	e9 f2 f1 ff ff       	jmp    80106149 <alltraps>

80106f57 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $233
80106f59:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f5e:	e9 e6 f1 ff ff       	jmp    80106149 <alltraps>

80106f63 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $234
80106f65:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f6a:	e9 da f1 ff ff       	jmp    80106149 <alltraps>

80106f6f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $235
80106f71:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f76:	e9 ce f1 ff ff       	jmp    80106149 <alltraps>

80106f7b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $236
80106f7d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f82:	e9 c2 f1 ff ff       	jmp    80106149 <alltraps>

80106f87 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $237
80106f89:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f8e:	e9 b6 f1 ff ff       	jmp    80106149 <alltraps>

80106f93 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $238
80106f95:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f9a:	e9 aa f1 ff ff       	jmp    80106149 <alltraps>

80106f9f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $239
80106fa1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fa6:	e9 9e f1 ff ff       	jmp    80106149 <alltraps>

80106fab <vector240>:
.globl vector240
vector240:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $240
80106fad:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fb2:	e9 92 f1 ff ff       	jmp    80106149 <alltraps>

80106fb7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $241
80106fb9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fbe:	e9 86 f1 ff ff       	jmp    80106149 <alltraps>

80106fc3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $242
80106fc5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fca:	e9 7a f1 ff ff       	jmp    80106149 <alltraps>

80106fcf <vector243>:
.globl vector243
vector243:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $243
80106fd1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fd6:	e9 6e f1 ff ff       	jmp    80106149 <alltraps>

80106fdb <vector244>:
.globl vector244
vector244:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $244
80106fdd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fe2:	e9 62 f1 ff ff       	jmp    80106149 <alltraps>

80106fe7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $245
80106fe9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fee:	e9 56 f1 ff ff       	jmp    80106149 <alltraps>

80106ff3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $246
80106ff5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ffa:	e9 4a f1 ff ff       	jmp    80106149 <alltraps>

80106fff <vector247>:
.globl vector247
vector247:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $247
80107001:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107006:	e9 3e f1 ff ff       	jmp    80106149 <alltraps>

8010700b <vector248>:
.globl vector248
vector248:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $248
8010700d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107012:	e9 32 f1 ff ff       	jmp    80106149 <alltraps>

80107017 <vector249>:
.globl vector249
vector249:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $249
80107019:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010701e:	e9 26 f1 ff ff       	jmp    80106149 <alltraps>

80107023 <vector250>:
.globl vector250
vector250:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $250
80107025:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010702a:	e9 1a f1 ff ff       	jmp    80106149 <alltraps>

8010702f <vector251>:
.globl vector251
vector251:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $251
80107031:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107036:	e9 0e f1 ff ff       	jmp    80106149 <alltraps>

8010703b <vector252>:
.globl vector252
vector252:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $252
8010703d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107042:	e9 02 f1 ff ff       	jmp    80106149 <alltraps>

80107047 <vector253>:
.globl vector253
vector253:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $253
80107049:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010704e:	e9 f6 f0 ff ff       	jmp    80106149 <alltraps>

80107053 <vector254>:
.globl vector254
vector254:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $254
80107055:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010705a:	e9 ea f0 ff ff       	jmp    80106149 <alltraps>

8010705f <vector255>:
.globl vector255
vector255:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $255
80107061:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107066:	e9 de f0 ff ff       	jmp    80106149 <alltraps>
8010706b:	66 90                	xchg   %ax,%ax
8010706d:	66 90                	xchg   %ax,%ax
8010706f:	90                   	nop

80107070 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107077:	c1 ea 16             	shr    $0x16,%edx
{
8010707a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010707b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010707e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107081:	8b 1f                	mov    (%edi),%ebx
80107083:	f6 c3 01             	test   $0x1,%bl
80107086:	74 28                	je     801070b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107088:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010708e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107094:	89 f0                	mov    %esi,%eax
}
80107096:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107099:	c1 e8 0a             	shr    $0xa,%eax
8010709c:	25 fc 0f 00 00       	and    $0xffc,%eax
801070a1:	01 d8                	add    %ebx,%eax
}
801070a3:	5b                   	pop    %ebx
801070a4:	5e                   	pop    %esi
801070a5:	5f                   	pop    %edi
801070a6:	5d                   	pop    %ebp
801070a7:	c3                   	ret    
801070a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070af:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070b0:	85 c9                	test   %ecx,%ecx
801070b2:	74 2c                	je     801070e0 <walkpgdir+0x70>
801070b4:	e8 47 ba ff ff       	call   80102b00 <kalloc>
801070b9:	89 c3                	mov    %eax,%ebx
801070bb:	85 c0                	test   %eax,%eax
801070bd:	74 21                	je     801070e0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070bf:	83 ec 04             	sub    $0x4,%esp
801070c2:	68 00 10 00 00       	push   $0x1000
801070c7:	6a 00                	push   $0x0
801070c9:	50                   	push   %eax
801070ca:	e8 31 de ff ff       	call   80104f00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070cf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070d5:	83 c4 10             	add    $0x10,%esp
801070d8:	83 c8 07             	or     $0x7,%eax
801070db:	89 07                	mov    %eax,(%edi)
801070dd:	eb b5                	jmp    80107094 <walkpgdir+0x24>
801070df:	90                   	nop
}
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070e3:	31 c0                	xor    %eax,%eax
}
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070f6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801070fa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107100:	89 d6                	mov    %edx,%esi
{
80107102:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107103:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107109:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010710c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010710f:	8b 45 08             	mov    0x8(%ebp),%eax
80107112:	29 f0                	sub    %esi,%eax
80107114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107117:	eb 1f                	jmp    80107138 <mappages+0x48>
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107120:	f6 00 01             	testb  $0x1,(%eax)
80107123:	75 45                	jne    8010716a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107125:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107128:	83 cb 01             	or     $0x1,%ebx
8010712b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010712d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107130:	74 2e                	je     80107160 <mappages+0x70>
      break;
    a += PGSIZE;
80107132:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010713b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107140:	89 f2                	mov    %esi,%edx
80107142:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107145:	89 f8                	mov    %edi,%eax
80107147:	e8 24 ff ff ff       	call   80107070 <walkpgdir>
8010714c:	85 c0                	test   %eax,%eax
8010714e:	75 d0                	jne    80107120 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107158:	5b                   	pop    %ebx
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
      panic("remap");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 0c 85 10 80       	push   $0x8010850c
80107172:	e8 19 92 ff ff       	call   80100390 <panic>
80107177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717e:	66 90                	xchg   %ax,%ax

80107180 <seginit>:
{
80107180:	f3 0f 1e fb          	endbr32 
80107184:	55                   	push   %ebp
80107185:	89 e5                	mov    %esp,%ebp
80107187:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010718a:	e8 61 ce ff ff       	call   80103ff0 <cpuid>
  pd[0] = size-1;
8010718f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107194:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010719a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719e:	c7 80 f8 37 18 80 ff 	movl   $0xffff,-0x7fe7c808(%eax)
801071a5:	ff 00 00 
801071a8:	c7 80 fc 37 18 80 00 	movl   $0xcf9a00,-0x7fe7c804(%eax)
801071af:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071b2:	c7 80 00 38 18 80 ff 	movl   $0xffff,-0x7fe7c800(%eax)
801071b9:	ff 00 00 
801071bc:	c7 80 04 38 18 80 00 	movl   $0xcf9200,-0x7fe7c7fc(%eax)
801071c3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071c6:	c7 80 08 38 18 80 ff 	movl   $0xffff,-0x7fe7c7f8(%eax)
801071cd:	ff 00 00 
801071d0:	c7 80 0c 38 18 80 00 	movl   $0xcffa00,-0x7fe7c7f4(%eax)
801071d7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071da:	c7 80 10 38 18 80 ff 	movl   $0xffff,-0x7fe7c7f0(%eax)
801071e1:	ff 00 00 
801071e4:	c7 80 14 38 18 80 00 	movl   $0xcff200,-0x7fe7c7ec(%eax)
801071eb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071ee:	05 f0 37 18 80       	add    $0x801837f0,%eax
  pd[1] = (uint)p;
801071f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071f7:	c1 e8 10             	shr    $0x10,%eax
801071fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107201:	0f 01 10             	lgdtl  (%eax)
}
80107204:	c9                   	leave  
80107205:	c3                   	ret    
80107206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010720d:	8d 76 00             	lea    0x0(%esi),%esi

80107210 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107210:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107214:	a1 a4 d9 18 80       	mov    0x8018d9a4,%eax
80107219:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010721e:	0f 22 d8             	mov    %eax,%cr3
}
80107221:	c3                   	ret    
80107222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
80107235:	89 e5                	mov    %esp,%ebp
80107237:	57                   	push   %edi
80107238:	56                   	push   %esi
80107239:	53                   	push   %ebx
8010723a:	83 ec 1c             	sub    $0x1c,%esp
8010723d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107240:	85 f6                	test   %esi,%esi
80107242:	0f 84 cb 00 00 00    	je     80107313 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107248:	8b 46 08             	mov    0x8(%esi),%eax
8010724b:	85 c0                	test   %eax,%eax
8010724d:	0f 84 da 00 00 00    	je     8010732d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107253:	8b 46 04             	mov    0x4(%esi),%eax
80107256:	85 c0                	test   %eax,%eax
80107258:	0f 84 c2 00 00 00    	je     80107320 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
8010725e:	e8 8d da ff ff       	call   80104cf0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107263:	e8 18 cd ff ff       	call   80103f80 <mycpu>
80107268:	89 c3                	mov    %eax,%ebx
8010726a:	e8 11 cd ff ff       	call   80103f80 <mycpu>
8010726f:	89 c7                	mov    %eax,%edi
80107271:	e8 0a cd ff ff       	call   80103f80 <mycpu>
80107276:	83 c7 08             	add    $0x8,%edi
80107279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010727c:	e8 ff cc ff ff       	call   80103f80 <mycpu>
80107281:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107284:	ba 67 00 00 00       	mov    $0x67,%edx
80107289:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107290:	83 c0 08             	add    $0x8,%eax
80107293:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010729a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010729f:	83 c1 08             	add    $0x8,%ecx
801072a2:	c1 e8 18             	shr    $0x18,%eax
801072a5:	c1 e9 10             	shr    $0x10,%ecx
801072a8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ae:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072b4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072b9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072c0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072c5:	e8 b6 cc ff ff       	call   80103f80 <mycpu>
801072ca:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072d1:	e8 aa cc ff ff       	call   80103f80 <mycpu>
801072d6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072da:	8b 5e 08             	mov    0x8(%esi),%ebx
801072dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072e3:	e8 98 cc ff ff       	call   80103f80 <mycpu>
801072e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072eb:	e8 90 cc ff ff       	call   80103f80 <mycpu>
801072f0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072f4:	b8 28 00 00 00       	mov    $0x28,%eax
801072f9:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072fc:	8b 46 04             	mov    0x4(%esi),%eax
801072ff:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107304:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730a:	5b                   	pop    %ebx
8010730b:	5e                   	pop    %esi
8010730c:	5f                   	pop    %edi
8010730d:	5d                   	pop    %ebp
  popcli();
8010730e:	e9 2d da ff ff       	jmp    80104d40 <popcli>
    panic("switchuvm: no process");
80107313:	83 ec 0c             	sub    $0xc,%esp
80107316:	68 12 85 10 80       	push   $0x80108512
8010731b:	e8 70 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	68 3d 85 10 80       	push   $0x8010853d
80107328:	e8 63 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010732d:	83 ec 0c             	sub    $0xc,%esp
80107330:	68 28 85 10 80       	push   $0x80108528
80107335:	e8 56 90 ff ff       	call   80100390 <panic>
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	57                   	push   %edi
80107348:	56                   	push   %esi
80107349:	53                   	push   %ebx
8010734a:	83 ec 1c             	sub    $0x1c,%esp
8010734d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107350:	8b 75 10             	mov    0x10(%ebp),%esi
80107353:	8b 7d 08             	mov    0x8(%ebp),%edi
80107356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107359:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010735f:	77 4b                	ja     801073ac <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107361:	e8 9a b7 ff ff       	call   80102b00 <kalloc>
  memset(mem, 0, PGSIZE);
80107366:	83 ec 04             	sub    $0x4,%esp
80107369:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010736e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107370:	6a 00                	push   $0x0
80107372:	50                   	push   %eax
80107373:	e8 88 db ff ff       	call   80104f00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107378:	58                   	pop    %eax
80107379:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010737f:	5a                   	pop    %edx
80107380:	6a 06                	push   $0x6
80107382:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107387:	31 d2                	xor    %edx,%edx
80107389:	50                   	push   %eax
8010738a:	89 f8                	mov    %edi,%eax
8010738c:	e8 5f fd ff ff       	call   801070f0 <mappages>
  memmove(mem, init, sz);
80107391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107394:	89 75 10             	mov    %esi,0x10(%ebp)
80107397:	83 c4 10             	add    $0x10,%esp
8010739a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010739d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a3:	5b                   	pop    %ebx
801073a4:	5e                   	pop    %esi
801073a5:	5f                   	pop    %edi
801073a6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073a7:	e9 f4 db ff ff       	jmp    80104fa0 <memmove>
    panic("inituvm: more than a page");
801073ac:	83 ec 0c             	sub    $0xc,%esp
801073af:	68 51 85 10 80       	push   $0x80108551
801073b4:	e8 d7 8f ff ff       	call   80100390 <panic>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	57                   	push   %edi
801073c8:	56                   	push   %esi
801073c9:	53                   	push   %ebx
801073ca:	83 ec 1c             	sub    $0x1c,%esp
801073cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801073d0:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801073d3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073d8:	0f 85 99 00 00 00    	jne    80107477 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801073de:	01 f0                	add    %esi,%eax
801073e0:	89 f3                	mov    %esi,%ebx
801073e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073e5:	8b 45 14             	mov    0x14(%ebp),%eax
801073e8:	01 f0                	add    %esi,%eax
801073ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073ed:	85 f6                	test   %esi,%esi
801073ef:	75 15                	jne    80107406 <loaduvm+0x46>
801073f1:	eb 6d                	jmp    80107460 <loaduvm+0xa0>
801073f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073f7:	90                   	nop
801073f8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801073fe:	89 f0                	mov    %esi,%eax
80107400:	29 d8                	sub    %ebx,%eax
80107402:	39 c6                	cmp    %eax,%esi
80107404:	76 5a                	jbe    80107460 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107409:	8b 45 08             	mov    0x8(%ebp),%eax
8010740c:	31 c9                	xor    %ecx,%ecx
8010740e:	29 da                	sub    %ebx,%edx
80107410:	e8 5b fc ff ff       	call   80107070 <walkpgdir>
80107415:	85 c0                	test   %eax,%eax
80107417:	74 51                	je     8010746a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107419:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010741b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010741e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107428:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010742e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107431:	29 d9                	sub    %ebx,%ecx
80107433:	05 00 00 00 80       	add    $0x80000000,%eax
80107438:	57                   	push   %edi
80107439:	51                   	push   %ecx
8010743a:	50                   	push   %eax
8010743b:	ff 75 10             	pushl  0x10(%ebp)
8010743e:	e8 2d a6 ff ff       	call   80101a70 <readi>
80107443:	83 c4 10             	add    $0x10,%esp
80107446:	39 f8                	cmp    %edi,%eax
80107448:	74 ae                	je     801073f8 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
8010744a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010744d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107452:	5b                   	pop    %ebx
80107453:	5e                   	pop    %esi
80107454:	5f                   	pop    %edi
80107455:	5d                   	pop    %ebp
80107456:	c3                   	ret    
80107457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745e:	66 90                	xchg   %ax,%ax
80107460:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107463:	31 c0                	xor    %eax,%eax
}
80107465:	5b                   	pop    %ebx
80107466:	5e                   	pop    %esi
80107467:	5f                   	pop    %edi
80107468:	5d                   	pop    %ebp
80107469:	c3                   	ret    
      panic("loaduvm: address should exist");
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	68 6b 85 10 80       	push   $0x8010856b
80107472:	e8 19 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107477:	83 ec 0c             	sub    $0xc,%esp
8010747a:	68 54 86 10 80       	push   $0x80108654
8010747f:	e8 0c 8f ff ff       	call   80100390 <panic>
80107484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop

80107490 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107490:	f3 0f 1e fb          	endbr32 
80107494:	55                   	push   %ebp
80107495:	89 e5                	mov    %esp,%ebp
80107497:	57                   	push   %edi
80107498:	56                   	push   %esi
80107499:	53                   	push   %ebx
8010749a:	83 ec 1c             	sub    $0x1c,%esp
8010749d:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
801074a0:	e8 6b cb ff ff       	call   80104010 <myproc>
801074a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801074a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801074ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ae:	0f 83 80 00 00 00    	jae    80107534 <deallocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(newsz);
801074b4:	8b 45 10             	mov    0x10(%ebp),%eax
801074b7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801074bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074c3:	89 d6                	mov    %edx,%esi
801074c5:	8d 76 00             	lea    0x0(%esi),%esi
  for(; a  < oldsz; a += PGSIZE){
801074c8:	39 75 0c             	cmp    %esi,0xc(%ebp)
801074cb:	76 64                	jbe    80107531 <deallocuvm+0xa1>
    pte = walkpgdir(pgdir, (char*)a, 0);
801074cd:	31 c9                	xor    %ecx,%ecx
801074cf:	89 f2                	mov    %esi,%edx
801074d1:	89 f8                	mov    %edi,%eax
801074d3:	e8 98 fb ff ff       	call   80107070 <walkpgdir>
801074d8:	89 c3                	mov    %eax,%ebx
    if(!pte)
801074da:	85 c0                	test   %eax,%eax
801074dc:	74 62                	je     80107540 <deallocuvm+0xb0>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801074de:	8b 08                	mov    (%eax),%ecx
801074e0:	f6 c1 01             	test   $0x1,%cl
801074e3:	74 41                	je     80107526 <deallocuvm+0x96>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801074e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801074eb:	74 79                	je     80107566 <deallocuvm+0xd6>
        panic("kfree");
      char *v = P2V(pa);
      
      curproc->nummemorypages--;
801074ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
      char *v = P2V(pa);
801074f0:	81 c1 00 00 00 80    	add    $0x80000000,%ecx

      if(getRefs(v) == 1)
801074f6:	83 ec 0c             	sub    $0xc,%esp
801074f9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      curproc->nummemorypages--;
801074fc:	83 a8 80 00 00 00 01 	subl   $0x1,0x80(%eax)
      if(getRefs(v) == 1)
80107503:	51                   	push   %ecx
80107504:	e8 97 b7 ff ff       	call   80102ca0 <getRefs>
80107509:	83 c4 10             	add    $0x10,%esp
8010750c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010750f:	83 f8 01             	cmp    $0x1,%eax
80107512:	74 44                	je     80107558 <deallocuvm+0xc8>
        kfree(v);
      else
        refDec(v);
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	51                   	push   %ecx
80107518:	e8 a3 b6 ff ff       	call   80102bc0 <refDec>
8010751d:	83 c4 10             	add    $0x10,%esp

      *pte = 0;
80107520:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107526:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(; a  < oldsz; a += PGSIZE){
8010752c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010752f:	77 9c                	ja     801074cd <deallocuvm+0x3d>
    }
  }
  return newsz;
80107531:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107537:	5b                   	pop    %ebx
80107538:	5e                   	pop    %esi
80107539:	5f                   	pop    %edi
8010753a:	5d                   	pop    %ebp
8010753b:	c3                   	ret    
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107540:	89 f2                	mov    %esi,%edx
80107542:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107548:	8d b2 00 00 40 00    	lea    0x400000(%edx),%esi
8010754e:	e9 75 ff ff ff       	jmp    801074c8 <deallocuvm+0x38>
80107553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107557:	90                   	nop
        kfree(v);
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	51                   	push   %ecx
8010755c:	e8 9f b2 ff ff       	call   80102800 <kfree>
80107561:	83 c4 10             	add    $0x10,%esp
80107564:	eb ba                	jmp    80107520 <deallocuvm+0x90>
        panic("kfree");
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	68 8a 7e 10 80       	push   $0x80107e8a
8010756e:	e8 1d 8e ff ff       	call   80100390 <panic>
80107573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107580 <allocuvm>:
{
80107580:	f3 0f 1e fb          	endbr32 
80107584:	55                   	push   %ebp
80107585:	89 e5                	mov    %esp,%ebp
80107587:	57                   	push   %edi
80107588:	56                   	push   %esi
80107589:	53                   	push   %ebx
8010758a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
8010758d:	e8 7e ca ff ff       	call   80104010 <myproc>
80107592:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107594:	8b 45 10             	mov    0x10(%ebp),%eax
80107597:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010759a:	85 c0                	test   %eax,%eax
8010759c:	0f 88 be 00 00 00    	js     80107660 <allocuvm+0xe0>
  if(newsz < oldsz)
801075a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075a8:	0f 82 a2 00 00 00    	jb     80107650 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
801075ae:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075b4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075ba:	39 75 10             	cmp    %esi,0x10(%ebp)
801075bd:	77 45                	ja     80107604 <allocuvm+0x84>
801075bf:	e9 8f 00 00 00       	jmp    80107653 <allocuvm+0xd3>
801075c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075c8:	83 ec 04             	sub    $0x4,%esp
801075cb:	68 00 10 00 00       	push   $0x1000
801075d0:	6a 00                	push   $0x0
801075d2:	50                   	push   %eax
801075d3:	e8 28 d9 ff ff       	call   80104f00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075d8:	58                   	pop    %eax
801075d9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075df:	5a                   	pop    %edx
801075e0:	6a 06                	push   $0x6
801075e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075e7:	89 f2                	mov    %esi,%edx
801075e9:	50                   	push   %eax
801075ea:	8b 45 08             	mov    0x8(%ebp),%eax
801075ed:	e8 fe fa ff ff       	call   801070f0 <mappages>
801075f2:	83 c4 10             	add    $0x10,%esp
801075f5:	85 c0                	test   %eax,%eax
801075f7:	78 7f                	js     80107678 <allocuvm+0xf8>
  for(; a < newsz; a += PGSIZE){
801075f9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075ff:	39 75 10             	cmp    %esi,0x10(%ebp)
80107602:	76 4f                	jbe    80107653 <allocuvm+0xd3>
    curproc->nummemorypages++;
80107604:	83 87 80 00 00 00 01 	addl   $0x1,0x80(%edi)
    mem = kalloc();
8010760b:	e8 f0 b4 ff ff       	call   80102b00 <kalloc>
80107610:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107612:	85 c0                	test   %eax,%eax
80107614:	75 b2                	jne    801075c8 <allocuvm+0x48>
      cprintf("allocuvm out of memory\n");
80107616:	83 ec 0c             	sub    $0xc,%esp
80107619:	68 89 85 10 80       	push   $0x80108589
8010761e:	e8 8d 90 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107623:	83 c4 0c             	add    $0xc,%esp
80107626:	ff 75 0c             	pushl  0xc(%ebp)
80107629:	ff 75 10             	pushl  0x10(%ebp)
8010762c:	ff 75 08             	pushl  0x8(%ebp)
8010762f:	e8 5c fe ff ff       	call   80107490 <deallocuvm>
      return 0;
80107634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010763b:	83 c4 10             	add    $0x10,%esp
}
8010763e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107644:	5b                   	pop    %ebx
80107645:	5e                   	pop    %esi
80107646:	5f                   	pop    %edi
80107647:	5d                   	pop    %ebp
80107648:	c3                   	ret    
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107650:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107656:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107659:	5b                   	pop    %ebx
8010765a:	5e                   	pop    %esi
8010765b:	5f                   	pop    %edi
8010765c:	5d                   	pop    %ebp
8010765d:	c3                   	ret    
8010765e:	66 90                	xchg   %ax,%ax
    return 0;
80107660:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010766a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010766d:	5b                   	pop    %ebx
8010766e:	5e                   	pop    %esi
8010766f:	5f                   	pop    %edi
80107670:	5d                   	pop    %ebp
80107671:	c3                   	ret    
80107672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107678:	83 ec 0c             	sub    $0xc,%esp
8010767b:	68 a1 85 10 80       	push   $0x801085a1
80107680:	e8 2b 90 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107685:	83 c4 0c             	add    $0xc,%esp
80107688:	ff 75 0c             	pushl  0xc(%ebp)
8010768b:	ff 75 10             	pushl  0x10(%ebp)
8010768e:	ff 75 08             	pushl  0x8(%ebp)
80107691:	e8 fa fd ff ff       	call   80107490 <deallocuvm>
      kfree(mem);
80107696:	89 1c 24             	mov    %ebx,(%esp)
80107699:	e8 62 b1 ff ff       	call   80102800 <kfree>
      return 0;
8010769e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076a5:	83 c4 10             	add    $0x10,%esp
}
801076a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ae:	5b                   	pop    %ebx
801076af:	5e                   	pop    %esi
801076b0:	5f                   	pop    %edi
801076b1:	5d                   	pop    %ebp
801076b2:	c3                   	ret    
801076b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076c0:	f3 0f 1e fb          	endbr32 
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
801076c7:	57                   	push   %edi
801076c8:	56                   	push   %esi
801076c9:	53                   	push   %ebx
801076ca:	83 ec 0c             	sub    $0xc,%esp
801076cd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076d0:	85 f6                	test   %esi,%esi
801076d2:	74 5d                	je     80107731 <freevm+0x71>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801076d4:	83 ec 04             	sub    $0x4,%esp
801076d7:	89 f3                	mov    %esi,%ebx
801076d9:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076df:	6a 00                	push   $0x0
801076e1:	68 00 00 00 80       	push   $0x80000000
801076e6:	56                   	push   %esi
801076e7:	e8 a4 fd ff ff       	call   80107490 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	eb 0e                	jmp    801076ff <freevm+0x3f>
801076f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076f8:	83 c3 04             	add    $0x4,%ebx
801076fb:	39 df                	cmp    %ebx,%edi
801076fd:	74 23                	je     80107722 <freevm+0x62>
    if(pgdir[i] & PTE_P){
801076ff:	8b 03                	mov    (%ebx),%eax
80107701:	a8 01                	test   $0x1,%al
80107703:	74 f3                	je     801076f8 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107705:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010770a:	83 ec 0c             	sub    $0xc,%esp
8010770d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107710:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107715:	50                   	push   %eax
80107716:	e8 e5 b0 ff ff       	call   80102800 <kfree>
8010771b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010771e:	39 df                	cmp    %ebx,%edi
80107720:	75 dd                	jne    801076ff <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
80107722:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107728:	5b                   	pop    %ebx
80107729:	5e                   	pop    %esi
8010772a:	5f                   	pop    %edi
8010772b:	5d                   	pop    %ebp
  kfree((char*)pgdir);
8010772c:	e9 cf b0 ff ff       	jmp    80102800 <kfree>
    panic("freevm: no pgdir");
80107731:	83 ec 0c             	sub    $0xc,%esp
80107734:	68 bd 85 10 80       	push   $0x801085bd
80107739:	e8 52 8c ff ff       	call   80100390 <panic>
8010773e:	66 90                	xchg   %ax,%ax

80107740 <setupkvm>:
{
80107740:	f3 0f 1e fb          	endbr32 
80107744:	55                   	push   %ebp
80107745:	89 e5                	mov    %esp,%ebp
80107747:	56                   	push   %esi
80107748:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107749:	e8 b2 b3 ff ff       	call   80102b00 <kalloc>
8010774e:	89 c6                	mov    %eax,%esi
80107750:	85 c0                	test   %eax,%eax
80107752:	74 60                	je     801077b4 <setupkvm+0x74>
  memset(pgdir, 0, PGSIZE);
80107754:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107757:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010775c:	68 00 10 00 00       	push   $0x1000
80107761:	6a 00                	push   $0x0
80107763:	50                   	push   %eax
80107764:	e8 97 d7 ff ff       	call   80104f00 <memset>
  cprintf("pgdir val %d\n", pgdir);
80107769:	58                   	pop    %eax
8010776a:	5a                   	pop    %edx
8010776b:	56                   	push   %esi
8010776c:	68 ce 85 10 80       	push   $0x801085ce
80107771:	e8 3a 8f ff ff       	call   801006b0 <cprintf>
80107776:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107779:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010777c:	83 ec 08             	sub    $0x8,%esp
8010777f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107782:	ff 73 0c             	pushl  0xc(%ebx)
80107785:	8b 13                	mov    (%ebx),%edx
80107787:	50                   	push   %eax
80107788:	29 c1                	sub    %eax,%ecx
8010778a:	89 f0                	mov    %esi,%eax
8010778c:	e8 5f f9 ff ff       	call   801070f0 <mappages>
80107791:	83 c4 10             	add    $0x10,%esp
80107794:	85 c0                	test   %eax,%eax
80107796:	78 28                	js     801077c0 <setupkvm+0x80>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107798:	83 c3 10             	add    $0x10,%ebx
8010779b:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077a1:	75 d6                	jne    80107779 <setupkvm+0x39>
  cprintf("pgdir val %d\n", pgdir);
801077a3:	83 ec 08             	sub    $0x8,%esp
801077a6:	56                   	push   %esi
801077a7:	68 ce 85 10 80       	push   $0x801085ce
801077ac:	e8 ff 8e ff ff       	call   801006b0 <cprintf>
  return pgdir;
801077b1:	83 c4 10             	add    $0x10,%esp
}
801077b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077b7:	89 f0                	mov    %esi,%eax
801077b9:	5b                   	pop    %ebx
801077ba:	5e                   	pop    %esi
801077bb:	5d                   	pop    %ebp
801077bc:	c3                   	ret    
801077bd:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
801077c0:	83 ec 0c             	sub    $0xc,%esp
801077c3:	56                   	push   %esi
      return 0;
801077c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077c6:	e8 f5 fe ff ff       	call   801076c0 <freevm>
      return 0;
801077cb:	83 c4 10             	add    $0x10,%esp
}
801077ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d1:	89 f0                	mov    %esi,%eax
801077d3:	5b                   	pop    %ebx
801077d4:	5e                   	pop    %esi
801077d5:	5d                   	pop    %ebp
801077d6:	c3                   	ret    
801077d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077de:	66 90                	xchg   %ax,%ax

801077e0 <kvmalloc>:
{
801077e0:	f3 0f 1e fb          	endbr32 
801077e4:	55                   	push   %ebp
801077e5:	89 e5                	mov    %esp,%ebp
801077e7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077ea:	e8 51 ff ff ff       	call   80107740 <setupkvm>
801077ef:	a3 a4 d9 18 80       	mov    %eax,0x8018d9a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077f4:	05 00 00 00 80       	add    $0x80000000,%eax
801077f9:	0f 22 d8             	mov    %eax,%cr3
}
801077fc:	c9                   	leave  
801077fd:	c3                   	ret    
801077fe:	66 90                	xchg   %ax,%ax

80107800 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107805:	31 c9                	xor    %ecx,%ecx
{
80107807:	89 e5                	mov    %esp,%ebp
80107809:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010780c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010780f:	8b 45 08             	mov    0x8(%ebp),%eax
80107812:	e8 59 f8 ff ff       	call   80107070 <walkpgdir>
  if(pte == 0)
80107817:	85 c0                	test   %eax,%eax
80107819:	74 05                	je     80107820 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010781b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010781e:	c9                   	leave  
8010781f:	c3                   	ret    
    panic("clearpteu");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 dc 85 10 80       	push   $0x801085dc
80107828:	e8 63 8b ff ff       	call   80100390 <panic>
8010782d:	8d 76 00             	lea    0x0(%esi),%esi

80107830 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
80107835:	89 e5                	mov    %esp,%ebp
80107837:	57                   	push   %edi
80107838:	56                   	push   %esi
80107839:	53                   	push   %ebx
8010783a:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d = 0;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
8010783d:	e8 fe fe ff ff       	call   80107740 <setupkvm>
80107842:	89 c6                	mov    %eax,%esi
80107844:	85 c0                	test   %eax,%eax
80107846:	0f 84 84 00 00 00    	je     801078d0 <cowuvm+0xa0>
  {
    return 0;
  }
  for(i = 0; i < sz; i += PGSIZE)
8010784c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010784f:	85 c0                	test   %eax,%eax
80107851:	74 7d                	je     801078d0 <cowuvm+0xa0>
80107853:	31 ff                	xor    %edi,%edi
80107855:	eb 29                	jmp    80107880 <cowuvm+0x50>
80107857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785e:	66 90                	xchg   %ax,%ax
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags < 0))
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107860:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107863:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    refInc(virt_addr);
80107869:	53                   	push   %ebx
8010786a:	e8 c1 b3 ff ff       	call   80102c30 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
8010786f:	0f 01 3f             	invlpg (%edi)
  for(i = 0; i < sz; i += PGSIZE)
80107872:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107878:	83 c4 10             	add    $0x10,%esp
8010787b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010787e:	76 50                	jbe    801078d0 <cowuvm+0xa0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107880:	8b 45 08             	mov    0x8(%ebp),%eax
80107883:	31 c9                	xor    %ecx,%ecx
80107885:	89 fa                	mov    %edi,%edx
80107887:	e8 e4 f7 ff ff       	call   80107070 <walkpgdir>
8010788c:	85 c0                	test   %eax,%eax
8010788e:	74 57                	je     801078e7 <cowuvm+0xb7>
    if(!(*pte & PTE_P))
80107890:	8b 18                	mov    (%eax),%ebx
80107892:	f6 c3 01             	test   $0x1,%bl
80107895:	74 43                	je     801078da <cowuvm+0xaa>
    *pte &= ~PTE_W;
80107897:	89 d9                	mov    %ebx,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags < 0))
80107899:	83 ec 08             	sub    $0x8,%esp
8010789c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801078a2:	89 fa                	mov    %edi,%edx
    *pte &= ~PTE_W;
801078a4:	83 e1 fd             	and    $0xfffffffd,%ecx
801078a7:	80 cd 08             	or     $0x8,%ch
801078aa:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags < 0))
801078ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078b1:	89 f0                	mov    %esi,%eax
801078b3:	6a 00                	push   $0x0
801078b5:	53                   	push   %ebx
801078b6:	e8 35 f8 ff ff       	call   801070f0 <mappages>
801078bb:	83 c4 10             	add    $0x10,%esp
801078be:	85 c0                	test   %eax,%eax
801078c0:	74 9e                	je     80107860 <cowuvm+0x30>
    invlpg((void*)i); // flush TLB entry
  }
  return d;

bad:
  freevm(d);
801078c2:	83 ec 0c             	sub    $0xc,%esp
801078c5:	56                   	push   %esi
  return 0;
801078c6:	31 f6                	xor    %esi,%esi
  freevm(d);
801078c8:	e8 f3 fd ff ff       	call   801076c0 <freevm>
  return 0;
801078cd:	83 c4 10             	add    $0x10,%esp
}
801078d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d3:	89 f0                	mov    %esi,%eax
801078d5:	5b                   	pop    %ebx
801078d6:	5e                   	pop    %esi
801078d7:	5f                   	pop    %edi
801078d8:	5d                   	pop    %ebp
801078d9:	c3                   	ret    
      panic("cowuvm: page not present");
801078da:	83 ec 0c             	sub    $0xc,%esp
801078dd:	68 f5 85 10 80       	push   $0x801085f5
801078e2:	e8 a9 8a ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
801078e7:	83 ec 0c             	sub    $0xc,%esp
801078ea:	68 e6 85 10 80       	push   $0x801085e6
801078ef:	e8 9c 8a ff ff       	call   80100390 <panic>
801078f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078ff:	90                   	nop

80107900 <pagefault>:

void
pagefault()
{
80107900:	f3 0f 1e fb          	endbr32 
80107904:	55                   	push   %ebp
80107905:	89 e5                	mov    %esp,%ebp
80107907:	57                   	push   %edi
80107908:	56                   	push   %esi
80107909:	53                   	push   %ebx
8010790a:	83 ec 28             	sub    $0x28,%esp
  cprintf("PAGEFAULT!!!!\n");
8010790d:	68 0e 86 10 80       	push   $0x8010860e
80107912:	e8 99 8d ff ff       	call   801006b0 <cprintf>
  struct proc* curproc = myproc();
80107917:	e8 f4 c6 ff ff       	call   80104010 <myproc>
8010791c:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010791e:	0f 20 d2             	mov    %cr2,%edx
  char* new_page;

  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
  
  // we should now do COW mechanism for kernel addresses
  if(va >= KERNBASE || (pte = walkpgdir(curproc->pgdir, start_page, 0)) == 0)
80107921:	83 c4 10             	add    $0x10,%esp
80107924:	85 d2                	test   %edx,%edx
80107926:	78 38                	js     80107960 <pagefault+0x60>
  uint err = curproc->tf->err;
80107928:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010792b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if(va >= KERNBASE || (pte = walkpgdir(curproc->pgdir, start_page, 0)) == 0)
80107931:	31 c9                	xor    %ecx,%ecx
  uint err = curproc->tf->err;
80107933:	8b 70 34             	mov    0x34(%eax),%esi
  if(va >= KERNBASE || (pte = walkpgdir(curproc->pgdir, start_page, 0)) == 0)
80107936:	8b 43 04             	mov    0x4(%ebx),%eax
80107939:	e8 32 f7 ff ff       	call   80107070 <walkpgdir>
8010793e:	89 c7                	mov    %eax,%edi
80107940:	85 c0                	test   %eax,%eax
80107942:	74 1c                	je     80107960 <pagefault+0x60>
    curproc->killed = 1;
    return;
  }

  // checking that page fault caused by write
  if(err & FEC_WR)
80107944:	83 e6 02             	and    $0x2,%esi
80107947:	74 07                	je     80107950 <pagefault+0x50>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW)) 
80107949:	8b 10                	mov    (%eax),%edx
8010794b:	f6 c6 08             	test   $0x8,%dh
8010794e:	75 40                	jne    80107990 <pagefault+0x90>
    }
  }

  else // pagefault is not write fault
  {
    curproc->killed = 1;
80107950:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return;
  }
}
80107957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795a:	5b                   	pop    %ebx
8010795b:	5e                   	pop    %esi
8010795c:	5f                   	pop    %edi
8010795d:	5d                   	pop    %ebp
8010795e:	c3                   	ret    
8010795f:	90                   	nop
    cprintf("Page fault: pid %d %s accesses invalid address %s.\n", curproc->pid, curproc->name);
80107960:	83 ec 04             	sub    $0x4,%esp
80107963:	8d 43 6c             	lea    0x6c(%ebx),%eax
80107966:	50                   	push   %eax
80107967:	ff 73 10             	pushl  0x10(%ebx)
8010796a:	68 78 86 10 80       	push   $0x80108678
8010796f:	e8 3c 8d ff ff       	call   801006b0 <cprintf>
    curproc->killed = 1;
80107974:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return;
8010797b:	83 c4 10             	add    $0x10,%esp
}
8010797e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107981:	5b                   	pop    %ebx
80107982:	5e                   	pop    %esi
80107983:	5f                   	pop    %edi
80107984:	5d                   	pop    %ebp
80107985:	c3                   	ret    
80107986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010798d:	8d 76 00             	lea    0x0(%esi),%esi
      pa = PTE_ADDR(*pte);
80107990:	89 d6                	mov    %edx,%esi
      ref_count = getRefs(va);
80107992:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
80107995:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107998:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      char *va = P2V(pa);
8010799e:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      ref_count = getRefs(va);
801079a4:	56                   	push   %esi
801079a5:	e8 f6 b2 ff ff       	call   80102ca0 <getRefs>
      if (ref_count > 1) // more than one reference
801079aa:	83 c4 10             	add    $0x10,%esp
801079ad:	83 f8 01             	cmp    $0x1,%eax
801079b0:	7f 16                	jg     801079c8 <pagefault+0xc8>
        *pte &= ~PTE_COW; // turn COW off
801079b2:	8b 07                	mov    (%edi),%eax
801079b4:	80 e4 f7             	and    $0xf7,%ah
801079b7:	83 c8 02             	or     $0x2,%eax
801079ba:	89 07                	mov    %eax,(%edi)
}
801079bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bf:	5b                   	pop    %ebx
801079c0:	5e                   	pop    %esi
801079c1:	5f                   	pop    %edi
801079c2:	5d                   	pop    %ebp
801079c3:	c3                   	ret    
801079c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
801079c8:	e8 33 b1 ff ff       	call   80102b00 <kalloc>
        curproc->nummemorypages++;
801079cd:	83 83 80 00 00 00 01 	addl   $0x1,0x80(%ebx)
        memmove(new_page, va, PGSIZE); // copy the faulty page to the newly allocated one
801079d4:	83 ec 04             	sub    $0x4,%esp
801079d7:	68 00 10 00 00       	push   $0x1000
801079dc:	56                   	push   %esi
801079dd:	50                   	push   %eax
801079de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079e1:	e8 ba d5 ff ff       	call   80104fa0 <memmove>
      flags = PTE_FLAGS(*pte);
801079e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
801079e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
801079ec:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
801079f2:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801079f8:	09 ca                	or     %ecx,%edx
801079fa:	83 ca 03             	or     $0x3,%edx
801079fd:	89 17                	mov    %edx,(%edi)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801079ff:	0f 01 3e             	invlpg (%esi)
        refDec(va); // decrement old page's ref count
80107a02:	89 34 24             	mov    %esi,(%esp)
80107a05:	e8 b6 b1 ff ff       	call   80102bc0 <refDec>
80107a0a:	83 c4 10             	add    $0x10,%esp
80107a0d:	e9 45 ff ff ff       	jmp    80107957 <pagefault+0x57>
80107a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a20 <copyuvm>:

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	57                   	push   %edi
80107a28:	56                   	push   %esi
80107a29:	53                   	push   %ebx
80107a2a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a2d:	e8 0e fd ff ff       	call   80107740 <setupkvm>
80107a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a35:	85 c0                	test   %eax,%eax
80107a37:	0f 84 9b 00 00 00    	je     80107ad8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a40:	85 c9                	test   %ecx,%ecx
80107a42:	0f 84 90 00 00 00    	je     80107ad8 <copyuvm+0xb8>
80107a48:	31 f6                	xor    %esi,%esi
80107a4a:	eb 46                	jmp    80107a92 <copyuvm+0x72>
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a50:	83 ec 04             	sub    $0x4,%esp
80107a53:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a59:	68 00 10 00 00       	push   $0x1000
80107a5e:	57                   	push   %edi
80107a5f:	50                   	push   %eax
80107a60:	e8 3b d5 ff ff       	call   80104fa0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a65:	58                   	pop    %eax
80107a66:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a6c:	5a                   	pop    %edx
80107a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a70:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a75:	89 f2                	mov    %esi,%edx
80107a77:	50                   	push   %eax
80107a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a7b:	e8 70 f6 ff ff       	call   801070f0 <mappages>
80107a80:	83 c4 10             	add    $0x10,%esp
80107a83:	85 c0                	test   %eax,%eax
80107a85:	78 61                	js     80107ae8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a87:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a8d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a90:	76 46                	jbe    80107ad8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a92:	8b 45 08             	mov    0x8(%ebp),%eax
80107a95:	31 c9                	xor    %ecx,%ecx
80107a97:	89 f2                	mov    %esi,%edx
80107a99:	e8 d2 f5 ff ff       	call   80107070 <walkpgdir>
80107a9e:	85 c0                	test   %eax,%eax
80107aa0:	74 61                	je     80107b03 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107aa2:	8b 00                	mov    (%eax),%eax
80107aa4:	a8 01                	test   $0x1,%al
80107aa6:	74 4e                	je     80107af6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107aa8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107aaa:	25 ff 0f 00 00       	and    $0xfff,%eax
80107aaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107ab2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107ab8:	e8 43 b0 ff ff       	call   80102b00 <kalloc>
80107abd:	89 c3                	mov    %eax,%ebx
80107abf:	85 c0                	test   %eax,%eax
80107ac1:	75 8d                	jne    80107a50 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ac3:	83 ec 0c             	sub    $0xc,%esp
80107ac6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ac9:	e8 f2 fb ff ff       	call   801076c0 <freevm>
  return 0;
80107ace:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ad5:	83 c4 10             	add    $0x10,%esp
}
80107ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ade:	5b                   	pop    %ebx
80107adf:	5e                   	pop    %esi
80107ae0:	5f                   	pop    %edi
80107ae1:	5d                   	pop    %ebp
80107ae2:	c3                   	ret    
80107ae3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ae7:	90                   	nop
      kfree(mem);
80107ae8:	83 ec 0c             	sub    $0xc,%esp
80107aeb:	53                   	push   %ebx
80107aec:	e8 0f ad ff ff       	call   80102800 <kfree>
      goto bad;
80107af1:	83 c4 10             	add    $0x10,%esp
80107af4:	eb cd                	jmp    80107ac3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	68 37 86 10 80       	push   $0x80108637
80107afe:	e8 8d 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107b03:	83 ec 0c             	sub    $0xc,%esp
80107b06:	68 1d 86 10 80       	push   $0x8010861d
80107b0b:	e8 80 88 ff ff       	call   80100390 <panic>

80107b10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b10:	f3 0f 1e fb          	endbr32 
80107b14:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b15:	31 c9                	xor    %ecx,%ecx
{
80107b17:	89 e5                	mov    %esp,%ebp
80107b19:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b22:	e8 49 f5 ff ff       	call   80107070 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b27:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b29:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b2a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b31:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b34:	05 00 00 00 80       	add    $0x80000000,%eax
80107b39:	83 fa 05             	cmp    $0x5,%edx
80107b3c:	ba 00 00 00 00       	mov    $0x0,%edx
80107b41:	0f 45 c2             	cmovne %edx,%eax
}
80107b44:	c3                   	ret    
80107b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b63:	85 f6                	test   %esi,%esi
80107b65:	75 3c                	jne    80107ba3 <copyout+0x53>
80107b67:	eb 67                	jmp    80107bd0 <copyout+0x80>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b70:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b73:	89 fb                	mov    %edi,%ebx
80107b75:	29 d3                	sub    %edx,%ebx
80107b77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b7d:	39 f3                	cmp    %esi,%ebx
80107b7f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b82:	29 fa                	sub    %edi,%edx
80107b84:	83 ec 04             	sub    $0x4,%esp
80107b87:	01 c2                	add    %eax,%edx
80107b89:	53                   	push   %ebx
80107b8a:	ff 75 10             	pushl  0x10(%ebp)
80107b8d:	52                   	push   %edx
80107b8e:	e8 0d d4 ff ff       	call   80104fa0 <memmove>
    len -= n;
    buf += n;
80107b93:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b96:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b9c:	83 c4 10             	add    $0x10,%esp
80107b9f:	29 de                	sub    %ebx,%esi
80107ba1:	74 2d                	je     80107bd0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107ba3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ba8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107bab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107bb1:	57                   	push   %edi
80107bb2:	ff 75 08             	pushl  0x8(%ebp)
80107bb5:	e8 56 ff ff ff       	call   80107b10 <uva2ka>
    if(pa0 == 0)
80107bba:	83 c4 10             	add    $0x10,%esp
80107bbd:	85 c0                	test   %eax,%eax
80107bbf:	75 af                	jne    80107b70 <copyout+0x20>
  }
  return 0;
}
80107bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bc9:	5b                   	pop    %ebx
80107bca:	5e                   	pop    %esi
80107bcb:	5f                   	pop    %edi
80107bcc:	5d                   	pop    %ebp
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax
80107bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bd3:	31 c0                	xor    %eax,%eax
}
80107bd5:	5b                   	pop    %ebx
80107bd6:	5e                   	pop    %esi
80107bd7:	5f                   	pop    %edi
80107bd8:	5d                   	pop    %ebp
80107bd9:	c3                   	ret    
