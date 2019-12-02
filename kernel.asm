
kernel：     文件格式 elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 80 bf 10 80       	mov    $0x8010bf80,%esp
8010002d:	b8 f0 2d 10 80       	mov    $0x80102df0,%eax
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
80100044:	bb b4 bf 10 80       	mov    $0x8010bfb4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 72 10 	movl   $0x80107220,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 80 bf 10 80 	movl   $0x8010bf80,(%esp)
8010005b:	e8 90 43 00 00       	call   801043f0 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba 7c 06 11 80       	mov    $0x8011067c,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 cc 06 11 80 7c 	movl   $0x8011067c,0x801106cc
8010006c:	06 11 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 d0 06 11 80 7c 	movl   $0x8011067c,0x801106d0
80100076:	06 11 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 7c 06 11 80 	movl   $0x8011067c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 72 10 	movl   $0x80107227,0x4(%esp)
8010009b:	80 
8010009c:	e8 1f 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 d0 06 11 80       	mov    0x801106d0,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d 7c 06 11 80       	cmp    $0x8011067c,%eax
    bcache.head.next = b;
801000b4:	89 1d d0 06 11 80    	mov    %ebx,0x801106d0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 80 bf 10 80 	movl   $0x8010bf80,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 75 44 00 00       	call   80104560 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d d0 06 11 80    	mov    0x801106d0,%ebx
801000f1:	81 fb 7c 06 11 80    	cmp    $0x8011067c,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 7c 06 11 80    	cmp    $0x8011067c,%ebx
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
80100120:	8b 1d cc 06 11 80    	mov    0x801106cc,%ebx
80100126:	81 fb 7c 06 11 80    	cmp    $0x8011067c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 7c 06 11 80    	cmp    $0x8011067c,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 80 bf 10 80 	movl   $0x8010bf80,(%esp)
80100161:	e8 6a 44 00 00       	call   801045d0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 8f 41 00 00       	call   80104300 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 72 10 80 	movl   $0x8010722e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 eb 41 00 00       	call   801043a0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 72 10 80 	movl   $0x8010723f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 aa 41 00 00       	call   801043a0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 5e 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 80 bf 10 80 	movl   $0x8010bf80,(%esp)
80100209:	e8 52 43 00 00       	call   80104560 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 d0 06 11 80       	mov    0x801106d0,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 7c 06 11 80 	movl   $0x8011067c,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 d0 06 11 80       	mov    0x801106d0,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d d0 06 11 80    	mov    %ebx,0x801106d0
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 80 bf 10 80 	movl   $0x8010bf80,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 7b 43 00 00       	jmp    801045d0 <release>
    panic("brelse");
80100255:	c7 04 24 46 72 10 80 	movl   $0x80107246,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

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
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 cd 42 00 00       	call   80104560 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 23 34 00 00       	call   801036d0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801002c3:	e8 78 3a 00 00       	call   80103d40 <sleep>
    while(input.r == input.w){
801002c8:	a1 60 09 11 80       	mov    0x80110960,%eax
801002cd:	3b 05 64 09 11 80    	cmp    0x80110964,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 60 09 11 80    	mov    %edx,0x80110960
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a e0 08 11 80 	movzbl -0x7feef720(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 ba 42 00 00       	call   801045d0 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 9c 42 00 00       	call   801045d0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 60 09 11 80       	mov    %eax,0x80110960
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 72 10 80 	movl   $0x8010724d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 e3 7c 10 80 	movl   $0x80107ce3,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 5c 40 00 00       	call   80104410 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 72 10 80 	movl   $0x80107261,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 b2 57 00 00       	call   80105bc0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 02 57 00 00       	call   80105bc0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 f6 56 00 00       	call   80105bc0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ea 56 00 00       	call   80105bc0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 bf 41 00 00       	call   801046c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 02 41 00 00       	call   80104620 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 72 10 80 	movl   $0x80107265,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 72 10 80 	movzbl -0x7fef8d70(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 4d 3f 00 00       	call   80104560 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 95 3f 00 00       	call   801045d0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 d8 3e 00 00       	call   801045d0 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 72 10 80       	mov    $0x80107278,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 c4 3d 00 00       	call   80104560 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 72 10 80 	movl   $0x8010727f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 96 3d 00 00       	call   80104560 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 68 09 11 80       	mov    0x80110968,%eax
801007f7:	3b 05 64 09 11 80    	cmp    0x80110964,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 68 09 11 80       	mov    %eax,0x80110968
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 a4 3d 00 00       	call   801045d0 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 68 09 11 80       	mov    0x80110968,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 60 09 11 80    	sub    0x80110960,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 68 09 11 80    	mov    %edx,0x80110968
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 e0 08 11 80    	mov    %cl,-0x7feef720(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 68 09 11 80       	mov    0x80110968,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d 60 09 11 80    	mov    0x80110960,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
          input.w = input.e;
801008ad:	a3 64 09 11 80       	mov    %eax,0x80110964
          wakeup(&input.r);
801008b2:	e8 29 36 00 00       	call   80103ee0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 68 09 11 80       	mov    0x80110968,%eax
801008c5:	3b 05 64 09 11 80    	cmp    0x80110964,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 68 09 11 80       	mov    %eax,0x80110968
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 68 09 11 80       	mov    0x80110968,%eax
801008ec:	3b 05 64 09 11 80    	cmp    0x80110964,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba e0 08 11 80 0a 	cmpb   $0xa,-0x7feef720(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 a4 36 00 00       	jmp    80103fd0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 e0 08 11 80 0a 	movb   $0xa,-0x7feef720(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 68 09 11 80       	mov    0x80110968,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 72 10 	movl   $0x80107288,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 86 3a 00 00       	call   801043f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 2c 13 11 80 f0 	movl   $0x801005f0,0x8011132c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 28 13 11 80 70 	movl   $0x80100270,0x80111328
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 1f 2d 00 00       	call   801036d0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 54 21 00 00       	call   80102b10 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
    end_op();
80100a08:	e8 73 21 00 00       	call   80102b80 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 7f 63 00 00       	call   80106db0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 49 61 00 00       	call   80106c20 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 48 60 00 00       	call   80106b60 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 02 62 00 00       	call   80106d30 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 3b 20 00 00       	call   80102b80 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 af 60 00 00       	call   80106c20 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 a7 61 00 00       	call   80106d30 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 e8 1f 00 00       	call   80102b80 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 a1 72 10 80 	movl   $0x801072a1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 93 62 00 00       	call   80106e60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 3a 3c 00 00       	call   80104840 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 29 3c 00 00       	call   80104840 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 8a 63 00 00       	call   80106fc0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 17 63 00 00       	call   80106fc0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 0a 3b 00 00       	call   80104800 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 ac 5c 00 00       	call   801069d0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 04 60 00 00       	call   80106d30 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ad 72 10 	movl   $0x801072ad,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100d65:	e8 86 36 00 00       	call   801043f0 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d7c:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100d83:	e8 d8 37 00 00       	call   80104560 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 14 13 11 80    	cmp    $0x80111314,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 1b 38 00 00       	call   801045d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dc0:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100dc7:	e8 04 38 00 00       	call   801045d0 <release>
}
80100dcc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100df1:	e8 6a 37 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100e0a:	e8 c1 37 00 00       	call   801045d0 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
    panic("filedup");
80100e17:	c7 04 24 b4 72 10 80 	movl   $0x801072b4,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80100e43:	e8 18 37 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e6b:	e9 60 37 00 00       	jmp    801045d0 <release>
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e85:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e8f:	e8 3c 37 00 00       	call   801045d0 <release>
  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 a8 23 00 00       	call   80103260 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ec0:	e8 4b 1c 00 00       	call   80102b10 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
    end_op();
80100ed7:	e9 a4 1c 00 00       	jmp    80102b80 <end_op>
    panic("fileclose");
80100edc:	c7 04 24 bc 72 10 80 	movl   $0x801072bc,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 a6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 14 0a 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 41 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 d7 09 00 00       	call   80101960 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fb5:	e9 26 24 00 00       	jmp    801033e0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
  panic("fileread");
80100fc7:	c7 04 24 c6 72 10 80 	movl   $0x801072c6,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
      end_op();
80101039:	e8 42 1b 00 00       	call   80102b80 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101063:	e8 a8 1a 00 00       	call   80102b10 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 3d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ce 09 00 00       	call   80101a60 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
      end_op();
801010a4:	e8 d7 1a 00 00       	call   80102b80 <end_op>
      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 0f 22 00 00       	jmp    801032f0 <pipewrite>
        panic("short filewrite");
801010e1:	c7 04 24 cf 72 10 80 	movl   $0x801072cf,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010ed:	c7 04 24 d5 72 10 80 	movl   $0x801072d5,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 d7                	mov    %edx,%edi
80101106:	56                   	push   %esi
80101107:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101108:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010110d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101110:	c1 ea 0c             	shr    $0xc,%edx
80101113:	03 15 98 13 11 80    	add    0x80111398,%edx
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101120:	e8 ab ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101125:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101127:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010112d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010112f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101132:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101135:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101137:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101139:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010113e:	0f b6 c8             	movzbl %al,%ecx
80101141:	85 d9                	test   %ebx,%ecx
80101143:	74 20                	je     80101165 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101145:	f7 d3                	not    %ebx
80101147:	21 c3                	and    %eax,%ebx
80101149:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010114d:	89 34 24             	mov    %esi,(%esp)
80101150:	e8 5b 1b 00 00       	call   80102cb0 <log_write>
  brelse(bp);
80101155:	89 34 24             	mov    %esi,(%esp)
80101158:	e8 83 f0 ff ff       	call   801001e0 <brelse>
}
8010115d:	83 c4 1c             	add    $0x1c,%esp
80101160:	5b                   	pop    %ebx
80101161:	5e                   	pop    %esi
80101162:	5f                   	pop    %edi
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    
    panic("freeing free block");
80101165:	c7 04 24 df 72 10 80 	movl   $0x801072df,(%esp)
8010116c:	e8 ef f1 ff ff       	call   80100360 <panic>
80101171:	eb 0d                	jmp    80101180 <balloc>
80101173:	90                   	nop
80101174:	90                   	nop
80101175:	90                   	nop
80101176:	90                   	nop
80101177:	90                   	nop
80101178:	90                   	nop
80101179:	90                   	nop
8010117a:	90                   	nop
8010117b:	90                   	nop
8010117c:	90                   	nop
8010117d:	90                   	nop
8010117e:	90                   	nop
8010117f:	90                   	nop

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 2c             	sub    $0x2c,%esp
80101189:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010118c:	a1 80 13 11 80       	mov    0x80111380,%eax
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 84 8c 00 00 00    	je     80101225 <balloc+0xa5>
80101199:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a3:	89 f0                	mov    %esi,%eax
801011a5:	c1 f8 0c             	sar    $0xc,%eax
801011a8:	03 05 98 13 11 80    	add    0x80111398,%eax
801011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801011b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 13 ef ff ff       	call   801000d0 <bread>
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	a1 80 13 11 80       	mov    0x80111380,%eax
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c8:	31 c0                	xor    %eax,%eax
801011ca:	eb 33                	jmp    801011ff <balloc+0x7f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011d5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	bf 01 00 00 00       	mov    $0x1,%edi
801011e2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011e9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011eb:	0f b6 fb             	movzbl %bl,%edi
801011ee:	85 cf                	test   %ecx,%edi
801011f0:	74 46                	je     80101238 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f2:	83 c0 01             	add    $0x1,%eax
801011f5:	83 c6 01             	add    $0x1,%esi
801011f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fd:	74 05                	je     80101204 <balloc+0x84>
801011ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101202:	72 cc                	jb     801011d0 <balloc+0x50>
    brelse(bp);
80101204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101207:	89 04 24             	mov    %eax,(%esp)
8010120a:	e8 d1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	3b 05 80 13 11 80    	cmp    0x80111380,%eax
8010121f:	0f 82 7b ff ff ff    	jb     801011a0 <balloc+0x20>
  panic("balloc: out of blocks");
80101225:	c7 04 24 f2 72 10 80 	movl   $0x801072f2,(%esp)
8010122c:	e8 2f f1 ff ff       	call   80100360 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101238:	09 d9                	or     %ebx,%ecx
8010123a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010123d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101241:	89 1c 24             	mov    %ebx,(%esp)
80101244:	e8 67 1a 00 00       	call   80102cb0 <log_write>
        brelse(bp);
80101249:	89 1c 24             	mov    %ebx,(%esp)
8010124c:	e8 8f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101251:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101254:	89 74 24 04          	mov    %esi,0x4(%esp)
80101258:	89 04 24             	mov    %eax,(%esp)
8010125b:	e8 70 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101260:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101267:	00 
80101268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010126f:	00 
  bp = bread(dev, bno);
80101270:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101272:	8d 40 5c             	lea    0x5c(%eax),%eax
80101275:	89 04 24             	mov    %eax,(%esp)
80101278:	e8 a3 33 00 00       	call   80104620 <memset>
  log_write(bp);
8010127d:	89 1c 24             	mov    %ebx,(%esp)
80101280:	e8 2b 1a 00 00       	call   80102cb0 <log_write>
  brelse(bp);
80101285:	89 1c 24             	mov    %ebx,(%esp)
80101288:	e8 53 ef ff ff       	call   801001e0 <brelse>
}
8010128d:	83 c4 2c             	add    $0x2c,%esp
80101290:	89 f0                	mov    %esi,%eax
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
80101297:	89 f6                	mov    %esi,%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a7:	31 f6                	xor    %esi,%esi
{
801012a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb d4 13 11 80       	mov    $0x801113d4,%ebx
{
801012af:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012b2:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
{
801012b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012bc:	e8 9f 32 00 00       	call   80104560 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c4:	eb 14                	jmp    801012da <iget+0x3a>
801012c6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c8:	85 f6                	test   %esi,%esi
801012ca:	74 3c                	je     80101308 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d2:	81 fb f4 2f 11 80    	cmp    $0x80112ff4,%ebx
801012d8:	74 46                	je     80101320 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012da:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	7e e7                	jle    801012c8 <iget+0x28>
801012e1:	39 3b                	cmp    %edi,(%ebx)
801012e3:	75 e3                	jne    801012c8 <iget+0x28>
801012e5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e8:	75 de                	jne    801012c8 <iget+0x28>
      ip->ref++;
801012ea:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012ed:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012ef:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
      ip->ref++;
801012f6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012f9:	e8 d2 32 00 00       	call   801045d0 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	89 f0                	mov    %esi,%eax
80101303:	5b                   	pop    %ebx
80101304:	5e                   	pop    %esi
80101305:	5f                   	pop    %edi
80101306:	5d                   	pop    %ebp
80101307:	c3                   	ret    
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb f4 2f 11 80    	cmp    $0x80112ff4,%ebx
80101319:	75 bf                	jne    801012da <iget+0x3a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 29                	je     8010134d <iget+0xad>
  ip->dev = dev;
80101324:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101326:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101329:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101330:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101337:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
8010133e:	e8 8d 32 00 00       	call   801045d0 <release>
}
80101343:	83 c4 1c             	add    $0x1c,%esp
80101346:	89 f0                	mov    %esi,%eax
80101348:	5b                   	pop    %ebx
80101349:	5e                   	pop    %esi
8010134a:	5f                   	pop    %edi
8010134b:	5d                   	pop    %ebp
8010134c:	c3                   	ret    
    panic("iget: no inodes");
8010134d:	c7 04 24 08 73 10 80 	movl   $0x80107308,(%esp)
80101354:	e8 07 f0 ff ff       	call   80100360 <panic>
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c3                	mov    %eax,%ebx
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 46 5c             	mov    0x5c(%esi),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 66                	je     801013e0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101388:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010138b:	83 fe 7f             	cmp    $0x7f,%esi
8010138e:	77 77                	ja     80101407 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101390:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013ac:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 19                	jne    801013cd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 c2 fd ff ff       	call   80101180 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 e3 18 00 00       	call   80102cb0 <log_write>
    brelse(bp);
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
}
801013d5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013d8:	89 f0                	mov    %esi,%eax
}
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 99 fd ff ff       	call   80101180 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 81 fd ff ff       	call   80101180 <balloc>
801013ff:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0x3a>
  panic("bmap: out of range");
80101407:	c7 04 24 18 73 10 80 	movl   $0x80107318,(%esp)
8010140e:	e8 4d ef ff ff       	call   80100360 <panic>
80101413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <readsb>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101432:	00 
{
80101433:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101448:	00 
  bp = bread(dev, 1);
80101449:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010144b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	e8 69 32 00 00       	call   801046c0 <memmove>
  brelse(bp);
80101457:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010145a:	83 c4 10             	add    $0x10,%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
  brelse(bp);
80101460:	e9 7b ed ff ff       	jmp    801001e0 <brelse>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb e0 13 11 80       	mov    $0x801113e0,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 2b 73 10 	movl   $0x8010732b,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
8010148b:	e8 60 2f 00 00       	call   801043f0 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 32 73 10 	movl   $0x80107332,0x4(%esp)
801014a0:	80 
801014a1:	e8 1a 2e 00 00       	call   801042c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 00 30 11 80    	cmp    $0x80113000,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 80 13 11 	movl   $0x80111380,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 5f ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 98 13 11 80       	mov    0x80111398,%eax
801014c6:	c7 04 24 98 73 10 80 	movl   $0x80107398,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 94 13 11 80       	mov    0x80111394,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 90 13 11 80       	mov    0x80111390,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 8c 13 11 80       	mov    0x8011138c,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 88 13 11 80       	mov    0x80111388,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 84 13 11 80       	mov    0x80111384,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 80 13 11 80       	mov    0x80111380,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d 88 13 11 80 01 	cmpl   $0x1,0x80111388
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d 88 13 11 80    	cmp    0x80111388,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 94 13 11 80    	add    0x80111394,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 72 30 00 00       	call   80104620 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 ea 16 00 00       	call   80102cb0 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
}
801015d6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
      return iget(dev, inum);
801015dc:	e9 bf fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
801015e1:	c7 04 24 38 73 10 80 	movl   $0x80107338,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 94 13 11 80    	add    0x80111394,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 5b 30 00 00       	call   801046c0 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 43 16 00 00       	call   80102cb0 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101691:	e8 ca 2e 00 00       	call   80104560 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
801016a1:	e8 2a 2f 00 00       	call   801045d0 <release>
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 27 2c 00 00       	call   80104300 <acquiresleep>
  if(ip->valid == 0){
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
}
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 94 13 11 80    	add    0x80111394,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 70 2f 00 00       	call   801046c0 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
      panic("ilock: no type");
8010176a:	c7 04 24 50 73 10 80 	movl   $0x80107350,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101776:	c7 04 24 4a 73 10 80 	movl   $0x8010734a,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 f6 2b 00 00       	call   801043a0 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017be:	e9 9d 2b 00 00       	jmp    80104360 <releasesleep>
    panic("iunlock");
801017c3:	c7 04 24 5f 73 10 80 	movl   $0x8010735f,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 19 2b 00 00       	call   80104300 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
  releasesleep(&ip->lock);
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 63 2b 00 00       	call   80104360 <releasesleep>
  acquire(&icache.lock);
801017fd:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101804:	e8 57 2d 00 00       	call   80104560 <acquire>
  ip->ref--;
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180d:	c7 45 08 a0 13 11 80 	movl   $0x801113a0,0x8(%ebp)
}
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
  release(&icache.lock);
8010181b:	e9 b0 2d 00 00       	jmp    801045d0 <release>
    acquire(&icache.lock);
80101820:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101827:	e8 34 2d 00 00       	call   80104560 <acquire>
    int r = ip->ref;
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010182f:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101836:	e8 95 2d 00 00       	call   801045d0 <release>
    if(r == 1){
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
    if(ip->addrs[i]){
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 9b f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
      ip->type = 0;
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018ae:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
      if(a[j])
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 1d f8 ff ff       	call   80101100 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
    brelse(bp);
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 00 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
  iput(ip);
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 99 f9 ff ff       	call   80101360 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019df:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ee:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 b3 2c 00 00       	call   801046c0 <memmove>
    brelse(bp);
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
  }
  return n;
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 20 13 11 80 	mov    -0x7feeece0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 94 f8 ff ff       	call   80101360 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 b7 2b 00 00       	call   801046c0 <memmove>
    log_write(bp);
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 9f 11 00 00       	call   80102cb0 <log_write>
    brelse(bp);
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 24 13 11 80 	mov    -0x7feeecdc(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 90 2b 00 00       	call   80104740 <strncmp>
}
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 12 2b 00 00       	call   80104740 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
        *poff = off;
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 57 f6 ff ff       	call   801012a0 <iget>
    }
  }

  return 0;
}
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c5b:	31 c0                	xor    %eax,%eax
}
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
      panic("dirlookup read");
80101c62:	c7 04 24 79 73 10 80 	movl   $0x80107379,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c6e:	c7 04 24 67 73 10 80 	movl   $0x80107367,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 32 1a 00 00       	call   801036d0 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ca1:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101ca8:	e8 b3 28 00 00       	call   80104560 <acquire>
  ip->ref++;
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb1:	c7 04 24 a0 13 11 80 	movl   $0x801113a0,(%esp)
80101cb8:	e8 13 29 00 00       	call   801045d0 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
    path++;
80101cf2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 a0 29 00 00       	call   801046c0 <memmove>
    path++;
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>
  iunlock(ip);
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 12 29 00 00       	call   801046c0 <memmove>
    name[len] = 0;
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
  }
  if(nameiparent){
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    
  iunlock(ip);
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
}
80101de0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101de3:	31 c0                	xor    %eax,%eax
}
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 a7 f4 ff ff       	call   801012a0 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
      iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
}
80101e08:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e0b:	89 f0                	mov    %esi,%eax
}
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
    iput(ip);
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
    if(de.inum == 0)
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 08 29 00 00       	call   801047b0 <strncpy>
  de.inum = inum;
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
  return 0;
80101ecc:	31 c0                	xor    %eax,%eax
}
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
    iput(ip);
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
    return -1;
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
      panic("dirlink read");
80101ee5:	c7 04 24 88 73 10 80 	movl   $0x80107388,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101ef1:	c7 04 24 ca 7a 10 80 	movl   $0x80107aca,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
    panic("incorrect blockno");
80101fdf:	c7 04 24 f4 73 10 80 	movl   $0x801073f4,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101feb:	c7 04 24 eb 73 10 80 	movl   $0x801073eb,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102006:	c7 44 24 04 06 74 10 	movl   $0x80107406,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102015:	e8 d6 23 00 00       	call   801043f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010201a:	a1 c0 36 11 80       	mov    0x801136c0,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
      havedisk1 = 1;
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 cb 24 00 00       	call   80104560 <acquire>

  if((b = idequeue) == 0){
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 1f 1e 00 00       	call   80103ee0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
    idestart(idequeue);
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 f5 24 00 00       	call   801045d0 <release>

  release(&idelock);
}
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 6b 22 00 00       	call   801043a0 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 f5 23 00 00       	call   80104560 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010218c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
    sleep(b, &idelock);
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 90 1b 00 00       	call   80103d40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
  }


  release(&idelock);
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
  release(&idelock);
801021c6:	e9 05 24 00 00       	jmp    801045d0 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
    idestart(b);
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
    panic("iderw: buf not locked");
801021db:	c7 04 24 0a 74 10 80 	movl   $0x8010740a,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021e7:	c7 04 24 35 74 10 80 	movl   $0x80107435,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801021f3:	c7 04 24 20 74 10 80 	movl   $0x80107420,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102208:	c7 05 f4 2f 11 80 00 	movl   $0xfec00000,0x80112ff4
8010220f:	00 c0 fe 
  ioapic->reg = reg;
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
  return ioapic->data;
8010221c:	8b 15 f4 2f 11 80    	mov    0x80112ff4,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010222b:	8b 1d f4 2f 11 80    	mov    0x80112ff4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102231:	0f b6 15 20 31 11 80 	movzbl 0x80113120,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102241:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102248:	c7 04 24 54 74 10 80 	movl   $0x80107454,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d f4 2f 11 80    	mov    0x80112ff4,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010226a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010226c:	8b 1d f4 2f 11 80    	mov    0x80112ff4,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010227b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102287:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102289:	8b 0d f4 2f 11 80    	mov    0x80112ff4,%ecx
  for(i = 0; i <= maxintr; i++){
8010228f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022c1:	8b 15 f4 2f 11 80    	mov    0x80112ff4,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ca:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022cc:	8b 15 f4 2f 11 80    	mov    0x80112ff4,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022d8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022da:	8b 15 f4 2f 11 80    	mov    0x80112ff4,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb 68 63 11 80    	cmp    $0x80116368,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 f1 22 00 00       	call   80104620 <memset>

  if(kmem.use_lock)
8010232f:	8b 15 34 30 11 80    	mov    0x80113034,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102339:	a1 38 30 11 80       	mov    0x80113038,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102340:	a1 34 30 11 80       	mov    0x80113034,%eax
  kmem.freelist = r;
80102345:	89 1d 38 30 11 80    	mov    %ebx,0x80113038
  if(kmem.use_lock)
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
    release(&kmem.lock);
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102358:	c7 45 08 00 30 11 80 	movl   $0x80113000,0x8(%ebp)
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
    release(&kmem.lock);
80102364:	e9 67 22 00 00       	jmp    801045d0 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102370:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
80102377:	e8 e4 21 00 00       	call   80104560 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
    panic("kfree");
8010237e:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
}
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023eb:	c7 44 24 04 8c 74 10 	movl   $0x8010748c,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
801023fa:	e8 f1 1f 00 00       	call   801043f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102402:	c7 05 34 30 11 80 00 	movl   $0x0,0x80113034
80102409:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
}
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>
  kmem.use_lock = 1;
8010248e:	c7 05 34 30 11 80 01 	movl   $0x1,0x80113034
80102495:	00 00 00 
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024a7:	a1 34 30 11 80       	mov    0x80113034,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024b0:	8b 1d 38 30 11 80    	mov    0x80113038,%ebx
  if(r)
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 38 30 11 80    	mov    %edx,0x80113038
  if(kmem.use_lock)
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
    release(&kmem.lock);
801024c6:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
801024cd:	e8 fe 20 00 00       	call   801045d0 <release>
  return (char*)r;
}
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024e0:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
801024e7:	e8 74 20 00 00       	call   80104560 <acquire>
801024ec:	a1 34 30 11 80       	mov    0x80113034,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102511:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102534:	0f b6 81 c0 75 10 80 	movzbl -0x7fef8a40(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102565:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102568:	0f b6 91 c0 75 10 80 	movzbl -0x7fef8a40(%ecx),%edx
  shift ^= togglecode[data];
8010256f:	0f b6 81 c0 74 10 80 	movzbl -0x7fef8b40(%ecx),%eax
  shift |= shiftcode[data];
80102576:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102578:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 a0 74 10 80 	mov    -0x7fef8b60(,%eax,4),%eax
  shift ^= togglecode[data];
80102586:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010258c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025a8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
    return -1;
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
}
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102606:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
  if(!lapic)
80102670:	a1 3c 30 11 80       	mov    0x8011303c,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>
  lapic[index] = value;
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
  if (!lapic)
80102760:	a1 3c 30 11 80       	mov    0x8011303c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
  return lapic[ID] >> 24;
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010276f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102770:	c1 e8 18             	shr    $0x18,%eax
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102778:	31 c0                	xor    %eax,%eax
}
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:
  if(lapic)
80102780:	a1 3c 30 11 80       	mov    0x8011303c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
  lapic[index] = value;
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 40 20             	mov    0x20(%eax),%eax
}
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
}
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:
{
801027b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027e0:	a1 3c 30 11 80       	mov    0x8011303c,%eax
  lapicw(ICRHI, apicid<<24);
801027e5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027e8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102822:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 40 20             	mov    0x20(%eax),%eax
}
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 7c fd ff ff       	call   801025f0 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 63 fd ff ff       	call   801025f0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 cf 1d 00 00       	call   80104670 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	66 90                	xchg   %ax,%ax
8010295a:	66 90                	xchg   %ax,%ax
8010295c:	66 90                	xchg   %ax,%ax
8010295e:	66 90                	xchg   %ax,%ax

80102960 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102966:	31 db                	xor    %ebx,%ebx
{
80102968:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010296b:	a1 88 30 11 80       	mov    0x80113088,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 78                	jle    801029ec <install_trans+0x8c>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102978:	a1 74 30 11 80       	mov    0x80113074,%eax
8010297d:	01 d8                	add    %ebx,%eax
8010297f:	83 c0 01             	add    $0x1,%eax
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 84 30 11 80       	mov    0x80113084,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102995:	8b 04 9d 8c 30 11 80 	mov    -0x7feecf74(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
8010299c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	a1 84 30 11 80       	mov    0x80113084,%eax
801029a8:	89 04 24             	mov    %eax,(%esp)
801029ab:	e8 20 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029b7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ba:	8d 47 5c             	lea    0x5c(%edi),%eax
801029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029c4:	89 04 24             	mov    %eax,(%esp)
801029c7:	e8 f4 1c 00 00       	call   801046c0 <memmove>
    bwrite(dbuf);  // write dst to disk
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 cc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029d4:	89 3c 24             	mov    %edi,(%esp)
801029d7:	e8 04 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 fc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029e4:	39 1d 88 30 11 80    	cmp    %ebx,0x80113088
801029ea:	7f 8c                	jg     80102978 <install_trans+0x18>
  }
}
801029ec:	83 c4 1c             	add    $0x1c,%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a09:	a1 74 30 11 80       	mov    0x80113074,%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	a1 84 30 11 80       	mov    0x80113084,%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 b1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a1f:	8b 1d 88 30 11 80    	mov    0x80113088,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a25:	31 d2                	xor    %edx,%edx
80102a27:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a29:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a2b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a2e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a31:	7e 17                	jle    80102a4a <write_head+0x4a>
80102a33:	90                   	nop
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a38:	8b 0c 95 8c 30 11 80 	mov    -0x7feecf74(,%edx,4),%ecx
80102a3f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a43:	83 c2 01             	add    $0x1,%edx
80102a46:	39 da                	cmp    %ebx,%edx
80102a48:	75 ee                	jne    80102a38 <write_head+0x38>
  }
  bwrite(buf);
80102a4a:	89 3c 24             	mov    %edi,(%esp)
80102a4d:	e8 4e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a52:	89 3c 24             	mov    %edi,(%esp)
80102a55:	e8 86 d7 ff ff       	call   801001e0 <brelse>
}
80102a5a:	83 c4 1c             	add    $0x1c,%esp
80102a5d:	5b                   	pop    %ebx
80102a5e:	5e                   	pop    %esi
80102a5f:	5f                   	pop    %edi
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 30             	sub    $0x30,%esp
80102a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a7b:	c7 44 24 04 c0 76 10 	movl   $0x801076c0,0x4(%esp)
80102a82:	80 
80102a83:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102a8a:	e8 61 19 00 00       	call   801043f0 <initlock>
  readsb(dev, &sb);
80102a8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	89 1c 24             	mov    %ebx,(%esp)
80102a99:	e8 82 e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
80102a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102aa4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102aa7:	89 1d 84 30 11 80    	mov    %ebx,0x80113084
  struct buf *buf = bread(log.dev, log.start);
80102aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ab1:	89 15 78 30 11 80    	mov    %edx,0x80113078
  log.start = sb.logstart;
80102ab7:	a3 74 30 11 80       	mov    %eax,0x80113074
  struct buf *buf = bread(log.dev, log.start);
80102abc:	e8 0f d6 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ac3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ac9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102acb:	89 1d 88 30 11 80    	mov    %ebx,0x80113088
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	7e 17                	jle    80102aea <initlog+0x7a>
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ad8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102adc:	89 0c 95 8c 30 11 80 	mov    %ecx,-0x7feecf74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ae3:	83 c2 01             	add    $0x1,%edx
80102ae6:	39 da                	cmp    %ebx,%edx
80102ae8:	75 ee                	jne    80102ad8 <initlog+0x68>
  brelse(buf);
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102af2:	e8 69 fe ff ff       	call   80102960 <install_trans>
  log.lh.n = 0;
80102af7:	c7 05 88 30 11 80 00 	movl   $0x0,0x80113088
80102afe:	00 00 00 
  write_head(); // clear the log
80102b01:	e8 fa fe ff ff       	call   80102a00 <write_head>
}
80102b06:	83 c4 30             	add    $0x30,%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret    
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b16:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102b1d:	e8 3e 1a 00 00       	call   80104560 <acquire>
80102b22:	eb 18                	jmp    80102b3c <begin_op+0x2c>
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b28:	c7 44 24 04 40 30 11 	movl   $0x80113040,0x4(%esp)
80102b2f:	80 
80102b30:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102b37:	e8 04 12 00 00       	call   80103d40 <sleep>
    if(log.committing){
80102b3c:	a1 80 30 11 80       	mov    0x80113080,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	75 e3                	jne    80102b28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b45:	a1 7c 30 11 80       	mov    0x8011307c,%eax
80102b4a:	8b 15 88 30 11 80    	mov    0x80113088,%edx
80102b50:	83 c0 01             	add    $0x1,%eax
80102b53:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b56:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b59:	83 fa 1e             	cmp    $0x1e,%edx
80102b5c:	7f ca                	jg     80102b28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b5e:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
      log.outstanding += 1;
80102b65:	a3 7c 30 11 80       	mov    %eax,0x8011307c
      release(&log.lock);
80102b6a:	e8 61 1a 00 00       	call   801045d0 <release>
      break;
    }
  }
}
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    
80102b71:	eb 0d                	jmp    80102b80 <end_op>
80102b73:	90                   	nop
80102b74:	90                   	nop
80102b75:	90                   	nop
80102b76:	90                   	nop
80102b77:	90                   	nop
80102b78:	90                   	nop
80102b79:	90                   	nop
80102b7a:	90                   	nop
80102b7b:	90                   	nop
80102b7c:	90                   	nop
80102b7d:	90                   	nop
80102b7e:	90                   	nop
80102b7f:	90                   	nop

80102b80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b89:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102b90:	e8 cb 19 00 00       	call   80104560 <acquire>
  log.outstanding -= 1;
80102b95:	a1 7c 30 11 80       	mov    0x8011307c,%eax
  if(log.committing)
80102b9a:	8b 15 80 30 11 80    	mov    0x80113080,%edx
  log.outstanding -= 1;
80102ba0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ba3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102ba5:	a3 7c 30 11 80       	mov    %eax,0x8011307c
  if(log.committing)
80102baa:	0f 85 f3 00 00 00    	jne    80102ca3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	0f 85 cb 00 00 00    	jne    80102c83 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bb8:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bbf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bc1:	c7 05 80 30 11 80 01 	movl   $0x1,0x80113080
80102bc8:	00 00 00 
  release(&log.lock);
