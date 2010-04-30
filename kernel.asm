
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
  10000f:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  100016:	e8 d5 48 00 00       	call   1048f0 <acquire>

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
  10002a:	c7 43 0c c0 8a 10 00 	movl   $0x108ac0,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 d0 8a 10 00       	mov    0x108ad0,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 d0 8a 10 00       	mov    0x108ad0,%eax
  bufhead.next = b;
  100041:	89 1d d0 8a 10 00    	mov    %ebx,0x108ad0

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 e0 8c 10 00 	movl   $0x108ce0,(%esp)
  100051:	e8 5a 37 00 00       	call   1037b0 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 e0 a1 10 00 	movl   $0x10a1e0,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 49 48 00 00       	jmp    1048b0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 a0 6a 10 00 	movl   $0x106aa0,(%esp)
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
  10008e:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  100095:	e8 56 48 00 00       	call   1048f0 <acquire>

	  // Try for cached block.
	  for(b = bufhead.next; b != &bufhead; b = b->next){
  10009a:	a1 d0 8a 10 00       	mov    0x108ad0,%eax
  10009f:	3d c0 8a 10 00       	cmp    $0x108ac0,%eax
  1000a4:	75 0c                	jne    1000b2 <bcheck+0x32>
  1000a6:	eb 38                	jmp    1000e0 <bcheck+0x60>
  1000a8:	8b 40 10             	mov    0x10(%eax),%eax
  1000ab:	3d c0 8a 10 00       	cmp    $0x108ac0,%eax
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
  1000c2:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  1000c9:	e8 e2 47 00 00       	call   1048b0 <release>
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
  1000e0:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  1000e7:	e8 c4 47 00 00       	call   1048b0 <release>
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
  10011e:	c7 04 24 a7 6a 10 00 	movl   $0x106aa7,(%esp)
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
  10013f:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  100146:	e8 a5 47 00 00       	call   1048f0 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10014b:	8b 1d d0 8a 10 00    	mov    0x108ad0,%ebx
  100151:	81 fb c0 8a 10 00    	cmp    $0x108ac0,%ebx
  100157:	75 12                	jne    10016b <bread+0x3b>
  100159:	eb 3d                	jmp    100198 <bread+0x68>
  10015b:	90                   	nop
  10015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100160:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100163:	81 fb c0 8a 10 00    	cmp    $0x108ac0,%ebx
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
  100182:	c7 44 24 04 e0 a1 10 	movl   $0x10a1e0,0x4(%esp)
  100189:	00 
  10018a:	c7 04 24 e0 8c 10 00 	movl   $0x108ce0,(%esp)
  100191:	e8 ca 39 00 00       	call   103b60 <sleep>
  100196:	eb b3                	jmp    10014b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100198:	8b 1d cc 8a 10 00    	mov    0x108acc,%ebx
  10019e:	81 fb c0 8a 10 00    	cmp    $0x108ac0,%ebx
  1001a4:	75 0d                	jne    1001b3 <bread+0x83>
  1001a6:	eb 3f                	jmp    1001e7 <bread+0xb7>
  1001a8:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1001ab:	81 fb c0 8a 10 00    	cmp    $0x108ac0,%ebx
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
  1001c4:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  1001cb:	e8 e0 46 00 00       	call   1048b0 <release>
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
  1001e7:	c7 04 24 ae 6a 10 00 	movl   $0x106aae,(%esp)
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
  1001f8:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  1001ff:	e8 ac 46 00 00       	call   1048b0 <release>
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
  100216:	c7 44 24 04 bf 6a 10 	movl   $0x106abf,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 e0 a1 10 00 	movl   $0x10a1e0,(%esp)
  100225:	e8 06 45 00 00       	call   104730 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10022a:	b8 d0 a1 10 00       	mov    $0x10a1d0,%eax
  10022f:	3d e0 8c 10 00       	cmp    $0x108ce0,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  100234:	c7 05 cc 8a 10 00 c0 	movl   $0x108ac0,0x108acc
  10023b:	8a 10 00 
  bufhead.next = &bufhead;
  10023e:	c7 05 d0 8a 10 00 c0 	movl   $0x108ac0,0x108ad0
  100245:	8a 10 00 
  for(b = buf; b < buf+NBUF; b++){
  100248:	76 33                	jbe    10027d <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  10024a:	ba c0 8a 10 00       	mov    $0x108ac0,%edx
  10024f:	b8 e0 8c 10 00       	mov    $0x108ce0,%eax
  100254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100258:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  10025b:	c7 40 0c c0 8a 10 00 	movl   $0x108ac0,0xc(%eax)
    bufhead.next->prev = b;
  100262:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100265:	89 c2                	mov    %eax,%edx
  100267:	05 18 02 00 00       	add    $0x218,%eax
  10026c:	3d d0 a1 10 00       	cmp    $0x10a1d0,%eax
  100271:	75 e5                	jne    100258 <binit+0x48>
  100273:	c7 05 d0 8a 10 00 b8 	movl   $0x109fb8,0x108ad0
  10027a:	9f 10 00 
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
  100286:	c7 44 24 04 c9 6a 10 	movl   $0x106ac9,0x4(%esp)
  10028d:	00 
  10028e:	c7 04 24 20 8a 10 00 	movl   $0x108a20,(%esp)
  100295:	e8 96 44 00 00       	call   104730 <initlock>
  initlock(&input.lock, "console input");
  10029a:	c7 44 24 04 d1 6a 10 	movl   $0x106ad1,0x4(%esp)
  1002a1:	00 
  1002a2:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1002a9:	e8 82 44 00 00       	call   104730 <initlock>

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
  1002b5:	c7 05 8c ac 10 00 d0 	movl   $0x1006d0,0x10ac8c
  1002bc:	06 10 00 
  devsw[CONSOLE].read = console_read;
  1002bf:	c7 05 88 ac 10 00 f0 	movl   $0x1002f0,0x10ac88
  1002c6:	02 10 00 
  use_console_lock = 1;
  1002c9:	c7 05 04 8a 10 00 01 	movl   $0x1,0x108a04
  1002d0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002d3:	e8 e8 2e 00 00       	call   1031c0 <pic_enable>
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
  10030a:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  100311:	e8 da 45 00 00       	call   1048f0 <acquire>
  while(n > 0){
  100316:	85 db                	test   %ebx,%ebx
  100318:	7f 26                	jg     100340 <console_read+0x50>
  10031a:	e9 bb 00 00 00       	jmp    1003da <console_read+0xea>
  10031f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  100320:	e8 8b 35 00 00       	call   1038b0 <curproc>
  100325:	8b 40 1c             	mov    0x1c(%eax),%eax
  100328:	85 c0                	test   %eax,%eax
  10032a:	75 5c                	jne    100388 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10032c:	c7 44 24 04 20 a2 10 	movl   $0x10a220,0x4(%esp)
  100333:	00 
  100334:	c7 04 24 d4 a2 10 00 	movl   $0x10a2d4,(%esp)
  10033b:	e8 20 38 00 00       	call   103b60 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100340:	a1 d4 a2 10 00       	mov    0x10a2d4,%eax
  100345:	3b 05 d8 a2 10 00    	cmp    0x10a2d8,%eax
  10034b:	74 d3                	je     100320 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10034d:	89 c2                	mov    %eax,%edx
  10034f:	83 e2 7f             	and    $0x7f,%edx
  100352:	0f b6 8a 54 a2 10 00 	movzbl 0x10a254(%edx),%ecx
  100359:	8d 78 01             	lea    0x1(%eax),%edi
  10035c:	89 3d d4 a2 10 00    	mov    %edi,0x10a2d4
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
  100388:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  10038f:	e8 1c 45 00 00       	call   1048b0 <release>
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
  1003ae:	a3 d4 a2 10 00       	mov    %eax,0x10a2d4
  1003b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1003b6:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1003b8:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  1003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1003c2:	e8 e9 44 00 00       	call   1048b0 <release>
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
  1003ec:	83 3d 00 8a 10 00 00 	cmpl   $0x0,0x108a00
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
  100508:	e8 e3 44 00 00       	call   1049f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10050d:	b8 80 07 00 00       	mov    $0x780,%eax
  100512:	29 d8                	sub    %ebx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	89 44 24 08          	mov    %eax,0x8(%esp)
  10051a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100521:	00 
  100522:	89 34 24             	mov    %esi,(%esp)
  100525:	e8 36 44 00 00       	call   104960 <memset>
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
  100574:	be 50 a2 10 00       	mov    $0x10a250,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100579:	53                   	push   %ebx
  10057a:	83 ec 20             	sub    $0x20,%esp
  10057d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100580:	c7 04 24 20 a2 10 00 	movl   $0x10a220,(%esp)
  100587:	e8 64 43 00 00       	call   1048f0 <acquire>
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
  1005bc:	8b 15 dc a2 10 00    	mov    0x10a2dc,%edx
  1005c2:	89 d1                	mov    %edx,%ecx
  1005c4:	2b 0d d4 a2 10 00    	sub    0x10a2d4,%ecx
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
  1005e1:	89 15 dc a2 10 00    	mov    %edx,0x10a2dc
        cons_putc(c);
  1005e7:	e8 f4 fd ff ff       	call   1003e0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ef:	83 f8 04             	cmp    $0x4,%eax
  1005f2:	0f 84 ba 00 00 00    	je     1006b2 <console_intr+0x142>
  1005f8:	83 f8 0a             	cmp    $0xa,%eax
  1005fb:	0f 84 b1 00 00 00    	je     1006b2 <console_intr+0x142>
  100601:	8b 15 d4 a2 10 00    	mov    0x10a2d4,%edx
  100607:	a1 dc a2 10 00       	mov    0x10a2dc,%eax
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
  100628:	c7 45 08 20 a2 10 00 	movl   $0x10a220,0x8(%ebp)
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
  100635:	e9 76 42 00 00       	jmp    1048b0 <release>
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
  100648:	80 ba 54 a2 10 00 0a 	cmpb   $0xa,0x10a254(%edx)
  10064f:	0f 84 3b ff ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100655:	a3 dc a2 10 00       	mov    %eax,0x10a2dc
        cons_putc(BACKSPACE);
  10065a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100661:	e8 7a fd ff ff       	call   1003e0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100666:	a1 dc a2 10 00       	mov    0x10a2dc,%eax
  10066b:	3b 05 d8 a2 10 00    	cmp    0x10a2d8,%eax
  100671:	75 cd                	jne    100640 <console_intr+0xd0>
  100673:	e9 18 ff ff ff       	jmp    100590 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100678:	e8 d3 2f 00 00       	call   103650 <procdump>
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
  100688:	a1 dc a2 10 00       	mov    0x10a2dc,%eax
  10068d:	3b 05 d8 a2 10 00    	cmp    0x10a2d8,%eax
  100693:	0f 84 f7 fe ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100699:	83 e8 01             	sub    $0x1,%eax
  10069c:	a3 dc a2 10 00       	mov    %eax,0x10a2dc
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
  1006b2:	a1 dc a2 10 00       	mov    0x10a2dc,%eax
          input.w = input.e;
  1006b7:	a3 d8 a2 10 00       	mov    %eax,0x10a2d8
          wakeup(&input.r);
  1006bc:	c7 04 24 d4 a2 10 00 	movl   $0x10a2d4,(%esp)
  1006c3:	e8 e8 30 00 00       	call   1037b0 <wakeup>
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
  1006ea:	c7 04 24 20 8a 10 00 	movl   $0x108a20,(%esp)
  1006f1:	e8 fa 41 00 00       	call   1048f0 <acquire>
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
  100713:	c7 04 24 20 8a 10 00 	movl   $0x108a20,(%esp)
  10071a:	e8 91 41 00 00       	call   1048b0 <release>
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
  10076c:	0f b6 92 f9 6a 10 00 	movzbl 0x106af9(%edx),%edx
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
  1007c9:	a1 04 8a 10 00       	mov    0x108a04,%eax
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
  10086f:	c7 04 24 20 8a 10 00 	movl   $0x108a20,(%esp)
  100876:	e8 35 40 00 00       	call   1048b0 <release>
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
  100940:	c7 04 24 20 8a 10 00 	movl   $0x108a20,(%esp)
  100947:	e8 a4 3f 00 00       	call   1048f0 <acquire>
  10094c:	e9 88 fe ff ff       	jmp    1007d9 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  100951:	be df 6a 10 00       	mov    $0x106adf,%esi
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
  100968:	c7 05 04 8a 10 00 00 	movl   $0x0,0x108a04
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
  10097d:	c7 04 24 e6 6a 10 00 	movl   $0x106ae6,(%esp)
  100984:	89 44 24 04          	mov    %eax,0x4(%esp)
  100988:	e8 33 fe ff ff       	call   1007c0 <cprintf>
  cprintf(s);
  10098d:	8b 45 08             	mov    0x8(%ebp),%eax
  100990:	89 04 24             	mov    %eax,(%esp)
  100993:	e8 28 fe ff ff       	call   1007c0 <cprintf>
  cprintf("\n");
  100998:	c7 04 24 7c 6f 10 00 	movl   $0x106f7c,(%esp)
  10099f:	e8 1c fe ff ff       	call   1007c0 <cprintf>
  getcallerpcs(&s, pcs);
  1009a4:	8d 45 08             	lea    0x8(%ebp),%eax
  1009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1009ab:	89 04 24             	mov    %eax,(%esp)
  1009ae:	e8 9d 3d 00 00       	call   104750 <getcallerpcs>
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
  1009be:	c7 04 24 f5 6a 10 00 	movl   $0x106af5,(%esp)
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
  1009d3:	c7 05 00 8a 10 00 01 	movl   $0x1,0x108a00
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
  100aee:	e8 4d 40 00 00       	call   104b40 <strlen>
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
  100b5b:	e8 00 3e 00 00       	call   104960 <memset>

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
  100c08:	e8 53 3d 00 00       	call   104960 <memset>
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
  100c86:	e8 b5 3e 00 00       	call   104b40 <strlen>
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
  100ca5:	e8 46 3d 00 00       	call   1049f0 <memmove>
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
  100d0b:	e8 a0 2b 00 00       	call   1038b0 <curproc>
  100d10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d14:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d1b:	00 
  100d1c:	05 88 00 00 00       	add    $0x88,%eax
  100d21:	89 04 24             	mov    %eax,(%esp)
  100d24:	e8 d7 3d 00 00       	call   104b00 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100d29:	e8 82 2b 00 00       	call   1038b0 <curproc>
  100d2e:	8b 58 04             	mov    0x4(%eax),%ebx
  100d31:	e8 7a 2b 00 00       	call   1038b0 <curproc>
  100d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d3a:	8b 00                	mov    (%eax),%eax
  100d3c:	89 04 24             	mov    %eax,(%esp)
  100d3f:	e8 4c 19 00 00       	call   102690 <kfree>
  cp->mem = mem;
  100d44:	e8 67 2b 00 00       	call   1038b0 <curproc>
  100d49:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d4c:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100d4e:	e8 5d 2b 00 00       	call   1038b0 <curproc>
  100d53:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100d56:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d59:	e8 52 2b 00 00       	call   1038b0 <curproc>
  100d5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100d61:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d67:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100d6a:	e8 41 2b 00 00       	call   1038b0 <curproc>
  100d6f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d75:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d78:	e8 33 2b 00 00       	call   1038b0 <curproc>
  100d7d:	89 04 24             	mov    %eax,(%esp)
  100d80:	e8 fb 30 00 00       	call   103e80 <setupsegs>
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
    if((r = log_writei(f->ip, addr, f->off, n)) > 0)
  100e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e19:	8b 43 14             	mov    0x14(%ebx),%eax
  100e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e24:	8b 43 10             	mov    0x10(%ebx),%eax
  100e27:	89 04 24             	mov    %eax,(%esp)
  100e2a:	e8 81 1d 00 00       	call   102bb0 <log_writei>
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
  100e72:	e9 f9 24 00 00       	jmp    103370 <pipewrite>
    if((r = log_writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e77:	c7 04 24 0a 6b 10 00 	movl   $0x106b0a,(%esp)
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
  100ef1:	c7 04 24 14 6b 10 00 	movl   $0x106b14,(%esp)
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
  100f92:	e9 f9 22 00 00       	jmp    103290 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f97:	c7 04 24 1e 6b 10 00 	movl   $0x106b1e,(%esp)
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
  10100a:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  101011:	e8 da 38 00 00       	call   1048f0 <acquire>
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
  101029:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  101030:	e8 7b 38 00 00       	call   1048b0 <release>
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
  10103d:	c7 04 24 27 6b 10 00 	movl   $0x106b27,(%esp)
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
  101057:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  10105e:	e8 8d 38 00 00       	call   1048f0 <acquire>
  101063:	ba e0 a2 10 00       	mov    $0x10a2e0,%edx
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
  10108b:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  101092:	c7 04 d5 e0 a2 10 00 	movl   $0x1,0x10a2e0(,%edx,8)
  101099:	01 00 00 00 
      file[i].ref = 1;
  10109d:	c7 04 d5 e4 a2 10 00 	movl   $0x1,0x10a2e4(,%edx,8)
  1010a4:	01 00 00 00 
      release(&file_table_lock);
  1010a8:	e8 03 38 00 00       	call   1048b0 <release>
      return file + i;
  1010ad:	8d 83 e0 a2 10 00    	lea    0x10a2e0(%ebx),%eax
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
  1010c0:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  1010c7:	e8 e4 37 00 00       	call   1048b0 <release>
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
  1010f2:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  1010f9:	e8 f2 37 00 00       	call   1048f0 <acquire>
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
  10111d:	c7 45 08 40 ac 10 00 	movl   $0x10ac40,0x8(%ebp)
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
  101130:	e9 7b 37 00 00       	jmp    1048b0 <release>
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
  101157:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  10115e:	e8 4d 37 00 00       	call   1048b0 <release>
  
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
  101196:	e8 d5 22 00 00       	call   103470 <pipeclose>
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
  1011a8:	c7 04 24 2f 6b 10 00 	movl   $0x106b2f,(%esp)
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
  1011c6:	c7 44 24 04 39 6b 10 	movl   $0x106b39,0x4(%esp)
  1011cd:	00 
  1011ce:	c7 04 24 40 ac 10 00 	movl   $0x10ac40,(%esp)
  1011d5:	e8 56 35 00 00       	call   104730 <initlock>
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
  10121a:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101221:	e8 ca 36 00 00       	call   1048f0 <acquire>
  ip->ref++;
  101226:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10122a:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101231:	e8 7a 36 00 00       	call   1048b0 <release>
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
  10124f:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101256:	e8 95 36 00 00       	call   1048f0 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10125b:	b8 14 ad 10 00       	mov    $0x10ad14,%eax
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
  10126f:	3d b4 bc 10 00       	cmp    $0x10bcb4,%eax
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
  10128c:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101296:	e8 15 36 00 00       	call   1048b0 <release>
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
  1012b1:	3d b4 bc 10 00       	cmp    $0x10bcb4,%eax
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
  1012cf:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  1012d6:	e8 d5 35 00 00       	call   1048b0 <release>

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
  1012e5:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
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
  101332:	e8 b9 36 00 00       	call   1049f0 <memmove>
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
  10140b:	c7 04 24 54 6b 10 00 	movl   $0x106b54,(%esp)
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
  101600:	c7 04 24 6a 6b 10 00 	movl   $0x106b6a,(%esp)
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
  10165b:	8b 04 c5 80 ac 10 00 	mov    0x10ac80(,%eax,8),%eax
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
  1016f7:	e8 f4 32 00 00       	call   1049f0 <memmove>
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
  10178b:	e8 60 32 00 00       	call   1049f0 <memmove>
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
  10185a:	e8 91 31 00 00       	call   1049f0 <memmove>
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
  1018be:	8b 04 c5 84 ac 10 00 	mov    0x10ac84(,%eax,8),%eax
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
  1018fb:	e8 50 31 00 00       	call   104a50 <strncmp>
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
  101a03:	c7 04 24 7d 6b 10 00 	movl   $0x106b7d,(%esp)
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
  101aeb:	e8 70 2e 00 00       	call   104960 <memset>
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
  101b1c:	c7 04 24 8f 6b 10 00 	movl   $0x106b8f,(%esp)
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
  101b61:	e8 fa 2d 00 00       	call   104960 <memset>
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
  101be2:	c7 04 24 a1 6b 10 00 	movl   $0x106ba1,(%esp)
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
  101bfc:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101c03:	e8 e8 2c 00 00       	call   1048f0 <acquire>
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
  101c41:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101c48:	e8 63 2c 00 00       	call   1048b0 <release>
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
  101ca1:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101ca8:	e8 43 2c 00 00       	call   1048f0 <acquire>
    ip->flags &= ~I_BUSY;
  101cad:	83 67 0c fe          	andl   $0xfffffffe,0xc(%edi)
    wakeup(ip);
  101cb1:	89 3c 24             	mov    %edi,(%esp)
  101cb4:	e8 f7 1a 00 00       	call   1037b0 <wakeup>
  101cb9:	8b 47 08             	mov    0x8(%edi),%eax
  }
  ip->ref--;
  101cbc:	83 e8 01             	sub    $0x1,%eax
  101cbf:	89 47 08             	mov    %eax,0x8(%edi)
  release(&icache.lock);
  101cc2:	c7 45 08 e0 ac 10 00 	movl   $0x10ace0,0x8(%ebp)
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
  101cd0:	e9 db 2b 00 00       	jmp    1048b0 <release>
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
  101dd3:	c7 04 24 b4 6b 10 00 	movl   $0x106bb4,(%esp)
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
  101e61:	e8 4a 2c 00 00       	call   104ab0 <strncpy>
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
  101eaa:	c7 04 24 be 6b 10 00 	movl   $0x106bbe,(%esp)
  101eb1:	e8 aa ea ff ff       	call   100960 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101eb6:	c7 04 24 cb 6b 10 00 	movl   $0x106bcb,(%esp)
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
  101eeb:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101ef2:	e8 f9 29 00 00       	call   1048f0 <acquire>
  ip->flags &= ~I_BUSY;
  101ef7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101efb:	89 1c 24             	mov    %ebx,(%esp)
  101efe:	e8 ad 18 00 00       	call   1037b0 <wakeup>
  release(&icache.lock);
  101f03:	c7 45 08 e0 ac 10 00 	movl   $0x10ace0,0x8(%ebp)
}
  101f0a:	83 c4 14             	add    $0x14,%esp
  101f0d:	5b                   	pop    %ebx
  101f0e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101f0f:	e9 9c 29 00 00       	jmp    1048b0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101f14:	c7 04 24 d3 6b 10 00 	movl   $0x106bd3,(%esp)
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
  101f5e:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101f65:	e8 86 29 00 00       	call   1048f0 <acquire>
  while(ip->flags & I_BUSY)
  101f6a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f6d:	a8 01                	test   $0x1,%al
  101f6f:	74 1e                	je     101f8f <ilock+0x4f>
  101f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101f78:	c7 44 24 04 e0 ac 10 	movl   $0x10ace0,0x4(%esp)
  101f7f:	00 
  101f80:	89 1c 24             	mov    %ebx,(%esp)
  101f83:	e8 d8 1b 00 00       	call   103b60 <sleep>

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
  101f95:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  101f9c:	e8 0f 29 00 00       	call   1048b0 <release>

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
  102010:	e8 db 29 00 00       	call   1049f0 <memmove>
    brelse(bp);
  102015:	89 34 24             	mov    %esi,(%esp)
  102018:	e8 e3 df ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  10201d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  102021:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  102026:	0f 85 7b ff ff ff    	jne    101fa7 <ilock+0x67>
      panic("ilock: no type");
  10202c:	c7 04 24 e1 6b 10 00 	movl   $0x106be1,(%esp)
  102033:	e8 28 e9 ff ff       	call   100960 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  102038:	c7 04 24 db 6b 10 00 	movl   $0x106bdb,(%esp)
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
	//cprintf("Path: %s\n", path);
  struct inode *ip, *next;

  if(*path == '/')
  102061:	80 38 2f             	cmpb   $0x2f,(%eax)
  102064:	0f 84 3b 01 00 00    	je     1021a5 <_namei+0x155>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  10206a:	e8 41 18 00 00       	call   1038b0 <curproc>
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
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
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
  1020e2:	e8 09 29 00 00       	call   1049f0 <memmove>
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
  else
    ip = idup(cp->cwd);

  //cprintf("cp name: %s\n", cp->name);

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
      //cprintf("HERE\n");
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
      //cprintf("HERE3\n");
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
      //cprintf("HERE1\n");
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
  102177:	e8 74 28 00 00       	call   1049f0 <memmove>
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
      iunlock(ip);
      //cprintf("HERE3\n");
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  102191:	89 3c 24             	mov    %edi,(%esp)
  102194:	31 ff                	xor    %edi,%edi
  102196:	e8 85 fd ff ff       	call   101f20 <iunlockput>
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
  return ip;
}
  10219b:	83 c4 2c             	add    $0x2c,%esp
  10219e:	89 f8                	mov    %edi,%eax
  1021a0:	5b                   	pop    %ebx
  1021a1:	5e                   	pop    %esi
  1021a2:	5f                   	pop    %edi
  1021a3:	5d                   	pop    %ebp
  1021a4:	c3                   	ret    
{
	//cprintf("Path: %s\n", path);
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  1021a5:	ba 01 00 00 00       	mov    $0x1,%edx
  1021aa:	b8 01 00 00 00       	mov    $0x1,%eax
  1021af:	e8 8c f0 ff ff       	call   101240 <iget>
  1021b4:	89 c7                	mov    %eax,%edi
  1021b6:	e9 c8 fe ff ff       	jmp    102083 <_namei+0x33>
      //cprintf("HERE\n");
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  1021bb:	89 3c 24             	mov    %edi,(%esp)
  1021be:	e8 0d fd ff ff       	call   101ed0 <iunlock>
    //cprintf("HERE2\n");
    return 0;
  }
  //cprintf("HERE4-2: %d\n", ip);
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
    //cprintf("HERE2\n");
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
  102226:	c7 44 24 04 f0 6b 10 	movl   $0x106bf0,0x4(%esp)
  10222d:	00 
  10222e:	c7 04 24 e0 ac 10 00 	movl   $0x10ace0,(%esp)
  102235:	e8 f6 24 00 00       	call   104730 <initlock>
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
  1022da:	c7 04 24 fc 6b 10 00 	movl   $0x106bfc,(%esp)
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
  102317:	a1 98 8a 10 00       	mov    0x108a98,%eax
  10231c:	85 c0                	test   %eax,%eax
  10231e:	0f 84 7c 00 00 00    	je     1023a0 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102324:	c7 04 24 60 8a 10 00 	movl   $0x108a60,(%esp)
  10232b:	e8 c0 25 00 00       	call   1048f0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102330:	a1 94 8a 10 00       	mov    0x108a94,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102335:	ba 94 8a 10 00       	mov    $0x108a94,%edx
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
  102354:	39 1d 94 8a 10 00    	cmp    %ebx,0x108a94
  10235a:	75 14                	jne    102370 <ide_rw+0x80>
  10235c:	eb 2d                	jmp    10238b <ide_rw+0x9b>
  10235e:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102360:	c7 44 24 04 60 8a 10 	movl   $0x108a60,0x4(%esp)
  102367:	00 
  102368:	89 1c 24             	mov    %ebx,(%esp)
  10236b:	e8 f0 17 00 00       	call   103b60 <sleep>
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
  10237a:	c7 45 08 60 8a 10 00 	movl   $0x108a60,0x8(%ebp)
}
  102381:	83 c4 14             	add    $0x14,%esp
  102384:	5b                   	pop    %ebx
  102385:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102386:	e9 25 25 00 00       	jmp    1048b0 <release>
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
  102394:	c7 04 24 0e 6c 10 00 	movl   $0x106c0e,(%esp)
  10239b:	e8 c0 e5 ff ff       	call   100960 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1023a0:	c7 04 24 39 6c 10 00 	movl   $0x106c39,(%esp)
  1023a7:	e8 b4 e5 ff ff       	call   100960 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1023ac:	c7 04 24 23 6c 10 00 	movl   $0x106c23,(%esp)
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
  1023c8:	c7 04 24 60 8a 10 00 	movl   $0x108a60,(%esp)
  1023cf:	e8 1c 25 00 00       	call   1048f0 <acquire>
  if((b = ide_queue) == 0){
  1023d4:	8b 1d 94 8a 10 00    	mov    0x108a94,%ebx
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
  1023f0:	e8 bb 13 00 00       	call   1037b0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  1023f5:	8b 43 14             	mov    0x14(%ebx),%eax
  1023f8:	85 c0                	test   %eax,%eax
  1023fa:	a3 94 8a 10 00       	mov    %eax,0x108a94
  1023ff:	74 05                	je     102406 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102401:	e8 3a fe ff ff       	call   102240 <ide_start_request>

  release(&ide_lock);
  102406:	c7 04 24 60 8a 10 00 	movl   $0x108a60,(%esp)
  10240d:	e8 9e 24 00 00       	call   1048b0 <release>
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
  102456:	c7 44 24 04 50 6c 10 	movl   $0x106c50,0x4(%esp)
  10245d:	00 
  10245e:	c7 04 24 60 8a 10 00 	movl   $0x108a60,(%esp)
  102465:	e8 c6 22 00 00       	call   104730 <initlock>
  pic_enable(IRQ_IDE);
  10246a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102471:	e8 4a 0d 00 00       	call   1031c0 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102476:	a1 80 c3 10 00       	mov    0x10c380,%eax
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
  1024c8:	c7 05 98 8a 10 00 01 	movl   $0x1,0x108a98
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
  1024e0:	8b 15 00 bd 10 00    	mov    0x10bd00,%edx
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
  1024f7:	a1 b4 bc 10 00       	mov    0x10bcb4,%eax
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
  102528:	8b 0d 00 bd 10 00    	mov    0x10bd00,%ecx
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
  10255b:	0f b6 0d 04 bd 10 00 	movzbl 0x10bd04,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102562:	c7 05 b4 bc 10 00 00 	movl   $0xfec00000,0x10bcb4
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
  10257c:	c7 04 24 54 6c 10 00 	movl   $0x106c54,(%esp)
  102583:	e8 38 e2 ff ff       	call   1007c0 <cprintf>
  102588:	a1 b4 bc 10 00       	mov    0x10bcb4,%eax
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
  1025e3:	c7 04 24 88 6c 10 00 	movl   $0x106c88,(%esp)
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
  1025f4:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  1025fb:	e8 f0 22 00 00       	call   1048f0 <acquire>
  102600:	8b 1d f4 bc 10 00    	mov    0x10bcf4,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102606:	85 db                	test   %ebx,%ebx
  102608:	74 3e                	je     102648 <kalloc+0x78>
    if(r->len == n){
  10260a:	8b 43 04             	mov    0x4(%ebx),%eax
  10260d:	ba f4 bc 10 00       	mov    $0x10bcf4,%edx
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
  102632:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  102639:	e8 72 22 00 00       	call   1048b0 <release>
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
  10264a:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  102651:	e8 5a 22 00 00       	call   1048b0 <release>

  cprintf("kalloc: out of memory\n");
  102656:	c7 04 24 8f 6c 10 00 	movl   $0x106c8f,(%esp)
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
  102674:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  10267b:	e8 30 22 00 00       	call   1048b0 <release>
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
  1026c7:	e8 94 22 00 00       	call   104960 <memset>

  acquire(&kalloc_lock);
  1026cc:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  1026d3:	e8 18 22 00 00       	call   1048f0 <acquire>
  p = (struct run*)v;
  1026d8:	a1 f4 bc 10 00       	mov    0x10bcf4,%eax
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
  10271e:	c7 04 24 ac 6c 10 00 	movl   $0x106cac,(%esp)
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
  102742:	bf f4 bc 10 00       	mov    $0x10bcf4,%edi
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
  102752:	c7 45 08 c0 bc 10 00 	movl   $0x10bcc0,0x8(%ebp)
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
  102760:	e9 4b 21 00 00       	jmp    1048b0 <release>
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
  10278c:	bf f4 bc 10 00       	mov    $0x10bcf4,%edi
  102791:	eb a1                	jmp    102734 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  102793:	c7 04 24 a6 6c 10 00 	movl   $0x106ca6,(%esp)
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
  1027a6:	c7 44 24 04 88 6c 10 	movl   $0x106c88,0x4(%esp)
  1027ad:	00 
  1027ae:	c7 04 24 c0 bc 10 00 	movl   $0x10bcc0,(%esp)
  1027b5:	e8 76 1f 00 00       	call   104730 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1027ba:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1027c1:	00 
  1027c2:	c7 04 24 be 6c 10 00 	movl   $0x106cbe,(%esp)
  1027c9:	e8 f2 df ff ff       	call   1007c0 <cprintf>
  kfree(start, mem * PAGE);
  1027ce:	b8 24 03 11 00       	mov    $0x110324,%eax
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
  10281d:	8b 15 9c 8a 10 00    	mov    0x108a9c,%edx
  102823:	f6 c2 40             	test   $0x40,%dl
  102826:	75 03                	jne    10282b <kbd_getc+0x3b>
  102828:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10282b:	0f b6 80 e0 6c 10 00 	movzbl 0x106ce0(%eax),%eax
  102832:	83 c8 40             	or     $0x40,%eax
  102835:	0f b6 c0             	movzbl %al,%eax
  102838:	f7 d0                	not    %eax
  10283a:	21 d0                	and    %edx,%eax
  10283c:	a3 9c 8a 10 00       	mov    %eax,0x108a9c
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
  102848:	8b 0d 9c 8a 10 00    	mov    0x108a9c,%ecx
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
  102858:	0f b6 90 e0 6c 10 00 	movzbl 0x106ce0(%eax),%edx
  10285f:	09 ca                	or     %ecx,%edx
  102861:	0f b6 88 e0 6d 10 00 	movzbl 0x106de0(%eax),%ecx
  102868:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  10286a:	89 d1                	mov    %edx,%ecx
  10286c:	83 e1 03             	and    $0x3,%ecx
  10286f:	8b 0c 8d e0 6e 10 00 	mov    0x106ee0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102876:	89 15 9c 8a 10 00    	mov    %edx,0x108a9c
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
  10289a:	83 0d 9c 8a 10 00 40 	orl    $0x40,0x108a9c
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
  1028e0:	a1 f8 bc 10 00       	mov    0x10bcf8,%eax
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
  1029d0:	a1 f8 bc 10 00       	mov    0x10bcf8,%eax
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
  102a13:	8b 15 f8 bc 10 00    	mov    0x10bcf8,%edx
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
  102b6d:	a1 a0 8a 10 00       	mov    0x108aa0,%eax
  102b72:	8d 50 01             	lea    0x1(%eax),%edx
  102b75:	85 c0                	test   %eax,%eax
  102b77:	89 15 a0 8a 10 00    	mov    %edx,0x108aa0
  102b7d:	74 19                	je     102b98 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  102b7f:	8b 15 f8 bc 10 00    	mov    0x10bcf8,%edx
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
  102b9d:	c7 04 24 f0 6e 10 00 	movl   $0x106ef0,(%esp)
  102ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ba8:	e8 13 dc ff ff       	call   1007c0 <cprintf>
  102bad:	eb d0                	jmp    102b7f <cpu+0x1f>
  102baf:	90                   	nop

00102bb0 <log_writei>:
 * off = offset from beginning of file where we should start writing
 * n = size of buffer to be written
 */
int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  102bb0:	55                   	push   %ebp
  102bb1:	89 e5                	mov    %esp,%ebp
  102bb3:	83 ec 58             	sub    $0x58,%esp
  102bb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102bb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  102bbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct transhead t;
  t.status = LOGGING;
  t.ip = ip;
  102bbf:	8b 45 08             	mov    0x8(%ebp),%eax
 * off = offset from beginning of file where we should start writing
 * n = size of buffer to be written
 */
int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  102bc2:	8b 7d 10             	mov    0x10(%ebp),%edi
  102bc5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  t.status = LOGGING;
  t.ip = ip;
  t.offset = off;
  t.size = n;
  //if it's a huge write, SCREW LOGS (for now)!
  if(n > BSIZE*LOGGED_BLOCKS){
  102bcb:	81 fb 00 14 00 00    	cmp    $0x1400,%ebx
 */
int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  struct transhead t;
  t.status = LOGGING;
  102bd1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  t.ip = ip;
  102bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  t.offset = off;
  102bdb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  t.size = n;
  102bde:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  //if it's a huge write, SCREW LOGS (for now)!
  if(n > BSIZE*LOGGED_BLOCKS){
  102be1:	76 14                	jbe    102bf7 <log_writei+0x47>
	  writei(ip, src, off, n);
  102be3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102be7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102beb:	89 74 24 04          	mov    %esi,0x4(%esp)
  102bef:	89 04 24             	mov    %eax,(%esp)
  102bf2:	e8 b9 eb ff ff       	call   1017b0 <writei>
  }
  writei(log_ip, &t, 0, sizeof(struct transhead));		//write status
  102bf7:	a1 fc bc 10 00       	mov    0x10bcfc,%eax
  102bfc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  102bff:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c03:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102c06:	c7 44 24 0c 14 00 00 	movl   $0x14,0xc(%esp)
  102c0d:	00 
  102c0e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102c15:	00 
  102c16:	89 04 24             	mov    %eax,(%esp)
  102c19:	e8 92 eb ff ff       	call   1017b0 <writei>
  writei(log_ip, *src, BSIZE, n);							//write data to log file
  102c1e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c22:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102c29:	00 
  102c2a:	0f be 06             	movsbl (%esi),%eax
  102c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c31:	a1 fc bc 10 00       	mov    0x10bcfc,%eax
  102c36:	89 04 24             	mov    %eax,(%esp)
  102c39:	e8 72 eb ff ff       	call   1017b0 <writei>

  //data is logged, now time for the write -- BOO YA!
  t.status = LOGGED;
  writei(log_ip, &t, 0, sizeof(struct transhead));
  102c3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c41:	a1 fc bc 10 00       	mov    0x10bcfc,%eax
  }
  writei(log_ip, &t, 0, sizeof(struct transhead));		//write status
  writei(log_ip, *src, BSIZE, n);							//write data to log file

  //data is logged, now time for the write -- BOO YA!
  t.status = LOGGED;
  102c46:	c7 45 d4 02 00 00 00 	movl   $0x2,-0x2c(%ebp)
  writei(log_ip, &t, 0, sizeof(struct transhead));
  102c4d:	c7 44 24 0c 14 00 00 	movl   $0x14,0xc(%esp)
  102c54:	00 
  102c55:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c59:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102c60:	00 
  102c61:	89 04 24             	mov    %eax,(%esp)
  102c64:	e8 47 eb ff ff       	call   1017b0 <writei>
  writei(ip, src, off, n);
  102c69:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c70:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102c74:	89 74 24 04          	mov    %esi,0x4(%esp)
  102c78:	89 04 24             	mov    %eax,(%esp)
  102c7b:	e8 30 eb ff ff       	call   1017b0 <writei>

  //writing to the log if finally done, god that took forever
  t.status = CLEAR;

  return;
}
  102c80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102c83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102c86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102c89:	89 ec                	mov    %ebp,%esp
  102c8b:	5d                   	pop    %ebp
  102c8c:	c3                   	ret    
  102c8d:	8d 76 00             	lea    0x0(%esi),%esi

00102c90 <log_initialize>:
uint size;
};


/**Checks if log exists, if it does not, create one*/
void log_initialize(){
  102c90:	55                   	push   %ebp
  102c91:	89 e5                	mov    %esp,%ebp
  102c93:	56                   	push   %esi
  102c94:	53                   	push   %ebx
  102c95:	81 ec 30 02 00 00    	sub    $0x230,%esp
	/*
	if(ip = namei(path) == 0){
		panic("cannot get inode for log file");
	}
	*/
	ip = namei(path);
  102c9b:	c7 04 24 1c 6f 10 00 	movl   $0x106f1c,(%esp)
  102ca2:	8d b5 e4 fd ff ff    	lea    -0x21c(%ebp),%esi
  102ca8:	e8 53 f5 ff ff       	call   102200 <namei>
  102cad:	89 c3                	mov    %eax,%ebx

	cprintf("ip->inum is %d\n", ip->inum);
  102caf:	8b 40 04             	mov    0x4(%eax),%eax
  102cb2:	c7 04 24 21 6f 10 00 	movl   $0x106f21,(%esp)
  102cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cbd:	e8 fe da ff ff       	call   1007c0 <cprintf>
  102cc2:	31 c0                	xor    %eax,%eax
  102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	//create buffer as large as the block size
	char buf[BSIZE];
	int i;
	for(i = 0; i < BSIZE; i++){
		buf[i] = 0;
  102cc8:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
	cprintf("ip->inum is %d\n", ip->inum);

	//create buffer as large as the block size
	char buf[BSIZE];
	int i;
	for(i = 0; i < BSIZE; i++){
  102ccc:	83 c0 01             	add    $0x1,%eax
  102ccf:	3d 00 02 00 00       	cmp    $0x200,%eax
  102cd4:	75 f2                	jne    102cc8 <log_initialize+0x38>
		buf[i] = 0;
	}

	//check if log exists, otherwise create it
	int lsize = BSIZE*(LOGGED_BLOCKS+1);
	ilock(ip);
  102cd6:	89 1c 24             	mov    %ebx,(%esp)
  102cd9:	e8 62 f2 ff ff       	call   101f40 <ilock>
	if(ip->size != lsize){
  102cde:	81 7b 18 00 16 00 00 	cmpl   $0x1600,0x18(%ebx)
  102ce5:	74 28                	je     102d0f <log_initialize+0x7f>
		writei(ip, buf, 0, lsize);
  102ce7:	c7 44 24 0c 00 16 00 	movl   $0x1600,0xc(%esp)
  102cee:	00 
  102cef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102cf6:	00 
  102cf7:	89 74 24 04          	mov    %esi,0x4(%esp)
  102cfb:	89 1c 24             	mov    %ebx,(%esp)
  102cfe:	e8 ad ea ff ff       	call   1017b0 <writei>
		cprintf("re-created log file");
  102d03:	c7 04 24 31 6f 10 00 	movl   $0x106f31,(%esp)
  102d0a:	e8 b1 da ff ff       	call   1007c0 <cprintf>
	}
	iunlock(ip);
  102d0f:	89 1c 24             	mov    %ebx,(%esp)
  102d12:	e8 b9 f1 ff ff       	call   101ed0 <iunlock>
	struct transhead t;
	t.status = CLEAR;
	t.currBlockIndex = 0;
	t.offset = 0;
	t.size = 0;
	writei(ip, &t, 0, sizeof(struct transhead));
  102d17:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  102d1a:	89 1c 24             	mov    %ebx,(%esp)
		cprintf("re-created log file");
	}
	iunlock(ip);

	struct transhead t;
	t.status = CLEAR;
  102d1d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	t.currBlockIndex = 0;
  102d24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	t.offset = 0;
  102d2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	t.size = 0;
  102d32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	writei(ip, &t, 0, sizeof(struct transhead));
  102d39:	c7 44 24 0c 14 00 00 	movl   $0x14,0xc(%esp)
  102d40:	00 
  102d41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102d48:	00 
  102d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d4d:	e8 5e ea ff ff       	call   1017b0 <writei>

	log_ip = ip;
  102d52:	89 1d fc bc 10 00    	mov    %ebx,0x10bcfc

	return;
}
  102d58:	81 c4 30 02 00 00    	add    $0x230,%esp
  102d5e:	5b                   	pop    %ebx
  102d5f:	5e                   	pop    %esi
  102d60:	5d                   	pop    %ebp
  102d61:	c3                   	ret    
  102d62:	90                   	nop
  102d63:	90                   	nop
  102d64:	90                   	nop
  102d65:	90                   	nop
  102d66:	90                   	nop
  102d67:	90                   	nop
  102d68:	90                   	nop
  102d69:	90                   	nop
  102d6a:	90                   	nop
  102d6b:	90                   	nop
  102d6c:	90                   	nop
  102d6d:	90                   	nop
  102d6e:	90                   	nop
  102d6f:	90                   	nop

00102d70 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102d70:	55                   	push   %ebp
  102d71:	89 e5                	mov    %esp,%ebp
  102d73:	53                   	push   %ebx
  102d74:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102d77:	e8 e4 fd ff ff       	call   102b60 <cpu>
  102d7c:	c7 04 24 45 6f 10 00 	movl   $0x106f45,(%esp)
  102d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d87:	e8 34 da ff ff       	call   1007c0 <cprintf>
  idtinit();
  102d8c:	e8 5f 2f 00 00       	call   105cf0 <idtinit>
  if(cpu() != mp_bcpu())
  102d91:	e8 ca fd ff ff       	call   102b60 <cpu>
  102d96:	89 c3                	mov    %eax,%ebx
  102d98:	e8 c3 01 00 00       	call   102f60 <mp_bcpu>
  102d9d:	39 c3                	cmp    %eax,%ebx
  102d9f:	74 0d                	je     102dae <mpmain+0x3e>
  lapic_init(cpu());
  102da1:	e8 ba fd ff ff       	call   102b60 <cpu>
  102da6:	89 04 24             	mov    %eax,(%esp)
  102da9:	e8 32 fb ff ff       	call   1028e0 <lapic_init>
  setupsegs(0);
  102dae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102db5:	e8 c6 10 00 00       	call   103e80 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  102dba:	e8 a1 fd ff ff       	call   102b60 <cpu>
  102dbf:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  102dca:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  102dd0:	f0 87 82 20 bd 10 00 	lock xchg %eax,0x10bd20(%edx)

  //log_open(O_RDONLY);

  cprintf("cpu%d: scheduling\n", cpu());
  102dd7:	e8 84 fd ff ff       	call   102b60 <cpu>
  102ddc:	c7 04 24 54 6f 10 00 	movl   $0x106f54,(%esp)
  102de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de7:	e8 d4 d9 ff ff       	call   1007c0 <cprintf>
  scheduler();
  102dec:	e8 6f 12 00 00       	call   104060 <scheduler>
  102df1:	eb 0d                	jmp    102e00 <main>
  102df3:	90                   	nop
  102df4:	90                   	nop
  102df5:	90                   	nop
  102df6:	90                   	nop
  102df7:	90                   	nop
  102df8:	90                   	nop
  102df9:	90                   	nop
  102dfa:	90                   	nop
  102dfb:	90                   	nop
  102dfc:	90                   	nop
  102dfd:	90                   	nop
  102dfe:	90                   	nop
  102dff:	90                   	nop

00102e00 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102e00:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102e01:	b8 24 f3 10 00       	mov    $0x10f324,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102e06:	89 e5                	mov    %esp,%ebp
  102e08:	83 e4 f0             	and    $0xfffffff0,%esp
  102e0b:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102e0c:	2d ee 89 10 00       	sub    $0x1089ee,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102e11:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102e14:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102e1f:	00 
  102e20:	c7 04 24 ee 89 10 00 	movl   $0x1089ee,(%esp)
  102e27:	e8 34 1b 00 00       	call   104960 <memset>

  mp_init(); // collect info about this machine
  102e2c:	e8 bf 01 00 00       	call   102ff0 <mp_init>
  lapic_init(mp_bcpu());
  102e31:	e8 2a 01 00 00       	call   102f60 <mp_bcpu>
  102e36:	89 04 24             	mov    %eax,(%esp)
  102e39:	e8 a2 fa ff ff       	call   1028e0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102e3e:	e8 1d fd ff ff       	call   102b60 <cpu>
  102e43:	c7 04 24 67 6f 10 00 	movl   $0x106f67,(%esp)
  102e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e4e:	e8 6d d9 ff ff       	call   1007c0 <cprintf>

  pinit();         // process table
  102e53:	e8 b8 18 00 00       	call   104710 <pinit>
  binit();         // buffer cache
  102e58:	e8 b3 d3 ff ff       	call   100210 <binit>
  102e5d:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  102e60:	e8 8b 03 00 00       	call   1031f0 <pic_init>
  ioapic_init();   // another interrupt controller
  102e65:	e8 b6 f6 ff ff       	call   102520 <ioapic_init>
  kinit();         // physical memory allocator
  102e6a:	e8 31 f9 ff ff       	call   1027a0 <kinit>
  102e6f:	90                   	nop
  tvinit();        // trap vectors
  102e70:	e8 2b 31 00 00       	call   105fa0 <tvinit>
  fileinit();      // file table
  102e75:	e8 46 e3 ff ff       	call   1011c0 <fileinit>
  iinit();         // inode cache
  102e7a:	e8 a1 f3 ff ff       	call   102220 <iinit>
  102e7f:	90                   	nop
  console_init();  // I/O devices & their interrupts
  102e80:	e8 fb d3 ff ff       	call   100280 <console_init>
  ide_init();      // disk
  102e85:	e8 c6 f5 ff ff       	call   102450 <ide_init>
  if(!ismp)
  102e8a:	a1 00 bd 10 00       	mov    0x10bd00,%eax
  102e8f:	85 c0                	test   %eax,%eax
  102e91:	0f 84 b1 00 00 00    	je     102f48 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102e97:	e8 84 17 00 00       	call   104620 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102e9c:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102ea3:	00 
  102ea4:	c7 44 24 04 94 89 10 	movl   $0x108994,0x4(%esp)
  102eab:	00 
  102eac:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102eb3:	e8 38 1b 00 00       	call   1049f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102eb8:	69 05 80 c3 10 00 cc 	imul   $0xcc,0x10c380,%eax
  102ebf:	00 00 00 
  102ec2:	05 20 bd 10 00       	add    $0x10bd20,%eax
  102ec7:	3d 20 bd 10 00       	cmp    $0x10bd20,%eax
  102ecc:	76 75                	jbe    102f43 <main+0x143>
  102ece:	bb 20 bd 10 00       	mov    $0x10bd20,%ebx
  102ed3:	90                   	nop
  102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102ed8:	e8 83 fc ff ff       	call   102b60 <cpu>
  102edd:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102ee3:	05 20 bd 10 00       	add    $0x10bd20,%eax
  102ee8:	39 c3                	cmp    %eax,%ebx
  102eea:	74 3e                	je     102f2a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102eec:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102ef3:	e8 d8 f6 ff ff       	call   1025d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102ef8:	c7 05 f8 6f 00 00 70 	movl   $0x102d70,0x6ff8
  102eff:	2d 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102f02:	05 00 10 00 00       	add    $0x1000,%eax
  102f07:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102f0c:	0f b6 03             	movzbl (%ebx),%eax
  102f0f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102f16:	00 
  102f17:	89 04 24             	mov    %eax,(%esp)
  102f1a:	e8 d1 fa ff ff       	call   1029f0 <lapic_startap>
  102f1f:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102f20:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102f26:	85 c0                	test   %eax,%eax
  102f28:	74 f6                	je     102f20 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102f2a:	69 05 80 c3 10 00 cc 	imul   $0xcc,0x10c380,%eax
  102f31:	00 00 00 
  102f34:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102f3a:	05 20 bd 10 00       	add    $0x10bd20,%eax
  102f3f:	39 c3                	cmp    %eax,%ebx
  102f41:	72 95                	jb     102ed8 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102f43:	e8 28 fe ff ff       	call   102d70 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102f48:	e8 43 2d 00 00       	call   105c90 <timer_init>
  102f4d:	8d 76 00             	lea    0x0(%esi),%esi
  102f50:	e9 42 ff ff ff       	jmp    102e97 <main+0x97>
  102f55:	90                   	nop
  102f56:	90                   	nop
  102f57:	90                   	nop
  102f58:	90                   	nop
  102f59:	90                   	nop
  102f5a:	90                   	nop
  102f5b:	90                   	nop
  102f5c:	90                   	nop
  102f5d:	90                   	nop
  102f5e:	90                   	nop
  102f5f:	90                   	nop

00102f60 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102f60:	a1 a4 8a 10 00       	mov    0x108aa4,%eax
  102f65:	55                   	push   %ebp
  102f66:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102f68:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102f69:	2d 20 bd 10 00       	sub    $0x10bd20,%eax
  102f6e:	c1 f8 02             	sar    $0x2,%eax
  102f71:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  102f77:	c3                   	ret    
  102f78:	90                   	nop
  102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102f80 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102f80:	55                   	push   %ebp
  102f81:	89 e5                	mov    %esp,%ebp
  102f83:	56                   	push   %esi
  102f84:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102f85:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102f88:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102f8b:	39 f0                	cmp    %esi,%eax
  102f8d:	73 42                	jae    102fd1 <mp_search1+0x51>
  102f8f:	89 c3                	mov    %eax,%ebx
  102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102f98:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102f9f:	00 
  102fa0:	c7 44 24 04 7e 6f 10 	movl   $0x106f7e,0x4(%esp)
  102fa7:	00 
  102fa8:	89 1c 24             	mov    %ebx,(%esp)
  102fab:	e8 e0 19 00 00       	call   104990 <memcmp>
  102fb0:	85 c0                	test   %eax,%eax
  102fb2:	75 16                	jne    102fca <mp_search1+0x4a>
  102fb4:	31 d2                	xor    %edx,%edx
  102fb6:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102fb8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102fbc:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102fbf:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102fc1:	83 f8 10             	cmp    $0x10,%eax
  102fc4:	75 f2                	jne    102fb8 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102fc6:	84 d2                	test   %dl,%dl
  102fc8:	74 10                	je     102fda <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102fca:	83 c3 10             	add    $0x10,%ebx
  102fcd:	39 de                	cmp    %ebx,%esi
  102fcf:	77 c7                	ja     102f98 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102fd1:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102fd4:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102fd6:	5b                   	pop    %ebx
  102fd7:	5e                   	pop    %esi
  102fd8:	5d                   	pop    %ebp
  102fd9:	c3                   	ret    
  102fda:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102fdd:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102fdf:	5b                   	pop    %ebx
  102fe0:	5e                   	pop    %esi
  102fe1:	5d                   	pop    %ebp
  102fe2:	c3                   	ret    
  102fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ff0 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102ff0:	55                   	push   %ebp
  102ff1:	89 e5                	mov    %esp,%ebp
  102ff3:	57                   	push   %edi
  102ff4:	56                   	push   %esi
  102ff5:	53                   	push   %ebx
  102ff6:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102ff9:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  103000:	69 05 80 c3 10 00 cc 	imul   $0xcc,0x10c380,%eax
  103007:	00 00 00 
  10300a:	05 20 bd 10 00       	add    $0x10bd20,%eax
  10300f:	a3 a4 8a 10 00       	mov    %eax,0x108aa4
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  103014:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  10301b:	c1 e0 08             	shl    $0x8,%eax
  10301e:	09 d0                	or     %edx,%eax
  103020:	c1 e0 04             	shl    $0x4,%eax
  103023:	85 c0                	test   %eax,%eax
  103025:	75 1b                	jne    103042 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  103027:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  10302e:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  103035:	c1 e0 08             	shl    $0x8,%eax
  103038:	09 d0                	or     %edx,%eax
  10303a:	c1 e0 0a             	shl    $0xa,%eax
  10303d:	2d 00 04 00 00       	sub    $0x400,%eax
  103042:	ba 00 04 00 00       	mov    $0x400,%edx
  103047:	e8 34 ff ff ff       	call   102f80 <mp_search1>
  10304c:	85 c0                	test   %eax,%eax
  10304e:	89 c3                	mov    %eax,%ebx
  103050:	0f 84 b2 00 00 00    	je     103108 <mp_init+0x118>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103056:	8b 73 04             	mov    0x4(%ebx),%esi
  103059:	85 f6                	test   %esi,%esi
  10305b:	75 0b                	jne    103068 <mp_init+0x78>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  10305d:	83 c4 2c             	add    $0x2c,%esp
  103060:	5b                   	pop    %ebx
  103061:	5e                   	pop    %esi
  103062:	5f                   	pop    %edi
  103063:	5d                   	pop    %ebp
  103064:	c3                   	ret    
  103065:	8d 76 00             	lea    0x0(%esi),%esi
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  103068:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  10306f:	00 
  103070:	c7 44 24 04 83 6f 10 	movl   $0x106f83,0x4(%esp)
  103077:	00 
  103078:	89 34 24             	mov    %esi,(%esp)
  10307b:	e8 10 19 00 00       	call   104990 <memcmp>
  103080:	85 c0                	test   %eax,%eax
  103082:	75 d9                	jne    10305d <mp_init+0x6d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  103084:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  103088:	3c 04                	cmp    $0x4,%al
  10308a:	74 06                	je     103092 <mp_init+0xa2>
  10308c:	3c 01                	cmp    $0x1,%al
  10308e:	66 90                	xchg   %ax,%ax
  103090:	75 cb                	jne    10305d <mp_init+0x6d>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  103092:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103096:	85 d2                	test   %edx,%edx
  103098:	74 15                	je     1030af <mp_init+0xbf>
  10309a:	31 c9                	xor    %ecx,%ecx
  10309c:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  10309e:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1030a2:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  1030a5:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  1030a7:	39 c2                	cmp    %eax,%edx
  1030a9:	7f f3                	jg     10309e <mp_init+0xae>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  1030ab:	84 c9                	test   %cl,%cl
  1030ad:	75 ae                	jne    10305d <mp_init+0x6d>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  1030af:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  1030b2:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  1030b5:	c7 05 00 bd 10 00 01 	movl   $0x1,0x10bd00
  1030bc:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  1030bf:	a3 f8 bc 10 00       	mov    %eax,0x10bcf8

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  1030c4:	8d 46 2c             	lea    0x2c(%esi),%eax
  1030c7:	39 d0                	cmp    %edx,%eax
  1030c9:	0f 83 81 00 00 00    	jae    103150 <mp_init+0x160>
  1030cf:	8b 35 a4 8a 10 00    	mov    0x108aa4,%esi
  1030d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  1030d8:	0f b6 08             	movzbl (%eax),%ecx
  1030db:	80 f9 04             	cmp    $0x4,%cl
  1030de:	76 50                	jbe    103130 <mp_init+0x140>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  1030e0:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  1030e3:	89 35 a4 8a 10 00    	mov    %esi,0x108aa4
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  1030e9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1030ed:	c7 04 24 90 6f 10 00 	movl   $0x106f90,(%esp)
  1030f4:	e8 c7 d6 ff ff       	call   1007c0 <cprintf>
      panic("mp_init");
  1030f9:	c7 04 24 88 6f 10 00 	movl   $0x106f88,(%esp)
  103100:	e8 5b d8 ff ff       	call   100960 <panic>
  103105:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103108:	ba 00 00 01 00       	mov    $0x10000,%edx
  10310d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  103112:	e8 69 fe ff ff       	call   102f80 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103117:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103119:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  10311b:	0f 85 35 ff ff ff    	jne    103056 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  103121:	83 c4 2c             	add    $0x2c,%esp
  103124:	5b                   	pop    %ebx
  103125:	5e                   	pop    %esi
  103126:	5f                   	pop    %edi
  103127:	5d                   	pop    %ebp
  103128:	c3                   	ret    
  103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  103130:	0f b6 c9             	movzbl %cl,%ecx
  103133:	ff 24 8d b4 6f 10 00 	jmp    *0x106fb4(,%ecx,4)
  10313a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  103140:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103143:	39 c2                	cmp    %eax,%edx
  103145:	77 91                	ja     1030d8 <mp_init+0xe8>
  103147:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10314a:	89 35 a4 8a 10 00    	mov    %esi,0x108aa4
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  103150:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  103154:	0f 84 03 ff ff ff    	je     10305d <mp_init+0x6d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10315a:	ba 22 00 00 00       	mov    $0x22,%edx
  10315f:	b8 70 00 00 00       	mov    $0x70,%eax
  103164:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103165:	b2 23                	mov    $0x23,%dl
  103167:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103168:	83 c8 01             	or     $0x1,%eax
  10316b:	ee                   	out    %al,(%dx)
  10316c:	e9 ec fe ff ff       	jmp    10305d <mp_init+0x6d>
  103171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103178:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  10317c:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  10317f:	88 0d 04 bd 10 00    	mov    %cl,0x10bd04
      p += sizeof(struct mpioapic);
      continue;
  103185:	eb bc                	jmp    103143 <mp_init+0x153>
  103187:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  103188:	8b 0d 80 c3 10 00    	mov    0x10c380,%ecx
  10318e:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  103192:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  103198:	88 9f 20 bd 10 00    	mov    %bl,0x10bd20(%edi)
      if(proc->flags & MPBOOT)
  10319e:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  1031a2:	74 06                	je     1031aa <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  1031a4:	8d b7 20 bd 10 00    	lea    0x10bd20(%edi),%esi
      ncpu++;
  1031aa:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  1031ad:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  1031b0:	89 0d 80 c3 10 00    	mov    %ecx,0x10c380
      p += sizeof(struct mpproc);
      continue;
  1031b6:	eb 8b                	jmp    103143 <mp_init+0x153>
  1031b8:	90                   	nop
  1031b9:	90                   	nop
  1031ba:	90                   	nop
  1031bb:	90                   	nop
  1031bc:	90                   	nop
  1031bd:	90                   	nop
  1031be:	90                   	nop
  1031bf:	90                   	nop

001031c0 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  1031c0:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  1031c1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  1031c6:	89 e5                	mov    %esp,%ebp
  1031c8:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  1031cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1031d0:	d3 c0                	rol    %cl,%eax
  1031d2:	66 23 05 60 85 10 00 	and    0x108560,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  1031d9:	66 a3 60 85 10 00    	mov    %ax,0x108560
  1031df:	ee                   	out    %al,(%dx)
  1031e0:	66 c1 e8 08          	shr    $0x8,%ax
  1031e4:	b2 a1                	mov    $0xa1,%dl
  1031e6:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  1031e7:	5d                   	pop    %ebp
  1031e8:	c3                   	ret    
  1031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001031f0 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  1031f0:	55                   	push   %ebp
  1031f1:	b9 21 00 00 00       	mov    $0x21,%ecx
  1031f6:	89 e5                	mov    %esp,%ebp
  1031f8:	83 ec 0c             	sub    $0xc,%esp
  1031fb:	89 1c 24             	mov    %ebx,(%esp)
  1031fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103203:	89 ca                	mov    %ecx,%edx
  103205:	89 74 24 04          	mov    %esi,0x4(%esp)
  103209:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10320d:	ee                   	out    %al,(%dx)
  10320e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  103213:	89 da                	mov    %ebx,%edx
  103215:	ee                   	out    %al,(%dx)
  103216:	be 11 00 00 00       	mov    $0x11,%esi
  10321b:	b2 20                	mov    $0x20,%dl
  10321d:	89 f0                	mov    %esi,%eax
  10321f:	ee                   	out    %al,(%dx)
  103220:	b8 20 00 00 00       	mov    $0x20,%eax
  103225:	89 ca                	mov    %ecx,%edx
  103227:	ee                   	out    %al,(%dx)
  103228:	b8 04 00 00 00       	mov    $0x4,%eax
  10322d:	ee                   	out    %al,(%dx)
  10322e:	bf 03 00 00 00       	mov    $0x3,%edi
  103233:	89 f8                	mov    %edi,%eax
  103235:	ee                   	out    %al,(%dx)
  103236:	b1 a0                	mov    $0xa0,%cl
  103238:	89 f0                	mov    %esi,%eax
  10323a:	89 ca                	mov    %ecx,%edx
  10323c:	ee                   	out    %al,(%dx)
  10323d:	b8 28 00 00 00       	mov    $0x28,%eax
  103242:	89 da                	mov    %ebx,%edx
  103244:	ee                   	out    %al,(%dx)
  103245:	b8 02 00 00 00       	mov    $0x2,%eax
  10324a:	ee                   	out    %al,(%dx)
  10324b:	89 f8                	mov    %edi,%eax
  10324d:	ee                   	out    %al,(%dx)
  10324e:	be 68 00 00 00       	mov    $0x68,%esi
  103253:	b2 20                	mov    $0x20,%dl
  103255:	89 f0                	mov    %esi,%eax
  103257:	ee                   	out    %al,(%dx)
  103258:	bb 0a 00 00 00       	mov    $0xa,%ebx
  10325d:	89 d8                	mov    %ebx,%eax
  10325f:	ee                   	out    %al,(%dx)
  103260:	89 f0                	mov    %esi,%eax
  103262:	89 ca                	mov    %ecx,%edx
  103264:	ee                   	out    %al,(%dx)
  103265:	89 d8                	mov    %ebx,%eax
  103267:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  103268:	0f b7 05 60 85 10 00 	movzwl 0x108560,%eax
  10326f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  103273:	74 0a                	je     10327f <pic_init+0x8f>
  103275:	b2 21                	mov    $0x21,%dl
  103277:	ee                   	out    %al,(%dx)
  103278:	66 c1 e8 08          	shr    $0x8,%ax
  10327c:	b2 a1                	mov    $0xa1,%dl
  10327e:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  10327f:	8b 1c 24             	mov    (%esp),%ebx
  103282:	8b 74 24 04          	mov    0x4(%esp),%esi
  103286:	8b 7c 24 08          	mov    0x8(%esp),%edi
  10328a:	89 ec                	mov    %ebp,%esp
  10328c:	5d                   	pop    %ebp
  10328d:	c3                   	ret    
  10328e:	90                   	nop
  10328f:	90                   	nop

00103290 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	57                   	push   %edi
  103294:	56                   	push   %esi
  103295:	53                   	push   %ebx
  103296:	83 ec 2c             	sub    $0x2c,%esp
  103299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  10329c:	8d 73 10             	lea    0x10(%ebx),%esi
  10329f:	89 34 24             	mov    %esi,(%esp)
  1032a2:	e8 49 16 00 00       	call   1048f0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  1032a7:	8b 53 0c             	mov    0xc(%ebx),%edx
  1032aa:	3b 53 08             	cmp    0x8(%ebx),%edx
  1032ad:	75 51                	jne    103300 <piperead+0x70>
  1032af:	8b 4b 04             	mov    0x4(%ebx),%ecx
  1032b2:	85 c9                	test   %ecx,%ecx
  1032b4:	74 4a                	je     103300 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  1032b6:	8d 7b 0c             	lea    0xc(%ebx),%edi
  1032b9:	eb 20                	jmp    1032db <piperead+0x4b>
  1032bb:	90                   	nop
  1032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1032c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  1032c4:	89 3c 24             	mov    %edi,(%esp)
  1032c7:	e8 94 08 00 00       	call   103b60 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  1032cc:	8b 53 0c             	mov    0xc(%ebx),%edx
  1032cf:	3b 53 08             	cmp    0x8(%ebx),%edx
  1032d2:	75 2c                	jne    103300 <piperead+0x70>
  1032d4:	8b 43 04             	mov    0x4(%ebx),%eax
  1032d7:	85 c0                	test   %eax,%eax
  1032d9:	74 25                	je     103300 <piperead+0x70>
    if(cp->killed){
  1032db:	e8 d0 05 00 00       	call   1038b0 <curproc>
  1032e0:	8b 40 1c             	mov    0x1c(%eax),%eax
  1032e3:	85 c0                	test   %eax,%eax
  1032e5:	74 d9                	je     1032c0 <piperead+0x30>
      release(&p->lock);
  1032e7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  1032ec:	89 34 24             	mov    %esi,(%esp)
  1032ef:	e8 bc 15 00 00       	call   1048b0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  1032f4:	83 c4 2c             	add    $0x2c,%esp
  1032f7:	89 f8                	mov    %edi,%eax
  1032f9:	5b                   	pop    %ebx
  1032fa:	5e                   	pop    %esi
  1032fb:	5f                   	pop    %edi
  1032fc:	5d                   	pop    %ebp
  1032fd:	c3                   	ret    
  1032fe:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103300:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103303:	85 c9                	test   %ecx,%ecx
  103305:	7e 5a                	jle    103361 <piperead+0xd1>
    if(p->readp == p->writep)
  103307:	31 ff                	xor    %edi,%edi
  103309:	3b 53 08             	cmp    0x8(%ebx),%edx
  10330c:	74 53                	je     103361 <piperead+0xd1>
  10330e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  103311:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103314:	8b 75 10             	mov    0x10(%ebp),%esi
  103317:	eb 0c                	jmp    103325 <piperead+0x95>
  103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103320:	39 53 08             	cmp    %edx,0x8(%ebx)
  103323:	74 1c                	je     103341 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103325:	89 d0                	mov    %edx,%eax
  103327:	83 c2 01             	add    $0x1,%edx
  10332a:	25 ff 01 00 00       	and    $0x1ff,%eax
  10332f:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  103334:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103337:	83 c7 01             	add    $0x1,%edi
  10333a:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  10333c:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10333f:	7f df                	jg     103320 <piperead+0x90>
  103341:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  103344:	83 c3 08             	add    $0x8,%ebx
  103347:	89 1c 24             	mov    %ebx,(%esp)
  10334a:	e8 61 04 00 00       	call   1037b0 <wakeup>
  release(&p->lock);
  10334f:	89 34 24             	mov    %esi,(%esp)
  103352:	e8 59 15 00 00       	call   1048b0 <release>
  return i;
}
  103357:	83 c4 2c             	add    $0x2c,%esp
  10335a:	89 f8                	mov    %edi,%eax
  10335c:	5b                   	pop    %ebx
  10335d:	5e                   	pop    %esi
  10335e:	5f                   	pop    %edi
  10335f:	5d                   	pop    %ebp
  103360:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103361:	31 ff                	xor    %edi,%edi
  103363:	eb df                	jmp    103344 <piperead+0xb4>
  103365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103370 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  103370:	55                   	push   %ebp
  103371:	89 e5                	mov    %esp,%ebp
  103373:	57                   	push   %edi
  103374:	56                   	push   %esi
  103375:	53                   	push   %ebx
  103376:	83 ec 3c             	sub    $0x3c,%esp
  103379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  10337c:	8d 73 10             	lea    0x10(%ebx),%esi
  10337f:	89 34 24             	mov    %esi,(%esp)
  103382:	e8 69 15 00 00       	call   1048f0 <acquire>
  for(i = 0; i < n; i++){
  103387:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10338a:	85 c9                	test   %ecx,%ecx
  10338c:	0f 8e d0 00 00 00    	jle    103462 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103392:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103395:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103398:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10339b:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  10339e:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  1033a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1033a8:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1033ab:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  1033b1:	39 c8                	cmp    %ecx,%eax
  1033b3:	75 66                	jne    10341b <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  1033b5:	8b 3b                	mov    (%ebx),%edi
  1033b7:	85 ff                	test   %edi,%edi
  1033b9:	74 3e                	je     1033f9 <pipewrite+0x89>
  1033bb:	8b 7d d0             	mov    -0x30(%ebp),%edi
  1033be:	eb 2d                	jmp    1033ed <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1033c0:	89 3c 24             	mov    %edi,(%esp)
  1033c3:	e8 e8 03 00 00       	call   1037b0 <wakeup>
      sleep(&p->writep, &p->lock);
  1033c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1033cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  1033cf:	89 0c 24             	mov    %ecx,(%esp)
  1033d2:	e8 89 07 00 00       	call   103b60 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1033d7:	8b 53 0c             	mov    0xc(%ebx),%edx
  1033da:	8b 43 08             	mov    0x8(%ebx),%eax
  1033dd:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  1033e3:	39 c8                	cmp    %ecx,%eax
  1033e5:	75 31                	jne    103418 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  1033e7:	8b 13                	mov    (%ebx),%edx
  1033e9:	85 d2                	test   %edx,%edx
  1033eb:	74 0c                	je     1033f9 <pipewrite+0x89>
  1033ed:	e8 be 04 00 00       	call   1038b0 <curproc>
  1033f2:	8b 40 1c             	mov    0x1c(%eax),%eax
  1033f5:	85 c0                	test   %eax,%eax
  1033f7:	74 c7                	je     1033c0 <pipewrite+0x50>
        release(&p->lock);
  1033f9:	89 34 24             	mov    %esi,(%esp)
  1033fc:	e8 af 14 00 00       	call   1048b0 <release>
  103401:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  103408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10340b:	83 c4 3c             	add    $0x3c,%esp
  10340e:	5b                   	pop    %ebx
  10340f:	5e                   	pop    %esi
  103410:	5f                   	pop    %edi
  103411:	5d                   	pop    %ebp
  103412:	c3                   	ret    
  103413:	90                   	nop
  103414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103418:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10341b:	89 c7                	mov    %eax,%edi
  10341d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103420:	83 c0 01             	add    $0x1,%eax
  103423:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  103429:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  10342c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10342f:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  103433:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103436:	89 43 08             	mov    %eax,0x8(%ebx)
  103439:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10343d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  103441:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103444:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  103447:	0f 8f 5e ff ff ff    	jg     1033ab <pipewrite+0x3b>
  10344d:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103450:	89 3c 24             	mov    %edi,(%esp)
  103453:	e8 58 03 00 00       	call   1037b0 <wakeup>
  release(&p->lock);
  103458:	89 34 24             	mov    %esi,(%esp)
  10345b:	e8 50 14 00 00       	call   1048b0 <release>
  return i;
  103460:	eb a6                	jmp    103408 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  103462:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103469:	8d 7b 0c             	lea    0xc(%ebx),%edi
  10346c:	eb e2                	jmp    103450 <pipewrite+0xe0>
  10346e:	66 90                	xchg   %ax,%ax

00103470 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  103470:	55                   	push   %ebp
  103471:	89 e5                	mov    %esp,%ebp
  103473:	83 ec 28             	sub    $0x28,%esp
  103476:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10347c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10347f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103482:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  103485:	8d 73 10             	lea    0x10(%ebx),%esi
  103488:	89 34 24             	mov    %esi,(%esp)
  10348b:	e8 60 14 00 00       	call   1048f0 <acquire>
  if(writable){
  103490:	85 ff                	test   %edi,%edi
  103492:	74 34                	je     1034c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  103494:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  103497:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  10349e:	89 04 24             	mov    %eax,(%esp)
  1034a1:	e8 0a 03 00 00       	call   1037b0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1034a6:	89 34 24             	mov    %esi,(%esp)
  1034a9:	e8 02 14 00 00       	call   1048b0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1034ae:	8b 3b                	mov    (%ebx),%edi
  1034b0:	85 ff                	test   %edi,%edi
  1034b2:	75 07                	jne    1034bb <pipeclose+0x4b>
  1034b4:	8b 73 04             	mov    0x4(%ebx),%esi
  1034b7:	85 f6                	test   %esi,%esi
  1034b9:	74 25                	je     1034e0 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1034bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1034be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1034c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1034c4:	89 ec                	mov    %ebp,%esp
  1034c6:	5d                   	pop    %ebp
  1034c7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  1034c8:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  1034cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  1034d1:	89 04 24             	mov    %eax,(%esp)
  1034d4:	e8 d7 02 00 00       	call   1037b0 <wakeup>
  1034d9:	eb cb                	jmp    1034a6 <pipeclose+0x36>
  1034db:	90                   	nop
  1034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1034e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  1034e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1034e6:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  1034ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1034f0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1034f3:	89 ec                	mov    %ebp,%esp
  1034f5:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1034f6:	e9 95 f1 ff ff       	jmp    102690 <kfree>
  1034fb:	90                   	nop
  1034fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103500 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103500:	55                   	push   %ebp
  103501:	89 e5                	mov    %esp,%ebp
  103503:	57                   	push   %edi
  103504:	56                   	push   %esi
  103505:	53                   	push   %ebx
  103506:	83 ec 1c             	sub    $0x1c,%esp
  103509:	8b 75 08             	mov    0x8(%ebp),%esi
  10350c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  10350f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  103515:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  10351b:	e8 30 db ff ff       	call   101050 <filealloc>
  103520:	85 c0                	test   %eax,%eax
  103522:	89 06                	mov    %eax,(%esi)
  103524:	0f 84 92 00 00 00    	je     1035bc <pipealloc+0xbc>
  10352a:	e8 21 db ff ff       	call   101050 <filealloc>
  10352f:	85 c0                	test   %eax,%eax
  103531:	89 03                	mov    %eax,(%ebx)
  103533:	74 73                	je     1035a8 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  103535:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  10353c:	e8 8f f0 ff ff       	call   1025d0 <kalloc>
  103541:	85 c0                	test   %eax,%eax
  103543:	89 c7                	mov    %eax,%edi
  103545:	74 61                	je     1035a8 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  103547:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  10354d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  103554:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  10355b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  103562:	8d 40 10             	lea    0x10(%eax),%eax
  103565:	89 04 24             	mov    %eax,(%esp)
  103568:	c7 44 24 04 c8 6f 10 	movl   $0x106fc8,0x4(%esp)
  10356f:	00 
  103570:	e8 bb 11 00 00       	call   104730 <initlock>
  (*f0)->type = FD_PIPE;
  103575:	8b 06                	mov    (%esi),%eax
  103577:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  10357d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  103581:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  103585:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  103588:	8b 03                	mov    (%ebx),%eax
  10358a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  103590:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  103594:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  103598:	89 78 0c             	mov    %edi,0xc(%eax)
  10359b:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  10359d:	83 c4 1c             	add    $0x1c,%esp
  1035a0:	5b                   	pop    %ebx
  1035a1:	5e                   	pop    %esi
  1035a2:	5f                   	pop    %edi
  1035a3:	5d                   	pop    %ebp
  1035a4:	c3                   	ret    
  1035a5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1035a8:	8b 06                	mov    (%esi),%eax
  1035aa:	85 c0                	test   %eax,%eax
  1035ac:	74 0e                	je     1035bc <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  1035ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1035b4:	89 04 24             	mov    %eax,(%esp)
  1035b7:	e8 24 db ff ff       	call   1010e0 <fileclose>
  }
  if(*f1){
  1035bc:	8b 13                	mov    (%ebx),%edx
  1035be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1035c3:	85 d2                	test   %edx,%edx
  1035c5:	74 d6                	je     10359d <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  1035c7:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  1035cd:	89 14 24             	mov    %edx,(%esp)
  1035d0:	e8 0b db ff ff       	call   1010e0 <fileclose>
  1035d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1035da:	eb c1                	jmp    10359d <pipealloc+0x9d>
  1035dc:	90                   	nop
  1035dd:	90                   	nop
  1035de:	90                   	nop
  1035df:	90                   	nop

001035e0 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  1035e0:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035e1:	b8 a0 ea 10 00       	mov    $0x10eaa0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  1035e6:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035e8:	3d a0 c3 10 00       	cmp    $0x10c3a0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  1035ed:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035f0:	76 3e                	jbe    103630 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  1035f2:	b8 a0 c3 10 00       	mov    $0x10c3a0,%eax
  1035f7:	eb 13                	jmp    10360c <wake_lock+0x2c>
  1035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103600:	05 9c 00 00 00       	add    $0x9c,%eax
  103605:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  10360a:	74 24                	je     103630 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  10360c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103610:	75 ee                	jne    103600 <wake_lock+0x20>
  103612:	39 50 10             	cmp    %edx,0x10(%eax)
  103615:	75 e9                	jne    103600 <wake_lock+0x20>
			p->state = RUNNABLE;
  103617:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10361e:	05 9c 00 00 00       	add    $0x9c,%eax
  103623:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  103628:	75 e2                	jne    10360c <wake_lock+0x2c>
  10362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  103630:	5d                   	pop    %ebp
  103631:	c3                   	ret    
  103632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103640 <tick>:
  }
}

int
tick(void)
{
  103640:	55                   	push   %ebp
return ticks;
}
  103641:	a1 20 f3 10 00       	mov    0x10f320,%eax
  }
}

