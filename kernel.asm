
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <brelse>:
}

// Release the buffer buf.
void
brelse(struct buf *b)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 14             	sub    $0x14,%esp
  100007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10000a:	f6 03 01             	testb  $0x1,(%ebx)
  10000d:	74 58                	je     100067 <brelse+0x67>
    panic("brelse");

  acquire(&buf_table_lock);
  10000f:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  100016:	e8 15 47 00 00       	call   104730 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 43 10             	mov    0x10(%ebx),%eax
  10001e:	8b 53 0c             	mov    0xc(%ebx),%edx
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  100021:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  if((b->flags & B_BUSY) == 0)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  100024:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
  100027:	8b 53 0c             	mov    0xc(%ebx),%edx
  b->next = bufhead.next;
  b->prev = &bufhead;
  10002a:	c7 43 0c e0 88 10 00 	movl   $0x1088e0,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 f0 88 10 00       	mov    0x1088f0,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 f0 88 10 00       	mov    0x1088f0,%eax
  bufhead.next = b;
  100041:	89 1d f0 88 10 00    	mov    %ebx,0x1088f0

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 00 8b 10 00 	movl   $0x108b00,(%esp)
  100051:	e8 9a 35 00 00       	call   1035f0 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 00 a0 10 00 	movl   $0x10a000,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 89 46 00 00       	jmp    1046f0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 e0 68 10 00 	movl   $0x1068e0,(%esp)
  10006e:	e8 ed 08 00 00       	call   100960 <panic>
  100073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100080 <bcheck>:
    bufhead.next = b;
  }
}

int
bcheck(uint dev, uint sector){
  100080:	55                   	push   %ebp
  100081:	89 e5                	mov    %esp,%ebp
  100083:	56                   	push   %esi
  100084:	53                   	push   %ebx
  100085:	83 ec 10             	sub    $0x10,%esp
  100088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10008b:	8b 75 0c             	mov    0xc(%ebp),%esi
	 struct buf *b;

	 acquire(&buf_table_lock);
  10008e:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  100095:	e8 96 46 00 00       	call   104730 <acquire>

	  // Try for cached block.
	  for(b = bufhead.next; b != &bufhead; b = b->next){
  10009a:	a1 f0 88 10 00       	mov    0x1088f0,%eax
  10009f:	3d e0 88 10 00       	cmp    $0x1088e0,%eax
  1000a4:	75 0c                	jne    1000b2 <bcheck+0x32>
  1000a6:	eb 38                	jmp    1000e0 <bcheck+0x60>
  1000a8:	8b 40 10             	mov    0x10(%eax),%eax
  1000ab:	3d e0 88 10 00       	cmp    $0x1088e0,%eax
  1000b0:	74 2e                	je     1000e0 <bcheck+0x60>
	    if((b->flags & (B_BUSY|B_VALID)) &&
  1000b2:	f6 00 03             	testb  $0x3,(%eax)
  1000b5:	74 f1                	je     1000a8 <bcheck+0x28>
	       b->dev == dev && b->sector == sector){
  1000b7:	39 58 04             	cmp    %ebx,0x4(%eax)
  1000ba:	75 ec                	jne    1000a8 <bcheck+0x28>
  1000bc:	39 70 08             	cmp    %esi,0x8(%eax)
  1000bf:	90                   	nop
  1000c0:	75 e6                	jne    1000a8 <bcheck+0x28>
	      release(&buf_table_lock);
  1000c2:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  1000c9:	e8 22 46 00 00       	call   1046f0 <release>
	    }
	  }
      release(&buf_table_lock);
	  return 0;

}
  1000ce:	83 c4 10             	add    $0x10,%esp

	  // Try for cached block.
	  for(b = bufhead.next; b != &bufhead; b = b->next){
	    if((b->flags & (B_BUSY|B_VALID)) &&
	       b->dev == dev && b->sector == sector){
	      release(&buf_table_lock);
  1000d1:	b8 01 00 00 00       	mov    $0x1,%eax
	    }
	  }
      release(&buf_table_lock);
	  return 0;

}
  1000d6:	5b                   	pop    %ebx
  1000d7:	5e                   	pop    %esi
  1000d8:	5d                   	pop    %ebp
  1000d9:	c3                   	ret    
  1000da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	       b->dev == dev && b->sector == sector){
	      release(&buf_table_lock);
	      return 1;
	    }
	  }
      release(&buf_table_lock);
  1000e0:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  1000e7:	e8 04 46 00 00       	call   1046f0 <release>
	  return 0;

}
  1000ec:	83 c4 10             	add    $0x10,%esp
	       b->dev == dev && b->sector == sector){
	      release(&buf_table_lock);
	      return 1;
	    }
	  }
      release(&buf_table_lock);
  1000ef:	31 c0                	xor    %eax,%eax
	  return 0;

}
  1000f1:	5b                   	pop    %ebx
  1000f2:	5e                   	pop    %esi
  1000f3:	5d                   	pop    %ebp
  1000f4:	c3                   	ret    
  1000f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100100 <bwrite>:
}

// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 18             	sub    $0x18,%esp
  100106:	8b 45 08             	mov    0x8(%ebp),%eax
  if((b->flags & B_BUSY) == 0)
  100109:	8b 10                	mov    (%eax),%edx
  10010b:	f6 c2 01             	test   $0x1,%dl
  10010e:	74 0e                	je     10011e <bwrite+0x1e>
    panic("bwrite");
  b->flags |= B_DIRTY;
  100110:	83 ca 04             	or     $0x4,%edx
  100113:	89 10                	mov    %edx,(%eax)
  ide_rw(b);
  100115:	89 45 08             	mov    %eax,0x8(%ebp)
}
  100118:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  ide_rw(b);
  100119:	e9 d2 21 00 00       	jmp    1022f0 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10011e:	c7 04 24 e7 68 10 00 	movl   $0x1068e7,(%esp)
  100125:	e8 36 08 00 00       	call   100960 <panic>
  10012a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100130 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  100130:	55                   	push   %ebp
  100131:	89 e5                	mov    %esp,%ebp
  100133:	57                   	push   %edi
  100134:	56                   	push   %esi
  100135:	53                   	push   %ebx
  100136:	83 ec 1c             	sub    $0x1c,%esp
  100139:	8b 75 08             	mov    0x8(%ebp),%esi
  10013c:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&buf_table_lock);
  10013f:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  100146:	e8 e5 45 00 00       	call   104730 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10014b:	8b 1d f0 88 10 00    	mov    0x1088f0,%ebx
  100151:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  100157:	75 12                	jne    10016b <bread+0x3b>
  100159:	eb 3d                	jmp    100198 <bread+0x68>
  10015b:	90                   	nop
  10015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100160:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100163:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  100169:	74 2d                	je     100198 <bread+0x68>
    if((b->flags & (B_BUSY|B_VALID)) &&
  10016b:	8b 03                	mov    (%ebx),%eax
  10016d:	a8 03                	test   $0x3,%al
  10016f:	74 ef                	je     100160 <bread+0x30>
  100171:	3b 73 04             	cmp    0x4(%ebx),%esi
  100174:	75 ea                	jne    100160 <bread+0x30>
  100176:	3b 7b 08             	cmp    0x8(%ebx),%edi
  100179:	75 e5                	jne    100160 <bread+0x30>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
  10017b:	a8 01                	test   $0x1,%al
  10017d:	8d 76 00             	lea    0x0(%esi),%esi
  100180:	74 71                	je     1001f3 <bread+0xc3>
        sleep(buf, &buf_table_lock);
  100182:	c7 44 24 04 00 a0 10 	movl   $0x10a000,0x4(%esp)
  100189:	00 
  10018a:	c7 04 24 00 8b 10 00 	movl   $0x108b00,(%esp)
  100191:	e8 0a 38 00 00       	call   1039a0 <sleep>
  100196:	eb b3                	jmp    10014b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100198:	8b 1d ec 88 10 00    	mov    0x1088ec,%ebx
  10019e:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  1001a4:	75 0d                	jne    1001b3 <bread+0x83>
  1001a6:	eb 3f                	jmp    1001e7 <bread+0xb7>
  1001a8:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1001ab:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  1001b1:	74 34                	je     1001e7 <bread+0xb7>
    if((b->flags & B_BUSY) == 0){
  1001b3:	f6 03 01             	testb  $0x1,(%ebx)
  1001b6:	75 f0                	jne    1001a8 <bread+0x78>
      b->flags = B_BUSY;
  1001b8:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      b->dev = dev;
  1001be:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  1001c1:	89 7b 08             	mov    %edi,0x8(%ebx)
      release(&buf_table_lock);
  1001c4:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  1001cb:	e8 20 45 00 00       	call   1046f0 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  1001d0:	f6 03 02             	testb  $0x2,(%ebx)
  1001d3:	75 08                	jne    1001dd <bread+0xad>
    ide_rw(b);
  1001d5:	89 1c 24             	mov    %ebx,(%esp)
  1001d8:	e8 13 21 00 00       	call   1022f0 <ide_rw>
  return b;
}
  1001dd:	83 c4 1c             	add    $0x1c,%esp
  1001e0:	89 d8                	mov    %ebx,%eax
  1001e2:	5b                   	pop    %ebx
  1001e3:	5e                   	pop    %esi
  1001e4:	5f                   	pop    %edi
  1001e5:	5d                   	pop    %ebp
  1001e6:	c3                   	ret    
      b->sector = sector;
      release(&buf_table_lock);
      return b;
    }
  }
  panic("bget: no buffers");
  1001e7:	c7 04 24 ee 68 10 00 	movl   $0x1068ee,(%esp)
  1001ee:	e8 6d 07 00 00       	call   100960 <panic>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
        sleep(buf, &buf_table_lock);
        goto loop;
      }
      b->flags |= B_BUSY;
  1001f3:	83 c8 01             	or     $0x1,%eax
  1001f6:	89 03                	mov    %eax,(%ebx)
      release(&buf_table_lock);
  1001f8:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  1001ff:	e8 ec 44 00 00       	call   1046f0 <release>
  100204:	eb ca                	jmp    1001d0 <bread+0xa0>
  100206:	8d 76 00             	lea    0x0(%esi),%esi
  100209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100210 <binit>:
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
{
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
  100213:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");
  100216:	c7 44 24 04 ff 68 10 	movl   $0x1068ff,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  100225:	e8 46 43 00 00       	call   104570 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10022a:	b8 f0 9f 10 00       	mov    $0x109ff0,%eax
  10022f:	3d 00 8b 10 00       	cmp    $0x108b00,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  100234:	c7 05 ec 88 10 00 e0 	movl   $0x1088e0,0x1088ec
  10023b:	88 10 00 
  bufhead.next = &bufhead;
  10023e:	c7 05 f0 88 10 00 e0 	movl   $0x1088e0,0x1088f0
  100245:	88 10 00 
  for(b = buf; b < buf+NBUF; b++){
  100248:	76 33                	jbe    10027d <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  10024a:	ba e0 88 10 00       	mov    $0x1088e0,%edx
  10024f:	b8 00 8b 10 00       	mov    $0x108b00,%eax
  100254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100258:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  10025b:	c7 40 0c e0 88 10 00 	movl   $0x1088e0,0xc(%eax)
    bufhead.next->prev = b;
  100262:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100265:	89 c2                	mov    %eax,%edx
  100267:	05 18 02 00 00       	add    $0x218,%eax
  10026c:	3d f0 9f 10 00       	cmp    $0x109ff0,%eax
  100271:	75 e5                	jne    100258 <binit+0x48>
  100273:	c7 05 f0 88 10 00 d8 	movl   $0x109dd8,0x1088f0
  10027a:	9d 10 00 
    b->next = bufhead.next;
    b->prev = &bufhead;
    bufhead.next->prev = b;
    bufhead.next = b;
  }
}
  10027d:	c9                   	leave  
  10027e:	c3                   	ret    
  10027f:	90                   	nop

00100280 <console_init>:
  return target - n;
}

void
console_init(void)
{
  100280:	55                   	push   %ebp
  100281:	89 e5                	mov    %esp,%ebp
  100283:	83 ec 18             	sub    $0x18,%esp
  initlock(&console_lock, "console");
  100286:	c7 44 24 04 09 69 10 	movl   $0x106909,0x4(%esp)
  10028d:	00 
  10028e:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100295:	e8 d6 42 00 00       	call   104570 <initlock>
  initlock(&input.lock, "console input");
  10029a:	c7 44 24 04 11 69 10 	movl   $0x106911,0x4(%esp)
  1002a1:	00 
  1002a2:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  1002a9:	e8 c2 42 00 00       	call   104570 <initlock>

  devsw[CONSOLE].write = console_write;
  devsw[CONSOLE].read = console_read;
  use_console_lock = 1;

  pic_enable(IRQ_KBD);
  1002ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
console_init(void)
{
  initlock(&console_lock, "console");
  initlock(&input.lock, "console input");

  devsw[CONSOLE].write = console_write;
  1002b5:	c7 05 ac aa 10 00 d0 	movl   $0x1006d0,0x10aaac
  1002bc:	06 10 00 
  devsw[CONSOLE].read = console_read;
  1002bf:	c7 05 a8 aa 10 00 f0 	movl   $0x1002f0,0x10aaa8
  1002c6:	02 10 00 
  use_console_lock = 1;
  1002c9:	c7 05 24 88 10 00 01 	movl   $0x1,0x108824
  1002d0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002d3:	e8 28 2d 00 00       	call   103000 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002df:	00 
  1002e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002e7:	e8 f4 21 00 00       	call   1024e0 <ioapic_enable>
}
  1002ec:	c9                   	leave  
  1002ed:	c3                   	ret    
  1002ee:	66 90                	xchg   %ax,%ax

001002f0 <console_read>:
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  1002f0:	55                   	push   %ebp
  1002f1:	89 e5                	mov    %esp,%ebp
  1002f3:	57                   	push   %edi
  1002f4:	56                   	push   %esi
  1002f5:	53                   	push   %ebx
  1002f6:	83 ec 2c             	sub    $0x2c,%esp
  1002f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1002fc:	8b 75 08             	mov    0x8(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  1002ff:	89 34 24             	mov    %esi,(%esp)
  100302:	e8 c9 1b 00 00       	call   101ed0 <iunlock>
  target = n;
  100307:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10030a:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  100311:	e8 1a 44 00 00       	call   104730 <acquire>
  while(n > 0){
  100316:	85 db                	test   %ebx,%ebx
  100318:	7f 26                	jg     100340 <console_read+0x50>
  10031a:	e9 bb 00 00 00       	jmp    1003da <console_read+0xea>
  10031f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  100320:	e8 cb 33 00 00       	call   1036f0 <curproc>
  100325:	8b 40 1c             	mov    0x1c(%eax),%eax
  100328:	85 c0                	test   %eax,%eax
  10032a:	75 5c                	jne    100388 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10032c:	c7 44 24 04 40 a0 10 	movl   $0x10a040,0x4(%esp)
  100333:	00 
  100334:	c7 04 24 f4 a0 10 00 	movl   $0x10a0f4,(%esp)
  10033b:	e8 60 36 00 00       	call   1039a0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100340:	a1 f4 a0 10 00       	mov    0x10a0f4,%eax
  100345:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  10034b:	74 d3                	je     100320 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10034d:	89 c2                	mov    %eax,%edx
  10034f:	83 e2 7f             	and    $0x7f,%edx
  100352:	0f b6 8a 74 a0 10 00 	movzbl 0x10a074(%edx),%ecx
  100359:	8d 78 01             	lea    0x1(%eax),%edi
  10035c:	89 3d f4 a0 10 00    	mov    %edi,0x10a0f4
  100362:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
  100365:	83 fa 04             	cmp    $0x4,%edx
  100368:	74 3f                	je     1003a9 <console_read+0xb9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10036a:	8b 45 0c             	mov    0xc(%ebp),%eax
    --n;
  10036d:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  100370:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  100373:	88 08                	mov    %cl,(%eax)
    --n;
    if(c == '\n')
  100375:	74 3c                	je     1003b3 <console_read+0xc3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  100377:	85 db                	test   %ebx,%ebx
  100379:	7e 38                	jle    1003b3 <console_read+0xc3>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10037b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  10037f:	eb bf                	jmp    100340 <console_read+0x50>
  100381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100388:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  10038f:	e8 5c 43 00 00       	call   1046f0 <release>
        ilock(ip);
  100394:	89 34 24             	mov    %esi,(%esp)
  100397:	e8 a4 1b 00 00       	call   101f40 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  10039c:	83 c4 2c             	add    $0x2c,%esp
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
        ilock(ip);
  10039f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  1003a4:	5b                   	pop    %ebx
  1003a5:	5e                   	pop    %esi
  1003a6:	5f                   	pop    %edi
  1003a7:	5d                   	pop    %ebp
  1003a8:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  1003a9:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  1003ac:	76 05                	jbe    1003b3 <console_read+0xc3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  1003ae:	a3 f4 a0 10 00       	mov    %eax,0x10a0f4
  1003b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1003b6:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1003b8:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  1003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1003c2:	e8 29 43 00 00       	call   1046f0 <release>
  ilock(ip);
  1003c7:	89 34 24             	mov    %esi,(%esp)
  1003ca:	e8 71 1b 00 00       	call   101f40 <ilock>
  1003cf:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
  1003d2:	83 c4 2c             	add    $0x2c,%esp
  1003d5:	5b                   	pop    %ebx
  1003d6:	5e                   	pop    %esi
  1003d7:	5f                   	pop    %edi
  1003d8:	5d                   	pop    %ebp
  1003d9:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1003da:	31 c0                	xor    %eax,%eax
  1003dc:	eb da                	jmp    1003b8 <console_read+0xc8>
  1003de:	66 90                	xchg   %ax,%ax

001003e0 <cons_putc>:
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  1003e0:	55                   	push   %ebp
  1003e1:	89 e5                	mov    %esp,%ebp
  1003e3:	57                   	push   %edi
  1003e4:	56                   	push   %esi
  1003e5:	53                   	push   %ebx
  1003e6:	83 ec 1c             	sub    $0x1c,%esp
  1003e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(panicked){
  1003ec:	83 3d 20 88 10 00 00 	cmpl   $0x0,0x108820
  1003f3:	0f 85 e1 00 00 00    	jne    1004da <cons_putc+0xfa>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003f9:	b8 79 03 00 00       	mov    $0x379,%eax
  1003fe:	89 c2                	mov    %eax,%edx
  100400:	ec                   	in     (%dx),%al
}

static inline void
cli(void)
{
  asm volatile("cli");
  100401:	31 db                	xor    %ebx,%ebx
static void
lpt_putc(int c)
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
  100403:	84 c0                	test   %al,%al
  100405:	79 14                	jns    10041b <cons_putc+0x3b>
  100407:	eb 19                	jmp    100422 <cons_putc+0x42>
  100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100410:	83 c3 01             	add    $0x1,%ebx
  100413:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
  100419:	74 07                	je     100422 <cons_putc+0x42>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10041b:	ec                   	in     (%dx),%al
  10041c:	84 c0                	test   %al,%al
  10041e:	66 90                	xchg   %ax,%ax
  100420:	79 ee                	jns    100410 <cons_putc+0x30>
    ;
  if(c == BACKSPACE)
  100422:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  100428:	89 c8                	mov    %ecx,%eax
  10042a:	0f 84 ad 00 00 00    	je     1004dd <cons_putc+0xfd>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100430:	ba 78 03 00 00       	mov    $0x378,%edx
  100435:	ee                   	out    %al,(%dx)
  100436:	b8 0d 00 00 00       	mov    $0xd,%eax
  10043b:	b2 7a                	mov    $0x7a,%dl
  10043d:	ee                   	out    %al,(%dx)
  10043e:	b8 08 00 00 00       	mov    $0x8,%eax
  100443:	ee                   	out    %al,(%dx)
  100444:	be d4 03 00 00       	mov    $0x3d4,%esi
  100449:	b8 0e 00 00 00       	mov    $0xe,%eax
  10044e:	89 f2                	mov    %esi,%edx
  100450:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100451:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100456:	89 fa                	mov    %edi,%edx
  100458:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  100459:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10045c:	89 f2                	mov    %esi,%edx
  10045e:	c1 e3 08             	shl    $0x8,%ebx
  100461:	b8 0f 00 00 00       	mov    $0xf,%eax
  100466:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100467:	89 fa                	mov    %edi,%edx
  100469:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  10046a:	0f b6 c0             	movzbl %al,%eax
  10046d:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  10046f:	83 f9 0a             	cmp    $0xa,%ecx
  100472:	0f 84 da 00 00 00    	je     100552 <cons_putc+0x172>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  100478:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  10047e:	0f 84 ad 00 00 00    	je     100531 <cons_putc+0x151>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  100484:	66 81 e1 ff 00       	and    $0xff,%cx
  100489:	80 cd 07             	or     $0x7,%ch
  10048c:	66 89 8c 1b 00 80 0b 	mov    %cx,0xb8000(%ebx,%ebx,1)
  100493:	00 
  100494:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  100497:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  10049d:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  1004a4:	7f 41                	jg     1004e7 <cons_putc+0x107>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1004a6:	be d4 03 00 00       	mov    $0x3d4,%esi
  1004ab:	b8 0e 00 00 00       	mov    $0xe,%eax
  1004b0:	89 f2                	mov    %esi,%edx
  1004b2:	ee                   	out    %al,(%dx)
  1004b3:	bf d5 03 00 00       	mov    $0x3d5,%edi
  1004b8:	89 d8                	mov    %ebx,%eax
  1004ba:	c1 f8 08             	sar    $0x8,%eax
  1004bd:	89 fa                	mov    %edi,%edx
  1004bf:	ee                   	out    %al,(%dx)
  1004c0:	b8 0f 00 00 00       	mov    $0xf,%eax
  1004c5:	89 f2                	mov    %esi,%edx
  1004c7:	ee                   	out    %al,(%dx)
  1004c8:	89 d8                	mov    %ebx,%eax
  1004ca:	89 fa                	mov    %edi,%edx
  1004cc:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  1004cd:	66 c7 01 20 07       	movw   $0x720,(%ecx)
      ;
  }

  lpt_putc(c);
  cga_putc(c);
}
  1004d2:	83 c4 1c             	add    $0x1c,%esp
  1004d5:	5b                   	pop    %ebx
  1004d6:	5e                   	pop    %esi
  1004d7:	5f                   	pop    %edi
  1004d8:	5d                   	pop    %ebp
  1004d9:	c3                   	ret    
}

static inline void
cli(void)
{
  asm volatile("cli");
  1004da:	fa                   	cli    
  1004db:	eb fe                	jmp    1004db <cons_putc+0xfb>
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
    ;
  if(c == BACKSPACE)
  1004dd:	b8 08 00 00 00       	mov    $0x8,%eax
  1004e2:	e9 49 ff ff ff       	jmp    100430 <cons_putc+0x50>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  1004e7:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  1004ea:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  1004f1:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f2:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  1004f9:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  100500:	00 
  100501:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  100508:	e8 23 43 00 00       	call   104830 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10050d:	b8 80 07 00 00       	mov    $0x780,%eax
  100512:	29 d8                	sub    %ebx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	89 44 24 08          	mov    %eax,0x8(%esp)
  10051a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100521:	00 
  100522:	89 34 24             	mov    %esi,(%esp)
  100525:	e8 76 42 00 00       	call   1047a0 <memset>
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
  10052a:	89 f1                	mov    %esi,%ecx
  10052c:	e9 75 ff ff ff       	jmp    1004a6 <cons_putc+0xc6>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  100531:	85 db                	test   %ebx,%ebx
  100533:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  10053a:	0f 8e 66 ff ff ff    	jle    1004a6 <cons_putc+0xc6>
      crt[--pos] = ' ' | 0x0700;
  100540:	83 eb 01             	sub    $0x1,%ebx
  100543:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  10054a:	00 20 07 
  10054d:	e9 45 ff ff ff       	jmp    100497 <cons_putc+0xb7>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  100552:	b8 50 00 00 00       	mov    $0x50,%eax
  100557:	89 da                	mov    %ebx,%edx
  100559:	89 c1                	mov    %eax,%ecx
  10055b:	89 d8                	mov    %ebx,%eax
  10055d:	c1 fa 1f             	sar    $0x1f,%edx
  100560:	83 c3 50             	add    $0x50,%ebx
  100563:	f7 f9                	idiv   %ecx
  100565:	29 d3                	sub    %edx,%ebx
  100567:	e9 2b ff ff ff       	jmp    100497 <cons_putc+0xb7>
  10056c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100570 <console_intr>:

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100570:	55                   	push   %ebp
  100571:	89 e5                	mov    %esp,%ebp
  100573:	56                   	push   %esi
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  100574:	be 70 a0 10 00       	mov    $0x10a070,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100579:	53                   	push   %ebx
  10057a:	83 ec 20             	sub    $0x20,%esp
  10057d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100580:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  100587:	e8 a4 41 00 00       	call   104730 <acquire>
  10058c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
  100590:	ff d3                	call   *%ebx
  100592:	85 c0                	test   %eax,%eax
  100594:	0f 88 8e 00 00 00    	js     100628 <console_intr+0xb8>
    switch(c){
  10059a:	83 f8 10             	cmp    $0x10,%eax
  10059d:	8d 76 00             	lea    0x0(%esi),%esi
  1005a0:	0f 84 d2 00 00 00    	je     100678 <console_intr+0x108>
  1005a6:	83 f8 15             	cmp    $0x15,%eax
  1005a9:	0f 84 b7 00 00 00    	je     100666 <console_intr+0xf6>
  1005af:	83 f8 08             	cmp    $0x8,%eax
  1005b2:	0f 84 d0 00 00 00    	je     100688 <console_intr+0x118>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  1005b8:	85 c0                	test   %eax,%eax
  1005ba:	74 d4                	je     100590 <console_intr+0x20>
  1005bc:	8b 15 fc a0 10 00    	mov    0x10a0fc,%edx
  1005c2:	89 d1                	mov    %edx,%ecx
  1005c4:	2b 0d f4 a0 10 00    	sub    0x10a0f4,%ecx
  1005ca:	83 f9 7f             	cmp    $0x7f,%ecx
  1005cd:	77 c1                	ja     100590 <console_intr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
  1005cf:	89 d1                	mov    %edx,%ecx
  1005d1:	83 c2 01             	add    $0x1,%edx
  1005d4:	83 e1 7f             	and    $0x7f,%ecx
  1005d7:	88 44 0e 04          	mov    %al,0x4(%esi,%ecx,1)
        cons_putc(c);
  1005db:	89 04 24             	mov    %eax,(%esp)
  1005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  1005e1:	89 15 fc a0 10 00    	mov    %edx,0x10a0fc
        cons_putc(c);
  1005e7:	e8 f4 fd ff ff       	call   1003e0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ef:	83 f8 04             	cmp    $0x4,%eax
  1005f2:	0f 84 ba 00 00 00    	je     1006b2 <console_intr+0x142>
  1005f8:	83 f8 0a             	cmp    $0xa,%eax
  1005fb:	0f 84 b1 00 00 00    	je     1006b2 <console_intr+0x142>
  100601:	8b 15 f4 a0 10 00    	mov    0x10a0f4,%edx
  100607:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10060c:	83 ea 80             	sub    $0xffffff80,%edx
  10060f:	39 d0                	cmp    %edx,%eax
  100611:	0f 84 a0 00 00 00    	je     1006b7 <console_intr+0x147>
console_intr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  100617:	ff d3                	call   *%ebx
  100619:	85 c0                	test   %eax,%eax
  10061b:	0f 89 79 ff ff ff    	jns    10059a <console_intr+0x2a>
  100621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&input.lock);
  100628:	c7 45 08 40 a0 10 00 	movl   $0x10a040,0x8(%ebp)
}
  10062f:	83 c4 20             	add    $0x20,%esp
  100632:	5b                   	pop    %ebx
  100633:	5e                   	pop    %esi
  100634:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  100635:	e9 b6 40 00 00       	jmp    1046f0 <release>
  10063a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  100640:	83 e8 01             	sub    $0x1,%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	83 e2 7f             	and    $0x7f,%edx
  100648:	80 ba 74 a0 10 00 0a 	cmpb   $0xa,0x10a074(%edx)
  10064f:	0f 84 3b ff ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100655:	a3 fc a0 10 00       	mov    %eax,0x10a0fc
        cons_putc(BACKSPACE);
  10065a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100661:	e8 7a fd ff ff       	call   1003e0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100666:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10066b:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  100671:	75 cd                	jne    100640 <console_intr+0xd0>
  100673:	e9 18 ff ff ff       	jmp    100590 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100678:	e8 13 2e 00 00       	call   103490 <procdump>
  10067d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
  100680:	e9 0b ff ff ff       	jmp    100590 <console_intr+0x20>
  100685:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  100688:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10068d:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  100693:	0f 84 f7 fe ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100699:	83 e8 01             	sub    $0x1,%eax
  10069c:	a3 fc a0 10 00       	mov    %eax,0x10a0fc
        cons_putc(BACKSPACE);
  1006a1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1006a8:	e8 33 fd ff ff       	call   1003e0 <cons_putc>
  1006ad:	e9 de fe ff ff       	jmp    100590 <console_intr+0x20>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        cons_putc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1006b2:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
          input.w = input.e;
  1006b7:	a3 f8 a0 10 00       	mov    %eax,0x10a0f8
          wakeup(&input.r);
  1006bc:	c7 04 24 f4 a0 10 00 	movl   $0x10a0f4,(%esp)
  1006c3:	e8 28 2f 00 00       	call   1035f0 <wakeup>
  1006c8:	e9 c3 fe ff ff       	jmp    100590 <console_intr+0x20>
  1006cd:	8d 76 00             	lea    0x0(%esi),%esi

001006d0 <console_write>:
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  1006d0:	55                   	push   %ebp
  1006d1:	89 e5                	mov    %esp,%ebp
  1006d3:	57                   	push   %edi
  1006d4:	56                   	push   %esi
  1006d5:	53                   	push   %ebx
  1006d6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
  1006d9:	8b 45 08             	mov    0x8(%ebp),%eax
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  1006dc:	8b 75 10             	mov    0x10(%ebp),%esi
  1006df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  1006e2:	89 04 24             	mov    %eax,(%esp)
  1006e5:	e8 e6 17 00 00       	call   101ed0 <iunlock>
  acquire(&console_lock);
  1006ea:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  1006f1:	e8 3a 40 00 00       	call   104730 <acquire>
  for(i = 0; i < n; i++)
  1006f6:	85 f6                	test   %esi,%esi
  1006f8:	7e 19                	jle    100713 <console_write+0x43>
  1006fa:	31 db                	xor    %ebx,%ebx
  1006fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cons_putc(buf[i] & 0xff);
  100700:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  100704:	83 c3 01             	add    $0x1,%ebx
    cons_putc(buf[i] & 0xff);
  100707:	89 14 24             	mov    %edx,(%esp)
  10070a:	e8 d1 fc ff ff       	call   1003e0 <cons_putc>
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  10070f:	39 de                	cmp    %ebx,%esi
  100711:	7f ed                	jg     100700 <console_write+0x30>
    cons_putc(buf[i] & 0xff);
  release(&console_lock);
  100713:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  10071a:	e8 d1 3f 00 00       	call   1046f0 <release>
  ilock(ip);
  10071f:	8b 45 08             	mov    0x8(%ebp),%eax
  100722:	89 04 24             	mov    %eax,(%esp)
  100725:	e8 16 18 00 00       	call   101f40 <ilock>

  return n;
}
  10072a:	83 c4 1c             	add    $0x1c,%esp
  10072d:	89 f0                	mov    %esi,%eax
  10072f:	5b                   	pop    %ebx
  100730:	5e                   	pop    %esi
  100731:	5f                   	pop    %edi
  100732:	5d                   	pop    %ebp
  100733:	c3                   	ret    
  100734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10073a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100740 <printint>:
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  100740:	55                   	push   %ebp
  100741:	89 e5                	mov    %esp,%ebp
  100743:	57                   	push   %edi
  100744:	56                   	push   %esi
  100745:	53                   	push   %ebx
  100746:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100749:	8b 55 10             	mov    0x10(%ebp),%edx
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  10074c:	8b 45 08             	mov    0x8(%ebp),%eax
  10074f:	8b 75 0c             	mov    0xc(%ebp),%esi
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100752:	85 d2                	test   %edx,%edx
  100754:	74 04                	je     10075a <printint+0x1a>
  100756:	85 c0                	test   %eax,%eax
  100758:	78 54                	js     1007ae <printint+0x6e>
    neg = 1;
    x = 0 - xx;
  } else {
    x = xx;
  10075a:	31 ff                	xor    %edi,%edi
  10075c:	31 c9                	xor    %ecx,%ecx
  10075e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  100761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  do{
    buf[i++] = digits[x % base];
  100768:	31 d2                	xor    %edx,%edx
  10076a:	f7 f6                	div    %esi
  10076c:	0f b6 92 39 69 10 00 	movzbl 0x106939(%edx),%edx
  100773:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  100776:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
  100779:	85 c0                	test   %eax,%eax
  10077b:	75 eb                	jne    100768 <printint+0x28>
  if(neg)
  10077d:	85 ff                	test   %edi,%edi
  10077f:	74 08                	je     100789 <printint+0x49>
    buf[i++] = '-';
  100781:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
  100786:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
  100789:	8d 71 ff             	lea    -0x1(%ecx),%esi
  10078c:	01 f3                	add    %esi,%ebx
  10078e:	66 90                	xchg   %ax,%ax
    cons_putc(buf[i]);
  100790:	0f be 03             	movsbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100793:	83 ee 01             	sub    $0x1,%esi
  100796:	83 eb 01             	sub    $0x1,%ebx
    cons_putc(buf[i]);
  100799:	89 04 24             	mov    %eax,(%esp)
  10079c:	e8 3f fc ff ff       	call   1003e0 <cons_putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  1007a1:	83 fe ff             	cmp    $0xffffffff,%esi
  1007a4:	75 ea                	jne    100790 <printint+0x50>
    cons_putc(buf[i]);
}
  1007a6:	83 c4 2c             	add    $0x2c,%esp
  1007a9:	5b                   	pop    %ebx
  1007aa:	5e                   	pop    %esi
  1007ab:	5f                   	pop    %edi
  1007ac:	5d                   	pop    %ebp
  1007ad:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  1007ae:	f7 d8                	neg    %eax
  1007b0:	bf 01 00 00 00       	mov    $0x1,%edi
  1007b5:	eb a5                	jmp    10075c <printint+0x1c>
  1007b7:	89 f6                	mov    %esi,%esi
  1007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001007c0 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1007c0:	55                   	push   %ebp
  1007c1:	89 e5                	mov    %esp,%ebp
  1007c3:	57                   	push   %edi
  1007c4:	56                   	push   %esi
  1007c5:	53                   	push   %ebx
  1007c6:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  1007c9:	a1 24 88 10 00       	mov    0x108824,%eax
  if(locking)
  1007ce:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  1007d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
  1007d3:	0f 85 67 01 00 00    	jne    100940 <cprintf+0x180>
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1007dc:	0f b6 02             	movzbl (%edx),%eax
  1007df:	84 c0                	test   %al,%al
  1007e1:	0f 84 81 00 00 00    	je     100868 <cprintf+0xa8>

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  1007e7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  1007ea:	31 f6                	xor    %esi,%esi
  1007ec:	31 db                	xor    %ebx,%ebx
  1007ee:	eb 1b                	jmp    10080b <cprintf+0x4b>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    switch(state){
    case 0:
      if(c == '%')
  1007f0:	83 f8 25             	cmp    $0x25,%eax
  1007f3:	0f 85 8f 00 00 00    	jne    100888 <cprintf+0xc8>
  1007f9:	be 25 00 00 00       	mov    $0x25,%esi
  1007fe:	66 90                	xchg   %ax,%ax
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100800:	83 c3 01             	add    $0x1,%ebx
  100803:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  100807:	84 c0                	test   %al,%al
  100809:	74 5d                	je     100868 <cprintf+0xa8>
    c = fmt[i] & 0xff;
    switch(state){
  10080b:	85 f6                	test   %esi,%esi
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  10080d:	0f b6 c0             	movzbl %al,%eax
    switch(state){
  100810:	74 de                	je     1007f0 <cprintf+0x30>
  100812:	83 fe 25             	cmp    $0x25,%esi
  100815:	75 e9                	jne    100800 <cprintf+0x40>
      else
        cons_putc(c);
      break;
    
    case '%':
      switch(c){
  100817:	83 f8 70             	cmp    $0x70,%eax
  10081a:	0f 84 82 00 00 00    	je     1008a2 <cprintf+0xe2>
  100820:	7f 76                	jg     100898 <cprintf+0xd8>
  100822:	83 f8 25             	cmp    $0x25,%eax
  100825:	8d 76 00             	lea    0x0(%esi),%esi
  100828:	0f 84 fa 00 00 00    	je     100928 <cprintf+0x168>
  10082e:	83 f8 64             	cmp    $0x64,%eax
  100831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100838:	0f 84 c2 00 00 00    	je     100900 <cprintf+0x140>
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  10083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100841:	83 c3 01             	add    $0x1,%ebx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  100844:	31 f6                	xor    %esi,%esi
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  100846:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10084d:	e8 8e fb ff ff       	call   1003e0 <cons_putc>
        cons_putc(c);
  100852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100855:	89 04 24             	mov    %eax,(%esp)
  100858:	e8 83 fb ff ff       	call   1003e0 <cons_putc>
  10085d:	8b 55 08             	mov    0x8(%ebp),%edx
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100860:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  100864:	84 c0                	test   %al,%al
  100866:	75 a3                	jne    10080b <cprintf+0x4b>
      state = 0;
      break;
    }
  }

  if(locking)
  100868:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10086b:	85 c9                	test   %ecx,%ecx
  10086d:	74 0c                	je     10087b <cprintf+0xbb>
    release(&console_lock);
  10086f:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100876:	e8 75 3e 00 00       	call   1046f0 <release>
}
  10087b:	83 c4 2c             	add    $0x2c,%esp
  10087e:	5b                   	pop    %ebx
  10087f:	5e                   	pop    %esi
  100880:	5f                   	pop    %edi
  100881:	5d                   	pop    %ebp
  100882:	c3                   	ret    
  100883:	90                   	nop
  100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(state){
    case 0:
      if(c == '%')
        state = '%';
      else
        cons_putc(c);
  100888:	89 04 24             	mov    %eax,(%esp)
  10088b:	e8 50 fb ff ff       	call   1003e0 <cons_putc>
  100890:	8b 55 08             	mov    0x8(%ebp),%edx
  100893:	e9 68 ff ff ff       	jmp    100800 <cprintf+0x40>
      break;
    
    case '%':
      switch(c){
  100898:	83 f8 73             	cmp    $0x73,%eax
  10089b:	74 33                	je     1008d0 <cprintf+0x110>
  10089d:	83 f8 78             	cmp    $0x78,%eax
  1008a0:	75 9c                	jne    10083e <cprintf+0x7e>
      case 'd':
        printint(*argp++, 10, 1);
        break;
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
  1008a2:	8b 07                	mov    (%edi),%eax
  1008a4:	31 f6                	xor    %esi,%esi
  1008a6:	83 c7 04             	add    $0x4,%edi
  1008a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1008b0:	00 
  1008b1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1008b8:	00 
  1008b9:	89 04 24             	mov    %eax,(%esp)
  1008bc:	e8 7f fe ff ff       	call   100740 <printint>
  1008c1:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  1008c4:	e9 37 ff ff ff       	jmp    100800 <cprintf+0x40>
  1008c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      case 's':
        s = (char*)*argp++;
  1008d0:	8b 37                	mov    (%edi),%esi
  1008d2:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
  1008d5:	85 f6                	test   %esi,%esi
  1008d7:	74 78                	je     100951 <cprintf+0x191>
          s = "(null)";
        for(; *s; s++)
  1008d9:	0f b6 06             	movzbl (%esi),%eax
  1008dc:	84 c0                	test   %al,%al
  1008de:	74 18                	je     1008f8 <cprintf+0x138>
          cons_putc(*s);
  1008e0:	0f be c0             	movsbl %al,%eax
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  1008e3:	83 c6 01             	add    $0x1,%esi
          cons_putc(*s);
  1008e6:	89 04 24             	mov    %eax,(%esp)
  1008e9:	e8 f2 fa ff ff       	call   1003e0 <cons_putc>
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  1008ee:	0f b6 06             	movzbl (%esi),%eax
  1008f1:	84 c0                	test   %al,%al
  1008f3:	75 eb                	jne    1008e0 <cprintf+0x120>
  1008f5:	8b 55 08             	mov    0x8(%ebp),%edx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  1008f8:	31 f6                	xor    %esi,%esi
  1008fa:	e9 01 ff ff ff       	jmp    100800 <cprintf+0x40>
  1008ff:	90                   	nop
      break;
    
    case '%':
      switch(c){
      case 'd':
        printint(*argp++, 10, 1);
  100900:	8b 07                	mov    (%edi),%eax
  100902:	31 f6                	xor    %esi,%esi
  100904:	83 c7 04             	add    $0x4,%edi
  100907:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10090e:	00 
  10090f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  100916:	00 
  100917:	89 04 24             	mov    %eax,(%esp)
  10091a:	e8 21 fe ff ff       	call   100740 <printint>
  10091f:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  100922:	e9 d9 fe ff ff       	jmp    100800 <cprintf+0x40>
  100927:	90                   	nop
          s = "(null)";
        for(; *s; s++)
          cons_putc(*s);
        break;
      case '%':
        cons_putc('%');
  100928:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10092f:	31 f6                	xor    %esi,%esi
  100931:	e8 aa fa ff ff       	call   1003e0 <cons_putc>
  100936:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  100939:	e9 c2 fe ff ff       	jmp    100800 <cprintf+0x40>
  10093e:	66 90                	xchg   %ax,%ax
  uint *argp;
  char *s;

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);
  100940:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100947:	e8 e4 3d 00 00       	call   104730 <acquire>
  10094c:	e9 88 fe ff ff       	jmp    1007d9 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  100951:	be 1f 69 10 00       	mov    $0x10691f,%esi
  100956:	eb 81                	jmp    1008d9 <cprintf+0x119>
  100958:	90                   	nop
  100959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100960 <panic>:
  ioapic_enable(IRQ_KBD, 0);
}

void
panic(char *s)
{
  100960:	55                   	push   %ebp
  100961:	89 e5                	mov    %esp,%ebp
  100963:	56                   	push   %esi
  100964:	53                   	push   %ebx
  100965:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  100968:	c7 05 24 88 10 00 00 	movl   $0x0,0x108824
  10096f:	00 00 00 
panic(char *s)
{
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  100972:	fa                   	cli    
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  100973:	e8 e8 21 00 00       	call   102b60 <cpu>
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  100978:	8d 75 d0             	lea    -0x30(%ebp),%esi
  10097b:	31 db                	xor    %ebx,%ebx
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  10097d:	c7 04 24 26 69 10 00 	movl   $0x106926,(%esp)
  100984:	89 44 24 04          	mov    %eax,0x4(%esp)
  100988:	e8 33 fe ff ff       	call   1007c0 <cprintf>
  cprintf(s);
  10098d:	8b 45 08             	mov    0x8(%ebp),%eax
  100990:	89 04 24             	mov    %eax,(%esp)
  100993:	e8 28 fe ff ff       	call   1007c0 <cprintf>
  cprintf("\n");
  100998:	c7 04 24 93 6d 10 00 	movl   $0x106d93,(%esp)
  10099f:	e8 1c fe ff ff       	call   1007c0 <cprintf>
  getcallerpcs(&s, pcs);
  1009a4:	8d 45 08             	lea    0x8(%ebp),%eax
  1009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1009ab:	89 04 24             	mov    %eax,(%esp)
  1009ae:	e8 dd 3b 00 00       	call   104590 <getcallerpcs>
  1009b3:	90                   	nop
  1009b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1009b8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  1009bb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
  1009be:	c7 04 24 35 69 10 00 	movl   $0x106935,(%esp)
  1009c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c9:	e8 f2 fd ff ff       	call   1007c0 <cprintf>
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  1009ce:	83 fb 0a             	cmp    $0xa,%ebx
  1009d1:	75 e5                	jne    1009b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  1009d3:	c7 05 20 88 10 00 01 	movl   $0x1,0x108820
  1009da:	00 00 00 
  1009dd:	eb fe                	jmp    1009dd <panic+0x7d>
  1009df:	90                   	nop

001009e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  1009e0:	55                   	push   %ebp
  1009e1:	89 e5                	mov    %esp,%ebp
  1009e3:	57                   	push   %edi
  1009e4:	56                   	push   %esi
  1009e5:	53                   	push   %ebx
  1009e6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  uint sz, sp, argp;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;

  if((ip = namei(path)) == 0)
  1009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ef:	89 04 24             	mov    %eax,(%esp)
  1009f2:	e8 09 18 00 00       	call   102200 <namei>
  1009f7:	89 c3                	mov    %eax,%ebx
  1009f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009fe:	85 db                	test   %ebx,%ebx
  100a00:	0f 84 81 03 00 00    	je     100d87 <exec+0x3a7>
    return -1;
  ilock(ip);
  100a06:	89 1c 24             	mov    %ebx,(%esp)
  100a09:	e8 32 15 00 00       	call   101f40 <ilock>
  // Compute memory size of new process.
  mem = 0;
  sz = 0;

  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  100a0e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  100a11:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100a18:	00 
  100a19:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100a20:	00 
  100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a25:	89 1c 24             	mov    %ebx,(%esp)
  100a28:	e8 e3 0b 00 00       	call   101610 <readi>
  100a2d:	83 f8 33             	cmp    $0x33,%eax
  100a30:	0f 86 74 03 00 00    	jbe    100daa <exec+0x3ca>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  100a36:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
  100a3d:	0f 85 67 03 00 00    	jne    100daa <exec+0x3ca>
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100a43:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100a48:	bf ff 1f 00 00       	mov    $0x1fff,%edi
  100a4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100a50:	74 6b                	je     100abd <exec+0xdd>
  100a52:	89 c7                	mov    %eax,%edi
  100a54:	31 f6                	xor    %esi,%esi
  100a56:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100a5d:	eb 0f                	jmp    100a6e <exec+0x8e>
  100a5f:	90                   	nop
  100a60:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100a64:	83 c6 01             	add    $0x1,%esi
  100a67:	39 f0                	cmp    %esi,%eax
  100a69:	7e 49                	jle    100ab4 <exec+0xd4>
  100a6b:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100a6e:	8d 55 c8             	lea    -0x38(%ebp),%edx
  100a71:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100a78:	00 
  100a79:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100a7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a81:	89 1c 24             	mov    %ebx,(%esp)
  100a84:	e8 87 0b 00 00       	call   101610 <readi>
  100a89:	83 f8 20             	cmp    $0x20,%eax
  100a8c:	0f 85 18 03 00 00    	jne    100daa <exec+0x3ca>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100a92:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100a96:	75 c8                	jne    100a60 <exec+0x80>
      continue;
    if(ph.memsz < ph.filesz)
  100a98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a9b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100a9e:	66 90                	xchg   %ax,%ax
  100aa0:	0f 82 04 03 00 00    	jb     100daa <exec+0x3ca>
      goto bad;
    sz += ph.memsz;
  100aa6:	01 45 84             	add    %eax,-0x7c(%ebp)
  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100aa9:	83 c6 01             	add    $0x1,%esi
  100aac:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100ab0:	39 f0                	cmp    %esi,%eax
  100ab2:	7f b7                	jg     100a6b <exec+0x8b>
  100ab4:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100ab7:	81 c7 ff 1f 00 00    	add    $0x1fff,%edi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ac0:	31 f6                	xor    %esi,%esi
  100ac2:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  100ac9:	00 00 00 
  100acc:	8b 11                	mov    (%ecx),%edx
  100ace:	85 d2                	test   %edx,%edx
  100ad0:	0f 84 ec 02 00 00    	je     100dc2 <exec+0x3e2>
  100ad6:	89 7d 84             	mov    %edi,-0x7c(%ebp)
  100ad9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100adc:	89 5d 80             	mov    %ebx,-0x80(%ebp)
  100adf:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
  100ae5:	8d 76 00             	lea    0x0(%esi),%esi
    arglen += strlen(argv[argc]) + 1;
  100ae8:	89 14 24             	mov    %edx,(%esp)
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100aeb:	83 c3 01             	add    $0x1,%ebx
    arglen += strlen(argv[argc]) + 1;
  100aee:	e8 8d 3e 00 00       	call   104980 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100af3:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
  100af6:	89 d9                	mov    %ebx,%ecx
    arglen += strlen(argv[argc]) + 1;
  100af8:	01 f0                	add    %esi,%eax
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100afa:	85 d2                	test   %edx,%edx
    arglen += strlen(argv[argc]) + 1;
  100afc:	8d 70 01             	lea    0x1(%eax),%esi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100aff:	75 e7                	jne    100ae8 <exec+0x108>
  100b01:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
  100b07:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100b0a:	83 c0 04             	add    $0x4,%eax
  100b0d:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100b10:	83 e0 fc             	and    $0xfffffffc,%eax
  100b13:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  100b19:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
  100b1d:	89 8d 74 ff ff ff    	mov    %ecx,-0x8c(%ebp)

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100b23:	8d 3c 38             	lea    (%eax,%edi,1),%edi
  100b26:	89 7d 80             	mov    %edi,-0x80(%ebp)
  100b29:	81 65 80 00 f0 ff ff 	andl   $0xfffff000,-0x80(%ebp)
  mem = kalloc(sz);
  100b30:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100b33:	89 0c 24             	mov    %ecx,(%esp)
  100b36:	e8 95 1a 00 00       	call   1025d0 <kalloc>
  if(mem == 0)
  100b3b:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100b3d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  if(mem == 0)
  100b40:	0f 84 64 02 00 00    	je     100daa <exec+0x3ca>
    goto bad;
  memset(mem, 0, sz);
  100b46:	8b 45 80             	mov    -0x80(%ebp),%eax
  100b49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b50:	00 
  100b51:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b55:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100b58:	89 14 24             	mov    %edx,(%esp)
  100b5b:	e8 40 3c 00 00       	call   1047a0 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b60:	8b 7d b0             	mov    -0x50(%ebp),%edi
  100b63:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100b68:	0f 84 ab 00 00 00    	je     100c19 <exec+0x239>
  100b6e:	31 f6                	xor    %esi,%esi
  100b70:	eb 18                	jmp    100b8a <exec+0x1aa>
  100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100b78:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100b7c:	83 c6 01             	add    $0x1,%esi
  100b7f:	39 f0                	cmp    %esi,%eax
  100b81:	0f 8e 92 00 00 00    	jle    100c19 <exec+0x239>
  100b87:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100b8a:	8d 4d c8             	lea    -0x38(%ebp),%ecx
  100b8d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100b94:	00 
  100b95:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100b99:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b9d:	89 1c 24             	mov    %ebx,(%esp)
  100ba0:	e8 6b 0a 00 00       	call   101610 <readi>
  100ba5:	83 f8 20             	cmp    $0x20,%eax
  100ba8:	0f 85 ea 01 00 00    	jne    100d98 <exec+0x3b8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100bae:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100bb2:	75 c4                	jne    100b78 <exec+0x198>
      continue;
    if(ph.va + ph.memsz > sz)
  100bb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100bb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100bba:	01 c2                	add    %eax,%edx
  100bbc:	39 55 80             	cmp    %edx,-0x80(%ebp)
  100bbf:	0f 82 d3 01 00 00    	jb     100d98 <exec+0x3b8>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100bc5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100bc8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100bcc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  100bcf:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bd3:	03 45 84             	add    -0x7c(%ebp),%eax
  100bd6:	89 1c 24             	mov    %ebx,(%esp)
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	e8 2e 0a 00 00       	call   101610 <readi>
  100be2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100be5:	0f 85 ad 01 00 00    	jne    100d98 <exec+0x3b8>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100beb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100bee:	83 c6 01             	add    $0x1,%esi
      continue;
    if(ph.va + ph.memsz > sz)
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100bf1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100bf8:	00 
  100bf9:	29 c2                	sub    %eax,%edx
  100bfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bff:	03 45 d0             	add    -0x30(%ebp),%eax
  100c02:	03 45 84             	add    -0x7c(%ebp),%eax
  100c05:	89 04 24             	mov    %eax,(%esp)
  100c08:	e8 93 3b 00 00       	call   1047a0 <memset>
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100c0d:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100c11:	39 f0                	cmp    %esi,%eax
  100c13:	0f 8f 6e ff ff ff    	jg     100b87 <exec+0x1a7>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100c19:	89 1c 24             	mov    %ebx,(%esp)
  100c1c:	e8 ff 12 00 00       	call   101f20 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c21:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100c27:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c2a:	2b 95 7c ff ff ff    	sub    -0x84(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c30:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c33:	f7 d0                	not    %eax
  100c35:	8d 04 82             	lea    (%edx,%eax,4),%eax

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c38:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c3e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c44:	89 d7                	mov    %edx,%edi
  100c46:	83 ef 01             	sub    $0x1,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c49:	8d 04 90             	lea    (%eax,%edx,4),%eax
  for(i=argc-1; i>=0; i--){
  100c4c:	83 ff ff             	cmp    $0xffffffff,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c4f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
  for(i=argc-1; i>=0; i--){
  100c56:	74 62                	je     100cba <exec+0x2da>
  100c58:	8b 75 0c             	mov    0xc(%ebp),%esi
  100c5b:	8d 04 bd 00 00 00 00 	lea    0x0(,%edi,4),%eax
  100c62:	89 ca                	mov    %ecx,%edx
  100c64:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100c67:	01 c6                	add    %eax,%esi
  100c69:	03 85 7c ff ff ff    	add    -0x84(%ebp),%eax
  100c6f:	01 c2                	add    %eax,%edx
  100c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    len = strlen(argv[i]) + 1;
  100c78:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c7a:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
  100c7d:	89 04 24             	mov    %eax,(%esp)
  100c80:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  100c86:	e8 f5 3c 00 00       	call   104980 <strlen>
    sp -= len;
  100c8b:	83 c0 01             	add    $0x1,%eax
  100c8e:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100c90:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c94:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c96:	83 ee 04             	sub    $0x4,%esi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c9d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  100ca0:	01 d8                	add    %ebx,%eax
  100ca2:	89 04 24             	mov    %eax,(%esp)
  100ca5:	e8 86 3b 00 00       	call   104830 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100caa:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  100cb0:	89 1a                	mov    %ebx,(%edx)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100cb2:	83 ea 04             	sub    $0x4,%edx
  100cb5:	83 ff ff             	cmp    $0xffffffff,%edi
  100cb8:	75 be                	jne    100c78 <exec+0x298>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100cba:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100cc0:	8b 55 84             	mov    -0x7c(%ebp),%edx
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100cc3:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  sp -= 4;
  100cc9:	89 c6                	mov    %eax,%esi
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100ccb:	89 44 02 fc          	mov    %eax,-0x4(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  100ccf:	83 ee 0c             	sub    $0xc,%esi
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100cd2:	89 4c 02 f8          	mov    %ecx,-0x8(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100cd6:	c7 44 02 f4 ff ff ff 	movl   $0xffffffff,-0xc(%edx,%eax,1)
  100cdd:	ff 

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100cde:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce1:	0f b6 10             	movzbl (%eax),%edx
  100ce4:	89 c3                	mov    %eax,%ebx
  100ce6:	84 d2                	test   %dl,%dl
  100ce8:	74 21                	je     100d0b <exec+0x32b>
  100cea:	83 c0 01             	add    $0x1,%eax
  100ced:	eb 0b                	jmp    100cfa <exec+0x31a>
  100cef:	90                   	nop
  100cf0:	0f b6 10             	movzbl (%eax),%edx
  100cf3:	83 c0 01             	add    $0x1,%eax
  100cf6:	84 d2                	test   %dl,%dl
  100cf8:	74 11                	je     100d0b <exec+0x32b>
    if(*s == '/')
  100cfa:	80 fa 2f             	cmp    $0x2f,%dl
  100cfd:	75 f1                	jne    100cf0 <exec+0x310>
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100cff:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
  100d02:	89 c3                	mov    %eax,%ebx
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100d04:	83 c0 01             	add    $0x1,%eax
  100d07:	84 d2                	test   %dl,%dl
  100d09:	75 ef                	jne    100cfa <exec+0x31a>
    if(*s == '/')
      last = s+1;
  safestrcpy(cp->name, last, sizeof(cp->name));
  100d0b:	e8 e0 29 00 00       	call   1036f0 <curproc>
  100d10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d14:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d1b:	00 
  100d1c:	05 88 00 00 00       	add    $0x88,%eax
  100d21:	89 04 24             	mov    %eax,(%esp)
  100d24:	e8 17 3c 00 00       	call   104940 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100d29:	e8 c2 29 00 00       	call   1036f0 <curproc>
  100d2e:	8b 58 04             	mov    0x4(%eax),%ebx
  100d31:	e8 ba 29 00 00       	call   1036f0 <curproc>
  100d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d3a:	8b 00                	mov    (%eax),%eax
  100d3c:	89 04 24             	mov    %eax,(%esp)
  100d3f:	e8 4c 19 00 00       	call   102690 <kfree>
  cp->mem = mem;
  100d44:	e8 a7 29 00 00       	call   1036f0 <curproc>
  100d49:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d4c:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100d4e:	e8 9d 29 00 00       	call   1036f0 <curproc>
  100d53:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100d56:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d59:	e8 92 29 00 00       	call   1036f0 <curproc>
  100d5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100d61:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d67:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100d6a:	e8 81 29 00 00       	call   1036f0 <curproc>
  100d6f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d75:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d78:	e8 73 29 00 00       	call   1036f0 <curproc>
  100d7d:	89 04 24             	mov    %eax,(%esp)
  100d80:	e8 3b 2f 00 00       	call   103cc0 <setupsegs>
  100d85:	31 c0                	xor    %eax,%eax
 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  return -1;
}
  100d87:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  100d8d:	5b                   	pop    %ebx
  100d8e:	5e                   	pop    %esi
  100d8f:	5f                   	pop    %edi
  100d90:	5d                   	pop    %ebp
  100d91:	c3                   	ret    
  100d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  setupsegs(cp);
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100d98:	8b 45 80             	mov    -0x80(%ebp),%eax
  100d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d9f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100da2:	89 14 24             	mov    %edx,(%esp)
  100da5:	e8 e6 18 00 00       	call   102690 <kfree>
  iunlockput(ip);
  100daa:	89 1c 24             	mov    %ebx,(%esp)
  100dad:	e8 6e 11 00 00       	call   101f20 <iunlockput>
  return -1;
}
  100db2:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  100dbd:	5b                   	pop    %ebx
  100dbe:	5e                   	pop    %esi
  100dbf:	5f                   	pop    %edi
  100dc0:	5d                   	pop    %ebp
  100dc1:	c3                   	ret    
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100dc2:	b8 04 00 00 00       	mov    $0x4,%eax
  100dc7:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100dce:	00 00 00 
  100dd1:	c7 85 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebp)
  100dd8:	00 00 00 
  100ddb:	e9 43 fd ff ff       	jmp    100b23 <exec+0x143>

00100de0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 38             	sub    $0x38,%esp
  100de6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100dec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100def:	8b 75 0c             	mov    0xc(%ebp),%esi
  100df2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100df5:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->writable == 0)
  100df8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100dfc:	74 5a                	je     100e58 <filewrite+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100dfe:	8b 03                	mov    (%ebx),%eax
  100e00:	83 f8 02             	cmp    $0x2,%eax
  100e03:	74 5b                	je     100e60 <filewrite+0x80>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100e05:	83 f8 03             	cmp    $0x3,%eax
  100e08:	75 6d                	jne    100e77 <filewrite+0x97>
    ilock(f->ip);
  100e0a:	8b 43 10             	mov    0x10(%ebx),%eax
  100e0d:	89 04 24             	mov    %eax,(%esp)
  100e10:	e8 2b 11 00 00       	call   101f40 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e19:	8b 43 14             	mov    0x14(%ebx),%eax
  100e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e24:	8b 43 10             	mov    0x10(%ebx),%eax
  100e27:	89 04 24             	mov    %eax,(%esp)
  100e2a:	e8 81 09 00 00       	call   1017b0 <writei>
  100e2f:	85 c0                	test   %eax,%eax
  100e31:	7e 03                	jle    100e36 <filewrite+0x56>
      f->off += r;
  100e33:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e36:	8b 53 10             	mov    0x10(%ebx),%edx
  100e39:	89 14 24             	mov    %edx,(%esp)
  100e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100e3f:	e8 8c 10 00 00       	call   101ed0 <iunlock>
    return r;
  100e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("filewrite");
}
  100e47:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e4a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e4d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e50:	89 ec                	mov    %ebp,%esp
  100e52:	5d                   	pop    %ebp
  100e53:	c3                   	ret    
  100e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e5d:	eb e8                	jmp    100e47 <filewrite+0x67>
  100e5f:	90                   	nop
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e60:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e6c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e6f:	89 ec                	mov    %ebp,%esp
  100e71:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e72:	e9 39 23 00 00       	jmp    1031b0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e77:	c7 04 24 4a 69 10 00 	movl   $0x10694a,(%esp)
  100e7e:	e8 dd fa ff ff       	call   100960 <panic>
  100e83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100e90 <filecheck>:
}

// Check if file exists in cache buffer.
int
filecheck(struct file *f, int offset)
{
  100e90:	55                   	push   %ebp
  100e91:	89 e5                	mov    %esp,%ebp
  100e93:	83 ec 18             	sub    $0x18,%esp
  100e96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  100e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100e9c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int r;

  if(f->readable == 0)
  100e9f:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100ea3:	74 3b                	je     100ee0 <filecheck+0x50>
    return -1;
  if(f->type == FD_INODE){
  100ea5:	83 3b 03             	cmpl   $0x3,(%ebx)
  100ea8:	75 47                	jne    100ef1 <filecheck+0x61>
    ilock(f->ip);
  100eaa:	8b 43 10             	mov    0x10(%ebx),%eax
  100ead:	89 04 24             	mov    %eax,(%esp)
  100eb0:	e8 8b 10 00 00       	call   101f40 <ilock>
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
  100eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ebc:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebf:	89 04 24             	mov    %eax,(%esp)
  100ec2:	e8 49 0b 00 00       	call   101a10 <checki>
  100ec7:	89 c6                	mov    %eax,%esi
    iunlock(f->ip);
  100ec9:	8b 43 10             	mov    0x10(%ebx),%eax
  100ecc:	89 04 24             	mov    %eax,(%esp)
  100ecf:	e8 fc 0f 00 00       	call   101ed0 <iunlock>
    return r;
  }
  panic("filecheck");
}
  100ed4:	89 f0                	mov    %esi,%eax
  100ed6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100ed9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100edc:	89 ec                	mov    %ebp,%esp
  100ede:	5d                   	pop    %ebp
  100edf:	c3                   	ret    
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
    iunlock(f->ip);
    return r;
  }
  panic("filecheck");
  100ee0:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
  100ee5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100ee8:	89 f0                	mov    %esi,%eax
  100eea:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100eed:	89 ec                	mov    %ebp,%esp
  100eef:	5d                   	pop    %ebp
  100ef0:	c3                   	ret    
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
    iunlock(f->ip);
    return r;
  }
  panic("filecheck");
  100ef1:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  100ef8:	e8 63 fa ff ff       	call   100960 <panic>
  100efd:	8d 76 00             	lea    0x0(%esi),%esi

00100f00 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100f00:	55                   	push   %ebp
  100f01:	89 e5                	mov    %esp,%ebp
  100f03:	83 ec 38             	sub    $0x38,%esp
  100f06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100f0f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100f12:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100f15:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
  100f18:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100f1c:	74 5a                	je     100f78 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100f1e:	8b 03                	mov    (%ebx),%eax
  100f20:	83 f8 02             	cmp    $0x2,%eax
  100f23:	74 5b                	je     100f80 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100f25:	83 f8 03             	cmp    $0x3,%eax
  100f28:	75 6d                	jne    100f97 <fileread+0x97>
    ilock(f->ip);
  100f2a:	8b 43 10             	mov    0x10(%ebx),%eax
  100f2d:	89 04 24             	mov    %eax,(%esp)
  100f30:	e8 0b 10 00 00       	call   101f40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100f35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100f39:	8b 43 14             	mov    0x14(%ebx),%eax
  100f3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f44:	8b 43 10             	mov    0x10(%ebx),%eax
  100f47:	89 04 24             	mov    %eax,(%esp)
  100f4a:	e8 c1 06 00 00       	call   101610 <readi>
  100f4f:	85 c0                	test   %eax,%eax
  100f51:	7e 03                	jle    100f56 <fileread+0x56>
      f->off += r;
  100f53:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100f56:	8b 53 10             	mov    0x10(%ebx),%edx
  100f59:	89 14 24             	mov    %edx,(%esp)
  100f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100f5f:	e8 6c 0f 00 00       	call   101ed0 <iunlock>
    return r;
  100f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
  100f67:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f6a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f6d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100f70:	89 ec                	mov    %ebp,%esp
  100f72:	5d                   	pop    %ebp
  100f73:	c3                   	ret    
  100f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100f7d:	eb e8                	jmp    100f67 <fileread+0x67>
  100f7f:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100f80:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f89:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100f8c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100f8f:	89 ec                	mov    %ebp,%esp
  100f91:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100f92:	e9 39 21 00 00       	jmp    1030d0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f97:	c7 04 24 5e 69 10 00 	movl   $0x10695e,(%esp)
  100f9e:	e8 bd f9 ff ff       	call   100960 <panic>
  100fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100fb0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100fb0:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100fb6:	89 e5                	mov    %esp,%ebp
  100fb8:	53                   	push   %ebx
  100fb9:	83 ec 14             	sub    $0x14,%esp
  100fbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100fbf:	83 3b 03             	cmpl   $0x3,(%ebx)
  100fc2:	74 0c                	je     100fd0 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100fc4:	83 c4 14             	add    $0x14,%esp
  100fc7:	5b                   	pop    %ebx
  100fc8:	5d                   	pop    %ebp
  100fc9:	c3                   	ret    
  100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100fd0:	8b 43 10             	mov    0x10(%ebx),%eax
  100fd3:	89 04 24             	mov    %eax,(%esp)
  100fd6:	e8 65 0f 00 00       	call   101f40 <ilock>
    stati(f->ip, st);
  100fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fe2:	8b 43 10             	mov    0x10(%ebx),%eax
  100fe5:	89 04 24             	mov    %eax,(%esp)
  100fe8:	e8 f3 01 00 00       	call   1011e0 <stati>
    iunlock(f->ip);
  100fed:	8b 43 10             	mov    0x10(%ebx),%eax
  100ff0:	89 04 24             	mov    %eax,(%esp)
  100ff3:	e8 d8 0e 00 00       	call   101ed0 <iunlock>
    return 0;
  }
  return -1;
}
  100ff8:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  100ffb:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  100ffd:	5b                   	pop    %ebx
  100ffe:	5d                   	pop    %ebp
  100fff:	c3                   	ret    

00101000 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  101000:	55                   	push   %ebp
  101001:	89 e5                	mov    %esp,%ebp
  101003:	53                   	push   %ebx
  101004:	83 ec 14             	sub    $0x14,%esp
  101007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&file_table_lock);
  10100a:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  101011:	e8 1a 37 00 00       	call   104730 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  101016:	8b 43 04             	mov    0x4(%ebx),%eax
  101019:	85 c0                	test   %eax,%eax
  10101b:	7e 20                	jle    10103d <filedup+0x3d>
  10101d:	8b 13                	mov    (%ebx),%edx
  10101f:	85 d2                	test   %edx,%edx
  101021:	74 1a                	je     10103d <filedup+0x3d>
    panic("filedup");
  f->ref++;
  101023:	83 c0 01             	add    $0x1,%eax
  101026:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  101029:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  101030:	e8 bb 36 00 00       	call   1046f0 <release>
  return f;
}
  101035:	89 d8                	mov    %ebx,%eax
  101037:	83 c4 14             	add    $0x14,%esp
  10103a:	5b                   	pop    %ebx
  10103b:	5d                   	pop    %ebp
  10103c:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("filedup");
  10103d:	c7 04 24 67 69 10 00 	movl   $0x106967,(%esp)
  101044:	e8 17 f9 ff ff       	call   100960 <panic>
  101049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101050 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  101050:	55                   	push   %ebp
  101051:	89 e5                	mov    %esp,%ebp
  101053:	53                   	push   %ebx
  101054:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&file_table_lock);
  101057:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10105e:	e8 cd 36 00 00       	call   104730 <acquire>
  101063:	ba 00 a1 10 00       	mov    $0x10a100,%edx
  101068:	31 c0                	xor    %eax,%eax
  10106a:	eb 0f                	jmp    10107b <filealloc+0x2b>
  10106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NFILE; i++){
  101070:	83 c0 01             	add    $0x1,%eax
  101073:	83 c2 18             	add    $0x18,%edx
  101076:	83 f8 64             	cmp    $0x64,%eax
  101079:	74 45                	je     1010c0 <filealloc+0x70>
    if(file[i].type == FD_CLOSED){
  10107b:	8b 0a                	mov    (%edx),%ecx
  10107d:	85 c9                	test   %ecx,%ecx
  10107f:	75 ef                	jne    101070 <filealloc+0x20>
      file[i].type = FD_NONE;
  101081:	8d 14 40             	lea    (%eax,%eax,2),%edx
  101084:	8d 1c d5 00 00 00 00 	lea    0x0(,%edx,8),%ebx
      file[i].ref = 1;
      release(&file_table_lock);
  10108b:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  101092:	c7 04 d5 00 a1 10 00 	movl   $0x1,0x10a100(,%edx,8)
  101099:	01 00 00 00 
      file[i].ref = 1;
  10109d:	c7 04 d5 04 a1 10 00 	movl   $0x1,0x10a104(,%edx,8)
  1010a4:	01 00 00 00 
      release(&file_table_lock);
  1010a8:	e8 43 36 00 00       	call   1046f0 <release>
      return file + i;
  1010ad:	8d 83 00 a1 10 00    	lea    0x10a100(%ebx),%eax
    }
  }
  release(&file_table_lock);
  return 0;
}
  1010b3:	83 c4 14             	add    $0x14,%esp
  1010b6:	5b                   	pop    %ebx
  1010b7:	5d                   	pop    %ebp
  1010b8:	c3                   	ret    
  1010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  1010c0:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1010c7:	e8 24 36 00 00       	call   1046f0 <release>
  return 0;
}
  1010cc:	83 c4 14             	add    $0x14,%esp
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  1010cf:	31 c0                	xor    %eax,%eax
  return 0;
}
  1010d1:	5b                   	pop    %ebx
  1010d2:	5d                   	pop    %ebp
  1010d3:	c3                   	ret    
  1010d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001010e0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  1010e0:	55                   	push   %ebp
  1010e1:	89 e5                	mov    %esp,%ebp
  1010e3:	83 ec 38             	sub    $0x38,%esp
  1010e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1010e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1010ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1010ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&file_table_lock);
  1010f2:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1010f9:	e8 32 36 00 00       	call   104730 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  1010fe:	8b 43 04             	mov    0x4(%ebx),%eax
  101101:	85 c0                	test   %eax,%eax
  101103:	0f 8e 9f 00 00 00    	jle    1011a8 <fileclose+0xc8>
  101109:	8b 33                	mov    (%ebx),%esi
  10110b:	85 f6                	test   %esi,%esi
  10110d:	0f 84 95 00 00 00    	je     1011a8 <fileclose+0xc8>
    panic("fileclose");
  if(--f->ref > 0){
  101113:	83 e8 01             	sub    $0x1,%eax
  101116:	85 c0                	test   %eax,%eax
  101118:	89 43 04             	mov    %eax,0x4(%ebx)
  10111b:	74 1b                	je     101138 <fileclose+0x58>
    release(&file_table_lock);
  10111d:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  101124:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101127:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10112a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10112d:	89 ec                	mov    %ebp,%esp
  10112f:	5d                   	pop    %ebp

  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
  101130:	e9 bb 35 00 00       	jmp    1046f0 <release>
  101135:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }
  ff = *f;
  101138:	8b 43 0c             	mov    0xc(%ebx),%eax
  10113b:	8b 33                	mov    (%ebx),%esi
  10113d:	8b 7b 10             	mov    0x10(%ebx),%edi
  f->ref = 0;
  101140:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101147:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10114a:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_CLOSED;
  10114e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101154:	88 45 e7             	mov    %al,-0x19(%ebp)
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  101157:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10115e:	e8 8d 35 00 00       	call   1046f0 <release>
  
  if(ff.type == FD_PIPE)
  101163:	83 fe 02             	cmp    $0x2,%esi
  101166:	74 20                	je     101188 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  101168:	83 fe 03             	cmp    $0x3,%esi
  10116b:	75 3b                	jne    1011a8 <fileclose+0xc8>
    iput(ff.ip);
  10116d:	89 7d 08             	mov    %edi,0x8(%ebp)
  else
    panic("fileclose");
}
  101170:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101173:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101176:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101179:	89 ec                	mov    %ebp,%esp
  10117b:	5d                   	pop    %ebp
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  10117c:	e9 6f 0a 00 00       	jmp    101bf0 <iput>
  101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  101188:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  10118c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101193:	89 04 24             	mov    %eax,(%esp)
  101196:	e8 15 21 00 00       	call   1032b0 <pipeclose>
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  10119b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10119e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1011a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1011a4:	89 ec                	mov    %ebp,%esp
  1011a6:	5d                   	pop    %ebp
  1011a7:	c3                   	ret    
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  1011a8:	c7 04 24 6f 69 10 00 	movl   $0x10696f,(%esp)
  1011af:	e8 ac f7 ff ff       	call   100960 <panic>
  1011b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1011ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001011c0 <fileinit>:
struct spinlock file_table_lock;
struct file file[NFILE];

void
fileinit(void)
{
  1011c0:	55                   	push   %ebp
  1011c1:	89 e5                	mov    %esp,%ebp
  1011c3:	83 ec 18             	sub    $0x18,%esp
  initlock(&file_table_lock, "file_table");
  1011c6:	c7 44 24 04 79 69 10 	movl   $0x106979,0x4(%esp)
  1011cd:	00 
  1011ce:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1011d5:	e8 96 33 00 00       	call   104570 <initlock>
}
  1011da:	c9                   	leave  
  1011db:	c3                   	ret    
  1011dc:	90                   	nop
  1011dd:	90                   	nop
  1011de:	90                   	nop
  1011df:	90                   	nop

001011e0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  1011e0:	55                   	push   %ebp
  1011e1:	89 e5                	mov    %esp,%ebp
  1011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
  1011e9:	8b 0a                	mov    (%edx),%ecx
  1011eb:	89 08                	mov    %ecx,(%eax)
  st->ino = ip->inum;
  1011ed:	8b 4a 04             	mov    0x4(%edx),%ecx
  1011f0:	89 48 04             	mov    %ecx,0x4(%eax)
  st->type = ip->type;
  1011f3:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
  1011f7:	66 89 48 08          	mov    %cx,0x8(%eax)
  st->nlink = ip->nlink;
  1011fb:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
  st->size = ip->size;
  1011ff:	8b 52 18             	mov    0x18(%edx),%edx
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  101202:	66 89 48 0a          	mov    %cx,0xa(%eax)
  st->size = ip->size;
  101206:	89 50 0c             	mov    %edx,0xc(%eax)
}
  101209:	5d                   	pop    %ebp
  10120a:	c3                   	ret    
  10120b:	90                   	nop
  10120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101210 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101210:	55                   	push   %ebp
  101211:	89 e5                	mov    %esp,%ebp
  101213:	53                   	push   %ebx
  101214:	83 ec 14             	sub    $0x14,%esp
  101217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10121a:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101221:	e8 0a 35 00 00       	call   104730 <acquire>
  ip->ref++;
  101226:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10122a:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101231:	e8 ba 34 00 00       	call   1046f0 <release>
  return ip;
}
  101236:	89 d8                	mov    %ebx,%eax
  101238:	83 c4 14             	add    $0x14,%esp
  10123b:	5b                   	pop    %ebx
  10123c:	5d                   	pop    %ebp
  10123d:	c3                   	ret    
  10123e:	66 90                	xchg   %ax,%ax

00101240 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101240:	55                   	push   %ebp
  101241:	89 e5                	mov    %esp,%ebp
  101243:	57                   	push   %edi
  101244:	89 d7                	mov    %edx,%edi
  101246:	56                   	push   %esi
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  101247:	31 f6                	xor    %esi,%esi
{
  101249:	53                   	push   %ebx
  10124a:	89 c3                	mov    %eax,%ebx
  10124c:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
  10124f:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101256:	e8 d5 34 00 00       	call   104730 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10125b:	b8 34 ab 10 00       	mov    $0x10ab34,%eax
  101260:	eb 14                	jmp    101276 <iget+0x36>
  101262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101268:	85 f6                	test   %esi,%esi
  10126a:	74 3c                	je     1012a8 <iget+0x68>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  10126c:	83 c0 50             	add    $0x50,%eax
  10126f:	3d d4 ba 10 00       	cmp    $0x10bad4,%eax
  101274:	74 42                	je     1012b8 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  101276:	8b 48 08             	mov    0x8(%eax),%ecx
  101279:	85 c9                	test   %ecx,%ecx
  10127b:	7e eb                	jle    101268 <iget+0x28>
  10127d:	39 18                	cmp    %ebx,(%eax)
  10127f:	75 e7                	jne    101268 <iget+0x28>
  101281:	39 78 04             	cmp    %edi,0x4(%eax)
  101284:	75 e2                	jne    101268 <iget+0x28>
      ip->ref++;
  101286:	83 c1 01             	add    $0x1,%ecx
  101289:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
  10128c:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101296:	e8 55 34 00 00       	call   1046f0 <release>
      return ip;
  10129b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  10129e:	83 c4 2c             	add    $0x2c,%esp
  1012a1:	5b                   	pop    %ebx
  1012a2:	5e                   	pop    %esi
  1012a3:	5f                   	pop    %edi
  1012a4:	5d                   	pop    %ebp
  1012a5:	c3                   	ret    
  1012a6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1012a8:	85 c9                	test   %ecx,%ecx
  1012aa:	75 c0                	jne    10126c <iget+0x2c>
  1012ac:	89 c6                	mov    %eax,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1012ae:	83 c0 50             	add    $0x50,%eax
  1012b1:	3d d4 ba 10 00       	cmp    $0x10bad4,%eax
  1012b6:	75 be                	jne    101276 <iget+0x36>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  1012b8:	85 f6                	test   %esi,%esi
  1012ba:	74 29                	je     1012e5 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  1012bc:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
  1012be:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
  1012c1:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  1012c8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
  1012cf:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  1012d6:	e8 15 34 00 00       	call   1046f0 <release>

  return ip;
}
  1012db:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  1012de:	89 f0                	mov    %esi,%eax

  return ip;
}
  1012e0:	5b                   	pop    %ebx
  1012e1:	5e                   	pop    %esi
  1012e2:	5f                   	pop    %edi
  1012e3:	5d                   	pop    %ebp
  1012e4:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  1012e5:	c7 04 24 84 69 10 00 	movl   $0x106984,(%esp)
  1012ec:	e8 6f f6 ff ff       	call   100960 <panic>
  1012f1:	eb 0d                	jmp    101300 <readsb>
  1012f3:	90                   	nop
  1012f4:	90                   	nop
  1012f5:	90                   	nop
  1012f6:	90                   	nop
  1012f7:	90                   	nop
  1012f8:	90                   	nop
  1012f9:	90                   	nop
  1012fa:	90                   	nop
  1012fb:	90                   	nop
  1012fc:	90                   	nop
  1012fd:	90                   	nop
  1012fe:	90                   	nop
  1012ff:	90                   	nop

00101300 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101300:	55                   	push   %ebp
  101301:	89 e5                	mov    %esp,%ebp
  101303:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101306:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10130d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10130e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101311:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101314:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101316:	89 04 24             	mov    %eax,(%esp)
  101319:	e8 12 ee ff ff       	call   100130 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10131e:	89 34 24             	mov    %esi,(%esp)
  101321:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101328:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101329:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10132b:	8d 40 18             	lea    0x18(%eax),%eax
  10132e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101332:	e8 f9 34 00 00       	call   104830 <memmove>
  brelse(bp);
  101337:	89 1c 24             	mov    %ebx,(%esp)
  10133a:	e8 c1 ec ff ff       	call   100000 <brelse>
}
  10133f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  101342:	8b 75 fc             	mov    -0x4(%ebp),%esi
  101345:	89 ec                	mov    %ebp,%esp
  101347:	5d                   	pop    %ebp
  101348:	c3                   	ret    
  101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101350 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101350:	55                   	push   %ebp
  101351:	89 e5                	mov    %esp,%ebp
  101353:	57                   	push   %edi
  101354:	56                   	push   %esi
  101355:	53                   	push   %ebx
  101356:	83 ec 3c             	sub    $0x3c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101359:	8d 55 dc             	lea    -0x24(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  10135c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  10135f:	e8 9c ff ff ff       	call   101300 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101364:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101367:	85 c0                	test   %eax,%eax
  101369:	0f 84 9c 00 00 00    	je     10140b <balloc+0xbb>
  10136f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101379:	31 db                	xor    %ebx,%ebx
  10137b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10137e:	c1 e8 03             	shr    $0x3,%eax
  101381:	c1 fa 0c             	sar    $0xc,%edx
  101384:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101388:	89 44 24 04          	mov    %eax,0x4(%esp)
  10138c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10138f:	89 04 24             	mov    %eax,(%esp)
  101392:	e8 99 ed ff ff       	call   100130 <bread>
  101397:	89 c6                	mov    %eax,%esi
  101399:	eb 10                	jmp    1013ab <balloc+0x5b>
  10139b:	90                   	nop
  10139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  1013a0:	83 c3 01             	add    $0x1,%ebx
  1013a3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  1013a9:	74 45                	je     1013f0 <balloc+0xa0>
      m = 1 << (bi % 8);
  1013ab:	89 d9                	mov    %ebx,%ecx
  1013ad:	ba 01 00 00 00       	mov    $0x1,%edx
  1013b2:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013b5:	89 d8                	mov    %ebx,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1013b7:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013b9:	c1 f8 03             	sar    $0x3,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1013bc:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013be:	0f b6 54 06 18       	movzbl 0x18(%esi,%eax,1),%edx
  1013c3:	0f b6 fa             	movzbl %dl,%edi
  1013c6:	85 cf                	test   %ecx,%edi
  1013c8:	75 d6                	jne    1013a0 <balloc+0x50>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1013ca:	09 d1                	or     %edx,%ecx
  1013cc:	88 4c 06 18          	mov    %cl,0x18(%esi,%eax,1)
        bwrite(bp);
  1013d0:	89 34 24             	mov    %esi,(%esp)
  1013d3:	e8 28 ed ff ff       	call   100100 <bwrite>
        brelse(bp);
  1013d8:	89 34 24             	mov    %esi,(%esp)
  1013db:	e8 20 ec ff ff       	call   100000 <brelse>
  1013e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013e3:	83 c4 3c             	add    $0x3c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1013e6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013e9:	5b                   	pop    %ebx
  1013ea:	5e                   	pop    %esi
  1013eb:	5f                   	pop    %edi
  1013ec:	5d                   	pop    %ebp
  1013ed:	c3                   	ret    
  1013ee:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1013f0:	89 34 24             	mov    %esi,(%esp)
  1013f3:	e8 08 ec ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1013f8:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  1013ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  101402:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101405:	0f 87 6b ff ff ff    	ja     101376 <balloc+0x26>
      }
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
  10140b:	c7 04 24 94 69 10 00 	movl   $0x106994,(%esp)
  101412:	e8 49 f5 ff ff       	call   100960 <panic>
  101417:	89 f6                	mov    %esi,%esi
  101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101420:	55                   	push   %ebp
  101421:	89 e5                	mov    %esp,%ebp
  101423:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101426:	83 fa 0a             	cmp    $0xa,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101429:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10142c:	89 c3                	mov    %eax,%ebx
  10142e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101431:	89 ce                	mov    %ecx,%esi
  101433:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101436:	77 28                	ja     101460 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
  101438:	8d 7a 04             	lea    0x4(%edx),%edi
  10143b:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
  10143f:	85 c0                	test   %eax,%eax
  101441:	75 0d                	jne    101450 <bmap+0x30>
      if(!alloc)
  101443:	85 c9                	test   %ecx,%ecx
  101445:	0f 85 e5 00 00 00    	jne    101530 <bmap+0x110>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  10144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101450:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101453:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101456:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101459:	89 ec                	mov    %ebp,%esp
  10145b:	5d                   	pop    %ebp
  10145c:	c3                   	ret    
  10145d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101460:	8d 4a f5             	lea    -0xb(%edx),%ecx

  //check indirect
  if(bn < NINDIRECT){
  101463:	83 f9 7f             	cmp    $0x7f,%ecx
  101466:	76 68                	jbe    1014d0 <bmap+0xb0>
    return addr;
  }

  //NEW CODE
  //decrement block number for new reference
  bn -= NINDIRECT;
  101468:	8d ba 75 ff ff ff    	lea    -0x8b(%edx),%edi


  //DOUBLE INDIRECT
  if(bn < NDINDIRECT){
  10146e:	81 ff ff 3f 00 00    	cmp    $0x3fff,%edi
  101474:	0f 87 86 01 00 00    	ja     101600 <bmap+0x1e0>

	  //cprintf("bn is %d\n", bn);

	  if((addr = ip->addrs[DINDIRECT]) == 0){
  10147a:	8b 40 4c             	mov    0x4c(%eax),%eax
  10147d:	85 c0                	test   %eax,%eax
  10147f:	75 0e                	jne    10148f <bmap+0x6f>
	     if(!alloc)
  101481:	85 f6                	test   %esi,%esi
  101483:	74 c6                	je     10144b <bmap+0x2b>
	        return -1;
	     ip->addrs[DINDIRECT] = addr = balloc(ip->dev);
  101485:	8b 03                	mov    (%ebx),%eax
  101487:	e8 c4 fe ff ff       	call   101350 <balloc>
  10148c:	89 43 4c             	mov    %eax,0x4c(%ebx)
	  }
	  bp = bread(ip->dev, addr);
  10148f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101493:	8b 03                	mov    (%ebx),%eax
  101495:	89 04 24             	mov    %eax,(%esp)
  101498:	e8 93 ec ff ff       	call   100130 <bread>
  10149d:	89 c2                	mov    %eax,%edx
	  //calculate base and offset indirect block in double indirect block
	  uint base = bn / NINDIRECT;
	  uint offset = bn % NINDIRECT;

	  //grab indirect block and allocate if necessary
	  if((addr = a[base]) == 0){
  10149f:	89 f8                	mov    %edi,%eax
  1014a1:	c1 e8 07             	shr    $0x7,%eax
  1014a4:	8d 4c 82 18          	lea    0x18(%edx,%eax,4),%ecx
  1014a8:	8b 01                	mov    (%ecx),%eax
  1014aa:	85 c0                	test   %eax,%eax
  1014ac:	0f 85 b4 00 00 00    	jne    101566 <bmap+0x146>
	        if(!alloc){
  1014b2:	85 f6                	test   %esi,%esi
  1014b4:	0f 85 86 00 00 00    	jne    101540 <bmap+0x120>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
	        if(!alloc){
	          brelse(bp);
  1014ba:	89 14 24             	mov    %edx,(%esp)
  1014bd:	e8 3e eb ff ff       	call   100000 <brelse>
  1014c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	          return -1;
  1014c7:	eb 87                	jmp    101450 <bmap+0x30>
  1014c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  //check indirect
  if(bn < NINDIRECT){

    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  1014d0:	8b 40 48             	mov    0x48(%eax),%eax
  1014d3:	85 c0                	test   %eax,%eax
  1014d5:	75 18                	jne    1014ef <bmap+0xcf>
      if(!alloc)
  1014d7:	85 f6                	test   %esi,%esi
  1014d9:	0f 84 6c ff ff ff    	je     10144b <bmap+0x2b>
        return -1;
      //cprintf("allocating indirect block %d in indirect\n", bn);
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  1014df:	8b 03                	mov    (%ebx),%eax
  1014e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1014e4:	e8 67 fe ff ff       	call   101350 <balloc>
  1014e9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1014ec:	89 43 48             	mov    %eax,0x48(%ebx)
    }
    bp = bread(ip->dev, addr);
  1014ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014f3:	8b 03                	mov    (%ebx),%eax
  1014f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1014f8:	89 04 24             	mov    %eax,(%esp)
  1014fb:	e8 30 ec ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101500:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  101503:	8d 54 88 18          	lea    0x18(%eax,%ecx,4),%edx
      if(!alloc)
        return -1;
      //cprintf("allocating indirect block %d in indirect\n", bn);
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  101507:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101509:	8b 02                	mov    (%edx),%eax
  10150b:	85 c0                	test   %eax,%eax
  10150d:	0f 85 da 00 00 00    	jne    1015ed <bmap+0x1cd>
      if(!alloc){
  101513:	85 f6                	test   %esi,%esi
  101515:	0f 85 b5 00 00 00    	jne    1015d0 <bmap+0x1b0>
        brelse(bp);
  10151b:	89 3c 24             	mov    %edi,(%esp)
  10151e:	e8 dd ea ff ff       	call   100000 <brelse>
  101523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        return -1;
  101528:	e9 23 ff ff ff       	jmp    101450 <bmap+0x30>
  10152d:	8d 76 00             	lea    0x0(%esi),%esi

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101530:	8b 03                	mov    (%ebx),%eax
  101532:	e8 19 fe ff ff       	call   101350 <balloc>
  101537:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  10153b:	e9 10 ff ff ff       	jmp    101450 <bmap+0x30>
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  101540:	8b 03                	mov    (%ebx),%eax
  101542:	89 55 e0             	mov    %edx,-0x20(%ebp)
  101545:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  101548:	e8 03 fe ff ff       	call   101350 <balloc>
  10154d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	        bwrite(bp);
  101550:	8b 55 e0             	mov    -0x20(%ebp),%edx
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  101553:	89 01                	mov    %eax,(%ecx)
	        bwrite(bp);
  101555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101558:	89 14 24             	mov    %edx,(%esp)
  10155b:	e8 a0 eb ff ff       	call   100100 <bwrite>
  101560:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	  }

	  brelse(bp);
  101566:	89 14 24             	mov    %edx,(%esp)
	  bp = bread(ip->dev, addr);
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101569:	83 e7 7f             	and    $0x7f,%edi
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
  10156c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10156f:	e8 8c ea ff ff       	call   100000 <brelse>
	  bp = bread(ip->dev, addr);
  101574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101577:	89 44 24 04          	mov    %eax,0x4(%esp)
  10157b:	8b 03                	mov    (%ebx),%eax
  10157d:	89 04 24             	mov    %eax,(%esp)
  101580:	e8 ab eb ff ff       	call   100130 <bread>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101585:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
	  bp = bread(ip->dev, addr);
  101589:	89 c2                	mov    %eax,%edx
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  10158b:	8b 07                	mov    (%edi),%eax
  10158d:	85 c0                	test   %eax,%eax
  10158f:	75 28                	jne    1015b9 <bmap+0x199>
	        if(!alloc){
  101591:	85 f6                	test   %esi,%esi
  101593:	0f 84 21 ff ff ff    	je     1014ba <bmap+0x9a>
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new data block with bn = %d\n", bn);
	        a[offset] = addr = balloc(ip->dev);
  101599:	8b 03                	mov    (%ebx),%eax
  10159b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10159e:	e8 ad fd ff ff       	call   101350 <balloc>
	        bwrite(bp);
  1015a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new data block with bn = %d\n", bn);
	        a[offset] = addr = balloc(ip->dev);
  1015a6:	89 07                	mov    %eax,(%edi)
	        bwrite(bp);
  1015a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1015ab:	89 14 24             	mov    %edx,(%esp)
  1015ae:	e8 4d eb ff ff       	call   100100 <bwrite>
  1015b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1015b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	  }
	  brelse(bp);
  1015b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1015bc:	89 14 24             	mov    %edx,(%esp)
  1015bf:	e8 3c ea ff ff       	call   100000 <brelse>
	  return addr;
  1015c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015c7:	e9 84 fe ff ff       	jmp    101450 <bmap+0x30>
  1015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(!alloc){
        brelse(bp);
        return -1;
      }
      //cprintf("allocating data block %d in indirect\n", bn);
      a[bn] = addr = balloc(ip->dev);
  1015d0:	8b 03                	mov    (%ebx),%eax
  1015d2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1015d5:	e8 76 fd ff ff       	call   101350 <balloc>
  1015da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1015dd:	89 02                	mov    %eax,(%edx)
      bwrite(bp);
  1015df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1015e2:	89 3c 24             	mov    %edi,(%esp)
  1015e5:	e8 16 eb ff ff       	call   100100 <bwrite>
  1015ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
  1015ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1015f0:	89 3c 24             	mov    %edi,(%esp)
  1015f3:	e8 08 ea ff ff       	call   100000 <brelse>
    return addr;
  1015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015fb:	e9 50 fe ff ff       	jmp    101450 <bmap+0x30>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  101600:	c7 04 24 aa 69 10 00 	movl   $0x1069aa,(%esp)
  101607:	e8 54 f3 ff ff       	call   100960 <panic>
  10160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101610 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
  101613:	83 ec 38             	sub    $0x38,%esp
  101616:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10161c:	8b 45 14             	mov    0x14(%ebp),%eax
  10161f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101622:	8b 75 10             	mov    0x10(%ebp),%esi
  101625:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101628:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10162b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101633:	74 1b                	je     101650 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101635:	8b 43 18             	mov    0x18(%ebx),%eax
  101638:	39 f0                	cmp    %esi,%eax
  10163a:	73 44                	jae    101680 <readi+0x70>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10163c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101641:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101644:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101647:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10164a:	89 ec                	mov    %ebp,%esp
  10164c:	5d                   	pop    %ebp
  10164d:	c3                   	ret    
  10164e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101650:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101654:	66 83 f8 09          	cmp    $0x9,%ax
  101658:	77 e2                	ja     10163c <readi+0x2c>
  10165a:	98                   	cwtl   
  10165b:	8b 04 c5 a0 aa 10 00 	mov    0x10aaa0(,%eax,8),%eax
  101662:	85 c0                	test   %eax,%eax
  101664:	74 d6                	je     10163c <readi+0x2c>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101666:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101669:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10166c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10166f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101672:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101675:	89 ec                	mov    %ebp,%esp
  101677:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101678:	ff e0                	jmp    *%eax
  10167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  101680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101683:	01 f2                	add    %esi,%edx
  101685:	72 b5                	jb     10163c <readi+0x2c>
    return -1;
  if(off + n > ip->size)
  101687:	39 d0                	cmp    %edx,%eax
  101689:	73 05                	jae    101690 <readi+0x80>
    n = ip->size - off;
  10168b:	29 f0                	sub    %esi,%eax
  10168d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101693:	85 d2                	test   %edx,%edx
  101695:	74 7e                	je     101715 <readi+0x105>
  101697:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
  10169e:	89 7d dc             	mov    %edi,-0x24(%ebp)
  1016a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016a8:	89 f2                	mov    %esi,%edx
  1016aa:	31 c9                	xor    %ecx,%ecx
  1016ac:	c1 ea 09             	shr    $0x9,%edx
  1016af:	89 d8                	mov    %ebx,%eax
  1016b1:	e8 6a fd ff ff       	call   101420 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016b6:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016bf:	8b 03                	mov    (%ebx),%eax
  1016c1:	89 04 24             	mov    %eax,(%esp)
  1016c4:	e8 67 ea ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1016cc:	2b 4d e0             	sub    -0x20(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1016d1:	89 f0                	mov    %esi,%eax
  1016d3:	25 ff 01 00 00       	and    $0x1ff,%eax
  1016d8:	29 c7                	sub    %eax,%edi
  1016da:	39 cf                	cmp    %ecx,%edi
  1016dc:	76 02                	jbe    1016e0 <readi+0xd0>
  1016de:	89 cf                	mov    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1016e0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016e4:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1016e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1016ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1016f1:	89 04 24             	mov    %eax,(%esp)
  1016f4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1016f7:	e8 34 31 00 00       	call   104830 <memmove>
    brelse(bp);
  1016fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1016ff:	89 14 24             	mov    %edx,(%esp)
  101702:	e8 f9 e8 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101707:	01 7d e0             	add    %edi,-0x20(%ebp)
  10170a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10170d:	01 7d dc             	add    %edi,-0x24(%ebp)
  101710:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101713:	77 93                	ja     1016a8 <readi+0x98>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101718:	e9 24 ff ff ff       	jmp    101641 <readi+0x31>
  10171d:	8d 76 00             	lea    0x0(%esi),%esi

00101720 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101720:	55                   	push   %ebp
  101721:	89 e5                	mov    %esp,%ebp
  101723:	56                   	push   %esi
  101724:	53                   	push   %ebx
  101725:	83 ec 10             	sub    $0x10,%esp
  101728:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10172b:	8b 43 04             	mov    0x4(%ebx),%eax
  10172e:	c1 e8 03             	shr    $0x3,%eax
  101731:	83 c0 02             	add    $0x2,%eax
  101734:	89 44 24 04          	mov    %eax,0x4(%esp)
  101738:	8b 03                	mov    (%ebx),%eax
  10173a:	89 04 24             	mov    %eax,(%esp)
  10173d:	e8 ee e9 ff ff       	call   100130 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  101742:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  101746:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101748:	8b 43 04             	mov    0x4(%ebx),%eax
  10174b:	83 e0 07             	and    $0x7,%eax
  10174e:	c1 e0 06             	shl    $0x6,%eax
  101751:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  101755:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  101758:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  10175c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  101760:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  101764:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  101768:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  10176c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  101770:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101773:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101776:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101779:	83 c0 0c             	add    $0xc,%eax
  10177c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101780:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101787:	00 
  101788:	89 04 24             	mov    %eax,(%esp)
  10178b:	e8 a0 30 00 00       	call   104830 <memmove>
  bwrite(bp);
  101790:	89 34 24             	mov    %esi,(%esp)
  101793:	e8 68 e9 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101798:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10179b:	83 c4 10             	add    $0x10,%esp
  10179e:	5b                   	pop    %ebx
  10179f:	5e                   	pop    %esi
  1017a0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  1017a1:	e9 5a e8 ff ff       	jmp    100000 <brelse>
  1017a6:	8d 76 00             	lea    0x0(%esi),%esi
  1017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001017b0 <writei>:
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1017b0:	55                   	push   %ebp
  1017b1:	89 e5                	mov    %esp,%ebp
  1017b3:	57                   	push   %edi
  1017b4:	56                   	push   %esi
  1017b5:	53                   	push   %ebx
  1017b6:	83 ec 2c             	sub    $0x2c,%esp
  1017b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1017bf:	8b 55 14             	mov    0x14(%ebp),%edx
  1017c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1017c5:	66 83 7e 10 03       	cmpw   $0x3,0x10(%esi)
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1017ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1017cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1017d0:	0f 84 c2 00 00 00    	je     101898 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  1017d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1017d9:	01 d8                	add    %ebx,%eax
  1017db:	0f 82 c1 00 00 00    	jb     1018a2 <writei+0xf2>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1017e1:	3d 00 16 81 00       	cmp    $0x811600,%eax
  1017e6:	76 0a                	jbe    1017f2 <writei+0x42>
    n = MAXFILE*BSIZE - off;
  1017e8:	c7 45 dc 00 16 81 00 	movl   $0x811600,-0x24(%ebp)
  1017ef:	29 5d dc             	sub    %ebx,-0x24(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1017f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1017f5:	85 c9                	test   %ecx,%ecx
  1017f7:	0f 84 8b 00 00 00    	je     101888 <writei+0xd8>
  1017fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  101804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101808:	89 da                	mov    %ebx,%edx
  10180a:	b9 01 00 00 00       	mov    $0x1,%ecx
  10180f:	c1 ea 09             	shr    $0x9,%edx
  101812:	89 f0                	mov    %esi,%eax
  101814:	e8 07 fc ff ff       	call   101420 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101819:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  10181e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101822:	8b 06                	mov    (%esi),%eax
  101824:	89 04 24             	mov    %eax,(%esp)
  101827:	e8 04 e9 ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  10182c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10182f:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101832:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  101834:	89 d8                	mov    %ebx,%eax
  101836:	25 ff 01 00 00       	and    $0x1ff,%eax
  10183b:	29 c7                	sub    %eax,%edi
  10183d:	39 cf                	cmp    %ecx,%edi
  10183f:	76 02                	jbe    101843 <writei+0x93>
  101841:	89 cf                	mov    %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
  101843:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101847:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10184a:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  10184e:	89 04 24             	mov    %eax,(%esp)
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101851:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101853:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  101857:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10185a:	e8 d1 2f 00 00       	call   104830 <memmove>
    bwrite(bp);
  10185f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101862:	89 14 24             	mov    %edx,(%esp)
  101865:	e8 96 e8 ff ff       	call   100100 <bwrite>
    brelse(bp);
  10186a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10186d:	89 14 24             	mov    %edx,(%esp)
  101870:	e8 8b e7 ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101875:	01 7d e4             	add    %edi,-0x1c(%ebp)
  101878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10187b:	01 7d e0             	add    %edi,-0x20(%ebp)
  10187e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101881:	77 85                	ja     101808 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101883:	3b 5e 18             	cmp    0x18(%esi),%ebx
  101886:	77 28                	ja     1018b0 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101888:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  10188b:	83 c4 2c             	add    $0x2c,%esp
  10188e:	5b                   	pop    %ebx
  10188f:	5e                   	pop    %esi
  101890:	5f                   	pop    %edi
  101891:	5d                   	pop    %ebp
  101892:	c3                   	ret    
  101893:	90                   	nop
  101894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101898:	0f b7 46 12          	movzwl 0x12(%esi),%eax
  10189c:	66 83 f8 09          	cmp    $0x9,%ax
  1018a0:	76 1b                	jbe    1018bd <writei+0x10d>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1018a2:	83 c4 2c             	add    $0x2c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1018a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1018aa:	5b                   	pop    %ebx
  1018ab:	5e                   	pop    %esi
  1018ac:	5f                   	pop    %edi
  1018ad:	5d                   	pop    %ebp
  1018ae:	c3                   	ret    
  1018af:	90                   	nop
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  1018b0:	89 5e 18             	mov    %ebx,0x18(%esi)
    iupdate(ip);
  1018b3:	89 34 24             	mov    %esi,(%esp)
  1018b6:	e8 65 fe ff ff       	call   101720 <iupdate>
  1018bb:	eb cb                	jmp    101888 <writei+0xd8>
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1018bd:	98                   	cwtl   
  1018be:	8b 04 c5 a4 aa 10 00 	mov    0x10aaa4(,%eax,8),%eax
  1018c5:	85 c0                	test   %eax,%eax
  1018c7:	74 d9                	je     1018a2 <writei+0xf2>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1018c9:	89 55 10             	mov    %edx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1018cc:	83 c4 2c             	add    $0x2c,%esp
  1018cf:	5b                   	pop    %ebx
  1018d0:	5e                   	pop    %esi
  1018d1:	5f                   	pop    %edi
  1018d2:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1018d3:	ff e0                	jmp    *%eax
  1018d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001018e0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  1018e0:	55                   	push   %ebp
  1018e1:	89 e5                	mov    %esp,%ebp
  1018e3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  1018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1018e9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1018f0:	00 
  1018f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f8:	89 04 24             	mov    %eax,(%esp)
  1018fb:	e8 90 2f 00 00       	call   104890 <strncmp>
}
  101900:	c9                   	leave  
  101901:	c3                   	ret    
  101902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101910 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101910:	55                   	push   %ebp
  101911:	89 e5                	mov    %esp,%ebp
  101913:	57                   	push   %edi
  101914:	56                   	push   %esi
  101915:	53                   	push   %ebx
  101916:	83 ec 3c             	sub    $0x3c,%esp
  101919:	8b 45 08             	mov    0x8(%ebp),%eax
  10191c:	8b 55 10             	mov    0x10(%ebp),%edx
  10191f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101922:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101927:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10192a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  10192d:	0f 85 d0 00 00 00    	jne    101a03 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101933:	8b 70 18             	mov    0x18(%eax),%esi
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101936:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10193d:	85 f6                	test   %esi,%esi
  10193f:	0f 84 b4 00 00 00    	je     1019f9 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101948:	31 c9                	xor    %ecx,%ecx
  10194a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10194d:	c1 ea 09             	shr    $0x9,%edx
  101950:	e8 cb fa ff ff       	call   101420 <bmap>
  101955:	89 44 24 04          	mov    %eax,0x4(%esp)
  101959:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10195c:	8b 01                	mov    (%ecx),%eax
  10195e:	89 04 24             	mov    %eax,(%esp)
  101961:	e8 ca e7 ff ff       	call   100130 <bread>
  101966:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101969:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  10196c:	83 c0 18             	add    $0x18,%eax
  10196f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101972:	89 c6                	mov    %eax,%esi

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101974:	81 c7 18 02 00 00    	add    $0x218,%edi
  10197a:	eb 0b                	jmp    101987 <dirlookup+0x77>
  10197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  101980:	83 c6 10             	add    $0x10,%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101983:	39 fe                	cmp    %edi,%esi
  101985:	74 51                	je     1019d8 <dirlookup+0xc8>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  101987:	66 83 3e 00          	cmpw   $0x0,(%esi)
  10198b:	74 f3                	je     101980 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  10198d:	8d 46 02             	lea    0x2(%esi),%eax
  101990:	89 44 24 04          	mov    %eax,0x4(%esp)
  101994:	89 1c 24             	mov    %ebx,(%esp)
  101997:	e8 44 ff ff ff       	call   1018e0 <namecmp>
  10199c:	85 c0                	test   %eax,%eax
  10199e:	75 e0                	jne    101980 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1019a0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1019a3:	85 db                	test   %ebx,%ebx
  1019a5:	74 0e                	je     1019b5 <dirlookup+0xa5>
          *poff = off + (uchar*)de - bp->data;
  1019a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1019aa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1019ad:	8d 04 16             	lea    (%esi,%edx,1),%eax
  1019b0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  1019b3:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
        brelse(bp);
  1019b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  1019b8:	0f b7 1e             	movzwl (%esi),%ebx
        brelse(bp);
  1019bb:	89 04 24             	mov    %eax,(%esp)
  1019be:	e8 3d e6 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  1019c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1019c6:	89 da                	mov    %ebx,%edx
  1019c8:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  1019ca:	83 c4 3c             	add    $0x3c,%esp
  1019cd:	5b                   	pop    %ebx
  1019ce:	5e                   	pop    %esi
  1019cf:	5f                   	pop    %edi
  1019d0:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  1019d1:	e9 6a f8 ff ff       	jmp    101240 <iget>
  1019d6:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  1019d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1019db:	89 04 24             	mov    %eax,(%esp)
  1019de:	e8 1d e6 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  1019e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1019e6:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  1019ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1019f0:	39 4a 18             	cmp    %ecx,0x18(%edx)
  1019f3:	0f 87 4c ff ff ff    	ja     101945 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  1019f9:	83 c4 3c             	add    $0x3c,%esp
  1019fc:	31 c0                	xor    %eax,%eax
  1019fe:	5b                   	pop    %ebx
  1019ff:	5e                   	pop    %esi
  101a00:	5f                   	pop    %edi
  101a01:	5d                   	pop    %ebp
  101a02:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101a03:	c7 04 24 bd 69 10 00 	movl   $0x1069bd,(%esp)
  101a0a:	e8 51 ef ff ff       	call   100960 <panic>
  101a0f:	90                   	nop

00101a10 <checki>:
}

// Check data from inode to see if it is in the buffer cache.
int
checki(struct inode *ip, int off)
{
  101a10:	55                   	push   %ebp
  101a11:	89 e5                	mov    %esp,%ebp
  101a13:	53                   	push   %ebx
  101a14:	83 ec 04             	sub    $0x4,%esp
  101a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if(off > ip->size)
  101a1d:	3b 43 18             	cmp    0x18(%ebx),%eax
  101a20:	76 0e                	jbe    101a30 <checki+0x20>
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));

 }
  101a22:	83 c4 04             	add    $0x4,%esp
  101a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101a2a:	5b                   	pop    %ebx
  101a2b:	5d                   	pop    %ebp
  101a2c:	c3                   	ret    
  101a2d:	8d 76 00             	lea    0x0(%esi),%esi
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101a30:	89 c2                	mov    %eax,%edx
  101a32:	31 c9                	xor    %ecx,%ecx
  101a34:	c1 fa 1f             	sar    $0x1f,%edx
  101a37:	c1 ea 17             	shr    $0x17,%edx
  101a3a:	01 c2                	add    %eax,%edx
  101a3c:	89 d8                	mov    %ebx,%eax
  101a3e:	c1 fa 09             	sar    $0x9,%edx
  101a41:	e8 da f9 ff ff       	call   101420 <bmap>
  101a46:	89 45 0c             	mov    %eax,0xc(%ebp)
  101a49:	8b 03                	mov    (%ebx),%eax
  101a4b:	89 45 08             	mov    %eax,0x8(%ebp)

 }
  101a4e:	83 c4 04             	add    $0x4,%esp
  101a51:	5b                   	pop    %ebx
  101a52:	5d                   	pop    %ebp
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101a53:	e9 28 e6 ff ff       	jmp    100080 <bcheck>
  101a58:	90                   	nop
  101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101a60 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101a60:	55                   	push   %ebp
  101a61:	89 e5                	mov    %esp,%ebp
  101a63:	57                   	push   %edi
  101a64:	56                   	push   %esi
  101a65:	53                   	push   %ebx
  101a66:	83 ec 3c             	sub    $0x3c,%esp
  101a69:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101a6d:	8d 55 dc             	lea    -0x24(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101a70:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	e8 84 f8 ff ff       	call   101300 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101a7c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101a80:	0f 86 96 00 00 00    	jbe    101b1c <ialloc+0xbc>
  101a86:	be 01 00 00 00       	mov    $0x1,%esi
  101a8b:	bb 01 00 00 00       	mov    $0x1,%ebx
  101a90:	eb 18                	jmp    101aaa <ialloc+0x4a>
  101a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101a98:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101a9b:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101a9e:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101aa0:	e8 5b e5 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101aa5:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  101aa8:	73 72                	jae    101b1c <ialloc+0xbc>
    bp = bread(dev, IBLOCK(inum));
  101aaa:	89 f0                	mov    %esi,%eax
  101aac:	c1 e8 03             	shr    $0x3,%eax
  101aaf:	83 c0 02             	add    $0x2,%eax
  101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	89 04 24             	mov    %eax,(%esp)
  101abc:	e8 6f e6 ff ff       	call   100130 <bread>
  101ac1:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101ac3:	89 f0                	mov    %esi,%eax
  101ac5:	83 e0 07             	and    $0x7,%eax
  101ac8:	c1 e0 06             	shl    $0x6,%eax
  101acb:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  101acf:	66 83 3a 00          	cmpw   $0x0,(%edx)
  101ad3:	75 c3                	jne    101a98 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101ad5:	89 14 24             	mov    %edx,(%esp)
  101ad8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  101adb:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101ae2:	00 
  101ae3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101aea:	00 
  101aeb:	e8 b0 2c 00 00       	call   1047a0 <memset>
      dip->type = type;
  101af0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  101af3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101af7:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  101afa:	89 3c 24             	mov    %edi,(%esp)
  101afd:	e8 fe e5 ff ff       	call   100100 <bwrite>
      brelse(bp);
  101b02:	89 3c 24             	mov    %edi,(%esp)
  101b05:	e8 f6 e4 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0d:	89 f2                	mov    %esi,%edx
  101b0f:	e8 2c f7 ff ff       	call   101240 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101b14:	83 c4 3c             	add    $0x3c,%esp
  101b17:	5b                   	pop    %ebx
  101b18:	5e                   	pop    %esi
  101b19:	5f                   	pop    %edi
  101b1a:	5d                   	pop    %ebp
  101b1b:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101b1c:	c7 04 24 cf 69 10 00 	movl   $0x1069cf,(%esp)
  101b23:	e8 38 ee ff ff       	call   100960 <panic>
  101b28:	90                   	nop
  101b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101b30 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101b30:	55                   	push   %ebp
  101b31:	89 e5                	mov    %esp,%ebp
  101b33:	57                   	push   %edi
  101b34:	56                   	push   %esi
  101b35:	89 c6                	mov    %eax,%esi
  101b37:	53                   	push   %ebx
  101b38:	89 d3                	mov    %edx,%ebx
  101b3a:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b41:	89 04 24             	mov    %eax,(%esp)
  101b44:	e8 e7 e5 ff ff       	call   100130 <bread>
  memset(bp->data, 0, BSIZE);
  101b49:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101b50:	00 
  101b51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b58:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b59:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  101b5b:	8d 40 18             	lea    0x18(%eax),%eax
  101b5e:	89 04 24             	mov    %eax,(%esp)
  101b61:	e8 3a 2c 00 00       	call   1047a0 <memset>
  bwrite(bp);
  101b66:	89 3c 24             	mov    %edi,(%esp)
  101b69:	e8 92 e5 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101b6e:	89 3c 24             	mov    %edi,(%esp)
  101b71:	e8 8a e4 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101b76:	89 f0                	mov    %esi,%eax
  101b78:	8d 55 dc             	lea    -0x24(%ebp),%edx
  101b7b:	e8 80 f7 ff ff       	call   101300 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101b83:	89 da                	mov    %ebx,%edx
  101b85:	c1 ea 0c             	shr    $0xc,%edx
  101b88:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b8b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b90:	c1 e8 03             	shr    $0x3,%eax
  101b93:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9b:	e8 90 e5 ff ff       	call   100130 <bread>
  bi = b % BPB;
  101ba0:	89 da                	mov    %ebx,%edx
  m = 1 << (bi % 8);
  101ba2:	89 d9                	mov    %ebx,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101ba4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  101baa:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  101bad:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101bb0:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101bb2:	0f b6 4c 10 18       	movzbl 0x18(%eax,%edx,1),%ecx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101bb7:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101bb9:	0f b6 c1             	movzbl %cl,%eax
  101bbc:	85 f0                	test   %esi,%eax
  101bbe:	74 22                	je     101be2 <bfree+0xb2>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101bc0:	89 f0                	mov    %esi,%eax
  101bc2:	f7 d0                	not    %eax
  101bc4:	21 c8                	and    %ecx,%eax
  101bc6:	88 44 17 18          	mov    %al,0x18(%edi,%edx,1)
  bwrite(bp);
  101bca:	89 3c 24             	mov    %edi,(%esp)
  101bcd:	e8 2e e5 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101bd2:	89 3c 24             	mov    %edi,(%esp)
  101bd5:	e8 26 e4 ff ff       	call   100000 <brelse>
}
  101bda:	83 c4 2c             	add    $0x2c,%esp
  101bdd:	5b                   	pop    %ebx
  101bde:	5e                   	pop    %esi
  101bdf:	5f                   	pop    %edi
  101be0:	5d                   	pop    %ebp
  101be1:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101be2:	c7 04 24 e1 69 10 00 	movl   $0x1069e1,(%esp)
  101be9:	e8 72 ed ff ff       	call   100960 <panic>
  101bee:	66 90                	xchg   %ax,%ax

00101bf0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101bf0:	55                   	push   %ebp
  101bf1:	89 e5                	mov    %esp,%ebp
  101bf3:	57                   	push   %edi
  101bf4:	56                   	push   %esi
  101bf5:	53                   	push   %ebx
  101bf6:	83 ec 2c             	sub    $0x2c,%esp
  101bf9:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&icache.lock);
  101bfc:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101c03:	e8 28 2b 00 00       	call   104730 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101c08:	8b 47 08             	mov    0x8(%edi),%eax
  101c0b:	83 f8 01             	cmp    $0x1,%eax
  101c0e:	0f 85 a8 00 00 00    	jne    101cbc <iput+0xcc>
  101c14:	8b 57 0c             	mov    0xc(%edi),%edx
  101c17:	f6 c2 02             	test   $0x2,%dl
  101c1a:	0f 84 9c 00 00 00    	je     101cbc <iput+0xcc>
  101c20:	66 83 7f 16 00       	cmpw   $0x0,0x16(%edi)
  101c25:	0f 85 91 00 00 00    	jne    101cbc <iput+0xcc>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101c2b:	f6 c2 01             	test   $0x1,%dl
  101c2e:	66 90                	xchg   %ax,%ax
  101c30:	0f 85 9d 01 00 00    	jne    101dd3 <iput+0x1e3>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101c36:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  101c39:	89 fb                	mov    %edi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101c3b:	89 57 0c             	mov    %edx,0xc(%edi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  101c3e:	8d 77 2c             	lea    0x2c(%edi),%esi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  101c41:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101c48:	e8 a3 2a 00 00       	call   1046f0 <release>
  101c4d:	eb 07                	jmp    101c56 <iput+0x66>
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101c4f:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101c52:	39 f3                	cmp    %esi,%ebx
  101c54:	74 1c                	je     101c72 <iput+0x82>
    if(ip->addrs[i]){
  101c56:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101c59:	85 d2                	test   %edx,%edx
  101c5b:	74 f2                	je     101c4f <iput+0x5f>
      bfree(ip->dev, ip->addrs[i]);
  101c5d:	8b 07                	mov    (%edi),%eax
  101c5f:	e8 cc fe ff ff       	call   101b30 <bfree>
      ip->addrs[i] = 0;
  101c64:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101c6b:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101c6e:	39 f3                	cmp    %esi,%ebx
  101c70:	75 e4                	jne    101c56 <iput+0x66>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101c72:	8b 47 48             	mov    0x48(%edi),%eax
  101c75:	85 c0                	test   %eax,%eax
  101c77:	0f 85 e9 00 00 00    	jne    101d66 <iput+0x176>
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
  101c7d:	8b 47 4c             	mov    0x4c(%edi),%eax
  101c80:	85 c0                	test   %eax,%eax
  101c82:	75 51                	jne    101cd5 <iput+0xe5>
	      }
	      brelse(bp);
	      ip->addrs[DINDIRECT] = 0;
  }

  ip->size = 0;
  101c84:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101c8b:	89 3c 24             	mov    %edi,(%esp)
  101c8e:	e8 8d fa ff ff       	call   101720 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101c93:	66 c7 47 10 00 00    	movw   $0x0,0x10(%edi)
    iupdate(ip);
  101c99:	89 3c 24             	mov    %edi,(%esp)
  101c9c:	e8 7f fa ff ff       	call   101720 <iupdate>
    acquire(&icache.lock);
  101ca1:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101ca8:	e8 83 2a 00 00       	call   104730 <acquire>
    ip->flags &= ~I_BUSY;
  101cad:	83 67 0c fe          	andl   $0xfffffffe,0xc(%edi)
    wakeup(ip);
  101cb1:	89 3c 24             	mov    %edi,(%esp)
  101cb4:	e8 37 19 00 00       	call   1035f0 <wakeup>
  101cb9:	8b 47 08             	mov    0x8(%edi),%eax
  }
  ip->ref--;
  101cbc:	83 e8 01             	sub    $0x1,%eax
  101cbf:	89 47 08             	mov    %eax,0x8(%edi)
  release(&icache.lock);
  101cc2:	c7 45 08 00 ab 10 00 	movl   $0x10ab00,0x8(%ebp)
}
  101cc9:	83 c4 2c             	add    $0x2c,%esp
  101ccc:	5b                   	pop    %ebx
  101ccd:	5e                   	pop    %esi
  101cce:	5f                   	pop    %edi
  101ccf:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101cd0:	e9 1b 2a 00 00       	jmp    1046f0 <release>
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd9:	8b 07                	mov    (%edi),%eax
  101cdb:	89 04 24             	mov    %eax,(%esp)
  101cde:	e8 4d e4 ff ff       	call   100130 <bread>
	      a = (uint*)bp->data;
  101ce3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101cea:	89 45 d8             	mov    %eax,-0x28(%ebp)
	      a = (uint*)bp->data;
  101ced:	83 c0 18             	add    $0x18,%eax
  101cf0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  101cf3:	31 c0                	xor    %eax,%eax
  101cf5:	eb 13                	jmp    101d0a <iput+0x11a>
  101cf7:	90                   	nop
	      for(j = 0; j < NINDIRECT; j++){
  101cf8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  101cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101cff:	3d 80 00 00 00       	cmp    $0x80,%eax
  101d04:	0f 84 9b 00 00 00    	je     101da5 <iput+0x1b5>
	        if(a[j]){
  101d0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101d0d:	8d 04 82             	lea    (%edx,%eax,4),%eax
  101d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101d13:	8b 00                	mov    (%eax),%eax
  101d15:	85 c0                	test   %eax,%eax
  101d17:	74 df                	je     101cf8 <iput+0x108>
	          bp2 = bread(ip->dev, a[j]);
  101d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1d:	8b 07                	mov    (%edi),%eax
	          uint* b = (uint*)bp2->data;
  101d1f:	31 db                	xor    %ebx,%ebx
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
  101d21:	89 04 24             	mov    %eax,(%esp)
  101d24:	e8 07 e4 ff ff       	call   100130 <bread>
	          uint* b = (uint*)bp2->data;
  101d29:	8d 70 18             	lea    0x18(%eax),%esi
  101d2c:	31 c0                	xor    %eax,%eax
  101d2e:	eb 0d                	jmp    101d3d <iput+0x14d>
	          for(k = 0; k < NINDIRECT; k++){
  101d30:	83 c3 01             	add    $0x1,%ebx
  101d33:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d39:	89 d8                	mov    %ebx,%eax
  101d3b:	74 1b                	je     101d58 <iput+0x168>
	        	  if(b[k]){
  101d3d:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101d40:	85 d2                	test   %edx,%edx
  101d42:	74 ec                	je     101d30 <iput+0x140>
	        		  bfree(ip->dev, b[k]);
  101d44:	8b 07                	mov    (%edi),%eax
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101d46:	83 c3 01             	add    $0x1,%ebx
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
  101d49:	e8 e2 fd ff ff       	call   101b30 <bfree>
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101d4e:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d54:	89 d8                	mov    %ebx,%eax
  101d56:	75 e5                	jne    101d3d <iput+0x14d>
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
	        	  }

	          }
	          bfree(ip->dev, a[j]);
  101d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101d5b:	8b 10                	mov    (%eax),%edx
  101d5d:	8b 07                	mov    (%edi),%eax
  101d5f:	e8 cc fd ff ff       	call   101b30 <bfree>
  101d64:	eb 92                	jmp    101cf8 <iput+0x108>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6a:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101d6c:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d6e:	89 04 24             	mov    %eax,(%esp)
  101d71:	e8 ba e3 ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  101d76:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101d7b:	83 c6 18             	add    $0x18,%esi
  101d7e:	31 c0                	xor    %eax,%eax
  101d80:	eb 13                	jmp    101d95 <iput+0x1a5>
  101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(j = 0; j < NINDIRECT; j++){
  101d88:	83 c3 01             	add    $0x1,%ebx
  101d8b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d91:	89 d8                	mov    %ebx,%eax
  101d93:	74 27                	je     101dbc <iput+0x1cc>
      if(a[j])
  101d95:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101d98:	85 d2                	test   %edx,%edx
  101d9a:	74 ec                	je     101d88 <iput+0x198>
        bfree(ip->dev, a[j]);
  101d9c:	8b 07                	mov    (%edi),%eax
  101d9e:	e8 8d fd ff ff       	call   101b30 <bfree>
  101da3:	eb e3                	jmp    101d88 <iput+0x198>

	          }
	          bfree(ip->dev, a[j]);
	        }
	      }
	      brelse(bp);
  101da5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101da8:	89 14 24             	mov    %edx,(%esp)
  101dab:	e8 50 e2 ff ff       	call   100000 <brelse>
	      ip->addrs[DINDIRECT] = 0;
  101db0:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101db7:	e9 c8 fe ff ff       	jmp    101c84 <iput+0x94>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101dbf:	89 04 24             	mov    %eax,(%esp)
  101dc2:	e8 39 e2 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  101dc7:	c7 47 48 00 00 00 00 	movl   $0x0,0x48(%edi)
  101dce:	e9 aa fe ff ff       	jmp    101c7d <iput+0x8d>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101dd3:	c7 04 24 f4 69 10 00 	movl   $0x1069f4,(%esp)
  101dda:	e8 81 eb ff ff       	call   100960 <panic>
  101ddf:	90                   	nop

00101de0 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101de0:	55                   	push   %ebp
  101de1:	89 e5                	mov    %esp,%ebp
  101de3:	57                   	push   %edi
  101de4:	56                   	push   %esi
  101de5:	53                   	push   %ebx
  101de6:	83 ec 2c             	sub    $0x2c,%esp
  101de9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  101def:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101df6:	00 
  101df7:	89 34 24             	mov    %esi,(%esp)
  101dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dfe:	e8 0d fb ff ff       	call   101910 <dirlookup>
  101e03:	85 c0                	test   %eax,%eax
  101e05:	0f 85 89 00 00 00    	jne    101e94 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101e0b:	8b 7e 18             	mov    0x18(%esi),%edi
  101e0e:	85 ff                	test   %edi,%edi
  101e10:	0f 84 8d 00 00 00    	je     101ea3 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101e16:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101e19:	31 db                	xor    %ebx,%ebx
  101e1b:	eb 0b                	jmp    101e28 <dirlink+0x48>
  101e1d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101e20:	83 c3 10             	add    $0x10,%ebx
  101e23:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101e26:	76 24                	jbe    101e4c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e28:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101e2f:	00 
  101e30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101e34:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101e38:	89 34 24             	mov    %esi,(%esp)
  101e3b:	e8 d0 f7 ff ff       	call   101610 <readi>
  101e40:	83 f8 10             	cmp    $0x10,%eax
  101e43:	75 65                	jne    101eaa <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101e45:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101e4a:	75 d4                	jne    101e20 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101e4f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e56:	00 
  101e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e5b:	8d 45 da             	lea    -0x26(%ebp),%eax
  101e5e:	89 04 24             	mov    %eax,(%esp)
  101e61:	e8 8a 2a 00 00       	call   1048f0 <strncpy>
  de.inum = ino;
  101e66:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e69:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101e70:	00 
  101e71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101e75:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101e79:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e7d:	89 34 24             	mov    %esi,(%esp)
  101e80:	e8 2b f9 ff ff       	call   1017b0 <writei>
  101e85:	83 f8 10             	cmp    $0x10,%eax
  101e88:	75 2c                	jne    101eb6 <dirlink+0xd6>
    panic("dirlink");
  101e8a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101e8c:	83 c4 2c             	add    $0x2c,%esp
  101e8f:	5b                   	pop    %ebx
  101e90:	5e                   	pop    %esi
  101e91:	5f                   	pop    %edi
  101e92:	5d                   	pop    %ebp
  101e93:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101e94:	89 04 24             	mov    %eax,(%esp)
  101e97:	e8 54 fd ff ff       	call   101bf0 <iput>
  101e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101ea1:	eb e9                	jmp    101e8c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101ea3:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101ea6:	31 db                	xor    %ebx,%ebx
  101ea8:	eb a2                	jmp    101e4c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101eaa:	c7 04 24 fe 69 10 00 	movl   $0x1069fe,(%esp)
  101eb1:	e8 aa ea ff ff       	call   100960 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101eb6:	c7 04 24 0b 6a 10 00 	movl   $0x106a0b,(%esp)
  101ebd:	e8 9e ea ff ff       	call   100960 <panic>
  101ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101ed0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101ed0:	55                   	push   %ebp
  101ed1:	89 e5                	mov    %esp,%ebp
  101ed3:	53                   	push   %ebx
  101ed4:	83 ec 14             	sub    $0x14,%esp
  101ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101eda:	85 db                	test   %ebx,%ebx
  101edc:	74 36                	je     101f14 <iunlock+0x44>
  101ede:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101ee2:	74 30                	je     101f14 <iunlock+0x44>
  101ee4:	8b 43 08             	mov    0x8(%ebx),%eax
  101ee7:	85 c0                	test   %eax,%eax
  101ee9:	7e 29                	jle    101f14 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101eeb:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101ef2:	e8 39 28 00 00       	call   104730 <acquire>
  ip->flags &= ~I_BUSY;
  101ef7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101efb:	89 1c 24             	mov    %ebx,(%esp)
  101efe:	e8 ed 16 00 00       	call   1035f0 <wakeup>
  release(&icache.lock);
  101f03:	c7 45 08 00 ab 10 00 	movl   $0x10ab00,0x8(%ebp)
}
  101f0a:	83 c4 14             	add    $0x14,%esp
  101f0d:	5b                   	pop    %ebx
  101f0e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101f0f:	e9 dc 27 00 00       	jmp    1046f0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101f14:	c7 04 24 13 6a 10 00 	movl   $0x106a13,(%esp)
  101f1b:	e8 40 ea ff ff       	call   100960 <panic>

00101f20 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101f20:	55                   	push   %ebp
  101f21:	89 e5                	mov    %esp,%ebp
  101f23:	53                   	push   %ebx
  101f24:	83 ec 14             	sub    $0x14,%esp
  101f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101f2a:	89 1c 24             	mov    %ebx,(%esp)
  101f2d:	e8 9e ff ff ff       	call   101ed0 <iunlock>
  iput(ip);
  101f32:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101f35:	83 c4 14             	add    $0x14,%esp
  101f38:	5b                   	pop    %ebx
  101f39:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101f3a:	e9 b1 fc ff ff       	jmp    101bf0 <iput>
  101f3f:	90                   	nop

00101f40 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101f40:	55                   	push   %ebp
  101f41:	89 e5                	mov    %esp,%ebp
  101f43:	56                   	push   %esi
  101f44:	53                   	push   %ebx
  101f45:	83 ec 10             	sub    $0x10,%esp
  101f48:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101f4b:	85 db                	test   %ebx,%ebx
  101f4d:	0f 84 e5 00 00 00    	je     102038 <ilock+0xf8>
  101f53:	8b 53 08             	mov    0x8(%ebx),%edx
  101f56:	85 d2                	test   %edx,%edx
  101f58:	0f 8e da 00 00 00    	jle    102038 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101f5e:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101f65:	e8 c6 27 00 00       	call   104730 <acquire>
  while(ip->flags & I_BUSY)
  101f6a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f6d:	a8 01                	test   $0x1,%al
  101f6f:	74 1e                	je     101f8f <ilock+0x4f>
  101f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101f78:	c7 44 24 04 00 ab 10 	movl   $0x10ab00,0x4(%esp)
  101f7f:	00 
  101f80:	89 1c 24             	mov    %ebx,(%esp)
  101f83:	e8 18 1a 00 00       	call   1039a0 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101f88:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f8b:	a8 01                	test   $0x1,%al
  101f8d:	75 e9                	jne    101f78 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101f8f:	83 c8 01             	or     $0x1,%eax
  101f92:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  101f95:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101f9c:	e8 4f 27 00 00       	call   1046f0 <release>

  if(!(ip->flags & I_VALID)){
  101fa1:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  101fa5:	74 09                	je     101fb0 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101fa7:	83 c4 10             	add    $0x10,%esp
  101faa:	5b                   	pop    %ebx
  101fab:	5e                   	pop    %esi
  101fac:	5d                   	pop    %ebp
  101fad:	c3                   	ret    
  101fae:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101fb0:	8b 43 04             	mov    0x4(%ebx),%eax
  101fb3:	c1 e8 03             	shr    $0x3,%eax
  101fb6:	83 c0 02             	add    $0x2,%eax
  101fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101fbd:	8b 03                	mov    (%ebx),%eax
  101fbf:	89 04 24             	mov    %eax,(%esp)
  101fc2:	e8 69 e1 ff ff       	call   100130 <bread>
  101fc7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101fc9:	8b 43 04             	mov    0x4(%ebx),%eax
  101fcc:	83 e0 07             	and    $0x7,%eax
  101fcf:	c1 e0 06             	shl    $0x6,%eax
  101fd2:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  101fd6:	0f b7 10             	movzwl (%eax),%edx
  101fd9:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  101fdd:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101fe1:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  101fe5:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101fe9:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  101fed:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101ff1:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  101ff5:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101ff8:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101ffb:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102002:	8d 43 1c             	lea    0x1c(%ebx),%eax
  102005:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  10200c:	00 
  10200d:	89 04 24             	mov    %eax,(%esp)
  102010:	e8 1b 28 00 00       	call   104830 <memmove>
    brelse(bp);
  102015:	89 34 24             	mov    %esi,(%esp)
  102018:	e8 e3 df ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  10201d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  102021:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  102026:	0f 85 7b ff ff ff    	jne    101fa7 <ilock+0x67>
      panic("ilock: no type");
  10202c:	c7 04 24 21 6a 10 00 	movl   $0x106a21,(%esp)
  102033:	e8 28 e9 ff ff       	call   100960 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  102038:	c7 04 24 1b 6a 10 00 	movl   $0x106a1b,(%esp)
  10203f:	e8 1c e9 ff ff       	call   100960 <panic>
  102044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10204a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102050 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  102050:	55                   	push   %ebp
  102051:	89 e5                	mov    %esp,%ebp
  102053:	57                   	push   %edi
  102054:	56                   	push   %esi
  102055:	53                   	push   %ebx
  102056:	89 c3                	mov    %eax,%ebx
  102058:	83 ec 2c             	sub    $0x2c,%esp
  10205b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10205e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  102061:	80 38 2f             	cmpb   $0x2f,(%eax)
  102064:	0f 84 3b 01 00 00    	je     1021a5 <_namei+0x155>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  10206a:	e8 81 16 00 00       	call   1036f0 <curproc>
  10206f:	8b 40 60             	mov    0x60(%eax),%eax
  102072:	89 04 24             	mov    %eax,(%esp)
  102075:	e8 96 f1 ff ff       	call   101210 <idup>
  10207a:	89 c7                	mov    %eax,%edi
  10207c:	eb 05                	jmp    102083 <_namei+0x33>
  10207e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  102080:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  102083:	0f b6 03             	movzbl (%ebx),%eax
  102086:	3c 2f                	cmp    $0x2f,%al
  102088:	74 f6                	je     102080 <_namei+0x30>
    path++;
  if(*path == 0)
  10208a:	84 c0                	test   %al,%al
  10208c:	75 1a                	jne    1020a8 <_namei+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  10208e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  102091:	85 c9                	test   %ecx,%ecx
  102093:	0f 85 34 01 00 00    	jne    1021cd <_namei+0x17d>
    iput(ip);
    return 0;
  }
  return ip;
}
  102099:	83 c4 2c             	add    $0x2c,%esp
  10209c:	89 f8                	mov    %edi,%eax
  10209e:	5b                   	pop    %ebx
  10209f:	5e                   	pop    %esi
  1020a0:	5f                   	pop    %edi
  1020a1:	5d                   	pop    %ebp
  1020a2:	c3                   	ret    
  1020a3:	90                   	nop
  1020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  1020a8:	3c 2f                	cmp    $0x2f,%al
  1020aa:	0f 84 db 00 00 00    	je     10218b <_namei+0x13b>
  1020b0:	89 de                	mov    %ebx,%esi
    path++;
  1020b2:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  1020b5:	0f b6 06             	movzbl (%esi),%eax
  1020b8:	84 c0                	test   %al,%al
  1020ba:	0f 85 90 00 00 00    	jne    102150 <_namei+0x100>
  1020c0:	89 f2                	mov    %esi,%edx
  1020c2:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  1020c4:	83 fa 0d             	cmp    $0xd,%edx
  1020c7:	0f 8e 99 00 00 00    	jle    102166 <_namei+0x116>
  1020cd:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, DIRSIZ);
  1020d0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1020d7:	00 
  1020d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1020dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1020df:	89 04 24             	mov    %eax,(%esp)
  1020e2:	e8 49 27 00 00       	call   104830 <memmove>
  1020e7:	eb 0a                	jmp    1020f3 <_namei+0xa3>
  1020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  1020f0:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  1020f3:	80 3e 2f             	cmpb   $0x2f,(%esi)
  1020f6:	74 f8                	je     1020f0 <_namei+0xa0>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  1020f8:	85 f6                	test   %esi,%esi
  1020fa:	74 92                	je     10208e <_namei+0x3e>
    ilock(ip);
  1020fc:	89 3c 24             	mov    %edi,(%esp)
  1020ff:	e8 3c fe ff ff       	call   101f40 <ilock>
    if(ip->type != T_DIR){
  102104:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  102109:	0f 85 82 00 00 00    	jne    102191 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  10210f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  102112:	85 db                	test   %ebx,%ebx
  102114:	74 09                	je     10211f <_namei+0xcf>
  102116:	80 3e 00             	cmpb   $0x0,(%esi)
  102119:	0f 84 9c 00 00 00    	je     1021bb <_namei+0x16b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  10211f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102126:	00 
  102127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10212a:	89 3c 24             	mov    %edi,(%esp)
  10212d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102131:	e8 da f7 ff ff       	call   101910 <dirlookup>
  102136:	85 c0                	test   %eax,%eax
  102138:	89 c3                	mov    %eax,%ebx
  10213a:	74 55                	je     102191 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  10213c:	89 3c 24             	mov    %edi,(%esp)
  10213f:	89 df                	mov    %ebx,%edi
  102141:	89 f3                	mov    %esi,%ebx
  102143:	e8 d8 fd ff ff       	call   101f20 <iunlockput>
  102148:	e9 36 ff ff ff       	jmp    102083 <_namei+0x33>
  10214d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  102150:	3c 2f                	cmp    $0x2f,%al
  102152:	0f 85 5a ff ff ff    	jne    1020b2 <_namei+0x62>
  102158:	89 f2                	mov    %esi,%edx
  10215a:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  10215c:	83 fa 0d             	cmp    $0xd,%edx
  10215f:	90                   	nop
  102160:	0f 8f 6a ff ff ff    	jg     1020d0 <_namei+0x80>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  102166:	89 54 24 08          	mov    %edx,0x8(%esp)
  10216a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10216e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102171:	89 04 24             	mov    %eax,(%esp)
  102174:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102177:	e8 b4 26 00 00       	call   104830 <memmove>
    name[len] = 0;
  10217c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10217f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102182:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  102186:	e9 68 ff ff ff       	jmp    1020f3 <_namei+0xa3>
  }
  while(*path == '/')
  10218b:	89 de                	mov    %ebx,%esi
  10218d:	31 d2                	xor    %edx,%edx
  10218f:	eb d5                	jmp    102166 <_namei+0x116>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  102191:	89 3c 24             	mov    %edi,(%esp)
  102194:	31 ff                	xor    %edi,%edi
  102196:	e8 85 fd ff ff       	call   101f20 <iunlockput>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  10219b:	83 c4 2c             	add    $0x2c,%esp
  10219e:	89 f8                	mov    %edi,%eax
  1021a0:	5b                   	pop    %ebx
  1021a1:	5e                   	pop    %esi
  1021a2:	5f                   	pop    %edi
  1021a3:	5d                   	pop    %ebp
  1021a4:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  1021a5:	ba 01 00 00 00       	mov    $0x1,%edx
  1021aa:	b8 01 00 00 00       	mov    $0x1,%eax
  1021af:	e8 8c f0 ff ff       	call   101240 <iget>
  1021b4:	89 c7                	mov    %eax,%edi
  1021b6:	e9 c8 fe ff ff       	jmp    102083 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  1021bb:	89 3c 24             	mov    %edi,(%esp)
  1021be:	e8 0d fd ff ff       	call   101ed0 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1021c3:	83 c4 2c             	add    $0x2c,%esp
  1021c6:	89 f8                	mov    %edi,%eax
  1021c8:	5b                   	pop    %ebx
  1021c9:	5e                   	pop    %esi
  1021ca:	5f                   	pop    %edi
  1021cb:	5d                   	pop    %ebp
  1021cc:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  1021cd:	89 3c 24             	mov    %edi,(%esp)
  1021d0:	31 ff                	xor    %edi,%edi
  1021d2:	e8 19 fa ff ff       	call   101bf0 <iput>
    return 0;
  1021d7:	e9 bd fe ff ff       	jmp    102099 <_namei+0x49>
  1021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001021e0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1021e0:	55                   	push   %ebp
  return _namei(path, 1, name);
  1021e1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1021e6:	89 e5                	mov    %esp,%ebp
  1021e8:	83 ec 08             	sub    $0x8,%esp
  return _namei(path, 1, name);
  1021eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1021ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1021f1:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  1021f2:	e9 59 fe ff ff       	jmp    102050 <_namei>
  1021f7:	89 f6                	mov    %esi,%esi
  1021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102200 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102200:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102201:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102203:	89 e5                	mov    %esp,%ebp
  102205:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102208:	8b 45 08             	mov    0x8(%ebp),%eax
  10220b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  10220e:	e8 3d fe ff ff       	call   102050 <_namei>
}
  102213:	c9                   	leave  
  102214:	c3                   	ret    
  102215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102220 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102220:	55                   	push   %ebp
  102221:	89 e5                	mov    %esp,%ebp
  102223:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache.lock");
  102226:	c7 44 24 04 30 6a 10 	movl   $0x106a30,0x4(%esp)
  10222d:	00 
  10222e:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  102235:	e8 36 23 00 00       	call   104570 <initlock>
}
  10223a:	c9                   	leave  
  10223b:	c3                   	ret    
  10223c:	90                   	nop
  10223d:	90                   	nop
  10223e:	90                   	nop
  10223f:	90                   	nop

00102240 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  102240:	55                   	push   %ebp
  102241:	89 c1                	mov    %eax,%ecx
  102243:	89 e5                	mov    %esp,%ebp
  102245:	56                   	push   %esi
  102246:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  102249:	85 c0                	test   %eax,%eax
  10224b:	0f 84 89 00 00 00    	je     1022da <ide_start_request+0x9a>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102251:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102256:	66 90                	xchg   %ax,%ax
  102258:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102259:	0f b6 c0             	movzbl %al,%eax
  10225c:	84 c0                	test   %al,%al
  10225e:	78 f8                	js     102258 <ide_start_request+0x18>
  102260:	a8 40                	test   $0x40,%al
  102262:	74 f4                	je     102258 <ide_start_request+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102264:	ba f6 03 00 00       	mov    $0x3f6,%edx
  102269:	31 c0                	xor    %eax,%eax
  10226b:	ee                   	out    %al,(%dx)
  10226c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  102271:	b8 01 00 00 00       	mov    $0x1,%eax
  102276:	ee                   	out    %al,(%dx)
    panic("ide_start_request");

  ide_wait_ready(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  102277:	8b 71 08             	mov    0x8(%ecx),%esi
  10227a:	b2 f3                	mov    $0xf3,%dl
  10227c:	89 f0                	mov    %esi,%eax
  10227e:	ee                   	out    %al,(%dx)
  10227f:	89 f0                	mov    %esi,%eax
  102281:	b2 f4                	mov    $0xf4,%dl
  102283:	c1 e8 08             	shr    $0x8,%eax
  102286:	ee                   	out    %al,(%dx)
  102287:	89 f0                	mov    %esi,%eax
  102289:	b2 f5                	mov    $0xf5,%dl
  10228b:	c1 e8 10             	shr    $0x10,%eax
  10228e:	ee                   	out    %al,(%dx)
  10228f:	8b 41 04             	mov    0x4(%ecx),%eax
  102292:	c1 ee 18             	shr    $0x18,%esi
  102295:	b2 f6                	mov    $0xf6,%dl
  102297:	83 e6 0f             	and    $0xf,%esi
  10229a:	83 e0 01             	and    $0x1,%eax
  10229d:	c1 e0 04             	shl    $0x4,%eax
  1022a0:	09 f0                	or     %esi,%eax
  1022a2:	83 c8 e0             	or     $0xffffffe0,%eax
  1022a5:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  1022a6:	f6 01 04             	testb  $0x4,(%ecx)
  1022a9:	75 11                	jne    1022bc <ide_start_request+0x7c>
  1022ab:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022b0:	b8 20 00 00 00       	mov    $0x20,%eax
  1022b5:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1022b6:	83 c4 14             	add    $0x14,%esp
  1022b9:	5e                   	pop    %esi
  1022ba:	5d                   	pop    %ebp
  1022bb:	c3                   	ret    
  1022bc:	b2 f7                	mov    $0xf7,%dl
  1022be:	b8 30 00 00 00       	mov    $0x30,%eax
  1022c3:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1022c4:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1022c9:	8d 71 18             	lea    0x18(%ecx),%esi
  1022cc:	b9 80 00 00 00       	mov    $0x80,%ecx
  1022d1:	fc                   	cld    
  1022d2:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  1022d4:	83 c4 14             	add    $0x14,%esp
  1022d7:	5e                   	pop    %esi
  1022d8:	5d                   	pop    %ebp
  1022d9:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  1022da:	c7 04 24 3c 6a 10 00 	movl   $0x106a3c,(%esp)
  1022e1:	e8 7a e6 ff ff       	call   100960 <panic>
  1022e6:	8d 76 00             	lea    0x0(%esi),%esi
  1022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001022f0 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  1022f0:	55                   	push   %ebp
  1022f1:	89 e5                	mov    %esp,%ebp
  1022f3:	53                   	push   %ebx
  1022f4:	83 ec 14             	sub    $0x14,%esp
  1022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  1022fa:	8b 03                	mov    (%ebx),%eax
  1022fc:	a8 01                	test   $0x1,%al
  1022fe:	0f 84 90 00 00 00    	je     102394 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102304:	83 e0 06             	and    $0x6,%eax
  102307:	83 f8 02             	cmp    $0x2,%eax
  10230a:	0f 84 9c 00 00 00    	je     1023ac <ide_rw+0xbc>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102310:	8b 53 04             	mov    0x4(%ebx),%edx
  102313:	85 d2                	test   %edx,%edx
  102315:	74 0d                	je     102324 <ide_rw+0x34>
  102317:	a1 b8 88 10 00       	mov    0x1088b8,%eax
  10231c:	85 c0                	test   %eax,%eax
  10231e:	0f 84 7c 00 00 00    	je     1023a0 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102324:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  10232b:	e8 00 24 00 00       	call   104730 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102330:	a1 b4 88 10 00       	mov    0x1088b4,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102335:	ba b4 88 10 00       	mov    $0x1088b4,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10233a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102341:	85 c0                	test   %eax,%eax
  102343:	74 0d                	je     102352 <ide_rw+0x62>
  102345:	8d 76 00             	lea    0x0(%esi),%esi
  102348:	8d 50 14             	lea    0x14(%eax),%edx
  10234b:	8b 40 14             	mov    0x14(%eax),%eax
  10234e:	85 c0                	test   %eax,%eax
  102350:	75 f6                	jne    102348 <ide_rw+0x58>
    ;
  *pp = b;
  102352:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  102354:	39 1d b4 88 10 00    	cmp    %ebx,0x1088b4
  10235a:	75 14                	jne    102370 <ide_rw+0x80>
  10235c:	eb 2d                	jmp    10238b <ide_rw+0x9b>
  10235e:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102360:	c7 44 24 04 80 88 10 	movl   $0x108880,0x4(%esp)
  102367:	00 
  102368:	89 1c 24             	mov    %ebx,(%esp)
  10236b:	e8 30 16 00 00       	call   1039a0 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102370:	8b 03                	mov    (%ebx),%eax
  102372:	83 e0 06             	and    $0x6,%eax
  102375:	83 f8 02             	cmp    $0x2,%eax
  102378:	75 e6                	jne    102360 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10237a:	c7 45 08 80 88 10 00 	movl   $0x108880,0x8(%ebp)
}
  102381:	83 c4 14             	add    $0x14,%esp
  102384:	5b                   	pop    %ebx
  102385:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102386:	e9 65 23 00 00       	jmp    1046f0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  10238b:	89 d8                	mov    %ebx,%eax
  10238d:	e8 ae fe ff ff       	call   102240 <ide_start_request>
  102392:	eb dc                	jmp    102370 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  102394:	c7 04 24 4e 6a 10 00 	movl   $0x106a4e,(%esp)
  10239b:	e8 c0 e5 ff ff       	call   100960 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1023a0:	c7 04 24 79 6a 10 00 	movl   $0x106a79,(%esp)
  1023a7:	e8 b4 e5 ff ff       	call   100960 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1023ac:	c7 04 24 63 6a 10 00 	movl   $0x106a63,(%esp)
  1023b3:	e8 a8 e5 ff ff       	call   100960 <panic>
  1023b8:	90                   	nop
  1023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001023c0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1023c0:	55                   	push   %ebp
  1023c1:	89 e5                	mov    %esp,%ebp
  1023c3:	57                   	push   %edi
  1023c4:	53                   	push   %ebx
  1023c5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1023c8:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  1023cf:	e8 5c 23 00 00       	call   104730 <acquire>
  if((b = ide_queue) == 0){
  1023d4:	8b 1d b4 88 10 00    	mov    0x1088b4,%ebx
  1023da:	85 db                	test   %ebx,%ebx
  1023dc:	74 28                	je     102406 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1023de:	8b 0b                	mov    (%ebx),%ecx
  1023e0:	f6 c1 04             	test   $0x4,%cl
  1023e3:	74 3b                	je     102420 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1023e5:	83 c9 02             	or     $0x2,%ecx
  1023e8:	83 e1 fb             	and    $0xfffffffb,%ecx
  1023eb:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  1023ed:	89 1c 24             	mov    %ebx,(%esp)
  1023f0:	e8 fb 11 00 00       	call   1035f0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  1023f5:	8b 43 14             	mov    0x14(%ebx),%eax
  1023f8:	85 c0                	test   %eax,%eax
  1023fa:	a3 b4 88 10 00       	mov    %eax,0x1088b4
  1023ff:	74 05                	je     102406 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102401:	e8 3a fe ff ff       	call   102240 <ide_start_request>

  release(&ide_lock);
  102406:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  10240d:	e8 de 22 00 00       	call   1046f0 <release>
}
  102412:	83 c4 10             	add    $0x10,%esp
  102415:	5b                   	pop    %ebx
  102416:	5f                   	pop    %edi
  102417:	5d                   	pop    %ebp
  102418:	c3                   	ret    
  102419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102420:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102425:	8d 76 00             	lea    0x0(%esi),%esi
  102428:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102429:	0f b6 c0             	movzbl %al,%eax
  10242c:	84 c0                	test   %al,%al
  10242e:	78 f8                	js     102428 <ide_intr+0x68>
  102430:	a8 40                	test   $0x40,%al
  102432:	74 f4                	je     102428 <ide_intr+0x68>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102434:	a8 21                	test   $0x21,%al
  102436:	75 ad                	jne    1023e5 <ide_intr+0x25>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102438:	8d 7b 18             	lea    0x18(%ebx),%edi
  10243b:	b9 80 00 00 00       	mov    $0x80,%ecx
  102440:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102445:	fc                   	cld    
  102446:	f2 6d                	repnz insl (%dx),%es:(%edi)
  102448:	8b 0b                	mov    (%ebx),%ecx
  10244a:	eb 99                	jmp    1023e5 <ide_intr+0x25>
  10244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102450 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102450:	55                   	push   %ebp
  102451:	89 e5                	mov    %esp,%ebp
  102453:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&ide_lock, "ide");
  102456:	c7 44 24 04 90 6a 10 	movl   $0x106a90,0x4(%esp)
  10245d:	00 
  10245e:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  102465:	e8 06 21 00 00       	call   104570 <initlock>
  pic_enable(IRQ_IDE);
  10246a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102471:	e8 8a 0b 00 00       	call   103000 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102476:	a1 a0 c1 10 00       	mov    0x10c1a0,%eax
  10247b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102482:	83 e8 01             	sub    $0x1,%eax
  102485:	89 44 24 04          	mov    %eax,0x4(%esp)
  102489:	e8 52 00 00 00       	call   1024e0 <ioapic_enable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10248e:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102493:	90                   	nop
  102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102498:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102499:	0f b6 c0             	movzbl %al,%eax
  10249c:	84 c0                	test   %al,%al
  10249e:	78 f8                	js     102498 <ide_init+0x48>
  1024a0:	a8 40                	test   $0x40,%al
  1024a2:	74 f4                	je     102498 <ide_init+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1024a4:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1024a9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1024ae:	ee                   	out    %al,(%dx)
  1024af:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1024b1:	b2 f7                	mov    $0xf7,%dl
  1024b3:	eb 0e                	jmp    1024c3 <ide_init+0x73>
  1024b5:	8d 76 00             	lea    0x0(%esi),%esi
  ioapic_enable(IRQ_IDE, ncpu - 1);
  ide_wait_ready(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1024b8:	83 c1 01             	add    $0x1,%ecx
  1024bb:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1024c1:	74 0f                	je     1024d2 <ide_init+0x82>
  1024c3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1024c4:	84 c0                	test   %al,%al
  1024c6:	74 f0                	je     1024b8 <ide_init+0x68>
      disk_1_present = 1;
  1024c8:	c7 05 b8 88 10 00 01 	movl   $0x1,0x1088b8
  1024cf:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1024d2:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1024d7:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1024dc:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1024dd:	c9                   	leave  
  1024de:	c3                   	ret    
  1024df:	90                   	nop

001024e0 <ioapic_enable>:
}

void
ioapic_enable(int irq, int cpunum)
{
  if(!ismp)
  1024e0:	8b 15 20 bb 10 00    	mov    0x10bb20,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1024e6:	55                   	push   %ebp
  1024e7:	89 e5                	mov    %esp,%ebp
  1024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  1024ec:	85 d2                	test   %edx,%edx
  1024ee:	74 1f                	je     10250f <ioapic_enable+0x2f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  1024f0:	8d 48 20             	lea    0x20(%eax),%ecx
  1024f3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1024f7:	a1 d4 ba 10 00       	mov    0x10bad4,%eax
  1024fc:	89 10                	mov    %edx,(%eax)
  1024fe:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  102501:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102504:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102507:	89 10                	mov    %edx,(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102509:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  10250c:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10250f:	5d                   	pop    %ebp
  102510:	c3                   	ret    
  102511:	eb 0d                	jmp    102520 <ioapic_init>
  102513:	90                   	nop
  102514:	90                   	nop
  102515:	90                   	nop
  102516:	90                   	nop
  102517:	90                   	nop
  102518:	90                   	nop
  102519:	90                   	nop
  10251a:	90                   	nop
  10251b:	90                   	nop
  10251c:	90                   	nop
  10251d:	90                   	nop
  10251e:	90                   	nop
  10251f:	90                   	nop

00102520 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102520:	55                   	push   %ebp
  102521:	89 e5                	mov    %esp,%ebp
  102523:	56                   	push   %esi
  102524:	53                   	push   %ebx
  102525:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102528:	8b 0d 20 bb 10 00    	mov    0x10bb20,%ecx
  10252e:	85 c9                	test   %ecx,%ecx
  102530:	0f 84 86 00 00 00    	je     1025bc <ioapic_init+0x9c>
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  102536:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10253d:	00 00 00 
  return ioapic->data;
  102540:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102546:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  10254b:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102552:	00 00 00 
  return ioapic->data;
  102555:	8b 15 10 00 c0 fe    	mov    0xfec00010,%edx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10255b:	0f b6 0d 24 bb 10 00 	movzbl 0x10bb24,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102562:	c7 05 d4 ba 10 00 00 	movl   $0xfec00000,0x10bad4
  102569:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10256c:	c1 ee 10             	shr    $0x10,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10256f:	c1 ea 18             	shr    $0x18,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102572:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102578:	39 d1                	cmp    %edx,%ecx
  10257a:	74 11                	je     10258d <ioapic_init+0x6d>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10257c:	c7 04 24 94 6a 10 00 	movl   $0x106a94,(%esp)
  102583:	e8 38 e2 ff ff       	call   1007c0 <cprintf>
  102588:	a1 d4 ba 10 00       	mov    0x10bad4,%eax
  10258d:	b9 10 00 00 00       	mov    $0x10,%ecx
  102592:	31 d2                	xor    %edx,%edx
  102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  102598:	8d 5a 20             	lea    0x20(%edx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10259b:	83 c2 01             	add    $0x1,%edx
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  10259e:	81 cb 00 00 01 00    	or     $0x10000,%ebx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1025a4:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  1025a6:	89 58 10             	mov    %ebx,0x10(%eax)
  1025a9:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1025ac:	83 c1 02             	add    $0x2,%ecx
  1025af:	39 d6                	cmp    %edx,%esi
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1025b1:	89 18                	mov    %ebx,(%eax)
  ioapic->data = data;
  1025b3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1025ba:	7d dc                	jge    102598 <ioapic_init+0x78>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1025bc:	83 c4 10             	add    $0x10,%esp
  1025bf:	5b                   	pop    %ebx
  1025c0:	5e                   	pop    %esi
  1025c1:	5d                   	pop    %ebp
  1025c2:	c3                   	ret    
  1025c3:	90                   	nop
  1025c4:	90                   	nop
  1025c5:	90                   	nop
  1025c6:	90                   	nop
  1025c7:	90                   	nop
  1025c8:	90                   	nop
  1025c9:	90                   	nop
  1025ca:	90                   	nop
  1025cb:	90                   	nop
  1025cc:	90                   	nop
  1025cd:	90                   	nop
  1025ce:	90                   	nop
  1025cf:	90                   	nop

001025d0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1025d0:	55                   	push   %ebp
  1025d1:	89 e5                	mov    %esp,%ebp
  1025d3:	56                   	push   %esi
  1025d4:	53                   	push   %ebx
  1025d5:	83 ec 10             	sub    $0x10,%esp
  1025d8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1025db:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1025e1:	74 0d                	je     1025f0 <kalloc+0x20>
    panic("kalloc");
  1025e3:	c7 04 24 c8 6a 10 00 	movl   $0x106ac8,(%esp)
  1025ea:	e8 71 e3 ff ff       	call   100960 <panic>
  1025ef:	90                   	nop
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1025f0:	85 f6                	test   %esi,%esi
  1025f2:	7e ef                	jle    1025e3 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  1025f4:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1025fb:	e8 30 21 00 00       	call   104730 <acquire>
  102600:	8b 1d 14 bb 10 00    	mov    0x10bb14,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102606:	85 db                	test   %ebx,%ebx
  102608:	74 3e                	je     102648 <kalloc+0x78>
    if(r->len == n){
  10260a:	8b 43 04             	mov    0x4(%ebx),%eax
  10260d:	ba 14 bb 10 00       	mov    $0x10bb14,%edx
  102612:	39 f0                	cmp    %esi,%eax
  102614:	75 11                	jne    102627 <kalloc+0x57>
  102616:	eb 58                	jmp    102670 <kalloc+0xa0>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102618:	89 da                	mov    %ebx,%edx
  10261a:	8b 1b                	mov    (%ebx),%ebx
  10261c:	85 db                	test   %ebx,%ebx
  10261e:	74 28                	je     102648 <kalloc+0x78>
    if(r->len == n){
  102620:	8b 43 04             	mov    0x4(%ebx),%eax
  102623:	39 f0                	cmp    %esi,%eax
  102625:	74 49                	je     102670 <kalloc+0xa0>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102627:	39 c6                	cmp    %eax,%esi
  102629:	7d ed                	jge    102618 <kalloc+0x48>
      r->len -= n;
  10262b:	29 f0                	sub    %esi,%eax
  10262d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102630:	01 c3                	add    %eax,%ebx
      release(&kalloc_lock);
  102632:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  102639:	e8 b2 20 00 00       	call   1046f0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10263e:	83 c4 10             	add    $0x10,%esp
  102641:	89 d8                	mov    %ebx,%eax
  102643:	5b                   	pop    %ebx
  102644:	5e                   	pop    %esi
  102645:	5d                   	pop    %ebp
  102646:	c3                   	ret    
  102647:	90                   	nop
      return p;
    }
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  102648:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  10264a:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  102651:	e8 9a 20 00 00       	call   1046f0 <release>

  cprintf("kalloc: out of memory\n");
  102656:	c7 04 24 cf 6a 10 00 	movl   $0x106acf,(%esp)
  10265d:	e8 5e e1 ff ff       	call   1007c0 <cprintf>
  return 0;
}
  102662:	83 c4 10             	add    $0x10,%esp
  102665:	89 d8                	mov    %ebx,%eax
  102667:	5b                   	pop    %ebx
  102668:	5e                   	pop    %esi
  102669:	5d                   	pop    %ebp
  10266a:	c3                   	ret    
  10266b:	90                   	nop
  10266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  102670:	8b 03                	mov    (%ebx),%eax
  102672:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  102674:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  10267b:	e8 70 20 00 00       	call   1046f0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  102680:	83 c4 10             	add    $0x10,%esp
  102683:	89 d8                	mov    %ebx,%eax
  102685:	5b                   	pop    %ebx
  102686:	5e                   	pop    %esi
  102687:	5d                   	pop    %ebp
  102688:	c3                   	ret    
  102689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102690 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102690:	55                   	push   %ebp
  102691:	89 e5                	mov    %esp,%ebp
  102693:	57                   	push   %edi
  102694:	56                   	push   %esi
  102695:	53                   	push   %ebx
  102696:	83 ec 2c             	sub    $0x2c,%esp
  102699:	8b 45 0c             	mov    0xc(%ebp),%eax
  10269c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10269f:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1026a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1026a4:	0f 8e e9 00 00 00    	jle    102793 <kfree+0x103>
  1026aa:	a9 ff 0f 00 00       	test   $0xfff,%eax
  1026af:	0f 85 de 00 00 00    	jne    102793 <kfree+0x103>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1026b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1026b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1026bf:	00 
  1026c0:	89 1c 24             	mov    %ebx,(%esp)
  1026c3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1026c7:	e8 d4 20 00 00       	call   1047a0 <memset>

  acquire(&kalloc_lock);
  1026cc:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1026d3:	e8 58 20 00 00       	call   104730 <acquire>
  p = (struct run*)v;
  1026d8:	a1 14 bb 10 00       	mov    0x10bb14,%eax
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1026dd:	85 c0                	test   %eax,%eax
  1026df:	74 61                	je     102742 <kfree+0xb2>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1026e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1026e4:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1026e7:	39 c1                	cmp    %eax,%ecx
  1026e9:	72 57                	jb     102742 <kfree+0xb2>
    rend = (struct run*)((char*)r + r->len);
  1026eb:	8b 70 04             	mov    0x4(%eax),%esi
  1026ee:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  1026f1:	39 d3                	cmp    %edx,%ebx
  1026f3:	72 73                	jb     102768 <kfree+0xd8>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1026f5:	39 c1                	cmp    %eax,%ecx
  1026f7:	0f 84 8f 00 00 00    	je     10278c <kfree+0xfc>
  1026fd:	8d 76 00             	lea    0x0(%esi),%esi
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102700:	39 da                	cmp    %ebx,%edx
  102702:	74 6c                	je     102770 <kfree+0xe0>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102704:	89 c7                	mov    %eax,%edi
  102706:	8b 00                	mov    (%eax),%eax
  102708:	85 c0                	test   %eax,%eax
  10270a:	74 3c                	je     102748 <kfree+0xb8>
  10270c:	39 c1                	cmp    %eax,%ecx
  10270e:	72 38                	jb     102748 <kfree+0xb8>
    rend = (struct run*)((char*)r + r->len);
  102710:	8b 70 04             	mov    0x4(%eax),%esi
  102713:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102716:	39 d3                	cmp    %edx,%ebx
  102718:	73 16                	jae    102730 <kfree+0xa0>
  10271a:	39 c3                	cmp    %eax,%ebx
  10271c:	72 12                	jb     102730 <kfree+0xa0>
      panic("freeing free page");
  10271e:	c7 04 24 ec 6a 10 00 	movl   $0x106aec,(%esp)
  102725:	e8 36 e2 ff ff       	call   100960 <panic>
  10272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  102730:	39 c1                	cmp    %eax,%ecx
  102732:	75 cc                	jne    102700 <kfree+0x70>
      p->len = len + r->len;
      p->next = r->next;
  102734:	8b 01                	mov    (%ecx),%eax
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  102736:	03 75 e4             	add    -0x1c(%ebp),%esi
      p->next = r->next;
  102739:	89 03                	mov    %eax,(%ebx)
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  10273b:	89 73 04             	mov    %esi,0x4(%ebx)
      p->next = r->next;
      *rp = p;
  10273e:	89 1f                	mov    %ebx,(%edi)
      goto out;
  102740:	eb 10                	jmp    102752 <kfree+0xc2>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102742:	bf 14 bb 10 00       	mov    $0x10bb14,%edi
  102747:	90                   	nop
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->next = r;
  10274b:	89 03                	mov    %eax,(%ebx)
  *rp = p;
  10274d:	89 1f                	mov    %ebx,(%edi)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  10274f:	89 53 04             	mov    %edx,0x4(%ebx)
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102752:	c7 45 08 e0 ba 10 00 	movl   $0x10bae0,0x8(%ebp)
}
  102759:	83 c4 2c             	add    $0x2c,%esp
  10275c:	5b                   	pop    %ebx
  10275d:	5e                   	pop    %esi
  10275e:	5f                   	pop    %edi
  10275f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102760:	e9 8b 1f 00 00       	jmp    1046f0 <release>
  102765:	8d 76 00             	lea    0x0(%esi),%esi
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102768:	39 c3                	cmp    %eax,%ebx
  10276a:	73 b2                	jae    10271e <kfree+0x8e>
  10276c:	eb 87                	jmp    1026f5 <kfree+0x65>
  10276e:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102770:	8b 10                	mov    (%eax),%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102772:	03 75 e4             	add    -0x1c(%ebp),%esi
      if(r->next && r->next == pend){  // r now next to r->next?
  102775:	85 d2                	test   %edx,%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102777:	89 70 04             	mov    %esi,0x4(%eax)
      if(r->next && r->next == pend){  // r now next to r->next?
  10277a:	74 d6                	je     102752 <kfree+0xc2>
  10277c:	39 d1                	cmp    %edx,%ecx
  10277e:	75 d2                	jne    102752 <kfree+0xc2>
        r->len += r->next->len;
        r->next = r->next->next;
  102780:	8b 11                	mov    (%ecx),%edx
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102782:	03 71 04             	add    0x4(%ecx),%esi
        r->next = r->next->next;
  102785:	89 10                	mov    %edx,(%eax)
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102787:	89 70 04             	mov    %esi,0x4(%eax)
  10278a:	eb c6                	jmp    102752 <kfree+0xc2>
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  10278c:	bf 14 bb 10 00       	mov    $0x10bb14,%edi
  102791:	eb a1                	jmp    102734 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  102793:	c7 04 24 e6 6a 10 00 	movl   $0x106ae6,(%esp)
  10279a:	e8 c1 e1 ff ff       	call   100960 <panic>
  10279f:	90                   	nop

001027a0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1027a0:	55                   	push   %ebp
  1027a1:	89 e5                	mov    %esp,%ebp
  1027a3:	83 ec 18             	sub    $0x18,%esp
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1027a6:	c7 44 24 04 c8 6a 10 	movl   $0x106ac8,0x4(%esp)
  1027ad:	00 
  1027ae:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1027b5:	e8 b6 1d 00 00       	call   104570 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1027ba:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1027c1:	00 
  1027c2:	c7 04 24 fe 6a 10 00 	movl   $0x106afe,(%esp)
  1027c9:	e8 f2 df ff ff       	call   1007c0 <cprintf>
  kfree(start, mem * PAGE);
  1027ce:	b8 44 01 11 00       	mov    $0x110144,%eax
  1027d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1027d8:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1027df:	00 
  1027e0:	89 04 24             	mov    %eax,(%esp)
  1027e3:	e8 a8 fe ff ff       	call   102690 <kfree>
}
  1027e8:	c9                   	leave  
  1027e9:	c3                   	ret    
  1027ea:	90                   	nop
  1027eb:	90                   	nop
  1027ec:	90                   	nop
  1027ed:	90                   	nop
  1027ee:	90                   	nop
  1027ef:	90                   	nop

001027f0 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  1027f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1027f1:	ba 64 00 00 00       	mov    $0x64,%edx
  1027f6:	89 e5                	mov    %esp,%ebp
  1027f8:	ec                   	in     (%dx),%al
  1027f9:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  1027fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102800:	83 e2 01             	and    $0x1,%edx
  102803:	74 3e                	je     102843 <kbd_getc+0x53>
  102805:	ba 60 00 00 00       	mov    $0x60,%edx
  10280a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  10280b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  10280e:	3d e0 00 00 00       	cmp    $0xe0,%eax
  102813:	0f 84 7f 00 00 00    	je     102898 <kbd_getc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102819:	84 c0                	test   %al,%al
  10281b:	79 2b                	jns    102848 <kbd_getc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  10281d:	8b 15 bc 88 10 00    	mov    0x1088bc,%edx
  102823:	f6 c2 40             	test   $0x40,%dl
  102826:	75 03                	jne    10282b <kbd_getc+0x3b>
  102828:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10282b:	0f b6 80 20 6b 10 00 	movzbl 0x106b20(%eax),%eax
  102832:	83 c8 40             	or     $0x40,%eax
  102835:	0f b6 c0             	movzbl %al,%eax
  102838:	f7 d0                	not    %eax
  10283a:	21 d0                	and    %edx,%eax
  10283c:	a3 bc 88 10 00       	mov    %eax,0x1088bc
  102841:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102843:	5d                   	pop    %ebp
  102844:	c3                   	ret    
  102845:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102848:	8b 0d bc 88 10 00    	mov    0x1088bc,%ecx
  10284e:	f6 c1 40             	test   $0x40,%cl
  102851:	74 05                	je     102858 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102853:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  102855:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102858:	0f b6 90 20 6b 10 00 	movzbl 0x106b20(%eax),%edx
  10285f:	09 ca                	or     %ecx,%edx
  102861:	0f b6 88 20 6c 10 00 	movzbl 0x106c20(%eax),%ecx
  102868:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  10286a:	89 d1                	mov    %edx,%ecx
  10286c:	83 e1 03             	and    $0x3,%ecx
  10286f:	8b 0c 8d 20 6d 10 00 	mov    0x106d20(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102876:	89 15 bc 88 10 00    	mov    %edx,0x1088bc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  10287c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10287f:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  102883:	74 be                	je     102843 <kbd_getc+0x53>
    if('a' <= c && c <= 'z')
  102885:	8d 50 9f             	lea    -0x61(%eax),%edx
  102888:	83 fa 19             	cmp    $0x19,%edx
  10288b:	77 1b                	ja     1028a8 <kbd_getc+0xb8>
      c += 'A' - 'a';
  10288d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102890:	5d                   	pop    %ebp
  102891:	c3                   	ret    
  102892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102898:	30 c0                	xor    %al,%al
  10289a:	83 0d bc 88 10 00 40 	orl    $0x40,0x1088bc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1028a1:	5d                   	pop    %ebp
  1028a2:	c3                   	ret    
  1028a3:	90                   	nop
  1028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1028a8:	8d 50 bf             	lea    -0x41(%eax),%edx
  1028ab:	83 fa 19             	cmp    $0x19,%edx
  1028ae:	77 93                	ja     102843 <kbd_getc+0x53>
      c += 'a' - 'A';
  1028b0:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  1028b3:	5d                   	pop    %ebp
  1028b4:	c3                   	ret    
  1028b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001028c0 <kbd_intr>:

void
kbd_intr(void)
{
  1028c0:	55                   	push   %ebp
  1028c1:	89 e5                	mov    %esp,%ebp
  1028c3:	83 ec 18             	sub    $0x18,%esp
  console_intr(kbd_getc);
  1028c6:	c7 04 24 f0 27 10 00 	movl   $0x1027f0,(%esp)
  1028cd:	e8 9e dc ff ff       	call   100570 <console_intr>
}
  1028d2:	c9                   	leave  
  1028d3:	c3                   	ret    
  1028d4:	90                   	nop
  1028d5:	90                   	nop
  1028d6:	90                   	nop
  1028d7:	90                   	nop
  1028d8:	90                   	nop
  1028d9:	90                   	nop
  1028da:	90                   	nop
  1028db:	90                   	nop
  1028dc:	90                   	nop
  1028dd:	90                   	nop
  1028de:	90                   	nop
  1028df:	90                   	nop

001028e0 <lapic_init>:
}

void
lapic_init(int c)
{
  if(!lapic) 
  1028e0:	a1 18 bb 10 00       	mov    0x10bb18,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1028e5:	55                   	push   %ebp
  1028e6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1028e8:	85 c0                	test   %eax,%eax
  1028ea:	0f 84 c4 00 00 00    	je     1029b4 <lapic_init+0xd4>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  1028f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1028fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102907:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10290a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  102911:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  102914:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102917:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10291e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102921:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102924:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10292b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10292e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102931:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102938:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10293b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10293e:	8b 50 30             	mov    0x30(%eax),%edx
  102941:	c1 ea 10             	shr    $0x10,%edx
  102944:	80 fa 03             	cmp    $0x3,%dl
  102947:	77 6f                	ja     1029b8 <lapic_init+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102949:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  102950:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102953:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102956:	8d 88 00 03 00 00    	lea    0x300(%eax),%ecx
  10295c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102963:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102966:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102969:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102973:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102976:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10297d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102980:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102983:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  10298a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10298d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102990:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  102997:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10299a:	8b 50 20             	mov    0x20(%eax),%edx
  10299d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1029a0:	8b 11                	mov    (%ecx),%edx
  1029a2:	80 e6 10             	and    $0x10,%dh
  1029a5:	75 f9                	jne    1029a0 <lapic_init+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029a7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  1029ae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029b1:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1029b4:	5d                   	pop    %ebp
  1029b5:	c3                   	ret    
  1029b6:	66 90                	xchg   %ax,%ax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  1029bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1029c2:	8b 50 20             	mov    0x20(%eax),%edx
  1029c5:	eb 82                	jmp    102949 <lapic_init+0x69>
  1029c7:	89 f6                	mov    %esi,%esi
  1029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001029d0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1029d0:	a1 18 bb 10 00       	mov    0x10bb18,%eax
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1029d5:	55                   	push   %ebp
  1029d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1029d8:	85 c0                	test   %eax,%eax
  1029da:	74 0d                	je     1029e9 <lapic_eoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1029e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029e6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  1029e9:	5d                   	pop    %ebp
  1029ea:	c3                   	ret    
  1029eb:	90                   	nop
  1029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001029f0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1029f0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1029f1:	ba 70 00 00 00       	mov    $0x70,%edx
  1029f6:	89 e5                	mov    %esp,%ebp
  1029f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  1029fd:	57                   	push   %edi
  1029fe:	56                   	push   %esi
  1029ff:	53                   	push   %ebx
  102a00:	83 ec 18             	sub    $0x18,%esp
  102a03:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  102a07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  102a0a:	ee                   	out    %al,(%dx)
  102a0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  102a10:	b2 71                	mov    $0x71,%dl
  102a12:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a13:	8b 15 18 bb 10 00    	mov    0x10bb18,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102a19:	89 d8                	mov    %ebx,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a1b:	89 cf                	mov    %ecx,%edi
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102a1d:	c1 e8 04             	shr    $0x4,%eax
  102a20:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a26:	c1 e7 18             	shl    $0x18,%edi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102a29:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102a30:	00 00 
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a32:	8d 82 10 03 00 00    	lea    0x310(%edx),%eax
  102a38:	89 ba 10 03 00 00    	mov    %edi,0x310(%edx)
  lapic[ID];  // wait for write to finish, by reading
  102a3e:	8d 72 20             	lea    0x20(%edx),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a41:	89 45 dc             	mov    %eax,-0x24(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102a44:	8b 42 20             	mov    0x20(%edx),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a47:	8d 82 00 03 00 00    	lea    0x300(%edx),%eax
  102a4d:	c7 82 00 03 00 00 00 	movl   $0xc500,0x300(%edx)
  102a54:	c5 00 00 
  102a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102a5a:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102a5d:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102a62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a69:	eb 0c                	jmp    102a77 <lapic_startap+0x87>
  102a6b:	90                   	nop
  102a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102a70:	85 c0                	test   %eax,%eax
  102a72:	74 2d                	je     102aa1 <lapic_startap+0xb1>
  102a74:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102a77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a81:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102a87:	7f e7                	jg     102a70 <lapic_startap+0x80>
  102a89:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a8c:	83 c1 01             	add    $0x1,%ecx
  102a8f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  102a92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a95:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102a9b:	7e ec                	jle    102a89 <lapic_startap+0x99>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102a9d:	85 c0                	test   %eax,%eax
  102a9f:	75 d3                	jne    102a74 <lapic_startap+0x84>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102aa1:	c7 82 00 03 00 00 00 	movl   $0x8500,0x300(%edx)
  102aa8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102aab:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102aae:	b8 63 00 00 00       	mov    $0x63,%eax
  102ab3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102aba:	eb 0b                	jmp    102ac7 <lapic_startap+0xd7>
  102abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102ac0:	85 c0                	test   %eax,%eax
  102ac2:	74 2d                	je     102af1 <lapic_startap+0x101>
  102ac4:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102ac7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ad1:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102ad7:	7f e7                	jg     102ac0 <lapic_startap+0xd0>
  102ad9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102adc:	83 c2 01             	add    $0x1,%edx
  102adf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ae5:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102aeb:	7e ec                	jle    102ad9 <lapic_startap+0xe9>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102aed:	85 c0                	test   %eax,%eax
  102aef:	75 d3                	jne    102ac4 <lapic_startap+0xd4>
  102af1:	c1 eb 0c             	shr    $0xc,%ebx
  102af4:	31 c9                	xor    %ecx,%ecx
  102af6:	80 cf 06             	or     $0x6,%bh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102af9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102afc:	89 38                	mov    %edi,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102afe:	8b 06                	mov    (%esi),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b03:	89 18                	mov    %ebx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102b05:	8b 06                	mov    (%esi),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102b07:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102b0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b13:	eb 0a                	jmp    102b1f <lapic_startap+0x12f>
  102b15:	8d 76 00             	lea    0x0(%esi),%esi
  
  while(us-- > 0)
  102b18:	85 c0                	test   %eax,%eax
  102b1a:	74 34                	je     102b50 <lapic_startap+0x160>
  102b1c:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102b1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b29:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b2f:	7f e7                	jg     102b18 <lapic_startap+0x128>
  102b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b34:	83 c2 01             	add    $0x1,%edx
  102b37:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b3d:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b43:	7e ec                	jle    102b31 <lapic_startap+0x141>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102b45:	85 c0                	test   %eax,%eax
  102b47:	75 d3                	jne    102b1c <lapic_startap+0x12c>
  102b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Send startup IPI (twice!) to enter bootstrap code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
  102b50:	83 c1 01             	add    $0x1,%ecx
  102b53:	83 f9 02             	cmp    $0x2,%ecx
  102b56:	75 a1                	jne    102af9 <lapic_startap+0x109>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  102b58:	83 c4 18             	add    $0x18,%esp
  102b5b:	5b                   	pop    %ebx
  102b5c:	5e                   	pop    %esi
  102b5d:	5f                   	pop    %edi
  102b5e:	5d                   	pop    %ebp
  102b5f:	c3                   	ret    

00102b60 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102b60:	55                   	push   %ebp
  102b61:	89 e5                	mov    %esp,%ebp
  102b63:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102b66:	9c                   	pushf  
  102b67:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102b68:	f6 c4 02             	test   $0x2,%ah
  102b6b:	74 12                	je     102b7f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  102b6d:	a1 c0 88 10 00       	mov    0x1088c0,%eax
  102b72:	8d 50 01             	lea    0x1(%eax),%edx
  102b75:	85 c0                	test   %eax,%eax
  102b77:	89 15 c0 88 10 00    	mov    %edx,0x1088c0
  102b7d:	74 19                	je     102b98 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  102b7f:	8b 15 18 bb 10 00    	mov    0x10bb18,%edx
  102b85:	31 c0                	xor    %eax,%eax
  102b87:	85 d2                	test   %edx,%edx
  102b89:	74 06                	je     102b91 <cpu+0x31>
    return lapic[ID]>>24;
  102b8b:	8b 42 20             	mov    0x20(%edx),%eax
  102b8e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102b91:	c9                   	leave  
  102b92:	c3                   	ret    
  102b93:	90                   	nop
  102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  102b98:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102b9a:	8b 40 04             	mov    0x4(%eax),%eax
  102b9d:	c7 04 24 30 6d 10 00 	movl   $0x106d30,(%esp)
  102ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ba8:	e8 13 dc ff ff       	call   1007c0 <cprintf>
  102bad:	eb d0                	jmp    102b7f <cpu+0x1f>
  102baf:	90                   	nop

00102bb0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102bb0:	55                   	push   %ebp
  102bb1:	89 e5                	mov    %esp,%ebp
  102bb3:	53                   	push   %ebx
  102bb4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102bb7:	e8 a4 ff ff ff       	call   102b60 <cpu>
  102bbc:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  102bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bc7:	e8 f4 db ff ff       	call   1007c0 <cprintf>
  idtinit();
  102bcc:	e8 4f 2f 00 00       	call   105b20 <idtinit>
  if(cpu() != mp_bcpu())
  102bd1:	e8 8a ff ff ff       	call   102b60 <cpu>
  102bd6:	89 c3                	mov    %eax,%ebx
  102bd8:	e8 c3 01 00 00       	call   102da0 <mp_bcpu>
  102bdd:	39 c3                	cmp    %eax,%ebx
  102bdf:	74 0d                	je     102bee <mpmain+0x3e>
    lapic_init(cpu());
  102be1:	e8 7a ff ff ff       	call   102b60 <cpu>
  102be6:	89 04 24             	mov    %eax,(%esp)
  102be9:	e8 f2 fc ff ff       	call   1028e0 <lapic_init>
  setupsegs(0);
  102bee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102bf5:	e8 c6 10 00 00       	call   103cc0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  102bfa:	e8 61 ff ff ff       	call   102b60 <cpu>
  102bff:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102c05:	b8 01 00 00 00       	mov    $0x1,%eax
  102c0a:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  102c10:	f0 87 82 40 bb 10 00 	lock xchg %eax,0x10bb40(%edx)

  cprintf("cpu%d: scheduling\n", cpu());
  102c17:	e8 44 ff ff ff       	call   102b60 <cpu>
  102c1c:	c7 04 24 6b 6d 10 00 	movl   $0x106d6b,(%esp)
  102c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c27:	e8 94 db ff ff       	call   1007c0 <cprintf>
  scheduler();
  102c2c:	e8 6f 12 00 00       	call   103ea0 <scheduler>
  102c31:	eb 0d                	jmp    102c40 <main>
  102c33:	90                   	nop
  102c34:	90                   	nop
  102c35:	90                   	nop
  102c36:	90                   	nop
  102c37:	90                   	nop
  102c38:	90                   	nop
  102c39:	90                   	nop
  102c3a:	90                   	nop
  102c3b:	90                   	nop
  102c3c:	90                   	nop
  102c3d:	90                   	nop
  102c3e:	90                   	nop
  102c3f:	90                   	nop

00102c40 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c40:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c41:	b8 44 f1 10 00       	mov    $0x10f144,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c46:	89 e5                	mov    %esp,%ebp
  102c48:	83 e4 f0             	and    $0xfffffff0,%esp
  102c4b:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c4c:	2d 0e 88 10 00       	sub    $0x10880e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c51:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c54:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c5f:	00 
  102c60:	c7 04 24 0e 88 10 00 	movl   $0x10880e,(%esp)
  102c67:	e8 34 1b 00 00       	call   1047a0 <memset>

  mp_init(); // collect info about this machine
  102c6c:	e8 bf 01 00 00       	call   102e30 <mp_init>
  lapic_init(mp_bcpu());
  102c71:	e8 2a 01 00 00       	call   102da0 <mp_bcpu>
  102c76:	89 04 24             	mov    %eax,(%esp)
  102c79:	e8 62 fc ff ff       	call   1028e0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102c7e:	e8 dd fe ff ff       	call   102b60 <cpu>
  102c83:	c7 04 24 7e 6d 10 00 	movl   $0x106d7e,(%esp)
  102c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c8e:	e8 2d db ff ff       	call   1007c0 <cprintf>

  pinit();         // process table
  102c93:	e8 b8 18 00 00       	call   104550 <pinit>
  binit();         // buffer cache
  102c98:	e8 73 d5 ff ff       	call   100210 <binit>
  102c9d:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  102ca0:	e8 8b 03 00 00       	call   103030 <pic_init>
  ioapic_init();   // another interrupt controller
  102ca5:	e8 76 f8 ff ff       	call   102520 <ioapic_init>
  kinit();         // physical memory allocator
  102caa:	e8 f1 fa ff ff       	call   1027a0 <kinit>
  102caf:	90                   	nop
  tvinit();        // trap vectors
  102cb0:	e8 1b 31 00 00       	call   105dd0 <tvinit>
  fileinit();      // file table
  102cb5:	e8 06 e5 ff ff       	call   1011c0 <fileinit>
  iinit();         // inode cache
  102cba:	e8 61 f5 ff ff       	call   102220 <iinit>
  102cbf:	90                   	nop
  console_init();  // I/O devices & their interrupts
  102cc0:	e8 bb d5 ff ff       	call   100280 <console_init>
  ide_init();      // disk
  102cc5:	e8 86 f7 ff ff       	call   102450 <ide_init>
  if(!ismp)
  102cca:	a1 20 bb 10 00       	mov    0x10bb20,%eax
  102ccf:	85 c0                	test   %eax,%eax
  102cd1:	0f 84 b1 00 00 00    	je     102d88 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102cd7:	e8 84 17 00 00       	call   104460 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102cdc:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102ce3:	00 
  102ce4:	c7 44 24 04 b4 87 10 	movl   $0x1087b4,0x4(%esp)
  102ceb:	00 
  102cec:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102cf3:	e8 38 1b 00 00       	call   104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102cf8:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102cff:	00 00 00 
  102d02:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102d07:	3d 40 bb 10 00       	cmp    $0x10bb40,%eax
  102d0c:	76 75                	jbe    102d83 <main+0x143>
  102d0e:	bb 40 bb 10 00       	mov    $0x10bb40,%ebx
  102d13:	90                   	nop
  102d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102d18:	e8 43 fe ff ff       	call   102b60 <cpu>
  102d1d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102d23:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102d28:	39 c3                	cmp    %eax,%ebx
  102d2a:	74 3e                	je     102d6a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102d2c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102d33:	e8 98 f8 ff ff       	call   1025d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102d38:	c7 05 f8 6f 00 00 b0 	movl   $0x102bb0,0x6ff8
  102d3f:	2b 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102d42:	05 00 10 00 00       	add    $0x1000,%eax
  102d47:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102d4c:	0f b6 03             	movzbl (%ebx),%eax
  102d4f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102d56:	00 
  102d57:	89 04 24             	mov    %eax,(%esp)
  102d5a:	e8 91 fc ff ff       	call   1029f0 <lapic_startap>
  102d5f:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102d60:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102d66:	85 c0                	test   %eax,%eax
  102d68:	74 f6                	je     102d60 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102d6a:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102d71:	00 00 00 
  102d74:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102d7a:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102d7f:	39 c3                	cmp    %eax,%ebx
  102d81:	72 95                	jb     102d18 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102d83:	e8 28 fe ff ff       	call   102bb0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102d88:	e8 33 2d 00 00       	call   105ac0 <timer_init>
  102d8d:	8d 76 00             	lea    0x0(%esi),%esi
  102d90:	e9 42 ff ff ff       	jmp    102cd7 <main+0x97>
  102d95:	90                   	nop
  102d96:	90                   	nop
  102d97:	90                   	nop
  102d98:	90                   	nop
  102d99:	90                   	nop
  102d9a:	90                   	nop
  102d9b:	90                   	nop
  102d9c:	90                   	nop
  102d9d:	90                   	nop
  102d9e:	90                   	nop
  102d9f:	90                   	nop

00102da0 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102da0:	a1 c4 88 10 00       	mov    0x1088c4,%eax
  102da5:	55                   	push   %ebp
  102da6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102da8:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102da9:	2d 40 bb 10 00       	sub    $0x10bb40,%eax
  102dae:	c1 f8 02             	sar    $0x2,%eax
  102db1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  102db7:	c3                   	ret    
  102db8:	90                   	nop
  102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102dc0 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102dc0:	55                   	push   %ebp
  102dc1:	89 e5                	mov    %esp,%ebp
  102dc3:	56                   	push   %esi
  102dc4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102dc5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102dc8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102dcb:	39 f0                	cmp    %esi,%eax
  102dcd:	73 42                	jae    102e11 <mp_search1+0x51>
  102dcf:	89 c3                	mov    %eax,%ebx
  102dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102dd8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102ddf:	00 
  102de0:	c7 44 24 04 95 6d 10 	movl   $0x106d95,0x4(%esp)
  102de7:	00 
  102de8:	89 1c 24             	mov    %ebx,(%esp)
  102deb:	e8 e0 19 00 00       	call   1047d0 <memcmp>
  102df0:	85 c0                	test   %eax,%eax
  102df2:	75 16                	jne    102e0a <mp_search1+0x4a>
  102df4:	31 d2                	xor    %edx,%edx
  102df6:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102df8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102dfc:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102dff:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102e01:	83 f8 10             	cmp    $0x10,%eax
  102e04:	75 f2                	jne    102df8 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102e06:	84 d2                	test   %dl,%dl
  102e08:	74 10                	je     102e1a <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102e0a:	83 c3 10             	add    $0x10,%ebx
  102e0d:	39 de                	cmp    %ebx,%esi
  102e0f:	77 c7                	ja     102dd8 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102e11:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102e14:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102e16:	5b                   	pop    %ebx
  102e17:	5e                   	pop    %esi
  102e18:	5d                   	pop    %ebp
  102e19:	c3                   	ret    
  102e1a:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102e1d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102e1f:	5b                   	pop    %ebx
  102e20:	5e                   	pop    %esi
  102e21:	5d                   	pop    %ebp
  102e22:	c3                   	ret    
  102e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102e30 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102e30:	55                   	push   %ebp
  102e31:	89 e5                	mov    %esp,%ebp
  102e33:	57                   	push   %edi
  102e34:	56                   	push   %esi
  102e35:	53                   	push   %ebx
  102e36:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102e39:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102e40:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102e47:	00 00 00 
  102e4a:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102e4f:	a3 c4 88 10 00       	mov    %eax,0x1088c4
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102e54:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102e5b:	c1 e0 08             	shl    $0x8,%eax
  102e5e:	09 d0                	or     %edx,%eax
  102e60:	c1 e0 04             	shl    $0x4,%eax
  102e63:	85 c0                	test   %eax,%eax
  102e65:	75 1b                	jne    102e82 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102e67:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102e6e:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102e75:	c1 e0 08             	shl    $0x8,%eax
  102e78:	09 d0                	or     %edx,%eax
  102e7a:	c1 e0 0a             	shl    $0xa,%eax
  102e7d:	2d 00 04 00 00       	sub    $0x400,%eax
  102e82:	ba 00 04 00 00       	mov    $0x400,%edx
  102e87:	e8 34 ff ff ff       	call   102dc0 <mp_search1>
  102e8c:	85 c0                	test   %eax,%eax
  102e8e:	89 c3                	mov    %eax,%ebx
  102e90:	0f 84 b2 00 00 00    	je     102f48 <mp_init+0x118>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102e96:	8b 73 04             	mov    0x4(%ebx),%esi
  102e99:	85 f6                	test   %esi,%esi
  102e9b:	75 0b                	jne    102ea8 <mp_init+0x78>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102e9d:	83 c4 2c             	add    $0x2c,%esp
  102ea0:	5b                   	pop    %ebx
  102ea1:	5e                   	pop    %esi
  102ea2:	5f                   	pop    %edi
  102ea3:	5d                   	pop    %ebp
  102ea4:	c3                   	ret    
  102ea5:	8d 76 00             	lea    0x0(%esi),%esi
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102ea8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102eaf:	00 
  102eb0:	c7 44 24 04 9a 6d 10 	movl   $0x106d9a,0x4(%esp)
  102eb7:	00 
  102eb8:	89 34 24             	mov    %esi,(%esp)
  102ebb:	e8 10 19 00 00       	call   1047d0 <memcmp>
  102ec0:	85 c0                	test   %eax,%eax
  102ec2:	75 d9                	jne    102e9d <mp_init+0x6d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102ec4:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  102ec8:	3c 04                	cmp    $0x4,%al
  102eca:	74 06                	je     102ed2 <mp_init+0xa2>
  102ecc:	3c 01                	cmp    $0x1,%al
  102ece:	66 90                	xchg   %ax,%ax
  102ed0:	75 cb                	jne    102e9d <mp_init+0x6d>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102ed2:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ed6:	85 d2                	test   %edx,%edx
  102ed8:	74 15                	je     102eef <mp_init+0xbf>
  102eda:	31 c9                	xor    %ecx,%ecx
  102edc:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  102ede:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ee2:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102ee5:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ee7:	39 c2                	cmp    %eax,%edx
  102ee9:	7f f3                	jg     102ede <mp_init+0xae>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102eeb:	84 c9                	test   %cl,%cl
  102eed:	75 ae                	jne    102e9d <mp_init+0x6d>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102eef:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102ef2:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102ef5:	c7 05 20 bb 10 00 01 	movl   $0x1,0x10bb20
  102efc:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102eff:	a3 18 bb 10 00       	mov    %eax,0x10bb18

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102f04:	8d 46 2c             	lea    0x2c(%esi),%eax
  102f07:	39 d0                	cmp    %edx,%eax
  102f09:	0f 83 81 00 00 00    	jae    102f90 <mp_init+0x160>
  102f0f:	8b 35 c4 88 10 00    	mov    0x1088c4,%esi
  102f15:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  102f18:	0f b6 08             	movzbl (%eax),%ecx
  102f1b:	80 f9 04             	cmp    $0x4,%cl
  102f1e:	76 50                	jbe    102f70 <mp_init+0x140>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102f20:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102f23:	89 35 c4 88 10 00    	mov    %esi,0x1088c4
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102f29:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102f2d:	c7 04 24 a8 6d 10 00 	movl   $0x106da8,(%esp)
  102f34:	e8 87 d8 ff ff       	call   1007c0 <cprintf>
      panic("mp_init");
  102f39:	c7 04 24 9f 6d 10 00 	movl   $0x106d9f,(%esp)
  102f40:	e8 1b da ff ff       	call   100960 <panic>
  102f45:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102f48:	ba 00 00 01 00       	mov    $0x10000,%edx
  102f4d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102f52:	e8 69 fe ff ff       	call   102dc0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102f57:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102f59:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102f5b:	0f 85 35 ff ff ff    	jne    102e96 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102f61:	83 c4 2c             	add    $0x2c,%esp
  102f64:	5b                   	pop    %ebx
  102f65:	5e                   	pop    %esi
  102f66:	5f                   	pop    %edi
  102f67:	5d                   	pop    %ebp
  102f68:	c3                   	ret    
  102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102f70:	0f b6 c9             	movzbl %cl,%ecx
  102f73:	ff 24 8d cc 6d 10 00 	jmp    *0x106dcc(,%ecx,4)
  102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102f80:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102f83:	39 c2                	cmp    %eax,%edx
  102f85:	77 91                	ja     102f18 <mp_init+0xe8>
  102f87:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  102f8a:	89 35 c4 88 10 00    	mov    %esi,0x1088c4
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102f90:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  102f94:	0f 84 03 ff ff ff    	je     102e9d <mp_init+0x6d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102f9a:	ba 22 00 00 00       	mov    $0x22,%edx
  102f9f:	b8 70 00 00 00       	mov    $0x70,%eax
  102fa4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102fa5:	b2 23                	mov    $0x23,%dl
  102fa7:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102fa8:	83 c8 01             	or     $0x1,%eax
  102fab:	ee                   	out    %al,(%dx)
  102fac:	e9 ec fe ff ff       	jmp    102e9d <mp_init+0x6d>
  102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102fb8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  102fbc:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102fbf:	88 0d 24 bb 10 00    	mov    %cl,0x10bb24
      p += sizeof(struct mpioapic);
      continue;
  102fc5:	eb bc                	jmp    102f83 <mp_init+0x153>
  102fc7:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102fc8:	8b 0d a0 c1 10 00    	mov    0x10c1a0,%ecx
  102fce:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102fd2:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  102fd8:	88 9f 40 bb 10 00    	mov    %bl,0x10bb40(%edi)
      if(proc->flags & MPBOOT)
  102fde:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102fe2:	74 06                	je     102fea <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  102fe4:	8d b7 40 bb 10 00    	lea    0x10bb40(%edi),%esi
      ncpu++;
  102fea:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  102fed:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102ff0:	89 0d a0 c1 10 00    	mov    %ecx,0x10c1a0
      p += sizeof(struct mpproc);
      continue;
  102ff6:	eb 8b                	jmp    102f83 <mp_init+0x153>
  102ff8:	90                   	nop
  102ff9:	90                   	nop
  102ffa:	90                   	nop
  102ffb:	90                   	nop
  102ffc:	90                   	nop
  102ffd:	90                   	nop
  102ffe:	90                   	nop
  102fff:	90                   	nop

00103000 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103000:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  103001:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103006:	89 e5                	mov    %esp,%ebp
  103008:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  10300d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103010:	d3 c0                	rol    %cl,%eax
  103012:	66 23 05 80 83 10 00 	and    0x108380,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  103019:	66 a3 80 83 10 00    	mov    %ax,0x108380
  10301f:	ee                   	out    %al,(%dx)
  103020:	66 c1 e8 08          	shr    $0x8,%ax
  103024:	b2 a1                	mov    $0xa1,%dl
  103026:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  103027:	5d                   	pop    %ebp
  103028:	c3                   	ret    
  103029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103030 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  103030:	55                   	push   %ebp
  103031:	b9 21 00 00 00       	mov    $0x21,%ecx
  103036:	89 e5                	mov    %esp,%ebp
  103038:	83 ec 0c             	sub    $0xc,%esp
  10303b:	89 1c 24             	mov    %ebx,(%esp)
  10303e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103043:	89 ca                	mov    %ecx,%edx
  103045:	89 74 24 04          	mov    %esi,0x4(%esp)
  103049:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10304d:	ee                   	out    %al,(%dx)
  10304e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  103053:	89 da                	mov    %ebx,%edx
  103055:	ee                   	out    %al,(%dx)
  103056:	be 11 00 00 00       	mov    $0x11,%esi
  10305b:	b2 20                	mov    $0x20,%dl
  10305d:	89 f0                	mov    %esi,%eax
  10305f:	ee                   	out    %al,(%dx)
  103060:	b8 20 00 00 00       	mov    $0x20,%eax
  103065:	89 ca                	mov    %ecx,%edx
  103067:	ee                   	out    %al,(%dx)
  103068:	b8 04 00 00 00       	mov    $0x4,%eax
  10306d:	ee                   	out    %al,(%dx)
  10306e:	bf 03 00 00 00       	mov    $0x3,%edi
  103073:	89 f8                	mov    %edi,%eax
  103075:	ee                   	out    %al,(%dx)
  103076:	b1 a0                	mov    $0xa0,%cl
  103078:	89 f0                	mov    %esi,%eax
  10307a:	89 ca                	mov    %ecx,%edx
  10307c:	ee                   	out    %al,(%dx)
  10307d:	b8 28 00 00 00       	mov    $0x28,%eax
  103082:	89 da                	mov    %ebx,%edx
  103084:	ee                   	out    %al,(%dx)
  103085:	b8 02 00 00 00       	mov    $0x2,%eax
  10308a:	ee                   	out    %al,(%dx)
  10308b:	89 f8                	mov    %edi,%eax
  10308d:	ee                   	out    %al,(%dx)
  10308e:	be 68 00 00 00       	mov    $0x68,%esi
  103093:	b2 20                	mov    $0x20,%dl
  103095:	89 f0                	mov    %esi,%eax
  103097:	ee                   	out    %al,(%dx)
  103098:	bb 0a 00 00 00       	mov    $0xa,%ebx
  10309d:	89 d8                	mov    %ebx,%eax
  10309f:	ee                   	out    %al,(%dx)
  1030a0:	89 f0                	mov    %esi,%eax
  1030a2:	89 ca                	mov    %ecx,%edx
  1030a4:	ee                   	out    %al,(%dx)
  1030a5:	89 d8                	mov    %ebx,%eax
  1030a7:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  1030a8:	0f b7 05 80 83 10 00 	movzwl 0x108380,%eax
  1030af:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  1030b3:	74 0a                	je     1030bf <pic_init+0x8f>
  1030b5:	b2 21                	mov    $0x21,%dl
  1030b7:	ee                   	out    %al,(%dx)
  1030b8:	66 c1 e8 08          	shr    $0x8,%ax
  1030bc:	b2 a1                	mov    $0xa1,%dl
  1030be:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  1030bf:	8b 1c 24             	mov    (%esp),%ebx
  1030c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  1030c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1030ca:	89 ec                	mov    %ebp,%esp
  1030cc:	5d                   	pop    %ebp
  1030cd:	c3                   	ret    
  1030ce:	90                   	nop
  1030cf:	90                   	nop

001030d0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  1030d0:	55                   	push   %ebp
  1030d1:	89 e5                	mov    %esp,%ebp
  1030d3:	57                   	push   %edi
  1030d4:	56                   	push   %esi
  1030d5:	53                   	push   %ebx
  1030d6:	83 ec 2c             	sub    $0x2c,%esp
  1030d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1030dc:	8d 73 10             	lea    0x10(%ebx),%esi
  1030df:	89 34 24             	mov    %esi,(%esp)
  1030e2:	e8 49 16 00 00       	call   104730 <acquire>
  while(p->readp == p->writep && p->writeopen){
  1030e7:	8b 53 0c             	mov    0xc(%ebx),%edx
  1030ea:	3b 53 08             	cmp    0x8(%ebx),%edx
  1030ed:	75 51                	jne    103140 <piperead+0x70>
  1030ef:	8b 4b 04             	mov    0x4(%ebx),%ecx
  1030f2:	85 c9                	test   %ecx,%ecx
  1030f4:	74 4a                	je     103140 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  1030f6:	8d 7b 0c             	lea    0xc(%ebx),%edi
  1030f9:	eb 20                	jmp    10311b <piperead+0x4b>
  1030fb:	90                   	nop
  1030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103100:	89 74 24 04          	mov    %esi,0x4(%esp)
  103104:	89 3c 24             	mov    %edi,(%esp)
  103107:	e8 94 08 00 00       	call   1039a0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  10310c:	8b 53 0c             	mov    0xc(%ebx),%edx
  10310f:	3b 53 08             	cmp    0x8(%ebx),%edx
  103112:	75 2c                	jne    103140 <piperead+0x70>
  103114:	8b 43 04             	mov    0x4(%ebx),%eax
  103117:	85 c0                	test   %eax,%eax
  103119:	74 25                	je     103140 <piperead+0x70>
    if(cp->killed){
  10311b:	e8 d0 05 00 00       	call   1036f0 <curproc>
  103120:	8b 40 1c             	mov    0x1c(%eax),%eax
  103123:	85 c0                	test   %eax,%eax
  103125:	74 d9                	je     103100 <piperead+0x30>
      release(&p->lock);
  103127:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  10312c:	89 34 24             	mov    %esi,(%esp)
  10312f:	e8 bc 15 00 00       	call   1046f0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  103134:	83 c4 2c             	add    $0x2c,%esp
  103137:	89 f8                	mov    %edi,%eax
  103139:	5b                   	pop    %ebx
  10313a:	5e                   	pop    %esi
  10313b:	5f                   	pop    %edi
  10313c:	5d                   	pop    %ebp
  10313d:	c3                   	ret    
  10313e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103140:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103143:	85 c9                	test   %ecx,%ecx
  103145:	7e 5a                	jle    1031a1 <piperead+0xd1>
    if(p->readp == p->writep)
  103147:	31 ff                	xor    %edi,%edi
  103149:	3b 53 08             	cmp    0x8(%ebx),%edx
  10314c:	74 53                	je     1031a1 <piperead+0xd1>
  10314e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  103151:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103154:	8b 75 10             	mov    0x10(%ebp),%esi
  103157:	eb 0c                	jmp    103165 <piperead+0x95>
  103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103160:	39 53 08             	cmp    %edx,0x8(%ebx)
  103163:	74 1c                	je     103181 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103165:	89 d0                	mov    %edx,%eax
  103167:	83 c2 01             	add    $0x1,%edx
  10316a:	25 ff 01 00 00       	and    $0x1ff,%eax
  10316f:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  103174:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103177:	83 c7 01             	add    $0x1,%edi
  10317a:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  10317c:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10317f:	7f df                	jg     103160 <piperead+0x90>
  103181:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  103184:	83 c3 08             	add    $0x8,%ebx
  103187:	89 1c 24             	mov    %ebx,(%esp)
  10318a:	e8 61 04 00 00       	call   1035f0 <wakeup>
  release(&p->lock);
  10318f:	89 34 24             	mov    %esi,(%esp)
  103192:	e8 59 15 00 00       	call   1046f0 <release>
  return i;
}
  103197:	83 c4 2c             	add    $0x2c,%esp
  10319a:	89 f8                	mov    %edi,%eax
  10319c:	5b                   	pop    %ebx
  10319d:	5e                   	pop    %esi
  10319e:	5f                   	pop    %edi
  10319f:	5d                   	pop    %ebp
  1031a0:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  1031a1:	31 ff                	xor    %edi,%edi
  1031a3:	eb df                	jmp    103184 <piperead+0xb4>
  1031a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1031a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001031b0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  1031b0:	55                   	push   %ebp
  1031b1:	89 e5                	mov    %esp,%ebp
  1031b3:	57                   	push   %edi
  1031b4:	56                   	push   %esi
  1031b5:	53                   	push   %ebx
  1031b6:	83 ec 3c             	sub    $0x3c,%esp
  1031b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1031bc:	8d 73 10             	lea    0x10(%ebx),%esi
  1031bf:	89 34 24             	mov    %esi,(%esp)
  1031c2:	e8 69 15 00 00       	call   104730 <acquire>
  for(i = 0; i < n; i++){
  1031c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1031ca:	85 c9                	test   %ecx,%ecx
  1031cc:	0f 8e d0 00 00 00    	jle    1032a2 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  1031d2:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1031d5:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  1031d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1031db:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1031de:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  1031e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1031e8:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1031eb:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  1031f1:	39 c8                	cmp    %ecx,%eax
  1031f3:	75 66                	jne    10325b <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  1031f5:	8b 3b                	mov    (%ebx),%edi
  1031f7:	85 ff                	test   %edi,%edi
  1031f9:	74 3e                	je     103239 <pipewrite+0x89>
  1031fb:	8b 7d d0             	mov    -0x30(%ebp),%edi
  1031fe:	eb 2d                	jmp    10322d <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  103200:	89 3c 24             	mov    %edi,(%esp)
  103203:	e8 e8 03 00 00       	call   1035f0 <wakeup>
      sleep(&p->writep, &p->lock);
  103208:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10320b:	89 74 24 04          	mov    %esi,0x4(%esp)
  10320f:	89 0c 24             	mov    %ecx,(%esp)
  103212:	e8 89 07 00 00       	call   1039a0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  103217:	8b 53 0c             	mov    0xc(%ebx),%edx
  10321a:	8b 43 08             	mov    0x8(%ebx),%eax
  10321d:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103223:	39 c8                	cmp    %ecx,%eax
  103225:	75 31                	jne    103258 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  103227:	8b 13                	mov    (%ebx),%edx
  103229:	85 d2                	test   %edx,%edx
  10322b:	74 0c                	je     103239 <pipewrite+0x89>
  10322d:	e8 be 04 00 00       	call   1036f0 <curproc>
  103232:	8b 40 1c             	mov    0x1c(%eax),%eax
  103235:	85 c0                	test   %eax,%eax
  103237:	74 c7                	je     103200 <pipewrite+0x50>
        release(&p->lock);
  103239:	89 34 24             	mov    %esi,(%esp)
  10323c:	e8 af 14 00 00       	call   1046f0 <release>
  103241:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  103248:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10324b:	83 c4 3c             	add    $0x3c,%esp
  10324e:	5b                   	pop    %ebx
  10324f:	5e                   	pop    %esi
  103250:	5f                   	pop    %edi
  103251:	5d                   	pop    %ebp
  103252:	c3                   	ret    
  103253:	90                   	nop
  103254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103258:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10325b:	89 c7                	mov    %eax,%edi
  10325d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103260:	83 c0 01             	add    $0x1,%eax
  103263:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  103269:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  10326c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10326f:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  103273:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103276:	89 43 08             	mov    %eax,0x8(%ebx)
  103279:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10327d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  103281:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103284:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  103287:	0f 8f 5e ff ff ff    	jg     1031eb <pipewrite+0x3b>
  10328d:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103290:	89 3c 24             	mov    %edi,(%esp)
  103293:	e8 58 03 00 00       	call   1035f0 <wakeup>
  release(&p->lock);
  103298:	89 34 24             	mov    %esi,(%esp)
  10329b:	e8 50 14 00 00       	call   1046f0 <release>
  return i;
  1032a0:	eb a6                	jmp    103248 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  1032a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1032a9:	8d 7b 0c             	lea    0xc(%ebx),%edi
  1032ac:	eb e2                	jmp    103290 <pipewrite+0xe0>
  1032ae:	66 90                	xchg   %ax,%ax

001032b0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  1032b0:	55                   	push   %ebp
  1032b1:	89 e5                	mov    %esp,%ebp
  1032b3:	83 ec 28             	sub    $0x28,%esp
  1032b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1032b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1032bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1032bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1032c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  1032c5:	8d 73 10             	lea    0x10(%ebx),%esi
  1032c8:	89 34 24             	mov    %esi,(%esp)
  1032cb:	e8 60 14 00 00       	call   104730 <acquire>
  if(writable){
  1032d0:	85 ff                	test   %edi,%edi
  1032d2:	74 34                	je     103308 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  1032d4:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  1032d7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  1032de:	89 04 24             	mov    %eax,(%esp)
  1032e1:	e8 0a 03 00 00       	call   1035f0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1032e6:	89 34 24             	mov    %esi,(%esp)
  1032e9:	e8 02 14 00 00       	call   1046f0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1032ee:	8b 3b                	mov    (%ebx),%edi
  1032f0:	85 ff                	test   %edi,%edi
  1032f2:	75 07                	jne    1032fb <pipeclose+0x4b>
  1032f4:	8b 73 04             	mov    0x4(%ebx),%esi
  1032f7:	85 f6                	test   %esi,%esi
  1032f9:	74 25                	je     103320 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1032fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1032fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103301:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103304:	89 ec                	mov    %ebp,%esp
  103306:	5d                   	pop    %ebp
  103307:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  103308:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  10330b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  103311:	89 04 24             	mov    %eax,(%esp)
  103314:	e8 d7 02 00 00       	call   1035f0 <wakeup>
  103319:	eb cb                	jmp    1032e6 <pipeclose+0x36>
  10331b:	90                   	nop
  10331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103320:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  103323:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103326:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10332d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103330:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103333:	89 ec                	mov    %ebp,%esp
  103335:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103336:	e9 55 f3 ff ff       	jmp    102690 <kfree>
  10333b:	90                   	nop
  10333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103340 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103340:	55                   	push   %ebp
  103341:	89 e5                	mov    %esp,%ebp
  103343:	57                   	push   %edi
  103344:	56                   	push   %esi
  103345:	53                   	push   %ebx
  103346:	83 ec 1c             	sub    $0x1c,%esp
  103349:	8b 75 08             	mov    0x8(%ebp),%esi
  10334c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  10334f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  103355:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  10335b:	e8 f0 dc ff ff       	call   101050 <filealloc>
  103360:	85 c0                	test   %eax,%eax
  103362:	89 06                	mov    %eax,(%esi)
  103364:	0f 84 92 00 00 00    	je     1033fc <pipealloc+0xbc>
  10336a:	e8 e1 dc ff ff       	call   101050 <filealloc>
  10336f:	85 c0                	test   %eax,%eax
  103371:	89 03                	mov    %eax,(%ebx)
  103373:	74 73                	je     1033e8 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  103375:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  10337c:	e8 4f f2 ff ff       	call   1025d0 <kalloc>
  103381:	85 c0                	test   %eax,%eax
  103383:	89 c7                	mov    %eax,%edi
  103385:	74 61                	je     1033e8 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  103387:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  10338d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  103394:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  10339b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  1033a2:	8d 40 10             	lea    0x10(%eax),%eax
  1033a5:	89 04 24             	mov    %eax,(%esp)
  1033a8:	c7 44 24 04 e0 6d 10 	movl   $0x106de0,0x4(%esp)
  1033af:	00 
  1033b0:	e8 bb 11 00 00       	call   104570 <initlock>
  (*f0)->type = FD_PIPE;
  1033b5:	8b 06                	mov    (%esi),%eax
  1033b7:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  1033bd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  1033c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1033c5:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1033c8:	8b 03                	mov    (%ebx),%eax
  1033ca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  1033d0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  1033d4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1033d8:	89 78 0c             	mov    %edi,0xc(%eax)
  1033db:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  1033dd:	83 c4 1c             	add    $0x1c,%esp
  1033e0:	5b                   	pop    %ebx
  1033e1:	5e                   	pop    %esi
  1033e2:	5f                   	pop    %edi
  1033e3:	5d                   	pop    %ebp
  1033e4:	c3                   	ret    
  1033e5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1033e8:	8b 06                	mov    (%esi),%eax
  1033ea:	85 c0                	test   %eax,%eax
  1033ec:	74 0e                	je     1033fc <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  1033ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1033f4:	89 04 24             	mov    %eax,(%esp)
  1033f7:	e8 e4 dc ff ff       	call   1010e0 <fileclose>
  }
  if(*f1){
  1033fc:	8b 13                	mov    (%ebx),%edx
  1033fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103403:	85 d2                	test   %edx,%edx
  103405:	74 d6                	je     1033dd <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  103407:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  10340d:	89 14 24             	mov    %edx,(%esp)
  103410:	e8 cb dc ff ff       	call   1010e0 <fileclose>
  103415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10341a:	eb c1                	jmp    1033dd <pipealloc+0x9d>
  10341c:	90                   	nop
  10341d:	90                   	nop
  10341e:	90                   	nop
  10341f:	90                   	nop

00103420 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103420:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103421:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103426:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103428:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  10342d:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103430:	76 3e                	jbe    103470 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  103432:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103437:	eb 13                	jmp    10344c <wake_lock+0x2c>
  103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103440:	05 9c 00 00 00       	add    $0x9c,%eax
  103445:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10344a:	74 24                	je     103470 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  10344c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103450:	75 ee                	jne    103440 <wake_lock+0x20>
  103452:	39 50 10             	cmp    %edx,0x10(%eax)
  103455:	75 e9                	jne    103440 <wake_lock+0x20>
			p->state = RUNNABLE;
  103457:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10345e:	05 9c 00 00 00       	add    $0x9c,%eax
  103463:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  103468:	75 e2                	jne    10344c <wake_lock+0x2c>
  10346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  103470:	5d                   	pop    %ebp
  103471:	c3                   	ret    
  103472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103480 <tick>:
  }
}

int
tick(void)
{
  103480:	55                   	push   %ebp
return ticks;
}
  103481:	a1 40 f1 10 00       	mov    0x10f140,%eax
  }
}

int
tick(void)
{
  103486:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103488:	5d                   	pop    %ebp
  103489:	c3                   	ret    
  10348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	57                   	push   %edi
  103494:	56                   	push   %esi
  103495:	53                   	push   %ebx
  103496:	bb cc c1 10 00       	mov    $0x10c1cc,%ebx
  10349b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10349e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  1034a1:	eb 50                	jmp    1034f3 <procdump+0x63>
  1034a3:	90                   	nop
  1034a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1034a8:	8b 04 85 a8 6e 10 00 	mov    0x106ea8(,%eax,4),%eax
  1034af:	85 c0                	test   %eax,%eax
  1034b1:	74 4e                	je     103501 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  1034b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034b7:	8b 43 04             	mov    0x4(%ebx),%eax
  1034ba:	81 c2 88 00 00 00    	add    $0x88,%edx
  1034c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1034c4:	c7 04 24 e9 6d 10 00 	movl   $0x106de9,(%esp)
  1034cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034cf:	e8 ec d2 ff ff       	call   1007c0 <cprintf>
    if(p->state == SLEEPING){
  1034d4:	83 3b 02             	cmpl   $0x2,(%ebx)
  1034d7:	74 2f                	je     103508 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1034d9:	c7 04 24 93 6d 10 00 	movl   $0x106d93,(%esp)
  1034e0:	e8 db d2 ff ff       	call   1007c0 <cprintf>
  1034e5:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1034eb:	81 fb cc e8 10 00    	cmp    $0x10e8cc,%ebx
  1034f1:	74 55                	je     103548 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  1034f3:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  1034f5:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1034f8:	85 c0                	test   %eax,%eax
  1034fa:	74 e9                	je     1034e5 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1034fc:	83 f8 05             	cmp    $0x5,%eax
  1034ff:	76 a7                	jbe    1034a8 <procdump+0x18>
  103501:	b8 e5 6d 10 00       	mov    $0x106de5,%eax
  103506:	eb ab                	jmp    1034b3 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103508:	8b 43 74             	mov    0x74(%ebx),%eax
  10350b:	31 f6                	xor    %esi,%esi
  10350d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103511:	83 c0 08             	add    $0x8,%eax
  103514:	89 04 24             	mov    %eax,(%esp)
  103517:	e8 74 10 00 00       	call   104590 <getcallerpcs>
  10351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103520:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103523:	85 c0                	test   %eax,%eax
  103525:	74 b2                	je     1034d9 <procdump+0x49>
  103527:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  10352a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352e:	c7 04 24 35 69 10 00 	movl   $0x106935,(%esp)
  103535:	e8 86 d2 ff ff       	call   1007c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10353a:	83 fe 0a             	cmp    $0xa,%esi
  10353d:	75 e1                	jne    103520 <procdump+0x90>
  10353f:	eb 98                	jmp    1034d9 <procdump+0x49>
  103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103548:	83 c4 4c             	add    $0x4c,%esp
  10354b:	5b                   	pop    %ebx
  10354c:	5e                   	pop    %esi
  10354d:	5f                   	pop    %edi
  10354e:	5d                   	pop    %ebp
  10354f:	90                   	nop
  103550:	c3                   	ret    
  103551:	eb 0d                	jmp    103560 <kill>
  103553:	90                   	nop
  103554:	90                   	nop
  103555:	90                   	nop
  103556:	90                   	nop
  103557:	90                   	nop
  103558:	90                   	nop
  103559:	90                   	nop
  10355a:	90                   	nop
  10355b:	90                   	nop
  10355c:	90                   	nop
  10355d:	90                   	nop
  10355e:	90                   	nop
  10355f:	90                   	nop

00103560 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103560:	55                   	push   %ebp
  103561:	89 e5                	mov    %esp,%ebp
  103563:	53                   	push   %ebx
  103564:	83 ec 14             	sub    $0x14,%esp
  103567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10356a:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103571:	e8 ba 11 00 00       	call   104730 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103576:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  10357b:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  103580:	76 56                	jbe    1035d8 <kill+0x78>
    if(p->pid == pid){
  103582:	39 1d d0 c1 10 00    	cmp    %ebx,0x10c1d0

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103588:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10358d:	74 12                	je     1035a1 <kill+0x41>
  10358f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  103590:	05 9c 00 00 00       	add    $0x9c,%eax
  103595:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10359a:	74 3c                	je     1035d8 <kill+0x78>
    if(p->pid == pid){
  10359c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10359f:	75 ef                	jne    103590 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1035a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  1035a5:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1035ac:	74 1a                	je     1035c8 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1035ae:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1035b5:	e8 36 11 00 00       	call   1046f0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1035ba:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1035bd:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1035bf:	5b                   	pop    %ebx
  1035c0:	5d                   	pop    %ebp
  1035c1:	c3                   	ret    
  1035c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1035c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1035cf:	eb dd                	jmp    1035ae <kill+0x4e>
  1035d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1035d8:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1035df:	e8 0c 11 00 00       	call   1046f0 <release>
  return -1;
}
  1035e4:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1035e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1035ec:	5b                   	pop    %ebx
  1035ed:	5d                   	pop    %ebp
  1035ee:	c3                   	ret    
  1035ef:	90                   	nop

001035f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1035f0:	55                   	push   %ebp
  1035f1:	89 e5                	mov    %esp,%ebp
  1035f3:	53                   	push   %ebx
  1035f4:	83 ec 14             	sub    $0x14,%esp
  1035f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1035fa:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103601:	e8 2a 11 00 00       	call   104730 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103606:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  10360b:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  103610:	76 3e                	jbe    103650 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  103612:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103617:	eb 13                	jmp    10362c <wakeup+0x3c>
  103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103620:	05 9c 00 00 00       	add    $0x9c,%eax
  103625:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10362a:	74 24                	je     103650 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  10362c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103630:	75 ee                	jne    103620 <wakeup+0x30>
  103632:	3b 58 18             	cmp    0x18(%eax),%ebx
  103635:	75 e9                	jne    103620 <wakeup+0x30>
      p->state = RUNNABLE;
  103637:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10363e:	05 9c 00 00 00       	add    $0x9c,%eax
  103643:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  103648:	75 e2                	jne    10362c <wakeup+0x3c>
  10364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103650:	c7 45 08 c0 e8 10 00 	movl   $0x10e8c0,0x8(%ebp)
}
  103657:	83 c4 14             	add    $0x14,%esp
  10365a:	5b                   	pop    %ebx
  10365b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  10365c:	e9 8f 10 00 00       	jmp    1046f0 <release>
  103661:	eb 0d                	jmp    103670 <allocproc>
  103663:	90                   	nop
  103664:	90                   	nop
  103665:	90                   	nop
  103666:	90                   	nop
  103667:	90                   	nop
  103668:	90                   	nop
  103669:	90                   	nop
  10366a:	90                   	nop
  10366b:	90                   	nop
  10366c:	90                   	nop
  10366d:	90                   	nop
  10366e:	90                   	nop
  10366f:	90                   	nop

00103670 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103670:	55                   	push   %ebp
  103671:	89 e5                	mov    %esp,%ebp
  103673:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103674:	bb c0 c1 10 00       	mov    $0x10c1c0,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103679:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10367c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103683:	e8 a8 10 00 00       	call   104730 <acquire>
  103688:	eb 14                	jmp    10369e <allocproc+0x2e>
  10368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103690:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103696:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  10369c:	74 32                	je     1036d0 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10369e:	8b 43 0c             	mov    0xc(%ebx),%eax
  1036a1:	85 c0                	test   %eax,%eax
  1036a3:	75 eb                	jne    103690 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  1036a5:	a1 84 83 10 00       	mov    0x108384,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  1036aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  1036b1:	89 43 10             	mov    %eax,0x10(%ebx)
  1036b4:	83 c0 01             	add    $0x1,%eax
  1036b7:	a3 84 83 10 00       	mov    %eax,0x108384
      release(&proc_table_lock);
  1036bc:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1036c3:	e8 28 10 00 00       	call   1046f0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  1036c8:	89 d8                	mov    %ebx,%eax
  1036ca:	83 c4 14             	add    $0x14,%esp
  1036cd:	5b                   	pop    %ebx
  1036ce:	5d                   	pop    %ebp
  1036cf:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  1036d0:	31 db                	xor    %ebx,%ebx
  1036d2:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1036d9:	e8 12 10 00 00       	call   1046f0 <release>
  return 0;
}
  1036de:	89 d8                	mov    %ebx,%eax
  1036e0:	83 c4 14             	add    $0x14,%esp
  1036e3:	5b                   	pop    %ebx
  1036e4:	5d                   	pop    %ebp
  1036e5:	c3                   	ret    
  1036e6:	8d 76 00             	lea    0x0(%esi),%esi
  1036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001036f0 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  1036f0:	55                   	push   %ebp
  1036f1:	89 e5                	mov    %esp,%ebp
  1036f3:	53                   	push   %ebx
  1036f4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  1036f7:	e8 64 0f 00 00       	call   104660 <pushcli>
  p = cpus[cpu()].curproc;
  1036fc:	e8 5f f4 ff ff       	call   102b60 <cpu>
  103701:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103707:	8b 98 44 bb 10 00    	mov    0x10bb44(%eax),%ebx
  popcli();
  10370d:	e8 ce 0e 00 00       	call   1045e0 <popcli>
  return p;
}
  103712:	83 c4 04             	add    $0x4,%esp
  103715:	89 d8                	mov    %ebx,%eax
  103717:	5b                   	pop    %ebx
  103718:	5d                   	pop    %ebp
  103719:	c3                   	ret    
  10371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103720 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103720:	55                   	push   %ebp
  103721:	89 e5                	mov    %esp,%ebp
  103723:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103726:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  10372d:	e8 be 0f 00 00       	call   1046f0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103732:	e8 b9 ff ff ff       	call   1036f0 <curproc>
  103737:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10373d:	89 04 24             	mov    %eax,(%esp)
  103740:	e8 c7 23 00 00       	call   105b0c <forkret1>
}
  103745:	c9                   	leave  
  103746:	c3                   	ret    
  103747:	89 f6                	mov    %esi,%esi
  103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103750 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103750:	55                   	push   %ebp
  103751:	89 e5                	mov    %esp,%ebp
  103753:	53                   	push   %ebx
  103754:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103757:	9c                   	pushf  
  103758:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103759:	f6 c4 02             	test   $0x2,%ah
  10375c:	75 5c                	jne    1037ba <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10375e:	e8 8d ff ff ff       	call   1036f0 <curproc>
  103763:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103767:	74 75                	je     1037de <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103769:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103770:	e8 3b 0f 00 00       	call   1046b0 <holding>
  103775:	85 c0                	test   %eax,%eax
  103777:	74 59                	je     1037d2 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103779:	e8 e2 f3 ff ff       	call   102b60 <cpu>
  10377e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103784:	83 b8 04 bc 10 00 01 	cmpl   $0x1,0x10bc04(%eax)
  10378b:	75 39                	jne    1037c6 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10378d:	e8 ce f3 ff ff       	call   102b60 <cpu>
  103792:	89 c3                	mov    %eax,%ebx
  103794:	e8 57 ff ff ff       	call   1036f0 <curproc>
  103799:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10379f:	81 c3 48 bb 10 00    	add    $0x10bb48,%ebx
  1037a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1037a9:	83 c0 64             	add    $0x64,%eax
  1037ac:	89 04 24             	mov    %eax,(%esp)
  1037af:	e8 e8 11 00 00       	call   10499c <swtch>
}
  1037b4:	83 c4 14             	add    $0x14,%esp
  1037b7:	5b                   	pop    %ebx
  1037b8:	5d                   	pop    %ebp
  1037b9:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  1037ba:	c7 04 24 f2 6d 10 00 	movl   $0x106df2,(%esp)
  1037c1:	e8 9a d1 ff ff       	call   100960 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  1037c6:	c7 04 24 2a 6e 10 00 	movl   $0x106e2a,(%esp)
  1037cd:	e8 8e d1 ff ff       	call   100960 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  1037d2:	c7 04 24 14 6e 10 00 	movl   $0x106e14,(%esp)
  1037d9:	e8 82 d1 ff ff       	call   100960 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  1037de:	c7 04 24 06 6e 10 00 	movl   $0x106e06,(%esp)
  1037e5:	e8 76 d1 ff ff       	call   100960 <panic>
  1037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001037f0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1037f0:	55                   	push   %ebp
  1037f1:	89 e5                	mov    %esp,%ebp
  1037f3:	56                   	push   %esi
  1037f4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1037f5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1037f7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  1037fa:	e8 f1 fe ff ff       	call   1036f0 <curproc>
  1037ff:	3b 05 c8 88 10 00    	cmp    0x1088c8,%eax
  103805:	0f 84 36 01 00 00    	je     103941 <exit+0x151>
  10380b:	90                   	nop
  10380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103810:	e8 db fe ff ff       	call   1036f0 <curproc>
  103815:	8d 73 08             	lea    0x8(%ebx),%esi
  103818:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  10381b:	85 d2                	test   %edx,%edx
  10381d:	74 1c                	je     10383b <exit+0x4b>
      fileclose(cp->ofile[fd]);
  10381f:	e8 cc fe ff ff       	call   1036f0 <curproc>
  103824:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  103827:	89 04 24             	mov    %eax,(%esp)
  10382a:	e8 b1 d8 ff ff       	call   1010e0 <fileclose>
      cp->ofile[fd] = 0;
  10382f:	e8 bc fe ff ff       	call   1036f0 <curproc>
  103834:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  10383b:	83 c3 01             	add    $0x1,%ebx
  10383e:	83 fb 10             	cmp    $0x10,%ebx
  103841:	75 cd                	jne    103810 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103843:	e8 a8 fe ff ff       	call   1036f0 <curproc>
  103848:	8b 40 60             	mov    0x60(%eax),%eax
  10384b:	89 04 24             	mov    %eax,(%esp)
  10384e:	e8 9d e3 ff ff       	call   101bf0 <iput>
  cp->cwd = 0;
  103853:	e8 98 fe ff ff       	call   1036f0 <curproc>
  103858:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  10385f:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103866:	e8 c5 0e 00 00       	call   104730 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10386b:	e8 80 fe ff ff       	call   1036f0 <curproc>
  103870:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103873:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  103878:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  10387d:	0f 86 95 00 00 00    	jbe    103918 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103883:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103888:	eb 12                	jmp    10389c <exit+0xac>
  10388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103890:	05 9c 00 00 00       	add    $0x9c,%eax
  103895:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10389a:	74 1e                	je     1038ba <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  10389c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1038a0:	75 ee                	jne    103890 <exit+0xa0>
  1038a2:	3b 50 18             	cmp    0x18(%eax),%edx
  1038a5:	75 e9                	jne    103890 <exit+0xa0>
      p->state = RUNNABLE;
  1038a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1038ae:	05 9c 00 00 00       	add    $0x9c,%eax
  1038b3:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  1038b8:	75 e2                	jne    10389c <exit+0xac>
  1038ba:	bb c0 c1 10 00       	mov    $0x10c1c0,%ebx
  1038bf:	eb 15                	jmp    1038d6 <exit+0xe6>
  1038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  1038c8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  1038ce:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  1038d4:	74 42                	je     103918 <exit+0x128>
    if(p->parent == cp){
  1038d6:	8b 73 14             	mov    0x14(%ebx),%esi
  1038d9:	e8 12 fe ff ff       	call   1036f0 <curproc>
  1038de:	39 c6                	cmp    %eax,%esi
  1038e0:	75 e6                	jne    1038c8 <exit+0xd8>
      p->parent = initproc;
  1038e2:	8b 15 c8 88 10 00    	mov    0x1088c8,%edx
      if(p->state == ZOMBIE)
  1038e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  1038ec:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  1038ef:	75 d7                	jne    1038c8 <exit+0xd8>
  1038f1:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  1038f6:	eb 0c                	jmp    103904 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1038f8:	05 9c 00 00 00       	add    $0x9c,%eax
  1038fd:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  103902:	74 c4                	je     1038c8 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  103904:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103908:	75 ee                	jne    1038f8 <exit+0x108>
  10390a:	3b 50 18             	cmp    0x18(%eax),%edx
  10390d:	75 e9                	jne    1038f8 <exit+0x108>
      p->state = RUNNABLE;
  10390f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103916:	eb e0                	jmp    1038f8 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103918:	e8 d3 fd ff ff       	call   1036f0 <curproc>
  10391d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  103924:	e8 c7 fd ff ff       	call   1036f0 <curproc>
  103929:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103930:	e8 1b fe ff ff       	call   103750 <sched>
  panic("zombie exit");
  103935:	c7 04 24 43 6e 10 00 	movl   $0x106e43,(%esp)
  10393c:	e8 1f d0 ff ff       	call   100960 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103941:	c7 04 24 36 6e 10 00 	movl   $0x106e36,(%esp)
  103948:	e8 13 d0 ff ff       	call   100960 <panic>
  10394d:	8d 76 00             	lea    0x0(%esi),%esi

00103950 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  103950:	55                   	push   %ebp
  103951:	89 e5                	mov    %esp,%ebp
  103953:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  103956:	e8 95 fd ff ff       	call   1036f0 <curproc>
  10395b:	85 c0                	test   %eax,%eax
  10395d:	74 2b                	je     10398a <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  10395f:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103966:	e8 c5 0d 00 00       	call   104730 <acquire>
  cp->state = SLEEPING;
  10396b:	e8 80 fd ff ff       	call   1036f0 <curproc>
  103970:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  103977:	e8 d4 fd ff ff       	call   103750 <sched>
	release(&proc_table_lock); 
  10397c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103983:	e8 68 0d 00 00       	call   1046f0 <release>
}
  103988:	c9                   	leave  
  103989:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  10398a:	c7 04 24 4f 6e 10 00 	movl   $0x106e4f,(%esp)
  103991:	e8 ca cf ff ff       	call   100960 <panic>
  103996:	8d 76 00             	lea    0x0(%esi),%esi
  103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001039a0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1039a0:	55                   	push   %ebp
  1039a1:	89 e5                	mov    %esp,%ebp
  1039a3:	56                   	push   %esi
  1039a4:	53                   	push   %ebx
  1039a5:	83 ec 10             	sub    $0x10,%esp
  1039a8:	8b 75 08             	mov    0x8(%ebp),%esi
  1039ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1039ae:	e8 3d fd ff ff       	call   1036f0 <curproc>
  1039b3:	85 c0                	test   %eax,%eax
  1039b5:	0f 84 9d 00 00 00    	je     103a58 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  1039bb:	85 db                	test   %ebx,%ebx
  1039bd:	0f 84 89 00 00 00    	je     103a4c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  1039c3:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  1039c9:	74 55                	je     103a20 <sleep+0x80>
    acquire(&proc_table_lock);
  1039cb:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1039d2:	e8 59 0d 00 00       	call   104730 <acquire>
    release(lk);
  1039d7:	89 1c 24             	mov    %ebx,(%esp)
  1039da:	e8 11 0d 00 00       	call   1046f0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  1039df:	e8 0c fd ff ff       	call   1036f0 <curproc>
  1039e4:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  1039e7:	e8 04 fd ff ff       	call   1036f0 <curproc>
  1039ec:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  1039f3:	e8 58 fd ff ff       	call   103750 <sched>

  // Tidy up.
  cp->chan = 0;
  1039f8:	e8 f3 fc ff ff       	call   1036f0 <curproc>
  1039fd:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103a04:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103a0b:	e8 e0 0c 00 00       	call   1046f0 <release>
    acquire(lk);
  103a10:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103a13:	83 c4 10             	add    $0x10,%esp
  103a16:	5b                   	pop    %ebx
  103a17:	5e                   	pop    %esi
  103a18:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103a19:	e9 12 0d 00 00       	jmp    104730 <acquire>
  103a1e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103a20:	e8 cb fc ff ff       	call   1036f0 <curproc>
  103a25:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103a28:	e8 c3 fc ff ff       	call   1036f0 <curproc>
  103a2d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103a34:	e8 17 fd ff ff       	call   103750 <sched>

  // Tidy up.
  cp->chan = 0;
  103a39:	e8 b2 fc ff ff       	call   1036f0 <curproc>
  103a3e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103a45:	83 c4 10             	add    $0x10,%esp
  103a48:	5b                   	pop    %ebx
  103a49:	5e                   	pop    %esi
  103a4a:	5d                   	pop    %ebp
  103a4b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  103a4c:	c7 04 24 55 6e 10 00 	movl   $0x106e55,(%esp)
  103a53:	e8 08 cf ff ff       	call   100960 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103a58:	c7 04 24 4f 6e 10 00 	movl   $0x106e4f,(%esp)
  103a5f:	e8 fc ce ff ff       	call   100960 <panic>
  103a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103a70 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a70:	55                   	push   %ebp
  103a71:	89 e5                	mov    %esp,%ebp
  103a73:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a74:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a76:	56                   	push   %esi
  103a77:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a78:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a7a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a7d:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103a84:	e8 a7 0c 00 00       	call   104730 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a89:	83 fb 3f             	cmp    $0x3f,%ebx
  103a8c:	7e 2f                	jle    103abd <wait_thread+0x4d>
  103a8e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103a90:	85 ff                	test   %edi,%edi
  103a92:	74 74                	je     103b08 <wait_thread+0x98>
  103a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103a98:	e8 53 fc ff ff       	call   1036f0 <curproc>
  103a9d:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103aa0:	85 c9                	test   %ecx,%ecx
  103aa2:	75 64                	jne    103b08 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103aa4:	e8 47 fc ff ff       	call   1036f0 <curproc>
  103aa9:	31 ff                	xor    %edi,%edi
  103aab:	31 db                	xor    %ebx,%ebx
  103aad:	c7 44 24 04 c0 e8 10 	movl   $0x10e8c0,0x4(%esp)
  103ab4:	00 
  103ab5:	89 04 24             	mov    %eax,(%esp)
  103ab8:	e8 e3 fe ff ff       	call   1039a0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103abd:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103ac3:	81 c6 c0 c1 10 00    	add    $0x10c1c0,%esi
      if(p->state == UNUSED)
  103ac9:	8b 46 0c             	mov    0xc(%esi),%eax
  103acc:	85 c0                	test   %eax,%eax
  103ace:	75 10                	jne    103ae0 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103ad0:	83 c3 01             	add    $0x1,%ebx
  103ad3:	83 fb 3f             	cmp    $0x3f,%ebx
  103ad6:	7e e5                	jle    103abd <wait_thread+0x4d>
  103ad8:	eb b6                	jmp    103a90 <wait_thread+0x20>
  103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103ae0:	8b 46 14             	mov    0x14(%esi),%eax
  103ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ae6:	e8 05 fc ff ff       	call   1036f0 <curproc>
  103aeb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103aee:	66 90                	xchg   %ax,%ax
  103af0:	75 de                	jne    103ad0 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103af2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103af6:	74 29                	je     103b21 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103af8:	bf 01 00 00 00       	mov    $0x1,%edi
  103afd:	8d 76 00             	lea    0x0(%esi),%esi
  103b00:	eb ce                	jmp    103ad0 <wait_thread+0x60>
  103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103b08:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103b0f:	e8 dc 0b 00 00       	call   1046f0 <release>
  103b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103b19:	83 c4 2c             	add    $0x2c,%esp
  103b1c:	5b                   	pop    %ebx
  103b1d:	5e                   	pop    %esi
  103b1e:	5f                   	pop    %edi
  103b1f:	5d                   	pop    %ebp
  103b20:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103b21:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b28:	00 
  103b29:	8b 46 08             	mov    0x8(%esi),%eax
  103b2c:	89 04 24             	mov    %eax,(%esp)
  103b2f:	e8 5c eb ff ff       	call   102690 <kfree>
          pid = p->pid;
  103b34:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103b37:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103b3e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103b45:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103b4c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103b53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103b56:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103b5d:	e8 8e 0b 00 00       	call   1046f0 <release>
          return pid;
  103b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b65:	eb b2                	jmp    103b19 <wait_thread+0xa9>
  103b67:	89 f6                	mov    %esi,%esi
  103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103b70 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b70:	55                   	push   %ebp
  103b71:	89 e5                	mov    %esp,%ebp
  103b73:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b74:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b76:	56                   	push   %esi
  103b77:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b78:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b7a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b7d:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103b84:	e8 a7 0b 00 00       	call   104730 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b89:	83 fb 3f             	cmp    $0x3f,%ebx
  103b8c:	7e 2f                	jle    103bbd <wait+0x4d>
  103b8e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103b90:	85 ff                	test   %edi,%edi
  103b92:	74 74                	je     103c08 <wait+0x98>
  103b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103b98:	e8 53 fb ff ff       	call   1036f0 <curproc>
  103b9d:	8b 50 1c             	mov    0x1c(%eax),%edx
  103ba0:	85 d2                	test   %edx,%edx
  103ba2:	75 64                	jne    103c08 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103ba4:	e8 47 fb ff ff       	call   1036f0 <curproc>
  103ba9:	31 ff                	xor    %edi,%edi
  103bab:	31 db                	xor    %ebx,%ebx
  103bad:	c7 44 24 04 c0 e8 10 	movl   $0x10e8c0,0x4(%esp)
  103bb4:	00 
  103bb5:	89 04 24             	mov    %eax,(%esp)
  103bb8:	e8 e3 fd ff ff       	call   1039a0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103bbd:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103bc3:	81 c6 c0 c1 10 00    	add    $0x10c1c0,%esi
      if(p->state == UNUSED)
  103bc9:	8b 4e 0c             	mov    0xc(%esi),%ecx
  103bcc:	85 c9                	test   %ecx,%ecx
  103bce:	75 10                	jne    103be0 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103bd0:	83 c3 01             	add    $0x1,%ebx
  103bd3:	83 fb 3f             	cmp    $0x3f,%ebx
  103bd6:	7e e5                	jle    103bbd <wait+0x4d>
  103bd8:	eb b6                	jmp    103b90 <wait+0x20>
  103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103be0:	8b 46 14             	mov    0x14(%esi),%eax
  103be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103be6:	e8 05 fb ff ff       	call   1036f0 <curproc>
  103beb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103bee:	66 90                	xchg   %ax,%ax
  103bf0:	75 de                	jne    103bd0 <wait+0x60>
        if(p->state == ZOMBIE){
  103bf2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103bf6:	74 29                	je     103c21 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103bf8:	bf 01 00 00 00       	mov    $0x1,%edi
  103bfd:	8d 76 00             	lea    0x0(%esi),%esi
  103c00:	eb ce                	jmp    103bd0 <wait+0x60>
  103c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103c08:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c0f:	e8 dc 0a 00 00       	call   1046f0 <release>
  103c14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103c19:	83 c4 2c             	add    $0x2c,%esp
  103c1c:	5b                   	pop    %ebx
  103c1d:	5e                   	pop    %esi
  103c1e:	5f                   	pop    %edi
  103c1f:	5d                   	pop    %ebp
  103c20:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103c21:	8b 46 04             	mov    0x4(%esi),%eax
  103c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c28:	8b 06                	mov    (%esi),%eax
  103c2a:	89 04 24             	mov    %eax,(%esp)
  103c2d:	e8 5e ea ff ff       	call   102690 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103c32:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c39:	00 
  103c3a:	8b 46 08             	mov    0x8(%esi),%eax
  103c3d:	89 04 24             	mov    %eax,(%esp)
  103c40:	e8 4b ea ff ff       	call   102690 <kfree>
          pid = p->pid;
  103c45:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103c48:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103c4f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103c56:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103c5d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c67:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c6e:	e8 7d 0a 00 00       	call   1046f0 <release>
          return pid;
  103c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c76:	eb a1                	jmp    103c19 <wait+0xa9>
  103c78:	90                   	nop
  103c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103c80 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103c80:	55                   	push   %ebp
  103c81:	89 e5                	mov    %esp,%ebp
  103c83:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  103c86:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c8d:	e8 9e 0a 00 00       	call   104730 <acquire>
  cp->state = RUNNABLE;
  103c92:	e8 59 fa ff ff       	call   1036f0 <curproc>
  103c97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103c9e:	e8 ad fa ff ff       	call   103750 <sched>
  release(&proc_table_lock);
  103ca3:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103caa:	e8 41 0a 00 00       	call   1046f0 <release>
}
  103caf:	c9                   	leave  
  103cb0:	c3                   	ret    
  103cb1:	eb 0d                	jmp    103cc0 <setupsegs>
  103cb3:	90                   	nop
  103cb4:	90                   	nop
  103cb5:	90                   	nop
  103cb6:	90                   	nop
  103cb7:	90                   	nop
  103cb8:	90                   	nop
  103cb9:	90                   	nop
  103cba:	90                   	nop
  103cbb:	90                   	nop
  103cbc:	90                   	nop
  103cbd:	90                   	nop
  103cbe:	90                   	nop
  103cbf:	90                   	nop

00103cc0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103cc0:	55                   	push   %ebp
  103cc1:	89 e5                	mov    %esp,%ebp
  103cc3:	57                   	push   %edi
  103cc4:	56                   	push   %esi
  103cc5:	53                   	push   %ebx
  103cc6:	83 ec 2c             	sub    $0x2c,%esp
  103cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103ccc:	e8 8f 09 00 00       	call   104660 <pushcli>
  c = &cpus[cpu()];
  103cd1:	e8 8a ee ff ff       	call   102b60 <cpu>
  103cd6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103cdc:	05 40 bb 10 00       	add    $0x10bb40,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103ce1:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103ce3:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103ce9:	0f 84 a1 01 00 00    	je     103e90 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103cef:	8b 56 08             	mov    0x8(%esi),%edx
  103cf2:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103cf8:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103cfb:	8d 50 28             	lea    0x28(%eax),%edx
  103cfe:	89 d1                	mov    %edx,%ecx
  103d00:	c1 e9 10             	shr    $0x10,%ecx
  103d03:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103d0a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103d0d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103d0f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103d16:	00 00 00 
  103d19:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103d20:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103d23:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103d2a:	0f 01 
  103d2c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103d33:	00 00 
  103d35:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103d3c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103d43:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103d4a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103d51:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103d58:	ff ff 
  103d5a:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103d61:	00 00 
  103d63:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103d6a:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103d71:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103d78:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103d7f:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103d86:	67 00 
  103d88:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103d8e:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103d95:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103d9b:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103da2:	0f 84 b8 00 00 00    	je     103e60 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103da8:	8b 16                	mov    (%esi),%edx
  103daa:	8b 5e 04             	mov    0x4(%esi),%ebx
  103dad:	89 d6                	mov    %edx,%esi
  103daf:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103db2:	89 d3                	mov    %edx,%ebx
  103db4:	c1 ee 10             	shr    $0x10,%esi
  103db7:	89 cf                	mov    %ecx,%edi
  103db9:	c1 eb 18             	shr    $0x18,%ebx
  103dbc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103dbf:	89 f3                	mov    %esi,%ebx
  103dc1:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103dc7:	89 cb                	mov    %ecx,%ebx
  103dc9:	c1 eb 1c             	shr    $0x1c,%ebx
  103dcc:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103dce:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103dd1:	83 c9 c0             	or     $0xffffffc0,%ecx
  103dd4:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103ddb:	c1 ef 0c             	shr    $0xc,%edi
  103dde:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103de4:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103de8:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103def:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103df5:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103dfc:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103e02:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103e06:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103e0d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103e0f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103e16:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103e1d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103e23:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103e29:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103e2e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103e34:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103e38:	c1 e8 10             	shr    $0x10,%eax
  103e3b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103e3f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103e42:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103e45:	b8 28 00 00 00       	mov    $0x28,%eax
  103e4a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103e4d:	e8 8e 07 00 00       	call   1045e0 <popcli>
}
  103e52:	83 c4 2c             	add    $0x2c,%esp
  103e55:	5b                   	pop    %ebx
  103e56:	5e                   	pop    %esi
  103e57:	5f                   	pop    %edi
  103e58:	5d                   	pop    %ebp
  103e59:	c3                   	ret    
  103e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103e60:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103e67:	00 00 00 
  103e6a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103e71:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103e74:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103e7b:	00 00 00 
  103e7e:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103e85:	00 00 00 
  103e88:	eb 9f                	jmp    103e29 <setupsegs+0x169>
  103e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103e90:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103e97:	e9 5f fe ff ff       	jmp    103cfb <setupsegs+0x3b>
  103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103ea0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103ea0:	55                   	push   %ebp
  103ea1:	89 e5                	mov    %esp,%ebp
  103ea3:	57                   	push   %edi
  103ea4:	56                   	push   %esi
  103ea5:	53                   	push   %ebx
  103ea6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103ea9:	e8 b2 ec ff ff       	call   102b60 <cpu>
  103eae:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103eb4:	81 c3 40 bb 10 00    	add    $0x10bb40,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103eba:	8d 73 08             	lea    0x8(%ebx),%esi
  103ebd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103ec0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103ec1:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103ec8:	e8 63 08 00 00       	call   104730 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103ecd:	83 3d d0 c1 10 00 01 	cmpl   $0x1,0x10c1d0
  103ed4:	0f 84 c6 00 00 00    	je     103fa0 <scheduler+0x100>
  103eda:	31 d2                	xor    %edx,%edx
  103edc:	31 c0                	xor    %eax,%eax
  103ede:	eb 0e                	jmp    103eee <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103ee0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103ee6:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103eec:	74 1d                	je     103f0b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103eee:	83 ba cc c1 10 00 03 	cmpl   $0x3,0x10c1cc(%edx)
  103ef5:	75 e9                	jne    103ee0 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103ef7:	03 82 58 c2 10 00    	add    0x10c258(%edx),%eax
  103efd:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103f03:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103f09:	75 e3                	jne    103eee <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103f0b:	85 c0                	test   %eax,%eax
  103f0d:	74 16                	je     103f25 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103f0f:	8b 3d 40 f1 10 00    	mov    0x10f140,%edi
  103f15:	89 c1                	mov    %eax,%ecx
  103f17:	c1 e7 08             	shl    $0x8,%edi
  103f1a:	89 fa                	mov    %edi,%edx
  103f1c:	89 f8                	mov    %edi,%eax
  103f1e:	c1 fa 1f             	sar    $0x1f,%edx
  103f21:	f7 f9                	idiv   %ecx
  103f23:	89 d7                	mov    %edx,%edi
  103f25:	b8 cc c1 10 00       	mov    $0x10c1cc,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103f2a:	31 d2                	xor    %edx,%edx
  103f2c:	eb 12                	jmp    103f40 <scheduler+0xa0>
  103f2e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103f30:	39 fa                	cmp    %edi,%edx
  103f32:	7f 1e                	jg     103f52 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103f34:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103f39:	3d cc e8 10 00       	cmp    $0x10e8cc,%eax
  103f3e:	74 4c                	je     103f8c <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103f40:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103f43:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103f46:	75 e8                	jne    103f30 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103f48:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103f4e:	39 fa                	cmp    %edi,%edx
  103f50:	7e e2                	jle    103f34 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103f52:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103f55:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103f58:	89 0c 24             	mov    %ecx,(%esp)
  103f5b:	e8 60 fd ff ff       	call   103cc0 <setupsegs>
    	  p->state = RUNNING;
  103f60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103f63:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103f6a:	83 c1 64             	add    $0x64,%ecx
  103f6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f71:	89 34 24             	mov    %esi,(%esp)
  103f74:	e8 23 0a 00 00       	call   10499c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103f79:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103f80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103f87:	e8 34 fd ff ff       	call   103cc0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103f8c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103f93:	e8 58 07 00 00       	call   1046f0 <release>
  103f98:	e9 23 ff ff ff       	jmp    103ec0 <scheduler+0x20>
  103f9d:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103fa0:	83 3d cc c1 10 00 03 	cmpl   $0x3,0x10c1cc
  103fa7:	0f 85 2d ff ff ff    	jne    103eda <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103fad:	c7 43 04 c0 c1 10 00 	movl   $0x10c1c0,0x4(%ebx)
      setupsegs(p);
  103fb4:	c7 04 24 c0 c1 10 00 	movl   $0x10c1c0,(%esp)
  103fbb:	e8 00 fd ff ff       	call   103cc0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103fc0:	c7 44 24 04 24 c2 10 	movl   $0x10c224,0x4(%esp)
  103fc7:	00 
  103fc8:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103fcb:	c7 05 58 c2 10 00 4b 	movl   $0x4b,0x10c258
  103fd2:	00 00 00 
      p->state = RUNNING;
  103fd5:	c7 05 cc c1 10 00 04 	movl   $0x4,0x10c1cc
  103fdc:	00 00 00 
      swtch(&c->context, &p->context);
  103fdf:	e8 b8 09 00 00       	call   10499c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103fe4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103feb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103ff2:	e8 c9 fc ff ff       	call   103cc0 <setupsegs>
      release(&proc_table_lock);
  103ff7:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103ffe:	e8 ed 06 00 00       	call   1046f0 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  104003:	e9 b8 fe ff ff       	jmp    103ec0 <scheduler+0x20>
  104008:	90                   	nop
  104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104010 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  104010:	55                   	push   %ebp
  104011:	89 e5                	mov    %esp,%ebp
  104013:	57                   	push   %edi
  104014:	56                   	push   %esi
  104015:	53                   	push   %ebx
  104016:	83 ec 1c             	sub    $0x1c,%esp
  104019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  10401c:	e8 cf f6 ff ff       	call   1036f0 <curproc>
  104021:	8b 50 04             	mov    0x4(%eax),%edx
  104024:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  104027:	89 04 24             	mov    %eax,(%esp)
  10402a:	e8 a1 e5 ff ff       	call   1025d0 <kalloc>
  10402f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  104031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104036:	85 f6                	test   %esi,%esi
  104038:	74 7f                	je     1040b9 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  10403a:	e8 b1 f6 ff ff       	call   1036f0 <curproc>
  10403f:	8b 78 04             	mov    0x4(%eax),%edi
  104042:	e8 a9 f6 ff ff       	call   1036f0 <curproc>
  104047:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10404b:	8b 00                	mov    (%eax),%eax
  10404d:	89 34 24             	mov    %esi,(%esp)
  104050:	89 44 24 04          	mov    %eax,0x4(%esp)
  104054:	e8 d7 07 00 00       	call   104830 <memmove>
  memset(newmem + cp->sz, 0, n);
  104059:	e8 92 f6 ff ff       	call   1036f0 <curproc>
  10405e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104062:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104069:	00 
  10406a:	8b 50 04             	mov    0x4(%eax),%edx
  10406d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104070:	89 04 24             	mov    %eax,(%esp)
  104073:	e8 28 07 00 00       	call   1047a0 <memset>
  kfree(cp->mem, cp->sz);
  104078:	e8 73 f6 ff ff       	call   1036f0 <curproc>
  10407d:	8b 78 04             	mov    0x4(%eax),%edi
  104080:	e8 6b f6 ff ff       	call   1036f0 <curproc>
  104085:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104089:	8b 00                	mov    (%eax),%eax
  10408b:	89 04 24             	mov    %eax,(%esp)
  10408e:	e8 fd e5 ff ff       	call   102690 <kfree>
  cp->mem = newmem;
  104093:	e8 58 f6 ff ff       	call   1036f0 <curproc>
  104098:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  10409a:	e8 51 f6 ff ff       	call   1036f0 <curproc>
  10409f:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  1040a2:	e8 49 f6 ff ff       	call   1036f0 <curproc>
  1040a7:	89 04 24             	mov    %eax,(%esp)
  1040aa:	e8 11 fc ff ff       	call   103cc0 <setupsegs>
  return cp->sz - n;
  1040af:	e8 3c f6 ff ff       	call   1036f0 <curproc>
  1040b4:	8b 40 04             	mov    0x4(%eax),%eax
  1040b7:	29 d8                	sub    %ebx,%eax
}
  1040b9:	83 c4 1c             	add    $0x1c,%esp
  1040bc:	5b                   	pop    %ebx
  1040bd:	5e                   	pop    %esi
  1040be:	5f                   	pop    %edi
  1040bf:	5d                   	pop    %ebp
  1040c0:	c3                   	ret    
  1040c1:	eb 0d                	jmp    1040d0 <copyproc_tix>
  1040c3:	90                   	nop
  1040c4:	90                   	nop
  1040c5:	90                   	nop
  1040c6:	90                   	nop
  1040c7:	90                   	nop
  1040c8:	90                   	nop
  1040c9:	90                   	nop
  1040ca:	90                   	nop
  1040cb:	90                   	nop
  1040cc:	90                   	nop
  1040cd:	90                   	nop
  1040ce:	90                   	nop
  1040cf:	90                   	nop

001040d0 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  1040d0:	55                   	push   %ebp
  1040d1:	89 e5                	mov    %esp,%ebp
  1040d3:	57                   	push   %edi
  1040d4:	56                   	push   %esi
  1040d5:	53                   	push   %ebx
  1040d6:	83 ec 1c             	sub    $0x1c,%esp
  1040d9:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1040dc:	e8 8f f5 ff ff       	call   103670 <allocproc>
  1040e1:	85 c0                	test   %eax,%eax
  1040e3:	89 c6                	mov    %eax,%esi
  1040e5:	0f 84 e1 00 00 00    	je     1041cc <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1040eb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1040f2:	e8 d9 e4 ff ff       	call   1025d0 <kalloc>
  1040f7:	85 c0                	test   %eax,%eax
  1040f9:	89 46 08             	mov    %eax,0x8(%esi)
  1040fc:	0f 84 d4 00 00 00    	je     1041d6 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104102:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104107:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104109:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10410f:	0f 84 85 00 00 00    	je     10419a <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  104115:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  104118:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  10411b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104121:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104128:	00 
  104129:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  10412f:	89 04 24             	mov    %eax,(%esp)
  104132:	89 54 24 04          	mov    %edx,0x4(%esp)
  104136:	e8 f5 06 00 00       	call   104830 <memmove>
  
    np->sz = p->sz;
  10413b:	8b 47 04             	mov    0x4(%edi),%eax
  10413e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104141:	89 04 24             	mov    %eax,(%esp)
  104144:	e8 87 e4 ff ff       	call   1025d0 <kalloc>
  104149:	85 c0                	test   %eax,%eax
  10414b:	89 06                	mov    %eax,(%esi)
  10414d:	0f 84 8e 00 00 00    	je     1041e1 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104153:	8b 56 04             	mov    0x4(%esi),%edx
  104156:	31 db                	xor    %ebx,%ebx
  104158:	89 54 24 08          	mov    %edx,0x8(%esp)
  10415c:	8b 17                	mov    (%edi),%edx
  10415e:	89 04 24             	mov    %eax,(%esp)
  104161:	89 54 24 04          	mov    %edx,0x4(%esp)
  104165:	e8 c6 06 00 00       	call   104830 <memmove>
  10416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104170:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104174:	85 c0                	test   %eax,%eax
  104176:	74 0c                	je     104184 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104178:	89 04 24             	mov    %eax,(%esp)
  10417b:	e8 80 ce ff ff       	call   101000 <filedup>
  104180:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104184:	83 c3 01             	add    $0x1,%ebx
  104187:	83 fb 10             	cmp    $0x10,%ebx
  10418a:	75 e4                	jne    104170 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10418c:	8b 47 60             	mov    0x60(%edi),%eax
  10418f:	89 04 24             	mov    %eax,(%esp)
  104192:	e8 79 d0 ff ff       	call   101210 <idup>
  104197:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10419a:	8d 46 64             	lea    0x64(%esi),%eax
  10419d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1041a4:	00 
  1041a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1041ac:	00 
  1041ad:	89 04 24             	mov    %eax,(%esp)
  1041b0:	e8 eb 05 00 00       	call   1047a0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1041b5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1041bb:	c7 46 64 20 37 10 00 	movl   $0x103720,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1041c2:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1041c5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1041cc:	83 c4 1c             	add    $0x1c,%esp
  1041cf:	89 f0                	mov    %esi,%eax
  1041d1:	5b                   	pop    %ebx
  1041d2:	5e                   	pop    %esi
  1041d3:	5f                   	pop    %edi
  1041d4:	5d                   	pop    %ebp
  1041d5:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1041d6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1041dd:	31 f6                	xor    %esi,%esi
    return 0;
  1041df:	eb eb                	jmp    1041cc <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1041e1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1041e8:	00 
  1041e9:	8b 46 08             	mov    0x8(%esi),%eax
  1041ec:	89 04 24             	mov    %eax,(%esp)
  1041ef:	e8 9c e4 ff ff       	call   102690 <kfree>
      np->kstack = 0;
  1041f4:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1041fb:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104202:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104209:	31 f6                	xor    %esi,%esi
      return 0;
  10420b:	eb bf                	jmp    1041cc <copyproc_tix+0xfc>
  10420d:	8d 76 00             	lea    0x0(%esi),%esi

00104210 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  104210:	55                   	push   %ebp
  104211:	89 e5                	mov    %esp,%ebp
  104213:	57                   	push   %edi
  104214:	56                   	push   %esi
  104215:	53                   	push   %ebx
  104216:	83 ec 1c             	sub    $0x1c,%esp
  104219:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  10421c:	e8 4f f4 ff ff       	call   103670 <allocproc>
  104221:	85 c0                	test   %eax,%eax
  104223:	89 c6                	mov    %eax,%esi
  104225:	0f 84 de 00 00 00    	je     104309 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10422b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104232:	e8 99 e3 ff ff       	call   1025d0 <kalloc>
  104237:	85 c0                	test   %eax,%eax
  104239:	89 46 08             	mov    %eax,0x8(%esi)
  10423c:	0f 84 d1 00 00 00    	je     104313 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104242:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104247:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104249:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10424f:	74 61                	je     1042b2 <copyproc_threads+0xa2>
    np->parent = p;
  104251:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104254:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104256:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10425d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104260:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104267:	00 
  104268:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  10426e:	89 04 24             	mov    %eax,(%esp)
  104271:	89 54 24 04          	mov    %edx,0x4(%esp)
  104275:	e8 b6 05 00 00       	call   104830 <memmove>
  
    np->sz = p->sz;
  10427a:	8b 47 04             	mov    0x4(%edi),%eax
  10427d:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104280:	8b 07                	mov    (%edi),%eax
  104282:	89 06                	mov    %eax,(%esi)
  104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104288:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  10428c:	85 c0                	test   %eax,%eax
  10428e:	74 0c                	je     10429c <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  104290:	89 04 24             	mov    %eax,(%esp)
  104293:	e8 68 cd ff ff       	call   101000 <filedup>
  104298:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  10429c:	83 c3 01             	add    $0x1,%ebx
  10429f:	83 fb 10             	cmp    $0x10,%ebx
  1042a2:	75 e4                	jne    104288 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1042a4:	8b 47 60             	mov    0x60(%edi),%eax
  1042a7:	89 04 24             	mov    %eax,(%esp)
  1042aa:	e8 61 cf ff ff       	call   101210 <idup>
  1042af:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1042b2:	8d 46 64             	lea    0x64(%esi),%eax
  1042b5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1042bc:	00 
  1042bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042c4:	00 
  1042c5:	89 04 24             	mov    %eax,(%esp)
  1042c8:	e8 d3 04 00 00       	call   1047a0 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1042d0:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1042d6:	c7 46 64 20 37 10 00 	movl   $0x103720,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1042dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1042e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042e3:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1042e9:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042ec:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  1042ef:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1042f1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1042f8:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1042ff:	8b 40 3c             	mov    0x3c(%eax),%eax
  104302:	8b 4d 14             	mov    0x14(%ebp),%ecx
  104305:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  104309:	83 c4 1c             	add    $0x1c,%esp
  10430c:	89 f0                	mov    %esi,%eax
  10430e:	5b                   	pop    %ebx
  10430f:	5e                   	pop    %esi
  104310:	5f                   	pop    %edi
  104311:	5d                   	pop    %ebp
  104312:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104313:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10431a:	31 f6                	xor    %esi,%esi
    return 0;
  10431c:	eb eb                	jmp    104309 <copyproc_threads+0xf9>
  10431e:	66 90                	xchg   %ax,%ax

00104320 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104320:	55                   	push   %ebp
  104321:	89 e5                	mov    %esp,%ebp
  104323:	57                   	push   %edi
  104324:	56                   	push   %esi
  104325:	53                   	push   %ebx
  104326:	83 ec 1c             	sub    $0x1c,%esp
  104329:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10432c:	e8 3f f3 ff ff       	call   103670 <allocproc>
  104331:	85 c0                	test   %eax,%eax
  104333:	89 c6                	mov    %eax,%esi
  104335:	0f 84 e1 00 00 00    	je     10441c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10433b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104342:	e8 89 e2 ff ff       	call   1025d0 <kalloc>
  104347:	85 c0                	test   %eax,%eax
  104349:	89 46 08             	mov    %eax,0x8(%esi)
  10434c:	0f 84 d4 00 00 00    	je     104426 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104352:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104357:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104359:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10435f:	0f 84 85 00 00 00    	je     1043ea <copyproc+0xca>
    np->parent = p;
  104365:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104368:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10436f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104372:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104379:	00 
  10437a:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104380:	89 04 24             	mov    %eax,(%esp)
  104383:	89 54 24 04          	mov    %edx,0x4(%esp)
  104387:	e8 a4 04 00 00       	call   104830 <memmove>
  
    np->sz = p->sz;
  10438c:	8b 47 04             	mov    0x4(%edi),%eax
  10438f:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104392:	89 04 24             	mov    %eax,(%esp)
  104395:	e8 36 e2 ff ff       	call   1025d0 <kalloc>
  10439a:	85 c0                	test   %eax,%eax
  10439c:	89 06                	mov    %eax,(%esi)
  10439e:	0f 84 8d 00 00 00    	je     104431 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1043a4:	8b 56 04             	mov    0x4(%esi),%edx
  1043a7:	31 db                	xor    %ebx,%ebx
  1043a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1043ad:	8b 17                	mov    (%edi),%edx
  1043af:	89 04 24             	mov    %eax,(%esp)
  1043b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1043b6:	e8 75 04 00 00       	call   104830 <memmove>
  1043bb:	90                   	nop
  1043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1043c0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1043c4:	85 c0                	test   %eax,%eax
  1043c6:	74 0c                	je     1043d4 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  1043c8:	89 04 24             	mov    %eax,(%esp)
  1043cb:	e8 30 cc ff ff       	call   101000 <filedup>
  1043d0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1043d4:	83 c3 01             	add    $0x1,%ebx
  1043d7:	83 fb 10             	cmp    $0x10,%ebx
  1043da:	75 e4                	jne    1043c0 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1043dc:	8b 47 60             	mov    0x60(%edi),%eax
  1043df:	89 04 24             	mov    %eax,(%esp)
  1043e2:	e8 29 ce ff ff       	call   101210 <idup>
  1043e7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1043ea:	8d 46 64             	lea    0x64(%esi),%eax
  1043ed:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1043f4:	00 
  1043f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1043fc:	00 
  1043fd:	89 04 24             	mov    %eax,(%esp)
  104400:	e8 9b 03 00 00       	call   1047a0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104405:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10440b:	c7 46 64 20 37 10 00 	movl   $0x103720,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104412:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104415:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10441c:	83 c4 1c             	add    $0x1c,%esp
  10441f:	89 f0                	mov    %esi,%eax
  104421:	5b                   	pop    %ebx
  104422:	5e                   	pop    %esi
  104423:	5f                   	pop    %edi
  104424:	5d                   	pop    %ebp
  104425:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104426:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10442d:	31 f6                	xor    %esi,%esi
    return 0;
  10442f:	eb eb                	jmp    10441c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104431:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104438:	00 
  104439:	8b 46 08             	mov    0x8(%esi),%eax
  10443c:	89 04 24             	mov    %eax,(%esp)
  10443f:	e8 4c e2 ff ff       	call   102690 <kfree>
      np->kstack = 0;
  104444:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10444b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104452:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104459:	31 f6                	xor    %esi,%esi
      return 0;
  10445b:	eb bf                	jmp    10441c <copyproc+0xfc>
  10445d:	8d 76 00             	lea    0x0(%esi),%esi

00104460 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104460:	55                   	push   %ebp
  104461:	89 e5                	mov    %esp,%ebp
  104463:	53                   	push   %ebx
  104464:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104467:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10446e:	e8 ad fe ff ff       	call   104320 <copyproc>
  p->sz = PAGE;
  104473:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10447a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10447c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104483:	e8 48 e1 ff ff       	call   1025d0 <kalloc>
  104488:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10448a:	c7 04 24 66 6e 10 00 	movl   $0x106e66,(%esp)
  104491:	e8 6a dd ff ff       	call   102200 <namei>
  104496:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104499:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1044a0:	00 
  1044a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044a8:	00 
  1044a9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  1044af:	89 04 24             	mov    %eax,(%esp)
  1044b2:	e8 e9 02 00 00       	call   1047a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1044b7:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044bd:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  1044bf:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  1044c6:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1044c9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1044cf:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  1044d5:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  1044db:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  1044de:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044e2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1044e5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044eb:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1044f2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1044f9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104500:	00 
  104501:	c7 44 24 04 88 87 10 	movl   $0x108788,0x4(%esp)
  104508:	00 
  104509:	8b 03                	mov    (%ebx),%eax
  10450b:	89 04 24             	mov    %eax,(%esp)
  10450e:	e8 1d 03 00 00       	call   104830 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104513:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104519:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104520:	00 
  104521:	c7 44 24 04 68 6e 10 	movl   $0x106e68,0x4(%esp)
  104528:	00 
  104529:	89 04 24             	mov    %eax,(%esp)
  10452c:	e8 0f 04 00 00       	call   104940 <safestrcpy>
  p->state = RUNNABLE;
  104531:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104538:	89 1d c8 88 10 00    	mov    %ebx,0x1088c8
}
  10453e:	83 c4 14             	add    $0x14,%esp
  104541:	5b                   	pop    %ebx
  104542:	5d                   	pop    %ebp
  104543:	c3                   	ret    
  104544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10454a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104550 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104550:	55                   	push   %ebp
  104551:	89 e5                	mov    %esp,%ebp
  104553:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104556:	c7 44 24 04 71 6e 10 	movl   $0x106e71,0x4(%esp)
  10455d:	00 
  10455e:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  104565:	e8 06 00 00 00       	call   104570 <initlock>
}
  10456a:	c9                   	leave  
  10456b:	c3                   	ret    
  10456c:	90                   	nop
  10456d:	90                   	nop
  10456e:	90                   	nop
  10456f:	90                   	nop

00104570 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104570:	55                   	push   %ebp
  104571:	89 e5                	mov    %esp,%ebp
  104573:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104576:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10457f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104582:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104589:	5d                   	pop    %ebp
  10458a:	c3                   	ret    
  10458b:	90                   	nop
  10458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104590:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104591:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104593:	89 e5                	mov    %esp,%ebp
  104595:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104596:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104599:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10459c:	83 ea 08             	sub    $0x8,%edx
  10459f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  1045a0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1045a3:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  1045a6:	77 18                	ja     1045c0 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  1045a8:	8b 4a 04             	mov    0x4(%edx),%ecx
  1045ab:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1045ae:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1045b1:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1045b3:	83 f8 0a             	cmp    $0xa,%eax
  1045b6:	75 e8                	jne    1045a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  1045b8:	5b                   	pop    %ebx
  1045b9:	5d                   	pop    %ebp
  1045ba:	c3                   	ret    
  1045bb:	90                   	nop
  1045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1045c0:	83 f8 09             	cmp    $0x9,%eax
  1045c3:	7f f3                	jg     1045b8 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1045c5:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  1045c8:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  1045cb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1045d1:	83 c2 04             	add    $0x4,%edx
  1045d4:	83 f8 0a             	cmp    $0xa,%eax
  1045d7:	75 ef                	jne    1045c8 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  1045d9:	5b                   	pop    %ebx
  1045da:	5d                   	pop    %ebp
  1045db:	c3                   	ret    
  1045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001045e0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1045e0:	55                   	push   %ebp
  1045e1:	89 e5                	mov    %esp,%ebp
  1045e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1045e6:	9c                   	pushf  
  1045e7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1045e8:	f6 c4 02             	test   $0x2,%ah
  1045eb:	75 5f                	jne    10464c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1045ed:	e8 6e e5 ff ff       	call   102b60 <cpu>
  1045f2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1045f8:	05 44 bb 10 00       	add    $0x10bb44,%eax
  1045fd:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104603:	83 ea 01             	sub    $0x1,%edx
  104606:	85 d2                	test   %edx,%edx
  104608:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10460e:	78 30                	js     104640 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104610:	e8 4b e5 ff ff       	call   102b60 <cpu>
  104615:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10461b:	8b 90 04 bc 10 00    	mov    0x10bc04(%eax),%edx
  104621:	85 d2                	test   %edx,%edx
  104623:	74 03                	je     104628 <popcli+0x48>
    sti();
}
  104625:	c9                   	leave  
  104626:	c3                   	ret    
  104627:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104628:	e8 33 e5 ff ff       	call   102b60 <cpu>
  10462d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104633:	8b 80 08 bc 10 00    	mov    0x10bc08(%eax),%eax
  104639:	85 c0                	test   %eax,%eax
  10463b:	74 e8                	je     104625 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10463d:	fb                   	sti    
    sti();
}
  10463e:	c9                   	leave  
  10463f:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104640:	c7 04 24 d7 6e 10 00 	movl   $0x106ed7,(%esp)
  104647:	e8 14 c3 ff ff       	call   100960 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10464c:	c7 04 24 c0 6e 10 00 	movl   $0x106ec0,(%esp)
  104653:	e8 08 c3 ff ff       	call   100960 <panic>
  104658:	90                   	nop
  104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104660 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104660:	55                   	push   %ebp
  104661:	89 e5                	mov    %esp,%ebp
  104663:	53                   	push   %ebx
  104664:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104667:	9c                   	pushf  
  104668:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104669:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10466a:	e8 f1 e4 ff ff       	call   102b60 <cpu>
  10466f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104675:	05 44 bb 10 00       	add    $0x10bb44,%eax
  10467a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104680:	8d 4a 01             	lea    0x1(%edx),%ecx
  104683:	85 d2                	test   %edx,%edx
  104685:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  10468b:	75 17                	jne    1046a4 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  10468d:	e8 ce e4 ff ff       	call   102b60 <cpu>
  104692:	81 e3 00 02 00 00    	and    $0x200,%ebx
  104698:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10469e:	89 98 08 bc 10 00    	mov    %ebx,0x10bc08(%eax)
}
  1046a4:	83 c4 04             	add    $0x4,%esp
  1046a7:	5b                   	pop    %ebx
  1046a8:	5d                   	pop    %ebp
  1046a9:	c3                   	ret    
  1046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001046b0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1046b0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  1046b1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1046b3:	89 e5                	mov    %esp,%ebp
  1046b5:	53                   	push   %ebx
  1046b6:	83 ec 04             	sub    $0x4,%esp
  1046b9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  1046bc:	8b 0a                	mov    (%edx),%ecx
  1046be:	85 c9                	test   %ecx,%ecx
  1046c0:	75 06                	jne    1046c8 <holding+0x18>
}
  1046c2:	83 c4 04             	add    $0x4,%esp
  1046c5:	5b                   	pop    %ebx
  1046c6:	5d                   	pop    %ebp
  1046c7:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1046c8:	8b 5a 08             	mov    0x8(%edx),%ebx
  1046cb:	e8 90 e4 ff ff       	call   102b60 <cpu>
  1046d0:	83 c0 0a             	add    $0xa,%eax
  1046d3:	39 c3                	cmp    %eax,%ebx
  1046d5:	0f 94 c0             	sete   %al
}
  1046d8:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1046db:	0f b6 c0             	movzbl %al,%eax
}
  1046de:	5b                   	pop    %ebx
  1046df:	5d                   	pop    %ebp
  1046e0:	c3                   	ret    
  1046e1:	eb 0d                	jmp    1046f0 <release>
  1046e3:	90                   	nop
  1046e4:	90                   	nop
  1046e5:	90                   	nop
  1046e6:	90                   	nop
  1046e7:	90                   	nop
  1046e8:	90                   	nop
  1046e9:	90                   	nop
  1046ea:	90                   	nop
  1046eb:	90                   	nop
  1046ec:	90                   	nop
  1046ed:	90                   	nop
  1046ee:	90                   	nop
  1046ef:	90                   	nop

001046f0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1046f0:	55                   	push   %ebp
  1046f1:	89 e5                	mov    %esp,%ebp
  1046f3:	53                   	push   %ebx
  1046f4:	83 ec 14             	sub    $0x14,%esp
  1046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1046fa:	89 1c 24             	mov    %ebx,(%esp)
  1046fd:	e8 ae ff ff ff       	call   1046b0 <holding>
  104702:	85 c0                	test   %eax,%eax
  104704:	74 1d                	je     104723 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104706:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10470d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10470f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104716:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104719:	83 c4 14             	add    $0x14,%esp
  10471c:	5b                   	pop    %ebx
  10471d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10471e:	e9 bd fe ff ff       	jmp    1045e0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104723:	c7 04 24 de 6e 10 00 	movl   $0x106ede,(%esp)
  10472a:	e8 31 c2 ff ff       	call   100960 <panic>
  10472f:	90                   	nop

00104730 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104730:	55                   	push   %ebp
  104731:	89 e5                	mov    %esp,%ebp
  104733:	53                   	push   %ebx
  104734:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104737:	e8 24 ff ff ff       	call   104660 <pushcli>
  if(holding(lock))
  10473c:	8b 45 08             	mov    0x8(%ebp),%eax
  10473f:	89 04 24             	mov    %eax,(%esp)
  104742:	e8 69 ff ff ff       	call   1046b0 <holding>
  104747:	85 c0                	test   %eax,%eax
  104749:	75 3d                	jne    104788 <acquire+0x58>
    panic("acquire");
  10474b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10474e:	ba 01 00 00 00       	mov    $0x1,%edx
  104753:	90                   	nop
  104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104758:	89 d0                	mov    %edx,%eax
  10475a:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10475d:	83 f8 01             	cmp    $0x1,%eax
  104760:	74 f6                	je     104758 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  104762:	e8 f9 e3 ff ff       	call   102b60 <cpu>
  104767:	83 c0 0a             	add    $0xa,%eax
  10476a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  10476d:	8b 45 08             	mov    0x8(%ebp),%eax
  104770:	83 c0 0c             	add    $0xc,%eax
  104773:	89 44 24 04          	mov    %eax,0x4(%esp)
  104777:	8d 45 08             	lea    0x8(%ebp),%eax
  10477a:	89 04 24             	mov    %eax,(%esp)
  10477d:	e8 0e fe ff ff       	call   104590 <getcallerpcs>
}
  104782:	83 c4 14             	add    $0x14,%esp
  104785:	5b                   	pop    %ebx
  104786:	5d                   	pop    %ebp
  104787:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104788:	c7 04 24 e6 6e 10 00 	movl   $0x106ee6,(%esp)
  10478f:	e8 cc c1 ff ff       	call   100960 <panic>
  104794:	90                   	nop
  104795:	90                   	nop
  104796:	90                   	nop
  104797:	90                   	nop
  104798:	90                   	nop
  104799:	90                   	nop
  10479a:	90                   	nop
  10479b:	90                   	nop
  10479c:	90                   	nop
  10479d:	90                   	nop
  10479e:	90                   	nop
  10479f:	90                   	nop

001047a0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  1047a0:	55                   	push   %ebp
  1047a1:	89 e5                	mov    %esp,%ebp
  1047a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1047a6:	53                   	push   %ebx
  1047a7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1047aa:	85 c9                	test   %ecx,%ecx
  1047ac:	74 14                	je     1047c2 <memset+0x22>
  1047ae:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  1047b2:	31 d2                	xor    %edx,%edx
  1047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  1047b8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  1047bb:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1047be:	39 ca                	cmp    %ecx,%edx
  1047c0:	75 f6                	jne    1047b8 <memset+0x18>
    *d++ = c;

  return dst;
}
  1047c2:	5b                   	pop    %ebx
  1047c3:	5d                   	pop    %ebp
  1047c4:	c3                   	ret    
  1047c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001047d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  1047d0:	55                   	push   %ebp
  1047d1:	89 e5                	mov    %esp,%ebp
  1047d3:	57                   	push   %edi
  1047d4:	56                   	push   %esi
  1047d5:	53                   	push   %ebx
  1047d6:	8b 55 10             	mov    0x10(%ebp),%edx
  1047d9:	8b 75 08             	mov    0x8(%ebp),%esi
  1047dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1047df:	85 d2                	test   %edx,%edx
  1047e1:	74 2d                	je     104810 <memcmp+0x40>
    if(*s1 != *s2)
  1047e3:	0f b6 1e             	movzbl (%esi),%ebx
  1047e6:	0f b6 0f             	movzbl (%edi),%ecx
  1047e9:	38 cb                	cmp    %cl,%bl
  1047eb:	75 2b                	jne    104818 <memcmp+0x48>
      return *s1 - *s2;
  1047ed:	83 ea 01             	sub    $0x1,%edx
  1047f0:	31 c0                	xor    %eax,%eax
  1047f2:	eb 18                	jmp    10480c <memcmp+0x3c>
  1047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1047f8:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  1047fd:	83 ea 01             	sub    $0x1,%edx
  104800:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  104805:	83 c0 01             	add    $0x1,%eax
  104808:	38 cb                	cmp    %cl,%bl
  10480a:	75 0c                	jne    104818 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10480c:	85 d2                	test   %edx,%edx
  10480e:	75 e8                	jne    1047f8 <memcmp+0x28>
  104810:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104812:	5b                   	pop    %ebx
  104813:	5e                   	pop    %esi
  104814:	5f                   	pop    %edi
  104815:	5d                   	pop    %ebp
  104816:	c3                   	ret    
  104817:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104818:	0f b6 c3             	movzbl %bl,%eax
  10481b:	0f b6 c9             	movzbl %cl,%ecx
  10481e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104820:	5b                   	pop    %ebx
  104821:	5e                   	pop    %esi
  104822:	5f                   	pop    %edi
  104823:	5d                   	pop    %ebp
  104824:	c3                   	ret    
  104825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104830:	55                   	push   %ebp
  104831:	89 e5                	mov    %esp,%ebp
  104833:	57                   	push   %edi
  104834:	56                   	push   %esi
  104835:	53                   	push   %ebx
  104836:	8b 45 08             	mov    0x8(%ebp),%eax
  104839:	8b 75 0c             	mov    0xc(%ebp),%esi
  10483c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10483f:	39 c6                	cmp    %eax,%esi
  104841:	73 2d                	jae    104870 <memmove+0x40>
  104843:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104846:	39 f8                	cmp    %edi,%eax
  104848:	73 26                	jae    104870 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10484a:	85 db                	test   %ebx,%ebx
  10484c:	74 1d                	je     10486b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10484e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104851:	31 d2                	xor    %edx,%edx
  104853:	90                   	nop
  104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104858:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  10485d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104861:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104864:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104867:	85 c9                	test   %ecx,%ecx
  104869:	75 ed                	jne    104858 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10486b:	5b                   	pop    %ebx
  10486c:	5e                   	pop    %esi
  10486d:	5f                   	pop    %edi
  10486e:	5d                   	pop    %ebp
  10486f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104870:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104872:	85 db                	test   %ebx,%ebx
  104874:	74 f5                	je     10486b <memmove+0x3b>
  104876:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104878:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  10487c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  10487f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104882:	39 d3                	cmp    %edx,%ebx
  104884:	75 f2                	jne    104878 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104886:	5b                   	pop    %ebx
  104887:	5e                   	pop    %esi
  104888:	5f                   	pop    %edi
  104889:	5d                   	pop    %ebp
  10488a:	c3                   	ret    
  10488b:	90                   	nop
  10488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104890 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104890:	55                   	push   %ebp
  104891:	89 e5                	mov    %esp,%ebp
  104893:	57                   	push   %edi
  104894:	56                   	push   %esi
  104895:	53                   	push   %ebx
  104896:	8b 7d 10             	mov    0x10(%ebp),%edi
  104899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10489c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10489f:	85 ff                	test   %edi,%edi
  1048a1:	74 3d                	je     1048e0 <strncmp+0x50>
  1048a3:	0f b6 01             	movzbl (%ecx),%eax
  1048a6:	84 c0                	test   %al,%al
  1048a8:	75 18                	jne    1048c2 <strncmp+0x32>
  1048aa:	eb 3c                	jmp    1048e8 <strncmp+0x58>
  1048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1048b0:	83 ef 01             	sub    $0x1,%edi
  1048b3:	74 2b                	je     1048e0 <strncmp+0x50>
    n--, p++, q++;
  1048b5:	83 c1 01             	add    $0x1,%ecx
  1048b8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048bb:	0f b6 01             	movzbl (%ecx),%eax
  1048be:	84 c0                	test   %al,%al
  1048c0:	74 26                	je     1048e8 <strncmp+0x58>
  1048c2:	0f b6 33             	movzbl (%ebx),%esi
  1048c5:	89 f2                	mov    %esi,%edx
  1048c7:	38 d0                	cmp    %dl,%al
  1048c9:	74 e5                	je     1048b0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1048cb:	81 e6 ff 00 00 00    	and    $0xff,%esi
  1048d1:	0f b6 c0             	movzbl %al,%eax
  1048d4:	29 f0                	sub    %esi,%eax
}
  1048d6:	5b                   	pop    %ebx
  1048d7:	5e                   	pop    %esi
  1048d8:	5f                   	pop    %edi
  1048d9:	5d                   	pop    %ebp
  1048da:	c3                   	ret    
  1048db:	90                   	nop
  1048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048e0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1048e2:	5b                   	pop    %ebx
  1048e3:	5e                   	pop    %esi
  1048e4:	5f                   	pop    %edi
  1048e5:	5d                   	pop    %ebp
  1048e6:	c3                   	ret    
  1048e7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048e8:	0f b6 33             	movzbl (%ebx),%esi
  1048eb:	eb de                	jmp    1048cb <strncmp+0x3b>
  1048ed:	8d 76 00             	lea    0x0(%esi),%esi

001048f0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1048f0:	55                   	push   %ebp
  1048f1:	89 e5                	mov    %esp,%ebp
  1048f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048f6:	56                   	push   %esi
  1048f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1048fa:	53                   	push   %ebx
  1048fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  1048fe:	89 c3                	mov    %eax,%ebx
  104900:	eb 09                	jmp    10490b <strncpy+0x1b>
  104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104908:	83 c6 01             	add    $0x1,%esi
  10490b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10490e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104911:	85 d2                	test   %edx,%edx
  104913:	7e 0c                	jle    104921 <strncpy+0x31>
  104915:	0f b6 16             	movzbl (%esi),%edx
  104918:	88 13                	mov    %dl,(%ebx)
  10491a:	83 c3 01             	add    $0x1,%ebx
  10491d:	84 d2                	test   %dl,%dl
  10491f:	75 e7                	jne    104908 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104921:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104923:	85 c9                	test   %ecx,%ecx
  104925:	7e 0c                	jle    104933 <strncpy+0x43>
  104927:	90                   	nop
    *s++ = 0;
  104928:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10492c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10492f:	39 ca                	cmp    %ecx,%edx
  104931:	75 f5                	jne    104928 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104933:	5b                   	pop    %ebx
  104934:	5e                   	pop    %esi
  104935:	5d                   	pop    %ebp
  104936:	c3                   	ret    
  104937:	89 f6                	mov    %esi,%esi
  104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104940 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104940:	55                   	push   %ebp
  104941:	89 e5                	mov    %esp,%ebp
  104943:	8b 55 10             	mov    0x10(%ebp),%edx
  104946:	56                   	push   %esi
  104947:	8b 45 08             	mov    0x8(%ebp),%eax
  10494a:	53                   	push   %ebx
  10494b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10494e:	85 d2                	test   %edx,%edx
  104950:	7e 1f                	jle    104971 <safestrcpy+0x31>
  104952:	89 c1                	mov    %eax,%ecx
  104954:	eb 05                	jmp    10495b <safestrcpy+0x1b>
  104956:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104958:	83 c6 01             	add    $0x1,%esi
  10495b:	83 ea 01             	sub    $0x1,%edx
  10495e:	85 d2                	test   %edx,%edx
  104960:	7e 0c                	jle    10496e <safestrcpy+0x2e>
  104962:	0f b6 1e             	movzbl (%esi),%ebx
  104965:	88 19                	mov    %bl,(%ecx)
  104967:	83 c1 01             	add    $0x1,%ecx
  10496a:	84 db                	test   %bl,%bl
  10496c:	75 ea                	jne    104958 <safestrcpy+0x18>
    ;
  *s = 0;
  10496e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104971:	5b                   	pop    %ebx
  104972:	5e                   	pop    %esi
  104973:	5d                   	pop    %ebp
  104974:	c3                   	ret    
  104975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104980 <strlen>:

int
strlen(const char *s)
{
  104980:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104981:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104983:	89 e5                	mov    %esp,%ebp
  104985:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104988:	80 3a 00             	cmpb   $0x0,(%edx)
  10498b:	74 0c                	je     104999 <strlen+0x19>
  10498d:	8d 76 00             	lea    0x0(%esi),%esi
  104990:	83 c0 01             	add    $0x1,%eax
  104993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104997:	75 f7                	jne    104990 <strlen+0x10>
    ;
  return n;
}
  104999:	5d                   	pop    %ebp
  10499a:	c3                   	ret    
  10499b:	90                   	nop

0010499c <swtch>:
  10499c:	8b 44 24 04          	mov    0x4(%esp),%eax
  1049a0:	8f 00                	popl   (%eax)
  1049a2:	89 60 04             	mov    %esp,0x4(%eax)
  1049a5:	89 58 08             	mov    %ebx,0x8(%eax)
  1049a8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1049ab:	89 50 10             	mov    %edx,0x10(%eax)
  1049ae:	89 70 14             	mov    %esi,0x14(%eax)
  1049b1:	89 78 18             	mov    %edi,0x18(%eax)
  1049b4:	89 68 1c             	mov    %ebp,0x1c(%eax)
  1049b7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1049bb:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1049be:	8b 78 18             	mov    0x18(%eax),%edi
  1049c1:	8b 70 14             	mov    0x14(%eax),%esi
  1049c4:	8b 50 10             	mov    0x10(%eax),%edx
  1049c7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1049ca:	8b 58 08             	mov    0x8(%eax),%ebx
  1049cd:	8b 60 04             	mov    0x4(%eax),%esp
  1049d0:	ff 30                	pushl  (%eax)
  1049d2:	c3                   	ret    
  1049d3:	90                   	nop
  1049d4:	90                   	nop
  1049d5:	90                   	nop
  1049d6:	90                   	nop
  1049d7:	90                   	nop
  1049d8:	90                   	nop
  1049d9:	90                   	nop
  1049da:	90                   	nop
  1049db:	90                   	nop
  1049dc:	90                   	nop
  1049dd:	90                   	nop
  1049de:	90                   	nop
  1049df:	90                   	nop

001049e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1049e0:	55                   	push   %ebp
  1049e1:	89 e5                	mov    %esp,%ebp
  1049e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1049e6:	53                   	push   %ebx
  1049e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  1049ea:	8b 51 04             	mov    0x4(%ecx),%edx
  1049ed:	39 c2                	cmp    %eax,%edx
  1049ef:	77 0f                	ja     104a00 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1049f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1049f6:	5b                   	pop    %ebx
  1049f7:	5d                   	pop    %ebp
  1049f8:	c3                   	ret    
  1049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104a00:	8d 58 04             	lea    0x4(%eax),%ebx
  104a03:	39 da                	cmp    %ebx,%edx
  104a05:	72 ea                	jb     1049f1 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104a07:	8b 11                	mov    (%ecx),%edx
  104a09:	8b 14 02             	mov    (%edx,%eax,1),%edx
  104a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  104a0f:	89 10                	mov    %edx,(%eax)
  104a11:	31 c0                	xor    %eax,%eax
  return 0;
  104a13:	eb e1                	jmp    1049f6 <fetchint+0x16>
  104a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104a20 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104a20:	55                   	push   %ebp
  104a21:	89 e5                	mov    %esp,%ebp
  104a23:	8b 45 08             	mov    0x8(%ebp),%eax
  104a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a29:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  104a2a:	39 50 04             	cmp    %edx,0x4(%eax)
  104a2d:	77 09                	ja     104a38 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104a2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104a34:	5b                   	pop    %ebx
  104a35:	5d                   	pop    %ebp
  104a36:	c3                   	ret    
  104a37:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104a38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104a3b:	03 10                	add    (%eax),%edx
  104a3d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  104a3f:	8b 18                	mov    (%eax),%ebx
  104a41:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104a44:	39 da                	cmp    %ebx,%edx
  104a46:	73 e7                	jae    104a2f <fetchstr+0xf>
    if(*s == 0)
  104a48:	31 c0                	xor    %eax,%eax
  104a4a:	89 d1                	mov    %edx,%ecx
  104a4c:	80 3a 00             	cmpb   $0x0,(%edx)
  104a4f:	74 e3                	je     104a34 <fetchstr+0x14>
  104a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104a58:	83 c1 01             	add    $0x1,%ecx
  104a5b:	39 cb                	cmp    %ecx,%ebx
  104a5d:	76 d0                	jbe    104a2f <fetchstr+0xf>
    if(*s == 0)
  104a5f:	80 39 00             	cmpb   $0x0,(%ecx)
  104a62:	75 f4                	jne    104a58 <fetchstr+0x38>
  104a64:	89 c8                	mov    %ecx,%eax
  104a66:	29 d0                	sub    %edx,%eax
  104a68:	eb ca                	jmp    104a34 <fetchstr+0x14>
  104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104a70 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104a70:	55                   	push   %ebp
  104a71:	89 e5                	mov    %esp,%ebp
  104a73:	53                   	push   %ebx
  104a74:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104a77:	e8 74 ec ff ff       	call   1036f0 <curproc>
  104a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  104a7f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a85:	8b 40 3c             	mov    0x3c(%eax),%eax
  104a88:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  104a8c:	e8 5f ec ff ff       	call   1036f0 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104a91:	8b 50 04             	mov    0x4(%eax),%edx
  104a94:	39 d3                	cmp    %edx,%ebx
  104a96:	72 10                	jb     104aa8 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  104a9d:	83 c4 04             	add    $0x4,%esp
  104aa0:	5b                   	pop    %ebx
  104aa1:	5d                   	pop    %ebp
  104aa2:	c3                   	ret    
  104aa3:	90                   	nop
  104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104aa8:	8d 4b 04             	lea    0x4(%ebx),%ecx
  104aab:	39 ca                	cmp    %ecx,%edx
  104aad:	72 e9                	jb     104a98 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104aaf:	8b 00                	mov    (%eax),%eax
  104ab1:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ab7:	89 10                	mov    %edx,(%eax)
  104ab9:	31 c0                	xor    %eax,%eax
  104abb:	eb e0                	jmp    104a9d <argint+0x2d>
  104abd:	8d 76 00             	lea    0x0(%esi),%esi

00104ac0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104ac0:	55                   	push   %ebp
  104ac1:	89 e5                	mov    %esp,%ebp
  104ac3:	53                   	push   %ebx
  104ac4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ace:	8b 45 08             	mov    0x8(%ebp),%eax
  104ad1:	89 04 24             	mov    %eax,(%esp)
  104ad4:	e8 97 ff ff ff       	call   104a70 <argint>
  104ad9:	85 c0                	test   %eax,%eax
  104adb:	78 3b                	js     104b18 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  104add:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ae0:	e8 0b ec ff ff       	call   1036f0 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104ae5:	3b 58 04             	cmp    0x4(%eax),%ebx
  104ae8:	73 2e                	jae    104b18 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  104aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  104aed:	03 18                	add    (%eax),%ebx
  104aef:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104af1:	8b 08                	mov    (%eax),%ecx
  104af3:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104af6:	39 cb                	cmp    %ecx,%ebx
  104af8:	73 1e                	jae    104b18 <argstr+0x58>
    if(*s == 0)
  104afa:	31 c0                	xor    %eax,%eax
  104afc:	89 da                	mov    %ebx,%edx
  104afe:	80 3b 00             	cmpb   $0x0,(%ebx)
  104b01:	75 0a                	jne    104b0d <argstr+0x4d>
  104b03:	eb 18                	jmp    104b1d <argstr+0x5d>
  104b05:	8d 76 00             	lea    0x0(%esi),%esi
  104b08:	80 3a 00             	cmpb   $0x0,(%edx)
  104b0b:	74 1b                	je     104b28 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104b0d:	83 c2 01             	add    $0x1,%edx
  104b10:	39 d1                	cmp    %edx,%ecx
  104b12:	77 f4                	ja     104b08 <argstr+0x48>
  104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b1d:	83 c4 24             	add    $0x24,%esp
  104b20:	5b                   	pop    %ebx
  104b21:	5d                   	pop    %ebp
  104b22:	c3                   	ret    
  104b23:	90                   	nop
  104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104b28:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b2a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104b2d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b2f:	5b                   	pop    %ebx
  104b30:	5d                   	pop    %ebp
  104b31:	c3                   	ret    
  104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104b40:	55                   	push   %ebp
  104b41:	89 e5                	mov    %esp,%ebp
  104b43:	53                   	push   %ebx
  104b44:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104b47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  104b51:	89 04 24             	mov    %eax,(%esp)
  104b54:	e8 17 ff ff ff       	call   104a70 <argint>
  104b59:	85 c0                	test   %eax,%eax
  104b5b:	79 0b                	jns    104b68 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  104b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b62:	83 c4 24             	add    $0x24,%esp
  104b65:	5b                   	pop    %ebx
  104b66:	5d                   	pop    %ebp
  104b67:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104b68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b6b:	e8 80 eb ff ff       	call   1036f0 <curproc>
  104b70:	3b 58 04             	cmp    0x4(%eax),%ebx
  104b73:	73 e8                	jae    104b5d <argptr+0x1d>
  104b75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104b78:	03 5d f4             	add    -0xc(%ebp),%ebx
  104b7b:	e8 70 eb ff ff       	call   1036f0 <curproc>
  104b80:	3b 58 04             	cmp    0x4(%eax),%ebx
  104b83:	73 d8                	jae    104b5d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104b85:	e8 66 eb ff ff       	call   1036f0 <curproc>
  104b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b8d:	8b 00                	mov    (%eax),%eax
  104b8f:	03 45 f4             	add    -0xc(%ebp),%eax
  104b92:	89 02                	mov    %eax,(%edx)
  104b94:	31 c0                	xor    %eax,%eax
  return 0;
  104b96:	eb ca                	jmp    104b62 <argptr+0x22>
  104b98:	90                   	nop
  104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104ba0 <syscall>:
[SYS_check]			sys_check,
};

void
syscall(void)
{
  104ba0:	55                   	push   %ebp
  104ba1:	89 e5                	mov    %esp,%ebp
  104ba3:	83 ec 18             	sub    $0x18,%esp
  104ba6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104ba9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  104bac:	e8 3f eb ff ff       	call   1036f0 <curproc>
  104bb1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104bb7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104bba:	83 fb 1b             	cmp    $0x1b,%ebx
  104bbd:	77 29                	ja     104be8 <syscall+0x48>
  104bbf:	8b 34 9d 20 6f 10 00 	mov    0x106f20(,%ebx,4),%esi
  104bc6:	85 f6                	test   %esi,%esi
  104bc8:	74 1e                	je     104be8 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  104bca:	e8 21 eb ff ff       	call   1036f0 <curproc>
  104bcf:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104bd5:	ff d6                	call   *%esi
  104bd7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104bda:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104bdd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104be0:	89 ec                	mov    %ebp,%esp
  104be2:	5d                   	pop    %ebp
  104be3:	c3                   	ret    
  104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104be8:	e8 03 eb ff ff       	call   1036f0 <curproc>
  104bed:	89 c6                	mov    %eax,%esi
  104bef:	e8 fc ea ff ff       	call   1036f0 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104bf4:	81 c6 88 00 00 00    	add    $0x88,%esi
  104bfa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104bfe:	89 74 24 08          	mov    %esi,0x8(%esp)
  104c02:	8b 40 10             	mov    0x10(%eax),%eax
  104c05:	c7 04 24 ee 6e 10 00 	movl   $0x106eee,(%esp)
  104c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c10:	e8 ab bb ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104c15:	e8 d6 ea ff ff       	call   1036f0 <curproc>
  104c1a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104c20:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104c27:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104c2a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104c2d:	89 ec                	mov    %ebp,%esp
  104c2f:	5d                   	pop    %ebp
  104c30:	c3                   	ret    
  104c31:	90                   	nop
  104c32:	90                   	nop
  104c33:	90                   	nop
  104c34:	90                   	nop
  104c35:	90                   	nop
  104c36:	90                   	nop
  104c37:	90                   	nop
  104c38:	90                   	nop
  104c39:	90                   	nop
  104c3a:	90                   	nop
  104c3b:	90                   	nop
  104c3c:	90                   	nop
  104c3d:	90                   	nop
  104c3e:	90                   	nop
  104c3f:	90                   	nop

00104c40 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104c40:	55                   	push   %ebp
  104c41:	89 e5                	mov    %esp,%ebp
  104c43:	57                   	push   %edi
  104c44:	89 c7                	mov    %eax,%edi
  104c46:	56                   	push   %esi
  104c47:	53                   	push   %ebx
  104c48:	31 db                	xor    %ebx,%ebx
  104c4a:	83 ec 0c             	sub    $0xc,%esp
  104c4d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104c50:	e8 9b ea ff ff       	call   1036f0 <curproc>
  104c55:	8d 73 08             	lea    0x8(%ebx),%esi
  104c58:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  104c5b:	85 c0                	test   %eax,%eax
  104c5d:	74 19                	je     104c78 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104c5f:	83 c3 01             	add    $0x1,%ebx
  104c62:	83 fb 10             	cmp    $0x10,%ebx
  104c65:	75 e9                	jne    104c50 <fdalloc+0x10>
  104c67:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104c6c:	83 c4 0c             	add    $0xc,%esp
  104c6f:	89 d8                	mov    %ebx,%eax
  104c71:	5b                   	pop    %ebx
  104c72:	5e                   	pop    %esi
  104c73:	5f                   	pop    %edi
  104c74:	5d                   	pop    %ebp
  104c75:	c3                   	ret    
  104c76:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104c78:	e8 73 ea ff ff       	call   1036f0 <curproc>
  104c7d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  104c80:	83 c4 0c             	add    $0xc,%esp
  104c83:	89 d8                	mov    %ebx,%eax
  104c85:	5b                   	pop    %ebx
  104c86:	5e                   	pop    %esi
  104c87:	5f                   	pop    %edi
  104c88:	5d                   	pop    %ebp
  104c89:	c3                   	ret    
  104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c90 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104c90:	55                   	push   %ebp
  104c91:	89 e5                	mov    %esp,%ebp
  104c93:	53                   	push   %ebx
  104c94:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104c97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c9a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104ca1:	00 
  104ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ca6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104cad:	e8 8e fe ff ff       	call   104b40 <argptr>
  104cb2:	85 c0                	test   %eax,%eax
  104cb4:	79 12                	jns    104cc8 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104cbb:	83 c4 24             	add    $0x24,%esp
  104cbe:	5b                   	pop    %ebx
  104cbf:	5d                   	pop    %ebp
  104cc0:	c3                   	ret    
  104cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104cc8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ccf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104cd2:	89 04 24             	mov    %eax,(%esp)
  104cd5:	e8 66 e6 ff ff       	call   103340 <pipealloc>
  104cda:	85 c0                	test   %eax,%eax
  104cdc:	78 d8                	js     104cb6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce1:	e8 5a ff ff ff       	call   104c40 <fdalloc>
  104ce6:	85 c0                	test   %eax,%eax
  104ce8:	89 c3                	mov    %eax,%ebx
  104cea:	78 25                	js     104d11 <sys_pipe+0x81>
  104cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cef:	e8 4c ff ff ff       	call   104c40 <fdalloc>
  104cf4:	85 c0                	test   %eax,%eax
  104cf6:	78 0c                	js     104d04 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104cf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  104cfb:	89 42 04             	mov    %eax,0x4(%edx)
  104cfe:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104d00:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104d02:	eb b7                	jmp    104cbb <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104d04:	e8 e7 e9 ff ff       	call   1036f0 <curproc>
  104d09:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104d10:	00 
    fileclose(rf);
  104d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d14:	89 04 24             	mov    %eax,(%esp)
  104d17:	e8 c4 c3 ff ff       	call   1010e0 <fileclose>
    fileclose(wf);
  104d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d1f:	89 04 24             	mov    %eax,(%esp)
  104d22:	e8 b9 c3 ff ff       	call   1010e0 <fileclose>
  104d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104d2c:	eb 8d                	jmp    104cbb <sys_pipe+0x2b>
  104d2e:	66 90                	xchg   %ax,%ax

00104d30 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104d30:	55                   	push   %ebp
  104d31:	89 e5                	mov    %esp,%ebp
  104d33:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d39:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104d3c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104d3f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104d42:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d50:	e8 6b fd ff ff       	call   104ac0 <argstr>
  104d55:	85 c0                	test   %eax,%eax
  104d57:	79 17                	jns    104d70 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104d5e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d61:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104d64:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104d67:	89 ec                	mov    %ebp,%esp
  104d69:	5d                   	pop    %ebp
  104d6a:	c3                   	ret    
  104d6b:	90                   	nop
  104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d70:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d7e:	e8 ed fc ff ff       	call   104a70 <argint>
  104d83:	85 c0                	test   %eax,%eax
  104d85:	78 d2                	js     104d59 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  104d87:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104d8a:	31 ff                	xor    %edi,%edi
  104d8c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104d93:	00 
  104d94:	31 db                	xor    %ebx,%ebx
  104d96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d9d:	00 
  104d9e:	89 04 24             	mov    %eax,(%esp)
  104da1:	e8 fa f9 ff ff       	call   1047a0 <memset>
  104da6:	eb 27                	jmp    104dcf <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104da8:	e8 43 e9 ff ff       	call   1036f0 <curproc>
  104dad:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104db1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104db5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104db9:	89 04 24             	mov    %eax,(%esp)
  104dbc:	e8 5f fc ff ff       	call   104a20 <fetchstr>
  104dc1:	85 c0                	test   %eax,%eax
  104dc3:	78 94                	js     104d59 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104dc5:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104dc8:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104dcb:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  104dcd:	74 8a                	je     104d59 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104dcf:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104dd6:	03 75 e0             	add    -0x20(%ebp),%esi
  104dd9:	e8 12 e9 ff ff       	call   1036f0 <curproc>
  104dde:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104de1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104de5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104de9:	89 04 24             	mov    %eax,(%esp)
  104dec:	e8 ef fb ff ff       	call   1049e0 <fetchint>
  104df1:	85 c0                	test   %eax,%eax
  104df3:	0f 88 60 ff ff ff    	js     104d59 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104df9:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104dfc:	85 f6                	test   %esi,%esi
  104dfe:	75 a8                	jne    104da8 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104e00:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104e0a:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104e11:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104e12:	89 04 24             	mov    %eax,(%esp)
  104e15:	e8 c6 bb ff ff       	call   1009e0 <exec>
  104e1a:	e9 3f ff ff ff       	jmp    104d5e <sys_exec+0x2e>
  104e1f:	90                   	nop

00104e20 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104e20:	55                   	push   %ebp
  104e21:	89 e5                	mov    %esp,%ebp
  104e23:	53                   	push   %ebx
  104e24:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e35:	e8 86 fc ff ff       	call   104ac0 <argstr>
  104e3a:	85 c0                	test   %eax,%eax
  104e3c:	79 12                	jns    104e50 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e43:	83 c4 24             	add    $0x24,%esp
  104e46:	5b                   	pop    %ebx
  104e47:	5d                   	pop    %ebp
  104e48:	c3                   	ret    
  104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e53:	89 04 24             	mov    %eax,(%esp)
  104e56:	e8 a5 d3 ff ff       	call   102200 <namei>
  104e5b:	85 c0                	test   %eax,%eax
  104e5d:	89 c3                	mov    %eax,%ebx
  104e5f:	74 dd                	je     104e3e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104e61:	89 04 24             	mov    %eax,(%esp)
  104e64:	e8 d7 d0 ff ff       	call   101f40 <ilock>
  if(ip->type != T_DIR){
  104e69:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104e6e:	75 24                	jne    104e94 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104e70:	89 1c 24             	mov    %ebx,(%esp)
  104e73:	e8 58 d0 ff ff       	call   101ed0 <iunlock>
  iput(cp->cwd);
  104e78:	e8 73 e8 ff ff       	call   1036f0 <curproc>
  104e7d:	8b 40 60             	mov    0x60(%eax),%eax
  104e80:	89 04 24             	mov    %eax,(%esp)
  104e83:	e8 68 cd ff ff       	call   101bf0 <iput>
  cp->cwd = ip;
  104e88:	e8 63 e8 ff ff       	call   1036f0 <curproc>
  104e8d:	89 58 60             	mov    %ebx,0x60(%eax)
  104e90:	31 c0                	xor    %eax,%eax
  return 0;
  104e92:	eb af                	jmp    104e43 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104e94:	89 1c 24             	mov    %ebx,(%esp)
  104e97:	e8 84 d0 ff ff       	call   101f20 <iunlockput>
  104e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104ea1:	eb a0                	jmp    104e43 <sys_chdir+0x23>
  104ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104eb0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104eb0:	55                   	push   %ebp
  104eb1:	89 e5                	mov    %esp,%ebp
  104eb3:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104eb6:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104eb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104ebc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104ebf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ec6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ecd:	e8 ee fb ff ff       	call   104ac0 <argstr>
  104ed2:	85 c0                	test   %eax,%eax
  104ed4:	79 12                	jns    104ee8 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104edb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ede:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104ee1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104ee4:	89 ec                	mov    %ebp,%esp
  104ee6:	5d                   	pop    %ebp
  104ee7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ee8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104eef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ef6:	e8 c5 fb ff ff       	call   104ac0 <argstr>
  104efb:	85 c0                	test   %eax,%eax
  104efd:	78 d7                	js     104ed6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f02:	89 04 24             	mov    %eax,(%esp)
  104f05:	e8 f6 d2 ff ff       	call   102200 <namei>
  104f0a:	85 c0                	test   %eax,%eax
  104f0c:	89 c3                	mov    %eax,%ebx
  104f0e:	74 c6                	je     104ed6 <sys_link+0x26>
    return -1;
  ilock(ip);
  104f10:	89 04 24             	mov    %eax,(%esp)
  104f13:	e8 28 d0 ff ff       	call   101f40 <ilock>
  if(ip->type == T_DIR){
  104f18:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104f1d:	0f 84 86 00 00 00    	je     104fa9 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104f23:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104f28:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104f2b:	89 1c 24             	mov    %ebx,(%esp)
  104f2e:	e8 ed c7 ff ff       	call   101720 <iupdate>
  iunlock(ip);
  104f33:	89 1c 24             	mov    %ebx,(%esp)
  104f36:	e8 95 cf ff ff       	call   101ed0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f42:	89 04 24             	mov    %eax,(%esp)
  104f45:	e8 96 d2 ff ff       	call   1021e0 <nameiparent>
  104f4a:	85 c0                	test   %eax,%eax
  104f4c:	89 c6                	mov    %eax,%esi
  104f4e:	74 44                	je     104f94 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  104f50:	89 04 24             	mov    %eax,(%esp)
  104f53:	e8 e8 cf ff ff       	call   101f40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104f58:	8b 06                	mov    (%esi),%eax
  104f5a:	3b 03                	cmp    (%ebx),%eax
  104f5c:	75 2e                	jne    104f8c <sys_link+0xdc>
  104f5e:	8b 43 04             	mov    0x4(%ebx),%eax
  104f61:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f65:	89 34 24             	mov    %esi,(%esp)
  104f68:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f6c:	e8 6f ce ff ff       	call   101de0 <dirlink>
  104f71:	85 c0                	test   %eax,%eax
  104f73:	78 17                	js     104f8c <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  104f75:	89 34 24             	mov    %esi,(%esp)
  104f78:	e8 a3 cf ff ff       	call   101f20 <iunlockput>
  iput(ip);
  104f7d:	89 1c 24             	mov    %ebx,(%esp)
  104f80:	e8 6b cc ff ff       	call   101bf0 <iput>
  104f85:	31 c0                	xor    %eax,%eax
  return 0;
  104f87:	e9 4f ff ff ff       	jmp    104edb <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  104f8c:	89 34 24             	mov    %esi,(%esp)
  104f8f:	e8 8c cf ff ff       	call   101f20 <iunlockput>
  ilock(ip);
  104f94:	89 1c 24             	mov    %ebx,(%esp)
  104f97:	e8 a4 cf ff ff       	call   101f40 <ilock>
  ip->nlink--;
  104f9c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104fa1:	89 1c 24             	mov    %ebx,(%esp)
  104fa4:	e8 77 c7 ff ff       	call   101720 <iupdate>
  iunlockput(ip);
  104fa9:	89 1c 24             	mov    %ebx,(%esp)
  104fac:	e8 6f cf ff ff       	call   101f20 <iunlockput>
  104fb1:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104fb4:	e9 22 ff ff ff       	jmp    104edb <sys_link+0x2b>
  104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104fc0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fc0:	55                   	push   %ebp
  104fc1:	89 e5                	mov    %esp,%ebp
  104fc3:	57                   	push   %edi
  104fc4:	89 cf                	mov    %ecx,%edi
  104fc6:	56                   	push   %esi
  104fc7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fc8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fca:	83 ec 4c             	sub    $0x4c,%esp
  104fcd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104fd0:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fd4:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fd7:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  104fdb:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104fdf:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fe3:	89 74 24 04          	mov    %esi,0x4(%esp)
  104fe7:	89 04 24             	mov    %eax,(%esp)
  104fea:	e8 f1 d1 ff ff       	call   1021e0 <nameiparent>
  104fef:	85 c0                	test   %eax,%eax
  104ff1:	74 67                	je     10505a <create+0x9a>
    return 0;
  ilock(dp);
  104ff3:	89 04 24             	mov    %eax,(%esp)
  104ff6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104ff9:	e8 42 cf ff ff       	call   101f40 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104ffe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105001:	85 d2                	test   %edx,%edx
  105003:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105006:	74 60                	je     105068 <create+0xa8>
  105008:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10500b:	89 14 24             	mov    %edx,(%esp)
  10500e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105012:	89 74 24 04          	mov    %esi,0x4(%esp)
  105016:	e8 f5 c8 ff ff       	call   101910 <dirlookup>
  10501b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10501e:	85 c0                	test   %eax,%eax
  105020:	89 c3                	mov    %eax,%ebx
  105022:	74 44                	je     105068 <create+0xa8>
    iunlockput(dp);
  105024:	89 14 24             	mov    %edx,(%esp)
  105027:	e8 f4 ce ff ff       	call   101f20 <iunlockput>
    ilock(ip);
  10502c:	89 1c 24             	mov    %ebx,(%esp)
  10502f:	e8 0c cf ff ff       	call   101f40 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105034:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  105038:	0f 85 02 01 00 00    	jne    105140 <create+0x180>
  10503e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  105042:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105046:	0f 85 f4 00 00 00    	jne    105140 <create+0x180>
  10504c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  105050:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  105054:	0f 85 e6 00 00 00    	jne    105140 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10505a:	83 c4 4c             	add    $0x4c,%esp
  10505d:	89 d8                	mov    %ebx,%eax
  10505f:	5b                   	pop    %ebx
  105060:	5e                   	pop    %esi
  105061:	5f                   	pop    %edi
  105062:	5d                   	pop    %ebp
  105063:	c3                   	ret    
  105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105068:	0f bf c7             	movswl %di,%eax
  10506b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10506f:	8b 02                	mov    (%edx),%eax
  105071:	89 04 24             	mov    %eax,(%esp)
  105074:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105077:	e8 e4 c9 ff ff       	call   101a60 <ialloc>
  10507c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10507f:	85 c0                	test   %eax,%eax
  105081:	89 c3                	mov    %eax,%ebx
  105083:	74 50                	je     1050d5 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105085:	89 04 24             	mov    %eax,(%esp)
  105088:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10508b:	e8 b0 ce ff ff       	call   101f40 <ilock>
  ip->major = major;
  105090:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  105094:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  10509a:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10509e:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  1050a2:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  1050a6:	89 1c 24             	mov    %ebx,(%esp)
  1050a9:	e8 72 c6 ff ff       	call   101720 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  1050ae:	8b 43 04             	mov    0x4(%ebx),%eax
  1050b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  1050b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050b9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1050bc:	89 14 24             	mov    %edx,(%esp)
  1050bf:	e8 1c cd ff ff       	call   101de0 <dirlink>
  1050c4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1050c7:	85 c0                	test   %eax,%eax
  1050c9:	0f 88 85 00 00 00    	js     105154 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  1050cf:	66 83 ff 01          	cmp    $0x1,%di
  1050d3:	74 13                	je     1050e8 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  1050d5:	89 14 24             	mov    %edx,(%esp)
  1050d8:	e8 43 ce ff ff       	call   101f20 <iunlockput>
  return ip;
}
  1050dd:	83 c4 4c             	add    $0x4c,%esp
  1050e0:	89 d8                	mov    %ebx,%eax
  1050e2:	5b                   	pop    %ebx
  1050e3:	5e                   	pop    %esi
  1050e4:	5f                   	pop    %edi
  1050e5:	5d                   	pop    %ebp
  1050e6:	c3                   	ret    
  1050e7:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1050e8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  1050ed:	89 14 24             	mov    %edx,(%esp)
  1050f0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1050f3:	e8 28 c6 ff ff       	call   101720 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1050f8:	8b 43 04             	mov    0x4(%ebx),%eax
  1050fb:	c7 44 24 04 91 6f 10 	movl   $0x106f91,0x4(%esp)
  105102:	00 
  105103:	89 1c 24             	mov    %ebx,(%esp)
  105106:	89 44 24 08          	mov    %eax,0x8(%esp)
  10510a:	e8 d1 cc ff ff       	call   101de0 <dirlink>
  10510f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105112:	85 c0                	test   %eax,%eax
  105114:	78 1e                	js     105134 <create+0x174>
  105116:	8b 42 04             	mov    0x4(%edx),%eax
  105119:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  105120:	00 
  105121:	89 1c 24             	mov    %ebx,(%esp)
  105124:	89 44 24 08          	mov    %eax,0x8(%esp)
  105128:	e8 b3 cc ff ff       	call   101de0 <dirlink>
  10512d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105130:	85 c0                	test   %eax,%eax
  105132:	79 a1                	jns    1050d5 <create+0x115>
      panic("create dots");
  105134:	c7 04 24 93 6f 10 00 	movl   $0x106f93,(%esp)
  10513b:	e8 20 b8 ff ff       	call   100960 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  105140:	89 1c 24             	mov    %ebx,(%esp)
  105143:	31 db                	xor    %ebx,%ebx
  105145:	e8 d6 cd ff ff       	call   101f20 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10514a:	83 c4 4c             	add    $0x4c,%esp
  10514d:	89 d8                	mov    %ebx,%eax
  10514f:	5b                   	pop    %ebx
  105150:	5e                   	pop    %esi
  105151:	5f                   	pop    %edi
  105152:	5d                   	pop    %ebp
  105153:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105154:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  10515a:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10515d:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10515f:	e8 bc cd ff ff       	call   101f20 <iunlockput>
    iunlockput(dp);
  105164:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105167:	89 14 24             	mov    %edx,(%esp)
  10516a:	e8 b1 cd ff ff       	call   101f20 <iunlockput>
    return 0;
  10516f:	e9 e6 fe ff ff       	jmp    10505a <create+0x9a>
  105174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10517a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105180 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105180:	55                   	push   %ebp
  105181:	89 e5                	mov    %esp,%ebp
  105183:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105186:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105189:	89 44 24 04          	mov    %eax,0x4(%esp)
  10518d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105194:	e8 27 f9 ff ff       	call   104ac0 <argstr>
  105199:	85 c0                	test   %eax,%eax
  10519b:	79 0b                	jns    1051a8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  10519d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1051a2:	c9                   	leave  
  1051a3:	c3                   	ret    
  1051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  1051a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1051af:	00 
  1051b0:	31 d2                	xor    %edx,%edx
  1051b2:	b9 01 00 00 00       	mov    $0x1,%ecx
  1051b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051c1:	e8 fa fd ff ff       	call   104fc0 <create>
  1051c6:	85 c0                	test   %eax,%eax
  1051c8:	74 d3                	je     10519d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1051ca:	89 04 24             	mov    %eax,(%esp)
  1051cd:	e8 4e cd ff ff       	call   101f20 <iunlockput>
  1051d2:	31 c0                	xor    %eax,%eax
  return 0;
}
  1051d4:	c9                   	leave  
  1051d5:	c3                   	ret    
  1051d6:	8d 76 00             	lea    0x0(%esi),%esi
  1051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001051e0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1051e0:	55                   	push   %ebp
  1051e1:	89 e5                	mov    %esp,%ebp
  1051e3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1051e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1051e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051f4:	e8 c7 f8 ff ff       	call   104ac0 <argstr>
  1051f9:	85 c0                	test   %eax,%eax
  1051fb:	79 0b                	jns    105208 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1051fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105202:	c9                   	leave  
  105203:	c3                   	ret    
  105204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  105208:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10520b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10520f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105216:	e8 55 f8 ff ff       	call   104a70 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10521b:	85 c0                	test   %eax,%eax
  10521d:	78 de                	js     1051fd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  10521f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105222:	89 44 24 04          	mov    %eax,0x4(%esp)
  105226:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10522d:	e8 3e f8 ff ff       	call   104a70 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105232:	85 c0                	test   %eax,%eax
  105234:	78 c7                	js     1051fd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  105236:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  10523a:	31 d2                	xor    %edx,%edx
  10523c:	b9 03 00 00 00       	mov    $0x3,%ecx
  105241:	89 44 24 04          	mov    %eax,0x4(%esp)
  105245:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  105249:	89 04 24             	mov    %eax,(%esp)
  10524c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10524f:	e8 6c fd ff ff       	call   104fc0 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105254:	85 c0                	test   %eax,%eax
  105256:	74 a5                	je     1051fd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105258:	89 04 24             	mov    %eax,(%esp)
  10525b:	e8 c0 cc ff ff       	call   101f20 <iunlockput>
  105260:	31 c0                	xor    %eax,%eax
  return 0;
}
  105262:	c9                   	leave  
  105263:	c3                   	ret    
  105264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10526a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105270 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105270:	55                   	push   %ebp
  105271:	89 e5                	mov    %esp,%ebp
  105273:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105276:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105279:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10527c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10527f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10528a:	e8 31 f8 ff ff       	call   104ac0 <argstr>
  10528f:	85 c0                	test   %eax,%eax
  105291:	79 15                	jns    1052a8 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105298:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10529b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10529e:	89 ec                	mov    %ebp,%esp
  1052a0:	5d                   	pop    %ebp
  1052a1:	c3                   	ret    
  1052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1052a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1052ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052b6:	e8 b5 f7 ff ff       	call   104a70 <argint>
  1052bb:	85 c0                	test   %eax,%eax
  1052bd:	78 d4                	js     105293 <sys_open+0x23>
    return -1;

  if(omode & O_CREATE){
  1052bf:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  1052c3:	74 7b                	je     105340 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  1052c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052c8:	b9 02 00 00 00       	mov    $0x2,%ecx
  1052cd:	ba 01 00 00 00       	mov    $0x1,%edx
  1052d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052d9:	00 
  1052da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052e1:	e8 da fc ff ff       	call   104fc0 <create>
  1052e6:	85 c0                	test   %eax,%eax
  1052e8:	89 c6                	mov    %eax,%esi
  1052ea:	74 a7                	je     105293 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1052ec:	e8 5f bd ff ff       	call   101050 <filealloc>
  1052f1:	85 c0                	test   %eax,%eax
  1052f3:	89 c3                	mov    %eax,%ebx
  1052f5:	74 73                	je     10536a <sys_open+0xfa>
  1052f7:	e8 44 f9 ff ff       	call   104c40 <fdalloc>
  1052fc:	85 c0                	test   %eax,%eax
  1052fe:	66 90                	xchg   %ax,%ax
  105300:	78 7d                	js     10537f <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105305:	89 34 24             	mov    %esi,(%esp)
  105308:	e8 c3 cb ff ff       	call   101ed0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10530d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  105310:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  105316:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  105319:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  105320:	89 d1                	mov    %edx,%ecx
  105322:	83 f1 01             	xor    $0x1,%ecx
  105325:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105328:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10532b:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10532e:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105335:	e9 5e ff ff ff       	jmp    105298 <sys_open+0x28>
  10533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105343:	89 04 24             	mov    %eax,(%esp)
  105346:	e8 b5 ce ff ff       	call   102200 <namei>
  10534b:	85 c0                	test   %eax,%eax
  10534d:	89 c6                	mov    %eax,%esi
  10534f:	0f 84 3e ff ff ff    	je     105293 <sys_open+0x23>
      return -1;
    ilock(ip);
  105355:	89 04 24             	mov    %eax,(%esp)
  105358:	e8 e3 cb ff ff       	call   101f40 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  10535d:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105362:	75 88                	jne    1052ec <sys_open+0x7c>
  105364:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  105368:	74 82                	je     1052ec <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  10536a:	89 34 24             	mov    %esi,(%esp)
  10536d:	8d 76 00             	lea    0x0(%esi),%esi
  105370:	e8 ab cb ff ff       	call   101f20 <iunlockput>
  105375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  10537a:	e9 19 ff ff ff       	jmp    105298 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10537f:	89 1c 24             	mov    %ebx,(%esp)
  105382:	e8 59 bd ff ff       	call   1010e0 <fileclose>
  105387:	eb e1                	jmp    10536a <sys_open+0xfa>
  105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105390 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105390:	55                   	push   %ebp
  105391:	89 e5                	mov    %esp,%ebp
  105393:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105396:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105399:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10539c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10539f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1053a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053ad:	e8 0e f7 ff ff       	call   104ac0 <argstr>
  1053b2:	85 c0                	test   %eax,%eax
  1053b4:	79 12                	jns    1053c8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1053b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1053bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1053be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1053c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1053c4:	89 ec                	mov    %ebp,%esp
  1053c6:	5d                   	pop    %ebp
  1053c7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1053c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053cb:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  1053ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053d2:	89 04 24             	mov    %eax,(%esp)
  1053d5:	e8 06 ce ff ff       	call   1021e0 <nameiparent>
  1053da:	85 c0                	test   %eax,%eax
  1053dc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1053df:	74 d5                	je     1053b6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1053e1:	89 04 24             	mov    %eax,(%esp)
  1053e4:	e8 57 cb ff ff       	call   101f40 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1053e9:	c7 44 24 04 91 6f 10 	movl   $0x106f91,0x4(%esp)
  1053f0:	00 
  1053f1:	89 1c 24             	mov    %ebx,(%esp)
  1053f4:	e8 e7 c4 ff ff       	call   1018e0 <namecmp>
  1053f9:	85 c0                	test   %eax,%eax
  1053fb:	0f 84 a4 00 00 00    	je     1054a5 <sys_unlink+0x115>
  105401:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  105408:	00 
  105409:	89 1c 24             	mov    %ebx,(%esp)
  10540c:	e8 cf c4 ff ff       	call   1018e0 <namecmp>
  105411:	85 c0                	test   %eax,%eax
  105413:	0f 84 8c 00 00 00    	je     1054a5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  105419:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10541c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105420:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105423:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105427:	89 04 24             	mov    %eax,(%esp)
  10542a:	e8 e1 c4 ff ff       	call   101910 <dirlookup>
  10542f:	85 c0                	test   %eax,%eax
  105431:	89 c6                	mov    %eax,%esi
  105433:	74 70                	je     1054a5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105435:	89 04 24             	mov    %eax,(%esp)
  105438:	e8 03 cb ff ff       	call   101f40 <ilock>

  if(ip->nlink < 1)
  10543d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105442:	0f 8e e9 00 00 00    	jle    105531 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105448:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  10544d:	75 71                	jne    1054c0 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10544f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105453:	76 6b                	jbe    1054c0 <sys_unlink+0x130>
  105455:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  105458:	bb 20 00 00 00       	mov    $0x20,%ebx
  10545d:	8d 76 00             	lea    0x0(%esi),%esi
  105460:	eb 0e                	jmp    105470 <sys_unlink+0xe0>
  105462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105468:	83 c3 10             	add    $0x10,%ebx
  10546b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10546e:	73 50                	jae    1054c0 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105470:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105477:	00 
  105478:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10547c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105480:	89 34 24             	mov    %esi,(%esp)
  105483:	e8 88 c1 ff ff       	call   101610 <readi>
  105488:	83 f8 10             	cmp    $0x10,%eax
  10548b:	0f 85 94 00 00 00    	jne    105525 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  105491:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  105496:	74 d0                	je     105468 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105498:	89 34 24             	mov    %esi,(%esp)
  10549b:	90                   	nop
  10549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1054a0:	e8 7b ca ff ff       	call   101f20 <iunlockput>
    iunlockput(dp);
  1054a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1054a8:	89 04 24             	mov    %eax,(%esp)
  1054ab:	e8 70 ca ff ff       	call   101f20 <iunlockput>
  1054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1054b5:	e9 01 ff ff ff       	jmp    1053bb <sys_unlink+0x2b>
  1054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  1054c0:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  1054c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1054ca:	00 
  1054cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054d2:	00 
  1054d3:	89 1c 24             	mov    %ebx,(%esp)
  1054d6:	e8 c5 f2 ff ff       	call   1047a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1054db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054de:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1054e5:	00 
  1054e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1054ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1054f1:	89 04 24             	mov    %eax,(%esp)
  1054f4:	e8 b7 c2 ff ff       	call   1017b0 <writei>
  1054f9:	83 f8 10             	cmp    $0x10,%eax
  1054fc:	75 3f                	jne    10553d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  1054fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105501:	89 04 24             	mov    %eax,(%esp)
  105504:	e8 17 ca ff ff       	call   101f20 <iunlockput>

  ip->nlink--;
  105509:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  10550e:	89 34 24             	mov    %esi,(%esp)
  105511:	e8 0a c2 ff ff       	call   101720 <iupdate>
  iunlockput(ip);
  105516:	89 34 24             	mov    %esi,(%esp)
  105519:	e8 02 ca ff ff       	call   101f20 <iunlockput>
  10551e:	31 c0                	xor    %eax,%eax
  return 0;
  105520:	e9 96 fe ff ff       	jmp    1053bb <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  105525:	c7 04 24 b1 6f 10 00 	movl   $0x106fb1,(%esp)
  10552c:	e8 2f b4 ff ff       	call   100960 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105531:	c7 04 24 9f 6f 10 00 	movl   $0x106f9f,(%esp)
  105538:	e8 23 b4 ff ff       	call   100960 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  10553d:	c7 04 24 c3 6f 10 00 	movl   $0x106fc3,(%esp)
  105544:	e8 17 b4 ff ff       	call   100960 <panic>
  105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105550 <T.63>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  105550:	55                   	push   %ebp
  105551:	89 e5                	mov    %esp,%ebp
  105553:	83 ec 28             	sub    $0x28,%esp
  105556:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105559:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10555b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  10555e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105561:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105563:	89 44 24 04          	mov    %eax,0x4(%esp)
  105567:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10556e:	e8 fd f4 ff ff       	call   104a70 <argint>
  105573:	85 c0                	test   %eax,%eax
  105575:	79 11                	jns    105588 <T.63+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  10557c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10557f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105582:	89 ec                	mov    %ebp,%esp
  105584:	5d                   	pop    %ebp
  105585:	c3                   	ret    
  105586:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105588:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  10558c:	77 e9                	ja     105577 <T.63+0x27>
  10558e:	e8 5d e1 ff ff       	call   1036f0 <curproc>
  105593:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  105596:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  10559a:	85 d2                	test   %edx,%edx
  10559c:	74 d9                	je     105577 <T.63+0x27>
    return -1;
  if(pfd)
  10559e:	85 db                	test   %ebx,%ebx
  1055a0:	74 02                	je     1055a4 <T.63+0x54>
    *pfd = fd;
  1055a2:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  1055a4:	31 c0                	xor    %eax,%eax
  1055a6:	85 f6                	test   %esi,%esi
  1055a8:	74 d2                	je     10557c <T.63+0x2c>
    *pf = f;
  1055aa:	89 16                	mov    %edx,(%esi)
  1055ac:	eb ce                	jmp    10557c <T.63+0x2c>
  1055ae:	66 90                	xchg   %ax,%ax

001055b0 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  1055b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055b1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  1055b3:	89 e5                	mov    %esp,%ebp
  1055b5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1055bb:	e8 90 ff ff ff       	call   105550 <T.63>
  1055c0:	85 c0                	test   %eax,%eax
  1055c2:	79 0c                	jns    1055d0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  1055c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055c9:	c9                   	leave  
  1055ca:	c3                   	ret    
  1055cb:	90                   	nop
  1055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1055d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055d7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1055de:	e8 8d f4 ff ff       	call   104a70 <argint>
  1055e3:	85 c0                	test   %eax,%eax
  1055e5:	78 dd                	js     1055c4 <sys_read+0x14>
  1055e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1055f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fc:	e8 3f f5 ff ff       	call   104b40 <argptr>
  105601:	85 c0                	test   %eax,%eax
  105603:	78 bf                	js     1055c4 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  105605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105608:	89 44 24 08          	mov    %eax,0x8(%esp)
  10560c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10560f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105616:	89 04 24             	mov    %eax,(%esp)
  105619:	e8 e2 b8 ff ff       	call   100f00 <fileread>
}
  10561e:	c9                   	leave  
  10561f:	c3                   	ret    

00105620 <sys_write>:

int
sys_write(void)
{
  105620:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105621:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105623:	89 e5                	mov    %esp,%ebp
  105625:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105628:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10562b:	e8 20 ff ff ff       	call   105550 <T.63>
  105630:	85 c0                	test   %eax,%eax
  105632:	79 0c                	jns    105640 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105639:	c9                   	leave  
  10563a:	c3                   	ret    
  10563b:	90                   	nop
  10563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105643:	89 44 24 04          	mov    %eax,0x4(%esp)
  105647:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10564e:	e8 1d f4 ff ff       	call   104a70 <argint>
  105653:	85 c0                	test   %eax,%eax
  105655:	78 dd                	js     105634 <sys_write+0x14>
  105657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10565a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105661:	89 44 24 08          	mov    %eax,0x8(%esp)
  105665:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105668:	89 44 24 04          	mov    %eax,0x4(%esp)
  10566c:	e8 cf f4 ff ff       	call   104b40 <argptr>
  105671:	85 c0                	test   %eax,%eax
  105673:	78 bf                	js     105634 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  105675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105678:	89 44 24 08          	mov    %eax,0x8(%esp)
  10567c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10567f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105686:	89 04 24             	mov    %eax,(%esp)
  105689:	e8 52 b7 ff ff       	call   100de0 <filewrite>
}
  10568e:	c9                   	leave  
  10568f:	c3                   	ret    

00105690 <sys_dup>:

int
sys_dup(void)
{
  105690:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105691:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105693:	89 e5                	mov    %esp,%ebp
  105695:	53                   	push   %ebx
  105696:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105699:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10569c:	e8 af fe ff ff       	call   105550 <T.63>
  1056a1:	85 c0                	test   %eax,%eax
  1056a3:	79 13                	jns    1056b8 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1056a5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1056aa:	89 d8                	mov    %ebx,%eax
  1056ac:	83 c4 24             	add    $0x24,%esp
  1056af:	5b                   	pop    %ebx
  1056b0:	5d                   	pop    %ebp
  1056b1:	c3                   	ret    
  1056b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1056b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056bb:	e8 80 f5 ff ff       	call   104c40 <fdalloc>
  1056c0:	85 c0                	test   %eax,%eax
  1056c2:	89 c3                	mov    %eax,%ebx
  1056c4:	78 df                	js     1056a5 <sys_dup+0x15>
    return -1;
  filedup(f);
  1056c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056c9:	89 04 24             	mov    %eax,(%esp)
  1056cc:	e8 2f b9 ff ff       	call   101000 <filedup>
  return fd;
  1056d1:	eb d7                	jmp    1056aa <sys_dup+0x1a>
  1056d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001056e0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  1056e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1056e1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  1056e3:	89 e5                	mov    %esp,%ebp
  1056e5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1056e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1056eb:	e8 60 fe ff ff       	call   105550 <T.63>
  1056f0:	85 c0                	test   %eax,%eax
  1056f2:	79 0c                	jns    105700 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  1056f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056f9:	c9                   	leave  
  1056fa:	c3                   	ret    
  1056fb:	90                   	nop
  1056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105700:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105703:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10570a:	00 
  10570b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10570f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105716:	e8 25 f4 ff ff       	call   104b40 <argptr>
  10571b:	85 c0                	test   %eax,%eax
  10571d:	78 d5                	js     1056f4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105722:	89 44 24 04          	mov    %eax,0x4(%esp)
  105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105729:	89 04 24             	mov    %eax,(%esp)
  10572c:	e8 7f b8 ff ff       	call   100fb0 <filestat>
}
  105731:	c9                   	leave  
  105732:	c3                   	ret    
  105733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105740 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105740:	55                   	push   %ebp
  105741:	89 e5                	mov    %esp,%ebp
  105743:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105746:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10574c:	e8 ff fd ff ff       	call   105550 <T.63>
  105751:	89 c2                	mov    %eax,%edx
  105753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105758:	85 d2                	test   %edx,%edx
  10575a:	78 1d                	js     105779 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10575c:	e8 8f df ff ff       	call   1036f0 <curproc>
  105761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105764:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10576b:	00 
  fileclose(f);
  10576c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10576f:	89 04 24             	mov    %eax,(%esp)
  105772:	e8 69 b9 ff ff       	call   1010e0 <fileclose>
  105777:	31 c0                	xor    %eax,%eax
  return 0;
}
  105779:	c9                   	leave  
  10577a:	c3                   	ret    
  10577b:	90                   	nop
  10577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105780 <sys_check>:
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105780:	55                   	push   %ebp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105781:	31 c0                	xor    %eax,%eax
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105783:	89 e5                	mov    %esp,%ebp
  105785:	83 ec 28             	sub    $0x28,%esp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105788:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10578b:	e8 c0 fd ff ff       	call   105550 <T.63>
  105790:	85 c0                	test   %eax,%eax
  105792:	79 0c                	jns    1057a0 <sys_check+0x20>
		return -1;
	return filecheck(f, off);
  105794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  105799:	c9                   	leave  
  10579a:	c3                   	ret    
  10579b:	90                   	nop
  10579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int sys_check(void){

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  1057a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1057a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1057ae:	e8 bd f2 ff ff       	call   104a70 <argint>
  1057b3:	85 c0                	test   %eax,%eax
  1057b5:	78 dd                	js     105794 <sys_check+0x14>
		return -1;
	return filecheck(f, off);
  1057b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057c1:	89 04 24             	mov    %eax,(%esp)
  1057c4:	e8 c7 b6 ff ff       	call   100e90 <filecheck>

}
  1057c9:	c9                   	leave  
  1057ca:	c3                   	ret    
  1057cb:	90                   	nop
  1057cc:	90                   	nop
  1057cd:	90                   	nop
  1057ce:	90                   	nop
  1057cf:	90                   	nop

001057d0 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  1057d0:	55                   	push   %ebp
return ticks;
}
  1057d1:	a1 40 f1 10 00       	mov    0x10f140,%eax
	return 0;
}

int
sys_tick(void)
{
  1057d6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1057d8:	5d                   	pop    %ebp
  1057d9:	c3                   	ret    
  1057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001057e0 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  1057e0:	55                   	push   %ebp
  1057e1:	89 e5                	mov    %esp,%ebp
  1057e3:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  1057e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1057e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057f4:	e8 77 f2 ff ff       	call   104a70 <argint>
  1057f9:	89 c2                	mov    %eax,%edx
  1057fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105800:	85 d2                	test   %edx,%edx
  105802:	78 0d                	js     105811 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  105804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105807:	89 04 24             	mov    %eax,(%esp)
  10580a:	e8 11 dc ff ff       	call   103420 <wake_lock>
  10580f:	31 c0                	xor    %eax,%eax

	return 0;
}
  105811:	c9                   	leave  
  105812:	c3                   	ret    
  105813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105820 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  105820:	55                   	push   %ebp
  105821:	89 e5                	mov    %esp,%ebp
  105823:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  105826:	e8 25 e1 ff ff       	call   103950 <sleep_lock>
	return 0;
}
  10582b:	31 c0                	xor    %eax,%eax
  10582d:	c9                   	leave  
  10582e:	c3                   	ret    
  10582f:	90                   	nop

00105830 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105830:	55                   	push   %ebp
  105831:	89 e5                	mov    %esp,%ebp
  105833:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105836:	e8 b5 de ff ff       	call   1036f0 <curproc>
  10583b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10583e:	c9                   	leave  
  10583f:	c3                   	ret    

00105840 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105840:	55                   	push   %ebp
  105841:	89 e5                	mov    %esp,%ebp
  105843:	53                   	push   %ebx
  105844:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10584a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10584e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105855:	e8 16 f2 ff ff       	call   104a70 <argint>
  10585a:	89 c2                	mov    %eax,%edx
  10585c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105861:	85 d2                	test   %edx,%edx
  105863:	78 58                	js     1058bd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105865:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  10586c:	e8 bf ee ff ff       	call   104730 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105874:	8b 1d 40 f1 10 00    	mov    0x10f140,%ebx
  while(ticks - ticks0 < n){
  10587a:	85 d2                	test   %edx,%edx
  10587c:	7f 22                	jg     1058a0 <sys_sleep+0x60>
  10587e:	eb 48                	jmp    1058c8 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105880:	c7 44 24 04 00 e9 10 	movl   $0x10e900,0x4(%esp)
  105887:	00 
  105888:	c7 04 24 40 f1 10 00 	movl   $0x10f140,(%esp)
  10588f:	e8 0c e1 ff ff       	call   1039a0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105894:	a1 40 f1 10 00       	mov    0x10f140,%eax
  105899:	29 d8                	sub    %ebx,%eax
  10589b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10589e:	7d 28                	jge    1058c8 <sys_sleep+0x88>
    if(cp->killed){
  1058a0:	e8 4b de ff ff       	call   1036f0 <curproc>
  1058a5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1058a8:	85 c0                	test   %eax,%eax
  1058aa:	74 d4                	je     105880 <sys_sleep+0x40>
      release(&tickslock);
  1058ac:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  1058b3:	e8 38 ee ff ff       	call   1046f0 <release>
  1058b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  1058bd:	83 c4 24             	add    $0x24,%esp
  1058c0:	5b                   	pop    %ebx
  1058c1:	5d                   	pop    %ebp
  1058c2:	c3                   	ret    
  1058c3:	90                   	nop
  1058c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1058c8:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  1058cf:	e8 1c ee ff ff       	call   1046f0 <release>
  return 0;
}
  1058d4:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1058d7:	31 c0                	xor    %eax,%eax
  return 0;
}
  1058d9:	5b                   	pop    %ebx
  1058da:	5d                   	pop    %ebp
  1058db:	c3                   	ret    
  1058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001058e0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1058e0:	55                   	push   %ebp
  1058e1:	89 e5                	mov    %esp,%ebp
  1058e3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1058e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1058e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058f4:	e8 77 f1 ff ff       	call   104a70 <argint>
  1058f9:	85 c0                	test   %eax,%eax
  1058fb:	79 0b                	jns    105908 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  1058fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105902:	c9                   	leave  
  105903:	c3                   	ret    
  105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10590b:	89 04 24             	mov    %eax,(%esp)
  10590e:	e8 fd e6 ff ff       	call   104010 <growproc>
  105913:	85 c0                	test   %eax,%eax
  105915:	78 e6                	js     1058fd <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105917:	c9                   	leave  
  105918:	c3                   	ret    
  105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105920 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105920:	55                   	push   %ebp
  105921:	89 e5                	mov    %esp,%ebp
  105923:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105934:	e8 37 f1 ff ff       	call   104a70 <argint>
  105939:	89 c2                	mov    %eax,%edx
  10593b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105940:	85 d2                	test   %edx,%edx
  105942:	78 0b                	js     10594f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105947:	89 04 24             	mov    %eax,(%esp)
  10594a:	e8 11 dc ff ff       	call   103560 <kill>
}
  10594f:	c9                   	leave  
  105950:	c3                   	ret    
  105951:	eb 0d                	jmp    105960 <sys_wait>
  105953:	90                   	nop
  105954:	90                   	nop
  105955:	90                   	nop
  105956:	90                   	nop
  105957:	90                   	nop
  105958:	90                   	nop
  105959:	90                   	nop
  10595a:	90                   	nop
  10595b:	90                   	nop
  10595c:	90                   	nop
  10595d:	90                   	nop
  10595e:	90                   	nop
  10595f:	90                   	nop

00105960 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105960:	55                   	push   %ebp
  105961:	89 e5                	mov    %esp,%ebp
  105963:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105966:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105967:	e9 04 e2 ff ff       	jmp    103b70 <wait>
  10596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105970 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  105970:	55                   	push   %ebp
  105971:	89 e5                	mov    %esp,%ebp
  105973:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  105976:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  105977:	e9 f4 e0 ff ff       	jmp    103a70 <wait_thread>
  10597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105980 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105980:	55                   	push   %ebp
  105981:	89 e5                	mov    %esp,%ebp
  105983:	83 ec 08             	sub    $0x8,%esp
  exit();
  105986:	e8 65 de ff ff       	call   1037f0 <exit>
  return 0;  // not reached
}
  10598b:	31 c0                	xor    %eax,%eax
  10598d:	c9                   	leave  
  10598e:	c3                   	ret    
  10598f:	90                   	nop

00105990 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105990:	55                   	push   %ebp
  105991:	89 e5                	mov    %esp,%ebp
  105993:	53                   	push   %ebx
  105994:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105997:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10599a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1059a5:	e8 c6 f0 ff ff       	call   104a70 <argint>
  1059aa:	85 c0                	test   %eax,%eax
  1059ac:	79 12                	jns    1059c0 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  1059ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1059b3:	83 c4 24             	add    $0x24,%esp
  1059b6:	5b                   	pop    %ebx
  1059b7:	5d                   	pop    %ebp
  1059b8:	c3                   	ret    
  1059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  1059c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1059c3:	e8 28 dd ff ff       	call   1036f0 <curproc>
  1059c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1059cc:	89 04 24             	mov    %eax,(%esp)
  1059cf:	e8 fc e6 ff ff       	call   1040d0 <copyproc_tix>
  1059d4:	85 c0                	test   %eax,%eax
  1059d6:	89 c2                	mov    %eax,%edx
  1059d8:	74 d4                	je     1059ae <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  1059da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  1059dd:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  1059e0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  1059e7:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  1059ed:	eb c4                	jmp    1059b3 <sys_fork_tickets+0x23>
  1059ef:	90                   	nop

001059f0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1059f0:	55                   	push   %ebp
  1059f1:	89 e5                	mov    %esp,%ebp
  1059f3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1059f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1059f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1059fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1059ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105a0d:	e8 5e f0 ff ff       	call   104a70 <argint>
  105a12:	85 c0                	test   %eax,%eax
  105a14:	79 12                	jns    105a28 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105a16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105a1b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105a1e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105a21:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105a24:	89 ec                	mov    %ebp,%esp
  105a26:	5d                   	pop    %ebp
  105a27:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105a28:	8d 45 e0             	lea    -0x20(%ebp),%eax
  105a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105a36:	e8 35 f0 ff ff       	call   104a70 <argint>
  105a3b:	85 c0                	test   %eax,%eax
  105a3d:	78 d7                	js     105a16 <sys_fork_thread+0x26>
  105a3f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  105a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a46:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105a4d:	e8 1e f0 ff ff       	call   104a70 <argint>
  105a52:	85 c0                	test   %eax,%eax
  105a54:	78 c0                	js     105a16 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105a56:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105a59:	8b 75 e0             	mov    -0x20(%ebp),%esi
  105a5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  105a5f:	e8 8c dc ff ff       	call   1036f0 <curproc>
  105a64:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105a68:	89 74 24 08          	mov    %esi,0x8(%esp)
  105a6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105a70:	89 04 24             	mov    %eax,(%esp)
  105a73:	e8 98 e7 ff ff       	call   104210 <copyproc_threads>
  105a78:	89 c2                	mov    %eax,%edx
  105a7a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  105a7f:	85 d2                	test   %edx,%edx
  105a81:	74 98                	je     105a1b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  105a83:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  105a8a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  105a8d:	eb 8c                	jmp    105a1b <sys_fork_thread+0x2b>
  105a8f:	90                   	nop

00105a90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105a90:	55                   	push   %ebp
  105a91:	89 e5                	mov    %esp,%ebp
  105a93:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105a96:	e8 55 dc ff ff       	call   1036f0 <curproc>
  105a9b:	89 04 24             	mov    %eax,(%esp)
  105a9e:	e8 7d e8 ff ff       	call   104320 <copyproc>
  105aa3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105aa8:	85 c0                	test   %eax,%eax
  105aaa:	74 0a                	je     105ab6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  105aac:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  105aaf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105ab6:	89 d0                	mov    %edx,%eax
  105ab8:	c9                   	leave  
  105ab9:	c3                   	ret    
  105aba:	90                   	nop
  105abb:	90                   	nop
  105abc:	90                   	nop
  105abd:	90                   	nop
  105abe:	90                   	nop
  105abf:	90                   	nop

00105ac0 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105ac0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105ac1:	ba 43 00 00 00       	mov    $0x43,%edx
  105ac6:	89 e5                	mov    %esp,%ebp
  105ac8:	83 ec 18             	sub    $0x18,%esp
  105acb:	b8 34 00 00 00       	mov    $0x34,%eax
  105ad0:	ee                   	out    %al,(%dx)
  105ad1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105ad6:	b2 40                	mov    $0x40,%dl
  105ad8:	ee                   	out    %al,(%dx)
  105ad9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  105ade:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105ae6:	e8 15 d5 ff ff       	call   103000 <pic_enable>
}
  105aeb:	c9                   	leave  
  105aec:	c3                   	ret    
  105aed:	90                   	nop
  105aee:	90                   	nop
  105aef:	90                   	nop

00105af0 <alltraps>:
  105af0:	1e                   	push   %ds
  105af1:	06                   	push   %es
  105af2:	60                   	pusha  
  105af3:	b8 10 00 00 00       	mov    $0x10,%eax
  105af8:	8e d8                	mov    %eax,%ds
  105afa:	8e c0                	mov    %eax,%es
  105afc:	54                   	push   %esp
  105afd:	e8 4e 00 00 00       	call   105b50 <trap>
  105b02:	83 c4 04             	add    $0x4,%esp

00105b05 <trapret>:
  105b05:	61                   	popa   
  105b06:	07                   	pop    %es
  105b07:	1f                   	pop    %ds
  105b08:	83 c4 08             	add    $0x8,%esp
  105b0b:	cf                   	iret   

00105b0c <forkret1>:
  105b0c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105b10:	e9 f0 ff ff ff       	jmp    105b05 <trapret>
  105b15:	90                   	nop
  105b16:	90                   	nop
  105b17:	90                   	nop
  105b18:	90                   	nop
  105b19:	90                   	nop
  105b1a:	90                   	nop
  105b1b:	90                   	nop
  105b1c:	90                   	nop
  105b1d:	90                   	nop
  105b1e:	90                   	nop
  105b1f:	90                   	nop

00105b20 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105b20:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105b21:	b8 40 e9 10 00       	mov    $0x10e940,%eax
  105b26:	89 e5                	mov    %esp,%ebp
  105b28:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  105b2b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105b31:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105b35:	c1 e8 10             	shr    $0x10,%eax
  105b38:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  105b3c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  105b3f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105b42:	c9                   	leave  
  105b43:	c3                   	ret    
  105b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105b50 <trap>:

void
trap(struct trapframe *tf)
{
  105b50:	55                   	push   %ebp
  105b51:	89 e5                	mov    %esp,%ebp
  105b53:	83 ec 48             	sub    $0x48,%esp
  105b56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  105b5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105b5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  105b62:	8b 43 28             	mov    0x28(%ebx),%eax
  105b65:	83 f8 30             	cmp    $0x30,%eax
  105b68:	0f 84 8a 01 00 00    	je     105cf8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105b6e:	83 f8 21             	cmp    $0x21,%eax
  105b71:	0f 84 69 01 00 00    	je     105ce0 <trap+0x190>
  105b77:	76 47                	jbe    105bc0 <trap+0x70>
  105b79:	83 f8 2e             	cmp    $0x2e,%eax
  105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105b80:	0f 84 42 01 00 00    	je     105cc8 <trap+0x178>
  105b86:	83 f8 3f             	cmp    $0x3f,%eax
  105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105b90:	75 37                	jne    105bc9 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105b92:	8b 7b 30             	mov    0x30(%ebx),%edi
  105b95:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  105b99:	e8 c2 cf ff ff       	call   102b60 <cpu>
  105b9e:	c7 04 24 d4 6f 10 00 	movl   $0x106fd4,(%esp)
  105ba5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105ba9:	89 74 24 08          	mov    %esi,0x8(%esp)
  105bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb1:	e8 0a ac ff ff       	call   1007c0 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105bb6:	e8 15 ce ff ff       	call   1029d0 <lapic_eoi>
    break;
  105bbb:	e9 90 00 00 00       	jmp    105c50 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105bc0:	83 f8 20             	cmp    $0x20,%eax
  105bc3:	0f 84 e7 00 00 00    	je     105cb0 <trap+0x160>
  105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105bd0:	e8 1b db ff ff       	call   1036f0 <curproc>
  105bd5:	85 c0                	test   %eax,%eax
  105bd7:	0f 84 9b 01 00 00    	je     105d78 <trap+0x228>
  105bdd:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  105be1:	0f 84 91 01 00 00    	je     105d78 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105be7:	8b 53 30             	mov    0x30(%ebx),%edx
  105bea:	89 55 e0             	mov    %edx,-0x20(%ebp)
  105bed:	e8 6e cf ff ff       	call   102b60 <cpu>
  105bf2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  105bf5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105bf8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105bfb:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105bfd:	e8 ee da ff ff       	call   1036f0 <curproc>
  105c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c05:	e8 e6 da ff ff       	call   1036f0 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105c0d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105c11:	89 74 24 10          	mov    %esi,0x10(%esp)
  105c15:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c19:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105c1c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105c20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c23:	81 c2 88 00 00 00    	add    $0x88,%edx
  105c29:	89 54 24 08          	mov    %edx,0x8(%esp)
  105c2d:	8b 40 10             	mov    0x10(%eax),%eax
  105c30:	c7 04 24 20 70 10 00 	movl   $0x107020,(%esp)
  105c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c3b:	e8 80 ab ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105c40:	e8 ab da ff ff       	call   1036f0 <curproc>
  105c45:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105c50:	e8 9b da ff ff       	call   1036f0 <curproc>
  105c55:	85 c0                	test   %eax,%eax
  105c57:	74 1c                	je     105c75 <trap+0x125>
  105c59:	e8 92 da ff ff       	call   1036f0 <curproc>
  105c5e:	8b 40 1c             	mov    0x1c(%eax),%eax
  105c61:	85 c0                	test   %eax,%eax
  105c63:	74 10                	je     105c75 <trap+0x125>
  105c65:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105c69:	83 e0 03             	and    $0x3,%eax
  105c6c:	83 f8 03             	cmp    $0x3,%eax
  105c6f:	0f 84 33 01 00 00    	je     105da8 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105c75:	e8 76 da ff ff       	call   1036f0 <curproc>
  105c7a:	85 c0                	test   %eax,%eax
  105c7c:	74 0d                	je     105c8b <trap+0x13b>
  105c7e:	66 90                	xchg   %ax,%ax
  105c80:	e8 6b da ff ff       	call   1036f0 <curproc>
  105c85:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105c89:	74 0d                	je     105c98 <trap+0x148>
    yield();
}
  105c8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105c8e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105c91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105c94:	89 ec                	mov    %ebp,%esp
  105c96:	5d                   	pop    %ebp
  105c97:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105c98:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  105c9c:	75 ed                	jne    105c8b <trap+0x13b>
    yield();
}
  105c9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105ca1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105ca4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105ca7:	89 ec                	mov    %ebp,%esp
  105ca9:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105caa:	e9 d1 df ff ff       	jmp    103c80 <yield>
  105caf:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105cb0:	e8 ab ce ff ff       	call   102b60 <cpu>
  105cb5:	85 c0                	test   %eax,%eax
  105cb7:	0f 84 8b 00 00 00    	je     105d48 <trap+0x1f8>
  105cbd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  105cc0:	e8 0b cd ff ff       	call   1029d0 <lapic_eoi>
    break;
  105cc5:	eb 89                	jmp    105c50 <trap+0x100>
  105cc7:	90                   	nop
  105cc8:	90                   	nop
  105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105cd0:	e8 eb c6 ff ff       	call   1023c0 <ide_intr>
  105cd5:	8d 76 00             	lea    0x0(%esi),%esi
  105cd8:	eb e3                	jmp    105cbd <trap+0x16d>
  105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105ce0:	e8 db cb ff ff       	call   1028c0 <kbd_intr>
  105ce5:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  105ce8:	e8 e3 cc ff ff       	call   1029d0 <lapic_eoi>
  105ced:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105cf0:	e9 5b ff ff ff       	jmp    105c50 <trap+0x100>
  105cf5:	8d 76 00             	lea    0x0(%esi),%esi
  105cf8:	90                   	nop
  105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105d00:	e8 eb d9 ff ff       	call   1036f0 <curproc>
  105d05:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105d08:	85 c9                	test   %ecx,%ecx
  105d0a:	0f 85 a8 00 00 00    	jne    105db8 <trap+0x268>
      exit();
    cp->tf = tf;
  105d10:	e8 db d9 ff ff       	call   1036f0 <curproc>
  105d15:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  105d1b:	e8 80 ee ff ff       	call   104ba0 <syscall>
    if(cp->killed)
  105d20:	e8 cb d9 ff ff       	call   1036f0 <curproc>
  105d25:	8b 50 1c             	mov    0x1c(%eax),%edx
  105d28:	85 d2                	test   %edx,%edx
  105d2a:	0f 84 5b ff ff ff    	je     105c8b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105d30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105d33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105d36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105d39:	89 ec                	mov    %ebp,%esp
  105d3b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105d3c:	e9 af da ff ff       	jmp    1037f0 <exit>
  105d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105d48:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  105d4f:	e8 dc e9 ff ff       	call   104730 <acquire>
      ticks++;
  105d54:	83 05 40 f1 10 00 01 	addl   $0x1,0x10f140
      wakeup(&ticks);
  105d5b:	c7 04 24 40 f1 10 00 	movl   $0x10f140,(%esp)
  105d62:	e8 89 d8 ff ff       	call   1035f0 <wakeup>
      release(&tickslock);
  105d67:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  105d6e:	e8 7d e9 ff ff       	call   1046f0 <release>
  105d73:	e9 45 ff ff ff       	jmp    105cbd <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105d78:	8b 73 30             	mov    0x30(%ebx),%esi
  105d7b:	e8 e0 cd ff ff       	call   102b60 <cpu>
  105d80:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105d84:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d88:	8b 43 28             	mov    0x28(%ebx),%eax
  105d8b:	c7 04 24 f8 6f 10 00 	movl   $0x106ff8,(%esp)
  105d92:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d96:	e8 25 aa ff ff       	call   1007c0 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105d9b:	c7 04 24 5c 70 10 00 	movl   $0x10705c,(%esp)
  105da2:	e8 b9 ab ff ff       	call   100960 <panic>
  105da7:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105da8:	e8 43 da ff ff       	call   1037f0 <exit>
  105dad:	e9 c3 fe ff ff       	jmp    105c75 <trap+0x125>
  105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105db8:	90                   	nop
  105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105dc0:	e8 2b da ff ff       	call   1037f0 <exit>
  105dc5:	8d 76 00             	lea    0x0(%esi),%esi
  105dc8:	e9 43 ff ff ff       	jmp    105d10 <trap+0x1c0>
  105dcd:	8d 76 00             	lea    0x0(%esi),%esi

00105dd0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105dd0:	55                   	push   %ebp
  105dd1:	31 c0                	xor    %eax,%eax
  105dd3:	89 e5                	mov    %esp,%ebp
  105dd5:	ba 40 e9 10 00       	mov    $0x10e940,%edx
  105dda:	83 ec 18             	sub    $0x18,%esp
  105ddd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105de0:	8b 0c 85 88 83 10 00 	mov    0x108388(,%eax,4),%ecx
  105de7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105dee:	66 89 0c c5 40 e9 10 	mov    %cx,0x10e940(,%eax,8)
  105df5:	00 
  105df6:	c1 e9 10             	shr    $0x10,%ecx
  105df9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  105dfe:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105e03:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105e08:	83 c0 01             	add    $0x1,%eax
  105e0b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105e10:	75 ce                	jne    105de0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105e12:	a1 48 84 10 00       	mov    0x108448,%eax
  
  initlock(&tickslock, "time");
  105e17:	c7 44 24 04 61 70 10 	movl   $0x107061,0x4(%esp)
  105e1e:	00 
  105e1f:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105e26:	66 c7 05 c2 ea 10 00 	movw   $0x8,0x10eac2
  105e2d:	08 00 
  105e2f:	66 a3 c0 ea 10 00    	mov    %ax,0x10eac0
  105e35:	c1 e8 10             	shr    $0x10,%eax
  105e38:	c6 05 c4 ea 10 00 00 	movb   $0x0,0x10eac4
  105e3f:	c6 05 c5 ea 10 00 ef 	movb   $0xef,0x10eac5
  105e46:	66 a3 c6 ea 10 00    	mov    %ax,0x10eac6
  
  initlock(&tickslock, "time");
  105e4c:	e8 1f e7 ff ff       	call   104570 <initlock>
}
  105e51:	c9                   	leave  
  105e52:	c3                   	ret    
  105e53:	90                   	nop

00105e54 <vector0>:
  105e54:	6a 00                	push   $0x0
  105e56:	6a 00                	push   $0x0
  105e58:	e9 93 fc ff ff       	jmp    105af0 <alltraps>

00105e5d <vector1>:
  105e5d:	6a 00                	push   $0x0
  105e5f:	6a 01                	push   $0x1
  105e61:	e9 8a fc ff ff       	jmp    105af0 <alltraps>

00105e66 <vector2>:
  105e66:	6a 00                	push   $0x0
  105e68:	6a 02                	push   $0x2
  105e6a:	e9 81 fc ff ff       	jmp    105af0 <alltraps>

00105e6f <vector3>:
  105e6f:	6a 00                	push   $0x0
  105e71:	6a 03                	push   $0x3
  105e73:	e9 78 fc ff ff       	jmp    105af0 <alltraps>

00105e78 <vector4>:
  105e78:	6a 00                	push   $0x0
  105e7a:	6a 04                	push   $0x4
  105e7c:	e9 6f fc ff ff       	jmp    105af0 <alltraps>

00105e81 <vector5>:
  105e81:	6a 00                	push   $0x0
  105e83:	6a 05                	push   $0x5
  105e85:	e9 66 fc ff ff       	jmp    105af0 <alltraps>

00105e8a <vector6>:
  105e8a:	6a 00                	push   $0x0
  105e8c:	6a 06                	push   $0x6
  105e8e:	e9 5d fc ff ff       	jmp    105af0 <alltraps>

00105e93 <vector7>:
  105e93:	6a 00                	push   $0x0
  105e95:	6a 07                	push   $0x7
  105e97:	e9 54 fc ff ff       	jmp    105af0 <alltraps>

00105e9c <vector8>:
  105e9c:	6a 08                	push   $0x8
  105e9e:	e9 4d fc ff ff       	jmp    105af0 <alltraps>

00105ea3 <vector9>:
  105ea3:	6a 09                	push   $0x9
  105ea5:	e9 46 fc ff ff       	jmp    105af0 <alltraps>

00105eaa <vector10>:
  105eaa:	6a 0a                	push   $0xa
  105eac:	e9 3f fc ff ff       	jmp    105af0 <alltraps>

00105eb1 <vector11>:
  105eb1:	6a 0b                	push   $0xb
  105eb3:	e9 38 fc ff ff       	jmp    105af0 <alltraps>

00105eb8 <vector12>:
  105eb8:	6a 0c                	push   $0xc
  105eba:	e9 31 fc ff ff       	jmp    105af0 <alltraps>

00105ebf <vector13>:
  105ebf:	6a 0d                	push   $0xd
  105ec1:	e9 2a fc ff ff       	jmp    105af0 <alltraps>

00105ec6 <vector14>:
  105ec6:	6a 0e                	push   $0xe
  105ec8:	e9 23 fc ff ff       	jmp    105af0 <alltraps>

00105ecd <vector15>:
  105ecd:	6a 00                	push   $0x0
  105ecf:	6a 0f                	push   $0xf
  105ed1:	e9 1a fc ff ff       	jmp    105af0 <alltraps>

00105ed6 <vector16>:
  105ed6:	6a 00                	push   $0x0
  105ed8:	6a 10                	push   $0x10
  105eda:	e9 11 fc ff ff       	jmp    105af0 <alltraps>

00105edf <vector17>:
  105edf:	6a 11                	push   $0x11
  105ee1:	e9 0a fc ff ff       	jmp    105af0 <alltraps>

00105ee6 <vector18>:
  105ee6:	6a 00                	push   $0x0
  105ee8:	6a 12                	push   $0x12
  105eea:	e9 01 fc ff ff       	jmp    105af0 <alltraps>

00105eef <vector19>:
  105eef:	6a 00                	push   $0x0
  105ef1:	6a 13                	push   $0x13
  105ef3:	e9 f8 fb ff ff       	jmp    105af0 <alltraps>

00105ef8 <vector20>:
  105ef8:	6a 00                	push   $0x0
  105efa:	6a 14                	push   $0x14
  105efc:	e9 ef fb ff ff       	jmp    105af0 <alltraps>

00105f01 <vector21>:
  105f01:	6a 00                	push   $0x0
  105f03:	6a 15                	push   $0x15
  105f05:	e9 e6 fb ff ff       	jmp    105af0 <alltraps>

00105f0a <vector22>:
  105f0a:	6a 00                	push   $0x0
  105f0c:	6a 16                	push   $0x16
  105f0e:	e9 dd fb ff ff       	jmp    105af0 <alltraps>

00105f13 <vector23>:
  105f13:	6a 00                	push   $0x0
  105f15:	6a 17                	push   $0x17
  105f17:	e9 d4 fb ff ff       	jmp    105af0 <alltraps>

00105f1c <vector24>:
  105f1c:	6a 00                	push   $0x0
  105f1e:	6a 18                	push   $0x18
  105f20:	e9 cb fb ff ff       	jmp    105af0 <alltraps>

00105f25 <vector25>:
  105f25:	6a 00                	push   $0x0
  105f27:	6a 19                	push   $0x19
  105f29:	e9 c2 fb ff ff       	jmp    105af0 <alltraps>

00105f2e <vector26>:
  105f2e:	6a 00                	push   $0x0
  105f30:	6a 1a                	push   $0x1a
  105f32:	e9 b9 fb ff ff       	jmp    105af0 <alltraps>

00105f37 <vector27>:
  105f37:	6a 00                	push   $0x0
  105f39:	6a 1b                	push   $0x1b
  105f3b:	e9 b0 fb ff ff       	jmp    105af0 <alltraps>

00105f40 <vector28>:
  105f40:	6a 00                	push   $0x0
  105f42:	6a 1c                	push   $0x1c
  105f44:	e9 a7 fb ff ff       	jmp    105af0 <alltraps>

00105f49 <vector29>:
  105f49:	6a 00                	push   $0x0
  105f4b:	6a 1d                	push   $0x1d
  105f4d:	e9 9e fb ff ff       	jmp    105af0 <alltraps>

00105f52 <vector30>:
  105f52:	6a 00                	push   $0x0
  105f54:	6a 1e                	push   $0x1e
  105f56:	e9 95 fb ff ff       	jmp    105af0 <alltraps>

00105f5b <vector31>:
  105f5b:	6a 00                	push   $0x0
  105f5d:	6a 1f                	push   $0x1f
  105f5f:	e9 8c fb ff ff       	jmp    105af0 <alltraps>

00105f64 <vector32>:
  105f64:	6a 00                	push   $0x0
  105f66:	6a 20                	push   $0x20
  105f68:	e9 83 fb ff ff       	jmp    105af0 <alltraps>

00105f6d <vector33>:
  105f6d:	6a 00                	push   $0x0
  105f6f:	6a 21                	push   $0x21
  105f71:	e9 7a fb ff ff       	jmp    105af0 <alltraps>

00105f76 <vector34>:
  105f76:	6a 00                	push   $0x0
  105f78:	6a 22                	push   $0x22
  105f7a:	e9 71 fb ff ff       	jmp    105af0 <alltraps>

00105f7f <vector35>:
  105f7f:	6a 00                	push   $0x0
  105f81:	6a 23                	push   $0x23
  105f83:	e9 68 fb ff ff       	jmp    105af0 <alltraps>

00105f88 <vector36>:
  105f88:	6a 00                	push   $0x0
  105f8a:	6a 24                	push   $0x24
  105f8c:	e9 5f fb ff ff       	jmp    105af0 <alltraps>

00105f91 <vector37>:
  105f91:	6a 00                	push   $0x0
  105f93:	6a 25                	push   $0x25
  105f95:	e9 56 fb ff ff       	jmp    105af0 <alltraps>

00105f9a <vector38>:
  105f9a:	6a 00                	push   $0x0
  105f9c:	6a 26                	push   $0x26
  105f9e:	e9 4d fb ff ff       	jmp    105af0 <alltraps>

00105fa3 <vector39>:
  105fa3:	6a 00                	push   $0x0
  105fa5:	6a 27                	push   $0x27
  105fa7:	e9 44 fb ff ff       	jmp    105af0 <alltraps>

00105fac <vector40>:
  105fac:	6a 00                	push   $0x0
  105fae:	6a 28                	push   $0x28
  105fb0:	e9 3b fb ff ff       	jmp    105af0 <alltraps>

00105fb5 <vector41>:
  105fb5:	6a 00                	push   $0x0
  105fb7:	6a 29                	push   $0x29
  105fb9:	e9 32 fb ff ff       	jmp    105af0 <alltraps>

00105fbe <vector42>:
  105fbe:	6a 00                	push   $0x0
  105fc0:	6a 2a                	push   $0x2a
  105fc2:	e9 29 fb ff ff       	jmp    105af0 <alltraps>

00105fc7 <vector43>:
  105fc7:	6a 00                	push   $0x0
  105fc9:	6a 2b                	push   $0x2b
  105fcb:	e9 20 fb ff ff       	jmp    105af0 <alltraps>

00105fd0 <vector44>:
  105fd0:	6a 00                	push   $0x0
  105fd2:	6a 2c                	push   $0x2c
  105fd4:	e9 17 fb ff ff       	jmp    105af0 <alltraps>

00105fd9 <vector45>:
  105fd9:	6a 00                	push   $0x0
  105fdb:	6a 2d                	push   $0x2d
  105fdd:	e9 0e fb ff ff       	jmp    105af0 <alltraps>

00105fe2 <vector46>:
  105fe2:	6a 00                	push   $0x0
  105fe4:	6a 2e                	push   $0x2e
  105fe6:	e9 05 fb ff ff       	jmp    105af0 <alltraps>

00105feb <vector47>:
  105feb:	6a 00                	push   $0x0
  105fed:	6a 2f                	push   $0x2f
  105fef:	e9 fc fa ff ff       	jmp    105af0 <alltraps>

00105ff4 <vector48>:
  105ff4:	6a 00                	push   $0x0
  105ff6:	6a 30                	push   $0x30
  105ff8:	e9 f3 fa ff ff       	jmp    105af0 <alltraps>

00105ffd <vector49>:
  105ffd:	6a 00                	push   $0x0
  105fff:	6a 31                	push   $0x31
  106001:	e9 ea fa ff ff       	jmp    105af0 <alltraps>

00106006 <vector50>:
  106006:	6a 00                	push   $0x0
  106008:	6a 32                	push   $0x32
  10600a:	e9 e1 fa ff ff       	jmp    105af0 <alltraps>

0010600f <vector51>:
  10600f:	6a 00                	push   $0x0
  106011:	6a 33                	push   $0x33
  106013:	e9 d8 fa ff ff       	jmp    105af0 <alltraps>

00106018 <vector52>:
  106018:	6a 00                	push   $0x0
  10601a:	6a 34                	push   $0x34
  10601c:	e9 cf fa ff ff       	jmp    105af0 <alltraps>

00106021 <vector53>:
  106021:	6a 00                	push   $0x0
  106023:	6a 35                	push   $0x35
  106025:	e9 c6 fa ff ff       	jmp    105af0 <alltraps>

0010602a <vector54>:
  10602a:	6a 00                	push   $0x0
  10602c:	6a 36                	push   $0x36
  10602e:	e9 bd fa ff ff       	jmp    105af0 <alltraps>

00106033 <vector55>:
  106033:	6a 00                	push   $0x0
  106035:	6a 37                	push   $0x37
  106037:	e9 b4 fa ff ff       	jmp    105af0 <alltraps>

0010603c <vector56>:
  10603c:	6a 00                	push   $0x0
  10603e:	6a 38                	push   $0x38
  106040:	e9 ab fa ff ff       	jmp    105af0 <alltraps>

00106045 <vector57>:
  106045:	6a 00                	push   $0x0
  106047:	6a 39                	push   $0x39
  106049:	e9 a2 fa ff ff       	jmp    105af0 <alltraps>

0010604e <vector58>:
  10604e:	6a 00                	push   $0x0
  106050:	6a 3a                	push   $0x3a
  106052:	e9 99 fa ff ff       	jmp    105af0 <alltraps>

00106057 <vector59>:
  106057:	6a 00                	push   $0x0
  106059:	6a 3b                	push   $0x3b
  10605b:	e9 90 fa ff ff       	jmp    105af0 <alltraps>

00106060 <vector60>:
  106060:	6a 00                	push   $0x0
  106062:	6a 3c                	push   $0x3c
  106064:	e9 87 fa ff ff       	jmp    105af0 <alltraps>

00106069 <vector61>:
  106069:	6a 00                	push   $0x0
  10606b:	6a 3d                	push   $0x3d
  10606d:	e9 7e fa ff ff       	jmp    105af0 <alltraps>

00106072 <vector62>:
  106072:	6a 00                	push   $0x0
  106074:	6a 3e                	push   $0x3e
  106076:	e9 75 fa ff ff       	jmp    105af0 <alltraps>

0010607b <vector63>:
  10607b:	6a 00                	push   $0x0
  10607d:	6a 3f                	push   $0x3f
  10607f:	e9 6c fa ff ff       	jmp    105af0 <alltraps>

00106084 <vector64>:
  106084:	6a 00                	push   $0x0
  106086:	6a 40                	push   $0x40
  106088:	e9 63 fa ff ff       	jmp    105af0 <alltraps>

0010608d <vector65>:
  10608d:	6a 00                	push   $0x0
  10608f:	6a 41                	push   $0x41
  106091:	e9 5a fa ff ff       	jmp    105af0 <alltraps>

00106096 <vector66>:
  106096:	6a 00                	push   $0x0
  106098:	6a 42                	push   $0x42
  10609a:	e9 51 fa ff ff       	jmp    105af0 <alltraps>

0010609f <vector67>:
  10609f:	6a 00                	push   $0x0
  1060a1:	6a 43                	push   $0x43
  1060a3:	e9 48 fa ff ff       	jmp    105af0 <alltraps>

001060a8 <vector68>:
  1060a8:	6a 00                	push   $0x0
  1060aa:	6a 44                	push   $0x44
  1060ac:	e9 3f fa ff ff       	jmp    105af0 <alltraps>

001060b1 <vector69>:
  1060b1:	6a 00                	push   $0x0
  1060b3:	6a 45                	push   $0x45
  1060b5:	e9 36 fa ff ff       	jmp    105af0 <alltraps>

001060ba <vector70>:
  1060ba:	6a 00                	push   $0x0
  1060bc:	6a 46                	push   $0x46
  1060be:	e9 2d fa ff ff       	jmp    105af0 <alltraps>

001060c3 <vector71>:
  1060c3:	6a 00                	push   $0x0
  1060c5:	6a 47                	push   $0x47
  1060c7:	e9 24 fa ff ff       	jmp    105af0 <alltraps>

001060cc <vector72>:
  1060cc:	6a 00                	push   $0x0
  1060ce:	6a 48                	push   $0x48
  1060d0:	e9 1b fa ff ff       	jmp    105af0 <alltraps>

001060d5 <vector73>:
  1060d5:	6a 00                	push   $0x0
  1060d7:	6a 49                	push   $0x49
  1060d9:	e9 12 fa ff ff       	jmp    105af0 <alltraps>

001060de <vector74>:
  1060de:	6a 00                	push   $0x0
  1060e0:	6a 4a                	push   $0x4a
  1060e2:	e9 09 fa ff ff       	jmp    105af0 <alltraps>

001060e7 <vector75>:
  1060e7:	6a 00                	push   $0x0
  1060e9:	6a 4b                	push   $0x4b
  1060eb:	e9 00 fa ff ff       	jmp    105af0 <alltraps>

001060f0 <vector76>:
  1060f0:	6a 00                	push   $0x0
  1060f2:	6a 4c                	push   $0x4c
  1060f4:	e9 f7 f9 ff ff       	jmp    105af0 <alltraps>

001060f9 <vector77>:
  1060f9:	6a 00                	push   $0x0
  1060fb:	6a 4d                	push   $0x4d
  1060fd:	e9 ee f9 ff ff       	jmp    105af0 <alltraps>

00106102 <vector78>:
  106102:	6a 00                	push   $0x0
  106104:	6a 4e                	push   $0x4e
  106106:	e9 e5 f9 ff ff       	jmp    105af0 <alltraps>

0010610b <vector79>:
  10610b:	6a 00                	push   $0x0
  10610d:	6a 4f                	push   $0x4f
  10610f:	e9 dc f9 ff ff       	jmp    105af0 <alltraps>

00106114 <vector80>:
  106114:	6a 00                	push   $0x0
  106116:	6a 50                	push   $0x50
  106118:	e9 d3 f9 ff ff       	jmp    105af0 <alltraps>

0010611d <vector81>:
  10611d:	6a 00                	push   $0x0
  10611f:	6a 51                	push   $0x51
  106121:	e9 ca f9 ff ff       	jmp    105af0 <alltraps>

00106126 <vector82>:
  106126:	6a 00                	push   $0x0
  106128:	6a 52                	push   $0x52
  10612a:	e9 c1 f9 ff ff       	jmp    105af0 <alltraps>

0010612f <vector83>:
  10612f:	6a 00                	push   $0x0
  106131:	6a 53                	push   $0x53
  106133:	e9 b8 f9 ff ff       	jmp    105af0 <alltraps>

00106138 <vector84>:
  106138:	6a 00                	push   $0x0
  10613a:	6a 54                	push   $0x54
  10613c:	e9 af f9 ff ff       	jmp    105af0 <alltraps>

00106141 <vector85>:
  106141:	6a 00                	push   $0x0
  106143:	6a 55                	push   $0x55
  106145:	e9 a6 f9 ff ff       	jmp    105af0 <alltraps>

0010614a <vector86>:
  10614a:	6a 00                	push   $0x0
  10614c:	6a 56                	push   $0x56
  10614e:	e9 9d f9 ff ff       	jmp    105af0 <alltraps>

00106153 <vector87>:
  106153:	6a 00                	push   $0x0
  106155:	6a 57                	push   $0x57
  106157:	e9 94 f9 ff ff       	jmp    105af0 <alltraps>

0010615c <vector88>:
  10615c:	6a 00                	push   $0x0
  10615e:	6a 58                	push   $0x58
  106160:	e9 8b f9 ff ff       	jmp    105af0 <alltraps>

00106165 <vector89>:
  106165:	6a 00                	push   $0x0
  106167:	6a 59                	push   $0x59
  106169:	e9 82 f9 ff ff       	jmp    105af0 <alltraps>

0010616e <vector90>:
  10616e:	6a 00                	push   $0x0
  106170:	6a 5a                	push   $0x5a
  106172:	e9 79 f9 ff ff       	jmp    105af0 <alltraps>

00106177 <vector91>:
  106177:	6a 00                	push   $0x0
  106179:	6a 5b                	push   $0x5b
  10617b:	e9 70 f9 ff ff       	jmp    105af0 <alltraps>

00106180 <vector92>:
  106180:	6a 00                	push   $0x0
  106182:	6a 5c                	push   $0x5c
  106184:	e9 67 f9 ff ff       	jmp    105af0 <alltraps>

00106189 <vector93>:
  106189:	6a 00                	push   $0x0
  10618b:	6a 5d                	push   $0x5d
  10618d:	e9 5e f9 ff ff       	jmp    105af0 <alltraps>

00106192 <vector94>:
  106192:	6a 00                	push   $0x0
  106194:	6a 5e                	push   $0x5e
  106196:	e9 55 f9 ff ff       	jmp    105af0 <alltraps>

0010619b <vector95>:
  10619b:	6a 00                	push   $0x0
  10619d:	6a 5f                	push   $0x5f
  10619f:	e9 4c f9 ff ff       	jmp    105af0 <alltraps>

001061a4 <vector96>:
  1061a4:	6a 00                	push   $0x0
  1061a6:	6a 60                	push   $0x60
  1061a8:	e9 43 f9 ff ff       	jmp    105af0 <alltraps>

001061ad <vector97>:
  1061ad:	6a 00                	push   $0x0
  1061af:	6a 61                	push   $0x61
  1061b1:	e9 3a f9 ff ff       	jmp    105af0 <alltraps>

001061b6 <vector98>:
  1061b6:	6a 00                	push   $0x0
  1061b8:	6a 62                	push   $0x62
  1061ba:	e9 31 f9 ff ff       	jmp    105af0 <alltraps>

001061bf <vector99>:
  1061bf:	6a 00                	push   $0x0
  1061c1:	6a 63                	push   $0x63
  1061c3:	e9 28 f9 ff ff       	jmp    105af0 <alltraps>

001061c8 <vector100>:
  1061c8:	6a 00                	push   $0x0
  1061ca:	6a 64                	push   $0x64
  1061cc:	e9 1f f9 ff ff       	jmp    105af0 <alltraps>

001061d1 <vector101>:
  1061d1:	6a 00                	push   $0x0
  1061d3:	6a 65                	push   $0x65
  1061d5:	e9 16 f9 ff ff       	jmp    105af0 <alltraps>

001061da <vector102>:
  1061da:	6a 00                	push   $0x0
  1061dc:	6a 66                	push   $0x66
  1061de:	e9 0d f9 ff ff       	jmp    105af0 <alltraps>

001061e3 <vector103>:
  1061e3:	6a 00                	push   $0x0
  1061e5:	6a 67                	push   $0x67
  1061e7:	e9 04 f9 ff ff       	jmp    105af0 <alltraps>

001061ec <vector104>:
  1061ec:	6a 00                	push   $0x0
  1061ee:	6a 68                	push   $0x68
  1061f0:	e9 fb f8 ff ff       	jmp    105af0 <alltraps>

001061f5 <vector105>:
  1061f5:	6a 00                	push   $0x0
  1061f7:	6a 69                	push   $0x69
  1061f9:	e9 f2 f8 ff ff       	jmp    105af0 <alltraps>

001061fe <vector106>:
  1061fe:	6a 00                	push   $0x0
  106200:	6a 6a                	push   $0x6a
  106202:	e9 e9 f8 ff ff       	jmp    105af0 <alltraps>

00106207 <vector107>:
  106207:	6a 00                	push   $0x0
  106209:	6a 6b                	push   $0x6b
  10620b:	e9 e0 f8 ff ff       	jmp    105af0 <alltraps>

00106210 <vector108>:
  106210:	6a 00                	push   $0x0
  106212:	6a 6c                	push   $0x6c
  106214:	e9 d7 f8 ff ff       	jmp    105af0 <alltraps>

00106219 <vector109>:
  106219:	6a 00                	push   $0x0
  10621b:	6a 6d                	push   $0x6d
  10621d:	e9 ce f8 ff ff       	jmp    105af0 <alltraps>

00106222 <vector110>:
  106222:	6a 00                	push   $0x0
  106224:	6a 6e                	push   $0x6e
  106226:	e9 c5 f8 ff ff       	jmp    105af0 <alltraps>

0010622b <vector111>:
  10622b:	6a 00                	push   $0x0
  10622d:	6a 6f                	push   $0x6f
  10622f:	e9 bc f8 ff ff       	jmp    105af0 <alltraps>

00106234 <vector112>:
  106234:	6a 00                	push   $0x0
  106236:	6a 70                	push   $0x70
  106238:	e9 b3 f8 ff ff       	jmp    105af0 <alltraps>

0010623d <vector113>:
  10623d:	6a 00                	push   $0x0
  10623f:	6a 71                	push   $0x71
  106241:	e9 aa f8 ff ff       	jmp    105af0 <alltraps>

00106246 <vector114>:
  106246:	6a 00                	push   $0x0
  106248:	6a 72                	push   $0x72
  10624a:	e9 a1 f8 ff ff       	jmp    105af0 <alltraps>

0010624f <vector115>:
  10624f:	6a 00                	push   $0x0
  106251:	6a 73                	push   $0x73
  106253:	e9 98 f8 ff ff       	jmp    105af0 <alltraps>

00106258 <vector116>:
  106258:	6a 00                	push   $0x0
  10625a:	6a 74                	push   $0x74
  10625c:	e9 8f f8 ff ff       	jmp    105af0 <alltraps>

00106261 <vector117>:
  106261:	6a 00                	push   $0x0
  106263:	6a 75                	push   $0x75
  106265:	e9 86 f8 ff ff       	jmp    105af0 <alltraps>

0010626a <vector118>:
  10626a:	6a 00                	push   $0x0
  10626c:	6a 76                	push   $0x76
  10626e:	e9 7d f8 ff ff       	jmp    105af0 <alltraps>

00106273 <vector119>:
  106273:	6a 00                	push   $0x0
  106275:	6a 77                	push   $0x77
  106277:	e9 74 f8 ff ff       	jmp    105af0 <alltraps>

0010627c <vector120>:
  10627c:	6a 00                	push   $0x0
  10627e:	6a 78                	push   $0x78
  106280:	e9 6b f8 ff ff       	jmp    105af0 <alltraps>

00106285 <vector121>:
  106285:	6a 00                	push   $0x0
  106287:	6a 79                	push   $0x79
  106289:	e9 62 f8 ff ff       	jmp    105af0 <alltraps>

0010628e <vector122>:
  10628e:	6a 00                	push   $0x0
  106290:	6a 7a                	push   $0x7a
  106292:	e9 59 f8 ff ff       	jmp    105af0 <alltraps>

00106297 <vector123>:
  106297:	6a 00                	push   $0x0
  106299:	6a 7b                	push   $0x7b
  10629b:	e9 50 f8 ff ff       	jmp    105af0 <alltraps>

001062a0 <vector124>:
  1062a0:	6a 00                	push   $0x0
  1062a2:	6a 7c                	push   $0x7c
  1062a4:	e9 47 f8 ff ff       	jmp    105af0 <alltraps>

001062a9 <vector125>:
  1062a9:	6a 00                	push   $0x0
  1062ab:	6a 7d                	push   $0x7d
  1062ad:	e9 3e f8 ff ff       	jmp    105af0 <alltraps>

001062b2 <vector126>:
  1062b2:	6a 00                	push   $0x0
  1062b4:	6a 7e                	push   $0x7e
  1062b6:	e9 35 f8 ff ff       	jmp    105af0 <alltraps>

001062bb <vector127>:
  1062bb:	6a 00                	push   $0x0
  1062bd:	6a 7f                	push   $0x7f
  1062bf:	e9 2c f8 ff ff       	jmp    105af0 <alltraps>

001062c4 <vector128>:
  1062c4:	6a 00                	push   $0x0
  1062c6:	68 80 00 00 00       	push   $0x80
  1062cb:	e9 20 f8 ff ff       	jmp    105af0 <alltraps>

001062d0 <vector129>:
  1062d0:	6a 00                	push   $0x0
  1062d2:	68 81 00 00 00       	push   $0x81
  1062d7:	e9 14 f8 ff ff       	jmp    105af0 <alltraps>

001062dc <vector130>:
  1062dc:	6a 00                	push   $0x0
  1062de:	68 82 00 00 00       	push   $0x82
  1062e3:	e9 08 f8 ff ff       	jmp    105af0 <alltraps>

001062e8 <vector131>:
  1062e8:	6a 00                	push   $0x0
  1062ea:	68 83 00 00 00       	push   $0x83
  1062ef:	e9 fc f7 ff ff       	jmp    105af0 <alltraps>

001062f4 <vector132>:
  1062f4:	6a 00                	push   $0x0
  1062f6:	68 84 00 00 00       	push   $0x84
  1062fb:	e9 f0 f7 ff ff       	jmp    105af0 <alltraps>

00106300 <vector133>:
  106300:	6a 00                	push   $0x0
  106302:	68 85 00 00 00       	push   $0x85
  106307:	e9 e4 f7 ff ff       	jmp    105af0 <alltraps>

0010630c <vector134>:
  10630c:	6a 00                	push   $0x0
  10630e:	68 86 00 00 00       	push   $0x86
  106313:	e9 d8 f7 ff ff       	jmp    105af0 <alltraps>

00106318 <vector135>:
  106318:	6a 00                	push   $0x0
  10631a:	68 87 00 00 00       	push   $0x87
  10631f:	e9 cc f7 ff ff       	jmp    105af0 <alltraps>

00106324 <vector136>:
  106324:	6a 00                	push   $0x0
  106326:	68 88 00 00 00       	push   $0x88
  10632b:	e9 c0 f7 ff ff       	jmp    105af0 <alltraps>

00106330 <vector137>:
  106330:	6a 00                	push   $0x0
  106332:	68 89 00 00 00       	push   $0x89
  106337:	e9 b4 f7 ff ff       	jmp    105af0 <alltraps>

0010633c <vector138>:
  10633c:	6a 00                	push   $0x0
  10633e:	68 8a 00 00 00       	push   $0x8a
  106343:	e9 a8 f7 ff ff       	jmp    105af0 <alltraps>

00106348 <vector139>:
  106348:	6a 00                	push   $0x0
  10634a:	68 8b 00 00 00       	push   $0x8b
  10634f:	e9 9c f7 ff ff       	jmp    105af0 <alltraps>

00106354 <vector140>:
  106354:	6a 00                	push   $0x0
  106356:	68 8c 00 00 00       	push   $0x8c
  10635b:	e9 90 f7 ff ff       	jmp    105af0 <alltraps>

00106360 <vector141>:
  106360:	6a 00                	push   $0x0
  106362:	68 8d 00 00 00       	push   $0x8d
  106367:	e9 84 f7 ff ff       	jmp    105af0 <alltraps>

0010636c <vector142>:
  10636c:	6a 00                	push   $0x0
  10636e:	68 8e 00 00 00       	push   $0x8e
  106373:	e9 78 f7 ff ff       	jmp    105af0 <alltraps>

00106378 <vector143>:
  106378:	6a 00                	push   $0x0
  10637a:	68 8f 00 00 00       	push   $0x8f
  10637f:	e9 6c f7 ff ff       	jmp    105af0 <alltraps>

00106384 <vector144>:
  106384:	6a 00                	push   $0x0
  106386:	68 90 00 00 00       	push   $0x90
  10638b:	e9 60 f7 ff ff       	jmp    105af0 <alltraps>

00106390 <vector145>:
  106390:	6a 00                	push   $0x0
  106392:	68 91 00 00 00       	push   $0x91
  106397:	e9 54 f7 ff ff       	jmp    105af0 <alltraps>

0010639c <vector146>:
  10639c:	6a 00                	push   $0x0
  10639e:	68 92 00 00 00       	push   $0x92
  1063a3:	e9 48 f7 ff ff       	jmp    105af0 <alltraps>

001063a8 <vector147>:
  1063a8:	6a 00                	push   $0x0
  1063aa:	68 93 00 00 00       	push   $0x93
  1063af:	e9 3c f7 ff ff       	jmp    105af0 <alltraps>

001063b4 <vector148>:
  1063b4:	6a 00                	push   $0x0
  1063b6:	68 94 00 00 00       	push   $0x94
  1063bb:	e9 30 f7 ff ff       	jmp    105af0 <alltraps>

001063c0 <vector149>:
  1063c0:	6a 00                	push   $0x0
  1063c2:	68 95 00 00 00       	push   $0x95
  1063c7:	e9 24 f7 ff ff       	jmp    105af0 <alltraps>

001063cc <vector150>:
  1063cc:	6a 00                	push   $0x0
  1063ce:	68 96 00 00 00       	push   $0x96
  1063d3:	e9 18 f7 ff ff       	jmp    105af0 <alltraps>

001063d8 <vector151>:
  1063d8:	6a 00                	push   $0x0
  1063da:	68 97 00 00 00       	push   $0x97
  1063df:	e9 0c f7 ff ff       	jmp    105af0 <alltraps>

001063e4 <vector152>:
  1063e4:	6a 00                	push   $0x0
  1063e6:	68 98 00 00 00       	push   $0x98
  1063eb:	e9 00 f7 ff ff       	jmp    105af0 <alltraps>

001063f0 <vector153>:
  1063f0:	6a 00                	push   $0x0
  1063f2:	68 99 00 00 00       	push   $0x99
  1063f7:	e9 f4 f6 ff ff       	jmp    105af0 <alltraps>

001063fc <vector154>:
  1063fc:	6a 00                	push   $0x0
  1063fe:	68 9a 00 00 00       	push   $0x9a
  106403:	e9 e8 f6 ff ff       	jmp    105af0 <alltraps>

00106408 <vector155>:
  106408:	6a 00                	push   $0x0
  10640a:	68 9b 00 00 00       	push   $0x9b
  10640f:	e9 dc f6 ff ff       	jmp    105af0 <alltraps>

00106414 <vector156>:
  106414:	6a 00                	push   $0x0
  106416:	68 9c 00 00 00       	push   $0x9c
  10641b:	e9 d0 f6 ff ff       	jmp    105af0 <alltraps>

00106420 <vector157>:
  106420:	6a 00                	push   $0x0
  106422:	68 9d 00 00 00       	push   $0x9d
  106427:	e9 c4 f6 ff ff       	jmp    105af0 <alltraps>

0010642c <vector158>:
  10642c:	6a 00                	push   $0x0
  10642e:	68 9e 00 00 00       	push   $0x9e
  106433:	e9 b8 f6 ff ff       	jmp    105af0 <alltraps>

00106438 <vector159>:
  106438:	6a 00                	push   $0x0
  10643a:	68 9f 00 00 00       	push   $0x9f
  10643f:	e9 ac f6 ff ff       	jmp    105af0 <alltraps>

00106444 <vector160>:
  106444:	6a 00                	push   $0x0
  106446:	68 a0 00 00 00       	push   $0xa0
  10644b:	e9 a0 f6 ff ff       	jmp    105af0 <alltraps>

00106450 <vector161>:
  106450:	6a 00                	push   $0x0
  106452:	68 a1 00 00 00       	push   $0xa1
  106457:	e9 94 f6 ff ff       	jmp    105af0 <alltraps>

0010645c <vector162>:
  10645c:	6a 00                	push   $0x0
  10645e:	68 a2 00 00 00       	push   $0xa2
  106463:	e9 88 f6 ff ff       	jmp    105af0 <alltraps>

00106468 <vector163>:
  106468:	6a 00                	push   $0x0
  10646a:	68 a3 00 00 00       	push   $0xa3
  10646f:	e9 7c f6 ff ff       	jmp    105af0 <alltraps>

00106474 <vector164>:
  106474:	6a 00                	push   $0x0
  106476:	68 a4 00 00 00       	push   $0xa4
  10647b:	e9 70 f6 ff ff       	jmp    105af0 <alltraps>

00106480 <vector165>:
  106480:	6a 00                	push   $0x0
  106482:	68 a5 00 00 00       	push   $0xa5
  106487:	e9 64 f6 ff ff       	jmp    105af0 <alltraps>

0010648c <vector166>:
  10648c:	6a 00                	push   $0x0
  10648e:	68 a6 00 00 00       	push   $0xa6
  106493:	e9 58 f6 ff ff       	jmp    105af0 <alltraps>

00106498 <vector167>:
  106498:	6a 00                	push   $0x0
  10649a:	68 a7 00 00 00       	push   $0xa7
  10649f:	e9 4c f6 ff ff       	jmp    105af0 <alltraps>

001064a4 <vector168>:
  1064a4:	6a 00                	push   $0x0
  1064a6:	68 a8 00 00 00       	push   $0xa8
  1064ab:	e9 40 f6 ff ff       	jmp    105af0 <alltraps>

001064b0 <vector169>:
  1064b0:	6a 00                	push   $0x0
  1064b2:	68 a9 00 00 00       	push   $0xa9
  1064b7:	e9 34 f6 ff ff       	jmp    105af0 <alltraps>

001064bc <vector170>:
  1064bc:	6a 00                	push   $0x0
  1064be:	68 aa 00 00 00       	push   $0xaa
  1064c3:	e9 28 f6 ff ff       	jmp    105af0 <alltraps>

001064c8 <vector171>:
  1064c8:	6a 00                	push   $0x0
  1064ca:	68 ab 00 00 00       	push   $0xab
  1064cf:	e9 1c f6 ff ff       	jmp    105af0 <alltraps>

001064d4 <vector172>:
  1064d4:	6a 00                	push   $0x0
  1064d6:	68 ac 00 00 00       	push   $0xac
  1064db:	e9 10 f6 ff ff       	jmp    105af0 <alltraps>

001064e0 <vector173>:
  1064e0:	6a 00                	push   $0x0
  1064e2:	68 ad 00 00 00       	push   $0xad
  1064e7:	e9 04 f6 ff ff       	jmp    105af0 <alltraps>

001064ec <vector174>:
  1064ec:	6a 00                	push   $0x0
  1064ee:	68 ae 00 00 00       	push   $0xae
  1064f3:	e9 f8 f5 ff ff       	jmp    105af0 <alltraps>

001064f8 <vector175>:
  1064f8:	6a 00                	push   $0x0
  1064fa:	68 af 00 00 00       	push   $0xaf
  1064ff:	e9 ec f5 ff ff       	jmp    105af0 <alltraps>

00106504 <vector176>:
  106504:	6a 00                	push   $0x0
  106506:	68 b0 00 00 00       	push   $0xb0
  10650b:	e9 e0 f5 ff ff       	jmp    105af0 <alltraps>

00106510 <vector177>:
  106510:	6a 00                	push   $0x0
  106512:	68 b1 00 00 00       	push   $0xb1
  106517:	e9 d4 f5 ff ff       	jmp    105af0 <alltraps>

0010651c <vector178>:
  10651c:	6a 00                	push   $0x0
  10651e:	68 b2 00 00 00       	push   $0xb2
  106523:	e9 c8 f5 ff ff       	jmp    105af0 <alltraps>

00106528 <vector179>:
  106528:	6a 00                	push   $0x0
  10652a:	68 b3 00 00 00       	push   $0xb3
  10652f:	e9 bc f5 ff ff       	jmp    105af0 <alltraps>

00106534 <vector180>:
  106534:	6a 00                	push   $0x0
  106536:	68 b4 00 00 00       	push   $0xb4
  10653b:	e9 b0 f5 ff ff       	jmp    105af0 <alltraps>

00106540 <vector181>:
  106540:	6a 00                	push   $0x0
  106542:	68 b5 00 00 00       	push   $0xb5
  106547:	e9 a4 f5 ff ff       	jmp    105af0 <alltraps>

0010654c <vector182>:
  10654c:	6a 00                	push   $0x0
  10654e:	68 b6 00 00 00       	push   $0xb6
  106553:	e9 98 f5 ff ff       	jmp    105af0 <alltraps>

00106558 <vector183>:
  106558:	6a 00                	push   $0x0
  10655a:	68 b7 00 00 00       	push   $0xb7
  10655f:	e9 8c f5 ff ff       	jmp    105af0 <alltraps>

00106564 <vector184>:
  106564:	6a 00                	push   $0x0
  106566:	68 b8 00 00 00       	push   $0xb8
  10656b:	e9 80 f5 ff ff       	jmp    105af0 <alltraps>

00106570 <vector185>:
  106570:	6a 00                	push   $0x0
  106572:	68 b9 00 00 00       	push   $0xb9
  106577:	e9 74 f5 ff ff       	jmp    105af0 <alltraps>

0010657c <vector186>:
  10657c:	6a 00                	push   $0x0
  10657e:	68 ba 00 00 00       	push   $0xba
  106583:	e9 68 f5 ff ff       	jmp    105af0 <alltraps>

00106588 <vector187>:
  106588:	6a 00                	push   $0x0
  10658a:	68 bb 00 00 00       	push   $0xbb
  10658f:	e9 5c f5 ff ff       	jmp    105af0 <alltraps>

00106594 <vector188>:
  106594:	6a 00                	push   $0x0
  106596:	68 bc 00 00 00       	push   $0xbc
  10659b:	e9 50 f5 ff ff       	jmp    105af0 <alltraps>

001065a0 <vector189>:
  1065a0:	6a 00                	push   $0x0
  1065a2:	68 bd 00 00 00       	push   $0xbd
  1065a7:	e9 44 f5 ff ff       	jmp    105af0 <alltraps>

001065ac <vector190>:
  1065ac:	6a 00                	push   $0x0
  1065ae:	68 be 00 00 00       	push   $0xbe
  1065b3:	e9 38 f5 ff ff       	jmp    105af0 <alltraps>

001065b8 <vector191>:
  1065b8:	6a 00                	push   $0x0
  1065ba:	68 bf 00 00 00       	push   $0xbf
  1065bf:	e9 2c f5 ff ff       	jmp    105af0 <alltraps>

001065c4 <vector192>:
  1065c4:	6a 00                	push   $0x0
  1065c6:	68 c0 00 00 00       	push   $0xc0
  1065cb:	e9 20 f5 ff ff       	jmp    105af0 <alltraps>

001065d0 <vector193>:
  1065d0:	6a 00                	push   $0x0
  1065d2:	68 c1 00 00 00       	push   $0xc1
  1065d7:	e9 14 f5 ff ff       	jmp    105af0 <alltraps>

001065dc <vector194>:
  1065dc:	6a 00                	push   $0x0
  1065de:	68 c2 00 00 00       	push   $0xc2
  1065e3:	e9 08 f5 ff ff       	jmp    105af0 <alltraps>

001065e8 <vector195>:
  1065e8:	6a 00                	push   $0x0
  1065ea:	68 c3 00 00 00       	push   $0xc3
  1065ef:	e9 fc f4 ff ff       	jmp    105af0 <alltraps>

001065f4 <vector196>:
  1065f4:	6a 00                	push   $0x0
  1065f6:	68 c4 00 00 00       	push   $0xc4
  1065fb:	e9 f0 f4 ff ff       	jmp    105af0 <alltraps>

00106600 <vector197>:
  106600:	6a 00                	push   $0x0
  106602:	68 c5 00 00 00       	push   $0xc5
  106607:	e9 e4 f4 ff ff       	jmp    105af0 <alltraps>

0010660c <vector198>:
  10660c:	6a 00                	push   $0x0
  10660e:	68 c6 00 00 00       	push   $0xc6
  106613:	e9 d8 f4 ff ff       	jmp    105af0 <alltraps>

00106618 <vector199>:
  106618:	6a 00                	push   $0x0
  10661a:	68 c7 00 00 00       	push   $0xc7
  10661f:	e9 cc f4 ff ff       	jmp    105af0 <alltraps>

00106624 <vector200>:
  106624:	6a 00                	push   $0x0
  106626:	68 c8 00 00 00       	push   $0xc8
  10662b:	e9 c0 f4 ff ff       	jmp    105af0 <alltraps>

00106630 <vector201>:
  106630:	6a 00                	push   $0x0
  106632:	68 c9 00 00 00       	push   $0xc9
  106637:	e9 b4 f4 ff ff       	jmp    105af0 <alltraps>

0010663c <vector202>:
  10663c:	6a 00                	push   $0x0
  10663e:	68 ca 00 00 00       	push   $0xca
  106643:	e9 a8 f4 ff ff       	jmp    105af0 <alltraps>

00106648 <vector203>:
  106648:	6a 00                	push   $0x0
  10664a:	68 cb 00 00 00       	push   $0xcb
  10664f:	e9 9c f4 ff ff       	jmp    105af0 <alltraps>

00106654 <vector204>:
  106654:	6a 00                	push   $0x0
  106656:	68 cc 00 00 00       	push   $0xcc
  10665b:	e9 90 f4 ff ff       	jmp    105af0 <alltraps>

00106660 <vector205>:
  106660:	6a 00                	push   $0x0
  106662:	68 cd 00 00 00       	push   $0xcd
  106667:	e9 84 f4 ff ff       	jmp    105af0 <alltraps>

0010666c <vector206>:
  10666c:	6a 00                	push   $0x0
  10666e:	68 ce 00 00 00       	push   $0xce
  106673:	e9 78 f4 ff ff       	jmp    105af0 <alltraps>

00106678 <vector207>:
  106678:	6a 00                	push   $0x0
  10667a:	68 cf 00 00 00       	push   $0xcf
  10667f:	e9 6c f4 ff ff       	jmp    105af0 <alltraps>

00106684 <vector208>:
  106684:	6a 00                	push   $0x0
  106686:	68 d0 00 00 00       	push   $0xd0
  10668b:	e9 60 f4 ff ff       	jmp    105af0 <alltraps>

00106690 <vector209>:
  106690:	6a 00                	push   $0x0
  106692:	68 d1 00 00 00       	push   $0xd1
  106697:	e9 54 f4 ff ff       	jmp    105af0 <alltraps>

0010669c <vector210>:
  10669c:	6a 00                	push   $0x0
  10669e:	68 d2 00 00 00       	push   $0xd2
  1066a3:	e9 48 f4 ff ff       	jmp    105af0 <alltraps>

001066a8 <vector211>:
  1066a8:	6a 00                	push   $0x0
  1066aa:	68 d3 00 00 00       	push   $0xd3
  1066af:	e9 3c f4 ff ff       	jmp    105af0 <alltraps>

001066b4 <vector212>:
  1066b4:	6a 00                	push   $0x0
  1066b6:	68 d4 00 00 00       	push   $0xd4
  1066bb:	e9 30 f4 ff ff       	jmp    105af0 <alltraps>

001066c0 <vector213>:
  1066c0:	6a 00                	push   $0x0
  1066c2:	68 d5 00 00 00       	push   $0xd5
  1066c7:	e9 24 f4 ff ff       	jmp    105af0 <alltraps>

001066cc <vector214>:
  1066cc:	6a 00                	push   $0x0
  1066ce:	68 d6 00 00 00       	push   $0xd6
  1066d3:	e9 18 f4 ff ff       	jmp    105af0 <alltraps>

001066d8 <vector215>:
  1066d8:	6a 00                	push   $0x0
  1066da:	68 d7 00 00 00       	push   $0xd7
  1066df:	e9 0c f4 ff ff       	jmp    105af0 <alltraps>

001066e4 <vector216>:
  1066e4:	6a 00                	push   $0x0
  1066e6:	68 d8 00 00 00       	push   $0xd8
  1066eb:	e9 00 f4 ff ff       	jmp    105af0 <alltraps>

001066f0 <vector217>:
  1066f0:	6a 00                	push   $0x0
  1066f2:	68 d9 00 00 00       	push   $0xd9
  1066f7:	e9 f4 f3 ff ff       	jmp    105af0 <alltraps>

001066fc <vector218>:
  1066fc:	6a 00                	push   $0x0
  1066fe:	68 da 00 00 00       	push   $0xda
  106703:	e9 e8 f3 ff ff       	jmp    105af0 <alltraps>

00106708 <vector219>:
  106708:	6a 00                	push   $0x0
  10670a:	68 db 00 00 00       	push   $0xdb
  10670f:	e9 dc f3 ff ff       	jmp    105af0 <alltraps>

00106714 <vector220>:
  106714:	6a 00                	push   $0x0
  106716:	68 dc 00 00 00       	push   $0xdc
  10671b:	e9 d0 f3 ff ff       	jmp    105af0 <alltraps>

00106720 <vector221>:
  106720:	6a 00                	push   $0x0
  106722:	68 dd 00 00 00       	push   $0xdd
  106727:	e9 c4 f3 ff ff       	jmp    105af0 <alltraps>

0010672c <vector222>:
  10672c:	6a 00                	push   $0x0
  10672e:	68 de 00 00 00       	push   $0xde
  106733:	e9 b8 f3 ff ff       	jmp    105af0 <alltraps>

00106738 <vector223>:
  106738:	6a 00                	push   $0x0
  10673a:	68 df 00 00 00       	push   $0xdf
  10673f:	e9 ac f3 ff ff       	jmp    105af0 <alltraps>

00106744 <vector224>:
  106744:	6a 00                	push   $0x0
  106746:	68 e0 00 00 00       	push   $0xe0
  10674b:	e9 a0 f3 ff ff       	jmp    105af0 <alltraps>

00106750 <vector225>:
  106750:	6a 00                	push   $0x0
  106752:	68 e1 00 00 00       	push   $0xe1
  106757:	e9 94 f3 ff ff       	jmp    105af0 <alltraps>

0010675c <vector226>:
  10675c:	6a 00                	push   $0x0
  10675e:	68 e2 00 00 00       	push   $0xe2
  106763:	e9 88 f3 ff ff       	jmp    105af0 <alltraps>

00106768 <vector227>:
  106768:	6a 00                	push   $0x0
  10676a:	68 e3 00 00 00       	push   $0xe3
  10676f:	e9 7c f3 ff ff       	jmp    105af0 <alltraps>

00106774 <vector228>:
  106774:	6a 00                	push   $0x0
  106776:	68 e4 00 00 00       	push   $0xe4
  10677b:	e9 70 f3 ff ff       	jmp    105af0 <alltraps>

00106780 <vector229>:
  106780:	6a 00                	push   $0x0
  106782:	68 e5 00 00 00       	push   $0xe5
  106787:	e9 64 f3 ff ff       	jmp    105af0 <alltraps>

0010678c <vector230>:
  10678c:	6a 00                	push   $0x0
  10678e:	68 e6 00 00 00       	push   $0xe6
  106793:	e9 58 f3 ff ff       	jmp    105af0 <alltraps>

00106798 <vector231>:
  106798:	6a 00                	push   $0x0
  10679a:	68 e7 00 00 00       	push   $0xe7
  10679f:	e9 4c f3 ff ff       	jmp    105af0 <alltraps>

001067a4 <vector232>:
  1067a4:	6a 00                	push   $0x0
  1067a6:	68 e8 00 00 00       	push   $0xe8
  1067ab:	e9 40 f3 ff ff       	jmp    105af0 <alltraps>

001067b0 <vector233>:
  1067b0:	6a 00                	push   $0x0
  1067b2:	68 e9 00 00 00       	push   $0xe9
  1067b7:	e9 34 f3 ff ff       	jmp    105af0 <alltraps>

001067bc <vector234>:
  1067bc:	6a 00                	push   $0x0
  1067be:	68 ea 00 00 00       	push   $0xea
  1067c3:	e9 28 f3 ff ff       	jmp    105af0 <alltraps>

001067c8 <vector235>:
  1067c8:	6a 00                	push   $0x0
  1067ca:	68 eb 00 00 00       	push   $0xeb
  1067cf:	e9 1c f3 ff ff       	jmp    105af0 <alltraps>

001067d4 <vector236>:
  1067d4:	6a 00                	push   $0x0
  1067d6:	68 ec 00 00 00       	push   $0xec
  1067db:	e9 10 f3 ff ff       	jmp    105af0 <alltraps>

001067e0 <vector237>:
  1067e0:	6a 00                	push   $0x0
  1067e2:	68 ed 00 00 00       	push   $0xed
  1067e7:	e9 04 f3 ff ff       	jmp    105af0 <alltraps>

001067ec <vector238>:
  1067ec:	6a 00                	push   $0x0
  1067ee:	68 ee 00 00 00       	push   $0xee
  1067f3:	e9 f8 f2 ff ff       	jmp    105af0 <alltraps>

001067f8 <vector239>:
  1067f8:	6a 00                	push   $0x0
  1067fa:	68 ef 00 00 00       	push   $0xef
  1067ff:	e9 ec f2 ff ff       	jmp    105af0 <alltraps>

00106804 <vector240>:
  106804:	6a 00                	push   $0x0
  106806:	68 f0 00 00 00       	push   $0xf0
  10680b:	e9 e0 f2 ff ff       	jmp    105af0 <alltraps>

00106810 <vector241>:
  106810:	6a 00                	push   $0x0
  106812:	68 f1 00 00 00       	push   $0xf1
  106817:	e9 d4 f2 ff ff       	jmp    105af0 <alltraps>

0010681c <vector242>:
  10681c:	6a 00                	push   $0x0
  10681e:	68 f2 00 00 00       	push   $0xf2
  106823:	e9 c8 f2 ff ff       	jmp    105af0 <alltraps>

00106828 <vector243>:
  106828:	6a 00                	push   $0x0
  10682a:	68 f3 00 00 00       	push   $0xf3
  10682f:	e9 bc f2 ff ff       	jmp    105af0 <alltraps>

00106834 <vector244>:
  106834:	6a 00                	push   $0x0
  106836:	68 f4 00 00 00       	push   $0xf4
  10683b:	e9 b0 f2 ff ff       	jmp    105af0 <alltraps>

00106840 <vector245>:
  106840:	6a 00                	push   $0x0
  106842:	68 f5 00 00 00       	push   $0xf5
  106847:	e9 a4 f2 ff ff       	jmp    105af0 <alltraps>

0010684c <vector246>:
  10684c:	6a 00                	push   $0x0
  10684e:	68 f6 00 00 00       	push   $0xf6
  106853:	e9 98 f2 ff ff       	jmp    105af0 <alltraps>

00106858 <vector247>:
  106858:	6a 00                	push   $0x0
  10685a:	68 f7 00 00 00       	push   $0xf7
  10685f:	e9 8c f2 ff ff       	jmp    105af0 <alltraps>

00106864 <vector248>:
  106864:	6a 00                	push   $0x0
  106866:	68 f8 00 00 00       	push   $0xf8
  10686b:	e9 80 f2 ff ff       	jmp    105af0 <alltraps>

00106870 <vector249>:
  106870:	6a 00                	push   $0x0
  106872:	68 f9 00 00 00       	push   $0xf9
  106877:	e9 74 f2 ff ff       	jmp    105af0 <alltraps>

0010687c <vector250>:
  10687c:	6a 00                	push   $0x0
  10687e:	68 fa 00 00 00       	push   $0xfa
  106883:	e9 68 f2 ff ff       	jmp    105af0 <alltraps>

00106888 <vector251>:
  106888:	6a 00                	push   $0x0
  10688a:	68 fb 00 00 00       	push   $0xfb
  10688f:	e9 5c f2 ff ff       	jmp    105af0 <alltraps>

00106894 <vector252>:
  106894:	6a 00                	push   $0x0
  106896:	68 fc 00 00 00       	push   $0xfc
  10689b:	e9 50 f2 ff ff       	jmp    105af0 <alltraps>

001068a0 <vector253>:
  1068a0:	6a 00                	push   $0x0
  1068a2:	68 fd 00 00 00       	push   $0xfd
  1068a7:	e9 44 f2 ff ff       	jmp    105af0 <alltraps>

001068ac <vector254>:
  1068ac:	6a 00                	push   $0x0
  1068ae:	68 fe 00 00 00       	push   $0xfe
  1068b3:	e9 38 f2 ff ff       	jmp    105af0 <alltraps>

001068b8 <vector255>:
  1068b8:	6a 00                	push   $0x0
  1068ba:	68 ff 00 00 00       	push   $0xff
  1068bf:	e9 2c f2 ff ff       	jmp    105af0 <alltraps>