80102bcb:	e8 00 1a 00 00       	call   801045d0 <release>
  if (log.lh.n > 0) {
80102bd0:	a1 88 30 11 80       	mov    0x80113088,%eax
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	0f 8e 90 00 00 00    	jle    80102c6d <end_op+0xed>
80102bdd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102be0:	a1 74 30 11 80       	mov    0x80113074,%eax
80102be5:	01 d8                	add    %ebx,%eax
80102be7:	83 c0 01             	add    $0x1,%eax
80102bea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bee:	a1 84 30 11 80       	mov    0x80113084,%eax
80102bf3:	89 04 24             	mov    %eax,(%esp)
80102bf6:	e8 d5 d4 ff ff       	call   801000d0 <bread>
80102bfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bfd:	8b 04 9d 8c 30 11 80 	mov    -0x7feecf74(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c04:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0b:	a1 84 30 11 80       	mov    0x80113084,%eax
80102c10:	89 04 24             	mov    %eax,(%esp)
80102c13:	e8 b8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c1f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c20:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2c:	89 04 24             	mov    %eax,(%esp)
80102c2f:	e8 8c 1a 00 00       	call   801046c0 <memmove>
    bwrite(to);  // write the log
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 64 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c3c:	89 3c 24             	mov    %edi,(%esp)
80102c3f:	e8 9c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 94 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c4c:	3b 1d 88 30 11 80    	cmp    0x80113088,%ebx
80102c52:	7c 8c                	jl     80102be0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c54:	e8 a7 fd ff ff       	call   80102a00 <write_head>
    install_trans(); // Now install writes to home locations
80102c59:	e8 02 fd ff ff       	call   80102960 <install_trans>
    log.lh.n = 0;
80102c5e:	c7 05 88 30 11 80 00 	movl   $0x0,0x80113088
80102c65:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c68:	e8 93 fd ff ff       	call   80102a00 <write_head>
    acquire(&log.lock);
80102c6d:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102c74:	e8 e7 18 00 00       	call   80104560 <acquire>
    log.committing = 0;
80102c79:	c7 05 80 30 11 80 00 	movl   $0x0,0x80113080
80102c80:	00 00 00 
    wakeup(&log);
80102c83:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102c8a:	e8 51 12 00 00       	call   80103ee0 <wakeup>
    release(&log.lock);
80102c8f:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102c96:	e8 35 19 00 00       	call   801045d0 <release>
}
80102c9b:	83 c4 1c             	add    $0x1c,%esp
80102c9e:	5b                   	pop    %ebx
80102c9f:	5e                   	pop    %esi
80102ca0:	5f                   	pop    %edi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
    panic("log.committing");
80102ca3:	c7 04 24 c4 76 10 80 	movl   $0x801076c4,(%esp)
80102caa:	e8 b1 d6 ff ff       	call   80100360 <panic>
80102caf:	90                   	nop

80102cb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cb7:	a1 88 30 11 80       	mov    0x80113088,%eax
{
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cbf:	83 f8 1d             	cmp    $0x1d,%eax
80102cc2:	0f 8f 98 00 00 00    	jg     80102d60 <log_write+0xb0>
80102cc8:	8b 0d 78 30 11 80    	mov    0x80113078,%ecx
80102cce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cd1:	39 d0                	cmp    %edx,%eax
80102cd3:	0f 8d 87 00 00 00    	jge    80102d60 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cd9:	a1 7c 30 11 80       	mov    0x8011307c,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	0f 8e 86 00 00 00    	jle    80102d6c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ce6:	c7 04 24 40 30 11 80 	movl   $0x80113040,(%esp)
80102ced:	e8 6e 18 00 00       	call   80104560 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102cf2:	8b 15 88 30 11 80    	mov    0x80113088,%edx
80102cf8:	83 fa 00             	cmp    $0x0,%edx
80102cfb:	7e 54                	jle    80102d51 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d00:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d02:	39 0d 8c 30 11 80    	cmp    %ecx,0x8011308c
80102d08:	75 0f                	jne    80102d19 <log_write+0x69>
80102d0a:	eb 3c                	jmp    80102d48 <log_write+0x98>
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d10:	39 0c 85 8c 30 11 80 	cmp    %ecx,-0x7feecf74(,%eax,4)
80102d17:	74 2f                	je     80102d48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d19:	83 c0 01             	add    $0x1,%eax
80102d1c:	39 d0                	cmp    %edx,%eax
80102d1e:	75 f0                	jne    80102d10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d20:	89 0c 95 8c 30 11 80 	mov    %ecx,-0x7feecf74(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d27:	83 c2 01             	add    $0x1,%edx
80102d2a:	89 15 88 30 11 80    	mov    %edx,0x80113088
  b->flags |= B_DIRTY; // prevent eviction
80102d30:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d33:	c7 45 08 40 30 11 80 	movl   $0x80113040,0x8(%ebp)
}
80102d3a:	83 c4 14             	add    $0x14,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
  release(&log.lock);
80102d3f:	e9 8c 18 00 00       	jmp    801045d0 <release>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d48:	89 0c 85 8c 30 11 80 	mov    %ecx,-0x7feecf74(,%eax,4)
80102d4f:	eb df                	jmp    80102d30 <log_write+0x80>
80102d51:	8b 43 08             	mov    0x8(%ebx),%eax
80102d54:	a3 8c 30 11 80       	mov    %eax,0x8011308c
  if (i == log.lh.n)
80102d59:	75 d5                	jne    80102d30 <log_write+0x80>
80102d5b:	eb ca                	jmp    80102d27 <log_write+0x77>
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d60:	c7 04 24 d3 76 10 80 	movl   $0x801076d3,(%esp)
80102d67:	e8 f4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d6c:	c7 04 24 e9 76 10 80 	movl   $0x801076e9,(%esp)
80102d73:	e8 e8 d5 ff ff       	call   80100360 <panic>
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d87:	e8 24 09 00 00       	call   801036b0 <cpuid>
80102d8c:	89 c3                	mov    %eax,%ebx
80102d8e:	e8 1d 09 00 00       	call   801036b0 <cpuid>
80102d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d97:	c7 04 24 04 77 10 80 	movl   $0x80107704,(%esp)
80102d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da2:	e8 a9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102da7:	e8 44 2b 00 00       	call   801058f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dac:	e8 7f 08 00 00       	call   80103630 <mycpu>
80102db1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102db3:	b8 01 00 00 00       	mov    $0x1,%eax
80102db8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dbf:	e8 cc 0b 00 00       	call   80103990 <scheduler>
80102dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dd0 <mpenter>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dd6:	e8 d5 3b 00 00       	call   801069b0 <switchkvm>
  seginit();
80102ddb:	e8 10 3b 00 00       	call   801068f0 <seginit>
  lapicinit();
80102de0:	e8 8b f8 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102de5:	e8 96 ff ff ff       	call   80102d80 <mpmain>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <main>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102df4:	bb 40 31 11 80       	mov    $0x80113140,%ebx
{
80102df9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dfc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102dff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e06:	80 
80102e07:	c7 04 24 68 63 11 80 	movl   $0x80116368,(%esp)
80102e0e:	e8 cd f5 ff ff       	call   801023e0 <kinit1>
  kvmalloc();      // kernel page table
80102e13:	e8 28 40 00 00       	call   80106e40 <kvmalloc>
  mpinit();        // detect other processors
80102e18:	e8 73 01 00 00       	call   80102f90 <mpinit>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e20:	e8 4b f8 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102e25:	e8 c6 3a 00 00       	call   801068f0 <seginit>
  picinit();       // disable pic
80102e2a:	e8 21 03 00 00       	call   80103150 <picinit>
80102e2f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e30:	e8 cb f3 ff ff       	call   80102200 <ioapicinit>
  consoleinit();   // console hardware
80102e35:	e8 16 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e3a:	e8 d1 2d 00 00       	call   80105c10 <uartinit>
80102e3f:	90                   	nop
  pinit();         // process table
80102e40:	e8 cb 07 00 00       	call   80103610 <pinit>
  tvinit();        // trap vectors
80102e45:	e8 06 2a 00 00       	call   80105850 <tvinit>
  binit();         // buffer cache
80102e4a:	e8 f1 d1 ff ff       	call   80100040 <binit>
80102e4f:	90                   	nop
  fileinit();      // file table
80102e50:	e8 fb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e55:	e8 a6 f1 ff ff       	call   80102000 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e5a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e61:	00 
80102e62:	c7 44 24 04 90 a4 10 	movl   $0x8010a490,0x4(%esp)
80102e69:	80 
80102e6a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e71:	e8 4a 18 00 00       	call   801046c0 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e76:	69 05 c0 36 11 80 b0 	imul   $0xb0,0x801136c0,%eax
80102e7d:	00 00 00 
80102e80:	05 40 31 11 80       	add    $0x80113140,%eax
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	76 6a                	jbe    80102ef3 <main+0x103>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102e90:	e8 9b 07 00 00       	call   80103630 <mycpu>
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	74 41                	je     80102eda <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e99:	e8 02 f6 ff ff       	call   801024a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102e9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102dd0,0x80006ff8
80102ea5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ea8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eaf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102eb2:	05 00 10 00 00       	add    $0x1000,%eax
80102eb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102ebc:	0f b6 03             	movzbl (%ebx),%eax
80102ebf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ec6:	00 
80102ec7:	89 04 24             	mov    %eax,(%esp)
80102eca:	e8 e1 f8 ff ff       	call   801027b0 <lapicstartap>
80102ecf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ed0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 f6                	je     80102ed0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eda:	69 05 c0 36 11 80 b0 	imul   $0xb0,0x801136c0,%eax
80102ee1:	00 00 00 
80102ee4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eea:	05 40 31 11 80       	add    $0x80113140,%eax
80102eef:	39 c3                	cmp    %eax,%ebx
80102ef1:	72 9d                	jb     80102e90 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ef3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102efa:	8e 
80102efb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f02:	e8 49 f5 ff ff       	call   80102450 <kinit2>
  userinit();      // first user process
80102f07:	e8 f4 07 00 00       	call   80103700 <userinit>
  mpmain();        // finish this processor's setup
80102f0c:	e8 6f fe ff ff       	call   80102d80 <mpmain>
80102f11:	66 90                	xchg   %ax,%ax
80102f13:	66 90                	xchg   %ax,%ax
80102f15:	66 90                	xchg   %ax,%ax
80102f17:	66 90                	xchg   %ax,%ax
80102f19:	66 90                	xchg   %ax,%ax
80102f1b:	66 90                	xchg   %ax,%ax
80102f1d:	66 90                	xchg   %ax,%ax
80102f1f:	90                   	nop

80102f20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f24:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f2a:	53                   	push   %ebx
  e = addr+len;
80102f2b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f2e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f31:	39 de                	cmp    %ebx,%esi
80102f33:	73 3c                	jae    80102f71 <mpsearch1+0x51>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f3f:	00 
80102f40:	c7 44 24 04 18 77 10 	movl   $0x80107718,0x4(%esp)
80102f47:	80 
80102f48:	89 34 24             	mov    %esi,(%esp)
80102f4b:	e8 20 17 00 00       	call   80104670 <memcmp>
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 16                	jne    80102f6a <mpsearch1+0x4a>
80102f54:	31 c9                	xor    %ecx,%ecx
80102f56:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f58:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f5c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f5f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f61:	83 fa 10             	cmp    $0x10,%edx
80102f64:	75 f2                	jne    80102f58 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f66:	84 c9                	test   %cl,%cl
80102f68:	74 10                	je     80102f7a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f6a:	83 c6 10             	add    $0x10,%esi
80102f6d:	39 f3                	cmp    %esi,%ebx
80102f6f:	77 c7                	ja     80102f38 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f71:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f74:	31 c0                	xor    %eax,%eax
}
80102f76:	5b                   	pop    %ebx
80102f77:	5e                   	pop    %esi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	89 f0                	mov    %esi,%eax
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fa0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fa7:	c1 e0 08             	shl    $0x8,%eax
80102faa:	09 d0                	or     %edx,%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	75 1b                	jne    80102fce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fb3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fc1:	c1 e0 08             	shl    $0x8,%eax
80102fc4:	09 d0                	or     %edx,%eax
80102fc6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fc9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fce:	ba 00 04 00 00       	mov    $0x400,%edx
80102fd3:	e8 48 ff ff ff       	call   80102f20 <mpsearch1>
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	0f 84 22 01 00 00    	je     80103104 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fe2:	8b 77 04             	mov    0x4(%edi),%esi
80102fe5:	85 f6                	test   %esi,%esi
80102fe7:	0f 84 30 01 00 00    	je     8010311d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102ffa:	00 
80102ffb:	c7 44 24 04 1d 77 10 	movl   $0x8010771d,0x4(%esp)
80103002:	80 
80103003:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103009:	e8 62 16 00 00       	call   80104670 <memcmp>
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 85 07 01 00 00    	jne    8010311d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103016:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010301d:	3c 04                	cmp    $0x4,%al
8010301f:	0f 85 0b 01 00 00    	jne    80103130 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103025:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 21                	je     80103051 <mpinit+0xc1>
  sum = 0;
80103030:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103032:	31 d2                	xor    %edx,%edx
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103038:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010303f:	80 
  for(i=0; i<len; i++)
80103040:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103043:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103045:	39 d0                	cmp    %edx,%eax
80103047:	7f ef                	jg     80103038 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103049:	84 c9                	test   %cl,%cl
8010304b:	0f 85 cc 00 00 00    	jne    8010311d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 c1 00 00 00    	je     8010311d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010305c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103062:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103067:	a3 3c 30 11 80       	mov    %eax,0x8011303c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010306c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103073:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103079:	03 55 e4             	add    -0x1c(%ebp),%edx
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 c2                	cmp    %eax,%edx
80103082:	76 1b                	jbe    8010309f <mpinit+0x10f>
80103084:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103087:	80 f9 04             	cmp    $0x4,%cl
8010308a:	77 74                	ja     80103100 <mpinit+0x170>
8010308c:	ff 24 8d 5c 77 10 80 	jmp    *-0x7fef88a4(,%ecx,4)
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103098:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309b:	39 c2                	cmp    %eax,%edx
8010309d:	77 e5                	ja     80103084 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010309f:	85 db                	test   %ebx,%ebx
801030a1:	0f 84 93 00 00 00    	je     8010313a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030ab:	74 12                	je     801030bf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ad:	ba 22 00 00 00       	mov    $0x22,%edx
801030b2:	b8 70 00 00 00       	mov    $0x70,%eax
801030b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030b8:	b2 23                	mov    $0x23,%dl
801030ba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030bb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030be:	ee                   	out    %al,(%dx)
  }
}
801030bf:	83 c4 1c             	add    $0x1c,%esp
801030c2:	5b                   	pop    %ebx
801030c3:	5e                   	pop    %esi
801030c4:	5f                   	pop    %edi
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	90                   	nop
      if(ncpu < NCPU) {
801030c8:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
801030ce:	83 fe 07             	cmp    $0x7,%esi
801030d1:	7f 17                	jg     801030ea <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030dd:	83 05 c0 36 11 80 01 	addl   $0x1,0x801136c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e4:	88 8e 40 31 11 80    	mov    %cl,-0x7feecec0(%esi)
      p += sizeof(struct mpproc);
801030ea:	83 c0 14             	add    $0x14,%eax
      continue;
801030ed:	eb 91                	jmp    80103080 <mpinit+0xf0>
801030ef:	90                   	nop
      ioapicid = ioapic->apicno;
801030f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801030f7:	88 0d 20 31 11 80    	mov    %cl,0x80113120
      continue;
801030fd:	eb 81                	jmp    80103080 <mpinit+0xf0>
801030ff:	90                   	nop
      ismp = 0;
80103100:	31 db                	xor    %ebx,%ebx
80103102:	eb 83                	jmp    80103087 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103104:	ba 00 00 01 00       	mov    $0x10000,%edx
80103109:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010310e:	e8 0d fe ff ff       	call   80102f20 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103113:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103115:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103117:	0f 85 c5 fe ff ff    	jne    80102fe2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010311d:	c7 04 24 22 77 10 80 	movl   $0x80107722,(%esp)
80103124:	e8 37 d2 ff ff       	call   80100360 <panic>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103130:	3c 01                	cmp    $0x1,%al
80103132:	0f 84 ed fe ff ff    	je     80103025 <mpinit+0x95>
80103138:	eb e3                	jmp    8010311d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010313a:	c7 04 24 3c 77 10 80 	movl   $0x8010773c,(%esp)
80103141:	e8 1a d2 ff ff       	call   80100360 <panic>
80103146:	66 90                	xchg   %ax,%ax
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103150:	55                   	push   %ebp
80103151:	ba 21 00 00 00       	mov    $0x21,%edx
80103156:	89 e5                	mov    %esp,%ebp
80103158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315d:	ee                   	out    %al,(%dx)
8010315e:	b2 a1                	mov    $0xa1,%dl
80103160:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
80103163:	66 90                	xchg   %ax,%ax
80103165:	66 90                	xchg   %ax,%ax
80103167:	66 90                	xchg   %ax,%ax
80103169:	66 90                	xchg   %ax,%ax
8010316b:	66 90                	xchg   %ax,%ax
8010316d:	66 90                	xchg   %ax,%ax
8010316f:	90                   	nop

80103170 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
80103179:	8b 75 08             	mov    0x8(%ebp),%esi
8010317c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010317f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103185:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010318b:	e8 e0 db ff ff       	call   80100d70 <filealloc>
80103190:	85 c0                	test   %eax,%eax
80103192:	89 06                	mov    %eax,(%esi)
80103194:	0f 84 a4 00 00 00    	je     8010323e <pipealloc+0xce>
8010319a:	e8 d1 db ff ff       	call   80100d70 <filealloc>
8010319f:	85 c0                	test   %eax,%eax
801031a1:	89 03                	mov    %eax,(%ebx)
801031a3:	0f 84 87 00 00 00    	je     80103230 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031a9:	e8 f2 f2 ff ff       	call   801024a0 <kalloc>
801031ae:	85 c0                	test   %eax,%eax
801031b0:	89 c7                	mov    %eax,%edi
801031b2:	74 7c                	je     80103230 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031bb:	00 00 00 
  p->writeopen = 1;
801031be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031c5:	00 00 00 
  p->nwrite = 0;
801031c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031cf:	00 00 00 
  p->nread = 0;
801031d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031d9:	00 00 00 
  initlock(&p->lock, "pipe");
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	c7 44 24 04 70 77 10 	movl   $0x80107770,0x4(%esp)
801031e6:	80 
801031e7:	e8 04 12 00 00       	call   801043f0 <initlock>
  (*f0)->type = FD_PIPE;
801031ec:	8b 06                	mov    (%esi),%eax
801031ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031f4:	8b 06                	mov    (%esi),%eax
801031f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031fa:	8b 06                	mov    (%esi),%eax
801031fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103200:	8b 06                	mov    (%esi),%eax
80103202:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103205:	8b 03                	mov    (%ebx),%eax
80103207:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010320d:	8b 03                	mov    (%ebx),%eax
8010320f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103213:	8b 03                	mov    (%ebx),%eax
80103215:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103219:	8b 03                	mov    (%ebx),%eax
  return 0;
8010321b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010321d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103220:	83 c4 1c             	add    $0x1c,%esp
80103223:	89 d8                	mov    %ebx,%eax
80103225:	5b                   	pop    %ebx
80103226:	5e                   	pop    %esi
80103227:	5f                   	pop    %edi
80103228:	5d                   	pop    %ebp
80103229:	c3                   	ret    
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103230:	8b 06                	mov    (%esi),%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	74 08                	je     8010323e <pipealloc+0xce>
    fileclose(*f0);
80103236:	89 04 24             	mov    %eax,(%esp)
80103239:	e8 f2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010323e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103240:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103245:	85 c0                	test   %eax,%eax
80103247:	74 d7                	je     80103220 <pipealloc+0xb0>
    fileclose(*f1);
80103249:	89 04 24             	mov    %eax,(%esp)
8010324c:	e8 df db ff ff       	call   80100e30 <fileclose>
}
80103251:	83 c4 1c             	add    $0x1c,%esp
80103254:	89 d8                	mov    %ebx,%eax
80103256:	5b                   	pop    %ebx
80103257:	5e                   	pop    %esi
80103258:	5f                   	pop    %edi
80103259:	5d                   	pop    %ebp
8010325a:	c3                   	ret    
8010325b:	90                   	nop
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	56                   	push   %esi
80103264:	53                   	push   %ebx
80103265:	83 ec 10             	sub    $0x10,%esp
80103268:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010326e:	89 1c 24             	mov    %ebx,(%esp)
80103271:	e8 ea 12 00 00       	call   80104560 <acquire>
  if(writable){
80103276:	85 f6                	test   %esi,%esi
80103278:	74 3e                	je     801032b8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010327a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103280:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103287:	00 00 00 
    wakeup(&p->nread);
8010328a:	89 04 24             	mov    %eax,(%esp)
8010328d:	e8 4e 0c 00 00       	call   80103ee0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103292:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103298:	85 d2                	test   %edx,%edx
8010329a:	75 0a                	jne    801032a6 <pipeclose+0x46>
8010329c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 32                	je     801032d8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5d                   	pop    %ebp
    release(&p->lock);
801032af:	e9 1c 13 00 00       	jmp    801045d0 <release>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032c5:	00 00 00 
    wakeup(&p->nwrite);
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 10 0c 00 00       	call   80103ee0 <wakeup>
801032d0:	eb c0                	jmp    80103292 <pipeclose+0x32>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032d8:	89 1c 24             	mov    %ebx,(%esp)
801032db:	e8 f0 12 00 00       	call   801045d0 <release>
    kfree((char*)p);
801032e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5d                   	pop    %ebp
    kfree((char*)p);
801032e9:	e9 02 f0 ff ff       	jmp    801022f0 <kfree>
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	e8 5c 12 00 00       	call   80104560 <acquire>
  for(i = 0; i < n; i++){
80103304:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103307:	85 c9                	test   %ecx,%ecx
80103309:	0f 8e b2 00 00 00    	jle    801033c1 <pipewrite+0xd1>
8010330f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103312:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103318:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010331e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103327:	03 4d 10             	add    0x10(%ebp),%ecx
8010332a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010332d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103333:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103339:	39 c8                	cmp    %ecx,%eax
8010333b:	74 38                	je     80103375 <pipewrite+0x85>
8010333d:	eb 55                	jmp    80103394 <pipewrite+0xa4>
8010333f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103340:	e8 8b 03 00 00       	call   801036d0 <myproc>
80103345:	8b 40 24             	mov    0x24(%eax),%eax
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 33                	jne    8010337f <pipewrite+0x8f>
      wakeup(&p->nread);
8010334c:	89 3c 24             	mov    %edi,(%esp)
8010334f:	e8 8c 0b 00 00       	call   80103ee0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103354:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103358:	89 34 24             	mov    %esi,(%esp)
8010335b:	e8 e0 09 00 00       	call   80103d40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103360:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103366:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010336c:	05 00 02 00 00       	add    $0x200,%eax
80103371:	39 c2                	cmp    %eax,%edx
80103373:	75 23                	jne    80103398 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103375:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010337b:	85 d2                	test   %edx,%edx
8010337d:	75 c1                	jne    80103340 <pipewrite+0x50>
        release(&p->lock);
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 49 12 00 00       	call   801045d0 <release>
        return -1;
80103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010338c:	83 c4 1c             	add    $0x1c,%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103394:	89 c2                	mov    %eax,%edx
80103396:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339b:	8d 42 01             	lea    0x1(%edx),%eax
8010339e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ae:	0f b6 09             	movzbl (%ecx),%ecx
801033b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033bb:	0f 85 6c ff ff ff    	jne    8010332d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 11 0b 00 00       	call   80103ee0 <wakeup>
  release(&p->lock);
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 f9 11 00 00       	call   801045d0 <release>
  return n;
801033d7:	8b 45 10             	mov    0x10(%ebp),%eax
801033da:	eb b0                	jmp    8010338c <pipewrite+0x9c>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ef:	89 34 24             	mov    %esi,(%esp)
801033f2:	e8 69 11 00 00       	call   80104560 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103403:	75 5b                	jne    80103460 <piperead+0x80>
80103405:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010340b:	85 db                	test   %ebx,%ebx
8010340d:	74 51                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010340f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103415:	eb 25                	jmp    8010343c <piperead+0x5c>
80103417:	90                   	nop
80103418:	89 74 24 04          	mov    %esi,0x4(%esp)
8010341c:	89 1c 24             	mov    %ebx,(%esp)
8010341f:	e8 1c 09 00 00       	call   80103d40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103424:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103430:	75 2e                	jne    80103460 <piperead+0x80>
80103432:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103438:	85 d2                	test   %edx,%edx
8010343a:	74 24                	je     80103460 <piperead+0x80>
    if(myproc()->killed){
8010343c:	e8 8f 02 00 00       	call   801036d0 <myproc>
80103441:	8b 48 24             	mov    0x24(%eax),%ecx
80103444:	85 c9                	test   %ecx,%ecx
80103446:	74 d0                	je     80103418 <piperead+0x38>
      release(&p->lock);
80103448:	89 34 24             	mov    %esi,(%esp)
8010344b:	e8 80 11 00 00       	call   801045d0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103450:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103460:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103463:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103465:	85 d2                	test   %edx,%edx
80103467:	7f 2b                	jg     80103494 <piperead+0xb4>
80103469:	eb 31                	jmp    8010349c <piperead+0xbc>
8010346b:	90                   	nop
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103470:	8d 48 01             	lea    0x1(%eax),%ecx
80103473:	25 ff 01 00 00       	and    $0x1ff,%eax
80103478:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010347e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103483:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103486:	83 c3 01             	add    $0x1,%ebx
80103489:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010348c:	74 0e                	je     8010349c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010348e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103494:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010349a:	75 d4                	jne    80103470 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010349c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034a2:	89 04 24             	mov    %eax,(%esp)
801034a5:	e8 36 0a 00 00       	call   80103ee0 <wakeup>
  release(&p->lock);
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 1e 11 00 00       	call   801045d0 <release>
}
801034b2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034b5:	89 d8                	mov    %ebx,%eax
}
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034c4:	bb 14 37 11 80       	mov    $0x80113714,%ebx
{
801034c9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034cc:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801034d3:	e8 88 10 00 00       	call   80104560 <acquire>
801034d8:	eb 18                	jmp    801034f2 <allocproc+0x32>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801034e6:	81 fb 14 5b 11 80    	cmp    $0x80115b14,%ebx
801034ec:	0f 84 ae 00 00 00    	je     801035a0 <allocproc+0xe0>
    if(p->state == UNUSED)
801034f2:	8b 43 0c             	mov    0xc(%ebx),%eax
801034f5:	85 c0                	test   %eax,%eax
801034f7:	75 e7                	jne    801034e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034f9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->tickets=10;
  p->stride=60/p->tickets;
  p->passvalue=p->stride;
  p->ticks=0;

  release(&ptable.lock);
801034fe:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
  p->state = EMBRYO;
80103505:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->tickets=10;
8010350c:	c7 83 80 00 00 00 0a 	movl   $0xa,0x80(%ebx)
80103513:	00 00 00 
  p->pid = nextpid++;
80103516:	8d 50 01             	lea    0x1(%eax),%edx
80103519:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010351f:	89 43 10             	mov    %eax,0x10(%ebx)
  p->stride=60/p->tickets;
80103522:	c7 83 88 00 00 00 06 	movl   $0x6,0x88(%ebx)
80103529:	00 00 00 
  p->passvalue=p->stride;
8010352c:	c7 83 84 00 00 00 06 	movl   $0x6,0x84(%ebx)
80103533:	00 00 00 
  p->ticks=0;
80103536:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010353d:	00 00 00 
  release(&ptable.lock);
80103540:	e8 8b 10 00 00       	call   801045d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103545:	e8 56 ef ff ff       	call   801024a0 <kalloc>
8010354a:	85 c0                	test   %eax,%eax
8010354c:	89 43 08             	mov    %eax,0x8(%ebx)
8010354f:	74 63                	je     801035b4 <allocproc+0xf4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103551:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103557:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010355c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010355f:	c7 40 14 36 58 10 80 	movl   $0x80105836,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103566:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010356d:	00 
8010356e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103575:	00 
80103576:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
80103579:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010357c:	e8 9f 10 00 00       	call   80104620 <memset>
  p->context->eip = (uint)forkret;
80103581:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103584:	c7 40 10 c0 35 10 80 	movl   $0x801035c0,0x10(%eax)
  p->sysnum=0;

  return p;
8010358b:	89 d8                	mov    %ebx,%eax
  p->sysnum=0;
8010358d:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
80103594:	83 c4 14             	add    $0x14,%esp
80103597:	5b                   	pop    %ebx
80103598:	5d                   	pop    %ebp
80103599:	c3                   	ret    
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801035a0:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801035a7:	e8 24 10 00 00       	call   801045d0 <release>
}
801035ac:	83 c4 14             	add    $0x14,%esp
  return 0;
801035af:	31 c0                	xor    %eax,%eax
}
801035b1:	5b                   	pop    %ebx
801035b2:	5d                   	pop    %ebp
801035b3:	c3                   	ret    
    p->state = UNUSED;
801035b4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035bb:	eb d7                	jmp    80103594 <allocproc+0xd4>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi

801035c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035c6:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801035cd:	e8 fe 0f 00 00       	call   801045d0 <release>

  if (first) {
801035d2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	75 05                	jne    801035e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035db:	c9                   	leave  
801035dc:	c3                   	ret    
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035e7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ee:	00 00 00 
    iinit(ROOTDEV);
801035f1:	e8 7a de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801035f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035fd:	e8 6e f4 ff ff       	call   80102a70 <initlog>
}
80103602:	c9                   	leave  
80103603:	c3                   	ret    
80103604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010360a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103610 <pinit>:
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103616:	c7 44 24 04 75 77 10 	movl   $0x80107775,0x4(%esp)
8010361d:	80 
8010361e:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103625:	e8 c6 0d 00 00       	call   801043f0 <initlock>
}
8010362a:	c9                   	leave  
8010362b:	c3                   	ret    
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103630 <mycpu>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103638:	9c                   	pushf  
80103639:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010363a:	f6 c4 02             	test   $0x2,%ah
8010363d:	75 57                	jne    80103696 <mycpu+0x66>
  apicid = lapicid();
8010363f:	e8 1c f1 ff ff       	call   80102760 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103644:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
8010364a:	85 f6                	test   %esi,%esi
8010364c:	7e 3c                	jle    8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010364e:	0f b6 15 40 31 11 80 	movzbl 0x80113140,%edx
80103655:	39 c2                	cmp    %eax,%edx
80103657:	74 2d                	je     80103686 <mycpu+0x56>
80103659:	b9 f0 31 11 80       	mov    $0x801131f0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010365e:	31 d2                	xor    %edx,%edx
80103660:	83 c2 01             	add    $0x1,%edx
80103663:	39 f2                	cmp    %esi,%edx
80103665:	74 23                	je     8010368a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103667:	0f b6 19             	movzbl (%ecx),%ebx
8010366a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103670:	39 c3                	cmp    %eax,%ebx
80103672:	75 ec                	jne    80103660 <mycpu+0x30>
      return &cpus[i];
80103674:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	5b                   	pop    %ebx
8010367e:	5e                   	pop    %esi
8010367f:	5d                   	pop    %ebp
      return &cpus[i];
80103680:	05 40 31 11 80       	add    $0x80113140,%eax
}
80103685:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103686:	31 d2                	xor    %edx,%edx
80103688:	eb ea                	jmp    80103674 <mycpu+0x44>
  panic("unknown apicid\n");
8010368a:	c7 04 24 7c 77 10 80 	movl   $0x8010777c,(%esp)
80103691:	e8 ca cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103696:	c7 04 24 74 78 10 80 	movl   $0x80107874,(%esp)
8010369d:	e8 be cc ff ff       	call   80100360 <panic>
801036a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036b0 <cpuid>:
cpuid() {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036b6:	e8 75 ff ff ff       	call   80103630 <mycpu>
}
801036bb:	c9                   	leave  
  return mycpu()-cpus;
801036bc:	2d 40 31 11 80       	sub    $0x80113140,%eax
801036c1:	c1 f8 04             	sar    $0x4,%eax
801036c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ca:	c3                   	ret    
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036d0 <myproc>:
myproc(void) {
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036d7:	e8 94 0d 00 00       	call   80104470 <pushcli>
  c = mycpu();
801036dc:	e8 4f ff ff ff       	call   80103630 <mycpu>
  p = c->proc;
801036e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036e7:	e8 c4 0d 00 00       	call   801044b0 <popcli>
}
801036ec:	83 c4 04             	add    $0x4,%esp
801036ef:	89 d8                	mov    %ebx,%eax
801036f1:	5b                   	pop    %ebx
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <userinit>:
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	53                   	push   %ebx
80103704:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103707:	e8 b4 fd ff ff       	call   801034c0 <allocproc>
8010370c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010370e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103713:	e8 98 36 00 00       	call   80106db0 <setupkvm>
80103718:	85 c0                	test   %eax,%eax
8010371a:	89 43 04             	mov    %eax,0x4(%ebx)
8010371d:	0f 84 d4 00 00 00    	je     801037f7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103723:	89 04 24             	mov    %eax,(%esp)
80103726:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010372d:	00 
8010372e:	c7 44 24 04 64 a4 10 	movl   $0x8010a464,0x4(%esp)
80103735:	80 
80103736:	e8 a5 33 00 00       	call   80106ae0 <inituvm>
  p->sz = PGSIZE;
8010373b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103741:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103748:	00 
80103749:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103750:	00 
80103751:	8b 43 18             	mov    0x18(%ebx),%eax
80103754:	89 04 24             	mov    %eax,(%esp)
80103757:	e8 c4 0e 00 00       	call   80104620 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010375c:	8b 43 18             	mov    0x18(%ebx),%eax
8010375f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103764:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103769:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010376d:	8b 43 18             	mov    0x18(%ebx),%eax
80103770:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010377b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010377f:	8b 43 18             	mov    0x18(%ebx),%eax
80103782:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103786:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010378a:	8b 43 18             	mov    0x18(%ebx),%eax
8010378d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103794:	8b 43 18             	mov    0x18(%ebx),%eax
80103797:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010379e:	8b 43 18             	mov    0x18(%ebx),%eax
801037a1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037a8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037ab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037b2:	00 
801037b3:	c7 44 24 04 a5 77 10 	movl   $0x801077a5,0x4(%esp)
801037ba:	80 
801037bb:	89 04 24             	mov    %eax,(%esp)
801037be:	e8 3d 10 00 00       	call   80104800 <safestrcpy>
  p->cwd = namei("/");
801037c3:	c7 04 24 ae 77 10 80 	movl   $0x801077ae,(%esp)
801037ca:	e8 31 e7 ff ff       	call   80101f00 <namei>
801037cf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037d2:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801037d9:	e8 82 0d 00 00       	call   80104560 <acquire>
  p->state = RUNNABLE;
801037de:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037e5:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801037ec:	e8 df 0d 00 00       	call   801045d0 <release>
}
801037f1:	83 c4 14             	add    $0x14,%esp
801037f4:	5b                   	pop    %ebx
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
    panic("userinit: out of memory?");
801037f7:	c7 04 24 8c 77 10 80 	movl   $0x8010778c,(%esp)
801037fe:	e8 5d cb ff ff       	call   80100360 <panic>
80103803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <growproc>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
80103815:	83 ec 10             	sub    $0x10,%esp
80103818:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010381b:	e8 b0 fe ff ff       	call   801036d0 <myproc>
  if(n > 0){
80103820:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103823:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103825:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103827:	7e 2f                	jle    80103858 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103829:	01 c6                	add    %eax,%esi
8010382b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010382f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103833:	8b 43 04             	mov    0x4(%ebx),%eax
80103836:	89 04 24             	mov    %eax,(%esp)
80103839:	e8 e2 33 00 00       	call   80106c20 <allocuvm>
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 36                	je     80103878 <growproc+0x68>
  curproc->sz = sz;
80103842:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103844:	89 1c 24             	mov    %ebx,(%esp)
80103847:	e8 84 31 00 00       	call   801069d0 <switchuvm>
  return 0;
8010384c:	31 c0                	xor    %eax,%eax
}
8010384e:	83 c4 10             	add    $0x10,%esp
80103851:	5b                   	pop    %ebx
80103852:	5e                   	pop    %esi
80103853:	5d                   	pop    %ebp
80103854:	c3                   	ret    
80103855:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103858:	74 e8                	je     80103842 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010385a:	01 c6                	add    %eax,%esi
8010385c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103860:	89 44 24 04          	mov    %eax,0x4(%esp)
80103864:	8b 43 04             	mov    0x4(%ebx),%eax
80103867:	89 04 24             	mov    %eax,(%esp)
8010386a:	e8 a1 34 00 00       	call   80106d10 <deallocuvm>
8010386f:	85 c0                	test   %eax,%eax
80103871:	75 cf                	jne    80103842 <growproc+0x32>
80103873:	90                   	nop
80103874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010387d:	eb cf                	jmp    8010384e <growproc+0x3e>
8010387f:	90                   	nop

80103880 <fork>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103889:	e8 42 fe ff ff       	call   801036d0 <myproc>
8010388e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103890:	e8 2b fc ff ff       	call   801034c0 <allocproc>
80103895:	85 c0                	test   %eax,%eax
80103897:	89 c7                	mov    %eax,%edi
80103899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010389c:	0f 84 bc 00 00 00    	je     8010395e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038a2:	8b 03                	mov    (%ebx),%eax
801038a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038a8:	8b 43 04             	mov    0x4(%ebx),%eax
801038ab:	89 04 24             	mov    %eax,(%esp)
801038ae:	e8 dd 35 00 00       	call   80106e90 <copyuvm>
801038b3:	85 c0                	test   %eax,%eax
801038b5:	89 47 04             	mov    %eax,0x4(%edi)
801038b8:	0f 84 a7 00 00 00    	je     80103965 <fork+0xe5>
  np->sz = curproc->sz;