int
tick(void)
{
  103646:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103648:	5d                   	pop    %ebp
  103649:	c3                   	ret    
  10364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103650 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103650:	55                   	push   %ebp
  103651:	89 e5                	mov    %esp,%ebp
  103653:	57                   	push   %edi
  103654:	56                   	push   %esi
  103655:	53                   	push   %ebx
  103656:	bb ac c3 10 00       	mov    $0x10c3ac,%ebx
  10365b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10365e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103661:	eb 50                	jmp    1036b3 <procdump+0x63>
  103663:	90                   	nop
  103664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103668:	8b 04 85 90 70 10 00 	mov    0x107090(,%eax,4),%eax
  10366f:	85 c0                	test   %eax,%eax
  103671:	74 4e                	je     1036c1 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103673:	89 44 24 08          	mov    %eax,0x8(%esp)
  103677:	8b 43 04             	mov    0x4(%ebx),%eax
  10367a:	81 c2 88 00 00 00    	add    $0x88,%edx
  103680:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103684:	c7 04 24 d1 6f 10 00 	movl   $0x106fd1,(%esp)
  10368b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10368f:	e8 2c d1 ff ff       	call   1007c0 <cprintf>
    if(p->state == SLEEPING){
  103694:	83 3b 02             	cmpl   $0x2,(%ebx)
  103697:	74 2f                	je     1036c8 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103699:	c7 04 24 7c 6f 10 00 	movl   $0x106f7c,(%esp)
  1036a0:	e8 1b d1 ff ff       	call   1007c0 <cprintf>
  1036a5:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1036ab:	81 fb ac ea 10 00    	cmp    $0x10eaac,%ebx
  1036b1:	74 55                	je     103708 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  1036b3:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  1036b5:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1036b8:	85 c0                	test   %eax,%eax
  1036ba:	74 e9                	je     1036a5 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1036bc:	83 f8 05             	cmp    $0x5,%eax
  1036bf:	76 a7                	jbe    103668 <procdump+0x18>
  1036c1:	b8 cd 6f 10 00       	mov    $0x106fcd,%eax
  1036c6:	eb ab                	jmp    103673 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1036c8:	8b 43 74             	mov    0x74(%ebx),%eax
  1036cb:	31 f6                	xor    %esi,%esi
  1036cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1036d1:	83 c0 08             	add    $0x8,%eax
  1036d4:	89 04 24             	mov    %eax,(%esp)
  1036d7:	e8 74 10 00 00       	call   104750 <getcallerpcs>
  1036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1036e0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  1036e3:	85 c0                	test   %eax,%eax
  1036e5:	74 b2                	je     103699 <procdump+0x49>
  1036e7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  1036ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036ee:	c7 04 24 f5 6a 10 00 	movl   $0x106af5,(%esp)
  1036f5:	e8 c6 d0 ff ff       	call   1007c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  1036fa:	83 fe 0a             	cmp    $0xa,%esi
  1036fd:	75 e1                	jne    1036e0 <procdump+0x90>
  1036ff:	eb 98                	jmp    103699 <procdump+0x49>
  103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103708:	83 c4 4c             	add    $0x4c,%esp
  10370b:	5b                   	pop    %ebx
  10370c:	5e                   	pop    %esi
  10370d:	5f                   	pop    %edi
  10370e:	5d                   	pop    %ebp
  10370f:	90                   	nop
  103710:	c3                   	ret    
  103711:	eb 0d                	jmp    103720 <kill>
  103713:	90                   	nop
  103714:	90                   	nop
  103715:	90                   	nop
  103716:	90                   	nop
  103717:	90                   	nop
  103718:	90                   	nop
  103719:	90                   	nop
  10371a:	90                   	nop
  10371b:	90                   	nop
  10371c:	90                   	nop
  10371d:	90                   	nop
  10371e:	90                   	nop
  10371f:	90                   	nop

00103720 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103720:	55                   	push   %ebp
  103721:	89 e5                	mov    %esp,%ebp
  103723:	53                   	push   %ebx
  103724:	83 ec 14             	sub    $0x14,%esp
  103727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10372a:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103731:	e8 ba 11 00 00       	call   1048f0 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103736:	b8 a0 ea 10 00       	mov    $0x10eaa0,%eax
  10373b:	3d a0 c3 10 00       	cmp    $0x10c3a0,%eax
  103740:	76 56                	jbe    103798 <kill+0x78>
    if(p->pid == pid){
  103742:	39 1d b0 c3 10 00    	cmp    %ebx,0x10c3b0

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103748:	b8 a0 c3 10 00       	mov    $0x10c3a0,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10374d:	74 12                	je     103761 <kill+0x41>
  10374f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  103750:	05 9c 00 00 00       	add    $0x9c,%eax
  103755:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  10375a:	74 3c                	je     103798 <kill+0x78>
    if(p->pid == pid){
  10375c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10375f:	75 ef                	jne    103750 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103761:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103765:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10376c:	74 1a                	je     103788 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10376e:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103775:	e8 36 11 00 00       	call   1048b0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10377a:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10377d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10377f:	5b                   	pop    %ebx
  103780:	5d                   	pop    %ebp
  103781:	c3                   	ret    
  103782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103788:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  10378f:	eb dd                	jmp    10376e <kill+0x4e>
  103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103798:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  10379f:	e8 0c 11 00 00       	call   1048b0 <release>
  return -1;
}
  1037a4:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1037a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1037ac:	5b                   	pop    %ebx
  1037ad:	5d                   	pop    %ebp
  1037ae:	c3                   	ret    
  1037af:	90                   	nop

001037b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1037b0:	55                   	push   %ebp
  1037b1:	89 e5                	mov    %esp,%ebp
  1037b3:	53                   	push   %ebx
  1037b4:	83 ec 14             	sub    $0x14,%esp
  1037b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1037ba:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  1037c1:	e8 2a 11 00 00       	call   1048f0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1037c6:	b8 a0 ea 10 00       	mov    $0x10eaa0,%eax
  1037cb:	3d a0 c3 10 00       	cmp    $0x10c3a0,%eax
  1037d0:	76 3e                	jbe    103810 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1037d2:	b8 a0 c3 10 00       	mov    $0x10c3a0,%eax
  1037d7:	eb 13                	jmp    1037ec <wakeup+0x3c>
  1037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1037e0:	05 9c 00 00 00       	add    $0x9c,%eax
  1037e5:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  1037ea:	74 24                	je     103810 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  1037ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1037f0:	75 ee                	jne    1037e0 <wakeup+0x30>
  1037f2:	3b 58 18             	cmp    0x18(%eax),%ebx
  1037f5:	75 e9                	jne    1037e0 <wakeup+0x30>
      p->state = RUNNABLE;
  1037f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1037fe:	05 9c 00 00 00       	add    $0x9c,%eax
  103803:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  103808:	75 e2                	jne    1037ec <wakeup+0x3c>
  10380a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103810:	c7 45 08 a0 ea 10 00 	movl   $0x10eaa0,0x8(%ebp)
}
  103817:	83 c4 14             	add    $0x14,%esp
  10381a:	5b                   	pop    %ebx
  10381b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  10381c:	e9 8f 10 00 00       	jmp    1048b0 <release>
  103821:	eb 0d                	jmp    103830 <allocproc>
  103823:	90                   	nop
  103824:	90                   	nop
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

00103830 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103830:	55                   	push   %ebp
  103831:	89 e5                	mov    %esp,%ebp
  103833:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103834:	bb a0 c3 10 00       	mov    $0x10c3a0,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103839:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10383c:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103843:	e8 a8 10 00 00       	call   1048f0 <acquire>
  103848:	eb 14                	jmp    10385e <allocproc+0x2e>
  10384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103850:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103856:	81 fb a0 ea 10 00    	cmp    $0x10eaa0,%ebx
  10385c:	74 32                	je     103890 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10385e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103861:	85 c0                	test   %eax,%eax
  103863:	75 eb                	jne    103850 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103865:	a1 64 85 10 00       	mov    0x108564,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10386a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103871:	89 43 10             	mov    %eax,0x10(%ebx)
  103874:	83 c0 01             	add    $0x1,%eax
  103877:	a3 64 85 10 00       	mov    %eax,0x108564
      release(&proc_table_lock);
  10387c:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103883:	e8 28 10 00 00       	call   1048b0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  103888:	89 d8                	mov    %ebx,%eax
  10388a:	83 c4 14             	add    $0x14,%esp
  10388d:	5b                   	pop    %ebx
  10388e:	5d                   	pop    %ebp
  10388f:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103890:	31 db                	xor    %ebx,%ebx
  103892:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103899:	e8 12 10 00 00       	call   1048b0 <release>
  return 0;
}
  10389e:	89 d8                	mov    %ebx,%eax
  1038a0:	83 c4 14             	add    $0x14,%esp
  1038a3:	5b                   	pop    %ebx
  1038a4:	5d                   	pop    %ebp
  1038a5:	c3                   	ret    
  1038a6:	8d 76 00             	lea    0x0(%esi),%esi
  1038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001038b0 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  1038b0:	55                   	push   %ebp
  1038b1:	89 e5                	mov    %esp,%ebp
  1038b3:	53                   	push   %ebx
  1038b4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  1038b7:	e8 64 0f 00 00       	call   104820 <pushcli>
  p = cpus[cpu()].curproc;
  1038bc:	e8 9f f2 ff ff       	call   102b60 <cpu>
  1038c1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1038c7:	8b 98 24 bd 10 00    	mov    0x10bd24(%eax),%ebx
  popcli();
  1038cd:	e8 ce 0e 00 00       	call   1047a0 <popcli>
  return p;
}
  1038d2:	83 c4 04             	add    $0x4,%esp
  1038d5:	89 d8                	mov    %ebx,%eax
  1038d7:	5b                   	pop    %ebx
  1038d8:	5d                   	pop    %ebp
  1038d9:	c3                   	ret    
  1038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  1038e0:	55                   	push   %ebp
  1038e1:	89 e5                	mov    %esp,%ebp
  1038e3:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  1038e6:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  1038ed:	e8 be 0f 00 00       	call   1048b0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1038f2:	e8 b9 ff ff ff       	call   1038b0 <curproc>
  1038f7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1038fd:	89 04 24             	mov    %eax,(%esp)
  103900:	e8 d7 23 00 00       	call   105cdc <forkret1>
}
  103905:	c9                   	leave  
  103906:	c3                   	ret    
  103907:	89 f6                	mov    %esi,%esi
  103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103910 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103910:	55                   	push   %ebp
  103911:	89 e5                	mov    %esp,%ebp
  103913:	53                   	push   %ebx
  103914:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103917:	9c                   	pushf  
  103918:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103919:	f6 c4 02             	test   $0x2,%ah
  10391c:	75 5c                	jne    10397a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10391e:	e8 8d ff ff ff       	call   1038b0 <curproc>
  103923:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103927:	74 75                	je     10399e <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103929:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103930:	e8 3b 0f 00 00       	call   104870 <holding>
  103935:	85 c0                	test   %eax,%eax
  103937:	74 59                	je     103992 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103939:	e8 22 f2 ff ff       	call   102b60 <cpu>
  10393e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103944:	83 b8 e4 bd 10 00 01 	cmpl   $0x1,0x10bde4(%eax)
  10394b:	75 39                	jne    103986 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10394d:	e8 0e f2 ff ff       	call   102b60 <cpu>
  103952:	89 c3                	mov    %eax,%ebx
  103954:	e8 57 ff ff ff       	call   1038b0 <curproc>
  103959:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10395f:	81 c3 28 bd 10 00    	add    $0x10bd28,%ebx
  103965:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103969:	83 c0 64             	add    $0x64,%eax
  10396c:	89 04 24             	mov    %eax,(%esp)
  10396f:	e8 e8 11 00 00       	call   104b5c <swtch>
}
  103974:	83 c4 14             	add    $0x14,%esp
  103977:	5b                   	pop    %ebx
  103978:	5d                   	pop    %ebp
  103979:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10397a:	c7 04 24 da 6f 10 00 	movl   $0x106fda,(%esp)
  103981:	e8 da cf ff ff       	call   100960 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  103986:	c7 04 24 12 70 10 00 	movl   $0x107012,(%esp)
  10398d:	e8 ce cf ff ff       	call   100960 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103992:	c7 04 24 fc 6f 10 00 	movl   $0x106ffc,(%esp)
  103999:	e8 c2 cf ff ff       	call   100960 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10399e:	c7 04 24 ee 6f 10 00 	movl   $0x106fee,(%esp)
  1039a5:	e8 b6 cf ff ff       	call   100960 <panic>
  1039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001039b0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1039b0:	55                   	push   %ebp
  1039b1:	89 e5                	mov    %esp,%ebp
  1039b3:	56                   	push   %esi
  1039b4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1039b5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1039b7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  1039ba:	e8 f1 fe ff ff       	call   1038b0 <curproc>
  1039bf:	3b 05 a8 8a 10 00    	cmp    0x108aa8,%eax
  1039c5:	0f 84 36 01 00 00    	je     103b01 <exit+0x151>
  1039cb:	90                   	nop
  1039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1039d0:	e8 db fe ff ff       	call   1038b0 <curproc>
  1039d5:	8d 73 08             	lea    0x8(%ebx),%esi
  1039d8:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  1039db:	85 d2                	test   %edx,%edx
  1039dd:	74 1c                	je     1039fb <exit+0x4b>
      fileclose(cp->ofile[fd]);
  1039df:	e8 cc fe ff ff       	call   1038b0 <curproc>
  1039e4:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1039e7:	89 04 24             	mov    %eax,(%esp)
  1039ea:	e8 f1 d6 ff ff       	call   1010e0 <fileclose>
      cp->ofile[fd] = 0;
  1039ef:	e8 bc fe ff ff       	call   1038b0 <curproc>
  1039f4:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1039fb:	83 c3 01             	add    $0x1,%ebx
  1039fe:	83 fb 10             	cmp    $0x10,%ebx
  103a01:	75 cd                	jne    1039d0 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103a03:	e8 a8 fe ff ff       	call   1038b0 <curproc>
  103a08:	8b 40 60             	mov    0x60(%eax),%eax
  103a0b:	89 04 24             	mov    %eax,(%esp)
  103a0e:	e8 dd e1 ff ff       	call   101bf0 <iput>
  cp->cwd = 0;
  103a13:	e8 98 fe ff ff       	call   1038b0 <curproc>
  103a18:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  103a1f:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103a26:	e8 c5 0e 00 00       	call   1048f0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  103a2b:	e8 80 fe ff ff       	call   1038b0 <curproc>
  103a30:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103a33:	b8 a0 ea 10 00       	mov    $0x10eaa0,%eax
  103a38:	3d a0 c3 10 00       	cmp    $0x10c3a0,%eax
  103a3d:	0f 86 95 00 00 00    	jbe    103ad8 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103a43:	b8 a0 c3 10 00       	mov    $0x10c3a0,%eax
  103a48:	eb 12                	jmp    103a5c <exit+0xac>
  103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103a50:	05 9c 00 00 00       	add    $0x9c,%eax
  103a55:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  103a5a:	74 1e                	je     103a7a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  103a5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103a60:	75 ee                	jne    103a50 <exit+0xa0>
  103a62:	3b 50 18             	cmp    0x18(%eax),%edx
  103a65:	75 e9                	jne    103a50 <exit+0xa0>
      p->state = RUNNABLE;
  103a67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103a6e:	05 9c 00 00 00       	add    $0x9c,%eax
  103a73:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  103a78:	75 e2                	jne    103a5c <exit+0xac>
  103a7a:	bb a0 c3 10 00       	mov    $0x10c3a0,%ebx
  103a7f:	eb 15                	jmp    103a96 <exit+0xe6>
  103a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103a88:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  103a8e:	81 fb a0 ea 10 00    	cmp    $0x10eaa0,%ebx
  103a94:	74 42                	je     103ad8 <exit+0x128>
    if(p->parent == cp){
  103a96:	8b 73 14             	mov    0x14(%ebx),%esi
  103a99:	e8 12 fe ff ff       	call   1038b0 <curproc>
  103a9e:	39 c6                	cmp    %eax,%esi
  103aa0:	75 e6                	jne    103a88 <exit+0xd8>
      p->parent = initproc;
  103aa2:	8b 15 a8 8a 10 00    	mov    0x108aa8,%edx
      if(p->state == ZOMBIE)
  103aa8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  103aac:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  103aaf:	75 d7                	jne    103a88 <exit+0xd8>
  103ab1:	b8 a0 c3 10 00       	mov    $0x10c3a0,%eax
  103ab6:	eb 0c                	jmp    103ac4 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103ab8:	05 9c 00 00 00       	add    $0x9c,%eax
  103abd:	3d a0 ea 10 00       	cmp    $0x10eaa0,%eax
  103ac2:	74 c4                	je     103a88 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  103ac4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103ac8:	75 ee                	jne    103ab8 <exit+0x108>
  103aca:	3b 50 18             	cmp    0x18(%eax),%edx
  103acd:	75 e9                	jne    103ab8 <exit+0x108>
      p->state = RUNNABLE;
  103acf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103ad6:	eb e0                	jmp    103ab8 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103ad8:	e8 d3 fd ff ff       	call   1038b0 <curproc>
  103add:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  103ae4:	e8 c7 fd ff ff       	call   1038b0 <curproc>
  103ae9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103af0:	e8 1b fe ff ff       	call   103910 <sched>
  panic("zombie exit");
  103af5:	c7 04 24 2b 70 10 00 	movl   $0x10702b,(%esp)
  103afc:	e8 5f ce ff ff       	call   100960 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103b01:	c7 04 24 1e 70 10 00 	movl   $0x10701e,(%esp)
  103b08:	e8 53 ce ff ff       	call   100960 <panic>
  103b0d:	8d 76 00             	lea    0x0(%esi),%esi

00103b10 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  103b10:	55                   	push   %ebp
  103b11:	89 e5                	mov    %esp,%ebp
  103b13:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  103b16:	e8 95 fd ff ff       	call   1038b0 <curproc>
  103b1b:	85 c0                	test   %eax,%eax
  103b1d:	74 2b                	je     103b4a <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  103b1f:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103b26:	e8 c5 0d 00 00       	call   1048f0 <acquire>
  cp->state = SLEEPING;
  103b2b:	e8 80 fd ff ff       	call   1038b0 <curproc>
  103b30:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  103b37:	e8 d4 fd ff ff       	call   103910 <sched>
	release(&proc_table_lock); 
  103b3c:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103b43:	e8 68 0d 00 00       	call   1048b0 <release>
}
  103b48:	c9                   	leave  
  103b49:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  103b4a:	c7 04 24 37 70 10 00 	movl   $0x107037,(%esp)
  103b51:	e8 0a ce ff ff       	call   100960 <panic>
  103b56:	8d 76 00             	lea    0x0(%esi),%esi
  103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103b60 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103b60:	55                   	push   %ebp
  103b61:	89 e5                	mov    %esp,%ebp
  103b63:	56                   	push   %esi
  103b64:	53                   	push   %ebx
  103b65:	83 ec 10             	sub    $0x10,%esp
  103b68:	8b 75 08             	mov    0x8(%ebp),%esi
  103b6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  103b6e:	e8 3d fd ff ff       	call   1038b0 <curproc>
  103b73:	85 c0                	test   %eax,%eax
  103b75:	0f 84 9d 00 00 00    	je     103c18 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  103b7b:	85 db                	test   %ebx,%ebx
  103b7d:	0f 84 89 00 00 00    	je     103c0c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103b83:	81 fb a0 ea 10 00    	cmp    $0x10eaa0,%ebx
  103b89:	74 55                	je     103be0 <sleep+0x80>
    acquire(&proc_table_lock);
  103b8b:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103b92:	e8 59 0d 00 00       	call   1048f0 <acquire>
    release(lk);
  103b97:	89 1c 24             	mov    %ebx,(%esp)
  103b9a:	e8 11 0d 00 00       	call   1048b0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  103b9f:	e8 0c fd ff ff       	call   1038b0 <curproc>
  103ba4:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103ba7:	e8 04 fd ff ff       	call   1038b0 <curproc>
  103bac:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103bb3:	e8 58 fd ff ff       	call   103910 <sched>

  // Tidy up.
  cp->chan = 0;
  103bb8:	e8 f3 fc ff ff       	call   1038b0 <curproc>
  103bbd:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103bc4:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103bcb:	e8 e0 0c 00 00       	call   1048b0 <release>
    acquire(lk);
  103bd0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103bd3:	83 c4 10             	add    $0x10,%esp
  103bd6:	5b                   	pop    %ebx
  103bd7:	5e                   	pop    %esi
  103bd8:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103bd9:	e9 12 0d 00 00       	jmp    1048f0 <acquire>
  103bde:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103be0:	e8 cb fc ff ff       	call   1038b0 <curproc>
  103be5:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103be8:	e8 c3 fc ff ff       	call   1038b0 <curproc>
  103bed:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103bf4:	e8 17 fd ff ff       	call   103910 <sched>

  // Tidy up.
  cp->chan = 0;
  103bf9:	e8 b2 fc ff ff       	call   1038b0 <curproc>
  103bfe:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103c05:	83 c4 10             	add    $0x10,%esp
  103c08:	5b                   	pop    %ebx
  103c09:	5e                   	pop    %esi
  103c0a:	5d                   	pop    %ebp
  103c0b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  103c0c:	c7 04 24 3d 70 10 00 	movl   $0x10703d,(%esp)
  103c13:	e8 48 cd ff ff       	call   100960 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103c18:	c7 04 24 37 70 10 00 	movl   $0x107037,(%esp)
  103c1f:	e8 3c cd ff ff       	call   100960 <panic>
  103c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103c30 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103c34:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103c36:	56                   	push   %esi
  103c37:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103c38:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103c3a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103c3d:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103c44:	e8 a7 0c 00 00       	call   1048f0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c49:	83 fb 3f             	cmp    $0x3f,%ebx
  103c4c:	7e 2f                	jle    103c7d <wait_thread+0x4d>
  103c4e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103c50:	85 ff                	test   %edi,%edi
  103c52:	74 74                	je     103cc8 <wait_thread+0x98>
  103c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103c58:	e8 53 fc ff ff       	call   1038b0 <curproc>
  103c5d:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103c60:	85 c9                	test   %ecx,%ecx
  103c62:	75 64                	jne    103cc8 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103c64:	e8 47 fc ff ff       	call   1038b0 <curproc>
  103c69:	31 ff                	xor    %edi,%edi
  103c6b:	31 db                	xor    %ebx,%ebx
  103c6d:	c7 44 24 04 a0 ea 10 	movl   $0x10eaa0,0x4(%esp)
  103c74:	00 
  103c75:	89 04 24             	mov    %eax,(%esp)
  103c78:	e8 e3 fe ff ff       	call   103b60 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103c7d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103c83:	81 c6 a0 c3 10 00    	add    $0x10c3a0,%esi
      if(p->state == UNUSED)
  103c89:	8b 46 0c             	mov    0xc(%esi),%eax
  103c8c:	85 c0                	test   %eax,%eax
  103c8e:	75 10                	jne    103ca0 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c90:	83 c3 01             	add    $0x1,%ebx
  103c93:	83 fb 3f             	cmp    $0x3f,%ebx
  103c96:	7e e5                	jle    103c7d <wait_thread+0x4d>
  103c98:	eb b6                	jmp    103c50 <wait_thread+0x20>
  103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103ca0:	8b 46 14             	mov    0x14(%esi),%eax
  103ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ca6:	e8 05 fc ff ff       	call   1038b0 <curproc>
  103cab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103cae:	66 90                	xchg   %ax,%ax
  103cb0:	75 de                	jne    103c90 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103cb2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103cb6:	74 29                	je     103ce1 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103cb8:	bf 01 00 00 00       	mov    $0x1,%edi
  103cbd:	8d 76 00             	lea    0x0(%esi),%esi
  103cc0:	eb ce                	jmp    103c90 <wait_thread+0x60>
  103cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103cc8:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103ccf:	e8 dc 0b 00 00       	call   1048b0 <release>
  103cd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103cd9:	83 c4 2c             	add    $0x2c,%esp
  103cdc:	5b                   	pop    %ebx
  103cdd:	5e                   	pop    %esi
  103cde:	5f                   	pop    %edi
  103cdf:	5d                   	pop    %ebp
  103ce0:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103ce1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ce8:	00 
  103ce9:	8b 46 08             	mov    0x8(%esi),%eax
  103cec:	89 04 24             	mov    %eax,(%esp)
  103cef:	e8 9c e9 ff ff       	call   102690 <kfree>
          pid = p->pid;
  103cf4:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103cf7:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103cfe:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103d05:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103d0c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103d16:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103d1d:	e8 8e 0b 00 00       	call   1048b0 <release>
          return pid;
  103d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103d25:	eb b2                	jmp    103cd9 <wait_thread+0xa9>
  103d27:	89 f6                	mov    %esi,%esi
  103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103d30 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103d30:	55                   	push   %ebp
  103d31:	89 e5                	mov    %esp,%ebp
  103d33:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103d34:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103d36:	56                   	push   %esi
  103d37:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103d38:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103d3a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103d3d:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103d44:	e8 a7 0b 00 00       	call   1048f0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103d49:	83 fb 3f             	cmp    $0x3f,%ebx
  103d4c:	7e 2f                	jle    103d7d <wait+0x4d>
  103d4e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103d50:	85 ff                	test   %edi,%edi
  103d52:	74 74                	je     103dc8 <wait+0x98>
  103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103d58:	e8 53 fb ff ff       	call   1038b0 <curproc>
  103d5d:	8b 50 1c             	mov    0x1c(%eax),%edx
  103d60:	85 d2                	test   %edx,%edx
  103d62:	75 64                	jne    103dc8 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103d64:	e8 47 fb ff ff       	call   1038b0 <curproc>
  103d69:	31 ff                	xor    %edi,%edi
  103d6b:	31 db                	xor    %ebx,%ebx
  103d6d:	c7 44 24 04 a0 ea 10 	movl   $0x10eaa0,0x4(%esp)
  103d74:	00 
  103d75:	89 04 24             	mov    %eax,(%esp)
  103d78:	e8 e3 fd ff ff       	call   103b60 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103d7d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103d83:	81 c6 a0 c3 10 00    	add    $0x10c3a0,%esi
      if(p->state == UNUSED)
  103d89:	8b 4e 0c             	mov    0xc(%esi),%ecx
  103d8c:	85 c9                	test   %ecx,%ecx
  103d8e:	75 10                	jne    103da0 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103d90:	83 c3 01             	add    $0x1,%ebx
  103d93:	83 fb 3f             	cmp    $0x3f,%ebx
  103d96:	7e e5                	jle    103d7d <wait+0x4d>
  103d98:	eb b6                	jmp    103d50 <wait+0x20>
  103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103da0:	8b 46 14             	mov    0x14(%esi),%eax
  103da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103da6:	e8 05 fb ff ff       	call   1038b0 <curproc>
  103dab:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103dae:	66 90                	xchg   %ax,%ax
  103db0:	75 de                	jne    103d90 <wait+0x60>
        if(p->state == ZOMBIE){
  103db2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103db6:	74 29                	je     103de1 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103db8:	bf 01 00 00 00       	mov    $0x1,%edi
  103dbd:	8d 76 00             	lea    0x0(%esi),%esi
  103dc0:	eb ce                	jmp    103d90 <wait+0x60>
  103dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103dc8:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103dcf:	e8 dc 0a 00 00       	call   1048b0 <release>
  103dd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103dd9:	83 c4 2c             	add    $0x2c,%esp
  103ddc:	5b                   	pop    %ebx
  103ddd:	5e                   	pop    %esi
  103dde:	5f                   	pop    %edi
  103ddf:	5d                   	pop    %ebp
  103de0:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103de1:	8b 46 04             	mov    0x4(%esi),%eax
  103de4:	89 44 24 04          	mov    %eax,0x4(%esp)
  103de8:	8b 06                	mov    (%esi),%eax
  103dea:	89 04 24             	mov    %eax,(%esp)
  103ded:	e8 9e e8 ff ff       	call   102690 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103df2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103df9:	00 
  103dfa:	8b 46 08             	mov    0x8(%esi),%eax
  103dfd:	89 04 24             	mov    %eax,(%esp)
  103e00:	e8 8b e8 ff ff       	call   102690 <kfree>
          pid = p->pid;
  103e05:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103e08:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103e0f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103e16:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103e1d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103e24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e27:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103e2e:	e8 7d 0a 00 00       	call   1048b0 <release>
          return pid;
  103e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e36:	eb a1                	jmp    103dd9 <wait+0xa9>
  103e38:	90                   	nop
  103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103e40 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103e40:	55                   	push   %ebp
  103e41:	89 e5                	mov    %esp,%ebp
  103e43:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  103e46:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103e4d:	e8 9e 0a 00 00       	call   1048f0 <acquire>
  cp->state = RUNNABLE;
  103e52:	e8 59 fa ff ff       	call   1038b0 <curproc>
  103e57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103e5e:	e8 ad fa ff ff       	call   103910 <sched>
  release(&proc_table_lock);
  103e63:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  103e6a:	e8 41 0a 00 00       	call   1048b0 <release>
}
  103e6f:	c9                   	leave  
  103e70:	c3                   	ret    
  103e71:	eb 0d                	jmp    103e80 <setupsegs>
  103e73:	90                   	nop
  103e74:	90                   	nop
  103e75:	90                   	nop
  103e76:	90                   	nop
  103e77:	90                   	nop
  103e78:	90                   	nop
  103e79:	90                   	nop
  103e7a:	90                   	nop
  103e7b:	90                   	nop
  103e7c:	90                   	nop
  103e7d:	90                   	nop
  103e7e:	90                   	nop
  103e7f:	90                   	nop

