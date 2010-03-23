
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
  100016:	e8 05 47 00 00       	call   104720 <acquire>

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
  100051:	e8 8a 35 00 00       	call   1035e0 <wakeup>

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
  100062:	e9 79 46 00 00       	jmp    1046e0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 c0 68 10 00 	movl   $0x1068c0,(%esp)
  10006e:	e8 fd 08 00 00       	call   100970 <panic>
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
  100095:	e8 86 46 00 00       	call   104720 <acquire>

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
  1000c9:	e8 12 46 00 00       	call   1046e0 <release>
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
  1000e7:	e8 f4 45 00 00       	call   1046e0 <release>
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
  100119:	e9 c2 21 00 00       	jmp    1022e0 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10011e:	c7 04 24 c7 68 10 00 	movl   $0x1068c7,(%esp)
  100125:	e8 46 08 00 00       	call   100970 <panic>
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
  100146:	e8 d5 45 00 00       	call   104720 <acquire>

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
  100180:	74 7d                	je     1001ff <bread+0xcf>
        sleep(buf, &buf_table_lock);
  100182:	c7 44 24 04 00 a0 10 	movl   $0x10a000,0x4(%esp)
  100189:	00 
  10018a:	c7 04 24 00 8b 10 00 	movl   $0x108b00,(%esp)
  100191:	e8 fa 37 00 00       	call   103990 <sleep>
  100196:	eb b3                	jmp    10014b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100198:	8b 1d ec 88 10 00    	mov    0x1088ec,%ebx
  10019e:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  1001a4:	75 19                	jne    1001bf <bread+0x8f>
  1001a6:	eb 4b                	jmp    1001f3 <bread+0xc3>
      b->dev = dev;
      b->sector = sector;
      release(&buf_table_lock);
      return b;
    }
    cprintf("here2\n");
  1001a8:	c7 04 24 ce 68 10 00 	movl   $0x1068ce,(%esp)
  1001af:	e8 1c 06 00 00       	call   1007d0 <cprintf>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  1001b4:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1001b7:	81 fb e0 88 10 00    	cmp    $0x1088e0,%ebx
  1001bd:	74 34                	je     1001f3 <bread+0xc3>
    if((b->flags & B_BUSY) == 0){
  1001bf:	f6 03 01             	testb  $0x1,(%ebx)
  1001c2:	75 e4                	jne    1001a8 <bread+0x78>
      b->flags = B_BUSY;
  1001c4:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      b->dev = dev;
  1001ca:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  1001cd:	89 7b 08             	mov    %edi,0x8(%ebx)
      release(&buf_table_lock);
  1001d0:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  1001d7:	e8 04 45 00 00       	call   1046e0 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  1001dc:	f6 03 02             	testb  $0x2,(%ebx)
  1001df:	75 08                	jne    1001e9 <bread+0xb9>
    ide_rw(b);
  1001e1:	89 1c 24             	mov    %ebx,(%esp)
  1001e4:	e8 f7 20 00 00       	call   1022e0 <ide_rw>
  return b;
}
  1001e9:	83 c4 1c             	add    $0x1c,%esp
  1001ec:	89 d8                	mov    %ebx,%eax
  1001ee:	5b                   	pop    %ebx
  1001ef:	5e                   	pop    %esi
  1001f0:	5f                   	pop    %edi
  1001f1:	5d                   	pop    %ebp
  1001f2:	c3                   	ret    
      release(&buf_table_lock);
      return b;
    }
    cprintf("here2\n");
  }
  panic("bget: no buffers");
  1001f3:	c7 04 24 d5 68 10 00 	movl   $0x1068d5,(%esp)
  1001fa:	e8 71 07 00 00       	call   100970 <panic>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
        sleep(buf, &buf_table_lock);
        goto loop;
      }
      b->flags |= B_BUSY;
  1001ff:	83 c8 01             	or     $0x1,%eax
  100202:	89 03                	mov    %eax,(%ebx)
      release(&buf_table_lock);
  100204:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  10020b:	e8 d0 44 00 00       	call   1046e0 <release>
  100210:	eb ca                	jmp    1001dc <bread+0xac>
  100212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100220 <binit>:
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
{
  100220:	55                   	push   %ebp
  100221:	89 e5                	mov    %esp,%ebp
  100223:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");
  100226:	c7 44 24 04 e6 68 10 	movl   $0x1068e6,0x4(%esp)
  10022d:	00 
  10022e:	c7 04 24 00 a0 10 00 	movl   $0x10a000,(%esp)
  100235:	e8 26 43 00 00       	call   104560 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10023a:	b8 f0 9f 10 00       	mov    $0x109ff0,%eax
  10023f:	3d 00 8b 10 00       	cmp    $0x108b00,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  100244:	c7 05 ec 88 10 00 e0 	movl   $0x1088e0,0x1088ec
  10024b:	88 10 00 
  bufhead.next = &bufhead;
  10024e:	c7 05 f0 88 10 00 e0 	movl   $0x1088e0,0x1088f0
  100255:	88 10 00 
  for(b = buf; b < buf+NBUF; b++){
  100258:	76 33                	jbe    10028d <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  10025a:	ba e0 88 10 00       	mov    $0x1088e0,%edx
  10025f:	b8 00 8b 10 00       	mov    $0x108b00,%eax
  100264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100268:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  10026b:	c7 40 0c e0 88 10 00 	movl   $0x1088e0,0xc(%eax)
    bufhead.next->prev = b;
  100272:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100275:	89 c2                	mov    %eax,%edx
  100277:	05 18 02 00 00       	add    $0x218,%eax
  10027c:	3d f0 9f 10 00       	cmp    $0x109ff0,%eax
  100281:	75 e5                	jne    100268 <binit+0x48>
  100283:	c7 05 f0 88 10 00 d8 	movl   $0x109dd8,0x1088f0
  10028a:	9d 10 00 
    b->next = bufhead.next;
    b->prev = &bufhead;
    bufhead.next->prev = b;
    bufhead.next = b;
  }
}
  10028d:	c9                   	leave  
  10028e:	c3                   	ret    
  10028f:	90                   	nop

00100290 <console_init>:
  return target - n;
}

void
console_init(void)
{
  100290:	55                   	push   %ebp
  100291:	89 e5                	mov    %esp,%ebp
  100293:	83 ec 18             	sub    $0x18,%esp
  initlock(&console_lock, "console");
  100296:	c7 44 24 04 f0 68 10 	movl   $0x1068f0,0x4(%esp)
  10029d:	00 
  10029e:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  1002a5:	e8 b6 42 00 00       	call   104560 <initlock>
  initlock(&input.lock, "console input");
  1002aa:	c7 44 24 04 f8 68 10 	movl   $0x1068f8,0x4(%esp)
  1002b1:	00 
  1002b2:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  1002b9:	e8 a2 42 00 00       	call   104560 <initlock>

  devsw[CONSOLE].write = console_write;
  devsw[CONSOLE].read = console_read;
  use_console_lock = 1;

  pic_enable(IRQ_KBD);
  1002be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
console_init(void)
{
  initlock(&console_lock, "console");
  initlock(&input.lock, "console input");

  devsw[CONSOLE].write = console_write;
  1002c5:	c7 05 ac aa 10 00 e0 	movl   $0x1006e0,0x10aaac
  1002cc:	06 10 00 
  devsw[CONSOLE].read = console_read;
  1002cf:	c7 05 a8 aa 10 00 00 	movl   $0x100300,0x10aaa8
  1002d6:	03 10 00 
  use_console_lock = 1;
  1002d9:	c7 05 24 88 10 00 01 	movl   $0x1,0x108824
  1002e0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002e3:	e8 08 2d 00 00       	call   102ff0 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002ef:	00 
  1002f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002f7:	e8 d4 21 00 00       	call   1024d0 <ioapic_enable>
}
  1002fc:	c9                   	leave  
  1002fd:	c3                   	ret    
  1002fe:	66 90                	xchg   %ax,%ax

00100300 <console_read>:
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  100300:	55                   	push   %ebp
  100301:	89 e5                	mov    %esp,%ebp
  100303:	57                   	push   %edi
  100304:	56                   	push   %esi
  100305:	53                   	push   %ebx
  100306:	83 ec 2c             	sub    $0x2c,%esp
  100309:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10030c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  10030f:	89 34 24             	mov    %esi,(%esp)
  100312:	e8 a9 1b 00 00       	call   101ec0 <iunlock>
  target = n;
  100317:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10031a:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  100321:	e8 fa 43 00 00       	call   104720 <acquire>
  while(n > 0){
  100326:	85 db                	test   %ebx,%ebx
  100328:	7f 26                	jg     100350 <console_read+0x50>
  10032a:	e9 bb 00 00 00       	jmp    1003ea <console_read+0xea>
  10032f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  100330:	e8 ab 33 00 00       	call   1036e0 <curproc>
  100335:	8b 40 1c             	mov    0x1c(%eax),%eax
  100338:	85 c0                	test   %eax,%eax
  10033a:	75 5c                	jne    100398 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10033c:	c7 44 24 04 40 a0 10 	movl   $0x10a040,0x4(%esp)
  100343:	00 
  100344:	c7 04 24 f4 a0 10 00 	movl   $0x10a0f4,(%esp)
  10034b:	e8 40 36 00 00       	call   103990 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100350:	a1 f4 a0 10 00       	mov    0x10a0f4,%eax
  100355:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  10035b:	74 d3                	je     100330 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10035d:	89 c2                	mov    %eax,%edx
  10035f:	83 e2 7f             	and    $0x7f,%edx
  100362:	0f b6 8a 74 a0 10 00 	movzbl 0x10a074(%edx),%ecx
  100369:	8d 78 01             	lea    0x1(%eax),%edi
  10036c:	89 3d f4 a0 10 00    	mov    %edi,0x10a0f4
  100372:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
  100375:	83 fa 04             	cmp    $0x4,%edx
  100378:	74 3f                	je     1003b9 <console_read+0xb9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10037a:	8b 45 0c             	mov    0xc(%ebp),%eax
    --n;
  10037d:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  100380:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  100383:	88 08                	mov    %cl,(%eax)
    --n;
    if(c == '\n')
  100385:	74 3c                	je     1003c3 <console_read+0xc3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  100387:	85 db                	test   %ebx,%ebx
  100389:	7e 38                	jle    1003c3 <console_read+0xc3>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10038b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  10038f:	eb bf                	jmp    100350 <console_read+0x50>
  100391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100398:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  10039f:	e8 3c 43 00 00       	call   1046e0 <release>
        ilock(ip);
  1003a4:	89 34 24             	mov    %esi,(%esp)
  1003a7:	e8 84 1b 00 00       	call   101f30 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  1003ac:	83 c4 2c             	add    $0x2c,%esp
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
        ilock(ip);
  1003af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  1003b4:	5b                   	pop    %ebx
  1003b5:	5e                   	pop    %esi
  1003b6:	5f                   	pop    %edi
  1003b7:	5d                   	pop    %ebp
  1003b8:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  1003b9:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  1003bc:	76 05                	jbe    1003c3 <console_read+0xc3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  1003be:	a3 f4 a0 10 00       	mov    %eax,0x10a0f4
  1003c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1003c6:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1003c8:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  1003cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1003d2:	e8 09 43 00 00       	call   1046e0 <release>
  ilock(ip);
  1003d7:	89 34 24             	mov    %esi,(%esp)
  1003da:	e8 51 1b 00 00       	call   101f30 <ilock>
  1003df:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
  1003e2:	83 c4 2c             	add    $0x2c,%esp
  1003e5:	5b                   	pop    %ebx
  1003e6:	5e                   	pop    %esi
  1003e7:	5f                   	pop    %edi
  1003e8:	5d                   	pop    %ebp
  1003e9:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1003ea:	31 c0                	xor    %eax,%eax
  1003ec:	eb da                	jmp    1003c8 <console_read+0xc8>
  1003ee:	66 90                	xchg   %ax,%ax

001003f0 <cons_putc>:
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  1003f0:	55                   	push   %ebp
  1003f1:	89 e5                	mov    %esp,%ebp
  1003f3:	57                   	push   %edi
  1003f4:	56                   	push   %esi
  1003f5:	53                   	push   %ebx
  1003f6:	83 ec 1c             	sub    $0x1c,%esp
  1003f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(panicked){
  1003fc:	83 3d 20 88 10 00 00 	cmpl   $0x0,0x108820
  100403:	0f 85 e1 00 00 00    	jne    1004ea <cons_putc+0xfa>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100409:	b8 79 03 00 00       	mov    $0x379,%eax
  10040e:	89 c2                	mov    %eax,%edx
  100410:	ec                   	in     (%dx),%al
}

static inline void
cli(void)
{
  asm volatile("cli");
  100411:	31 db                	xor    %ebx,%ebx
static void
lpt_putc(int c)
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
  100413:	84 c0                	test   %al,%al
  100415:	79 14                	jns    10042b <cons_putc+0x3b>
  100417:	eb 19                	jmp    100432 <cons_putc+0x42>
  100419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100420:	83 c3 01             	add    $0x1,%ebx
  100423:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
  100429:	74 07                	je     100432 <cons_putc+0x42>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10042b:	ec                   	in     (%dx),%al
  10042c:	84 c0                	test   %al,%al
  10042e:	66 90                	xchg   %ax,%ax
  100430:	79 ee                	jns    100420 <cons_putc+0x30>
    ;
  if(c == BACKSPACE)
  100432:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  100438:	89 c8                	mov    %ecx,%eax
  10043a:	0f 84 ad 00 00 00    	je     1004ed <cons_putc+0xfd>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100440:	ba 78 03 00 00       	mov    $0x378,%edx
  100445:	ee                   	out    %al,(%dx)
  100446:	b8 0d 00 00 00       	mov    $0xd,%eax
  10044b:	b2 7a                	mov    $0x7a,%dl
  10044d:	ee                   	out    %al,(%dx)
  10044e:	b8 08 00 00 00       	mov    $0x8,%eax
  100453:	ee                   	out    %al,(%dx)
  100454:	be d4 03 00 00       	mov    $0x3d4,%esi
  100459:	b8 0e 00 00 00       	mov    $0xe,%eax
  10045e:	89 f2                	mov    %esi,%edx
  100460:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100461:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100466:	89 fa                	mov    %edi,%edx
  100468:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  100469:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10046c:	89 f2                	mov    %esi,%edx
  10046e:	c1 e3 08             	shl    $0x8,%ebx
  100471:	b8 0f 00 00 00       	mov    $0xf,%eax
  100476:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100477:	89 fa                	mov    %edi,%edx
  100479:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  10047a:	0f b6 c0             	movzbl %al,%eax
  10047d:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  10047f:	83 f9 0a             	cmp    $0xa,%ecx
  100482:	0f 84 da 00 00 00    	je     100562 <cons_putc+0x172>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  100488:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  10048e:	0f 84 ad 00 00 00    	je     100541 <cons_putc+0x151>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  100494:	66 81 e1 ff 00       	and    $0xff,%cx
  100499:	80 cd 07             	or     $0x7,%ch
  10049c:	66 89 8c 1b 00 80 0b 	mov    %cx,0xb8000(%ebx,%ebx,1)
  1004a3:	00 
  1004a4:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  1004a7:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  1004ad:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  1004b4:	7f 41                	jg     1004f7 <cons_putc+0x107>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1004b6:	be d4 03 00 00       	mov    $0x3d4,%esi
  1004bb:	b8 0e 00 00 00       	mov    $0xe,%eax
  1004c0:	89 f2                	mov    %esi,%edx
  1004c2:	ee                   	out    %al,(%dx)
  1004c3:	bf d5 03 00 00       	mov    $0x3d5,%edi
  1004c8:	89 d8                	mov    %ebx,%eax
  1004ca:	c1 f8 08             	sar    $0x8,%eax
  1004cd:	89 fa                	mov    %edi,%edx
  1004cf:	ee                   	out    %al,(%dx)
  1004d0:	b8 0f 00 00 00       	mov    $0xf,%eax
  1004d5:	89 f2                	mov    %esi,%edx
  1004d7:	ee                   	out    %al,(%dx)
  1004d8:	89 d8                	mov    %ebx,%eax
  1004da:	89 fa                	mov    %edi,%edx
  1004dc:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  1004dd:	66 c7 01 20 07       	movw   $0x720,(%ecx)
      ;
  }

  lpt_putc(c);
  cga_putc(c);
}
  1004e2:	83 c4 1c             	add    $0x1c,%esp
  1004e5:	5b                   	pop    %ebx
  1004e6:	5e                   	pop    %esi
  1004e7:	5f                   	pop    %edi
  1004e8:	5d                   	pop    %ebp
  1004e9:	c3                   	ret    
}

static inline void
cli(void)
{
  asm volatile("cli");
  1004ea:	fa                   	cli    
  1004eb:	eb fe                	jmp    1004eb <cons_putc+0xfb>
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
    ;
  if(c == BACKSPACE)
  1004ed:	b8 08 00 00 00       	mov    $0x8,%eax
  1004f2:	e9 49 ff ff ff       	jmp    100440 <cons_putc+0x50>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  1004f7:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  1004fa:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  100501:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100502:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  100509:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  100510:	00 
  100511:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  100518:	e8 03 43 00 00       	call   104820 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10051d:	b8 80 07 00 00       	mov    $0x780,%eax
  100522:	29 d8                	sub    %ebx,%eax
  100524:	01 c0                	add    %eax,%eax
  100526:	89 44 24 08          	mov    %eax,0x8(%esp)
  10052a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100531:	00 
  100532:	89 34 24             	mov    %esi,(%esp)
  100535:	e8 56 42 00 00       	call   104790 <memset>
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
  10053a:	89 f1                	mov    %esi,%ecx
  10053c:	e9 75 ff ff ff       	jmp    1004b6 <cons_putc+0xc6>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  100541:	85 db                	test   %ebx,%ebx
  100543:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  10054a:	0f 8e 66 ff ff ff    	jle    1004b6 <cons_putc+0xc6>
      crt[--pos] = ' ' | 0x0700;
  100550:	83 eb 01             	sub    $0x1,%ebx
  100553:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  10055a:	00 20 07 
  10055d:	e9 45 ff ff ff       	jmp    1004a7 <cons_putc+0xb7>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  100562:	b8 50 00 00 00       	mov    $0x50,%eax
  100567:	89 da                	mov    %ebx,%edx
  100569:	89 c1                	mov    %eax,%ecx
  10056b:	89 d8                	mov    %ebx,%eax
  10056d:	c1 fa 1f             	sar    $0x1f,%edx
  100570:	83 c3 50             	add    $0x50,%ebx
  100573:	f7 f9                	idiv   %ecx
  100575:	29 d3                	sub    %edx,%ebx
  100577:	e9 2b ff ff ff       	jmp    1004a7 <cons_putc+0xb7>
  10057c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100580 <console_intr>:

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100580:	55                   	push   %ebp
  100581:	89 e5                	mov    %esp,%ebp
  100583:	56                   	push   %esi
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  100584:	be 70 a0 10 00       	mov    $0x10a070,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100589:	53                   	push   %ebx
  10058a:	83 ec 20             	sub    $0x20,%esp
  10058d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100590:	c7 04 24 40 a0 10 00 	movl   $0x10a040,(%esp)
  100597:	e8 84 41 00 00       	call   104720 <acquire>
  10059c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
  1005a0:	ff d3                	call   *%ebx
  1005a2:	85 c0                	test   %eax,%eax
  1005a4:	0f 88 8e 00 00 00    	js     100638 <console_intr+0xb8>
    switch(c){
  1005aa:	83 f8 10             	cmp    $0x10,%eax
  1005ad:	8d 76 00             	lea    0x0(%esi),%esi
  1005b0:	0f 84 d2 00 00 00    	je     100688 <console_intr+0x108>
  1005b6:	83 f8 15             	cmp    $0x15,%eax
  1005b9:	0f 84 b7 00 00 00    	je     100676 <console_intr+0xf6>
  1005bf:	83 f8 08             	cmp    $0x8,%eax
  1005c2:	0f 84 d0 00 00 00    	je     100698 <console_intr+0x118>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  1005c8:	85 c0                	test   %eax,%eax
  1005ca:	74 d4                	je     1005a0 <console_intr+0x20>
  1005cc:	8b 15 fc a0 10 00    	mov    0x10a0fc,%edx
  1005d2:	89 d1                	mov    %edx,%ecx
  1005d4:	2b 0d f4 a0 10 00    	sub    0x10a0f4,%ecx
  1005da:	83 f9 7f             	cmp    $0x7f,%ecx
  1005dd:	77 c1                	ja     1005a0 <console_intr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
  1005df:	89 d1                	mov    %edx,%ecx
  1005e1:	83 c2 01             	add    $0x1,%edx
  1005e4:	83 e1 7f             	and    $0x7f,%ecx
  1005e7:	88 44 0e 04          	mov    %al,0x4(%esi,%ecx,1)
        cons_putc(c);
  1005eb:	89 04 24             	mov    %eax,(%esp)
  1005ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  1005f1:	89 15 fc a0 10 00    	mov    %edx,0x10a0fc
        cons_putc(c);
  1005f7:	e8 f4 fd ff ff       	call   1003f0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ff:	83 f8 04             	cmp    $0x4,%eax
  100602:	0f 84 ba 00 00 00    	je     1006c2 <console_intr+0x142>
  100608:	83 f8 0a             	cmp    $0xa,%eax
  10060b:	0f 84 b1 00 00 00    	je     1006c2 <console_intr+0x142>
  100611:	8b 15 f4 a0 10 00    	mov    0x10a0f4,%edx
  100617:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10061c:	83 ea 80             	sub    $0xffffff80,%edx
  10061f:	39 d0                	cmp    %edx,%eax
  100621:	0f 84 a0 00 00 00    	je     1006c7 <console_intr+0x147>
console_intr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  100627:	ff d3                	call   *%ebx
  100629:	85 c0                	test   %eax,%eax
  10062b:	0f 89 79 ff ff ff    	jns    1005aa <console_intr+0x2a>
  100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&input.lock);
  100638:	c7 45 08 40 a0 10 00 	movl   $0x10a040,0x8(%ebp)
}
  10063f:	83 c4 20             	add    $0x20,%esp
  100642:	5b                   	pop    %ebx
  100643:	5e                   	pop    %esi
  100644:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  100645:	e9 96 40 00 00       	jmp    1046e0 <release>
  10064a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  100650:	83 e8 01             	sub    $0x1,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	83 e2 7f             	and    $0x7f,%edx
  100658:	80 ba 74 a0 10 00 0a 	cmpb   $0xa,0x10a074(%edx)
  10065f:	0f 84 3b ff ff ff    	je     1005a0 <console_intr+0x20>
        input.e--;
  100665:	a3 fc a0 10 00       	mov    %eax,0x10a0fc
        cons_putc(BACKSPACE);
  10066a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100671:	e8 7a fd ff ff       	call   1003f0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100676:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10067b:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  100681:	75 cd                	jne    100650 <console_intr+0xd0>
  100683:	e9 18 ff ff ff       	jmp    1005a0 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100688:	e8 f3 2d 00 00       	call   103480 <procdump>
  10068d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
  100690:	e9 0b ff ff ff       	jmp    1005a0 <console_intr+0x20>
  100695:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  100698:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
  10069d:	3b 05 f8 a0 10 00    	cmp    0x10a0f8,%eax
  1006a3:	0f 84 f7 fe ff ff    	je     1005a0 <console_intr+0x20>
        input.e--;
  1006a9:	83 e8 01             	sub    $0x1,%eax
  1006ac:	a3 fc a0 10 00       	mov    %eax,0x10a0fc
        cons_putc(BACKSPACE);
  1006b1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1006b8:	e8 33 fd ff ff       	call   1003f0 <cons_putc>
  1006bd:	e9 de fe ff ff       	jmp    1005a0 <console_intr+0x20>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        cons_putc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1006c2:	a1 fc a0 10 00       	mov    0x10a0fc,%eax
          input.w = input.e;
  1006c7:	a3 f8 a0 10 00       	mov    %eax,0x10a0f8
          wakeup(&input.r);
  1006cc:	c7 04 24 f4 a0 10 00 	movl   $0x10a0f4,(%esp)
  1006d3:	e8 08 2f 00 00       	call   1035e0 <wakeup>
  1006d8:	e9 c3 fe ff ff       	jmp    1005a0 <console_intr+0x20>
  1006dd:	8d 76 00             	lea    0x0(%esi),%esi

001006e0 <console_write>:
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  1006e0:	55                   	push   %ebp
  1006e1:	89 e5                	mov    %esp,%ebp
  1006e3:	57                   	push   %edi
  1006e4:	56                   	push   %esi
  1006e5:	53                   	push   %ebx
  1006e6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
  1006e9:	8b 45 08             	mov    0x8(%ebp),%eax
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  1006ec:	8b 75 10             	mov    0x10(%ebp),%esi
  1006ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 c6 17 00 00       	call   101ec0 <iunlock>
  acquire(&console_lock);
  1006fa:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100701:	e8 1a 40 00 00       	call   104720 <acquire>
  for(i = 0; i < n; i++)
  100706:	85 f6                	test   %esi,%esi
  100708:	7e 19                	jle    100723 <console_write+0x43>
  10070a:	31 db                	xor    %ebx,%ebx
  10070c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cons_putc(buf[i] & 0xff);
  100710:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  100714:	83 c3 01             	add    $0x1,%ebx
    cons_putc(buf[i] & 0xff);
  100717:	89 14 24             	mov    %edx,(%esp)
  10071a:	e8 d1 fc ff ff       	call   1003f0 <cons_putc>
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  10071f:	39 de                	cmp    %ebx,%esi
  100721:	7f ed                	jg     100710 <console_write+0x30>
    cons_putc(buf[i] & 0xff);
  release(&console_lock);
  100723:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  10072a:	e8 b1 3f 00 00       	call   1046e0 <release>
  ilock(ip);
  10072f:	8b 45 08             	mov    0x8(%ebp),%eax
  100732:	89 04 24             	mov    %eax,(%esp)
  100735:	e8 f6 17 00 00       	call   101f30 <ilock>

  return n;
}
  10073a:	83 c4 1c             	add    $0x1c,%esp
  10073d:	89 f0                	mov    %esi,%eax
  10073f:	5b                   	pop    %ebx
  100740:	5e                   	pop    %esi
  100741:	5f                   	pop    %edi
  100742:	5d                   	pop    %ebp
  100743:	c3                   	ret    
  100744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10074a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100750 <printint>:
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  100750:	55                   	push   %ebp
  100751:	89 e5                	mov    %esp,%ebp
  100753:	57                   	push   %edi
  100754:	56                   	push   %esi
  100755:	53                   	push   %ebx
  100756:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100759:	8b 55 10             	mov    0x10(%ebp),%edx
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  10075c:	8b 45 08             	mov    0x8(%ebp),%eax
  10075f:	8b 75 0c             	mov    0xc(%ebp),%esi
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100762:	85 d2                	test   %edx,%edx
  100764:	74 04                	je     10076a <printint+0x1a>
  100766:	85 c0                	test   %eax,%eax
  100768:	78 54                	js     1007be <printint+0x6e>
    neg = 1;
    x = 0 - xx;
  } else {
    x = xx;
  10076a:	31 ff                	xor    %edi,%edi
  10076c:	31 c9                	xor    %ecx,%ecx
  10076e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  do{
    buf[i++] = digits[x % base];
  100778:	31 d2                	xor    %edx,%edx
  10077a:	f7 f6                	div    %esi
  10077c:	0f b6 92 20 69 10 00 	movzbl 0x106920(%edx),%edx
  100783:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  100786:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
  100789:	85 c0                	test   %eax,%eax
  10078b:	75 eb                	jne    100778 <printint+0x28>
  if(neg)
  10078d:	85 ff                	test   %edi,%edi
  10078f:	74 08                	je     100799 <printint+0x49>
    buf[i++] = '-';
  100791:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
  100796:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
  100799:	8d 71 ff             	lea    -0x1(%ecx),%esi
  10079c:	01 f3                	add    %esi,%ebx
  10079e:	66 90                	xchg   %ax,%ax
    cons_putc(buf[i]);
  1007a0:	0f be 03             	movsbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  1007a3:	83 ee 01             	sub    $0x1,%esi
  1007a6:	83 eb 01             	sub    $0x1,%ebx
    cons_putc(buf[i]);
  1007a9:	89 04 24             	mov    %eax,(%esp)
  1007ac:	e8 3f fc ff ff       	call   1003f0 <cons_putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  1007b1:	83 fe ff             	cmp    $0xffffffff,%esi
  1007b4:	75 ea                	jne    1007a0 <printint+0x50>
    cons_putc(buf[i]);
}
  1007b6:	83 c4 2c             	add    $0x2c,%esp
  1007b9:	5b                   	pop    %ebx
  1007ba:	5e                   	pop    %esi
  1007bb:	5f                   	pop    %edi
  1007bc:	5d                   	pop    %ebp
  1007bd:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  1007be:	f7 d8                	neg    %eax
  1007c0:	bf 01 00 00 00       	mov    $0x1,%edi
  1007c5:	eb a5                	jmp    10076c <printint+0x1c>
  1007c7:	89 f6                	mov    %esi,%esi
  1007c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001007d0 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1007d0:	55                   	push   %ebp
  1007d1:	89 e5                	mov    %esp,%ebp
  1007d3:	57                   	push   %edi
  1007d4:	56                   	push   %esi
  1007d5:	53                   	push   %ebx
  1007d6:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  1007d9:	a1 24 88 10 00       	mov    0x108824,%eax
  if(locking)
  1007de:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  1007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
  1007e3:	0f 85 67 01 00 00    	jne    100950 <cprintf+0x180>
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ec:	0f b6 02             	movzbl (%edx),%eax
  1007ef:	84 c0                	test   %al,%al
  1007f1:	0f 84 81 00 00 00    	je     100878 <cprintf+0xa8>

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  1007f7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  1007fa:	31 f6                	xor    %esi,%esi
  1007fc:	31 db                	xor    %ebx,%ebx
  1007fe:	eb 1b                	jmp    10081b <cprintf+0x4b>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    switch(state){
    case 0:
      if(c == '%')
  100800:	83 f8 25             	cmp    $0x25,%eax
  100803:	0f 85 8f 00 00 00    	jne    100898 <cprintf+0xc8>
  100809:	be 25 00 00 00       	mov    $0x25,%esi
  10080e:	66 90                	xchg   %ax,%ax
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100810:	83 c3 01             	add    $0x1,%ebx
  100813:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  100817:	84 c0                	test   %al,%al
  100819:	74 5d                	je     100878 <cprintf+0xa8>
    c = fmt[i] & 0xff;
    switch(state){
  10081b:	85 f6                	test   %esi,%esi
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  10081d:	0f b6 c0             	movzbl %al,%eax
    switch(state){
  100820:	74 de                	je     100800 <cprintf+0x30>
  100822:	83 fe 25             	cmp    $0x25,%esi
  100825:	75 e9                	jne    100810 <cprintf+0x40>
      else
        cons_putc(c);
      break;
    
    case '%':
      switch(c){
  100827:	83 f8 70             	cmp    $0x70,%eax
  10082a:	0f 84 82 00 00 00    	je     1008b2 <cprintf+0xe2>
  100830:	7f 76                	jg     1008a8 <cprintf+0xd8>
  100832:	83 f8 25             	cmp    $0x25,%eax
  100835:	8d 76 00             	lea    0x0(%esi),%esi
  100838:	0f 84 fa 00 00 00    	je     100938 <cprintf+0x168>
  10083e:	83 f8 64             	cmp    $0x64,%eax
  100841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100848:	0f 84 c2 00 00 00    	je     100910 <cprintf+0x140>
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  10084e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100851:	83 c3 01             	add    $0x1,%ebx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  100854:	31 f6                	xor    %esi,%esi
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  100856:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10085d:	e8 8e fb ff ff       	call   1003f0 <cons_putc>
        cons_putc(c);
  100862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100865:	89 04 24             	mov    %eax,(%esp)
  100868:	e8 83 fb ff ff       	call   1003f0 <cons_putc>
  10086d:	8b 55 08             	mov    0x8(%ebp),%edx
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100870:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  100874:	84 c0                	test   %al,%al
  100876:	75 a3                	jne    10081b <cprintf+0x4b>
      state = 0;
      break;
    }
  }

  if(locking)
  100878:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10087b:	85 c9                	test   %ecx,%ecx
  10087d:	74 0c                	je     10088b <cprintf+0xbb>
    release(&console_lock);
  10087f:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100886:	e8 55 3e 00 00       	call   1046e0 <release>
}
  10088b:	83 c4 2c             	add    $0x2c,%esp
  10088e:	5b                   	pop    %ebx
  10088f:	5e                   	pop    %esi
  100890:	5f                   	pop    %edi
  100891:	5d                   	pop    %ebp
  100892:	c3                   	ret    
  100893:	90                   	nop
  100894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(state){
    case 0:
      if(c == '%')
        state = '%';
      else
        cons_putc(c);
  100898:	89 04 24             	mov    %eax,(%esp)
  10089b:	e8 50 fb ff ff       	call   1003f0 <cons_putc>
  1008a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1008a3:	e9 68 ff ff ff       	jmp    100810 <cprintf+0x40>
      break;
    
    case '%':
      switch(c){
  1008a8:	83 f8 73             	cmp    $0x73,%eax
  1008ab:	74 33                	je     1008e0 <cprintf+0x110>
  1008ad:	83 f8 78             	cmp    $0x78,%eax
  1008b0:	75 9c                	jne    10084e <cprintf+0x7e>
      case 'd':
        printint(*argp++, 10, 1);
        break;
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
  1008b2:	8b 07                	mov    (%edi),%eax
  1008b4:	31 f6                	xor    %esi,%esi
  1008b6:	83 c7 04             	add    $0x4,%edi
  1008b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1008c0:	00 
  1008c1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1008c8:	00 
  1008c9:	89 04 24             	mov    %eax,(%esp)
  1008cc:	e8 7f fe ff ff       	call   100750 <printint>
  1008d1:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  1008d4:	e9 37 ff ff ff       	jmp    100810 <cprintf+0x40>
  1008d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      case 's':
        s = (char*)*argp++;
  1008e0:	8b 37                	mov    (%edi),%esi
  1008e2:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
  1008e5:	85 f6                	test   %esi,%esi
  1008e7:	74 78                	je     100961 <cprintf+0x191>
          s = "(null)";
        for(; *s; s++)
  1008e9:	0f b6 06             	movzbl (%esi),%eax
  1008ec:	84 c0                	test   %al,%al
  1008ee:	74 18                	je     100908 <cprintf+0x138>
          cons_putc(*s);
  1008f0:	0f be c0             	movsbl %al,%eax
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  1008f3:	83 c6 01             	add    $0x1,%esi
          cons_putc(*s);
  1008f6:	89 04 24             	mov    %eax,(%esp)
  1008f9:	e8 f2 fa ff ff       	call   1003f0 <cons_putc>
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  1008fe:	0f b6 06             	movzbl (%esi),%eax
  100901:	84 c0                	test   %al,%al
  100903:	75 eb                	jne    1008f0 <cprintf+0x120>
  100905:	8b 55 08             	mov    0x8(%ebp),%edx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  100908:	31 f6                	xor    %esi,%esi
  10090a:	e9 01 ff ff ff       	jmp    100810 <cprintf+0x40>
  10090f:	90                   	nop
      break;
    
    case '%':
      switch(c){
      case 'd':
        printint(*argp++, 10, 1);
  100910:	8b 07                	mov    (%edi),%eax
  100912:	31 f6                	xor    %esi,%esi
  100914:	83 c7 04             	add    $0x4,%edi
  100917:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10091e:	00 
  10091f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  100926:	00 
  100927:	89 04 24             	mov    %eax,(%esp)
  10092a:	e8 21 fe ff ff       	call   100750 <printint>
  10092f:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  100932:	e9 d9 fe ff ff       	jmp    100810 <cprintf+0x40>
  100937:	90                   	nop
          s = "(null)";
        for(; *s; s++)
          cons_putc(*s);
        break;
      case '%':
        cons_putc('%');
  100938:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10093f:	31 f6                	xor    %esi,%esi
  100941:	e8 aa fa ff ff       	call   1003f0 <cons_putc>
  100946:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  100949:	e9 c2 fe ff ff       	jmp    100810 <cprintf+0x40>
  10094e:	66 90                	xchg   %ax,%ax
  uint *argp;
  char *s;

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);
  100950:	c7 04 24 40 88 10 00 	movl   $0x108840,(%esp)
  100957:	e8 c4 3d 00 00       	call   104720 <acquire>
  10095c:	e9 88 fe ff ff       	jmp    1007e9 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  100961:	be 06 69 10 00       	mov    $0x106906,%esi
  100966:	eb 81                	jmp    1008e9 <cprintf+0x119>
  100968:	90                   	nop
  100969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100970 <panic>:
  ioapic_enable(IRQ_KBD, 0);
}

void
panic(char *s)
{
  100970:	55                   	push   %ebp
  100971:	89 e5                	mov    %esp,%ebp
  100973:	56                   	push   %esi
  100974:	53                   	push   %ebx
  100975:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  100978:	c7 05 24 88 10 00 00 	movl   $0x0,0x108824
  10097f:	00 00 00 
panic(char *s)
{
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  100982:	fa                   	cli    
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  100983:	e8 c8 21 00 00       	call   102b50 <cpu>
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  100988:	8d 75 d0             	lea    -0x30(%ebp),%esi
  10098b:	31 db                	xor    %ebx,%ebx
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  10098d:	c7 04 24 0d 69 10 00 	movl   $0x10690d,(%esp)
  100994:	89 44 24 04          	mov    %eax,0x4(%esp)
  100998:	e8 33 fe ff ff       	call   1007d0 <cprintf>
  cprintf(s);
  10099d:	8b 45 08             	mov    0x8(%ebp),%eax
  1009a0:	89 04 24             	mov    %eax,(%esp)
  1009a3:	e8 28 fe ff ff       	call   1007d0 <cprintf>
  cprintf("\n");
  1009a8:	c7 04 24 93 6d 10 00 	movl   $0x106d93,(%esp)
  1009af:	e8 1c fe ff ff       	call   1007d0 <cprintf>
  getcallerpcs(&s, pcs);
  1009b4:	8d 45 08             	lea    0x8(%ebp),%eax
  1009b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1009bb:	89 04 24             	mov    %eax,(%esp)
  1009be:	e8 bd 3b 00 00       	call   104580 <getcallerpcs>
  1009c3:	90                   	nop
  1009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  1009c8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  1009cb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
  1009ce:	c7 04 24 1c 69 10 00 	movl   $0x10691c,(%esp)
  1009d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d9:	e8 f2 fd ff ff       	call   1007d0 <cprintf>
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  1009de:	83 fb 0a             	cmp    $0xa,%ebx
  1009e1:	75 e5                	jne    1009c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  1009e3:	c7 05 20 88 10 00 01 	movl   $0x1,0x108820
  1009ea:	00 00 00 
  1009ed:	eb fe                	jmp    1009ed <panic+0x7d>
  1009ef:	90                   	nop

001009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  1009f0:	55                   	push   %ebp
  1009f1:	89 e5                	mov    %esp,%ebp
  1009f3:	57                   	push   %edi
  1009f4:	56                   	push   %esi
  1009f5:	53                   	push   %ebx
  1009f6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  uint sz, sp, argp;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;

  if((ip = namei(path)) == 0)
  1009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ff:	89 04 24             	mov    %eax,(%esp)
  100a02:	e8 e9 17 00 00       	call   1021f0 <namei>
  100a07:	89 c3                	mov    %eax,%ebx
  100a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100a0e:	85 db                	test   %ebx,%ebx
  100a10:	0f 84 81 03 00 00    	je     100d97 <exec+0x3a7>
    return -1;
  ilock(ip);
  100a16:	89 1c 24             	mov    %ebx,(%esp)
  100a19:	e8 12 15 00 00       	call   101f30 <ilock>
  // Compute memory size of new process.
  mem = 0;
  sz = 0;

  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  100a1e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  100a21:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100a28:	00 
  100a29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100a30:	00 
  100a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a35:	89 1c 24             	mov    %ebx,(%esp)
  100a38:	e8 c3 0b 00 00       	call   101600 <readi>
  100a3d:	83 f8 33             	cmp    $0x33,%eax
  100a40:	0f 86 74 03 00 00    	jbe    100dba <exec+0x3ca>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  100a46:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
  100a4d:	0f 85 67 03 00 00    	jne    100dba <exec+0x3ca>
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100a53:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100a58:	bf ff 1f 00 00       	mov    $0x1fff,%edi
  100a5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100a60:	74 6b                	je     100acd <exec+0xdd>
  100a62:	89 c7                	mov    %eax,%edi
  100a64:	31 f6                	xor    %esi,%esi
  100a66:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100a6d:	eb 0f                	jmp    100a7e <exec+0x8e>
  100a6f:	90                   	nop
  100a70:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100a74:	83 c6 01             	add    $0x1,%esi
  100a77:	39 f0                	cmp    %esi,%eax
  100a79:	7e 49                	jle    100ac4 <exec+0xd4>
  100a7b:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100a7e:	8d 55 c8             	lea    -0x38(%ebp),%edx
  100a81:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100a88:	00 
  100a89:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100a8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a91:	89 1c 24             	mov    %ebx,(%esp)
  100a94:	e8 67 0b 00 00       	call   101600 <readi>
  100a99:	83 f8 20             	cmp    $0x20,%eax
  100a9c:	0f 85 18 03 00 00    	jne    100dba <exec+0x3ca>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100aa2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100aa6:	75 c8                	jne    100a70 <exec+0x80>
      continue;
    if(ph.memsz < ph.filesz)
  100aa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aab:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100aae:	66 90                	xchg   %ax,%ax
  100ab0:	0f 82 04 03 00 00    	jb     100dba <exec+0x3ca>
      goto bad;
    sz += ph.memsz;
  100ab6:	01 45 84             	add    %eax,-0x7c(%ebp)
  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100ab9:	83 c6 01             	add    $0x1,%esi
  100abc:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100ac0:	39 f0                	cmp    %esi,%eax
  100ac2:	7f b7                	jg     100a7b <exec+0x8b>
  100ac4:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100ac7:	81 c7 ff 1f 00 00    	add    $0x1fff,%edi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100acd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ad0:	31 f6                	xor    %esi,%esi
  100ad2:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  100ad9:	00 00 00 
  100adc:	8b 11                	mov    (%ecx),%edx
  100ade:	85 d2                	test   %edx,%edx
  100ae0:	0f 84 ec 02 00 00    	je     100dd2 <exec+0x3e2>
  100ae6:	89 7d 84             	mov    %edi,-0x7c(%ebp)
  100ae9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100aec:	89 5d 80             	mov    %ebx,-0x80(%ebp)
  100aef:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
  100af5:	8d 76 00             	lea    0x0(%esi),%esi
    arglen += strlen(argv[argc]) + 1;
  100af8:	89 14 24             	mov    %edx,(%esp)
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100afb:	83 c3 01             	add    $0x1,%ebx
    arglen += strlen(argv[argc]) + 1;
  100afe:	e8 6d 3e 00 00       	call   104970 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100b03:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
  100b06:	89 d9                	mov    %ebx,%ecx
    arglen += strlen(argv[argc]) + 1;
  100b08:	01 f0                	add    %esi,%eax
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100b0a:	85 d2                	test   %edx,%edx
    arglen += strlen(argv[argc]) + 1;
  100b0c:	8d 70 01             	lea    0x1(%eax),%esi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100b0f:	75 e7                	jne    100af8 <exec+0x108>
  100b11:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
  100b17:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100b1a:	83 c0 04             	add    $0x4,%eax
  100b1d:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100b20:	83 e0 fc             	and    $0xfffffffc,%eax
  100b23:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  100b29:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
  100b2d:	89 8d 74 ff ff ff    	mov    %ecx,-0x8c(%ebp)

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100b33:	8d 3c 38             	lea    (%eax,%edi,1),%edi
  100b36:	89 7d 80             	mov    %edi,-0x80(%ebp)
  100b39:	81 65 80 00 f0 ff ff 	andl   $0xfffff000,-0x80(%ebp)
  mem = kalloc(sz);
  100b40:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100b43:	89 0c 24             	mov    %ecx,(%esp)
  100b46:	e8 75 1a 00 00       	call   1025c0 <kalloc>
  if(mem == 0)
  100b4b:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100b4d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  if(mem == 0)
  100b50:	0f 84 64 02 00 00    	je     100dba <exec+0x3ca>
    goto bad;
  memset(mem, 0, sz);
  100b56:	8b 45 80             	mov    -0x80(%ebp),%eax
  100b59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b60:	00 
  100b61:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b65:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100b68:	89 14 24             	mov    %edx,(%esp)
  100b6b:	e8 20 3c 00 00       	call   104790 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b70:	8b 7d b0             	mov    -0x50(%ebp),%edi
  100b73:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100b78:	0f 84 ab 00 00 00    	je     100c29 <exec+0x239>
  100b7e:	31 f6                	xor    %esi,%esi
  100b80:	eb 18                	jmp    100b9a <exec+0x1aa>
  100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100b88:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100b8c:	83 c6 01             	add    $0x1,%esi
  100b8f:	39 f0                	cmp    %esi,%eax
  100b91:	0f 8e 92 00 00 00    	jle    100c29 <exec+0x239>
  100b97:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100b9a:	8d 4d c8             	lea    -0x38(%ebp),%ecx
  100b9d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100ba4:	00 
  100ba5:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100ba9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bad:	89 1c 24             	mov    %ebx,(%esp)
  100bb0:	e8 4b 0a 00 00       	call   101600 <readi>
  100bb5:	83 f8 20             	cmp    $0x20,%eax
  100bb8:	0f 85 ea 01 00 00    	jne    100da8 <exec+0x3b8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100bbe:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100bc2:	75 c4                	jne    100b88 <exec+0x198>
      continue;
    if(ph.va + ph.memsz > sz)
  100bc4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100bc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100bca:	01 c2                	add    %eax,%edx
  100bcc:	39 55 80             	cmp    %edx,-0x80(%ebp)
  100bcf:	0f 82 d3 01 00 00    	jb     100da8 <exec+0x3b8>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100bd5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100bd8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100bdc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  100bdf:	89 54 24 08          	mov    %edx,0x8(%esp)
  100be3:	03 45 84             	add    -0x7c(%ebp),%eax
  100be6:	89 1c 24             	mov    %ebx,(%esp)
  100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bed:	e8 0e 0a 00 00       	call   101600 <readi>
  100bf2:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100bf5:	0f 85 ad 01 00 00    	jne    100da8 <exec+0x3b8>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100bfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100bfe:	83 c6 01             	add    $0x1,%esi
      continue;
    if(ph.va + ph.memsz > sz)
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100c01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100c08:	00 
  100c09:	29 c2                	sub    %eax,%edx
  100c0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c0f:	03 45 d0             	add    -0x30(%ebp),%eax
  100c12:	03 45 84             	add    -0x7c(%ebp),%eax
  100c15:	89 04 24             	mov    %eax,(%esp)
  100c18:	e8 73 3b 00 00       	call   104790 <memset>
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100c1d:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100c21:	39 f0                	cmp    %esi,%eax
  100c23:	0f 8f 6e ff ff ff    	jg     100b97 <exec+0x1a7>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100c29:	89 1c 24             	mov    %ebx,(%esp)
  100c2c:	e8 df 12 00 00       	call   101f10 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100c37:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c3a:	2b 95 7c ff ff ff    	sub    -0x84(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c40:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c43:	f7 d0                	not    %eax
  100c45:	8d 04 82             	lea    (%edx,%eax,4),%eax

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c48:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100c4e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c54:	89 d7                	mov    %edx,%edi
  100c56:	83 ef 01             	sub    $0x1,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c59:	8d 04 90             	lea    (%eax,%edx,4),%eax
  for(i=argc-1; i>=0; i--){
  100c5c:	83 ff ff             	cmp    $0xffffffff,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c5f:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
  for(i=argc-1; i>=0; i--){
  100c66:	74 62                	je     100cca <exec+0x2da>
  100c68:	8b 75 0c             	mov    0xc(%ebp),%esi
  100c6b:	8d 04 bd 00 00 00 00 	lea    0x0(,%edi,4),%eax
  100c72:	89 ca                	mov    %ecx,%edx
  100c74:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100c77:	01 c6                	add    %eax,%esi
  100c79:	03 85 7c ff ff ff    	add    -0x84(%ebp),%eax
  100c7f:	01 c2                	add    %eax,%edx
  100c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    len = strlen(argv[i]) + 1;
  100c88:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c8a:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
  100c8d:	89 04 24             	mov    %eax,(%esp)
  100c90:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  100c96:	e8 d5 3c 00 00       	call   104970 <strlen>
    sp -= len;
  100c9b:	83 c0 01             	add    $0x1,%eax
  100c9e:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ca4:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100ca6:	83 ee 04             	sub    $0x4,%esi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cad:	8b 45 84             	mov    -0x7c(%ebp),%eax
  100cb0:	01 d8                	add    %ebx,%eax
  100cb2:	89 04 24             	mov    %eax,(%esp)
  100cb5:	e8 66 3b 00 00       	call   104820 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100cba:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  100cc0:	89 1a                	mov    %ebx,(%edx)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100cc2:	83 ea 04             	sub    $0x4,%edx
  100cc5:	83 ff ff             	cmp    $0xffffffff,%edi
  100cc8:	75 be                	jne    100c88 <exec+0x298>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100cca:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100cd0:	8b 55 84             	mov    -0x7c(%ebp),%edx
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100cd3:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  sp -= 4;
  100cd9:	89 c6                	mov    %eax,%esi
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100cdb:	89 44 02 fc          	mov    %eax,-0x4(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  100cdf:	83 ee 0c             	sub    $0xc,%esi
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100ce2:	89 4c 02 f8          	mov    %ecx,-0x8(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100ce6:	c7 44 02 f4 ff ff ff 	movl   $0xffffffff,-0xc(%edx,%eax,1)
  100ced:	ff 

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	0f b6 10             	movzbl (%eax),%edx
  100cf4:	89 c3                	mov    %eax,%ebx
  100cf6:	84 d2                	test   %dl,%dl
  100cf8:	74 21                	je     100d1b <exec+0x32b>
  100cfa:	83 c0 01             	add    $0x1,%eax
  100cfd:	eb 0b                	jmp    100d0a <exec+0x31a>
  100cff:	90                   	nop
  100d00:	0f b6 10             	movzbl (%eax),%edx
  100d03:	83 c0 01             	add    $0x1,%eax
  100d06:	84 d2                	test   %dl,%dl
  100d08:	74 11                	je     100d1b <exec+0x32b>
    if(*s == '/')
  100d0a:	80 fa 2f             	cmp    $0x2f,%dl
  100d0d:	75 f1                	jne    100d00 <exec+0x310>
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100d0f:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
  100d12:	89 c3                	mov    %eax,%ebx
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100d14:	83 c0 01             	add    $0x1,%eax
  100d17:	84 d2                	test   %dl,%dl
  100d19:	75 ef                	jne    100d0a <exec+0x31a>
    if(*s == '/')
      last = s+1;
  safestrcpy(cp->name, last, sizeof(cp->name));
  100d1b:	e8 c0 29 00 00       	call   1036e0 <curproc>
  100d20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d24:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d2b:	00 
  100d2c:	05 88 00 00 00       	add    $0x88,%eax
  100d31:	89 04 24             	mov    %eax,(%esp)
  100d34:	e8 f7 3b 00 00       	call   104930 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100d39:	e8 a2 29 00 00       	call   1036e0 <curproc>
  100d3e:	8b 58 04             	mov    0x4(%eax),%ebx
  100d41:	e8 9a 29 00 00       	call   1036e0 <curproc>
  100d46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d4a:	8b 00                	mov    (%eax),%eax
  100d4c:	89 04 24             	mov    %eax,(%esp)
  100d4f:	e8 2c 19 00 00       	call   102680 <kfree>
  cp->mem = mem;
  100d54:	e8 87 29 00 00       	call   1036e0 <curproc>
  100d59:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d5c:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100d5e:	e8 7d 29 00 00       	call   1036e0 <curproc>
  100d63:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100d66:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d69:	e8 72 29 00 00       	call   1036e0 <curproc>
  100d6e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100d71:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d77:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100d7a:	e8 61 29 00 00       	call   1036e0 <curproc>
  100d7f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d85:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d88:	e8 53 29 00 00       	call   1036e0 <curproc>
  100d8d:	89 04 24             	mov    %eax,(%esp)
  100d90:	e8 1b 2f 00 00       	call   103cb0 <setupsegs>
  100d95:	31 c0                	xor    %eax,%eax
 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  return -1;
}
  100d97:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  100d9d:	5b                   	pop    %ebx
  100d9e:	5e                   	pop    %esi
  100d9f:	5f                   	pop    %edi
  100da0:	5d                   	pop    %ebp
  100da1:	c3                   	ret    
  100da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  setupsegs(cp);
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100da8:	8b 45 80             	mov    -0x80(%ebp),%eax
  100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100daf:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100db2:	89 14 24             	mov    %edx,(%esp)
  100db5:	e8 c6 18 00 00       	call   102680 <kfree>
  iunlockput(ip);
  100dba:	89 1c 24             	mov    %ebx,(%esp)
  100dbd:	e8 4e 11 00 00       	call   101f10 <iunlockput>
  return -1;
}
  100dc2:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100dc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  100dcd:	5b                   	pop    %ebx
  100dce:	5e                   	pop    %esi
  100dcf:	5f                   	pop    %edi
  100dd0:	5d                   	pop    %ebp
  100dd1:	c3                   	ret    
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100dd2:	b8 04 00 00 00       	mov    $0x4,%eax
  100dd7:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100dde:	00 00 00 
  100de1:	c7 85 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebp)
  100de8:	00 00 00 
  100deb:	e9 43 fd ff ff       	jmp    100b33 <exec+0x143>

00100df0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 38             	sub    $0x38,%esp
  100df6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100dfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100dff:	8b 75 0c             	mov    0xc(%ebp),%esi
  100e02:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100e05:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->writable == 0)
  100e08:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100e0c:	74 5a                	je     100e68 <filewrite+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100e0e:	8b 03                	mov    (%ebx),%eax
  100e10:	83 f8 02             	cmp    $0x2,%eax
  100e13:	74 5b                	je     100e70 <filewrite+0x80>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100e15:	83 f8 03             	cmp    $0x3,%eax
  100e18:	75 6d                	jne    100e87 <filewrite+0x97>
    ilock(f->ip);
  100e1a:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1d:	89 04 24             	mov    %eax,(%esp)
  100e20:	e8 0b 11 00 00       	call   101f30 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100e25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e29:	8b 43 14             	mov    0x14(%ebx),%eax
  100e2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e30:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e34:	8b 43 10             	mov    0x10(%ebx),%eax
  100e37:	89 04 24             	mov    %eax,(%esp)
  100e3a:	e8 61 09 00 00       	call   1017a0 <writei>
  100e3f:	85 c0                	test   %eax,%eax
  100e41:	7e 03                	jle    100e46 <filewrite+0x56>
      f->off += r;
  100e43:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e46:	8b 53 10             	mov    0x10(%ebx),%edx
  100e49:	89 14 24             	mov    %edx,(%esp)
  100e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100e4f:	e8 6c 10 00 00       	call   101ec0 <iunlock>
    return r;
  100e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("filewrite");
}
  100e57:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e5a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e5d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e60:	89 ec                	mov    %ebp,%esp
  100e62:	5d                   	pop    %ebp
  100e63:	c3                   	ret    
  100e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e6d:	eb e8                	jmp    100e57 <filewrite+0x67>
  100e6f:	90                   	nop
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e70:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e76:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e79:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e7c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e7f:	89 ec                	mov    %ebp,%esp
  100e81:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e82:	e9 19 23 00 00       	jmp    1031a0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e87:	c7 04 24 31 69 10 00 	movl   $0x106931,(%esp)
  100e8e:	e8 dd fa ff ff       	call   100970 <panic>
  100e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100ea0 <filecheck>:
}

// Check if file exists in cache buffer.
int
filecheck(struct file *f, int offset)
{
  100ea0:	55                   	push   %ebp
  100ea1:	89 e5                	mov    %esp,%ebp
  100ea3:	83 ec 18             	sub    $0x18,%esp
  100ea6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100eac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int r;

  if(f->readable == 0)
  100eaf:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100eb3:	74 3b                	je     100ef0 <filecheck+0x50>
    return -1;
  if(f->type == FD_INODE){
  100eb5:	83 3b 03             	cmpl   $0x3,(%ebx)
  100eb8:	75 47                	jne    100f01 <filecheck+0x61>
    ilock(f->ip);
  100eba:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebd:	89 04 24             	mov    %eax,(%esp)
  100ec0:	e8 6b 10 00 00       	call   101f30 <ilock>
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
  100ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ecc:	8b 43 10             	mov    0x10(%ebx),%eax
  100ecf:	89 04 24             	mov    %eax,(%esp)
  100ed2:	e8 29 0b 00 00       	call   101a00 <checki>
  100ed7:	89 c6                	mov    %eax,%esi
    iunlock(f->ip);
  100ed9:	8b 43 10             	mov    0x10(%ebx),%eax
  100edc:	89 04 24             	mov    %eax,(%esp)
  100edf:	e8 dc 0f 00 00       	call   101ec0 <iunlock>
    return r;
  }
  panic("filecheck");
}
  100ee4:	89 f0                	mov    %esi,%eax
  100ee6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100ee9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100eec:	89 ec                	mov    %ebp,%esp
  100eee:	5d                   	pop    %ebp
  100eef:	c3                   	ret    
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
    iunlock(f->ip);
    return r;
  }
  panic("filecheck");
  100ef0:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
  100ef5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100ef8:	89 f0                	mov    %esi,%eax
  100efa:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100efd:	89 ec                	mov    %ebp,%esp
  100eff:	5d                   	pop    %ebp
  100f00:	c3                   	ret    
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
    iunlock(f->ip);
    return r;
  }
  panic("filecheck");
  100f01:	c7 04 24 3b 69 10 00 	movl   $0x10693b,(%esp)
  100f08:	e8 63 fa ff ff       	call   100970 <panic>
  100f0d:	8d 76 00             	lea    0x0(%esi),%esi

00100f10 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100f10:	55                   	push   %ebp
  100f11:	89 e5                	mov    %esp,%ebp
  100f13:	83 ec 38             	sub    $0x38,%esp
  100f16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100f1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100f22:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100f25:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
  100f28:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100f2c:	74 5a                	je     100f88 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100f2e:	8b 03                	mov    (%ebx),%eax
  100f30:	83 f8 02             	cmp    $0x2,%eax
  100f33:	74 5b                	je     100f90 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100f35:	83 f8 03             	cmp    $0x3,%eax
  100f38:	75 6d                	jne    100fa7 <fileread+0x97>
    ilock(f->ip);
  100f3a:	8b 43 10             	mov    0x10(%ebx),%eax
  100f3d:	89 04 24             	mov    %eax,(%esp)
  100f40:	e8 eb 0f 00 00       	call   101f30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100f45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100f49:	8b 43 14             	mov    0x14(%ebx),%eax
  100f4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f50:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f54:	8b 43 10             	mov    0x10(%ebx),%eax
  100f57:	89 04 24             	mov    %eax,(%esp)
  100f5a:	e8 a1 06 00 00       	call   101600 <readi>
  100f5f:	85 c0                	test   %eax,%eax
  100f61:	7e 03                	jle    100f66 <fileread+0x56>
      f->off += r;
  100f63:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100f66:	8b 53 10             	mov    0x10(%ebx),%edx
  100f69:	89 14 24             	mov    %edx,(%esp)
  100f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100f6f:	e8 4c 0f 00 00       	call   101ec0 <iunlock>
    return r;
  100f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
  100f77:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f7a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f7d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100f80:	89 ec                	mov    %ebp,%esp
  100f82:	5d                   	pop    %ebp
  100f83:	c3                   	ret    
  100f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100f8d:	eb e8                	jmp    100f77 <fileread+0x67>
  100f8f:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100f93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100f9c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100f9f:	89 ec                	mov    %ebp,%esp
  100fa1:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100fa2:	e9 19 21 00 00       	jmp    1030c0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100fa7:	c7 04 24 45 69 10 00 	movl   $0x106945,(%esp)
  100fae:	e8 bd f9 ff ff       	call   100970 <panic>
  100fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100fc0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100fc0:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100fc6:	89 e5                	mov    %esp,%ebp
  100fc8:	53                   	push   %ebx
  100fc9:	83 ec 14             	sub    $0x14,%esp
  100fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100fcf:	83 3b 03             	cmpl   $0x3,(%ebx)
  100fd2:	74 0c                	je     100fe0 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100fd4:	83 c4 14             	add    $0x14,%esp
  100fd7:	5b                   	pop    %ebx
  100fd8:	5d                   	pop    %ebp
  100fd9:	c3                   	ret    
  100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100fe0:	8b 43 10             	mov    0x10(%ebx),%eax
  100fe3:	89 04 24             	mov    %eax,(%esp)
  100fe6:	e8 45 0f 00 00       	call   101f30 <ilock>
    stati(f->ip, st);
  100feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ff2:	8b 43 10             	mov    0x10(%ebx),%eax
  100ff5:	89 04 24             	mov    %eax,(%esp)
  100ff8:	e8 f3 01 00 00       	call   1011f0 <stati>
    iunlock(f->ip);
  100ffd:	8b 43 10             	mov    0x10(%ebx),%eax
  101000:	89 04 24             	mov    %eax,(%esp)
  101003:	e8 b8 0e 00 00       	call   101ec0 <iunlock>
    return 0;
  }
  return -1;
}
  101008:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  10100b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  10100d:	5b                   	pop    %ebx
  10100e:	5d                   	pop    %ebp
  10100f:	c3                   	ret    

00101010 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  101010:	55                   	push   %ebp
  101011:	89 e5                	mov    %esp,%ebp
  101013:	53                   	push   %ebx
  101014:	83 ec 14             	sub    $0x14,%esp
  101017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&file_table_lock);
  10101a:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  101021:	e8 fa 36 00 00       	call   104720 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  101026:	8b 43 04             	mov    0x4(%ebx),%eax
  101029:	85 c0                	test   %eax,%eax
  10102b:	7e 20                	jle    10104d <filedup+0x3d>
  10102d:	8b 13                	mov    (%ebx),%edx
  10102f:	85 d2                	test   %edx,%edx
  101031:	74 1a                	je     10104d <filedup+0x3d>
    panic("filedup");
  f->ref++;
  101033:	83 c0 01             	add    $0x1,%eax
  101036:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  101039:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  101040:	e8 9b 36 00 00       	call   1046e0 <release>
  return f;
}
  101045:	89 d8                	mov    %ebx,%eax
  101047:	83 c4 14             	add    $0x14,%esp
  10104a:	5b                   	pop    %ebx
  10104b:	5d                   	pop    %ebp
  10104c:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("filedup");
  10104d:	c7 04 24 4e 69 10 00 	movl   $0x10694e,(%esp)
  101054:	e8 17 f9 ff ff       	call   100970 <panic>
  101059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101060 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  101060:	55                   	push   %ebp
  101061:	89 e5                	mov    %esp,%ebp
  101063:	53                   	push   %ebx
  101064:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&file_table_lock);
  101067:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10106e:	e8 ad 36 00 00       	call   104720 <acquire>
  101073:	ba 00 a1 10 00       	mov    $0x10a100,%edx
  101078:	31 c0                	xor    %eax,%eax
  10107a:	eb 0f                	jmp    10108b <filealloc+0x2b>
  10107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NFILE; i++){
  101080:	83 c0 01             	add    $0x1,%eax
  101083:	83 c2 18             	add    $0x18,%edx
  101086:	83 f8 64             	cmp    $0x64,%eax
  101089:	74 45                	je     1010d0 <filealloc+0x70>
    if(file[i].type == FD_CLOSED){
  10108b:	8b 0a                	mov    (%edx),%ecx
  10108d:	85 c9                	test   %ecx,%ecx
  10108f:	75 ef                	jne    101080 <filealloc+0x20>
      file[i].type = FD_NONE;
  101091:	8d 14 40             	lea    (%eax,%eax,2),%edx
  101094:	8d 1c d5 00 00 00 00 	lea    0x0(,%edx,8),%ebx
      file[i].ref = 1;
      release(&file_table_lock);
  10109b:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  1010a2:	c7 04 d5 00 a1 10 00 	movl   $0x1,0x10a100(,%edx,8)
  1010a9:	01 00 00 00 
      file[i].ref = 1;
  1010ad:	c7 04 d5 04 a1 10 00 	movl   $0x1,0x10a104(,%edx,8)
  1010b4:	01 00 00 00 
      release(&file_table_lock);
  1010b8:	e8 23 36 00 00       	call   1046e0 <release>
      return file + i;
  1010bd:	8d 83 00 a1 10 00    	lea    0x10a100(%ebx),%eax
    }
  }
  release(&file_table_lock);
  return 0;
}
  1010c3:	83 c4 14             	add    $0x14,%esp
  1010c6:	5b                   	pop    %ebx
  1010c7:	5d                   	pop    %ebp
  1010c8:	c3                   	ret    
  1010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  1010d0:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1010d7:	e8 04 36 00 00       	call   1046e0 <release>
  return 0;
}
  1010dc:	83 c4 14             	add    $0x14,%esp
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  1010df:	31 c0                	xor    %eax,%eax
  return 0;
}
  1010e1:	5b                   	pop    %ebx
  1010e2:	5d                   	pop    %ebp
  1010e3:	c3                   	ret    
  1010e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001010f0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  1010f0:	55                   	push   %ebp
  1010f1:	89 e5                	mov    %esp,%ebp
  1010f3:	83 ec 38             	sub    $0x38,%esp
  1010f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1010f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1010fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1010ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&file_table_lock);
  101102:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  101109:	e8 12 36 00 00       	call   104720 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  10110e:	8b 43 04             	mov    0x4(%ebx),%eax
  101111:	85 c0                	test   %eax,%eax
  101113:	0f 8e 9f 00 00 00    	jle    1011b8 <fileclose+0xc8>
  101119:	8b 33                	mov    (%ebx),%esi
  10111b:	85 f6                	test   %esi,%esi
  10111d:	0f 84 95 00 00 00    	je     1011b8 <fileclose+0xc8>
    panic("fileclose");
  if(--f->ref > 0){
  101123:	83 e8 01             	sub    $0x1,%eax
  101126:	85 c0                	test   %eax,%eax
  101128:	89 43 04             	mov    %eax,0x4(%ebx)
  10112b:	74 1b                	je     101148 <fileclose+0x58>
    release(&file_table_lock);
  10112d:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  101134:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101137:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10113a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10113d:	89 ec                	mov    %ebp,%esp
  10113f:	5d                   	pop    %ebp

  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
  101140:	e9 9b 35 00 00       	jmp    1046e0 <release>
  101145:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }
  ff = *f;
  101148:	8b 43 0c             	mov    0xc(%ebx),%eax
  10114b:	8b 33                	mov    (%ebx),%esi
  10114d:	8b 7b 10             	mov    0x10(%ebx),%edi
  f->ref = 0;
  101150:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101157:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10115a:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_CLOSED;
  10115e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101164:	88 45 e7             	mov    %al,-0x19(%ebp)
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  101167:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10116e:	e8 6d 35 00 00       	call   1046e0 <release>
  
  if(ff.type == FD_PIPE)
  101173:	83 fe 02             	cmp    $0x2,%esi
  101176:	74 20                	je     101198 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  101178:	83 fe 03             	cmp    $0x3,%esi
  10117b:	75 3b                	jne    1011b8 <fileclose+0xc8>
    iput(ff.ip);
  10117d:	89 7d 08             	mov    %edi,0x8(%ebp)
  else
    panic("fileclose");
}
  101180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101183:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101186:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101189:	89 ec                	mov    %ebp,%esp
  10118b:	5d                   	pop    %ebp
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  10118c:	e9 4f 0a 00 00       	jmp    101be0 <iput>
  101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  101198:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  10119c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1011a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1011a3:	89 04 24             	mov    %eax,(%esp)
  1011a6:	e8 f5 20 00 00       	call   1032a0 <pipeclose>
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  1011ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1011ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1011b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1011b4:	89 ec                	mov    %ebp,%esp
  1011b6:	5d                   	pop    %ebp
  1011b7:	c3                   	ret    
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  1011b8:	c7 04 24 56 69 10 00 	movl   $0x106956,(%esp)
  1011bf:	e8 ac f7 ff ff       	call   100970 <panic>
  1011c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1011ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001011d0 <fileinit>:
struct spinlock file_table_lock;
struct file file[NFILE];

void
fileinit(void)
{
  1011d0:	55                   	push   %ebp
  1011d1:	89 e5                	mov    %esp,%ebp
  1011d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&file_table_lock, "file_table");
  1011d6:	c7 44 24 04 60 69 10 	movl   $0x106960,0x4(%esp)
  1011dd:	00 
  1011de:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1011e5:	e8 76 33 00 00       	call   104560 <initlock>
}
  1011ea:	c9                   	leave  
  1011eb:	c3                   	ret    
  1011ec:	90                   	nop
  1011ed:	90                   	nop
  1011ee:	90                   	nop
  1011ef:	90                   	nop

001011f0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  1011f0:	55                   	push   %ebp
  1011f1:	89 e5                	mov    %esp,%ebp
  1011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
  1011f9:	8b 0a                	mov    (%edx),%ecx
  1011fb:	89 08                	mov    %ecx,(%eax)
  st->ino = ip->inum;
  1011fd:	8b 4a 04             	mov    0x4(%edx),%ecx
  101200:	89 48 04             	mov    %ecx,0x4(%eax)
  st->type = ip->type;
  101203:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
  101207:	66 89 48 08          	mov    %cx,0x8(%eax)
  st->nlink = ip->nlink;
  10120b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
  st->size = ip->size;
  10120f:	8b 52 18             	mov    0x18(%edx),%edx
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  101212:	66 89 48 0a          	mov    %cx,0xa(%eax)
  st->size = ip->size;
  101216:	89 50 0c             	mov    %edx,0xc(%eax)
}
  101219:	5d                   	pop    %ebp
  10121a:	c3                   	ret    
  10121b:	90                   	nop
  10121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101220 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101220:	55                   	push   %ebp
  101221:	89 e5                	mov    %esp,%ebp
  101223:	53                   	push   %ebx
  101224:	83 ec 14             	sub    $0x14,%esp
  101227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10122a:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101231:	e8 ea 34 00 00       	call   104720 <acquire>
  ip->ref++;
  101236:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10123a:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101241:	e8 9a 34 00 00       	call   1046e0 <release>
  return ip;
}
  101246:	89 d8                	mov    %ebx,%eax
  101248:	83 c4 14             	add    $0x14,%esp
  10124b:	5b                   	pop    %ebx
  10124c:	5d                   	pop    %ebp
  10124d:	c3                   	ret    
  10124e:	66 90                	xchg   %ax,%ax

00101250 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101250:	55                   	push   %ebp
  101251:	89 e5                	mov    %esp,%ebp
  101253:	57                   	push   %edi
  101254:	89 d7                	mov    %edx,%edi
  101256:	56                   	push   %esi
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  101257:	31 f6                	xor    %esi,%esi
{
  101259:	53                   	push   %ebx
  10125a:	89 c3                	mov    %eax,%ebx
  10125c:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
  10125f:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101266:	e8 b5 34 00 00       	call   104720 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10126b:	b8 34 ab 10 00       	mov    $0x10ab34,%eax
  101270:	eb 14                	jmp    101286 <iget+0x36>
  101272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101278:	85 f6                	test   %esi,%esi
  10127a:	74 3c                	je     1012b8 <iget+0x68>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  10127c:	83 c0 50             	add    $0x50,%eax
  10127f:	3d d4 ba 10 00       	cmp    $0x10bad4,%eax
  101284:	74 42                	je     1012c8 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  101286:	8b 48 08             	mov    0x8(%eax),%ecx
  101289:	85 c9                	test   %ecx,%ecx
  10128b:	7e eb                	jle    101278 <iget+0x28>
  10128d:	39 18                	cmp    %ebx,(%eax)
  10128f:	75 e7                	jne    101278 <iget+0x28>
  101291:	39 78 04             	cmp    %edi,0x4(%eax)
  101294:	75 e2                	jne    101278 <iget+0x28>
      ip->ref++;
  101296:	83 c1 01             	add    $0x1,%ecx
  101299:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
  10129c:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  1012a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1012a6:	e8 35 34 00 00       	call   1046e0 <release>
      return ip;
  1012ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1012ae:	83 c4 2c             	add    $0x2c,%esp
  1012b1:	5b                   	pop    %ebx
  1012b2:	5e                   	pop    %esi
  1012b3:	5f                   	pop    %edi
  1012b4:	5d                   	pop    %ebp
  1012b5:	c3                   	ret    
  1012b6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1012b8:	85 c9                	test   %ecx,%ecx
  1012ba:	75 c0                	jne    10127c <iget+0x2c>
  1012bc:	89 c6                	mov    %eax,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1012be:	83 c0 50             	add    $0x50,%eax
  1012c1:	3d d4 ba 10 00       	cmp    $0x10bad4,%eax
  1012c6:	75 be                	jne    101286 <iget+0x36>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  1012c8:	85 f6                	test   %esi,%esi
  1012ca:	74 29                	je     1012f5 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  1012cc:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
  1012ce:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
  1012d1:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  1012d8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
  1012df:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  1012e6:	e8 f5 33 00 00       	call   1046e0 <release>

  return ip;
}
  1012eb:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  1012ee:	89 f0                	mov    %esi,%eax

  return ip;
}
  1012f0:	5b                   	pop    %ebx
  1012f1:	5e                   	pop    %esi
  1012f2:	5f                   	pop    %edi
  1012f3:	5d                   	pop    %ebp
  1012f4:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  1012f5:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1012fc:	e8 6f f6 ff ff       	call   100970 <panic>
  101301:	eb 0d                	jmp    101310 <readsb>
  101303:	90                   	nop
  101304:	90                   	nop
  101305:	90                   	nop
  101306:	90                   	nop
  101307:	90                   	nop
  101308:	90                   	nop
  101309:	90                   	nop
  10130a:	90                   	nop
  10130b:	90                   	nop
  10130c:	90                   	nop
  10130d:	90                   	nop
  10130e:	90                   	nop
  10130f:	90                   	nop

00101310 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101310:	55                   	push   %ebp
  101311:	89 e5                	mov    %esp,%ebp
  101313:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101316:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10131d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10131e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101321:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101324:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101326:	89 04 24             	mov    %eax,(%esp)
  101329:	e8 02 ee ff ff       	call   100130 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10132e:	89 34 24             	mov    %esi,(%esp)
  101331:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101338:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101339:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10133b:	8d 40 18             	lea    0x18(%eax),%eax
  10133e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101342:	e8 d9 34 00 00       	call   104820 <memmove>
  brelse(bp);
  101347:	89 1c 24             	mov    %ebx,(%esp)
  10134a:	e8 b1 ec ff ff       	call   100000 <brelse>
}
  10134f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  101352:	8b 75 fc             	mov    -0x4(%ebp),%esi
  101355:	89 ec                	mov    %ebp,%esp
  101357:	5d                   	pop    %ebp
  101358:	c3                   	ret    
  101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101360 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101360:	55                   	push   %ebp
  101361:	89 e5                	mov    %esp,%ebp
  101363:	57                   	push   %edi
  101364:	56                   	push   %esi
  101365:	53                   	push   %ebx
  101366:	83 ec 3c             	sub    $0x3c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101369:	8d 55 dc             	lea    -0x24(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  10136c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  10136f:	e8 9c ff ff ff       	call   101310 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101377:	85 c0                	test   %eax,%eax
  101379:	0f 84 af 00 00 00    	je     10142e <balloc+0xce>
  10137f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101389:	31 db                	xor    %ebx,%ebx
  10138b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10138e:	c1 e8 03             	shr    $0x3,%eax
  101391:	c1 fa 0c             	sar    $0xc,%edx
  101394:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10139c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10139f:	89 04 24             	mov    %eax,(%esp)
  1013a2:	e8 89 ed ff ff       	call   100130 <bread>
  1013a7:	89 c6                	mov    %eax,%esi
  1013a9:	eb 10                	jmp    1013bb <balloc+0x5b>
  1013ab:	90                   	nop
  1013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  1013b0:	83 c3 01             	add    $0x1,%ebx
  1013b3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  1013b9:	74 45                	je     101400 <balloc+0xa0>
      m = 1 << (bi % 8);
  1013bb:	89 d9                	mov    %ebx,%ecx
  1013bd:	ba 01 00 00 00       	mov    $0x1,%edx
  1013c2:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013c5:	89 d8                	mov    %ebx,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1013c7:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013c9:	c1 f8 03             	sar    $0x3,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1013cc:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1013ce:	0f b6 54 06 18       	movzbl 0x18(%esi,%eax,1),%edx
  1013d3:	0f b6 fa             	movzbl %dl,%edi
  1013d6:	85 cf                	test   %ecx,%edi
  1013d8:	75 d6                	jne    1013b0 <balloc+0x50>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1013da:	09 d1                	or     %edx,%ecx
  1013dc:	88 4c 06 18          	mov    %cl,0x18(%esi,%eax,1)
        bwrite(bp);
  1013e0:	89 34 24             	mov    %esi,(%esp)
  1013e3:	e8 18 ed ff ff       	call   100100 <bwrite>
        brelse(bp);
  1013e8:	89 34 24             	mov    %esi,(%esp)
  1013eb:	e8 10 ec ff ff       	call   100000 <brelse>
  1013f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    }
    brelse(bp);
    cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013f3:	83 c4 3c             	add    $0x3c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1013f6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    }
    brelse(bp);
    cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
}
  1013f9:	5b                   	pop    %ebx
  1013fa:	5e                   	pop    %esi
  1013fb:	5f                   	pop    %edi
  1013fc:	5d                   	pop    %ebp
  1013fd:	c3                   	ret    
  1013fe:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  101400:	89 34 24             	mov    %esi,(%esp)
  101403:	e8 f8 eb ff ff       	call   100000 <brelse>
    cprintf("b = %d", b);
  101408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10140b:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  101412:	89 44 24 04          	mov    %eax,0x4(%esp)
  101416:	e8 b5 f3 ff ff       	call   1007d0 <cprintf>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  10141b:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  101422:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  101425:	39 55 dc             	cmp    %edx,-0x24(%ebp)
  101428:	0f 87 58 ff ff ff    	ja     101386 <balloc+0x26>
      }
    }
    brelse(bp);
    cprintf("b = %d", b);
  }
  panic("balloc: out of blocks");
  10142e:	c7 04 24 82 69 10 00 	movl   $0x106982,(%esp)
  101435:	e8 36 f5 ff ff       	call   100970 <panic>
  10143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101440:	55                   	push   %ebp
  101441:	89 e5                	mov    %esp,%ebp
  101443:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101446:	83 fa 0a             	cmp    $0xa,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101449:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10144c:	89 c3                	mov    %eax,%ebx
  10144e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101451:	89 ce                	mov    %ecx,%esi
  101453:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101456:	77 28                	ja     101480 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
  101458:	8d 7a 04             	lea    0x4(%edx),%edi
  10145b:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
  10145f:	85 c0                	test   %eax,%eax
  101461:	75 0d                	jne    101470 <bmap+0x30>
      if(!alloc)
  101463:	85 c9                	test   %ecx,%ecx
  101465:	0f 85 4d 01 00 00    	jne    1015b8 <bmap+0x178>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  10146b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101470:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101473:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101476:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101479:	89 ec                	mov    %ebp,%esp
  10147b:	5d                   	pop    %ebp
  10147c:	c3                   	ret    
  10147d:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101480:	8d 7a f5             	lea    -0xb(%edx),%edi

  //check indirect
  if(bn < NINDIRECT){
  101483:	83 ff 7f             	cmp    $0x7f,%edi
  101486:	0f 86 dc 00 00 00    	jbe    101568 <bmap+0x128>
    return addr;
  }

  //NEW CODE
  //decrement block number for new reference
  bn -= NINDIRECT;
  10148c:	8d ba 75 ff ff ff    	lea    -0x8b(%edx),%edi

  //DOUBLE INDIRECT
  if(bn < NDINDIRECT){
  101492:	81 ff ff 3f 00 00    	cmp    $0x3fff,%edi
  101498:	0f 87 51 01 00 00    	ja     1015ef <bmap+0x1af>

	  //cprintf("bn is %d\n", bn);

	  if((addr = ip->addrs[DINDIRECT]) == 0){
  10149e:	8b 40 4c             	mov    0x4c(%eax),%eax
  1014a1:	85 c0                	test   %eax,%eax
  1014a3:	75 11                	jne    1014b6 <bmap+0x76>
	     if(!alloc)
  1014a5:	85 c9                	test   %ecx,%ecx
  1014a7:	74 c2                	je     10146b <bmap+0x2b>
	        return -1;
	     ip->addrs[NINDIRECT] = addr = balloc(ip->dev);
  1014a9:	8b 03                	mov    (%ebx),%eax
  1014ab:	e8 b0 fe ff ff       	call   101360 <balloc>
  1014b0:	89 83 1c 02 00 00    	mov    %eax,0x21c(%ebx)
	  }
	  bp = bread(ip->dev, addr);
  1014b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014ba:	8b 03                	mov    (%ebx),%eax
  1014bc:	89 04 24             	mov    %eax,(%esp)
  1014bf:	e8 6c ec ff ff       	call   100130 <bread>
  1014c4:	89 c2                	mov    %eax,%edx
	  //calculate base and offset indirect block in double indirect block
	  uint base = bn / NINDIRECT;
	  uint offset = bn % NINDIRECT;

	  //grab indirect block and allocate if necessary
	  if((addr = a[base]) == 0){
  1014c6:	89 f8                	mov    %edi,%eax
  1014c8:	c1 e8 07             	shr    $0x7,%eax
  1014cb:	8d 4c 82 18          	lea    0x18(%edx,%eax,4),%ecx
  1014cf:	8b 01                	mov    (%ecx),%eax
  1014d1:	85 c0                	test   %eax,%eax
  1014d3:	75 2e                	jne    101503 <bmap+0xc3>
	        if(!alloc){
  1014d5:	85 f6                	test   %esi,%esi
  1014d7:	0f 84 c2 00 00 00    	je     10159f <bmap+0x15f>
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  1014dd:	8b 03                	mov    (%ebx),%eax
  1014df:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1014e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1014e5:	e8 76 fe ff ff       	call   101360 <balloc>
  1014ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	        bwrite(bp);
  1014ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
	        if(!alloc){
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
  1014f0:	89 01                	mov    %eax,(%ecx)
	        bwrite(bp);
  1014f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1014f5:	89 14 24             	mov    %edx,(%esp)
  1014f8:	e8 03 ec ff ff       	call   100100 <bwrite>
  1014fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	  }

	  brelse(bp);
  101503:	89 14 24             	mov    %edx,(%esp)
	  bp = bread(ip->dev, addr);
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101506:	83 e7 7f             	and    $0x7f,%edi
	        //cprintf("allocating new indirect block for bn = %d\n", bn);
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
  101509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10150c:	e8 ef ea ff ff       	call   100000 <brelse>
	  bp = bread(ip->dev, addr);
  101511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101514:	89 44 24 04          	mov    %eax,0x4(%esp)
  101518:	8b 03                	mov    (%ebx),%eax
  10151a:	89 04 24             	mov    %eax,(%esp)
  10151d:	e8 0e ec ff ff       	call   100130 <bread>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101522:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi
	        a[base] = addr = balloc(ip->dev);
	        bwrite(bp);
	  }

	  brelse(bp);
	  bp = bread(ip->dev, addr);
  101526:	89 c2                	mov    %eax,%edx
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
  101528:	8b 07                	mov    (%edi),%eax
  10152a:	85 c0                	test   %eax,%eax
  10152c:	75 24                	jne    101552 <bmap+0x112>
	        if(!alloc){
  10152e:	85 f6                	test   %esi,%esi
  101530:	74 6d                	je     10159f <bmap+0x15f>
	          brelse(bp);
	          return -1;
	        }
	        //cprintf("allocating new data block with bn = %d\n", bn);
	        a[offset] = addr = balloc(ip->dev);
  101532:	8b 03                	mov    (%ebx),%eax
  101534:	89 55 e0             	mov    %edx,-0x20(%ebp)
  101537:	e8 24 fe ff ff       	call   101360 <balloc>
  10153c:	89 07                	mov    %eax,(%edi)
	        bwrite(bp);
  10153e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101544:	89 14 24             	mov    %edx,(%esp)
  101547:	e8 b4 eb ff ff       	call   100100 <bwrite>
  10154c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10154f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
	  }
	  brelse(bp);
  101552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101555:	89 14 24             	mov    %edx,(%esp)
  101558:	e8 a3 ea ff ff       	call   100000 <brelse>
	  return addr;
  10155d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101560:	e9 0b ff ff ff       	jmp    101470 <bmap+0x30>
  101565:	8d 76 00             	lea    0x0(%esi),%esi

  //check indirect
  if(bn < NINDIRECT){

    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  101568:	8b 40 48             	mov    0x48(%eax),%eax
  10156b:	85 c0                	test   %eax,%eax
  10156d:	75 12                	jne    101581 <bmap+0x141>
      if(!alloc)
  10156f:	85 c9                	test   %ecx,%ecx
  101571:	0f 84 f4 fe ff ff    	je     10146b <bmap+0x2b>
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101577:	8b 03                	mov    (%ebx),%eax
  101579:	e8 e2 fd ff ff       	call   101360 <balloc>
  10157e:	89 43 48             	mov    %eax,0x48(%ebx)
    }
    bp = bread(ip->dev, addr);
  101581:	89 44 24 04          	mov    %eax,0x4(%esp)
  101585:	8b 03                	mov    (%ebx),%eax
  101587:	89 04 24             	mov    %eax,(%esp)
  10158a:	e8 a1 eb ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  10158f:	8d 4c b8 18          	lea    0x18(%eax,%edi,4),%ecx
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  101593:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101595:	8b 01                	mov    (%ecx),%eax
  101597:	85 c0                	test   %eax,%eax
  101599:	75 b7                	jne    101552 <bmap+0x112>
      if(!alloc){
  10159b:	85 f6                	test   %esi,%esi
  10159d:	75 29                	jne    1015c8 <bmap+0x188>
	  a = (uint*)bp->data;

	  //get data block from indirect block
	  if((addr = a[offset]) == 0){
	        if(!alloc){
	          brelse(bp);
  10159f:	89 14 24             	mov    %edx,(%esp)
  1015a2:	e8 59 ea ff ff       	call   100000 <brelse>
  1015a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	          return -1;
  1015ac:	e9 bf fe ff ff       	jmp    101470 <bmap+0x30>
  1015b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  1015b8:	8b 03                	mov    (%ebx),%eax
  1015ba:	e8 a1 fd ff ff       	call   101360 <balloc>
  1015bf:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  1015c3:	e9 a8 fe ff ff       	jmp    101470 <bmap+0x30>
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      cprintf("allocating block %d in indirect\n", bn);
  1015c8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1015cb:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1015ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1015d2:	c7 04 24 2c 6a 10 00 	movl   $0x106a2c,(%esp)
  1015d9:	e8 f2 f1 ff ff       	call   1007d0 <cprintf>
      a[bn] = addr = balloc(ip->dev);
  1015de:	8b 03                	mov    (%ebx),%eax
  1015e0:	e8 7b fd ff ff       	call   101360 <balloc>
  1015e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1015e8:	89 01                	mov    %eax,(%ecx)
  1015ea:	e9 4f ff ff ff       	jmp    10153e <bmap+0xfe>
	  brelse(bp);
	  return addr;

  }

  panic("bmap: out of range");
  1015ef:	c7 04 24 98 69 10 00 	movl   $0x106998,(%esp)
  1015f6:	e8 75 f3 ff ff       	call   100970 <panic>
  1015fb:	90                   	nop
  1015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
  10160c:	8b 45 14             	mov    0x14(%ebp),%eax
  10160f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101612:	8b 75 10             	mov    0x10(%ebp),%esi
  101615:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101618:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10161b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101623:	74 1b                	je     101640 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101625:	8b 43 18             	mov    0x18(%ebx),%eax
  101628:	39 f0                	cmp    %esi,%eax
  10162a:	73 44                	jae    101670 <readi+0x70>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10162c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101631:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101634:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101637:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10163a:	89 ec                	mov    %ebp,%esp
  10163c:	5d                   	pop    %ebp
  10163d:	c3                   	ret    
  10163e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101640:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101644:	66 83 f8 09          	cmp    $0x9,%ax
  101648:	77 e2                	ja     10162c <readi+0x2c>
  10164a:	98                   	cwtl   
  10164b:	8b 04 c5 a0 aa 10 00 	mov    0x10aaa0(,%eax,8),%eax
  101652:	85 c0                	test   %eax,%eax
  101654:	74 d6                	je     10162c <readi+0x2c>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101656:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101659:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10165c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10165f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101662:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101665:	89 ec                	mov    %ebp,%esp
  101667:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101668:	ff e0                	jmp    *%eax
  10166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  101670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101673:	01 f2                	add    %esi,%edx
  101675:	72 b5                	jb     10162c <readi+0x2c>
    return -1;
  if(off + n > ip->size)
  101677:	39 d0                	cmp    %edx,%eax
  101679:	73 05                	jae    101680 <readi+0x80>
    n = ip->size - off;
  10167b:	29 f0                	sub    %esi,%eax
  10167d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101683:	85 d2                	test   %edx,%edx
  101685:	74 7e                	je     101705 <readi+0x105>
  101687:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
  10168e:	89 7d dc             	mov    %edi,-0x24(%ebp)
  101691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101698:	89 f2                	mov    %esi,%edx
  10169a:	31 c9                	xor    %ecx,%ecx
  10169c:	c1 ea 09             	shr    $0x9,%edx
  10169f:	89 d8                	mov    %ebx,%eax
  1016a1:	e8 9a fd ff ff       	call   101440 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016a6:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016af:	8b 03                	mov    (%ebx),%eax
  1016b1:	89 04 24             	mov    %eax,(%esp)
  1016b4:	e8 77 ea ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016b9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1016bc:	2b 4d e0             	sub    -0x20(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1016c1:	89 f0                	mov    %esi,%eax
  1016c3:	25 ff 01 00 00       	and    $0x1ff,%eax
  1016c8:	29 c7                	sub    %eax,%edi
  1016ca:	39 cf                	cmp    %ecx,%edi
  1016cc:	76 02                	jbe    1016d0 <readi+0xd0>
  1016ce:	89 cf                	mov    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1016d0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016d4:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1016d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1016da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1016e1:	89 04 24             	mov    %eax,(%esp)
  1016e4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1016e7:	e8 34 31 00 00       	call   104820 <memmove>
    brelse(bp);
  1016ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1016ef:	89 14 24             	mov    %edx,(%esp)
  1016f2:	e8 09 e9 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016f7:	01 7d e0             	add    %edi,-0x20(%ebp)
  1016fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1016fd:	01 7d dc             	add    %edi,-0x24(%ebp)
  101700:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101703:	77 93                	ja     101698 <readi+0x98>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101708:	e9 24 ff ff ff       	jmp    101631 <readi+0x31>
  10170d:	8d 76 00             	lea    0x0(%esi),%esi

00101710 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	56                   	push   %esi
  101714:	53                   	push   %ebx
  101715:	83 ec 10             	sub    $0x10,%esp
  101718:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10171b:	8b 43 04             	mov    0x4(%ebx),%eax
  10171e:	c1 e8 03             	shr    $0x3,%eax
  101721:	83 c0 02             	add    $0x2,%eax
  101724:	89 44 24 04          	mov    %eax,0x4(%esp)
  101728:	8b 03                	mov    (%ebx),%eax
  10172a:	89 04 24             	mov    %eax,(%esp)
  10172d:	e8 fe e9 ff ff       	call   100130 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  101732:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  101736:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101738:	8b 43 04             	mov    0x4(%ebx),%eax
  10173b:	83 e0 07             	and    $0x7,%eax
  10173e:	c1 e0 06             	shl    $0x6,%eax
  101741:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  101745:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  101748:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  10174c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  101750:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  101754:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  101758:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  10175c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  101760:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101763:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101766:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101769:	83 c0 0c             	add    $0xc,%eax
  10176c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101770:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101777:	00 
  101778:	89 04 24             	mov    %eax,(%esp)
  10177b:	e8 a0 30 00 00       	call   104820 <memmove>
  bwrite(bp);
  101780:	89 34 24             	mov    %esi,(%esp)
  101783:	e8 78 e9 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101788:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10178b:	83 c4 10             	add    $0x10,%esp
  10178e:	5b                   	pop    %ebx
  10178f:	5e                   	pop    %esi
  101790:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  101791:	e9 6a e8 ff ff       	jmp    100000 <brelse>
  101796:	8d 76 00             	lea    0x0(%esi),%esi
  101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001017a0 <writei>:
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1017a0:	55                   	push   %ebp
  1017a1:	89 e5                	mov    %esp,%ebp
  1017a3:	57                   	push   %edi
  1017a4:	56                   	push   %esi
  1017a5:	53                   	push   %ebx
  1017a6:	83 ec 2c             	sub    $0x2c,%esp
  1017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  1017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1017af:	8b 55 14             	mov    0x14(%ebp),%edx
  1017b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1017b5:	66 83 7e 10 03       	cmpw   $0x3,0x10(%esi)
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1017ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1017bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1017c0:	0f 84 c2 00 00 00    	je     101888 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  1017c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1017c9:	01 d8                	add    %ebx,%eax
  1017cb:	0f 82 c1 00 00 00    	jb     101892 <writei+0xf2>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1017d1:	3d 00 16 81 00       	cmp    $0x811600,%eax
  1017d6:	76 0a                	jbe    1017e2 <writei+0x42>
    n = MAXFILE*BSIZE - off;
  1017d8:	c7 45 dc 00 16 81 00 	movl   $0x811600,-0x24(%ebp)
  1017df:	29 5d dc             	sub    %ebx,-0x24(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1017e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1017e5:	85 c9                	test   %ecx,%ecx
  1017e7:	0f 84 8b 00 00 00    	je     101878 <writei+0xd8>
  1017ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1017f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1017f8:	89 da                	mov    %ebx,%edx
  1017fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  1017ff:	c1 ea 09             	shr    $0x9,%edx
  101802:	89 f0                	mov    %esi,%eax
  101804:	e8 37 fc ff ff       	call   101440 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101809:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  10180e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101812:	8b 06                	mov    (%esi),%eax
  101814:	89 04 24             	mov    %eax,(%esp)
  101817:	e8 14 e9 ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  10181c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10181f:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101822:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  101824:	89 d8                	mov    %ebx,%eax
  101826:	25 ff 01 00 00       	and    $0x1ff,%eax
  10182b:	29 c7                	sub    %eax,%edi
  10182d:	39 cf                	cmp    %ecx,%edi
  10182f:	76 02                	jbe    101833 <writei+0x93>
  101831:	89 cf                	mov    %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
  101833:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101837:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10183a:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  10183e:	89 04 24             	mov    %eax,(%esp)
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101841:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  101847:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10184a:	e8 d1 2f 00 00       	call   104820 <memmove>
    bwrite(bp);
  10184f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101852:	89 14 24             	mov    %edx,(%esp)
  101855:	e8 a6 e8 ff ff       	call   100100 <bwrite>
    brelse(bp);
  10185a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10185d:	89 14 24             	mov    %edx,(%esp)
  101860:	e8 9b e7 ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101865:	01 7d e4             	add    %edi,-0x1c(%ebp)
  101868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10186b:	01 7d e0             	add    %edi,-0x20(%ebp)
  10186e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101871:	77 85                	ja     1017f8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101873:	3b 5e 18             	cmp    0x18(%esi),%ebx
  101876:	77 28                	ja     1018a0 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101878:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  10187b:	83 c4 2c             	add    $0x2c,%esp
  10187e:	5b                   	pop    %ebx
  10187f:	5e                   	pop    %esi
  101880:	5f                   	pop    %edi
  101881:	5d                   	pop    %ebp
  101882:	c3                   	ret    
  101883:	90                   	nop
  101884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101888:	0f b7 46 12          	movzwl 0x12(%esi),%eax
  10188c:	66 83 f8 09          	cmp    $0x9,%ax
  101890:	76 1b                	jbe    1018ad <writei+0x10d>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101892:	83 c4 2c             	add    $0x2c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10189a:	5b                   	pop    %ebx
  10189b:	5e                   	pop    %esi
  10189c:	5f                   	pop    %edi
  10189d:	5d                   	pop    %ebp
  10189e:	c3                   	ret    
  10189f:	90                   	nop
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  1018a0:	89 5e 18             	mov    %ebx,0x18(%esi)
    iupdate(ip);
  1018a3:	89 34 24             	mov    %esi,(%esp)
  1018a6:	e8 65 fe ff ff       	call   101710 <iupdate>
  1018ab:	eb cb                	jmp    101878 <writei+0xd8>
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1018ad:	98                   	cwtl   
  1018ae:	8b 04 c5 a4 aa 10 00 	mov    0x10aaa4(,%eax,8),%eax
  1018b5:	85 c0                	test   %eax,%eax
  1018b7:	74 d9                	je     101892 <writei+0xf2>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1018b9:	89 55 10             	mov    %edx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1018bc:	83 c4 2c             	add    $0x2c,%esp
  1018bf:	5b                   	pop    %ebx
  1018c0:	5e                   	pop    %esi
  1018c1:	5f                   	pop    %edi
  1018c2:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1018c3:	ff e0                	jmp    *%eax
  1018c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001018d0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  1018d0:	55                   	push   %ebp
  1018d1:	89 e5                	mov    %esp,%ebp
  1018d3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  1018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1018d9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1018e0:	00 
  1018e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e8:	89 04 24             	mov    %eax,(%esp)
  1018eb:	e8 90 2f 00 00       	call   104880 <strncmp>
}
  1018f0:	c9                   	leave  
  1018f1:	c3                   	ret    
  1018f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1018f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101900 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101900:	55                   	push   %ebp
  101901:	89 e5                	mov    %esp,%ebp
  101903:	57                   	push   %edi
  101904:	56                   	push   %esi
  101905:	53                   	push   %ebx
  101906:	83 ec 3c             	sub    $0x3c,%esp
  101909:	8b 45 08             	mov    0x8(%ebp),%eax
  10190c:	8b 55 10             	mov    0x10(%ebp),%edx
  10190f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101912:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101917:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10191a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  10191d:	0f 85 d0 00 00 00    	jne    1019f3 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101923:	8b 70 18             	mov    0x18(%eax),%esi
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101926:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10192d:	85 f6                	test   %esi,%esi
  10192f:	0f 84 b4 00 00 00    	je     1019e9 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101935:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101938:	31 c9                	xor    %ecx,%ecx
  10193a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10193d:	c1 ea 09             	shr    $0x9,%edx
  101940:	e8 fb fa ff ff       	call   101440 <bmap>
  101945:	89 44 24 04          	mov    %eax,0x4(%esp)
  101949:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10194c:	8b 01                	mov    (%ecx),%eax
  10194e:	89 04 24             	mov    %eax,(%esp)
  101951:	e8 da e7 ff ff       	call   100130 <bread>
  101956:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101959:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  10195c:	83 c0 18             	add    $0x18,%eax
  10195f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101962:	89 c6                	mov    %eax,%esi

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101964:	81 c7 18 02 00 00    	add    $0x218,%edi
  10196a:	eb 0b                	jmp    101977 <dirlookup+0x77>
  10196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  101970:	83 c6 10             	add    $0x10,%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101973:	39 fe                	cmp    %edi,%esi
  101975:	74 51                	je     1019c8 <dirlookup+0xc8>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  101977:	66 83 3e 00          	cmpw   $0x0,(%esi)
  10197b:	74 f3                	je     101970 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  10197d:	8d 46 02             	lea    0x2(%esi),%eax
  101980:	89 44 24 04          	mov    %eax,0x4(%esp)
  101984:	89 1c 24             	mov    %ebx,(%esp)
  101987:	e8 44 ff ff ff       	call   1018d0 <namecmp>
  10198c:	85 c0                	test   %eax,%eax
  10198e:	75 e0                	jne    101970 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101990:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  101993:	85 db                	test   %ebx,%ebx
  101995:	74 0e                	je     1019a5 <dirlookup+0xa5>
          *poff = off + (uchar*)de - bp->data;
  101997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10199a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10199d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  1019a0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  1019a3:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
        brelse(bp);
  1019a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  1019a8:	0f b7 1e             	movzwl (%esi),%ebx
        brelse(bp);
  1019ab:	89 04 24             	mov    %eax,(%esp)
  1019ae:	e8 4d e6 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  1019b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1019b6:	89 da                	mov    %ebx,%edx
  1019b8:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  1019ba:	83 c4 3c             	add    $0x3c,%esp
  1019bd:	5b                   	pop    %ebx
  1019be:	5e                   	pop    %esi
  1019bf:	5f                   	pop    %edi
  1019c0:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  1019c1:	e9 8a f8 ff ff       	jmp    101250 <iget>
  1019c6:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  1019c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1019cb:	89 04 24             	mov    %eax,(%esp)
  1019ce:	e8 2d e6 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  1019d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1019d6:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  1019dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1019e0:	39 4a 18             	cmp    %ecx,0x18(%edx)
  1019e3:	0f 87 4c ff ff ff    	ja     101935 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  1019e9:	83 c4 3c             	add    $0x3c,%esp
  1019ec:	31 c0                	xor    %eax,%eax
  1019ee:	5b                   	pop    %ebx
  1019ef:	5e                   	pop    %esi
  1019f0:	5f                   	pop    %edi
  1019f1:	5d                   	pop    %ebp
  1019f2:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  1019f3:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1019fa:	e8 71 ef ff ff       	call   100970 <panic>
  1019ff:	90                   	nop

00101a00 <checki>:
}

// Check data from inode to see if it is in the buffer cache.
int
checki(struct inode *ip, int off)
{
  101a00:	55                   	push   %ebp
  101a01:	89 e5                	mov    %esp,%ebp
  101a03:	53                   	push   %ebx
  101a04:	83 ec 04             	sub    $0x4,%esp
  101a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if(off > ip->size)
  101a0d:	3b 43 18             	cmp    0x18(%ebx),%eax
  101a10:	76 0e                	jbe    101a20 <checki+0x20>
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));

 }
  101a12:	83 c4 04             	add    $0x4,%esp
  101a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101a1a:	5b                   	pop    %ebx
  101a1b:	5d                   	pop    %ebp
  101a1c:	c3                   	ret    
  101a1d:	8d 76 00             	lea    0x0(%esi),%esi
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101a20:	89 c2                	mov    %eax,%edx
  101a22:	31 c9                	xor    %ecx,%ecx
  101a24:	c1 fa 1f             	sar    $0x1f,%edx
  101a27:	c1 ea 17             	shr    $0x17,%edx
  101a2a:	01 c2                	add    %eax,%edx
  101a2c:	89 d8                	mov    %ebx,%eax
  101a2e:	c1 fa 09             	sar    $0x9,%edx
  101a31:	e8 0a fa ff ff       	call   101440 <bmap>
  101a36:	89 45 0c             	mov    %eax,0xc(%ebp)
  101a39:	8b 03                	mov    (%ebx),%eax
  101a3b:	89 45 08             	mov    %eax,0x8(%ebp)

 }
  101a3e:	83 c4 04             	add    $0x4,%esp
  101a41:	5b                   	pop    %ebx
  101a42:	5d                   	pop    %ebp
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101a43:	e9 38 e6 ff ff       	jmp    100080 <bcheck>
  101a48:	90                   	nop
  101a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101a50 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101a50:	55                   	push   %ebp
  101a51:	89 e5                	mov    %esp,%ebp
  101a53:	57                   	push   %edi
  101a54:	56                   	push   %esi
  101a55:	53                   	push   %ebx
  101a56:	83 ec 3c             	sub    $0x3c,%esp
  101a59:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101a5d:	8d 55 dc             	lea    -0x24(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101a60:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	e8 a4 f8 ff ff       	call   101310 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101a6c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101a70:	0f 86 96 00 00 00    	jbe    101b0c <ialloc+0xbc>
  101a76:	be 01 00 00 00       	mov    $0x1,%esi
  101a7b:	bb 01 00 00 00       	mov    $0x1,%ebx
  101a80:	eb 18                	jmp    101a9a <ialloc+0x4a>
  101a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101a88:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101a8b:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101a8e:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101a90:	e8 6b e5 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101a95:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  101a98:	73 72                	jae    101b0c <ialloc+0xbc>
    bp = bread(dev, IBLOCK(inum));
  101a9a:	89 f0                	mov    %esi,%eax
  101a9c:	c1 e8 03             	shr    $0x3,%eax
  101a9f:	83 c0 02             	add    $0x2,%eax
  101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa9:	89 04 24             	mov    %eax,(%esp)
  101aac:	e8 7f e6 ff ff       	call   100130 <bread>
  101ab1:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101ab3:	89 f0                	mov    %esi,%eax
  101ab5:	83 e0 07             	and    $0x7,%eax
  101ab8:	c1 e0 06             	shl    $0x6,%eax
  101abb:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  101abf:	66 83 3a 00          	cmpw   $0x0,(%edx)
  101ac3:	75 c3                	jne    101a88 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101ac5:	89 14 24             	mov    %edx,(%esp)
  101ac8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  101acb:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101ad2:	00 
  101ad3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101ada:	00 
  101adb:	e8 b0 2c 00 00       	call   104790 <memset>
      dip->type = type;
  101ae0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  101ae3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101ae7:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  101aea:	89 3c 24             	mov    %edi,(%esp)
  101aed:	e8 0e e6 ff ff       	call   100100 <bwrite>
      brelse(bp);
  101af2:	89 3c 24             	mov    %edi,(%esp)
  101af5:	e8 06 e5 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101afa:	8b 45 08             	mov    0x8(%ebp),%eax
  101afd:	89 f2                	mov    %esi,%edx
  101aff:	e8 4c f7 ff ff       	call   101250 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101b04:	83 c4 3c             	add    $0x3c,%esp
  101b07:	5b                   	pop    %ebx
  101b08:	5e                   	pop    %esi
  101b09:	5f                   	pop    %edi
  101b0a:	5d                   	pop    %ebp
  101b0b:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101b0c:	c7 04 24 bd 69 10 00 	movl   $0x1069bd,(%esp)
  101b13:	e8 58 ee ff ff       	call   100970 <panic>
  101b18:	90                   	nop
  101b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101b20 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101b20:	55                   	push   %ebp
  101b21:	89 e5                	mov    %esp,%ebp
  101b23:	57                   	push   %edi
  101b24:	56                   	push   %esi
  101b25:	89 c6                	mov    %eax,%esi
  101b27:	53                   	push   %ebx
  101b28:	89 d3                	mov    %edx,%ebx
  101b2a:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b31:	89 04 24             	mov    %eax,(%esp)
  101b34:	e8 f7 e5 ff ff       	call   100130 <bread>
  memset(bp->data, 0, BSIZE);
  101b39:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101b40:	00 
  101b41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b48:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b49:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  101b4b:	8d 40 18             	lea    0x18(%eax),%eax
  101b4e:	89 04 24             	mov    %eax,(%esp)
  101b51:	e8 3a 2c 00 00       	call   104790 <memset>
  bwrite(bp);
  101b56:	89 3c 24             	mov    %edi,(%esp)
  101b59:	e8 a2 e5 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101b5e:	89 3c 24             	mov    %edi,(%esp)
  101b61:	e8 9a e4 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101b66:	89 f0                	mov    %esi,%eax
  101b68:	8d 55 dc             	lea    -0x24(%ebp),%edx
  101b6b:	e8 a0 f7 ff ff       	call   101310 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101b73:	89 da                	mov    %ebx,%edx
  101b75:	c1 ea 0c             	shr    $0xc,%edx
  101b78:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b7b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b80:	c1 e8 03             	shr    $0x3,%eax
  101b83:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	e8 a0 e5 ff ff       	call   100130 <bread>
  bi = b % BPB;
  101b90:	89 da                	mov    %ebx,%edx
  m = 1 << (bi % 8);
  101b92:	89 d9                	mov    %ebx,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101b94:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  101b9a:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  101b9d:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101ba0:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101ba2:	0f b6 4c 10 18       	movzbl 0x18(%eax,%edx,1),%ecx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101ba7:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101ba9:	0f b6 c1             	movzbl %cl,%eax
  101bac:	85 f0                	test   %esi,%eax
  101bae:	74 22                	je     101bd2 <bfree+0xb2>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101bb0:	89 f0                	mov    %esi,%eax
  101bb2:	f7 d0                	not    %eax
  101bb4:	21 c8                	and    %ecx,%eax
  101bb6:	88 44 17 18          	mov    %al,0x18(%edi,%edx,1)
  bwrite(bp);
  101bba:	89 3c 24             	mov    %edi,(%esp)
  101bbd:	e8 3e e5 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101bc2:	89 3c 24             	mov    %edi,(%esp)
  101bc5:	e8 36 e4 ff ff       	call   100000 <brelse>
}
  101bca:	83 c4 2c             	add    $0x2c,%esp
  101bcd:	5b                   	pop    %ebx
  101bce:	5e                   	pop    %esi
  101bcf:	5f                   	pop    %edi
  101bd0:	5d                   	pop    %ebp
  101bd1:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101bd2:	c7 04 24 cf 69 10 00 	movl   $0x1069cf,(%esp)
  101bd9:	e8 92 ed ff ff       	call   100970 <panic>
  101bde:	66 90                	xchg   %ax,%ax

00101be0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101be0:	55                   	push   %ebp
  101be1:	89 e5                	mov    %esp,%ebp
  101be3:	57                   	push   %edi
  101be4:	56                   	push   %esi
  101be5:	53                   	push   %ebx
  101be6:	83 ec 2c             	sub    $0x2c,%esp
  101be9:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&icache.lock);
  101bec:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101bf3:	e8 28 2b 00 00       	call   104720 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101bf8:	8b 47 08             	mov    0x8(%edi),%eax
  101bfb:	83 f8 01             	cmp    $0x1,%eax
  101bfe:	0f 85 a8 00 00 00    	jne    101cac <iput+0xcc>
  101c04:	8b 57 0c             	mov    0xc(%edi),%edx
  101c07:	f6 c2 02             	test   $0x2,%dl
  101c0a:	0f 84 9c 00 00 00    	je     101cac <iput+0xcc>
  101c10:	66 83 7f 16 00       	cmpw   $0x0,0x16(%edi)
  101c15:	0f 85 91 00 00 00    	jne    101cac <iput+0xcc>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101c1b:	f6 c2 01             	test   $0x1,%dl
  101c1e:	66 90                	xchg   %ax,%ax
  101c20:	0f 85 9d 01 00 00    	jne    101dc3 <iput+0x1e3>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101c26:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  101c29:	89 fb                	mov    %edi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101c2b:	89 57 0c             	mov    %edx,0xc(%edi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  101c2e:	8d 77 2c             	lea    0x2c(%edi),%esi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  101c31:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101c38:	e8 a3 2a 00 00       	call   1046e0 <release>
  101c3d:	eb 07                	jmp    101c46 <iput+0x66>
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101c3f:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101c42:	39 f3                	cmp    %esi,%ebx
  101c44:	74 1c                	je     101c62 <iput+0x82>
    if(ip->addrs[i]){
  101c46:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101c49:	85 d2                	test   %edx,%edx
  101c4b:	74 f2                	je     101c3f <iput+0x5f>
      bfree(ip->dev, ip->addrs[i]);
  101c4d:	8b 07                	mov    (%edi),%eax
  101c4f:	e8 cc fe ff ff       	call   101b20 <bfree>
      ip->addrs[i] = 0;
  101c54:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101c5b:	83 c3 04             	add    $0x4,%ebx
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101c5e:	39 f3                	cmp    %esi,%ebx
  101c60:	75 e4                	jne    101c46 <iput+0x66>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101c62:	8b 47 48             	mov    0x48(%edi),%eax
  101c65:	85 c0                	test   %eax,%eax
  101c67:	0f 85 e9 00 00 00    	jne    101d56 <iput+0x176>
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
  101c6d:	8b 47 4c             	mov    0x4c(%edi),%eax
  101c70:	85 c0                	test   %eax,%eax
  101c72:	75 51                	jne    101cc5 <iput+0xe5>
	      }
	      brelse(bp);
	      ip->addrs[DINDIRECT] = 0;
  }

  ip->size = 0;
  101c74:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101c7b:	89 3c 24             	mov    %edi,(%esp)
  101c7e:	e8 8d fa ff ff       	call   101710 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101c83:	66 c7 47 10 00 00    	movw   $0x0,0x10(%edi)
    iupdate(ip);
  101c89:	89 3c 24             	mov    %edi,(%esp)
  101c8c:	e8 7f fa ff ff       	call   101710 <iupdate>
    acquire(&icache.lock);
  101c91:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101c98:	e8 83 2a 00 00       	call   104720 <acquire>
    ip->flags &= ~I_BUSY;
  101c9d:	83 67 0c fe          	andl   $0xfffffffe,0xc(%edi)
    wakeup(ip);
  101ca1:	89 3c 24             	mov    %edi,(%esp)
  101ca4:	e8 37 19 00 00       	call   1035e0 <wakeup>
  101ca9:	8b 47 08             	mov    0x8(%edi),%eax
  }
  ip->ref--;
  101cac:	83 e8 01             	sub    $0x1,%eax
  101caf:	89 47 08             	mov    %eax,0x8(%edi)
  release(&icache.lock);
  101cb2:	c7 45 08 00 ab 10 00 	movl   $0x10ab00,0x8(%ebp)
}
  101cb9:	83 c4 2c             	add    $0x2c,%esp
  101cbc:	5b                   	pop    %ebx
  101cbd:	5e                   	pop    %esi
  101cbe:	5f                   	pop    %edi
  101cbf:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101cc0:	e9 1b 2a 00 00       	jmp    1046e0 <release>
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	8b 07                	mov    (%edi),%eax
  101ccb:	89 04 24             	mov    %eax,(%esp)
  101cce:	e8 5d e4 ff ff       	call   100130 <bread>
	      a = (uint*)bp->data;
  101cd3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    ip->addrs[INDIRECT] = 0;
  }

  //free double indirect blocks -- NEW CODE
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
  101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
	      a = (uint*)bp->data;
  101cdd:	83 c0 18             	add    $0x18,%eax
  101ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  101ce3:	31 c0                	xor    %eax,%eax
  101ce5:	eb 13                	jmp    101cfa <iput+0x11a>
  101ce7:	90                   	nop
	      for(j = 0; j < NINDIRECT; j++){
  101ce8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  101cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101cef:	3d 80 00 00 00       	cmp    $0x80,%eax
  101cf4:	0f 84 9b 00 00 00    	je     101d95 <iput+0x1b5>
	        if(a[j]){
  101cfa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101cfd:	8d 04 82             	lea    (%edx,%eax,4),%eax
  101d00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101d03:	8b 00                	mov    (%eax),%eax
  101d05:	85 c0                	test   %eax,%eax
  101d07:	74 df                	je     101ce8 <iput+0x108>
	          bp2 = bread(ip->dev, a[j]);
  101d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0d:	8b 07                	mov    (%edi),%eax
	          uint* b = (uint*)bp2->data;
  101d0f:	31 db                	xor    %ebx,%ebx
  if(ip->addrs[DINDIRECT]){
	  bp = bread(ip->dev, ip->addrs[DINDIRECT]);
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
  101d11:	89 04 24             	mov    %eax,(%esp)
  101d14:	e8 17 e4 ff ff       	call   100130 <bread>
	          uint* b = (uint*)bp2->data;
  101d19:	8d 70 18             	lea    0x18(%eax),%esi
  101d1c:	31 c0                	xor    %eax,%eax
  101d1e:	eb 0d                	jmp    101d2d <iput+0x14d>
	          for(k = 0; k < NINDIRECT; k++){
  101d20:	83 c3 01             	add    $0x1,%ebx
  101d23:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d29:	89 d8                	mov    %ebx,%eax
  101d2b:	74 1b                	je     101d48 <iput+0x168>
	        	  if(b[k]){
  101d2d:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101d30:	85 d2                	test   %edx,%edx
  101d32:	74 ec                	je     101d20 <iput+0x140>
	        		  bfree(ip->dev, b[k]);
  101d34:	8b 07                	mov    (%edi),%eax
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101d36:	83 c3 01             	add    $0x1,%ebx
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
  101d39:	e8 e2 fd ff ff       	call   101b20 <bfree>
	      a = (uint*)bp->data;
	      for(j = 0; j < NINDIRECT; j++){
	        if(a[j]){
	          bp2 = bread(ip->dev, a[j]);
	          uint* b = (uint*)bp2->data;
	          for(k = 0; k < NINDIRECT; k++){
  101d3e:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d44:	89 d8                	mov    %ebx,%eax
  101d46:	75 e5                	jne    101d2d <iput+0x14d>
	        	  if(b[k]){
	        		  bfree(ip->dev, b[k]);
	        	  }

	          }
	          bfree(ip->dev, a[j]);
  101d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101d4b:	8b 10                	mov    (%eax),%edx
  101d4d:	8b 07                	mov    (%edi),%eax
  101d4f:	e8 cc fd ff ff       	call   101b20 <bfree>
  101d54:	eb 92                	jmp    101ce8 <iput+0x108>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5a:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101d5c:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d5e:	89 04 24             	mov    %eax,(%esp)
  101d61:	e8 ca e3 ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  101d66:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101d68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101d6b:	83 c6 18             	add    $0x18,%esi
  101d6e:	31 c0                	xor    %eax,%eax
  101d70:	eb 13                	jmp    101d85 <iput+0x1a5>
  101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(j = 0; j < NINDIRECT; j++){
  101d78:	83 c3 01             	add    $0x1,%ebx
  101d7b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101d81:	89 d8                	mov    %ebx,%eax
  101d83:	74 27                	je     101dac <iput+0x1cc>
      if(a[j])
  101d85:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101d88:	85 d2                	test   %edx,%edx
  101d8a:	74 ec                	je     101d78 <iput+0x198>
        bfree(ip->dev, a[j]);
  101d8c:	8b 07                	mov    (%edi),%eax
  101d8e:	e8 8d fd ff ff       	call   101b20 <bfree>
  101d93:	eb e3                	jmp    101d78 <iput+0x198>

	          }
	          bfree(ip->dev, a[j]);
	        }
	      }
	      brelse(bp);
  101d95:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101d98:	89 14 24             	mov    %edx,(%esp)
  101d9b:	e8 60 e2 ff ff       	call   100000 <brelse>
	      ip->addrs[DINDIRECT] = 0;
  101da0:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101da7:	e9 c8 fe ff ff       	jmp    101c74 <iput+0x94>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101daf:	89 04 24             	mov    %eax,(%esp)
  101db2:	e8 49 e2 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  101db7:	c7 47 48 00 00 00 00 	movl   $0x0,0x48(%edi)
  101dbe:	e9 aa fe ff ff       	jmp    101c6d <iput+0x8d>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101dc3:	c7 04 24 e2 69 10 00 	movl   $0x1069e2,(%esp)
  101dca:	e8 a1 eb ff ff       	call   100970 <panic>
  101dcf:	90                   	nop

00101dd0 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101dd0:	55                   	push   %ebp
  101dd1:	89 e5                	mov    %esp,%ebp
  101dd3:	57                   	push   %edi
  101dd4:	56                   	push   %esi
  101dd5:	53                   	push   %ebx
  101dd6:	83 ec 2c             	sub    $0x2c,%esp
  101dd9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  101ddf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101de6:	00 
  101de7:	89 34 24             	mov    %esi,(%esp)
  101dea:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dee:	e8 0d fb ff ff       	call   101900 <dirlookup>
  101df3:	85 c0                	test   %eax,%eax
  101df5:	0f 85 89 00 00 00    	jne    101e84 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101dfb:	8b 7e 18             	mov    0x18(%esi),%edi
  101dfe:	85 ff                	test   %edi,%edi
  101e00:	0f 84 8d 00 00 00    	je     101e93 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101e06:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101e09:	31 db                	xor    %ebx,%ebx
  101e0b:	eb 0b                	jmp    101e18 <dirlink+0x48>
  101e0d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101e10:	83 c3 10             	add    $0x10,%ebx
  101e13:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101e16:	76 24                	jbe    101e3c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e18:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101e1f:	00 
  101e20:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101e24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101e28:	89 34 24             	mov    %esi,(%esp)
  101e2b:	e8 d0 f7 ff ff       	call   101600 <readi>
  101e30:	83 f8 10             	cmp    $0x10,%eax
  101e33:	75 65                	jne    101e9a <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101e35:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101e3a:	75 d4                	jne    101e10 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101e3f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e46:	00 
  101e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e4b:	8d 45 da             	lea    -0x26(%ebp),%eax
  101e4e:	89 04 24             	mov    %eax,(%esp)
  101e51:	e8 8a 2a 00 00       	call   1048e0 <strncpy>
  de.inum = ino;
  101e56:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e59:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101e60:	00 
  101e61:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101e65:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101e69:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101e6d:	89 34 24             	mov    %esi,(%esp)
  101e70:	e8 2b f9 ff ff       	call   1017a0 <writei>
  101e75:	83 f8 10             	cmp    $0x10,%eax
  101e78:	75 2c                	jne    101ea6 <dirlink+0xd6>
    panic("dirlink");
  101e7a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101e7c:	83 c4 2c             	add    $0x2c,%esp
  101e7f:	5b                   	pop    %ebx
  101e80:	5e                   	pop    %esi
  101e81:	5f                   	pop    %edi
  101e82:	5d                   	pop    %ebp
  101e83:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101e84:	89 04 24             	mov    %eax,(%esp)
  101e87:	e8 54 fd ff ff       	call   101be0 <iput>
  101e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101e91:	eb e9                	jmp    101e7c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101e93:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101e96:	31 db                	xor    %ebx,%ebx
  101e98:	eb a2                	jmp    101e3c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101e9a:	c7 04 24 ec 69 10 00 	movl   $0x1069ec,(%esp)
  101ea1:	e8 ca ea ff ff       	call   100970 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101ea6:	c7 04 24 f9 69 10 00 	movl   $0x1069f9,(%esp)
  101ead:	e8 be ea ff ff       	call   100970 <panic>
  101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101ec0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101ec0:	55                   	push   %ebp
  101ec1:	89 e5                	mov    %esp,%ebp
  101ec3:	53                   	push   %ebx
  101ec4:	83 ec 14             	sub    $0x14,%esp
  101ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101eca:	85 db                	test   %ebx,%ebx
  101ecc:	74 36                	je     101f04 <iunlock+0x44>
  101ece:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101ed2:	74 30                	je     101f04 <iunlock+0x44>
  101ed4:	8b 43 08             	mov    0x8(%ebx),%eax
  101ed7:	85 c0                	test   %eax,%eax
  101ed9:	7e 29                	jle    101f04 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101edb:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101ee2:	e8 39 28 00 00       	call   104720 <acquire>
  ip->flags &= ~I_BUSY;
  101ee7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101eeb:	89 1c 24             	mov    %ebx,(%esp)
  101eee:	e8 ed 16 00 00       	call   1035e0 <wakeup>
  release(&icache.lock);
  101ef3:	c7 45 08 00 ab 10 00 	movl   $0x10ab00,0x8(%ebp)
}
  101efa:	83 c4 14             	add    $0x14,%esp
  101efd:	5b                   	pop    %ebx
  101efe:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101eff:	e9 dc 27 00 00       	jmp    1046e0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101f04:	c7 04 24 01 6a 10 00 	movl   $0x106a01,(%esp)
  101f0b:	e8 60 ea ff ff       	call   100970 <panic>

00101f10 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101f10:	55                   	push   %ebp
  101f11:	89 e5                	mov    %esp,%ebp
  101f13:	53                   	push   %ebx
  101f14:	83 ec 14             	sub    $0x14,%esp
  101f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101f1a:	89 1c 24             	mov    %ebx,(%esp)
  101f1d:	e8 9e ff ff ff       	call   101ec0 <iunlock>
  iput(ip);
  101f22:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101f25:	83 c4 14             	add    $0x14,%esp
  101f28:	5b                   	pop    %ebx
  101f29:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101f2a:	e9 b1 fc ff ff       	jmp    101be0 <iput>
  101f2f:	90                   	nop

00101f30 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101f30:	55                   	push   %ebp
  101f31:	89 e5                	mov    %esp,%ebp
  101f33:	56                   	push   %esi
  101f34:	53                   	push   %ebx
  101f35:	83 ec 10             	sub    $0x10,%esp
  101f38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101f3b:	85 db                	test   %ebx,%ebx
  101f3d:	0f 84 e5 00 00 00    	je     102028 <ilock+0xf8>
  101f43:	8b 53 08             	mov    0x8(%ebx),%edx
  101f46:	85 d2                	test   %edx,%edx
  101f48:	0f 8e da 00 00 00    	jle    102028 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101f4e:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101f55:	e8 c6 27 00 00       	call   104720 <acquire>
  while(ip->flags & I_BUSY)
  101f5a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f5d:	a8 01                	test   $0x1,%al
  101f5f:	74 1e                	je     101f7f <ilock+0x4f>
  101f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101f68:	c7 44 24 04 00 ab 10 	movl   $0x10ab00,0x4(%esp)
  101f6f:	00 
  101f70:	89 1c 24             	mov    %ebx,(%esp)
  101f73:	e8 18 1a 00 00       	call   103990 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101f78:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f7b:	a8 01                	test   $0x1,%al
  101f7d:	75 e9                	jne    101f68 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101f7f:	83 c8 01             	or     $0x1,%eax
  101f82:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  101f85:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  101f8c:	e8 4f 27 00 00       	call   1046e0 <release>

  if(!(ip->flags & I_VALID)){
  101f91:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  101f95:	74 09                	je     101fa0 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101f97:	83 c4 10             	add    $0x10,%esp
  101f9a:	5b                   	pop    %ebx
  101f9b:	5e                   	pop    %esi
  101f9c:	5d                   	pop    %ebp
  101f9d:	c3                   	ret    
  101f9e:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101fa0:	8b 43 04             	mov    0x4(%ebx),%eax
  101fa3:	c1 e8 03             	shr    $0x3,%eax
  101fa6:	83 c0 02             	add    $0x2,%eax
  101fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101fad:	8b 03                	mov    (%ebx),%eax
  101faf:	89 04 24             	mov    %eax,(%esp)
  101fb2:	e8 79 e1 ff ff       	call   100130 <bread>
  101fb7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101fb9:	8b 43 04             	mov    0x4(%ebx),%eax
  101fbc:	83 e0 07             	and    $0x7,%eax
  101fbf:	c1 e0 06             	shl    $0x6,%eax
  101fc2:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  101fc6:	0f b7 10             	movzwl (%eax),%edx
  101fc9:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  101fcd:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101fd1:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  101fd5:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101fd9:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  101fdd:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101fe1:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  101fe5:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101fe8:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101feb:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ff2:	8d 43 1c             	lea    0x1c(%ebx),%eax
  101ff5:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101ffc:	00 
  101ffd:	89 04 24             	mov    %eax,(%esp)
  102000:	e8 1b 28 00 00       	call   104820 <memmove>
    brelse(bp);
  102005:	89 34 24             	mov    %esi,(%esp)
  102008:	e8 f3 df ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  10200d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  102011:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  102016:	0f 85 7b ff ff ff    	jne    101f97 <ilock+0x67>
      panic("ilock: no type");
  10201c:	c7 04 24 0f 6a 10 00 	movl   $0x106a0f,(%esp)
  102023:	e8 48 e9 ff ff       	call   100970 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  102028:	c7 04 24 09 6a 10 00 	movl   $0x106a09,(%esp)
  10202f:	e8 3c e9 ff ff       	call   100970 <panic>
  102034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10203a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102040 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  102040:	55                   	push   %ebp
  102041:	89 e5                	mov    %esp,%ebp
  102043:	57                   	push   %edi
  102044:	56                   	push   %esi
  102045:	53                   	push   %ebx
  102046:	89 c3                	mov    %eax,%ebx
  102048:	83 ec 2c             	sub    $0x2c,%esp
  10204b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  10204e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  102051:	80 38 2f             	cmpb   $0x2f,(%eax)
  102054:	0f 84 3b 01 00 00    	je     102195 <_namei+0x155>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  10205a:	e8 81 16 00 00       	call   1036e0 <curproc>
  10205f:	8b 40 60             	mov    0x60(%eax),%eax
  102062:	89 04 24             	mov    %eax,(%esp)
  102065:	e8 b6 f1 ff ff       	call   101220 <idup>
  10206a:	89 c7                	mov    %eax,%edi
  10206c:	eb 05                	jmp    102073 <_namei+0x33>
  10206e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  102070:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  102073:	0f b6 03             	movzbl (%ebx),%eax
  102076:	3c 2f                	cmp    $0x2f,%al
  102078:	74 f6                	je     102070 <_namei+0x30>
    path++;
  if(*path == 0)
  10207a:	84 c0                	test   %al,%al
  10207c:	75 1a                	jne    102098 <_namei+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  10207e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  102081:	85 c9                	test   %ecx,%ecx
  102083:	0f 85 34 01 00 00    	jne    1021bd <_namei+0x17d>
    iput(ip);
    return 0;
  }
  return ip;
}
  102089:	83 c4 2c             	add    $0x2c,%esp
  10208c:	89 f8                	mov    %edi,%eax
  10208e:	5b                   	pop    %ebx
  10208f:	5e                   	pop    %esi
  102090:	5f                   	pop    %edi
  102091:	5d                   	pop    %ebp
  102092:	c3                   	ret    
  102093:	90                   	nop
  102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  102098:	3c 2f                	cmp    $0x2f,%al
  10209a:	0f 84 db 00 00 00    	je     10217b <_namei+0x13b>
  1020a0:	89 de                	mov    %ebx,%esi
    path++;
  1020a2:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  1020a5:	0f b6 06             	movzbl (%esi),%eax
  1020a8:	84 c0                	test   %al,%al
  1020aa:	0f 85 90 00 00 00    	jne    102140 <_namei+0x100>
  1020b0:	89 f2                	mov    %esi,%edx
  1020b2:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  1020b4:	83 fa 0d             	cmp    $0xd,%edx
  1020b7:	0f 8e 99 00 00 00    	jle    102156 <_namei+0x116>
  1020bd:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, DIRSIZ);
  1020c0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1020c7:	00 
  1020c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1020cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1020cf:	89 04 24             	mov    %eax,(%esp)
  1020d2:	e8 49 27 00 00       	call   104820 <memmove>
  1020d7:	eb 0a                	jmp    1020e3 <_namei+0xa3>
  1020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  1020e0:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  1020e3:	80 3e 2f             	cmpb   $0x2f,(%esi)
  1020e6:	74 f8                	je     1020e0 <_namei+0xa0>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  1020e8:	85 f6                	test   %esi,%esi
  1020ea:	74 92                	je     10207e <_namei+0x3e>
    ilock(ip);
  1020ec:	89 3c 24             	mov    %edi,(%esp)
  1020ef:	e8 3c fe ff ff       	call   101f30 <ilock>
    if(ip->type != T_DIR){
  1020f4:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1020f9:	0f 85 82 00 00 00    	jne    102181 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  1020ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  102102:	85 db                	test   %ebx,%ebx
  102104:	74 09                	je     10210f <_namei+0xcf>
  102106:	80 3e 00             	cmpb   $0x0,(%esi)
  102109:	0f 84 9c 00 00 00    	je     1021ab <_namei+0x16b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  10210f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102116:	00 
  102117:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10211a:	89 3c 24             	mov    %edi,(%esp)
  10211d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102121:	e8 da f7 ff ff       	call   101900 <dirlookup>
  102126:	85 c0                	test   %eax,%eax
  102128:	89 c3                	mov    %eax,%ebx
  10212a:	74 55                	je     102181 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  10212c:	89 3c 24             	mov    %edi,(%esp)
  10212f:	89 df                	mov    %ebx,%edi
  102131:	89 f3                	mov    %esi,%ebx
  102133:	e8 d8 fd ff ff       	call   101f10 <iunlockput>
  102138:	e9 36 ff ff ff       	jmp    102073 <_namei+0x33>
  10213d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  102140:	3c 2f                	cmp    $0x2f,%al
  102142:	0f 85 5a ff ff ff    	jne    1020a2 <_namei+0x62>
  102148:	89 f2                	mov    %esi,%edx
  10214a:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  10214c:	83 fa 0d             	cmp    $0xd,%edx
  10214f:	90                   	nop
  102150:	0f 8f 6a ff ff ff    	jg     1020c0 <_namei+0x80>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  102156:	89 54 24 08          	mov    %edx,0x8(%esp)
  10215a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10215e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102161:	89 04 24             	mov    %eax,(%esp)
  102164:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102167:	e8 b4 26 00 00       	call   104820 <memmove>
    name[len] = 0;
  10216c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10216f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102172:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  102176:	e9 68 ff ff ff       	jmp    1020e3 <_namei+0xa3>
  }
  while(*path == '/')
  10217b:	89 de                	mov    %ebx,%esi
  10217d:	31 d2                	xor    %edx,%edx
  10217f:	eb d5                	jmp    102156 <_namei+0x116>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  102181:	89 3c 24             	mov    %edi,(%esp)
  102184:	31 ff                	xor    %edi,%edi
  102186:	e8 85 fd ff ff       	call   101f10 <iunlockput>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  10218b:	83 c4 2c             	add    $0x2c,%esp
  10218e:	89 f8                	mov    %edi,%eax
  102190:	5b                   	pop    %ebx
  102191:	5e                   	pop    %esi
  102192:	5f                   	pop    %edi
  102193:	5d                   	pop    %ebp
  102194:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  102195:	ba 01 00 00 00       	mov    $0x1,%edx
  10219a:	b8 01 00 00 00       	mov    $0x1,%eax
  10219f:	e8 ac f0 ff ff       	call   101250 <iget>
  1021a4:	89 c7                	mov    %eax,%edi
  1021a6:	e9 c8 fe ff ff       	jmp    102073 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  1021ab:	89 3c 24             	mov    %edi,(%esp)
  1021ae:	e8 0d fd ff ff       	call   101ec0 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1021b3:	83 c4 2c             	add    $0x2c,%esp
  1021b6:	89 f8                	mov    %edi,%eax
  1021b8:	5b                   	pop    %ebx
  1021b9:	5e                   	pop    %esi
  1021ba:	5f                   	pop    %edi
  1021bb:	5d                   	pop    %ebp
  1021bc:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  1021bd:	89 3c 24             	mov    %edi,(%esp)
  1021c0:	31 ff                	xor    %edi,%edi
  1021c2:	e8 19 fa ff ff       	call   101be0 <iput>
    return 0;
  1021c7:	e9 bd fe ff ff       	jmp    102089 <_namei+0x49>
  1021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001021d0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1021d0:	55                   	push   %ebp
  return _namei(path, 1, name);
  1021d1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1021d6:	89 e5                	mov    %esp,%ebp
  1021d8:	83 ec 08             	sub    $0x8,%esp
  return _namei(path, 1, name);
  1021db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1021de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1021e1:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  1021e2:	e9 59 fe ff ff       	jmp    102040 <_namei>
  1021e7:	89 f6                	mov    %esi,%esi
  1021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001021f0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  1021f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  1021f1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  1021f3:	89 e5                	mov    %esp,%ebp
  1021f5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  1021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1021fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  1021fe:	e8 3d fe ff ff       	call   102040 <_namei>
}
  102203:	c9                   	leave  
  102204:	c3                   	ret    
  102205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102210 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102210:	55                   	push   %ebp
  102211:	89 e5                	mov    %esp,%ebp
  102213:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache.lock");
  102216:	c7 44 24 04 1e 6a 10 	movl   $0x106a1e,0x4(%esp)
  10221d:	00 
  10221e:	c7 04 24 00 ab 10 00 	movl   $0x10ab00,(%esp)
  102225:	e8 36 23 00 00       	call   104560 <initlock>
}
  10222a:	c9                   	leave  
  10222b:	c3                   	ret    
  10222c:	90                   	nop
  10222d:	90                   	nop
  10222e:	90                   	nop
  10222f:	90                   	nop

00102230 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  102230:	55                   	push   %ebp
  102231:	89 c1                	mov    %eax,%ecx
  102233:	89 e5                	mov    %esp,%ebp
  102235:	56                   	push   %esi
  102236:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  102239:	85 c0                	test   %eax,%eax
  10223b:	0f 84 89 00 00 00    	je     1022ca <ide_start_request+0x9a>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102241:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102246:	66 90                	xchg   %ax,%ax
  102248:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102249:	0f b6 c0             	movzbl %al,%eax
  10224c:	84 c0                	test   %al,%al
  10224e:	78 f8                	js     102248 <ide_start_request+0x18>
  102250:	a8 40                	test   $0x40,%al
  102252:	74 f4                	je     102248 <ide_start_request+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102254:	ba f6 03 00 00       	mov    $0x3f6,%edx
  102259:	31 c0                	xor    %eax,%eax
  10225b:	ee                   	out    %al,(%dx)
  10225c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  102261:	b8 01 00 00 00       	mov    $0x1,%eax
  102266:	ee                   	out    %al,(%dx)
    panic("ide_start_request");

  ide_wait_ready(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  102267:	8b 71 08             	mov    0x8(%ecx),%esi
  10226a:	b2 f3                	mov    $0xf3,%dl
  10226c:	89 f0                	mov    %esi,%eax
  10226e:	ee                   	out    %al,(%dx)
  10226f:	89 f0                	mov    %esi,%eax
  102271:	b2 f4                	mov    $0xf4,%dl
  102273:	c1 e8 08             	shr    $0x8,%eax
  102276:	ee                   	out    %al,(%dx)
  102277:	89 f0                	mov    %esi,%eax
  102279:	b2 f5                	mov    $0xf5,%dl
  10227b:	c1 e8 10             	shr    $0x10,%eax
  10227e:	ee                   	out    %al,(%dx)
  10227f:	8b 41 04             	mov    0x4(%ecx),%eax
  102282:	c1 ee 18             	shr    $0x18,%esi
  102285:	b2 f6                	mov    $0xf6,%dl
  102287:	83 e6 0f             	and    $0xf,%esi
  10228a:	83 e0 01             	and    $0x1,%eax
  10228d:	c1 e0 04             	shl    $0x4,%eax
  102290:	09 f0                	or     %esi,%eax
  102292:	83 c8 e0             	or     $0xffffffe0,%eax
  102295:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  102296:	f6 01 04             	testb  $0x4,(%ecx)
  102299:	75 11                	jne    1022ac <ide_start_request+0x7c>
  10229b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022a0:	b8 20 00 00 00       	mov    $0x20,%eax
  1022a5:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1022a6:	83 c4 14             	add    $0x14,%esp
  1022a9:	5e                   	pop    %esi
  1022aa:	5d                   	pop    %ebp
  1022ab:	c3                   	ret    
  1022ac:	b2 f7                	mov    $0xf7,%dl
  1022ae:	b8 30 00 00 00       	mov    $0x30,%eax
  1022b3:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1022b4:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1022b9:	8d 71 18             	lea    0x18(%ecx),%esi
  1022bc:	b9 80 00 00 00       	mov    $0x80,%ecx
  1022c1:	fc                   	cld    
  1022c2:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  1022c4:	83 c4 14             	add    $0x14,%esp
  1022c7:	5e                   	pop    %esi
  1022c8:	5d                   	pop    %ebp
  1022c9:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  1022ca:	c7 04 24 4d 6a 10 00 	movl   $0x106a4d,(%esp)
  1022d1:	e8 9a e6 ff ff       	call   100970 <panic>
  1022d6:	8d 76 00             	lea    0x0(%esi),%esi
  1022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001022e0 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  1022e0:	55                   	push   %ebp
  1022e1:	89 e5                	mov    %esp,%ebp
  1022e3:	53                   	push   %ebx
  1022e4:	83 ec 14             	sub    $0x14,%esp
  1022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  1022ea:	8b 03                	mov    (%ebx),%eax
  1022ec:	a8 01                	test   $0x1,%al
  1022ee:	0f 84 90 00 00 00    	je     102384 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  1022f4:	83 e0 06             	and    $0x6,%eax
  1022f7:	83 f8 02             	cmp    $0x2,%eax
  1022fa:	0f 84 9c 00 00 00    	je     10239c <ide_rw+0xbc>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102300:	8b 53 04             	mov    0x4(%ebx),%edx
  102303:	85 d2                	test   %edx,%edx
  102305:	74 0d                	je     102314 <ide_rw+0x34>
  102307:	a1 b8 88 10 00       	mov    0x1088b8,%eax
  10230c:	85 c0                	test   %eax,%eax
  10230e:	0f 84 7c 00 00 00    	je     102390 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102314:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  10231b:	e8 00 24 00 00       	call   104720 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102320:	a1 b4 88 10 00       	mov    0x1088b4,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102325:	ba b4 88 10 00       	mov    $0x1088b4,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10232a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102331:	85 c0                	test   %eax,%eax
  102333:	74 0d                	je     102342 <ide_rw+0x62>
  102335:	8d 76 00             	lea    0x0(%esi),%esi
  102338:	8d 50 14             	lea    0x14(%eax),%edx
  10233b:	8b 40 14             	mov    0x14(%eax),%eax
  10233e:	85 c0                	test   %eax,%eax
  102340:	75 f6                	jne    102338 <ide_rw+0x58>
    ;
  *pp = b;
  102342:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  102344:	39 1d b4 88 10 00    	cmp    %ebx,0x1088b4
  10234a:	75 14                	jne    102360 <ide_rw+0x80>
  10234c:	eb 2d                	jmp    10237b <ide_rw+0x9b>
  10234e:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102350:	c7 44 24 04 80 88 10 	movl   $0x108880,0x4(%esp)
  102357:	00 
  102358:	89 1c 24             	mov    %ebx,(%esp)
  10235b:	e8 30 16 00 00       	call   103990 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102360:	8b 03                	mov    (%ebx),%eax
  102362:	83 e0 06             	and    $0x6,%eax
  102365:	83 f8 02             	cmp    $0x2,%eax
  102368:	75 e6                	jne    102350 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10236a:	c7 45 08 80 88 10 00 	movl   $0x108880,0x8(%ebp)
}
  102371:	83 c4 14             	add    $0x14,%esp
  102374:	5b                   	pop    %ebx
  102375:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102376:	e9 65 23 00 00       	jmp    1046e0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  10237b:	89 d8                	mov    %ebx,%eax
  10237d:	e8 ae fe ff ff       	call   102230 <ide_start_request>
  102382:	eb dc                	jmp    102360 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  102384:	c7 04 24 5f 6a 10 00 	movl   $0x106a5f,(%esp)
  10238b:	e8 e0 e5 ff ff       	call   100970 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  102390:	c7 04 24 8a 6a 10 00 	movl   $0x106a8a,(%esp)
  102397:	e8 d4 e5 ff ff       	call   100970 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  10239c:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  1023a3:	e8 c8 e5 ff ff       	call   100970 <panic>
  1023a8:	90                   	nop
  1023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001023b0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1023b0:	55                   	push   %ebp
  1023b1:	89 e5                	mov    %esp,%ebp
  1023b3:	57                   	push   %edi
  1023b4:	53                   	push   %ebx
  1023b5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1023b8:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  1023bf:	e8 5c 23 00 00       	call   104720 <acquire>
  if((b = ide_queue) == 0){
  1023c4:	8b 1d b4 88 10 00    	mov    0x1088b4,%ebx
  1023ca:	85 db                	test   %ebx,%ebx
  1023cc:	74 28                	je     1023f6 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1023ce:	8b 0b                	mov    (%ebx),%ecx
  1023d0:	f6 c1 04             	test   $0x4,%cl
  1023d3:	74 3b                	je     102410 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1023d5:	83 c9 02             	or     $0x2,%ecx
  1023d8:	83 e1 fb             	and    $0xfffffffb,%ecx
  1023db:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  1023dd:	89 1c 24             	mov    %ebx,(%esp)
  1023e0:	e8 fb 11 00 00       	call   1035e0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  1023e5:	8b 43 14             	mov    0x14(%ebx),%eax
  1023e8:	85 c0                	test   %eax,%eax
  1023ea:	a3 b4 88 10 00       	mov    %eax,0x1088b4
  1023ef:	74 05                	je     1023f6 <ide_intr+0x46>
    ide_start_request(ide_queue);
  1023f1:	e8 3a fe ff ff       	call   102230 <ide_start_request>

  release(&ide_lock);
  1023f6:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  1023fd:	e8 de 22 00 00       	call   1046e0 <release>
}
  102402:	83 c4 10             	add    $0x10,%esp
  102405:	5b                   	pop    %ebx
  102406:	5f                   	pop    %edi
  102407:	5d                   	pop    %ebp
  102408:	c3                   	ret    
  102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102410:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102415:	8d 76 00             	lea    0x0(%esi),%esi
  102418:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102419:	0f b6 c0             	movzbl %al,%eax
  10241c:	84 c0                	test   %al,%al
  10241e:	78 f8                	js     102418 <ide_intr+0x68>
  102420:	a8 40                	test   $0x40,%al
  102422:	74 f4                	je     102418 <ide_intr+0x68>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102424:	a8 21                	test   $0x21,%al
  102426:	75 ad                	jne    1023d5 <ide_intr+0x25>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102428:	8d 7b 18             	lea    0x18(%ebx),%edi
  10242b:	b9 80 00 00 00       	mov    $0x80,%ecx
  102430:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102435:	fc                   	cld    
  102436:	f2 6d                	repnz insl (%dx),%es:(%edi)
  102438:	8b 0b                	mov    (%ebx),%ecx
  10243a:	eb 99                	jmp    1023d5 <ide_intr+0x25>
  10243c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102440 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102440:	55                   	push   %ebp
  102441:	89 e5                	mov    %esp,%ebp
  102443:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&ide_lock, "ide");
  102446:	c7 44 24 04 a1 6a 10 	movl   $0x106aa1,0x4(%esp)
  10244d:	00 
  10244e:	c7 04 24 80 88 10 00 	movl   $0x108880,(%esp)
  102455:	e8 06 21 00 00       	call   104560 <initlock>
  pic_enable(IRQ_IDE);
  10245a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102461:	e8 8a 0b 00 00       	call   102ff0 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102466:	a1 a0 c1 10 00       	mov    0x10c1a0,%eax
  10246b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102472:	83 e8 01             	sub    $0x1,%eax
  102475:	89 44 24 04          	mov    %eax,0x4(%esp)
  102479:	e8 52 00 00 00       	call   1024d0 <ioapic_enable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10247e:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102483:	90                   	nop
  102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102488:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102489:	0f b6 c0             	movzbl %al,%eax
  10248c:	84 c0                	test   %al,%al
  10248e:	78 f8                	js     102488 <ide_init+0x48>
  102490:	a8 40                	test   $0x40,%al
  102492:	74 f4                	je     102488 <ide_init+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102494:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102499:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10249e:	ee                   	out    %al,(%dx)
  10249f:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1024a1:	b2 f7                	mov    $0xf7,%dl
  1024a3:	eb 0e                	jmp    1024b3 <ide_init+0x73>
  1024a5:	8d 76 00             	lea    0x0(%esi),%esi
  ioapic_enable(IRQ_IDE, ncpu - 1);
  ide_wait_ready(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1024a8:	83 c1 01             	add    $0x1,%ecx
  1024ab:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1024b1:	74 0f                	je     1024c2 <ide_init+0x82>
  1024b3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1024b4:	84 c0                	test   %al,%al
  1024b6:	74 f0                	je     1024a8 <ide_init+0x68>
      disk_1_present = 1;
  1024b8:	c7 05 b8 88 10 00 01 	movl   $0x1,0x1088b8
  1024bf:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1024c2:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1024c7:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1024cc:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1024cd:	c9                   	leave  
  1024ce:	c3                   	ret    
  1024cf:	90                   	nop

001024d0 <ioapic_enable>:
}

void
ioapic_enable(int irq, int cpunum)
{
  if(!ismp)
  1024d0:	8b 15 20 bb 10 00    	mov    0x10bb20,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1024d6:	55                   	push   %ebp
  1024d7:	89 e5                	mov    %esp,%ebp
  1024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  1024dc:	85 d2                	test   %edx,%edx
  1024de:	74 1f                	je     1024ff <ioapic_enable+0x2f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  1024e0:	8d 48 20             	lea    0x20(%eax),%ecx
  1024e3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1024e7:	a1 d4 ba 10 00       	mov    0x10bad4,%eax
  1024ec:	89 10                	mov    %edx,(%eax)
  1024ee:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  1024f1:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  1024f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1024f7:	89 10                	mov    %edx,(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  1024f9:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  1024fc:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  1024ff:	5d                   	pop    %ebp
  102500:	c3                   	ret    
  102501:	eb 0d                	jmp    102510 <ioapic_init>
  102503:	90                   	nop
  102504:	90                   	nop
  102505:	90                   	nop
  102506:	90                   	nop
  102507:	90                   	nop
  102508:	90                   	nop
  102509:	90                   	nop
  10250a:	90                   	nop
  10250b:	90                   	nop
  10250c:	90                   	nop
  10250d:	90                   	nop
  10250e:	90                   	nop
  10250f:	90                   	nop

00102510 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102510:	55                   	push   %ebp
  102511:	89 e5                	mov    %esp,%ebp
  102513:	56                   	push   %esi
  102514:	53                   	push   %ebx
  102515:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102518:	8b 0d 20 bb 10 00    	mov    0x10bb20,%ecx
  10251e:	85 c9                	test   %ecx,%ecx
  102520:	0f 84 86 00 00 00    	je     1025ac <ioapic_init+0x9c>
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  102526:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10252d:	00 00 00 
  return ioapic->data;
  102530:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102536:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  10253b:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102542:	00 00 00 
  return ioapic->data;
  102545:	8b 15 10 00 c0 fe    	mov    0xfec00010,%edx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10254b:	0f b6 0d 24 bb 10 00 	movzbl 0x10bb24,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102552:	c7 05 d4 ba 10 00 00 	movl   $0xfec00000,0x10bad4
  102559:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10255c:	c1 ee 10             	shr    $0x10,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10255f:	c1 ea 18             	shr    $0x18,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102562:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102568:	39 d1                	cmp    %edx,%ecx
  10256a:	74 11                	je     10257d <ioapic_init+0x6d>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10256c:	c7 04 24 a8 6a 10 00 	movl   $0x106aa8,(%esp)
  102573:	e8 58 e2 ff ff       	call   1007d0 <cprintf>
  102578:	a1 d4 ba 10 00       	mov    0x10bad4,%eax
  10257d:	b9 10 00 00 00       	mov    $0x10,%ecx
  102582:	31 d2                	xor    %edx,%edx
  102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  102588:	8d 5a 20             	lea    0x20(%edx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10258b:	83 c2 01             	add    $0x1,%edx
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  10258e:	81 cb 00 00 01 00    	or     $0x10000,%ebx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102594:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  102596:	89 58 10             	mov    %ebx,0x10(%eax)
  102599:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10259c:	83 c1 02             	add    $0x2,%ecx
  10259f:	39 d6                	cmp    %edx,%esi
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1025a1:	89 18                	mov    %ebx,(%eax)
  ioapic->data = data;
  1025a3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1025aa:	7d dc                	jge    102588 <ioapic_init+0x78>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1025ac:	83 c4 10             	add    $0x10,%esp
  1025af:	5b                   	pop    %ebx
  1025b0:	5e                   	pop    %esi
  1025b1:	5d                   	pop    %ebp
  1025b2:	c3                   	ret    
  1025b3:	90                   	nop
  1025b4:	90                   	nop
  1025b5:	90                   	nop
  1025b6:	90                   	nop
  1025b7:	90                   	nop
  1025b8:	90                   	nop
  1025b9:	90                   	nop
  1025ba:	90                   	nop
  1025bb:	90                   	nop
  1025bc:	90                   	nop
  1025bd:	90                   	nop
  1025be:	90                   	nop
  1025bf:	90                   	nop

001025c0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1025c0:	55                   	push   %ebp
  1025c1:	89 e5                	mov    %esp,%ebp
  1025c3:	56                   	push   %esi
  1025c4:	53                   	push   %ebx
  1025c5:	83 ec 10             	sub    $0x10,%esp
  1025c8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1025cb:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1025d1:	74 0d                	je     1025e0 <kalloc+0x20>
    panic("kalloc");
  1025d3:	c7 04 24 dc 6a 10 00 	movl   $0x106adc,(%esp)
  1025da:	e8 91 e3 ff ff       	call   100970 <panic>
  1025df:	90                   	nop
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1025e0:	85 f6                	test   %esi,%esi
  1025e2:	7e ef                	jle    1025d3 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  1025e4:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1025eb:	e8 30 21 00 00       	call   104720 <acquire>
  1025f0:	8b 1d 14 bb 10 00    	mov    0x10bb14,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  1025f6:	85 db                	test   %ebx,%ebx
  1025f8:	74 3e                	je     102638 <kalloc+0x78>
    if(r->len == n){
  1025fa:	8b 43 04             	mov    0x4(%ebx),%eax
  1025fd:	ba 14 bb 10 00       	mov    $0x10bb14,%edx
  102602:	39 f0                	cmp    %esi,%eax
  102604:	75 11                	jne    102617 <kalloc+0x57>
  102606:	eb 58                	jmp    102660 <kalloc+0xa0>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102608:	89 da                	mov    %ebx,%edx
  10260a:	8b 1b                	mov    (%ebx),%ebx
  10260c:	85 db                	test   %ebx,%ebx
  10260e:	74 28                	je     102638 <kalloc+0x78>
    if(r->len == n){
  102610:	8b 43 04             	mov    0x4(%ebx),%eax
  102613:	39 f0                	cmp    %esi,%eax
  102615:	74 49                	je     102660 <kalloc+0xa0>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102617:	39 c6                	cmp    %eax,%esi
  102619:	7d ed                	jge    102608 <kalloc+0x48>
      r->len -= n;
  10261b:	29 f0                	sub    %esi,%eax
  10261d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102620:	01 c3                	add    %eax,%ebx
      release(&kalloc_lock);
  102622:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  102629:	e8 b2 20 00 00       	call   1046e0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10262e:	83 c4 10             	add    $0x10,%esp
  102631:	89 d8                	mov    %ebx,%eax
  102633:	5b                   	pop    %ebx
  102634:	5e                   	pop    %esi
  102635:	5d                   	pop    %ebp
  102636:	c3                   	ret    
  102637:	90                   	nop
      return p;
    }
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  102638:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  10263a:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  102641:	e8 9a 20 00 00       	call   1046e0 <release>

  cprintf("kalloc: out of memory\n");
  102646:	c7 04 24 e3 6a 10 00 	movl   $0x106ae3,(%esp)
  10264d:	e8 7e e1 ff ff       	call   1007d0 <cprintf>
  return 0;
}
  102652:	83 c4 10             	add    $0x10,%esp
  102655:	89 d8                	mov    %ebx,%eax
  102657:	5b                   	pop    %ebx
  102658:	5e                   	pop    %esi
  102659:	5d                   	pop    %ebp
  10265a:	c3                   	ret    
  10265b:	90                   	nop
  10265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  102660:	8b 03                	mov    (%ebx),%eax
  102662:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  102664:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  10266b:	e8 70 20 00 00       	call   1046e0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  102670:	83 c4 10             	add    $0x10,%esp
  102673:	89 d8                	mov    %ebx,%eax
  102675:	5b                   	pop    %ebx
  102676:	5e                   	pop    %esi
  102677:	5d                   	pop    %ebp
  102678:	c3                   	ret    
  102679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102680 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102680:	55                   	push   %ebp
  102681:	89 e5                	mov    %esp,%ebp
  102683:	57                   	push   %edi
  102684:	56                   	push   %esi
  102685:	53                   	push   %ebx
  102686:	83 ec 2c             	sub    $0x2c,%esp
  102689:	8b 45 0c             	mov    0xc(%ebp),%eax
  10268c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10268f:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  102694:	0f 8e e9 00 00 00    	jle    102783 <kfree+0x103>
  10269a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  10269f:	0f 85 de 00 00 00    	jne    102783 <kfree+0x103>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1026a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1026a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1026af:	00 
  1026b0:	89 1c 24             	mov    %ebx,(%esp)
  1026b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1026b7:	e8 d4 20 00 00       	call   104790 <memset>

  acquire(&kalloc_lock);
  1026bc:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1026c3:	e8 58 20 00 00       	call   104720 <acquire>
  p = (struct run*)v;
  1026c8:	a1 14 bb 10 00       	mov    0x10bb14,%eax
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1026cd:	85 c0                	test   %eax,%eax
  1026cf:	74 61                	je     102732 <kfree+0xb2>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1026d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1026d4:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1026d7:	39 c1                	cmp    %eax,%ecx
  1026d9:	72 57                	jb     102732 <kfree+0xb2>
    rend = (struct run*)((char*)r + r->len);
  1026db:	8b 70 04             	mov    0x4(%eax),%esi
  1026de:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  1026e1:	39 d3                	cmp    %edx,%ebx
  1026e3:	72 73                	jb     102758 <kfree+0xd8>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1026e5:	39 c1                	cmp    %eax,%ecx
  1026e7:	0f 84 8f 00 00 00    	je     10277c <kfree+0xfc>
  1026ed:	8d 76 00             	lea    0x0(%esi),%esi
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  1026f0:	39 da                	cmp    %ebx,%edx
  1026f2:	74 6c                	je     102760 <kfree+0xe0>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1026f4:	89 c7                	mov    %eax,%edi
  1026f6:	8b 00                	mov    (%eax),%eax
  1026f8:	85 c0                	test   %eax,%eax
  1026fa:	74 3c                	je     102738 <kfree+0xb8>
  1026fc:	39 c1                	cmp    %eax,%ecx
  1026fe:	72 38                	jb     102738 <kfree+0xb8>
    rend = (struct run*)((char*)r + r->len);
  102700:	8b 70 04             	mov    0x4(%eax),%esi
  102703:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102706:	39 d3                	cmp    %edx,%ebx
  102708:	73 16                	jae    102720 <kfree+0xa0>
  10270a:	39 c3                	cmp    %eax,%ebx
  10270c:	72 12                	jb     102720 <kfree+0xa0>
      panic("freeing free page");
  10270e:	c7 04 24 00 6b 10 00 	movl   $0x106b00,(%esp)
  102715:	e8 56 e2 ff ff       	call   100970 <panic>
  10271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  102720:	39 c1                	cmp    %eax,%ecx
  102722:	75 cc                	jne    1026f0 <kfree+0x70>
      p->len = len + r->len;
      p->next = r->next;
  102724:	8b 01                	mov    (%ecx),%eax
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  102726:	03 75 e4             	add    -0x1c(%ebp),%esi
      p->next = r->next;
  102729:	89 03                	mov    %eax,(%ebx)
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  10272b:	89 73 04             	mov    %esi,0x4(%ebx)
      p->next = r->next;
      *rp = p;
  10272e:	89 1f                	mov    %ebx,(%edi)
      goto out;
  102730:	eb 10                	jmp    102742 <kfree+0xc2>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102732:	bf 14 bb 10 00       	mov    $0x10bb14,%edi
  102737:	90                   	nop
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->next = r;
  10273b:	89 03                	mov    %eax,(%ebx)
  *rp = p;
  10273d:	89 1f                	mov    %ebx,(%edi)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  10273f:	89 53 04             	mov    %edx,0x4(%ebx)
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102742:	c7 45 08 e0 ba 10 00 	movl   $0x10bae0,0x8(%ebp)
}
  102749:	83 c4 2c             	add    $0x2c,%esp
  10274c:	5b                   	pop    %ebx
  10274d:	5e                   	pop    %esi
  10274e:	5f                   	pop    %edi
  10274f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102750:	e9 8b 1f 00 00       	jmp    1046e0 <release>
  102755:	8d 76 00             	lea    0x0(%esi),%esi
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102758:	39 c3                	cmp    %eax,%ebx
  10275a:	73 b2                	jae    10270e <kfree+0x8e>
  10275c:	eb 87                	jmp    1026e5 <kfree+0x65>
  10275e:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102760:	8b 10                	mov    (%eax),%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102762:	03 75 e4             	add    -0x1c(%ebp),%esi
      if(r->next && r->next == pend){  // r now next to r->next?
  102765:	85 d2                	test   %edx,%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102767:	89 70 04             	mov    %esi,0x4(%eax)
      if(r->next && r->next == pend){  // r now next to r->next?
  10276a:	74 d6                	je     102742 <kfree+0xc2>
  10276c:	39 d1                	cmp    %edx,%ecx
  10276e:	75 d2                	jne    102742 <kfree+0xc2>
        r->len += r->next->len;
        r->next = r->next->next;
  102770:	8b 11                	mov    (%ecx),%edx
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102772:	03 71 04             	add    0x4(%ecx),%esi
        r->next = r->next->next;
  102775:	89 10                	mov    %edx,(%eax)
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102777:	89 70 04             	mov    %esi,0x4(%eax)
  10277a:	eb c6                	jmp    102742 <kfree+0xc2>
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  10277c:	bf 14 bb 10 00       	mov    $0x10bb14,%edi
  102781:	eb a1                	jmp    102724 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  102783:	c7 04 24 fa 6a 10 00 	movl   $0x106afa,(%esp)
  10278a:	e8 e1 e1 ff ff       	call   100970 <panic>
  10278f:	90                   	nop

00102790 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102790:	55                   	push   %ebp
  102791:	89 e5                	mov    %esp,%ebp
  102793:	83 ec 18             	sub    $0x18,%esp
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  102796:	c7 44 24 04 dc 6a 10 	movl   $0x106adc,0x4(%esp)
  10279d:	00 
  10279e:	c7 04 24 e0 ba 10 00 	movl   $0x10bae0,(%esp)
  1027a5:	e8 b6 1d 00 00       	call   104560 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1027aa:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1027b1:	00 
  1027b2:	c7 04 24 12 6b 10 00 	movl   $0x106b12,(%esp)
  1027b9:	e8 12 e0 ff ff       	call   1007d0 <cprintf>
  kfree(start, mem * PAGE);
  1027be:	b8 44 01 11 00       	mov    $0x110144,%eax
  1027c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1027c8:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1027cf:	00 
  1027d0:	89 04 24             	mov    %eax,(%esp)
  1027d3:	e8 a8 fe ff ff       	call   102680 <kfree>
}
  1027d8:	c9                   	leave  
  1027d9:	c3                   	ret    
  1027da:	90                   	nop
  1027db:	90                   	nop
  1027dc:	90                   	nop
  1027dd:	90                   	nop
  1027de:	90                   	nop
  1027df:	90                   	nop

001027e0 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  1027e0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1027e1:	ba 64 00 00 00       	mov    $0x64,%edx
  1027e6:	89 e5                	mov    %esp,%ebp
  1027e8:	ec                   	in     (%dx),%al
  1027e9:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  1027eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1027f0:	83 e2 01             	and    $0x1,%edx
  1027f3:	74 3e                	je     102833 <kbd_getc+0x53>
  1027f5:	ba 60 00 00 00       	mov    $0x60,%edx
  1027fa:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  1027fb:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  1027fe:	3d e0 00 00 00       	cmp    $0xe0,%eax
  102803:	0f 84 7f 00 00 00    	je     102888 <kbd_getc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102809:	84 c0                	test   %al,%al
  10280b:	79 2b                	jns    102838 <kbd_getc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  10280d:	8b 15 bc 88 10 00    	mov    0x1088bc,%edx
  102813:	f6 c2 40             	test   $0x40,%dl
  102816:	75 03                	jne    10281b <kbd_getc+0x3b>
  102818:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10281b:	0f b6 80 20 6b 10 00 	movzbl 0x106b20(%eax),%eax
  102822:	83 c8 40             	or     $0x40,%eax
  102825:	0f b6 c0             	movzbl %al,%eax
  102828:	f7 d0                	not    %eax
  10282a:	21 d0                	and    %edx,%eax
  10282c:	a3 bc 88 10 00       	mov    %eax,0x1088bc
  102831:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102833:	5d                   	pop    %ebp
  102834:	c3                   	ret    
  102835:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102838:	8b 0d bc 88 10 00    	mov    0x1088bc,%ecx
  10283e:	f6 c1 40             	test   $0x40,%cl
  102841:	74 05                	je     102848 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102843:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  102845:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102848:	0f b6 90 20 6b 10 00 	movzbl 0x106b20(%eax),%edx
  10284f:	09 ca                	or     %ecx,%edx
  102851:	0f b6 88 20 6c 10 00 	movzbl 0x106c20(%eax),%ecx
  102858:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  10285a:	89 d1                	mov    %edx,%ecx
  10285c:	83 e1 03             	and    $0x3,%ecx
  10285f:	8b 0c 8d 20 6d 10 00 	mov    0x106d20(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102866:	89 15 bc 88 10 00    	mov    %edx,0x1088bc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  10286c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10286f:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  102873:	74 be                	je     102833 <kbd_getc+0x53>
    if('a' <= c && c <= 'z')
  102875:	8d 50 9f             	lea    -0x61(%eax),%edx
  102878:	83 fa 19             	cmp    $0x19,%edx
  10287b:	77 1b                	ja     102898 <kbd_getc+0xb8>
      c += 'A' - 'a';
  10287d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102880:	5d                   	pop    %ebp
  102881:	c3                   	ret    
  102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  102888:	30 c0                	xor    %al,%al
  10288a:	83 0d bc 88 10 00 40 	orl    $0x40,0x1088bc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102891:	5d                   	pop    %ebp
  102892:	c3                   	ret    
  102893:	90                   	nop
  102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  102898:	8d 50 bf             	lea    -0x41(%eax),%edx
  10289b:	83 fa 19             	cmp    $0x19,%edx
  10289e:	77 93                	ja     102833 <kbd_getc+0x53>
      c += 'a' - 'A';
  1028a0:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  1028a3:	5d                   	pop    %ebp
  1028a4:	c3                   	ret    
  1028a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001028b0 <kbd_intr>:

void
kbd_intr(void)
{
  1028b0:	55                   	push   %ebp
  1028b1:	89 e5                	mov    %esp,%ebp
  1028b3:	83 ec 18             	sub    $0x18,%esp
  console_intr(kbd_getc);
  1028b6:	c7 04 24 e0 27 10 00 	movl   $0x1027e0,(%esp)
  1028bd:	e8 be dc ff ff       	call   100580 <console_intr>
}
  1028c2:	c9                   	leave  
  1028c3:	c3                   	ret    
  1028c4:	90                   	nop
  1028c5:	90                   	nop
  1028c6:	90                   	nop
  1028c7:	90                   	nop
  1028c8:	90                   	nop
  1028c9:	90                   	nop
  1028ca:	90                   	nop
  1028cb:	90                   	nop
  1028cc:	90                   	nop
  1028cd:	90                   	nop
  1028ce:	90                   	nop
  1028cf:	90                   	nop

001028d0 <lapic_init>:
}

void
lapic_init(int c)
{
  if(!lapic) 
  1028d0:	a1 18 bb 10 00       	mov    0x10bb18,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1028d5:	55                   	push   %ebp
  1028d6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1028d8:	85 c0                	test   %eax,%eax
  1028da:	0f 84 c4 00 00 00    	je     1029a4 <lapic_init+0xd4>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  1028e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1028ea:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1028f7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  102901:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  102904:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102907:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10290e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102911:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102914:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10291b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10291e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102921:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102928:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10292b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10292e:	8b 50 30             	mov    0x30(%eax),%edx
  102931:	c1 ea 10             	shr    $0x10,%edx
  102934:	80 fa 03             	cmp    $0x3,%dl
  102937:	77 6f                	ja     1029a8 <lapic_init+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102939:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  102940:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102943:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102946:	8d 88 00 03 00 00    	lea    0x300(%eax),%ecx
  10294c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102953:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102956:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102959:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102960:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102963:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102966:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10296d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102970:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102973:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  10297a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10297d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102980:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  102987:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10298a:	8b 50 20             	mov    0x20(%eax),%edx
  10298d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  102990:	8b 11                	mov    (%ecx),%edx
  102992:	80 e6 10             	and    $0x10,%dh
  102995:	75 f9                	jne    102990 <lapic_init+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102997:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  10299e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029a1:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1029a4:	5d                   	pop    %ebp
  1029a5:	c3                   	ret    
  1029a6:	66 90                	xchg   %ax,%ax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029a8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  1029af:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1029b2:	8b 50 20             	mov    0x20(%eax),%edx
  1029b5:	eb 82                	jmp    102939 <lapic_init+0x69>
  1029b7:	89 f6                	mov    %esi,%esi
  1029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001029c0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1029c0:	a1 18 bb 10 00       	mov    0x10bb18,%eax
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1029c5:	55                   	push   %ebp
  1029c6:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1029c8:	85 c0                	test   %eax,%eax
  1029ca:	74 0d                	je     1029d9 <lapic_eoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1029cc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1029d3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1029d6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  1029d9:	5d                   	pop    %ebp
  1029da:	c3                   	ret    
  1029db:	90                   	nop
  1029dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001029e0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1029e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1029e1:	ba 70 00 00 00       	mov    $0x70,%edx
  1029e6:	89 e5                	mov    %esp,%ebp
  1029e8:	b8 0f 00 00 00       	mov    $0xf,%eax
  1029ed:	57                   	push   %edi
  1029ee:	56                   	push   %esi
  1029ef:	53                   	push   %ebx
  1029f0:	83 ec 18             	sub    $0x18,%esp
  1029f3:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  1029f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1029fa:	ee                   	out    %al,(%dx)
  1029fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  102a00:	b2 71                	mov    $0x71,%dl
  102a02:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a03:	8b 15 18 bb 10 00    	mov    0x10bb18,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102a09:	89 d8                	mov    %ebx,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a0b:	89 cf                	mov    %ecx,%edi
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102a0d:	c1 e8 04             	shr    $0x4,%eax
  102a10:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a16:	c1 e7 18             	shl    $0x18,%edi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102a19:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102a20:	00 00 
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a22:	8d 82 10 03 00 00    	lea    0x310(%edx),%eax
  102a28:	89 ba 10 03 00 00    	mov    %edi,0x310(%edx)
  lapic[ID];  // wait for write to finish, by reading
  102a2e:	8d 72 20             	lea    0x20(%edx),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102a34:	8b 42 20             	mov    0x20(%edx),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a37:	8d 82 00 03 00 00    	lea    0x300(%edx),%eax
  102a3d:	c7 82 00 03 00 00 00 	movl   $0xc500,0x300(%edx)
  102a44:	c5 00 00 
  102a47:	89 45 e0             	mov    %eax,-0x20(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102a4a:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102a4d:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102a52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a59:	eb 0c                	jmp    102a67 <lapic_startap+0x87>
  102a5b:	90                   	nop
  102a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102a60:	85 c0                	test   %eax,%eax
  102a62:	74 2d                	je     102a91 <lapic_startap+0xb1>
  102a64:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a71:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102a77:	7f e7                	jg     102a60 <lapic_startap+0x80>
  102a79:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a7c:	83 c1 01             	add    $0x1,%ecx
  102a7f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  102a82:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102a85:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102a8b:	7e ec                	jle    102a79 <lapic_startap+0x99>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102a8d:	85 c0                	test   %eax,%eax
  102a8f:	75 d3                	jne    102a64 <lapic_startap+0x84>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102a91:	c7 82 00 03 00 00 00 	movl   $0x8500,0x300(%edx)
  102a98:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102a9b:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102a9e:	b8 63 00 00 00       	mov    $0x63,%eax
  102aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102aaa:	eb 0b                	jmp    102ab7 <lapic_startap+0xd7>
  102aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102ab0:	85 c0                	test   %eax,%eax
  102ab2:	74 2d                	je     102ae1 <lapic_startap+0x101>
  102ab4:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102ab7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102abe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ac1:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102ac7:	7f e7                	jg     102ab0 <lapic_startap+0xd0>
  102ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102acc:	83 c2 01             	add    $0x1,%edx
  102acf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ad2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ad5:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102adb:	7e ec                	jle    102ac9 <lapic_startap+0xe9>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102add:	85 c0                	test   %eax,%eax
  102adf:	75 d3                	jne    102ab4 <lapic_startap+0xd4>
  102ae1:	c1 eb 0c             	shr    $0xc,%ebx
  102ae4:	31 c9                	xor    %ecx,%ecx
  102ae6:	80 cf 06             	or     $0x6,%bh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102ae9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102aec:	89 38                	mov    %edi,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102aee:	8b 06                	mov    (%esi),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102af3:	89 18                	mov    %ebx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102af5:	8b 06                	mov    (%esi),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102af7:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102afc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b03:	eb 0a                	jmp    102b0f <lapic_startap+0x12f>
  102b05:	8d 76 00             	lea    0x0(%esi),%esi
  
  while(us-- > 0)
  102b08:	85 c0                	test   %eax,%eax
  102b0a:	74 34                	je     102b40 <lapic_startap+0x160>
  102b0c:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102b0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b19:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b1f:	7f e7                	jg     102b08 <lapic_startap+0x128>
  102b21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b24:	83 c2 01             	add    $0x1,%edx
  102b27:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b2d:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102b33:	7e ec                	jle    102b21 <lapic_startap+0x141>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102b35:	85 c0                	test   %eax,%eax
  102b37:	75 d3                	jne    102b0c <lapic_startap+0x12c>
  102b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Send startup IPI (twice!) to enter bootstrap code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
  102b40:	83 c1 01             	add    $0x1,%ecx
  102b43:	83 f9 02             	cmp    $0x2,%ecx
  102b46:	75 a1                	jne    102ae9 <lapic_startap+0x109>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  102b48:	83 c4 18             	add    $0x18,%esp
  102b4b:	5b                   	pop    %ebx
  102b4c:	5e                   	pop    %esi
  102b4d:	5f                   	pop    %edi
  102b4e:	5d                   	pop    %ebp
  102b4f:	c3                   	ret    

00102b50 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102b50:	55                   	push   %ebp
  102b51:	89 e5                	mov    %esp,%ebp
  102b53:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102b56:	9c                   	pushf  
  102b57:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102b58:	f6 c4 02             	test   $0x2,%ah
  102b5b:	74 12                	je     102b6f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  102b5d:	a1 c0 88 10 00       	mov    0x1088c0,%eax
  102b62:	8d 50 01             	lea    0x1(%eax),%edx
  102b65:	85 c0                	test   %eax,%eax
  102b67:	89 15 c0 88 10 00    	mov    %edx,0x1088c0
  102b6d:	74 19                	je     102b88 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  102b6f:	8b 15 18 bb 10 00    	mov    0x10bb18,%edx
  102b75:	31 c0                	xor    %eax,%eax
  102b77:	85 d2                	test   %edx,%edx
  102b79:	74 06                	je     102b81 <cpu+0x31>
    return lapic[ID]>>24;
  102b7b:	8b 42 20             	mov    0x20(%edx),%eax
  102b7e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102b81:	c9                   	leave  
  102b82:	c3                   	ret    
  102b83:	90                   	nop
  102b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  102b88:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102b8a:	8b 40 04             	mov    0x4(%eax),%eax
  102b8d:	c7 04 24 30 6d 10 00 	movl   $0x106d30,(%esp)
  102b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b98:	e8 33 dc ff ff       	call   1007d0 <cprintf>
  102b9d:	eb d0                	jmp    102b6f <cpu+0x1f>
  102b9f:	90                   	nop

00102ba0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102ba0:	55                   	push   %ebp
  102ba1:	89 e5                	mov    %esp,%ebp
  102ba3:	53                   	push   %ebx
  102ba4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102ba7:	e8 a4 ff ff ff       	call   102b50 <cpu>
  102bac:	c7 04 24 5c 6d 10 00 	movl   $0x106d5c,(%esp)
  102bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bb7:	e8 14 dc ff ff       	call   1007d0 <cprintf>
  idtinit();
  102bbc:	e8 4f 2f 00 00       	call   105b10 <idtinit>
  if(cpu() != mp_bcpu())
  102bc1:	e8 8a ff ff ff       	call   102b50 <cpu>
  102bc6:	89 c3                	mov    %eax,%ebx
  102bc8:	e8 c3 01 00 00       	call   102d90 <mp_bcpu>
  102bcd:	39 c3                	cmp    %eax,%ebx
  102bcf:	74 0d                	je     102bde <mpmain+0x3e>
    lapic_init(cpu());
  102bd1:	e8 7a ff ff ff       	call   102b50 <cpu>
  102bd6:	89 04 24             	mov    %eax,(%esp)
  102bd9:	e8 f2 fc ff ff       	call   1028d0 <lapic_init>
  setupsegs(0);
  102bde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102be5:	e8 c6 10 00 00       	call   103cb0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  102bea:	e8 61 ff ff ff       	call   102b50 <cpu>
  102bef:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  102bfa:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  102c00:	f0 87 82 40 bb 10 00 	lock xchg %eax,0x10bb40(%edx)

  cprintf("cpu%d: scheduling\n", cpu());
  102c07:	e8 44 ff ff ff       	call   102b50 <cpu>
  102c0c:	c7 04 24 6b 6d 10 00 	movl   $0x106d6b,(%esp)
  102c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c17:	e8 b4 db ff ff       	call   1007d0 <cprintf>
  scheduler();
  102c1c:	e8 6f 12 00 00       	call   103e90 <scheduler>
  102c21:	eb 0d                	jmp    102c30 <main>
  102c23:	90                   	nop
  102c24:	90                   	nop
  102c25:	90                   	nop
  102c26:	90                   	nop
  102c27:	90                   	nop
  102c28:	90                   	nop
  102c29:	90                   	nop
  102c2a:	90                   	nop
  102c2b:	90                   	nop
  102c2c:	90                   	nop
  102c2d:	90                   	nop
  102c2e:	90                   	nop
  102c2f:	90                   	nop

00102c30 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c30:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c31:	b8 44 f1 10 00       	mov    $0x10f144,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c36:	89 e5                	mov    %esp,%ebp
  102c38:	83 e4 f0             	and    $0xfffffff0,%esp
  102c3b:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c3c:	2d 0e 88 10 00       	sub    $0x10880e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102c41:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102c44:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c4f:	00 
  102c50:	c7 04 24 0e 88 10 00 	movl   $0x10880e,(%esp)
  102c57:	e8 34 1b 00 00       	call   104790 <memset>

  mp_init(); // collect info about this machine
  102c5c:	e8 bf 01 00 00       	call   102e20 <mp_init>
  lapic_init(mp_bcpu());
  102c61:	e8 2a 01 00 00       	call   102d90 <mp_bcpu>
  102c66:	89 04 24             	mov    %eax,(%esp)
  102c69:	e8 62 fc ff ff       	call   1028d0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102c6e:	e8 dd fe ff ff       	call   102b50 <cpu>
  102c73:	c7 04 24 7e 6d 10 00 	movl   $0x106d7e,(%esp)
  102c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c7e:	e8 4d db ff ff       	call   1007d0 <cprintf>

  pinit();         // process table
  102c83:	e8 b8 18 00 00       	call   104540 <pinit>
  binit();         // buffer cache
  102c88:	e8 93 d5 ff ff       	call   100220 <binit>
  102c8d:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  102c90:	e8 8b 03 00 00       	call   103020 <pic_init>
  ioapic_init();   // another interrupt controller
  102c95:	e8 76 f8 ff ff       	call   102510 <ioapic_init>
  kinit();         // physical memory allocator
  102c9a:	e8 f1 fa ff ff       	call   102790 <kinit>
  102c9f:	90                   	nop
  tvinit();        // trap vectors
  102ca0:	e8 1b 31 00 00       	call   105dc0 <tvinit>
  fileinit();      // file table
  102ca5:	e8 26 e5 ff ff       	call   1011d0 <fileinit>
  iinit();         // inode cache
  102caa:	e8 61 f5 ff ff       	call   102210 <iinit>
  102caf:	90                   	nop
  console_init();  // I/O devices & their interrupts
  102cb0:	e8 db d5 ff ff       	call   100290 <console_init>
  ide_init();      // disk
  102cb5:	e8 86 f7 ff ff       	call   102440 <ide_init>
  if(!ismp)
  102cba:	a1 20 bb 10 00       	mov    0x10bb20,%eax
  102cbf:	85 c0                	test   %eax,%eax
  102cc1:	0f 84 b1 00 00 00    	je     102d78 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102cc7:	e8 84 17 00 00       	call   104450 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102ccc:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102cd3:	00 
  102cd4:	c7 44 24 04 b4 87 10 	movl   $0x1087b4,0x4(%esp)
  102cdb:	00 
  102cdc:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102ce3:	e8 38 1b 00 00       	call   104820 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102ce8:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102cef:	00 00 00 
  102cf2:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102cf7:	3d 40 bb 10 00       	cmp    $0x10bb40,%eax
  102cfc:	76 75                	jbe    102d73 <main+0x143>
  102cfe:	bb 40 bb 10 00       	mov    $0x10bb40,%ebx
  102d03:	90                   	nop
  102d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102d08:	e8 43 fe ff ff       	call   102b50 <cpu>
  102d0d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102d13:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102d18:	39 c3                	cmp    %eax,%ebx
  102d1a:	74 3e                	je     102d5a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102d1c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102d23:	e8 98 f8 ff ff       	call   1025c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102d28:	c7 05 f8 6f 00 00 a0 	movl   $0x102ba0,0x6ff8
  102d2f:	2b 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102d32:	05 00 10 00 00       	add    $0x1000,%eax
  102d37:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102d3c:	0f b6 03             	movzbl (%ebx),%eax
  102d3f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102d46:	00 
  102d47:	89 04 24             	mov    %eax,(%esp)
  102d4a:	e8 91 fc ff ff       	call   1029e0 <lapic_startap>
  102d4f:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102d50:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102d56:	85 c0                	test   %eax,%eax
  102d58:	74 f6                	je     102d50 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102d5a:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102d61:	00 00 00 
  102d64:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102d6a:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102d6f:	39 c3                	cmp    %eax,%ebx
  102d71:	72 95                	jb     102d08 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102d73:	e8 28 fe ff ff       	call   102ba0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102d78:	e8 33 2d 00 00       	call   105ab0 <timer_init>
  102d7d:	8d 76 00             	lea    0x0(%esi),%esi
  102d80:	e9 42 ff ff ff       	jmp    102cc7 <main+0x97>
  102d85:	90                   	nop
  102d86:	90                   	nop
  102d87:	90                   	nop
  102d88:	90                   	nop
  102d89:	90                   	nop
  102d8a:	90                   	nop
  102d8b:	90                   	nop
  102d8c:	90                   	nop
  102d8d:	90                   	nop
  102d8e:	90                   	nop
  102d8f:	90                   	nop

00102d90 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102d90:	a1 c4 88 10 00       	mov    0x1088c4,%eax
  102d95:	55                   	push   %ebp
  102d96:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102d98:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102d99:	2d 40 bb 10 00       	sub    $0x10bb40,%eax
  102d9e:	c1 f8 02             	sar    $0x2,%eax
  102da1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  102da7:	c3                   	ret    
  102da8:	90                   	nop
  102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102db0 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102db0:	55                   	push   %ebp
  102db1:	89 e5                	mov    %esp,%ebp
  102db3:	56                   	push   %esi
  102db4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102db5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102db8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102dbb:	39 f0                	cmp    %esi,%eax
  102dbd:	73 42                	jae    102e01 <mp_search1+0x51>
  102dbf:	89 c3                	mov    %eax,%ebx
  102dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102dc8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102dcf:	00 
  102dd0:	c7 44 24 04 95 6d 10 	movl   $0x106d95,0x4(%esp)
  102dd7:	00 
  102dd8:	89 1c 24             	mov    %ebx,(%esp)
  102ddb:	e8 e0 19 00 00       	call   1047c0 <memcmp>
  102de0:	85 c0                	test   %eax,%eax
  102de2:	75 16                	jne    102dfa <mp_search1+0x4a>
  102de4:	31 d2                	xor    %edx,%edx
  102de6:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102de8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102dec:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102def:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102df1:	83 f8 10             	cmp    $0x10,%eax
  102df4:	75 f2                	jne    102de8 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102df6:	84 d2                	test   %dl,%dl
  102df8:	74 10                	je     102e0a <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102dfa:	83 c3 10             	add    $0x10,%ebx
  102dfd:	39 de                	cmp    %ebx,%esi
  102dff:	77 c7                	ja     102dc8 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102e01:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102e04:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102e06:	5b                   	pop    %ebx
  102e07:	5e                   	pop    %esi
  102e08:	5d                   	pop    %ebp
  102e09:	c3                   	ret    
  102e0a:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102e0d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102e0f:	5b                   	pop    %ebx
  102e10:	5e                   	pop    %esi
  102e11:	5d                   	pop    %ebp
  102e12:	c3                   	ret    
  102e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102e20 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102e20:	55                   	push   %ebp
  102e21:	89 e5                	mov    %esp,%ebp
  102e23:	57                   	push   %edi
  102e24:	56                   	push   %esi
  102e25:	53                   	push   %ebx
  102e26:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102e29:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102e30:	69 05 a0 c1 10 00 cc 	imul   $0xcc,0x10c1a0,%eax
  102e37:	00 00 00 
  102e3a:	05 40 bb 10 00       	add    $0x10bb40,%eax
  102e3f:	a3 c4 88 10 00       	mov    %eax,0x1088c4
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102e44:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102e4b:	c1 e0 08             	shl    $0x8,%eax
  102e4e:	09 d0                	or     %edx,%eax
  102e50:	c1 e0 04             	shl    $0x4,%eax
  102e53:	85 c0                	test   %eax,%eax
  102e55:	75 1b                	jne    102e72 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102e57:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102e5e:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102e65:	c1 e0 08             	shl    $0x8,%eax
  102e68:	09 d0                	or     %edx,%eax
  102e6a:	c1 e0 0a             	shl    $0xa,%eax
  102e6d:	2d 00 04 00 00       	sub    $0x400,%eax
  102e72:	ba 00 04 00 00       	mov    $0x400,%edx
  102e77:	e8 34 ff ff ff       	call   102db0 <mp_search1>
  102e7c:	85 c0                	test   %eax,%eax
  102e7e:	89 c3                	mov    %eax,%ebx
  102e80:	0f 84 b2 00 00 00    	je     102f38 <mp_init+0x118>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102e86:	8b 73 04             	mov    0x4(%ebx),%esi
  102e89:	85 f6                	test   %esi,%esi
  102e8b:	75 0b                	jne    102e98 <mp_init+0x78>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102e8d:	83 c4 2c             	add    $0x2c,%esp
  102e90:	5b                   	pop    %ebx
  102e91:	5e                   	pop    %esi
  102e92:	5f                   	pop    %edi
  102e93:	5d                   	pop    %ebp
  102e94:	c3                   	ret    
  102e95:	8d 76 00             	lea    0x0(%esi),%esi
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102e98:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102e9f:	00 
  102ea0:	c7 44 24 04 9a 6d 10 	movl   $0x106d9a,0x4(%esp)
  102ea7:	00 
  102ea8:	89 34 24             	mov    %esi,(%esp)
  102eab:	e8 10 19 00 00       	call   1047c0 <memcmp>
  102eb0:	85 c0                	test   %eax,%eax
  102eb2:	75 d9                	jne    102e8d <mp_init+0x6d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102eb4:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  102eb8:	3c 04                	cmp    $0x4,%al
  102eba:	74 06                	je     102ec2 <mp_init+0xa2>
  102ebc:	3c 01                	cmp    $0x1,%al
  102ebe:	66 90                	xchg   %ax,%ax
  102ec0:	75 cb                	jne    102e8d <mp_init+0x6d>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102ec2:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ec6:	85 d2                	test   %edx,%edx
  102ec8:	74 15                	je     102edf <mp_init+0xbf>
  102eca:	31 c9                	xor    %ecx,%ecx
  102ecc:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  102ece:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ed2:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102ed5:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ed7:	39 c2                	cmp    %eax,%edx
  102ed9:	7f f3                	jg     102ece <mp_init+0xae>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102edb:	84 c9                	test   %cl,%cl
  102edd:	75 ae                	jne    102e8d <mp_init+0x6d>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102edf:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102ee2:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102ee5:	c7 05 20 bb 10 00 01 	movl   $0x1,0x10bb20
  102eec:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102eef:	a3 18 bb 10 00       	mov    %eax,0x10bb18

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102ef4:	8d 46 2c             	lea    0x2c(%esi),%eax
  102ef7:	39 d0                	cmp    %edx,%eax
  102ef9:	0f 83 81 00 00 00    	jae    102f80 <mp_init+0x160>
  102eff:	8b 35 c4 88 10 00    	mov    0x1088c4,%esi
  102f05:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  102f08:	0f b6 08             	movzbl (%eax),%ecx
  102f0b:	80 f9 04             	cmp    $0x4,%cl
  102f0e:	76 50                	jbe    102f60 <mp_init+0x140>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102f10:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102f13:	89 35 c4 88 10 00    	mov    %esi,0x1088c4
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102f19:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102f1d:	c7 04 24 a8 6d 10 00 	movl   $0x106da8,(%esp)
  102f24:	e8 a7 d8 ff ff       	call   1007d0 <cprintf>
      panic("mp_init");
  102f29:	c7 04 24 9f 6d 10 00 	movl   $0x106d9f,(%esp)
  102f30:	e8 3b da ff ff       	call   100970 <panic>
  102f35:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102f38:	ba 00 00 01 00       	mov    $0x10000,%edx
  102f3d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102f42:	e8 69 fe ff ff       	call   102db0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102f47:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102f49:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102f4b:	0f 85 35 ff ff ff    	jne    102e86 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102f51:	83 c4 2c             	add    $0x2c,%esp
  102f54:	5b                   	pop    %ebx
  102f55:	5e                   	pop    %esi
  102f56:	5f                   	pop    %edi
  102f57:	5d                   	pop    %ebp
  102f58:	c3                   	ret    
  102f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102f60:	0f b6 c9             	movzbl %cl,%ecx
  102f63:	ff 24 8d cc 6d 10 00 	jmp    *0x106dcc(,%ecx,4)
  102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102f70:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102f73:	39 c2                	cmp    %eax,%edx
  102f75:	77 91                	ja     102f08 <mp_init+0xe8>
  102f77:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  102f7a:	89 35 c4 88 10 00    	mov    %esi,0x1088c4
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102f80:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  102f84:	0f 84 03 ff ff ff    	je     102e8d <mp_init+0x6d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102f8a:	ba 22 00 00 00       	mov    $0x22,%edx
  102f8f:	b8 70 00 00 00       	mov    $0x70,%eax
  102f94:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102f95:	b2 23                	mov    $0x23,%dl
  102f97:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102f98:	83 c8 01             	or     $0x1,%eax
  102f9b:	ee                   	out    %al,(%dx)
  102f9c:	e9 ec fe ff ff       	jmp    102e8d <mp_init+0x6d>
  102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102fa8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  102fac:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102faf:	88 0d 24 bb 10 00    	mov    %cl,0x10bb24
      p += sizeof(struct mpioapic);
      continue;
  102fb5:	eb bc                	jmp    102f73 <mp_init+0x153>
  102fb7:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102fb8:	8b 0d a0 c1 10 00    	mov    0x10c1a0,%ecx
  102fbe:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102fc2:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  102fc8:	88 9f 40 bb 10 00    	mov    %bl,0x10bb40(%edi)
      if(proc->flags & MPBOOT)
  102fce:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102fd2:	74 06                	je     102fda <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  102fd4:	8d b7 40 bb 10 00    	lea    0x10bb40(%edi),%esi
      ncpu++;
  102fda:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  102fdd:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102fe0:	89 0d a0 c1 10 00    	mov    %ecx,0x10c1a0
      p += sizeof(struct mpproc);
      continue;
  102fe6:	eb 8b                	jmp    102f73 <mp_init+0x153>
  102fe8:	90                   	nop
  102fe9:	90                   	nop
  102fea:	90                   	nop
  102feb:	90                   	nop
  102fec:	90                   	nop
  102fed:	90                   	nop
  102fee:	90                   	nop
  102fef:	90                   	nop

00102ff0 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102ff0:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102ff1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102ff6:	89 e5                	mov    %esp,%ebp
  102ff8:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  102ffd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  103000:	d3 c0                	rol    %cl,%eax
  103002:	66 23 05 80 83 10 00 	and    0x108380,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  103009:	66 a3 80 83 10 00    	mov    %ax,0x108380
  10300f:	ee                   	out    %al,(%dx)
  103010:	66 c1 e8 08          	shr    $0x8,%ax
  103014:	b2 a1                	mov    $0xa1,%dl
  103016:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  103017:	5d                   	pop    %ebp
  103018:	c3                   	ret    
  103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103020 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  103020:	55                   	push   %ebp
  103021:	b9 21 00 00 00       	mov    $0x21,%ecx
  103026:	89 e5                	mov    %esp,%ebp
  103028:	83 ec 0c             	sub    $0xc,%esp
  10302b:	89 1c 24             	mov    %ebx,(%esp)
  10302e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103033:	89 ca                	mov    %ecx,%edx
  103035:	89 74 24 04          	mov    %esi,0x4(%esp)
  103039:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10303d:	ee                   	out    %al,(%dx)
  10303e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  103043:	89 da                	mov    %ebx,%edx
  103045:	ee                   	out    %al,(%dx)
  103046:	be 11 00 00 00       	mov    $0x11,%esi
  10304b:	b2 20                	mov    $0x20,%dl
  10304d:	89 f0                	mov    %esi,%eax
  10304f:	ee                   	out    %al,(%dx)
  103050:	b8 20 00 00 00       	mov    $0x20,%eax
  103055:	89 ca                	mov    %ecx,%edx
  103057:	ee                   	out    %al,(%dx)
  103058:	b8 04 00 00 00       	mov    $0x4,%eax
  10305d:	ee                   	out    %al,(%dx)
  10305e:	bf 03 00 00 00       	mov    $0x3,%edi
  103063:	89 f8                	mov    %edi,%eax
  103065:	ee                   	out    %al,(%dx)
  103066:	b1 a0                	mov    $0xa0,%cl
  103068:	89 f0                	mov    %esi,%eax
  10306a:	89 ca                	mov    %ecx,%edx
  10306c:	ee                   	out    %al,(%dx)
  10306d:	b8 28 00 00 00       	mov    $0x28,%eax
  103072:	89 da                	mov    %ebx,%edx
  103074:	ee                   	out    %al,(%dx)
  103075:	b8 02 00 00 00       	mov    $0x2,%eax
  10307a:	ee                   	out    %al,(%dx)
  10307b:	89 f8                	mov    %edi,%eax
  10307d:	ee                   	out    %al,(%dx)
  10307e:	be 68 00 00 00       	mov    $0x68,%esi
  103083:	b2 20                	mov    $0x20,%dl
  103085:	89 f0                	mov    %esi,%eax
  103087:	ee                   	out    %al,(%dx)
  103088:	bb 0a 00 00 00       	mov    $0xa,%ebx
  10308d:	89 d8                	mov    %ebx,%eax
  10308f:	ee                   	out    %al,(%dx)
  103090:	89 f0                	mov    %esi,%eax
  103092:	89 ca                	mov    %ecx,%edx
  103094:	ee                   	out    %al,(%dx)
  103095:	89 d8                	mov    %ebx,%eax
  103097:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  103098:	0f b7 05 80 83 10 00 	movzwl 0x108380,%eax
  10309f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  1030a3:	74 0a                	je     1030af <pic_init+0x8f>
  1030a5:	b2 21                	mov    $0x21,%dl
  1030a7:	ee                   	out    %al,(%dx)
  1030a8:	66 c1 e8 08          	shr    $0x8,%ax
  1030ac:	b2 a1                	mov    $0xa1,%dl
  1030ae:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  1030af:	8b 1c 24             	mov    (%esp),%ebx
  1030b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  1030b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1030ba:	89 ec                	mov    %ebp,%esp
  1030bc:	5d                   	pop    %ebp
  1030bd:	c3                   	ret    
  1030be:	90                   	nop
  1030bf:	90                   	nop

001030c0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  1030c0:	55                   	push   %ebp
  1030c1:	89 e5                	mov    %esp,%ebp
  1030c3:	57                   	push   %edi
  1030c4:	56                   	push   %esi
  1030c5:	53                   	push   %ebx
  1030c6:	83 ec 2c             	sub    $0x2c,%esp
  1030c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1030cc:	8d 73 10             	lea    0x10(%ebx),%esi
  1030cf:	89 34 24             	mov    %esi,(%esp)
  1030d2:	e8 49 16 00 00       	call   104720 <acquire>
  while(p->readp == p->writep && p->writeopen){
  1030d7:	8b 53 0c             	mov    0xc(%ebx),%edx
  1030da:	3b 53 08             	cmp    0x8(%ebx),%edx
  1030dd:	75 51                	jne    103130 <piperead+0x70>
  1030df:	8b 4b 04             	mov    0x4(%ebx),%ecx
  1030e2:	85 c9                	test   %ecx,%ecx
  1030e4:	74 4a                	je     103130 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  1030e6:	8d 7b 0c             	lea    0xc(%ebx),%edi
  1030e9:	eb 20                	jmp    10310b <piperead+0x4b>
  1030eb:	90                   	nop
  1030ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1030f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  1030f4:	89 3c 24             	mov    %edi,(%esp)
  1030f7:	e8 94 08 00 00       	call   103990 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  1030fc:	8b 53 0c             	mov    0xc(%ebx),%edx
  1030ff:	3b 53 08             	cmp    0x8(%ebx),%edx
  103102:	75 2c                	jne    103130 <piperead+0x70>
  103104:	8b 43 04             	mov    0x4(%ebx),%eax
  103107:	85 c0                	test   %eax,%eax
  103109:	74 25                	je     103130 <piperead+0x70>
    if(cp->killed){
  10310b:	e8 d0 05 00 00       	call   1036e0 <curproc>
  103110:	8b 40 1c             	mov    0x1c(%eax),%eax
  103113:	85 c0                	test   %eax,%eax
  103115:	74 d9                	je     1030f0 <piperead+0x30>
      release(&p->lock);
  103117:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  10311c:	89 34 24             	mov    %esi,(%esp)
  10311f:	e8 bc 15 00 00       	call   1046e0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  103124:	83 c4 2c             	add    $0x2c,%esp
  103127:	89 f8                	mov    %edi,%eax
  103129:	5b                   	pop    %ebx
  10312a:	5e                   	pop    %esi
  10312b:	5f                   	pop    %edi
  10312c:	5d                   	pop    %ebp
  10312d:	c3                   	ret    
  10312e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103130:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103133:	85 c9                	test   %ecx,%ecx
  103135:	7e 5a                	jle    103191 <piperead+0xd1>
    if(p->readp == p->writep)
  103137:	31 ff                	xor    %edi,%edi
  103139:	3b 53 08             	cmp    0x8(%ebx),%edx
  10313c:	74 53                	je     103191 <piperead+0xd1>
  10313e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  103141:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  103144:	8b 75 10             	mov    0x10(%ebp),%esi
  103147:	eb 0c                	jmp    103155 <piperead+0x95>
  103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103150:	39 53 08             	cmp    %edx,0x8(%ebx)
  103153:	74 1c                	je     103171 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103155:	89 d0                	mov    %edx,%eax
  103157:	83 c2 01             	add    $0x1,%edx
  10315a:	25 ff 01 00 00       	and    $0x1ff,%eax
  10315f:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  103164:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103167:	83 c7 01             	add    $0x1,%edi
  10316a:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  10316c:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10316f:	7f df                	jg     103150 <piperead+0x90>
  103171:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  103174:	83 c3 08             	add    $0x8,%ebx
  103177:	89 1c 24             	mov    %ebx,(%esp)
  10317a:	e8 61 04 00 00       	call   1035e0 <wakeup>
  release(&p->lock);
  10317f:	89 34 24             	mov    %esi,(%esp)
  103182:	e8 59 15 00 00       	call   1046e0 <release>
  return i;
}
  103187:	83 c4 2c             	add    $0x2c,%esp
  10318a:	89 f8                	mov    %edi,%eax
  10318c:	5b                   	pop    %ebx
  10318d:	5e                   	pop    %esi
  10318e:	5f                   	pop    %edi
  10318f:	5d                   	pop    %ebp
  103190:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103191:	31 ff                	xor    %edi,%edi
  103193:	eb df                	jmp    103174 <piperead+0xb4>
  103195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001031a0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  1031a0:	55                   	push   %ebp
  1031a1:	89 e5                	mov    %esp,%ebp
  1031a3:	57                   	push   %edi
  1031a4:	56                   	push   %esi
  1031a5:	53                   	push   %ebx
  1031a6:	83 ec 3c             	sub    $0x3c,%esp
  1031a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1031ac:	8d 73 10             	lea    0x10(%ebx),%esi
  1031af:	89 34 24             	mov    %esi,(%esp)
  1031b2:	e8 69 15 00 00       	call   104720 <acquire>
  for(i = 0; i < n; i++){
  1031b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1031ba:	85 c9                	test   %ecx,%ecx
  1031bc:	0f 8e d0 00 00 00    	jle    103292 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  1031c2:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1031c5:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  1031c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1031cb:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1031ce:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  1031d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1031d8:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1031db:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  1031e1:	39 c8                	cmp    %ecx,%eax
  1031e3:	75 66                	jne    10324b <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  1031e5:	8b 3b                	mov    (%ebx),%edi
  1031e7:	85 ff                	test   %edi,%edi
  1031e9:	74 3e                	je     103229 <pipewrite+0x89>
  1031eb:	8b 7d d0             	mov    -0x30(%ebp),%edi
  1031ee:	eb 2d                	jmp    10321d <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1031f0:	89 3c 24             	mov    %edi,(%esp)
  1031f3:	e8 e8 03 00 00       	call   1035e0 <wakeup>
      sleep(&p->writep, &p->lock);
  1031f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1031fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  1031ff:	89 0c 24             	mov    %ecx,(%esp)
  103202:	e8 89 07 00 00       	call   103990 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  103207:	8b 53 0c             	mov    0xc(%ebx),%edx
  10320a:	8b 43 08             	mov    0x8(%ebx),%eax
  10320d:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103213:	39 c8                	cmp    %ecx,%eax
  103215:	75 31                	jne    103248 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  103217:	8b 13                	mov    (%ebx),%edx
  103219:	85 d2                	test   %edx,%edx
  10321b:	74 0c                	je     103229 <pipewrite+0x89>
  10321d:	e8 be 04 00 00       	call   1036e0 <curproc>
  103222:	8b 40 1c             	mov    0x1c(%eax),%eax
  103225:	85 c0                	test   %eax,%eax
  103227:	74 c7                	je     1031f0 <pipewrite+0x50>
        release(&p->lock);
  103229:	89 34 24             	mov    %esi,(%esp)
  10322c:	e8 af 14 00 00       	call   1046e0 <release>
  103231:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  103238:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10323b:	83 c4 3c             	add    $0x3c,%esp
  10323e:	5b                   	pop    %ebx
  10323f:	5e                   	pop    %esi
  103240:	5f                   	pop    %edi
  103241:	5d                   	pop    %ebp
  103242:	c3                   	ret    
  103243:	90                   	nop
  103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103248:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10324b:	89 c7                	mov    %eax,%edi
  10324d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103250:	83 c0 01             	add    $0x1,%eax
  103253:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  103259:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  10325c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10325f:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  103263:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103266:	89 43 08             	mov    %eax,0x8(%ebx)
  103269:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10326d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  103271:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103274:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  103277:	0f 8f 5e ff ff ff    	jg     1031db <pipewrite+0x3b>
  10327d:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103280:	89 3c 24             	mov    %edi,(%esp)
  103283:	e8 58 03 00 00       	call   1035e0 <wakeup>
  release(&p->lock);
  103288:	89 34 24             	mov    %esi,(%esp)
  10328b:	e8 50 14 00 00       	call   1046e0 <release>
  return i;
  103290:	eb a6                	jmp    103238 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  103292:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103299:	8d 7b 0c             	lea    0xc(%ebx),%edi
  10329c:	eb e2                	jmp    103280 <pipewrite+0xe0>
  10329e:	66 90                	xchg   %ax,%ax

001032a0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  1032a0:	55                   	push   %ebp
  1032a1:	89 e5                	mov    %esp,%ebp
  1032a3:	83 ec 28             	sub    $0x28,%esp
  1032a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1032a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1032ac:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1032af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1032b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  1032b5:	8d 73 10             	lea    0x10(%ebx),%esi
  1032b8:	89 34 24             	mov    %esi,(%esp)
  1032bb:	e8 60 14 00 00       	call   104720 <acquire>
  if(writable){
  1032c0:	85 ff                	test   %edi,%edi
  1032c2:	74 34                	je     1032f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  1032c4:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  1032c7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  1032ce:	89 04 24             	mov    %eax,(%esp)
  1032d1:	e8 0a 03 00 00       	call   1035e0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1032d6:	89 34 24             	mov    %esi,(%esp)
  1032d9:	e8 02 14 00 00       	call   1046e0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1032de:	8b 3b                	mov    (%ebx),%edi
  1032e0:	85 ff                	test   %edi,%edi
  1032e2:	75 07                	jne    1032eb <pipeclose+0x4b>
  1032e4:	8b 73 04             	mov    0x4(%ebx),%esi
  1032e7:	85 f6                	test   %esi,%esi
  1032e9:	74 25                	je     103310 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1032eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1032ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1032f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1032f4:	89 ec                	mov    %ebp,%esp
  1032f6:	5d                   	pop    %ebp
  1032f7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  1032f8:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  1032fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  103301:	89 04 24             	mov    %eax,(%esp)
  103304:	e8 d7 02 00 00       	call   1035e0 <wakeup>
  103309:	eb cb                	jmp    1032d6 <pipeclose+0x36>
  10330b:	90                   	nop
  10330c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103310:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  103313:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103316:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10331d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103320:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103323:	89 ec                	mov    %ebp,%esp
  103325:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103326:	e9 55 f3 ff ff       	jmp    102680 <kfree>
  10332b:	90                   	nop
  10332c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103330 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103330:	55                   	push   %ebp
  103331:	89 e5                	mov    %esp,%ebp
  103333:	57                   	push   %edi
  103334:	56                   	push   %esi
  103335:	53                   	push   %ebx
  103336:	83 ec 1c             	sub    $0x1c,%esp
  103339:	8b 75 08             	mov    0x8(%ebp),%esi
  10333c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  10333f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  103345:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  10334b:	e8 10 dd ff ff       	call   101060 <filealloc>
  103350:	85 c0                	test   %eax,%eax
  103352:	89 06                	mov    %eax,(%esi)
  103354:	0f 84 92 00 00 00    	je     1033ec <pipealloc+0xbc>
  10335a:	e8 01 dd ff ff       	call   101060 <filealloc>
  10335f:	85 c0                	test   %eax,%eax
  103361:	89 03                	mov    %eax,(%ebx)
  103363:	74 73                	je     1033d8 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  103365:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  10336c:	e8 4f f2 ff ff       	call   1025c0 <kalloc>
  103371:	85 c0                	test   %eax,%eax
  103373:	89 c7                	mov    %eax,%edi
  103375:	74 61                	je     1033d8 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  103377:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  10337d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  103384:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  10338b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  103392:	8d 40 10             	lea    0x10(%eax),%eax
  103395:	89 04 24             	mov    %eax,(%esp)
  103398:	c7 44 24 04 e0 6d 10 	movl   $0x106de0,0x4(%esp)
  10339f:	00 
  1033a0:	e8 bb 11 00 00       	call   104560 <initlock>
  (*f0)->type = FD_PIPE;
  1033a5:	8b 06                	mov    (%esi),%eax
  1033a7:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  1033ad:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  1033b1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1033b5:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1033b8:	8b 03                	mov    (%ebx),%eax
  1033ba:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  1033c0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  1033c4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1033c8:	89 78 0c             	mov    %edi,0xc(%eax)
  1033cb:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  1033cd:	83 c4 1c             	add    $0x1c,%esp
  1033d0:	5b                   	pop    %ebx
  1033d1:	5e                   	pop    %esi
  1033d2:	5f                   	pop    %edi
  1033d3:	5d                   	pop    %ebp
  1033d4:	c3                   	ret    
  1033d5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1033d8:	8b 06                	mov    (%esi),%eax
  1033da:	85 c0                	test   %eax,%eax
  1033dc:	74 0e                	je     1033ec <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  1033de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1033e4:	89 04 24             	mov    %eax,(%esp)
  1033e7:	e8 04 dd ff ff       	call   1010f0 <fileclose>
  }
  if(*f1){
  1033ec:	8b 13                	mov    (%ebx),%edx
  1033ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1033f3:	85 d2                	test   %edx,%edx
  1033f5:	74 d6                	je     1033cd <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  1033f7:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  1033fd:	89 14 24             	mov    %edx,(%esp)
  103400:	e8 eb dc ff ff       	call   1010f0 <fileclose>
  103405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10340a:	eb c1                	jmp    1033cd <pipealloc+0x9d>
  10340c:	90                   	nop
  10340d:	90                   	nop
  10340e:	90                   	nop
  10340f:	90                   	nop

00103410 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103410:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103411:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103416:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103418:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  10341d:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103420:	76 3e                	jbe    103460 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  103422:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103427:	eb 13                	jmp    10343c <wake_lock+0x2c>
  103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103430:	05 9c 00 00 00       	add    $0x9c,%eax
  103435:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10343a:	74 24                	je     103460 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  10343c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103440:	75 ee                	jne    103430 <wake_lock+0x20>
  103442:	39 50 10             	cmp    %edx,0x10(%eax)
  103445:	75 e9                	jne    103430 <wake_lock+0x20>
			p->state = RUNNABLE;
  103447:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10344e:	05 9c 00 00 00       	add    $0x9c,%eax
  103453:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  103458:	75 e2                	jne    10343c <wake_lock+0x2c>
  10345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  103460:	5d                   	pop    %ebp
  103461:	c3                   	ret    
  103462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103470 <tick>:
  }
}

int
tick(void)
{
  103470:	55                   	push   %ebp
return ticks;
}
  103471:	a1 40 f1 10 00       	mov    0x10f140,%eax
  }
}

int
tick(void)
{
  103476:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103478:	5d                   	pop    %ebp
  103479:	c3                   	ret    
  10347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103480 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103480:	55                   	push   %ebp
  103481:	89 e5                	mov    %esp,%ebp
  103483:	57                   	push   %edi
  103484:	56                   	push   %esi
  103485:	53                   	push   %ebx
  103486:	bb cc c1 10 00       	mov    $0x10c1cc,%ebx
  10348b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10348e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103491:	eb 50                	jmp    1034e3 <procdump+0x63>
  103493:	90                   	nop
  103494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103498:	8b 04 85 a8 6e 10 00 	mov    0x106ea8(,%eax,4),%eax
  10349f:	85 c0                	test   %eax,%eax
  1034a1:	74 4e                	je     1034f1 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  1034a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034a7:	8b 43 04             	mov    0x4(%ebx),%eax
  1034aa:	81 c2 88 00 00 00    	add    $0x88,%edx
  1034b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1034b4:	c7 04 24 e9 6d 10 00 	movl   $0x106de9,(%esp)
  1034bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034bf:	e8 0c d3 ff ff       	call   1007d0 <cprintf>
    if(p->state == SLEEPING){
  1034c4:	83 3b 02             	cmpl   $0x2,(%ebx)
  1034c7:	74 2f                	je     1034f8 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1034c9:	c7 04 24 93 6d 10 00 	movl   $0x106d93,(%esp)
  1034d0:	e8 fb d2 ff ff       	call   1007d0 <cprintf>
  1034d5:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1034db:	81 fb cc e8 10 00    	cmp    $0x10e8cc,%ebx
  1034e1:	74 55                	je     103538 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  1034e3:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  1034e5:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1034e8:	85 c0                	test   %eax,%eax
  1034ea:	74 e9                	je     1034d5 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1034ec:	83 f8 05             	cmp    $0x5,%eax
  1034ef:	76 a7                	jbe    103498 <procdump+0x18>
  1034f1:	b8 e5 6d 10 00       	mov    $0x106de5,%eax
  1034f6:	eb ab                	jmp    1034a3 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1034f8:	8b 43 74             	mov    0x74(%ebx),%eax
  1034fb:	31 f6                	xor    %esi,%esi
  1034fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103501:	83 c0 08             	add    $0x8,%eax
  103504:	89 04 24             	mov    %eax,(%esp)
  103507:	e8 74 10 00 00       	call   104580 <getcallerpcs>
  10350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103510:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103513:	85 c0                	test   %eax,%eax
  103515:	74 b2                	je     1034c9 <procdump+0x49>
  103517:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  10351a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351e:	c7 04 24 1c 69 10 00 	movl   $0x10691c,(%esp)
  103525:	e8 a6 d2 ff ff       	call   1007d0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10352a:	83 fe 0a             	cmp    $0xa,%esi
  10352d:	75 e1                	jne    103510 <procdump+0x90>
  10352f:	eb 98                	jmp    1034c9 <procdump+0x49>
  103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103538:	83 c4 4c             	add    $0x4c,%esp
  10353b:	5b                   	pop    %ebx
  10353c:	5e                   	pop    %esi
  10353d:	5f                   	pop    %edi
  10353e:	5d                   	pop    %ebp
  10353f:	90                   	nop
  103540:	c3                   	ret    
  103541:	eb 0d                	jmp    103550 <kill>
  103543:	90                   	nop
  103544:	90                   	nop
  103545:	90                   	nop
  103546:	90                   	nop
  103547:	90                   	nop
  103548:	90                   	nop
  103549:	90                   	nop
  10354a:	90                   	nop
  10354b:	90                   	nop
  10354c:	90                   	nop
  10354d:	90                   	nop
  10354e:	90                   	nop
  10354f:	90                   	nop

00103550 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103550:	55                   	push   %ebp
  103551:	89 e5                	mov    %esp,%ebp
  103553:	53                   	push   %ebx
  103554:	83 ec 14             	sub    $0x14,%esp
  103557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10355a:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103561:	e8 ba 11 00 00       	call   104720 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103566:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  10356b:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  103570:	76 56                	jbe    1035c8 <kill+0x78>
    if(p->pid == pid){
  103572:	39 1d d0 c1 10 00    	cmp    %ebx,0x10c1d0

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103578:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10357d:	74 12                	je     103591 <kill+0x41>
  10357f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  103580:	05 9c 00 00 00       	add    $0x9c,%eax
  103585:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10358a:	74 3c                	je     1035c8 <kill+0x78>
    if(p->pid == pid){
  10358c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10358f:	75 ef                	jne    103580 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103591:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103595:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10359c:	74 1a                	je     1035b8 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10359e:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1035a5:	e8 36 11 00 00       	call   1046e0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1035aa:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1035ad:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1035af:	5b                   	pop    %ebx
  1035b0:	5d                   	pop    %ebp
  1035b1:	c3                   	ret    
  1035b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1035b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1035bf:	eb dd                	jmp    10359e <kill+0x4e>
  1035c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1035c8:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1035cf:	e8 0c 11 00 00       	call   1046e0 <release>
  return -1;
}
  1035d4:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1035d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1035dc:	5b                   	pop    %ebx
  1035dd:	5d                   	pop    %ebp
  1035de:	c3                   	ret    
  1035df:	90                   	nop

001035e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1035e0:	55                   	push   %ebp
  1035e1:	89 e5                	mov    %esp,%ebp
  1035e3:	53                   	push   %ebx
  1035e4:	83 ec 14             	sub    $0x14,%esp
  1035e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1035ea:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1035f1:	e8 2a 11 00 00       	call   104720 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035f6:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  1035fb:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  103600:	76 3e                	jbe    103640 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  103602:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103607:	eb 13                	jmp    10361c <wakeup+0x3c>
  103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103610:	05 9c 00 00 00       	add    $0x9c,%eax
  103615:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10361a:	74 24                	je     103640 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  10361c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103620:	75 ee                	jne    103610 <wakeup+0x30>
  103622:	3b 58 18             	cmp    0x18(%eax),%ebx
  103625:	75 e9                	jne    103610 <wakeup+0x30>
      p->state = RUNNABLE;
  103627:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10362e:	05 9c 00 00 00       	add    $0x9c,%eax
  103633:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  103638:	75 e2                	jne    10361c <wakeup+0x3c>
  10363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103640:	c7 45 08 c0 e8 10 00 	movl   $0x10e8c0,0x8(%ebp)
}
  103647:	83 c4 14             	add    $0x14,%esp
  10364a:	5b                   	pop    %ebx
  10364b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  10364c:	e9 8f 10 00 00       	jmp    1046e0 <release>
  103651:	eb 0d                	jmp    103660 <allocproc>
  103653:	90                   	nop
  103654:	90                   	nop
  103655:	90                   	nop
  103656:	90                   	nop
  103657:	90                   	nop
  103658:	90                   	nop
  103659:	90                   	nop
  10365a:	90                   	nop
  10365b:	90                   	nop
  10365c:	90                   	nop
  10365d:	90                   	nop
  10365e:	90                   	nop
  10365f:	90                   	nop

00103660 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103660:	55                   	push   %ebp
  103661:	89 e5                	mov    %esp,%ebp
  103663:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103664:	bb c0 c1 10 00       	mov    $0x10c1c0,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103669:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10366c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103673:	e8 a8 10 00 00       	call   104720 <acquire>
  103678:	eb 14                	jmp    10368e <allocproc+0x2e>
  10367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103680:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103686:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  10368c:	74 32                	je     1036c0 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10368e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103691:	85 c0                	test   %eax,%eax
  103693:	75 eb                	jne    103680 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103695:	a1 84 83 10 00       	mov    0x108384,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10369a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  1036a1:	89 43 10             	mov    %eax,0x10(%ebx)
  1036a4:	83 c0 01             	add    $0x1,%eax
  1036a7:	a3 84 83 10 00       	mov    %eax,0x108384
      release(&proc_table_lock);
  1036ac:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1036b3:	e8 28 10 00 00       	call   1046e0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  1036b8:	89 d8                	mov    %ebx,%eax
  1036ba:	83 c4 14             	add    $0x14,%esp
  1036bd:	5b                   	pop    %ebx
  1036be:	5d                   	pop    %ebp
  1036bf:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  1036c0:	31 db                	xor    %ebx,%ebx
  1036c2:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1036c9:	e8 12 10 00 00       	call   1046e0 <release>
  return 0;
}
  1036ce:	89 d8                	mov    %ebx,%eax
  1036d0:	83 c4 14             	add    $0x14,%esp
  1036d3:	5b                   	pop    %ebx
  1036d4:	5d                   	pop    %ebp
  1036d5:	c3                   	ret    
  1036d6:	8d 76 00             	lea    0x0(%esi),%esi
  1036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001036e0 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  1036e0:	55                   	push   %ebp
  1036e1:	89 e5                	mov    %esp,%ebp
  1036e3:	53                   	push   %ebx
  1036e4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  1036e7:	e8 64 0f 00 00       	call   104650 <pushcli>
  p = cpus[cpu()].curproc;
  1036ec:	e8 5f f4 ff ff       	call   102b50 <cpu>
  1036f1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1036f7:	8b 98 44 bb 10 00    	mov    0x10bb44(%eax),%ebx
  popcli();
  1036fd:	e8 ce 0e 00 00       	call   1045d0 <popcli>
  return p;
}
  103702:	83 c4 04             	add    $0x4,%esp
  103705:	89 d8                	mov    %ebx,%eax
  103707:	5b                   	pop    %ebx
  103708:	5d                   	pop    %ebp
  103709:	c3                   	ret    
  10370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103710 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103710:	55                   	push   %ebp
  103711:	89 e5                	mov    %esp,%ebp
  103713:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103716:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  10371d:	e8 be 0f 00 00       	call   1046e0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103722:	e8 b9 ff ff ff       	call   1036e0 <curproc>
  103727:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10372d:	89 04 24             	mov    %eax,(%esp)
  103730:	e8 c7 23 00 00       	call   105afc <forkret1>
}
  103735:	c9                   	leave  
  103736:	c3                   	ret    
  103737:	89 f6                	mov    %esi,%esi
  103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103740 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103740:	55                   	push   %ebp
  103741:	89 e5                	mov    %esp,%ebp
  103743:	53                   	push   %ebx
  103744:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103747:	9c                   	pushf  
  103748:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103749:	f6 c4 02             	test   $0x2,%ah
  10374c:	75 5c                	jne    1037aa <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10374e:	e8 8d ff ff ff       	call   1036e0 <curproc>
  103753:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103757:	74 75                	je     1037ce <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103759:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103760:	e8 3b 0f 00 00       	call   1046a0 <holding>
  103765:	85 c0                	test   %eax,%eax
  103767:	74 59                	je     1037c2 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103769:	e8 e2 f3 ff ff       	call   102b50 <cpu>
  10376e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103774:	83 b8 04 bc 10 00 01 	cmpl   $0x1,0x10bc04(%eax)
  10377b:	75 39                	jne    1037b6 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10377d:	e8 ce f3 ff ff       	call   102b50 <cpu>
  103782:	89 c3                	mov    %eax,%ebx
  103784:	e8 57 ff ff ff       	call   1036e0 <curproc>
  103789:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10378f:	81 c3 48 bb 10 00    	add    $0x10bb48,%ebx
  103795:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103799:	83 c0 64             	add    $0x64,%eax
  10379c:	89 04 24             	mov    %eax,(%esp)
  10379f:	e8 e8 11 00 00       	call   10498c <swtch>
}
  1037a4:	83 c4 14             	add    $0x14,%esp
  1037a7:	5b                   	pop    %ebx
  1037a8:	5d                   	pop    %ebp
  1037a9:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  1037aa:	c7 04 24 f2 6d 10 00 	movl   $0x106df2,(%esp)
  1037b1:	e8 ba d1 ff ff       	call   100970 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  1037b6:	c7 04 24 2a 6e 10 00 	movl   $0x106e2a,(%esp)
  1037bd:	e8 ae d1 ff ff       	call   100970 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  1037c2:	c7 04 24 14 6e 10 00 	movl   $0x106e14,(%esp)
  1037c9:	e8 a2 d1 ff ff       	call   100970 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  1037ce:	c7 04 24 06 6e 10 00 	movl   $0x106e06,(%esp)
  1037d5:	e8 96 d1 ff ff       	call   100970 <panic>
  1037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001037e0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1037e0:	55                   	push   %ebp
  1037e1:	89 e5                	mov    %esp,%ebp
  1037e3:	56                   	push   %esi
  1037e4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1037e5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1037e7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  1037ea:	e8 f1 fe ff ff       	call   1036e0 <curproc>
  1037ef:	3b 05 c8 88 10 00    	cmp    0x1088c8,%eax
  1037f5:	0f 84 36 01 00 00    	je     103931 <exit+0x151>
  1037fb:	90                   	nop
  1037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103800:	e8 db fe ff ff       	call   1036e0 <curproc>
  103805:	8d 73 08             	lea    0x8(%ebx),%esi
  103808:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  10380b:	85 d2                	test   %edx,%edx
  10380d:	74 1c                	je     10382b <exit+0x4b>
      fileclose(cp->ofile[fd]);
  10380f:	e8 cc fe ff ff       	call   1036e0 <curproc>
  103814:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  103817:	89 04 24             	mov    %eax,(%esp)
  10381a:	e8 d1 d8 ff ff       	call   1010f0 <fileclose>
      cp->ofile[fd] = 0;
  10381f:	e8 bc fe ff ff       	call   1036e0 <curproc>
  103824:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  10382b:	83 c3 01             	add    $0x1,%ebx
  10382e:	83 fb 10             	cmp    $0x10,%ebx
  103831:	75 cd                	jne    103800 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103833:	e8 a8 fe ff ff       	call   1036e0 <curproc>
  103838:	8b 40 60             	mov    0x60(%eax),%eax
  10383b:	89 04 24             	mov    %eax,(%esp)
  10383e:	e8 9d e3 ff ff       	call   101be0 <iput>
  cp->cwd = 0;
  103843:	e8 98 fe ff ff       	call   1036e0 <curproc>
  103848:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  10384f:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103856:	e8 c5 0e 00 00       	call   104720 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10385b:	e8 80 fe ff ff       	call   1036e0 <curproc>
  103860:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103863:	b8 c0 e8 10 00       	mov    $0x10e8c0,%eax
  103868:	3d c0 c1 10 00       	cmp    $0x10c1c0,%eax
  10386d:	0f 86 95 00 00 00    	jbe    103908 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103873:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  103878:	eb 12                	jmp    10388c <exit+0xac>
  10387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103880:	05 9c 00 00 00       	add    $0x9c,%eax
  103885:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  10388a:	74 1e                	je     1038aa <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  10388c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103890:	75 ee                	jne    103880 <exit+0xa0>
  103892:	3b 50 18             	cmp    0x18(%eax),%edx
  103895:	75 e9                	jne    103880 <exit+0xa0>
      p->state = RUNNABLE;
  103897:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10389e:	05 9c 00 00 00       	add    $0x9c,%eax
  1038a3:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  1038a8:	75 e2                	jne    10388c <exit+0xac>
  1038aa:	bb c0 c1 10 00       	mov    $0x10c1c0,%ebx
  1038af:	eb 15                	jmp    1038c6 <exit+0xe6>
  1038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  1038b8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  1038be:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  1038c4:	74 42                	je     103908 <exit+0x128>
    if(p->parent == cp){
  1038c6:	8b 73 14             	mov    0x14(%ebx),%esi
  1038c9:	e8 12 fe ff ff       	call   1036e0 <curproc>
  1038ce:	39 c6                	cmp    %eax,%esi
  1038d0:	75 e6                	jne    1038b8 <exit+0xd8>
      p->parent = initproc;
  1038d2:	8b 15 c8 88 10 00    	mov    0x1088c8,%edx
      if(p->state == ZOMBIE)
  1038d8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  1038dc:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  1038df:	75 d7                	jne    1038b8 <exit+0xd8>
  1038e1:	b8 c0 c1 10 00       	mov    $0x10c1c0,%eax
  1038e6:	eb 0c                	jmp    1038f4 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1038e8:	05 9c 00 00 00       	add    $0x9c,%eax
  1038ed:	3d c0 e8 10 00       	cmp    $0x10e8c0,%eax
  1038f2:	74 c4                	je     1038b8 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  1038f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1038f8:	75 ee                	jne    1038e8 <exit+0x108>
  1038fa:	3b 50 18             	cmp    0x18(%eax),%edx
  1038fd:	75 e9                	jne    1038e8 <exit+0x108>
      p->state = RUNNABLE;
  1038ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103906:	eb e0                	jmp    1038e8 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103908:	e8 d3 fd ff ff       	call   1036e0 <curproc>
  10390d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  103914:	e8 c7 fd ff ff       	call   1036e0 <curproc>
  103919:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103920:	e8 1b fe ff ff       	call   103740 <sched>
  panic("zombie exit");
  103925:	c7 04 24 43 6e 10 00 	movl   $0x106e43,(%esp)
  10392c:	e8 3f d0 ff ff       	call   100970 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103931:	c7 04 24 36 6e 10 00 	movl   $0x106e36,(%esp)
  103938:	e8 33 d0 ff ff       	call   100970 <panic>
  10393d:	8d 76 00             	lea    0x0(%esi),%esi

00103940 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  103940:	55                   	push   %ebp
  103941:	89 e5                	mov    %esp,%ebp
  103943:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  103946:	e8 95 fd ff ff       	call   1036e0 <curproc>
  10394b:	85 c0                	test   %eax,%eax
  10394d:	74 2b                	je     10397a <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  10394f:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103956:	e8 c5 0d 00 00       	call   104720 <acquire>
  cp->state = SLEEPING;
  10395b:	e8 80 fd ff ff       	call   1036e0 <curproc>
  103960:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  103967:	e8 d4 fd ff ff       	call   103740 <sched>
	release(&proc_table_lock); 
  10396c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103973:	e8 68 0d 00 00       	call   1046e0 <release>
}
  103978:	c9                   	leave  
  103979:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  10397a:	c7 04 24 4f 6e 10 00 	movl   $0x106e4f,(%esp)
  103981:	e8 ea cf ff ff       	call   100970 <panic>
  103986:	8d 76 00             	lea    0x0(%esi),%esi
  103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103990 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103990:	55                   	push   %ebp
  103991:	89 e5                	mov    %esp,%ebp
  103993:	56                   	push   %esi
  103994:	53                   	push   %ebx
  103995:	83 ec 10             	sub    $0x10,%esp
  103998:	8b 75 08             	mov    0x8(%ebp),%esi
  10399b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10399e:	e8 3d fd ff ff       	call   1036e0 <curproc>
  1039a3:	85 c0                	test   %eax,%eax
  1039a5:	0f 84 9d 00 00 00    	je     103a48 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  1039ab:	85 db                	test   %ebx,%ebx
  1039ad:	0f 84 89 00 00 00    	je     103a3c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  1039b3:	81 fb c0 e8 10 00    	cmp    $0x10e8c0,%ebx
  1039b9:	74 55                	je     103a10 <sleep+0x80>
    acquire(&proc_table_lock);
  1039bb:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1039c2:	e8 59 0d 00 00       	call   104720 <acquire>
    release(lk);
  1039c7:	89 1c 24             	mov    %ebx,(%esp)
  1039ca:	e8 11 0d 00 00       	call   1046e0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  1039cf:	e8 0c fd ff ff       	call   1036e0 <curproc>
  1039d4:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  1039d7:	e8 04 fd ff ff       	call   1036e0 <curproc>
  1039dc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  1039e3:	e8 58 fd ff ff       	call   103740 <sched>

  // Tidy up.
  cp->chan = 0;
  1039e8:	e8 f3 fc ff ff       	call   1036e0 <curproc>
  1039ed:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  1039f4:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  1039fb:	e8 e0 0c 00 00       	call   1046e0 <release>
    acquire(lk);
  103a00:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103a03:	83 c4 10             	add    $0x10,%esp
  103a06:	5b                   	pop    %ebx
  103a07:	5e                   	pop    %esi
  103a08:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103a09:	e9 12 0d 00 00       	jmp    104720 <acquire>
  103a0e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103a10:	e8 cb fc ff ff       	call   1036e0 <curproc>
  103a15:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103a18:	e8 c3 fc ff ff       	call   1036e0 <curproc>
  103a1d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103a24:	e8 17 fd ff ff       	call   103740 <sched>

  // Tidy up.
  cp->chan = 0;
  103a29:	e8 b2 fc ff ff       	call   1036e0 <curproc>
  103a2e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103a35:	83 c4 10             	add    $0x10,%esp
  103a38:	5b                   	pop    %ebx
  103a39:	5e                   	pop    %esi
  103a3a:	5d                   	pop    %ebp
  103a3b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  103a3c:	c7 04 24 55 6e 10 00 	movl   $0x106e55,(%esp)
  103a43:	e8 28 cf ff ff       	call   100970 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103a48:	c7 04 24 4f 6e 10 00 	movl   $0x106e4f,(%esp)
  103a4f:	e8 1c cf ff ff       	call   100970 <panic>
  103a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103a60 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a60:	55                   	push   %ebp
  103a61:	89 e5                	mov    %esp,%ebp
  103a63:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a64:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a66:	56                   	push   %esi
  103a67:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a68:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a6a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a6d:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103a74:	e8 a7 0c 00 00       	call   104720 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a79:	83 fb 3f             	cmp    $0x3f,%ebx
  103a7c:	7e 2f                	jle    103aad <wait_thread+0x4d>
  103a7e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103a80:	85 ff                	test   %edi,%edi
  103a82:	74 74                	je     103af8 <wait_thread+0x98>
  103a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103a88:	e8 53 fc ff ff       	call   1036e0 <curproc>
  103a8d:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103a90:	85 c9                	test   %ecx,%ecx
  103a92:	75 64                	jne    103af8 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103a94:	e8 47 fc ff ff       	call   1036e0 <curproc>
  103a99:	31 ff                	xor    %edi,%edi
  103a9b:	31 db                	xor    %ebx,%ebx
  103a9d:	c7 44 24 04 c0 e8 10 	movl   $0x10e8c0,0x4(%esp)
  103aa4:	00 
  103aa5:	89 04 24             	mov    %eax,(%esp)
  103aa8:	e8 e3 fe ff ff       	call   103990 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103aad:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103ab3:	81 c6 c0 c1 10 00    	add    $0x10c1c0,%esi
      if(p->state == UNUSED)
  103ab9:	8b 46 0c             	mov    0xc(%esi),%eax
  103abc:	85 c0                	test   %eax,%eax
  103abe:	75 10                	jne    103ad0 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103ac0:	83 c3 01             	add    $0x1,%ebx
  103ac3:	83 fb 3f             	cmp    $0x3f,%ebx
  103ac6:	7e e5                	jle    103aad <wait_thread+0x4d>
  103ac8:	eb b6                	jmp    103a80 <wait_thread+0x20>
  103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103ad0:	8b 46 14             	mov    0x14(%esi),%eax
  103ad3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ad6:	e8 05 fc ff ff       	call   1036e0 <curproc>
  103adb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103ade:	66 90                	xchg   %ax,%ax
  103ae0:	75 de                	jne    103ac0 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103ae2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103ae6:	74 29                	je     103b11 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103ae8:	bf 01 00 00 00       	mov    $0x1,%edi
  103aed:	8d 76 00             	lea    0x0(%esi),%esi
  103af0:	eb ce                	jmp    103ac0 <wait_thread+0x60>
  103af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103af8:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103aff:	e8 dc 0b 00 00       	call   1046e0 <release>
  103b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103b09:	83 c4 2c             	add    $0x2c,%esp
  103b0c:	5b                   	pop    %ebx
  103b0d:	5e                   	pop    %esi
  103b0e:	5f                   	pop    %edi
  103b0f:	5d                   	pop    %ebp
  103b10:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103b11:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b18:	00 
  103b19:	8b 46 08             	mov    0x8(%esi),%eax
  103b1c:	89 04 24             	mov    %eax,(%esp)
  103b1f:	e8 5c eb ff ff       	call   102680 <kfree>
          pid = p->pid;
  103b24:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103b27:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103b2e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103b35:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103b3c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103b43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103b46:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103b4d:	e8 8e 0b 00 00       	call   1046e0 <release>
          return pid;
  103b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b55:	eb b2                	jmp    103b09 <wait_thread+0xa9>
  103b57:	89 f6                	mov    %esi,%esi
  103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103b60 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b60:	55                   	push   %ebp
  103b61:	89 e5                	mov    %esp,%ebp
  103b63:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b64:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b66:	56                   	push   %esi
  103b67:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b68:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b6a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b6d:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103b74:	e8 a7 0b 00 00       	call   104720 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b79:	83 fb 3f             	cmp    $0x3f,%ebx
  103b7c:	7e 2f                	jle    103bad <wait+0x4d>
  103b7e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103b80:	85 ff                	test   %edi,%edi
  103b82:	74 74                	je     103bf8 <wait+0x98>
  103b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103b88:	e8 53 fb ff ff       	call   1036e0 <curproc>
  103b8d:	8b 50 1c             	mov    0x1c(%eax),%edx
  103b90:	85 d2                	test   %edx,%edx
  103b92:	75 64                	jne    103bf8 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103b94:	e8 47 fb ff ff       	call   1036e0 <curproc>
  103b99:	31 ff                	xor    %edi,%edi
  103b9b:	31 db                	xor    %ebx,%ebx
  103b9d:	c7 44 24 04 c0 e8 10 	movl   $0x10e8c0,0x4(%esp)
  103ba4:	00 
  103ba5:	89 04 24             	mov    %eax,(%esp)
  103ba8:	e8 e3 fd ff ff       	call   103990 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103bad:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103bb3:	81 c6 c0 c1 10 00    	add    $0x10c1c0,%esi
      if(p->state == UNUSED)
  103bb9:	8b 4e 0c             	mov    0xc(%esi),%ecx
  103bbc:	85 c9                	test   %ecx,%ecx
  103bbe:	75 10                	jne    103bd0 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103bc0:	83 c3 01             	add    $0x1,%ebx
  103bc3:	83 fb 3f             	cmp    $0x3f,%ebx
  103bc6:	7e e5                	jle    103bad <wait+0x4d>
  103bc8:	eb b6                	jmp    103b80 <wait+0x20>
  103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103bd0:	8b 46 14             	mov    0x14(%esi),%eax
  103bd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103bd6:	e8 05 fb ff ff       	call   1036e0 <curproc>
  103bdb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103bde:	66 90                	xchg   %ax,%ax
  103be0:	75 de                	jne    103bc0 <wait+0x60>
        if(p->state == ZOMBIE){
  103be2:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103be6:	74 29                	je     103c11 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103be8:	bf 01 00 00 00       	mov    $0x1,%edi
  103bed:	8d 76 00             	lea    0x0(%esi),%esi
  103bf0:	eb ce                	jmp    103bc0 <wait+0x60>
  103bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103bf8:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103bff:	e8 dc 0a 00 00       	call   1046e0 <release>
  103c04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103c09:	83 c4 2c             	add    $0x2c,%esp
  103c0c:	5b                   	pop    %ebx
  103c0d:	5e                   	pop    %esi
  103c0e:	5f                   	pop    %edi
  103c0f:	5d                   	pop    %ebp
  103c10:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103c11:	8b 46 04             	mov    0x4(%esi),%eax
  103c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c18:	8b 06                	mov    (%esi),%eax
  103c1a:	89 04 24             	mov    %eax,(%esp)
  103c1d:	e8 5e ea ff ff       	call   102680 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103c22:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c29:	00 
  103c2a:	8b 46 08             	mov    0x8(%esi),%eax
  103c2d:	89 04 24             	mov    %eax,(%esp)
  103c30:	e8 4b ea ff ff       	call   102680 <kfree>
          pid = p->pid;
  103c35:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103c38:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103c3f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103c46:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103c4d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103c54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c57:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c5e:	e8 7d 0a 00 00       	call   1046e0 <release>
          return pid;
  103c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c66:	eb a1                	jmp    103c09 <wait+0xa9>
  103c68:	90                   	nop
  103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103c70 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103c70:	55                   	push   %ebp
  103c71:	89 e5                	mov    %esp,%ebp
  103c73:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  103c76:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c7d:	e8 9e 0a 00 00       	call   104720 <acquire>
  cp->state = RUNNABLE;
  103c82:	e8 59 fa ff ff       	call   1036e0 <curproc>
  103c87:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103c8e:	e8 ad fa ff ff       	call   103740 <sched>
  release(&proc_table_lock);
  103c93:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103c9a:	e8 41 0a 00 00       	call   1046e0 <release>
}
  103c9f:	c9                   	leave  
  103ca0:	c3                   	ret    
  103ca1:	eb 0d                	jmp    103cb0 <setupsegs>
  103ca3:	90                   	nop
  103ca4:	90                   	nop
  103ca5:	90                   	nop
  103ca6:	90                   	nop
  103ca7:	90                   	nop
  103ca8:	90                   	nop
  103ca9:	90                   	nop
  103caa:	90                   	nop
  103cab:	90                   	nop
  103cac:	90                   	nop
  103cad:	90                   	nop
  103cae:	90                   	nop
  103caf:	90                   	nop

00103cb0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103cb0:	55                   	push   %ebp
  103cb1:	89 e5                	mov    %esp,%ebp
  103cb3:	57                   	push   %edi
  103cb4:	56                   	push   %esi
  103cb5:	53                   	push   %ebx
  103cb6:	83 ec 2c             	sub    $0x2c,%esp
  103cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103cbc:	e8 8f 09 00 00       	call   104650 <pushcli>
  c = &cpus[cpu()];
  103cc1:	e8 8a ee ff ff       	call   102b50 <cpu>
  103cc6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103ccc:	05 40 bb 10 00       	add    $0x10bb40,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103cd1:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103cd3:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103cd9:	0f 84 a1 01 00 00    	je     103e80 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103cdf:	8b 56 08             	mov    0x8(%esi),%edx
  103ce2:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103ce8:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103ceb:	8d 50 28             	lea    0x28(%eax),%edx
  103cee:	89 d1                	mov    %edx,%ecx
  103cf0:	c1 e9 10             	shr    $0x10,%ecx
  103cf3:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103cfa:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103cfd:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103cff:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103d06:	00 00 00 
  103d09:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103d10:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103d13:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103d1a:	0f 01 
  103d1c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103d23:	00 00 
  103d25:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103d2c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103d33:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103d3a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103d41:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103d48:	ff ff 
  103d4a:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103d51:	00 00 
  103d53:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103d5a:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103d61:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103d68:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103d6f:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103d76:	67 00 
  103d78:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103d7e:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103d85:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103d8b:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103d92:	0f 84 b8 00 00 00    	je     103e50 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103d98:	8b 16                	mov    (%esi),%edx
  103d9a:	8b 5e 04             	mov    0x4(%esi),%ebx
  103d9d:	89 d6                	mov    %edx,%esi
  103d9f:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103da2:	89 d3                	mov    %edx,%ebx
  103da4:	c1 ee 10             	shr    $0x10,%esi
  103da7:	89 cf                	mov    %ecx,%edi
  103da9:	c1 eb 18             	shr    $0x18,%ebx
  103dac:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103daf:	89 f3                	mov    %esi,%ebx
  103db1:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103db7:	89 cb                	mov    %ecx,%ebx
  103db9:	c1 eb 1c             	shr    $0x1c,%ebx
  103dbc:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103dbe:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103dc1:	83 c9 c0             	or     $0xffffffc0,%ecx
  103dc4:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103dcb:	c1 ef 0c             	shr    $0xc,%edi
  103dce:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103dd4:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103dd8:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103ddf:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103de5:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103dec:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103df2:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103df6:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103dfd:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103dff:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103e06:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103e0d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103e13:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103e19:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103e1e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103e24:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103e28:	c1 e8 10             	shr    $0x10,%eax
  103e2b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103e2f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103e32:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103e35:	b8 28 00 00 00       	mov    $0x28,%eax
  103e3a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103e3d:	e8 8e 07 00 00       	call   1045d0 <popcli>
}
  103e42:	83 c4 2c             	add    $0x2c,%esp
  103e45:	5b                   	pop    %ebx
  103e46:	5e                   	pop    %esi
  103e47:	5f                   	pop    %edi
  103e48:	5d                   	pop    %ebp
  103e49:	c3                   	ret    
  103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103e50:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103e57:	00 00 00 
  103e5a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103e61:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103e64:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103e6b:	00 00 00 
  103e6e:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103e75:	00 00 00 
  103e78:	eb 9f                	jmp    103e19 <setupsegs+0x169>
  103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103e80:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103e87:	e9 5f fe ff ff       	jmp    103ceb <setupsegs+0x3b>
  103e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e90 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103e90:	55                   	push   %ebp
  103e91:	89 e5                	mov    %esp,%ebp
  103e93:	57                   	push   %edi
  103e94:	56                   	push   %esi
  103e95:	53                   	push   %ebx
  103e96:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103e99:	e8 b2 ec ff ff       	call   102b50 <cpu>
  103e9e:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103ea4:	81 c3 40 bb 10 00    	add    $0x10bb40,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103eaa:	8d 73 08             	lea    0x8(%ebx),%esi
  103ead:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103eb0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103eb1:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103eb8:	e8 63 08 00 00       	call   104720 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103ebd:	83 3d d0 c1 10 00 01 	cmpl   $0x1,0x10c1d0
  103ec4:	0f 84 c6 00 00 00    	je     103f90 <scheduler+0x100>
  103eca:	31 d2                	xor    %edx,%edx
  103ecc:	31 c0                	xor    %eax,%eax
  103ece:	eb 0e                	jmp    103ede <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103ed0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103ed6:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103edc:	74 1d                	je     103efb <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103ede:	83 ba cc c1 10 00 03 	cmpl   $0x3,0x10c1cc(%edx)
  103ee5:	75 e9                	jne    103ed0 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103ee7:	03 82 58 c2 10 00    	add    0x10c258(%edx),%eax
  103eed:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103ef3:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103ef9:	75 e3                	jne    103ede <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103efb:	85 c0                	test   %eax,%eax
  103efd:	74 16                	je     103f15 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103eff:	8b 3d 40 f1 10 00    	mov    0x10f140,%edi
  103f05:	89 c1                	mov    %eax,%ecx
  103f07:	c1 e7 08             	shl    $0x8,%edi
  103f0a:	89 fa                	mov    %edi,%edx
  103f0c:	89 f8                	mov    %edi,%eax
  103f0e:	c1 fa 1f             	sar    $0x1f,%edx
  103f11:	f7 f9                	idiv   %ecx
  103f13:	89 d7                	mov    %edx,%edi
  103f15:	b8 cc c1 10 00       	mov    $0x10c1cc,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103f1a:	31 d2                	xor    %edx,%edx
  103f1c:	eb 12                	jmp    103f30 <scheduler+0xa0>
  103f1e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103f20:	39 fa                	cmp    %edi,%edx
  103f22:	7f 1e                	jg     103f42 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103f24:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103f29:	3d cc e8 10 00       	cmp    $0x10e8cc,%eax
  103f2e:	74 4c                	je     103f7c <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103f30:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103f33:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103f36:	75 e8                	jne    103f20 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103f38:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103f3e:	39 fa                	cmp    %edi,%edx
  103f40:	7e e2                	jle    103f24 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103f42:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103f45:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103f48:	89 0c 24             	mov    %ecx,(%esp)
  103f4b:	e8 60 fd ff ff       	call   103cb0 <setupsegs>
    	  p->state = RUNNING;
  103f50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103f53:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103f5a:	83 c1 64             	add    $0x64,%ecx
  103f5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f61:	89 34 24             	mov    %esi,(%esp)
  103f64:	e8 23 0a 00 00       	call   10498c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103f69:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103f70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103f77:	e8 34 fd ff ff       	call   103cb0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103f7c:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103f83:	e8 58 07 00 00       	call   1046e0 <release>
  103f88:	e9 23 ff ff ff       	jmp    103eb0 <scheduler+0x20>
  103f8d:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103f90:	83 3d cc c1 10 00 03 	cmpl   $0x3,0x10c1cc
  103f97:	0f 85 2d ff ff ff    	jne    103eca <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103f9d:	c7 43 04 c0 c1 10 00 	movl   $0x10c1c0,0x4(%ebx)
      setupsegs(p);
  103fa4:	c7 04 24 c0 c1 10 00 	movl   $0x10c1c0,(%esp)
  103fab:	e8 00 fd ff ff       	call   103cb0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103fb0:	c7 44 24 04 24 c2 10 	movl   $0x10c224,0x4(%esp)
  103fb7:	00 
  103fb8:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103fbb:	c7 05 58 c2 10 00 4b 	movl   $0x4b,0x10c258
  103fc2:	00 00 00 
      p->state = RUNNING;
  103fc5:	c7 05 cc c1 10 00 04 	movl   $0x4,0x10c1cc
  103fcc:	00 00 00 
      swtch(&c->context, &p->context);
  103fcf:	e8 b8 09 00 00       	call   10498c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103fd4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103fdb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103fe2:	e8 c9 fc ff ff       	call   103cb0 <setupsegs>
      release(&proc_table_lock);
  103fe7:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  103fee:	e8 ed 06 00 00       	call   1046e0 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103ff3:	e9 b8 fe ff ff       	jmp    103eb0 <scheduler+0x20>
  103ff8:	90                   	nop
  103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104000 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  104000:	55                   	push   %ebp
  104001:	89 e5                	mov    %esp,%ebp
  104003:	57                   	push   %edi
  104004:	56                   	push   %esi
  104005:	53                   	push   %ebx
  104006:	83 ec 1c             	sub    $0x1c,%esp
  104009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  10400c:	e8 cf f6 ff ff       	call   1036e0 <curproc>
  104011:	8b 50 04             	mov    0x4(%eax),%edx
  104014:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  104017:	89 04 24             	mov    %eax,(%esp)
  10401a:	e8 a1 e5 ff ff       	call   1025c0 <kalloc>
  10401f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  104021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104026:	85 f6                	test   %esi,%esi
  104028:	74 7f                	je     1040a9 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  10402a:	e8 b1 f6 ff ff       	call   1036e0 <curproc>
  10402f:	8b 78 04             	mov    0x4(%eax),%edi
  104032:	e8 a9 f6 ff ff       	call   1036e0 <curproc>
  104037:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10403b:	8b 00                	mov    (%eax),%eax
  10403d:	89 34 24             	mov    %esi,(%esp)
  104040:	89 44 24 04          	mov    %eax,0x4(%esp)
  104044:	e8 d7 07 00 00       	call   104820 <memmove>
  memset(newmem + cp->sz, 0, n);
  104049:	e8 92 f6 ff ff       	call   1036e0 <curproc>
  10404e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104052:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104059:	00 
  10405a:	8b 50 04             	mov    0x4(%eax),%edx
  10405d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104060:	89 04 24             	mov    %eax,(%esp)
  104063:	e8 28 07 00 00       	call   104790 <memset>
  kfree(cp->mem, cp->sz);
  104068:	e8 73 f6 ff ff       	call   1036e0 <curproc>
  10406d:	8b 78 04             	mov    0x4(%eax),%edi
  104070:	e8 6b f6 ff ff       	call   1036e0 <curproc>
  104075:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104079:	8b 00                	mov    (%eax),%eax
  10407b:	89 04 24             	mov    %eax,(%esp)
  10407e:	e8 fd e5 ff ff       	call   102680 <kfree>
  cp->mem = newmem;
  104083:	e8 58 f6 ff ff       	call   1036e0 <curproc>
  104088:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  10408a:	e8 51 f6 ff ff       	call   1036e0 <curproc>
  10408f:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  104092:	e8 49 f6 ff ff       	call   1036e0 <curproc>
  104097:	89 04 24             	mov    %eax,(%esp)
  10409a:	e8 11 fc ff ff       	call   103cb0 <setupsegs>
  return cp->sz - n;
  10409f:	e8 3c f6 ff ff       	call   1036e0 <curproc>
  1040a4:	8b 40 04             	mov    0x4(%eax),%eax
  1040a7:	29 d8                	sub    %ebx,%eax
}
  1040a9:	83 c4 1c             	add    $0x1c,%esp
  1040ac:	5b                   	pop    %ebx
  1040ad:	5e                   	pop    %esi
  1040ae:	5f                   	pop    %edi
  1040af:	5d                   	pop    %ebp
  1040b0:	c3                   	ret    
  1040b1:	eb 0d                	jmp    1040c0 <copyproc_tix>
  1040b3:	90                   	nop
  1040b4:	90                   	nop
  1040b5:	90                   	nop
  1040b6:	90                   	nop
  1040b7:	90                   	nop
  1040b8:	90                   	nop
  1040b9:	90                   	nop
  1040ba:	90                   	nop
  1040bb:	90                   	nop
  1040bc:	90                   	nop
  1040bd:	90                   	nop
  1040be:	90                   	nop
  1040bf:	90                   	nop

001040c0 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  1040c0:	55                   	push   %ebp
  1040c1:	89 e5                	mov    %esp,%ebp
  1040c3:	57                   	push   %edi
  1040c4:	56                   	push   %esi
  1040c5:	53                   	push   %ebx
  1040c6:	83 ec 1c             	sub    $0x1c,%esp
  1040c9:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1040cc:	e8 8f f5 ff ff       	call   103660 <allocproc>
  1040d1:	85 c0                	test   %eax,%eax
  1040d3:	89 c6                	mov    %eax,%esi
  1040d5:	0f 84 e1 00 00 00    	je     1041bc <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1040db:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1040e2:	e8 d9 e4 ff ff       	call   1025c0 <kalloc>
  1040e7:	85 c0                	test   %eax,%eax
  1040e9:	89 46 08             	mov    %eax,0x8(%esi)
  1040ec:	0f 84 d4 00 00 00    	je     1041c6 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040f2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1040f7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040f9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1040ff:	0f 84 85 00 00 00    	je     10418a <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  104105:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  104108:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  10410b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104111:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104118:	00 
  104119:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  10411f:	89 04 24             	mov    %eax,(%esp)
  104122:	89 54 24 04          	mov    %edx,0x4(%esp)
  104126:	e8 f5 06 00 00       	call   104820 <memmove>
  
    np->sz = p->sz;
  10412b:	8b 47 04             	mov    0x4(%edi),%eax
  10412e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104131:	89 04 24             	mov    %eax,(%esp)
  104134:	e8 87 e4 ff ff       	call   1025c0 <kalloc>
  104139:	85 c0                	test   %eax,%eax
  10413b:	89 06                	mov    %eax,(%esi)
  10413d:	0f 84 8e 00 00 00    	je     1041d1 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104143:	8b 56 04             	mov    0x4(%esi),%edx
  104146:	31 db                	xor    %ebx,%ebx
  104148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10414c:	8b 17                	mov    (%edi),%edx
  10414e:	89 04 24             	mov    %eax,(%esp)
  104151:	89 54 24 04          	mov    %edx,0x4(%esp)
  104155:	e8 c6 06 00 00       	call   104820 <memmove>
  10415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104160:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104164:	85 c0                	test   %eax,%eax
  104166:	74 0c                	je     104174 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104168:	89 04 24             	mov    %eax,(%esp)
  10416b:	e8 a0 ce ff ff       	call   101010 <filedup>
  104170:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104174:	83 c3 01             	add    $0x1,%ebx
  104177:	83 fb 10             	cmp    $0x10,%ebx
  10417a:	75 e4                	jne    104160 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10417c:	8b 47 60             	mov    0x60(%edi),%eax
  10417f:	89 04 24             	mov    %eax,(%esp)
  104182:	e8 99 d0 ff ff       	call   101220 <idup>
  104187:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10418a:	8d 46 64             	lea    0x64(%esi),%eax
  10418d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104194:	00 
  104195:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10419c:	00 
  10419d:	89 04 24             	mov    %eax,(%esp)
  1041a0:	e8 eb 05 00 00       	call   104790 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1041a5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1041ab:	c7 46 64 10 37 10 00 	movl   $0x103710,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1041b2:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1041b5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1041bc:	83 c4 1c             	add    $0x1c,%esp
  1041bf:	89 f0                	mov    %esi,%eax
  1041c1:	5b                   	pop    %ebx
  1041c2:	5e                   	pop    %esi
  1041c3:	5f                   	pop    %edi
  1041c4:	5d                   	pop    %ebp
  1041c5:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1041c6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1041cd:	31 f6                	xor    %esi,%esi
    return 0;
  1041cf:	eb eb                	jmp    1041bc <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1041d1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1041d8:	00 
  1041d9:	8b 46 08             	mov    0x8(%esi),%eax
  1041dc:	89 04 24             	mov    %eax,(%esp)
  1041df:	e8 9c e4 ff ff       	call   102680 <kfree>
      np->kstack = 0;
  1041e4:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1041eb:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1041f2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1041f9:	31 f6                	xor    %esi,%esi
      return 0;
  1041fb:	eb bf                	jmp    1041bc <copyproc_tix+0xfc>
  1041fd:	8d 76 00             	lea    0x0(%esi),%esi

00104200 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  104200:	55                   	push   %ebp
  104201:	89 e5                	mov    %esp,%ebp
  104203:	57                   	push   %edi
  104204:	56                   	push   %esi
  104205:	53                   	push   %ebx
  104206:	83 ec 1c             	sub    $0x1c,%esp
  104209:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  10420c:	e8 4f f4 ff ff       	call   103660 <allocproc>
  104211:	85 c0                	test   %eax,%eax
  104213:	89 c6                	mov    %eax,%esi
  104215:	0f 84 de 00 00 00    	je     1042f9 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10421b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104222:	e8 99 e3 ff ff       	call   1025c0 <kalloc>
  104227:	85 c0                	test   %eax,%eax
  104229:	89 46 08             	mov    %eax,0x8(%esi)
  10422c:	0f 84 d1 00 00 00    	je     104303 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104232:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104237:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104239:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10423f:	74 61                	je     1042a2 <copyproc_threads+0xa2>
    np->parent = p;
  104241:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104244:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104246:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10424d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104250:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104257:	00 
  104258:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  10425e:	89 04 24             	mov    %eax,(%esp)
  104261:	89 54 24 04          	mov    %edx,0x4(%esp)
  104265:	e8 b6 05 00 00       	call   104820 <memmove>
  
    np->sz = p->sz;
  10426a:	8b 47 04             	mov    0x4(%edi),%eax
  10426d:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104270:	8b 07                	mov    (%edi),%eax
  104272:	89 06                	mov    %eax,(%esi)
  104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104278:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  10427c:	85 c0                	test   %eax,%eax
  10427e:	74 0c                	je     10428c <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  104280:	89 04 24             	mov    %eax,(%esp)
  104283:	e8 88 cd ff ff       	call   101010 <filedup>
  104288:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  10428c:	83 c3 01             	add    $0x1,%ebx
  10428f:	83 fb 10             	cmp    $0x10,%ebx
  104292:	75 e4                	jne    104278 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  104294:	8b 47 60             	mov    0x60(%edi),%eax
  104297:	89 04 24             	mov    %eax,(%esp)
  10429a:	e8 81 cf ff ff       	call   101220 <idup>
  10429f:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1042a2:	8d 46 64             	lea    0x64(%esi),%eax
  1042a5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1042ac:	00 
  1042ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042b4:	00 
  1042b5:	89 04 24             	mov    %eax,(%esp)
  1042b8:	e8 d3 04 00 00       	call   104790 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1042c0:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1042c6:	c7 46 64 10 37 10 00 	movl   $0x103710,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1042cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1042d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042d3:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1042d9:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1042dc:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  1042df:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1042e1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1042e8:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1042ef:	8b 40 3c             	mov    0x3c(%eax),%eax
  1042f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1042f5:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  1042f9:	83 c4 1c             	add    $0x1c,%esp
  1042fc:	89 f0                	mov    %esi,%eax
  1042fe:	5b                   	pop    %ebx
  1042ff:	5e                   	pop    %esi
  104300:	5f                   	pop    %edi
  104301:	5d                   	pop    %ebp
  104302:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104303:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10430a:	31 f6                	xor    %esi,%esi
    return 0;
  10430c:	eb eb                	jmp    1042f9 <copyproc_threads+0xf9>
  10430e:	66 90                	xchg   %ax,%ax

00104310 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104310:	55                   	push   %ebp
  104311:	89 e5                	mov    %esp,%ebp
  104313:	57                   	push   %edi
  104314:	56                   	push   %esi
  104315:	53                   	push   %ebx
  104316:	83 ec 1c             	sub    $0x1c,%esp
  104319:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10431c:	e8 3f f3 ff ff       	call   103660 <allocproc>
  104321:	85 c0                	test   %eax,%eax
  104323:	89 c6                	mov    %eax,%esi
  104325:	0f 84 e1 00 00 00    	je     10440c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10432b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104332:	e8 89 e2 ff ff       	call   1025c0 <kalloc>
  104337:	85 c0                	test   %eax,%eax
  104339:	89 46 08             	mov    %eax,0x8(%esi)
  10433c:	0f 84 d4 00 00 00    	je     104416 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104342:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104347:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104349:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10434f:	0f 84 85 00 00 00    	je     1043da <copyproc+0xca>
    np->parent = p;
  104355:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104358:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10435f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104362:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104369:	00 
  10436a:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104370:	89 04 24             	mov    %eax,(%esp)
  104373:	89 54 24 04          	mov    %edx,0x4(%esp)
  104377:	e8 a4 04 00 00       	call   104820 <memmove>
  
    np->sz = p->sz;
  10437c:	8b 47 04             	mov    0x4(%edi),%eax
  10437f:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104382:	89 04 24             	mov    %eax,(%esp)
  104385:	e8 36 e2 ff ff       	call   1025c0 <kalloc>
  10438a:	85 c0                	test   %eax,%eax
  10438c:	89 06                	mov    %eax,(%esi)
  10438e:	0f 84 8d 00 00 00    	je     104421 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104394:	8b 56 04             	mov    0x4(%esi),%edx
  104397:	31 db                	xor    %ebx,%ebx
  104399:	89 54 24 08          	mov    %edx,0x8(%esp)
  10439d:	8b 17                	mov    (%edi),%edx
  10439f:	89 04 24             	mov    %eax,(%esp)
  1043a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1043a6:	e8 75 04 00 00       	call   104820 <memmove>
  1043ab:	90                   	nop
  1043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1043b0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1043b4:	85 c0                	test   %eax,%eax
  1043b6:	74 0c                	je     1043c4 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  1043b8:	89 04 24             	mov    %eax,(%esp)
  1043bb:	e8 50 cc ff ff       	call   101010 <filedup>
  1043c0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1043c4:	83 c3 01             	add    $0x1,%ebx
  1043c7:	83 fb 10             	cmp    $0x10,%ebx
  1043ca:	75 e4                	jne    1043b0 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1043cc:	8b 47 60             	mov    0x60(%edi),%eax
  1043cf:	89 04 24             	mov    %eax,(%esp)
  1043d2:	e8 49 ce ff ff       	call   101220 <idup>
  1043d7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1043da:	8d 46 64             	lea    0x64(%esi),%eax
  1043dd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1043e4:	00 
  1043e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1043ec:	00 
  1043ed:	89 04 24             	mov    %eax,(%esp)
  1043f0:	e8 9b 03 00 00       	call   104790 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1043f5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1043fb:	c7 46 64 10 37 10 00 	movl   $0x103710,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104402:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104405:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10440c:	83 c4 1c             	add    $0x1c,%esp
  10440f:	89 f0                	mov    %esi,%eax
  104411:	5b                   	pop    %ebx
  104412:	5e                   	pop    %esi
  104413:	5f                   	pop    %edi
  104414:	5d                   	pop    %ebp
  104415:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104416:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10441d:	31 f6                	xor    %esi,%esi
    return 0;
  10441f:	eb eb                	jmp    10440c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104421:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104428:	00 
  104429:	8b 46 08             	mov    0x8(%esi),%eax
  10442c:	89 04 24             	mov    %eax,(%esp)
  10442f:	e8 4c e2 ff ff       	call   102680 <kfree>
      np->kstack = 0;
  104434:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10443b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104442:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104449:	31 f6                	xor    %esi,%esi
      return 0;
  10444b:	eb bf                	jmp    10440c <copyproc+0xfc>
  10444d:	8d 76 00             	lea    0x0(%esi),%esi

00104450 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104450:	55                   	push   %ebp
  104451:	89 e5                	mov    %esp,%ebp
  104453:	53                   	push   %ebx
  104454:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104457:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10445e:	e8 ad fe ff ff       	call   104310 <copyproc>
  p->sz = PAGE;
  104463:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10446a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10446c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104473:	e8 48 e1 ff ff       	call   1025c0 <kalloc>
  104478:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10447a:	c7 04 24 66 6e 10 00 	movl   $0x106e66,(%esp)
  104481:	e8 6a dd ff ff       	call   1021f0 <namei>
  104486:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104489:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104490:	00 
  104491:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104498:	00 
  104499:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10449f:	89 04 24             	mov    %eax,(%esp)
  1044a2:	e8 e9 02 00 00       	call   104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1044a7:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044ad:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  1044af:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  1044b6:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1044b9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1044bf:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  1044c5:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  1044cb:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  1044ce:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044d2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1044d5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1044db:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1044e2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1044e9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1044f0:	00 
  1044f1:	c7 44 24 04 88 87 10 	movl   $0x108788,0x4(%esp)
  1044f8:	00 
  1044f9:	8b 03                	mov    (%ebx),%eax
  1044fb:	89 04 24             	mov    %eax,(%esp)
  1044fe:	e8 1d 03 00 00       	call   104820 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104503:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104509:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104510:	00 
  104511:	c7 44 24 04 68 6e 10 	movl   $0x106e68,0x4(%esp)
  104518:	00 
  104519:	89 04 24             	mov    %eax,(%esp)
  10451c:	e8 0f 04 00 00       	call   104930 <safestrcpy>
  p->state = RUNNABLE;
  104521:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104528:	89 1d c8 88 10 00    	mov    %ebx,0x1088c8
}
  10452e:	83 c4 14             	add    $0x14,%esp
  104531:	5b                   	pop    %ebx
  104532:	5d                   	pop    %ebp
  104533:	c3                   	ret    
  104534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10453a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104540 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104540:	55                   	push   %ebp
  104541:	89 e5                	mov    %esp,%ebp
  104543:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104546:	c7 44 24 04 71 6e 10 	movl   $0x106e71,0x4(%esp)
  10454d:	00 
  10454e:	c7 04 24 c0 e8 10 00 	movl   $0x10e8c0,(%esp)
  104555:	e8 06 00 00 00       	call   104560 <initlock>
}
  10455a:	c9                   	leave  
  10455b:	c3                   	ret    
  10455c:	90                   	nop
  10455d:	90                   	nop
  10455e:	90                   	nop
  10455f:	90                   	nop

00104560 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104560:	55                   	push   %ebp
  104561:	89 e5                	mov    %esp,%ebp
  104563:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104566:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10456f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104572:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104579:	5d                   	pop    %ebp
  10457a:	c3                   	ret    
  10457b:	90                   	nop
  10457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104580 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104580:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104581:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104583:	89 e5                	mov    %esp,%ebp
  104585:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104586:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104589:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10458c:	83 ea 08             	sub    $0x8,%edx
  10458f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104590:	8d 4a ff             	lea    -0x1(%edx),%ecx
  104593:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  104596:	77 18                	ja     1045b0 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  104598:	8b 4a 04             	mov    0x4(%edx),%ecx
  10459b:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  10459e:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1045a1:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1045a3:	83 f8 0a             	cmp    $0xa,%eax
  1045a6:	75 e8                	jne    104590 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  1045a8:	5b                   	pop    %ebx
  1045a9:	5d                   	pop    %ebp
  1045aa:	c3                   	ret    
  1045ab:	90                   	nop
  1045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1045b0:	83 f8 09             	cmp    $0x9,%eax
  1045b3:	7f f3                	jg     1045a8 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1045b5:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  1045b8:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  1045bb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1045c1:	83 c2 04             	add    $0x4,%edx
  1045c4:	83 f8 0a             	cmp    $0xa,%eax
  1045c7:	75 ef                	jne    1045b8 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  1045c9:	5b                   	pop    %ebx
  1045ca:	5d                   	pop    %ebp
  1045cb:	c3                   	ret    
  1045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001045d0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1045d0:	55                   	push   %ebp
  1045d1:	89 e5                	mov    %esp,%ebp
  1045d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1045d6:	9c                   	pushf  
  1045d7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1045d8:	f6 c4 02             	test   $0x2,%ah
  1045db:	75 5f                	jne    10463c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1045dd:	e8 6e e5 ff ff       	call   102b50 <cpu>
  1045e2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1045e8:	05 44 bb 10 00       	add    $0x10bb44,%eax
  1045ed:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1045f3:	83 ea 01             	sub    $0x1,%edx
  1045f6:	85 d2                	test   %edx,%edx
  1045f8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1045fe:	78 30                	js     104630 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104600:	e8 4b e5 ff ff       	call   102b50 <cpu>
  104605:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10460b:	8b 90 04 bc 10 00    	mov    0x10bc04(%eax),%edx
  104611:	85 d2                	test   %edx,%edx
  104613:	74 03                	je     104618 <popcli+0x48>
    sti();
}
  104615:	c9                   	leave  
  104616:	c3                   	ret    
  104617:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104618:	e8 33 e5 ff ff       	call   102b50 <cpu>
  10461d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104623:	8b 80 08 bc 10 00    	mov    0x10bc08(%eax),%eax
  104629:	85 c0                	test   %eax,%eax
  10462b:	74 e8                	je     104615 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10462d:	fb                   	sti    
    sti();
}
  10462e:	c9                   	leave  
  10462f:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104630:	c7 04 24 d7 6e 10 00 	movl   $0x106ed7,(%esp)
  104637:	e8 34 c3 ff ff       	call   100970 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10463c:	c7 04 24 c0 6e 10 00 	movl   $0x106ec0,(%esp)
  104643:	e8 28 c3 ff ff       	call   100970 <panic>
  104648:	90                   	nop
  104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104650 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104650:	55                   	push   %ebp
  104651:	89 e5                	mov    %esp,%ebp
  104653:	53                   	push   %ebx
  104654:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104657:	9c                   	pushf  
  104658:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104659:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10465a:	e8 f1 e4 ff ff       	call   102b50 <cpu>
  10465f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104665:	05 44 bb 10 00       	add    $0x10bb44,%eax
  10466a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104670:	8d 4a 01             	lea    0x1(%edx),%ecx
  104673:	85 d2                	test   %edx,%edx
  104675:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  10467b:	75 17                	jne    104694 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  10467d:	e8 ce e4 ff ff       	call   102b50 <cpu>
  104682:	81 e3 00 02 00 00    	and    $0x200,%ebx
  104688:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10468e:	89 98 08 bc 10 00    	mov    %ebx,0x10bc08(%eax)
}
  104694:	83 c4 04             	add    $0x4,%esp
  104697:	5b                   	pop    %ebx
  104698:	5d                   	pop    %ebp
  104699:	c3                   	ret    
  10469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001046a0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1046a0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  1046a1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1046a3:	89 e5                	mov    %esp,%ebp
  1046a5:	53                   	push   %ebx
  1046a6:	83 ec 04             	sub    $0x4,%esp
  1046a9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  1046ac:	8b 0a                	mov    (%edx),%ecx
  1046ae:	85 c9                	test   %ecx,%ecx
  1046b0:	75 06                	jne    1046b8 <holding+0x18>
}
  1046b2:	83 c4 04             	add    $0x4,%esp
  1046b5:	5b                   	pop    %ebx
  1046b6:	5d                   	pop    %ebp
  1046b7:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1046b8:	8b 5a 08             	mov    0x8(%edx),%ebx
  1046bb:	e8 90 e4 ff ff       	call   102b50 <cpu>
  1046c0:	83 c0 0a             	add    $0xa,%eax
  1046c3:	39 c3                	cmp    %eax,%ebx
  1046c5:	0f 94 c0             	sete   %al
}
  1046c8:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1046cb:	0f b6 c0             	movzbl %al,%eax
}
  1046ce:	5b                   	pop    %ebx
  1046cf:	5d                   	pop    %ebp
  1046d0:	c3                   	ret    
  1046d1:	eb 0d                	jmp    1046e0 <release>
  1046d3:	90                   	nop
  1046d4:	90                   	nop
  1046d5:	90                   	nop
  1046d6:	90                   	nop
  1046d7:	90                   	nop
  1046d8:	90                   	nop
  1046d9:	90                   	nop
  1046da:	90                   	nop
  1046db:	90                   	nop
  1046dc:	90                   	nop
  1046dd:	90                   	nop
  1046de:	90                   	nop
  1046df:	90                   	nop

001046e0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1046e0:	55                   	push   %ebp
  1046e1:	89 e5                	mov    %esp,%ebp
  1046e3:	53                   	push   %ebx
  1046e4:	83 ec 14             	sub    $0x14,%esp
  1046e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1046ea:	89 1c 24             	mov    %ebx,(%esp)
  1046ed:	e8 ae ff ff ff       	call   1046a0 <holding>
  1046f2:	85 c0                	test   %eax,%eax
  1046f4:	74 1d                	je     104713 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1046f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1046fd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1046ff:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104706:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104709:	83 c4 14             	add    $0x14,%esp
  10470c:	5b                   	pop    %ebx
  10470d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10470e:	e9 bd fe ff ff       	jmp    1045d0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104713:	c7 04 24 de 6e 10 00 	movl   $0x106ede,(%esp)
  10471a:	e8 51 c2 ff ff       	call   100970 <panic>
  10471f:	90                   	nop

00104720 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104720:	55                   	push   %ebp
  104721:	89 e5                	mov    %esp,%ebp
  104723:	53                   	push   %ebx
  104724:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104727:	e8 24 ff ff ff       	call   104650 <pushcli>
  if(holding(lock))
  10472c:	8b 45 08             	mov    0x8(%ebp),%eax
  10472f:	89 04 24             	mov    %eax,(%esp)
  104732:	e8 69 ff ff ff       	call   1046a0 <holding>
  104737:	85 c0                	test   %eax,%eax
  104739:	75 3d                	jne    104778 <acquire+0x58>
    panic("acquire");
  10473b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10473e:	ba 01 00 00 00       	mov    $0x1,%edx
  104743:	90                   	nop
  104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104748:	89 d0                	mov    %edx,%eax
  10474a:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10474d:	83 f8 01             	cmp    $0x1,%eax
  104750:	74 f6                	je     104748 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  104752:	e8 f9 e3 ff ff       	call   102b50 <cpu>
  104757:	83 c0 0a             	add    $0xa,%eax
  10475a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  10475d:	8b 45 08             	mov    0x8(%ebp),%eax
  104760:	83 c0 0c             	add    $0xc,%eax
  104763:	89 44 24 04          	mov    %eax,0x4(%esp)
  104767:	8d 45 08             	lea    0x8(%ebp),%eax
  10476a:	89 04 24             	mov    %eax,(%esp)
  10476d:	e8 0e fe ff ff       	call   104580 <getcallerpcs>
}
  104772:	83 c4 14             	add    $0x14,%esp
  104775:	5b                   	pop    %ebx
  104776:	5d                   	pop    %ebp
  104777:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104778:	c7 04 24 e6 6e 10 00 	movl   $0x106ee6,(%esp)
  10477f:	e8 ec c1 ff ff       	call   100970 <panic>
  104784:	90                   	nop
  104785:	90                   	nop
  104786:	90                   	nop
  104787:	90                   	nop
  104788:	90                   	nop
  104789:	90                   	nop
  10478a:	90                   	nop
  10478b:	90                   	nop
  10478c:	90                   	nop
  10478d:	90                   	nop
  10478e:	90                   	nop
  10478f:	90                   	nop

00104790 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  104790:	55                   	push   %ebp
  104791:	89 e5                	mov    %esp,%ebp
  104793:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104796:	53                   	push   %ebx
  104797:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10479a:	85 c9                	test   %ecx,%ecx
  10479c:	74 14                	je     1047b2 <memset+0x22>
  10479e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  1047a2:	31 d2                	xor    %edx,%edx
  1047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  1047a8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  1047ab:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1047ae:	39 ca                	cmp    %ecx,%edx
  1047b0:	75 f6                	jne    1047a8 <memset+0x18>
    *d++ = c;

  return dst;
}
  1047b2:	5b                   	pop    %ebx
  1047b3:	5d                   	pop    %ebp
  1047b4:	c3                   	ret    
  1047b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001047c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  1047c0:	55                   	push   %ebp
  1047c1:	89 e5                	mov    %esp,%ebp
  1047c3:	57                   	push   %edi
  1047c4:	56                   	push   %esi
  1047c5:	53                   	push   %ebx
  1047c6:	8b 55 10             	mov    0x10(%ebp),%edx
  1047c9:	8b 75 08             	mov    0x8(%ebp),%esi
  1047cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1047cf:	85 d2                	test   %edx,%edx
  1047d1:	74 2d                	je     104800 <memcmp+0x40>
    if(*s1 != *s2)
  1047d3:	0f b6 1e             	movzbl (%esi),%ebx
  1047d6:	0f b6 0f             	movzbl (%edi),%ecx
  1047d9:	38 cb                	cmp    %cl,%bl
  1047db:	75 2b                	jne    104808 <memcmp+0x48>
      return *s1 - *s2;
  1047dd:	83 ea 01             	sub    $0x1,%edx
  1047e0:	31 c0                	xor    %eax,%eax
  1047e2:	eb 18                	jmp    1047fc <memcmp+0x3c>
  1047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1047e8:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  1047ed:	83 ea 01             	sub    $0x1,%edx
  1047f0:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  1047f5:	83 c0 01             	add    $0x1,%eax
  1047f8:	38 cb                	cmp    %cl,%bl
  1047fa:	75 0c                	jne    104808 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1047fc:	85 d2                	test   %edx,%edx
  1047fe:	75 e8                	jne    1047e8 <memcmp+0x28>
  104800:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104802:	5b                   	pop    %ebx
  104803:	5e                   	pop    %esi
  104804:	5f                   	pop    %edi
  104805:	5d                   	pop    %ebp
  104806:	c3                   	ret    
  104807:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104808:	0f b6 c3             	movzbl %bl,%eax
  10480b:	0f b6 c9             	movzbl %cl,%ecx
  10480e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104810:	5b                   	pop    %ebx
  104811:	5e                   	pop    %esi
  104812:	5f                   	pop    %edi
  104813:	5d                   	pop    %ebp
  104814:	c3                   	ret    
  104815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104820 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104820:	55                   	push   %ebp
  104821:	89 e5                	mov    %esp,%ebp
  104823:	57                   	push   %edi
  104824:	56                   	push   %esi
  104825:	53                   	push   %ebx
  104826:	8b 45 08             	mov    0x8(%ebp),%eax
  104829:	8b 75 0c             	mov    0xc(%ebp),%esi
  10482c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10482f:	39 c6                	cmp    %eax,%esi
  104831:	73 2d                	jae    104860 <memmove+0x40>
  104833:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104836:	39 f8                	cmp    %edi,%eax
  104838:	73 26                	jae    104860 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10483a:	85 db                	test   %ebx,%ebx
  10483c:	74 1d                	je     10485b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10483e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104841:	31 d2                	xor    %edx,%edx
  104843:	90                   	nop
  104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104848:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  10484d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104851:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104854:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104857:	85 c9                	test   %ecx,%ecx
  104859:	75 ed                	jne    104848 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10485b:	5b                   	pop    %ebx
  10485c:	5e                   	pop    %esi
  10485d:	5f                   	pop    %edi
  10485e:	5d                   	pop    %ebp
  10485f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104860:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104862:	85 db                	test   %ebx,%ebx
  104864:	74 f5                	je     10485b <memmove+0x3b>
  104866:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104868:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  10486c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  10486f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104872:	39 d3                	cmp    %edx,%ebx
  104874:	75 f2                	jne    104868 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104876:	5b                   	pop    %ebx
  104877:	5e                   	pop    %esi
  104878:	5f                   	pop    %edi
  104879:	5d                   	pop    %ebp
  10487a:	c3                   	ret    
  10487b:	90                   	nop
  10487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104880 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104880:	55                   	push   %ebp
  104881:	89 e5                	mov    %esp,%ebp
  104883:	57                   	push   %edi
  104884:	56                   	push   %esi
  104885:	53                   	push   %ebx
  104886:	8b 7d 10             	mov    0x10(%ebp),%edi
  104889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10488c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10488f:	85 ff                	test   %edi,%edi
  104891:	74 3d                	je     1048d0 <strncmp+0x50>
  104893:	0f b6 01             	movzbl (%ecx),%eax
  104896:	84 c0                	test   %al,%al
  104898:	75 18                	jne    1048b2 <strncmp+0x32>
  10489a:	eb 3c                	jmp    1048d8 <strncmp+0x58>
  10489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1048a0:	83 ef 01             	sub    $0x1,%edi
  1048a3:	74 2b                	je     1048d0 <strncmp+0x50>
    n--, p++, q++;
  1048a5:	83 c1 01             	add    $0x1,%ecx
  1048a8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048ab:	0f b6 01             	movzbl (%ecx),%eax
  1048ae:	84 c0                	test   %al,%al
  1048b0:	74 26                	je     1048d8 <strncmp+0x58>
  1048b2:	0f b6 33             	movzbl (%ebx),%esi
  1048b5:	89 f2                	mov    %esi,%edx
  1048b7:	38 d0                	cmp    %dl,%al
  1048b9:	74 e5                	je     1048a0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1048bb:	81 e6 ff 00 00 00    	and    $0xff,%esi
  1048c1:	0f b6 c0             	movzbl %al,%eax
  1048c4:	29 f0                	sub    %esi,%eax
}
  1048c6:	5b                   	pop    %ebx
  1048c7:	5e                   	pop    %esi
  1048c8:	5f                   	pop    %edi
  1048c9:	5d                   	pop    %ebp
  1048ca:	c3                   	ret    
  1048cb:	90                   	nop
  1048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048d0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1048d2:	5b                   	pop    %ebx
  1048d3:	5e                   	pop    %esi
  1048d4:	5f                   	pop    %edi
  1048d5:	5d                   	pop    %ebp
  1048d6:	c3                   	ret    
  1048d7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1048d8:	0f b6 33             	movzbl (%ebx),%esi
  1048db:	eb de                	jmp    1048bb <strncmp+0x3b>
  1048dd:	8d 76 00             	lea    0x0(%esi),%esi

001048e0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048e6:	56                   	push   %esi
  1048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1048ea:	53                   	push   %ebx
  1048eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  1048ee:	89 c3                	mov    %eax,%ebx
  1048f0:	eb 09                	jmp    1048fb <strncpy+0x1b>
  1048f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1048f8:	83 c6 01             	add    $0x1,%esi
  1048fb:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  1048fe:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104901:	85 d2                	test   %edx,%edx
  104903:	7e 0c                	jle    104911 <strncpy+0x31>
  104905:	0f b6 16             	movzbl (%esi),%edx
  104908:	88 13                	mov    %dl,(%ebx)
  10490a:	83 c3 01             	add    $0x1,%ebx
  10490d:	84 d2                	test   %dl,%dl
  10490f:	75 e7                	jne    1048f8 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104911:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104913:	85 c9                	test   %ecx,%ecx
  104915:	7e 0c                	jle    104923 <strncpy+0x43>
  104917:	90                   	nop
    *s++ = 0;
  104918:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10491c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10491f:	39 ca                	cmp    %ecx,%edx
  104921:	75 f5                	jne    104918 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104923:	5b                   	pop    %ebx
  104924:	5e                   	pop    %esi
  104925:	5d                   	pop    %ebp
  104926:	c3                   	ret    
  104927:	89 f6                	mov    %esi,%esi
  104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104930 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104930:	55                   	push   %ebp
  104931:	89 e5                	mov    %esp,%ebp
  104933:	8b 55 10             	mov    0x10(%ebp),%edx
  104936:	56                   	push   %esi
  104937:	8b 45 08             	mov    0x8(%ebp),%eax
  10493a:	53                   	push   %ebx
  10493b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10493e:	85 d2                	test   %edx,%edx
  104940:	7e 1f                	jle    104961 <safestrcpy+0x31>
  104942:	89 c1                	mov    %eax,%ecx
  104944:	eb 05                	jmp    10494b <safestrcpy+0x1b>
  104946:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104948:	83 c6 01             	add    $0x1,%esi
  10494b:	83 ea 01             	sub    $0x1,%edx
  10494e:	85 d2                	test   %edx,%edx
  104950:	7e 0c                	jle    10495e <safestrcpy+0x2e>
  104952:	0f b6 1e             	movzbl (%esi),%ebx
  104955:	88 19                	mov    %bl,(%ecx)
  104957:	83 c1 01             	add    $0x1,%ecx
  10495a:	84 db                	test   %bl,%bl
  10495c:	75 ea                	jne    104948 <safestrcpy+0x18>
    ;
  *s = 0;
  10495e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104961:	5b                   	pop    %ebx
  104962:	5e                   	pop    %esi
  104963:	5d                   	pop    %ebp
  104964:	c3                   	ret    
  104965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104970 <strlen>:

int
strlen(const char *s)
{
  104970:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104971:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104973:	89 e5                	mov    %esp,%ebp
  104975:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104978:	80 3a 00             	cmpb   $0x0,(%edx)
  10497b:	74 0c                	je     104989 <strlen+0x19>
  10497d:	8d 76 00             	lea    0x0(%esi),%esi
  104980:	83 c0 01             	add    $0x1,%eax
  104983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104987:	75 f7                	jne    104980 <strlen+0x10>
    ;
  return n;
}
  104989:	5d                   	pop    %ebp
  10498a:	c3                   	ret    
  10498b:	90                   	nop

0010498c <swtch>:
  10498c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104990:	8f 00                	popl   (%eax)
  104992:	89 60 04             	mov    %esp,0x4(%eax)
  104995:	89 58 08             	mov    %ebx,0x8(%eax)
  104998:	89 48 0c             	mov    %ecx,0xc(%eax)
  10499b:	89 50 10             	mov    %edx,0x10(%eax)
  10499e:	89 70 14             	mov    %esi,0x14(%eax)
  1049a1:	89 78 18             	mov    %edi,0x18(%eax)
  1049a4:	89 68 1c             	mov    %ebp,0x1c(%eax)
  1049a7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1049ab:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1049ae:	8b 78 18             	mov    0x18(%eax),%edi
  1049b1:	8b 70 14             	mov    0x14(%eax),%esi
  1049b4:	8b 50 10             	mov    0x10(%eax),%edx
  1049b7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1049ba:	8b 58 08             	mov    0x8(%eax),%ebx
  1049bd:	8b 60 04             	mov    0x4(%eax),%esp
  1049c0:	ff 30                	pushl  (%eax)
  1049c2:	c3                   	ret    
  1049c3:	90                   	nop
  1049c4:	90                   	nop
  1049c5:	90                   	nop
  1049c6:	90                   	nop
  1049c7:	90                   	nop
  1049c8:	90                   	nop
  1049c9:	90                   	nop
  1049ca:	90                   	nop
  1049cb:	90                   	nop
  1049cc:	90                   	nop
  1049cd:	90                   	nop
  1049ce:	90                   	nop
  1049cf:	90                   	nop

001049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1049d0:	55                   	push   %ebp
  1049d1:	89 e5                	mov    %esp,%ebp
  1049d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1049d6:	53                   	push   %ebx
  1049d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  1049da:	8b 51 04             	mov    0x4(%ecx),%edx
  1049dd:	39 c2                	cmp    %eax,%edx
  1049df:	77 0f                	ja     1049f0 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1049e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1049e6:	5b                   	pop    %ebx
  1049e7:	5d                   	pop    %ebp
  1049e8:	c3                   	ret    
  1049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1049f0:	8d 58 04             	lea    0x4(%eax),%ebx
  1049f3:	39 da                	cmp    %ebx,%edx
  1049f5:	72 ea                	jb     1049e1 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1049f7:	8b 11                	mov    (%ecx),%edx
  1049f9:	8b 14 02             	mov    (%edx,%eax,1),%edx
  1049fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1049ff:	89 10                	mov    %edx,(%eax)
  104a01:	31 c0                	xor    %eax,%eax
  return 0;
  104a03:	eb e1                	jmp    1049e6 <fetchint+0x16>
  104a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104a10:	55                   	push   %ebp
  104a11:	89 e5                	mov    %esp,%ebp
  104a13:	8b 45 08             	mov    0x8(%ebp),%eax
  104a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a19:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  104a1a:	39 50 04             	cmp    %edx,0x4(%eax)
  104a1d:	77 09                	ja     104a28 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104a24:	5b                   	pop    %ebx
  104a25:	5d                   	pop    %ebp
  104a26:	c3                   	ret    
  104a27:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104a2b:	03 10                	add    (%eax),%edx
  104a2d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  104a2f:	8b 18                	mov    (%eax),%ebx
  104a31:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104a34:	39 da                	cmp    %ebx,%edx
  104a36:	73 e7                	jae    104a1f <fetchstr+0xf>
    if(*s == 0)
  104a38:	31 c0                	xor    %eax,%eax
  104a3a:	89 d1                	mov    %edx,%ecx
  104a3c:	80 3a 00             	cmpb   $0x0,(%edx)
  104a3f:	74 e3                	je     104a24 <fetchstr+0x14>
  104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104a48:	83 c1 01             	add    $0x1,%ecx
  104a4b:	39 cb                	cmp    %ecx,%ebx
  104a4d:	76 d0                	jbe    104a1f <fetchstr+0xf>
    if(*s == 0)
  104a4f:	80 39 00             	cmpb   $0x0,(%ecx)
  104a52:	75 f4                	jne    104a48 <fetchstr+0x38>
  104a54:	89 c8                	mov    %ecx,%eax
  104a56:	29 d0                	sub    %edx,%eax
  104a58:	eb ca                	jmp    104a24 <fetchstr+0x14>
  104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104a60 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104a60:	55                   	push   %ebp
  104a61:	89 e5                	mov    %esp,%ebp
  104a63:	53                   	push   %ebx
  104a64:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104a67:	e8 74 ec ff ff       	call   1036e0 <curproc>
  104a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  104a6f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a75:	8b 40 3c             	mov    0x3c(%eax),%eax
  104a78:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  104a7c:	e8 5f ec ff ff       	call   1036e0 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104a81:	8b 50 04             	mov    0x4(%eax),%edx
  104a84:	39 d3                	cmp    %edx,%ebx
  104a86:	72 10                	jb     104a98 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  104a8d:	83 c4 04             	add    $0x4,%esp
  104a90:	5b                   	pop    %ebx
  104a91:	5d                   	pop    %ebp
  104a92:	c3                   	ret    
  104a93:	90                   	nop
  104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104a98:	8d 4b 04             	lea    0x4(%ebx),%ecx
  104a9b:	39 ca                	cmp    %ecx,%edx
  104a9d:	72 e9                	jb     104a88 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104a9f:	8b 00                	mov    (%eax),%eax
  104aa1:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  104aa7:	89 10                	mov    %edx,(%eax)
  104aa9:	31 c0                	xor    %eax,%eax
  104aab:	eb e0                	jmp    104a8d <argint+0x2d>
  104aad:	8d 76 00             	lea    0x0(%esi),%esi

00104ab0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104ab0:	55                   	push   %ebp
  104ab1:	89 e5                	mov    %esp,%ebp
  104ab3:	53                   	push   %ebx
  104ab4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104aba:	89 44 24 04          	mov    %eax,0x4(%esp)
  104abe:	8b 45 08             	mov    0x8(%ebp),%eax
  104ac1:	89 04 24             	mov    %eax,(%esp)
  104ac4:	e8 97 ff ff ff       	call   104a60 <argint>
  104ac9:	85 c0                	test   %eax,%eax
  104acb:	78 3b                	js     104b08 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  104acd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ad0:	e8 0b ec ff ff       	call   1036e0 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104ad5:	3b 58 04             	cmp    0x4(%eax),%ebx
  104ad8:	73 2e                	jae    104b08 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  104ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  104add:	03 18                	add    (%eax),%ebx
  104adf:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104ae1:	8b 08                	mov    (%eax),%ecx
  104ae3:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104ae6:	39 cb                	cmp    %ecx,%ebx
  104ae8:	73 1e                	jae    104b08 <argstr+0x58>
    if(*s == 0)
  104aea:	31 c0                	xor    %eax,%eax
  104aec:	89 da                	mov    %ebx,%edx
  104aee:	80 3b 00             	cmpb   $0x0,(%ebx)
  104af1:	75 0a                	jne    104afd <argstr+0x4d>
  104af3:	eb 18                	jmp    104b0d <argstr+0x5d>
  104af5:	8d 76 00             	lea    0x0(%esi),%esi
  104af8:	80 3a 00             	cmpb   $0x0,(%edx)
  104afb:	74 1b                	je     104b18 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104afd:	83 c2 01             	add    $0x1,%edx
  104b00:	39 d1                	cmp    %edx,%ecx
  104b02:	77 f4                	ja     104af8 <argstr+0x48>
  104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b0d:	83 c4 24             	add    $0x24,%esp
  104b10:	5b                   	pop    %ebx
  104b11:	5d                   	pop    %ebp
  104b12:	c3                   	ret    
  104b13:	90                   	nop
  104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104b18:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b1a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104b1d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  104b1f:	5b                   	pop    %ebx
  104b20:	5d                   	pop    %ebp
  104b21:	c3                   	ret    
  104b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	53                   	push   %ebx
  104b34:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  104b41:	89 04 24             	mov    %eax,(%esp)
  104b44:	e8 17 ff ff ff       	call   104a60 <argint>
  104b49:	85 c0                	test   %eax,%eax
  104b4b:	79 0b                	jns    104b58 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  104b4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b52:	83 c4 24             	add    $0x24,%esp
  104b55:	5b                   	pop    %ebx
  104b56:	5d                   	pop    %ebp
  104b57:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104b58:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b5b:	e8 80 eb ff ff       	call   1036e0 <curproc>
  104b60:	3b 58 04             	cmp    0x4(%eax),%ebx
  104b63:	73 e8                	jae    104b4d <argptr+0x1d>
  104b65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104b68:	03 5d f4             	add    -0xc(%ebp),%ebx
  104b6b:	e8 70 eb ff ff       	call   1036e0 <curproc>
  104b70:	3b 58 04             	cmp    0x4(%eax),%ebx
  104b73:	73 d8                	jae    104b4d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104b75:	e8 66 eb ff ff       	call   1036e0 <curproc>
  104b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  104b7d:	8b 00                	mov    (%eax),%eax
  104b7f:	03 45 f4             	add    -0xc(%ebp),%eax
  104b82:	89 02                	mov    %eax,(%edx)
  104b84:	31 c0                	xor    %eax,%eax
  return 0;
  104b86:	eb ca                	jmp    104b52 <argptr+0x22>
  104b88:	90                   	nop
  104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104b90 <syscall>:
[SYS_check]			sys_check,
};

void
syscall(void)
{
  104b90:	55                   	push   %ebp
  104b91:	89 e5                	mov    %esp,%ebp
  104b93:	83 ec 18             	sub    $0x18,%esp
  104b96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104b99:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  104b9c:	e8 3f eb ff ff       	call   1036e0 <curproc>
  104ba1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104ba7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104baa:	83 fb 1b             	cmp    $0x1b,%ebx
  104bad:	77 29                	ja     104bd8 <syscall+0x48>
  104baf:	8b 34 9d 20 6f 10 00 	mov    0x106f20(,%ebx,4),%esi
  104bb6:	85 f6                	test   %esi,%esi
  104bb8:	74 1e                	je     104bd8 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  104bba:	e8 21 eb ff ff       	call   1036e0 <curproc>
  104bbf:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104bc5:	ff d6                	call   *%esi
  104bc7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104bca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104bcd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104bd0:	89 ec                	mov    %ebp,%esp
  104bd2:	5d                   	pop    %ebp
  104bd3:	c3                   	ret    
  104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104bd8:	e8 03 eb ff ff       	call   1036e0 <curproc>
  104bdd:	89 c6                	mov    %eax,%esi
  104bdf:	e8 fc ea ff ff       	call   1036e0 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104be4:	81 c6 88 00 00 00    	add    $0x88,%esi
  104bea:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104bee:	89 74 24 08          	mov    %esi,0x8(%esp)
  104bf2:	8b 40 10             	mov    0x10(%eax),%eax
  104bf5:	c7 04 24 ee 6e 10 00 	movl   $0x106eee,(%esp)
  104bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c00:	e8 cb bb ff ff       	call   1007d0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104c05:	e8 d6 ea ff ff       	call   1036e0 <curproc>
  104c0a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104c10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104c17:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104c1a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104c1d:	89 ec                	mov    %ebp,%esp
  104c1f:	5d                   	pop    %ebp
  104c20:	c3                   	ret    
  104c21:	90                   	nop
  104c22:	90                   	nop
  104c23:	90                   	nop
  104c24:	90                   	nop
  104c25:	90                   	nop
  104c26:	90                   	nop
  104c27:	90                   	nop
  104c28:	90                   	nop
  104c29:	90                   	nop
  104c2a:	90                   	nop
  104c2b:	90                   	nop
  104c2c:	90                   	nop
  104c2d:	90                   	nop
  104c2e:	90                   	nop
  104c2f:	90                   	nop

00104c30 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104c30:	55                   	push   %ebp
  104c31:	89 e5                	mov    %esp,%ebp
  104c33:	57                   	push   %edi
  104c34:	89 c7                	mov    %eax,%edi
  104c36:	56                   	push   %esi
  104c37:	53                   	push   %ebx
  104c38:	31 db                	xor    %ebx,%ebx
  104c3a:	83 ec 0c             	sub    $0xc,%esp
  104c3d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104c40:	e8 9b ea ff ff       	call   1036e0 <curproc>
  104c45:	8d 73 08             	lea    0x8(%ebx),%esi
  104c48:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  104c4b:	85 c0                	test   %eax,%eax
  104c4d:	74 19                	je     104c68 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104c4f:	83 c3 01             	add    $0x1,%ebx
  104c52:	83 fb 10             	cmp    $0x10,%ebx
  104c55:	75 e9                	jne    104c40 <fdalloc+0x10>
  104c57:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104c5c:	83 c4 0c             	add    $0xc,%esp
  104c5f:	89 d8                	mov    %ebx,%eax
  104c61:	5b                   	pop    %ebx
  104c62:	5e                   	pop    %esi
  104c63:	5f                   	pop    %edi
  104c64:	5d                   	pop    %ebp
  104c65:	c3                   	ret    
  104c66:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104c68:	e8 73 ea ff ff       	call   1036e0 <curproc>
  104c6d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  104c70:	83 c4 0c             	add    $0xc,%esp
  104c73:	89 d8                	mov    %ebx,%eax
  104c75:	5b                   	pop    %ebx
  104c76:	5e                   	pop    %esi
  104c77:	5f                   	pop    %edi
  104c78:	5d                   	pop    %ebp
  104c79:	c3                   	ret    
  104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c80 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104c80:	55                   	push   %ebp
  104c81:	89 e5                	mov    %esp,%ebp
  104c83:	53                   	push   %ebx
  104c84:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c8a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104c91:	00 
  104c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c9d:	e8 8e fe ff ff       	call   104b30 <argptr>
  104ca2:	85 c0                	test   %eax,%eax
  104ca4:	79 12                	jns    104cb8 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104cab:	83 c4 24             	add    $0x24,%esp
  104cae:	5b                   	pop    %ebx
  104caf:	5d                   	pop    %ebp
  104cb0:	c3                   	ret    
  104cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104cb8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104cc2:	89 04 24             	mov    %eax,(%esp)
  104cc5:	e8 66 e6 ff ff       	call   103330 <pipealloc>
  104cca:	85 c0                	test   %eax,%eax
  104ccc:	78 d8                	js     104ca6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd1:	e8 5a ff ff ff       	call   104c30 <fdalloc>
  104cd6:	85 c0                	test   %eax,%eax
  104cd8:	89 c3                	mov    %eax,%ebx
  104cda:	78 25                	js     104d01 <sys_pipe+0x81>
  104cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cdf:	e8 4c ff ff ff       	call   104c30 <fdalloc>
  104ce4:	85 c0                	test   %eax,%eax
  104ce6:	78 0c                	js     104cf4 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104ce8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  104ceb:	89 42 04             	mov    %eax,0x4(%edx)
  104cee:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104cf0:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104cf2:	eb b7                	jmp    104cab <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104cf4:	e8 e7 e9 ff ff       	call   1036e0 <curproc>
  104cf9:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104d00:	00 
    fileclose(rf);
  104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d04:	89 04 24             	mov    %eax,(%esp)
  104d07:	e8 e4 c3 ff ff       	call   1010f0 <fileclose>
    fileclose(wf);
  104d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d0f:	89 04 24             	mov    %eax,(%esp)
  104d12:	e8 d9 c3 ff ff       	call   1010f0 <fileclose>
  104d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104d1c:	eb 8d                	jmp    104cab <sys_pipe+0x2b>
  104d1e:	66 90                	xchg   %ax,%ax

00104d20 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104d20:	55                   	push   %ebp
  104d21:	89 e5                	mov    %esp,%ebp
  104d23:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d29:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104d2c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104d2f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104d32:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d40:	e8 6b fd ff ff       	call   104ab0 <argstr>
  104d45:	85 c0                	test   %eax,%eax
  104d47:	79 17                	jns    104d60 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104d4e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d51:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104d54:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104d57:	89 ec                	mov    %ebp,%esp
  104d59:	5d                   	pop    %ebp
  104d5a:	c3                   	ret    
  104d5b:	90                   	nop
  104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d60:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d6e:	e8 ed fc ff ff       	call   104a60 <argint>
  104d73:	85 c0                	test   %eax,%eax
  104d75:	78 d2                	js     104d49 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  104d77:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104d7a:	31 ff                	xor    %edi,%edi
  104d7c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104d83:	00 
  104d84:	31 db                	xor    %ebx,%ebx
  104d86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d8d:	00 
  104d8e:	89 04 24             	mov    %eax,(%esp)
  104d91:	e8 fa f9 ff ff       	call   104790 <memset>
  104d96:	eb 27                	jmp    104dbf <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104d98:	e8 43 e9 ff ff       	call   1036e0 <curproc>
  104d9d:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104da1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104da5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104da9:	89 04 24             	mov    %eax,(%esp)
  104dac:	e8 5f fc ff ff       	call   104a10 <fetchstr>
  104db1:	85 c0                	test   %eax,%eax
  104db3:	78 94                	js     104d49 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104db5:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104db8:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104dbb:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  104dbd:	74 8a                	je     104d49 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104dbf:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104dc6:	03 75 e0             	add    -0x20(%ebp),%esi
  104dc9:	e8 12 e9 ff ff       	call   1036e0 <curproc>
  104dce:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104dd1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104dd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104dd9:	89 04 24             	mov    %eax,(%esp)
  104ddc:	e8 ef fb ff ff       	call   1049d0 <fetchint>
  104de1:	85 c0                	test   %eax,%eax
  104de3:	0f 88 60 ff ff ff    	js     104d49 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104de9:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104dec:	85 f6                	test   %esi,%esi
  104dee:	75 a8                	jne    104d98 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104df0:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104dfa:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104e01:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104e02:	89 04 24             	mov    %eax,(%esp)
  104e05:	e8 e6 bb ff ff       	call   1009f0 <exec>
  104e0a:	e9 3f ff ff ff       	jmp    104d4e <sys_exec+0x2e>
  104e0f:	90                   	nop

00104e10 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104e10:	55                   	push   %ebp
  104e11:	89 e5                	mov    %esp,%ebp
  104e13:	53                   	push   %ebx
  104e14:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e25:	e8 86 fc ff ff       	call   104ab0 <argstr>
  104e2a:	85 c0                	test   %eax,%eax
  104e2c:	79 12                	jns    104e40 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104e2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e33:	83 c4 24             	add    $0x24,%esp
  104e36:	5b                   	pop    %ebx
  104e37:	5d                   	pop    %ebp
  104e38:	c3                   	ret    
  104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e43:	89 04 24             	mov    %eax,(%esp)
  104e46:	e8 a5 d3 ff ff       	call   1021f0 <namei>
  104e4b:	85 c0                	test   %eax,%eax
  104e4d:	89 c3                	mov    %eax,%ebx
  104e4f:	74 dd                	je     104e2e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104e51:	89 04 24             	mov    %eax,(%esp)
  104e54:	e8 d7 d0 ff ff       	call   101f30 <ilock>
  if(ip->type != T_DIR){
  104e59:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104e5e:	75 24                	jne    104e84 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104e60:	89 1c 24             	mov    %ebx,(%esp)
  104e63:	e8 58 d0 ff ff       	call   101ec0 <iunlock>
  iput(cp->cwd);
  104e68:	e8 73 e8 ff ff       	call   1036e0 <curproc>
  104e6d:	8b 40 60             	mov    0x60(%eax),%eax
  104e70:	89 04 24             	mov    %eax,(%esp)
  104e73:	e8 68 cd ff ff       	call   101be0 <iput>
  cp->cwd = ip;
  104e78:	e8 63 e8 ff ff       	call   1036e0 <curproc>
  104e7d:	89 58 60             	mov    %ebx,0x60(%eax)
  104e80:	31 c0                	xor    %eax,%eax
  return 0;
  104e82:	eb af                	jmp    104e33 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104e84:	89 1c 24             	mov    %ebx,(%esp)
  104e87:	e8 84 d0 ff ff       	call   101f10 <iunlockput>
  104e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104e91:	eb a0                	jmp    104e33 <sys_chdir+0x23>
  104e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104ea0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104ea0:	55                   	push   %ebp
  104ea1:	89 e5                	mov    %esp,%ebp
  104ea3:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ea6:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104ea9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104eac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104eaf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104eb6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ebd:	e8 ee fb ff ff       	call   104ab0 <argstr>
  104ec2:	85 c0                	test   %eax,%eax
  104ec4:	79 12                	jns    104ed8 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ecb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ece:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104ed1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104ed4:	89 ec                	mov    %ebp,%esp
  104ed6:	5d                   	pop    %ebp
  104ed7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ed8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104edf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ee6:	e8 c5 fb ff ff       	call   104ab0 <argstr>
  104eeb:	85 c0                	test   %eax,%eax
  104eed:	78 d7                	js     104ec6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104eef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ef2:	89 04 24             	mov    %eax,(%esp)
  104ef5:	e8 f6 d2 ff ff       	call   1021f0 <namei>
  104efa:	85 c0                	test   %eax,%eax
  104efc:	89 c3                	mov    %eax,%ebx
  104efe:	74 c6                	je     104ec6 <sys_link+0x26>
    return -1;
  ilock(ip);
  104f00:	89 04 24             	mov    %eax,(%esp)
  104f03:	e8 28 d0 ff ff       	call   101f30 <ilock>
  if(ip->type == T_DIR){
  104f08:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104f0d:	0f 84 86 00 00 00    	je     104f99 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104f13:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104f18:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104f1b:	89 1c 24             	mov    %ebx,(%esp)
  104f1e:	e8 ed c7 ff ff       	call   101710 <iupdate>
  iunlock(ip);
  104f23:	89 1c 24             	mov    %ebx,(%esp)
  104f26:	e8 95 cf ff ff       	call   101ec0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f32:	89 04 24             	mov    %eax,(%esp)
  104f35:	e8 96 d2 ff ff       	call   1021d0 <nameiparent>
  104f3a:	85 c0                	test   %eax,%eax
  104f3c:	89 c6                	mov    %eax,%esi
  104f3e:	74 44                	je     104f84 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  104f40:	89 04 24             	mov    %eax,(%esp)
  104f43:	e8 e8 cf ff ff       	call   101f30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104f48:	8b 06                	mov    (%esi),%eax
  104f4a:	3b 03                	cmp    (%ebx),%eax
  104f4c:	75 2e                	jne    104f7c <sys_link+0xdc>
  104f4e:	8b 43 04             	mov    0x4(%ebx),%eax
  104f51:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f55:	89 34 24             	mov    %esi,(%esp)
  104f58:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f5c:	e8 6f ce ff ff       	call   101dd0 <dirlink>
  104f61:	85 c0                	test   %eax,%eax
  104f63:	78 17                	js     104f7c <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  104f65:	89 34 24             	mov    %esi,(%esp)
  104f68:	e8 a3 cf ff ff       	call   101f10 <iunlockput>
  iput(ip);
  104f6d:	89 1c 24             	mov    %ebx,(%esp)
  104f70:	e8 6b cc ff ff       	call   101be0 <iput>
  104f75:	31 c0                	xor    %eax,%eax
  return 0;
  104f77:	e9 4f ff ff ff       	jmp    104ecb <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  104f7c:	89 34 24             	mov    %esi,(%esp)
  104f7f:	e8 8c cf ff ff       	call   101f10 <iunlockput>
  ilock(ip);
  104f84:	89 1c 24             	mov    %ebx,(%esp)
  104f87:	e8 a4 cf ff ff       	call   101f30 <ilock>
  ip->nlink--;
  104f8c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104f91:	89 1c 24             	mov    %ebx,(%esp)
  104f94:	e8 77 c7 ff ff       	call   101710 <iupdate>
  iunlockput(ip);
  104f99:	89 1c 24             	mov    %ebx,(%esp)
  104f9c:	e8 6f cf ff ff       	call   101f10 <iunlockput>
  104fa1:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104fa4:	e9 22 ff ff ff       	jmp    104ecb <sys_link+0x2b>
  104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104fb0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fb0:	55                   	push   %ebp
  104fb1:	89 e5                	mov    %esp,%ebp
  104fb3:	57                   	push   %edi
  104fb4:	89 cf                	mov    %ecx,%edi
  104fb6:	56                   	push   %esi
  104fb7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fb8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fba:	83 ec 4c             	sub    $0x4c,%esp
  104fbd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104fc0:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fc4:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fc7:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  104fcb:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104fcf:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fd3:	89 74 24 04          	mov    %esi,0x4(%esp)
  104fd7:	89 04 24             	mov    %eax,(%esp)
  104fda:	e8 f1 d1 ff ff       	call   1021d0 <nameiparent>
  104fdf:	85 c0                	test   %eax,%eax
  104fe1:	74 67                	je     10504a <create+0x9a>
    return 0;
  ilock(dp);
  104fe3:	89 04 24             	mov    %eax,(%esp)
  104fe6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104fe9:	e8 42 cf ff ff       	call   101f30 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104fee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104ff1:	85 d2                	test   %edx,%edx
  104ff3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ff6:	74 60                	je     105058 <create+0xa8>
  104ff8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104ffb:	89 14 24             	mov    %edx,(%esp)
  104ffe:	89 44 24 08          	mov    %eax,0x8(%esp)
  105002:	89 74 24 04          	mov    %esi,0x4(%esp)
  105006:	e8 f5 c8 ff ff       	call   101900 <dirlookup>
  10500b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10500e:	85 c0                	test   %eax,%eax
  105010:	89 c3                	mov    %eax,%ebx
  105012:	74 44                	je     105058 <create+0xa8>
    iunlockput(dp);
  105014:	89 14 24             	mov    %edx,(%esp)
  105017:	e8 f4 ce ff ff       	call   101f10 <iunlockput>
    ilock(ip);
  10501c:	89 1c 24             	mov    %ebx,(%esp)
  10501f:	e8 0c cf ff ff       	call   101f30 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105024:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  105028:	0f 85 02 01 00 00    	jne    105130 <create+0x180>
  10502e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  105032:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105036:	0f 85 f4 00 00 00    	jne    105130 <create+0x180>
  10503c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  105040:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  105044:	0f 85 e6 00 00 00    	jne    105130 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10504a:	83 c4 4c             	add    $0x4c,%esp
  10504d:	89 d8                	mov    %ebx,%eax
  10504f:	5b                   	pop    %ebx
  105050:	5e                   	pop    %esi
  105051:	5f                   	pop    %edi
  105052:	5d                   	pop    %ebp
  105053:	c3                   	ret    
  105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105058:	0f bf c7             	movswl %di,%eax
  10505b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10505f:	8b 02                	mov    (%edx),%eax
  105061:	89 04 24             	mov    %eax,(%esp)
  105064:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105067:	e8 e4 c9 ff ff       	call   101a50 <ialloc>
  10506c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10506f:	85 c0                	test   %eax,%eax
  105071:	89 c3                	mov    %eax,%ebx
  105073:	74 50                	je     1050c5 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105075:	89 04 24             	mov    %eax,(%esp)
  105078:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10507b:	e8 b0 ce ff ff       	call   101f30 <ilock>
  ip->major = major;
  105080:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  105084:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  10508a:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10508e:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  105092:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105096:	89 1c 24             	mov    %ebx,(%esp)
  105099:	e8 72 c6 ff ff       	call   101710 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  10509e:	8b 43 04             	mov    0x4(%ebx),%eax
  1050a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  1050a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050a9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1050ac:	89 14 24             	mov    %edx,(%esp)
  1050af:	e8 1c cd ff ff       	call   101dd0 <dirlink>
  1050b4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1050b7:	85 c0                	test   %eax,%eax
  1050b9:	0f 88 85 00 00 00    	js     105144 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  1050bf:	66 83 ff 01          	cmp    $0x1,%di
  1050c3:	74 13                	je     1050d8 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  1050c5:	89 14 24             	mov    %edx,(%esp)
  1050c8:	e8 43 ce ff ff       	call   101f10 <iunlockput>
  return ip;
}
  1050cd:	83 c4 4c             	add    $0x4c,%esp
  1050d0:	89 d8                	mov    %ebx,%eax
  1050d2:	5b                   	pop    %ebx
  1050d3:	5e                   	pop    %esi
  1050d4:	5f                   	pop    %edi
  1050d5:	5d                   	pop    %ebp
  1050d6:	c3                   	ret    
  1050d7:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1050d8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  1050dd:	89 14 24             	mov    %edx,(%esp)
  1050e0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1050e3:	e8 28 c6 ff ff       	call   101710 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1050e8:	8b 43 04             	mov    0x4(%ebx),%eax
  1050eb:	c7 44 24 04 91 6f 10 	movl   $0x106f91,0x4(%esp)
  1050f2:	00 
  1050f3:	89 1c 24             	mov    %ebx,(%esp)
  1050f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050fa:	e8 d1 cc ff ff       	call   101dd0 <dirlink>
  1050ff:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105102:	85 c0                	test   %eax,%eax
  105104:	78 1e                	js     105124 <create+0x174>
  105106:	8b 42 04             	mov    0x4(%edx),%eax
  105109:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  105110:	00 
  105111:	89 1c 24             	mov    %ebx,(%esp)
  105114:	89 44 24 08          	mov    %eax,0x8(%esp)
  105118:	e8 b3 cc ff ff       	call   101dd0 <dirlink>
  10511d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105120:	85 c0                	test   %eax,%eax
  105122:	79 a1                	jns    1050c5 <create+0x115>
      panic("create dots");
  105124:	c7 04 24 93 6f 10 00 	movl   $0x106f93,(%esp)
  10512b:	e8 40 b8 ff ff       	call   100970 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  105130:	89 1c 24             	mov    %ebx,(%esp)
  105133:	31 db                	xor    %ebx,%ebx
  105135:	e8 d6 cd ff ff       	call   101f10 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  10513a:	83 c4 4c             	add    $0x4c,%esp
  10513d:	89 d8                	mov    %ebx,%eax
  10513f:	5b                   	pop    %ebx
  105140:	5e                   	pop    %esi
  105141:	5f                   	pop    %edi
  105142:	5d                   	pop    %ebp
  105143:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105144:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  10514a:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10514d:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10514f:	e8 bc cd ff ff       	call   101f10 <iunlockput>
    iunlockput(dp);
  105154:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105157:	89 14 24             	mov    %edx,(%esp)
  10515a:	e8 b1 cd ff ff       	call   101f10 <iunlockput>
    return 0;
  10515f:	e9 e6 fe ff ff       	jmp    10504a <create+0x9a>
  105164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10516a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105170 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105170:	55                   	push   %ebp
  105171:	89 e5                	mov    %esp,%ebp
  105173:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105176:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105179:	89 44 24 04          	mov    %eax,0x4(%esp)
  10517d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105184:	e8 27 f9 ff ff       	call   104ab0 <argstr>
  105189:	85 c0                	test   %eax,%eax
  10518b:	79 0b                	jns    105198 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  10518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105192:	c9                   	leave  
  105193:	c3                   	ret    
  105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10519f:	00 
  1051a0:	31 d2                	xor    %edx,%edx
  1051a2:	b9 01 00 00 00       	mov    $0x1,%ecx
  1051a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051b1:	e8 fa fd ff ff       	call   104fb0 <create>
  1051b6:	85 c0                	test   %eax,%eax
  1051b8:	74 d3                	je     10518d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1051ba:	89 04 24             	mov    %eax,(%esp)
  1051bd:	e8 4e cd ff ff       	call   101f10 <iunlockput>
  1051c2:	31 c0                	xor    %eax,%eax
  return 0;
}
  1051c4:	c9                   	leave  
  1051c5:	c3                   	ret    
  1051c6:	8d 76 00             	lea    0x0(%esi),%esi
  1051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001051d0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1051d0:	55                   	push   %ebp
  1051d1:	89 e5                	mov    %esp,%ebp
  1051d3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1051d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1051d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051e4:	e8 c7 f8 ff ff       	call   104ab0 <argstr>
  1051e9:	85 c0                	test   %eax,%eax
  1051eb:	79 0b                	jns    1051f8 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1051ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1051f2:	c9                   	leave  
  1051f3:	c3                   	ret    
  1051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  1051f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1051fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105206:	e8 55 f8 ff ff       	call   104a60 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10520b:	85 c0                	test   %eax,%eax
  10520d:	78 de                	js     1051ed <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  10520f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105212:	89 44 24 04          	mov    %eax,0x4(%esp)
  105216:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10521d:	e8 3e f8 ff ff       	call   104a60 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105222:	85 c0                	test   %eax,%eax
  105224:	78 c7                	js     1051ed <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  105226:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  10522a:	31 d2                	xor    %edx,%edx
  10522c:	b9 03 00 00 00       	mov    $0x3,%ecx
  105231:	89 44 24 04          	mov    %eax,0x4(%esp)
  105235:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  105239:	89 04 24             	mov    %eax,(%esp)
  10523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10523f:	e8 6c fd ff ff       	call   104fb0 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105244:	85 c0                	test   %eax,%eax
  105246:	74 a5                	je     1051ed <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105248:	89 04 24             	mov    %eax,(%esp)
  10524b:	e8 c0 cc ff ff       	call   101f10 <iunlockput>
  105250:	31 c0                	xor    %eax,%eax
  return 0;
}
  105252:	c9                   	leave  
  105253:	c3                   	ret    
  105254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10525a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105260 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105260:	55                   	push   %ebp
  105261:	89 e5                	mov    %esp,%ebp
  105263:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105266:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105269:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10526c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10526f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10527a:	e8 31 f8 ff ff       	call   104ab0 <argstr>
  10527f:	85 c0                	test   %eax,%eax
  105281:	79 15                	jns    105298 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105288:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10528b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10528e:	89 ec                	mov    %ebp,%esp
  105290:	5d                   	pop    %ebp
  105291:	c3                   	ret    
  105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105298:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10529b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10529f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052a6:	e8 b5 f7 ff ff       	call   104a60 <argint>
  1052ab:	85 c0                	test   %eax,%eax
  1052ad:	78 d4                	js     105283 <sys_open+0x23>
    return -1;

  if(omode & O_CREATE){
  1052af:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  1052b3:	74 7b                	je     105330 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  1052b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052b8:	b9 02 00 00 00       	mov    $0x2,%ecx
  1052bd:	ba 01 00 00 00       	mov    $0x1,%edx
  1052c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052c9:	00 
  1052ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052d1:	e8 da fc ff ff       	call   104fb0 <create>
  1052d6:	85 c0                	test   %eax,%eax
  1052d8:	89 c6                	mov    %eax,%esi
  1052da:	74 a7                	je     105283 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1052dc:	e8 7f bd ff ff       	call   101060 <filealloc>
  1052e1:	85 c0                	test   %eax,%eax
  1052e3:	89 c3                	mov    %eax,%ebx
  1052e5:	74 73                	je     10535a <sys_open+0xfa>
  1052e7:	e8 44 f9 ff ff       	call   104c30 <fdalloc>
  1052ec:	85 c0                	test   %eax,%eax
  1052ee:	66 90                	xchg   %ax,%ax
  1052f0:	78 7d                	js     10536f <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1052f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052f5:	89 34 24             	mov    %esi,(%esp)
  1052f8:	e8 c3 cb ff ff       	call   101ec0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1052fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  105300:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  105306:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  105309:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  105310:	89 d1                	mov    %edx,%ecx
  105312:	83 f1 01             	xor    $0x1,%ecx
  105315:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105318:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10531b:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10531e:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105325:	e9 5e ff ff ff       	jmp    105288 <sys_open+0x28>
  10532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105333:	89 04 24             	mov    %eax,(%esp)
  105336:	e8 b5 ce ff ff       	call   1021f0 <namei>
  10533b:	85 c0                	test   %eax,%eax
  10533d:	89 c6                	mov    %eax,%esi
  10533f:	0f 84 3e ff ff ff    	je     105283 <sys_open+0x23>
      return -1;
    ilock(ip);
  105345:	89 04 24             	mov    %eax,(%esp)
  105348:	e8 e3 cb ff ff       	call   101f30 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  10534d:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105352:	75 88                	jne    1052dc <sys_open+0x7c>
  105354:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  105358:	74 82                	je     1052dc <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  10535a:	89 34 24             	mov    %esi,(%esp)
  10535d:	8d 76 00             	lea    0x0(%esi),%esi
  105360:	e8 ab cb ff ff       	call   101f10 <iunlockput>
  105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  10536a:	e9 19 ff ff ff       	jmp    105288 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10536f:	89 1c 24             	mov    %ebx,(%esp)
  105372:	e8 79 bd ff ff       	call   1010f0 <fileclose>
  105377:	eb e1                	jmp    10535a <sys_open+0xfa>
  105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105380 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105380:	55                   	push   %ebp
  105381:	89 e5                	mov    %esp,%ebp
  105383:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105386:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105389:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10538c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10538f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105392:	89 44 24 04          	mov    %eax,0x4(%esp)
  105396:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10539d:	e8 0e f7 ff ff       	call   104ab0 <argstr>
  1053a2:	85 c0                	test   %eax,%eax
  1053a4:	79 12                	jns    1053b8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1053a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1053ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1053ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1053b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1053b4:	89 ec                	mov    %ebp,%esp
  1053b6:	5d                   	pop    %ebp
  1053b7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1053b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053bb:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  1053be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053c2:	89 04 24             	mov    %eax,(%esp)
  1053c5:	e8 06 ce ff ff       	call   1021d0 <nameiparent>
  1053ca:	85 c0                	test   %eax,%eax
  1053cc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1053cf:	74 d5                	je     1053a6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1053d1:	89 04 24             	mov    %eax,(%esp)
  1053d4:	e8 57 cb ff ff       	call   101f30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1053d9:	c7 44 24 04 91 6f 10 	movl   $0x106f91,0x4(%esp)
  1053e0:	00 
  1053e1:	89 1c 24             	mov    %ebx,(%esp)
  1053e4:	e8 e7 c4 ff ff       	call   1018d0 <namecmp>
  1053e9:	85 c0                	test   %eax,%eax
  1053eb:	0f 84 a4 00 00 00    	je     105495 <sys_unlink+0x115>
  1053f1:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  1053f8:	00 
  1053f9:	89 1c 24             	mov    %ebx,(%esp)
  1053fc:	e8 cf c4 ff ff       	call   1018d0 <namecmp>
  105401:	85 c0                	test   %eax,%eax
  105403:	0f 84 8c 00 00 00    	je     105495 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  105409:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10540c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105410:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105413:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105417:	89 04 24             	mov    %eax,(%esp)
  10541a:	e8 e1 c4 ff ff       	call   101900 <dirlookup>
  10541f:	85 c0                	test   %eax,%eax
  105421:	89 c6                	mov    %eax,%esi
  105423:	74 70                	je     105495 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105425:	89 04 24             	mov    %eax,(%esp)
  105428:	e8 03 cb ff ff       	call   101f30 <ilock>

  if(ip->nlink < 1)
  10542d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105432:	0f 8e e9 00 00 00    	jle    105521 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105438:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  10543d:	75 71                	jne    1054b0 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10543f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105443:	76 6b                	jbe    1054b0 <sys_unlink+0x130>
  105445:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  105448:	bb 20 00 00 00       	mov    $0x20,%ebx
  10544d:	8d 76 00             	lea    0x0(%esi),%esi
  105450:	eb 0e                	jmp    105460 <sys_unlink+0xe0>
  105452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105458:	83 c3 10             	add    $0x10,%ebx
  10545b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10545e:	73 50                	jae    1054b0 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105460:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105467:	00 
  105468:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10546c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105470:	89 34 24             	mov    %esi,(%esp)
  105473:	e8 88 c1 ff ff       	call   101600 <readi>
  105478:	83 f8 10             	cmp    $0x10,%eax
  10547b:	0f 85 94 00 00 00    	jne    105515 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  105481:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  105486:	74 d0                	je     105458 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105488:	89 34 24             	mov    %esi,(%esp)
  10548b:	90                   	nop
  10548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105490:	e8 7b ca ff ff       	call   101f10 <iunlockput>
    iunlockput(dp);
  105495:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105498:	89 04 24             	mov    %eax,(%esp)
  10549b:	e8 70 ca ff ff       	call   101f10 <iunlockput>
  1054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1054a5:	e9 01 ff ff ff       	jmp    1053ab <sys_unlink+0x2b>
  1054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  1054b0:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  1054b3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1054ba:	00 
  1054bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1054c2:	00 
  1054c3:	89 1c 24             	mov    %ebx,(%esp)
  1054c6:	e8 c5 f2 ff ff       	call   104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1054cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054ce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1054d5:	00 
  1054d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1054da:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1054e1:	89 04 24             	mov    %eax,(%esp)
  1054e4:	e8 b7 c2 ff ff       	call   1017a0 <writei>
  1054e9:	83 f8 10             	cmp    $0x10,%eax
  1054ec:	75 3f                	jne    10552d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  1054ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1054f1:	89 04 24             	mov    %eax,(%esp)
  1054f4:	e8 17 ca ff ff       	call   101f10 <iunlockput>

  ip->nlink--;
  1054f9:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1054fe:	89 34 24             	mov    %esi,(%esp)
  105501:	e8 0a c2 ff ff       	call   101710 <iupdate>
  iunlockput(ip);
  105506:	89 34 24             	mov    %esi,(%esp)
  105509:	e8 02 ca ff ff       	call   101f10 <iunlockput>
  10550e:	31 c0                	xor    %eax,%eax
  return 0;
  105510:	e9 96 fe ff ff       	jmp    1053ab <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  105515:	c7 04 24 b1 6f 10 00 	movl   $0x106fb1,(%esp)
  10551c:	e8 4f b4 ff ff       	call   100970 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105521:	c7 04 24 9f 6f 10 00 	movl   $0x106f9f,(%esp)
  105528:	e8 43 b4 ff ff       	call   100970 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  10552d:	c7 04 24 c3 6f 10 00 	movl   $0x106fc3,(%esp)
  105534:	e8 37 b4 ff ff       	call   100970 <panic>
  105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105540 <T.63>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  105540:	55                   	push   %ebp
  105541:	89 e5                	mov    %esp,%ebp
  105543:	83 ec 28             	sub    $0x28,%esp
  105546:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105549:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10554b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  10554e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105551:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105553:	89 44 24 04          	mov    %eax,0x4(%esp)
  105557:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10555e:	e8 fd f4 ff ff       	call   104a60 <argint>
  105563:	85 c0                	test   %eax,%eax
  105565:	79 11                	jns    105578 <T.63+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105567:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  10556c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10556f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105572:	89 ec                	mov    %ebp,%esp
  105574:	5d                   	pop    %ebp
  105575:	c3                   	ret    
  105576:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105578:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  10557c:	77 e9                	ja     105567 <T.63+0x27>
  10557e:	e8 5d e1 ff ff       	call   1036e0 <curproc>
  105583:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  105586:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  10558a:	85 d2                	test   %edx,%edx
  10558c:	74 d9                	je     105567 <T.63+0x27>
    return -1;
  if(pfd)
  10558e:	85 db                	test   %ebx,%ebx
  105590:	74 02                	je     105594 <T.63+0x54>
    *pfd = fd;
  105592:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  105594:	31 c0                	xor    %eax,%eax
  105596:	85 f6                	test   %esi,%esi
  105598:	74 d2                	je     10556c <T.63+0x2c>
    *pf = f;
  10559a:	89 16                	mov    %edx,(%esi)
  10559c:	eb ce                	jmp    10556c <T.63+0x2c>
  10559e:	66 90                	xchg   %ax,%ax

001055a0 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  1055a0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055a1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  1055a3:	89 e5                	mov    %esp,%ebp
  1055a5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055a8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1055ab:	e8 90 ff ff ff       	call   105540 <T.63>
  1055b0:	85 c0                	test   %eax,%eax
  1055b2:	79 0c                	jns    1055c0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  1055b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055b9:	c9                   	leave  
  1055ba:	c3                   	ret    
  1055bb:	90                   	nop
  1055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1055c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055c7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1055ce:	e8 8d f4 ff ff       	call   104a60 <argint>
  1055d3:	85 c0                	test   %eax,%eax
  1055d5:	78 dd                	js     1055b4 <sys_read+0x14>
  1055d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1055e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ec:	e8 3f f5 ff ff       	call   104b30 <argptr>
  1055f1:	85 c0                	test   %eax,%eax
  1055f3:	78 bf                	js     1055b4 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  1055f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1055ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105606:	89 04 24             	mov    %eax,(%esp)
  105609:	e8 02 b9 ff ff       	call   100f10 <fileread>
}
  10560e:	c9                   	leave  
  10560f:	c3                   	ret    

00105610 <sys_write>:

int
sys_write(void)
{
  105610:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105611:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105613:	89 e5                	mov    %esp,%ebp
  105615:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105618:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10561b:	e8 20 ff ff ff       	call   105540 <T.63>
  105620:	85 c0                	test   %eax,%eax
  105622:	79 0c                	jns    105630 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105624:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105629:	c9                   	leave  
  10562a:	c3                   	ret    
  10562b:	90                   	nop
  10562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105630:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105633:	89 44 24 04          	mov    %eax,0x4(%esp)
  105637:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10563e:	e8 1d f4 ff ff       	call   104a60 <argint>
  105643:	85 c0                	test   %eax,%eax
  105645:	78 dd                	js     105624 <sys_write+0x14>
  105647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10564a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105651:	89 44 24 08          	mov    %eax,0x8(%esp)
  105655:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105658:	89 44 24 04          	mov    %eax,0x4(%esp)
  10565c:	e8 cf f4 ff ff       	call   104b30 <argptr>
  105661:	85 c0                	test   %eax,%eax
  105663:	78 bf                	js     105624 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  105665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105668:	89 44 24 08          	mov    %eax,0x8(%esp)
  10566c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10566f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105676:	89 04 24             	mov    %eax,(%esp)
  105679:	e8 72 b7 ff ff       	call   100df0 <filewrite>
}
  10567e:	c9                   	leave  
  10567f:	c3                   	ret    

00105680 <sys_dup>:

int
sys_dup(void)
{
  105680:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105681:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105683:	89 e5                	mov    %esp,%ebp
  105685:	53                   	push   %ebx
  105686:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105689:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10568c:	e8 af fe ff ff       	call   105540 <T.63>
  105691:	85 c0                	test   %eax,%eax
  105693:	79 13                	jns    1056a8 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  105695:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10569a:	89 d8                	mov    %ebx,%eax
  10569c:	83 c4 24             	add    $0x24,%esp
  10569f:	5b                   	pop    %ebx
  1056a0:	5d                   	pop    %ebp
  1056a1:	c3                   	ret    
  1056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1056a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056ab:	e8 80 f5 ff ff       	call   104c30 <fdalloc>
  1056b0:	85 c0                	test   %eax,%eax
  1056b2:	89 c3                	mov    %eax,%ebx
  1056b4:	78 df                	js     105695 <sys_dup+0x15>
    return -1;
  filedup(f);
  1056b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056b9:	89 04 24             	mov    %eax,(%esp)
  1056bc:	e8 4f b9 ff ff       	call   101010 <filedup>
  return fd;
  1056c1:	eb d7                	jmp    10569a <sys_dup+0x1a>
  1056c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001056d0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  1056d0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1056d1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  1056d3:	89 e5                	mov    %esp,%ebp
  1056d5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1056d8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1056db:	e8 60 fe ff ff       	call   105540 <T.63>
  1056e0:	85 c0                	test   %eax,%eax
  1056e2:	79 0c                	jns    1056f0 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  1056e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056e9:	c9                   	leave  
  1056ea:	c3                   	ret    
  1056eb:	90                   	nop
  1056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1056f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1056f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1056fa:	00 
  1056fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105706:	e8 25 f4 ff ff       	call   104b30 <argptr>
  10570b:	85 c0                	test   %eax,%eax
  10570d:	78 d5                	js     1056e4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10570f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105712:	89 44 24 04          	mov    %eax,0x4(%esp)
  105716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105719:	89 04 24             	mov    %eax,(%esp)
  10571c:	e8 9f b8 ff ff       	call   100fc0 <filestat>
}
  105721:	c9                   	leave  
  105722:	c3                   	ret    
  105723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105730 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105730:	55                   	push   %ebp
  105731:	89 e5                	mov    %esp,%ebp
  105733:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105736:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10573c:	e8 ff fd ff ff       	call   105540 <T.63>
  105741:	89 c2                	mov    %eax,%edx
  105743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105748:	85 d2                	test   %edx,%edx
  10574a:	78 1d                	js     105769 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10574c:	e8 8f df ff ff       	call   1036e0 <curproc>
  105751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105754:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10575b:	00 
  fileclose(f);
  10575c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10575f:	89 04 24             	mov    %eax,(%esp)
  105762:	e8 89 b9 ff ff       	call   1010f0 <fileclose>
  105767:	31 c0                	xor    %eax,%eax
  return 0;
}
  105769:	c9                   	leave  
  10576a:	c3                   	ret    
  10576b:	90                   	nop
  10576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105770 <sys_check>:
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105770:	55                   	push   %ebp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105771:	31 c0                	xor    %eax,%eax
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  105773:	89 e5                	mov    %esp,%ebp
  105775:	83 ec 28             	sub    $0x28,%esp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105778:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10577b:	e8 c0 fd ff ff       	call   105540 <T.63>
  105780:	85 c0                	test   %eax,%eax
  105782:	79 0c                	jns    105790 <sys_check+0x20>
		return -1;
	return filecheck(f, off);
  105784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  105789:	c9                   	leave  
  10578a:	c3                   	ret    
  10578b:	90                   	nop
  10578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int sys_check(void){

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  105790:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105793:	89 44 24 04          	mov    %eax,0x4(%esp)
  105797:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10579e:	e8 bd f2 ff ff       	call   104a60 <argint>
  1057a3:	85 c0                	test   %eax,%eax
  1057a5:	78 dd                	js     105784 <sys_check+0x14>
		return -1;
	return filecheck(f, off);
  1057a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057b1:	89 04 24             	mov    %eax,(%esp)
  1057b4:	e8 e7 b6 ff ff       	call   100ea0 <filecheck>

}
  1057b9:	c9                   	leave  
  1057ba:	c3                   	ret    
  1057bb:	90                   	nop
  1057bc:	90                   	nop
  1057bd:	90                   	nop
  1057be:	90                   	nop
  1057bf:	90                   	nop

001057c0 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  1057c0:	55                   	push   %ebp
return ticks;
}
  1057c1:	a1 40 f1 10 00       	mov    0x10f140,%eax
	return 0;
}

int
sys_tick(void)
{
  1057c6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1057c8:	5d                   	pop    %ebp
  1057c9:	c3                   	ret    
  1057ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001057d0 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  1057d0:	55                   	push   %ebp
  1057d1:	89 e5                	mov    %esp,%ebp
  1057d3:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  1057d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1057d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057e4:	e8 77 f2 ff ff       	call   104a60 <argint>
  1057e9:	89 c2                	mov    %eax,%edx
  1057eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1057f0:	85 d2                	test   %edx,%edx
  1057f2:	78 0d                	js     105801 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  1057f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057f7:	89 04 24             	mov    %eax,(%esp)
  1057fa:	e8 11 dc ff ff       	call   103410 <wake_lock>
  1057ff:	31 c0                	xor    %eax,%eax

	return 0;
}
  105801:	c9                   	leave  
  105802:	c3                   	ret    
  105803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105810 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  105810:	55                   	push   %ebp
  105811:	89 e5                	mov    %esp,%ebp
  105813:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  105816:	e8 25 e1 ff ff       	call   103940 <sleep_lock>
	return 0;
}
  10581b:	31 c0                	xor    %eax,%eax
  10581d:	c9                   	leave  
  10581e:	c3                   	ret    
  10581f:	90                   	nop

00105820 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105820:	55                   	push   %ebp
  105821:	89 e5                	mov    %esp,%ebp
  105823:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105826:	e8 b5 de ff ff       	call   1036e0 <curproc>
  10582b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10582e:	c9                   	leave  
  10582f:	c3                   	ret    

00105830 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105830:	55                   	push   %ebp
  105831:	89 e5                	mov    %esp,%ebp
  105833:	53                   	push   %ebx
  105834:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105837:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10583a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105845:	e8 16 f2 ff ff       	call   104a60 <argint>
  10584a:	89 c2                	mov    %eax,%edx
  10584c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105851:	85 d2                	test   %edx,%edx
  105853:	78 58                	js     1058ad <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105855:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  10585c:	e8 bf ee ff ff       	call   104720 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105864:	8b 1d 40 f1 10 00    	mov    0x10f140,%ebx
  while(ticks - ticks0 < n){
  10586a:	85 d2                	test   %edx,%edx
  10586c:	7f 22                	jg     105890 <sys_sleep+0x60>
  10586e:	eb 48                	jmp    1058b8 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105870:	c7 44 24 04 00 e9 10 	movl   $0x10e900,0x4(%esp)
  105877:	00 
  105878:	c7 04 24 40 f1 10 00 	movl   $0x10f140,(%esp)
  10587f:	e8 0c e1 ff ff       	call   103990 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105884:	a1 40 f1 10 00       	mov    0x10f140,%eax
  105889:	29 d8                	sub    %ebx,%eax
  10588b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10588e:	7d 28                	jge    1058b8 <sys_sleep+0x88>
    if(cp->killed){
  105890:	e8 4b de ff ff       	call   1036e0 <curproc>
  105895:	8b 40 1c             	mov    0x1c(%eax),%eax
  105898:	85 c0                	test   %eax,%eax
  10589a:	74 d4                	je     105870 <sys_sleep+0x40>
      release(&tickslock);
  10589c:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  1058a3:	e8 38 ee ff ff       	call   1046e0 <release>
  1058a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  1058ad:	83 c4 24             	add    $0x24,%esp
  1058b0:	5b                   	pop    %ebx
  1058b1:	5d                   	pop    %ebp
  1058b2:	c3                   	ret    
  1058b3:	90                   	nop
  1058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1058b8:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  1058bf:	e8 1c ee ff ff       	call   1046e0 <release>
  return 0;
}
  1058c4:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1058c7:	31 c0                	xor    %eax,%eax
  return 0;
}
  1058c9:	5b                   	pop    %ebx
  1058ca:	5d                   	pop    %ebp
  1058cb:	c3                   	ret    
  1058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001058d0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1058d0:	55                   	push   %ebp
  1058d1:	89 e5                	mov    %esp,%ebp
  1058d3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1058d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1058d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058e4:	e8 77 f1 ff ff       	call   104a60 <argint>
  1058e9:	85 c0                	test   %eax,%eax
  1058eb:	79 0b                	jns    1058f8 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  1058ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1058f2:	c9                   	leave  
  1058f3:	c3                   	ret    
  1058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1058f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058fb:	89 04 24             	mov    %eax,(%esp)
  1058fe:	e8 fd e6 ff ff       	call   104000 <growproc>
  105903:	85 c0                	test   %eax,%eax
  105905:	78 e6                	js     1058ed <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105907:	c9                   	leave  
  105908:	c3                   	ret    
  105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105910 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105910:	55                   	push   %ebp
  105911:	89 e5                	mov    %esp,%ebp
  105913:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105916:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105924:	e8 37 f1 ff ff       	call   104a60 <argint>
  105929:	89 c2                	mov    %eax,%edx
  10592b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105930:	85 d2                	test   %edx,%edx
  105932:	78 0b                	js     10593f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105937:	89 04 24             	mov    %eax,(%esp)
  10593a:	e8 11 dc ff ff       	call   103550 <kill>
}
  10593f:	c9                   	leave  
  105940:	c3                   	ret    
  105941:	eb 0d                	jmp    105950 <sys_wait>
  105943:	90                   	nop
  105944:	90                   	nop
  105945:	90                   	nop
  105946:	90                   	nop
  105947:	90                   	nop
  105948:	90                   	nop
  105949:	90                   	nop
  10594a:	90                   	nop
  10594b:	90                   	nop
  10594c:	90                   	nop
  10594d:	90                   	nop
  10594e:	90                   	nop
  10594f:	90                   	nop

00105950 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105950:	55                   	push   %ebp
  105951:	89 e5                	mov    %esp,%ebp
  105953:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105956:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105957:	e9 04 e2 ff ff       	jmp    103b60 <wait>
  10595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105960 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  105960:	55                   	push   %ebp
  105961:	89 e5                	mov    %esp,%ebp
  105963:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  105966:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  105967:	e9 f4 e0 ff ff       	jmp    103a60 <wait_thread>
  10596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105970 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105970:	55                   	push   %ebp
  105971:	89 e5                	mov    %esp,%ebp
  105973:	83 ec 08             	sub    $0x8,%esp
  exit();
  105976:	e8 65 de ff ff       	call   1037e0 <exit>
  return 0;  // not reached
}
  10597b:	31 c0                	xor    %eax,%eax
  10597d:	c9                   	leave  
  10597e:	c3                   	ret    
  10597f:	90                   	nop

00105980 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105980:	55                   	push   %ebp
  105981:	89 e5                	mov    %esp,%ebp
  105983:	53                   	push   %ebx
  105984:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105987:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10598a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10598e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105995:	e8 c6 f0 ff ff       	call   104a60 <argint>
  10599a:	85 c0                	test   %eax,%eax
  10599c:	79 12                	jns    1059b0 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10599e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1059a3:	83 c4 24             	add    $0x24,%esp
  1059a6:	5b                   	pop    %ebx
  1059a7:	5d                   	pop    %ebp
  1059a8:	c3                   	ret    
  1059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  1059b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1059b3:	e8 28 dd ff ff       	call   1036e0 <curproc>
  1059b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1059bc:	89 04 24             	mov    %eax,(%esp)
  1059bf:	e8 fc e6 ff ff       	call   1040c0 <copyproc_tix>
  1059c4:	85 c0                	test   %eax,%eax
  1059c6:	89 c2                	mov    %eax,%edx
  1059c8:	74 d4                	je     10599e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  1059ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  1059cd:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  1059d0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  1059d7:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  1059dd:	eb c4                	jmp    1059a3 <sys_fork_tickets+0x23>
  1059df:	90                   	nop

001059e0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1059e0:	55                   	push   %ebp
  1059e1:	89 e5                	mov    %esp,%ebp
  1059e3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1059e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1059e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1059ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1059ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1059f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1059fd:	e8 5e f0 ff ff       	call   104a60 <argint>
  105a02:	85 c0                	test   %eax,%eax
  105a04:	79 12                	jns    105a18 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105a0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105a0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105a11:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105a14:	89 ec                	mov    %ebp,%esp
  105a16:	5d                   	pop    %ebp
  105a17:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105a18:	8d 45 e0             	lea    -0x20(%ebp),%eax
  105a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105a26:	e8 35 f0 ff ff       	call   104a60 <argint>
  105a2b:	85 c0                	test   %eax,%eax
  105a2d:	78 d7                	js     105a06 <sys_fork_thread+0x26>
  105a2f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  105a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a36:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105a3d:	e8 1e f0 ff ff       	call   104a60 <argint>
  105a42:	85 c0                	test   %eax,%eax
  105a44:	78 c0                	js     105a06 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105a46:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105a49:	8b 75 e0             	mov    -0x20(%ebp),%esi
  105a4c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  105a4f:	e8 8c dc ff ff       	call   1036e0 <curproc>
  105a54:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105a58:	89 74 24 08          	mov    %esi,0x8(%esp)
  105a5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105a60:	89 04 24             	mov    %eax,(%esp)
  105a63:	e8 98 e7 ff ff       	call   104200 <copyproc_threads>
  105a68:	89 c2                	mov    %eax,%edx
  105a6a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  105a6f:	85 d2                	test   %edx,%edx
  105a71:	74 98                	je     105a0b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  105a73:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  105a7a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  105a7d:	eb 8c                	jmp    105a0b <sys_fork_thread+0x2b>
  105a7f:	90                   	nop

00105a80 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105a80:	55                   	push   %ebp
  105a81:	89 e5                	mov    %esp,%ebp
  105a83:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105a86:	e8 55 dc ff ff       	call   1036e0 <curproc>
  105a8b:	89 04 24             	mov    %eax,(%esp)
  105a8e:	e8 7d e8 ff ff       	call   104310 <copyproc>
  105a93:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105a98:	85 c0                	test   %eax,%eax
  105a9a:	74 0a                	je     105aa6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  105a9c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  105a9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105aa6:	89 d0                	mov    %edx,%eax
  105aa8:	c9                   	leave  
  105aa9:	c3                   	ret    
  105aaa:	90                   	nop
  105aab:	90                   	nop
  105aac:	90                   	nop
  105aad:	90                   	nop
  105aae:	90                   	nop
  105aaf:	90                   	nop

00105ab0 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105ab0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105ab1:	ba 43 00 00 00       	mov    $0x43,%edx
  105ab6:	89 e5                	mov    %esp,%ebp
  105ab8:	83 ec 18             	sub    $0x18,%esp
  105abb:	b8 34 00 00 00       	mov    $0x34,%eax
  105ac0:	ee                   	out    %al,(%dx)
  105ac1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105ac6:	b2 40                	mov    $0x40,%dl
  105ac8:	ee                   	out    %al,(%dx)
  105ac9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  105ace:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105acf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105ad6:	e8 15 d5 ff ff       	call   102ff0 <pic_enable>
}
  105adb:	c9                   	leave  
  105adc:	c3                   	ret    
  105add:	90                   	nop
  105ade:	90                   	nop
  105adf:	90                   	nop

00105ae0 <alltraps>:
  105ae0:	1e                   	push   %ds
  105ae1:	06                   	push   %es
  105ae2:	60                   	pusha  
  105ae3:	b8 10 00 00 00       	mov    $0x10,%eax
  105ae8:	8e d8                	mov    %eax,%ds
  105aea:	8e c0                	mov    %eax,%es
  105aec:	54                   	push   %esp
  105aed:	e8 4e 00 00 00       	call   105b40 <trap>
  105af2:	83 c4 04             	add    $0x4,%esp

00105af5 <trapret>:
  105af5:	61                   	popa   
  105af6:	07                   	pop    %es
  105af7:	1f                   	pop    %ds
  105af8:	83 c4 08             	add    $0x8,%esp
  105afb:	cf                   	iret   

00105afc <forkret1>:
  105afc:	8b 64 24 04          	mov    0x4(%esp),%esp
  105b00:	e9 f0 ff ff ff       	jmp    105af5 <trapret>
  105b05:	90                   	nop
  105b06:	90                   	nop
  105b07:	90                   	nop
  105b08:	90                   	nop
  105b09:	90                   	nop
  105b0a:	90                   	nop
  105b0b:	90                   	nop
  105b0c:	90                   	nop
  105b0d:	90                   	nop
  105b0e:	90                   	nop
  105b0f:	90                   	nop

00105b10 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105b10:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105b11:	b8 40 e9 10 00       	mov    $0x10e940,%eax
  105b16:	89 e5                	mov    %esp,%ebp
  105b18:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  105b1b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105b21:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105b25:	c1 e8 10             	shr    $0x10,%eax
  105b28:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  105b2c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  105b2f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105b32:	c9                   	leave  
  105b33:	c3                   	ret    
  105b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105b40 <trap>:

void
trap(struct trapframe *tf)
{
  105b40:	55                   	push   %ebp
  105b41:	89 e5                	mov    %esp,%ebp
  105b43:	83 ec 48             	sub    $0x48,%esp
  105b46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  105b4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105b4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  105b52:	8b 43 28             	mov    0x28(%ebx),%eax
  105b55:	83 f8 30             	cmp    $0x30,%eax
  105b58:	0f 84 8a 01 00 00    	je     105ce8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105b5e:	83 f8 21             	cmp    $0x21,%eax
  105b61:	0f 84 69 01 00 00    	je     105cd0 <trap+0x190>
  105b67:	76 47                	jbe    105bb0 <trap+0x70>
  105b69:	83 f8 2e             	cmp    $0x2e,%eax
  105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105b70:	0f 84 42 01 00 00    	je     105cb8 <trap+0x178>
  105b76:	83 f8 3f             	cmp    $0x3f,%eax
  105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105b80:	75 37                	jne    105bb9 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105b82:	8b 7b 30             	mov    0x30(%ebx),%edi
  105b85:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  105b89:	e8 c2 cf ff ff       	call   102b50 <cpu>
  105b8e:	c7 04 24 d4 6f 10 00 	movl   $0x106fd4,(%esp)
  105b95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105b99:	89 74 24 08          	mov    %esi,0x8(%esp)
  105b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba1:	e8 2a ac ff ff       	call   1007d0 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105ba6:	e8 15 ce ff ff       	call   1029c0 <lapic_eoi>
    break;
  105bab:	e9 90 00 00 00       	jmp    105c40 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105bb0:	83 f8 20             	cmp    $0x20,%eax
  105bb3:	0f 84 e7 00 00 00    	je     105ca0 <trap+0x160>
  105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105bc0:	e8 1b db ff ff       	call   1036e0 <curproc>
  105bc5:	85 c0                	test   %eax,%eax
  105bc7:	0f 84 9b 01 00 00    	je     105d68 <trap+0x228>
  105bcd:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  105bd1:	0f 84 91 01 00 00    	je     105d68 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105bd7:	8b 53 30             	mov    0x30(%ebx),%edx
  105bda:	89 55 e0             	mov    %edx,-0x20(%ebp)
  105bdd:	e8 6e cf ff ff       	call   102b50 <cpu>
  105be2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  105be5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105be8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105beb:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105bed:	e8 ee da ff ff       	call   1036e0 <curproc>
  105bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105bf5:	e8 e6 da ff ff       	call   1036e0 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105bfa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105bfd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105c01:	89 74 24 10          	mov    %esi,0x10(%esp)
  105c05:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105c0c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c13:	81 c2 88 00 00 00    	add    $0x88,%edx
  105c19:	89 54 24 08          	mov    %edx,0x8(%esp)
  105c1d:	8b 40 10             	mov    0x10(%eax),%eax
  105c20:	c7 04 24 20 70 10 00 	movl   $0x107020,(%esp)
  105c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2b:	e8 a0 ab ff ff       	call   1007d0 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105c30:	e8 ab da ff ff       	call   1036e0 <curproc>
  105c35:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105c40:	e8 9b da ff ff       	call   1036e0 <curproc>
  105c45:	85 c0                	test   %eax,%eax
  105c47:	74 1c                	je     105c65 <trap+0x125>
  105c49:	e8 92 da ff ff       	call   1036e0 <curproc>
  105c4e:	8b 40 1c             	mov    0x1c(%eax),%eax
  105c51:	85 c0                	test   %eax,%eax
  105c53:	74 10                	je     105c65 <trap+0x125>
  105c55:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105c59:	83 e0 03             	and    $0x3,%eax
  105c5c:	83 f8 03             	cmp    $0x3,%eax
  105c5f:	0f 84 33 01 00 00    	je     105d98 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105c65:	e8 76 da ff ff       	call   1036e0 <curproc>
  105c6a:	85 c0                	test   %eax,%eax
  105c6c:	74 0d                	je     105c7b <trap+0x13b>
  105c6e:	66 90                	xchg   %ax,%ax
  105c70:	e8 6b da ff ff       	call   1036e0 <curproc>
  105c75:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105c79:	74 0d                	je     105c88 <trap+0x148>
    yield();
}
  105c7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105c7e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105c81:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105c84:	89 ec                	mov    %ebp,%esp
  105c86:	5d                   	pop    %ebp
  105c87:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105c88:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  105c8c:	75 ed                	jne    105c7b <trap+0x13b>
    yield();
}
  105c8e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105c91:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105c94:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105c97:	89 ec                	mov    %ebp,%esp
  105c99:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105c9a:	e9 d1 df ff ff       	jmp    103c70 <yield>
  105c9f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105ca0:	e8 ab ce ff ff       	call   102b50 <cpu>
  105ca5:	85 c0                	test   %eax,%eax
  105ca7:	0f 84 8b 00 00 00    	je     105d38 <trap+0x1f8>
  105cad:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  105cb0:	e8 0b cd ff ff       	call   1029c0 <lapic_eoi>
    break;
  105cb5:	eb 89                	jmp    105c40 <trap+0x100>
  105cb7:	90                   	nop
  105cb8:	90                   	nop
  105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105cc0:	e8 eb c6 ff ff       	call   1023b0 <ide_intr>
  105cc5:	8d 76 00             	lea    0x0(%esi),%esi
  105cc8:	eb e3                	jmp    105cad <trap+0x16d>
  105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105cd0:	e8 db cb ff ff       	call   1028b0 <kbd_intr>
  105cd5:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  105cd8:	e8 e3 cc ff ff       	call   1029c0 <lapic_eoi>
  105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105ce0:	e9 5b ff ff ff       	jmp    105c40 <trap+0x100>
  105ce5:	8d 76 00             	lea    0x0(%esi),%esi
  105ce8:	90                   	nop
  105ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105cf0:	e8 eb d9 ff ff       	call   1036e0 <curproc>
  105cf5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105cf8:	85 c9                	test   %ecx,%ecx
  105cfa:	0f 85 a8 00 00 00    	jne    105da8 <trap+0x268>
      exit();
    cp->tf = tf;
  105d00:	e8 db d9 ff ff       	call   1036e0 <curproc>
  105d05:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  105d0b:	e8 80 ee ff ff       	call   104b90 <syscall>
    if(cp->killed)
  105d10:	e8 cb d9 ff ff       	call   1036e0 <curproc>
  105d15:	8b 50 1c             	mov    0x1c(%eax),%edx
  105d18:	85 d2                	test   %edx,%edx
  105d1a:	0f 84 5b ff ff ff    	je     105c7b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105d20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105d23:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105d26:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105d29:	89 ec                	mov    %ebp,%esp
  105d2b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105d2c:	e9 af da ff ff       	jmp    1037e0 <exit>
  105d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105d38:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  105d3f:	e8 dc e9 ff ff       	call   104720 <acquire>
      ticks++;
  105d44:	83 05 40 f1 10 00 01 	addl   $0x1,0x10f140
      wakeup(&ticks);
  105d4b:	c7 04 24 40 f1 10 00 	movl   $0x10f140,(%esp)
  105d52:	e8 89 d8 ff ff       	call   1035e0 <wakeup>
      release(&tickslock);
  105d57:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
  105d5e:	e8 7d e9 ff ff       	call   1046e0 <release>
  105d63:	e9 45 ff ff ff       	jmp    105cad <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105d68:	8b 73 30             	mov    0x30(%ebx),%esi
  105d6b:	e8 e0 cd ff ff       	call   102b50 <cpu>
  105d70:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105d74:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d78:	8b 43 28             	mov    0x28(%ebx),%eax
  105d7b:	c7 04 24 f8 6f 10 00 	movl   $0x106ff8,(%esp)
  105d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d86:	e8 45 aa ff ff       	call   1007d0 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105d8b:	c7 04 24 5c 70 10 00 	movl   $0x10705c,(%esp)
  105d92:	e8 d9 ab ff ff       	call   100970 <panic>
  105d97:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105d98:	e8 43 da ff ff       	call   1037e0 <exit>
  105d9d:	e9 c3 fe ff ff       	jmp    105c65 <trap+0x125>
  105da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105da8:	90                   	nop
  105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105db0:	e8 2b da ff ff       	call   1037e0 <exit>
  105db5:	8d 76 00             	lea    0x0(%esi),%esi
  105db8:	e9 43 ff ff ff       	jmp    105d00 <trap+0x1c0>
  105dbd:	8d 76 00             	lea    0x0(%esi),%esi

00105dc0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105dc0:	55                   	push   %ebp
  105dc1:	31 c0                	xor    %eax,%eax
  105dc3:	89 e5                	mov    %esp,%ebp
  105dc5:	ba 40 e9 10 00       	mov    $0x10e940,%edx
  105dca:	83 ec 18             	sub    $0x18,%esp
  105dcd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105dd0:	8b 0c 85 88 83 10 00 	mov    0x108388(,%eax,4),%ecx
  105dd7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105dde:	66 89 0c c5 40 e9 10 	mov    %cx,0x10e940(,%eax,8)
  105de5:	00 
  105de6:	c1 e9 10             	shr    $0x10,%ecx
  105de9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  105dee:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105df3:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105df8:	83 c0 01             	add    $0x1,%eax
  105dfb:	3d 00 01 00 00       	cmp    $0x100,%eax
  105e00:	75 ce                	jne    105dd0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105e02:	a1 48 84 10 00       	mov    0x108448,%eax
  
  initlock(&tickslock, "time");
  105e07:	c7 44 24 04 61 70 10 	movl   $0x107061,0x4(%esp)
  105e0e:	00 
  105e0f:	c7 04 24 00 e9 10 00 	movl   $0x10e900,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105e16:	66 c7 05 c2 ea 10 00 	movw   $0x8,0x10eac2
  105e1d:	08 00 
  105e1f:	66 a3 c0 ea 10 00    	mov    %ax,0x10eac0
  105e25:	c1 e8 10             	shr    $0x10,%eax
  105e28:	c6 05 c4 ea 10 00 00 	movb   $0x0,0x10eac4
  105e2f:	c6 05 c5 ea 10 00 ef 	movb   $0xef,0x10eac5
  105e36:	66 a3 c6 ea 10 00    	mov    %ax,0x10eac6
  
  initlock(&tickslock, "time");
  105e3c:	e8 1f e7 ff ff       	call   104560 <initlock>
}
  105e41:	c9                   	leave  
  105e42:	c3                   	ret    
  105e43:	90                   	nop

00105e44 <vector0>:
  105e44:	6a 00                	push   $0x0
  105e46:	6a 00                	push   $0x0
  105e48:	e9 93 fc ff ff       	jmp    105ae0 <alltraps>

00105e4d <vector1>:
  105e4d:	6a 00                	push   $0x0
  105e4f:	6a 01                	push   $0x1
  105e51:	e9 8a fc ff ff       	jmp    105ae0 <alltraps>

00105e56 <vector2>:
  105e56:	6a 00                	push   $0x0
  105e58:	6a 02                	push   $0x2
  105e5a:	e9 81 fc ff ff       	jmp    105ae0 <alltraps>

00105e5f <vector3>:
  105e5f:	6a 00                	push   $0x0
  105e61:	6a 03                	push   $0x3
  105e63:	e9 78 fc ff ff       	jmp    105ae0 <alltraps>

00105e68 <vector4>:
  105e68:	6a 00                	push   $0x0
  105e6a:	6a 04                	push   $0x4
  105e6c:	e9 6f fc ff ff       	jmp    105ae0 <alltraps>

00105e71 <vector5>:
  105e71:	6a 00                	push   $0x0
  105e73:	6a 05                	push   $0x5
  105e75:	e9 66 fc ff ff       	jmp    105ae0 <alltraps>

00105e7a <vector6>:
  105e7a:	6a 00                	push   $0x0
  105e7c:	6a 06                	push   $0x6
  105e7e:	e9 5d fc ff ff       	jmp    105ae0 <alltraps>

00105e83 <vector7>:
  105e83:	6a 00                	push   $0x0
  105e85:	6a 07                	push   $0x7
  105e87:	e9 54 fc ff ff       	jmp    105ae0 <alltraps>

00105e8c <vector8>:
  105e8c:	6a 08                	push   $0x8
  105e8e:	e9 4d fc ff ff       	jmp    105ae0 <alltraps>

00105e93 <vector9>:
  105e93:	6a 09                	push   $0x9
  105e95:	e9 46 fc ff ff       	jmp    105ae0 <alltraps>

00105e9a <vector10>:
  105e9a:	6a 0a                	push   $0xa
  105e9c:	e9 3f fc ff ff       	jmp    105ae0 <alltraps>

00105ea1 <vector11>:
  105ea1:	6a 0b                	push   $0xb
  105ea3:	e9 38 fc ff ff       	jmp    105ae0 <alltraps>

00105ea8 <vector12>:
  105ea8:	6a 0c                	push   $0xc
  105eaa:	e9 31 fc ff ff       	jmp    105ae0 <alltraps>

00105eaf <vector13>:
  105eaf:	6a 0d                	push   $0xd
  105eb1:	e9 2a fc ff ff       	jmp    105ae0 <alltraps>

00105eb6 <vector14>:
  105eb6:	6a 0e                	push   $0xe
  105eb8:	e9 23 fc ff ff       	jmp    105ae0 <alltraps>

00105ebd <vector15>:
  105ebd:	6a 00                	push   $0x0
  105ebf:	6a 0f                	push   $0xf
  105ec1:	e9 1a fc ff ff       	jmp    105ae0 <alltraps>

00105ec6 <vector16>:
  105ec6:	6a 00                	push   $0x0
  105ec8:	6a 10                	push   $0x10
  105eca:	e9 11 fc ff ff       	jmp    105ae0 <alltraps>

00105ecf <vector17>:
  105ecf:	6a 11                	push   $0x11
  105ed1:	e9 0a fc ff ff       	jmp    105ae0 <alltraps>

00105ed6 <vector18>:
  105ed6:	6a 00                	push   $0x0
  105ed8:	6a 12                	push   $0x12
  105eda:	e9 01 fc ff ff       	jmp    105ae0 <alltraps>

00105edf <vector19>:
  105edf:	6a 00                	push   $0x0
  105ee1:	6a 13                	push   $0x13
  105ee3:	e9 f8 fb ff ff       	jmp    105ae0 <alltraps>

00105ee8 <vector20>:
  105ee8:	6a 00                	push   $0x0
  105eea:	6a 14                	push   $0x14
  105eec:	e9 ef fb ff ff       	jmp    105ae0 <alltraps>

00105ef1 <vector21>:
  105ef1:	6a 00                	push   $0x0
  105ef3:	6a 15                	push   $0x15
  105ef5:	e9 e6 fb ff ff       	jmp    105ae0 <alltraps>

00105efa <vector22>:
  105efa:	6a 00                	push   $0x0
  105efc:	6a 16                	push   $0x16
  105efe:	e9 dd fb ff ff       	jmp    105ae0 <alltraps>

00105f03 <vector23>:
  105f03:	6a 00                	push   $0x0
  105f05:	6a 17                	push   $0x17
  105f07:	e9 d4 fb ff ff       	jmp    105ae0 <alltraps>

00105f0c <vector24>:
  105f0c:	6a 00                	push   $0x0
  105f0e:	6a 18                	push   $0x18
  105f10:	e9 cb fb ff ff       	jmp    105ae0 <alltraps>

00105f15 <vector25>:
  105f15:	6a 00                	push   $0x0
  105f17:	6a 19                	push   $0x19
  105f19:	e9 c2 fb ff ff       	jmp    105ae0 <alltraps>

00105f1e <vector26>:
  105f1e:	6a 00                	push   $0x0
  105f20:	6a 1a                	push   $0x1a
  105f22:	e9 b9 fb ff ff       	jmp    105ae0 <alltraps>

00105f27 <vector27>:
  105f27:	6a 00                	push   $0x0
  105f29:	6a 1b                	push   $0x1b
  105f2b:	e9 b0 fb ff ff       	jmp    105ae0 <alltraps>

00105f30 <vector28>:
  105f30:	6a 00                	push   $0x0
  105f32:	6a 1c                	push   $0x1c
  105f34:	e9 a7 fb ff ff       	jmp    105ae0 <alltraps>

00105f39 <vector29>:
  105f39:	6a 00                	push   $0x0
  105f3b:	6a 1d                	push   $0x1d
  105f3d:	e9 9e fb ff ff       	jmp    105ae0 <alltraps>

00105f42 <vector30>:
  105f42:	6a 00                	push   $0x0
  105f44:	6a 1e                	push   $0x1e
  105f46:	e9 95 fb ff ff       	jmp    105ae0 <alltraps>

00105f4b <vector31>:
  105f4b:	6a 00                	push   $0x0
  105f4d:	6a 1f                	push   $0x1f
  105f4f:	e9 8c fb ff ff       	jmp    105ae0 <alltraps>

00105f54 <vector32>:
  105f54:	6a 00                	push   $0x0
  105f56:	6a 20                	push   $0x20
  105f58:	e9 83 fb ff ff       	jmp    105ae0 <alltraps>

00105f5d <vector33>:
  105f5d:	6a 00                	push   $0x0
  105f5f:	6a 21                	push   $0x21
  105f61:	e9 7a fb ff ff       	jmp    105ae0 <alltraps>

00105f66 <vector34>:
  105f66:	6a 00                	push   $0x0
  105f68:	6a 22                	push   $0x22
  105f6a:	e9 71 fb ff ff       	jmp    105ae0 <alltraps>

00105f6f <vector35>:
  105f6f:	6a 00                	push   $0x0
  105f71:	6a 23                	push   $0x23
  105f73:	e9 68 fb ff ff       	jmp    105ae0 <alltraps>

00105f78 <vector36>:
  105f78:	6a 00                	push   $0x0
  105f7a:	6a 24                	push   $0x24
  105f7c:	e9 5f fb ff ff       	jmp    105ae0 <alltraps>

00105f81 <vector37>:
  105f81:	6a 00                	push   $0x0
  105f83:	6a 25                	push   $0x25
  105f85:	e9 56 fb ff ff       	jmp    105ae0 <alltraps>

00105f8a <vector38>:
  105f8a:	6a 00                	push   $0x0
  105f8c:	6a 26                	push   $0x26
  105f8e:	e9 4d fb ff ff       	jmp    105ae0 <alltraps>

00105f93 <vector39>:
  105f93:	6a 00                	push   $0x0
  105f95:	6a 27                	push   $0x27
  105f97:	e9 44 fb ff ff       	jmp    105ae0 <alltraps>

00105f9c <vector40>:
  105f9c:	6a 00                	push   $0x0
  105f9e:	6a 28                	push   $0x28
  105fa0:	e9 3b fb ff ff       	jmp    105ae0 <alltraps>

00105fa5 <vector41>:
  105fa5:	6a 00                	push   $0x0
  105fa7:	6a 29                	push   $0x29
  105fa9:	e9 32 fb ff ff       	jmp    105ae0 <alltraps>

00105fae <vector42>:
  105fae:	6a 00                	push   $0x0
  105fb0:	6a 2a                	push   $0x2a
  105fb2:	e9 29 fb ff ff       	jmp    105ae0 <alltraps>

00105fb7 <vector43>:
  105fb7:	6a 00                	push   $0x0
  105fb9:	6a 2b                	push   $0x2b
  105fbb:	e9 20 fb ff ff       	jmp    105ae0 <alltraps>

00105fc0 <vector44>:
  105fc0:	6a 00                	push   $0x0
  105fc2:	6a 2c                	push   $0x2c
  105fc4:	e9 17 fb ff ff       	jmp    105ae0 <alltraps>

00105fc9 <vector45>:
  105fc9:	6a 00                	push   $0x0
  105fcb:	6a 2d                	push   $0x2d
  105fcd:	e9 0e fb ff ff       	jmp    105ae0 <alltraps>

00105fd2 <vector46>:
  105fd2:	6a 00                	push   $0x0
  105fd4:	6a 2e                	push   $0x2e
  105fd6:	e9 05 fb ff ff       	jmp    105ae0 <alltraps>

00105fdb <vector47>:
  105fdb:	6a 00                	push   $0x0
  105fdd:	6a 2f                	push   $0x2f
  105fdf:	e9 fc fa ff ff       	jmp    105ae0 <alltraps>

00105fe4 <vector48>:
  105fe4:	6a 00                	push   $0x0
  105fe6:	6a 30                	push   $0x30
  105fe8:	e9 f3 fa ff ff       	jmp    105ae0 <alltraps>

00105fed <vector49>:
  105fed:	6a 00                	push   $0x0
  105fef:	6a 31                	push   $0x31
  105ff1:	e9 ea fa ff ff       	jmp    105ae0 <alltraps>

00105ff6 <vector50>:
  105ff6:	6a 00                	push   $0x0
  105ff8:	6a 32                	push   $0x32
  105ffa:	e9 e1 fa ff ff       	jmp    105ae0 <alltraps>

00105fff <vector51>:
  105fff:	6a 00                	push   $0x0
  106001:	6a 33                	push   $0x33
  106003:	e9 d8 fa ff ff       	jmp    105ae0 <alltraps>

00106008 <vector52>:
  106008:	6a 00                	push   $0x0
  10600a:	6a 34                	push   $0x34
  10600c:	e9 cf fa ff ff       	jmp    105ae0 <alltraps>

00106011 <vector53>:
  106011:	6a 00                	push   $0x0
  106013:	6a 35                	push   $0x35
  106015:	e9 c6 fa ff ff       	jmp    105ae0 <alltraps>

0010601a <vector54>:
  10601a:	6a 00                	push   $0x0
  10601c:	6a 36                	push   $0x36
  10601e:	e9 bd fa ff ff       	jmp    105ae0 <alltraps>

00106023 <vector55>:
  106023:	6a 00                	push   $0x0
  106025:	6a 37                	push   $0x37
  106027:	e9 b4 fa ff ff       	jmp    105ae0 <alltraps>

0010602c <vector56>:
  10602c:	6a 00                	push   $0x0
  10602e:	6a 38                	push   $0x38
  106030:	e9 ab fa ff ff       	jmp    105ae0 <alltraps>

00106035 <vector57>:
  106035:	6a 00                	push   $0x0
  106037:	6a 39                	push   $0x39
  106039:	e9 a2 fa ff ff       	jmp    105ae0 <alltraps>

0010603e <vector58>:
  10603e:	6a 00                	push   $0x0
  106040:	6a 3a                	push   $0x3a
  106042:	e9 99 fa ff ff       	jmp    105ae0 <alltraps>

00106047 <vector59>:
  106047:	6a 00                	push   $0x0
  106049:	6a 3b                	push   $0x3b
  10604b:	e9 90 fa ff ff       	jmp    105ae0 <alltraps>

00106050 <vector60>:
  106050:	6a 00                	push   $0x0
  106052:	6a 3c                	push   $0x3c
  106054:	e9 87 fa ff ff       	jmp    105ae0 <alltraps>

00106059 <vector61>:
  106059:	6a 00                	push   $0x0
  10605b:	6a 3d                	push   $0x3d
  10605d:	e9 7e fa ff ff       	jmp    105ae0 <alltraps>

00106062 <vector62>:
  106062:	6a 00                	push   $0x0
  106064:	6a 3e                	push   $0x3e
  106066:	e9 75 fa ff ff       	jmp    105ae0 <alltraps>

0010606b <vector63>:
  10606b:	6a 00                	push   $0x0
  10606d:	6a 3f                	push   $0x3f
  10606f:	e9 6c fa ff ff       	jmp    105ae0 <alltraps>

00106074 <vector64>:
  106074:	6a 00                	push   $0x0
  106076:	6a 40                	push   $0x40
  106078:	e9 63 fa ff ff       	jmp    105ae0 <alltraps>

0010607d <vector65>:
  10607d:	6a 00                	push   $0x0
  10607f:	6a 41                	push   $0x41
  106081:	e9 5a fa ff ff       	jmp    105ae0 <alltraps>

00106086 <vector66>:
  106086:	6a 00                	push   $0x0
  106088:	6a 42                	push   $0x42
  10608a:	e9 51 fa ff ff       	jmp    105ae0 <alltraps>

0010608f <vector67>:
  10608f:	6a 00                	push   $0x0
  106091:	6a 43                	push   $0x43
  106093:	e9 48 fa ff ff       	jmp    105ae0 <alltraps>

00106098 <vector68>:
  106098:	6a 00                	push   $0x0
  10609a:	6a 44                	push   $0x44
  10609c:	e9 3f fa ff ff       	jmp    105ae0 <alltraps>

001060a1 <vector69>:
  1060a1:	6a 00                	push   $0x0
  1060a3:	6a 45                	push   $0x45
  1060a5:	e9 36 fa ff ff       	jmp    105ae0 <alltraps>

001060aa <vector70>:
  1060aa:	6a 00                	push   $0x0
  1060ac:	6a 46                	push   $0x46
  1060ae:	e9 2d fa ff ff       	jmp    105ae0 <alltraps>

001060b3 <vector71>:
  1060b3:	6a 00                	push   $0x0
  1060b5:	6a 47                	push   $0x47
  1060b7:	e9 24 fa ff ff       	jmp    105ae0 <alltraps>

001060bc <vector72>:
  1060bc:	6a 00                	push   $0x0
  1060be:	6a 48                	push   $0x48
  1060c0:	e9 1b fa ff ff       	jmp    105ae0 <alltraps>

001060c5 <vector73>:
  1060c5:	6a 00                	push   $0x0
  1060c7:	6a 49                	push   $0x49
  1060c9:	e9 12 fa ff ff       	jmp    105ae0 <alltraps>

001060ce <vector74>:
  1060ce:	6a 00                	push   $0x0
  1060d0:	6a 4a                	push   $0x4a
  1060d2:	e9 09 fa ff ff       	jmp    105ae0 <alltraps>

001060d7 <vector75>:
  1060d7:	6a 00                	push   $0x0
  1060d9:	6a 4b                	push   $0x4b
  1060db:	e9 00 fa ff ff       	jmp    105ae0 <alltraps>

001060e0 <vector76>:
  1060e0:	6a 00                	push   $0x0
  1060e2:	6a 4c                	push   $0x4c
  1060e4:	e9 f7 f9 ff ff       	jmp    105ae0 <alltraps>

001060e9 <vector77>:
  1060e9:	6a 00                	push   $0x0
  1060eb:	6a 4d                	push   $0x4d
  1060ed:	e9 ee f9 ff ff       	jmp    105ae0 <alltraps>

001060f2 <vector78>:
  1060f2:	6a 00                	push   $0x0
  1060f4:	6a 4e                	push   $0x4e
  1060f6:	e9 e5 f9 ff ff       	jmp    105ae0 <alltraps>

001060fb <vector79>:
  1060fb:	6a 00                	push   $0x0
  1060fd:	6a 4f                	push   $0x4f
  1060ff:	e9 dc f9 ff ff       	jmp    105ae0 <alltraps>

00106104 <vector80>:
  106104:	6a 00                	push   $0x0
  106106:	6a 50                	push   $0x50
  106108:	e9 d3 f9 ff ff       	jmp    105ae0 <alltraps>

0010610d <vector81>:
  10610d:	6a 00                	push   $0x0
  10610f:	6a 51                	push   $0x51
  106111:	e9 ca f9 ff ff       	jmp    105ae0 <alltraps>

00106116 <vector82>:
  106116:	6a 00                	push   $0x0
  106118:	6a 52                	push   $0x52
  10611a:	e9 c1 f9 ff ff       	jmp    105ae0 <alltraps>

0010611f <vector83>:
  10611f:	6a 00                	push   $0x0
  106121:	6a 53                	push   $0x53
  106123:	e9 b8 f9 ff ff       	jmp    105ae0 <alltraps>

00106128 <vector84>:
  106128:	6a 00                	push   $0x0
  10612a:	6a 54                	push   $0x54
  10612c:	e9 af f9 ff ff       	jmp    105ae0 <alltraps>

00106131 <vector85>:
  106131:	6a 00                	push   $0x0
  106133:	6a 55                	push   $0x55
  106135:	e9 a6 f9 ff ff       	jmp    105ae0 <alltraps>

0010613a <vector86>:
  10613a:	6a 00                	push   $0x0
  10613c:	6a 56                	push   $0x56
  10613e:	e9 9d f9 ff ff       	jmp    105ae0 <alltraps>

00106143 <vector87>:
  106143:	6a 00                	push   $0x0
  106145:	6a 57                	push   $0x57
  106147:	e9 94 f9 ff ff       	jmp    105ae0 <alltraps>

0010614c <vector88>:
  10614c:	6a 00                	push   $0x0
  10614e:	6a 58                	push   $0x58
  106150:	e9 8b f9 ff ff       	jmp    105ae0 <alltraps>

00106155 <vector89>:
  106155:	6a 00                	push   $0x0
  106157:	6a 59                	push   $0x59
  106159:	e9 82 f9 ff ff       	jmp    105ae0 <alltraps>

0010615e <vector90>:
  10615e:	6a 00                	push   $0x0
  106160:	6a 5a                	push   $0x5a
  106162:	e9 79 f9 ff ff       	jmp    105ae0 <alltraps>

00106167 <vector91>:
  106167:	6a 00                	push   $0x0
  106169:	6a 5b                	push   $0x5b
  10616b:	e9 70 f9 ff ff       	jmp    105ae0 <alltraps>

00106170 <vector92>:
  106170:	6a 00                	push   $0x0
  106172:	6a 5c                	push   $0x5c
  106174:	e9 67 f9 ff ff       	jmp    105ae0 <alltraps>

00106179 <vector93>:
  106179:	6a 00                	push   $0x0
  10617b:	6a 5d                	push   $0x5d
  10617d:	e9 5e f9 ff ff       	jmp    105ae0 <alltraps>

00106182 <vector94>:
  106182:	6a 00                	push   $0x0
  106184:	6a 5e                	push   $0x5e
  106186:	e9 55 f9 ff ff       	jmp    105ae0 <alltraps>

0010618b <vector95>:
  10618b:	6a 00                	push   $0x0
  10618d:	6a 5f                	push   $0x5f
  10618f:	e9 4c f9 ff ff       	jmp    105ae0 <alltraps>

00106194 <vector96>:
  106194:	6a 00                	push   $0x0
  106196:	6a 60                	push   $0x60
  106198:	e9 43 f9 ff ff       	jmp    105ae0 <alltraps>

0010619d <vector97>:
  10619d:	6a 00                	push   $0x0
  10619f:	6a 61                	push   $0x61
  1061a1:	e9 3a f9 ff ff       	jmp    105ae0 <alltraps>

001061a6 <vector98>:
  1061a6:	6a 00                	push   $0x0
  1061a8:	6a 62                	push   $0x62
  1061aa:	e9 31 f9 ff ff       	jmp    105ae0 <alltraps>

001061af <vector99>:
  1061af:	6a 00                	push   $0x0
  1061b1:	6a 63                	push   $0x63
  1061b3:	e9 28 f9 ff ff       	jmp    105ae0 <alltraps>

001061b8 <vector100>:
  1061b8:	6a 00                	push   $0x0
  1061ba:	6a 64                	push   $0x64
  1061bc:	e9 1f f9 ff ff       	jmp    105ae0 <alltraps>

001061c1 <vector101>:
  1061c1:	6a 00                	push   $0x0
  1061c3:	6a 65                	push   $0x65
  1061c5:	e9 16 f9 ff ff       	jmp    105ae0 <alltraps>

001061ca <vector102>:
  1061ca:	6a 00                	push   $0x0
  1061cc:	6a 66                	push   $0x66
  1061ce:	e9 0d f9 ff ff       	jmp    105ae0 <alltraps>

001061d3 <vector103>:
  1061d3:	6a 00                	push   $0x0
  1061d5:	6a 67                	push   $0x67
  1061d7:	e9 04 f9 ff ff       	jmp    105ae0 <alltraps>

001061dc <vector104>:
  1061dc:	6a 00                	push   $0x0
  1061de:	6a 68                	push   $0x68
  1061e0:	e9 fb f8 ff ff       	jmp    105ae0 <alltraps>

001061e5 <vector105>:
  1061e5:	6a 00                	push   $0x0
  1061e7:	6a 69                	push   $0x69
  1061e9:	e9 f2 f8 ff ff       	jmp    105ae0 <alltraps>

001061ee <vector106>:
  1061ee:	6a 00                	push   $0x0
  1061f0:	6a 6a                	push   $0x6a
  1061f2:	e9 e9 f8 ff ff       	jmp    105ae0 <alltraps>

001061f7 <vector107>:
  1061f7:	6a 00                	push   $0x0
  1061f9:	6a 6b                	push   $0x6b
  1061fb:	e9 e0 f8 ff ff       	jmp    105ae0 <alltraps>

00106200 <vector108>:
  106200:	6a 00                	push   $0x0
  106202:	6a 6c                	push   $0x6c
  106204:	e9 d7 f8 ff ff       	jmp    105ae0 <alltraps>

00106209 <vector109>:
  106209:	6a 00                	push   $0x0
  10620b:	6a 6d                	push   $0x6d
  10620d:	e9 ce f8 ff ff       	jmp    105ae0 <alltraps>

00106212 <vector110>:
  106212:	6a 00                	push   $0x0
  106214:	6a 6e                	push   $0x6e
  106216:	e9 c5 f8 ff ff       	jmp    105ae0 <alltraps>

0010621b <vector111>:
  10621b:	6a 00                	push   $0x0
  10621d:	6a 6f                	push   $0x6f
  10621f:	e9 bc f8 ff ff       	jmp    105ae0 <alltraps>

00106224 <vector112>:
  106224:	6a 00                	push   $0x0
  106226:	6a 70                	push   $0x70
  106228:	e9 b3 f8 ff ff       	jmp    105ae0 <alltraps>

0010622d <vector113>:
  10622d:	6a 00                	push   $0x0
  10622f:	6a 71                	push   $0x71
  106231:	e9 aa f8 ff ff       	jmp    105ae0 <alltraps>

00106236 <vector114>:
  106236:	6a 00                	push   $0x0
  106238:	6a 72                	push   $0x72
  10623a:	e9 a1 f8 ff ff       	jmp    105ae0 <alltraps>

0010623f <vector115>:
  10623f:	6a 00                	push   $0x0
  106241:	6a 73                	push   $0x73
  106243:	e9 98 f8 ff ff       	jmp    105ae0 <alltraps>

00106248 <vector116>:
  106248:	6a 00                	push   $0x0
  10624a:	6a 74                	push   $0x74
  10624c:	e9 8f f8 ff ff       	jmp    105ae0 <alltraps>

00106251 <vector117>:
  106251:	6a 00                	push   $0x0
  106253:	6a 75                	push   $0x75
  106255:	e9 86 f8 ff ff       	jmp    105ae0 <alltraps>

0010625a <vector118>:
  10625a:	6a 00                	push   $0x0
  10625c:	6a 76                	push   $0x76
  10625e:	e9 7d f8 ff ff       	jmp    105ae0 <alltraps>

00106263 <vector119>:
  106263:	6a 00                	push   $0x0
  106265:	6a 77                	push   $0x77
  106267:	e9 74 f8 ff ff       	jmp    105ae0 <alltraps>

0010626c <vector120>:
  10626c:	6a 00                	push   $0x0
  10626e:	6a 78                	push   $0x78
  106270:	e9 6b f8 ff ff       	jmp    105ae0 <alltraps>

00106275 <vector121>:
  106275:	6a 00                	push   $0x0
  106277:	6a 79                	push   $0x79
  106279:	e9 62 f8 ff ff       	jmp    105ae0 <alltraps>

0010627e <vector122>:
  10627e:	6a 00                	push   $0x0
  106280:	6a 7a                	push   $0x7a
  106282:	e9 59 f8 ff ff       	jmp    105ae0 <alltraps>

00106287 <vector123>:
  106287:	6a 00                	push   $0x0
  106289:	6a 7b                	push   $0x7b
  10628b:	e9 50 f8 ff ff       	jmp    105ae0 <alltraps>

00106290 <vector124>:
  106290:	6a 00                	push   $0x0
  106292:	6a 7c                	push   $0x7c
  106294:	e9 47 f8 ff ff       	jmp    105ae0 <alltraps>

00106299 <vector125>:
  106299:	6a 00                	push   $0x0
  10629b:	6a 7d                	push   $0x7d
  10629d:	e9 3e f8 ff ff       	jmp    105ae0 <alltraps>

001062a2 <vector126>:
  1062a2:	6a 00                	push   $0x0
  1062a4:	6a 7e                	push   $0x7e
  1062a6:	e9 35 f8 ff ff       	jmp    105ae0 <alltraps>

001062ab <vector127>:
  1062ab:	6a 00                	push   $0x0
  1062ad:	6a 7f                	push   $0x7f
  1062af:	e9 2c f8 ff ff       	jmp    105ae0 <alltraps>

001062b4 <vector128>:
  1062b4:	6a 00                	push   $0x0
  1062b6:	68 80 00 00 00       	push   $0x80
  1062bb:	e9 20 f8 ff ff       	jmp    105ae0 <alltraps>

001062c0 <vector129>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	68 81 00 00 00       	push   $0x81
  1062c7:	e9 14 f8 ff ff       	jmp    105ae0 <alltraps>

001062cc <vector130>:
  1062cc:	6a 00                	push   $0x0
  1062ce:	68 82 00 00 00       	push   $0x82
  1062d3:	e9 08 f8 ff ff       	jmp    105ae0 <alltraps>

001062d8 <vector131>:
  1062d8:	6a 00                	push   $0x0
  1062da:	68 83 00 00 00       	push   $0x83
  1062df:	e9 fc f7 ff ff       	jmp    105ae0 <alltraps>

001062e4 <vector132>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	68 84 00 00 00       	push   $0x84
  1062eb:	e9 f0 f7 ff ff       	jmp    105ae0 <alltraps>

001062f0 <vector133>:
  1062f0:	6a 00                	push   $0x0
  1062f2:	68 85 00 00 00       	push   $0x85
  1062f7:	e9 e4 f7 ff ff       	jmp    105ae0 <alltraps>

001062fc <vector134>:
  1062fc:	6a 00                	push   $0x0
  1062fe:	68 86 00 00 00       	push   $0x86
  106303:	e9 d8 f7 ff ff       	jmp    105ae0 <alltraps>

00106308 <vector135>:
  106308:	6a 00                	push   $0x0
  10630a:	68 87 00 00 00       	push   $0x87
  10630f:	e9 cc f7 ff ff       	jmp    105ae0 <alltraps>

00106314 <vector136>:
  106314:	6a 00                	push   $0x0
  106316:	68 88 00 00 00       	push   $0x88
  10631b:	e9 c0 f7 ff ff       	jmp    105ae0 <alltraps>

00106320 <vector137>:
  106320:	6a 00                	push   $0x0
  106322:	68 89 00 00 00       	push   $0x89
  106327:	e9 b4 f7 ff ff       	jmp    105ae0 <alltraps>

0010632c <vector138>:
  10632c:	6a 00                	push   $0x0
  10632e:	68 8a 00 00 00       	push   $0x8a
  106333:	e9 a8 f7 ff ff       	jmp    105ae0 <alltraps>

00106338 <vector139>:
  106338:	6a 00                	push   $0x0
  10633a:	68 8b 00 00 00       	push   $0x8b
  10633f:	e9 9c f7 ff ff       	jmp    105ae0 <alltraps>

00106344 <vector140>:
  106344:	6a 00                	push   $0x0
  106346:	68 8c 00 00 00       	push   $0x8c
  10634b:	e9 90 f7 ff ff       	jmp    105ae0 <alltraps>

00106350 <vector141>:
  106350:	6a 00                	push   $0x0
  106352:	68 8d 00 00 00       	push   $0x8d
  106357:	e9 84 f7 ff ff       	jmp    105ae0 <alltraps>

0010635c <vector142>:
  10635c:	6a 00                	push   $0x0
  10635e:	68 8e 00 00 00       	push   $0x8e
  106363:	e9 78 f7 ff ff       	jmp    105ae0 <alltraps>

00106368 <vector143>:
  106368:	6a 00                	push   $0x0
  10636a:	68 8f 00 00 00       	push   $0x8f
  10636f:	e9 6c f7 ff ff       	jmp    105ae0 <alltraps>

00106374 <vector144>:
  106374:	6a 00                	push   $0x0
  106376:	68 90 00 00 00       	push   $0x90
  10637b:	e9 60 f7 ff ff       	jmp    105ae0 <alltraps>

00106380 <vector145>:
  106380:	6a 00                	push   $0x0
  106382:	68 91 00 00 00       	push   $0x91
  106387:	e9 54 f7 ff ff       	jmp    105ae0 <alltraps>

0010638c <vector146>:
  10638c:	6a 00                	push   $0x0
  10638e:	68 92 00 00 00       	push   $0x92
  106393:	e9 48 f7 ff ff       	jmp    105ae0 <alltraps>

00106398 <vector147>:
  106398:	6a 00                	push   $0x0
  10639a:	68 93 00 00 00       	push   $0x93
  10639f:	e9 3c f7 ff ff       	jmp    105ae0 <alltraps>

001063a4 <vector148>:
  1063a4:	6a 00                	push   $0x0
  1063a6:	68 94 00 00 00       	push   $0x94
  1063ab:	e9 30 f7 ff ff       	jmp    105ae0 <alltraps>

001063b0 <vector149>:
  1063b0:	6a 00                	push   $0x0
  1063b2:	68 95 00 00 00       	push   $0x95
  1063b7:	e9 24 f7 ff ff       	jmp    105ae0 <alltraps>

001063bc <vector150>:
  1063bc:	6a 00                	push   $0x0
  1063be:	68 96 00 00 00       	push   $0x96
  1063c3:	e9 18 f7 ff ff       	jmp    105ae0 <alltraps>

001063c8 <vector151>:
  1063c8:	6a 00                	push   $0x0
  1063ca:	68 97 00 00 00       	push   $0x97
  1063cf:	e9 0c f7 ff ff       	jmp    105ae0 <alltraps>

001063d4 <vector152>:
  1063d4:	6a 00                	push   $0x0
  1063d6:	68 98 00 00 00       	push   $0x98
  1063db:	e9 00 f7 ff ff       	jmp    105ae0 <alltraps>

001063e0 <vector153>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	68 99 00 00 00       	push   $0x99
  1063e7:	e9 f4 f6 ff ff       	jmp    105ae0 <alltraps>

001063ec <vector154>:
  1063ec:	6a 00                	push   $0x0
  1063ee:	68 9a 00 00 00       	push   $0x9a
  1063f3:	e9 e8 f6 ff ff       	jmp    105ae0 <alltraps>

001063f8 <vector155>:
  1063f8:	6a 00                	push   $0x0
  1063fa:	68 9b 00 00 00       	push   $0x9b
  1063ff:	e9 dc f6 ff ff       	jmp    105ae0 <alltraps>

00106404 <vector156>:
  106404:	6a 00                	push   $0x0
  106406:	68 9c 00 00 00       	push   $0x9c
  10640b:	e9 d0 f6 ff ff       	jmp    105ae0 <alltraps>

00106410 <vector157>:
  106410:	6a 00                	push   $0x0
  106412:	68 9d 00 00 00       	push   $0x9d
  106417:	e9 c4 f6 ff ff       	jmp    105ae0 <alltraps>

0010641c <vector158>:
  10641c:	6a 00                	push   $0x0
  10641e:	68 9e 00 00 00       	push   $0x9e
  106423:	e9 b8 f6 ff ff       	jmp    105ae0 <alltraps>

00106428 <vector159>:
  106428:	6a 00                	push   $0x0
  10642a:	68 9f 00 00 00       	push   $0x9f
  10642f:	e9 ac f6 ff ff       	jmp    105ae0 <alltraps>

00106434 <vector160>:
  106434:	6a 00                	push   $0x0
  106436:	68 a0 00 00 00       	push   $0xa0
  10643b:	e9 a0 f6 ff ff       	jmp    105ae0 <alltraps>

00106440 <vector161>:
  106440:	6a 00                	push   $0x0
  106442:	68 a1 00 00 00       	push   $0xa1
  106447:	e9 94 f6 ff ff       	jmp    105ae0 <alltraps>

0010644c <vector162>:
  10644c:	6a 00                	push   $0x0
  10644e:	68 a2 00 00 00       	push   $0xa2
  106453:	e9 88 f6 ff ff       	jmp    105ae0 <alltraps>

00106458 <vector163>:
  106458:	6a 00                	push   $0x0
  10645a:	68 a3 00 00 00       	push   $0xa3
  10645f:	e9 7c f6 ff ff       	jmp    105ae0 <alltraps>

00106464 <vector164>:
  106464:	6a 00                	push   $0x0
  106466:	68 a4 00 00 00       	push   $0xa4
  10646b:	e9 70 f6 ff ff       	jmp    105ae0 <alltraps>

00106470 <vector165>:
  106470:	6a 00                	push   $0x0
  106472:	68 a5 00 00 00       	push   $0xa5
  106477:	e9 64 f6 ff ff       	jmp    105ae0 <alltraps>

0010647c <vector166>:
  10647c:	6a 00                	push   $0x0
  10647e:	68 a6 00 00 00       	push   $0xa6
  106483:	e9 58 f6 ff ff       	jmp    105ae0 <alltraps>

00106488 <vector167>:
  106488:	6a 00                	push   $0x0
  10648a:	68 a7 00 00 00       	push   $0xa7
  10648f:	e9 4c f6 ff ff       	jmp    105ae0 <alltraps>

00106494 <vector168>:
  106494:	6a 00                	push   $0x0
  106496:	68 a8 00 00 00       	push   $0xa8
  10649b:	e9 40 f6 ff ff       	jmp    105ae0 <alltraps>

001064a0 <vector169>:
  1064a0:	6a 00                	push   $0x0
  1064a2:	68 a9 00 00 00       	push   $0xa9
  1064a7:	e9 34 f6 ff ff       	jmp    105ae0 <alltraps>

001064ac <vector170>:
  1064ac:	6a 00                	push   $0x0
  1064ae:	68 aa 00 00 00       	push   $0xaa
  1064b3:	e9 28 f6 ff ff       	jmp    105ae0 <alltraps>

001064b8 <vector171>:
  1064b8:	6a 00                	push   $0x0
  1064ba:	68 ab 00 00 00       	push   $0xab
  1064bf:	e9 1c f6 ff ff       	jmp    105ae0 <alltraps>

001064c4 <vector172>:
  1064c4:	6a 00                	push   $0x0
  1064c6:	68 ac 00 00 00       	push   $0xac
  1064cb:	e9 10 f6 ff ff       	jmp    105ae0 <alltraps>

001064d0 <vector173>:
  1064d0:	6a 00                	push   $0x0
  1064d2:	68 ad 00 00 00       	push   $0xad
  1064d7:	e9 04 f6 ff ff       	jmp    105ae0 <alltraps>

001064dc <vector174>:
  1064dc:	6a 00                	push   $0x0
  1064de:	68 ae 00 00 00       	push   $0xae
  1064e3:	e9 f8 f5 ff ff       	jmp    105ae0 <alltraps>

001064e8 <vector175>:
  1064e8:	6a 00                	push   $0x0
  1064ea:	68 af 00 00 00       	push   $0xaf
  1064ef:	e9 ec f5 ff ff       	jmp    105ae0 <alltraps>

001064f4 <vector176>:
  1064f4:	6a 00                	push   $0x0
  1064f6:	68 b0 00 00 00       	push   $0xb0
  1064fb:	e9 e0 f5 ff ff       	jmp    105ae0 <alltraps>

00106500 <vector177>:
  106500:	6a 00                	push   $0x0
  106502:	68 b1 00 00 00       	push   $0xb1
  106507:	e9 d4 f5 ff ff       	jmp    105ae0 <alltraps>

0010650c <vector178>:
  10650c:	6a 00                	push   $0x0
  10650e:	68 b2 00 00 00       	push   $0xb2
  106513:	e9 c8 f5 ff ff       	jmp    105ae0 <alltraps>

00106518 <vector179>:
  106518:	6a 00                	push   $0x0
  10651a:	68 b3 00 00 00       	push   $0xb3
  10651f:	e9 bc f5 ff ff       	jmp    105ae0 <alltraps>

00106524 <vector180>:
  106524:	6a 00                	push   $0x0
  106526:	68 b4 00 00 00       	push   $0xb4
  10652b:	e9 b0 f5 ff ff       	jmp    105ae0 <alltraps>

00106530 <vector181>:
  106530:	6a 00                	push   $0x0
  106532:	68 b5 00 00 00       	push   $0xb5
  106537:	e9 a4 f5 ff ff       	jmp    105ae0 <alltraps>

0010653c <vector182>:
  10653c:	6a 00                	push   $0x0
  10653e:	68 b6 00 00 00       	push   $0xb6
  106543:	e9 98 f5 ff ff       	jmp    105ae0 <alltraps>

00106548 <vector183>:
  106548:	6a 00                	push   $0x0
  10654a:	68 b7 00 00 00       	push   $0xb7
  10654f:	e9 8c f5 ff ff       	jmp    105ae0 <alltraps>

00106554 <vector184>:
  106554:	6a 00                	push   $0x0
  106556:	68 b8 00 00 00       	push   $0xb8
  10655b:	e9 80 f5 ff ff       	jmp    105ae0 <alltraps>

00106560 <vector185>:
  106560:	6a 00                	push   $0x0
  106562:	68 b9 00 00 00       	push   $0xb9
  106567:	e9 74 f5 ff ff       	jmp    105ae0 <alltraps>

0010656c <vector186>:
  10656c:	6a 00                	push   $0x0
  10656e:	68 ba 00 00 00       	push   $0xba
  106573:	e9 68 f5 ff ff       	jmp    105ae0 <alltraps>

00106578 <vector187>:
  106578:	6a 00                	push   $0x0
  10657a:	68 bb 00 00 00       	push   $0xbb
  10657f:	e9 5c f5 ff ff       	jmp    105ae0 <alltraps>

00106584 <vector188>:
  106584:	6a 00                	push   $0x0
  106586:	68 bc 00 00 00       	push   $0xbc
  10658b:	e9 50 f5 ff ff       	jmp    105ae0 <alltraps>

00106590 <vector189>:
  106590:	6a 00                	push   $0x0
  106592:	68 bd 00 00 00       	push   $0xbd
  106597:	e9 44 f5 ff ff       	jmp    105ae0 <alltraps>

0010659c <vector190>:
  10659c:	6a 00                	push   $0x0
  10659e:	68 be 00 00 00       	push   $0xbe
  1065a3:	e9 38 f5 ff ff       	jmp    105ae0 <alltraps>

001065a8 <vector191>:
  1065a8:	6a 00                	push   $0x0
  1065aa:	68 bf 00 00 00       	push   $0xbf
  1065af:	e9 2c f5 ff ff       	jmp    105ae0 <alltraps>

001065b4 <vector192>:
  1065b4:	6a 00                	push   $0x0
  1065b6:	68 c0 00 00 00       	push   $0xc0
  1065bb:	e9 20 f5 ff ff       	jmp    105ae0 <alltraps>

001065c0 <vector193>:
  1065c0:	6a 00                	push   $0x0
  1065c2:	68 c1 00 00 00       	push   $0xc1
  1065c7:	e9 14 f5 ff ff       	jmp    105ae0 <alltraps>

001065cc <vector194>:
  1065cc:	6a 00                	push   $0x0
  1065ce:	68 c2 00 00 00       	push   $0xc2
  1065d3:	e9 08 f5 ff ff       	jmp    105ae0 <alltraps>

001065d8 <vector195>:
  1065d8:	6a 00                	push   $0x0
  1065da:	68 c3 00 00 00       	push   $0xc3
  1065df:	e9 fc f4 ff ff       	jmp    105ae0 <alltraps>

001065e4 <vector196>:
  1065e4:	6a 00                	push   $0x0
  1065e6:	68 c4 00 00 00       	push   $0xc4
  1065eb:	e9 f0 f4 ff ff       	jmp    105ae0 <alltraps>

001065f0 <vector197>:
  1065f0:	6a 00                	push   $0x0
  1065f2:	68 c5 00 00 00       	push   $0xc5
  1065f7:	e9 e4 f4 ff ff       	jmp    105ae0 <alltraps>

001065fc <vector198>:
  1065fc:	6a 00                	push   $0x0
  1065fe:	68 c6 00 00 00       	push   $0xc6
  106603:	e9 d8 f4 ff ff       	jmp    105ae0 <alltraps>

00106608 <vector199>:
  106608:	6a 00                	push   $0x0
  10660a:	68 c7 00 00 00       	push   $0xc7
  10660f:	e9 cc f4 ff ff       	jmp    105ae0 <alltraps>

00106614 <vector200>:
  106614:	6a 00                	push   $0x0
  106616:	68 c8 00 00 00       	push   $0xc8
  10661b:	e9 c0 f4 ff ff       	jmp    105ae0 <alltraps>

00106620 <vector201>:
  106620:	6a 00                	push   $0x0
  106622:	68 c9 00 00 00       	push   $0xc9
  106627:	e9 b4 f4 ff ff       	jmp    105ae0 <alltraps>

0010662c <vector202>:
  10662c:	6a 00                	push   $0x0
  10662e:	68 ca 00 00 00       	push   $0xca
  106633:	e9 a8 f4 ff ff       	jmp    105ae0 <alltraps>

00106638 <vector203>:
  106638:	6a 00                	push   $0x0
  10663a:	68 cb 00 00 00       	push   $0xcb
  10663f:	e9 9c f4 ff ff       	jmp    105ae0 <alltraps>

00106644 <vector204>:
  106644:	6a 00                	push   $0x0
  106646:	68 cc 00 00 00       	push   $0xcc
  10664b:	e9 90 f4 ff ff       	jmp    105ae0 <alltraps>

00106650 <vector205>:
  106650:	6a 00                	push   $0x0
  106652:	68 cd 00 00 00       	push   $0xcd
  106657:	e9 84 f4 ff ff       	jmp    105ae0 <alltraps>

0010665c <vector206>:
  10665c:	6a 00                	push   $0x0
  10665e:	68 ce 00 00 00       	push   $0xce
  106663:	e9 78 f4 ff ff       	jmp    105ae0 <alltraps>

00106668 <vector207>:
  106668:	6a 00                	push   $0x0
  10666a:	68 cf 00 00 00       	push   $0xcf
  10666f:	e9 6c f4 ff ff       	jmp    105ae0 <alltraps>

00106674 <vector208>:
  106674:	6a 00                	push   $0x0
  106676:	68 d0 00 00 00       	push   $0xd0
  10667b:	e9 60 f4 ff ff       	jmp    105ae0 <alltraps>

00106680 <vector209>:
  106680:	6a 00                	push   $0x0
  106682:	68 d1 00 00 00       	push   $0xd1
  106687:	e9 54 f4 ff ff       	jmp    105ae0 <alltraps>

0010668c <vector210>:
  10668c:	6a 00                	push   $0x0
  10668e:	68 d2 00 00 00       	push   $0xd2
  106693:	e9 48 f4 ff ff       	jmp    105ae0 <alltraps>

00106698 <vector211>:
  106698:	6a 00                	push   $0x0
  10669a:	68 d3 00 00 00       	push   $0xd3
  10669f:	e9 3c f4 ff ff       	jmp    105ae0 <alltraps>

001066a4 <vector212>:
  1066a4:	6a 00                	push   $0x0
  1066a6:	68 d4 00 00 00       	push   $0xd4
  1066ab:	e9 30 f4 ff ff       	jmp    105ae0 <alltraps>

001066b0 <vector213>:
  1066b0:	6a 00                	push   $0x0
  1066b2:	68 d5 00 00 00       	push   $0xd5
  1066b7:	e9 24 f4 ff ff       	jmp    105ae0 <alltraps>

001066bc <vector214>:
  1066bc:	6a 00                	push   $0x0
  1066be:	68 d6 00 00 00       	push   $0xd6
  1066c3:	e9 18 f4 ff ff       	jmp    105ae0 <alltraps>

001066c8 <vector215>:
  1066c8:	6a 00                	push   $0x0
  1066ca:	68 d7 00 00 00       	push   $0xd7
  1066cf:	e9 0c f4 ff ff       	jmp    105ae0 <alltraps>

001066d4 <vector216>:
  1066d4:	6a 00                	push   $0x0
  1066d6:	68 d8 00 00 00       	push   $0xd8
  1066db:	e9 00 f4 ff ff       	jmp    105ae0 <alltraps>

001066e0 <vector217>:
  1066e0:	6a 00                	push   $0x0
  1066e2:	68 d9 00 00 00       	push   $0xd9
  1066e7:	e9 f4 f3 ff ff       	jmp    105ae0 <alltraps>

001066ec <vector218>:
  1066ec:	6a 00                	push   $0x0
  1066ee:	68 da 00 00 00       	push   $0xda
  1066f3:	e9 e8 f3 ff ff       	jmp    105ae0 <alltraps>

001066f8 <vector219>:
  1066f8:	6a 00                	push   $0x0
  1066fa:	68 db 00 00 00       	push   $0xdb
  1066ff:	e9 dc f3 ff ff       	jmp    105ae0 <alltraps>

00106704 <vector220>:
  106704:	6a 00                	push   $0x0
  106706:	68 dc 00 00 00       	push   $0xdc
  10670b:	e9 d0 f3 ff ff       	jmp    105ae0 <alltraps>

00106710 <vector221>:
  106710:	6a 00                	push   $0x0
  106712:	68 dd 00 00 00       	push   $0xdd
  106717:	e9 c4 f3 ff ff       	jmp    105ae0 <alltraps>

0010671c <vector222>:
  10671c:	6a 00                	push   $0x0
  10671e:	68 de 00 00 00       	push   $0xde
  106723:	e9 b8 f3 ff ff       	jmp    105ae0 <alltraps>

00106728 <vector223>:
  106728:	6a 00                	push   $0x0
  10672a:	68 df 00 00 00       	push   $0xdf
  10672f:	e9 ac f3 ff ff       	jmp    105ae0 <alltraps>

00106734 <vector224>:
  106734:	6a 00                	push   $0x0
  106736:	68 e0 00 00 00       	push   $0xe0
  10673b:	e9 a0 f3 ff ff       	jmp    105ae0 <alltraps>

00106740 <vector225>:
  106740:	6a 00                	push   $0x0
  106742:	68 e1 00 00 00       	push   $0xe1
  106747:	e9 94 f3 ff ff       	jmp    105ae0 <alltraps>

0010674c <vector226>:
  10674c:	6a 00                	push   $0x0
  10674e:	68 e2 00 00 00       	push   $0xe2
  106753:	e9 88 f3 ff ff       	jmp    105ae0 <alltraps>

00106758 <vector227>:
  106758:	6a 00                	push   $0x0
  10675a:	68 e3 00 00 00       	push   $0xe3
  10675f:	e9 7c f3 ff ff       	jmp    105ae0 <alltraps>

00106764 <vector228>:
  106764:	6a 00                	push   $0x0
  106766:	68 e4 00 00 00       	push   $0xe4
  10676b:	e9 70 f3 ff ff       	jmp    105ae0 <alltraps>

00106770 <vector229>:
  106770:	6a 00                	push   $0x0
  106772:	68 e5 00 00 00       	push   $0xe5
  106777:	e9 64 f3 ff ff       	jmp    105ae0 <alltraps>

0010677c <vector230>:
  10677c:	6a 00                	push   $0x0
  10677e:	68 e6 00 00 00       	push   $0xe6
  106783:	e9 58 f3 ff ff       	jmp    105ae0 <alltraps>

00106788 <vector231>:
  106788:	6a 00                	push   $0x0
  10678a:	68 e7 00 00 00       	push   $0xe7
  10678f:	e9 4c f3 ff ff       	jmp    105ae0 <alltraps>

00106794 <vector232>:
  106794:	6a 00                	push   $0x0
  106796:	68 e8 00 00 00       	push   $0xe8
  10679b:	e9 40 f3 ff ff       	jmp    105ae0 <alltraps>

001067a0 <vector233>:
  1067a0:	6a 00                	push   $0x0
  1067a2:	68 e9 00 00 00       	push   $0xe9
  1067a7:	e9 34 f3 ff ff       	jmp    105ae0 <alltraps>

001067ac <vector234>:
  1067ac:	6a 00                	push   $0x0
  1067ae:	68 ea 00 00 00       	push   $0xea
  1067b3:	e9 28 f3 ff ff       	jmp    105ae0 <alltraps>

001067b8 <vector235>:
  1067b8:	6a 00                	push   $0x0
  1067ba:	68 eb 00 00 00       	push   $0xeb
  1067bf:	e9 1c f3 ff ff       	jmp    105ae0 <alltraps>

001067c4 <vector236>:
  1067c4:	6a 00                	push   $0x0
  1067c6:	68 ec 00 00 00       	push   $0xec
  1067cb:	e9 10 f3 ff ff       	jmp    105ae0 <alltraps>

001067d0 <vector237>:
  1067d0:	6a 00                	push   $0x0
  1067d2:	68 ed 00 00 00       	push   $0xed
  1067d7:	e9 04 f3 ff ff       	jmp    105ae0 <alltraps>

001067dc <vector238>:
  1067dc:	6a 00                	push   $0x0
  1067de:	68 ee 00 00 00       	push   $0xee
  1067e3:	e9 f8 f2 ff ff       	jmp    105ae0 <alltraps>

001067e8 <vector239>:
  1067e8:	6a 00                	push   $0x0
  1067ea:	68 ef 00 00 00       	push   $0xef
  1067ef:	e9 ec f2 ff ff       	jmp    105ae0 <alltraps>

001067f4 <vector240>:
  1067f4:	6a 00                	push   $0x0
  1067f6:	68 f0 00 00 00       	push   $0xf0
  1067fb:	e9 e0 f2 ff ff       	jmp    105ae0 <alltraps>

00106800 <vector241>:
  106800:	6a 00                	push   $0x0
  106802:	68 f1 00 00 00       	push   $0xf1
  106807:	e9 d4 f2 ff ff       	jmp    105ae0 <alltraps>

0010680c <vector242>:
  10680c:	6a 00                	push   $0x0
  10680e:	68 f2 00 00 00       	push   $0xf2
  106813:	e9 c8 f2 ff ff       	jmp    105ae0 <alltraps>

00106818 <vector243>:
  106818:	6a 00                	push   $0x0
  10681a:	68 f3 00 00 00       	push   $0xf3
  10681f:	e9 bc f2 ff ff       	jmp    105ae0 <alltraps>

00106824 <vector244>:
  106824:	6a 00                	push   $0x0
  106826:	68 f4 00 00 00       	push   $0xf4
  10682b:	e9 b0 f2 ff ff       	jmp    105ae0 <alltraps>

00106830 <vector245>:
  106830:	6a 00                	push   $0x0
  106832:	68 f5 00 00 00       	push   $0xf5
  106837:	e9 a4 f2 ff ff       	jmp    105ae0 <alltraps>

0010683c <vector246>:
  10683c:	6a 00                	push   $0x0
  10683e:	68 f6 00 00 00       	push   $0xf6
  106843:	e9 98 f2 ff ff       	jmp    105ae0 <alltraps>

00106848 <vector247>:
  106848:	6a 00                	push   $0x0
  10684a:	68 f7 00 00 00       	push   $0xf7
  10684f:	e9 8c f2 ff ff       	jmp    105ae0 <alltraps>

00106854 <vector248>:
  106854:	6a 00                	push   $0x0
  106856:	68 f8 00 00 00       	push   $0xf8
  10685b:	e9 80 f2 ff ff       	jmp    105ae0 <alltraps>

00106860 <vector249>:
  106860:	6a 00                	push   $0x0
  106862:	68 f9 00 00 00       	push   $0xf9
  106867:	e9 74 f2 ff ff       	jmp    105ae0 <alltraps>

0010686c <vector250>:
  10686c:	6a 00                	push   $0x0
  10686e:	68 fa 00 00 00       	push   $0xfa
  106873:	e9 68 f2 ff ff       	jmp    105ae0 <alltraps>

00106878 <vector251>:
  106878:	6a 00                	push   $0x0
  10687a:	68 fb 00 00 00       	push   $0xfb
  10687f:	e9 5c f2 ff ff       	jmp    105ae0 <alltraps>

00106884 <vector252>:
  106884:	6a 00                	push   $0x0
  106886:	68 fc 00 00 00       	push   $0xfc
  10688b:	e9 50 f2 ff ff       	jmp    105ae0 <alltraps>

00106890 <vector253>:
  106890:	6a 00                	push   $0x0
  106892:	68 fd 00 00 00       	push   $0xfd
  106897:	e9 44 f2 ff ff       	jmp    105ae0 <alltraps>

0010689c <vector254>:
  10689c:	6a 00                	push   $0x0
  10689e:	68 fe 00 00 00       	push   $0xfe
  1068a3:	e9 38 f2 ff ff       	jmp    105ae0 <alltraps>

001068a8 <vector255>:
  1068a8:	6a 00                	push   $0x0
  1068aa:	68 ff 00 00 00       	push   $0xff
  1068af:	e9 2c f2 ff ff       	jmp    105ae0 <alltraps>