801038be:	8b 03                	mov    (%ebx),%eax
801038c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038c3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038c5:	8b 79 18             	mov    0x18(%ecx),%edi
801038c8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038ca:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038cd:	8b 73 18             	mov    0x18(%ebx),%esi
801038d0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038d7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038d9:	8b 40 18             	mov    0x18(%eax),%eax
801038dc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038e3:	90                   	nop
801038e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038ec:	85 c0                	test   %eax,%eax
801038ee:	74 0f                	je     801038ff <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038f0:	89 04 24             	mov    %eax,(%esp)
801038f3:	e8 e8 d4 ff ff       	call   80100de0 <filedup>
801038f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038fb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038ff:	83 c6 01             	add    $0x1,%esi
80103902:	83 fe 10             	cmp    $0x10,%esi
80103905:	75 e1                	jne    801038e8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103907:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010390d:	89 04 24             	mov    %eax,(%esp)
80103910:	e8 6b dd ff ff       	call   80101680 <idup>
80103915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103918:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010391b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010391e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103922:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103929:	00 
8010392a:	89 04 24             	mov    %eax,(%esp)
8010392d:	e8 ce 0e 00 00       	call   80104800 <safestrcpy>
  pid = np->pid;
80103932:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103935:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
8010393c:	e8 1f 0c 00 00       	call   80104560 <acquire>
  np->state = RUNNABLE;
80103941:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103948:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
8010394f:	e8 7c 0c 00 00       	call   801045d0 <release>
  return pid;
80103954:	89 d8                	mov    %ebx,%eax
}
80103956:	83 c4 1c             	add    $0x1c,%esp
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5f                   	pop    %edi
8010395c:	5d                   	pop    %ebp
8010395d:	c3                   	ret    
    return -1;
8010395e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103963:	eb f1                	jmp    80103956 <fork+0xd6>
    kfree(np->kstack);
80103965:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103968:	8b 47 08             	mov    0x8(%edi),%eax
8010396b:	89 04 24             	mov    %eax,(%esp)
8010396e:	e8 7d e9 ff ff       	call   801022f0 <kfree>
    return -1;
80103973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103978:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010397f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103986:	eb ce                	jmp    80103956 <fork+0xd6>
80103988:	90                   	nop
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103990 <scheduler>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
struct cpu *c = mycpu();
80103999:	e8 92 fc ff ff       	call   80103630 <mycpu>
8010399e:	89 c3                	mov    %eax,%ebx
c->proc = 0;
801039a0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039a7:	00 00 00 
801039aa:	8d 70 04             	lea    0x4(%eax),%esi
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039b0:	fb                   	sti    
   acquire(&ptable.lock);
801039b1:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801039b8:	e8 a3 0b 00 00       	call   80104560 <acquire>
   for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
801039bd:	b8 14 37 11 80       	mov    $0x80113714,%eax
       if(p->state!=RUNNABLE)
801039c2:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801039c6:	0f 84 cc 00 00 00    	je     80103a98 <scheduler+0x108>
   for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
801039cc:	05 90 00 00 00       	add    $0x90,%eax
801039d1:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
801039d6:	75 ea                	jne    801039c2 <scheduler+0x32>
   int minpass=0;
801039d8:	31 c0                	xor    %eax,%eax
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039e0:	ba 14 37 11 80       	mov    $0x80113714,%edx
801039e5:	eb 0f                	jmp    801039f6 <scheduler+0x66>
801039e7:	90                   	nop
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e8:	81 c2 90 00 00 00    	add    $0x90,%edx
801039ee:	81 fa 14 5b 11 80    	cmp    $0x80115b14,%edx
801039f4:	74 1f                	je     80103a15 <scheduler+0x85>
       if(p->state != RUNNABLE){
801039f6:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801039fa:	75 ec                	jne    801039e8 <scheduler+0x58>
       if(p->passvalue<minpass)
801039fc:	8b 8a 84 00 00 00    	mov    0x84(%edx),%ecx
80103a02:	39 c8                	cmp    %ecx,%eax
80103a04:	0f 4f c1             	cmovg  %ecx,%eax
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a07:	81 c2 90 00 00 00    	add    $0x90,%edx
80103a0d:	81 fa 14 5b 11 80    	cmp    $0x80115b14,%edx
80103a13:	75 e1                	jne    801039f6 <scheduler+0x66>
80103a15:	bf 14 37 11 80       	mov    $0x80113714,%edi
80103a1a:	eb 12                	jmp    80103a2e <scheduler+0x9e>
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a20:	81 c7 90 00 00 00    	add    $0x90,%edi
80103a26:	81 ff 14 5b 11 80    	cmp    $0x80115b14,%edi
80103a2c:	74 54                	je     80103a82 <scheduler+0xf2>
       if(p->state != RUNNABLE)
80103a2e:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103a32:	75 ec                	jne    80103a20 <scheduler+0x90>
       if(p->passvalue!=minpass)
80103a34:	3b 87 84 00 00 00    	cmp    0x84(%edi),%eax
80103a3a:	75 e4                	jne    80103a20 <scheduler+0x90>
     p->passvalue=p->passvalue+p->stride;
80103a3c:	03 87 88 00 00 00    	add    0x88(%edi),%eax
     p->ticks=p->ticks+1;
80103a42:	83 87 8c 00 00 00 01 	addl   $0x1,0x8c(%edi)
     p->passvalue=p->passvalue+p->stride;
80103a49:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
     c->proc = p;
80103a4f:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
     switchuvm(p);
80103a55:	89 3c 24             	mov    %edi,(%esp)
80103a58:	e8 73 2f 00 00       	call   801069d0 <switchuvm>
     swtch(&(c->scheduler), p->context);
80103a5d:	8b 47 1c             	mov    0x1c(%edi),%eax
80103a60:	89 34 24             	mov    %esi,(%esp)
     p->state = RUNNING;
80103a63:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
     swtch(&(c->scheduler), p->context);
80103a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a6e:	e8 e8 0d 00 00       	call   8010485b <swtch>
     switchkvm();
80103a73:	e8 38 2f 00 00       	call   801069b0 <switchkvm>
     c->proc = 0;
80103a78:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103a7f:	00 00 00 
   release(&ptable.lock);
80103a82:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103a89:	e8 42 0b 00 00       	call   801045d0 <release>
 }
80103a8e:	e9 1d ff ff ff       	jmp    801039b0 <scheduler+0x20>
80103a93:	90                   	nop
80103a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       minpass=p->passvalue;
80103a98:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
       break;
80103a9e:	e9 3d ff ff ff       	jmp    801039e0 <scheduler+0x50>
80103aa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <sched>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103ab8:	e8 13 fc ff ff       	call   801036d0 <myproc>
  if(!holding(&ptable.lock))
80103abd:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
  struct proc *p = myproc();
80103ac4:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103ac6:	e8 55 0a 00 00       	call   80104520 <holding>
80103acb:	85 c0                	test   %eax,%eax
80103acd:	74 4f                	je     80103b1e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103acf:	e8 5c fb ff ff       	call   80103630 <mycpu>
80103ad4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103adb:	75 65                	jne    80103b42 <sched+0x92>
  if(p->state == RUNNING)
80103add:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ae1:	74 53                	je     80103b36 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae3:	9c                   	pushf  
80103ae4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ae5:	f6 c4 02             	test   $0x2,%ah
80103ae8:	75 40                	jne    80103b2a <sched+0x7a>
  intena = mycpu()->intena;
80103aea:	e8 41 fb ff ff       	call   80103630 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103aef:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103af2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103af8:	e8 33 fb ff ff       	call   80103630 <mycpu>
80103afd:	8b 40 04             	mov    0x4(%eax),%eax
80103b00:	89 1c 24             	mov    %ebx,(%esp)
80103b03:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b07:	e8 4f 0d 00 00       	call   8010485b <swtch>
  mycpu()->intena = intena;
80103b0c:	e8 1f fb ff ff       	call   80103630 <mycpu>
80103b11:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	5b                   	pop    %ebx
80103b1b:	5e                   	pop    %esi
80103b1c:	5d                   	pop    %ebp
80103b1d:	c3                   	ret    
    panic("sched ptable.lock");
80103b1e:	c7 04 24 b0 77 10 80 	movl   $0x801077b0,(%esp)
80103b25:	e8 36 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103b2a:	c7 04 24 dc 77 10 80 	movl   $0x801077dc,(%esp)
80103b31:	e8 2a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b36:	c7 04 24 ce 77 10 80 	movl   $0x801077ce,(%esp)
80103b3d:	e8 1e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b42:	c7 04 24 c2 77 10 80 	movl   $0x801077c2,(%esp)
80103b49:	e8 12 c8 ff ff       	call   80100360 <panic>
80103b4e:	66 90                	xchg   %ax,%ax

80103b50 <exit>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	bf 80 37 11 80       	mov    $0x80113780,%edi
80103b59:	56                   	push   %esi
80103b5a:	53                   	push   %ebx
80103b5b:	83 ec 3c             	sub    $0x3c,%esp
  struct proc *curproc = myproc();
80103b5e:	e8 6d fb ff ff       	call   801036d0 <myproc>
80103b63:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103b66:	66 90                	xchg   %ax,%ax
      if(p->state == UNUSED)
80103b68:	8b 47 a0             	mov    -0x60(%edi),%eax
80103b6b:	85 c0                	test   %eax,%eax
80103b6d:	74 6e                	je     80103bdd <exit+0x8d>
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b6f:	83 f8 05             	cmp    $0x5,%eax
        state = "???";
80103b72:	bb f0 77 10 80       	mov    $0x801077f0,%ebx
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b77:	77 11                	ja     80103b8a <exit+0x3a>
80103b79:	8b 1c 85 b8 79 10 80 	mov    -0x7fef8648(,%eax,4),%ebx
        state = "???";
80103b80:	b8 f0 77 10 80       	mov    $0x801077f0,%eax
80103b85:	85 db                	test   %ebx,%ebx
80103b87:	0f 44 d8             	cmove  %eax,%ebx
      cprintf("From  %s-%d: %d %s %s sched_times=%d ticket=%d \n", myproc()->name, myproc()->pid, p->pid, state, p->name, p->ticks, p->tickets);
80103b8a:	8b 4f 14             	mov    0x14(%edi),%ecx
80103b8d:	8b 57 20             	mov    0x20(%edi),%edx
80103b90:	8b 47 a4             	mov    -0x5c(%edi),%eax
80103b93:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80103b96:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b9c:	e8 2f fb ff ff       	call   801036d0 <myproc>
80103ba1:	8b 70 10             	mov    0x10(%eax),%esi
80103ba4:	e8 27 fb ff ff       	call   801036d0 <myproc>
80103ba9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80103bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103baf:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80103bb3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bb6:	89 7c 24 14          	mov    %edi,0x14(%esp)
80103bba:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80103bbe:	89 54 24 18          	mov    %edx,0x18(%esp)
80103bc2:	83 c0 6c             	add    $0x6c,%eax
80103bc5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103bc9:	89 74 24 08          	mov    %esi,0x8(%esp)
80103bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bd1:	c7 04 24 9c 78 10 80 	movl   $0x8010789c,(%esp)
80103bd8:	e8 73 ca ff ff       	call   80100650 <cprintf>
80103bdd:	81 c7 90 00 00 00    	add    $0x90,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103be3:	81 ff 80 5b 11 80    	cmp    $0x80115b80,%edi
80103be9:	0f 85 79 ff ff ff    	jne    80103b68 <exit+0x18>
80103bef:	8b 75 d8             	mov    -0x28(%ebp),%esi
  if(curproc == initproc)
80103bf2:	31 db                	xor    %ebx,%ebx
80103bf4:	3b 35 b8 a5 10 80    	cmp    0x8010a5b8,%esi
80103bfa:	0f 84 f0 00 00 00    	je     80103cf0 <exit+0x1a0>
    if(curproc->ofile[fd]){
80103c00:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103c04:	85 c0                	test   %eax,%eax
80103c06:	74 10                	je     80103c18 <exit+0xc8>
      fileclose(curproc->ofile[fd]);
80103c08:	89 04 24             	mov    %eax,(%esp)
80103c0b:	e8 20 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c10:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
80103c17:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103c18:	83 c3 01             	add    $0x1,%ebx
80103c1b:	83 fb 10             	cmp    $0x10,%ebx
80103c1e:	75 e0                	jne    80103c00 <exit+0xb0>
  begin_op();
80103c20:	e8 eb ee ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103c25:	8b 46 68             	mov    0x68(%esi),%eax
80103c28:	89 04 24             	mov    %eax,(%esp)
80103c2b:	e8 a0 db ff ff       	call   801017d0 <iput>
  end_op();
80103c30:	e8 4b ef ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103c35:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock); 
80103c3c:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103c43:	e8 18 09 00 00       	call   80104560 <acquire>
  wakeup1(curproc->parent);
80103c48:	8b 56 14             	mov    0x14(%esi),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c4b:	b8 14 37 11 80       	mov    $0x80113714,%eax
80103c50:	eb 12                	jmp    80103c64 <exit+0x114>
80103c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c58:	05 90 00 00 00       	add    $0x90,%eax
80103c5d:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103c62:	74 1e                	je     80103c82 <exit+0x132>
    if(p->state == SLEEPING && p->chan == chan)
80103c64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c68:	75 ee                	jne    80103c58 <exit+0x108>
80103c6a:	3b 50 20             	cmp    0x20(%eax),%edx
80103c6d:	75 e9                	jne    80103c58 <exit+0x108>
      p->state = RUNNABLE;
80103c6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c76:	05 90 00 00 00       	add    $0x90,%eax
80103c7b:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103c80:	75 e2                	jne    80103c64 <exit+0x114>
      p->parent = initproc;
80103c82:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c88:	ba 14 37 11 80       	mov    $0x80113714,%edx
80103c8d:	eb 0f                	jmp    80103c9e <exit+0x14e>
80103c8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c90:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c96:	81 fa 14 5b 11 80    	cmp    $0x80115b14,%edx
80103c9c:	74 3a                	je     80103cd8 <exit+0x188>
    if(p->parent == curproc){
80103c9e:	39 72 14             	cmp    %esi,0x14(%edx)
80103ca1:	75 ed                	jne    80103c90 <exit+0x140>
      if(p->state == ZOMBIE)
80103ca3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ca7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103caa:	75 e4                	jne    80103c90 <exit+0x140>
80103cac:	b8 14 37 11 80       	mov    $0x80113714,%eax
80103cb1:	eb 11                	jmp    80103cc4 <exit+0x174>
80103cb3:	90                   	nop
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb8:	05 90 00 00 00       	add    $0x90,%eax
80103cbd:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103cc2:	74 cc                	je     80103c90 <exit+0x140>
    if(p->state == SLEEPING && p->chan == chan)
80103cc4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cc8:	75 ee                	jne    80103cb8 <exit+0x168>
80103cca:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ccd:	75 e9                	jne    80103cb8 <exit+0x168>
      p->state = RUNNABLE;
80103ccf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103cd6:	eb e0                	jmp    80103cb8 <exit+0x168>
  curproc->state = ZOMBIE;
80103cd8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103cdf:	e8 cc fd ff ff       	call   80103ab0 <sched>
  panic("zombie exit");
80103ce4:	c7 04 24 01 78 10 80 	movl   $0x80107801,(%esp)
80103ceb:	e8 70 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103cf0:	c7 04 24 f4 77 10 80 	movl   $0x801077f4,(%esp)
80103cf7:	e8 64 c6 ff ff       	call   80100360 <panic>
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d00 <yield>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d06:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103d0d:	e8 4e 08 00 00       	call   80104560 <acquire>
  myproc()->state = RUNNABLE;
80103d12:	e8 b9 f9 ff ff       	call   801036d0 <myproc>
80103d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103d1e:	e8 8d fd ff ff       	call   80103ab0 <sched>
  release(&ptable.lock);
80103d23:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103d2a:	e8 a1 08 00 00       	call   801045d0 <release>
}
80103d2f:	c9                   	leave  
80103d30:	c3                   	ret    
80103d31:	eb 0d                	jmp    80103d40 <sleep>
80103d33:	90                   	nop
80103d34:	90                   	nop
80103d35:	90                   	nop
80103d36:	90                   	nop
80103d37:	90                   	nop
80103d38:	90                   	nop
80103d39:	90                   	nop
80103d3a:	90                   	nop
80103d3b:	90                   	nop
80103d3c:	90                   	nop
80103d3d:	90                   	nop
80103d3e:	90                   	nop
80103d3f:	90                   	nop

80103d40 <sleep>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	83 ec 1c             	sub    $0x1c,%esp
80103d49:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d4f:	e8 7c f9 ff ff       	call   801036d0 <myproc>
  if(p == 0)
80103d54:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103d56:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103d58:	0f 84 7c 00 00 00    	je     80103dda <sleep+0x9a>
  if(lk == 0)
80103d5e:	85 f6                	test   %esi,%esi
80103d60:	74 6c                	je     80103dce <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d62:	81 fe e0 36 11 80    	cmp    $0x801136e0,%esi
80103d68:	74 46                	je     80103db0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d6a:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103d71:	e8 ea 07 00 00       	call   80104560 <acquire>
    release(lk);
80103d76:	89 34 24             	mov    %esi,(%esp)
80103d79:	e8 52 08 00 00       	call   801045d0 <release>
  p->chan = chan;
80103d7e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d81:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103d88:	e8 23 fd ff ff       	call   80103ab0 <sched>
  p->chan = 0;
80103d8d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d94:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103d9b:	e8 30 08 00 00       	call   801045d0 <release>
    acquire(lk);
80103da0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103da3:	83 c4 1c             	add    $0x1c,%esp
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5f                   	pop    %edi
80103da9:	5d                   	pop    %ebp
    acquire(lk);
80103daa:	e9 b1 07 00 00       	jmp    80104560 <acquire>
80103daf:	90                   	nop
  p->chan = chan;
80103db0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103db3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103dba:	e8 f1 fc ff ff       	call   80103ab0 <sched>
  p->chan = 0;
80103dbf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103dc6:	83 c4 1c             	add    $0x1c,%esp
80103dc9:	5b                   	pop    %ebx
80103dca:	5e                   	pop    %esi
80103dcb:	5f                   	pop    %edi
80103dcc:	5d                   	pop    %ebp
80103dcd:	c3                   	ret    
    panic("sleep without lk");
80103dce:	c7 04 24 13 78 10 80 	movl   $0x80107813,(%esp)
80103dd5:	e8 86 c5 ff ff       	call   80100360 <panic>
    panic("sleep");
80103dda:	c7 04 24 0d 78 10 80 	movl   $0x8010780d,(%esp)
80103de1:	e8 7a c5 ff ff       	call   80100360 <panic>
80103de6:	8d 76 00             	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <wait>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	56                   	push   %esi
80103df4:	53                   	push   %ebx
80103df5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103df8:	e8 d3 f8 ff ff       	call   801036d0 <myproc>
  acquire(&ptable.lock);
80103dfd:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
  struct proc *curproc = myproc();
80103e04:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103e06:	e8 55 07 00 00       	call   80104560 <acquire>
    havekids = 0;
80103e0b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0d:	bb 14 37 11 80       	mov    $0x80113714,%ebx
80103e12:	eb 12                	jmp    80103e26 <wait+0x36>
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e18:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103e1e:	81 fb 14 5b 11 80    	cmp    $0x80115b14,%ebx
80103e24:	74 22                	je     80103e48 <wait+0x58>
      if(p->parent != curproc)
80103e26:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e29:	75 ed                	jne    80103e18 <wait+0x28>
      if(p->state == ZOMBIE){
80103e2b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e2f:	74 34                	je     80103e65 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e31:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103e37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	81 fb 14 5b 11 80    	cmp    $0x80115b14,%ebx
80103e42:	75 e2                	jne    80103e26 <wait+0x36>
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103e48:	85 c0                	test   %eax,%eax
80103e4a:	74 6e                	je     80103eba <wait+0xca>
80103e4c:	8b 46 24             	mov    0x24(%esi),%eax
80103e4f:	85 c0                	test   %eax,%eax
80103e51:	75 67                	jne    80103eba <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e53:	c7 44 24 04 e0 36 11 	movl   $0x801136e0,0x4(%esp)
80103e5a:	80 
80103e5b:	89 34 24             	mov    %esi,(%esp)
80103e5e:	e8 dd fe ff ff       	call   80103d40 <sleep>
  }
80103e63:	eb a6                	jmp    80103e0b <wait+0x1b>
        kfree(p->kstack);
80103e65:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103e68:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e6b:	89 04 24             	mov    %eax,(%esp)
80103e6e:	e8 7d e4 ff ff       	call   801022f0 <kfree>
        freevm(p->pgdir);
80103e73:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103e76:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e7d:	89 04 24             	mov    %eax,(%esp)
80103e80:	e8 ab 2e 00 00       	call   80106d30 <freevm>
        release(&ptable.lock);
80103e85:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
        p->pid = 0;
80103e8c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e93:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e9a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e9e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ea5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103eac:	e8 1f 07 00 00       	call   801045d0 <release>
}
80103eb1:	83 c4 10             	add    $0x10,%esp
        return pid;
80103eb4:	89 f0                	mov    %esi,%eax
}
80103eb6:	5b                   	pop    %ebx
80103eb7:	5e                   	pop    %esi
80103eb8:	5d                   	pop    %ebp
80103eb9:	c3                   	ret    
      release(&ptable.lock);
80103eba:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103ec1:	e8 0a 07 00 00       	call   801045d0 <release>
}
80103ec6:	83 c4 10             	add    $0x10,%esp
      return -1;
80103ec9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ece:	5b                   	pop    %ebx
80103ecf:	5e                   	pop    %esi
80103ed0:	5d                   	pop    %ebp
80103ed1:	c3                   	ret    
80103ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ee0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	53                   	push   %ebx
80103ee4:	83 ec 14             	sub    $0x14,%esp
80103ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eea:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103ef1:	e8 6a 06 00 00       	call   80104560 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ef6:	b8 14 37 11 80       	mov    $0x80113714,%eax
80103efb:	eb 0f                	jmp    80103f0c <wakeup+0x2c>
80103efd:	8d 76 00             	lea    0x0(%esi),%esi
80103f00:	05 90 00 00 00       	add    $0x90,%eax
80103f05:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103f0a:	74 24                	je     80103f30 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103f0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f10:	75 ee                	jne    80103f00 <wakeup+0x20>
80103f12:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f15:	75 e9                	jne    80103f00 <wakeup+0x20>
      p->state = RUNNABLE;
80103f17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1e:	05 90 00 00 00       	add    $0x90,%eax
80103f23:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103f28:	75 e2                	jne    80103f0c <wakeup+0x2c>
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103f30:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
80103f37:	83 c4 14             	add    $0x14,%esp
80103f3a:	5b                   	pop    %ebx
80103f3b:	5d                   	pop    %ebp
  release(&ptable.lock);
80103f3c:	e9 8f 06 00 00       	jmp    801045d0 <release>
80103f41:	eb 0d                	jmp    80103f50 <kill>
80103f43:	90                   	nop
80103f44:	90                   	nop
80103f45:	90                   	nop
80103f46:	90                   	nop
80103f47:	90                   	nop
80103f48:	90                   	nop
80103f49:	90                   	nop
80103f4a:	90                   	nop
80103f4b:	90                   	nop
80103f4c:	90                   	nop
80103f4d:	90                   	nop
80103f4e:	90                   	nop
80103f4f:	90                   	nop

80103f50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 14             	sub    $0x14,%esp
80103f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f5a:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103f61:	e8 fa 05 00 00       	call   80104560 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f66:	b8 14 37 11 80       	mov    $0x80113714,%eax
80103f6b:	eb 0f                	jmp    80103f7c <kill+0x2c>
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
80103f70:	05 90 00 00 00       	add    $0x90,%eax
80103f75:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80103f7a:	74 3c                	je     80103fb8 <kill+0x68>
    if(p->pid == pid){
80103f7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f7f:	75 ef                	jne    80103f70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103f85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103f8c:	74 1a                	je     80103fa8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f8e:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103f95:	e8 36 06 00 00       	call   801045d0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f9a:	83 c4 14             	add    $0x14,%esp
      return 0;
80103f9d:	31 c0                	xor    %eax,%eax
}
80103f9f:	5b                   	pop    %ebx
80103fa0:	5d                   	pop    %ebp
80103fa1:	c3                   	ret    
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103fa8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103faf:	eb dd                	jmp    80103f8e <kill+0x3e>
80103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103fb8:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80103fbf:	e8 0c 06 00 00       	call   801045d0 <release>
}
80103fc4:	83 c4 14             	add    $0x14,%esp
  return -1;
80103fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fcc:	5b                   	pop    %ebx
80103fcd:	5d                   	pop    %ebp
80103fce:	c3                   	ret    
80103fcf:	90                   	nop

80103fd0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103fdb:	83 ec 4c             	sub    $0x4c,%esp
80103fde:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fe1:	eb 23                	jmp    80104006 <procdump+0x36>
80103fe3:	90                   	nop
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fe8:	c7 04 24 e3 7c 10 80 	movl   $0x80107ce3,(%esp)
80103fef:	e8 5c c6 ff ff       	call   80100650 <cprintf>
80103ff4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffa:	81 fb 80 5b 11 80    	cmp    $0x80115b80,%ebx
80104000:	0f 84 8a 00 00 00    	je     80104090 <procdump+0xc0>
    if(p->state == UNUSED)
80104006:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104009:	85 c0                	test   %eax,%eax
8010400b:	74 e7                	je     80103ff4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010400d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104010:	ba f0 77 10 80       	mov    $0x801077f0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104015:	77 11                	ja     80104028 <procdump+0x58>
80104017:	8b 14 85 a0 79 10 80 	mov    -0x7fef8660(,%eax,4),%edx
      state = "???";
8010401e:	b8 f0 77 10 80       	mov    $0x801077f0,%eax
80104023:	85 d2                	test   %edx,%edx
80104025:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104028:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010402b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010402f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104033:	c7 04 24 24 78 10 80 	movl   $0x80107824,(%esp)
8010403a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010403e:	e8 0d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104043:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104047:	75 9f                	jne    80103fe8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104049:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010404c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104050:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104053:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104056:	8b 40 0c             	mov    0xc(%eax),%eax
80104059:	83 c0 08             	add    $0x8,%eax
8010405c:	89 04 24             	mov    %eax,(%esp)
8010405f:	e8 ac 03 00 00       	call   80104410 <getcallerpcs>
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104068:	8b 17                	mov    (%edi),%edx
8010406a:	85 d2                	test   %edx,%edx
8010406c:	0f 84 76 ff ff ff    	je     80103fe8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104072:	89 54 24 04          	mov    %edx,0x4(%esp)
80104076:	83 c7 04             	add    $0x4,%edi
80104079:	c7 04 24 61 72 10 80 	movl   $0x80107261,(%esp)
80104080:	e8 cb c5 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104085:	39 f7                	cmp    %esi,%edi
80104087:	75 df                	jne    80104068 <procdump+0x98>
80104089:	e9 5a ff ff ff       	jmp    80103fe8 <procdump+0x18>
8010408e:	66 90                	xchg   %ax,%ax
  }
}
80104090:	83 c4 4c             	add    $0x4c,%esp
80104093:	5b                   	pop    %ebx
80104094:	5e                   	pop    %esi
80104095:	5f                   	pop    %edi
80104096:	5d                   	pop    %ebp
80104097:	c3                   	ret    
80104098:	90                   	nop
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040a0 <info>:
//return a count of the processes in the system
int info(int param)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 14             	sub    $0x14,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  asm volatile("sti");
801040aa:	fb                   	sti    
	
	sti();
	acquire(&ptable.lock);
801040ab:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801040b2:	e8 a9 04 00 00       	call   80104560 <acquire>
	struct proc *p;
	uint sz;
	struct proc *myp=myproc();
801040b7:	e8 14 f6 ff ff       	call   801036d0 <myproc>
	int num=0;
	if(param==1)// print the count of the processes in the system
801040bc:	83 fb 01             	cmp    $0x1,%ebx
801040bf:	74 37                	je     801040f8 <info+0x58>
	
		}
		
		cprintf("the count of the processes in the system is : %d\n",num);
	}
	else if(param==2)
801040c1:	83 fb 02             	cmp    $0x2,%ebx
801040c4:	74 64                	je     8010412a <info+0x8a>
		struct proc *m=myproc();
		int num=m->sysnum;	
		cprintf("the total number of system calls is : %d\n", num);
		
	}
	else if(param==3)
801040c6:	83 fb 03             	cmp    $0x3,%ebx
801040c9:	0f 84 81 00 00 00    	je     80104150 <info+0xb0>
	{
		sz=myp->sz;
		num=sz/PGSIZE;
		cprintf("the number of the pages of this process is: %d\n",num);
	}
	else if (param==4)
801040cf:	83 fb 04             	cmp    $0x4,%ebx
801040d2:	74 70                	je     80104144 <info+0xa4>
	{
		return myp->ticks;
	}
	else cprintf("doesn't have this function\n");
801040d4:	c7 04 24 2d 78 10 80 	movl   $0x8010782d,(%esp)
801040db:	e8 70 c5 ff ff       	call   80100650 <cprintf>
	release(&ptable.lock);
801040e0:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801040e7:	e8 e4 04 00 00       	call   801045d0 <release>
	return 22;
}
801040ec:	83 c4 14             	add    $0x14,%esp
	return 22;
801040ef:	b8 16 00 00 00       	mov    $0x16,%eax
}
801040f4:	5b                   	pop    %ebx
801040f5:	5d                   	pop    %ebp
801040f6:	c3                   	ret    
801040f7:	90                   	nop
	if(param==1)// print the count of the processes in the system
801040f8:	31 d2                	xor    %edx,%edx
801040fa:	b8 14 37 11 80       	mov    $0x80113714,%eax
801040ff:	90                   	nop
		      if(p->state==RUNNING||p->state==SLEEPING||p->state==RUNNABLE)	num++;
80104100:	8b 58 0c             	mov    0xc(%eax),%ebx
80104103:	8d 4b fe             	lea    -0x2(%ebx),%ecx
80104106:	83 f9 03             	cmp    $0x3,%ecx
80104109:	83 d2 00             	adc    $0x0,%edx
		for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
8010410c:	05 90 00 00 00       	add    $0x90,%eax
80104111:	3d 14 5b 11 80       	cmp    $0x80115b14,%eax
80104116:	75 e8                	jne    80104100 <info+0x60>
		cprintf("the count of the processes in the system is : %d\n",num);
80104118:	89 54 24 04          	mov    %edx,0x4(%esp)
8010411c:	c7 04 24 d0 78 10 80 	movl   $0x801078d0,(%esp)
80104123:	e8 28 c5 ff ff       	call   80100650 <cprintf>
80104128:	eb b6                	jmp    801040e0 <info+0x40>
		struct proc *m=myproc();
8010412a:	e8 a1 f5 ff ff       	call   801036d0 <myproc>
		cprintf("the total number of system calls is : %d\n", num);
8010412f:	8b 40 7c             	mov    0x7c(%eax),%eax
80104132:	c7 04 24 04 79 10 80 	movl   $0x80107904,(%esp)
80104139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010413d:	e8 0e c5 ff ff       	call   80100650 <cprintf>
80104142:	eb 9c                	jmp    801040e0 <info+0x40>
		return myp->ticks;
80104144:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
}
8010414a:	83 c4 14             	add    $0x14,%esp
8010414d:	5b                   	pop    %ebx
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    
		num=sz/PGSIZE;
80104150:	8b 00                	mov    (%eax),%eax
		cprintf("the number of the pages of this process is: %d\n",num);
80104152:	c7 04 24 30 79 10 80 	movl   $0x80107930,(%esp)
		num=sz/PGSIZE;
80104159:	c1 e8 0c             	shr    $0xc,%eax
		cprintf("the number of the pages of this process is: %d\n",num);
8010415c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104160:	e8 eb c4 ff ff       	call   80100650 <cprintf>
80104165:	e9 76 ff ff ff       	jmp    801040e0 <info+0x40>
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104170 <settick>:
int settick(int tick)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	53                   	push   %ebx
80104174:	83 ec 14             	sub    $0x14,%esp
80104177:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010417a:	fb                   	sti    
	sti();
	acquire(&ptable.lock);
8010417b:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80104182:	e8 d9 03 00 00       	call   80104560 <acquire>
	struct proc *myp=myproc();
80104187:	e8 44 f5 ff ff       	call   801036d0 <myproc>
	if(tick<1) 
8010418c:	85 db                	test   %ebx,%ebx
8010418e:	7e 38                	jle    801041c8 <settick+0x58>
		return 23;
	}
	else
	{
		
		myp->tickets = tick;
80104190:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
80104196:	89 c1                	mov    %eax,%ecx
		myp->stride =60/ myp->tickets;
80104198:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010419d:	99                   	cltd   
8010419e:	f7 fb                	idiv   %ebx
801041a0:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
		myp->passvalue=myp->stride;
801041a6:	89 81 84 00 00 00    	mov    %eax,0x84(%ecx)
	
	}
	release(&ptable.lock);
801041ac:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
801041b3:	e8 18 04 00 00       	call   801045d0 <release>
	return 23;

}
801041b8:	83 c4 14             	add    $0x14,%esp
801041bb:	b8 17 00 00 00       	mov    $0x17,%eax
801041c0:	5b                   	pop    %ebx
801041c1:	5d                   	pop    %ebp
801041c2:	c3                   	ret    
801041c3:	90                   	nop
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("the number of ticket is invalidation!\n");
801041c8:	c7 04 24 60 79 10 80 	movl   $0x80107960,(%esp)
801041cf:	e8 7c c4 ff ff       	call   80100650 <cprintf>
}
801041d4:	83 c4 14             	add    $0x14,%esp
801041d7:	b8 17 00 00 00       	mov    $0x17,%eax
801041dc:	5b                   	pop    %ebx
801041dd:	5d                   	pop    %ebp
801041de:	c3                   	ret    
801041df:	90                   	nop

801041e0 <tickprintf>:
int tickprintf(int para)
{   
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801041eb:	83 ec 3c             	sub    $0x3c,%esp
    if(para==0) return 24;
801041ee:	8b 45 08             	mov    0x8(%ebp),%eax
801041f1:	85 c0                	test   %eax,%eax
801041f3:	75 1d                	jne    80104212 <tickprintf+0x32>
801041f5:	e9 ae 00 00 00       	jmp    801042a8 <tickprintf+0xc8>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104200:	81 c3 90 00 00 00    	add    $0x90,%ebx
    [ZOMBIE]    "zombie"
    };
 
   
    char *state;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104206:	81 fb 80 5b 11 80    	cmp    $0x80115b80,%ebx
8010420c:	0f 84 96 00 00 00    	je     801042a8 <tickprintf+0xc8>
      if(p->state == UNUSED)
80104212:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	74 e7                	je     80104200 <tickprintf+0x20>
        continue;
     
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104219:	83 f8 05             	cmp    $0x5,%eax
        state = states[p->state];
      else
        state = "???";
8010421c:	be f0 77 10 80       	mov    $0x801077f0,%esi
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104221:	77 11                	ja     80104234 <tickprintf+0x54>
80104223:	8b 34 85 88 79 10 80 	mov    -0x7fef8678(,%eax,4),%esi
        state = "???";
8010422a:	ba f0 77 10 80       	mov    $0x801077f0,%edx
8010422f:	85 f6                	test   %esi,%esi
80104231:	0f 44 f2             	cmove  %edx,%esi
      if(p->state==RUNNING||p->state==RUNNABLE){
80104234:	83 e8 03             	sub    $0x3,%eax
80104237:	83 f8 01             	cmp    $0x1,%eax
8010423a:	77 c4                	ja     80104200 <tickprintf+0x20>
      cprintf("From  %s-%d: %d %s %s sched_times=%d ticket=%d \n", myproc()->name, myproc()->pid, p->pid, state, p->name, p->ticks, p->tickets);
8010423c:	8b 4b 14             	mov    0x14(%ebx),%ecx
8010423f:	8b 53 20             	mov    0x20(%ebx),%edx
80104242:	8b 7b a4             	mov    -0x5c(%ebx),%edi
80104245:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80104248:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010424b:	e8 80 f4 ff ff       	call   801036d0 <myproc>
80104250:	8b 40 10             	mov    0x10(%eax),%eax
80104253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104256:	e8 75 f4 ff ff       	call   801036d0 <myproc>
8010425b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010425e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104261:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80104265:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104268:	89 5c 24 14          	mov    %ebx,0x14(%esp)
8010426c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104272:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80104276:	89 54 24 18          	mov    %edx,0x18(%esp)
8010427a:	83 c0 6c             	add    $0x6c,%eax
8010427d:	89 74 24 10          	mov    %esi,0x10(%esp)
80104281:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104285:	89 44 24 04          	mov    %eax,0x4(%esp)
80104289:	c7 04 24 9c 78 10 80 	movl   $0x8010789c,(%esp)
80104290:	e8 bb c3 ff ff       	call   80100650 <cprintf>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104295:	81 fb 80 5b 11 80    	cmp    $0x80115b80,%ebx
8010429b:	0f 85 71 ff ff ff    	jne    80104212 <tickprintf+0x32>
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     } 
    }
 return 24;
} 
801042a8:	83 c4 3c             	add    $0x3c,%esp
801042ab:	b8 18 00 00 00       	mov    $0x18,%eax
801042b0:	5b                   	pop    %ebx
801042b1:	5e                   	pop    %esi
801042b2:	5f                   	pop    %edi
801042b3:	5d                   	pop    %ebp
801042b4:	c3                   	ret    
801042b5:	66 90                	xchg   %ax,%ax
801042b7:	66 90                	xchg   %ax,%ax
801042b9:	66 90                	xchg   %ax,%ax
801042bb:	66 90                	xchg   %ax,%ax
801042bd:	66 90                	xchg   %ax,%ax
801042bf:	90                   	nop