00103e80 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103e80:	55                   	push   %ebp
  103e81:	89 e5                	mov    %esp,%ebp
  103e83:	57                   	push   %edi
  103e84:	56                   	push   %esi
  103e85:	53                   	push   %ebx
  103e86:	83 ec 2c             	sub    $0x2c,%esp
  103e89:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103e8c:	e8 8f 09 00 00       	call   104820 <pushcli>
  c = &cpus[cpu()];
  103e91:	e8 ca ec ff ff       	call   102b60 <cpu>
  103e96:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103e9c:	05 20 bd 10 00       	add    $0x10bd20,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103ea1:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103ea3:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103ea9:	0f 84 a1 01 00 00    	je     104050 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103eaf:	8b 56 08             	mov    0x8(%esi),%edx
  103eb2:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103eb8:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103ebb:	8d 50 28             	lea    0x28(%eax),%edx
  103ebe:	89 d1                	mov    %edx,%ecx
  103ec0:	c1 e9 10             	shr    $0x10,%ecx
  103ec3:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103eca:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103ecd:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103ecf:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103ed6:	00 00 00 
  103ed9:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103ee0:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103ee3:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103eea:	0f 01 
  103eec:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103ef3:	00 00 
  103ef5:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103efc:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103f03:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103f0a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103f11:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103f18:	ff ff 
  103f1a:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103f21:	00 00 
  103f23:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103f2a:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103f31:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103f38:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103f3f:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103f46:	67 00 
  103f48:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103f4e:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103f55:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103f5b:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103f62:	0f 84 b8 00 00 00    	je     104020 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103f68:	8b 16                	mov    (%esi),%edx
  103f6a:	8b 5e 04             	mov    0x4(%esi),%ebx
  103f6d:	89 d6                	mov    %edx,%esi
  103f6f:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103f72:	89 d3                	mov    %edx,%ebx
  103f74:	c1 ee 10             	shr    $0x10,%esi
  103f77:	89 cf                	mov    %ecx,%edi
  103f79:	c1 eb 18             	shr    $0x18,%ebx
  103f7c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103f7f:	89 f3                	mov    %esi,%ebx
  103f81:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103f87:	89 cb                	mov    %ecx,%ebx
  103f89:	c1 eb 1c             	shr    $0x1c,%ebx
  103f8c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103f8e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103f91:	83 c9 c0             	or     $0xffffffc0,%ecx
  103f94:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103f9b:	c1 ef 0c             	shr    $0xc,%edi
  103f9e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103fa4:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103fa8:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103faf:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103fb5:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103fbc:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103fc2:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103fc6:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103fcd:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103fcf:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103fd6:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103fdd:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103fe3:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103fe9:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103fee:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103ff4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103ff8:	c1 e8 10             	shr    $0x10,%eax
  103ffb:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103fff:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104002:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  104005:	b8 28 00 00 00       	mov    $0x28,%eax
  10400a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  10400d:	e8 8e 07 00 00       	call   1047a0 <popcli>
}
  104012:	83 c4 2c             	add    $0x2c,%esp
  104015:	5b                   	pop    %ebx
  104016:	5e                   	pop    %esi
  104017:	5f                   	pop    %edi
  104018:	5d                   	pop    %ebp
  104019:	c3                   	ret    
  10401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  104020:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  104027:	00 00 00 
  10402a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  104031:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  104034:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10403b:	00 00 00 
  10403e:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  104045:	00 00 00 
  104048:	eb 9f                	jmp    103fe9 <setupsegs+0x169>
  10404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  104050:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  104057:	e9 5f fe ff ff       	jmp    103ebb <setupsegs+0x3b>
  10405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104060 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  104060:	55                   	push   %ebp
  104061:	89 e5                	mov    %esp,%ebp
  104063:	57                   	push   %edi
  104064:	56                   	push   %esi
  104065:	53                   	push   %ebx
  104066:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  104069:	e8 f2 ea ff ff       	call   102b60 <cpu>
  10406e:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  104074:	81 c3 20 bd 10 00    	add    $0x10bd20,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  10407a:	8d 73 08             	lea    0x8(%ebx),%esi
  10407d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  104080:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104081:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  104088:	e8 63 08 00 00       	call   1048f0 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  10408d:	83 3d b0 c3 10 00 01 	cmpl   $0x1,0x10c3b0
  104094:	0f 84 c6 00 00 00    	je     104160 <scheduler+0x100>
  10409a:	31 d2                	xor    %edx,%edx
  10409c:	31 c0                	xor    %eax,%eax
  10409e:	eb 0e                	jmp    1040ae <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  1040a0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  1040a6:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  1040ac:	74 1d                	je     1040cb <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  1040ae:	83 ba ac c3 10 00 03 	cmpl   $0x3,0x10c3ac(%edx)
  1040b5:	75 e9                	jne    1040a0 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  1040b7:	03 82 38 c4 10 00    	add    0x10c438(%edx),%eax
  1040bd:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  1040c3:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  1040c9:	75 e3                	jne    1040ae <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  1040cb:	85 c0                	test   %eax,%eax
  1040cd:	74 16                	je     1040e5 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  1040cf:	8b 3d 20 f3 10 00    	mov    0x10f320,%edi
  1040d5:	89 c1                	mov    %eax,%ecx
  1040d7:	c1 e7 08             	shl    $0x8,%edi
  1040da:	89 fa                	mov    %edi,%edx
  1040dc:	89 f8                	mov    %edi,%eax
  1040de:	c1 fa 1f             	sar    $0x1f,%edx
  1040e1:	f7 f9                	idiv   %ecx
  1040e3:	89 d7                	mov    %edx,%edi
  1040e5:	b8 ac c3 10 00       	mov    $0x10c3ac,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  1040ea:	31 d2                	xor    %edx,%edx
  1040ec:	eb 12                	jmp    104100 <scheduler+0xa0>
  1040ee:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  1040f0:	39 fa                	cmp    %edi,%edx
  1040f2:	7f 1e                	jg     104112 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  1040f4:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  1040f9:	3d ac ea 10 00       	cmp    $0x10eaac,%eax
  1040fe:	74 4c                	je     10414c <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  104100:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  104103:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  104106:	75 e8                	jne    1040f0 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  104108:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  10410e:	39 fa                	cmp    %edi,%edx
  104110:	7e e2                	jle    1040f4 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  104112:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  104115:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  104118:	89 0c 24             	mov    %ecx,(%esp)
  10411b:	e8 60 fd ff ff       	call   103e80 <setupsegs>
    	  p->state = RUNNING;
  104120:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  104123:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  10412a:	83 c1 64             	add    $0x64,%ecx
  10412d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104131:	89 34 24             	mov    %esi,(%esp)
  104134:	e8 23 0a 00 00       	call   104b5c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  104139:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  104140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104147:	e8 34 fd ff ff       	call   103e80 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  10414c:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  104153:	e8 58 07 00 00       	call   1048b0 <release>
  104158:	e9 23 ff ff ff       	jmp    104080 <scheduler+0x20>
  10415d:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  104160:	83 3d ac c3 10 00 03 	cmpl   $0x3,0x10c3ac
  104167:	0f 85 2d ff ff ff    	jne    10409a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  10416d:	c7 43 04 a0 c3 10 00 	movl   $0x10c3a0,0x4(%ebx)
      setupsegs(p);
  104174:	c7 04 24 a0 c3 10 00 	movl   $0x10c3a0,(%esp)
  10417b:	e8 00 fd ff ff       	call   103e80 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104180:	c7 44 24 04 04 c4 10 	movl   $0x10c404,0x4(%esp)
  104187:	00 
  104188:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  10418b:	c7 05 38 c4 10 00 4b 	movl   $0x4b,0x10c438
  104192:	00 00 00 
      p->state = RUNNING;
  104195:	c7 05 ac c3 10 00 04 	movl   $0x4,0x10c3ac
  10419c:	00 00 00 
      swtch(&c->context, &p->context);
  10419f:	e8 b8 09 00 00       	call   104b5c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  1041a4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  1041ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1041b2:	e8 c9 fc ff ff       	call   103e80 <setupsegs>
      release(&proc_table_lock);
  1041b7:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  1041be:	e8 ed 06 00 00       	call   1048b0 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  1041c3:	e9 b8 fe ff ff       	jmp    104080 <scheduler+0x20>
  1041c8:	90                   	nop
  1041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001041d0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  1041d0:	55                   	push   %ebp
  1041d1:	89 e5                	mov    %esp,%ebp
  1041d3:	57                   	push   %edi
  1041d4:	56                   	push   %esi
  1041d5:	53                   	push   %ebx
  1041d6:	83 ec 1c             	sub    $0x1c,%esp
  1041d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  1041dc:	e8 cf f6 ff ff       	call   1038b0 <curproc>
  1041e1:	8b 50 04             	mov    0x4(%eax),%edx
  1041e4:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  1041e7:	89 04 24             	mov    %eax,(%esp)
  1041ea:	e8 e1 e3 ff ff       	call   1025d0 <kalloc>
  1041ef:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  1041f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1041f6:	85 f6                	test   %esi,%esi
  1041f8:	74 7f                	je     104279 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  1041fa:	e8 b1 f6 ff ff       	call   1038b0 <curproc>
  1041ff:	8b 78 04             	mov    0x4(%eax),%edi
  104202:	e8 a9 f6 ff ff       	call   1038b0 <curproc>
  104207:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10420b:	8b 00                	mov    (%eax),%eax
  10420d:	89 34 24             	mov    %esi,(%esp)
  104210:	89 44 24 04          	mov    %eax,0x4(%esp)
  104214:	e8 d7 07 00 00       	call   1049f0 <memmove>
  memset(newmem + cp->sz, 0, n);
  104219:	e8 92 f6 ff ff       	call   1038b0 <curproc>
  10421e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104222:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104229:	00 
  10422a:	8b 50 04             	mov    0x4(%eax),%edx
  10422d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104230:	89 04 24             	mov    %eax,(%esp)
  104233:	e8 28 07 00 00       	call   104960 <memset>
  kfree(cp->mem, cp->sz);
  104238:	e8 73 f6 ff ff       	call   1038b0 <curproc>
  10423d:	8b 78 04             	mov    0x4(%eax),%edi
  104240:	e8 6b f6 ff ff       	call   1038b0 <curproc>
  104245:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104249:	8b 00                	mov    (%eax),%eax
  10424b:	89 04 24             	mov    %eax,(%esp)
  10424e:	e8 3d e4 ff ff       	call   102690 <kfree>
  cp->mem = newmem;
  104253:	e8 58 f6 ff ff       	call   1038b0 <curproc>
  104258:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  10425a:	e8 51 f6 ff ff       	call   1038b0 <curproc>
  10425f:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  104262:	e8 49 f6 ff ff       	call   1038b0 <curproc>
  104267:	89 04 24             	mov    %eax,(%esp)
  10426a:	e8 11 fc ff ff       	call   103e80 <setupsegs>
  return cp->sz - n;
  10426f:	e8 3c f6 ff ff       	call   1038b0 <curproc>
  104274:	8b 40 04             	mov    0x4(%eax),%eax
  104277:	29 d8                	sub    %ebx,%eax
}
  104279:	83 c4 1c             	add    $0x1c,%esp
  10427c:	5b                   	pop    %ebx
  10427d:	5e                   	pop    %esi
  10427e:	5f                   	pop    %edi
  10427f:	5d                   	pop    %ebp
  104280:	c3                   	ret    
  104281:	eb 0d                	jmp    104290 <copyproc_tix>
  104283:	90                   	nop
  104284:	90                   	nop
  104285:	90                   	nop
  104286:	90                   	nop
  104287:	90                   	nop
  104288:	90                   	nop
  104289:	90                   	nop
  10428a:	90                   	nop
  10428b:	90                   	nop
  10428c:	90                   	nop
  10428d:	90                   	nop
  10428e:	90                   	nop
  10428f:	90                   	nop

