
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
  10000f:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  100016:	e8 95 51 00 00       	call   1051b0 <acquire>

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
  10002a:	c7 43 0c 60 88 10 00 	movl   $0x108860,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 70 88 10 00       	mov    0x108870,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 70 88 10 00       	mov    0x108870,%eax
  bufhead.next = b;
  100041:	89 1d 70 88 10 00    	mov    %ebx,0x108870

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 80 8a 10 00 	movl   $0x108a80,(%esp)
  100051:	e8 2a 40 00 00       	call   104080 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 60 b4 10 00 	movl   $0x10b460,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 09 51 00 00       	jmp    105170 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 80 73 10 00 	movl   $0x107380,(%esp)
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
  10008e:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  100095:	e8 16 51 00 00       	call   1051b0 <acquire>

	  // Try for cached block.
	  for(b = bufhead.next; b != &bufhead; b = b->next){
  10009a:	a1 70 88 10 00       	mov    0x108870,%eax
  10009f:	3d 60 88 10 00       	cmp    $0x108860,%eax
  1000a4:	75 0c                	jne    1000b2 <bcheck+0x32>
  1000a6:	eb 38                	jmp    1000e0 <bcheck+0x60>
  1000a8:	8b 40 10             	mov    0x10(%eax),%eax
  1000ab:	3d 60 88 10 00       	cmp    $0x108860,%eax
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
  1000c2:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  1000c9:	e8 a2 50 00 00       	call   105170 <release>
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
  1000e0:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  1000e7:	e8 84 50 00 00       	call   105170 <release>
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
  100119:	e9 42 22 00 00       	jmp    102360 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10011e:	c7 04 24 87 73 10 00 	movl   $0x107387,(%esp)
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
  10013f:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  100146:	e8 65 50 00 00       	call   1051b0 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10014b:	8b 1d 70 88 10 00    	mov    0x108870,%ebx
  100151:	81 fb 60 88 10 00    	cmp    $0x108860,%ebx
  100157:	75 12                	jne    10016b <bread+0x3b>
  100159:	eb 3d                	jmp    100198 <bread+0x68>
  10015b:	90                   	nop
  10015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100160:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100163:	81 fb 60 88 10 00    	cmp    $0x108860,%ebx
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
  100182:	c7 44 24 04 60 b4 10 	movl   $0x10b460,0x4(%esp)
  100189:	00 
  10018a:	c7 04 24 80 8a 10 00 	movl   $0x108a80,(%esp)
  100191:	e8 9a 42 00 00       	call   104430 <sleep>
  100196:	eb b3                	jmp    10014b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100198:	8b 1d 6c 88 10 00    	mov    0x10886c,%ebx
  10019e:	81 fb 60 88 10 00    	cmp    $0x108860,%ebx
  1001a4:	75 0d                	jne    1001b3 <bread+0x83>
  1001a6:	eb 3f                	jmp    1001e7 <bread+0xb7>
  1001a8:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1001ab:	81 fb 60 88 10 00    	cmp    $0x108860,%ebx
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
  1001c4:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  1001cb:	e8 a0 4f 00 00       	call   105170 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  1001d0:	f6 03 02             	testb  $0x2,(%ebx)
  1001d3:	75 08                	jne    1001dd <bread+0xad>
    ide_rw(b);
  1001d5:	89 1c 24             	mov    %ebx,(%esp)
  1001d8:	e8 83 21 00 00       	call   102360 <ide_rw>
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
  1001e7:	c7 04 24 8e 73 10 00 	movl   $0x10738e,(%esp)
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
  1001f8:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  1001ff:	e8 6c 4f 00 00       	call   105170 <release>
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
  100216:	c7 44 24 04 9f 73 10 	movl   $0x10739f,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 60 b4 10 00 	movl   $0x10b460,(%esp)
  100225:	e8 c6 4d 00 00       	call   104ff0 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10022a:	b8 60 b4 10 00       	mov    $0x10b460,%eax
  10022f:	3d 80 8a 10 00       	cmp    $0x108a80,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  100234:	c7 05 6c 88 10 00 60 	movl   $0x108860,0x10886c
  10023b:	88 10 00 
  bufhead.next = &bufhead;
  10023e:	c7 05 70 88 10 00 60 	movl   $0x108860,0x108870
  100245:	88 10 00 
  for(b = buf; b < buf+NBUF; b++){
  100248:	76 33                	jbe    10027d <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  10024a:	ba 60 88 10 00       	mov    $0x108860,%edx
  10024f:	b8 80 8a 10 00       	mov    $0x108a80,%eax
  100254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100258:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  10025b:	c7 40 0c 60 88 10 00 	movl   $0x108860,0xc(%eax)
    bufhead.next->prev = b;
  100262:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100265:	89 c2                	mov    %eax,%edx
  100267:	05 18 02 00 00       	add    $0x218,%eax
  10026c:	3d 60 b4 10 00       	cmp    $0x10b460,%eax
  100271:	75 e5                	jne    100258 <binit+0x48>
  100273:	c7 05 70 88 10 00 48 	movl   $0x10b248,0x108870
  10027a:	b2 10 00 
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
  100286:	c7 44 24 04 a9 73 10 	movl   $0x1073a9,0x4(%esp)
  10028d:	00 
  10028e:	c7 04 24 c0 87 10 00 	movl   $0x1087c0,(%esp)
  100295:	e8 56 4d 00 00       	call   104ff0 <initlock>
  initlock(&input.lock, "console input");
  10029a:	c7 44 24 04 b1 73 10 	movl   $0x1073b1,0x4(%esp)
  1002a1:	00 
  1002a2:	c7 04 24 a0 b4 10 00 	movl   $0x10b4a0,(%esp)
  1002a9:	e8 42 4d 00 00       	call   104ff0 <initlock>

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
  1002b5:	c7 05 0c bf 10 00 d0 	movl   $0x1006d0,0x10bf0c
  1002bc:	06 10 00 
  devsw[CONSOLE].read = console_read;
  1002bf:	c7 05 08 bf 10 00 f0 	movl   $0x1002f0,0x10bf08
  1002c6:	02 10 00 
  use_console_lock = 1;
  1002c9:	c7 05 a4 87 10 00 01 	movl   $0x1,0x1087a4
  1002d0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002d3:	e8 b8 37 00 00       	call   103a90 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002df:	00 
  1002e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002e7:	e8 64 22 00 00       	call   102550 <ioapic_enable>
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
  100302:	e8 59 1c 00 00       	call   101f60 <iunlock>
  target = n;
  100307:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10030a:	c7 04 24 a0 b4 10 00 	movl   $0x10b4a0,(%esp)
  100311:	e8 9a 4e 00 00       	call   1051b0 <acquire>
  while(n > 0){
  100316:	85 db                	test   %ebx,%ebx
  100318:	7f 26                	jg     100340 <console_read+0x50>
  10031a:	e9 bb 00 00 00       	jmp    1003da <console_read+0xea>
  10031f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  100320:	e8 5b 3e 00 00       	call   104180 <curproc>
  100325:	8b 40 1c             	mov    0x1c(%eax),%eax
  100328:	85 c0                	test   %eax,%eax
  10032a:	75 5c                	jne    100388 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10032c:	c7 44 24 04 a0 b4 10 	movl   $0x10b4a0,0x4(%esp)
  100333:	00 
  100334:	c7 04 24 54 b5 10 00 	movl   $0x10b554,(%esp)
  10033b:	e8 f0 40 00 00       	call   104430 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100340:	a1 54 b5 10 00       	mov    0x10b554,%eax
  100345:	3b 05 58 b5 10 00    	cmp    0x10b558,%eax
  10034b:	74 d3                	je     100320 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10034d:	89 c2                	mov    %eax,%edx
  10034f:	83 e2 7f             	and    $0x7f,%edx
  100352:	0f b6 8a d4 b4 10 00 	movzbl 0x10b4d4(%edx),%ecx
  100359:	8d 78 01             	lea    0x1(%eax),%edi
  10035c:	89 3d 54 b5 10 00    	mov    %edi,0x10b554
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
  100388:	c7 04 24 a0 b4 10 00 	movl   $0x10b4a0,(%esp)
  10038f:	e8 dc 4d 00 00       	call   105170 <release>
        ilock(ip);
  100394:	89 34 24             	mov    %esi,(%esp)
  100397:	e8 34 1c 00 00       	call   101fd0 <ilock>
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
  1003ae:	a3 54 b5 10 00       	mov    %eax,0x10b554
  1003b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1003b6:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1003b8:	c7 04 24 a0 b4 10 00 	movl   $0x10b4a0,(%esp)
  1003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1003c2:	e8 a9 4d 00 00       	call   105170 <release>
  ilock(ip);
  1003c7:	89 34 24             	mov    %esi,(%esp)
  1003ca:	e8 01 1c 00 00       	call   101fd0 <ilock>
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
  1003ec:	83 3d a0 87 10 00 00 	cmpl   $0x0,0x1087a0
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
  100508:	e8 a3 4d 00 00       	call   1052b0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10050d:	b8 80 07 00 00       	mov    $0x780,%eax
  100512:	29 d8                	sub    %ebx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	89 44 24 08          	mov    %eax,0x8(%esp)
  10051a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100521:	00 
  100522:	89 34 24             	mov    %esi,(%esp)
  100525:	e8 f6 4c 00 00       	call   105220 <memset>
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
  100552:	89 da                	mov    %ebx,%edx
  100554:	89 d8                	mov    %ebx,%eax
  100556:	b1 50                	mov    $0x50,%cl
  100558:	83 c3 50             	add    $0x50,%ebx
  10055b:	c1 fa 1f             	sar    $0x1f,%edx
  10055e:	f7 f9                	idiv   %ecx
  100560:	29 d3                	sub    %edx,%ebx
  100562:	e9 30 ff ff ff       	jmp    100497 <cons_putc+0xb7>
  100567:	89 f6                	mov    %esi,%esi
  100569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
  100574:	be d0 b4 10 00       	mov    $0x10b4d0,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100579:	53                   	push   %ebx
  10057a:	83 ec 20             	sub    $0x20,%esp
  10057d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100580:	c7 04 24 a0 b4 10 00 	movl   $0x10b4a0,(%esp)
  100587:	e8 24 4c 00 00       	call   1051b0 <acquire>
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
  1005bc:	8b 15 5c b5 10 00    	mov    0x10b55c,%edx
  1005c2:	89 d1                	mov    %edx,%ecx
  1005c4:	2b 0d 54 b5 10 00    	sub    0x10b554,%ecx
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
  1005e1:	89 15 5c b5 10 00    	mov    %edx,0x10b55c
        cons_putc(c);
  1005e7:	e8 f4 fd ff ff       	call   1003e0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ef:	83 f8 04             	cmp    $0x4,%eax
  1005f2:	0f 84 ba 00 00 00    	je     1006b2 <console_intr+0x142>
  1005f8:	83 f8 0a             	cmp    $0xa,%eax
  1005fb:	0f 84 b1 00 00 00    	je     1006b2 <console_intr+0x142>
  100601:	8b 15 54 b5 10 00    	mov    0x10b554,%edx
  100607:	a1 5c b5 10 00       	mov    0x10b55c,%eax
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
  100628:	c7 45 08 a0 b4 10 00 	movl   $0x10b4a0,0x8(%ebp)
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
  100635:	e9 36 4b 00 00       	jmp    105170 <release>
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
  100648:	80 ba d4 b4 10 00 0a 	cmpb   $0xa,0x10b4d4(%edx)
  10064f:	0f 84 3b ff ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100655:	a3 5c b5 10 00       	mov    %eax,0x10b55c
        cons_putc(BACKSPACE);
  10065a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100661:	e8 7a fd ff ff       	call   1003e0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100666:	a1 5c b5 10 00       	mov    0x10b55c,%eax
  10066b:	3b 05 58 b5 10 00    	cmp    0x10b558,%eax
  100671:	75 cd                	jne    100640 <console_intr+0xd0>
  100673:	e9 18 ff ff ff       	jmp    100590 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100678:	e8 a3 38 00 00       	call   103f20 <procdump>
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
  100688:	a1 5c b5 10 00       	mov    0x10b55c,%eax
  10068d:	3b 05 58 b5 10 00    	cmp    0x10b558,%eax
  100693:	0f 84 f7 fe ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100699:	83 e8 01             	sub    $0x1,%eax
  10069c:	a3 5c b5 10 00       	mov    %eax,0x10b55c
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
  1006b2:	a1 5c b5 10 00       	mov    0x10b55c,%eax
          input.w = input.e;
  1006b7:	a3 58 b5 10 00       	mov    %eax,0x10b558
          wakeup(&input.r);
  1006bc:	c7 04 24 54 b5 10 00 	movl   $0x10b554,(%esp)
  1006c3:	e8 b8 39 00 00       	call   104080 <wakeup>
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
  1006e5:	e8 76 18 00 00       	call   101f60 <iunlock>
  acquire(&console_lock);
  1006ea:	c7 04 24 c0 87 10 00 	movl   $0x1087c0,(%esp)
  1006f1:	e8 ba 4a 00 00       	call   1051b0 <acquire>
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
  100713:	c7 04 24 c0 87 10 00 	movl   $0x1087c0,(%esp)
  10071a:	e8 51 4a 00 00       	call   105170 <release>
  ilock(ip);
  10071f:	8b 45 08             	mov    0x8(%ebp),%eax
  100722:	89 04 24             	mov    %eax,(%esp)
  100725:	e8 a6 18 00 00       	call   101fd0 <ilock>

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
  100758:	78 56                	js     1007b0 <printint+0x70>
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
  10076c:	0f b6 92 d9 73 10 00 	movzbl 0x1073d9(%edx),%edx
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
  1007ae:	66 90                	xchg   %ax,%ax
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  1007b0:	f7 d8                	neg    %eax
  1007b2:	bf 01 00 00 00       	mov    $0x1,%edi
  1007b7:	eb a3                	jmp    10075c <printint+0x1c>
  1007b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
  1007c9:	a1 a4 87 10 00       	mov    0x1087a4,%eax
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
  1007ea:	31 db                	xor    %ebx,%ebx
  1007ec:	31 f6                	xor    %esi,%esi
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
  10086f:	c7 04 24 c0 87 10 00 	movl   $0x1087c0,(%esp)
  100876:	e8 f5 48 00 00       	call   105170 <release>
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
  100940:	c7 04 24 c0 87 10 00 	movl   $0x1087c0,(%esp)
  100947:	e8 64 48 00 00       	call   1051b0 <acquire>
  10094c:	e9 88 fe ff ff       	jmp    1007d9 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  100951:	be bf 73 10 00       	mov    $0x1073bf,%esi
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
  100968:	c7 05 a4 87 10 00 00 	movl   $0x0,0x1087a4
  10096f:	00 00 00 
panic(char *s)
{
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  100972:	fa                   	cli    
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  100973:	e8 78 22 00 00       	call   102bf0 <cpu>
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
  10097d:	c7 04 24 c6 73 10 00 	movl   $0x1073c6,(%esp)
  100984:	89 44 24 04          	mov    %eax,0x4(%esp)
  100988:	e8 33 fe ff ff       	call   1007c0 <cprintf>
  cprintf(s);
  10098d:	8b 45 08             	mov    0x8(%ebp),%eax
  100990:	89 04 24             	mov    %eax,(%esp)
  100993:	e8 28 fe ff ff       	call   1007c0 <cprintf>
  cprintf("\n");
  100998:	c7 04 24 ca 78 10 00 	movl   $0x1078ca,(%esp)
  10099f:	e8 1c fe ff ff       	call   1007c0 <cprintf>
  getcallerpcs(&s, pcs);
  1009a4:	8d 45 08             	lea    0x8(%ebp),%eax
  1009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1009ab:	89 04 24             	mov    %eax,(%esp)
  1009ae:	e8 5d 46 00 00       	call   105010 <getcallerpcs>
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
  1009be:	c7 04 24 d5 73 10 00 	movl   $0x1073d5,(%esp)
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
  1009d3:	c7 05 a0 87 10 00 01 	movl   $0x1,0x1087a0
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
  1009f2:	e8 79 18 00 00       	call   102270 <namei>
  1009f7:	89 c3                	mov    %eax,%ebx
  1009f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009fe:	85 db                	test   %ebx,%ebx
  100a00:	0f 84 81 03 00 00    	je     100d87 <exec+0x3a7>
    return -1;
  ilock(ip);
  100a06:	89 1c 24             	mov    %ebx,(%esp)
  100a09:	e8 c2 15 00 00       	call   101fd0 <ilock>
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
  100a28:	e8 d3 0b 00 00       	call   101600 <readi>
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
  100a84:	e8 77 0b 00 00       	call   101600 <readi>
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
  100aee:	e8 0d 49 00 00       	call   105400 <strlen>
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
  100b36:	e8 05 1b 00 00       	call   102640 <kalloc>
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
  100b5b:	e8 c0 46 00 00       	call   105220 <memset>

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
  100ba0:	e8 5b 0a 00 00       	call   101600 <readi>
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
  100bdd:	e8 1e 0a 00 00       	call   101600 <readi>
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
  100c08:	e8 13 46 00 00       	call   105220 <memset>
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
  100c1c:	e8 8f 13 00 00       	call   101fb0 <iunlockput>
  
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
  100c86:	e8 75 47 00 00       	call   105400 <strlen>
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
  100ca5:	e8 06 46 00 00       	call   1052b0 <memmove>
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
  100d0b:	e8 70 34 00 00       	call   104180 <curproc>
  100d10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d14:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d1b:	00 
  100d1c:	05 88 00 00 00       	add    $0x88,%eax
  100d21:	89 04 24             	mov    %eax,(%esp)
  100d24:	e8 97 46 00 00       	call   1053c0 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100d29:	e8 52 34 00 00       	call   104180 <curproc>
  100d2e:	8b 58 04             	mov    0x4(%eax),%ebx
  100d31:	e8 4a 34 00 00       	call   104180 <curproc>
  100d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d3a:	8b 00                	mov    (%eax),%eax
  100d3c:	89 04 24             	mov    %eax,(%esp)
  100d3f:	e8 cc 19 00 00       	call   102710 <kfree>
  cp->mem = mem;
  100d44:	e8 37 34 00 00       	call   104180 <curproc>
  100d49:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d4c:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100d4e:	e8 2d 34 00 00       	call   104180 <curproc>
  100d53:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100d56:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d59:	e8 22 34 00 00       	call   104180 <curproc>
  100d5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100d61:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d67:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100d6a:	e8 11 34 00 00       	call   104180 <curproc>
  100d6f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d75:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d78:	e8 03 34 00 00       	call   104180 <curproc>
  100d7d:	89 04 24             	mov    %eax,(%esp)
  100d80:	e8 cb 39 00 00       	call   104750 <setupsegs>
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
  100da5:	e8 66 19 00 00       	call   102710 <kfree>
  iunlockput(ip);
  100daa:	89 1c 24             	mov    %ebx,(%esp)
  100dad:	e8 fe 11 00 00       	call   101fb0 <iunlockput>
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
  100e10:	e8 bb 11 00 00       	call   101fd0 <ilock>
    if((r = log_writei(f->ip, addr, f->off, n)) > 0)
  100e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e19:	8b 43 14             	mov    0x14(%ebx),%eax
  100e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e24:	8b 43 10             	mov    0x10(%ebx),%eax
  100e27:	89 04 24             	mov    %eax,(%esp)
  100e2a:	e8 a1 24 00 00       	call   1032d0 <log_writei>
  100e2f:	85 c0                	test   %eax,%eax
  100e31:	7e 03                	jle    100e36 <filewrite+0x56>
      f->off += r;
  100e33:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e36:	8b 53 10             	mov    0x10(%ebx),%edx
  100e39:	89 14 24             	mov    %edx,(%esp)
  100e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100e3f:	e8 1c 11 00 00       	call   101f60 <iunlock>
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
    if((r = log_writei(f->ip, addr, f->off, n)) > 0)
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
  100e72:	e9 c9 2d 00 00       	jmp    103c40 <pipewrite>
    if((r = log_writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e77:	c7 04 24 ea 73 10 00 	movl   $0x1073ea,(%esp)
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
  100eb0:	e8 1b 11 00 00       	call   101fd0 <ilock>
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
  100eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ebc:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebf:	89 04 24             	mov    %eax,(%esp)
  100ec2:	e8 99 09 00 00       	call   101860 <checki>
  100ec7:	89 c6                	mov    %eax,%esi
    iunlock(f->ip);
  100ec9:	8b 43 10             	mov    0x10(%ebx),%eax
  100ecc:	89 04 24             	mov    %eax,(%esp)
  100ecf:	e8 8c 10 00 00       	call   101f60 <iunlock>
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
  100ef1:	c7 04 24 f4 73 10 00 	movl   $0x1073f4,(%esp)
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
  100f30:	e8 9b 10 00 00       	call   101fd0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100f35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100f39:	8b 43 14             	mov    0x14(%ebx),%eax
  100f3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f44:	8b 43 10             	mov    0x10(%ebx),%eax
  100f47:	89 04 24             	mov    %eax,(%esp)
  100f4a:	e8 b1 06 00 00       	call   101600 <readi>
  100f4f:	85 c0                	test   %eax,%eax
  100f51:	7e 03                	jle    100f56 <fileread+0x56>
      f->off += r;
  100f53:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100f56:	8b 53 10             	mov    0x10(%ebx),%edx
  100f59:	89 14 24             	mov    %edx,(%esp)
  100f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100f5f:	e8 fc 0f 00 00       	call   101f60 <iunlock>
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
  100f92:	e9 c9 2b 00 00       	jmp    103b60 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f97:	c7 04 24 fe 73 10 00 	movl   $0x1073fe,(%esp)
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
  100fd6:	e8 f5 0f 00 00       	call   101fd0 <ilock>
    stati(f->ip, st);
  100fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fe2:	8b 43 10             	mov    0x10(%ebx),%eax
  100fe5:	89 04 24             	mov    %eax,(%esp)
  100fe8:	e8 f3 01 00 00       	call   1011e0 <stati>
    iunlock(f->ip);
  100fed:	8b 43 10             	mov    0x10(%ebx),%eax
  100ff0:	89 04 24             	mov    %eax,(%esp)
  100ff3:	e8 68 0f 00 00       	call   101f60 <iunlock>
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
  10100a:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  101011:	e8 9a 41 00 00       	call   1051b0 <acquire>
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
  101029:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  101030:	e8 3b 41 00 00       	call   105170 <release>
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
  10103d:	c7 04 24 07 74 10 00 	movl   $0x107407,(%esp)
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
  101057:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  10105e:	e8 4d 41 00 00       	call   1051b0 <acquire>
  101063:	ba 60 b5 10 00       	mov    $0x10b560,%edx
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
  10108b:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  101092:	c7 04 d5 60 b5 10 00 	movl   $0x1,0x10b560(,%edx,8)
  101099:	01 00 00 00 
      file[i].ref = 1;
  10109d:	c7 04 d5 64 b5 10 00 	movl   $0x1,0x10b564(,%edx,8)
  1010a4:	01 00 00 00 
      release(&file_table_lock);
  1010a8:	e8 c3 40 00 00       	call   105170 <release>
      return file + i;
  1010ad:	8d 83 60 b5 10 00    	lea    0x10b560(%ebx),%eax
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
  1010c0:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  1010c7:	e8 a4 40 00 00       	call   105170 <release>
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
  1010f2:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  1010f9:	e8 b2 40 00 00       	call   1051b0 <acquire>
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
  10111d:	c7 45 08 c0 be 10 00 	movl   $0x10bec0,0x8(%ebp)
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
  101130:	e9 3b 40 00 00       	jmp    105170 <release>
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
  101157:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  10115e:	e8 0d 40 00 00       	call   105170 <release>
  
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
  10117c:	e9 ff 0a 00 00       	jmp    101c80 <iput>
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
  101196:	e8 a5 2b 00 00       	call   103d40 <pipeclose>
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
  1011a8:	c7 04 24 0f 74 10 00 	movl   $0x10740f,(%esp)
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
  1011c6:	c7 44 24 04 19 74 10 	movl   $0x107419,0x4(%esp)
  1011cd:	00 
  1011ce:	c7 04 24 c0 be 10 00 	movl   $0x10bec0,(%esp)
  1011d5:	e8 16 3e 00 00       	call   104ff0 <initlock>
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

00101210 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  101210:	55                   	push   %ebp
  101211:	89 e5                	mov    %esp,%ebp
  101213:	83 ec 18             	sub    $0x18,%esp
  101216:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101219:	89 75 fc             	mov    %esi,-0x4(%ebp)
  10121c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  10121f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  101226:	00 
  101227:	8b 45 08             	mov    0x8(%ebp),%eax
  10122a:	89 04 24             	mov    %eax,(%esp)
  10122d:	e8 fe ee ff ff       	call   100130 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  101232:	89 34 24             	mov    %esi,(%esp)
  101235:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  10123c:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  10123d:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10123f:	8d 40 18             	lea    0x18(%eax),%eax
  101242:	89 44 24 04          	mov    %eax,0x4(%esp)
  101246:	e8 65 40 00 00       	call   1052b0 <memmove>
  brelse(bp);
}
  10124b:	8b 75 fc             	mov    -0x4(%ebp),%esi
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
  10124e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101251:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  101254:	89 ec                	mov    %ebp,%esp
  101256:	5d                   	pop    %ebp
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
  101257:	e9 a4 ed ff ff       	jmp    100000 <brelse>
  10125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101260 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101260:	55                   	push   %ebp
  101261:	89 e5                	mov    %esp,%ebp
  101263:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101266:	8b 45 0c             	mov    0xc(%ebp),%eax
  101269:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101270:	00 
  101271:	89 44 24 04          	mov    %eax,0x4(%esp)
  101275:	8b 45 08             	mov    0x8(%ebp),%eax
  101278:	89 04 24             	mov    %eax,(%esp)
  10127b:	e8 90 40 00 00       	call   105310 <strncmp>
}
  101280:	c9                   	leave  
  101281:	c3                   	ret    
  101282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101290 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101290:	55                   	push   %ebp
  101291:	89 e5                	mov    %esp,%ebp
  101293:	56                   	push   %esi
  101294:	53                   	push   %ebx
  101295:	83 ec 10             	sub    $0x10,%esp
  101298:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10129b:	8b 43 04             	mov    0x4(%ebx),%eax
  10129e:	c1 e8 03             	shr    $0x3,%eax
  1012a1:	83 c0 02             	add    $0x2,%eax
  1012a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1012a8:	8b 03                	mov    (%ebx),%eax
  1012aa:	89 04 24             	mov    %eax,(%esp)
  1012ad:	e8 7e ee ff ff       	call   100130 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  1012b2:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  1012b6:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  1012b8:	8b 43 04             	mov    0x4(%ebx),%eax
  1012bb:	83 e0 07             	and    $0x7,%eax
  1012be:	c1 e0 06             	shl    $0x6,%eax
  1012c1:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  1012c5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  1012c8:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  1012cc:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  1012d0:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  1012d4:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  1012d8:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  1012dc:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  1012e0:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1012e3:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  1012e6:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1012e9:	83 c0 0c             	add    $0xc,%eax
  1012ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1012f0:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  1012f7:	00 
  1012f8:	89 04 24             	mov    %eax,(%esp)
  1012fb:	e8 b0 3f 00 00       	call   1052b0 <memmove>
  bwrite(bp);
  101300:	89 34 24             	mov    %esi,(%esp)
  101303:	e8 f8 ed ff ff       	call   100100 <bwrite>
  brelse(bp);
  101308:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10130b:	83 c4 10             	add    $0x10,%esp
  10130e:	5b                   	pop    %ebx
  10130f:	5e                   	pop    %esi
  101310:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  101311:	e9 ea ec ff ff       	jmp    100000 <brelse>
  101316:	8d 76 00             	lea    0x0(%esi),%esi
  101319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101320 <balloc>:
// Blocks. 

// Allocate a disk block.
uint
balloc(uint dev)
{
  101320:	55                   	push   %ebp
  101321:	89 e5                	mov    %esp,%ebp
  101323:	57                   	push   %edi
  101324:	56                   	push   %esi
  101325:	53                   	push   %ebx
  101326:	83 ec 3c             	sub    $0x3c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101329:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10132c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101330:	8b 45 08             	mov    0x8(%ebp),%eax
  101333:	89 04 24             	mov    %eax,(%esp)
  101336:	e8 d5 fe ff ff       	call   101210 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  10133b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10133e:	85 c0                	test   %eax,%eax
  101340:	0f 84 9d 00 00 00    	je     1013e3 <balloc+0xc3>
  101346:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  10134d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101350:	31 db                	xor    %ebx,%ebx
  101352:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  101355:	c1 e8 03             	shr    $0x3,%eax
  101358:	c1 fa 0c             	sar    $0xc,%edx
  10135b:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  10135f:	8b 55 08             	mov    0x8(%ebp),%edx
  101362:	89 44 24 04          	mov    %eax,0x4(%esp)
  101366:	89 14 24             	mov    %edx,(%esp)
  101369:	e8 c2 ed ff ff       	call   100130 <bread>
  10136e:	89 c6                	mov    %eax,%esi
  101370:	eb 11                	jmp    101383 <balloc+0x63>
  101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(bi = 0; bi < BPB; bi++){
  101378:	83 c3 01             	add    $0x1,%ebx
  10137b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  101381:	74 45                	je     1013c8 <balloc+0xa8>
      m = 1 << (bi % 8);
  101383:	89 d9                	mov    %ebx,%ecx
  101385:	b8 01 00 00 00       	mov    $0x1,%eax
  10138a:	83 e1 07             	and    $0x7,%ecx
  10138d:	d3 e0                	shl    %cl,%eax
  10138f:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101391:	89 d8                	mov    %ebx,%eax
  101393:	c1 f8 03             	sar    $0x3,%eax
  101396:	0f b6 54 06 18       	movzbl 0x18(%esi,%eax,1),%edx
  10139b:	0f b6 fa             	movzbl %dl,%edi
  10139e:	85 cf                	test   %ecx,%edi
  1013a0:	75 d6                	jne    101378 <balloc+0x58>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1013a2:	09 d1                	or     %edx,%ecx
  1013a4:	88 4c 06 18          	mov    %cl,0x18(%esi,%eax,1)
        bwrite(bp);
  1013a8:	89 34 24             	mov    %esi,(%esp)
  1013ab:	e8 50 ed ff ff       	call   100100 <bwrite>
        brelse(bp);
  1013b0:	89 34 24             	mov    %esi,(%esp)
  1013b3:	e8 48 ec ff ff       	call   100000 <brelse>
  1013b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013bb:	83 c4 3c             	add    $0x3c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1013be:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013c1:	5b                   	pop    %ebx
  1013c2:	5e                   	pop    %esi
  1013c3:	5f                   	pop    %edi
  1013c4:	5d                   	pop    %ebp
  1013c5:	c3                   	ret    
  1013c6:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1013c8:	89 34 24             	mov    %esi,(%esp)
  1013cb:	e8 30 ec ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1013d0:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  1013d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1013da:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1013dd:	0f 87 6a ff ff ff    	ja     10134d <balloc+0x2d>
      }
    }
    brelse(bp);
    //cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
  1013e3:	c7 04 24 24 74 10 00 	movl   $0x107424,(%esp)
  1013ea:	e8 71 f5 ff ff       	call   100960 <panic>
  1013ef:	90                   	nop

001013f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
uint
bmap(struct inode *ip, uint bn, int alloc)
{
  1013f0:	55                   	push   %ebp
  1013f1:	89 e5                	mov    %esp,%ebp
  1013f3:	83 ec 38             	sub    $0x38,%esp
  1013f6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1013f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1013fc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1013ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101402:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101405:	8b 75 10             	mov    0x10(%ebp),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101408:	83 ff 0a             	cmp    $0xa,%edi
  10140b:	77 2b                	ja     101438 <bmap+0x48>
    if((addr = ip->addrs[bn]) == 0){
  10140d:	83 c7 04             	add    $0x4,%edi
  101410:	8b 44 bb 0c          	mov    0xc(%ebx,%edi,4),%eax
  101414:	85 c0                	test   %eax,%eax
  101416:	75 0d                	jne    101425 <bmap+0x35>
      if(!alloc)
  101418:	85 f6                	test   %esi,%esi
  10141a:	0f 85 e8 00 00 00    	jne    101508 <bmap+0x118>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  101420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101425:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101428:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10142b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10142e:	89 ec                	mov    %ebp,%esp
  101430:	5d                   	pop    %ebp
  101431:	c3                   	ret    
  101432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101438:	8d 57 f5             	lea    -0xb(%edi),%edx

  //check indirect
  if(bn < NINDIRECT){
  10143b:	83 fa 7f             	cmp    $0x7f,%edx
  10143e:	76 68                	jbe    1014a8 <bmap+0xb8>
    return addr;
  }

  //NEW CODE
  //decrement block number for new reference
  bn -= NINDIRECT;
  101440:	81 ef 8b 00 00 00    	sub    $0x8b,%edi


  //DOUBLE INDIRECT
  if(bn < NDINDIRECT){
  101446:	81 ff ff 3f 00 00    	cmp    $0x3fff,%edi
  10144c:	0f 87 99 01 00 00    	ja     1015eb <bmap+0x1fb>

	  //cprintf("bn is %d\n", bn);

	  if((addr = ip->addrs[DINDIRECT]) == 0){
  101452:	8b 43 4c             	mov    0x4c(%ebx),%eax
  101455:	85 c0                	test   %eax,%eax
  101457:	75 11                	jne    10146a <bmap+0x7a>
	     if(!alloc)
  101459:	85 f6                	test   %esi,%esi
  10145b:	74 c3                	je     101420 <bmap+0x30>
	        return -1;
	     ip->addrs[DINDIRECT] = addr = balloc(ip->dev);
  10145d:	8b 03                	mov    (%ebx),%eax
  10145f:	89 04 24             	mov    %eax,(%esp)
  101462:	e8 b9 fe ff ff       	call   101320 <balloc>
  101467:	89 43 4c             	mov    %eax,0x4c(%ebx)
	  }
	  bp = bread(ip->dev, addr);
  10146a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10146e:	8b 03                	mov    (%ebx),%eax
  101470:	89 04 24             	mov    %eax,(%esp)
  101473:	e8 b8 ec ff ff       	call   100130 <bread>
  101478:	89 c2                	mov    %eax,%edx
	  //calculate base and offset indirect block in double indirect block
	  uint base = bn / NINDIRECT;
	  uint offset = bn % NINDIRECT;

	  //grab indirect block and allocate if necessary
	  if((addr = a[base]) == 0){
  10147a:	89 f8                	mov    %edi,%eax
  10147c:	c1 e8 07             	shr    $0x7,%eax
  10147f:	8d 4c 82 18          	lea    0x18(%edx,%eax,4),%ecx
  101483:	8b 01                	mov    (%ecx),%eax
  101485:	85 c0                	test   %eax,%eax
  101487:	0f 85 bc 00 00 00    	jne    101549 <bmap+0x159>
	        if(!alloc){
  10148d:	85 f6                	test   %esi,%esi
  10148f:	0f 85 8b 00 00 00    	jne    101520 <bmap+0x130>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
	        if(!alloc){
	          brelse(bp);
  101495:	89 14 24             	mov    %edx,(%esp)
  101498:	e8 63 eb ff ff       	call   100000 <brelse>
  10149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	          return -1;
  1014a2:	eb 81                	jmp    101425 <bmap+0x35>
  1014a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  //check indirect
  if(bn < NINDIRECT){

    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  1014a8:	8b 43 48             	mov    0x48(%ebx),%eax
  1014ab:	85 c0                	test   %eax,%eax
  1014ad:	75 1b                	jne    1014ca <bmap+0xda>
      if(!alloc)
  1014af:	85 f6                	test   %esi,%esi
  1014b1:	0f 84 69 ff ff ff    	je     101420 <bmap+0x30>
        return -1;
      //cprintf("allocating indirect block %d in indirect\n", bn);
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  1014b7:	8b 03                	mov    (%ebx),%eax
  1014b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1014bc:	89 04 24             	mov    %eax,(%esp)
  1014bf:	e8 5c fe ff ff       	call   101320 <balloc>
  1014c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1014c7:	89 43 48             	mov    %eax,0x48(%ebx)
    }
    bp = bread(ip->dev, addr);
  1014ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014ce:	8b 03                	mov    (%ebx),%eax
  1014d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1014d3:	89 04 24             	mov    %eax,(%esp)
  1014d6:	e8 55 ec ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1014de:	8d 54 90 18          	lea    0x18(%eax,%edx,4),%edx
      if(!alloc)
        return -1;
      //cprintf("allocating indirect block %d in indirect\n", bn);
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  1014e2:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014e4:	8b 02                	mov    (%edx),%eax
  1014e6:	85 c0                	test   %eax,%eax
  1014e8:	0f 85 ea 00 00 00    	jne    1015d8 <bmap+0x1e8>
      if(!alloc){
  1014ee:	85 f6                	test   %esi,%esi
  1014f0:	0f 85 c2 00 00 00    	jne    1015b8 <bmap+0x1c8>
        brelse(bp);
  1014f6:	89 3c 24             	mov    %edi,(%esp)
  1014f9:	e8 02 eb ff ff       	call   100000 <brelse>
  1014fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        return -1;
  101503:	e9 1d ff ff ff       	jmp    101425 <bmap+0x35>

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101508:	8b 03                	mov    (%ebx),%eax
  10150a:	89 04 24             	mov    %eax,(%esp)
  10150d:	e8 0e fe ff ff       	call   101320 <balloc>
  101512:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  101516:	e9 0a ff ff ff       	jmp    101425 <bmap+0x35>
  10151b:	90                   	nop
  10151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  101520:	8b 03                	mov    (%ebx),%eax
  101522:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101525:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  101528:	89 04 24             	mov    %eax,(%esp)
  10152b:	e8 f0 fd ff ff       	call   101320 <balloc>
  101530:	8b 4d e0             	mov    -0x20(%ebp),%ecx
	        bwrite(bp);
  101533:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  101536:	89 01                	mov    %eax,(%ecx)
	        bwrite(bp);
  101538:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10153b:	89 14 24             	mov    %edx,(%esp)
  10153e:	e8 bd eb ff ff       	call   100100 <bwrite>
  101543:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101546:	8b 45 e0             	mov    -0x20(%ebp),%eax
	  }

	  brelse(bp);
  101549:	89 14 24             	mov    %edx,(%esp)
	  bp = bread(ip->dev, addr);
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  10154c:	83 e7 7f             	and    $0x7f,%edi
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
  10154f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101552:	e8 a9 ea ff ff       	call   100000 <brelse>
	  bp = bread(ip->dev, addr);
  101557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10155a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10155e:	8b 03                	mov    (%ebx),%eax
  101560:	89 04 24             	mov    %eax,(%esp)
  101563:	e8 c8 eb ff ff       	call   100130 <bread>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101568:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
	  bp = bread(ip->dev, addr);
  10156c:	89 c2                	mov    %eax,%edx
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  10156e:	8b 07                	mov    (%edi),%eax
  101570:	85 c0                	test   %eax,%eax
  101572:	75 2b                	jne    10159f <bmap+0x1af>
	        if(!alloc){
  101574:	85 f6                	test   %esi,%esi
  101576:	0f 84 19 ff ff ff    	je     101495 <bmap+0xa5>
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new data block with bn = %d\n", bn);
	        a[offset] = addr = balloc(ip->dev);
  10157c:	8b 03                	mov    (%ebx),%eax
  10157e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101581:	89 04 24             	mov    %eax,(%esp)
  101584:	e8 97 fd ff ff       	call   101320 <balloc>
	        bwrite(bp);
  101589:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new data block with bn = %d\n", bn);
	        a[offset] = addr = balloc(ip->dev);
  10158c:	89 07                	mov    %eax,(%edi)
	        bwrite(bp);
  10158e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101591:	89 14 24             	mov    %edx,(%esp)
  101594:	e8 67 eb ff ff       	call   100100 <bwrite>
  101599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10159c:	8b 45 e0             	mov    -0x20(%ebp),%eax
	  }
	  brelse(bp);
  10159f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1015a2:	89 14 24             	mov    %edx,(%esp)
  1015a5:	e8 56 ea ff ff       	call   100000 <brelse>
	  return addr;
  1015aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1015ad:	e9 73 fe ff ff       	jmp    101425 <bmap+0x35>
  1015b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(!alloc){
        brelse(bp);
        return -1;
      }
      //cprintf("allocating data block %d in indirect\n", bn);
      a[bn] = addr = balloc(ip->dev);
  1015b8:	8b 03                	mov    (%ebx),%eax
  1015ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1015bd:	89 04 24             	mov    %eax,(%esp)
  1015c0:	e8 5b fd ff ff       	call   101320 <balloc>
  1015c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1015c8:	89 02                	mov    %eax,(%edx)
      bwrite(bp);
  1015ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1015cd:	89 3c 24             	mov    %edi,(%esp)
  1015d0:	e8 2b eb ff ff       	call   100100 <bwrite>
  1015d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
    }
    brelse(bp);
  1015d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1015db:	89 3c 24             	mov    %edi,(%esp)
  1015de:	e8 1d ea ff ff       	call   100000 <brelse>
    return addr;
  1015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1015e6:	e9 3a fe ff ff       	jmp    101425 <bmap+0x35>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  1015eb:	c7 04 24 3a 74 10 00 	movl   $0x10743a,(%esp)
  1015f2:	e8 69 f3 ff ff       	call   100960 <panic>
  1015f7:	89 f6                	mov    %esi,%esi
  1015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101600 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101600:	55                   	push   %ebp
  101601:	89 e5                	mov    %esp,%ebp
  101603:	83 ec 38             	sub    $0x38,%esp
  101606:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10160c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10160f:	8b 55 14             	mov    0x14(%ebp),%edx
  101612:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101615:	8b 75 10             	mov    0x10(%ebp),%esi
  101618:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10161b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
  101620:	74 1e                	je     101640 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101622:	8b 43 18             	mov    0x18(%ebx),%eax
  101625:	39 f0                	cmp    %esi,%eax
  101627:	73 3f                	jae    101668 <readi+0x68>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10162e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101631:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101634:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101637:	89 ec                	mov    %ebp,%esp
  101639:	5d                   	pop    %ebp
  10163a:	c3                   	ret    
  10163b:	90                   	nop
  10163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101640:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101644:	66 83 f8 09          	cmp    $0x9,%ax
  101648:	77 df                	ja     101629 <readi+0x29>
  10164a:	98                   	cwtl   
  10164b:	8b 04 c5 00 bf 10 00 	mov    0x10bf00(,%eax,8),%eax
  101652:	85 c0                	test   %eax,%eax
  101654:	74 d3                	je     101629 <readi+0x29>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101656:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101659:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10165c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10165f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101662:	89 ec                	mov    %ebp,%esp
  101664:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101665:	ff e0                	jmp    *%eax
  101667:	90                   	nop
  }

  if(off > ip->size || off + n < off)
  101668:	89 d1                	mov    %edx,%ecx
  10166a:	01 f1                	add    %esi,%ecx
  10166c:	72 bb                	jb     101629 <readi+0x29>
    return -1;
  if(off + n > ip->size)
  10166e:	39 c8                	cmp    %ecx,%eax
  101670:	73 04                	jae    101676 <readi+0x76>
    n = ip->size - off;
  101672:	89 c2                	mov    %eax,%edx
  101674:	29 f2                	sub    %esi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101676:	85 d2                	test   %edx,%edx
  101678:	0f 84 8d 00 00 00    	je     10170b <readi+0x10b>
  10167e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
  101685:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  101688:	89 7d e0             	mov    %edi,-0x20(%ebp)
  10168b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10168e:	66 90                	xchg   %ax,%ax
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101690:	89 f0                	mov    %esi,%eax
    m = min(n - tot, BSIZE - off%BSIZE);
  101692:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101697:	c1 e8 09             	shr    $0x9,%eax
  10169a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1016a1:	00 
  1016a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1016a9:	89 04 24             	mov    %eax,(%esp)
  1016ac:	e8 3f fd ff ff       	call   1013f0 <bmap>
  1016b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1016b8:	8b 02                	mov    (%edx),%eax
  1016ba:	89 04 24             	mov    %eax,(%esp)
  1016bd:	e8 6e ea ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1016c5:	2b 55 e4             	sub    -0x1c(%ebp),%edx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016c8:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
  1016ca:	89 f0                	mov    %esi,%eax
  1016cc:	25 ff 01 00 00       	and    $0x1ff,%eax
  1016d1:	29 c7                	sub    %eax,%edi
  1016d3:	39 d7                	cmp    %edx,%edi
  1016d5:	76 02                	jbe    1016d9 <readi+0xd9>
  1016d7:	89 d7                	mov    %edx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1016d9:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016dd:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1016df:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1016ea:	89 04 24             	mov    %eax,(%esp)
  1016ed:	e8 be 3b 00 00       	call   1052b0 <memmove>
    brelse(bp);
  1016f2:	89 1c 24             	mov    %ebx,(%esp)
  1016f5:	e8 06 e9 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016fa:	01 7d e4             	add    %edi,-0x1c(%ebp)
  1016fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101700:	01 7d e0             	add    %edi,-0x20(%ebp)
  101703:	39 55 dc             	cmp    %edx,-0x24(%ebp)
  101706:	77 88                	ja     101690 <readi+0x90>
  101708:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10170b:	89 d0                	mov    %edx,%eax
  10170d:	e9 1c ff ff ff       	jmp    10162e <readi+0x2e>
  101712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101720 <writei>:
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  101720:	55                   	push   %ebp
  101721:	89 e5                	mov    %esp,%ebp
  101723:	57                   	push   %edi
  101724:	56                   	push   %esi
  101725:	53                   	push   %ebx
  101726:	83 ec 2c             	sub    $0x2c,%esp
  101729:	8b 45 08             	mov    0x8(%ebp),%eax
  10172c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10172f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101732:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101735:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  10173a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10173d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101740:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101743:	0f 84 cf 00 00 00    	je     101818 <writei+0xf8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  101749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10174c:	01 f0                	add    %esi,%eax
  10174e:	0f 82 ce 00 00 00    	jb     101822 <writei+0x102>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101754:	3d 00 16 81 00       	cmp    $0x811600,%eax
  101759:	76 0a                	jbe    101765 <writei+0x45>
    n = MAXFILE*BSIZE - off;
  10175b:	c7 45 e0 00 16 81 00 	movl   $0x811600,-0x20(%ebp)
  101762:	29 75 e0             	sub    %esi,-0x20(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101765:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101768:	85 d2                	test   %edx,%edx
  10176a:	0f 84 98 00 00 00    	je     101808 <writei+0xe8>
  101770:	31 ff                	xor    %edi,%edi
  101772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101778:	89 f0                	mov    %esi,%eax
    m = min(n - tot, BSIZE - off%BSIZE);
  10177a:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  10177f:	c1 e8 09             	shr    $0x9,%eax
  101782:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  101789:	00 
  10178a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10178e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101791:	89 04 24             	mov    %eax,(%esp)
  101794:	e8 57 fc ff ff       	call   1013f0 <bmap>
  101799:	89 44 24 04          	mov    %eax,0x4(%esp)
  10179d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1017a0:	8b 02                	mov    (%edx),%eax
  1017a2:	89 04 24             	mov    %eax,(%esp)
  1017a5:	e8 86 e9 ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1017aa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1017ad:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1017af:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1017b1:	89 f0                	mov    %esi,%eax
  1017b3:	25 ff 01 00 00       	and    $0x1ff,%eax
  1017b8:	29 c3                	sub    %eax,%ebx
  1017ba:	39 cb                	cmp    %ecx,%ebx
  1017bc:	76 02                	jbe    1017c0 <writei+0xa0>
  1017be:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  1017c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1017c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1017c7:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  1017cb:	89 04 24             	mov    %eax,(%esp)
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1017ce:	01 df                	add    %ebx,%edi
  1017d0:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  1017d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1017d6:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1017d9:	e8 d2 3a 00 00       	call   1052b0 <memmove>
    bwrite(bp);
  1017de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1017e1:	89 14 24             	mov    %edx,(%esp)
  1017e4:	e8 17 e9 ff ff       	call   100100 <bwrite>
    brelse(bp);
  1017e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1017ec:	89 14 24             	mov    %edx,(%esp)
  1017ef:	e8 0c e8 ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1017f4:	01 5d e4             	add    %ebx,-0x1c(%ebp)
  1017f7:	39 7d e0             	cmp    %edi,-0x20(%ebp)
  1017fa:	0f 87 78 ff ff ff    	ja     101778 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101800:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101803:	3b 70 18             	cmp    0x18(%eax),%esi
  101806:	77 28                	ja     101830 <writei+0x110>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101808:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
  10180b:	83 c4 2c             	add    $0x2c,%esp
  10180e:	5b                   	pop    %ebx
  10180f:	5e                   	pop    %esi
  101810:	5f                   	pop    %edi
  101811:	5d                   	pop    %ebp
  101812:	c3                   	ret    
  101813:	90                   	nop
  101814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101818:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10181c:	66 83 f8 09          	cmp    $0x9,%ax
  101820:	76 1b                	jbe    10183d <writei+0x11d>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101822:	83 c4 2c             	add    $0x2c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10182a:	5b                   	pop    %ebx
  10182b:	5e                   	pop    %esi
  10182c:	5f                   	pop    %edi
  10182d:	5d                   	pop    %ebp
  10182e:	c3                   	ret    
  10182f:	90                   	nop
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  101830:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
  101833:	89 04 24             	mov    %eax,(%esp)
  101836:	e8 55 fa ff ff       	call   101290 <iupdate>
  10183b:	eb cb                	jmp    101808 <writei+0xe8>
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  10183d:	98                   	cwtl   
  10183e:	8b 04 c5 04 bf 10 00 	mov    0x10bf04(,%eax,8),%eax
  101845:	85 c0                	test   %eax,%eax
  101847:	74 d9                	je     101822 <writei+0x102>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101849:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10184c:	83 c4 2c             	add    $0x2c,%esp
  10184f:	5b                   	pop    %ebx
  101850:	5e                   	pop    %esi
  101851:	5f                   	pop    %edi
  101852:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101853:	ff e0                	jmp    *%eax
  101855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101860 <checki>:
}

// Check data from inode to see if it is in the buffer cache.
int
checki(struct inode *ip, int off)
{
  101860:	55                   	push   %ebp
  101861:	89 e5                	mov    %esp,%ebp
  101863:	53                   	push   %ebx
  101864:	83 ec 14             	sub    $0x14,%esp
  101867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10186a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if(off > ip->size)
  10186d:	3b 43 18             	cmp    0x18(%ebx),%eax
  101870:	76 0e                	jbe    101880 <checki+0x20>
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));

 }
  101872:	83 c4 14             	add    $0x14,%esp
  101875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10187a:	5b                   	pop    %ebx
  10187b:	5d                   	pop    %ebp
  10187c:	c3                   	ret    
  10187d:	8d 76 00             	lea    0x0(%esi),%esi
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101880:	89 c2                	mov    %eax,%edx
  101882:	c1 fa 1f             	sar    $0x1f,%edx
  101885:	c1 ea 17             	shr    $0x17,%edx
  101888:	8d 04 02             	lea    (%edx,%eax,1),%eax
  10188b:	c1 f8 09             	sar    $0x9,%eax
  10188e:	89 1c 24             	mov    %ebx,(%esp)
  101891:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101898:	00 
  101899:	89 44 24 04          	mov    %eax,0x4(%esp)
  10189d:	e8 4e fb ff ff       	call   1013f0 <bmap>
  1018a2:	89 45 0c             	mov    %eax,0xc(%ebp)
  1018a5:	8b 03                	mov    (%ebx),%eax
  1018a7:	89 45 08             	mov    %eax,0x8(%ebp)

 }
  1018aa:	83 c4 14             	add    $0x14,%esp
  1018ad:	5b                   	pop    %ebx
  1018ae:	5d                   	pop    %ebp
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  1018af:	e9 cc e7 ff ff       	jmp    100080 <bcheck>
  1018b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1018ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001018c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  1018c0:	55                   	push   %ebp
  1018c1:	89 e5                	mov    %esp,%ebp
  1018c3:	57                   	push   %edi
  1018c4:	56                   	push   %esi
  1018c5:	89 d6                	mov    %edx,%esi
  1018c7:	53                   	push   %ebx
  1018c8:	89 c3                	mov    %eax,%ebx
  1018ca:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1018cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018d1:	89 04 24             	mov    %eax,(%esp)
  1018d4:	e8 57 e8 ff ff       	call   100130 <bread>
  memset(bp->data, 0, BSIZE);
  1018d9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  1018e0:	00 
  1018e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1018e8:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1018e9:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  1018eb:	8d 40 18             	lea    0x18(%eax),%eax
  1018ee:	89 04 24             	mov    %eax,(%esp)
  1018f1:	e8 2a 39 00 00       	call   105220 <memset>
  bwrite(bp);
  1018f6:	89 3c 24             	mov    %edi,(%esp)
  1018f9:	e8 02 e8 ff ff       	call   100100 <bwrite>
  brelse(bp);
  1018fe:	89 3c 24             	mov    %edi,(%esp)
  101901:	e8 fa e6 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101906:	8d 45 dc             	lea    -0x24(%ebp),%eax
  101909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10190d:	89 1c 24             	mov    %ebx,(%esp)
  101910:	e8 fb f8 ff ff       	call   101210 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101918:	89 f2                	mov    %esi,%edx
  10191a:	c1 ea 0c             	shr    $0xc,%edx
  10191d:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101920:	bb 01 00 00 00       	mov    $0x1,%ebx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101925:	c1 e8 03             	shr    $0x3,%eax
  101928:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  10192c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101930:	e8 fb e7 ff ff       	call   100130 <bread>
  bi = b % BPB;
  101935:	89 f2                	mov    %esi,%edx
  m = 1 << (bi % 8);
  101937:	89 f1                	mov    %esi,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101939:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  10193f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  101942:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101945:	d3 e3                	shl    %cl,%ebx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101947:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101949:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
  10194e:	0f b6 c8             	movzbl %al,%ecx
  101951:	85 d9                	test   %ebx,%ecx
  101953:	74 20                	je     101975 <bfree+0xb5>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101955:	f7 d3                	not    %ebx
  101957:	21 c3                	and    %eax,%ebx
  101959:	88 5c 17 18          	mov    %bl,0x18(%edi,%edx,1)
  bwrite(bp);
  10195d:	89 3c 24             	mov    %edi,(%esp)
  101960:	e8 9b e7 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101965:	89 3c 24             	mov    %edi,(%esp)
  101968:	e8 93 e6 ff ff       	call   100000 <brelse>
}
  10196d:	83 c4 2c             	add    $0x2c,%esp
  101970:	5b                   	pop    %ebx
  101971:	5e                   	pop    %esi
  101972:	5f                   	pop    %edi
  101973:	5d                   	pop    %ebp
  101974:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101975:	c7 04 24 4d 74 10 00 	movl   $0x10744d,(%esp)
  10197c:	e8 df ef ff ff       	call   100960 <panic>
  101981:	eb 0d                	jmp    101990 <idup>
  101983:	90                   	nop
  101984:	90                   	nop
  101985:	90                   	nop
  101986:	90                   	nop
  101987:	90                   	nop
  101988:	90                   	nop
  101989:	90                   	nop
  10198a:	90                   	nop
  10198b:	90                   	nop
  10198c:	90                   	nop
  10198d:	90                   	nop
  10198e:	90                   	nop
  10198f:	90                   	nop

00101990 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101990:	55                   	push   %ebp
  101991:	89 e5                	mov    %esp,%ebp
  101993:	53                   	push   %ebx
  101994:	83 ec 14             	sub    $0x14,%esp
  101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10199a:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  1019a1:	e8 0a 38 00 00       	call   1051b0 <acquire>
  ip->ref++;
  1019a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  1019aa:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  1019b1:	e8 ba 37 00 00       	call   105170 <release>
  return ip;
}
  1019b6:	89 d8                	mov    %ebx,%eax
  1019b8:	83 c4 14             	add    $0x14,%esp
  1019bb:	5b                   	pop    %ebx
  1019bc:	5d                   	pop    %ebp
  1019bd:	c3                   	ret    
  1019be:	66 90                	xchg   %ax,%ax

001019c0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
struct inode*
iget(uint dev, uint inum)
{
  1019c0:	55                   	push   %ebp
  1019c1:	89 e5                	mov    %esp,%ebp
  1019c3:	57                   	push   %edi
  1019c4:	56                   	push   %esi
  1019c5:	53                   	push   %ebx
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
struct inode*
iget(uint dev, uint inum)
  1019c6:	31 db                	xor    %ebx,%ebx
{
  1019c8:	83 ec 2c             	sub    $0x2c,%esp
  1019cb:	8b 75 08             	mov    0x8(%ebp),%esi
  1019ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1019d1:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  1019d8:	e8 d3 37 00 00       	call   1051b0 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
struct inode*
iget(uint dev, uint inum)
  1019dd:	b8 94 bf 10 00       	mov    $0x10bf94,%eax
  1019e2:	eb 12                	jmp    1019f6 <iget+0x36>
  1019e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1019e8:	85 db                	test   %ebx,%ebx
  1019ea:	74 3c                	je     101a28 <iget+0x68>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1019ec:	83 c0 50             	add    $0x50,%eax
  1019ef:	3d 34 cf 10 00       	cmp    $0x10cf34,%eax
  1019f4:	74 42                	je     101a38 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1019f6:	8b 50 08             	mov    0x8(%eax),%edx
  1019f9:	85 d2                	test   %edx,%edx
  1019fb:	7e eb                	jle    1019e8 <iget+0x28>
  1019fd:	39 30                	cmp    %esi,(%eax)
  1019ff:	75 e7                	jne    1019e8 <iget+0x28>
  101a01:	39 78 04             	cmp    %edi,0x4(%eax)
  101a04:	75 e2                	jne    1019e8 <iget+0x28>
      ip->ref++;
  101a06:	83 c2 01             	add    $0x1,%edx
  101a09:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
  101a0c:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101a13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101a16:	e8 55 37 00 00       	call   105170 <release>
      return ip;
  101a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  101a1e:	83 c4 2c             	add    $0x2c,%esp
  101a21:	5b                   	pop    %ebx
  101a22:	5e                   	pop    %esi
  101a23:	5f                   	pop    %edi
  101a24:	5d                   	pop    %ebp
  101a25:	c3                   	ret    
  101a26:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101a28:	85 d2                	test   %edx,%edx
  101a2a:	75 c0                	jne    1019ec <iget+0x2c>
  101a2c:	89 c3                	mov    %eax,%ebx

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101a2e:	83 c0 50             	add    $0x50,%eax
  101a31:	3d 34 cf 10 00       	cmp    $0x10cf34,%eax
  101a36:	75 be                	jne    1019f6 <iget+0x36>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101a38:	85 db                	test   %ebx,%ebx
  101a3a:	74 29                	je     101a65 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  101a3c:	89 33                	mov    %esi,(%ebx)
  ip->inum = inum;
  101a3e:	89 7b 04             	mov    %edi,0x4(%ebx)
  ip->ref = 1;
  101a41:	c7 43 08 01 00 00 00 	movl   $0x1,0x8(%ebx)
  ip->flags = 0;
  101a48:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  release(&icache.lock);
  101a4f:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101a56:	e8 15 37 00 00       	call   105170 <release>

  return ip;
}
  101a5b:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101a5e:	89 d8                	mov    %ebx,%eax

  return ip;
}
  101a60:	5b                   	pop    %ebx
  101a61:	5e                   	pop    %esi
  101a62:	5f                   	pop    %edi
  101a63:	5d                   	pop    %ebp
  101a64:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101a65:	c7 04 24 60 74 10 00 	movl   $0x107460,(%esp)
  101a6c:	e8 ef ee ff ff       	call   100960 <panic>
  101a71:	eb 0d                	jmp    101a80 <dirlookup>
  101a73:	90                   	nop
  101a74:	90                   	nop
  101a75:	90                   	nop
  101a76:	90                   	nop
  101a77:	90                   	nop
  101a78:	90                   	nop
  101a79:	90                   	nop
  101a7a:	90                   	nop
  101a7b:	90                   	nop
  101a7c:	90                   	nop
  101a7d:	90                   	nop
  101a7e:	90                   	nop
  101a7f:	90                   	nop

00101a80 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101a80:	55                   	push   %ebp
  101a81:	89 e5                	mov    %esp,%ebp
  101a83:	57                   	push   %edi
  101a84:	56                   	push   %esi
  101a85:	53                   	push   %ebx
  101a86:	83 ec 3c             	sub    $0x3c,%esp
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	8b 55 10             	mov    0x10(%ebp),%edx
  101a8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101a92:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101a97:	89 45 dc             	mov    %eax,-0x24(%ebp)
  101a9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101a9d:	0f 85 e8 00 00 00    	jne    101b8b <dirlookup+0x10b>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101aa3:	8b 58 18             	mov    0x18(%eax),%ebx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101aa6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  101aad:	85 db                	test   %ebx,%ebx
  101aaf:	0f 84 cc 00 00 00    	je     101b81 <dirlookup+0x101>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101ab5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101abc:	00 
  101abd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101ac0:	c1 e8 09             	shr    $0x9,%eax
  101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101aca:	89 04 24             	mov    %eax,(%esp)
  101acd:	e8 1e f9 ff ff       	call   1013f0 <bmap>
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101ad9:	8b 02                	mov    (%edx),%eax
  101adb:	89 04 24             	mov    %eax,(%esp)
  101ade:	e8 4d e6 ff ff       	call   100130 <bread>
  101ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101ae6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101ae9:	83 c0 18             	add    $0x18,%eax
  101aec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101aef:	89 c3                	mov    %eax,%ebx

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101af1:	81 c6 18 02 00 00    	add    $0x218,%esi
  101af7:	eb 0e                	jmp    101b07 <dirlookup+0x87>
  101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  101b00:	83 c3 10             	add    $0x10,%ebx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101b03:	39 f3                	cmp    %esi,%ebx
  101b05:	74 59                	je     101b60 <dirlookup+0xe0>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  101b07:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101b0b:	74 f3                	je     101b00 <dirlookup+0x80>
        continue;
      if(namecmp(name, de->name) == 0){
  101b0d:	8d 43 02             	lea    0x2(%ebx),%eax
  101b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b14:	89 3c 24             	mov    %edi,(%esp)
  101b17:	e8 44 f7 ff ff       	call   101260 <namecmp>
  101b1c:	85 c0                	test   %eax,%eax
  101b1e:	75 e0                	jne    101b00 <dirlookup+0x80>
        // entry matches path element
        if(poff)
  101b20:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  101b23:	85 c9                	test   %ecx,%ecx
  101b25:	74 0e                	je     101b35 <dirlookup+0xb5>
          *poff = off + (uchar*)de - bp->data;
  101b27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101b2a:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101b2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  101b30:	2b 45 d8             	sub    -0x28(%ebp),%eax
  101b33:	89 02                	mov    %eax,(%edx)
        inum = de->inum;
        brelse(bp);
  101b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  101b38:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101b3b:	89 04 24             	mov    %eax,(%esp)
  101b3e:	e8 bd e4 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  101b43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101b46:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  101b49:	8b 02                	mov    (%edx),%eax
  101b4b:	89 45 08             	mov    %eax,0x8(%ebp)
      }
    }
    brelse(bp);
  }
  return 0;
}
  101b4e:	83 c4 3c             	add    $0x3c,%esp
  101b51:	5b                   	pop    %ebx
  101b52:	5e                   	pop    %esi
  101b53:	5f                   	pop    %edi
  101b54:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101b55:	e9 66 fe ff ff       	jmp    1019c0 <iget>
  101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }
    brelse(bp);
  101b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101b63:	89 04 24             	mov    %eax,(%esp)
  101b66:	e8 95 e4 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101b6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101b6e:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  101b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101b78:	39 42 18             	cmp    %eax,0x18(%edx)
  101b7b:	0f 87 34 ff ff ff    	ja     101ab5 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101b81:	83 c4 3c             	add    $0x3c,%esp
  101b84:	31 c0                	xor    %eax,%eax
  101b86:	5b                   	pop    %ebx
  101b87:	5e                   	pop    %esi
  101b88:	5f                   	pop    %edi
  101b89:	5d                   	pop    %ebp
  101b8a:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101b8b:	c7 04 24 70 74 10 00 	movl   $0x107470,(%esp)
  101b92:	e8 c9 ed ff ff       	call   100960 <panic>
  101b97:	89 f6                	mov    %esi,%esi
  101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101ba0 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101ba0:	55                   	push   %ebp
  101ba1:	89 e5                	mov    %esp,%ebp
  101ba3:	57                   	push   %edi
  101ba4:	56                   	push   %esi
  101ba5:	53                   	push   %ebx
  101ba6:	83 ec 3c             	sub    $0x3c,%esp
  101ba9:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  101bad:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101bb1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  101bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	89 04 24             	mov    %eax,(%esp)
  101bbe:	e8 4d f6 ff ff       	call   101210 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101bc3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101bc7:	0f 86 9c 00 00 00    	jbe    101c69 <ialloc+0xc9>
  101bcd:	be 01 00 00 00       	mov    $0x1,%esi
  101bd2:	bb 01 00 00 00       	mov    $0x1,%ebx
  101bd7:	eb 19                	jmp    101bf2 <ialloc+0x52>
  101bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101be0:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101be3:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101be6:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101be8:	e8 13 e4 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101bed:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  101bf0:	73 77                	jae    101c69 <ialloc+0xc9>
    bp = bread(dev, IBLOCK(inum));
  101bf2:	89 f0                	mov    %esi,%eax
  101bf4:	c1 e8 03             	shr    $0x3,%eax
  101bf7:	83 c0 02             	add    $0x2,%eax
  101bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	89 04 24             	mov    %eax,(%esp)
  101c04:	e8 27 e5 ff ff       	call   100130 <bread>
  101c09:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101c0b:	89 f0                	mov    %esi,%eax
  101c0d:	83 e0 07             	and    $0x7,%eax
  101c10:	c1 e0 06             	shl    $0x6,%eax
  101c13:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  101c17:	66 83 3a 00          	cmpw   $0x0,(%edx)
  101c1b:	75 c3                	jne    101be0 <ialloc+0x40>
      memset(dip, 0, sizeof(*dip));
  101c1d:	89 14 24             	mov    %edx,(%esp)
  101c20:	89 55 d0             	mov    %edx,-0x30(%ebp)
  101c23:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101c2a:	00 
  101c2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101c32:	00 
  101c33:	e8 e8 35 00 00       	call   105220 <memset>
      dip->type = type;
  101c38:	8b 55 d0             	mov    -0x30(%ebp),%edx
  101c3b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101c3f:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  101c42:	89 3c 24             	mov    %edi,(%esp)
  101c45:	e8 b6 e4 ff ff       	call   100100 <bwrite>
      brelse(bp);
  101c4a:	89 3c 24             	mov    %edi,(%esp)
  101c4d:	e8 ae e3 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101c52:	8b 45 08             	mov    0x8(%ebp),%eax
  101c55:	89 74 24 04          	mov    %esi,0x4(%esp)
  101c59:	89 04 24             	mov    %eax,(%esp)
  101c5c:	e8 5f fd ff ff       	call   1019c0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101c61:	83 c4 3c             	add    $0x3c,%esp
  101c64:	5b                   	pop    %ebx
  101c65:	5e                   	pop    %esi
  101c66:	5f                   	pop    %edi
  101c67:	5d                   	pop    %ebp
  101c68:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101c69:	c7 04 24 82 74 10 00 	movl   $0x107482,(%esp)
  101c70:	e8 eb ec ff ff       	call   100960 <panic>
  101c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101c80 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101c80:	55                   	push   %ebp
  101c81:	89 e5                	mov    %esp,%ebp
  101c83:	57                   	push   %edi
  101c84:	56                   	push   %esi
  101c85:	53                   	push   %ebx
  101c86:	83 ec 2c             	sub    $0x2c,%esp
  101c89:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&icache.lock);
  101c8c:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101c93:	e8 18 35 00 00       	call   1051b0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101c98:	8b 47 08             	mov    0x8(%edi),%eax
  101c9b:	83 f8 01             	cmp    $0x1,%eax
  101c9e:	0f 85 a8 00 00 00    	jne    101d4c <iput+0xcc>
  101ca4:	8b 57 0c             	mov    0xc(%edi),%edx
  101ca7:	f6 c2 02             	test   $0x2,%dl
  101caa:	0f 84 9c 00 00 00    	je     101d4c <iput+0xcc>
  101cb0:	66 83 7f 16 00       	cmpw   $0x0,0x16(%edi)
  101cb5:	0f 85 91 00 00 00    	jne    101d4c <iput+0xcc>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101cbb:	f6 c2 01             	test   $0x1,%dl
  101cbe:	66 90                	xchg   %ax,%ax
  101cc0:	0f 85 9d 01 00 00    	jne    101e63 <iput+0x1e3>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101cc6:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  101cc9:	89 fb                	mov    %edi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101ccb:	89 57 0c             	mov    %edx,0xc(%edi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  101cce:	8d 77 2c             	lea    0x2c(%edi),%esi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  101cd1:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101cd8:	e8 93 34 00 00       	call   105170 <release>
  101cdd:	eb 07                	jmp    101ce6 <iput+0x66>
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101cdf:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101ce2:	39 f3                	cmp    %esi,%ebx
  101ce4:	74 1c                	je     101d02 <iput+0x82>
    if(ip->addrs[i]){
  101ce6:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101ce9:	85 d2                	test   %edx,%edx
  101ceb:	74 f2                	je     101cdf <iput+0x5f>
      bfree(ip->dev, ip->addrs[i]);
  101ced:	8b 07                	mov    (%edi),%eax
  101cef:	e8 cc fb ff ff       	call   1018c0 <bfree>
      ip->addrs[i] = 0;
  101cf4:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101cfb:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101cfe:	39 f3                	cmp    %esi,%ebx
  101d00:	75 e4                	jne    101ce6 <iput+0x66>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101d02:	8b 47 48             	mov    0x48(%edi),%eax
  101d05:	85 c0                	test   %eax,%eax
  101d07:	0f 85 e9 00 00 00    	jne    101df6 <iput+0x176>
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
  101d0d:	8b 47 4c             	mov    0x4c(%edi),%eax
  101d10:	85 c0                	test   %eax,%eax
  101d12:	75 51                	jne    101d65 <iput+0xe5>
	      }
	      brelse(bp);
	      ip->addrs[DINDIRECT] = 0;
  }

  ip->size = 0;
  101d14:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101d1b:	89 3c 24             	mov    %edi,(%esp)
  101d1e:	e8 6d f5 ff ff       	call   101290 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101d23:	66 c7 47 10 00 00    	movw   $0x0,0x10(%edi)
    iupdate(ip);
  101d29:	89 3c 24             	mov    %edi,(%esp)
  101d2c:	e8 5f f5 ff ff       	call   101290 <iupdate>
    acquire(&icache.lock);
  101d31:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101d38:	e8 73 34 00 00       	call   1051b0 <acquire>
    ip->flags &= ~I_BUSY;
  101d3d:	83 67 0c fe          	andl   $0xfffffffe,0xc(%edi)
    wakeup(ip);
  101d41:	89 3c 24             	mov    %edi,(%esp)
  101d44:	e8 37 23 00 00       	call   104080 <wakeup>
  101d49:	8b 47 08             	mov    0x8(%edi),%eax
  }
  ip->ref--;
  101d4c:	83 e8 01             	sub    $0x1,%eax
  101d4f:	89 47 08             	mov    %eax,0x8(%edi)
  release(&icache.lock);
  101d52:	c7 45 08 60 bf 10 00 	movl   $0x10bf60,0x8(%ebp)
}
  101d59:	83 c4 2c             	add    $0x2c,%esp
  101d5c:	5b                   	pop    %ebx
  101d5d:	5e                   	pop    %esi
  101d5e:	5f                   	pop    %edi
  101d5f:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101d60:	e9 0b 34 00 00       	jmp    105170 <release>
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d69:	8b 07                	mov    (%edi),%eax
  101d6b:	89 04 24             	mov    %eax,(%esp)
  101d6e:	e8 bd e3 ff ff       	call   100130 <bread>
	      a = (uint*)bp->data;
  101d73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101d7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	      a = (uint*)bp->data;
  101d7d:	83 c0 18             	add    $0x18,%eax
  101d80:	89 45 dc             	mov    %eax,-0x24(%ebp)
  101d83:	31 c0                	xor    %eax,%eax
  101d85:	eb 13                	jmp    101d9a <iput+0x11a>
  101d87:	90                   	nop
	      for(j = 0; j < NINDIRECT; j++){
  101d88:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  101d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101d8f:	3d 80 00 00 00       	cmp    $0x80,%eax
  101d94:	0f 84 9b 00 00 00    	je     101e35 <iput+0x1b5>
	        if(a[j]){
  101d9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101d9d:	8d 04 82             	lea    (%edx,%eax,4),%eax
  101da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101da3:	8b 00                	mov    (%eax),%eax
  101da5:	85 c0                	test   %eax,%eax
  101da7:	74 df                	je     101d88 <iput+0x108>
	          bp2 = bread(ip->dev, a[j]);
  101da9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dad:	8b 07                	mov    (%edi),%eax
	          uint* b = (uint*)bp2->data;
  101daf:	31 db                	xor    %ebx,%ebx
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
  101db1:	89 04 24             	mov    %eax,(%esp)
  101db4:	e8 77 e3 ff ff       	call   100130 <bread>
	          uint* b = (uint*)bp2->data;
  101db9:	8d 70 18             	lea    0x18(%eax),%esi
  101dbc:	31 c0                	xor    %eax,%eax
  101dbe:	eb 0d                	jmp    101dcd <iput+0x14d>
	          for(k = 0; k < NINDIRECT; k++){
  101dc0:	83 c3 01             	add    $0x1,%ebx
  101dc3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101dc9:	89 d8                	mov    %ebx,%eax
  101dcb:	74 1b                	je     101de8 <iput+0x168>
	        	  if(b[k]){
  101dcd:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101dd0:	85 d2                	test   %edx,%edx
  101dd2:	74 ec                	je     101dc0 <iput+0x140>
	        		  bfree(ip->dev, b[k]);
  101dd4:	8b 07                	mov    (%edi),%eax
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101dd6:	83 c3 01             	add    $0x1,%ebx
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
  101dd9:	e8 e2 fa ff ff       	call   1018c0 <bfree>
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101dde:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101de4:	89 d8                	mov    %ebx,%eax
  101de6:	75 e5                	jne    101dcd <iput+0x14d>
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
	        	  }

	          }
	          bfree(ip->dev, a[j]);
  101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101deb:	8b 10                	mov    (%eax),%edx
  101ded:	8b 07                	mov    (%edi),%eax
  101def:	e8 cc fa ff ff       	call   1018c0 <bfree>
  101df4:	eb 92                	jmp    101d88 <iput+0x108>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dfa:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101dfc:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101dfe:	89 04 24             	mov    %eax,(%esp)
  101e01:	e8 2a e3 ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  101e06:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101e08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101e0b:	83 c6 18             	add    $0x18,%esi
  101e0e:	31 c0                	xor    %eax,%eax
  101e10:	eb 13                	jmp    101e25 <iput+0x1a5>
  101e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(j = 0; j < NINDIRECT; j++){
  101e18:	83 c3 01             	add    $0x1,%ebx
  101e1b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101e21:	89 d8                	mov    %ebx,%eax
  101e23:	74 27                	je     101e4c <iput+0x1cc>
      if(a[j])
  101e25:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101e28:	85 d2                	test   %edx,%edx
  101e2a:	74 ec                	je     101e18 <iput+0x198>
        bfree(ip->dev, a[j]);
  101e2c:	8b 07                	mov    (%edi),%eax
  101e2e:	e8 8d fa ff ff       	call   1018c0 <bfree>
  101e33:	eb e3                	jmp    101e18 <iput+0x198>

	          }
	          bfree(ip->dev, a[j]);
	        }
	      }
	      brelse(bp);
  101e35:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101e38:	89 14 24             	mov    %edx,(%esp)
  101e3b:	e8 c0 e1 ff ff       	call   100000 <brelse>
	      ip->addrs[DINDIRECT] = 0;
  101e40:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101e47:	e9 c8 fe ff ff       	jmp    101d14 <iput+0x94>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e4f:	89 04 24             	mov    %eax,(%esp)
  101e52:	e8 a9 e1 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  101e57:	c7 47 48 00 00 00 00 	movl   $0x0,0x48(%edi)
  101e5e:	e9 aa fe ff ff       	jmp    101d0d <iput+0x8d>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101e63:	c7 04 24 94 74 10 00 	movl   $0x107494,(%esp)
  101e6a:	e8 f1 ea ff ff       	call   100960 <panic>
  101e6f:	90                   	nop

00101e70 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101e70:	55                   	push   %ebp
  101e71:	89 e5                	mov    %esp,%ebp
  101e73:	57                   	push   %edi
  101e74:	56                   	push   %esi
  101e75:	53                   	push   %ebx
  101e76:	83 ec 2c             	sub    $0x2c,%esp
  101e79:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101e7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101e86:	00 
  101e87:	89 34 24             	mov    %esi,(%esp)
  101e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e8e:	e8 ed fb ff ff       	call   101a80 <dirlookup>
  101e93:	85 c0                	test   %eax,%eax
  101e95:	0f 85 89 00 00 00    	jne    101f24 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101e9b:	8b 7e 18             	mov    0x18(%esi),%edi
  101e9e:	85 ff                	test   %edi,%edi
  101ea0:	0f 84 8d 00 00 00    	je     101f33 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101ea6:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101ea9:	31 db                	xor    %ebx,%ebx
  101eab:	eb 0b                	jmp    101eb8 <dirlink+0x48>
  101ead:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101eb0:	83 c3 10             	add    $0x10,%ebx
  101eb3:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101eb6:	76 24                	jbe    101edc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101eb8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101ebf:	00 
  101ec0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101ec4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101ec8:	89 34 24             	mov    %esi,(%esp)
  101ecb:	e8 30 f7 ff ff       	call   101600 <readi>
  101ed0:	83 f8 10             	cmp    $0x10,%eax
  101ed3:	75 65                	jne    101f3a <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101ed5:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101eda:	75 d4                	jne    101eb0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  101edf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101ee6:	00 
  101ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101eeb:	8d 45 da             	lea    -0x26(%ebp),%eax
  101eee:	89 04 24             	mov    %eax,(%esp)
  101ef1:	e8 7a 34 00 00       	call   105370 <strncpy>
  de.inum = ino;
  101ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101ef9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101f00:	00 
  101f01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101f05:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101f09:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101f0d:	89 34 24             	mov    %esi,(%esp)
  101f10:	e8 0b f8 ff ff       	call   101720 <writei>
  101f15:	83 f8 10             	cmp    $0x10,%eax
  101f18:	75 2c                	jne    101f46 <dirlink+0xd6>
    panic("dirlink");
  101f1a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101f1c:	83 c4 2c             	add    $0x2c,%esp
  101f1f:	5b                   	pop    %ebx
  101f20:	5e                   	pop    %esi
  101f21:	5f                   	pop    %edi
  101f22:	5d                   	pop    %ebp
  101f23:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101f24:	89 04 24             	mov    %eax,(%esp)
  101f27:	e8 54 fd ff ff       	call   101c80 <iput>
  101f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101f31:	eb e9                	jmp    101f1c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101f33:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101f36:	31 db                	xor    %ebx,%ebx
  101f38:	eb a2                	jmp    101edc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101f3a:	c7 04 24 9e 74 10 00 	movl   $0x10749e,(%esp)
  101f41:	e8 1a ea ff ff       	call   100960 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101f46:	c7 04 24 ab 74 10 00 	movl   $0x1074ab,(%esp)
  101f4d:	e8 0e ea ff ff       	call   100960 <panic>
  101f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101f60 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101f60:	55                   	push   %ebp
  101f61:	89 e5                	mov    %esp,%ebp
  101f63:	53                   	push   %ebx
  101f64:	83 ec 14             	sub    $0x14,%esp
  101f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101f6a:	85 db                	test   %ebx,%ebx
  101f6c:	74 36                	je     101fa4 <iunlock+0x44>
  101f6e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101f72:	74 30                	je     101fa4 <iunlock+0x44>
  101f74:	8b 43 08             	mov    0x8(%ebx),%eax
  101f77:	85 c0                	test   %eax,%eax
  101f79:	7e 29                	jle    101fa4 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101f7b:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101f82:	e8 29 32 00 00       	call   1051b0 <acquire>
  ip->flags &= ~I_BUSY;
  101f87:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101f8b:	89 1c 24             	mov    %ebx,(%esp)
  101f8e:	e8 ed 20 00 00       	call   104080 <wakeup>
  release(&icache.lock);
  101f93:	c7 45 08 60 bf 10 00 	movl   $0x10bf60,0x8(%ebp)
}
  101f9a:	83 c4 14             	add    $0x14,%esp
  101f9d:	5b                   	pop    %ebx
  101f9e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101f9f:	e9 cc 31 00 00       	jmp    105170 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101fa4:	c7 04 24 b3 74 10 00 	movl   $0x1074b3,(%esp)
  101fab:	e8 b0 e9 ff ff       	call   100960 <panic>

00101fb0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101fb0:	55                   	push   %ebp
  101fb1:	89 e5                	mov    %esp,%ebp
  101fb3:	53                   	push   %ebx
  101fb4:	83 ec 14             	sub    $0x14,%esp
  101fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101fba:	89 1c 24             	mov    %ebx,(%esp)
  101fbd:	e8 9e ff ff ff       	call   101f60 <iunlock>
  iput(ip);
  101fc2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101fc5:	83 c4 14             	add    $0x14,%esp
  101fc8:	5b                   	pop    %ebx
  101fc9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101fca:	e9 b1 fc ff ff       	jmp    101c80 <iput>
  101fcf:	90                   	nop

00101fd0 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101fd0:	55                   	push   %ebp
  101fd1:	89 e5                	mov    %esp,%ebp
  101fd3:	56                   	push   %esi
  101fd4:	53                   	push   %ebx
  101fd5:	83 ec 10             	sub    $0x10,%esp
  101fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101fdb:	85 db                	test   %ebx,%ebx
  101fdd:	0f 84 e5 00 00 00    	je     1020c8 <ilock+0xf8>
  101fe3:	8b 53 08             	mov    0x8(%ebx),%edx
  101fe6:	85 d2                	test   %edx,%edx
  101fe8:	0f 8e da 00 00 00    	jle    1020c8 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101fee:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  101ff5:	e8 b6 31 00 00       	call   1051b0 <acquire>
  while(ip->flags & I_BUSY)
  101ffa:	8b 43 0c             	mov    0xc(%ebx),%eax
  101ffd:	a8 01                	test   $0x1,%al
  101fff:	74 1e                	je     10201f <ilock+0x4f>
  102001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  102008:	c7 44 24 04 60 bf 10 	movl   $0x10bf60,0x4(%esp)
  10200f:	00 
  102010:	89 1c 24             	mov    %ebx,(%esp)
  102013:	e8 18 24 00 00       	call   104430 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  102018:	8b 43 0c             	mov    0xc(%ebx),%eax
  10201b:	a8 01                	test   $0x1,%al
  10201d:	75 e9                	jne    102008 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  10201f:	83 c8 01             	or     $0x1,%eax
  102022:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  102025:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  10202c:	e8 3f 31 00 00       	call   105170 <release>

  if(!(ip->flags & I_VALID)){
  102031:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  102035:	74 09                	je     102040 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  102037:	83 c4 10             	add    $0x10,%esp
  10203a:	5b                   	pop    %ebx
  10203b:	5e                   	pop    %esi
  10203c:	5d                   	pop    %ebp
  10203d:	c3                   	ret    
  10203e:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  102040:	8b 43 04             	mov    0x4(%ebx),%eax
  102043:	c1 e8 03             	shr    $0x3,%eax
  102046:	83 c0 02             	add    $0x2,%eax
  102049:	89 44 24 04          	mov    %eax,0x4(%esp)
  10204d:	8b 03                	mov    (%ebx),%eax
  10204f:	89 04 24             	mov    %eax,(%esp)
  102052:	e8 d9 e0 ff ff       	call   100130 <bread>
  102057:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102059:	8b 43 04             	mov    0x4(%ebx),%eax
  10205c:	83 e0 07             	and    $0x7,%eax
  10205f:	c1 e0 06             	shl    $0x6,%eax
  102062:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  102066:	0f b7 10             	movzwl (%eax),%edx
  102069:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  10206d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102071:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  102075:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102079:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  10207d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102081:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  102085:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102088:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  10208b:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  10208e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102092:	8d 43 1c             	lea    0x1c(%ebx),%eax
  102095:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  10209c:	00 
  10209d:	89 04 24             	mov    %eax,(%esp)
  1020a0:	e8 0b 32 00 00       	call   1052b0 <memmove>
    brelse(bp);
  1020a5:	89 34 24             	mov    %esi,(%esp)
  1020a8:	e8 53 df ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  1020ad:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  1020b1:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  1020b6:	0f 85 7b ff ff ff    	jne    102037 <ilock+0x67>
      panic("ilock: no type");
  1020bc:	c7 04 24 c1 74 10 00 	movl   $0x1074c1,(%esp)
  1020c3:	e8 98 e8 ff ff       	call   100960 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  1020c8:	c7 04 24 bb 74 10 00 	movl   $0x1074bb,(%esp)
  1020cf:	e8 8c e8 ff ff       	call   100960 <panic>
  1020d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1020da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001020e0 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  1020e0:	55                   	push   %ebp
  1020e1:	89 e5                	mov    %esp,%ebp
  1020e3:	57                   	push   %edi
  1020e4:	56                   	push   %esi
  1020e5:	53                   	push   %ebx
  1020e6:	89 c3                	mov    %eax,%ebx
  1020e8:	83 ec 2c             	sub    $0x2c,%esp
  1020eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1020ee:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	//cprintf("Path: %s\n", path);
  struct inode *ip, *next;

  if(*path == '/')
  1020f1:	80 38 2f             	cmpb   $0x2f,(%eax)
  1020f4:	0f 84 14 01 00 00    	je     10220e <_namei+0x12e>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  1020fa:	e8 81 20 00 00       	call   104180 <curproc>
  1020ff:	8b 40 60             	mov    0x60(%eax),%eax
  102102:	89 04 24             	mov    %eax,(%esp)
  102105:	e8 86 f8 ff ff       	call   101990 <idup>
  10210a:	89 c7                	mov    %eax,%edi
  10210c:	eb 05                	jmp    102113 <_namei+0x33>
  10210e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  102110:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  102113:	0f b6 03             	movzbl (%ebx),%eax
  102116:	3c 2f                	cmp    $0x2f,%al
  102118:	74 f6                	je     102110 <_namei+0x30>
    path++;
  if(*path == 0)
  10211a:	84 c0                	test   %al,%al
  10211c:	75 1a                	jne    102138 <_namei+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  10211e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  102121:	85 c9                	test   %ecx,%ecx
  102123:	0f 85 12 01 00 00    	jne    10223b <_namei+0x15b>
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
  return ip;
}
  102129:	83 c4 2c             	add    $0x2c,%esp
  10212c:	89 f8                	mov    %edi,%eax
  10212e:	5b                   	pop    %ebx
  10212f:	5e                   	pop    %esi
  102130:	5f                   	pop    %edi
  102131:	5d                   	pop    %ebp
  102132:	c3                   	ret    
  102133:	90                   	nop
  102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  102138:	3c 2f                	cmp    $0x2f,%al
  10213a:	0f 84 94 00 00 00    	je     1021d4 <_namei+0xf4>
  102140:	89 de                	mov    %ebx,%esi
  102142:	eb 08                	jmp    10214c <_namei+0x6c>
  102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102148:	3c 2f                	cmp    $0x2f,%al
  10214a:	74 0a                	je     102156 <_namei+0x76>
    path++;
  10214c:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  10214f:	0f b6 06             	movzbl (%esi),%eax
  102152:	84 c0                	test   %al,%al
  102154:	75 f2                	jne    102148 <_namei+0x68>
  102156:	89 f2                	mov    %esi,%edx
  102158:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  10215a:	83 fa 0d             	cmp    $0xd,%edx
  10215d:	7e 79                	jle    1021d8 <_namei+0xf8>
    memmove(name, s, DIRSIZ);
  10215f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  102166:	00 
  102167:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10216b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10216e:	89 04 24             	mov    %eax,(%esp)
  102171:	e8 3a 31 00 00       	call   1052b0 <memmove>
  102176:	eb 03                	jmp    10217b <_namei+0x9b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  102178:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  10217b:	80 3e 2f             	cmpb   $0x2f,(%esi)
  10217e:	74 f8                	je     102178 <_namei+0x98>
  else
    ip = idup(cp->cwd);

  //cprintf("cp name: %s\n", cp->name);

  while((path = skipelem(path, name)) != 0){
  102180:	85 f6                	test   %esi,%esi
  102182:	74 9a                	je     10211e <_namei+0x3e>
    ilock(ip);
  102184:	89 3c 24             	mov    %edi,(%esp)
  102187:	e8 44 fe ff ff       	call   101fd0 <ilock>
    if(ip->type != T_DIR){
  10218c:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  102191:	75 67                	jne    1021fa <_namei+0x11a>
      iunlockput(ip);
      //cprintf("HERE\n");
      return 0;
    }
    if(parent && *path == '\0'){
  102193:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  102196:	85 db                	test   %ebx,%ebx
  102198:	74 0c                	je     1021a6 <_namei+0xc6>
  10219a:	80 3e 00             	cmpb   $0x0,(%esi)
  10219d:	8d 76 00             	lea    0x0(%esi),%esi
  1021a0:	0f 84 83 00 00 00    	je     102229 <_namei+0x149>
      // Stop one level early.
      iunlock(ip);
      //cprintf("HERE3\n");
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  1021a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1021ad:	00 
  1021ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1021b1:	89 3c 24             	mov    %edi,(%esp)
  1021b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1021b8:	e8 c3 f8 ff ff       	call   101a80 <dirlookup>
  1021bd:	85 c0                	test   %eax,%eax
  1021bf:	89 c3                	mov    %eax,%ebx
  1021c1:	74 37                	je     1021fa <_namei+0x11a>
      iunlockput(ip);
      //cprintf("HERE1\n");
      return 0;
    }
    iunlockput(ip);
  1021c3:	89 3c 24             	mov    %edi,(%esp)
  1021c6:	89 df                	mov    %ebx,%edi
  1021c8:	89 f3                	mov    %esi,%ebx
  1021ca:	e8 e1 fd ff ff       	call   101fb0 <iunlockput>
  1021cf:	e9 3f ff ff ff       	jmp    102113 <_namei+0x33>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  1021d4:	89 de                	mov    %ebx,%esi
  1021d6:	31 d2                	xor    %edx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  1021d8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1021dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1021e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1021e3:	89 04 24             	mov    %eax,(%esp)
  1021e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1021e9:	e8 c2 30 00 00       	call   1052b0 <memmove>
    name[len] = 0;
  1021ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1021f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1021f4:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  1021f8:	eb 81                	jmp    10217b <_namei+0x9b>
      iunlock(ip);
      //cprintf("HERE3\n");
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  1021fa:	89 3c 24             	mov    %edi,(%esp)
  1021fd:	31 ff                	xor    %edi,%edi
  1021ff:	e8 ac fd ff ff       	call   101fb0 <iunlockput>
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
  return ip;
}
  102204:	83 c4 2c             	add    $0x2c,%esp
  102207:	89 f8                	mov    %edi,%eax
  102209:	5b                   	pop    %ebx
  10220a:	5e                   	pop    %esi
  10220b:	5f                   	pop    %edi
  10220c:	5d                   	pop    %ebp
  10220d:	c3                   	ret    
{
	//cprintf("Path: %s\n", path);
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  10220e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102215:	00 
  102216:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10221d:	e8 9e f7 ff ff       	call   1019c0 <iget>
  102222:	89 c7                	mov    %eax,%edi
  102224:	e9 ea fe ff ff       	jmp    102113 <_namei+0x33>
      //cprintf("HERE\n");
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  102229:	89 3c 24             	mov    %edi,(%esp)
  10222c:	e8 2f fd ff ff       	call   101f60 <iunlock>
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
  return ip;
}
  102231:	83 c4 2c             	add    $0x2c,%esp
  102234:	89 f8                	mov    %edi,%eax
  102236:	5b                   	pop    %ebx
  102237:	5e                   	pop    %esi
  102238:	5f                   	pop    %edi
  102239:	5d                   	pop    %ebp
  10223a:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  10223b:	89 3c 24             	mov    %edi,(%esp)
  10223e:	31 ff                	xor    %edi,%edi
  102240:	e8 3b fa ff ff       	call   101c80 <iput>
    //cprintf("HERE2\n");
    return 0;
  102245:	e9 df fe ff ff       	jmp    102129 <_namei+0x49>
  10224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102250 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102250:	55                   	push   %ebp
  return _namei(path, 1, name);
  102251:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102256:	89 e5                	mov    %esp,%ebp
  102258:	83 ec 08             	sub    $0x8,%esp
  return _namei(path, 1, name);
  10225b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10225e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102261:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  102262:	e9 79 fe ff ff       	jmp    1020e0 <_namei>
  102267:	89 f6                	mov    %esi,%esi
  102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102270 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102270:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102271:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102273:	89 e5                	mov    %esp,%ebp
  102275:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102278:	8b 45 08             	mov    0x8(%ebp),%eax
  10227b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  10227e:	e8 5d fe ff ff       	call   1020e0 <_namei>
}
  102283:	c9                   	leave  
  102284:	c3                   	ret    
  102285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102290 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102290:	55                   	push   %ebp
  102291:	89 e5                	mov    %esp,%ebp
  102293:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache.lock");
  102296:	c7 44 24 04 d0 74 10 	movl   $0x1074d0,0x4(%esp)
  10229d:	00 
  10229e:	c7 04 24 60 bf 10 00 	movl   $0x10bf60,(%esp)
  1022a5:	e8 46 2d 00 00       	call   104ff0 <initlock>
}
  1022aa:	c9                   	leave  
  1022ab:	c3                   	ret    
  1022ac:	90                   	nop
  1022ad:	90                   	nop
  1022ae:	90                   	nop
  1022af:	90                   	nop

001022b0 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  1022b0:	55                   	push   %ebp
  1022b1:	89 c1                	mov    %eax,%ecx
  1022b3:	89 e5                	mov    %esp,%ebp
  1022b5:	56                   	push   %esi
  1022b6:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  1022b9:	85 c0                	test   %eax,%eax
  1022bb:	0f 84 89 00 00 00    	je     10234a <ide_start_request+0x9a>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1022c1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022c6:	66 90                	xchg   %ax,%ax
  1022c8:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  1022c9:	0f b6 c0             	movzbl %al,%eax
  1022cc:	84 c0                	test   %al,%al
  1022ce:	78 f8                	js     1022c8 <ide_start_request+0x18>
  1022d0:	a8 40                	test   $0x40,%al
  1022d2:	74 f4                	je     1022c8 <ide_start_request+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1022d4:	ba f6 03 00 00       	mov    $0x3f6,%edx
  1022d9:	31 c0                	xor    %eax,%eax
  1022db:	ee                   	out    %al,(%dx)
  1022dc:	ba f2 01 00 00       	mov    $0x1f2,%edx
  1022e1:	b8 01 00 00 00       	mov    $0x1,%eax
  1022e6:	ee                   	out    %al,(%dx)
    panic("ide_start_request");

  ide_wait_ready(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  1022e7:	8b 71 08             	mov    0x8(%ecx),%esi
  1022ea:	b2 f3                	mov    $0xf3,%dl
  1022ec:	89 f0                	mov    %esi,%eax
  1022ee:	ee                   	out    %al,(%dx)
  1022ef:	89 f0                	mov    %esi,%eax
  1022f1:	b2 f4                	mov    $0xf4,%dl
  1022f3:	c1 e8 08             	shr    $0x8,%eax
  1022f6:	ee                   	out    %al,(%dx)
  1022f7:	89 f0                	mov    %esi,%eax
  1022f9:	b2 f5                	mov    $0xf5,%dl
  1022fb:	c1 e8 10             	shr    $0x10,%eax
  1022fe:	ee                   	out    %al,(%dx)
  1022ff:	8b 41 04             	mov    0x4(%ecx),%eax
  102302:	c1 ee 18             	shr    $0x18,%esi
  102305:	b2 f6                	mov    $0xf6,%dl
  102307:	83 e6 0f             	and    $0xf,%esi
  10230a:	83 e0 01             	and    $0x1,%eax
  10230d:	c1 e0 04             	shl    $0x4,%eax
  102310:	09 f0                	or     %esi,%eax
  102312:	83 c8 e0             	or     $0xffffffe0,%eax
  102315:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  102316:	f6 01 04             	testb  $0x4,(%ecx)
  102319:	75 11                	jne    10232c <ide_start_request+0x7c>
  10231b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102320:	b8 20 00 00 00       	mov    $0x20,%eax
  102325:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  102326:	83 c4 14             	add    $0x14,%esp
  102329:	5e                   	pop    %esi
  10232a:	5d                   	pop    %ebp
  10232b:	c3                   	ret    
  10232c:	b2 f7                	mov    $0xf7,%dl
  10232e:	b8 30 00 00 00       	mov    $0x30,%eax
  102333:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  102334:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102339:	8d 71 18             	lea    0x18(%ecx),%esi
  10233c:	b9 80 00 00 00       	mov    $0x80,%ecx
  102341:	fc                   	cld    
  102342:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  102344:	83 c4 14             	add    $0x14,%esp
  102347:	5e                   	pop    %esi
  102348:	5d                   	pop    %ebp
  102349:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  10234a:	c7 04 24 dc 74 10 00 	movl   $0x1074dc,(%esp)
  102351:	e8 0a e6 ff ff       	call   100960 <panic>
  102356:	8d 76 00             	lea    0x0(%esi),%esi
  102359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102360 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102360:	55                   	push   %ebp
  102361:	89 e5                	mov    %esp,%ebp
  102363:	53                   	push   %ebx
  102364:	83 ec 14             	sub    $0x14,%esp
  102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10236a:	8b 03                	mov    (%ebx),%eax
  10236c:	a8 01                	test   $0x1,%al
  10236e:	0f 84 90 00 00 00    	je     102404 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102374:	83 e0 06             	and    $0x6,%eax
  102377:	83 f8 02             	cmp    $0x2,%eax
  10237a:	0f 84 9c 00 00 00    	je     10241c <ide_rw+0xbc>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102380:	8b 53 04             	mov    0x4(%ebx),%edx
  102383:	85 d2                	test   %edx,%edx
  102385:	74 0d                	je     102394 <ide_rw+0x34>
  102387:	a1 38 88 10 00       	mov    0x108838,%eax
  10238c:	85 c0                	test   %eax,%eax
  10238e:	0f 84 7c 00 00 00    	je     102410 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102394:	c7 04 24 00 88 10 00 	movl   $0x108800,(%esp)
  10239b:	e8 10 2e 00 00       	call   1051b0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  1023a0:	a1 34 88 10 00       	mov    0x108834,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  1023a5:	ba 34 88 10 00       	mov    $0x108834,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  1023aa:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  1023b1:	85 c0                	test   %eax,%eax
  1023b3:	74 0d                	je     1023c2 <ide_rw+0x62>
  1023b5:	8d 76 00             	lea    0x0(%esi),%esi
  1023b8:	8d 50 14             	lea    0x14(%eax),%edx
  1023bb:	8b 40 14             	mov    0x14(%eax),%eax
  1023be:	85 c0                	test   %eax,%eax
  1023c0:	75 f6                	jne    1023b8 <ide_rw+0x58>
    ;
  *pp = b;
  1023c2:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  1023c4:	39 1d 34 88 10 00    	cmp    %ebx,0x108834
  1023ca:	75 14                	jne    1023e0 <ide_rw+0x80>
  1023cc:	eb 2d                	jmp    1023fb <ide_rw+0x9b>
  1023ce:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  1023d0:	c7 44 24 04 00 88 10 	movl   $0x108800,0x4(%esp)
  1023d7:	00 
  1023d8:	89 1c 24             	mov    %ebx,(%esp)
  1023db:	e8 50 20 00 00       	call   104430 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1023e0:	8b 03                	mov    (%ebx),%eax
  1023e2:	83 e0 06             	and    $0x6,%eax
  1023e5:	83 f8 02             	cmp    $0x2,%eax
  1023e8:	75 e6                	jne    1023d0 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  1023ea:	c7 45 08 00 88 10 00 	movl   $0x108800,0x8(%ebp)
}
  1023f1:	83 c4 14             	add    $0x14,%esp
  1023f4:	5b                   	pop    %ebx
  1023f5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  1023f6:	e9 75 2d 00 00       	jmp    105170 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  1023fb:	89 d8                	mov    %ebx,%eax
  1023fd:	e8 ae fe ff ff       	call   1022b0 <ide_start_request>
  102402:	eb dc                	jmp    1023e0 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  102404:	c7 04 24 ee 74 10 00 	movl   $0x1074ee,(%esp)
  10240b:	e8 50 e5 ff ff       	call   100960 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  102410:	c7 04 24 19 75 10 00 	movl   $0x107519,(%esp)
  102417:	e8 44 e5 ff ff       	call   100960 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  10241c:	c7 04 24 03 75 10 00 	movl   $0x107503,(%esp)
  102423:	e8 38 e5 ff ff       	call   100960 <panic>
  102428:	90                   	nop
  102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102430 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  102430:	55                   	push   %ebp
  102431:	89 e5                	mov    %esp,%ebp
  102433:	57                   	push   %edi
  102434:	53                   	push   %ebx
  102435:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  102438:	c7 04 24 00 88 10 00 	movl   $0x108800,(%esp)
  10243f:	e8 6c 2d 00 00       	call   1051b0 <acquire>
  if((b = ide_queue) == 0){
  102444:	8b 1d 34 88 10 00    	mov    0x108834,%ebx
  10244a:	85 db                	test   %ebx,%ebx
  10244c:	74 28                	je     102476 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  10244e:	8b 0b                	mov    (%ebx),%ecx
  102450:	f6 c1 04             	test   $0x4,%cl
  102453:	74 3b                	je     102490 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  102455:	83 c9 02             	or     $0x2,%ecx
  102458:	83 e1 fb             	and    $0xfffffffb,%ecx
  10245b:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  10245d:	89 1c 24             	mov    %ebx,(%esp)
  102460:	e8 1b 1c 00 00       	call   104080 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102465:	8b 43 14             	mov    0x14(%ebx),%eax
  102468:	85 c0                	test   %eax,%eax
  10246a:	a3 34 88 10 00       	mov    %eax,0x108834
  10246f:	74 05                	je     102476 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102471:	e8 3a fe ff ff       	call   1022b0 <ide_start_request>

  release(&ide_lock);
  102476:	c7 04 24 00 88 10 00 	movl   $0x108800,(%esp)
  10247d:	e8 ee 2c 00 00       	call   105170 <release>
}
  102482:	83 c4 10             	add    $0x10,%esp
  102485:	5b                   	pop    %ebx
  102486:	5f                   	pop    %edi
  102487:	5d                   	pop    %ebp
  102488:	c3                   	ret    
  102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102490:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102495:	8d 76 00             	lea    0x0(%esi),%esi
  102498:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102499:	0f b6 c0             	movzbl %al,%eax
  10249c:	84 c0                	test   %al,%al
  10249e:	78 f8                	js     102498 <ide_intr+0x68>
  1024a0:	a8 40                	test   $0x40,%al
  1024a2:	74 f4                	je     102498 <ide_intr+0x68>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  1024a4:	a8 21                	test   $0x21,%al
  1024a6:	75 ad                	jne    102455 <ide_intr+0x25>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  1024a8:	8d 7b 18             	lea    0x18(%ebx),%edi
  1024ab:	b9 80 00 00 00       	mov    $0x80,%ecx
  1024b0:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1024b5:	fc                   	cld    
  1024b6:	f2 6d                	repnz insl (%dx),%es:(%edi)
  1024b8:	8b 0b                	mov    (%ebx),%ecx
  1024ba:	eb 99                	jmp    102455 <ide_intr+0x25>
  1024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001024c0 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  1024c0:	55                   	push   %ebp
  1024c1:	89 e5                	mov    %esp,%ebp
  1024c3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&ide_lock, "ide");
  1024c6:	c7 44 24 04 30 75 10 	movl   $0x107530,0x4(%esp)
  1024cd:	00 
  1024ce:	c7 04 24 00 88 10 00 	movl   $0x108800,(%esp)
  1024d5:	e8 16 2b 00 00       	call   104ff0 <initlock>
  pic_enable(IRQ_IDE);
  1024da:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1024e1:	e8 aa 15 00 00       	call   103a90 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  1024e6:	a1 60 d6 10 00       	mov    0x10d660,%eax
  1024eb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1024f2:	83 e8 01             	sub    $0x1,%eax
  1024f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1024f9:	e8 52 00 00 00       	call   102550 <ioapic_enable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1024fe:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102503:	90                   	nop
  102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102508:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102509:	0f b6 c0             	movzbl %al,%eax
  10250c:	84 c0                	test   %al,%al
  10250e:	78 f8                	js     102508 <ide_init+0x48>
  102510:	a8 40                	test   $0x40,%al
  102512:	74 f4                	je     102508 <ide_init+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102514:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102519:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10251e:	ee                   	out    %al,(%dx)
  10251f:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102521:	b2 f7                	mov    $0xf7,%dl
  102523:	eb 0e                	jmp    102533 <ide_init+0x73>
  102525:	8d 76 00             	lea    0x0(%esi),%esi
  ioapic_enable(IRQ_IDE, ncpu - 1);
  ide_wait_ready(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  102528:	83 c1 01             	add    $0x1,%ecx
  10252b:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  102531:	74 0f                	je     102542 <ide_init+0x82>
  102533:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  102534:	84 c0                	test   %al,%al
  102536:	74 f0                	je     102528 <ide_init+0x68>
      disk_1_present = 1;
  102538:	c7 05 38 88 10 00 01 	movl   $0x1,0x108838
  10253f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102542:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102547:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  10254c:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10254d:	c9                   	leave  
  10254e:	c3                   	ret    
  10254f:	90                   	nop

00102550 <ioapic_enable>:
}

void
ioapic_enable(int irq, int cpunum)
{
  if(!ismp)
  102550:	8b 15 e0 cf 10 00    	mov    0x10cfe0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102556:	55                   	push   %ebp
  102557:	89 e5                	mov    %esp,%ebp
  102559:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  10255c:	85 d2                	test   %edx,%edx
  10255e:	74 1f                	je     10257f <ioapic_enable+0x2f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102560:	8d 48 20             	lea    0x20(%eax),%ecx
  102563:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102567:	a1 34 cf 10 00       	mov    0x10cf34,%eax
  10256c:	89 10                	mov    %edx,(%eax)
  10256e:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  102571:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102577:	89 10                	mov    %edx,(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102579:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  10257c:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10257f:	5d                   	pop    %ebp
  102580:	c3                   	ret    
  102581:	eb 0d                	jmp    102590 <ioapic_init>
  102583:	90                   	nop
  102584:	90                   	nop
  102585:	90                   	nop
  102586:	90                   	nop
  102587:	90                   	nop
  102588:	90                   	nop
  102589:	90                   	nop
  10258a:	90                   	nop
  10258b:	90                   	nop
  10258c:	90                   	nop
  10258d:	90                   	nop
  10258e:	90                   	nop
  10258f:	90                   	nop

00102590 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102590:	55                   	push   %ebp
  102591:	89 e5                	mov    %esp,%ebp
  102593:	56                   	push   %esi
  102594:	53                   	push   %ebx
  102595:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102598:	8b 0d e0 cf 10 00    	mov    0x10cfe0,%ecx
  10259e:	85 c9                	test   %ecx,%ecx
  1025a0:	0f 84 86 00 00 00    	je     10262c <ioapic_init+0x9c>
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1025a6:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  1025ad:	00 00 00 
  return ioapic->data;
  1025b0:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1025b6:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1025bb:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  1025c2:	00 00 00 
  return ioapic->data;
  1025c5:	8b 15 10 00 c0 fe    	mov    0xfec00010,%edx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1025cb:	0f b6 0d e4 cf 10 00 	movzbl 0x10cfe4,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1025d2:	c7 05 34 cf 10 00 00 	movl   $0xfec00000,0x10cf34
  1025d9:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1025dc:	c1 ee 10             	shr    $0x10,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1025df:	c1 ea 18             	shr    $0x18,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1025e2:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1025e8:	39 d1                	cmp    %edx,%ecx
  1025ea:	74 11                	je     1025fd <ioapic_init+0x6d>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1025ec:	c7 04 24 34 75 10 00 	movl   $0x107534,(%esp)
  1025f3:	e8 c8 e1 ff ff       	call   1007c0 <cprintf>
  1025f8:	a1 34 cf 10 00       	mov    0x10cf34,%eax
  1025fd:	b9 10 00 00 00       	mov    $0x10,%ecx
  102602:	31 d2                	xor    %edx,%edx
  102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  102608:	8d 5a 20             	lea    0x20(%edx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10260b:	83 c2 01             	add    $0x1,%edx
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  10260e:	81 cb 00 00 01 00    	or     $0x10000,%ebx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102614:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  102616:	89 58 10             	mov    %ebx,0x10(%eax)
  102619:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10261c:	83 c1 02             	add    $0x2,%ecx
  10261f:	39 d6                	cmp    %edx,%esi
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102621:	89 18                	mov    %ebx,(%eax)
  ioapic->data = data;
  102623:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10262a:	7d dc                	jge    102608 <ioapic_init+0x78>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  10262c:	83 c4 10             	add    $0x10,%esp
  10262f:	5b                   	pop    %ebx
  102630:	5e                   	pop    %esi
  102631:	5d                   	pop    %ebp
  102632:	c3                   	ret    
  102633:	90                   	nop
  102634:	90                   	nop
  102635:	90                   	nop
  102636:	90                   	nop
  102637:	90                   	nop
  102638:	90                   	nop
  102639:	90                   	nop
  10263a:	90                   	nop
  10263b:	90                   	nop
  10263c:	90                   	nop
  10263d:	90                   	nop
  10263e:	90                   	nop
  10263f:	90                   	nop

00102640 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  102640:	55                   	push   %ebp
  102641:	89 e5                	mov    %esp,%ebp
  102643:	56                   	push   %esi
  102644:	53                   	push   %ebx
  102645:	83 ec 10             	sub    $0x10,%esp
  102648:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  10264b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102651:	0f 85 a2 00 00 00    	jne    1026f9 <kalloc+0xb9>
  102657:	85 f6                	test   %esi,%esi
  102659:	0f 8e 9a 00 00 00    	jle    1026f9 <kalloc+0xb9>
    panic("kalloc");

  acquire(&kalloc_lock);
  10265f:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  102666:	e8 45 2b 00 00       	call   1051b0 <acquire>
  10266b:	8b 1d 74 cf 10 00    	mov    0x10cf74,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102671:	85 db                	test   %ebx,%ebx
  102673:	74 43                	je     1026b8 <kalloc+0x78>
    if(r->len == n){
  102675:	8b 43 04             	mov    0x4(%ebx),%eax
  102678:	ba 74 cf 10 00       	mov    $0x10cf74,%edx
  10267d:	39 f0                	cmp    %esi,%eax
  10267f:	75 16                	jne    102697 <kalloc+0x57>
  102681:	eb 5d                	jmp    1026e0 <kalloc+0xa0>
  102683:	90                   	nop
  102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102688:	89 da                	mov    %ebx,%edx
  10268a:	8b 1b                	mov    (%ebx),%ebx
  10268c:	85 db                	test   %ebx,%ebx
  10268e:	74 28                	je     1026b8 <kalloc+0x78>
    if(r->len == n){
  102690:	8b 43 04             	mov    0x4(%ebx),%eax
  102693:	39 f0                	cmp    %esi,%eax
  102695:	74 49                	je     1026e0 <kalloc+0xa0>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102697:	39 c6                	cmp    %eax,%esi
  102699:	7d ed                	jge    102688 <kalloc+0x48>
      r->len -= n;
  10269b:	29 f0                	sub    %esi,%eax
  10269d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  1026a0:	01 c3                	add    %eax,%ebx
      release(&kalloc_lock);
  1026a2:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  1026a9:	e8 c2 2a 00 00       	call   105170 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  1026ae:	83 c4 10             	add    $0x10,%esp
  1026b1:	89 d8                	mov    %ebx,%eax
  1026b3:	5b                   	pop    %ebx
  1026b4:	5e                   	pop    %esi
  1026b5:	5d                   	pop    %ebp
  1026b6:	c3                   	ret    
  1026b7:	90                   	nop
      return p;
    }
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  1026b8:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  1026ba:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  1026c1:	e8 aa 2a 00 00       	call   105170 <release>

  cprintf("kalloc: out of memory\n");
  1026c6:	c7 04 24 6f 75 10 00 	movl   $0x10756f,(%esp)
  1026cd:	e8 ee e0 ff ff       	call   1007c0 <cprintf>
  return 0;
}
  1026d2:	83 c4 10             	add    $0x10,%esp
  1026d5:	89 d8                	mov    %ebx,%eax
  1026d7:	5b                   	pop    %ebx
  1026d8:	5e                   	pop    %esi
  1026d9:	5d                   	pop    %ebp
  1026da:	c3                   	ret    
  1026db:	90                   	nop
  1026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  1026e0:	8b 03                	mov    (%ebx),%eax
  1026e2:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  1026e4:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  1026eb:	e8 80 2a 00 00       	call   105170 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  1026f0:	83 c4 10             	add    $0x10,%esp
  1026f3:	89 d8                	mov    %ebx,%eax
  1026f5:	5b                   	pop    %ebx
  1026f6:	5e                   	pop    %esi
  1026f7:	5d                   	pop    %ebp
  1026f8:	c3                   	ret    
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
    panic("kalloc");
  1026f9:	c7 04 24 68 75 10 00 	movl   $0x107568,(%esp)
  102700:	e8 5b e2 ff ff       	call   100960 <panic>
  102705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102710 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102710:	55                   	push   %ebp
  102711:	89 e5                	mov    %esp,%ebp
  102713:	57                   	push   %edi
  102714:	56                   	push   %esi
  102715:	53                   	push   %ebx
  102716:	83 ec 2c             	sub    $0x2c,%esp
  102719:	8b 45 0c             	mov    0xc(%ebp),%eax
  10271c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10271f:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102721:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  102724:	0f 8e ec 00 00 00    	jle    102816 <kfree+0x106>
  10272a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  10272f:	0f 85 e1 00 00 00    	jne    102816 <kfree+0x106>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  102735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102738:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10273f:	00 
  102740:	89 1c 24             	mov    %ebx,(%esp)
  102743:	89 54 24 08          	mov    %edx,0x8(%esp)
  102747:	e8 d4 2a 00 00       	call   105220 <memset>

  acquire(&kalloc_lock);
  10274c:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  102753:	e8 58 2a 00 00       	call   1051b0 <acquire>
  p = (struct run*)v;
  102758:	a1 74 cf 10 00       	mov    0x10cf74,%eax
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  10275d:	85 c0                	test   %eax,%eax
  10275f:	74 63                	je     1027c4 <kfree+0xb4>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  102761:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102764:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102767:	39 c1                	cmp    %eax,%ecx
  102769:	72 59                	jb     1027c4 <kfree+0xb4>
    rend = (struct run*)((char*)r + r->len);
  10276b:	8b 70 04             	mov    0x4(%eax),%esi
  10276e:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102771:	39 d3                	cmp    %edx,%ebx
  102773:	0f 82 a9 00 00 00    	jb     102822 <kfree+0x112>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102779:	39 c1                	cmp    %eax,%ecx
  10277b:	75 27                	jne    1027a4 <kfree+0x94>
  10277d:	8d 76 00             	lea    0x0(%esi),%esi
  102780:	eb 6b                	jmp    1027ed <kfree+0xdd>
  102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102788:	89 c7                	mov    %eax,%edi
  10278a:	8b 00                	mov    (%eax),%eax
  10278c:	85 c0                	test   %eax,%eax
  10278e:	66 90                	xchg   %ax,%ax
  102790:	74 3e                	je     1027d0 <kfree+0xc0>
  102792:	39 c1                	cmp    %eax,%ecx
  102794:	72 3a                	jb     1027d0 <kfree+0xc0>
    rend = (struct run*)((char*)r + r->len);
  102796:	8b 70 04             	mov    0x4(%eax),%esi
  102799:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  10279c:	39 d3                	cmp    %edx,%ebx
  10279e:	72 66                	jb     102806 <kfree+0xf6>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1027a0:	39 c1                	cmp    %eax,%ecx
  1027a2:	74 54                	je     1027f8 <kfree+0xe8>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  1027a4:	39 da                	cmp    %ebx,%edx
  1027a6:	75 e0                	jne    102788 <kfree+0x78>
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  1027a8:	8b 10                	mov    (%eax),%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  1027aa:	03 75 e4             	add    -0x1c(%ebp),%esi
      if(r->next && r->next == pend){  // r now next to r->next?
  1027ad:	85 d2                	test   %edx,%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  1027af:	89 70 04             	mov    %esi,0x4(%eax)
      if(r->next && r->next == pend){  // r now next to r->next?
  1027b2:	74 26                	je     1027da <kfree+0xca>
  1027b4:	39 d1                	cmp    %edx,%ecx
  1027b6:	75 22                	jne    1027da <kfree+0xca>
        r->len += r->next->len;
        r->next = r->next->next;
  1027b8:	8b 11                	mov    (%ecx),%edx
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  1027ba:	03 71 04             	add    0x4(%ecx),%esi
        r->next = r->next->next;
  1027bd:	89 10                	mov    %edx,(%eax)
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  1027bf:	89 70 04             	mov    %esi,0x4(%eax)
  1027c2:	eb 16                	jmp    1027da <kfree+0xca>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1027c4:	bf 74 cf 10 00       	mov    $0x10cf74,%edi
  1027c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  1027d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->next = r;
  1027d3:	89 03                	mov    %eax,(%ebx)
  *rp = p;
  1027d5:	89 1f                	mov    %ebx,(%edi)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  1027d7:	89 53 04             	mov    %edx,0x4(%ebx)
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  1027da:	c7 45 08 40 cf 10 00 	movl   $0x10cf40,0x8(%ebp)
}
  1027e1:	83 c4 2c             	add    $0x2c,%esp
  1027e4:	5b                   	pop    %ebx
  1027e5:	5e                   	pop    %esi
  1027e6:	5f                   	pop    %edi
  1027e7:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  1027e8:	e9 83 29 00 00       	jmp    105170 <release>
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1027ed:	bf 74 cf 10 00       	mov    $0x10cf74,%edi
  1027f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->len = len + r->len;
      p->next = r->next;
  1027f8:	8b 01                	mov    (%ecx),%eax
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  1027fa:	03 75 e4             	add    -0x1c(%ebp),%esi
      p->next = r->next;
  1027fd:	89 03                	mov    %eax,(%ebx)
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  1027ff:	89 73 04             	mov    %esi,0x4(%ebx)
      p->next = r->next;
      *rp = p;
  102802:	89 1f                	mov    %ebx,(%edi)
      goto out;
  102804:	eb d4                	jmp    1027da <kfree+0xca>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102806:	39 c3                	cmp    %eax,%ebx
  102808:	72 96                	jb     1027a0 <kfree+0x90>
      panic("freeing free page");
  10280a:	c7 04 24 8c 75 10 00 	movl   $0x10758c,(%esp)
  102811:	e8 4a e1 ff ff       	call   100960 <panic>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  102816:	c7 04 24 86 75 10 00 	movl   $0x107586,(%esp)
  10281d:	e8 3e e1 ff ff       	call   100960 <panic>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102822:	39 c3                	cmp    %eax,%ebx
  102824:	0f 82 4f ff ff ff    	jb     102779 <kfree+0x69>
  10282a:	eb de                	jmp    10280a <kfree+0xfa>
  10282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102830 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102830:	55                   	push   %ebp
  102831:	89 e5                	mov    %esp,%ebp
  102833:	83 ec 18             	sub    $0x18,%esp
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  102836:	c7 44 24 04 68 75 10 	movl   $0x107568,0x4(%esp)
  10283d:	00 
  10283e:	c7 04 24 40 cf 10 00 	movl   $0x10cf40,(%esp)
  102845:	e8 a6 27 00 00       	call   104ff0 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  10284a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  102851:	00 
  102852:	c7 04 24 9e 75 10 00 	movl   $0x10759e,(%esp)
  102859:	e8 62 df ff ff       	call   1007c0 <cprintf>
  kfree(start, mem * PAGE);
  10285e:	b8 04 16 11 00       	mov    $0x111604,%eax
  102863:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102868:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10286f:	00 
  102870:	89 04 24             	mov    %eax,(%esp)
  102873:	e8 98 fe ff ff       	call   102710 <kfree>
}
  102878:	c9                   	leave  
  102879:	c3                   	ret    
  10287a:	90                   	nop
  10287b:	90                   	nop
  10287c:	90                   	nop
  10287d:	90                   	nop
  10287e:	90                   	nop
  10287f:	90                   	nop

00102880 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102880:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102881:	ba 64 00 00 00       	mov    $0x64,%edx
  102886:	89 e5                	mov    %esp,%ebp
  102888:	ec                   	in     (%dx),%al
  102889:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  10288b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102890:	83 e2 01             	and    $0x1,%edx
  102893:	74 3e                	je     1028d3 <kbd_getc+0x53>
  102895:	ba 60 00 00 00       	mov    $0x60,%edx
  10289a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  10289b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  10289e:	3d e0 00 00 00       	cmp    $0xe0,%eax
  1028a3:	0f 84 7f 00 00 00    	je     102928 <kbd_getc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  1028a9:	84 c0                	test   %al,%al
  1028ab:	79 2b                	jns    1028d8 <kbd_getc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  1028ad:	8b 15 3c 88 10 00    	mov    0x10883c,%edx
  1028b3:	f6 c2 40             	test   $0x40,%dl
  1028b6:	75 03                	jne    1028bb <kbd_getc+0x3b>
  1028b8:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  1028bb:	0f b6 80 c0 75 10 00 	movzbl 0x1075c0(%eax),%eax
  1028c2:	83 c8 40             	or     $0x40,%eax
  1028c5:	0f b6 c0             	movzbl %al,%eax
  1028c8:	f7 d0                	not    %eax
  1028ca:	21 d0                	and    %edx,%eax
  1028cc:	a3 3c 88 10 00       	mov    %eax,0x10883c
  1028d1:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1028d3:	5d                   	pop    %ebp
  1028d4:	c3                   	ret    
  1028d5:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  1028d8:	8b 0d 3c 88 10 00    	mov    0x10883c,%ecx
  1028de:	f6 c1 40             	test   $0x40,%cl
  1028e1:	74 05                	je     1028e8 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1028e3:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  1028e5:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1028e8:	0f b6 90 c0 75 10 00 	movzbl 0x1075c0(%eax),%edx
  1028ef:	09 ca                	or     %ecx,%edx
  1028f1:	0f b6 88 c0 76 10 00 	movzbl 0x1076c0(%eax),%ecx
  1028f8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  1028fa:	89 d1                	mov    %edx,%ecx
  1028fc:	83 e1 03             	and    $0x3,%ecx
  1028ff:	8b 0c 8d c0 77 10 00 	mov    0x1077c0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102906:	89 15 3c 88 10 00    	mov    %edx,0x10883c
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  10290c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10290f:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  102913:	74 be                	je     1028d3 <kbd_getc+0x53>
    if('a' <= c && c <= 'z')
  102915:	8d 50 9f             	lea    -0x61(%eax),%edx
  102918:	83 fa 19             	cmp    $0x19,%edx
  10291b:	77 1b                	ja     102938 <kbd_getc+0xb8>
      c += 'A' - 'a';
  10291d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102920:	5d                   	pop    %ebp
  102921:	c3                   	ret    
  102922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102928:	30 c0                	xor    %al,%al
  10292a:	83 0d 3c 88 10 00 40 	orl    $0x40,0x10883c
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102931:	5d                   	pop    %ebp
  102932:	c3                   	ret    
  102933:	90                   	nop
  102934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  102938:	8d 50 bf             	lea    -0x41(%eax),%edx
  10293b:	83 fa 19             	cmp    $0x19,%edx
  10293e:	77 93                	ja     1028d3 <kbd_getc+0x53>
      c += 'a' - 'A';
  102940:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  102943:	5d                   	pop    %ebp
  102944:	c3                   	ret    
  102945:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102950 <kbd_intr>:

void
kbd_intr(void)
{
  102950:	55                   	push   %ebp
  102951:	89 e5                	mov    %esp,%ebp
  102953:	83 ec 18             	sub    $0x18,%esp
  console_intr(kbd_getc);
  102956:	c7 04 24 80 28 10 00 	movl   $0x102880,(%esp)
  10295d:	e8 0e dc ff ff       	call   100570 <console_intr>
}
  102962:	c9                   	leave  
  102963:	c3                   	ret    
  102964:	90                   	nop
  102965:	90                   	nop
  102966:	90                   	nop
  102967:	90                   	nop
  102968:	90                   	nop
  102969:	90                   	nop
  10296a:	90                   	nop
  10296b:	90                   	nop
  10296c:	90                   	nop
  10296d:	90                   	nop
  10296e:	90                   	nop
  10296f:	90                   	nop

00102970 <lapic_init>:
}

void
lapic_init(int c)
{
  if(!lapic) 
  102970:	a1 78 cf 10 00       	mov    0x10cf78,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  102975:	55                   	push   %ebp
  102976:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  102978:	85 c0                	test   %eax,%eax
  10297a:	0f 84 c4 00 00 00    	je     102a44 <lapic_init+0xd4>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102980:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  102987:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10298a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10298d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  102994:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102997:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10299a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1029a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  1029a4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  1029ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  1029b1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  1029bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1029be:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  1029c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1029cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  1029ce:	8b 50 30             	mov    0x30(%eax),%edx
  1029d1:	c1 ea 10             	shr    $0x10,%edx
  1029d4:	80 fa 03             	cmp    $0x3,%dl
  1029d7:	77 6f                	ja     102a48 <lapic_init+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  1029e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029e3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029e6:	8d 88 00 03 00 00    	lea    0x300(%eax),%ecx
  1029ec:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1029f3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029f6:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029f9:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102a00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a03:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a06:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102a0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a10:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a13:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  102a1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a1d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a20:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  102a27:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  102a2a:	8b 50 20             	mov    0x20(%eax),%edx
  102a2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  102a30:	8b 11                	mov    (%ecx),%edx
  102a32:	80 e6 10             	and    $0x10,%dh
  102a35:	75 f9                	jne    102a30 <lapic_init+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a37:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  102a3e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a41:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  102a44:	5d                   	pop    %ebp
  102a45:	c3                   	ret    
  102a46:	66 90                	xchg   %ax,%ax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a48:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  102a4f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102a52:	8b 50 20             	mov    0x20(%eax),%edx
  102a55:	eb 82                	jmp    1029d9 <lapic_init+0x69>
  102a57:	89 f6                	mov    %esi,%esi
  102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102a60 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  102a60:	a1 78 cf 10 00       	mov    0x10cf78,%eax
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102a68:	85 c0                	test   %eax,%eax
  102a6a:	74 0d                	je     102a79 <lapic_eoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a6c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102a73:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a76:	8b 40 20             	mov    0x20(%eax),%eax
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  102a79:	5d                   	pop    %ebp
  102a7a:	c3                   	ret    
  102a7b:	90                   	nop
  102a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102a80 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  102a80:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102a81:	ba 70 00 00 00       	mov    $0x70,%edx
  102a86:	89 e5                	mov    %esp,%ebp
  102a88:	b8 0f 00 00 00       	mov    $0xf,%eax
  102a8d:	57                   	push   %edi
  102a8e:	56                   	push   %esi
  102a8f:	53                   	push   %ebx
  102a90:	83 ec 18             	sub    $0x18,%esp
  102a93:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  102a97:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  102a9a:	ee                   	out    %al,(%dx)
  102a9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  102aa0:	b2 71                	mov    $0x71,%dl
  102aa2:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102aa3:	8b 15 78 cf 10 00    	mov    0x10cf78,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102aa9:	89 d8                	mov    %ebx,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102aab:	89 cf                	mov    %ecx,%edi
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102aad:	c1 e8 04             	shr    $0x4,%eax
  102ab0:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102ab6:	c1 e7 18             	shl    $0x18,%edi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102ab9:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102ac0:	00 00 
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102ac2:	8d 82 10 03 00 00    	lea    0x310(%edx),%eax
  102ac8:	89 ba 10 03 00 00    	mov    %edi,0x310(%edx)
  lapic[ID];  // wait for write to finish, by reading
  102ace:	8d 72 20             	lea    0x20(%edx),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102ad4:	8b 42 20             	mov    0x20(%edx),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102ad7:	8d 82 00 03 00 00    	lea    0x300(%edx),%eax
  102add:	c7 82 00 03 00 00 00 	movl   $0xc500,0x300(%edx)
  102ae4:	c5 00 00 
  102ae7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102aea:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102aed:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102af2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102af9:	eb 0c                	jmp    102b07 <lapic_startap+0x87>
  102afb:	90                   	nop
  102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102b00:	85 c0                	test   %eax,%eax
  102b02:	74 2d                	je     102b31 <lapic_startap+0xb1>
  102b04:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102b07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b11:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102b17:	7f e7                	jg     102b00 <lapic_startap+0x80>
  102b19:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b1c:	83 c1 01             	add    $0x1,%ecx
  102b1f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  102b22:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102b25:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102b2b:	7e ec                	jle    102b19 <lapic_startap+0x99>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102b2d:	85 c0                	test   %eax,%eax
  102b2f:	75 d3                	jne    102b04 <lapic_startap+0x84>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102b31:	c7 82 00 03 00 00 00 	movl   $0x8500,0x300(%edx)
  102b38:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102b3b:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102b3e:	b8 63 00 00 00       	mov    $0x63,%eax
  102b43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b4a:	eb 0b                	jmp    102b57 <lapic_startap+0xd7>
  102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102b50:	85 c0                	test   %eax,%eax
  102b52:	74 2d                	je     102b81 <lapic_startap+0x101>
  102b54:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b61:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b67:	7f e7                	jg     102b50 <lapic_startap+0xd0>
  102b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b6c:	83 c2 01             	add    $0x1,%edx
  102b6f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b75:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b7b:	7e ec                	jle    102b69 <lapic_startap+0xe9>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102b7d:	85 c0                	test   %eax,%eax
  102b7f:	75 d3                	jne    102b54 <lapic_startap+0xd4>
  102b81:	c1 eb 0c             	shr    $0xc,%ebx
  102b84:	31 c9                	xor    %ecx,%ecx
  102b86:	80 cf 06             	or     $0x6,%bh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b8c:	89 38                	mov    %edi,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102b8e:	8b 06                	mov    (%esi),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b93:	89 18                	mov    %ebx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102b95:	8b 06                	mov    (%esi),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102b97:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102b9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ba3:	eb 0a                	jmp    102baf <lapic_startap+0x12f>
  102ba5:	8d 76 00             	lea    0x0(%esi),%esi
  
  while(us-- > 0)
  102ba8:	85 c0                	test   %eax,%eax
  102baa:	74 34                	je     102be0 <lapic_startap+0x160>
  102bac:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102baf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102bb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bb9:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102bbf:	7f e7                	jg     102ba8 <lapic_startap+0x128>
  102bc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bc4:	83 c2 01             	add    $0x1,%edx
  102bc7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bcd:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102bd3:	7e ec                	jle    102bc1 <lapic_startap+0x141>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102bd5:	85 c0                	test   %eax,%eax
  102bd7:	75 d3                	jne    102bac <lapic_startap+0x12c>
  102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Send startup IPI (twice!) to enter bootstrap code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
  102be0:	83 c1 01             	add    $0x1,%ecx
  102be3:	83 f9 02             	cmp    $0x2,%ecx
  102be6:	75 a1                	jne    102b89 <lapic_startap+0x109>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  102be8:	83 c4 18             	add    $0x18,%esp
  102beb:	5b                   	pop    %ebx
  102bec:	5e                   	pop    %esi
  102bed:	5f                   	pop    %edi
  102bee:	5d                   	pop    %ebp
  102bef:	c3                   	ret    

00102bf0 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102bf0:	55                   	push   %ebp
  102bf1:	89 e5                	mov    %esp,%ebp
  102bf3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102bf6:	9c                   	pushf  
  102bf7:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102bf8:	f6 c4 02             	test   $0x2,%ah
  102bfb:	74 12                	je     102c0f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  102bfd:	a1 40 88 10 00       	mov    0x108840,%eax
  102c02:	8d 50 01             	lea    0x1(%eax),%edx
  102c05:	85 c0                	test   %eax,%eax
  102c07:	89 15 40 88 10 00    	mov    %edx,0x108840
  102c0d:	74 19                	je     102c28 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  102c0f:	8b 15 78 cf 10 00    	mov    0x10cf78,%edx
  102c15:	31 c0                	xor    %eax,%eax
  102c17:	85 d2                	test   %edx,%edx
  102c19:	74 06                	je     102c21 <cpu+0x31>
    return lapic[ID]>>24;
  102c1b:	8b 42 20             	mov    0x20(%edx),%eax
  102c1e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102c21:	c9                   	leave  
  102c22:	c3                   	ret    
  102c23:	90                   	nop
  102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  102c28:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102c2a:	8b 40 04             	mov    0x4(%eax),%eax
  102c2d:	c7 04 24 d0 77 10 00 	movl   $0x1077d0,(%esp)
  102c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c38:	e8 83 db ff ff       	call   1007c0 <cprintf>
  102c3d:	eb d0                	jmp    102c0f <cpu+0x1f>
  102c3f:	90                   	nop

00102c40 <start_trans_man_action>:

}

void
start_trans_man_action()
{
  102c40:	55                   	push   %ebp
  102c41:	89 e5                	mov    %esp,%ebp
  b_index = 0;
  102c43:	c7 05 d0 cf 10 00 00 	movl   $0x0,0x10cfd0
  102c4a:	00 00 00 
}
  102c4d:	5d                   	pop    %ebp
  102c4e:	c3                   	ret    
  102c4f:	90                   	nop

00102c50 <log_start>:
  }
}

static void
log_start()
{
  102c50:	55                   	push   %ebp
  102c51:	89 e5                	mov    %esp,%ebp
  102c53:	56                   	push   %esi
  102c54:	53                   	push   %ebx
  102c55:	83 ec 70             	sub    $0x70,%esp
  struct inode *ip;
  int i;
  struct trans_start start;
  uint state = LOGGING;

  ip = iget(1, 3);
  102c58:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  102c5f:	00 
  102c60:	8d 5d 9c             	lea    -0x64(%ebp),%ebx
log_start()
{
  struct inode *ip;
  int i;
  struct trans_start start;
  uint state = LOGGING;
  102c63:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

  ip = iget(1, 3);
  102c6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c71:	e8 4a ed ff ff       	call   1019c0 <iget>
  102c76:	89 c6                	mov    %eax,%esi
  ilock(ip);
  102c78:	89 04 24             	mov    %eax,(%esp)
  102c7b:	e8 50 f3 ff ff       	call   101fd0 <ilock>
  start.state = READY;
  start.num_blks = b_index;
  102c80:	8b 0d d0 cf 10 00    	mov    0x10cfd0,%ecx
  struct trans_start start;
  uint state = LOGGING;

  ip = iget(1, 3);
  ilock(ip);
  start.state = READY;
  102c86:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
  start.num_blks = b_index;
  for(i=0;i<b_index;i++){
  102c8d:	85 c9                	test   %ecx,%ecx
  uint state = LOGGING;

  ip = iget(1, 3);
  ilock(ip);
  start.state = READY;
  start.num_blks = b_index;
  102c8f:	89 4d a0             	mov    %ecx,-0x60(%ebp)
  for(i=0;i<b_index;i++){
  102c92:	74 19                	je     102cad <log_start+0x5d>
    if(!((i+1)%32)) cprintf("\n");
  }
}

static void
log_start()
  102c94:	31 c0                	xor    %eax,%eax
  102c96:	66 90                	xchg   %ax,%ax
  ip = iget(1, 3);
  ilock(ip);
  start.state = READY;
  start.num_blks = b_index;
  for(i=0;i<b_index;i++){
    start.sector[i] = bp[i]->sector;
  102c98:	8b 14 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%edx
  102c9f:	8b 52 08             	mov    0x8(%edx),%edx
  102ca2:	89 54 83 08          	mov    %edx,0x8(%ebx,%eax,4)

  ip = iget(1, 3);
  ilock(ip);
  start.state = READY;
  start.num_blks = b_index;
  for(i=0;i<b_index;i++){
  102ca6:	83 c0 01             	add    $0x1,%eax
  102ca9:	39 c8                	cmp    %ecx,%eax
  102cab:	75 eb                	jne    102c98 <log_start+0x48>
    start.sector[i] = bp[i]->sector;
  }

  writei(ip, &start, 0, sizeof(start));
  102cad:	c7 44 24 0c 58 00 00 	movl   $0x58,0xc(%esp)
  102cb4:	00 
  102cb5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102cbc:	00 
  102cbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102cc1:	89 34 24             	mov    %esi,(%esp)
  102cc4:	e8 57 ea ff ff       	call   101720 <writei>

  for(i=0;i<b_index;i++){
  102cc9:	a1 d0 cf 10 00       	mov    0x10cfd0,%eax
  102cce:	85 c0                	test   %eax,%eax
  102cd0:	74 38                	je     102d0a <log_start+0xba>
  102cd2:	31 db                	xor    %ebx,%ebx
  102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    writei(ip, bp[i]->data, (i*512) + 512, sizeof(bp[i]->data));
  102cd8:	83 c3 01             	add    $0x1,%ebx
  102cdb:	89 d8                	mov    %ebx,%eax
  102cdd:	c1 e0 09             	shl    $0x9,%eax
  102ce0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ce4:	8b 04 9d 7c cf 10 00 	mov    0x10cf7c(,%ebx,4),%eax
  102ceb:	c7 44 24 0c 00 02 00 	movl   $0x200,0xc(%esp)
  102cf2:	00 
  102cf3:	89 34 24             	mov    %esi,(%esp)
  102cf6:	83 c0 18             	add    $0x18,%eax
  102cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cfd:	e8 1e ea ff ff       	call   101720 <writei>
    start.sector[i] = bp[i]->sector;
  }

  writei(ip, &start, 0, sizeof(start));

  for(i=0;i<b_index;i++){
  102d02:	39 1d d0 cf 10 00    	cmp    %ebx,0x10cfd0
  102d08:	77 ce                	ja     102cd8 <log_start+0x88>
    writei(ip, bp[i]->data, (i*512) + 512, sizeof(bp[i]->data));
  }

  writei(ip, &state, 0, sizeof(state));
  102d0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  102d0d:	89 34 24             	mov    %esi,(%esp)
  102d10:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  102d17:	00 
  102d18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102d1f:	00 
  102d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d24:	e8 f7 e9 ff ff       	call   101720 <writei>

  iunlock(ip);
  102d29:	89 34 24             	mov    %esi,(%esp)
  102d2c:	e8 2f f2 ff ff       	call   101f60 <iunlock>
}
  102d31:	83 c4 70             	add    $0x70,%esp
  102d34:	5b                   	pop    %ebx
  102d35:	5e                   	pop    %esi
  102d36:	5d                   	pop    %ebp
  102d37:	c3                   	ret    
  102d38:	90                   	nop
  102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102d40 <log_end>:

static void
log_end()
{
  102d40:	55                   	push   %ebp
  102d41:	89 e5                	mov    %esp,%ebp
  102d43:	53                   	push   %ebx
  102d44:	83 ec 24             	sub    $0x24,%esp
  uint state = LOGGED;
  struct inode *ip;
  ip = iget(1, 3);
  102d47:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  102d4e:	00 
}

static void
log_end()
{
  uint state = LOGGED;
  102d4f:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  struct inode *ip;
  ip = iget(1, 3);
  102d56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d5d:	e8 5e ec ff ff       	call   1019c0 <iget>
  102d62:	89 c3                	mov    %eax,%ebx
  ilock(ip);
  102d64:	89 04 24             	mov    %eax,(%esp)
  102d67:	e8 64 f2 ff ff       	call   101fd0 <ilock>
  writei(ip, &state, 0, sizeof(state));
  102d6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  102d6f:	89 1c 24             	mov    %ebx,(%esp)
  102d72:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  102d79:	00 
  102d7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102d81:	00 
  102d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d86:	e8 95 e9 ff ff       	call   101720 <writei>
  iunlock(ip);
  102d8b:	89 1c 24             	mov    %ebx,(%esp)
  102d8e:	e8 cd f1 ff ff       	call   101f60 <iunlock>
}
  102d93:	83 c4 24             	add    $0x24,%esp
  102d96:	5b                   	pop    %ebx
  102d97:	5d                   	pop    %ebp
  102d98:	c3                   	ret    
  102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102da0 <end_trans_man_action>:
  b_index = 0;
}

void
end_trans_man_action()
{
  102da0:	55                   	push   %ebp
  102da1:	89 e5                	mov    %esp,%ebp
  102da3:	53                   	push   %ebx
  102da4:	83 ec 14             	sub    $0x14,%esp
  int i;
  log_start();
  102da7:	e8 a4 fe ff ff       	call   102c50 <log_start>
  for(i = 0; i < b_index; i++){
  102dac:	8b 15 d0 cf 10 00    	mov    0x10cfd0,%edx
  102db2:	85 d2                	test   %edx,%edx
  102db4:	74 2b                	je     102de1 <end_trans_man_action+0x41>
  102db6:	31 db                	xor    %ebx,%ebx
    bwrite(bp[i]);
  102db8:	8b 04 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%eax
  102dbf:	89 04 24             	mov    %eax,(%esp)
  102dc2:	e8 39 d3 ff ff       	call   100100 <bwrite>
    brelse(bp[i]);
  102dc7:	8b 04 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%eax
void
end_trans_man_action()
{
  int i;
  log_start();
  for(i = 0; i < b_index; i++){
  102dce:	83 c3 01             	add    $0x1,%ebx
    bwrite(bp[i]);
    brelse(bp[i]);
  102dd1:	89 04 24             	mov    %eax,(%esp)
  102dd4:	e8 27 d2 ff ff       	call   100000 <brelse>
void
end_trans_man_action()
{
  int i;
  log_start();
  for(i = 0; i < b_index; i++){
  102dd9:	39 1d d0 cf 10 00    	cmp    %ebx,0x10cfd0
  102ddf:	77 d7                	ja     102db8 <end_trans_man_action+0x18>
    bwrite(bp[i]);
    brelse(bp[i]);
  }

  log_end();
}
  102de1:	83 c4 14             	add    $0x14,%esp
  102de4:	5b                   	pop    %ebx
  102de5:	5d                   	pop    %ebp
  for(i = 0; i < b_index; i++){
    bwrite(bp[i]);
    brelse(bp[i]);
  }

  log_end();
  102de6:	e9 55 ff ff ff       	jmp    102d40 <log_end>
  102deb:	90                   	nop
  102dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102df0 <log_iupdate>:
  panic("bmap: out of range");
}

void
log_iupdate(struct inode *ip)
{
  102df0:	55                   	push   %ebp
  102df1:	89 e5                	mov    %esp,%ebp
  102df3:	56                   	push   %esi
  102df4:	53                   	push   %ebx
  102df5:	83 ec 10             	sub    $0x10,%esp
  102df8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct dinode *dip;
  bp[b_index] = bread(ip->dev, IBLOCK(ip->inum));
  102dfb:	8b 35 d0 cf 10 00    	mov    0x10cfd0,%esi
  102e01:	8b 43 04             	mov    0x4(%ebx),%eax
  102e04:	c1 e8 03             	shr    $0x3,%eax
  102e07:	83 c0 02             	add    $0x2,%eax
  102e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0e:	8b 03                	mov    (%ebx),%eax
  102e10:	89 04 24             	mov    %eax,(%esp)
  102e13:	e8 18 d3 ff ff       	call   100130 <bread>
  102e18:	89 04 b5 80 cf 10 00 	mov    %eax,0x10cf80(,%esi,4)
  dip = (struct dinode*)bp[b_index]->data + ip->inum%IPB;
  102e1f:	a1 d0 cf 10 00       	mov    0x10cfd0,%eax
  102e24:	8b 14 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%edx
  102e2b:	8b 43 04             	mov    0x4(%ebx),%eax
  102e2e:	83 e0 07             	and    $0x7,%eax
  102e31:	c1 e0 06             	shl    $0x6,%eax
  102e34:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  dip->type = ip->type;
  102e38:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
  102e3c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  102e3f:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  102e43:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  102e47:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  102e4b:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  102e4f:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  102e53:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  102e57:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  102e5a:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp[b_index]->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  102e5d:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  102e60:	83 c0 0c             	add    $0xc,%eax
  102e63:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102e67:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  102e6e:	00 
  102e6f:	89 04 24             	mov    %eax,(%esp)
  102e72:	e8 39 24 00 00       	call   1052b0 <memmove>
  b_index++;
  102e77:	83 05 d0 cf 10 00 01 	addl   $0x1,0x10cfd0
}
  102e7e:	83 c4 10             	add    $0x10,%esp
  102e81:	5b                   	pop    %ebx
  102e82:	5e                   	pop    %esi
  102e83:	5d                   	pop    %ebp
  102e84:	c3                   	ret    
  102e85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102e90 <log_lookup>:
  panic("balloc: out of blocks");
}

uint
log_lookup(struct inode *ip, uint bn)
{
  102e90:	55                   	push   %ebp
  102e91:	89 e5                	mov    %esp,%ebp
  102e93:	57                   	push   %edi
  102e94:	56                   	push   %esi
  102e95:	53                   	push   %ebx
  102e96:	83 ec 2c             	sub    $0x2c,%esp
  102e99:	8b 7d 0c             	mov    0xc(%ebp),%edi
  102e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  uchar found = 0;
  int i;
  uint addr, *a;

  if(bn < NDIRECT){
  102e9f:	83 ff 0a             	cmp    $0xa,%edi
  102ea2:	77 14                	ja     102eb8 <log_lookup+0x28>
    if((addr = ip->addrs[bn]) == 0){
  102ea4:	8b 44 b8 1c          	mov    0x1c(%eax,%edi,4),%eax
  102ea8:	85 c0                	test   %eax,%eax
  102eaa:	74 2c                	je     102ed8 <log_lookup+0x48>
    return addr;
  }

  panic("bmap: out of range");

}
  102eac:	83 c4 2c             	add    $0x2c,%esp
  102eaf:	5b                   	pop    %ebx
  102eb0:	5e                   	pop    %esi
  102eb1:	5f                   	pop    %edi
  102eb2:	5d                   	pop    %ebp
  102eb3:	c3                   	ret    
  102eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0){
      panic("FS failure");
    }
    return addr;
  }
  bn -= NDIRECT;
  102eb8:	83 ef 0b             	sub    $0xb,%edi
  if(bn < (NINDIRECT * NINDIRECT)){
  102ebb:	81 ff ff 3f 00 00    	cmp    $0x3fff,%edi
  102ec1:	0f 87 9b 00 00 00    	ja     102f62 <log_lookup+0xd2>
    if((addr = ip->addrs[INDIRECT]) == 0){
  102ec7:	8b 70 48             	mov    0x48(%eax),%esi
  102eca:	85 f6                	test   %esi,%esi
  102ecc:	74 0a                	je     102ed8 <log_lookup+0x48>
      panic("FS failure");
    }
    for(i = 0; i < b_index; i++){
  102ece:	8b 0d d0 cf 10 00    	mov    0x10cfd0,%ecx
  102ed4:	85 c9                	test   %ecx,%ecx
  102ed6:	75 10                	jne    102ee8 <log_lookup+0x58>
	  panic("FS failure");
	}
	break;
      }
    }
    if(!found)    panic("FS failure");
  102ed8:	c7 04 24 fc 77 10 00 	movl   $0x1077fc,(%esp)
  102edf:	e8 7c da ff ff       	call   100960 <panic>
  102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(bn < (NINDIRECT * NINDIRECT)){
    if((addr = ip->addrs[INDIRECT]) == 0){
      panic("FS failure");
    }
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
  102ee8:	8b 15 80 cf 10 00    	mov    0x10cf80,%edx
  102eee:	8b 42 08             	mov    0x8(%edx),%eax
  102ef1:	89 d3                	mov    %edx,%ebx
  102ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
	  panic("fs fail");
  102ef6:	31 c0                	xor    %eax,%eax
  if(bn < (NINDIRECT * NINDIRECT)){
    if((addr = ip->addrs[INDIRECT]) == 0){
      panic("FS failure");
    }
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
  102ef8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  102efb:	75 0f                	jne    102f0c <log_lookup+0x7c>
  102efd:	eb 19                	jmp    102f18 <log_lookup+0x88>
  102eff:	90                   	nop
  102f00:	8b 1c 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%ebx
  102f07:	39 73 08             	cmp    %esi,0x8(%ebx)
  102f0a:	74 0c                	je     102f18 <log_lookup+0x88>
  bn -= NDIRECT;
  if(bn < (NINDIRECT * NINDIRECT)){
    if((addr = ip->addrs[INDIRECT]) == 0){
      panic("FS failure");
    }
    for(i = 0; i < b_index; i++){
  102f0c:	83 c0 01             	add    $0x1,%eax
  102f0f:	39 c8                	cmp    %ecx,%eax
  102f11:	72 ed                	jb     102f00 <log_lookup+0x70>
  102f13:	eb c3                	jmp    102ed8 <log_lookup+0x48>
  102f15:	8d 76 00             	lea    0x0(%esi),%esi
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
  102f18:	89 f8                	mov    %edi,%eax
  102f1a:	c1 e8 07             	shr    $0x7,%eax
  102f1d:	8b 5c 83 18          	mov    0x18(%ebx,%eax,4),%ebx
  102f21:	85 db                	test   %ebx,%ebx
  102f23:	74 31                	je     102f56 <log_lookup+0xc6>
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
	  panic("FS failure");
  102f25:	31 c0                	xor    %eax,%eax
      }
    }
    if(!found) panic("FS failure");
    found = 0;
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
  102f27:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  102f2a:	74 17                	je     102f43 <log_lookup+0xb3>
  102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	break;
      }
    }
    if(!found) panic("FS failure");
    found = 0;
    for(i = 0;i < b_index; i++){
  102f30:	83 c0 01             	add    $0x1,%eax
  102f33:	39 c1                	cmp    %eax,%ecx
  102f35:	76 a1                	jbe    102ed8 <log_lookup+0x48>
      if(bp[i]->sector == addr){
  102f37:	8b 14 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%edx
  102f3e:	3b 5a 08             	cmp    0x8(%edx),%ebx
  102f41:	75 ed                	jne    102f30 <log_lookup+0xa0>
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
  102f43:	83 e7 7f             	and    $0x7f,%edi
  102f46:	8b 44 ba 18          	mov    0x18(%edx,%edi,4),%eax
  102f4a:	85 c0                	test   %eax,%eax
  102f4c:	74 8a                	je     102ed8 <log_lookup+0x48>
    return addr;
  }

  panic("bmap: out of range");

}
  102f4e:	83 c4 2c             	add    $0x2c,%esp
  102f51:	5b                   	pop    %ebx
  102f52:	5e                   	pop    %esi
  102f53:	5f                   	pop    %edi
  102f54:	5d                   	pop    %ebp
  102f55:	c3                   	ret    
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
	  panic("fs fail");
  102f56:	c7 04 24 07 78 10 00 	movl   $0x107807,(%esp)
  102f5d:	e8 fe d9 ff ff       	call   100960 <panic>
    if(!found)    panic("FS failure");

    return addr;
  }

  panic("bmap: out of range");
  102f62:	c7 04 24 3a 74 10 00 	movl   $0x10743a,(%esp)
  102f69:	e8 f2 d9 ff ff       	call   100960 <panic>
  102f6e:	66 90                	xchg   %ax,%ax

00102f70 <log_balloc>:
}


static uint
log_balloc(uint dev)
{
  102f70:	55                   	push   %ebp
  102f71:	89 e5                	mov    %esp,%ebp
  102f73:	57                   	push   %edi
  102f74:	56                   	push   %esi
  102f75:	53                   	push   %ebx
  102f76:	83 ec 5c             	sub    $0x5c,%esp
  102f79:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  int b, bi, m, i;
  struct superblock sb;

  readsb(dev, &sb);
  102f7c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  102f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f86:	89 04 24             	mov    %eax,(%esp)
  102f89:	e8 82 e2 ff ff       	call   101210 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  102f8e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102f91:	85 c9                	test   %ecx,%ecx
  102f93:	0f 84 58 01 00 00    	je     1030f1 <log_balloc+0x181>
  102f99:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
    for(i = 0; i < b_index; i++)
  102fa0:	a1 d0 cf 10 00       	mov    0x10cfd0,%eax
  102fa5:	85 c0                	test   %eax,%eax
  102fa7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102faa:	0f 84 0e 01 00 00    	je     1030be <log_balloc+0x14e>
  102fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fb3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102fb6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  102fbd:	c1 e8 03             	shr    $0x3,%eax
  102fc0:	c1 fa 0c             	sar    $0xc,%edx
  102fc3:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  102fc7:	89 55 cc             	mov    %edx,-0x34(%ebp)
      if(bp[i]->sector == BBLOCK(b, sb.ninodes)) {
  102fca:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  102fcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102fd0:	8b 14 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%edx
  102fd7:	39 42 08             	cmp    %eax,0x8(%edx)
  102fda:	0f 84 90 00 00 00    	je     103070 <log_balloc+0x100>
  int b, bi, m, i;
  struct superblock sb;

  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    for(i = 0; i < b_index; i++)
  102fe0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
  102fe4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  102fe7:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  102fea:	72 de                	jb     102fca <log_balloc+0x5a>
	    return b + bi;
	  }
	}
      }

    bp[b_index] = bread(dev, BBLOCK(b, sb.ninodes));
  102fec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102fef:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ff3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ff6:	89 14 24             	mov    %edx,(%esp)
  102ff9:	e8 32 d1 ff ff       	call   100130 <bread>
  102ffe:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  103001:	89 04 9d 80 cf 10 00 	mov    %eax,0x10cf80(,%ebx,4)
  103008:	a1 d0 cf 10 00       	mov    0x10cfd0,%eax
  10300d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  103010:	8b 3c 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%edi
  103017:	31 c0                	xor    %eax,%eax
  103019:	eb 13                	jmp    10302e <log_balloc+0xbe>
  10301b:	90                   	nop
  10301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  103020:	83 c0 01             	add    $0x1,%eax
  103023:	3d 00 10 00 00       	cmp    $0x1000,%eax
  103028:	0f 84 a8 00 00 00    	je     1030d6 <log_balloc+0x166>
      m = 1 << (bi % 8);
  10302e:	89 c1                	mov    %eax,%ecx
  103030:	ba 01 00 00 00       	mov    $0x1,%edx
  103035:	83 e1 07             	and    $0x7,%ecx
  103038:	d3 e2                	shl    %cl,%edx
  10303a:	89 d1                	mov    %edx,%ecx
      if((bp[b_index]->data[bi/8] & m) == 0){
  10303c:	89 c2                	mov    %eax,%edx
  10303e:	c1 fa 03             	sar    $0x3,%edx
  103041:	0f b6 5c 17 18       	movzbl 0x18(%edi,%edx,1),%ebx
  103046:	0f b6 f3             	movzbl %bl,%esi
  103049:	85 ce                	test   %ecx,%esi
  10304b:	75 d3                	jne    103020 <log_balloc+0xb0>
	bp[b_index]->data[bi/8] |= m;
  10304d:	09 d9                	or     %ebx,%ecx
  10304f:	88 4c 17 18          	mov    %cl,0x18(%edi,%edx,1)
	b_index++;
  103053:	8b 55 d4             	mov    -0x2c(%ebp),%edx
	return b + bi;
  103056:	03 45 c8             	add    -0x38(%ebp),%eax
    bp[b_index] = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp[b_index]->data[bi/8] & m) == 0){
	bp[b_index]->data[bi/8] |= m;
	b_index++;
  103059:	83 c2 01             	add    $0x1,%edx
  10305c:	89 15 d0 cf 10 00    	mov    %edx,0x10cfd0
      }
    }
    brelse(bp[b_index]);
  }
  panic("balloc: out of blocks");
}
  103062:	83 c4 5c             	add    $0x5c,%esp
  103065:	5b                   	pop    %ebx
  103066:	5e                   	pop    %esi
  103067:	5f                   	pop    %edi
  103068:	5d                   	pop    %ebp
  103069:	c3                   	ret    
  10306a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct superblock sb;

  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    for(i = 0; i < b_index; i++)
      if(bp[i]->sector == BBLOCK(b, sb.ninodes)) {
  103070:	31 c0                	xor    %eax,%eax
  103072:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  103075:	eb 0f                	jmp    103086 <log_balloc+0x116>
  103077:	90                   	nop
	for(bi = 0; bi < BPB; bi++){
  103078:	83 c0 01             	add    $0x1,%eax
  10307b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  103080:	0f 84 5a ff ff ff    	je     102fe0 <log_balloc+0x70>
	  m = 1 << (bi % 8);
  103086:	89 c1                	mov    %eax,%ecx
  103088:	ba 01 00 00 00       	mov    $0x1,%edx
  10308d:	83 e1 07             	and    $0x7,%ecx
	  if((bp[i]->data[bi/8] & m) == 0){
  103090:	89 c3                	mov    %eax,%ebx
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    for(i = 0; i < b_index; i++)
      if(bp[i]->sector == BBLOCK(b, sb.ninodes)) {
	for(bi = 0; bi < BPB; bi++){
	  m = 1 << (bi % 8);
  103092:	d3 e2                	shl    %cl,%edx
  103094:	89 d1                	mov    %edx,%ecx
	  if((bp[i]->data[bi/8] & m) == 0){
  103096:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103099:	c1 fb 03             	sar    $0x3,%ebx
  10309c:	0f b6 74 1a 18       	movzbl 0x18(%edx,%ebx,1),%esi
  1030a1:	89 f2                	mov    %esi,%edx
  1030a3:	0f b6 fa             	movzbl %dl,%edi
  1030a6:	85 cf                	test   %ecx,%edi
  1030a8:	75 ce                	jne    103078 <log_balloc+0x108>
  1030aa:	8b 55 b4             	mov    -0x4c(%ebp),%edx
	    bp[i]->data[bi/8] |= m;
  1030ad:	09 f1                	or     %esi,%ecx
  1030af:	88 4c 1a 18          	mov    %cl,0x18(%edx,%ebx,1)
	    return b + bi;
  1030b3:	03 45 c8             	add    -0x38(%ebp),%eax
      }
    }
    brelse(bp[b_index]);
  }
  panic("balloc: out of blocks");
}
  1030b6:	83 c4 5c             	add    $0x5c,%esp
  1030b9:	5b                   	pop    %ebx
  1030ba:	5e                   	pop    %esi
  1030bb:	5f                   	pop    %edi
  1030bc:	5d                   	pop    %ebp
  1030bd:	c3                   	ret    
  int b, bi, m, i;
  struct superblock sb;

  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    for(i = 0; i < b_index; i++)
  1030be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1030c4:	c1 e8 03             	shr    $0x3,%eax
  1030c7:	c1 fa 0c             	sar    $0xc,%edx
  1030ca:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  1030ce:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1030d1:	e9 16 ff ff ff       	jmp    102fec <log_balloc+0x7c>
	bp[b_index]->data[bi/8] |= m;
	b_index++;
	return b + bi;
      }
    }
    brelse(bp[b_index]);
  1030d6:	89 3c 24             	mov    %edi,(%esp)
  1030d9:	e8 22 cf ff ff       	call   100000 <brelse>
{
  int b, bi, m, i;
  struct superblock sb;

  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1030de:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  1030e5:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  1030e8:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
  1030eb:	0f 87 af fe ff ff    	ja     102fa0 <log_balloc+0x30>
	return b + bi;
      }
    }
    brelse(bp[b_index]);
  }
  panic("balloc: out of blocks");
  1030f1:	c7 04 24 24 74 10 00 	movl   $0x107424,(%esp)
  1030f8:	e8 63 d8 ff ff       	call   100960 <panic>
  1030fd:	8d 76 00             	lea    0x0(%esi),%esi

00103100 <log_bmap>:

}

uint
log_bmap(struct inode *ip, uint bn)
{
  103100:	55                   	push   %ebp
  103101:	89 e5                	mov    %esp,%ebp
  103103:	57                   	push   %edi
  103104:	56                   	push   %esi
  103105:	53                   	push   %ebx
  103106:	83 ec 2c             	sub    $0x2c,%esp
  103109:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10310c:	8b 75 08             	mov    0x8(%ebp),%esi
  uchar found;
  int i;
  uint addr, *a;

  if(bn < NDIRECT){
  10310f:	83 ff 0a             	cmp    $0xa,%edi
  103112:	77 1c                	ja     103130 <log_bmap+0x30>
    if((addr = ip->addrs[bn]) == 0){
  103114:	83 c7 04             	add    $0x4,%edi
  103117:	8b 44 be 0c          	mov    0xc(%esi,%edi,4),%eax
  10311b:	85 c0                	test   %eax,%eax
  10311d:	0f 84 65 01 00 00    	je     103288 <log_bmap+0x188>

    return addr;
  }

  panic("bmap: out of range");
}
  103123:	83 c4 2c             	add    $0x2c,%esp
  103126:	5b                   	pop    %ebx
  103127:	5e                   	pop    %esi
  103128:	5f                   	pop    %edi
  103129:	5d                   	pop    %ebp
  10312a:	c3                   	ret    
  10312b:	90                   	nop
  10312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0){
      ip->addrs[bn] = addr = log_balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  103130:	83 ef 0b             	sub    $0xb,%edi
  if(bn < (NINDIRECT * NINDIRECT)){
  103133:	81 ff ff 3f 00 00    	cmp    $0x3fff,%edi
  103139:	0f 87 7e 01 00 00    	ja     1032bd <log_bmap+0x1bd>

    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  10313f:	8b 46 48             	mov    0x48(%esi),%eax
  103142:	85 c0                	test   %eax,%eax
  103144:	0f 84 56 01 00 00    	je     1032a0 <log_bmap+0x1a0>
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
  10314a:	8b 1d d0 cf 10 00    	mov    0x10cfd0,%ebx
  103150:	85 db                	test   %ebx,%ebx
  103152:	74 2b                	je     10317f <log_bmap+0x7f>
      if(bp[i]->sector == addr){
  103154:	8b 0d 80 cf 10 00    	mov    0x10cf80,%ecx
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
	  a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
  10315a:	31 d2                	xor    %edx,%edx
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
  10315c:	39 41 08             	cmp    %eax,0x8(%ecx)
  10315f:	75 17                	jne    103178 <log_bmap+0x78>
  103161:	e9 da 00 00 00       	jmp    103240 <log_bmap+0x140>
  103166:	66 90                	xchg   %ax,%ax
  103168:	8b 0c 95 80 cf 10 00 	mov    0x10cf80(,%edx,4),%ecx
  10316f:	39 41 08             	cmp    %eax,0x8(%ecx)
  103172:	0f 84 c8 00 00 00    	je     103240 <log_bmap+0x140>
    if((addr = ip->addrs[INDIRECT]) == 0){
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
  103178:	83 c2 01             	add    $0x1,%edx
  10317b:	39 d3                	cmp    %edx,%ebx
  10317d:	77 e9                	ja     103168 <log_bmap+0x68>
      }
    }
    if(!found){
      // load new block from mem

      bp[b_index] = bread(ip->dev, addr);
  10317f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103183:	8b 06                	mov    (%esi),%eax
  103185:	89 04 24             	mov    %eax,(%esp)
  103188:	e8 a3 cf ff ff       	call   100130 <bread>
      a = (uint*)bp[b_index]->data;

      b_index++;
      if((addr = a[(bn / NINDIRECT)]) == 0){
  10318d:	89 fa                	mov    %edi,%edx
  10318f:	c1 ea 07             	shr    $0x7,%edx
      }
    }
    if(!found){
      // load new block from mem

      bp[b_index] = bread(ip->dev, addr);
  103192:	89 04 9d 80 cf 10 00 	mov    %eax,0x10cf80(,%ebx,4)
      a = (uint*)bp[b_index]->data;
  103199:	8b 1d d0 cf 10 00    	mov    0x10cfd0,%ebx
  10319f:	8b 04 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%eax

      b_index++;
  1031a6:	83 c3 01             	add    $0x1,%ebx
  1031a9:	89 1d d0 cf 10 00    	mov    %ebx,0x10cfd0
      if((addr = a[(bn / NINDIRECT)]) == 0){
  1031af:	8d 54 90 18          	lea    0x18(%eax,%edx,4),%edx
  1031b3:	8b 02                	mov    (%edx),%eax
  1031b5:	85 c0                	test   %eax,%eax
  1031b7:	0f 84 96 00 00 00    	je     103253 <log_bmap+0x153>
	a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
      }
    }
    found = 0;
    for(i = 0;i < b_index; i++){
  1031bd:	85 db                	test   %ebx,%ebx
  1031bf:	74 2e                	je     1031ef <log_bmap+0xef>
      if(bp[i]->sector == addr){
  1031c1:	8b 0d 80 cf 10 00    	mov    0x10cf80,%ecx
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
	  a[(bn % NINDIRECT)] = addr = log_balloc(ip->dev);
  1031c7:	31 d2                	xor    %edx,%edx
	a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
      }
    }
    found = 0;
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
  1031c9:	39 41 08             	cmp    %eax,0x8(%ecx)
  1031cc:	75 1a                	jne    1031e8 <log_bmap+0xe8>
  1031ce:	e9 9d 00 00 00       	jmp    103270 <log_bmap+0x170>
  1031d3:	90                   	nop
  1031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1031d8:	8b 0c 95 80 cf 10 00 	mov    0x10cf80(,%edx,4),%ecx
  1031df:	39 41 08             	cmp    %eax,0x8(%ecx)
  1031e2:	0f 84 88 00 00 00    	je     103270 <log_bmap+0x170>
      if((addr = a[(bn / NINDIRECT)]) == 0){
	a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
      }
    }
    found = 0;
    for(i = 0;i < b_index; i++){
  1031e8:	83 c2 01             	add    $0x1,%edx
  1031eb:	39 d3                	cmp    %edx,%ebx
  1031ed:	77 e9                	ja     1031d8 <log_bmap+0xd8>
	break;
      }
    }
    if(!found){
      // load new block
      bp[b_index] = bread(ip->dev, addr);
  1031ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f3:	8b 06                	mov    (%esi),%eax
      a = (uint*)bp[b_index]->data;

      b_index++;
      if((addr = a[(bn % NINDIRECT)]) == 0){
  1031f5:	83 e7 7f             	and    $0x7f,%edi
	break;
      }
    }
    if(!found){
      // load new block
      bp[b_index] = bread(ip->dev, addr);
  1031f8:	89 04 24             	mov    %eax,(%esp)
  1031fb:	e8 30 cf ff ff       	call   100130 <bread>
  103200:	89 04 9d 80 cf 10 00 	mov    %eax,0x10cf80(,%ebx,4)
      a = (uint*)bp[b_index]->data;
  103207:	a1 d0 cf 10 00       	mov    0x10cfd0,%eax
  10320c:	8b 14 85 80 cf 10 00 	mov    0x10cf80(,%eax,4),%edx

      b_index++;
  103213:	83 c0 01             	add    $0x1,%eax
  103216:	a3 d0 cf 10 00       	mov    %eax,0x10cfd0
      if((addr = a[(bn % NINDIRECT)]) == 0){
  10321b:	8d 5c ba 18          	lea    0x18(%edx,%edi,4),%ebx
  10321f:	8b 03                	mov    (%ebx),%eax
  103221:	85 c0                	test   %eax,%eax
  103223:	0f 85 fa fe ff ff    	jne    103123 <log_bmap+0x23>
	a[(bn % NINDIRECT)] = addr = log_balloc(ip->dev);
  103229:	8b 06                	mov    (%esi),%eax
  10322b:	e8 40 fd ff ff       	call   102f70 <log_balloc>
  103230:	89 03                	mov    %eax,(%ebx)

    return addr;
  }

  panic("bmap: out of range");
}
  103232:	83 c4 2c             	add    $0x2c,%esp
  103235:	5b                   	pop    %ebx
  103236:	5e                   	pop    %esi
  103237:	5f                   	pop    %edi
  103238:	5d                   	pop    %ebp
  103239:	c3                   	ret    
  10323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    found = 0;
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
  103240:	89 f8                	mov    %edi,%eax
  103242:	c1 e8 07             	shr    $0x7,%eax
  103245:	8d 54 81 18          	lea    0x18(%ecx,%eax,4),%edx
  103249:	8b 02                	mov    (%edx),%eax
  10324b:	85 c0                	test   %eax,%eax
  10324d:	0f 85 6a ff ff ff    	jne    1031bd <log_bmap+0xbd>
      bp[b_index] = bread(ip->dev, addr);
      a = (uint*)bp[b_index]->data;

      b_index++;
      if((addr = a[(bn / NINDIRECT)]) == 0){
	a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
  103253:	8b 06                	mov    (%esi),%eax
  103255:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103258:	e8 13 fd ff ff       	call   102f70 <log_balloc>
  10325d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103260:	89 02                	mov    %eax,(%edx)
  103262:	8b 1d d0 cf 10 00    	mov    0x10cfd0,%ebx
  103268:	e9 50 ff ff ff       	jmp    1031bd <log_bmap+0xbd>
  10326d:	8d 76 00             	lea    0x0(%esi),%esi
    found = 0;
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
  103270:	83 e7 7f             	and    $0x7f,%edi
  103273:	8d 5c b9 18          	lea    0x18(%ecx,%edi,4),%ebx
  103277:	8b 03                	mov    (%ebx),%eax
  103279:	85 c0                	test   %eax,%eax
  10327b:	74 ac                	je     103229 <log_bmap+0x129>

    return addr;
  }

  panic("bmap: out of range");
}
  10327d:	83 c4 2c             	add    $0x2c,%esp
  103280:	5b                   	pop    %ebx
  103281:	5e                   	pop    %esi
  103282:	5f                   	pop    %edi
  103283:	5d                   	pop    %ebp
  103284:	c3                   	ret    
  103285:	8d 76 00             	lea    0x0(%esi),%esi
  int i;
  uint addr, *a;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      ip->addrs[bn] = addr = log_balloc(ip->dev);
  103288:	8b 06                	mov    (%esi),%eax
  10328a:	e8 e1 fc ff ff       	call   102f70 <log_balloc>
  10328f:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)

    return addr;
  }

  panic("bmap: out of range");
}
  103293:	83 c4 2c             	add    $0x2c,%esp
  103296:	5b                   	pop    %ebx
  103297:	5e                   	pop    %esi
  103298:	5f                   	pop    %edi
  103299:	5d                   	pop    %ebp
  10329a:	c3                   	ret    
  10329b:	90                   	nop
  10329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
  if(bn < (NINDIRECT * NINDIRECT)){

    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
  1032a0:	8b 06                	mov    (%esi),%eax
  1032a2:	e8 c9 fc ff ff       	call   102f70 <log_balloc>
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
  1032a7:	8b 1d d0 cf 10 00    	mov    0x10cfd0,%ebx
  1032ad:	85 db                	test   %ebx,%ebx
  bn -= NDIRECT;
  if(bn < (NINDIRECT * NINDIRECT)){

    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
  1032af:	89 46 48             	mov    %eax,0x48(%esi)
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
  1032b2:	0f 85 9c fe ff ff    	jne    103154 <log_bmap+0x54>
  1032b8:	e9 c2 fe ff ff       	jmp    10317f <log_bmap+0x7f>
    }

    return addr;
  }

  panic("bmap: out of range");
  1032bd:	c7 04 24 3a 74 10 00 	movl   $0x10743a,(%esp)
  1032c4:	e8 97 d6 ff ff       	call   100960 <panic>
  1032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001032d0 <log_writei>:
  b_index++;
}

int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  1032d0:	55                   	push   %ebp
  1032d1:	89 e5                	mov    %esp,%ebp
  1032d3:	57                   	push   %edi
  1032d4:	56                   	push   %esi
  1032d5:	53                   	push   %ebx
  1032d6:	83 ec 3c             	sub    $0x3c,%esp
  1032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1032e2:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m, i, j;
  struct buf *tbp;

  if(ip->type == T_DEV){
  1032e5:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
  b_index++;
}

int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  1032ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1032f0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  uint tot, m, i, j;
  struct buf *tbp;

  if(ip->type == T_DEV){
  1032f3:	0f 84 67 01 00 00    	je     103460 <log_writei+0x190>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  1032f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1032fc:	01 f0                	add    %esi,%eax
  1032fe:	0f 82 66 01 00 00    	jb     10346a <log_writei+0x19a>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  103304:	3d 00 16 81 00       	cmp    $0x811600,%eax
  103309:	76 08                	jbe    103313 <log_writei+0x43>
    n = MAXFILE*BSIZE - off;
  10330b:	be 00 16 81 00       	mov    $0x811600,%esi
  103310:	2b 75 d8             	sub    -0x28(%ebp),%esi


  b_index = 0; // new xfer, start keeping track of open bufs

  /* allocate all space needed */
  for(i=0, j=off; i<n; i+=m, j+=m){
  103313:	85 f6                	test   %esi,%esi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;


  b_index = 0; // new xfer, start keeping track of open bufs
  103315:	c7 05 d0 cf 10 00 00 	movl   $0x0,0x10cfd0
  10331c:	00 00 00 

  /* allocate all space needed */
  for(i=0, j=off; i<n; i+=m, j+=m){
  10331f:	0f 84 f2 00 00 00    	je     103417 <log_writei+0x147>
  103325:	8b 7d d8             	mov    -0x28(%ebp),%edi
  103328:	31 db                	xor    %ebx,%ebx
  10332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log_bmap(ip, j/BSIZE);
  103330:	89 f8                	mov    %edi,%eax
  103332:	c1 e8 09             	shr    $0x9,%eax
  103335:	89 44 24 04          	mov    %eax,0x4(%esp)
  103339:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10333c:	89 04 24             	mov    %eax,(%esp)
  10333f:	e8 bc fd ff ff       	call   103100 <log_bmap>
    m = min(n - i, BSIZE - j%BSIZE);
  103344:	89 f8                	mov    %edi,%eax
  103346:	ba 00 02 00 00       	mov    $0x200,%edx
  10334b:	25 ff 01 00 00       	and    $0x1ff,%eax
  103350:	29 c2                	sub    %eax,%edx
  103352:	89 d0                	mov    %edx,%eax
  103354:	89 f2                	mov    %esi,%edx
  103356:	29 da                	sub    %ebx,%edx
  103358:	39 d0                	cmp    %edx,%eax
  10335a:	76 02                	jbe    10335e <log_writei+0x8e>
  10335c:	89 d0                	mov    %edx,%eax


  b_index = 0; // new xfer, start keeping track of open bufs

  /* allocate all space needed */
  for(i=0, j=off; i<n; i+=m, j+=m){
  10335e:	01 c3                	add    %eax,%ebx
  103360:	01 c7                	add    %eax,%edi
  103362:	39 de                	cmp    %ebx,%esi
  103364:	77 ca                	ja     103330 <log_writei+0x60>
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
  103366:	89 75 dc             	mov    %esi,-0x24(%ebp)


  b_index = 0; // new xfer, start keeping track of open bufs

  /* allocate all space needed */
  for(i=0, j=off; i<n; i+=m, j+=m){
  103369:	8b 15 d0 cf 10 00    	mov    0x10cfd0,%edx
  10336f:	31 ff                	xor    %edi,%edi
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
  103371:	8b 75 d8             	mov    -0x28(%ebp),%esi
  103374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
  103378:	89 f0                	mov    %esi,%eax
    m = min(n - tot, BSIZE - off%BSIZE);
  10337a:	bb 00 02 00 00       	mov    $0x200,%ebx
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
  10337f:	c1 e8 09             	shr    $0x9,%eax
  103382:	89 44 24 04          	mov    %eax,0x4(%esp)
  103386:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103389:	89 0c 24             	mov    %ecx,(%esp)
  10338c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10338f:	e8 fc fa ff ff       	call   102e90 <log_lookup>
  103394:	89 44 24 04          	mov    %eax,0x4(%esp)
  103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10339b:	8b 01                	mov    (%ecx),%eax
  10339d:	89 04 24             	mov    %eax,(%esp)
  1033a0:	e8 8b cd ff ff       	call   100130 <bread>
  1033a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1033a8:	89 04 95 80 cf 10 00 	mov    %eax,0x10cf80(,%edx,4)
    m = min(n - tot, BSIZE - off%BSIZE);
  1033af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033b2:	89 f0                	mov    %esi,%eax
  1033b4:	25 ff 01 00 00       	and    $0x1ff,%eax
  1033b9:	29 c3                	sub    %eax,%ebx
  1033bb:	29 fa                	sub    %edi,%edx
  1033bd:	39 d3                	cmp    %edx,%ebx
  1033bf:	76 02                	jbe    1033c3 <log_writei+0xf3>
  1033c1:	89 d3                	mov    %edx,%ebx
    memmove(bp[b_index]->data + off%BSIZE, src, m);
  1033c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1033c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  for(i=0, j=off; i<n; i+=m, j+=m){
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1033ca:	01 df                	add    %ebx,%edi
  1033cc:	01 de                	add    %ebx,%esi
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp[b_index]->data + off%BSIZE, src, m);
  1033ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033d2:	8b 15 d0 cf 10 00    	mov    0x10cfd0,%edx
  1033d8:	8b 14 95 80 cf 10 00 	mov    0x10cf80(,%edx,4),%edx
  1033df:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  1033e3:	89 04 24             	mov    %eax,(%esp)
  1033e6:	e8 c5 1e 00 00       	call   1052b0 <memmove>
    b_index++;
  1033eb:	8b 15 d0 cf 10 00    	mov    0x10cfd0,%edx
  for(i=0, j=off; i<n; i+=m, j+=m){
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1033f1:	01 5d e0             	add    %ebx,-0x20(%ebp)
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp[b_index]->data + off%BSIZE, src, m);
    b_index++;
  1033f4:	83 c2 01             	add    $0x1,%edx
  for(i=0, j=off; i<n; i+=m, j+=m){
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1033f7:	39 7d dc             	cmp    %edi,-0x24(%ebp)
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp[b_index]->data + off%BSIZE, src, m);
    b_index++;
  1033fa:	89 15 d0 cf 10 00    	mov    %edx,0x10cfd0
  for(i=0, j=off; i<n; i+=m, j+=m){
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  103400:	0f 87 72 ff ff ff    	ja     103378 <log_writei+0xa8>
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp[b_index]->data + off%BSIZE, src, m);
    b_index++;
  }

  if(n > 0 && off > ip->size){
  103406:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103409:	89 75 d8             	mov    %esi,-0x28(%ebp)
  10340c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10340f:	8b 75 dc             	mov    -0x24(%ebp),%esi
  103412:	39 41 18             	cmp    %eax,0x18(%ecx)
  103415:	72 61                	jb     103478 <log_writei+0x1a8>
    ip->size = off;
    log_iupdate(ip);
  }

  log_start();
  103417:	e8 34 f8 ff ff       	call   102c50 <log_start>
  for(i = 0; i < b_index; i++){
  10341c:	8b 1d d0 cf 10 00    	mov    0x10cfd0,%ebx
  103422:	85 db                	test   %ebx,%ebx
  103424:	74 2b                	je     103451 <log_writei+0x181>
  103426:	31 db                	xor    %ebx,%ebx
    bwrite(bp[i]);
  103428:	8b 04 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%eax
  10342f:	89 04 24             	mov    %eax,(%esp)
  103432:	e8 c9 cc ff ff       	call   100100 <bwrite>
    brelse(bp[i]);
  103437:	8b 04 9d 80 cf 10 00 	mov    0x10cf80(,%ebx,4),%eax
    ip->size = off;
    log_iupdate(ip);
  }

  log_start();
  for(i = 0; i < b_index; i++){
  10343e:	83 c3 01             	add    $0x1,%ebx
    bwrite(bp[i]);
    brelse(bp[i]);
  103441:	89 04 24             	mov    %eax,(%esp)
  103444:	e8 b7 cb ff ff       	call   100000 <brelse>
    ip->size = off;
    log_iupdate(ip);
  }

  log_start();
  for(i = 0; i < b_index; i++){
  103449:	39 1d d0 cf 10 00    	cmp    %ebx,0x10cfd0
  10344f:	77 d7                	ja     103428 <log_writei+0x158>
    bwrite(bp[i]);
    brelse(bp[i]);
  }

  log_end();
  103451:	e8 ea f8 ff ff       	call   102d40 <log_end>

  return n;

}
  103456:	83 c4 3c             	add    $0x3c,%esp
    brelse(bp[i]);
  }

  log_end();

  return n;
  103459:	89 f0                	mov    %esi,%eax

}
  10345b:	5b                   	pop    %ebx
  10345c:	5e                   	pop    %esi
  10345d:	5f                   	pop    %edi
  10345e:	5d                   	pop    %ebp
  10345f:	c3                   	ret    
{
  uint tot, m, i, j;
  struct buf *tbp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  103460:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  103464:	66 83 f8 09          	cmp    $0x9,%ax
  103468:	76 1b                	jbe    103485 <log_writei+0x1b5>

  log_end();

  return n;

}
  10346a:	83 c4 3c             	add    $0x3c,%esp
    brelse(bp[i]);
  }

  log_end();

  return n;
  10346d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  103472:	5b                   	pop    %ebx
  103473:	5e                   	pop    %esi
  103474:	5f                   	pop    %edi
  103475:	5d                   	pop    %ebp
  103476:	c3                   	ret    
  103477:	90                   	nop
    memmove(bp[b_index]->data + off%BSIZE, src, m);
    b_index++;
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  103478:	89 41 18             	mov    %eax,0x18(%ecx)
    log_iupdate(ip);
  10347b:	89 0c 24             	mov    %ecx,(%esp)
  10347e:	e8 6d f9 ff ff       	call   102df0 <log_iupdate>
  103483:	eb 92                	jmp    103417 <log_writei+0x147>
{
  uint tot, m, i, j;
  struct buf *tbp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  103485:	98                   	cwtl   
  103486:	8b 04 c5 04 bf 10 00 	mov    0x10bf04(,%eax,8),%eax
  10348d:	85 c0                	test   %eax,%eax
  10348f:	74 d9                	je     10346a <log_writei+0x19a>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  103491:	89 75 10             	mov    %esi,0x10(%ebp)

  log_end();

  return n;

}
  103494:	83 c4 3c             	add    $0x3c,%esp
  103497:	5b                   	pop    %ebx
  103498:	5e                   	pop    %esi
  103499:	5f                   	pop    %edi
  10349a:	5d                   	pop    %ebp
  struct buf *tbp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  10349b:	ff e0                	jmp    *%eax
  10349d:	8d 76 00             	lea    0x0(%esi),%esi

001034a0 <log_initialize>:
  iunlock(ip);
}

void
log_initialize()
{
  1034a0:	55                   	push   %ebp
  1034a1:	31 c0                	xor    %eax,%eax
  1034a3:	89 e5                	mov    %esp,%ebp
  1034a5:	57                   	push   %edi
  1034a6:	56                   	push   %esi
  1034a7:	53                   	push   %ebx
  1034a8:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
  1034ae:	8d 9d 90 fd ff ff    	lea    -0x270(%ebp),%ebx
  1034b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i, j;
  struct buf *bp;
  struct trans_start t_blk;

  for(j=0;j<512;j++)
    buffer[j] = 0;
  1034b8:	c6 04 03 00          	movb   $0x0,(%ebx,%eax,1)
  uchar buffer[512];
  int i, j;
  struct buf *bp;
  struct trans_start t_blk;

  for(j=0;j<512;j++)
  1034bc:	83 c0 01             	add    $0x1,%eax
  1034bf:	3d 00 02 00 00       	cmp    $0x200,%eax
  1034c4:	75 f2                	jne    1034b8 <log_initialize+0x18>
    buffer[j] = 0;

  ip = iget(1, 3);
  1034c6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1034cd:	00 
  1034ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034d5:	e8 e6 e4 ff ff       	call   1019c0 <iget>
  1034da:	89 c6                	mov    %eax,%esi
  ilock(ip);
  1034dc:	89 04 24             	mov    %eax,(%esp)
  1034df:	e8 ec ea ff ff       	call   101fd0 <ilock>
  if(ip->size < 512*20){
  1034e4:	81 7e 18 ff 27 00 00 	cmpl   $0x27ff,0x18(%esi)
  1034eb:	77 4c                	ja     103539 <log_initialize+0x99>
    cprintf("Creating Journal...\n");
  1034ed:	c7 04 24 0f 78 10 00 	movl   $0x10780f,(%esp)
  1034f4:	31 ff                	xor    %edi,%edi
  1034f6:	e8 c5 d2 ff ff       	call   1007c0 <cprintf>
  1034fb:	90                   	nop
  1034fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<20;i++){
      writei(ip, buffer, i*512, sizeof(buffer));
  103500:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103504:	81 c7 00 02 00 00    	add    $0x200,%edi
  10350a:	c7 44 24 0c 00 02 00 	movl   $0x200,0xc(%esp)
  103511:	00 
  103512:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103516:	89 34 24             	mov    %esi,(%esp)
  103519:	e8 02 e2 ff ff       	call   101720 <writei>

  ip = iget(1, 3);
  ilock(ip);
  if(ip->size < 512*20){
    cprintf("Creating Journal...\n");
    for(i=0;i<20;i++){
  10351e:	81 ff 00 28 00 00    	cmp    $0x2800,%edi
  103524:	75 da                	jne    103500 <log_initialize+0x60>
      writei(ip, buffer, 0, sizeof(buffer));
      cprintf("Recovery Complete.\n");
    }
  }

  iunlock(ip);
  103526:	89 34 24             	mov    %esi,(%esp)
  103529:	e8 32 ea ff ff       	call   101f60 <iunlock>
}
  10352e:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  103534:	5b                   	pop    %ebx
  103535:	5e                   	pop    %esi
  103536:	5f                   	pop    %edi
  103537:	5d                   	pop    %ebp
  103538:	c3                   	ret    
    for(i=0;i<20;i++){
      writei(ip, buffer, i*512, sizeof(buffer));
    }
  }
  else {
    readi(ip, &t_blk, 0, sizeof(t_blk));
  103539:	8d 45 90             	lea    -0x70(%ebp),%eax
  10353c:	c7 44 24 0c 58 00 00 	movl   $0x58,0xc(%esp)
  103543:	00 
  103544:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10354b:	00 
  10354c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103550:	89 34 24             	mov    %esi,(%esp)
  103553:	e8 a8 e0 ff ff       	call   101600 <readi>

    if(t_blk.state == LOGGING){
  103558:	83 7d 90 01          	cmpl   $0x1,-0x70(%ebp)
  10355c:	75 c8                	jne    103526 <log_initialize+0x86>
      cprintf("Inconsistency found in file system. Attempting to recover.\n");
  10355e:	c7 04 24 38 78 10 00 	movl   $0x107838,(%esp)

      for(i = 0; i < t_blk.num_blks; i++){
  103565:	31 ff                	xor    %edi,%edi
  }
  else {
    readi(ip, &t_blk, 0, sizeof(t_blk));

    if(t_blk.state == LOGGING){
      cprintf("Inconsistency found in file system. Attempting to recover.\n");
  103567:	e8 54 d2 ff ff       	call   1007c0 <cprintf>

      for(i = 0; i < t_blk.num_blks; i++){
  10356c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10356f:	85 c0                	test   %eax,%eax
  103571:	0f 84 91 00 00 00    	je     103608 <log_initialize+0x168>
  103577:	90                   	nop
    	  readi(ip, buffer, i*512+512, sizeof(buffer));
  103578:	83 c7 01             	add    $0x1,%edi
  10357b:	89 f8                	mov    %edi,%eax
  10357d:	c1 e0 09             	shl    $0x9,%eax
  103580:	c7 44 24 0c 00 02 00 	movl   $0x200,0xc(%esp)
  103587:	00 
  103588:	89 44 24 08          	mov    %eax,0x8(%esp)
  10358c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103590:	89 34 24             	mov    %esi,(%esp)
  103593:	e8 68 e0 ff ff       	call   101600 <readi>
    	  bp = bread(1, t_blk.sector[i]);
  103598:	8b 44 bd 94          	mov    -0x6c(%ebp,%edi,4),%eax
  10359c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035a7:	e8 84 cb ff ff       	call   100130 <bread>
    	  cprintf("Recovering data in sector: %d\n", t_blk.sector[i]);
  1035ac:	c7 04 24 74 78 10 00 	movl   $0x107874,(%esp)
    if(t_blk.state == LOGGING){
      cprintf("Inconsistency found in file system. Attempting to recover.\n");

      for(i = 0; i < t_blk.num_blks; i++){
    	  readi(ip, buffer, i*512+512, sizeof(buffer));
    	  bp = bread(1, t_blk.sector[i]);
  1035b3:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
    	  cprintf("Recovering data in sector: %d\n", t_blk.sector[i]);
  1035b9:	8b 44 bd 94          	mov    -0x6c(%ebp,%edi,4),%eax
  1035bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c1:	e8 fa d1 ff ff       	call   1007c0 <cprintf>
    	  memmove(bp->data, buffer, sizeof(buffer));
  1035c6:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  1035cc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  1035d3:	00 
  1035d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1035d8:	83 c0 18             	add    $0x18,%eax
  1035db:	89 04 24             	mov    %eax,(%esp)
  1035de:	e8 cd 1c 00 00       	call   1052b0 <memmove>
    	  bwrite(bp);
  1035e3:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  1035e9:	89 04 24             	mov    %eax,(%esp)
  1035ec:	e8 0f cb ff ff       	call   100100 <bwrite>
    	  brelse(bp);
  1035f1:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  1035f7:	89 04 24             	mov    %eax,(%esp)
  1035fa:	e8 01 ca ff ff       	call   100000 <brelse>
    readi(ip, &t_blk, 0, sizeof(t_blk));

    if(t_blk.state == LOGGING){
      cprintf("Inconsistency found in file system. Attempting to recover.\n");

      for(i = 0; i < t_blk.num_blks; i++){
  1035ff:	39 7d 94             	cmp    %edi,-0x6c(%ebp)
  103602:	0f 87 70 ff ff ff    	ja     103578 <log_initialize+0xd8>
    	  memmove(bp->data, buffer, sizeof(buffer));
    	  bwrite(bp);
    	  brelse(bp);
      }

      writei(ip, buffer, 0, sizeof(buffer));
  103608:	c7 44 24 0c 00 02 00 	movl   $0x200,0xc(%esp)
  10360f:	00 
  103610:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103617:	00 
  103618:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10361c:	89 34 24             	mov    %esi,(%esp)
  10361f:	e8 fc e0 ff ff       	call   101720 <writei>
      cprintf("Recovery Complete.\n");
  103624:	c7 04 24 24 78 10 00 	movl   $0x107824,(%esp)
  10362b:	e8 90 d1 ff ff       	call   1007c0 <cprintf>
  103630:	e9 f1 fe ff ff       	jmp    103526 <log_initialize+0x86>
  103635:	90                   	nop
  103636:	90                   	nop
  103637:	90                   	nop
  103638:	90                   	nop
  103639:	90                   	nop
  10363a:	90                   	nop
  10363b:	90                   	nop
  10363c:	90                   	nop
  10363d:	90                   	nop
  10363e:	90                   	nop
  10363f:	90                   	nop

00103640 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  103640:	55                   	push   %ebp
  103641:	89 e5                	mov    %esp,%ebp
  103643:	53                   	push   %ebx
  103644:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  103647:	e8 a4 f5 ff ff       	call   102bf0 <cpu>
  10364c:	c7 04 24 93 78 10 00 	movl   $0x107893,(%esp)
  103653:	89 44 24 04          	mov    %eax,0x4(%esp)
  103657:	e8 64 d1 ff ff       	call   1007c0 <cprintf>
  idtinit();
  10365c:	e8 6f 2f 00 00       	call   1065d0 <idtinit>
  if(cpu() != mp_bcpu())
  103661:	e8 8a f5 ff ff       	call   102bf0 <cpu>
  103666:	89 c3                	mov    %eax,%ebx
  103668:	e8 c3 01 00 00       	call   103830 <mp_bcpu>
  10366d:	39 c3                	cmp    %eax,%ebx
  10366f:	74 0d                	je     10367e <mpmain+0x3e>
  lapic_init(cpu());
  103671:	e8 7a f5 ff ff       	call   102bf0 <cpu>
  103676:	89 04 24             	mov    %eax,(%esp)
  103679:	e8 f2 f2 ff ff       	call   102970 <lapic_init>
  setupsegs(0);
  10367e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103685:	e8 c6 10 00 00       	call   104750 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  10368a:	e8 61 f5 ff ff       	call   102bf0 <cpu>
  10368f:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103695:	b8 01 00 00 00       	mov    $0x1,%eax
  10369a:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  1036a0:	f0 87 82 00 d0 10 00 	lock xchg %eax,0x10d000(%edx)

  //log_open(O_RDONLY);

  cprintf("cpu%d: scheduling\n", cpu());
  1036a7:	e8 44 f5 ff ff       	call   102bf0 <cpu>
  1036ac:	c7 04 24 a2 78 10 00 	movl   $0x1078a2,(%esp)
  1036b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036b7:	e8 04 d1 ff ff       	call   1007c0 <cprintf>
  scheduler();
  1036bc:	e8 6f 12 00 00       	call   104930 <scheduler>
  1036c1:	eb 0d                	jmp    1036d0 <main>
  1036c3:	90                   	nop
  1036c4:	90                   	nop
  1036c5:	90                   	nop
  1036c6:	90                   	nop
  1036c7:	90                   	nop
  1036c8:	90                   	nop
  1036c9:	90                   	nop
  1036ca:	90                   	nop
  1036cb:	90                   	nop
  1036cc:	90                   	nop
  1036cd:	90                   	nop
  1036ce:	90                   	nop
  1036cf:	90                   	nop

001036d0 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  1036d0:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  1036d1:	b8 04 06 11 00       	mov    $0x110604,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  1036d6:	89 e5                	mov    %esp,%ebp
  1036d8:	83 e4 f0             	and    $0xfffffff0,%esp
  1036db:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  1036dc:	2d 8e 87 10 00       	sub    $0x10878e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  1036e1:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  1036e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036ef:	00 
  1036f0:	c7 04 24 8e 87 10 00 	movl   $0x10878e,(%esp)
  1036f7:	e8 24 1b 00 00       	call   105220 <memset>

  mp_init(); // collect info about this machine
  1036fc:	e8 bf 01 00 00       	call   1038c0 <mp_init>
  lapic_init(mp_bcpu());
  103701:	e8 2a 01 00 00       	call   103830 <mp_bcpu>
  103706:	89 04 24             	mov    %eax,(%esp)
  103709:	e8 62 f2 ff ff       	call   102970 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  10370e:	e8 dd f4 ff ff       	call   102bf0 <cpu>
  103713:	c7 04 24 b5 78 10 00 	movl   $0x1078b5,(%esp)
  10371a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10371e:	e8 9d d0 ff ff       	call   1007c0 <cprintf>

  pinit();         // process table
  103723:	e8 a8 18 00 00       	call   104fd0 <pinit>
  binit();         // buffer cache
  103728:	e8 e3 ca ff ff       	call   100210 <binit>
  10372d:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  103730:	e8 8b 03 00 00       	call   103ac0 <pic_init>
  ioapic_init();   // another interrupt controller
  103735:	e8 56 ee ff ff       	call   102590 <ioapic_init>
  kinit();         // physical memory allocator
  10373a:	e8 f1 f0 ff ff       	call   102830 <kinit>
  10373f:	90                   	nop
  tvinit();        // trap vectors
  103740:	e8 3b 31 00 00       	call   106880 <tvinit>
  fileinit();      // file table
  103745:	e8 76 da ff ff       	call   1011c0 <fileinit>
  iinit();         // inode cache
  10374a:	e8 41 eb ff ff       	call   102290 <iinit>
  10374f:	90                   	nop
  console_init();  // I/O devices & their interrupts
  103750:	e8 2b cb ff ff       	call   100280 <console_init>
  ide_init();      // disk
  103755:	e8 66 ed ff ff       	call   1024c0 <ide_init>
  if(!ismp)
  10375a:	a1 e0 cf 10 00       	mov    0x10cfe0,%eax
  10375f:	85 c0                	test   %eax,%eax
  103761:	0f 84 b1 00 00 00    	je     103818 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  103767:	e8 74 17 00 00       	call   104ee0 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  10376c:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  103773:	00 
  103774:	c7 44 24 04 34 87 10 	movl   $0x108734,0x4(%esp)
  10377b:	00 
  10377c:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  103783:	e8 28 1b 00 00       	call   1052b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  103788:	69 05 60 d6 10 00 cc 	imul   $0xcc,0x10d660,%eax
  10378f:	00 00 00 
  103792:	05 00 d0 10 00       	add    $0x10d000,%eax
  103797:	3d 00 d0 10 00       	cmp    $0x10d000,%eax
  10379c:	76 75                	jbe    103813 <main+0x143>
  10379e:	bb 00 d0 10 00       	mov    $0x10d000,%ebx
  1037a3:	90                   	nop
  1037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  1037a8:	e8 43 f4 ff ff       	call   102bf0 <cpu>
  1037ad:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1037b3:	05 00 d0 10 00       	add    $0x10d000,%eax
  1037b8:	39 c3                	cmp    %eax,%ebx
  1037ba:	74 3e                	je     1037fa <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  1037bc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1037c3:	e8 78 ee ff ff       	call   102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  1037c8:	c7 05 f8 6f 00 00 40 	movl   $0x103640,0x6ff8
  1037cf:	36 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  1037d2:	05 00 10 00 00       	add    $0x1000,%eax
  1037d7:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  1037dc:	0f b6 03             	movzbl (%ebx),%eax
  1037df:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  1037e6:	00 
  1037e7:	89 04 24             	mov    %eax,(%esp)
  1037ea:	e8 91 f2 ff ff       	call   102a80 <lapic_startap>
  1037ef:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  1037f0:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  1037f6:	85 c0                	test   %eax,%eax
  1037f8:	74 f6                	je     1037f0 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  1037fa:	69 05 60 d6 10 00 cc 	imul   $0xcc,0x10d660,%eax
  103801:	00 00 00 
  103804:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  10380a:	05 00 d0 10 00       	add    $0x10d000,%eax
  10380f:	39 c3                	cmp    %eax,%ebx
  103811:	72 95                	jb     1037a8 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  103813:	e8 28 fe ff ff       	call   103640 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  103818:	e8 53 2d 00 00       	call   106570 <timer_init>
  10381d:	8d 76 00             	lea    0x0(%esi),%esi
  103820:	e9 42 ff ff ff       	jmp    103767 <main+0x97>
  103825:	90                   	nop
  103826:	90                   	nop
  103827:	90                   	nop
  103828:	90                   	nop
  103829:	90                   	nop
  10382a:	90                   	nop
  10382b:	90                   	nop
  10382c:	90                   	nop
  10382d:	90                   	nop
  10382e:	90                   	nop
  10382f:	90                   	nop

00103830 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  103830:	a1 44 88 10 00       	mov    0x108844,%eax
  103835:	55                   	push   %ebp
  103836:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  103838:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  103839:	2d 00 d0 10 00       	sub    $0x10d000,%eax
  10383e:	c1 f8 02             	sar    $0x2,%eax
  103841:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  103847:	c3                   	ret    
  103848:	90                   	nop
  103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103850 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103850:	55                   	push   %ebp
  103851:	89 e5                	mov    %esp,%ebp
  103853:	56                   	push   %esi
  103854:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  103855:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103858:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  10385b:	39 f0                	cmp    %esi,%eax
  10385d:	73 42                	jae    1038a1 <mp_search1+0x51>
  10385f:	89 c3                	mov    %eax,%ebx
  103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  103868:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  10386f:	00 
  103870:	c7 44 24 04 cc 78 10 	movl   $0x1078cc,0x4(%esp)
  103877:	00 
  103878:	89 1c 24             	mov    %ebx,(%esp)
  10387b:	e8 d0 19 00 00       	call   105250 <memcmp>
  103880:	85 c0                	test   %eax,%eax
  103882:	75 16                	jne    10389a <mp_search1+0x4a>
  103884:	31 d2                	xor    %edx,%edx
  103886:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  103888:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  10388c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  10388f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103891:	83 f8 10             	cmp    $0x10,%eax
  103894:	75 f2                	jne    103888 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  103896:	84 d2                	test   %dl,%dl
  103898:	74 10                	je     1038aa <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  10389a:	83 c3 10             	add    $0x10,%ebx
  10389d:	39 de                	cmp    %ebx,%esi
  10389f:	77 c7                	ja     103868 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  1038a1:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  1038a4:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  1038a6:	5b                   	pop    %ebx
  1038a7:	5e                   	pop    %esi
  1038a8:	5d                   	pop    %ebp
  1038a9:	c3                   	ret    
  1038aa:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  1038ad:	89 d8                	mov    %ebx,%eax
  return 0;
}
  1038af:	5b                   	pop    %ebx
  1038b0:	5e                   	pop    %esi
  1038b1:	5d                   	pop    %ebp
  1038b2:	c3                   	ret    
  1038b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001038c0 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  1038c0:	55                   	push   %ebp
  1038c1:	89 e5                	mov    %esp,%ebp
  1038c3:	57                   	push   %edi
  1038c4:	56                   	push   %esi
  1038c5:	53                   	push   %ebx
  1038c6:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  1038c9:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  1038d0:	69 05 60 d6 10 00 cc 	imul   $0xcc,0x10d660,%eax
  1038d7:	00 00 00 
  1038da:	05 00 d0 10 00       	add    $0x10d000,%eax
  1038df:	a3 44 88 10 00       	mov    %eax,0x108844
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  1038e4:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  1038eb:	c1 e0 08             	shl    $0x8,%eax
  1038ee:	09 d0                	or     %edx,%eax
  1038f0:	c1 e0 04             	shl    $0x4,%eax
  1038f3:	85 c0                	test   %eax,%eax
  1038f5:	75 1b                	jne    103912 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  1038f7:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  1038fe:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  103905:	c1 e0 08             	shl    $0x8,%eax
  103908:	09 d0                	or     %edx,%eax
  10390a:	c1 e0 0a             	shl    $0xa,%eax
  10390d:	2d 00 04 00 00       	sub    $0x400,%eax
  103912:	ba 00 04 00 00       	mov    $0x400,%edx
  103917:	e8 34 ff ff ff       	call   103850 <mp_search1>
  10391c:	85 c0                	test   %eax,%eax
  10391e:	89 c3                	mov    %eax,%ebx
  103920:	0f 84 3a 01 00 00    	je     103a60 <mp_init+0x1a0>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103926:	8b 73 04             	mov    0x4(%ebx),%esi
  103929:	85 f6                	test   %esi,%esi
  10392b:	74 1c                	je     103949 <mp_init+0x89>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  10392d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  103934:	00 
  103935:	c7 44 24 04 d1 78 10 	movl   $0x1078d1,0x4(%esp)
  10393c:	00 
  10393d:	89 34 24             	mov    %esi,(%esp)
  103940:	e8 0b 19 00 00       	call   105250 <memcmp>
  103945:	85 c0                	test   %eax,%eax
  103947:	74 0f                	je     103958 <mp_init+0x98>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  103949:	83 c4 2c             	add    $0x2c,%esp
  10394c:	5b                   	pop    %ebx
  10394d:	5e                   	pop    %esi
  10394e:	5f                   	pop    %edi
  10394f:	5d                   	pop    %ebp
  103950:	c3                   	ret    
  103951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
  103958:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  10395c:	3c 04                	cmp    $0x4,%al
  10395e:	74 04                	je     103964 <mp_init+0xa4>
  103960:	3c 01                	cmp    $0x1,%al
  103962:	75 e5                	jne    103949 <mp_init+0x89>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  103964:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103968:	85 d2                	test   %edx,%edx
  10396a:	74 15                	je     103981 <mp_init+0xc1>
  10396c:	31 c9                	xor    %ecx,%ecx
  10396e:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  103970:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103974:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  103977:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103979:	39 c2                	cmp    %eax,%edx
  10397b:	7f f3                	jg     103970 <mp_init+0xb0>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  10397d:	84 c9                	test   %cl,%cl
  10397f:	75 c8                	jne    103949 <mp_init+0x89>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  103981:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103984:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  103987:	c7 05 e0 cf 10 00 01 	movl   $0x1,0x10cfe0
  10398e:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  103991:	a3 78 cf 10 00       	mov    %eax,0x10cf78

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103996:	8d 46 2c             	lea    0x2c(%esi),%eax
  103999:	39 d0                	cmp    %edx,%eax
  10399b:	73 5b                	jae    1039f8 <mp_init+0x138>
  10399d:	8b 35 44 88 10 00    	mov    0x108844,%esi
  1039a3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  1039a6:	0f b6 08             	movzbl (%eax),%ecx
  1039a9:	80 f9 04             	cmp    $0x4,%cl
  1039ac:	76 2a                	jbe    1039d8 <mp_init+0x118>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  1039ae:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  1039b1:	89 35 44 88 10 00    	mov    %esi,0x108844
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  1039b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1039bb:	c7 04 24 e0 78 10 00 	movl   $0x1078e0,(%esp)
  1039c2:	e8 f9 cd ff ff       	call   1007c0 <cprintf>
      panic("mp_init");
  1039c7:	c7 04 24 d6 78 10 00 	movl   $0x1078d6,(%esp)
  1039ce:	e8 8d cf ff ff       	call   100960 <panic>
  1039d3:	90                   	nop
  1039d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  1039d8:	0f b6 c9             	movzbl %cl,%ecx
  1039db:	ff 24 8d 04 79 10 00 	jmp    *0x107904(,%ecx,4)
  1039e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  1039e8:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  1039eb:	39 c2                	cmp    %eax,%edx
  1039ed:	77 b7                	ja     1039a6 <mp_init+0xe6>
  1039ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  1039f2:	89 35 44 88 10 00    	mov    %esi,0x108844
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  1039f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  1039fc:	0f 84 47 ff ff ff    	je     103949 <mp_init+0x89>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103a02:	ba 22 00 00 00       	mov    $0x22,%edx
  103a07:	b8 70 00 00 00       	mov    $0x70,%eax
  103a0c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103a0d:	b2 23                	mov    $0x23,%dl
  103a0f:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103a10:	83 c8 01             	or     $0x1,%eax
  103a13:	ee                   	out    %al,(%dx)
  103a14:	e9 30 ff ff ff       	jmp    103949 <mp_init+0x89>
  103a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  103a20:	8b 0d 60 d6 10 00    	mov    0x10d660,%ecx
  103a26:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  103a2a:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  103a30:	88 9f 00 d0 10 00    	mov    %bl,0x10d000(%edi)
      if(proc->flags & MPBOOT)
  103a36:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  103a3a:	74 06                	je     103a42 <mp_init+0x182>
        bcpu = &cpus[ncpu];
  103a3c:	8d b7 00 d0 10 00    	lea    0x10d000(%edi),%esi
      ncpu++;
  103a42:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  103a45:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  103a48:	89 0d 60 d6 10 00    	mov    %ecx,0x10d660
      p += sizeof(struct mpproc);
      continue;
  103a4e:	eb 9b                	jmp    1039eb <mp_init+0x12b>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103a50:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  103a54:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103a57:	88 0d e4 cf 10 00    	mov    %cl,0x10cfe4
      p += sizeof(struct mpioapic);
      continue;
  103a5d:	eb 8c                	jmp    1039eb <mp_init+0x12b>
  103a5f:	90                   	nop
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103a60:	ba 00 00 01 00       	mov    $0x10000,%edx
  103a65:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  103a6a:	e8 e1 fd ff ff       	call   103850 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103a6f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103a71:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103a73:	0f 85 ad fe ff ff    	jne    103926 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  103a79:	83 c4 2c             	add    $0x2c,%esp
  103a7c:	5b                   	pop    %ebx
  103a7d:	5e                   	pop    %esi
  103a7e:	5f                   	pop    %edi
  103a7f:	5d                   	pop    %ebp
  103a80:	c3                   	ret    
  103a81:	90                   	nop
  103a82:	90                   	nop
  103a83:	90                   	nop
  103a84:	90                   	nop
  103a85:	90                   	nop
  103a86:	90                   	nop
  103a87:	90                   	nop
  103a88:	90                   	nop
  103a89:	90                   	nop
  103a8a:	90                   	nop
  103a8b:	90                   	nop
  103a8c:	90                   	nop
  103a8d:	90                   	nop
  103a8e:	90                   	nop
  103a8f:	90                   	nop

00103a90 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103a90:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  103a91:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103a96:	89 e5                	mov    %esp,%ebp
  103a98:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  103a9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103aa0:	d3 c0                	rol    %cl,%eax
  103aa2:	66 23 05 00 83 10 00 	and    0x108300,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  103aa9:	66 a3 00 83 10 00    	mov    %ax,0x108300
  103aaf:	ee                   	out    %al,(%dx)
  103ab0:	66 c1 e8 08          	shr    $0x8,%ax
  103ab4:	b2 a1                	mov    $0xa1,%dl
  103ab6:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  103ab7:	5d                   	pop    %ebp
  103ab8:	c3                   	ret    
  103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103ac0 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  103ac0:	55                   	push   %ebp
  103ac1:	b9 21 00 00 00       	mov    $0x21,%ecx
  103ac6:	89 e5                	mov    %esp,%ebp
  103ac8:	83 ec 0c             	sub    $0xc,%esp
  103acb:	89 1c 24             	mov    %ebx,(%esp)
  103ace:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103ad3:	89 ca                	mov    %ecx,%edx
  103ad5:	89 74 24 04          	mov    %esi,0x4(%esp)
  103ad9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103add:	ee                   	out    %al,(%dx)
  103ade:	bb a1 00 00 00       	mov    $0xa1,%ebx
  103ae3:	89 da                	mov    %ebx,%edx
  103ae5:	ee                   	out    %al,(%dx)
  103ae6:	be 11 00 00 00       	mov    $0x11,%esi
  103aeb:	b2 20                	mov    $0x20,%dl
  103aed:	89 f0                	mov    %esi,%eax
  103aef:	ee                   	out    %al,(%dx)
  103af0:	b8 20 00 00 00       	mov    $0x20,%eax
  103af5:	89 ca                	mov    %ecx,%edx
  103af7:	ee                   	out    %al,(%dx)
  103af8:	b8 04 00 00 00       	mov    $0x4,%eax
  103afd:	ee                   	out    %al,(%dx)
  103afe:	bf 03 00 00 00       	mov    $0x3,%edi
  103b03:	89 f8                	mov    %edi,%eax
  103b05:	ee                   	out    %al,(%dx)
  103b06:	b1 a0                	mov    $0xa0,%cl
  103b08:	89 f0                	mov    %esi,%eax
  103b0a:	89 ca                	mov    %ecx,%edx
  103b0c:	ee                   	out    %al,(%dx)
  103b0d:	b8 28 00 00 00       	mov    $0x28,%eax
  103b12:	89 da                	mov    %ebx,%edx
  103b14:	ee                   	out    %al,(%dx)
  103b15:	b8 02 00 00 00       	mov    $0x2,%eax
  103b1a:	ee                   	out    %al,(%dx)
  103b1b:	89 f8                	mov    %edi,%eax
  103b1d:	ee                   	out    %al,(%dx)
  103b1e:	be 68 00 00 00       	mov    $0x68,%esi
  103b23:	b2 20                	mov    $0x20,%dl
  103b25:	89 f0                	mov    %esi,%eax
  103b27:	ee                   	out    %al,(%dx)
  103b28:	bb 0a 00 00 00       	mov    $0xa,%ebx
  103b2d:	89 d8                	mov    %ebx,%eax
  103b2f:	ee                   	out    %al,(%dx)
  103b30:	89 f0                	mov    %esi,%eax
  103b32:	89 ca                	mov    %ecx,%edx
  103b34:	ee                   	out    %al,(%dx)
  103b35:	89 d8                	mov    %ebx,%eax
  103b37:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  103b38:	0f b7 05 00 83 10 00 	movzwl 0x108300,%eax
  103b3f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  103b43:	74 0a                	je     103b4f <pic_init+0x8f>
  103b45:	b2 21                	mov    $0x21,%dl
  103b47:	ee                   	out    %al,(%dx)
  103b48:	66 c1 e8 08          	shr    $0x8,%ax
  103b4c:	b2 a1                	mov    $0xa1,%dl
  103b4e:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  103b4f:	8b 1c 24             	mov    (%esp),%ebx
  103b52:	8b 74 24 04          	mov    0x4(%esp),%esi
  103b56:	8b 7c 24 08          	mov    0x8(%esp),%edi
  103b5a:	89 ec                	mov    %ebp,%esp
  103b5c:	5d                   	pop    %ebp
  103b5d:	c3                   	ret    
  103b5e:	90                   	nop
  103b5f:	90                   	nop

00103b60 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  103b60:	55                   	push   %ebp
  103b61:	89 e5                	mov    %esp,%ebp
  103b63:	57                   	push   %edi
  103b64:	56                   	push   %esi
  103b65:	53                   	push   %ebx
  103b66:	83 ec 2c             	sub    $0x2c,%esp
  103b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  103b6c:	8d 73 10             	lea    0x10(%ebx),%esi
  103b6f:	89 34 24             	mov    %esi,(%esp)
  103b72:	e8 39 16 00 00       	call   1051b0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  103b77:	8b 53 0c             	mov    0xc(%ebx),%edx
  103b7a:	3b 53 08             	cmp    0x8(%ebx),%edx
  103b7d:	75 51                	jne    103bd0 <piperead+0x70>
  103b7f:	8b 4b 04             	mov    0x4(%ebx),%ecx
  103b82:	85 c9                	test   %ecx,%ecx
  103b84:	74 4a                	je     103bd0 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  103b86:	8d 7b 0c             	lea    0xc(%ebx),%edi
  103b89:	eb 20                	jmp    103bab <piperead+0x4b>
  103b8b:	90                   	nop
  103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103b90:	89 74 24 04          	mov    %esi,0x4(%esp)
  103b94:	89 3c 24             	mov    %edi,(%esp)
  103b97:	e8 94 08 00 00       	call   104430 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  103b9c:	8b 53 0c             	mov    0xc(%ebx),%edx
  103b9f:	3b 53 08             	cmp    0x8(%ebx),%edx
  103ba2:	75 2c                	jne    103bd0 <piperead+0x70>
  103ba4:	8b 43 04             	mov    0x4(%ebx),%eax
  103ba7:	85 c0                	test   %eax,%eax
  103ba9:	74 25                	je     103bd0 <piperead+0x70>
    if(cp->killed){
  103bab:	e8 d0 05 00 00       	call   104180 <curproc>
  103bb0:	8b 40 1c             	mov    0x1c(%eax),%eax
  103bb3:	85 c0                	test   %eax,%eax
  103bb5:	74 d9                	je     103b90 <piperead+0x30>
      release(&p->lock);
  103bb7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  103bbc:	89 34 24             	mov    %esi,(%esp)
  103bbf:	e8 ac 15 00 00       	call   105170 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  103bc4:	83 c4 2c             	add    $0x2c,%esp
  103bc7:	89 f8                	mov    %edi,%eax
  103bc9:	5b                   	pop    %ebx
  103bca:	5e                   	pop    %esi
  103bcb:	5f                   	pop    %edi
  103bcc:	5d                   	pop    %ebp
  103bcd:	c3                   	ret    
  103bce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103bd0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103bd3:	85 c9                	test   %ecx,%ecx
  103bd5:	7e 5a                	jle    103c31 <piperead+0xd1>
    if(p->readp == p->writep)
  103bd7:	31 ff                	xor    %edi,%edi
  103bd9:	3b 53 08             	cmp    0x8(%ebx),%edx
  103bdc:	74 53                	je     103c31 <piperead+0xd1>
  103bde:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  103be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103be4:	8b 75 10             	mov    0x10(%ebp),%esi
  103be7:	eb 0c                	jmp    103bf5 <piperead+0x95>
  103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103bf0:	39 53 08             	cmp    %edx,0x8(%ebx)
  103bf3:	74 1c                	je     103c11 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103bf5:	89 d0                	mov    %edx,%eax
  103bf7:	83 c2 01             	add    $0x1,%edx
  103bfa:	25 ff 01 00 00       	and    $0x1ff,%eax
  103bff:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  103c04:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103c07:	83 c7 01             	add    $0x1,%edi
  103c0a:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103c0c:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103c0f:	7f df                	jg     103bf0 <piperead+0x90>
  103c11:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  103c14:	83 c3 08             	add    $0x8,%ebx
  103c17:	89 1c 24             	mov    %ebx,(%esp)
  103c1a:	e8 61 04 00 00       	call   104080 <wakeup>
  release(&p->lock);
  103c1f:	89 34 24             	mov    %esi,(%esp)
  103c22:	e8 49 15 00 00       	call   105170 <release>
  return i;
}
  103c27:	83 c4 2c             	add    $0x2c,%esp
  103c2a:	89 f8                	mov    %edi,%eax
  103c2c:	5b                   	pop    %ebx
  103c2d:	5e                   	pop    %esi
  103c2e:	5f                   	pop    %edi
  103c2f:	5d                   	pop    %ebp
  103c30:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103c31:	31 ff                	xor    %edi,%edi
  103c33:	eb df                	jmp    103c14 <piperead+0xb4>
  103c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103c40 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  103c40:	55                   	push   %ebp
  103c41:	89 e5                	mov    %esp,%ebp
  103c43:	57                   	push   %edi
  103c44:	56                   	push   %esi
  103c45:	53                   	push   %ebx
  103c46:	83 ec 3c             	sub    $0x3c,%esp
  103c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  103c4c:	8d 73 10             	lea    0x10(%ebx),%esi
  103c4f:	89 34 24             	mov    %esi,(%esp)
  103c52:	e8 59 15 00 00       	call   1051b0 <acquire>
  for(i = 0; i < n; i++){
  103c57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103c5a:	85 c9                	test   %ecx,%ecx
  103c5c:	0f 8e d0 00 00 00    	jle    103d32 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103c62:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103c65:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103c68:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103c6b:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  103c6e:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  103c71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103c78:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  103c7b:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103c81:	39 c8                	cmp    %ecx,%eax
  103c83:	75 66                	jne    103ceb <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  103c85:	8b 3b                	mov    (%ebx),%edi
  103c87:	85 ff                	test   %edi,%edi
  103c89:	74 3e                	je     103cc9 <pipewrite+0x89>
  103c8b:	8b 7d d0             	mov    -0x30(%ebp),%edi
  103c8e:	eb 2d                	jmp    103cbd <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  103c90:	89 3c 24             	mov    %edi,(%esp)
  103c93:	e8 e8 03 00 00       	call   104080 <wakeup>
      sleep(&p->writep, &p->lock);
  103c98:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103c9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  103c9f:	89 0c 24             	mov    %ecx,(%esp)
  103ca2:	e8 89 07 00 00       	call   104430 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  103ca7:	8b 53 0c             	mov    0xc(%ebx),%edx
  103caa:	8b 43 08             	mov    0x8(%ebx),%eax
  103cad:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103cb3:	39 c8                	cmp    %ecx,%eax
  103cb5:	75 31                	jne    103ce8 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  103cb7:	8b 13                	mov    (%ebx),%edx
  103cb9:	85 d2                	test   %edx,%edx
  103cbb:	74 0c                	je     103cc9 <pipewrite+0x89>
  103cbd:	e8 be 04 00 00       	call   104180 <curproc>
  103cc2:	8b 40 1c             	mov    0x1c(%eax),%eax
  103cc5:	85 c0                	test   %eax,%eax
  103cc7:	74 c7                	je     103c90 <pipewrite+0x50>
        release(&p->lock);
  103cc9:	89 34 24             	mov    %esi,(%esp)
  103ccc:	e8 9f 14 00 00       	call   105170 <release>
  103cd1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  103cd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103cdb:	83 c4 3c             	add    $0x3c,%esp
  103cde:	5b                   	pop    %ebx
  103cdf:	5e                   	pop    %esi
  103ce0:	5f                   	pop    %edi
  103ce1:	5d                   	pop    %ebp
  103ce2:	c3                   	ret    
  103ce3:	90                   	nop
  103ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103ce8:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  103ceb:	89 c7                	mov    %eax,%edi
  103ced:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103cf0:	83 c0 01             	add    $0x1,%eax
  103cf3:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  103cf9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  103cfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103cff:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  103d03:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103d06:	89 43 08             	mov    %eax,0x8(%ebx)
  103d09:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103d0d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  103d11:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103d14:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  103d17:	0f 8f 5e ff ff ff    	jg     103c7b <pipewrite+0x3b>
  103d1d:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103d20:	89 3c 24             	mov    %edi,(%esp)
  103d23:	e8 58 03 00 00       	call   104080 <wakeup>
  release(&p->lock);
  103d28:	89 34 24             	mov    %esi,(%esp)
  103d2b:	e8 40 14 00 00       	call   105170 <release>
  return i;
  103d30:	eb a6                	jmp    103cd8 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  103d32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d39:	8d 7b 0c             	lea    0xc(%ebx),%edi
  103d3c:	eb e2                	jmp    103d20 <pipewrite+0xe0>
  103d3e:	66 90                	xchg   %ax,%ax

00103d40 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  103d40:	55                   	push   %ebp
  103d41:	89 e5                	mov    %esp,%ebp
  103d43:	83 ec 28             	sub    $0x28,%esp
  103d46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  103d4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  103d4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103d52:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  103d55:	8d 73 10             	lea    0x10(%ebx),%esi
  103d58:	89 34 24             	mov    %esi,(%esp)
  103d5b:	e8 50 14 00 00       	call   1051b0 <acquire>
  if(writable){
  103d60:	85 ff                	test   %edi,%edi
  103d62:	74 34                	je     103d98 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  103d64:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  103d67:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  103d6e:	89 04 24             	mov    %eax,(%esp)
  103d71:	e8 0a 03 00 00       	call   104080 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  103d76:	89 34 24             	mov    %esi,(%esp)
  103d79:	e8 f2 13 00 00       	call   105170 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  103d7e:	8b 3b                	mov    (%ebx),%edi
  103d80:	85 ff                	test   %edi,%edi
  103d82:	75 07                	jne    103d8b <pipeclose+0x4b>
  103d84:	8b 73 04             	mov    0x4(%ebx),%esi
  103d87:	85 f6                	test   %esi,%esi
  103d89:	74 25                	je     103db0 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  103d8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103d8e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103d91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103d94:	89 ec                	mov    %ebp,%esp
  103d96:	5d                   	pop    %ebp
  103d97:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  103d98:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  103d9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  103da1:	89 04 24             	mov    %eax,(%esp)
  103da4:	e8 d7 02 00 00       	call   104080 <wakeup>
  103da9:	eb cb                	jmp    103d76 <pipeclose+0x36>
  103dab:	90                   	nop
  103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103db0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  103db3:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103db6:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  103dbd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103dc0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103dc3:	89 ec                	mov    %ebp,%esp
  103dc5:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103dc6:	e9 45 e9 ff ff       	jmp    102710 <kfree>
  103dcb:	90                   	nop
  103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103dd0 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103dd0:	55                   	push   %ebp
  103dd1:	89 e5                	mov    %esp,%ebp
  103dd3:	57                   	push   %edi
  103dd4:	56                   	push   %esi
  103dd5:	53                   	push   %ebx
  103dd6:	83 ec 1c             	sub    $0x1c,%esp
  103dd9:	8b 75 08             	mov    0x8(%ebp),%esi
  103ddc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103ddf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  103de5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103deb:	e8 60 d2 ff ff       	call   101050 <filealloc>
  103df0:	85 c0                	test   %eax,%eax
  103df2:	89 06                	mov    %eax,(%esi)
  103df4:	0f 84 92 00 00 00    	je     103e8c <pipealloc+0xbc>
  103dfa:	e8 51 d2 ff ff       	call   101050 <filealloc>
  103dff:	85 c0                	test   %eax,%eax
  103e01:	89 03                	mov    %eax,(%ebx)
  103e03:	74 73                	je     103e78 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  103e05:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103e0c:	e8 2f e8 ff ff       	call   102640 <kalloc>
  103e11:	85 c0                	test   %eax,%eax
  103e13:	89 c7                	mov    %eax,%edi
  103e15:	74 61                	je     103e78 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  103e17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  103e1d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  103e24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  103e2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  103e32:	8d 40 10             	lea    0x10(%eax),%eax
  103e35:	89 04 24             	mov    %eax,(%esp)
  103e38:	c7 44 24 04 18 79 10 	movl   $0x107918,0x4(%esp)
  103e3f:	00 
  103e40:	e8 ab 11 00 00       	call   104ff0 <initlock>
  (*f0)->type = FD_PIPE;
  103e45:	8b 06                	mov    (%esi),%eax
  103e47:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  103e4d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  103e51:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  103e55:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  103e58:	8b 03                	mov    (%ebx),%eax
  103e5a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  103e60:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  103e64:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  103e68:	89 78 0c             	mov    %edi,0xc(%eax)
  103e6b:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  103e6d:	83 c4 1c             	add    $0x1c,%esp
  103e70:	5b                   	pop    %ebx
  103e71:	5e                   	pop    %esi
  103e72:	5f                   	pop    %edi
  103e73:	5d                   	pop    %ebp
  103e74:	c3                   	ret    
  103e75:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  103e78:	8b 06                	mov    (%esi),%eax
  103e7a:	85 c0                	test   %eax,%eax
  103e7c:	74 0e                	je     103e8c <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  103e7e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  103e84:	89 04 24             	mov    %eax,(%esp)
  103e87:	e8 54 d2 ff ff       	call   1010e0 <fileclose>
  }
  if(*f1){
  103e8c:	8b 13                	mov    (%ebx),%edx
  103e8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103e93:	85 d2                	test   %edx,%edx
  103e95:	74 d6                	je     103e6d <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  103e97:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  103e9d:	89 14 24             	mov    %edx,(%esp)
  103ea0:	e8 3b d2 ff ff       	call   1010e0 <fileclose>
  103ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103eaa:	eb c1                	jmp    103e6d <pipealloc+0x9d>
  103eac:	90                   	nop
  103ead:	90                   	nop
  103eae:	90                   	nop
  103eaf:	90                   	nop

00103eb0 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103eb0:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103eb1:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103eb6:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103eb8:	3d 80 d6 10 00       	cmp    $0x10d680,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103ebd:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103ec0:	76 3e                	jbe    103f00 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  103ec2:	b8 80 d6 10 00       	mov    $0x10d680,%eax
  103ec7:	eb 13                	jmp    103edc <wake_lock+0x2c>
  103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103ed0:	05 9c 00 00 00       	add    $0x9c,%eax
  103ed5:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  103eda:	74 24                	je     103f00 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  103edc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103ee0:	75 ee                	jne    103ed0 <wake_lock+0x20>
  103ee2:	39 50 10             	cmp    %edx,0x10(%eax)
  103ee5:	75 e9                	jne    103ed0 <wake_lock+0x20>
			p->state = RUNNABLE;
  103ee7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103eee:	05 9c 00 00 00       	add    $0x9c,%eax
  103ef3:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  103ef8:	75 e2                	jne    103edc <wake_lock+0x2c>
  103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  103f00:	5d                   	pop    %ebp
  103f01:	c3                   	ret    
  103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103f10 <tick>:
  }
}

int
tick(void)
{
  103f10:	55                   	push   %ebp
return ticks;
}
  103f11:	a1 00 06 11 00       	mov    0x110600,%eax
  }
}

int
tick(void)
{
  103f16:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103f18:	5d                   	pop    %ebp
  103f19:	c3                   	ret    
  103f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103f20:	55                   	push   %ebp
  103f21:	89 e5                	mov    %esp,%ebp
  103f23:	57                   	push   %edi
  103f24:	56                   	push   %esi
  103f25:	53                   	push   %ebx
  103f26:	bb 8c d6 10 00       	mov    $0x10d68c,%ebx
  103f2b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103f2e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103f31:	eb 50                	jmp    103f83 <procdump+0x63>
  103f33:	90                   	nop
  103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103f38:	8b 04 85 e0 79 10 00 	mov    0x1079e0(,%eax,4),%eax
  103f3f:	85 c0                	test   %eax,%eax
  103f41:	74 4e                	je     103f91 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103f43:	89 44 24 08          	mov    %eax,0x8(%esp)
  103f47:	8b 43 04             	mov    0x4(%ebx),%eax
  103f4a:	81 c2 88 00 00 00    	add    $0x88,%edx
  103f50:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103f54:	c7 04 24 21 79 10 00 	movl   $0x107921,(%esp)
  103f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f5f:	e8 5c c8 ff ff       	call   1007c0 <cprintf>
    if(p->state == SLEEPING){
  103f64:	83 3b 02             	cmpl   $0x2,(%ebx)
  103f67:	74 2f                	je     103f98 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103f69:	c7 04 24 ca 78 10 00 	movl   $0x1078ca,(%esp)
  103f70:	e8 4b c8 ff ff       	call   1007c0 <cprintf>
  103f75:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  103f7b:	81 fb 8c fd 10 00    	cmp    $0x10fd8c,%ebx
  103f81:	74 55                	je     103fd8 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  103f83:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103f85:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  103f88:	85 c0                	test   %eax,%eax
  103f8a:	74 e9                	je     103f75 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103f8c:	83 f8 05             	cmp    $0x5,%eax
  103f8f:	76 a7                	jbe    103f38 <procdump+0x18>
  103f91:	b8 1d 79 10 00       	mov    $0x10791d,%eax
  103f96:	eb ab                	jmp    103f43 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103f98:	8b 43 74             	mov    0x74(%ebx),%eax
  103f9b:	31 f6                	xor    %esi,%esi
  103f9d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103fa1:	83 c0 08             	add    $0x8,%eax
  103fa4:	89 04 24             	mov    %eax,(%esp)
  103fa7:	e8 64 10 00 00       	call   105010 <getcallerpcs>
  103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103fb0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103fb3:	85 c0                	test   %eax,%eax
  103fb5:	74 b2                	je     103f69 <procdump+0x49>
  103fb7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  103fba:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fbe:	c7 04 24 d5 73 10 00 	movl   $0x1073d5,(%esp)
  103fc5:	e8 f6 c7 ff ff       	call   1007c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  103fca:	83 fe 0a             	cmp    $0xa,%esi
  103fcd:	75 e1                	jne    103fb0 <procdump+0x90>
  103fcf:	eb 98                	jmp    103f69 <procdump+0x49>
  103fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103fd8:	83 c4 4c             	add    $0x4c,%esp
  103fdb:	5b                   	pop    %ebx
  103fdc:	5e                   	pop    %esi
  103fdd:	5f                   	pop    %edi
  103fde:	5d                   	pop    %ebp
  103fdf:	90                   	nop
  103fe0:	c3                   	ret    
  103fe1:	eb 0d                	jmp    103ff0 <kill>
  103fe3:	90                   	nop
  103fe4:	90                   	nop
  103fe5:	90                   	nop
  103fe6:	90                   	nop
  103fe7:	90                   	nop
  103fe8:	90                   	nop
  103fe9:	90                   	nop
  103fea:	90                   	nop
  103feb:	90                   	nop
  103fec:	90                   	nop
  103fed:	90                   	nop
  103fee:	90                   	nop
  103fef:	90                   	nop

00103ff0 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103ff0:	55                   	push   %ebp
  103ff1:	89 e5                	mov    %esp,%ebp
  103ff3:	53                   	push   %ebx
  103ff4:	83 ec 14             	sub    $0x14,%esp
  103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  103ffa:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104001:	e8 aa 11 00 00       	call   1051b0 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  104006:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10400b:	3d 80 d6 10 00       	cmp    $0x10d680,%eax
  104010:	76 56                	jbe    104068 <kill+0x78>
    if(p->pid == pid){
  104012:	39 1d 90 d6 10 00    	cmp    %ebx,0x10d690

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  104018:	b8 80 d6 10 00       	mov    $0x10d680,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10401d:	74 12                	je     104031 <kill+0x41>
  10401f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  104020:	05 9c 00 00 00       	add    $0x9c,%eax
  104025:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  10402a:	74 3c                	je     104068 <kill+0x78>
    if(p->pid == pid){
  10402c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10402f:	75 ef                	jne    104020 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  104031:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  104035:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10403c:	74 1a                	je     104058 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10403e:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104045:	e8 26 11 00 00       	call   105170 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10404a:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10404d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10404f:	5b                   	pop    %ebx
  104050:	5d                   	pop    %ebp
  104051:	c3                   	ret    
  104052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  104058:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  10405f:	eb dd                	jmp    10403e <kill+0x4e>
  104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  104068:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10406f:	e8 fc 10 00 00       	call   105170 <release>
  return -1;
}
  104074:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  104077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  10407c:	5b                   	pop    %ebx
  10407d:	5d                   	pop    %ebp
  10407e:	c3                   	ret    
  10407f:	90                   	nop

00104080 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  104080:	55                   	push   %ebp
  104081:	89 e5                	mov    %esp,%ebp
  104083:	53                   	push   %ebx
  104084:	83 ec 14             	sub    $0x14,%esp
  104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10408a:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104091:	e8 1a 11 00 00       	call   1051b0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104096:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10409b:	3d 80 d6 10 00       	cmp    $0x10d680,%eax
  1040a0:	76 3e                	jbe    1040e0 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1040a2:	b8 80 d6 10 00       	mov    $0x10d680,%eax
  1040a7:	eb 13                	jmp    1040bc <wakeup+0x3c>
  1040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1040b0:	05 9c 00 00 00       	add    $0x9c,%eax
  1040b5:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  1040ba:	74 24                	je     1040e0 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  1040bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1040c0:	75 ee                	jne    1040b0 <wakeup+0x30>
  1040c2:	3b 58 18             	cmp    0x18(%eax),%ebx
  1040c5:	75 e9                	jne    1040b0 <wakeup+0x30>
      p->state = RUNNABLE;
  1040c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1040ce:	05 9c 00 00 00       	add    $0x9c,%eax
  1040d3:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  1040d8:	75 e2                	jne    1040bc <wakeup+0x3c>
  1040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1040e0:	c7 45 08 80 fd 10 00 	movl   $0x10fd80,0x8(%ebp)
}
  1040e7:	83 c4 14             	add    $0x14,%esp
  1040ea:	5b                   	pop    %ebx
  1040eb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1040ec:	e9 7f 10 00 00       	jmp    105170 <release>
  1040f1:	eb 0d                	jmp    104100 <allocproc>
  1040f3:	90                   	nop
  1040f4:	90                   	nop
  1040f5:	90                   	nop
  1040f6:	90                   	nop
  1040f7:	90                   	nop
  1040f8:	90                   	nop
  1040f9:	90                   	nop
  1040fa:	90                   	nop
  1040fb:	90                   	nop
  1040fc:	90                   	nop
  1040fd:	90                   	nop
  1040fe:	90                   	nop
  1040ff:	90                   	nop

00104100 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  104100:	55                   	push   %ebp
  104101:	89 e5                	mov    %esp,%ebp
  104103:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  104104:	bb 80 d6 10 00       	mov    $0x10d680,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  104109:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10410c:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104113:	e8 98 10 00 00       	call   1051b0 <acquire>
  104118:	eb 14                	jmp    10412e <allocproc+0x2e>
  10411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  104120:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  104126:	81 fb 80 fd 10 00    	cmp    $0x10fd80,%ebx
  10412c:	74 32                	je     104160 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10412e:	8b 43 0c             	mov    0xc(%ebx),%eax
  104131:	85 c0                	test   %eax,%eax
  104133:	75 eb                	jne    104120 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  104135:	a1 04 83 10 00       	mov    0x108304,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10413a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  104141:	89 43 10             	mov    %eax,0x10(%ebx)
  104144:	83 c0 01             	add    $0x1,%eax
  104147:	a3 04 83 10 00       	mov    %eax,0x108304
      release(&proc_table_lock);
  10414c:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104153:	e8 18 10 00 00       	call   105170 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  104158:	89 d8                	mov    %ebx,%eax
  10415a:	83 c4 14             	add    $0x14,%esp
  10415d:	5b                   	pop    %ebx
  10415e:	5d                   	pop    %ebp
  10415f:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  104160:	31 db                	xor    %ebx,%ebx
  104162:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104169:	e8 02 10 00 00       	call   105170 <release>
  return 0;
}
  10416e:	89 d8                	mov    %ebx,%eax
  104170:	83 c4 14             	add    $0x14,%esp
  104173:	5b                   	pop    %ebx
  104174:	5d                   	pop    %ebp
  104175:	c3                   	ret    
  104176:	8d 76 00             	lea    0x0(%esi),%esi
  104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104180 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  104180:	55                   	push   %ebp
  104181:	89 e5                	mov    %esp,%ebp
  104183:	53                   	push   %ebx
  104184:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  104187:	e8 54 0f 00 00       	call   1050e0 <pushcli>
  p = cpus[cpu()].curproc;
  10418c:	e8 5f ea ff ff       	call   102bf0 <cpu>
  104191:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104197:	8b 98 04 d0 10 00    	mov    0x10d004(%eax),%ebx
  popcli();
  10419d:	e8 be 0e 00 00       	call   105060 <popcli>
  return p;
}
  1041a2:	83 c4 04             	add    $0x4,%esp
  1041a5:	89 d8                	mov    %ebx,%eax
  1041a7:	5b                   	pop    %ebx
  1041a8:	5d                   	pop    %ebp
  1041a9:	c3                   	ret    
  1041aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001041b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  1041b6:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  1041bd:	e8 ae 0f 00 00       	call   105170 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1041c2:	e8 b9 ff ff ff       	call   104180 <curproc>
  1041c7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1041cd:	89 04 24             	mov    %eax,(%esp)
  1041d0:	e8 e7 23 00 00       	call   1065bc <forkret1>
}
  1041d5:	c9                   	leave  
  1041d6:	c3                   	ret    
  1041d7:	89 f6                	mov    %esi,%esi
  1041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001041e0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1041e0:	55                   	push   %ebp
  1041e1:	89 e5                	mov    %esp,%ebp
  1041e3:	53                   	push   %ebx
  1041e4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1041e7:	9c                   	pushf  
  1041e8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1041e9:	f6 c4 02             	test   $0x2,%ah
  1041ec:	75 5c                	jne    10424a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1041ee:	e8 8d ff ff ff       	call   104180 <curproc>
  1041f3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1041f7:	74 75                	je     10426e <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1041f9:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104200:	e8 2b 0f 00 00       	call   105130 <holding>
  104205:	85 c0                	test   %eax,%eax
  104207:	74 59                	je     104262 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  104209:	e8 e2 e9 ff ff       	call   102bf0 <cpu>
  10420e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104214:	83 b8 c4 d0 10 00 01 	cmpl   $0x1,0x10d0c4(%eax)
  10421b:	75 39                	jne    104256 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10421d:	e8 ce e9 ff ff       	call   102bf0 <cpu>
  104222:	89 c3                	mov    %eax,%ebx
  104224:	e8 57 ff ff ff       	call   104180 <curproc>
  104229:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10422f:	81 c3 08 d0 10 00    	add    $0x10d008,%ebx
  104235:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104239:	83 c0 64             	add    $0x64,%eax
  10423c:	89 04 24             	mov    %eax,(%esp)
  10423f:	e8 d8 11 00 00       	call   10541c <swtch>
}
  104244:	83 c4 14             	add    $0x14,%esp
  104247:	5b                   	pop    %ebx
  104248:	5d                   	pop    %ebp
  104249:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10424a:	c7 04 24 2a 79 10 00 	movl   $0x10792a,(%esp)
  104251:	e8 0a c7 ff ff       	call   100960 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  104256:	c7 04 24 62 79 10 00 	movl   $0x107962,(%esp)
  10425d:	e8 fe c6 ff ff       	call   100960 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  104262:	c7 04 24 4c 79 10 00 	movl   $0x10794c,(%esp)
  104269:	e8 f2 c6 ff ff       	call   100960 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10426e:	c7 04 24 3e 79 10 00 	movl   $0x10793e,(%esp)
  104275:	e8 e6 c6 ff ff       	call   100960 <panic>
  10427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104280 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  104280:	55                   	push   %ebp
  104281:	89 e5                	mov    %esp,%ebp
  104283:	56                   	push   %esi
  104284:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  104285:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  104287:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  10428a:	e8 f1 fe ff ff       	call   104180 <curproc>
  10428f:	3b 05 48 88 10 00    	cmp    0x108848,%eax
  104295:	0f 84 36 01 00 00    	je     1043d1 <exit+0x151>
  10429b:	90                   	nop
  10429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1042a0:	e8 db fe ff ff       	call   104180 <curproc>
  1042a5:	8d 73 08             	lea    0x8(%ebx),%esi
  1042a8:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  1042ab:	85 d2                	test   %edx,%edx
  1042ad:	74 1c                	je     1042cb <exit+0x4b>
      fileclose(cp->ofile[fd]);
  1042af:	e8 cc fe ff ff       	call   104180 <curproc>
  1042b4:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1042b7:	89 04 24             	mov    %eax,(%esp)
  1042ba:	e8 21 ce ff ff       	call   1010e0 <fileclose>
      cp->ofile[fd] = 0;
  1042bf:	e8 bc fe ff ff       	call   104180 <curproc>
  1042c4:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1042cb:	83 c3 01             	add    $0x1,%ebx
  1042ce:	83 fb 10             	cmp    $0x10,%ebx
  1042d1:	75 cd                	jne    1042a0 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  1042d3:	e8 a8 fe ff ff       	call   104180 <curproc>
  1042d8:	8b 40 60             	mov    0x60(%eax),%eax
  1042db:	89 04 24             	mov    %eax,(%esp)
  1042de:	e8 9d d9 ff ff       	call   101c80 <iput>
  cp->cwd = 0;
  1042e3:	e8 98 fe ff ff       	call   104180 <curproc>
  1042e8:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  1042ef:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  1042f6:	e8 b5 0e 00 00       	call   1051b0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  1042fb:	e8 80 fe ff ff       	call   104180 <curproc>
  104300:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104303:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  104308:	3d 80 d6 10 00       	cmp    $0x10d680,%eax
  10430d:	0f 86 95 00 00 00    	jbe    1043a8 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  104313:	b8 80 d6 10 00       	mov    $0x10d680,%eax
  104318:	eb 12                	jmp    10432c <exit+0xac>
  10431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104320:	05 9c 00 00 00       	add    $0x9c,%eax
  104325:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  10432a:	74 1e                	je     10434a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  10432c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  104330:	75 ee                	jne    104320 <exit+0xa0>
  104332:	3b 50 18             	cmp    0x18(%eax),%edx
  104335:	75 e9                	jne    104320 <exit+0xa0>
      p->state = RUNNABLE;
  104337:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10433e:	05 9c 00 00 00       	add    $0x9c,%eax
  104343:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  104348:	75 e2                	jne    10432c <exit+0xac>
  10434a:	bb 80 d6 10 00       	mov    $0x10d680,%ebx
  10434f:	eb 15                	jmp    104366 <exit+0xe6>
  104351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  104358:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  10435e:	81 fb 80 fd 10 00    	cmp    $0x10fd80,%ebx
  104364:	74 42                	je     1043a8 <exit+0x128>
    if(p->parent == cp){
  104366:	8b 73 14             	mov    0x14(%ebx),%esi
  104369:	e8 12 fe ff ff       	call   104180 <curproc>
  10436e:	39 c6                	cmp    %eax,%esi
  104370:	75 e6                	jne    104358 <exit+0xd8>
      p->parent = initproc;
  104372:	8b 15 48 88 10 00    	mov    0x108848,%edx
      if(p->state == ZOMBIE)
  104378:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10437c:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  10437f:	75 d7                	jne    104358 <exit+0xd8>
  104381:	b8 80 d6 10 00       	mov    $0x10d680,%eax
  104386:	eb 0c                	jmp    104394 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104388:	05 9c 00 00 00       	add    $0x9c,%eax
  10438d:	3d 80 fd 10 00       	cmp    $0x10fd80,%eax
  104392:	74 c4                	je     104358 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  104394:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  104398:	75 ee                	jne    104388 <exit+0x108>
  10439a:	3b 50 18             	cmp    0x18(%eax),%edx
  10439d:	75 e9                	jne    104388 <exit+0x108>
      p->state = RUNNABLE;
  10439f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1043a6:	eb e0                	jmp    104388 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  1043a8:	e8 d3 fd ff ff       	call   104180 <curproc>
  1043ad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  1043b4:	e8 c7 fd ff ff       	call   104180 <curproc>
  1043b9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  1043c0:	e8 1b fe ff ff       	call   1041e0 <sched>
  panic("zombie exit");
  1043c5:	c7 04 24 7b 79 10 00 	movl   $0x10797b,(%esp)
  1043cc:	e8 8f c5 ff ff       	call   100960 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1043d1:	c7 04 24 6e 79 10 00 	movl   $0x10796e,(%esp)
  1043d8:	e8 83 c5 ff ff       	call   100960 <panic>
  1043dd:	8d 76 00             	lea    0x0(%esi),%esi

001043e0 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  1043e0:	55                   	push   %ebp
  1043e1:	89 e5                	mov    %esp,%ebp
  1043e3:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  1043e6:	e8 95 fd ff ff       	call   104180 <curproc>
  1043eb:	85 c0                	test   %eax,%eax
  1043ed:	74 2b                	je     10441a <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  1043ef:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  1043f6:	e8 b5 0d 00 00       	call   1051b0 <acquire>
  cp->state = SLEEPING;
  1043fb:	e8 80 fd ff ff       	call   104180 <curproc>
  104400:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  104407:	e8 d4 fd ff ff       	call   1041e0 <sched>
	release(&proc_table_lock); 
  10440c:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104413:	e8 58 0d 00 00       	call   105170 <release>
}
  104418:	c9                   	leave  
  104419:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  10441a:	c7 04 24 87 79 10 00 	movl   $0x107987,(%esp)
  104421:	e8 3a c5 ff ff       	call   100960 <panic>
  104426:	8d 76 00             	lea    0x0(%esi),%esi
  104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104430 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	56                   	push   %esi
  104434:	53                   	push   %ebx
  104435:	83 ec 10             	sub    $0x10,%esp
  104438:	8b 75 08             	mov    0x8(%ebp),%esi
  10443b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10443e:	e8 3d fd ff ff       	call   104180 <curproc>
  104443:	85 c0                	test   %eax,%eax
  104445:	0f 84 9d 00 00 00    	je     1044e8 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  10444b:	85 db                	test   %ebx,%ebx
  10444d:	0f 84 89 00 00 00    	je     1044dc <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  104453:	81 fb 80 fd 10 00    	cmp    $0x10fd80,%ebx
  104459:	74 55                	je     1044b0 <sleep+0x80>
    acquire(&proc_table_lock);
  10445b:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104462:	e8 49 0d 00 00       	call   1051b0 <acquire>
    release(lk);
  104467:	89 1c 24             	mov    %ebx,(%esp)
  10446a:	e8 01 0d 00 00       	call   105170 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  10446f:	e8 0c fd ff ff       	call   104180 <curproc>
  104474:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  104477:	e8 04 fd ff ff       	call   104180 <curproc>
  10447c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  104483:	e8 58 fd ff ff       	call   1041e0 <sched>

  // Tidy up.
  cp->chan = 0;
  104488:	e8 f3 fc ff ff       	call   104180 <curproc>
  10448d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  104494:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10449b:	e8 d0 0c 00 00       	call   105170 <release>
    acquire(lk);
  1044a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  1044a3:	83 c4 10             	add    $0x10,%esp
  1044a6:	5b                   	pop    %ebx
  1044a7:	5e                   	pop    %esi
  1044a8:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  1044a9:	e9 02 0d 00 00       	jmp    1051b0 <acquire>
  1044ae:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  1044b0:	e8 cb fc ff ff       	call   104180 <curproc>
  1044b5:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  1044b8:	e8 c3 fc ff ff       	call   104180 <curproc>
  1044bd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  1044c4:	e8 17 fd ff ff       	call   1041e0 <sched>

  // Tidy up.
  cp->chan = 0;
  1044c9:	e8 b2 fc ff ff       	call   104180 <curproc>
  1044ce:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  1044d5:	83 c4 10             	add    $0x10,%esp
  1044d8:	5b                   	pop    %ebx
  1044d9:	5e                   	pop    %esi
  1044da:	5d                   	pop    %ebp
  1044db:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  1044dc:	c7 04 24 8d 79 10 00 	movl   $0x10798d,(%esp)
  1044e3:	e8 78 c4 ff ff       	call   100960 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1044e8:	c7 04 24 87 79 10 00 	movl   $0x107987,(%esp)
  1044ef:	e8 6c c4 ff ff       	call   100960 <panic>
  1044f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1044fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104500 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104504:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104506:	56                   	push   %esi
  104507:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104508:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  10450a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10450d:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104514:	e8 97 0c 00 00       	call   1051b0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104519:	83 fb 3f             	cmp    $0x3f,%ebx
  10451c:	7e 2f                	jle    10454d <wait_thread+0x4d>
  10451e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104520:	85 ff                	test   %edi,%edi
  104522:	74 74                	je     104598 <wait_thread+0x98>
  104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104528:	e8 53 fc ff ff       	call   104180 <curproc>
  10452d:	8b 48 1c             	mov    0x1c(%eax),%ecx
  104530:	85 c9                	test   %ecx,%ecx
  104532:	75 64                	jne    104598 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104534:	e8 47 fc ff ff       	call   104180 <curproc>
  104539:	31 ff                	xor    %edi,%edi
  10453b:	31 db                	xor    %ebx,%ebx
  10453d:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  104544:	00 
  104545:	89 04 24             	mov    %eax,(%esp)
  104548:	e8 e3 fe ff ff       	call   104430 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10454d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  104553:	81 c6 80 d6 10 00    	add    $0x10d680,%esi
      if(p->state == UNUSED)
  104559:	8b 46 0c             	mov    0xc(%esi),%eax
  10455c:	85 c0                	test   %eax,%eax
  10455e:	75 10                	jne    104570 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104560:	83 c3 01             	add    $0x1,%ebx
  104563:	83 fb 3f             	cmp    $0x3f,%ebx
  104566:	7e e5                	jle    10454d <wait_thread+0x4d>
  104568:	eb b6                	jmp    104520 <wait_thread+0x20>
  10456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104570:	8b 46 14             	mov    0x14(%esi),%eax
  104573:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104576:	e8 05 fc ff ff       	call   104180 <curproc>
  10457b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10457e:	66 90                	xchg   %ax,%ax
  104580:	75 de                	jne    104560 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  104582:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  104586:	74 29                	je     1045b1 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  104588:	bf 01 00 00 00       	mov    $0x1,%edi
  10458d:	8d 76 00             	lea    0x0(%esi),%esi
  104590:	eb ce                	jmp    104560 <wait_thread+0x60>
  104592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104598:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10459f:	e8 cc 0b 00 00       	call   105170 <release>
  1045a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  1045a9:	83 c4 2c             	add    $0x2c,%esp
  1045ac:	5b                   	pop    %ebx
  1045ad:	5e                   	pop    %esi
  1045ae:	5f                   	pop    %edi
  1045af:	5d                   	pop    %ebp
  1045b0:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  1045b1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1045b8:	00 
  1045b9:	8b 46 08             	mov    0x8(%esi),%eax
  1045bc:	89 04 24             	mov    %eax,(%esp)
  1045bf:	e8 4c e1 ff ff       	call   102710 <kfree>
          pid = p->pid;
  1045c4:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  1045c7:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  1045ce:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  1045d5:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  1045dc:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1045e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1045e6:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  1045ed:	e8 7e 0b 00 00       	call   105170 <release>
          return pid;
  1045f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045f5:	eb b2                	jmp    1045a9 <wait_thread+0xa9>
  1045f7:	89 f6                	mov    %esi,%esi
  1045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104600 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104604:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104606:	56                   	push   %esi
  104607:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104608:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  10460a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10460d:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104614:	e8 97 0b 00 00       	call   1051b0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104619:	83 fb 3f             	cmp    $0x3f,%ebx
  10461c:	7e 2f                	jle    10464d <wait+0x4d>
  10461e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104620:	85 ff                	test   %edi,%edi
  104622:	74 74                	je     104698 <wait+0x98>
  104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104628:	e8 53 fb ff ff       	call   104180 <curproc>
  10462d:	8b 50 1c             	mov    0x1c(%eax),%edx
  104630:	85 d2                	test   %edx,%edx
  104632:	75 64                	jne    104698 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104634:	e8 47 fb ff ff       	call   104180 <curproc>
  104639:	31 ff                	xor    %edi,%edi
  10463b:	31 db                	xor    %ebx,%ebx
  10463d:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  104644:	00 
  104645:	89 04 24             	mov    %eax,(%esp)
  104648:	e8 e3 fd ff ff       	call   104430 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10464d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  104653:	81 c6 80 d6 10 00    	add    $0x10d680,%esi
      if(p->state == UNUSED)
  104659:	8b 4e 0c             	mov    0xc(%esi),%ecx
  10465c:	85 c9                	test   %ecx,%ecx
  10465e:	75 10                	jne    104670 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104660:	83 c3 01             	add    $0x1,%ebx
  104663:	83 fb 3f             	cmp    $0x3f,%ebx
  104666:	7e e5                	jle    10464d <wait+0x4d>
  104668:	eb b6                	jmp    104620 <wait+0x20>
  10466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104670:	8b 46 14             	mov    0x14(%esi),%eax
  104673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104676:	e8 05 fb ff ff       	call   104180 <curproc>
  10467b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10467e:	66 90                	xchg   %ax,%ax
  104680:	75 de                	jne    104660 <wait+0x60>
        if(p->state == ZOMBIE){
  104682:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  104686:	74 29                	je     1046b1 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  104688:	bf 01 00 00 00       	mov    $0x1,%edi
  10468d:	8d 76 00             	lea    0x0(%esi),%esi
  104690:	eb ce                	jmp    104660 <wait+0x60>
  104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104698:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10469f:	e8 cc 0a 00 00       	call   105170 <release>
  1046a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  1046a9:	83 c4 2c             	add    $0x2c,%esp
  1046ac:	5b                   	pop    %ebx
  1046ad:	5e                   	pop    %esi
  1046ae:	5f                   	pop    %edi
  1046af:	5d                   	pop    %ebp
  1046b0:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  1046b1:	8b 46 04             	mov    0x4(%esi),%eax
  1046b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b8:	8b 06                	mov    (%esi),%eax
  1046ba:	89 04 24             	mov    %eax,(%esp)
  1046bd:	e8 4e e0 ff ff       	call   102710 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  1046c2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1046c9:	00 
  1046ca:	8b 46 08             	mov    0x8(%esi),%eax
  1046cd:	89 04 24             	mov    %eax,(%esp)
  1046d0:	e8 3b e0 ff ff       	call   102710 <kfree>
          pid = p->pid;
  1046d5:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  1046d8:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  1046df:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  1046e6:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  1046ed:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1046f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1046f7:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  1046fe:	e8 6d 0a 00 00       	call   105170 <release>
          return pid;
  104703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104706:	eb a1                	jmp    1046a9 <wait+0xa9>
  104708:	90                   	nop
  104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104710 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  104710:	55                   	push   %ebp
  104711:	89 e5                	mov    %esp,%ebp
  104713:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  104716:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10471d:	e8 8e 0a 00 00       	call   1051b0 <acquire>
  cp->state = RUNNABLE;
  104722:	e8 59 fa ff ff       	call   104180 <curproc>
  104727:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  10472e:	e8 ad fa ff ff       	call   1041e0 <sched>
  release(&proc_table_lock);
  104733:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  10473a:	e8 31 0a 00 00       	call   105170 <release>
}
  10473f:	c9                   	leave  
  104740:	c3                   	ret    
  104741:	eb 0d                	jmp    104750 <setupsegs>
  104743:	90                   	nop
  104744:	90                   	nop
  104745:	90                   	nop
  104746:	90                   	nop
  104747:	90                   	nop
  104748:	90                   	nop
  104749:	90                   	nop
  10474a:	90                   	nop
  10474b:	90                   	nop
  10474c:	90                   	nop
  10474d:	90                   	nop
  10474e:	90                   	nop
  10474f:	90                   	nop

00104750 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	57                   	push   %edi
  104754:	56                   	push   %esi
  104755:	53                   	push   %ebx
  104756:	83 ec 2c             	sub    $0x2c,%esp
  104759:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  10475c:	e8 7f 09 00 00       	call   1050e0 <pushcli>
  c = &cpus[cpu()];
  104761:	e8 8a e4 ff ff       	call   102bf0 <cpu>
  104766:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10476c:	05 00 d0 10 00       	add    $0x10d000,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  104771:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  104773:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  104779:	0f 84 a1 01 00 00    	je     104920 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  10477f:	8b 56 08             	mov    0x8(%esi),%edx
  104782:	81 c2 00 10 00 00    	add    $0x1000,%edx
  104788:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10478b:	8d 50 28             	lea    0x28(%eax),%edx
  10478e:	89 d1                	mov    %edx,%ecx
  104790:	c1 e9 10             	shr    $0x10,%ecx
  104793:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  10479a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  10479d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  10479f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  1047a6:	00 00 00 
  1047a9:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  1047b0:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  1047b3:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  1047ba:	0f 01 
  1047bc:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  1047c3:	00 00 
  1047c5:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  1047cc:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  1047d3:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  1047da:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  1047e1:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  1047e8:	ff ff 
  1047ea:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  1047f1:	00 00 
  1047f3:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  1047fa:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  104801:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  104808:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10480f:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  104816:	67 00 
  104818:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  10481e:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  104825:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  10482b:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  104832:	0f 84 b8 00 00 00    	je     1048f0 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  104838:	8b 16                	mov    (%esi),%edx
  10483a:	8b 5e 04             	mov    0x4(%esi),%ebx
  10483d:	89 d6                	mov    %edx,%esi
  10483f:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  104842:	89 d3                	mov    %edx,%ebx
  104844:	c1 ee 10             	shr    $0x10,%esi
  104847:	89 cf                	mov    %ecx,%edi
  104849:	c1 eb 18             	shr    $0x18,%ebx
  10484c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  10484f:	89 f3                	mov    %esi,%ebx
  104851:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  104857:	89 cb                	mov    %ecx,%ebx
  104859:	c1 eb 1c             	shr    $0x1c,%ebx
  10485c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  10485e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  104861:	83 c9 c0             	or     $0xffffffc0,%ecx
  104864:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  10486b:	c1 ef 0c             	shr    $0xc,%edi
  10486e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  104874:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  104878:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  10487f:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  104885:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  10488c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  104892:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  104896:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  10489d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10489f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1048a6:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  1048ad:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  1048b3:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  1048b9:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1048be:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  1048c4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  1048c8:	c1 e8 10             	shr    $0x10,%eax
  1048cb:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  1048cf:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1048d2:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  1048d5:	b8 28 00 00 00       	mov    $0x28,%eax
  1048da:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  1048dd:	e8 7e 07 00 00       	call   105060 <popcli>
}
  1048e2:	83 c4 2c             	add    $0x2c,%esp
  1048e5:	5b                   	pop    %ebx
  1048e6:	5e                   	pop    %esi
  1048e7:	5f                   	pop    %edi
  1048e8:	5d                   	pop    %ebp
  1048e9:	c3                   	ret    
  1048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  1048f0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  1048f7:	00 00 00 
  1048fa:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  104901:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  104904:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10490b:	00 00 00 
  10490e:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  104915:	00 00 00 
  104918:	eb 9f                	jmp    1048b9 <setupsegs+0x169>
  10491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  104920:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  104927:	e9 5f fe ff ff       	jmp    10478b <setupsegs+0x3b>
  10492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104930 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  104930:	55                   	push   %ebp
  104931:	89 e5                	mov    %esp,%ebp
  104933:	57                   	push   %edi
  104934:	56                   	push   %esi
  104935:	53                   	push   %ebx
  104936:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  104939:	e8 b2 e2 ff ff       	call   102bf0 <cpu>
  10493e:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  104944:	81 c3 00 d0 10 00    	add    $0x10d000,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  10494a:	8d 73 08             	lea    0x8(%ebx),%esi
  10494d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  104950:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104951:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104958:	e8 53 08 00 00       	call   1051b0 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  10495d:	83 3d 90 d6 10 00 01 	cmpl   $0x1,0x10d690
  104964:	0f 84 be 00 00 00    	je     104a28 <scheduler+0xf8>
  10496a:	31 c0                	xor    %eax,%eax
  10496c:	31 c9                	xor    %ecx,%ecx
  10496e:	eb 0c                	jmp    10497c <scheduler+0x4c>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  104970:	05 9c 00 00 00       	add    $0x9c,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  104975:	3d 00 27 00 00       	cmp    $0x2700,%eax
  10497a:	74 1b                	je     104997 <scheduler+0x67>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  10497c:	83 b8 8c d6 10 00 03 	cmpl   $0x3,0x10d68c(%eax)
  104983:	75 eb                	jne    104970 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  104985:	03 88 18 d7 10 00    	add    0x10d718(%eax),%ecx
  10498b:	05 9c 00 00 00       	add    $0x9c,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  104990:	3d 00 27 00 00       	cmp    $0x2700,%eax
  104995:	75 e5                	jne    10497c <scheduler+0x4c>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  104997:	85 c9                	test   %ecx,%ecx
  104999:	74 11                	je     1049ac <scheduler+0x7c>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  10499b:	a1 00 06 11 00       	mov    0x110600,%eax
  1049a0:	c1 e0 08             	shl    $0x8,%eax
  1049a3:	89 c2                	mov    %eax,%edx
  1049a5:	c1 fa 1f             	sar    $0x1f,%edx
  1049a8:	f7 f9                	idiv   %ecx
  1049aa:	89 d7                	mov    %edx,%edi
  1049ac:	b8 8c d6 10 00       	mov    $0x10d68c,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  1049b1:	31 d2                	xor    %edx,%edx
  1049b3:	eb 13                	jmp    1049c8 <scheduler+0x98>
  1049b5:	8d 76 00             	lea    0x0(%esi),%esi
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  1049b8:	39 fa                	cmp    %edi,%edx
  1049ba:	7f 1e                	jg     1049da <scheduler+0xaa>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  1049bc:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  1049c1:	3d 8c fd 10 00       	cmp    $0x10fd8c,%eax
  1049c6:	74 4c                	je     104a14 <scheduler+0xe4>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  1049c8:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  1049cb:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  1049ce:	75 e8                	jne    1049b8 <scheduler+0x88>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  1049d0:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  1049d6:	39 fa                	cmp    %edi,%edx
  1049d8:	7e e2                	jle    1049bc <scheduler+0x8c>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  1049da:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  1049dd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1049e0:	89 0c 24             	mov    %ecx,(%esp)
  1049e3:	e8 68 fd ff ff       	call   104750 <setupsegs>
    	  p->state = RUNNING;
  1049e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1049eb:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  1049f2:	83 c1 64             	add    $0x64,%ecx
  1049f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1049f9:	89 34 24             	mov    %esi,(%esp)
  1049fc:	e8 1b 0a 00 00       	call   10541c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  104a01:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  104a08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a0f:	e8 3c fd ff ff       	call   104750 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  104a14:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104a1b:	e8 50 07 00 00       	call   105170 <release>
  104a20:	e9 2b ff ff ff       	jmp    104950 <scheduler+0x20>
  104a25:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  104a28:	83 3d 8c d6 10 00 03 	cmpl   $0x3,0x10d68c
  104a2f:	0f 85 35 ff ff ff    	jne    10496a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  104a35:	c7 43 04 80 d6 10 00 	movl   $0x10d680,0x4(%ebx)
      setupsegs(p);
  104a3c:	c7 04 24 80 d6 10 00 	movl   $0x10d680,(%esp)
  104a43:	e8 08 fd ff ff       	call   104750 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104a48:	c7 44 24 04 e4 d6 10 	movl   $0x10d6e4,0x4(%esp)
  104a4f:	00 
  104a50:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  104a53:	c7 05 18 d7 10 00 4b 	movl   $0x4b,0x10d718
  104a5a:	00 00 00 
      p->state = RUNNING;
  104a5d:	c7 05 8c d6 10 00 04 	movl   $0x4,0x10d68c
  104a64:	00 00 00 
      swtch(&c->context, &p->context);
  104a67:	e8 b0 09 00 00       	call   10541c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  104a6c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  104a73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a7a:	e8 d1 fc ff ff       	call   104750 <setupsegs>
      release(&proc_table_lock);
  104a7f:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104a86:	e8 e5 06 00 00       	call   105170 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  104a8b:	e9 c0 fe ff ff       	jmp    104950 <scheduler+0x20>

00104a90 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  104a90:	55                   	push   %ebp
  104a91:	89 e5                	mov    %esp,%ebp
  104a93:	57                   	push   %edi
  104a94:	56                   	push   %esi
  104a95:	53                   	push   %ebx
  104a96:	83 ec 1c             	sub    $0x1c,%esp
  104a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  104a9c:	e8 df f6 ff ff       	call   104180 <curproc>
  104aa1:	8b 50 04             	mov    0x4(%eax),%edx
  104aa4:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  104aa7:	89 04 24             	mov    %eax,(%esp)
  104aaa:	e8 91 db ff ff       	call   102640 <kalloc>
  104aaf:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  104ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ab6:	85 f6                	test   %esi,%esi
  104ab8:	74 7f                	je     104b39 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  104aba:	e8 c1 f6 ff ff       	call   104180 <curproc>
  104abf:	8b 78 04             	mov    0x4(%eax),%edi
  104ac2:	e8 b9 f6 ff ff       	call   104180 <curproc>
  104ac7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  104acb:	8b 00                	mov    (%eax),%eax
  104acd:	89 34 24             	mov    %esi,(%esp)
  104ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ad4:	e8 d7 07 00 00       	call   1052b0 <memmove>
  memset(newmem + cp->sz, 0, n);
  104ad9:	e8 a2 f6 ff ff       	call   104180 <curproc>
  104ade:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104ae2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ae9:	00 
  104aea:	8b 50 04             	mov    0x4(%eax),%edx
  104aed:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104af0:	89 04 24             	mov    %eax,(%esp)
  104af3:	e8 28 07 00 00       	call   105220 <memset>
  kfree(cp->mem, cp->sz);
  104af8:	e8 83 f6 ff ff       	call   104180 <curproc>
  104afd:	8b 78 04             	mov    0x4(%eax),%edi
  104b00:	e8 7b f6 ff ff       	call   104180 <curproc>
  104b05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104b09:	8b 00                	mov    (%eax),%eax
  104b0b:	89 04 24             	mov    %eax,(%esp)
  104b0e:	e8 fd db ff ff       	call   102710 <kfree>
  cp->mem = newmem;
  104b13:	e8 68 f6 ff ff       	call   104180 <curproc>
  104b18:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  104b1a:	e8 61 f6 ff ff       	call   104180 <curproc>
  104b1f:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  104b22:	e8 59 f6 ff ff       	call   104180 <curproc>
  104b27:	89 04 24             	mov    %eax,(%esp)
  104b2a:	e8 21 fc ff ff       	call   104750 <setupsegs>
  return cp->sz - n;
  104b2f:	e8 4c f6 ff ff       	call   104180 <curproc>
  104b34:	8b 40 04             	mov    0x4(%eax),%eax
  104b37:	29 d8                	sub    %ebx,%eax
}
  104b39:	83 c4 1c             	add    $0x1c,%esp
  104b3c:	5b                   	pop    %ebx
  104b3d:	5e                   	pop    %esi
  104b3e:	5f                   	pop    %edi
  104b3f:	5d                   	pop    %ebp
  104b40:	c3                   	ret    
  104b41:	eb 0d                	jmp    104b50 <copyproc_tix>
  104b43:	90                   	nop
  104b44:	90                   	nop
  104b45:	90                   	nop
  104b46:	90                   	nop
  104b47:	90                   	nop
  104b48:	90                   	nop
  104b49:	90                   	nop
  104b4a:	90                   	nop
  104b4b:	90                   	nop
  104b4c:	90                   	nop
  104b4d:	90                   	nop
  104b4e:	90                   	nop
  104b4f:	90                   	nop

00104b50 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  104b50:	55                   	push   %ebp
  104b51:	89 e5                	mov    %esp,%ebp
  104b53:	57                   	push   %edi
  104b54:	56                   	push   %esi
  104b55:	53                   	push   %ebx
  104b56:	83 ec 1c             	sub    $0x1c,%esp
  104b59:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  104b5c:	e8 9f f5 ff ff       	call   104100 <allocproc>
  104b61:	85 c0                	test   %eax,%eax
  104b63:	89 c6                	mov    %eax,%esi
  104b65:	0f 84 e1 00 00 00    	je     104c4c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  104b6b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104b72:	e8 c9 da ff ff       	call   102640 <kalloc>
  104b77:	85 c0                	test   %eax,%eax
  104b79:	89 46 08             	mov    %eax,0x8(%esi)
  104b7c:	0f 84 d4 00 00 00    	je     104c56 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104b82:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104b87:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104b89:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  104b8f:	0f 84 85 00 00 00    	je     104c1a <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  104b95:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  104b98:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  104b9b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104ba1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104ba8:	00 
  104ba9:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104baf:	89 04 24             	mov    %eax,(%esp)
  104bb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bb6:	e8 f5 06 00 00       	call   1052b0 <memmove>
  
    np->sz = p->sz;
  104bbb:	8b 47 04             	mov    0x4(%edi),%eax
  104bbe:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104bc1:	89 04 24             	mov    %eax,(%esp)
  104bc4:	e8 77 da ff ff       	call   102640 <kalloc>
  104bc9:	85 c0                	test   %eax,%eax
  104bcb:	89 06                	mov    %eax,(%esi)
  104bcd:	0f 84 8e 00 00 00    	je     104c61 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104bd3:	8b 56 04             	mov    0x4(%esi),%edx
  104bd6:	31 db                	xor    %ebx,%ebx
  104bd8:	89 54 24 08          	mov    %edx,0x8(%esp)
  104bdc:	8b 17                	mov    (%edi),%edx
  104bde:	89 04 24             	mov    %eax,(%esp)
  104be1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104be5:	e8 c6 06 00 00       	call   1052b0 <memmove>
  104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104bf0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104bf4:	85 c0                	test   %eax,%eax
  104bf6:	74 0c                	je     104c04 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104bf8:	89 04 24             	mov    %eax,(%esp)
  104bfb:	e8 00 c4 ff ff       	call   101000 <filedup>
  104c00:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104c04:	83 c3 01             	add    $0x1,%ebx
  104c07:	83 fb 10             	cmp    $0x10,%ebx
  104c0a:	75 e4                	jne    104bf0 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  104c0c:	8b 47 60             	mov    0x60(%edi),%eax
  104c0f:	89 04 24             	mov    %eax,(%esp)
  104c12:	e8 79 cd ff ff       	call   101990 <idup>
  104c17:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104c1a:	8d 46 64             	lea    0x64(%esi),%eax
  104c1d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104c24:	00 
  104c25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c2c:	00 
  104c2d:	89 04 24             	mov    %eax,(%esp)
  104c30:	e8 eb 05 00 00       	call   105220 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104c35:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104c3b:	c7 46 64 b0 41 10 00 	movl   $0x1041b0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104c42:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104c45:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  104c4c:	83 c4 1c             	add    $0x1c,%esp
  104c4f:	89 f0                	mov    %esi,%eax
  104c51:	5b                   	pop    %ebx
  104c52:	5e                   	pop    %esi
  104c53:	5f                   	pop    %edi
  104c54:	5d                   	pop    %ebp
  104c55:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104c56:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  104c5d:	31 f6                	xor    %esi,%esi
    return 0;
  104c5f:	eb eb                	jmp    104c4c <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104c61:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c68:	00 
  104c69:	8b 46 08             	mov    0x8(%esi),%eax
  104c6c:	89 04 24             	mov    %eax,(%esp)
  104c6f:	e8 9c da ff ff       	call   102710 <kfree>
      np->kstack = 0;
  104c74:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  104c7b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104c82:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104c89:	31 f6                	xor    %esi,%esi
      return 0;
  104c8b:	eb bf                	jmp    104c4c <copyproc_tix+0xfc>
  104c8d:	8d 76 00             	lea    0x0(%esi),%esi

00104c90 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  104c90:	55                   	push   %ebp
  104c91:	89 e5                	mov    %esp,%ebp
  104c93:	57                   	push   %edi
  104c94:	56                   	push   %esi
  104c95:	53                   	push   %ebx
  104c96:	83 ec 1c             	sub    $0x1c,%esp
  104c99:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  104c9c:	e8 5f f4 ff ff       	call   104100 <allocproc>
  104ca1:	85 c0                	test   %eax,%eax
  104ca3:	89 c6                	mov    %eax,%esi
  104ca5:	0f 84 de 00 00 00    	je     104d89 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  104cab:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104cb2:	e8 89 d9 ff ff       	call   102640 <kalloc>
  104cb7:	85 c0                	test   %eax,%eax
  104cb9:	89 46 08             	mov    %eax,0x8(%esi)
  104cbc:	0f 84 d1 00 00 00    	je     104d93 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104cc2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104cc7:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104cc9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  104ccf:	74 61                	je     104d32 <copyproc_threads+0xa2>
    np->parent = p;
  104cd1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104cd4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104cd6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  104cdd:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104ce0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104ce7:	00 
  104ce8:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104cee:	89 04 24             	mov    %eax,(%esp)
  104cf1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cf5:	e8 b6 05 00 00       	call   1052b0 <memmove>
  
    np->sz = p->sz;
  104cfa:	8b 47 04             	mov    0x4(%edi),%eax
  104cfd:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104d00:	8b 07                	mov    (%edi),%eax
  104d02:	89 06                	mov    %eax,(%esi)
  104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104d08:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104d0c:	85 c0                	test   %eax,%eax
  104d0e:	74 0c                	je     104d1c <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  104d10:	89 04 24             	mov    %eax,(%esp)
  104d13:	e8 e8 c2 ff ff       	call   101000 <filedup>
  104d18:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104d1c:	83 c3 01             	add    $0x1,%ebx
  104d1f:	83 fb 10             	cmp    $0x10,%ebx
  104d22:	75 e4                	jne    104d08 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  104d24:	8b 47 60             	mov    0x60(%edi),%eax
  104d27:	89 04 24             	mov    %eax,(%esp)
  104d2a:	e8 61 cc ff ff       	call   101990 <idup>
  104d2f:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104d32:	8d 46 64             	lea    0x64(%esi),%eax
  104d35:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104d3c:	00 
  104d3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d44:	00 
  104d45:	89 04 24             	mov    %eax,(%esp)
  104d48:	e8 d3 04 00 00       	call   105220 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104d50:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104d56:	c7 46 64 b0 41 10 00 	movl   $0x1041b0,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104d60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104d63:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104d69:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104d6c:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  104d6f:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104d71:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104d78:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  104d7f:	8b 40 3c             	mov    0x3c(%eax),%eax
  104d82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  104d85:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  104d89:	83 c4 1c             	add    $0x1c,%esp
  104d8c:	89 f0                	mov    %esi,%eax
  104d8e:	5b                   	pop    %ebx
  104d8f:	5e                   	pop    %esi
  104d90:	5f                   	pop    %edi
  104d91:	5d                   	pop    %ebp
  104d92:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104d93:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  104d9a:	31 f6                	xor    %esi,%esi
    return 0;
  104d9c:	eb eb                	jmp    104d89 <copyproc_threads+0xf9>
  104d9e:	66 90                	xchg   %ax,%ax

00104da0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104da0:	55                   	push   %ebp
  104da1:	89 e5                	mov    %esp,%ebp
  104da3:	57                   	push   %edi
  104da4:	56                   	push   %esi
  104da5:	53                   	push   %ebx
  104da6:	83 ec 1c             	sub    $0x1c,%esp
  104da9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  104dac:	e8 4f f3 ff ff       	call   104100 <allocproc>
  104db1:	85 c0                	test   %eax,%eax
  104db3:	89 c6                	mov    %eax,%esi
  104db5:	0f 84 e1 00 00 00    	je     104e9c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  104dbb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104dc2:	e8 79 d8 ff ff       	call   102640 <kalloc>
  104dc7:	85 c0                	test   %eax,%eax
  104dc9:	89 46 08             	mov    %eax,0x8(%esi)
  104dcc:	0f 84 d4 00 00 00    	je     104ea6 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104dd2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104dd7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104dd9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  104ddf:	0f 84 85 00 00 00    	je     104e6a <copyproc+0xca>
    np->parent = p;
  104de5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104de8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  104def:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104df2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104df9:	00 
  104dfa:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104e00:	89 04 24             	mov    %eax,(%esp)
  104e03:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e07:	e8 a4 04 00 00       	call   1052b0 <memmove>
  
    np->sz = p->sz;
  104e0c:	8b 47 04             	mov    0x4(%edi),%eax
  104e0f:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104e12:	89 04 24             	mov    %eax,(%esp)
  104e15:	e8 26 d8 ff ff       	call   102640 <kalloc>
  104e1a:	85 c0                	test   %eax,%eax
  104e1c:	89 06                	mov    %eax,(%esi)
  104e1e:	0f 84 8d 00 00 00    	je     104eb1 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104e24:	8b 56 04             	mov    0x4(%esi),%edx
  104e27:	31 db                	xor    %ebx,%ebx
  104e29:	89 54 24 08          	mov    %edx,0x8(%esp)
  104e2d:	8b 17                	mov    (%edi),%edx
  104e2f:	89 04 24             	mov    %eax,(%esp)
  104e32:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e36:	e8 75 04 00 00       	call   1052b0 <memmove>
  104e3b:	90                   	nop
  104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104e40:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104e44:	85 c0                	test   %eax,%eax
  104e46:	74 0c                	je     104e54 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104e48:	89 04 24             	mov    %eax,(%esp)
  104e4b:	e8 b0 c1 ff ff       	call   101000 <filedup>
  104e50:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104e54:	83 c3 01             	add    $0x1,%ebx
  104e57:	83 fb 10             	cmp    $0x10,%ebx
  104e5a:	75 e4                	jne    104e40 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  104e5c:	8b 47 60             	mov    0x60(%edi),%eax
  104e5f:	89 04 24             	mov    %eax,(%esp)
  104e62:	e8 29 cb ff ff       	call   101990 <idup>
  104e67:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104e6a:	8d 46 64             	lea    0x64(%esi),%eax
  104e6d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104e74:	00 
  104e75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e7c:	00 
  104e7d:	89 04 24             	mov    %eax,(%esp)
  104e80:	e8 9b 03 00 00       	call   105220 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104e85:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104e8b:	c7 46 64 b0 41 10 00 	movl   $0x1041b0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104e92:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104e95:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  104e9c:	83 c4 1c             	add    $0x1c,%esp
  104e9f:	89 f0                	mov    %esi,%eax
  104ea1:	5b                   	pop    %ebx
  104ea2:	5e                   	pop    %esi
  104ea3:	5f                   	pop    %edi
  104ea4:	5d                   	pop    %ebp
  104ea5:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104ea6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  104ead:	31 f6                	xor    %esi,%esi
    return 0;
  104eaf:	eb eb                	jmp    104e9c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104eb1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104eb8:	00 
  104eb9:	8b 46 08             	mov    0x8(%esi),%eax
  104ebc:	89 04 24             	mov    %eax,(%esp)
  104ebf:	e8 4c d8 ff ff       	call   102710 <kfree>
      np->kstack = 0;
  104ec4:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  104ecb:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104ed2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104ed9:	31 f6                	xor    %esi,%esi
      return 0;
  104edb:	eb bf                	jmp    104e9c <copyproc+0xfc>
  104edd:	8d 76 00             	lea    0x0(%esi),%esi

00104ee0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104ee0:	55                   	push   %ebp
  104ee1:	89 e5                	mov    %esp,%ebp
  104ee3:	53                   	push   %ebx
  104ee4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104ee7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104eee:	e8 ad fe ff ff       	call   104da0 <copyproc>
  p->sz = PAGE;
  104ef3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104efa:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  104efc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104f03:	e8 38 d7 ff ff       	call   102640 <kalloc>
  104f08:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  104f0a:	c7 04 24 9e 79 10 00 	movl   $0x10799e,(%esp)
  104f11:	e8 5a d3 ff ff       	call   102270 <namei>
  104f16:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104f19:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104f20:	00 
  104f21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f28:	00 
  104f29:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  104f2f:	89 04 24             	mov    %eax,(%esp)
  104f32:	e8 e9 02 00 00       	call   105220 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104f37:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104f3d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  104f3f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104f46:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104f49:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  104f4f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104f55:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  104f5b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  104f5e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104f62:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104f65:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104f6b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104f72:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104f79:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104f80:	00 
  104f81:	c7 44 24 04 08 87 10 	movl   $0x108708,0x4(%esp)
  104f88:	00 
  104f89:	8b 03                	mov    (%ebx),%eax
  104f8b:	89 04 24             	mov    %eax,(%esp)
  104f8e:	e8 1d 03 00 00       	call   1052b0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104f93:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104f99:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104fa0:	00 
  104fa1:	c7 44 24 04 a0 79 10 	movl   $0x1079a0,0x4(%esp)
  104fa8:	00 
  104fa9:	89 04 24             	mov    %eax,(%esp)
  104fac:	e8 0f 04 00 00       	call   1053c0 <safestrcpy>
  p->state = RUNNABLE;
  104fb1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104fb8:	89 1d 48 88 10 00    	mov    %ebx,0x108848
}
  104fbe:	83 c4 14             	add    $0x14,%esp
  104fc1:	5b                   	pop    %ebx
  104fc2:	5d                   	pop    %ebp
  104fc3:	c3                   	ret    
  104fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104fd0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104fd0:	55                   	push   %ebp
  104fd1:	89 e5                	mov    %esp,%ebp
  104fd3:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104fd6:	c7 44 24 04 a9 79 10 	movl   $0x1079a9,0x4(%esp)
  104fdd:	00 
  104fde:	c7 04 24 80 fd 10 00 	movl   $0x10fd80,(%esp)
  104fe5:	e8 06 00 00 00       	call   104ff0 <initlock>
}
  104fea:	c9                   	leave  
  104feb:	c3                   	ret    
  104fec:	90                   	nop
  104fed:	90                   	nop
  104fee:	90                   	nop
  104fef:	90                   	nop

00104ff0 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  104ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  104fff:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  105002:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  105009:	5d                   	pop    %ebp
  10500a:	c3                   	ret    
  10500b:	90                   	nop
  10500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105010 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105010:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105011:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105013:	89 e5                	mov    %esp,%ebp
  105015:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105016:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105019:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10501c:	83 ea 08             	sub    $0x8,%edx
  10501f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  105020:	8d 4a ff             	lea    -0x1(%edx),%ecx
  105023:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  105026:	77 18                	ja     105040 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  105028:	8b 4a 04             	mov    0x4(%edx),%ecx
  10502b:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  10502e:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  105031:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  105033:	83 f8 0a             	cmp    $0xa,%eax
  105036:	75 e8                	jne    105020 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  105038:	5b                   	pop    %ebx
  105039:	5d                   	pop    %ebp
  10503a:	c3                   	ret    
  10503b:	90                   	nop
  10503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  105040:	83 f8 09             	cmp    $0x9,%eax
  105043:	7f f3                	jg     105038 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  105045:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  105048:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  10504b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  105051:	83 c2 04             	add    $0x4,%edx
  105054:	83 f8 0a             	cmp    $0xa,%eax
  105057:	75 ef                	jne    105048 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  105059:	5b                   	pop    %ebx
  10505a:	5d                   	pop    %ebp
  10505b:	c3                   	ret    
  10505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105060 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  105060:	55                   	push   %ebp
  105061:	89 e5                	mov    %esp,%ebp
  105063:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  105066:	9c                   	pushf  
  105067:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  105068:	f6 c4 02             	test   $0x2,%ah
  10506b:	75 5f                	jne    1050cc <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10506d:	e8 7e db ff ff       	call   102bf0 <cpu>
  105072:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105078:	05 04 d0 10 00       	add    $0x10d004,%eax
  10507d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  105083:	83 ea 01             	sub    $0x1,%edx
  105086:	85 d2                	test   %edx,%edx
  105088:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10508e:	78 30                	js     1050c0 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  105090:	e8 5b db ff ff       	call   102bf0 <cpu>
  105095:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10509b:	8b 90 c4 d0 10 00    	mov    0x10d0c4(%eax),%edx
  1050a1:	85 d2                	test   %edx,%edx
  1050a3:	74 03                	je     1050a8 <popcli+0x48>
    sti();
}
  1050a5:	c9                   	leave  
  1050a6:	c3                   	ret    
  1050a7:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1050a8:	e8 43 db ff ff       	call   102bf0 <cpu>
  1050ad:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1050b3:	8b 80 c8 d0 10 00    	mov    0x10d0c8(%eax),%eax
  1050b9:	85 c0                	test   %eax,%eax
  1050bb:	74 e8                	je     1050a5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  1050bd:	fb                   	sti    
    sti();
}
  1050be:	c9                   	leave  
  1050bf:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  1050c0:	c7 04 24 0f 7a 10 00 	movl   $0x107a0f,(%esp)
  1050c7:	e8 94 b8 ff ff       	call   100960 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  1050cc:	c7 04 24 f8 79 10 00 	movl   $0x1079f8,(%esp)
  1050d3:	e8 88 b8 ff ff       	call   100960 <panic>
  1050d8:	90                   	nop
  1050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001050e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1050e0:	55                   	push   %ebp
  1050e1:	89 e5                	mov    %esp,%ebp
  1050e3:	53                   	push   %ebx
  1050e4:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1050e7:	9c                   	pushf  
  1050e8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1050e9:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  1050ea:	e8 01 db ff ff       	call   102bf0 <cpu>
  1050ef:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1050f5:	05 04 d0 10 00       	add    $0x10d004,%eax
  1050fa:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  105100:	8d 4a 01             	lea    0x1(%edx),%ecx
  105103:	85 d2                	test   %edx,%edx
  105105:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  10510b:	75 17                	jne    105124 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  10510d:	e8 de da ff ff       	call   102bf0 <cpu>
  105112:	81 e3 00 02 00 00    	and    $0x200,%ebx
  105118:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10511e:	89 98 c8 d0 10 00    	mov    %ebx,0x10d0c8(%eax)
}
  105124:	83 c4 04             	add    $0x4,%esp
  105127:	5b                   	pop    %ebx
  105128:	5d                   	pop    %ebp
  105129:	c3                   	ret    
  10512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105130 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  105130:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  105131:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  105133:	89 e5                	mov    %esp,%ebp
  105135:	53                   	push   %ebx
  105136:	83 ec 04             	sub    $0x4,%esp
  105139:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10513c:	8b 0a                	mov    (%edx),%ecx
  10513e:	85 c9                	test   %ecx,%ecx
  105140:	75 06                	jne    105148 <holding+0x18>
}
  105142:	83 c4 04             	add    $0x4,%esp
  105145:	5b                   	pop    %ebx
  105146:	5d                   	pop    %ebp
  105147:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  105148:	8b 5a 08             	mov    0x8(%edx),%ebx
  10514b:	e8 a0 da ff ff       	call   102bf0 <cpu>
  105150:	83 c0 0a             	add    $0xa,%eax
  105153:	39 c3                	cmp    %eax,%ebx
  105155:	0f 94 c0             	sete   %al
}
  105158:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  10515b:	0f b6 c0             	movzbl %al,%eax
}
  10515e:	5b                   	pop    %ebx
  10515f:	5d                   	pop    %ebp
  105160:	c3                   	ret    
  105161:	eb 0d                	jmp    105170 <release>
  105163:	90                   	nop
  105164:	90                   	nop
  105165:	90                   	nop
  105166:	90                   	nop
  105167:	90                   	nop
  105168:	90                   	nop
  105169:	90                   	nop
  10516a:	90                   	nop
  10516b:	90                   	nop
  10516c:	90                   	nop
  10516d:	90                   	nop
  10516e:	90                   	nop
  10516f:	90                   	nop

00105170 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  105170:	55                   	push   %ebp
  105171:	89 e5                	mov    %esp,%ebp
  105173:	53                   	push   %ebx
  105174:	83 ec 14             	sub    $0x14,%esp
  105177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10517a:	89 1c 24             	mov    %ebx,(%esp)
  10517d:	e8 ae ff ff ff       	call   105130 <holding>
  105182:	85 c0                	test   %eax,%eax
  105184:	74 1d                	je     1051a3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  105186:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10518d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10518f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  105196:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  105199:	83 c4 14             	add    $0x14,%esp
  10519c:	5b                   	pop    %ebx
  10519d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10519e:	e9 bd fe ff ff       	jmp    105060 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1051a3:	c7 04 24 16 7a 10 00 	movl   $0x107a16,(%esp)
  1051aa:	e8 b1 b7 ff ff       	call   100960 <panic>
  1051af:	90                   	nop

001051b0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  1051b0:	55                   	push   %ebp
  1051b1:	89 e5                	mov    %esp,%ebp
  1051b3:	53                   	push   %ebx
  1051b4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  1051b7:	e8 24 ff ff ff       	call   1050e0 <pushcli>
  if(holding(lock))
  1051bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1051bf:	89 04 24             	mov    %eax,(%esp)
  1051c2:	e8 69 ff ff ff       	call   105130 <holding>
  1051c7:	85 c0                	test   %eax,%eax
  1051c9:	75 3d                	jne    105208 <acquire+0x58>
    panic("acquire");
  1051cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1051ce:	ba 01 00 00 00       	mov    $0x1,%edx
  1051d3:	90                   	nop
  1051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1051d8:	89 d0                	mov    %edx,%eax
  1051da:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1051dd:	83 f8 01             	cmp    $0x1,%eax
  1051e0:	74 f6                	je     1051d8 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1051e2:	e8 09 da ff ff       	call   102bf0 <cpu>
  1051e7:	83 c0 0a             	add    $0xa,%eax
  1051ea:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  1051ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f0:	83 c0 0c             	add    $0xc,%eax
  1051f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051f7:	8d 45 08             	lea    0x8(%ebp),%eax
  1051fa:	89 04 24             	mov    %eax,(%esp)
  1051fd:	e8 0e fe ff ff       	call   105010 <getcallerpcs>
}
  105202:	83 c4 14             	add    $0x14,%esp
  105205:	5b                   	pop    %ebx
  105206:	5d                   	pop    %ebp
  105207:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  105208:	c7 04 24 1e 7a 10 00 	movl   $0x107a1e,(%esp)
  10520f:	e8 4c b7 ff ff       	call   100960 <panic>
  105214:	90                   	nop
  105215:	90                   	nop
  105216:	90                   	nop
  105217:	90                   	nop
  105218:	90                   	nop
  105219:	90                   	nop
  10521a:	90                   	nop
  10521b:	90                   	nop
  10521c:	90                   	nop
  10521d:	90                   	nop
  10521e:	90                   	nop
  10521f:	90                   	nop

00105220 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  105220:	55                   	push   %ebp
  105221:	89 e5                	mov    %esp,%ebp
  105223:	8b 4d 10             	mov    0x10(%ebp),%ecx
  105226:	53                   	push   %ebx
  105227:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10522a:	85 c9                	test   %ecx,%ecx
  10522c:	74 14                	je     105242 <memset+0x22>
  10522e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  105232:	31 d2                	xor    %edx,%edx
  105234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  105238:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  10523b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10523e:	39 ca                	cmp    %ecx,%edx
  105240:	75 f6                	jne    105238 <memset+0x18>
    *d++ = c;

  return dst;
}
  105242:	5b                   	pop    %ebx
  105243:	5d                   	pop    %ebp
  105244:	c3                   	ret    
  105245:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105250 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  105250:	55                   	push   %ebp
  105251:	89 e5                	mov    %esp,%ebp
  105253:	57                   	push   %edi
  105254:	56                   	push   %esi
  105255:	53                   	push   %ebx
  105256:	8b 55 10             	mov    0x10(%ebp),%edx
  105259:	8b 75 08             	mov    0x8(%ebp),%esi
  10525c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10525f:	85 d2                	test   %edx,%edx
  105261:	74 2d                	je     105290 <memcmp+0x40>
    if(*s1 != *s2)
  105263:	0f b6 1e             	movzbl (%esi),%ebx
  105266:	0f b6 0f             	movzbl (%edi),%ecx
  105269:	38 cb                	cmp    %cl,%bl
  10526b:	75 2b                	jne    105298 <memcmp+0x48>
      return *s1 - *s2;
  10526d:	83 ea 01             	sub    $0x1,%edx
  105270:	31 c0                	xor    %eax,%eax
  105272:	eb 18                	jmp    10528c <memcmp+0x3c>
  105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  105278:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  10527d:	83 ea 01             	sub    $0x1,%edx
  105280:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  105285:	83 c0 01             	add    $0x1,%eax
  105288:	38 cb                	cmp    %cl,%bl
  10528a:	75 0c                	jne    105298 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10528c:	85 d2                	test   %edx,%edx
  10528e:	75 e8                	jne    105278 <memcmp+0x28>
  105290:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  105292:	5b                   	pop    %ebx
  105293:	5e                   	pop    %esi
  105294:	5f                   	pop    %edi
  105295:	5d                   	pop    %ebp
  105296:	c3                   	ret    
  105297:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  105298:	0f b6 c3             	movzbl %bl,%eax
  10529b:	0f b6 c9             	movzbl %cl,%ecx
  10529e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  1052a0:	5b                   	pop    %ebx
  1052a1:	5e                   	pop    %esi
  1052a2:	5f                   	pop    %edi
  1052a3:	5d                   	pop    %ebp
  1052a4:	c3                   	ret    
  1052a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1052b0:	55                   	push   %ebp
  1052b1:	89 e5                	mov    %esp,%ebp
  1052b3:	57                   	push   %edi
  1052b4:	56                   	push   %esi
  1052b5:	53                   	push   %ebx
  1052b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1052b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  1052bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1052bf:	39 c6                	cmp    %eax,%esi
  1052c1:	73 2d                	jae    1052f0 <memmove+0x40>
  1052c3:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  1052c6:	39 f8                	cmp    %edi,%eax
  1052c8:	73 26                	jae    1052f0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1052ca:	85 db                	test   %ebx,%ebx
  1052cc:	74 1d                	je     1052eb <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  1052ce:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  1052d1:	31 d2                	xor    %edx,%edx
  1052d3:	90                   	nop
  1052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  1052d8:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  1052dd:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  1052e1:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1052e4:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  1052e7:	85 c9                	test   %ecx,%ecx
  1052e9:	75 ed                	jne    1052d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  1052eb:	5b                   	pop    %ebx
  1052ec:	5e                   	pop    %esi
  1052ed:	5f                   	pop    %edi
  1052ee:	5d                   	pop    %ebp
  1052ef:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1052f0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  1052f2:	85 db                	test   %ebx,%ebx
  1052f4:	74 f5                	je     1052eb <memmove+0x3b>
  1052f6:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  1052f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  1052fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1052ff:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  105302:	39 d3                	cmp    %edx,%ebx
  105304:	75 f2                	jne    1052f8 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  105306:	5b                   	pop    %ebx
  105307:	5e                   	pop    %esi
  105308:	5f                   	pop    %edi
  105309:	5d                   	pop    %ebp
  10530a:	c3                   	ret    
  10530b:	90                   	nop
  10530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105310 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  105310:	55                   	push   %ebp
  105311:	89 e5                	mov    %esp,%ebp
  105313:	57                   	push   %edi
  105314:	56                   	push   %esi
  105315:	53                   	push   %ebx
  105316:	8b 7d 10             	mov    0x10(%ebp),%edi
  105319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10531c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10531f:	85 ff                	test   %edi,%edi
  105321:	74 3d                	je     105360 <strncmp+0x50>
  105323:	0f b6 01             	movzbl (%ecx),%eax
  105326:	84 c0                	test   %al,%al
  105328:	75 18                	jne    105342 <strncmp+0x32>
  10532a:	eb 3c                	jmp    105368 <strncmp+0x58>
  10532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105330:	83 ef 01             	sub    $0x1,%edi
  105333:	74 2b                	je     105360 <strncmp+0x50>
    n--, p++, q++;
  105335:	83 c1 01             	add    $0x1,%ecx
  105338:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  10533b:	0f b6 01             	movzbl (%ecx),%eax
  10533e:	84 c0                	test   %al,%al
  105340:	74 26                	je     105368 <strncmp+0x58>
  105342:	0f b6 33             	movzbl (%ebx),%esi
  105345:	89 f2                	mov    %esi,%edx
  105347:	38 d0                	cmp    %dl,%al
  105349:	74 e5                	je     105330 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10534b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  105351:	0f b6 c0             	movzbl %al,%eax
  105354:	29 f0                	sub    %esi,%eax
}
  105356:	5b                   	pop    %ebx
  105357:	5e                   	pop    %esi
  105358:	5f                   	pop    %edi
  105359:	5d                   	pop    %ebp
  10535a:	c3                   	ret    
  10535b:	90                   	nop
  10535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  105360:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  105362:	5b                   	pop    %ebx
  105363:	5e                   	pop    %esi
  105364:	5f                   	pop    %edi
  105365:	5d                   	pop    %ebp
  105366:	c3                   	ret    
  105367:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  105368:	0f b6 33             	movzbl (%ebx),%esi
  10536b:	eb de                	jmp    10534b <strncmp+0x3b>
  10536d:	8d 76 00             	lea    0x0(%esi),%esi

00105370 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  105370:	55                   	push   %ebp
  105371:	89 e5                	mov    %esp,%ebp
  105373:	8b 45 08             	mov    0x8(%ebp),%eax
  105376:	56                   	push   %esi
  105377:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10537a:	53                   	push   %ebx
  10537b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10537e:	89 c3                	mov    %eax,%ebx
  105380:	eb 09                	jmp    10538b <strncpy+0x1b>
  105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  105388:	83 c6 01             	add    $0x1,%esi
  10538b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10538e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  105391:	85 d2                	test   %edx,%edx
  105393:	7e 0c                	jle    1053a1 <strncpy+0x31>
  105395:	0f b6 16             	movzbl (%esi),%edx
  105398:	88 13                	mov    %dl,(%ebx)
  10539a:	83 c3 01             	add    $0x1,%ebx
  10539d:	84 d2                	test   %dl,%dl
  10539f:	75 e7                	jne    105388 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  1053a1:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1053a3:	85 c9                	test   %ecx,%ecx
  1053a5:	7e 0c                	jle    1053b3 <strncpy+0x43>
  1053a7:	90                   	nop
    *s++ = 0;
  1053a8:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  1053ac:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1053af:	39 ca                	cmp    %ecx,%edx
  1053b1:	75 f5                	jne    1053a8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  1053b3:	5b                   	pop    %ebx
  1053b4:	5e                   	pop    %esi
  1053b5:	5d                   	pop    %ebp
  1053b6:	c3                   	ret    
  1053b7:	89 f6                	mov    %esi,%esi
  1053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001053c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1053c0:	55                   	push   %ebp
  1053c1:	89 e5                	mov    %esp,%ebp
  1053c3:	8b 55 10             	mov    0x10(%ebp),%edx
  1053c6:	56                   	push   %esi
  1053c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ca:	53                   	push   %ebx
  1053cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  1053ce:	85 d2                	test   %edx,%edx
  1053d0:	7e 1f                	jle    1053f1 <safestrcpy+0x31>
  1053d2:	89 c1                	mov    %eax,%ecx
  1053d4:	eb 05                	jmp    1053db <safestrcpy+0x1b>
  1053d6:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1053d8:	83 c6 01             	add    $0x1,%esi
  1053db:	83 ea 01             	sub    $0x1,%edx
  1053de:	85 d2                	test   %edx,%edx
  1053e0:	7e 0c                	jle    1053ee <safestrcpy+0x2e>
  1053e2:	0f b6 1e             	movzbl (%esi),%ebx
  1053e5:	88 19                	mov    %bl,(%ecx)
  1053e7:	83 c1 01             	add    $0x1,%ecx
  1053ea:	84 db                	test   %bl,%bl
  1053ec:	75 ea                	jne    1053d8 <safestrcpy+0x18>
    ;
  *s = 0;
  1053ee:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  1053f1:	5b                   	pop    %ebx
  1053f2:	5e                   	pop    %esi
  1053f3:	5d                   	pop    %ebp
  1053f4:	c3                   	ret    
  1053f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105400 <strlen>:

int
strlen(const char *s)
{
  105400:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  105401:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  105403:	89 e5                	mov    %esp,%ebp
  105405:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  105408:	80 3a 00             	cmpb   $0x0,(%edx)
  10540b:	74 0c                	je     105419 <strlen+0x19>
  10540d:	8d 76 00             	lea    0x0(%esi),%esi
  105410:	83 c0 01             	add    $0x1,%eax
  105413:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  105417:	75 f7                	jne    105410 <strlen+0x10>
    ;
  return n;
}
  105419:	5d                   	pop    %ebp
  10541a:	c3                   	ret    
  10541b:	90                   	nop

0010541c <swtch>:
  10541c:	8b 44 24 04          	mov    0x4(%esp),%eax
  105420:	8f 00                	popl   (%eax)
  105422:	89 60 04             	mov    %esp,0x4(%eax)
  105425:	89 58 08             	mov    %ebx,0x8(%eax)
  105428:	89 48 0c             	mov    %ecx,0xc(%eax)
  10542b:	89 50 10             	mov    %edx,0x10(%eax)
  10542e:	89 70 14             	mov    %esi,0x14(%eax)
  105431:	89 78 18             	mov    %edi,0x18(%eax)
  105434:	89 68 1c             	mov    %ebp,0x1c(%eax)
  105437:	8b 44 24 04          	mov    0x4(%esp),%eax
  10543b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10543e:	8b 78 18             	mov    0x18(%eax),%edi
  105441:	8b 70 14             	mov    0x14(%eax),%esi
  105444:	8b 50 10             	mov    0x10(%eax),%edx
  105447:	8b 48 0c             	mov    0xc(%eax),%ecx
  10544a:	8b 58 08             	mov    0x8(%eax),%ebx
  10544d:	8b 60 04             	mov    0x4(%eax),%esp
  105450:	ff 30                	pushl  (%eax)
  105452:	c3                   	ret    
  105453:	90                   	nop
  105454:	90                   	nop
  105455:	90                   	nop
  105456:	90                   	nop
  105457:	90                   	nop
  105458:	90                   	nop
  105459:	90                   	nop
  10545a:	90                   	nop
  10545b:	90                   	nop
  10545c:	90                   	nop
  10545d:	90                   	nop
  10545e:	90                   	nop
  10545f:	90                   	nop

00105460 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  105460:	55                   	push   %ebp
  105461:	89 e5                	mov    %esp,%ebp
  105463:	8b 4d 08             	mov    0x8(%ebp),%ecx
  105466:	53                   	push   %ebx
  105467:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  10546a:	8b 51 04             	mov    0x4(%ecx),%edx
  10546d:	39 c2                	cmp    %eax,%edx
  10546f:	77 0f                	ja     105480 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  105471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105476:	5b                   	pop    %ebx
  105477:	5d                   	pop    %ebp
  105478:	c3                   	ret    
  105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  105480:	8d 58 04             	lea    0x4(%eax),%ebx
  105483:	39 da                	cmp    %ebx,%edx
  105485:	72 ea                	jb     105471 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  105487:	8b 11                	mov    (%ecx),%edx
  105489:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10548c:	8b 45 10             	mov    0x10(%ebp),%eax
  10548f:	89 10                	mov    %edx,(%eax)
  105491:	31 c0                	xor    %eax,%eax
  return 0;
  105493:	eb e1                	jmp    105476 <fetchint+0x16>
  105495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001054a0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1054a0:	55                   	push   %ebp
  1054a1:	89 e5                	mov    %esp,%ebp
  1054a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1054a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1054a9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  1054aa:	39 50 04             	cmp    %edx,0x4(%eax)
  1054ad:	77 09                	ja     1054b8 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1054af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1054b4:	5b                   	pop    %ebx
  1054b5:	5d                   	pop    %ebp
  1054b6:	c3                   	ret    
  1054b7:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1054b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1054bb:	03 10                	add    (%eax),%edx
  1054bd:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  1054bf:	8b 18                	mov    (%eax),%ebx
  1054c1:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  1054c4:	39 da                	cmp    %ebx,%edx
  1054c6:	73 e7                	jae    1054af <fetchstr+0xf>
    if(*s == 0)
  1054c8:	31 c0                	xor    %eax,%eax
  1054ca:	89 d1                	mov    %edx,%ecx
  1054cc:	80 3a 00             	cmpb   $0x0,(%edx)
  1054cf:	74 e3                	je     1054b4 <fetchstr+0x14>
  1054d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1054d8:	83 c1 01             	add    $0x1,%ecx
  1054db:	39 cb                	cmp    %ecx,%ebx
  1054dd:	76 d0                	jbe    1054af <fetchstr+0xf>
    if(*s == 0)
  1054df:	80 39 00             	cmpb   $0x0,(%ecx)
  1054e2:	75 f4                	jne    1054d8 <fetchstr+0x38>
  1054e4:	89 c8                	mov    %ecx,%eax
  1054e6:	29 d0                	sub    %edx,%eax
  1054e8:	eb ca                	jmp    1054b4 <fetchstr+0x14>
  1054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054f0 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1054f0:	55                   	push   %ebp
  1054f1:	89 e5                	mov    %esp,%ebp
  1054f3:	53                   	push   %ebx
  1054f4:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1054f7:	e8 84 ec ff ff       	call   104180 <curproc>
  1054fc:	8b 55 08             	mov    0x8(%ebp),%edx
  1054ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105505:	8b 40 3c             	mov    0x3c(%eax),%eax
  105508:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  10550c:	e8 6f ec ff ff       	call   104180 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  105511:	8b 50 04             	mov    0x4(%eax),%edx
  105514:	39 d3                	cmp    %edx,%ebx
  105516:	72 10                	jb     105528 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  10551d:	83 c4 04             	add    $0x4,%esp
  105520:	5b                   	pop    %ebx
  105521:	5d                   	pop    %ebp
  105522:	c3                   	ret    
  105523:	90                   	nop
  105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  105528:	8d 4b 04             	lea    0x4(%ebx),%ecx
  10552b:	39 ca                	cmp    %ecx,%edx
  10552d:	72 e9                	jb     105518 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10552f:	8b 00                	mov    (%eax),%eax
  105531:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  105534:	8b 45 0c             	mov    0xc(%ebp),%eax
  105537:	89 10                	mov    %edx,(%eax)
  105539:	31 c0                	xor    %eax,%eax
  10553b:	eb e0                	jmp    10551d <argint+0x2d>
  10553d:	8d 76 00             	lea    0x0(%esi),%esi

00105540 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  105540:	55                   	push   %ebp
  105541:	89 e5                	mov    %esp,%ebp
  105543:	53                   	push   %ebx
  105544:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  105547:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10554a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10554e:	8b 45 08             	mov    0x8(%ebp),%eax
  105551:	89 04 24             	mov    %eax,(%esp)
  105554:	e8 97 ff ff ff       	call   1054f0 <argint>
  105559:	85 c0                	test   %eax,%eax
  10555b:	78 3b                	js     105598 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  10555d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105560:	e8 1b ec ff ff       	call   104180 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  105565:	3b 58 04             	cmp    0x4(%eax),%ebx
  105568:	73 2e                	jae    105598 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  10556a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10556d:	03 18                	add    (%eax),%ebx
  10556f:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  105571:	8b 08                	mov    (%eax),%ecx
  105573:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  105576:	39 cb                	cmp    %ecx,%ebx
  105578:	73 1e                	jae    105598 <argstr+0x58>
    if(*s == 0)
  10557a:	31 c0                	xor    %eax,%eax
  10557c:	89 da                	mov    %ebx,%edx
  10557e:	80 3b 00             	cmpb   $0x0,(%ebx)
  105581:	75 0a                	jne    10558d <argstr+0x4d>
  105583:	eb 18                	jmp    10559d <argstr+0x5d>
  105585:	8d 76 00             	lea    0x0(%esi),%esi
  105588:	80 3a 00             	cmpb   $0x0,(%edx)
  10558b:	74 1b                	je     1055a8 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10558d:	83 c2 01             	add    $0x1,%edx
  105590:	39 d1                	cmp    %edx,%ecx
  105592:	77 f4                	ja     105588 <argstr+0x48>
  105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105598:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10559d:	83 c4 24             	add    $0x24,%esp
  1055a0:	5b                   	pop    %ebx
  1055a1:	5d                   	pop    %ebp
  1055a2:	c3                   	ret    
  1055a3:	90                   	nop
  1055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  1055a8:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  1055aa:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  1055ad:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  1055af:	5b                   	pop    %ebx
  1055b0:	5d                   	pop    %ebp
  1055b1:	c3                   	ret    
  1055b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001055c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1055c0:	55                   	push   %ebp
  1055c1:	89 e5                	mov    %esp,%ebp
  1055c3:	53                   	push   %ebx
  1055c4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1055c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d1:	89 04 24             	mov    %eax,(%esp)
  1055d4:	e8 17 ff ff ff       	call   1054f0 <argint>
  1055d9:	85 c0                	test   %eax,%eax
  1055db:	79 0b                	jns    1055e8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1055dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055e2:	83 c4 24             	add    $0x24,%esp
  1055e5:	5b                   	pop    %ebx
  1055e6:	5d                   	pop    %ebp
  1055e7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1055e8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1055eb:	e8 90 eb ff ff       	call   104180 <curproc>
  1055f0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1055f3:	73 e8                	jae    1055dd <argptr+0x1d>
  1055f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1055f8:	03 5d f4             	add    -0xc(%ebp),%ebx
  1055fb:	e8 80 eb ff ff       	call   104180 <curproc>
  105600:	3b 58 04             	cmp    0x4(%eax),%ebx
  105603:	73 d8                	jae    1055dd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  105605:	e8 76 eb ff ff       	call   104180 <curproc>
  10560a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10560d:	8b 00                	mov    (%eax),%eax
  10560f:	03 45 f4             	add    -0xc(%ebp),%eax
  105612:	89 02                	mov    %eax,(%edx)
  105614:	31 c0                	xor    %eax,%eax
  return 0;
  105616:	eb ca                	jmp    1055e2 <argptr+0x22>
  105618:	90                   	nop
  105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105620 <syscall>:
[SYS_log_init]		sys_log_init,
};

void
syscall(void)
{
  105620:	55                   	push   %ebp
  105621:	89 e5                	mov    %esp,%ebp
  105623:	83 ec 18             	sub    $0x18,%esp
  105626:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105629:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  10562c:	e8 4f eb ff ff       	call   104180 <curproc>
  105631:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105637:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  10563a:	83 fb 1c             	cmp    $0x1c,%ebx
  10563d:	77 29                	ja     105668 <syscall+0x48>
  10563f:	8b 34 9d 60 7a 10 00 	mov    0x107a60(,%ebx,4),%esi
  105646:	85 f6                	test   %esi,%esi
  105648:	74 1e                	je     105668 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  10564a:	e8 31 eb ff ff       	call   104180 <curproc>
  10564f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  105655:	ff d6                	call   *%esi
  105657:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10565a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10565d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105660:	89 ec                	mov    %ebp,%esp
  105662:	5d                   	pop    %ebp
  105663:	c3                   	ret    
  105664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  105668:	e8 13 eb ff ff       	call   104180 <curproc>
  10566d:	89 c6                	mov    %eax,%esi
  10566f:	e8 0c eb ff ff       	call   104180 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  105674:	81 c6 88 00 00 00    	add    $0x88,%esi
  10567a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10567e:	89 74 24 08          	mov    %esi,0x8(%esp)
  105682:	8b 40 10             	mov    0x10(%eax),%eax
  105685:	c7 04 24 26 7a 10 00 	movl   $0x107a26,(%esp)
  10568c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105690:	e8 2b b1 ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  105695:	e8 e6 ea ff ff       	call   104180 <curproc>
  10569a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1056a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  1056a7:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1056aa:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1056ad:	89 ec                	mov    %ebp,%esp
  1056af:	5d                   	pop    %ebp
  1056b0:	c3                   	ret    
  1056b1:	90                   	nop
  1056b2:	90                   	nop
  1056b3:	90                   	nop
  1056b4:	90                   	nop
  1056b5:	90                   	nop
  1056b6:	90                   	nop
  1056b7:	90                   	nop
  1056b8:	90                   	nop
  1056b9:	90                   	nop
  1056ba:	90                   	nop
  1056bb:	90                   	nop
  1056bc:	90                   	nop
  1056bd:	90                   	nop
  1056be:	90                   	nop
  1056bf:	90                   	nop

001056c0 <sys_log_init>:

	log_initialize();

}

void sys_log_init(void){
  1056c0:	55                   	push   %ebp
  1056c1:	89 e5                	mov    %esp,%ebp
  1056c3:	83 ec 08             	sub    $0x8,%esp

	log_initialize();
	return;
}
  1056c6:	c9                   	leave  

}

void sys_log_init(void){

	log_initialize();
  1056c7:	e9 d4 dd ff ff       	jmp    1034a0 <log_initialize>
  1056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001056d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  1056d0:	55                   	push   %ebp
  1056d1:	89 e5                	mov    %esp,%ebp
  1056d3:	57                   	push   %edi
  1056d4:	89 c7                	mov    %eax,%edi
  1056d6:	56                   	push   %esi
  1056d7:	53                   	push   %ebx
  1056d8:	31 db                	xor    %ebx,%ebx
  1056da:	83 ec 0c             	sub    $0xc,%esp
  1056dd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  1056e0:	e8 9b ea ff ff       	call   104180 <curproc>
  1056e5:	8d 73 08             	lea    0x8(%ebx),%esi
  1056e8:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1056eb:	85 c0                	test   %eax,%eax
  1056ed:	74 19                	je     105708 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1056ef:	83 c3 01             	add    $0x1,%ebx
  1056f2:	83 fb 10             	cmp    $0x10,%ebx
  1056f5:	75 e9                	jne    1056e0 <fdalloc+0x10>
  1056f7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  1056fc:	83 c4 0c             	add    $0xc,%esp
  1056ff:	89 d8                	mov    %ebx,%eax
  105701:	5b                   	pop    %ebx
  105702:	5e                   	pop    %esi
  105703:	5f                   	pop    %edi
  105704:	5d                   	pop    %ebp
  105705:	c3                   	ret    
  105706:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  105708:	e8 73 ea ff ff       	call   104180 <curproc>
  10570d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  105710:	83 c4 0c             	add    $0xc,%esp
  105713:	89 d8                	mov    %ebx,%eax
  105715:	5b                   	pop    %ebx
  105716:	5e                   	pop    %esi
  105717:	5f                   	pop    %edi
  105718:	5d                   	pop    %ebp
  105719:	c3                   	ret    
  10571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105720 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  105720:	55                   	push   %ebp
  105721:	89 e5                	mov    %esp,%ebp
  105723:	53                   	push   %ebx
  105724:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  105727:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10572a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  105731:	00 
  105732:	89 44 24 04          	mov    %eax,0x4(%esp)
  105736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10573d:	e8 7e fe ff ff       	call   1055c0 <argptr>
  105742:	85 c0                	test   %eax,%eax
  105744:	79 12                	jns    105758 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  105746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10574b:	83 c4 24             	add    $0x24,%esp
  10574e:	5b                   	pop    %ebx
  10574f:	5d                   	pop    %ebp
  105750:	c3                   	ret    
  105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  105758:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10575b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105762:	89 04 24             	mov    %eax,(%esp)
  105765:	e8 66 e6 ff ff       	call   103dd0 <pipealloc>
  10576a:	85 c0                	test   %eax,%eax
  10576c:	78 d8                	js     105746 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10576e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105771:	e8 5a ff ff ff       	call   1056d0 <fdalloc>
  105776:	85 c0                	test   %eax,%eax
  105778:	89 c3                	mov    %eax,%ebx
  10577a:	78 25                	js     1057a1 <sys_pipe+0x81>
  10577c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10577f:	e8 4c ff ff ff       	call   1056d0 <fdalloc>
  105784:	85 c0                	test   %eax,%eax
  105786:	78 0c                	js     105794 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  105788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  10578b:	89 42 04             	mov    %eax,0x4(%edx)
  10578e:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  105790:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  105792:	eb b7                	jmp    10574b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  105794:	e8 e7 e9 ff ff       	call   104180 <curproc>
  105799:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  1057a0:	00 
    fileclose(rf);
  1057a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a4:	89 04 24             	mov    %eax,(%esp)
  1057a7:	e8 34 b9 ff ff       	call   1010e0 <fileclose>
    fileclose(wf);
  1057ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057af:	89 04 24             	mov    %eax,(%esp)
  1057b2:	e8 29 b9 ff ff       	call   1010e0 <fileclose>
  1057b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1057bc:	eb 8d                	jmp    10574b <sys_pipe+0x2b>
  1057be:	66 90                	xchg   %ax,%ax

001057c0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  1057c0:	55                   	push   %ebp
  1057c1:	89 e5                	mov    %esp,%ebp
  1057c3:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1057c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  1057cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1057cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1057d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1057d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057e0:	e8 5b fd ff ff       	call   105540 <argstr>
  1057e5:	85 c0                	test   %eax,%eax
  1057e7:	79 17                	jns    105800 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  1057e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  1057ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1057f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1057f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1057f7:	89 ec                	mov    %ebp,%esp
  1057f9:	5d                   	pop    %ebp
  1057fa:	c3                   	ret    
  1057fb:	90                   	nop
  1057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105800:	8d 45 e0             	lea    -0x20(%ebp),%eax
  105803:	89 44 24 04          	mov    %eax,0x4(%esp)
  105807:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10580e:	e8 dd fc ff ff       	call   1054f0 <argint>
  105813:	85 c0                	test   %eax,%eax
  105815:	78 d2                	js     1057e9 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  105817:	8d 45 8c             	lea    -0x74(%ebp),%eax
  10581a:	31 ff                	xor    %edi,%edi
  10581c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  105823:	00 
  105824:	31 db                	xor    %ebx,%ebx
  105826:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10582d:	00 
  10582e:	89 04 24             	mov    %eax,(%esp)
  105831:	e8 ea f9 ff ff       	call   105220 <memset>
  105836:	eb 27                	jmp    10585f <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  105838:	e8 43 e9 ff ff       	call   104180 <curproc>
  10583d:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  105841:	89 54 24 08          	mov    %edx,0x8(%esp)
  105845:	89 74 24 04          	mov    %esi,0x4(%esp)
  105849:	89 04 24             	mov    %eax,(%esp)
  10584c:	e8 4f fc ff ff       	call   1054a0 <fetchstr>
  105851:	85 c0                	test   %eax,%eax
  105853:	78 94                	js     1057e9 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  105855:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  105858:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  10585b:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  10585d:	74 8a                	je     1057e9 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  10585f:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  105866:	03 75 e0             	add    -0x20(%ebp),%esi
  105869:	e8 12 e9 ff ff       	call   104180 <curproc>
  10586e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  105871:	89 54 24 08          	mov    %edx,0x8(%esp)
  105875:	89 74 24 04          	mov    %esi,0x4(%esp)
  105879:	89 04 24             	mov    %eax,(%esp)
  10587c:	e8 df fb ff ff       	call   105460 <fetchint>
  105881:	85 c0                	test   %eax,%eax
  105883:	0f 88 60 ff ff ff    	js     1057e9 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  105889:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10588c:	85 f6                	test   %esi,%esi
  10588e:	75 a8                	jne    105838 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  105890:	8d 45 8c             	lea    -0x74(%ebp),%eax
  105893:	89 44 24 04          	mov    %eax,0x4(%esp)
  105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  10589a:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  1058a1:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1058a2:	89 04 24             	mov    %eax,(%esp)
  1058a5:	e8 36 b1 ff ff       	call   1009e0 <exec>
  1058aa:	e9 3f ff ff ff       	jmp    1057ee <sys_exec+0x2e>
  1058af:	90                   	nop

001058b0 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  1058b0:	55                   	push   %ebp
  1058b1:	89 e5                	mov    %esp,%ebp
  1058b3:	53                   	push   %ebx
  1058b4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  1058b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058c5:	e8 76 fc ff ff       	call   105540 <argstr>
  1058ca:	85 c0                	test   %eax,%eax
  1058cc:	79 12                	jns    1058e0 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  1058ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1058d3:	83 c4 24             	add    $0x24,%esp
  1058d6:	5b                   	pop    %ebx
  1058d7:	5d                   	pop    %ebp
  1058d8:	c3                   	ret    
  1058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  1058e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058e3:	89 04 24             	mov    %eax,(%esp)
  1058e6:	e8 85 c9 ff ff       	call   102270 <namei>
  1058eb:	85 c0                	test   %eax,%eax
  1058ed:	89 c3                	mov    %eax,%ebx
  1058ef:	74 dd                	je     1058ce <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  1058f1:	89 04 24             	mov    %eax,(%esp)
  1058f4:	e8 d7 c6 ff ff       	call   101fd0 <ilock>
  if(ip->type != T_DIR){
  1058f9:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1058fe:	75 24                	jne    105924 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105900:	89 1c 24             	mov    %ebx,(%esp)
  105903:	e8 58 c6 ff ff       	call   101f60 <iunlock>
  iput(cp->cwd);
  105908:	e8 73 e8 ff ff       	call   104180 <curproc>
  10590d:	8b 40 60             	mov    0x60(%eax),%eax
  105910:	89 04 24             	mov    %eax,(%esp)
  105913:	e8 68 c3 ff ff       	call   101c80 <iput>
  cp->cwd = ip;
  105918:	e8 63 e8 ff ff       	call   104180 <curproc>
  10591d:	89 58 60             	mov    %ebx,0x60(%eax)
  105920:	31 c0                	xor    %eax,%eax
  return 0;
  105922:	eb af                	jmp    1058d3 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  105924:	89 1c 24             	mov    %ebx,(%esp)
  105927:	e8 84 c6 ff ff       	call   101fb0 <iunlockput>
  10592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  105931:	eb a0                	jmp    1058d3 <sys_chdir+0x23>
  105933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105940 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105940:	55                   	push   %ebp
  105941:	89 e5                	mov    %esp,%ebp
  105943:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105946:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105949:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10594c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10594f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105952:	89 44 24 04          	mov    %eax,0x4(%esp)
  105956:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10595d:	e8 de fb ff ff       	call   105540 <argstr>
  105962:	85 c0                	test   %eax,%eax
  105964:	79 12                	jns    105978 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  105966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10596b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10596e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105971:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105974:	89 ec                	mov    %ebp,%esp
  105976:	5d                   	pop    %ebp
  105977:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105978:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10597b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10597f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105986:	e8 b5 fb ff ff       	call   105540 <argstr>
  10598b:	85 c0                	test   %eax,%eax
  10598d:	78 d7                	js     105966 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  10598f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105992:	89 04 24             	mov    %eax,(%esp)
  105995:	e8 d6 c8 ff ff       	call   102270 <namei>
  10599a:	85 c0                	test   %eax,%eax
  10599c:	89 c3                	mov    %eax,%ebx
  10599e:	74 c6                	je     105966 <sys_link+0x26>
    return -1;
  ilock(ip);
  1059a0:	89 04 24             	mov    %eax,(%esp)
  1059a3:	e8 28 c6 ff ff       	call   101fd0 <ilock>
  if(ip->type == T_DIR){
  1059a8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1059ad:	0f 84 86 00 00 00    	je     105a39 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  1059b3:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  1059b8:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  1059bb:	89 1c 24             	mov    %ebx,(%esp)
  1059be:	e8 cd b8 ff ff       	call   101290 <iupdate>
  iunlock(ip);
  1059c3:	89 1c 24             	mov    %ebx,(%esp)
  1059c6:	e8 95 c5 ff ff       	call   101f60 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  1059cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1059d2:	89 04 24             	mov    %eax,(%esp)
  1059d5:	e8 76 c8 ff ff       	call   102250 <nameiparent>
  1059da:	85 c0                	test   %eax,%eax
  1059dc:	89 c6                	mov    %eax,%esi
  1059de:	74 44                	je     105a24 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  1059e0:	89 04 24             	mov    %eax,(%esp)
  1059e3:	e8 e8 c5 ff ff       	call   101fd0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  1059e8:	8b 06                	mov    (%esi),%eax
  1059ea:	3b 03                	cmp    (%ebx),%eax
  1059ec:	75 2e                	jne    105a1c <sys_link+0xdc>
  1059ee:	8b 43 04             	mov    0x4(%ebx),%eax
  1059f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1059f5:	89 34 24             	mov    %esi,(%esp)
  1059f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059fc:	e8 6f c4 ff ff       	call   101e70 <dirlink>
  105a01:	85 c0                	test   %eax,%eax
  105a03:	78 17                	js     105a1c <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  105a05:	89 34 24             	mov    %esi,(%esp)
  105a08:	e8 a3 c5 ff ff       	call   101fb0 <iunlockput>
  iput(ip);
  105a0d:	89 1c 24             	mov    %ebx,(%esp)
  105a10:	e8 6b c2 ff ff       	call   101c80 <iput>
  105a15:	31 c0                	xor    %eax,%eax
  return 0;
  105a17:	e9 4f ff ff ff       	jmp    10596b <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  105a1c:	89 34 24             	mov    %esi,(%esp)
  105a1f:	e8 8c c5 ff ff       	call   101fb0 <iunlockput>
  ilock(ip);
  105a24:	89 1c 24             	mov    %ebx,(%esp)
  105a27:	e8 a4 c5 ff ff       	call   101fd0 <ilock>
  ip->nlink--;
  105a2c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  105a31:	89 1c 24             	mov    %ebx,(%esp)
  105a34:	e8 57 b8 ff ff       	call   101290 <iupdate>
  iunlockput(ip);
  105a39:	89 1c 24             	mov    %ebx,(%esp)
  105a3c:	e8 6f c5 ff ff       	call   101fb0 <iunlockput>
  105a41:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  105a44:	e9 22 ff ff ff       	jmp    10596b <sys_link+0x2b>
  105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105a50 <create>:
  return 0;
}

struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105a50:	55                   	push   %ebp
  105a51:	89 e5                	mov    %esp,%ebp
  105a53:	83 ec 58             	sub    $0x58,%esp
  105a56:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  105a5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105a5d:	8d 7d d6             	lea    -0x2a(%ebp),%edi
  return 0;
}

struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105a60:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105a63:	31 db                	xor    %ebx,%ebx
  return 0;
}

struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105a65:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105a68:	66 89 45 c6          	mov    %ax,-0x3a(%ebp)
  105a6c:	0f b7 45 14          	movzwl 0x14(%ebp),%eax
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105a70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  return 0;
}

struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105a74:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
  105a78:	0f b7 45 18          	movzwl 0x18(%ebp),%eax
  105a7c:	66 89 45 c2          	mov    %ax,-0x3e(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105a80:	8b 45 08             	mov    0x8(%ebp),%eax
  105a83:	89 04 24             	mov    %eax,(%esp)
  105a86:	e8 c5 c7 ff ff       	call   102250 <nameiparent>
  105a8b:	85 c0                	test   %eax,%eax
  105a8d:	89 c6                	mov    %eax,%esi
  105a8f:	74 67                	je     105af8 <create+0xa8>
    return 0;
  ilock(dp);
  105a91:	89 04 24             	mov    %eax,(%esp)
  105a94:	e8 37 c5 ff ff       	call   101fd0 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  105a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a9c:	85 d2                	test   %edx,%edx
  105a9e:	74 68                	je     105b08 <create+0xb8>
  105aa0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  105aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  105aa7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105aab:	89 34 24             	mov    %esi,(%esp)
  105aae:	e8 cd bf ff ff       	call   101a80 <dirlookup>
  105ab3:	85 c0                	test   %eax,%eax
  105ab5:	89 c3                	mov    %eax,%ebx
  105ab7:	74 4f                	je     105b08 <create+0xb8>
    iunlockput(dp);
  105ab9:	89 34 24             	mov    %esi,(%esp)
  105abc:	e8 ef c4 ff ff       	call   101fb0 <iunlockput>
    ilock(ip);
  105ac1:	89 1c 24             	mov    %ebx,(%esp)
  105ac4:	e8 07 c5 ff ff       	call   101fd0 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105ac9:	0f b7 45 c6          	movzwl -0x3a(%ebp),%eax
  105acd:	66 39 43 10          	cmp    %ax,0x10(%ebx)
  105ad1:	0f 85 f1 00 00 00    	jne    105bc8 <create+0x178>
  105ad7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  105adb:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105adf:	0f 85 e3 00 00 00    	jne    105bc8 <create+0x178>
  105ae5:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  105ae9:	66 39 43 14          	cmp    %ax,0x14(%ebx)
  105aed:	0f 85 d5 00 00 00    	jne    105bc8 <create+0x178>
  105af3:	90                   	nop
  105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  105af8:	89 d8                	mov    %ebx,%eax
  105afa:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105afd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105b00:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105b03:	89 ec                	mov    %ebp,%esp
  105b05:	5d                   	pop    %ebp
  105b06:	c3                   	ret    
  105b07:	90                   	nop
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105b08:	0f bf 45 c6          	movswl -0x3a(%ebp),%eax
  105b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b10:	8b 06                	mov    (%esi),%eax
  105b12:	89 04 24             	mov    %eax,(%esp)
  105b15:	e8 86 c0 ff ff       	call   101ba0 <ialloc>
  105b1a:	85 c0                	test   %eax,%eax
  105b1c:	89 c3                	mov    %eax,%ebx
  105b1e:	74 44                	je     105b64 <create+0x114>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105b20:	89 04 24             	mov    %eax,(%esp)
  105b23:	e8 a8 c4 ff ff       	call   101fd0 <ilock>
  ip->major = major;
  105b28:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  105b2c:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  105b32:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  105b36:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  105b3a:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105b3e:	89 1c 24             	mov    %ebx,(%esp)
  105b41:	e8 4a b7 ff ff       	call   101290 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  105b46:	8b 43 04             	mov    0x4(%ebx),%eax
  105b49:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105b4d:	89 34 24             	mov    %esi,(%esp)
  105b50:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b54:	e8 17 c3 ff ff       	call   101e70 <dirlink>
  105b59:	85 c0                	test   %eax,%eax
  105b5b:	78 7a                	js     105bd7 <create+0x187>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  105b5d:	66 83 7d c6 01       	cmpw   $0x1,-0x3a(%ebp)
  105b62:	74 14                	je     105b78 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  105b64:	89 34 24             	mov    %esi,(%esp)
  105b67:	e8 44 c4 ff ff       	call   101fb0 <iunlockput>
  105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return ip;
  105b70:	eb 86                	jmp    105af8 <create+0xa8>
  105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  105b78:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  105b7d:	89 34 24             	mov    %esi,(%esp)
  105b80:	e8 0b b7 ff ff       	call   101290 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  105b85:	8b 43 04             	mov    0x4(%ebx),%eax
  105b88:	c7 44 24 04 d5 7a 10 	movl   $0x107ad5,0x4(%esp)
  105b8f:	00 
  105b90:	89 1c 24             	mov    %ebx,(%esp)
  105b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b97:	e8 d4 c2 ff ff       	call   101e70 <dirlink>
  105b9c:	85 c0                	test   %eax,%eax
  105b9e:	78 1b                	js     105bbb <create+0x16b>
  105ba0:	8b 46 04             	mov    0x4(%esi),%eax
  105ba3:	c7 44 24 04 d4 7a 10 	movl   $0x107ad4,0x4(%esp)
  105baa:	00 
  105bab:	89 1c 24             	mov    %ebx,(%esp)
  105bae:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bb2:	e8 b9 c2 ff ff       	call   101e70 <dirlink>
  105bb7:	85 c0                	test   %eax,%eax
  105bb9:	79 a9                	jns    105b64 <create+0x114>
      panic("create dots");
  105bbb:	c7 04 24 d7 7a 10 00 	movl   $0x107ad7,(%esp)
  105bc2:	e8 99 ad ff ff       	call   100960 <panic>
  105bc7:	90                   	nop

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  105bc8:	89 1c 24             	mov    %ebx,(%esp)
  105bcb:	31 db                	xor    %ebx,%ebx
  105bcd:	e8 de c3 ff ff       	call   101fb0 <iunlockput>
      return 0;
  105bd2:	e9 21 ff ff ff       	jmp    105af8 <create+0xa8>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105bd7:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  105bdd:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  105be0:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  105be2:	e8 c9 c3 ff ff       	call   101fb0 <iunlockput>
    iunlockput(dp);
  105be7:	89 34 24             	mov    %esi,(%esp)
  105bea:	e8 c1 c3 ff ff       	call   101fb0 <iunlockput>
    return 0;
  105bef:	e9 04 ff ff ff       	jmp    105af8 <create+0xa8>
  105bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105c00 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105c00:	55                   	push   %ebp
  105c01:	89 e5                	mov    %esp,%ebp
  105c03:	83 ec 38             	sub    $0x38,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105c14:	e8 27 f9 ff ff       	call   105540 <argstr>
  105c19:	85 c0                	test   %eax,%eax
  105c1b:	79 0b                	jns    105c28 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  105c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105c22:	c9                   	leave  
  105c23:	c3                   	ret    
  105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105c28:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  105c2f:	00 
  105c30:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105c37:	00 
  105c38:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  105c3f:	00 
  105c40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105c47:	00 
  105c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c4b:	89 04 24             	mov    %eax,(%esp)
  105c4e:	e8 fd fd ff ff       	call   105a50 <create>
  105c53:	85 c0                	test   %eax,%eax
  105c55:	74 c6                	je     105c1d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  105c57:	89 04 24             	mov    %eax,(%esp)
  105c5a:	e8 51 c3 ff ff       	call   101fb0 <iunlockput>
  105c5f:	31 c0                	xor    %eax,%eax
  return 0;
}
  105c61:	c9                   	leave  
  105c62:	c3                   	ret    
  105c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105c70 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  105c70:	55                   	push   %ebp
  105c71:	89 e5                	mov    %esp,%ebp
  105c73:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105c76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105c84:	e8 b7 f8 ff ff       	call   105540 <argstr>
  105c89:	85 c0                	test   %eax,%eax
  105c8b:	79 0b                	jns    105c98 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  105c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105c92:	c9                   	leave  
  105c93:	c3                   	ret    
  105c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  105c98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105ca6:	e8 45 f8 ff ff       	call   1054f0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105cab:	85 c0                	test   %eax,%eax
  105cad:	78 de                	js     105c8d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  105caf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cb6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105cbd:	e8 2e f8 ff ff       	call   1054f0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105cc2:	85 c0                	test   %eax,%eax
  105cc4:	78 c7                	js     105c8d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  105cc6:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  105cca:	89 44 24 10          	mov    %eax,0x10(%esp)
  105cce:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  105cd2:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
  105cd9:	00 
  105cda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105ce1:	00 
  105ce2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105ce9:	89 04 24             	mov    %eax,(%esp)
  105cec:	e8 5f fd ff ff       	call   105a50 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105cf1:	85 c0                	test   %eax,%eax
  105cf3:	74 98                	je     105c8d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105cf5:	89 04 24             	mov    %eax,(%esp)
  105cf8:	e8 b3 c2 ff ff       	call   101fb0 <iunlockput>
  105cfd:	31 c0                	xor    %eax,%eax
  return 0;
}
  105cff:	c9                   	leave  
  105d00:	c3                   	ret    
  105d01:	eb 0d                	jmp    105d10 <sys_open>
  105d03:	90                   	nop
  105d04:	90                   	nop
  105d05:	90                   	nop
  105d06:	90                   	nop
  105d07:	90                   	nop
  105d08:	90                   	nop
  105d09:	90                   	nop
  105d0a:	90                   	nop
  105d0b:	90                   	nop
  105d0c:	90                   	nop
  105d0d:	90                   	nop
  105d0e:	90                   	nop
  105d0f:	90                   	nop

00105d10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105d10:	55                   	push   %ebp
  105d11:	89 e5                	mov    %esp,%ebp
  105d13:	83 ec 48             	sub    $0x48,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105d16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105d19:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105d1c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105d2a:	e8 11 f8 ff ff       	call   105540 <argstr>
  105d2f:	85 c0                	test   %eax,%eax
  105d31:	79 15                	jns    105d48 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105d38:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105d3b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105d3e:	89 ec                	mov    %ebp,%esp
  105d40:	5d                   	pop    %ebp
  105d41:	c3                   	ret    
  105d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105d48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105d56:	e8 95 f7 ff ff       	call   1054f0 <argint>
  105d5b:	85 c0                	test   %eax,%eax
  105d5d:	78 d4                	js     105d33 <sys_open+0x23>
    return -1;

  //cprintf("%s\n", path);

  if(omode & O_CREATE){
  105d5f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  105d63:	0f 84 7f 00 00 00    	je     105de8 <sys_open+0xd8>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d6c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  105d73:	00 
  105d74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  105d7b:	00 
  105d7c:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  105d83:	00 
  105d84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105d8b:	00 
  105d8c:	89 04 24             	mov    %eax,(%esp)
  105d8f:	e8 bc fc ff ff       	call   105a50 <create>
  105d94:	85 c0                	test   %eax,%eax
  105d96:	89 c6                	mov    %eax,%esi
  105d98:	74 99                	je     105d33 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  105d9a:	e8 b1 b2 ff ff       	call   101050 <filealloc>
  105d9f:	85 c0                	test   %eax,%eax
  105da1:	89 c3                	mov    %eax,%ebx
  105da3:	74 6d                	je     105e12 <sys_open+0x102>
  105da5:	e8 26 f9 ff ff       	call   1056d0 <fdalloc>
  105daa:	85 c0                	test   %eax,%eax
  105dac:	78 77                	js     105e25 <sys_open+0x115>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105db1:	89 34 24             	mov    %esi,(%esp)
  105db4:	e8 a7 c1 ff ff       	call   101f60 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  105db9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  105dbc:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  105dc2:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  105dc5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  105dcc:	89 d1                	mov    %edx,%ecx
  105dce:	83 f1 01             	xor    $0x1,%ecx
  105dd1:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105dd4:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  105dd7:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105dda:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105de1:	e9 52 ff ff ff       	jmp    105d38 <sys_open+0x28>
  105de6:	66 90                	xchg   %ax,%ax

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105deb:	89 04 24             	mov    %eax,(%esp)
  105dee:	e8 7d c4 ff ff       	call   102270 <namei>
  105df3:	85 c0                	test   %eax,%eax
  105df5:	89 c6                	mov    %eax,%esi
  105df7:	0f 84 36 ff ff ff    	je     105d33 <sys_open+0x23>
      return -1;
    ilock(ip);
  105dfd:	89 04 24             	mov    %eax,(%esp)
  105e00:	e8 cb c1 ff ff       	call   101fd0 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  105e05:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105e0a:	75 8e                	jne    105d9a <sys_open+0x8a>
  105e0c:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  105e10:	74 88                	je     105d9a <sys_open+0x8a>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  105e12:	89 34 24             	mov    %esi,(%esp)
  105e15:	e8 96 c1 ff ff       	call   101fb0 <iunlockput>
  105e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105e1f:	90                   	nop
    return -1;
  105e20:	e9 13 ff ff ff       	jmp    105d38 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  105e25:	89 1c 24             	mov    %ebx,(%esp)
  105e28:	e8 b3 b2 ff ff       	call   1010e0 <fileclose>
  105e2d:	8d 76 00             	lea    0x0(%esi),%esi
  105e30:	eb e0                	jmp    105e12 <sys_open+0x102>
  105e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105e40 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105e40:	55                   	push   %ebp
  105e41:	89 e5                	mov    %esp,%ebp
  105e43:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105e46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105e49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105e4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105e4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105e5d:	e8 de f6 ff ff       	call   105540 <argstr>
  105e62:	85 c0                	test   %eax,%eax
  105e64:	79 12                	jns    105e78 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  105e66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105e6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105e6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105e71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e74:	89 ec                	mov    %ebp,%esp
  105e76:	5d                   	pop    %ebp
  105e77:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  105e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e7b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  105e7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105e82:	89 04 24             	mov    %eax,(%esp)
  105e85:	e8 c6 c3 ff ff       	call   102250 <nameiparent>
  105e8a:	85 c0                	test   %eax,%eax
  105e8c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  105e8f:	74 d5                	je     105e66 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  105e91:	89 04 24             	mov    %eax,(%esp)
  105e94:	e8 37 c1 ff ff       	call   101fd0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  105e99:	c7 44 24 04 d5 7a 10 	movl   $0x107ad5,0x4(%esp)
  105ea0:	00 
  105ea1:	89 1c 24             	mov    %ebx,(%esp)
  105ea4:	e8 b7 b3 ff ff       	call   101260 <namecmp>
  105ea9:	85 c0                	test   %eax,%eax
  105eab:	0f 84 a4 00 00 00    	je     105f55 <sys_unlink+0x115>
  105eb1:	c7 44 24 04 d4 7a 10 	movl   $0x107ad4,0x4(%esp)
  105eb8:	00 
  105eb9:	89 1c 24             	mov    %ebx,(%esp)
  105ebc:	e8 9f b3 ff ff       	call   101260 <namecmp>
  105ec1:	85 c0                	test   %eax,%eax
  105ec3:	0f 84 8c 00 00 00    	je     105f55 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  105ec9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  105ecc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ed0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105ed3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105ed7:	89 04 24             	mov    %eax,(%esp)
  105eda:	e8 a1 bb ff ff       	call   101a80 <dirlookup>
  105edf:	85 c0                	test   %eax,%eax
  105ee1:	89 c6                	mov    %eax,%esi
  105ee3:	74 70                	je     105f55 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105ee5:	89 04 24             	mov    %eax,(%esp)
  105ee8:	e8 e3 c0 ff ff       	call   101fd0 <ilock>

  if(ip->nlink < 1)
  105eed:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105ef2:	0f 8e e9 00 00 00    	jle    105fe1 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105ef8:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105efd:	75 71                	jne    105f70 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  105eff:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105f03:	76 6b                	jbe    105f70 <sys_unlink+0x130>
  105f05:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  105f08:	bb 20 00 00 00       	mov    $0x20,%ebx
  105f0d:	8d 76 00             	lea    0x0(%esi),%esi
  105f10:	eb 0e                	jmp    105f20 <sys_unlink+0xe0>
  105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105f18:	83 c3 10             	add    $0x10,%ebx
  105f1b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  105f1e:	73 50                	jae    105f70 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105f20:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105f27:	00 
  105f28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105f2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105f30:	89 34 24             	mov    %esi,(%esp)
  105f33:	e8 c8 b6 ff ff       	call   101600 <readi>
  105f38:	83 f8 10             	cmp    $0x10,%eax
  105f3b:	0f 85 94 00 00 00    	jne    105fd5 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  105f41:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  105f46:	74 d0                	je     105f18 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105f48:	89 34 24             	mov    %esi,(%esp)
  105f4b:	90                   	nop
  105f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105f50:	e8 5b c0 ff ff       	call   101fb0 <iunlockput>
    iunlockput(dp);
  105f55:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105f58:	89 04 24             	mov    %eax,(%esp)
  105f5b:	e8 50 c0 ff ff       	call   101fb0 <iunlockput>
  105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  105f65:	e9 01 ff ff ff       	jmp    105e6b <sys_unlink+0x2b>
  105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  105f70:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  105f73:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105f7a:	00 
  105f7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105f82:	00 
  105f83:	89 1c 24             	mov    %ebx,(%esp)
  105f86:	e8 95 f2 ff ff       	call   105220 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f8e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105f95:	00 
  105f96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f9e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105fa1:	89 04 24             	mov    %eax,(%esp)
  105fa4:	e8 77 b7 ff ff       	call   101720 <writei>
  105fa9:	83 f8 10             	cmp    $0x10,%eax
  105fac:	75 3f                	jne    105fed <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  105fae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105fb1:	89 04 24             	mov    %eax,(%esp)
  105fb4:	e8 f7 bf ff ff       	call   101fb0 <iunlockput>

  ip->nlink--;
  105fb9:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  105fbe:	89 34 24             	mov    %esi,(%esp)
  105fc1:	e8 ca b2 ff ff       	call   101290 <iupdate>
  iunlockput(ip);
  105fc6:	89 34 24             	mov    %esi,(%esp)
  105fc9:	e8 e2 bf ff ff       	call   101fb0 <iunlockput>
  105fce:	31 c0                	xor    %eax,%eax
  return 0;
  105fd0:	e9 96 fe ff ff       	jmp    105e6b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  105fd5:	c7 04 24 f5 7a 10 00 	movl   $0x107af5,(%esp)
  105fdc:	e8 7f a9 ff ff       	call   100960 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105fe1:	c7 04 24 e3 7a 10 00 	movl   $0x107ae3,(%esp)
  105fe8:	e8 73 a9 ff ff       	call   100960 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  105fed:	c7 04 24 07 7b 10 00 	movl   $0x107b07,(%esp)
  105ff4:	e8 67 a9 ff ff       	call   100960 <panic>
  105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106000 <T.63>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  106000:	55                   	push   %ebp
  106001:	89 e5                	mov    %esp,%ebp
  106003:	83 ec 28             	sub    $0x28,%esp
  106006:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  106009:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10600b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  10600e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  106011:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  106013:	89 44 24 04          	mov    %eax,0x4(%esp)
  106017:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10601e:	e8 cd f4 ff ff       	call   1054f0 <argint>
  106023:	85 c0                	test   %eax,%eax
  106025:	79 11                	jns    106038 <T.63+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  106027:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  10602c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10602f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  106032:	89 ec                	mov    %ebp,%esp
  106034:	5d                   	pop    %ebp
  106035:	c3                   	ret    
  106036:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  106038:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  10603c:	77 e9                	ja     106027 <T.63+0x27>
  10603e:	e8 3d e1 ff ff       	call   104180 <curproc>
  106043:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  106046:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  10604a:	85 d2                	test   %edx,%edx
  10604c:	74 d9                	je     106027 <T.63+0x27>
    return -1;
  if(pfd)
  10604e:	85 db                	test   %ebx,%ebx
  106050:	74 02                	je     106054 <T.63+0x54>
    *pfd = fd;
  106052:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  106054:	31 c0                	xor    %eax,%eax
  106056:	85 f6                	test   %esi,%esi
  106058:	74 d2                	je     10602c <T.63+0x2c>
    *pf = f;
  10605a:	89 16                	mov    %edx,(%esi)
  10605c:	eb ce                	jmp    10602c <T.63+0x2c>
  10605e:	66 90                	xchg   %ax,%ax

00106060 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  106060:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106061:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  106063:	89 e5                	mov    %esp,%ebp
  106065:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106068:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10606b:	e8 90 ff ff ff       	call   106000 <T.63>
  106070:	85 c0                	test   %eax,%eax
  106072:	79 0c                	jns    106080 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  106074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  106079:	c9                   	leave  
  10607a:	c3                   	ret    
  10607b:	90                   	nop
  10607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106080:	8d 45 f0             	lea    -0x10(%ebp),%eax
  106083:	89 44 24 04          	mov    %eax,0x4(%esp)
  106087:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10608e:	e8 5d f4 ff ff       	call   1054f0 <argint>
  106093:	85 c0                	test   %eax,%eax
  106095:	78 dd                	js     106074 <sys_read+0x14>
  106097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10609a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1060a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1060a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060ac:	e8 0f f5 ff ff       	call   1055c0 <argptr>
  1060b1:	85 c0                	test   %eax,%eax
  1060b3:	78 bf                	js     106074 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  1060b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1060c6:	89 04 24             	mov    %eax,(%esp)
  1060c9:	e8 32 ae ff ff       	call   100f00 <fileread>
}
  1060ce:	c9                   	leave  
  1060cf:	c3                   	ret    

001060d0 <sys_write>:

int
sys_write(void)
{
  1060d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1060d1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1060d3:	89 e5                	mov    %esp,%ebp
  1060d5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1060d8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1060db:	e8 20 ff ff ff       	call   106000 <T.63>
  1060e0:	85 c0                	test   %eax,%eax
  1060e2:	79 0c                	jns    1060f0 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  1060e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1060e9:	c9                   	leave  
  1060ea:	c3                   	ret    
  1060eb:	90                   	nop
  1060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1060f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1060f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060f7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1060fe:	e8 ed f3 ff ff       	call   1054f0 <argint>
  106103:	85 c0                	test   %eax,%eax
  106105:	78 dd                	js     1060e4 <sys_write+0x14>
  106107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10610a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106111:	89 44 24 08          	mov    %eax,0x8(%esp)
  106115:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10611c:	e8 9f f4 ff ff       	call   1055c0 <argptr>
  106121:	85 c0                	test   %eax,%eax
  106123:	78 bf                	js     1060e4 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  106125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106128:	89 44 24 08          	mov    %eax,0x8(%esp)
  10612c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10612f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106136:	89 04 24             	mov    %eax,(%esp)
  106139:	e8 a2 ac ff ff       	call   100de0 <filewrite>
}
  10613e:	c9                   	leave  
  10613f:	c3                   	ret    

00106140 <sys_dup>:

int
sys_dup(void)
{
  106140:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  106141:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  106143:	89 e5                	mov    %esp,%ebp
  106145:	53                   	push   %ebx
  106146:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  106149:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10614c:	e8 af fe ff ff       	call   106000 <T.63>
  106151:	85 c0                	test   %eax,%eax
  106153:	79 13                	jns    106168 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  106155:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10615a:	89 d8                	mov    %ebx,%eax
  10615c:	83 c4 24             	add    $0x24,%esp
  10615f:	5b                   	pop    %ebx
  106160:	5d                   	pop    %ebp
  106161:	c3                   	ret    
  106162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  106168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10616b:	e8 60 f5 ff ff       	call   1056d0 <fdalloc>
  106170:	85 c0                	test   %eax,%eax
  106172:	89 c3                	mov    %eax,%ebx
  106174:	78 df                	js     106155 <sys_dup+0x15>
    return -1;
  filedup(f);
  106176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106179:	89 04 24             	mov    %eax,(%esp)
  10617c:	e8 7f ae ff ff       	call   101000 <filedup>
  return fd;
  106181:	eb d7                	jmp    10615a <sys_dup+0x1a>
  106183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106190 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  106190:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106191:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  106193:	89 e5                	mov    %esp,%ebp
  106195:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106198:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10619b:	e8 60 fe ff ff       	call   106000 <T.63>
  1061a0:	85 c0                	test   %eax,%eax
  1061a2:	79 0c                	jns    1061b0 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  1061a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1061a9:	c9                   	leave  
  1061aa:	c3                   	ret    
  1061ab:	90                   	nop
  1061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1061b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1061b3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1061ba:	00 
  1061bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1061c6:	e8 f5 f3 ff ff       	call   1055c0 <argptr>
  1061cb:	85 c0                	test   %eax,%eax
  1061cd:	78 d5                	js     1061a4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  1061cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1061d9:	89 04 24             	mov    %eax,(%esp)
  1061dc:	e8 cf ad ff ff       	call   100fb0 <filestat>
}
  1061e1:	c9                   	leave  
  1061e2:	c3                   	ret    
  1061e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1061e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001061f0 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  1061f0:	55                   	push   %ebp
  1061f1:	89 e5                	mov    %esp,%ebp
  1061f3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  1061f6:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1061f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1061fc:	e8 ff fd ff ff       	call   106000 <T.63>
  106201:	89 c2                	mov    %eax,%edx
  106203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  106208:	85 d2                	test   %edx,%edx
  10620a:	78 1d                	js     106229 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10620c:	e8 6f df ff ff       	call   104180 <curproc>
  106211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106214:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10621b:	00 
  fileclose(f);
  10621c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10621f:	89 04 24             	mov    %eax,(%esp)
  106222:	e8 b9 ae ff ff       	call   1010e0 <fileclose>
  106227:	31 c0                	xor    %eax,%eax
  return 0;
}
  106229:	c9                   	leave  
  10622a:	c3                   	ret    
  10622b:	90                   	nop
  10622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106230 <sys_check>:
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  106230:	55                   	push   %ebp


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  106231:	31 c0                	xor    %eax,%eax
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  106233:	89 e5                	mov    %esp,%ebp
  106235:	83 ec 28             	sub    $0x28,%esp


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  106238:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10623b:	e8 c0 fd ff ff       	call   106000 <T.63>
  106240:	85 c0                	test   %eax,%eax
  106242:	79 0c                	jns    106250 <sys_check+0x20>
		return -1;
	return filecheck(f, off);
  106244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	log_initialize();

}
  106249:	c9                   	leave  
  10624a:	c3                   	ret    
  10624b:	90                   	nop
  10624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  106250:	8d 45 f0             	lea    -0x10(%ebp),%eax
  106253:	89 44 24 04          	mov    %eax,0x4(%esp)
  106257:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10625e:	e8 8d f2 ff ff       	call   1054f0 <argint>
  106263:	85 c0                	test   %eax,%eax
  106265:	78 dd                	js     106244 <sys_check+0x14>
		return -1;
	return filecheck(f, off);
  106267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10626a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10626e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106271:	89 04 24             	mov    %eax,(%esp)
  106274:	e8 17 ac ff ff       	call   100e90 <filecheck>

	log_initialize();

}
  106279:	c9                   	leave  
  10627a:	c3                   	ret    
  10627b:	90                   	nop
  10627c:	90                   	nop
  10627d:	90                   	nop
  10627e:	90                   	nop
  10627f:	90                   	nop

00106280 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  106280:	55                   	push   %ebp
return ticks;
}
  106281:	a1 00 06 11 00       	mov    0x110600,%eax
	return 0;
}

int
sys_tick(void)
{
  106286:	89 e5                	mov    %esp,%ebp
return ticks;
}
  106288:	5d                   	pop    %ebp
  106289:	c3                   	ret    
  10628a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106290 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  106290:	55                   	push   %ebp
  106291:	89 e5                	mov    %esp,%ebp
  106293:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  106296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  106299:	89 44 24 04          	mov    %eax,0x4(%esp)
  10629d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1062a4:	e8 47 f2 ff ff       	call   1054f0 <argint>
  1062a9:	89 c2                	mov    %eax,%edx
  1062ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1062b0:	85 d2                	test   %edx,%edx
  1062b2:	78 0d                	js     1062c1 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  1062b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1062b7:	89 04 24             	mov    %eax,(%esp)
  1062ba:	e8 f1 db ff ff       	call   103eb0 <wake_lock>
  1062bf:	31 c0                	xor    %eax,%eax

	return 0;
}
  1062c1:	c9                   	leave  
  1062c2:	c3                   	ret    
  1062c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001062d0 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  1062d0:	55                   	push   %ebp
  1062d1:	89 e5                	mov    %esp,%ebp
  1062d3:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  1062d6:	e8 05 e1 ff ff       	call   1043e0 <sleep_lock>
	return 0;
}
  1062db:	31 c0                	xor    %eax,%eax
  1062dd:	c9                   	leave  
  1062de:	c3                   	ret    
  1062df:	90                   	nop

001062e0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1062e0:	55                   	push   %ebp
  1062e1:	89 e5                	mov    %esp,%ebp
  1062e3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1062e6:	e8 95 de ff ff       	call   104180 <curproc>
  1062eb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1062ee:	c9                   	leave  
  1062ef:	c3                   	ret    

001062f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1062f0:	55                   	push   %ebp
  1062f1:	89 e5                	mov    %esp,%ebp
  1062f3:	53                   	push   %ebx
  1062f4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  1062f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1062fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106305:	e8 e6 f1 ff ff       	call   1054f0 <argint>
  10630a:	89 c2                	mov    %eax,%edx
  10630c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  106311:	85 d2                	test   %edx,%edx
  106313:	78 58                	js     10636d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  106315:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10631c:	e8 8f ee ff ff       	call   1051b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  106321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  106324:	8b 1d 00 06 11 00    	mov    0x110600,%ebx
  while(ticks - ticks0 < n){
  10632a:	85 d2                	test   %edx,%edx
  10632c:	7f 22                	jg     106350 <sys_sleep+0x60>
  10632e:	eb 48                	jmp    106378 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  106330:	c7 44 24 04 c0 fd 10 	movl   $0x10fdc0,0x4(%esp)
  106337:	00 
  106338:	c7 04 24 00 06 11 00 	movl   $0x110600,(%esp)
  10633f:	e8 ec e0 ff ff       	call   104430 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  106344:	a1 00 06 11 00       	mov    0x110600,%eax
  106349:	29 d8                	sub    %ebx,%eax
  10634b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10634e:	7d 28                	jge    106378 <sys_sleep+0x88>
    if(cp->killed){
  106350:	e8 2b de ff ff       	call   104180 <curproc>
  106355:	8b 40 1c             	mov    0x1c(%eax),%eax
  106358:	85 c0                	test   %eax,%eax
  10635a:	74 d4                	je     106330 <sys_sleep+0x40>
      release(&tickslock);
  10635c:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  106363:	e8 08 ee ff ff       	call   105170 <release>
  106368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10636d:	83 c4 24             	add    $0x24,%esp
  106370:	5b                   	pop    %ebx
  106371:	5d                   	pop    %ebp
  106372:	c3                   	ret    
  106373:	90                   	nop
  106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  106378:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10637f:	e8 ec ed ff ff       	call   105170 <release>
  return 0;
}
  106384:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  106387:	31 c0                	xor    %eax,%eax
  return 0;
}
  106389:	5b                   	pop    %ebx
  10638a:	5d                   	pop    %ebp
  10638b:	c3                   	ret    
  10638c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106390 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  106390:	55                   	push   %ebp
  106391:	89 e5                	mov    %esp,%ebp
  106393:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  106396:	8d 45 f4             	lea    -0xc(%ebp),%eax
  106399:	89 44 24 04          	mov    %eax,0x4(%esp)
  10639d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1063a4:	e8 47 f1 ff ff       	call   1054f0 <argint>
  1063a9:	85 c0                	test   %eax,%eax
  1063ab:	79 0b                	jns    1063b8 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  1063ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1063b2:	c9                   	leave  
  1063b3:	c3                   	ret    
  1063b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1063b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1063bb:	89 04 24             	mov    %eax,(%esp)
  1063be:	e8 cd e6 ff ff       	call   104a90 <growproc>
  1063c3:	85 c0                	test   %eax,%eax
  1063c5:	78 e6                	js     1063ad <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1063c7:	c9                   	leave  
  1063c8:	c3                   	ret    
  1063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001063d0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1063d0:	55                   	push   %ebp
  1063d1:	89 e5                	mov    %esp,%ebp
  1063d3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1063d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1063d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1063e4:	e8 07 f1 ff ff       	call   1054f0 <argint>
  1063e9:	89 c2                	mov    %eax,%edx
  1063eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1063f0:	85 d2                	test   %edx,%edx
  1063f2:	78 0b                	js     1063ff <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1063f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1063f7:	89 04 24             	mov    %eax,(%esp)
  1063fa:	e8 f1 db ff ff       	call   103ff0 <kill>
}
  1063ff:	c9                   	leave  
  106400:	c3                   	ret    
  106401:	eb 0d                	jmp    106410 <sys_wait>
  106403:	90                   	nop
  106404:	90                   	nop
  106405:	90                   	nop
  106406:	90                   	nop
  106407:	90                   	nop
  106408:	90                   	nop
  106409:	90                   	nop
  10640a:	90                   	nop
  10640b:	90                   	nop
  10640c:	90                   	nop
  10640d:	90                   	nop
  10640e:	90                   	nop
  10640f:	90                   	nop

00106410 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  106410:	55                   	push   %ebp
  106411:	89 e5                	mov    %esp,%ebp
  106413:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  106416:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  106417:	e9 e4 e1 ff ff       	jmp    104600 <wait>
  10641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106420 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  106420:	55                   	push   %ebp
  106421:	89 e5                	mov    %esp,%ebp
  106423:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  106426:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  106427:	e9 d4 e0 ff ff       	jmp    104500 <wait_thread>
  10642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106430 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  106430:	55                   	push   %ebp
  106431:	89 e5                	mov    %esp,%ebp
  106433:	83 ec 08             	sub    $0x8,%esp
  exit();
  106436:	e8 45 de ff ff       	call   104280 <exit>
  return 0;  // not reached
}
  10643b:	31 c0                	xor    %eax,%eax
  10643d:	c9                   	leave  
  10643e:	c3                   	ret    
  10643f:	90                   	nop

00106440 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  106440:	55                   	push   %ebp
  106441:	89 e5                	mov    %esp,%ebp
  106443:	53                   	push   %ebx
  106444:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  106447:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10644a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10644e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106455:	e8 96 f0 ff ff       	call   1054f0 <argint>
  10645a:	85 c0                	test   %eax,%eax
  10645c:	79 12                	jns    106470 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10645e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  106463:	83 c4 24             	add    $0x24,%esp
  106466:	5b                   	pop    %ebx
  106467:	5d                   	pop    %ebp
  106468:	c3                   	ret    
  106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  106470:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106473:	e8 08 dd ff ff       	call   104180 <curproc>
  106478:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10647c:	89 04 24             	mov    %eax,(%esp)
  10647f:	e8 cc e6 ff ff       	call   104b50 <copyproc_tix>
  106484:	85 c0                	test   %eax,%eax
  106486:	89 c2                	mov    %eax,%edx
  106488:	74 d4                	je     10645e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10648a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10648d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  106490:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  106497:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  10649d:	eb c4                	jmp    106463 <sys_fork_tickets+0x23>
  10649f:	90                   	nop

001064a0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1064a0:	55                   	push   %ebp
  1064a1:	89 e5                	mov    %esp,%ebp
  1064a3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1064a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1064a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1064ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1064af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1064b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1064bd:	e8 2e f0 ff ff       	call   1054f0 <argint>
  1064c2:	85 c0                	test   %eax,%eax
  1064c4:	79 12                	jns    1064d8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1064c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1064cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1064ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1064d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1064d4:	89 ec                	mov    %ebp,%esp
  1064d6:	5d                   	pop    %ebp
  1064d7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1064d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1064db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1064e6:	e8 05 f0 ff ff       	call   1054f0 <argint>
  1064eb:	85 c0                	test   %eax,%eax
  1064ed:	78 d7                	js     1064c6 <sys_fork_thread+0x26>
  1064ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1064f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064f6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1064fd:	e8 ee ef ff ff       	call   1054f0 <argint>
  106502:	85 c0                	test   %eax,%eax
  106504:	78 c0                	js     1064c6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  106506:	8b 7d dc             	mov    -0x24(%ebp),%edi
  106509:	8b 75 e0             	mov    -0x20(%ebp),%esi
  10650c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10650f:	e8 6c dc ff ff       	call   104180 <curproc>
  106514:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  106518:	89 74 24 08          	mov    %esi,0x8(%esp)
  10651c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  106520:	89 04 24             	mov    %eax,(%esp)
  106523:	e8 68 e7 ff ff       	call   104c90 <copyproc_threads>
  106528:	89 c2                	mov    %eax,%edx
  10652a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10652f:	85 d2                	test   %edx,%edx
  106531:	74 98                	je     1064cb <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  106533:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  10653a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  10653d:	eb 8c                	jmp    1064cb <sys_fork_thread+0x2b>
  10653f:	90                   	nop

00106540 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  106540:	55                   	push   %ebp
  106541:	89 e5                	mov    %esp,%ebp
  106543:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  106546:	e8 35 dc ff ff       	call   104180 <curproc>
  10654b:	89 04 24             	mov    %eax,(%esp)
  10654e:	e8 4d e8 ff ff       	call   104da0 <copyproc>
  106553:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  106558:	85 c0                	test   %eax,%eax
  10655a:	74 0a                	je     106566 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10655c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10655f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  106566:	89 d0                	mov    %edx,%eax
  106568:	c9                   	leave  
  106569:	c3                   	ret    
  10656a:	90                   	nop
  10656b:	90                   	nop
  10656c:	90                   	nop
  10656d:	90                   	nop
  10656e:	90                   	nop
  10656f:	90                   	nop

00106570 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  106570:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  106571:	ba 43 00 00 00       	mov    $0x43,%edx
  106576:	89 e5                	mov    %esp,%ebp
  106578:	83 ec 18             	sub    $0x18,%esp
  10657b:	b8 34 00 00 00       	mov    $0x34,%eax
  106580:	ee                   	out    %al,(%dx)
  106581:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  106586:	b2 40                	mov    $0x40,%dl
  106588:	ee                   	out    %al,(%dx)
  106589:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10658e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  10658f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106596:	e8 f5 d4 ff ff       	call   103a90 <pic_enable>
}
  10659b:	c9                   	leave  
  10659c:	c3                   	ret    
  10659d:	90                   	nop
  10659e:	90                   	nop
  10659f:	90                   	nop

001065a0 <alltraps>:
  1065a0:	1e                   	push   %ds
  1065a1:	06                   	push   %es
  1065a2:	60                   	pusha  
  1065a3:	b8 10 00 00 00       	mov    $0x10,%eax
  1065a8:	8e d8                	mov    %eax,%ds
  1065aa:	8e c0                	mov    %eax,%es
  1065ac:	54                   	push   %esp
  1065ad:	e8 4e 00 00 00       	call   106600 <trap>
  1065b2:	83 c4 04             	add    $0x4,%esp

001065b5 <trapret>:
  1065b5:	61                   	popa   
  1065b6:	07                   	pop    %es
  1065b7:	1f                   	pop    %ds
  1065b8:	83 c4 08             	add    $0x8,%esp
  1065bb:	cf                   	iret   

001065bc <forkret1>:
  1065bc:	8b 64 24 04          	mov    0x4(%esp),%esp
  1065c0:	e9 f0 ff ff ff       	jmp    1065b5 <trapret>
  1065c5:	90                   	nop
  1065c6:	90                   	nop
  1065c7:	90                   	nop
  1065c8:	90                   	nop
  1065c9:	90                   	nop
  1065ca:	90                   	nop
  1065cb:	90                   	nop
  1065cc:	90                   	nop
  1065cd:	90                   	nop
  1065ce:	90                   	nop
  1065cf:	90                   	nop

001065d0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1065d0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1065d1:	b8 00 fe 10 00       	mov    $0x10fe00,%eax
  1065d6:	89 e5                	mov    %esp,%ebp
  1065d8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1065db:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1065e1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1065e5:	c1 e8 10             	shr    $0x10,%eax
  1065e8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1065ec:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1065ef:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1065f2:	c9                   	leave  
  1065f3:	c3                   	ret    
  1065f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1065fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106600 <trap>:

void
trap(struct trapframe *tf)
{
  106600:	55                   	push   %ebp
  106601:	89 e5                	mov    %esp,%ebp
  106603:	83 ec 48             	sub    $0x48,%esp
  106606:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  106609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10660c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10660f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  106612:	8b 43 28             	mov    0x28(%ebx),%eax
  106615:	83 f8 30             	cmp    $0x30,%eax
  106618:	0f 84 8a 01 00 00    	je     1067a8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10661e:	83 f8 21             	cmp    $0x21,%eax
  106621:	0f 84 69 01 00 00    	je     106790 <trap+0x190>
  106627:	76 47                	jbe    106670 <trap+0x70>
  106629:	83 f8 2e             	cmp    $0x2e,%eax
  10662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106630:	0f 84 42 01 00 00    	je     106778 <trap+0x178>
  106636:	83 f8 3f             	cmp    $0x3f,%eax
  106639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106640:	75 37                	jne    106679 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  106642:	8b 7b 30             	mov    0x30(%ebx),%edi
  106645:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  106649:	e8 a2 c5 ff ff       	call   102bf0 <cpu>
  10664e:	c7 04 24 18 7b 10 00 	movl   $0x107b18,(%esp)
  106655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  106659:	89 74 24 08          	mov    %esi,0x8(%esp)
  10665d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106661:	e8 5a a1 ff ff       	call   1007c0 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  106666:	e8 f5 c3 ff ff       	call   102a60 <lapic_eoi>
    break;
  10666b:	e9 90 00 00 00       	jmp    106700 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  106670:	83 f8 20             	cmp    $0x20,%eax
  106673:	0f 84 e7 00 00 00    	je     106760 <trap+0x160>
  106679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  106680:	e8 fb da ff ff       	call   104180 <curproc>
  106685:	85 c0                	test   %eax,%eax
  106687:	0f 84 9b 01 00 00    	je     106828 <trap+0x228>
  10668d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  106691:	0f 84 91 01 00 00    	je     106828 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  106697:	8b 53 30             	mov    0x30(%ebx),%edx
  10669a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10669d:	e8 4e c5 ff ff       	call   102bf0 <cpu>
  1066a2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  1066a5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1066a8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1066ab:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1066ad:	e8 ce da ff ff       	call   104180 <curproc>
  1066b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1066b5:	e8 c6 da ff ff       	call   104180 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1066ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1066bd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  1066c1:	89 74 24 10          	mov    %esi,0x10(%esp)
  1066c5:	89 54 24 18          	mov    %edx,0x18(%esp)
  1066c9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1066cc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1066d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1066d3:	81 c2 88 00 00 00    	add    $0x88,%edx
  1066d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1066dd:	8b 40 10             	mov    0x10(%eax),%eax
  1066e0:	c7 04 24 64 7b 10 00 	movl   $0x107b64,(%esp)
  1066e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066eb:	e8 d0 a0 ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  1066f0:	e8 8b da ff ff       	call   104180 <curproc>
  1066f5:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  1066fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  106700:	e8 7b da ff ff       	call   104180 <curproc>
  106705:	85 c0                	test   %eax,%eax
  106707:	74 1c                	je     106725 <trap+0x125>
  106709:	e8 72 da ff ff       	call   104180 <curproc>
  10670e:	8b 40 1c             	mov    0x1c(%eax),%eax
  106711:	85 c0                	test   %eax,%eax
  106713:	74 10                	je     106725 <trap+0x125>
  106715:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  106719:	83 e0 03             	and    $0x3,%eax
  10671c:	83 f8 03             	cmp    $0x3,%eax
  10671f:	0f 84 33 01 00 00    	je     106858 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106725:	e8 56 da ff ff       	call   104180 <curproc>
  10672a:	85 c0                	test   %eax,%eax
  10672c:	74 0d                	je     10673b <trap+0x13b>
  10672e:	66 90                	xchg   %ax,%ax
  106730:	e8 4b da ff ff       	call   104180 <curproc>
  106735:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  106739:	74 0d                	je     106748 <trap+0x148>
    yield();
}
  10673b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10673e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106741:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106744:	89 ec                	mov    %ebp,%esp
  106746:	5d                   	pop    %ebp
  106747:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106748:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  10674c:	75 ed                	jne    10673b <trap+0x13b>
    yield();
}
  10674e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106751:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106754:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106757:	89 ec                	mov    %ebp,%esp
  106759:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  10675a:	e9 b1 df ff ff       	jmp    104710 <yield>
  10675f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  106760:	e8 8b c4 ff ff       	call   102bf0 <cpu>
  106765:	85 c0                	test   %eax,%eax
  106767:	0f 84 8b 00 00 00    	je     1067f8 <trap+0x1f8>
  10676d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  106770:	e8 eb c2 ff ff       	call   102a60 <lapic_eoi>
    break;
  106775:	eb 89                	jmp    106700 <trap+0x100>
  106777:	90                   	nop
  106778:	90                   	nop
  106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  106780:	e8 ab bc ff ff       	call   102430 <ide_intr>
  106785:	8d 76 00             	lea    0x0(%esi),%esi
  106788:	eb e3                	jmp    10676d <trap+0x16d>
  10678a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  106790:	e8 bb c1 ff ff       	call   102950 <kbd_intr>
  106795:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  106798:	e8 c3 c2 ff ff       	call   102a60 <lapic_eoi>
  10679d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  1067a0:	e9 5b ff ff ff       	jmp    106700 <trap+0x100>
  1067a5:	8d 76 00             	lea    0x0(%esi),%esi
  1067a8:	90                   	nop
  1067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  1067b0:	e8 cb d9 ff ff       	call   104180 <curproc>
  1067b5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1067b8:	85 c9                	test   %ecx,%ecx
  1067ba:	0f 85 a8 00 00 00    	jne    106868 <trap+0x268>
      exit();
    cp->tf = tf;
  1067c0:	e8 bb d9 ff ff       	call   104180 <curproc>
  1067c5:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  1067cb:	e8 50 ee ff ff       	call   105620 <syscall>
    if(cp->killed)
  1067d0:	e8 ab d9 ff ff       	call   104180 <curproc>
  1067d5:	8b 50 1c             	mov    0x1c(%eax),%edx
  1067d8:	85 d2                	test   %edx,%edx
  1067da:	0f 84 5b ff ff ff    	je     10673b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  1067e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1067e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1067e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1067e9:	89 ec                	mov    %ebp,%esp
  1067eb:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  1067ec:	e9 8f da ff ff       	jmp    104280 <exit>
  1067f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  1067f8:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  1067ff:	e8 ac e9 ff ff       	call   1051b0 <acquire>
      ticks++;
  106804:	83 05 00 06 11 00 01 	addl   $0x1,0x110600
      wakeup(&ticks);
  10680b:	c7 04 24 00 06 11 00 	movl   $0x110600,(%esp)
  106812:	e8 69 d8 ff ff       	call   104080 <wakeup>
      release(&tickslock);
  106817:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10681e:	e8 4d e9 ff ff       	call   105170 <release>
  106823:	e9 45 ff ff ff       	jmp    10676d <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  106828:	8b 73 30             	mov    0x30(%ebx),%esi
  10682b:	e8 c0 c3 ff ff       	call   102bf0 <cpu>
  106830:	89 74 24 0c          	mov    %esi,0xc(%esp)
  106834:	89 44 24 08          	mov    %eax,0x8(%esp)
  106838:	8b 43 28             	mov    0x28(%ebx),%eax
  10683b:	c7 04 24 3c 7b 10 00 	movl   $0x107b3c,(%esp)
  106842:	89 44 24 04          	mov    %eax,0x4(%esp)
  106846:	e8 75 9f ff ff       	call   1007c0 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  10684b:	c7 04 24 a0 7b 10 00 	movl   $0x107ba0,(%esp)
  106852:	e8 09 a1 ff ff       	call   100960 <panic>
  106857:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  106858:	e8 23 da ff ff       	call   104280 <exit>
  10685d:	e9 c3 fe ff ff       	jmp    106725 <trap+0x125>
  106862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106868:	90                   	nop
  106869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  106870:	e8 0b da ff ff       	call   104280 <exit>
  106875:	8d 76 00             	lea    0x0(%esi),%esi
  106878:	e9 43 ff ff ff       	jmp    1067c0 <trap+0x1c0>
  10687d:	8d 76 00             	lea    0x0(%esi),%esi

00106880 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  106880:	55                   	push   %ebp
  106881:	31 c0                	xor    %eax,%eax
  106883:	89 e5                	mov    %esp,%ebp
  106885:	ba 00 fe 10 00       	mov    $0x10fe00,%edx
  10688a:	83 ec 18             	sub    $0x18,%esp
  10688d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  106890:	8b 0c 85 08 83 10 00 	mov    0x108308(,%eax,4),%ecx
  106897:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  10689e:	66 89 0c c5 00 fe 10 	mov    %cx,0x10fe00(,%eax,8)
  1068a5:	00 
  1068a6:	c1 e9 10             	shr    $0x10,%ecx
  1068a9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1068ae:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  1068b3:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  1068b8:	83 c0 01             	add    $0x1,%eax
  1068bb:	3d 00 01 00 00       	cmp    $0x100,%eax
  1068c0:	75 ce                	jne    106890 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1068c2:	a1 c8 83 10 00       	mov    0x1083c8,%eax
  
  initlock(&tickslock, "time");
  1068c7:	c7 44 24 04 a5 7b 10 	movl   $0x107ba5,0x4(%esp)
  1068ce:	00 
  1068cf:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1068d6:	66 c7 05 82 ff 10 00 	movw   $0x8,0x10ff82
  1068dd:	08 00 
  1068df:	66 a3 80 ff 10 00    	mov    %ax,0x10ff80
  1068e5:	c1 e8 10             	shr    $0x10,%eax
  1068e8:	c6 05 84 ff 10 00 00 	movb   $0x0,0x10ff84
  1068ef:	c6 05 85 ff 10 00 ef 	movb   $0xef,0x10ff85
  1068f6:	66 a3 86 ff 10 00    	mov    %ax,0x10ff86
  
  initlock(&tickslock, "time");
  1068fc:	e8 ef e6 ff ff       	call   104ff0 <initlock>
}
  106901:	c9                   	leave  
  106902:	c3                   	ret    
  106903:	90                   	nop

00106904 <vector0>:
  106904:	6a 00                	push   $0x0
  106906:	6a 00                	push   $0x0
  106908:	e9 93 fc ff ff       	jmp    1065a0 <alltraps>

0010690d <vector1>:
  10690d:	6a 00                	push   $0x0
  10690f:	6a 01                	push   $0x1
  106911:	e9 8a fc ff ff       	jmp    1065a0 <alltraps>

00106916 <vector2>:
  106916:	6a 00                	push   $0x0
  106918:	6a 02                	push   $0x2
  10691a:	e9 81 fc ff ff       	jmp    1065a0 <alltraps>

0010691f <vector3>:
  10691f:	6a 00                	push   $0x0
  106921:	6a 03                	push   $0x3
  106923:	e9 78 fc ff ff       	jmp    1065a0 <alltraps>

00106928 <vector4>:
  106928:	6a 00                	push   $0x0
  10692a:	6a 04                	push   $0x4
  10692c:	e9 6f fc ff ff       	jmp    1065a0 <alltraps>

00106931 <vector5>:
  106931:	6a 00                	push   $0x0
  106933:	6a 05                	push   $0x5
  106935:	e9 66 fc ff ff       	jmp    1065a0 <alltraps>

0010693a <vector6>:
  10693a:	6a 00                	push   $0x0
  10693c:	6a 06                	push   $0x6
  10693e:	e9 5d fc ff ff       	jmp    1065a0 <alltraps>

00106943 <vector7>:
  106943:	6a 00                	push   $0x0
  106945:	6a 07                	push   $0x7
  106947:	e9 54 fc ff ff       	jmp    1065a0 <alltraps>

0010694c <vector8>:
  10694c:	6a 08                	push   $0x8
  10694e:	e9 4d fc ff ff       	jmp    1065a0 <alltraps>

00106953 <vector9>:
  106953:	6a 09                	push   $0x9
  106955:	e9 46 fc ff ff       	jmp    1065a0 <alltraps>

0010695a <vector10>:
  10695a:	6a 0a                	push   $0xa
  10695c:	e9 3f fc ff ff       	jmp    1065a0 <alltraps>

00106961 <vector11>:
  106961:	6a 0b                	push   $0xb
  106963:	e9 38 fc ff ff       	jmp    1065a0 <alltraps>

00106968 <vector12>:
  106968:	6a 0c                	push   $0xc
  10696a:	e9 31 fc ff ff       	jmp    1065a0 <alltraps>

0010696f <vector13>:
  10696f:	6a 0d                	push   $0xd
  106971:	e9 2a fc ff ff       	jmp    1065a0 <alltraps>

00106976 <vector14>:
  106976:	6a 0e                	push   $0xe
  106978:	e9 23 fc ff ff       	jmp    1065a0 <alltraps>

0010697d <vector15>:
  10697d:	6a 00                	push   $0x0
  10697f:	6a 0f                	push   $0xf
  106981:	e9 1a fc ff ff       	jmp    1065a0 <alltraps>

00106986 <vector16>:
  106986:	6a 00                	push   $0x0
  106988:	6a 10                	push   $0x10
  10698a:	e9 11 fc ff ff       	jmp    1065a0 <alltraps>

0010698f <vector17>:
  10698f:	6a 11                	push   $0x11
  106991:	e9 0a fc ff ff       	jmp    1065a0 <alltraps>

00106996 <vector18>:
  106996:	6a 00                	push   $0x0
  106998:	6a 12                	push   $0x12
  10699a:	e9 01 fc ff ff       	jmp    1065a0 <alltraps>

0010699f <vector19>:
  10699f:	6a 00                	push   $0x0
  1069a1:	6a 13                	push   $0x13
  1069a3:	e9 f8 fb ff ff       	jmp    1065a0 <alltraps>

001069a8 <vector20>:
  1069a8:	6a 00                	push   $0x0
  1069aa:	6a 14                	push   $0x14
  1069ac:	e9 ef fb ff ff       	jmp    1065a0 <alltraps>

001069b1 <vector21>:
  1069b1:	6a 00                	push   $0x0
  1069b3:	6a 15                	push   $0x15
  1069b5:	e9 e6 fb ff ff       	jmp    1065a0 <alltraps>

001069ba <vector22>:
  1069ba:	6a 00                	push   $0x0
  1069bc:	6a 16                	push   $0x16
  1069be:	e9 dd fb ff ff       	jmp    1065a0 <alltraps>

001069c3 <vector23>:
  1069c3:	6a 00                	push   $0x0
  1069c5:	6a 17                	push   $0x17
  1069c7:	e9 d4 fb ff ff       	jmp    1065a0 <alltraps>

001069cc <vector24>:
  1069cc:	6a 00                	push   $0x0
  1069ce:	6a 18                	push   $0x18
  1069d0:	e9 cb fb ff ff       	jmp    1065a0 <alltraps>

001069d5 <vector25>:
  1069d5:	6a 00                	push   $0x0
  1069d7:	6a 19                	push   $0x19
  1069d9:	e9 c2 fb ff ff       	jmp    1065a0 <alltraps>

001069de <vector26>:
  1069de:	6a 00                	push   $0x0
  1069e0:	6a 1a                	push   $0x1a
  1069e2:	e9 b9 fb ff ff       	jmp    1065a0 <alltraps>

001069e7 <vector27>:
  1069e7:	6a 00                	push   $0x0
  1069e9:	6a 1b                	push   $0x1b
  1069eb:	e9 b0 fb ff ff       	jmp    1065a0 <alltraps>

001069f0 <vector28>:
  1069f0:	6a 00                	push   $0x0
  1069f2:	6a 1c                	push   $0x1c
  1069f4:	e9 a7 fb ff ff       	jmp    1065a0 <alltraps>

001069f9 <vector29>:
  1069f9:	6a 00                	push   $0x0
  1069fb:	6a 1d                	push   $0x1d
  1069fd:	e9 9e fb ff ff       	jmp    1065a0 <alltraps>

00106a02 <vector30>:
  106a02:	6a 00                	push   $0x0
  106a04:	6a 1e                	push   $0x1e
  106a06:	e9 95 fb ff ff       	jmp    1065a0 <alltraps>

00106a0b <vector31>:
  106a0b:	6a 00                	push   $0x0
  106a0d:	6a 1f                	push   $0x1f
  106a0f:	e9 8c fb ff ff       	jmp    1065a0 <alltraps>

00106a14 <vector32>:
  106a14:	6a 00                	push   $0x0
  106a16:	6a 20                	push   $0x20
  106a18:	e9 83 fb ff ff       	jmp    1065a0 <alltraps>

00106a1d <vector33>:
  106a1d:	6a 00                	push   $0x0
  106a1f:	6a 21                	push   $0x21
  106a21:	e9 7a fb ff ff       	jmp    1065a0 <alltraps>

00106a26 <vector34>:
  106a26:	6a 00                	push   $0x0
  106a28:	6a 22                	push   $0x22
  106a2a:	e9 71 fb ff ff       	jmp    1065a0 <alltraps>

00106a2f <vector35>:
  106a2f:	6a 00                	push   $0x0
  106a31:	6a 23                	push   $0x23
  106a33:	e9 68 fb ff ff       	jmp    1065a0 <alltraps>

00106a38 <vector36>:
  106a38:	6a 00                	push   $0x0
  106a3a:	6a 24                	push   $0x24
  106a3c:	e9 5f fb ff ff       	jmp    1065a0 <alltraps>

00106a41 <vector37>:
  106a41:	6a 00                	push   $0x0
  106a43:	6a 25                	push   $0x25
  106a45:	e9 56 fb ff ff       	jmp    1065a0 <alltraps>

00106a4a <vector38>:
  106a4a:	6a 00                	push   $0x0
  106a4c:	6a 26                	push   $0x26
  106a4e:	e9 4d fb ff ff       	jmp    1065a0 <alltraps>

00106a53 <vector39>:
  106a53:	6a 00                	push   $0x0
  106a55:	6a 27                	push   $0x27
  106a57:	e9 44 fb ff ff       	jmp    1065a0 <alltraps>

00106a5c <vector40>:
  106a5c:	6a 00                	push   $0x0
  106a5e:	6a 28                	push   $0x28
  106a60:	e9 3b fb ff ff       	jmp    1065a0 <alltraps>

00106a65 <vector41>:
  106a65:	6a 00                	push   $0x0
  106a67:	6a 29                	push   $0x29
  106a69:	e9 32 fb ff ff       	jmp    1065a0 <alltraps>

00106a6e <vector42>:
  106a6e:	6a 00                	push   $0x0
  106a70:	6a 2a                	push   $0x2a
  106a72:	e9 29 fb ff ff       	jmp    1065a0 <alltraps>

00106a77 <vector43>:
  106a77:	6a 00                	push   $0x0
  106a79:	6a 2b                	push   $0x2b
  106a7b:	e9 20 fb ff ff       	jmp    1065a0 <alltraps>

00106a80 <vector44>:
  106a80:	6a 00                	push   $0x0
  106a82:	6a 2c                	push   $0x2c
  106a84:	e9 17 fb ff ff       	jmp    1065a0 <alltraps>

00106a89 <vector45>:
  106a89:	6a 00                	push   $0x0
  106a8b:	6a 2d                	push   $0x2d
  106a8d:	e9 0e fb ff ff       	jmp    1065a0 <alltraps>

00106a92 <vector46>:
  106a92:	6a 00                	push   $0x0
  106a94:	6a 2e                	push   $0x2e
  106a96:	e9 05 fb ff ff       	jmp    1065a0 <alltraps>

00106a9b <vector47>:
  106a9b:	6a 00                	push   $0x0
  106a9d:	6a 2f                	push   $0x2f
  106a9f:	e9 fc fa ff ff       	jmp    1065a0 <alltraps>

00106aa4 <vector48>:
  106aa4:	6a 00                	push   $0x0
  106aa6:	6a 30                	push   $0x30
  106aa8:	e9 f3 fa ff ff       	jmp    1065a0 <alltraps>

00106aad <vector49>:
  106aad:	6a 00                	push   $0x0
  106aaf:	6a 31                	push   $0x31
  106ab1:	e9 ea fa ff ff       	jmp    1065a0 <alltraps>

00106ab6 <vector50>:
  106ab6:	6a 00                	push   $0x0
  106ab8:	6a 32                	push   $0x32
  106aba:	e9 e1 fa ff ff       	jmp    1065a0 <alltraps>

00106abf <vector51>:
  106abf:	6a 00                	push   $0x0
  106ac1:	6a 33                	push   $0x33
  106ac3:	e9 d8 fa ff ff       	jmp    1065a0 <alltraps>

00106ac8 <vector52>:
  106ac8:	6a 00                	push   $0x0
  106aca:	6a 34                	push   $0x34
  106acc:	e9 cf fa ff ff       	jmp    1065a0 <alltraps>

00106ad1 <vector53>:
  106ad1:	6a 00                	push   $0x0
  106ad3:	6a 35                	push   $0x35
  106ad5:	e9 c6 fa ff ff       	jmp    1065a0 <alltraps>

00106ada <vector54>:
  106ada:	6a 00                	push   $0x0
  106adc:	6a 36                	push   $0x36
  106ade:	e9 bd fa ff ff       	jmp    1065a0 <alltraps>

00106ae3 <vector55>:
  106ae3:	6a 00                	push   $0x0
  106ae5:	6a 37                	push   $0x37
  106ae7:	e9 b4 fa ff ff       	jmp    1065a0 <alltraps>

00106aec <vector56>:
  106aec:	6a 00                	push   $0x0
  106aee:	6a 38                	push   $0x38
  106af0:	e9 ab fa ff ff       	jmp    1065a0 <alltraps>

00106af5 <vector57>:
  106af5:	6a 00                	push   $0x0
  106af7:	6a 39                	push   $0x39
  106af9:	e9 a2 fa ff ff       	jmp    1065a0 <alltraps>

00106afe <vector58>:
  106afe:	6a 00                	push   $0x0
  106b00:	6a 3a                	push   $0x3a
  106b02:	e9 99 fa ff ff       	jmp    1065a0 <alltraps>

00106b07 <vector59>:
  106b07:	6a 00                	push   $0x0
  106b09:	6a 3b                	push   $0x3b
  106b0b:	e9 90 fa ff ff       	jmp    1065a0 <alltraps>

00106b10 <vector60>:
  106b10:	6a 00                	push   $0x0
  106b12:	6a 3c                	push   $0x3c
  106b14:	e9 87 fa ff ff       	jmp    1065a0 <alltraps>

00106b19 <vector61>:
  106b19:	6a 00                	push   $0x0
  106b1b:	6a 3d                	push   $0x3d
  106b1d:	e9 7e fa ff ff       	jmp    1065a0 <alltraps>

00106b22 <vector62>:
  106b22:	6a 00                	push   $0x0
  106b24:	6a 3e                	push   $0x3e
  106b26:	e9 75 fa ff ff       	jmp    1065a0 <alltraps>

00106b2b <vector63>:
  106b2b:	6a 00                	push   $0x0
  106b2d:	6a 3f                	push   $0x3f
  106b2f:	e9 6c fa ff ff       	jmp    1065a0 <alltraps>

00106b34 <vector64>:
  106b34:	6a 00                	push   $0x0
  106b36:	6a 40                	push   $0x40
  106b38:	e9 63 fa ff ff       	jmp    1065a0 <alltraps>

00106b3d <vector65>:
  106b3d:	6a 00                	push   $0x0
  106b3f:	6a 41                	push   $0x41
  106b41:	e9 5a fa ff ff       	jmp    1065a0 <alltraps>

00106b46 <vector66>:
  106b46:	6a 00                	push   $0x0
  106b48:	6a 42                	push   $0x42
  106b4a:	e9 51 fa ff ff       	jmp    1065a0 <alltraps>

00106b4f <vector67>:
  106b4f:	6a 00                	push   $0x0
  106b51:	6a 43                	push   $0x43
  106b53:	e9 48 fa ff ff       	jmp    1065a0 <alltraps>

00106b58 <vector68>:
  106b58:	6a 00                	push   $0x0
  106b5a:	6a 44                	push   $0x44
  106b5c:	e9 3f fa ff ff       	jmp    1065a0 <alltraps>

00106b61 <vector69>:
  106b61:	6a 00                	push   $0x0
  106b63:	6a 45                	push   $0x45
  106b65:	e9 36 fa ff ff       	jmp    1065a0 <alltraps>

00106b6a <vector70>:
  106b6a:	6a 00                	push   $0x0
  106b6c:	6a 46                	push   $0x46
  106b6e:	e9 2d fa ff ff       	jmp    1065a0 <alltraps>

00106b73 <vector71>:
  106b73:	6a 00                	push   $0x0
  106b75:	6a 47                	push   $0x47
  106b77:	e9 24 fa ff ff       	jmp    1065a0 <alltraps>

00106b7c <vector72>:
  106b7c:	6a 00                	push   $0x0
  106b7e:	6a 48                	push   $0x48
  106b80:	e9 1b fa ff ff       	jmp    1065a0 <alltraps>

00106b85 <vector73>:
  106b85:	6a 00                	push   $0x0
  106b87:	6a 49                	push   $0x49
  106b89:	e9 12 fa ff ff       	jmp    1065a0 <alltraps>

00106b8e <vector74>:
  106b8e:	6a 00                	push   $0x0
  106b90:	6a 4a                	push   $0x4a
  106b92:	e9 09 fa ff ff       	jmp    1065a0 <alltraps>

00106b97 <vector75>:
  106b97:	6a 00                	push   $0x0
  106b99:	6a 4b                	push   $0x4b
  106b9b:	e9 00 fa ff ff       	jmp    1065a0 <alltraps>

00106ba0 <vector76>:
  106ba0:	6a 00                	push   $0x0
  106ba2:	6a 4c                	push   $0x4c
  106ba4:	e9 f7 f9 ff ff       	jmp    1065a0 <alltraps>

00106ba9 <vector77>:
  106ba9:	6a 00                	push   $0x0
  106bab:	6a 4d                	push   $0x4d
  106bad:	e9 ee f9 ff ff       	jmp    1065a0 <alltraps>

00106bb2 <vector78>:
  106bb2:	6a 00                	push   $0x0
  106bb4:	6a 4e                	push   $0x4e
  106bb6:	e9 e5 f9 ff ff       	jmp    1065a0 <alltraps>

00106bbb <vector79>:
  106bbb:	6a 00                	push   $0x0
  106bbd:	6a 4f                	push   $0x4f
  106bbf:	e9 dc f9 ff ff       	jmp    1065a0 <alltraps>

00106bc4 <vector80>:
  106bc4:	6a 00                	push   $0x0
  106bc6:	6a 50                	push   $0x50
  106bc8:	e9 d3 f9 ff ff       	jmp    1065a0 <alltraps>

00106bcd <vector81>:
  106bcd:	6a 00                	push   $0x0
  106bcf:	6a 51                	push   $0x51
  106bd1:	e9 ca f9 ff ff       	jmp    1065a0 <alltraps>

00106bd6 <vector82>:
  106bd6:	6a 00                	push   $0x0
  106bd8:	6a 52                	push   $0x52
  106bda:	e9 c1 f9 ff ff       	jmp    1065a0 <alltraps>

00106bdf <vector83>:
  106bdf:	6a 00                	push   $0x0
  106be1:	6a 53                	push   $0x53
  106be3:	e9 b8 f9 ff ff       	jmp    1065a0 <alltraps>

00106be8 <vector84>:
  106be8:	6a 00                	push   $0x0
  106bea:	6a 54                	push   $0x54
  106bec:	e9 af f9 ff ff       	jmp    1065a0 <alltraps>

00106bf1 <vector85>:
  106bf1:	6a 00                	push   $0x0
  106bf3:	6a 55                	push   $0x55
  106bf5:	e9 a6 f9 ff ff       	jmp    1065a0 <alltraps>

00106bfa <vector86>:
  106bfa:	6a 00                	push   $0x0
  106bfc:	6a 56                	push   $0x56
  106bfe:	e9 9d f9 ff ff       	jmp    1065a0 <alltraps>

00106c03 <vector87>:
  106c03:	6a 00                	push   $0x0
  106c05:	6a 57                	push   $0x57
  106c07:	e9 94 f9 ff ff       	jmp    1065a0 <alltraps>

00106c0c <vector88>:
  106c0c:	6a 00                	push   $0x0
  106c0e:	6a 58                	push   $0x58
  106c10:	e9 8b f9 ff ff       	jmp    1065a0 <alltraps>

00106c15 <vector89>:
  106c15:	6a 00                	push   $0x0
  106c17:	6a 59                	push   $0x59
  106c19:	e9 82 f9 ff ff       	jmp    1065a0 <alltraps>

00106c1e <vector90>:
  106c1e:	6a 00                	push   $0x0
  106c20:	6a 5a                	push   $0x5a
  106c22:	e9 79 f9 ff ff       	jmp    1065a0 <alltraps>

00106c27 <vector91>:
  106c27:	6a 00                	push   $0x0
  106c29:	6a 5b                	push   $0x5b
  106c2b:	e9 70 f9 ff ff       	jmp    1065a0 <alltraps>

00106c30 <vector92>:
  106c30:	6a 00                	push   $0x0
  106c32:	6a 5c                	push   $0x5c
  106c34:	e9 67 f9 ff ff       	jmp    1065a0 <alltraps>

00106c39 <vector93>:
  106c39:	6a 00                	push   $0x0
  106c3b:	6a 5d                	push   $0x5d
  106c3d:	e9 5e f9 ff ff       	jmp    1065a0 <alltraps>

00106c42 <vector94>:
  106c42:	6a 00                	push   $0x0
  106c44:	6a 5e                	push   $0x5e
  106c46:	e9 55 f9 ff ff       	jmp    1065a0 <alltraps>

00106c4b <vector95>:
  106c4b:	6a 00                	push   $0x0
  106c4d:	6a 5f                	push   $0x5f
  106c4f:	e9 4c f9 ff ff       	jmp    1065a0 <alltraps>

00106c54 <vector96>:
  106c54:	6a 00                	push   $0x0
  106c56:	6a 60                	push   $0x60
  106c58:	e9 43 f9 ff ff       	jmp    1065a0 <alltraps>

00106c5d <vector97>:
  106c5d:	6a 00                	push   $0x0
  106c5f:	6a 61                	push   $0x61
  106c61:	e9 3a f9 ff ff       	jmp    1065a0 <alltraps>

00106c66 <vector98>:
  106c66:	6a 00                	push   $0x0
  106c68:	6a 62                	push   $0x62
  106c6a:	e9 31 f9 ff ff       	jmp    1065a0 <alltraps>

00106c6f <vector99>:
  106c6f:	6a 00                	push   $0x0
  106c71:	6a 63                	push   $0x63
  106c73:	e9 28 f9 ff ff       	jmp    1065a0 <alltraps>

00106c78 <vector100>:
  106c78:	6a 00                	push   $0x0
  106c7a:	6a 64                	push   $0x64
  106c7c:	e9 1f f9 ff ff       	jmp    1065a0 <alltraps>

00106c81 <vector101>:
  106c81:	6a 00                	push   $0x0
  106c83:	6a 65                	push   $0x65
  106c85:	e9 16 f9 ff ff       	jmp    1065a0 <alltraps>

00106c8a <vector102>:
  106c8a:	6a 00                	push   $0x0
  106c8c:	6a 66                	push   $0x66
  106c8e:	e9 0d f9 ff ff       	jmp    1065a0 <alltraps>

00106c93 <vector103>:
  106c93:	6a 00                	push   $0x0
  106c95:	6a 67                	push   $0x67
  106c97:	e9 04 f9 ff ff       	jmp    1065a0 <alltraps>

00106c9c <vector104>:
  106c9c:	6a 00                	push   $0x0
  106c9e:	6a 68                	push   $0x68
  106ca0:	e9 fb f8 ff ff       	jmp    1065a0 <alltraps>

00106ca5 <vector105>:
  106ca5:	6a 00                	push   $0x0
  106ca7:	6a 69                	push   $0x69
  106ca9:	e9 f2 f8 ff ff       	jmp    1065a0 <alltraps>

00106cae <vector106>:
  106cae:	6a 00                	push   $0x0
  106cb0:	6a 6a                	push   $0x6a
  106cb2:	e9 e9 f8 ff ff       	jmp    1065a0 <alltraps>

00106cb7 <vector107>:
  106cb7:	6a 00                	push   $0x0
  106cb9:	6a 6b                	push   $0x6b
  106cbb:	e9 e0 f8 ff ff       	jmp    1065a0 <alltraps>

00106cc0 <vector108>:
  106cc0:	6a 00                	push   $0x0
  106cc2:	6a 6c                	push   $0x6c
  106cc4:	e9 d7 f8 ff ff       	jmp    1065a0 <alltraps>

00106cc9 <vector109>:
  106cc9:	6a 00                	push   $0x0
  106ccb:	6a 6d                	push   $0x6d
  106ccd:	e9 ce f8 ff ff       	jmp    1065a0 <alltraps>

00106cd2 <vector110>:
  106cd2:	6a 00                	push   $0x0
  106cd4:	6a 6e                	push   $0x6e
  106cd6:	e9 c5 f8 ff ff       	jmp    1065a0 <alltraps>

00106cdb <vector111>:
  106cdb:	6a 00                	push   $0x0
  106cdd:	6a 6f                	push   $0x6f
  106cdf:	e9 bc f8 ff ff       	jmp    1065a0 <alltraps>

00106ce4 <vector112>:
  106ce4:	6a 00                	push   $0x0
  106ce6:	6a 70                	push   $0x70
  106ce8:	e9 b3 f8 ff ff       	jmp    1065a0 <alltraps>

00106ced <vector113>:
  106ced:	6a 00                	push   $0x0
  106cef:	6a 71                	push   $0x71
  106cf1:	e9 aa f8 ff ff       	jmp    1065a0 <alltraps>

00106cf6 <vector114>:
  106cf6:	6a 00                	push   $0x0
  106cf8:	6a 72                	push   $0x72
  106cfa:	e9 a1 f8 ff ff       	jmp    1065a0 <alltraps>

00106cff <vector115>:
  106cff:	6a 00                	push   $0x0
  106d01:	6a 73                	push   $0x73
  106d03:	e9 98 f8 ff ff       	jmp    1065a0 <alltraps>

00106d08 <vector116>:
  106d08:	6a 00                	push   $0x0
  106d0a:	6a 74                	push   $0x74
  106d0c:	e9 8f f8 ff ff       	jmp    1065a0 <alltraps>

00106d11 <vector117>:
  106d11:	6a 00                	push   $0x0
  106d13:	6a 75                	push   $0x75
  106d15:	e9 86 f8 ff ff       	jmp    1065a0 <alltraps>

00106d1a <vector118>:
  106d1a:	6a 00                	push   $0x0
  106d1c:	6a 76                	push   $0x76
  106d1e:	e9 7d f8 ff ff       	jmp    1065a0 <alltraps>

00106d23 <vector119>:
  106d23:	6a 00                	push   $0x0
  106d25:	6a 77                	push   $0x77
  106d27:	e9 74 f8 ff ff       	jmp    1065a0 <alltraps>

00106d2c <vector120>:
  106d2c:	6a 00                	push   $0x0
  106d2e:	6a 78                	push   $0x78
  106d30:	e9 6b f8 ff ff       	jmp    1065a0 <alltraps>

00106d35 <vector121>:
  106d35:	6a 00                	push   $0x0
  106d37:	6a 79                	push   $0x79
  106d39:	e9 62 f8 ff ff       	jmp    1065a0 <alltraps>

00106d3e <vector122>:
  106d3e:	6a 00                	push   $0x0
  106d40:	6a 7a                	push   $0x7a
  106d42:	e9 59 f8 ff ff       	jmp    1065a0 <alltraps>

00106d47 <vector123>:
  106d47:	6a 00                	push   $0x0
  106d49:	6a 7b                	push   $0x7b
  106d4b:	e9 50 f8 ff ff       	jmp    1065a0 <alltraps>

00106d50 <vector124>:
  106d50:	6a 00                	push   $0x0
  106d52:	6a 7c                	push   $0x7c
  106d54:	e9 47 f8 ff ff       	jmp    1065a0 <alltraps>

00106d59 <vector125>:
  106d59:	6a 00                	push   $0x0
  106d5b:	6a 7d                	push   $0x7d
  106d5d:	e9 3e f8 ff ff       	jmp    1065a0 <alltraps>

00106d62 <vector126>:
  106d62:	6a 00                	push   $0x0
  106d64:	6a 7e                	push   $0x7e
  106d66:	e9 35 f8 ff ff       	jmp    1065a0 <alltraps>

00106d6b <vector127>:
  106d6b:	6a 00                	push   $0x0
  106d6d:	6a 7f                	push   $0x7f
  106d6f:	e9 2c f8 ff ff       	jmp    1065a0 <alltraps>

00106d74 <vector128>:
  106d74:	6a 00                	push   $0x0
  106d76:	68 80 00 00 00       	push   $0x80
  106d7b:	e9 20 f8 ff ff       	jmp    1065a0 <alltraps>

00106d80 <vector129>:
  106d80:	6a 00                	push   $0x0
  106d82:	68 81 00 00 00       	push   $0x81
  106d87:	e9 14 f8 ff ff       	jmp    1065a0 <alltraps>

00106d8c <vector130>:
  106d8c:	6a 00                	push   $0x0
  106d8e:	68 82 00 00 00       	push   $0x82
  106d93:	e9 08 f8 ff ff       	jmp    1065a0 <alltraps>

00106d98 <vector131>:
  106d98:	6a 00                	push   $0x0
  106d9a:	68 83 00 00 00       	push   $0x83
  106d9f:	e9 fc f7 ff ff       	jmp    1065a0 <alltraps>

00106da4 <vector132>:
  106da4:	6a 00                	push   $0x0
  106da6:	68 84 00 00 00       	push   $0x84
  106dab:	e9 f0 f7 ff ff       	jmp    1065a0 <alltraps>

00106db0 <vector133>:
  106db0:	6a 00                	push   $0x0
  106db2:	68 85 00 00 00       	push   $0x85
  106db7:	e9 e4 f7 ff ff       	jmp    1065a0 <alltraps>

00106dbc <vector134>:
  106dbc:	6a 00                	push   $0x0
  106dbe:	68 86 00 00 00       	push   $0x86
  106dc3:	e9 d8 f7 ff ff       	jmp    1065a0 <alltraps>

00106dc8 <vector135>:
  106dc8:	6a 00                	push   $0x0
  106dca:	68 87 00 00 00       	push   $0x87
  106dcf:	e9 cc f7 ff ff       	jmp    1065a0 <alltraps>

00106dd4 <vector136>:
  106dd4:	6a 00                	push   $0x0
  106dd6:	68 88 00 00 00       	push   $0x88
  106ddb:	e9 c0 f7 ff ff       	jmp    1065a0 <alltraps>

00106de0 <vector137>:
  106de0:	6a 00                	push   $0x0
  106de2:	68 89 00 00 00       	push   $0x89
  106de7:	e9 b4 f7 ff ff       	jmp    1065a0 <alltraps>

00106dec <vector138>:
  106dec:	6a 00                	push   $0x0
  106dee:	68 8a 00 00 00       	push   $0x8a
  106df3:	e9 a8 f7 ff ff       	jmp    1065a0 <alltraps>

00106df8 <vector139>:
  106df8:	6a 00                	push   $0x0
  106dfa:	68 8b 00 00 00       	push   $0x8b
  106dff:	e9 9c f7 ff ff       	jmp    1065a0 <alltraps>

00106e04 <vector140>:
  106e04:	6a 00                	push   $0x0
  106e06:	68 8c 00 00 00       	push   $0x8c
  106e0b:	e9 90 f7 ff ff       	jmp    1065a0 <alltraps>

00106e10 <vector141>:
  106e10:	6a 00                	push   $0x0
  106e12:	68 8d 00 00 00       	push   $0x8d
  106e17:	e9 84 f7 ff ff       	jmp    1065a0 <alltraps>

00106e1c <vector142>:
  106e1c:	6a 00                	push   $0x0
  106e1e:	68 8e 00 00 00       	push   $0x8e
  106e23:	e9 78 f7 ff ff       	jmp    1065a0 <alltraps>

00106e28 <vector143>:
  106e28:	6a 00                	push   $0x0
  106e2a:	68 8f 00 00 00       	push   $0x8f
  106e2f:	e9 6c f7 ff ff       	jmp    1065a0 <alltraps>

00106e34 <vector144>:
  106e34:	6a 00                	push   $0x0
  106e36:	68 90 00 00 00       	push   $0x90
  106e3b:	e9 60 f7 ff ff       	jmp    1065a0 <alltraps>

00106e40 <vector145>:
  106e40:	6a 00                	push   $0x0
  106e42:	68 91 00 00 00       	push   $0x91
  106e47:	e9 54 f7 ff ff       	jmp    1065a0 <alltraps>

00106e4c <vector146>:
  106e4c:	6a 00                	push   $0x0
  106e4e:	68 92 00 00 00       	push   $0x92
  106e53:	e9 48 f7 ff ff       	jmp    1065a0 <alltraps>

00106e58 <vector147>:
  106e58:	6a 00                	push   $0x0
  106e5a:	68 93 00 00 00       	push   $0x93
  106e5f:	e9 3c f7 ff ff       	jmp    1065a0 <alltraps>

00106e64 <vector148>:
  106e64:	6a 00                	push   $0x0
  106e66:	68 94 00 00 00       	push   $0x94
  106e6b:	e9 30 f7 ff ff       	jmp    1065a0 <alltraps>

00106e70 <vector149>:
  106e70:	6a 00                	push   $0x0
  106e72:	68 95 00 00 00       	push   $0x95
  106e77:	e9 24 f7 ff ff       	jmp    1065a0 <alltraps>

00106e7c <vector150>:
  106e7c:	6a 00                	push   $0x0
  106e7e:	68 96 00 00 00       	push   $0x96
  106e83:	e9 18 f7 ff ff       	jmp    1065a0 <alltraps>

00106e88 <vector151>:
  106e88:	6a 00                	push   $0x0
  106e8a:	68 97 00 00 00       	push   $0x97
  106e8f:	e9 0c f7 ff ff       	jmp    1065a0 <alltraps>

00106e94 <vector152>:
  106e94:	6a 00                	push   $0x0
  106e96:	68 98 00 00 00       	push   $0x98
  106e9b:	e9 00 f7 ff ff       	jmp    1065a0 <alltraps>

00106ea0 <vector153>:
  106ea0:	6a 00                	push   $0x0
  106ea2:	68 99 00 00 00       	push   $0x99
  106ea7:	e9 f4 f6 ff ff       	jmp    1065a0 <alltraps>

00106eac <vector154>:
  106eac:	6a 00                	push   $0x0
  106eae:	68 9a 00 00 00       	push   $0x9a
  106eb3:	e9 e8 f6 ff ff       	jmp    1065a0 <alltraps>

00106eb8 <vector155>:
  106eb8:	6a 00                	push   $0x0
  106eba:	68 9b 00 00 00       	push   $0x9b
  106ebf:	e9 dc f6 ff ff       	jmp    1065a0 <alltraps>

00106ec4 <vector156>:
  106ec4:	6a 00                	push   $0x0
  106ec6:	68 9c 00 00 00       	push   $0x9c
  106ecb:	e9 d0 f6 ff ff       	jmp    1065a0 <alltraps>

00106ed0 <vector157>:
  106ed0:	6a 00                	push   $0x0
  106ed2:	68 9d 00 00 00       	push   $0x9d
  106ed7:	e9 c4 f6 ff ff       	jmp    1065a0 <alltraps>

00106edc <vector158>:
  106edc:	6a 00                	push   $0x0
  106ede:	68 9e 00 00 00       	push   $0x9e
  106ee3:	e9 b8 f6 ff ff       	jmp    1065a0 <alltraps>

00106ee8 <vector159>:
  106ee8:	6a 00                	push   $0x0
  106eea:	68 9f 00 00 00       	push   $0x9f
  106eef:	e9 ac f6 ff ff       	jmp    1065a0 <alltraps>

00106ef4 <vector160>:
  106ef4:	6a 00                	push   $0x0
  106ef6:	68 a0 00 00 00       	push   $0xa0
  106efb:	e9 a0 f6 ff ff       	jmp    1065a0 <alltraps>

00106f00 <vector161>:
  106f00:	6a 00                	push   $0x0
  106f02:	68 a1 00 00 00       	push   $0xa1
  106f07:	e9 94 f6 ff ff       	jmp    1065a0 <alltraps>

00106f0c <vector162>:
  106f0c:	6a 00                	push   $0x0
  106f0e:	68 a2 00 00 00       	push   $0xa2
  106f13:	e9 88 f6 ff ff       	jmp    1065a0 <alltraps>

00106f18 <vector163>:
  106f18:	6a 00                	push   $0x0
  106f1a:	68 a3 00 00 00       	push   $0xa3
  106f1f:	e9 7c f6 ff ff       	jmp    1065a0 <alltraps>

00106f24 <vector164>:
  106f24:	6a 00                	push   $0x0
  106f26:	68 a4 00 00 00       	push   $0xa4
  106f2b:	e9 70 f6 ff ff       	jmp    1065a0 <alltraps>

00106f30 <vector165>:
  106f30:	6a 00                	push   $0x0
  106f32:	68 a5 00 00 00       	push   $0xa5
  106f37:	e9 64 f6 ff ff       	jmp    1065a0 <alltraps>

00106f3c <vector166>:
  106f3c:	6a 00                	push   $0x0
  106f3e:	68 a6 00 00 00       	push   $0xa6
  106f43:	e9 58 f6 ff ff       	jmp    1065a0 <alltraps>

00106f48 <vector167>:
  106f48:	6a 00                	push   $0x0
  106f4a:	68 a7 00 00 00       	push   $0xa7
  106f4f:	e9 4c f6 ff ff       	jmp    1065a0 <alltraps>

00106f54 <vector168>:
  106f54:	6a 00                	push   $0x0
  106f56:	68 a8 00 00 00       	push   $0xa8
  106f5b:	e9 40 f6 ff ff       	jmp    1065a0 <alltraps>

00106f60 <vector169>:
  106f60:	6a 00                	push   $0x0
  106f62:	68 a9 00 00 00       	push   $0xa9
  106f67:	e9 34 f6 ff ff       	jmp    1065a0 <alltraps>

00106f6c <vector170>:
  106f6c:	6a 00                	push   $0x0
  106f6e:	68 aa 00 00 00       	push   $0xaa
  106f73:	e9 28 f6 ff ff       	jmp    1065a0 <alltraps>

00106f78 <vector171>:
  106f78:	6a 00                	push   $0x0
  106f7a:	68 ab 00 00 00       	push   $0xab
  106f7f:	e9 1c f6 ff ff       	jmp    1065a0 <alltraps>

00106f84 <vector172>:
  106f84:	6a 00                	push   $0x0
  106f86:	68 ac 00 00 00       	push   $0xac
  106f8b:	e9 10 f6 ff ff       	jmp    1065a0 <alltraps>

00106f90 <vector173>:
  106f90:	6a 00                	push   $0x0
  106f92:	68 ad 00 00 00       	push   $0xad
  106f97:	e9 04 f6 ff ff       	jmp    1065a0 <alltraps>

00106f9c <vector174>:
  106f9c:	6a 00                	push   $0x0
  106f9e:	68 ae 00 00 00       	push   $0xae
  106fa3:	e9 f8 f5 ff ff       	jmp    1065a0 <alltraps>

00106fa8 <vector175>:
  106fa8:	6a 00                	push   $0x0
  106faa:	68 af 00 00 00       	push   $0xaf
  106faf:	e9 ec f5 ff ff       	jmp    1065a0 <alltraps>

00106fb4 <vector176>:
  106fb4:	6a 00                	push   $0x0
  106fb6:	68 b0 00 00 00       	push   $0xb0
  106fbb:	e9 e0 f5 ff ff       	jmp    1065a0 <alltraps>

00106fc0 <vector177>:
  106fc0:	6a 00                	push   $0x0
  106fc2:	68 b1 00 00 00       	push   $0xb1
  106fc7:	e9 d4 f5 ff ff       	jmp    1065a0 <alltraps>

00106fcc <vector178>:
  106fcc:	6a 00                	push   $0x0
  106fce:	68 b2 00 00 00       	push   $0xb2
  106fd3:	e9 c8 f5 ff ff       	jmp    1065a0 <alltraps>

00106fd8 <vector179>:
  106fd8:	6a 00                	push   $0x0
  106fda:	68 b3 00 00 00       	push   $0xb3
  106fdf:	e9 bc f5 ff ff       	jmp    1065a0 <alltraps>

00106fe4 <vector180>:
  106fe4:	6a 00                	push   $0x0
  106fe6:	68 b4 00 00 00       	push   $0xb4
  106feb:	e9 b0 f5 ff ff       	jmp    1065a0 <alltraps>

00106ff0 <vector181>:
  106ff0:	6a 00                	push   $0x0
  106ff2:	68 b5 00 00 00       	push   $0xb5
  106ff7:	e9 a4 f5 ff ff       	jmp    1065a0 <alltraps>

00106ffc <vector182>:
  106ffc:	6a 00                	push   $0x0
  106ffe:	68 b6 00 00 00       	push   $0xb6
  107003:	e9 98 f5 ff ff       	jmp    1065a0 <alltraps>

00107008 <vector183>:
  107008:	6a 00                	push   $0x0
  10700a:	68 b7 00 00 00       	push   $0xb7
  10700f:	e9 8c f5 ff ff       	jmp    1065a0 <alltraps>

00107014 <vector184>:
  107014:	6a 00                	push   $0x0
  107016:	68 b8 00 00 00       	push   $0xb8
  10701b:	e9 80 f5 ff ff       	jmp    1065a0 <alltraps>

00107020 <vector185>:
  107020:	6a 00                	push   $0x0
  107022:	68 b9 00 00 00       	push   $0xb9
  107027:	e9 74 f5 ff ff       	jmp    1065a0 <alltraps>

0010702c <vector186>:
  10702c:	6a 00                	push   $0x0
  10702e:	68 ba 00 00 00       	push   $0xba
  107033:	e9 68 f5 ff ff       	jmp    1065a0 <alltraps>

00107038 <vector187>:
  107038:	6a 00                	push   $0x0
  10703a:	68 bb 00 00 00       	push   $0xbb
  10703f:	e9 5c f5 ff ff       	jmp    1065a0 <alltraps>

00107044 <vector188>:
  107044:	6a 00                	push   $0x0
  107046:	68 bc 00 00 00       	push   $0xbc
  10704b:	e9 50 f5 ff ff       	jmp    1065a0 <alltraps>

00107050 <vector189>:
  107050:	6a 00                	push   $0x0
  107052:	68 bd 00 00 00       	push   $0xbd
  107057:	e9 44 f5 ff ff       	jmp    1065a0 <alltraps>

0010705c <vector190>:
  10705c:	6a 00                	push   $0x0
  10705e:	68 be 00 00 00       	push   $0xbe
  107063:	e9 38 f5 ff ff       	jmp    1065a0 <alltraps>

00107068 <vector191>:
  107068:	6a 00                	push   $0x0
  10706a:	68 bf 00 00 00       	push   $0xbf
  10706f:	e9 2c f5 ff ff       	jmp    1065a0 <alltraps>

00107074 <vector192>:
  107074:	6a 00                	push   $0x0
  107076:	68 c0 00 00 00       	push   $0xc0
  10707b:	e9 20 f5 ff ff       	jmp    1065a0 <alltraps>

00107080 <vector193>:
  107080:	6a 00                	push   $0x0
  107082:	68 c1 00 00 00       	push   $0xc1
  107087:	e9 14 f5 ff ff       	jmp    1065a0 <alltraps>

0010708c <vector194>:
  10708c:	6a 00                	push   $0x0
  10708e:	68 c2 00 00 00       	push   $0xc2
  107093:	e9 08 f5 ff ff       	jmp    1065a0 <alltraps>

00107098 <vector195>:
  107098:	6a 00                	push   $0x0
  10709a:	68 c3 00 00 00       	push   $0xc3
  10709f:	e9 fc f4 ff ff       	jmp    1065a0 <alltraps>

001070a4 <vector196>:
  1070a4:	6a 00                	push   $0x0
  1070a6:	68 c4 00 00 00       	push   $0xc4
  1070ab:	e9 f0 f4 ff ff       	jmp    1065a0 <alltraps>

001070b0 <vector197>:
  1070b0:	6a 00                	push   $0x0
  1070b2:	68 c5 00 00 00       	push   $0xc5
  1070b7:	e9 e4 f4 ff ff       	jmp    1065a0 <alltraps>

001070bc <vector198>:
  1070bc:	6a 00                	push   $0x0
  1070be:	68 c6 00 00 00       	push   $0xc6
  1070c3:	e9 d8 f4 ff ff       	jmp    1065a0 <alltraps>

001070c8 <vector199>:
  1070c8:	6a 00                	push   $0x0
  1070ca:	68 c7 00 00 00       	push   $0xc7
  1070cf:	e9 cc f4 ff ff       	jmp    1065a0 <alltraps>

001070d4 <vector200>:
  1070d4:	6a 00                	push   $0x0
  1070d6:	68 c8 00 00 00       	push   $0xc8
  1070db:	e9 c0 f4 ff ff       	jmp    1065a0 <alltraps>

001070e0 <vector201>:
  1070e0:	6a 00                	push   $0x0
  1070e2:	68 c9 00 00 00       	push   $0xc9
  1070e7:	e9 b4 f4 ff ff       	jmp    1065a0 <alltraps>

001070ec <vector202>:
  1070ec:	6a 00                	push   $0x0
  1070ee:	68 ca 00 00 00       	push   $0xca
  1070f3:	e9 a8 f4 ff ff       	jmp    1065a0 <alltraps>

001070f8 <vector203>:
  1070f8:	6a 00                	push   $0x0
  1070fa:	68 cb 00 00 00       	push   $0xcb
  1070ff:	e9 9c f4 ff ff       	jmp    1065a0 <alltraps>

00107104 <vector204>:
  107104:	6a 00                	push   $0x0
  107106:	68 cc 00 00 00       	push   $0xcc
  10710b:	e9 90 f4 ff ff       	jmp    1065a0 <alltraps>

00107110 <vector205>:
  107110:	6a 00                	push   $0x0
  107112:	68 cd 00 00 00       	push   $0xcd
  107117:	e9 84 f4 ff ff       	jmp    1065a0 <alltraps>

0010711c <vector206>:
  10711c:	6a 00                	push   $0x0
  10711e:	68 ce 00 00 00       	push   $0xce
  107123:	e9 78 f4 ff ff       	jmp    1065a0 <alltraps>

00107128 <vector207>:
  107128:	6a 00                	push   $0x0
  10712a:	68 cf 00 00 00       	push   $0xcf
  10712f:	e9 6c f4 ff ff       	jmp    1065a0 <alltraps>

00107134 <vector208>:
  107134:	6a 00                	push   $0x0
  107136:	68 d0 00 00 00       	push   $0xd0
  10713b:	e9 60 f4 ff ff       	jmp    1065a0 <alltraps>

00107140 <vector209>:
  107140:	6a 00                	push   $0x0
  107142:	68 d1 00 00 00       	push   $0xd1
  107147:	e9 54 f4 ff ff       	jmp    1065a0 <alltraps>

0010714c <vector210>:
  10714c:	6a 00                	push   $0x0
  10714e:	68 d2 00 00 00       	push   $0xd2
  107153:	e9 48 f4 ff ff       	jmp    1065a0 <alltraps>

00107158 <vector211>:
  107158:	6a 00                	push   $0x0
  10715a:	68 d3 00 00 00       	push   $0xd3
  10715f:	e9 3c f4 ff ff       	jmp    1065a0 <alltraps>

00107164 <vector212>:
  107164:	6a 00                	push   $0x0
  107166:	68 d4 00 00 00       	push   $0xd4
  10716b:	e9 30 f4 ff ff       	jmp    1065a0 <alltraps>

00107170 <vector213>:
  107170:	6a 00                	push   $0x0
  107172:	68 d5 00 00 00       	push   $0xd5
  107177:	e9 24 f4 ff ff       	jmp    1065a0 <alltraps>

0010717c <vector214>:
  10717c:	6a 00                	push   $0x0
  10717e:	68 d6 00 00 00       	push   $0xd6
  107183:	e9 18 f4 ff ff       	jmp    1065a0 <alltraps>

00107188 <vector215>:
  107188:	6a 00                	push   $0x0
  10718a:	68 d7 00 00 00       	push   $0xd7
  10718f:	e9 0c f4 ff ff       	jmp    1065a0 <alltraps>

00107194 <vector216>:
  107194:	6a 00                	push   $0x0
  107196:	68 d8 00 00 00       	push   $0xd8
  10719b:	e9 00 f4 ff ff       	jmp    1065a0 <alltraps>

001071a0 <vector217>:
  1071a0:	6a 00                	push   $0x0
  1071a2:	68 d9 00 00 00       	push   $0xd9
  1071a7:	e9 f4 f3 ff ff       	jmp    1065a0 <alltraps>

001071ac <vector218>:
  1071ac:	6a 00                	push   $0x0
  1071ae:	68 da 00 00 00       	push   $0xda
  1071b3:	e9 e8 f3 ff ff       	jmp    1065a0 <alltraps>

001071b8 <vector219>:
  1071b8:	6a 00                	push   $0x0
  1071ba:	68 db 00 00 00       	push   $0xdb
  1071bf:	e9 dc f3 ff ff       	jmp    1065a0 <alltraps>

001071c4 <vector220>:
  1071c4:	6a 00                	push   $0x0
  1071c6:	68 dc 00 00 00       	push   $0xdc
  1071cb:	e9 d0 f3 ff ff       	jmp    1065a0 <alltraps>

001071d0 <vector221>:
  1071d0:	6a 00                	push   $0x0
  1071d2:	68 dd 00 00 00       	push   $0xdd
  1071d7:	e9 c4 f3 ff ff       	jmp    1065a0 <alltraps>

001071dc <vector222>:
  1071dc:	6a 00                	push   $0x0
  1071de:	68 de 00 00 00       	push   $0xde
  1071e3:	e9 b8 f3 ff ff       	jmp    1065a0 <alltraps>

001071e8 <vector223>:
  1071e8:	6a 00                	push   $0x0
  1071ea:	68 df 00 00 00       	push   $0xdf
  1071ef:	e9 ac f3 ff ff       	jmp    1065a0 <alltraps>

001071f4 <vector224>:
  1071f4:	6a 00                	push   $0x0
  1071f6:	68 e0 00 00 00       	push   $0xe0
  1071fb:	e9 a0 f3 ff ff       	jmp    1065a0 <alltraps>

00107200 <vector225>:
  107200:	6a 00                	push   $0x0
  107202:	68 e1 00 00 00       	push   $0xe1
  107207:	e9 94 f3 ff ff       	jmp    1065a0 <alltraps>

0010720c <vector226>:
  10720c:	6a 00                	push   $0x0
  10720e:	68 e2 00 00 00       	push   $0xe2
  107213:	e9 88 f3 ff ff       	jmp    1065a0 <alltraps>

00107218 <vector227>:
  107218:	6a 00                	push   $0x0
  10721a:	68 e3 00 00 00       	push   $0xe3
  10721f:	e9 7c f3 ff ff       	jmp    1065a0 <alltraps>

00107224 <vector228>:
  107224:	6a 00                	push   $0x0
  107226:	68 e4 00 00 00       	push   $0xe4
  10722b:	e9 70 f3 ff ff       	jmp    1065a0 <alltraps>

00107230 <vector229>:
  107230:	6a 00                	push   $0x0
  107232:	68 e5 00 00 00       	push   $0xe5
  107237:	e9 64 f3 ff ff       	jmp    1065a0 <alltraps>

0010723c <vector230>:
  10723c:	6a 00                	push   $0x0
  10723e:	68 e6 00 00 00       	push   $0xe6
  107243:	e9 58 f3 ff ff       	jmp    1065a0 <alltraps>

00107248 <vector231>:
  107248:	6a 00                	push   $0x0
  10724a:	68 e7 00 00 00       	push   $0xe7
  10724f:	e9 4c f3 ff ff       	jmp    1065a0 <alltraps>

00107254 <vector232>:
  107254:	6a 00                	push   $0x0
  107256:	68 e8 00 00 00       	push   $0xe8
  10725b:	e9 40 f3 ff ff       	jmp    1065a0 <alltraps>

00107260 <vector233>:
  107260:	6a 00                	push   $0x0
  107262:	68 e9 00 00 00       	push   $0xe9
  107267:	e9 34 f3 ff ff       	jmp    1065a0 <alltraps>

0010726c <vector234>:
  10726c:	6a 00                	push   $0x0
  10726e:	68 ea 00 00 00       	push   $0xea
  107273:	e9 28 f3 ff ff       	jmp    1065a0 <alltraps>

00107278 <vector235>:
  107278:	6a 00                	push   $0x0
  10727a:	68 eb 00 00 00       	push   $0xeb
  10727f:	e9 1c f3 ff ff       	jmp    1065a0 <alltraps>

00107284 <vector236>:
  107284:	6a 00                	push   $0x0
  107286:	68 ec 00 00 00       	push   $0xec
  10728b:	e9 10 f3 ff ff       	jmp    1065a0 <alltraps>

00107290 <vector237>:
  107290:	6a 00                	push   $0x0
  107292:	68 ed 00 00 00       	push   $0xed
  107297:	e9 04 f3 ff ff       	jmp    1065a0 <alltraps>

0010729c <vector238>:
  10729c:	6a 00                	push   $0x0
  10729e:	68 ee 00 00 00       	push   $0xee
  1072a3:	e9 f8 f2 ff ff       	jmp    1065a0 <alltraps>

001072a8 <vector239>:
  1072a8:	6a 00                	push   $0x0
  1072aa:	68 ef 00 00 00       	push   $0xef
  1072af:	e9 ec f2 ff ff       	jmp    1065a0 <alltraps>

001072b4 <vector240>:
  1072b4:	6a 00                	push   $0x0
  1072b6:	68 f0 00 00 00       	push   $0xf0
  1072bb:	e9 e0 f2 ff ff       	jmp    1065a0 <alltraps>

001072c0 <vector241>:
  1072c0:	6a 00                	push   $0x0
  1072c2:	68 f1 00 00 00       	push   $0xf1
  1072c7:	e9 d4 f2 ff ff       	jmp    1065a0 <alltraps>

001072cc <vector242>:
  1072cc:	6a 00                	push   $0x0
  1072ce:	68 f2 00 00 00       	push   $0xf2
  1072d3:	e9 c8 f2 ff ff       	jmp    1065a0 <alltraps>

001072d8 <vector243>:
  1072d8:	6a 00                	push   $0x0
  1072da:	68 f3 00 00 00       	push   $0xf3
  1072df:	e9 bc f2 ff ff       	jmp    1065a0 <alltraps>

001072e4 <vector244>:
  1072e4:	6a 00                	push   $0x0
  1072e6:	68 f4 00 00 00       	push   $0xf4
  1072eb:	e9 b0 f2 ff ff       	jmp    1065a0 <alltraps>

001072f0 <vector245>:
  1072f0:	6a 00                	push   $0x0
  1072f2:	68 f5 00 00 00       	push   $0xf5
  1072f7:	e9 a4 f2 ff ff       	jmp    1065a0 <alltraps>

001072fc <vector246>:
  1072fc:	6a 00                	push   $0x0
  1072fe:	68 f6 00 00 00       	push   $0xf6
  107303:	e9 98 f2 ff ff       	jmp    1065a0 <alltraps>

00107308 <vector247>:
  107308:	6a 00                	push   $0x0
  10730a:	68 f7 00 00 00       	push   $0xf7
  10730f:	e9 8c f2 ff ff       	jmp    1065a0 <alltraps>

00107314 <vector248>:
  107314:	6a 00                	push   $0x0
  107316:	68 f8 00 00 00       	push   $0xf8
  10731b:	e9 80 f2 ff ff       	jmp    1065a0 <alltraps>

00107320 <vector249>:
  107320:	6a 00                	push   $0x0
  107322:	68 f9 00 00 00       	push   $0xf9
  107327:	e9 74 f2 ff ff       	jmp    1065a0 <alltraps>

0010732c <vector250>:
  10732c:	6a 00                	push   $0x0
  10732e:	68 fa 00 00 00       	push   $0xfa
  107333:	e9 68 f2 ff ff       	jmp    1065a0 <alltraps>

00107338 <vector251>:
  107338:	6a 00                	push   $0x0
  10733a:	68 fb 00 00 00       	push   $0xfb
  10733f:	e9 5c f2 ff ff       	jmp    1065a0 <alltraps>

00107344 <vector252>:
  107344:	6a 00                	push   $0x0
  107346:	68 fc 00 00 00       	push   $0xfc
  10734b:	e9 50 f2 ff ff       	jmp    1065a0 <alltraps>

00107350 <vector253>:
  107350:	6a 00                	push   $0x0
  107352:	68 fd 00 00 00       	push   $0xfd
  107357:	e9 44 f2 ff ff       	jmp    1065a0 <alltraps>

0010735c <vector254>:
  10735c:	6a 00                	push   $0x0
  10735e:	68 fe 00 00 00       	push   $0xfe
  107363:	e9 38 f2 ff ff       	jmp    1065a0 <alltraps>

00107368 <vector255>:
  107368:	6a 00                	push   $0x0
  10736a:	68 ff 00 00 00       	push   $0xff
  10736f:	e9 2c f2 ff ff       	jmp    1065a0 <alltraps>