801042c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 14             	sub    $0x14,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ca:	c7 44 24 04 d0 79 10 	movl   $0x801079d0,0x4(%esp)
801042d1:	80 
801042d2:	8d 43 04             	lea    0x4(%ebx),%eax
801042d5:	89 04 24             	mov    %eax,(%esp)
801042d8:	e8 13 01 00 00       	call   801043f0 <initlock>
  lk->name = name;
801042dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042e6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042ed:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042f0:	83 c4 14             	add    $0x14,%esp
801042f3:	5b                   	pop    %ebx
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
801042f6:	8d 76 00             	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	83 ec 10             	sub    $0x10,%esp
80104308:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010430b:	8d 73 04             	lea    0x4(%ebx),%esi
8010430e:	89 34 24             	mov    %esi,(%esp)
80104311:	e8 4a 02 00 00       	call   80104560 <acquire>
  while (lk->locked) {
80104316:	8b 13                	mov    (%ebx),%edx
80104318:	85 d2                	test   %edx,%edx
8010431a:	74 16                	je     80104332 <acquiresleep+0x32>
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104320:	89 74 24 04          	mov    %esi,0x4(%esp)
80104324:	89 1c 24             	mov    %ebx,(%esp)
80104327:	e8 14 fa ff ff       	call   80103d40 <sleep>
  while (lk->locked) {
8010432c:	8b 03                	mov    (%ebx),%eax
8010432e:	85 c0                	test   %eax,%eax
80104330:	75 ee                	jne    80104320 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104332:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104338:	e8 93 f3 ff ff       	call   801036d0 <myproc>
8010433d:	8b 40 10             	mov    0x10(%eax),%eax
80104340:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104343:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104346:	83 c4 10             	add    $0x10,%esp
80104349:	5b                   	pop    %ebx
8010434a:	5e                   	pop    %esi
8010434b:	5d                   	pop    %ebp
  release(&lk->lk);
8010434c:	e9 7f 02 00 00       	jmp    801045d0 <release>
80104351:	eb 0d                	jmp    80104360 <releasesleep>
80104353:	90                   	nop
80104354:	90                   	nop
80104355:	90                   	nop
80104356:	90                   	nop
80104357:	90                   	nop
80104358:	90                   	nop
80104359:	90                   	nop
8010435a:	90                   	nop
8010435b:	90                   	nop
8010435c:	90                   	nop
8010435d:	90                   	nop
8010435e:	90                   	nop
8010435f:	90                   	nop

80104360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	83 ec 10             	sub    $0x10,%esp
80104368:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010436b:	8d 73 04             	lea    0x4(%ebx),%esi
8010436e:	89 34 24             	mov    %esi,(%esp)
80104371:	e8 ea 01 00 00       	call   80104560 <acquire>
  lk->locked = 0;
80104376:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010437c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104383:	89 1c 24             	mov    %ebx,(%esp)
80104386:	e8 55 fb ff ff       	call   80103ee0 <wakeup>
  release(&lk->lk);
8010438b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010438e:	83 c4 10             	add    $0x10,%esp
80104391:	5b                   	pop    %ebx
80104392:	5e                   	pop    %esi
80104393:	5d                   	pop    %ebp
  release(&lk->lk);
80104394:	e9 37 02 00 00       	jmp    801045d0 <release>
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
801043a4:	31 ff                	xor    %edi,%edi
{
801043a6:	56                   	push   %esi
801043a7:	53                   	push   %ebx
801043a8:	83 ec 1c             	sub    $0x1c,%esp
801043ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043ae:	8d 73 04             	lea    0x4(%ebx),%esi
801043b1:	89 34 24             	mov    %esi,(%esp)
801043b4:	e8 a7 01 00 00       	call   80104560 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043b9:	8b 03                	mov    (%ebx),%eax
801043bb:	85 c0                	test   %eax,%eax
801043bd:	74 13                	je     801043d2 <holdingsleep+0x32>
801043bf:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043c2:	e8 09 f3 ff ff       	call   801036d0 <myproc>
801043c7:	3b 58 10             	cmp    0x10(%eax),%ebx
801043ca:	0f 94 c0             	sete   %al
801043cd:	0f b6 c0             	movzbl %al,%eax
801043d0:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801043d2:	89 34 24             	mov    %esi,(%esp)
801043d5:	e8 f6 01 00 00       	call   801045d0 <release>
  return r;
}
801043da:	83 c4 1c             	add    $0x1c,%esp
801043dd:	89 f8                	mov    %edi,%eax
801043df:	5b                   	pop    %ebx
801043e0:	5e                   	pop    %esi
801043e1:	5f                   	pop    %edi
801043e2:	5d                   	pop    %ebp
801043e3:	c3                   	ret    
801043e4:	66 90                	xchg   %ax,%ax
801043e6:	66 90                	xchg   %ax,%ax
801043e8:	66 90                	xchg   %ax,%ax
801043ea:	66 90                	xchg   %ax,%ax
801043ec:	66 90                	xchg   %ax,%ax
801043ee:	66 90                	xchg   %ax,%ax

801043f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801043f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801043f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret    
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104410 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104419:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010441a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010441d:	31 c0                	xor    %eax,%eax
8010441f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104420:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104426:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010442c:	77 1a                	ja     80104448 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010442e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104431:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104434:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104437:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104439:	83 f8 0a             	cmp    $0xa,%eax
8010443c:	75 e2                	jne    80104420 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010443e:	5b                   	pop    %ebx
8010443f:	5d                   	pop    %ebp
80104440:	c3                   	ret    
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104448:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010444f:	83 c0 01             	add    $0x1,%eax
80104452:	83 f8 0a             	cmp    $0xa,%eax
80104455:	74 e7                	je     8010443e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104457:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010445e:	83 c0 01             	add    $0x1,%eax
80104461:	83 f8 0a             	cmp    $0xa,%eax
80104464:	75 e2                	jne    80104448 <getcallerpcs+0x38>
80104466:	eb d6                	jmp    8010443e <getcallerpcs+0x2e>
80104468:	90                   	nop
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104477:	9c                   	pushf  
80104478:	5b                   	pop    %ebx
  asm volatile("cli");
80104479:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010447a:	e8 b1 f1 ff ff       	call   80103630 <mycpu>
8010447f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104485:	85 c0                	test   %eax,%eax
80104487:	75 11                	jne    8010449a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104489:	e8 a2 f1 ff ff       	call   80103630 <mycpu>
8010448e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104494:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010449a:	e8 91 f1 ff ff       	call   80103630 <mycpu>
8010449f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a6:	83 c4 04             	add    $0x4,%esp
801044a9:	5b                   	pop    %ebx
801044aa:	5d                   	pop    %ebp
801044ab:	c3                   	ret    
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <popcli>:

void
popcli(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044b6:	9c                   	pushf  
801044b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044b8:	f6 c4 02             	test   $0x2,%ah
801044bb:	75 49                	jne    80104506 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044bd:	e8 6e f1 ff ff       	call   80103630 <mycpu>
801044c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801044c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801044cb:	85 d2                	test   %edx,%edx
801044cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801044d3:	78 25                	js     801044fa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044d5:	e8 56 f1 ff ff       	call   80103630 <mycpu>
801044da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044e0:	85 d2                	test   %edx,%edx
801044e2:	74 04                	je     801044e8 <popcli+0x38>
    sti();
}
801044e4:	c9                   	leave  
801044e5:	c3                   	ret    
801044e6:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044e8:	e8 43 f1 ff ff       	call   80103630 <mycpu>
801044ed:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801044f3:	85 c0                	test   %eax,%eax
801044f5:	74 ed                	je     801044e4 <popcli+0x34>
  asm volatile("sti");
801044f7:	fb                   	sti    
}
801044f8:	c9                   	leave  
801044f9:	c3                   	ret    
    panic("popcli");
801044fa:	c7 04 24 f2 79 10 80 	movl   $0x801079f2,(%esp)
80104501:	e8 5a be ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104506:	c7 04 24 db 79 10 80 	movl   $0x801079db,(%esp)
8010450d:	e8 4e be ff ff       	call   80100360 <panic>
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <holding>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
80104524:	31 f6                	xor    %esi,%esi
{
80104526:	53                   	push   %ebx
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010452a:	e8 41 ff ff ff       	call   80104470 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010452f:	8b 03                	mov    (%ebx),%eax
80104531:	85 c0                	test   %eax,%eax
80104533:	74 12                	je     80104547 <holding+0x27>
80104535:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104538:	e8 f3 f0 ff ff       	call   80103630 <mycpu>
8010453d:	39 c3                	cmp    %eax,%ebx
8010453f:	0f 94 c0             	sete   %al
80104542:	0f b6 c0             	movzbl %al,%eax
80104545:	89 c6                	mov    %eax,%esi
  popcli();
80104547:	e8 64 ff ff ff       	call   801044b0 <popcli>
}
8010454c:	89 f0                	mov    %esi,%eax
8010454e:	5b                   	pop    %ebx
8010454f:	5e                   	pop    %esi
80104550:	5d                   	pop    %ebp
80104551:	c3                   	ret    
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <acquire>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104567:	e8 04 ff ff ff       	call   80104470 <pushcli>
  if(holding(lk))
8010456c:	8b 45 08             	mov    0x8(%ebp),%eax
8010456f:	89 04 24             	mov    %eax,(%esp)
80104572:	e8 a9 ff ff ff       	call   80104520 <holding>
80104577:	85 c0                	test   %eax,%eax
80104579:	75 3a                	jne    801045b5 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
8010457b:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104580:	8b 55 08             	mov    0x8(%ebp),%edx
80104583:	89 c8                	mov    %ecx,%eax
80104585:	f0 87 02             	lock xchg %eax,(%edx)
80104588:	85 c0                	test   %eax,%eax
8010458a:	75 f4                	jne    80104580 <acquire+0x20>
  __sync_synchronize();
8010458c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010458f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104592:	e8 99 f0 ff ff       	call   80103630 <mycpu>
80104597:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010459a:	8b 45 08             	mov    0x8(%ebp),%eax
8010459d:	83 c0 0c             	add    $0xc,%eax
801045a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801045a4:	8d 45 08             	lea    0x8(%ebp),%eax
801045a7:	89 04 24             	mov    %eax,(%esp)
801045aa:	e8 61 fe ff ff       	call   80104410 <getcallerpcs>
}
801045af:	83 c4 14             	add    $0x14,%esp
801045b2:	5b                   	pop    %ebx
801045b3:	5d                   	pop    %ebp
801045b4:	c3                   	ret    
    panic("acquire");
801045b5:	c7 04 24 f9 79 10 80 	movl   $0x801079f9,(%esp)
801045bc:	e8 9f bd ff ff       	call   80100360 <panic>
801045c1:	eb 0d                	jmp    801045d0 <release>
801045c3:	90                   	nop
801045c4:	90                   	nop
801045c5:	90                   	nop
801045c6:	90                   	nop
801045c7:	90                   	nop
801045c8:	90                   	nop
801045c9:	90                   	nop
801045ca:	90                   	nop
801045cb:	90                   	nop
801045cc:	90                   	nop
801045cd:	90                   	nop
801045ce:	90                   	nop
801045cf:	90                   	nop

801045d0 <release>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 14             	sub    $0x14,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801045da:	89 1c 24             	mov    %ebx,(%esp)
801045dd:	e8 3e ff ff ff       	call   80104520 <holding>
801045e2:	85 c0                	test   %eax,%eax
801045e4:	74 21                	je     80104607 <release+0x37>
  lk->pcs[0] = 0;
801045e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045ed:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045f4:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045fd:	83 c4 14             	add    $0x14,%esp
80104600:	5b                   	pop    %ebx
80104601:	5d                   	pop    %ebp
  popcli();
80104602:	e9 a9 fe ff ff       	jmp    801044b0 <popcli>
    panic("release");
80104607:	c7 04 24 01 7a 10 80 	movl   $0x80107a01,(%esp)
8010460e:	e8 4d bd ff ff       	call   80100360 <panic>
80104613:	66 90                	xchg   %ax,%ax
80104615:	66 90                	xchg   %ax,%ax
80104617:	66 90                	xchg   %ax,%ax
80104619:	66 90                	xchg   %ax,%ax
8010461b:	66 90                	xchg   %ax,%ax
8010461d:	66 90                	xchg   %ax,%ax
8010461f:	90                   	nop

80104620 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	8b 55 08             	mov    0x8(%ebp),%edx
80104626:	57                   	push   %edi
80104627:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010462a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010462b:	f6 c2 03             	test   $0x3,%dl
8010462e:	75 05                	jne    80104635 <memset+0x15>
80104630:	f6 c1 03             	test   $0x3,%cl
80104633:	74 13                	je     80104648 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104635:	89 d7                	mov    %edx,%edi
80104637:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463a:	fc                   	cld    
8010463b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010463d:	5b                   	pop    %ebx
8010463e:	89 d0                	mov    %edx,%eax
80104640:	5f                   	pop    %edi
80104641:	5d                   	pop    %ebp
80104642:	c3                   	ret    
80104643:	90                   	nop
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104648:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010464c:	c1 e9 02             	shr    $0x2,%ecx
8010464f:	89 f8                	mov    %edi,%eax
80104651:	89 fb                	mov    %edi,%ebx
80104653:	c1 e0 18             	shl    $0x18,%eax
80104656:	c1 e3 10             	shl    $0x10,%ebx
80104659:	09 d8                	or     %ebx,%eax
8010465b:	09 f8                	or     %edi,%eax
8010465d:	c1 e7 08             	shl    $0x8,%edi
80104660:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104662:	89 d7                	mov    %edx,%edi
80104664:	fc                   	cld    
80104665:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104667:	5b                   	pop    %ebx
80104668:	89 d0                	mov    %edx,%eax
8010466a:	5f                   	pop    %edi
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi

80104670 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	8b 45 10             	mov    0x10(%ebp),%eax
80104676:	57                   	push   %edi
80104677:	56                   	push   %esi
80104678:	8b 75 0c             	mov    0xc(%ebp),%esi
8010467b:	53                   	push   %ebx
8010467c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010467f:	85 c0                	test   %eax,%eax
80104681:	8d 78 ff             	lea    -0x1(%eax),%edi
80104684:	74 26                	je     801046ac <memcmp+0x3c>
    if(*s1 != *s2)
80104686:	0f b6 03             	movzbl (%ebx),%eax
80104689:	31 d2                	xor    %edx,%edx
8010468b:	0f b6 0e             	movzbl (%esi),%ecx
8010468e:	38 c8                	cmp    %cl,%al
80104690:	74 16                	je     801046a8 <memcmp+0x38>
80104692:	eb 24                	jmp    801046b8 <memcmp+0x48>
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104698:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010469d:	83 c2 01             	add    $0x1,%edx
801046a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046a4:	38 c8                	cmp    %cl,%al
801046a6:	75 10                	jne    801046b8 <memcmp+0x48>
  while(n-- > 0){
801046a8:	39 fa                	cmp    %edi,%edx
801046aa:	75 ec                	jne    80104698 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046ac:	5b                   	pop    %ebx
  return 0;
801046ad:	31 c0                	xor    %eax,%eax
}
801046af:	5e                   	pop    %esi
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b8:	5b                   	pop    %ebx
      return *s1 - *s2;
801046b9:	29 c8                	sub    %ecx,%eax
}
801046bb:	5e                   	pop    %esi
801046bc:	5f                   	pop    %edi
801046bd:	5d                   	pop    %ebp
801046be:	c3                   	ret    
801046bf:	90                   	nop

801046c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	8b 45 08             	mov    0x8(%ebp),%eax
801046c7:	56                   	push   %esi
801046c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801046cb:	53                   	push   %ebx
801046cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046cf:	39 c6                	cmp    %eax,%esi
801046d1:	73 35                	jae    80104708 <memmove+0x48>
801046d3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801046d6:	39 c8                	cmp    %ecx,%eax
801046d8:	73 2e                	jae    80104708 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801046da:	85 db                	test   %ebx,%ebx
    d += n;
801046dc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801046df:	8d 53 ff             	lea    -0x1(%ebx),%edx
801046e2:	74 1b                	je     801046ff <memmove+0x3f>
801046e4:	f7 db                	neg    %ebx
801046e6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801046e9:	01 fb                	add    %edi,%ebx
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801046f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801046f4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
801046f7:	83 ea 01             	sub    $0x1,%edx
801046fa:	83 fa ff             	cmp    $0xffffffff,%edx
801046fd:	75 f1                	jne    801046f0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046ff:	5b                   	pop    %ebx
80104700:	5e                   	pop    %esi
80104701:	5f                   	pop    %edi
80104702:	5d                   	pop    %ebp
80104703:	c3                   	ret    
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104708:	31 d2                	xor    %edx,%edx
8010470a:	85 db                	test   %ebx,%ebx
8010470c:	74 f1                	je     801046ff <memmove+0x3f>
8010470e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104710:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104714:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104717:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010471a:	39 da                	cmp    %ebx,%edx
8010471c:	75 f2                	jne    80104710 <memmove+0x50>
}
8010471e:	5b                   	pop    %ebx
8010471f:	5e                   	pop    %esi
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104733:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104734:	eb 8a                	jmp    801046c0 <memmove>
80104736:	8d 76 00             	lea    0x0(%esi),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	8b 75 10             	mov    0x10(%ebp),%esi
80104747:	53                   	push   %ebx
80104748:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010474b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010474e:	85 f6                	test   %esi,%esi
80104750:	74 30                	je     80104782 <strncmp+0x42>
80104752:	0f b6 01             	movzbl (%ecx),%eax
80104755:	84 c0                	test   %al,%al
80104757:	74 2f                	je     80104788 <strncmp+0x48>
80104759:	0f b6 13             	movzbl (%ebx),%edx
8010475c:	38 d0                	cmp    %dl,%al
8010475e:	75 46                	jne    801047a6 <strncmp+0x66>
80104760:	8d 51 01             	lea    0x1(%ecx),%edx
80104763:	01 ce                	add    %ecx,%esi
80104765:	eb 14                	jmp    8010477b <strncmp+0x3b>
80104767:	90                   	nop
80104768:	0f b6 02             	movzbl (%edx),%eax
8010476b:	84 c0                	test   %al,%al
8010476d:	74 31                	je     801047a0 <strncmp+0x60>
8010476f:	0f b6 19             	movzbl (%ecx),%ebx
80104772:	83 c2 01             	add    $0x1,%edx
80104775:	38 d8                	cmp    %bl,%al
80104777:	75 17                	jne    80104790 <strncmp+0x50>
    n--, p++, q++;
80104779:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010477b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010477d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104780:	75 e6                	jne    80104768 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104782:	5b                   	pop    %ebx
    return 0;
80104783:	31 c0                	xor    %eax,%eax
}
80104785:	5e                   	pop    %esi
80104786:	5d                   	pop    %ebp
80104787:	c3                   	ret    
80104788:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010478b:	31 c0                	xor    %eax,%eax
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104790:	0f b6 d3             	movzbl %bl,%edx
80104793:	29 d0                	sub    %edx,%eax
}
80104795:	5b                   	pop    %ebx
80104796:	5e                   	pop    %esi
80104797:	5d                   	pop    %ebp
80104798:	c3                   	ret    
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801047a4:	eb ea                	jmp    80104790 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801047a6:	89 d3                	mov    %edx,%ebx
801047a8:	eb e6                	jmp    80104790 <strncmp+0x50>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	8b 45 08             	mov    0x8(%ebp),%eax
801047b6:	56                   	push   %esi
801047b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ba:	53                   	push   %ebx
801047bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047be:	89 c2                	mov    %eax,%edx
801047c0:	eb 19                	jmp    801047db <strncpy+0x2b>
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c8:	83 c3 01             	add    $0x1,%ebx
801047cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801047cf:	83 c2 01             	add    $0x1,%edx
801047d2:	84 c9                	test   %cl,%cl
801047d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801047d7:	74 09                	je     801047e2 <strncpy+0x32>
801047d9:	89 f1                	mov    %esi,%ecx
801047db:	85 c9                	test   %ecx,%ecx
801047dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801047e0:	7f e6                	jg     801047c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801047e2:	31 c9                	xor    %ecx,%ecx
801047e4:	85 f6                	test   %esi,%esi
801047e6:	7e 0f                	jle    801047f7 <strncpy+0x47>
    *s++ = 0;
801047e8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801047ec:	89 f3                	mov    %esi,%ebx
801047ee:	83 c1 01             	add    $0x1,%ecx
801047f1:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801047f3:	85 db                	test   %ebx,%ebx
801047f5:	7f f1                	jg     801047e8 <strncpy+0x38>
  return os;
}
801047f7:	5b                   	pop    %ebx
801047f8:	5e                   	pop    %esi
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    
801047fb:	90                   	nop
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104806:	56                   	push   %esi
80104807:	8b 45 08             	mov    0x8(%ebp),%eax
8010480a:	53                   	push   %ebx
8010480b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010480e:	85 c9                	test   %ecx,%ecx
80104810:	7e 26                	jle    80104838 <safestrcpy+0x38>
80104812:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104816:	89 c1                	mov    %eax,%ecx
80104818:	eb 17                	jmp    80104831 <safestrcpy+0x31>
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104820:	83 c2 01             	add    $0x1,%edx
80104823:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104827:	83 c1 01             	add    $0x1,%ecx
8010482a:	84 db                	test   %bl,%bl
8010482c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010482f:	74 04                	je     80104835 <safestrcpy+0x35>
80104831:	39 f2                	cmp    %esi,%edx
80104833:	75 eb                	jne    80104820 <safestrcpy+0x20>
    ;
  *s = 0;
80104835:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104838:	5b                   	pop    %ebx
80104839:	5e                   	pop    %esi
8010483a:	5d                   	pop    %ebp
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <strlen>:

int
strlen(const char *s)
{
80104840:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104841:	31 c0                	xor    %eax,%eax
{
80104843:	89 e5                	mov    %esp,%ebp
80104845:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104848:	80 3a 00             	cmpb   $0x0,(%edx)
8010484b:	74 0c                	je     80104859 <strlen+0x19>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
80104850:	83 c0 01             	add    $0x1,%eax
80104853:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104857:	75 f7                	jne    80104850 <strlen+0x10>
    ;
  return n;
}
80104859:	5d                   	pop    %ebp
8010485a:	c3                   	ret    

8010485b <swtch>:
8010485b:	8b 44 24 04          	mov    0x4(%esp),%eax
8010485f:	8b 54 24 08          	mov    0x8(%esp),%edx
80104863:	55                   	push   %ebp
80104864:	53                   	push   %ebx
80104865:	56                   	push   %esi
80104866:	57                   	push   %edi
80104867:	89 20                	mov    %esp,(%eax)
80104869:	89 d4                	mov    %edx,%esp
8010486b:	5f                   	pop    %edi
8010486c:	5e                   	pop    %esi
8010486d:	5b                   	pop    %ebx
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret    

80104870 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
80104877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010487a:	e8 51 ee ff ff       	call   801036d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010487f:	8b 00                	mov    (%eax),%eax
80104881:	39 d8                	cmp    %ebx,%eax
80104883:	76 1b                	jbe    801048a0 <fetchint+0x30>
80104885:	8d 53 04             	lea    0x4(%ebx),%edx
80104888:	39 d0                	cmp    %edx,%eax
8010488a:	72 14                	jb     801048a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010488c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010488f:	8b 13                	mov    (%ebx),%edx
80104891:	89 10                	mov    %edx,(%eax)
  return 0;
80104893:	31 c0                	xor    %eax,%eax
}
80104895:	83 c4 04             	add    $0x4,%esp
80104898:	5b                   	pop    %ebx
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	90                   	nop
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a5:	eb ee                	jmp    80104895 <fetchint+0x25>
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048ba:	e8 11 ee ff ff       	call   801036d0 <myproc>

  if(addr >= curproc->sz)
801048bf:	39 18                	cmp    %ebx,(%eax)
801048c1:	76 26                	jbe    801048e9 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
801048c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801048c6:	89 da                	mov    %ebx,%edx
801048c8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801048ca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801048cc:	39 c3                	cmp    %eax,%ebx
801048ce:	73 19                	jae    801048e9 <fetchstr+0x39>
    if(*s == 0)
801048d0:	80 3b 00             	cmpb   $0x0,(%ebx)
801048d3:	75 0d                	jne    801048e2 <fetchstr+0x32>
801048d5:	eb 21                	jmp    801048f8 <fetchstr+0x48>
801048d7:	90                   	nop
801048d8:	80 3a 00             	cmpb   $0x0,(%edx)
801048db:	90                   	nop
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e0:	74 16                	je     801048f8 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
801048e2:	83 c2 01             	add    $0x1,%edx
801048e5:	39 d0                	cmp    %edx,%eax
801048e7:	77 ef                	ja     801048d8 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
801048e9:	83 c4 04             	add    $0x4,%esp
    return -1;
801048ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048f1:	5b                   	pop    %ebx
801048f2:	5d                   	pop    %ebp
801048f3:	c3                   	ret    
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f8:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801048fb:	89 d0                	mov    %edx,%eax
801048fd:	29 d8                	sub    %ebx,%eax
}
801048ff:	5b                   	pop    %ebx
80104900:	5d                   	pop    %ebp
80104901:	c3                   	ret    
80104902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	8b 75 0c             	mov    0xc(%ebp),%esi
80104917:	53                   	push   %ebx
80104918:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010491b:	e8 b0 ed ff ff       	call   801036d0 <myproc>
80104920:	89 75 0c             	mov    %esi,0xc(%ebp)
80104923:	8b 40 18             	mov    0x18(%eax),%eax
80104926:	8b 40 44             	mov    0x44(%eax),%eax
80104929:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010492d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104933:	e9 38 ff ff ff       	jmp    80104870 <fetchint>
80104938:	90                   	nop
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	83 ec 20             	sub    $0x20,%esp
80104948:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010494b:	e8 80 ed ff ff       	call   801036d0 <myproc>
80104950:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104952:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104955:	89 44 24 04          	mov    %eax,0x4(%esp)
80104959:	8b 45 08             	mov    0x8(%ebp),%eax
8010495c:	89 04 24             	mov    %eax,(%esp)
8010495f:	e8 ac ff ff ff       	call   80104910 <argint>
80104964:	85 c0                	test   %eax,%eax
80104966:	78 28                	js     80104990 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104968:	85 db                	test   %ebx,%ebx
8010496a:	78 24                	js     80104990 <argptr+0x50>
8010496c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010496f:	8b 06                	mov    (%esi),%eax
80104971:	39 c2                	cmp    %eax,%edx
80104973:	73 1b                	jae    80104990 <argptr+0x50>
80104975:	01 d3                	add    %edx,%ebx
80104977:	39 d8                	cmp    %ebx,%eax
80104979:	72 15                	jb     80104990 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104980:	83 c4 20             	add    $0x20,%esp
  return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104990:	83 c4 20             	add    $0x20,%esp
    return -1;
80104993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104998:	5b                   	pop    %ebx
80104999:	5e                   	pop    %esi
8010499a:	5d                   	pop    %ebp
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801049a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ad:	8b 45 08             	mov    0x8(%ebp),%eax
801049b0:	89 04 24             	mov    %eax,(%esp)
801049b3:	e8 58 ff ff ff       	call   80104910 <argint>
801049b8:	85 c0                	test   %eax,%eax
801049ba:	78 14                	js     801049d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c6:	89 04 24             	mov    %eax,(%esp)
801049c9:	e8 e2 fe ff ff       	call   801048b0 <fetchstr>
}
801049ce:	c9                   	leave  
801049cf:	c3                   	ret    
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049d5:	c9                   	leave  
801049d6:	c3                   	ret    
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <syscall>:
[SYS_tickprintf] sys_tickprintf,
};

void
syscall(void)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
801049e6:	83 ec 1c             	sub    $0x1c,%esp
  int num;
  struct proc *curproc = myproc();
801049e9:	e8 e2 ec ff ff       	call   801036d0 <myproc>
  int syscnum=curproc->sysnum;
  
  num = curproc->tf->eax;
801049ee:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
801049f1:	89 c3                	mov    %eax,%ebx
  int syscnum=curproc->sysnum;
801049f3:	8b 78 7c             	mov    0x7c(%eax),%edi
  num = curproc->tf->eax;
801049f6:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049f9:	8d 50 ff             	lea    -0x1(%eax),%edx
801049fc:	83 fa 17             	cmp    $0x17,%edx
801049ff:	77 1f                	ja     80104a20 <syscall+0x40>
80104a01:	8b 14 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%edx
80104a08:	85 d2                	test   %edx,%edx
80104a0a:	74 14                	je     80104a20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a0c:	ff d2                	call   *%edx
    syscnum++;
80104a0e:	83 c7 01             	add    $0x1,%edi
    curproc->tf->eax = syscalls[num]();
80104a11:	89 46 1c             	mov    %eax,0x1c(%esi)
    syscnum++;
80104a14:	89 7b 7c             	mov    %edi,0x7c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a17:	83 c4 1c             	add    $0x1c,%esp
80104a1a:	5b                   	pop    %ebx
80104a1b:	5e                   	pop    %esi
80104a1c:	5f                   	pop    %edi
80104a1d:	5d                   	pop    %ebp
80104a1e:	c3                   	ret    
80104a1f:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80104a20:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104a24:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a27:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104a2b:	8b 43 10             	mov    0x10(%ebx),%eax
80104a2e:	c7 04 24 09 7a 10 80 	movl   $0x80107a09,(%esp)
80104a35:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a39:	e8 12 bc ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104a3e:	8b 43 18             	mov    0x18(%ebx),%eax
80104a41:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a48:	83 c4 1c             	add    $0x1c,%esp
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5f                   	pop    %edi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	89 c3                	mov    %eax,%ebx
80104a56:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104a59:	e8 72 ec ff ff       	call   801036d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80104a5e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104a60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104a64:	85 c9                	test   %ecx,%ecx
80104a66:	74 18                	je     80104a80 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104a68:	83 c2 01             	add    $0x1,%edx
80104a6b:	83 fa 10             	cmp    $0x10,%edx
80104a6e:	75 f0                	jne    80104a60 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104a70:	83 c4 04             	add    $0x4,%esp
  return -1;
80104a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a78:	5b                   	pop    %ebx
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	90                   	nop
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104a80:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104a84:	83 c4 04             	add    $0x4,%esp
      return fd;
80104a87:	89 d0                	mov    %edx,%eax
}
80104a89:	5b                   	pop    %ebx
80104a8a:	5d                   	pop    %ebp
80104a8b:	c3                   	ret    
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	83 ec 3c             	sub    $0x3c,%esp
80104a99:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a9f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104aa2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104aa6:	89 04 24             	mov    %eax,(%esp)
{
80104aa9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104aac:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104aaf:	e8 6c d4 ff ff       	call   80101f20 <nameiparent>
80104ab4:	85 c0                	test   %eax,%eax
80104ab6:	89 c7                	mov    %eax,%edi
80104ab8:	0f 84 da 00 00 00    	je     80104b98 <create+0x108>
    return 0;
  ilock(dp);
80104abe:	89 04 24             	mov    %eax,(%esp)
80104ac1:	e8 ea cb ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ac6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104acd:	00 
80104ace:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ad2:	89 3c 24             	mov    %edi,(%esp)
80104ad5:	e8 e6 d0 ff ff       	call   80101bc0 <dirlookup>
80104ada:	85 c0                	test   %eax,%eax
80104adc:	89 c6                	mov    %eax,%esi
80104ade:	74 40                	je     80104b20 <create+0x90>
    iunlockput(dp);
80104ae0:	89 3c 24             	mov    %edi,(%esp)
80104ae3:	e8 28 ce ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104ae8:	89 34 24             	mov    %esi,(%esp)
80104aeb:	e8 c0 cb ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104af0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104af5:	75 11                	jne    80104b08 <create+0x78>
80104af7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104afc:	89 f0                	mov    %esi,%eax
80104afe:	75 08                	jne    80104b08 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b00:	83 c4 3c             	add    $0x3c,%esp
80104b03:	5b                   	pop    %ebx
80104b04:	5e                   	pop    %esi
80104b05:	5f                   	pop    %edi
80104b06:	5d                   	pop    %ebp
80104b07:	c3                   	ret    
    iunlockput(ip);
80104b08:	89 34 24             	mov    %esi,(%esp)
80104b0b:	e8 00 ce ff ff       	call   80101910 <iunlockput>
}
80104b10:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104b13:	31 c0                	xor    %eax,%eax
}
80104b15:	5b                   	pop    %ebx
80104b16:	5e                   	pop    %esi
80104b17:	5f                   	pop    %edi
80104b18:	5d                   	pop    %ebp
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104b20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b24:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b28:	8b 07                	mov    (%edi),%eax
80104b2a:	89 04 24             	mov    %eax,(%esp)
80104b2d:	e8 ee c9 ff ff       	call   80101520 <ialloc>
80104b32:	85 c0                	test   %eax,%eax
80104b34:	89 c6                	mov    %eax,%esi
80104b36:	0f 84 bf 00 00 00    	je     80104bfb <create+0x16b>
  ilock(ip);
80104b3c:	89 04 24             	mov    %eax,(%esp)
80104b3f:	e8 6c cb ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104b44:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b48:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b4c:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104b50:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b54:	b8 01 00 00 00       	mov    $0x1,%eax
80104b59:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b5d:	89 34 24             	mov    %esi,(%esp)
80104b60:	e8 8b ca ff ff       	call   801015f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b65:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b6a:	74 34                	je     80104ba0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104b6c:	8b 46 04             	mov    0x4(%esi),%eax
80104b6f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104b73:	89 3c 24             	mov    %edi,(%esp)
80104b76:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b7a:	e8 a1 d2 ff ff       	call   80101e20 <dirlink>
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	78 6c                	js     80104bef <create+0x15f>
  iunlockput(dp);
80104b83:	89 3c 24             	mov    %edi,(%esp)
80104b86:	e8 85 cd ff ff       	call   80101910 <iunlockput>
}
80104b8b:	83 c4 3c             	add    $0x3c,%esp
  return ip;
80104b8e:	89 f0                	mov    %esi,%eax
}
80104b90:	5b                   	pop    %ebx
80104b91:	5e                   	pop    %esi
80104b92:	5f                   	pop    %edi
80104b93:	5d                   	pop    %ebp
80104b94:	c3                   	ret    
80104b95:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104b98:	31 c0                	xor    %eax,%eax
80104b9a:	e9 61 ff ff ff       	jmp    80104b00 <create+0x70>
80104b9f:	90                   	nop
    dp->nlink++;  // for ".."
80104ba0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104ba5:	89 3c 24             	mov    %edi,(%esp)
80104ba8:	e8 43 ca ff ff       	call   801015f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bad:	8b 46 04             	mov    0x4(%esi),%eax
80104bb0:	c7 44 24 04 c0 7a 10 	movl   $0x80107ac0,0x4(%esp)
80104bb7:	80 
80104bb8:	89 34 24             	mov    %esi,(%esp)
80104bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bbf:	e8 5c d2 ff ff       	call   80101e20 <dirlink>
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	78 1b                	js     80104be3 <create+0x153>
80104bc8:	8b 47 04             	mov    0x4(%edi),%eax
80104bcb:	c7 44 24 04 bf 7a 10 	movl   $0x80107abf,0x4(%esp)
80104bd2:	80 
80104bd3:	89 34 24             	mov    %esi,(%esp)
80104bd6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bda:	e8 41 d2 ff ff       	call   80101e20 <dirlink>
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	79 89                	jns    80104b6c <create+0xdc>
      panic("create dots");