00104290 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  104290:	55                   	push   %ebp
  104291:	89 e5                	mov    %esp,%ebp
  104293:	57                   	push   %edi
  104294:	56                   	push   %esi
  104295:	53                   	push   %ebx
  104296:	83 ec 1c             	sub    $0x1c,%esp
  104299:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10429c:	e8 8f f5 ff ff       	call   103830 <allocproc>
  1042a1:	85 c0                	test   %eax,%eax
  1042a3:	89 c6                	mov    %eax,%esi
  1042a5:	0f 84 e1 00 00 00    	je     10438c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1042ab:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1042b2:	e8 19 e3 ff ff       	call   1025d0 <kalloc>
  1042b7:	85 c0                	test   %eax,%eax
  1042b9:	89 46 08             	mov    %eax,0x8(%esi)
  1042bc:	0f 84 d4 00 00 00    	je     104396 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1042c2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1042c7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1042c9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1042cf:	0f 84 85 00 00 00    	je     10435a <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  1042d5:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  1042d8:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  1042db:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1042e1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1042e8:	00 
  1042e9:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  1042ef:	89 04 24             	mov    %eax,(%esp)
  1042f2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042f6:	e8 f5 06 00 00       	call   1049f0 <memmove>
  
    np->sz = p->sz;
  1042fb:	8b 47 04             	mov    0x4(%edi),%eax
  1042fe:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104301:	89 04 24             	mov    %eax,(%esp)
  104304:	e8 c7 e2 ff ff       	call   1025d0 <kalloc>
  104309:	85 c0                	test   %eax,%eax
  10430b:	89 06                	mov    %eax,(%esi)
  10430d:	0f 84 8e 00 00 00    	je     1043a1 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104313:	8b 56 04             	mov    0x4(%esi),%edx
  104316:	31 db                	xor    %ebx,%ebx
  104318:	89 54 24 08          	mov    %edx,0x8(%esp)
  10431c:	8b 17                	mov    (%edi),%edx
  10431e:	89 04 24             	mov    %eax,(%esp)
  104321:	89 54 24 04          	mov    %edx,0x4(%esp)
  104325:	e8 c6 06 00 00       	call   1049f0 <memmove>
  10432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104330:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104334:	85 c0                	test   %eax,%eax
  104336:	74 0c                	je     104344 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104338:	89 04 24             	mov    %eax,(%esp)
  10433b:	e8 c0 cc ff ff       	call   101000 <filedup>
  104340:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104344:	83 c3 01             	add    $0x1,%ebx
  104347:	83 fb 10             	cmp    $0x10,%ebx
  10434a:	75 e4                	jne    104330 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10434c:	8b 47 60             	mov    0x60(%edi),%eax
  10434f:	89 04 24             	mov    %eax,(%esp)
  104352:	e8 b9 ce ff ff       	call   101210 <idup>
  104357:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10435a:	8d 46 64             	lea    0x64(%esi),%eax
  10435d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104364:	00 
  104365:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10436c:	00 
  10436d:	89 04 24             	mov    %eax,(%esp)
  104370:	e8 eb 05 00 00       	call   104960 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104375:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10437b:	c7 46 64 e0 38 10 00 	movl   $0x1038e0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104382:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104385:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10438c:	83 c4 1c             	add    $0x1c,%esp
  10438f:	89 f0                	mov    %esi,%eax
  104391:	5b                   	pop    %ebx
  104392:	5e                   	pop    %esi
  104393:	5f                   	pop    %edi
  104394:	5d                   	pop    %ebp
  104395:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104396:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10439d:	31 f6                	xor    %esi,%esi
    return 0;
  10439f:	eb eb                	jmp    10438c <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1043a1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1043a8:	00 
  1043a9:	8b 46 08             	mov    0x8(%esi),%eax
  1043ac:	89 04 24             	mov    %eax,(%esp)
  1043af:	e8 dc e2 ff ff       	call   102690 <kfree>
      np->kstack = 0;
  1043b4:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1043bb:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1043c2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1043c9:	31 f6                	xor    %esi,%esi
      return 0;
  1043cb:	eb bf                	jmp    10438c <copyproc_tix+0xfc>
  1043cd:	8d 76 00             	lea    0x0(%esi),%esi

001043d0 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  1043d0:	55                   	push   %ebp
  1043d1:	89 e5                	mov    %esp,%ebp
  1043d3:	57                   	push   %edi
  1043d4:	56                   	push   %esi
  1043d5:	53                   	push   %ebx
  1043d6:	83 ec 1c             	sub    $0x1c,%esp
  1043d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  1043dc:	e8 4f f4 ff ff       	call   103830 <allocproc>
  1043e1:	85 c0                	test   %eax,%eax
  1043e3:	89 c6                	mov    %eax,%esi
  1043e5:	0f 84 de 00 00 00    	je     1044c9 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1043eb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1043f2:	e8 d9 e1 ff ff       	call   1025d0 <kalloc>
  1043f7:	85 c0                	test   %eax,%eax
  1043f9:	89 46 08             	mov    %eax,0x8(%esi)
  1043fc:	0f 84 d1 00 00 00    	je     1044d3 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104402:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104407:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104409:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10440f:	74 61                	je     104472 <copyproc_threads+0xa2>
    np->parent = p;
  104411:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104414:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104416:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10441d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104420:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104427:	00 
  104428:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  10442e:	89 04 24             	mov    %eax,(%esp)
  104431:	89 54 24 04          	mov    %edx,0x4(%esp)
  104435:	e8 b6 05 00 00       	call   1049f0 <memmove>
  
    np->sz = p->sz;
  10443a:	8b 47 04             	mov    0x4(%edi),%eax
  10443d:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104440:	8b 07                	mov    (%edi),%eax
  104442:	89 06                	mov    %eax,(%esi)
  104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104448:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  10444c:	85 c0                	test   %eax,%eax
  10444e:	74 0c                	je     10445c <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  104450:	89 04 24             	mov    %eax,(%esp)
  104453:	e8 a8 cb ff ff       	call   101000 <filedup>
  104458:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  10445c:	83 c3 01             	add    $0x1,%ebx
  10445f:	83 fb 10             	cmp    $0x10,%ebx
  104462:	75 e4                	jne    104448 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  104464:	8b 47 60             	mov    0x60(%edi),%eax
  104467:	89 04 24             	mov    %eax,(%esp)
  10446a:	e8 a1 cd ff ff       	call   101210 <idup>
  10446f:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104472:	8d 46 64             	lea    0x64(%esi),%eax
  104475:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  10447c:	00 
  10447d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104484:	00 
  104485:	89 04 24             	mov    %eax,(%esp)
  104488:	e8 d3 04 00 00       	call   104960 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10448d:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104490:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104496:	c7 46 64 e0 38 10 00 	movl   $0x1038e0,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  10449d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1044a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1044a3:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1044a9:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1044ac:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  1044af:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1044b1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1044b8:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1044bf:	8b 40 3c             	mov    0x3c(%eax),%eax
  1044c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1044c5:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  1044c9:	83 c4 1c             	add    $0x1c,%esp
  1044cc:	89 f0                	mov    %esi,%eax
  1044ce:	5b                   	pop    %ebx
  1044cf:	5e                   	pop    %esi
  1044d0:	5f                   	pop    %edi
  1044d1:	5d                   	pop    %ebp
  1044d2:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1044d3:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1044da:	31 f6                	xor    %esi,%esi
    return 0;
  1044dc:	eb eb                	jmp    1044c9 <copyproc_threads+0xf9>
  1044de:	66 90                	xchg   %ax,%ax

001044e0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  1044e0:	55                   	push   %ebp
  1044e1:	89 e5                	mov    %esp,%ebp
  1044e3:	57                   	push   %edi
  1044e4:	56                   	push   %esi
  1044e5:	53                   	push   %ebx
  1044e6:	83 ec 1c             	sub    $0x1c,%esp
  1044e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1044ec:	e8 3f f3 ff ff       	call   103830 <allocproc>
  1044f1:	85 c0                	test   %eax,%eax
  1044f3:	89 c6                	mov    %eax,%esi
  1044f5:	0f 84 e1 00 00 00    	je     1045dc <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1044fb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104502:	e8 c9 e0 ff ff       	call   1025d0 <kalloc>
  104507:	85 c0                	test   %eax,%eax
  104509:	89 46 08             	mov    %eax,0x8(%esi)
  10450c:	0f 84 d4 00 00 00    	je     1045e6 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104512:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104517:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104519:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10451f:	0f 84 85 00 00 00    	je     1045aa <copyproc+0xca>
    np->parent = p;
  104525:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104528:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10452f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104532:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104539:	00 
  10453a:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104540:	89 04 24             	mov    %eax,(%esp)
  104543:	89 54 24 04          	mov    %edx,0x4(%esp)
  104547:	e8 a4 04 00 00       	call   1049f0 <memmove>
  
    np->sz = p->sz;
  10454c:	8b 47 04             	mov    0x4(%edi),%eax
  10454f:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104552:	89 04 24             	mov    %eax,(%esp)
  104555:	e8 76 e0 ff ff       	call   1025d0 <kalloc>
  10455a:	85 c0                	test   %eax,%eax
  10455c:	89 06                	mov    %eax,(%esi)
  10455e:	0f 84 8d 00 00 00    	je     1045f1 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104564:	8b 56 04             	mov    0x4(%esi),%edx
  104567:	31 db                	xor    %ebx,%ebx
  104569:	89 54 24 08          	mov    %edx,0x8(%esp)
  10456d:	8b 17                	mov    (%edi),%edx
  10456f:	89 04 24             	mov    %eax,(%esp)
  104572:	89 54 24 04          	mov    %edx,0x4(%esp)
  104576:	e8 75 04 00 00       	call   1049f0 <memmove>
  10457b:	90                   	nop
  10457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104580:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104584:	85 c0                	test   %eax,%eax
  104586:	74 0c                	je     104594 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104588:	89 04 24             	mov    %eax,(%esp)
  10458b:	e8 70 ca ff ff       	call   101000 <filedup>
  104590:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104594:	83 c3 01             	add    $0x1,%ebx
  104597:	83 fb 10             	cmp    $0x10,%ebx
  10459a:	75 e4                	jne    104580 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10459c:	8b 47 60             	mov    0x60(%edi),%eax
  10459f:	89 04 24             	mov    %eax,(%esp)
  1045a2:	e8 69 cc ff ff       	call   101210 <idup>
  1045a7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1045aa:	8d 46 64             	lea    0x64(%esi),%eax
  1045ad:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1045b4:	00 
  1045b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045bc:	00 
  1045bd:	89 04 24             	mov    %eax,(%esp)
  1045c0:	e8 9b 03 00 00       	call   104960 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1045c5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1045cb:	c7 46 64 e0 38 10 00 	movl   $0x1038e0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1045d2:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1045d5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1045dc:	83 c4 1c             	add    $0x1c,%esp
  1045df:	89 f0                	mov    %esi,%eax
  1045e1:	5b                   	pop    %ebx
  1045e2:	5e                   	pop    %esi
  1045e3:	5f                   	pop    %edi
  1045e4:	5d                   	pop    %ebp
  1045e5:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1045e6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1045ed:	31 f6                	xor    %esi,%esi
    return 0;
  1045ef:	eb eb                	jmp    1045dc <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1045f1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1045f8:	00 
  1045f9:	8b 46 08             	mov    0x8(%esi),%eax
  1045fc:	89 04 24             	mov    %eax,(%esp)
  1045ff:	e8 8c e0 ff ff       	call   102690 <kfree>
      np->kstack = 0;
  104604:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10460b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104612:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104619:	31 f6                	xor    %esi,%esi
      return 0;
  10461b:	eb bf                	jmp    1045dc <copyproc+0xfc>
  10461d:	8d 76 00             	lea    0x0(%esi),%esi

00104620 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104620:	55                   	push   %ebp
  104621:	89 e5                	mov    %esp,%ebp
  104623:	53                   	push   %ebx
  104624:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104627:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10462e:	e8 ad fe ff ff       	call   1044e0 <copyproc>
  p->sz = PAGE;
  104633:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10463a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10463c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104643:	e8 88 df ff ff       	call   1025d0 <kalloc>
  104648:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10464a:	c7 04 24 4e 70 10 00 	movl   $0x10704e,(%esp)
  104651:	e8 aa db ff ff       	call   102200 <namei>
  104656:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104659:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104660:	00 
  104661:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104668:	00 
  104669:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10466f:	89 04 24             	mov    %eax,(%esp)
  104672:	e8 e9 02 00 00       	call   104960 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104677:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10467d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10467f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104686:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104689:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10468f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104695:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10469b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10469e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1046a2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1046a5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1046ab:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1046b2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1046b9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1046c0:	00 
  1046c1:	c7 44 24 04 68 89 10 	movl   $0x108968,0x4(%esp)
  1046c8:	00 
  1046c9:	8b 03                	mov    (%ebx),%eax
  1046cb:	89 04 24             	mov    %eax,(%esp)
  1046ce:	e8 1d 03 00 00       	call   1049f0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  1046d3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  1046d9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1046e0:	00 
  1046e1:	c7 44 24 04 50 70 10 	movl   $0x107050,0x4(%esp)
  1046e8:	00 
  1046e9:	89 04 24             	mov    %eax,(%esp)
  1046ec:	e8 0f 04 00 00       	call   104b00 <safestrcpy>
  p->state = RUNNABLE;
  1046f1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  1046f8:	89 1d a8 8a 10 00    	mov    %ebx,0x108aa8
}
  1046fe:	83 c4 14             	add    $0x14,%esp
  104701:	5b                   	pop    %ebx
  104702:	5d                   	pop    %ebp
  104703:	c3                   	ret    
  104704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10470a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104710 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104710:	55                   	push   %ebp
  104711:	89 e5                	mov    %esp,%ebp
  104713:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104716:	c7 44 24 04 59 70 10 	movl   $0x107059,0x4(%esp)
  10471d:	00 
  10471e:	c7 04 24 a0 ea 10 00 	movl   $0x10eaa0,(%esp)
  104725:	e8 06 00 00 00       	call   104730 <initlock>
}
  10472a:	c9                   	leave  
  10472b:	c3                   	ret    
  10472c:	90                   	nop
  10472d:	90                   	nop
  10472e:	90                   	nop
  10472f:	90                   	nop

00104730 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104730:	55                   	push   %ebp
  104731:	89 e5                	mov    %esp,%ebp
  104733:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104736:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10473f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104742:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104749:	5d                   	pop    %ebp
  10474a:	c3                   	ret    
  10474b:	90                   	nop
  10474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104750 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104750:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104751:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104753:	89 e5                	mov    %esp,%ebp
  104755:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104756:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104759:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10475c:	83 ea 08             	sub    $0x8,%edx
  10475f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104760:	8d 4a ff             	lea    -0x1(%edx),%ecx
  104763:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  104766:	77 18                	ja     104780 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  104768:	8b 4a 04             	mov    0x4(%edx),%ecx
  10476b:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  10476e:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104771:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104773:	83 f8 0a             	cmp    $0xa,%eax
  104776:	75 e8                	jne    104760 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  104778:	5b                   	pop    %ebx
  104779:	5d                   	pop    %ebp
  10477a:	c3                   	ret    
  10477b:	90                   	nop
  10477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104780:	83 f8 09             	cmp    $0x9,%eax
  104783:	7f f3                	jg     104778 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104785:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  104788:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  10478b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104791:	83 c2 04             	add    $0x4,%edx
  104794:	83 f8 0a             	cmp    $0xa,%eax
  104797:	75 ef                	jne    104788 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  104799:	5b                   	pop    %ebx
  10479a:	5d                   	pop    %ebp
  10479b:	c3                   	ret    
  10479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001047a0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1047a0:	55                   	push   %ebp
  1047a1:	89 e5                	mov    %esp,%ebp
  1047a3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1047a6:	9c                   	pushf  
  1047a7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1047a8:	f6 c4 02             	test   $0x2,%ah
  1047ab:	75 5f                	jne    10480c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1047ad:	e8 ae e3 ff ff       	call   102b60 <cpu>
  1047b2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1047b8:	05 24 bd 10 00       	add    $0x10bd24,%eax
  1047bd:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1047c3:	83 ea 01             	sub    $0x1,%edx
  1047c6:	85 d2                	test   %edx,%edx
  1047c8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1047ce:	78 30                	js     104800 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1047d0:	e8 8b e3 ff ff       	call   102b60 <cpu>
  1047d5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1047db:	8b 90 e4 bd 10 00    	mov    0x10bde4(%eax),%edx
  1047e1:	85 d2                	test   %edx,%edx
  1047e3:	74 03                	je     1047e8 <popcli+0x48>
    sti();
}
  1047e5:	c9                   	leave  
  1047e6:	c3                   	ret    
  1047e7:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1047e8:	e8 73 e3 ff ff       	call   102b60 <cpu>
  1047ed:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1047f3:	8b 80 e8 bd 10 00    	mov    0x10bde8(%eax),%eax
  1047f9:	85 c0                	test   %eax,%eax
  1047fb:	74 e8                	je     1047e5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  1047fd:	fb                   	sti    
    sti();
}
  1047fe:	c9                   	leave  
  1047ff:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104800:	c7 04 24 bf 70 10 00 	movl   $0x1070bf,(%esp)
  104807:	e8 54 c1 ff ff       	call   100960 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10480c:	c7 04 24 a8 70 10 00 	movl   $0x1070a8,(%esp)
  104813:	e8 48 c1 ff ff       	call   100960 <panic>
  104818:	90                   	nop
  104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104820 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104820:	55                   	push   %ebp
  104821:	89 e5                	mov    %esp,%ebp
  104823:	53                   	push   %ebx
  104824:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104827:	9c                   	pushf  
  104828:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104829:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10482a:	e8 31 e3 ff ff       	call   102b60 <cpu>
  10482f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104835:	05 24 bd 10 00       	add    $0x10bd24,%eax
  10483a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104840:	8d 4a 01             	lea    0x1(%edx),%ecx
  104843:	85 d2                	test   %edx,%edx
  104845:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  10484b:	75 17                	jne    104864 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  10484d:	e8 0e e3 ff ff       	call   102b60 <cpu>
  104852:	81 e3 00 02 00 00    	and    $0x200,%ebx
  104858:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10485e:	89 98 e8 bd 10 00    	mov    %ebx,0x10bde8(%eax)
}
  104864:	83 c4 04             	add    $0x4,%esp
  104867:	5b                   	pop    %ebx
  104868:	5d                   	pop    %ebp
  104869:	c3                   	ret    
  10486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104870 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104870:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104871:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104873:	89 e5                	mov    %esp,%ebp
  104875:	53                   	push   %ebx
  104876:	83 ec 04             	sub    $0x4,%esp
  104879:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10487c:	8b 0a                	mov    (%edx),%ecx
  10487e:	85 c9                	test   %ecx,%ecx
  104880:	75 06                	jne    104888 <holding+0x18>
}
  104882:	83 c4 04             	add    $0x4,%esp
  104885:	5b                   	pop    %ebx
  104886:	5d                   	pop    %ebp
  104887:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  104888:	8b 5a 08             	mov    0x8(%edx),%ebx
  10488b:	e8 d0 e2 ff ff       	call   102b60 <cpu>
  104890:	83 c0 0a             	add    $0xa,%eax
  104893:	39 c3                	cmp    %eax,%ebx
  104895:	0f 94 c0             	sete   %al
}
  104898:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  10489b:	0f b6 c0             	movzbl %al,%eax
}
  10489e:	5b                   	pop    %ebx
  10489f:	5d                   	pop    %ebp
  1048a0:	c3                   	ret    
  1048a1:	eb 0d                	jmp    1048b0 <release>
  1048a3:	90                   	nop
  1048a4:	90                   	nop
  1048a5:	90                   	nop
  1048a6:	90                   	nop
  1048a7:	90                   	nop
  1048a8:	90                   	nop
  1048a9:	90                   	nop
  1048aa:	90                   	nop
  1048ab:	90                   	nop
  1048ac:	90                   	nop
  1048ad:	90                   	nop
  1048ae:	90                   	nop
  1048af:	90                   	nop

