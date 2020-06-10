
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc e0 f5 10 80       	mov    $0x8010f5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 3a 10 80       	mov    $0x80103a20,%eax
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
80100048:	bb 14 f6 10 80       	mov    $0x8010f614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 91 10 80       	push   $0x801091a0
80100055:	68 e0 f5 10 80       	push   $0x8010f5e0
8010005a:	e8 51 52 00 00       	call   801052b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 3c 11 80       	mov    $0x80113cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 3d 11 80 dc 	movl   $0x80113cdc,0x80113d2c
8010006e:	3c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 3d 11 80 dc 	movl   $0x80113cdc,0x80113d30
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
8010008b:	c7 43 50 dc 3c 11 80 	movl   $0x80113cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 91 10 80       	push   $0x801091a7
80100097:	50                   	push   %eax
80100098:	e8 d3 50 00 00       	call   80105170 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 3d 11 80       	mov    0x80113d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 3d 11 80    	mov    %ebx,0x80113d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 3a 11 80    	cmp    $0x80113a80,%ebx
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
801000e3:	68 e0 f5 10 80       	push   $0x8010f5e0
801000e8:	e8 43 53 00 00       	call   80105430 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 3d 11 80    	mov    0x80113d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 3c 11 80    	cmp    $0x80113cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 3c 11 80    	cmp    $0x80113cdc,%ebx
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
80100120:	8b 1d 2c 3d 11 80    	mov    0x80113d2c,%ebx
80100126:	81 fb dc 3c 11 80    	cmp    $0x80113cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 3c 11 80    	cmp    $0x80113cdc,%ebx
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
8010015d:	68 e0 f5 10 80       	push   $0x8010f5e0
80100162:	e8 89 53 00 00       	call   801054f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 50 00 00       	call   801051b0 <acquiresleep>
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
8010018c:	e8 3f 28 00 00       	call   801029d0 <iderw>
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
801001a3:	68 ae 91 10 80       	push   $0x801091ae
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
801001c2:	e8 89 50 00 00       	call   80105250 <holdingsleep>
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
801001d8:	e9 f3 27 00 00       	jmp    801029d0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 91 10 80       	push   $0x801091bf
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
80100203:	e8 48 50 00 00       	call   80105250 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 4f 00 00       	call   80105210 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 f5 10 80 	movl   $0x8010f5e0,(%esp)
8010021f:	e8 0c 52 00 00       	call   80105430 <acquire>
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
80100246:	a1 30 3d 11 80       	mov    0x80113d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 3c 11 80 	movl   $0x80113cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 3d 11 80       	mov    0x80113d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 3d 11 80    	mov    %ebx,0x80113d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 f5 10 80 	movl   $0x8010f5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 52 00 00       	jmp    801054f0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 91 10 80       	push   $0x801091c6
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
801002a5:	e8 66 19 00 00       	call   80101c10 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
801002b1:	e8 7a 51 00 00       	call   80105430 <acquire>
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
801002c6:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
801002cb:	3b 05 c4 3f 11 80    	cmp    0x80113fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 d5 10 80       	push   $0x8010d520
801002e0:	68 c0 3f 11 80       	push   $0x80113fc0
801002e5:	e8 86 49 00 00       	call   80104c70 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 3f 11 80    	cmp    0x80113fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 71 41 00 00       	call   80104470 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 d5 10 80       	push   $0x8010d520
8010030e:	e8 dd 51 00 00       	call   801054f0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 14 18 00 00       	call   80101b30 <ilock>
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
80100333:	89 15 c0 3f 11 80    	mov    %edx,0x80113fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 3f 11 80 	movsbl -0x7feec0c0(%edx),%ecx
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
80100360:	68 20 d5 10 80       	push   $0x8010d520
80100365:	e8 86 51 00 00       	call   801054f0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 bd 17 00 00       	call   80101b30 <ilock>
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
80100386:	a3 c0 3f 11 80       	mov    %eax,0x80113fc0
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
8010039d:	c7 05 54 d5 10 80 00 	movl   $0x0,0x8010d554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ce 2e 00 00       	call   80103280 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 91 10 80       	push   $0x801091cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 40 9d 10 80 	movl   $0x80109d40,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 4e 00 00       	call   801052d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 91 10 80       	push   $0x801091e1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 d5 10 80 01 	movl   $0x1,0x8010d558
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
8010042a:	e8 e1 67 00 00       	call   80106c10 <uartputc>
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
80100515:	e8 f6 66 00 00       	call   80106c10 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ea 66 00 00       	call   80106c10 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 de 66 00 00       	call   80106c10 <uartputc>
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
80100561:	e8 7a 50 00 00       	call   801055e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 4f 00 00       	call   80105540 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 91 10 80       	push   $0x801091e5
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
801005c9:	0f b6 92 10 92 10 80 	movzbl -0x7fef6df0(%edx),%edx
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
80100603:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
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
80100653:	e8 b8 15 00 00       	call   80101c10 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010065f:	e8 cc 4d 00 00       	call   80105430 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
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
80100692:	68 20 d5 10 80       	push   $0x8010d520
80100697:	e8 54 4e 00 00       	call   801054f0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 8b 14 00 00       	call   80101b30 <ilock>

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
801006bd:	a1 54 d5 10 80       	mov    0x8010d554,%eax
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
801006ec:	8b 0d 58 d5 10 80    	mov    0x8010d558,%ecx
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
8010077d:	bb f8 91 10 80       	mov    $0x801091f8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
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
801007b8:	68 20 d5 10 80       	push   $0x8010d520
801007bd:	e8 6e 4c 00 00       	call   80105430 <acquire>
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
801007e0:	8b 3d 58 d5 10 80    	mov    0x8010d558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 d5 10 80    	mov    0x8010d558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 d5 10 80       	push   $0x8010d520
80100828:	e8 c3 4c 00 00       	call   801054f0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 91 10 80       	push   $0x801091ff
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
80100872:	68 20 d5 10 80       	push   $0x8010d520
80100877:	e8 b4 4b 00 00       	call   80105430 <acquire>
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
801008b4:	a1 c8 3f 11 80       	mov    0x80113fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 3f 11 80    	sub    0x80113fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 3f 11 80    	mov    %ecx,0x80113fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 3f 11 80    	mov    %bl,-0x7feec0c0(%eax)
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
80100908:	a1 c0 3f 11 80       	mov    0x80113fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 3f 11 80    	cmp    %eax,0x80113fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 3f 11 80       	mov    0x80113fc8,%eax
80100925:	39 05 c4 3f 11 80    	cmp    %eax,0x80113fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 3f 11 80 0a 	cmpb   $0xa,-0x7feec0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 d5 10 80    	mov    0x8010d558,%edx
        input.e--;
8010094c:	a3 c8 3f 11 80       	mov    %eax,0x80113fc8
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
8010096a:	a1 c8 3f 11 80       	mov    0x80113fc8,%eax
8010096f:	3b 05 c4 3f 11 80    	cmp    0x80113fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 3f 11 80       	mov    0x80113fc8,%eax
80100985:	3b 05 c4 3f 11 80    	cmp    0x80113fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 3f 11 80       	mov    %eax,0x80113fc8
  if(panicked){
80100999:	a1 58 d5 10 80       	mov    0x8010d558,%eax
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
801009ca:	68 20 d5 10 80       	push   $0x8010d520
801009cf:	e8 1c 4b 00 00       	call   801054f0 <release>
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
801009e3:	c6 80 40 3f 11 80 0a 	movb   $0xa,-0x7feec0c0(%eax)
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
801009ff:	e9 5c 46 00 00       	jmp    80105060 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 3f 11 80       	mov    0x80113fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 3f 11 80       	mov    %eax,0x80113fc4
          wakeup(&input.r);
80100a1b:	68 c0 3f 11 80       	push   $0x80113fc0
80100a20:	e8 8b 44 00 00       	call   80104eb0 <wakeup>
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
80100a3a:	68 08 92 10 80       	push   $0x80109208
80100a3f:	68 20 d5 10 80       	push   $0x8010d520
80100a44:	e8 67 48 00 00       	call   801052b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 4c 4d 11 80 40 	movl   $0x80100640,0x80114d4c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 48 4d 11 80 90 	movl   $0x80100290,0x80114d48
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 d5 10 80 01 	movl   $0x1,0x8010d554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 0e 21 00 00       	call   80102b80 <ioapicenable>
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
  // cprintf("exec now\n");
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a8e:	68 c0 01 00 00       	push   $0x1c0
80100a93:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a99:	50                   	push   %eax
80100a9a:	68 e0 3f 11 80       	push   $0x80113fe0
80100a9f:	e8 3c 4b 00 00       	call   801055e0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100aa4:	83 c4 0c             	add    $0xc,%esp
80100aa7:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100aad:	68 c0 01 00 00       	push   $0x1c0
80100ab2:	50                   	push   %eax
80100ab3:	68 c0 41 11 80       	push   $0x801141c0
80100ab8:	e8 23 4b 00 00       	call   801055e0 <memmove>
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
80100ac6:	a3 6c d5 10 80       	mov    %eax,0x8010d56c
  num_swap_backup = curproc->num_swap;
80100acb:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80100ad1:	a3 68 d5 10 80       	mov    %eax,0x8010d568
  free_head_backup = curproc->free_head;
80100ad6:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80100adc:	a3 60 d5 10 80       	mov    %eax,0x8010d560
  free_tail_backup = curproc->free_tail;
80100ae1:	8b 83 18 04 00 00    	mov    0x418(%ebx),%eax
80100ae7:	a3 5c d5 10 80       	mov    %eax,0x8010d55c
  swapfile_backup = curproc->swapFile;
80100aec:	8b 43 7c             	mov    0x7c(%ebx),%eax
80100aef:	a3 a0 41 11 80       	mov    %eax,0x801141a0
  queue_head_backup = curproc->queue_head;
80100af4:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80100afa:	a3 80 43 11 80       	mov    %eax,0x80114380
  queue_tail_backup = curproc->queue_tail;
80100aff:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80100b05:	a3 84 43 11 80       	mov    %eax,0x80114384
  clockhand_backup = curproc->clockHand;
80100b0a:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
}
80100b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  clockhand_backup = curproc->clockHand;
80100b13:	a3 64 d5 10 80       	mov    %eax,0x8010d564
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
80100b3c:	e8 ff 49 00 00       	call   80105540 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100b41:	83 c4 0c             	add    $0xc,%esp
80100b44:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100b4a:	68 c0 01 00 00       	push   $0x1c0
80100b4f:	6a 00                	push   $0x0
80100b51:	50                   	push   %eax
80100b52:	e8 e9 49 00 00       	call   80105540 <memset>
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
80100b95:	e8 26 23 00 00       	call   80102ec0 <kalloc>
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
80100bc2:	e8 f9 22 00 00       	call   80102ec0 <kalloc>
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
80100c47:	68 21 92 10 80       	push   $0x80109221
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
80100c6f:	e8 4c 1a 00 00       	call   801026c0 <createSwapFile>
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
80100cc7:	68 21 92 10 80       	push   $0x80109221
80100ccc:	e8 df f9 ff ff       	call   801006b0 <cprintf>
80100cd1:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	eb be                	jmp    80100c9a <allocate_fresh+0x3a>
    panic("exec: create swapfile for exec proc failed");
80100cdc:	83 ec 0c             	sub    $0xc,%esp
80100cdf:	68 50 92 10 80       	push   $0x80109250
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
80100d00:	e8 6b 37 00 00       	call   80104470 <myproc>
  
  if(curproc->pid > 2)
80100d05:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *curproc = myproc();
80100d09:	89 c6                	mov    %eax,%esi
  if(curproc->pid > 2)
80100d0b:	0f 8f 37 02 00 00    	jg     80100f48 <exec+0x258>
  {  
    backup(curproc);
    allocate_fresh(curproc);
  }

  begin_op();
80100d11:	e8 fa 29 00 00       	call   80103710 <begin_op>

  if((ip = namei(path)) == 0){
80100d16:	83 ec 0c             	sub    $0xc,%esp
80100d19:	ff 75 08             	pushl  0x8(%ebp)
80100d1c:	e8 df 16 00 00       	call   80102400 <namei>
80100d21:	83 c4 10             	add    $0x10,%esp
80100d24:	89 c3                	mov    %eax,%ebx
80100d26:	85 c0                	test   %eax,%eax
80100d28:	0f 84 37 04 00 00    	je     80101165 <exec+0x475>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d2e:	83 ec 0c             	sub    $0xc,%esp
80100d31:	50                   	push   %eax
80100d32:	e8 f9 0d 00 00       	call   80101b30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d37:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d3d:	6a 34                	push   $0x34
80100d3f:	6a 00                	push   $0x0
80100d41:	50                   	push   %eax
80100d42:	53                   	push   %ebx
80100d43:	e8 e8 10 00 00       	call   80101e30 <readi>
80100d48:	83 c4 20             	add    $0x20,%esp
80100d4b:	83 f8 34             	cmp    $0x34,%eax
80100d4e:	74 40                	je     80100d90 <exec+0xa0>
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  cprintf("exec: bad\n");
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	68 42 92 10 80       	push   $0x80109242
80100d58:	e8 53 f9 ff ff       	call   801006b0 <cprintf>
80100d5d:	83 c4 10             	add    $0x10,%esp
  if(pgdir)
    freevm(pgdir);
  /* restoring variables */
  if(curproc->pid > 2)
80100d60:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80100d64:	0f 8f 4c 01 00 00    	jg     80100eb6 <exec+0x1c6>

  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100d6a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  if(ip){
80100d6f:	85 db                	test   %ebx,%ebx
80100d71:	74 11                	je     80100d84 <exec+0x94>
    iunlockput(ip);
80100d73:	83 ec 0c             	sub    $0xc,%esp
80100d76:	53                   	push   %ebx
80100d77:	e8 54 10 00 00       	call   80101dd0 <iunlockput>
    end_op();
80100d7c:	e8 ff 29 00 00       	call   80103780 <end_op>
80100d81:	83 c4 10             	add    $0x10,%esp
}
80100d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d87:	89 f0                	mov    %esi,%eax
80100d89:	5b                   	pop    %ebx
80100d8a:	5e                   	pop    %esi
80100d8b:	5f                   	pop    %edi
80100d8c:	5d                   	pop    %ebp
80100d8d:	c3                   	ret    
80100d8e:	66 90                	xchg   %ax,%ax
  if(elf.magic != ELF_MAGIC)
80100d90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d97:	45 4c 46 
80100d9a:	75 b4                	jne    80100d50 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100d9c:	e8 3f 75 00 00       	call   801082e0 <setupkvm>
80100da1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100da7:	85 c0                	test   %eax,%eax
80100da9:	74 a5                	je     80100d50 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100db2:	00 
80100db3:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100db9:	0f 84 c5 03 00 00    	je     80101184 <exec+0x494>
80100dbf:	31 c0                	xor    %eax,%eax
80100dc1:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
  sz = 0;
80100dc7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100dce:	00 00 00 
80100dd1:	89 c6                	mov    %eax,%esi
80100dd3:	e9 96 00 00 00       	jmp    80100e6e <exec+0x17e>
80100dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ddf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100de0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100de7:	75 70                	jne    80100e59 <exec+0x169>
    if(ph.memsz < ph.filesz)
80100de9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100def:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100df5:	0f 82 8f 00 00 00    	jb     80100e8a <exec+0x19a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100dfb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e01:	0f 82 83 00 00 00    	jb     80100e8a <exec+0x19a>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e07:	83 ec 04             	sub    $0x4,%esp
80100e0a:	50                   	push   %eax
80100e0b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100e11:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e17:	e8 84 72 00 00       	call   801080a0 <allocuvm>
80100e1c:	83 c4 10             	add    $0x10,%esp
80100e1f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e25:	85 c0                	test   %eax,%eax
80100e27:	74 61                	je     80100e8a <exec+0x19a>
    if(ph.vaddr % PGSIZE != 0)
80100e29:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e34:	75 54                	jne    80100e8a <exec+0x19a>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e36:	83 ec 0c             	sub    $0xc,%esp
80100e39:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e3f:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e45:	53                   	push   %ebx
80100e46:	50                   	push   %eax
80100e47:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e4d:	e8 1e 6d 00 00       	call   80107b70 <loaduvm>
80100e52:	83 c4 20             	add    $0x20,%esp
80100e55:	85 c0                	test   %eax,%eax
80100e57:	78 31                	js     80100e8a <exec+0x19a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e59:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e60:	83 c6 01             	add    $0x1,%esi
80100e63:	83 c7 20             	add    $0x20,%edi
80100e66:	39 f0                	cmp    %esi,%eax
80100e68:	0f 8e fa 00 00 00    	jle    80100f68 <exec+0x278>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e6e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e74:	6a 20                	push   $0x20
80100e76:	57                   	push   %edi
80100e77:	50                   	push   %eax
80100e78:	53                   	push   %ebx
80100e79:	e8 b2 0f 00 00       	call   80101e30 <readi>
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	83 f8 20             	cmp    $0x20,%eax
80100e84:	0f 84 56 ff ff ff    	je     80100de0 <exec+0xf0>
80100e8a:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  cprintf("exec: bad\n");
80100e90:	83 ec 0c             	sub    $0xc,%esp
80100e93:	68 42 92 10 80       	push   $0x80109242
80100e98:	e8 13 f8 ff ff       	call   801006b0 <cprintf>
    freevm(pgdir);
80100e9d:	58                   	pop    %eax
80100e9e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ea4:	e8 87 73 00 00       	call   80108230 <freevm>
80100ea9:	83 c4 10             	add    $0x10,%esp
  if(curproc->pid > 2)
80100eac:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80100eb0:	0f 8e b4 fe ff ff    	jle    80100d6a <exec+0x7a>
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
80100eb6:	83 ec 04             	sub    $0x4,%esp
80100eb9:	8d 86 48 02 00 00    	lea    0x248(%esi),%eax
80100ebf:	68 c0 01 00 00       	push   $0x1c0
80100ec4:	68 e0 3f 11 80       	push   $0x80113fe0
80100ec9:	50                   	push   %eax
80100eca:	e8 11 47 00 00       	call   801055e0 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100ecf:	83 c4 0c             	add    $0xc,%esp
80100ed2:	8d 86 88 00 00 00    	lea    0x88(%esi),%eax
80100ed8:	68 c0 01 00 00       	push   $0x1c0
80100edd:	68 c0 41 11 80       	push   $0x801141c0
80100ee2:	50                   	push   %eax
80100ee3:	e8 f8 46 00 00       	call   801055e0 <memmove>
    curproc->free_head = free_head_backup;
80100ee8:	a1 60 d5 10 80       	mov    0x8010d560,%eax
    curproc->queue_tail = queue_tail_backup;
80100eed:	83 c4 10             	add    $0x10,%esp
    curproc->free_head = free_head_backup;
80100ef0:	89 86 14 04 00 00    	mov    %eax,0x414(%esi)
    curproc->free_tail = free_tail_backup;
80100ef6:	a1 5c d5 10 80       	mov    0x8010d55c,%eax
80100efb:	89 86 18 04 00 00    	mov    %eax,0x418(%esi)
    curproc->num_ram = num_ram_backup;
80100f01:	a1 6c d5 10 80       	mov    0x8010d56c,%eax
80100f06:	89 86 08 04 00 00    	mov    %eax,0x408(%esi)
    curproc->num_swap = num_swap_backup;
80100f0c:	a1 68 d5 10 80       	mov    0x8010d568,%eax
80100f11:	89 86 0c 04 00 00    	mov    %eax,0x40c(%esi)
    curproc->swapFile = swapfile_backup;
80100f17:	a1 a0 41 11 80       	mov    0x801141a0,%eax
80100f1c:	89 46 7c             	mov    %eax,0x7c(%esi)
    curproc->clockHand = clockhand_backup;
80100f1f:	a1 64 d5 10 80       	mov    0x8010d564,%eax
80100f24:	89 86 10 04 00 00    	mov    %eax,0x410(%esi)
    curproc->queue_head = queue_head_backup;
80100f2a:	a1 80 43 11 80       	mov    0x80114380,%eax
80100f2f:	89 86 1c 04 00 00    	mov    %eax,0x41c(%esi)
    curproc->queue_tail = queue_tail_backup;
80100f35:	a1 84 43 11 80       	mov    0x80114384,%eax
80100f3a:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
80100f40:	e9 25 fe ff ff       	jmp    80100d6a <exec+0x7a>
80100f45:	8d 76 00             	lea    0x0(%esi),%esi
    backup(curproc);
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	50                   	push   %eax
80100f4c:	e8 2f fb ff ff       	call   80100a80 <backup>
    allocate_fresh(curproc);
80100f51:	89 34 24             	mov    %esi,(%esp)
80100f54:	e8 07 fd ff ff       	call   80100c60 <allocate_fresh>
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	e9 b0 fd ff ff       	jmp    80100d11 <exec+0x21>
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f68:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f6e:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100f74:	05 ff 0f 00 00       	add    $0xfff,%eax
80100f79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f7e:	8d b8 00 20 00 00    	lea    0x2000(%eax),%edi
  iunlockput(ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f8d:	53                   	push   %ebx
80100f8e:	e8 3d 0e 00 00       	call   80101dd0 <iunlockput>
  end_op();
80100f93:	e8 e8 27 00 00       	call   80103780 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f98:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f9e:	83 c4 0c             	add    $0xc,%esp
80100fa1:	57                   	push   %edi
80100fa2:	50                   	push   %eax
80100fa3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fa9:	e8 f2 70 00 00       	call   801080a0 <allocuvm>
80100fae:	83 c4 10             	add    $0x10,%esp
80100fb1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100fb7:	85 c0                	test   %eax,%eax
80100fb9:	0f 84 9a 00 00 00    	je     80101059 <exec+0x369>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fbf:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100fc5:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100fc8:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fca:	8d 83 00 e0 ff ff    	lea    -0x2000(%ebx),%eax
80100fd0:	50                   	push   %eax
80100fd1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fd7:	e8 b4 73 00 00       	call   80108390 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdf:	83 c4 10             	add    $0x10,%esp
80100fe2:	8b 00                	mov    (%eax),%eax
80100fe4:	85 c0                	test   %eax,%eax
80100fe6:	0f 84 a4 01 00 00    	je     80101190 <exec+0x4a0>
80100fec:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ff2:	89 fe                	mov    %edi,%esi
80100ff4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100ffa:	eb 23                	jmp    8010101f <exec+0x32f>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101000:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101003:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
8010100a:	83 c6 01             	add    $0x1,%esi
    ustack[3+argc] = sp;
8010100d:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101013:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80101016:	85 c0                	test   %eax,%eax
80101018:	74 46                	je     80101060 <exec+0x370>
    if(argc >= MAXARG)
8010101a:	83 fe 20             	cmp    $0x20,%esi
8010101d:	74 34                	je     80101053 <exec+0x363>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	50                   	push   %eax
80101023:	e8 18 47 00 00       	call   80105740 <strlen>
80101028:	f7 d0                	not    %eax
8010102a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010102c:	58                   	pop    %eax
8010102d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101030:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101033:	ff 34 b0             	pushl  (%eax,%esi,4)
80101036:	e8 05 47 00 00       	call   80105740 <strlen>
8010103b:	83 c0 01             	add    $0x1,%eax
8010103e:	50                   	push   %eax
8010103f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101042:	ff 34 b0             	pushl  (%eax,%esi,4)
80101045:	53                   	push   %ebx
80101046:	57                   	push   %edi
80101047:	e8 04 7b 00 00       	call   80108b50 <copyout>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	85 c0                	test   %eax,%eax
80101051:	79 ad                	jns    80101000 <exec+0x310>
80101053:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ip = 0;
80101059:	31 db                	xor    %ebx,%ebx
8010105b:	e9 30 fe ff ff       	jmp    80100e90 <exec+0x1a0>
80101060:	89 f7                	mov    %esi,%edi
80101062:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101068:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
8010106f:	89 da                	mov    %ebx,%edx
  ustack[3+argc] = 0;
80101071:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101078:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107c:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
8010107e:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101081:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101087:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101089:	50                   	push   %eax
8010108a:	51                   	push   %ecx
8010108b:	53                   	push   %ebx
8010108c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101092:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101099:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010109c:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010a2:	e8 a9 7a 00 00       	call   80108b50 <copyout>
801010a7:	83 c4 10             	add    $0x10,%esp
801010aa:	85 c0                	test   %eax,%eax
801010ac:	78 ab                	js     80101059 <exec+0x369>
  for(last=s=path; *s; s++)
801010ae:	8b 45 08             	mov    0x8(%ebp),%eax
801010b1:	8b 55 08             	mov    0x8(%ebp),%edx
801010b4:	0f b6 00             	movzbl (%eax),%eax
801010b7:	84 c0                	test   %al,%al
801010b9:	74 14                	je     801010cf <exec+0x3df>
801010bb:	89 d1                	mov    %edx,%ecx
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
801010c0:	83 c1 01             	add    $0x1,%ecx
801010c3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010c5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801010c8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801010cb:	84 c0                	test   %al,%al
801010cd:	75 f1                	jne    801010c0 <exec+0x3d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010cf:	83 ec 04             	sub    $0x4,%esp
801010d2:	8d 46 6c             	lea    0x6c(%esi),%eax
801010d5:	6a 10                	push   $0x10
801010d7:	52                   	push   %edx
801010d8:	50                   	push   %eax
801010d9:	e8 22 46 00 00       	call   80105700 <safestrcpy>
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
801010de:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
801010e4:	8d 86 88 00 00 00    	lea    0x88(%esi),%eax
801010ea:	83 c4 10             	add    $0x10,%esp
801010ed:	8d 96 48 02 00 00    	lea    0x248(%esi),%edx
801010f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010f7:	90                   	nop
    if(curproc->ramPages[ind].isused)
801010f8:	8b b8 c4 01 00 00    	mov    0x1c4(%eax),%edi
801010fe:	85 ff                	test   %edi,%edi
80101100:	74 06                	je     80101108 <exec+0x418>
      curproc->ramPages[ind].pgdir = pgdir;
80101102:	89 88 c0 01 00 00    	mov    %ecx,0x1c0(%eax)
    if(curproc->swappedPages[ind].isused)
80101108:	8b 78 04             	mov    0x4(%eax),%edi
8010110b:	85 ff                	test   %edi,%edi
8010110d:	74 02                	je     80101111 <exec+0x421>
      curproc->swappedPages[ind].pgdir = pgdir;
8010110f:	89 08                	mov    %ecx,(%eax)
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
80101111:	83 c0 1c             	add    $0x1c,%eax
80101114:	39 d0                	cmp    %edx,%eax
80101116:	75 e0                	jne    801010f8 <exec+0x408>
  oldpgdir = curproc->pgdir;
80101118:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->tf->eip = elf.entry;  // main
8010111b:	8b 56 18             	mov    0x18(%esi),%edx
  switchuvm(curproc);
8010111e:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80101121:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80101127:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
8010112d:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80101130:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80101136:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80101138:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
8010113e:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80101141:	8b 56 18             	mov    0x18(%esi),%edx
80101144:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
80101147:	56                   	push   %esi
  return 0;
80101148:	31 f6                	xor    %esi,%esi
  switchuvm(curproc);
8010114a:	e8 91 68 00 00       	call   801079e0 <switchuvm>
  freevm(oldpgdir);
8010114f:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 d3 70 00 00       	call   80108230 <freevm>
  return 0;
8010115d:	83 c4 10             	add    $0x10,%esp
80101160:	e9 1f fc ff ff       	jmp    80100d84 <exec+0x94>
    end_op();
80101165:	e8 16 26 00 00       	call   80103780 <end_op>
    cprintf("exec: fail\n");
8010116a:	83 ec 0c             	sub    $0xc,%esp
    return -1;
8010116d:	be ff ff ff ff       	mov    $0xffffffff,%esi
    cprintf("exec: fail\n");
80101172:	68 36 92 10 80       	push   $0x80109236
80101177:	e8 34 f5 ff ff       	call   801006b0 <cprintf>
    return -1;
8010117c:	83 c4 10             	add    $0x10,%esp
8010117f:	e9 00 fc ff ff       	jmp    80100d84 <exec+0x94>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101184:	31 c0                	xor    %eax,%eax
80101186:	bf 00 20 00 00       	mov    $0x2000,%edi
8010118b:	e9 f4 fd ff ff       	jmp    80100f84 <exec+0x294>
  for(argc = 0; argv[argc]; argc++) {
80101190:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101196:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010119c:	e9 c7 fe ff ff       	jmp    80101068 <exec+0x378>
801011a1:	66 90                	xchg   %ax,%ax
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011b0:	f3 0f 1e fb          	endbr32 
801011b4:	55                   	push   %ebp
801011b5:	89 e5                	mov    %esp,%ebp
801011b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011ba:	68 7b 92 10 80       	push   $0x8010927b
801011bf:	68 a0 43 11 80       	push   $0x801143a0
801011c4:	e8 e7 40 00 00       	call   801052b0 <initlock>
}
801011c9:	83 c4 10             	add    $0x10,%esp
801011cc:	c9                   	leave  
801011cd:	c3                   	ret    
801011ce:	66 90                	xchg   %ax,%ax

801011d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011d0:	f3 0f 1e fb          	endbr32 
801011d4:	55                   	push   %ebp
801011d5:	89 e5                	mov    %esp,%ebp
801011d7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d8:	bb d4 43 11 80       	mov    $0x801143d4,%ebx
{
801011dd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011e0:	68 a0 43 11 80       	push   $0x801143a0
801011e5:	e8 46 42 00 00       	call   80105430 <acquire>
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	eb 0c                	jmp    801011fb <filealloc+0x2b>
801011ef:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011f0:	83 c3 18             	add    $0x18,%ebx
801011f3:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
801011f9:	74 25                	je     80101220 <filealloc+0x50>
    if(f->ref == 0){
801011fb:	8b 43 04             	mov    0x4(%ebx),%eax
801011fe:	85 c0                	test   %eax,%eax
80101200:	75 ee                	jne    801011f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101202:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101205:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010120c:	68 a0 43 11 80       	push   $0x801143a0
80101211:	e8 da 42 00 00       	call   801054f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101216:	89 d8                	mov    %ebx,%eax
      return f;
80101218:	83 c4 10             	add    $0x10,%esp
}
8010121b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010121e:	c9                   	leave  
8010121f:	c3                   	ret    
  release(&ftable.lock);
80101220:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101223:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101225:	68 a0 43 11 80       	push   $0x801143a0
8010122a:	e8 c1 42 00 00       	call   801054f0 <release>
}
8010122f:	89 d8                	mov    %ebx,%eax
  return 0;
80101231:	83 c4 10             	add    $0x10,%esp
}
80101234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101237:	c9                   	leave  
80101238:	c3                   	ret    
80101239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101240 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101240:	f3 0f 1e fb          	endbr32 
80101244:	55                   	push   %ebp
80101245:	89 e5                	mov    %esp,%ebp
80101247:	53                   	push   %ebx
80101248:	83 ec 10             	sub    $0x10,%esp
8010124b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010124e:	68 a0 43 11 80       	push   $0x801143a0
80101253:	e8 d8 41 00 00       	call   80105430 <acquire>
  if(f->ref < 1)
80101258:	8b 43 04             	mov    0x4(%ebx),%eax
8010125b:	83 c4 10             	add    $0x10,%esp
8010125e:	85 c0                	test   %eax,%eax
80101260:	7e 1a                	jle    8010127c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101262:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101265:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101268:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010126b:	68 a0 43 11 80       	push   $0x801143a0
80101270:	e8 7b 42 00 00       	call   801054f0 <release>
  return f;
}
80101275:	89 d8                	mov    %ebx,%eax
80101277:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010127a:	c9                   	leave  
8010127b:	c3                   	ret    
    panic("filedup");
8010127c:	83 ec 0c             	sub    $0xc,%esp
8010127f:	68 82 92 10 80       	push   $0x80109282
80101284:	e8 07 f1 ff ff       	call   80100390 <panic>
80101289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101290 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101290:	f3 0f 1e fb          	endbr32 
80101294:	55                   	push   %ebp
80101295:	89 e5                	mov    %esp,%ebp
80101297:	57                   	push   %edi
80101298:	56                   	push   %esi
80101299:	53                   	push   %ebx
8010129a:	83 ec 28             	sub    $0x28,%esp
8010129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801012a0:	68 a0 43 11 80       	push   $0x801143a0
801012a5:	e8 86 41 00 00       	call   80105430 <acquire>
  if(f->ref < 1)
801012aa:	8b 53 04             	mov    0x4(%ebx),%edx
801012ad:	83 c4 10             	add    $0x10,%esp
801012b0:	85 d2                	test   %edx,%edx
801012b2:	0f 8e a1 00 00 00    	jle    80101359 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801012b8:	83 ea 01             	sub    $0x1,%edx
801012bb:	89 53 04             	mov    %edx,0x4(%ebx)
801012be:	75 40                	jne    80101300 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012c0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012c4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012c7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801012c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012cf:	8b 73 0c             	mov    0xc(%ebx),%esi
801012d2:	88 45 e7             	mov    %al,-0x19(%ebp)
801012d5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012d8:	68 a0 43 11 80       	push   $0x801143a0
  ff = *f;
801012dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012e0:	e8 0b 42 00 00       	call   801054f0 <release>

  if(ff.type == FD_PIPE)
801012e5:	83 c4 10             	add    $0x10,%esp
801012e8:	83 ff 01             	cmp    $0x1,%edi
801012eb:	74 53                	je     80101340 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012ed:	83 ff 02             	cmp    $0x2,%edi
801012f0:	74 26                	je     80101318 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f5:	5b                   	pop    %ebx
801012f6:	5e                   	pop    %esi
801012f7:	5f                   	pop    %edi
801012f8:	5d                   	pop    %ebp
801012f9:	c3                   	ret    
801012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101300:	c7 45 08 a0 43 11 80 	movl   $0x801143a0,0x8(%ebp)
}
80101307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010130e:	e9 dd 41 00 00       	jmp    801054f0 <release>
80101313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101317:	90                   	nop
    begin_op();
80101318:	e8 f3 23 00 00       	call   80103710 <begin_op>
    iput(ff.ip);
8010131d:	83 ec 0c             	sub    $0xc,%esp
80101320:	ff 75 e0             	pushl  -0x20(%ebp)
80101323:	e8 38 09 00 00       	call   80101c60 <iput>
    end_op();
80101328:	83 c4 10             	add    $0x10,%esp
}
8010132b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132e:	5b                   	pop    %ebx
8010132f:	5e                   	pop    %esi
80101330:	5f                   	pop    %edi
80101331:	5d                   	pop    %ebp
    end_op();
80101332:	e9 49 24 00 00       	jmp    80103780 <end_op>
80101337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101340:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101344:	83 ec 08             	sub    $0x8,%esp
80101347:	53                   	push   %ebx
80101348:	56                   	push   %esi
80101349:	e8 92 2b 00 00       	call   80103ee0 <pipeclose>
8010134e:	83 c4 10             	add    $0x10,%esp
}
80101351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101354:	5b                   	pop    %ebx
80101355:	5e                   	pop    %esi
80101356:	5f                   	pop    %edi
80101357:	5d                   	pop    %ebp
80101358:	c3                   	ret    
    panic("fileclose");
80101359:	83 ec 0c             	sub    $0xc,%esp
8010135c:	68 8a 92 10 80       	push   $0x8010928a
80101361:	e8 2a f0 ff ff       	call   80100390 <panic>
80101366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136d:	8d 76 00             	lea    0x0(%esi),%esi

80101370 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101370:	f3 0f 1e fb          	endbr32 
80101374:	55                   	push   %ebp
80101375:	89 e5                	mov    %esp,%ebp
80101377:	53                   	push   %ebx
80101378:	83 ec 04             	sub    $0x4,%esp
8010137b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010137e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101381:	75 2d                	jne    801013b0 <filestat+0x40>
    ilock(f->ip);
80101383:	83 ec 0c             	sub    $0xc,%esp
80101386:	ff 73 10             	pushl  0x10(%ebx)
80101389:	e8 a2 07 00 00       	call   80101b30 <ilock>
    stati(f->ip, st);
8010138e:	58                   	pop    %eax
8010138f:	5a                   	pop    %edx
80101390:	ff 75 0c             	pushl  0xc(%ebp)
80101393:	ff 73 10             	pushl  0x10(%ebx)
80101396:	e8 65 0a 00 00       	call   80101e00 <stati>
    iunlock(f->ip);
8010139b:	59                   	pop    %ecx
8010139c:	ff 73 10             	pushl  0x10(%ebx)
8010139f:	e8 6c 08 00 00       	call   80101c10 <iunlock>
    return 0;
  }
  return -1;
}
801013a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801013a7:	83 c4 10             	add    $0x10,%esp
801013aa:	31 c0                	xor    %eax,%eax
}
801013ac:	c9                   	leave  
801013ad:	c3                   	ret    
801013ae:	66 90                	xchg   %ax,%ax
801013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801013b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013b8:	c9                   	leave  
801013b9:	c3                   	ret    
801013ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801013c0:	f3 0f 1e fb          	endbr32 
801013c4:	55                   	push   %ebp
801013c5:	89 e5                	mov    %esp,%ebp
801013c7:	57                   	push   %edi
801013c8:	56                   	push   %esi
801013c9:	53                   	push   %ebx
801013ca:	83 ec 0c             	sub    $0xc,%esp
801013cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013d0:	8b 75 0c             	mov    0xc(%ebp),%esi
801013d3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013d6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013da:	74 64                	je     80101440 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801013dc:	8b 03                	mov    (%ebx),%eax
801013de:	83 f8 01             	cmp    $0x1,%eax
801013e1:	74 45                	je     80101428 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013e3:	83 f8 02             	cmp    $0x2,%eax
801013e6:	75 5f                	jne    80101447 <fileread+0x87>
    ilock(f->ip);
801013e8:	83 ec 0c             	sub    $0xc,%esp
801013eb:	ff 73 10             	pushl  0x10(%ebx)
801013ee:	e8 3d 07 00 00       	call   80101b30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013f3:	57                   	push   %edi
801013f4:	ff 73 14             	pushl  0x14(%ebx)
801013f7:	56                   	push   %esi
801013f8:	ff 73 10             	pushl  0x10(%ebx)
801013fb:	e8 30 0a 00 00       	call   80101e30 <readi>
80101400:	83 c4 20             	add    $0x20,%esp
80101403:	89 c6                	mov    %eax,%esi
80101405:	85 c0                	test   %eax,%eax
80101407:	7e 03                	jle    8010140c <fileread+0x4c>
      f->off += r;
80101409:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010140c:	83 ec 0c             	sub    $0xc,%esp
8010140f:	ff 73 10             	pushl  0x10(%ebx)
80101412:	e8 f9 07 00 00       	call   80101c10 <iunlock>
    return r;
80101417:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141d:	89 f0                	mov    %esi,%eax
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5f                   	pop    %edi
80101422:	5d                   	pop    %ebp
80101423:	c3                   	ret    
80101424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101428:	8b 43 0c             	mov    0xc(%ebx),%eax
8010142b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010142e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101431:	5b                   	pop    %ebx
80101432:	5e                   	pop    %esi
80101433:	5f                   	pop    %edi
80101434:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101435:	e9 46 2c 00 00       	jmp    80104080 <piperead>
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101440:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101445:	eb d3                	jmp    8010141a <fileread+0x5a>
  panic("fileread");
80101447:	83 ec 0c             	sub    $0xc,%esp
8010144a:	68 94 92 10 80       	push   $0x80109294
8010144f:	e8 3c ef ff ff       	call   80100390 <panic>
80101454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010145f:	90                   	nop

80101460 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101460:	f3 0f 1e fb          	endbr32 
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	57                   	push   %edi
80101468:	56                   	push   %esi
80101469:	53                   	push   %ebx
8010146a:	83 ec 1c             	sub    $0x1c,%esp
8010146d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101470:	8b 75 08             	mov    0x8(%ebp),%esi
80101473:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101476:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101479:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010147d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101480:	0f 84 c1 00 00 00    	je     80101547 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101486:	8b 06                	mov    (%esi),%eax
80101488:	83 f8 01             	cmp    $0x1,%eax
8010148b:	0f 84 c3 00 00 00    	je     80101554 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101491:	83 f8 02             	cmp    $0x2,%eax
80101494:	0f 85 cc 00 00 00    	jne    80101566 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010149a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010149d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010149f:	85 c0                	test   %eax,%eax
801014a1:	7f 34                	jg     801014d7 <filewrite+0x77>
801014a3:	e9 98 00 00 00       	jmp    80101540 <filewrite+0xe0>
801014a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014af:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801014b0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801014b3:	83 ec 0c             	sub    $0xc,%esp
801014b6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801014b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801014bc:	e8 4f 07 00 00       	call   80101c10 <iunlock>
      end_op();
801014c1:	e8 ba 22 00 00       	call   80103780 <end_op>
      if(r < 0)
        break;
      if(r != n1)
801014c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014c9:	83 c4 10             	add    $0x10,%esp
801014cc:	39 c3                	cmp    %eax,%ebx
801014ce:	75 60                	jne    80101530 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801014d0:	01 df                	add    %ebx,%edi
    while(i < n){
801014d2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014d5:	7e 69                	jle    80101540 <filewrite+0xe0>
      int n1 = n - i;
801014d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801014da:	b8 00 06 00 00       	mov    $0x600,%eax
801014df:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801014e1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801014e7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801014ea:	e8 21 22 00 00       	call   80103710 <begin_op>
      ilock(f->ip);
801014ef:	83 ec 0c             	sub    $0xc,%esp
801014f2:	ff 76 10             	pushl  0x10(%esi)
801014f5:	e8 36 06 00 00       	call   80101b30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014fd:	53                   	push   %ebx
801014fe:	ff 76 14             	pushl  0x14(%esi)
80101501:	01 f8                	add    %edi,%eax
80101503:	50                   	push   %eax
80101504:	ff 76 10             	pushl  0x10(%esi)
80101507:	e8 24 0a 00 00       	call   80101f30 <writei>
8010150c:	83 c4 20             	add    $0x20,%esp
8010150f:	85 c0                	test   %eax,%eax
80101511:	7f 9d                	jg     801014b0 <filewrite+0x50>
      iunlock(f->ip);
80101513:	83 ec 0c             	sub    $0xc,%esp
80101516:	ff 76 10             	pushl  0x10(%esi)
80101519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010151c:	e8 ef 06 00 00       	call   80101c10 <iunlock>
      end_op();
80101521:	e8 5a 22 00 00       	call   80103780 <end_op>
      if(r < 0)
80101526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101529:	83 c4 10             	add    $0x10,%esp
8010152c:	85 c0                	test   %eax,%eax
8010152e:	75 17                	jne    80101547 <filewrite+0xe7>
        panic("short filewrite");
80101530:	83 ec 0c             	sub    $0xc,%esp
80101533:	68 9d 92 10 80       	push   $0x8010929d
80101538:	e8 53 ee ff ff       	call   80100390 <panic>
8010153d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101540:	89 f8                	mov    %edi,%eax
80101542:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101545:	74 05                	je     8010154c <filewrite+0xec>
80101547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010154c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5f                   	pop    %edi
80101552:	5d                   	pop    %ebp
80101553:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101554:	8b 46 0c             	mov    0xc(%esi),%eax
80101557:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010155a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155d:	5b                   	pop    %ebx
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101561:	e9 1a 2a 00 00       	jmp    80103f80 <pipewrite>
  panic("filewrite");
80101566:	83 ec 0c             	sub    $0xc,%esp
80101569:	68 a3 92 10 80       	push   $0x801092a3
8010156e:	e8 1d ee ff ff       	call   80100390 <panic>
80101573:	66 90                	xchg   %ax,%ax
80101575:	66 90                	xchg   %ax,%ax
80101577:	66 90                	xchg   %ax,%ax
80101579:	66 90                	xchg   %ax,%ax
8010157b:	66 90                	xchg   %ax,%ax
8010157d:	66 90                	xchg   %ax,%ax
8010157f:	90                   	nop

80101580 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101580:	55                   	push   %ebp
80101581:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101583:	89 d0                	mov    %edx,%eax
80101585:	c1 e8 0c             	shr    $0xc,%eax
80101588:	03 05 b8 4d 11 80    	add    0x80114db8,%eax
{
8010158e:	89 e5                	mov    %esp,%ebp
80101590:	56                   	push   %esi
80101591:	53                   	push   %ebx
80101592:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101594:	83 ec 08             	sub    $0x8,%esp
80101597:	50                   	push   %eax
80101598:	51                   	push   %ecx
80101599:	e8 32 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010159e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015a0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801015a3:	ba 01 00 00 00       	mov    $0x1,%edx
801015a8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801015ab:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801015b1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801015b4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801015b6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801015bb:	85 d1                	test   %edx,%ecx
801015bd:	74 25                	je     801015e4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015bf:	f7 d2                	not    %edx
  log_write(bp);
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801015c6:	21 ca                	and    %ecx,%edx
801015c8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801015cc:	50                   	push   %eax
801015cd:	e8 1e 23 00 00       	call   801038f0 <log_write>
  brelse(bp);
801015d2:	89 34 24             	mov    %esi,(%esp)
801015d5:	e8 16 ec ff ff       	call   801001f0 <brelse>
}
801015da:	83 c4 10             	add    $0x10,%esp
801015dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e0:	5b                   	pop    %ebx
801015e1:	5e                   	pop    %esi
801015e2:	5d                   	pop    %ebp
801015e3:	c3                   	ret    
    panic("freeing free block");
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	68 ad 92 10 80       	push   $0x801092ad
801015ec:	e8 9f ed ff ff       	call   80100390 <panic>
801015f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ff:	90                   	nop

80101600 <balloc>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101609:	8b 0d a0 4d 11 80    	mov    0x80114da0,%ecx
{
8010160f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101612:	85 c9                	test   %ecx,%ecx
80101614:	0f 84 87 00 00 00    	je     801016a1 <balloc+0xa1>
8010161a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101621:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101624:	83 ec 08             	sub    $0x8,%esp
80101627:	89 f0                	mov    %esi,%eax
80101629:	c1 f8 0c             	sar    $0xc,%eax
8010162c:	03 05 b8 4d 11 80    	add    0x80114db8,%eax
80101632:	50                   	push   %eax
80101633:	ff 75 d8             	pushl  -0x28(%ebp)
80101636:	e8 95 ea ff ff       	call   801000d0 <bread>
8010163b:	83 c4 10             	add    $0x10,%esp
8010163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101641:	a1 a0 4d 11 80       	mov    0x80114da0,%eax
80101646:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101649:	31 c0                	xor    %eax,%eax
8010164b:	eb 2f                	jmp    8010167c <balloc+0x7c>
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101650:	89 c1                	mov    %eax,%ecx
80101652:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101657:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010165a:	83 e1 07             	and    $0x7,%ecx
8010165d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010165f:	89 c1                	mov    %eax,%ecx
80101661:	c1 f9 03             	sar    $0x3,%ecx
80101664:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101669:	89 fa                	mov    %edi,%edx
8010166b:	85 df                	test   %ebx,%edi
8010166d:	74 41                	je     801016b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010166f:	83 c0 01             	add    $0x1,%eax
80101672:	83 c6 01             	add    $0x1,%esi
80101675:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010167a:	74 05                	je     80101681 <balloc+0x81>
8010167c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010167f:	77 cf                	ja     80101650 <balloc+0x50>
    brelse(bp);
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	ff 75 e4             	pushl  -0x1c(%ebp)
80101687:	e8 64 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010168c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101693:	83 c4 10             	add    $0x10,%esp
80101696:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101699:	39 05 a0 4d 11 80    	cmp    %eax,0x80114da0
8010169f:	77 80                	ja     80101621 <balloc+0x21>
  panic("balloc: out of blocks");
801016a1:	83 ec 0c             	sub    $0xc,%esp
801016a4:	68 c0 92 10 80       	push   $0x801092c0
801016a9:	e8 e2 ec ff ff       	call   80100390 <panic>
801016ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801016b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801016b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801016b6:	09 da                	or     %ebx,%edx
801016b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801016bc:	57                   	push   %edi
801016bd:	e8 2e 22 00 00       	call   801038f0 <log_write>
        brelse(bp);
801016c2:	89 3c 24             	mov    %edi,(%esp)
801016c5:	e8 26 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016ca:	58                   	pop    %eax
801016cb:	5a                   	pop    %edx
801016cc:	56                   	push   %esi
801016cd:	ff 75 d8             	pushl  -0x28(%ebp)
801016d0:	e8 fb e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016da:	8d 40 5c             	lea    0x5c(%eax),%eax
801016dd:	68 00 02 00 00       	push   $0x200
801016e2:	6a 00                	push   $0x0
801016e4:	50                   	push   %eax
801016e5:	e8 56 3e 00 00       	call   80105540 <memset>
  log_write(bp);
801016ea:	89 1c 24             	mov    %ebx,(%esp)
801016ed:	e8 fe 21 00 00       	call   801038f0 <log_write>
  brelse(bp);
801016f2:	89 1c 24             	mov    %ebx,(%esp)
801016f5:	e8 f6 ea ff ff       	call   801001f0 <brelse>
}
801016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fd:	89 f0                	mov    %esi,%eax
801016ff:	5b                   	pop    %ebx
80101700:	5e                   	pop    %esi
80101701:	5f                   	pop    %edi
80101702:	5d                   	pop    %ebp
80101703:	c3                   	ret    
80101704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	89 c7                	mov    %eax,%edi
80101716:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101717:	31 f6                	xor    %esi,%esi
{
80101719:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010171a:	bb f4 4d 11 80       	mov    $0x80114df4,%ebx
{
8010171f:	83 ec 28             	sub    $0x28,%esp
80101722:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101725:	68 c0 4d 11 80       	push   $0x80114dc0
8010172a:	e8 01 3d 00 00       	call   80105430 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010172f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101732:	83 c4 10             	add    $0x10,%esp
80101735:	eb 1b                	jmp    80101752 <iget+0x42>
80101737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101740:	39 3b                	cmp    %edi,(%ebx)
80101742:	74 6c                	je     801017b0 <iget+0xa0>
80101744:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010174a:	81 fb 14 6a 11 80    	cmp    $0x80116a14,%ebx
80101750:	73 26                	jae    80101778 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101752:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101755:	85 c9                	test   %ecx,%ecx
80101757:	7f e7                	jg     80101740 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101759:	85 f6                	test   %esi,%esi
8010175b:	75 e7                	jne    80101744 <iget+0x34>
8010175d:	89 d8                	mov    %ebx,%eax
8010175f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101765:	85 c9                	test   %ecx,%ecx
80101767:	75 6e                	jne    801017d7 <iget+0xc7>
80101769:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010176b:	81 fb 14 6a 11 80    	cmp    $0x80116a14,%ebx
80101771:	72 df                	jb     80101752 <iget+0x42>
80101773:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101777:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101778:	85 f6                	test   %esi,%esi
8010177a:	74 73                	je     801017ef <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010177c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010177f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101781:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101784:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010178b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101792:	68 c0 4d 11 80       	push   $0x80114dc0
80101797:	e8 54 3d 00 00       	call   801054f0 <release>

  return ip;
8010179c:	83 c4 10             	add    $0x10,%esp
}
8010179f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a2:	89 f0                	mov    %esi,%eax
801017a4:	5b                   	pop    %ebx
801017a5:	5e                   	pop    %esi
801017a6:	5f                   	pop    %edi
801017a7:	5d                   	pop    %ebp
801017a8:	c3                   	ret    
801017a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801017b3:	75 8f                	jne    80101744 <iget+0x34>
      release(&icache.lock);
801017b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801017b8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801017bb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801017bd:	68 c0 4d 11 80       	push   $0x80114dc0
      ip->ref++;
801017c2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801017c5:	e8 26 3d 00 00       	call   801054f0 <release>
      return ip;
801017ca:	83 c4 10             	add    $0x10,%esp
}
801017cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d0:	89 f0                	mov    %esi,%eax
801017d2:	5b                   	pop    %ebx
801017d3:	5e                   	pop    %esi
801017d4:	5f                   	pop    %edi
801017d5:	5d                   	pop    %ebp
801017d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017d7:	81 fb 14 6a 11 80    	cmp    $0x80116a14,%ebx
801017dd:	73 10                	jae    801017ef <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017df:	8b 4b 08             	mov    0x8(%ebx),%ecx
801017e2:	85 c9                	test   %ecx,%ecx
801017e4:	0f 8f 56 ff ff ff    	jg     80101740 <iget+0x30>
801017ea:	e9 6e ff ff ff       	jmp    8010175d <iget+0x4d>
    panic("iget: no inodes");
801017ef:	83 ec 0c             	sub    $0xc,%esp
801017f2:	68 d6 92 10 80       	push   $0x801092d6
801017f7:	e8 94 eb ff ff       	call   80100390 <panic>
801017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101800 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	89 c6                	mov    %eax,%esi
80101807:	53                   	push   %ebx
80101808:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010180b:	83 fa 0b             	cmp    $0xb,%edx
8010180e:	0f 86 84 00 00 00    	jbe    80101898 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101814:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101817:	83 fb 7f             	cmp    $0x7f,%ebx
8010181a:	0f 87 98 00 00 00    	ja     801018b8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101820:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101826:	8b 16                	mov    (%esi),%edx
80101828:	85 c0                	test   %eax,%eax
8010182a:	74 54                	je     80101880 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010182c:	83 ec 08             	sub    $0x8,%esp
8010182f:	50                   	push   %eax
80101830:	52                   	push   %edx
80101831:	e8 9a e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101836:	83 c4 10             	add    $0x10,%esp
80101839:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010183d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010183f:	8b 1a                	mov    (%edx),%ebx
80101841:	85 db                	test   %ebx,%ebx
80101843:	74 1b                	je     80101860 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101845:	83 ec 0c             	sub    $0xc,%esp
80101848:	57                   	push   %edi
80101849:	e8 a2 e9 ff ff       	call   801001f0 <brelse>
    return addr;
8010184e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101854:	89 d8                	mov    %ebx,%eax
80101856:	5b                   	pop    %ebx
80101857:	5e                   	pop    %esi
80101858:	5f                   	pop    %edi
80101859:	5d                   	pop    %ebp
8010185a:	c3                   	ret    
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101860:	8b 06                	mov    (%esi),%eax
80101862:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101865:	e8 96 fd ff ff       	call   80101600 <balloc>
8010186a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010186d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101870:	89 c3                	mov    %eax,%ebx
80101872:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101874:	57                   	push   %edi
80101875:	e8 76 20 00 00       	call   801038f0 <log_write>
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	eb c6                	jmp    80101845 <bmap+0x45>
8010187f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101880:	89 d0                	mov    %edx,%eax
80101882:	e8 79 fd ff ff       	call   80101600 <balloc>
80101887:	8b 16                	mov    (%esi),%edx
80101889:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010188f:	eb 9b                	jmp    8010182c <bmap+0x2c>
80101891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101898:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010189b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010189e:	85 db                	test   %ebx,%ebx
801018a0:	75 af                	jne    80101851 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801018a2:	8b 00                	mov    (%eax),%eax
801018a4:	e8 57 fd ff ff       	call   80101600 <balloc>
801018a9:	89 47 5c             	mov    %eax,0x5c(%edi)
801018ac:	89 c3                	mov    %eax,%ebx
}
801018ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	5b                   	pop    %ebx
801018b4:	5e                   	pop    %esi
801018b5:	5f                   	pop    %edi
801018b6:	5d                   	pop    %ebp
801018b7:	c3                   	ret    
  panic("bmap: out of range");
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 e6 92 10 80       	push   $0x801092e6
801018c0:	e8 cb ea ff ff       	call   80100390 <panic>
801018c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <readsb>:
{
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	56                   	push   %esi
801018d8:	53                   	push   %ebx
801018d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018dc:	83 ec 08             	sub    $0x8,%esp
801018df:	6a 01                	push   $0x1
801018e1:	ff 75 08             	pushl  0x8(%ebp)
801018e4:	e8 e7 e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018e9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018ec:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018ee:	8d 40 5c             	lea    0x5c(%eax),%eax
801018f1:	6a 1c                	push   $0x1c
801018f3:	50                   	push   %eax
801018f4:	56                   	push   %esi
801018f5:	e8 e6 3c 00 00       	call   801055e0 <memmove>
  brelse(bp);
801018fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018fd:	83 c4 10             	add    $0x10,%esp
}
80101900:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101903:	5b                   	pop    %ebx
80101904:	5e                   	pop    %esi
80101905:	5d                   	pop    %ebp
  brelse(bp);
80101906:	e9 e5 e8 ff ff       	jmp    801001f0 <brelse>
8010190b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop

80101910 <iinit>:
{
80101910:	f3 0f 1e fb          	endbr32 
80101914:	55                   	push   %ebp
80101915:	89 e5                	mov    %esp,%ebp
80101917:	53                   	push   %ebx
80101918:	bb 00 4e 11 80       	mov    $0x80114e00,%ebx
8010191d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101920:	68 f9 92 10 80       	push   $0x801092f9
80101925:	68 c0 4d 11 80       	push   $0x80114dc0
8010192a:	e8 81 39 00 00       	call   801052b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010192f:	83 c4 10             	add    $0x10,%esp
80101932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101938:	83 ec 08             	sub    $0x8,%esp
8010193b:	68 00 93 10 80       	push   $0x80109300
80101940:	53                   	push   %ebx
80101941:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101947:	e8 24 38 00 00       	call   80105170 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010194c:	83 c4 10             	add    $0x10,%esp
8010194f:	81 fb 20 6a 11 80    	cmp    $0x80116a20,%ebx
80101955:	75 e1                	jne    80101938 <iinit+0x28>
  readsb(dev, &sb);
80101957:	83 ec 08             	sub    $0x8,%esp
8010195a:	68 a0 4d 11 80       	push   $0x80114da0
8010195f:	ff 75 08             	pushl  0x8(%ebp)
80101962:	e8 69 ff ff ff       	call   801018d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101967:	ff 35 b8 4d 11 80    	pushl  0x80114db8
8010196d:	ff 35 b4 4d 11 80    	pushl  0x80114db4
80101973:	ff 35 b0 4d 11 80    	pushl  0x80114db0
80101979:	ff 35 ac 4d 11 80    	pushl  0x80114dac
8010197f:	ff 35 a8 4d 11 80    	pushl  0x80114da8
80101985:	ff 35 a4 4d 11 80    	pushl  0x80114da4
8010198b:	ff 35 a0 4d 11 80    	pushl  0x80114da0
80101991:	68 ac 93 10 80       	push   $0x801093ac
80101996:	e8 15 ed ff ff       	call   801006b0 <cprintf>
}
8010199b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010199e:	83 c4 30             	add    $0x30,%esp
801019a1:	c9                   	leave  
801019a2:	c3                   	ret    
801019a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019b0 <ialloc>:
{
801019b0:	f3 0f 1e fb          	endbr32 
801019b4:	55                   	push   %ebp
801019b5:	89 e5                	mov    %esp,%ebp
801019b7:	57                   	push   %edi
801019b8:	56                   	push   %esi
801019b9:	53                   	push   %ebx
801019ba:	83 ec 1c             	sub    $0x1c,%esp
801019bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801019c0:	83 3d a8 4d 11 80 01 	cmpl   $0x1,0x80114da8
{
801019c7:	8b 75 08             	mov    0x8(%ebp),%esi
801019ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801019cd:	0f 86 8d 00 00 00    	jbe    80101a60 <ialloc+0xb0>
801019d3:	bf 01 00 00 00       	mov    $0x1,%edi
801019d8:	eb 1d                	jmp    801019f7 <ialloc+0x47>
801019da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801019e3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801019e6:	53                   	push   %ebx
801019e7:	e8 04 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801019ec:	83 c4 10             	add    $0x10,%esp
801019ef:	3b 3d a8 4d 11 80    	cmp    0x80114da8,%edi
801019f5:	73 69                	jae    80101a60 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019f7:	89 f8                	mov    %edi,%eax
801019f9:	83 ec 08             	sub    $0x8,%esp
801019fc:	c1 e8 03             	shr    $0x3,%eax
801019ff:	03 05 b4 4d 11 80    	add    0x80114db4,%eax
80101a05:	50                   	push   %eax
80101a06:	56                   	push   %esi
80101a07:	e8 c4 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101a0c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101a0f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101a11:	89 f8                	mov    %edi,%eax
80101a13:	83 e0 07             	and    $0x7,%eax
80101a16:	c1 e0 06             	shl    $0x6,%eax
80101a19:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101a1d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a21:	75 bd                	jne    801019e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a23:	83 ec 04             	sub    $0x4,%esp
80101a26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a29:	6a 40                	push   $0x40
80101a2b:	6a 00                	push   $0x0
80101a2d:	51                   	push   %ecx
80101a2e:	e8 0d 3b 00 00       	call   80105540 <memset>
      dip->type = type;
80101a33:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a3a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a3d:	89 1c 24             	mov    %ebx,(%esp)
80101a40:	e8 ab 1e 00 00       	call   801038f0 <log_write>
      brelse(bp);
80101a45:	89 1c 24             	mov    %ebx,(%esp)
80101a48:	e8 a3 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101a4d:	83 c4 10             	add    $0x10,%esp
}
80101a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a53:	89 fa                	mov    %edi,%edx
}
80101a55:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a56:	89 f0                	mov    %esi,%eax
}
80101a58:	5e                   	pop    %esi
80101a59:	5f                   	pop    %edi
80101a5a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a5b:	e9 b0 fc ff ff       	jmp    80101710 <iget>
  panic("ialloc: no inodes");
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 06 93 10 80       	push   $0x80109306
80101a68:	e8 23 e9 ff ff       	call   80100390 <panic>
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi

80101a70 <iupdate>:
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	56                   	push   %esi
80101a78:	53                   	push   %ebx
80101a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a7c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a82:	83 ec 08             	sub    $0x8,%esp
80101a85:	c1 e8 03             	shr    $0x3,%eax
80101a88:	03 05 b4 4d 11 80    	add    0x80114db4,%eax
80101a8e:	50                   	push   %eax
80101a8f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a92:	e8 39 e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a97:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a9b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a9e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101aa0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101aa3:	83 e0 07             	and    $0x7,%eax
80101aa6:	c1 e0 06             	shl    $0x6,%eax
80101aa9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101aad:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101ab0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ab4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101ab7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101abb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101abf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101ac3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ac7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101acb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101ace:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ad1:	6a 34                	push   $0x34
80101ad3:	53                   	push   %ebx
80101ad4:	50                   	push   %eax
80101ad5:	e8 06 3b 00 00       	call   801055e0 <memmove>
  log_write(bp);
80101ada:	89 34 24             	mov    %esi,(%esp)
80101add:	e8 0e 1e 00 00       	call   801038f0 <log_write>
  brelse(bp);
80101ae2:	89 75 08             	mov    %esi,0x8(%ebp)
80101ae5:	83 c4 10             	add    $0x10,%esp
}
80101ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5d                   	pop    %ebp
  brelse(bp);
80101aee:	e9 fd e6 ff ff       	jmp    801001f0 <brelse>
80101af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b00 <idup>:
{
80101b00:	f3 0f 1e fb          	endbr32 
80101b04:	55                   	push   %ebp
80101b05:	89 e5                	mov    %esp,%ebp
80101b07:	53                   	push   %ebx
80101b08:	83 ec 10             	sub    $0x10,%esp
80101b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101b0e:	68 c0 4d 11 80       	push   $0x80114dc0
80101b13:	e8 18 39 00 00       	call   80105430 <acquire>
  ip->ref++;
80101b18:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b1c:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
80101b23:	e8 c8 39 00 00       	call   801054f0 <release>
}
80101b28:	89 d8                	mov    %ebx,%eax
80101b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b2d:	c9                   	leave  
80101b2e:	c3                   	ret    
80101b2f:	90                   	nop

80101b30 <ilock>:
{
80101b30:	f3 0f 1e fb          	endbr32 
80101b34:	55                   	push   %ebp
80101b35:	89 e5                	mov    %esp,%ebp
80101b37:	56                   	push   %esi
80101b38:	53                   	push   %ebx
80101b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b3c:	85 db                	test   %ebx,%ebx
80101b3e:	0f 84 b3 00 00 00    	je     80101bf7 <ilock+0xc7>
80101b44:	8b 53 08             	mov    0x8(%ebx),%edx
80101b47:	85 d2                	test   %edx,%edx
80101b49:	0f 8e a8 00 00 00    	jle    80101bf7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	8d 43 0c             	lea    0xc(%ebx),%eax
80101b55:	50                   	push   %eax
80101b56:	e8 55 36 00 00       	call   801051b0 <acquiresleep>
  if(ip->valid == 0){
80101b5b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 0b                	je     80101b70 <ilock+0x40>
}
80101b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b68:	5b                   	pop    %ebx
80101b69:	5e                   	pop    %esi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b70:	8b 43 04             	mov    0x4(%ebx),%eax
80101b73:	83 ec 08             	sub    $0x8,%esp
80101b76:	c1 e8 03             	shr    $0x3,%eax
80101b79:	03 05 b4 4d 11 80    	add    0x80114db4,%eax
80101b7f:	50                   	push   %eax
80101b80:	ff 33                	pushl  (%ebx)
80101b82:	e8 49 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b87:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b8a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b8c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b8f:	83 e0 07             	and    $0x7,%eax
80101b92:	c1 e0 06             	shl    $0x6,%eax
80101b95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ba3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ba7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101bab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101baf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101bb3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101bb7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101bbb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101bbe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bc1:	6a 34                	push   $0x34
80101bc3:	50                   	push   %eax
80101bc4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101bc7:	50                   	push   %eax
80101bc8:	e8 13 3a 00 00       	call   801055e0 <memmove>
    brelse(bp);
80101bcd:	89 34 24             	mov    %esi,(%esp)
80101bd0:	e8 1b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101bd5:	83 c4 10             	add    $0x10,%esp
80101bd8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101bdd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101be4:	0f 85 7b ff ff ff    	jne    80101b65 <ilock+0x35>
      panic("ilock: no type");
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	68 1e 93 10 80       	push   $0x8010931e
80101bf2:	e8 99 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	68 18 93 10 80       	push   $0x80109318
80101bff:	e8 8c e7 ff ff       	call   80100390 <panic>
80101c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c0f:	90                   	nop

80101c10 <iunlock>:
{
80101c10:	f3 0f 1e fb          	endbr32 
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	56                   	push   %esi
80101c18:	53                   	push   %ebx
80101c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c1c:	85 db                	test   %ebx,%ebx
80101c1e:	74 28                	je     80101c48 <iunlock+0x38>
80101c20:	83 ec 0c             	sub    $0xc,%esp
80101c23:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c26:	56                   	push   %esi
80101c27:	e8 24 36 00 00       	call   80105250 <holdingsleep>
80101c2c:	83 c4 10             	add    $0x10,%esp
80101c2f:	85 c0                	test   %eax,%eax
80101c31:	74 15                	je     80101c48 <iunlock+0x38>
80101c33:	8b 43 08             	mov    0x8(%ebx),%eax
80101c36:	85 c0                	test   %eax,%eax
80101c38:	7e 0e                	jle    80101c48 <iunlock+0x38>
  releasesleep(&ip->lock);
80101c3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c40:	5b                   	pop    %ebx
80101c41:	5e                   	pop    %esi
80101c42:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c43:	e9 c8 35 00 00       	jmp    80105210 <releasesleep>
    panic("iunlock");
80101c48:	83 ec 0c             	sub    $0xc,%esp
80101c4b:	68 2d 93 10 80       	push   $0x8010932d
80101c50:	e8 3b e7 ff ff       	call   80100390 <panic>
80101c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c60 <iput>:
{
80101c60:	f3 0f 1e fb          	endbr32 
80101c64:	55                   	push   %ebp
80101c65:	89 e5                	mov    %esp,%ebp
80101c67:	57                   	push   %edi
80101c68:	56                   	push   %esi
80101c69:	53                   	push   %ebx
80101c6a:	83 ec 28             	sub    $0x28,%esp
80101c6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c70:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c73:	57                   	push   %edi
80101c74:	e8 37 35 00 00       	call   801051b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c79:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c7c:	83 c4 10             	add    $0x10,%esp
80101c7f:	85 d2                	test   %edx,%edx
80101c81:	74 07                	je     80101c8a <iput+0x2a>
80101c83:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c88:	74 36                	je     80101cc0 <iput+0x60>
  releasesleep(&ip->lock);
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	57                   	push   %edi
80101c8e:	e8 7d 35 00 00       	call   80105210 <releasesleep>
  acquire(&icache.lock);
80101c93:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
80101c9a:	e8 91 37 00 00       	call   80105430 <acquire>
  ip->ref--;
80101c9f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ca3:	83 c4 10             	add    $0x10,%esp
80101ca6:	c7 45 08 c0 4d 11 80 	movl   $0x80114dc0,0x8(%ebp)
}
80101cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb0:	5b                   	pop    %ebx
80101cb1:	5e                   	pop    %esi
80101cb2:	5f                   	pop    %edi
80101cb3:	5d                   	pop    %ebp
  release(&icache.lock);
80101cb4:	e9 37 38 00 00       	jmp    801054f0 <release>
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101cc0:	83 ec 0c             	sub    $0xc,%esp
80101cc3:	68 c0 4d 11 80       	push   $0x80114dc0
80101cc8:	e8 63 37 00 00       	call   80105430 <acquire>
    int r = ip->ref;
80101ccd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cd0:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
80101cd7:	e8 14 38 00 00       	call   801054f0 <release>
    if(r == 1){
80101cdc:	83 c4 10             	add    $0x10,%esp
80101cdf:	83 fe 01             	cmp    $0x1,%esi
80101ce2:	75 a6                	jne    80101c8a <iput+0x2a>
80101ce4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101cea:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ced:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101cf0:	89 cf                	mov    %ecx,%edi
80101cf2:	eb 0b                	jmp    80101cff <iput+0x9f>
80101cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cf8:	83 c6 04             	add    $0x4,%esi
80101cfb:	39 fe                	cmp    %edi,%esi
80101cfd:	74 19                	je     80101d18 <iput+0xb8>
    if(ip->addrs[i]){
80101cff:	8b 16                	mov    (%esi),%edx
80101d01:	85 d2                	test   %edx,%edx
80101d03:	74 f3                	je     80101cf8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101d05:	8b 03                	mov    (%ebx),%eax
80101d07:	e8 74 f8 ff ff       	call   80101580 <bfree>
      ip->addrs[i] = 0;
80101d0c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101d12:	eb e4                	jmp    80101cf8 <iput+0x98>
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101d18:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101d1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d21:	85 c0                	test   %eax,%eax
80101d23:	75 33                	jne    80101d58 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d25:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d28:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d2f:	53                   	push   %ebx
80101d30:	e8 3b fd ff ff       	call   80101a70 <iupdate>
      ip->type = 0;
80101d35:	31 c0                	xor    %eax,%eax
80101d37:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d3b:	89 1c 24             	mov    %ebx,(%esp)
80101d3e:	e8 2d fd ff ff       	call   80101a70 <iupdate>
      ip->valid = 0;
80101d43:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	e9 38 ff ff ff       	jmp    80101c8a <iput+0x2a>
80101d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d58:	83 ec 08             	sub    $0x8,%esp
80101d5b:	50                   	push   %eax
80101d5c:	ff 33                	pushl  (%ebx)
80101d5e:	e8 6d e3 ff ff       	call   801000d0 <bread>
80101d63:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d66:	83 c4 10             	add    $0x10,%esp
80101d69:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d72:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d75:	89 cf                	mov    %ecx,%edi
80101d77:	eb 0e                	jmp    80101d87 <iput+0x127>
80101d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d80:	83 c6 04             	add    $0x4,%esi
80101d83:	39 f7                	cmp    %esi,%edi
80101d85:	74 19                	je     80101da0 <iput+0x140>
      if(a[j])
80101d87:	8b 16                	mov    (%esi),%edx
80101d89:	85 d2                	test   %edx,%edx
80101d8b:	74 f3                	je     80101d80 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d8d:	8b 03                	mov    (%ebx),%eax
80101d8f:	e8 ec f7 ff ff       	call   80101580 <bfree>
80101d94:	eb ea                	jmp    80101d80 <iput+0x120>
80101d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d9d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101da0:	83 ec 0c             	sub    $0xc,%esp
80101da3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101da6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101da9:	e8 42 e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101dae:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101db4:	8b 03                	mov    (%ebx),%eax
80101db6:	e8 c5 f7 ff ff       	call   80101580 <bfree>
    ip->addrs[NDIRECT] = 0;
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101dc5:	00 00 00 
80101dc8:	e9 58 ff ff ff       	jmp    80101d25 <iput+0xc5>
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi

80101dd0 <iunlockput>:
{
80101dd0:	f3 0f 1e fb          	endbr32 
80101dd4:	55                   	push   %ebp
80101dd5:	89 e5                	mov    %esp,%ebp
80101dd7:	53                   	push   %ebx
80101dd8:	83 ec 10             	sub    $0x10,%esp
80101ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101dde:	53                   	push   %ebx
80101ddf:	e8 2c fe ff ff       	call   80101c10 <iunlock>
  iput(ip);
80101de4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101de7:	83 c4 10             	add    $0x10,%esp
}
80101dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ded:	c9                   	leave  
  iput(ip);
80101dee:	e9 6d fe ff ff       	jmp    80101c60 <iput>
80101df3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e00:	f3 0f 1e fb          	endbr32 
80101e04:	55                   	push   %ebp
80101e05:	89 e5                	mov    %esp,%ebp
80101e07:	8b 55 08             	mov    0x8(%ebp),%edx
80101e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101e0d:	8b 0a                	mov    (%edx),%ecx
80101e0f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e12:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e15:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e18:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e1c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e1f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e23:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e27:	8b 52 58             	mov    0x58(%edx),%edx
80101e2a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e2d:	5d                   	pop    %ebp
80101e2e:	c3                   	ret    
80101e2f:	90                   	nop

80101e30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e30:	f3 0f 1e fb          	endbr32 
80101e34:	55                   	push   %ebp
80101e35:	89 e5                	mov    %esp,%ebp
80101e37:	57                   	push   %edi
80101e38:	56                   	push   %esi
80101e39:	53                   	push   %ebx
80101e3a:	83 ec 1c             	sub    $0x1c,%esp
80101e3d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101e40:	8b 45 08             	mov    0x8(%ebp),%eax
80101e43:	8b 75 10             	mov    0x10(%ebp),%esi
80101e46:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e49:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e4c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e51:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e54:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e57:	0f 84 a3 00 00 00    	je     80101f00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e60:	8b 40 58             	mov    0x58(%eax),%eax
80101e63:	39 c6                	cmp    %eax,%esi
80101e65:	0f 87 b6 00 00 00    	ja     80101f21 <readi+0xf1>
80101e6b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e6e:	31 c9                	xor    %ecx,%ecx
80101e70:	89 da                	mov    %ebx,%edx
80101e72:	01 f2                	add    %esi,%edx
80101e74:	0f 92 c1             	setb   %cl
80101e77:	89 cf                	mov    %ecx,%edi
80101e79:	0f 82 a2 00 00 00    	jb     80101f21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e7f:	89 c1                	mov    %eax,%ecx
80101e81:	29 f1                	sub    %esi,%ecx
80101e83:	39 d0                	cmp    %edx,%eax
80101e85:	0f 43 cb             	cmovae %ebx,%ecx
80101e88:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e8b:	85 c9                	test   %ecx,%ecx
80101e8d:	74 63                	je     80101ef2 <readi+0xc2>
80101e8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e93:	89 f2                	mov    %esi,%edx
80101e95:	c1 ea 09             	shr    $0x9,%edx
80101e98:	89 d8                	mov    %ebx,%eax
80101e9a:	e8 61 f9 ff ff       	call   80101800 <bmap>
80101e9f:	83 ec 08             	sub    $0x8,%esp
80101ea2:	50                   	push   %eax
80101ea3:	ff 33                	pushl  (%ebx)
80101ea5:	e8 26 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101eaa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ead:	b9 00 02 00 00       	mov    $0x200,%ecx
80101eb2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb7:	89 f0                	mov    %esi,%eax
80101eb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ebe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ec0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ec5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec9:	39 d9                	cmp    %ebx,%ecx
80101ecb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ece:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ecf:	01 df                	add    %ebx,%edi
80101ed1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ed3:	50                   	push   %eax
80101ed4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ed7:	e8 04 37 00 00       	call   801055e0 <memmove>
    brelse(bp);
80101edc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101edf:	89 14 24             	mov    %edx,(%esp)
80101ee2:	e8 09 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101eea:	83 c4 10             	add    $0x10,%esp
80101eed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ef0:	77 9e                	ja     80101e90 <readi+0x60>
  }
  return n;
80101ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef8:	5b                   	pop    %ebx
80101ef9:	5e                   	pop    %esi
80101efa:	5f                   	pop    %edi
80101efb:	5d                   	pop    %ebp
80101efc:	c3                   	ret    
80101efd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	77 17                	ja     80101f21 <readi+0xf1>
80101f0a:	8b 04 c5 40 4d 11 80 	mov    -0x7feeb2c0(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	74 0c                	je     80101f21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1b:	5b                   	pop    %ebx
80101f1c:	5e                   	pop    %esi
80101f1d:	5f                   	pop    %edi
80101f1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f1f:	ff e0                	jmp    *%eax
      return -1;
80101f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f26:	eb cd                	jmp    80101ef5 <readi+0xc5>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop

80101f30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f30:	f3 0f 1e fb          	endbr32 
80101f34:	55                   	push   %ebp
80101f35:	89 e5                	mov    %esp,%ebp
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
80101f3a:	83 ec 1c             	sub    $0x1c,%esp
80101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f40:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f43:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f46:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f4b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f51:	8b 75 10             	mov    0x10(%ebp),%esi
80101f54:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f57:	0f 84 b3 00 00 00    	je     80102010 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f60:	39 70 58             	cmp    %esi,0x58(%eax)
80101f63:	0f 82 e3 00 00 00    	jb     8010204c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f69:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f6c:	89 f8                	mov    %edi,%eax
80101f6e:	01 f0                	add    %esi,%eax
80101f70:	0f 82 d6 00 00 00    	jb     8010204c <writei+0x11c>
80101f76:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f7b:	0f 87 cb 00 00 00    	ja     8010204c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f88:	85 ff                	test   %edi,%edi
80101f8a:	74 75                	je     80102001 <writei+0xd1>
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f93:	89 f2                	mov    %esi,%edx
80101f95:	c1 ea 09             	shr    $0x9,%edx
80101f98:	89 f8                	mov    %edi,%eax
80101f9a:	e8 61 f8 ff ff       	call   80101800 <bmap>
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 37                	pushl  (%edi)
80101fa5:	e8 26 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101faa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101faf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101fb2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	83 c4 0c             	add    $0xc,%esp
80101fbc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101fc3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc7:	39 d9                	cmp    %ebx,%ecx
80101fc9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101fcc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fcd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101fcf:	ff 75 dc             	pushl  -0x24(%ebp)
80101fd2:	50                   	push   %eax
80101fd3:	e8 08 36 00 00       	call   801055e0 <memmove>
    log_write(bp);
80101fd8:	89 3c 24             	mov    %edi,(%esp)
80101fdb:	e8 10 19 00 00       	call   801038f0 <log_write>
    brelse(bp);
80101fe0:	89 3c 24             	mov    %edi,(%esp)
80101fe3:	e8 08 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fe8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ff1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ff4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ff7:	77 97                	ja     80101f90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ff9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ffc:	3b 70 58             	cmp    0x58(%eax),%esi
80101fff:	77 37                	ja     80102038 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102001:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
8010200b:	c3                   	ret    
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102010:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102014:	66 83 f8 09          	cmp    $0x9,%ax
80102018:	77 32                	ja     8010204c <writei+0x11c>
8010201a:	8b 04 c5 44 4d 11 80 	mov    -0x7feeb2bc(,%eax,8),%eax
80102021:	85 c0                	test   %eax,%eax
80102023:	74 27                	je     8010204c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102025:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202b:	5b                   	pop    %ebx
8010202c:	5e                   	pop    %esi
8010202d:	5f                   	pop    %edi
8010202e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010202f:	ff e0                	jmp    *%eax
80102031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102038:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010203b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010203e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102041:	50                   	push   %eax
80102042:	e8 29 fa ff ff       	call   80101a70 <iupdate>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	eb b5                	jmp    80102001 <writei+0xd1>
      return -1;
8010204c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102051:	eb b1                	jmp    80102004 <writei+0xd4>
80102053:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102060 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
80102065:	89 e5                	mov    %esp,%ebp
80102067:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010206a:	6a 0e                	push   $0xe
8010206c:	ff 75 0c             	pushl  0xc(%ebp)
8010206f:	ff 75 08             	pushl  0x8(%ebp)
80102072:	e8 d9 35 00 00       	call   80105650 <strncmp>
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102080:	f3 0f 1e fb          	endbr32 
80102084:	55                   	push   %ebp
80102085:	89 e5                	mov    %esp,%ebp
80102087:	57                   	push   %edi
80102088:	56                   	push   %esi
80102089:	53                   	push   %ebx
8010208a:	83 ec 1c             	sub    $0x1c,%esp
8010208d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102090:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102095:	0f 85 89 00 00 00    	jne    80102124 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010209b:	8b 53 58             	mov    0x58(%ebx),%edx
8010209e:	31 ff                	xor    %edi,%edi
801020a0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020a3:	85 d2                	test   %edx,%edx
801020a5:	74 42                	je     801020e9 <dirlookup+0x69>
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b0:	6a 10                	push   $0x10
801020b2:	57                   	push   %edi
801020b3:	56                   	push   %esi
801020b4:	53                   	push   %ebx
801020b5:	e8 76 fd ff ff       	call   80101e30 <readi>
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	83 f8 10             	cmp    $0x10,%eax
801020c0:	75 55                	jne    80102117 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801020c2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020c7:	74 18                	je     801020e1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801020c9:	83 ec 04             	sub    $0x4,%esp
801020cc:	8d 45 da             	lea    -0x26(%ebp),%eax
801020cf:	6a 0e                	push   $0xe
801020d1:	50                   	push   %eax
801020d2:	ff 75 0c             	pushl  0xc(%ebp)
801020d5:	e8 76 35 00 00       	call   80105650 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801020da:	83 c4 10             	add    $0x10,%esp
801020dd:	85 c0                	test   %eax,%eax
801020df:	74 17                	je     801020f8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020e1:	83 c7 10             	add    $0x10,%edi
801020e4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020e7:	72 c7                	jb     801020b0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801020e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801020ec:	31 c0                	xor    %eax,%eax
}
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f7:	90                   	nop
      if(poff)
801020f8:	8b 45 10             	mov    0x10(%ebp),%eax
801020fb:	85 c0                	test   %eax,%eax
801020fd:	74 05                	je     80102104 <dirlookup+0x84>
        *poff = off;
801020ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102102:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102104:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102108:	8b 03                	mov    (%ebx),%eax
8010210a:	e8 01 f6 ff ff       	call   80101710 <iget>
}
8010210f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102112:	5b                   	pop    %ebx
80102113:	5e                   	pop    %esi
80102114:	5f                   	pop    %edi
80102115:	5d                   	pop    %ebp
80102116:	c3                   	ret    
      panic("dirlookup read");
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 47 93 10 80       	push   $0x80109347
8010211f:	e8 6c e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	68 35 93 10 80       	push   $0x80109335
8010212c:	e8 5f e2 ff ff       	call   80100390 <panic>
80102131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213f:	90                   	nop

80102140 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	89 c3                	mov    %eax,%ebx
80102148:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010214b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010214e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102151:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102154:	0f 84 86 01 00 00    	je     801022e0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010215a:	e8 11 23 00 00       	call   80104470 <myproc>
  acquire(&icache.lock);
8010215f:	83 ec 0c             	sub    $0xc,%esp
80102162:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102164:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102167:	68 c0 4d 11 80       	push   $0x80114dc0
8010216c:	e8 bf 32 00 00       	call   80105430 <acquire>
  ip->ref++;
80102171:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102175:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
8010217c:	e8 6f 33 00 00       	call   801054f0 <release>
80102181:	83 c4 10             	add    $0x10,%esp
80102184:	eb 0d                	jmp    80102193 <namex+0x53>
80102186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102190:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102193:	0f b6 07             	movzbl (%edi),%eax
80102196:	3c 2f                	cmp    $0x2f,%al
80102198:	74 f6                	je     80102190 <namex+0x50>
  if(*path == 0)
8010219a:	84 c0                	test   %al,%al
8010219c:	0f 84 ee 00 00 00    	je     80102290 <namex+0x150>
  while(*path != '/' && *path != 0)
801021a2:	0f b6 07             	movzbl (%edi),%eax
801021a5:	84 c0                	test   %al,%al
801021a7:	0f 84 fb 00 00 00    	je     801022a8 <namex+0x168>
801021ad:	89 fb                	mov    %edi,%ebx
801021af:	3c 2f                	cmp    $0x2f,%al
801021b1:	0f 84 f1 00 00 00    	je     801022a8 <namex+0x168>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
801021c0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801021c4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801021c7:	3c 2f                	cmp    $0x2f,%al
801021c9:	74 04                	je     801021cf <namex+0x8f>
801021cb:	84 c0                	test   %al,%al
801021cd:	75 f1                	jne    801021c0 <namex+0x80>
  len = path - s;
801021cf:	89 d8                	mov    %ebx,%eax
801021d1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801021d3:	83 f8 0d             	cmp    $0xd,%eax
801021d6:	0f 8e 84 00 00 00    	jle    80102260 <namex+0x120>
    memmove(name, s, DIRSIZ);
801021dc:	83 ec 04             	sub    $0x4,%esp
801021df:	6a 0e                	push   $0xe
801021e1:	57                   	push   %edi
    path++;
801021e2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801021e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801021e7:	e8 f4 33 00 00       	call   801055e0 <memmove>
801021ec:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801021ef:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801021f2:	75 0c                	jne    80102200 <namex+0xc0>
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021f8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801021fb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801021fe:	74 f8                	je     801021f8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	56                   	push   %esi
80102204:	e8 27 f9 ff ff       	call   80101b30 <ilock>
    if(ip->type != T_DIR){
80102209:	83 c4 10             	add    $0x10,%esp
8010220c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102211:	0f 85 a1 00 00 00    	jne    801022b8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102217:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010221a:	85 d2                	test   %edx,%edx
8010221c:	74 09                	je     80102227 <namex+0xe7>
8010221e:	80 3f 00             	cmpb   $0x0,(%edi)
80102221:	0f 84 d9 00 00 00    	je     80102300 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102227:	83 ec 04             	sub    $0x4,%esp
8010222a:	6a 00                	push   $0x0
8010222c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010222f:	56                   	push   %esi
80102230:	e8 4b fe ff ff       	call   80102080 <dirlookup>
80102235:	83 c4 10             	add    $0x10,%esp
80102238:	89 c3                	mov    %eax,%ebx
8010223a:	85 c0                	test   %eax,%eax
8010223c:	74 7a                	je     801022b8 <namex+0x178>
  iunlock(ip);
8010223e:	83 ec 0c             	sub    $0xc,%esp
80102241:	56                   	push   %esi
80102242:	e8 c9 f9 ff ff       	call   80101c10 <iunlock>
  iput(ip);
80102247:	89 34 24             	mov    %esi,(%esp)
8010224a:	89 de                	mov    %ebx,%esi
8010224c:	e8 0f fa ff ff       	call   80101c60 <iput>
80102251:	83 c4 10             	add    $0x10,%esp
80102254:	e9 3a ff ff ff       	jmp    80102193 <namex+0x53>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102263:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102266:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102269:	83 ec 04             	sub    $0x4,%esp
8010226c:	50                   	push   %eax
8010226d:	57                   	push   %edi
    name[len] = 0;
8010226e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102270:	ff 75 e4             	pushl  -0x1c(%ebp)
80102273:	e8 68 33 00 00       	call   801055e0 <memmove>
    name[len] = 0;
80102278:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	c6 00 00             	movb   $0x0,(%eax)
80102281:	e9 69 ff ff ff       	jmp    801021ef <namex+0xaf>
80102286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102290:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102293:	85 c0                	test   %eax,%eax
80102295:	0f 85 85 00 00 00    	jne    80102320 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010229b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010229e:	89 f0                	mov    %esi,%eax
801022a0:	5b                   	pop    %ebx
801022a1:	5e                   	pop    %esi
801022a2:	5f                   	pop    %edi
801022a3:	5d                   	pop    %ebp
801022a4:	c3                   	ret    
801022a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801022a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022ab:	89 fb                	mov    %edi,%ebx
801022ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801022b0:	31 c0                	xor    %eax,%eax
801022b2:	eb b5                	jmp    80102269 <namex+0x129>
801022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	56                   	push   %esi
801022bc:	e8 4f f9 ff ff       	call   80101c10 <iunlock>
  iput(ip);
801022c1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022c4:	31 f6                	xor    %esi,%esi
  iput(ip);
801022c6:	e8 95 f9 ff ff       	call   80101c60 <iput>
      return 0;
801022cb:	83 c4 10             	add    $0x10,%esp
}
801022ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d1:	89 f0                	mov    %esi,%eax
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801022e0:	ba 01 00 00 00       	mov    $0x1,%edx
801022e5:	b8 01 00 00 00       	mov    $0x1,%eax
801022ea:	89 df                	mov    %ebx,%edi
801022ec:	e8 1f f4 ff ff       	call   80101710 <iget>
801022f1:	89 c6                	mov    %eax,%esi
801022f3:	e9 9b fe ff ff       	jmp    80102193 <namex+0x53>
801022f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop
      iunlock(ip);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	56                   	push   %esi
80102304:	e8 07 f9 ff ff       	call   80101c10 <iunlock>
      return ip;
80102309:	83 c4 10             	add    $0x10,%esp
}
8010230c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010230f:	89 f0                	mov    %esi,%eax
80102311:	5b                   	pop    %ebx
80102312:	5e                   	pop    %esi
80102313:	5f                   	pop    %edi
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
80102316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	56                   	push   %esi
    return 0;
80102324:	31 f6                	xor    %esi,%esi
    iput(ip);
80102326:	e8 35 f9 ff ff       	call   80101c60 <iput>
    return 0;
8010232b:	83 c4 10             	add    $0x10,%esp
8010232e:	e9 68 ff ff ff       	jmp    8010229b <namex+0x15b>
80102333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102340 <dirlink>:
{
80102340:	f3 0f 1e fb          	endbr32 
80102344:	55                   	push   %ebp
80102345:	89 e5                	mov    %esp,%ebp
80102347:	57                   	push   %edi
80102348:	56                   	push   %esi
80102349:	53                   	push   %ebx
8010234a:	83 ec 20             	sub    $0x20,%esp
8010234d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102350:	6a 00                	push   $0x0
80102352:	ff 75 0c             	pushl  0xc(%ebp)
80102355:	53                   	push   %ebx
80102356:	e8 25 fd ff ff       	call   80102080 <dirlookup>
8010235b:	83 c4 10             	add    $0x10,%esp
8010235e:	85 c0                	test   %eax,%eax
80102360:	75 6b                	jne    801023cd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102362:	8b 7b 58             	mov    0x58(%ebx),%edi
80102365:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102368:	85 ff                	test   %edi,%edi
8010236a:	74 2d                	je     80102399 <dirlink+0x59>
8010236c:	31 ff                	xor    %edi,%edi
8010236e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102371:	eb 0d                	jmp    80102380 <dirlink+0x40>
80102373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102377:	90                   	nop
80102378:	83 c7 10             	add    $0x10,%edi
8010237b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010237e:	73 19                	jae    80102399 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102380:	6a 10                	push   $0x10
80102382:	57                   	push   %edi
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	e8 a6 fa ff ff       	call   80101e30 <readi>
8010238a:	83 c4 10             	add    $0x10,%esp
8010238d:	83 f8 10             	cmp    $0x10,%eax
80102390:	75 4e                	jne    801023e0 <dirlink+0xa0>
    if(de.inum == 0)
80102392:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102397:	75 df                	jne    80102378 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102399:	83 ec 04             	sub    $0x4,%esp
8010239c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010239f:	6a 0e                	push   $0xe
801023a1:	ff 75 0c             	pushl  0xc(%ebp)
801023a4:	50                   	push   %eax
801023a5:	e8 f6 32 00 00       	call   801056a0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023aa:	6a 10                	push   $0x10
  de.inum = inum;
801023ac:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023af:	57                   	push   %edi
801023b0:	56                   	push   %esi
801023b1:	53                   	push   %ebx
  de.inum = inum;
801023b2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b6:	e8 75 fb ff ff       	call   80101f30 <writei>
801023bb:	83 c4 20             	add    $0x20,%esp
801023be:	83 f8 10             	cmp    $0x10,%eax
801023c1:	75 2a                	jne    801023ed <dirlink+0xad>
  return 0;
801023c3:	31 c0                	xor    %eax,%eax
}
801023c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c8:	5b                   	pop    %ebx
801023c9:	5e                   	pop    %esi
801023ca:	5f                   	pop    %edi
801023cb:	5d                   	pop    %ebp
801023cc:	c3                   	ret    
    iput(ip);
801023cd:	83 ec 0c             	sub    $0xc,%esp
801023d0:	50                   	push   %eax
801023d1:	e8 8a f8 ff ff       	call   80101c60 <iput>
    return -1;
801023d6:	83 c4 10             	add    $0x10,%esp
801023d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023de:	eb e5                	jmp    801023c5 <dirlink+0x85>
      panic("dirlink read");
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	68 56 93 10 80       	push   $0x80109356
801023e8:	e8 a3 df ff ff       	call   80100390 <panic>
    panic("dirlink");
801023ed:	83 ec 0c             	sub    $0xc,%esp
801023f0:	68 95 9a 10 80       	push   $0x80109a95
801023f5:	e8 96 df ff ff       	call   80100390 <panic>
801023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102400 <namei>:

struct inode*
namei(char *path)
{
80102400:	f3 0f 1e fb          	endbr32 
80102404:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102405:	31 d2                	xor    %edx,%edx
{
80102407:	89 e5                	mov    %esp,%ebp
80102409:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010240c:	8b 45 08             	mov    0x8(%ebp),%eax
8010240f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102412:	e8 29 fd ff ff       	call   80102140 <namex>
}
80102417:	c9                   	leave  
80102418:	c3                   	ret    
80102419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102420 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102420:	f3 0f 1e fb          	endbr32 
80102424:	55                   	push   %ebp
  return namex(path, 1, name);
80102425:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010242a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010242c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102432:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102433:	e9 08 fd ff ff       	jmp    80102140 <namex>
80102438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243f:	90                   	nop

80102440 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102445:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010244a:	89 e5                	mov    %esp,%ebp
8010244c:	57                   	push   %edi
8010244d:	56                   	push   %esi
8010244e:	53                   	push   %ebx
8010244f:	83 ec 10             	sub    $0x10,%esp
80102452:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102455:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102458:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010245f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102466:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010246a:	89 fb                	mov    %edi,%ebx
8010246c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102470:	85 c9                	test   %ecx,%ecx
80102472:	79 08                	jns    8010247c <itoa+0x3c>
        *p++ = '-';
80102474:	c6 07 2d             	movb   $0x2d,(%edi)
80102477:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010247a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010247c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010247e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102487:	90                   	nop
80102488:	89 d0                	mov    %edx,%eax
        ++p;
8010248a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010248d:	f7 e6                	mul    %esi
    }while(shifter);
8010248f:	c1 ea 03             	shr    $0x3,%edx
80102492:	75 f4                	jne    80102488 <itoa+0x48>
    *p = '\0';
80102494:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102497:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a0:	89 c8                	mov    %ecx,%eax
801024a2:	83 eb 01             	sub    $0x1,%ebx
801024a5:	f7 e6                	mul    %esi
801024a7:	c1 ea 03             	shr    $0x3,%edx
801024aa:	8d 04 92             	lea    (%edx,%edx,4),%eax
801024ad:	01 c0                	add    %eax,%eax
801024af:	29 c1                	sub    %eax,%ecx
801024b1:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801024b6:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801024b8:	88 03                	mov    %al,(%ebx)
    }while(i);
801024ba:	85 d2                	test   %edx,%edx
801024bc:	75 e2                	jne    801024a0 <itoa+0x60>
    return b;
}
801024be:	83 c4 10             	add    $0x10,%esp
801024c1:	89 f8                	mov    %edi,%eax
801024c3:	5b                   	pop    %ebx
801024c4:	5e                   	pop    %esi
801024c5:	5f                   	pop    %edi
801024c6:	5d                   	pop    %ebp
801024c7:	c3                   	ret    
801024c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024cf:	90                   	nop

801024d0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801024d0:	f3 0f 1e fb          	endbr32 
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	57                   	push   %edi
801024d8:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801024d9:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801024dc:	53                   	push   %ebx
801024dd:	83 ec 40             	sub    $0x40,%esp
801024e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801024e3:	6a 06                	push   $0x6
801024e5:	68 63 93 10 80       	push   $0x80109363
801024ea:	56                   	push   %esi
801024eb:	e8 f0 30 00 00       	call   801055e0 <memmove>
  itoa(p->pid, path+ 6);
801024f0:	58                   	pop    %eax
801024f1:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801024f4:	5a                   	pop    %edx
801024f5:	50                   	push   %eax
801024f6:	ff 73 10             	pushl  0x10(%ebx)
801024f9:	e8 42 ff ff ff       	call   80102440 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801024fe:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102501:	83 c4 10             	add    $0x10,%esp
80102504:	85 c0                	test   %eax,%eax
80102506:	0f 84 7a 01 00 00    	je     80102686 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
8010250c:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010250f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80102512:	50                   	push   %eax
80102513:	e8 78 ed ff ff       	call   80101290 <fileclose>

  begin_op();
80102518:	e8 f3 11 00 00       	call   80103710 <begin_op>
  return namex(path, 1, name);
8010251d:	89 f0                	mov    %esi,%eax
8010251f:	89 d9                	mov    %ebx,%ecx
80102521:	ba 01 00 00 00       	mov    $0x1,%edx
80102526:	e8 15 fc ff ff       	call   80102140 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010252b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010252e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102530:	85 c0                	test   %eax,%eax
80102532:	0f 84 55 01 00 00    	je     8010268d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	50                   	push   %eax
8010253c:	e8 ef f5 ff ff       	call   80101b30 <ilock>
  return strncmp(s, t, DIRSIZ);
80102541:	83 c4 0c             	add    $0xc,%esp
80102544:	6a 0e                	push   $0xe
80102546:	68 6b 93 10 80       	push   $0x8010936b
8010254b:	53                   	push   %ebx
8010254c:	e8 ff 30 00 00       	call   80105650 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102551:	83 c4 10             	add    $0x10,%esp
80102554:	85 c0                	test   %eax,%eax
80102556:	0f 84 f4 00 00 00    	je     80102650 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010255c:	83 ec 04             	sub    $0x4,%esp
8010255f:	6a 0e                	push   $0xe
80102561:	68 6a 93 10 80       	push   $0x8010936a
80102566:	53                   	push   %ebx
80102567:	e8 e4 30 00 00       	call   80105650 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010256c:	83 c4 10             	add    $0x10,%esp
8010256f:	85 c0                	test   %eax,%eax
80102571:	0f 84 d9 00 00 00    	je     80102650 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102577:	83 ec 04             	sub    $0x4,%esp
8010257a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010257d:	50                   	push   %eax
8010257e:	53                   	push   %ebx
8010257f:	56                   	push   %esi
80102580:	e8 fb fa ff ff       	call   80102080 <dirlookup>
80102585:	83 c4 10             	add    $0x10,%esp
80102588:	89 c3                	mov    %eax,%ebx
8010258a:	85 c0                	test   %eax,%eax
8010258c:	0f 84 be 00 00 00    	je     80102650 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102592:	83 ec 0c             	sub    $0xc,%esp
80102595:	50                   	push   %eax
80102596:	e8 95 f5 ff ff       	call   80101b30 <ilock>

  if(ip->nlink < 1)
8010259b:	83 c4 10             	add    $0x10,%esp
8010259e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801025a3:	0f 8e 00 01 00 00    	jle    801026a9 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801025a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801025ae:	74 78                	je     80102628 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801025b0:	83 ec 04             	sub    $0x4,%esp
801025b3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801025b6:	6a 10                	push   $0x10
801025b8:	6a 00                	push   $0x0
801025ba:	57                   	push   %edi
801025bb:	e8 80 2f 00 00       	call   80105540 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025c0:	6a 10                	push   $0x10
801025c2:	ff 75 b8             	pushl  -0x48(%ebp)
801025c5:	57                   	push   %edi
801025c6:	56                   	push   %esi
801025c7:	e8 64 f9 ff ff       	call   80101f30 <writei>
801025cc:	83 c4 20             	add    $0x20,%esp
801025cf:	83 f8 10             	cmp    $0x10,%eax
801025d2:	0f 85 c4 00 00 00    	jne    8010269c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801025d8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801025dd:	0f 84 8d 00 00 00    	je     80102670 <removeSwapFile+0x1a0>
  iunlock(ip);
801025e3:	83 ec 0c             	sub    $0xc,%esp
801025e6:	56                   	push   %esi
801025e7:	e8 24 f6 ff ff       	call   80101c10 <iunlock>
  iput(ip);
801025ec:	89 34 24             	mov    %esi,(%esp)
801025ef:	e8 6c f6 ff ff       	call   80101c60 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801025f4:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801025f9:	89 1c 24             	mov    %ebx,(%esp)
801025fc:	e8 6f f4 ff ff       	call   80101a70 <iupdate>
  iunlock(ip);
80102601:	89 1c 24             	mov    %ebx,(%esp)
80102604:	e8 07 f6 ff ff       	call   80101c10 <iunlock>
  iput(ip);
80102609:	89 1c 24             	mov    %ebx,(%esp)
8010260c:	e8 4f f6 ff ff       	call   80101c60 <iput>
  iunlockput(ip);

  end_op();
80102611:	e8 6a 11 00 00       	call   80103780 <end_op>

  return 0;
80102616:	83 c4 10             	add    $0x10,%esp
80102619:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
8010261b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010261e:	5b                   	pop    %ebx
8010261f:	5e                   	pop    %esi
80102620:	5f                   	pop    %edi
80102621:	5d                   	pop    %ebp
80102622:	c3                   	ret    
80102623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102627:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	53                   	push   %ebx
8010262c:	e8 df 36 00 00       	call   80105d10 <isdirempty>
80102631:	83 c4 10             	add    $0x10,%esp
80102634:	85 c0                	test   %eax,%eax
80102636:	0f 85 74 ff ff ff    	jne    801025b0 <removeSwapFile+0xe0>
  iunlock(ip);
8010263c:	83 ec 0c             	sub    $0xc,%esp
8010263f:	53                   	push   %ebx
80102640:	e8 cb f5 ff ff       	call   80101c10 <iunlock>
  iput(ip);
80102645:	89 1c 24             	mov    %ebx,(%esp)
80102648:	e8 13 f6 ff ff       	call   80101c60 <iput>
    goto bad;
8010264d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	56                   	push   %esi
80102654:	e8 b7 f5 ff ff       	call   80101c10 <iunlock>
  iput(ip);
80102659:	89 34 24             	mov    %esi,(%esp)
8010265c:	e8 ff f5 ff ff       	call   80101c60 <iput>
    end_op();
80102661:	e8 1a 11 00 00       	call   80103780 <end_op>
    return -1;
80102666:	83 c4 10             	add    $0x10,%esp
80102669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010266e:	eb ab                	jmp    8010261b <removeSwapFile+0x14b>
    iupdate(dp);
80102670:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102673:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102678:	56                   	push   %esi
80102679:	e8 f2 f3 ff ff       	call   80101a70 <iupdate>
8010267e:	83 c4 10             	add    $0x10,%esp
80102681:	e9 5d ff ff ff       	jmp    801025e3 <removeSwapFile+0x113>
    return -1;
80102686:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010268b:	eb 8e                	jmp    8010261b <removeSwapFile+0x14b>
    end_op();
8010268d:	e8 ee 10 00 00       	call   80103780 <end_op>
    return -1;
80102692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102697:	e9 7f ff ff ff       	jmp    8010261b <removeSwapFile+0x14b>
    panic("unlink: writei");
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	68 7f 93 10 80       	push   $0x8010937f
801026a4:	e8 e7 dc ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801026a9:	83 ec 0c             	sub    $0xc,%esp
801026ac:	68 6d 93 10 80       	push   $0x8010936d
801026b1:	e8 da dc ff ff       	call   80100390 <panic>
801026b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bd:	8d 76 00             	lea    0x0(%esi),%esi

801026c0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801026c0:	f3 0f 1e fb          	endbr32 
801026c4:	55                   	push   %ebp
801026c5:	89 e5                	mov    %esp,%ebp
801026c7:	56                   	push   %esi
801026c8:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801026c9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801026cc:	83 ec 14             	sub    $0x14,%esp
801026cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801026d2:	6a 06                	push   $0x6
801026d4:	68 63 93 10 80       	push   $0x80109363
801026d9:	56                   	push   %esi
801026da:	e8 01 2f 00 00       	call   801055e0 <memmove>
  itoa(p->pid, path+ 6);
801026df:	58                   	pop    %eax
801026e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801026e3:	5a                   	pop    %edx
801026e4:	50                   	push   %eax
801026e5:	ff 73 10             	pushl  0x10(%ebx)
801026e8:	e8 53 fd ff ff       	call   80102440 <itoa>

    begin_op();
801026ed:	e8 1e 10 00 00       	call   80103710 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801026f2:	6a 00                	push   $0x0
801026f4:	6a 00                	push   $0x0
801026f6:	6a 02                	push   $0x2
801026f8:	56                   	push   %esi
801026f9:	e8 32 38 00 00       	call   80105f30 <create>
  iunlock(in);
801026fe:	83 c4 14             	add    $0x14,%esp
80102701:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
80102702:	89 c6                	mov    %eax,%esi
  iunlock(in);
80102704:	e8 07 f5 ff ff       	call   80101c10 <iunlock>

  p->swapFile = filealloc();
80102709:	e8 c2 ea ff ff       	call   801011d0 <filealloc>
  if (p->swapFile == 0)
8010270e:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
80102711:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102714:	85 c0                	test   %eax,%eax
80102716:	74 32                	je     8010274a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102718:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
8010271b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010271e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102724:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102727:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010272e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102731:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102735:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102738:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010273c:	e8 3f 10 00 00       	call   80103780 <end_op>

    return 0;
}
80102741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102744:	31 c0                	xor    %eax,%eax
80102746:	5b                   	pop    %ebx
80102747:	5e                   	pop    %esi
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
    panic("no slot for files on /store");
8010274a:	83 ec 0c             	sub    $0xc,%esp
8010274d:	68 8e 93 10 80       	push   $0x8010938e
80102752:	e8 39 dc ff ff       	call   80100390 <panic>
80102757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010275e:	66 90                	xchg   %ax,%ax

80102760 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102760:	f3 0f 1e fb          	endbr32 
80102764:	55                   	push   %ebp
80102765:	89 e5                	mov    %esp,%ebp
80102767:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010276a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010276d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102770:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
80102773:	8b 55 14             	mov    0x14(%ebp),%edx
80102776:	89 55 10             	mov    %edx,0x10(%ebp)
80102779:	8b 40 7c             	mov    0x7c(%eax),%eax
8010277c:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010277f:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102780:	e9 db ec ff ff       	jmp    80101460 <filewrite>
80102785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010279a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010279d:	8b 50 7c             	mov    0x7c(%eax),%edx
801027a0:	89 4a 14             	mov    %ecx,0x14(%edx)
  return fileread(p->swapFile, buffer,  size);
801027a3:	8b 55 14             	mov    0x14(%ebp),%edx
801027a6:	89 55 10             	mov    %edx,0x10(%ebp)
801027a9:	8b 40 7c             	mov    0x7c(%eax),%eax
801027ac:	89 45 08             	mov    %eax,0x8(%ebp)
}
801027af:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801027b0:	e9 0b ec ff ff       	jmp    801013c0 <fileread>
801027b5:	66 90                	xchg   %ax,%ax
801027b7:	66 90                	xchg   %ax,%ax
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	57                   	push   %edi
801027c4:	56                   	push   %esi
801027c5:	53                   	push   %ebx
801027c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801027c9:	85 c0                	test   %eax,%eax
801027cb:	0f 84 b4 00 00 00    	je     80102885 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801027d1:	8b 70 08             	mov    0x8(%eax),%esi
801027d4:	89 c3                	mov    %eax,%ebx
801027d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801027dc:	0f 87 96 00 00 00    	ja     80102878 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801027e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ee:	66 90                	xchg   %ax,%ax
801027f0:	89 ca                	mov    %ecx,%edx
801027f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027f3:	83 e0 c0             	and    $0xffffffc0,%eax
801027f6:	3c 40                	cmp    $0x40,%al
801027f8:	75 f6                	jne    801027f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027fa:	31 ff                	xor    %edi,%edi
801027fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102801:	89 f8                	mov    %edi,%eax
80102803:	ee                   	out    %al,(%dx)
80102804:	b8 01 00 00 00       	mov    $0x1,%eax
80102809:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010280e:	ee                   	out    %al,(%dx)
8010280f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102814:	89 f0                	mov    %esi,%eax
80102816:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102817:	89 f0                	mov    %esi,%eax
80102819:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010281e:	c1 f8 08             	sar    $0x8,%eax
80102821:	ee                   	out    %al,(%dx)
80102822:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102827:	89 f8                	mov    %edi,%eax
80102829:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010282a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010282e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102833:	c1 e0 04             	shl    $0x4,%eax
80102836:	83 e0 10             	and    $0x10,%eax
80102839:	83 c8 e0             	or     $0xffffffe0,%eax
8010283c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010283d:	f6 03 04             	testb  $0x4,(%ebx)
80102840:	75 16                	jne    80102858 <idestart+0x98>
80102842:	b8 20 00 00 00       	mov    $0x20,%eax
80102847:	89 ca                	mov    %ecx,%edx
80102849:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010284a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010284d:	5b                   	pop    %ebx
8010284e:	5e                   	pop    %esi
8010284f:	5f                   	pop    %edi
80102850:	5d                   	pop    %ebp
80102851:	c3                   	ret    
80102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102858:	b8 30 00 00 00       	mov    $0x30,%eax
8010285d:	89 ca                	mov    %ecx,%edx
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102860:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102865:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102868:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010286d:	fc                   	cld    
8010286e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102870:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102873:	5b                   	pop    %ebx
80102874:	5e                   	pop    %esi
80102875:	5f                   	pop    %edi
80102876:	5d                   	pop    %ebp
80102877:	c3                   	ret    
    panic("incorrect blockno");
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	68 08 94 10 80       	push   $0x80109408
80102880:	e8 0b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102885:	83 ec 0c             	sub    $0xc,%esp
80102888:	68 ff 93 10 80       	push   $0x801093ff
8010288d:	e8 fe da ff ff       	call   80100390 <panic>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <ideinit>:
{
801028a0:	f3 0f 1e fb          	endbr32 
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801028aa:	68 1a 94 10 80       	push   $0x8010941a
801028af:	68 a0 d5 10 80       	push   $0x8010d5a0
801028b4:	e8 f7 29 00 00       	call   801052b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801028b9:	58                   	pop    %eax
801028ba:	a1 e0 70 18 80       	mov    0x801870e0,%eax
801028bf:	5a                   	pop    %edx
801028c0:	83 e8 01             	sub    $0x1,%eax
801028c3:	50                   	push   %eax
801028c4:	6a 0e                	push   $0xe
801028c6:	e8 b5 02 00 00       	call   80102b80 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028cb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028d7:	90                   	nop
801028d8:	ec                   	in     (%dx),%al
801028d9:	83 e0 c0             	and    $0xffffffc0,%eax
801028dc:	3c 40                	cmp    $0x40,%al
801028de:	75 f8                	jne    801028d8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801028e5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028ea:	ee                   	out    %al,(%dx)
801028eb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028f5:	eb 0e                	jmp    80102905 <ideinit+0x65>
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102900:	83 e9 01             	sub    $0x1,%ecx
80102903:	74 0f                	je     80102914 <ideinit+0x74>
80102905:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102906:	84 c0                	test   %al,%al
80102908:	74 f6                	je     80102900 <ideinit+0x60>
      havedisk1 = 1;
8010290a:	c7 05 80 d5 10 80 01 	movl   $0x1,0x8010d580
80102911:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102919:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010291e:	ee                   	out    %al,(%dx)
}
8010291f:	c9                   	leave  
80102920:	c3                   	ret    
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292f:	90                   	nop

80102930 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102930:	f3 0f 1e fb          	endbr32 
80102934:	55                   	push   %ebp
80102935:	89 e5                	mov    %esp,%ebp
80102937:	57                   	push   %edi
80102938:	56                   	push   %esi
80102939:	53                   	push   %ebx
8010293a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010293d:	68 a0 d5 10 80       	push   $0x8010d5a0
80102942:	e8 e9 2a 00 00       	call   80105430 <acquire>

  if((b = idequeue) == 0){
80102947:	8b 1d 84 d5 10 80    	mov    0x8010d584,%ebx
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	85 db                	test   %ebx,%ebx
80102952:	74 5f                	je     801029b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102954:	8b 43 58             	mov    0x58(%ebx),%eax
80102957:	a3 84 d5 10 80       	mov    %eax,0x8010d584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010295c:	8b 33                	mov    (%ebx),%esi
8010295e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102964:	75 2b                	jne    80102991 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102966:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010296b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010296f:	90                   	nop
80102970:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102971:	89 c1                	mov    %eax,%ecx
80102973:	83 e1 c0             	and    $0xffffffc0,%ecx
80102976:	80 f9 40             	cmp    $0x40,%cl
80102979:	75 f5                	jne    80102970 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010297b:	a8 21                	test   $0x21,%al
8010297d:	75 12                	jne    80102991 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010297f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102982:	b9 80 00 00 00       	mov    $0x80,%ecx
80102987:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010298c:	fc                   	cld    
8010298d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010298f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102991:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102994:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102997:	83 ce 02             	or     $0x2,%esi
8010299a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010299c:	53                   	push   %ebx
8010299d:	e8 0e 25 00 00       	call   80104eb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801029a2:	a1 84 d5 10 80       	mov    0x8010d584,%eax
801029a7:	83 c4 10             	add    $0x10,%esp
801029aa:	85 c0                	test   %eax,%eax
801029ac:	74 05                	je     801029b3 <ideintr+0x83>
    idestart(idequeue);
801029ae:	e8 0d fe ff ff       	call   801027c0 <idestart>
    release(&idelock);
801029b3:	83 ec 0c             	sub    $0xc,%esp
801029b6:	68 a0 d5 10 80       	push   $0x8010d5a0
801029bb:	e8 30 2b 00 00       	call   801054f0 <release>

  release(&idelock);
}
801029c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029c3:	5b                   	pop    %ebx
801029c4:	5e                   	pop    %esi
801029c5:	5f                   	pop    %edi
801029c6:	5d                   	pop    %ebp
801029c7:	c3                   	ret    
801029c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029d0:	f3 0f 1e fb          	endbr32 
801029d4:	55                   	push   %ebp
801029d5:	89 e5                	mov    %esp,%ebp
801029d7:	53                   	push   %ebx
801029d8:	83 ec 10             	sub    $0x10,%esp
801029db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801029de:	8d 43 0c             	lea    0xc(%ebx),%eax
801029e1:	50                   	push   %eax
801029e2:	e8 69 28 00 00       	call   80105250 <holdingsleep>
801029e7:	83 c4 10             	add    $0x10,%esp
801029ea:	85 c0                	test   %eax,%eax
801029ec:	0f 84 cf 00 00 00    	je     80102ac1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029f2:	8b 03                	mov    (%ebx),%eax
801029f4:	83 e0 06             	and    $0x6,%eax
801029f7:	83 f8 02             	cmp    $0x2,%eax
801029fa:	0f 84 b4 00 00 00    	je     80102ab4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102a00:	8b 53 04             	mov    0x4(%ebx),%edx
80102a03:	85 d2                	test   %edx,%edx
80102a05:	74 0d                	je     80102a14 <iderw+0x44>
80102a07:	a1 80 d5 10 80       	mov    0x8010d580,%eax
80102a0c:	85 c0                	test   %eax,%eax
80102a0e:	0f 84 93 00 00 00    	je     80102aa7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102a14:	83 ec 0c             	sub    $0xc,%esp
80102a17:	68 a0 d5 10 80       	push   $0x8010d5a0
80102a1c:	e8 0f 2a 00 00       	call   80105430 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a21:	a1 84 d5 10 80       	mov    0x8010d584,%eax
  b->qnext = 0;
80102a26:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a2d:	83 c4 10             	add    $0x10,%esp
80102a30:	85 c0                	test   %eax,%eax
80102a32:	74 6c                	je     80102aa0 <iderw+0xd0>
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a38:	89 c2                	mov    %eax,%edx
80102a3a:	8b 40 58             	mov    0x58(%eax),%eax
80102a3d:	85 c0                	test   %eax,%eax
80102a3f:	75 f7                	jne    80102a38 <iderw+0x68>
80102a41:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102a44:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102a46:	39 1d 84 d5 10 80    	cmp    %ebx,0x8010d584
80102a4c:	74 42                	je     80102a90 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a4e:	8b 03                	mov    (%ebx),%eax
80102a50:	83 e0 06             	and    $0x6,%eax
80102a53:	83 f8 02             	cmp    $0x2,%eax
80102a56:	74 23                	je     80102a7b <iderw+0xab>
80102a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop
    sleep(b, &idelock);
80102a60:	83 ec 08             	sub    $0x8,%esp
80102a63:	68 a0 d5 10 80       	push   $0x8010d5a0
80102a68:	53                   	push   %ebx
80102a69:	e8 02 22 00 00       	call   80104c70 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a6e:	8b 03                	mov    (%ebx),%eax
80102a70:	83 c4 10             	add    $0x10,%esp
80102a73:	83 e0 06             	and    $0x6,%eax
80102a76:	83 f8 02             	cmp    $0x2,%eax
80102a79:	75 e5                	jne    80102a60 <iderw+0x90>
  }


  release(&idelock);
80102a7b:	c7 45 08 a0 d5 10 80 	movl   $0x8010d5a0,0x8(%ebp)
}
80102a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a85:	c9                   	leave  
  release(&idelock);
80102a86:	e9 65 2a 00 00       	jmp    801054f0 <release>
80102a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a8f:	90                   	nop
    idestart(b);
80102a90:	89 d8                	mov    %ebx,%eax
80102a92:	e8 29 fd ff ff       	call   801027c0 <idestart>
80102a97:	eb b5                	jmp    80102a4e <iderw+0x7e>
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102aa0:	ba 84 d5 10 80       	mov    $0x8010d584,%edx
80102aa5:	eb 9d                	jmp    80102a44 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102aa7:	83 ec 0c             	sub    $0xc,%esp
80102aaa:	68 49 94 10 80       	push   $0x80109449
80102aaf:	e8 dc d8 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102ab4:	83 ec 0c             	sub    $0xc,%esp
80102ab7:	68 34 94 10 80       	push   $0x80109434
80102abc:	e8 cf d8 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102ac1:	83 ec 0c             	sub    $0xc,%esp
80102ac4:	68 1e 94 10 80       	push   $0x8010941e
80102ac9:	e8 c2 d8 ff ff       	call   80100390 <panic>
80102ace:	66 90                	xchg   %ax,%ax

80102ad0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ad5:	c7 05 14 6a 11 80 00 	movl   $0xfec00000,0x80116a14
80102adc:	00 c0 fe 
{
80102adf:	89 e5                	mov    %esp,%ebp
80102ae1:	56                   	push   %esi
80102ae2:	53                   	push   %ebx
  ioapic->reg = reg;
80102ae3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102aea:	00 00 00 
  return ioapic->data;
80102aed:	8b 15 14 6a 11 80    	mov    0x80116a14,%edx
80102af3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102af6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102afc:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102b02:	0f b6 15 40 6b 18 80 	movzbl 0x80186b40,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102b09:	c1 ee 10             	shr    $0x10,%esi
80102b0c:	89 f0                	mov    %esi,%eax
80102b0e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102b11:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102b14:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102b17:	39 c2                	cmp    %eax,%edx
80102b19:	74 16                	je     80102b31 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1b:	83 ec 0c             	sub    $0xc,%esp
80102b1e:	68 68 94 10 80       	push   $0x80109468
80102b23:	e8 88 db ff ff       	call   801006b0 <cprintf>
80102b28:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
80102b2e:	83 c4 10             	add    $0x10,%esp
80102b31:	83 c6 21             	add    $0x21,%esi
{
80102b34:	ba 10 00 00 00       	mov    $0x10,%edx
80102b39:	b8 20 00 00 00       	mov    $0x20,%eax
80102b3e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102b40:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b42:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102b44:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
80102b4a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b4d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102b53:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102b56:	8d 5a 01             	lea    0x1(%edx),%ebx
80102b59:	83 c2 02             	add    $0x2,%edx
80102b5c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102b5e:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
80102b64:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102b6b:	39 f0                	cmp    %esi,%eax
80102b6d:	75 d1                	jne    80102b40 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b72:	5b                   	pop    %ebx
80102b73:	5e                   	pop    %esi
80102b74:	5d                   	pop    %ebp
80102b75:	c3                   	ret    
80102b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b80:	f3 0f 1e fb          	endbr32 
80102b84:	55                   	push   %ebp
  ioapic->reg = reg;
80102b85:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
{
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b90:	8d 50 20             	lea    0x20(%eax),%edx
80102b93:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102b97:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b99:	8b 0d 14 6a 11 80    	mov    0x80116a14,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b9f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102ba2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ba8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102baa:	a1 14 6a 11 80       	mov    0x80116a14,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102baf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102bb2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102bb5:	5d                   	pop    %ebp
80102bb6:	c3                   	ret    
80102bb7:	66 90                	xchg   %ax,%ax
80102bb9:	66 90                	xchg   %ax,%ax
80102bbb:	66 90                	xchg   %ax,%ax
80102bbd:	66 90                	xchg   %ax,%ax
80102bbf:	90                   	nop

80102bc0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bc0:	f3 0f 1e fb          	endbr32 
80102bc4:	55                   	push   %ebp
80102bc5:	89 e5                	mov    %esp,%ebp
80102bc7:	53                   	push   %ebx
80102bc8:	83 ec 04             	sub    $0x4,%esp
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bce:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102bd3:	0f 85 af 00 00 00    	jne    80102c88 <kfree+0xc8>
80102bd9:	3d 88 85 19 80       	cmp    $0x80198588,%eax
80102bde:	0f 82 a4 00 00 00    	jb     80102c88 <kfree+0xc8>
80102be4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102bea:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102bf0:	0f 87 92 00 00 00    	ja     80102c88 <kfree+0xc8>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bf6:	83 ec 04             	sub    $0x4,%esp
80102bf9:	68 00 10 00 00       	push   $0x1000
80102bfe:	6a 01                	push   $0x1
80102c00:	50                   	push   %eax
80102c01:	e8 3a 29 00 00       	call   80105540 <memset>

  if(kmem.use_lock) 
80102c06:	a1 54 6a 11 80       	mov    0x80116a54,%eax
80102c0b:	83 c4 10             	add    $0x10,%esp
80102c0e:	85 c0                	test   %eax,%eax
80102c10:	75 4e                	jne    80102c60 <kfree+0xa0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102c12:	c1 eb 0c             	shr    $0xc,%ebx
80102c15:	8d 43 06             	lea    0x6(%ebx),%eax
80102c18:	8d 0c dd 5c 6a 11 80 	lea    -0x7fee95a4(,%ebx,8),%ecx


  if(r->refcount != 1)
80102c1f:	8b 14 c5 30 6a 11 80 	mov    -0x7fee95d0(,%eax,8),%edx
80102c26:	83 fa 01             	cmp    $0x1,%edx
80102c29:	75 6a                	jne    80102c95 <kfree+0xd5>
    panic("kfree: freeing a shared page");

  }
  

  r->next = kmem.freelist;
80102c2b:	8b 15 58 6a 11 80    	mov    0x80116a58,%edx
  r->refcount = 0;
80102c31:	c7 04 c5 30 6a 11 80 	movl   $0x0,-0x7fee95d0(,%eax,8)
80102c38:	00 00 00 00 
  kmem.freelist = r;
80102c3c:	89 0d 58 6a 11 80    	mov    %ecx,0x80116a58
  r->next = kmem.freelist;
80102c42:	89 14 c5 2c 6a 11 80 	mov    %edx,-0x7fee95d4(,%eax,8)
  if(kmem.use_lock)
80102c49:	a1 54 6a 11 80       	mov    0x80116a54,%eax
80102c4e:	85 c0                	test   %eax,%eax
80102c50:	75 26                	jne    80102c78 <kfree+0xb8>
    release(&kmem.lock);
}
80102c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c55:	c9                   	leave  
80102c56:	c3                   	ret    
80102c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c5e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
80102c63:	68 20 6a 11 80       	push   $0x80116a20
80102c68:	e8 c3 27 00 00       	call   80105430 <acquire>
80102c6d:	83 c4 10             	add    $0x10,%esp
80102c70:	eb a0                	jmp    80102c12 <kfree+0x52>
80102c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c78:	c7 45 08 20 6a 11 80 	movl   $0x80116a20,0x8(%ebp)
}
80102c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c82:	c9                   	leave  
    release(&kmem.lock);
80102c83:	e9 68 28 00 00       	jmp    801054f0 <release>
    panic("kfree");
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	68 9a 94 10 80       	push   $0x8010949a
80102c90:	e8 fb d6 ff ff       	call   80100390 <panic>
    cprintf("ref count is %d", r->refcount);
80102c95:	51                   	push   %ecx
80102c96:	51                   	push   %ecx
80102c97:	52                   	push   %edx
80102c98:	68 a0 94 10 80       	push   $0x801094a0
80102c9d:	e8 0e da ff ff       	call   801006b0 <cprintf>
    panic("kfree: freeing a shared page");
80102ca2:	c7 04 24 b0 94 10 80 	movl   $0x801094b0,(%esp)
80102ca9:	e8 e2 d6 ff ff       	call   80100390 <panic>
80102cae:	66 90                	xchg   %ax,%ax

80102cb0 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	53                   	push   %ebx
80102cb8:	83 ec 04             	sub    $0x4,%esp
80102cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102cbe:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102cc3:	0f 85 c1 00 00 00    	jne    80102d8a <kfree_nocheck+0xda>
80102cc9:	3d 88 85 19 80       	cmp    $0x80198588,%eax
80102cce:	0f 82 b6 00 00 00    	jb     80102d8a <kfree_nocheck+0xda>
80102cd4:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102cda:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102ce0:	0f 87 a4 00 00 00    	ja     80102d8a <kfree_nocheck+0xda>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ce6:	83 ec 04             	sub    $0x4,%esp
80102ce9:	68 00 10 00 00       	push   $0x1000
80102cee:	6a 01                	push   $0x1
80102cf0:	50                   	push   %eax
80102cf1:	e8 4a 28 00 00       	call   80105540 <memset>

  if(kmem.use_lock) 
80102cf6:	8b 15 54 6a 11 80    	mov    0x80116a54,%edx
80102cfc:	83 c4 10             	add    $0x10,%esp
80102cff:	85 d2                	test   %edx,%edx
80102d01:	75 35                	jne    80102d38 <kfree_nocheck+0x88>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102d03:	a1 58 6a 11 80       	mov    0x80116a58,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102d08:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102d0b:	83 c3 06             	add    $0x6,%ebx
80102d0e:	89 04 dd 2c 6a 11 80 	mov    %eax,-0x7fee95d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102d15:	8d 04 dd 2c 6a 11 80 	lea    -0x7fee95d4(,%ebx,8),%eax
  r->refcount = 0;
80102d1c:	c7 04 dd 30 6a 11 80 	movl   $0x0,-0x7fee95d0(,%ebx,8)
80102d23:	00 00 00 00 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102d27:	a3 58 6a 11 80       	mov    %eax,0x80116a58
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102d2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d2f:	c9                   	leave  
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102d38:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102d3b:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102d3e:	68 20 6a 11 80       	push   $0x80116a20
  r->next = kmem.freelist;
80102d43:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102d46:	e8 e5 26 00 00       	call   80105430 <acquire>
  r->next = kmem.freelist;
80102d4b:	a1 58 6a 11 80       	mov    0x80116a58,%eax
  if(kmem.use_lock)
80102d50:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102d53:	c7 04 dd 30 6a 11 80 	movl   $0x0,-0x7fee95d0(,%ebx,8)
80102d5a:	00 00 00 00 
  r->next = kmem.freelist;
80102d5e:	89 04 dd 2c 6a 11 80 	mov    %eax,-0x7fee95d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102d65:	8d 04 dd 2c 6a 11 80 	lea    -0x7fee95d4(,%ebx,8),%eax
80102d6c:	a3 58 6a 11 80       	mov    %eax,0x80116a58
  if(kmem.use_lock)
80102d71:	a1 54 6a 11 80       	mov    0x80116a54,%eax
80102d76:	85 c0                	test   %eax,%eax
80102d78:	74 b2                	je     80102d2c <kfree_nocheck+0x7c>
    release(&kmem.lock);
80102d7a:	c7 45 08 20 6a 11 80 	movl   $0x80116a20,0x8(%ebp)
}
80102d81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d84:	c9                   	leave  
    release(&kmem.lock);
80102d85:	e9 66 27 00 00       	jmp    801054f0 <release>
    panic("kfree_nocheck");
80102d8a:	83 ec 0c             	sub    $0xc,%esp
80102d8d:	68 cd 94 10 80       	push   $0x801094cd
80102d92:	e8 f9 d5 ff ff       	call   80100390 <panic>
80102d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <freerange>:
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102da8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102dab:	8b 75 0c             	mov    0xc(%ebp),%esi
80102dae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102daf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102db5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dbb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102dc1:	39 de                	cmp    %ebx,%esi
80102dc3:	72 1f                	jb     80102de4 <freerange+0x44>
80102dc5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102dc8:	83 ec 0c             	sub    $0xc,%esp
80102dcb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dd1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102dd7:	50                   	push   %eax
80102dd8:	e8 d3 fe ff ff       	call   80102cb0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ddd:	83 c4 10             	add    $0x10,%esp
80102de0:	39 f3                	cmp    %esi,%ebx
80102de2:	76 e4                	jbe    80102dc8 <freerange+0x28>
}
80102de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102de7:	5b                   	pop    %ebx
80102de8:	5e                   	pop    %esi
80102de9:	5d                   	pop    %ebp
80102dea:	c3                   	ret    
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop

80102df0 <kinit1>:
{
80102df0:	f3 0f 1e fb          	endbr32 
80102df4:	55                   	push   %ebp
80102df5:	89 e5                	mov    %esp,%ebp
80102df7:	56                   	push   %esi
80102df8:	53                   	push   %ebx
80102df9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102dfc:	83 ec 08             	sub    $0x8,%esp
80102dff:	68 db 94 10 80       	push   $0x801094db
80102e04:	68 20 6a 11 80       	push   $0x80116a20
80102e09:	e8 a2 24 00 00       	call   801052b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e11:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e14:	c7 05 54 6a 11 80 00 	movl   $0x0,0x80116a54
80102e1b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102e1e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e24:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e30:	39 de                	cmp    %ebx,%esi
80102e32:	72 20                	jb     80102e54 <kinit1+0x64>
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102e38:	83 ec 0c             	sub    $0xc,%esp
80102e3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102e47:	50                   	push   %eax
80102e48:	e8 63 fe ff ff       	call   80102cb0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e4d:	83 c4 10             	add    $0x10,%esp
80102e50:	39 de                	cmp    %ebx,%esi
80102e52:	73 e4                	jae    80102e38 <kinit1+0x48>
}
80102e54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e57:	5b                   	pop    %ebx
80102e58:	5e                   	pop    %esi
80102e59:	5d                   	pop    %ebp
80102e5a:	c3                   	ret    
80102e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e5f:	90                   	nop

80102e60 <kinit2>:
{
80102e60:	f3 0f 1e fb          	endbr32 
80102e64:	55                   	push   %ebp
80102e65:	89 e5                	mov    %esp,%ebp
80102e67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e81:	39 de                	cmp    %ebx,%esi
80102e83:	72 1f                	jb     80102ea4 <kinit2+0x44>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree_nocheck(p);
80102e88:	83 ec 0c             	sub    $0xc,%esp
80102e8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102e97:	50                   	push   %eax
80102e98:	e8 13 fe ff ff       	call   80102cb0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e9d:	83 c4 10             	add    $0x10,%esp
80102ea0:	39 de                	cmp    %ebx,%esi
80102ea2:	73 e4                	jae    80102e88 <kinit2+0x28>
  kmem.use_lock = 1;
80102ea4:	c7 05 54 6a 11 80 01 	movl   $0x1,0x80116a54
80102eab:	00 00 00 
}
80102eae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102eb1:	5b                   	pop    %ebx
80102eb2:	5e                   	pop    %esi
80102eb3:	5d                   	pop    %ebp
80102eb4:	c3                   	ret    
80102eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ec0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ec0:	f3 0f 1e fb          	endbr32 
80102ec4:	55                   	push   %ebp
80102ec5:	89 e5                	mov    %esp,%ebp
80102ec7:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102eca:	a1 54 6a 11 80       	mov    0x80116a54,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	75 65                	jne    80102f38 <kalloc+0x78>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102ed3:	a1 58 6a 11 80       	mov    0x80116a58,%eax
  if(r)
80102ed8:	85 c0                	test   %eax,%eax
80102eda:	74 54                	je     80102f30 <kalloc+0x70>
  {
    kmem.freelist = r->next;
80102edc:	8b 10                	mov    (%eax),%edx
80102ede:	89 15 58 6a 11 80    	mov    %edx,0x80116a58
    r->refcount = 1;
80102ee4:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102eeb:	8b 0d 54 6a 11 80    	mov    0x80116a54,%ecx
80102ef1:	85 c9                	test   %ecx,%ecx
80102ef3:	75 13                	jne    80102f08 <kalloc+0x48>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102ef5:	2d 5c 6a 11 80       	sub    $0x80116a5c,%eax
80102efa:	c1 e0 09             	shl    $0x9,%eax
80102efd:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102f02:	c9                   	leave  
80102f03:	c3                   	ret    
80102f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102f08:	83 ec 0c             	sub    $0xc,%esp
80102f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f0e:	68 20 6a 11 80       	push   $0x80116a20
80102f13:	e8 d8 25 00 00       	call   801054f0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f1b:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102f1e:	2d 5c 6a 11 80       	sub    $0x80116a5c,%eax
80102f23:	c1 e0 09             	shl    $0x9,%eax
80102f26:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
80102f2b:	eb d5                	jmp    80102f02 <kalloc+0x42>
80102f2d:	8d 76 00             	lea    0x0(%esi),%esi
}
80102f30:	c9                   	leave  
{
80102f31:	31 c0                	xor    %eax,%eax
}
80102f33:	c3                   	ret    
80102f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102f38:	83 ec 0c             	sub    $0xc,%esp
80102f3b:	68 20 6a 11 80       	push   $0x80116a20
80102f40:	e8 eb 24 00 00       	call   80105430 <acquire>
  r = kmem.freelist;
80102f45:	a1 58 6a 11 80       	mov    0x80116a58,%eax
  if(r)
80102f4a:	83 c4 10             	add    $0x10,%esp
80102f4d:	85 c0                	test   %eax,%eax
80102f4f:	75 8b                	jne    80102edc <kalloc+0x1c>
  if(kmem.use_lock)
80102f51:	8b 15 54 6a 11 80    	mov    0x80116a54,%edx
80102f57:	85 d2                	test   %edx,%edx
80102f59:	74 d5                	je     80102f30 <kalloc+0x70>
    release(&kmem.lock);
80102f5b:	83 ec 0c             	sub    $0xc,%esp
80102f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f61:	68 20 6a 11 80       	push   $0x80116a20
80102f66:	e8 85 25 00 00       	call   801054f0 <release>
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f6e:	83 c4 10             	add    $0x10,%esp
}
80102f71:	c9                   	leave  
80102f72:	c3                   	ret    
80102f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f80 <refDec>:

void
refDec(char *v)
{
80102f80:	f3 0f 1e fb          	endbr32 
80102f84:	55                   	push   %ebp
80102f85:	89 e5                	mov    %esp,%ebp
80102f87:	53                   	push   %ebx
80102f88:	83 ec 04             	sub    $0x4,%esp
  struct run *r;
  if(kmem.use_lock)
80102f8b:	8b 15 54 6a 11 80    	mov    0x80116a54,%edx
{
80102f91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102f94:	85 d2                	test   %edx,%edx
80102f96:	75 18                	jne    80102fb0 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102f98:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102f9e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102fa1:	83 2c c5 60 6a 11 80 	subl   $0x1,-0x7fee95a0(,%eax,8)
80102fa8:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102fa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fac:	c9                   	leave  
80102fad:	c3                   	ret    
80102fae:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102fb0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102fb3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102fb9:	68 20 6a 11 80       	push   $0x80116a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102fbe:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102fc1:	e8 6a 24 00 00       	call   80105430 <acquire>
  if(kmem.use_lock)
80102fc6:	a1 54 6a 11 80       	mov    0x80116a54,%eax
  r->refcount -= 1;
80102fcb:	83 2c dd 60 6a 11 80 	subl   $0x1,-0x7fee95a0(,%ebx,8)
80102fd2:	01 
  if(kmem.use_lock)
80102fd3:	83 c4 10             	add    $0x10,%esp
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 cf                	je     80102fa9 <refDec+0x29>
    release(&kmem.lock);
80102fda:	c7 45 08 20 6a 11 80 	movl   $0x80116a20,0x8(%ebp)
}
80102fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fe4:	c9                   	leave  
    release(&kmem.lock);
80102fe5:	e9 06 25 00 00       	jmp    801054f0 <release>
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ff0 <refInc>:

void
refInc(char *v)
{
80102ff0:	f3 0f 1e fb          	endbr32 
80102ff4:	55                   	push   %ebp
80102ff5:	89 e5                	mov    %esp,%ebp
80102ff7:	53                   	push   %ebx
80102ff8:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102ffb:	8b 15 54 6a 11 80    	mov    0x80116a54,%edx
{
80103001:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80103004:	85 d2                	test   %edx,%edx
80103006:	75 18                	jne    80103020 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80103008:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010300e:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80103011:	83 04 c5 60 6a 11 80 	addl   $0x1,-0x7fee95a0(,%eax,8)
80103018:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80103019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010301c:	c9                   	leave  
8010301d:	c3                   	ret    
8010301e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80103020:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80103023:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80103029:	68 20 6a 11 80       	push   $0x80116a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
8010302e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80103031:	e8 fa 23 00 00       	call   80105430 <acquire>
  if(kmem.use_lock)
80103036:	a1 54 6a 11 80       	mov    0x80116a54,%eax
  r->refcount += 1;
8010303b:	83 04 dd 60 6a 11 80 	addl   $0x1,-0x7fee95a0(,%ebx,8)
80103042:	01 
  if(kmem.use_lock)
80103043:	83 c4 10             	add    $0x10,%esp
80103046:	85 c0                	test   %eax,%eax
80103048:	74 cf                	je     80103019 <refInc+0x29>
    release(&kmem.lock);
8010304a:	c7 45 08 20 6a 11 80 	movl   $0x80116a20,0x8(%ebp)
}
80103051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103054:	c9                   	leave  
    release(&kmem.lock);
80103055:	e9 96 24 00 00       	jmp    801054f0 <release>
8010305a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103060 <getRefs>:

int
getRefs(char *v)
{
80103060:	f3 0f 1e fb          	endbr32 
80103064:	55                   	push   %ebp
80103065:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80103067:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
8010306a:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
8010306b:	05 00 00 00 80       	add    $0x80000000,%eax
80103070:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80103073:	8b 04 c5 60 6a 11 80 	mov    -0x7fee95a0(,%eax,8),%eax
8010307a:	c3                   	ret    
8010307b:	66 90                	xchg   %ax,%ax
8010307d:	66 90                	xchg   %ax,%ax
8010307f:	90                   	nop

80103080 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103080:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103084:	ba 64 00 00 00       	mov    $0x64,%edx
80103089:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010308a:	a8 01                	test   $0x1,%al
8010308c:	0f 84 be 00 00 00    	je     80103150 <kbdgetc+0xd0>
{
80103092:	55                   	push   %ebp
80103093:	ba 60 00 00 00       	mov    $0x60,%edx
80103098:	89 e5                	mov    %esp,%ebp
8010309a:	53                   	push   %ebx
8010309b:	ec                   	in     (%dx),%al
  return data;
8010309c:	8b 1d d4 d5 10 80    	mov    0x8010d5d4,%ebx
    return -1;
  data = inb(KBDATAP);
801030a2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801030a5:	3c e0                	cmp    $0xe0,%al
801030a7:	74 57                	je     80103100 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801030a9:	89 d9                	mov    %ebx,%ecx
801030ab:	83 e1 40             	and    $0x40,%ecx
801030ae:	84 c0                	test   %al,%al
801030b0:	78 5e                	js     80103110 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801030b2:	85 c9                	test   %ecx,%ecx
801030b4:	74 09                	je     801030bf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801030b6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801030b9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801030bc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801030bf:	0f b6 8a 00 96 10 80 	movzbl -0x7fef6a00(%edx),%ecx
  shift ^= togglecode[data];
801030c6:	0f b6 82 00 95 10 80 	movzbl -0x7fef6b00(%edx),%eax
  shift |= shiftcode[data];
801030cd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801030cf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801030d1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801030d3:	89 0d d4 d5 10 80    	mov    %ecx,0x8010d5d4
  c = charcode[shift & (CTL | SHIFT)][data];
801030d9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801030dc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801030df:	8b 04 85 e0 94 10 80 	mov    -0x7fef6b20(,%eax,4),%eax
801030e6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801030ea:	74 0b                	je     801030f7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801030ec:	8d 50 9f             	lea    -0x61(%eax),%edx
801030ef:	83 fa 19             	cmp    $0x19,%edx
801030f2:	77 44                	ja     80103138 <kbdgetc+0xb8>
      c += 'A' - 'a';
801030f4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801030f7:	5b                   	pop    %ebx
801030f8:	5d                   	pop    %ebp
801030f9:	c3                   	ret    
801030fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80103100:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103103:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103105:	89 1d d4 d5 10 80    	mov    %ebx,0x8010d5d4
}
8010310b:	5b                   	pop    %ebx
8010310c:	5d                   	pop    %ebp
8010310d:	c3                   	ret    
8010310e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103110:	83 e0 7f             	and    $0x7f,%eax
80103113:	85 c9                	test   %ecx,%ecx
80103115:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80103118:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010311a:	0f b6 8a 00 96 10 80 	movzbl -0x7fef6a00(%edx),%ecx
80103121:	83 c9 40             	or     $0x40,%ecx
80103124:	0f b6 c9             	movzbl %cl,%ecx
80103127:	f7 d1                	not    %ecx
80103129:	21 d9                	and    %ebx,%ecx
}
8010312b:	5b                   	pop    %ebx
8010312c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010312d:	89 0d d4 d5 10 80    	mov    %ecx,0x8010d5d4
}
80103133:	c3                   	ret    
80103134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103138:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010313b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010313e:	5b                   	pop    %ebx
8010313f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103140:	83 f9 1a             	cmp    $0x1a,%ecx
80103143:	0f 42 c2             	cmovb  %edx,%eax
}
80103146:	c3                   	ret    
80103147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314e:	66 90                	xchg   %ax,%ax
    return -1;
80103150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103155:	c3                   	ret    
80103156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010315d:	8d 76 00             	lea    0x0(%esi),%esi

80103160 <kbdintr>:

void
kbdintr(void)
{
80103160:	f3 0f 1e fb          	endbr32 
80103164:	55                   	push   %ebp
80103165:	89 e5                	mov    %esp,%ebp
80103167:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010316a:	68 80 30 10 80       	push   $0x80103080
8010316f:	e8 ec d6 ff ff       	call   80100860 <consoleintr>
}
80103174:	83 c4 10             	add    $0x10,%esp
80103177:	c9                   	leave  
80103178:	c3                   	ret    
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103180:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103184:	a1 5c 6a 18 80       	mov    0x80186a5c,%eax
80103189:	85 c0                	test   %eax,%eax
8010318b:	0f 84 c7 00 00 00    	je     80103258 <lapicinit+0xd8>
  lapic[index] = value;
80103191:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103198:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010319b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010319e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801031a5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031ab:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801031b2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801031b5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031b8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801031bf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801031c2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031c5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801031cc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801031cf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031d2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801031d9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801031dc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801031df:	8b 50 30             	mov    0x30(%eax),%edx
801031e2:	c1 ea 10             	shr    $0x10,%edx
801031e5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801031eb:	75 73                	jne    80103260 <lapicinit+0xe0>
  lapic[index] = value;
801031ed:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801031f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031fa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103201:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103204:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103207:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010320e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103211:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103214:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010321b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010321e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103221:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103228:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010322b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010322e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103235:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103238:	8b 50 20             	mov    0x20(%eax),%edx
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103240:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103246:	80 e6 10             	and    $0x10,%dh
80103249:	75 f5                	jne    80103240 <lapicinit+0xc0>
  lapic[index] = value;
8010324b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103252:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103255:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103258:	c3                   	ret    
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103260:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103267:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010326a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010326d:	e9 7b ff ff ff       	jmp    801031ed <lapicinit+0x6d>
80103272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103280 <lapicid>:

int
lapicid(void)
{
80103280:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103284:	a1 5c 6a 18 80       	mov    0x80186a5c,%eax
80103289:	85 c0                	test   %eax,%eax
8010328b:	74 0b                	je     80103298 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010328d:	8b 40 20             	mov    0x20(%eax),%eax
80103290:	c1 e8 18             	shr    $0x18,%eax
80103293:	c3                   	ret    
80103294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103298:	31 c0                	xor    %eax,%eax
}
8010329a:	c3                   	ret    
8010329b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010329f:	90                   	nop

801032a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801032a0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801032a4:	a1 5c 6a 18 80       	mov    0x80186a5c,%eax
801032a9:	85 c0                	test   %eax,%eax
801032ab:	74 0d                	je     801032ba <lapiceoi+0x1a>
  lapic[index] = value;
801032ad:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801032b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032b7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801032ba:	c3                   	ret    
801032bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop

801032c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801032c0:	f3 0f 1e fb          	endbr32 
}
801032c4:	c3                   	ret    
801032c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801032d0:	f3 0f 1e fb          	endbr32 
801032d4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d5:	b8 0f 00 00 00       	mov    $0xf,%eax
801032da:	ba 70 00 00 00       	mov    $0x70,%edx
801032df:	89 e5                	mov    %esp,%ebp
801032e1:	53                   	push   %ebx
801032e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801032e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032e8:	ee                   	out    %al,(%dx)
801032e9:	b8 0a 00 00 00       	mov    $0xa,%eax
801032ee:	ba 71 00 00 00       	mov    $0x71,%edx
801032f3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801032f4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801032f6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801032f9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801032ff:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103301:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103304:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103306:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103309:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010330c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103312:	a1 5c 6a 18 80       	mov    0x80186a5c,%eax
80103317:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010331d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103320:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103327:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010332a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010332d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103334:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103337:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010333a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103340:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103343:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103349:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010334c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103352:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103355:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010335b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010335c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010335f:	5d                   	pop    %ebp
80103360:	c3                   	ret    
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop

80103370 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103370:	f3 0f 1e fb          	endbr32 
80103374:	55                   	push   %ebp
80103375:	b8 0b 00 00 00       	mov    $0xb,%eax
8010337a:	ba 70 00 00 00       	mov    $0x70,%edx
8010337f:	89 e5                	mov    %esp,%ebp
80103381:	57                   	push   %edi
80103382:	56                   	push   %esi
80103383:	53                   	push   %ebx
80103384:	83 ec 4c             	sub    $0x4c,%esp
80103387:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103388:	ba 71 00 00 00       	mov    $0x71,%edx
8010338d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010338e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103391:	bb 70 00 00 00       	mov    $0x70,%ebx
80103396:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033a0:	31 c0                	xor    %eax,%eax
801033a2:	89 da                	mov    %ebx,%edx
801033a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033a5:	b9 71 00 00 00       	mov    $0x71,%ecx
801033aa:	89 ca                	mov    %ecx,%edx
801033ac:	ec                   	in     (%dx),%al
801033ad:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033b0:	89 da                	mov    %ebx,%edx
801033b2:	b8 02 00 00 00       	mov    $0x2,%eax
801033b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b8:	89 ca                	mov    %ecx,%edx
801033ba:	ec                   	in     (%dx),%al
801033bb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033be:	89 da                	mov    %ebx,%edx
801033c0:	b8 04 00 00 00       	mov    $0x4,%eax
801033c5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c6:	89 ca                	mov    %ecx,%edx
801033c8:	ec                   	in     (%dx),%al
801033c9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033cc:	89 da                	mov    %ebx,%edx
801033ce:	b8 07 00 00 00       	mov    $0x7,%eax
801033d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033d4:	89 ca                	mov    %ecx,%edx
801033d6:	ec                   	in     (%dx),%al
801033d7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033da:	89 da                	mov    %ebx,%edx
801033dc:	b8 08 00 00 00       	mov    $0x8,%eax
801033e1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033e2:	89 ca                	mov    %ecx,%edx
801033e4:	ec                   	in     (%dx),%al
801033e5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033e7:	89 da                	mov    %ebx,%edx
801033e9:	b8 09 00 00 00       	mov    $0x9,%eax
801033ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033ef:	89 ca                	mov    %ecx,%edx
801033f1:	ec                   	in     (%dx),%al
801033f2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033f4:	89 da                	mov    %ebx,%edx
801033f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801033fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033fc:	89 ca                	mov    %ecx,%edx
801033fe:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801033ff:	84 c0                	test   %al,%al
80103401:	78 9d                	js     801033a0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103403:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103407:	89 fa                	mov    %edi,%edx
80103409:	0f b6 fa             	movzbl %dl,%edi
8010340c:	89 f2                	mov    %esi,%edx
8010340e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103411:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103415:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103418:	89 da                	mov    %ebx,%edx
8010341a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010341d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103420:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103424:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103427:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010342a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010342e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103431:	31 c0                	xor    %eax,%eax
80103433:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103434:	89 ca                	mov    %ecx,%edx
80103436:	ec                   	in     (%dx),%al
80103437:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010343a:	89 da                	mov    %ebx,%edx
8010343c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010343f:	b8 02 00 00 00       	mov    $0x2,%eax
80103444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103445:	89 ca                	mov    %ecx,%edx
80103447:	ec                   	in     (%dx),%al
80103448:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010344b:	89 da                	mov    %ebx,%edx
8010344d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103450:	b8 04 00 00 00       	mov    $0x4,%eax
80103455:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103456:	89 ca                	mov    %ecx,%edx
80103458:	ec                   	in     (%dx),%al
80103459:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010345c:	89 da                	mov    %ebx,%edx
8010345e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103461:	b8 07 00 00 00       	mov    $0x7,%eax
80103466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103467:	89 ca                	mov    %ecx,%edx
80103469:	ec                   	in     (%dx),%al
8010346a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010346d:	89 da                	mov    %ebx,%edx
8010346f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103472:	b8 08 00 00 00       	mov    $0x8,%eax
80103477:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103478:	89 ca                	mov    %ecx,%edx
8010347a:	ec                   	in     (%dx),%al
8010347b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010347e:	89 da                	mov    %ebx,%edx
80103480:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103483:	b8 09 00 00 00       	mov    $0x9,%eax
80103488:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103489:	89 ca                	mov    %ecx,%edx
8010348b:	ec                   	in     (%dx),%al
8010348c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010348f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103495:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103498:	6a 18                	push   $0x18
8010349a:	50                   	push   %eax
8010349b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010349e:	50                   	push   %eax
8010349f:	e8 ec 20 00 00       	call   80105590 <memcmp>
801034a4:	83 c4 10             	add    $0x10,%esp
801034a7:	85 c0                	test   %eax,%eax
801034a9:	0f 85 f1 fe ff ff    	jne    801033a0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801034af:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801034b3:	75 78                	jne    8010352d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801034b5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801034b8:	89 c2                	mov    %eax,%edx
801034ba:	83 e0 0f             	and    $0xf,%eax
801034bd:	c1 ea 04             	shr    $0x4,%edx
801034c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034c6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801034c9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801034cc:	89 c2                	mov    %eax,%edx
801034ce:	83 e0 0f             	and    $0xf,%eax
801034d1:	c1 ea 04             	shr    $0x4,%edx
801034d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034da:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801034dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801034e0:	89 c2                	mov    %eax,%edx
801034e2:	83 e0 0f             	and    $0xf,%eax
801034e5:	c1 ea 04             	shr    $0x4,%edx
801034e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801034ee:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801034f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801034f4:	89 c2                	mov    %eax,%edx
801034f6:	83 e0 0f             	and    $0xf,%eax
801034f9:	c1 ea 04             	shr    $0x4,%edx
801034fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801034ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103502:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103505:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103508:	89 c2                	mov    %eax,%edx
8010350a:	83 e0 0f             	and    $0xf,%eax
8010350d:	c1 ea 04             	shr    $0x4,%edx
80103510:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103513:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103516:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103519:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010351c:	89 c2                	mov    %eax,%edx
8010351e:	83 e0 0f             	and    $0xf,%eax
80103521:	c1 ea 04             	shr    $0x4,%edx
80103524:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103527:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010352a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010352d:	8b 75 08             	mov    0x8(%ebp),%esi
80103530:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103533:	89 06                	mov    %eax,(%esi)
80103535:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103538:	89 46 04             	mov    %eax,0x4(%esi)
8010353b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010353e:	89 46 08             	mov    %eax,0x8(%esi)
80103541:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103544:	89 46 0c             	mov    %eax,0xc(%esi)
80103547:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010354a:	89 46 10             	mov    %eax,0x10(%esi)
8010354d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103550:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103553:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010355a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010355d:	5b                   	pop    %ebx
8010355e:	5e                   	pop    %esi
8010355f:	5f                   	pop    %edi
80103560:	5d                   	pop    %ebp
80103561:	c3                   	ret    
80103562:	66 90                	xchg   %ax,%ax
80103564:	66 90                	xchg   %ax,%ax
80103566:	66 90                	xchg   %ax,%ax
80103568:	66 90                	xchg   %ax,%ax
8010356a:	66 90                	xchg   %ax,%ax
8010356c:	66 90                	xchg   %ax,%ax
8010356e:	66 90                	xchg   %ax,%ax

80103570 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103570:	8b 0d a8 6a 18 80    	mov    0x80186aa8,%ecx
80103576:	85 c9                	test   %ecx,%ecx
80103578:	0f 8e 8a 00 00 00    	jle    80103608 <install_trans+0x98>
{
8010357e:	55                   	push   %ebp
8010357f:	89 e5                	mov    %esp,%ebp
80103581:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103582:	31 ff                	xor    %edi,%edi
{
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103590:	a1 94 6a 18 80       	mov    0x80186a94,%eax
80103595:	83 ec 08             	sub    $0x8,%esp
80103598:	01 f8                	add    %edi,%eax
8010359a:	83 c0 01             	add    $0x1,%eax
8010359d:	50                   	push   %eax
8010359e:	ff 35 a4 6a 18 80    	pushl  0x80186aa4
801035a4:	e8 27 cb ff ff       	call   801000d0 <bread>
801035a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801035ab:	58                   	pop    %eax
801035ac:	5a                   	pop    %edx
801035ad:	ff 34 bd ac 6a 18 80 	pushl  -0x7fe79554(,%edi,4)
801035b4:	ff 35 a4 6a 18 80    	pushl  0x80186aa4
  for (tail = 0; tail < log.lh.n; tail++) {
801035ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801035bd:	e8 0e cb ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801035c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801035c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801035c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801035ca:	68 00 02 00 00       	push   $0x200
801035cf:	50                   	push   %eax
801035d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801035d3:	50                   	push   %eax
801035d4:	e8 07 20 00 00       	call   801055e0 <memmove>
    bwrite(dbuf);  // write dst to disk
801035d9:	89 1c 24             	mov    %ebx,(%esp)
801035dc:	e8 cf cb ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801035e1:	89 34 24             	mov    %esi,(%esp)
801035e4:	e8 07 cc ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801035e9:	89 1c 24             	mov    %ebx,(%esp)
801035ec:	e8 ff cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801035f1:	83 c4 10             	add    $0x10,%esp
801035f4:	39 3d a8 6a 18 80    	cmp    %edi,0x80186aa8
801035fa:	7f 94                	jg     80103590 <install_trans+0x20>
  }
}
801035fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ff:	5b                   	pop    %ebx
80103600:	5e                   	pop    %esi
80103601:	5f                   	pop    %edi
80103602:	5d                   	pop    %ebp
80103603:	c3                   	ret    
80103604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103608:	c3                   	ret    
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103610 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
80103614:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103617:	ff 35 94 6a 18 80    	pushl  0x80186a94
8010361d:	ff 35 a4 6a 18 80    	pushl  0x80186aa4
80103623:	e8 a8 ca ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103628:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010362b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010362d:	a1 a8 6a 18 80       	mov    0x80186aa8,%eax
80103632:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103635:	85 c0                	test   %eax,%eax
80103637:	7e 19                	jle    80103652 <write_head+0x42>
80103639:	31 d2                	xor    %edx,%edx
8010363b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010363f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103640:	8b 0c 95 ac 6a 18 80 	mov    -0x7fe79554(,%edx,4),%ecx
80103647:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010364b:	83 c2 01             	add    $0x1,%edx
8010364e:	39 d0                	cmp    %edx,%eax
80103650:	75 ee                	jne    80103640 <write_head+0x30>
  }
  bwrite(buf);
80103652:	83 ec 0c             	sub    $0xc,%esp
80103655:	53                   	push   %ebx
80103656:	e8 55 cb ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010365b:	89 1c 24             	mov    %ebx,(%esp)
8010365e:	e8 8d cb ff ff       	call   801001f0 <brelse>
}
80103663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103666:	83 c4 10             	add    $0x10,%esp
80103669:	c9                   	leave  
8010366a:	c3                   	ret    
8010366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop

80103670 <initlog>:
{
80103670:	f3 0f 1e fb          	endbr32 
80103674:	55                   	push   %ebp
80103675:	89 e5                	mov    %esp,%ebp
80103677:	53                   	push   %ebx
80103678:	83 ec 2c             	sub    $0x2c,%esp
8010367b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010367e:	68 00 97 10 80       	push   $0x80109700
80103683:	68 60 6a 18 80       	push   $0x80186a60
80103688:	e8 23 1c 00 00       	call   801052b0 <initlock>
  readsb(dev, &sb);
8010368d:	58                   	pop    %eax
8010368e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103691:	5a                   	pop    %edx
80103692:	50                   	push   %eax
80103693:	53                   	push   %ebx
80103694:	e8 37 e2 ff ff       	call   801018d0 <readsb>
  log.start = sb.logstart;
80103699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010369c:	59                   	pop    %ecx
  log.dev = dev;
8010369d:	89 1d a4 6a 18 80    	mov    %ebx,0x80186aa4
  log.size = sb.nlog;
801036a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801036a6:	a3 94 6a 18 80       	mov    %eax,0x80186a94
  log.size = sb.nlog;
801036ab:	89 15 98 6a 18 80    	mov    %edx,0x80186a98
  struct buf *buf = bread(log.dev, log.start);
801036b1:	5a                   	pop    %edx
801036b2:	50                   	push   %eax
801036b3:	53                   	push   %ebx
801036b4:	e8 17 ca ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801036b9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801036bc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801036bf:	89 0d a8 6a 18 80    	mov    %ecx,0x80186aa8
  for (i = 0; i < log.lh.n; i++) {
801036c5:	85 c9                	test   %ecx,%ecx
801036c7:	7e 19                	jle    801036e2 <initlog+0x72>
801036c9:	31 d2                	xor    %edx,%edx
801036cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801036d0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801036d4:	89 1c 95 ac 6a 18 80 	mov    %ebx,-0x7fe79554(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801036db:	83 c2 01             	add    $0x1,%edx
801036de:	39 d1                	cmp    %edx,%ecx
801036e0:	75 ee                	jne    801036d0 <initlog+0x60>
  brelse(buf);
801036e2:	83 ec 0c             	sub    $0xc,%esp
801036e5:	50                   	push   %eax
801036e6:	e8 05 cb ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801036eb:	e8 80 fe ff ff       	call   80103570 <install_trans>
  log.lh.n = 0;
801036f0:	c7 05 a8 6a 18 80 00 	movl   $0x0,0x80186aa8
801036f7:	00 00 00 
  write_head(); // clear the log
801036fa:	e8 11 ff ff ff       	call   80103610 <write_head>
}
801036ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103702:	83 c4 10             	add    $0x10,%esp
80103705:	c9                   	leave  
80103706:	c3                   	ret    
80103707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010370e:	66 90                	xchg   %ax,%ax

80103710 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103710:	f3 0f 1e fb          	endbr32 
80103714:	55                   	push   %ebp
80103715:	89 e5                	mov    %esp,%ebp
80103717:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010371a:	68 60 6a 18 80       	push   $0x80186a60
8010371f:	e8 0c 1d 00 00       	call   80105430 <acquire>
80103724:	83 c4 10             	add    $0x10,%esp
80103727:	eb 1c                	jmp    80103745 <begin_op+0x35>
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	68 60 6a 18 80       	push   $0x80186a60
80103738:	68 60 6a 18 80       	push   $0x80186a60
8010373d:	e8 2e 15 00 00       	call   80104c70 <sleep>
80103742:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103745:	a1 a0 6a 18 80       	mov    0x80186aa0,%eax
8010374a:	85 c0                	test   %eax,%eax
8010374c:	75 e2                	jne    80103730 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010374e:	a1 9c 6a 18 80       	mov    0x80186a9c,%eax
80103753:	8b 15 a8 6a 18 80    	mov    0x80186aa8,%edx
80103759:	83 c0 01             	add    $0x1,%eax
8010375c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010375f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103762:	83 fa 1e             	cmp    $0x1e,%edx
80103765:	7f c9                	jg     80103730 <begin_op+0x20>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103767:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010376a:	a3 9c 6a 18 80       	mov    %eax,0x80186a9c
      release(&log.lock);
8010376f:	68 60 6a 18 80       	push   $0x80186a60
80103774:	e8 77 1d 00 00       	call   801054f0 <release>
      break;
    }
  }
}
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	c9                   	leave  
8010377d:	c3                   	ret    
8010377e:	66 90                	xchg   %ax,%ax

80103780 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103780:	f3 0f 1e fb          	endbr32 
80103784:	55                   	push   %ebp
80103785:	89 e5                	mov    %esp,%ebp
80103787:	57                   	push   %edi
80103788:	56                   	push   %esi
80103789:	53                   	push   %ebx
8010378a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010378d:	68 60 6a 18 80       	push   $0x80186a60
80103792:	e8 99 1c 00 00       	call   80105430 <acquire>
  log.outstanding -= 1;
80103797:	a1 9c 6a 18 80       	mov    0x80186a9c,%eax
  if(log.committing)
8010379c:	8b 35 a0 6a 18 80    	mov    0x80186aa0,%esi
801037a2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801037a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801037a8:	89 1d 9c 6a 18 80    	mov    %ebx,0x80186a9c
  if(log.committing)
801037ae:	85 f6                	test   %esi,%esi
801037b0:	0f 85 1e 01 00 00    	jne    801038d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801037b6:	85 db                	test   %ebx,%ebx
801037b8:	0f 85 f2 00 00 00    	jne    801038b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801037be:	c7 05 a0 6a 18 80 01 	movl   $0x1,0x80186aa0
801037c5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	68 60 6a 18 80       	push   $0x80186a60
801037d0:	e8 1b 1d 00 00       	call   801054f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801037d5:	8b 0d a8 6a 18 80    	mov    0x80186aa8,%ecx
801037db:	83 c4 10             	add    $0x10,%esp
801037de:	85 c9                	test   %ecx,%ecx
801037e0:	7f 3e                	jg     80103820 <end_op+0xa0>
    acquire(&log.lock);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	68 60 6a 18 80       	push   $0x80186a60
801037ea:	e8 41 1c 00 00       	call   80105430 <acquire>
    wakeup(&log);
801037ef:	c7 04 24 60 6a 18 80 	movl   $0x80186a60,(%esp)
    log.committing = 0;
801037f6:	c7 05 a0 6a 18 80 00 	movl   $0x0,0x80186aa0
801037fd:	00 00 00 
    wakeup(&log);
80103800:	e8 ab 16 00 00       	call   80104eb0 <wakeup>
    release(&log.lock);
80103805:	c7 04 24 60 6a 18 80 	movl   $0x80186a60,(%esp)
8010380c:	e8 df 1c 00 00       	call   801054f0 <release>
80103811:	83 c4 10             	add    $0x10,%esp
}
80103814:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103817:	5b                   	pop    %ebx
80103818:	5e                   	pop    %esi
80103819:	5f                   	pop    %edi
8010381a:	5d                   	pop    %ebp
8010381b:	c3                   	ret    
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103820:	a1 94 6a 18 80       	mov    0x80186a94,%eax
80103825:	83 ec 08             	sub    $0x8,%esp
80103828:	01 d8                	add    %ebx,%eax
8010382a:	83 c0 01             	add    $0x1,%eax
8010382d:	50                   	push   %eax
8010382e:	ff 35 a4 6a 18 80    	pushl  0x80186aa4
80103834:	e8 97 c8 ff ff       	call   801000d0 <bread>
80103839:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010383b:	58                   	pop    %eax
8010383c:	5a                   	pop    %edx
8010383d:	ff 34 9d ac 6a 18 80 	pushl  -0x7fe79554(,%ebx,4)
80103844:	ff 35 a4 6a 18 80    	pushl  0x80186aa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010384a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010384d:	e8 7e c8 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103852:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103855:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103857:	8d 40 5c             	lea    0x5c(%eax),%eax
8010385a:	68 00 02 00 00       	push   $0x200
8010385f:	50                   	push   %eax
80103860:	8d 46 5c             	lea    0x5c(%esi),%eax
80103863:	50                   	push   %eax
80103864:	e8 77 1d 00 00       	call   801055e0 <memmove>
    bwrite(to);  // write the log
80103869:	89 34 24             	mov    %esi,(%esp)
8010386c:	e8 3f c9 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103871:	89 3c 24             	mov    %edi,(%esp)
80103874:	e8 77 c9 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103879:	89 34 24             	mov    %esi,(%esp)
8010387c:	e8 6f c9 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103881:	83 c4 10             	add    $0x10,%esp
80103884:	3b 1d a8 6a 18 80    	cmp    0x80186aa8,%ebx
8010388a:	7c 94                	jl     80103820 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010388c:	e8 7f fd ff ff       	call   80103610 <write_head>
    install_trans(); // Now install writes to home locations
80103891:	e8 da fc ff ff       	call   80103570 <install_trans>
    log.lh.n = 0;
80103896:	c7 05 a8 6a 18 80 00 	movl   $0x0,0x80186aa8
8010389d:	00 00 00 
    write_head();    // Erase the transaction from the log
801038a0:	e8 6b fd ff ff       	call   80103610 <write_head>
801038a5:	e9 38 ff ff ff       	jmp    801037e2 <end_op+0x62>
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 60 6a 18 80       	push   $0x80186a60
801038b8:	e8 f3 15 00 00       	call   80104eb0 <wakeup>
  release(&log.lock);
801038bd:	c7 04 24 60 6a 18 80 	movl   $0x80186a60,(%esp)
801038c4:	e8 27 1c 00 00       	call   801054f0 <release>
801038c9:	83 c4 10             	add    $0x10,%esp
}
801038cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038cf:	5b                   	pop    %ebx
801038d0:	5e                   	pop    %esi
801038d1:	5f                   	pop    %edi
801038d2:	5d                   	pop    %ebp
801038d3:	c3                   	ret    
    panic("log.committing");
801038d4:	83 ec 0c             	sub    $0xc,%esp
801038d7:	68 04 97 10 80       	push   $0x80109704
801038dc:	e8 af ca ff ff       	call   80100390 <panic>
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop

801038f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	53                   	push   %ebx
801038f8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801038fb:	8b 15 a8 6a 18 80    	mov    0x80186aa8,%edx
{
80103901:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103904:	83 fa 1d             	cmp    $0x1d,%edx
80103907:	0f 8f 91 00 00 00    	jg     8010399e <log_write+0xae>
8010390d:	a1 98 6a 18 80       	mov    0x80186a98,%eax
80103912:	83 e8 01             	sub    $0x1,%eax
80103915:	39 c2                	cmp    %eax,%edx
80103917:	0f 8d 81 00 00 00    	jge    8010399e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010391d:	a1 9c 6a 18 80       	mov    0x80186a9c,%eax
80103922:	85 c0                	test   %eax,%eax
80103924:	0f 8e 81 00 00 00    	jle    801039ab <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	68 60 6a 18 80       	push   $0x80186a60
80103932:	e8 f9 1a 00 00       	call   80105430 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103937:	8b 15 a8 6a 18 80    	mov    0x80186aa8,%edx
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	85 d2                	test   %edx,%edx
80103942:	7e 4e                	jle    80103992 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103944:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103947:	31 c0                	xor    %eax,%eax
80103949:	eb 0c                	jmp    80103957 <log_write+0x67>
8010394b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010394f:	90                   	nop
80103950:	83 c0 01             	add    $0x1,%eax
80103953:	39 c2                	cmp    %eax,%edx
80103955:	74 29                	je     80103980 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103957:	39 0c 85 ac 6a 18 80 	cmp    %ecx,-0x7fe79554(,%eax,4)
8010395e:	75 f0                	jne    80103950 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103960:	89 0c 85 ac 6a 18 80 	mov    %ecx,-0x7fe79554(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103967:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010396a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010396d:	c7 45 08 60 6a 18 80 	movl   $0x80186a60,0x8(%ebp)
}
80103974:	c9                   	leave  
  release(&log.lock);
80103975:	e9 76 1b 00 00       	jmp    801054f0 <release>
8010397a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103980:	89 0c 95 ac 6a 18 80 	mov    %ecx,-0x7fe79554(,%edx,4)
    log.lh.n++;
80103987:	83 c2 01             	add    $0x1,%edx
8010398a:	89 15 a8 6a 18 80    	mov    %edx,0x80186aa8
80103990:	eb d5                	jmp    80103967 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103992:	8b 43 08             	mov    0x8(%ebx),%eax
80103995:	a3 ac 6a 18 80       	mov    %eax,0x80186aac
  if (i == log.lh.n)
8010399a:	75 cb                	jne    80103967 <log_write+0x77>
8010399c:	eb e9                	jmp    80103987 <log_write+0x97>
    panic("too big a transaction");
8010399e:	83 ec 0c             	sub    $0xc,%esp
801039a1:	68 13 97 10 80       	push   $0x80109713
801039a6:	e8 e5 c9 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801039ab:	83 ec 0c             	sub    $0xc,%esp
801039ae:	68 29 97 10 80       	push   $0x80109729
801039b3:	e8 d8 c9 ff ff       	call   80100390 <panic>
801039b8:	66 90                	xchg   %ax,%ax
801039ba:	66 90                	xchg   %ax,%ax
801039bc:	66 90                	xchg   %ax,%ax
801039be:	66 90                	xchg   %ax,%ax

801039c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801039c7:	e8 84 0a 00 00       	call   80104450 <cpuid>
801039cc:	89 c3                	mov    %eax,%ebx
801039ce:	e8 7d 0a 00 00       	call   80104450 <cpuid>
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	53                   	push   %ebx
801039d7:	50                   	push   %eax
801039d8:	68 44 97 10 80       	push   $0x80109744
801039dd:	e8 ce cc ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801039e2:	e8 49 2e 00 00       	call   80106830 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801039e7:	e8 f4 09 00 00       	call   801043e0 <mycpu>
801039ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801039ee:	b8 01 00 00 00       	mov    $0x1,%eax
801039f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801039fa:	e8 51 0f 00 00       	call   80104950 <scheduler>
801039ff:	90                   	nop

80103a00 <mpenter>:
{
80103a00:	f3 0f 1e fb          	endbr32 
80103a04:	55                   	push   %ebp
80103a05:	89 e5                	mov    %esp,%ebp
80103a07:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103a0a:	e8 b1 3f 00 00       	call   801079c0 <switchkvm>
  seginit();
80103a0f:	e8 1c 3f 00 00       	call   80107930 <seginit>
  lapicinit();
80103a14:	e8 67 f7 ff ff       	call   80103180 <lapicinit>
  mpmain();
80103a19:	e8 a2 ff ff ff       	call   801039c0 <mpmain>
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <main>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103a28:	83 e4 f0             	and    $0xfffffff0,%esp
80103a2b:	ff 71 fc             	pushl  -0x4(%ecx)
80103a2e:	55                   	push   %ebp
80103a2f:	89 e5                	mov    %esp,%ebp
80103a31:	53                   	push   %ebx
80103a32:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a33:	83 ec 08             	sub    $0x8,%esp
80103a36:	68 00 00 40 80       	push   $0x80400000
80103a3b:	68 88 85 19 80       	push   $0x80198588
80103a40:	e8 ab f3 ff ff       	call   80102df0 <kinit1>
  kvmalloc();      // kernel page table
80103a45:	e8 26 49 00 00       	call   80108370 <kvmalloc>
  mpinit();        // detect other processors
80103a4a:	e8 81 01 00 00       	call   80103bd0 <mpinit>
  lapicinit();     // interrupt controller
80103a4f:	e8 2c f7 ff ff       	call   80103180 <lapicinit>
  seginit();       // segment descriptors
80103a54:	e8 d7 3e 00 00       	call   80107930 <seginit>
  picinit();       // disable pic
80103a59:	e8 52 03 00 00       	call   80103db0 <picinit>
  ioapicinit();    // another interrupt controller
80103a5e:	e8 6d f0 ff ff       	call   80102ad0 <ioapicinit>
  consoleinit();   // console hardware
80103a63:	e8 c8 cf ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103a68:	e8 e3 30 00 00       	call   80106b50 <uartinit>
  pinit();         // process table
80103a6d:	e8 4e 09 00 00       	call   801043c0 <pinit>
  tvinit();        // trap vectors
80103a72:	e8 39 2d 00 00       	call   801067b0 <tvinit>
  binit();         // buffer cache
80103a77:	e8 c4 c5 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103a7c:	e8 2f d7 ff ff       	call   801011b0 <fileinit>
  ideinit();       // disk 
80103a81:	e8 1a ee ff ff       	call   801028a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a86:	83 c4 0c             	add    $0xc,%esp
80103a89:	68 8a 00 00 00       	push   $0x8a
80103a8e:	68 8c d4 10 80       	push   $0x8010d48c
80103a93:	68 00 70 00 80       	push   $0x80007000
80103a98:	e8 43 1b 00 00       	call   801055e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103a9d:	83 c4 10             	add    $0x10,%esp
80103aa0:	69 05 e0 70 18 80 b0 	imul   $0xb0,0x801870e0,%eax
80103aa7:	00 00 00 
80103aaa:	05 60 6b 18 80       	add    $0x80186b60,%eax
80103aaf:	3d 60 6b 18 80       	cmp    $0x80186b60,%eax
80103ab4:	76 7a                	jbe    80103b30 <main+0x110>
80103ab6:	bb 60 6b 18 80       	mov    $0x80186b60,%ebx
80103abb:	eb 1c                	jmp    80103ad9 <main+0xb9>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
80103ac0:	69 05 e0 70 18 80 b0 	imul   $0xb0,0x801870e0,%eax
80103ac7:	00 00 00 
80103aca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103ad0:	05 60 6b 18 80       	add    $0x80186b60,%eax
80103ad5:	39 c3                	cmp    %eax,%ebx
80103ad7:	73 57                	jae    80103b30 <main+0x110>
    if(c == mycpu())  // We've started already.
80103ad9:	e8 02 09 00 00       	call   801043e0 <mycpu>
80103ade:	39 c3                	cmp    %eax,%ebx
80103ae0:	74 de                	je     80103ac0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ae2:	e8 d9 f3 ff ff       	call   80102ec0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103ae7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103aea:	c7 05 f8 6f 00 80 00 	movl   $0x80103a00,0x80006ff8
80103af1:	3a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103af4:	c7 05 f4 6f 00 80 00 	movl   $0x10c000,0x80006ff4
80103afb:	c0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103afe:	05 00 10 00 00       	add    $0x1000,%eax
80103b03:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103b08:	0f b6 03             	movzbl (%ebx),%eax
80103b0b:	68 00 70 00 00       	push   $0x7000
80103b10:	50                   	push   %eax
80103b11:	e8 ba f7 ff ff       	call   801032d0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b16:	83 c4 10             	add    $0x10,%esp
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b20:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103b26:	85 c0                	test   %eax,%eax
80103b28:	74 f6                	je     80103b20 <main+0x100>
80103b2a:	eb 94                	jmp    80103ac0 <main+0xa0>
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103b30:	83 ec 08             	sub    $0x8,%esp
80103b33:	68 00 00 00 8e       	push   $0x8e000000
80103b38:	68 00 00 40 80       	push   $0x80400000
80103b3d:	e8 1e f3 ff ff       	call   80102e60 <kinit2>
  userinit();      // first user process
80103b42:	e8 59 09 00 00       	call   801044a0 <userinit>
  mpmain();        // finish this processor's setup
80103b47:	e8 74 fe ff ff       	call   801039c0 <mpmain>
80103b4c:	66 90                	xchg   %ax,%ax
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103b55:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103b5b:	53                   	push   %ebx
  e = addr+len;
80103b5c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103b5f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103b62:	39 de                	cmp    %ebx,%esi
80103b64:	72 10                	jb     80103b76 <mpsearch1+0x26>
80103b66:	eb 50                	jmp    80103bb8 <mpsearch1+0x68>
80103b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6f:	90                   	nop
80103b70:	89 fe                	mov    %edi,%esi
80103b72:	39 fb                	cmp    %edi,%ebx
80103b74:	76 42                	jbe    80103bb8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b76:	83 ec 04             	sub    $0x4,%esp
80103b79:	8d 7e 10             	lea    0x10(%esi),%edi
80103b7c:	6a 04                	push   $0x4
80103b7e:	68 58 97 10 80       	push   $0x80109758
80103b83:	56                   	push   %esi
80103b84:	e8 07 1a 00 00       	call   80105590 <memcmp>
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	85 c0                	test   %eax,%eax
80103b8e:	75 e0                	jne    80103b70 <mpsearch1+0x20>
80103b90:	89 f2                	mov    %esi,%edx
80103b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103b98:	0f b6 0a             	movzbl (%edx),%ecx
80103b9b:	83 c2 01             	add    $0x1,%edx
80103b9e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103ba0:	39 fa                	cmp    %edi,%edx
80103ba2:	75 f4                	jne    80103b98 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ba4:	84 c0                	test   %al,%al
80103ba6:	75 c8                	jne    80103b70 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bab:	89 f0                	mov    %esi,%eax
80103bad:	5b                   	pop    %ebx
80103bae:	5e                   	pop    %esi
80103baf:	5f                   	pop    %edi
80103bb0:	5d                   	pop    %ebp
80103bb1:	c3                   	ret    
80103bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103bbb:	31 f6                	xor    %esi,%esi
}
80103bbd:	5b                   	pop    %ebx
80103bbe:	89 f0                	mov    %esi,%eax
80103bc0:	5e                   	pop    %esi
80103bc1:	5f                   	pop    %edi
80103bc2:	5d                   	pop    %ebp
80103bc3:	c3                   	ret    
80103bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bcf:	90                   	nop

80103bd0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bdd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103be4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103beb:	c1 e0 08             	shl    $0x8,%eax
80103bee:	09 d0                	or     %edx,%eax
80103bf0:	c1 e0 04             	shl    $0x4,%eax
80103bf3:	75 1b                	jne    80103c10 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103bf5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103bfc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103c03:	c1 e0 08             	shl    $0x8,%eax
80103c06:	09 d0                	or     %edx,%eax
80103c08:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103c0b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103c10:	ba 00 04 00 00       	mov    $0x400,%edx
80103c15:	e8 36 ff ff ff       	call   80103b50 <mpsearch1>
80103c1a:	89 c6                	mov    %eax,%esi
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	0f 84 4c 01 00 00    	je     80103d70 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c24:	8b 5e 04             	mov    0x4(%esi),%ebx
80103c27:	85 db                	test   %ebx,%ebx
80103c29:	0f 84 61 01 00 00    	je     80103d90 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103c2f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c32:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103c38:	6a 04                	push   $0x4
80103c3a:	68 5d 97 10 80       	push   $0x8010975d
80103c3f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c43:	e8 48 19 00 00       	call   80105590 <memcmp>
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	85 c0                	test   %eax,%eax
80103c4d:	0f 85 3d 01 00 00    	jne    80103d90 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103c53:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103c5a:	3c 01                	cmp    $0x1,%al
80103c5c:	74 08                	je     80103c66 <mpinit+0x96>
80103c5e:	3c 04                	cmp    $0x4,%al
80103c60:	0f 85 2a 01 00 00    	jne    80103d90 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103c66:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103c6d:	66 85 d2             	test   %dx,%dx
80103c70:	74 26                	je     80103c98 <mpinit+0xc8>
80103c72:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103c75:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103c77:	31 d2                	xor    %edx,%edx
80103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103c80:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103c87:	83 c0 01             	add    $0x1,%eax
80103c8a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103c8c:	39 f8                	cmp    %edi,%eax
80103c8e:	75 f0                	jne    80103c80 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103c90:	84 d2                	test   %dl,%dl
80103c92:	0f 85 f8 00 00 00    	jne    80103d90 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103c98:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103c9e:	a3 5c 6a 18 80       	mov    %eax,0x80186a5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ca3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103ca9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103cb0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cb5:	03 55 e4             	add    -0x1c(%ebp),%edx
80103cb8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop
80103cc0:	39 c2                	cmp    %eax,%edx
80103cc2:	76 15                	jbe    80103cd9 <mpinit+0x109>
    switch(*p){
80103cc4:	0f b6 08             	movzbl (%eax),%ecx
80103cc7:	80 f9 02             	cmp    $0x2,%cl
80103cca:	74 5c                	je     80103d28 <mpinit+0x158>
80103ccc:	77 42                	ja     80103d10 <mpinit+0x140>
80103cce:	84 c9                	test   %cl,%cl
80103cd0:	74 6e                	je     80103d40 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cd2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cd5:	39 c2                	cmp    %eax,%edx
80103cd7:	77 eb                	ja     80103cc4 <mpinit+0xf4>
80103cd9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103cdc:	85 db                	test   %ebx,%ebx
80103cde:	0f 84 b9 00 00 00    	je     80103d9d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103ce4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103ce8:	74 15                	je     80103cff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cea:	b8 70 00 00 00       	mov    $0x70,%eax
80103cef:	ba 22 00 00 00       	mov    $0x22,%edx
80103cf4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cf5:	ba 23 00 00 00       	mov    $0x23,%edx
80103cfa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103cfb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cfe:	ee                   	out    %al,(%dx)
  }
}
80103cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d02:	5b                   	pop    %ebx
80103d03:	5e                   	pop    %esi
80103d04:	5f                   	pop    %edi
80103d05:	5d                   	pop    %ebp
80103d06:	c3                   	ret    
80103d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103d10:	83 e9 03             	sub    $0x3,%ecx
80103d13:	80 f9 01             	cmp    $0x1,%cl
80103d16:	76 ba                	jbe    80103cd2 <mpinit+0x102>
80103d18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103d1f:	eb 9f                	jmp    80103cc0 <mpinit+0xf0>
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103d28:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103d2c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103d2f:	88 0d 40 6b 18 80    	mov    %cl,0x80186b40
      continue;
80103d35:	eb 89                	jmp    80103cc0 <mpinit+0xf0>
80103d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103d40:	8b 0d e0 70 18 80    	mov    0x801870e0,%ecx
80103d46:	83 f9 07             	cmp    $0x7,%ecx
80103d49:	7f 19                	jg     80103d64 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d4b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103d51:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103d55:	83 c1 01             	add    $0x1,%ecx
80103d58:	89 0d e0 70 18 80    	mov    %ecx,0x801870e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d5e:	88 9f 60 6b 18 80    	mov    %bl,-0x7fe794a0(%edi)
      p += sizeof(struct mpproc);
80103d64:	83 c0 14             	add    $0x14,%eax
      continue;
80103d67:	e9 54 ff ff ff       	jmp    80103cc0 <mpinit+0xf0>
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103d70:	ba 00 00 01 00       	mov    $0x10000,%edx
80103d75:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103d7a:	e8 d1 fd ff ff       	call   80103b50 <mpsearch1>
80103d7f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d81:	85 c0                	test   %eax,%eax
80103d83:	0f 85 9b fe ff ff    	jne    80103c24 <mpinit+0x54>
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	68 62 97 10 80       	push   $0x80109762
80103d98:	e8 f3 c5 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103d9d:	83 ec 0c             	sub    $0xc,%esp
80103da0:	68 7c 97 10 80       	push   $0x8010977c
80103da5:	e8 e6 c5 ff ff       	call   80100390 <panic>
80103daa:	66 90                	xchg   %ax,%ax
80103dac:	66 90                	xchg   %ax,%ax
80103dae:	66 90                	xchg   %ax,%ax

80103db0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103db9:	ba 21 00 00 00       	mov    $0x21,%edx
80103dbe:	ee                   	out    %al,(%dx)
80103dbf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103dc4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103dc5:	c3                   	ret    
80103dc6:	66 90                	xchg   %ax,%ax
80103dc8:	66 90                	xchg   %ax,%ax
80103dca:	66 90                	xchg   %ax,%ax
80103dcc:	66 90                	xchg   %ax,%ax
80103dce:	66 90                	xchg   %ax,%ax

80103dd0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	57                   	push   %edi
80103dd8:	56                   	push   %esi
80103dd9:	53                   	push   %ebx
80103dda:	83 ec 0c             	sub    $0xc,%esp
80103ddd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103de0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103de3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103de9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103def:	e8 dc d3 ff ff       	call   801011d0 <filealloc>
80103df4:	89 03                	mov    %eax,(%ebx)
80103df6:	85 c0                	test   %eax,%eax
80103df8:	0f 84 ac 00 00 00    	je     80103eaa <pipealloc+0xda>
80103dfe:	e8 cd d3 ff ff       	call   801011d0 <filealloc>
80103e03:	89 06                	mov    %eax,(%esi)
80103e05:	85 c0                	test   %eax,%eax
80103e07:	0f 84 8b 00 00 00    	je     80103e98 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103e0d:	e8 ae f0 ff ff       	call   80102ec0 <kalloc>
80103e12:	89 c7                	mov    %eax,%edi
80103e14:	85 c0                	test   %eax,%eax
80103e16:	0f 84 b4 00 00 00    	je     80103ed0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103e1c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103e23:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103e26:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103e29:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103e30:	00 00 00 
  p->nwrite = 0;
80103e33:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103e3a:	00 00 00 
  p->nread = 0;
80103e3d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103e44:	00 00 00 
  initlock(&p->lock, "pipe");
80103e47:	68 9b 97 10 80       	push   $0x8010979b
80103e4c:	50                   	push   %eax
80103e4d:	e8 5e 14 00 00       	call   801052b0 <initlock>
  (*f0)->type = FD_PIPE;
80103e52:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103e54:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103e57:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103e5d:	8b 03                	mov    (%ebx),%eax
80103e5f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103e63:	8b 03                	mov    (%ebx),%eax
80103e65:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103e69:	8b 03                	mov    (%ebx),%eax
80103e6b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103e6e:	8b 06                	mov    (%esi),%eax
80103e70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103e76:	8b 06                	mov    (%esi),%eax
80103e78:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103e7c:	8b 06                	mov    (%esi),%eax
80103e7e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103e82:	8b 06                	mov    (%esi),%eax
80103e84:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103e8a:	31 c0                	xor    %eax,%eax
}
80103e8c:	5b                   	pop    %ebx
80103e8d:	5e                   	pop    %esi
80103e8e:	5f                   	pop    %edi
80103e8f:	5d                   	pop    %ebp
80103e90:	c3                   	ret    
80103e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103e98:	8b 03                	mov    (%ebx),%eax
80103e9a:	85 c0                	test   %eax,%eax
80103e9c:	74 1e                	je     80103ebc <pipealloc+0xec>
    fileclose(*f0);
80103e9e:	83 ec 0c             	sub    $0xc,%esp
80103ea1:	50                   	push   %eax
80103ea2:	e8 e9 d3 ff ff       	call   80101290 <fileclose>
80103ea7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103eaa:	8b 06                	mov    (%esi),%eax
80103eac:	85 c0                	test   %eax,%eax
80103eae:	74 0c                	je     80103ebc <pipealloc+0xec>
    fileclose(*f1);
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	50                   	push   %eax
80103eb4:	e8 d7 d3 ff ff       	call   80101290 <fileclose>
80103eb9:	83 c4 10             	add    $0x10,%esp
}
80103ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ec4:	5b                   	pop    %ebx
80103ec5:	5e                   	pop    %esi
80103ec6:	5f                   	pop    %edi
80103ec7:	5d                   	pop    %ebp
80103ec8:	c3                   	ret    
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103ed0:	8b 03                	mov    (%ebx),%eax
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 c8                	jne    80103e9e <pipealloc+0xce>
80103ed6:	eb d2                	jmp    80103eaa <pipealloc+0xda>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop

80103ee0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ee0:	f3 0f 1e fb          	endbr32 
80103ee4:	55                   	push   %ebp
80103ee5:	89 e5                	mov    %esp,%ebp
80103ee7:	56                   	push   %esi
80103ee8:	53                   	push   %ebx
80103ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103eec:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103eef:	83 ec 0c             	sub    $0xc,%esp
80103ef2:	53                   	push   %ebx
80103ef3:	e8 38 15 00 00       	call   80105430 <acquire>
  if(writable){
80103ef8:	83 c4 10             	add    $0x10,%esp
80103efb:	85 f6                	test   %esi,%esi
80103efd:	74 41                	je     80103f40 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103eff:	83 ec 0c             	sub    $0xc,%esp
80103f02:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103f08:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103f0f:	00 00 00 
    wakeup(&p->nread);
80103f12:	50                   	push   %eax
80103f13:	e8 98 0f 00 00       	call   80104eb0 <wakeup>
80103f18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103f1b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103f21:	85 d2                	test   %edx,%edx
80103f23:	75 0a                	jne    80103f2f <pipeclose+0x4f>
80103f25:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103f2b:	85 c0                	test   %eax,%eax
80103f2d:	74 31                	je     80103f60 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103f2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103f32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f35:	5b                   	pop    %ebx
80103f36:	5e                   	pop    %esi
80103f37:	5d                   	pop    %ebp
    release(&p->lock);
80103f38:	e9 b3 15 00 00       	jmp    801054f0 <release>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103f49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103f50:	00 00 00 
    wakeup(&p->nwrite);
80103f53:	50                   	push   %eax
80103f54:	e8 57 0f 00 00       	call   80104eb0 <wakeup>
80103f59:	83 c4 10             	add    $0x10,%esp
80103f5c:	eb bd                	jmp    80103f1b <pipeclose+0x3b>
80103f5e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	53                   	push   %ebx
80103f64:	e8 87 15 00 00       	call   801054f0 <release>
    kfree((char*)p);
80103f69:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f6c:	83 c4 10             	add    $0x10,%esp
}
80103f6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f72:	5b                   	pop    %ebx
80103f73:	5e                   	pop    %esi
80103f74:	5d                   	pop    %ebp
    kfree((char*)p);
80103f75:	e9 46 ec ff ff       	jmp    80102bc0 <kfree>
80103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	57                   	push   %edi
80103f88:	56                   	push   %esi
80103f89:	53                   	push   %ebx
80103f8a:	83 ec 28             	sub    $0x28,%esp
80103f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103f90:	53                   	push   %ebx
80103f91:	e8 9a 14 00 00       	call   80105430 <acquire>
  for(i = 0; i < n; i++){
80103f96:	8b 45 10             	mov    0x10(%ebp),%eax
80103f99:	83 c4 10             	add    $0x10,%esp
80103f9c:	85 c0                	test   %eax,%eax
80103f9e:	0f 8e bc 00 00 00    	jle    80104060 <pipewrite+0xe0>
80103fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fa7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103fad:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103fb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fb6:	03 45 10             	add    0x10(%ebp),%eax
80103fb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fbc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103fc2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fc8:	89 ca                	mov    %ecx,%edx
80103fca:	05 00 02 00 00       	add    $0x200,%eax
80103fcf:	39 c1                	cmp    %eax,%ecx
80103fd1:	74 3b                	je     8010400e <pipewrite+0x8e>
80103fd3:	eb 63                	jmp    80104038 <pipewrite+0xb8>
80103fd5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103fd8:	e8 93 04 00 00       	call   80104470 <myproc>
80103fdd:	8b 48 24             	mov    0x24(%eax),%ecx
80103fe0:	85 c9                	test   %ecx,%ecx
80103fe2:	75 34                	jne    80104018 <pipewrite+0x98>
      wakeup(&p->nread);
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	57                   	push   %edi
80103fe8:	e8 c3 0e 00 00       	call   80104eb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103fed:	58                   	pop    %eax
80103fee:	5a                   	pop    %edx
80103fef:	53                   	push   %ebx
80103ff0:	56                   	push   %esi
80103ff1:	e8 7a 0c 00 00       	call   80104c70 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ff6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103ffc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104002:	83 c4 10             	add    $0x10,%esp
80104005:	05 00 02 00 00       	add    $0x200,%eax
8010400a:	39 c2                	cmp    %eax,%edx
8010400c:	75 2a                	jne    80104038 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010400e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104014:	85 c0                	test   %eax,%eax
80104016:	75 c0                	jne    80103fd8 <pipewrite+0x58>
        release(&p->lock);
80104018:	83 ec 0c             	sub    $0xc,%esp
8010401b:	53                   	push   %ebx
8010401c:	e8 cf 14 00 00       	call   801054f0 <release>
        return -1;
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104029:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010402c:	5b                   	pop    %ebx
8010402d:	5e                   	pop    %esi
8010402e:	5f                   	pop    %edi
8010402f:	5d                   	pop    %ebp
80104030:	c3                   	ret    
80104031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104038:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010403b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010403e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104044:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010404a:	0f b6 06             	movzbl (%esi),%eax
8010404d:	83 c6 01             	add    $0x1,%esi
80104050:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80104053:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104057:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010405a:	0f 85 5c ff ff ff    	jne    80103fbc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104069:	50                   	push   %eax
8010406a:	e8 41 0e 00 00       	call   80104eb0 <wakeup>
  release(&p->lock);
8010406f:	89 1c 24             	mov    %ebx,(%esp)
80104072:	e8 79 14 00 00       	call   801054f0 <release>
  return n;
80104077:	8b 45 10             	mov    0x10(%ebp),%eax
8010407a:	83 c4 10             	add    $0x10,%esp
8010407d:	eb aa                	jmp    80104029 <pipewrite+0xa9>
8010407f:	90                   	nop

80104080 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104080:	f3 0f 1e fb          	endbr32 
80104084:	55                   	push   %ebp
80104085:	89 e5                	mov    %esp,%ebp
80104087:	57                   	push   %edi
80104088:	56                   	push   %esi
80104089:	53                   	push   %ebx
8010408a:	83 ec 18             	sub    $0x18,%esp
8010408d:	8b 75 08             	mov    0x8(%ebp),%esi
80104090:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104093:	56                   	push   %esi
80104094:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010409a:	e8 91 13 00 00       	call   80105430 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010409f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801040a5:	83 c4 10             	add    $0x10,%esp
801040a8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801040ae:	74 33                	je     801040e3 <piperead+0x63>
801040b0:	eb 3b                	jmp    801040ed <piperead+0x6d>
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801040b8:	e8 b3 03 00 00       	call   80104470 <myproc>
801040bd:	8b 48 24             	mov    0x24(%eax),%ecx
801040c0:	85 c9                	test   %ecx,%ecx
801040c2:	0f 85 88 00 00 00    	jne    80104150 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801040c8:	83 ec 08             	sub    $0x8,%esp
801040cb:	56                   	push   %esi
801040cc:	53                   	push   %ebx
801040cd:	e8 9e 0b 00 00       	call   80104c70 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801040d2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801040d8:	83 c4 10             	add    $0x10,%esp
801040db:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801040e1:	75 0a                	jne    801040ed <piperead+0x6d>
801040e3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801040e9:	85 c0                	test   %eax,%eax
801040eb:	75 cb                	jne    801040b8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801040ed:	8b 55 10             	mov    0x10(%ebp),%edx
801040f0:	31 db                	xor    %ebx,%ebx
801040f2:	85 d2                	test   %edx,%edx
801040f4:	7f 28                	jg     8010411e <piperead+0x9e>
801040f6:	eb 34                	jmp    8010412c <piperead+0xac>
801040f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104100:	8d 48 01             	lea    0x1(%eax),%ecx
80104103:	25 ff 01 00 00       	and    $0x1ff,%eax
80104108:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010410e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104113:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104116:	83 c3 01             	add    $0x1,%ebx
80104119:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010411c:	74 0e                	je     8010412c <piperead+0xac>
    if(p->nread == p->nwrite)
8010411e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104124:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010412a:	75 d4                	jne    80104100 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010412c:	83 ec 0c             	sub    $0xc,%esp
8010412f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104135:	50                   	push   %eax
80104136:	e8 75 0d 00 00       	call   80104eb0 <wakeup>
  release(&p->lock);
8010413b:	89 34 24             	mov    %esi,(%esp)
8010413e:	e8 ad 13 00 00       	call   801054f0 <release>
  return i;
80104143:	83 c4 10             	add    $0x10,%esp
}
80104146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104149:	89 d8                	mov    %ebx,%eax
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    
      release(&p->lock);
80104150:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104153:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104158:	56                   	push   %esi
80104159:	e8 92 13 00 00       	call   801054f0 <release>
      return -1;
8010415e:	83 c4 10             	add    $0x10,%esp
}
80104161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104164:	89 d8                	mov    %ebx,%eax
80104166:	5b                   	pop    %ebx
80104167:	5e                   	pop    %esi
80104168:	5f                   	pop    %edi
80104169:	5d                   	pop    %ebp
8010416a:	c3                   	ret    
8010416b:	66 90                	xchg   %ax,%ax
8010416d:	66 90                	xchg   %ax,%ax
8010416f:	90                   	nop

80104170 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	bb 34 71 18 80       	mov    $0x80187134,%ebx
{
8010417b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010417e:	68 00 71 18 80       	push   $0x80187100
80104183:	e8 a8 12 00 00       	call   80105430 <acquire>
80104188:	83 c4 10             	add    $0x10,%esp
8010418b:	eb 15                	jmp    801041a2 <allocproc+0x32>
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104190:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104196:	81 fb 34 7d 19 80    	cmp    $0x80197d34,%ebx
8010419c:	0f 84 7e 01 00 00    	je     80104320 <allocproc+0x1b0>
    if(p->state == UNUSED)
801041a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801041a5:	85 c0                	test   %eax,%eax
801041a7:	75 e7                	jne    80104190 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801041a9:	a1 04 d0 10 80       	mov    0x8010d004,%eax

  release(&ptable.lock);
801041ae:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801041b1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801041b8:	89 43 10             	mov    %eax,0x10(%ebx)
801041bb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801041be:	68 00 71 18 80       	push   $0x80187100
  p->pid = nextpid++;
801041c3:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
  release(&ptable.lock);
801041c9:	e8 22 13 00 00       	call   801054f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041ce:	e8 ed ec ff ff       	call   80102ec0 <kalloc>
801041d3:	83 c4 10             	add    $0x10,%esp
801041d6:	89 43 08             	mov    %eax,0x8(%ebx)
801041d9:	85 c0                	test   %eax,%eax
801041db:	0f 84 6a 01 00 00    	je     8010434b <allocproc+0x1db>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801041e1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801041e7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801041ea:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801041ef:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801041f2:	c7 40 14 a1 67 10 80 	movl   $0x801067a1,0x14(%eax)
  p->context = (struct context*)sp;
801041f9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801041fc:	6a 14                	push   $0x14
801041fe:	6a 00                	push   $0x0
80104200:	50                   	push   %eax
80104201:	e8 3a 13 00 00       	call   80105540 <memset>
  p->context->eip = (uint)forkret;
80104206:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80104209:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010420c:	c7 40 10 70 43 10 80 	movl   $0x80104370,0x10(%eax)
  if(p->pid > 2) {
80104213:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104217:	7f 0f                	jg     80104228 <allocproc+0xb8>
      // cprintf("\n");

    }
  }
  return p;
}
80104219:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010421c:	89 d8                	mov    %ebx,%eax
8010421e:	5b                   	pop    %ebx
8010421f:	5e                   	pop    %esi
80104220:	5f                   	pop    %edi
80104221:	5d                   	pop    %ebp
80104222:	c3                   	ret    
80104223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104227:	90                   	nop
    if(createSwapFile(p) != 0)
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	53                   	push   %ebx
8010422c:	e8 8f e4 ff ff       	call   801026c0 <createSwapFile>
80104231:	83 c4 10             	add    $0x10,%esp
80104234:	85 c0                	test   %eax,%eax
80104236:	0f 85 22 01 00 00    	jne    8010435e <allocproc+0x1ee>
    p->num_ram = 0;
8010423c:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80104243:	00 00 00 
    if(p->selection == SCFIFO)
80104246:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
    p->num_swap = 0;
8010424c:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80104253:	00 00 00 
    p->totalPgfltCount = 0;
80104256:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
8010425d:	00 00 00 
    p->totalPgoutCount = 0;
80104260:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
80104267:	00 00 00 
    if(p->selection == SCFIFO)
8010426a:	83 f8 03             	cmp    $0x3,%eax
8010426d:	0f 84 c9 00 00 00    	je     8010433c <allocproc+0x1cc>
    if(p->selection == AQ)
80104273:	83 f8 04             	cmp    $0x4,%eax
80104276:	75 14                	jne    8010428c <allocproc+0x11c>
      p->queue_head = 0;
80104278:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
8010427f:	00 00 00 
      p->queue_tail = 0;
80104282:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104289:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
8010428c:	83 ec 04             	sub    $0x4,%esp
8010428f:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104295:	68 c0 01 00 00       	push   $0x1c0
8010429a:	6a 00                	push   $0x0
8010429c:	50                   	push   %eax
8010429d:	e8 9e 12 00 00       	call   80105540 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801042a2:	83 c4 0c             	add    $0xc,%esp
801042a5:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801042ab:	68 c0 01 00 00       	push   $0x1c0
801042b0:	6a 00                	push   $0x0
801042b2:	50                   	push   %eax
801042b3:	e8 88 12 00 00       	call   80105540 <memset>
    if(p->pid > 2)
801042b8:	83 c4 10             	add    $0x10,%esp
801042bb:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801042bf:	0f 8e 54 ff ff ff    	jle    80104219 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
801042c5:	e8 f6 eb ff ff       	call   80102ec0 <kalloc>
      struct fblock *prev = p->free_head;
801042ca:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head = (struct fblock*)kalloc();
801042cf:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
801042d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      p->free_head->off = 0 * PGSIZE;
801042dc:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
801042e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
801042e8:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
801042ee:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
801042f0:	89 c7                	mov    %eax,%edi
801042f2:	e8 c9 eb ff ff       	call   80102ec0 <kalloc>
        curr->off = i * PGSIZE;
801042f7:	89 30                	mov    %esi,(%eax)
        curr->prev = prev;
801042f9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801042ff:	89 78 08             	mov    %edi,0x8(%eax)
        curr->prev->next = curr;
80104302:	89 47 04             	mov    %eax,0x4(%edi)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104305:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
8010430b:	75 e3                	jne    801042f0 <allocproc+0x180>
      p->free_tail = prev;
8010430d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010431a:	e9 fa fe ff ff       	jmp    80104219 <allocproc+0xa9>
8010431f:	90                   	nop
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104323:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104325:	68 00 71 18 80       	push   $0x80187100
8010432a:	e8 c1 11 00 00       	call   801054f0 <release>
  return 0;
8010432f:	83 c4 10             	add    $0x10,%esp
}
80104332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104335:	89 d8                	mov    %ebx,%eax
80104337:	5b                   	pop    %ebx
80104338:	5e                   	pop    %esi
80104339:	5f                   	pop    %edi
8010433a:	5d                   	pop    %ebp
8010433b:	c3                   	ret    
      p->clockHand = 0;
8010433c:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104343:	00 00 00 
    if(p->selection == AQ)
80104346:	e9 41 ff ff ff       	jmp    8010428c <allocproc+0x11c>
    p->state = UNUSED;
8010434b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80104352:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104355:	31 db                	xor    %ebx,%ebx
}
80104357:	89 d8                	mov    %ebx,%eax
80104359:	5b                   	pop    %ebx
8010435a:	5e                   	pop    %esi
8010435b:	5f                   	pop    %edi
8010435c:	5d                   	pop    %ebp
8010435d:	c3                   	ret    
      panic("allocproc: createSwapFile");
8010435e:	83 ec 0c             	sub    $0xc,%esp
80104361:	68 a0 97 10 80       	push   $0x801097a0
80104366:	e8 25 c0 ff ff       	call   80100390 <panic>
8010436b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010436f:	90                   	nop

80104370 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010437a:	68 00 71 18 80       	push   $0x80187100
8010437f:	e8 6c 11 00 00       	call   801054f0 <release>

  if (first) {
80104384:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80104389:	83 c4 10             	add    $0x10,%esp
8010438c:	85 c0                	test   %eax,%eax
8010438e:	75 08                	jne    80104398 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104390:	c9                   	leave  
80104391:	c3                   	ret    
80104392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104398:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
8010439f:	00 00 00 
    iinit(ROOTDEV);
801043a2:	83 ec 0c             	sub    $0xc,%esp
801043a5:	6a 01                	push   $0x1
801043a7:	e8 64 d5 ff ff       	call   80101910 <iinit>
    initlog(ROOTDEV);
801043ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801043b3:	e8 b8 f2 ff ff       	call   80103670 <initlog>
}
801043b8:	83 c4 10             	add    $0x10,%esp
801043bb:	c9                   	leave  
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi

801043c0 <pinit>:
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801043ca:	68 ba 97 10 80       	push   $0x801097ba
801043cf:	68 00 71 18 80       	push   $0x80187100
801043d4:	e8 d7 0e 00 00       	call   801052b0 <initlock>
}
801043d9:	83 c4 10             	add    $0x10,%esp
801043dc:	c9                   	leave  
801043dd:	c3                   	ret    
801043de:	66 90                	xchg   %ax,%ax

801043e0 <mycpu>:
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	56                   	push   %esi
801043e8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e9:	9c                   	pushf  
801043ea:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043eb:	f6 c4 02             	test   $0x2,%ah
801043ee:	75 4a                	jne    8010443a <mycpu+0x5a>
  apicid = lapicid();
801043f0:	e8 8b ee ff ff       	call   80103280 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801043f5:	8b 35 e0 70 18 80    	mov    0x801870e0,%esi
  apicid = lapicid();
801043fb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801043fd:	85 f6                	test   %esi,%esi
801043ff:	7e 2c                	jle    8010442d <mycpu+0x4d>
80104401:	31 d2                	xor    %edx,%edx
80104403:	eb 0a                	jmp    8010440f <mycpu+0x2f>
80104405:	8d 76 00             	lea    0x0(%esi),%esi
80104408:	83 c2 01             	add    $0x1,%edx
8010440b:	39 f2                	cmp    %esi,%edx
8010440d:	74 1e                	je     8010442d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010440f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104415:	0f b6 81 60 6b 18 80 	movzbl -0x7fe794a0(%ecx),%eax
8010441c:	39 d8                	cmp    %ebx,%eax
8010441e:	75 e8                	jne    80104408 <mycpu+0x28>
}
80104420:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104423:	8d 81 60 6b 18 80    	lea    -0x7fe794a0(%ecx),%eax
}
80104429:	5b                   	pop    %ebx
8010442a:	5e                   	pop    %esi
8010442b:	5d                   	pop    %ebp
8010442c:	c3                   	ret    
  panic("unknown apicid\n");
8010442d:	83 ec 0c             	sub    $0xc,%esp
80104430:	68 c1 97 10 80       	push   $0x801097c1
80104435:	e8 56 bf ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010443a:	83 ec 0c             	sub    $0xc,%esp
8010443d:	68 b0 98 10 80       	push   $0x801098b0
80104442:	e8 49 bf ff ff       	call   80100390 <panic>
80104447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444e:	66 90                	xchg   %ax,%ax

80104450 <cpuid>:
cpuid() {
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010445a:	e8 81 ff ff ff       	call   801043e0 <mycpu>
}
8010445f:	c9                   	leave  
  return mycpu()-cpus;
80104460:	2d 60 6b 18 80       	sub    $0x80186b60,%eax
80104465:	c1 f8 04             	sar    $0x4,%eax
80104468:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010446e:	c3                   	ret    
8010446f:	90                   	nop

80104470 <myproc>:
myproc(void) {
80104470:	f3 0f 1e fb          	endbr32 
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	53                   	push   %ebx
80104478:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010447b:	e8 b0 0e 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104480:	e8 5b ff ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104485:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448b:	e8 f0 0e 00 00       	call   80105380 <popcli>
}
80104490:	83 c4 04             	add    $0x4,%esp
80104493:	89 d8                	mov    %ebx,%eax
80104495:	5b                   	pop    %ebx
80104496:	5d                   	pop    %ebp
80104497:	c3                   	ret    
80104498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop

801044a0 <userinit>:
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	53                   	push   %ebx
801044a8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801044ab:	e8 c0 fc ff ff       	call   80104170 <allocproc>
801044b0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801044b2:	a3 d8 d5 10 80       	mov    %eax,0x8010d5d8
  if((p->pgdir = setupkvm()) == 0)
801044b7:	e8 24 3e 00 00       	call   801082e0 <setupkvm>
801044bc:	89 43 04             	mov    %eax,0x4(%ebx)
801044bf:	85 c0                	test   %eax,%eax
801044c1:	0f 84 bd 00 00 00    	je     80104584 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044c7:	83 ec 04             	sub    $0x4,%esp
801044ca:	68 2c 00 00 00       	push   $0x2c
801044cf:	68 60 d4 10 80       	push   $0x8010d460
801044d4:	50                   	push   %eax
801044d5:	e8 16 36 00 00       	call   80107af0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801044da:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801044dd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801044e3:	6a 4c                	push   $0x4c
801044e5:	6a 00                	push   $0x0
801044e7:	ff 73 18             	pushl  0x18(%ebx)
801044ea:	e8 51 10 00 00       	call   80105540 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044ef:	8b 43 18             	mov    0x18(%ebx),%eax
801044f2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801044f7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044fa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044ff:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104503:	8b 43 18             	mov    0x18(%ebx),%eax
80104506:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010450a:	8b 43 18             	mov    0x18(%ebx),%eax
8010450d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104511:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104515:	8b 43 18             	mov    0x18(%ebx),%eax
80104518:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010451c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104520:	8b 43 18             	mov    0x18(%ebx),%eax
80104523:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010452a:	8b 43 18             	mov    0x18(%ebx),%eax
8010452d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104534:	8b 43 18             	mov    0x18(%ebx),%eax
80104537:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010453e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104541:	6a 10                	push   $0x10
80104543:	68 ea 97 10 80       	push   $0x801097ea
80104548:	50                   	push   %eax
80104549:	e8 b2 11 00 00       	call   80105700 <safestrcpy>
  p->cwd = namei("/");
8010454e:	c7 04 24 f3 97 10 80 	movl   $0x801097f3,(%esp)
80104555:	e8 a6 de ff ff       	call   80102400 <namei>
8010455a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010455d:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104564:	e8 c7 0e 00 00       	call   80105430 <acquire>
  p->state = RUNNABLE;
80104569:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104570:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104577:	e8 74 0f 00 00       	call   801054f0 <release>
}
8010457c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010457f:	83 c4 10             	add    $0x10,%esp
80104582:	c9                   	leave  
80104583:	c3                   	ret    
    panic("userinit: out of memory?");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 d1 97 10 80       	push   $0x801097d1
8010458c:	e8 ff bd ff ff       	call   80100390 <panic>
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop

801045a0 <growproc>:
{
801045a0:	f3 0f 1e fb          	endbr32 
801045a4:	55                   	push   %ebp
801045a5:	89 e5                	mov    %esp,%ebp
801045a7:	57                   	push   %edi
801045a8:	56                   	push   %esi
801045a9:	53                   	push   %ebx
801045aa:	83 ec 0c             	sub    $0xc,%esp
801045ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801045b0:	e8 7b 0d 00 00       	call   80105330 <pushcli>
  c = mycpu();
801045b5:	e8 26 fe ff ff       	call   801043e0 <mycpu>
  p = c->proc;
801045ba:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045c0:	e8 bb 0d 00 00       	call   80105380 <popcli>
  sz = curproc->sz;
801045c5:	8b 1e                	mov    (%esi),%ebx
  if(n > 0){
801045c7:	85 ff                	test   %edi,%edi
801045c9:	7f 1d                	jg     801045e8 <growproc+0x48>
  } else if(n < 0){
801045cb:	75 43                	jne    80104610 <growproc+0x70>
  switchuvm(curproc);
801045cd:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801045d0:	89 1e                	mov    %ebx,(%esi)
  switchuvm(curproc);
801045d2:	56                   	push   %esi
801045d3:	e8 08 34 00 00       	call   801079e0 <switchuvm>
  return 0;
801045d8:	83 c4 10             	add    $0x10,%esp
801045db:	31 c0                	xor    %eax,%eax
}
801045dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e0:	5b                   	pop    %ebx
801045e1:	5e                   	pop    %esi
801045e2:	5f                   	pop    %edi
801045e3:	5d                   	pop    %ebp
801045e4:	c3                   	ret    
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045e8:	83 ec 04             	sub    $0x4,%esp
801045eb:	01 df                	add    %ebx,%edi
801045ed:	57                   	push   %edi
801045ee:	53                   	push   %ebx
801045ef:	ff 76 04             	pushl  0x4(%esi)
801045f2:	e8 a9 3a 00 00       	call   801080a0 <allocuvm>
801045f7:	83 c4 10             	add    $0x10,%esp
801045fa:	89 c3                	mov    %eax,%ebx
801045fc:	85 c0                	test   %eax,%eax
801045fe:	75 cd                	jne    801045cd <growproc+0x2d>
      return -1;
80104600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104605:	eb d6                	jmp    801045dd <growproc+0x3d>
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
    cprintf("growproc: n < 0\n");
80104610:	83 ec 0c             	sub    $0xc,%esp
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104613:	01 df                	add    %ebx,%edi
    cprintf("growproc: n < 0\n");
80104615:	68 f5 97 10 80       	push   $0x801097f5
8010461a:	e8 91 c0 ff ff       	call   801006b0 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010461f:	83 c4 0c             	add    $0xc,%esp
80104622:	57                   	push   %edi
80104623:	53                   	push   %ebx
80104624:	ff 76 04             	pushl  0x4(%esi)
80104627:	e8 54 38 00 00       	call   80107e80 <deallocuvm>
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	89 c3                	mov    %eax,%ebx
80104631:	85 c0                	test   %eax,%eax
80104633:	75 98                	jne    801045cd <growproc+0x2d>
80104635:	eb c9                	jmp    80104600 <growproc+0x60>
80104637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463e:	66 90                	xchg   %ax,%ax

80104640 <fork>:
{ 
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	57                   	push   %edi
80104648:	56                   	push   %esi
80104649:	53                   	push   %ebx
8010464a:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
80104650:	e8 db 0c 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104655:	e8 86 fd ff ff       	call   801043e0 <mycpu>
  p = c->proc;
8010465a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104660:	e8 1b 0d 00 00       	call   80105380 <popcli>
  if((np = allocproc()) == 0){
80104665:	e8 06 fb ff ff       	call   80104170 <allocproc>
8010466a:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
80104670:	85 c0                	test   %eax,%eax
80104672:	0f 84 f5 01 00 00    	je     8010486d <fork+0x22d>
  if(curproc->pid <= 2) // init, shell
80104678:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010467c:	89 c7                	mov    %eax,%edi
8010467e:	8b 13                	mov    (%ebx),%edx
80104680:	8b 43 04             	mov    0x4(%ebx),%eax
80104683:	0f 8e cf 01 00 00    	jle    80104858 <fork+0x218>
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
80104689:	83 ec 08             	sub    $0x8,%esp
8010468c:	52                   	push   %edx
8010468d:	50                   	push   %eax
8010468e:	e8 2d 3d 00 00       	call   801083c0 <cowuvm>
80104693:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
80104699:	83 c4 10             	add    $0x10,%esp
8010469c:	89 41 04             	mov    %eax,0x4(%ecx)
  if(np->pgdir == 0){
8010469f:	85 c0                	test   %eax,%eax
801046a1:	0f 84 da 01 00 00    	je     80104881 <fork+0x241>
  np->sz = curproc->sz;
801046a7:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801046ad:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801046af:	8b 79 18             	mov    0x18(%ecx),%edi
  np->sz = curproc->sz;
801046b2:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801046b4:	89 c8                	mov    %ecx,%eax
801046b6:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801046b9:	b9 13 00 00 00       	mov    $0x13,%ecx
801046be:	8b 73 18             	mov    0x18(%ebx),%esi
801046c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801046c3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801046c7:	0f 8e 00 01 00 00    	jle    801047cd <fork+0x18d>
    np->totalPgfltCount = 0;
801046cd:	89 c7                	mov    %eax,%edi
801046cf:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
801046d5:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801046dc:	00 00 00 
    np->totalPgoutCount = 0;
801046df:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801046e6:	00 00 00 
    np->num_ram = curproc->num_ram;
801046e9:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
        np->ramPages[i].pgdir = np->pgdir;
801046ef:	8b 4f 04             	mov    0x4(%edi),%ecx
    np->num_ram = curproc->num_ram;
801046f2:	89 87 08 04 00 00    	mov    %eax,0x408(%edi)
    np->num_swap = curproc->num_swap;
801046f8:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
801046fe:	89 87 0c 04 00 00    	mov    %eax,0x40c(%edi)
    for(i = 0; i < MAX_PSYC_PAGES; i++)
80104704:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
8010470a:	81 c7 48 02 00 00    	add    $0x248,%edi
        np->ramPages[i].isused = 1;
80104710:	c7 80 c4 01 00 00 01 	movl   $0x1,0x1c4(%eax)
80104717:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010471a:	83 c0 1c             	add    $0x1c,%eax
8010471d:	83 c2 1c             	add    $0x1c,%edx
80104720:	8b b2 a4 01 00 00    	mov    0x1a4(%edx),%esi
        np->ramPages[i].pgdir = np->pgdir;
80104726:	89 88 a4 01 00 00    	mov    %ecx,0x1a4(%eax)
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010472c:	89 b0 ac 01 00 00    	mov    %esi,0x1ac(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104732:	8b b2 ac 01 00 00    	mov    0x1ac(%edx),%esi
      np->swappedPages[i].isused = 1;
80104738:	c7 40 e8 01 00 00 00 	movl   $0x1,-0x18(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
8010473f:	89 b0 b4 01 00 00    	mov    %esi,0x1b4(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104745:	8b 72 e4             	mov    -0x1c(%edx),%esi
      np->swappedPages[i].pgdir = np->pgdir;
80104748:	89 48 e4             	mov    %ecx,-0x1c(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010474b:	89 70 ec             	mov    %esi,-0x14(%eax)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
8010474e:	8b 72 e8             	mov    -0x18(%edx),%esi
80104751:	89 70 f0             	mov    %esi,-0x10(%eax)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
80104754:	8b 72 ec             	mov    -0x14(%edx),%esi
80104757:	89 70 f4             	mov    %esi,-0xc(%eax)
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010475a:	39 f8                	cmp    %edi,%eax
8010475c:	75 b2                	jne    80104710 <fork+0xd0>
      char buffer[PGSIZE / 2] = "";
8010475e:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104764:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104769:	31 c0                	xor    %eax,%eax
      int offset = 0;
8010476b:	31 f6                	xor    %esi,%esi
      char buffer[PGSIZE / 2] = "";
8010476d:	f3 ab                	rep stos %eax,%es:(%edi)
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
8010476f:	89 9d e0 f7 ff ff    	mov    %ebx,-0x820(%ebp)
80104775:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
      char buffer[PGSIZE / 2] = "";
8010477b:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104782:	00 00 00 
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
80104785:	eb 25                	jmp    801047ac <fork+0x16c>
80104787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478e:	66 90                	xchg   %ax,%ax
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
80104790:	53                   	push   %ebx
80104791:	56                   	push   %esi
80104792:	57                   	push   %edi
80104793:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
80104799:	e8 c2 df ff ff       	call   80102760 <writeToSwapFile>
8010479e:	83 c4 10             	add    $0x10,%esp
801047a1:	83 f8 ff             	cmp    $0xffffffff,%eax
801047a4:	0f 84 ca 00 00 00    	je     80104874 <fork+0x234>
        offset += nread;
801047aa:	01 de                	add    %ebx,%esi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801047ac:	68 00 08 00 00       	push   $0x800
801047b1:	56                   	push   %esi
801047b2:	57                   	push   %edi
801047b3:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
801047b9:	e8 d2 df ff ff       	call   80102790 <readFromSwapFile>
801047be:	83 c4 10             	add    $0x10,%esp
801047c1:	89 c3                	mov    %eax,%ebx
801047c3:	85 c0                	test   %eax,%eax
801047c5:	75 c9                	jne    80104790 <fork+0x150>
801047c7:	8b 9d e0 f7 ff ff    	mov    -0x820(%ebp),%ebx
  np->tf->eax = 0;
801047cd:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801047d3:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801047d5:	8b 47 18             	mov    0x18(%edi),%eax
801047d8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801047df:	90                   	nop
    if(curproc->ofile[i])
801047e0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801047e4:	85 c0                	test   %eax,%eax
801047e6:	74 10                	je     801047f8 <fork+0x1b8>
      np->ofile[i] = filedup(curproc->ofile[i]);
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	50                   	push   %eax
801047ec:	e8 4f ca ff ff       	call   80101240 <filedup>
801047f1:	83 c4 10             	add    $0x10,%esp
801047f4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
801047f8:	83 c6 01             	add    $0x1,%esi
801047fb:	83 fe 10             	cmp    $0x10,%esi
801047fe:	75 e0                	jne    801047e0 <fork+0x1a0>
  np->cwd = idup(curproc->cwd);
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104806:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104809:	e8 f2 d2 ff ff       	call   80101b00 <idup>
8010480e:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104814:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104817:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010481a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010481d:	6a 10                	push   $0x10
8010481f:	53                   	push   %ebx
80104820:	50                   	push   %eax
80104821:	e8 da 0e 00 00       	call   80105700 <safestrcpy>
  pid = np->pid;
80104826:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104829:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104830:	e8 fb 0b 00 00       	call   80105430 <acquire>
  np->state = RUNNABLE;
80104835:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010483c:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104843:	e8 a8 0c 00 00       	call   801054f0 <release>
  return pid;
80104848:	83 c4 10             	add    $0x10,%esp
}
8010484b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010484e:	89 d8                	mov    %ebx,%eax
80104850:	5b                   	pop    %ebx
80104851:	5e                   	pop    %esi
80104852:	5f                   	pop    %edi
80104853:	5d                   	pop    %ebp
80104854:	c3                   	ret    
80104855:	8d 76 00             	lea    0x0(%esi),%esi
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104858:	83 ec 08             	sub    $0x8,%esp
8010485b:	52                   	push   %edx
8010485c:	50                   	push   %eax
8010485d:	e8 6e 41 00 00       	call   801089d0 <copyuvm>
80104862:	83 c4 10             	add    $0x10,%esp
80104865:	89 47 04             	mov    %eax,0x4(%edi)
80104868:	e9 32 fe ff ff       	jmp    8010469f <fork+0x5f>
    return -1;
8010486d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104872:	eb d7                	jmp    8010484b <fork+0x20b>
          panic("fork: error copying parent's swap file");
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	68 d8 98 10 80       	push   $0x801098d8
8010487c:	e8 0f bb ff ff       	call   80100390 <panic>
    kfree(np->kstack);
80104881:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
80104887:	83 ec 0c             	sub    $0xc,%esp
8010488a:	ff 73 08             	pushl  0x8(%ebx)
8010488d:	e8 2e e3 ff ff       	call   80102bc0 <kfree>
    np->kstack = 0;
80104892:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104899:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010489c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801048a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801048a8:	eb a1                	jmp    8010484b <fork+0x20b>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <copyAQ>:
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	57                   	push   %edi
801048b8:	56                   	push   %esi
801048b9:	53                   	push   %ebx
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801048c0:	e8 6b 0a 00 00       	call   80105330 <pushcli>
  c = mycpu();
801048c5:	e8 16 fb ff ff       	call   801043e0 <mycpu>
  p = c->proc;
801048ca:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048d0:	e8 ab 0a 00 00       	call   80105380 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
801048d5:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
801048db:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
801048e2:	00 00 00 
  np->queue_tail = 0;
801048e5:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
801048ec:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
801048ef:	85 db                	test   %ebx,%ebx
801048f1:	74 53                	je     80104946 <copyAQ+0x96>
    np_curr = (struct queue_node*)kalloc();
801048f3:	e8 c8 e5 ff ff       	call   80102ec0 <kalloc>
    np_curr->page_index = old_curr->page_index;
801048f8:	8b 53 08             	mov    0x8(%ebx),%edx
801048fb:	89 50 08             	mov    %edx,0x8(%eax)
    np->queue_head =np_curr;
801048fe:	89 86 1c 04 00 00    	mov    %eax,0x41c(%esi)
    np_curr->prev = 0;
80104904:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    old_curr = old_curr->next;
8010490b:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010490d:	85 db                	test   %ebx,%ebx
8010490f:	74 1f                	je     80104930 <copyAQ+0x80>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np_curr = (struct queue_node*)kalloc();
80104918:	89 c7                	mov    %eax,%edi
8010491a:	e8 a1 e5 ff ff       	call   80102ec0 <kalloc>
    np_curr->page_index = old_curr->page_index;
8010491f:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
80104922:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
80104925:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
80104928:	89 07                	mov    %eax,(%edi)
    old_curr = old_curr->next;
8010492a:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010492c:	85 db                	test   %ebx,%ebx
8010492e:	75 e8                	jne    80104918 <copyAQ+0x68>
  if(np->queue_head != 0) // if the queue wasn't empty
80104930:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
80104936:	85 d2                	test   %edx,%edx
80104938:	74 0c                	je     80104946 <copyAQ+0x96>
    np_curr->next = 0;
8010493a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104940:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
80104946:	83 c4 0c             	add    $0xc,%esp
80104949:	5b                   	pop    %ebx
8010494a:	5e                   	pop    %esi
8010494b:	5f                   	pop    %edi
8010494c:	5d                   	pop    %ebp
8010494d:	c3                   	ret    
8010494e:	66 90                	xchg   %ax,%ax

80104950 <scheduler>:
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	53                   	push   %ebx
8010495a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010495d:	e8 7e fa ff ff       	call   801043e0 <mycpu>
  c->proc = 0;
80104962:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104969:	00 00 00 
  struct cpu *c = mycpu();
8010496c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010496e:	8d 78 04             	lea    0x4(%eax),%edi
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104978:	fb                   	sti    
    acquire(&ptable.lock);
80104979:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010497c:	bb 34 71 18 80       	mov    $0x80187134,%ebx
    acquire(&ptable.lock);
80104981:	68 00 71 18 80       	push   $0x80187100
80104986:	e8 a5 0a 00 00       	call   80105430 <acquire>
8010498b:	83 c4 10             	add    $0x10,%esp
8010498e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104990:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104994:	75 33                	jne    801049c9 <scheduler+0x79>
      switchuvm(p);
80104996:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104999:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010499f:	53                   	push   %ebx
801049a0:	e8 3b 30 00 00       	call   801079e0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801049a5:	58                   	pop    %eax
801049a6:	5a                   	pop    %edx
801049a7:	ff 73 1c             	pushl  0x1c(%ebx)
801049aa:	57                   	push   %edi
      p->state = RUNNING;
801049ab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801049b2:	e8 ac 0d 00 00       	call   80105763 <swtch>
      switchkvm();
801049b7:	e8 04 30 00 00       	call   801079c0 <switchkvm>
      c->proc = 0;
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801049c6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c9:	81 c3 30 04 00 00    	add    $0x430,%ebx
801049cf:	81 fb 34 7d 19 80    	cmp    $0x80197d34,%ebx
801049d5:	75 b9                	jne    80104990 <scheduler+0x40>
    release(&ptable.lock);
801049d7:	83 ec 0c             	sub    $0xc,%esp
801049da:	68 00 71 18 80       	push   $0x80187100
801049df:	e8 0c 0b 00 00       	call   801054f0 <release>
    sti();
801049e4:	83 c4 10             	add    $0x10,%esp
801049e7:	eb 8f                	jmp    80104978 <scheduler+0x28>
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <sched>:
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	56                   	push   %esi
801049f8:	53                   	push   %ebx
  pushcli();
801049f9:	e8 32 09 00 00       	call   80105330 <pushcli>
  c = mycpu();
801049fe:	e8 dd f9 ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104a03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a09:	e8 72 09 00 00       	call   80105380 <popcli>
  if(!holding(&ptable.lock))
80104a0e:	83 ec 0c             	sub    $0xc,%esp
80104a11:	68 00 71 18 80       	push   $0x80187100
80104a16:	e8 c5 09 00 00       	call   801053e0 <holding>
80104a1b:	83 c4 10             	add    $0x10,%esp
80104a1e:	85 c0                	test   %eax,%eax
80104a20:	74 4f                	je     80104a71 <sched+0x81>
  if(mycpu()->ncli != 1)
80104a22:	e8 b9 f9 ff ff       	call   801043e0 <mycpu>
80104a27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104a2e:	75 68                	jne    80104a98 <sched+0xa8>
  if(p->state == RUNNING)
80104a30:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104a34:	74 55                	je     80104a8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a36:	9c                   	pushf  
80104a37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a38:	f6 c4 02             	test   $0x2,%ah
80104a3b:	75 41                	jne    80104a7e <sched+0x8e>
  intena = mycpu()->intena;
80104a3d:	e8 9e f9 ff ff       	call   801043e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104a42:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104a45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104a4b:	e8 90 f9 ff ff       	call   801043e0 <mycpu>
80104a50:	83 ec 08             	sub    $0x8,%esp
80104a53:	ff 70 04             	pushl  0x4(%eax)
80104a56:	53                   	push   %ebx
80104a57:	e8 07 0d 00 00       	call   80105763 <swtch>
  mycpu()->intena = intena;
80104a5c:	e8 7f f9 ff ff       	call   801043e0 <mycpu>
}
80104a61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104a64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104a6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a6d:	5b                   	pop    %ebx
80104a6e:	5e                   	pop    %esi
80104a6f:	5d                   	pop    %ebp
80104a70:	c3                   	ret    
    panic("sched ptable.lock");
80104a71:	83 ec 0c             	sub    $0xc,%esp
80104a74:	68 06 98 10 80       	push   $0x80109806
80104a79:	e8 12 b9 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80104a7e:	83 ec 0c             	sub    $0xc,%esp
80104a81:	68 32 98 10 80       	push   $0x80109832
80104a86:	e8 05 b9 ff ff       	call   80100390 <panic>
    panic("sched running");
80104a8b:	83 ec 0c             	sub    $0xc,%esp
80104a8e:	68 24 98 10 80       	push   $0x80109824
80104a93:	e8 f8 b8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	68 18 98 10 80       	push   $0x80109818
80104aa0:	e8 eb b8 ff ff       	call   80100390 <panic>
80104aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <exit>:
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	57                   	push   %edi
80104ab8:	56                   	push   %esi
80104ab9:	53                   	push   %ebx
80104aba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104abd:	e8 6e 08 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104ac2:	e8 19 f9 ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104ac7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104acd:	e8 ae 08 00 00       	call   80105380 <popcli>
  if(curproc == initproc)
80104ad2:	8d 5e 28             	lea    0x28(%esi),%ebx
80104ad5:	8d 7e 68             	lea    0x68(%esi),%edi
80104ad8:	39 35 d8 d5 10 80    	cmp    %esi,0x8010d5d8
80104ade:	0f 84 2e 01 00 00    	je     80104c12 <exit+0x162>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104ae8:	8b 03                	mov    (%ebx),%eax
80104aea:	85 c0                	test   %eax,%eax
80104aec:	74 12                	je     80104b00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80104aee:	83 ec 0c             	sub    $0xc,%esp
80104af1:	50                   	push   %eax
80104af2:	e8 99 c7 ff ff       	call   80101290 <fileclose>
      curproc->ofile[fd] = 0;
80104af7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104afd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104b00:	83 c3 04             	add    $0x4,%ebx
80104b03:	39 df                	cmp    %ebx,%edi
80104b05:	75 e1                	jne    80104ae8 <exit+0x38>
  begin_op();
80104b07:	e8 04 ec ff ff       	call   80103710 <begin_op>
  iput(curproc->cwd);
80104b0c:	83 ec 0c             	sub    $0xc,%esp
80104b0f:	ff 76 68             	pushl  0x68(%esi)
80104b12:	e8 49 d1 ff ff       	call   80101c60 <iput>
  end_op();
80104b17:	e8 64 ec ff ff       	call   80103780 <end_op>
  if(curproc->pid > 2) {
80104b1c:	83 c4 10             	add    $0x10,%esp
80104b1f:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
  curproc->cwd = 0;
80104b23:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  if(curproc->pid > 2) {
80104b2a:	0f 8f c1 00 00 00    	jg     80104bf1 <exit+0x141>
  acquire(&ptable.lock);
80104b30:	83 ec 0c             	sub    $0xc,%esp
80104b33:	68 00 71 18 80       	push   $0x80187100
80104b38:	e8 f3 08 00 00       	call   80105430 <acquire>
  wakeup1(curproc->parent);
80104b3d:	8b 56 14             	mov    0x14(%esi),%edx
80104b40:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b43:	b8 34 71 18 80       	mov    $0x80187134,%eax
80104b48:	eb 12                	jmp    80104b5c <exit+0xac>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b50:	05 30 04 00 00       	add    $0x430,%eax
80104b55:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104b5a:	74 1e                	je     80104b7a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80104b5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104b60:	75 ee                	jne    80104b50 <exit+0xa0>
80104b62:	3b 50 20             	cmp    0x20(%eax),%edx
80104b65:	75 e9                	jne    80104b50 <exit+0xa0>
      p->state = RUNNABLE;
80104b67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b6e:	05 30 04 00 00       	add    $0x430,%eax
80104b73:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104b78:	75 e2                	jne    80104b5c <exit+0xac>
      p->parent = initproc;
80104b7a:	8b 0d d8 d5 10 80    	mov    0x8010d5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b80:	ba 34 71 18 80       	mov    $0x80187134,%edx
80104b85:	eb 17                	jmp    80104b9e <exit+0xee>
80104b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8e:	66 90                	xchg   %ax,%ax
80104b90:	81 c2 30 04 00 00    	add    $0x430,%edx
80104b96:	81 fa 34 7d 19 80    	cmp    $0x80197d34,%edx
80104b9c:	74 3a                	je     80104bd8 <exit+0x128>
    if(p->parent == curproc){
80104b9e:	39 72 14             	cmp    %esi,0x14(%edx)
80104ba1:	75 ed                	jne    80104b90 <exit+0xe0>
      if(p->state == ZOMBIE)
80104ba3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104ba7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104baa:	75 e4                	jne    80104b90 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bac:	b8 34 71 18 80       	mov    $0x80187134,%eax
80104bb1:	eb 11                	jmp    80104bc4 <exit+0x114>
80104bb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb7:	90                   	nop
80104bb8:	05 30 04 00 00       	add    $0x430,%eax
80104bbd:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104bc2:	74 cc                	je     80104b90 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104bc4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bc8:	75 ee                	jne    80104bb8 <exit+0x108>
80104bca:	3b 48 20             	cmp    0x20(%eax),%ecx
80104bcd:	75 e9                	jne    80104bb8 <exit+0x108>
      p->state = RUNNABLE;
80104bcf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104bd6:	eb e0                	jmp    80104bb8 <exit+0x108>
  curproc->state = ZOMBIE;
80104bd8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104bdf:	e8 0c fe ff ff       	call   801049f0 <sched>
  panic("zombie exit");
80104be4:	83 ec 0c             	sub    $0xc,%esp
80104be7:	68 53 98 10 80       	push   $0x80109853
80104bec:	e8 9f b7 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104bf1:	83 ec 0c             	sub    $0xc,%esp
80104bf4:	56                   	push   %esi
80104bf5:	e8 d6 d8 ff ff       	call   801024d0 <removeSwapFile>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	0f 84 2b ff ff ff    	je     80104b30 <exit+0x80>
      panic("exit: error deleting swap file");
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	68 00 99 10 80       	push   $0x80109900
80104c0d:	e8 7e b7 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 46 98 10 80       	push   $0x80109846
80104c1a:	e8 71 b7 ff ff       	call   80100390 <panic>
80104c1f:	90                   	nop

80104c20 <yield>:
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	53                   	push   %ebx
80104c28:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c2b:	68 00 71 18 80       	push   $0x80187100
80104c30:	e8 fb 07 00 00       	call   80105430 <acquire>
  pushcli();
80104c35:	e8 f6 06 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104c3a:	e8 a1 f7 ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104c3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c45:	e8 36 07 00 00       	call   80105380 <popcli>
  myproc()->state = RUNNABLE;
80104c4a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104c51:	e8 9a fd ff ff       	call   801049f0 <sched>
  release(&ptable.lock);
80104c56:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104c5d:	e8 8e 08 00 00       	call   801054f0 <release>
}
80104c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <sleep>:
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	56                   	push   %esi
80104c79:	53                   	push   %ebx
80104c7a:	83 ec 0c             	sub    $0xc,%esp
80104c7d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c80:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104c83:	e8 a8 06 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104c88:	e8 53 f7 ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104c8d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c93:	e8 e8 06 00 00       	call   80105380 <popcli>
  if(p == 0)
80104c98:	85 db                	test   %ebx,%ebx
80104c9a:	0f 84 83 00 00 00    	je     80104d23 <sleep+0xb3>
  if(lk == 0)
80104ca0:	85 f6                	test   %esi,%esi
80104ca2:	74 72                	je     80104d16 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ca4:	81 fe 00 71 18 80    	cmp    $0x80187100,%esi
80104caa:	74 4c                	je     80104cf8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	68 00 71 18 80       	push   $0x80187100
80104cb4:	e8 77 07 00 00       	call   80105430 <acquire>
    release(lk);
80104cb9:	89 34 24             	mov    %esi,(%esp)
80104cbc:	e8 2f 08 00 00       	call   801054f0 <release>
  p->chan = chan;
80104cc1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104cc4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ccb:	e8 20 fd ff ff       	call   801049f0 <sched>
  p->chan = 0;
80104cd0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104cd7:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
80104cde:	e8 0d 08 00 00       	call   801054f0 <release>
    acquire(lk);
80104ce3:	89 75 08             	mov    %esi,0x8(%ebp)
80104ce6:	83 c4 10             	add    $0x10,%esp
}
80104ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cec:	5b                   	pop    %ebx
80104ced:	5e                   	pop    %esi
80104cee:	5f                   	pop    %edi
80104cef:	5d                   	pop    %ebp
    acquire(lk);
80104cf0:	e9 3b 07 00 00       	jmp    80105430 <acquire>
80104cf5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104cf8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104cfb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104d02:	e8 e9 fc ff ff       	call   801049f0 <sched>
  p->chan = 0;
80104d07:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d11:	5b                   	pop    %ebx
80104d12:	5e                   	pop    %esi
80104d13:	5f                   	pop    %edi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
    panic("sleep without lk");
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	68 65 98 10 80       	push   $0x80109865
80104d1e:	e8 6d b6 ff ff       	call   80100390 <panic>
    panic("sleep");
80104d23:	83 ec 0c             	sub    $0xc,%esp
80104d26:	68 5f 98 10 80       	push   $0x8010985f
80104d2b:	e8 60 b6 ff ff       	call   80100390 <panic>

80104d30 <wait>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	56                   	push   %esi
80104d38:	53                   	push   %ebx
  pushcli();
80104d39:	e8 f2 05 00 00       	call   80105330 <pushcli>
  c = mycpu();
80104d3e:	e8 9d f6 ff ff       	call   801043e0 <mycpu>
  p = c->proc;
80104d43:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104d49:	e8 32 06 00 00       	call   80105380 <popcli>
  acquire(&ptable.lock);
80104d4e:	83 ec 0c             	sub    $0xc,%esp
80104d51:	68 00 71 18 80       	push   $0x80187100
80104d56:	e8 d5 06 00 00       	call   80105430 <acquire>
80104d5b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104d5e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d60:	bb 34 71 18 80       	mov    $0x80187134,%ebx
80104d65:	eb 17                	jmp    80104d7e <wait+0x4e>
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104d76:	81 fb 34 7d 19 80    	cmp    $0x80197d34,%ebx
80104d7c:	74 1e                	je     80104d9c <wait+0x6c>
      if(p->parent != curproc)
80104d7e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104d81:	75 ed                	jne    80104d70 <wait+0x40>
      if(p->state == ZOMBIE){
80104d83:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104d87:	74 3f                	je     80104dc8 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d89:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104d8f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d94:	81 fb 34 7d 19 80    	cmp    $0x80197d34,%ebx
80104d9a:	75 e2                	jne    80104d7e <wait+0x4e>
    if(!havekids || curproc->killed){
80104d9c:	85 c0                	test   %eax,%eax
80104d9e:	0f 84 f3 00 00 00    	je     80104e97 <wait+0x167>
80104da4:	8b 46 24             	mov    0x24(%esi),%eax
80104da7:	85 c0                	test   %eax,%eax
80104da9:	0f 85 e8 00 00 00    	jne    80104e97 <wait+0x167>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104daf:	83 ec 08             	sub    $0x8,%esp
80104db2:	68 00 71 18 80       	push   $0x80187100
80104db7:	56                   	push   %esi
80104db8:	e8 b3 fe ff ff       	call   80104c70 <sleep>
    havekids = 0;
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	eb 9c                	jmp    80104d5e <wait+0x2e>
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104dc8:	83 ec 0c             	sub    $0xc,%esp
80104dcb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104dce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104dd1:	e8 ea dd ff ff       	call   80102bc0 <kfree>
        freevm(p->pgdir); // panic: kfree
80104dd6:	5a                   	pop    %edx
80104dd7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104dda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104de1:	e8 4a 34 00 00       	call   80108230 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104de6:	83 c4 0c             	add    $0xc,%esp
        p->name[0] = 0;
80104de9:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104ded:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104df3:	68 c0 01 00 00       	push   $0x1c0
80104df8:	6a 00                	push   $0x0
80104dfa:	50                   	push   %eax
        p->pid = 0;
80104dfb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104e02:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104e09:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104e10:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104e17:	00 00 00 
        p->swapFile = 0;
80104e1a:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104e21:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104e28:	00 00 00 
        p->free_tail = 0;
80104e2b:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104e32:	00 00 00 
        p->queue_head = 0;
80104e35:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104e3c:	00 00 00 
        p->queue_tail = 0;
80104e3f:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104e46:	00 00 00 
        p->numswappages = 0;
80104e49:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104e50:	00 00 00 
        p-> nummemorypages = 0;
80104e53:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104e5a:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104e5d:	e8 de 06 00 00       	call   80105540 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104e62:	83 c4 0c             	add    $0xc,%esp
80104e65:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104e6b:	68 c0 01 00 00       	push   $0x1c0
80104e70:	6a 00                	push   $0x0
80104e72:	50                   	push   %eax
80104e73:	e8 c8 06 00 00       	call   80105540 <memset>
        release(&ptable.lock);
80104e78:	c7 04 24 00 71 18 80 	movl   $0x80187100,(%esp)
        p->state = UNUSED;
80104e7f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104e86:	e8 65 06 00 00       	call   801054f0 <release>
        return pid;
80104e8b:	83 c4 10             	add    $0x10,%esp
}
80104e8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e91:	89 f0                	mov    %esi,%eax
80104e93:	5b                   	pop    %ebx
80104e94:	5e                   	pop    %esi
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    
      release(&ptable.lock);
80104e97:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104e9a:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104e9f:	68 00 71 18 80       	push   $0x80187100
80104ea4:	e8 47 06 00 00       	call   801054f0 <release>
      return -1;
80104ea9:	83 c4 10             	add    $0x10,%esp
80104eac:	eb e0                	jmp    80104e8e <wait+0x15e>
80104eae:	66 90                	xchg   %ax,%ax

80104eb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	53                   	push   %ebx
80104eb8:	83 ec 10             	sub    $0x10,%esp
80104ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104ebe:	68 00 71 18 80       	push   $0x80187100
80104ec3:	e8 68 05 00 00       	call   80105430 <acquire>
80104ec8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ecb:	b8 34 71 18 80       	mov    $0x80187134,%eax
80104ed0:	eb 12                	jmp    80104ee4 <wakeup+0x34>
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed8:	05 30 04 00 00       	add    $0x430,%eax
80104edd:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104ee2:	74 1e                	je     80104f02 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104ee4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ee8:	75 ee                	jne    80104ed8 <wakeup+0x28>
80104eea:	3b 58 20             	cmp    0x20(%eax),%ebx
80104eed:	75 e9                	jne    80104ed8 <wakeup+0x28>
      p->state = RUNNABLE;
80104eef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ef6:	05 30 04 00 00       	add    $0x430,%eax
80104efb:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104f00:	75 e2                	jne    80104ee4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104f02:	c7 45 08 00 71 18 80 	movl   $0x80187100,0x8(%ebp)
}
80104f09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f0c:	c9                   	leave  
  release(&ptable.lock);
80104f0d:	e9 de 05 00 00       	jmp    801054f0 <release>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	53                   	push   %ebx
80104f28:	83 ec 10             	sub    $0x10,%esp
80104f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104f2e:	68 00 71 18 80       	push   $0x80187100
80104f33:	e8 f8 04 00 00       	call   80105430 <acquire>
80104f38:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f3b:	b8 34 71 18 80       	mov    $0x80187134,%eax
80104f40:	eb 12                	jmp    80104f54 <kill+0x34>
80104f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f48:	05 30 04 00 00       	add    $0x430,%eax
80104f4d:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104f52:	74 34                	je     80104f88 <kill+0x68>
    if(p->pid == pid){
80104f54:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f57:	75 ef                	jne    80104f48 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f59:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104f5d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104f64:	75 07                	jne    80104f6d <kill+0x4d>
        p->state = RUNNABLE;
80104f66:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	68 00 71 18 80       	push   $0x80187100
80104f75:	e8 76 05 00 00       	call   801054f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	31 c0                	xor    %eax,%eax
}
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	68 00 71 18 80       	push   $0x80187100
80104f90:	e8 5b 05 00 00       	call   801054f0 <release>
}
80104f95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104fb8:	31 db                	xor    %ebx,%ebx
{
80104fba:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104fbd:	68 00 71 18 80       	push   $0x80187100
80104fc2:	e8 69 04 00 00       	call   80105430 <acquire>
80104fc7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fca:	b8 34 71 18 80       	mov    $0x80187134,%eax
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104fcf:	b9 10 00 00 00       	mov    $0x10,%ecx
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == UNUSED)
80104fd8:	8b 50 0c             	mov    0xc(%eax),%edx
80104fdb:	85 d2                	test   %edx,%edx
80104fdd:	74 0a                	je     80104fe9 <getCurrentFreePages+0x39>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104fdf:	89 ca                	mov    %ecx,%edx
80104fe1:	2b 90 08 04 00 00    	sub    0x408(%eax),%edx
80104fe7:	01 d3                	add    %edx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fe9:	05 30 04 00 00       	add    $0x430,%eax
80104fee:	3d 34 7d 19 80       	cmp    $0x80197d34,%eax
80104ff3:	75 e3                	jne    80104fd8 <getCurrentFreePages+0x28>
    pcount++;
  }
  release(&ptable.lock);
80104ff5:	83 ec 0c             	sub    $0xc,%esp
80104ff8:	68 00 71 18 80       	push   $0x80187100
80104ffd:	e8 ee 04 00 00       	call   801054f0 <release>
  return sum;
}
80105002:	89 d8                	mov    %ebx,%eax
80105004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105007:	c9                   	leave  
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105010 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80105018:	31 db                	xor    %ebx,%ebx
{
8010501a:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010501d:	68 00 71 18 80       	push   $0x80187100
80105022:	e8 09 04 00 00       	call   80105430 <acquire>
80105027:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010502a:	ba 34 71 18 80       	mov    $0x80187134,%edx
8010502f:	90                   	nop
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80105030:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80105034:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105037:	81 c2 30 04 00 00    	add    $0x430,%edx
8010503d:	81 fa 34 7d 19 80    	cmp    $0x80197d34,%edx
80105043:	75 eb                	jne    80105030 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	68 00 71 18 80       	push   $0x80187100
8010504d:	e8 9e 04 00 00       	call   801054f0 <release>
  return pcount * MAX_PSYC_PAGES;
80105052:	89 d8                	mov    %ebx,%eax
80105054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105057:	c9                   	leave  
  return pcount * MAX_PSYC_PAGES;
80105058:	c1 e0 04             	shl    $0x4,%eax
8010505b:	c3                   	ret    
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <procdump>:
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	57                   	push   %edi
80105068:	56                   	push   %esi
80105069:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010506c:	53                   	push   %ebx
8010506d:	bb a0 71 18 80       	mov    $0x801871a0,%ebx
80105072:	83 ec 3c             	sub    $0x3c,%esp
80105075:	eb 45                	jmp    801050bc <procdump+0x5c>
80105077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507e:	66 90                	xchg   %ax,%ax
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80105080:	e8 8b ff ff ff       	call   80105010 <getTotalFreePages>
80105085:	89 c7                	mov    %eax,%edi
80105087:	e8 24 ff ff ff       	call   80104fb0 <getCurrentFreePages>
8010508c:	83 ec 04             	sub    $0x4,%esp
8010508f:	57                   	push   %edi
80105090:	50                   	push   %eax
80105091:	68 7a 98 10 80       	push   $0x8010987a
80105096:	e8 15 b6 ff ff       	call   801006b0 <cprintf>
    cprintf("\n");
8010509b:	c7 04 24 40 9d 10 80 	movl   $0x80109d40,(%esp)
801050a2:	e8 09 b6 ff ff       	call   801006b0 <cprintf>
801050a7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050aa:	81 c3 30 04 00 00    	add    $0x430,%ebx
801050b0:	81 fb a0 7d 19 80    	cmp    $0x80197da0,%ebx
801050b6:	0f 84 a4 00 00 00    	je     80105160 <procdump+0x100>
    if(p->state == UNUSED)
801050bc:	8b 43 a0             	mov    -0x60(%ebx),%eax
801050bf:	85 c0                	test   %eax,%eax
801050c1:	74 e7                	je     801050aa <procdump+0x4a>
      state = "???";
801050c3:	ba 76 98 10 80       	mov    $0x80109876,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050c8:	83 f8 05             	cmp    $0x5,%eax
801050cb:	77 11                	ja     801050de <procdump+0x7e>
801050cd:	8b 14 85 88 99 10 80 	mov    -0x7fef6678(,%eax,4),%edx
      state = "???";
801050d4:	b8 76 98 10 80       	mov    $0x80109876,%eax
801050d9:	85 d2                	test   %edx,%edx
801050db:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
801050de:	ff b3 c0 03 00 00    	pushl  0x3c0(%ebx)
801050e4:	ff b3 bc 03 00 00    	pushl  0x3bc(%ebx)
801050ea:	ff b3 a0 03 00 00    	pushl  0x3a0(%ebx)
801050f0:	ff b3 9c 03 00 00    	pushl  0x39c(%ebx)
801050f6:	53                   	push   %ebx
801050f7:	52                   	push   %edx
801050f8:	ff 73 a4             	pushl  -0x5c(%ebx)
801050fb:	68 20 99 10 80       	push   $0x80109920
80105100:	e8 ab b5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80105105:	83 c4 20             	add    $0x20,%esp
80105108:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010510c:	0f 85 6e ff ff ff    	jne    80105080 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105112:	83 ec 08             	sub    $0x8,%esp
80105115:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105118:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010511b:	50                   	push   %eax
8010511c:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010511f:	8b 40 0c             	mov    0xc(%eax),%eax
80105122:	83 c0 08             	add    $0x8,%eax
80105125:	50                   	push   %eax
80105126:	e8 a5 01 00 00       	call   801052d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010512b:	83 c4 10             	add    $0x10,%esp
8010512e:	66 90                	xchg   %ax,%ax
80105130:	8b 17                	mov    (%edi),%edx
80105132:	85 d2                	test   %edx,%edx
80105134:	0f 84 46 ff ff ff    	je     80105080 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010513a:	83 ec 08             	sub    $0x8,%esp
8010513d:	83 c7 04             	add    $0x4,%edi
80105140:	52                   	push   %edx
80105141:	68 e1 91 10 80       	push   $0x801091e1
80105146:	e8 65 b5 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010514b:	83 c4 10             	add    $0x10,%esp
8010514e:	39 fe                	cmp    %edi,%esi
80105150:	75 de                	jne    80105130 <procdump+0xd0>
80105152:	e9 29 ff ff ff       	jmp    80105080 <procdump+0x20>
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax
}
80105160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105163:	5b                   	pop    %ebx
80105164:	5e                   	pop    %esi
80105165:	5f                   	pop    %edi
80105166:	5d                   	pop    %ebp
80105167:	c3                   	ret    
80105168:	66 90                	xchg   %ax,%ax
8010516a:	66 90                	xchg   %ax,%ax
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	53                   	push   %ebx
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010517e:	68 a0 99 10 80       	push   $0x801099a0
80105183:	8d 43 04             	lea    0x4(%ebx),%eax
80105186:	50                   	push   %eax
80105187:	e8 24 01 00 00       	call   801052b0 <initlock>
  lk->name = name;
8010518c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010518f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105195:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105198:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010519f:	89 43 38             	mov    %eax,0x38(%ebx)
}
801051a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	56                   	push   %esi
801051b8:	53                   	push   %ebx
801051b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801051bc:	8d 73 04             	lea    0x4(%ebx),%esi
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	56                   	push   %esi
801051c3:	e8 68 02 00 00       	call   80105430 <acquire>
  while (lk->locked) {
801051c8:	8b 13                	mov    (%ebx),%edx
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 d2                	test   %edx,%edx
801051cf:	74 1a                	je     801051eb <acquiresleep+0x3b>
801051d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801051d8:	83 ec 08             	sub    $0x8,%esp
801051db:	56                   	push   %esi
801051dc:	53                   	push   %ebx
801051dd:	e8 8e fa ff ff       	call   80104c70 <sleep>
  while (lk->locked) {
801051e2:	8b 03                	mov    (%ebx),%eax
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	75 ed                	jne    801051d8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801051eb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801051f1:	e8 7a f2 ff ff       	call   80104470 <myproc>
801051f6:	8b 40 10             	mov    0x10(%eax),%eax
801051f9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801051fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801051ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105202:	5b                   	pop    %ebx
80105203:	5e                   	pop    %esi
80105204:	5d                   	pop    %ebp
  release(&lk->lk);
80105205:	e9 e6 02 00 00       	jmp    801054f0 <release>
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105210 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	53                   	push   %ebx
80105219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010521c:	8d 73 04             	lea    0x4(%ebx),%esi
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	56                   	push   %esi
80105223:	e8 08 02 00 00       	call   80105430 <acquire>
  lk->locked = 0;
80105228:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010522e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105235:	89 1c 24             	mov    %ebx,(%esp)
80105238:	e8 73 fc ff ff       	call   80104eb0 <wakeup>
  release(&lk->lk);
8010523d:	89 75 08             	mov    %esi,0x8(%ebp)
80105240:	83 c4 10             	add    $0x10,%esp
}
80105243:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105246:	5b                   	pop    %ebx
80105247:	5e                   	pop    %esi
80105248:	5d                   	pop    %ebp
  release(&lk->lk);
80105249:	e9 a2 02 00 00       	jmp    801054f0 <release>
8010524e:	66 90                	xchg   %ax,%ax

80105250 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	57                   	push   %edi
80105258:	31 ff                	xor    %edi,%edi
8010525a:	56                   	push   %esi
8010525b:	53                   	push   %ebx
8010525c:	83 ec 18             	sub    $0x18,%esp
8010525f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105262:	8d 73 04             	lea    0x4(%ebx),%esi
80105265:	56                   	push   %esi
80105266:	e8 c5 01 00 00       	call   80105430 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010526b:	8b 03                	mov    (%ebx),%eax
8010526d:	83 c4 10             	add    $0x10,%esp
80105270:	85 c0                	test   %eax,%eax
80105272:	75 1c                	jne    80105290 <holdingsleep+0x40>
  release(&lk->lk);
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	56                   	push   %esi
80105278:	e8 73 02 00 00       	call   801054f0 <release>
  return r;
}
8010527d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105280:	89 f8                	mov    %edi,%eax
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5f                   	pop    %edi
80105285:	5d                   	pop    %ebp
80105286:	c3                   	ret    
80105287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105290:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105293:	e8 d8 f1 ff ff       	call   80104470 <myproc>
80105298:	39 58 10             	cmp    %ebx,0x10(%eax)
8010529b:	0f 94 c0             	sete   %al
8010529e:	0f b6 c0             	movzbl %al,%eax
801052a1:	89 c7                	mov    %eax,%edi
801052a3:	eb cf                	jmp    80105274 <holdingsleep+0x24>
801052a5:	66 90                	xchg   %ax,%ax
801052a7:	66 90                	xchg   %ax,%ax
801052a9:	66 90                	xchg   %ax,%ax
801052ab:	66 90                	xchg   %ax,%ax
801052ad:	66 90                	xchg   %ax,%ax
801052af:	90                   	nop

801052b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801052ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801052bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801052c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801052c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052cd:	5d                   	pop    %ebp
801052ce:	c3                   	ret    
801052cf:	90                   	nop

801052d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801052d5:	31 d2                	xor    %edx,%edx
{
801052d7:	89 e5                	mov    %esp,%ebp
801052d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801052da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801052dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801052e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801052e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801052ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801052f4:	77 1a                	ja     80105310 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052f6:	8b 58 04             	mov    0x4(%eax),%ebx
801052f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801052fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801052ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105301:	83 fa 0a             	cmp    $0xa,%edx
80105304:	75 e2                	jne    801052e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105306:	5b                   	pop    %ebx
80105307:	5d                   	pop    %ebp
80105308:	c3                   	ret    
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105310:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105313:	8d 51 28             	lea    0x28(%ecx),%edx
80105316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105326:	83 c0 04             	add    $0x4,%eax
80105329:	39 d0                	cmp    %edx,%eax
8010532b:	75 f3                	jne    80105320 <getcallerpcs+0x50>
}
8010532d:	5b                   	pop    %ebx
8010532e:	5d                   	pop    %ebp
8010532f:	c3                   	ret    

80105330 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	53                   	push   %ebx
80105338:	83 ec 04             	sub    $0x4,%esp
8010533b:	9c                   	pushf  
8010533c:	5b                   	pop    %ebx
  asm volatile("cli");
8010533d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010533e:	e8 9d f0 ff ff       	call   801043e0 <mycpu>
80105343:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105349:	85 c0                	test   %eax,%eax
8010534b:	74 13                	je     80105360 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010534d:	e8 8e f0 ff ff       	call   801043e0 <mycpu>
80105352:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105359:	83 c4 04             	add    $0x4,%esp
8010535c:	5b                   	pop    %ebx
8010535d:	5d                   	pop    %ebp
8010535e:	c3                   	ret    
8010535f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105360:	e8 7b f0 ff ff       	call   801043e0 <mycpu>
80105365:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010536b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105371:	eb da                	jmp    8010534d <pushcli+0x1d>
80105373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105380 <popcli>:

void
popcli(void)
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010538a:	9c                   	pushf  
8010538b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010538c:	f6 c4 02             	test   $0x2,%ah
8010538f:	75 31                	jne    801053c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105391:	e8 4a f0 ff ff       	call   801043e0 <mycpu>
80105396:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010539d:	78 30                	js     801053cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010539f:	e8 3c f0 ff ff       	call   801043e0 <mycpu>
801053a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801053aa:	85 d2                	test   %edx,%edx
801053ac:	74 02                	je     801053b0 <popcli+0x30>
    sti();
}
801053ae:	c9                   	leave  
801053af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801053b0:	e8 2b f0 ff ff       	call   801043e0 <mycpu>
801053b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801053bb:	85 c0                	test   %eax,%eax
801053bd:	74 ef                	je     801053ae <popcli+0x2e>
  asm volatile("sti");
801053bf:	fb                   	sti    
}
801053c0:	c9                   	leave  
801053c1:	c3                   	ret    
    panic("popcli - interruptible");
801053c2:	83 ec 0c             	sub    $0xc,%esp
801053c5:	68 ab 99 10 80       	push   $0x801099ab
801053ca:	e8 c1 af ff ff       	call   80100390 <panic>
    panic("popcli");
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	68 c2 99 10 80       	push   $0x801099c2
801053d7:	e8 b4 af ff ff       	call   80100390 <panic>
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <holding>:
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	56                   	push   %esi
801053e8:	53                   	push   %ebx
801053e9:	8b 75 08             	mov    0x8(%ebp),%esi
801053ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801053ee:	e8 3d ff ff ff       	call   80105330 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801053f3:	8b 06                	mov    (%esi),%eax
801053f5:	85 c0                	test   %eax,%eax
801053f7:	75 0f                	jne    80105408 <holding+0x28>
  popcli();
801053f9:	e8 82 ff ff ff       	call   80105380 <popcli>
}
801053fe:	89 d8                	mov    %ebx,%eax
80105400:	5b                   	pop    %ebx
80105401:	5e                   	pop    %esi
80105402:	5d                   	pop    %ebp
80105403:	c3                   	ret    
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105408:	8b 5e 08             	mov    0x8(%esi),%ebx
8010540b:	e8 d0 ef ff ff       	call   801043e0 <mycpu>
80105410:	39 c3                	cmp    %eax,%ebx
80105412:	0f 94 c3             	sete   %bl
  popcli();
80105415:	e8 66 ff ff ff       	call   80105380 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010541a:	0f b6 db             	movzbl %bl,%ebx
}
8010541d:	89 d8                	mov    %ebx,%eax
8010541f:	5b                   	pop    %ebx
80105420:	5e                   	pop    %esi
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105430 <acquire>:
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	56                   	push   %esi
80105438:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105439:	e8 f2 fe ff ff       	call   80105330 <pushcli>
  if(holding(lk))
8010543e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105441:	83 ec 0c             	sub    $0xc,%esp
80105444:	53                   	push   %ebx
80105445:	e8 96 ff ff ff       	call   801053e0 <holding>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	85 c0                	test   %eax,%eax
8010544f:	0f 85 7f 00 00 00    	jne    801054d4 <acquire+0xa4>
80105455:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105457:	ba 01 00 00 00       	mov    $0x1,%edx
8010545c:	eb 05                	jmp    80105463 <acquire+0x33>
8010545e:	66 90                	xchg   %ax,%ax
80105460:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105463:	89 d0                	mov    %edx,%eax
80105465:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105468:	85 c0                	test   %eax,%eax
8010546a:	75 f4                	jne    80105460 <acquire+0x30>
  __sync_synchronize();
8010546c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105471:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105474:	e8 67 ef ff ff       	call   801043e0 <mycpu>
80105479:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010547c:	89 e8                	mov    %ebp,%eax
8010547e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105480:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105486:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010548c:	77 22                	ja     801054b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010548e:	8b 50 04             	mov    0x4(%eax),%edx
80105491:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105495:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105498:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010549a:	83 fe 0a             	cmp    $0xa,%esi
8010549d:	75 e1                	jne    80105480 <acquire+0x50>
}
8010549f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5d                   	pop    %ebp
801054a5:	c3                   	ret    
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801054b0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801054b4:	83 c3 34             	add    $0x34,%ebx
801054b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801054c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801054c6:	83 c0 04             	add    $0x4,%eax
801054c9:	39 d8                	cmp    %ebx,%eax
801054cb:	75 f3                	jne    801054c0 <acquire+0x90>
}
801054cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d0:	5b                   	pop    %ebx
801054d1:	5e                   	pop    %esi
801054d2:	5d                   	pop    %ebp
801054d3:	c3                   	ret    
    panic("acquire");
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	68 c9 99 10 80       	push   $0x801099c9
801054dc:	e8 af ae ff ff       	call   80100390 <panic>
801054e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ef:	90                   	nop

801054f0 <release>:
{
801054f0:	f3 0f 1e fb          	endbr32 
801054f4:	55                   	push   %ebp
801054f5:	89 e5                	mov    %esp,%ebp
801054f7:	53                   	push   %ebx
801054f8:	83 ec 10             	sub    $0x10,%esp
801054fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801054fe:	53                   	push   %ebx
801054ff:	e8 dc fe ff ff       	call   801053e0 <holding>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	74 22                	je     8010552d <release+0x3d>
  lk->pcs[0] = 0;
8010550b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105512:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105519:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010551e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105527:	c9                   	leave  
  popcli();
80105528:	e9 53 fe ff ff       	jmp    80105380 <popcli>
    panic("release");
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	68 d1 99 10 80       	push   $0x801099d1
80105535:	e8 56 ae ff ff       	call   80100390 <panic>
8010553a:	66 90                	xchg   %ax,%ax
8010553c:	66 90                	xchg   %ax,%ax
8010553e:	66 90                	xchg   %ax,%ax

80105540 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
80105545:	89 e5                	mov    %esp,%ebp
80105547:	57                   	push   %edi
80105548:	8b 55 08             	mov    0x8(%ebp),%edx
8010554b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010554e:	53                   	push   %ebx
8010554f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105552:	89 d7                	mov    %edx,%edi
80105554:	09 cf                	or     %ecx,%edi
80105556:	83 e7 03             	and    $0x3,%edi
80105559:	75 25                	jne    80105580 <memset+0x40>
    c &= 0xFF;
8010555b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010555e:	c1 e0 18             	shl    $0x18,%eax
80105561:	89 fb                	mov    %edi,%ebx
80105563:	c1 e9 02             	shr    $0x2,%ecx
80105566:	c1 e3 10             	shl    $0x10,%ebx
80105569:	09 d8                	or     %ebx,%eax
8010556b:	09 f8                	or     %edi,%eax
8010556d:	c1 e7 08             	shl    $0x8,%edi
80105570:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105572:	89 d7                	mov    %edx,%edi
80105574:	fc                   	cld    
80105575:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105577:	5b                   	pop    %ebx
80105578:	89 d0                	mov    %edx,%eax
8010557a:	5f                   	pop    %edi
8010557b:	5d                   	pop    %ebp
8010557c:	c3                   	ret    
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105580:	89 d7                	mov    %edx,%edi
80105582:	fc                   	cld    
80105583:	f3 aa                	rep stos %al,%es:(%edi)
80105585:	5b                   	pop    %ebx
80105586:	89 d0                	mov    %edx,%eax
80105588:	5f                   	pop    %edi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop

80105590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
80105595:	89 e5                	mov    %esp,%ebp
80105597:	56                   	push   %esi
80105598:	8b 75 10             	mov    0x10(%ebp),%esi
8010559b:	8b 55 08             	mov    0x8(%ebp),%edx
8010559e:	53                   	push   %ebx
8010559f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801055a2:	85 f6                	test   %esi,%esi
801055a4:	74 2a                	je     801055d0 <memcmp+0x40>
801055a6:	01 c6                	add    %eax,%esi
801055a8:	eb 10                	jmp    801055ba <memcmp+0x2a>
801055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801055b0:	83 c0 01             	add    $0x1,%eax
801055b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801055b6:	39 f0                	cmp    %esi,%eax
801055b8:	74 16                	je     801055d0 <memcmp+0x40>
    if(*s1 != *s2)
801055ba:	0f b6 0a             	movzbl (%edx),%ecx
801055bd:	0f b6 18             	movzbl (%eax),%ebx
801055c0:	38 d9                	cmp    %bl,%cl
801055c2:	74 ec                	je     801055b0 <memcmp+0x20>
      return *s1 - *s2;
801055c4:	0f b6 c1             	movzbl %cl,%eax
801055c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801055c9:	5b                   	pop    %ebx
801055ca:	5e                   	pop    %esi
801055cb:	5d                   	pop    %ebp
801055cc:	c3                   	ret    
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
801055d0:	5b                   	pop    %ebx
  return 0;
801055d1:	31 c0                	xor    %eax,%eax
}
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi

801055e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	57                   	push   %edi
801055e8:	8b 55 08             	mov    0x8(%ebp),%edx
801055eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801055ee:	56                   	push   %esi
801055ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801055f2:	39 d6                	cmp    %edx,%esi
801055f4:	73 2a                	jae    80105620 <memmove+0x40>
801055f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801055f9:	39 fa                	cmp    %edi,%edx
801055fb:	73 23                	jae    80105620 <memmove+0x40>
801055fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105600:	85 c9                	test   %ecx,%ecx
80105602:	74 13                	je     80105617 <memmove+0x37>
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105608:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010560c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010560f:	83 e8 01             	sub    $0x1,%eax
80105612:	83 f8 ff             	cmp    $0xffffffff,%eax
80105615:	75 f1                	jne    80105608 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105617:	5e                   	pop    %esi
80105618:	89 d0                	mov    %edx,%eax
8010561a:	5f                   	pop    %edi
8010561b:	5d                   	pop    %ebp
8010561c:	c3                   	ret    
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105620:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105623:	89 d7                	mov    %edx,%edi
80105625:	85 c9                	test   %ecx,%ecx
80105627:	74 ee                	je     80105617 <memmove+0x37>
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105630:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105631:	39 f0                	cmp    %esi,%eax
80105633:	75 fb                	jne    80105630 <memmove+0x50>
}
80105635:	5e                   	pop    %esi
80105636:	89 d0                	mov    %edx,%eax
80105638:	5f                   	pop    %edi
80105639:	5d                   	pop    %ebp
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop

80105640 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105640:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105644:	eb 9a                	jmp    801055e0 <memmove>
80105646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564d:	8d 76 00             	lea    0x0(%esi),%esi

80105650 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	56                   	push   %esi
80105658:	8b 75 10             	mov    0x10(%ebp),%esi
8010565b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010565e:	53                   	push   %ebx
8010565f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105662:	85 f6                	test   %esi,%esi
80105664:	74 32                	je     80105698 <strncmp+0x48>
80105666:	01 c6                	add    %eax,%esi
80105668:	eb 14                	jmp    8010567e <strncmp+0x2e>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105670:	38 da                	cmp    %bl,%dl
80105672:	75 14                	jne    80105688 <strncmp+0x38>
    n--, p++, q++;
80105674:	83 c0 01             	add    $0x1,%eax
80105677:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010567a:	39 f0                	cmp    %esi,%eax
8010567c:	74 1a                	je     80105698 <strncmp+0x48>
8010567e:	0f b6 11             	movzbl (%ecx),%edx
80105681:	0f b6 18             	movzbl (%eax),%ebx
80105684:	84 d2                	test   %dl,%dl
80105686:	75 e8                	jne    80105670 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105688:	0f b6 c2             	movzbl %dl,%eax
8010568b:	29 d8                	sub    %ebx,%eax
}
8010568d:	5b                   	pop    %ebx
8010568e:	5e                   	pop    %esi
8010568f:	5d                   	pop    %ebp
80105690:	c3                   	ret    
80105691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105698:	5b                   	pop    %ebx
    return 0;
80105699:	31 c0                	xor    %eax,%eax
}
8010569b:	5e                   	pop    %esi
8010569c:	5d                   	pop    %ebp
8010569d:	c3                   	ret    
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	57                   	push   %edi
801056a8:	56                   	push   %esi
801056a9:	8b 75 08             	mov    0x8(%ebp),%esi
801056ac:	53                   	push   %ebx
801056ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801056b0:	89 f2                	mov    %esi,%edx
801056b2:	eb 1b                	jmp    801056cf <strncpy+0x2f>
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801056bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801056bf:	83 c2 01             	add    $0x1,%edx
801056c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801056c6:	89 f9                	mov    %edi,%ecx
801056c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801056cb:	84 c9                	test   %cl,%cl
801056cd:	74 09                	je     801056d8 <strncpy+0x38>
801056cf:	89 c3                	mov    %eax,%ebx
801056d1:	83 e8 01             	sub    $0x1,%eax
801056d4:	85 db                	test   %ebx,%ebx
801056d6:	7f e0                	jg     801056b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801056d8:	89 d1                	mov    %edx,%ecx
801056da:	85 c0                	test   %eax,%eax
801056dc:	7e 15                	jle    801056f3 <strncpy+0x53>
801056de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801056e0:	83 c1 01             	add    $0x1,%ecx
801056e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801056e7:	89 c8                	mov    %ecx,%eax
801056e9:	f7 d0                	not    %eax
801056eb:	01 d0                	add    %edx,%eax
801056ed:	01 d8                	add    %ebx,%eax
801056ef:	85 c0                	test   %eax,%eax
801056f1:	7f ed                	jg     801056e0 <strncpy+0x40>
  return os;
}
801056f3:	5b                   	pop    %ebx
801056f4:	89 f0                	mov    %esi,%eax
801056f6:	5e                   	pop    %esi
801056f7:	5f                   	pop    %edi
801056f8:	5d                   	pop    %ebp
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105700 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	56                   	push   %esi
80105708:	8b 55 10             	mov    0x10(%ebp),%edx
8010570b:	8b 75 08             	mov    0x8(%ebp),%esi
8010570e:	53                   	push   %ebx
8010570f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105712:	85 d2                	test   %edx,%edx
80105714:	7e 21                	jle    80105737 <safestrcpy+0x37>
80105716:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010571a:	89 f2                	mov    %esi,%edx
8010571c:	eb 12                	jmp    80105730 <safestrcpy+0x30>
8010571e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105720:	0f b6 08             	movzbl (%eax),%ecx
80105723:	83 c0 01             	add    $0x1,%eax
80105726:	83 c2 01             	add    $0x1,%edx
80105729:	88 4a ff             	mov    %cl,-0x1(%edx)
8010572c:	84 c9                	test   %cl,%cl
8010572e:	74 04                	je     80105734 <safestrcpy+0x34>
80105730:	39 d8                	cmp    %ebx,%eax
80105732:	75 ec                	jne    80105720 <safestrcpy+0x20>
    ;
  *s = 0;
80105734:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105737:	89 f0                	mov    %esi,%eax
80105739:	5b                   	pop    %ebx
8010573a:	5e                   	pop    %esi
8010573b:	5d                   	pop    %ebp
8010573c:	c3                   	ret    
8010573d:	8d 76 00             	lea    0x0(%esi),%esi

80105740 <strlen>:

int
strlen(const char *s)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105745:	31 c0                	xor    %eax,%eax
{
80105747:	89 e5                	mov    %esp,%ebp
80105749:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010574c:	80 3a 00             	cmpb   $0x0,(%edx)
8010574f:	74 10                	je     80105761 <strlen+0x21>
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105758:	83 c0 01             	add    $0x1,%eax
8010575b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010575f:	75 f7                	jne    80105758 <strlen+0x18>
    ;
  return n;
}
80105761:	5d                   	pop    %ebp
80105762:	c3                   	ret    

80105763 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105763:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105767:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010576b:	55                   	push   %ebp
  pushl %ebx
8010576c:	53                   	push   %ebx
  pushl %esi
8010576d:	56                   	push   %esi
  pushl %edi
8010576e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010576f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105771:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105773:	5f                   	pop    %edi
  popl %esi
80105774:	5e                   	pop    %esi
  popl %ebx
80105775:	5b                   	pop    %ebx
  popl %ebp
80105776:	5d                   	pop    %ebp
  ret
80105777:	c3                   	ret    
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	53                   	push   %ebx
80105788:	83 ec 04             	sub    $0x4,%esp
8010578b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010578e:	e8 dd ec ff ff       	call   80104470 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105793:	8b 00                	mov    (%eax),%eax
80105795:	39 d8                	cmp    %ebx,%eax
80105797:	76 17                	jbe    801057b0 <fetchint+0x30>
80105799:	8d 53 04             	lea    0x4(%ebx),%edx
8010579c:	39 d0                	cmp    %edx,%eax
8010579e:	72 10                	jb     801057b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801057a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a3:	8b 13                	mov    (%ebx),%edx
801057a5:	89 10                	mov    %edx,(%eax)
  return 0;
801057a7:	31 c0                	xor    %eax,%eax
}
801057a9:	83 c4 04             	add    $0x4,%esp
801057ac:	5b                   	pop    %ebx
801057ad:	5d                   	pop    %ebp
801057ae:	c3                   	ret    
801057af:	90                   	nop
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b5:	eb f2                	jmp    801057a9 <fetchint+0x29>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	53                   	push   %ebx
801057c8:	83 ec 04             	sub    $0x4,%esp
801057cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801057ce:	e8 9d ec ff ff       	call   80104470 <myproc>

  if(addr >= curproc->sz)
801057d3:	39 18                	cmp    %ebx,(%eax)
801057d5:	76 31                	jbe    80105808 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801057d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801057da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801057dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801057de:	39 d3                	cmp    %edx,%ebx
801057e0:	73 26                	jae    80105808 <fetchstr+0x48>
801057e2:	89 d8                	mov    %ebx,%eax
801057e4:	eb 11                	jmp    801057f7 <fetchstr+0x37>
801057e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ed:	8d 76 00             	lea    0x0(%esi),%esi
801057f0:	83 c0 01             	add    $0x1,%eax
801057f3:	39 c2                	cmp    %eax,%edx
801057f5:	76 11                	jbe    80105808 <fetchstr+0x48>
    if(*s == 0)
801057f7:	80 38 00             	cmpb   $0x0,(%eax)
801057fa:	75 f4                	jne    801057f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801057fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801057ff:	29 d8                	sub    %ebx,%eax
}
80105801:	5b                   	pop    %ebx
80105802:	5d                   	pop    %ebp
80105803:	c3                   	ret    
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105808:	83 c4 04             	add    $0x4,%esp
    return -1;
8010580b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105810:	5b                   	pop    %ebx
80105811:	5d                   	pop    %ebp
80105812:	c3                   	ret    
80105813:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105820 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	56                   	push   %esi
80105828:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105829:	e8 42 ec ff ff       	call   80104470 <myproc>
8010582e:	8b 55 08             	mov    0x8(%ebp),%edx
80105831:	8b 40 18             	mov    0x18(%eax),%eax
80105834:	8b 40 44             	mov    0x44(%eax),%eax
80105837:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010583a:	e8 31 ec ff ff       	call   80104470 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010583f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105842:	8b 00                	mov    (%eax),%eax
80105844:	39 c6                	cmp    %eax,%esi
80105846:	73 18                	jae    80105860 <argint+0x40>
80105848:	8d 53 08             	lea    0x8(%ebx),%edx
8010584b:	39 d0                	cmp    %edx,%eax
8010584d:	72 11                	jb     80105860 <argint+0x40>
  *ip = *(int*)(addr);
8010584f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105852:	8b 53 04             	mov    0x4(%ebx),%edx
80105855:	89 10                	mov    %edx,(%eax)
  return 0;
80105857:	31 c0                	xor    %eax,%eax
}
80105859:	5b                   	pop    %ebx
8010585a:	5e                   	pop    %esi
8010585b:	5d                   	pop    %ebp
8010585c:	c3                   	ret    
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105865:	eb f2                	jmp    80105859 <argint+0x39>
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax

80105870 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105870:	f3 0f 1e fb          	endbr32 
80105874:	55                   	push   %ebp
80105875:	89 e5                	mov    %esp,%ebp
80105877:	56                   	push   %esi
80105878:	53                   	push   %ebx
80105879:	83 ec 10             	sub    $0x10,%esp
8010587c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010587f:	e8 ec eb ff ff       	call   80104470 <myproc>
 
  if(argint(n, &i) < 0)
80105884:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105887:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105889:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588c:	50                   	push   %eax
8010588d:	ff 75 08             	pushl  0x8(%ebp)
80105890:	e8 8b ff ff ff       	call   80105820 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105895:	83 c4 10             	add    $0x10,%esp
80105898:	85 c0                	test   %eax,%eax
8010589a:	78 24                	js     801058c0 <argptr+0x50>
8010589c:	85 db                	test   %ebx,%ebx
8010589e:	78 20                	js     801058c0 <argptr+0x50>
801058a0:	8b 16                	mov    (%esi),%edx
801058a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a5:	39 c2                	cmp    %eax,%edx
801058a7:	76 17                	jbe    801058c0 <argptr+0x50>
801058a9:	01 c3                	add    %eax,%ebx
801058ab:	39 da                	cmp    %ebx,%edx
801058ad:	72 11                	jb     801058c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801058af:	8b 55 0c             	mov    0xc(%ebp),%edx
801058b2:	89 02                	mov    %eax,(%edx)
  return 0;
801058b4:	31 c0                	xor    %eax,%eax
}
801058b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058b9:	5b                   	pop    %ebx
801058ba:	5e                   	pop    %esi
801058bb:	5d                   	pop    %ebp
801058bc:	c3                   	ret    
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c5:	eb ef                	jmp    801058b6 <argptr+0x46>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058dd:	50                   	push   %eax
801058de:	ff 75 08             	pushl  0x8(%ebp)
801058e1:	e8 3a ff ff ff       	call   80105820 <argint>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	78 13                	js     80105900 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801058ed:	83 ec 08             	sub    $0x8,%esp
801058f0:	ff 75 0c             	pushl  0xc(%ebp)
801058f3:	ff 75 f4             	pushl  -0xc(%ebp)
801058f6:	e8 c5 fe ff ff       	call   801057c0 <fetchstr>
801058fb:	83 c4 10             	add    $0x10,%esp
}
801058fe:	c9                   	leave  
801058ff:	c3                   	ret    
80105900:	c9                   	leave  
    return -1;
80105901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	53                   	push   %ebx
80105918:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010591b:	e8 50 eb ff ff       	call   80104470 <myproc>
80105920:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105922:	8b 40 18             	mov    0x18(%eax),%eax
80105925:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105928:	8d 50 ff             	lea    -0x1(%eax),%edx
8010592b:	83 fa 16             	cmp    $0x16,%edx
8010592e:	77 20                	ja     80105950 <syscall+0x40>
80105930:	8b 14 85 00 9a 10 80 	mov    -0x7fef6600(,%eax,4),%edx
80105937:	85 d2                	test   %edx,%edx
80105939:	74 15                	je     80105950 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010593b:	ff d2                	call   *%edx
8010593d:	89 c2                	mov    %eax,%edx
8010593f:	8b 43 18             	mov    0x18(%ebx),%eax
80105942:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105948:	c9                   	leave  
80105949:	c3                   	ret    
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105950:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105951:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105954:	50                   	push   %eax
80105955:	ff 73 10             	pushl  0x10(%ebx)
80105958:	68 d9 99 10 80       	push   $0x801099d9
8010595d:	e8 4e ad ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105962:	8b 43 18             	mov    0x18(%ebx),%eax
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010596f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105972:	c9                   	leave  
80105973:	c3                   	ret    
80105974:	66 90                	xchg   %ax,%ax
80105976:	66 90                	xchg   %ax,%ax
80105978:	66 90                	xchg   %ax,%ax
8010597a:	66 90                	xchg   %ax,%ax
8010597c:	66 90                	xchg   %ax,%ax
8010597e:	66 90                	xchg   %ax,%ax

80105980 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	56                   	push   %esi
80105984:	89 d6                	mov    %edx,%esi
80105986:	53                   	push   %ebx
80105987:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105989:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010598c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010598f:	50                   	push   %eax
80105990:	6a 00                	push   $0x0
80105992:	e8 89 fe ff ff       	call   80105820 <argint>
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	85 c0                	test   %eax,%eax
8010599c:	78 2a                	js     801059c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010599e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059a2:	77 24                	ja     801059c8 <argfd.constprop.0+0x48>
801059a4:	e8 c7 ea ff ff       	call   80104470 <myproc>
801059a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801059b0:	85 c0                	test   %eax,%eax
801059b2:	74 14                	je     801059c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801059b4:	85 db                	test   %ebx,%ebx
801059b6:	74 02                	je     801059ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801059b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801059ba:	89 06                	mov    %eax,(%esi)
  return 0;
801059bc:	31 c0                	xor    %eax,%eax
}
801059be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059c1:	5b                   	pop    %ebx
801059c2:	5e                   	pop    %esi
801059c3:	5d                   	pop    %ebp
801059c4:	c3                   	ret    
801059c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cd:	eb ef                	jmp    801059be <argfd.constprop.0+0x3e>
801059cf:	90                   	nop

801059d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801059d5:	31 c0                	xor    %eax,%eax
{
801059d7:	89 e5                	mov    %esp,%ebp
801059d9:	56                   	push   %esi
801059da:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801059db:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801059de:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801059e1:	e8 9a ff ff ff       	call   80105980 <argfd.constprop.0>
801059e6:	85 c0                	test   %eax,%eax
801059e8:	78 1e                	js     80105a08 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801059ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801059ed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059ef:	e8 7c ea ff ff       	call   80104470 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059f8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801059fc:	85 d2                	test   %edx,%edx
801059fe:	74 20                	je     80105a20 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105a00:	83 c3 01             	add    $0x1,%ebx
80105a03:	83 fb 10             	cmp    $0x10,%ebx
80105a06:	75 f0                	jne    801059f8 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105a0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105a10:	89 d8                	mov    %ebx,%eax
80105a12:	5b                   	pop    %ebx
80105a13:	5e                   	pop    %esi
80105a14:	5d                   	pop    %ebp
80105a15:	c3                   	ret    
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105a20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	ff 75 f4             	pushl  -0xc(%ebp)
80105a2a:	e8 11 b8 ff ff       	call   80101240 <filedup>
  return fd;
80105a2f:	83 c4 10             	add    $0x10,%esp
}
80105a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a35:	89 d8                	mov    %ebx,%eax
80105a37:	5b                   	pop    %ebx
80105a38:	5e                   	pop    %esi
80105a39:	5d                   	pop    %ebp
80105a3a:	c3                   	ret    
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop

80105a40 <sys_read>:

int
sys_read(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a45:	31 c0                	xor    %eax,%eax
{
80105a47:	89 e5                	mov    %esp,%ebp
80105a49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105a4f:	e8 2c ff ff ff       	call   80105980 <argfd.constprop.0>
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 48                	js     80105aa0 <sys_read+0x60>
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a5e:	50                   	push   %eax
80105a5f:	6a 02                	push   $0x2
80105a61:	e8 ba fd ff ff       	call   80105820 <argint>
80105a66:	83 c4 10             	add    $0x10,%esp
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	78 33                	js     80105aa0 <sys_read+0x60>
80105a6d:	83 ec 04             	sub    $0x4,%esp
80105a70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a73:	ff 75 f0             	pushl  -0x10(%ebp)
80105a76:	50                   	push   %eax
80105a77:	6a 01                	push   $0x1
80105a79:	e8 f2 fd ff ff       	call   80105870 <argptr>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 1b                	js     80105aa0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105a85:	83 ec 04             	sub    $0x4,%esp
80105a88:	ff 75 f0             	pushl  -0x10(%ebp)
80105a8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a8e:	ff 75 ec             	pushl  -0x14(%ebp)
80105a91:	e8 2a b9 ff ff       	call   801013c0 <fileread>
80105a96:	83 c4 10             	add    $0x10,%esp
}
80105a99:	c9                   	leave  
80105a9a:	c3                   	ret    
80105a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
80105aa0:	c9                   	leave  
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa6:	c3                   	ret    
80105aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_write>:

int
sys_write(void)
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ab5:	31 c0                	xor    %eax,%eax
{
80105ab7:	89 e5                	mov    %esp,%ebp
80105ab9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105abc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105abf:	e8 bc fe ff ff       	call   80105980 <argfd.constprop.0>
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 48                	js     80105b10 <sys_write+0x60>
80105ac8:	83 ec 08             	sub    $0x8,%esp
80105acb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ace:	50                   	push   %eax
80105acf:	6a 02                	push   $0x2
80105ad1:	e8 4a fd ff ff       	call   80105820 <argint>
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	78 33                	js     80105b10 <sys_write+0x60>
80105add:	83 ec 04             	sub    $0x4,%esp
80105ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ae6:	50                   	push   %eax
80105ae7:	6a 01                	push   $0x1
80105ae9:	e8 82 fd ff ff       	call   80105870 <argptr>
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	85 c0                	test   %eax,%eax
80105af3:	78 1b                	js     80105b10 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105af5:	83 ec 04             	sub    $0x4,%esp
80105af8:	ff 75 f0             	pushl  -0x10(%ebp)
80105afb:	ff 75 f4             	pushl  -0xc(%ebp)
80105afe:	ff 75 ec             	pushl  -0x14(%ebp)
80105b01:	e8 5a b9 ff ff       	call   80101460 <filewrite>
80105b06:	83 c4 10             	add    $0x10,%esp
}
80105b09:	c9                   	leave  
80105b0a:	c3                   	ret    
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
80105b10:	c9                   	leave  
    return -1;
80105b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b16:	c3                   	ret    
80105b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_close>:

int
sys_close(void)
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105b2a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105b2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b30:	e8 4b fe ff ff       	call   80105980 <argfd.constprop.0>
80105b35:	85 c0                	test   %eax,%eax
80105b37:	78 27                	js     80105b60 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105b39:	e8 32 e9 ff ff       	call   80104470 <myproc>
80105b3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105b41:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105b44:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105b4b:	00 
  fileclose(f);
80105b4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4f:	e8 3c b7 ff ff       	call   80101290 <fileclose>
  return 0;
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	31 c0                	xor    %eax,%eax
}
80105b59:	c9                   	leave  
80105b5a:	c3                   	ret    
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
80105b60:	c9                   	leave  
    return -1;
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b66:	c3                   	ret    
80105b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <sys_fstat>:

int
sys_fstat(void)
{
80105b70:	f3 0f 1e fb          	endbr32 
80105b74:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b75:	31 c0                	xor    %eax,%eax
{
80105b77:	89 e5                	mov    %esp,%ebp
80105b79:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b7c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105b7f:	e8 fc fd ff ff       	call   80105980 <argfd.constprop.0>
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 30                	js     80105bb8 <sys_fstat+0x48>
80105b88:	83 ec 04             	sub    $0x4,%esp
80105b8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b8e:	6a 14                	push   $0x14
80105b90:	50                   	push   %eax
80105b91:	6a 01                	push   $0x1
80105b93:	e8 d8 fc ff ff       	call   80105870 <argptr>
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	78 19                	js     80105bb8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80105b9f:	83 ec 08             	sub    $0x8,%esp
80105ba2:	ff 75 f4             	pushl  -0xc(%ebp)
80105ba5:	ff 75 f0             	pushl  -0x10(%ebp)
80105ba8:	e8 c3 b7 ff ff       	call   80101370 <filestat>
80105bad:	83 c4 10             	add    $0x10,%esp
}
80105bb0:	c9                   	leave  
80105bb1:	c3                   	ret    
80105bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bb8:	c9                   	leave  
    return -1;
80105bb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bbe:	c3                   	ret    
80105bbf:	90                   	nop

80105bc0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
80105bc5:	89 e5                	mov    %esp,%ebp
80105bc7:	57                   	push   %edi
80105bc8:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bc9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105bcc:	53                   	push   %ebx
80105bcd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bd0:	50                   	push   %eax
80105bd1:	6a 00                	push   $0x0
80105bd3:	e8 f8 fc ff ff       	call   801058d0 <argstr>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	85 c0                	test   %eax,%eax
80105bdd:	0f 88 ff 00 00 00    	js     80105ce2 <sys_link+0x122>
80105be3:	83 ec 08             	sub    $0x8,%esp
80105be6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105be9:	50                   	push   %eax
80105bea:	6a 01                	push   $0x1
80105bec:	e8 df fc ff ff       	call   801058d0 <argstr>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	0f 88 e6 00 00 00    	js     80105ce2 <sys_link+0x122>
    return -1;

  begin_op();
80105bfc:	e8 0f db ff ff       	call   80103710 <begin_op>
  if((ip = namei(old)) == 0){
80105c01:	83 ec 0c             	sub    $0xc,%esp
80105c04:	ff 75 d4             	pushl  -0x2c(%ebp)
80105c07:	e8 f4 c7 ff ff       	call   80102400 <namei>
80105c0c:	83 c4 10             	add    $0x10,%esp
80105c0f:	89 c3                	mov    %eax,%ebx
80105c11:	85 c0                	test   %eax,%eax
80105c13:	0f 84 e8 00 00 00    	je     80105d01 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105c19:	83 ec 0c             	sub    $0xc,%esp
80105c1c:	50                   	push   %eax
80105c1d:	e8 0e bf ff ff       	call   80101b30 <ilock>
  if(ip->type == T_DIR){
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c2a:	0f 84 b9 00 00 00    	je     80105ce9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105c30:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105c38:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105c3b:	53                   	push   %ebx
80105c3c:	e8 2f be ff ff       	call   80101a70 <iupdate>
  iunlock(ip);
80105c41:	89 1c 24             	mov    %ebx,(%esp)
80105c44:	e8 c7 bf ff ff       	call   80101c10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105c49:	58                   	pop    %eax
80105c4a:	5a                   	pop    %edx
80105c4b:	57                   	push   %edi
80105c4c:	ff 75 d0             	pushl  -0x30(%ebp)
80105c4f:	e8 cc c7 ff ff       	call   80102420 <nameiparent>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	89 c6                	mov    %eax,%esi
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	74 5f                	je     80105cbc <sys_link+0xfc>
    goto bad;
  ilock(dp);
80105c5d:	83 ec 0c             	sub    $0xc,%esp
80105c60:	50                   	push   %eax
80105c61:	e8 ca be ff ff       	call   80101b30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105c66:	8b 03                	mov    (%ebx),%eax
80105c68:	83 c4 10             	add    $0x10,%esp
80105c6b:	39 06                	cmp    %eax,(%esi)
80105c6d:	75 41                	jne    80105cb0 <sys_link+0xf0>
80105c6f:	83 ec 04             	sub    $0x4,%esp
80105c72:	ff 73 04             	pushl  0x4(%ebx)
80105c75:	57                   	push   %edi
80105c76:	56                   	push   %esi
80105c77:	e8 c4 c6 ff ff       	call   80102340 <dirlink>
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	78 2d                	js     80105cb0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105c83:	83 ec 0c             	sub    $0xc,%esp
80105c86:	56                   	push   %esi
80105c87:	e8 44 c1 ff ff       	call   80101dd0 <iunlockput>
  iput(ip);
80105c8c:	89 1c 24             	mov    %ebx,(%esp)
80105c8f:	e8 cc bf ff ff       	call   80101c60 <iput>

  end_op();
80105c94:	e8 e7 da ff ff       	call   80103780 <end_op>

  return 0;
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca1:	5b                   	pop    %ebx
80105ca2:	5e                   	pop    %esi
80105ca3:	5f                   	pop    %edi
80105ca4:	5d                   	pop    %ebp
80105ca5:	c3                   	ret    
80105ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	56                   	push   %esi
80105cb4:	e8 17 c1 ff ff       	call   80101dd0 <iunlockput>
    goto bad;
80105cb9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105cbc:	83 ec 0c             	sub    $0xc,%esp
80105cbf:	53                   	push   %ebx
80105cc0:	e8 6b be ff ff       	call   80101b30 <ilock>
  ip->nlink--;
80105cc5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cca:	89 1c 24             	mov    %ebx,(%esp)
80105ccd:	e8 9e bd ff ff       	call   80101a70 <iupdate>
  iunlockput(ip);
80105cd2:	89 1c 24             	mov    %ebx,(%esp)
80105cd5:	e8 f6 c0 ff ff       	call   80101dd0 <iunlockput>
  end_op();
80105cda:	e8 a1 da ff ff       	call   80103780 <end_op>
  return -1;
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce7:	eb b5                	jmp    80105c9e <sys_link+0xde>
    iunlockput(ip);
80105ce9:	83 ec 0c             	sub    $0xc,%esp
80105cec:	53                   	push   %ebx
80105ced:	e8 de c0 ff ff       	call   80101dd0 <iunlockput>
    end_op();
80105cf2:	e8 89 da ff ff       	call   80103780 <end_op>
    return -1;
80105cf7:	83 c4 10             	add    $0x10,%esp
80105cfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cff:	eb 9d                	jmp    80105c9e <sys_link+0xde>
    end_op();
80105d01:	e8 7a da ff ff       	call   80103780 <end_op>
    return -1;
80105d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0b:	eb 91                	jmp    80105c9e <sys_link+0xde>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi

80105d10 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
80105d19:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105d1c:	53                   	push   %ebx
80105d1d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105d22:	83 ec 1c             	sub    $0x1c,%esp
80105d25:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d28:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105d2c:	77 0a                	ja     80105d38 <isdirempty+0x28>
80105d2e:	eb 30                	jmp    80105d60 <isdirempty+0x50>
80105d30:	83 c3 10             	add    $0x10,%ebx
80105d33:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105d36:	76 28                	jbe    80105d60 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d38:	6a 10                	push   $0x10
80105d3a:	53                   	push   %ebx
80105d3b:	57                   	push   %edi
80105d3c:	56                   	push   %esi
80105d3d:	e8 ee c0 ff ff       	call   80101e30 <readi>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	83 f8 10             	cmp    $0x10,%eax
80105d48:	75 23                	jne    80105d6d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105d4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d4f:	74 df                	je     80105d30 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105d54:	31 c0                	xor    %eax,%eax
}
80105d56:	5b                   	pop    %ebx
80105d57:	5e                   	pop    %esi
80105d58:	5f                   	pop    %edi
80105d59:	5d                   	pop    %ebp
80105d5a:	c3                   	ret    
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
80105d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105d63:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d68:	5b                   	pop    %ebx
80105d69:	5e                   	pop    %esi
80105d6a:	5f                   	pop    %edi
80105d6b:	5d                   	pop    %ebp
80105d6c:	c3                   	ret    
      panic("isdirempty: readi");
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	68 60 9a 10 80       	push   $0x80109a60
80105d75:	e8 16 a6 ff ff       	call   80100390 <panic>
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d80 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	57                   	push   %edi
80105d88:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d89:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105d8c:	53                   	push   %ebx
80105d8d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105d90:	50                   	push   %eax
80105d91:	6a 00                	push   $0x0
80105d93:	e8 38 fb ff ff       	call   801058d0 <argstr>
80105d98:	83 c4 10             	add    $0x10,%esp
80105d9b:	85 c0                	test   %eax,%eax
80105d9d:	0f 88 5d 01 00 00    	js     80105f00 <sys_unlink+0x180>
    return -1;

  begin_op();
80105da3:	e8 68 d9 ff ff       	call   80103710 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105da8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105dab:	83 ec 08             	sub    $0x8,%esp
80105dae:	53                   	push   %ebx
80105daf:	ff 75 c0             	pushl  -0x40(%ebp)
80105db2:	e8 69 c6 ff ff       	call   80102420 <nameiparent>
80105db7:	83 c4 10             	add    $0x10,%esp
80105dba:	89 c6                	mov    %eax,%esi
80105dbc:	85 c0                	test   %eax,%eax
80105dbe:	0f 84 43 01 00 00    	je     80105f07 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105dc4:	83 ec 0c             	sub    $0xc,%esp
80105dc7:	50                   	push   %eax
80105dc8:	e8 63 bd ff ff       	call   80101b30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105dcd:	58                   	pop    %eax
80105dce:	5a                   	pop    %edx
80105dcf:	68 6b 93 10 80       	push   $0x8010936b
80105dd4:	53                   	push   %ebx
80105dd5:	e8 86 c2 ff ff       	call   80102060 <namecmp>
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	0f 84 db 00 00 00    	je     80105ec0 <sys_unlink+0x140>
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	68 6a 93 10 80       	push   $0x8010936a
80105ded:	53                   	push   %ebx
80105dee:	e8 6d c2 ff ff       	call   80102060 <namecmp>
80105df3:	83 c4 10             	add    $0x10,%esp
80105df6:	85 c0                	test   %eax,%eax
80105df8:	0f 84 c2 00 00 00    	je     80105ec0 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105dfe:	83 ec 04             	sub    $0x4,%esp
80105e01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105e04:	50                   	push   %eax
80105e05:	53                   	push   %ebx
80105e06:	56                   	push   %esi
80105e07:	e8 74 c2 ff ff       	call   80102080 <dirlookup>
80105e0c:	83 c4 10             	add    $0x10,%esp
80105e0f:	89 c3                	mov    %eax,%ebx
80105e11:	85 c0                	test   %eax,%eax
80105e13:	0f 84 a7 00 00 00    	je     80105ec0 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105e19:	83 ec 0c             	sub    $0xc,%esp
80105e1c:	50                   	push   %eax
80105e1d:	e8 0e bd ff ff       	call   80101b30 <ilock>

  if(ip->nlink < 1)
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105e2a:	0f 8e f3 00 00 00    	jle    80105f23 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e35:	74 69                	je     80105ea0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105e37:	83 ec 04             	sub    $0x4,%esp
80105e3a:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105e3d:	6a 10                	push   $0x10
80105e3f:	6a 00                	push   $0x0
80105e41:	57                   	push   %edi
80105e42:	e8 f9 f6 ff ff       	call   80105540 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e47:	6a 10                	push   $0x10
80105e49:	ff 75 c4             	pushl  -0x3c(%ebp)
80105e4c:	57                   	push   %edi
80105e4d:	56                   	push   %esi
80105e4e:	e8 dd c0 ff ff       	call   80101f30 <writei>
80105e53:	83 c4 20             	add    $0x20,%esp
80105e56:	83 f8 10             	cmp    $0x10,%eax
80105e59:	0f 85 b7 00 00 00    	jne    80105f16 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105e5f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e64:	74 7a                	je     80105ee0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105e66:	83 ec 0c             	sub    $0xc,%esp
80105e69:	56                   	push   %esi
80105e6a:	e8 61 bf ff ff       	call   80101dd0 <iunlockput>

  ip->nlink--;
80105e6f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e74:	89 1c 24             	mov    %ebx,(%esp)
80105e77:	e8 f4 bb ff ff       	call   80101a70 <iupdate>
  iunlockput(ip);
80105e7c:	89 1c 24             	mov    %ebx,(%esp)
80105e7f:	e8 4c bf ff ff       	call   80101dd0 <iunlockput>

  end_op();
80105e84:	e8 f7 d8 ff ff       	call   80103780 <end_op>

  return 0;
80105e89:	83 c4 10             	add    $0x10,%esp
80105e8c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e91:	5b                   	pop    %ebx
80105e92:	5e                   	pop    %esi
80105e93:	5f                   	pop    %edi
80105e94:	5d                   	pop    %ebp
80105e95:	c3                   	ret    
80105e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	53                   	push   %ebx
80105ea4:	e8 67 fe ff ff       	call   80105d10 <isdirempty>
80105ea9:	83 c4 10             	add    $0x10,%esp
80105eac:	85 c0                	test   %eax,%eax
80105eae:	75 87                	jne    80105e37 <sys_unlink+0xb7>
    iunlockput(ip);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	53                   	push   %ebx
80105eb4:	e8 17 bf ff ff       	call   80101dd0 <iunlockput>
    goto bad;
80105eb9:	83 c4 10             	add    $0x10,%esp
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	56                   	push   %esi
80105ec4:	e8 07 bf ff ff       	call   80101dd0 <iunlockput>
  end_op();
80105ec9:	e8 b2 d8 ff ff       	call   80103780 <end_op>
  return -1;
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed6:	eb b6                	jmp    80105e8e <sys_unlink+0x10e>
80105ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edf:	90                   	nop
    iupdate(dp);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105ee3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ee8:	56                   	push   %esi
80105ee9:	e8 82 bb ff ff       	call   80101a70 <iupdate>
80105eee:	83 c4 10             	add    $0x10,%esp
80105ef1:	e9 70 ff ff ff       	jmp    80105e66 <sys_unlink+0xe6>
80105ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f05:	eb 87                	jmp    80105e8e <sys_unlink+0x10e>
    end_op();
80105f07:	e8 74 d8 ff ff       	call   80103780 <end_op>
    return -1;
80105f0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f11:	e9 78 ff ff ff       	jmp    80105e8e <sys_unlink+0x10e>
    panic("unlink: writei");
80105f16:	83 ec 0c             	sub    $0xc,%esp
80105f19:	68 7f 93 10 80       	push   $0x8010937f
80105f1e:	e8 6d a4 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105f23:	83 ec 0c             	sub    $0xc,%esp
80105f26:	68 6d 93 10 80       	push   $0x8010936d
80105f2b:	e8 60 a4 ff ff       	call   80100390 <panic>

80105f30 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	57                   	push   %edi
80105f38:	56                   	push   %esi
80105f39:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105f3a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105f3d:	83 ec 34             	sub    $0x34,%esp
80105f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f43:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105f46:	53                   	push   %ebx
{
80105f47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105f4a:	ff 75 08             	pushl  0x8(%ebp)
{
80105f4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105f50:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105f53:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105f56:	e8 c5 c4 ff ff       	call   80102420 <nameiparent>
80105f5b:	83 c4 10             	add    $0x10,%esp
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	0f 84 3a 01 00 00    	je     801060a0 <create+0x170>
    return 0;
  ilock(dp);
80105f66:	83 ec 0c             	sub    $0xc,%esp
80105f69:	89 c6                	mov    %eax,%esi
80105f6b:	50                   	push   %eax
80105f6c:	e8 bf bb ff ff       	call   80101b30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105f71:	83 c4 0c             	add    $0xc,%esp
80105f74:	6a 00                	push   $0x0
80105f76:	53                   	push   %ebx
80105f77:	56                   	push   %esi
80105f78:	e8 03 c1 ff ff       	call   80102080 <dirlookup>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	89 c7                	mov    %eax,%edi
80105f82:	85 c0                	test   %eax,%eax
80105f84:	74 4a                	je     80105fd0 <create+0xa0>
    iunlockput(dp);
80105f86:	83 ec 0c             	sub    $0xc,%esp
80105f89:	56                   	push   %esi
80105f8a:	e8 41 be ff ff       	call   80101dd0 <iunlockput>
    ilock(ip);
80105f8f:	89 3c 24             	mov    %edi,(%esp)
80105f92:	e8 99 bb ff ff       	call   80101b30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f9f:	75 17                	jne    80105fb8 <create+0x88>
80105fa1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105fa6:	75 10                	jne    80105fb8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fab:	89 f8                	mov    %edi,%eax
80105fad:	5b                   	pop    %ebx
80105fae:	5e                   	pop    %esi
80105faf:	5f                   	pop    %edi
80105fb0:	5d                   	pop    %ebp
80105fb1:	c3                   	ret    
80105fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	57                   	push   %edi
    return 0;
80105fbc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105fbe:	e8 0d be ff ff       	call   80101dd0 <iunlockput>
    return 0;
80105fc3:	83 c4 10             	add    $0x10,%esp
}
80105fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc9:	89 f8                	mov    %edi,%eax
80105fcb:	5b                   	pop    %ebx
80105fcc:	5e                   	pop    %esi
80105fcd:	5f                   	pop    %edi
80105fce:	5d                   	pop    %ebp
80105fcf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105fd0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105fd4:	83 ec 08             	sub    $0x8,%esp
80105fd7:	50                   	push   %eax
80105fd8:	ff 36                	pushl  (%esi)
80105fda:	e8 d1 b9 ff ff       	call   801019b0 <ialloc>
80105fdf:	83 c4 10             	add    $0x10,%esp
80105fe2:	89 c7                	mov    %eax,%edi
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	0f 84 cd 00 00 00    	je     801060b9 <create+0x189>
  ilock(ip);
80105fec:	83 ec 0c             	sub    $0xc,%esp
80105fef:	50                   	push   %eax
80105ff0:	e8 3b bb ff ff       	call   80101b30 <ilock>
  ip->major = major;
80105ff5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105ff9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105ffd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106001:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80106005:	b8 01 00 00 00       	mov    $0x1,%eax
8010600a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010600e:	89 3c 24             	mov    %edi,(%esp)
80106011:	e8 5a ba ff ff       	call   80101a70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010601e:	74 30                	je     80106050 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106020:	83 ec 04             	sub    $0x4,%esp
80106023:	ff 77 04             	pushl  0x4(%edi)
80106026:	53                   	push   %ebx
80106027:	56                   	push   %esi
80106028:	e8 13 c3 ff ff       	call   80102340 <dirlink>
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	85 c0                	test   %eax,%eax
80106032:	78 78                	js     801060ac <create+0x17c>
  iunlockput(dp);
80106034:	83 ec 0c             	sub    $0xc,%esp
80106037:	56                   	push   %esi
80106038:	e8 93 bd ff ff       	call   80101dd0 <iunlockput>
  return ip;
8010603d:	83 c4 10             	add    $0x10,%esp
}
80106040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106043:	89 f8                	mov    %edi,%eax
80106045:	5b                   	pop    %ebx
80106046:	5e                   	pop    %esi
80106047:	5f                   	pop    %edi
80106048:	5d                   	pop    %ebp
80106049:	c3                   	ret    
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106050:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106053:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80106058:	56                   	push   %esi
80106059:	e8 12 ba ff ff       	call   80101a70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010605e:	83 c4 0c             	add    $0xc,%esp
80106061:	ff 77 04             	pushl  0x4(%edi)
80106064:	68 6b 93 10 80       	push   $0x8010936b
80106069:	57                   	push   %edi
8010606a:	e8 d1 c2 ff ff       	call   80102340 <dirlink>
8010606f:	83 c4 10             	add    $0x10,%esp
80106072:	85 c0                	test   %eax,%eax
80106074:	78 18                	js     8010608e <create+0x15e>
80106076:	83 ec 04             	sub    $0x4,%esp
80106079:	ff 76 04             	pushl  0x4(%esi)
8010607c:	68 6a 93 10 80       	push   $0x8010936a
80106081:	57                   	push   %edi
80106082:	e8 b9 c2 ff ff       	call   80102340 <dirlink>
80106087:	83 c4 10             	add    $0x10,%esp
8010608a:	85 c0                	test   %eax,%eax
8010608c:	79 92                	jns    80106020 <create+0xf0>
      panic("create dots");
8010608e:	83 ec 0c             	sub    $0xc,%esp
80106091:	68 81 9a 10 80       	push   $0x80109a81
80106096:	e8 f5 a2 ff ff       	call   80100390 <panic>
8010609b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010609f:	90                   	nop
}
801060a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801060a3:	31 ff                	xor    %edi,%edi
}
801060a5:	5b                   	pop    %ebx
801060a6:	89 f8                	mov    %edi,%eax
801060a8:	5e                   	pop    %esi
801060a9:	5f                   	pop    %edi
801060aa:	5d                   	pop    %ebp
801060ab:	c3                   	ret    
    panic("create: dirlink");
801060ac:	83 ec 0c             	sub    $0xc,%esp
801060af:	68 8d 9a 10 80       	push   $0x80109a8d
801060b4:	e8 d7 a2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801060b9:	83 ec 0c             	sub    $0xc,%esp
801060bc:	68 72 9a 10 80       	push   $0x80109a72
801060c1:	e8 ca a2 ff ff       	call   80100390 <panic>
801060c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060cd:	8d 76 00             	lea    0x0(%esi),%esi

801060d0 <sys_open>:

int
sys_open(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	57                   	push   %edi
801060d8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801060dc:	53                   	push   %ebx
801060dd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801060e0:	50                   	push   %eax
801060e1:	6a 00                	push   $0x0
801060e3:	e8 e8 f7 ff ff       	call   801058d0 <argstr>
801060e8:	83 c4 10             	add    $0x10,%esp
801060eb:	85 c0                	test   %eax,%eax
801060ed:	0f 88 8a 00 00 00    	js     8010617d <sys_open+0xad>
801060f3:	83 ec 08             	sub    $0x8,%esp
801060f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060f9:	50                   	push   %eax
801060fa:	6a 01                	push   $0x1
801060fc:	e8 1f f7 ff ff       	call   80105820 <argint>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	85 c0                	test   %eax,%eax
80106106:	78 75                	js     8010617d <sys_open+0xad>
    return -1;

  begin_op();
80106108:	e8 03 d6 ff ff       	call   80103710 <begin_op>

  if(omode & O_CREATE){
8010610d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106111:	75 75                	jne    80106188 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106113:	83 ec 0c             	sub    $0xc,%esp
80106116:	ff 75 e0             	pushl  -0x20(%ebp)
80106119:	e8 e2 c2 ff ff       	call   80102400 <namei>
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	89 c6                	mov    %eax,%esi
80106123:	85 c0                	test   %eax,%eax
80106125:	74 78                	je     8010619f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80106127:	83 ec 0c             	sub    $0xc,%esp
8010612a:	50                   	push   %eax
8010612b:	e8 00 ba ff ff       	call   80101b30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106130:	83 c4 10             	add    $0x10,%esp
80106133:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106138:	0f 84 ba 00 00 00    	je     801061f8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010613e:	e8 8d b0 ff ff       	call   801011d0 <filealloc>
80106143:	89 c7                	mov    %eax,%edi
80106145:	85 c0                	test   %eax,%eax
80106147:	74 23                	je     8010616c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106149:	e8 22 e3 ff ff       	call   80104470 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010614e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106150:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106154:	85 d2                	test   %edx,%edx
80106156:	74 58                	je     801061b0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80106158:	83 c3 01             	add    $0x1,%ebx
8010615b:	83 fb 10             	cmp    $0x10,%ebx
8010615e:	75 f0                	jne    80106150 <sys_open+0x80>
    if(f)
      fileclose(f);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	57                   	push   %edi
80106164:	e8 27 b1 ff ff       	call   80101290 <fileclose>
80106169:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010616c:	83 ec 0c             	sub    $0xc,%esp
8010616f:	56                   	push   %esi
80106170:	e8 5b bc ff ff       	call   80101dd0 <iunlockput>
    end_op();
80106175:	e8 06 d6 ff ff       	call   80103780 <end_op>
    return -1;
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106182:	eb 65                	jmp    801061e9 <sys_open+0x119>
80106184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106188:	6a 00                	push   $0x0
8010618a:	6a 00                	push   $0x0
8010618c:	6a 02                	push   $0x2
8010618e:	ff 75 e0             	pushl  -0x20(%ebp)
80106191:	e8 9a fd ff ff       	call   80105f30 <create>
    if(ip == 0){
80106196:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106199:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010619b:	85 c0                	test   %eax,%eax
8010619d:	75 9f                	jne    8010613e <sys_open+0x6e>
      end_op();
8010619f:	e8 dc d5 ff ff       	call   80103780 <end_op>
      return -1;
801061a4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a9:	eb 3e                	jmp    801061e9 <sys_open+0x119>
801061ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop
  }
  iunlock(ip);
801061b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801061b3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801061b7:	56                   	push   %esi
801061b8:	e8 53 ba ff ff       	call   80101c10 <iunlock>
  end_op();
801061bd:	e8 be d5 ff ff       	call   80103780 <end_op>

  f->type = FD_INODE;
801061c2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801061c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061cb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801061ce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801061d1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801061d3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801061da:	f7 d0                	not    %eax
801061dc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061df:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801061e2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061e5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801061e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061ec:	89 d8                	mov    %ebx,%eax
801061ee:	5b                   	pop    %ebx
801061ef:	5e                   	pop    %esi
801061f0:	5f                   	pop    %edi
801061f1:	5d                   	pop    %ebp
801061f2:	c3                   	ret    
801061f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061f7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801061f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801061fb:	85 c9                	test   %ecx,%ecx
801061fd:	0f 84 3b ff ff ff    	je     8010613e <sys_open+0x6e>
80106203:	e9 64 ff ff ff       	jmp    8010616c <sys_open+0x9c>
80106208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <sys_mkdir>:

int
sys_mkdir(void)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010621a:	e8 f1 d4 ff ff       	call   80103710 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010621f:	83 ec 08             	sub    $0x8,%esp
80106222:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106225:	50                   	push   %eax
80106226:	6a 00                	push   $0x0
80106228:	e8 a3 f6 ff ff       	call   801058d0 <argstr>
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	85 c0                	test   %eax,%eax
80106232:	78 2c                	js     80106260 <sys_mkdir+0x50>
80106234:	6a 00                	push   $0x0
80106236:	6a 00                	push   $0x0
80106238:	6a 01                	push   $0x1
8010623a:	ff 75 f4             	pushl  -0xc(%ebp)
8010623d:	e8 ee fc ff ff       	call   80105f30 <create>
80106242:	83 c4 10             	add    $0x10,%esp
80106245:	85 c0                	test   %eax,%eax
80106247:	74 17                	je     80106260 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106249:	83 ec 0c             	sub    $0xc,%esp
8010624c:	50                   	push   %eax
8010624d:	e8 7e bb ff ff       	call   80101dd0 <iunlockput>
  end_op();
80106252:	e8 29 d5 ff ff       	call   80103780 <end_op>
  return 0;
80106257:	83 c4 10             	add    $0x10,%esp
8010625a:	31 c0                	xor    %eax,%eax
}
8010625c:	c9                   	leave  
8010625d:	c3                   	ret    
8010625e:	66 90                	xchg   %ax,%ax
    end_op();
80106260:	e8 1b d5 ff ff       	call   80103780 <end_op>
    return -1;
80106265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010626a:	c9                   	leave  
8010626b:	c3                   	ret    
8010626c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106270 <sys_mknod>:

int
sys_mknod(void)
{
80106270:	f3 0f 1e fb          	endbr32 
80106274:	55                   	push   %ebp
80106275:	89 e5                	mov    %esp,%ebp
80106277:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010627a:	e8 91 d4 ff ff       	call   80103710 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010627f:	83 ec 08             	sub    $0x8,%esp
80106282:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106285:	50                   	push   %eax
80106286:	6a 00                	push   $0x0
80106288:	e8 43 f6 ff ff       	call   801058d0 <argstr>
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	85 c0                	test   %eax,%eax
80106292:	78 5c                	js     801062f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106294:	83 ec 08             	sub    $0x8,%esp
80106297:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010629a:	50                   	push   %eax
8010629b:	6a 01                	push   $0x1
8010629d:	e8 7e f5 ff ff       	call   80105820 <argint>
  if((argstr(0, &path)) < 0 ||
801062a2:	83 c4 10             	add    $0x10,%esp
801062a5:	85 c0                	test   %eax,%eax
801062a7:	78 47                	js     801062f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801062a9:	83 ec 08             	sub    $0x8,%esp
801062ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062af:	50                   	push   %eax
801062b0:	6a 02                	push   $0x2
801062b2:	e8 69 f5 ff ff       	call   80105820 <argint>
     argint(1, &major) < 0 ||
801062b7:	83 c4 10             	add    $0x10,%esp
801062ba:	85 c0                	test   %eax,%eax
801062bc:	78 32                	js     801062f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801062be:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801062c2:	50                   	push   %eax
801062c3:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
801062c7:	50                   	push   %eax
801062c8:	6a 03                	push   $0x3
801062ca:	ff 75 ec             	pushl  -0x14(%ebp)
801062cd:	e8 5e fc ff ff       	call   80105f30 <create>
     argint(2, &minor) < 0 ||
801062d2:	83 c4 10             	add    $0x10,%esp
801062d5:	85 c0                	test   %eax,%eax
801062d7:	74 17                	je     801062f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801062d9:	83 ec 0c             	sub    $0xc,%esp
801062dc:	50                   	push   %eax
801062dd:	e8 ee ba ff ff       	call   80101dd0 <iunlockput>
  end_op();
801062e2:	e8 99 d4 ff ff       	call   80103780 <end_op>
  return 0;
801062e7:	83 c4 10             	add    $0x10,%esp
801062ea:	31 c0                	xor    %eax,%eax
}
801062ec:	c9                   	leave  
801062ed:	c3                   	ret    
801062ee:	66 90                	xchg   %ax,%ax
    end_op();
801062f0:	e8 8b d4 ff ff       	call   80103780 <end_op>
    return -1;
801062f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062fa:	c9                   	leave  
801062fb:	c3                   	ret    
801062fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106300 <sys_chdir>:

int
sys_chdir(void)
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
80106305:	89 e5                	mov    %esp,%ebp
80106307:	56                   	push   %esi
80106308:	53                   	push   %ebx
80106309:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010630c:	e8 5f e1 ff ff       	call   80104470 <myproc>
80106311:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106313:	e8 f8 d3 ff ff       	call   80103710 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106318:	83 ec 08             	sub    $0x8,%esp
8010631b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010631e:	50                   	push   %eax
8010631f:	6a 00                	push   $0x0
80106321:	e8 aa f5 ff ff       	call   801058d0 <argstr>
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	85 c0                	test   %eax,%eax
8010632b:	78 73                	js     801063a0 <sys_chdir+0xa0>
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	ff 75 f4             	pushl  -0xc(%ebp)
80106333:	e8 c8 c0 ff ff       	call   80102400 <namei>
80106338:	83 c4 10             	add    $0x10,%esp
8010633b:	89 c3                	mov    %eax,%ebx
8010633d:	85 c0                	test   %eax,%eax
8010633f:	74 5f                	je     801063a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106341:	83 ec 0c             	sub    $0xc,%esp
80106344:	50                   	push   %eax
80106345:	e8 e6 b7 ff ff       	call   80101b30 <ilock>
  if(ip->type != T_DIR){
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106352:	75 2c                	jne    80106380 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	53                   	push   %ebx
80106358:	e8 b3 b8 ff ff       	call   80101c10 <iunlock>
  iput(curproc->cwd);
8010635d:	58                   	pop    %eax
8010635e:	ff 76 68             	pushl  0x68(%esi)
80106361:	e8 fa b8 ff ff       	call   80101c60 <iput>
  end_op();
80106366:	e8 15 d4 ff ff       	call   80103780 <end_op>
  curproc->cwd = ip;
8010636b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010636e:	83 c4 10             	add    $0x10,%esp
80106371:	31 c0                	xor    %eax,%eax
}
80106373:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106376:	5b                   	pop    %ebx
80106377:	5e                   	pop    %esi
80106378:	5d                   	pop    %ebp
80106379:	c3                   	ret    
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106380:	83 ec 0c             	sub    $0xc,%esp
80106383:	53                   	push   %ebx
80106384:	e8 47 ba ff ff       	call   80101dd0 <iunlockput>
    end_op();
80106389:	e8 f2 d3 ff ff       	call   80103780 <end_op>
    return -1;
8010638e:	83 c4 10             	add    $0x10,%esp
80106391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106396:	eb db                	jmp    80106373 <sys_chdir+0x73>
80106398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639f:	90                   	nop
    end_op();
801063a0:	e8 db d3 ff ff       	call   80103780 <end_op>
    return -1;
801063a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063aa:	eb c7                	jmp    80106373 <sys_chdir+0x73>
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063b0 <sys_exec>:

int
sys_exec(void)
{
801063b0:	f3 0f 1e fb          	endbr32 
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	57                   	push   %edi
801063b8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063b9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801063bf:	53                   	push   %ebx
801063c0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063c6:	50                   	push   %eax
801063c7:	6a 00                	push   $0x0
801063c9:	e8 02 f5 ff ff       	call   801058d0 <argstr>
801063ce:	83 c4 10             	add    $0x10,%esp
801063d1:	85 c0                	test   %eax,%eax
801063d3:	0f 88 8b 00 00 00    	js     80106464 <sys_exec+0xb4>
801063d9:	83 ec 08             	sub    $0x8,%esp
801063dc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801063e2:	50                   	push   %eax
801063e3:	6a 01                	push   $0x1
801063e5:	e8 36 f4 ff ff       	call   80105820 <argint>
801063ea:	83 c4 10             	add    $0x10,%esp
801063ed:	85 c0                	test   %eax,%eax
801063ef:	78 73                	js     80106464 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801063f1:	83 ec 04             	sub    $0x4,%esp
801063f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801063fa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801063fc:	68 80 00 00 00       	push   $0x80
80106401:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106407:	6a 00                	push   $0x0
80106409:	50                   	push   %eax
8010640a:	e8 31 f1 ff ff       	call   80105540 <memset>
8010640f:	83 c4 10             	add    $0x10,%esp
80106412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106418:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010641e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106425:	83 ec 08             	sub    $0x8,%esp
80106428:	57                   	push   %edi
80106429:	01 f0                	add    %esi,%eax
8010642b:	50                   	push   %eax
8010642c:	e8 4f f3 ff ff       	call   80105780 <fetchint>
80106431:	83 c4 10             	add    $0x10,%esp
80106434:	85 c0                	test   %eax,%eax
80106436:	78 2c                	js     80106464 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106438:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010643e:	85 c0                	test   %eax,%eax
80106440:	74 36                	je     80106478 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106442:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106448:	83 ec 08             	sub    $0x8,%esp
8010644b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010644e:	52                   	push   %edx
8010644f:	50                   	push   %eax
80106450:	e8 6b f3 ff ff       	call   801057c0 <fetchstr>
80106455:	83 c4 10             	add    $0x10,%esp
80106458:	85 c0                	test   %eax,%eax
8010645a:	78 08                	js     80106464 <sys_exec+0xb4>
  for(i=0;; i++){
8010645c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010645f:	83 fb 20             	cmp    $0x20,%ebx
80106462:	75 b4                	jne    80106418 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106464:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010646c:	5b                   	pop    %ebx
8010646d:	5e                   	pop    %esi
8010646e:	5f                   	pop    %edi
8010646f:	5d                   	pop    %ebp
80106470:	c3                   	ret    
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106478:	83 ec 08             	sub    $0x8,%esp
8010647b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106481:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106488:	00 00 00 00 
  return exec(path, argv);
8010648c:	50                   	push   %eax
8010648d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106493:	e8 58 a8 ff ff       	call   80100cf0 <exec>
80106498:	83 c4 10             	add    $0x10,%esp
}
8010649b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010649e:	5b                   	pop    %ebx
8010649f:	5e                   	pop    %esi
801064a0:	5f                   	pop    %edi
801064a1:	5d                   	pop    %ebp
801064a2:	c3                   	ret    
801064a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064b0 <sys_pipe>:

int
sys_pipe(void)
{
801064b0:	f3 0f 1e fb          	endbr32 
801064b4:	55                   	push   %ebp
801064b5:	89 e5                	mov    %esp,%ebp
801064b7:	57                   	push   %edi
801064b8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064b9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801064bc:	53                   	push   %ebx
801064bd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064c0:	6a 08                	push   $0x8
801064c2:	50                   	push   %eax
801064c3:	6a 00                	push   $0x0
801064c5:	e8 a6 f3 ff ff       	call   80105870 <argptr>
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	85 c0                	test   %eax,%eax
801064cf:	78 4e                	js     8010651f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801064d1:	83 ec 08             	sub    $0x8,%esp
801064d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064d7:	50                   	push   %eax
801064d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801064db:	50                   	push   %eax
801064dc:	e8 ef d8 ff ff       	call   80103dd0 <pipealloc>
801064e1:	83 c4 10             	add    $0x10,%esp
801064e4:	85 c0                	test   %eax,%eax
801064e6:	78 37                	js     8010651f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801064eb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801064ed:	e8 7e df ff ff       	call   80104470 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801064f8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801064fc:	85 f6                	test   %esi,%esi
801064fe:	74 30                	je     80106530 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106500:	83 c3 01             	add    $0x1,%ebx
80106503:	83 fb 10             	cmp    $0x10,%ebx
80106506:	75 f0                	jne    801064f8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	ff 75 e0             	pushl  -0x20(%ebp)
8010650e:	e8 7d ad ff ff       	call   80101290 <fileclose>
    fileclose(wf);
80106513:	58                   	pop    %eax
80106514:	ff 75 e4             	pushl  -0x1c(%ebp)
80106517:	e8 74 ad ff ff       	call   80101290 <fileclose>
    return -1;
8010651c:	83 c4 10             	add    $0x10,%esp
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106524:	eb 5b                	jmp    80106581 <sys_pipe+0xd1>
80106526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010652d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106530:	8d 73 08             	lea    0x8(%ebx),%esi
80106533:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010653a:	e8 31 df ff ff       	call   80104470 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010653f:	31 d2                	xor    %edx,%edx
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106548:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010654c:	85 c9                	test   %ecx,%ecx
8010654e:	74 20                	je     80106570 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106550:	83 c2 01             	add    $0x1,%edx
80106553:	83 fa 10             	cmp    $0x10,%edx
80106556:	75 f0                	jne    80106548 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106558:	e8 13 df ff ff       	call   80104470 <myproc>
8010655d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106564:	00 
80106565:	eb a1                	jmp    80106508 <sys_pipe+0x58>
80106567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106570:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106574:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106577:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106579:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010657c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010657f:	31 c0                	xor    %eax,%eax
}
80106581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106584:	5b                   	pop    %ebx
80106585:	5e                   	pop    %esi
80106586:	5f                   	pop    %edi
80106587:	5d                   	pop    %ebp
80106588:	c3                   	ret    
80106589:	66 90                	xchg   %ax,%ax
8010658b:	66 90                	xchg   %ax,%ax
8010658d:	66 90                	xchg   %ax,%ax
8010658f:	90                   	nop

80106590 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106590:	f3 0f 1e fb          	endbr32 
  return fork();
80106594:	e9 a7 e0 ff ff       	jmp    80104640 <fork>
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_exit>:
}

int
sys_exit(void)
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	83 ec 08             	sub    $0x8,%esp
  exit();
801065aa:	e8 01 e5 ff ff       	call   80104ab0 <exit>
  return 0;  // not reached
}
801065af:	31 c0                	xor    %eax,%eax
801065b1:	c9                   	leave  
801065b2:	c3                   	ret    
801065b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065c0 <sys_wait>:

int
sys_wait(void)
{
801065c0:	f3 0f 1e fb          	endbr32 
  return wait();
801065c4:	e9 67 e7 ff ff       	jmp    80104d30 <wait>
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <sys_kill>:
}

int
sys_kill(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801065da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065dd:	50                   	push   %eax
801065de:	6a 00                	push   $0x0
801065e0:	e8 3b f2 ff ff       	call   80105820 <argint>
801065e5:	83 c4 10             	add    $0x10,%esp
801065e8:	85 c0                	test   %eax,%eax
801065ea:	78 14                	js     80106600 <sys_kill+0x30>
    return -1;
  return kill(pid);
801065ec:	83 ec 0c             	sub    $0xc,%esp
801065ef:	ff 75 f4             	pushl  -0xc(%ebp)
801065f2:	e8 29 e9 ff ff       	call   80104f20 <kill>
801065f7:	83 c4 10             	add    $0x10,%esp
}
801065fa:	c9                   	leave  
801065fb:	c3                   	ret    
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106600:	c9                   	leave  
    return -1;
80106601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106606:	c3                   	ret    
80106607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010660e:	66 90                	xchg   %ax,%ax

80106610 <sys_getpid>:

int
sys_getpid(void)
{
80106610:	f3 0f 1e fb          	endbr32 
80106614:	55                   	push   %ebp
80106615:	89 e5                	mov    %esp,%ebp
80106617:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010661a:	e8 51 de ff ff       	call   80104470 <myproc>
8010661f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106622:	c9                   	leave  
80106623:	c3                   	ret    
80106624:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop

80106630 <sys_sbrk>:

int
sys_sbrk(void)
{
80106630:	f3 0f 1e fb          	endbr32 
80106634:	55                   	push   %ebp
80106635:	89 e5                	mov    %esp,%ebp
80106637:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106638:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010663b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010663e:	50                   	push   %eax
8010663f:	6a 00                	push   $0x0
80106641:	e8 da f1 ff ff       	call   80105820 <argint>
80106646:	83 c4 10             	add    $0x10,%esp
80106649:	85 c0                	test   %eax,%eax
8010664b:	78 23                	js     80106670 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010664d:	e8 1e de ff ff       	call   80104470 <myproc>
  if(growproc(n) < 0)
80106652:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106655:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106657:	ff 75 f4             	pushl  -0xc(%ebp)
8010665a:	e8 41 df ff ff       	call   801045a0 <growproc>
8010665f:	83 c4 10             	add    $0x10,%esp
80106662:	85 c0                	test   %eax,%eax
80106664:	78 0a                	js     80106670 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106666:	89 d8                	mov    %ebx,%eax
80106668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010666b:	c9                   	leave  
8010666c:	c3                   	ret    
8010666d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106670:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106675:	eb ef                	jmp    80106666 <sys_sbrk+0x36>
80106677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667e:	66 90                	xchg   %ax,%ax

80106680 <sys_sleep>:

int
sys_sleep(void)
{
80106680:	f3 0f 1e fb          	endbr32 
80106684:	55                   	push   %ebp
80106685:	89 e5                	mov    %esp,%ebp
80106687:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106688:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010668b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010668e:	50                   	push   %eax
8010668f:	6a 00                	push   $0x0
80106691:	e8 8a f1 ff ff       	call   80105820 <argint>
80106696:	83 c4 10             	add    $0x10,%esp
80106699:	85 c0                	test   %eax,%eax
8010669b:	0f 88 86 00 00 00    	js     80106727 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801066a1:	83 ec 0c             	sub    $0xc,%esp
801066a4:	68 40 7d 19 80       	push   $0x80197d40
801066a9:	e8 82 ed ff ff       	call   80105430 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801066ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801066b1:	8b 1d 80 85 19 80    	mov    0x80198580,%ebx
  while(ticks - ticks0 < n){
801066b7:	83 c4 10             	add    $0x10,%esp
801066ba:	85 d2                	test   %edx,%edx
801066bc:	75 23                	jne    801066e1 <sys_sleep+0x61>
801066be:	eb 50                	jmp    80106710 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801066c0:	83 ec 08             	sub    $0x8,%esp
801066c3:	68 40 7d 19 80       	push   $0x80197d40
801066c8:	68 80 85 19 80       	push   $0x80198580
801066cd:	e8 9e e5 ff ff       	call   80104c70 <sleep>
  while(ticks - ticks0 < n){
801066d2:	a1 80 85 19 80       	mov    0x80198580,%eax
801066d7:	83 c4 10             	add    $0x10,%esp
801066da:	29 d8                	sub    %ebx,%eax
801066dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801066df:	73 2f                	jae    80106710 <sys_sleep+0x90>
    if(myproc()->killed){
801066e1:	e8 8a dd ff ff       	call   80104470 <myproc>
801066e6:	8b 40 24             	mov    0x24(%eax),%eax
801066e9:	85 c0                	test   %eax,%eax
801066eb:	74 d3                	je     801066c0 <sys_sleep+0x40>
      release(&tickslock);
801066ed:	83 ec 0c             	sub    $0xc,%esp
801066f0:	68 40 7d 19 80       	push   $0x80197d40
801066f5:	e8 f6 ed ff ff       	call   801054f0 <release>
  }
  release(&tickslock);
  return 0;
}
801066fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801066fd:	83 c4 10             	add    $0x10,%esp
80106700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106705:	c9                   	leave  
80106706:	c3                   	ret    
80106707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106710:	83 ec 0c             	sub    $0xc,%esp
80106713:	68 40 7d 19 80       	push   $0x80197d40
80106718:	e8 d3 ed ff ff       	call   801054f0 <release>
  return 0;
8010671d:	83 c4 10             	add    $0x10,%esp
80106720:	31 c0                	xor    %eax,%eax
}
80106722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106725:	c9                   	leave  
80106726:	c3                   	ret    
    return -1;
80106727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672c:	eb f4                	jmp    80106722 <sys_sleep+0xa2>
8010672e:	66 90                	xchg   %ax,%ax

80106730 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106730:	f3 0f 1e fb          	endbr32 
80106734:	55                   	push   %ebp
80106735:	89 e5                	mov    %esp,%ebp
80106737:	53                   	push   %ebx
80106738:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010673b:	68 40 7d 19 80       	push   $0x80197d40
80106740:	e8 eb ec ff ff       	call   80105430 <acquire>
  xticks = ticks;
80106745:	8b 1d 80 85 19 80    	mov    0x80198580,%ebx
  release(&tickslock);
8010674b:	c7 04 24 40 7d 19 80 	movl   $0x80197d40,(%esp)
80106752:	e8 99 ed ff ff       	call   801054f0 <release>
  return xticks;
}
80106757:	89 d8                	mov    %ebx,%eax
80106759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010675c:	c9                   	leave  
8010675d:	c3                   	ret    
8010675e:	66 90                	xchg   %ax,%ax

80106760 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106760:	f3 0f 1e fb          	endbr32 
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
8010676a:	e8 01 dd ff ff       	call   80104470 <myproc>
8010676f:	89 c2                	mov    %eax,%edx
80106771:	b8 10 00 00 00       	mov    $0x10,%eax
80106776:	2b 82 80 00 00 00    	sub    0x80(%edx),%eax
}
8010677c:	c9                   	leave  
8010677d:	c3                   	ret    
8010677e:	66 90                	xchg   %ax,%ax

80106780 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106780:	f3 0f 1e fb          	endbr32 
  return getTotalFreePages();
80106784:	e9 87 e8 ff ff       	jmp    80105010 <getTotalFreePages>

80106789 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106789:	1e                   	push   %ds
  pushl %es
8010678a:	06                   	push   %es
  pushl %fs
8010678b:	0f a0                	push   %fs
  pushl %gs
8010678d:	0f a8                	push   %gs
  pushal
8010678f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106790:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106794:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106796:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106798:	54                   	push   %esp
  call trap
80106799:	e8 c2 00 00 00       	call   80106860 <trap>
  addl $4, %esp
8010679e:	83 c4 04             	add    $0x4,%esp

801067a1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067a1:	61                   	popa   
  popl %gs
801067a2:	0f a9                	pop    %gs
  popl %fs
801067a4:	0f a1                	pop    %fs
  popl %es
801067a6:	07                   	pop    %es
  popl %ds
801067a7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067a8:	83 c4 08             	add    $0x8,%esp
  iret
801067ab:	cf                   	iret   
801067ac:	66 90                	xchg   %ax,%ax
801067ae:	66 90                	xchg   %ax,%ax

801067b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801067b0:	f3 0f 1e fb          	endbr32 
801067b4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801067b5:	31 c0                	xor    %eax,%eax
{
801067b7:	89 e5                	mov    %esp,%ebp
801067b9:	83 ec 08             	sub    $0x8,%esp
801067bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801067c0:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
801067c7:	c7 04 c5 82 7d 19 80 	movl   $0x8e000008,-0x7fe6827e(,%eax,8)
801067ce:	08 00 00 8e 
801067d2:	66 89 14 c5 80 7d 19 	mov    %dx,-0x7fe68280(,%eax,8)
801067d9:	80 
801067da:	c1 ea 10             	shr    $0x10,%edx
801067dd:	66 89 14 c5 86 7d 19 	mov    %dx,-0x7fe6827a(,%eax,8)
801067e4:	80 
  for(i = 0; i < 256; i++)
801067e5:	83 c0 01             	add    $0x1,%eax
801067e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801067ed:	75 d1                	jne    801067c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801067ef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801067f2:	a1 08 d1 10 80       	mov    0x8010d108,%eax
801067f7:	c7 05 82 7f 19 80 08 	movl   $0xef000008,0x80197f82
801067fe:	00 00 ef 
  initlock(&tickslock, "time");
80106801:	68 9d 9a 10 80       	push   $0x80109a9d
80106806:	68 40 7d 19 80       	push   $0x80197d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010680b:	66 a3 80 7f 19 80    	mov    %ax,0x80197f80
80106811:	c1 e8 10             	shr    $0x10,%eax
80106814:	66 a3 86 7f 19 80    	mov    %ax,0x80197f86
  initlock(&tickslock, "time");
8010681a:	e8 91 ea ff ff       	call   801052b0 <initlock>
}
8010681f:	83 c4 10             	add    $0x10,%esp
80106822:	c9                   	leave  
80106823:	c3                   	ret    
80106824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010682f:	90                   	nop

80106830 <idtinit>:

void
idtinit(void)
{
80106830:	f3 0f 1e fb          	endbr32 
80106834:	55                   	push   %ebp
  pd[0] = size-1;
80106835:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010683a:	89 e5                	mov    %esp,%ebp
8010683c:	83 ec 10             	sub    $0x10,%esp
8010683f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106843:	b8 80 7d 19 80       	mov    $0x80197d80,%eax
80106848:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010684c:	c1 e8 10             	shr    $0x10,%eax
8010684f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106853:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106856:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106859:	c9                   	leave  
8010685a:	c3                   	ret    
8010685b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010685f:	90                   	nop

80106860 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106860:	f3 0f 1e fb          	endbr32 
80106864:	55                   	push   %ebp
80106865:	89 e5                	mov    %esp,%ebp
80106867:	57                   	push   %edi
80106868:	56                   	push   %esi
80106869:	53                   	push   %ebx
8010686a:	83 ec 1c             	sub    $0x1c,%esp
8010686d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("at trap");
  struct proc* curproc = myproc();
80106870:	e8 fb db ff ff       	call   80104470 <myproc>
80106875:	89 c6                	mov    %eax,%esi
  if(tf->trapno == T_SYSCALL){
80106877:	8b 43 30             	mov    0x30(%ebx),%eax
8010687a:	83 f8 40             	cmp    $0x40,%eax
8010687d:	0f 84 ed 00 00 00    	je     80106970 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106883:	83 e8 0e             	sub    $0xe,%eax
80106886:	83 f8 31             	cmp    $0x31,%eax
80106889:	77 08                	ja     80106893 <trap+0x33>
8010688b:	3e ff 24 85 44 9b 10 	notrack jmp *-0x7fef64bc(,%eax,4)
80106892:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106893:	e8 d8 db ff ff       	call   80104470 <myproc>
80106898:	85 c0                	test   %eax,%eax
8010689a:	0f 84 fa 01 00 00    	je     80106a9a <trap+0x23a>
801068a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801068a4:	0f 84 f0 01 00 00    	je     80106a9a <trap+0x23a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801068aa:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068ad:	8b 53 38             	mov    0x38(%ebx),%edx
801068b0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801068b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801068b6:	e8 95 db ff ff       	call   80104450 <cpuid>
801068bb:	8b 73 30             	mov    0x30(%ebx),%esi
801068be:	89 c7                	mov    %eax,%edi
801068c0:	8b 43 34             	mov    0x34(%ebx),%eax
801068c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801068c6:	e8 a5 db ff ff       	call   80104470 <myproc>
801068cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068ce:	e8 9d db ff ff       	call   80104470 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068d3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801068d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
801068d9:	51                   	push   %ecx
801068da:	52                   	push   %edx
801068db:	57                   	push   %edi
801068dc:	ff 75 e4             	pushl  -0x1c(%ebp)
801068df:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801068e0:	8b 75 e0             	mov    -0x20(%ebp),%esi
801068e3:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801068e6:	56                   	push   %esi
801068e7:	ff 70 10             	pushl  0x10(%eax)
801068ea:	68 00 9b 10 80       	push   $0x80109b00
801068ef:	e8 bc 9d ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801068f4:	83 c4 20             	add    $0x20,%esp
801068f7:	e8 74 db ff ff       	call   80104470 <myproc>
801068fc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106903:	e8 68 db ff ff       	call   80104470 <myproc>
80106908:	85 c0                	test   %eax,%eax
8010690a:	74 1d                	je     80106929 <trap+0xc9>
8010690c:	e8 5f db ff ff       	call   80104470 <myproc>
80106911:	8b 50 24             	mov    0x24(%eax),%edx
80106914:	85 d2                	test   %edx,%edx
80106916:	74 11                	je     80106929 <trap+0xc9>
80106918:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010691c:	83 e0 03             	and    $0x3,%eax
8010691f:	66 83 f8 03          	cmp    $0x3,%ax
80106923:	0f 84 67 01 00 00    	je     80106a90 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106929:	e8 42 db ff ff       	call   80104470 <myproc>
8010692e:	85 c0                	test   %eax,%eax
80106930:	74 0f                	je     80106941 <trap+0xe1>
80106932:	e8 39 db ff ff       	call   80104470 <myproc>
80106937:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010693b:	0f 84 1f 01 00 00    	je     80106a60 <trap+0x200>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106941:	e8 2a db ff ff       	call   80104470 <myproc>
80106946:	85 c0                	test   %eax,%eax
80106948:	74 19                	je     80106963 <trap+0x103>
8010694a:	e8 21 db ff ff       	call   80104470 <myproc>
8010694f:	8b 40 24             	mov    0x24(%eax),%eax
80106952:	85 c0                	test   %eax,%eax
80106954:	74 0d                	je     80106963 <trap+0x103>
80106956:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010695a:	83 e0 03             	and    $0x3,%eax
8010695d:	66 83 f8 03          	cmp    $0x3,%ax
80106961:	74 2c                	je     8010698f <trap+0x12f>
    exit();
80106963:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106966:	5b                   	pop    %ebx
80106967:	5e                   	pop    %esi
80106968:	5f                   	pop    %edi
80106969:	5d                   	pop    %ebp
8010696a:	c3                   	ret    
8010696b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010696f:	90                   	nop
    if(curproc->killed)
80106970:	8b 7e 24             	mov    0x24(%esi),%edi
80106973:	85 ff                	test   %edi,%edi
80106975:	0f 85 05 01 00 00    	jne    80106a80 <trap+0x220>
    curproc->tf = tf;
8010697b:	89 5e 18             	mov    %ebx,0x18(%esi)
    syscall();
8010697e:	e8 8d ef ff ff       	call   80105910 <syscall>
    if(myproc()->killed)
80106983:	e8 e8 da ff ff       	call   80104470 <myproc>
80106988:	8b 58 24             	mov    0x24(%eax),%ebx
8010698b:	85 db                	test   %ebx,%ebx
8010698d:	74 d4                	je     80106963 <trap+0x103>
8010698f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106992:	5b                   	pop    %ebx
80106993:	5e                   	pop    %esi
80106994:	5f                   	pop    %edi
80106995:	5d                   	pop    %ebp
      exit();
80106996:	e9 15 e1 ff ff       	jmp    80104ab0 <exit>
    ideintr();
8010699b:	e8 90 bf ff ff       	call   80102930 <ideintr>
    lapiceoi();
801069a0:	e8 fb c8 ff ff       	call   801032a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801069a5:	e8 c6 da ff ff       	call   80104470 <myproc>
801069aa:	85 c0                	test   %eax,%eax
801069ac:	0f 85 5a ff ff ff    	jne    8010690c <trap+0xac>
801069b2:	e9 72 ff ff ff       	jmp    80106929 <trap+0xc9>
    if(myproc()->pid > 2) 
801069b7:	e8 b4 da ff ff       	call   80104470 <myproc>
801069bc:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801069c0:	0f 8e 3d ff ff ff    	jle    80106903 <trap+0xa3>
    pagefault();
801069c6:	e8 25 1f 00 00       	call   801088f0 <pagefault>
      if(curproc->killed) {
801069cb:	8b 4e 24             	mov    0x24(%esi),%ecx
801069ce:	85 c9                	test   %ecx,%ecx
801069d0:	0f 84 2d ff ff ff    	je     80106903 <trap+0xa3>
        exit();
801069d6:	e8 d5 e0 ff ff       	call   80104ab0 <exit>
801069db:	e9 23 ff ff ff       	jmp    80106903 <trap+0xa3>
    if(cpuid() == 0){
801069e0:	e8 6b da ff ff       	call   80104450 <cpuid>
801069e5:	85 c0                	test   %eax,%eax
801069e7:	75 b7                	jne    801069a0 <trap+0x140>
      acquire(&tickslock);
801069e9:	83 ec 0c             	sub    $0xc,%esp
801069ec:	68 40 7d 19 80       	push   $0x80197d40
801069f1:	e8 3a ea ff ff       	call   80105430 <acquire>
      wakeup(&ticks);
801069f6:	c7 04 24 80 85 19 80 	movl   $0x80198580,(%esp)
      ticks++;
801069fd:	83 05 80 85 19 80 01 	addl   $0x1,0x80198580
      wakeup(&ticks);
80106a04:	e8 a7 e4 ff ff       	call   80104eb0 <wakeup>
      release(&tickslock);
80106a09:	c7 04 24 40 7d 19 80 	movl   $0x80197d40,(%esp)
80106a10:	e8 db ea ff ff       	call   801054f0 <release>
80106a15:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106a18:	eb 86                	jmp    801069a0 <trap+0x140>
    kbdintr();
80106a1a:	e8 41 c7 ff ff       	call   80103160 <kbdintr>
    lapiceoi();
80106a1f:	e8 7c c8 ff ff       	call   801032a0 <lapiceoi>
    break;
80106a24:	e9 da fe ff ff       	jmp    80106903 <trap+0xa3>
    uartintr();
80106a29:	e8 12 02 00 00       	call   80106c40 <uartintr>
    lapiceoi();
80106a2e:	e8 6d c8 ff ff       	call   801032a0 <lapiceoi>
    break;
80106a33:	e9 cb fe ff ff       	jmp    80106903 <trap+0xa3>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106a38:	8b 7b 38             	mov    0x38(%ebx),%edi
80106a3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106a3f:	e8 0c da ff ff       	call   80104450 <cpuid>
80106a44:	57                   	push   %edi
80106a45:	56                   	push   %esi
80106a46:	50                   	push   %eax
80106a47:	68 a8 9a 10 80       	push   $0x80109aa8
80106a4c:	e8 5f 9c ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106a51:	e8 4a c8 ff ff       	call   801032a0 <lapiceoi>
    break;
80106a56:	83 c4 10             	add    $0x10,%esp
80106a59:	e9 a5 fe ff ff       	jmp    80106903 <trap+0xa3>
80106a5e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80106a60:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106a64:	0f 85 d7 fe ff ff    	jne    80106941 <trap+0xe1>
      if(myproc()->pid > 2) 
80106a6a:	e8 01 da ff ff       	call   80104470 <myproc>
      yield();
80106a6f:	e8 ac e1 ff ff       	call   80104c20 <yield>
80106a74:	e9 c8 fe ff ff       	jmp    80106941 <trap+0xe1>
80106a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      exit();
80106a80:	e8 2b e0 ff ff       	call   80104ab0 <exit>
80106a85:	e9 f1 fe ff ff       	jmp    8010697b <trap+0x11b>
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106a90:	e8 1b e0 ff ff       	call   80104ab0 <exit>
80106a95:	e9 8f fe ff ff       	jmp    80106929 <trap+0xc9>
80106a9a:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a9d:	8b 73 38             	mov    0x38(%ebx),%esi
80106aa0:	e8 ab d9 ff ff       	call   80104450 <cpuid>
80106aa5:	83 ec 0c             	sub    $0xc,%esp
80106aa8:	57                   	push   %edi
80106aa9:	56                   	push   %esi
80106aaa:	50                   	push   %eax
80106aab:	ff 73 30             	pushl  0x30(%ebx)
80106aae:	68 cc 9a 10 80       	push   $0x80109acc
80106ab3:	e8 f8 9b ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106ab8:	83 c4 14             	add    $0x14,%esp
80106abb:	68 a2 9a 10 80       	push   $0x80109aa2
80106ac0:	e8 cb 98 ff ff       	call   80100390 <panic>
80106ac5:	66 90                	xchg   %ax,%ax
80106ac7:	66 90                	xchg   %ax,%ax
80106ac9:	66 90                	xchg   %ax,%ax
80106acb:	66 90                	xchg   %ax,%ax
80106acd:	66 90                	xchg   %ax,%ax
80106acf:	90                   	nop

80106ad0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106ad0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106ad4:	a1 dc d5 10 80       	mov    0x8010d5dc,%eax
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	74 1b                	je     80106af8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106add:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ae2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106ae3:	a8 01                	test   $0x1,%al
80106ae5:	74 11                	je     80106af8 <uartgetc+0x28>
80106ae7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aec:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106aed:	0f b6 c0             	movzbl %al,%eax
80106af0:	c3                   	ret    
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106afd:	c3                   	ret    
80106afe:	66 90                	xchg   %ax,%ax

80106b00 <uartputc.part.0>:
uartputc(int c)
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	89 c7                	mov    %eax,%edi
80106b06:	56                   	push   %esi
80106b07:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b0c:	53                   	push   %ebx
80106b0d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b12:	83 ec 0c             	sub    $0xc,%esp
80106b15:	eb 1b                	jmp    80106b32 <uartputc.part.0+0x32>
80106b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106b20:	83 ec 0c             	sub    $0xc,%esp
80106b23:	6a 0a                	push   $0xa
80106b25:	e8 96 c7 ff ff       	call   801032c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b2a:	83 c4 10             	add    $0x10,%esp
80106b2d:	83 eb 01             	sub    $0x1,%ebx
80106b30:	74 07                	je     80106b39 <uartputc.part.0+0x39>
80106b32:	89 f2                	mov    %esi,%edx
80106b34:	ec                   	in     (%dx),%al
80106b35:	a8 20                	test   $0x20,%al
80106b37:	74 e7                	je     80106b20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b3e:	89 f8                	mov    %edi,%eax
80106b40:	ee                   	out    %al,(%dx)
}
80106b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b44:	5b                   	pop    %ebx
80106b45:	5e                   	pop    %esi
80106b46:	5f                   	pop    %edi
80106b47:	5d                   	pop    %ebp
80106b48:	c3                   	ret    
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <uartinit>:
{
80106b50:	f3 0f 1e fb          	endbr32 
80106b54:	55                   	push   %ebp
80106b55:	31 c9                	xor    %ecx,%ecx
80106b57:	89 c8                	mov    %ecx,%eax
80106b59:	89 e5                	mov    %esp,%ebp
80106b5b:	57                   	push   %edi
80106b5c:	56                   	push   %esi
80106b5d:	53                   	push   %ebx
80106b5e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106b63:	89 da                	mov    %ebx,%edx
80106b65:	83 ec 0c             	sub    $0xc,%esp
80106b68:	ee                   	out    %al,(%dx)
80106b69:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106b6e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106b73:	89 fa                	mov    %edi,%edx
80106b75:	ee                   	out    %al,(%dx)
80106b76:	b8 0c 00 00 00       	mov    $0xc,%eax
80106b7b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b80:	ee                   	out    %al,(%dx)
80106b81:	be f9 03 00 00       	mov    $0x3f9,%esi
80106b86:	89 c8                	mov    %ecx,%eax
80106b88:	89 f2                	mov    %esi,%edx
80106b8a:	ee                   	out    %al,(%dx)
80106b8b:	b8 03 00 00 00       	mov    $0x3,%eax
80106b90:	89 fa                	mov    %edi,%edx
80106b92:	ee                   	out    %al,(%dx)
80106b93:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106b98:	89 c8                	mov    %ecx,%eax
80106b9a:	ee                   	out    %al,(%dx)
80106b9b:	b8 01 00 00 00       	mov    $0x1,%eax
80106ba0:	89 f2                	mov    %esi,%edx
80106ba2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ba3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ba8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ba9:	3c ff                	cmp    $0xff,%al
80106bab:	74 52                	je     80106bff <uartinit+0xaf>
  uart = 1;
80106bad:	c7 05 dc d5 10 80 01 	movl   $0x1,0x8010d5dc
80106bb4:	00 00 00 
80106bb7:	89 da                	mov    %ebx,%edx
80106bb9:	ec                   	in     (%dx),%al
80106bba:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106bbf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106bc0:	83 ec 08             	sub    $0x8,%esp
80106bc3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106bc8:	bb 0c 9c 10 80       	mov    $0x80109c0c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106bcd:	6a 00                	push   $0x0
80106bcf:	6a 04                	push   $0x4
80106bd1:	e8 aa bf ff ff       	call   80102b80 <ioapicenable>
80106bd6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106bd9:	b8 78 00 00 00       	mov    $0x78,%eax
80106bde:	eb 04                	jmp    80106be4 <uartinit+0x94>
80106be0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106be4:	8b 15 dc d5 10 80    	mov    0x8010d5dc,%edx
80106bea:	85 d2                	test   %edx,%edx
80106bec:	74 08                	je     80106bf6 <uartinit+0xa6>
    uartputc(*p);
80106bee:	0f be c0             	movsbl %al,%eax
80106bf1:	e8 0a ff ff ff       	call   80106b00 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106bf6:	89 f0                	mov    %esi,%eax
80106bf8:	83 c3 01             	add    $0x1,%ebx
80106bfb:	84 c0                	test   %al,%al
80106bfd:	75 e1                	jne    80106be0 <uartinit+0x90>
}
80106bff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c02:	5b                   	pop    %ebx
80106c03:	5e                   	pop    %esi
80106c04:	5f                   	pop    %edi
80106c05:	5d                   	pop    %ebp
80106c06:	c3                   	ret    
80106c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <uartputc>:
{
80106c10:	f3 0f 1e fb          	endbr32 
80106c14:	55                   	push   %ebp
  if(!uart)
80106c15:	8b 15 dc d5 10 80    	mov    0x8010d5dc,%edx
{
80106c1b:	89 e5                	mov    %esp,%ebp
80106c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106c20:	85 d2                	test   %edx,%edx
80106c22:	74 0c                	je     80106c30 <uartputc+0x20>
}
80106c24:	5d                   	pop    %ebp
80106c25:	e9 d6 fe ff ff       	jmp    80106b00 <uartputc.part.0>
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c30:	5d                   	pop    %ebp
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c40 <uartintr>:

void
uartintr(void)
{
80106c40:	f3 0f 1e fb          	endbr32 
80106c44:	55                   	push   %ebp
80106c45:	89 e5                	mov    %esp,%ebp
80106c47:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106c4a:	68 d0 6a 10 80       	push   $0x80106ad0
80106c4f:	e8 0c 9c ff ff       	call   80100860 <consoleintr>
}
80106c54:	83 c4 10             	add    $0x10,%esp
80106c57:	c9                   	leave  
80106c58:	c3                   	ret    

80106c59 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $0
80106c5b:	6a 00                	push   $0x0
  jmp alltraps
80106c5d:	e9 27 fb ff ff       	jmp    80106789 <alltraps>

80106c62 <vector1>:
.globl vector1
vector1:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $1
80106c64:	6a 01                	push   $0x1
  jmp alltraps
80106c66:	e9 1e fb ff ff       	jmp    80106789 <alltraps>

80106c6b <vector2>:
.globl vector2
vector2:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $2
80106c6d:	6a 02                	push   $0x2
  jmp alltraps
80106c6f:	e9 15 fb ff ff       	jmp    80106789 <alltraps>

80106c74 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $3
80106c76:	6a 03                	push   $0x3
  jmp alltraps
80106c78:	e9 0c fb ff ff       	jmp    80106789 <alltraps>

80106c7d <vector4>:
.globl vector4
vector4:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $4
80106c7f:	6a 04                	push   $0x4
  jmp alltraps
80106c81:	e9 03 fb ff ff       	jmp    80106789 <alltraps>

80106c86 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $5
80106c88:	6a 05                	push   $0x5
  jmp alltraps
80106c8a:	e9 fa fa ff ff       	jmp    80106789 <alltraps>

80106c8f <vector6>:
.globl vector6
vector6:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $6
80106c91:	6a 06                	push   $0x6
  jmp alltraps
80106c93:	e9 f1 fa ff ff       	jmp    80106789 <alltraps>

80106c98 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $7
80106c9a:	6a 07                	push   $0x7
  jmp alltraps
80106c9c:	e9 e8 fa ff ff       	jmp    80106789 <alltraps>

80106ca1 <vector8>:
.globl vector8
vector8:
  pushl $8
80106ca1:	6a 08                	push   $0x8
  jmp alltraps
80106ca3:	e9 e1 fa ff ff       	jmp    80106789 <alltraps>

80106ca8 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $9
80106caa:	6a 09                	push   $0x9
  jmp alltraps
80106cac:	e9 d8 fa ff ff       	jmp    80106789 <alltraps>

80106cb1 <vector10>:
.globl vector10
vector10:
  pushl $10
80106cb1:	6a 0a                	push   $0xa
  jmp alltraps
80106cb3:	e9 d1 fa ff ff       	jmp    80106789 <alltraps>

80106cb8 <vector11>:
.globl vector11
vector11:
  pushl $11
80106cb8:	6a 0b                	push   $0xb
  jmp alltraps
80106cba:	e9 ca fa ff ff       	jmp    80106789 <alltraps>

80106cbf <vector12>:
.globl vector12
vector12:
  pushl $12
80106cbf:	6a 0c                	push   $0xc
  jmp alltraps
80106cc1:	e9 c3 fa ff ff       	jmp    80106789 <alltraps>

80106cc6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106cc6:	6a 0d                	push   $0xd
  jmp alltraps
80106cc8:	e9 bc fa ff ff       	jmp    80106789 <alltraps>

80106ccd <vector14>:
.globl vector14
vector14:
  pushl $14
80106ccd:	6a 0e                	push   $0xe
  jmp alltraps
80106ccf:	e9 b5 fa ff ff       	jmp    80106789 <alltraps>

80106cd4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $15
80106cd6:	6a 0f                	push   $0xf
  jmp alltraps
80106cd8:	e9 ac fa ff ff       	jmp    80106789 <alltraps>

80106cdd <vector16>:
.globl vector16
vector16:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $16
80106cdf:	6a 10                	push   $0x10
  jmp alltraps
80106ce1:	e9 a3 fa ff ff       	jmp    80106789 <alltraps>

80106ce6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ce6:	6a 11                	push   $0x11
  jmp alltraps
80106ce8:	e9 9c fa ff ff       	jmp    80106789 <alltraps>

80106ced <vector18>:
.globl vector18
vector18:
  pushl $0
80106ced:	6a 00                	push   $0x0
  pushl $18
80106cef:	6a 12                	push   $0x12
  jmp alltraps
80106cf1:	e9 93 fa ff ff       	jmp    80106789 <alltraps>

80106cf6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $19
80106cf8:	6a 13                	push   $0x13
  jmp alltraps
80106cfa:	e9 8a fa ff ff       	jmp    80106789 <alltraps>

80106cff <vector20>:
.globl vector20
vector20:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $20
80106d01:	6a 14                	push   $0x14
  jmp alltraps
80106d03:	e9 81 fa ff ff       	jmp    80106789 <alltraps>

80106d08 <vector21>:
.globl vector21
vector21:
  pushl $0
80106d08:	6a 00                	push   $0x0
  pushl $21
80106d0a:	6a 15                	push   $0x15
  jmp alltraps
80106d0c:	e9 78 fa ff ff       	jmp    80106789 <alltraps>

80106d11 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d11:	6a 00                	push   $0x0
  pushl $22
80106d13:	6a 16                	push   $0x16
  jmp alltraps
80106d15:	e9 6f fa ff ff       	jmp    80106789 <alltraps>

80106d1a <vector23>:
.globl vector23
vector23:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $23
80106d1c:	6a 17                	push   $0x17
  jmp alltraps
80106d1e:	e9 66 fa ff ff       	jmp    80106789 <alltraps>

80106d23 <vector24>:
.globl vector24
vector24:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $24
80106d25:	6a 18                	push   $0x18
  jmp alltraps
80106d27:	e9 5d fa ff ff       	jmp    80106789 <alltraps>

80106d2c <vector25>:
.globl vector25
vector25:
  pushl $0
80106d2c:	6a 00                	push   $0x0
  pushl $25
80106d2e:	6a 19                	push   $0x19
  jmp alltraps
80106d30:	e9 54 fa ff ff       	jmp    80106789 <alltraps>

80106d35 <vector26>:
.globl vector26
vector26:
  pushl $0
80106d35:	6a 00                	push   $0x0
  pushl $26
80106d37:	6a 1a                	push   $0x1a
  jmp alltraps
80106d39:	e9 4b fa ff ff       	jmp    80106789 <alltraps>

80106d3e <vector27>:
.globl vector27
vector27:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $27
80106d40:	6a 1b                	push   $0x1b
  jmp alltraps
80106d42:	e9 42 fa ff ff       	jmp    80106789 <alltraps>

80106d47 <vector28>:
.globl vector28
vector28:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $28
80106d49:	6a 1c                	push   $0x1c
  jmp alltraps
80106d4b:	e9 39 fa ff ff       	jmp    80106789 <alltraps>

80106d50 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d50:	6a 00                	push   $0x0
  pushl $29
80106d52:	6a 1d                	push   $0x1d
  jmp alltraps
80106d54:	e9 30 fa ff ff       	jmp    80106789 <alltraps>

80106d59 <vector30>:
.globl vector30
vector30:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $30
80106d5b:	6a 1e                	push   $0x1e
  jmp alltraps
80106d5d:	e9 27 fa ff ff       	jmp    80106789 <alltraps>

80106d62 <vector31>:
.globl vector31
vector31:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $31
80106d64:	6a 1f                	push   $0x1f
  jmp alltraps
80106d66:	e9 1e fa ff ff       	jmp    80106789 <alltraps>

80106d6b <vector32>:
.globl vector32
vector32:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $32
80106d6d:	6a 20                	push   $0x20
  jmp alltraps
80106d6f:	e9 15 fa ff ff       	jmp    80106789 <alltraps>

80106d74 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d74:	6a 00                	push   $0x0
  pushl $33
80106d76:	6a 21                	push   $0x21
  jmp alltraps
80106d78:	e9 0c fa ff ff       	jmp    80106789 <alltraps>

80106d7d <vector34>:
.globl vector34
vector34:
  pushl $0
80106d7d:	6a 00                	push   $0x0
  pushl $34
80106d7f:	6a 22                	push   $0x22
  jmp alltraps
80106d81:	e9 03 fa ff ff       	jmp    80106789 <alltraps>

80106d86 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $35
80106d88:	6a 23                	push   $0x23
  jmp alltraps
80106d8a:	e9 fa f9 ff ff       	jmp    80106789 <alltraps>

80106d8f <vector36>:
.globl vector36
vector36:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $36
80106d91:	6a 24                	push   $0x24
  jmp alltraps
80106d93:	e9 f1 f9 ff ff       	jmp    80106789 <alltraps>

80106d98 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d98:	6a 00                	push   $0x0
  pushl $37
80106d9a:	6a 25                	push   $0x25
  jmp alltraps
80106d9c:	e9 e8 f9 ff ff       	jmp    80106789 <alltraps>

80106da1 <vector38>:
.globl vector38
vector38:
  pushl $0
80106da1:	6a 00                	push   $0x0
  pushl $38
80106da3:	6a 26                	push   $0x26
  jmp alltraps
80106da5:	e9 df f9 ff ff       	jmp    80106789 <alltraps>

80106daa <vector39>:
.globl vector39
vector39:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $39
80106dac:	6a 27                	push   $0x27
  jmp alltraps
80106dae:	e9 d6 f9 ff ff       	jmp    80106789 <alltraps>

80106db3 <vector40>:
.globl vector40
vector40:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $40
80106db5:	6a 28                	push   $0x28
  jmp alltraps
80106db7:	e9 cd f9 ff ff       	jmp    80106789 <alltraps>

80106dbc <vector41>:
.globl vector41
vector41:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $41
80106dbe:	6a 29                	push   $0x29
  jmp alltraps
80106dc0:	e9 c4 f9 ff ff       	jmp    80106789 <alltraps>

80106dc5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106dc5:	6a 00                	push   $0x0
  pushl $42
80106dc7:	6a 2a                	push   $0x2a
  jmp alltraps
80106dc9:	e9 bb f9 ff ff       	jmp    80106789 <alltraps>

80106dce <vector43>:
.globl vector43
vector43:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $43
80106dd0:	6a 2b                	push   $0x2b
  jmp alltraps
80106dd2:	e9 b2 f9 ff ff       	jmp    80106789 <alltraps>

80106dd7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $44
80106dd9:	6a 2c                	push   $0x2c
  jmp alltraps
80106ddb:	e9 a9 f9 ff ff       	jmp    80106789 <alltraps>

80106de0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106de0:	6a 00                	push   $0x0
  pushl $45
80106de2:	6a 2d                	push   $0x2d
  jmp alltraps
80106de4:	e9 a0 f9 ff ff       	jmp    80106789 <alltraps>

80106de9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106de9:	6a 00                	push   $0x0
  pushl $46
80106deb:	6a 2e                	push   $0x2e
  jmp alltraps
80106ded:	e9 97 f9 ff ff       	jmp    80106789 <alltraps>

80106df2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $47
80106df4:	6a 2f                	push   $0x2f
  jmp alltraps
80106df6:	e9 8e f9 ff ff       	jmp    80106789 <alltraps>

80106dfb <vector48>:
.globl vector48
vector48:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $48
80106dfd:	6a 30                	push   $0x30
  jmp alltraps
80106dff:	e9 85 f9 ff ff       	jmp    80106789 <alltraps>

80106e04 <vector49>:
.globl vector49
vector49:
  pushl $0
80106e04:	6a 00                	push   $0x0
  pushl $49
80106e06:	6a 31                	push   $0x31
  jmp alltraps
80106e08:	e9 7c f9 ff ff       	jmp    80106789 <alltraps>

80106e0d <vector50>:
.globl vector50
vector50:
  pushl $0
80106e0d:	6a 00                	push   $0x0
  pushl $50
80106e0f:	6a 32                	push   $0x32
  jmp alltraps
80106e11:	e9 73 f9 ff ff       	jmp    80106789 <alltraps>

80106e16 <vector51>:
.globl vector51
vector51:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $51
80106e18:	6a 33                	push   $0x33
  jmp alltraps
80106e1a:	e9 6a f9 ff ff       	jmp    80106789 <alltraps>

80106e1f <vector52>:
.globl vector52
vector52:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $52
80106e21:	6a 34                	push   $0x34
  jmp alltraps
80106e23:	e9 61 f9 ff ff       	jmp    80106789 <alltraps>

80106e28 <vector53>:
.globl vector53
vector53:
  pushl $0
80106e28:	6a 00                	push   $0x0
  pushl $53
80106e2a:	6a 35                	push   $0x35
  jmp alltraps
80106e2c:	e9 58 f9 ff ff       	jmp    80106789 <alltraps>

80106e31 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e31:	6a 00                	push   $0x0
  pushl $54
80106e33:	6a 36                	push   $0x36
  jmp alltraps
80106e35:	e9 4f f9 ff ff       	jmp    80106789 <alltraps>

80106e3a <vector55>:
.globl vector55
vector55:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $55
80106e3c:	6a 37                	push   $0x37
  jmp alltraps
80106e3e:	e9 46 f9 ff ff       	jmp    80106789 <alltraps>

80106e43 <vector56>:
.globl vector56
vector56:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $56
80106e45:	6a 38                	push   $0x38
  jmp alltraps
80106e47:	e9 3d f9 ff ff       	jmp    80106789 <alltraps>

80106e4c <vector57>:
.globl vector57
vector57:
  pushl $0
80106e4c:	6a 00                	push   $0x0
  pushl $57
80106e4e:	6a 39                	push   $0x39
  jmp alltraps
80106e50:	e9 34 f9 ff ff       	jmp    80106789 <alltraps>

80106e55 <vector58>:
.globl vector58
vector58:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $58
80106e57:	6a 3a                	push   $0x3a
  jmp alltraps
80106e59:	e9 2b f9 ff ff       	jmp    80106789 <alltraps>

80106e5e <vector59>:
.globl vector59
vector59:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $59
80106e60:	6a 3b                	push   $0x3b
  jmp alltraps
80106e62:	e9 22 f9 ff ff       	jmp    80106789 <alltraps>

80106e67 <vector60>:
.globl vector60
vector60:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $60
80106e69:	6a 3c                	push   $0x3c
  jmp alltraps
80106e6b:	e9 19 f9 ff ff       	jmp    80106789 <alltraps>

80106e70 <vector61>:
.globl vector61
vector61:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $61
80106e72:	6a 3d                	push   $0x3d
  jmp alltraps
80106e74:	e9 10 f9 ff ff       	jmp    80106789 <alltraps>

80106e79 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $62
80106e7b:	6a 3e                	push   $0x3e
  jmp alltraps
80106e7d:	e9 07 f9 ff ff       	jmp    80106789 <alltraps>

80106e82 <vector63>:
.globl vector63
vector63:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $63
80106e84:	6a 3f                	push   $0x3f
  jmp alltraps
80106e86:	e9 fe f8 ff ff       	jmp    80106789 <alltraps>

80106e8b <vector64>:
.globl vector64
vector64:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $64
80106e8d:	6a 40                	push   $0x40
  jmp alltraps
80106e8f:	e9 f5 f8 ff ff       	jmp    80106789 <alltraps>

80106e94 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $65
80106e96:	6a 41                	push   $0x41
  jmp alltraps
80106e98:	e9 ec f8 ff ff       	jmp    80106789 <alltraps>

80106e9d <vector66>:
.globl vector66
vector66:
  pushl $0
80106e9d:	6a 00                	push   $0x0
  pushl $66
80106e9f:	6a 42                	push   $0x42
  jmp alltraps
80106ea1:	e9 e3 f8 ff ff       	jmp    80106789 <alltraps>

80106ea6 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $67
80106ea8:	6a 43                	push   $0x43
  jmp alltraps
80106eaa:	e9 da f8 ff ff       	jmp    80106789 <alltraps>

80106eaf <vector68>:
.globl vector68
vector68:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $68
80106eb1:	6a 44                	push   $0x44
  jmp alltraps
80106eb3:	e9 d1 f8 ff ff       	jmp    80106789 <alltraps>

80106eb8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106eb8:	6a 00                	push   $0x0
  pushl $69
80106eba:	6a 45                	push   $0x45
  jmp alltraps
80106ebc:	e9 c8 f8 ff ff       	jmp    80106789 <alltraps>

80106ec1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ec1:	6a 00                	push   $0x0
  pushl $70
80106ec3:	6a 46                	push   $0x46
  jmp alltraps
80106ec5:	e9 bf f8 ff ff       	jmp    80106789 <alltraps>

80106eca <vector71>:
.globl vector71
vector71:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $71
80106ecc:	6a 47                	push   $0x47
  jmp alltraps
80106ece:	e9 b6 f8 ff ff       	jmp    80106789 <alltraps>

80106ed3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $72
80106ed5:	6a 48                	push   $0x48
  jmp alltraps
80106ed7:	e9 ad f8 ff ff       	jmp    80106789 <alltraps>

80106edc <vector73>:
.globl vector73
vector73:
  pushl $0
80106edc:	6a 00                	push   $0x0
  pushl $73
80106ede:	6a 49                	push   $0x49
  jmp alltraps
80106ee0:	e9 a4 f8 ff ff       	jmp    80106789 <alltraps>

80106ee5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ee5:	6a 00                	push   $0x0
  pushl $74
80106ee7:	6a 4a                	push   $0x4a
  jmp alltraps
80106ee9:	e9 9b f8 ff ff       	jmp    80106789 <alltraps>

80106eee <vector75>:
.globl vector75
vector75:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $75
80106ef0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ef2:	e9 92 f8 ff ff       	jmp    80106789 <alltraps>

80106ef7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $76
80106ef9:	6a 4c                	push   $0x4c
  jmp alltraps
80106efb:	e9 89 f8 ff ff       	jmp    80106789 <alltraps>

80106f00 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f00:	6a 00                	push   $0x0
  pushl $77
80106f02:	6a 4d                	push   $0x4d
  jmp alltraps
80106f04:	e9 80 f8 ff ff       	jmp    80106789 <alltraps>

80106f09 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f09:	6a 00                	push   $0x0
  pushl $78
80106f0b:	6a 4e                	push   $0x4e
  jmp alltraps
80106f0d:	e9 77 f8 ff ff       	jmp    80106789 <alltraps>

80106f12 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $79
80106f14:	6a 4f                	push   $0x4f
  jmp alltraps
80106f16:	e9 6e f8 ff ff       	jmp    80106789 <alltraps>

80106f1b <vector80>:
.globl vector80
vector80:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $80
80106f1d:	6a 50                	push   $0x50
  jmp alltraps
80106f1f:	e9 65 f8 ff ff       	jmp    80106789 <alltraps>

80106f24 <vector81>:
.globl vector81
vector81:
  pushl $0
80106f24:	6a 00                	push   $0x0
  pushl $81
80106f26:	6a 51                	push   $0x51
  jmp alltraps
80106f28:	e9 5c f8 ff ff       	jmp    80106789 <alltraps>

80106f2d <vector82>:
.globl vector82
vector82:
  pushl $0
80106f2d:	6a 00                	push   $0x0
  pushl $82
80106f2f:	6a 52                	push   $0x52
  jmp alltraps
80106f31:	e9 53 f8 ff ff       	jmp    80106789 <alltraps>

80106f36 <vector83>:
.globl vector83
vector83:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $83
80106f38:	6a 53                	push   $0x53
  jmp alltraps
80106f3a:	e9 4a f8 ff ff       	jmp    80106789 <alltraps>

80106f3f <vector84>:
.globl vector84
vector84:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $84
80106f41:	6a 54                	push   $0x54
  jmp alltraps
80106f43:	e9 41 f8 ff ff       	jmp    80106789 <alltraps>

80106f48 <vector85>:
.globl vector85
vector85:
  pushl $0
80106f48:	6a 00                	push   $0x0
  pushl $85
80106f4a:	6a 55                	push   $0x55
  jmp alltraps
80106f4c:	e9 38 f8 ff ff       	jmp    80106789 <alltraps>

80106f51 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f51:	6a 00                	push   $0x0
  pushl $86
80106f53:	6a 56                	push   $0x56
  jmp alltraps
80106f55:	e9 2f f8 ff ff       	jmp    80106789 <alltraps>

80106f5a <vector87>:
.globl vector87
vector87:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $87
80106f5c:	6a 57                	push   $0x57
  jmp alltraps
80106f5e:	e9 26 f8 ff ff       	jmp    80106789 <alltraps>

80106f63 <vector88>:
.globl vector88
vector88:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $88
80106f65:	6a 58                	push   $0x58
  jmp alltraps
80106f67:	e9 1d f8 ff ff       	jmp    80106789 <alltraps>

80106f6c <vector89>:
.globl vector89
vector89:
  pushl $0
80106f6c:	6a 00                	push   $0x0
  pushl $89
80106f6e:	6a 59                	push   $0x59
  jmp alltraps
80106f70:	e9 14 f8 ff ff       	jmp    80106789 <alltraps>

80106f75 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f75:	6a 00                	push   $0x0
  pushl $90
80106f77:	6a 5a                	push   $0x5a
  jmp alltraps
80106f79:	e9 0b f8 ff ff       	jmp    80106789 <alltraps>

80106f7e <vector91>:
.globl vector91
vector91:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $91
80106f80:	6a 5b                	push   $0x5b
  jmp alltraps
80106f82:	e9 02 f8 ff ff       	jmp    80106789 <alltraps>

80106f87 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $92
80106f89:	6a 5c                	push   $0x5c
  jmp alltraps
80106f8b:	e9 f9 f7 ff ff       	jmp    80106789 <alltraps>

80106f90 <vector93>:
.globl vector93
vector93:
  pushl $0
80106f90:	6a 00                	push   $0x0
  pushl $93
80106f92:	6a 5d                	push   $0x5d
  jmp alltraps
80106f94:	e9 f0 f7 ff ff       	jmp    80106789 <alltraps>

80106f99 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f99:	6a 00                	push   $0x0
  pushl $94
80106f9b:	6a 5e                	push   $0x5e
  jmp alltraps
80106f9d:	e9 e7 f7 ff ff       	jmp    80106789 <alltraps>

80106fa2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $95
80106fa4:	6a 5f                	push   $0x5f
  jmp alltraps
80106fa6:	e9 de f7 ff ff       	jmp    80106789 <alltraps>

80106fab <vector96>:
.globl vector96
vector96:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $96
80106fad:	6a 60                	push   $0x60
  jmp alltraps
80106faf:	e9 d5 f7 ff ff       	jmp    80106789 <alltraps>

80106fb4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106fb4:	6a 00                	push   $0x0
  pushl $97
80106fb6:	6a 61                	push   $0x61
  jmp alltraps
80106fb8:	e9 cc f7 ff ff       	jmp    80106789 <alltraps>

80106fbd <vector98>:
.globl vector98
vector98:
  pushl $0
80106fbd:	6a 00                	push   $0x0
  pushl $98
80106fbf:	6a 62                	push   $0x62
  jmp alltraps
80106fc1:	e9 c3 f7 ff ff       	jmp    80106789 <alltraps>

80106fc6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $99
80106fc8:	6a 63                	push   $0x63
  jmp alltraps
80106fca:	e9 ba f7 ff ff       	jmp    80106789 <alltraps>

80106fcf <vector100>:
.globl vector100
vector100:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $100
80106fd1:	6a 64                	push   $0x64
  jmp alltraps
80106fd3:	e9 b1 f7 ff ff       	jmp    80106789 <alltraps>

80106fd8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106fd8:	6a 00                	push   $0x0
  pushl $101
80106fda:	6a 65                	push   $0x65
  jmp alltraps
80106fdc:	e9 a8 f7 ff ff       	jmp    80106789 <alltraps>

80106fe1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106fe1:	6a 00                	push   $0x0
  pushl $102
80106fe3:	6a 66                	push   $0x66
  jmp alltraps
80106fe5:	e9 9f f7 ff ff       	jmp    80106789 <alltraps>

80106fea <vector103>:
.globl vector103
vector103:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $103
80106fec:	6a 67                	push   $0x67
  jmp alltraps
80106fee:	e9 96 f7 ff ff       	jmp    80106789 <alltraps>

80106ff3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $104
80106ff5:	6a 68                	push   $0x68
  jmp alltraps
80106ff7:	e9 8d f7 ff ff       	jmp    80106789 <alltraps>

80106ffc <vector105>:
.globl vector105
vector105:
  pushl $0
80106ffc:	6a 00                	push   $0x0
  pushl $105
80106ffe:	6a 69                	push   $0x69
  jmp alltraps
80107000:	e9 84 f7 ff ff       	jmp    80106789 <alltraps>

80107005 <vector106>:
.globl vector106
vector106:
  pushl $0
80107005:	6a 00                	push   $0x0
  pushl $106
80107007:	6a 6a                	push   $0x6a
  jmp alltraps
80107009:	e9 7b f7 ff ff       	jmp    80106789 <alltraps>

8010700e <vector107>:
.globl vector107
vector107:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $107
80107010:	6a 6b                	push   $0x6b
  jmp alltraps
80107012:	e9 72 f7 ff ff       	jmp    80106789 <alltraps>

80107017 <vector108>:
.globl vector108
vector108:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $108
80107019:	6a 6c                	push   $0x6c
  jmp alltraps
8010701b:	e9 69 f7 ff ff       	jmp    80106789 <alltraps>

80107020 <vector109>:
.globl vector109
vector109:
  pushl $0
80107020:	6a 00                	push   $0x0
  pushl $109
80107022:	6a 6d                	push   $0x6d
  jmp alltraps
80107024:	e9 60 f7 ff ff       	jmp    80106789 <alltraps>

80107029 <vector110>:
.globl vector110
vector110:
  pushl $0
80107029:	6a 00                	push   $0x0
  pushl $110
8010702b:	6a 6e                	push   $0x6e
  jmp alltraps
8010702d:	e9 57 f7 ff ff       	jmp    80106789 <alltraps>

80107032 <vector111>:
.globl vector111
vector111:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $111
80107034:	6a 6f                	push   $0x6f
  jmp alltraps
80107036:	e9 4e f7 ff ff       	jmp    80106789 <alltraps>

8010703b <vector112>:
.globl vector112
vector112:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $112
8010703d:	6a 70                	push   $0x70
  jmp alltraps
8010703f:	e9 45 f7 ff ff       	jmp    80106789 <alltraps>

80107044 <vector113>:
.globl vector113
vector113:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $113
80107046:	6a 71                	push   $0x71
  jmp alltraps
80107048:	e9 3c f7 ff ff       	jmp    80106789 <alltraps>

8010704d <vector114>:
.globl vector114
vector114:
  pushl $0
8010704d:	6a 00                	push   $0x0
  pushl $114
8010704f:	6a 72                	push   $0x72
  jmp alltraps
80107051:	e9 33 f7 ff ff       	jmp    80106789 <alltraps>

80107056 <vector115>:
.globl vector115
vector115:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $115
80107058:	6a 73                	push   $0x73
  jmp alltraps
8010705a:	e9 2a f7 ff ff       	jmp    80106789 <alltraps>

8010705f <vector116>:
.globl vector116
vector116:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $116
80107061:	6a 74                	push   $0x74
  jmp alltraps
80107063:	e9 21 f7 ff ff       	jmp    80106789 <alltraps>

80107068 <vector117>:
.globl vector117
vector117:
  pushl $0
80107068:	6a 00                	push   $0x0
  pushl $117
8010706a:	6a 75                	push   $0x75
  jmp alltraps
8010706c:	e9 18 f7 ff ff       	jmp    80106789 <alltraps>

80107071 <vector118>:
.globl vector118
vector118:
  pushl $0
80107071:	6a 00                	push   $0x0
  pushl $118
80107073:	6a 76                	push   $0x76
  jmp alltraps
80107075:	e9 0f f7 ff ff       	jmp    80106789 <alltraps>

8010707a <vector119>:
.globl vector119
vector119:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $119
8010707c:	6a 77                	push   $0x77
  jmp alltraps
8010707e:	e9 06 f7 ff ff       	jmp    80106789 <alltraps>

80107083 <vector120>:
.globl vector120
vector120:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $120
80107085:	6a 78                	push   $0x78
  jmp alltraps
80107087:	e9 fd f6 ff ff       	jmp    80106789 <alltraps>

8010708c <vector121>:
.globl vector121
vector121:
  pushl $0
8010708c:	6a 00                	push   $0x0
  pushl $121
8010708e:	6a 79                	push   $0x79
  jmp alltraps
80107090:	e9 f4 f6 ff ff       	jmp    80106789 <alltraps>

80107095 <vector122>:
.globl vector122
vector122:
  pushl $0
80107095:	6a 00                	push   $0x0
  pushl $122
80107097:	6a 7a                	push   $0x7a
  jmp alltraps
80107099:	e9 eb f6 ff ff       	jmp    80106789 <alltraps>

8010709e <vector123>:
.globl vector123
vector123:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $123
801070a0:	6a 7b                	push   $0x7b
  jmp alltraps
801070a2:	e9 e2 f6 ff ff       	jmp    80106789 <alltraps>

801070a7 <vector124>:
.globl vector124
vector124:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $124
801070a9:	6a 7c                	push   $0x7c
  jmp alltraps
801070ab:	e9 d9 f6 ff ff       	jmp    80106789 <alltraps>

801070b0 <vector125>:
.globl vector125
vector125:
  pushl $0
801070b0:	6a 00                	push   $0x0
  pushl $125
801070b2:	6a 7d                	push   $0x7d
  jmp alltraps
801070b4:	e9 d0 f6 ff ff       	jmp    80106789 <alltraps>

801070b9 <vector126>:
.globl vector126
vector126:
  pushl $0
801070b9:	6a 00                	push   $0x0
  pushl $126
801070bb:	6a 7e                	push   $0x7e
  jmp alltraps
801070bd:	e9 c7 f6 ff ff       	jmp    80106789 <alltraps>

801070c2 <vector127>:
.globl vector127
vector127:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $127
801070c4:	6a 7f                	push   $0x7f
  jmp alltraps
801070c6:	e9 be f6 ff ff       	jmp    80106789 <alltraps>

801070cb <vector128>:
.globl vector128
vector128:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $128
801070cd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801070d2:	e9 b2 f6 ff ff       	jmp    80106789 <alltraps>

801070d7 <vector129>:
.globl vector129
vector129:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $129
801070d9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801070de:	e9 a6 f6 ff ff       	jmp    80106789 <alltraps>

801070e3 <vector130>:
.globl vector130
vector130:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $130
801070e5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801070ea:	e9 9a f6 ff ff       	jmp    80106789 <alltraps>

801070ef <vector131>:
.globl vector131
vector131:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $131
801070f1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801070f6:	e9 8e f6 ff ff       	jmp    80106789 <alltraps>

801070fb <vector132>:
.globl vector132
vector132:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $132
801070fd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107102:	e9 82 f6 ff ff       	jmp    80106789 <alltraps>

80107107 <vector133>:
.globl vector133
vector133:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $133
80107109:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010710e:	e9 76 f6 ff ff       	jmp    80106789 <alltraps>

80107113 <vector134>:
.globl vector134
vector134:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $134
80107115:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010711a:	e9 6a f6 ff ff       	jmp    80106789 <alltraps>

8010711f <vector135>:
.globl vector135
vector135:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $135
80107121:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107126:	e9 5e f6 ff ff       	jmp    80106789 <alltraps>

8010712b <vector136>:
.globl vector136
vector136:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $136
8010712d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107132:	e9 52 f6 ff ff       	jmp    80106789 <alltraps>

80107137 <vector137>:
.globl vector137
vector137:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $137
80107139:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010713e:	e9 46 f6 ff ff       	jmp    80106789 <alltraps>

80107143 <vector138>:
.globl vector138
vector138:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $138
80107145:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010714a:	e9 3a f6 ff ff       	jmp    80106789 <alltraps>

8010714f <vector139>:
.globl vector139
vector139:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $139
80107151:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107156:	e9 2e f6 ff ff       	jmp    80106789 <alltraps>

8010715b <vector140>:
.globl vector140
vector140:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $140
8010715d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107162:	e9 22 f6 ff ff       	jmp    80106789 <alltraps>

80107167 <vector141>:
.globl vector141
vector141:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $141
80107169:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010716e:	e9 16 f6 ff ff       	jmp    80106789 <alltraps>

80107173 <vector142>:
.globl vector142
vector142:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $142
80107175:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010717a:	e9 0a f6 ff ff       	jmp    80106789 <alltraps>

8010717f <vector143>:
.globl vector143
vector143:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $143
80107181:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107186:	e9 fe f5 ff ff       	jmp    80106789 <alltraps>

8010718b <vector144>:
.globl vector144
vector144:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $144
8010718d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107192:	e9 f2 f5 ff ff       	jmp    80106789 <alltraps>

80107197 <vector145>:
.globl vector145
vector145:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $145
80107199:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010719e:	e9 e6 f5 ff ff       	jmp    80106789 <alltraps>

801071a3 <vector146>:
.globl vector146
vector146:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $146
801071a5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071aa:	e9 da f5 ff ff       	jmp    80106789 <alltraps>

801071af <vector147>:
.globl vector147
vector147:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $147
801071b1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071b6:	e9 ce f5 ff ff       	jmp    80106789 <alltraps>

801071bb <vector148>:
.globl vector148
vector148:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $148
801071bd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801071c2:	e9 c2 f5 ff ff       	jmp    80106789 <alltraps>

801071c7 <vector149>:
.globl vector149
vector149:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $149
801071c9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801071ce:	e9 b6 f5 ff ff       	jmp    80106789 <alltraps>

801071d3 <vector150>:
.globl vector150
vector150:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $150
801071d5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801071da:	e9 aa f5 ff ff       	jmp    80106789 <alltraps>

801071df <vector151>:
.globl vector151
vector151:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $151
801071e1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801071e6:	e9 9e f5 ff ff       	jmp    80106789 <alltraps>

801071eb <vector152>:
.globl vector152
vector152:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $152
801071ed:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801071f2:	e9 92 f5 ff ff       	jmp    80106789 <alltraps>

801071f7 <vector153>:
.globl vector153
vector153:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $153
801071f9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801071fe:	e9 86 f5 ff ff       	jmp    80106789 <alltraps>

80107203 <vector154>:
.globl vector154
vector154:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $154
80107205:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010720a:	e9 7a f5 ff ff       	jmp    80106789 <alltraps>

8010720f <vector155>:
.globl vector155
vector155:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $155
80107211:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107216:	e9 6e f5 ff ff       	jmp    80106789 <alltraps>

8010721b <vector156>:
.globl vector156
vector156:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $156
8010721d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107222:	e9 62 f5 ff ff       	jmp    80106789 <alltraps>

80107227 <vector157>:
.globl vector157
vector157:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $157
80107229:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010722e:	e9 56 f5 ff ff       	jmp    80106789 <alltraps>

80107233 <vector158>:
.globl vector158
vector158:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $158
80107235:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010723a:	e9 4a f5 ff ff       	jmp    80106789 <alltraps>

8010723f <vector159>:
.globl vector159
vector159:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $159
80107241:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107246:	e9 3e f5 ff ff       	jmp    80106789 <alltraps>

8010724b <vector160>:
.globl vector160
vector160:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $160
8010724d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107252:	e9 32 f5 ff ff       	jmp    80106789 <alltraps>

80107257 <vector161>:
.globl vector161
vector161:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $161
80107259:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010725e:	e9 26 f5 ff ff       	jmp    80106789 <alltraps>

80107263 <vector162>:
.globl vector162
vector162:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $162
80107265:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010726a:	e9 1a f5 ff ff       	jmp    80106789 <alltraps>

8010726f <vector163>:
.globl vector163
vector163:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $163
80107271:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107276:	e9 0e f5 ff ff       	jmp    80106789 <alltraps>

8010727b <vector164>:
.globl vector164
vector164:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $164
8010727d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107282:	e9 02 f5 ff ff       	jmp    80106789 <alltraps>

80107287 <vector165>:
.globl vector165
vector165:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $165
80107289:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010728e:	e9 f6 f4 ff ff       	jmp    80106789 <alltraps>

80107293 <vector166>:
.globl vector166
vector166:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $166
80107295:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010729a:	e9 ea f4 ff ff       	jmp    80106789 <alltraps>

8010729f <vector167>:
.globl vector167
vector167:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $167
801072a1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072a6:	e9 de f4 ff ff       	jmp    80106789 <alltraps>

801072ab <vector168>:
.globl vector168
vector168:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $168
801072ad:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072b2:	e9 d2 f4 ff ff       	jmp    80106789 <alltraps>

801072b7 <vector169>:
.globl vector169
vector169:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $169
801072b9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801072be:	e9 c6 f4 ff ff       	jmp    80106789 <alltraps>

801072c3 <vector170>:
.globl vector170
vector170:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $170
801072c5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801072ca:	e9 ba f4 ff ff       	jmp    80106789 <alltraps>

801072cf <vector171>:
.globl vector171
vector171:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $171
801072d1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801072d6:	e9 ae f4 ff ff       	jmp    80106789 <alltraps>

801072db <vector172>:
.globl vector172
vector172:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $172
801072dd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801072e2:	e9 a2 f4 ff ff       	jmp    80106789 <alltraps>

801072e7 <vector173>:
.globl vector173
vector173:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $173
801072e9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801072ee:	e9 96 f4 ff ff       	jmp    80106789 <alltraps>

801072f3 <vector174>:
.globl vector174
vector174:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $174
801072f5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801072fa:	e9 8a f4 ff ff       	jmp    80106789 <alltraps>

801072ff <vector175>:
.globl vector175
vector175:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $175
80107301:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107306:	e9 7e f4 ff ff       	jmp    80106789 <alltraps>

8010730b <vector176>:
.globl vector176
vector176:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $176
8010730d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107312:	e9 72 f4 ff ff       	jmp    80106789 <alltraps>

80107317 <vector177>:
.globl vector177
vector177:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $177
80107319:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010731e:	e9 66 f4 ff ff       	jmp    80106789 <alltraps>

80107323 <vector178>:
.globl vector178
vector178:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $178
80107325:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010732a:	e9 5a f4 ff ff       	jmp    80106789 <alltraps>

8010732f <vector179>:
.globl vector179
vector179:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $179
80107331:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107336:	e9 4e f4 ff ff       	jmp    80106789 <alltraps>

8010733b <vector180>:
.globl vector180
vector180:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $180
8010733d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107342:	e9 42 f4 ff ff       	jmp    80106789 <alltraps>

80107347 <vector181>:
.globl vector181
vector181:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $181
80107349:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010734e:	e9 36 f4 ff ff       	jmp    80106789 <alltraps>

80107353 <vector182>:
.globl vector182
vector182:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $182
80107355:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010735a:	e9 2a f4 ff ff       	jmp    80106789 <alltraps>

8010735f <vector183>:
.globl vector183
vector183:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $183
80107361:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107366:	e9 1e f4 ff ff       	jmp    80106789 <alltraps>

8010736b <vector184>:
.globl vector184
vector184:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $184
8010736d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107372:	e9 12 f4 ff ff       	jmp    80106789 <alltraps>

80107377 <vector185>:
.globl vector185
vector185:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $185
80107379:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010737e:	e9 06 f4 ff ff       	jmp    80106789 <alltraps>

80107383 <vector186>:
.globl vector186
vector186:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $186
80107385:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010738a:	e9 fa f3 ff ff       	jmp    80106789 <alltraps>

8010738f <vector187>:
.globl vector187
vector187:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $187
80107391:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107396:	e9 ee f3 ff ff       	jmp    80106789 <alltraps>

8010739b <vector188>:
.globl vector188
vector188:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $188
8010739d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073a2:	e9 e2 f3 ff ff       	jmp    80106789 <alltraps>

801073a7 <vector189>:
.globl vector189
vector189:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $189
801073a9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073ae:	e9 d6 f3 ff ff       	jmp    80106789 <alltraps>

801073b3 <vector190>:
.globl vector190
vector190:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $190
801073b5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801073ba:	e9 ca f3 ff ff       	jmp    80106789 <alltraps>

801073bf <vector191>:
.globl vector191
vector191:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $191
801073c1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801073c6:	e9 be f3 ff ff       	jmp    80106789 <alltraps>

801073cb <vector192>:
.globl vector192
vector192:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $192
801073cd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801073d2:	e9 b2 f3 ff ff       	jmp    80106789 <alltraps>

801073d7 <vector193>:
.globl vector193
vector193:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $193
801073d9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801073de:	e9 a6 f3 ff ff       	jmp    80106789 <alltraps>

801073e3 <vector194>:
.globl vector194
vector194:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $194
801073e5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801073ea:	e9 9a f3 ff ff       	jmp    80106789 <alltraps>

801073ef <vector195>:
.globl vector195
vector195:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $195
801073f1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801073f6:	e9 8e f3 ff ff       	jmp    80106789 <alltraps>

801073fb <vector196>:
.globl vector196
vector196:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $196
801073fd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107402:	e9 82 f3 ff ff       	jmp    80106789 <alltraps>

80107407 <vector197>:
.globl vector197
vector197:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $197
80107409:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010740e:	e9 76 f3 ff ff       	jmp    80106789 <alltraps>

80107413 <vector198>:
.globl vector198
vector198:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $198
80107415:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010741a:	e9 6a f3 ff ff       	jmp    80106789 <alltraps>

8010741f <vector199>:
.globl vector199
vector199:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $199
80107421:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107426:	e9 5e f3 ff ff       	jmp    80106789 <alltraps>

8010742b <vector200>:
.globl vector200
vector200:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $200
8010742d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107432:	e9 52 f3 ff ff       	jmp    80106789 <alltraps>

80107437 <vector201>:
.globl vector201
vector201:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $201
80107439:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010743e:	e9 46 f3 ff ff       	jmp    80106789 <alltraps>

80107443 <vector202>:
.globl vector202
vector202:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $202
80107445:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010744a:	e9 3a f3 ff ff       	jmp    80106789 <alltraps>

8010744f <vector203>:
.globl vector203
vector203:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $203
80107451:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107456:	e9 2e f3 ff ff       	jmp    80106789 <alltraps>

8010745b <vector204>:
.globl vector204
vector204:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $204
8010745d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107462:	e9 22 f3 ff ff       	jmp    80106789 <alltraps>

80107467 <vector205>:
.globl vector205
vector205:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $205
80107469:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010746e:	e9 16 f3 ff ff       	jmp    80106789 <alltraps>

80107473 <vector206>:
.globl vector206
vector206:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $206
80107475:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010747a:	e9 0a f3 ff ff       	jmp    80106789 <alltraps>

8010747f <vector207>:
.globl vector207
vector207:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $207
80107481:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107486:	e9 fe f2 ff ff       	jmp    80106789 <alltraps>

8010748b <vector208>:
.globl vector208
vector208:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $208
8010748d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107492:	e9 f2 f2 ff ff       	jmp    80106789 <alltraps>

80107497 <vector209>:
.globl vector209
vector209:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $209
80107499:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010749e:	e9 e6 f2 ff ff       	jmp    80106789 <alltraps>

801074a3 <vector210>:
.globl vector210
vector210:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $210
801074a5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074aa:	e9 da f2 ff ff       	jmp    80106789 <alltraps>

801074af <vector211>:
.globl vector211
vector211:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $211
801074b1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074b6:	e9 ce f2 ff ff       	jmp    80106789 <alltraps>

801074bb <vector212>:
.globl vector212
vector212:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $212
801074bd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801074c2:	e9 c2 f2 ff ff       	jmp    80106789 <alltraps>

801074c7 <vector213>:
.globl vector213
vector213:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $213
801074c9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801074ce:	e9 b6 f2 ff ff       	jmp    80106789 <alltraps>

801074d3 <vector214>:
.globl vector214
vector214:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $214
801074d5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801074da:	e9 aa f2 ff ff       	jmp    80106789 <alltraps>

801074df <vector215>:
.globl vector215
vector215:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $215
801074e1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801074e6:	e9 9e f2 ff ff       	jmp    80106789 <alltraps>

801074eb <vector216>:
.globl vector216
vector216:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $216
801074ed:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801074f2:	e9 92 f2 ff ff       	jmp    80106789 <alltraps>

801074f7 <vector217>:
.globl vector217
vector217:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $217
801074f9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801074fe:	e9 86 f2 ff ff       	jmp    80106789 <alltraps>

80107503 <vector218>:
.globl vector218
vector218:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $218
80107505:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010750a:	e9 7a f2 ff ff       	jmp    80106789 <alltraps>

8010750f <vector219>:
.globl vector219
vector219:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $219
80107511:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107516:	e9 6e f2 ff ff       	jmp    80106789 <alltraps>

8010751b <vector220>:
.globl vector220
vector220:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $220
8010751d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107522:	e9 62 f2 ff ff       	jmp    80106789 <alltraps>

80107527 <vector221>:
.globl vector221
vector221:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $221
80107529:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010752e:	e9 56 f2 ff ff       	jmp    80106789 <alltraps>

80107533 <vector222>:
.globl vector222
vector222:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $222
80107535:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010753a:	e9 4a f2 ff ff       	jmp    80106789 <alltraps>

8010753f <vector223>:
.globl vector223
vector223:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $223
80107541:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107546:	e9 3e f2 ff ff       	jmp    80106789 <alltraps>

8010754b <vector224>:
.globl vector224
vector224:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $224
8010754d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107552:	e9 32 f2 ff ff       	jmp    80106789 <alltraps>

80107557 <vector225>:
.globl vector225
vector225:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $225
80107559:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010755e:	e9 26 f2 ff ff       	jmp    80106789 <alltraps>

80107563 <vector226>:
.globl vector226
vector226:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $226
80107565:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010756a:	e9 1a f2 ff ff       	jmp    80106789 <alltraps>

8010756f <vector227>:
.globl vector227
vector227:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $227
80107571:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107576:	e9 0e f2 ff ff       	jmp    80106789 <alltraps>

8010757b <vector228>:
.globl vector228
vector228:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $228
8010757d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107582:	e9 02 f2 ff ff       	jmp    80106789 <alltraps>

80107587 <vector229>:
.globl vector229
vector229:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $229
80107589:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010758e:	e9 f6 f1 ff ff       	jmp    80106789 <alltraps>

80107593 <vector230>:
.globl vector230
vector230:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $230
80107595:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010759a:	e9 ea f1 ff ff       	jmp    80106789 <alltraps>

8010759f <vector231>:
.globl vector231
vector231:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $231
801075a1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075a6:	e9 de f1 ff ff       	jmp    80106789 <alltraps>

801075ab <vector232>:
.globl vector232
vector232:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $232
801075ad:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075b2:	e9 d2 f1 ff ff       	jmp    80106789 <alltraps>

801075b7 <vector233>:
.globl vector233
vector233:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $233
801075b9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801075be:	e9 c6 f1 ff ff       	jmp    80106789 <alltraps>

801075c3 <vector234>:
.globl vector234
vector234:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $234
801075c5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801075ca:	e9 ba f1 ff ff       	jmp    80106789 <alltraps>

801075cf <vector235>:
.globl vector235
vector235:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $235
801075d1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801075d6:	e9 ae f1 ff ff       	jmp    80106789 <alltraps>

801075db <vector236>:
.globl vector236
vector236:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $236
801075dd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801075e2:	e9 a2 f1 ff ff       	jmp    80106789 <alltraps>

801075e7 <vector237>:
.globl vector237
vector237:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $237
801075e9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801075ee:	e9 96 f1 ff ff       	jmp    80106789 <alltraps>

801075f3 <vector238>:
.globl vector238
vector238:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $238
801075f5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801075fa:	e9 8a f1 ff ff       	jmp    80106789 <alltraps>

801075ff <vector239>:
.globl vector239
vector239:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $239
80107601:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107606:	e9 7e f1 ff ff       	jmp    80106789 <alltraps>

8010760b <vector240>:
.globl vector240
vector240:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $240
8010760d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107612:	e9 72 f1 ff ff       	jmp    80106789 <alltraps>

80107617 <vector241>:
.globl vector241
vector241:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $241
80107619:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010761e:	e9 66 f1 ff ff       	jmp    80106789 <alltraps>

80107623 <vector242>:
.globl vector242
vector242:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $242
80107625:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010762a:	e9 5a f1 ff ff       	jmp    80106789 <alltraps>

8010762f <vector243>:
.globl vector243
vector243:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $243
80107631:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107636:	e9 4e f1 ff ff       	jmp    80106789 <alltraps>

8010763b <vector244>:
.globl vector244
vector244:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $244
8010763d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107642:	e9 42 f1 ff ff       	jmp    80106789 <alltraps>

80107647 <vector245>:
.globl vector245
vector245:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $245
80107649:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010764e:	e9 36 f1 ff ff       	jmp    80106789 <alltraps>

80107653 <vector246>:
.globl vector246
vector246:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $246
80107655:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010765a:	e9 2a f1 ff ff       	jmp    80106789 <alltraps>

8010765f <vector247>:
.globl vector247
vector247:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $247
80107661:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107666:	e9 1e f1 ff ff       	jmp    80106789 <alltraps>

8010766b <vector248>:
.globl vector248
vector248:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $248
8010766d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107672:	e9 12 f1 ff ff       	jmp    80106789 <alltraps>

80107677 <vector249>:
.globl vector249
vector249:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $249
80107679:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010767e:	e9 06 f1 ff ff       	jmp    80106789 <alltraps>

80107683 <vector250>:
.globl vector250
vector250:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $250
80107685:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010768a:	e9 fa f0 ff ff       	jmp    80106789 <alltraps>

8010768f <vector251>:
.globl vector251
vector251:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $251
80107691:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107696:	e9 ee f0 ff ff       	jmp    80106789 <alltraps>

8010769b <vector252>:
.globl vector252
vector252:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $252
8010769d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076a2:	e9 e2 f0 ff ff       	jmp    80106789 <alltraps>

801076a7 <vector253>:
.globl vector253
vector253:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $253
801076a9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076ae:	e9 d6 f0 ff ff       	jmp    80106789 <alltraps>

801076b3 <vector254>:
.globl vector254
vector254:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $254
801076b5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801076ba:	e9 ca f0 ff ff       	jmp    80106789 <alltraps>

801076bf <vector255>:
.globl vector255
vector255:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $255
801076c1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801076c6:	e9 be f0 ff ff       	jmp    80106789 <alltraps>
801076cb:	66 90                	xchg   %ax,%ax
801076cd:	66 90                	xchg   %ax,%ax
801076cf:	90                   	nop

801076d0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801076d7:	c1 ea 16             	shr    $0x16,%edx
{
801076da:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801076db:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801076de:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801076e1:	8b 1f                	mov    (%edi),%ebx
801076e3:	f6 c3 01             	test   $0x1,%bl
801076e6:	74 28                	je     80107710 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801076ee:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801076f4:	89 f0                	mov    %esi,%eax
}
801076f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801076f9:	c1 e8 0a             	shr    $0xa,%eax
801076fc:	25 fc 0f 00 00       	and    $0xffc,%eax
80107701:	01 d8                	add    %ebx,%eax
}
80107703:	5b                   	pop    %ebx
80107704:	5e                   	pop    %esi
80107705:	5f                   	pop    %edi
80107706:	5d                   	pop    %ebp
80107707:	c3                   	ret    
80107708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107710:	85 c9                	test   %ecx,%ecx
80107712:	74 2c                	je     80107740 <walkpgdir+0x70>
80107714:	e8 a7 b7 ff ff       	call   80102ec0 <kalloc>
80107719:	89 c3                	mov    %eax,%ebx
8010771b:	85 c0                	test   %eax,%eax
8010771d:	74 21                	je     80107740 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010771f:	83 ec 04             	sub    $0x4,%esp
80107722:	68 00 10 00 00       	push   $0x1000
80107727:	6a 00                	push   $0x0
80107729:	50                   	push   %eax
8010772a:	e8 11 de ff ff       	call   80105540 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010772f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107735:	83 c4 10             	add    $0x10,%esp
80107738:	83 c8 07             	or     $0x7,%eax
8010773b:	89 07                	mov    %eax,(%edi)
8010773d:	eb b5                	jmp    801076f4 <walkpgdir+0x24>
8010773f:	90                   	nop
}
80107740:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107743:	31 c0                	xor    %eax,%eax
}
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107750 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107756:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010775a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010775b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107760:	89 d6                	mov    %edx,%esi
{
80107762:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107763:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107769:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010776c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010776f:	8b 45 08             	mov    0x8(%ebp),%eax
80107772:	29 f0                	sub    %esi,%eax
80107774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107777:	eb 1f                	jmp    80107798 <mappages+0x48>
80107779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107780:	f6 00 01             	testb  $0x1,(%eax)
80107783:	75 45                	jne    801077ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107785:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107788:	83 cb 01             	or     $0x1,%ebx
8010778b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010778d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107790:	74 2e                	je     801077c0 <mappages+0x70>
      break;
    a += PGSIZE;
80107792:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010779b:	b9 01 00 00 00       	mov    $0x1,%ecx
801077a0:	89 f2                	mov    %esi,%edx
801077a2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801077a5:	89 f8                	mov    %edi,%eax
801077a7:	e8 24 ff ff ff       	call   801076d0 <walkpgdir>
801077ac:	85 c0                	test   %eax,%eax
801077ae:	75 d0                	jne    80107780 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801077b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077b8:	5b                   	pop    %ebx
801077b9:	5e                   	pop    %esi
801077ba:	5f                   	pop    %edi
801077bb:	5d                   	pop    %ebp
801077bc:	c3                   	ret    
801077bd:	8d 76 00             	lea    0x0(%esi),%esi
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077c3:	31 c0                	xor    %eax,%eax
}
801077c5:	5b                   	pop    %ebx
801077c6:	5e                   	pop    %esi
801077c7:	5f                   	pop    %edi
801077c8:	5d                   	pop    %ebp
801077c9:	c3                   	ret    
      panic("remap");
801077ca:	83 ec 0c             	sub    $0xc,%esp
801077cd:	68 14 9c 10 80       	push   $0x80109c14
801077d2:	e8 b9 8b ff ff       	call   80100390 <panic>
801077d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077de:	66 90                	xchg   %ax,%ax

801077e0 <printlist>:
{
801077e0:	f3 0f 1e fb          	endbr32 
801077e4:	55                   	push   %ebp
801077e5:	89 e5                	mov    %esp,%ebp
801077e7:	56                   	push   %esi
  struct fblock *curr = myproc()->free_head;
801077e8:	be 10 00 00 00       	mov    $0x10,%esi
{
801077ed:	53                   	push   %ebx
  cprintf("printing list:\n");
801077ee:	83 ec 0c             	sub    $0xc,%esp
801077f1:	68 1a 9c 10 80       	push   $0x80109c1a
801077f6:	e8 b5 8e ff ff       	call   801006b0 <cprintf>
  struct fblock *curr = myproc()->free_head;
801077fb:	e8 70 cc ff ff       	call   80104470 <myproc>
80107800:	83 c4 10             	add    $0x10,%esp
80107803:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d -> ", curr->off);
80107810:	83 ec 08             	sub    $0x8,%esp
80107813:	ff 33                	pushl  (%ebx)
80107815:	68 2a 9c 10 80       	push   $0x80109c2a
8010781a:	e8 91 8e ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
8010781f:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107822:	83 c4 10             	add    $0x10,%esp
80107825:	85 db                	test   %ebx,%ebx
80107827:	74 05                	je     8010782e <printlist+0x4e>
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107829:	83 ee 01             	sub    $0x1,%esi
8010782c:	75 e2                	jne    80107810 <printlist+0x30>
  cprintf("\n");
8010782e:	83 ec 0c             	sub    $0xc,%esp
80107831:	68 40 9d 10 80       	push   $0x80109d40
80107836:	e8 75 8e ff ff       	call   801006b0 <cprintf>
}
8010783b:	83 c4 10             	add    $0x10,%esp
8010783e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107841:	5b                   	pop    %ebx
80107842:	5e                   	pop    %esi
80107843:	5d                   	pop    %ebp
80107844:	c3                   	ret    
80107845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107850 <printaq>:
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
80107855:	89 e5                	mov    %esp,%ebp
80107857:	53                   	push   %ebx
80107858:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
8010785b:	68 31 9c 10 80       	push   $0x80109c31
80107860:	e8 4b 8e ff ff       	call   801006b0 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107865:	e8 06 cc ff ff       	call   80104470 <myproc>
8010786a:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107870:	8b 58 08             	mov    0x8(%eax),%ebx
80107873:	e8 f8 cb ff ff       	call   80104470 <myproc>
80107878:	83 c4 0c             	add    $0xc,%esp
8010787b:	53                   	push   %ebx
8010787c:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107882:	ff 70 08             	pushl  0x8(%eax)
80107885:	68 43 9c 10 80       	push   $0x80109c43
8010788a:	e8 21 8e ff ff       	call   801006b0 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010788f:	e8 dc cb ff ff       	call   80104470 <myproc>
80107894:	83 c4 10             	add    $0x10,%esp
80107897:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010789d:	8b 50 04             	mov    0x4(%eax),%edx
801078a0:	85 d2                	test   %edx,%edx
801078a2:	74 5c                	je     80107900 <printaq+0xb0>
  struct queue_node *curr = myproc()->queue_head;
801078a4:	e8 c7 cb ff ff       	call   80104470 <myproc>
801078a9:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
801078af:	85 db                	test   %ebx,%ebx
801078b1:	74 1e                	je     801078d1 <printaq+0x81>
801078b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078b7:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
801078b8:	83 ec 08             	sub    $0x8,%esp
801078bb:	ff 73 08             	pushl  0x8(%ebx)
801078be:	68 61 9c 10 80       	push   $0x80109c61
801078c3:	e8 e8 8d ff ff       	call   801006b0 <cprintf>
    curr = curr->next;
801078c8:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
801078ca:	83 c4 10             	add    $0x10,%esp
801078cd:	85 db                	test   %ebx,%ebx
801078cf:	75 e7                	jne    801078b8 <printaq+0x68>
  if(myproc()->queue_tail->next == 0)
801078d1:	e8 9a cb ff ff       	call   80104470 <myproc>
801078d6:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801078dc:	8b 00                	mov    (%eax),%eax
801078de:	85 c0                	test   %eax,%eax
801078e0:	74 36                	je     80107918 <printaq+0xc8>
  cprintf("\n");
801078e2:	83 ec 0c             	sub    $0xc,%esp
801078e5:	68 40 9d 10 80       	push   $0x80109d40
801078ea:	e8 c1 8d ff ff       	call   801006b0 <cprintf>
}
801078ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801078f2:	83 c4 10             	add    $0x10,%esp
801078f5:	c9                   	leave  
801078f6:	c3                   	ret    
801078f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078fe:	66 90                	xchg   %ax,%ax
    cprintf("null <-> ");
80107900:	83 ec 0c             	sub    $0xc,%esp
80107903:	68 57 9c 10 80       	push   $0x80109c57
80107908:	e8 a3 8d ff ff       	call   801006b0 <cprintf>
8010790d:	83 c4 10             	add    $0x10,%esp
80107910:	eb 92                	jmp    801078a4 <printaq+0x54>
80107912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
80107918:	83 ec 0c             	sub    $0xc,%esp
8010791b:	68 57 9c 10 80       	push   $0x80109c57
80107920:	e8 8b 8d ff ff       	call   801006b0 <cprintf>
80107925:	83 c4 10             	add    $0x10,%esp
80107928:	eb b8                	jmp    801078e2 <printaq+0x92>
8010792a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107930 <seginit>:
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010793a:	e8 11 cb ff ff       	call   80104450 <cpuid>
  pd[0] = size-1;
8010793f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107944:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010794a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010794e:	c7 80 d8 6b 18 80 ff 	movl   $0xffff,-0x7fe79428(%eax)
80107955:	ff 00 00 
80107958:	c7 80 dc 6b 18 80 00 	movl   $0xcf9a00,-0x7fe79424(%eax)
8010795f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107962:	c7 80 e0 6b 18 80 ff 	movl   $0xffff,-0x7fe79420(%eax)
80107969:	ff 00 00 
8010796c:	c7 80 e4 6b 18 80 00 	movl   $0xcf9200,-0x7fe7941c(%eax)
80107973:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107976:	c7 80 e8 6b 18 80 ff 	movl   $0xffff,-0x7fe79418(%eax)
8010797d:	ff 00 00 
80107980:	c7 80 ec 6b 18 80 00 	movl   $0xcffa00,-0x7fe79414(%eax)
80107987:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010798a:	c7 80 f0 6b 18 80 ff 	movl   $0xffff,-0x7fe79410(%eax)
80107991:	ff 00 00 
80107994:	c7 80 f4 6b 18 80 00 	movl   $0xcff200,-0x7fe7940c(%eax)
8010799b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010799e:	05 d0 6b 18 80       	add    $0x80186bd0,%eax
  pd[1] = (uint)p;
801079a3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801079a7:	c1 e8 10             	shr    $0x10,%eax
801079aa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801079ae:	8d 45 f2             	lea    -0xe(%ebp),%eax
801079b1:	0f 01 10             	lgdtl  (%eax)
}
801079b4:	c9                   	leave  
801079b5:	c3                   	ret    
801079b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079bd:	8d 76 00             	lea    0x0(%esi),%esi

801079c0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801079c0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079c4:	a1 84 85 19 80       	mov    0x80198584,%eax
801079c9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079ce:	0f 22 d8             	mov    %eax,%cr3
}
801079d1:	c3                   	ret    
801079d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801079e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801079e0:	f3 0f 1e fb          	endbr32 
801079e4:	55                   	push   %ebp
801079e5:	89 e5                	mov    %esp,%ebp
801079e7:	57                   	push   %edi
801079e8:	56                   	push   %esi
801079e9:	53                   	push   %ebx
801079ea:	83 ec 1c             	sub    $0x1c,%esp
801079ed:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801079f0:	85 f6                	test   %esi,%esi
801079f2:	0f 84 cb 00 00 00    	je     80107ac3 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801079f8:	8b 46 08             	mov    0x8(%esi),%eax
801079fb:	85 c0                	test   %eax,%eax
801079fd:	0f 84 da 00 00 00    	je     80107add <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107a03:	8b 46 04             	mov    0x4(%esi),%eax
80107a06:	85 c0                	test   %eax,%eax
80107a08:	0f 84 c2 00 00 00    	je     80107ad0 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
80107a0e:	e8 1d d9 ff ff       	call   80105330 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a13:	e8 c8 c9 ff ff       	call   801043e0 <mycpu>
80107a18:	89 c3                	mov    %eax,%ebx
80107a1a:	e8 c1 c9 ff ff       	call   801043e0 <mycpu>
80107a1f:	89 c7                	mov    %eax,%edi
80107a21:	e8 ba c9 ff ff       	call   801043e0 <mycpu>
80107a26:	83 c7 08             	add    $0x8,%edi
80107a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a2c:	e8 af c9 ff ff       	call   801043e0 <mycpu>
80107a31:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a34:	ba 67 00 00 00       	mov    $0x67,%edx
80107a39:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107a40:	83 c0 08             	add    $0x8,%eax
80107a43:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a4a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a4f:	83 c1 08             	add    $0x8,%ecx
80107a52:	c1 e8 18             	shr    $0x18,%eax
80107a55:	c1 e9 10             	shr    $0x10,%ecx
80107a58:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107a5e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a64:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a69:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a70:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107a75:	e8 66 c9 ff ff       	call   801043e0 <mycpu>
80107a7a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a81:	e8 5a c9 ff ff       	call   801043e0 <mycpu>
80107a86:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107a8a:	8b 5e 08             	mov    0x8(%esi),%ebx
80107a8d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a93:	e8 48 c9 ff ff       	call   801043e0 <mycpu>
80107a98:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a9b:	e8 40 c9 ff ff       	call   801043e0 <mycpu>
80107aa0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107aa4:	b8 28 00 00 00       	mov    $0x28,%eax
80107aa9:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107aac:	8b 46 04             	mov    0x4(%esi),%eax
80107aaf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ab4:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aba:	5b                   	pop    %ebx
80107abb:	5e                   	pop    %esi
80107abc:	5f                   	pop    %edi
80107abd:	5d                   	pop    %ebp
  popcli();
80107abe:	e9 bd d8 ff ff       	jmp    80105380 <popcli>
    panic("switchuvm: no process");
80107ac3:	83 ec 0c             	sub    $0xc,%esp
80107ac6:	68 69 9c 10 80       	push   $0x80109c69
80107acb:	e8 c0 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107ad0:	83 ec 0c             	sub    $0xc,%esp
80107ad3:	68 94 9c 10 80       	push   $0x80109c94
80107ad8:	e8 b3 88 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107add:	83 ec 0c             	sub    $0xc,%esp
80107ae0:	68 7f 9c 10 80       	push   $0x80109c7f
80107ae5:	e8 a6 88 ff ff       	call   80100390 <panic>
80107aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107af0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107af0:	f3 0f 1e fb          	endbr32 
80107af4:	55                   	push   %ebp
80107af5:	89 e5                	mov    %esp,%ebp
80107af7:	57                   	push   %edi
80107af8:	56                   	push   %esi
80107af9:	53                   	push   %ebx
80107afa:	83 ec 1c             	sub    $0x1c,%esp
80107afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b00:	8b 75 10             	mov    0x10(%ebp),%esi
80107b03:	8b 7d 08             	mov    0x8(%ebp),%edi
80107b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80107b09:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107b0f:	77 4b                	ja     80107b5c <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
80107b11:	e8 aa b3 ff ff       	call   80102ec0 <kalloc>
  memset(mem, 0, PGSIZE);
80107b16:	83 ec 04             	sub    $0x4,%esp
80107b19:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107b1e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107b20:	6a 00                	push   $0x0
80107b22:	50                   	push   %eax
80107b23:	e8 18 da ff ff       	call   80105540 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b28:	58                   	pop    %eax
80107b29:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b2f:	5a                   	pop    %edx
80107b30:	6a 06                	push   $0x6
80107b32:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b37:	31 d2                	xor    %edx,%edx
80107b39:	50                   	push   %eax
80107b3a:	89 f8                	mov    %edi,%eax
80107b3c:	e8 0f fc ff ff       	call   80107750 <mappages>
  memmove(mem, init, sz);
80107b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b44:	89 75 10             	mov    %esi,0x10(%ebp)
80107b47:	83 c4 10             	add    $0x10,%esp
80107b4a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107b4d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b53:	5b                   	pop    %ebx
80107b54:	5e                   	pop    %esi
80107b55:	5f                   	pop    %edi
80107b56:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107b57:	e9 84 da ff ff       	jmp    801055e0 <memmove>
    panic("inituvm: more than a page");
80107b5c:	83 ec 0c             	sub    $0xc,%esp
80107b5f:	68 a8 9c 10 80       	push   $0x80109ca8
80107b64:	e8 27 88 ff ff       	call   80100390 <panic>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b70 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107b70:	f3 0f 1e fb          	endbr32 
80107b74:	55                   	push   %ebp
80107b75:	89 e5                	mov    %esp,%ebp
80107b77:	57                   	push   %edi
80107b78:	56                   	push   %esi
80107b79:	53                   	push   %ebx
80107b7a:	83 ec 1c             	sub    $0x1c,%esp
80107b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b80:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107b83:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107b88:	0f 85 99 00 00 00    	jne    80107c27 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107b8e:	01 f0                	add    %esi,%eax
80107b90:	89 f3                	mov    %esi,%ebx
80107b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107b95:	8b 45 14             	mov    0x14(%ebp),%eax
80107b98:	01 f0                	add    %esi,%eax
80107b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107b9d:	85 f6                	test   %esi,%esi
80107b9f:	75 15                	jne    80107bb6 <loaduvm+0x46>
80107ba1:	eb 6d                	jmp    80107c10 <loaduvm+0xa0>
80107ba3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ba7:	90                   	nop
80107ba8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107bae:	89 f0                	mov    %esi,%eax
80107bb0:	29 d8                	sub    %ebx,%eax
80107bb2:	39 c6                	cmp    %eax,%esi
80107bb4:	76 5a                	jbe    80107c10 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107bb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107bbc:	31 c9                	xor    %ecx,%ecx
80107bbe:	29 da                	sub    %ebx,%edx
80107bc0:	e8 0b fb ff ff       	call   801076d0 <walkpgdir>
80107bc5:	85 c0                	test   %eax,%eax
80107bc7:	74 51                	je     80107c1a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107bc9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107bcb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107bce:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107bd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107bd8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107bde:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107be1:	29 d9                	sub    %ebx,%ecx
80107be3:	05 00 00 00 80       	add    $0x80000000,%eax
80107be8:	57                   	push   %edi
80107be9:	51                   	push   %ecx
80107bea:	50                   	push   %eax
80107beb:	ff 75 10             	pushl  0x10(%ebp)
80107bee:	e8 3d a2 ff ff       	call   80101e30 <readi>
80107bf3:	83 c4 10             	add    $0x10,%esp
80107bf6:	39 f8                	cmp    %edi,%eax
80107bf8:	74 ae                	je     80107ba8 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
80107bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c02:	5b                   	pop    %ebx
80107c03:	5e                   	pop    %esi
80107c04:	5f                   	pop    %edi
80107c05:	5d                   	pop    %ebp
80107c06:	c3                   	ret    
80107c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c0e:	66 90                	xchg   %ax,%ax
80107c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c13:	31 c0                	xor    %eax,%eax
}
80107c15:	5b                   	pop    %ebx
80107c16:	5e                   	pop    %esi
80107c17:	5f                   	pop    %edi
80107c18:	5d                   	pop    %ebp
80107c19:	c3                   	ret    
      panic("loaduvm: address should exist");
80107c1a:	83 ec 0c             	sub    $0xc,%esp
80107c1d:	68 c2 9c 10 80       	push   $0x80109cc2
80107c22:	e8 69 87 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107c27:	83 ec 0c             	sub    $0xc,%esp
80107c2a:	68 58 9e 10 80       	push   $0x80109e58
80107c2f:	e8 5c 87 ff ff       	call   80100390 <panic>
80107c34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c3f:	90                   	nop

80107c40 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107c40:	f3 0f 1e fb          	endbr32 
80107c44:	55                   	push   %ebp
80107c45:	89 e5                	mov    %esp,%ebp
80107c47:	53                   	push   %ebx
80107c48:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107c4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107c4e:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107c54:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
80107c57:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107c5a:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107c5c:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107c62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107c65:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107c6c:	00 00 00 
  page->swap_offset = -1;
80107c6f:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107c76:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107c79:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107c7f:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107c85:	5b                   	pop    %ebx
80107c86:	5d                   	pop    %ebp
80107c87:	c3                   	ret    
80107c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c8f:	90                   	nop

80107c90 <allocuvm_withswap>:



void
allocuvm_withswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107c90:	f3 0f 1e fb          	endbr32 
80107c94:	55                   	push   %ebp
80107c95:	89 e5                	mov    %esp,%ebp
80107c97:	57                   	push   %edi
80107c98:	56                   	push   %esi
80107c99:	53                   	push   %ebx
80107c9a:	83 ec 0c             	sub    $0xc,%esp
80107c9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107ca0:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107ca7:	0f 8f 38 01 00 00    	jg     80107de5 <allocuvm_withswap+0x155>

      // get info of the page to be evicted
      uint evicted_ind = indexToEvict();
      // cprintf("[allocuvm] index to evict: %d\n",evicted_ind);
      struct page *evicted_page = &curproc->ramPages[evicted_ind];
      int swap_offset = curproc->free_head->off;
80107cad:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx

      if(curproc->free_head->next == 0)
80107cb3:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107cb6:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107cb8:	85 c0                	test   %eax,%eax
80107cba:	0f 84 00 01 00 00    	je     80107dc0 <allocuvm_withswap+0x130>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80107cc0:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107cc3:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107cc9:	ff 70 08             	pushl  0x8(%eax)
80107ccc:	e8 ef ae ff ff       	call   80102bc0 <kfree>
80107cd1:	83 c4 10             	add    $0x10,%esp
      }

      // cprintf("before write to swap\n");
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107cd4:	68 00 10 00 00       	push   $0x1000
80107cd9:	56                   	push   %esi
80107cda:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
80107ce0:	53                   	push   %ebx
80107ce1:	e8 7a aa ff ff       	call   80102760 <writeToSwapFile>
80107ce6:	83 c4 10             	add    $0x10,%esp
80107ce9:	85 c0                	test   %eax,%eax
80107ceb:	0f 88 0e 01 00 00    	js     80107dff <allocuvm_withswap+0x16f>
        panic("allocuvm: writeToSwapFile");


      curproc->swappedPages[curproc->num_swap].isused = 1;
80107cf1:	8b 8b 0c 04 00 00    	mov    0x40c(%ebx),%ecx
80107cf7:	6b c1 1c             	imul   $0x1c,%ecx,%eax
80107cfa:	01 d8                	add    %ebx,%eax
80107cfc:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80107d03:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107d06:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80107d0c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107d12:	8b bb 9c 02 00 00    	mov    0x29c(%ebx),%edi
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107d18:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107d1e:	89 b8 88 00 00 00    	mov    %edi,0x88(%eax)
      // cprintf("num swap: %d\n", curproc->num_swap);
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107d24:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107d2a:	0f 22 d8             	mov    %eax,%cr3
      curproc->num_swap ++;
80107d2d:	83 c1 01             	add    $0x1,%ecx


      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107d30:	89 f8                	mov    %edi,%eax
      curproc->num_swap ++;
80107d32:	89 8b 0c 04 00 00    	mov    %ecx,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107d38:	31 c9                	xor    %ecx,%ecx
80107d3a:	e8 91 f9 ff ff       	call   801076d0 <walkpgdir>
80107d3f:	89 c7                	mov    %eax,%edi



      if(!(*evicted_pte & PTE_P))
80107d41:	8b 00                	mov    (%eax),%eax
80107d43:	a8 01                	test   $0x1,%al
80107d45:	0f 84 a7 00 00 00    	je     80107df2 <allocuvm_withswap+0x162>
        panic("allocuvm: swap: ram page not present");
      
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107d4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      
      if(getRefs(P2V(evicted_pa)) == 1)
80107d50:	83 ec 0c             	sub    $0xc,%esp
80107d53:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107d59:	56                   	push   %esi
80107d5a:	e8 01 b3 ff ff       	call   80103060 <getRefs>
80107d5f:	83 c4 10             	add    $0x10,%esp
80107d62:	83 f8 01             	cmp    $0x1,%eax
80107d65:	74 49                	je     80107db0 <allocuvm_withswap+0x120>
      {
           kfree(P2V(evicted_pa));
      }
      else
      {
             refDec(P2V(evicted_pa));
80107d67:	83 ec 0c             	sub    $0xc,%esp
80107d6a:	56                   	push   %esi
80107d6b:	e8 10 b2 ff ff       	call   80102f80 <refDec>
80107d70:	83 c4 10             	add    $0x10,%esp
  

      *evicted_pte &= 0xFFF; // ???

      *evicted_pte |= PTE_PG;
      *evicted_pte &= ~PTE_P;
80107d73:	8b 07                	mov    (%edi),%eax
80107d75:	25 fe 0f 00 00       	and    $0xffe,%eax
80107d7a:	80 cc 02             	or     $0x2,%ah
80107d7d:	89 07                	mov    %eax,(%edi)
    

      struct page *newpage = &curproc->ramPages[evicted_ind];
      newpage->isused = 1;
      newpage->pgdir = pgdir; // ??? 
80107d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->isused = 1;
80107d82:	c7 83 a0 02 00 00 01 	movl   $0x1,0x2a0(%ebx)
80107d89:	00 00 00 
      newpage->pgdir = pgdir; // ??? 
80107d8c:	89 83 9c 02 00 00    	mov    %eax,0x29c(%ebx)
      newpage->swap_offset = -1;
      newpage->virt_addr = rounded_virtaddr;
80107d92:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->swap_offset = -1;
80107d95:	c7 83 a8 02 00 00 ff 	movl   $0xffffffff,0x2a8(%ebx)
80107d9c:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
80107d9f:	89 83 a4 02 00 00    	mov    %eax,0x2a4(%ebx)
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
     
}
80107da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107da8:	5b                   	pop    %ebx
80107da9:	5e                   	pop    %esi
80107daa:	5f                   	pop    %edi
80107dab:	5d                   	pop    %ebp
80107dac:	c3                   	ret    
80107dad:	8d 76 00             	lea    0x0(%esi),%esi
           kfree(P2V(evicted_pa));
80107db0:	83 ec 0c             	sub    $0xc,%esp
80107db3:	56                   	push   %esi
80107db4:	e8 07 ae ff ff       	call   80102bc0 <kfree>
80107db9:	83 c4 10             	add    $0x10,%esp
80107dbc:	eb b5                	jmp    80107d73 <allocuvm_withswap+0xe3>
80107dbe:	66 90                	xchg   %ax,%ax
        curproc->free_tail = 0;
80107dc0:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107dc7:	00 00 00 
        kfree((char*)curproc->free_head);
80107dca:	83 ec 0c             	sub    $0xc,%esp
80107dcd:	52                   	push   %edx
80107dce:	e8 ed ad ff ff       	call   80102bc0 <kfree>
        curproc->free_head = 0;
80107dd3:	83 c4 10             	add    $0x10,%esp
80107dd6:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107ddd:	00 00 00 
80107de0:	e9 ef fe ff ff       	jmp    80107cd4 <allocuvm_withswap+0x44>
        panic("page limit exceeded");
80107de5:	83 ec 0c             	sub    $0xc,%esp
80107de8:	68 e0 9c 10 80       	push   $0x80109ce0
80107ded:	e8 9e 85 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107df2:	83 ec 0c             	sub    $0xc,%esp
80107df5:	68 7c 9e 10 80       	push   $0x80109e7c
80107dfa:	e8 91 85 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107dff:	83 ec 0c             	sub    $0xc,%esp
80107e02:	68 f4 9c 10 80       	push   $0x80109cf4
80107e07:	e8 84 85 ff ff       	call   80100390 <panic>
80107e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e10 <allocuvm_paging>:
{
80107e10:	f3 0f 1e fb          	endbr32 
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	56                   	push   %esi
80107e18:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107e1b:	8b 75 0c             	mov    0xc(%ebp),%esi
80107e1e:	53                   	push   %ebx
80107e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107e22:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
80107e28:	83 fa 0f             	cmp    $0xf,%edx
80107e2b:	7f 33                	jg     80107e60 <allocuvm_paging+0x50>
  page->isused = 1;
80107e2d:	6b c2 1c             	imul   $0x1c,%edx,%eax
  curproc->num_ram++;
80107e30:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107e33:	01 c8                	add    %ecx,%eax
80107e35:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107e3c:	00 00 00 
  page->pgdir = pgdir;
80107e3f:	89 b0 48 02 00 00    	mov    %esi,0x248(%eax)
  page->swap_offset = -1;
80107e45:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107e4c:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107e4f:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107e55:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
}
80107e5b:	5b                   	pop    %ebx
80107e5c:	5e                   	pop    %esi
80107e5d:	5d                   	pop    %ebp
80107e5e:	c3                   	ret    
80107e5f:	90                   	nop
80107e60:	5b                   	pop    %ebx
80107e61:	5e                   	pop    %esi
80107e62:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107e63:	e9 28 fe ff ff       	jmp    80107c90 <allocuvm_withswap>
80107e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e6f:	90                   	nop

80107e70 <update_selectionfiled_allocuvm>:

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107e70:	f3 0f 1e fb          	endbr32 
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107e74:	c3                   	ret    
80107e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e80 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e80:	f3 0f 1e fb          	endbr32 
80107e84:	55                   	push   %ebp
80107e85:	89 e5                	mov    %esp,%ebp
80107e87:	57                   	push   %edi
80107e88:	56                   	push   %esi
80107e89:	53                   	push   %ebx
80107e8a:	83 ec 5c             	sub    $0x5c,%esp
80107e8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107e90:	e8 db c5 ff ff       	call   80104470 <myproc>
80107e95:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e9b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e9e:	0f 83 9b 00 00 00    	jae    80107f3f <deallocuvm+0xbf>
    return oldsz;

  a = PGROUNDUP(newsz);
80107ea4:	8b 45 10             	mov    0x10(%ebp),%eax
80107ea7:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ead:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107eb3:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107eb6:	77 64                	ja     80107f1c <deallocuvm+0x9c>
80107eb8:	e9 7f 00 00 00       	jmp    80107f3c <deallocuvm+0xbc>
80107ebd:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107ec0:	8b 18                	mov    (%eax),%ebx
80107ec2:	f6 c3 01             	test   $0x1,%bl
80107ec5:	74 4a                	je     80107f11 <deallocuvm+0x91>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107ec7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107ecd:	0f 84 b7 01 00 00    	je     8010808a <deallocuvm+0x20a>
        panic("kfree");
      char *v = P2V(pa);
      
      if(getRefs(v) == 1)
80107ed3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107ed6:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107edc:	89 45 a0             	mov    %eax,-0x60(%ebp)
      if(getRefs(v) == 1)
80107edf:	53                   	push   %ebx
80107ee0:	e8 7b b1 ff ff       	call   80103060 <getRefs>
80107ee5:	83 c4 10             	add    $0x10,%esp
80107ee8:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107eeb:	83 f8 01             	cmp    $0x1,%eax
80107eee:	74 60                	je     80107f50 <deallocuvm+0xd0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107ef0:	83 ec 0c             	sub    $0xc,%esp
80107ef3:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107ef6:	53                   	push   %ebx
80107ef7:	e8 84 b0 ff ff       	call   80102f80 <refDec>
      }

      if(curproc->pid >2)
80107efc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
        refDec(v);
80107eff:	83 c4 10             	add    $0x10,%esp
80107f02:	8b 55 a0             	mov    -0x60(%ebp),%edx
      if(curproc->pid >2)
80107f05:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107f09:	7f 5d                	jg     80107f68 <deallocuvm+0xe8>
          }
        }

      }
     
      *pte = 0;
80107f0b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107f11:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f17:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107f1a:	76 20                	jbe    80107f3c <deallocuvm+0xbc>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107f1c:	31 c9                	xor    %ecx,%ecx
80107f1e:	89 f2                	mov    %esi,%edx
80107f20:	89 f8                	mov    %edi,%eax
80107f22:	e8 a9 f7 ff ff       	call   801076d0 <walkpgdir>
    if(!pte)
80107f27:	85 c0                	test   %eax,%eax
80107f29:	75 95                	jne    80107ec0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107f2b:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107f31:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107f37:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107f3a:	77 e0                	ja     80107f1c <deallocuvm+0x9c>
    }
  }
  return newsz;
80107f3c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f42:	5b                   	pop    %ebx
80107f43:	5e                   	pop    %esi
80107f44:	5f                   	pop    %edi
80107f45:	5d                   	pop    %ebp
80107f46:	c3                   	ret    
80107f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f4e:	66 90                	xchg   %ax,%ax
        kfree(v);
80107f50:	83 ec 0c             	sub    $0xc,%esp
80107f53:	53                   	push   %ebx
80107f54:	e8 67 ac ff ff       	call   80102bc0 <kfree>
      if(curproc->pid >2)
80107f59:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107f5c:	83 c4 10             	add    $0x10,%esp
80107f5f:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107f62:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107f66:	7e a3                	jle    80107f0b <deallocuvm+0x8b>
80107f68:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107f6e:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107f71:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107f77:	89 fa                	mov    %edi,%edx
80107f79:	89 cf                	mov    %ecx,%edi
80107f7b:	eb 17                	jmp    80107f94 <deallocuvm+0x114>
80107f7d:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107f80:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107f83:	0f 84 b7 00 00 00    	je     80108040 <deallocuvm+0x1c0>
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107f89:	83 c3 1c             	add    $0x1c,%ebx
80107f8c:	39 fb                	cmp    %edi,%ebx
80107f8e:	0f 84 ec 00 00 00    	je     80108080 <deallocuvm+0x200>
          struct page p_ram = curproc->ramPages[i];
80107f94:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107f9a:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107f9d:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107fa3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107fa6:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107fac:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107faf:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
80107fb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107fb8:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107fbe:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107fc1:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107fc7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107fca:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107fd0:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107fd3:	8b 03                	mov    (%ebx),%eax
80107fd5:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107fd8:	8b 43 04             	mov    0x4(%ebx),%eax
80107fdb:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107fde:	8b 43 08             	mov    0x8(%ebx),%eax
80107fe1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107fe4:	8b 43 0c             	mov    0xc(%ebx),%eax
80107fe7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107fea:	8b 43 10             	mov    0x10(%ebx),%eax
80107fed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107ff0:	8b 43 14             	mov    0x14(%ebx),%eax
80107ff3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ff6:	8b 43 18             	mov    0x18(%ebx),%eax
80107ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107ffc:	39 75 b8             	cmp    %esi,-0x48(%ebp)
80107fff:	0f 85 7b ff ff ff    	jne    80107f80 <deallocuvm+0x100>
80108005:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80108008:	0f 85 72 ff ff ff    	jne    80107f80 <deallocuvm+0x100>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
8010800e:	83 ec 04             	sub    $0x4,%esp
80108011:	8d 45 b0             	lea    -0x50(%ebp),%eax
80108014:	89 55 08             	mov    %edx,0x8(%ebp)
80108017:	6a 1c                	push   $0x1c
80108019:	6a 00                	push   $0x0
8010801b:	50                   	push   %eax
8010801c:	e8 1f d5 ff ff       	call   80105540 <memset>
            curproc->num_ram -- ;
80108021:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108024:	8b 55 08             	mov    0x8(%ebp),%edx
80108027:	83 c4 10             	add    $0x10,%esp
8010802a:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80108031:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80108034:	0f 85 4f ff ff ff    	jne    80107f89 <deallocuvm+0x109>
8010803a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108040:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80108043:	0f 85 40 ff ff ff    	jne    80107f89 <deallocuvm+0x109>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80108049:	83 ec 04             	sub    $0x4,%esp
8010804c:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010804f:	89 55 08             	mov    %edx,0x8(%ebp)
80108052:	83 c3 1c             	add    $0x1c,%ebx
80108055:	6a 1c                	push   $0x1c
80108057:	6a 00                	push   $0x0
80108059:	50                   	push   %eax
8010805a:	e8 e1 d4 ff ff       	call   80105540 <memset>
            curproc->num_swap --;
8010805f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80108062:	8b 55 08             	mov    0x8(%ebp),%edx
80108065:	83 c4 10             	add    $0x10,%esp
80108068:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
8010806f:	39 fb                	cmp    %edi,%ebx
80108071:	0f 85 1d ff ff ff    	jne    80107f94 <deallocuvm+0x114>
80108077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010807e:	66 90                	xchg   %ax,%ax
80108080:	89 d7                	mov    %edx,%edi
80108082:	8b 55 a0             	mov    -0x60(%ebp),%edx
80108085:	e9 81 fe ff ff       	jmp    80107f0b <deallocuvm+0x8b>
        panic("kfree");
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	68 9a 94 10 80       	push   $0x8010949a
80108092:	e8 f9 82 ff ff       	call   80100390 <panic>
80108097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010809e:	66 90                	xchg   %ax,%ax

801080a0 <allocuvm>:
{
801080a0:	f3 0f 1e fb          	endbr32 
801080a4:	55                   	push   %ebp
801080a5:	89 e5                	mov    %esp,%ebp
801080a7:	57                   	push   %edi
801080a8:	56                   	push   %esi
801080a9:	53                   	push   %ebx
801080aa:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
801080ad:	e8 be c3 ff ff       	call   80104470 <myproc>
801080b2:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
801080b4:	8b 45 10             	mov    0x10(%ebp),%eax
801080b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801080ba:	85 c0                	test   %eax,%eax
801080bc:	0f 88 de 00 00 00    	js     801081a0 <allocuvm+0x100>
  if(newsz < oldsz)
801080c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801080c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801080c8:	0f 82 c2 00 00 00    	jb     80108190 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
801080ce:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801080d4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801080da:	39 75 10             	cmp    %esi,0x10(%ebp)
801080dd:	77 45                	ja     80108124 <allocuvm+0x84>
801080df:	e9 af 00 00 00       	jmp    80108193 <allocuvm+0xf3>
801080e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  page->isused = 1;
801080e8:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
801080eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
801080ee:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
801080f1:	01 f8                	add    %edi,%eax
801080f3:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
801080fa:	00 00 00 
  page->pgdir = pgdir;
801080fd:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
80108103:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
8010810a:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
8010810d:	89 b0 50 02 00 00    	mov    %esi,0x250(%eax)
  curproc->num_ram++;
80108113:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
80108119:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010811f:	39 75 10             	cmp    %esi,0x10(%ebp)
80108122:	76 6f                	jbe    80108193 <allocuvm+0xf3>
    mem = kalloc();
80108124:	e8 97 ad ff ff       	call   80102ec0 <kalloc>
80108129:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010812b:	85 c0                	test   %eax,%eax
8010812d:	0f 84 85 00 00 00    	je     801081b8 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
80108133:	83 ec 04             	sub    $0x4,%esp
80108136:	68 00 10 00 00       	push   $0x1000
8010813b:	6a 00                	push   $0x0
8010813d:	50                   	push   %eax
8010813e:	e8 fd d3 ff ff       	call   80105540 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108143:	58                   	pop    %eax
80108144:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010814a:	5a                   	pop    %edx
8010814b:	6a 06                	push   $0x6
8010814d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108152:	89 f2                	mov    %esi,%edx
80108154:	50                   	push   %eax
80108155:	8b 45 08             	mov    0x8(%ebp),%eax
80108158:	e8 f3 f5 ff ff       	call   80107750 <mappages>
8010815d:	83 c4 10             	add    $0x10,%esp
80108160:	85 c0                	test   %eax,%eax
80108162:	0f 88 88 00 00 00    	js     801081f0 <allocuvm+0x150>
    if(curproc->pid > 2) 
80108168:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010816c:	7e ab                	jle    80108119 <allocuvm+0x79>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
8010816e:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
80108174:	83 fa 0f             	cmp    $0xf,%edx
80108177:	0f 8e 6b ff ff ff    	jle    801080e8 <allocuvm+0x48>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
8010817d:	83 ec 04             	sub    $0x4,%esp
80108180:	56                   	push   %esi
80108181:	ff 75 08             	pushl  0x8(%ebp)
80108184:	57                   	push   %edi
80108185:	e8 06 fb ff ff       	call   80107c90 <allocuvm_withswap>
8010818a:	83 c4 10             	add    $0x10,%esp
8010818d:	eb 8a                	jmp    80108119 <allocuvm+0x79>
8010818f:	90                   	nop
    return oldsz;
80108190:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108199:	5b                   	pop    %ebx
8010819a:	5e                   	pop    %esi
8010819b:	5f                   	pop    %edi
8010819c:	5d                   	pop    %ebp
8010819d:	c3                   	ret    
8010819e:	66 90                	xchg   %ax,%ax
    return 0;
801081a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801081a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081ad:	5b                   	pop    %ebx
801081ae:	5e                   	pop    %esi
801081af:	5f                   	pop    %edi
801081b0:	5d                   	pop    %ebp
801081b1:	c3                   	ret    
801081b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
801081b8:	83 ec 0c             	sub    $0xc,%esp
801081bb:	68 0e 9d 10 80       	push   $0x80109d0e
801081c0:	e8 eb 84 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081c5:	83 c4 0c             	add    $0xc,%esp
801081c8:	ff 75 0c             	pushl  0xc(%ebp)
801081cb:	ff 75 10             	pushl  0x10(%ebp)
801081ce:	ff 75 08             	pushl  0x8(%ebp)
801081d1:	e8 aa fc ff ff       	call   80107e80 <deallocuvm>
      return 0;
801081d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801081dd:	83 c4 10             	add    $0x10,%esp
}
801081e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081e6:	5b                   	pop    %ebx
801081e7:	5e                   	pop    %esi
801081e8:	5f                   	pop    %edi
801081e9:	5d                   	pop    %ebp
801081ea:	c3                   	ret    
801081eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081ef:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
801081f0:	83 ec 0c             	sub    $0xc,%esp
801081f3:	68 26 9d 10 80       	push   $0x80109d26
801081f8:	e8 b3 84 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801081fd:	83 c4 0c             	add    $0xc,%esp
80108200:	ff 75 0c             	pushl  0xc(%ebp)
80108203:	ff 75 10             	pushl  0x10(%ebp)
80108206:	ff 75 08             	pushl  0x8(%ebp)
80108209:	e8 72 fc ff ff       	call   80107e80 <deallocuvm>
      kfree(mem);
8010820e:	89 1c 24             	mov    %ebx,(%esp)
80108211:	e8 aa a9 ff ff       	call   80102bc0 <kfree>
      return 0;
80108216:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010821d:	83 c4 10             	add    $0x10,%esp
}
80108220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108226:	5b                   	pop    %ebx
80108227:	5e                   	pop    %esi
80108228:	5f                   	pop    %edi
80108229:	5d                   	pop    %ebp
8010822a:	c3                   	ret    
8010822b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010822f:	90                   	nop

80108230 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108230:	f3 0f 1e fb          	endbr32 
80108234:	55                   	push   %ebp
80108235:	89 e5                	mov    %esp,%ebp
80108237:	57                   	push   %edi
80108238:	56                   	push   %esi
80108239:	53                   	push   %ebx
8010823a:	83 ec 1c             	sub    $0x1c,%esp
8010823d:	8b 45 08             	mov    0x8(%ebp),%eax
80108240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint i;

  if(pgdir == 0)
80108243:	85 c0                	test   %eax,%eax
80108245:	0f 84 83 00 00 00    	je     801082ce <freevm+0x9e>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
8010824b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010824e:	83 ec 04             	sub    $0x4,%esp
80108251:	6a 00                	push   $0x0
80108253:	68 00 00 00 80       	push   $0x80000000
80108258:	89 fb                	mov    %edi,%ebx
8010825a:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80108260:	57                   	push   %edi
80108261:	e8 1a fc ff ff       	call   80107e80 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108266:	83 c4 10             	add    $0x10,%esp
80108269:	eb 0c                	jmp    80108277 <freevm+0x47>
8010826b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010826f:	90                   	nop
80108270:	83 c3 04             	add    $0x4,%ebx
80108273:	39 de                	cmp    %ebx,%esi
80108275:	74 35                	je     801082ac <freevm+0x7c>
    if(pgdir[i] & PTE_P){
80108277:	8b 03                	mov    (%ebx),%eax
80108279:	a8 01                	test   $0x1,%al
8010827b:	74 f3                	je     80108270 <freevm+0x40>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010827d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(v) == 1)
80108282:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108285:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
      if(getRefs(v) == 1)
8010828b:	57                   	push   %edi
8010828c:	e8 cf ad ff ff       	call   80103060 <getRefs>
80108291:	83 c4 10             	add    $0x10,%esp
80108294:	83 f8 01             	cmp    $0x1,%eax
80108297:	74 27                	je     801082c0 <freevm+0x90>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80108299:	83 ec 0c             	sub    $0xc,%esp
8010829c:	83 c3 04             	add    $0x4,%ebx
8010829f:	57                   	push   %edi
801082a0:	e8 db ac ff ff       	call   80102f80 <refDec>
801082a5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801082a8:	39 de                	cmp    %ebx,%esi
801082aa:	75 cb                	jne    80108277 <freevm+0x47>
      }
    }
  }
  kfree((char*)pgdir);
801082ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801082b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082b5:	5b                   	pop    %ebx
801082b6:	5e                   	pop    %esi
801082b7:	5f                   	pop    %edi
801082b8:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801082b9:	e9 02 a9 ff ff       	jmp    80102bc0 <kfree>
801082be:	66 90                	xchg   %ax,%ax
        kfree(v);
801082c0:	83 ec 0c             	sub    $0xc,%esp
801082c3:	57                   	push   %edi
801082c4:	e8 f7 a8 ff ff       	call   80102bc0 <kfree>
801082c9:	83 c4 10             	add    $0x10,%esp
801082cc:	eb a2                	jmp    80108270 <freevm+0x40>
    panic("freevm: no pgdir");
801082ce:	83 ec 0c             	sub    $0xc,%esp
801082d1:	68 42 9d 10 80       	push   $0x80109d42
801082d6:	e8 b5 80 ff ff       	call   80100390 <panic>
801082db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082df:	90                   	nop

801082e0 <setupkvm>:
{
801082e0:	f3 0f 1e fb          	endbr32 
801082e4:	55                   	push   %ebp
801082e5:	89 e5                	mov    %esp,%ebp
801082e7:	56                   	push   %esi
801082e8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801082e9:	e8 d2 ab ff ff       	call   80102ec0 <kalloc>
801082ee:	89 c6                	mov    %eax,%esi
801082f0:	85 c0                	test   %eax,%eax
801082f2:	74 42                	je     80108336 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801082f4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082f7:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
801082fc:	68 00 10 00 00       	push   $0x1000
80108301:	6a 00                	push   $0x0
80108303:	50                   	push   %eax
80108304:	e8 37 d2 ff ff       	call   80105540 <memset>
80108309:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010830c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010830f:	83 ec 08             	sub    $0x8,%esp
80108312:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108315:	ff 73 0c             	pushl  0xc(%ebx)
80108318:	8b 13                	mov    (%ebx),%edx
8010831a:	50                   	push   %eax
8010831b:	29 c1                	sub    %eax,%ecx
8010831d:	89 f0                	mov    %esi,%eax
8010831f:	e8 2c f4 ff ff       	call   80107750 <mappages>
80108324:	83 c4 10             	add    $0x10,%esp
80108327:	85 c0                	test   %eax,%eax
80108329:	78 15                	js     80108340 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010832b:	83 c3 10             	add    $0x10,%ebx
8010832e:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
80108334:	75 d6                	jne    8010830c <setupkvm+0x2c>
}
80108336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108339:	89 f0                	mov    %esi,%eax
8010833b:	5b                   	pop    %ebx
8010833c:	5e                   	pop    %esi
8010833d:	5d                   	pop    %ebp
8010833e:	c3                   	ret    
8010833f:	90                   	nop
      cprintf("mappages failed on setupkvm");
80108340:	83 ec 0c             	sub    $0xc,%esp
80108343:	68 53 9d 10 80       	push   $0x80109d53
80108348:	e8 63 83 ff ff       	call   801006b0 <cprintf>
      freevm(pgdir);
8010834d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80108350:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108352:	e8 d9 fe ff ff       	call   80108230 <freevm>
      return 0;
80108357:	83 c4 10             	add    $0x10,%esp
}
8010835a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010835d:	89 f0                	mov    %esi,%eax
8010835f:	5b                   	pop    %ebx
80108360:	5e                   	pop    %esi
80108361:	5d                   	pop    %ebp
80108362:	c3                   	ret    
80108363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010836a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108370 <kvmalloc>:
{
80108370:	f3 0f 1e fb          	endbr32 
80108374:	55                   	push   %ebp
80108375:	89 e5                	mov    %esp,%ebp
80108377:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010837a:	e8 61 ff ff ff       	call   801082e0 <setupkvm>
8010837f:	a3 84 85 19 80       	mov    %eax,0x80198584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108384:	05 00 00 00 80       	add    $0x80000000,%eax
80108389:	0f 22 d8             	mov    %eax,%cr3
}
8010838c:	c9                   	leave  
8010838d:	c3                   	ret    
8010838e:	66 90                	xchg   %ax,%ax

80108390 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108390:	f3 0f 1e fb          	endbr32 
80108394:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108395:	31 c9                	xor    %ecx,%ecx
{
80108397:	89 e5                	mov    %esp,%ebp
80108399:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010839c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010839f:	8b 45 08             	mov    0x8(%ebp),%eax
801083a2:	e8 29 f3 ff ff       	call   801076d0 <walkpgdir>
  if(pte == 0)
801083a7:	85 c0                	test   %eax,%eax
801083a9:	74 05                	je     801083b0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801083ab:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801083ae:	c9                   	leave  
801083af:	c3                   	ret    
    panic("clearpteu");
801083b0:	83 ec 0c             	sub    $0xc,%esp
801083b3:	68 6f 9d 10 80       	push   $0x80109d6f
801083b8:	e8 d3 7f ff ff       	call   80100390 <panic>
801083bd:	8d 76 00             	lea    0x0(%esi),%esi

801083c0 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
801083c0:	f3 0f 1e fb          	endbr32 
801083c4:	55                   	push   %ebp
801083c5:	89 e5                	mov    %esp,%ebp
801083c7:	57                   	push   %edi
801083c8:	56                   	push   %esi
801083c9:	53                   	push   %ebx
801083ca:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
801083cd:	e8 0e ff ff ff       	call   801082e0 <setupkvm>
801083d2:	89 c7                	mov    %eax,%edi
801083d4:	85 c0                	test   %eax,%eax
801083d6:	0f 84 c7 00 00 00    	je     801084a3 <cowuvm+0xe3>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
801083dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801083df:	85 c0                	test   %eax,%eax
801083e1:	0f 84 b1 00 00 00    	je     80108498 <cowuvm+0xd8>
801083e7:	31 db                	xor    %ebx,%ebx
801083e9:	eb 5b                	jmp    80108446 <cowuvm+0x86>
801083eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083ef:	90                   	nop
      *pte = PTE_U | PTE_W | PTE_PG;
       continue;
    }
    
    *pte |= PTE_COW;
    *pte &= ~PTE_W;
801083f0:	89 d1                	mov    %edx,%ecx
801083f2:	89 d6                	mov    %edx,%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
801083f4:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801083fa:	83 ec 08             	sub    $0x8,%esp
    *pte &= ~PTE_W;
801083fd:	83 e1 fd             	and    $0xfffffffd,%ecx
    flags = PTE_FLAGS(*pte);
80108400:	80 ce 04             	or     $0x4,%dh
80108403:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    *pte &= ~PTE_W;
80108409:	80 cd 04             	or     $0x4,%ch
8010840c:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
8010840e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108413:	89 f8                	mov    %edi,%eax
80108415:	52                   	push   %edx
80108416:	89 da                	mov    %ebx,%edx
80108418:	56                   	push   %esi
80108419:	e8 32 f3 ff ff       	call   80107750 <mappages>
8010841e:	83 c4 10             	add    $0x10,%esp
80108421:	85 c0                	test   %eax,%eax
80108423:	0f 88 87 00 00 00    	js     801084b0 <cowuvm+0xf0>
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80108429:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
8010842c:	81 c6 00 00 00 80    	add    $0x80000000,%esi
  for(i = 0; i < sz; i += PGSIZE)
80108432:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    refInc(virt_addr);
80108438:	56                   	push   %esi
80108439:	e8 b2 ab ff ff       	call   80102ff0 <refInc>
8010843e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
80108441:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80108444:	76 52                	jbe    80108498 <cowuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108446:	8b 45 08             	mov    0x8(%ebp),%eax
80108449:	31 c9                	xor    %ecx,%ecx
8010844b:	89 da                	mov    %ebx,%edx
8010844d:	e8 7e f2 ff ff       	call   801076d0 <walkpgdir>
80108452:	85 c0                	test   %eax,%eax
80108454:	0f 84 92 00 00 00    	je     801084ec <cowuvm+0x12c>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
8010845a:	8b 10                	mov    (%eax),%edx
8010845c:	f7 c2 01 02 00 00    	test   $0x201,%edx
80108462:	74 7b                	je     801084df <cowuvm+0x11f>
    if(*pte & PTE_PG)  //there is pgfault, then not mark this entry as cow
80108464:	f6 c6 02             	test   $0x2,%dh
80108467:	74 87                	je     801083f0 <cowuvm+0x30>
      cprintf("cowuvm,  not marked as cow because pgfault \n");
80108469:	83 ec 0c             	sub    $0xc,%esp
8010846c:	68 d4 9e 10 80       	push   $0x80109ed4
80108471:	e8 3a 82 ff ff       	call   801006b0 <cprintf>
       pte = walkpgdir(d, (void*) i, 1);
80108476:	89 da                	mov    %ebx,%edx
80108478:	b9 01 00 00 00       	mov    $0x1,%ecx
8010847d:	89 f8                	mov    %edi,%eax
8010847f:	e8 4c f2 ff ff       	call   801076d0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE)
80108484:	81 c3 00 10 00 00    	add    $0x1000,%ebx
       continue;
8010848a:	83 c4 10             	add    $0x10,%esp
      *pte = PTE_U | PTE_W | PTE_PG;
8010848d:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE)
80108493:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80108496:	77 ae                	ja     80108446 <cowuvm+0x86>
    // lcr3(V2P(pgdir));
    // invlpg((void*)i); // flush TLB
  }
  lcr3(V2P(pgdir));
80108498:	8b 45 08             	mov    0x8(%ebp),%eax
8010849b:	05 00 00 00 80       	add    $0x80000000,%eax
801084a0:	0f 22 d8             	mov    %eax,%cr3
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
801084a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084a6:	89 f8                	mov    %edi,%eax
801084a8:	5b                   	pop    %ebx
801084a9:	5e                   	pop    %esi
801084aa:	5f                   	pop    %edi
801084ab:	5d                   	pop    %ebp
801084ac:	c3                   	ret    
801084ad:	8d 76 00             	lea    0x0(%esi),%esi
  cprintf("bad: cowuvm\n");
801084b0:	83 ec 0c             	sub    $0xc,%esp
801084b3:	68 88 9d 10 80       	push   $0x80109d88
801084b8:	e8 f3 81 ff ff       	call   801006b0 <cprintf>
  freevm(d);
801084bd:	89 3c 24             	mov    %edi,(%esp)
801084c0:	e8 6b fd ff ff       	call   80108230 <freevm>
  lcr3(V2P(pgdir));  // flush tlb
801084c5:	8b 45 08             	mov    0x8(%ebp),%eax
801084c8:	05 00 00 00 80       	add    $0x80000000,%eax
801084cd:	0f 22 d8             	mov    %eax,%cr3
  return 0;
801084d0:	31 ff                	xor    %edi,%edi
801084d2:	83 c4 10             	add    $0x10,%esp
}
801084d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084d8:	5b                   	pop    %ebx
801084d9:	89 f8                	mov    %edi,%eax
801084db:	5e                   	pop    %esi
801084dc:	5f                   	pop    %edi
801084dd:	5d                   	pop    %ebp
801084de:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
801084df:	83 ec 0c             	sub    $0xc,%esp
801084e2:	68 a4 9e 10 80       	push   $0x80109ea4
801084e7:	e8 a4 7e ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
801084ec:	83 ec 0c             	sub    $0xc,%esp
801084ef:	68 79 9d 10 80       	push   $0x80109d79
801084f4:	e8 97 7e ff ff       	call   80100390 <panic>
801084f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108500 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80108500:	f3 0f 1e fb          	endbr32 
80108504:	55                   	push   %ebp
80108505:	89 e5                	mov    %esp,%ebp
80108507:	53                   	push   %ebx
80108508:	83 ec 04             	sub    $0x4,%esp
8010850b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
8010850e:	e8 5d bf ff ff       	call   80104470 <myproc>
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108513:	31 d2                	xor    %edx,%edx
80108515:	05 90 00 00 00       	add    $0x90,%eax
8010851a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    if(curproc->swappedPages[i].virt_addr == va)
80108520:	39 18                	cmp    %ebx,(%eax)
80108522:	74 10                	je     80108534 <getSwappedPageIndex+0x34>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108524:	83 c2 01             	add    $0x1,%edx
80108527:	83 c0 1c             	add    $0x1c,%eax
8010852a:	83 fa 10             	cmp    $0x10,%edx
8010852d:	75 f1                	jne    80108520 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
8010852f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80108534:	83 c4 04             	add    $0x4,%esp
80108537:	89 d0                	mov    %edx,%eax
80108539:	5b                   	pop    %ebx
8010853a:	5d                   	pop    %ebp
8010853b:	c3                   	ret    
8010853c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108540 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80108540:	f3 0f 1e fb          	endbr32 
80108544:	55                   	push   %ebp
80108545:	89 e5                	mov    %esp,%ebp
80108547:	57                   	push   %edi
80108548:	56                   	push   %esi
80108549:	53                   	push   %ebx
8010854a:	83 ec 1c             	sub    $0x1c,%esp
8010854d:	8b 45 08             	mov    0x8(%ebp),%eax
80108550:	8b 75 0c             	mov    0xc(%ebp),%esi
80108553:	8b 55 10             	mov    0x10(%ebp),%edx
  uint err = curproc->tf->err;
80108556:	8b 48 18             	mov    0x18(%eax),%ecx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80108559:	f6 41 34 02          	testb  $0x2,0x34(%ecx)
8010855d:	74 07                	je     80108566 <handle_cow_pagefault+0x26>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
8010855f:	8b 1e                	mov    (%esi),%ebx
80108561:	f6 c7 04             	test   $0x4,%bh
80108564:	75 12                	jne    80108578 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80108566:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
8010856d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108570:	5b                   	pop    %ebx
80108571:	5e                   	pop    %esi
80108572:	5f                   	pop    %edi
80108573:	5d                   	pop    %ebp
80108574:	c3                   	ret    
80108575:	8d 76 00             	lea    0x0(%esi),%esi
      pa = PTE_ADDR(*pte);
80108578:	89 df                	mov    %ebx,%edi
      ref_count = getRefs(virt_addr);
8010857a:	83 ec 0c             	sub    $0xc,%esp
8010857d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80108580:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108586:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010858c:	57                   	push   %edi
8010858d:	e8 ce aa ff ff       	call   80103060 <getRefs>
      if (ref_count > 1) // more than one reference
80108592:	83 c4 10             	add    $0x10,%esp
80108595:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108598:	83 f8 01             	cmp    $0x1,%eax
8010859b:	7f 1b                	jg     801085b8 <handle_cow_pagefault+0x78>
        *pte &= ~PTE_COW; // turn COW off
8010859d:	8b 06                	mov    (%esi),%eax
8010859f:	80 e4 fb             	and    $0xfb,%ah
801085a2:	83 c8 02             	or     $0x2,%eax
801085a5:	89 06                	mov    %eax,(%esi)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801085a7:	0f 01 3a             	invlpg (%edx)
}
801085aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085ad:	5b                   	pop    %ebx
801085ae:	5e                   	pop    %esi
801085af:	5f                   	pop    %edi
801085b0:	5d                   	pop    %ebp
801085b1:	c3                   	ret    
801085b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801085b8:	89 55 e0             	mov    %edx,-0x20(%ebp)
      flags = PTE_FLAGS(*pte);
801085bb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        new_page = kalloc();
801085c1:	e8 fa a8 ff ff       	call   80102ec0 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
801085c6:	83 ec 04             	sub    $0x4,%esp
801085c9:	68 00 10 00 00       	push   $0x1000
801085ce:	57                   	push   %edi
801085cf:	50                   	push   %eax
801085d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801085d3:	e8 08 d0 ff ff       	call   801055e0 <memmove>
        new_pa = V2P(new_page);
801085d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801085db:	8b 55 e0             	mov    -0x20(%ebp),%edx
801085de:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801085e4:	09 cb                	or     %ecx,%ebx
801085e6:	83 cb 03             	or     $0x3,%ebx
801085e9:	89 1e                	mov    %ebx,(%esi)
801085eb:	0f 01 3a             	invlpg (%edx)
        refDec(virt_addr); // decrement old page's ref count
801085ee:	89 7d 08             	mov    %edi,0x8(%ebp)
801085f1:	83 c4 10             	add    $0x10,%esp
}
801085f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085f7:	5b                   	pop    %ebx
801085f8:	5e                   	pop    %esi
801085f9:	5f                   	pop    %edi
801085fa:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
801085fb:	e9 80 a9 ff ff       	jmp    80102f80 <refDec>

80108600 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
80108600:	f3 0f 1e fb          	endbr32 
80108604:	55                   	push   %ebp
80108605:	89 e5                	mov    %esp,%ebp
80108607:	57                   	push   %edi
80108608:	56                   	push   %esi
80108609:	53                   	push   %ebx
8010860a:	83 ec 20             	sub    $0x20,%esp
8010860d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80108610:	8b 7d 10             	mov    0x10(%ebp),%edi
80108613:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108616:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108619:	ff 73 10             	pushl  0x10(%ebx)
8010861c:	50                   	push   %eax
8010861d:	68 04 9f 10 80       	push   $0x80109f04
80108622:	e8 89 80 ff ff       	call   801006b0 <cprintf>

    new_page = kalloc();
80108627:	e8 94 a8 ff ff       	call   80102ec0 <kalloc>
8010862c:	89 c2                	mov    %eax,%edx
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
    *pte |= V2P(new_page);
8010862e:	8b 07                	mov    (%edi),%eax
80108630:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108636:	25 ff 0d 00 00       	and    $0xdff,%eax
8010863b:	09 d0                	or     %edx,%eax
8010863d:	83 c8 07             	or     $0x7,%eax
80108640:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108642:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
80108644:	e8 27 be ff ff       	call   80104470 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108649:	83 c4 10             	add    $0x10,%esp
8010864c:	05 90 00 00 00       	add    $0x90,%eax
80108651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->swappedPages[i].virt_addr == va)
80108658:	3b 30                	cmp    (%eax),%esi
8010865a:	0f 84 b8 01 00 00    	je     80108818 <handle_pagedout+0x218>
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108660:	83 c7 01             	add    $0x1,%edi
80108663:	83 c0 1c             	add    $0x1c,%eax
80108666:	83 ff 10             	cmp    $0x10,%edi
80108669:	75 ed                	jne    80108658 <handle_pagedout+0x58>
8010866b:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
80108670:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
80108675:	01 d8                	add    %ebx,%eax

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108677:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
8010867c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
8010867f:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108682:	01 d8                	add    %ebx,%eax
80108684:	ff b0 94 00 00 00    	pushl  0x94(%eax)
8010868a:	68 e0 d5 10 80       	push   $0x8010d5e0
8010868f:	53                   	push   %ebx
80108690:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108693:	e8 f8 a0 ff ff       	call   80102790 <readFromSwapFile>
80108698:	83 c4 10             	add    $0x10,%esp
8010869b:	85 c0                	test   %eax,%eax
8010869d:	0f 88 2b 02 00 00    	js     801088ce <handle_pagedout+0x2ce>
      panic("allocuvm: readFromSwapFile");

    struct fblock *new_block = (struct fblock*)kalloc();
801086a3:	e8 18 a8 ff ff       	call   80102ec0 <kalloc>
    new_block->off = swap_page->swap_offset;
801086a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801086ab:	8b 89 94 00 00 00    	mov    0x94(%ecx),%ecx
    new_block->next = 0;
801086b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
801086b8:	89 08                	mov    %ecx,(%eax)
    new_block->prev = curproc->free_tail;
801086ba:	8b 8b 18 04 00 00    	mov    0x418(%ebx),%ecx
801086c0:	89 48 08             	mov    %ecx,0x8(%eax)

    if(curproc->free_tail != 0)
801086c3:	85 c9                	test   %ecx,%ecx
801086c5:	0f 84 d5 01 00 00    	je     801088a0 <handle_pagedout+0x2a0>
      curproc->free_tail->next = new_block;
801086cb:	89 41 04             	mov    %eax,0x4(%ecx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
801086ce:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
801086d1:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
801086d7:	68 00 10 00 00       	push   $0x1000
801086dc:	68 e0 d5 10 80       	push   $0x8010d5e0
801086e1:	56                   	push   %esi
801086e2:	e8 f9 ce ff ff       	call   801055e0 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
801086e7:	83 c4 0c             	add    $0xc,%esp
801086ea:	6a 1c                	push   $0x1c
801086ec:	6a 00                	push   $0x0
801086ee:	ff 75 e4             	pushl  -0x1c(%ebp)
801086f1:	e8 4a ce ff ff       	call   80105540 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
801086f6:	83 c4 10             	add    $0x10,%esp
801086f9:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
80108700:	0f 8e 22 01 00 00    	jle    80108828 <handle_pagedout+0x228>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
80108706:	8b 8b 14 04 00 00    	mov    0x414(%ebx),%ecx
8010870c:	8b 01                	mov    (%ecx),%eax
8010870e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
80108711:	8b 41 04             	mov    0x4(%ecx),%eax
80108714:	85 c0                	test   %eax,%eax
80108716:	0f 84 d4 00 00 00    	je     801087f0 <handle_pagedout+0x1f0>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
8010871c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
8010871f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108725:	ff 70 08             	pushl  0x8(%eax)
80108728:	e8 93 a4 ff ff       	call   80102bc0 <kfree>
8010872d:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108730:	68 00 10 00 00       	push   $0x1000
80108735:	ff 75 e4             	pushl  -0x1c(%ebp)
80108738:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
8010873e:	53                   	push   %ebx
8010873f:	e8 1c a0 ff ff       	call   80102760 <writeToSwapFile>
80108744:	83 c4 10             	add    $0x10,%esp
80108747:	85 c0                	test   %eax,%eax
80108749:	0f 88 8c 01 00 00    	js     801088db <handle_pagedout+0x2db>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
8010874f:	6b d7 1c             	imul   $0x1c,%edi,%edx
80108752:	8b 83 a4 02 00 00    	mov    0x2a4(%ebx),%eax
80108758:	01 da                	add    %ebx,%edx
8010875a:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
      swap_page->pgdir = ram_page->pgdir;
80108760:	8b 8b 9c 02 00 00    	mov    0x29c(%ebx),%ecx
      swap_page->isused = 1;
80108766:	c7 82 8c 00 00 00 01 	movl   $0x1,0x8c(%edx)
8010876d:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80108770:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
      swap_page->swap_offset = swap_offset;
80108776:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108779:	89 8a 94 00 00 00    	mov    %ecx,0x94(%edx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
8010877f:	8b 7b 04             	mov    0x4(%ebx),%edi
80108782:	89 c2                	mov    %eax,%edx
80108784:	31 c9                	xor    %ecx,%ecx
80108786:	89 f8                	mov    %edi,%eax
80108788:	e8 43 ef ff ff       	call   801076d0 <walkpgdir>
8010878d:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
8010878f:	8b 00                	mov    (%eax),%eax
80108791:	a8 01                	test   $0x1,%al
80108793:	0f 84 28 01 00 00    	je     801088c1 <handle_pagedout+0x2c1>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
80108799:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      

       if(getRefs(P2V(ramPa)) == 1)
8010879e:	83 ec 0c             	sub    $0xc,%esp
801087a1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801087a7:	52                   	push   %edx
801087a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801087ab:	e8 b0 a8 ff ff       	call   80103060 <getRefs>
801087b0:	83 c4 10             	add    $0x10,%esp
801087b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801087b6:	83 f8 01             	cmp    $0x1,%eax
801087b9:	0f 84 f1 00 00 00    	je     801088b0 <handle_pagedout+0x2b0>
      {
           kfree(P2V(ramPa));
      }
      else
      {
           refDec(P2V(ramPa));
801087bf:	83 ec 0c             	sub    $0xc,%esp
801087c2:	52                   	push   %edx
801087c3:	e8 b8 a7 ff ff       	call   80102f80 <refDec>
801087c8:	83 c4 10             	add    $0x10,%esp
      
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
801087cb:	8b 07                	mov    (%edi),%eax
801087cd:	25 fe 0f 00 00       	and    $0xffe,%eax
801087d2:	80 cc 02             	or     $0x2,%ah
801087d5:	89 07                	mov    %eax,(%edi)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801087d7:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
801087da:	89 b3 a4 02 00 00    	mov    %esi,0x2a4(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801087e0:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801087e5:	0f 22 d8             	mov    %eax,%cr3
    }
    return;
}
801087e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087eb:	5b                   	pop    %ebx
801087ec:	5e                   	pop    %esi
801087ed:	5f                   	pop    %edi
801087ee:	5d                   	pop    %ebp
801087ef:	c3                   	ret    
        curproc->free_tail = 0;
801087f0:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
801087f7:	00 00 00 
        kfree((char*)curproc->free_head);
801087fa:	83 ec 0c             	sub    $0xc,%esp
801087fd:	51                   	push   %ecx
801087fe:	e8 bd a3 ff ff       	call   80102bc0 <kfree>
        curproc->free_head = 0;
80108803:	83 c4 10             	add    $0x10,%esp
80108806:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
8010880d:	00 00 00 
80108810:	e9 1b ff ff ff       	jmp    80108730 <handle_pagedout+0x130>
80108815:	8d 76 00             	lea    0x0(%esi),%esi
80108818:	6b c7 1c             	imul   $0x1c,%edi,%eax
8010881b:	05 88 00 00 00       	add    $0x88,%eax
80108820:	e9 50 fe ff ff       	jmp    80108675 <handle_pagedout+0x75>
80108825:	8d 76 00             	lea    0x0(%esi),%esi

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80108828:	e8 43 bc ff ff       	call   80104470 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
8010882d:	31 ff                	xor    %edi,%edi
8010882f:	05 4c 02 00 00       	add    $0x24c,%eax
80108834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108838:	8b 10                	mov    (%eax),%edx
8010883a:	85 d2                	test   %edx,%edx
8010883c:	74 10                	je     8010884e <handle_pagedout+0x24e>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
8010883e:	83 c7 01             	add    $0x1,%edi
80108841:	83 c0 1c             	add    $0x1c,%eax
80108844:	83 ff 10             	cmp    $0x10,%edi
80108847:	75 ef                	jne    80108838 <handle_pagedout+0x238>
      return i;
  }
  return -1;
80108849:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010884e:	83 ec 08             	sub    $0x8,%esp
80108851:	57                   	push   %edi
      curproc->ramPages[new_indx].virt_addr = start_page;
80108852:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
80108855:	68 b0 9d 10 80       	push   $0x80109db0
      curproc->ramPages[new_indx].virt_addr = start_page;
8010885a:	01 df                	add    %ebx,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010885c:	e8 4f 7e ff ff       	call   801006b0 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
80108861:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
80108867:	83 c4 10             	add    $0x10,%esp
8010886a:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
80108871:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108874:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108877:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
8010887e:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108881:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
80108887:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
8010888e:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108898:	5b                   	pop    %ebx
80108899:	5e                   	pop    %esi
8010889a:	5f                   	pop    %edi
8010889b:	5d                   	pop    %ebp
8010889c:	c3                   	ret    
8010889d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->free_head = new_block;
801088a0:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
801088a6:	e9 23 fe ff ff       	jmp    801086ce <handle_pagedout+0xce>
801088ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801088af:	90                   	nop
           kfree(P2V(ramPa));
801088b0:	83 ec 0c             	sub    $0xc,%esp
801088b3:	52                   	push   %edx
801088b4:	e8 07 a3 ff ff       	call   80102bc0 <kfree>
801088b9:	83 c4 10             	add    $0x10,%esp
801088bc:	e9 0a ff ff ff       	jmp    801087cb <handle_pagedout+0x1cb>
        panic("pagefault: ram page is not present");
801088c1:	83 ec 0c             	sub    $0xc,%esp
801088c4:	68 34 9f 10 80       	push   $0x80109f34
801088c9:	e8 c2 7a ff ff       	call   80100390 <panic>
      panic("allocuvm: readFromSwapFile");
801088ce:	83 ec 0c             	sub    $0xc,%esp
801088d1:	68 95 9d 10 80       	push   $0x80109d95
801088d6:	e8 b5 7a ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801088db:	83 ec 0c             	sub    $0xc,%esp
801088de:	68 f4 9c 10 80       	push   $0x80109cf4
801088e3:	e8 a8 7a ff ff       	call   80100390 <panic>
801088e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801088ef:	90                   	nop

801088f0 <pagefault>:
{
801088f0:	f3 0f 1e fb          	endbr32 
801088f4:	55                   	push   %ebp
801088f5:	89 e5                	mov    %esp,%ebp
801088f7:	57                   	push   %edi
801088f8:	56                   	push   %esi
801088f9:	53                   	push   %ebx
801088fa:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801088fd:	e8 6e bb ff ff       	call   80104470 <myproc>
80108902:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108904:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108907:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010890e:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108910:	8b 40 04             	mov    0x4(%eax),%eax
80108913:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108915:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
8010891b:	89 fa                	mov    %edi,%edx
8010891d:	e8 ae ed ff ff       	call   801076d0 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
80108922:	8b 10                	mov    (%eax),%edx
80108924:	81 e2 00 06 00 00    	and    $0x600,%edx
8010892a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80108930:	74 5e                	je     80108990 <pagefault+0xa0>
    if(va >= KERNBASE || pte == 0)
80108932:	85 f6                	test   %esi,%esi
80108934:	78 2a                	js     80108960 <pagefault+0x70>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108936:	8b 43 04             	mov    0x4(%ebx),%eax
80108939:	31 c9                	xor    %ecx,%ecx
8010893b:	89 f2                	mov    %esi,%edx
8010893d:	e8 8e ed ff ff       	call   801076d0 <walkpgdir>
80108942:	85 c0                	test   %eax,%eax
80108944:	74 60                	je     801089a6 <pagefault+0xb6>
    handle_cow_pagefault(curproc, pte, va);
80108946:	83 ec 04             	sub    $0x4,%esp
80108949:	56                   	push   %esi
8010894a:	50                   	push   %eax
8010894b:	53                   	push   %ebx
8010894c:	e8 ef fb ff ff       	call   80108540 <handle_cow_pagefault>
80108951:	83 c4 10             	add    $0x10,%esp
}
80108954:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108957:	5b                   	pop    %ebx
80108958:	5e                   	pop    %esi
80108959:	5f                   	pop    %edi
8010895a:	5d                   	pop    %ebp
8010895b:	c3                   	ret    
8010895c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108960:	83 ec 04             	sub    $0x4,%esp
80108963:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108966:	50                   	push   %eax
80108967:	ff 73 10             	pushl  0x10(%ebx)
8010896a:	68 58 9f 10 80       	push   $0x80109f58
8010896f:	e8 3c 7d ff ff       	call   801006b0 <cprintf>
      curproc->killed = 1;
80108974:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
8010897b:	83 c4 10             	add    $0x10,%esp
}
8010897e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108981:	5b                   	pop    %ebx
80108982:	5e                   	pop    %esi
80108983:	5f                   	pop    %edi
80108984:	5d                   	pop    %ebp
80108985:	c3                   	ret    
80108986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010898d:	8d 76 00             	lea    0x0(%esi),%esi
    handle_pagedout(curproc, start_page, pte);
80108990:	83 ec 04             	sub    $0x4,%esp
80108993:	50                   	push   %eax
80108994:	57                   	push   %edi
80108995:	53                   	push   %ebx
80108996:	e8 65 fc ff ff       	call   80108600 <handle_pagedout>
8010899b:	83 c4 10             	add    $0x10,%esp
}
8010899e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089a1:	5b                   	pop    %ebx
801089a2:	5e                   	pop    %esi
801089a3:	5f                   	pop    %edi
801089a4:	5d                   	pop    %ebp
801089a5:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
801089a6:	83 ec 0c             	sub    $0xc,%esp
801089a9:	68 c6 9d 10 80       	push   $0x80109dc6
801089ae:	e8 dd 79 ff ff       	call   80100390 <panic>
801089b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801089c0 <update_selectionfiled_pagefault>:
801089c0:	f3 0f 1e fb          	endbr32 
801089c4:	c3                   	ret    
801089c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801089d0 <copyuvm>:
{
801089d0:	f3 0f 1e fb          	endbr32 
801089d4:	55                   	push   %ebp
801089d5:	89 e5                	mov    %esp,%ebp
801089d7:	57                   	push   %edi
801089d8:	56                   	push   %esi
801089d9:	53                   	push   %ebx
801089da:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801089dd:	e8 fe f8 ff ff       	call   801082e0 <setupkvm>
801089e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801089e5:	85 c0                	test   %eax,%eax
801089e7:	0f 84 bb 00 00 00    	je     80108aa8 <copyuvm+0xd8>
  for(i = 0; i < sz; i += PGSIZE){
801089ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801089f0:	85 db                	test   %ebx,%ebx
801089f2:	0f 84 b0 00 00 00    	je     80108aa8 <copyuvm+0xd8>
801089f8:	31 f6                	xor    %esi,%esi
801089fa:	eb 65                	jmp    80108a61 <copyuvm+0x91>
801089fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
80108a00:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80108a02:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108a08:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108a0e:	e8 ad a4 ff ff       	call   80102ec0 <kalloc>
80108a13:	85 c0                	test   %eax,%eax
80108a15:	0f 84 ad 00 00 00    	je     80108ac8 <copyuvm+0xf8>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108a1b:	83 ec 04             	sub    $0x4,%esp
80108a1e:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108a27:	68 00 10 00 00       	push   $0x1000
80108a2c:	57                   	push   %edi
80108a2d:	50                   	push   %eax
80108a2e:	e8 ad cb ff ff       	call   801055e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108a33:	5a                   	pop    %edx
80108a34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a37:	59                   	pop    %ecx
80108a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a3b:	53                   	push   %ebx
80108a3c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108a41:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108a47:	52                   	push   %edx
80108a48:	89 f2                	mov    %esi,%edx
80108a4a:	e8 01 ed ff ff       	call   80107750 <mappages>
80108a4f:	83 c4 10             	add    $0x10,%esp
80108a52:	85 c0                	test   %eax,%eax
80108a54:	78 62                	js     80108ab8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108a56:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108a5c:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108a5f:	76 47                	jbe    80108aa8 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a61:	8b 45 08             	mov    0x8(%ebp),%eax
80108a64:	31 c9                	xor    %ecx,%ecx
80108a66:	89 f2                	mov    %esi,%edx
80108a68:	e8 63 ec ff ff       	call   801076d0 <walkpgdir>
80108a6d:	85 c0                	test   %eax,%eax
80108a6f:	0f 84 8b 00 00 00    	je     80108b00 <copyuvm+0x130>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108a75:	8b 18                	mov    (%eax),%ebx
80108a77:	f7 c3 01 02 00 00    	test   $0x201,%ebx
80108a7d:	74 74                	je     80108af3 <copyuvm+0x123>
    if (*pte & PTE_PG) {
80108a7f:	f6 c7 02             	test   $0x2,%bh
80108a82:	0f 84 78 ff ff ff    	je     80108a00 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a8b:	89 f2                	mov    %esi,%edx
80108a8d:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108a92:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108a98:	e8 33 ec ff ff       	call   801076d0 <walkpgdir>
      *pte = PTE_U | PTE_W | PTE_PG;
80108a9d:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108aa3:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108aa6:	77 b9                	ja     80108a61 <copyuvm+0x91>
}
80108aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108aae:	5b                   	pop    %ebx
80108aaf:	5e                   	pop    %esi
80108ab0:	5f                   	pop    %edi
80108ab1:	5d                   	pop    %ebp
80108ab2:	c3                   	ret    
80108ab3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108ab7:	90                   	nop
      cprintf("copyuvm: mappages failed\n");
80108ab8:	83 ec 0c             	sub    $0xc,%esp
80108abb:	68 f9 9d 10 80       	push   $0x80109df9
80108ac0:	e8 eb 7b ff ff       	call   801006b0 <cprintf>
      goto bad;
80108ac5:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
80108ac8:	83 ec 0c             	sub    $0xc,%esp
80108acb:	68 13 9e 10 80       	push   $0x80109e13
80108ad0:	e8 db 7b ff ff       	call   801006b0 <cprintf>
  freevm(d);
80108ad5:	58                   	pop    %eax
80108ad6:	ff 75 e0             	pushl  -0x20(%ebp)
80108ad9:	e8 52 f7 ff ff       	call   80108230 <freevm>
  return 0;
80108ade:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108ae5:	83 c4 10             	add    $0x10,%esp
}
80108ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108aee:	5b                   	pop    %ebx
80108aef:	5e                   	pop    %esi
80108af0:	5f                   	pop    %edi
80108af1:	5d                   	pop    %ebp
80108af2:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80108af3:	83 ec 0c             	sub    $0xc,%esp
80108af6:	68 8c 9f 10 80       	push   $0x80109f8c
80108afb:	e8 90 78 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108b00:	83 ec 0c             	sub    $0xc,%esp
80108b03:	68 df 9d 10 80       	push   $0x80109ddf
80108b08:	e8 83 78 ff ff       	call   80100390 <panic>
80108b0d:	8d 76 00             	lea    0x0(%esi),%esi

80108b10 <uva2ka>:
{
80108b10:	f3 0f 1e fb          	endbr32 
80108b14:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80108b15:	31 c9                	xor    %ecx,%ecx
{
80108b17:	89 e5                	mov    %esp,%ebp
80108b19:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b22:	e8 a9 eb ff ff       	call   801076d0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108b27:	8b 00                	mov    (%eax),%eax
}
80108b29:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108b2a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108b31:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108b34:	05 00 00 00 80       	add    $0x80000000,%eax
80108b39:	83 fa 05             	cmp    $0x5,%edx
80108b3c:	ba 00 00 00 00       	mov    $0x0,%edx
80108b41:	0f 45 c2             	cmovne %edx,%eax
}
80108b44:	c3                   	ret    
80108b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108b50 <copyout>:
{
80108b50:	f3 0f 1e fb          	endbr32 
80108b54:	55                   	push   %ebp
80108b55:	89 e5                	mov    %esp,%ebp
80108b57:	57                   	push   %edi
80108b58:	56                   	push   %esi
80108b59:	53                   	push   %ebx
80108b5a:	83 ec 0c             	sub    $0xc,%esp
80108b5d:	8b 75 14             	mov    0x14(%ebp),%esi
80108b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(len > 0){
80108b63:	85 f6                	test   %esi,%esi
80108b65:	75 3c                	jne    80108ba3 <copyout+0x53>
80108b67:	eb 67                	jmp    80108bd0 <copyout+0x80>
80108b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108b70:	8b 55 0c             	mov    0xc(%ebp),%edx
80108b73:	89 fb                	mov    %edi,%ebx
80108b75:	29 d3                	sub    %edx,%ebx
80108b77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80108b7d:	39 f3                	cmp    %esi,%ebx
80108b7f:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108b82:	29 fa                	sub    %edi,%edx
80108b84:	83 ec 04             	sub    $0x4,%esp
80108b87:	01 c2                	add    %eax,%edx
80108b89:	53                   	push   %ebx
80108b8a:	ff 75 10             	pushl  0x10(%ebp)
80108b8d:	52                   	push   %edx
80108b8e:	e8 4d ca ff ff       	call   801055e0 <memmove>
    buf += n;
80108b93:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108b96:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80108b9c:	83 c4 10             	add    $0x10,%esp
80108b9f:	29 de                	sub    %ebx,%esi
80108ba1:	74 2d                	je     80108bd0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108ba3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108ba5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108ba8:	89 55 0c             	mov    %edx,0xc(%ebp)
80108bab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108bb1:	57                   	push   %edi
80108bb2:	ff 75 08             	pushl  0x8(%ebp)
80108bb5:	e8 56 ff ff ff       	call   80108b10 <uva2ka>
    if(pa0 == 0)
80108bba:	83 c4 10             	add    $0x10,%esp
80108bbd:	85 c0                	test   %eax,%eax
80108bbf:	75 af                	jne    80108b70 <copyout+0x20>
}
80108bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108bc9:	5b                   	pop    %ebx
80108bca:	5e                   	pop    %esi
80108bcb:	5f                   	pop    %edi
80108bcc:	5d                   	pop    %ebp
80108bcd:	c3                   	ret    
80108bce:	66 90                	xchg   %ax,%ax
80108bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108bd3:	31 c0                	xor    %eax,%eax
}
80108bd5:	5b                   	pop    %ebx
80108bd6:	5e                   	pop    %esi
80108bd7:	5f                   	pop    %edi
80108bd8:	5d                   	pop    %ebp
80108bd9:	c3                   	ret    
80108bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108be0 <getNextFreeRamIndex>:
{ 
80108be0:	f3 0f 1e fb          	endbr32 
80108be4:	55                   	push   %ebp
80108be5:	89 e5                	mov    %esp,%ebp
80108be7:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80108bea:	e8 81 b8 ff ff       	call   80104470 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108bef:	31 d2                	xor    %edx,%edx
80108bf1:	05 4c 02 00 00       	add    $0x24c,%eax
80108bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108c00:	8b 08                	mov    (%eax),%ecx
80108c02:	85 c9                	test   %ecx,%ecx
80108c04:	74 10                	je     80108c16 <getNextFreeRamIndex+0x36>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108c06:	83 c2 01             	add    $0x1,%edx
80108c09:	83 c0 1c             	add    $0x1c,%eax
80108c0c:	83 fa 10             	cmp    $0x10,%edx
80108c0f:	75 ef                	jne    80108c00 <getNextFreeRamIndex+0x20>
  return -1;
80108c11:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80108c16:	c9                   	leave  
80108c17:	89 d0                	mov    %edx,%eax
80108c19:	c3                   	ret    
80108c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108c20 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108c20:	f3 0f 1e fb          	endbr32 
80108c24:	55                   	push   %ebp
80108c25:	89 e5                	mov    %esp,%ebp
80108c27:	56                   	push   %esi
80108c28:	8b 75 08             	mov    0x8(%ebp),%esi
80108c2b:	53                   	push   %ebx
80108c2c:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108c32:	81 c6 08 04 00 00    	add    $0x408,%esi
80108c38:	eb 19                	jmp    80108c53 <updateLapa+0x33>
80108c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108c40:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108c46:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108c49:	83 20 df             	andl   $0xffffffdf,(%eax)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108c4c:	83 c3 1c             	add    $0x1c,%ebx
80108c4f:	39 f3                	cmp    %esi,%ebx
80108c51:	74 2b                	je     80108c7e <updateLapa+0x5e>
    if(!cur_page->isused)
80108c53:	8b 43 04             	mov    0x4(%ebx),%eax
80108c56:	85 c0                	test   %eax,%eax
80108c58:	74 f2                	je     80108c4c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108c5a:	8b 53 08             	mov    0x8(%ebx),%edx
80108c5d:	8b 03                	mov    (%ebx),%eax
80108c5f:	31 c9                	xor    %ecx,%ecx
80108c61:	e8 6a ea ff ff       	call   801076d0 <walkpgdir>
80108c66:	85 c0                	test   %eax,%eax
80108c68:	74 1b                	je     80108c85 <updateLapa+0x65>
    if(*pte & PTE_A) // if accessed
80108c6a:	8b 53 18             	mov    0x18(%ebx),%edx
80108c6d:	d1 ea                	shr    %edx
80108c6f:	f6 00 20             	testb  $0x20,(%eax)
80108c72:	75 cc                	jne    80108c40 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
80108c74:	89 53 18             	mov    %edx,0x18(%ebx)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108c77:	83 c3 1c             	add    $0x1c,%ebx
80108c7a:	39 f3                	cmp    %esi,%ebx
80108c7c:	75 d5                	jne    80108c53 <updateLapa+0x33>
    }
  }
}
80108c7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108c81:	5b                   	pop    %ebx
80108c82:	5e                   	pop    %esi
80108c83:	5d                   	pop    %ebp
80108c84:	c3                   	ret    
      panic("updateLapa: no pte");
80108c85:	83 ec 0c             	sub    $0xc,%esp
80108c88:	68 21 9e 10 80       	push   $0x80109e21
80108c8d:	e8 fe 76 ff ff       	call   80100390 <panic>
80108c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108ca0 <updateNfua>:

void updateNfua(struct proc* p)
{
80108ca0:	f3 0f 1e fb          	endbr32 
80108ca4:	55                   	push   %ebp
80108ca5:	89 e5                	mov    %esp,%ebp
80108ca7:	56                   	push   %esi
80108ca8:	8b 75 08             	mov    0x8(%ebp),%esi
80108cab:	53                   	push   %ebx
80108cac:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108cb2:	81 c6 08 04 00 00    	add    $0x408,%esi
80108cb8:	eb 19                	jmp    80108cd3 <updateNfua+0x33>
80108cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108cc0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108cc6:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108cc9:	83 20 df             	andl   $0xffffffdf,(%eax)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108ccc:	83 c3 1c             	add    $0x1c,%ebx
80108ccf:	39 f3                	cmp    %esi,%ebx
80108cd1:	74 2b                	je     80108cfe <updateNfua+0x5e>
    if(!cur_page->isused)
80108cd3:	8b 43 04             	mov    0x4(%ebx),%eax
80108cd6:	85 c0                	test   %eax,%eax
80108cd8:	74 f2                	je     80108ccc <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108cda:	8b 53 08             	mov    0x8(%ebx),%edx
80108cdd:	8b 03                	mov    (%ebx),%eax
80108cdf:	31 c9                	xor    %ecx,%ecx
80108ce1:	e8 ea e9 ff ff       	call   801076d0 <walkpgdir>
80108ce6:	85 c0                	test   %eax,%eax
80108ce8:	74 1b                	je     80108d05 <updateNfua+0x65>
    if(*pte & PTE_A) // if accessed
80108cea:	8b 53 14             	mov    0x14(%ebx),%edx
80108ced:	d1 ea                	shr    %edx
80108cef:	f6 00 20             	testb  $0x20,(%eax)
80108cf2:	75 cc                	jne    80108cc0 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108cf4:	89 53 14             	mov    %edx,0x14(%ebx)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108cf7:	83 c3 1c             	add    $0x1c,%ebx
80108cfa:	39 f3                	cmp    %esi,%ebx
80108cfc:	75 d5                	jne    80108cd3 <updateNfua+0x33>
    }
  }
}
80108cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108d01:	5b                   	pop    %ebx
80108d02:	5e                   	pop    %esi
80108d03:	5d                   	pop    %ebp
80108d04:	c3                   	ret    
      panic("updateNfua: no pte");
80108d05:	83 ec 0c             	sub    $0xc,%esp
80108d08:	68 34 9e 10 80       	push   $0x80109e34
80108d0d:	e8 7e 76 ff ff       	call   80100390 <panic>
80108d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108d20 <indexToEvict>:
uint indexToEvict()
{  
80108d20:	f3 0f 1e fb          	endbr32 
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
80108d24:	b8 03 00 00 00       	mov    $0x3,%eax
80108d29:	c3                   	ret    
80108d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108d30 <aq>:

uint aq()
{
80108d30:	f3 0f 1e fb          	endbr32 
80108d34:	55                   	push   %ebp
80108d35:	89 e5                	mov    %esp,%ebp
80108d37:	57                   	push   %edi
80108d38:	56                   	push   %esi
80108d39:	53                   	push   %ebx
80108d3a:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108d3d:	e8 2e b7 ff ff       	call   80104470 <myproc>
80108d42:	89 c3                	mov    %eax,%ebx
  int res = curproc->queue_tail->page_index;
80108d44:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108d4a:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
  int res = curproc->queue_tail->page_index;
80108d50:	8b 78 08             	mov    0x8(%eax),%edi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108d53:	85 d2                	test   %edx,%edx
80108d55:	74 47                	je     80108d9e <aq+0x6e>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108d57:	39 d0                	cmp    %edx,%eax
80108d59:	74 35                	je     80108d90 <aq+0x60>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108d5b:	8b 40 04             	mov    0x4(%eax),%eax
80108d5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108d64:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80108d6a:	8b 70 04             	mov    0x4(%eax),%esi
  }

  kfree((char*)curproc->queue_tail);
80108d6d:	83 ec 0c             	sub    $0xc,%esp
80108d70:	50                   	push   %eax
80108d71:	e8 4a 9e ff ff       	call   80102bc0 <kfree>
  curproc->queue_tail = new_tail;
80108d76:	89 b3 20 04 00 00    	mov    %esi,0x420(%ebx)
  
  return  res;


}
80108d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d7f:	89 f8                	mov    %edi,%eax
80108d81:	5b                   	pop    %ebx
80108d82:	5e                   	pop    %esi
80108d83:	5f                   	pop    %edi
80108d84:	5d                   	pop    %ebp
80108d85:	c3                   	ret    
80108d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108d8d:	8d 76 00             	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108d90:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80108d97:	00 00 00 
    new_tail = 0;
80108d9a:	31 f6                	xor    %esi,%esi
80108d9c:	eb cf                	jmp    80108d6d <aq+0x3d>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108d9e:	83 ec 0c             	sub    $0xc,%esp
80108da1:	68 c8 9f 10 80       	push   $0x80109fc8
80108da6:	e8 e5 75 ff ff       	call   80100390 <panic>
80108dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108daf:	90                   	nop

80108db0 <lapa>:
uint lapa()
{
80108db0:	f3 0f 1e fb          	endbr32 
80108db4:	55                   	push   %ebp
80108db5:	89 e5                	mov    %esp,%ebp
80108db7:	57                   	push   %edi
80108db8:	56                   	push   %esi
80108db9:	53                   	push   %ebx
80108dba:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108dbd:	e8 ae b6 ff ff       	call   80104470 <myproc>
80108dc2:	89 c1                	mov    %eax,%ecx
  struct page *ramPages = curproc->ramPages;
80108dc4:	05 48 02 00 00       	add    $0x248,%eax
80108dc9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108dcc:	8b 81 60 02 00 00    	mov    0x260(%ecx),%eax
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108dd2:	85 c0                	test   %eax,%eax
80108dd4:	0f 84 df 00 00 00    	je     80108eb9 <lapa+0x109>
    uint count = 0;
80108dda:	31 d2                	xor    %edx,%edx
80108ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108de0:	89 c3                	mov    %eax,%ebx
80108de2:	83 e3 01             	and    $0x1,%ebx
80108de5:	01 da                	add    %ebx,%edx
    while (n) {
80108de7:	d1 e8                	shr    %eax
80108de9:	75 f5                	jne    80108de0 <lapa+0x30>
80108deb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108dee:	8d 81 7c 02 00 00    	lea    0x27c(%ecx),%eax
  uint minloc = 0;
80108df4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  uint instances = 0;
80108dfb:	31 ff                	xor    %edi,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108dfd:	bb 01 00 00 00       	mov    $0x1,%ebx
80108e02:	89 45 dc             	mov    %eax,-0x24(%ebp)
    uint count = 0;
80108e05:	89 c6                	mov    %eax,%esi
80108e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e0e:	66 90                	xchg   %ax,%ax
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108e10:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108e12:	31 d2                	xor    %edx,%edx
    while (n) {
80108e14:	85 c0                	test   %eax,%eax
80108e16:	74 13                	je     80108e2b <lapa+0x7b>
80108e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e1f:	90                   	nop
        count += n & 1;
80108e20:	89 c1                	mov    %eax,%ecx
80108e22:	83 e1 01             	and    $0x1,%ecx
80108e25:	01 ca                	add    %ecx,%edx
    while (n) {
80108e27:	d1 e8                	shr    %eax
80108e29:	75 f5                	jne    80108e20 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108e2b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108e2e:	72 78                	jb     80108ea8 <lapa+0xf8>
      instances++;
80108e30:	0f 94 c0             	sete   %al
80108e33:	0f b6 c0             	movzbl %al,%eax
80108e36:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108e38:	83 c3 01             	add    $0x1,%ebx
80108e3b:	83 c6 1c             	add    $0x1c,%esi
80108e3e:	83 fb 10             	cmp    $0x10,%ebx
80108e41:	75 cd                	jne    80108e10 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108e43:	83 ff 01             	cmp    $0x1,%edi
80108e46:	76 52                	jbe    80108e9a <lapa+0xea>
      uint minvalue = ramPages[minloc].lapa_counter;
80108e48:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108e4c:	8b 7d d8             	mov    -0x28(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108e4f:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108e54:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e5f:	90                   	nop
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108e63:	8b 18                	mov    (%eax),%ebx
    while (n) {
80108e65:	85 db                	test   %ebx,%ebx
80108e67:	74 4c                	je     80108eb5 <lapa+0x105>
80108e69:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108e6b:	31 d2                	xor    %edx,%edx
80108e6d:	8d 76 00             	lea    0x0(%esi),%esi
        count += n & 1;
80108e70:	89 c1                	mov    %eax,%ecx
80108e72:	83 e1 01             	and    $0x1,%ecx
80108e75:	01 ca                	add    %ecx,%edx
    while (n) {
80108e77:	d1 e8                	shr    %eax
80108e79:	75 f5                	jne    80108e70 <lapa+0xc0>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108e7b:	39 fb                	cmp    %edi,%ebx
80108e7d:	73 0f                	jae    80108e8e <lapa+0xde>
80108e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e82:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108e85:	0f 44 fb             	cmove  %ebx,%edi
80108e88:	0f 44 c6             	cmove  %esi,%eax
80108e8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108e8e:	83 c6 01             	add    $0x1,%esi
80108e91:	83 45 dc 1c          	addl   $0x1c,-0x24(%ebp)
80108e95:	83 fe 10             	cmp    $0x10,%esi
80108e98:	75 c6                	jne    80108e60 <lapa+0xb0>
}
80108e9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e9d:	83 c4 1c             	add    $0x1c,%esp
80108ea0:	5b                   	pop    %ebx
80108ea1:	5e                   	pop    %esi
80108ea2:	5f                   	pop    %edi
80108ea3:	5d                   	pop    %ebp
80108ea4:	c3                   	ret    
80108ea5:	8d 76 00             	lea    0x0(%esi),%esi
      minloc = i;
80108ea8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
      instances = 1;
80108eab:	bf 01 00 00 00       	mov    $0x1,%edi
80108eb0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108eb3:	eb 83                	jmp    80108e38 <lapa+0x88>
    uint count = 0;
80108eb5:	31 d2                	xor    %edx,%edx
80108eb7:	eb c2                	jmp    80108e7b <lapa+0xcb>
80108eb9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108ec0:	e9 29 ff ff ff       	jmp    80108dee <lapa+0x3e>
80108ec5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108ed0 <nfua>:
{
80108ed0:	f3 0f 1e fb          	endbr32 
80108ed4:	55                   	push   %ebp
80108ed5:	89 e5                	mov    %esp,%ebp
80108ed7:	56                   	push   %esi
  uint minloc = 0;
80108ed8:	31 f6                	xor    %esi,%esi
{
80108eda:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108edb:	e8 90 b5 ff ff       	call   80104470 <myproc>
  uint minval = ramPages[0].nfua_counter;
80108ee0:	8b 98 5c 02 00 00    	mov    0x25c(%eax),%ebx
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108ee6:	8d 90 78 02 00 00    	lea    0x278(%eax),%edx
80108eec:	b8 01 00 00 00       	mov    $0x1,%eax
80108ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ramPages[i].nfua_counter < minval)
80108ef8:	8b 0a                	mov    (%edx),%ecx
80108efa:	39 d9                	cmp    %ebx,%ecx
80108efc:	73 04                	jae    80108f02 <nfua+0x32>
      minloc = i;
80108efe:	89 c6                	mov    %eax,%esi
    if(ramPages[i].nfua_counter < minval)
80108f00:	89 cb                	mov    %ecx,%ebx
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108f02:	83 c0 01             	add    $0x1,%eax
80108f05:	83 c2 1c             	add    $0x1c,%edx
80108f08:	83 f8 10             	cmp    $0x10,%eax
80108f0b:	75 eb                	jne    80108ef8 <nfua+0x28>
}
80108f0d:	89 f0                	mov    %esi,%eax
80108f0f:	5b                   	pop    %ebx
80108f10:	5e                   	pop    %esi
80108f11:	5d                   	pop    %ebp
80108f12:	c3                   	ret    
80108f13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108f20 <scfifo>:
{
80108f20:	f3 0f 1e fb          	endbr32 
80108f24:	55                   	push   %ebp
80108f25:	89 e5                	mov    %esp,%ebp
80108f27:	57                   	push   %edi
80108f28:	56                   	push   %esi
80108f29:	53                   	push   %ebx
80108f2a:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108f2d:	e8 3e b5 ff ff       	call   80104470 <myproc>
80108f32:	89 c7                	mov    %eax,%edi
80108f34:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108f3a:	89 c6                	mov    %eax,%esi
80108f3c:	83 f8 0f             	cmp    $0xf,%eax
80108f3f:	7f 6b                	jg     80108fac <scfifo+0x8c>
80108f41:	6b d8 1c             	imul   $0x1c,%eax,%ebx
80108f44:	01 fb                	add    %edi,%ebx
80108f46:	eb 18                	jmp    80108f60 <scfifo+0x40>
80108f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f4f:	90                   	nop
          *pte &= ~PTE_A; 
80108f50:	83 e2 df             	and    $0xffffffdf,%edx
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108f53:	83 c6 01             	add    $0x1,%esi
80108f56:	83 c3 1c             	add    $0x1c,%ebx
          *pte &= ~PTE_A; 
80108f59:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108f5b:	83 fe 10             	cmp    $0x10,%esi
80108f5e:	74 40                	je     80108fa0 <scfifo+0x80>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108f60:	8b 93 50 02 00 00    	mov    0x250(%ebx),%edx
80108f66:	8b 83 48 02 00 00    	mov    0x248(%ebx),%eax
80108f6c:	31 c9                	xor    %ecx,%ecx
80108f6e:	e8 5d e7 ff ff       	call   801076d0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108f73:	8b 10                	mov    (%eax),%edx
80108f75:	89 d1                	mov    %edx,%ecx
80108f77:	83 e1 20             	and    $0x20,%ecx
80108f7a:	75 d4                	jne    80108f50 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108f7c:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108f83:	74 03                	je     80108f88 <scfifo+0x68>
            curproc->clockHand = i + 1;
80108f85:	8d 4e 01             	lea    0x1(%esi),%ecx
          curproc->clockHand = j + 1;
80108f88:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108f8e:	83 c4 0c             	add    $0xc,%esp
80108f91:	89 f0                	mov    %esi,%eax
80108f93:	5b                   	pop    %ebx
80108f94:	5e                   	pop    %esi
80108f95:	5f                   	pop    %edi
80108f96:	5d                   	pop    %ebp
80108f97:	c3                   	ret    
80108f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108f9f:	90                   	nop
80108fa0:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108fa6:	31 f6                	xor    %esi,%esi
    for(j=0; j< curproc->clockHand ;j++)
80108fa8:	85 c0                	test   %eax,%eax
80108faa:	74 95                	je     80108f41 <scfifo+0x21>
80108fac:	8d 9f 48 02 00 00    	lea    0x248(%edi),%ebx
80108fb2:	31 c9                	xor    %ecx,%ecx
80108fb4:	eb 20                	jmp    80108fd6 <scfifo+0xb6>
80108fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108fbd:	8d 76 00             	lea    0x0(%esi),%esi
          *pte &= ~PTE_A;  
80108fc0:	83 e2 df             	and    $0xffffffdf,%edx
80108fc3:	83 c3 1c             	add    $0x1c,%ebx
80108fc6:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108fc8:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108fce:	39 c1                	cmp    %eax,%ecx
80108fd0:	0f 83 64 ff ff ff    	jae    80108f3a <scfifo+0x1a>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108fd6:	8b 53 08             	mov    0x8(%ebx),%edx
80108fd9:	8b 03                	mov    (%ebx),%eax
80108fdb:	89 ce                	mov    %ecx,%esi
80108fdd:	31 c9                	xor    %ecx,%ecx
80108fdf:	e8 ec e6 ff ff       	call   801076d0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108fe4:	8d 4e 01             	lea    0x1(%esi),%ecx
80108fe7:	8b 10                	mov    (%eax),%edx
80108fe9:	f6 c2 20             	test   $0x20,%dl
80108fec:	75 d2                	jne    80108fc0 <scfifo+0xa0>
          curproc->clockHand = j + 1;
80108fee:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108ff4:	83 c4 0c             	add    $0xc,%esp
80108ff7:	89 f0                	mov    %esi,%eax
80108ff9:	5b                   	pop    %ebx
80108ffa:	5e                   	pop    %esi
80108ffb:	5f                   	pop    %edi
80108ffc:	5d                   	pop    %ebp
80108ffd:	c3                   	ret    
80108ffe:	66 90                	xchg   %ax,%ax

80109000 <countSetBits>:
{
80109000:	f3 0f 1e fb          	endbr32 
80109004:	55                   	push   %ebp
    uint count = 0;
80109005:	31 d2                	xor    %edx,%edx
{
80109007:	89 e5                	mov    %esp,%ebp
80109009:	8b 45 08             	mov    0x8(%ebp),%eax
    while (n) {
8010900c:	85 c0                	test   %eax,%eax
8010900e:	74 0b                	je     8010901b <countSetBits+0x1b>
        count += n & 1;
80109010:	89 c1                	mov    %eax,%ecx
80109012:	83 e1 01             	and    $0x1,%ecx
80109015:	01 ca                	add    %ecx,%edx
    while (n) {
80109017:	d1 e8                	shr    %eax
80109019:	75 f5                	jne    80109010 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
8010901b:	89 d0                	mov    %edx,%eax
8010901d:	5d                   	pop    %ebp
8010901e:	c3                   	ret    
8010901f:	90                   	nop

80109020 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80109020:	f3 0f 1e fb          	endbr32 
80109024:	55                   	push   %ebp
80109025:	89 e5                	mov    %esp,%ebp
80109027:	56                   	push   %esi
80109028:	53                   	push   %ebx
80109029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
8010902c:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
8010902f:	e8 3c b4 ff ff       	call   80104470 <myproc>
80109034:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
8010903a:	74 34                	je     80109070 <swapAQ+0x50>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
8010903c:	e8 2f b4 ff ff       	call   80104470 <myproc>
80109041:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80109047:	74 57                	je     801090a0 <swapAQ+0x80>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80109049:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
8010904c:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
8010904e:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80109050:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80109053:	85 d2                	test   %edx,%edx
80109055:	74 05                	je     8010905c <swapAQ+0x3c>
  {
    curr_node->prev = maybeLeft;
80109057:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
8010905a:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
8010905c:	85 c0                	test   %eax,%eax
8010905e:	74 05                	je     80109065 <swapAQ+0x45>
  {
    prev_node->next = maybeRight;
80109060:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80109062:	89 70 04             	mov    %esi,0x4(%eax)
  }
80109065:	5b                   	pop    %ebx
80109066:	5e                   	pop    %esi
80109067:	5d                   	pop    %ebp
80109068:	c3                   	ret    
80109069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_tail = prev_node;
80109070:	e8 fb b3 ff ff       	call   80104470 <myproc>
80109075:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
8010907b:	e8 f0 b3 ff ff       	call   80104470 <myproc>
80109080:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80109086:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
8010908c:	e8 df b3 ff ff       	call   80104470 <myproc>
80109091:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80109097:	75 b0                	jne    80109049 <swapAQ+0x29>
80109099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
801090a0:	e8 cb b3 ff ff       	call   80104470 <myproc>
801090a5:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
801090ab:	e8 c0 b3 ff ff       	call   80104470 <myproc>
801090b0:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
801090b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
801090bd:	eb 8a                	jmp    80109049 <swapAQ+0x29>
801090bf:	90                   	nop

801090c0 <updateAQ>:
{
801090c0:	f3 0f 1e fb          	endbr32 
801090c4:	55                   	push   %ebp
801090c5:	89 e5                	mov    %esp,%ebp
801090c7:	57                   	push   %edi
801090c8:	56                   	push   %esi
801090c9:	53                   	push   %ebx
801090ca:	83 ec 1c             	sub    $0x1c,%esp
801090cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
801090d0:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
801090d6:	85 d2                	test   %edx,%edx
801090d8:	0f 84 92 00 00 00    	je     80109170 <updateAQ+0xb0>
  struct queue_node *curr_node = p->queue_tail;
801090de:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
801090e4:	8b 56 04             	mov    0x4(%esi),%edx
801090e7:	85 d2                	test   %edx,%edx
801090e9:	0f 84 81 00 00 00    	je     80109170 <updateAQ+0xb0>
  prev_page = &ramPages[curr_node->prev->page_index];
801090ef:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *ramPages = p->ramPages;
801090f3:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  struct page *curr_page = &ramPages[curr_node->page_index];
801090f9:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
801090fd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80109100:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80109102:	01 d8                	add    %ebx,%eax
  while(curr_node != 0)
80109104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80109108:	8b 50 08             	mov    0x8(%eax),%edx
8010910b:	8b 00                	mov    (%eax),%eax
8010910d:	31 c9                	xor    %ecx,%ecx
8010910f:	e8 bc e5 ff ff       	call   801076d0 <walkpgdir>
80109114:	89 c3                	mov    %eax,%ebx
80109116:	85 c0                	test   %eax,%eax
80109118:	74 5e                	je     80109178 <updateAQ+0xb8>
    if(*pte_curr & PTE_A) // an accessed page
8010911a:	8b 00                	mov    (%eax),%eax
8010911c:	8b 56 04             	mov    0x4(%esi),%edx
8010911f:	a8 20                	test   $0x20,%al
80109121:	74 23                	je     80109146 <updateAQ+0x86>
      if(curr_node->prev != 0) // there is a page behind it
80109123:	85 d2                	test   %edx,%edx
80109125:	74 17                	je     8010913e <updateAQ+0x7e>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80109127:	8b 57 08             	mov    0x8(%edi),%edx
8010912a:	8b 07                	mov    (%edi),%eax
8010912c:	31 c9                	xor    %ecx,%ecx
8010912e:	e8 9d e5 ff ff       	call   801076d0 <walkpgdir>
80109133:	85 c0                	test   %eax,%eax
80109135:	74 41                	je     80109178 <updateAQ+0xb8>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80109137:	f6 00 20             	testb  $0x20,(%eax)
8010913a:	74 24                	je     80109160 <updateAQ+0xa0>
8010913c:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
8010913e:	83 e0 df             	and    $0xffffffdf,%eax
80109141:	89 03                	mov    %eax,(%ebx)
80109143:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80109146:	85 d2                	test   %edx,%edx
80109148:	74 26                	je     80109170 <updateAQ+0xb0>
      curr_page = &ramPages[curr_node->page_index];
8010914a:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
8010914e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80109151:	89 d6                	mov    %edx,%esi
80109153:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80109157:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80109159:	01 cf                	add    %ecx,%edi
  while(curr_node != 0)
8010915b:	eb ab                	jmp    80109108 <updateAQ+0x48>
8010915d:	8d 76 00             	lea    0x0(%esi),%esi
          swapAQ(curr_node);
80109160:	83 ec 0c             	sub    $0xc,%esp
80109163:	56                   	push   %esi
80109164:	e8 b7 fe ff ff       	call   80109020 <swapAQ>
80109169:	8b 03                	mov    (%ebx),%eax
8010916b:	83 c4 10             	add    $0x10,%esp
8010916e:	eb ce                	jmp    8010913e <updateAQ+0x7e>
}
80109170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109173:	5b                   	pop    %ebx
80109174:	5e                   	pop    %esi
80109175:	5f                   	pop    %edi
80109176:	5d                   	pop    %ebp
80109177:	c3                   	ret    
      panic("updateAQ: no pte");
80109178:	83 ec 0c             	sub    $0xc,%esp
8010917b:	68 47 9e 10 80       	push   $0x80109e47
80109180:	e8 0b 72 ff ff       	call   80100390 <panic>