80104be3:	c7 04 24 b3 7a 10 80 	movl   $0x80107ab3,(%esp)
80104bea:	e8 71 b7 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104bef:	c7 04 24 c2 7a 10 80 	movl   $0x80107ac2,(%esp)
80104bf6:	e8 65 b7 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104bfb:	c7 04 24 a4 7a 10 80 	movl   $0x80107aa4,(%esp)
80104c02:	e8 59 b7 ff ff       	call   80100360 <panic>
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	89 c6                	mov    %eax,%esi
80104c16:	53                   	push   %ebx
80104c17:	89 d3                	mov    %edx,%ebx
80104c19:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104c1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c2a:	e8 e1 fc ff ff       	call   80104910 <argint>
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	78 2d                	js     80104c60 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c33:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c37:	77 27                	ja     80104c60 <argfd.constprop.0+0x50>
80104c39:	e8 92 ea ff ff       	call   801036d0 <myproc>
80104c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c41:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c45:	85 c0                	test   %eax,%eax
80104c47:	74 17                	je     80104c60 <argfd.constprop.0+0x50>
  if(pfd)
80104c49:	85 f6                	test   %esi,%esi
80104c4b:	74 02                	je     80104c4f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104c4d:	89 16                	mov    %edx,(%esi)
  if(pf)
80104c4f:	85 db                	test   %ebx,%ebx
80104c51:	74 1d                	je     80104c70 <argfd.constprop.0+0x60>
    *pf = f;
80104c53:	89 03                	mov    %eax,(%ebx)
  return 0;
80104c55:	31 c0                	xor    %eax,%eax
}
80104c57:	83 c4 20             	add    $0x20,%esp
80104c5a:	5b                   	pop    %ebx
80104c5b:	5e                   	pop    %esi
80104c5c:	5d                   	pop    %ebp
80104c5d:	c3                   	ret    
80104c5e:	66 90                	xchg   %ax,%ax
80104c60:	83 c4 20             	add    $0x20,%esp
    return -1;
80104c63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c68:	5b                   	pop    %ebx
80104c69:	5e                   	pop    %esi
80104c6a:	5d                   	pop    %ebp
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104c70:	31 c0                	xor    %eax,%eax
80104c72:	eb e3                	jmp    80104c57 <argfd.constprop.0+0x47>
80104c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c80 <sys_dup>:
{
80104c80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c81:	31 c0                	xor    %eax,%eax
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	53                   	push   %ebx
80104c86:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104c89:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c8c:	e8 7f ff ff ff       	call   80104c10 <argfd.constprop.0>
80104c91:	85 c0                	test   %eax,%eax
80104c93:	78 23                	js     80104cb8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c98:	e8 b3 fd ff ff       	call   80104a50 <fdalloc>
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	89 c3                	mov    %eax,%ebx
80104ca1:	78 15                	js     80104cb8 <sys_dup+0x38>
  filedup(f);
80104ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca6:	89 04 24             	mov    %eax,(%esp)
80104ca9:	e8 32 c1 ff ff       	call   80100de0 <filedup>
  return fd;
80104cae:	89 d8                	mov    %ebx,%eax
}
80104cb0:	83 c4 24             	add    $0x24,%esp
80104cb3:	5b                   	pop    %ebx
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret    
80104cb6:	66 90                	xchg   %ax,%ax
    return -1;
80104cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbd:	eb f1                	jmp    80104cb0 <sys_dup+0x30>
80104cbf:	90                   	nop

80104cc0 <sys_read>:
{
80104cc0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc1:	31 c0                	xor    %eax,%eax
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ccb:	e8 40 ff ff ff       	call   80104c10 <argfd.constprop.0>
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 54                	js     80104d28 <sys_read+0x68>
80104cd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cdb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ce2:	e8 29 fc ff ff       	call   80104910 <argint>
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	78 3d                	js     80104d28 <sys_read+0x68>
80104ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cf5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d00:	e8 3b fc ff ff       	call   80104940 <argptr>
80104d05:	85 c0                	test   %eax,%eax
80104d07:	78 1f                	js     80104d28 <sys_read+0x68>
  return fileread(f, p, n);
80104d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d1a:	89 04 24             	mov    %eax,(%esp)
80104d1d:	e8 1e c2 ff ff       	call   80100f40 <fileread>
}
80104d22:	c9                   	leave  
80104d23:	c3                   	ret    
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d2d:	c9                   	leave  
80104d2e:	c3                   	ret    
80104d2f:	90                   	nop

80104d30 <sys_write>:
{
80104d30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d31:	31 c0                	xor    %eax,%eax
{
80104d33:	89 e5                	mov    %esp,%ebp
80104d35:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3b:	e8 d0 fe ff ff       	call   80104c10 <argfd.constprop.0>
80104d40:	85 c0                	test   %eax,%eax
80104d42:	78 54                	js     80104d98 <sys_write+0x68>
80104d44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d4b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104d52:	e8 b9 fb ff ff       	call   80104910 <argint>
80104d57:	85 c0                	test   %eax,%eax
80104d59:	78 3d                	js     80104d98 <sys_write+0x68>
80104d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d65:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d70:	e8 cb fb ff ff       	call   80104940 <argptr>
80104d75:	85 c0                	test   %eax,%eax
80104d77:	78 1f                	js     80104d98 <sys_write+0x68>
  return filewrite(f, p, n);
80104d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d8a:	89 04 24             	mov    %eax,(%esp)
80104d8d:	e8 4e c2 ff ff       	call   80100fe0 <filewrite>
}
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9d:	c9                   	leave  
80104d9e:	c3                   	ret    
80104d9f:	90                   	nop

80104da0 <sys_close>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104da6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104da9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dac:	e8 5f fe ff ff       	call   80104c10 <argfd.constprop.0>
80104db1:	85 c0                	test   %eax,%eax
80104db3:	78 23                	js     80104dd8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104db5:	e8 16 e9 ff ff       	call   801036d0 <myproc>
80104dba:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dbd:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104dc4:	00 
  fileclose(f);
80104dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc8:	89 04 24             	mov    %eax,(%esp)
80104dcb:	e8 60 c0 ff ff       	call   80100e30 <fileclose>
  return 0;
80104dd0:	31 c0                	xor    %eax,%eax
}
80104dd2:	c9                   	leave  
80104dd3:	c3                   	ret    
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ddd:	c9                   	leave  
80104dde:	c3                   	ret    
80104ddf:	90                   	nop

80104de0 <sys_fstat>:
{
80104de0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104deb:	e8 20 fe ff ff       	call   80104c10 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 34                	js     80104e28 <sys_fstat+0x48>
80104df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104df7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104dfe:	00 
80104dff:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e0a:	e8 31 fb ff ff       	call   80104940 <argptr>
80104e0f:	85 c0                	test   %eax,%eax
80104e11:	78 15                	js     80104e28 <sys_fstat+0x48>
  return filestat(f, st);
80104e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e16:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e1d:	89 04 24             	mov    %eax,(%esp)
80104e20:	e8 cb c0 ff ff       	call   80100ef0 <filestat>
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	90                   	nop
    return -1;
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e2d:	c9                   	leave  
80104e2e:	c3                   	ret    
80104e2f:	90                   	nop

80104e30 <sys_link>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
80104e36:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e39:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e47:	e8 54 fb ff ff       	call   801049a0 <argstr>
80104e4c:	85 c0                	test   %eax,%eax
80104e4e:	0f 88 e6 00 00 00    	js     80104f3a <sys_link+0x10a>
80104e54:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e62:	e8 39 fb ff ff       	call   801049a0 <argstr>
80104e67:	85 c0                	test   %eax,%eax
80104e69:	0f 88 cb 00 00 00    	js     80104f3a <sys_link+0x10a>
  begin_op();
80104e6f:	e8 9c dc ff ff       	call   80102b10 <begin_op>
  if((ip = namei(old)) == 0){
80104e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104e77:	89 04 24             	mov    %eax,(%esp)
80104e7a:	e8 81 d0 ff ff       	call   80101f00 <namei>
80104e7f:	85 c0                	test   %eax,%eax
80104e81:	89 c3                	mov    %eax,%ebx
80104e83:	0f 84 ac 00 00 00    	je     80104f35 <sys_link+0x105>
  ilock(ip);
80104e89:	89 04 24             	mov    %eax,(%esp)
80104e8c:	e8 1f c8 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
80104e91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e96:	0f 84 91 00 00 00    	je     80104f2d <sys_link+0xfd>
  ip->nlink++;
80104e9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ea1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ea4:	89 1c 24             	mov    %ebx,(%esp)
80104ea7:	e8 44 c7 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
80104eac:	89 1c 24             	mov    %ebx,(%esp)
80104eaf:	e8 dc c8 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104eb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104eb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ebb:	89 04 24             	mov    %eax,(%esp)
80104ebe:	e8 5d d0 ff ff       	call   80101f20 <nameiparent>
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	89 c6                	mov    %eax,%esi
80104ec7:	74 4f                	je     80104f18 <sys_link+0xe8>
  ilock(dp);
80104ec9:	89 04 24             	mov    %eax,(%esp)
80104ecc:	e8 df c7 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ed1:	8b 03                	mov    (%ebx),%eax
80104ed3:	39 06                	cmp    %eax,(%esi)
80104ed5:	75 39                	jne    80104f10 <sys_link+0xe0>
80104ed7:	8b 43 04             	mov    0x4(%ebx),%eax
80104eda:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104ede:	89 34 24             	mov    %esi,(%esp)
80104ee1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ee5:	e8 36 cf ff ff       	call   80101e20 <dirlink>
80104eea:	85 c0                	test   %eax,%eax
80104eec:	78 22                	js     80104f10 <sys_link+0xe0>
  iunlockput(dp);
80104eee:	89 34 24             	mov    %esi,(%esp)
80104ef1:	e8 1a ca ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104ef6:	89 1c 24             	mov    %ebx,(%esp)
80104ef9:	e8 d2 c8 ff ff       	call   801017d0 <iput>
  end_op();
80104efe:	e8 7d dc ff ff       	call   80102b80 <end_op>
}
80104f03:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104f06:	31 c0                	xor    %eax,%eax
}
80104f08:	5b                   	pop    %ebx
80104f09:	5e                   	pop    %esi
80104f0a:	5f                   	pop    %edi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f10:	89 34 24             	mov    %esi,(%esp)
80104f13:	e8 f8 c9 ff ff       	call   80101910 <iunlockput>
  ilock(ip);
80104f18:	89 1c 24             	mov    %ebx,(%esp)
80104f1b:	e8 90 c7 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80104f20:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f25:	89 1c 24             	mov    %ebx,(%esp)
80104f28:	e8 c3 c6 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80104f2d:	89 1c 24             	mov    %ebx,(%esp)
80104f30:	e8 db c9 ff ff       	call   80101910 <iunlockput>
  end_op();
80104f35:	e8 46 dc ff ff       	call   80102b80 <end_op>
}
80104f3a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f42:	5b                   	pop    %ebx
80104f43:	5e                   	pop    %esi
80104f44:	5f                   	pop    %edi
80104f45:	5d                   	pop    %ebp
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_unlink>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
80104f56:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104f59:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f67:	e8 34 fa ff ff       	call   801049a0 <argstr>
80104f6c:	85 c0                	test   %eax,%eax
80104f6e:	0f 88 76 01 00 00    	js     801050ea <sys_unlink+0x19a>
  begin_op();
80104f74:	e8 97 db ff ff       	call   80102b10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f79:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104f7c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104f83:	89 04 24             	mov    %eax,(%esp)
80104f86:	e8 95 cf ff ff       	call   80101f20 <nameiparent>
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104f90:	0f 84 4f 01 00 00    	je     801050e5 <sys_unlink+0x195>
  ilock(dp);
80104f96:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104f99:	89 34 24             	mov    %esi,(%esp)
80104f9c:	e8 0f c7 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fa1:	c7 44 24 04 c0 7a 10 	movl   $0x80107ac0,0x4(%esp)
80104fa8:	80 
80104fa9:	89 1c 24             	mov    %ebx,(%esp)
80104fac:	e8 df cb ff ff       	call   80101b90 <namecmp>
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	0f 84 21 01 00 00    	je     801050da <sys_unlink+0x18a>
80104fb9:	c7 44 24 04 bf 7a 10 	movl   $0x80107abf,0x4(%esp)
80104fc0:	80 
80104fc1:	89 1c 24             	mov    %ebx,(%esp)
80104fc4:	e8 c7 cb ff ff       	call   80101b90 <namecmp>
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	0f 84 09 01 00 00    	je     801050da <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104fd1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104fd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fdc:	89 34 24             	mov    %esi,(%esp)
80104fdf:	e8 dc cb ff ff       	call   80101bc0 <dirlookup>
80104fe4:	85 c0                	test   %eax,%eax
80104fe6:	89 c3                	mov    %eax,%ebx
80104fe8:	0f 84 ec 00 00 00    	je     801050da <sys_unlink+0x18a>
  ilock(ip);
80104fee:	89 04 24             	mov    %eax,(%esp)
80104ff1:	e8 ba c6 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
80104ff6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ffb:	0f 8e 24 01 00 00    	jle    80105125 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105001:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105006:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105009:	74 7d                	je     80105088 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
8010500b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105012:	00 
80105013:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010501a:	00 
8010501b:	89 34 24             	mov    %esi,(%esp)
8010501e:	e8 fd f5 ff ff       	call   80104620 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105023:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105026:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010502d:	00 
8010502e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105032:	89 44 24 08          	mov    %eax,0x8(%esp)
80105036:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105039:	89 04 24             	mov    %eax,(%esp)
8010503c:	e8 1f ca ff ff       	call   80101a60 <writei>
80105041:	83 f8 10             	cmp    $0x10,%eax
80105044:	0f 85 cf 00 00 00    	jne    80105119 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010504a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010504f:	0f 84 a3 00 00 00    	je     801050f8 <sys_unlink+0x1a8>
  iunlockput(dp);
80105055:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105058:	89 04 24             	mov    %eax,(%esp)
8010505b:	e8 b0 c8 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105060:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105065:	89 1c 24             	mov    %ebx,(%esp)
80105068:	e8 83 c5 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010506d:	89 1c 24             	mov    %ebx,(%esp)
80105070:	e8 9b c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105075:	e8 06 db ff ff       	call   80102b80 <end_op>
}
8010507a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
8010507d:	31 c0                	xor    %eax,%eax
}
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5f                   	pop    %edi
80105082:	5d                   	pop    %ebp
80105083:	c3                   	ret    
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105088:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010508c:	0f 86 79 ff ff ff    	jbe    8010500b <sys_unlink+0xbb>
80105092:	bf 20 00 00 00       	mov    $0x20,%edi
80105097:	eb 15                	jmp    801050ae <sys_unlink+0x15e>
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a0:	8d 57 10             	lea    0x10(%edi),%edx
801050a3:	3b 53 58             	cmp    0x58(%ebx),%edx
801050a6:	0f 83 5f ff ff ff    	jae    8010500b <sys_unlink+0xbb>
801050ac:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050ae:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801050b5:	00 
801050b6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801050ba:	89 74 24 04          	mov    %esi,0x4(%esp)
801050be:	89 1c 24             	mov    %ebx,(%esp)
801050c1:	e8 9a c8 ff ff       	call   80101960 <readi>
801050c6:	83 f8 10             	cmp    $0x10,%eax
801050c9:	75 42                	jne    8010510d <sys_unlink+0x1bd>
    if(de.inum != 0)
801050cb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050d0:	74 ce                	je     801050a0 <sys_unlink+0x150>
    iunlockput(ip);
801050d2:	89 1c 24             	mov    %ebx,(%esp)
801050d5:	e8 36 c8 ff ff       	call   80101910 <iunlockput>
  iunlockput(dp);
801050da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	e8 2b c8 ff ff       	call   80101910 <iunlockput>
  end_op();
801050e5:	e8 96 da ff ff       	call   80102b80 <end_op>
}
801050ea:	83 c4 5c             	add    $0x5c,%esp
  return -1;
801050ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f2:	5b                   	pop    %ebx
801050f3:	5e                   	pop    %esi
801050f4:	5f                   	pop    %edi
801050f5:	5d                   	pop    %ebp
801050f6:	c3                   	ret    
801050f7:	90                   	nop
    dp->nlink--;
801050f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801050fb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105100:	89 04 24             	mov    %eax,(%esp)
80105103:	e8 e8 c4 ff ff       	call   801015f0 <iupdate>
80105108:	e9 48 ff ff ff       	jmp    80105055 <sys_unlink+0x105>
      panic("isdirempty: readi");
8010510d:	c7 04 24 e4 7a 10 80 	movl   $0x80107ae4,(%esp)
80105114:	e8 47 b2 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80105119:	c7 04 24 f6 7a 10 80 	movl   $0x80107af6,(%esp)
80105120:	e8 3b b2 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80105125:	c7 04 24 d2 7a 10 80 	movl   $0x80107ad2,(%esp)
8010512c:	e8 2f b2 ff ff       	call   80100360 <panic>
80105131:	eb 0d                	jmp    80105140 <sys_open>
80105133:	90                   	nop
80105134:	90                   	nop
80105135:	90                   	nop
80105136:	90                   	nop
80105137:	90                   	nop
80105138:	90                   	nop
80105139:	90                   	nop
8010513a:	90                   	nop
8010513b:	90                   	nop
8010513c:	90                   	nop
8010513d:	90                   	nop
8010513e:	90                   	nop
8010513f:	90                   	nop

80105140 <sys_open>:

int
sys_open(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
80105145:	53                   	push   %ebx
80105146:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105149:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010514c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105157:	e8 44 f8 ff ff       	call   801049a0 <argstr>
8010515c:	85 c0                	test   %eax,%eax
8010515e:	0f 88 d1 00 00 00    	js     80105235 <sys_open+0xf5>
80105164:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105167:	89 44 24 04          	mov    %eax,0x4(%esp)
8010516b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105172:	e8 99 f7 ff ff       	call   80104910 <argint>
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 b6 00 00 00    	js     80105235 <sys_open+0xf5>
    return -1;

  begin_op();
8010517f:	e8 8c d9 ff ff       	call   80102b10 <begin_op>

  if(omode & O_CREATE){
80105184:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105188:	0f 85 82 00 00 00    	jne    80105210 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010518e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105191:	89 04 24             	mov    %eax,(%esp)
80105194:	e8 67 cd ff ff       	call   80101f00 <namei>
80105199:	85 c0                	test   %eax,%eax
8010519b:	89 c6                	mov    %eax,%esi
8010519d:	0f 84 8d 00 00 00    	je     80105230 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
801051a3:	89 04 24             	mov    %eax,(%esp)
801051a6:	e8 05 c5 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051b0:	0f 84 92 00 00 00    	je     80105248 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051b6:	e8 b5 bb ff ff       	call   80100d70 <filealloc>
801051bb:	85 c0                	test   %eax,%eax
801051bd:	89 c3                	mov    %eax,%ebx
801051bf:	0f 84 93 00 00 00    	je     80105258 <sys_open+0x118>
801051c5:	e8 86 f8 ff ff       	call   80104a50 <fdalloc>
801051ca:	85 c0                	test   %eax,%eax
801051cc:	89 c7                	mov    %eax,%edi
801051ce:	0f 88 94 00 00 00    	js     80105268 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051d4:	89 34 24             	mov    %esi,(%esp)
801051d7:	e8 b4 c5 ff ff       	call   80101790 <iunlock>
  end_op();
801051dc:	e8 9f d9 ff ff       	call   80102b80 <end_op>

  f->type = FD_INODE;
801051e1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
801051ea:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801051ed:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801051f4:	89 c2                	mov    %eax,%edx
801051f6:	83 e2 01             	and    $0x1,%edx
801051f9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051fc:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
801051fe:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80105201:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105203:	0f 95 43 09          	setne  0x9(%ebx)
}
80105207:	83 c4 2c             	add    $0x2c,%esp
8010520a:	5b                   	pop    %ebx
8010520b:	5e                   	pop    %esi
8010520c:	5f                   	pop    %edi
8010520d:	5d                   	pop    %ebp
8010520e:	c3                   	ret    
8010520f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80105210:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105213:	31 c9                	xor    %ecx,%ecx
80105215:	ba 02 00 00 00       	mov    $0x2,%edx
8010521a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105221:	e8 6a f8 ff ff       	call   80104a90 <create>
    if(ip == 0){
80105226:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105228:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010522a:	75 8a                	jne    801051b6 <sys_open+0x76>
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105230:	e8 4b d9 ff ff       	call   80102b80 <end_op>
}
80105235:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80105238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523d:	5b                   	pop    %ebx
8010523e:	5e                   	pop    %esi
8010523f:	5f                   	pop    %edi
80105240:	5d                   	pop    %ebp
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010524b:	85 c0                	test   %eax,%eax
8010524d:	0f 84 63 ff ff ff    	je     801051b6 <sys_open+0x76>
80105253:	90                   	nop
80105254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105258:	89 34 24             	mov    %esi,(%esp)
8010525b:	e8 b0 c6 ff ff       	call   80101910 <iunlockput>
80105260:	eb ce                	jmp    80105230 <sys_open+0xf0>
80105262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80105268:	89 1c 24             	mov    %ebx,(%esp)
8010526b:	e8 c0 bb ff ff       	call   80100e30 <fileclose>
80105270:	eb e6                	jmp    80105258 <sys_open+0x118>
80105272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_mkdir>:

int
sys_mkdir(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105286:	e8 85 d8 ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010528b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010528e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105299:	e8 02 f7 ff ff       	call   801049a0 <argstr>
8010529e:	85 c0                	test   %eax,%eax
801052a0:	78 2e                	js     801052d0 <sys_mkdir+0x50>
801052a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a5:	31 c9                	xor    %ecx,%ecx
801052a7:	ba 01 00 00 00       	mov    $0x1,%edx
801052ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052b3:	e8 d8 f7 ff ff       	call   80104a90 <create>
801052b8:	85 c0                	test   %eax,%eax
801052ba:	74 14                	je     801052d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052bc:	89 04 24             	mov    %eax,(%esp)
801052bf:	e8 4c c6 ff ff       	call   80101910 <iunlockput>
  end_op();
801052c4:	e8 b7 d8 ff ff       	call   80102b80 <end_op>
  return 0;
801052c9:	31 c0                	xor    %eax,%eax
}
801052cb:	c9                   	leave  
801052cc:	c3                   	ret    
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801052d0:	e8 ab d8 ff ff       	call   80102b80 <end_op>
    return -1;
801052d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052da:	c9                   	leave  
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_mknod>:

int
sys_mknod(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801052e6:	e8 25 d8 ff ff       	call   80102b10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801052eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801052f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f9:	e8 a2 f6 ff ff       	call   801049a0 <argstr>
801052fe:	85 c0                	test   %eax,%eax
80105300:	78 5e                	js     80105360 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105302:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105305:	89 44 24 04          	mov    %eax,0x4(%esp)
80105309:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105310:	e8 fb f5 ff ff       	call   80104910 <argint>
  if((argstr(0, &path)) < 0 ||
80105315:	85 c0                	test   %eax,%eax
80105317:	78 47                	js     80105360 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105319:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105320:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105327:	e8 e4 f5 ff ff       	call   80104910 <argint>
     argint(1, &major) < 0 ||
8010532c:	85 c0                	test   %eax,%eax
8010532e:	78 30                	js     80105360 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105330:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105334:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105339:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010533d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80105340:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105343:	e8 48 f7 ff ff       	call   80104a90 <create>
80105348:	85 c0                	test   %eax,%eax
8010534a:	74 14                	je     80105360 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010534c:	89 04 24             	mov    %eax,(%esp)
8010534f:	e8 bc c5 ff ff       	call   80101910 <iunlockput>
  end_op();
80105354:	e8 27 d8 ff ff       	call   80102b80 <end_op>
  return 0;
80105359:	31 c0                	xor    %eax,%eax
}
8010535b:	c9                   	leave  
8010535c:	c3                   	ret    
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105360:	e8 1b d8 ff ff       	call   80102b80 <end_op>
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010536a:	c9                   	leave  
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_chdir>:

int
sys_chdir(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
80105375:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105378:	e8 53 e3 ff ff       	call   801036d0 <myproc>
8010537d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010537f:	e8 8c d7 ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105384:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105387:	89 44 24 04          	mov    %eax,0x4(%esp)
8010538b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105392:	e8 09 f6 ff ff       	call   801049a0 <argstr>
80105397:	85 c0                	test   %eax,%eax
80105399:	78 4a                	js     801053e5 <sys_chdir+0x75>
8010539b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539e:	89 04 24             	mov    %eax,(%esp)
801053a1:	e8 5a cb ff ff       	call   80101f00 <namei>
801053a6:	85 c0                	test   %eax,%eax
801053a8:	89 c3                	mov    %eax,%ebx
801053aa:	74 39                	je     801053e5 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801053ac:	89 04 24             	mov    %eax,(%esp)
801053af:	e8 fc c2 ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801053b4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801053b9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
801053bc:	75 22                	jne    801053e0 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
801053be:	e8 cd c3 ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
801053c3:	8b 46 68             	mov    0x68(%esi),%eax
801053c6:	89 04 24             	mov    %eax,(%esp)
801053c9:	e8 02 c4 ff ff       	call   801017d0 <iput>
  end_op();
801053ce:	e8 ad d7 ff ff       	call   80102b80 <end_op>
  curproc->cwd = ip;
  return 0;
801053d3:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
801053d5:	89 5e 68             	mov    %ebx,0x68(%esi)
}
801053d8:	83 c4 20             	add    $0x20,%esp
801053db:	5b                   	pop    %ebx
801053dc:	5e                   	pop    %esi
801053dd:	5d                   	pop    %ebp
801053de:	c3                   	ret    
801053df:	90                   	nop
    iunlockput(ip);
801053e0:	e8 2b c5 ff ff       	call   80101910 <iunlockput>
    end_op();
801053e5:	e8 96 d7 ff ff       	call   80102b80 <end_op>
}
801053ea:	83 c4 20             	add    $0x20,%esp
    return -1;
801053ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f2:	5b                   	pop    %ebx
801053f3:	5e                   	pop    %esi
801053f4:	5d                   	pop    %ebp
801053f5:	c3                   	ret    
801053f6:	8d 76 00             	lea    0x0(%esi),%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_exec>:

int
sys_exec(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
80105406:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010540c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105412:	89 44 24 04          	mov    %eax,0x4(%esp)
80105416:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010541d:	e8 7e f5 ff ff       	call   801049a0 <argstr>
80105422:	85 c0                	test   %eax,%eax
80105424:	0f 88 84 00 00 00    	js     801054ae <sys_exec+0xae>
8010542a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105430:	89 44 24 04          	mov    %eax,0x4(%esp)
80105434:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010543b:	e8 d0 f4 ff ff       	call   80104910 <argint>
80105440:	85 c0                	test   %eax,%eax
80105442:	78 6a                	js     801054ae <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105444:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010544a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010544c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105453:	00 
80105454:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010545a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105461:	00 
80105462:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105468:	89 04 24             	mov    %eax,(%esp)
8010546b:	e8 b0 f1 ff ff       	call   80104620 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105470:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105476:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010547a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010547d:	89 04 24             	mov    %eax,(%esp)
80105480:	e8 eb f3 ff ff       	call   80104870 <fetchint>
80105485:	85 c0                	test   %eax,%eax
80105487:	78 25                	js     801054ae <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105489:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010548f:	85 c0                	test   %eax,%eax
80105491:	74 2d                	je     801054c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105493:	89 74 24 04          	mov    %esi,0x4(%esp)
80105497:	89 04 24             	mov    %eax,(%esp)
8010549a:	e8 11 f4 ff ff       	call   801048b0 <fetchstr>
8010549f:	85 c0                	test   %eax,%eax
801054a1:	78 0b                	js     801054ae <sys_exec+0xae>
  for(i=0;; i++){
801054a3:	83 c3 01             	add    $0x1,%ebx
801054a6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801054a9:	83 fb 20             	cmp    $0x20,%ebx
801054ac:	75 c2                	jne    80105470 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801054ae:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801054b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b9:	5b                   	pop    %ebx
801054ba:	5e                   	pop    %esi
801054bb:	5f                   	pop    %edi
801054bc:	5d                   	pop    %ebp
801054bd:	c3                   	ret    
801054be:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801054c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ca:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
801054d0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054d7:	00 00 00 00 
  return exec(path, argv);
801054db:	89 04 24             	mov    %eax,(%esp)
801054de:	e8 bd b4 ff ff       	call   801009a0 <exec>
}
801054e3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801054e9:	5b                   	pop    %ebx
801054ea:	5e                   	pop    %esi
801054eb:	5f                   	pop    %edi
801054ec:	5d                   	pop    %ebp
801054ed:	c3                   	ret    
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <sys_pipe>:

int
sys_pipe(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054f7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054fa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105501:	00 
80105502:	89 44 24 04          	mov    %eax,0x4(%esp)
80105506:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010550d:	e8 2e f4 ff ff       	call   80104940 <argptr>
80105512:	85 c0                	test   %eax,%eax
80105514:	78 6d                	js     80105583 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105519:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105520:	89 04 24             	mov    %eax,(%esp)
80105523:	e8 48 dc ff ff       	call   80103170 <pipealloc>
80105528:	85 c0                	test   %eax,%eax
8010552a:	78 57                	js     80105583 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010552c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552f:	e8 1c f5 ff ff       	call   80104a50 <fdalloc>
80105534:	85 c0                	test   %eax,%eax
80105536:	89 c3                	mov    %eax,%ebx
80105538:	78 33                	js     8010556d <sys_pipe+0x7d>
8010553a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553d:	e8 0e f5 ff ff       	call   80104a50 <fdalloc>
80105542:	85 c0                	test   %eax,%eax
80105544:	78 1a                	js     80105560 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105546:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105549:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010554b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010554e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105551:	83 c4 24             	add    $0x24,%esp
  return 0;
80105554:	31 c0                	xor    %eax,%eax
}
80105556:	5b                   	pop    %ebx
80105557:	5d                   	pop    %ebp
80105558:	c3                   	ret    
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105560:	e8 6b e1 ff ff       	call   801036d0 <myproc>
80105565:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010556c:	00 
    fileclose(rf);
8010556d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105570:	89 04 24             	mov    %eax,(%esp)
80105573:	e8 b8 b8 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010557b:	89 04 24             	mov    %eax,(%esp)
8010557e:	e8 ad b8 ff ff       	call   80100e30 <fileclose>
}
80105583:	83 c4 24             	add    $0x24,%esp
    return -1;
80105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558b:	5b                   	pop    %ebx
8010558c:	5d                   	pop    %ebp
8010558d:	c3                   	ret    
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105593:	5d                   	pop    %ebp
  return fork();
80105594:	e9 e7 e2 ff ff       	jmp    80103880 <fork>
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_exit>:

int
sys_exit(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055a6:	e8 a5 e5 ff ff       	call   80103b50 <exit>
  return 0;  // not reached
}
801055ab:	31 c0                	xor    %eax,%eax
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    
801055af:	90                   	nop

801055b0 <sys_wait>:

int
sys_wait(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801055b3:	5d                   	pop    %ebp
  return wait();
801055b4:	e9 37 e8 ff ff       	jmp    80103df0 <wait>
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_kill>:

int
sys_kill(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055d4:	e8 37 f3 ff ff       	call   80104910 <argint>
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 13                	js     801055f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e0:	89 04 24             	mov    %eax,(%esp)
801055e3:	e8 68 e9 ff ff       	call   80103f50 <kill>
}
801055e8:	c9                   	leave  
801055e9:	c3                   	ret    
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f5:	c9                   	leave  
801055f6:	c3                   	ret    
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_getpid>:

int
sys_getpid(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105606:	e8 c5 e0 ff ff       	call   801036d0 <myproc>
8010560b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <sys_sbrk>:

int
sys_sbrk(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	53                   	push   %ebx
80105614:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105617:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010561e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105625:	e8 e6 f2 ff ff       	call   80104910 <argint>
8010562a:	85 c0                	test   %eax,%eax
8010562c:	78 22                	js     80105650 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010562e:	e8 9d e0 ff ff       	call   801036d0 <myproc>
  if(growproc(n) < 0)
80105633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105636:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105638:	89 14 24             	mov    %edx,(%esp)
8010563b:	e8 d0 e1 ff ff       	call   80103810 <growproc>
80105640:	85 c0                	test   %eax,%eax
80105642:	78 0c                	js     80105650 <sys_sbrk+0x40>
    return -1;
  return addr;
80105644:	89 d8                	mov    %ebx,%eax
}
80105646:	83 c4 24             	add    $0x24,%esp
80105649:	5b                   	pop    %ebx
8010564a:	5d                   	pop    %ebp
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105655:	eb ef                	jmp    80105646 <sys_sbrk+0x36>
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <sys_sleep>:

int
sys_sleep(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010566e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105675:	e8 96 f2 ff ff       	call   80104910 <argint>
8010567a:	85 c0                	test   %eax,%eax
8010567c:	78 7e                	js     801056fc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010567e:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
80105685:	e8 d6 ee ff ff       	call   80104560 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010568a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010568d:	8b 1d 60 63 11 80    	mov    0x80116360,%ebx
  while(ticks - ticks0 < n){
80105693:	85 d2                	test   %edx,%edx
80105695:	75 29                	jne    801056c0 <sys_sleep+0x60>
80105697:	eb 4f                	jmp    801056e8 <sys_sleep+0x88>
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056a0:	c7 44 24 04 20 5b 11 	movl   $0x80115b20,0x4(%esp)
801056a7:	80 
801056a8:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
801056af:	e8 8c e6 ff ff       	call   80103d40 <sleep>
  while(ticks - ticks0 < n){
801056b4:	a1 60 63 11 80       	mov    0x80116360,%eax
801056b9:	29 d8                	sub    %ebx,%eax
801056bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056be:	73 28                	jae    801056e8 <sys_sleep+0x88>
    if(myproc()->killed){
801056c0:	e8 0b e0 ff ff       	call   801036d0 <myproc>
801056c5:	8b 40 24             	mov    0x24(%eax),%eax
801056c8:	85 c0                	test   %eax,%eax
801056ca:	74 d4                	je     801056a0 <sys_sleep+0x40>
      release(&tickslock);
801056cc:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
801056d3:	e8 f8 ee ff ff       	call   801045d0 <release>
      return -1;
801056d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056dd:	83 c4 24             	add    $0x24,%esp
801056e0:	5b                   	pop    %ebx
801056e1:	5d                   	pop    %ebp
801056e2:	c3                   	ret    
801056e3:	90                   	nop
801056e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
801056e8:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
801056ef:	e8 dc ee ff ff       	call   801045d0 <release>
}
801056f4:	83 c4 24             	add    $0x24,%esp
  return 0;
801056f7:	31 c0                	xor    %eax,%eax
}
801056f9:	5b                   	pop    %ebx
801056fa:	5d                   	pop    %ebp
801056fb:	c3                   	ret    
    return -1;
801056fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105701:	eb da                	jmp    801056dd <sys_sleep+0x7d>
80105703:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
80105714:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105717:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
8010571e:	e8 3d ee ff ff       	call   80104560 <acquire>
  xticks = ticks;
80105723:	8b 1d 60 63 11 80    	mov    0x80116360,%ebx
  release(&tickslock);
80105729:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
80105730:	e8 9b ee ff ff       	call   801045d0 <release>
  return xticks;
}
80105735:	83 c4 14             	add    $0x14,%esp
80105738:	89 d8                	mov    %ebx,%eax
8010573a:	5b                   	pop    %ebx
8010573b:	5d                   	pop    %ebp
8010573c:	c3                   	ret    
8010573d:	8d 76 00             	lea    0x0(%esi),%esi

80105740 <sys_info>:
int
sys_info(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 28             	sub    $0x28,%esp
	int param;// parameter required
	argint(0,&param);
80105746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010574d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105754:	e8 b7 f1 ff ff       	call   80104910 <argint>
	//1
	if(param==1)
80105759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575c:	83 f8 01             	cmp    $0x1,%eax
8010575f:	74 27                	je     80105788 <sys_info+0x48>
	{
		
		return info(param);
	}
	else if(param==2)
80105761:	83 f8 02             	cmp    $0x2,%eax
80105764:	74 32                	je     80105798 <sys_info+0x58>
	{
		return info(param);
	}
	else if(param==3)
80105766:	83 f8 03             	cmp    $0x3,%eax
80105769:	74 0d                	je     80105778 <sys_info+0x38>
	{
		return info(param);
	}
	else return info(param);
8010576b:	89 04 24             	mov    %eax,(%esp)
8010576e:	e8 2d e9 ff ff       	call   801040a0 <info>
	return 0;

}
80105773:	c9                   	leave  
80105774:	c3                   	ret    
80105775:	8d 76 00             	lea    0x0(%esi),%esi
		return info(param);
80105778:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
8010577f:	e8 1c e9 ff ff       	call   801040a0 <info>
}
80105784:	c9                   	leave  
80105785:	c3                   	ret    
80105786:	66 90                	xchg   %ax,%ax
		return info(param);
80105788:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010578f:	e8 0c e9 ff ff       	call   801040a0 <info>
}
80105794:	c9                   	leave  
80105795:	c3                   	ret    
80105796:	66 90                	xchg   %ax,%ax
		return info(param);
80105798:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010579f:	e8 fc e8 ff ff       	call   801040a0 <info>
}
801057a4:	c9                   	leave  
801057a5:	c3                   	ret    
801057a6:	8d 76 00             	lea    0x0(%esi),%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <sys_settick>:
int
sys_settick(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 28             	sub    $0x28,%esp
	int tick;
	argint(0,&tick);
801057b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801057bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057c4:	e8 47 f1 ff ff       	call   80104910 <argint>
	return settick(tick);
801057c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057cc:	89 04 24             	mov    %eax,(%esp)
801057cf:	e8 9c e9 ff ff       	call   80104170 <settick>
}
801057d4:	c9                   	leave  
801057d5:	c3                   	ret    
801057d6:	8d 76 00             	lea    0x0(%esi),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057e0 <sys_tickprintf>:
int
sys_tickprintf(void)
{ 
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 28             	sub    $0x28,%esp
  int para;
  argint(0,&para);
801057e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057f4:	e8 17 f1 ff ff       	call   80104910 <argint>
  if(para==0) return tickprintf(0);
801057f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057fc:	85 c0                	test   %eax,%eax
801057fe:	74 10                	je     80105810 <sys_tickprintf+0x30>
  else 
  return tickprintf(1);
80105800:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105807:	e8 d4 e9 ff ff       	call   801041e0 <tickprintf>
}
8010580c:	c9                   	leave  
8010580d:	c3                   	ret    
8010580e:	66 90                	xchg   %ax,%ax
  if(para==0) return tickprintf(0);
80105810:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105817:	e8 c4 e9 ff ff       	call   801041e0 <tickprintf>
}
8010581c:	c9                   	leave  
8010581d:	c3                   	ret    