001048b0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1048b0:	55                   	push   %ebp
  1048b1:	89 e5                	mov    %esp,%ebp
  1048b3:	53                   	push   %ebx
  1048b4:	83 ec 14             	sub    $0x14,%esp
  1048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1048ba:	89 1c 24             	mov    %ebx,(%esp)
  1048bd:	e8 ae ff ff ff       	call   104870 <holding>
  1048c2:	85 c0                	test   %eax,%eax
  1048c4:	74 1d                	je     1048e3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1048c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1048cd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1048cf:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  1048d6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  1048d9:	83 c4 14             	add    $0x14,%esp
  1048dc:	5b                   	pop    %ebx
  1048dd:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  1048de:	e9 bd fe ff ff       	jmp    1047a0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1048e3:	c7 04 24 c6 70 10 00 	movl   $0x1070c6,(%esp)
  1048ea:	e8 71 c0 ff ff       	call   100960 <panic>
  1048ef:	90                   	nop

001048f0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  1048f0:	55                   	push   %ebp
  1048f1:	89 e5                	mov    %esp,%ebp
  1048f3:	53                   	push   %ebx
  1048f4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  1048f7:	e8 24 ff ff ff       	call   104820 <pushcli>
  if(holding(lock))
  1048fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1048ff:	89 04 24             	mov    %eax,(%esp)
  104902:	e8 69 ff ff ff       	call   104870 <holding>
  104907:	85 c0                	test   %eax,%eax
  104909:	75 3d                	jne    104948 <acquire+0x58>
    panic("acquire");
  10490b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10490e:	ba 01 00 00 00       	mov    $0x1,%edx
  104913:	90                   	nop
  104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104918:	89 d0                	mov    %edx,%eax
  10491a:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10491d:	83 f8 01             	cmp    $0x1,%eax
  104920:	74 f6                	je     104918 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  104922:	e8 39 e2 ff ff       	call   102b60 <cpu>
  104927:	83 c0 0a             	add    $0xa,%eax
  10492a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  10492d:	8b 45 08             	mov    0x8(%ebp),%eax
  104930:	83 c0 0c             	add    $0xc,%eax
  104933:	89 44 24 04          	mov    %eax,0x4(%esp)
  104937:	8d 45 08             	lea    0x8(%ebp),%eax
  10493a:	89 04 24             	mov    %eax,(%esp)
  10493d:	e8 0e fe ff ff       	call   104750 <getcallerpcs>
}
  104942:	83 c4 14             	add    $0x14,%esp
  104945:	5b                   	pop    %ebx
  104946:	5d                   	pop    %ebp
  104947:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104948:	c7 04 24 ce 70 10 00 	movl   $0x1070ce,(%esp)
  10494f:	e8 0c c0 ff ff       	call   100960 <panic>
  104954:	90                   	nop
  104955:	90                   	nop
  104956:	90                   	nop
  104957:	90                   	nop
  104958:	90                   	nop
  104959:	90                   	nop
  10495a:	90                   	nop
  10495b:	90                   	nop
  10495c:	90                   	nop
  10495d:	90                   	nop
  10495e:	90                   	nop
  10495f:	90                   	nop

00104960 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  104960:	55                   	push   %ebp
  104961:	89 e5                	mov    %esp,%ebp
  104963:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104966:	53                   	push   %ebx
  104967:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10496a:	85 c9                	test   %ecx,%ecx
  10496c:	74 14                	je     104982 <memset+0x22>
  10496e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  104972:	31 d2                	xor    %edx,%edx
  104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  104978:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  10497b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10497e:	39 ca                	cmp    %ecx,%edx
  104980:	75 f6                	jne    104978 <memset+0x18>
    *d++ = c;

  return dst;
}
  104982:	5b                   	pop    %ebx
  104983:	5d                   	pop    %ebp
  104984:	c3                   	ret    
  104985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104990:	55                   	push   %ebp
  104991:	89 e5                	mov    %esp,%ebp
  104993:	57                   	push   %edi
  104994:	56                   	push   %esi
  104995:	53                   	push   %ebx
  104996:	8b 55 10             	mov    0x10(%ebp),%edx
  104999:	8b 75 08             	mov    0x8(%ebp),%esi
  10499c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10499f:	85 d2                	test   %edx,%edx
  1049a1:	74 2d                	je     1049d0 <memcmp+0x40>
    if(*s1 != *s2)
  1049a3:	0f b6 1e             	movzbl (%esi),%ebx
  1049a6:	0f b6 0f             	movzbl (%edi),%ecx
  1049a9:	38 cb                	cmp    %cl,%bl
  1049ab:	75 2b                	jne    1049d8 <memcmp+0x48>
      return *s1 - *s2;
  1049ad:	83 ea 01             	sub    $0x1,%edx
  1049b0:	31 c0                	xor    %eax,%eax
  1049b2:	eb 18                	jmp    1049cc <memcmp+0x3c>
  1049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1049b8:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  1049bd:	83 ea 01             	sub    $0x1,%edx
  1049c0:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  1049c5:	83 c0 01             	add    $0x1,%eax
  1049c8:	38 cb                	cmp    %cl,%bl
  1049ca:	75 0c                	jne    1049d8 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1049cc:	85 d2                	test   %edx,%edx
  1049ce:	75 e8                	jne    1049b8 <memcmp+0x28>
  1049d0:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1049d2:	5b                   	pop    %ebx
  1049d3:	5e                   	pop    %esi
  1049d4:	5f                   	pop    %edi
  1049d5:	5d                   	pop    %ebp
  1049d6:	c3                   	ret    
  1049d7:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1049d8:	0f b6 c3             	movzbl %bl,%eax
  1049db:	0f b6 c9             	movzbl %cl,%ecx
  1049de:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  1049e0:	5b                   	pop    %ebx
  1049e1:	5e                   	pop    %esi
  1049e2:	5f                   	pop    %edi
  1049e3:	5d                   	pop    %ebp
  1049e4:	c3                   	ret    
  1049e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001049f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	57                   	push   %edi
  1049f4:	56                   	push   %esi
  1049f5:	53                   	push   %ebx
  1049f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1049f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  1049fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1049ff:	39 c6                	cmp    %eax,%esi
  104a01:	73 2d                	jae    104a30 <memmove+0x40>
  104a03:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104a06:	39 f8                	cmp    %edi,%eax
  104a08:	73 26                	jae    104a30 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  104a0a:	85 db                	test   %ebx,%ebx
  104a0c:	74 1d                	je     104a2b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  104a0e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104a11:	31 d2                	xor    %edx,%edx
  104a13:	90                   	nop
  104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104a18:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  104a1d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104a21:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104a24:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104a27:	85 c9                	test   %ecx,%ecx
  104a29:	75 ed                	jne    104a18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  104a2b:	5b                   	pop    %ebx
  104a2c:	5e                   	pop    %esi
  104a2d:	5f                   	pop    %edi
  104a2e:	5d                   	pop    %ebp
  104a2f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104a30:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104a32:	85 db                	test   %ebx,%ebx
  104a34:	74 f5                	je     104a2b <memmove+0x3b>
  104a36:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104a38:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  104a3c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  104a3f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104a42:	39 d3                	cmp    %edx,%ebx
  104a44:	75 f2                	jne    104a38 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104a46:	5b                   	pop    %ebx
  104a47:	5e                   	pop    %esi
  104a48:	5f                   	pop    %edi
  104a49:	5d                   	pop    %ebp
  104a4a:	c3                   	ret    
  104a4b:	90                   	nop
  104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104a50 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104a50:	55                   	push   %ebp
  104a51:	89 e5                	mov    %esp,%ebp
  104a53:	57                   	push   %edi
  104a54:	56                   	push   %esi
  104a55:	53                   	push   %ebx
  104a56:	8b 7d 10             	mov    0x10(%ebp),%edi
  104a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104a5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  104a5f:	85 ff                	test   %edi,%edi
  104a61:	74 3d                	je     104aa0 <strncmp+0x50>
  104a63:	0f b6 01             	movzbl (%ecx),%eax
  104a66:	84 c0                	test   %al,%al
  104a68:	75 18                	jne    104a82 <strncmp+0x32>
  104a6a:	eb 3c                	jmp    104aa8 <strncmp+0x58>
  104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104a70:	83 ef 01             	sub    $0x1,%edi
  104a73:	74 2b                	je     104aa0 <strncmp+0x50>
    n--, p++, q++;
  104a75:	83 c1 01             	add    $0x1,%ecx
  104a78:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104a7b:	0f b6 01             	movzbl (%ecx),%eax
  104a7e:	84 c0                	test   %al,%al
  104a80:	74 26                	je     104aa8 <strncmp+0x58>
  104a82:	0f b6 33             	movzbl (%ebx),%esi
  104a85:	89 f2                	mov    %esi,%edx
  104a87:	38 d0                	cmp    %dl,%al
  104a89:	74 e5                	je     104a70 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  104a8b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  104a91:	0f b6 c0             	movzbl %al,%eax
  104a94:	29 f0                	sub    %esi,%eax
}
  104a96:	5b                   	pop    %ebx
  104a97:	5e                   	pop    %esi
  104a98:	5f                   	pop    %edi
  104a99:	5d                   	pop    %ebp
  104a9a:	c3                   	ret    
  104a9b:	90                   	nop
  104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104aa0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  104aa2:	5b                   	pop    %ebx
  104aa3:	5e                   	pop    %esi
  104aa4:	5f                   	pop    %edi
  104aa5:	5d                   	pop    %ebp
  104aa6:	c3                   	ret    
  104aa7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104aa8:	0f b6 33             	movzbl (%ebx),%esi
  104aab:	eb de                	jmp    104a8b <strncmp+0x3b>
  104aad:	8d 76 00             	lea    0x0(%esi),%esi

00104ab0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  104ab0:	55                   	push   %ebp
  104ab1:	89 e5                	mov    %esp,%ebp
  104ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  104ab6:	56                   	push   %esi
  104ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104aba:	53                   	push   %ebx
  104abb:	8b 75 0c             	mov    0xc(%ebp),%esi
  104abe:	89 c3                	mov    %eax,%ebx
  104ac0:	eb 09                	jmp    104acb <strncpy+0x1b>
  104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104ac8:	83 c6 01             	add    $0x1,%esi
  104acb:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104ace:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104ad1:	85 d2                	test   %edx,%edx
  104ad3:	7e 0c                	jle    104ae1 <strncpy+0x31>
  104ad5:	0f b6 16             	movzbl (%esi),%edx
  104ad8:	88 13                	mov    %dl,(%ebx)
  104ada:	83 c3 01             	add    $0x1,%ebx
  104add:	84 d2                	test   %dl,%dl
  104adf:	75 e7                	jne    104ac8 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104ae1:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104ae3:	85 c9                	test   %ecx,%ecx
  104ae5:	7e 0c                	jle    104af3 <strncpy+0x43>
  104ae7:	90                   	nop
    *s++ = 0;
  104ae8:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  104aec:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104aef:	39 ca                	cmp    %ecx,%edx
  104af1:	75 f5                	jne    104ae8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104af3:	5b                   	pop    %ebx
  104af4:	5e                   	pop    %esi
  104af5:	5d                   	pop    %ebp
  104af6:	c3                   	ret    
  104af7:	89 f6                	mov    %esi,%esi
  104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104b00:	55                   	push   %ebp
  104b01:	89 e5                	mov    %esp,%ebp
  104b03:	8b 55 10             	mov    0x10(%ebp),%edx
  104b06:	56                   	push   %esi
  104b07:	8b 45 08             	mov    0x8(%ebp),%eax
  104b0a:	53                   	push   %ebx
  104b0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  104b0e:	85 d2                	test   %edx,%edx
  104b10:	7e 1f                	jle    104b31 <safestrcpy+0x31>
  104b12:	89 c1                	mov    %eax,%ecx
  104b14:	eb 05                	jmp    104b1b <safestrcpy+0x1b>
  104b16:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104b18:	83 c6 01             	add    $0x1,%esi
  104b1b:	83 ea 01             	sub    $0x1,%edx
  104b1e:	85 d2                	test   %edx,%edx
  104b20:	7e 0c                	jle    104b2e <safestrcpy+0x2e>
  104b22:	0f b6 1e             	movzbl (%esi),%ebx
  104b25:	88 19                	mov    %bl,(%ecx)
  104b27:	83 c1 01             	add    $0x1,%ecx
  104b2a:	84 db                	test   %bl,%bl
  104b2c:	75 ea                	jne    104b18 <safestrcpy+0x18>
    ;
  *s = 0;
  104b2e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104b31:	5b                   	pop    %ebx
  104b32:	5e                   	pop    %esi
  104b33:	5d                   	pop    %ebp
  104b34:	c3                   	ret    
  104b35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b40 <strlen>:

int
strlen(const char *s)
{
  104b40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104b41:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104b43:	89 e5                	mov    %esp,%ebp
  104b45:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104b48:	80 3a 00             	cmpb   $0x0,(%edx)
  104b4b:	74 0c                	je     104b59 <strlen+0x19>
  104b4d:	8d 76 00             	lea    0x0(%esi),%esi
  104b50:	83 c0 01             	add    $0x1,%eax
  104b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104b57:	75 f7                	jne    104b50 <strlen+0x10>
    ;
  return n;
}
  104b59:	5d                   	pop    %ebp
  104b5a:	c3                   	ret    
  104b5b:	90                   	nop

00104b5c <swtch>:
  104b5c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104b60:	8f 00                	popl   (%eax)
  104b62:	89 60 04             	mov    %esp,0x4(%eax)
  104b65:	89 58 08             	mov    %ebx,0x8(%eax)
  104b68:	89 48 0c             	mov    %ecx,0xc(%eax)
  104b6b:	89 50 10             	mov    %edx,0x10(%eax)
  104b6e:	89 70 14             	mov    %esi,0x14(%eax)
  104b71:	89 78 18             	mov    %edi,0x18(%eax)
  104b74:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104b77:	8b 44 24 04          	mov    0x4(%esp),%eax
  104b7b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  104b7e:	8b 78 18             	mov    0x18(%eax),%edi
  104b81:	8b 70 14             	mov    0x14(%eax),%esi
  104b84:	8b 50 10             	mov    0x10(%eax),%edx
  104b87:	8b 48 0c             	mov    0xc(%eax),%ecx
  104b8a:	8b 58 08             	mov    0x8(%eax),%ebx
  104b8d:	8b 60 04             	mov    0x4(%eax),%esp
  104b90:	ff 30                	pushl  (%eax)
  104b92:	c3                   	ret    
  104b93:	90                   	nop
  104b94:	90                   	nop
  104b95:	90                   	nop
  104b96:	90                   	nop
  104b97:	90                   	nop
  104b98:	90                   	nop
  104b99:	90                   	nop
  104b9a:	90                   	nop
  104b9b:	90                   	nop
  104b9c:	90                   	nop
  104b9d:	90                   	nop
  104b9e:	90                   	nop
  104b9f:	90                   	nop

00104ba0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104ba0:	55                   	push   %ebp
  104ba1:	89 e5                	mov    %esp,%ebp
  104ba3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104ba6:	53                   	push   %ebx
  104ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  104baa:	8b 51 04             	mov    0x4(%ecx),%edx
  104bad:	39 c2                	cmp    %eax,%edx
  104baf:	77 0f                	ja     104bc0 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104bb6:	5b                   	pop    %ebx
  104bb7:	5d                   	pop    %ebp
  104bb8:	c3                   	ret    
  104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104bc0:	8d 58 04             	lea    0x4(%eax),%ebx
  104bc3:	39 da                	cmp    %ebx,%edx
  104bc5:	72 ea                	jb     104bb1 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104bc7:	8b 11                	mov    (%ecx),%edx
  104bc9:	8b 14 02             	mov    (%edx,%eax,1),%edx
  104bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  104bcf:	89 10                	mov    %edx,(%eax)
  104bd1:	31 c0                	xor    %eax,%eax
  return 0;
  104bd3:	eb e1                	jmp    104bb6 <fetchint+0x16>
  104bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104be0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104be0:	55                   	push   %ebp
  104be1:	89 e5                	mov    %esp,%ebp
  104be3:	8b 45 08             	mov    0x8(%ebp),%eax
  104be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  104be9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  104bea:	39 50 04             	cmp    %edx,0x4(%eax)
  104bed:	77 09                	ja     104bf8 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104bef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104bf4:	5b                   	pop    %ebx
  104bf5:	5d                   	pop    %ebp
  104bf6:	c3                   	ret    
  104bf7:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104bfb:	03 10                	add    (%eax),%edx
  104bfd:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  104bff:	8b 18                	mov    (%eax),%ebx
  104c01:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104c04:	39 da                	cmp    %ebx,%edx
  104c06:	73 e7                	jae    104bef <fetchstr+0xf>
    if(*s == 0)
  104c08:	31 c0                	xor    %eax,%eax
  104c0a:	89 d1                	mov    %edx,%ecx
  104c0c:	80 3a 00             	cmpb   $0x0,(%edx)
  104c0f:	74 e3                	je     104bf4 <fetchstr+0x14>
  104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104c18:	83 c1 01             	add    $0x1,%ecx
  104c1b:	39 cb                	cmp    %ecx,%ebx
  104c1d:	76 d0                	jbe    104bef <fetchstr+0xf>
    if(*s == 0)
  104c1f:	80 39 00             	cmpb   $0x0,(%ecx)
  104c22:	75 f4                	jne    104c18 <fetchstr+0x38>
  104c24:	89 c8                	mov    %ecx,%eax
  104c26:	29 d0                	sub    %edx,%eax
  104c28:	eb ca                	jmp    104bf4 <fetchstr+0x14>
  104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c30 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104c30:	55                   	push   %ebp
  104c31:	89 e5                	mov    %esp,%ebp
  104c33:	53                   	push   %ebx
  104c34:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104c37:	e8 74 ec ff ff       	call   1038b0 <curproc>
  104c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  104c3f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104c45:	8b 40 3c             	mov    0x3c(%eax),%eax
  104c48:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  104c4c:	e8 5f ec ff ff       	call   1038b0 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104c51:	8b 50 04             	mov    0x4(%eax),%edx
  104c54:	39 d3                	cmp    %edx,%ebx
  104c56:	72 10                	jb     104c68 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  104c5d:	83 c4 04             	add    $0x4,%esp
  104c60:	5b                   	pop    %ebx
  104c61:	5d                   	pop    %ebp
  104c62:	c3                   	ret    
  104c63:	90                   	nop
  104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104c68:	8d 4b 04             	lea    0x4(%ebx),%ecx
  104c6b:	39 ca                	cmp    %ecx,%edx
  104c6d:	72 e9                	jb     104c58 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104c6f:	8b 00                	mov    (%eax),%eax
  104c71:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  104c77:	89 10                	mov    %edx,(%eax)
  104c79:	31 c0                	xor    %eax,%eax
  104c7b:	eb e0                	jmp    104c5d <argint+0x2d>
  104c7d:	8d 76 00             	lea    0x0(%esi),%esi

00104c80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104c80:	55                   	push   %ebp
  104c81:	89 e5                	mov    %esp,%ebp
  104c83:	53                   	push   %ebx
  104c84:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  104c91:	89 04 24             	mov    %eax,(%esp)
  104c94:	e8 97 ff ff ff       	call   104c30 <argint>
  104c99:	85 c0                	test   %eax,%eax
  104c9b:	78 3b                	js     104cd8 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  104c9d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ca0:	e8 0b ec ff ff       	call   1038b0 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104ca5:	3b 58 04             	cmp    0x4(%eax),%ebx
  104ca8:	73 2e                	jae    104cd8 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  104caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  104cad:	03 18                	add    (%eax),%ebx
  104caf:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104cb1:	8b 08                	mov    (%eax),%ecx
  104cb3:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104cb6:	39 cb                	cmp    %ecx,%ebx
  104cb8:	73 1e                	jae    104cd8 <argstr+0x58>
    if(*s == 0)
  104cba:	31 c0                	xor    %eax,%eax
  104cbc:	89 da                	mov    %ebx,%edx
  104cbe:	80 3b 00             	cmpb   $0x0,(%ebx)
  104cc1:	75 0a                	jne    104ccd <argstr+0x4d>
  104cc3:	eb 18                	jmp    104cdd <argstr+0x5d>
  104cc5:	8d 76 00             	lea    0x0(%esi),%esi
  104cc8:	80 3a 00             	cmpb   $0x0,(%edx)
  104ccb:	74 1b                	je     104ce8 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104ccd:	83 c2 01             	add    $0x1,%edx
  104cd0:	39 d1                	cmp    %edx,%ecx
  104cd2:	77 f4                	ja     104cc8 <argstr+0x48>
  104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104cd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104cdd:	83 c4 24             	add    $0x24,%esp
  104ce0:	5b                   	pop    %ebx
  104ce1:	5d                   	pop    %ebp
  104ce2:	c3                   	ret    
  104ce3:	90                   	nop
  104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104ce8:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104cea:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104ced:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104cef:	5b                   	pop    %ebx
  104cf0:	5d                   	pop    %ebp
  104cf1:	c3                   	ret    
  104cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104d00:	55                   	push   %ebp
  104d01:	89 e5                	mov    %esp,%ebp
  104d03:	53                   	push   %ebx
  104d04:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104d07:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  104d11:	89 04 24             	mov    %eax,(%esp)
  104d14:	e8 17 ff ff ff       	call   104c30 <argint>
  104d19:	85 c0                	test   %eax,%eax
  104d1b:	79 0b                	jns    104d28 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  104d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d22:	83 c4 24             	add    $0x24,%esp
  104d25:	5b                   	pop    %ebx
  104d26:	5d                   	pop    %ebp
  104d27:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104d28:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d2b:	e8 80 eb ff ff       	call   1038b0 <curproc>
  104d30:	3b 58 04             	cmp    0x4(%eax),%ebx
  104d33:	73 e8                	jae    104d1d <argptr+0x1d>
  104d35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104d38:	03 5d f4             	add    -0xc(%ebp),%ebx
  104d3b:	e8 70 eb ff ff       	call   1038b0 <curproc>
  104d40:	3b 58 04             	cmp    0x4(%eax),%ebx
  104d43:	73 d8                	jae    104d1d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104d45:	e8 66 eb ff ff       	call   1038b0 <curproc>
  104d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  104d4d:	8b 00                	mov    (%eax),%eax
  104d4f:	03 45 f4             	add    -0xc(%ebp),%eax
  104d52:	89 02                	mov    %eax,(%edx)
  104d54:	31 c0                	xor    %eax,%eax
  return 0;
  104d56:	eb ca                	jmp    104d22 <argptr+0x22>
  104d58:	90                   	nop
  104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104d60 <syscall>:
[SYS_log_init]		sys_log_init,
};

void
syscall(void)
{
  104d60:	55                   	push   %ebp
  104d61:	89 e5                	mov    %esp,%ebp
  104d63:	83 ec 18             	sub    $0x18,%esp
  104d66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104d69:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  104d6c:	e8 3f eb ff ff       	call   1038b0 <curproc>
  104d71:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104d77:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104d7a:	83 fb 1c             	cmp    $0x1c,%ebx
  104d7d:	77 29                	ja     104da8 <syscall+0x48>
  104d7f:	8b 34 9d 00 71 10 00 	mov    0x107100(,%ebx,4),%esi
  104d86:	85 f6                	test   %esi,%esi
  104d88:	74 1e                	je     104da8 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  104d8a:	e8 21 eb ff ff       	call   1038b0 <curproc>
  104d8f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104d95:	ff d6                	call   *%esi
  104d97:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104d9a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104d9d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104da0:	89 ec                	mov    %ebp,%esp
  104da2:	5d                   	pop    %ebp
  104da3:	c3                   	ret    
  104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104da8:	e8 03 eb ff ff       	call   1038b0 <curproc>
  104dad:	89 c6                	mov    %eax,%esi
  104daf:	e8 fc ea ff ff       	call   1038b0 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104db4:	81 c6 88 00 00 00    	add    $0x88,%esi
  104dba:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104dbe:	89 74 24 08          	mov    %esi,0x8(%esp)
  104dc2:	8b 40 10             	mov    0x10(%eax),%eax
  104dc5:	c7 04 24 d6 70 10 00 	movl   $0x1070d6,(%esp)
  104dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dd0:	e8 eb b9 ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104dd5:	e8 d6 ea ff ff       	call   1038b0 <curproc>
  104dda:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104de0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104de7:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104dea:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104ded:	89 ec                	mov    %ebp,%esp
  104def:	5d                   	pop    %ebp
  104df0:	c3                   	ret    
  104df1:	90                   	nop
  104df2:	90                   	nop
  104df3:	90                   	nop
  104df4:	90                   	nop
  104df5:	90                   	nop
  104df6:	90                   	nop
  104df7:	90                   	nop
  104df8:	90                   	nop
  104df9:	90                   	nop
  104dfa:	90                   	nop
  104dfb:	90                   	nop
  104dfc:	90                   	nop
  104dfd:	90                   	nop
  104dfe:	90                   	nop
  104dff:	90                   	nop

00104e00 <sys_log_init>:

	log_initialize();

}

void sys_log_init(void){
  104e00:	55                   	push   %ebp
  104e01:	89 e5                	mov    %esp,%ebp
  104e03:	83 ec 08             	sub    $0x8,%esp

	log_initialize();
	return;
}
  104e06:	c9                   	leave  

}

