
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
  10000f:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  100016:	e8 65 45 00 00       	call   104580 <acquire>

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
  10002a:	c7 43 0c 20 87 10 00 	movl   $0x108720,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 30 87 10 00       	mov    0x108730,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 30 87 10 00       	mov    0x108730,%eax
  bufhead.next = b;
  100041:	89 1d 30 87 10 00    	mov    %ebx,0x108730

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 40 89 10 00 	movl   $0x108940,(%esp)
  100051:	e8 ea 33 00 00       	call   103440 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 40 9e 10 00 	movl   $0x109e40,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 d9 44 00 00       	jmp    104540 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
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
  10008e:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  100095:	e8 e6 44 00 00       	call   104580 <acquire>

	  // Try for cached block.
	  for(b = bufhead.next; b != &bufhead; b = b->next){
  10009a:	a1 30 87 10 00       	mov    0x108730,%eax
  10009f:	3d 20 87 10 00       	cmp    $0x108720,%eax
  1000a4:	75 0c                	jne    1000b2 <bcheck+0x32>
  1000a6:	eb 38                	jmp    1000e0 <bcheck+0x60>
  1000a8:	8b 40 10             	mov    0x10(%eax),%eax
  1000ab:	3d 20 87 10 00       	cmp    $0x108720,%eax
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
  1000c2:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  1000c9:	e8 72 44 00 00       	call   104540 <release>
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
  1000e0:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  1000e7:	e8 54 44 00 00       	call   104540 <release>
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
  100119:	e9 22 20 00 00       	jmp    102140 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10011e:	c7 04 24 27 67 10 00 	movl   $0x106727,(%esp)
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
  10013f:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  100146:	e8 35 44 00 00       	call   104580 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10014b:	8b 1d 30 87 10 00    	mov    0x108730,%ebx
  100151:	81 fb 20 87 10 00    	cmp    $0x108720,%ebx
  100157:	75 12                	jne    10016b <bread+0x3b>
  100159:	eb 3d                	jmp    100198 <bread+0x68>
  10015b:	90                   	nop
  10015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100160:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100163:	81 fb 20 87 10 00    	cmp    $0x108720,%ebx
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
  100182:	c7 44 24 04 40 9e 10 	movl   $0x109e40,0x4(%esp)
  100189:	00 
  10018a:	c7 04 24 40 89 10 00 	movl   $0x108940,(%esp)
  100191:	e8 5a 36 00 00       	call   1037f0 <sleep>
  100196:	eb b3                	jmp    10014b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100198:	8b 1d 2c 87 10 00    	mov    0x10872c,%ebx
  10019e:	81 fb 20 87 10 00    	cmp    $0x108720,%ebx
  1001a4:	75 0d                	jne    1001b3 <bread+0x83>
  1001a6:	eb 3f                	jmp    1001e7 <bread+0xb7>
  1001a8:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1001ab:	81 fb 20 87 10 00    	cmp    $0x108720,%ebx
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
  1001c4:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  1001cb:	e8 70 43 00 00       	call   104540 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  1001d0:	f6 03 02             	testb  $0x2,(%ebx)
  1001d3:	75 08                	jne    1001dd <bread+0xad>
    ide_rw(b);
  1001d5:	89 1c 24             	mov    %ebx,(%esp)
  1001d8:	e8 63 1f 00 00       	call   102140 <ide_rw>
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
  1001e7:	c7 04 24 2e 67 10 00 	movl   $0x10672e,(%esp)
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
  1001f8:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  1001ff:	e8 3c 43 00 00       	call   104540 <release>
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
  100216:	c7 44 24 04 3f 67 10 	movl   $0x10673f,0x4(%esp)
  10021d:	00 
  10021e:	c7 04 24 40 9e 10 00 	movl   $0x109e40,(%esp)
  100225:	e8 96 41 00 00       	call   1043c0 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10022a:	b8 30 9e 10 00       	mov    $0x109e30,%eax
  10022f:	3d 40 89 10 00       	cmp    $0x108940,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  100234:	c7 05 2c 87 10 00 20 	movl   $0x108720,0x10872c
  10023b:	87 10 00 
  bufhead.next = &bufhead;
  10023e:	c7 05 30 87 10 00 20 	movl   $0x108720,0x108730
  100245:	87 10 00 
  for(b = buf; b < buf+NBUF; b++){
  100248:	76 33                	jbe    10027d <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  10024a:	ba 20 87 10 00       	mov    $0x108720,%edx
  10024f:	b8 40 89 10 00       	mov    $0x108940,%eax
  100254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100258:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  10025b:	c7 40 0c 20 87 10 00 	movl   $0x108720,0xc(%eax)
    bufhead.next->prev = b;
  100262:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100265:	89 c2                	mov    %eax,%edx
  100267:	05 18 02 00 00       	add    $0x218,%eax
  10026c:	3d 30 9e 10 00       	cmp    $0x109e30,%eax
  100271:	75 e5                	jne    100258 <binit+0x48>
  100273:	c7 05 30 87 10 00 18 	movl   $0x109c18,0x108730
  10027a:	9c 10 00 
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
  100286:	c7 44 24 04 49 67 10 	movl   $0x106749,0x4(%esp)
  10028d:	00 
  10028e:	c7 04 24 80 86 10 00 	movl   $0x108680,(%esp)
  100295:	e8 26 41 00 00       	call   1043c0 <initlock>
  initlock(&input.lock, "console input");
  10029a:	c7 44 24 04 51 67 10 	movl   $0x106751,0x4(%esp)
  1002a1:	00 
  1002a2:	c7 04 24 80 9e 10 00 	movl   $0x109e80,(%esp)
  1002a9:	e8 12 41 00 00       	call   1043c0 <initlock>

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
  1002b5:	c7 05 ec a8 10 00 d0 	movl   $0x1006d0,0x10a8ec
  1002bc:	06 10 00 
  devsw[CONSOLE].read = console_read;
  1002bf:	c7 05 e8 a8 10 00 f0 	movl   $0x1002f0,0x10a8e8
  1002c6:	02 10 00 
  use_console_lock = 1;
  1002c9:	c7 05 64 86 10 00 01 	movl   $0x1,0x108664
  1002d0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002d3:	e8 78 2b 00 00       	call   102e50 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002df:	00 
  1002e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002e7:	e8 44 20 00 00       	call   102330 <ioapic_enable>
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
  100302:	e8 19 1a 00 00       	call   101d20 <iunlock>
  target = n;
  100307:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10030a:	c7 04 24 80 9e 10 00 	movl   $0x109e80,(%esp)
  100311:	e8 6a 42 00 00       	call   104580 <acquire>
  while(n > 0){
  100316:	85 db                	test   %ebx,%ebx
  100318:	7f 26                	jg     100340 <console_read+0x50>
  10031a:	e9 bb 00 00 00       	jmp    1003da <console_read+0xea>
  10031f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  100320:	e8 1b 32 00 00       	call   103540 <curproc>
  100325:	8b 40 1c             	mov    0x1c(%eax),%eax
  100328:	85 c0                	test   %eax,%eax
  10032a:	75 5c                	jne    100388 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10032c:	c7 44 24 04 80 9e 10 	movl   $0x109e80,0x4(%esp)
  100333:	00 
  100334:	c7 04 24 34 9f 10 00 	movl   $0x109f34,(%esp)
  10033b:	e8 b0 34 00 00       	call   1037f0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100340:	a1 34 9f 10 00       	mov    0x109f34,%eax
  100345:	3b 05 38 9f 10 00    	cmp    0x109f38,%eax
  10034b:	74 d3                	je     100320 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10034d:	89 c2                	mov    %eax,%edx
  10034f:	83 e2 7f             	and    $0x7f,%edx
  100352:	0f b6 8a b4 9e 10 00 	movzbl 0x109eb4(%edx),%ecx
  100359:	8d 78 01             	lea    0x1(%eax),%edi
  10035c:	89 3d 34 9f 10 00    	mov    %edi,0x109f34
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
  100388:	c7 04 24 80 9e 10 00 	movl   $0x109e80,(%esp)
  10038f:	e8 ac 41 00 00       	call   104540 <release>
        ilock(ip);
  100394:	89 34 24             	mov    %esi,(%esp)
  100397:	e8 f4 19 00 00       	call   101d90 <ilock>
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
  1003ae:	a3 34 9f 10 00       	mov    %eax,0x109f34
  1003b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1003b6:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  1003b8:	c7 04 24 80 9e 10 00 	movl   $0x109e80,(%esp)
  1003bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1003c2:	e8 79 41 00 00       	call   104540 <release>
  ilock(ip);
  1003c7:	89 34 24             	mov    %esi,(%esp)
  1003ca:	e8 c1 19 00 00       	call   101d90 <ilock>
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
  1003ec:	83 3d 60 86 10 00 00 	cmpl   $0x0,0x108660
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
  100508:	e8 73 41 00 00       	call   104680 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10050d:	b8 80 07 00 00       	mov    $0x780,%eax
  100512:	29 d8                	sub    %ebx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	89 44 24 08          	mov    %eax,0x8(%esp)
  10051a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100521:	00 
  100522:	89 34 24             	mov    %esi,(%esp)
  100525:	e8 c6 40 00 00       	call   1045f0 <memset>
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
  100574:	be b0 9e 10 00       	mov    $0x109eb0,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100579:	53                   	push   %ebx
  10057a:	83 ec 20             	sub    $0x20,%esp
  10057d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100580:	c7 04 24 80 9e 10 00 	movl   $0x109e80,(%esp)
  100587:	e8 f4 3f 00 00       	call   104580 <acquire>
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
  1005bc:	8b 15 3c 9f 10 00    	mov    0x109f3c,%edx
  1005c2:	89 d1                	mov    %edx,%ecx
  1005c4:	2b 0d 34 9f 10 00    	sub    0x109f34,%ecx
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
  1005e1:	89 15 3c 9f 10 00    	mov    %edx,0x109f3c
        cons_putc(c);
  1005e7:	e8 f4 fd ff ff       	call   1003e0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ef:	83 f8 04             	cmp    $0x4,%eax
  1005f2:	0f 84 ba 00 00 00    	je     1006b2 <console_intr+0x142>
  1005f8:	83 f8 0a             	cmp    $0xa,%eax
  1005fb:	0f 84 b1 00 00 00    	je     1006b2 <console_intr+0x142>
  100601:	8b 15 34 9f 10 00    	mov    0x109f34,%edx
  100607:	a1 3c 9f 10 00       	mov    0x109f3c,%eax
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
  100628:	c7 45 08 80 9e 10 00 	movl   $0x109e80,0x8(%ebp)
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
  100635:	e9 06 3f 00 00       	jmp    104540 <release>
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
  100648:	80 ba b4 9e 10 00 0a 	cmpb   $0xa,0x109eb4(%edx)
  10064f:	0f 84 3b ff ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100655:	a3 3c 9f 10 00       	mov    %eax,0x109f3c
        cons_putc(BACKSPACE);
  10065a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100661:	e8 7a fd ff ff       	call   1003e0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100666:	a1 3c 9f 10 00       	mov    0x109f3c,%eax
  10066b:	3b 05 38 9f 10 00    	cmp    0x109f38,%eax
  100671:	75 cd                	jne    100640 <console_intr+0xd0>
  100673:	e9 18 ff ff ff       	jmp    100590 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100678:	e8 63 2c 00 00       	call   1032e0 <procdump>
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
  100688:	a1 3c 9f 10 00       	mov    0x109f3c,%eax
  10068d:	3b 05 38 9f 10 00    	cmp    0x109f38,%eax
  100693:	0f 84 f7 fe ff ff    	je     100590 <console_intr+0x20>
        input.e--;
  100699:	83 e8 01             	sub    $0x1,%eax
  10069c:	a3 3c 9f 10 00       	mov    %eax,0x109f3c
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
  1006b2:	a1 3c 9f 10 00       	mov    0x109f3c,%eax
          input.w = input.e;
  1006b7:	a3 38 9f 10 00       	mov    %eax,0x109f38
          wakeup(&input.r);
  1006bc:	c7 04 24 34 9f 10 00 	movl   $0x109f34,(%esp)
  1006c3:	e8 78 2d 00 00       	call   103440 <wakeup>
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
  1006e5:	e8 36 16 00 00       	call   101d20 <iunlock>
  acquire(&console_lock);
  1006ea:	c7 04 24 80 86 10 00 	movl   $0x108680,(%esp)
  1006f1:	e8 8a 3e 00 00       	call   104580 <acquire>
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
  100713:	c7 04 24 80 86 10 00 	movl   $0x108680,(%esp)
  10071a:	e8 21 3e 00 00       	call   104540 <release>
  ilock(ip);
  10071f:	8b 45 08             	mov    0x8(%ebp),%eax
  100722:	89 04 24             	mov    %eax,(%esp)
  100725:	e8 66 16 00 00       	call   101d90 <ilock>

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
  10076c:	0f b6 92 79 67 10 00 	movzbl 0x106779(%edx),%edx
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
  1007c9:	a1 64 86 10 00       	mov    0x108664,%eax
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
  10086f:	c7 04 24 80 86 10 00 	movl   $0x108680,(%esp)
  100876:	e8 c5 3c 00 00       	call   104540 <release>
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
  100940:	c7 04 24 80 86 10 00 	movl   $0x108680,(%esp)
  100947:	e8 34 3c 00 00       	call   104580 <acquire>
  10094c:	e9 88 fe ff ff       	jmp    1007d9 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  100951:	be 5f 67 10 00       	mov    $0x10675f,%esi
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
  100968:	c7 05 64 86 10 00 00 	movl   $0x0,0x108664
  10096f:	00 00 00 
panic(char *s)
{
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  100972:	fa                   	cli    
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  100973:	e8 38 20 00 00       	call   1029b0 <cpu>
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
  10097d:	c7 04 24 66 67 10 00 	movl   $0x106766,(%esp)
  100984:	89 44 24 04          	mov    %eax,0x4(%esp)
  100988:	e8 33 fe ff ff       	call   1007c0 <cprintf>
  cprintf(s);
  10098d:	8b 45 08             	mov    0x8(%ebp),%eax
  100990:	89 04 24             	mov    %eax,(%esp)
  100993:	e8 28 fe ff ff       	call   1007c0 <cprintf>
  cprintf("\n");
  100998:	c7 04 24 d3 6b 10 00 	movl   $0x106bd3,(%esp)
  10099f:	e8 1c fe ff ff       	call   1007c0 <cprintf>
  getcallerpcs(&s, pcs);
  1009a4:	8d 45 08             	lea    0x8(%ebp),%eax
  1009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1009ab:	89 04 24             	mov    %eax,(%esp)
  1009ae:	e8 2d 3a 00 00       	call   1043e0 <getcallerpcs>
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
  1009be:	c7 04 24 75 67 10 00 	movl   $0x106775,(%esp)
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
  1009d3:	c7 05 60 86 10 00 01 	movl   $0x1,0x108660
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
  1009f2:	e8 59 16 00 00       	call   102050 <namei>
  1009f7:	89 c3                	mov    %eax,%ebx
  1009f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009fe:	85 db                	test   %ebx,%ebx
  100a00:	0f 84 81 03 00 00    	je     100d87 <exec+0x3a7>
    return -1;
  ilock(ip);
  100a06:	89 1c 24             	mov    %ebx,(%esp)
  100a09:	e8 82 13 00 00       	call   101d90 <ilock>
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
  100a28:	e8 d3 0a 00 00       	call   101500 <readi>
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
  100a84:	e8 77 0a 00 00       	call   101500 <readi>
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
  100aee:	e8 dd 3c 00 00       	call   1047d0 <strlen>
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
  100b36:	e8 e5 18 00 00       	call   102420 <kalloc>
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
  100b5b:	e8 90 3a 00 00       	call   1045f0 <memset>

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
  100ba0:	e8 5b 09 00 00       	call   101500 <readi>
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
  100bdd:	e8 1e 09 00 00       	call   101500 <readi>
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
  100c08:	e8 e3 39 00 00       	call   1045f0 <memset>
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
  100c1c:	e8 4f 11 00 00       	call   101d70 <iunlockput>
  
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
  100c86:	e8 45 3b 00 00       	call   1047d0 <strlen>
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
  100ca5:	e8 d6 39 00 00       	call   104680 <memmove>
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
  100d0b:	e8 30 28 00 00       	call   103540 <curproc>
  100d10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d14:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d1b:	00 
  100d1c:	05 88 00 00 00       	add    $0x88,%eax
  100d21:	89 04 24             	mov    %eax,(%esp)
  100d24:	e8 67 3a 00 00       	call   104790 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100d29:	e8 12 28 00 00       	call   103540 <curproc>
  100d2e:	8b 58 04             	mov    0x4(%eax),%ebx
  100d31:	e8 0a 28 00 00       	call   103540 <curproc>
  100d36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d3a:	8b 00                	mov    (%eax),%eax
  100d3c:	89 04 24             	mov    %eax,(%esp)
  100d3f:	e8 9c 17 00 00       	call   1024e0 <kfree>
  cp->mem = mem;
  100d44:	e8 f7 27 00 00       	call   103540 <curproc>
  100d49:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d4c:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100d4e:	e8 ed 27 00 00       	call   103540 <curproc>
  100d53:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100d56:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d59:	e8 e2 27 00 00       	call   103540 <curproc>
  100d5e:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100d61:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d67:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100d6a:	e8 d1 27 00 00       	call   103540 <curproc>
  100d6f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d75:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d78:	e8 c3 27 00 00       	call   103540 <curproc>
  100d7d:	89 04 24             	mov    %eax,(%esp)
  100d80:	e8 8b 2d 00 00       	call   103b10 <setupsegs>
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
  100da5:	e8 36 17 00 00       	call   1024e0 <kfree>
  iunlockput(ip);
  100daa:	89 1c 24             	mov    %ebx,(%esp)
  100dad:	e8 be 0f 00 00       	call   101d70 <iunlockput>
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
  100e10:	e8 7b 0f 00 00       	call   101d90 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100e15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e19:	8b 43 14             	mov    0x14(%ebx),%eax
  100e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e24:	8b 43 10             	mov    0x10(%ebx),%eax
  100e27:	89 04 24             	mov    %eax,(%esp)
  100e2a:	e8 71 08 00 00       	call   1016a0 <writei>
  100e2f:	85 c0                	test   %eax,%eax
  100e31:	7e 03                	jle    100e36 <filewrite+0x56>
      f->off += r;
  100e33:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e36:	8b 53 10             	mov    0x10(%ebx),%edx
  100e39:	89 14 24             	mov    %edx,(%esp)
  100e3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100e3f:	e8 dc 0e 00 00       	call   101d20 <iunlock>
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
  100e72:	e9 89 21 00 00       	jmp    103000 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e77:	c7 04 24 8a 67 10 00 	movl   $0x10678a,(%esp)
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
  100eb0:	e8 db 0e 00 00       	call   101d90 <ilock>
    //cprintf("calling checki\n");
    r = checki(f->ip, offset);
  100eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ebc:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebf:	89 04 24             	mov    %eax,(%esp)
  100ec2:	e8 39 0a 00 00       	call   101900 <checki>
  100ec7:	89 c6                	mov    %eax,%esi
    iunlock(f->ip);
  100ec9:	8b 43 10             	mov    0x10(%ebx),%eax
  100ecc:	89 04 24             	mov    %eax,(%esp)
  100ecf:	e8 4c 0e 00 00       	call   101d20 <iunlock>
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
  100ef1:	c7 04 24 94 67 10 00 	movl   $0x106794,(%esp)
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
  100f30:	e8 5b 0e 00 00       	call   101d90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100f35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100f39:	8b 43 14             	mov    0x14(%ebx),%eax
  100f3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f44:	8b 43 10             	mov    0x10(%ebx),%eax
  100f47:	89 04 24             	mov    %eax,(%esp)
  100f4a:	e8 b1 05 00 00       	call   101500 <readi>
  100f4f:	85 c0                	test   %eax,%eax
  100f51:	7e 03                	jle    100f56 <fileread+0x56>
      f->off += r;
  100f53:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100f56:	8b 53 10             	mov    0x10(%ebx),%edx
  100f59:	89 14 24             	mov    %edx,(%esp)
  100f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100f5f:	e8 bc 0d 00 00       	call   101d20 <iunlock>
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
  100f92:	e9 89 1f 00 00       	jmp    102f20 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100f97:	c7 04 24 9e 67 10 00 	movl   $0x10679e,(%esp)
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
  100fd6:	e8 b5 0d 00 00       	call   101d90 <ilock>
    stati(f->ip, st);
  100fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100fde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100fe2:	8b 43 10             	mov    0x10(%ebx),%eax
  100fe5:	89 04 24             	mov    %eax,(%esp)
  100fe8:	e8 f3 01 00 00       	call   1011e0 <stati>
    iunlock(f->ip);
  100fed:	8b 43 10             	mov    0x10(%ebx),%eax
  100ff0:	89 04 24             	mov    %eax,(%esp)
  100ff3:	e8 28 0d 00 00       	call   101d20 <iunlock>
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
  10100a:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  101011:	e8 6a 35 00 00       	call   104580 <acquire>
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
  101029:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  101030:	e8 0b 35 00 00       	call   104540 <release>
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
  10103d:	c7 04 24 a7 67 10 00 	movl   $0x1067a7,(%esp)
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
  101057:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  10105e:	e8 1d 35 00 00       	call   104580 <acquire>
  101063:	ba 40 9f 10 00       	mov    $0x109f40,%edx
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
  10108b:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  101092:	c7 04 d5 40 9f 10 00 	movl   $0x1,0x109f40(,%edx,8)
  101099:	01 00 00 00 
      file[i].ref = 1;
  10109d:	c7 04 d5 44 9f 10 00 	movl   $0x1,0x109f44(,%edx,8)
  1010a4:	01 00 00 00 
      release(&file_table_lock);
  1010a8:	e8 93 34 00 00       	call   104540 <release>
      return file + i;
  1010ad:	8d 83 40 9f 10 00    	lea    0x109f40(%ebx),%eax
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
  1010c0:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  1010c7:	e8 74 34 00 00       	call   104540 <release>
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
  1010f2:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  1010f9:	e8 82 34 00 00       	call   104580 <acquire>
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
  10111d:	c7 45 08 a0 a8 10 00 	movl   $0x10a8a0,0x8(%ebp)
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
  101130:	e9 0b 34 00 00       	jmp    104540 <release>
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
  101157:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  10115e:	e8 dd 33 00 00       	call   104540 <release>
  
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
  10117c:	e9 5f 09 00 00       	jmp    101ae0 <iput>
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
  101196:	e8 65 1f 00 00       	call   103100 <pipeclose>
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
  1011a8:	c7 04 24 af 67 10 00 	movl   $0x1067af,(%esp)
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
  1011c6:	c7 44 24 04 b9 67 10 	movl   $0x1067b9,0x4(%esp)
  1011cd:	00 
  1011ce:	c7 04 24 a0 a8 10 00 	movl   $0x10a8a0,(%esp)
  1011d5:	e8 e6 31 00 00       	call   1043c0 <initlock>
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
  10121a:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101221:	e8 5a 33 00 00       	call   104580 <acquire>
  ip->ref++;
  101226:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10122a:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101231:	e8 0a 33 00 00       	call   104540 <release>
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
  10124f:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101256:	e8 25 33 00 00       	call   104580 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10125b:	b8 74 a9 10 00       	mov    $0x10a974,%eax
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
  10126f:	3d 14 b9 10 00       	cmp    $0x10b914,%eax
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
  10128c:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101296:	e8 a5 32 00 00       	call   104540 <release>
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
  1012b1:	3d 14 b9 10 00       	cmp    $0x10b914,%eax
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
  1012cf:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  1012d6:	e8 65 32 00 00       	call   104540 <release>

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
  1012e5:	c7 04 24 c4 67 10 00 	movl   $0x1067c4,(%esp)
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
  101332:	e8 49 33 00 00       	call   104680 <memmove>
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
    }
    brelse(bp);
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
    }
    brelse(bp);
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
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  10140b:	c7 04 24 d4 67 10 00 	movl   $0x1067d4,(%esp)
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
  101426:	83 fa 0b             	cmp    $0xb,%edx

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
  101436:	77 30                	ja     101468 <bmap+0x48>
    if((addr = ip->addrs[bn]) == 0){
  101438:	8d 7a 04             	lea    0x4(%edx),%edi
  10143b:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
  10143f:	85 c0                	test   %eax,%eax
  101441:	75 15                	jne    101458 <bmap+0x38>
      if(!alloc)
  101443:	85 c9                	test   %ecx,%ecx
  101445:	74 38                	je     10147f <bmap+0x5f>
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101447:	8b 03                	mov    (%ebx),%eax
  101449:	e8 02 ff ff ff       	call   101350 <balloc>
  10144e:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  101452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  101458:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10145b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10145e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101461:	89 ec                	mov    %ebp,%esp
  101463:	5d                   	pop    %ebp
  101464:	c3                   	ret    
  101465:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101468:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
  10146b:	83 ff 7f             	cmp    $0x7f,%edi
  10146e:	0f 87 7f 00 00 00    	ja     1014f3 <bmap+0xd3>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  101474:	8b 40 4c             	mov    0x4c(%eax),%eax
  101477:	85 c0                	test   %eax,%eax
  101479:	75 17                	jne    101492 <bmap+0x72>
      if(!alloc)
  10147b:	85 c9                	test   %ecx,%ecx
  10147d:	75 09                	jne    101488 <bmap+0x68>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  10147f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101484:	eb d2                	jmp    101458 <bmap+0x38>
  101486:	66 90                	xchg   %ax,%ax
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101488:	8b 03                	mov    (%ebx),%eax
  10148a:	e8 c1 fe ff ff       	call   101350 <balloc>
  10148f:	89 43 4c             	mov    %eax,0x4c(%ebx)
    }
    bp = bread(ip->dev, addr);
  101492:	89 44 24 04          	mov    %eax,0x4(%esp)
  101496:	8b 03                	mov    (%ebx),%eax
  101498:	89 04 24             	mov    %eax,(%esp)
  10149b:	e8 90 ec ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014a0:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  1014a4:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014a6:	8b 07                	mov    (%edi),%eax
  1014a8:	85 c0                	test   %eax,%eax
  1014aa:	75 34                	jne    1014e0 <bmap+0xc0>
      if(!alloc){
  1014ac:	85 f6                	test   %esi,%esi
  1014ae:	75 10                	jne    1014c0 <bmap+0xa0>
        brelse(bp);
  1014b0:	89 14 24             	mov    %edx,(%esp)
  1014b3:	e8 48 eb ff ff       	call   100000 <brelse>
  1014b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        return -1;
  1014bd:	eb 99                	jmp    101458 <bmap+0x38>
  1014bf:	90                   	nop
      }
      a[bn] = addr = balloc(ip->dev);
  1014c0:	8b 03                	mov    (%ebx),%eax
  1014c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1014c5:	e8 86 fe ff ff       	call   101350 <balloc>
      bwrite(bp);
  1014ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  1014cd:	89 07                	mov    %eax,(%edi)
      bwrite(bp);
  1014cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1014d2:	89 14 24             	mov    %edx,(%esp)
  1014d5:	e8 26 ec ff ff       	call   100100 <bwrite>
  1014da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1014dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
  1014e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1014e3:	89 14 24             	mov    %edx,(%esp)
  1014e6:	e8 15 eb ff ff       	call   100000 <brelse>
    return addr;
  1014eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014ee:	e9 65 ff ff ff       	jmp    101458 <bmap+0x38>
  }

  panic("bmap: out of range");
  1014f3:	c7 04 24 ea 67 10 00 	movl   $0x1067ea,(%esp)
  1014fa:	e8 61 f4 ff ff       	call   100960 <panic>
  1014ff:	90                   	nop

00101500 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101500:	55                   	push   %ebp
  101501:	89 e5                	mov    %esp,%ebp
  101503:	83 ec 38             	sub    $0x38,%esp
  101506:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101509:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10150c:	8b 45 14             	mov    0x14(%ebp),%eax
  10150f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101512:	8b 75 10             	mov    0x10(%ebp),%esi
  101515:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101518:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10151b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101523:	74 1b                	je     101540 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101525:	8b 43 18             	mov    0x18(%ebx),%eax
  101528:	39 f0                	cmp    %esi,%eax
  10152a:	73 44                	jae    101570 <readi+0x70>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10152c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101531:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101534:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101537:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10153a:	89 ec                	mov    %ebp,%esp
  10153c:	5d                   	pop    %ebp
  10153d:	c3                   	ret    
  10153e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101540:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101544:	66 83 f8 09          	cmp    $0x9,%ax
  101548:	77 e2                	ja     10152c <readi+0x2c>
  10154a:	98                   	cwtl   
  10154b:	8b 04 c5 e0 a8 10 00 	mov    0x10a8e0(,%eax,8),%eax
  101552:	85 c0                	test   %eax,%eax
  101554:	74 d6                	je     10152c <readi+0x2c>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101556:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101559:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10155c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10155f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101562:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101565:	89 ec                	mov    %ebp,%esp
  101567:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101568:	ff e0                	jmp    *%eax
  10156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  101570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101573:	01 f2                	add    %esi,%edx
  101575:	72 b5                	jb     10152c <readi+0x2c>
    return -1;
  if(off + n > ip->size)
  101577:	39 d0                	cmp    %edx,%eax
  101579:	73 05                	jae    101580 <readi+0x80>
    n = ip->size - off;
  10157b:	29 f0                	sub    %esi,%eax
  10157d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101580:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101583:	85 d2                	test   %edx,%edx
  101585:	74 7e                	je     101605 <readi+0x105>
  101587:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
  10158e:	89 7d dc             	mov    %edi,-0x24(%ebp)
  101591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101598:	89 f2                	mov    %esi,%edx
  10159a:	31 c9                	xor    %ecx,%ecx
  10159c:	c1 ea 09             	shr    $0x9,%edx
  10159f:	89 d8                	mov    %ebx,%eax
  1015a1:	e8 7a fe ff ff       	call   101420 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015a6:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015af:	8b 03                	mov    (%ebx),%eax
  1015b1:	89 04 24             	mov    %eax,(%esp)
  1015b4:	e8 77 eb ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015b9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1015bc:	2b 4d e0             	sub    -0x20(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1015c1:	89 f0                	mov    %esi,%eax
  1015c3:	25 ff 01 00 00       	and    $0x1ff,%eax
  1015c8:	29 c7                	sub    %eax,%edi
  1015ca:	39 cf                	cmp    %ecx,%edi
  1015cc:	76 02                	jbe    1015d0 <readi+0xd0>
  1015ce:	89 cf                	mov    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1015d0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015d4:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1015d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1015da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1015e1:	89 04 24             	mov    %eax,(%esp)
  1015e4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1015e7:	e8 94 30 00 00       	call   104680 <memmove>
    brelse(bp);
  1015ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1015ef:	89 14 24             	mov    %edx,(%esp)
  1015f2:	e8 09 ea ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015f7:	01 7d e0             	add    %edi,-0x20(%ebp)
  1015fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1015fd:	01 7d dc             	add    %edi,-0x24(%ebp)
  101600:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101603:	77 93                	ja     101598 <readi+0x98>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101608:	e9 24 ff ff ff       	jmp    101531 <readi+0x31>
  10160d:	8d 76 00             	lea    0x0(%esi),%esi

00101610 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
  101613:	56                   	push   %esi
  101614:	53                   	push   %ebx
  101615:	83 ec 10             	sub    $0x10,%esp
  101618:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10161b:	8b 43 04             	mov    0x4(%ebx),%eax
  10161e:	c1 e8 03             	shr    $0x3,%eax
  101621:	83 c0 02             	add    $0x2,%eax
  101624:	89 44 24 04          	mov    %eax,0x4(%esp)
  101628:	8b 03                	mov    (%ebx),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 fe ea ff ff       	call   100130 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  101632:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  101636:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101638:	8b 43 04             	mov    0x4(%ebx),%eax
  10163b:	83 e0 07             	and    $0x7,%eax
  10163e:	c1 e0 06             	shl    $0x6,%eax
  101641:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  101645:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  101648:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  10164c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  101650:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  101654:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  101658:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  10165c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  101660:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101663:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101666:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101669:	83 c0 0c             	add    $0xc,%eax
  10166c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101670:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101677:	00 
  101678:	89 04 24             	mov    %eax,(%esp)
  10167b:	e8 00 30 00 00       	call   104680 <memmove>
  bwrite(bp);
  101680:	89 34 24             	mov    %esi,(%esp)
  101683:	e8 78 ea ff ff       	call   100100 <bwrite>
  brelse(bp);
  101688:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10168b:	83 c4 10             	add    $0x10,%esp
  10168e:	5b                   	pop    %ebx
  10168f:	5e                   	pop    %esi
  101690:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  101691:	e9 6a e9 ff ff       	jmp    100000 <brelse>
  101696:	8d 76 00             	lea    0x0(%esi),%esi
  101699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001016a0 <writei>:
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1016a0:	55                   	push   %ebp
  1016a1:	89 e5                	mov    %esp,%ebp
  1016a3:	57                   	push   %edi
  1016a4:	56                   	push   %esi
  1016a5:	53                   	push   %ebx
  1016a6:	83 ec 2c             	sub    $0x2c,%esp
  1016a9:	8b 75 08             	mov    0x8(%ebp),%esi
  1016ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1016af:	8b 55 14             	mov    0x14(%ebp),%edx
  1016b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1016b5:	66 83 7e 10 03       	cmpw   $0x3,0x10(%esi)
 }

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1016ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1016bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1016c0:	0f 84 c2 00 00 00    	je     101788 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  1016c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1016c9:	01 d8                	add    %ebx,%eax
  1016cb:	0f 82 c1 00 00 00    	jb     101792 <writei+0xf2>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1016d1:	3d 00 18 01 00       	cmp    $0x11800,%eax
  1016d6:	76 0a                	jbe    1016e2 <writei+0x42>
    n = MAXFILE*BSIZE - off;
  1016d8:	c7 45 dc 00 18 01 00 	movl   $0x11800,-0x24(%ebp)
  1016df:	29 5d dc             	sub    %ebx,-0x24(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1016e2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1016e5:	85 c9                	test   %ecx,%ecx
  1016e7:	0f 84 8b 00 00 00    	je     101778 <writei+0xd8>
  1016ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1016f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1016f8:	89 da                	mov    %ebx,%edx
  1016fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  1016ff:	c1 ea 09             	shr    $0x9,%edx
  101702:	89 f0                	mov    %esi,%eax
  101704:	e8 17 fd ff ff       	call   101420 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101709:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  10170e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101712:	8b 06                	mov    (%esi),%eax
  101714:	89 04 24             	mov    %eax,(%esp)
  101717:	e8 14 ea ff ff       	call   100130 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  10171c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10171f:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101722:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  101724:	89 d8                	mov    %ebx,%eax
  101726:	25 ff 01 00 00       	and    $0x1ff,%eax
  10172b:	29 c7                	sub    %eax,%edi
  10172d:	39 cf                	cmp    %ecx,%edi
  10172f:	76 02                	jbe    101733 <writei+0x93>
  101731:	89 cf                	mov    %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
  101733:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101737:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10173a:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  10173e:	89 04 24             	mov    %eax,(%esp)
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101741:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101743:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  101747:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10174a:	e8 31 2f 00 00       	call   104680 <memmove>
    bwrite(bp);
  10174f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101752:	89 14 24             	mov    %edx,(%esp)
  101755:	e8 a6 e9 ff ff       	call   100100 <bwrite>
    brelse(bp);
  10175a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10175d:	89 14 24             	mov    %edx,(%esp)
  101760:	e8 9b e8 ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101765:	01 7d e4             	add    %edi,-0x1c(%ebp)
  101768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10176b:	01 7d e0             	add    %edi,-0x20(%ebp)
  10176e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101771:	77 85                	ja     1016f8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101773:	3b 5e 18             	cmp    0x18(%esi),%ebx
  101776:	77 28                	ja     1017a0 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101778:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  10177b:	83 c4 2c             	add    $0x2c,%esp
  10177e:	5b                   	pop    %ebx
  10177f:	5e                   	pop    %esi
  101780:	5f                   	pop    %edi
  101781:	5d                   	pop    %ebp
  101782:	c3                   	ret    
  101783:	90                   	nop
  101784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101788:	0f b7 46 12          	movzwl 0x12(%esi),%eax
  10178c:	66 83 f8 09          	cmp    $0x9,%ax
  101790:	76 1b                	jbe    1017ad <writei+0x10d>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101792:	83 c4 2c             	add    $0x2c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10179a:	5b                   	pop    %ebx
  10179b:	5e                   	pop    %esi
  10179c:	5f                   	pop    %edi
  10179d:	5d                   	pop    %ebp
  10179e:	c3                   	ret    
  10179f:	90                   	nop
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  1017a0:	89 5e 18             	mov    %ebx,0x18(%esi)
    iupdate(ip);
  1017a3:	89 34 24             	mov    %esi,(%esp)
  1017a6:	e8 65 fe ff ff       	call   101610 <iupdate>
  1017ab:	eb cb                	jmp    101778 <writei+0xd8>
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1017ad:	98                   	cwtl   
  1017ae:	8b 04 c5 e4 a8 10 00 	mov    0x10a8e4(,%eax,8),%eax
  1017b5:	85 c0                	test   %eax,%eax
  1017b7:	74 d9                	je     101792 <writei+0xf2>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1017b9:	89 55 10             	mov    %edx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1017bc:	83 c4 2c             	add    $0x2c,%esp
  1017bf:	5b                   	pop    %ebx
  1017c0:	5e                   	pop    %esi
  1017c1:	5f                   	pop    %edi
  1017c2:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1017c3:	ff e0                	jmp    *%eax
  1017c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1017c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001017d0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  1017d0:	55                   	push   %ebp
  1017d1:	89 e5                	mov    %esp,%ebp
  1017d3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  1017d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1017d9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1017e0:	00 
  1017e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e8:	89 04 24             	mov    %eax,(%esp)
  1017eb:	e8 f0 2e 00 00       	call   1046e0 <strncmp>
}
  1017f0:	c9                   	leave  
  1017f1:	c3                   	ret    
  1017f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101800 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101800:	55                   	push   %ebp
  101801:	89 e5                	mov    %esp,%ebp
  101803:	57                   	push   %edi
  101804:	56                   	push   %esi
  101805:	53                   	push   %ebx
  101806:	83 ec 3c             	sub    $0x3c,%esp
  101809:	8b 45 08             	mov    0x8(%ebp),%eax
  10180c:	8b 55 10             	mov    0x10(%ebp),%edx
  10180f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101812:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101817:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10181a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  10181d:	0f 85 d0 00 00 00    	jne    1018f3 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101823:	8b 70 18             	mov    0x18(%eax),%esi
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10182d:	85 f6                	test   %esi,%esi
  10182f:	0f 84 b4 00 00 00    	je     1018e9 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101838:	31 c9                	xor    %ecx,%ecx
  10183a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10183d:	c1 ea 09             	shr    $0x9,%edx
  101840:	e8 db fb ff ff       	call   101420 <bmap>
  101845:	89 44 24 04          	mov    %eax,0x4(%esp)
  101849:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10184c:	8b 01                	mov    (%ecx),%eax
  10184e:	89 04 24             	mov    %eax,(%esp)
  101851:	e8 da e8 ff ff       	call   100130 <bread>
  101856:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101859:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  10185c:	83 c0 18             	add    $0x18,%eax
  10185f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101862:	89 c6                	mov    %eax,%esi

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101864:	81 c7 18 02 00 00    	add    $0x218,%edi
  10186a:	eb 0b                	jmp    101877 <dirlookup+0x77>
  10186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  101870:	83 c6 10             	add    $0x10,%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101873:	39 fe                	cmp    %edi,%esi
  101875:	74 51                	je     1018c8 <dirlookup+0xc8>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  101877:	66 83 3e 00          	cmpw   $0x0,(%esi)
  10187b:	74 f3                	je     101870 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  10187d:	8d 46 02             	lea    0x2(%esi),%eax
  101880:	89 44 24 04          	mov    %eax,0x4(%esp)
  101884:	89 1c 24             	mov    %ebx,(%esp)
  101887:	e8 44 ff ff ff       	call   1017d0 <namecmp>
  10188c:	85 c0                	test   %eax,%eax
  10188e:	75 e0                	jne    101870 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101890:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  101893:	85 db                	test   %ebx,%ebx
  101895:	74 0e                	je     1018a5 <dirlookup+0xa5>
          *poff = off + (uchar*)de - bp->data;
  101897:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10189a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10189d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  1018a0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  1018a3:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
        brelse(bp);
  1018a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  1018a8:	0f b7 1e             	movzwl (%esi),%ebx
        brelse(bp);
  1018ab:	89 04 24             	mov    %eax,(%esp)
  1018ae:	e8 4d e7 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  1018b3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1018b6:	89 da                	mov    %ebx,%edx
  1018b8:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  1018ba:	83 c4 3c             	add    $0x3c,%esp
  1018bd:	5b                   	pop    %ebx
  1018be:	5e                   	pop    %esi
  1018bf:	5f                   	pop    %edi
  1018c0:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  1018c1:	e9 7a f9 ff ff       	jmp    101240 <iget>
  1018c6:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  1018c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1018cb:	89 04 24             	mov    %eax,(%esp)
  1018ce:	e8 2d e7 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  1018d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1018d6:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  1018dd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1018e0:	39 4a 18             	cmp    %ecx,0x18(%edx)
  1018e3:	0f 87 4c ff ff ff    	ja     101835 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  1018e9:	83 c4 3c             	add    $0x3c,%esp
  1018ec:	31 c0                	xor    %eax,%eax
  1018ee:	5b                   	pop    %ebx
  1018ef:	5e                   	pop    %esi
  1018f0:	5f                   	pop    %edi
  1018f1:	5d                   	pop    %ebp
  1018f2:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  1018f3:	c7 04 24 fd 67 10 00 	movl   $0x1067fd,(%esp)
  1018fa:	e8 61 f0 ff ff       	call   100960 <panic>
  1018ff:	90                   	nop

00101900 <checki>:
}

// Check data from inode to see if it is in the buffer cache.
int
checki(struct inode *ip, int off)
{
  101900:	55                   	push   %ebp
  101901:	89 e5                	mov    %esp,%ebp
  101903:	53                   	push   %ebx
  101904:	83 ec 04             	sub    $0x4,%esp
  101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10190a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if(off > ip->size)
  10190d:	3b 43 18             	cmp    0x18(%ebx),%eax
  101910:	76 0e                	jbe    101920 <checki+0x20>
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));

 }
  101912:	83 c4 04             	add    $0x4,%esp
  101915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10191a:	5b                   	pop    %ebx
  10191b:	5d                   	pop    %ebp
  10191c:	c3                   	ret    
  10191d:	8d 76 00             	lea    0x0(%esi),%esi
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101920:	89 c2                	mov    %eax,%edx
  101922:	31 c9                	xor    %ecx,%ecx
  101924:	c1 fa 1f             	sar    $0x1f,%edx
  101927:	c1 ea 17             	shr    $0x17,%edx
  10192a:	01 c2                	add    %eax,%edx
  10192c:	89 d8                	mov    %ebx,%eax
  10192e:	c1 fa 09             	sar    $0x9,%edx
  101931:	e8 ea fa ff ff       	call   101420 <bmap>
  101936:	89 45 0c             	mov    %eax,0xc(%ebp)
  101939:	8b 03                	mov    (%ebx),%eax
  10193b:	89 45 08             	mov    %eax,0x8(%ebp)

 }
  10193e:	83 c4 04             	add    $0x4,%esp
  101941:	5b                   	pop    %ebx
  101942:	5d                   	pop    %ebp
checki(struct inode *ip, int off)
{
	if(off > ip->size)
		return -1;
	//cprintf("checki: calling bcheck\n");
    return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101943:	e9 38 e7 ff ff       	jmp    100080 <bcheck>
  101948:	90                   	nop
  101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101950 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101950:	55                   	push   %ebp
  101951:	89 e5                	mov    %esp,%ebp
  101953:	57                   	push   %edi
  101954:	56                   	push   %esi
  101955:	53                   	push   %ebx
  101956:	83 ec 3c             	sub    $0x3c,%esp
  101959:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10195d:	8d 55 dc             	lea    -0x24(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101960:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101964:	8b 45 08             	mov    0x8(%ebp),%eax
  101967:	e8 94 f9 ff ff       	call   101300 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10196c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101970:	0f 86 96 00 00 00    	jbe    101a0c <ialloc+0xbc>
  101976:	be 01 00 00 00       	mov    $0x1,%esi
  10197b:	bb 01 00 00 00       	mov    $0x1,%ebx
  101980:	eb 18                	jmp    10199a <ialloc+0x4a>
  101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101988:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  10198b:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10198e:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101990:	e8 6b e6 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101995:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  101998:	73 72                	jae    101a0c <ialloc+0xbc>
    bp = bread(dev, IBLOCK(inum));
  10199a:	89 f0                	mov    %esi,%eax
  10199c:	c1 e8 03             	shr    $0x3,%eax
  10199f:	83 c0 02             	add    $0x2,%eax
  1019a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a9:	89 04 24             	mov    %eax,(%esp)
  1019ac:	e8 7f e7 ff ff       	call   100130 <bread>
  1019b1:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  1019b3:	89 f0                	mov    %esi,%eax
  1019b5:	83 e0 07             	and    $0x7,%eax
  1019b8:	c1 e0 06             	shl    $0x6,%eax
  1019bb:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  1019bf:	66 83 3a 00          	cmpw   $0x0,(%edx)
  1019c3:	75 c3                	jne    101988 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  1019c5:	89 14 24             	mov    %edx,(%esp)
  1019c8:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1019cb:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  1019d2:	00 
  1019d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1019da:	00 
  1019db:	e8 10 2c 00 00       	call   1045f0 <memset>
      dip->type = type;
  1019e0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1019e3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  1019e7:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  1019ea:	89 3c 24             	mov    %edi,(%esp)
  1019ed:	e8 0e e7 ff ff       	call   100100 <bwrite>
      brelse(bp);
  1019f2:	89 3c 24             	mov    %edi,(%esp)
  1019f5:	e8 06 e6 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  1019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fd:	89 f2                	mov    %esi,%edx
  1019ff:	e8 3c f8 ff ff       	call   101240 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101a04:	83 c4 3c             	add    $0x3c,%esp
  101a07:	5b                   	pop    %ebx
  101a08:	5e                   	pop    %esi
  101a09:	5f                   	pop    %edi
  101a0a:	5d                   	pop    %ebp
  101a0b:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101a0c:	c7 04 24 0f 68 10 00 	movl   $0x10680f,(%esp)
  101a13:	e8 48 ef ff ff       	call   100960 <panic>
  101a18:	90                   	nop
  101a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101a20 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101a20:	55                   	push   %ebp
  101a21:	89 e5                	mov    %esp,%ebp
  101a23:	57                   	push   %edi
  101a24:	56                   	push   %esi
  101a25:	89 c6                	mov    %eax,%esi
  101a27:	53                   	push   %ebx
  101a28:	89 d3                	mov    %edx,%ebx
  101a2a:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a31:	89 04 24             	mov    %eax,(%esp)
  101a34:	e8 f7 e6 ff ff       	call   100130 <bread>
  memset(bp->data, 0, BSIZE);
  101a39:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101a40:	00 
  101a41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101a48:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a49:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  101a4b:	8d 40 18             	lea    0x18(%eax),%eax
  101a4e:	89 04 24             	mov    %eax,(%esp)
  101a51:	e8 9a 2b 00 00       	call   1045f0 <memset>
  bwrite(bp);
  101a56:	89 3c 24             	mov    %edi,(%esp)
  101a59:	e8 a2 e6 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101a5e:	89 3c 24             	mov    %edi,(%esp)
  101a61:	e8 9a e5 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101a66:	89 f0                	mov    %esi,%eax
  101a68:	8d 55 dc             	lea    -0x24(%ebp),%edx
  101a6b:	e8 90 f8 ff ff       	call   101300 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101a73:	89 da                	mov    %ebx,%edx
  101a75:	c1 ea 0c             	shr    $0xc,%edx
  101a78:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101a7b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a80:	c1 e8 03             	shr    $0x3,%eax
  101a83:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8b:	e8 a0 e6 ff ff       	call   100130 <bread>
  bi = b % BPB;
  101a90:	89 da                	mov    %ebx,%edx
  m = 1 << (bi % 8);
  101a92:	89 d9                	mov    %ebx,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101a94:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  101a9a:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  101a9d:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101aa0:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101aa2:	0f b6 4c 10 18       	movzbl 0x18(%eax,%edx,1),%ecx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101aa7:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101aa9:	0f b6 c1             	movzbl %cl,%eax
  101aac:	85 f0                	test   %esi,%eax
  101aae:	74 22                	je     101ad2 <bfree+0xb2>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101ab0:	89 f0                	mov    %esi,%eax
  101ab2:	f7 d0                	not    %eax
  101ab4:	21 c8                	and    %ecx,%eax
  101ab6:	88 44 17 18          	mov    %al,0x18(%edi,%edx,1)
  bwrite(bp);
  101aba:	89 3c 24             	mov    %edi,(%esp)
  101abd:	e8 3e e6 ff ff       	call   100100 <bwrite>
  brelse(bp);
  101ac2:	89 3c 24             	mov    %edi,(%esp)
  101ac5:	e8 36 e5 ff ff       	call   100000 <brelse>
}
  101aca:	83 c4 2c             	add    $0x2c,%esp
  101acd:	5b                   	pop    %ebx
  101ace:	5e                   	pop    %esi
  101acf:	5f                   	pop    %edi
  101ad0:	5d                   	pop    %ebp
  101ad1:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101ad2:	c7 04 24 21 68 10 00 	movl   $0x106821,(%esp)
  101ad9:	e8 82 ee ff ff       	call   100960 <panic>
  101ade:	66 90                	xchg   %ax,%ax

00101ae0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101ae0:	55                   	push   %ebp
  101ae1:	89 e5                	mov    %esp,%ebp
  101ae3:	57                   	push   %edi
  101ae4:	56                   	push   %esi
  101ae5:	53                   	push   %ebx
  101ae6:	83 ec 2c             	sub    $0x2c,%esp
  101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  101aec:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101af3:	e8 88 2a 00 00       	call   104580 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101af8:	8b 46 08             	mov    0x8(%esi),%eax
  101afb:	83 f8 01             	cmp    $0x1,%eax
  101afe:	0f 85 9e 00 00 00    	jne    101ba2 <iput+0xc2>
  101b04:	8b 56 0c             	mov    0xc(%esi),%edx
  101b07:	f6 c2 02             	test   $0x2,%dl
  101b0a:	0f 84 92 00 00 00    	je     101ba2 <iput+0xc2>
  101b10:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101b15:	0f 85 87 00 00 00    	jne    101ba2 <iput+0xc2>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101b1b:	f6 c2 01             	test   $0x1,%dl
  101b1e:	66 90                	xchg   %ax,%ax
  101b20:	0f 85 ef 00 00 00    	jne    101c15 <iput+0x135>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b26:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  101b29:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b2b:	89 56 0c             	mov    %edx,0xc(%esi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  101b2e:	8d 7e 30             	lea    0x30(%esi),%edi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  101b31:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101b38:	e8 03 2a 00 00       	call   104540 <release>
  101b3d:	eb 08                	jmp    101b47 <iput+0x67>
  101b3f:	90                   	nop
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101b40:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101b43:	39 fb                	cmp    %edi,%ebx
  101b45:	74 1c                	je     101b63 <iput+0x83>
    if(ip->addrs[i]){
  101b47:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101b4a:	85 d2                	test   %edx,%edx
  101b4c:	74 f2                	je     101b40 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
  101b4e:	8b 06                	mov    (%esi),%eax
  101b50:	e8 cb fe ff ff       	call   101a20 <bfree>
      ip->addrs[i] = 0;
  101b55:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101b5c:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101b5f:	39 fb                	cmp    %edi,%ebx
  101b61:	75 e4                	jne    101b47 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101b63:	8b 46 4c             	mov    0x4c(%esi),%eax
  101b66:	85 c0                	test   %eax,%eax
  101b68:	75 56                	jne    101bc0 <iput+0xe0>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101b6a:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101b71:	89 34 24             	mov    %esi,(%esp)
  101b74:	e8 97 fa ff ff       	call   101610 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101b79:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101b7f:	89 34 24             	mov    %esi,(%esp)
  101b82:	e8 89 fa ff ff       	call   101610 <iupdate>
    acquire(&icache.lock);
  101b87:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101b8e:	e8 ed 29 00 00       	call   104580 <acquire>
    ip->flags &= ~I_BUSY;
  101b93:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101b97:	89 34 24             	mov    %esi,(%esp)
  101b9a:	e8 a1 18 00 00       	call   103440 <wakeup>
  101b9f:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
  101ba2:	83 e8 01             	sub    $0x1,%eax
  101ba5:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101ba8:	c7 45 08 40 a9 10 00 	movl   $0x10a940,0x8(%ebp)
}
  101baf:	83 c4 2c             	add    $0x2c,%esp
  101bb2:	5b                   	pop    %ebx
  101bb3:	5e                   	pop    %esi
  101bb4:	5f                   	pop    %edi
  101bb5:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101bb6:	e9 85 29 00 00       	jmp    104540 <release>
  101bbb:	90                   	nop
  101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc4:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101bc6:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bc8:	89 04 24             	mov    %eax,(%esp)
  101bcb:	e8 60 e5 ff ff       	call   100130 <bread>
    a = (uint*)bp->data;
  101bd0:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101bd5:	83 c7 18             	add    $0x18,%edi
  101bd8:	31 c0                	xor    %eax,%eax
  101bda:	eb 11                	jmp    101bed <iput+0x10d>
  101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
  101be0:	83 c3 01             	add    $0x1,%ebx
  101be3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101be9:	89 d8                	mov    %ebx,%eax
  101beb:	74 10                	je     101bfd <iput+0x11d>
      if(a[j])
  101bed:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101bf0:	85 d2                	test   %edx,%edx
  101bf2:	74 ec                	je     101be0 <iput+0x100>
        bfree(ip->dev, a[j]);
  101bf4:	8b 06                	mov    (%esi),%eax
  101bf6:	e8 25 fe ff ff       	call   101a20 <bfree>
  101bfb:	eb e3                	jmp    101be0 <iput+0x100>
    }
    brelse(bp);
  101bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101c00:	89 04 24             	mov    %eax,(%esp)
  101c03:	e8 f8 e3 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  101c08:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101c0f:	90                   	nop
  101c10:	e9 55 ff ff ff       	jmp    101b6a <iput+0x8a>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101c15:	c7 04 24 34 68 10 00 	movl   $0x106834,(%esp)
  101c1c:	e8 3f ed ff ff       	call   100960 <panic>
  101c21:	eb 0d                	jmp    101c30 <dirlink>
  101c23:	90                   	nop
  101c24:	90                   	nop
  101c25:	90                   	nop
  101c26:	90                   	nop
  101c27:	90                   	nop
  101c28:	90                   	nop
  101c29:	90                   	nop
  101c2a:	90                   	nop
  101c2b:	90                   	nop
  101c2c:	90                   	nop
  101c2d:	90                   	nop
  101c2e:	90                   	nop
  101c2f:	90                   	nop

00101c30 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101c30:	55                   	push   %ebp
  101c31:	89 e5                	mov    %esp,%ebp
  101c33:	57                   	push   %edi
  101c34:	56                   	push   %esi
  101c35:	53                   	push   %ebx
  101c36:	83 ec 2c             	sub    $0x2c,%esp
  101c39:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101c3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101c46:	00 
  101c47:	89 34 24             	mov    %esi,(%esp)
  101c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4e:	e8 ad fb ff ff       	call   101800 <dirlookup>
  101c53:	85 c0                	test   %eax,%eax
  101c55:	0f 85 89 00 00 00    	jne    101ce4 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c5b:	8b 7e 18             	mov    0x18(%esi),%edi
  101c5e:	85 ff                	test   %edi,%edi
  101c60:	0f 84 8d 00 00 00    	je     101cf3 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101c66:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101c69:	31 db                	xor    %ebx,%ebx
  101c6b:	eb 0b                	jmp    101c78 <dirlink+0x48>
  101c6d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c70:	83 c3 10             	add    $0x10,%ebx
  101c73:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101c76:	76 24                	jbe    101c9c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101c78:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101c7f:	00 
  101c80:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101c84:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101c88:	89 34 24             	mov    %esi,(%esp)
  101c8b:	e8 70 f8 ff ff       	call   101500 <readi>
  101c90:	83 f8 10             	cmp    $0x10,%eax
  101c93:	75 65                	jne    101cfa <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101c95:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101c9a:	75 d4                	jne    101c70 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101c9f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101ca6:	00 
  101ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cab:	8d 45 da             	lea    -0x26(%ebp),%eax
  101cae:	89 04 24             	mov    %eax,(%esp)
  101cb1:	e8 8a 2a 00 00       	call   104740 <strncpy>
  de.inum = ino;
  101cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101cb9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101cc0:	00 
  101cc1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101cc5:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101cc9:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101ccd:	89 34 24             	mov    %esi,(%esp)
  101cd0:	e8 cb f9 ff ff       	call   1016a0 <writei>
  101cd5:	83 f8 10             	cmp    $0x10,%eax
  101cd8:	75 2c                	jne    101d06 <dirlink+0xd6>
    panic("dirlink");
  101cda:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101cdc:	83 c4 2c             	add    $0x2c,%esp
  101cdf:	5b                   	pop    %ebx
  101ce0:	5e                   	pop    %esi
  101ce1:	5f                   	pop    %edi
  101ce2:	5d                   	pop    %ebp
  101ce3:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ce4:	89 04 24             	mov    %eax,(%esp)
  101ce7:	e8 f4 fd ff ff       	call   101ae0 <iput>
  101cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101cf1:	eb e9                	jmp    101cdc <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101cf3:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101cf6:	31 db                	xor    %ebx,%ebx
  101cf8:	eb a2                	jmp    101c9c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101cfa:	c7 04 24 3e 68 10 00 	movl   $0x10683e,(%esp)
  101d01:	e8 5a ec ff ff       	call   100960 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101d06:	c7 04 24 4b 68 10 00 	movl   $0x10684b,(%esp)
  101d0d:	e8 4e ec ff ff       	call   100960 <panic>
  101d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101d20 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101d20:	55                   	push   %ebp
  101d21:	89 e5                	mov    %esp,%ebp
  101d23:	53                   	push   %ebx
  101d24:	83 ec 14             	sub    $0x14,%esp
  101d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101d2a:	85 db                	test   %ebx,%ebx
  101d2c:	74 36                	je     101d64 <iunlock+0x44>
  101d2e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101d32:	74 30                	je     101d64 <iunlock+0x44>
  101d34:	8b 43 08             	mov    0x8(%ebx),%eax
  101d37:	85 c0                	test   %eax,%eax
  101d39:	7e 29                	jle    101d64 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101d3b:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101d42:	e8 39 28 00 00       	call   104580 <acquire>
  ip->flags &= ~I_BUSY;
  101d47:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101d4b:	89 1c 24             	mov    %ebx,(%esp)
  101d4e:	e8 ed 16 00 00       	call   103440 <wakeup>
  release(&icache.lock);
  101d53:	c7 45 08 40 a9 10 00 	movl   $0x10a940,0x8(%ebp)
}
  101d5a:	83 c4 14             	add    $0x14,%esp
  101d5d:	5b                   	pop    %ebx
  101d5e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101d5f:	e9 dc 27 00 00       	jmp    104540 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101d64:	c7 04 24 53 68 10 00 	movl   $0x106853,(%esp)
  101d6b:	e8 f0 eb ff ff       	call   100960 <panic>

00101d70 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101d70:	55                   	push   %ebp
  101d71:	89 e5                	mov    %esp,%ebp
  101d73:	53                   	push   %ebx
  101d74:	83 ec 14             	sub    $0x14,%esp
  101d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101d7a:	89 1c 24             	mov    %ebx,(%esp)
  101d7d:	e8 9e ff ff ff       	call   101d20 <iunlock>
  iput(ip);
  101d82:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101d85:	83 c4 14             	add    $0x14,%esp
  101d88:	5b                   	pop    %ebx
  101d89:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101d8a:	e9 51 fd ff ff       	jmp    101ae0 <iput>
  101d8f:	90                   	nop

00101d90 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101d90:	55                   	push   %ebp
  101d91:	89 e5                	mov    %esp,%ebp
  101d93:	56                   	push   %esi
  101d94:	53                   	push   %ebx
  101d95:	83 ec 10             	sub    $0x10,%esp
  101d98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101d9b:	85 db                	test   %ebx,%ebx
  101d9d:	0f 84 e5 00 00 00    	je     101e88 <ilock+0xf8>
  101da3:	8b 53 08             	mov    0x8(%ebx),%edx
  101da6:	85 d2                	test   %edx,%edx
  101da8:	0f 8e da 00 00 00    	jle    101e88 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101dae:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101db5:	e8 c6 27 00 00       	call   104580 <acquire>
  while(ip->flags & I_BUSY)
  101dba:	8b 43 0c             	mov    0xc(%ebx),%eax
  101dbd:	a8 01                	test   $0x1,%al
  101dbf:	74 1e                	je     101ddf <ilock+0x4f>
  101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101dc8:	c7 44 24 04 40 a9 10 	movl   $0x10a940,0x4(%esp)
  101dcf:	00 
  101dd0:	89 1c 24             	mov    %ebx,(%esp)
  101dd3:	e8 18 1a 00 00       	call   1037f0 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101dd8:	8b 43 0c             	mov    0xc(%ebx),%eax
  101ddb:	a8 01                	test   $0x1,%al
  101ddd:	75 e9                	jne    101dc8 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101ddf:	83 c8 01             	or     $0x1,%eax
  101de2:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  101de5:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  101dec:	e8 4f 27 00 00       	call   104540 <release>

  if(!(ip->flags & I_VALID)){
  101df1:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  101df5:	74 09                	je     101e00 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101df7:	83 c4 10             	add    $0x10,%esp
  101dfa:	5b                   	pop    %ebx
  101dfb:	5e                   	pop    %esi
  101dfc:	5d                   	pop    %ebp
  101dfd:	c3                   	ret    
  101dfe:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101e00:	8b 43 04             	mov    0x4(%ebx),%eax
  101e03:	c1 e8 03             	shr    $0x3,%eax
  101e06:	83 c0 02             	add    $0x2,%eax
  101e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e0d:	8b 03                	mov    (%ebx),%eax
  101e0f:	89 04 24             	mov    %eax,(%esp)
  101e12:	e8 19 e3 ff ff       	call   100130 <bread>
  101e17:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101e19:	8b 43 04             	mov    0x4(%ebx),%eax
  101e1c:	83 e0 07             	and    $0x7,%eax
  101e1f:	c1 e0 06             	shl    $0x6,%eax
  101e22:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  101e26:	0f b7 10             	movzwl (%eax),%edx
  101e29:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  101e2d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101e31:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  101e35:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101e39:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  101e3d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101e41:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  101e45:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e48:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101e4b:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e52:	8d 43 1c             	lea    0x1c(%ebx),%eax
  101e55:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101e5c:	00 
  101e5d:	89 04 24             	mov    %eax,(%esp)
  101e60:	e8 1b 28 00 00       	call   104680 <memmove>
    brelse(bp);
  101e65:	89 34 24             	mov    %esi,(%esp)
  101e68:	e8 93 e1 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101e6d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101e71:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101e76:	0f 85 7b ff ff ff    	jne    101df7 <ilock+0x67>
      panic("ilock: no type");
  101e7c:	c7 04 24 61 68 10 00 	movl   $0x106861,(%esp)
  101e83:	e8 d8 ea ff ff       	call   100960 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101e88:	c7 04 24 5b 68 10 00 	movl   $0x10685b,(%esp)
  101e8f:	e8 cc ea ff ff       	call   100960 <panic>
  101e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101ea0 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101ea0:	55                   	push   %ebp
  101ea1:	89 e5                	mov    %esp,%ebp
  101ea3:	57                   	push   %edi
  101ea4:	56                   	push   %esi
  101ea5:	53                   	push   %ebx
  101ea6:	89 c3                	mov    %eax,%ebx
  101ea8:	83 ec 2c             	sub    $0x2c,%esp
  101eab:	89 55 e0             	mov    %edx,-0x20(%ebp)
  101eae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101eb1:	80 38 2f             	cmpb   $0x2f,(%eax)
  101eb4:	0f 84 3b 01 00 00    	je     101ff5 <_namei+0x155>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101eba:	e8 81 16 00 00       	call   103540 <curproc>
  101ebf:	8b 40 60             	mov    0x60(%eax),%eax
  101ec2:	89 04 24             	mov    %eax,(%esp)
  101ec5:	e8 46 f3 ff ff       	call   101210 <idup>
  101eca:	89 c7                	mov    %eax,%edi
  101ecc:	eb 05                	jmp    101ed3 <_namei+0x33>
  101ece:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101ed0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101ed3:	0f b6 03             	movzbl (%ebx),%eax
  101ed6:	3c 2f                	cmp    $0x2f,%al
  101ed8:	74 f6                	je     101ed0 <_namei+0x30>
    path++;
  if(*path == 0)
  101eda:	84 c0                	test   %al,%al
  101edc:	75 1a                	jne    101ef8 <_namei+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  101ede:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101ee1:	85 c9                	test   %ecx,%ecx
  101ee3:	0f 85 34 01 00 00    	jne    10201d <_namei+0x17d>
    iput(ip);
    return 0;
  }
  return ip;
}
  101ee9:	83 c4 2c             	add    $0x2c,%esp
  101eec:	89 f8                	mov    %edi,%eax
  101eee:	5b                   	pop    %ebx
  101eef:	5e                   	pop    %esi
  101ef0:	5f                   	pop    %edi
  101ef1:	5d                   	pop    %ebp
  101ef2:	c3                   	ret    
  101ef3:	90                   	nop
  101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101ef8:	3c 2f                	cmp    $0x2f,%al
  101efa:	0f 84 db 00 00 00    	je     101fdb <_namei+0x13b>
  101f00:	89 de                	mov    %ebx,%esi
    path++;
  101f02:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101f05:	0f b6 06             	movzbl (%esi),%eax
  101f08:	84 c0                	test   %al,%al
  101f0a:	0f 85 90 00 00 00    	jne    101fa0 <_namei+0x100>
  101f10:	89 f2                	mov    %esi,%edx
  101f12:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  101f14:	83 fa 0d             	cmp    $0xd,%edx
  101f17:	0f 8e 99 00 00 00    	jle    101fb6 <_namei+0x116>
  101f1d:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, DIRSIZ);
  101f20:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101f27:	00 
  101f28:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f2f:	89 04 24             	mov    %eax,(%esp)
  101f32:	e8 49 27 00 00       	call   104680 <memmove>
  101f37:	eb 0a                	jmp    101f43 <_namei+0xa3>
  101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101f40:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101f43:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101f46:	74 f8                	je     101f40 <_namei+0xa0>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101f48:	85 f6                	test   %esi,%esi
  101f4a:	74 92                	je     101ede <_namei+0x3e>
    ilock(ip);
  101f4c:	89 3c 24             	mov    %edi,(%esp)
  101f4f:	e8 3c fe ff ff       	call   101d90 <ilock>
    if(ip->type != T_DIR){
  101f54:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  101f59:	0f 85 82 00 00 00    	jne    101fe1 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101f5f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  101f62:	85 db                	test   %ebx,%ebx
  101f64:	74 09                	je     101f6f <_namei+0xcf>
  101f66:	80 3e 00             	cmpb   $0x0,(%esi)
  101f69:	0f 84 9c 00 00 00    	je     10200b <_namei+0x16b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101f6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101f76:	00 
  101f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f7a:	89 3c 24             	mov    %edi,(%esp)
  101f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f81:	e8 7a f8 ff ff       	call   101800 <dirlookup>
  101f86:	85 c0                	test   %eax,%eax
  101f88:	89 c3                	mov    %eax,%ebx
  101f8a:	74 55                	je     101fe1 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101f8c:	89 3c 24             	mov    %edi,(%esp)
  101f8f:	89 df                	mov    %ebx,%edi
  101f91:	89 f3                	mov    %esi,%ebx
  101f93:	e8 d8 fd ff ff       	call   101d70 <iunlockput>
  101f98:	e9 36 ff ff ff       	jmp    101ed3 <_namei+0x33>
  101f9d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101fa0:	3c 2f                	cmp    $0x2f,%al
  101fa2:	0f 85 5a ff ff ff    	jne    101f02 <_namei+0x62>
  101fa8:	89 f2                	mov    %esi,%edx
  101faa:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  101fac:	83 fa 0d             	cmp    $0xd,%edx
  101faf:	90                   	nop
  101fb0:	0f 8f 6a ff ff ff    	jg     101f20 <_namei+0x80>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101fb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101fba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101fc1:	89 04 24             	mov    %eax,(%esp)
  101fc4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  101fc7:	e8 b4 26 00 00       	call   104680 <memmove>
    name[len] = 0;
  101fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101fd2:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101fd6:	e9 68 ff ff ff       	jmp    101f43 <_namei+0xa3>
  }
  while(*path == '/')
  101fdb:	89 de                	mov    %ebx,%esi
  101fdd:	31 d2                	xor    %edx,%edx
  101fdf:	eb d5                	jmp    101fb6 <_namei+0x116>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101fe1:	89 3c 24             	mov    %edi,(%esp)
  101fe4:	31 ff                	xor    %edi,%edi
  101fe6:	e8 85 fd ff ff       	call   101d70 <iunlockput>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101feb:	83 c4 2c             	add    $0x2c,%esp
  101fee:	89 f8                	mov    %edi,%eax
  101ff0:	5b                   	pop    %ebx
  101ff1:	5e                   	pop    %esi
  101ff2:	5f                   	pop    %edi
  101ff3:	5d                   	pop    %ebp
  101ff4:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  101ff5:	ba 01 00 00 00       	mov    $0x1,%edx
  101ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  101fff:	e8 3c f2 ff ff       	call   101240 <iget>
  102004:	89 c7                	mov    %eax,%edi
  102006:	e9 c8 fe ff ff       	jmp    101ed3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  10200b:	89 3c 24             	mov    %edi,(%esp)
  10200e:	e8 0d fd ff ff       	call   101d20 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  102013:	83 c4 2c             	add    $0x2c,%esp
  102016:	89 f8                	mov    %edi,%eax
  102018:	5b                   	pop    %ebx
  102019:	5e                   	pop    %esi
  10201a:	5f                   	pop    %edi
  10201b:	5d                   	pop    %ebp
  10201c:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  10201d:	89 3c 24             	mov    %edi,(%esp)
  102020:	31 ff                	xor    %edi,%edi
  102022:	e8 b9 fa ff ff       	call   101ae0 <iput>
    return 0;
  102027:	e9 bd fe ff ff       	jmp    101ee9 <_namei+0x49>
  10202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102030 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102030:	55                   	push   %ebp
  return _namei(path, 1, name);
  102031:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102036:	89 e5                	mov    %esp,%ebp
  102038:	83 ec 08             	sub    $0x8,%esp
  return _namei(path, 1, name);
  10203b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10203e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102041:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  102042:	e9 59 fe ff ff       	jmp    101ea0 <_namei>
  102047:	89 f6                	mov    %esi,%esi
  102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102050 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102050:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102051:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102053:	89 e5                	mov    %esp,%ebp
  102055:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102058:	8b 45 08             	mov    0x8(%ebp),%eax
  10205b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  10205e:	e8 3d fe ff ff       	call   101ea0 <_namei>
}
  102063:	c9                   	leave  
  102064:	c3                   	ret    
  102065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102070 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102070:	55                   	push   %ebp
  102071:	89 e5                	mov    %esp,%ebp
  102073:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache.lock");
  102076:	c7 44 24 04 70 68 10 	movl   $0x106870,0x4(%esp)
  10207d:	00 
  10207e:	c7 04 24 40 a9 10 00 	movl   $0x10a940,(%esp)
  102085:	e8 36 23 00 00       	call   1043c0 <initlock>
}
  10208a:	c9                   	leave  
  10208b:	c3                   	ret    
  10208c:	90                   	nop
  10208d:	90                   	nop
  10208e:	90                   	nop
  10208f:	90                   	nop

00102090 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  102090:	55                   	push   %ebp
  102091:	89 c1                	mov    %eax,%ecx
  102093:	89 e5                	mov    %esp,%ebp
  102095:	56                   	push   %esi
  102096:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  102099:	85 c0                	test   %eax,%eax
  10209b:	0f 84 89 00 00 00    	je     10212a <ide_start_request+0x9a>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1020a1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1020a6:	66 90                	xchg   %ax,%ax
  1020a8:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  1020a9:	0f b6 c0             	movzbl %al,%eax
  1020ac:	84 c0                	test   %al,%al
  1020ae:	78 f8                	js     1020a8 <ide_start_request+0x18>
  1020b0:	a8 40                	test   $0x40,%al
  1020b2:	74 f4                	je     1020a8 <ide_start_request+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1020b4:	ba f6 03 00 00       	mov    $0x3f6,%edx
  1020b9:	31 c0                	xor    %eax,%eax
  1020bb:	ee                   	out    %al,(%dx)
  1020bc:	ba f2 01 00 00       	mov    $0x1f2,%edx
  1020c1:	b8 01 00 00 00       	mov    $0x1,%eax
  1020c6:	ee                   	out    %al,(%dx)
    panic("ide_start_request");

  ide_wait_ready(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  1020c7:	8b 71 08             	mov    0x8(%ecx),%esi
  1020ca:	b2 f3                	mov    $0xf3,%dl
  1020cc:	89 f0                	mov    %esi,%eax
  1020ce:	ee                   	out    %al,(%dx)
  1020cf:	89 f0                	mov    %esi,%eax
  1020d1:	b2 f4                	mov    $0xf4,%dl
  1020d3:	c1 e8 08             	shr    $0x8,%eax
  1020d6:	ee                   	out    %al,(%dx)
  1020d7:	89 f0                	mov    %esi,%eax
  1020d9:	b2 f5                	mov    $0xf5,%dl
  1020db:	c1 e8 10             	shr    $0x10,%eax
  1020de:	ee                   	out    %al,(%dx)
  1020df:	8b 41 04             	mov    0x4(%ecx),%eax
  1020e2:	c1 ee 18             	shr    $0x18,%esi
  1020e5:	b2 f6                	mov    $0xf6,%dl
  1020e7:	83 e6 0f             	and    $0xf,%esi
  1020ea:	83 e0 01             	and    $0x1,%eax
  1020ed:	c1 e0 04             	shl    $0x4,%eax
  1020f0:	09 f0                	or     %esi,%eax
  1020f2:	83 c8 e0             	or     $0xffffffe0,%eax
  1020f5:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  1020f6:	f6 01 04             	testb  $0x4,(%ecx)
  1020f9:	75 11                	jne    10210c <ide_start_request+0x7c>
  1020fb:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102100:	b8 20 00 00 00       	mov    $0x20,%eax
  102105:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  102106:	83 c4 14             	add    $0x14,%esp
  102109:	5e                   	pop    %esi
  10210a:	5d                   	pop    %ebp
  10210b:	c3                   	ret    
  10210c:	b2 f7                	mov    $0xf7,%dl
  10210e:	b8 30 00 00 00       	mov    $0x30,%eax
  102113:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  102114:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102119:	8d 71 18             	lea    0x18(%ecx),%esi
  10211c:	b9 80 00 00 00       	mov    $0x80,%ecx
  102121:	fc                   	cld    
  102122:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  102124:	83 c4 14             	add    $0x14,%esp
  102127:	5e                   	pop    %esi
  102128:	5d                   	pop    %ebp
  102129:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  10212a:	c7 04 24 7c 68 10 00 	movl   $0x10687c,(%esp)
  102131:	e8 2a e8 ff ff       	call   100960 <panic>
  102136:	8d 76 00             	lea    0x0(%esi),%esi
  102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102140 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102140:	55                   	push   %ebp
  102141:	89 e5                	mov    %esp,%ebp
  102143:	53                   	push   %ebx
  102144:	83 ec 14             	sub    $0x14,%esp
  102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10214a:	8b 03                	mov    (%ebx),%eax
  10214c:	a8 01                	test   $0x1,%al
  10214e:	0f 84 90 00 00 00    	je     1021e4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102154:	83 e0 06             	and    $0x6,%eax
  102157:	83 f8 02             	cmp    $0x2,%eax
  10215a:	0f 84 9c 00 00 00    	je     1021fc <ide_rw+0xbc>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102160:	8b 53 04             	mov    0x4(%ebx),%edx
  102163:	85 d2                	test   %edx,%edx
  102165:	74 0d                	je     102174 <ide_rw+0x34>
  102167:	a1 f8 86 10 00       	mov    0x1086f8,%eax
  10216c:	85 c0                	test   %eax,%eax
  10216e:	0f 84 7c 00 00 00    	je     1021f0 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102174:	c7 04 24 c0 86 10 00 	movl   $0x1086c0,(%esp)
  10217b:	e8 00 24 00 00       	call   104580 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102180:	a1 f4 86 10 00       	mov    0x1086f4,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102185:	ba f4 86 10 00       	mov    $0x1086f4,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10218a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102191:	85 c0                	test   %eax,%eax
  102193:	74 0d                	je     1021a2 <ide_rw+0x62>
  102195:	8d 76 00             	lea    0x0(%esi),%esi
  102198:	8d 50 14             	lea    0x14(%eax),%edx
  10219b:	8b 40 14             	mov    0x14(%eax),%eax
  10219e:	85 c0                	test   %eax,%eax
  1021a0:	75 f6                	jne    102198 <ide_rw+0x58>
    ;
  *pp = b;
  1021a2:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  1021a4:	39 1d f4 86 10 00    	cmp    %ebx,0x1086f4
  1021aa:	75 14                	jne    1021c0 <ide_rw+0x80>
  1021ac:	eb 2d                	jmp    1021db <ide_rw+0x9b>
  1021ae:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  1021b0:	c7 44 24 04 c0 86 10 	movl   $0x1086c0,0x4(%esp)
  1021b7:	00 
  1021b8:	89 1c 24             	mov    %ebx,(%esp)
  1021bb:	e8 30 16 00 00       	call   1037f0 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1021c0:	8b 03                	mov    (%ebx),%eax
  1021c2:	83 e0 06             	and    $0x6,%eax
  1021c5:	83 f8 02             	cmp    $0x2,%eax
  1021c8:	75 e6                	jne    1021b0 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  1021ca:	c7 45 08 c0 86 10 00 	movl   $0x1086c0,0x8(%ebp)
}
  1021d1:	83 c4 14             	add    $0x14,%esp
  1021d4:	5b                   	pop    %ebx
  1021d5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  1021d6:	e9 65 23 00 00       	jmp    104540 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  1021db:	89 d8                	mov    %ebx,%eax
  1021dd:	e8 ae fe ff ff       	call   102090 <ide_start_request>
  1021e2:	eb dc                	jmp    1021c0 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1021e4:	c7 04 24 8e 68 10 00 	movl   $0x10688e,(%esp)
  1021eb:	e8 70 e7 ff ff       	call   100960 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1021f0:	c7 04 24 b9 68 10 00 	movl   $0x1068b9,(%esp)
  1021f7:	e8 64 e7 ff ff       	call   100960 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1021fc:	c7 04 24 a3 68 10 00 	movl   $0x1068a3,(%esp)
  102203:	e8 58 e7 ff ff       	call   100960 <panic>
  102208:	90                   	nop
  102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102210 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  102210:	55                   	push   %ebp
  102211:	89 e5                	mov    %esp,%ebp
  102213:	57                   	push   %edi
  102214:	53                   	push   %ebx
  102215:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  102218:	c7 04 24 c0 86 10 00 	movl   $0x1086c0,(%esp)
  10221f:	e8 5c 23 00 00       	call   104580 <acquire>
  if((b = ide_queue) == 0){
  102224:	8b 1d f4 86 10 00    	mov    0x1086f4,%ebx
  10222a:	85 db                	test   %ebx,%ebx
  10222c:	74 28                	je     102256 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  10222e:	8b 0b                	mov    (%ebx),%ecx
  102230:	f6 c1 04             	test   $0x4,%cl
  102233:	74 3b                	je     102270 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  102235:	83 c9 02             	or     $0x2,%ecx
  102238:	83 e1 fb             	and    $0xfffffffb,%ecx
  10223b:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  10223d:	89 1c 24             	mov    %ebx,(%esp)
  102240:	e8 fb 11 00 00       	call   103440 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102245:	8b 43 14             	mov    0x14(%ebx),%eax
  102248:	85 c0                	test   %eax,%eax
  10224a:	a3 f4 86 10 00       	mov    %eax,0x1086f4
  10224f:	74 05                	je     102256 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102251:	e8 3a fe ff ff       	call   102090 <ide_start_request>

  release(&ide_lock);
  102256:	c7 04 24 c0 86 10 00 	movl   $0x1086c0,(%esp)
  10225d:	e8 de 22 00 00       	call   104540 <release>
}
  102262:	83 c4 10             	add    $0x10,%esp
  102265:	5b                   	pop    %ebx
  102266:	5f                   	pop    %edi
  102267:	5d                   	pop    %ebp
  102268:	c3                   	ret    
  102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102270:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102275:	8d 76 00             	lea    0x0(%esi),%esi
  102278:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102279:	0f b6 c0             	movzbl %al,%eax
  10227c:	84 c0                	test   %al,%al
  10227e:	78 f8                	js     102278 <ide_intr+0x68>
  102280:	a8 40                	test   $0x40,%al
  102282:	74 f4                	je     102278 <ide_intr+0x68>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102284:	a8 21                	test   $0x21,%al
  102286:	75 ad                	jne    102235 <ide_intr+0x25>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102288:	8d 7b 18             	lea    0x18(%ebx),%edi
  10228b:	b9 80 00 00 00       	mov    $0x80,%ecx
  102290:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102295:	fc                   	cld    
  102296:	f2 6d                	repnz insl (%dx),%es:(%edi)
  102298:	8b 0b                	mov    (%ebx),%ecx
  10229a:	eb 99                	jmp    102235 <ide_intr+0x25>
  10229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001022a0 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  1022a0:	55                   	push   %ebp
  1022a1:	89 e5                	mov    %esp,%ebp
  1022a3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&ide_lock, "ide");
  1022a6:	c7 44 24 04 d0 68 10 	movl   $0x1068d0,0x4(%esp)
  1022ad:	00 
  1022ae:	c7 04 24 c0 86 10 00 	movl   $0x1086c0,(%esp)
  1022b5:	e8 06 21 00 00       	call   1043c0 <initlock>
  pic_enable(IRQ_IDE);
  1022ba:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022c1:	e8 8a 0b 00 00       	call   102e50 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  1022c6:	a1 e0 bf 10 00       	mov    0x10bfe0,%eax
  1022cb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022d2:	83 e8 01             	sub    $0x1,%eax
  1022d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1022d9:	e8 52 00 00 00       	call   102330 <ioapic_enable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1022de:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022e3:	90                   	nop
  1022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1022e8:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  1022e9:	0f b6 c0             	movzbl %al,%eax
  1022ec:	84 c0                	test   %al,%al
  1022ee:	78 f8                	js     1022e8 <ide_init+0x48>
  1022f0:	a8 40                	test   $0x40,%al
  1022f2:	74 f4                	je     1022e8 <ide_init+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1022f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1022f9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1022fe:	ee                   	out    %al,(%dx)
  1022ff:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102301:	b2 f7                	mov    $0xf7,%dl
  102303:	eb 0e                	jmp    102313 <ide_init+0x73>
  102305:	8d 76 00             	lea    0x0(%esi),%esi
  ioapic_enable(IRQ_IDE, ncpu - 1);
  ide_wait_ready(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  102308:	83 c1 01             	add    $0x1,%ecx
  10230b:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  102311:	74 0f                	je     102322 <ide_init+0x82>
  102313:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  102314:	84 c0                	test   %al,%al
  102316:	74 f0                	je     102308 <ide_init+0x68>
      disk_1_present = 1;
  102318:	c7 05 f8 86 10 00 01 	movl   $0x1,0x1086f8
  10231f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102322:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102327:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  10232c:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10232d:	c9                   	leave  
  10232e:	c3                   	ret    
  10232f:	90                   	nop

00102330 <ioapic_enable>:
}

void
ioapic_enable(int irq, int cpunum)
{
  if(!ismp)
  102330:	8b 15 60 b9 10 00    	mov    0x10b960,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102336:	55                   	push   %ebp
  102337:	89 e5                	mov    %esp,%ebp
  102339:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  10233c:	85 d2                	test   %edx,%edx
  10233e:	74 1f                	je     10235f <ioapic_enable+0x2f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102340:	8d 48 20             	lea    0x20(%eax),%ecx
  102343:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102347:	a1 14 b9 10 00       	mov    0x10b914,%eax
  10234c:	89 10                	mov    %edx,(%eax)
  10234e:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  102351:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102354:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102357:	89 10                	mov    %edx,(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102359:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  10235c:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10235f:	5d                   	pop    %ebp
  102360:	c3                   	ret    
  102361:	eb 0d                	jmp    102370 <ioapic_init>
  102363:	90                   	nop
  102364:	90                   	nop
  102365:	90                   	nop
  102366:	90                   	nop
  102367:	90                   	nop
  102368:	90                   	nop
  102369:	90                   	nop
  10236a:	90                   	nop
  10236b:	90                   	nop
  10236c:	90                   	nop
  10236d:	90                   	nop
  10236e:	90                   	nop
  10236f:	90                   	nop

00102370 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102370:	55                   	push   %ebp
  102371:	89 e5                	mov    %esp,%ebp
  102373:	56                   	push   %esi
  102374:	53                   	push   %ebx
  102375:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102378:	8b 0d 60 b9 10 00    	mov    0x10b960,%ecx
  10237e:	85 c9                	test   %ecx,%ecx
  102380:	0f 84 86 00 00 00    	je     10240c <ioapic_init+0x9c>
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  102386:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10238d:	00 00 00 
  return ioapic->data;
  102390:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102396:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  10239b:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  1023a2:	00 00 00 
  return ioapic->data;
  1023a5:	8b 15 10 00 c0 fe    	mov    0xfec00010,%edx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1023ab:	0f b6 0d 64 b9 10 00 	movzbl 0x10b964,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1023b2:	c7 05 14 b9 10 00 00 	movl   $0xfec00000,0x10b914
  1023b9:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1023bc:	c1 ee 10             	shr    $0x10,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1023bf:	c1 ea 18             	shr    $0x18,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1023c2:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  1023c8:	39 d1                	cmp    %edx,%ecx
  1023ca:	74 11                	je     1023dd <ioapic_init+0x6d>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1023cc:	c7 04 24 d4 68 10 00 	movl   $0x1068d4,(%esp)
  1023d3:	e8 e8 e3 ff ff       	call   1007c0 <cprintf>
  1023d8:	a1 14 b9 10 00       	mov    0x10b914,%eax
  1023dd:	b9 10 00 00 00       	mov    $0x10,%ecx
  1023e2:	31 d2                	xor    %edx,%edx
  1023e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1023e8:	8d 5a 20             	lea    0x20(%edx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023eb:	83 c2 01             	add    $0x1,%edx
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1023ee:	81 cb 00 00 01 00    	or     $0x10000,%ebx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1023f4:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  1023f6:	89 58 10             	mov    %ebx,0x10(%eax)
  1023f9:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023fc:	83 c1 02             	add    $0x2,%ecx
  1023ff:	39 d6                	cmp    %edx,%esi
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102401:	89 18                	mov    %ebx,(%eax)
  ioapic->data = data;
  102403:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10240a:	7d dc                	jge    1023e8 <ioapic_init+0x78>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  10240c:	83 c4 10             	add    $0x10,%esp
  10240f:	5b                   	pop    %ebx
  102410:	5e                   	pop    %esi
  102411:	5d                   	pop    %ebp
  102412:	c3                   	ret    
  102413:	90                   	nop
  102414:	90                   	nop
  102415:	90                   	nop
  102416:	90                   	nop
  102417:	90                   	nop
  102418:	90                   	nop
  102419:	90                   	nop
  10241a:	90                   	nop
  10241b:	90                   	nop
  10241c:	90                   	nop
  10241d:	90                   	nop
  10241e:	90                   	nop
  10241f:	90                   	nop

00102420 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  102420:	55                   	push   %ebp
  102421:	89 e5                	mov    %esp,%ebp
  102423:	56                   	push   %esi
  102424:	53                   	push   %ebx
  102425:	83 ec 10             	sub    $0x10,%esp
  102428:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  10242b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102431:	74 0d                	je     102440 <kalloc+0x20>
    panic("kalloc");
  102433:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10243a:	e8 21 e5 ff ff       	call   100960 <panic>
  10243f:	90                   	nop
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  102440:	85 f6                	test   %esi,%esi
  102442:	7e ef                	jle    102433 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  102444:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  10244b:	e8 30 21 00 00       	call   104580 <acquire>
  102450:	8b 1d 54 b9 10 00    	mov    0x10b954,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102456:	85 db                	test   %ebx,%ebx
  102458:	74 3e                	je     102498 <kalloc+0x78>
    if(r->len == n){
  10245a:	8b 43 04             	mov    0x4(%ebx),%eax
  10245d:	ba 54 b9 10 00       	mov    $0x10b954,%edx
  102462:	39 f0                	cmp    %esi,%eax
  102464:	75 11                	jne    102477 <kalloc+0x57>
  102466:	eb 58                	jmp    1024c0 <kalloc+0xa0>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102468:	89 da                	mov    %ebx,%edx
  10246a:	8b 1b                	mov    (%ebx),%ebx
  10246c:	85 db                	test   %ebx,%ebx
  10246e:	74 28                	je     102498 <kalloc+0x78>
    if(r->len == n){
  102470:	8b 43 04             	mov    0x4(%ebx),%eax
  102473:	39 f0                	cmp    %esi,%eax
  102475:	74 49                	je     1024c0 <kalloc+0xa0>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102477:	39 c6                	cmp    %eax,%esi
  102479:	7d ed                	jge    102468 <kalloc+0x48>
      r->len -= n;
  10247b:	29 f0                	sub    %esi,%eax
  10247d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102480:	01 c3                	add    %eax,%ebx
      release(&kalloc_lock);
  102482:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  102489:	e8 b2 20 00 00       	call   104540 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10248e:	83 c4 10             	add    $0x10,%esp
  102491:	89 d8                	mov    %ebx,%eax
  102493:	5b                   	pop    %ebx
  102494:	5e                   	pop    %esi
  102495:	5d                   	pop    %ebp
  102496:	c3                   	ret    
  102497:	90                   	nop
      return p;
    }
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  102498:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  10249a:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  1024a1:	e8 9a 20 00 00       	call   104540 <release>

  cprintf("kalloc: out of memory\n");
  1024a6:	c7 04 24 0f 69 10 00 	movl   $0x10690f,(%esp)
  1024ad:	e8 0e e3 ff ff       	call   1007c0 <cprintf>
  return 0;
}
  1024b2:	83 c4 10             	add    $0x10,%esp
  1024b5:	89 d8                	mov    %ebx,%eax
  1024b7:	5b                   	pop    %ebx
  1024b8:	5e                   	pop    %esi
  1024b9:	5d                   	pop    %ebp
  1024ba:	c3                   	ret    
  1024bb:	90                   	nop
  1024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  1024c0:	8b 03                	mov    (%ebx),%eax
  1024c2:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  1024c4:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  1024cb:	e8 70 20 00 00       	call   104540 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  1024d0:	83 c4 10             	add    $0x10,%esp
  1024d3:	89 d8                	mov    %ebx,%eax
  1024d5:	5b                   	pop    %ebx
  1024d6:	5e                   	pop    %esi
  1024d7:	5d                   	pop    %ebp
  1024d8:	c3                   	ret    
  1024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1024e0:	55                   	push   %ebp
  1024e1:	89 e5                	mov    %esp,%ebp
  1024e3:	57                   	push   %edi
  1024e4:	56                   	push   %esi
  1024e5:	53                   	push   %ebx
  1024e6:	83 ec 2c             	sub    $0x2c,%esp
  1024e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1024ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1024ef:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1024f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1024f4:	0f 8e e9 00 00 00    	jle    1025e3 <kfree+0x103>
  1024fa:	a9 ff 0f 00 00       	test   $0xfff,%eax
  1024ff:	0f 85 de 00 00 00    	jne    1025e3 <kfree+0x103>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  102505:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102508:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10250f:	00 
  102510:	89 1c 24             	mov    %ebx,(%esp)
  102513:	89 54 24 08          	mov    %edx,0x8(%esp)
  102517:	e8 d4 20 00 00       	call   1045f0 <memset>

  acquire(&kalloc_lock);
  10251c:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  102523:	e8 58 20 00 00       	call   104580 <acquire>
  p = (struct run*)v;
  102528:	a1 54 b9 10 00       	mov    0x10b954,%eax
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  10252d:	85 c0                	test   %eax,%eax
  10252f:	74 61                	je     102592 <kfree+0xb2>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  102531:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102534:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102537:	39 c1                	cmp    %eax,%ecx
  102539:	72 57                	jb     102592 <kfree+0xb2>
    rend = (struct run*)((char*)r + r->len);
  10253b:	8b 70 04             	mov    0x4(%eax),%esi
  10253e:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102541:	39 d3                	cmp    %edx,%ebx
  102543:	72 73                	jb     1025b8 <kfree+0xd8>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102545:	39 c1                	cmp    %eax,%ecx
  102547:	0f 84 8f 00 00 00    	je     1025dc <kfree+0xfc>
  10254d:	8d 76 00             	lea    0x0(%esi),%esi
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102550:	39 da                	cmp    %ebx,%edx
  102552:	74 6c                	je     1025c0 <kfree+0xe0>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102554:	89 c7                	mov    %eax,%edi
  102556:	8b 00                	mov    (%eax),%eax
  102558:	85 c0                	test   %eax,%eax
  10255a:	74 3c                	je     102598 <kfree+0xb8>
  10255c:	39 c1                	cmp    %eax,%ecx
  10255e:	72 38                	jb     102598 <kfree+0xb8>
    rend = (struct run*)((char*)r + r->len);
  102560:	8b 70 04             	mov    0x4(%eax),%esi
  102563:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102566:	39 d3                	cmp    %edx,%ebx
  102568:	73 16                	jae    102580 <kfree+0xa0>
  10256a:	39 c3                	cmp    %eax,%ebx
  10256c:	72 12                	jb     102580 <kfree+0xa0>
      panic("freeing free page");
  10256e:	c7 04 24 2c 69 10 00 	movl   $0x10692c,(%esp)
  102575:	e8 e6 e3 ff ff       	call   100960 <panic>
  10257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  102580:	39 c1                	cmp    %eax,%ecx
  102582:	75 cc                	jne    102550 <kfree+0x70>
      p->len = len + r->len;
      p->next = r->next;
  102584:	8b 01                	mov    (%ecx),%eax
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  102586:	03 75 e4             	add    -0x1c(%ebp),%esi
      p->next = r->next;
  102589:	89 03                	mov    %eax,(%ebx)
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  10258b:	89 73 04             	mov    %esi,0x4(%ebx)
      p->next = r->next;
      *rp = p;
  10258e:	89 1f                	mov    %ebx,(%edi)
      goto out;
  102590:	eb 10                	jmp    1025a2 <kfree+0xc2>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102592:	bf 54 b9 10 00       	mov    $0x10b954,%edi
  102597:	90                   	nop
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102598:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->next = r;
  10259b:	89 03                	mov    %eax,(%ebx)
  *rp = p;
  10259d:	89 1f                	mov    %ebx,(%edi)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  10259f:	89 53 04             	mov    %edx,0x4(%ebx)
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  1025a2:	c7 45 08 20 b9 10 00 	movl   $0x10b920,0x8(%ebp)
}
  1025a9:	83 c4 2c             	add    $0x2c,%esp
  1025ac:	5b                   	pop    %ebx
  1025ad:	5e                   	pop    %esi
  1025ae:	5f                   	pop    %edi
  1025af:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  1025b0:	e9 8b 1f 00 00       	jmp    104540 <release>
  1025b5:	8d 76 00             	lea    0x0(%esi),%esi
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  1025b8:	39 c3                	cmp    %eax,%ebx
  1025ba:	73 b2                	jae    10256e <kfree+0x8e>
  1025bc:	eb 87                	jmp    102545 <kfree+0x65>
  1025be:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  1025c0:	8b 10                	mov    (%eax),%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  1025c2:	03 75 e4             	add    -0x1c(%ebp),%esi
      if(r->next && r->next == pend){  // r now next to r->next?
  1025c5:	85 d2                	test   %edx,%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  1025c7:	89 70 04             	mov    %esi,0x4(%eax)
      if(r->next && r->next == pend){  // r now next to r->next?
  1025ca:	74 d6                	je     1025a2 <kfree+0xc2>
  1025cc:	39 d1                	cmp    %edx,%ecx
  1025ce:	75 d2                	jne    1025a2 <kfree+0xc2>
        r->len += r->next->len;
        r->next = r->next->next;
  1025d0:	8b 11                	mov    (%ecx),%edx
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  1025d2:	03 71 04             	add    0x4(%ecx),%esi
        r->next = r->next->next;
  1025d5:	89 10                	mov    %edx,(%eax)
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  1025d7:	89 70 04             	mov    %esi,0x4(%eax)
  1025da:	eb c6                	jmp    1025a2 <kfree+0xc2>
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1025dc:	bf 54 b9 10 00       	mov    $0x10b954,%edi
  1025e1:	eb a1                	jmp    102584 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  1025e3:	c7 04 24 26 69 10 00 	movl   $0x106926,(%esp)
  1025ea:	e8 71 e3 ff ff       	call   100960 <panic>
  1025ef:	90                   	nop

001025f0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1025f0:	55                   	push   %ebp
  1025f1:	89 e5                	mov    %esp,%ebp
  1025f3:	83 ec 18             	sub    $0x18,%esp
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1025f6:	c7 44 24 04 08 69 10 	movl   $0x106908,0x4(%esp)
  1025fd:	00 
  1025fe:	c7 04 24 20 b9 10 00 	movl   $0x10b920,(%esp)
  102605:	e8 b6 1d 00 00       	call   1043c0 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  10260a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  102611:	00 
  102612:	c7 04 24 3e 69 10 00 	movl   $0x10693e,(%esp)
  102619:	e8 a2 e1 ff ff       	call   1007c0 <cprintf>
  kfree(start, mem * PAGE);
  10261e:	b8 84 ff 10 00       	mov    $0x10ff84,%eax
  102623:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102628:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10262f:	00 
  102630:	89 04 24             	mov    %eax,(%esp)
  102633:	e8 a8 fe ff ff       	call   1024e0 <kfree>
}
  102638:	c9                   	leave  
  102639:	c3                   	ret    
  10263a:	90                   	nop
  10263b:	90                   	nop
  10263c:	90                   	nop
  10263d:	90                   	nop
  10263e:	90                   	nop
  10263f:	90                   	nop

00102640 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102640:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102641:	ba 64 00 00 00       	mov    $0x64,%edx
  102646:	89 e5                	mov    %esp,%ebp
  102648:	ec                   	in     (%dx),%al
  102649:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  10264b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102650:	83 e2 01             	and    $0x1,%edx
  102653:	74 3e                	je     102693 <kbd_getc+0x53>
  102655:	ba 60 00 00 00       	mov    $0x60,%edx
  10265a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  10265b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  10265e:	3d e0 00 00 00       	cmp    $0xe0,%eax
  102663:	0f 84 7f 00 00 00    	je     1026e8 <kbd_getc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102669:	84 c0                	test   %al,%al
  10266b:	79 2b                	jns    102698 <kbd_getc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  10266d:	8b 15 fc 86 10 00    	mov    0x1086fc,%edx
  102673:	f6 c2 40             	test   $0x40,%dl
  102676:	75 03                	jne    10267b <kbd_getc+0x3b>
  102678:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10267b:	0f b6 80 60 69 10 00 	movzbl 0x106960(%eax),%eax
  102682:	83 c8 40             	or     $0x40,%eax
  102685:	0f b6 c0             	movzbl %al,%eax
  102688:	f7 d0                	not    %eax
  10268a:	21 d0                	and    %edx,%eax
  10268c:	a3 fc 86 10 00       	mov    %eax,0x1086fc
  102691:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102693:	5d                   	pop    %ebp
  102694:	c3                   	ret    
  102695:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102698:	8b 0d fc 86 10 00    	mov    0x1086fc,%ecx
  10269e:	f6 c1 40             	test   $0x40,%cl
  1026a1:	74 05                	je     1026a8 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1026a3:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  1026a5:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1026a8:	0f b6 90 60 69 10 00 	movzbl 0x106960(%eax),%edx
  1026af:	09 ca                	or     %ecx,%edx
  1026b1:	0f b6 88 60 6a 10 00 	movzbl 0x106a60(%eax),%ecx
  1026b8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  1026ba:	89 d1                	mov    %edx,%ecx
  1026bc:	83 e1 03             	and    $0x3,%ecx
  1026bf:	8b 0c 8d 60 6b 10 00 	mov    0x106b60(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1026c6:	89 15 fc 86 10 00    	mov    %edx,0x1086fc
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  1026cc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1026cf:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  1026d3:	74 be                	je     102693 <kbd_getc+0x53>
    if('a' <= c && c <= 'z')
  1026d5:	8d 50 9f             	lea    -0x61(%eax),%edx
  1026d8:	83 fa 19             	cmp    $0x19,%edx
  1026db:	77 1b                	ja     1026f8 <kbd_getc+0xb8>
      c += 'A' - 'a';
  1026dd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1026e0:	5d                   	pop    %ebp
  1026e1:	c3                   	ret    
  1026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1026e8:	30 c0                	xor    %al,%al
  1026ea:	83 0d fc 86 10 00 40 	orl    $0x40,0x1086fc
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1026f1:	5d                   	pop    %ebp
  1026f2:	c3                   	ret    
  1026f3:	90                   	nop
  1026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1026f8:	8d 50 bf             	lea    -0x41(%eax),%edx
  1026fb:	83 fa 19             	cmp    $0x19,%edx
  1026fe:	77 93                	ja     102693 <kbd_getc+0x53>
      c += 'a' - 'A';
  102700:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  102703:	5d                   	pop    %ebp
  102704:	c3                   	ret    
  102705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102710 <kbd_intr>:

void
kbd_intr(void)
{
  102710:	55                   	push   %ebp
  102711:	89 e5                	mov    %esp,%ebp
  102713:	83 ec 18             	sub    $0x18,%esp
  console_intr(kbd_getc);
  102716:	c7 04 24 40 26 10 00 	movl   $0x102640,(%esp)
  10271d:	e8 4e de ff ff       	call   100570 <console_intr>
}
  102722:	c9                   	leave  
  102723:	c3                   	ret    
  102724:	90                   	nop
  102725:	90                   	nop
  102726:	90                   	nop
  102727:	90                   	nop
  102728:	90                   	nop
  102729:	90                   	nop
  10272a:	90                   	nop
  10272b:	90                   	nop
  10272c:	90                   	nop
  10272d:	90                   	nop
  10272e:	90                   	nop
  10272f:	90                   	nop

00102730 <lapic_init>:
}

void
lapic_init(int c)
{
  if(!lapic) 
  102730:	a1 58 b9 10 00       	mov    0x10b958,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  102735:	55                   	push   %ebp
  102736:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  102738:	85 c0                	test   %eax,%eax
  10273a:	0f 84 c4 00 00 00    	je     102804 <lapic_init+0xd4>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102740:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  102747:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10274a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10274d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102757:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10275a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  102761:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  102764:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102767:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10276e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102771:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102774:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10277b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10277e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102781:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102788:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10278b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10278e:	8b 50 30             	mov    0x30(%eax),%edx
  102791:	c1 ea 10             	shr    $0x10,%edx
  102794:	80 fa 03             	cmp    $0x3,%dl
  102797:	77 6f                	ja     102808 <lapic_init+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102799:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  1027a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027a3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027a6:	8d 88 00 03 00 00    	lea    0x300(%eax),%ecx
  1027ac:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027b6:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b9:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  1027c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027c3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027c6:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1027cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027d0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027d3:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1027da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027dd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027e0:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1027e7:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1027ea:	8b 50 20             	mov    0x20(%eax),%edx
  1027ed:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1027f0:	8b 11                	mov    (%ecx),%edx
  1027f2:	80 e6 10             	and    $0x10,%dh
  1027f5:	75 f9                	jne    1027f0 <lapic_init+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027f7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  1027fe:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102801:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  102804:	5d                   	pop    %ebp
  102805:	c3                   	ret    
  102806:	66 90                	xchg   %ax,%ax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102808:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  10280f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  102812:	8b 50 20             	mov    0x20(%eax),%edx
  102815:	eb 82                	jmp    102799 <lapic_init+0x69>
  102817:	89 f6                	mov    %esi,%esi
  102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102820 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  102820:	a1 58 b9 10 00       	mov    0x10b958,%eax
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  102825:	55                   	push   %ebp
  102826:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102828:	85 c0                	test   %eax,%eax
  10282a:	74 0d                	je     102839 <lapic_eoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10282c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102833:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102836:	8b 40 20             	mov    0x20(%eax),%eax
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  102839:	5d                   	pop    %ebp
  10283a:	c3                   	ret    
  10283b:	90                   	nop
  10283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102840 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  102840:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102841:	ba 70 00 00 00       	mov    $0x70,%edx
  102846:	89 e5                	mov    %esp,%ebp
  102848:	b8 0f 00 00 00       	mov    $0xf,%eax
  10284d:	57                   	push   %edi
  10284e:	56                   	push   %esi
  10284f:	53                   	push   %ebx
  102850:	83 ec 18             	sub    $0x18,%esp
  102853:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  102857:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10285a:	ee                   	out    %al,(%dx)
  10285b:	b8 0a 00 00 00       	mov    $0xa,%eax
  102860:	b2 71                	mov    $0x71,%dl
  102862:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102863:	8b 15 58 b9 10 00    	mov    0x10b958,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102869:	89 d8                	mov    %ebx,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10286b:	89 cf                	mov    %ecx,%edi
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  10286d:	c1 e8 04             	shr    $0x4,%eax
  102870:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102876:	c1 e7 18             	shl    $0x18,%edi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102879:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102880:	00 00 
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102882:	8d 82 10 03 00 00    	lea    0x310(%edx),%eax
  102888:	89 ba 10 03 00 00    	mov    %edi,0x310(%edx)
  lapic[ID];  // wait for write to finish, by reading
  10288e:	8d 72 20             	lea    0x20(%edx),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102891:	89 45 dc             	mov    %eax,-0x24(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102894:	8b 42 20             	mov    0x20(%edx),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102897:	8d 82 00 03 00 00    	lea    0x300(%edx),%eax
  10289d:	c7 82 00 03 00 00 00 	movl   $0xc500,0x300(%edx)
  1028a4:	c5 00 00 
  1028a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  1028aa:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  1028ad:	b8 c7 00 00 00       	mov    $0xc7,%eax
  1028b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028b9:	eb 0c                	jmp    1028c7 <lapic_startap+0x87>
  1028bb:	90                   	nop
  1028bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  1028c0:	85 c0                	test   %eax,%eax
  1028c2:	74 2d                	je     1028f1 <lapic_startap+0xb1>
  1028c4:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  1028c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028ce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1028d1:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  1028d7:	7f e7                	jg     1028c0 <lapic_startap+0x80>
  1028d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1028dc:	83 c1 01             	add    $0x1,%ecx
  1028df:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1028e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1028e5:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  1028eb:	7e ec                	jle    1028d9 <lapic_startap+0x99>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  1028ed:	85 c0                	test   %eax,%eax
  1028ef:	75 d3                	jne    1028c4 <lapic_startap+0x84>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028f1:	c7 82 00 03 00 00 00 	movl   $0x8500,0x300(%edx)
  1028f8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1028fb:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  1028fe:	b8 63 00 00 00       	mov    $0x63,%eax
  102903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10290a:	eb 0b                	jmp    102917 <lapic_startap+0xd7>
  10290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102910:	85 c0                	test   %eax,%eax
  102912:	74 2d                	je     102941 <lapic_startap+0x101>
  102914:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102917:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10291e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102921:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102927:	7f e7                	jg     102910 <lapic_startap+0xd0>
  102929:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10292c:	83 c2 01             	add    $0x1,%edx
  10292f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102932:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102935:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  10293b:	7e ec                	jle    102929 <lapic_startap+0xe9>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  10293d:	85 c0                	test   %eax,%eax
  10293f:	75 d3                	jne    102914 <lapic_startap+0xd4>
  102941:	c1 eb 0c             	shr    $0xc,%ebx
  102944:	31 c9                	xor    %ecx,%ecx
  102946:	80 cf 06             	or     $0x6,%bh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102949:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10294c:	89 38                	mov    %edi,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  10294e:	8b 06                	mov    (%esi),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102953:	89 18                	mov    %ebx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102955:	8b 06                	mov    (%esi),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102957:	b8 c7 00 00 00       	mov    $0xc7,%eax
  10295c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102963:	eb 0a                	jmp    10296f <lapic_startap+0x12f>
  102965:	8d 76 00             	lea    0x0(%esi),%esi
  
  while(us-- > 0)
  102968:	85 c0                	test   %eax,%eax
  10296a:	74 34                	je     1029a0 <lapic_startap+0x160>
  10296c:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  10296f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102976:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102979:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  10297f:	7f e7                	jg     102968 <lapic_startap+0x128>
  102981:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102984:	83 c2 01             	add    $0x1,%edx
  102987:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10298a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10298d:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102993:	7e ec                	jle    102981 <lapic_startap+0x141>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102995:	85 c0                	test   %eax,%eax
  102997:	75 d3                	jne    10296c <lapic_startap+0x12c>
  102999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Send startup IPI (twice!) to enter bootstrap code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
  1029a0:	83 c1 01             	add    $0x1,%ecx
  1029a3:	83 f9 02             	cmp    $0x2,%ecx
  1029a6:	75 a1                	jne    102949 <lapic_startap+0x109>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  1029a8:	83 c4 18             	add    $0x18,%esp
  1029ab:	5b                   	pop    %ebx
  1029ac:	5e                   	pop    %esi
  1029ad:	5f                   	pop    %edi
  1029ae:	5d                   	pop    %ebp
  1029af:	c3                   	ret    

001029b0 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  1029b0:	55                   	push   %ebp
  1029b1:	89 e5                	mov    %esp,%ebp
  1029b3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1029b6:	9c                   	pushf  
  1029b7:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  1029b8:	f6 c4 02             	test   $0x2,%ah
  1029bb:	74 12                	je     1029cf <cpu+0x1f>
    static int n;
    if(n++ == 0)
  1029bd:	a1 00 87 10 00       	mov    0x108700,%eax
  1029c2:	8d 50 01             	lea    0x1(%eax),%edx
  1029c5:	85 c0                	test   %eax,%eax
  1029c7:	89 15 00 87 10 00    	mov    %edx,0x108700
  1029cd:	74 19                	je     1029e8 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  1029cf:	8b 15 58 b9 10 00    	mov    0x10b958,%edx
  1029d5:	31 c0                	xor    %eax,%eax
  1029d7:	85 d2                	test   %edx,%edx
  1029d9:	74 06                	je     1029e1 <cpu+0x31>
    return lapic[ID]>>24;
  1029db:	8b 42 20             	mov    0x20(%edx),%eax
  1029de:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1029e1:	c9                   	leave  
  1029e2:	c3                   	ret    
  1029e3:	90                   	nop
  1029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1029e8:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1029ea:	8b 40 04             	mov    0x4(%eax),%eax
  1029ed:	c7 04 24 70 6b 10 00 	movl   $0x106b70,(%esp)
  1029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f8:	e8 c3 dd ff ff       	call   1007c0 <cprintf>
  1029fd:	eb d0                	jmp    1029cf <cpu+0x1f>
  1029ff:	90                   	nop

00102a00 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102a00:	55                   	push   %ebp
  102a01:	89 e5                	mov    %esp,%ebp
  102a03:	53                   	push   %ebx
  102a04:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102a07:	e8 a4 ff ff ff       	call   1029b0 <cpu>
  102a0c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  102a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a17:	e8 a4 dd ff ff       	call   1007c0 <cprintf>
  idtinit();
  102a1c:	e8 4f 2f 00 00       	call   105970 <idtinit>
  if(cpu() != mp_bcpu())
  102a21:	e8 8a ff ff ff       	call   1029b0 <cpu>
  102a26:	89 c3                	mov    %eax,%ebx
  102a28:	e8 c3 01 00 00       	call   102bf0 <mp_bcpu>
  102a2d:	39 c3                	cmp    %eax,%ebx
  102a2f:	74 0d                	je     102a3e <mpmain+0x3e>
    lapic_init(cpu());
  102a31:	e8 7a ff ff ff       	call   1029b0 <cpu>
  102a36:	89 04 24             	mov    %eax,(%esp)
  102a39:	e8 f2 fc ff ff       	call   102730 <lapic_init>
  setupsegs(0);
  102a3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102a45:	e8 c6 10 00 00       	call   103b10 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  102a4a:	e8 61 ff ff ff       	call   1029b0 <cpu>
  102a4f:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102a55:	b8 01 00 00 00       	mov    $0x1,%eax
  102a5a:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  102a60:	f0 87 82 80 b9 10 00 	lock xchg %eax,0x10b980(%edx)

  cprintf("cpu%d: scheduling\n", cpu());
  102a67:	e8 44 ff ff ff       	call   1029b0 <cpu>
  102a6c:	c7 04 24 ab 6b 10 00 	movl   $0x106bab,(%esp)
  102a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a77:	e8 44 dd ff ff       	call   1007c0 <cprintf>
  scheduler();
  102a7c:	e8 6f 12 00 00       	call   103cf0 <scheduler>
  102a81:	eb 0d                	jmp    102a90 <main>
  102a83:	90                   	nop
  102a84:	90                   	nop
  102a85:	90                   	nop
  102a86:	90                   	nop
  102a87:	90                   	nop
  102a88:	90                   	nop
  102a89:	90                   	nop
  102a8a:	90                   	nop
  102a8b:	90                   	nop
  102a8c:	90                   	nop
  102a8d:	90                   	nop
  102a8e:	90                   	nop
  102a8f:	90                   	nop

00102a90 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102a90:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102a91:	b8 84 ef 10 00       	mov    $0x10ef84,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102a96:	89 e5                	mov    %esp,%ebp
  102a98:	83 e4 f0             	and    $0xfffffff0,%esp
  102a9b:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102a9c:	2d 4e 86 10 00       	sub    $0x10864e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102aa1:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102aaf:	00 
  102ab0:	c7 04 24 4e 86 10 00 	movl   $0x10864e,(%esp)
  102ab7:	e8 34 1b 00 00       	call   1045f0 <memset>

  mp_init(); // collect info about this machine
  102abc:	e8 bf 01 00 00       	call   102c80 <mp_init>
  lapic_init(mp_bcpu());
  102ac1:	e8 2a 01 00 00       	call   102bf0 <mp_bcpu>
  102ac6:	89 04 24             	mov    %eax,(%esp)
  102ac9:	e8 62 fc ff ff       	call   102730 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102ace:	e8 dd fe ff ff       	call   1029b0 <cpu>
  102ad3:	c7 04 24 be 6b 10 00 	movl   $0x106bbe,(%esp)
  102ada:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ade:	e8 dd dc ff ff       	call   1007c0 <cprintf>

  pinit();         // process table
  102ae3:	e8 b8 18 00 00       	call   1043a0 <pinit>
  binit();         // buffer cache
  102ae8:	e8 23 d7 ff ff       	call   100210 <binit>
  102aed:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  102af0:	e8 8b 03 00 00       	call   102e80 <pic_init>
  ioapic_init();   // another interrupt controller
  102af5:	e8 76 f8 ff ff       	call   102370 <ioapic_init>
  kinit();         // physical memory allocator
  102afa:	e8 f1 fa ff ff       	call   1025f0 <kinit>
  102aff:	90                   	nop
  tvinit();        // trap vectors
  102b00:	e8 1b 31 00 00       	call   105c20 <tvinit>
  fileinit();      // file table
  102b05:	e8 b6 e6 ff ff       	call   1011c0 <fileinit>
  iinit();         // inode cache
  102b0a:	e8 61 f5 ff ff       	call   102070 <iinit>
  102b0f:	90                   	nop
  console_init();  // I/O devices & their interrupts
  102b10:	e8 6b d7 ff ff       	call   100280 <console_init>
  ide_init();      // disk
  102b15:	e8 86 f7 ff ff       	call   1022a0 <ide_init>
  if(!ismp)
  102b1a:	a1 60 b9 10 00       	mov    0x10b960,%eax
  102b1f:	85 c0                	test   %eax,%eax
  102b21:	0f 84 b1 00 00 00    	je     102bd8 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102b27:	e8 84 17 00 00       	call   1042b0 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102b2c:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102b33:	00 
  102b34:	c7 44 24 04 f4 85 10 	movl   $0x1085f4,0x4(%esp)
  102b3b:	00 
  102b3c:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102b43:	e8 38 1b 00 00       	call   104680 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102b48:	69 05 e0 bf 10 00 cc 	imul   $0xcc,0x10bfe0,%eax
  102b4f:	00 00 00 
  102b52:	05 80 b9 10 00       	add    $0x10b980,%eax
  102b57:	3d 80 b9 10 00       	cmp    $0x10b980,%eax
  102b5c:	76 75                	jbe    102bd3 <main+0x143>
  102b5e:	bb 80 b9 10 00       	mov    $0x10b980,%ebx
  102b63:	90                   	nop
  102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102b68:	e8 43 fe ff ff       	call   1029b0 <cpu>
  102b6d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102b73:	05 80 b9 10 00       	add    $0x10b980,%eax
  102b78:	39 c3                	cmp    %eax,%ebx
  102b7a:	74 3e                	je     102bba <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102b7c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102b83:	e8 98 f8 ff ff       	call   102420 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102b88:	c7 05 f8 6f 00 00 00 	movl   $0x102a00,0x6ff8
  102b8f:	2a 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102b92:	05 00 10 00 00       	add    $0x1000,%eax
  102b97:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102b9c:	0f b6 03             	movzbl (%ebx),%eax
  102b9f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102ba6:	00 
  102ba7:	89 04 24             	mov    %eax,(%esp)
  102baa:	e8 91 fc ff ff       	call   102840 <lapic_startap>
  102baf:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102bb0:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102bb6:	85 c0                	test   %eax,%eax
  102bb8:	74 f6                	je     102bb0 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102bba:	69 05 e0 bf 10 00 cc 	imul   $0xcc,0x10bfe0,%eax
  102bc1:	00 00 00 
  102bc4:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102bca:	05 80 b9 10 00       	add    $0x10b980,%eax
  102bcf:	39 c3                	cmp    %eax,%ebx
  102bd1:	72 95                	jb     102b68 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102bd3:	e8 28 fe ff ff       	call   102a00 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102bd8:	e8 33 2d 00 00       	call   105910 <timer_init>
  102bdd:	8d 76 00             	lea    0x0(%esi),%esi
  102be0:	e9 42 ff ff ff       	jmp    102b27 <main+0x97>
  102be5:	90                   	nop
  102be6:	90                   	nop
  102be7:	90                   	nop
  102be8:	90                   	nop
  102be9:	90                   	nop
  102bea:	90                   	nop
  102beb:	90                   	nop
  102bec:	90                   	nop
  102bed:	90                   	nop
  102bee:	90                   	nop
  102bef:	90                   	nop

00102bf0 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102bf0:	a1 04 87 10 00       	mov    0x108704,%eax
  102bf5:	55                   	push   %ebp
  102bf6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102bf8:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102bf9:	2d 80 b9 10 00       	sub    $0x10b980,%eax
  102bfe:	c1 f8 02             	sar    $0x2,%eax
  102c01:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  102c07:	c3                   	ret    
  102c08:	90                   	nop
  102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102c10 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102c10:	55                   	push   %ebp
  102c11:	89 e5                	mov    %esp,%ebp
  102c13:	56                   	push   %esi
  102c14:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102c15:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102c18:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102c1b:	39 f0                	cmp    %esi,%eax
  102c1d:	73 42                	jae    102c61 <mp_search1+0x51>
  102c1f:	89 c3                	mov    %eax,%ebx
  102c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102c28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102c2f:	00 
  102c30:	c7 44 24 04 d5 6b 10 	movl   $0x106bd5,0x4(%esp)
  102c37:	00 
  102c38:	89 1c 24             	mov    %ebx,(%esp)
  102c3b:	e8 e0 19 00 00       	call   104620 <memcmp>
  102c40:	85 c0                	test   %eax,%eax
  102c42:	75 16                	jne    102c5a <mp_search1+0x4a>
  102c44:	31 d2                	xor    %edx,%edx
  102c46:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102c48:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c4c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102c4f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c51:	83 f8 10             	cmp    $0x10,%eax
  102c54:	75 f2                	jne    102c48 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102c56:	84 d2                	test   %dl,%dl
  102c58:	74 10                	je     102c6a <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102c5a:	83 c3 10             	add    $0x10,%ebx
  102c5d:	39 de                	cmp    %ebx,%esi
  102c5f:	77 c7                	ja     102c28 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102c61:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102c64:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102c66:	5b                   	pop    %ebx
  102c67:	5e                   	pop    %esi
  102c68:	5d                   	pop    %ebp
  102c69:	c3                   	ret    
  102c6a:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102c6d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102c6f:	5b                   	pop    %ebx
  102c70:	5e                   	pop    %esi
  102c71:	5d                   	pop    %ebp
  102c72:	c3                   	ret    
  102c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102c80 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102c80:	55                   	push   %ebp
  102c81:	89 e5                	mov    %esp,%ebp
  102c83:	57                   	push   %edi
  102c84:	56                   	push   %esi
  102c85:	53                   	push   %ebx
  102c86:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102c89:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102c90:	69 05 e0 bf 10 00 cc 	imul   $0xcc,0x10bfe0,%eax
  102c97:	00 00 00 
  102c9a:	05 80 b9 10 00       	add    $0x10b980,%eax
  102c9f:	a3 04 87 10 00       	mov    %eax,0x108704
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102ca4:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102cab:	c1 e0 08             	shl    $0x8,%eax
  102cae:	09 d0                	or     %edx,%eax
  102cb0:	c1 e0 04             	shl    $0x4,%eax
  102cb3:	85 c0                	test   %eax,%eax
  102cb5:	75 1b                	jne    102cd2 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102cb7:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102cbe:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102cc5:	c1 e0 08             	shl    $0x8,%eax
  102cc8:	09 d0                	or     %edx,%eax
  102cca:	c1 e0 0a             	shl    $0xa,%eax
  102ccd:	2d 00 04 00 00       	sub    $0x400,%eax
  102cd2:	ba 00 04 00 00       	mov    $0x400,%edx
  102cd7:	e8 34 ff ff ff       	call   102c10 <mp_search1>
  102cdc:	85 c0                	test   %eax,%eax
  102cde:	89 c3                	mov    %eax,%ebx
  102ce0:	0f 84 b2 00 00 00    	je     102d98 <mp_init+0x118>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102ce6:	8b 73 04             	mov    0x4(%ebx),%esi
  102ce9:	85 f6                	test   %esi,%esi
  102ceb:	75 0b                	jne    102cf8 <mp_init+0x78>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102ced:	83 c4 2c             	add    $0x2c,%esp
  102cf0:	5b                   	pop    %ebx
  102cf1:	5e                   	pop    %esi
  102cf2:	5f                   	pop    %edi
  102cf3:	5d                   	pop    %ebp
  102cf4:	c3                   	ret    
  102cf5:	8d 76 00             	lea    0x0(%esi),%esi
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102cf8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102cff:	00 
  102d00:	c7 44 24 04 da 6b 10 	movl   $0x106bda,0x4(%esp)
  102d07:	00 
  102d08:	89 34 24             	mov    %esi,(%esp)
  102d0b:	e8 10 19 00 00       	call   104620 <memcmp>
  102d10:	85 c0                	test   %eax,%eax
  102d12:	75 d9                	jne    102ced <mp_init+0x6d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102d14:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  102d18:	3c 04                	cmp    $0x4,%al
  102d1a:	74 06                	je     102d22 <mp_init+0xa2>
  102d1c:	3c 01                	cmp    $0x1,%al
  102d1e:	66 90                	xchg   %ax,%ax
  102d20:	75 cb                	jne    102ced <mp_init+0x6d>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102d22:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102d26:	85 d2                	test   %edx,%edx
  102d28:	74 15                	je     102d3f <mp_init+0xbf>
  102d2a:	31 c9                	xor    %ecx,%ecx
  102d2c:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  102d2e:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102d32:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102d35:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102d37:	39 c2                	cmp    %eax,%edx
  102d39:	7f f3                	jg     102d2e <mp_init+0xae>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102d3b:	84 c9                	test   %cl,%cl
  102d3d:	75 ae                	jne    102ced <mp_init+0x6d>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102d3f:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102d42:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102d45:	c7 05 60 b9 10 00 01 	movl   $0x1,0x10b960
  102d4c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102d4f:	a3 58 b9 10 00       	mov    %eax,0x10b958

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102d54:	8d 46 2c             	lea    0x2c(%esi),%eax
  102d57:	39 d0                	cmp    %edx,%eax
  102d59:	0f 83 81 00 00 00    	jae    102de0 <mp_init+0x160>
  102d5f:	8b 35 04 87 10 00    	mov    0x108704,%esi
  102d65:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  102d68:	0f b6 08             	movzbl (%eax),%ecx
  102d6b:	80 f9 04             	cmp    $0x4,%cl
  102d6e:	76 50                	jbe    102dc0 <mp_init+0x140>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102d70:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102d73:	89 35 04 87 10 00    	mov    %esi,0x108704
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102d79:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102d7d:	c7 04 24 e8 6b 10 00 	movl   $0x106be8,(%esp)
  102d84:	e8 37 da ff ff       	call   1007c0 <cprintf>
      panic("mp_init");
  102d89:	c7 04 24 df 6b 10 00 	movl   $0x106bdf,(%esp)
  102d90:	e8 cb db ff ff       	call   100960 <panic>
  102d95:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102d98:	ba 00 00 01 00       	mov    $0x10000,%edx
  102d9d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102da2:	e8 69 fe ff ff       	call   102c10 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102da7:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102da9:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102dab:	0f 85 35 ff ff ff    	jne    102ce6 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102db1:	83 c4 2c             	add    $0x2c,%esp
  102db4:	5b                   	pop    %ebx
  102db5:	5e                   	pop    %esi
  102db6:	5f                   	pop    %edi
  102db7:	5d                   	pop    %ebp
  102db8:	c3                   	ret    
  102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102dc0:	0f b6 c9             	movzbl %cl,%ecx
  102dc3:	ff 24 8d 0c 6c 10 00 	jmp    *0x106c0c(,%ecx,4)
  102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102dd0:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102dd3:	39 c2                	cmp    %eax,%edx
  102dd5:	77 91                	ja     102d68 <mp_init+0xe8>
  102dd7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  102dda:	89 35 04 87 10 00    	mov    %esi,0x108704
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102de0:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  102de4:	0f 84 03 ff ff ff    	je     102ced <mp_init+0x6d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102dea:	ba 22 00 00 00       	mov    $0x22,%edx
  102def:	b8 70 00 00 00       	mov    $0x70,%eax
  102df4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102df5:	b2 23                	mov    $0x23,%dl
  102df7:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102df8:	83 c8 01             	or     $0x1,%eax
  102dfb:	ee                   	out    %al,(%dx)
  102dfc:	e9 ec fe ff ff       	jmp    102ced <mp_init+0x6d>
  102e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102e08:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  102e0c:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102e0f:	88 0d 64 b9 10 00    	mov    %cl,0x10b964
      p += sizeof(struct mpioapic);
      continue;
  102e15:	eb bc                	jmp    102dd3 <mp_init+0x153>
  102e17:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102e18:	8b 0d e0 bf 10 00    	mov    0x10bfe0,%ecx
  102e1e:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102e22:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  102e28:	88 9f 80 b9 10 00    	mov    %bl,0x10b980(%edi)
      if(proc->flags & MPBOOT)
  102e2e:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102e32:	74 06                	je     102e3a <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  102e34:	8d b7 80 b9 10 00    	lea    0x10b980(%edi),%esi
      ncpu++;
  102e3a:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  102e3d:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102e40:	89 0d e0 bf 10 00    	mov    %ecx,0x10bfe0
      p += sizeof(struct mpproc);
      continue;
  102e46:	eb 8b                	jmp    102dd3 <mp_init+0x153>
  102e48:	90                   	nop
  102e49:	90                   	nop
  102e4a:	90                   	nop
  102e4b:	90                   	nop
  102e4c:	90                   	nop
  102e4d:	90                   	nop
  102e4e:	90                   	nop
  102e4f:	90                   	nop

00102e50 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102e50:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102e51:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102e56:	89 e5                	mov    %esp,%ebp
  102e58:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  102e5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102e60:	d3 c0                	rol    %cl,%eax
  102e62:	66 23 05 c0 81 10 00 	and    0x1081c0,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  102e69:	66 a3 c0 81 10 00    	mov    %ax,0x1081c0
  102e6f:	ee                   	out    %al,(%dx)
  102e70:	66 c1 e8 08          	shr    $0x8,%ax
  102e74:	b2 a1                	mov    $0xa1,%dl
  102e76:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  102e77:	5d                   	pop    %ebp
  102e78:	c3                   	ret    
  102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102e80 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102e80:	55                   	push   %ebp
  102e81:	b9 21 00 00 00       	mov    $0x21,%ecx
  102e86:	89 e5                	mov    %esp,%ebp
  102e88:	83 ec 0c             	sub    $0xc,%esp
  102e8b:	89 1c 24             	mov    %ebx,(%esp)
  102e8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102e93:	89 ca                	mov    %ecx,%edx
  102e95:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e99:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102e9d:	ee                   	out    %al,(%dx)
  102e9e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102ea3:	89 da                	mov    %ebx,%edx
  102ea5:	ee                   	out    %al,(%dx)
  102ea6:	be 11 00 00 00       	mov    $0x11,%esi
  102eab:	b2 20                	mov    $0x20,%dl
  102ead:	89 f0                	mov    %esi,%eax
  102eaf:	ee                   	out    %al,(%dx)
  102eb0:	b8 20 00 00 00       	mov    $0x20,%eax
  102eb5:	89 ca                	mov    %ecx,%edx
  102eb7:	ee                   	out    %al,(%dx)
  102eb8:	b8 04 00 00 00       	mov    $0x4,%eax
  102ebd:	ee                   	out    %al,(%dx)
  102ebe:	bf 03 00 00 00       	mov    $0x3,%edi
  102ec3:	89 f8                	mov    %edi,%eax
  102ec5:	ee                   	out    %al,(%dx)
  102ec6:	b1 a0                	mov    $0xa0,%cl
  102ec8:	89 f0                	mov    %esi,%eax
  102eca:	89 ca                	mov    %ecx,%edx
  102ecc:	ee                   	out    %al,(%dx)
  102ecd:	b8 28 00 00 00       	mov    $0x28,%eax
  102ed2:	89 da                	mov    %ebx,%edx
  102ed4:	ee                   	out    %al,(%dx)
  102ed5:	b8 02 00 00 00       	mov    $0x2,%eax
  102eda:	ee                   	out    %al,(%dx)
  102edb:	89 f8                	mov    %edi,%eax
  102edd:	ee                   	out    %al,(%dx)
  102ede:	be 68 00 00 00       	mov    $0x68,%esi
  102ee3:	b2 20                	mov    $0x20,%dl
  102ee5:	89 f0                	mov    %esi,%eax
  102ee7:	ee                   	out    %al,(%dx)
  102ee8:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102eed:	89 d8                	mov    %ebx,%eax
  102eef:	ee                   	out    %al,(%dx)
  102ef0:	89 f0                	mov    %esi,%eax
  102ef2:	89 ca                	mov    %ecx,%edx
  102ef4:	ee                   	out    %al,(%dx)
  102ef5:	89 d8                	mov    %ebx,%eax
  102ef7:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102ef8:	0f b7 05 c0 81 10 00 	movzwl 0x1081c0,%eax
  102eff:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102f03:	74 0a                	je     102f0f <pic_init+0x8f>
  102f05:	b2 21                	mov    $0x21,%dl
  102f07:	ee                   	out    %al,(%dx)
  102f08:	66 c1 e8 08          	shr    $0x8,%ax
  102f0c:	b2 a1                	mov    $0xa1,%dl
  102f0e:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  102f0f:	8b 1c 24             	mov    (%esp),%ebx
  102f12:	8b 74 24 04          	mov    0x4(%esp),%esi
  102f16:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102f1a:	89 ec                	mov    %ebp,%esp
  102f1c:	5d                   	pop    %ebp
  102f1d:	c3                   	ret    
  102f1e:	90                   	nop
  102f1f:	90                   	nop

00102f20 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102f20:	55                   	push   %ebp
  102f21:	89 e5                	mov    %esp,%ebp
  102f23:	57                   	push   %edi
  102f24:	56                   	push   %esi
  102f25:	53                   	push   %ebx
  102f26:	83 ec 2c             	sub    $0x2c,%esp
  102f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102f2c:	8d 73 10             	lea    0x10(%ebx),%esi
  102f2f:	89 34 24             	mov    %esi,(%esp)
  102f32:	e8 49 16 00 00       	call   104580 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102f37:	8b 53 0c             	mov    0xc(%ebx),%edx
  102f3a:	3b 53 08             	cmp    0x8(%ebx),%edx
  102f3d:	75 51                	jne    102f90 <piperead+0x70>
  102f3f:	8b 4b 04             	mov    0x4(%ebx),%ecx
  102f42:	85 c9                	test   %ecx,%ecx
  102f44:	74 4a                	je     102f90 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102f46:	8d 7b 0c             	lea    0xc(%ebx),%edi
  102f49:	eb 20                	jmp    102f6b <piperead+0x4b>
  102f4b:	90                   	nop
  102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102f50:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f54:	89 3c 24             	mov    %edi,(%esp)
  102f57:	e8 94 08 00 00       	call   1037f0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102f5c:	8b 53 0c             	mov    0xc(%ebx),%edx
  102f5f:	3b 53 08             	cmp    0x8(%ebx),%edx
  102f62:	75 2c                	jne    102f90 <piperead+0x70>
  102f64:	8b 43 04             	mov    0x4(%ebx),%eax
  102f67:	85 c0                	test   %eax,%eax
  102f69:	74 25                	je     102f90 <piperead+0x70>
    if(cp->killed){
  102f6b:	e8 d0 05 00 00       	call   103540 <curproc>
  102f70:	8b 40 1c             	mov    0x1c(%eax),%eax
  102f73:	85 c0                	test   %eax,%eax
  102f75:	74 d9                	je     102f50 <piperead+0x30>
      release(&p->lock);
  102f77:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  102f7c:	89 34 24             	mov    %esi,(%esp)
  102f7f:	e8 bc 15 00 00       	call   104540 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102f84:	83 c4 2c             	add    $0x2c,%esp
  102f87:	89 f8                	mov    %edi,%eax
  102f89:	5b                   	pop    %ebx
  102f8a:	5e                   	pop    %esi
  102f8b:	5f                   	pop    %edi
  102f8c:	5d                   	pop    %ebp
  102f8d:	c3                   	ret    
  102f8e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102f90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102f93:	85 c9                	test   %ecx,%ecx
  102f95:	7e 5a                	jle    102ff1 <piperead+0xd1>
    if(p->readp == p->writep)
  102f97:	31 ff                	xor    %edi,%edi
  102f99:	3b 53 08             	cmp    0x8(%ebx),%edx
  102f9c:	74 53                	je     102ff1 <piperead+0xd1>
  102f9e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  102fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102fa4:	8b 75 10             	mov    0x10(%ebp),%esi
  102fa7:	eb 0c                	jmp    102fb5 <piperead+0x95>
  102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102fb0:	39 53 08             	cmp    %edx,0x8(%ebx)
  102fb3:	74 1c                	je     102fd1 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102fb5:	89 d0                	mov    %edx,%eax
  102fb7:	83 c2 01             	add    $0x1,%edx
  102fba:	25 ff 01 00 00       	and    $0x1ff,%eax
  102fbf:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102fc4:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102fc7:	83 c7 01             	add    $0x1,%edi
  102fca:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102fcc:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102fcf:	7f df                	jg     102fb0 <piperead+0x90>
  102fd1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102fd4:	83 c3 08             	add    $0x8,%ebx
  102fd7:	89 1c 24             	mov    %ebx,(%esp)
  102fda:	e8 61 04 00 00       	call   103440 <wakeup>
  release(&p->lock);
  102fdf:	89 34 24             	mov    %esi,(%esp)
  102fe2:	e8 59 15 00 00       	call   104540 <release>
  return i;
}
  102fe7:	83 c4 2c             	add    $0x2c,%esp
  102fea:	89 f8                	mov    %edi,%eax
  102fec:	5b                   	pop    %ebx
  102fed:	5e                   	pop    %esi
  102fee:	5f                   	pop    %edi
  102fef:	5d                   	pop    %ebp
  102ff0:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102ff1:	31 ff                	xor    %edi,%edi
  102ff3:	eb df                	jmp    102fd4 <piperead+0xb4>
  102ff5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103000 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  103000:	55                   	push   %ebp
  103001:	89 e5                	mov    %esp,%ebp
  103003:	57                   	push   %edi
  103004:	56                   	push   %esi
  103005:	53                   	push   %ebx
  103006:	83 ec 3c             	sub    $0x3c,%esp
  103009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  10300c:	8d 73 10             	lea    0x10(%ebx),%esi
  10300f:	89 34 24             	mov    %esi,(%esp)
  103012:	e8 69 15 00 00       	call   104580 <acquire>
  for(i = 0; i < n; i++){
  103017:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10301a:	85 c9                	test   %ecx,%ecx
  10301c:	0f 8e d0 00 00 00    	jle    1030f2 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103022:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103025:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  103028:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10302b:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  10302e:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  103031:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103038:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  10303b:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103041:	39 c8                	cmp    %ecx,%eax
  103043:	75 66                	jne    1030ab <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  103045:	8b 3b                	mov    (%ebx),%edi
  103047:	85 ff                	test   %edi,%edi
  103049:	74 3e                	je     103089 <pipewrite+0x89>
  10304b:	8b 7d d0             	mov    -0x30(%ebp),%edi
  10304e:	eb 2d                	jmp    10307d <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  103050:	89 3c 24             	mov    %edi,(%esp)
  103053:	e8 e8 03 00 00       	call   103440 <wakeup>
      sleep(&p->writep, &p->lock);
  103058:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10305b:	89 74 24 04          	mov    %esi,0x4(%esp)
  10305f:	89 0c 24             	mov    %ecx,(%esp)
  103062:	e8 89 07 00 00       	call   1037f0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  103067:	8b 53 0c             	mov    0xc(%ebx),%edx
  10306a:	8b 43 08             	mov    0x8(%ebx),%eax
  10306d:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  103073:	39 c8                	cmp    %ecx,%eax
  103075:	75 31                	jne    1030a8 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  103077:	8b 13                	mov    (%ebx),%edx
  103079:	85 d2                	test   %edx,%edx
  10307b:	74 0c                	je     103089 <pipewrite+0x89>
  10307d:	e8 be 04 00 00       	call   103540 <curproc>
  103082:	8b 40 1c             	mov    0x1c(%eax),%eax
  103085:	85 c0                	test   %eax,%eax
  103087:	74 c7                	je     103050 <pipewrite+0x50>
        release(&p->lock);
  103089:	89 34 24             	mov    %esi,(%esp)
  10308c:	e8 af 14 00 00       	call   104540 <release>
  103091:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  103098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10309b:	83 c4 3c             	add    $0x3c,%esp
  10309e:	5b                   	pop    %ebx
  10309f:	5e                   	pop    %esi
  1030a0:	5f                   	pop    %edi
  1030a1:	5d                   	pop    %ebp
  1030a2:	c3                   	ret    
  1030a3:	90                   	nop
  1030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1030a8:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  1030ab:	89 c7                	mov    %eax,%edi
  1030ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1030b0:	83 c0 01             	add    $0x1,%eax
  1030b3:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  1030b9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  1030bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1030bf:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  1030c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1030c6:	89 43 08             	mov    %eax,0x8(%ebx)
  1030c9:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1030cd:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1030d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1030d4:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  1030d7:	0f 8f 5e ff ff ff    	jg     10303b <pipewrite+0x3b>
  1030dd:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  1030e0:	89 3c 24             	mov    %edi,(%esp)
  1030e3:	e8 58 03 00 00       	call   103440 <wakeup>
  release(&p->lock);
  1030e8:	89 34 24             	mov    %esi,(%esp)
  1030eb:	e8 50 14 00 00       	call   104540 <release>
  return i;
  1030f0:	eb a6                	jmp    103098 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  1030f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1030f9:	8d 7b 0c             	lea    0xc(%ebx),%edi
  1030fc:	eb e2                	jmp    1030e0 <pipewrite+0xe0>
  1030fe:	66 90                	xchg   %ax,%ax

00103100 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  103100:	55                   	push   %ebp
  103101:	89 e5                	mov    %esp,%ebp
  103103:	83 ec 28             	sub    $0x28,%esp
  103106:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10310c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10310f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103112:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  103115:	8d 73 10             	lea    0x10(%ebx),%esi
  103118:	89 34 24             	mov    %esi,(%esp)
  10311b:	e8 60 14 00 00       	call   104580 <acquire>
  if(writable){
  103120:	85 ff                	test   %edi,%edi
  103122:	74 34                	je     103158 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  103124:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  103127:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  10312e:	89 04 24             	mov    %eax,(%esp)
  103131:	e8 0a 03 00 00       	call   103440 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  103136:	89 34 24             	mov    %esi,(%esp)
  103139:	e8 02 14 00 00       	call   104540 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  10313e:	8b 3b                	mov    (%ebx),%edi
  103140:	85 ff                	test   %edi,%edi
  103142:	75 07                	jne    10314b <pipeclose+0x4b>
  103144:	8b 73 04             	mov    0x4(%ebx),%esi
  103147:	85 f6                	test   %esi,%esi
  103149:	74 25                	je     103170 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  10314b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10314e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103151:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103154:	89 ec                	mov    %ebp,%esp
  103156:	5d                   	pop    %ebp
  103157:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  103158:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  10315b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  103161:	89 04 24             	mov    %eax,(%esp)
  103164:	e8 d7 02 00 00       	call   103440 <wakeup>
  103169:	eb cb                	jmp    103136 <pipeclose+0x36>
  10316b:	90                   	nop
  10316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103170:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  103173:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103176:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10317d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103180:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103183:	89 ec                	mov    %ebp,%esp
  103185:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103186:	e9 55 f3 ff ff       	jmp    1024e0 <kfree>
  10318b:	90                   	nop
  10318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103190 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103190:	55                   	push   %ebp
  103191:	89 e5                	mov    %esp,%ebp
  103193:	57                   	push   %edi
  103194:	56                   	push   %esi
  103195:	53                   	push   %ebx
  103196:	83 ec 1c             	sub    $0x1c,%esp
  103199:	8b 75 08             	mov    0x8(%ebp),%esi
  10319c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  10319f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  1031a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  1031ab:	e8 a0 de ff ff       	call   101050 <filealloc>
  1031b0:	85 c0                	test   %eax,%eax
  1031b2:	89 06                	mov    %eax,(%esi)
  1031b4:	0f 84 92 00 00 00    	je     10324c <pipealloc+0xbc>
  1031ba:	e8 91 de ff ff       	call   101050 <filealloc>
  1031bf:	85 c0                	test   %eax,%eax
  1031c1:	89 03                	mov    %eax,(%ebx)
  1031c3:	74 73                	je     103238 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  1031c5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1031cc:	e8 4f f2 ff ff       	call   102420 <kalloc>
  1031d1:	85 c0                	test   %eax,%eax
  1031d3:	89 c7                	mov    %eax,%edi
  1031d5:	74 61                	je     103238 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  1031d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  1031dd:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  1031e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  1031eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  1031f2:	8d 40 10             	lea    0x10(%eax),%eax
  1031f5:	89 04 24             	mov    %eax,(%esp)
  1031f8:	c7 44 24 04 20 6c 10 	movl   $0x106c20,0x4(%esp)
  1031ff:	00 
  103200:	e8 bb 11 00 00       	call   1043c0 <initlock>
  (*f0)->type = FD_PIPE;
  103205:	8b 06                	mov    (%esi),%eax
  103207:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  10320d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  103211:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  103215:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  103218:	8b 03                	mov    (%ebx),%eax
  10321a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  103220:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  103224:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  103228:	89 78 0c             	mov    %edi,0xc(%eax)
  10322b:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  10322d:	83 c4 1c             	add    $0x1c,%esp
  103230:	5b                   	pop    %ebx
  103231:	5e                   	pop    %esi
  103232:	5f                   	pop    %edi
  103233:	5d                   	pop    %ebp
  103234:	c3                   	ret    
  103235:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  103238:	8b 06                	mov    (%esi),%eax
  10323a:	85 c0                	test   %eax,%eax
  10323c:	74 0e                	je     10324c <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  10323e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  103244:	89 04 24             	mov    %eax,(%esp)
  103247:	e8 94 de ff ff       	call   1010e0 <fileclose>
  }
  if(*f1){
  10324c:	8b 13                	mov    (%ebx),%edx
  10324e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103253:	85 d2                	test   %edx,%edx
  103255:	74 d6                	je     10322d <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  103257:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  10325d:	89 14 24             	mov    %edx,(%esp)
  103260:	e8 7b de ff ff       	call   1010e0 <fileclose>
  103265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10326a:	eb c1                	jmp    10322d <pipealloc+0x9d>
  10326c:	90                   	nop
  10326d:	90                   	nop
  10326e:	90                   	nop
  10326f:	90                   	nop

00103270 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103270:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103271:	b8 00 e7 10 00       	mov    $0x10e700,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103276:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103278:	3d 00 c0 10 00       	cmp    $0x10c000,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  10327d:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103280:	76 3e                	jbe    1032c0 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  103282:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  103287:	eb 13                	jmp    10329c <wake_lock+0x2c>
  103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103290:	05 9c 00 00 00       	add    $0x9c,%eax
  103295:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  10329a:	74 24                	je     1032c0 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  10329c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1032a0:	75 ee                	jne    103290 <wake_lock+0x20>
  1032a2:	39 50 10             	cmp    %edx,0x10(%eax)
  1032a5:	75 e9                	jne    103290 <wake_lock+0x20>
			p->state = RUNNABLE;
  1032a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1032ae:	05 9c 00 00 00       	add    $0x9c,%eax
  1032b3:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  1032b8:	75 e2                	jne    10329c <wake_lock+0x2c>
  1032ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  1032c0:	5d                   	pop    %ebp
  1032c1:	c3                   	ret    
  1032c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001032d0 <tick>:
  }
}

int
tick(void)
{
  1032d0:	55                   	push   %ebp
return ticks;
}
  1032d1:	a1 80 ef 10 00       	mov    0x10ef80,%eax
  }
}

int
tick(void)
{
  1032d6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1032d8:	5d                   	pop    %ebp
  1032d9:	c3                   	ret    
  1032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001032e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1032e0:	55                   	push   %ebp
  1032e1:	89 e5                	mov    %esp,%ebp
  1032e3:	57                   	push   %edi
  1032e4:	56                   	push   %esi
  1032e5:	53                   	push   %ebx
  1032e6:	bb 0c c0 10 00       	mov    $0x10c00c,%ebx
  1032eb:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1032ee:	8d 7d c0             	lea    -0x40(%ebp),%edi
  1032f1:	eb 50                	jmp    103343 <procdump+0x63>
  1032f3:	90                   	nop
  1032f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1032f8:	8b 04 85 e8 6c 10 00 	mov    0x106ce8(,%eax,4),%eax
  1032ff:	85 c0                	test   %eax,%eax
  103301:	74 4e                	je     103351 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103303:	89 44 24 08          	mov    %eax,0x8(%esp)
  103307:	8b 43 04             	mov    0x4(%ebx),%eax
  10330a:	81 c2 88 00 00 00    	add    $0x88,%edx
  103310:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103314:	c7 04 24 29 6c 10 00 	movl   $0x106c29,(%esp)
  10331b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10331f:	e8 9c d4 ff ff       	call   1007c0 <cprintf>
    if(p->state == SLEEPING){
  103324:	83 3b 02             	cmpl   $0x2,(%ebx)
  103327:	74 2f                	je     103358 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103329:	c7 04 24 d3 6b 10 00 	movl   $0x106bd3,(%esp)
  103330:	e8 8b d4 ff ff       	call   1007c0 <cprintf>
  103335:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  10333b:	81 fb 0c e7 10 00    	cmp    $0x10e70c,%ebx
  103341:	74 55                	je     103398 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  103343:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103345:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  103348:	85 c0                	test   %eax,%eax
  10334a:	74 e9                	je     103335 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  10334c:	83 f8 05             	cmp    $0x5,%eax
  10334f:	76 a7                	jbe    1032f8 <procdump+0x18>
  103351:	b8 25 6c 10 00       	mov    $0x106c25,%eax
  103356:	eb ab                	jmp    103303 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103358:	8b 43 74             	mov    0x74(%ebx),%eax
  10335b:	31 f6                	xor    %esi,%esi
  10335d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103361:	83 c0 08             	add    $0x8,%eax
  103364:	89 04 24             	mov    %eax,(%esp)
  103367:	e8 74 10 00 00       	call   1043e0 <getcallerpcs>
  10336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103370:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103373:	85 c0                	test   %eax,%eax
  103375:	74 b2                	je     103329 <procdump+0x49>
  103377:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  10337a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10337e:	c7 04 24 75 67 10 00 	movl   $0x106775,(%esp)
  103385:	e8 36 d4 ff ff       	call   1007c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10338a:	83 fe 0a             	cmp    $0xa,%esi
  10338d:	75 e1                	jne    103370 <procdump+0x90>
  10338f:	eb 98                	jmp    103329 <procdump+0x49>
  103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103398:	83 c4 4c             	add    $0x4c,%esp
  10339b:	5b                   	pop    %ebx
  10339c:	5e                   	pop    %esi
  10339d:	5f                   	pop    %edi
  10339e:	5d                   	pop    %ebp
  10339f:	90                   	nop
  1033a0:	c3                   	ret    
  1033a1:	eb 0d                	jmp    1033b0 <kill>
  1033a3:	90                   	nop
  1033a4:	90                   	nop
  1033a5:	90                   	nop
  1033a6:	90                   	nop
  1033a7:	90                   	nop
  1033a8:	90                   	nop
  1033a9:	90                   	nop
  1033aa:	90                   	nop
  1033ab:	90                   	nop
  1033ac:	90                   	nop
  1033ad:	90                   	nop
  1033ae:	90                   	nop
  1033af:	90                   	nop

001033b0 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  1033b0:	55                   	push   %ebp
  1033b1:	89 e5                	mov    %esp,%ebp
  1033b3:	53                   	push   %ebx
  1033b4:	83 ec 14             	sub    $0x14,%esp
  1033b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  1033ba:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1033c1:	e8 ba 11 00 00       	call   104580 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  1033c6:	b8 00 e7 10 00       	mov    $0x10e700,%eax
  1033cb:	3d 00 c0 10 00       	cmp    $0x10c000,%eax
  1033d0:	76 56                	jbe    103428 <kill+0x78>
    if(p->pid == pid){
  1033d2:	39 1d 10 c0 10 00    	cmp    %ebx,0x10c010

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  1033d8:	b8 00 c0 10 00       	mov    $0x10c000,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  1033dd:	74 12                	je     1033f1 <kill+0x41>
  1033df:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  1033e0:	05 9c 00 00 00       	add    $0x9c,%eax
  1033e5:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  1033ea:	74 3c                	je     103428 <kill+0x78>
    if(p->pid == pid){
  1033ec:	39 58 10             	cmp    %ebx,0x10(%eax)
  1033ef:	75 ef                	jne    1033e0 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1033f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  1033f5:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1033fc:	74 1a                	je     103418 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1033fe:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103405:	e8 36 11 00 00       	call   104540 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10340a:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10340d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10340f:	5b                   	pop    %ebx
  103410:	5d                   	pop    %ebp
  103411:	c3                   	ret    
  103412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103418:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  10341f:	eb dd                	jmp    1033fe <kill+0x4e>
  103421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103428:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  10342f:	e8 0c 11 00 00       	call   104540 <release>
  return -1;
}
  103434:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  10343c:	5b                   	pop    %ebx
  10343d:	5d                   	pop    %ebp
  10343e:	c3                   	ret    
  10343f:	90                   	nop

00103440 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  103440:	55                   	push   %ebp
  103441:	89 e5                	mov    %esp,%ebp
  103443:	53                   	push   %ebx
  103444:	83 ec 14             	sub    $0x14,%esp
  103447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10344a:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103451:	e8 2a 11 00 00       	call   104580 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103456:	b8 00 e7 10 00       	mov    $0x10e700,%eax
  10345b:	3d 00 c0 10 00       	cmp    $0x10c000,%eax
  103460:	76 3e                	jbe    1034a0 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  103462:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  103467:	eb 13                	jmp    10347c <wakeup+0x3c>
  103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103470:	05 9c 00 00 00       	add    $0x9c,%eax
  103475:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  10347a:	74 24                	je     1034a0 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  10347c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103480:	75 ee                	jne    103470 <wakeup+0x30>
  103482:	3b 58 18             	cmp    0x18(%eax),%ebx
  103485:	75 e9                	jne    103470 <wakeup+0x30>
      p->state = RUNNABLE;
  103487:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10348e:	05 9c 00 00 00       	add    $0x9c,%eax
  103493:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  103498:	75 e2                	jne    10347c <wakeup+0x3c>
  10349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1034a0:	c7 45 08 00 e7 10 00 	movl   $0x10e700,0x8(%ebp)
}
  1034a7:	83 c4 14             	add    $0x14,%esp
  1034aa:	5b                   	pop    %ebx
  1034ab:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1034ac:	e9 8f 10 00 00       	jmp    104540 <release>
  1034b1:	eb 0d                	jmp    1034c0 <allocproc>
  1034b3:	90                   	nop
  1034b4:	90                   	nop
  1034b5:	90                   	nop
  1034b6:	90                   	nop
  1034b7:	90                   	nop
  1034b8:	90                   	nop
  1034b9:	90                   	nop
  1034ba:	90                   	nop
  1034bb:	90                   	nop
  1034bc:	90                   	nop
  1034bd:	90                   	nop
  1034be:	90                   	nop
  1034bf:	90                   	nop

001034c0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1034c0:	55                   	push   %ebp
  1034c1:	89 e5                	mov    %esp,%ebp
  1034c3:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1034c4:	bb 00 c0 10 00       	mov    $0x10c000,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1034c9:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1034cc:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1034d3:	e8 a8 10 00 00       	call   104580 <acquire>
  1034d8:	eb 14                	jmp    1034ee <allocproc+0x2e>
  1034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  1034e0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  1034e6:	81 fb 00 e7 10 00    	cmp    $0x10e700,%ebx
  1034ec:	74 32                	je     103520 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  1034ee:	8b 43 0c             	mov    0xc(%ebx),%eax
  1034f1:	85 c0                	test   %eax,%eax
  1034f3:	75 eb                	jne    1034e0 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  1034f5:	a1 c4 81 10 00       	mov    0x1081c4,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  1034fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103501:	89 43 10             	mov    %eax,0x10(%ebx)
  103504:	83 c0 01             	add    $0x1,%eax
  103507:	a3 c4 81 10 00       	mov    %eax,0x1081c4
      release(&proc_table_lock);
  10350c:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103513:	e8 28 10 00 00       	call   104540 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  103518:	89 d8                	mov    %ebx,%eax
  10351a:	83 c4 14             	add    $0x14,%esp
  10351d:	5b                   	pop    %ebx
  10351e:	5d                   	pop    %ebp
  10351f:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103520:	31 db                	xor    %ebx,%ebx
  103522:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103529:	e8 12 10 00 00       	call   104540 <release>
  return 0;
}
  10352e:	89 d8                	mov    %ebx,%eax
  103530:	83 c4 14             	add    $0x14,%esp
  103533:	5b                   	pop    %ebx
  103534:	5d                   	pop    %ebp
  103535:	c3                   	ret    
  103536:	8d 76 00             	lea    0x0(%esi),%esi
  103539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103540 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103540:	55                   	push   %ebp
  103541:	89 e5                	mov    %esp,%ebp
  103543:	53                   	push   %ebx
  103544:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103547:	e8 64 0f 00 00       	call   1044b0 <pushcli>
  p = cpus[cpu()].curproc;
  10354c:	e8 5f f4 ff ff       	call   1029b0 <cpu>
  103551:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103557:	8b 98 84 b9 10 00    	mov    0x10b984(%eax),%ebx
  popcli();
  10355d:	e8 ce 0e 00 00       	call   104430 <popcli>
  return p;
}
  103562:	83 c4 04             	add    $0x4,%esp
  103565:	89 d8                	mov    %ebx,%eax
  103567:	5b                   	pop    %ebx
  103568:	5d                   	pop    %ebp
  103569:	c3                   	ret    
  10356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103570 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103570:	55                   	push   %ebp
  103571:	89 e5                	mov    %esp,%ebp
  103573:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103576:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  10357d:	e8 be 0f 00 00       	call   104540 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103582:	e8 b9 ff ff ff       	call   103540 <curproc>
  103587:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10358d:	89 04 24             	mov    %eax,(%esp)
  103590:	e8 c7 23 00 00       	call   10595c <forkret1>
}
  103595:	c9                   	leave  
  103596:	c3                   	ret    
  103597:	89 f6                	mov    %esi,%esi
  103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001035a0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1035a0:	55                   	push   %ebp
  1035a1:	89 e5                	mov    %esp,%ebp
  1035a3:	53                   	push   %ebx
  1035a4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1035a7:	9c                   	pushf  
  1035a8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1035a9:	f6 c4 02             	test   $0x2,%ah
  1035ac:	75 5c                	jne    10360a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1035ae:	e8 8d ff ff ff       	call   103540 <curproc>
  1035b3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1035b7:	74 75                	je     10362e <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1035b9:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1035c0:	e8 3b 0f 00 00       	call   104500 <holding>
  1035c5:	85 c0                	test   %eax,%eax
  1035c7:	74 59                	je     103622 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  1035c9:	e8 e2 f3 ff ff       	call   1029b0 <cpu>
  1035ce:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1035d4:	83 b8 44 ba 10 00 01 	cmpl   $0x1,0x10ba44(%eax)
  1035db:	75 39                	jne    103616 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  1035dd:	e8 ce f3 ff ff       	call   1029b0 <cpu>
  1035e2:	89 c3                	mov    %eax,%ebx
  1035e4:	e8 57 ff ff ff       	call   103540 <curproc>
  1035e9:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  1035ef:	81 c3 88 b9 10 00    	add    $0x10b988,%ebx
  1035f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1035f9:	83 c0 64             	add    $0x64,%eax
  1035fc:	89 04 24             	mov    %eax,(%esp)
  1035ff:	e8 e8 11 00 00       	call   1047ec <swtch>
}
  103604:	83 c4 14             	add    $0x14,%esp
  103607:	5b                   	pop    %ebx
  103608:	5d                   	pop    %ebp
  103609:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10360a:	c7 04 24 32 6c 10 00 	movl   $0x106c32,(%esp)
  103611:	e8 4a d3 ff ff       	call   100960 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  103616:	c7 04 24 6a 6c 10 00 	movl   $0x106c6a,(%esp)
  10361d:	e8 3e d3 ff ff       	call   100960 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103622:	c7 04 24 54 6c 10 00 	movl   $0x106c54,(%esp)
  103629:	e8 32 d3 ff ff       	call   100960 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10362e:	c7 04 24 46 6c 10 00 	movl   $0x106c46,(%esp)
  103635:	e8 26 d3 ff ff       	call   100960 <panic>
  10363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103640 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103640:	55                   	push   %ebp
  103641:	89 e5                	mov    %esp,%ebp
  103643:	56                   	push   %esi
  103644:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103645:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103647:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  10364a:	e8 f1 fe ff ff       	call   103540 <curproc>
  10364f:	3b 05 08 87 10 00    	cmp    0x108708,%eax
  103655:	0f 84 36 01 00 00    	je     103791 <exit+0x151>
  10365b:	90                   	nop
  10365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103660:	e8 db fe ff ff       	call   103540 <curproc>
  103665:	8d 73 08             	lea    0x8(%ebx),%esi
  103668:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  10366b:	85 d2                	test   %edx,%edx
  10366d:	74 1c                	je     10368b <exit+0x4b>
      fileclose(cp->ofile[fd]);
  10366f:	e8 cc fe ff ff       	call   103540 <curproc>
  103674:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  103677:	89 04 24             	mov    %eax,(%esp)
  10367a:	e8 61 da ff ff       	call   1010e0 <fileclose>
      cp->ofile[fd] = 0;
  10367f:	e8 bc fe ff ff       	call   103540 <curproc>
  103684:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  10368b:	83 c3 01             	add    $0x1,%ebx
  10368e:	83 fb 10             	cmp    $0x10,%ebx
  103691:	75 cd                	jne    103660 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103693:	e8 a8 fe ff ff       	call   103540 <curproc>
  103698:	8b 40 60             	mov    0x60(%eax),%eax
  10369b:	89 04 24             	mov    %eax,(%esp)
  10369e:	e8 3d e4 ff ff       	call   101ae0 <iput>
  cp->cwd = 0;
  1036a3:	e8 98 fe ff ff       	call   103540 <curproc>
  1036a8:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  1036af:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1036b6:	e8 c5 0e 00 00       	call   104580 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  1036bb:	e8 80 fe ff ff       	call   103540 <curproc>
  1036c0:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1036c3:	b8 00 e7 10 00       	mov    $0x10e700,%eax
  1036c8:	3d 00 c0 10 00       	cmp    $0x10c000,%eax
  1036cd:	0f 86 95 00 00 00    	jbe    103768 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  1036d3:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  1036d8:	eb 12                	jmp    1036ec <exit+0xac>
  1036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1036e0:	05 9c 00 00 00       	add    $0x9c,%eax
  1036e5:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  1036ea:	74 1e                	je     10370a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  1036ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1036f0:	75 ee                	jne    1036e0 <exit+0xa0>
  1036f2:	3b 50 18             	cmp    0x18(%eax),%edx
  1036f5:	75 e9                	jne    1036e0 <exit+0xa0>
      p->state = RUNNABLE;
  1036f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1036fe:	05 9c 00 00 00       	add    $0x9c,%eax
  103703:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  103708:	75 e2                	jne    1036ec <exit+0xac>
  10370a:	bb 00 c0 10 00       	mov    $0x10c000,%ebx
  10370f:	eb 15                	jmp    103726 <exit+0xe6>
  103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103718:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  10371e:	81 fb 00 e7 10 00    	cmp    $0x10e700,%ebx
  103724:	74 42                	je     103768 <exit+0x128>
    if(p->parent == cp){
  103726:	8b 73 14             	mov    0x14(%ebx),%esi
  103729:	e8 12 fe ff ff       	call   103540 <curproc>
  10372e:	39 c6                	cmp    %eax,%esi
  103730:	75 e6                	jne    103718 <exit+0xd8>
      p->parent = initproc;
  103732:	8b 15 08 87 10 00    	mov    0x108708,%edx
      if(p->state == ZOMBIE)
  103738:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10373c:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  10373f:	75 d7                	jne    103718 <exit+0xd8>
  103741:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  103746:	eb 0c                	jmp    103754 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103748:	05 9c 00 00 00       	add    $0x9c,%eax
  10374d:	3d 00 e7 10 00       	cmp    $0x10e700,%eax
  103752:	74 c4                	je     103718 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  103754:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103758:	75 ee                	jne    103748 <exit+0x108>
  10375a:	3b 50 18             	cmp    0x18(%eax),%edx
  10375d:	75 e9                	jne    103748 <exit+0x108>
      p->state = RUNNABLE;
  10375f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103766:	eb e0                	jmp    103748 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103768:	e8 d3 fd ff ff       	call   103540 <curproc>
  10376d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  103774:	e8 c7 fd ff ff       	call   103540 <curproc>
  103779:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103780:	e8 1b fe ff ff       	call   1035a0 <sched>
  panic("zombie exit");
  103785:	c7 04 24 83 6c 10 00 	movl   $0x106c83,(%esp)
  10378c:	e8 cf d1 ff ff       	call   100960 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103791:	c7 04 24 76 6c 10 00 	movl   $0x106c76,(%esp)
  103798:	e8 c3 d1 ff ff       	call   100960 <panic>
  10379d:	8d 76 00             	lea    0x0(%esi),%esi

001037a0 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  1037a0:	55                   	push   %ebp
  1037a1:	89 e5                	mov    %esp,%ebp
  1037a3:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  1037a6:	e8 95 fd ff ff       	call   103540 <curproc>
  1037ab:	85 c0                	test   %eax,%eax
  1037ad:	74 2b                	je     1037da <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  1037af:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1037b6:	e8 c5 0d 00 00       	call   104580 <acquire>
  cp->state = SLEEPING;
  1037bb:	e8 80 fd ff ff       	call   103540 <curproc>
  1037c0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  1037c7:	e8 d4 fd ff ff       	call   1035a0 <sched>
	release(&proc_table_lock); 
  1037cc:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1037d3:	e8 68 0d 00 00       	call   104540 <release>
}
  1037d8:	c9                   	leave  
  1037d9:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  1037da:	c7 04 24 8f 6c 10 00 	movl   $0x106c8f,(%esp)
  1037e1:	e8 7a d1 ff ff       	call   100960 <panic>
  1037e6:	8d 76 00             	lea    0x0(%esi),%esi
  1037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001037f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1037f0:	55                   	push   %ebp
  1037f1:	89 e5                	mov    %esp,%ebp
  1037f3:	56                   	push   %esi
  1037f4:	53                   	push   %ebx
  1037f5:	83 ec 10             	sub    $0x10,%esp
  1037f8:	8b 75 08             	mov    0x8(%ebp),%esi
  1037fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1037fe:	e8 3d fd ff ff       	call   103540 <curproc>
  103803:	85 c0                	test   %eax,%eax
  103805:	0f 84 9d 00 00 00    	je     1038a8 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  10380b:	85 db                	test   %ebx,%ebx
  10380d:	0f 84 89 00 00 00    	je     10389c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103813:	81 fb 00 e7 10 00    	cmp    $0x10e700,%ebx
  103819:	74 55                	je     103870 <sleep+0x80>
    acquire(&proc_table_lock);
  10381b:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103822:	e8 59 0d 00 00       	call   104580 <acquire>
    release(lk);
  103827:	89 1c 24             	mov    %ebx,(%esp)
  10382a:	e8 11 0d 00 00       	call   104540 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  10382f:	e8 0c fd ff ff       	call   103540 <curproc>
  103834:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103837:	e8 04 fd ff ff       	call   103540 <curproc>
  10383c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103843:	e8 58 fd ff ff       	call   1035a0 <sched>

  // Tidy up.
  cp->chan = 0;
  103848:	e8 f3 fc ff ff       	call   103540 <curproc>
  10384d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103854:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  10385b:	e8 e0 0c 00 00       	call   104540 <release>
    acquire(lk);
  103860:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103863:	83 c4 10             	add    $0x10,%esp
  103866:	5b                   	pop    %ebx
  103867:	5e                   	pop    %esi
  103868:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103869:	e9 12 0d 00 00       	jmp    104580 <acquire>
  10386e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103870:	e8 cb fc ff ff       	call   103540 <curproc>
  103875:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103878:	e8 c3 fc ff ff       	call   103540 <curproc>
  10387d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103884:	e8 17 fd ff ff       	call   1035a0 <sched>

  // Tidy up.
  cp->chan = 0;
  103889:	e8 b2 fc ff ff       	call   103540 <curproc>
  10388e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103895:	83 c4 10             	add    $0x10,%esp
  103898:	5b                   	pop    %ebx
  103899:	5e                   	pop    %esi
  10389a:	5d                   	pop    %ebp
  10389b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  10389c:	c7 04 24 95 6c 10 00 	movl   $0x106c95,(%esp)
  1038a3:	e8 b8 d0 ff ff       	call   100960 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1038a8:	c7 04 24 8f 6c 10 00 	movl   $0x106c8f,(%esp)
  1038af:	e8 ac d0 ff ff       	call   100960 <panic>
  1038b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1038ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001038c0 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1038c0:	55                   	push   %ebp
  1038c1:	89 e5                	mov    %esp,%ebp
  1038c3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038c4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1038c6:	56                   	push   %esi
  1038c7:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038c8:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1038ca:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038cd:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1038d4:	e8 a7 0c 00 00       	call   104580 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1038d9:	83 fb 3f             	cmp    $0x3f,%ebx
  1038dc:	7e 2f                	jle    10390d <wait_thread+0x4d>
  1038de:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1038e0:	85 ff                	test   %edi,%edi
  1038e2:	74 74                	je     103958 <wait_thread+0x98>
  1038e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038e8:	e8 53 fc ff ff       	call   103540 <curproc>
  1038ed:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1038f0:	85 c9                	test   %ecx,%ecx
  1038f2:	75 64                	jne    103958 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1038f4:	e8 47 fc ff ff       	call   103540 <curproc>
  1038f9:	31 ff                	xor    %edi,%edi
  1038fb:	31 db                	xor    %ebx,%ebx
  1038fd:	c7 44 24 04 00 e7 10 	movl   $0x10e700,0x4(%esp)
  103904:	00 
  103905:	89 04 24             	mov    %eax,(%esp)
  103908:	e8 e3 fe ff ff       	call   1037f0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10390d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103913:	81 c6 00 c0 10 00    	add    $0x10c000,%esi
      if(p->state == UNUSED)
  103919:	8b 46 0c             	mov    0xc(%esi),%eax
  10391c:	85 c0                	test   %eax,%eax
  10391e:	75 10                	jne    103930 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103920:	83 c3 01             	add    $0x1,%ebx
  103923:	83 fb 3f             	cmp    $0x3f,%ebx
  103926:	7e e5                	jle    10390d <wait_thread+0x4d>
  103928:	eb b6                	jmp    1038e0 <wait_thread+0x20>
  10392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103930:	8b 46 14             	mov    0x14(%esi),%eax
  103933:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103936:	e8 05 fc ff ff       	call   103540 <curproc>
  10393b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10393e:	66 90                	xchg   %ax,%ax
  103940:	75 de                	jne    103920 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103942:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103946:	74 29                	je     103971 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103948:	bf 01 00 00 00       	mov    $0x1,%edi
  10394d:	8d 76 00             	lea    0x0(%esi),%esi
  103950:	eb ce                	jmp    103920 <wait_thread+0x60>
  103952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103958:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  10395f:	e8 dc 0b 00 00       	call   104540 <release>
  103964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103969:	83 c4 2c             	add    $0x2c,%esp
  10396c:	5b                   	pop    %ebx
  10396d:	5e                   	pop    %esi
  10396e:	5f                   	pop    %edi
  10396f:	5d                   	pop    %ebp
  103970:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103971:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103978:	00 
  103979:	8b 46 08             	mov    0x8(%esi),%eax
  10397c:	89 04 24             	mov    %eax,(%esp)
  10397f:	e8 5c eb ff ff       	call   1024e0 <kfree>
          pid = p->pid;
  103984:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103987:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10398e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103995:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10399c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1039a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1039a6:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1039ad:	e8 8e 0b 00 00       	call   104540 <release>
          return pid;
  1039b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039b5:	eb b2                	jmp    103969 <wait_thread+0xa9>
  1039b7:	89 f6                	mov    %esi,%esi
  1039b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001039c0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1039c0:	55                   	push   %ebp
  1039c1:	89 e5                	mov    %esp,%ebp
  1039c3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1039c4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1039c6:	56                   	push   %esi
  1039c7:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1039c8:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1039ca:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1039cd:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1039d4:	e8 a7 0b 00 00       	call   104580 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1039d9:	83 fb 3f             	cmp    $0x3f,%ebx
  1039dc:	7e 2f                	jle    103a0d <wait+0x4d>
  1039de:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1039e0:	85 ff                	test   %edi,%edi
  1039e2:	74 74                	je     103a58 <wait+0x98>
  1039e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1039e8:	e8 53 fb ff ff       	call   103540 <curproc>
  1039ed:	8b 50 1c             	mov    0x1c(%eax),%edx
  1039f0:	85 d2                	test   %edx,%edx
  1039f2:	75 64                	jne    103a58 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1039f4:	e8 47 fb ff ff       	call   103540 <curproc>
  1039f9:	31 ff                	xor    %edi,%edi
  1039fb:	31 db                	xor    %ebx,%ebx
  1039fd:	c7 44 24 04 00 e7 10 	movl   $0x10e700,0x4(%esp)
  103a04:	00 
  103a05:	89 04 24             	mov    %eax,(%esp)
  103a08:	e8 e3 fd ff ff       	call   1037f0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103a0d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103a13:	81 c6 00 c0 10 00    	add    $0x10c000,%esi
      if(p->state == UNUSED)
  103a19:	8b 4e 0c             	mov    0xc(%esi),%ecx
  103a1c:	85 c9                	test   %ecx,%ecx
  103a1e:	75 10                	jne    103a30 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a20:	83 c3 01             	add    $0x1,%ebx
  103a23:	83 fb 3f             	cmp    $0x3f,%ebx
  103a26:	7e e5                	jle    103a0d <wait+0x4d>
  103a28:	eb b6                	jmp    1039e0 <wait+0x20>
  103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103a30:	8b 46 14             	mov    0x14(%esi),%eax
  103a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a36:	e8 05 fb ff ff       	call   103540 <curproc>
  103a3b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a3e:	66 90                	xchg   %ax,%ax
  103a40:	75 de                	jne    103a20 <wait+0x60>
        if(p->state == ZOMBIE){
  103a42:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103a46:	74 29                	je     103a71 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103a48:	bf 01 00 00 00       	mov    $0x1,%edi
  103a4d:	8d 76 00             	lea    0x0(%esi),%esi
  103a50:	eb ce                	jmp    103a20 <wait+0x60>
  103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103a58:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103a5f:	e8 dc 0a 00 00       	call   104540 <release>
  103a64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103a69:	83 c4 2c             	add    $0x2c,%esp
  103a6c:	5b                   	pop    %ebx
  103a6d:	5e                   	pop    %esi
  103a6e:	5f                   	pop    %edi
  103a6f:	5d                   	pop    %ebp
  103a70:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103a71:	8b 46 04             	mov    0x4(%esi),%eax
  103a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a78:	8b 06                	mov    (%esi),%eax
  103a7a:	89 04 24             	mov    %eax,(%esp)
  103a7d:	e8 5e ea ff ff       	call   1024e0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103a82:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a89:	00 
  103a8a:	8b 46 08             	mov    0x8(%esi),%eax
  103a8d:	89 04 24             	mov    %eax,(%esp)
  103a90:	e8 4b ea ff ff       	call   1024e0 <kfree>
          pid = p->pid;
  103a95:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103a98:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  103a9f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103aa6:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103aad:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ab7:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103abe:	e8 7d 0a 00 00       	call   104540 <release>
          return pid;
  103ac3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ac6:	eb a1                	jmp    103a69 <wait+0xa9>
  103ac8:	90                   	nop
  103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103ad0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103ad0:	55                   	push   %ebp
  103ad1:	89 e5                	mov    %esp,%ebp
  103ad3:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  103ad6:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103add:	e8 9e 0a 00 00       	call   104580 <acquire>
  cp->state = RUNNABLE;
  103ae2:	e8 59 fa ff ff       	call   103540 <curproc>
  103ae7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103aee:	e8 ad fa ff ff       	call   1035a0 <sched>
  release(&proc_table_lock);
  103af3:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103afa:	e8 41 0a 00 00       	call   104540 <release>
}
  103aff:	c9                   	leave  
  103b00:	c3                   	ret    
  103b01:	eb 0d                	jmp    103b10 <setupsegs>
  103b03:	90                   	nop
  103b04:	90                   	nop
  103b05:	90                   	nop
  103b06:	90                   	nop
  103b07:	90                   	nop
  103b08:	90                   	nop
  103b09:	90                   	nop
  103b0a:	90                   	nop
  103b0b:	90                   	nop
  103b0c:	90                   	nop
  103b0d:	90                   	nop
  103b0e:	90                   	nop
  103b0f:	90                   	nop

00103b10 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103b10:	55                   	push   %ebp
  103b11:	89 e5                	mov    %esp,%ebp
  103b13:	57                   	push   %edi
  103b14:	56                   	push   %esi
  103b15:	53                   	push   %ebx
  103b16:	83 ec 2c             	sub    $0x2c,%esp
  103b19:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103b1c:	e8 8f 09 00 00       	call   1044b0 <pushcli>
  c = &cpus[cpu()];
  103b21:	e8 8a ee ff ff       	call   1029b0 <cpu>
  103b26:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103b2c:	05 80 b9 10 00       	add    $0x10b980,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103b31:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103b33:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103b39:	0f 84 a1 01 00 00    	je     103ce0 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103b3f:	8b 56 08             	mov    0x8(%esi),%edx
  103b42:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103b48:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103b4b:	8d 50 28             	lea    0x28(%eax),%edx
  103b4e:	89 d1                	mov    %edx,%ecx
  103b50:	c1 e9 10             	shr    $0x10,%ecx
  103b53:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103b5a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103b5d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103b5f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103b66:	00 00 00 
  103b69:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103b70:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103b73:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103b7a:	0f 01 
  103b7c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103b83:	00 00 
  103b85:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103b8c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103b93:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103b9a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103ba1:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103ba8:	ff ff 
  103baa:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103bb1:	00 00 
  103bb3:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103bba:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103bc1:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103bc8:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103bcf:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103bd6:	67 00 
  103bd8:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103bde:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103be5:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103beb:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103bf2:	0f 84 b8 00 00 00    	je     103cb0 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103bf8:	8b 16                	mov    (%esi),%edx
  103bfa:	8b 5e 04             	mov    0x4(%esi),%ebx
  103bfd:	89 d6                	mov    %edx,%esi
  103bff:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103c02:	89 d3                	mov    %edx,%ebx
  103c04:	c1 ee 10             	shr    $0x10,%esi
  103c07:	89 cf                	mov    %ecx,%edi
  103c09:	c1 eb 18             	shr    $0x18,%ebx
  103c0c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103c0f:	89 f3                	mov    %esi,%ebx
  103c11:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103c17:	89 cb                	mov    %ecx,%ebx
  103c19:	c1 eb 1c             	shr    $0x1c,%ebx
  103c1c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103c1e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103c21:	83 c9 c0             	or     $0xffffffc0,%ecx
  103c24:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103c2b:	c1 ef 0c             	shr    $0xc,%edi
  103c2e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103c34:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103c38:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103c3f:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103c45:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103c4c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103c52:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103c56:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103c5d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103c5f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103c66:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103c6d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103c73:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103c79:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103c7e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103c84:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103c88:	c1 e8 10             	shr    $0x10,%eax
  103c8b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103c8f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103c92:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103c95:	b8 28 00 00 00       	mov    $0x28,%eax
  103c9a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103c9d:	e8 8e 07 00 00       	call   104430 <popcli>
}
  103ca2:	83 c4 2c             	add    $0x2c,%esp
  103ca5:	5b                   	pop    %ebx
  103ca6:	5e                   	pop    %esi
  103ca7:	5f                   	pop    %edi
  103ca8:	5d                   	pop    %ebp
  103ca9:	c3                   	ret    
  103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103cb0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103cb7:	00 00 00 
  103cba:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103cc1:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103cc4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103ccb:	00 00 00 
  103cce:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103cd5:	00 00 00 
  103cd8:	eb 9f                	jmp    103c79 <setupsegs+0x169>
  103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103ce0:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103ce7:	e9 5f fe ff ff       	jmp    103b4b <setupsegs+0x3b>
  103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103cf0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103cf0:	55                   	push   %ebp
  103cf1:	89 e5                	mov    %esp,%ebp
  103cf3:	57                   	push   %edi
  103cf4:	56                   	push   %esi
  103cf5:	53                   	push   %ebx
  103cf6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103cf9:	e8 b2 ec ff ff       	call   1029b0 <cpu>
  103cfe:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103d04:	81 c3 80 b9 10 00    	add    $0x10b980,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103d0a:	8d 73 08             	lea    0x8(%ebx),%esi
  103d0d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103d10:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103d11:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103d18:	e8 63 08 00 00       	call   104580 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d1d:	83 3d 10 c0 10 00 01 	cmpl   $0x1,0x10c010
  103d24:	0f 84 c6 00 00 00    	je     103df0 <scheduler+0x100>
  103d2a:	31 d2                	xor    %edx,%edx
  103d2c:	31 c0                	xor    %eax,%eax
  103d2e:	eb 0e                	jmp    103d3e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103d30:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103d36:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103d3c:	74 1d                	je     103d5b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103d3e:	83 ba 0c c0 10 00 03 	cmpl   $0x3,0x10c00c(%edx)
  103d45:	75 e9                	jne    103d30 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103d47:	03 82 98 c0 10 00    	add    0x10c098(%edx),%eax
  103d4d:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103d53:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103d59:	75 e3                	jne    103d3e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103d5b:	85 c0                	test   %eax,%eax
  103d5d:	74 16                	je     103d75 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103d5f:	8b 3d 80 ef 10 00    	mov    0x10ef80,%edi
  103d65:	89 c1                	mov    %eax,%ecx
  103d67:	c1 e7 08             	shl    $0x8,%edi
  103d6a:	89 fa                	mov    %edi,%edx
  103d6c:	89 f8                	mov    %edi,%eax
  103d6e:	c1 fa 1f             	sar    $0x1f,%edx
  103d71:	f7 f9                	idiv   %ecx
  103d73:	89 d7                	mov    %edx,%edi
  103d75:	b8 0c c0 10 00       	mov    $0x10c00c,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103d7a:	31 d2                	xor    %edx,%edx
  103d7c:	eb 12                	jmp    103d90 <scheduler+0xa0>
  103d7e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103d80:	39 fa                	cmp    %edi,%edx
  103d82:	7f 1e                	jg     103da2 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103d84:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103d89:	3d 0c e7 10 00       	cmp    $0x10e70c,%eax
  103d8e:	74 4c                	je     103ddc <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103d90:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103d93:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103d96:	75 e8                	jne    103d80 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103d98:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103d9e:	39 fa                	cmp    %edi,%edx
  103da0:	7e e2                	jle    103d84 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103da2:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103da5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103da8:	89 0c 24             	mov    %ecx,(%esp)
  103dab:	e8 60 fd ff ff       	call   103b10 <setupsegs>
    	  p->state = RUNNING;
  103db0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103db3:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103dba:	83 c1 64             	add    $0x64,%ecx
  103dbd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103dc1:	89 34 24             	mov    %esi,(%esp)
  103dc4:	e8 23 0a 00 00       	call   1047ec <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103dc9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103dd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103dd7:	e8 34 fd ff ff       	call   103b10 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103ddc:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103de3:	e8 58 07 00 00       	call   104540 <release>
  103de8:	e9 23 ff ff ff       	jmp    103d10 <scheduler+0x20>
  103ded:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103df0:	83 3d 0c c0 10 00 03 	cmpl   $0x3,0x10c00c
  103df7:	0f 85 2d ff ff ff    	jne    103d2a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103dfd:	c7 43 04 00 c0 10 00 	movl   $0x10c000,0x4(%ebx)
      setupsegs(p);
  103e04:	c7 04 24 00 c0 10 00 	movl   $0x10c000,(%esp)
  103e0b:	e8 00 fd ff ff       	call   103b10 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103e10:	c7 44 24 04 64 c0 10 	movl   $0x10c064,0x4(%esp)
  103e17:	00 
  103e18:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103e1b:	c7 05 98 c0 10 00 4b 	movl   $0x4b,0x10c098
  103e22:	00 00 00 
      p->state = RUNNING;
  103e25:	c7 05 0c c0 10 00 04 	movl   $0x4,0x10c00c
  103e2c:	00 00 00 
      swtch(&c->context, &p->context);
  103e2f:	e8 b8 09 00 00       	call   1047ec <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103e34:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103e3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103e42:	e8 c9 fc ff ff       	call   103b10 <setupsegs>
      release(&proc_table_lock);
  103e47:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  103e4e:	e8 ed 06 00 00       	call   104540 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103e53:	e9 b8 fe ff ff       	jmp    103d10 <scheduler+0x20>
  103e58:	90                   	nop
  103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103e60 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103e60:	55                   	push   %ebp
  103e61:	89 e5                	mov    %esp,%ebp
  103e63:	57                   	push   %edi
  103e64:	56                   	push   %esi
  103e65:	53                   	push   %ebx
  103e66:	83 ec 1c             	sub    $0x1c,%esp
  103e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103e6c:	e8 cf f6 ff ff       	call   103540 <curproc>
  103e71:	8b 50 04             	mov    0x4(%eax),%edx
  103e74:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103e77:	89 04 24             	mov    %eax,(%esp)
  103e7a:	e8 a1 e5 ff ff       	call   102420 <kalloc>
  103e7f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103e86:	85 f6                	test   %esi,%esi
  103e88:	74 7f                	je     103f09 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103e8a:	e8 b1 f6 ff ff       	call   103540 <curproc>
  103e8f:	8b 78 04             	mov    0x4(%eax),%edi
  103e92:	e8 a9 f6 ff ff       	call   103540 <curproc>
  103e97:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103e9b:	8b 00                	mov    (%eax),%eax
  103e9d:	89 34 24             	mov    %esi,(%esp)
  103ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ea4:	e8 d7 07 00 00       	call   104680 <memmove>
  memset(newmem + cp->sz, 0, n);
  103ea9:	e8 92 f6 ff ff       	call   103540 <curproc>
  103eae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103eb9:	00 
  103eba:	8b 50 04             	mov    0x4(%eax),%edx
  103ebd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103ec0:	89 04 24             	mov    %eax,(%esp)
  103ec3:	e8 28 07 00 00       	call   1045f0 <memset>
  kfree(cp->mem, cp->sz);
  103ec8:	e8 73 f6 ff ff       	call   103540 <curproc>
  103ecd:	8b 78 04             	mov    0x4(%eax),%edi
  103ed0:	e8 6b f6 ff ff       	call   103540 <curproc>
  103ed5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103ed9:	8b 00                	mov    (%eax),%eax
  103edb:	89 04 24             	mov    %eax,(%esp)
  103ede:	e8 fd e5 ff ff       	call   1024e0 <kfree>
  cp->mem = newmem;
  103ee3:	e8 58 f6 ff ff       	call   103540 <curproc>
  103ee8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103eea:	e8 51 f6 ff ff       	call   103540 <curproc>
  103eef:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  103ef2:	e8 49 f6 ff ff       	call   103540 <curproc>
  103ef7:	89 04 24             	mov    %eax,(%esp)
  103efa:	e8 11 fc ff ff       	call   103b10 <setupsegs>
  return cp->sz - n;
  103eff:	e8 3c f6 ff ff       	call   103540 <curproc>
  103f04:	8b 40 04             	mov    0x4(%eax),%eax
  103f07:	29 d8                	sub    %ebx,%eax
}
  103f09:	83 c4 1c             	add    $0x1c,%esp
  103f0c:	5b                   	pop    %ebx
  103f0d:	5e                   	pop    %esi
  103f0e:	5f                   	pop    %edi
  103f0f:	5d                   	pop    %ebp
  103f10:	c3                   	ret    
  103f11:	eb 0d                	jmp    103f20 <copyproc_tix>
  103f13:	90                   	nop
  103f14:	90                   	nop
  103f15:	90                   	nop
  103f16:	90                   	nop
  103f17:	90                   	nop
  103f18:	90                   	nop
  103f19:	90                   	nop
  103f1a:	90                   	nop
  103f1b:	90                   	nop
  103f1c:	90                   	nop
  103f1d:	90                   	nop
  103f1e:	90                   	nop
  103f1f:	90                   	nop

00103f20 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103f20:	55                   	push   %ebp
  103f21:	89 e5                	mov    %esp,%ebp
  103f23:	57                   	push   %edi
  103f24:	56                   	push   %esi
  103f25:	53                   	push   %ebx
  103f26:	83 ec 1c             	sub    $0x1c,%esp
  103f29:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103f2c:	e8 8f f5 ff ff       	call   1034c0 <allocproc>
  103f31:	85 c0                	test   %eax,%eax
  103f33:	89 c6                	mov    %eax,%esi
  103f35:	0f 84 e1 00 00 00    	je     10401c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103f3b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103f42:	e8 d9 e4 ff ff       	call   102420 <kalloc>
  103f47:	85 c0                	test   %eax,%eax
  103f49:	89 46 08             	mov    %eax,0x8(%esi)
  103f4c:	0f 84 d4 00 00 00    	je     104026 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f52:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103f57:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f59:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103f5f:	0f 84 85 00 00 00    	je     103fea <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  103f65:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103f68:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103f6b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103f71:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103f78:	00 
  103f79:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103f7f:	89 04 24             	mov    %eax,(%esp)
  103f82:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f86:	e8 f5 06 00 00       	call   104680 <memmove>
  
    np->sz = p->sz;
  103f8b:	8b 47 04             	mov    0x4(%edi),%eax
  103f8e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103f91:	89 04 24             	mov    %eax,(%esp)
  103f94:	e8 87 e4 ff ff       	call   102420 <kalloc>
  103f99:	85 c0                	test   %eax,%eax
  103f9b:	89 06                	mov    %eax,(%esi)
  103f9d:	0f 84 8e 00 00 00    	je     104031 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103fa3:	8b 56 04             	mov    0x4(%esi),%edx
  103fa6:	31 db                	xor    %ebx,%ebx
  103fa8:	89 54 24 08          	mov    %edx,0x8(%esp)
  103fac:	8b 17                	mov    (%edi),%edx
  103fae:	89 04 24             	mov    %eax,(%esp)
  103fb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fb5:	e8 c6 06 00 00       	call   104680 <memmove>
  103fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103fc0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103fc4:	85 c0                	test   %eax,%eax
  103fc6:	74 0c                	je     103fd4 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103fc8:	89 04 24             	mov    %eax,(%esp)
  103fcb:	e8 30 d0 ff ff       	call   101000 <filedup>
  103fd0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103fd4:	83 c3 01             	add    $0x1,%ebx
  103fd7:	83 fb 10             	cmp    $0x10,%ebx
  103fda:	75 e4                	jne    103fc0 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103fdc:	8b 47 60             	mov    0x60(%edi),%eax
  103fdf:	89 04 24             	mov    %eax,(%esp)
  103fe2:	e8 29 d2 ff ff       	call   101210 <idup>
  103fe7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103fea:	8d 46 64             	lea    0x64(%esi),%eax
  103fed:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103ff4:	00 
  103ff5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ffc:	00 
  103ffd:	89 04 24             	mov    %eax,(%esp)
  104000:	e8 eb 05 00 00       	call   1045f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104005:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10400b:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104012:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104015:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10401c:	83 c4 1c             	add    $0x1c,%esp
  10401f:	89 f0                	mov    %esi,%eax
  104021:	5b                   	pop    %ebx
  104022:	5e                   	pop    %esi
  104023:	5f                   	pop    %edi
  104024:	5d                   	pop    %ebp
  104025:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104026:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10402d:	31 f6                	xor    %esi,%esi
    return 0;
  10402f:	eb eb                	jmp    10401c <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104031:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104038:	00 
  104039:	8b 46 08             	mov    0x8(%esi),%eax
  10403c:	89 04 24             	mov    %eax,(%esp)
  10403f:	e8 9c e4 ff ff       	call   1024e0 <kfree>
      np->kstack = 0;
  104044:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10404b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104052:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104059:	31 f6                	xor    %esi,%esi
      return 0;
  10405b:	eb bf                	jmp    10401c <copyproc_tix+0xfc>
  10405d:	8d 76 00             	lea    0x0(%esi),%esi

00104060 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  104060:	55                   	push   %ebp
  104061:	89 e5                	mov    %esp,%ebp
  104063:	57                   	push   %edi
  104064:	56                   	push   %esi
  104065:	53                   	push   %ebx
  104066:	83 ec 1c             	sub    $0x1c,%esp
  104069:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  10406c:	e8 4f f4 ff ff       	call   1034c0 <allocproc>
  104071:	85 c0                	test   %eax,%eax
  104073:	89 c6                	mov    %eax,%esi
  104075:	0f 84 de 00 00 00    	je     104159 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10407b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104082:	e8 99 e3 ff ff       	call   102420 <kalloc>
  104087:	85 c0                	test   %eax,%eax
  104089:	89 46 08             	mov    %eax,0x8(%esi)
  10408c:	0f 84 d1 00 00 00    	je     104163 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104092:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104097:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104099:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10409f:	74 61                	je     104102 <copyproc_threads+0xa2>
    np->parent = p;
  1040a1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  1040a4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  1040a6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1040ad:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1040b0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1040b7:	00 
  1040b8:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  1040be:	89 04 24             	mov    %eax,(%esp)
  1040c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040c5:	e8 b6 05 00 00       	call   104680 <memmove>
  
    np->sz = p->sz;
  1040ca:	8b 47 04             	mov    0x4(%edi),%eax
  1040cd:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  1040d0:	8b 07                	mov    (%edi),%eax
  1040d2:	89 06                	mov    %eax,(%esi)
  1040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1040d8:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1040dc:	85 c0                	test   %eax,%eax
  1040de:	74 0c                	je     1040ec <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  1040e0:	89 04 24             	mov    %eax,(%esp)
  1040e3:	e8 18 cf ff ff       	call   101000 <filedup>
  1040e8:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1040ec:	83 c3 01             	add    $0x1,%ebx
  1040ef:	83 fb 10             	cmp    $0x10,%ebx
  1040f2:	75 e4                	jne    1040d8 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1040f4:	8b 47 60             	mov    0x60(%edi),%eax
  1040f7:	89 04 24             	mov    %eax,(%esp)
  1040fa:	e8 11 d1 ff ff       	call   101210 <idup>
  1040ff:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104102:	8d 46 64             	lea    0x64(%esi),%eax
  104105:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  10410c:	00 
  10410d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104114:	00 
  104115:	89 04 24             	mov    %eax,(%esp)
  104118:	e8 d3 04 00 00       	call   1045f0 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10411d:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104120:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104126:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  10412d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104130:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104133:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104139:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10413c:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  10413f:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104141:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104148:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  10414f:	8b 40 3c             	mov    0x3c(%eax),%eax
  104152:	8b 4d 14             	mov    0x14(%ebp),%ecx
  104155:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  104159:	83 c4 1c             	add    $0x1c,%esp
  10415c:	89 f0                	mov    %esi,%eax
  10415e:	5b                   	pop    %ebx
  10415f:	5e                   	pop    %esi
  104160:	5f                   	pop    %edi
  104161:	5d                   	pop    %ebp
  104162:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104163:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10416a:	31 f6                	xor    %esi,%esi
    return 0;
  10416c:	eb eb                	jmp    104159 <copyproc_threads+0xf9>
  10416e:	66 90                	xchg   %ax,%ax

00104170 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104170:	55                   	push   %ebp
  104171:	89 e5                	mov    %esp,%ebp
  104173:	57                   	push   %edi
  104174:	56                   	push   %esi
  104175:	53                   	push   %ebx
  104176:	83 ec 1c             	sub    $0x1c,%esp
  104179:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10417c:	e8 3f f3 ff ff       	call   1034c0 <allocproc>
  104181:	85 c0                	test   %eax,%eax
  104183:	89 c6                	mov    %eax,%esi
  104185:	0f 84 e1 00 00 00    	je     10426c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10418b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104192:	e8 89 e2 ff ff       	call   102420 <kalloc>
  104197:	85 c0                	test   %eax,%eax
  104199:	89 46 08             	mov    %eax,0x8(%esi)
  10419c:	0f 84 d4 00 00 00    	je     104276 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1041a2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1041a7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1041a9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1041af:	0f 84 85 00 00 00    	je     10423a <copyproc+0xca>
    np->parent = p;
  1041b5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  1041b8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1041bf:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1041c2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1041c9:	00 
  1041ca:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  1041d0:	89 04 24             	mov    %eax,(%esp)
  1041d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041d7:	e8 a4 04 00 00       	call   104680 <memmove>
  
    np->sz = p->sz;
  1041dc:	8b 47 04             	mov    0x4(%edi),%eax
  1041df:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  1041e2:	89 04 24             	mov    %eax,(%esp)
  1041e5:	e8 36 e2 ff ff       	call   102420 <kalloc>
  1041ea:	85 c0                	test   %eax,%eax
  1041ec:	89 06                	mov    %eax,(%esi)
  1041ee:	0f 84 8d 00 00 00    	je     104281 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1041f4:	8b 56 04             	mov    0x4(%esi),%edx
  1041f7:	31 db                	xor    %ebx,%ebx
  1041f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1041fd:	8b 17                	mov    (%edi),%edx
  1041ff:	89 04 24             	mov    %eax,(%esp)
  104202:	89 54 24 04          	mov    %edx,0x4(%esp)
  104206:	e8 75 04 00 00       	call   104680 <memmove>
  10420b:	90                   	nop
  10420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104210:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104214:	85 c0                	test   %eax,%eax
  104216:	74 0c                	je     104224 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104218:	89 04 24             	mov    %eax,(%esp)
  10421b:	e8 e0 cd ff ff       	call   101000 <filedup>
  104220:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104224:	83 c3 01             	add    $0x1,%ebx
  104227:	83 fb 10             	cmp    $0x10,%ebx
  10422a:	75 e4                	jne    104210 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10422c:	8b 47 60             	mov    0x60(%edi),%eax
  10422f:	89 04 24             	mov    %eax,(%esp)
  104232:	e8 d9 cf ff ff       	call   101210 <idup>
  104237:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10423a:	8d 46 64             	lea    0x64(%esi),%eax
  10423d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104244:	00 
  104245:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10424c:	00 
  10424d:	89 04 24             	mov    %eax,(%esp)
  104250:	e8 9b 03 00 00       	call   1045f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104255:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10425b:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104262:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104265:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10426c:	83 c4 1c             	add    $0x1c,%esp
  10426f:	89 f0                	mov    %esi,%eax
  104271:	5b                   	pop    %ebx
  104272:	5e                   	pop    %esi
  104273:	5f                   	pop    %edi
  104274:	5d                   	pop    %ebp
  104275:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104276:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10427d:	31 f6                	xor    %esi,%esi
    return 0;
  10427f:	eb eb                	jmp    10426c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104281:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104288:	00 
  104289:	8b 46 08             	mov    0x8(%esi),%eax
  10428c:	89 04 24             	mov    %eax,(%esp)
  10428f:	e8 4c e2 ff ff       	call   1024e0 <kfree>
      np->kstack = 0;
  104294:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10429b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1042a2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1042a9:	31 f6                	xor    %esi,%esi
      return 0;
  1042ab:	eb bf                	jmp    10426c <copyproc+0xfc>
  1042ad:	8d 76 00             	lea    0x0(%esi),%esi

001042b0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  1042b0:	55                   	push   %ebp
  1042b1:	89 e5                	mov    %esp,%ebp
  1042b3:	53                   	push   %ebx
  1042b4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1042b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1042be:	e8 ad fe ff ff       	call   104170 <copyproc>
  p->sz = PAGE;
  1042c3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1042ca:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  1042cc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1042d3:	e8 48 e1 ff ff       	call   102420 <kalloc>
  1042d8:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  1042da:	c7 04 24 a6 6c 10 00 	movl   $0x106ca6,(%esp)
  1042e1:	e8 6a dd ff ff       	call   102050 <namei>
  1042e6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  1042e9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1042f0:	00 
  1042f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042f8:	00 
  1042f9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  1042ff:	89 04 24             	mov    %eax,(%esp)
  104302:	e8 e9 02 00 00       	call   1045f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104307:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10430d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10430f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104316:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104319:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10431f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104325:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10432b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10432e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104332:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104335:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10433b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104342:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104349:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104350:	00 
  104351:	c7 44 24 04 c8 85 10 	movl   $0x1085c8,0x4(%esp)
  104358:	00 
  104359:	8b 03                	mov    (%ebx),%eax
  10435b:	89 04 24             	mov    %eax,(%esp)
  10435e:	e8 1d 03 00 00       	call   104680 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104363:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104369:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104370:	00 
  104371:	c7 44 24 04 a8 6c 10 	movl   $0x106ca8,0x4(%esp)
  104378:	00 
  104379:	89 04 24             	mov    %eax,(%esp)
  10437c:	e8 0f 04 00 00       	call   104790 <safestrcpy>
  p->state = RUNNABLE;
  104381:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104388:	89 1d 08 87 10 00    	mov    %ebx,0x108708
}
  10438e:	83 c4 14             	add    $0x14,%esp
  104391:	5b                   	pop    %ebx
  104392:	5d                   	pop    %ebp
  104393:	c3                   	ret    
  104394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10439a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001043a0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  1043a0:	55                   	push   %ebp
  1043a1:	89 e5                	mov    %esp,%ebp
  1043a3:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  1043a6:	c7 44 24 04 b1 6c 10 	movl   $0x106cb1,0x4(%esp)
  1043ad:	00 
  1043ae:	c7 04 24 00 e7 10 00 	movl   $0x10e700,(%esp)
  1043b5:	e8 06 00 00 00       	call   1043c0 <initlock>
}
  1043ba:	c9                   	leave  
  1043bb:	c3                   	ret    
  1043bc:	90                   	nop
  1043bd:	90                   	nop
  1043be:	90                   	nop
  1043bf:	90                   	nop

001043c0 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  1043c0:	55                   	push   %ebp
  1043c1:	89 e5                	mov    %esp,%ebp
  1043c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  1043c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  1043c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  1043cf:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  1043d2:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  1043d9:	5d                   	pop    %ebp
  1043da:	c3                   	ret    
  1043db:	90                   	nop
  1043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001043e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1043e0:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1043e1:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1043e3:	89 e5                	mov    %esp,%ebp
  1043e5:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1043e6:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1043e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1043ec:	83 ea 08             	sub    $0x8,%edx
  1043ef:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  1043f0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1043f3:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  1043f6:	77 18                	ja     104410 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  1043f8:	8b 4a 04             	mov    0x4(%edx),%ecx
  1043fb:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1043fe:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104401:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104403:	83 f8 0a             	cmp    $0xa,%eax
  104406:	75 e8                	jne    1043f0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  104408:	5b                   	pop    %ebx
  104409:	5d                   	pop    %ebp
  10440a:	c3                   	ret    
  10440b:	90                   	nop
  10440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104410:	83 f8 09             	cmp    $0x9,%eax
  104413:	7f f3                	jg     104408 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104415:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  104418:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  10441b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104421:	83 c2 04             	add    $0x4,%edx
  104424:	83 f8 0a             	cmp    $0xa,%eax
  104427:	75 ef                	jne    104418 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  104429:	5b                   	pop    %ebx
  10442a:	5d                   	pop    %ebp
  10442b:	c3                   	ret    
  10442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104430 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104436:	9c                   	pushf  
  104437:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104438:	f6 c4 02             	test   $0x2,%ah
  10443b:	75 5f                	jne    10449c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10443d:	e8 6e e5 ff ff       	call   1029b0 <cpu>
  104442:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104448:	05 84 b9 10 00       	add    $0x10b984,%eax
  10444d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104453:	83 ea 01             	sub    $0x1,%edx
  104456:	85 d2                	test   %edx,%edx
  104458:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10445e:	78 30                	js     104490 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104460:	e8 4b e5 ff ff       	call   1029b0 <cpu>
  104465:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10446b:	8b 90 44 ba 10 00    	mov    0x10ba44(%eax),%edx
  104471:	85 d2                	test   %edx,%edx
  104473:	74 03                	je     104478 <popcli+0x48>
    sti();
}
  104475:	c9                   	leave  
  104476:	c3                   	ret    
  104477:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104478:	e8 33 e5 ff ff       	call   1029b0 <cpu>
  10447d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104483:	8b 80 48 ba 10 00    	mov    0x10ba48(%eax),%eax
  104489:	85 c0                	test   %eax,%eax
  10448b:	74 e8                	je     104475 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10448d:	fb                   	sti    
    sti();
}
  10448e:	c9                   	leave  
  10448f:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104490:	c7 04 24 17 6d 10 00 	movl   $0x106d17,(%esp)
  104497:	e8 c4 c4 ff ff       	call   100960 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10449c:	c7 04 24 00 6d 10 00 	movl   $0x106d00,(%esp)
  1044a3:	e8 b8 c4 ff ff       	call   100960 <panic>
  1044a8:	90                   	nop
  1044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001044b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1044b0:	55                   	push   %ebp
  1044b1:	89 e5                	mov    %esp,%ebp
  1044b3:	53                   	push   %ebx
  1044b4:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1044b7:	9c                   	pushf  
  1044b8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1044b9:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  1044ba:	e8 f1 e4 ff ff       	call   1029b0 <cpu>
  1044bf:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1044c5:	05 84 b9 10 00       	add    $0x10b984,%eax
  1044ca:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1044d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  1044d3:	85 d2                	test   %edx,%edx
  1044d5:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  1044db:	75 17                	jne    1044f4 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  1044dd:	e8 ce e4 ff ff       	call   1029b0 <cpu>
  1044e2:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1044e8:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1044ee:	89 98 48 ba 10 00    	mov    %ebx,0x10ba48(%eax)
}
  1044f4:	83 c4 04             	add    $0x4,%esp
  1044f7:	5b                   	pop    %ebx
  1044f8:	5d                   	pop    %ebp
  1044f9:	c3                   	ret    
  1044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104500 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104500:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104501:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104503:	89 e5                	mov    %esp,%ebp
  104505:	53                   	push   %ebx
  104506:	83 ec 04             	sub    $0x4,%esp
  104509:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10450c:	8b 0a                	mov    (%edx),%ecx
  10450e:	85 c9                	test   %ecx,%ecx
  104510:	75 06                	jne    104518 <holding+0x18>
}
  104512:	83 c4 04             	add    $0x4,%esp
  104515:	5b                   	pop    %ebx
  104516:	5d                   	pop    %ebp
  104517:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  104518:	8b 5a 08             	mov    0x8(%edx),%ebx
  10451b:	e8 90 e4 ff ff       	call   1029b0 <cpu>
  104520:	83 c0 0a             	add    $0xa,%eax
  104523:	39 c3                	cmp    %eax,%ebx
  104525:	0f 94 c0             	sete   %al
}
  104528:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  10452b:	0f b6 c0             	movzbl %al,%eax
}
  10452e:	5b                   	pop    %ebx
  10452f:	5d                   	pop    %ebp
  104530:	c3                   	ret    
  104531:	eb 0d                	jmp    104540 <release>
  104533:	90                   	nop
  104534:	90                   	nop
  104535:	90                   	nop
  104536:	90                   	nop
  104537:	90                   	nop
  104538:	90                   	nop
  104539:	90                   	nop
  10453a:	90                   	nop
  10453b:	90                   	nop
  10453c:	90                   	nop
  10453d:	90                   	nop
  10453e:	90                   	nop
  10453f:	90                   	nop

00104540 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  104540:	55                   	push   %ebp
  104541:	89 e5                	mov    %esp,%ebp
  104543:	53                   	push   %ebx
  104544:	83 ec 14             	sub    $0x14,%esp
  104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10454a:	89 1c 24             	mov    %ebx,(%esp)
  10454d:	e8 ae ff ff ff       	call   104500 <holding>
  104552:	85 c0                	test   %eax,%eax
  104554:	74 1d                	je     104573 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104556:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10455d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10455f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104566:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104569:	83 c4 14             	add    $0x14,%esp
  10456c:	5b                   	pop    %ebx
  10456d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10456e:	e9 bd fe ff ff       	jmp    104430 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104573:	c7 04 24 1e 6d 10 00 	movl   $0x106d1e,(%esp)
  10457a:	e8 e1 c3 ff ff       	call   100960 <panic>
  10457f:	90                   	nop

00104580 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104580:	55                   	push   %ebp
  104581:	89 e5                	mov    %esp,%ebp
  104583:	53                   	push   %ebx
  104584:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104587:	e8 24 ff ff ff       	call   1044b0 <pushcli>
  if(holding(lock))
  10458c:	8b 45 08             	mov    0x8(%ebp),%eax
  10458f:	89 04 24             	mov    %eax,(%esp)
  104592:	e8 69 ff ff ff       	call   104500 <holding>
  104597:	85 c0                	test   %eax,%eax
  104599:	75 3d                	jne    1045d8 <acquire+0x58>
    panic("acquire");
  10459b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10459e:	ba 01 00 00 00       	mov    $0x1,%edx
  1045a3:	90                   	nop
  1045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045a8:	89 d0                	mov    %edx,%eax
  1045aa:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1045ad:	83 f8 01             	cmp    $0x1,%eax
  1045b0:	74 f6                	je     1045a8 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1045b2:	e8 f9 e3 ff ff       	call   1029b0 <cpu>
  1045b7:	83 c0 0a             	add    $0xa,%eax
  1045ba:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  1045bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1045c0:	83 c0 0c             	add    $0xc,%eax
  1045c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045c7:	8d 45 08             	lea    0x8(%ebp),%eax
  1045ca:	89 04 24             	mov    %eax,(%esp)
  1045cd:	e8 0e fe ff ff       	call   1043e0 <getcallerpcs>
}
  1045d2:	83 c4 14             	add    $0x14,%esp
  1045d5:	5b                   	pop    %ebx
  1045d6:	5d                   	pop    %ebp
  1045d7:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  1045d8:	c7 04 24 26 6d 10 00 	movl   $0x106d26,(%esp)
  1045df:	e8 7c c3 ff ff       	call   100960 <panic>
  1045e4:	90                   	nop
  1045e5:	90                   	nop
  1045e6:	90                   	nop
  1045e7:	90                   	nop
  1045e8:	90                   	nop
  1045e9:	90                   	nop
  1045ea:	90                   	nop
  1045eb:	90                   	nop
  1045ec:	90                   	nop
  1045ed:	90                   	nop
  1045ee:	90                   	nop
  1045ef:	90                   	nop

001045f0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  1045f0:	55                   	push   %ebp
  1045f1:	89 e5                	mov    %esp,%ebp
  1045f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1045f6:	53                   	push   %ebx
  1045f7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1045fa:	85 c9                	test   %ecx,%ecx
  1045fc:	74 14                	je     104612 <memset+0x22>
  1045fe:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  104602:	31 d2                	xor    %edx,%edx
  104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  104608:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  10460b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10460e:	39 ca                	cmp    %ecx,%edx
  104610:	75 f6                	jne    104608 <memset+0x18>
    *d++ = c;

  return dst;
}
  104612:	5b                   	pop    %ebx
  104613:	5d                   	pop    %ebp
  104614:	c3                   	ret    
  104615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104620 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104620:	55                   	push   %ebp
  104621:	89 e5                	mov    %esp,%ebp
  104623:	57                   	push   %edi
  104624:	56                   	push   %esi
  104625:	53                   	push   %ebx
  104626:	8b 55 10             	mov    0x10(%ebp),%edx
  104629:	8b 75 08             	mov    0x8(%ebp),%esi
  10462c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10462f:	85 d2                	test   %edx,%edx
  104631:	74 2d                	je     104660 <memcmp+0x40>
    if(*s1 != *s2)
  104633:	0f b6 1e             	movzbl (%esi),%ebx
  104636:	0f b6 0f             	movzbl (%edi),%ecx
  104639:	38 cb                	cmp    %cl,%bl
  10463b:	75 2b                	jne    104668 <memcmp+0x48>
      return *s1 - *s2;
  10463d:	83 ea 01             	sub    $0x1,%edx
  104640:	31 c0                	xor    %eax,%eax
  104642:	eb 18                	jmp    10465c <memcmp+0x3c>
  104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104648:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  10464d:	83 ea 01             	sub    $0x1,%edx
  104650:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  104655:	83 c0 01             	add    $0x1,%eax
  104658:	38 cb                	cmp    %cl,%bl
  10465a:	75 0c                	jne    104668 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10465c:	85 d2                	test   %edx,%edx
  10465e:	75 e8                	jne    104648 <memcmp+0x28>
  104660:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104662:	5b                   	pop    %ebx
  104663:	5e                   	pop    %esi
  104664:	5f                   	pop    %edi
  104665:	5d                   	pop    %ebp
  104666:	c3                   	ret    
  104667:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104668:	0f b6 c3             	movzbl %bl,%eax
  10466b:	0f b6 c9             	movzbl %cl,%ecx
  10466e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104670:	5b                   	pop    %ebx
  104671:	5e                   	pop    %esi
  104672:	5f                   	pop    %edi
  104673:	5d                   	pop    %ebp
  104674:	c3                   	ret    
  104675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104680 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	57                   	push   %edi
  104684:	56                   	push   %esi
  104685:	53                   	push   %ebx
  104686:	8b 45 08             	mov    0x8(%ebp),%eax
  104689:	8b 75 0c             	mov    0xc(%ebp),%esi
  10468c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10468f:	39 c6                	cmp    %eax,%esi
  104691:	73 2d                	jae    1046c0 <memmove+0x40>
  104693:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104696:	39 f8                	cmp    %edi,%eax
  104698:	73 26                	jae    1046c0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10469a:	85 db                	test   %ebx,%ebx
  10469c:	74 1d                	je     1046bb <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10469e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  1046a1:	31 d2                	xor    %edx,%edx
  1046a3:	90                   	nop
  1046a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  1046a8:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  1046ad:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  1046b1:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1046b4:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  1046b7:	85 c9                	test   %ecx,%ecx
  1046b9:	75 ed                	jne    1046a8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  1046bb:	5b                   	pop    %ebx
  1046bc:	5e                   	pop    %esi
  1046bd:	5f                   	pop    %edi
  1046be:	5d                   	pop    %ebp
  1046bf:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1046c0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  1046c2:	85 db                	test   %ebx,%ebx
  1046c4:	74 f5                	je     1046bb <memmove+0x3b>
  1046c6:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  1046c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  1046cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1046cf:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  1046d2:	39 d3                	cmp    %edx,%ebx
  1046d4:	75 f2                	jne    1046c8 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  1046d6:	5b                   	pop    %ebx
  1046d7:	5e                   	pop    %esi
  1046d8:	5f                   	pop    %edi
  1046d9:	5d                   	pop    %ebp
  1046da:	c3                   	ret    
  1046db:	90                   	nop
  1046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001046e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  1046e0:	55                   	push   %ebp
  1046e1:	89 e5                	mov    %esp,%ebp
  1046e3:	57                   	push   %edi
  1046e4:	56                   	push   %esi
  1046e5:	53                   	push   %ebx
  1046e6:	8b 7d 10             	mov    0x10(%ebp),%edi
  1046e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1046ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  1046ef:	85 ff                	test   %edi,%edi
  1046f1:	74 3d                	je     104730 <strncmp+0x50>
  1046f3:	0f b6 01             	movzbl (%ecx),%eax
  1046f6:	84 c0                	test   %al,%al
  1046f8:	75 18                	jne    104712 <strncmp+0x32>
  1046fa:	eb 3c                	jmp    104738 <strncmp+0x58>
  1046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104700:	83 ef 01             	sub    $0x1,%edi
  104703:	74 2b                	je     104730 <strncmp+0x50>
    n--, p++, q++;
  104705:	83 c1 01             	add    $0x1,%ecx
  104708:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  10470b:	0f b6 01             	movzbl (%ecx),%eax
  10470e:	84 c0                	test   %al,%al
  104710:	74 26                	je     104738 <strncmp+0x58>
  104712:	0f b6 33             	movzbl (%ebx),%esi
  104715:	89 f2                	mov    %esi,%edx
  104717:	38 d0                	cmp    %dl,%al
  104719:	74 e5                	je     104700 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10471b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  104721:	0f b6 c0             	movzbl %al,%eax
  104724:	29 f0                	sub    %esi,%eax
}
  104726:	5b                   	pop    %ebx
  104727:	5e                   	pop    %esi
  104728:	5f                   	pop    %edi
  104729:	5d                   	pop    %ebp
  10472a:	c3                   	ret    
  10472b:	90                   	nop
  10472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104730:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  104732:	5b                   	pop    %ebx
  104733:	5e                   	pop    %esi
  104734:	5f                   	pop    %edi
  104735:	5d                   	pop    %ebp
  104736:	c3                   	ret    
  104737:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104738:	0f b6 33             	movzbl (%ebx),%esi
  10473b:	eb de                	jmp    10471b <strncmp+0x3b>
  10473d:	8d 76 00             	lea    0x0(%esi),%esi

00104740 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  104740:	55                   	push   %ebp
  104741:	89 e5                	mov    %esp,%ebp
  104743:	8b 45 08             	mov    0x8(%ebp),%eax
  104746:	56                   	push   %esi
  104747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10474a:	53                   	push   %ebx
  10474b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10474e:	89 c3                	mov    %eax,%ebx
  104750:	eb 09                	jmp    10475b <strncpy+0x1b>
  104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104758:	83 c6 01             	add    $0x1,%esi
  10475b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10475e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104761:	85 d2                	test   %edx,%edx
  104763:	7e 0c                	jle    104771 <strncpy+0x31>
  104765:	0f b6 16             	movzbl (%esi),%edx
  104768:	88 13                	mov    %dl,(%ebx)
  10476a:	83 c3 01             	add    $0x1,%ebx
  10476d:	84 d2                	test   %dl,%dl
  10476f:	75 e7                	jne    104758 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104771:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104773:	85 c9                	test   %ecx,%ecx
  104775:	7e 0c                	jle    104783 <strncpy+0x43>
  104777:	90                   	nop
    *s++ = 0;
  104778:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10477c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10477f:	39 ca                	cmp    %ecx,%edx
  104781:	75 f5                	jne    104778 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104783:	5b                   	pop    %ebx
  104784:	5e                   	pop    %esi
  104785:	5d                   	pop    %ebp
  104786:	c3                   	ret    
  104787:	89 f6                	mov    %esi,%esi
  104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104790 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104790:	55                   	push   %ebp
  104791:	89 e5                	mov    %esp,%ebp
  104793:	8b 55 10             	mov    0x10(%ebp),%edx
  104796:	56                   	push   %esi
  104797:	8b 45 08             	mov    0x8(%ebp),%eax
  10479a:	53                   	push   %ebx
  10479b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10479e:	85 d2                	test   %edx,%edx
  1047a0:	7e 1f                	jle    1047c1 <safestrcpy+0x31>
  1047a2:	89 c1                	mov    %eax,%ecx
  1047a4:	eb 05                	jmp    1047ab <safestrcpy+0x1b>
  1047a6:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1047a8:	83 c6 01             	add    $0x1,%esi
  1047ab:	83 ea 01             	sub    $0x1,%edx
  1047ae:	85 d2                	test   %edx,%edx
  1047b0:	7e 0c                	jle    1047be <safestrcpy+0x2e>
  1047b2:	0f b6 1e             	movzbl (%esi),%ebx
  1047b5:	88 19                	mov    %bl,(%ecx)
  1047b7:	83 c1 01             	add    $0x1,%ecx
  1047ba:	84 db                	test   %bl,%bl
  1047bc:	75 ea                	jne    1047a8 <safestrcpy+0x18>
    ;
  *s = 0;
  1047be:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  1047c1:	5b                   	pop    %ebx
  1047c2:	5e                   	pop    %esi
  1047c3:	5d                   	pop    %ebp
  1047c4:	c3                   	ret    
  1047c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001047d0 <strlen>:

int
strlen(const char *s)
{
  1047d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  1047d1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  1047d3:	89 e5                	mov    %esp,%ebp
  1047d5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  1047d8:	80 3a 00             	cmpb   $0x0,(%edx)
  1047db:	74 0c                	je     1047e9 <strlen+0x19>
  1047dd:	8d 76 00             	lea    0x0(%esi),%esi
  1047e0:	83 c0 01             	add    $0x1,%eax
  1047e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1047e7:	75 f7                	jne    1047e0 <strlen+0x10>
    ;
  return n;
}
  1047e9:	5d                   	pop    %ebp
  1047ea:	c3                   	ret    
  1047eb:	90                   	nop

001047ec <swtch>:
  1047ec:	8b 44 24 04          	mov    0x4(%esp),%eax
  1047f0:	8f 00                	popl   (%eax)
  1047f2:	89 60 04             	mov    %esp,0x4(%eax)
  1047f5:	89 58 08             	mov    %ebx,0x8(%eax)
  1047f8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1047fb:	89 50 10             	mov    %edx,0x10(%eax)
  1047fe:	89 70 14             	mov    %esi,0x14(%eax)
  104801:	89 78 18             	mov    %edi,0x18(%eax)
  104804:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104807:	8b 44 24 04          	mov    0x4(%esp),%eax
  10480b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10480e:	8b 78 18             	mov    0x18(%eax),%edi
  104811:	8b 70 14             	mov    0x14(%eax),%esi
  104814:	8b 50 10             	mov    0x10(%eax),%edx
  104817:	8b 48 0c             	mov    0xc(%eax),%ecx
  10481a:	8b 58 08             	mov    0x8(%eax),%ebx
  10481d:	8b 60 04             	mov    0x4(%eax),%esp
  104820:	ff 30                	pushl  (%eax)
  104822:	c3                   	ret    
  104823:	90                   	nop
  104824:	90                   	nop
  104825:	90                   	nop
  104826:	90                   	nop
  104827:	90                   	nop
  104828:	90                   	nop
  104829:	90                   	nop
  10482a:	90                   	nop
  10482b:	90                   	nop
  10482c:	90                   	nop
  10482d:	90                   	nop
  10482e:	90                   	nop
  10482f:	90                   	nop

00104830 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104830:	55                   	push   %ebp
  104831:	89 e5                	mov    %esp,%ebp
  104833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104836:	53                   	push   %ebx
  104837:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  10483a:	8b 51 04             	mov    0x4(%ecx),%edx
  10483d:	39 c2                	cmp    %eax,%edx
  10483f:	77 0f                	ja     104850 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104846:	5b                   	pop    %ebx
  104847:	5d                   	pop    %ebp
  104848:	c3                   	ret    
  104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104850:	8d 58 04             	lea    0x4(%eax),%ebx
  104853:	39 da                	cmp    %ebx,%edx
  104855:	72 ea                	jb     104841 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104857:	8b 11                	mov    (%ecx),%edx
  104859:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10485c:	8b 45 10             	mov    0x10(%ebp),%eax
  10485f:	89 10                	mov    %edx,(%eax)
  104861:	31 c0                	xor    %eax,%eax
  return 0;
  104863:	eb e1                	jmp    104846 <fetchint+0x16>
  104865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104870 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104870:	55                   	push   %ebp
  104871:	89 e5                	mov    %esp,%ebp
  104873:	8b 45 08             	mov    0x8(%ebp),%eax
  104876:	8b 55 0c             	mov    0xc(%ebp),%edx
  104879:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10487a:	39 50 04             	cmp    %edx,0x4(%eax)
  10487d:	77 09                	ja     104888 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10487f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104884:	5b                   	pop    %ebx
  104885:	5d                   	pop    %ebp
  104886:	c3                   	ret    
  104887:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10488b:	03 10                	add    (%eax),%edx
  10488d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  10488f:	8b 18                	mov    (%eax),%ebx
  104891:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104894:	39 da                	cmp    %ebx,%edx
  104896:	73 e7                	jae    10487f <fetchstr+0xf>
    if(*s == 0)
  104898:	31 c0                	xor    %eax,%eax
  10489a:	89 d1                	mov    %edx,%ecx
  10489c:	80 3a 00             	cmpb   $0x0,(%edx)
  10489f:	74 e3                	je     104884 <fetchstr+0x14>
  1048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1048a8:	83 c1 01             	add    $0x1,%ecx
  1048ab:	39 cb                	cmp    %ecx,%ebx
  1048ad:	76 d0                	jbe    10487f <fetchstr+0xf>
    if(*s == 0)
  1048af:	80 39 00             	cmpb   $0x0,(%ecx)
  1048b2:	75 f4                	jne    1048a8 <fetchstr+0x38>
  1048b4:	89 c8                	mov    %ecx,%eax
  1048b6:	29 d0                	sub    %edx,%eax
  1048b8:	eb ca                	jmp    104884 <fetchstr+0x14>
  1048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001048c0 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1048c0:	55                   	push   %ebp
  1048c1:	89 e5                	mov    %esp,%ebp
  1048c3:	53                   	push   %ebx
  1048c4:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1048c7:	e8 74 ec ff ff       	call   103540 <curproc>
  1048cc:	8b 55 08             	mov    0x8(%ebp),%edx
  1048cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1048d5:	8b 40 3c             	mov    0x3c(%eax),%eax
  1048d8:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  1048dc:	e8 5f ec ff ff       	call   103540 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1048e1:	8b 50 04             	mov    0x4(%eax),%edx
  1048e4:	39 d3                	cmp    %edx,%ebx
  1048e6:	72 10                	jb     1048f8 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1048e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  1048ed:	83 c4 04             	add    $0x4,%esp
  1048f0:	5b                   	pop    %ebx
  1048f1:	5d                   	pop    %ebp
  1048f2:	c3                   	ret    
  1048f3:	90                   	nop
  1048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1048f8:	8d 4b 04             	lea    0x4(%ebx),%ecx
  1048fb:	39 ca                	cmp    %ecx,%edx
  1048fd:	72 e9                	jb     1048e8 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1048ff:	8b 00                	mov    (%eax),%eax
  104901:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104904:	8b 45 0c             	mov    0xc(%ebp),%eax
  104907:	89 10                	mov    %edx,(%eax)
  104909:	31 c0                	xor    %eax,%eax
  10490b:	eb e0                	jmp    1048ed <argint+0x2d>
  10490d:	8d 76 00             	lea    0x0(%esi),%esi

00104910 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104910:	55                   	push   %ebp
  104911:	89 e5                	mov    %esp,%ebp
  104913:	53                   	push   %ebx
  104914:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104917:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10491a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10491e:	8b 45 08             	mov    0x8(%ebp),%eax
  104921:	89 04 24             	mov    %eax,(%esp)
  104924:	e8 97 ff ff ff       	call   1048c0 <argint>
  104929:	85 c0                	test   %eax,%eax
  10492b:	78 3b                	js     104968 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  10492d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104930:	e8 0b ec ff ff       	call   103540 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104935:	3b 58 04             	cmp    0x4(%eax),%ebx
  104938:	73 2e                	jae    104968 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  10493a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10493d:	03 18                	add    (%eax),%ebx
  10493f:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104941:	8b 08                	mov    (%eax),%ecx
  104943:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104946:	39 cb                	cmp    %ecx,%ebx
  104948:	73 1e                	jae    104968 <argstr+0x58>
    if(*s == 0)
  10494a:	31 c0                	xor    %eax,%eax
  10494c:	89 da                	mov    %ebx,%edx
  10494e:	80 3b 00             	cmpb   $0x0,(%ebx)
  104951:	75 0a                	jne    10495d <argstr+0x4d>
  104953:	eb 18                	jmp    10496d <argstr+0x5d>
  104955:	8d 76 00             	lea    0x0(%esi),%esi
  104958:	80 3a 00             	cmpb   $0x0,(%edx)
  10495b:	74 1b                	je     104978 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10495d:	83 c2 01             	add    $0x1,%edx
  104960:	39 d1                	cmp    %edx,%ecx
  104962:	77 f4                	ja     104958 <argstr+0x48>
  104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10496d:	83 c4 24             	add    $0x24,%esp
  104970:	5b                   	pop    %ebx
  104971:	5d                   	pop    %ebp
  104972:	c3                   	ret    
  104973:	90                   	nop
  104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104978:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10497a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10497d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10497f:	5b                   	pop    %ebx
  104980:	5d                   	pop    %ebp
  104981:	c3                   	ret    
  104982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104990 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104990:	55                   	push   %ebp
  104991:	89 e5                	mov    %esp,%ebp
  104993:	53                   	push   %ebx
  104994:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104997:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10499a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10499e:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a1:	89 04 24             	mov    %eax,(%esp)
  1049a4:	e8 17 ff ff ff       	call   1048c0 <argint>
  1049a9:	85 c0                	test   %eax,%eax
  1049ab:	79 0b                	jns    1049b8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1049ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1049b2:	83 c4 24             	add    $0x24,%esp
  1049b5:	5b                   	pop    %ebx
  1049b6:	5d                   	pop    %ebp
  1049b7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1049b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1049bb:	e8 80 eb ff ff       	call   103540 <curproc>
  1049c0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1049c3:	73 e8                	jae    1049ad <argptr+0x1d>
  1049c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1049c8:	03 5d f4             	add    -0xc(%ebp),%ebx
  1049cb:	e8 70 eb ff ff       	call   103540 <curproc>
  1049d0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1049d3:	73 d8                	jae    1049ad <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1049d5:	e8 66 eb ff ff       	call   103540 <curproc>
  1049da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1049dd:	8b 00                	mov    (%eax),%eax
  1049df:	03 45 f4             	add    -0xc(%ebp),%eax
  1049e2:	89 02                	mov    %eax,(%edx)
  1049e4:	31 c0                	xor    %eax,%eax
  return 0;
  1049e6:	eb ca                	jmp    1049b2 <argptr+0x22>
  1049e8:	90                   	nop
  1049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001049f0 <syscall>:
[SYS_check]			sys_check,
};

void
syscall(void)
{
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	83 ec 18             	sub    $0x18,%esp
  1049f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1049f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1049fc:	e8 3f eb ff ff       	call   103540 <curproc>
  104a01:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a07:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104a0a:	83 fb 1b             	cmp    $0x1b,%ebx
  104a0d:	77 29                	ja     104a38 <syscall+0x48>
  104a0f:	8b 34 9d 60 6d 10 00 	mov    0x106d60(,%ebx,4),%esi
  104a16:	85 f6                	test   %esi,%esi
  104a18:	74 1e                	je     104a38 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  104a1a:	e8 21 eb ff ff       	call   103540 <curproc>
  104a1f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104a25:	ff d6                	call   *%esi
  104a27:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104a2a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a2d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a30:	89 ec                	mov    %ebp,%esp
  104a32:	5d                   	pop    %ebp
  104a33:	c3                   	ret    
  104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104a38:	e8 03 eb ff ff       	call   103540 <curproc>
  104a3d:	89 c6                	mov    %eax,%esi
  104a3f:	e8 fc ea ff ff       	call   103540 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104a44:	81 c6 88 00 00 00    	add    $0x88,%esi
  104a4a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104a4e:	89 74 24 08          	mov    %esi,0x8(%esp)
  104a52:	8b 40 10             	mov    0x10(%eax),%eax
  104a55:	c7 04 24 2e 6d 10 00 	movl   $0x106d2e,(%esp)
  104a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a60:	e8 5b bd ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104a65:	e8 d6 ea ff ff       	call   103540 <curproc>
  104a6a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104a77:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a7a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a7d:	89 ec                	mov    %ebp,%esp
  104a7f:	5d                   	pop    %ebp
  104a80:	c3                   	ret    
  104a81:	90                   	nop
  104a82:	90                   	nop
  104a83:	90                   	nop
  104a84:	90                   	nop
  104a85:	90                   	nop
  104a86:	90                   	nop
  104a87:	90                   	nop
  104a88:	90                   	nop
  104a89:	90                   	nop
  104a8a:	90                   	nop
  104a8b:	90                   	nop
  104a8c:	90                   	nop
  104a8d:	90                   	nop
  104a8e:	90                   	nop
  104a8f:	90                   	nop

00104a90 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104a90:	55                   	push   %ebp
  104a91:	89 e5                	mov    %esp,%ebp
  104a93:	57                   	push   %edi
  104a94:	89 c7                	mov    %eax,%edi
  104a96:	56                   	push   %esi
  104a97:	53                   	push   %ebx
  104a98:	31 db                	xor    %ebx,%ebx
  104a9a:	83 ec 0c             	sub    $0xc,%esp
  104a9d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104aa0:	e8 9b ea ff ff       	call   103540 <curproc>
  104aa5:	8d 73 08             	lea    0x8(%ebx),%esi
  104aa8:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  104aab:	85 c0                	test   %eax,%eax
  104aad:	74 19                	je     104ac8 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104aaf:	83 c3 01             	add    $0x1,%ebx
  104ab2:	83 fb 10             	cmp    $0x10,%ebx
  104ab5:	75 e9                	jne    104aa0 <fdalloc+0x10>
  104ab7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104abc:	83 c4 0c             	add    $0xc,%esp
  104abf:	89 d8                	mov    %ebx,%eax
  104ac1:	5b                   	pop    %ebx
  104ac2:	5e                   	pop    %esi
  104ac3:	5f                   	pop    %edi
  104ac4:	5d                   	pop    %ebp
  104ac5:	c3                   	ret    
  104ac6:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104ac8:	e8 73 ea ff ff       	call   103540 <curproc>
  104acd:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  104ad0:	83 c4 0c             	add    $0xc,%esp
  104ad3:	89 d8                	mov    %ebx,%eax
  104ad5:	5b                   	pop    %ebx
  104ad6:	5e                   	pop    %esi
  104ad7:	5f                   	pop    %edi
  104ad8:	5d                   	pop    %ebp
  104ad9:	c3                   	ret    
  104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104ae0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104ae0:	55                   	push   %ebp
  104ae1:	89 e5                	mov    %esp,%ebp
  104ae3:	53                   	push   %ebx
  104ae4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104ae7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104aea:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104af1:	00 
  104af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104af6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104afd:	e8 8e fe ff ff       	call   104990 <argptr>
  104b02:	85 c0                	test   %eax,%eax
  104b04:	79 12                	jns    104b18 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b0b:	83 c4 24             	add    $0x24,%esp
  104b0e:	5b                   	pop    %ebx
  104b0f:	5d                   	pop    %ebp
  104b10:	c3                   	ret    
  104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104b18:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b1f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104b22:	89 04 24             	mov    %eax,(%esp)
  104b25:	e8 66 e6 ff ff       	call   103190 <pipealloc>
  104b2a:	85 c0                	test   %eax,%eax
  104b2c:	78 d8                	js     104b06 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b31:	e8 5a ff ff ff       	call   104a90 <fdalloc>
  104b36:	85 c0                	test   %eax,%eax
  104b38:	89 c3                	mov    %eax,%ebx
  104b3a:	78 25                	js     104b61 <sys_pipe+0x81>
  104b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b3f:	e8 4c ff ff ff       	call   104a90 <fdalloc>
  104b44:	85 c0                	test   %eax,%eax
  104b46:	78 0c                	js     104b54 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  104b4b:	89 42 04             	mov    %eax,0x4(%edx)
  104b4e:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104b50:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104b52:	eb b7                	jmp    104b0b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104b54:	e8 e7 e9 ff ff       	call   103540 <curproc>
  104b59:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104b60:	00 
    fileclose(rf);
  104b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b64:	89 04 24             	mov    %eax,(%esp)
  104b67:	e8 74 c5 ff ff       	call   1010e0 <fileclose>
    fileclose(wf);
  104b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b6f:	89 04 24             	mov    %eax,(%esp)
  104b72:	e8 69 c5 ff ff       	call   1010e0 <fileclose>
  104b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104b7c:	eb 8d                	jmp    104b0b <sys_pipe+0x2b>
  104b7e:	66 90                	xchg   %ax,%ax

00104b80 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104b80:	55                   	push   %ebp
  104b81:	89 e5                	mov    %esp,%ebp
  104b83:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104b89:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104b8c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b8f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b92:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ba0:	e8 6b fd ff ff       	call   104910 <argstr>
  104ba5:	85 c0                	test   %eax,%eax
  104ba7:	79 17                	jns    104bc0 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104bae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104bb1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104bb4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104bb7:	89 ec                	mov    %ebp,%esp
  104bb9:	5d                   	pop    %ebp
  104bba:	c3                   	ret    
  104bbb:	90                   	nop
  104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104bc0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bce:	e8 ed fc ff ff       	call   1048c0 <argint>
  104bd3:	85 c0                	test   %eax,%eax
  104bd5:	78 d2                	js     104ba9 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  104bd7:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104bda:	31 ff                	xor    %edi,%edi
  104bdc:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104be3:	00 
  104be4:	31 db                	xor    %ebx,%ebx
  104be6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104bed:	00 
  104bee:	89 04 24             	mov    %eax,(%esp)
  104bf1:	e8 fa f9 ff ff       	call   1045f0 <memset>
  104bf6:	eb 27                	jmp    104c1f <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104bf8:	e8 43 e9 ff ff       	call   103540 <curproc>
  104bfd:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104c01:	89 54 24 08          	mov    %edx,0x8(%esp)
  104c05:	89 74 24 04          	mov    %esi,0x4(%esp)
  104c09:	89 04 24             	mov    %eax,(%esp)
  104c0c:	e8 5f fc ff ff       	call   104870 <fetchstr>
  104c11:	85 c0                	test   %eax,%eax
  104c13:	78 94                	js     104ba9 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104c15:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104c18:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104c1b:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  104c1d:	74 8a                	je     104ba9 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104c1f:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104c26:	03 75 e0             	add    -0x20(%ebp),%esi
  104c29:	e8 12 e9 ff ff       	call   103540 <curproc>
  104c2e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104c31:	89 54 24 08          	mov    %edx,0x8(%esp)
  104c35:	89 74 24 04          	mov    %esi,0x4(%esp)
  104c39:	89 04 24             	mov    %eax,(%esp)
  104c3c:	e8 ef fb ff ff       	call   104830 <fetchint>
  104c41:	85 c0                	test   %eax,%eax
  104c43:	0f 88 60 ff ff ff    	js     104ba9 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104c49:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104c4c:	85 f6                	test   %esi,%esi
  104c4e:	75 a8                	jne    104bf8 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104c50:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104c5a:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104c61:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104c62:	89 04 24             	mov    %eax,(%esp)
  104c65:	e8 76 bd ff ff       	call   1009e0 <exec>
  104c6a:	e9 3f ff ff ff       	jmp    104bae <sys_exec+0x2e>
  104c6f:	90                   	nop

00104c70 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104c70:	55                   	push   %ebp
  104c71:	89 e5                	mov    %esp,%ebp
  104c73:	53                   	push   %ebx
  104c74:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c85:	e8 86 fc ff ff       	call   104910 <argstr>
  104c8a:	85 c0                	test   %eax,%eax
  104c8c:	79 12                	jns    104ca0 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c93:	83 c4 24             	add    $0x24,%esp
  104c96:	5b                   	pop    %ebx
  104c97:	5d                   	pop    %ebp
  104c98:	c3                   	ret    
  104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ca3:	89 04 24             	mov    %eax,(%esp)
  104ca6:	e8 a5 d3 ff ff       	call   102050 <namei>
  104cab:	85 c0                	test   %eax,%eax
  104cad:	89 c3                	mov    %eax,%ebx
  104caf:	74 dd                	je     104c8e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104cb1:	89 04 24             	mov    %eax,(%esp)
  104cb4:	e8 d7 d0 ff ff       	call   101d90 <ilock>
  if(ip->type != T_DIR){
  104cb9:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104cbe:	75 24                	jne    104ce4 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104cc0:	89 1c 24             	mov    %ebx,(%esp)
  104cc3:	e8 58 d0 ff ff       	call   101d20 <iunlock>
  iput(cp->cwd);
  104cc8:	e8 73 e8 ff ff       	call   103540 <curproc>
  104ccd:	8b 40 60             	mov    0x60(%eax),%eax
  104cd0:	89 04 24             	mov    %eax,(%esp)
  104cd3:	e8 08 ce ff ff       	call   101ae0 <iput>
  cp->cwd = ip;
  104cd8:	e8 63 e8 ff ff       	call   103540 <curproc>
  104cdd:	89 58 60             	mov    %ebx,0x60(%eax)
  104ce0:	31 c0                	xor    %eax,%eax
  return 0;
  104ce2:	eb af                	jmp    104c93 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104ce4:	89 1c 24             	mov    %ebx,(%esp)
  104ce7:	e8 84 d0 ff ff       	call   101d70 <iunlockput>
  104cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104cf1:	eb a0                	jmp    104c93 <sys_chdir+0x23>
  104cf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d00 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104d00:	55                   	push   %ebp
  104d01:	89 e5                	mov    %esp,%ebp
  104d03:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104d06:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104d09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104d0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104d0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104d12:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d1d:	e8 ee fb ff ff       	call   104910 <argstr>
  104d22:	85 c0                	test   %eax,%eax
  104d24:	79 12                	jns    104d38 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104d26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d2b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d2e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104d31:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104d34:	89 ec                	mov    %ebp,%esp
  104d36:	5d                   	pop    %ebp
  104d37:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104d38:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d46:	e8 c5 fb ff ff       	call   104910 <argstr>
  104d4b:	85 c0                	test   %eax,%eax
  104d4d:	78 d7                	js     104d26 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d52:	89 04 24             	mov    %eax,(%esp)
  104d55:	e8 f6 d2 ff ff       	call   102050 <namei>
  104d5a:	85 c0                	test   %eax,%eax
  104d5c:	89 c3                	mov    %eax,%ebx
  104d5e:	74 c6                	je     104d26 <sys_link+0x26>
    return -1;
  ilock(ip);
  104d60:	89 04 24             	mov    %eax,(%esp)
  104d63:	e8 28 d0 ff ff       	call   101d90 <ilock>
  if(ip->type == T_DIR){
  104d68:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104d6d:	0f 84 86 00 00 00    	je     104df9 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104d73:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104d78:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104d7b:	89 1c 24             	mov    %ebx,(%esp)
  104d7e:	e8 8d c8 ff ff       	call   101610 <iupdate>
  iunlock(ip);
  104d83:	89 1c 24             	mov    %ebx,(%esp)
  104d86:	e8 95 cf ff ff       	call   101d20 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d92:	89 04 24             	mov    %eax,(%esp)
  104d95:	e8 96 d2 ff ff       	call   102030 <nameiparent>
  104d9a:	85 c0                	test   %eax,%eax
  104d9c:	89 c6                	mov    %eax,%esi
  104d9e:	74 44                	je     104de4 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  104da0:	89 04 24             	mov    %eax,(%esp)
  104da3:	e8 e8 cf ff ff       	call   101d90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104da8:	8b 06                	mov    (%esi),%eax
  104daa:	3b 03                	cmp    (%ebx),%eax
  104dac:	75 2e                	jne    104ddc <sys_link+0xdc>
  104dae:	8b 43 04             	mov    0x4(%ebx),%eax
  104db1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104db5:	89 34 24             	mov    %esi,(%esp)
  104db8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dbc:	e8 6f ce ff ff       	call   101c30 <dirlink>
  104dc1:	85 c0                	test   %eax,%eax
  104dc3:	78 17                	js     104ddc <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  104dc5:	89 34 24             	mov    %esi,(%esp)
  104dc8:	e8 a3 cf ff ff       	call   101d70 <iunlockput>
  iput(ip);
  104dcd:	89 1c 24             	mov    %ebx,(%esp)
  104dd0:	e8 0b cd ff ff       	call   101ae0 <iput>
  104dd5:	31 c0                	xor    %eax,%eax
  return 0;
  104dd7:	e9 4f ff ff ff       	jmp    104d2b <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  104ddc:	89 34 24             	mov    %esi,(%esp)
  104ddf:	e8 8c cf ff ff       	call   101d70 <iunlockput>
  ilock(ip);
  104de4:	89 1c 24             	mov    %ebx,(%esp)
  104de7:	e8 a4 cf ff ff       	call   101d90 <ilock>
  ip->nlink--;
  104dec:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104df1:	89 1c 24             	mov    %ebx,(%esp)
  104df4:	e8 17 c8 ff ff       	call   101610 <iupdate>
  iunlockput(ip);
  104df9:	89 1c 24             	mov    %ebx,(%esp)
  104dfc:	e8 6f cf ff ff       	call   101d70 <iunlockput>
  104e01:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104e04:	e9 22 ff ff ff       	jmp    104d2b <sys_link+0x2b>
  104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104e10 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104e10:	55                   	push   %ebp
  104e11:	89 e5                	mov    %esp,%ebp
  104e13:	57                   	push   %edi
  104e14:	89 cf                	mov    %ecx,%edi
  104e16:	56                   	push   %esi
  104e17:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104e18:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104e1a:	83 ec 4c             	sub    $0x4c,%esp
  104e1d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104e20:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104e24:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104e27:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  104e2b:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104e2f:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104e33:	89 74 24 04          	mov    %esi,0x4(%esp)
  104e37:	89 04 24             	mov    %eax,(%esp)
  104e3a:	e8 f1 d1 ff ff       	call   102030 <nameiparent>
  104e3f:	85 c0                	test   %eax,%eax
  104e41:	74 67                	je     104eaa <create+0x9a>
    return 0;
  ilock(dp);
  104e43:	89 04 24             	mov    %eax,(%esp)
  104e46:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104e49:	e8 42 cf ff ff       	call   101d90 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104e4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104e51:	85 d2                	test   %edx,%edx
  104e53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e56:	74 60                	je     104eb8 <create+0xa8>
  104e58:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104e5b:	89 14 24             	mov    %edx,(%esp)
  104e5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e62:	89 74 24 04          	mov    %esi,0x4(%esp)
  104e66:	e8 95 c9 ff ff       	call   101800 <dirlookup>
  104e6b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e6e:	85 c0                	test   %eax,%eax
  104e70:	89 c3                	mov    %eax,%ebx
  104e72:	74 44                	je     104eb8 <create+0xa8>
    iunlockput(dp);
  104e74:	89 14 24             	mov    %edx,(%esp)
  104e77:	e8 f4 ce ff ff       	call   101d70 <iunlockput>
    ilock(ip);
  104e7c:	89 1c 24             	mov    %ebx,(%esp)
  104e7f:	e8 0c cf ff ff       	call   101d90 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104e84:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  104e88:	0f 85 02 01 00 00    	jne    104f90 <create+0x180>
  104e8e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  104e92:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104e96:	0f 85 f4 00 00 00    	jne    104f90 <create+0x180>
  104e9c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  104ea0:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104ea4:	0f 85 e6 00 00 00    	jne    104f90 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104eaa:	83 c4 4c             	add    $0x4c,%esp
  104ead:	89 d8                	mov    %ebx,%eax
  104eaf:	5b                   	pop    %ebx
  104eb0:	5e                   	pop    %esi
  104eb1:	5f                   	pop    %edi
  104eb2:	5d                   	pop    %ebp
  104eb3:	c3                   	ret    
  104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104eb8:	0f bf c7             	movswl %di,%eax
  104ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ebf:	8b 02                	mov    (%edx),%eax
  104ec1:	89 04 24             	mov    %eax,(%esp)
  104ec4:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104ec7:	e8 84 ca ff ff       	call   101950 <ialloc>
  104ecc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104ecf:	85 c0                	test   %eax,%eax
  104ed1:	89 c3                	mov    %eax,%ebx
  104ed3:	74 50                	je     104f25 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104ed5:	89 04 24             	mov    %eax,(%esp)
  104ed8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104edb:	e8 b0 ce ff ff       	call   101d90 <ilock>
  ip->major = major;
  104ee0:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  104ee4:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104eea:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104eee:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  104ef2:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104ef6:	89 1c 24             	mov    %ebx,(%esp)
  104ef9:	e8 12 c7 ff ff       	call   101610 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104efe:	8b 43 04             	mov    0x4(%ebx),%eax
  104f01:	89 74 24 04          	mov    %esi,0x4(%esp)
  104f05:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f09:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f0c:	89 14 24             	mov    %edx,(%esp)
  104f0f:	e8 1c cd ff ff       	call   101c30 <dirlink>
  104f14:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f17:	85 c0                	test   %eax,%eax
  104f19:	0f 88 85 00 00 00    	js     104fa4 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104f1f:	66 83 ff 01          	cmp    $0x1,%di
  104f23:	74 13                	je     104f38 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104f25:	89 14 24             	mov    %edx,(%esp)
  104f28:	e8 43 ce ff ff       	call   101d70 <iunlockput>
  return ip;
}
  104f2d:	83 c4 4c             	add    $0x4c,%esp
  104f30:	89 d8                	mov    %ebx,%eax
  104f32:	5b                   	pop    %ebx
  104f33:	5e                   	pop    %esi
  104f34:	5f                   	pop    %edi
  104f35:	5d                   	pop    %ebp
  104f36:	c3                   	ret    
  104f37:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104f38:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  104f3d:	89 14 24             	mov    %edx,(%esp)
  104f40:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104f43:	e8 c8 c6 ff ff       	call   101610 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104f48:	8b 43 04             	mov    0x4(%ebx),%eax
  104f4b:	c7 44 24 04 d1 6d 10 	movl   $0x106dd1,0x4(%esp)
  104f52:	00 
  104f53:	89 1c 24             	mov    %ebx,(%esp)
  104f56:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f5a:	e8 d1 cc ff ff       	call   101c30 <dirlink>
  104f5f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f62:	85 c0                	test   %eax,%eax
  104f64:	78 1e                	js     104f84 <create+0x174>
  104f66:	8b 42 04             	mov    0x4(%edx),%eax
  104f69:	c7 44 24 04 d0 6d 10 	movl   $0x106dd0,0x4(%esp)
  104f70:	00 
  104f71:	89 1c 24             	mov    %ebx,(%esp)
  104f74:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f78:	e8 b3 cc ff ff       	call   101c30 <dirlink>
  104f7d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104f80:	85 c0                	test   %eax,%eax
  104f82:	79 a1                	jns    104f25 <create+0x115>
      panic("create dots");
  104f84:	c7 04 24 d3 6d 10 00 	movl   $0x106dd3,(%esp)
  104f8b:	e8 d0 b9 ff ff       	call   100960 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  104f90:	89 1c 24             	mov    %ebx,(%esp)
  104f93:	31 db                	xor    %ebx,%ebx
  104f95:	e8 d6 cd ff ff       	call   101d70 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104f9a:	83 c4 4c             	add    $0x4c,%esp
  104f9d:	89 d8                	mov    %ebx,%eax
  104f9f:	5b                   	pop    %ebx
  104fa0:	5e                   	pop    %esi
  104fa1:	5f                   	pop    %edi
  104fa2:	5d                   	pop    %ebp
  104fa3:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104fa4:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104faa:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  104fad:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  104faf:	e8 bc cd ff ff       	call   101d70 <iunlockput>
    iunlockput(dp);
  104fb4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104fb7:	89 14 24             	mov    %edx,(%esp)
  104fba:	e8 b1 cd ff ff       	call   101d70 <iunlockput>
    return 0;
  104fbf:	e9 e6 fe ff ff       	jmp    104eaa <create+0x9a>
  104fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104fd0 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104fd0:	55                   	push   %ebp
  104fd1:	89 e5                	mov    %esp,%ebp
  104fd3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104fd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fe4:	e8 27 f9 ff ff       	call   104910 <argstr>
  104fe9:	85 c0                	test   %eax,%eax
  104feb:	79 0b                	jns    104ff8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  104fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ff2:	c9                   	leave  
  104ff3:	c3                   	ret    
  104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104ff8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104fff:	00 
  105000:	31 d2                	xor    %edx,%edx
  105002:	b9 01 00 00 00       	mov    $0x1,%ecx
  105007:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10500e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105011:	e8 fa fd ff ff       	call   104e10 <create>
  105016:	85 c0                	test   %eax,%eax
  105018:	74 d3                	je     104fed <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  10501a:	89 04 24             	mov    %eax,(%esp)
  10501d:	e8 4e cd ff ff       	call   101d70 <iunlockput>
  105022:	31 c0                	xor    %eax,%eax
  return 0;
}
  105024:	c9                   	leave  
  105025:	c3                   	ret    
  105026:	8d 76 00             	lea    0x0(%esi),%esi
  105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105030 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  105030:	55                   	push   %ebp
  105031:	89 e5                	mov    %esp,%ebp
  105033:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105036:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105039:	89 44 24 04          	mov    %eax,0x4(%esp)
  10503d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105044:	e8 c7 f8 ff ff       	call   104910 <argstr>
  105049:	85 c0                	test   %eax,%eax
  10504b:	79 0b                	jns    105058 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10504d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105052:	c9                   	leave  
  105053:	c3                   	ret    
  105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  105058:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10505b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10505f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105066:	e8 55 f8 ff ff       	call   1048c0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10506b:	85 c0                	test   %eax,%eax
  10506d:	78 de                	js     10504d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  10506f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105072:	89 44 24 04          	mov    %eax,0x4(%esp)
  105076:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10507d:	e8 3e f8 ff ff       	call   1048c0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105082:	85 c0                	test   %eax,%eax
  105084:	78 c7                	js     10504d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  105086:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  10508a:	31 d2                	xor    %edx,%edx
  10508c:	b9 03 00 00 00       	mov    $0x3,%ecx
  105091:	89 44 24 04          	mov    %eax,0x4(%esp)
  105095:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  105099:	89 04 24             	mov    %eax,(%esp)
  10509c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10509f:	e8 6c fd ff ff       	call   104e10 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1050a4:	85 c0                	test   %eax,%eax
  1050a6:	74 a5                	je     10504d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  1050a8:	89 04 24             	mov    %eax,(%esp)
  1050ab:	e8 c0 cc ff ff       	call   101d70 <iunlockput>
  1050b0:	31 c0                	xor    %eax,%eax
  return 0;
}
  1050b2:	c9                   	leave  
  1050b3:	c3                   	ret    
  1050b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1050ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001050c0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  1050c0:	55                   	push   %ebp
  1050c1:	89 e5                	mov    %esp,%ebp
  1050c3:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1050c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  1050c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1050cc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1050cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050da:	e8 31 f8 ff ff       	call   104910 <argstr>
  1050df:	85 c0                	test   %eax,%eax
  1050e1:	79 15                	jns    1050f8 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  1050e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1050e8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1050eb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1050ee:	89 ec                	mov    %ebp,%esp
  1050f0:	5d                   	pop    %ebp
  1050f1:	c3                   	ret    
  1050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1050f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1050fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105106:	e8 b5 f7 ff ff       	call   1048c0 <argint>
  10510b:	85 c0                	test   %eax,%eax
  10510d:	78 d4                	js     1050e3 <sys_open+0x23>
    return -1;

  if(omode & O_CREATE){
  10510f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  105113:	74 7b                	je     105190 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105118:	b9 02 00 00 00       	mov    $0x2,%ecx
  10511d:	ba 01 00 00 00       	mov    $0x1,%edx
  105122:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105129:	00 
  10512a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105131:	e8 da fc ff ff       	call   104e10 <create>
  105136:	85 c0                	test   %eax,%eax
  105138:	89 c6                	mov    %eax,%esi
  10513a:	74 a7                	je     1050e3 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  10513c:	e8 0f bf ff ff       	call   101050 <filealloc>
  105141:	85 c0                	test   %eax,%eax
  105143:	89 c3                	mov    %eax,%ebx
  105145:	74 73                	je     1051ba <sys_open+0xfa>
  105147:	e8 44 f9 ff ff       	call   104a90 <fdalloc>
  10514c:	85 c0                	test   %eax,%eax
  10514e:	66 90                	xchg   %ax,%ax
  105150:	78 7d                	js     1051cf <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105155:	89 34 24             	mov    %esi,(%esp)
  105158:	e8 c3 cb ff ff       	call   101d20 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10515d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  105160:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  105166:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  105169:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  105170:	89 d1                	mov    %edx,%ecx
  105172:	83 f1 01             	xor    $0x1,%ecx
  105175:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105178:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10517b:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10517e:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105185:	e9 5e ff ff ff       	jmp    1050e8 <sys_open+0x28>
  10518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105193:	89 04 24             	mov    %eax,(%esp)
  105196:	e8 b5 ce ff ff       	call   102050 <namei>
  10519b:	85 c0                	test   %eax,%eax
  10519d:	89 c6                	mov    %eax,%esi
  10519f:	0f 84 3e ff ff ff    	je     1050e3 <sys_open+0x23>
      return -1;
    ilock(ip);
  1051a5:	89 04 24             	mov    %eax,(%esp)
  1051a8:	e8 e3 cb ff ff       	call   101d90 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1051ad:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  1051b2:	75 88                	jne    10513c <sys_open+0x7c>
  1051b4:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  1051b8:	74 82                	je     10513c <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  1051ba:	89 34 24             	mov    %esi,(%esp)
  1051bd:	8d 76 00             	lea    0x0(%esi),%esi
  1051c0:	e8 ab cb ff ff       	call   101d70 <iunlockput>
  1051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1051ca:	e9 19 ff ff ff       	jmp    1050e8 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  1051cf:	89 1c 24             	mov    %ebx,(%esp)
  1051d2:	e8 09 bf ff ff       	call   1010e0 <fileclose>
  1051d7:	eb e1                	jmp    1051ba <sys_open+0xfa>
  1051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001051e0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  1051e0:	55                   	push   %ebp
  1051e1:	89 e5                	mov    %esp,%ebp
  1051e3:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1051e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  1051e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1051ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1051ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1051f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051fd:	e8 0e f7 ff ff       	call   104910 <argstr>
  105202:	85 c0                	test   %eax,%eax
  105204:	79 12                	jns    105218 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  105206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10520b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10520e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105211:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105214:	89 ec                	mov    %ebp,%esp
  105216:	5d                   	pop    %ebp
  105217:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  105218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10521b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  10521e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105222:	89 04 24             	mov    %eax,(%esp)
  105225:	e8 06 ce ff ff       	call   102030 <nameiparent>
  10522a:	85 c0                	test   %eax,%eax
  10522c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10522f:	74 d5                	je     105206 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  105231:	89 04 24             	mov    %eax,(%esp)
  105234:	e8 57 cb ff ff       	call   101d90 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  105239:	c7 44 24 04 d1 6d 10 	movl   $0x106dd1,0x4(%esp)
  105240:	00 
  105241:	89 1c 24             	mov    %ebx,(%esp)
  105244:	e8 87 c5 ff ff       	call   1017d0 <namecmp>
  105249:	85 c0                	test   %eax,%eax
  10524b:	0f 84 a4 00 00 00    	je     1052f5 <sys_unlink+0x115>
  105251:	c7 44 24 04 d0 6d 10 	movl   $0x106dd0,0x4(%esp)
  105258:	00 
  105259:	89 1c 24             	mov    %ebx,(%esp)
  10525c:	e8 6f c5 ff ff       	call   1017d0 <namecmp>
  105261:	85 c0                	test   %eax,%eax
  105263:	0f 84 8c 00 00 00    	je     1052f5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  105269:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10526c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105270:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105273:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105277:	89 04 24             	mov    %eax,(%esp)
  10527a:	e8 81 c5 ff ff       	call   101800 <dirlookup>
  10527f:	85 c0                	test   %eax,%eax
  105281:	89 c6                	mov    %eax,%esi
  105283:	74 70                	je     1052f5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105285:	89 04 24             	mov    %eax,(%esp)
  105288:	e8 03 cb ff ff       	call   101d90 <ilock>

  if(ip->nlink < 1)
  10528d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105292:	0f 8e e9 00 00 00    	jle    105381 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105298:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  10529d:	75 71                	jne    105310 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10529f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  1052a3:	76 6b                	jbe    105310 <sys_unlink+0x130>
  1052a5:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  1052a8:	bb 20 00 00 00       	mov    $0x20,%ebx
  1052ad:	8d 76 00             	lea    0x0(%esi),%esi
  1052b0:	eb 0e                	jmp    1052c0 <sys_unlink+0xe0>
  1052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052b8:	83 c3 10             	add    $0x10,%ebx
  1052bb:	3b 5e 18             	cmp    0x18(%esi),%ebx
  1052be:	73 50                	jae    105310 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1052c0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1052c7:	00 
  1052c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1052cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1052d0:	89 34 24             	mov    %esi,(%esp)
  1052d3:	e8 28 c2 ff ff       	call   101500 <readi>
  1052d8:	83 f8 10             	cmp    $0x10,%eax
  1052db:	0f 85 94 00 00 00    	jne    105375 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  1052e1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  1052e6:	74 d0                	je     1052b8 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  1052e8:	89 34 24             	mov    %esi,(%esp)
  1052eb:	90                   	nop
  1052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1052f0:	e8 7b ca ff ff       	call   101d70 <iunlockput>
    iunlockput(dp);
  1052f5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1052f8:	89 04 24             	mov    %eax,(%esp)
  1052fb:	e8 70 ca ff ff       	call   101d70 <iunlockput>
  105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  105305:	e9 01 ff ff ff       	jmp    10520b <sys_unlink+0x2b>
  10530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  105310:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  105313:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10531a:	00 
  10531b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105322:	00 
  105323:	89 1c 24             	mov    %ebx,(%esp)
  105326:	e8 c5 f2 ff ff       	call   1045f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10532b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10532e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105335:	00 
  105336:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10533a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10533e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105341:	89 04 24             	mov    %eax,(%esp)
  105344:	e8 57 c3 ff ff       	call   1016a0 <writei>
  105349:	83 f8 10             	cmp    $0x10,%eax
  10534c:	75 3f                	jne    10538d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  10534e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105351:	89 04 24             	mov    %eax,(%esp)
  105354:	e8 17 ca ff ff       	call   101d70 <iunlockput>

  ip->nlink--;
  105359:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  10535e:	89 34 24             	mov    %esi,(%esp)
  105361:	e8 aa c2 ff ff       	call   101610 <iupdate>
  iunlockput(ip);
  105366:	89 34 24             	mov    %esi,(%esp)
  105369:	e8 02 ca ff ff       	call   101d70 <iunlockput>
  10536e:	31 c0                	xor    %eax,%eax
  return 0;
  105370:	e9 96 fe ff ff       	jmp    10520b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  105375:	c7 04 24 f1 6d 10 00 	movl   $0x106df1,(%esp)
  10537c:	e8 df b5 ff ff       	call   100960 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105381:	c7 04 24 df 6d 10 00 	movl   $0x106ddf,(%esp)
  105388:	e8 d3 b5 ff ff       	call   100960 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  10538d:	c7 04 24 03 6e 10 00 	movl   $0x106e03,(%esp)
  105394:	e8 c7 b5 ff ff       	call   100960 <panic>
  105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001053a0 <T.63>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  1053a0:	55                   	push   %ebp
  1053a1:	89 e5                	mov    %esp,%ebp
  1053a3:	83 ec 28             	sub    $0x28,%esp
  1053a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1053a9:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  1053ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  1053ae:	89 75 fc             	mov    %esi,-0x4(%ebp)
  1053b1:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  1053b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053be:	e8 fd f4 ff ff       	call   1048c0 <argint>
  1053c3:	85 c0                	test   %eax,%eax
  1053c5:	79 11                	jns    1053d8 <T.63+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  1053c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  1053cc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1053cf:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1053d2:	89 ec                	mov    %ebp,%esp
  1053d4:	5d                   	pop    %ebp
  1053d5:	c3                   	ret    
  1053d6:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  1053d8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  1053dc:	77 e9                	ja     1053c7 <T.63+0x27>
  1053de:	e8 5d e1 ff ff       	call   103540 <curproc>
  1053e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  1053e6:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  1053ea:	85 d2                	test   %edx,%edx
  1053ec:	74 d9                	je     1053c7 <T.63+0x27>
    return -1;
  if(pfd)
  1053ee:	85 db                	test   %ebx,%ebx
  1053f0:	74 02                	je     1053f4 <T.63+0x54>
    *pfd = fd;
  1053f2:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  1053f4:	31 c0                	xor    %eax,%eax
  1053f6:	85 f6                	test   %esi,%esi
  1053f8:	74 d2                	je     1053cc <T.63+0x2c>
    *pf = f;
  1053fa:	89 16                	mov    %edx,(%esi)
  1053fc:	eb ce                	jmp    1053cc <T.63+0x2c>
  1053fe:	66 90                	xchg   %ax,%ax

00105400 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105400:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105401:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105403:	89 e5                	mov    %esp,%ebp
  105405:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105408:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10540b:	e8 90 ff ff ff       	call   1053a0 <T.63>
  105410:	85 c0                	test   %eax,%eax
  105412:	79 0c                	jns    105420 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  105414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105419:	c9                   	leave  
  10541a:	c3                   	ret    
  10541b:	90                   	nop
  10541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105423:	89 44 24 04          	mov    %eax,0x4(%esp)
  105427:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10542e:	e8 8d f4 ff ff       	call   1048c0 <argint>
  105433:	85 c0                	test   %eax,%eax
  105435:	78 dd                	js     105414 <sys_read+0x14>
  105437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10543a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105441:	89 44 24 08          	mov    %eax,0x8(%esp)
  105445:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105448:	89 44 24 04          	mov    %eax,0x4(%esp)
  10544c:	e8 3f f5 ff ff       	call   104990 <argptr>
  105451:	85 c0                	test   %eax,%eax
  105453:	78 bf                	js     105414 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  105455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105458:	89 44 24 08          	mov    %eax,0x8(%esp)
  10545c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10545f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105466:	89 04 24             	mov    %eax,(%esp)
  105469:	e8 92 ba ff ff       	call   100f00 <fileread>
}
  10546e:	c9                   	leave  
  10546f:	c3                   	ret    

00105470 <sys_write>:

int
sys_write(void)
{
  105470:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105471:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105473:	89 e5                	mov    %esp,%ebp
  105475:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105478:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10547b:	e8 20 ff ff ff       	call   1053a0 <T.63>
  105480:	85 c0                	test   %eax,%eax
  105482:	79 0c                	jns    105490 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105484:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105489:	c9                   	leave  
  10548a:	c3                   	ret    
  10548b:	90                   	nop
  10548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105490:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105493:	89 44 24 04          	mov    %eax,0x4(%esp)
  105497:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10549e:	e8 1d f4 ff ff       	call   1048c0 <argint>
  1054a3:	85 c0                	test   %eax,%eax
  1054a5:	78 dd                	js     105484 <sys_write+0x14>
  1054a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1054b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054bc:	e8 cf f4 ff ff       	call   104990 <argptr>
  1054c1:	85 c0                	test   %eax,%eax
  1054c3:	78 bf                	js     105484 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  1054c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054d6:	89 04 24             	mov    %eax,(%esp)
  1054d9:	e8 02 b9 ff ff       	call   100de0 <filewrite>
}
  1054de:	c9                   	leave  
  1054df:	c3                   	ret    

001054e0 <sys_dup>:

int
sys_dup(void)
{
  1054e0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1054e1:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1054e3:	89 e5                	mov    %esp,%ebp
  1054e5:	53                   	push   %ebx
  1054e6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1054e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1054ec:	e8 af fe ff ff       	call   1053a0 <T.63>
  1054f1:	85 c0                	test   %eax,%eax
  1054f3:	79 13                	jns    105508 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1054f5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1054fa:	89 d8                	mov    %ebx,%eax
  1054fc:	83 c4 24             	add    $0x24,%esp
  1054ff:	5b                   	pop    %ebx
  105500:	5d                   	pop    %ebp
  105501:	c3                   	ret    
  105502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  105508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10550b:	e8 80 f5 ff ff       	call   104a90 <fdalloc>
  105510:	85 c0                	test   %eax,%eax
  105512:	89 c3                	mov    %eax,%ebx
  105514:	78 df                	js     1054f5 <sys_dup+0x15>
    return -1;
  filedup(f);
  105516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105519:	89 04 24             	mov    %eax,(%esp)
  10551c:	e8 df ba ff ff       	call   101000 <filedup>
  return fd;
  105521:	eb d7                	jmp    1054fa <sys_dup+0x1a>
  105523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105530 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105530:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105531:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105533:	89 e5                	mov    %esp,%ebp
  105535:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105538:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10553b:	e8 60 fe ff ff       	call   1053a0 <T.63>
  105540:	85 c0                	test   %eax,%eax
  105542:	79 0c                	jns    105550 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  105544:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105549:	c9                   	leave  
  10554a:	c3                   	ret    
  10554b:	90                   	nop
  10554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105550:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105553:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10555a:	00 
  10555b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10555f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105566:	e8 25 f4 ff ff       	call   104990 <argptr>
  10556b:	85 c0                	test   %eax,%eax
  10556d:	78 d5                	js     105544 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10556f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105572:	89 44 24 04          	mov    %eax,0x4(%esp)
  105576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105579:	89 04 24             	mov    %eax,(%esp)
  10557c:	e8 2f ba ff ff       	call   100fb0 <filestat>
}
  105581:	c9                   	leave  
  105582:	c3                   	ret    
  105583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105590 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105590:	55                   	push   %ebp
  105591:	89 e5                	mov    %esp,%ebp
  105593:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105596:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105599:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10559c:	e8 ff fd ff ff       	call   1053a0 <T.63>
  1055a1:	89 c2                	mov    %eax,%edx
  1055a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1055a8:	85 d2                	test   %edx,%edx
  1055aa:	78 1d                	js     1055c9 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  1055ac:	e8 8f df ff ff       	call   103540 <curproc>
  1055b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1055b4:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  1055bb:	00 
  fileclose(f);
  1055bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055bf:	89 04 24             	mov    %eax,(%esp)
  1055c2:	e8 19 bb ff ff       	call   1010e0 <fileclose>
  1055c7:	31 c0                	xor    %eax,%eax
  return 0;
}
  1055c9:	c9                   	leave  
  1055ca:	c3                   	ret    
  1055cb:	90                   	nop
  1055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001055d0 <sys_check>:
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  1055d0:	55                   	push   %ebp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  1055d1:	31 c0                	xor    %eax,%eax
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}

int sys_check(void){
  1055d3:	89 e5                	mov    %esp,%ebp
  1055d5:	83 ec 28             	sub    $0x28,%esp

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  1055d8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1055db:	e8 c0 fd ff ff       	call   1053a0 <T.63>
  1055e0:	85 c0                	test   %eax,%eax
  1055e2:	79 0c                	jns    1055f0 <sys_check+0x20>
		return -1;
	return filecheck(f, off);
  1055e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
  1055e9:	c9                   	leave  
  1055ea:	c3                   	ret    
  1055eb:	90                   	nop
  1055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int sys_check(void){

	struct file *f;
	int off;

	if(argfd(0, 0, &f) < 0 || argint(1, &off) < 0)
  1055f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1055f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055fe:	e8 bd f2 ff ff       	call   1048c0 <argint>
  105603:	85 c0                	test   %eax,%eax
  105605:	78 dd                	js     1055e4 <sys_check+0x14>
		return -1;
	return filecheck(f, off);
  105607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10560a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105611:	89 04 24             	mov    %eax,(%esp)
  105614:	e8 77 b8 ff ff       	call   100e90 <filecheck>

}
  105619:	c9                   	leave  
  10561a:	c3                   	ret    
  10561b:	90                   	nop
  10561c:	90                   	nop
  10561d:	90                   	nop
  10561e:	90                   	nop
  10561f:	90                   	nop

00105620 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  105620:	55                   	push   %ebp
return ticks;
}
  105621:	a1 80 ef 10 00       	mov    0x10ef80,%eax
	return 0;
}

int
sys_tick(void)
{
  105626:	89 e5                	mov    %esp,%ebp
return ticks;
}
  105628:	5d                   	pop    %ebp
  105629:	c3                   	ret    
  10562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105630 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  105630:	55                   	push   %ebp
  105631:	89 e5                	mov    %esp,%ebp
  105633:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  105636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105639:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105644:	e8 77 f2 ff ff       	call   1048c0 <argint>
  105649:	89 c2                	mov    %eax,%edx
  10564b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105650:	85 d2                	test   %edx,%edx
  105652:	78 0d                	js     105661 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  105654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105657:	89 04 24             	mov    %eax,(%esp)
  10565a:	e8 11 dc ff ff       	call   103270 <wake_lock>
  10565f:	31 c0                	xor    %eax,%eax

	return 0;
}
  105661:	c9                   	leave  
  105662:	c3                   	ret    
  105663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105670 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  105670:	55                   	push   %ebp
  105671:	89 e5                	mov    %esp,%ebp
  105673:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  105676:	e8 25 e1 ff ff       	call   1037a0 <sleep_lock>
	return 0;
}
  10567b:	31 c0                	xor    %eax,%eax
  10567d:	c9                   	leave  
  10567e:	c3                   	ret    
  10567f:	90                   	nop

00105680 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105686:	e8 b5 de ff ff       	call   103540 <curproc>
  10568b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10568e:	c9                   	leave  
  10568f:	c3                   	ret    

00105690 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105690:	55                   	push   %ebp
  105691:	89 e5                	mov    %esp,%ebp
  105693:	53                   	push   %ebx
  105694:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105697:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10569a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10569e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056a5:	e8 16 f2 ff ff       	call   1048c0 <argint>
  1056aa:	89 c2                	mov    %eax,%edx
  1056ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1056b1:	85 d2                	test   %edx,%edx
  1056b3:	78 58                	js     10570d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  1056b5:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
  1056bc:	e8 bf ee ff ff       	call   104580 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  1056c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  1056c4:	8b 1d 80 ef 10 00    	mov    0x10ef80,%ebx
  while(ticks - ticks0 < n){
  1056ca:	85 d2                	test   %edx,%edx
  1056cc:	7f 22                	jg     1056f0 <sys_sleep+0x60>
  1056ce:	eb 48                	jmp    105718 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  1056d0:	c7 44 24 04 40 e7 10 	movl   $0x10e740,0x4(%esp)
  1056d7:	00 
  1056d8:	c7 04 24 80 ef 10 00 	movl   $0x10ef80,(%esp)
  1056df:	e8 0c e1 ff ff       	call   1037f0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  1056e4:	a1 80 ef 10 00       	mov    0x10ef80,%eax
  1056e9:	29 d8                	sub    %ebx,%eax
  1056eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1056ee:	7d 28                	jge    105718 <sys_sleep+0x88>
    if(cp->killed){
  1056f0:	e8 4b de ff ff       	call   103540 <curproc>
  1056f5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1056f8:	85 c0                	test   %eax,%eax
  1056fa:	74 d4                	je     1056d0 <sys_sleep+0x40>
      release(&tickslock);
  1056fc:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
  105703:	e8 38 ee ff ff       	call   104540 <release>
  105708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10570d:	83 c4 24             	add    $0x24,%esp
  105710:	5b                   	pop    %ebx
  105711:	5d                   	pop    %ebp
  105712:	c3                   	ret    
  105713:	90                   	nop
  105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105718:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
  10571f:	e8 1c ee ff ff       	call   104540 <release>
  return 0;
}
  105724:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105727:	31 c0                	xor    %eax,%eax
  return 0;
}
  105729:	5b                   	pop    %ebx
  10572a:	5d                   	pop    %ebp
  10572b:	c3                   	ret    
  10572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105730 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105730:	55                   	push   %ebp
  105731:	89 e5                	mov    %esp,%ebp
  105733:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105736:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105739:	89 44 24 04          	mov    %eax,0x4(%esp)
  10573d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105744:	e8 77 f1 ff ff       	call   1048c0 <argint>
  105749:	85 c0                	test   %eax,%eax
  10574b:	79 0b                	jns    105758 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  10574d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105752:	c9                   	leave  
  105753:	c3                   	ret    
  105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10575b:	89 04 24             	mov    %eax,(%esp)
  10575e:	e8 fd e6 ff ff       	call   103e60 <growproc>
  105763:	85 c0                	test   %eax,%eax
  105765:	78 e6                	js     10574d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105767:	c9                   	leave  
  105768:	c3                   	ret    
  105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105770 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105770:	55                   	push   %ebp
  105771:	89 e5                	mov    %esp,%ebp
  105773:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105776:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105779:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105784:	e8 37 f1 ff ff       	call   1048c0 <argint>
  105789:	89 c2                	mov    %eax,%edx
  10578b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105790:	85 d2                	test   %edx,%edx
  105792:	78 0b                	js     10579f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105797:	89 04 24             	mov    %eax,(%esp)
  10579a:	e8 11 dc ff ff       	call   1033b0 <kill>
}
  10579f:	c9                   	leave  
  1057a0:	c3                   	ret    
  1057a1:	eb 0d                	jmp    1057b0 <sys_wait>
  1057a3:	90                   	nop
  1057a4:	90                   	nop
  1057a5:	90                   	nop
  1057a6:	90                   	nop
  1057a7:	90                   	nop
  1057a8:	90                   	nop
  1057a9:	90                   	nop
  1057aa:	90                   	nop
  1057ab:	90                   	nop
  1057ac:	90                   	nop
  1057ad:	90                   	nop
  1057ae:	90                   	nop
  1057af:	90                   	nop

001057b0 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  1057b0:	55                   	push   %ebp
  1057b1:	89 e5                	mov    %esp,%ebp
  1057b3:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  1057b6:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  1057b7:	e9 04 e2 ff ff       	jmp    1039c0 <wait>
  1057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001057c0 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  1057c0:	55                   	push   %ebp
  1057c1:	89 e5                	mov    %esp,%ebp
  1057c3:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  1057c6:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  1057c7:	e9 f4 e0 ff ff       	jmp    1038c0 <wait_thread>
  1057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001057d0 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  1057d0:	55                   	push   %ebp
  1057d1:	89 e5                	mov    %esp,%ebp
  1057d3:	83 ec 08             	sub    $0x8,%esp
  exit();
  1057d6:	e8 65 de ff ff       	call   103640 <exit>
  return 0;  // not reached
}
  1057db:	31 c0                	xor    %eax,%eax
  1057dd:	c9                   	leave  
  1057de:	c3                   	ret    
  1057df:	90                   	nop

001057e0 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  1057e0:	55                   	push   %ebp
  1057e1:	89 e5                	mov    %esp,%ebp
  1057e3:	53                   	push   %ebx
  1057e4:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  1057e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1057ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057f5:	e8 c6 f0 ff ff       	call   1048c0 <argint>
  1057fa:	85 c0                	test   %eax,%eax
  1057fc:	79 12                	jns    105810 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  1057fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105803:	83 c4 24             	add    $0x24,%esp
  105806:	5b                   	pop    %ebx
  105807:	5d                   	pop    %ebp
  105808:	c3                   	ret    
  105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105810:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105813:	e8 28 dd ff ff       	call   103540 <curproc>
  105818:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10581c:	89 04 24             	mov    %eax,(%esp)
  10581f:	e8 fc e6 ff ff       	call   103f20 <copyproc_tix>
  105824:	85 c0                	test   %eax,%eax
  105826:	89 c2                	mov    %eax,%edx
  105828:	74 d4                	je     1057fe <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10582a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10582d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  105830:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  105837:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  10583d:	eb c4                	jmp    105803 <sys_fork_tickets+0x23>
  10583f:	90                   	nop

00105840 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  105840:	55                   	push   %ebp
  105841:	89 e5                	mov    %esp,%ebp
  105843:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105846:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  105849:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10584c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10584f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105852:	89 44 24 04          	mov    %eax,0x4(%esp)
  105856:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10585d:	e8 5e f0 ff ff       	call   1048c0 <argint>
  105862:	85 c0                	test   %eax,%eax
  105864:	79 12                	jns    105878 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10586b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10586e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105871:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105874:	89 ec                	mov    %ebp,%esp
  105876:	5d                   	pop    %ebp
  105877:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105878:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10587b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10587f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105886:	e8 35 f0 ff ff       	call   1048c0 <argint>
  10588b:	85 c0                	test   %eax,%eax
  10588d:	78 d7                	js     105866 <sys_fork_thread+0x26>
  10588f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  105892:	89 44 24 04          	mov    %eax,0x4(%esp)
  105896:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10589d:	e8 1e f0 ff ff       	call   1048c0 <argint>
  1058a2:	85 c0                	test   %eax,%eax
  1058a4:	78 c0                	js     105866 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  1058a6:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1058a9:	8b 75 e0             	mov    -0x20(%ebp),%esi
  1058ac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  1058af:	e8 8c dc ff ff       	call   103540 <curproc>
  1058b4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1058b8:	89 74 24 08          	mov    %esi,0x8(%esp)
  1058bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1058c0:	89 04 24             	mov    %eax,(%esp)
  1058c3:	e8 98 e7 ff ff       	call   104060 <copyproc_threads>
  1058c8:	89 c2                	mov    %eax,%edx
  1058ca:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  1058cf:	85 d2                	test   %edx,%edx
  1058d1:	74 98                	je     10586b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  1058d3:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  1058da:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  1058dd:	eb 8c                	jmp    10586b <sys_fork_thread+0x2b>
  1058df:	90                   	nop

001058e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  1058e0:	55                   	push   %ebp
  1058e1:	89 e5                	mov    %esp,%ebp
  1058e3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  1058e6:	e8 55 dc ff ff       	call   103540 <curproc>
  1058eb:	89 04 24             	mov    %eax,(%esp)
  1058ee:	e8 7d e8 ff ff       	call   104170 <copyproc>
  1058f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1058f8:	85 c0                	test   %eax,%eax
  1058fa:	74 0a                	je     105906 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1058fc:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1058ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105906:	89 d0                	mov    %edx,%eax
  105908:	c9                   	leave  
  105909:	c3                   	ret    
  10590a:	90                   	nop
  10590b:	90                   	nop
  10590c:	90                   	nop
  10590d:	90                   	nop
  10590e:	90                   	nop
  10590f:	90                   	nop

00105910 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105910:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105911:	ba 43 00 00 00       	mov    $0x43,%edx
  105916:	89 e5                	mov    %esp,%ebp
  105918:	83 ec 18             	sub    $0x18,%esp
  10591b:	b8 34 00 00 00       	mov    $0x34,%eax
  105920:	ee                   	out    %al,(%dx)
  105921:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105926:	b2 40                	mov    $0x40,%dl
  105928:	ee                   	out    %al,(%dx)
  105929:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10592e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  10592f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105936:	e8 15 d5 ff ff       	call   102e50 <pic_enable>
}
  10593b:	c9                   	leave  
  10593c:	c3                   	ret    
  10593d:	90                   	nop
  10593e:	90                   	nop
  10593f:	90                   	nop

00105940 <alltraps>:
  105940:	1e                   	push   %ds
  105941:	06                   	push   %es
  105942:	60                   	pusha  
  105943:	b8 10 00 00 00       	mov    $0x10,%eax
  105948:	8e d8                	mov    %eax,%ds
  10594a:	8e c0                	mov    %eax,%es
  10594c:	54                   	push   %esp
  10594d:	e8 4e 00 00 00       	call   1059a0 <trap>
  105952:	83 c4 04             	add    $0x4,%esp

00105955 <trapret>:
  105955:	61                   	popa   
  105956:	07                   	pop    %es
  105957:	1f                   	pop    %ds
  105958:	83 c4 08             	add    $0x8,%esp
  10595b:	cf                   	iret   

0010595c <forkret1>:
  10595c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105960:	e9 f0 ff ff ff       	jmp    105955 <trapret>
  105965:	90                   	nop
  105966:	90                   	nop
  105967:	90                   	nop
  105968:	90                   	nop
  105969:	90                   	nop
  10596a:	90                   	nop
  10596b:	90                   	nop
  10596c:	90                   	nop
  10596d:	90                   	nop
  10596e:	90                   	nop
  10596f:	90                   	nop

00105970 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105970:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105971:	b8 80 e7 10 00       	mov    $0x10e780,%eax
  105976:	89 e5                	mov    %esp,%ebp
  105978:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10597b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105981:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105985:	c1 e8 10             	shr    $0x10,%eax
  105988:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10598c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10598f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105992:	c9                   	leave  
  105993:	c3                   	ret    
  105994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10599a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001059a0 <trap>:

void
trap(struct trapframe *tf)
{
  1059a0:	55                   	push   %ebp
  1059a1:	89 e5                	mov    %esp,%ebp
  1059a3:	83 ec 48             	sub    $0x48,%esp
  1059a6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1059a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1059ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1059af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  1059b2:	8b 43 28             	mov    0x28(%ebx),%eax
  1059b5:	83 f8 30             	cmp    $0x30,%eax
  1059b8:	0f 84 8a 01 00 00    	je     105b48 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1059be:	83 f8 21             	cmp    $0x21,%eax
  1059c1:	0f 84 69 01 00 00    	je     105b30 <trap+0x190>
  1059c7:	76 47                	jbe    105a10 <trap+0x70>
  1059c9:	83 f8 2e             	cmp    $0x2e,%eax
  1059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1059d0:	0f 84 42 01 00 00    	je     105b18 <trap+0x178>
  1059d6:	83 f8 3f             	cmp    $0x3f,%eax
  1059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1059e0:	75 37                	jne    105a19 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1059e2:	8b 7b 30             	mov    0x30(%ebx),%edi
  1059e5:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  1059e9:	e8 c2 cf ff ff       	call   1029b0 <cpu>
  1059ee:	c7 04 24 14 6e 10 00 	movl   $0x106e14,(%esp)
  1059f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1059f9:	89 74 24 08          	mov    %esi,0x8(%esp)
  1059fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a01:	e8 ba ad ff ff       	call   1007c0 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105a06:	e8 15 ce ff ff       	call   102820 <lapic_eoi>
    break;
  105a0b:	e9 90 00 00 00       	jmp    105aa0 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105a10:	83 f8 20             	cmp    $0x20,%eax
  105a13:	0f 84 e7 00 00 00    	je     105b00 <trap+0x160>
  105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105a20:	e8 1b db ff ff       	call   103540 <curproc>
  105a25:	85 c0                	test   %eax,%eax
  105a27:	0f 84 9b 01 00 00    	je     105bc8 <trap+0x228>
  105a2d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  105a31:	0f 84 91 01 00 00    	je     105bc8 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105a37:	8b 53 30             	mov    0x30(%ebx),%edx
  105a3a:	89 55 e0             	mov    %edx,-0x20(%ebp)
  105a3d:	e8 6e cf ff ff       	call   1029b0 <cpu>
  105a42:	8b 4b 28             	mov    0x28(%ebx),%ecx
  105a45:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105a48:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105a4b:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  105a4d:	e8 ee da ff ff       	call   103540 <curproc>
  105a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a55:	e8 e6 da ff ff       	call   103540 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105a5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105a5d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105a61:	89 74 24 10          	mov    %esi,0x10(%esp)
  105a65:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a69:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105a6c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a73:	81 c2 88 00 00 00    	add    $0x88,%edx
  105a79:	89 54 24 08          	mov    %edx,0x8(%esp)
  105a7d:	8b 40 10             	mov    0x10(%eax),%eax
  105a80:	c7 04 24 60 6e 10 00 	movl   $0x106e60,(%esp)
  105a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a8b:	e8 30 ad ff ff       	call   1007c0 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105a90:	e8 ab da ff ff       	call   103540 <curproc>
  105a95:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105aa0:	e8 9b da ff ff       	call   103540 <curproc>
  105aa5:	85 c0                	test   %eax,%eax
  105aa7:	74 1c                	je     105ac5 <trap+0x125>
  105aa9:	e8 92 da ff ff       	call   103540 <curproc>
  105aae:	8b 40 1c             	mov    0x1c(%eax),%eax
  105ab1:	85 c0                	test   %eax,%eax
  105ab3:	74 10                	je     105ac5 <trap+0x125>
  105ab5:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105ab9:	83 e0 03             	and    $0x3,%eax
  105abc:	83 f8 03             	cmp    $0x3,%eax
  105abf:	0f 84 33 01 00 00    	je     105bf8 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105ac5:	e8 76 da ff ff       	call   103540 <curproc>
  105aca:	85 c0                	test   %eax,%eax
  105acc:	74 0d                	je     105adb <trap+0x13b>
  105ace:	66 90                	xchg   %ax,%ax
  105ad0:	e8 6b da ff ff       	call   103540 <curproc>
  105ad5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105ad9:	74 0d                	je     105ae8 <trap+0x148>
    yield();
}
  105adb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105ade:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105ae1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105ae4:	89 ec                	mov    %ebp,%esp
  105ae6:	5d                   	pop    %ebp
  105ae7:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105ae8:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  105aec:	75 ed                	jne    105adb <trap+0x13b>
    yield();
}
  105aee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105af1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105af4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105af7:	89 ec                	mov    %ebp,%esp
  105af9:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105afa:	e9 d1 df ff ff       	jmp    103ad0 <yield>
  105aff:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105b00:	e8 ab ce ff ff       	call   1029b0 <cpu>
  105b05:	85 c0                	test   %eax,%eax
  105b07:	0f 84 8b 00 00 00    	je     105b98 <trap+0x1f8>
  105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  105b10:	e8 0b cd ff ff       	call   102820 <lapic_eoi>
    break;
  105b15:	eb 89                	jmp    105aa0 <trap+0x100>
  105b17:	90                   	nop
  105b18:	90                   	nop
  105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105b20:	e8 eb c6 ff ff       	call   102210 <ide_intr>
  105b25:	8d 76 00             	lea    0x0(%esi),%esi
  105b28:	eb e3                	jmp    105b0d <trap+0x16d>
  105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105b30:	e8 db cb ff ff       	call   102710 <kbd_intr>
  105b35:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  105b38:	e8 e3 cc ff ff       	call   102820 <lapic_eoi>
  105b3d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105b40:	e9 5b ff ff ff       	jmp    105aa0 <trap+0x100>
  105b45:	8d 76 00             	lea    0x0(%esi),%esi
  105b48:	90                   	nop
  105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105b50:	e8 eb d9 ff ff       	call   103540 <curproc>
  105b55:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105b58:	85 c9                	test   %ecx,%ecx
  105b5a:	0f 85 a8 00 00 00    	jne    105c08 <trap+0x268>
      exit();
    cp->tf = tf;
  105b60:	e8 db d9 ff ff       	call   103540 <curproc>
  105b65:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  105b6b:	e8 80 ee ff ff       	call   1049f0 <syscall>
    if(cp->killed)
  105b70:	e8 cb d9 ff ff       	call   103540 <curproc>
  105b75:	8b 50 1c             	mov    0x1c(%eax),%edx
  105b78:	85 d2                	test   %edx,%edx
  105b7a:	0f 84 5b ff ff ff    	je     105adb <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105b80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105b83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105b86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105b89:	89 ec                	mov    %ebp,%esp
  105b8b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105b8c:	e9 af da ff ff       	jmp    103640 <exit>
  105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105b98:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
  105b9f:	e8 dc e9 ff ff       	call   104580 <acquire>
      ticks++;
  105ba4:	83 05 80 ef 10 00 01 	addl   $0x1,0x10ef80
      wakeup(&ticks);
  105bab:	c7 04 24 80 ef 10 00 	movl   $0x10ef80,(%esp)
  105bb2:	e8 89 d8 ff ff       	call   103440 <wakeup>
      release(&tickslock);
  105bb7:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
  105bbe:	e8 7d e9 ff ff       	call   104540 <release>
  105bc3:	e9 45 ff ff ff       	jmp    105b0d <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105bc8:	8b 73 30             	mov    0x30(%ebx),%esi
  105bcb:	e8 e0 cd ff ff       	call   1029b0 <cpu>
  105bd0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105bd4:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bd8:	8b 43 28             	mov    0x28(%ebx),%eax
  105bdb:	c7 04 24 38 6e 10 00 	movl   $0x106e38,(%esp)
  105be2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be6:	e8 d5 ab ff ff       	call   1007c0 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105beb:	c7 04 24 9c 6e 10 00 	movl   $0x106e9c,(%esp)
  105bf2:	e8 69 ad ff ff       	call   100960 <panic>
  105bf7:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105bf8:	e8 43 da ff ff       	call   103640 <exit>
  105bfd:	e9 c3 fe ff ff       	jmp    105ac5 <trap+0x125>
  105c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105c08:	90                   	nop
  105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105c10:	e8 2b da ff ff       	call   103640 <exit>
  105c15:	8d 76 00             	lea    0x0(%esi),%esi
  105c18:	e9 43 ff ff ff       	jmp    105b60 <trap+0x1c0>
  105c1d:	8d 76 00             	lea    0x0(%esi),%esi

00105c20 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105c20:	55                   	push   %ebp
  105c21:	31 c0                	xor    %eax,%eax
  105c23:	89 e5                	mov    %esp,%ebp
  105c25:	ba 80 e7 10 00       	mov    $0x10e780,%edx
  105c2a:	83 ec 18             	sub    $0x18,%esp
  105c2d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105c30:	8b 0c 85 c8 81 10 00 	mov    0x1081c8(,%eax,4),%ecx
  105c37:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105c3e:	66 89 0c c5 80 e7 10 	mov    %cx,0x10e780(,%eax,8)
  105c45:	00 
  105c46:	c1 e9 10             	shr    $0x10,%ecx
  105c49:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  105c4e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105c53:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105c58:	83 c0 01             	add    $0x1,%eax
  105c5b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105c60:	75 ce                	jne    105c30 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105c62:	a1 88 82 10 00       	mov    0x108288,%eax
  
  initlock(&tickslock, "time");
  105c67:	c7 44 24 04 a1 6e 10 	movl   $0x106ea1,0x4(%esp)
  105c6e:	00 
  105c6f:	c7 04 24 40 e7 10 00 	movl   $0x10e740,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105c76:	66 c7 05 02 e9 10 00 	movw   $0x8,0x10e902
  105c7d:	08 00 
  105c7f:	66 a3 00 e9 10 00    	mov    %ax,0x10e900
  105c85:	c1 e8 10             	shr    $0x10,%eax
  105c88:	c6 05 04 e9 10 00 00 	movb   $0x0,0x10e904
  105c8f:	c6 05 05 e9 10 00 ef 	movb   $0xef,0x10e905
  105c96:	66 a3 06 e9 10 00    	mov    %ax,0x10e906
  
  initlock(&tickslock, "time");
  105c9c:	e8 1f e7 ff ff       	call   1043c0 <initlock>
}
  105ca1:	c9                   	leave  
  105ca2:	c3                   	ret    
  105ca3:	90                   	nop

00105ca4 <vector0>:
  105ca4:	6a 00                	push   $0x0
  105ca6:	6a 00                	push   $0x0
  105ca8:	e9 93 fc ff ff       	jmp    105940 <alltraps>

00105cad <vector1>:
  105cad:	6a 00                	push   $0x0
  105caf:	6a 01                	push   $0x1
  105cb1:	e9 8a fc ff ff       	jmp    105940 <alltraps>

00105cb6 <vector2>:
  105cb6:	6a 00                	push   $0x0
  105cb8:	6a 02                	push   $0x2
  105cba:	e9 81 fc ff ff       	jmp    105940 <alltraps>

00105cbf <vector3>:
  105cbf:	6a 00                	push   $0x0
  105cc1:	6a 03                	push   $0x3
  105cc3:	e9 78 fc ff ff       	jmp    105940 <alltraps>

00105cc8 <vector4>:
  105cc8:	6a 00                	push   $0x0
  105cca:	6a 04                	push   $0x4
  105ccc:	e9 6f fc ff ff       	jmp    105940 <alltraps>

00105cd1 <vector5>:
  105cd1:	6a 00                	push   $0x0
  105cd3:	6a 05                	push   $0x5
  105cd5:	e9 66 fc ff ff       	jmp    105940 <alltraps>

00105cda <vector6>:
  105cda:	6a 00                	push   $0x0
  105cdc:	6a 06                	push   $0x6
  105cde:	e9 5d fc ff ff       	jmp    105940 <alltraps>

00105ce3 <vector7>:
  105ce3:	6a 00                	push   $0x0
  105ce5:	6a 07                	push   $0x7
  105ce7:	e9 54 fc ff ff       	jmp    105940 <alltraps>

00105cec <vector8>:
  105cec:	6a 08                	push   $0x8
  105cee:	e9 4d fc ff ff       	jmp    105940 <alltraps>

00105cf3 <vector9>:
  105cf3:	6a 09                	push   $0x9
  105cf5:	e9 46 fc ff ff       	jmp    105940 <alltraps>

00105cfa <vector10>:
  105cfa:	6a 0a                	push   $0xa
  105cfc:	e9 3f fc ff ff       	jmp    105940 <alltraps>

00105d01 <vector11>:
  105d01:	6a 0b                	push   $0xb
  105d03:	e9 38 fc ff ff       	jmp    105940 <alltraps>

00105d08 <vector12>:
  105d08:	6a 0c                	push   $0xc
  105d0a:	e9 31 fc ff ff       	jmp    105940 <alltraps>

00105d0f <vector13>:
  105d0f:	6a 0d                	push   $0xd
  105d11:	e9 2a fc ff ff       	jmp    105940 <alltraps>

00105d16 <vector14>:
  105d16:	6a 0e                	push   $0xe
  105d18:	e9 23 fc ff ff       	jmp    105940 <alltraps>

00105d1d <vector15>:
  105d1d:	6a 00                	push   $0x0
  105d1f:	6a 0f                	push   $0xf
  105d21:	e9 1a fc ff ff       	jmp    105940 <alltraps>

00105d26 <vector16>:
  105d26:	6a 00                	push   $0x0
  105d28:	6a 10                	push   $0x10
  105d2a:	e9 11 fc ff ff       	jmp    105940 <alltraps>

00105d2f <vector17>:
  105d2f:	6a 11                	push   $0x11
  105d31:	e9 0a fc ff ff       	jmp    105940 <alltraps>

00105d36 <vector18>:
  105d36:	6a 00                	push   $0x0
  105d38:	6a 12                	push   $0x12
  105d3a:	e9 01 fc ff ff       	jmp    105940 <alltraps>

00105d3f <vector19>:
  105d3f:	6a 00                	push   $0x0
  105d41:	6a 13                	push   $0x13
  105d43:	e9 f8 fb ff ff       	jmp    105940 <alltraps>

00105d48 <vector20>:
  105d48:	6a 00                	push   $0x0
  105d4a:	6a 14                	push   $0x14
  105d4c:	e9 ef fb ff ff       	jmp    105940 <alltraps>

00105d51 <vector21>:
  105d51:	6a 00                	push   $0x0
  105d53:	6a 15                	push   $0x15
  105d55:	e9 e6 fb ff ff       	jmp    105940 <alltraps>

00105d5a <vector22>:
  105d5a:	6a 00                	push   $0x0
  105d5c:	6a 16                	push   $0x16
  105d5e:	e9 dd fb ff ff       	jmp    105940 <alltraps>

00105d63 <vector23>:
  105d63:	6a 00                	push   $0x0
  105d65:	6a 17                	push   $0x17
  105d67:	e9 d4 fb ff ff       	jmp    105940 <alltraps>

00105d6c <vector24>:
  105d6c:	6a 00                	push   $0x0
  105d6e:	6a 18                	push   $0x18
  105d70:	e9 cb fb ff ff       	jmp    105940 <alltraps>

00105d75 <vector25>:
  105d75:	6a 00                	push   $0x0
  105d77:	6a 19                	push   $0x19
  105d79:	e9 c2 fb ff ff       	jmp    105940 <alltraps>

00105d7e <vector26>:
  105d7e:	6a 00                	push   $0x0
  105d80:	6a 1a                	push   $0x1a
  105d82:	e9 b9 fb ff ff       	jmp    105940 <alltraps>

00105d87 <vector27>:
  105d87:	6a 00                	push   $0x0
  105d89:	6a 1b                	push   $0x1b
  105d8b:	e9 b0 fb ff ff       	jmp    105940 <alltraps>

00105d90 <vector28>:
  105d90:	6a 00                	push   $0x0
  105d92:	6a 1c                	push   $0x1c
  105d94:	e9 a7 fb ff ff       	jmp    105940 <alltraps>

00105d99 <vector29>:
  105d99:	6a 00                	push   $0x0
  105d9b:	6a 1d                	push   $0x1d
  105d9d:	e9 9e fb ff ff       	jmp    105940 <alltraps>

00105da2 <vector30>:
  105da2:	6a 00                	push   $0x0
  105da4:	6a 1e                	push   $0x1e
  105da6:	e9 95 fb ff ff       	jmp    105940 <alltraps>

00105dab <vector31>:
  105dab:	6a 00                	push   $0x0
  105dad:	6a 1f                	push   $0x1f
  105daf:	e9 8c fb ff ff       	jmp    105940 <alltraps>

00105db4 <vector32>:
  105db4:	6a 00                	push   $0x0
  105db6:	6a 20                	push   $0x20
  105db8:	e9 83 fb ff ff       	jmp    105940 <alltraps>

00105dbd <vector33>:
  105dbd:	6a 00                	push   $0x0
  105dbf:	6a 21                	push   $0x21
  105dc1:	e9 7a fb ff ff       	jmp    105940 <alltraps>

00105dc6 <vector34>:
  105dc6:	6a 00                	push   $0x0
  105dc8:	6a 22                	push   $0x22
  105dca:	e9 71 fb ff ff       	jmp    105940 <alltraps>

00105dcf <vector35>:
  105dcf:	6a 00                	push   $0x0
  105dd1:	6a 23                	push   $0x23
  105dd3:	e9 68 fb ff ff       	jmp    105940 <alltraps>

00105dd8 <vector36>:
  105dd8:	6a 00                	push   $0x0
  105dda:	6a 24                	push   $0x24
  105ddc:	e9 5f fb ff ff       	jmp    105940 <alltraps>

00105de1 <vector37>:
  105de1:	6a 00                	push   $0x0
  105de3:	6a 25                	push   $0x25
  105de5:	e9 56 fb ff ff       	jmp    105940 <alltraps>

00105dea <vector38>:
  105dea:	6a 00                	push   $0x0
  105dec:	6a 26                	push   $0x26
  105dee:	e9 4d fb ff ff       	jmp    105940 <alltraps>

00105df3 <vector39>:
  105df3:	6a 00                	push   $0x0
  105df5:	6a 27                	push   $0x27
  105df7:	e9 44 fb ff ff       	jmp    105940 <alltraps>

00105dfc <vector40>:
  105dfc:	6a 00                	push   $0x0
  105dfe:	6a 28                	push   $0x28
  105e00:	e9 3b fb ff ff       	jmp    105940 <alltraps>

00105e05 <vector41>:
  105e05:	6a 00                	push   $0x0
  105e07:	6a 29                	push   $0x29
  105e09:	e9 32 fb ff ff       	jmp    105940 <alltraps>

00105e0e <vector42>:
  105e0e:	6a 00                	push   $0x0
  105e10:	6a 2a                	push   $0x2a
  105e12:	e9 29 fb ff ff       	jmp    105940 <alltraps>

00105e17 <vector43>:
  105e17:	6a 00                	push   $0x0
  105e19:	6a 2b                	push   $0x2b
  105e1b:	e9 20 fb ff ff       	jmp    105940 <alltraps>

00105e20 <vector44>:
  105e20:	6a 00                	push   $0x0
  105e22:	6a 2c                	push   $0x2c
  105e24:	e9 17 fb ff ff       	jmp    105940 <alltraps>

00105e29 <vector45>:
  105e29:	6a 00                	push   $0x0
  105e2b:	6a 2d                	push   $0x2d
  105e2d:	e9 0e fb ff ff       	jmp    105940 <alltraps>

00105e32 <vector46>:
  105e32:	6a 00                	push   $0x0
  105e34:	6a 2e                	push   $0x2e
  105e36:	e9 05 fb ff ff       	jmp    105940 <alltraps>

00105e3b <vector47>:
  105e3b:	6a 00                	push   $0x0
  105e3d:	6a 2f                	push   $0x2f
  105e3f:	e9 fc fa ff ff       	jmp    105940 <alltraps>

00105e44 <vector48>:
  105e44:	6a 00                	push   $0x0
  105e46:	6a 30                	push   $0x30
  105e48:	e9 f3 fa ff ff       	jmp    105940 <alltraps>

00105e4d <vector49>:
  105e4d:	6a 00                	push   $0x0
  105e4f:	6a 31                	push   $0x31
  105e51:	e9 ea fa ff ff       	jmp    105940 <alltraps>

00105e56 <vector50>:
  105e56:	6a 00                	push   $0x0
  105e58:	6a 32                	push   $0x32
  105e5a:	e9 e1 fa ff ff       	jmp    105940 <alltraps>

00105e5f <vector51>:
  105e5f:	6a 00                	push   $0x0
  105e61:	6a 33                	push   $0x33
  105e63:	e9 d8 fa ff ff       	jmp    105940 <alltraps>

00105e68 <vector52>:
  105e68:	6a 00                	push   $0x0
  105e6a:	6a 34                	push   $0x34
  105e6c:	e9 cf fa ff ff       	jmp    105940 <alltraps>

00105e71 <vector53>:
  105e71:	6a 00                	push   $0x0
  105e73:	6a 35                	push   $0x35
  105e75:	e9 c6 fa ff ff       	jmp    105940 <alltraps>

00105e7a <vector54>:
  105e7a:	6a 00                	push   $0x0
  105e7c:	6a 36                	push   $0x36
  105e7e:	e9 bd fa ff ff       	jmp    105940 <alltraps>

00105e83 <vector55>:
  105e83:	6a 00                	push   $0x0
  105e85:	6a 37                	push   $0x37
  105e87:	e9 b4 fa ff ff       	jmp    105940 <alltraps>

00105e8c <vector56>:
  105e8c:	6a 00                	push   $0x0
  105e8e:	6a 38                	push   $0x38
  105e90:	e9 ab fa ff ff       	jmp    105940 <alltraps>

00105e95 <vector57>:
  105e95:	6a 00                	push   $0x0
  105e97:	6a 39                	push   $0x39
  105e99:	e9 a2 fa ff ff       	jmp    105940 <alltraps>

00105e9e <vector58>:
  105e9e:	6a 00                	push   $0x0
  105ea0:	6a 3a                	push   $0x3a
  105ea2:	e9 99 fa ff ff       	jmp    105940 <alltraps>

00105ea7 <vector59>:
  105ea7:	6a 00                	push   $0x0
  105ea9:	6a 3b                	push   $0x3b
  105eab:	e9 90 fa ff ff       	jmp    105940 <alltraps>

00105eb0 <vector60>:
  105eb0:	6a 00                	push   $0x0
  105eb2:	6a 3c                	push   $0x3c
  105eb4:	e9 87 fa ff ff       	jmp    105940 <alltraps>

00105eb9 <vector61>:
  105eb9:	6a 00                	push   $0x0
  105ebb:	6a 3d                	push   $0x3d
  105ebd:	e9 7e fa ff ff       	jmp    105940 <alltraps>

00105ec2 <vector62>:
  105ec2:	6a 00                	push   $0x0
  105ec4:	6a 3e                	push   $0x3e
  105ec6:	e9 75 fa ff ff       	jmp    105940 <alltraps>

00105ecb <vector63>:
  105ecb:	6a 00                	push   $0x0
  105ecd:	6a 3f                	push   $0x3f
  105ecf:	e9 6c fa ff ff       	jmp    105940 <alltraps>

00105ed4 <vector64>:
  105ed4:	6a 00                	push   $0x0
  105ed6:	6a 40                	push   $0x40
  105ed8:	e9 63 fa ff ff       	jmp    105940 <alltraps>

00105edd <vector65>:
  105edd:	6a 00                	push   $0x0
  105edf:	6a 41                	push   $0x41
  105ee1:	e9 5a fa ff ff       	jmp    105940 <alltraps>

00105ee6 <vector66>:
  105ee6:	6a 00                	push   $0x0
  105ee8:	6a 42                	push   $0x42
  105eea:	e9 51 fa ff ff       	jmp    105940 <alltraps>

00105eef <vector67>:
  105eef:	6a 00                	push   $0x0
  105ef1:	6a 43                	push   $0x43
  105ef3:	e9 48 fa ff ff       	jmp    105940 <alltraps>

00105ef8 <vector68>:
  105ef8:	6a 00                	push   $0x0
  105efa:	6a 44                	push   $0x44
  105efc:	e9 3f fa ff ff       	jmp    105940 <alltraps>

00105f01 <vector69>:
  105f01:	6a 00                	push   $0x0
  105f03:	6a 45                	push   $0x45
  105f05:	e9 36 fa ff ff       	jmp    105940 <alltraps>

00105f0a <vector70>:
  105f0a:	6a 00                	push   $0x0
  105f0c:	6a 46                	push   $0x46
  105f0e:	e9 2d fa ff ff       	jmp    105940 <alltraps>

00105f13 <vector71>:
  105f13:	6a 00                	push   $0x0
  105f15:	6a 47                	push   $0x47
  105f17:	e9 24 fa ff ff       	jmp    105940 <alltraps>

00105f1c <vector72>:
  105f1c:	6a 00                	push   $0x0
  105f1e:	6a 48                	push   $0x48
  105f20:	e9 1b fa ff ff       	jmp    105940 <alltraps>

00105f25 <vector73>:
  105f25:	6a 00                	push   $0x0
  105f27:	6a 49                	push   $0x49
  105f29:	e9 12 fa ff ff       	jmp    105940 <alltraps>

00105f2e <vector74>:
  105f2e:	6a 00                	push   $0x0
  105f30:	6a 4a                	push   $0x4a
  105f32:	e9 09 fa ff ff       	jmp    105940 <alltraps>

00105f37 <vector75>:
  105f37:	6a 00                	push   $0x0
  105f39:	6a 4b                	push   $0x4b
  105f3b:	e9 00 fa ff ff       	jmp    105940 <alltraps>

00105f40 <vector76>:
  105f40:	6a 00                	push   $0x0
  105f42:	6a 4c                	push   $0x4c
  105f44:	e9 f7 f9 ff ff       	jmp    105940 <alltraps>

00105f49 <vector77>:
  105f49:	6a 00                	push   $0x0
  105f4b:	6a 4d                	push   $0x4d
  105f4d:	e9 ee f9 ff ff       	jmp    105940 <alltraps>

00105f52 <vector78>:
  105f52:	6a 00                	push   $0x0
  105f54:	6a 4e                	push   $0x4e
  105f56:	e9 e5 f9 ff ff       	jmp    105940 <alltraps>

00105f5b <vector79>:
  105f5b:	6a 00                	push   $0x0
  105f5d:	6a 4f                	push   $0x4f
  105f5f:	e9 dc f9 ff ff       	jmp    105940 <alltraps>

00105f64 <vector80>:
  105f64:	6a 00                	push   $0x0
  105f66:	6a 50                	push   $0x50
  105f68:	e9 d3 f9 ff ff       	jmp    105940 <alltraps>

00105f6d <vector81>:
  105f6d:	6a 00                	push   $0x0
  105f6f:	6a 51                	push   $0x51
  105f71:	e9 ca f9 ff ff       	jmp    105940 <alltraps>

00105f76 <vector82>:
  105f76:	6a 00                	push   $0x0
  105f78:	6a 52                	push   $0x52
  105f7a:	e9 c1 f9 ff ff       	jmp    105940 <alltraps>

00105f7f <vector83>:
  105f7f:	6a 00                	push   $0x0
  105f81:	6a 53                	push   $0x53
  105f83:	e9 b8 f9 ff ff       	jmp    105940 <alltraps>

00105f88 <vector84>:
  105f88:	6a 00                	push   $0x0
  105f8a:	6a 54                	push   $0x54
  105f8c:	e9 af f9 ff ff       	jmp    105940 <alltraps>

00105f91 <vector85>:
  105f91:	6a 00                	push   $0x0
  105f93:	6a 55                	push   $0x55
  105f95:	e9 a6 f9 ff ff       	jmp    105940 <alltraps>

00105f9a <vector86>:
  105f9a:	6a 00                	push   $0x0
  105f9c:	6a 56                	push   $0x56
  105f9e:	e9 9d f9 ff ff       	jmp    105940 <alltraps>

00105fa3 <vector87>:
  105fa3:	6a 00                	push   $0x0
  105fa5:	6a 57                	push   $0x57
  105fa7:	e9 94 f9 ff ff       	jmp    105940 <alltraps>

00105fac <vector88>:
  105fac:	6a 00                	push   $0x0
  105fae:	6a 58                	push   $0x58
  105fb0:	e9 8b f9 ff ff       	jmp    105940 <alltraps>

00105fb5 <vector89>:
  105fb5:	6a 00                	push   $0x0
  105fb7:	6a 59                	push   $0x59
  105fb9:	e9 82 f9 ff ff       	jmp    105940 <alltraps>

00105fbe <vector90>:
  105fbe:	6a 00                	push   $0x0
  105fc0:	6a 5a                	push   $0x5a
  105fc2:	e9 79 f9 ff ff       	jmp    105940 <alltraps>

00105fc7 <vector91>:
  105fc7:	6a 00                	push   $0x0
  105fc9:	6a 5b                	push   $0x5b
  105fcb:	e9 70 f9 ff ff       	jmp    105940 <alltraps>

00105fd0 <vector92>:
  105fd0:	6a 00                	push   $0x0
  105fd2:	6a 5c                	push   $0x5c
  105fd4:	e9 67 f9 ff ff       	jmp    105940 <alltraps>

00105fd9 <vector93>:
  105fd9:	6a 00                	push   $0x0
  105fdb:	6a 5d                	push   $0x5d
  105fdd:	e9 5e f9 ff ff       	jmp    105940 <alltraps>

00105fe2 <vector94>:
  105fe2:	6a 00                	push   $0x0
  105fe4:	6a 5e                	push   $0x5e
  105fe6:	e9 55 f9 ff ff       	jmp    105940 <alltraps>

00105feb <vector95>:
  105feb:	6a 00                	push   $0x0
  105fed:	6a 5f                	push   $0x5f
  105fef:	e9 4c f9 ff ff       	jmp    105940 <alltraps>

00105ff4 <vector96>:
  105ff4:	6a 00                	push   $0x0
  105ff6:	6a 60                	push   $0x60
  105ff8:	e9 43 f9 ff ff       	jmp    105940 <alltraps>

00105ffd <vector97>:
  105ffd:	6a 00                	push   $0x0
  105fff:	6a 61                	push   $0x61
  106001:	e9 3a f9 ff ff       	jmp    105940 <alltraps>

00106006 <vector98>:
  106006:	6a 00                	push   $0x0
  106008:	6a 62                	push   $0x62
  10600a:	e9 31 f9 ff ff       	jmp    105940 <alltraps>

0010600f <vector99>:
  10600f:	6a 00                	push   $0x0
  106011:	6a 63                	push   $0x63
  106013:	e9 28 f9 ff ff       	jmp    105940 <alltraps>

00106018 <vector100>:
  106018:	6a 00                	push   $0x0
  10601a:	6a 64                	push   $0x64
  10601c:	e9 1f f9 ff ff       	jmp    105940 <alltraps>

00106021 <vector101>:
  106021:	6a 00                	push   $0x0
  106023:	6a 65                	push   $0x65
  106025:	e9 16 f9 ff ff       	jmp    105940 <alltraps>

0010602a <vector102>:
  10602a:	6a 00                	push   $0x0
  10602c:	6a 66                	push   $0x66
  10602e:	e9 0d f9 ff ff       	jmp    105940 <alltraps>

00106033 <vector103>:
  106033:	6a 00                	push   $0x0
  106035:	6a 67                	push   $0x67
  106037:	e9 04 f9 ff ff       	jmp    105940 <alltraps>

0010603c <vector104>:
  10603c:	6a 00                	push   $0x0
  10603e:	6a 68                	push   $0x68
  106040:	e9 fb f8 ff ff       	jmp    105940 <alltraps>

00106045 <vector105>:
  106045:	6a 00                	push   $0x0
  106047:	6a 69                	push   $0x69
  106049:	e9 f2 f8 ff ff       	jmp    105940 <alltraps>

0010604e <vector106>:
  10604e:	6a 00                	push   $0x0
  106050:	6a 6a                	push   $0x6a
  106052:	e9 e9 f8 ff ff       	jmp    105940 <alltraps>

00106057 <vector107>:
  106057:	6a 00                	push   $0x0
  106059:	6a 6b                	push   $0x6b
  10605b:	e9 e0 f8 ff ff       	jmp    105940 <alltraps>

00106060 <vector108>:
  106060:	6a 00                	push   $0x0
  106062:	6a 6c                	push   $0x6c
  106064:	e9 d7 f8 ff ff       	jmp    105940 <alltraps>

00106069 <vector109>:
  106069:	6a 00                	push   $0x0
  10606b:	6a 6d                	push   $0x6d
  10606d:	e9 ce f8 ff ff       	jmp    105940 <alltraps>

00106072 <vector110>:
  106072:	6a 00                	push   $0x0
  106074:	6a 6e                	push   $0x6e
  106076:	e9 c5 f8 ff ff       	jmp    105940 <alltraps>

0010607b <vector111>:
  10607b:	6a 00                	push   $0x0
  10607d:	6a 6f                	push   $0x6f
  10607f:	e9 bc f8 ff ff       	jmp    105940 <alltraps>

00106084 <vector112>:
  106084:	6a 00                	push   $0x0
  106086:	6a 70                	push   $0x70
  106088:	e9 b3 f8 ff ff       	jmp    105940 <alltraps>

0010608d <vector113>:
  10608d:	6a 00                	push   $0x0
  10608f:	6a 71                	push   $0x71
  106091:	e9 aa f8 ff ff       	jmp    105940 <alltraps>

00106096 <vector114>:
  106096:	6a 00                	push   $0x0
  106098:	6a 72                	push   $0x72
  10609a:	e9 a1 f8 ff ff       	jmp    105940 <alltraps>

0010609f <vector115>:
  10609f:	6a 00                	push   $0x0
  1060a1:	6a 73                	push   $0x73
  1060a3:	e9 98 f8 ff ff       	jmp    105940 <alltraps>

001060a8 <vector116>:
  1060a8:	6a 00                	push   $0x0
  1060aa:	6a 74                	push   $0x74
  1060ac:	e9 8f f8 ff ff       	jmp    105940 <alltraps>

001060b1 <vector117>:
  1060b1:	6a 00                	push   $0x0
  1060b3:	6a 75                	push   $0x75
  1060b5:	e9 86 f8 ff ff       	jmp    105940 <alltraps>

001060ba <vector118>:
  1060ba:	6a 00                	push   $0x0
  1060bc:	6a 76                	push   $0x76
  1060be:	e9 7d f8 ff ff       	jmp    105940 <alltraps>

001060c3 <vector119>:
  1060c3:	6a 00                	push   $0x0
  1060c5:	6a 77                	push   $0x77
  1060c7:	e9 74 f8 ff ff       	jmp    105940 <alltraps>

001060cc <vector120>:
  1060cc:	6a 00                	push   $0x0
  1060ce:	6a 78                	push   $0x78
  1060d0:	e9 6b f8 ff ff       	jmp    105940 <alltraps>

001060d5 <vector121>:
  1060d5:	6a 00                	push   $0x0
  1060d7:	6a 79                	push   $0x79
  1060d9:	e9 62 f8 ff ff       	jmp    105940 <alltraps>

001060de <vector122>:
  1060de:	6a 00                	push   $0x0
  1060e0:	6a 7a                	push   $0x7a
  1060e2:	e9 59 f8 ff ff       	jmp    105940 <alltraps>

001060e7 <vector123>:
  1060e7:	6a 00                	push   $0x0
  1060e9:	6a 7b                	push   $0x7b
  1060eb:	e9 50 f8 ff ff       	jmp    105940 <alltraps>

001060f0 <vector124>:
  1060f0:	6a 00                	push   $0x0
  1060f2:	6a 7c                	push   $0x7c
  1060f4:	e9 47 f8 ff ff       	jmp    105940 <alltraps>

001060f9 <vector125>:
  1060f9:	6a 00                	push   $0x0
  1060fb:	6a 7d                	push   $0x7d
  1060fd:	e9 3e f8 ff ff       	jmp    105940 <alltraps>

00106102 <vector126>:
  106102:	6a 00                	push   $0x0
  106104:	6a 7e                	push   $0x7e
  106106:	e9 35 f8 ff ff       	jmp    105940 <alltraps>

0010610b <vector127>:
  10610b:	6a 00                	push   $0x0
  10610d:	6a 7f                	push   $0x7f
  10610f:	e9 2c f8 ff ff       	jmp    105940 <alltraps>

00106114 <vector128>:
  106114:	6a 00                	push   $0x0
  106116:	68 80 00 00 00       	push   $0x80
  10611b:	e9 20 f8 ff ff       	jmp    105940 <alltraps>

00106120 <vector129>:
  106120:	6a 00                	push   $0x0
  106122:	68 81 00 00 00       	push   $0x81
  106127:	e9 14 f8 ff ff       	jmp    105940 <alltraps>

0010612c <vector130>:
  10612c:	6a 00                	push   $0x0
  10612e:	68 82 00 00 00       	push   $0x82
  106133:	e9 08 f8 ff ff       	jmp    105940 <alltraps>

00106138 <vector131>:
  106138:	6a 00                	push   $0x0
  10613a:	68 83 00 00 00       	push   $0x83
  10613f:	e9 fc f7 ff ff       	jmp    105940 <alltraps>

00106144 <vector132>:
  106144:	6a 00                	push   $0x0
  106146:	68 84 00 00 00       	push   $0x84
  10614b:	e9 f0 f7 ff ff       	jmp    105940 <alltraps>

00106150 <vector133>:
  106150:	6a 00                	push   $0x0
  106152:	68 85 00 00 00       	push   $0x85
  106157:	e9 e4 f7 ff ff       	jmp    105940 <alltraps>

0010615c <vector134>:
  10615c:	6a 00                	push   $0x0
  10615e:	68 86 00 00 00       	push   $0x86
  106163:	e9 d8 f7 ff ff       	jmp    105940 <alltraps>

00106168 <vector135>:
  106168:	6a 00                	push   $0x0
  10616a:	68 87 00 00 00       	push   $0x87
  10616f:	e9 cc f7 ff ff       	jmp    105940 <alltraps>

00106174 <vector136>:
  106174:	6a 00                	push   $0x0
  106176:	68 88 00 00 00       	push   $0x88
  10617b:	e9 c0 f7 ff ff       	jmp    105940 <alltraps>

00106180 <vector137>:
  106180:	6a 00                	push   $0x0
  106182:	68 89 00 00 00       	push   $0x89
  106187:	e9 b4 f7 ff ff       	jmp    105940 <alltraps>

0010618c <vector138>:
  10618c:	6a 00                	push   $0x0
  10618e:	68 8a 00 00 00       	push   $0x8a
  106193:	e9 a8 f7 ff ff       	jmp    105940 <alltraps>

00106198 <vector139>:
  106198:	6a 00                	push   $0x0
  10619a:	68 8b 00 00 00       	push   $0x8b
  10619f:	e9 9c f7 ff ff       	jmp    105940 <alltraps>

001061a4 <vector140>:
  1061a4:	6a 00                	push   $0x0
  1061a6:	68 8c 00 00 00       	push   $0x8c
  1061ab:	e9 90 f7 ff ff       	jmp    105940 <alltraps>

001061b0 <vector141>:
  1061b0:	6a 00                	push   $0x0
  1061b2:	68 8d 00 00 00       	push   $0x8d
  1061b7:	e9 84 f7 ff ff       	jmp    105940 <alltraps>

001061bc <vector142>:
  1061bc:	6a 00                	push   $0x0
  1061be:	68 8e 00 00 00       	push   $0x8e
  1061c3:	e9 78 f7 ff ff       	jmp    105940 <alltraps>

001061c8 <vector143>:
  1061c8:	6a 00                	push   $0x0
  1061ca:	68 8f 00 00 00       	push   $0x8f
  1061cf:	e9 6c f7 ff ff       	jmp    105940 <alltraps>

001061d4 <vector144>:
  1061d4:	6a 00                	push   $0x0
  1061d6:	68 90 00 00 00       	push   $0x90
  1061db:	e9 60 f7 ff ff       	jmp    105940 <alltraps>

001061e0 <vector145>:
  1061e0:	6a 00                	push   $0x0
  1061e2:	68 91 00 00 00       	push   $0x91
  1061e7:	e9 54 f7 ff ff       	jmp    105940 <alltraps>

001061ec <vector146>:
  1061ec:	6a 00                	push   $0x0
  1061ee:	68 92 00 00 00       	push   $0x92
  1061f3:	e9 48 f7 ff ff       	jmp    105940 <alltraps>

001061f8 <vector147>:
  1061f8:	6a 00                	push   $0x0
  1061fa:	68 93 00 00 00       	push   $0x93
  1061ff:	e9 3c f7 ff ff       	jmp    105940 <alltraps>

00106204 <vector148>:
  106204:	6a 00                	push   $0x0
  106206:	68 94 00 00 00       	push   $0x94
  10620b:	e9 30 f7 ff ff       	jmp    105940 <alltraps>

00106210 <vector149>:
  106210:	6a 00                	push   $0x0
  106212:	68 95 00 00 00       	push   $0x95
  106217:	e9 24 f7 ff ff       	jmp    105940 <alltraps>

0010621c <vector150>:
  10621c:	6a 00                	push   $0x0
  10621e:	68 96 00 00 00       	push   $0x96
  106223:	e9 18 f7 ff ff       	jmp    105940 <alltraps>

00106228 <vector151>:
  106228:	6a 00                	push   $0x0
  10622a:	68 97 00 00 00       	push   $0x97
  10622f:	e9 0c f7 ff ff       	jmp    105940 <alltraps>

00106234 <vector152>:
  106234:	6a 00                	push   $0x0
  106236:	68 98 00 00 00       	push   $0x98
  10623b:	e9 00 f7 ff ff       	jmp    105940 <alltraps>

00106240 <vector153>:
  106240:	6a 00                	push   $0x0
  106242:	68 99 00 00 00       	push   $0x99
  106247:	e9 f4 f6 ff ff       	jmp    105940 <alltraps>

0010624c <vector154>:
  10624c:	6a 00                	push   $0x0
  10624e:	68 9a 00 00 00       	push   $0x9a
  106253:	e9 e8 f6 ff ff       	jmp    105940 <alltraps>

00106258 <vector155>:
  106258:	6a 00                	push   $0x0
  10625a:	68 9b 00 00 00       	push   $0x9b
  10625f:	e9 dc f6 ff ff       	jmp    105940 <alltraps>

00106264 <vector156>:
  106264:	6a 00                	push   $0x0
  106266:	68 9c 00 00 00       	push   $0x9c
  10626b:	e9 d0 f6 ff ff       	jmp    105940 <alltraps>

00106270 <vector157>:
  106270:	6a 00                	push   $0x0
  106272:	68 9d 00 00 00       	push   $0x9d
  106277:	e9 c4 f6 ff ff       	jmp    105940 <alltraps>

0010627c <vector158>:
  10627c:	6a 00                	push   $0x0
  10627e:	68 9e 00 00 00       	push   $0x9e
  106283:	e9 b8 f6 ff ff       	jmp    105940 <alltraps>

00106288 <vector159>:
  106288:	6a 00                	push   $0x0
  10628a:	68 9f 00 00 00       	push   $0x9f
  10628f:	e9 ac f6 ff ff       	jmp    105940 <alltraps>

00106294 <vector160>:
  106294:	6a 00                	push   $0x0
  106296:	68 a0 00 00 00       	push   $0xa0
  10629b:	e9 a0 f6 ff ff       	jmp    105940 <alltraps>

001062a0 <vector161>:
  1062a0:	6a 00                	push   $0x0
  1062a2:	68 a1 00 00 00       	push   $0xa1
  1062a7:	e9 94 f6 ff ff       	jmp    105940 <alltraps>

001062ac <vector162>:
  1062ac:	6a 00                	push   $0x0
  1062ae:	68 a2 00 00 00       	push   $0xa2
  1062b3:	e9 88 f6 ff ff       	jmp    105940 <alltraps>

001062b8 <vector163>:
  1062b8:	6a 00                	push   $0x0
  1062ba:	68 a3 00 00 00       	push   $0xa3
  1062bf:	e9 7c f6 ff ff       	jmp    105940 <alltraps>

001062c4 <vector164>:
  1062c4:	6a 00                	push   $0x0
  1062c6:	68 a4 00 00 00       	push   $0xa4
  1062cb:	e9 70 f6 ff ff       	jmp    105940 <alltraps>

001062d0 <vector165>:
  1062d0:	6a 00                	push   $0x0
  1062d2:	68 a5 00 00 00       	push   $0xa5
  1062d7:	e9 64 f6 ff ff       	jmp    105940 <alltraps>

001062dc <vector166>:
  1062dc:	6a 00                	push   $0x0
  1062de:	68 a6 00 00 00       	push   $0xa6
  1062e3:	e9 58 f6 ff ff       	jmp    105940 <alltraps>

001062e8 <vector167>:
  1062e8:	6a 00                	push   $0x0
  1062ea:	68 a7 00 00 00       	push   $0xa7
  1062ef:	e9 4c f6 ff ff       	jmp    105940 <alltraps>

001062f4 <vector168>:
  1062f4:	6a 00                	push   $0x0
  1062f6:	68 a8 00 00 00       	push   $0xa8
  1062fb:	e9 40 f6 ff ff       	jmp    105940 <alltraps>

00106300 <vector169>:
  106300:	6a 00                	push   $0x0
  106302:	68 a9 00 00 00       	push   $0xa9
  106307:	e9 34 f6 ff ff       	jmp    105940 <alltraps>

0010630c <vector170>:
  10630c:	6a 00                	push   $0x0
  10630e:	68 aa 00 00 00       	push   $0xaa
  106313:	e9 28 f6 ff ff       	jmp    105940 <alltraps>

00106318 <vector171>:
  106318:	6a 00                	push   $0x0
  10631a:	68 ab 00 00 00       	push   $0xab
  10631f:	e9 1c f6 ff ff       	jmp    105940 <alltraps>

00106324 <vector172>:
  106324:	6a 00                	push   $0x0
  106326:	68 ac 00 00 00       	push   $0xac
  10632b:	e9 10 f6 ff ff       	jmp    105940 <alltraps>

00106330 <vector173>:
  106330:	6a 00                	push   $0x0
  106332:	68 ad 00 00 00       	push   $0xad
  106337:	e9 04 f6 ff ff       	jmp    105940 <alltraps>

0010633c <vector174>:
  10633c:	6a 00                	push   $0x0
  10633e:	68 ae 00 00 00       	push   $0xae
  106343:	e9 f8 f5 ff ff       	jmp    105940 <alltraps>

00106348 <vector175>:
  106348:	6a 00                	push   $0x0
  10634a:	68 af 00 00 00       	push   $0xaf
  10634f:	e9 ec f5 ff ff       	jmp    105940 <alltraps>

00106354 <vector176>:
  106354:	6a 00                	push   $0x0
  106356:	68 b0 00 00 00       	push   $0xb0
  10635b:	e9 e0 f5 ff ff       	jmp    105940 <alltraps>

00106360 <vector177>:
  106360:	6a 00                	push   $0x0
  106362:	68 b1 00 00 00       	push   $0xb1
  106367:	e9 d4 f5 ff ff       	jmp    105940 <alltraps>

0010636c <vector178>:
  10636c:	6a 00                	push   $0x0
  10636e:	68 b2 00 00 00       	push   $0xb2
  106373:	e9 c8 f5 ff ff       	jmp    105940 <alltraps>

00106378 <vector179>:
  106378:	6a 00                	push   $0x0
  10637a:	68 b3 00 00 00       	push   $0xb3
  10637f:	e9 bc f5 ff ff       	jmp    105940 <alltraps>

00106384 <vector180>:
  106384:	6a 00                	push   $0x0
  106386:	68 b4 00 00 00       	push   $0xb4
  10638b:	e9 b0 f5 ff ff       	jmp    105940 <alltraps>

00106390 <vector181>:
  106390:	6a 00                	push   $0x0
  106392:	68 b5 00 00 00       	push   $0xb5
  106397:	e9 a4 f5 ff ff       	jmp    105940 <alltraps>

0010639c <vector182>:
  10639c:	6a 00                	push   $0x0
  10639e:	68 b6 00 00 00       	push   $0xb6
  1063a3:	e9 98 f5 ff ff       	jmp    105940 <alltraps>

001063a8 <vector183>:
  1063a8:	6a 00                	push   $0x0
  1063aa:	68 b7 00 00 00       	push   $0xb7
  1063af:	e9 8c f5 ff ff       	jmp    105940 <alltraps>

001063b4 <vector184>:
  1063b4:	6a 00                	push   $0x0
  1063b6:	68 b8 00 00 00       	push   $0xb8
  1063bb:	e9 80 f5 ff ff       	jmp    105940 <alltraps>

001063c0 <vector185>:
  1063c0:	6a 00                	push   $0x0
  1063c2:	68 b9 00 00 00       	push   $0xb9
  1063c7:	e9 74 f5 ff ff       	jmp    105940 <alltraps>

001063cc <vector186>:
  1063cc:	6a 00                	push   $0x0
  1063ce:	68 ba 00 00 00       	push   $0xba
  1063d3:	e9 68 f5 ff ff       	jmp    105940 <alltraps>

001063d8 <vector187>:
  1063d8:	6a 00                	push   $0x0
  1063da:	68 bb 00 00 00       	push   $0xbb
  1063df:	e9 5c f5 ff ff       	jmp    105940 <alltraps>

001063e4 <vector188>:
  1063e4:	6a 00                	push   $0x0
  1063e6:	68 bc 00 00 00       	push   $0xbc
  1063eb:	e9 50 f5 ff ff       	jmp    105940 <alltraps>

001063f0 <vector189>:
  1063f0:	6a 00                	push   $0x0
  1063f2:	68 bd 00 00 00       	push   $0xbd
  1063f7:	e9 44 f5 ff ff       	jmp    105940 <alltraps>

001063fc <vector190>:
  1063fc:	6a 00                	push   $0x0
  1063fe:	68 be 00 00 00       	push   $0xbe
  106403:	e9 38 f5 ff ff       	jmp    105940 <alltraps>

00106408 <vector191>:
  106408:	6a 00                	push   $0x0
  10640a:	68 bf 00 00 00       	push   $0xbf
  10640f:	e9 2c f5 ff ff       	jmp    105940 <alltraps>

00106414 <vector192>:
  106414:	6a 00                	push   $0x0
  106416:	68 c0 00 00 00       	push   $0xc0
  10641b:	e9 20 f5 ff ff       	jmp    105940 <alltraps>

00106420 <vector193>:
  106420:	6a 00                	push   $0x0
  106422:	68 c1 00 00 00       	push   $0xc1
  106427:	e9 14 f5 ff ff       	jmp    105940 <alltraps>

0010642c <vector194>:
  10642c:	6a 00                	push   $0x0
  10642e:	68 c2 00 00 00       	push   $0xc2
  106433:	e9 08 f5 ff ff       	jmp    105940 <alltraps>

00106438 <vector195>:
  106438:	6a 00                	push   $0x0
  10643a:	68 c3 00 00 00       	push   $0xc3
  10643f:	e9 fc f4 ff ff       	jmp    105940 <alltraps>

00106444 <vector196>:
  106444:	6a 00                	push   $0x0
  106446:	68 c4 00 00 00       	push   $0xc4
  10644b:	e9 f0 f4 ff ff       	jmp    105940 <alltraps>

00106450 <vector197>:
  106450:	6a 00                	push   $0x0
  106452:	68 c5 00 00 00       	push   $0xc5
  106457:	e9 e4 f4 ff ff       	jmp    105940 <alltraps>

0010645c <vector198>:
  10645c:	6a 00                	push   $0x0
  10645e:	68 c6 00 00 00       	push   $0xc6
  106463:	e9 d8 f4 ff ff       	jmp    105940 <alltraps>

00106468 <vector199>:
  106468:	6a 00                	push   $0x0
  10646a:	68 c7 00 00 00       	push   $0xc7
  10646f:	e9 cc f4 ff ff       	jmp    105940 <alltraps>

00106474 <vector200>:
  106474:	6a 00                	push   $0x0
  106476:	68 c8 00 00 00       	push   $0xc8
  10647b:	e9 c0 f4 ff ff       	jmp    105940 <alltraps>

00106480 <vector201>:
  106480:	6a 00                	push   $0x0
  106482:	68 c9 00 00 00       	push   $0xc9
  106487:	e9 b4 f4 ff ff       	jmp    105940 <alltraps>

0010648c <vector202>:
  10648c:	6a 00                	push   $0x0
  10648e:	68 ca 00 00 00       	push   $0xca
  106493:	e9 a8 f4 ff ff       	jmp    105940 <alltraps>

00106498 <vector203>:
  106498:	6a 00                	push   $0x0
  10649a:	68 cb 00 00 00       	push   $0xcb
  10649f:	e9 9c f4 ff ff       	jmp    105940 <alltraps>

001064a4 <vector204>:
  1064a4:	6a 00                	push   $0x0
  1064a6:	68 cc 00 00 00       	push   $0xcc
  1064ab:	e9 90 f4 ff ff       	jmp    105940 <alltraps>

001064b0 <vector205>:
  1064b0:	6a 00                	push   $0x0
  1064b2:	68 cd 00 00 00       	push   $0xcd
  1064b7:	e9 84 f4 ff ff       	jmp    105940 <alltraps>

001064bc <vector206>:
  1064bc:	6a 00                	push   $0x0
  1064be:	68 ce 00 00 00       	push   $0xce
  1064c3:	e9 78 f4 ff ff       	jmp    105940 <alltraps>

001064c8 <vector207>:
  1064c8:	6a 00                	push   $0x0
  1064ca:	68 cf 00 00 00       	push   $0xcf
  1064cf:	e9 6c f4 ff ff       	jmp    105940 <alltraps>

001064d4 <vector208>:
  1064d4:	6a 00                	push   $0x0
  1064d6:	68 d0 00 00 00       	push   $0xd0
  1064db:	e9 60 f4 ff ff       	jmp    105940 <alltraps>

001064e0 <vector209>:
  1064e0:	6a 00                	push   $0x0
  1064e2:	68 d1 00 00 00       	push   $0xd1
  1064e7:	e9 54 f4 ff ff       	jmp    105940 <alltraps>

001064ec <vector210>:
  1064ec:	6a 00                	push   $0x0
  1064ee:	68 d2 00 00 00       	push   $0xd2
  1064f3:	e9 48 f4 ff ff       	jmp    105940 <alltraps>

001064f8 <vector211>:
  1064f8:	6a 00                	push   $0x0
  1064fa:	68 d3 00 00 00       	push   $0xd3
  1064ff:	e9 3c f4 ff ff       	jmp    105940 <alltraps>

00106504 <vector212>:
  106504:	6a 00                	push   $0x0
  106506:	68 d4 00 00 00       	push   $0xd4
  10650b:	e9 30 f4 ff ff       	jmp    105940 <alltraps>

00106510 <vector213>:
  106510:	6a 00                	push   $0x0
  106512:	68 d5 00 00 00       	push   $0xd5
  106517:	e9 24 f4 ff ff       	jmp    105940 <alltraps>

0010651c <vector214>:
  10651c:	6a 00                	push   $0x0
  10651e:	68 d6 00 00 00       	push   $0xd6
  106523:	e9 18 f4 ff ff       	jmp    105940 <alltraps>

00106528 <vector215>:
  106528:	6a 00                	push   $0x0
  10652a:	68 d7 00 00 00       	push   $0xd7
  10652f:	e9 0c f4 ff ff       	jmp    105940 <alltraps>

00106534 <vector216>:
  106534:	6a 00                	push   $0x0
  106536:	68 d8 00 00 00       	push   $0xd8
  10653b:	e9 00 f4 ff ff       	jmp    105940 <alltraps>

00106540 <vector217>:
  106540:	6a 00                	push   $0x0
  106542:	68 d9 00 00 00       	push   $0xd9
  106547:	e9 f4 f3 ff ff       	jmp    105940 <alltraps>

0010654c <vector218>:
  10654c:	6a 00                	push   $0x0
  10654e:	68 da 00 00 00       	push   $0xda
  106553:	e9 e8 f3 ff ff       	jmp    105940 <alltraps>

00106558 <vector219>:
  106558:	6a 00                	push   $0x0
  10655a:	68 db 00 00 00       	push   $0xdb
  10655f:	e9 dc f3 ff ff       	jmp    105940 <alltraps>

00106564 <vector220>:
  106564:	6a 00                	push   $0x0
  106566:	68 dc 00 00 00       	push   $0xdc
  10656b:	e9 d0 f3 ff ff       	jmp    105940 <alltraps>

00106570 <vector221>:
  106570:	6a 00                	push   $0x0
  106572:	68 dd 00 00 00       	push   $0xdd
  106577:	e9 c4 f3 ff ff       	jmp    105940 <alltraps>

0010657c <vector222>:
  10657c:	6a 00                	push   $0x0
  10657e:	68 de 00 00 00       	push   $0xde
  106583:	e9 b8 f3 ff ff       	jmp    105940 <alltraps>

00106588 <vector223>:
  106588:	6a 00                	push   $0x0
  10658a:	68 df 00 00 00       	push   $0xdf
  10658f:	e9 ac f3 ff ff       	jmp    105940 <alltraps>

00106594 <vector224>:
  106594:	6a 00                	push   $0x0
  106596:	68 e0 00 00 00       	push   $0xe0
  10659b:	e9 a0 f3 ff ff       	jmp    105940 <alltraps>

001065a0 <vector225>:
  1065a0:	6a 00                	push   $0x0
  1065a2:	68 e1 00 00 00       	push   $0xe1
  1065a7:	e9 94 f3 ff ff       	jmp    105940 <alltraps>

001065ac <vector226>:
  1065ac:	6a 00                	push   $0x0
  1065ae:	68 e2 00 00 00       	push   $0xe2
  1065b3:	e9 88 f3 ff ff       	jmp    105940 <alltraps>

001065b8 <vector227>:
  1065b8:	6a 00                	push   $0x0
  1065ba:	68 e3 00 00 00       	push   $0xe3
  1065bf:	e9 7c f3 ff ff       	jmp    105940 <alltraps>

001065c4 <vector228>:
  1065c4:	6a 00                	push   $0x0
  1065c6:	68 e4 00 00 00       	push   $0xe4
  1065cb:	e9 70 f3 ff ff       	jmp    105940 <alltraps>

001065d0 <vector229>:
  1065d0:	6a 00                	push   $0x0
  1065d2:	68 e5 00 00 00       	push   $0xe5
  1065d7:	e9 64 f3 ff ff       	jmp    105940 <alltraps>

001065dc <vector230>:
  1065dc:	6a 00                	push   $0x0
  1065de:	68 e6 00 00 00       	push   $0xe6
  1065e3:	e9 58 f3 ff ff       	jmp    105940 <alltraps>

001065e8 <vector231>:
  1065e8:	6a 00                	push   $0x0
  1065ea:	68 e7 00 00 00       	push   $0xe7
  1065ef:	e9 4c f3 ff ff       	jmp    105940 <alltraps>

001065f4 <vector232>:
  1065f4:	6a 00                	push   $0x0
  1065f6:	68 e8 00 00 00       	push   $0xe8
  1065fb:	e9 40 f3 ff ff       	jmp    105940 <alltraps>

00106600 <vector233>:
  106600:	6a 00                	push   $0x0
  106602:	68 e9 00 00 00       	push   $0xe9
  106607:	e9 34 f3 ff ff       	jmp    105940 <alltraps>

0010660c <vector234>:
  10660c:	6a 00                	push   $0x0
  10660e:	68 ea 00 00 00       	push   $0xea
  106613:	e9 28 f3 ff ff       	jmp    105940 <alltraps>

00106618 <vector235>:
  106618:	6a 00                	push   $0x0
  10661a:	68 eb 00 00 00       	push   $0xeb
  10661f:	e9 1c f3 ff ff       	jmp    105940 <alltraps>

00106624 <vector236>:
  106624:	6a 00                	push   $0x0
  106626:	68 ec 00 00 00       	push   $0xec
  10662b:	e9 10 f3 ff ff       	jmp    105940 <alltraps>

00106630 <vector237>:
  106630:	6a 00                	push   $0x0
  106632:	68 ed 00 00 00       	push   $0xed
  106637:	e9 04 f3 ff ff       	jmp    105940 <alltraps>

0010663c <vector238>:
  10663c:	6a 00                	push   $0x0
  10663e:	68 ee 00 00 00       	push   $0xee
  106643:	e9 f8 f2 ff ff       	jmp    105940 <alltraps>

00106648 <vector239>:
  106648:	6a 00                	push   $0x0
  10664a:	68 ef 00 00 00       	push   $0xef
  10664f:	e9 ec f2 ff ff       	jmp    105940 <alltraps>

00106654 <vector240>:
  106654:	6a 00                	push   $0x0
  106656:	68 f0 00 00 00       	push   $0xf0
  10665b:	e9 e0 f2 ff ff       	jmp    105940 <alltraps>

00106660 <vector241>:
  106660:	6a 00                	push   $0x0
  106662:	68 f1 00 00 00       	push   $0xf1
  106667:	e9 d4 f2 ff ff       	jmp    105940 <alltraps>

0010666c <vector242>:
  10666c:	6a 00                	push   $0x0
  10666e:	68 f2 00 00 00       	push   $0xf2
  106673:	e9 c8 f2 ff ff       	jmp    105940 <alltraps>

00106678 <vector243>:
  106678:	6a 00                	push   $0x0
  10667a:	68 f3 00 00 00       	push   $0xf3
  10667f:	e9 bc f2 ff ff       	jmp    105940 <alltraps>

00106684 <vector244>:
  106684:	6a 00                	push   $0x0
  106686:	68 f4 00 00 00       	push   $0xf4
  10668b:	e9 b0 f2 ff ff       	jmp    105940 <alltraps>

00106690 <vector245>:
  106690:	6a 00                	push   $0x0
  106692:	68 f5 00 00 00       	push   $0xf5
  106697:	e9 a4 f2 ff ff       	jmp    105940 <alltraps>

0010669c <vector246>:
  10669c:	6a 00                	push   $0x0
  10669e:	68 f6 00 00 00       	push   $0xf6
  1066a3:	e9 98 f2 ff ff       	jmp    105940 <alltraps>

001066a8 <vector247>:
  1066a8:	6a 00                	push   $0x0
  1066aa:	68 f7 00 00 00       	push   $0xf7
  1066af:	e9 8c f2 ff ff       	jmp    105940 <alltraps>

001066b4 <vector248>:
  1066b4:	6a 00                	push   $0x0
  1066b6:	68 f8 00 00 00       	push   $0xf8
  1066bb:	e9 80 f2 ff ff       	jmp    105940 <alltraps>

001066c0 <vector249>:
  1066c0:	6a 00                	push   $0x0
  1066c2:	68 f9 00 00 00       	push   $0xf9
  1066c7:	e9 74 f2 ff ff       	jmp    105940 <alltraps>

001066cc <vector250>:
  1066cc:	6a 00                	push   $0x0
  1066ce:	68 fa 00 00 00       	push   $0xfa
  1066d3:	e9 68 f2 ff ff       	jmp    105940 <alltraps>

001066d8 <vector251>:
  1066d8:	6a 00                	push   $0x0
  1066da:	68 fb 00 00 00       	push   $0xfb
  1066df:	e9 5c f2 ff ff       	jmp    105940 <alltraps>

001066e4 <vector252>:
  1066e4:	6a 00                	push   $0x0
  1066e6:	68 fc 00 00 00       	push   $0xfc
  1066eb:	e9 50 f2 ff ff       	jmp    105940 <alltraps>

001066f0 <vector253>:
  1066f0:	6a 00                	push   $0x0
  1066f2:	68 fd 00 00 00       	push   $0xfd
  1066f7:	e9 44 f2 ff ff       	jmp    105940 <alltraps>

001066fc <vector254>:
  1066fc:	6a 00                	push   $0x0
  1066fe:	68 fe 00 00 00       	push   $0xfe
  106703:	e9 38 f2 ff ff       	jmp    105940 <alltraps>

00106708 <vector255>:
  106708:	6a 00                	push   $0x0
  10670a:	68 ff 00 00 00       	push   $0xff
  10670f:	e9 2c f2 ff ff       	jmp    105940 <alltraps>