8010581e <alltraps>:
8010581e:	1e                   	push   %ds
8010581f:	06                   	push   %es
80105820:	0f a0                	push   %fs
80105822:	0f a8                	push   %gs
80105824:	60                   	pusha  
80105825:	66 b8 10 00          	mov    $0x10,%ax
80105829:	8e d8                	mov    %eax,%ds
8010582b:	8e c0                	mov    %eax,%es
8010582d:	54                   	push   %esp
8010582e:	e8 ed 00 00 00       	call   80105920 <trap>
80105833:	83 c4 04             	add    $0x4,%esp

80105836 <trapret>:
80105836:	61                   	popa   
80105837:	0f a9                	pop    %gs
80105839:	0f a1                	pop    %fs
8010583b:	07                   	pop    %es
8010583c:	1f                   	pop    %ds
8010583d:	83 c4 08             	add    $0x8,%esp
80105840:	cf                   	iret   
80105841:	66 90                	xchg   %ax,%ax
80105843:	66 90                	xchg   %ax,%ax
80105845:	66 90                	xchg   %ax,%ax
80105847:	66 90                	xchg   %ax,%ax
80105849:	66 90                	xchg   %ax,%ax
8010584b:	66 90                	xchg   %ax,%ax
8010584d:	66 90                	xchg   %ax,%ax
8010584f:	90                   	nop

80105850 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105850:	31 c0                	xor    %eax,%eax
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105858:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010585f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105864:	66 89 0c c5 62 5b 11 	mov    %cx,-0x7feea49e(,%eax,8)
8010586b:	80 
8010586c:	c6 04 c5 64 5b 11 80 	movb   $0x0,-0x7feea49c(,%eax,8)
80105873:	00 
80105874:	c6 04 c5 65 5b 11 80 	movb   $0x8e,-0x7feea49b(,%eax,8)
8010587b:	8e 
8010587c:	66 89 14 c5 60 5b 11 	mov    %dx,-0x7feea4a0(,%eax,8)
80105883:	80 
80105884:	c1 ea 10             	shr    $0x10,%edx
80105887:	66 89 14 c5 66 5b 11 	mov    %dx,-0x7feea49a(,%eax,8)
8010588e:	80 
  for(i = 0; i < 256; i++)
8010588f:	83 c0 01             	add    $0x1,%eax
80105892:	3d 00 01 00 00       	cmp    $0x100,%eax
80105897:	75 bf                	jne    80105858 <tvinit+0x8>
{
80105899:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010589a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010589f:	89 e5                	mov    %esp,%ebp
801058a1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058a4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801058a9:	c7 44 24 04 05 7b 10 	movl   $0x80107b05,0x4(%esp)
801058b0:	80 
801058b1:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058b8:	66 89 15 62 5d 11 80 	mov    %dx,0x80115d62
801058bf:	66 a3 60 5d 11 80    	mov    %ax,0x80115d60
801058c5:	c1 e8 10             	shr    $0x10,%eax
801058c8:	c6 05 64 5d 11 80 00 	movb   $0x0,0x80115d64
801058cf:	c6 05 65 5d 11 80 ef 	movb   $0xef,0x80115d65
801058d6:	66 a3 66 5d 11 80    	mov    %ax,0x80115d66
  initlock(&tickslock, "time");
801058dc:	e8 0f eb ff ff       	call   801043f0 <initlock>
}
801058e1:	c9                   	leave  
801058e2:	c3                   	ret    
801058e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <idtinit>:

void
idtinit(void)
{
801058f0:	55                   	push   %ebp
  pd[0] = size-1;
801058f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058f6:	89 e5                	mov    %esp,%ebp
801058f8:	83 ec 10             	sub    $0x10,%esp
801058fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058ff:	b8 60 5b 11 80       	mov    $0x80115b60,%eax
80105904:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105908:	c1 e8 10             	shr    $0x10,%eax
8010590b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010590f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105912:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
80105926:	83 ec 3c             	sub    $0x3c,%esp
80105929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010592c:	8b 43 30             	mov    0x30(%ebx),%eax
8010592f:	83 f8 40             	cmp    $0x40,%eax
80105932:	0f 84 a0 01 00 00    	je     80105ad8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105938:	83 e8 20             	sub    $0x20,%eax
8010593b:	83 f8 1f             	cmp    $0x1f,%eax
8010593e:	77 08                	ja     80105948 <trap+0x28>
80105940:	ff 24 85 ac 7b 10 80 	jmp    *-0x7fef8454(,%eax,4)
80105947:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105948:	e8 83 dd ff ff       	call   801036d0 <myproc>
8010594d:	85 c0                	test   %eax,%eax
8010594f:	90                   	nop
80105950:	0f 84 fa 01 00 00    	je     80105b50 <trap+0x230>
80105956:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010595a:	0f 84 f0 01 00 00    	je     80105b50 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105960:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105963:	8b 53 38             	mov    0x38(%ebx),%edx
80105966:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105969:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010596c:	e8 3f dd ff ff       	call   801036b0 <cpuid>
80105971:	8b 73 30             	mov    0x30(%ebx),%esi
80105974:	89 c7                	mov    %eax,%edi
80105976:	8b 43 34             	mov    0x34(%ebx),%eax
80105979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010597c:	e8 4f dd ff ff       	call   801036d0 <myproc>
80105981:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105984:	e8 47 dd ff ff       	call   801036d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105989:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010598c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105990:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105993:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105996:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010599a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010599e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801059a1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059a4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801059a8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059ac:	89 54 24 10          	mov    %edx,0x10(%esp)
801059b0:	8b 40 10             	mov    0x10(%eax),%eax
801059b3:	c7 04 24 68 7b 10 80 	movl   $0x80107b68,(%esp)
801059ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801059be:	e8 8d ac ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801059c3:	e8 08 dd ff ff       	call   801036d0 <myproc>
801059c8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801059cf:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d0:	e8 fb dc ff ff       	call   801036d0 <myproc>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 0c                	je     801059e5 <trap+0xc5>
801059d9:	e8 f2 dc ff ff       	call   801036d0 <myproc>
801059de:	8b 50 24             	mov    0x24(%eax),%edx
801059e1:	85 d2                	test   %edx,%edx
801059e3:	75 4b                	jne    80105a30 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059e5:	e8 e6 dc ff ff       	call   801036d0 <myproc>
801059ea:	85 c0                	test   %eax,%eax
801059ec:	74 0d                	je     801059fb <trap+0xdb>
801059ee:	66 90                	xchg   %ax,%ax
801059f0:	e8 db dc ff ff       	call   801036d0 <myproc>
801059f5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059f9:	74 4d                	je     80105a48 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059fb:	e8 d0 dc ff ff       	call   801036d0 <myproc>
80105a00:	85 c0                	test   %eax,%eax
80105a02:	74 1d                	je     80105a21 <trap+0x101>
80105a04:	e8 c7 dc ff ff       	call   801036d0 <myproc>
80105a09:	8b 40 24             	mov    0x24(%eax),%eax
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	74 11                	je     80105a21 <trap+0x101>
80105a10:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a14:	83 e0 03             	and    $0x3,%eax
80105a17:	66 83 f8 03          	cmp    $0x3,%ax
80105a1b:	0f 84 e8 00 00 00    	je     80105b09 <trap+0x1e9>
    exit();
}
80105a21:	83 c4 3c             	add    $0x3c,%esp
80105a24:	5b                   	pop    %ebx
80105a25:	5e                   	pop    %esi
80105a26:	5f                   	pop    %edi
80105a27:	5d                   	pop    %ebp
80105a28:	c3                   	ret    
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a30:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a34:	83 e0 03             	and    $0x3,%eax
80105a37:	66 83 f8 03          	cmp    $0x3,%ax
80105a3b:	75 a8                	jne    801059e5 <trap+0xc5>
    exit();
80105a3d:	e8 0e e1 ff ff       	call   80103b50 <exit>
80105a42:	eb a1                	jmp    801059e5 <trap+0xc5>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105a48:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a50:	75 a9                	jne    801059fb <trap+0xdb>
    yield();
80105a52:	e8 a9 e2 ff ff       	call   80103d00 <yield>
80105a57:	eb a2                	jmp    801059fb <trap+0xdb>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105a60:	e8 4b dc ff ff       	call   801036b0 <cpuid>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	0f 84 b3 00 00 00    	je     80105b20 <trap+0x200>
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105a70:	e8 0b cd ff ff       	call   80102780 <lapiceoi>
    break;
80105a75:	e9 56 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105a80:	e8 4b cb ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105a85:	e8 f6 cc ff ff       	call   80102780 <lapiceoi>
    break;
80105a8a:	e9 41 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a8f:	90                   	nop
    uartintr();
80105a90:	e8 1b 02 00 00       	call   80105cb0 <uartintr>
    lapiceoi();
80105a95:	e8 e6 cc ff ff       	call   80102780 <lapiceoi>
    break;
80105a9a:	e9 31 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a9f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105aa0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105aa3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105aa7:	e8 04 dc ff ff       	call   801036b0 <cpuid>
80105aac:	c7 04 24 10 7b 10 80 	movl   $0x80107b10,(%esp)
80105ab3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105ab7:	89 74 24 08          	mov    %esi,0x8(%esp)
80105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105abf:	e8 8c ab ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105ac4:	e8 b7 cc ff ff       	call   80102780 <lapiceoi>
    break;
80105ac9:	e9 02 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105ace:	66 90                	xchg   %ax,%ax
    ideintr();
80105ad0:	e8 ab c5 ff ff       	call   80102080 <ideintr>
80105ad5:	eb 96                	jmp    80105a6d <trap+0x14d>
80105ad7:	90                   	nop
80105ad8:	90                   	nop
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ae0:	e8 eb db ff ff       	call   801036d0 <myproc>
80105ae5:	8b 70 24             	mov    0x24(%eax),%esi
80105ae8:	85 f6                	test   %esi,%esi
80105aea:	75 2c                	jne    80105b18 <trap+0x1f8>
    myproc()->tf = tf;
80105aec:	e8 df db ff ff       	call   801036d0 <myproc>
80105af1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105af4:	e8 e7 ee ff ff       	call   801049e0 <syscall>
    if(myproc()->killed)
80105af9:	e8 d2 db ff ff       	call   801036d0 <myproc>
80105afe:	8b 48 24             	mov    0x24(%eax),%ecx
80105b01:	85 c9                	test   %ecx,%ecx
80105b03:	0f 84 18 ff ff ff    	je     80105a21 <trap+0x101>
}
80105b09:	83 c4 3c             	add    $0x3c,%esp
80105b0c:	5b                   	pop    %ebx
80105b0d:	5e                   	pop    %esi
80105b0e:	5f                   	pop    %edi
80105b0f:	5d                   	pop    %ebp
      exit();
80105b10:	e9 3b e0 ff ff       	jmp    80103b50 <exit>
80105b15:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105b18:	e8 33 e0 ff ff       	call   80103b50 <exit>
80105b1d:	eb cd                	jmp    80105aec <trap+0x1cc>
80105b1f:	90                   	nop
      acquire(&tickslock);
80105b20:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
80105b27:	e8 34 ea ff ff       	call   80104560 <acquire>
      wakeup(&ticks);
80105b2c:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
      ticks++;
80105b33:	83 05 60 63 11 80 01 	addl   $0x1,0x80116360
      wakeup(&ticks);
80105b3a:	e8 a1 e3 ff ff       	call   80103ee0 <wakeup>
      release(&tickslock);
80105b3f:	c7 04 24 20 5b 11 80 	movl   $0x80115b20,(%esp)
80105b46:	e8 85 ea ff ff       	call   801045d0 <release>
80105b4b:	e9 1d ff ff ff       	jmp    80105a6d <trap+0x14d>
80105b50:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b53:	8b 73 38             	mov    0x38(%ebx),%esi
80105b56:	e8 55 db ff ff       	call   801036b0 <cpuid>
80105b5b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105b5f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105b63:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b67:	8b 43 30             	mov    0x30(%ebx),%eax
80105b6a:	c7 04 24 34 7b 10 80 	movl   $0x80107b34,(%esp)
80105b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b75:	e8 d6 aa ff ff       	call   80100650 <cprintf>
      panic("trap");
80105b7a:	c7 04 24 0a 7b 10 80 	movl   $0x80107b0a,(%esp)
80105b81:	e8 da a7 ff ff       	call   80100360 <panic>
80105b86:	66 90                	xchg   %ax,%ax
80105b88:	66 90                	xchg   %ax,%ax
80105b8a:	66 90                	xchg   %ax,%ax
80105b8c:	66 90                	xchg   %ax,%ax
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105b95:	55                   	push   %ebp
80105b96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	74 14                	je     80105bb0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ba1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ba2:	a8 01                	test   $0x1,%al
80105ba4:	74 0a                	je     80105bb0 <uartgetc+0x20>
80105ba6:	b2 f8                	mov    $0xf8,%dl
80105ba8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ba9:	0f b6 c0             	movzbl %al,%eax
}
80105bac:	5d                   	pop    %ebp
80105bad:	c3                   	ret    
80105bae:	66 90                	xchg   %ax,%ax
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bb5:	5d                   	pop    %ebp
80105bb6:	c3                   	ret    
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bc0 <uartputc>:
  if(!uart)
80105bc0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 3f                	je     80105c08 <uartputc+0x48>
{
80105bc9:	55                   	push   %ebp
80105bca:	89 e5                	mov    %esp,%ebp
80105bcc:	56                   	push   %esi
80105bcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105bd2:	53                   	push   %ebx
  if(!uart)
80105bd3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105bd8:	83 ec 10             	sub    $0x10,%esp
80105bdb:	eb 14                	jmp    80105bf1 <uartputc+0x31>
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105be0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105be7:	e8 b4 cb ff ff       	call   801027a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105bec:	83 eb 01             	sub    $0x1,%ebx
80105bef:	74 07                	je     80105bf8 <uartputc+0x38>
80105bf1:	89 f2                	mov    %esi,%edx
80105bf3:	ec                   	in     (%dx),%al
80105bf4:	a8 20                	test   $0x20,%al
80105bf6:	74 e8                	je     80105be0 <uartputc+0x20>
  outb(COM1+0, c);
80105bf8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bfc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c01:	ee                   	out    %al,(%dx)
}
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	5b                   	pop    %ebx
80105c06:	5e                   	pop    %esi
80105c07:	5d                   	pop    %ebp
80105c08:	f3 c3                	repz ret 
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c10 <uartinit>:
{
80105c10:	55                   	push   %ebp
80105c11:	31 c9                	xor    %ecx,%ecx
80105c13:	89 e5                	mov    %esp,%ebp
80105c15:	89 c8                	mov    %ecx,%eax
80105c17:	57                   	push   %edi
80105c18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c1d:	56                   	push   %esi
80105c1e:	89 fa                	mov    %edi,%edx
80105c20:	53                   	push   %ebx
80105c21:	83 ec 1c             	sub    $0x1c,%esp
80105c24:	ee                   	out    %al,(%dx)
80105c25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c2f:	89 f2                	mov    %esi,%edx
80105c31:	ee                   	out    %al,(%dx)
80105c32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c37:	b2 f8                	mov    $0xf8,%dl
80105c39:	ee                   	out    %al,(%dx)
80105c3a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c3f:	89 c8                	mov    %ecx,%eax
80105c41:	89 da                	mov    %ebx,%edx
80105c43:	ee                   	out    %al,(%dx)
80105c44:	b8 03 00 00 00       	mov    $0x3,%eax
80105c49:	89 f2                	mov    %esi,%edx
80105c4b:	ee                   	out    %al,(%dx)
80105c4c:	b2 fc                	mov    $0xfc,%dl
80105c4e:	89 c8                	mov    %ecx,%eax
80105c50:	ee                   	out    %al,(%dx)
80105c51:	b8 01 00 00 00       	mov    $0x1,%eax
80105c56:	89 da                	mov    %ebx,%edx
80105c58:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c59:	b2 fd                	mov    $0xfd,%dl
80105c5b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c5c:	3c ff                	cmp    $0xff,%al
80105c5e:	74 42                	je     80105ca2 <uartinit+0x92>
  uart = 1;
80105c60:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c67:	00 00 00 
80105c6a:	89 fa                	mov    %edi,%edx
80105c6c:	ec                   	in     (%dx),%al
80105c6d:	b2 f8                	mov    $0xf8,%dl
80105c6f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c77:	00 
  for(p="xv6...\n"; *p; p++)
80105c78:	bb 2c 7c 10 80       	mov    $0x80107c2c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c7d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105c84:	e8 27 c6 ff ff       	call   801022b0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105c89:	b8 78 00 00 00       	mov    $0x78,%eax
80105c8e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105c90:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105c93:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105c96:	e8 25 ff ff ff       	call   80105bc0 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105c9b:	0f be 03             	movsbl (%ebx),%eax
80105c9e:	84 c0                	test   %al,%al
80105ca0:	75 ee                	jne    80105c90 <uartinit+0x80>
}
80105ca2:	83 c4 1c             	add    $0x1c,%esp
80105ca5:	5b                   	pop    %ebx
80105ca6:	5e                   	pop    %esi
80105ca7:	5f                   	pop    %edi
80105ca8:	5d                   	pop    %ebp
80105ca9:	c3                   	ret    
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <uartintr>:

void
uartintr(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105cb6:	c7 04 24 90 5b 10 80 	movl   $0x80105b90,(%esp)
80105cbd:	e8 ee aa ff ff       	call   801007b0 <consoleintr>
}
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    

80105cc4 <vector0>:
80105cc4:	6a 00                	push   $0x0
80105cc6:	6a 00                	push   $0x0
80105cc8:	e9 51 fb ff ff       	jmp    8010581e <alltraps>

80105ccd <vector1>:
80105ccd:	6a 00                	push   $0x0
80105ccf:	6a 01                	push   $0x1
80105cd1:	e9 48 fb ff ff       	jmp    8010581e <alltraps>

80105cd6 <vector2>:
80105cd6:	6a 00                	push   $0x0
80105cd8:	6a 02                	push   $0x2
80105cda:	e9 3f fb ff ff       	jmp    8010581e <alltraps>

80105cdf <vector3>:
80105cdf:	6a 00                	push   $0x0
80105ce1:	6a 03                	push   $0x3
80105ce3:	e9 36 fb ff ff       	jmp    8010581e <alltraps>

80105ce8 <vector4>:
80105ce8:	6a 00                	push   $0x0
80105cea:	6a 04                	push   $0x4
80105cec:	e9 2d fb ff ff       	jmp    8010581e <alltraps>

80105cf1 <vector5>:
80105cf1:	6a 00                	push   $0x0
80105cf3:	6a 05                	push   $0x5
80105cf5:	e9 24 fb ff ff       	jmp    8010581e <alltraps>

80105cfa <vector6>:
80105cfa:	6a 00                	push   $0x0
80105cfc:	6a 06                	push   $0x6
80105cfe:	e9 1b fb ff ff       	jmp    8010581e <alltraps>

80105d03 <vector7>:
80105d03:	6a 00                	push   $0x0
80105d05:	6a 07                	push   $0x7
80105d07:	e9 12 fb ff ff       	jmp    8010581e <alltraps>

80105d0c <vector8>:
80105d0c:	6a 08                	push   $0x8
80105d0e:	e9 0b fb ff ff       	jmp    8010581e <alltraps>

80105d13 <vector9>:
80105d13:	6a 00                	push   $0x0
80105d15:	6a 09                	push   $0x9
80105d17:	e9 02 fb ff ff       	jmp    8010581e <alltraps>

80105d1c <vector10>:
80105d1c:	6a 0a                	push   $0xa
80105d1e:	e9 fb fa ff ff       	jmp    8010581e <alltraps>

80105d23 <vector11>:
80105d23:	6a 0b                	push   $0xb
80105d25:	e9 f4 fa ff ff       	jmp    8010581e <alltraps>

80105d2a <vector12>:
80105d2a:	6a 0c                	push   $0xc
80105d2c:	e9 ed fa ff ff       	jmp    8010581e <alltraps>

80105d31 <vector13>:
80105d31:	6a 0d                	push   $0xd
80105d33:	e9 e6 fa ff ff       	jmp    8010581e <alltraps>

80105d38 <vector14>:
80105d38:	6a 0e                	push   $0xe
80105d3a:	e9 df fa ff ff       	jmp    8010581e <alltraps>

80105d3f <vector15>:
80105d3f:	6a 00                	push   $0x0
80105d41:	6a 0f                	push   $0xf
80105d43:	e9 d6 fa ff ff       	jmp    8010581e <alltraps>

80105d48 <vector16>:
80105d48:	6a 00                	push   $0x0
80105d4a:	6a 10                	push   $0x10
80105d4c:	e9 cd fa ff ff       	jmp    8010581e <alltraps>

80105d51 <vector17>:
80105d51:	6a 11                	push   $0x11
80105d53:	e9 c6 fa ff ff       	jmp    8010581e <alltraps>

80105d58 <vector18>:
80105d58:	6a 00                	push   $0x0
80105d5a:	6a 12                	push   $0x12
80105d5c:	e9 bd fa ff ff       	jmp    8010581e <alltraps>

80105d61 <vector19>:
80105d61:	6a 00                	push   $0x0
80105d63:	6a 13                	push   $0x13
80105d65:	e9 b4 fa ff ff       	jmp    8010581e <alltraps>

80105d6a <vector20>:
80105d6a:	6a 00                	push   $0x0
80105d6c:	6a 14                	push   $0x14
80105d6e:	e9 ab fa ff ff       	jmp    8010581e <alltraps>

80105d73 <vector21>:
80105d73:	6a 00                	push   $0x0
80105d75:	6a 15                	push   $0x15
80105d77:	e9 a2 fa ff ff       	jmp    8010581e <alltraps>

80105d7c <vector22>:
80105d7c:	6a 00                	push   $0x0
80105d7e:	6a 16                	push   $0x16
80105d80:	e9 99 fa ff ff       	jmp    8010581e <alltraps>

80105d85 <vector23>:
80105d85:	6a 00                	push   $0x0
80105d87:	6a 17                	push   $0x17
80105d89:	e9 90 fa ff ff       	jmp    8010581e <alltraps>

80105d8e <vector24>:
80105d8e:	6a 00                	push   $0x0
80105d90:	6a 18                	push   $0x18
80105d92:	e9 87 fa ff ff       	jmp    8010581e <alltraps>

80105d97 <vector25>:
80105d97:	6a 00                	push   $0x0
80105d99:	6a 19                	push   $0x19
80105d9b:	e9 7e fa ff ff       	jmp    8010581e <alltraps>

80105da0 <vector26>:
80105da0:	6a 00                	push   $0x0
80105da2:	6a 1a                	push   $0x1a
80105da4:	e9 75 fa ff ff       	jmp    8010581e <alltraps>

80105da9 <vector27>:
80105da9:	6a 00                	push   $0x0
80105dab:	6a 1b                	push   $0x1b
80105dad:	e9 6c fa ff ff       	jmp    8010581e <alltraps>

80105db2 <vector28>:
80105db2:	6a 00                	push   $0x0
80105db4:	6a 1c                	push   $0x1c
80105db6:	e9 63 fa ff ff       	jmp    8010581e <alltraps>

80105dbb <vector29>:
80105dbb:	6a 00                	push   $0x0
80105dbd:	6a 1d                	push   $0x1d
80105dbf:	e9 5a fa ff ff       	jmp    8010581e <alltraps>

80105dc4 <vector30>:
80105dc4:	6a 00                	push   $0x0
80105dc6:	6a 1e                	push   $0x1e
80105dc8:	e9 51 fa ff ff       	jmp    8010581e <alltraps>

80105dcd <vector31>:
80105dcd:	6a 00                	push   $0x0
80105dcf:	6a 1f                	push   $0x1f
80105dd1:	e9 48 fa ff ff       	jmp    8010581e <alltraps>

80105dd6 <vector32>:
80105dd6:	6a 00                	push   $0x0
80105dd8:	6a 20                	push   $0x20
80105dda:	e9 3f fa ff ff       	jmp    8010581e <alltraps>

80105ddf <vector33>:
80105ddf:	6a 00                	push   $0x0
80105de1:	6a 21                	push   $0x21
80105de3:	e9 36 fa ff ff       	jmp    8010581e <alltraps>

80105de8 <vector34>:
80105de8:	6a 00                	push   $0x0
80105dea:	6a 22                	push   $0x22
80105dec:	e9 2d fa ff ff       	jmp    8010581e <alltraps>

80105df1 <vector35>:
80105df1:	6a 00                	push   $0x0
80105df3:	6a 23                	push   $0x23
80105df5:	e9 24 fa ff ff       	jmp    8010581e <alltraps>

80105dfa <vector36>:
80105dfa:	6a 00                	push   $0x0
80105dfc:	6a 24                	push   $0x24
80105dfe:	e9 1b fa ff ff       	jmp    8010581e <alltraps>

80105e03 <vector37>:
80105e03:	6a 00                	push   $0x0
80105e05:	6a 25                	push   $0x25
80105e07:	e9 12 fa ff ff       	jmp    8010581e <alltraps>

80105e0c <vector38>:
80105e0c:	6a 00                	push   $0x0
80105e0e:	6a 26                	push   $0x26
80105e10:	e9 09 fa ff ff       	jmp    8010581e <alltraps>

80105e15 <vector39>:
80105e15:	6a 00                	push   $0x0
80105e17:	6a 27                	push   $0x27
80105e19:	e9 00 fa ff ff       	jmp    8010581e <alltraps>

80105e1e <vector40>:
80105e1e:	6a 00                	push   $0x0
80105e20:	6a 28                	push   $0x28
80105e22:	e9 f7 f9 ff ff       	jmp    8010581e <alltraps>

80105e27 <vector41>:
80105e27:	6a 00                	push   $0x0
80105e29:	6a 29                	push   $0x29
80105e2b:	e9 ee f9 ff ff       	jmp    8010581e <alltraps>

80105e30 <vector42>:
80105e30:	6a 00                	push   $0x0
80105e32:	6a 2a                	push   $0x2a
80105e34:	e9 e5 f9 ff ff       	jmp    8010581e <alltraps>

80105e39 <vector43>:
80105e39:	6a 00                	push   $0x0
80105e3b:	6a 2b                	push   $0x2b
80105e3d:	e9 dc f9 ff ff       	jmp    8010581e <alltraps>

80105e42 <vector44>:
80105e42:	6a 00                	push   $0x0
80105e44:	6a 2c                	push   $0x2c
80105e46:	e9 d3 f9 ff ff       	jmp    8010581e <alltraps>

80105e4b <vector45>:
80105e4b:	6a 00                	push   $0x0
80105e4d:	6a 2d                	push   $0x2d
80105e4f:	e9 ca f9 ff ff       	jmp    8010581e <alltraps>

80105e54 <vector46>:
80105e54:	6a 00                	push   $0x0
80105e56:	6a 2e                	push   $0x2e
80105e58:	e9 c1 f9 ff ff       	jmp    8010581e <alltraps>

80105e5d <vector47>:
80105e5d:	6a 00                	push   $0x0
80105e5f:	6a 2f                	push   $0x2f
80105e61:	e9 b8 f9 ff ff       	jmp    8010581e <alltraps>

80105e66 <vector48>:
80105e66:	6a 00                	push   $0x0
80105e68:	6a 30                	push   $0x30
80105e6a:	e9 af f9 ff ff       	jmp    8010581e <alltraps>

80105e6f <vector49>:
80105e6f:	6a 00                	push   $0x0
80105e71:	6a 31                	push   $0x31
80105e73:	e9 a6 f9 ff ff       	jmp    8010581e <alltraps>

80105e78 <vector50>:
80105e78:	6a 00                	push   $0x0
80105e7a:	6a 32                	push   $0x32
80105e7c:	e9 9d f9 ff ff       	jmp    8010581e <alltraps>

80105e81 <vector51>:
80105e81:	6a 00                	push   $0x0
80105e83:	6a 33                	push   $0x33
80105e85:	e9 94 f9 ff ff       	jmp    8010581e <alltraps>

80105e8a <vector52>:
80105e8a:	6a 00                	push   $0x0
80105e8c:	6a 34                	push   $0x34
80105e8e:	e9 8b f9 ff ff       	jmp    8010581e <alltraps>

80105e93 <vector53>:
80105e93:	6a 00                	push   $0x0
80105e95:	6a 35                	push   $0x35
80105e97:	e9 82 f9 ff ff       	jmp    8010581e <alltraps>

80105e9c <vector54>:
80105e9c:	6a 00                	push   $0x0
80105e9e:	6a 36                	push   $0x36
80105ea0:	e9 79 f9 ff ff       	jmp    8010581e <alltraps>

80105ea5 <vector55>:
80105ea5:	6a 00                	push   $0x0
80105ea7:	6a 37                	push   $0x37
80105ea9:	e9 70 f9 ff ff       	jmp    8010581e <alltraps>

80105eae <vector56>:
80105eae:	6a 00                	push   $0x0
80105eb0:	6a 38                	push   $0x38
80105eb2:	e9 67 f9 ff ff       	jmp    8010581e <alltraps>

80105eb7 <vector57>:
80105eb7:	6a 00                	push   $0x0
80105eb9:	6a 39                	push   $0x39
80105ebb:	e9 5e f9 ff ff       	jmp    8010581e <alltraps>

80105ec0 <vector58>:
80105ec0:	6a 00                	push   $0x0
80105ec2:	6a 3a                	push   $0x3a
80105ec4:	e9 55 f9 ff ff       	jmp    8010581e <alltraps>

80105ec9 <vector59>:
80105ec9:	6a 00                	push   $0x0
80105ecb:	6a 3b                	push   $0x3b
80105ecd:	e9 4c f9 ff ff       	jmp    8010581e <alltraps>

80105ed2 <vector60>:
80105ed2:	6a 00                	push   $0x0
80105ed4:	6a 3c                	push   $0x3c
80105ed6:	e9 43 f9 ff ff       	jmp    8010581e <alltraps>

80105edb <vector61>:
80105edb:	6a 00                	push   $0x0
80105edd:	6a 3d                	push   $0x3d
80105edf:	e9 3a f9 ff ff       	jmp    8010581e <alltraps>

80105ee4 <vector62>:
80105ee4:	6a 00                	push   $0x0
80105ee6:	6a 3e                	push   $0x3e
80105ee8:	e9 31 f9 ff ff       	jmp    8010581e <alltraps>

80105eed <vector63>:
80105eed:	6a 00                	push   $0x0
80105eef:	6a 3f                	push   $0x3f
80105ef1:	e9 28 f9 ff ff       	jmp    8010581e <alltraps>

80105ef6 <vector64>:
80105ef6:	6a 00                	push   $0x0
80105ef8:	6a 40                	push   $0x40
80105efa:	e9 1f f9 ff ff       	jmp    8010581e <alltraps>

80105eff <vector65>:
80105eff:	6a 00                	push   $0x0
80105f01:	6a 41                	push   $0x41
80105f03:	e9 16 f9 ff ff       	jmp    8010581e <alltraps>

80105f08 <vector66>:
80105f08:	6a 00                	push   $0x0
80105f0a:	6a 42                	push   $0x42
80105f0c:	e9 0d f9 ff ff       	jmp    8010581e <alltraps>

80105f11 <vector67>:
80105f11:	6a 00                	push   $0x0
80105f13:	6a 43                	push   $0x43
80105f15:	e9 04 f9 ff ff       	jmp    8010581e <alltraps>

80105f1a <vector68>:
80105f1a:	6a 00                	push   $0x0
80105f1c:	6a 44                	push   $0x44
80105f1e:	e9 fb f8 ff ff       	jmp    8010581e <alltraps>

80105f23 <vector69>:
80105f23:	6a 00                	push   $0x0
80105f25:	6a 45                	push   $0x45
80105f27:	e9 f2 f8 ff ff       	jmp    8010581e <alltraps>

80105f2c <vector70>:
80105f2c:	6a 00                	push   $0x0
80105f2e:	6a 46                	push   $0x46
80105f30:	e9 e9 f8 ff ff       	jmp    8010581e <alltraps>

80105f35 <vector71>:
80105f35:	6a 00                	push   $0x0
80105f37:	6a 47                	push   $0x47
80105f39:	e9 e0 f8 ff ff       	jmp    8010581e <alltraps>

80105f3e <vector72>:
80105f3e:	6a 00                	push   $0x0
80105f40:	6a 48                	push   $0x48
80105f42:	e9 d7 f8 ff ff       	jmp    8010581e <alltraps>

80105f47 <vector73>:
80105f47:	6a 00                	push   $0x0
80105f49:	6a 49                	push   $0x49
80105f4b:	e9 ce f8 ff ff       	jmp    8010581e <alltraps>

80105f50 <vector74>:
80105f50:	6a 00                	push   $0x0
80105f52:	6a 4a                	push   $0x4a
80105f54:	e9 c5 f8 ff ff       	jmp    8010581e <alltraps>

80105f59 <vector75>:
80105f59:	6a 00                	push   $0x0
80105f5b:	6a 4b                	push   $0x4b
80105f5d:	e9 bc f8 ff ff       	jmp    8010581e <alltraps>

80105f62 <vector76>:
80105f62:	6a 00                	push   $0x0
80105f64:	6a 4c                	push   $0x4c
80105f66:	e9 b3 f8 ff ff       	jmp    8010581e <alltraps>

80105f6b <vector77>:
80105f6b:	6a 00                	push   $0x0
80105f6d:	6a 4d                	push   $0x4d
80105f6f:	e9 aa f8 ff ff       	jmp    8010581e <alltraps>

80105f74 <vector78>:
80105f74:	6a 00                	push   $0x0
80105f76:	6a 4e                	push   $0x4e
80105f78:	e9 a1 f8 ff ff       	jmp    8010581e <alltraps>

80105f7d <vector79>:
80105f7d:	6a 00                	push   $0x0
80105f7f:	6a 4f                	push   $0x4f
80105f81:	e9 98 f8 ff ff       	jmp    8010581e <alltraps>

80105f86 <vector80>:
80105f86:	6a 00                	push   $0x0
80105f88:	6a 50                	push   $0x50
80105f8a:	e9 8f f8 ff ff       	jmp    8010581e <alltraps>

80105f8f <vector81>:
80105f8f:	6a 00                	push   $0x0
80105f91:	6a 51                	push   $0x51
80105f93:	e9 86 f8 ff ff       	jmp    8010581e <alltraps>

80105f98 <vector82>:
80105f98:	6a 00                	push   $0x0
80105f9a:	6a 52                	push   $0x52
80105f9c:	e9 7d f8 ff ff       	jmp    8010581e <alltraps>

80105fa1 <vector83>:
80105fa1:	6a 00                	push   $0x0
80105fa3:	6a 53                	push   $0x53
80105fa5:	e9 74 f8 ff ff       	jmp    8010581e <alltraps>