void sys_log_init(void){

	log_initialize();
  104e07:	e9 84 de ff ff       	jmp    102c90 <log_initialize>
  104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104e10 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104e10:	55                   	push   %ebp
  104e11:	89 e5                	mov    %esp,%ebp
  104e13:	57                   	push   %edi
  104e14:	89 c7                	mov    %eax,%edi
  104e16:	56                   	push   %esi
  104e17:	53                   	push   %ebx
  104e18:	31 db                	xor    %ebx,%ebx
  104e1a:	83 ec 0c             	sub    $0xc,%esp
  104e1d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104e20:	e8 8b ea ff ff       	call   1038b0 <curproc>
  104e25:	8d 73 08             	lea    0x8(%ebx),%esi
  104e28:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  104e2b:	85 c0                	test   %eax,%eax
  104e2d:	74 19                	je     104e48 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e2f:	83 c3 01             	add    $0x1,%ebx
  104e32:	83 fb 10             	cmp    $0x10,%ebx
  104e35:	75 e9                	jne    104e20 <fdalloc+0x10>
  104e37:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104e3c:	83 c4 0c             	add    $0xc,%esp
  104e3f:	89 d8                	mov    %ebx,%eax
  104e41:	5b                   	pop    %ebx
  104e42:	5e                   	pop    %esi
  104e43:	5f                   	pop    %edi
  104e44:	5d                   	pop    %ebp
  104e45:	c3                   	ret    
  104e46:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104e48:	e8 63 ea ff ff       	call   1038b0 <curproc>
  104e4d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  104e50:	83 c4 0c             	add    $0xc,%esp
  104e53:	89 d8                	mov    %ebx,%eax
  104e55:	5b                   	pop    %ebx
  104e56:	5e                   	pop    %esi
  104e57:	5f                   	pop    %edi
  104e58:	5d                   	pop    %ebp
  104e59:	c3                   	ret    
  104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104e60 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104e60:	55                   	push   %ebp
  104e61:	89 e5                	mov    %esp,%ebp
  104e63:	53                   	push   %ebx
  104e64:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104e67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e6a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104e71:	00 
  104e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e7d:	e8 7e fe ff ff       	call   104d00 <argptr>
  104e82:	85 c0                	test   %eax,%eax
  104e84:	79 12                	jns    104e98 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e8b:	83 c4 24             	add    $0x24,%esp
  104e8e:	5b                   	pop    %ebx
  104e8f:	5d                   	pop    %ebp
  104e90:	c3                   	ret    
  104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104e98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104e9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ea2:	89 04 24             	mov    %eax,(%esp)
  104ea5:	e8 56 e6 ff ff       	call   103500 <pipealloc>
  104eaa:	85 c0                	test   %eax,%eax
  104eac:	78 d8                	js     104e86 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104eb1:	e8 5a ff ff ff       	call   104e10 <fdalloc>
  104eb6:	85 c0                	test   %eax,%eax
  104eb8:	89 c3                	mov    %eax,%ebx
  104eba:	78 25                	js     104ee1 <sys_pipe+0x81>
  104ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ebf:	e8 4c ff ff ff       	call   104e10 <fdalloc>
  104ec4:	85 c0                	test   %eax,%eax
  104ec6:	78 0c                	js     104ed4 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  104ecb:	89 42 04             	mov    %eax,0x4(%edx)
  104ece:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104ed0:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104ed2:	eb b7                	jmp    104e8b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104ed4:	e8 d7 e9 ff ff       	call   1038b0 <curproc>
  104ed9:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104ee0:	00 
    fileclose(rf);
  104ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ee4:	89 04 24             	mov    %eax,(%esp)
  104ee7:	e8 f4 c1 ff ff       	call   1010e0 <fileclose>
    fileclose(wf);
  104eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104eef:	89 04 24             	mov    %eax,(%esp)
  104ef2:	e8 e9 c1 ff ff       	call   1010e0 <fileclose>
  104ef7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104efc:	eb 8d                	jmp    104e8b <sys_pipe+0x2b>
  104efe:	66 90                	xchg   %ax,%ax

00104f00 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104f00:	55                   	push   %ebp
  104f01:	89 e5                	mov    %esp,%ebp
  104f03:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104f09:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104f0c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104f0f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104f12:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f20:	e8 5b fd ff ff       	call   104c80 <argstr>
  104f25:	85 c0                	test   %eax,%eax
  104f27:	79 17                	jns    104f40 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104f2e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104f31:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104f34:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104f37:	89 ec                	mov    %ebp,%esp
  104f39:	5d                   	pop    %ebp
  104f3a:	c3                   	ret    
  104f3b:	90                   	nop
  104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104f40:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f4e:	e8 dd fc ff ff       	call   104c30 <argint>
  104f53:	85 c0                	test   %eax,%eax
  104f55:	78 d2                	js     104f29 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  104f57:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104f5a:	31 ff                	xor    %edi,%edi
  104f5c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104f63:	00 
  104f64:	31 db                	xor    %ebx,%ebx
  104f66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f6d:	00 
  104f6e:	89 04 24             	mov    %eax,(%esp)
  104f71:	e8 ea f9 ff ff       	call   104960 <memset>
  104f76:	eb 27                	jmp    104f9f <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104f78:	e8 33 e9 ff ff       	call   1038b0 <curproc>
  104f7d:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104f81:	89 54 24 08          	mov    %edx,0x8(%esp)
  104f85:	89 74 24 04          	mov    %esi,0x4(%esp)
  104f89:	89 04 24             	mov    %eax,(%esp)
  104f8c:	e8 4f fc ff ff       	call   104be0 <fetchstr>
  104f91:	85 c0                	test   %eax,%eax
  104f93:	78 94                	js     104f29 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104f95:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104f98:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104f9b:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  104f9d:	74 8a                	je     104f29 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104f9f:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104fa6:	03 75 e0             	add    -0x20(%ebp),%esi
  104fa9:	e8 02 e9 ff ff       	call   1038b0 <curproc>
  104fae:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104fb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104fb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104fb9:	89 04 24             	mov    %eax,(%esp)
  104fbc:	e8 df fb ff ff       	call   104ba0 <fetchint>
  104fc1:	85 c0                	test   %eax,%eax
  104fc3:	0f 88 60 ff ff ff    	js     104f29 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104fc9:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104fcc:	85 f6                	test   %esi,%esi
  104fce:	75 a8                	jne    104f78 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104fd0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104fda:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104fe1:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104fe2:	89 04 24             	mov    %eax,(%esp)
  104fe5:	e8 f6 b9 ff ff       	call   1009e0 <exec>
  104fea:	e9 3f ff ff ff       	jmp    104f2e <sys_exec+0x2e>
  104fef:	90                   	nop

00104ff0 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  104ff3:	53                   	push   %ebx
  104ff4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104ffa:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ffe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105005:	e8 76 fc ff ff       	call   104c80 <argstr>
  10500a:	85 c0                	test   %eax,%eax
  10500c:	79 12                	jns    105020 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  10500e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105013:	83 c4 24             	add    $0x24,%esp
  105016:	5b                   	pop    %ebx
  105017:	5d                   	pop    %ebp
  105018:	c3                   	ret    
  105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  105020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105023:	89 04 24             	mov    %eax,(%esp)
  105026:	e8 d5 d1 ff ff       	call   102200 <namei>
  10502b:	85 c0                	test   %eax,%eax
  10502d:	89 c3                	mov    %eax,%ebx
  10502f:	74 dd                	je     10500e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  105031:	89 04 24             	mov    %eax,(%esp)
  105034:	e8 07 cf ff ff       	call   101f40 <ilock>
  if(ip->type != T_DIR){
  105039:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10503e:	75 24                	jne    105064 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105040:	89 1c 24             	mov    %ebx,(%esp)
  105043:	e8 88 ce ff ff       	call   101ed0 <iunlock>
  iput(cp->cwd);
  105048:	e8 63 e8 ff ff       	call   1038b0 <curproc>
  10504d:	8b 40 60             	mov    0x60(%eax),%eax
  105050:	89 04 24             	mov    %eax,(%esp)
  105053:	e8 98 cb ff ff       	call   101bf0 <iput>
  cp->cwd = ip;
  105058:	e8 53 e8 ff ff       	call   1038b0 <curproc>
  10505d:	89 58 60             	mov    %ebx,0x60(%eax)
  105060:	31 c0                	xor    %eax,%eax
  return 0;
  105062:	eb af                	jmp    105013 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  105064:	89 1c 24             	mov    %ebx,(%esp)
  105067:	e8 b4 ce ff ff       	call   101f20 <iunlockput>
  10506c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  105071:	eb a0                	jmp    105013 <sys_chdir+0x23>
  105073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105080 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105080:	55                   	push   %ebp
  105081:	89 e5                	mov    %esp,%ebp
  105083:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105086:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105089:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10508c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10508f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105092:	89 44 24 04          	mov    %eax,0x4(%esp)
  105096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10509d:	e8 de fb ff ff       	call   104c80 <argstr>
  1050a2:	85 c0                	test   %eax,%eax
  1050a4:	79 12                	jns    1050b8 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  1050a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1050ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1050ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1050b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1050b4:	89 ec                	mov    %ebp,%esp
  1050b6:	5d                   	pop    %ebp
  1050b7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1050b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1050bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050c6:	e8 b5 fb ff ff       	call   104c80 <argstr>
  1050cb:	85 c0                	test   %eax,%eax
  1050cd:	78 d7                	js     1050a6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  1050cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050d2:	89 04 24             	mov    %eax,(%esp)
  1050d5:	e8 26 d1 ff ff       	call   102200 <namei>
  1050da:	85 c0                	test   %eax,%eax
  1050dc:	89 c3                	mov    %eax,%ebx
  1050de:	74 c6                	je     1050a6 <sys_link+0x26>
    return -1;
  ilock(ip);
  1050e0:	89 04 24             	mov    %eax,(%esp)
  1050e3:	e8 58 ce ff ff       	call   101f40 <ilock>
  if(ip->type == T_DIR){
  1050e8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1050ed:	0f 84 86 00 00 00    	je     105179 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  1050f3:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  1050f8:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  1050fb:	89 1c 24             	mov    %ebx,(%esp)
  1050fe:	e8 1d c6 ff ff       	call   101720 <iupdate>
  iunlock(ip);
  105103:	89 1c 24             	mov    %ebx,(%esp)
  105106:	e8 c5 cd ff ff       	call   101ed0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  10510b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10510e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105112:	89 04 24             	mov    %eax,(%esp)
  105115:	e8 c6 d0 ff ff       	call   1021e0 <nameiparent>
  10511a:	85 c0                	test   %eax,%eax
  10511c:	89 c6                	mov    %eax,%esi
  10511e:	74 44                	je     105164 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  105120:	89 04 24             	mov    %eax,(%esp)
  105123:	e8 18 ce ff ff       	call   101f40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  105128:	8b 06                	mov    (%esi),%eax
  10512a:	3b 03                	cmp    (%ebx),%eax
  10512c:	75 2e                	jne    10515c <sys_link+0xdc>
  10512e:	8b 43 04             	mov    0x4(%ebx),%eax
  105131:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105135:	89 34 24             	mov    %esi,(%esp)
  105138:	89 44 24 08          	mov    %eax,0x8(%esp)
  10513c:	e8 9f cc ff ff       	call   101de0 <dirlink>
  105141:	85 c0                	test   %eax,%eax
  105143:	78 17                	js     10515c <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  105145:	89 34 24             	mov    %esi,(%esp)
  105148:	e8 d3 cd ff ff       	call   101f20 <iunlockput>
  iput(ip);
  10514d:	89 1c 24             	mov    %ebx,(%esp)
  105150:	e8 9b ca ff ff       	call   101bf0 <iput>
  105155:	31 c0                	xor    %eax,%eax
  return 0;
  105157:	e9 4f ff ff ff       	jmp    1050ab <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  10515c:	89 34 24             	mov    %esi,(%esp)
  10515f:	e8 bc cd ff ff       	call   101f20 <iunlockput>
  ilock(ip);
  105164:	89 1c 24             	mov    %ebx,(%esp)
  105167:	e8 d4 cd ff ff       	call   101f40 <ilock>
  ip->nlink--;
  10516c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  105171:	89 1c 24             	mov    %ebx,(%esp)
  105174:	e8 a7 c5 ff ff       	call   101720 <iupdate>
  iunlockput(ip);
  105179:	89 1c 24             	mov    %ebx,(%esp)
  10517c:	e8 9f cd ff ff       	call   101f20 <iunlockput>
  105181:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  105184:	e9 22 ff ff ff       	jmp    1050ab <sys_link+0x2b>
  105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105190 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105190:	55                   	push   %ebp
  105191:	89 e5                	mov    %esp,%ebp
  105193:	57                   	push   %edi
  105194:	89 cf                	mov    %ecx,%edi
  105196:	56                   	push   %esi
  105197:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105198:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  10519a:	83 ec 4c             	sub    $0x4c,%esp
  10519d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1051a0:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1051a4:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  1051a7:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  1051ab:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  1051af:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1051b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  1051b7:	89 04 24             	mov    %eax,(%esp)
  1051ba:	e8 21 d0 ff ff       	call   1021e0 <nameiparent>
  1051bf:	85 c0                	test   %eax,%eax
  1051c1:	74 67                	je     10522a <create+0x9a>
    return 0;
  ilock(dp);
  1051c3:	89 04 24             	mov    %eax,(%esp)
  1051c6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1051c9:	e8 72 cd ff ff       	call   101f40 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  1051ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1051d1:	85 d2                	test   %edx,%edx
  1051d3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1051d6:	74 60                	je     105238 <create+0xa8>
  1051d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1051db:	89 14 24             	mov    %edx,(%esp)
  1051de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  1051e6:	e8 25 c7 ff ff       	call   101910 <dirlookup>
  1051eb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1051ee:	85 c0                	test   %eax,%eax
  1051f0:	89 c3                	mov    %eax,%ebx
  1051f2:	74 44                	je     105238 <create+0xa8>
    iunlockput(dp);
  1051f4:	89 14 24             	mov    %edx,(%esp)
  1051f7:	e8 24 cd ff ff       	call   101f20 <iunlockput>
    ilock(ip);
  1051fc:	89 1c 24             	mov    %ebx,(%esp)
  1051ff:	e8 3c cd ff ff       	call   101f40 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105204:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  105208:	0f 85 02 01 00 00    	jne    105310 <create+0x180>
  10520e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  105212:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105216:	0f 85 f4 00 00 00    	jne    105310 <create+0x180>
  10521c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  105220:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  105224:	0f 85 e6 00 00 00    	jne    105310 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10522a:	83 c4 4c             	add    $0x4c,%esp
  10522d:	89 d8                	mov    %ebx,%eax
  10522f:	5b                   	pop    %ebx
  105230:	5e                   	pop    %esi
  105231:	5f                   	pop    %edi
  105232:	5d                   	pop    %ebp
  105233:	c3                   	ret    
  105234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105238:	0f bf c7             	movswl %di,%eax
  10523b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10523f:	8b 02                	mov    (%edx),%eax
  105241:	89 04 24             	mov    %eax,(%esp)
  105244:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105247:	e8 14 c8 ff ff       	call   101a60 <ialloc>
  10524c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10524f:	85 c0                	test   %eax,%eax
  105251:	89 c3                	mov    %eax,%ebx
  105253:	74 50                	je     1052a5 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105255:	89 04 24             	mov    %eax,(%esp)
  105258:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10525b:	e8 e0 cc ff ff       	call   101f40 <ilock>
  ip->major = major;
  105260:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  105264:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  10526a:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10526e:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  105272:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105276:	89 1c 24             	mov    %ebx,(%esp)
  105279:	e8 a2 c4 ff ff       	call   101720 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  10527e:	8b 43 04             	mov    0x4(%ebx),%eax
  105281:	89 74 24 04          	mov    %esi,0x4(%esp)
  105285:	89 44 24 08          	mov    %eax,0x8(%esp)
  105289:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10528c:	89 14 24             	mov    %edx,(%esp)
  10528f:	e8 4c cb ff ff       	call   101de0 <dirlink>
  105294:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105297:	85 c0                	test   %eax,%eax
  105299:	0f 88 85 00 00 00    	js     105324 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  10529f:	66 83 ff 01          	cmp    $0x1,%di
  1052a3:	74 13                	je     1052b8 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  1052a5:	89 14 24             	mov    %edx,(%esp)
  1052a8:	e8 73 cc ff ff       	call   101f20 <iunlockput>
  return ip;
}
  1052ad:	83 c4 4c             	add    $0x4c,%esp
  1052b0:	89 d8                	mov    %ebx,%eax
  1052b2:	5b                   	pop    %ebx
  1052b3:	5e                   	pop    %esi
  1052b4:	5f                   	pop    %edi
  1052b5:	5d                   	pop    %ebp
  1052b6:	c3                   	ret    
  1052b7:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1052b8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  1052bd:	89 14 24             	mov    %edx,(%esp)
  1052c0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1052c3:	e8 58 c4 ff ff       	call   101720 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1052c8:	8b 43 04             	mov    0x4(%ebx),%eax
  1052cb:	c7 44 24 04 75 71 10 	movl   $0x107175,0x4(%esp)
  1052d2:	00 
  1052d3:	89 1c 24             	mov    %ebx,(%esp)
  1052d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052da:	e8 01 cb ff ff       	call   101de0 <dirlink>
  1052df:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1052e2:	85 c0                	test   %eax,%eax
  1052e4:	78 1e                	js     105304 <create+0x174>
  1052e6:	8b 42 04             	mov    0x4(%edx),%eax
  1052e9:	c7 44 24 04 74 71 10 	movl   $0x107174,0x4(%esp)
  1052f0:	00 
  1052f1:	89 1c 24             	mov    %ebx,(%esp)
  1052f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052f8:	e8 e3 ca ff ff       	call   101de0 <dirlink>
  1052fd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105300:	85 c0                	test   %eax,%eax
  105302:	79 a1                	jns    1052a5 <create+0x115>
      panic("create dots");
  105304:	c7 04 24 77 71 10 00 	movl   $0x107177,(%esp)
  10530b:	e8 50 b6 ff ff       	call   100960 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  105310:	89 1c 24             	mov    %ebx,(%esp)
  105313:	31 db                	xor    %ebx,%ebx
  105315:	e8 06 cc ff ff       	call   101f20 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10531a:	83 c4 4c             	add    $0x4c,%esp
  10531d:	89 d8                	mov    %ebx,%eax
  10531f:	5b                   	pop    %ebx
  105320:	5e                   	pop    %esi
  105321:	5f                   	pop    %edi
  105322:	5d                   	pop    %ebp
  105323:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105324:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  10532a:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10532d:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10532f:	e8 ec cb ff ff       	call   101f20 <iunlockput>
    iunlockput(dp);
  105334:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105337:	89 14 24             	mov    %edx,(%esp)
  10533a:	e8 e1 cb ff ff       	call   101f20 <iunlockput>
    return 0;
  10533f:	e9 e6 fe ff ff       	jmp    10522a <create+0x9a>
  105344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10534a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105350 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105350:	55                   	push   %ebp
  105351:	89 e5                	mov    %esp,%ebp
  105353:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105356:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105359:	89 44 24 04          	mov    %eax,0x4(%esp)
  10535d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105364:	e8 17 f9 ff ff       	call   104c80 <argstr>
  105369:	85 c0                	test   %eax,%eax
  10536b:	79 0b                	jns    105378 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  10536d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105372:	c9                   	leave  
  105373:	c3                   	ret    
  105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105378:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10537f:	00 
  105380:	31 d2                	xor    %edx,%edx
  105382:	b9 01 00 00 00       	mov    $0x1,%ecx
  105387:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10538e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105391:	e8 fa fd ff ff       	call   105190 <create>
  105396:	85 c0                	test   %eax,%eax
  105398:	74 d3                	je     10536d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  10539a:	89 04 24             	mov    %eax,(%esp)
  10539d:	e8 7e cb ff ff       	call   101f20 <iunlockput>
  1053a2:	31 c0                	xor    %eax,%eax
  return 0;
}
  1053a4:	c9                   	leave  
  1053a5:	c3                   	ret    
  1053a6:	8d 76 00             	lea    0x0(%esi),%esi
  1053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001053b0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1053b0:	55                   	push   %ebp
  1053b1:	89 e5                	mov    %esp,%ebp
  1053b3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1053b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1053b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053c4:	e8 b7 f8 ff ff       	call   104c80 <argstr>
  1053c9:	85 c0                	test   %eax,%eax
  1053cb:	79 0b                	jns    1053d8 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1053cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1053d2:	c9                   	leave  
  1053d3:	c3                   	ret    
  1053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  1053d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1053db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1053e6:	e8 45 f8 ff ff       	call   104c30 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1053eb:	85 c0                	test   %eax,%eax
  1053ed:	78 de                	js     1053cd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  1053ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1053f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053f6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053fd:	e8 2e f8 ff ff       	call   104c30 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105402:	85 c0                	test   %eax,%eax
  105404:	78 c7                	js     1053cd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  105406:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  10540a:	31 d2                	xor    %edx,%edx
  10540c:	b9 03 00 00 00       	mov    $0x3,%ecx
  105411:	89 44 24 04          	mov    %eax,0x4(%esp)
  105415:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  105419:	89 04 24             	mov    %eax,(%esp)
  10541c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10541f:	e8 6c fd ff ff       	call   105190 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105424:	85 c0                	test   %eax,%eax
  105426:	74 a5                	je     1053cd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105428:	89 04 24             	mov    %eax,(%esp)
  10542b:	e8 f0 ca ff ff       	call   101f20 <iunlockput>
  105430:	31 c0                	xor    %eax,%eax
  return 0;
}
  105432:	c9                   	leave  
  105433:	c3                   	ret    
  105434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10543a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105440 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105440:	55                   	push   %ebp
  105441:	89 e5                	mov    %esp,%ebp
  105443:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105449:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10544c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10544f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10545a:	e8 21 f8 ff ff       	call   104c80 <argstr>
  10545f:	85 c0                	test   %eax,%eax
  105461:	79 15                	jns    105478 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105468:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10546b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10546e:	89 ec                	mov    %ebp,%esp
  105470:	5d                   	pop    %ebp
  105471:	c3                   	ret    
  105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105478:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10547b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10547f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105486:	e8 a5 f7 ff ff       	call   104c30 <argint>
  10548b:	85 c0                	test   %eax,%eax
  10548d:	78 d4                	js     105463 <sys_open+0x23>
    return -1;

  //cprintf("%s\n", path);

  if(omode & O_CREATE){
  10548f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  105493:	74 7b                	je     105510 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105498:	b9 02 00 00 00       	mov    $0x2,%ecx
  10549d:	ba 01 00 00 00       	mov    $0x1,%edx
  1054a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054a9:	00 
  1054aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054b1:	e8 da fc ff ff       	call   105190 <create>
  1054b6:	85 c0                	test   %eax,%eax
  1054b8:	89 c6                	mov    %eax,%esi
  1054ba:	74 a7                	je     105463 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1054bc:	e8 8f bb ff ff       	call   101050 <filealloc>
  1054c1:	85 c0                	test   %eax,%eax
  1054c3:	89 c3                	mov    %eax,%ebx
  1054c5:	74 73                	je     10553a <sys_open+0xfa>
  1054c7:	e8 44 f9 ff ff       	call   104e10 <fdalloc>
  1054cc:	85 c0                	test   %eax,%eax
  1054ce:	66 90                	xchg   %ax,%ax
  1054d0:	78 7d                	js     10554f <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1054d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054d5:	89 34 24             	mov    %esi,(%esp)
  1054d8:	e8 f3 c9 ff ff       	call   101ed0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1054dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  1054e0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  1054e6:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  1054e9:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  1054f0:	89 d1                	mov    %edx,%ecx
  1054f2:	83 f1 01             	xor    $0x1,%ecx
  1054f5:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1054f8:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1054fb:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1054fe:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105505:	e9 5e ff ff ff       	jmp    105468 <sys_open+0x28>
  10550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105513:	89 04 24             	mov    %eax,(%esp)
  105516:	e8 e5 cc ff ff       	call   102200 <namei>
  10551b:	85 c0                	test   %eax,%eax
  10551d:	89 c6                	mov    %eax,%esi
  10551f:	0f 84 3e ff ff ff    	je     105463 <sys_open+0x23>
      return -1;
    ilock(ip);
  105525:	89 04 24             	mov    %eax,(%esp)
  105528:	e8 13 ca ff ff       	call   101f40 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  10552d:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105532:	75 88                	jne    1054bc <sys_open+0x7c>
  105534:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  105538:	74 82                	je     1054bc <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  10553a:	89 34 24             	mov    %esi,(%esp)
  10553d:	8d 76 00             	lea    0x0(%esi),%esi
  105540:	e8 db c9 ff ff       	call   101f20 <iunlockput>
  105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  10554a:	e9 19 ff ff ff       	jmp    105468 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10554f:	89 1c 24             	mov    %ebx,(%esp)
  105552:	e8 89 bb ff ff       	call   1010e0 <fileclose>
  105557:	eb e1                	jmp    10553a <sys_open+0xfa>
  105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105560 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105560:	55                   	push   %ebp
  105561:	89 e5                	mov    %esp,%ebp
  105563:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105566:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105569:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10556c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10556f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105572:	89 44 24 04          	mov    %eax,0x4(%esp)
  105576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10557d:	e8 fe f6 ff ff       	call   104c80 <argstr>
  105582:	85 c0                	test   %eax,%eax
  105584:	79 12                	jns    105598 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10558b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10558e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105591:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105594:	89 ec                	mov    %ebp,%esp
  105596:	5d                   	pop    %ebp
  105597:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  105598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10559b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  10559e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1055a2:	89 04 24             	mov    %eax,(%esp)
  1055a5:	e8 36 cc ff ff       	call   1021e0 <nameiparent>
  1055aa:	85 c0                	test   %eax,%eax
  1055ac:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1055af:	74 d5                	je     105586 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1055b1:	89 04 24             	mov    %eax,(%esp)
  1055b4:	e8 87 c9 ff ff       	call   101f40 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1055b9:	c7 44 24 04 75 71 10 	movl   $0x107175,0x4(%esp)
  1055c0:	00 
  1055c1:	89 1c 24             	mov    %ebx,(%esp)
  1055c4:	e8 17 c3 ff ff       	call   1018e0 <namecmp>
  1055c9:	85 c0                	test   %eax,%eax
  1055cb:	0f 84 a4 00 00 00    	je     105675 <sys_unlink+0x115>
  1055d1:	c7 44 24 04 74 71 10 	movl   $0x107174,0x4(%esp)
  1055d8:	00 
  1055d9:	89 1c 24             	mov    %ebx,(%esp)
  1055dc:	e8 ff c2 ff ff       	call   1018e0 <namecmp>
  1055e1:	85 c0                	test   %eax,%eax
  1055e3:	0f 84 8c 00 00 00    	je     105675 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  1055e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1055ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1055f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1055f7:	89 04 24             	mov    %eax,(%esp)
  1055fa:	e8 11 c3 ff ff       	call   101910 <dirlookup>
  1055ff:	85 c0                	test   %eax,%eax
  105601:	89 c6                	mov    %eax,%esi
  105603:	74 70                	je     105675 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105605:	89 04 24             	mov    %eax,(%esp)
  105608:	e8 33 c9 ff ff       	call   101f40 <ilock>

  if(ip->nlink < 1)
  10560d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105612:	0f 8e e9 00 00 00    	jle    105701 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105618:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  10561d:	75 71                	jne    105690 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10561f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105623:	76 6b                	jbe    105690 <sys_unlink+0x130>
  105625:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  105628:	bb 20 00 00 00       	mov    $0x20,%ebx
  10562d:	8d 76 00             	lea    0x0(%esi),%esi
  105630:	eb 0e                	jmp    105640 <sys_unlink+0xe0>
  105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105638:	83 c3 10             	add    $0x10,%ebx
  10563b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10563e:	73 50                	jae    105690 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105640:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105647:	00 
  105648:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10564c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105650:	89 34 24             	mov    %esi,(%esp)
  105653:	e8 b8 bf ff ff       	call   101610 <readi>
  105658:	83 f8 10             	cmp    $0x10,%eax
  10565b:	0f 85 94 00 00 00    	jne    1056f5 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  105661:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  105666:	74 d0                	je     105638 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105668:	89 34 24             	mov    %esi,(%esp)
  10566b:	90                   	nop
  10566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105670:	e8 ab c8 ff ff       	call   101f20 <iunlockput>
    iunlockput(dp);
  105675:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105678:	89 04 24             	mov    %eax,(%esp)
  10567b:	e8 a0 c8 ff ff       	call   101f20 <iunlockput>
  105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  105685:	e9 01 ff ff ff       	jmp    10558b <sys_unlink+0x2b>
  10568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  105690:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  105693:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10569a:	00 
  10569b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1056a2:	00 
  1056a3:	89 1c 24             	mov    %ebx,(%esp)
  1056a6:	e8 b5 f2 ff ff       	call   104960 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1056ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056ae:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1056b5:	00 
  1056b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1056ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1056c1:	89 04 24             	mov    %eax,(%esp)
  1056c4:	e8 e7 c0 ff ff       	call   1017b0 <writei>
  1056c9:	83 f8 10             	cmp    $0x10,%eax
  1056cc:	75 3f                	jne    10570d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  1056ce:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1056d1:	89 04 24             	mov    %eax,(%esp)
  1056d4:	e8 47 c8 ff ff       	call   101f20 <iunlockput>

  ip->nlink--;
  1056d9:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1056de:	89 34 24             	mov    %esi,(%esp)
  1056e1:	e8 3a c0 ff ff       	call   101720 <iupdate>
  iunlockput(ip);
  1056e6:	89 34 24             	mov    %esi,(%esp)
  1056e9:	e8 32 c8 ff ff       	call   101f20 <iunlockput>
  1056ee:	31 c0                	xor    %eax,%eax
  return 0;
  1056f0:	e9 96 fe ff ff       	jmp    10558b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  1056f5:	c7 04 24 95 71 10 00 	movl   $0x107195,(%esp)
  1056fc:	e8 5f b2 ff ff       	call   100960 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105701:	c7 04 24 83 71 10 00 	movl   $0x107183,(%esp)
  105708:	e8 53 b2 ff ff       	call   100960 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  10570d:	c7 04 24 a7 71 10 00 	movl   $0x1071a7,(%esp)
  105714:	e8 47 b2 ff ff       	call   100960 <panic>
  105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105720 <T.63>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  105720:	55                   	push   %ebp
  105721:	89 e5                	mov    %esp,%ebp
  105723:	83 ec 28             	sub    $0x28,%esp
  105726:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105729:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10572b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  10572e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105731:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105733:	89 44 24 04          	mov    %eax,0x4(%esp)
  105737:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10573e:	e8 ed f4 ff ff       	call   104c30 <argint>
  105743:	85 c0                	test   %eax,%eax
  105745:	79 11                	jns    105758 <T.63+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  10574c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10574f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105752:	89 ec                	mov    %ebp,%esp
  105754:	5d                   	pop    %ebp
  105755:	c3                   	ret    
  105756:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105758:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  10575c:	77 e9                	ja     105747 <T.63+0x27>
  10575e:	e8 4d e1 ff ff       	call   1038b0 <curproc>
  105763:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  105766:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  10576a:	85 d2                	test   %edx,%edx
  10576c:	74 d9                	je     105747 <T.63+0x27>
    return -1;
  if(pfd)
  10576e:	85 db                	test   %ebx,%ebx
  105770:	74 02                	je     105774 <T.63+0x54>
    *pfd = fd;
  105772:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  105774:	31 c0                	xor    %eax,%eax
  105776:	85 f6                	test   %esi,%esi
  105778:	74 d2                	je     10574c <T.63+0x2c>
    *pf = f;
  10577a:	89 16                	mov    %edx,(%esi)
  10577c:	eb ce                	jmp    10574c <T.63+0x2c>
  10577e:	66 90                	xchg   %ax,%ax

00105780 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105780:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105781:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105783:	89 e5                	mov    %esp,%ebp
  105785:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105788:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10578b:	e8 90 ff ff ff       	call   105720 <T.63>
  105790:	85 c0                	test   %eax,%eax
  105792:	79 0c                	jns    1057a0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  105794:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105799:	c9                   	leave  
  10579a:	c3                   	ret    
  10579b:	90                   	nop
  10579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1057a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1057a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1057ae:	e8 7d f4 ff ff       	call   104c30 <argint>
  1057b3:	85 c0                	test   %eax,%eax
  1057b5:	78 dd                	js     105794 <sys_read+0x14>
  1057b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1057c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1057c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057cc:	e8 2f f5 ff ff       	call   104d00 <argptr>
  1057d1:	85 c0                	test   %eax,%eax
  1057d3:	78 bf                	js     105794 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  1057d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057e6:	89 04 24             	mov    %eax,(%esp)
  1057e9:	e8 12 b7 ff ff       	call   100f00 <fileread>
}
  1057ee:	c9                   	leave  
  1057ef:	c3                   	ret    

001057f0 <sys_write>:

int
sys_write(void)
{
  1057f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1057f1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1057f3:	89 e5                	mov    %esp,%ebp
  1057f5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1057f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1057fb:	e8 20 ff ff ff       	call   105720 <T.63>
  105800:	85 c0                	test   %eax,%eax
  105802:	79 0c                	jns    105810 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105804:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105809:	c9                   	leave  
  10580a:	c3                   	ret    
  10580b:	90                   	nop
  10580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105813:	89 44 24 04          	mov    %eax,0x4(%esp)
  105817:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10581e:	e8 0d f4 ff ff       	call   104c30 <argint>
  105823:	85 c0                	test   %eax,%eax
  105825:	78 dd                	js     105804 <sys_write+0x14>
  105827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10582a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105831:	89 44 24 08          	mov    %eax,0x8(%esp)
  105835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105838:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583c:	e8 bf f4 ff ff       	call   104d00 <argptr>
  105841:	85 c0                	test   %eax,%eax
  105843:	78 bf                	js     105804 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  105845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105848:	89 44 24 08          	mov    %eax,0x8(%esp)
  10584c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10584f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105856:	89 04 24             	mov    %eax,(%esp)
  105859:	e8 82 b5 ff ff       	call   100de0 <filewrite>
}
  10585e:	c9                   	leave  
  10585f:	c3                   	ret    

00105860 <sys_dup>:

int
sys_dup(void)
{
  105860:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105861:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105863:	89 e5                	mov    %esp,%ebp
  105865:	53                   	push   %ebx
  105866:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105869:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10586c:	e8 af fe ff ff       	call   105720 <T.63>
  105871:	85 c0                	test   %eax,%eax
  105873:	79 13                	jns    105888 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  105875:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10587a:	89 d8                	mov    %ebx,%eax
  10587c:	83 c4 24             	add    $0x24,%esp
  10587f:	5b                   	pop    %ebx
  105880:	5d                   	pop    %ebp
  105881:	c3                   	ret    
  105882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  105888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10588b:	e8 80 f5 ff ff       	call   104e10 <fdalloc>
  105890:	85 c0                	test   %eax,%eax
  105892:	89 c3                	mov    %eax,%ebx
  105894:	78 df                	js     105875 <sys_dup+0x15>
    return -1;
  filedup(f);
  105896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105899:	89 04 24             	mov    %eax,(%esp)
  10589c:	e8 5f b7 ff ff       	call   101000 <filedup>
  return fd;
  1058a1:	eb d7                	jmp    10587a <sys_dup+0x1a>
  1058a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001058b0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  1058b0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1058b1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  1058b3:	89 e5                	mov    %esp,%ebp
  1058b5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1058b8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1058bb:	e8 60 fe ff ff       	call   105720 <T.63>
  1058c0:	85 c0                	test   %eax,%eax
  1058c2:	79 0c                	jns    1058d0 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  1058c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1058c9:	c9                   	leave  
  1058ca:	c3                   	ret    
  1058cb:	90                   	nop
  1058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1058d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1058d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1058da:	00 
  1058db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1058e6:	e8 15 f4 ff ff       	call   104d00 <argptr>
  1058eb:	85 c0                	test   %eax,%eax
  1058ed:	78 d5                	js     1058c4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  1058ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058f9:	89 04 24             	mov    %eax,(%esp)
  1058fc:	e8 af b6 ff ff       	call   100fb0 <filestat>
}
  105901:	c9                   	leave  
  105902:	c3                   	ret    
  105903:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105910 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105910:	55                   	push   %ebp
  105911:	89 e5                	mov    %esp,%ebp
  105913:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105916:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105919:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10591c:	e8 ff fd ff ff       	call   105720 <T.63>
  105921:	89 c2                	mov    %eax,%edx
  105923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105928:	85 d2                	test   %edx,%edx
  10592a:	78 1d                	js     105949 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10592c:	e8 7f df ff ff       	call   1038b0 <curproc>
  105931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105934:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10593b:	00 
  fileclose(f);
  10593c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10593f:	89 04 24             	mov    %eax,(%esp)
  105942:	e8 99 b7 ff ff       	call   1010e0 <fileclose>
  105947:	31 c0                	xor    %eax,%eax
  return 0;
}
  105949:	c9                   	leave  
  10594a:	c3                   	ret    
  10594b:	90                   	nop
  10594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105950 <sys_check>:
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105950:	55                   	push   %ebp


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105951:	31 c0                	xor    %eax,%eax
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105953:	89 e5                	mov    %esp,%ebp
  105955:	83 ec 28             	sub    $0x28,%esp


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105958:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10595b:	e8 c0 fd ff ff       	call   105720 <T.63>
  105960:	85 c0                	test   %eax,%eax
  105962:	79 0c                	jns    105970 <sys_check+0x20>
		return -1;
	return filecheck(f, off);
  105964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	log_initialize();

}
  105969:	c9                   	leave  
  10596a:	c3                   	ret    
  10596b:	90                   	nop
  10596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi


	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105970:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105973:	89 44 24 04          	mov    %eax,0x4(%esp)
  105977:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10597e:	e8 ad f2 ff ff       	call   104c30 <argint>
  105983:	85 c0                	test   %eax,%eax
  105985:	78 dd                	js     105964 <sys_check+0x14>
		return -1;
	return filecheck(f, off);
  105987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10598a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10598e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105991:	89 04 24             	mov    %eax,(%esp)
  105994:	e8 f7 b4 ff ff       	call   100e90 <filecheck>

	log_initialize();

}
  105999:	c9                   	leave  
  10599a:	c3                   	ret    
  10599b:	90                   	nop
  10599c:	90                   	nop
  10599d:	90                   	nop
  10599e:	90                   	nop
  10599f:	90                   	nop

001059a0 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  1059a0:	55                   	push   %ebp
return ticks;
}
  1059a1:	a1 20 f3 10 00       	mov    0x10f320,%eax
	return 0;
}

int
sys_tick(void)
{
  1059a6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1059a8:	5d                   	pop    %ebp
  1059a9:	c3                   	ret    
  1059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001059b0 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  1059b0:	55                   	push   %ebp
  1059b1:	89 e5                	mov    %esp,%ebp
  1059b3:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  1059b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1059b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1059c4:	e8 67 f2 ff ff       	call   104c30 <argint>
  1059c9:	89 c2                	mov    %eax,%edx
  1059cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1059d0:	85 d2                	test   %edx,%edx
  1059d2:	78 0d                	js     1059e1 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  1059d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059d7:	89 04 24             	mov    %eax,(%esp)
  1059da:	e8 01 dc ff ff       	call   1035e0 <wake_lock>
  1059df:	31 c0                	xor    %eax,%eax

	return 0;
}
  1059e1:	c9                   	leave  
  1059e2:	c3                   	ret    
  1059e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001059f0 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  1059f0:	55                   	push   %ebp
  1059f1:	89 e5                	mov    %esp,%ebp
  1059f3:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  1059f6:	e8 15 e1 ff ff       	call   103b10 <sleep_lock>
	return 0;
}
  1059fb:	31 c0                	xor    %eax,%eax
  1059fd:	c9                   	leave  
  1059fe:	c3                   	ret    
  1059ff:	90                   	nop

00105a00 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105a00:	55                   	push   %ebp
  105a01:	89 e5                	mov    %esp,%ebp
  105a03:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105a06:	e8 a5 de ff ff       	call   1038b0 <curproc>
  105a0b:	8b 40 10             	mov    0x10(%eax),%eax
}
  105a0e:	c9                   	leave  
  105a0f:	c3                   	ret    

00105a10 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105a10:	55                   	push   %ebp
  105a11:	89 e5                	mov    %esp,%ebp
  105a13:	53                   	push   %ebx
  105a14:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105a17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105a25:	e8 06 f2 ff ff       	call   104c30 <argint>
  105a2a:	89 c2                	mov    %eax,%edx
  105a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105a31:	85 d2                	test   %edx,%edx
  105a33:	78 58                	js     105a8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105a35:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
  105a3c:	e8 af ee ff ff       	call   1048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105a44:	8b 1d 20 f3 10 00    	mov    0x10f320,%ebx
  while(ticks - ticks0 < n){
  105a4a:	85 d2                	test   %edx,%edx
  105a4c:	7f 22                	jg     105a70 <sys_sleep+0x60>
  105a4e:	eb 48                	jmp    105a98 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105a50:	c7 44 24 04 e0 ea 10 	movl   $0x10eae0,0x4(%esp)
  105a57:	00 
  105a58:	c7 04 24 20 f3 10 00 	movl   $0x10f320,(%esp)
  105a5f:	e8 fc e0 ff ff       	call   103b60 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105a64:	a1 20 f3 10 00       	mov    0x10f320,%eax
  105a69:	29 d8                	sub    %ebx,%eax
  105a6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  105a6e:	7d 28                	jge    105a98 <sys_sleep+0x88>
    if(cp->killed){
  105a70:	e8 3b de ff ff       	call   1038b0 <curproc>
  105a75:	8b 40 1c             	mov    0x1c(%eax),%eax
  105a78:	85 c0                	test   %eax,%eax
  105a7a:	74 d4                	je     105a50 <sys_sleep+0x40>
      release(&tickslock);
  105a7c:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
  105a83:	e8 28 ee ff ff       	call   1048b0 <release>
  105a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  105a8d:	83 c4 24             	add    $0x24,%esp
  105a90:	5b                   	pop    %ebx
  105a91:	5d                   	pop    %ebp
  105a92:	c3                   	ret    
  105a93:	90                   	nop
  105a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105a98:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
  105a9f:	e8 0c ee ff ff       	call   1048b0 <release>
  return 0;
}
  105aa4:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105aa7:	31 c0                	xor    %eax,%eax
  return 0;
}
  105aa9:	5b                   	pop    %ebx
  105aaa:	5d                   	pop    %ebp
  105aab:	c3                   	ret    
  105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105ab0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105ab0:	55                   	push   %ebp
  105ab1:	89 e5                	mov    %esp,%ebp
  105ab3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105ac4:	e8 67 f1 ff ff       	call   104c30 <argint>
  105ac9:	85 c0                	test   %eax,%eax
  105acb:	79 0b                	jns    105ad8 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  105acd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105ad2:	c9                   	leave  
  105ad3:	c3                   	ret    
  105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105adb:	89 04 24             	mov    %eax,(%esp)
  105ade:	e8 ed e6 ff ff       	call   1041d0 <growproc>
  105ae3:	85 c0                	test   %eax,%eax
  105ae5:	78 e6                	js     105acd <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105ae7:	c9                   	leave  
  105ae8:	c3                   	ret    
  105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105af0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105af0:	55                   	push   %ebp
  105af1:	89 e5                	mov    %esp,%ebp
  105af3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105afd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105b04:	e8 27 f1 ff ff       	call   104c30 <argint>
  105b09:	89 c2                	mov    %eax,%edx
  105b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105b10:	85 d2                	test   %edx,%edx
  105b12:	78 0b                	js     105b1f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b17:	89 04 24             	mov    %eax,(%esp)
  105b1a:	e8 01 dc ff ff       	call   103720 <kill>
}
  105b1f:	c9                   	leave  
  105b20:	c3                   	ret    
  105b21:	eb 0d                	jmp    105b30 <sys_wait>
  105b23:	90                   	nop
  105b24:	90                   	nop
  105b25:	90                   	nop
  105b26:	90                   	nop
  105b27:	90                   	nop
  105b28:	90                   	nop
  105b29:	90                   	nop
  105b2a:	90                   	nop
  105b2b:	90                   	nop
  105b2c:	90                   	nop
  105b2d:	90                   	nop
  105b2e:	90                   	nop
  105b2f:	90                   	nop

00105b30 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105b30:	55                   	push   %ebp
  105b31:	89 e5                	mov    %esp,%ebp
  105b33:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105b36:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105b37:	e9 f4 e1 ff ff       	jmp    103d30 <wait>
  105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105b40 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  105b40:	55                   	push   %ebp
  105b41:	89 e5                	mov    %esp,%ebp
  105b43:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  105b46:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  105b47:	e9 e4 e0 ff ff       	jmp    103c30 <wait_thread>
  105b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105b50 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105b50:	55                   	push   %ebp
  105b51:	89 e5                	mov    %esp,%ebp
  105b53:	83 ec 08             	sub    $0x8,%esp
  exit();
  105b56:	e8 55 de ff ff       	call   1039b0 <exit>
  return 0;  // not reached
}
  105b5b:	31 c0                	xor    %eax,%eax
  105b5d:	c9                   	leave  
  105b5e:	c3                   	ret    
  105b5f:	90                   	nop