80105faa <vector84>:
80105faa:	6a 00                	push   $0x0
80105fac:	6a 54                	push   $0x54
80105fae:	e9 6b f8 ff ff       	jmp    8010581e <alltraps>

80105fb3 <vector85>:
80105fb3:	6a 00                	push   $0x0
80105fb5:	6a 55                	push   $0x55
80105fb7:	e9 62 f8 ff ff       	jmp    8010581e <alltraps>

80105fbc <vector86>:
80105fbc:	6a 00                	push   $0x0
80105fbe:	6a 56                	push   $0x56
80105fc0:	e9 59 f8 ff ff       	jmp    8010581e <alltraps>

80105fc5 <vector87>:
80105fc5:	6a 00                	push   $0x0
80105fc7:	6a 57                	push   $0x57
80105fc9:	e9 50 f8 ff ff       	jmp    8010581e <alltraps>

80105fce <vector88>:
80105fce:	6a 00                	push   $0x0
80105fd0:	6a 58                	push   $0x58
80105fd2:	e9 47 f8 ff ff       	jmp    8010581e <alltraps>

80105fd7 <vector89>:
80105fd7:	6a 00                	push   $0x0
80105fd9:	6a 59                	push   $0x59
80105fdb:	e9 3e f8 ff ff       	jmp    8010581e <alltraps>

80105fe0 <vector90>:
80105fe0:	6a 00                	push   $0x0
80105fe2:	6a 5a                	push   $0x5a
80105fe4:	e9 35 f8 ff ff       	jmp    8010581e <alltraps>

80105fe9 <vector91>:
80105fe9:	6a 00                	push   $0x0
80105feb:	6a 5b                	push   $0x5b
80105fed:	e9 2c f8 ff ff       	jmp    8010581e <alltraps>

80105ff2 <vector92>:
80105ff2:	6a 00                	push   $0x0
80105ff4:	6a 5c                	push   $0x5c
80105ff6:	e9 23 f8 ff ff       	jmp    8010581e <alltraps>

80105ffb <vector93>:
80105ffb:	6a 00                	push   $0x0
80105ffd:	6a 5d                	push   $0x5d
80105fff:	e9 1a f8 ff ff       	jmp    8010581e <alltraps>

80106004 <vector94>:
80106004:	6a 00                	push   $0x0
80106006:	6a 5e                	push   $0x5e
80106008:	e9 11 f8 ff ff       	jmp    8010581e <alltraps>

8010600d <vector95>:
8010600d:	6a 00                	push   $0x0
8010600f:	6a 5f                	push   $0x5f
80106011:	e9 08 f8 ff ff       	jmp    8010581e <alltraps>

80106016 <vector96>:
80106016:	6a 00                	push   $0x0
80106018:	6a 60                	push   $0x60
8010601a:	e9 ff f7 ff ff       	jmp    8010581e <alltraps>

8010601f <vector97>:
8010601f:	6a 00                	push   $0x0
80106021:	6a 61                	push   $0x61
80106023:	e9 f6 f7 ff ff       	jmp    8010581e <alltraps>

80106028 <vector98>:
80106028:	6a 00                	push   $0x0
8010602a:	6a 62                	push   $0x62
8010602c:	e9 ed f7 ff ff       	jmp    8010581e <alltraps>

80106031 <vector99>:
80106031:	6a 00                	push   $0x0
80106033:	6a 63                	push   $0x63
80106035:	e9 e4 f7 ff ff       	jmp    8010581e <alltraps>

8010603a <vector100>:
8010603a:	6a 00                	push   $0x0
8010603c:	6a 64                	push   $0x64
8010603e:	e9 db f7 ff ff       	jmp    8010581e <alltraps>

80106043 <vector101>:
80106043:	6a 00                	push   $0x0
80106045:	6a 65                	push   $0x65
80106047:	e9 d2 f7 ff ff       	jmp    8010581e <alltraps>

8010604c <vector102>:
8010604c:	6a 00                	push   $0x0
8010604e:	6a 66                	push   $0x66
80106050:	e9 c9 f7 ff ff       	jmp    8010581e <alltraps>

80106055 <vector103>:
80106055:	6a 00                	push   $0x0
80106057:	6a 67                	push   $0x67
80106059:	e9 c0 f7 ff ff       	jmp    8010581e <alltraps>

8010605e <vector104>:
8010605e:	6a 00                	push   $0x0
80106060:	6a 68                	push   $0x68
80106062:	e9 b7 f7 ff ff       	jmp    8010581e <alltraps>

80106067 <vector105>:
80106067:	6a 00                	push   $0x0
80106069:	6a 69                	push   $0x69
8010606b:	e9 ae f7 ff ff       	jmp    8010581e <alltraps>

80106070 <vector106>:
80106070:	6a 00                	push   $0x0
80106072:	6a 6a                	push   $0x6a
80106074:	e9 a5 f7 ff ff       	jmp    8010581e <alltraps>

80106079 <vector107>:
80106079:	6a 00                	push   $0x0
8010607b:	6a 6b                	push   $0x6b
8010607d:	e9 9c f7 ff ff       	jmp    8010581e <alltraps>

80106082 <vector108>:
80106082:	6a 00                	push   $0x0
80106084:	6a 6c                	push   $0x6c
80106086:	e9 93 f7 ff ff       	jmp    8010581e <alltraps>

8010608b <vector109>:
8010608b:	6a 00                	push   $0x0
8010608d:	6a 6d                	push   $0x6d
8010608f:	e9 8a f7 ff ff       	jmp    8010581e <alltraps>

80106094 <vector110>:
80106094:	6a 00                	push   $0x0
80106096:	6a 6e                	push   $0x6e
80106098:	e9 81 f7 ff ff       	jmp    8010581e <alltraps>

8010609d <vector111>:
8010609d:	6a 00                	push   $0x0
8010609f:	6a 6f                	push   $0x6f
801060a1:	e9 78 f7 ff ff       	jmp    8010581e <alltraps>

801060a6 <vector112>:
801060a6:	6a 00                	push   $0x0
801060a8:	6a 70                	push   $0x70
801060aa:	e9 6f f7 ff ff       	jmp    8010581e <alltraps>

801060af <vector113>:
801060af:	6a 00                	push   $0x0
801060b1:	6a 71                	push   $0x71
801060b3:	e9 66 f7 ff ff       	jmp    8010581e <alltraps>

801060b8 <vector114>:
801060b8:	6a 00                	push   $0x0
801060ba:	6a 72                	push   $0x72
801060bc:	e9 5d f7 ff ff       	jmp    8010581e <alltraps>

801060c1 <vector115>:
801060c1:	6a 00                	push   $0x0
801060c3:	6a 73                	push   $0x73
801060c5:	e9 54 f7 ff ff       	jmp    8010581e <alltraps>

801060ca <vector116>:
801060ca:	6a 00                	push   $0x0
801060cc:	6a 74                	push   $0x74
801060ce:	e9 4b f7 ff ff       	jmp    8010581e <alltraps>

801060d3 <vector117>:
801060d3:	6a 00                	push   $0x0
801060d5:	6a 75                	push   $0x75
801060d7:	e9 42 f7 ff ff       	jmp    8010581e <alltraps>

801060dc <vector118>:
801060dc:	6a 00                	push   $0x0
801060de:	6a 76                	push   $0x76
801060e0:	e9 39 f7 ff ff       	jmp    8010581e <alltraps>

801060e5 <vector119>:
801060e5:	6a 00                	push   $0x0
801060e7:	6a 77                	push   $0x77
801060e9:	e9 30 f7 ff ff       	jmp    8010581e <alltraps>

801060ee <vector120>:
801060ee:	6a 00                	push   $0x0
801060f0:	6a 78                	push   $0x78
801060f2:	e9 27 f7 ff ff       	jmp    8010581e <alltraps>

801060f7 <vector121>:
801060f7:	6a 00                	push   $0x0
801060f9:	6a 79                	push   $0x79
801060fb:	e9 1e f7 ff ff       	jmp    8010581e <alltraps>

80106100 <vector122>:
80106100:	6a 00                	push   $0x0
80106102:	6a 7a                	push   $0x7a
80106104:	e9 15 f7 ff ff       	jmp    8010581e <alltraps>

80106109 <vector123>:
80106109:	6a 00                	push   $0x0
8010610b:	6a 7b                	push   $0x7b
8010610d:	e9 0c f7 ff ff       	jmp    8010581e <alltraps>

80106112 <vector124>:
80106112:	6a 00                	push   $0x0
80106114:	6a 7c                	push   $0x7c
80106116:	e9 03 f7 ff ff       	jmp    8010581e <alltraps>

8010611b <vector125>:
8010611b:	6a 00                	push   $0x0
8010611d:	6a 7d                	push   $0x7d
8010611f:	e9 fa f6 ff ff       	jmp    8010581e <alltraps>

80106124 <vector126>:
80106124:	6a 00                	push   $0x0
80106126:	6a 7e                	push   $0x7e
80106128:	e9 f1 f6 ff ff       	jmp    8010581e <alltraps>

8010612d <vector127>:
8010612d:	6a 00                	push   $0x0
8010612f:	6a 7f                	push   $0x7f
80106131:	e9 e8 f6 ff ff       	jmp    8010581e <alltraps>

80106136 <vector128>:
80106136:	6a 00                	push   $0x0
80106138:	68 80 00 00 00       	push   $0x80
8010613d:	e9 dc f6 ff ff       	jmp    8010581e <alltraps>

80106142 <vector129>:
80106142:	6a 00                	push   $0x0
80106144:	68 81 00 00 00       	push   $0x81
80106149:	e9 d0 f6 ff ff       	jmp    8010581e <alltraps>

8010614e <vector130>:
8010614e:	6a 00                	push   $0x0
80106150:	68 82 00 00 00       	push   $0x82
80106155:	e9 c4 f6 ff ff       	jmp    8010581e <alltraps>

8010615a <vector131>:
8010615a:	6a 00                	push   $0x0
8010615c:	68 83 00 00 00       	push   $0x83
80106161:	e9 b8 f6 ff ff       	jmp    8010581e <alltraps>

80106166 <vector132>:
80106166:	6a 00                	push   $0x0
80106168:	68 84 00 00 00       	push   $0x84
8010616d:	e9 ac f6 ff ff       	jmp    8010581e <alltraps>

80106172 <vector133>:
80106172:	6a 00                	push   $0x0
80106174:	68 85 00 00 00       	push   $0x85
80106179:	e9 a0 f6 ff ff       	jmp    8010581e <alltraps>

8010617e <vector134>:
8010617e:	6a 00                	push   $0x0
80106180:	68 86 00 00 00       	push   $0x86
80106185:	e9 94 f6 ff ff       	jmp    8010581e <alltraps>

8010618a <vector135>:
8010618a:	6a 00                	push   $0x0
8010618c:	68 87 00 00 00       	push   $0x87
80106191:	e9 88 f6 ff ff       	jmp    8010581e <alltraps>

80106196 <vector136>:
80106196:	6a 00                	push   $0x0
80106198:	68 88 00 00 00       	push   $0x88
8010619d:	e9 7c f6 ff ff       	jmp    8010581e <alltraps>

801061a2 <vector137>:
801061a2:	6a 00                	push   $0x0
801061a4:	68 89 00 00 00       	push   $0x89
801061a9:	e9 70 f6 ff ff       	jmp    8010581e <alltraps>

801061ae <vector138>:
801061ae:	6a 00                	push   $0x0
801061b0:	68 8a 00 00 00       	push   $0x8a
801061b5:	e9 64 f6 ff ff       	jmp    8010581e <alltraps>

801061ba <vector139>:
801061ba:	6a 00                	push   $0x0
801061bc:	68 8b 00 00 00       	push   $0x8b
801061c1:	e9 58 f6 ff ff       	jmp    8010581e <alltraps>

801061c6 <vector140>:
801061c6:	6a 00                	push   $0x0
801061c8:	68 8c 00 00 00       	push   $0x8c
801061cd:	e9 4c f6 ff ff       	jmp    8010581e <alltraps>

801061d2 <vector141>:
801061d2:	6a 00                	push   $0x0
801061d4:	68 8d 00 00 00       	push   $0x8d
801061d9:	e9 40 f6 ff ff       	jmp    8010581e <alltraps>

801061de <vector142>:
801061de:	6a 00                	push   $0x0
801061e0:	68 8e 00 00 00       	push   $0x8e
801061e5:	e9 34 f6 ff ff       	jmp    8010581e <alltraps>

801061ea <vector143>:
801061ea:	6a 00                	push   $0x0
801061ec:	68 8f 00 00 00       	push   $0x8f
801061f1:	e9 28 f6 ff ff       	jmp    8010581e <alltraps>

801061f6 <vector144>:
801061f6:	6a 00                	push   $0x0
801061f8:	68 90 00 00 00       	push   $0x90
801061fd:	e9 1c f6 ff ff       	jmp    8010581e <alltraps>

80106202 <vector145>:
80106202:	6a 00                	push   $0x0
80106204:	68 91 00 00 00       	push   $0x91
80106209:	e9 10 f6 ff ff       	jmp    8010581e <alltraps>

8010620e <vector146>:
8010620e:	6a 00                	push   $0x0
80106210:	68 92 00 00 00       	push   $0x92
80106215:	e9 04 f6 ff ff       	jmp    8010581e <alltraps>

8010621a <vector147>:
8010621a:	6a 00                	push   $0x0
8010621c:	68 93 00 00 00       	push   $0x93
80106221:	e9 f8 f5 ff ff       	jmp    8010581e <alltraps>

80106226 <vector148>:
80106226:	6a 00                	push   $0x0
80106228:	68 94 00 00 00       	push   $0x94
8010622d:	e9 ec f5 ff ff       	jmp    8010581e <alltraps>

80106232 <vector149>:
80106232:	6a 00                	push   $0x0
80106234:	68 95 00 00 00       	push   $0x95
80106239:	e9 e0 f5 ff ff       	jmp    8010581e <alltraps>

8010623e <vector150>:
8010623e:	6a 00                	push   $0x0
80106240:	68 96 00 00 00       	push   $0x96
80106245:	e9 d4 f5 ff ff       	jmp    8010581e <alltraps>

8010624a <vector151>:
8010624a:	6a 00                	push   $0x0
8010624c:	68 97 00 00 00       	push   $0x97
80106251:	e9 c8 f5 ff ff       	jmp    8010581e <alltraps>

80106256 <vector152>:
80106256:	6a 00                	push   $0x0
80106258:	68 98 00 00 00       	push   $0x98
8010625d:	e9 bc f5 ff ff       	jmp    8010581e <alltraps>

80106262 <vector153>:
80106262:	6a 00                	push   $0x0
80106264:	68 99 00 00 00       	push   $0x99
80106269:	e9 b0 f5 ff ff       	jmp    8010581e <alltraps>

8010626e <vector154>:
8010626e:	6a 00                	push   $0x0
80106270:	68 9a 00 00 00       	push   $0x9a
80106275:	e9 a4 f5 ff ff       	jmp    8010581e <alltraps>

8010627a <vector155>:
8010627a:	6a 00                	push   $0x0
8010627c:	68 9b 00 00 00       	push   $0x9b
80106281:	e9 98 f5 ff ff       	jmp    8010581e <alltraps>

80106286 <vector156>:
80106286:	6a 00                	push   $0x0
80106288:	68 9c 00 00 00       	push   $0x9c
8010628d:	e9 8c f5 ff ff       	jmp    8010581e <alltraps>

80106292 <vector157>:
80106292:	6a 00                	push   $0x0
80106294:	68 9d 00 00 00       	push   $0x9d
80106299:	e9 80 f5 ff ff       	jmp    8010581e <alltraps>

8010629e <vector158>:
8010629e:	6a 00                	push   $0x0
801062a0:	68 9e 00 00 00       	push   $0x9e
801062a5:	e9 74 f5 ff ff       	jmp    8010581e <alltraps>

801062aa <vector159>:
801062aa:	6a 00                	push   $0x0
801062ac:	68 9f 00 00 00       	push   $0x9f
801062b1:	e9 68 f5 ff ff       	jmp    8010581e <alltraps>

801062b6 <vector160>:
801062b6:	6a 00                	push   $0x0
801062b8:	68 a0 00 00 00       	push   $0xa0
801062bd:	e9 5c f5 ff ff       	jmp    8010581e <alltraps>

801062c2 <vector161>:
801062c2:	6a 00                	push   $0x0
801062c4:	68 a1 00 00 00       	push   $0xa1
801062c9:	e9 50 f5 ff ff       	jmp    8010581e <alltraps>

801062ce <vector162>:
801062ce:	6a 00                	push   $0x0
801062d0:	68 a2 00 00 00       	push   $0xa2
801062d5:	e9 44 f5 ff ff       	jmp    8010581e <alltraps>

801062da <vector163>:
801062da:	6a 00                	push   $0x0
801062dc:	68 a3 00 00 00       	push   $0xa3
801062e1:	e9 38 f5 ff ff       	jmp    8010581e <alltraps>

801062e6 <vector164>:
801062e6:	6a 00                	push   $0x0
801062e8:	68 a4 00 00 00       	push   $0xa4
801062ed:	e9 2c f5 ff ff       	jmp    8010581e <alltraps>

801062f2 <vector165>:
801062f2:	6a 00                	push   $0x0
801062f4:	68 a5 00 00 00       	push   $0xa5
801062f9:	e9 20 f5 ff ff       	jmp    8010581e <alltraps>

801062fe <vector166>:
801062fe:	6a 00                	push   $0x0
80106300:	68 a6 00 00 00       	push   $0xa6
80106305:	e9 14 f5 ff ff       	jmp    8010581e <alltraps>

8010630a <vector167>:
8010630a:	6a 00                	push   $0x0
8010630c:	68 a7 00 00 00       	push   $0xa7
80106311:	e9 08 f5 ff ff       	jmp    8010581e <alltraps>

80106316 <vector168>:
80106316:	6a 00                	push   $0x0
80106318:	68 a8 00 00 00       	push   $0xa8
8010631d:	e9 fc f4 ff ff       	jmp    8010581e <alltraps>

80106322 <vector169>:
80106322:	6a 00                	push   $0x0
80106324:	68 a9 00 00 00       	push   $0xa9
80106329:	e9 f0 f4 ff ff       	jmp    8010581e <alltraps>

8010632e <vector170>:
8010632e:	6a 00                	push   $0x0
80106330:	68 aa 00 00 00       	push   $0xaa
80106335:	e9 e4 f4 ff ff       	jmp    8010581e <alltraps>

8010633a <vector171>:
8010633a:	6a 00                	push   $0x0
8010633c:	68 ab 00 00 00       	push   $0xab
80106341:	e9 d8 f4 ff ff       	jmp    8010581e <alltraps>

80106346 <vector172>:
80106346:	6a 00                	push   $0x0
80106348:	68 ac 00 00 00       	push   $0xac
8010634d:	e9 cc f4 ff ff       	jmp    8010581e <alltraps>

80106352 <vector173>:
80106352:	6a 00                	push   $0x0
80106354:	68 ad 00 00 00       	push   $0xad
80106359:	e9 c0 f4 ff ff       	jmp    8010581e <alltraps>

8010635e <vector174>:
8010635e:	6a 00                	push   $0x0
80106360:	68 ae 00 00 00       	push   $0xae
80106365:	e9 b4 f4 ff ff       	jmp    8010581e <alltraps>

8010636a <vector175>:
8010636a:	6a 00                	push   $0x0
8010636c:	68 af 00 00 00       	push   $0xaf
80106371:	e9 a8 f4 ff ff       	jmp    8010581e <alltraps>

80106376 <vector176>:
80106376:	6a 00                	push   $0x0
80106378:	68 b0 00 00 00       	push   $0xb0
8010637d:	e9 9c f4 ff ff       	jmp    8010581e <alltraps>

80106382 <vector177>:
80106382:	6a 00                	push   $0x0
80106384:	68 b1 00 00 00       	push   $0xb1
80106389:	e9 90 f4 ff ff       	jmp    8010581e <alltraps>

8010638e <vector178>:
8010638e:	6a 00                	push   $0x0
80106390:	68 b2 00 00 00       	push   $0xb2
80106395:	e9 84 f4 ff ff       	jmp    8010581e <alltraps>

8010639a <vector179>:
8010639a:	6a 00                	push   $0x0
8010639c:	68 b3 00 00 00       	push   $0xb3
801063a1:	e9 78 f4 ff ff       	jmp    8010581e <alltraps>

801063a6 <vector180>:
801063a6:	6a 00                	push   $0x0
801063a8:	68 b4 00 00 00       	push   $0xb4
801063ad:	e9 6c f4 ff ff       	jmp    8010581e <alltraps>

801063b2 <vector181>:
801063b2:	6a 00                	push   $0x0
801063b4:	68 b5 00 00 00       	push   $0xb5
801063b9:	e9 60 f4 ff ff       	jmp    8010581e <alltraps>

801063be <vector182>:
801063be:	6a 00                	push   $0x0
801063c0:	68 b6 00 00 00       	push   $0xb6
801063c5:	e9 54 f4 ff ff       	jmp    8010581e <alltraps>

801063ca <vector183>:
801063ca:	6a 00                	push   $0x0
801063cc:	68 b7 00 00 00       	push   $0xb7
801063d1:	e9 48 f4 ff ff       	jmp    8010581e <alltraps>

801063d6 <vector184>:
801063d6:	6a 00                	push   $0x0
801063d8:	68 b8 00 00 00       	push   $0xb8
801063dd:	e9 3c f4 ff ff       	jmp    8010581e <alltraps>

801063e2 <vector185>:
801063e2:	6a 00                	push   $0x0
801063e4:	68 b9 00 00 00       	push   $0xb9
801063e9:	e9 30 f4 ff ff       	jmp    8010581e <alltraps>

801063ee <vector186>:
801063ee:	6a 00                	push   $0x0
801063f0:	68 ba 00 00 00       	push   $0xba
801063f5:	e9 24 f4 ff ff       	jmp    8010581e <alltraps>

801063fa <vector187>:
801063fa:	6a 00                	push   $0x0
801063fc:	68 bb 00 00 00       	push   $0xbb
80106401:	e9 18 f4 ff ff       	jmp    8010581e <alltraps>

80106406 <vector188>:
80106406:	6a 00                	push   $0x0
80106408:	68 bc 00 00 00       	push   $0xbc
8010640d:	e9 0c f4 ff ff       	jmp    8010581e <alltraps>

80106412 <vector189>:
80106412:	6a 00                	push   $0x0
80106414:	68 bd 00 00 00       	push   $0xbd
80106419:	e9 00 f4 ff ff       	jmp    8010581e <alltraps>

8010641e <vector190>:
8010641e:	6a 00                	push   $0x0
80106420:	68 be 00 00 00       	push   $0xbe
80106425:	e9 f4 f3 ff ff       	jmp    8010581e <alltraps>

8010642a <vector191>:
8010642a:	6a 00                	push   $0x0
8010642c:	68 bf 00 00 00       	push   $0xbf
80106431:	e9 e8 f3 ff ff       	jmp    8010581e <alltraps>

80106436 <vector192>:
80106436:	6a 00                	push   $0x0
80106438:	68 c0 00 00 00       	push   $0xc0
8010643d:	e9 dc f3 ff ff       	jmp    8010581e <alltraps>

80106442 <vector193>:
80106442:	6a 00                	push   $0x0
80106444:	68 c1 00 00 00       	push   $0xc1
80106449:	e9 d0 f3 ff ff       	jmp    8010581e <alltraps>

8010644e <vector194>:
8010644e:	6a 00                	push   $0x0
80106450:	68 c2 00 00 00       	push   $0xc2
80106455:	e9 c4 f3 ff ff       	jmp    8010581e <alltraps>

8010645a <vector195>:
8010645a:	6a 00                	push   $0x0
8010645c:	68 c3 00 00 00       	push   $0xc3
80106461:	e9 b8 f3 ff ff       	jmp    8010581e <alltraps>

80106466 <vector196>:
80106466:	6a 00                	push   $0x0
80106468:	68 c4 00 00 00       	push   $0xc4
8010646d:	e9 ac f3 ff ff       	jmp    8010581e <alltraps>

80106472 <vector197>:
80106472:	6a 00                	push   $0x0
80106474:	68 c5 00 00 00       	push   $0xc5
80106479:	e9 a0 f3 ff ff       	jmp    8010581e <alltraps>

8010647e <vector198>:
8010647e:	6a 00                	push   $0x0
80106480:	68 c6 00 00 00       	push   $0xc6
80106485:	e9 94 f3 ff ff       	jmp    8010581e <alltraps>

8010648a <vector199>:
8010648a:	6a 00                	push   $0x0
8010648c:	68 c7 00 00 00       	push   $0xc7
80106491:	e9 88 f3 ff ff       	jmp    8010581e <alltraps>

80106496 <vector200>:
80106496:	6a 00                	push   $0x0
80106498:	68 c8 00 00 00       	push   $0xc8
8010649d:	e9 7c f3 ff ff       	jmp    8010581e <alltraps>

801064a2 <vector201>:
801064a2:	6a 00                	push   $0x0
801064a4:	68 c9 00 00 00       	push   $0xc9
801064a9:	e9 70 f3 ff ff       	jmp    8010581e <alltraps>

801064ae <vector202>:
801064ae:	6a 00                	push   $0x0
801064b0:	68 ca 00 00 00       	push   $0xca
801064b5:	e9 64 f3 ff ff       	jmp    8010581e <alltraps>

801064ba <vector203>:
801064ba:	6a 00                	push   $0x0
801064bc:	68 cb 00 00 00       	push   $0xcb
801064c1:	e9 58 f3 ff ff       	jmp    8010581e <alltraps>

801064c6 <vector204>:
801064c6:	6a 00                	push   $0x0
801064c8:	68 cc 00 00 00       	push   $0xcc
801064cd:	e9 4c f3 ff ff       	jmp    8010581e <alltraps>

801064d2 <vector205>:
801064d2:	6a 00                	push   $0x0
801064d4:	68 cd 00 00 00       	push   $0xcd
801064d9:	e9 40 f3 ff ff       	jmp    8010581e <alltraps>

801064de <vector206>:
801064de:	6a 00                	push   $0x0
801064e0:	68 ce 00 00 00       	push   $0xce
801064e5:	e9 34 f3 ff ff       	jmp    8010581e <alltraps>

801064ea <vector207>:
801064ea:	6a 00                	push   $0x0
801064ec:	68 cf 00 00 00       	push   $0xcf
801064f1:	e9 28 f3 ff ff       	jmp    8010581e <alltraps>

801064f6 <vector208>:
801064f6:	6a 00                	push   $0x0
801064f8:	68 d0 00 00 00       	push   $0xd0
801064fd:	e9 1c f3 ff ff       	jmp    8010581e <alltraps>

80106502 <vector209>:
80106502:	6a 00                	push   $0x0
80106504:	68 d1 00 00 00       	push   $0xd1
80106509:	e9 10 f3 ff ff       	jmp    8010581e <alltraps>

8010650e <vector210>:
8010650e:	6a 00                	push   $0x0
80106510:	68 d2 00 00 00       	push   $0xd2
80106515:	e9 04 f3 ff ff       	jmp    8010581e <alltraps>

8010651a <vector211>:
8010651a:	6a 00                	push   $0x0
8010651c:	68 d3 00 00 00       	push   $0xd3
80106521:	e9 f8 f2 ff ff       	jmp    8010581e <alltraps>

80106526 <vector212>:
80106526:	6a 00                	push   $0x0
80106528:	68 d4 00 00 00       	push   $0xd4
8010652d:	e9 ec f2 ff ff       	jmp    8010581e <alltraps>

80106532 <vector213>:
80106532:	6a 00                	push   $0x0
80106534:	68 d5 00 00 00       	push   $0xd5
80106539:	e9 e0 f2 ff ff       	jmp    8010581e <alltraps>

8010653e <vector214>:
8010653e:	6a 00                	push   $0x0
80106540:	68 d6 00 00 00       	push   $0xd6
80106545:	e9 d4 f2 ff ff       	jmp    8010581e <alltraps>

8010654a <vector215>:
8010654a:	6a 00                	push   $0x0
8010654c:	68 d7 00 00 00       	push   $0xd7
80106551:	e9 c8 f2 ff ff       	jmp    8010581e <alltraps>

80106556 <vector216>:
80106556:	6a 00                	push   $0x0
80106558:	68 d8 00 00 00       	push   $0xd8
8010655d:	e9 bc f2 ff ff       	jmp    8010581e <alltraps>

80106562 <vector217>:
80106562:	6a 00                	push   $0x0
80106564:	68 d9 00 00 00       	push   $0xd9
80106569:	e9 b0 f2 ff ff       	jmp    8010581e <alltraps>

8010656e <vector218>:
8010656e:	6a 00                	push   $0x0
80106570:	68 da 00 00 00       	push   $0xda
80106575:	e9 a4 f2 ff ff       	jmp    8010581e <alltraps>

8010657a <vector219>:
8010657a:	6a 00                	push   $0x0
8010657c:	68 db 00 00 00       	push   $0xdb
80106581:	e9 98 f2 ff ff       	jmp    8010581e <alltraps>

80106586 <vector220>:
80106586:	6a 00                	push   $0x0
80106588:	68 dc 00 00 00       	push   $0xdc
8010658d:	e9 8c f2 ff ff       	jmp    8010581e <alltraps>

80106592 <vector221>:
80106592:	6a 00                	push   $0x0
80106594:	68 dd 00 00 00       	push   $0xdd
80106599:	e9 80 f2 ff ff       	jmp    8010581e <alltraps>

8010659e <vector222>:
8010659e:	6a 00                	push   $0x0
801065a0:	68 de 00 00 00       	push   $0xde
801065a5:	e9 74 f2 ff ff       	jmp    8010581e <alltraps>

801065aa <vector223>:
801065aa:	6a 00                	push   $0x0
801065ac:	68 df 00 00 00       	push   $0xdf
801065b1:	e9 68 f2 ff ff       	jmp    8010581e <alltraps>

801065b6 <vector224>:
801065b6:	6a 00                	push   $0x0
801065b8:	68 e0 00 00 00       	push   $0xe0
801065bd:	e9 5c f2 ff ff       	jmp    8010581e <alltraps>

801065c2 <vector225>:
801065c2:	6a 00                	push   $0x0
801065c4:	68 e1 00 00 00       	push   $0xe1
801065c9:	e9 50 f2 ff ff       	jmp    8010581e <alltraps>

801065ce <vector226>:
801065ce:	6a 00                	push   $0x0
801065d0:	68 e2 00 00 00       	push   $0xe2
801065d5:	e9 44 f2 ff ff       	jmp    8010581e <alltraps>

801065da <vector227>:
801065da:	6a 00                	push   $0x0
801065dc:	68 e3 00 00 00       	push   $0xe3
801065e1:	e9 38 f2 ff ff       	jmp    8010581e <alltraps>

801065e6 <vector228>:
801065e6:	6a 00                	push   $0x0
801065e8:	68 e4 00 00 00       	push   $0xe4
801065ed:	e9 2c f2 ff ff       	jmp    8010581e <alltraps>

801065f2 <vector229>:
801065f2:	6a 00                	push   $0x0
801065f4:	68 e5 00 00 00       	push   $0xe5
801065f9:	e9 20 f2 ff ff       	jmp    8010581e <alltraps>

801065fe <vector230>:
801065fe:	6a 00                	push   $0x0
80106600:	68 e6 00 00 00       	push   $0xe6
80106605:	e9 14 f2 ff ff       	jmp    8010581e <alltraps>

8010660a <vector231>:
8010660a:	6a 00                	push   $0x0
8010660c:	68 e7 00 00 00       	push   $0xe7
80106611:	e9 08 f2 ff ff       	jmp    8010581e <alltraps>

80106616 <vector232>:
80106616:	6a 00                	push   $0x0
80106618:	68 e8 00 00 00       	push   $0xe8
8010661d:	e9 fc f1 ff ff       	jmp    8010581e <alltraps>

80106622 <vector233>:
80106622:	6a 00                	push   $0x0
80106624:	68 e9 00 00 00       	push   $0xe9
80106629:	e9 f0 f1 ff ff       	jmp    8010581e <alltraps>

8010662e <vector234>:
8010662e:	6a 00                	push   $0x0
80106630:	68 ea 00 00 00       	push   $0xea
80106635:	e9 e4 f1 ff ff       	jmp    8010581e <alltraps>

8010663a <vector235>:
8010663a:	6a 00                	push   $0x0
8010663c:	68 eb 00 00 00       	push   $0xeb
80106641:	e9 d8 f1 ff ff       	jmp    8010581e <alltraps>

80106646 <vector236>:
80106646:	6a 00                	push   $0x0
80106648:	68 ec 00 00 00       	push   $0xec
8010664d:	e9 cc f1 ff ff       	jmp    8010581e <alltraps>

80106652 <vector237>:
80106652:	6a 00                	push   $0x0
80106654:	68 ed 00 00 00       	push   $0xed
80106659:	e9 c0 f1 ff ff       	jmp    8010581e <alltraps>

8010665e <vector238>:
8010665e:	6a 00                	push   $0x0
80106660:	68 ee 00 00 00       	push   $0xee
80106665:	e9 b4 f1 ff ff       	jmp    8010581e <alltraps>

8010666a <vector239>:
8010666a:	6a 00                	push   $0x0
8010666c:	68 ef 00 00 00       	push   $0xef
80106671:	e9 a8 f1 ff ff       	jmp    8010581e <alltraps>

80106676 <vector240>:
80106676:	6a 00                	push   $0x0
80106678:	68 f0 00 00 00       	push   $0xf0
8010667d:	e9 9c f1 ff ff       	jmp    8010581e <alltraps>

80106682 <vector241>:
80106682:	6a 00                	push   $0x0
80106684:	68 f1 00 00 00       	push   $0xf1
80106689:	e9 90 f1 ff ff       	jmp    8010581e <alltraps>

8010668e <vector242>:
8010668e:	6a 00                	push   $0x0
80106690:	68 f2 00 00 00       	push   $0xf2
80106695:	e9 84 f1 ff ff       	jmp    8010581e <alltraps>

8010669a <vector243>:
8010669a:	6a 00                	push   $0x0
8010669c:	68 f3 00 00 00       	push   $0xf3
801066a1:	e9 78 f1 ff ff       	jmp    8010581e <alltraps>

801066a6 <vector244>:
801066a6:	6a 00                	push   $0x0
801066a8:	68 f4 00 00 00       	push   $0xf4
801066ad:	e9 6c f1 ff ff       	jmp    8010581e <alltraps>

801066b2 <vector245>:
801066b2:	6a 00                	push   $0x0
801066b4:	68 f5 00 00 00       	push   $0xf5
801066b9:	e9 60 f1 ff ff       	jmp    8010581e <alltraps>

801066be <vector246>:
801066be:	6a 00                	push   $0x0
801066c0:	68 f6 00 00 00       	push   $0xf6
801066c5:	e9 54 f1 ff ff       	jmp    8010581e <alltraps>

801066ca <vector247>:
801066ca:	6a 00                	push   $0x0
801066cc:	68 f7 00 00 00       	push   $0xf7
801066d1:	e9 48 f1 ff ff       	jmp    8010581e <alltraps>

801066d6 <vector248>:
801066d6:	6a 00                	push   $0x0
801066d8:	68 f8 00 00 00       	push   $0xf8
801066dd:	e9 3c f1 ff ff       	jmp    8010581e <alltraps>

801066e2 <vector249>:
801066e2:	6a 00                	push   $0x0
801066e4:	68 f9 00 00 00       	push   $0xf9
801066e9:	e9 30 f1 ff ff       	jmp    8010581e <alltraps>

801066ee <vector250>:
801066ee:	6a 00                	push   $0x0
801066f0:	68 fa 00 00 00       	push   $0xfa
801066f5:	e9 24 f1 ff ff       	jmp    8010581e <alltraps>

801066fa <vector251>:
801066fa:	6a 00                	push   $0x0
801066fc:	68 fb 00 00 00       	push   $0xfb
80106701:	e9 18 f1 ff ff       	jmp    8010581e <alltraps>

80106706 <vector252>:
80106706:	6a 00                	push   $0x0
80106708:	68 fc 00 00 00       	push   $0xfc
8010670d:	e9 0c f1 ff ff       	jmp    8010581e <alltraps>

80106712 <vector253>:
80106712:	6a 00                	push   $0x0
80106714:	68 fd 00 00 00       	push   $0xfd
80106719:	e9 00 f1 ff ff       	jmp    8010581e <alltraps>