00105b60 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105b60:	55                   	push   %ebp
  105b61:	89 e5                	mov    %esp,%ebp
  105b63:	53                   	push   %ebx
  105b64:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105b67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105b75:	e8 b6 f0 ff ff       	call   104c30 <argint>
  105b7a:	85 c0                	test   %eax,%eax
  105b7c:	79 12                	jns    105b90 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  105b7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105b83:	83 c4 24             	add    $0x24,%esp
  105b86:	5b                   	pop    %ebx
  105b87:	5d                   	pop    %ebp
  105b88:	c3                   	ret    
  105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105b90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105b93:	e8 18 dd ff ff       	call   1038b0 <curproc>
  105b98:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105b9c:	89 04 24             	mov    %eax,(%esp)
  105b9f:	e8 ec e6 ff ff       	call   104290 <copyproc_tix>
  105ba4:	85 c0                	test   %eax,%eax
  105ba6:	89 c2                	mov    %eax,%edx
  105ba8:	74 d4                	je     105b7e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  105baa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  105bad:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  105bb0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  105bb7:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  105bbd:	eb c4                	jmp    105b83 <sys_fork_tickets+0x23>
  105bbf:	90                   	nop

00105bc0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  105bc0:	55                   	push   %ebp
  105bc1:	89 e5                	mov    %esp,%ebp
  105bc3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105bc6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  105bc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105bcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105bcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105bdd:	e8 4e f0 ff ff       	call   104c30 <argint>
  105be2:	85 c0                	test   %eax,%eax
  105be4:	79 12                	jns    105bf8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105beb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105bee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105bf1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105bf4:	89 ec                	mov    %ebp,%esp
  105bf6:	5d                   	pop    %ebp
  105bf7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105bf8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  105bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c06:	e8 25 f0 ff ff       	call   104c30 <argint>
  105c0b:	85 c0                	test   %eax,%eax
  105c0d:	78 d7                	js     105be6 <sys_fork_thread+0x26>
  105c0f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  105c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c16:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105c1d:	e8 0e f0 ff ff       	call   104c30 <argint>
  105c22:	85 c0                	test   %eax,%eax
  105c24:	78 c0                	js     105be6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105c26:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105c29:	8b 75 e0             	mov    -0x20(%ebp),%esi
  105c2c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  105c2f:	e8 7c dc ff ff       	call   1038b0 <curproc>
  105c34:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105c38:	89 74 24 08          	mov    %esi,0x8(%esp)
  105c3c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105c40:	89 04 24             	mov    %eax,(%esp)
  105c43:	e8 88 e7 ff ff       	call   1043d0 <copyproc_threads>
  105c48:	89 c2                	mov    %eax,%edx
  105c4a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  105c4f:	85 d2                	test   %edx,%edx
  105c51:	74 98                	je     105beb <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  105c53:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  105c5a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  105c5d:	eb 8c                	jmp    105beb <sys_fork_thread+0x2b>
  105c5f:	90                   	nop

00105c60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105c60:	55                   	push   %ebp
  105c61:	89 e5                	mov    %esp,%ebp
  105c63:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105c66:	e8 45 dc ff ff       	call   1038b0 <curproc>
  105c6b:	89 04 24             	mov    %eax,(%esp)
  105c6e:	e8 6d e8 ff ff       	call   1044e0 <copyproc>
  105c73:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105c78:	85 c0                	test   %eax,%eax
  105c7a:	74 0a                	je     105c86 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  105c7c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  105c7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105c86:	89 d0                	mov    %edx,%eax
  105c88:	c9                   	leave  
  105c89:	c3                   	ret    
  105c8a:	90                   	nop
  105c8b:	90                   	nop
  105c8c:	90                   	nop
  105c8d:	90                   	nop
  105c8e:	90                   	nop
  105c8f:	90                   	nop

00105c90 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105c90:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105c91:	ba 43 00 00 00       	mov    $0x43,%edx
  105c96:	89 e5                	mov    %esp,%ebp
  105c98:	83 ec 18             	sub    $0x18,%esp
  105c9b:	b8 34 00 00 00       	mov    $0x34,%eax
  105ca0:	ee                   	out    %al,(%dx)
  105ca1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105ca6:	b2 40                	mov    $0x40,%dl
  105ca8:	ee                   	out    %al,(%dx)
  105ca9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  105cae:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105caf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105cb6:	e8 05 d5 ff ff       	call   1031c0 <pic_enable>
}
  105cbb:	c9                   	leave  
  105cbc:	c3                   	ret    
  105cbd:	90                   	nop
  105cbe:	90                   	nop
  105cbf:	90                   	nop

00105cc0 <alltraps>:
  105cc0:	1e                   	push   %ds
  105cc1:	06                   	push   %es
  105cc2:	60                   	pusha  
  105cc3:	b8 10 00 00 00       	mov    $0x10,%eax
  105cc8:	8e d8                	mov    %eax,%ds
  105cca:	8e c0                	mov    %eax,%es
  105ccc:	54                   	push   %esp
  105ccd:	e8 4e 00 00 00       	call   105d20 <trap>
  105cd2:	83 c4 04             	add    $0x4,%esp

00105cd5 <trapret>:
  105cd5:	61                   	popa   
  105cd6:	07                   	pop    %es
  105cd7:	1f                   	pop    %ds
  105cd8:	83 c4 08             	add    $0x8,%esp
  105cdb:	cf                   	iret   

00105cdc <forkret1>:
  105cdc:	8b 64 24 04          	mov    0x4(%esp),%esp
  105ce0:	e9 f0 ff ff ff       	jmp    105cd5 <trapret>
  105ce5:	90                   	nop
  105ce6:	90                   	nop
  105ce7:	90                   	nop
  105ce8:	90                   	nop
  105ce9:	90                   	nop
  105cea:	90                   	nop
  105ceb:	90                   	nop
  105cec:	90                   	nop
  105ced:	90                   	nop
  105cee:	90                   	nop
  105cef:	90                   	nop

00105cf0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105cf0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105cf1:	b8 20 eb 10 00       	mov    $0x10eb20,%eax
  105cf6:	89 e5                	mov    %esp,%ebp
  105cf8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  105cfb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105d01:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105d05:	c1 e8 10             	shr    $0x10,%eax
  105d08:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  105d0c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  105d0f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105d12:	c9                   	leave  
  105d13:	c3                   	ret    
  105d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105d20 <trap>:

void
trap(struct trapframe *tf)
{
  105d20:	55                   	push   %ebp
  105d21:	89 e5                	mov    %esp,%ebp
  105d23:	83 ec 48             	sub    $0x48,%esp
  105d26:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  105d2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105d2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  105d32:	8b 43 28             	mov    0x28(%ebx),%eax
  105d35:	83 f8 30             	cmp    $0x30,%eax
  105d38:	0f 84 8a 01 00 00    	je     105ec8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105d3e:	83 f8 21             	cmp    $0x21,%eax
  105d41:	0f 84 69 01 00 00    	je     105eb0 <trap+0x190>
  105d47:	76 47                	jbe    105d90 <trap+0x70>
  105d49:	83 f8 2e             	cmp    $0x2e,%eax
  105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105d50:	0f 84 42 01 00 00    	je     105e98 <trap+0x178>
  105d56:	83 f8 3f             	cmp    $0x3f,%eax
  105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105d60:	75 37                	jne    105d99 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105d62:	8b 7b 30             	mov    0x30(%ebx),%edi
  105d65:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  105d69:	e8 f2 cd ff ff       	call   102b60 <cpu>
  105d6e:	c7 04 24 b8 71 10 00 	movl   $0x1071b8,(%esp)
  105d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105d79:	89 74 24 08          	mov    %esi,0x8(%esp)
  105d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d81:	e8 3a aa ff ff       	call   1007c0 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105d86:	e8 45 cc ff ff       	call   1029d0 <lapic_eoi>
    break;
  105d8b:	e9 90 00 00 00       	jmp    105e20 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105d90:	83 f8 20             	cmp    $0x20,%eax
  105d93:	0f 84 e7 00 00 00    	je     105e80 <trap+0x160>
  105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105da0:	e8 0b db ff ff       	call   1038b0 <curproc>
  105da5:	85 c0                	test   %eax,%eax
  105da7:	0f 84 9b 01 00 00    	je     105f48 <trap+0x228>
  105dad:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  105db1:	0f 84 91 01 00 00    	je     105f48 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105db7:	8b 53 30             	mov    0x30(%ebx),%edx
  105dba:	89 55 e0             	mov    %edx,-0x20(%ebp)
  105dbd:	e8 9e cd ff ff       	call   102b60 <cpu>
  105dc2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  105dc5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105dc8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105dcb:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105dcd:	e8 de da ff ff       	call   1038b0 <curproc>
  105dd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105dd5:	e8 d6 da ff ff       	call   1038b0 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105dda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105ddd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105de1:	89 74 24 10          	mov    %esi,0x10(%esp)
  105de5:	89 54 24 18          	mov    %edx,0x18(%esp)
  105de9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105dec:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105df0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105df3:	81 c2 88 00 00 00    	add    $0x88,%edx
  105df9:	89 54 24 08          	mov    %edx,0x8(%esp)
  105dfd:	8b 40 10             	mov    0x10(%eax),%eax
  105e00:	c7 04 24 04 72 10 00 	movl   $0x107204,(%esp)
  105e07:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e0b:	e8 b0 a9 ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105e10:	e8 9b da ff ff       	call   1038b0 <curproc>
  105e15:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105e20:	e8 8b da ff ff       	call   1038b0 <curproc>
  105e25:	85 c0                	test   %eax,%eax
  105e27:	74 1c                	je     105e45 <trap+0x125>
  105e29:	e8 82 da ff ff       	call   1038b0 <curproc>
  105e2e:	8b 40 1c             	mov    0x1c(%eax),%eax
  105e31:	85 c0                	test   %eax,%eax
  105e33:	74 10                	je     105e45 <trap+0x125>
  105e35:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105e39:	83 e0 03             	and    $0x3,%eax
  105e3c:	83 f8 03             	cmp    $0x3,%eax
  105e3f:	0f 84 33 01 00 00    	je     105f78 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105e45:	e8 66 da ff ff       	call   1038b0 <curproc>
  105e4a:	85 c0                	test   %eax,%eax
  105e4c:	74 0d                	je     105e5b <trap+0x13b>
  105e4e:	66 90                	xchg   %ax,%ax
  105e50:	e8 5b da ff ff       	call   1038b0 <curproc>
  105e55:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105e59:	74 0d                	je     105e68 <trap+0x148>
    yield();
}
  105e5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105e5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105e61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e64:	89 ec                	mov    %ebp,%esp
  105e66:	5d                   	pop    %ebp
  105e67:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105e68:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  105e6c:	75 ed                	jne    105e5b <trap+0x13b>
    yield();
}
  105e6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105e71:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105e74:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e77:	89 ec                	mov    %ebp,%esp
  105e79:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105e7a:	e9 c1 df ff ff       	jmp    103e40 <yield>
  105e7f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105e80:	e8 db cc ff ff       	call   102b60 <cpu>
  105e85:	85 c0                	test   %eax,%eax
  105e87:	0f 84 8b 00 00 00    	je     105f18 <trap+0x1f8>
  105e8d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  105e90:	e8 3b cb ff ff       	call   1029d0 <lapic_eoi>
    break;
  105e95:	eb 89                	jmp    105e20 <trap+0x100>
  105e97:	90                   	nop
  105e98:	90                   	nop
  105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105ea0:	e8 1b c5 ff ff       	call   1023c0 <ide_intr>
  105ea5:	8d 76 00             	lea    0x0(%esi),%esi
  105ea8:	eb e3                	jmp    105e8d <trap+0x16d>
  105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105eb0:	e8 0b ca ff ff       	call   1028c0 <kbd_intr>
  105eb5:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  105eb8:	e8 13 cb ff ff       	call   1029d0 <lapic_eoi>
  105ebd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105ec0:	e9 5b ff ff ff       	jmp    105e20 <trap+0x100>
  105ec5:	8d 76 00             	lea    0x0(%esi),%esi
  105ec8:	90                   	nop
  105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105ed0:	e8 db d9 ff ff       	call   1038b0 <curproc>
  105ed5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105ed8:	85 c9                	test   %ecx,%ecx
  105eda:	0f 85 a8 00 00 00    	jne    105f88 <trap+0x268>
      exit();
    cp->tf = tf;
  105ee0:	e8 cb d9 ff ff       	call   1038b0 <curproc>
  105ee5:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  105eeb:	e8 70 ee ff ff       	call   104d60 <syscall>
    if(cp->killed)
  105ef0:	e8 bb d9 ff ff       	call   1038b0 <curproc>
  105ef5:	8b 50 1c             	mov    0x1c(%eax),%edx
  105ef8:	85 d2                	test   %edx,%edx
  105efa:	0f 84 5b ff ff ff    	je     105e5b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105f00:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105f03:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105f06:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105f09:	89 ec                	mov    %ebp,%esp
  105f0b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105f0c:	e9 9f da ff ff       	jmp    1039b0 <exit>
  105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105f18:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
  105f1f:	e8 cc e9 ff ff       	call   1048f0 <acquire>
      ticks++;
  105f24:	83 05 20 f3 10 00 01 	addl   $0x1,0x10f320
      wakeup(&ticks);
  105f2b:	c7 04 24 20 f3 10 00 	movl   $0x10f320,(%esp)
  105f32:	e8 79 d8 ff ff       	call   1037b0 <wakeup>
      release(&tickslock);
  105f37:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
  105f3e:	e8 6d e9 ff ff       	call   1048b0 <release>
  105f43:	e9 45 ff ff ff       	jmp    105e8d <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105f48:	8b 73 30             	mov    0x30(%ebx),%esi
  105f4b:	e8 10 cc ff ff       	call   102b60 <cpu>
  105f50:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105f54:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f58:	8b 43 28             	mov    0x28(%ebx),%eax
  105f5b:	c7 04 24 dc 71 10 00 	movl   $0x1071dc,(%esp)
  105f62:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f66:	e8 55 a8 ff ff       	call   1007c0 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105f6b:	c7 04 24 40 72 10 00 	movl   $0x107240,(%esp)
  105f72:	e8 e9 a9 ff ff       	call   100960 <panic>
  105f77:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105f78:	e8 33 da ff ff       	call   1039b0 <exit>
  105f7d:	e9 c3 fe ff ff       	jmp    105e45 <trap+0x125>
  105f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105f88:	90                   	nop
  105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105f90:	e8 1b da ff ff       	call   1039b0 <exit>
  105f95:	8d 76 00             	lea    0x0(%esi),%esi
  105f98:	e9 43 ff ff ff       	jmp    105ee0 <trap+0x1c0>
  105f9d:	8d 76 00             	lea    0x0(%esi),%esi

00105fa0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105fa0:	55                   	push   %ebp
  105fa1:	31 c0                	xor    %eax,%eax
  105fa3:	89 e5                	mov    %esp,%ebp
  105fa5:	ba 20 eb 10 00       	mov    $0x10eb20,%edx
  105faa:	83 ec 18             	sub    $0x18,%esp
  105fad:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105fb0:	8b 0c 85 68 85 10 00 	mov    0x108568(,%eax,4),%ecx
  105fb7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105fbe:	66 89 0c c5 20 eb 10 	mov    %cx,0x10eb20(,%eax,8)
  105fc5:	00 
  105fc6:	c1 e9 10             	shr    $0x10,%ecx
  105fc9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  105fce:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105fd3:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105fd8:	83 c0 01             	add    $0x1,%eax
  105fdb:	3d 00 01 00 00       	cmp    $0x100,%eax
  105fe0:	75 ce                	jne    105fb0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105fe2:	a1 28 86 10 00       	mov    0x108628,%eax
  
  initlock(&tickslock, "time");
  105fe7:	c7 44 24 04 45 72 10 	movl   $0x107245,0x4(%esp)
  105fee:	00 
  105fef:	c7 04 24 e0 ea 10 00 	movl   $0x10eae0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105ff6:	66 c7 05 a2 ec 10 00 	movw   $0x8,0x10eca2
  105ffd:	08 00 
  105fff:	66 a3 a0 ec 10 00    	mov    %ax,0x10eca0
  106005:	c1 e8 10             	shr    $0x10,%eax
  106008:	c6 05 a4 ec 10 00 00 	movb   $0x0,0x10eca4
  10600f:	c6 05 a5 ec 10 00 ef 	movb   $0xef,0x10eca5
  106016:	66 a3 a6 ec 10 00    	mov    %ax,0x10eca6
  
  initlock(&tickslock, "time");
  10601c:	e8 0f e7 ff ff       	call   104730 <initlock>
}
  106021:	c9                   	leave  
  106022:	c3                   	ret    
  106023:	90                   	nop

00106024 <vector0>:
  106024:	6a 00                	push   $0x0
  106026:	6a 00                	push   $0x0
  106028:	e9 93 fc ff ff       	jmp    105cc0 <alltraps>

0010602d <vector1>:
  10602d:	6a 00                	push   $0x0
  10602f:	6a 01                	push   $0x1
  106031:	e9 8a fc ff ff       	jmp    105cc0 <alltraps>

00106036 <vector2>:
  106036:	6a 00                	push   $0x0
  106038:	6a 02                	push   $0x2
  10603a:	e9 81 fc ff ff       	jmp    105cc0 <alltraps>

0010603f <vector3>:
  10603f:	6a 00                	push   $0x0
  106041:	6a 03                	push   $0x3
  106043:	e9 78 fc ff ff       	jmp    105cc0 <alltraps>

00106048 <vector4>:
  106048:	6a 00                	push   $0x0
  10604a:	6a 04                	push   $0x4
  10604c:	e9 6f fc ff ff       	jmp    105cc0 <alltraps>

00106051 <vector5>:
  106051:	6a 00                	push   $0x0
  106053:	6a 05                	push   $0x5
  106055:	e9 66 fc ff ff       	jmp    105cc0 <alltraps>

0010605a <vector6>:
  10605a:	6a 00                	push   $0x0
  10605c:	6a 06                	push   $0x6
  10605e:	e9 5d fc ff ff       	jmp    105cc0 <alltraps>

00106063 <vector7>:
  106063:	6a 00                	push   $0x0
  106065:	6a 07                	push   $0x7
  106067:	e9 54 fc ff ff       	jmp    105cc0 <alltraps>

0010606c <vector8>:
  10606c:	6a 08                	push   $0x8
  10606e:	e9 4d fc ff ff       	jmp    105cc0 <alltraps>

00106073 <vector9>:
  106073:	6a 09                	push   $0x9
  106075:	e9 46 fc ff ff       	jmp    105cc0 <alltraps>

0010607a <vector10>:
  10607a:	6a 0a                	push   $0xa
  10607c:	e9 3f fc ff ff       	jmp    105cc0 <alltraps>

00106081 <vector11>:
  106081:	6a 0b                	push   $0xb
  106083:	e9 38 fc ff ff       	jmp    105cc0 <alltraps>

00106088 <vector12>:
  106088:	6a 0c                	push   $0xc
  10608a:	e9 31 fc ff ff       	jmp    105cc0 <alltraps>

0010608f <vector13>:
  10608f:	6a 0d                	push   $0xd
  106091:	e9 2a fc ff ff       	jmp    105cc0 <alltraps>

00106096 <vector14>:
  106096:	6a 0e                	push   $0xe
  106098:	e9 23 fc ff ff       	jmp    105cc0 <alltraps>

0010609d <vector15>:
  10609d:	6a 00                	push   $0x0
  10609f:	6a 0f                	push   $0xf
  1060a1:	e9 1a fc ff ff       	jmp    105cc0 <alltraps>

001060a6 <vector16>:
  1060a6:	6a 00                	push   $0x0
  1060a8:	6a 10                	push   $0x10
  1060aa:	e9 11 fc ff ff       	jmp    105cc0 <alltraps>

001060af <vector17>:
  1060af:	6a 11                	push   $0x11
  1060b1:	e9 0a fc ff ff       	jmp    105cc0 <alltraps>

001060b6 <vector18>:
  1060b6:	6a 00                	push   $0x0
  1060b8:	6a 12                	push   $0x12
  1060ba:	e9 01 fc ff ff       	jmp    105cc0 <alltraps>

001060bf <vector19>:
  1060bf:	6a 00                	push   $0x0
  1060c1:	6a 13                	push   $0x13
  1060c3:	e9 f8 fb ff ff       	jmp    105cc0 <alltraps>

001060c8 <vector20>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	6a 14                	push   $0x14
  1060cc:	e9 ef fb ff ff       	jmp    105cc0 <alltraps>

001060d1 <vector21>:
  1060d1:	6a 00                	push   $0x0
  1060d3:	6a 15                	push   $0x15
  1060d5:	e9 e6 fb ff ff       	jmp    105cc0 <alltraps>

001060da <vector22>:
  1060da:	6a 00                	push   $0x0
  1060dc:	6a 16                	push   $0x16
  1060de:	e9 dd fb ff ff       	jmp    105cc0 <alltraps>

001060e3 <vector23>:
  1060e3:	6a 00                	push   $0x0
  1060e5:	6a 17                	push   $0x17
  1060e7:	e9 d4 fb ff ff       	jmp    105cc0 <alltraps>

001060ec <vector24>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	6a 18                	push   $0x18
  1060f0:	e9 cb fb ff ff       	jmp    105cc0 <alltraps>

001060f5 <vector25>:
  1060f5:	6a 00                	push   $0x0
  1060f7:	6a 19                	push   $0x19
  1060f9:	e9 c2 fb ff ff       	jmp    105cc0 <alltraps>

001060fe <vector26>:
  1060fe:	6a 00                	push   $0x0
  106100:	6a 1a                	push   $0x1a
  106102:	e9 b9 fb ff ff       	jmp    105cc0 <alltraps>

00106107 <vector27>:
  106107:	6a 00                	push   $0x0
  106109:	6a 1b                	push   $0x1b
  10610b:	e9 b0 fb ff ff       	jmp    105cc0 <alltraps>

00106110 <vector28>:
  106110:	6a 00                	push   $0x0
  106112:	6a 1c                	push   $0x1c
  106114:	e9 a7 fb ff ff       	jmp    105cc0 <alltraps>

00106119 <vector29>:
  106119:	6a 00                	push   $0x0
  10611b:	6a 1d                	push   $0x1d
  10611d:	e9 9e fb ff ff       	jmp    105cc0 <alltraps>

00106122 <vector30>:
  106122:	6a 00                	push   $0x0
  106124:	6a 1e                	push   $0x1e
  106126:	e9 95 fb ff ff       	jmp    105cc0 <alltraps>

0010612b <vector31>:
  10612b:	6a 00                	push   $0x0
  10612d:	6a 1f                	push   $0x1f
  10612f:	e9 8c fb ff ff       	jmp    105cc0 <alltraps>

00106134 <vector32>:
  106134:	6a 00                	push   $0x0
  106136:	6a 20                	push   $0x20
  106138:	e9 83 fb ff ff       	jmp    105cc0 <alltraps>

0010613d <vector33>:
  10613d:	6a 00                	push   $0x0
  10613f:	6a 21                	push   $0x21
  106141:	e9 7a fb ff ff       	jmp    105cc0 <alltraps>

00106146 <vector34>:
  106146:	6a 00                	push   $0x0
  106148:	6a 22                	push   $0x22
  10614a:	e9 71 fb ff ff       	jmp    105cc0 <alltraps>

0010614f <vector35>:
  10614f:	6a 00                	push   $0x0
  106151:	6a 23                	push   $0x23
  106153:	e9 68 fb ff ff       	jmp    105cc0 <alltraps>

00106158 <vector36>:
  106158:	6a 00                	push   $0x0
  10615a:	6a 24                	push   $0x24
  10615c:	e9 5f fb ff ff       	jmp    105cc0 <alltraps>

00106161 <vector37>:
  106161:	6a 00                	push   $0x0
  106163:	6a 25                	push   $0x25
  106165:	e9 56 fb ff ff       	jmp    105cc0 <alltraps>

0010616a <vector38>:
  10616a:	6a 00                	push   $0x0
  10616c:	6a 26                	push   $0x26
  10616e:	e9 4d fb ff ff       	jmp    105cc0 <alltraps>

00106173 <vector39>:
  106173:	6a 00                	push   $0x0
  106175:	6a 27                	push   $0x27
  106177:	e9 44 fb ff ff       	jmp    105cc0 <alltraps>

0010617c <vector40>:
  10617c:	6a 00                	push   $0x0
  10617e:	6a 28                	push   $0x28
  106180:	e9 3b fb ff ff       	jmp    105cc0 <alltraps>

00106185 <vector41>:
  106185:	6a 00                	push   $0x0
  106187:	6a 29                	push   $0x29
  106189:	e9 32 fb ff ff       	jmp    105cc0 <alltraps>

0010618e <vector42>:
  10618e:	6a 00                	push   $0x0
  106190:	6a 2a                	push   $0x2a
  106192:	e9 29 fb ff ff       	jmp    105cc0 <alltraps>

00106197 <vector43>:
  106197:	6a 00                	push   $0x0
  106199:	6a 2b                	push   $0x2b
  10619b:	e9 20 fb ff ff       	jmp    105cc0 <alltraps>

001061a0 <vector44>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	6a 2c                	push   $0x2c
  1061a4:	e9 17 fb ff ff       	jmp    105cc0 <alltraps>

001061a9 <vector45>:
  1061a9:	6a 00                	push   $0x0
  1061ab:	6a 2d                	push   $0x2d
  1061ad:	e9 0e fb ff ff       	jmp    105cc0 <alltraps>

001061b2 <vector46>:
  1061b2:	6a 00                	push   $0x0
  1061b4:	6a 2e                	push   $0x2e
  1061b6:	e9 05 fb ff ff       	jmp    105cc0 <alltraps>

001061bb <vector47>:
  1061bb:	6a 00                	push   $0x0
  1061bd:	6a 2f                	push   $0x2f
  1061bf:	e9 fc fa ff ff       	jmp    105cc0 <alltraps>

001061c4 <vector48>:
  1061c4:	6a 00                	push   $0x0
  1061c6:	6a 30                	push   $0x30
  1061c8:	e9 f3 fa ff ff       	jmp    105cc0 <alltraps>

001061cd <vector49>:
  1061cd:	6a 00                	push   $0x0
  1061cf:	6a 31                	push   $0x31
  1061d1:	e9 ea fa ff ff       	jmp    105cc0 <alltraps>

001061d6 <vector50>:
  1061d6:	6a 00                	push   $0x0
  1061d8:	6a 32                	push   $0x32
  1061da:	e9 e1 fa ff ff       	jmp    105cc0 <alltraps>

001061df <vector51>:
  1061df:	6a 00                	push   $0x0
  1061e1:	6a 33                	push   $0x33
  1061e3:	e9 d8 fa ff ff       	jmp    105cc0 <alltraps>

001061e8 <vector52>:
  1061e8:	6a 00                	push   $0x0
  1061ea:	6a 34                	push   $0x34
  1061ec:	e9 cf fa ff ff       	jmp    105cc0 <alltraps>

001061f1 <vector53>:
  1061f1:	6a 00                	push   $0x0
  1061f3:	6a 35                	push   $0x35
  1061f5:	e9 c6 fa ff ff       	jmp    105cc0 <alltraps>

001061fa <vector54>:
  1061fa:	6a 00                	push   $0x0
  1061fc:	6a 36                	push   $0x36
  1061fe:	e9 bd fa ff ff       	jmp    105cc0 <alltraps>

00106203 <vector55>:
  106203:	6a 00                	push   $0x0
  106205:	6a 37                	push   $0x37
  106207:	e9 b4 fa ff ff       	jmp    105cc0 <alltraps>

0010620c <vector56>:
  10620c:	6a 00                	push   $0x0
  10620e:	6a 38                	push   $0x38
  106210:	e9 ab fa ff ff       	jmp    105cc0 <alltraps>

00106215 <vector57>:
  106215:	6a 00                	push   $0x0
  106217:	6a 39                	push   $0x39
  106219:	e9 a2 fa ff ff       	jmp    105cc0 <alltraps>

0010621e <vector58>:
  10621e:	6a 00                	push   $0x0
  106220:	6a 3a                	push   $0x3a
  106222:	e9 99 fa ff ff       	jmp    105cc0 <alltraps>

00106227 <vector59>:
  106227:	6a 00                	push   $0x0
  106229:	6a 3b                	push   $0x3b
  10622b:	e9 90 fa ff ff       	jmp    105cc0 <alltraps>

00106230 <vector60>:
  106230:	6a 00                	push   $0x0
  106232:	6a 3c                	push   $0x3c
  106234:	e9 87 fa ff ff       	jmp    105cc0 <alltraps>

00106239 <vector61>:
  106239:	6a 00                	push   $0x0
  10623b:	6a 3d                	push   $0x3d
  10623d:	e9 7e fa ff ff       	jmp    105cc0 <alltraps>

00106242 <vector62>:
  106242:	6a 00                	push   $0x0
  106244:	6a 3e                	push   $0x3e
  106246:	e9 75 fa ff ff       	jmp    105cc0 <alltraps>

0010624b <vector63>:
  10624b:	6a 00                	push   $0x0
  10624d:	6a 3f                	push   $0x3f
  10624f:	e9 6c fa ff ff       	jmp    105cc0 <alltraps>

00106254 <vector64>:
  106254:	6a 00                	push   $0x0
  106256:	6a 40                	push   $0x40
  106258:	e9 63 fa ff ff       	jmp    105cc0 <alltraps>

0010625d <vector65>:
  10625d:	6a 00                	push   $0x0
  10625f:	6a 41                	push   $0x41
  106261:	e9 5a fa ff ff       	jmp    105cc0 <alltraps>

00106266 <vector66>:
  106266:	6a 00                	push   $0x0
  106268:	6a 42                	push   $0x42
  10626a:	e9 51 fa ff ff       	jmp    105cc0 <alltraps>

0010626f <vector67>:
  10626f:	6a 00                	push   $0x0
  106271:	6a 43                	push   $0x43
  106273:	e9 48 fa ff ff       	jmp    105cc0 <alltraps>

00106278 <vector68>:
  106278:	6a 00                	push   $0x0
  10627a:	6a 44                	push   $0x44
  10627c:	e9 3f fa ff ff       	jmp    105cc0 <alltraps>

00106281 <vector69>:
  106281:	6a 00                	push   $0x0
  106283:	6a 45                	push   $0x45
  106285:	e9 36 fa ff ff       	jmp    105cc0 <alltraps>

0010628a <vector70>:
  10628a:	6a 00                	push   $0x0
  10628c:	6a 46                	push   $0x46
  10628e:	e9 2d fa ff ff       	jmp    105cc0 <alltraps>

00106293 <vector71>:
  106293:	6a 00                	push   $0x0
  106295:	6a 47                	push   $0x47
  106297:	e9 24 fa ff ff       	jmp    105cc0 <alltraps>

0010629c <vector72>:
  10629c:	6a 00                	push   $0x0
  10629e:	6a 48                	push   $0x48
  1062a0:	e9 1b fa ff ff       	jmp    105cc0 <alltraps>

001062a5 <vector73>:
  1062a5:	6a 00                	push   $0x0
  1062a7:	6a 49                	push   $0x49
  1062a9:	e9 12 fa ff ff       	jmp    105cc0 <alltraps>

001062ae <vector74>:
  1062ae:	6a 00                	push   $0x0
  1062b0:	6a 4a                	push   $0x4a
  1062b2:	e9 09 fa ff ff       	jmp    105cc0 <alltraps>

001062b7 <vector75>:
  1062b7:	6a 00                	push   $0x0
  1062b9:	6a 4b                	push   $0x4b
  1062bb:	e9 00 fa ff ff       	jmp    105cc0 <alltraps>

001062c0 <vector76>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	6a 4c                	push   $0x4c
  1062c4:	e9 f7 f9 ff ff       	jmp    105cc0 <alltraps>

001062c9 <vector77>:
  1062c9:	6a 00                	push   $0x0
  1062cb:	6a 4d                	push   $0x4d
  1062cd:	e9 ee f9 ff ff       	jmp    105cc0 <alltraps>

001062d2 <vector78>:
  1062d2:	6a 00                	push   $0x0
  1062d4:	6a 4e                	push   $0x4e
  1062d6:	e9 e5 f9 ff ff       	jmp    105cc0 <alltraps>

001062db <vector79>:
  1062db:	6a 00                	push   $0x0
  1062dd:	6a 4f                	push   $0x4f
  1062df:	e9 dc f9 ff ff       	jmp    105cc0 <alltraps>

001062e4 <vector80>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	6a 50                	push   $0x50
  1062e8:	e9 d3 f9 ff ff       	jmp    105cc0 <alltraps>

001062ed <vector81>:
  1062ed:	6a 00                	push   $0x0
  1062ef:	6a 51                	push   $0x51
  1062f1:	e9 ca f9 ff ff       	jmp    105cc0 <alltraps>

001062f6 <vector82>:
  1062f6:	6a 00                	push   $0x0
  1062f8:	6a 52                	push   $0x52
  1062fa:	e9 c1 f9 ff ff       	jmp    105cc0 <alltraps>

001062ff <vector83>:
  1062ff:	6a 00                	push   $0x0
  106301:	6a 53                	push   $0x53
  106303:	e9 b8 f9 ff ff       	jmp    105cc0 <alltraps>

00106308 <vector84>:
  106308:	6a 00                	push   $0x0
  10630a:	6a 54                	push   $0x54
  10630c:	e9 af f9 ff ff       	jmp    105cc0 <alltraps>

00106311 <vector85>:
  106311:	6a 00                	push   $0x0
  106313:	6a 55                	push   $0x55
  106315:	e9 a6 f9 ff ff       	jmp    105cc0 <alltraps>

0010631a <vector86>:
  10631a:	6a 00                	push   $0x0
  10631c:	6a 56                	push   $0x56
  10631e:	e9 9d f9 ff ff       	jmp    105cc0 <alltraps>

00106323 <vector87>:
  106323:	6a 00                	push   $0x0
  106325:	6a 57                	push   $0x57
  106327:	e9 94 f9 ff ff       	jmp    105cc0 <alltraps>

0010632c <vector88>:
  10632c:	6a 00                	push   $0x0
  10632e:	6a 58                	push   $0x58
  106330:	e9 8b f9 ff ff       	jmp    105cc0 <alltraps>

00106335 <vector89>:
  106335:	6a 00                	push   $0x0
  106337:	6a 59                	push   $0x59
  106339:	e9 82 f9 ff ff       	jmp    105cc0 <alltraps>

0010633e <vector90>:
  10633e:	6a 00                	push   $0x0
  106340:	6a 5a                	push   $0x5a
  106342:	e9 79 f9 ff ff       	jmp    105cc0 <alltraps>

00106347 <vector91>:
  106347:	6a 00                	push   $0x0
  106349:	6a 5b                	push   $0x5b
  10634b:	e9 70 f9 ff ff       	jmp    105cc0 <alltraps>

00106350 <vector92>:
  106350:	6a 00                	push   $0x0
  106352:	6a 5c                	push   $0x5c
  106354:	e9 67 f9 ff ff       	jmp    105cc0 <alltraps>

00106359 <vector93>:
  106359:	6a 00                	push   $0x0
  10635b:	6a 5d                	push   $0x5d
  10635d:	e9 5e f9 ff ff       	jmp    105cc0 <alltraps>

00106362 <vector94>:
  106362:	6a 00                	push   $0x0
  106364:	6a 5e                	push   $0x5e
  106366:	e9 55 f9 ff ff       	jmp    105cc0 <alltraps>

0010636b <vector95>:
  10636b:	6a 00                	push   $0x0
  10636d:	6a 5f                	push   $0x5f
  10636f:	e9 4c f9 ff ff       	jmp    105cc0 <alltraps>

00106374 <vector96>:
  106374:	6a 00                	push   $0x0
  106376:	6a 60                	push   $0x60
  106378:	e9 43 f9 ff ff       	jmp    105cc0 <alltraps>

0010637d <vector97>:
  10637d:	6a 00                	push   $0x0
  10637f:	6a 61                	push   $0x61
  106381:	e9 3a f9 ff ff       	jmp    105cc0 <alltraps>

00106386 <vector98>:
  106386:	6a 00                	push   $0x0
  106388:	6a 62                	push   $0x62
  10638a:	e9 31 f9 ff ff       	jmp    105cc0 <alltraps>

0010638f <vector99>:
  10638f:	6a 00                	push   $0x0
  106391:	6a 63                	push   $0x63
  106393:	e9 28 f9 ff ff       	jmp    105cc0 <alltraps>

00106398 <vector100>:
  106398:	6a 00                	push   $0x0
  10639a:	6a 64                	push   $0x64
  10639c:	e9 1f f9 ff ff       	jmp    105cc0 <alltraps>

001063a1 <vector101>:
  1063a1:	6a 00                	push   $0x0
  1063a3:	6a 65                	push   $0x65
  1063a5:	e9 16 f9 ff ff       	jmp    105cc0 <alltraps>

001063aa <vector102>:
  1063aa:	6a 00                	push   $0x0
  1063ac:	6a 66                	push   $0x66
  1063ae:	e9 0d f9 ff ff       	jmp    105cc0 <alltraps>

001063b3 <vector103>:
  1063b3:	6a 00                	push   $0x0
  1063b5:	6a 67                	push   $0x67
  1063b7:	e9 04 f9 ff ff       	jmp    105cc0 <alltraps>

001063bc <vector104>:
  1063bc:	6a 00                	push   $0x0
  1063be:	6a 68                	push   $0x68
  1063c0:	e9 fb f8 ff ff       	jmp    105cc0 <alltraps>

001063c5 <vector105>:
  1063c5:	6a 00                	push   $0x0
  1063c7:	6a 69                	push   $0x69
  1063c9:	e9 f2 f8 ff ff       	jmp    105cc0 <alltraps>

001063ce <vector106>:
  1063ce:	6a 00                	push   $0x0
  1063d0:	6a 6a                	push   $0x6a
  1063d2:	e9 e9 f8 ff ff       	jmp    105cc0 <alltraps>

001063d7 <vector107>:
  1063d7:	6a 00                	push   $0x0
  1063d9:	6a 6b                	push   $0x6b
  1063db:	e9 e0 f8 ff ff       	jmp    105cc0 <alltraps>

001063e0 <vector108>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	6a 6c                	push   $0x6c
  1063e4:	e9 d7 f8 ff ff       	jmp    105cc0 <alltraps>

001063e9 <vector109>:
  1063e9:	6a 00                	push   $0x0
  1063eb:	6a 6d                	push   $0x6d
  1063ed:	e9 ce f8 ff ff       	jmp    105cc0 <alltraps>

001063f2 <vector110>:
  1063f2:	6a 00                	push   $0x0
  1063f4:	6a 6e                	push   $0x6e
  1063f6:	e9 c5 f8 ff ff       	jmp    105cc0 <alltraps>

001063fb <vector111>:
  1063fb:	6a 00                	push   $0x0
  1063fd:	6a 6f                	push   $0x6f
  1063ff:	e9 bc f8 ff ff       	jmp    105cc0 <alltraps>

00106404 <vector112>:
  106404:	6a 00                	push   $0x0
  106406:	6a 70                	push   $0x70
  106408:	e9 b3 f8 ff ff       	jmp    105cc0 <alltraps>

0010640d <vector113>:
  10640d:	6a 00                	push   $0x0
  10640f:	6a 71                	push   $0x71
  106411:	e9 aa f8 ff ff       	jmp    105cc0 <alltraps>

00106416 <vector114>:
  106416:	6a 00                	push   $0x0
  106418:	6a 72                	push   $0x72
  10641a:	e9 a1 f8 ff ff       	jmp    105cc0 <alltraps>

0010641f <vector115>:
  10641f:	6a 00                	push   $0x0
  106421:	6a 73                	push   $0x73
  106423:	e9 98 f8 ff ff       	jmp    105cc0 <alltraps>

00106428 <vector116>:
  106428:	6a 00                	push   $0x0
  10642a:	6a 74                	push   $0x74
  10642c:	e9 8f f8 ff ff       	jmp    105cc0 <alltraps>

00106431 <vector117>:
  106431:	6a 00                	push   $0x0
  106433:	6a 75                	push   $0x75
  106435:	e9 86 f8 ff ff       	jmp    105cc0 <alltraps>

0010643a <vector118>:
  10643a:	6a 00                	push   $0x0
  10643c:	6a 76                	push   $0x76
  10643e:	e9 7d f8 ff ff       	jmp    105cc0 <alltraps>

00106443 <vector119>:
  106443:	6a 00                	push   $0x0
  106445:	6a 77                	push   $0x77
  106447:	e9 74 f8 ff ff       	jmp    105cc0 <alltraps>

0010644c <vector120>:
  10644c:	6a 00                	push   $0x0
  10644e:	6a 78                	push   $0x78
  106450:	e9 6b f8 ff ff       	jmp    105cc0 <alltraps>

00106455 <vector121>:
  106455:	6a 00                	push   $0x0
  106457:	6a 79                	push   $0x79
  106459:	e9 62 f8 ff ff       	jmp    105cc0 <alltraps>

0010645e <vector122>:
  10645e:	6a 00                	push   $0x0
  106460:	6a 7a                	push   $0x7a
  106462:	e9 59 f8 ff ff       	jmp    105cc0 <alltraps>

00106467 <vector123>:
  106467:	6a 00                	push   $0x0
  106469:	6a 7b                	push   $0x7b
  10646b:	e9 50 f8 ff ff       	jmp    105cc0 <alltraps>

00106470 <vector124>:
  106470:	6a 00                	push   $0x0
  106472:	6a 7c                	push   $0x7c
  106474:	e9 47 f8 ff ff       	jmp    105cc0 <alltraps>

00106479 <vector125>:
  106479:	6a 00                	push   $0x0
  10647b:	6a 7d                	push   $0x7d
  10647d:	e9 3e f8 ff ff       	jmp    105cc0 <alltraps>

00106482 <vector126>:
  106482:	6a 00                	push   $0x0
  106484:	6a 7e                	push   $0x7e
  106486:	e9 35 f8 ff ff       	jmp    105cc0 <alltraps>

0010648b <vector127>:
  10648b:	6a 00                	push   $0x0
  10648d:	6a 7f                	push   $0x7f
  10648f:	e9 2c f8 ff ff       	jmp    105cc0 <alltraps>

00106494 <vector128>:
  106494:	6a 00                	push   $0x0
  106496:	68 80 00 00 00       	push   $0x80
  10649b:	e9 20 f8 ff ff       	jmp    105cc0 <alltraps>

001064a0 <vector129>:
  1064a0:	6a 00                	push   $0x0
  1064a2:	68 81 00 00 00       	push   $0x81
  1064a7:	e9 14 f8 ff ff       	jmp    105cc0 <alltraps>

001064ac <vector130>:
  1064ac:	6a 00                	push   $0x0
  1064ae:	68 82 00 00 00       	push   $0x82
  1064b3:	e9 08 f8 ff ff       	jmp    105cc0 <alltraps>

001064b8 <vector131>:
  1064b8:	6a 00                	push   $0x0
  1064ba:	68 83 00 00 00       	push   $0x83
  1064bf:	e9 fc f7 ff ff       	jmp    105cc0 <alltraps>

001064c4 <vector132>:
  1064c4:	6a 00                	push   $0x0
  1064c6:	68 84 00 00 00       	push   $0x84
  1064cb:	e9 f0 f7 ff ff       	jmp    105cc0 <alltraps>

001064d0 <vector133>:
  1064d0:	6a 00                	push   $0x0
  1064d2:	68 85 00 00 00       	push   $0x85
  1064d7:	e9 e4 f7 ff ff       	jmp    105cc0 <alltraps>

001064dc <vector134>:
  1064dc:	6a 00                	push   $0x0
  1064de:	68 86 00 00 00       	push   $0x86
  1064e3:	e9 d8 f7 ff ff       	jmp    105cc0 <alltraps>

001064e8 <vector135>:
  1064e8:	6a 00                	push   $0x0
  1064ea:	68 87 00 00 00       	push   $0x87
  1064ef:	e9 cc f7 ff ff       	jmp    105cc0 <alltraps>

001064f4 <vector136>:
  1064f4:	6a 00                	push   $0x0
  1064f6:	68 88 00 00 00       	push   $0x88
  1064fb:	e9 c0 f7 ff ff       	jmp    105cc0 <alltraps>

00106500 <vector137>:
  106500:	6a 00                	push   $0x0
  106502:	68 89 00 00 00       	push   $0x89
  106507:	e9 b4 f7 ff ff       	jmp    105cc0 <alltraps>

0010650c <vector138>:
  10650c:	6a 00                	push   $0x0
  10650e:	68 8a 00 00 00       	push   $0x8a
  106513:	e9 a8 f7 ff ff       	jmp    105cc0 <alltraps>

00106518 <vector139>:
  106518:	6a 00                	push   $0x0
  10651a:	68 8b 00 00 00       	push   $0x8b
  10651f:	e9 9c f7 ff ff       	jmp    105cc0 <alltraps>

00106524 <vector140>:
  106524:	6a 00                	push   $0x0
  106526:	68 8c 00 00 00       	push   $0x8c
  10652b:	e9 90 f7 ff ff       	jmp    105cc0 <alltraps>

00106530 <vector141>:
  106530:	6a 00                	push   $0x0
  106532:	68 8d 00 00 00       	push   $0x8d
  106537:	e9 84 f7 ff ff       	jmp    105cc0 <alltraps>

0010653c <vector142>:
  10653c:	6a 00                	push   $0x0
  10653e:	68 8e 00 00 00       	push   $0x8e
  106543:	e9 78 f7 ff ff       	jmp    105cc0 <alltraps>

00106548 <vector143>:
  106548:	6a 00                	push   $0x0
  10654a:	68 8f 00 00 00       	push   $0x8f
  10654f:	e9 6c f7 ff ff       	jmp    105cc0 <alltraps>

00106554 <vector144>:
  106554:	6a 00                	push   $0x0
  106556:	68 90 00 00 00       	push   $0x90
  10655b:	e9 60 f7 ff ff       	jmp    105cc0 <alltraps>

00106560 <vector145>:
  106560:	6a 00                	push   $0x0
  106562:	68 91 00 00 00       	push   $0x91
  106567:	e9 54 f7 ff ff       	jmp    105cc0 <alltraps>

0010656c <vector146>:
  10656c:	6a 00                	push   $0x0
  10656e:	68 92 00 00 00       	push   $0x92
  106573:	e9 48 f7 ff ff       	jmp    105cc0 <alltraps>

00106578 <vector147>:
  106578:	6a 00                	push   $0x0
  10657a:	68 93 00 00 00       	push   $0x93
  10657f:	e9 3c f7 ff ff       	jmp    105cc0 <alltraps>

00106584 <vector148>:
  106584:	6a 00                	push   $0x0
  106586:	68 94 00 00 00       	push   $0x94
  10658b:	e9 30 f7 ff ff       	jmp    105cc0 <alltraps>

00106590 <vector149>:
  106590:	6a 00                	push   $0x0
  106592:	68 95 00 00 00       	push   $0x95
  106597:	e9 24 f7 ff ff       	jmp    105cc0 <alltraps>

0010659c <vector150>:
  10659c:	6a 00                	push   $0x0
  10659e:	68 96 00 00 00       	push   $0x96
  1065a3:	e9 18 f7 ff ff       	jmp    105cc0 <alltraps>

001065a8 <vector151>:
  1065a8:	6a 00                	push   $0x0
  1065aa:	68 97 00 00 00       	push   $0x97
  1065af:	e9 0c f7 ff ff       	jmp    105cc0 <alltraps>

001065b4 <vector152>:
  1065b4:	6a 00                	push   $0x0
  1065b6:	68 98 00 00 00       	push   $0x98
  1065bb:	e9 00 f7 ff ff       	jmp    105cc0 <alltraps>

001065c0 <vector153>:
  1065c0:	6a 00                	push   $0x0
  1065c2:	68 99 00 00 00       	push   $0x99
  1065c7:	e9 f4 f6 ff ff       	jmp    105cc0 <alltraps>

001065cc <vector154>:
  1065cc:	6a 00                	push   $0x0
  1065ce:	68 9a 00 00 00       	push   $0x9a
  1065d3:	e9 e8 f6 ff ff       	jmp    105cc0 <alltraps>

001065d8 <vector155>:
  1065d8:	6a 00                	push   $0x0
  1065da:	68 9b 00 00 00       	push   $0x9b
  1065df:	e9 dc f6 ff ff       	jmp    105cc0 <alltraps>

001065e4 <vector156>:
  1065e4:	6a 00                	push   $0x0
  1065e6:	68 9c 00 00 00       	push   $0x9c
  1065eb:	e9 d0 f6 ff ff       	jmp    105cc0 <alltraps>

001065f0 <vector157>:
  1065f0:	6a 00                	push   $0x0
  1065f2:	68 9d 00 00 00       	push   $0x9d
  1065f7:	e9 c4 f6 ff ff       	jmp    105cc0 <alltraps>

001065fc <vector158>:
  1065fc:	6a 00                	push   $0x0
  1065fe:	68 9e 00 00 00       	push   $0x9e
  106603:	e9 b8 f6 ff ff       	jmp    105cc0 <alltraps>

00106608 <vector159>:
  106608:	6a 00                	push   $0x0
  10660a:	68 9f 00 00 00       	push   $0x9f
  10660f:	e9 ac f6 ff ff       	jmp    105cc0 <alltraps>

00106614 <vector160>:
  106614:	6a 00                	push   $0x0
  106616:	68 a0 00 00 00       	push   $0xa0
  10661b:	e9 a0 f6 ff ff       	jmp    105cc0 <alltraps>

00106620 <vector161>:
  106620:	6a 00                	push   $0x0
  106622:	68 a1 00 00 00       	push   $0xa1
  106627:	e9 94 f6 ff ff       	jmp    105cc0 <alltraps>

0010662c <vector162>:
  10662c:	6a 00                	push   $0x0
  10662e:	68 a2 00 00 00       	push   $0xa2
  106633:	e9 88 f6 ff ff       	jmp    105cc0 <alltraps>

00106638 <vector163>:
  106638:	6a 00                	push   $0x0
  10663a:	68 a3 00 00 00       	push   $0xa3
  10663f:	e9 7c f6 ff ff       	jmp    105cc0 <alltraps>

00106644 <vector164>:
  106644:	6a 00                	push   $0x0
  106646:	68 a4 00 00 00       	push   $0xa4
  10664b:	e9 70 f6 ff ff       	jmp    105cc0 <alltraps>

00106650 <vector165>:
  106650:	6a 00                	push   $0x0
  106652:	68 a5 00 00 00       	push   $0xa5
  106657:	e9 64 f6 ff ff       	jmp    105cc0 <alltraps>

0010665c <vector166>:
  10665c:	6a 00                	push   $0x0
  10665e:	68 a6 00 00 00       	push   $0xa6
  106663:	e9 58 f6 ff ff       	jmp    105cc0 <alltraps>

00106668 <vector167>:
  106668:	6a 00                	push   $0x0
  10666a:	68 a7 00 00 00       	push   $0xa7
  10666f:	e9 4c f6 ff ff       	jmp    105cc0 <alltraps>

00106674 <vector168>:
  106674:	6a 00                	push   $0x0
  106676:	68 a8 00 00 00       	push   $0xa8
  10667b:	e9 40 f6 ff ff       	jmp    105cc0 <alltraps>

00106680 <vector169>:
  106680:	6a 00                	push   $0x0
  106682:	68 a9 00 00 00       	push   $0xa9
  106687:	e9 34 f6 ff ff       	jmp    105cc0 <alltraps>

0010668c <vector170>:
  10668c:	6a 00                	push   $0x0
  10668e:	68 aa 00 00 00       	push   $0xaa
  106693:	e9 28 f6 ff ff       	jmp    105cc0 <alltraps>

00106698 <vector171>:
  106698:	6a 00                	push   $0x0
  10669a:	68 ab 00 00 00       	push   $0xab
  10669f:	e9 1c f6 ff ff       	jmp    105cc0 <alltraps>

001066a4 <vector172>:
  1066a4:	6a 00                	push   $0x0
  1066a6:	68 ac 00 00 00       	push   $0xac
  1066ab:	e9 10 f6 ff ff       	jmp    105cc0 <alltraps>

001066b0 <vector173>:
  1066b0:	6a 00                	push   $0x0
  1066b2:	68 ad 00 00 00       	push   $0xad
  1066b7:	e9 04 f6 ff ff       	jmp    105cc0 <alltraps>

001066bc <vector174>:
  1066bc:	6a 00                	push   $0x0
  1066be:	68 ae 00 00 00       	push   $0xae
  1066c3:	e9 f8 f5 ff ff       	jmp    105cc0 <alltraps>

001066c8 <vector175>:
  1066c8:	6a 00                	push   $0x0
  1066ca:	68 af 00 00 00       	push   $0xaf
  1066cf:	e9 ec f5 ff ff       	jmp    105cc0 <alltraps>

001066d4 <vector176>:
  1066d4:	6a 00                	push   $0x0
  1066d6:	68 b0 00 00 00       	push   $0xb0
  1066db:	e9 e0 f5 ff ff       	jmp    105cc0 <alltraps>

001066e0 <vector177>:
  1066e0:	6a 00                	push   $0x0
  1066e2:	68 b1 00 00 00       	push   $0xb1
  1066e7:	e9 d4 f5 ff ff       	jmp    105cc0 <alltraps>

001066ec <vector178>:
  1066ec:	6a 00                	push   $0x0
  1066ee:	68 b2 00 00 00       	push   $0xb2
  1066f3:	e9 c8 f5 ff ff       	jmp    105cc0 <alltraps>

001066f8 <vector179>:
  1066f8:	6a 00                	push   $0x0
  1066fa:	68 b3 00 00 00       	push   $0xb3
  1066ff:	e9 bc f5 ff ff       	jmp    105cc0 <alltraps>

00106704 <vector180>:
  106704:	6a 00                	push   $0x0
  106706:	68 b4 00 00 00       	push   $0xb4
  10670b:	e9 b0 f5 ff ff       	jmp    105cc0 <alltraps>

00106710 <vector181>:
  106710:	6a 00                	push   $0x0
  106712:	68 b5 00 00 00       	push   $0xb5
  106717:	e9 a4 f5 ff ff       	jmp    105cc0 <alltraps>

0010671c <vector182>:
  10671c:	6a 00                	push   $0x0
  10671e:	68 b6 00 00 00       	push   $0xb6
  106723:	e9 98 f5 ff ff       	jmp    105cc0 <alltraps>

00106728 <vector183>:
  106728:	6a 00                	push   $0x0
  10672a:	68 b7 00 00 00       	push   $0xb7
  10672f:	e9 8c f5 ff ff       	jmp    105cc0 <alltraps>

00106734 <vector184>:
  106734:	6a 00                	push   $0x0
  106736:	68 b8 00 00 00       	push   $0xb8
  10673b:	e9 80 f5 ff ff       	jmp    105cc0 <alltraps>

00106740 <vector185>:
  106740:	6a 00                	push   $0x0
  106742:	68 b9 00 00 00       	push   $0xb9
  106747:	e9 74 f5 ff ff       	jmp    105cc0 <alltraps>

0010674c <vector186>:
  10674c:	6a 00                	push   $0x0
  10674e:	68 ba 00 00 00       	push   $0xba
  106753:	e9 68 f5 ff ff       	jmp    105cc0 <alltraps>

00106758 <vector187>:
  106758:	6a 00                	push   $0x0
  10675a:	68 bb 00 00 00       	push   $0xbb
  10675f:	e9 5c f5 ff ff       	jmp    105cc0 <alltraps>

00106764 <vector188>:
  106764:	6a 00                	push   $0x0
  106766:	68 bc 00 00 00       	push   $0xbc
  10676b:	e9 50 f5 ff ff       	jmp    105cc0 <alltraps>

00106770 <vector189>:
  106770:	6a 00                	push   $0x0
  106772:	68 bd 00 00 00       	push   $0xbd
  106777:	e9 44 f5 ff ff       	jmp    105cc0 <alltraps>

0010677c <vector190>:
  10677c:	6a 00                	push   $0x0
  10677e:	68 be 00 00 00       	push   $0xbe
  106783:	e9 38 f5 ff ff       	jmp    105cc0 <alltraps>

00106788 <vector191>:
  106788:	6a 00                	push   $0x0
  10678a:	68 bf 00 00 00       	push   $0xbf
  10678f:	e9 2c f5 ff ff       	jmp    105cc0 <alltraps>

00106794 <vector192>:
  106794:	6a 00                	push   $0x0
  106796:	68 c0 00 00 00       	push   $0xc0
  10679b:	e9 20 f5 ff ff       	jmp    105cc0 <alltraps>

001067a0 <vector193>:
  1067a0:	6a 00                	push   $0x0
  1067a2:	68 c1 00 00 00       	push   $0xc1
  1067a7:	e9 14 f5 ff ff       	jmp    105cc0 <alltraps>

001067ac <vector194>:
  1067ac:	6a 00                	push   $0x0
  1067ae:	68 c2 00 00 00       	push   $0xc2
  1067b3:	e9 08 f5 ff ff       	jmp    105cc0 <alltraps>

001067b8 <vector195>:
  1067b8:	6a 00                	push   $0x0
  1067ba:	68 c3 00 00 00       	push   $0xc3
  1067bf:	e9 fc f4 ff ff       	jmp    105cc0 <alltraps>

001067c4 <vector196>:
  1067c4:	6a 00                	push   $0x0
  1067c6:	68 c4 00 00 00       	push   $0xc4
  1067cb:	e9 f0 f4 ff ff       	jmp    105cc0 <alltraps>

001067d0 <vector197>:
  1067d0:	6a 00                	push   $0x0
  1067d2:	68 c5 00 00 00       	push   $0xc5
  1067d7:	e9 e4 f4 ff ff       	jmp    105cc0 <alltraps>

001067dc <vector198>:
  1067dc:	6a 00                	push   $0x0
  1067de:	68 c6 00 00 00       	push   $0xc6
  1067e3:	e9 d8 f4 ff ff       	jmp    105cc0 <alltraps>

001067e8 <vector199>:
  1067e8:	6a 00                	push   $0x0
  1067ea:	68 c7 00 00 00       	push   $0xc7
  1067ef:	e9 cc f4 ff ff       	jmp    105cc0 <alltraps>

001067f4 <vector200>:
  1067f4:	6a 00                	push   $0x0
  1067f6:	68 c8 00 00 00       	push   $0xc8
  1067fb:	e9 c0 f4 ff ff       	jmp    105cc0 <alltraps>

00106800 <vector201>:
  106800:	6a 00                	push   $0x0
  106802:	68 c9 00 00 00       	push   $0xc9
  106807:	e9 b4 f4 ff ff       	jmp    105cc0 <alltraps>

0010680c <vector202>:
  10680c:	6a 00                	push   $0x0
  10680e:	68 ca 00 00 00       	push   $0xca
  106813:	e9 a8 f4 ff ff       	jmp    105cc0 <alltraps>

00106818 <vector203>:
  106818:	6a 00                	push   $0x0
  10681a:	68 cb 00 00 00       	push   $0xcb
  10681f:	e9 9c f4 ff ff       	jmp    105cc0 <alltraps>

00106824 <vector204>:
  106824:	6a 00                	push   $0x0
  106826:	68 cc 00 00 00       	push   $0xcc
  10682b:	e9 90 f4 ff ff       	jmp    105cc0 <alltraps>

00106830 <vector205>:
  106830:	6a 00                	push   $0x0
  106832:	68 cd 00 00 00       	push   $0xcd
  106837:	e9 84 f4 ff ff       	jmp    105cc0 <alltraps>

0010683c <vector206>:
  10683c:	6a 00                	push   $0x0
  10683e:	68 ce 00 00 00       	push   $0xce
  106843:	e9 78 f4 ff ff       	jmp    105cc0 <alltraps>

00106848 <vector207>:
  106848:	6a 00                	push   $0x0
  10684a:	68 cf 00 00 00       	push   $0xcf
  10684f:	e9 6c f4 ff ff       	jmp    105cc0 <alltraps>

00106854 <vector208>:
  106854:	6a 00                	push   $0x0
  106856:	68 d0 00 00 00       	push   $0xd0
  10685b:	e9 60 f4 ff ff       	jmp    105cc0 <alltraps>

00106860 <vector209>:
  106860:	6a 00                	push   $0x0
  106862:	68 d1 00 00 00       	push   $0xd1
  106867:	e9 54 f4 ff ff       	jmp    105cc0 <alltraps>

0010686c <vector210>:
  10686c:	6a 00                	push   $0x0
  10686e:	68 d2 00 00 00       	push   $0xd2
  106873:	e9 48 f4 ff ff       	jmp    105cc0 <alltraps>

00106878 <vector211>:
  106878:	6a 00                	push   $0x0
  10687a:	68 d3 00 00 00       	push   $0xd3
  10687f:	e9 3c f4 ff ff       	jmp    105cc0 <alltraps>

00106884 <vector212>:
  106884:	6a 00                	push   $0x0
  106886:	68 d4 00 00 00       	push   $0xd4
  10688b:	e9 30 f4 ff ff       	jmp    105cc0 <alltraps>

00106890 <vector213>:
  106890:	6a 00                	push   $0x0
  106892:	68 d5 00 00 00       	push   $0xd5
  106897:	e9 24 f4 ff ff       	jmp    105cc0 <alltraps>

0010689c <vector214>:
  10689c:	6a 00                	push   $0x0
  10689e:	68 d6 00 00 00       	push   $0xd6
  1068a3:	e9 18 f4 ff ff       	jmp    105cc0 <alltraps>

001068a8 <vector215>:
  1068a8:	6a 00                	push   $0x0
  1068aa:	68 d7 00 00 00       	push   $0xd7
  1068af:	e9 0c f4 ff ff       	jmp    105cc0 <alltraps>

001068b4 <vector216>:
  1068b4:	6a 00                	push   $0x0
  1068b6:	68 d8 00 00 00       	push   $0xd8
  1068bb:	e9 00 f4 ff ff       	jmp    105cc0 <alltraps>

001068c0 <vector217>:
  1068c0:	6a 00                	push   $0x0
  1068c2:	68 d9 00 00 00       	push   $0xd9
  1068c7:	e9 f4 f3 ff ff       	jmp    105cc0 <alltraps>

001068cc <vector218>:
  1068cc:	6a 00                	push   $0x0
  1068ce:	68 da 00 00 00       	push   $0xda
  1068d3:	e9 e8 f3 ff ff       	jmp    105cc0 <alltraps>

001068d8 <vector219>:
  1068d8:	6a 00                	push   $0x0
  1068da:	68 db 00 00 00       	push   $0xdb
  1068df:	e9 dc f3 ff ff       	jmp    105cc0 <alltraps>

001068e4 <vector220>:
  1068e4:	6a 00                	push   $0x0
  1068e6:	68 dc 00 00 00       	push   $0xdc
  1068eb:	e9 d0 f3 ff ff       	jmp    105cc0 <alltraps>

001068f0 <vector221>:
  1068f0:	6a 00                	push   $0x0
  1068f2:	68 dd 00 00 00       	push   $0xdd
  1068f7:	e9 c4 f3 ff ff       	jmp    105cc0 <alltraps>

001068fc <vector222>:
  1068fc:	6a 00                	push   $0x0
  1068fe:	68 de 00 00 00       	push   $0xde
  106903:	e9 b8 f3 ff ff       	jmp    105cc0 <alltraps>

00106908 <vector223>:
  106908:	6a 00                	push   $0x0
  10690a:	68 df 00 00 00       	push   $0xdf
  10690f:	e9 ac f3 ff ff       	jmp    105cc0 <alltraps>

00106914 <vector224>:
  106914:	6a 00                	push   $0x0
  106916:	68 e0 00 00 00       	push   $0xe0
  10691b:	e9 a0 f3 ff ff       	jmp    105cc0 <alltraps>

00106920 <vector225>:
  106920:	6a 00                	push   $0x0
  106922:	68 e1 00 00 00       	push   $0xe1
  106927:	e9 94 f3 ff ff       	jmp    105cc0 <alltraps>

0010692c <vector226>:
  10692c:	6a 00                	push   $0x0
  10692e:	68 e2 00 00 00       	push   $0xe2
  106933:	e9 88 f3 ff ff       	jmp    105cc0 <alltraps>

00106938 <vector227>:
  106938:	6a 00                	push   $0x0
  10693a:	68 e3 00 00 00       	push   $0xe3
  10693f:	e9 7c f3 ff ff       	jmp    105cc0 <alltraps>

00106944 <vector228>:
  106944:	6a 00                	push   $0x0
  106946:	68 e4 00 00 00       	push   $0xe4
  10694b:	e9 70 f3 ff ff       	jmp    105cc0 <alltraps>

00106950 <vector229>:
  106950:	6a 00                	push   $0x0
  106952:	68 e5 00 00 00       	push   $0xe5
  106957:	e9 64 f3 ff ff       	jmp    105cc0 <alltraps>

0010695c <vector230>:
  10695c:	6a 00                	push   $0x0
  10695e:	68 e6 00 00 00       	push   $0xe6
  106963:	e9 58 f3 ff ff       	jmp    105cc0 <alltraps>

00106968 <vector231>:
  106968:	6a 00                	push   $0x0
  10696a:	68 e7 00 00 00       	push   $0xe7
  10696f:	e9 4c f3 ff ff       	jmp    105cc0 <alltraps>

00106974 <vector232>:
  106974:	6a 00                	push   $0x0
  106976:	68 e8 00 00 00       	push   $0xe8
  10697b:	e9 40 f3 ff ff       	jmp    105cc0 <alltraps>

00106980 <vector233>:
  106980:	6a 00                	push   $0x0
  106982:	68 e9 00 00 00       	push   $0xe9
  106987:	e9 34 f3 ff ff       	jmp    105cc0 <alltraps>

0010698c <vector234>:
  10698c:	6a 00                	push   $0x0
  10698e:	68 ea 00 00 00       	push   $0xea
  106993:	e9 28 f3 ff ff       	jmp    105cc0 <alltraps>

00106998 <vector235>:
  106998:	6a 00                	push   $0x0
  10699a:	68 eb 00 00 00       	push   $0xeb
  10699f:	e9 1c f3 ff ff       	jmp    105cc0 <alltraps>

001069a4 <vector236>:
  1069a4:	6a 00                	push   $0x0
  1069a6:	68 ec 00 00 00       	push   $0xec
  1069ab:	e9 10 f3 ff ff       	jmp    105cc0 <alltraps>

001069b0 <vector237>:
  1069b0:	6a 00                	push   $0x0
  1069b2:	68 ed 00 00 00       	push   $0xed
  1069b7:	e9 04 f3 ff ff       	jmp    105cc0 <alltraps>

001069bc <vector238>:
  1069bc:	6a 00                	push   $0x0
  1069be:	68 ee 00 00 00       	push   $0xee
  1069c3:	e9 f8 f2 ff ff       	jmp    105cc0 <alltraps>

001069c8 <vector239>:
  1069c8:	6a 00                	push   $0x0
  1069ca:	68 ef 00 00 00       	push   $0xef
  1069cf:	e9 ec f2 ff ff       	jmp    105cc0 <alltraps>

001069d4 <vector240>:
  1069d4:	6a 00                	push   $0x0
  1069d6:	68 f0 00 00 00       	push   $0xf0
  1069db:	e9 e0 f2 ff ff       	jmp    105cc0 <alltraps>

001069e0 <vector241>:
  1069e0:	6a 00                	push   $0x0
  1069e2:	68 f1 00 00 00       	push   $0xf1
  1069e7:	e9 d4 f2 ff ff       	jmp    105cc0 <alltraps>

001069ec <vector242>:
  1069ec:	6a 00                	push   $0x0
  1069ee:	68 f2 00 00 00       	push   $0xf2
  1069f3:	e9 c8 f2 ff ff       	jmp    105cc0 <alltraps>

001069f8 <vector243>:
  1069f8:	6a 00                	push   $0x0
  1069fa:	68 f3 00 00 00       	push   $0xf3
  1069ff:	e9 bc f2 ff ff       	jmp    105cc0 <alltraps>

00106a04 <vector244>:
  106a04:	6a 00                	push   $0x0
  106a06:	68 f4 00 00 00       	push   $0xf4
  106a0b:	e9 b0 f2 ff ff       	jmp    105cc0 <alltraps>

00106a10 <vector245>:
  106a10:	6a 00                	push   $0x0
  106a12:	68 f5 00 00 00       	push   $0xf5
  106a17:	e9 a4 f2 ff ff       	jmp    105cc0 <alltraps>

00106a1c <vector246>:
  106a1c:	6a 00                	push   $0x0
  106a1e:	68 f6 00 00 00       	push   $0xf6
  106a23:	e9 98 f2 ff ff       	jmp    105cc0 <alltraps>

00106a28 <vector247>:
  106a28:	6a 00                	push   $0x0
  106a2a:	68 f7 00 00 00       	push   $0xf7
  106a2f:	e9 8c f2 ff ff       	jmp    105cc0 <alltraps>

00106a34 <vector248>:
  106a34:	6a 00                	push   $0x0
  106a36:	68 f8 00 00 00       	push   $0xf8
  106a3b:	e9 80 f2 ff ff       	jmp    105cc0 <alltraps>

00106a40 <vector249>:
  106a40:	6a 00                	push   $0x0
  106a42:	68 f9 00 00 00       	push   $0xf9
  106a47:	e9 74 f2 ff ff       	jmp    105cc0 <alltraps>

00106a4c <vector250>:
  106a4c:	6a 00                	push   $0x0
  106a4e:	68 fa 00 00 00       	push   $0xfa
  106a53:	e9 68 f2 ff ff       	jmp    105cc0 <alltraps>

00106a58 <vector251>:
  106a58:	6a 00                	push   $0x0
  106a5a:	68 fb 00 00 00       	push   $0xfb
  106a5f:	e9 5c f2 ff ff       	jmp    105cc0 <alltraps>

00106a64 <vector252>:
  106a64:	6a 00                	push   $0x0
  106a66:	68 fc 00 00 00       	push   $0xfc
  106a6b:	e9 50 f2 ff ff       	jmp    105cc0 <alltraps>

00106a70 <vector253>:
  106a70:	6a 00                	push   $0x0
  106a72:	68 fd 00 00 00       	push   $0xfd
  106a77:	e9 44 f2 ff ff       	jmp    105cc0 <alltraps>

00106a7c <vector254>:
  106a7c:	6a 00                	push   $0x0
  106a7e:	68 fe 00 00 00       	push   $0xfe
  106a83:	e9 38 f2 ff ff       	jmp    105cc0 <alltraps>

00106a88 <vector255>:
  106a88:	6a 00                	push   $0x0
  106a8a:	68 ff 00 00 00       	push   $0xff
  106a8f:	e9 2c f2 ff ff       	jmp    105cc0 <alltraps>