8010671e <vector254>:
8010671e:	6a 00                	push   $0x0
80106720:	68 fe 00 00 00       	push   $0xfe
80106725:	e9 f4 f0 ff ff       	jmp    8010581e <alltraps>

8010672a <vector255>:
8010672a:	6a 00                	push   $0x0
8010672c:	68 ff 00 00 00       	push   $0xff
80106731:	e9 e8 f0 ff ff       	jmp    8010581e <alltraps>
80106736:	66 90                	xchg   %ax,%ax
80106738:	66 90                	xchg   %ax,%ax
8010673a:	66 90                	xchg   %ax,%ax
8010673c:	66 90                	xchg   %ax,%ax
8010673e:	66 90                	xchg   %ax,%ax

80106740 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106747:	c1 ea 16             	shr    $0x16,%edx
{
8010674a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010674b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010674e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106751:	8b 1f                	mov    (%edi),%ebx
80106753:	f6 c3 01             	test   $0x1,%bl
80106756:	74 28                	je     80106780 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106758:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010675e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106764:	c1 ee 0a             	shr    $0xa,%esi
}
80106767:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010676a:	89 f2                	mov    %esi,%edx
8010676c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106772:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106775:	5b                   	pop    %ebx
80106776:	5e                   	pop    %esi
80106777:	5f                   	pop    %edi
80106778:	5d                   	pop    %ebp
80106779:	c3                   	ret    
8010677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106780:	85 c9                	test   %ecx,%ecx
80106782:	74 34                	je     801067b8 <walkpgdir+0x78>
80106784:	e8 17 bd ff ff       	call   801024a0 <kalloc>
80106789:	85 c0                	test   %eax,%eax
8010678b:	89 c3                	mov    %eax,%ebx
8010678d:	74 29                	je     801067b8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010678f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106796:	00 
80106797:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010679e:	00 
8010679f:	89 04 24             	mov    %eax,(%esp)
801067a2:	e8 79 de ff ff       	call   80104620 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067a7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067ad:	83 c8 07             	or     $0x7,%eax
801067b0:	89 07                	mov    %eax,(%edi)
801067b2:	eb b0                	jmp    80106764 <walkpgdir+0x24>
801067b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801067b8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801067bb:	31 c0                	xor    %eax,%eax
}
801067bd:	5b                   	pop    %ebx
801067be:	5e                   	pop    %esi
801067bf:	5f                   	pop    %edi
801067c0:	5d                   	pop    %ebp
801067c1:	c3                   	ret    
801067c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067d6:	89 d3                	mov    %edx,%ebx
{
801067d8:	83 ec 1c             	sub    $0x1c,%esp
801067db:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
801067de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801067e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067e7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067ee:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067f2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801067f9:	29 df                	sub    %ebx,%edi
801067fb:	eb 18                	jmp    80106815 <mappages+0x45>
801067fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106800:	f6 00 01             	testb  $0x1,(%eax)
80106803:	75 3d                	jne    80106842 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106805:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106808:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010680b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010680d:	74 29                	je     80106838 <mappages+0x68>
      break;
    a += PGSIZE;
8010680f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106815:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106818:	b9 01 00 00 00       	mov    $0x1,%ecx
8010681d:	89 da                	mov    %ebx,%edx
8010681f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106822:	e8 19 ff ff ff       	call   80106740 <walkpgdir>
80106827:	85 c0                	test   %eax,%eax
80106829:	75 d5                	jne    80106800 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010682b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010682e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106833:	5b                   	pop    %ebx
80106834:	5e                   	pop    %esi
80106835:	5f                   	pop    %edi
80106836:	5d                   	pop    %ebp
80106837:	c3                   	ret    
80106838:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010683b:	31 c0                	xor    %eax,%eax
}
8010683d:	5b                   	pop    %ebx
8010683e:	5e                   	pop    %esi
8010683f:	5f                   	pop    %edi
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    
      panic("remap");
80106842:	c7 04 24 34 7c 10 80 	movl   $0x80107c34,(%esp)
80106849:	e8 12 9b ff ff       	call   80100360 <panic>
8010684e:	66 90                	xchg   %ax,%ax

80106850 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	89 c7                	mov    %eax,%edi
80106856:	56                   	push   %esi
80106857:	89 d6                	mov    %edx,%esi
80106859:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010685a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106860:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106863:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106869:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010686b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010686e:	72 3b                	jb     801068ab <deallocuvm.part.0+0x5b>
80106870:	eb 5e                	jmp    801068d0 <deallocuvm.part.0+0x80>
80106872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106878:	8b 10                	mov    (%eax),%edx
8010687a:	f6 c2 01             	test   $0x1,%dl
8010687d:	74 22                	je     801068a1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010687f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106885:	74 54                	je     801068db <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106887:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010688d:	89 14 24             	mov    %edx,(%esp)
80106890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106893:	e8 58 ba ff ff       	call   801022f0 <kfree>
      *pte = 0;
80106898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010689b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801068a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068a7:	39 f3                	cmp    %esi,%ebx
801068a9:	73 25                	jae    801068d0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068ab:	31 c9                	xor    %ecx,%ecx
801068ad:	89 da                	mov    %ebx,%edx
801068af:	89 f8                	mov    %edi,%eax
801068b1:	e8 8a fe ff ff       	call   80106740 <walkpgdir>
    if(!pte)
801068b6:	85 c0                	test   %eax,%eax
801068b8:	75 be                	jne    80106878 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068ba:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068c0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068cc:	39 f3                	cmp    %esi,%ebx
801068ce:	72 db                	jb     801068ab <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
801068d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068d3:	83 c4 1c             	add    $0x1c,%esp
801068d6:	5b                   	pop    %ebx
801068d7:	5e                   	pop    %esi
801068d8:	5f                   	pop    %edi
801068d9:	5d                   	pop    %ebp
801068da:	c3                   	ret    
        panic("kfree");
801068db:	c7 04 24 86 74 10 80 	movl   $0x80107486,(%esp)
801068e2:	e8 79 9a ff ff       	call   80100360 <panic>
801068e7:	89 f6                	mov    %esi,%esi
801068e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068f0 <seginit>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801068f6:	e8 b5 cd ff ff       	call   801036b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068fb:	31 c9                	xor    %ecx,%ecx
801068fd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106902:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106908:	05 40 31 11 80       	add    $0x80113140,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010690d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106911:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106916:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106919:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010691d:	31 c9                	xor    %ecx,%ecx
8010691f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106923:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106928:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010692c:	31 c9                	xor    %ecx,%ecx
8010692e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106932:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106937:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010693b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010693d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106941:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106945:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106949:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010694d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106951:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106955:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106959:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010695d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106961:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106966:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010696a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010696e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106972:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106976:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010697a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010697e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106982:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106986:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010698a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010698e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106992:	c1 e8 10             	shr    $0x10,%eax
80106995:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106999:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010699c:	0f 01 10             	lgdtl  (%eax)
}
8010699f:	c9                   	leave  
801069a0:	c3                   	ret    
801069a1:	eb 0d                	jmp    801069b0 <switchkvm>
801069a3:	90                   	nop
801069a4:	90                   	nop
801069a5:	90                   	nop
801069a6:	90                   	nop
801069a7:	90                   	nop
801069a8:	90                   	nop
801069a9:	90                   	nop
801069aa:	90                   	nop
801069ab:	90                   	nop
801069ac:	90                   	nop
801069ad:	90                   	nop
801069ae:	90                   	nop
801069af:	90                   	nop

801069b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069b0:	a1 64 63 11 80       	mov    0x80116364,%eax
{
801069b5:	55                   	push   %ebp
801069b6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069b8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069bd:	0f 22 d8             	mov    %eax,%cr3
}
801069c0:	5d                   	pop    %ebp
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <switchuvm>:
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 1c             	sub    $0x1c,%esp
801069d9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069dc:	85 f6                	test   %esi,%esi
801069de:	0f 84 cd 00 00 00    	je     80106ab1 <switchuvm+0xe1>
  if(p->kstack == 0)
801069e4:	8b 46 08             	mov    0x8(%esi),%eax
801069e7:	85 c0                	test   %eax,%eax
801069e9:	0f 84 da 00 00 00    	je     80106ac9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801069ef:	8b 7e 04             	mov    0x4(%esi),%edi
801069f2:	85 ff                	test   %edi,%edi
801069f4:	0f 84 c3 00 00 00    	je     80106abd <switchuvm+0xed>
  pushcli();
801069fa:	e8 71 da ff ff       	call   80104470 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069ff:	e8 2c cc ff ff       	call   80103630 <mycpu>
80106a04:	89 c3                	mov    %eax,%ebx
80106a06:	e8 25 cc ff ff       	call   80103630 <mycpu>
80106a0b:	89 c7                	mov    %eax,%edi
80106a0d:	e8 1e cc ff ff       	call   80103630 <mycpu>
80106a12:	83 c7 08             	add    $0x8,%edi
80106a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a18:	e8 13 cc ff ff       	call   80103630 <mycpu>
80106a1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a20:	ba 67 00 00 00       	mov    $0x67,%edx
80106a25:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a2c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a33:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a3a:	83 c1 08             	add    $0x8,%ecx
80106a3d:	c1 e9 10             	shr    $0x10,%ecx
80106a40:	83 c0 08             	add    $0x8,%eax
80106a43:	c1 e8 18             	shr    $0x18,%eax
80106a46:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106a4c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a53:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a59:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106a5e:	e8 cd cb ff ff       	call   80103630 <mycpu>
80106a63:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a6a:	e8 c1 cb ff ff       	call   80103630 <mycpu>
80106a6f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106a74:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a78:	e8 b3 cb ff ff       	call   80103630 <mycpu>
80106a7d:	8b 56 08             	mov    0x8(%esi),%edx
80106a80:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106a86:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a89:	e8 a2 cb ff ff       	call   80103630 <mycpu>
80106a8e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a92:	b8 28 00 00 00       	mov    $0x28,%eax
80106a97:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a9a:	8b 46 04             	mov    0x4(%esi),%eax
80106a9d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aa2:	0f 22 d8             	mov    %eax,%cr3
}
80106aa5:	83 c4 1c             	add    $0x1c,%esp
80106aa8:	5b                   	pop    %ebx
80106aa9:	5e                   	pop    %esi
80106aaa:	5f                   	pop    %edi
80106aab:	5d                   	pop    %ebp
  popcli();
80106aac:	e9 ff d9 ff ff       	jmp    801044b0 <popcli>
    panic("switchuvm: no process");
80106ab1:	c7 04 24 3a 7c 10 80 	movl   $0x80107c3a,(%esp)
80106ab8:	e8 a3 98 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106abd:	c7 04 24 65 7c 10 80 	movl   $0x80107c65,(%esp)
80106ac4:	e8 97 98 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106ac9:	c7 04 24 50 7c 10 80 	movl   $0x80107c50,(%esp)
80106ad0:	e8 8b 98 ff ff       	call   80100360 <panic>
80106ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ae0 <inituvm>:
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
80106ae6:	83 ec 1c             	sub    $0x1c,%esp
80106ae9:	8b 75 10             	mov    0x10(%ebp),%esi
80106aec:	8b 45 08             	mov    0x8(%ebp),%eax
80106aef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106af2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106afb:	77 54                	ja     80106b51 <inituvm+0x71>
  mem = kalloc();
80106afd:	e8 9e b9 ff ff       	call   801024a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b02:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b09:	00 
80106b0a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b11:	00 
  mem = kalloc();
80106b12:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b14:	89 04 24             	mov    %eax,(%esp)
80106b17:	e8 04 db ff ff       	call   80104620 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b1c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b22:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b27:	89 04 24             	mov    %eax,(%esp)
80106b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b2d:	31 d2                	xor    %edx,%edx
80106b2f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106b36:	00 
80106b37:	e8 94 fc ff ff       	call   801067d0 <mappages>
  memmove(mem, init, sz);
80106b3c:	89 75 10             	mov    %esi,0x10(%ebp)
80106b3f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b45:	83 c4 1c             	add    $0x1c,%esp
80106b48:	5b                   	pop    %ebx
80106b49:	5e                   	pop    %esi
80106b4a:	5f                   	pop    %edi
80106b4b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b4c:	e9 6f db ff ff       	jmp    801046c0 <memmove>
    panic("inituvm: more than a page");
80106b51:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80106b58:	e8 03 98 ff ff       	call   80100360 <panic>
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi

80106b60 <loaduvm>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106b69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b70:	0f 85 98 00 00 00    	jne    80106c0e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106b76:	8b 75 18             	mov    0x18(%ebp),%esi
80106b79:	31 db                	xor    %ebx,%ebx
80106b7b:	85 f6                	test   %esi,%esi
80106b7d:	75 1a                	jne    80106b99 <loaduvm+0x39>
80106b7f:	eb 77                	jmp    80106bf8 <loaduvm+0x98>
80106b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b97:	76 5f                	jbe    80106bf8 <loaduvm+0x98>
80106b99:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b9c:	31 c9                	xor    %ecx,%ecx
80106b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba1:	01 da                	add    %ebx,%edx
80106ba3:	e8 98 fb ff ff       	call   80106740 <walkpgdir>
80106ba8:	85 c0                	test   %eax,%eax
80106baa:	74 56                	je     80106c02 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80106bac:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
80106bae:	bf 00 10 00 00       	mov    $0x1000,%edi
80106bb3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106bb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
80106bbb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106bc1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bcd:	8b 45 10             	mov    0x10(%ebp),%eax
80106bd0:	01 d9                	add    %ebx,%ecx
80106bd2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106bd6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106bda:	89 04 24             	mov    %eax,(%esp)
80106bdd:	e8 7e ad ff ff       	call   80101960 <readi>
80106be2:	39 f8                	cmp    %edi,%eax
80106be4:	74 a2                	je     80106b88 <loaduvm+0x28>
}
80106be6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bee:	5b                   	pop    %ebx
80106bef:	5e                   	pop    %esi
80106bf0:	5f                   	pop    %edi
80106bf1:	5d                   	pop    %ebp
80106bf2:	c3                   	ret    
80106bf3:	90                   	nop
80106bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bf8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106bfb:	31 c0                	xor    %eax,%eax
}
80106bfd:	5b                   	pop    %ebx
80106bfe:	5e                   	pop    %esi
80106bff:	5f                   	pop    %edi
80106c00:	5d                   	pop    %ebp
80106c01:	c3                   	ret    
      panic("loaduvm: address should exist");
80106c02:	c7 04 24 93 7c 10 80 	movl   $0x80107c93,(%esp)
80106c09:	e8 52 97 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106c0e:	c7 04 24 34 7d 10 80 	movl   $0x80107d34,(%esp)
80106c15:	e8 46 97 ff ff       	call   80100360 <panic>
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <allocuvm>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 1c             	sub    $0x1c,%esp
80106c29:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106c2c:	85 ff                	test   %edi,%edi
80106c2e:	0f 88 7e 00 00 00    	js     80106cb2 <allocuvm+0x92>
  if(newsz < oldsz)
80106c34:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106c3a:	72 78                	jb     80106cb4 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
80106c3c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c42:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c48:	39 df                	cmp    %ebx,%edi
80106c4a:	77 4a                	ja     80106c96 <allocuvm+0x76>
80106c4c:	eb 72                	jmp    80106cc0 <allocuvm+0xa0>
80106c4e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106c50:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c57:	00 
80106c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c5f:	00 
80106c60:	89 04 24             	mov    %eax,(%esp)
80106c63:	e8 b8 d9 ff ff       	call   80104620 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c68:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c73:	89 04 24             	mov    %eax,(%esp)
80106c76:	8b 45 08             	mov    0x8(%ebp),%eax
80106c79:	89 da                	mov    %ebx,%edx
80106c7b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106c82:	00 
80106c83:	e8 48 fb ff ff       	call   801067d0 <mappages>
80106c88:	85 c0                	test   %eax,%eax
80106c8a:	78 44                	js     80106cd0 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106c8c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c92:	39 df                	cmp    %ebx,%edi
80106c94:	76 2a                	jbe    80106cc0 <allocuvm+0xa0>
    mem = kalloc();
80106c96:	e8 05 b8 ff ff       	call   801024a0 <kalloc>
    if(mem == 0){
80106c9b:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106c9d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c9f:	75 af                	jne    80106c50 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ca1:	c7 04 24 b1 7c 10 80 	movl   $0x80107cb1,(%esp)
80106ca8:	e8 a3 99 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106cad:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cb0:	77 48                	ja     80106cfa <allocuvm+0xda>
      return 0;
80106cb2:	31 c0                	xor    %eax,%eax
}
80106cb4:	83 c4 1c             	add    $0x1c,%esp
80106cb7:	5b                   	pop    %ebx
80106cb8:	5e                   	pop    %esi
80106cb9:	5f                   	pop    %edi
80106cba:	5d                   	pop    %ebp
80106cbb:	c3                   	ret    
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	83 c4 1c             	add    $0x1c,%esp
80106cc3:	89 f8                	mov    %edi,%eax
80106cc5:	5b                   	pop    %ebx
80106cc6:	5e                   	pop    %esi
80106cc7:	5f                   	pop    %edi
80106cc8:	5d                   	pop    %ebp
80106cc9:	c3                   	ret    
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106cd0:	c7 04 24 c9 7c 10 80 	movl   $0x80107cc9,(%esp)
80106cd7:	e8 74 99 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106cdc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cdf:	76 0d                	jbe    80106cee <allocuvm+0xce>
80106ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ce4:	89 fa                	mov    %edi,%edx
80106ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce9:	e8 62 fb ff ff       	call   80106850 <deallocuvm.part.0>
      kfree(mem);
80106cee:	89 34 24             	mov    %esi,(%esp)
80106cf1:	e8 fa b5 ff ff       	call   801022f0 <kfree>
      return 0;
80106cf6:	31 c0                	xor    %eax,%eax
80106cf8:	eb ba                	jmp    80106cb4 <allocuvm+0x94>
80106cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cfd:	89 fa                	mov    %edi,%edx
80106cff:	8b 45 08             	mov    0x8(%ebp),%eax
80106d02:	e8 49 fb ff ff       	call   80106850 <deallocuvm.part.0>
      return 0;
80106d07:	31 c0                	xor    %eax,%eax
80106d09:	eb a9                	jmp    80106cb4 <allocuvm+0x94>
80106d0b:	90                   	nop
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d10 <deallocuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 08                	jae    80106d28 <deallocuvm+0x18>
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 2a fb ff ff       	jmp    80106850 <deallocuvm.part.0>
80106d26:	66 90                	xchg   %ax,%ax
80106d28:	89 d0                	mov    %edx,%eax
80106d2a:	5d                   	pop    %ebp
80106d2b:	c3                   	ret    
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	56                   	push   %esi
80106d34:	53                   	push   %ebx
80106d35:	83 ec 10             	sub    $0x10,%esp
80106d38:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d3b:	85 f6                	test   %esi,%esi
80106d3d:	74 59                	je     80106d98 <freevm+0x68>
80106d3f:	31 c9                	xor    %ecx,%ecx
80106d41:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d46:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d48:	31 db                	xor    %ebx,%ebx
80106d4a:	e8 01 fb ff ff       	call   80106850 <deallocuvm.part.0>
80106d4f:	eb 12                	jmp    80106d63 <freevm+0x33>
80106d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d58:	83 c3 01             	add    $0x1,%ebx
80106d5b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106d61:	74 27                	je     80106d8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d63:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106d66:	f6 c2 01             	test   $0x1,%dl
80106d69:	74 ed                	je     80106d58 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d6b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106d71:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d74:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106d7a:	89 14 24             	mov    %edx,(%esp)
80106d7d:	e8 6e b5 ff ff       	call   801022f0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106d82:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106d88:	75 d9                	jne    80106d63 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106d8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d8d:	83 c4 10             	add    $0x10,%esp
80106d90:	5b                   	pop    %ebx
80106d91:	5e                   	pop    %esi
80106d92:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d93:	e9 58 b5 ff ff       	jmp    801022f0 <kfree>
    panic("freevm: no pgdir");
80106d98:	c7 04 24 e5 7c 10 80 	movl   $0x80107ce5,(%esp)
80106d9f:	e8 bc 95 ff ff       	call   80100360 <panic>
80106da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106db0 <setupkvm>:
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	56                   	push   %esi
80106db4:	53                   	push   %ebx
80106db5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106db8:	e8 e3 b6 ff ff       	call   801024a0 <kalloc>
80106dbd:	85 c0                	test   %eax,%eax
80106dbf:	89 c6                	mov    %eax,%esi
80106dc1:	74 6d                	je     80106e30 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106dc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106dca:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dcb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106dd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106dd7:	00 
80106dd8:	89 04 24             	mov    %eax,(%esp)
80106ddb:	e8 40 d8 ff ff       	call   80104620 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106de0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106de3:	8b 43 04             	mov    0x4(%ebx),%eax
80106de6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106de9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ded:	8b 13                	mov    (%ebx),%edx
80106def:	89 04 24             	mov    %eax,(%esp)
80106df2:	29 c1                	sub    %eax,%ecx
80106df4:	89 f0                	mov    %esi,%eax
80106df6:	e8 d5 f9 ff ff       	call   801067d0 <mappages>
80106dfb:	85 c0                	test   %eax,%eax
80106dfd:	78 19                	js     80106e18 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dff:	83 c3 10             	add    $0x10,%ebx
80106e02:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e08:	72 d6                	jb     80106de0 <setupkvm+0x30>
80106e0a:	89 f0                	mov    %esi,%eax
}
80106e0c:	83 c4 10             	add    $0x10,%esp
80106e0f:	5b                   	pop    %ebx
80106e10:	5e                   	pop    %esi
80106e11:	5d                   	pop    %ebp
80106e12:	c3                   	ret    
80106e13:	90                   	nop
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106e18:	89 34 24             	mov    %esi,(%esp)
80106e1b:	e8 10 ff ff ff       	call   80106d30 <freevm>
}
80106e20:	83 c4 10             	add    $0x10,%esp
      return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5d                   	pop    %ebp
80106e28:	c3                   	ret    
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106e30:	31 c0                	xor    %eax,%eax
80106e32:	eb d8                	jmp    80106e0c <setupkvm+0x5c>
80106e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e40 <kvmalloc>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e46:	e8 65 ff ff ff       	call   80106db0 <setupkvm>
80106e4b:	a3 64 63 11 80       	mov    %eax,0x80116364
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	05 00 00 00 80       	add    $0x80000000,%eax
80106e55:	0f 22 d8             	mov    %eax,%cr3
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e61:	31 c9                	xor    %ecx,%ecx
{
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6e:	e8 cd f8 ff ff       	call   80106740 <walkpgdir>
  if(pte == 0)
80106e73:	85 c0                	test   %eax,%eax
80106e75:	74 05                	je     80106e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
    panic("clearpteu");
80106e7c:	c7 04 24 f6 7c 10 80 	movl   $0x80107cf6,(%esp)
80106e83:	e8 d8 94 ff ff       	call   80100360 <panic>
80106e88:	90                   	nop
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e99:	e8 12 ff ff ff       	call   80106db0 <setupkvm>
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea3:	0f 84 b9 00 00 00    	je     80106f62 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	85 c0                	test   %eax,%eax
80106eae:	0f 84 94 00 00 00    	je     80106f48 <copyuvm+0xb8>
80106eb4:	31 ff                	xor    %edi,%edi
80106eb6:	eb 48                	jmp    80106f00 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106eb8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106ebe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ec5:	00 
80106ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
80106eca:	89 04 24             	mov    %eax,(%esp)
80106ecd:	e8 ee d7 ff ff       	call   801046c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eda:	89 fa                	mov    %edi,%edx
80106edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ee0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ee6:	89 04 24             	mov    %eax,(%esp)
80106ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106eec:	e8 df f8 ff ff       	call   801067d0 <mappages>
80106ef1:	85 c0                	test   %eax,%eax
80106ef3:	78 63                	js     80106f58 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106ef5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106efb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106efe:	76 48                	jbe    80106f48 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f00:	8b 45 08             	mov    0x8(%ebp),%eax
80106f03:	31 c9                	xor    %ecx,%ecx
80106f05:	89 fa                	mov    %edi,%edx
80106f07:	e8 34 f8 ff ff       	call   80106740 <walkpgdir>
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	74 62                	je     80106f72 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106f10:	8b 00                	mov    (%eax),%eax
80106f12:	a8 01                	test   $0x1,%al
80106f14:	74 50                	je     80106f66 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106f16:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106f18:	25 ff 0f 00 00       	and    $0xfff,%eax
80106f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106f20:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106f26:	e8 75 b5 ff ff       	call   801024a0 <kalloc>
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	89 c3                	mov    %eax,%ebx
80106f2f:	75 87                	jne    80106eb8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f34:	89 04 24             	mov    %eax,(%esp)
80106f37:	e8 f4 fd ff ff       	call   80106d30 <freevm>
  return 0;
80106f3c:	31 c0                	xor    %eax,%eax
}
80106f3e:	83 c4 2c             	add    $0x2c,%esp
80106f41:	5b                   	pop    %ebx
80106f42:	5e                   	pop    %esi
80106f43:	5f                   	pop    %edi
80106f44:	5d                   	pop    %ebp
80106f45:	c3                   	ret    
80106f46:	66 90                	xchg   %ax,%ax
80106f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4b:	83 c4 2c             	add    $0x2c,%esp
80106f4e:	5b                   	pop    %ebx
80106f4f:	5e                   	pop    %esi
80106f50:	5f                   	pop    %edi
80106f51:	5d                   	pop    %ebp
80106f52:	c3                   	ret    
80106f53:	90                   	nop
80106f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106f58:	89 1c 24             	mov    %ebx,(%esp)
80106f5b:	e8 90 b3 ff ff       	call   801022f0 <kfree>
      goto bad;
80106f60:	eb cf                	jmp    80106f31 <copyuvm+0xa1>
    return 0;
80106f62:	31 c0                	xor    %eax,%eax
80106f64:	eb d8                	jmp    80106f3e <copyuvm+0xae>
      panic("copyuvm: page not present");
80106f66:	c7 04 24 1a 7d 10 80 	movl   $0x80107d1a,(%esp)
80106f6d:	e8 ee 93 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106f72:	c7 04 24 00 7d 10 80 	movl   $0x80107d00,(%esp)
80106f79:	e8 e2 93 ff ff       	call   80100360 <panic>
80106f7e:	66 90                	xchg   %ax,%ax

80106f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f81:	31 c9                	xor    %ecx,%ecx
{
80106f83:	89 e5                	mov    %esp,%ebp
80106f85:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8e:	e8 ad f7 ff ff       	call   80106740 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f93:	8b 00                	mov    (%eax),%eax
80106f95:	89 c2                	mov    %eax,%edx
80106f97:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106f9a:	83 fa 05             	cmp    $0x5,%edx
80106f9d:	75 11                	jne    80106fb0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fa4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106fa9:	c9                   	leave  
80106faa:	c3                   	ret    
80106fab:	90                   	nop
80106fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106fb0:	31 c0                	xor    %eax,%eax
}
80106fb2:	c9                   	leave  
80106fb3:	c3                   	ret    
80106fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fd2:	85 db                	test   %ebx,%ebx
80106fd4:	75 3a                	jne    80107010 <copyout+0x50>
80106fd6:	eb 68                	jmp    80107040 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fdb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fdd:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106fe1:	29 ca                	sub    %ecx,%edx
80106fe3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106fe9:	39 da                	cmp    %ebx,%edx
80106feb:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106fee:	29 f1                	sub    %esi,%ecx
80106ff0:	01 c8                	add    %ecx,%eax
80106ff2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106ff6:	89 04 24             	mov    %eax,(%esp)
80106ff9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ffc:	e8 bf d6 ff ff       	call   801046c0 <memmove>
    len -= n;
    buf += n;
80107001:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107004:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
8010700a:	01 d7                	add    %edx,%edi
  while(len > 0){
8010700c:	29 d3                	sub    %edx,%ebx
8010700e:	74 30                	je     80107040 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80107010:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80107013:	89 ce                	mov    %ecx,%esi
80107015:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010701b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
8010701f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107022:	89 04 24             	mov    %eax,(%esp)
80107025:	e8 56 ff ff ff       	call   80106f80 <uva2ka>
    if(pa0 == 0)
8010702a:	85 c0                	test   %eax,%eax
8010702c:	75 aa                	jne    80106fd8 <copyout+0x18>
  }
  return 0;
}
8010702e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80107031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
8010703b:	90                   	nop
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107040:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
8010704a:	66 90                	xchg   %ax,%ax
8010704c:	66 90                	xchg   %ax,%ax
8010704e:	66 90                	xchg   %ax,%ax

80107050 <sgenrand>:
80107050:	55                   	push   %ebp
80107051:	b8 c4 a5 10 80       	mov    $0x8010a5c4,%eax
80107056:	b9 7c af 10 80       	mov    $0x8010af7c,%ecx
8010705b:	89 e5                	mov    %esp,%ebp
8010705d:	8b 55 08             	mov    0x8(%ebp),%edx
80107060:	89 15 c0 a5 10 80    	mov    %edx,0x8010a5c0
80107066:	eb 0b                	jmp    80107073 <sgenrand+0x23>
80107068:	90                   	nop
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107070:	83 c0 04             	add    $0x4,%eax
80107073:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
80107079:	39 c1                	cmp    %eax,%ecx
8010707b:	89 10                	mov    %edx,(%eax)
8010707d:	75 f1                	jne    80107070 <sgenrand+0x20>
8010707f:	c7 05 60 a4 10 80 70 	movl   $0x270,0x8010a460
80107086:	02 00 00 
80107089:	5d                   	pop    %ebp
8010708a:	c3                   	ret    
8010708b:	90                   	nop
8010708c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107090 <genrand>:
80107090:	a1 60 a4 10 80       	mov    0x8010a460,%eax
80107095:	55                   	push   %ebp
80107096:	89 e5                	mov    %esp,%ebp
80107098:	56                   	push   %esi
80107099:	53                   	push   %ebx
8010709a:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010709f:	0f 8e f9 00 00 00    	jle    8010719e <genrand+0x10e>
801070a5:	3d 71 02 00 00       	cmp    $0x271,%eax
801070aa:	0f 84 fa 00 00 00    	je     801071aa <genrand+0x11a>
801070b0:	ba c0 a5 10 80       	mov    $0x8010a5c0,%edx
801070b5:	bb 4c a9 10 80       	mov    $0x8010a94c,%ebx
801070ba:	89 d1                	mov    %edx,%ecx
801070bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070c0:	8b 01                	mov    (%ecx),%eax
801070c2:	8b 71 04             	mov    0x4(%ecx),%esi
801070c5:	83 c1 04             	add    $0x4,%ecx
801070c8:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
801070ce:	25 00 00 00 80       	and    $0x80000000,%eax
801070d3:	09 f0                	or     %esi,%eax
801070d5:	89 c6                	mov    %eax,%esi
801070d7:	83 e0 01             	and    $0x1,%eax
801070da:	d1 ee                	shr    %esi
801070dc:	33 b1 30 06 00 00    	xor    0x630(%ecx),%esi
801070e2:	33 34 85 58 7d 10 80 	xor    -0x7fef82a8(,%eax,4),%esi
801070e9:	89 71 fc             	mov    %esi,-0x4(%ecx)
801070ec:	39 cb                	cmp    %ecx,%ebx
801070ee:	75 d0                	jne    801070c0 <genrand+0x30>
801070f0:	b9 f0 ab 10 80       	mov    $0x8010abf0,%ecx
801070f5:	8d 76 00             	lea    0x0(%esi),%esi
801070f8:	8b 82 8c 03 00 00    	mov    0x38c(%edx),%eax
801070fe:	8b 9a 90 03 00 00    	mov    0x390(%edx),%ebx
80107104:	83 c2 04             	add    $0x4,%edx
80107107:	81 e3 ff ff ff 7f    	and    $0x7fffffff,%ebx
8010710d:	25 00 00 00 80       	and    $0x80000000,%eax
80107112:	09 d8                	or     %ebx,%eax
80107114:	89 c3                	mov    %eax,%ebx
80107116:	83 e0 01             	and    $0x1,%eax
80107119:	d1 eb                	shr    %ebx
8010711b:	33 5a fc             	xor    -0x4(%edx),%ebx
8010711e:	33 1c 85 58 7d 10 80 	xor    -0x7fef82a8(,%eax,4),%ebx
80107125:	89 9a 88 03 00 00    	mov    %ebx,0x388(%edx)
8010712b:	39 d1                	cmp    %edx,%ecx
8010712d:	75 c9                	jne    801070f8 <genrand+0x68>
8010712f:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80107134:	8b 0d 7c af 10 80    	mov    0x8010af7c,%ecx
8010713a:	89 c2                	mov    %eax,%edx
8010713c:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
80107142:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80107148:	09 d1                	or     %edx,%ecx
8010714a:	89 ca                	mov    %ecx,%edx
8010714c:	83 e1 01             	and    $0x1,%ecx
8010714f:	d1 ea                	shr    %edx
80107151:	33 15 f0 ab 10 80    	xor    0x8010abf0,%edx
80107157:	33 14 8d 58 7d 10 80 	xor    -0x7fef82a8(,%ecx,4),%edx
8010715e:	89 15 7c af 10 80    	mov    %edx,0x8010af7c
80107164:	ba 01 00 00 00       	mov    $0x1,%edx
80107169:	89 15 60 a4 10 80    	mov    %edx,0x8010a460
8010716f:	89 c2                	mov    %eax,%edx
80107171:	c1 ea 0b             	shr    $0xb,%edx
80107174:	31 c2                	xor    %eax,%edx
80107176:	89 d0                	mov    %edx,%eax
80107178:	c1 e0 07             	shl    $0x7,%eax
8010717b:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80107180:	31 c2                	xor    %eax,%edx
80107182:	89 d0                	mov    %edx,%eax
80107184:	c1 e0 0f             	shl    $0xf,%eax
80107187:	25 00 00 c6 ef       	and    $0xefc60000,%eax
8010718c:	31 d0                	xor    %edx,%eax
8010718e:	89 c2                	mov    %eax,%edx
80107190:	c1 ea 12             	shr    $0x12,%edx
80107193:	31 d0                	xor    %edx,%eax
80107195:	5b                   	pop    %ebx
80107196:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
8010719b:	5e                   	pop    %esi
8010719c:	5d                   	pop    %ebp
8010719d:	c3                   	ret    
8010719e:	8d 50 01             	lea    0x1(%eax),%edx
801071a1:	8b 04 85 c0 a5 10 80 	mov    -0x7fef5a40(,%eax,4),%eax
801071a8:	eb bf                	jmp    80107169 <genrand+0xd9>
801071aa:	c7 05 c0 a5 10 80 05 	movl   $0x1105,0x8010a5c0
801071b1:	11 00 00 
801071b4:	b8 c4 a5 10 80       	mov    $0x8010a5c4,%eax
801071b9:	b9 7c af 10 80       	mov    $0x8010af7c,%ecx
801071be:	ba 05 11 00 00       	mov    $0x1105,%edx
801071c3:	eb 06                	jmp    801071cb <genrand+0x13b>
801071c5:	8d 76 00             	lea    0x0(%esi),%esi
801071c8:	83 c0 04             	add    $0x4,%eax
801071cb:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
801071d1:	39 c1                	cmp    %eax,%ecx
801071d3:	89 10                	mov    %edx,(%eax)
801071d5:	75 f1                	jne    801071c8 <genrand+0x138>
801071d7:	e9 d4 fe ff ff       	jmp    801070b0 <genrand+0x20>
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801071e0 <random_at_most>:
801071e0:	55                   	push   %ebp
801071e1:	31 d2                	xor    %edx,%edx
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	56                   	push   %esi
801071e6:	53                   	push   %ebx
801071e7:	8b 45 08             	mov    0x8(%ebp),%eax
801071ea:	bb 00 00 00 80       	mov    $0x80000000,%ebx
801071ef:	8d 48 01             	lea    0x1(%eax),%ecx
801071f2:	89 d8                	mov    %ebx,%eax
801071f4:	f7 f1                	div    %ecx
801071f6:	89 c6                	mov    %eax,%esi
801071f8:	29 d3                	sub    %edx,%ebx
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107200:	e8 8b fe ff ff       	call   80107090 <genrand>
80107205:	39 d8                	cmp    %ebx,%eax
80107207:	73 f7                	jae    80107200 <random_at_most+0x20>
80107209:	31 d2                	xor    %edx,%edx
8010720b:	f7 f6                	div    %esi
8010720d:	5b                   	pop    %ebx
8010720e:	5e                   	pop    %esi
8010720f:	5d                   	pop    %ebp
80107210:	c3                   	ret    
