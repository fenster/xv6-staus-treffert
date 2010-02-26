
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
  10000f:	c7 04 24 a0 9c 10 00 	movl   $0x109ca0,(%esp)
  100016:	e8 25 44 00 00       	call   104440 <acquire>

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
  10002a:	c7 43 0c 80 85 10 00 	movl   $0x108580,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 90 85 10 00       	mov    0x108590,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 90 85 10 00       	mov    0x108590,%eax
  bufhead.next = b;
  100041:	89 1d 90 85 10 00    	mov    %ebx,0x108590

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 a0 87 10 00 	movl   $0x1087a0,(%esp)
  100051:	e8 aa 32 00 00       	call   103300 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 a0 9c 10 00 	movl   $0x109ca0,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 99 43 00 00       	jmp    104400 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  10006e:	e8 6d 08 00 00       	call   1008e0 <panic>
  100073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100080 <bwrite>:
}

// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  100080:	55                   	push   %ebp
  100081:	89 e5                	mov    %esp,%ebp
  100083:	83 ec 18             	sub    $0x18,%esp
  100086:	8b 45 08             	mov    0x8(%ebp),%eax
  if((b->flags & B_BUSY) == 0)
  100089:	8b 10                	mov    (%eax),%edx
  10008b:	f6 c2 01             	test   $0x1,%dl
  10008e:	74 0e                	je     10009e <bwrite+0x1e>
    panic("bwrite");
  b->flags |= B_DIRTY;
  100090:	83 ca 04             	or     $0x4,%edx
  100093:	89 10                	mov    %edx,(%eax)
  ide_rw(b);
  100095:	89 45 08             	mov    %eax,0x8(%ebp)
}
  100098:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  ide_rw(b);
  100099:	e9 62 1f 00 00       	jmp    102000 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10009e:	c7 04 24 a7 65 10 00 	movl   $0x1065a7,(%esp)
  1000a5:	e8 36 08 00 00       	call   1008e0 <panic>
  1000aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001000b0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  1000b0:	55                   	push   %ebp
  1000b1:	89 e5                	mov    %esp,%ebp
  1000b3:	57                   	push   %edi
  1000b4:	56                   	push   %esi
  1000b5:	53                   	push   %ebx
  1000b6:	83 ec 1c             	sub    $0x1c,%esp
  1000b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&buf_table_lock);
  1000bf:	c7 04 24 a0 9c 10 00 	movl   $0x109ca0,(%esp)
  1000c6:	e8 75 43 00 00       	call   104440 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  1000cb:	8b 1d 90 85 10 00    	mov    0x108590,%ebx
  1000d1:	81 fb 80 85 10 00    	cmp    $0x108580,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 3d                	jmp    100118 <bread+0x68>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb 80 85 10 00    	cmp    $0x108580,%ebx
  1000e9:	74 2d                	je     100118 <bread+0x68>
    if((b->flags & (B_BUSY|B_VALID)) &&
  1000eb:	8b 03                	mov    (%ebx),%eax
  1000ed:	a8 03                	test   $0x3,%al
  1000ef:	74 ef                	je     1000e0 <bread+0x30>
  1000f1:	3b 73 04             	cmp    0x4(%ebx),%esi
  1000f4:	75 ea                	jne    1000e0 <bread+0x30>
  1000f6:	3b 7b 08             	cmp    0x8(%ebx),%edi
  1000f9:	75 e5                	jne    1000e0 <bread+0x30>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
  1000fb:	a8 01                	test   $0x1,%al
  1000fd:	8d 76 00             	lea    0x0(%esi),%esi
  100100:	74 71                	je     100173 <bread+0xc3>
        sleep(buf, &buf_table_lock);
  100102:	c7 44 24 04 a0 9c 10 	movl   $0x109ca0,0x4(%esp)
  100109:	00 
  10010a:	c7 04 24 a0 87 10 00 	movl   $0x1087a0,(%esp)
  100111:	e8 9a 35 00 00       	call   1036b0 <sleep>
  100116:	eb b3                	jmp    1000cb <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100118:	8b 1d 8c 85 10 00    	mov    0x10858c,%ebx
  10011e:	81 fb 80 85 10 00    	cmp    $0x108580,%ebx
  100124:	75 0d                	jne    100133 <bread+0x83>
  100126:	eb 3f                	jmp    100167 <bread+0xb7>
  100128:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10012b:	81 fb 80 85 10 00    	cmp    $0x108580,%ebx
  100131:	74 34                	je     100167 <bread+0xb7>
    if((b->flags & B_BUSY) == 0){
  100133:	f6 03 01             	testb  $0x1,(%ebx)
  100136:	75 f0                	jne    100128 <bread+0x78>
      b->flags = B_BUSY;
  100138:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      b->dev = dev;
  10013e:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  100141:	89 7b 08             	mov    %edi,0x8(%ebx)
      release(&buf_table_lock);
  100144:	c7 04 24 a0 9c 10 00 	movl   $0x109ca0,(%esp)
  10014b:	e8 b0 42 00 00       	call   104400 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  100150:	f6 03 02             	testb  $0x2,(%ebx)
  100153:	75 08                	jne    10015d <bread+0xad>
    ide_rw(b);
  100155:	89 1c 24             	mov    %ebx,(%esp)
  100158:	e8 a3 1e 00 00       	call   102000 <ide_rw>
  return b;
}
  10015d:	83 c4 1c             	add    $0x1c,%esp
  100160:	89 d8                	mov    %ebx,%eax
  100162:	5b                   	pop    %ebx
  100163:	5e                   	pop    %esi
  100164:	5f                   	pop    %edi
  100165:	5d                   	pop    %ebp
  100166:	c3                   	ret    
      b->sector = sector;
      release(&buf_table_lock);
      return b;
    }
  }
  panic("bget: no buffers");
  100167:	c7 04 24 ae 65 10 00 	movl   $0x1065ae,(%esp)
  10016e:	e8 6d 07 00 00       	call   1008e0 <panic>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
        sleep(buf, &buf_table_lock);
        goto loop;
      }
      b->flags |= B_BUSY;
  100173:	83 c8 01             	or     $0x1,%eax
  100176:	89 03                	mov    %eax,(%ebx)
      release(&buf_table_lock);
  100178:	c7 04 24 a0 9c 10 00 	movl   $0x109ca0,(%esp)
  10017f:	e8 7c 42 00 00       	call   104400 <release>
  100184:	eb ca                	jmp    100150 <bread+0xa0>
  100186:	8d 76 00             	lea    0x0(%esi),%esi
  100189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100190 <binit>:
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
{
  100190:	55                   	push   %ebp
  100191:	89 e5                	mov    %esp,%ebp
  100193:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");
  100196:	c7 44 24 04 bf 65 10 	movl   $0x1065bf,0x4(%esp)
  10019d:	00 
  10019e:	c7 04 24 a0 9c 10 00 	movl   $0x109ca0,(%esp)
  1001a5:	e8 d6 40 00 00       	call   104280 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001aa:	b8 90 9c 10 00       	mov    $0x109c90,%eax
  1001af:	3d a0 87 10 00       	cmp    $0x1087a0,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  1001b4:	c7 05 8c 85 10 00 80 	movl   $0x108580,0x10858c
  1001bb:	85 10 00 
  bufhead.next = &bufhead;
  1001be:	c7 05 90 85 10 00 80 	movl   $0x108580,0x108590
  1001c5:	85 10 00 
  for(b = buf; b < buf+NBUF; b++){
  1001c8:	76 33                	jbe    1001fd <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  1001ca:	ba 80 85 10 00       	mov    $0x108580,%edx
  1001cf:	b8 a0 87 10 00       	mov    $0x1087a0,%eax
  1001d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  1001d8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  1001db:	c7 40 0c 80 85 10 00 	movl   $0x108580,0xc(%eax)
    bufhead.next->prev = b;
  1001e2:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001e5:	89 c2                	mov    %eax,%edx
  1001e7:	05 18 02 00 00       	add    $0x218,%eax
  1001ec:	3d 90 9c 10 00       	cmp    $0x109c90,%eax
  1001f1:	75 e5                	jne    1001d8 <binit+0x48>
  1001f3:	c7 05 90 85 10 00 78 	movl   $0x109a78,0x108590
  1001fa:	9a 10 00 
    b->next = bufhead.next;
    b->prev = &bufhead;
    bufhead.next->prev = b;
    bufhead.next = b;
  }
}
  1001fd:	c9                   	leave  
  1001fe:	c3                   	ret    
  1001ff:	90                   	nop

00100200 <console_init>:
  return target - n;
}

void
console_init(void)
{
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 18             	sub    $0x18,%esp
  initlock(&console_lock, "console");
  100206:	c7 44 24 04 c9 65 10 	movl   $0x1065c9,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 e0 84 10 00 	movl   $0x1084e0,(%esp)
  100215:	e8 66 40 00 00       	call   104280 <initlock>
  initlock(&input.lock, "console input");
  10021a:	c7 44 24 04 d1 65 10 	movl   $0x1065d1,0x4(%esp)
  100221:	00 
  100222:	c7 04 24 e0 9c 10 00 	movl   $0x109ce0,(%esp)
  100229:	e8 52 40 00 00       	call   104280 <initlock>

  devsw[CONSOLE].write = console_write;
  devsw[CONSOLE].read = console_read;
  use_console_lock = 1;

  pic_enable(IRQ_KBD);
  10022e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
console_init(void)
{
  initlock(&console_lock, "console");
  initlock(&input.lock, "console input");

  devsw[CONSOLE].write = console_write;
  100235:	c7 05 4c a7 10 00 50 	movl   $0x100650,0x10a74c
  10023c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10023f:	c7 05 48 a7 10 00 70 	movl   $0x100270,0x10a748
  100246:	02 10 00 
  use_console_lock = 1;
  100249:	c7 05 c4 84 10 00 01 	movl   $0x1,0x1084c4
  100250:	00 00 00 

  pic_enable(IRQ_KBD);
  100253:	e8 b8 2a 00 00       	call   102d10 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  100258:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10025f:	00 
  100260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100267:	e8 84 1f 00 00       	call   1021f0 <ioapic_enable>
}
  10026c:	c9                   	leave  
  10026d:	c3                   	ret    
  10026e:	66 90                	xchg   %ax,%ax

00100270 <console_read>:
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  100270:	55                   	push   %ebp
  100271:	89 e5                	mov    %esp,%ebp
  100273:	57                   	push   %edi
  100274:	56                   	push   %esi
  100275:	53                   	push   %ebx
  100276:	83 ec 2c             	sub    $0x2c,%esp
  100279:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10027c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  10027f:	89 34 24             	mov    %esi,(%esp)
  100282:	e8 59 19 00 00       	call   101be0 <iunlock>
  target = n;
  100287:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10028a:	c7 04 24 e0 9c 10 00 	movl   $0x109ce0,(%esp)
  100291:	e8 aa 41 00 00       	call   104440 <acquire>
  while(n > 0){
  100296:	85 db                	test   %ebx,%ebx
  100298:	7f 26                	jg     1002c0 <console_read+0x50>
  10029a:	e9 bb 00 00 00       	jmp    10035a <console_read+0xea>
  10029f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  1002a0:	e8 5b 31 00 00       	call   103400 <curproc>
  1002a5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1002a8:	85 c0                	test   %eax,%eax
  1002aa:	75 5c                	jne    100308 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  1002ac:	c7 44 24 04 e0 9c 10 	movl   $0x109ce0,0x4(%esp)
  1002b3:	00 
  1002b4:	c7 04 24 94 9d 10 00 	movl   $0x109d94,(%esp)
  1002bb:	e8 f0 33 00 00       	call   1036b0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1002c0:	a1 94 9d 10 00       	mov    0x109d94,%eax
  1002c5:	3b 05 98 9d 10 00    	cmp    0x109d98,%eax
  1002cb:	74 d3                	je     1002a0 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  1002cd:	89 c2                	mov    %eax,%edx
  1002cf:	83 e2 7f             	and    $0x7f,%edx
  1002d2:	0f b6 8a 14 9d 10 00 	movzbl 0x109d14(%edx),%ecx
  1002d9:	8d 78 01             	lea    0x1(%eax),%edi
  1002dc:	89 3d 94 9d 10 00    	mov    %edi,0x109d94
  1002e2:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
  1002e5:	83 fa 04             	cmp    $0x4,%edx
  1002e8:	74 3f                	je     100329 <console_read+0xb9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    --n;
  1002ed:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  1002f0:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1002f3:	88 08                	mov    %cl,(%eax)
    --n;
    if(c == '\n')
  1002f5:	74 3c                	je     100333 <console_read+0xc3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  1002f7:	85 db                	test   %ebx,%ebx
  1002f9:	7e 38                	jle    100333 <console_read+0xc3>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1002fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  1002ff:	eb bf                	jmp    1002c0 <console_read+0x50>
  100301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100308:	c7 04 24 e0 9c 10 00 	movl   $0x109ce0,(%esp)
  10030f:	e8 ec 40 00 00       	call   104400 <release>
        ilock(ip);
  100314:	89 34 24             	mov    %esi,(%esp)
  100317:	e8 34 19 00 00       	call   101c50 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  10031c:	83 c4 2c             	add    $0x2c,%esp
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
        ilock(ip);
  10031f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  100324:	5b                   	pop    %ebx
  100325:	5e                   	pop    %esi
  100326:	5f                   	pop    %edi
  100327:	5d                   	pop    %ebp
  100328:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  100329:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  10032c:	76 05                	jbe    100333 <console_read+0xc3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  10032e:	a3 94 9d 10 00       	mov    %eax,0x109d94
  100333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100336:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  100338:	c7 04 24 e0 9c 10 00 	movl   $0x109ce0,(%esp)
  10033f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  100342:	e8 b9 40 00 00       	call   104400 <release>
  ilock(ip);
  100347:	89 34 24             	mov    %esi,(%esp)
  10034a:	e8 01 19 00 00       	call   101c50 <ilock>
  10034f:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
  100352:	83 c4 2c             	add    $0x2c,%esp
  100355:	5b                   	pop    %ebx
  100356:	5e                   	pop    %esi
  100357:	5f                   	pop    %edi
  100358:	5d                   	pop    %ebp
  100359:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  10035a:	31 c0                	xor    %eax,%eax
  10035c:	eb da                	jmp    100338 <console_read+0xc8>
  10035e:	66 90                	xchg   %ax,%ax

00100360 <cons_putc>:
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  100360:	55                   	push   %ebp
  100361:	89 e5                	mov    %esp,%ebp
  100363:	57                   	push   %edi
  100364:	56                   	push   %esi
  100365:	53                   	push   %ebx
  100366:	83 ec 1c             	sub    $0x1c,%esp
  100369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(panicked){
  10036c:	83 3d c0 84 10 00 00 	cmpl   $0x0,0x1084c0
  100373:	0f 85 e1 00 00 00    	jne    10045a <cons_putc+0xfa>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100379:	b8 79 03 00 00       	mov    $0x379,%eax
  10037e:	89 c2                	mov    %eax,%edx
  100380:	ec                   	in     (%dx),%al
}

static inline void
cli(void)
{
  asm volatile("cli");
  100381:	31 db                	xor    %ebx,%ebx
static void
lpt_putc(int c)
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
  100383:	84 c0                	test   %al,%al
  100385:	79 14                	jns    10039b <cons_putc+0x3b>
  100387:	eb 19                	jmp    1003a2 <cons_putc+0x42>
  100389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100390:	83 c3 01             	add    $0x1,%ebx
  100393:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
  100399:	74 07                	je     1003a2 <cons_putc+0x42>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10039b:	ec                   	in     (%dx),%al
  10039c:	84 c0                	test   %al,%al
  10039e:	66 90                	xchg   %ax,%ax
  1003a0:	79 ee                	jns    100390 <cons_putc+0x30>
    ;
  if(c == BACKSPACE)
  1003a2:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  1003a8:	89 c8                	mov    %ecx,%eax
  1003aa:	0f 84 ad 00 00 00    	je     10045d <cons_putc+0xfd>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1003b0:	ba 78 03 00 00       	mov    $0x378,%edx
  1003b5:	ee                   	out    %al,(%dx)
  1003b6:	b8 0d 00 00 00       	mov    $0xd,%eax
  1003bb:	b2 7a                	mov    $0x7a,%dl
  1003bd:	ee                   	out    %al,(%dx)
  1003be:	b8 08 00 00 00       	mov    $0x8,%eax
  1003c3:	ee                   	out    %al,(%dx)
  1003c4:	be d4 03 00 00       	mov    $0x3d4,%esi
  1003c9:	b8 0e 00 00 00       	mov    $0xe,%eax
  1003ce:	89 f2                	mov    %esi,%edx
  1003d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003d1:	bf d5 03 00 00       	mov    $0x3d5,%edi
  1003d6:	89 fa                	mov    %edi,%edx
  1003d8:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  1003d9:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1003dc:	89 f2                	mov    %esi,%edx
  1003de:	c1 e3 08             	shl    $0x8,%ebx
  1003e1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1003e6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003e7:	89 fa                	mov    %edi,%edx
  1003e9:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  1003ea:	0f b6 c0             	movzbl %al,%eax
  1003ed:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  1003ef:	83 f9 0a             	cmp    $0xa,%ecx
  1003f2:	0f 84 da 00 00 00    	je     1004d2 <cons_putc+0x172>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  1003f8:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
  1003fe:	0f 84 ad 00 00 00    	je     1004b1 <cons_putc+0x151>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  100404:	66 81 e1 ff 00       	and    $0xff,%cx
  100409:	80 cd 07             	or     $0x7,%ch
  10040c:	66 89 8c 1b 00 80 0b 	mov    %cx,0xb8000(%ebx,%ebx,1)
  100413:	00 
  100414:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  100417:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  10041d:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  100424:	7f 41                	jg     100467 <cons_putc+0x107>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100426:	be d4 03 00 00       	mov    $0x3d4,%esi
  10042b:	b8 0e 00 00 00       	mov    $0xe,%eax
  100430:	89 f2                	mov    %esi,%edx
  100432:	ee                   	out    %al,(%dx)
  100433:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100438:	89 d8                	mov    %ebx,%eax
  10043a:	c1 f8 08             	sar    $0x8,%eax
  10043d:	89 fa                	mov    %edi,%edx
  10043f:	ee                   	out    %al,(%dx)
  100440:	b8 0f 00 00 00       	mov    $0xf,%eax
  100445:	89 f2                	mov    %esi,%edx
  100447:	ee                   	out    %al,(%dx)
  100448:	89 d8                	mov    %ebx,%eax
  10044a:	89 fa                	mov    %edi,%edx
  10044c:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  10044d:	66 c7 01 20 07       	movw   $0x720,(%ecx)
      ;
  }

  lpt_putc(c);
  cga_putc(c);
}
  100452:	83 c4 1c             	add    $0x1c,%esp
  100455:	5b                   	pop    %ebx
  100456:	5e                   	pop    %esi
  100457:	5f                   	pop    %edi
  100458:	5d                   	pop    %ebp
  100459:	c3                   	ret    
}

static inline void
cli(void)
{
  asm volatile("cli");
  10045a:	fa                   	cli    
  10045b:	eb fe                	jmp    10045b <cons_putc+0xfb>
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
    ;
  if(c == BACKSPACE)
  10045d:	b8 08 00 00 00       	mov    $0x8,%eax
  100462:	e9 49 ff ff ff       	jmp    1003b0 <cons_putc+0x50>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  100467:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  10046a:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  100471:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100472:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  100479:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  100480:	00 
  100481:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  100488:	e8 b3 40 00 00       	call   104540 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10048d:	b8 80 07 00 00       	mov    $0x780,%eax
  100492:	29 d8                	sub    %ebx,%eax
  100494:	01 c0                	add    %eax,%eax
  100496:	89 44 24 08          	mov    %eax,0x8(%esp)
  10049a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1004a1:	00 
  1004a2:	89 34 24             	mov    %esi,(%esp)
  1004a5:	e8 06 40 00 00       	call   1044b0 <memset>
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
  1004aa:	89 f1                	mov    %esi,%ecx
  1004ac:	e9 75 ff ff ff       	jmp    100426 <cons_putc+0xc6>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  1004b1:	85 db                	test   %ebx,%ebx
  1004b3:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  1004ba:	0f 8e 66 ff ff ff    	jle    100426 <cons_putc+0xc6>
      crt[--pos] = ' ' | 0x0700;
  1004c0:	83 eb 01             	sub    $0x1,%ebx
  1004c3:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  1004ca:	00 20 07 
  1004cd:	e9 45 ff ff ff       	jmp    100417 <cons_putc+0xb7>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  1004d2:	b8 50 00 00 00       	mov    $0x50,%eax
  1004d7:	89 da                	mov    %ebx,%edx
  1004d9:	89 c1                	mov    %eax,%ecx
  1004db:	89 d8                	mov    %ebx,%eax
  1004dd:	c1 fa 1f             	sar    $0x1f,%edx
  1004e0:	83 c3 50             	add    $0x50,%ebx
  1004e3:	f7 f9                	idiv   %ecx
  1004e5:	29 d3                	sub    %edx,%ebx
  1004e7:	e9 2b ff ff ff       	jmp    100417 <cons_putc+0xb7>
  1004ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001004f0 <console_intr>:

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  1004f0:	55                   	push   %ebp
  1004f1:	89 e5                	mov    %esp,%ebp
  1004f3:	56                   	push   %esi
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  1004f4:	be 10 9d 10 00       	mov    $0x109d10,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  1004f9:	53                   	push   %ebx
  1004fa:	83 ec 20             	sub    $0x20,%esp
  1004fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100500:	c7 04 24 e0 9c 10 00 	movl   $0x109ce0,(%esp)
  100507:	e8 34 3f 00 00       	call   104440 <acquire>
  10050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((c = getc()) >= 0){
  100510:	ff d3                	call   *%ebx
  100512:	85 c0                	test   %eax,%eax
  100514:	0f 88 8e 00 00 00    	js     1005a8 <console_intr+0xb8>
    switch(c){
  10051a:	83 f8 10             	cmp    $0x10,%eax
  10051d:	8d 76 00             	lea    0x0(%esi),%esi
  100520:	0f 84 d2 00 00 00    	je     1005f8 <console_intr+0x108>
  100526:	83 f8 15             	cmp    $0x15,%eax
  100529:	0f 84 b7 00 00 00    	je     1005e6 <console_intr+0xf6>
  10052f:	83 f8 08             	cmp    $0x8,%eax
  100532:	0f 84 d0 00 00 00    	je     100608 <console_intr+0x118>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100538:	85 c0                	test   %eax,%eax
  10053a:	74 d4                	je     100510 <console_intr+0x20>
  10053c:	8b 15 9c 9d 10 00    	mov    0x109d9c,%edx
  100542:	89 d1                	mov    %edx,%ecx
  100544:	2b 0d 94 9d 10 00    	sub    0x109d94,%ecx
  10054a:	83 f9 7f             	cmp    $0x7f,%ecx
  10054d:	77 c1                	ja     100510 <console_intr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
  10054f:	89 d1                	mov    %edx,%ecx
  100551:	83 c2 01             	add    $0x1,%edx
  100554:	83 e1 7f             	and    $0x7f,%ecx
  100557:	88 44 0e 04          	mov    %al,0x4(%esi,%ecx,1)
        cons_putc(c);
  10055b:	89 04 24             	mov    %eax,(%esp)
  10055e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
  100561:	89 15 9c 9d 10 00    	mov    %edx,0x109d9c
        cons_putc(c);
  100567:	e8 f4 fd ff ff       	call   100360 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10056c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10056f:	83 f8 04             	cmp    $0x4,%eax
  100572:	0f 84 ba 00 00 00    	je     100632 <console_intr+0x142>
  100578:	83 f8 0a             	cmp    $0xa,%eax
  10057b:	0f 84 b1 00 00 00    	je     100632 <console_intr+0x142>
  100581:	8b 15 94 9d 10 00    	mov    0x109d94,%edx
  100587:	a1 9c 9d 10 00       	mov    0x109d9c,%eax
  10058c:	83 ea 80             	sub    $0xffffff80,%edx
  10058f:	39 d0                	cmp    %edx,%eax
  100591:	0f 84 a0 00 00 00    	je     100637 <console_intr+0x147>
console_intr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  100597:	ff d3                	call   *%ebx
  100599:	85 c0                	test   %eax,%eax
  10059b:	0f 89 79 ff ff ff    	jns    10051a <console_intr+0x2a>
  1005a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&input.lock);
  1005a8:	c7 45 08 e0 9c 10 00 	movl   $0x109ce0,0x8(%ebp)
}
  1005af:	83 c4 20             	add    $0x20,%esp
  1005b2:	5b                   	pop    %ebx
  1005b3:	5e                   	pop    %esi
  1005b4:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  1005b5:	e9 46 3e 00 00       	jmp    104400 <release>
  1005ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1005c0:	83 e8 01             	sub    $0x1,%eax
  1005c3:	89 c2                	mov    %eax,%edx
  1005c5:	83 e2 7f             	and    $0x7f,%edx
  1005c8:	80 ba 14 9d 10 00 0a 	cmpb   $0xa,0x109d14(%edx)
  1005cf:	0f 84 3b ff ff ff    	je     100510 <console_intr+0x20>
        input.e--;
  1005d5:	a3 9c 9d 10 00       	mov    %eax,0x109d9c
        cons_putc(BACKSPACE);
  1005da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1005e1:	e8 7a fd ff ff       	call   100360 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1005e6:	a1 9c 9d 10 00       	mov    0x109d9c,%eax
  1005eb:	3b 05 98 9d 10 00    	cmp    0x109d98,%eax
  1005f1:	75 cd                	jne    1005c0 <console_intr+0xd0>
  1005f3:	e9 18 ff ff ff       	jmp    100510 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  1005f8:	e8 a3 2b 00 00       	call   1031a0 <procdump>
  1005fd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
  100600:	e9 0b ff ff ff       	jmp    100510 <console_intr+0x20>
  100605:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  100608:	a1 9c 9d 10 00       	mov    0x109d9c,%eax
  10060d:	3b 05 98 9d 10 00    	cmp    0x109d98,%eax
  100613:	0f 84 f7 fe ff ff    	je     100510 <console_intr+0x20>
        input.e--;
  100619:	83 e8 01             	sub    $0x1,%eax
  10061c:	a3 9c 9d 10 00       	mov    %eax,0x109d9c
        cons_putc(BACKSPACE);
  100621:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100628:	e8 33 fd ff ff       	call   100360 <cons_putc>
  10062d:	e9 de fe ff ff       	jmp    100510 <console_intr+0x20>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        cons_putc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100632:	a1 9c 9d 10 00       	mov    0x109d9c,%eax
          input.w = input.e;
  100637:	a3 98 9d 10 00       	mov    %eax,0x109d98
          wakeup(&input.r);
  10063c:	c7 04 24 94 9d 10 00 	movl   $0x109d94,(%esp)
  100643:	e8 b8 2c 00 00       	call   103300 <wakeup>
  100648:	e9 c3 fe ff ff       	jmp    100510 <console_intr+0x20>
  10064d:	8d 76 00             	lea    0x0(%esi),%esi

00100650 <console_write>:
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  100650:	55                   	push   %ebp
  100651:	89 e5                	mov    %esp,%ebp
  100653:	57                   	push   %edi
  100654:	56                   	push   %esi
  100655:	53                   	push   %ebx
  100656:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
  100659:	8b 45 08             	mov    0x8(%ebp),%eax
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  10065c:	8b 75 10             	mov    0x10(%ebp),%esi
  10065f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  100662:	89 04 24             	mov    %eax,(%esp)
  100665:	e8 76 15 00 00       	call   101be0 <iunlock>
  acquire(&console_lock);
  10066a:	c7 04 24 e0 84 10 00 	movl   $0x1084e0,(%esp)
  100671:	e8 ca 3d 00 00       	call   104440 <acquire>
  for(i = 0; i < n; i++)
  100676:	85 f6                	test   %esi,%esi
  100678:	7e 19                	jle    100693 <console_write+0x43>
  10067a:	31 db                	xor    %ebx,%ebx
  10067c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cons_putc(buf[i] & 0xff);
  100680:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  100684:	83 c3 01             	add    $0x1,%ebx
    cons_putc(buf[i] & 0xff);
  100687:	89 14 24             	mov    %edx,(%esp)
  10068a:	e8 d1 fc ff ff       	call   100360 <cons_putc>
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  10068f:	39 de                	cmp    %ebx,%esi
  100691:	7f ed                	jg     100680 <console_write+0x30>
    cons_putc(buf[i] & 0xff);
  release(&console_lock);
  100693:	c7 04 24 e0 84 10 00 	movl   $0x1084e0,(%esp)
  10069a:	e8 61 3d 00 00       	call   104400 <release>
  ilock(ip);
  10069f:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a2:	89 04 24             	mov    %eax,(%esp)
  1006a5:	e8 a6 15 00 00       	call   101c50 <ilock>

  return n;
}
  1006aa:	83 c4 1c             	add    $0x1c,%esp
  1006ad:	89 f0                	mov    %esi,%eax
  1006af:	5b                   	pop    %ebx
  1006b0:	5e                   	pop    %esi
  1006b1:	5f                   	pop    %edi
  1006b2:	5d                   	pop    %ebp
  1006b3:	c3                   	ret    
  1006b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1006ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001006c0 <printint>:
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  1006c0:	55                   	push   %ebp
  1006c1:	89 e5                	mov    %esp,%ebp
  1006c3:	57                   	push   %edi
  1006c4:	56                   	push   %esi
  1006c5:	53                   	push   %ebx
  1006c6:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  1006c9:	8b 55 10             	mov    0x10(%ebp),%edx
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  1006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  1006d2:	85 d2                	test   %edx,%edx
  1006d4:	74 04                	je     1006da <printint+0x1a>
  1006d6:	85 c0                	test   %eax,%eax
  1006d8:	78 54                	js     10072e <printint+0x6e>
    neg = 1;
    x = 0 - xx;
  } else {
    x = xx;
  1006da:	31 ff                	xor    %edi,%edi
  1006dc:	31 c9                	xor    %ecx,%ecx
  1006de:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  1006e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  do{
    buf[i++] = digits[x % base];
  1006e8:	31 d2                	xor    %edx,%edx
  1006ea:	f7 f6                	div    %esi
  1006ec:	0f b6 92 f9 65 10 00 	movzbl 0x1065f9(%edx),%edx
  1006f3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  1006f6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
  1006f9:	85 c0                	test   %eax,%eax
  1006fb:	75 eb                	jne    1006e8 <printint+0x28>
  if(neg)
  1006fd:	85 ff                	test   %edi,%edi
  1006ff:	74 08                	je     100709 <printint+0x49>
    buf[i++] = '-';
  100701:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
  100706:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
  100709:	8d 71 ff             	lea    -0x1(%ecx),%esi
  10070c:	01 f3                	add    %esi,%ebx
  10070e:	66 90                	xchg   %ax,%ax
    cons_putc(buf[i]);
  100710:	0f be 03             	movsbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100713:	83 ee 01             	sub    $0x1,%esi
  100716:	83 eb 01             	sub    $0x1,%ebx
    cons_putc(buf[i]);
  100719:	89 04 24             	mov    %eax,(%esp)
  10071c:	e8 3f fc ff ff       	call   100360 <cons_putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100721:	83 fe ff             	cmp    $0xffffffff,%esi
  100724:	75 ea                	jne    100710 <printint+0x50>
    cons_putc(buf[i]);
}
  100726:	83 c4 2c             	add    $0x2c,%esp
  100729:	5b                   	pop    %ebx
  10072a:	5e                   	pop    %esi
  10072b:	5f                   	pop    %edi
  10072c:	5d                   	pop    %ebp
  10072d:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  10072e:	f7 d8                	neg    %eax
  100730:	bf 01 00 00 00       	mov    $0x1,%edi
  100735:	eb a5                	jmp    1006dc <printint+0x1c>
  100737:	89 f6                	mov    %esi,%esi
  100739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100740 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  100740:	55                   	push   %ebp
  100741:	89 e5                	mov    %esp,%ebp
  100743:	57                   	push   %edi
  100744:	56                   	push   %esi
  100745:	53                   	push   %ebx
  100746:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100749:	a1 c4 84 10 00       	mov    0x1084c4,%eax
  if(locking)
  10074e:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
  100753:	0f 85 67 01 00 00    	jne    1008c0 <cprintf+0x180>
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100759:	8b 55 08             	mov    0x8(%ebp),%edx
  10075c:	0f b6 02             	movzbl (%edx),%eax
  10075f:	84 c0                	test   %al,%al
  100761:	0f 84 81 00 00 00    	je     1007e8 <cprintf+0xa8>

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  100767:	8d 7d 0c             	lea    0xc(%ebp),%edi
  10076a:	31 f6                	xor    %esi,%esi
  10076c:	31 db                	xor    %ebx,%ebx
  10076e:	eb 1b                	jmp    10078b <cprintf+0x4b>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    switch(state){
    case 0:
      if(c == '%')
  100770:	83 f8 25             	cmp    $0x25,%eax
  100773:	0f 85 8f 00 00 00    	jne    100808 <cprintf+0xc8>
  100779:	be 25 00 00 00       	mov    $0x25,%esi
  10077e:	66 90                	xchg   %ax,%ax
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100780:	83 c3 01             	add    $0x1,%ebx
  100783:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  100787:	84 c0                	test   %al,%al
  100789:	74 5d                	je     1007e8 <cprintf+0xa8>
    c = fmt[i] & 0xff;
    switch(state){
  10078b:	85 f6                	test   %esi,%esi
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  10078d:	0f b6 c0             	movzbl %al,%eax
    switch(state){
  100790:	74 de                	je     100770 <cprintf+0x30>
  100792:	83 fe 25             	cmp    $0x25,%esi
  100795:	75 e9                	jne    100780 <cprintf+0x40>
      else
        cons_putc(c);
      break;
    
    case '%':
      switch(c){
  100797:	83 f8 70             	cmp    $0x70,%eax
  10079a:	0f 84 82 00 00 00    	je     100822 <cprintf+0xe2>
  1007a0:	7f 76                	jg     100818 <cprintf+0xd8>
  1007a2:	83 f8 25             	cmp    $0x25,%eax
  1007a5:	8d 76 00             	lea    0x0(%esi),%esi
  1007a8:	0f 84 fa 00 00 00    	je     1008a8 <cprintf+0x168>
  1007ae:	83 f8 64             	cmp    $0x64,%eax
  1007b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1007b8:	0f 84 c2 00 00 00    	je     100880 <cprintf+0x140>
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  1007be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007c1:	83 c3 01             	add    $0x1,%ebx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  1007c4:	31 f6                	xor    %esi,%esi
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  1007c6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1007cd:	e8 8e fb ff ff       	call   100360 <cons_putc>
        cons_putc(c);
  1007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007d5:	89 04 24             	mov    %eax,(%esp)
  1007d8:	e8 83 fb ff ff       	call   100360 <cons_putc>
  1007dd:	8b 55 08             	mov    0x8(%ebp),%edx
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007e0:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
  1007e4:	84 c0                	test   %al,%al
  1007e6:	75 a3                	jne    10078b <cprintf+0x4b>
      state = 0;
      break;
    }
  }

  if(locking)
  1007e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1007eb:	85 c9                	test   %ecx,%ecx
  1007ed:	74 0c                	je     1007fb <cprintf+0xbb>
    release(&console_lock);
  1007ef:	c7 04 24 e0 84 10 00 	movl   $0x1084e0,(%esp)
  1007f6:	e8 05 3c 00 00       	call   104400 <release>
}
  1007fb:	83 c4 2c             	add    $0x2c,%esp
  1007fe:	5b                   	pop    %ebx
  1007ff:	5e                   	pop    %esi
  100800:	5f                   	pop    %edi
  100801:	5d                   	pop    %ebp
  100802:	c3                   	ret    
  100803:	90                   	nop
  100804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(state){
    case 0:
      if(c == '%')
        state = '%';
      else
        cons_putc(c);
  100808:	89 04 24             	mov    %eax,(%esp)
  10080b:	e8 50 fb ff ff       	call   100360 <cons_putc>
  100810:	8b 55 08             	mov    0x8(%ebp),%edx
  100813:	e9 68 ff ff ff       	jmp    100780 <cprintf+0x40>
      break;
    
    case '%':
      switch(c){
  100818:	83 f8 73             	cmp    $0x73,%eax
  10081b:	74 33                	je     100850 <cprintf+0x110>
  10081d:	83 f8 78             	cmp    $0x78,%eax
  100820:	75 9c                	jne    1007be <cprintf+0x7e>
      case 'd':
        printint(*argp++, 10, 1);
        break;
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
  100822:	8b 07                	mov    (%edi),%eax
  100824:	31 f6                	xor    %esi,%esi
  100826:	83 c7 04             	add    $0x4,%edi
  100829:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100830:	00 
  100831:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100838:	00 
  100839:	89 04 24             	mov    %eax,(%esp)
  10083c:	e8 7f fe ff ff       	call   1006c0 <printint>
  100841:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  100844:	e9 37 ff ff ff       	jmp    100780 <cprintf+0x40>
  100849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      case 's':
        s = (char*)*argp++;
  100850:	8b 37                	mov    (%edi),%esi
  100852:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
  100855:	85 f6                	test   %esi,%esi
  100857:	74 78                	je     1008d1 <cprintf+0x191>
          s = "(null)";
        for(; *s; s++)
  100859:	0f b6 06             	movzbl (%esi),%eax
  10085c:	84 c0                	test   %al,%al
  10085e:	74 18                	je     100878 <cprintf+0x138>
          cons_putc(*s);
  100860:	0f be c0             	movsbl %al,%eax
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  100863:	83 c6 01             	add    $0x1,%esi
          cons_putc(*s);
  100866:	89 04 24             	mov    %eax,(%esp)
  100869:	e8 f2 fa ff ff       	call   100360 <cons_putc>
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  10086e:	0f b6 06             	movzbl (%esi),%eax
  100871:	84 c0                	test   %al,%al
  100873:	75 eb                	jne    100860 <cprintf+0x120>
  100875:	8b 55 08             	mov    0x8(%ebp),%edx
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  100878:	31 f6                	xor    %esi,%esi
  10087a:	e9 01 ff ff ff       	jmp    100780 <cprintf+0x40>
  10087f:	90                   	nop
      break;
    
    case '%':
      switch(c){
      case 'd':
        printint(*argp++, 10, 1);
  100880:	8b 07                	mov    (%edi),%eax
  100882:	31 f6                	xor    %esi,%esi
  100884:	83 c7 04             	add    $0x4,%edi
  100887:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10088e:	00 
  10088f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  100896:	00 
  100897:	89 04 24             	mov    %eax,(%esp)
  10089a:	e8 21 fe ff ff       	call   1006c0 <printint>
  10089f:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  1008a2:	e9 d9 fe ff ff       	jmp    100780 <cprintf+0x40>
  1008a7:	90                   	nop
          s = "(null)";
        for(; *s; s++)
          cons_putc(*s);
        break;
      case '%':
        cons_putc('%');
  1008a8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1008af:	31 f6                	xor    %esi,%esi
  1008b1:	e8 aa fa ff ff       	call   100360 <cons_putc>
  1008b6:	8b 55 08             	mov    0x8(%ebp),%edx
        break;
  1008b9:	e9 c2 fe ff ff       	jmp    100780 <cprintf+0x40>
  1008be:	66 90                	xchg   %ax,%ax
  uint *argp;
  char *s;

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);
  1008c0:	c7 04 24 e0 84 10 00 	movl   $0x1084e0,(%esp)
  1008c7:	e8 74 3b 00 00       	call   104440 <acquire>
  1008cc:	e9 88 fe ff ff       	jmp    100759 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  1008d1:	be df 65 10 00       	mov    $0x1065df,%esi
  1008d6:	eb 81                	jmp    100859 <cprintf+0x119>
  1008d8:	90                   	nop
  1008d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001008e0 <panic>:
  ioapic_enable(IRQ_KBD, 0);
}

void
panic(char *s)
{
  1008e0:	55                   	push   %ebp
  1008e1:	89 e5                	mov    %esp,%ebp
  1008e3:	56                   	push   %esi
  1008e4:	53                   	push   %ebx
  1008e5:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  1008e8:	c7 05 c4 84 10 00 00 	movl   $0x0,0x1084c4
  1008ef:	00 00 00 
panic(char *s)
{
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  1008f2:	fa                   	cli    
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  1008f3:	e8 78 1f 00 00       	call   102870 <cpu>
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  1008f8:	8d 75 d0             	lea    -0x30(%ebp),%esi
  1008fb:	31 db                	xor    %ebx,%ebx
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  1008fd:	c7 04 24 e6 65 10 00 	movl   $0x1065e6,(%esp)
  100904:	89 44 24 04          	mov    %eax,0x4(%esp)
  100908:	e8 33 fe ff ff       	call   100740 <cprintf>
  cprintf(s);
  10090d:	8b 45 08             	mov    0x8(%ebp),%eax
  100910:	89 04 24             	mov    %eax,(%esp)
  100913:	e8 28 fe ff ff       	call   100740 <cprintf>
  cprintf("\n");
  100918:	c7 04 24 33 6a 10 00 	movl   $0x106a33,(%esp)
  10091f:	e8 1c fe ff ff       	call   100740 <cprintf>
  getcallerpcs(&s, pcs);
  100924:	8d 45 08             	lea    0x8(%ebp),%eax
  100927:	89 74 24 04          	mov    %esi,0x4(%esp)
  10092b:	89 04 24             	mov    %eax,(%esp)
  10092e:	e8 6d 39 00 00       	call   1042a0 <getcallerpcs>
  100933:	90                   	nop
  100934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100938:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  10093b:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
  10093e:	c7 04 24 f5 65 10 00 	movl   $0x1065f5,(%esp)
  100945:	89 44 24 04          	mov    %eax,0x4(%esp)
  100949:	e8 f2 fd ff ff       	call   100740 <cprintf>
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  10094e:	83 fb 0a             	cmp    $0xa,%ebx
  100951:	75 e5                	jne    100938 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  100953:	c7 05 c0 84 10 00 01 	movl   $0x1,0x1084c0
  10095a:	00 00 00 
  10095d:	eb fe                	jmp    10095d <panic+0x7d>
  10095f:	90                   	nop

00100960 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  100960:	55                   	push   %ebp
  100961:	89 e5                	mov    %esp,%ebp
  100963:	57                   	push   %edi
  100964:	56                   	push   %esi
  100965:	53                   	push   %ebx
  100966:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  uint sz, sp, argp;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;

  if((ip = namei(path)) == 0)
  10096c:	8b 45 08             	mov    0x8(%ebp),%eax
  10096f:	89 04 24             	mov    %eax,(%esp)
  100972:	e8 99 15 00 00       	call   101f10 <namei>
  100977:	89 c3                	mov    %eax,%ebx
  100979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10097e:	85 db                	test   %ebx,%ebx
  100980:	0f 84 81 03 00 00    	je     100d07 <exec+0x3a7>
    return -1;
  ilock(ip);
  100986:	89 1c 24             	mov    %ebx,(%esp)
  100989:	e8 c2 12 00 00       	call   101c50 <ilock>
  // Compute memory size of new process.
  mem = 0;
  sz = 0;

  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  10098e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  100991:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100998:	00 
  100999:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1009a0:	00 
  1009a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a5:	89 1c 24             	mov    %ebx,(%esp)
  1009a8:	e8 63 0a 00 00       	call   101410 <readi>
  1009ad:	83 f8 33             	cmp    $0x33,%eax
  1009b0:	0f 86 74 03 00 00    	jbe    100d2a <exec+0x3ca>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  1009b6:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
  1009bd:	0f 85 67 03 00 00    	jne    100d2a <exec+0x3ca>
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  1009c3:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  1009c8:	bf ff 1f 00 00       	mov    $0x1fff,%edi
  1009cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1009d0:	74 6b                	je     100a3d <exec+0xdd>
  1009d2:	89 c7                	mov    %eax,%edi
  1009d4:	31 f6                	xor    %esi,%esi
  1009d6:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  1009dd:	eb 0f                	jmp    1009ee <exec+0x8e>
  1009df:	90                   	nop
  1009e0:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  1009e4:	83 c6 01             	add    $0x1,%esi
  1009e7:	39 f0                	cmp    %esi,%eax
  1009e9:	7e 49                	jle    100a34 <exec+0xd4>
  1009eb:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  1009ee:	8d 55 c8             	lea    -0x38(%ebp),%edx
  1009f1:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  1009f8:	00 
  1009f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1009fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a01:	89 1c 24             	mov    %ebx,(%esp)
  100a04:	e8 07 0a 00 00       	call   101410 <readi>
  100a09:	83 f8 20             	cmp    $0x20,%eax
  100a0c:	0f 85 18 03 00 00    	jne    100d2a <exec+0x3ca>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100a12:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100a16:	75 c8                	jne    1009e0 <exec+0x80>
      continue;
    if(ph.memsz < ph.filesz)
  100a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a1b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100a1e:	66 90                	xchg   %ax,%ax
  100a20:	0f 82 04 03 00 00    	jb     100d2a <exec+0x3ca>
      goto bad;
    sz += ph.memsz;
  100a26:	01 45 84             	add    %eax,-0x7c(%ebp)
  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100a29:	83 c6 01             	add    $0x1,%esi
  100a2c:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100a30:	39 f0                	cmp    %esi,%eax
  100a32:	7f b7                	jg     1009eb <exec+0x8b>
  100a34:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100a37:	81 c7 ff 1f 00 00    	add    $0x1fff,%edi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100a40:	31 f6                	xor    %esi,%esi
  100a42:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  100a49:	00 00 00 
  100a4c:	8b 11                	mov    (%ecx),%edx
  100a4e:	85 d2                	test   %edx,%edx
  100a50:	0f 84 ec 02 00 00    	je     100d42 <exec+0x3e2>
  100a56:	89 7d 84             	mov    %edi,-0x7c(%ebp)
  100a59:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100a5c:	89 5d 80             	mov    %ebx,-0x80(%ebp)
  100a5f:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
  100a65:	8d 76 00             	lea    0x0(%esi),%esi
    arglen += strlen(argv[argc]) + 1;
  100a68:	89 14 24             	mov    %edx,(%esp)
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a6b:	83 c3 01             	add    $0x1,%ebx
    arglen += strlen(argv[argc]) + 1;
  100a6e:	e8 1d 3c 00 00       	call   104690 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a73:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
  100a76:	89 d9                	mov    %ebx,%ecx
    arglen += strlen(argv[argc]) + 1;
  100a78:	01 f0                	add    %esi,%eax
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a7a:	85 d2                	test   %edx,%edx
    arglen += strlen(argv[argc]) + 1;
  100a7c:	8d 70 01             	lea    0x1(%eax),%esi
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a7f:	75 e7                	jne    100a68 <exec+0x108>
  100a81:	89 9d 78 ff ff ff    	mov    %ebx,-0x88(%ebp)
  100a87:	8b 7d 84             	mov    -0x7c(%ebp),%edi
  100a8a:	83 c0 04             	add    $0x4,%eax
  100a8d:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100a90:	83 e0 fc             	and    $0xfffffffc,%eax
  100a93:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  100a99:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax
  100a9d:	89 8d 74 ff ff ff    	mov    %ecx,-0x8c(%ebp)

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100aa3:	8d 3c 38             	lea    (%eax,%edi,1),%edi
  100aa6:	89 7d 80             	mov    %edi,-0x80(%ebp)
  100aa9:	81 65 80 00 f0 ff ff 	andl   $0xfffff000,-0x80(%ebp)
  mem = kalloc(sz);
  100ab0:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100ab3:	89 0c 24             	mov    %ecx,(%esp)
  100ab6:	e8 25 18 00 00       	call   1022e0 <kalloc>
  if(mem == 0)
  100abb:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100abd:	89 45 84             	mov    %eax,-0x7c(%ebp)
  if(mem == 0)
  100ac0:	0f 84 64 02 00 00    	je     100d2a <exec+0x3ca>
    goto bad;
  memset(mem, 0, sz);
  100ac6:	8b 45 80             	mov    -0x80(%ebp),%eax
  100ac9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100ad0:	00 
  100ad1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ad5:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100ad8:	89 14 24             	mov    %edx,(%esp)
  100adb:	e8 d0 39 00 00       	call   1044b0 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100ae0:	8b 7d b0             	mov    -0x50(%ebp),%edi
  100ae3:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100ae8:	0f 84 ab 00 00 00    	je     100b99 <exec+0x239>
  100aee:	31 f6                	xor    %esi,%esi
  100af0:	eb 18                	jmp    100b0a <exec+0x1aa>
  100af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100af8:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100afc:	83 c6 01             	add    $0x1,%esi
  100aff:	39 f0                	cmp    %esi,%eax
  100b01:	0f 8e 92 00 00 00    	jle    100b99 <exec+0x239>
  100b07:	83 c7 20             	add    $0x20,%edi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100b0a:	8d 4d c8             	lea    -0x38(%ebp),%ecx
  100b0d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100b14:	00 
  100b15:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100b19:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b1d:	89 1c 24             	mov    %ebx,(%esp)
  100b20:	e8 eb 08 00 00       	call   101410 <readi>
  100b25:	83 f8 20             	cmp    $0x20,%eax
  100b28:	0f 85 ea 01 00 00    	jne    100d18 <exec+0x3b8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100b2e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100b32:	75 c4                	jne    100af8 <exec+0x198>
      continue;
    if(ph.va + ph.memsz > sz)
  100b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100b37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100b3a:	01 c2                	add    %eax,%edx
  100b3c:	39 55 80             	cmp    %edx,-0x80(%ebp)
  100b3f:	0f 82 d3 01 00 00    	jb     100d18 <exec+0x3b8>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100b45:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100b48:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100b4c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  100b4f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b53:	03 45 84             	add    -0x7c(%ebp),%eax
  100b56:	89 1c 24             	mov    %ebx,(%esp)
  100b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5d:	e8 ae 08 00 00       	call   101410 <readi>
  100b62:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100b65:	0f 85 ad 01 00 00    	jne    100d18 <exec+0x3b8>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100b6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b6e:	83 c6 01             	add    $0x1,%esi
      continue;
    if(ph.va + ph.memsz > sz)
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100b71:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b78:	00 
  100b79:	29 c2                	sub    %eax,%edx
  100b7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b7f:	03 45 d0             	add    -0x30(%ebp),%eax
  100b82:	03 45 84             	add    -0x7c(%ebp),%eax
  100b85:	89 04 24             	mov    %eax,(%esp)
  100b88:	e8 23 39 00 00       	call   1044b0 <memset>
  if(mem == 0)
    goto bad;
  memset(mem, 0, sz);

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b8d:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100b91:	39 f0                	cmp    %esi,%eax
  100b93:	0f 8f 6e ff ff ff    	jg     100b07 <exec+0x1a7>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100b99:	89 1c 24             	mov    %ebx,(%esp)
  100b9c:	e8 8f 10 00 00       	call   101c30 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100ba1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100ba7:	8b 55 80             	mov    -0x80(%ebp),%edx
  100baa:	2b 95 7c ff ff ff    	sub    -0x84(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100bb0:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100bb3:	f7 d0                	not    %eax
  100bb5:	8d 04 82             	lea    (%edx,%eax,4),%eax

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100bb8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100bbe:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bc4:	89 d7                	mov    %edx,%edi
  100bc6:	83 ef 01             	sub    $0x1,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100bc9:	8d 04 90             	lea    (%eax,%edx,4),%eax
  for(i=argc-1; i>=0; i--){
  100bcc:	83 ff ff             	cmp    $0xffffffff,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100bcf:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
  for(i=argc-1; i>=0; i--){
  100bd6:	74 62                	je     100c3a <exec+0x2da>
  100bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  100bdb:	8d 04 bd 00 00 00 00 	lea    0x0(,%edi,4),%eax
  100be2:	89 ca                	mov    %ecx,%edx
  100be4:	8b 5d 80             	mov    -0x80(%ebp),%ebx
  100be7:	01 c6                	add    %eax,%esi
  100be9:	03 85 7c ff ff ff    	add    -0x84(%ebp),%eax
  100bef:	01 c2                	add    %eax,%edx
  100bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    len = strlen(argv[i]) + 1;
  100bf8:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100bfa:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
  100bfd:	89 04 24             	mov    %eax,(%esp)
  100c00:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  100c06:	e8 85 3a 00 00       	call   104690 <strlen>
    sp -= len;
  100c0b:	83 c0 01             	add    $0x1,%eax
  100c0e:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100c10:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c14:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c16:	83 ee 04             	sub    $0x4,%esi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c1d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  100c20:	01 d8                	add    %ebx,%eax
  100c22:	89 04 24             	mov    %eax,(%esp)
  100c25:	e8 16 39 00 00       	call   104540 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100c2a:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  100c30:	89 1a                	mov    %ebx,(%edx)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c32:	83 ea 04             	sub    $0x4,%edx
  100c35:	83 ff ff             	cmp    $0xffffffff,%edi
  100c38:	75 be                	jne    100bf8 <exec+0x298>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100c3a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100c40:	8b 55 84             	mov    -0x7c(%ebp),%edx
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c43:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  sp -= 4;
  100c49:	89 c6                	mov    %eax,%esi
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100c4b:	89 44 02 fc          	mov    %eax,-0x4(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  100c4f:	83 ee 0c             	sub    $0xc,%esi
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c52:	89 4c 02 f8          	mov    %ecx,-0x8(%edx,%eax,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100c56:	c7 44 02 f4 ff ff ff 	movl   $0xffffffff,-0xc(%edx,%eax,1)
  100c5d:	ff 

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c61:	0f b6 10             	movzbl (%eax),%edx
  100c64:	89 c3                	mov    %eax,%ebx
  100c66:	84 d2                	test   %dl,%dl
  100c68:	74 21                	je     100c8b <exec+0x32b>
  100c6a:	83 c0 01             	add    $0x1,%eax
  100c6d:	eb 0b                	jmp    100c7a <exec+0x31a>
  100c6f:	90                   	nop
  100c70:	0f b6 10             	movzbl (%eax),%edx
  100c73:	83 c0 01             	add    $0x1,%eax
  100c76:	84 d2                	test   %dl,%dl
  100c78:	74 11                	je     100c8b <exec+0x32b>
    if(*s == '/')
  100c7a:	80 fa 2f             	cmp    $0x2f,%dl
  100c7d:	75 f1                	jne    100c70 <exec+0x310>
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c7f:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
  100c82:	89 c3                	mov    %eax,%ebx
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c84:	83 c0 01             	add    $0x1,%eax
  100c87:	84 d2                	test   %dl,%dl
  100c89:	75 ef                	jne    100c7a <exec+0x31a>
    if(*s == '/')
      last = s+1;
  safestrcpy(cp->name, last, sizeof(cp->name));
  100c8b:	e8 70 27 00 00       	call   103400 <curproc>
  100c90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c94:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100c9b:	00 
  100c9c:	05 88 00 00 00       	add    $0x88,%eax
  100ca1:	89 04 24             	mov    %eax,(%esp)
  100ca4:	e8 a7 39 00 00       	call   104650 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100ca9:	e8 52 27 00 00       	call   103400 <curproc>
  100cae:	8b 58 04             	mov    0x4(%eax),%ebx
  100cb1:	e8 4a 27 00 00       	call   103400 <curproc>
  100cb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cba:	8b 00                	mov    (%eax),%eax
  100cbc:	89 04 24             	mov    %eax,(%esp)
  100cbf:	e8 dc 16 00 00       	call   1023a0 <kfree>
  cp->mem = mem;
  100cc4:	e8 37 27 00 00       	call   103400 <curproc>
  100cc9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100ccc:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cce:	e8 2d 27 00 00       	call   103400 <curproc>
  100cd3:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100cd6:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100cd9:	e8 22 27 00 00       	call   103400 <curproc>
  100cde:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100ce1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100ce7:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100cea:	e8 11 27 00 00       	call   103400 <curproc>
  100cef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100cf5:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100cf8:	e8 03 27 00 00       	call   103400 <curproc>
  100cfd:	89 04 24             	mov    %eax,(%esp)
  100d00:	e8 cb 2c 00 00       	call   1039d0 <setupsegs>
  100d05:	31 c0                	xor    %eax,%eax
 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  return -1;
}
  100d07:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  100d0d:	5b                   	pop    %ebx
  100d0e:	5e                   	pop    %esi
  100d0f:	5f                   	pop    %edi
  100d10:	5d                   	pop    %ebp
  100d11:	c3                   	ret    
  100d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  setupsegs(cp);
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100d18:	8b 45 80             	mov    -0x80(%ebp),%eax
  100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100d22:	89 14 24             	mov    %edx,(%esp)
  100d25:	e8 76 16 00 00       	call   1023a0 <kfree>
  iunlockput(ip);
  100d2a:	89 1c 24             	mov    %ebx,(%esp)
  100d2d:	e8 fe 0e 00 00       	call   101c30 <iunlockput>
  return -1;
}
  100d32:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  100d3d:	5b                   	pop    %ebx
  100d3e:	5e                   	pop    %esi
  100d3f:	5f                   	pop    %edi
  100d40:	5d                   	pop    %ebp
  100d41:	c3                   	ret    
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100d42:	b8 04 00 00 00       	mov    $0x4,%eax
  100d47:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100d4e:	00 00 00 
  100d51:	c7 85 74 ff ff ff 00 	movl   $0x0,-0x8c(%ebp)
  100d58:	00 00 00 
  100d5b:	e9 43 fd ff ff       	jmp    100aa3 <exec+0x143>

00100d60 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100d60:	55                   	push   %ebp
  100d61:	89 e5                	mov    %esp,%ebp
  100d63:	83 ec 38             	sub    $0x38,%esp
  100d66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100d6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100d6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100d72:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100d75:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->writable == 0)
  100d78:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100d7c:	74 5a                	je     100dd8 <filewrite+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100d7e:	8b 03                	mov    (%ebx),%eax
  100d80:	83 f8 02             	cmp    $0x2,%eax
  100d83:	74 5b                	je     100de0 <filewrite+0x80>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100d85:	83 f8 03             	cmp    $0x3,%eax
  100d88:	75 6d                	jne    100df7 <filewrite+0x97>
    ilock(f->ip);
  100d8a:	8b 43 10             	mov    0x10(%ebx),%eax
  100d8d:	89 04 24             	mov    %eax,(%esp)
  100d90:	e8 bb 0e 00 00       	call   101c50 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100d95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100d99:	8b 43 14             	mov    0x14(%ebx),%eax
  100d9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100da0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 01 08 00 00       	call   1015b0 <writei>
  100daf:	85 c0                	test   %eax,%eax
  100db1:	7e 03                	jle    100db6 <filewrite+0x56>
      f->off += r;
  100db3:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100db6:	8b 53 10             	mov    0x10(%ebx),%edx
  100db9:	89 14 24             	mov    %edx,(%esp)
  100dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100dbf:	e8 1c 0e 00 00       	call   101be0 <iunlock>
    return r;
  100dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("filewrite");
}
  100dc7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100dca:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100dcd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100dd0:	89 ec                	mov    %ebp,%esp
  100dd2:	5d                   	pop    %ebp
  100dd3:	c3                   	ret    
  100dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100ddd:	eb e8                	jmp    100dc7 <filewrite+0x67>
  100ddf:	90                   	nop
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100de0:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100de3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100de6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100de9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100dec:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100def:	89 ec                	mov    %ebp,%esp
  100df1:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100df2:	e9 c9 20 00 00       	jmp    102ec0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100df7:	c7 04 24 0a 66 10 00 	movl   $0x10660a,(%esp)
  100dfe:	e8 dd fa ff ff       	call   1008e0 <panic>
  100e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100e10 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100e10:	55                   	push   %ebp
  100e11:	89 e5                	mov    %esp,%ebp
  100e13:	83 ec 38             	sub    $0x38,%esp
  100e16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100e1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100e1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100e22:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100e25:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
  100e28:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100e2c:	74 5a                	je     100e88 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100e2e:	8b 03                	mov    (%ebx),%eax
  100e30:	83 f8 02             	cmp    $0x2,%eax
  100e33:	74 5b                	je     100e90 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100e35:	83 f8 03             	cmp    $0x3,%eax
  100e38:	75 6d                	jne    100ea7 <fileread+0x97>
    ilock(f->ip);
  100e3a:	8b 43 10             	mov    0x10(%ebx),%eax
  100e3d:	89 04 24             	mov    %eax,(%esp)
  100e40:	e8 0b 0e 00 00       	call   101c50 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100e49:	8b 43 14             	mov    0x14(%ebx),%eax
  100e4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e54:	8b 43 10             	mov    0x10(%ebx),%eax
  100e57:	89 04 24             	mov    %eax,(%esp)
  100e5a:	e8 b1 05 00 00       	call   101410 <readi>
  100e5f:	85 c0                	test   %eax,%eax
  100e61:	7e 03                	jle    100e66 <fileread+0x56>
      f->off += r;
  100e63:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e66:	8b 53 10             	mov    0x10(%ebx),%edx
  100e69:	89 14 24             	mov    %edx,(%esp)
  100e6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100e6f:	e8 6c 0d 00 00       	call   101be0 <iunlock>
    return r;
  100e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
  100e77:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e7a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e7d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e80:	89 ec                	mov    %ebp,%esp
  100e82:	5d                   	pop    %ebp
  100e83:	c3                   	ret    
  100e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e8d:	eb e8                	jmp    100e77 <fileread+0x67>
  100e8f:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e90:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e99:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100e9c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100e9f:	89 ec                	mov    %ebp,%esp
  100ea1:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100ea2:	e9 39 1f 00 00       	jmp    102de0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ea7:	c7 04 24 14 66 10 00 	movl   $0x106614,(%esp)
  100eae:	e8 2d fa ff ff       	call   1008e0 <panic>
  100eb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100ec0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100ec0:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100ec6:	89 e5                	mov    %esp,%ebp
  100ec8:	53                   	push   %ebx
  100ec9:	83 ec 14             	sub    $0x14,%esp
  100ecc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100ecf:	83 3b 03             	cmpl   $0x3,(%ebx)
  100ed2:	74 0c                	je     100ee0 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100ed4:	83 c4 14             	add    $0x14,%esp
  100ed7:	5b                   	pop    %ebx
  100ed8:	5d                   	pop    %ebp
  100ed9:	c3                   	ret    
  100eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100ee0:	8b 43 10             	mov    0x10(%ebx),%eax
  100ee3:	89 04 24             	mov    %eax,(%esp)
  100ee6:	e8 65 0d 00 00       	call   101c50 <ilock>
    stati(f->ip, st);
  100eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ef2:	8b 43 10             	mov    0x10(%ebx),%eax
  100ef5:	89 04 24             	mov    %eax,(%esp)
  100ef8:	e8 f3 01 00 00       	call   1010f0 <stati>
    iunlock(f->ip);
  100efd:	8b 43 10             	mov    0x10(%ebx),%eax
  100f00:	89 04 24             	mov    %eax,(%esp)
  100f03:	e8 d8 0c 00 00       	call   101be0 <iunlock>
    return 0;
  }
  return -1;
}
  100f08:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  100f0b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  100f0d:	5b                   	pop    %ebx
  100f0e:	5d                   	pop    %ebp
  100f0f:	c3                   	ret    

00100f10 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  100f10:	55                   	push   %ebp
  100f11:	89 e5                	mov    %esp,%ebp
  100f13:	53                   	push   %ebx
  100f14:	83 ec 14             	sub    $0x14,%esp
  100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&file_table_lock);
  100f1a:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  100f21:	e8 1a 35 00 00       	call   104440 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f26:	8b 43 04             	mov    0x4(%ebx),%eax
  100f29:	85 c0                	test   %eax,%eax
  100f2b:	7e 20                	jle    100f4d <filedup+0x3d>
  100f2d:	8b 13                	mov    (%ebx),%edx
  100f2f:	85 d2                	test   %edx,%edx
  100f31:	74 1a                	je     100f4d <filedup+0x3d>
    panic("filedup");
  f->ref++;
  100f33:	83 c0 01             	add    $0x1,%eax
  100f36:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f39:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  100f40:	e8 bb 34 00 00       	call   104400 <release>
  return f;
}
  100f45:	89 d8                	mov    %ebx,%eax
  100f47:	83 c4 14             	add    $0x14,%esp
  100f4a:	5b                   	pop    %ebx
  100f4b:	5d                   	pop    %ebp
  100f4c:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("filedup");
  100f4d:	c7 04 24 1d 66 10 00 	movl   $0x10661d,(%esp)
  100f54:	e8 87 f9 ff ff       	call   1008e0 <panic>
  100f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100f60 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  100f60:	55                   	push   %ebp
  100f61:	89 e5                	mov    %esp,%ebp
  100f63:	53                   	push   %ebx
  100f64:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&file_table_lock);
  100f67:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  100f6e:	e8 cd 34 00 00       	call   104440 <acquire>
  100f73:	ba a0 9d 10 00       	mov    $0x109da0,%edx
  100f78:	31 c0                	xor    %eax,%eax
  100f7a:	eb 0f                	jmp    100f8b <filealloc+0x2b>
  100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NFILE; i++){
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	83 c2 18             	add    $0x18,%edx
  100f86:	83 f8 64             	cmp    $0x64,%eax
  100f89:	74 45                	je     100fd0 <filealloc+0x70>
    if(file[i].type == FD_CLOSED){
  100f8b:	8b 0a                	mov    (%edx),%ecx
  100f8d:	85 c9                	test   %ecx,%ecx
  100f8f:	75 ef                	jne    100f80 <filealloc+0x20>
      file[i].type = FD_NONE;
  100f91:	8d 14 40             	lea    (%eax,%eax,2),%edx
  100f94:	8d 1c d5 00 00 00 00 	lea    0x0(,%edx,8),%ebx
      file[i].ref = 1;
      release(&file_table_lock);
  100f9b:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  100fa2:	c7 04 d5 a0 9d 10 00 	movl   $0x1,0x109da0(,%edx,8)
  100fa9:	01 00 00 00 
      file[i].ref = 1;
  100fad:	c7 04 d5 a4 9d 10 00 	movl   $0x1,0x109da4(,%edx,8)
  100fb4:	01 00 00 00 
      release(&file_table_lock);
  100fb8:	e8 43 34 00 00       	call   104400 <release>
      return file + i;
  100fbd:	8d 83 a0 9d 10 00    	lea    0x109da0(%ebx),%eax
    }
  }
  release(&file_table_lock);
  return 0;
}
  100fc3:	83 c4 14             	add    $0x14,%esp
  100fc6:	5b                   	pop    %ebx
  100fc7:	5d                   	pop    %ebp
  100fc8:	c3                   	ret    
  100fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  100fd0:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  100fd7:	e8 24 34 00 00       	call   104400 <release>
  return 0;
}
  100fdc:	83 c4 14             	add    $0x14,%esp
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  100fdf:	31 c0                	xor    %eax,%eax
  return 0;
}
  100fe1:	5b                   	pop    %ebx
  100fe2:	5d                   	pop    %ebp
  100fe3:	c3                   	ret    
  100fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100ff0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  100ff0:	55                   	push   %ebp
  100ff1:	89 e5                	mov    %esp,%ebp
  100ff3:	83 ec 38             	sub    $0x38,%esp
  100ff6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100ffc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100fff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&file_table_lock);
  101002:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101009:	e8 32 34 00 00       	call   104440 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  10100e:	8b 43 04             	mov    0x4(%ebx),%eax
  101011:	85 c0                	test   %eax,%eax
  101013:	0f 8e 9f 00 00 00    	jle    1010b8 <fileclose+0xc8>
  101019:	8b 33                	mov    (%ebx),%esi
  10101b:	85 f6                	test   %esi,%esi
  10101d:	0f 84 95 00 00 00    	je     1010b8 <fileclose+0xc8>
    panic("fileclose");
  if(--f->ref > 0){
  101023:	83 e8 01             	sub    $0x1,%eax
  101026:	85 c0                	test   %eax,%eax
  101028:	89 43 04             	mov    %eax,0x4(%ebx)
  10102b:	74 1b                	je     101048 <fileclose+0x58>
    release(&file_table_lock);
  10102d:	c7 45 08 00 a7 10 00 	movl   $0x10a700,0x8(%ebp)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  101034:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101037:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10103a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10103d:	89 ec                	mov    %ebp,%esp
  10103f:	5d                   	pop    %ebp

  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
  101040:	e9 bb 33 00 00       	jmp    104400 <release>
  101045:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }
  ff = *f;
  101048:	8b 43 0c             	mov    0xc(%ebx),%eax
  10104b:	8b 33                	mov    (%ebx),%esi
  10104d:	8b 7b 10             	mov    0x10(%ebx),%edi
  f->ref = 0;
  101050:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101057:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10105a:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_CLOSED;
  10105e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101064:	88 45 e7             	mov    %al,-0x19(%ebp)
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  101067:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  10106e:	e8 8d 33 00 00       	call   104400 <release>
  
  if(ff.type == FD_PIPE)
  101073:	83 fe 02             	cmp    $0x2,%esi
  101076:	74 20                	je     101098 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  101078:	83 fe 03             	cmp    $0x3,%esi
  10107b:	75 3b                	jne    1010b8 <fileclose+0xc8>
    iput(ff.ip);
  10107d:	89 7d 08             	mov    %edi,0x8(%ebp)
  else
    panic("fileclose");
}
  101080:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101083:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101086:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101089:	89 ec                	mov    %ebp,%esp
  10108b:	5d                   	pop    %ebp
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  10108c:	e9 0f 09 00 00       	jmp    1019a0 <iput>
  101091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  101098:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  10109c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1010a3:	89 04 24             	mov    %eax,(%esp)
  1010a6:	e8 15 1f 00 00       	call   102fc0 <pipeclose>
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  1010ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1010ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1010b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1010b4:	89 ec                	mov    %ebp,%esp
  1010b6:	5d                   	pop    %ebp
  1010b7:	c3                   	ret    
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  1010b8:	c7 04 24 25 66 10 00 	movl   $0x106625,(%esp)
  1010bf:	e8 1c f8 ff ff       	call   1008e0 <panic>
  1010c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001010d0 <fileinit>:
struct spinlock file_table_lock;
struct file file[NFILE];

void
fileinit(void)
{
  1010d0:	55                   	push   %ebp
  1010d1:	89 e5                	mov    %esp,%ebp
  1010d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&file_table_lock, "file_table");
  1010d6:	c7 44 24 04 2f 66 10 	movl   $0x10662f,0x4(%esp)
  1010dd:	00 
  1010de:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  1010e5:	e8 96 31 00 00       	call   104280 <initlock>
}
  1010ea:	c9                   	leave  
  1010eb:	c3                   	ret    
  1010ec:	90                   	nop
  1010ed:	90                   	nop
  1010ee:	90                   	nop
  1010ef:	90                   	nop

001010f0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  1010f0:	55                   	push   %ebp
  1010f1:	89 e5                	mov    %esp,%ebp
  1010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
  1010f9:	8b 0a                	mov    (%edx),%ecx
  1010fb:	89 08                	mov    %ecx,(%eax)
  st->ino = ip->inum;
  1010fd:	8b 4a 04             	mov    0x4(%edx),%ecx
  101100:	89 48 04             	mov    %ecx,0x4(%eax)
  st->type = ip->type;
  101103:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
  101107:	66 89 48 08          	mov    %cx,0x8(%eax)
  st->nlink = ip->nlink;
  10110b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
  st->size = ip->size;
  10110f:	8b 52 18             	mov    0x18(%edx),%edx
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  101112:	66 89 48 0a          	mov    %cx,0xa(%eax)
  st->size = ip->size;
  101116:	89 50 0c             	mov    %edx,0xc(%eax)
}
  101119:	5d                   	pop    %ebp
  10111a:	c3                   	ret    
  10111b:	90                   	nop
  10111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101120 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101120:	55                   	push   %ebp
  101121:	89 e5                	mov    %esp,%ebp
  101123:	53                   	push   %ebx
  101124:	83 ec 14             	sub    $0x14,%esp
  101127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10112a:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101131:	e8 0a 33 00 00       	call   104440 <acquire>
  ip->ref++;
  101136:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10113a:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101141:	e8 ba 32 00 00       	call   104400 <release>
  return ip;
}
  101146:	89 d8                	mov    %ebx,%eax
  101148:	83 c4 14             	add    $0x14,%esp
  10114b:	5b                   	pop    %ebx
  10114c:	5d                   	pop    %ebp
  10114d:	c3                   	ret    
  10114e:	66 90                	xchg   %ax,%ax

00101150 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101150:	55                   	push   %ebp
  101151:	89 e5                	mov    %esp,%ebp
  101153:	57                   	push   %edi
  101154:	89 d7                	mov    %edx,%edi
  101156:	56                   	push   %esi
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  101157:	31 f6                	xor    %esi,%esi
{
  101159:	53                   	push   %ebx
  10115a:	89 c3                	mov    %eax,%ebx
  10115c:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
  10115f:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101166:	e8 d5 32 00 00       	call   104440 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10116b:	b8 d4 a7 10 00       	mov    $0x10a7d4,%eax
  101170:	eb 14                	jmp    101186 <iget+0x36>
  101172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101178:	85 f6                	test   %esi,%esi
  10117a:	74 3c                	je     1011b8 <iget+0x68>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  10117c:	83 c0 50             	add    $0x50,%eax
  10117f:	3d 74 b7 10 00       	cmp    $0x10b774,%eax
  101184:	74 42                	je     1011c8 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  101186:	8b 48 08             	mov    0x8(%eax),%ecx
  101189:	85 c9                	test   %ecx,%ecx
  10118b:	7e eb                	jle    101178 <iget+0x28>
  10118d:	39 18                	cmp    %ebx,(%eax)
  10118f:	75 e7                	jne    101178 <iget+0x28>
  101191:	39 78 04             	cmp    %edi,0x4(%eax)
  101194:	75 e2                	jne    101178 <iget+0x28>
      ip->ref++;
  101196:	83 c1 01             	add    $0x1,%ecx
  101199:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
  10119c:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  1011a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1011a6:	e8 55 32 00 00       	call   104400 <release>
      return ip;
  1011ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1011ae:	83 c4 2c             	add    $0x2c,%esp
  1011b1:	5b                   	pop    %ebx
  1011b2:	5e                   	pop    %esi
  1011b3:	5f                   	pop    %edi
  1011b4:	5d                   	pop    %ebp
  1011b5:	c3                   	ret    
  1011b6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1011b8:	85 c9                	test   %ecx,%ecx
  1011ba:	75 c0                	jne    10117c <iget+0x2c>
  1011bc:	89 c6                	mov    %eax,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1011be:	83 c0 50             	add    $0x50,%eax
  1011c1:	3d 74 b7 10 00       	cmp    $0x10b774,%eax
  1011c6:	75 be                	jne    101186 <iget+0x36>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  1011c8:	85 f6                	test   %esi,%esi
  1011ca:	74 29                	je     1011f5 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  1011cc:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
  1011ce:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
  1011d1:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  1011d8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
  1011df:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  1011e6:	e8 15 32 00 00       	call   104400 <release>

  return ip;
}
  1011eb:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  1011ee:	89 f0                	mov    %esi,%eax

  return ip;
}
  1011f0:	5b                   	pop    %ebx
  1011f1:	5e                   	pop    %esi
  1011f2:	5f                   	pop    %edi
  1011f3:	5d                   	pop    %ebp
  1011f4:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  1011f5:	c7 04 24 3a 66 10 00 	movl   $0x10663a,(%esp)
  1011fc:	e8 df f6 ff ff       	call   1008e0 <panic>
  101201:	eb 0d                	jmp    101210 <readsb>
  101203:	90                   	nop
  101204:	90                   	nop
  101205:	90                   	nop
  101206:	90                   	nop
  101207:	90                   	nop
  101208:	90                   	nop
  101209:	90                   	nop
  10120a:	90                   	nop
  10120b:	90                   	nop
  10120c:	90                   	nop
  10120d:	90                   	nop
  10120e:	90                   	nop
  10120f:	90                   	nop

00101210 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101210:	55                   	push   %ebp
  101211:	89 e5                	mov    %esp,%ebp
  101213:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101216:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10121d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10121e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101221:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101224:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101226:	89 04 24             	mov    %eax,(%esp)
  101229:	e8 82 ee ff ff       	call   1000b0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10122e:	89 34 24             	mov    %esi,(%esp)
  101231:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101238:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101239:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10123b:	8d 40 18             	lea    0x18(%eax),%eax
  10123e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101242:	e8 f9 32 00 00       	call   104540 <memmove>
  brelse(bp);
  101247:	89 1c 24             	mov    %ebx,(%esp)
  10124a:	e8 b1 ed ff ff       	call   100000 <brelse>
}
  10124f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  101252:	8b 75 fc             	mov    -0x4(%ebp),%esi
  101255:	89 ec                	mov    %ebp,%esp
  101257:	5d                   	pop    %ebp
  101258:	c3                   	ret    
  101259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101260 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101260:	55                   	push   %ebp
  101261:	89 e5                	mov    %esp,%ebp
  101263:	57                   	push   %edi
  101264:	56                   	push   %esi
  101265:	53                   	push   %ebx
  101266:	83 ec 3c             	sub    $0x3c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101269:	8d 55 dc             	lea    -0x24(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  10126c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  10126f:	e8 9c ff ff ff       	call   101210 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101274:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101277:	85 c0                	test   %eax,%eax
  101279:	0f 84 9c 00 00 00    	je     10131b <balloc+0xbb>
  10127f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101289:	31 db                	xor    %ebx,%ebx
  10128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10128e:	c1 e8 03             	shr    $0x3,%eax
  101291:	c1 fa 0c             	sar    $0xc,%edx
  101294:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101298:	89 44 24 04          	mov    %eax,0x4(%esp)
  10129c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10129f:	89 04 24             	mov    %eax,(%esp)
  1012a2:	e8 09 ee ff ff       	call   1000b0 <bread>
  1012a7:	89 c6                	mov    %eax,%esi
  1012a9:	eb 10                	jmp    1012bb <balloc+0x5b>
  1012ab:	90                   	nop
  1012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  1012b0:	83 c3 01             	add    $0x1,%ebx
  1012b3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  1012b9:	74 45                	je     101300 <balloc+0xa0>
      m = 1 << (bi % 8);
  1012bb:	89 d9                	mov    %ebx,%ecx
  1012bd:	ba 01 00 00 00       	mov    $0x1,%edx
  1012c2:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012c5:	89 d8                	mov    %ebx,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1012c7:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012c9:	c1 f8 03             	sar    $0x3,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1012cc:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012ce:	0f b6 54 06 18       	movzbl 0x18(%esi,%eax,1),%edx
  1012d3:	0f b6 fa             	movzbl %dl,%edi
  1012d6:	85 cf                	test   %ecx,%edi
  1012d8:	75 d6                	jne    1012b0 <balloc+0x50>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1012da:	09 d1                	or     %edx,%ecx
  1012dc:	88 4c 06 18          	mov    %cl,0x18(%esi,%eax,1)
        bwrite(bp);
  1012e0:	89 34 24             	mov    %esi,(%esp)
  1012e3:	e8 98 ed ff ff       	call   100080 <bwrite>
        brelse(bp);
  1012e8:	89 34 24             	mov    %esi,(%esp)
  1012eb:	e8 10 ed ff ff       	call   100000 <brelse>
  1012f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012f3:	83 c4 3c             	add    $0x3c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1012f6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012f9:	5b                   	pop    %ebx
  1012fa:	5e                   	pop    %esi
  1012fb:	5f                   	pop    %edi
  1012fc:	5d                   	pop    %ebp
  1012fd:	c3                   	ret    
  1012fe:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  101300:	89 34 24             	mov    %esi,(%esp)
  101303:	e8 f8 ec ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  101308:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  10130f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  101312:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101315:	0f 87 6b ff ff ff    	ja     101286 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  10131b:	c7 04 24 4a 66 10 00 	movl   $0x10664a,(%esp)
  101322:	e8 b9 f5 ff ff       	call   1008e0 <panic>
  101327:	89 f6                	mov    %esi,%esi
  101329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101330 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101330:	55                   	push   %ebp
  101331:	89 e5                	mov    %esp,%ebp
  101333:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101336:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101339:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10133c:	89 c3                	mov    %eax,%ebx
  10133e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101341:	89 ce                	mov    %ecx,%esi
  101343:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101346:	77 30                	ja     101378 <bmap+0x48>
    if((addr = ip->addrs[bn]) == 0){
  101348:	8d 7a 04             	lea    0x4(%edx),%edi
  10134b:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
  10134f:	85 c0                	test   %eax,%eax
  101351:	75 15                	jne    101368 <bmap+0x38>
      if(!alloc)
  101353:	85 c9                	test   %ecx,%ecx
  101355:	74 38                	je     10138f <bmap+0x5f>
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101357:	8b 03                	mov    (%ebx),%eax
  101359:	e8 02 ff ff ff       	call   101260 <balloc>
  10135e:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  101368:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10136b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10136e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101371:	89 ec                	mov    %ebp,%esp
  101373:	5d                   	pop    %ebp
  101374:	c3                   	ret    
  101375:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101378:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
  10137b:	83 ff 7f             	cmp    $0x7f,%edi
  10137e:	0f 87 7f 00 00 00    	ja     101403 <bmap+0xd3>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  101384:	8b 40 4c             	mov    0x4c(%eax),%eax
  101387:	85 c0                	test   %eax,%eax
  101389:	75 17                	jne    1013a2 <bmap+0x72>
      if(!alloc)
  10138b:	85 c9                	test   %ecx,%ecx
  10138d:	75 09                	jne    101398 <bmap+0x68>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  10138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101394:	eb d2                	jmp    101368 <bmap+0x38>
  101396:	66 90                	xchg   %ax,%ax
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101398:	8b 03                	mov    (%ebx),%eax
  10139a:	e8 c1 fe ff ff       	call   101260 <balloc>
  10139f:	89 43 4c             	mov    %eax,0x4c(%ebx)
    }
    bp = bread(ip->dev, addr);
  1013a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013a6:	8b 03                	mov    (%ebx),%eax
  1013a8:	89 04 24             	mov    %eax,(%esp)
  1013ab:	e8 00 ed ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1013b0:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  1013b4:	89 c2                	mov    %eax,%edx
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1013b6:	8b 07                	mov    (%edi),%eax
  1013b8:	85 c0                	test   %eax,%eax
  1013ba:	75 34                	jne    1013f0 <bmap+0xc0>
      if(!alloc){
  1013bc:	85 f6                	test   %esi,%esi
  1013be:	75 10                	jne    1013d0 <bmap+0xa0>
        brelse(bp);
  1013c0:	89 14 24             	mov    %edx,(%esp)
  1013c3:	e8 38 ec ff ff       	call   100000 <brelse>
  1013c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        return -1;
  1013cd:	eb 99                	jmp    101368 <bmap+0x38>
  1013cf:	90                   	nop
      }
      a[bn] = addr = balloc(ip->dev);
  1013d0:	8b 03                	mov    (%ebx),%eax
  1013d2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1013d5:	e8 86 fe ff ff       	call   101260 <balloc>
      bwrite(bp);
  1013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  1013dd:	89 07                	mov    %eax,(%edi)
      bwrite(bp);
  1013df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1013e2:	89 14 24             	mov    %edx,(%esp)
  1013e5:	e8 96 ec ff ff       	call   100080 <bwrite>
  1013ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1013ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
  1013f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1013f3:	89 14 24             	mov    %edx,(%esp)
  1013f6:	e8 05 ec ff ff       	call   100000 <brelse>
    return addr;
  1013fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1013fe:	e9 65 ff ff ff       	jmp    101368 <bmap+0x38>
  }

  panic("bmap: out of range");
  101403:	c7 04 24 60 66 10 00 	movl   $0x106660,(%esp)
  10140a:	e8 d1 f4 ff ff       	call   1008e0 <panic>
  10140f:	90                   	nop

00101410 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101410:	55                   	push   %ebp
  101411:	89 e5                	mov    %esp,%ebp
  101413:	83 ec 38             	sub    $0x38,%esp
  101416:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10141c:	8b 45 14             	mov    0x14(%ebp),%eax
  10141f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101422:	8b 75 10             	mov    0x10(%ebp),%esi
  101425:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101428:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10142b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101433:	74 1b                	je     101450 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101435:	8b 43 18             	mov    0x18(%ebx),%eax
  101438:	39 f0                	cmp    %esi,%eax
  10143a:	73 44                	jae    101480 <readi+0x70>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10143c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101441:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101444:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101447:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10144a:	89 ec                	mov    %ebp,%esp
  10144c:	5d                   	pop    %ebp
  10144d:	c3                   	ret    
  10144e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101450:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101454:	66 83 f8 09          	cmp    $0x9,%ax
  101458:	77 e2                	ja     10143c <readi+0x2c>
  10145a:	98                   	cwtl   
  10145b:	8b 04 c5 40 a7 10 00 	mov    0x10a740(,%eax,8),%eax
  101462:	85 c0                	test   %eax,%eax
  101464:	74 d6                	je     10143c <readi+0x2c>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101469:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10146c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10146f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101472:	89 55 10             	mov    %edx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101475:	89 ec                	mov    %ebp,%esp
  101477:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101478:	ff e0                	jmp    *%eax
  10147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  if(off > ip->size || off + n < off)
  101480:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101483:	01 f2                	add    %esi,%edx
  101485:	72 b5                	jb     10143c <readi+0x2c>
    return -1;
  if(off + n > ip->size)
  101487:	39 d0                	cmp    %edx,%eax
  101489:	73 05                	jae    101490 <readi+0x80>
    n = ip->size - off;
  10148b:	29 f0                	sub    %esi,%eax
  10148d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101493:	85 d2                	test   %edx,%edx
  101495:	74 7e                	je     101515 <readi+0x105>
  101497:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
  10149e:	89 7d dc             	mov    %edi,-0x24(%ebp)
  1014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1014a8:	89 f2                	mov    %esi,%edx
  1014aa:	31 c9                	xor    %ecx,%ecx
  1014ac:	c1 ea 09             	shr    $0x9,%edx
  1014af:	89 d8                	mov    %ebx,%eax
  1014b1:	e8 7a fe ff ff       	call   101330 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1014b6:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1014bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014bf:	8b 03                	mov    (%ebx),%eax
  1014c1:	89 04 24             	mov    %eax,(%esp)
  1014c4:	e8 e7 eb ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1014c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1014cc:	2b 4d e0             	sub    -0x20(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1014cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1014d1:	89 f0                	mov    %esi,%eax
  1014d3:	25 ff 01 00 00       	and    $0x1ff,%eax
  1014d8:	29 c7                	sub    %eax,%edi
  1014da:	39 cf                	cmp    %ecx,%edi
  1014dc:	76 02                	jbe    1014e0 <readi+0xd0>
  1014de:	89 cf                	mov    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1014e0:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1014e4:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1014e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1014ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1014f1:	89 04 24             	mov    %eax,(%esp)
  1014f4:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1014f7:	e8 44 30 00 00       	call   104540 <memmove>
    brelse(bp);
  1014fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1014ff:	89 14 24             	mov    %edx,(%esp)
  101502:	e8 f9 ea ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101507:	01 7d e0             	add    %edi,-0x20(%ebp)
  10150a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10150d:	01 7d dc             	add    %edi,-0x24(%ebp)
  101510:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101513:	77 93                	ja     1014a8 <readi+0x98>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101518:	e9 24 ff ff ff       	jmp    101441 <readi+0x31>
  10151d:	8d 76 00             	lea    0x0(%esi),%esi

00101520 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	56                   	push   %esi
  101524:	53                   	push   %ebx
  101525:	83 ec 10             	sub    $0x10,%esp
  101528:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10152b:	8b 43 04             	mov    0x4(%ebx),%eax
  10152e:	c1 e8 03             	shr    $0x3,%eax
  101531:	83 c0 02             	add    $0x2,%eax
  101534:	89 44 24 04          	mov    %eax,0x4(%esp)
  101538:	8b 03                	mov    (%ebx),%eax
  10153a:	89 04 24             	mov    %eax,(%esp)
  10153d:	e8 6e eb ff ff       	call   1000b0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  101542:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  101546:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101548:	8b 43 04             	mov    0x4(%ebx),%eax
  10154b:	83 e0 07             	and    $0x7,%eax
  10154e:	c1 e0 06             	shl    $0x6,%eax
  101551:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  101555:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  101558:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  10155c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  101560:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  101564:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  101568:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  10156c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  101570:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101573:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101576:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101579:	83 c0 0c             	add    $0xc,%eax
  10157c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101580:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101587:	00 
  101588:	89 04 24             	mov    %eax,(%esp)
  10158b:	e8 b0 2f 00 00       	call   104540 <memmove>
  bwrite(bp);
  101590:	89 34 24             	mov    %esi,(%esp)
  101593:	e8 e8 ea ff ff       	call   100080 <bwrite>
  brelse(bp);
  101598:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10159b:	83 c4 10             	add    $0x10,%esp
  10159e:	5b                   	pop    %ebx
  10159f:	5e                   	pop    %esi
  1015a0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  1015a1:	e9 5a ea ff ff       	jmp    100000 <brelse>
  1015a6:	8d 76 00             	lea    0x0(%esi),%esi
  1015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001015b0 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1015b0:	55                   	push   %ebp
  1015b1:	89 e5                	mov    %esp,%ebp
  1015b3:	57                   	push   %edi
  1015b4:	56                   	push   %esi
  1015b5:	53                   	push   %ebx
  1015b6:	83 ec 2c             	sub    $0x2c,%esp
  1015b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1015bf:	8b 55 14             	mov    0x14(%ebp),%edx
  1015c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1015c5:	66 83 7e 10 03       	cmpw   $0x3,0x10(%esi)
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1015ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1015cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1015d0:	0f 84 c2 00 00 00    	je     101698 <writei+0xe8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  1015d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1015d9:	01 d8                	add    %ebx,%eax
  1015db:	0f 82 c1 00 00 00    	jb     1016a2 <writei+0xf2>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1015e1:	3d 00 18 01 00       	cmp    $0x11800,%eax
  1015e6:	76 0a                	jbe    1015f2 <writei+0x42>
    n = MAXFILE*BSIZE - off;
  1015e8:	c7 45 dc 00 18 01 00 	movl   $0x11800,-0x24(%ebp)
  1015ef:	29 5d dc             	sub    %ebx,-0x24(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1015f5:	85 c9                	test   %ecx,%ecx
  1015f7:	0f 84 8b 00 00 00    	je     101688 <writei+0xd8>
  1015fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  101604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101608:	89 da                	mov    %ebx,%edx
  10160a:	b9 01 00 00 00       	mov    $0x1,%ecx
  10160f:	c1 ea 09             	shr    $0x9,%edx
  101612:	89 f0                	mov    %esi,%eax
  101614:	e8 17 fd ff ff       	call   101330 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101619:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  10161e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101622:	8b 06                	mov    (%esi),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 84 ea ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  10162c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10162f:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101632:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  101634:	89 d8                	mov    %ebx,%eax
  101636:	25 ff 01 00 00       	and    $0x1ff,%eax
  10163b:	29 c7                	sub    %eax,%edi
  10163d:	39 cf                	cmp    %ecx,%edi
  10163f:	76 02                	jbe    101643 <writei+0x93>
  101641:	89 cf                	mov    %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
  101643:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10164a:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  10164e:	89 04 24             	mov    %eax,(%esp)
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101651:	01 fb                	add    %edi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101653:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  101657:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10165a:	e8 e1 2e 00 00       	call   104540 <memmove>
    bwrite(bp);
  10165f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  101662:	89 14 24             	mov    %edx,(%esp)
  101665:	e8 16 ea ff ff       	call   100080 <bwrite>
    brelse(bp);
  10166a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10166d:	89 14 24             	mov    %edx,(%esp)
  101670:	e8 8b e9 ff ff       	call   100000 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101675:	01 7d e4             	add    %edi,-0x1c(%ebp)
  101678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10167b:	01 7d e0             	add    %edi,-0x20(%ebp)
  10167e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101681:	77 85                	ja     101608 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101683:	3b 5e 18             	cmp    0x18(%esi),%ebx
  101686:	77 28                	ja     1016b0 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101688:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  10168b:	83 c4 2c             	add    $0x2c,%esp
  10168e:	5b                   	pop    %ebx
  10168f:	5e                   	pop    %esi
  101690:	5f                   	pop    %edi
  101691:	5d                   	pop    %ebp
  101692:	c3                   	ret    
  101693:	90                   	nop
  101694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101698:	0f b7 46 12          	movzwl 0x12(%esi),%eax
  10169c:	66 83 f8 09          	cmp    $0x9,%ax
  1016a0:	76 1b                	jbe    1016bd <writei+0x10d>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1016a2:	83 c4 2c             	add    $0x2c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1016a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1016aa:	5b                   	pop    %ebx
  1016ab:	5e                   	pop    %esi
  1016ac:	5f                   	pop    %edi
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    
  1016af:	90                   	nop
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  1016b0:	89 5e 18             	mov    %ebx,0x18(%esi)
    iupdate(ip);
  1016b3:	89 34 24             	mov    %esi,(%esp)
  1016b6:	e8 65 fe ff ff       	call   101520 <iupdate>
  1016bb:	eb cb                	jmp    101688 <writei+0xd8>
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1016bd:	98                   	cwtl   
  1016be:	8b 04 c5 44 a7 10 00 	mov    0x10a744(,%eax,8),%eax
  1016c5:	85 c0                	test   %eax,%eax
  1016c7:	74 d9                	je     1016a2 <writei+0xf2>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1016c9:	89 55 10             	mov    %edx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1016cc:	83 c4 2c             	add    $0x2c,%esp
  1016cf:	5b                   	pop    %ebx
  1016d0:	5e                   	pop    %esi
  1016d1:	5f                   	pop    %edi
  1016d2:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1016d3:	ff e0                	jmp    *%eax
  1016d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1016d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001016e0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  1016e0:	55                   	push   %ebp
  1016e1:	89 e5                	mov    %esp,%ebp
  1016e3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  1016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1016e9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1016f0:	00 
  1016f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f8:	89 04 24             	mov    %eax,(%esp)
  1016fb:	e8 a0 2e 00 00       	call   1045a0 <strncmp>
}
  101700:	c9                   	leave  
  101701:	c3                   	ret    
  101702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101710 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	57                   	push   %edi
  101714:	56                   	push   %esi
  101715:	53                   	push   %ebx
  101716:	83 ec 3c             	sub    $0x3c,%esp
  101719:	8b 45 08             	mov    0x8(%ebp),%eax
  10171c:	8b 55 10             	mov    0x10(%ebp),%edx
  10171f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101722:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101727:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10172a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  10172d:	0f 85 d0 00 00 00    	jne    101803 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101733:	8b 70 18             	mov    0x18(%eax),%esi
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101736:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10173d:	85 f6                	test   %esi,%esi
  10173f:	0f 84 b4 00 00 00    	je     1017f9 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101745:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101748:	31 c9                	xor    %ecx,%ecx
  10174a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10174d:	c1 ea 09             	shr    $0x9,%edx
  101750:	e8 db fb ff ff       	call   101330 <bmap>
  101755:	89 44 24 04          	mov    %eax,0x4(%esp)
  101759:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10175c:	8b 01                	mov    (%ecx),%eax
  10175e:	89 04 24             	mov    %eax,(%esp)
  101761:	e8 4a e9 ff ff       	call   1000b0 <bread>
  101766:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  10176c:	83 c0 18             	add    $0x18,%eax
  10176f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101772:	89 c6                	mov    %eax,%esi

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101774:	81 c7 18 02 00 00    	add    $0x218,%edi
  10177a:	eb 0b                	jmp    101787 <dirlookup+0x77>
  10177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  101780:	83 c6 10             	add    $0x10,%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101783:	39 fe                	cmp    %edi,%esi
  101785:	74 51                	je     1017d8 <dirlookup+0xc8>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  101787:	66 83 3e 00          	cmpw   $0x0,(%esi)
  10178b:	74 f3                	je     101780 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  10178d:	8d 46 02             	lea    0x2(%esi),%eax
  101790:	89 44 24 04          	mov    %eax,0x4(%esp)
  101794:	89 1c 24             	mov    %ebx,(%esp)
  101797:	e8 44 ff ff ff       	call   1016e0 <namecmp>
  10179c:	85 c0                	test   %eax,%eax
  10179e:	75 e0                	jne    101780 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1017a0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1017a3:	85 db                	test   %ebx,%ebx
  1017a5:	74 0e                	je     1017b5 <dirlookup+0xa5>
          *poff = off + (uchar*)de - bp->data;
  1017a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1017aa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1017ad:	8d 04 16             	lea    (%esi,%edx,1),%eax
  1017b0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  1017b3:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
        brelse(bp);
  1017b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  1017b8:	0f b7 1e             	movzwl (%esi),%ebx
        brelse(bp);
  1017bb:	89 04 24             	mov    %eax,(%esp)
  1017be:	e8 3d e8 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  1017c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1017c6:	89 da                	mov    %ebx,%edx
  1017c8:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  1017ca:	83 c4 3c             	add    $0x3c,%esp
  1017cd:	5b                   	pop    %ebx
  1017ce:	5e                   	pop    %esi
  1017cf:	5f                   	pop    %edi
  1017d0:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  1017d1:	e9 7a f9 ff ff       	jmp    101150 <iget>
  1017d6:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  1017d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1017db:	89 04 24             	mov    %eax,(%esp)
  1017de:	e8 1d e8 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  1017e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1017e6:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  1017ed:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1017f0:	39 4a 18             	cmp    %ecx,0x18(%edx)
  1017f3:	0f 87 4c ff ff ff    	ja     101745 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  1017f9:	83 c4 3c             	add    $0x3c,%esp
  1017fc:	31 c0                	xor    %eax,%eax
  1017fe:	5b                   	pop    %ebx
  1017ff:	5e                   	pop    %esi
  101800:	5f                   	pop    %edi
  101801:	5d                   	pop    %ebp
  101802:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101803:	c7 04 24 73 66 10 00 	movl   $0x106673,(%esp)
  10180a:	e8 d1 f0 ff ff       	call   1008e0 <panic>
  10180f:	90                   	nop

00101810 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101810:	55                   	push   %ebp
  101811:	89 e5                	mov    %esp,%ebp
  101813:	57                   	push   %edi
  101814:	56                   	push   %esi
  101815:	53                   	push   %ebx
  101816:	83 ec 3c             	sub    $0x3c,%esp
  101819:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10181d:	8d 55 dc             	lea    -0x24(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101820:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101824:	8b 45 08             	mov    0x8(%ebp),%eax
  101827:	e8 e4 f9 ff ff       	call   101210 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10182c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101830:	0f 86 96 00 00 00    	jbe    1018cc <ialloc+0xbc>
  101836:	be 01 00 00 00       	mov    $0x1,%esi
  10183b:	bb 01 00 00 00       	mov    $0x1,%ebx
  101840:	eb 18                	jmp    10185a <ialloc+0x4a>
  101842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101848:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  10184b:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10184e:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101850:	e8 ab e7 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101855:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  101858:	73 72                	jae    1018cc <ialloc+0xbc>
    bp = bread(dev, IBLOCK(inum));
  10185a:	89 f0                	mov    %esi,%eax
  10185c:	c1 e8 03             	shr    $0x3,%eax
  10185f:	83 c0 02             	add    $0x2,%eax
  101862:	89 44 24 04          	mov    %eax,0x4(%esp)
  101866:	8b 45 08             	mov    0x8(%ebp),%eax
  101869:	89 04 24             	mov    %eax,(%esp)
  10186c:	e8 3f e8 ff ff       	call   1000b0 <bread>
  101871:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101873:	89 f0                	mov    %esi,%eax
  101875:	83 e0 07             	and    $0x7,%eax
  101878:	c1 e0 06             	shl    $0x6,%eax
  10187b:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  10187f:	66 83 3a 00          	cmpw   $0x0,(%edx)
  101883:	75 c3                	jne    101848 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101885:	89 14 24             	mov    %edx,(%esp)
  101888:	89 55 d0             	mov    %edx,-0x30(%ebp)
  10188b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101892:	00 
  101893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10189a:	00 
  10189b:	e8 10 2c 00 00       	call   1044b0 <memset>
      dip->type = type;
  1018a0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1018a3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  1018a7:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  1018aa:	89 3c 24             	mov    %edi,(%esp)
  1018ad:	e8 ce e7 ff ff       	call   100080 <bwrite>
      brelse(bp);
  1018b2:	89 3c 24             	mov    %edi,(%esp)
  1018b5:	e8 46 e7 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  1018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1018bd:	89 f2                	mov    %esi,%edx
  1018bf:	e8 8c f8 ff ff       	call   101150 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  1018c4:	83 c4 3c             	add    $0x3c,%esp
  1018c7:	5b                   	pop    %ebx
  1018c8:	5e                   	pop    %esi
  1018c9:	5f                   	pop    %edi
  1018ca:	5d                   	pop    %ebp
  1018cb:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  1018cc:	c7 04 24 85 66 10 00 	movl   $0x106685,(%esp)
  1018d3:	e8 08 f0 ff ff       	call   1008e0 <panic>
  1018d8:	90                   	nop
  1018d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001018e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  1018e0:	55                   	push   %ebp
  1018e1:	89 e5                	mov    %esp,%ebp
  1018e3:	57                   	push   %edi
  1018e4:	56                   	push   %esi
  1018e5:	89 c6                	mov    %eax,%esi
  1018e7:	53                   	push   %ebx
  1018e8:	89 d3                	mov    %edx,%ebx
  1018ea:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1018ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018f1:	89 04 24             	mov    %eax,(%esp)
  1018f4:	e8 b7 e7 ff ff       	call   1000b0 <bread>
  memset(bp->data, 0, BSIZE);
  1018f9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101900:	00 
  101901:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101908:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101909:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  10190b:	8d 40 18             	lea    0x18(%eax),%eax
  10190e:	89 04 24             	mov    %eax,(%esp)
  101911:	e8 9a 2b 00 00       	call   1044b0 <memset>
  bwrite(bp);
  101916:	89 3c 24             	mov    %edi,(%esp)
  101919:	e8 62 e7 ff ff       	call   100080 <bwrite>
  brelse(bp);
  10191e:	89 3c 24             	mov    %edi,(%esp)
  101921:	e8 da e6 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101926:	89 f0                	mov    %esi,%eax
  101928:	8d 55 dc             	lea    -0x24(%ebp),%edx
  10192b:	e8 e0 f8 ff ff       	call   101210 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101933:	89 da                	mov    %ebx,%edx
  101935:	c1 ea 0c             	shr    $0xc,%edx
  101938:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  10193b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101940:	c1 e8 03             	shr    $0x3,%eax
  101943:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101947:	89 44 24 04          	mov    %eax,0x4(%esp)
  10194b:	e8 60 e7 ff ff       	call   1000b0 <bread>
  bi = b % BPB;
  101950:	89 da                	mov    %ebx,%edx
  m = 1 << (bi % 8);
  101952:	89 d9                	mov    %ebx,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  101954:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  10195a:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  10195d:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101960:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101962:	0f b6 4c 10 18       	movzbl 0x18(%eax,%edx,1),%ecx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101967:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101969:	0f b6 c1             	movzbl %cl,%eax
  10196c:	85 f0                	test   %esi,%eax
  10196e:	74 22                	je     101992 <bfree+0xb2>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101970:	89 f0                	mov    %esi,%eax
  101972:	f7 d0                	not    %eax
  101974:	21 c8                	and    %ecx,%eax
  101976:	88 44 17 18          	mov    %al,0x18(%edi,%edx,1)
  bwrite(bp);
  10197a:	89 3c 24             	mov    %edi,(%esp)
  10197d:	e8 fe e6 ff ff       	call   100080 <bwrite>
  brelse(bp);
  101982:	89 3c 24             	mov    %edi,(%esp)
  101985:	e8 76 e6 ff ff       	call   100000 <brelse>
}
  10198a:	83 c4 2c             	add    $0x2c,%esp
  10198d:	5b                   	pop    %ebx
  10198e:	5e                   	pop    %esi
  10198f:	5f                   	pop    %edi
  101990:	5d                   	pop    %ebp
  101991:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101992:	c7 04 24 97 66 10 00 	movl   $0x106697,(%esp)
  101999:	e8 42 ef ff ff       	call   1008e0 <panic>
  10199e:	66 90                	xchg   %ax,%ax

001019a0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  1019a0:	55                   	push   %ebp
  1019a1:	89 e5                	mov    %esp,%ebp
  1019a3:	57                   	push   %edi
  1019a4:	56                   	push   %esi
  1019a5:	53                   	push   %ebx
  1019a6:	83 ec 2c             	sub    $0x2c,%esp
  1019a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  1019ac:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  1019b3:	e8 88 2a 00 00       	call   104440 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  1019b8:	8b 46 08             	mov    0x8(%esi),%eax
  1019bb:	83 f8 01             	cmp    $0x1,%eax
  1019be:	0f 85 9e 00 00 00    	jne    101a62 <iput+0xc2>
  1019c4:	8b 56 0c             	mov    0xc(%esi),%edx
  1019c7:	f6 c2 02             	test   $0x2,%dl
  1019ca:	0f 84 92 00 00 00    	je     101a62 <iput+0xc2>
  1019d0:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  1019d5:	0f 85 87 00 00 00    	jne    101a62 <iput+0xc2>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  1019db:	f6 c2 01             	test   $0x1,%dl
  1019de:	66 90                	xchg   %ax,%ax
  1019e0:	0f 85 ef 00 00 00    	jne    101ad5 <iput+0x135>
      panic("iput busy");
    ip->flags |= I_BUSY;
  1019e6:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  1019e9:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  1019eb:	89 56 0c             	mov    %edx,0xc(%esi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  1019ee:	8d 7e 30             	lea    0x30(%esi),%edi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  1019f1:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  1019f8:	e8 03 2a 00 00       	call   104400 <release>
  1019fd:	eb 08                	jmp    101a07 <iput+0x67>
  1019ff:	90                   	nop
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101a00:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101a03:	39 fb                	cmp    %edi,%ebx
  101a05:	74 1c                	je     101a23 <iput+0x83>
    if(ip->addrs[i]){
  101a07:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101a0a:	85 d2                	test   %edx,%edx
  101a0c:	74 f2                	je     101a00 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
  101a0e:	8b 06                	mov    (%esi),%eax
  101a10:	e8 cb fe ff ff       	call   1018e0 <bfree>
      ip->addrs[i] = 0;
  101a15:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101a1c:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101a1f:	39 fb                	cmp    %edi,%ebx
  101a21:	75 e4                	jne    101a07 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101a23:	8b 46 4c             	mov    0x4c(%esi),%eax
  101a26:	85 c0                	test   %eax,%eax
  101a28:	75 56                	jne    101a80 <iput+0xe0>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101a2a:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101a31:	89 34 24             	mov    %esi,(%esp)
  101a34:	e8 e7 fa ff ff       	call   101520 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101a39:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101a3f:	89 34 24             	mov    %esi,(%esp)
  101a42:	e8 d9 fa ff ff       	call   101520 <iupdate>
    acquire(&icache.lock);
  101a47:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101a4e:	e8 ed 29 00 00       	call   104440 <acquire>
    ip->flags &= ~I_BUSY;
  101a53:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101a57:	89 34 24             	mov    %esi,(%esp)
  101a5a:	e8 a1 18 00 00       	call   103300 <wakeup>
  101a5f:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
  101a62:	83 e8 01             	sub    $0x1,%eax
  101a65:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101a68:	c7 45 08 a0 a7 10 00 	movl   $0x10a7a0,0x8(%ebp)
}
  101a6f:	83 c4 2c             	add    $0x2c,%esp
  101a72:	5b                   	pop    %ebx
  101a73:	5e                   	pop    %esi
  101a74:	5f                   	pop    %edi
  101a75:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101a76:	e9 85 29 00 00       	jmp    104400 <release>
  101a7b:	90                   	nop
  101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a84:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101a86:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101a88:	89 04 24             	mov    %eax,(%esp)
  101a8b:	e8 20 e6 ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
  101a90:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101a95:	83 c7 18             	add    $0x18,%edi
  101a98:	31 c0                	xor    %eax,%eax
  101a9a:	eb 11                	jmp    101aad <iput+0x10d>
  101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
  101aa0:	83 c3 01             	add    $0x1,%ebx
  101aa3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101aa9:	89 d8                	mov    %ebx,%eax
  101aab:	74 10                	je     101abd <iput+0x11d>
      if(a[j])
  101aad:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101ab0:	85 d2                	test   %edx,%edx
  101ab2:	74 ec                	je     101aa0 <iput+0x100>
        bfree(ip->dev, a[j]);
  101ab4:	8b 06                	mov    (%esi),%eax
  101ab6:	e8 25 fe ff ff       	call   1018e0 <bfree>
  101abb:	eb e3                	jmp    101aa0 <iput+0x100>
    }
    brelse(bp);
  101abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101ac0:	89 04 24             	mov    %eax,(%esp)
  101ac3:	e8 38 e5 ff ff       	call   100000 <brelse>
    ip->addrs[INDIRECT] = 0;
  101ac8:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101acf:	90                   	nop
  101ad0:	e9 55 ff ff ff       	jmp    101a2a <iput+0x8a>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101ad5:	c7 04 24 aa 66 10 00 	movl   $0x1066aa,(%esp)
  101adc:	e8 ff ed ff ff       	call   1008e0 <panic>
  101ae1:	eb 0d                	jmp    101af0 <dirlink>
  101ae3:	90                   	nop
  101ae4:	90                   	nop
  101ae5:	90                   	nop
  101ae6:	90                   	nop
  101ae7:	90                   	nop
  101ae8:	90                   	nop
  101ae9:	90                   	nop
  101aea:	90                   	nop
  101aeb:	90                   	nop
  101aec:	90                   	nop
  101aed:	90                   	nop
  101aee:	90                   	nop
  101aef:	90                   	nop

00101af0 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101af0:	55                   	push   %ebp
  101af1:	89 e5                	mov    %esp,%ebp
  101af3:	57                   	push   %edi
  101af4:	56                   	push   %esi
  101af5:	53                   	push   %ebx
  101af6:	83 ec 2c             	sub    $0x2c,%esp
  101af9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  101aff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101b06:	00 
  101b07:	89 34 24             	mov    %esi,(%esp)
  101b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0e:	e8 fd fb ff ff       	call   101710 <dirlookup>
  101b13:	85 c0                	test   %eax,%eax
  101b15:	0f 85 89 00 00 00    	jne    101ba4 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101b1b:	8b 7e 18             	mov    0x18(%esi),%edi
  101b1e:	85 ff                	test   %edi,%edi
  101b20:	0f 84 8d 00 00 00    	je     101bb3 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101b26:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101b29:	31 db                	xor    %ebx,%ebx
  101b2b:	eb 0b                	jmp    101b38 <dirlink+0x48>
  101b2d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101b30:	83 c3 10             	add    $0x10,%ebx
  101b33:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101b36:	76 24                	jbe    101b5c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101b38:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101b3f:	00 
  101b40:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101b44:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101b48:	89 34 24             	mov    %esi,(%esp)
  101b4b:	e8 c0 f8 ff ff       	call   101410 <readi>
  101b50:	83 f8 10             	cmp    $0x10,%eax
  101b53:	75 65                	jne    101bba <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101b55:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101b5a:	75 d4                	jne    101b30 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101b5f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101b66:	00 
  101b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6b:	8d 45 da             	lea    -0x26(%ebp),%eax
  101b6e:	89 04 24             	mov    %eax,(%esp)
  101b71:	e8 8a 2a 00 00       	call   104600 <strncpy>
  de.inum = ino;
  101b76:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101b79:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101b80:	00 
  101b81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101b85:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101b89:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101b8d:	89 34 24             	mov    %esi,(%esp)
  101b90:	e8 1b fa ff ff       	call   1015b0 <writei>
  101b95:	83 f8 10             	cmp    $0x10,%eax
  101b98:	75 2c                	jne    101bc6 <dirlink+0xd6>
    panic("dirlink");
  101b9a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101b9c:	83 c4 2c             	add    $0x2c,%esp
  101b9f:	5b                   	pop    %ebx
  101ba0:	5e                   	pop    %esi
  101ba1:	5f                   	pop    %edi
  101ba2:	5d                   	pop    %ebp
  101ba3:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ba4:	89 04 24             	mov    %eax,(%esp)
  101ba7:	e8 f4 fd ff ff       	call   1019a0 <iput>
  101bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101bb1:	eb e9                	jmp    101b9c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101bb3:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101bb6:	31 db                	xor    %ebx,%ebx
  101bb8:	eb a2                	jmp    101b5c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101bba:	c7 04 24 b4 66 10 00 	movl   $0x1066b4,(%esp)
  101bc1:	e8 1a ed ff ff       	call   1008e0 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101bc6:	c7 04 24 c1 66 10 00 	movl   $0x1066c1,(%esp)
  101bcd:	e8 0e ed ff ff       	call   1008e0 <panic>
  101bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101be0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101be0:	55                   	push   %ebp
  101be1:	89 e5                	mov    %esp,%ebp
  101be3:	53                   	push   %ebx
  101be4:	83 ec 14             	sub    $0x14,%esp
  101be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101bea:	85 db                	test   %ebx,%ebx
  101bec:	74 36                	je     101c24 <iunlock+0x44>
  101bee:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101bf2:	74 30                	je     101c24 <iunlock+0x44>
  101bf4:	8b 43 08             	mov    0x8(%ebx),%eax
  101bf7:	85 c0                	test   %eax,%eax
  101bf9:	7e 29                	jle    101c24 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101bfb:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101c02:	e8 39 28 00 00       	call   104440 <acquire>
  ip->flags &= ~I_BUSY;
  101c07:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101c0b:	89 1c 24             	mov    %ebx,(%esp)
  101c0e:	e8 ed 16 00 00       	call   103300 <wakeup>
  release(&icache.lock);
  101c13:	c7 45 08 a0 a7 10 00 	movl   $0x10a7a0,0x8(%ebp)
}
  101c1a:	83 c4 14             	add    $0x14,%esp
  101c1d:	5b                   	pop    %ebx
  101c1e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101c1f:	e9 dc 27 00 00       	jmp    104400 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101c24:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  101c2b:	e8 b0 ec ff ff       	call   1008e0 <panic>

00101c30 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101c30:	55                   	push   %ebp
  101c31:	89 e5                	mov    %esp,%ebp
  101c33:	53                   	push   %ebx
  101c34:	83 ec 14             	sub    $0x14,%esp
  101c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101c3a:	89 1c 24             	mov    %ebx,(%esp)
  101c3d:	e8 9e ff ff ff       	call   101be0 <iunlock>
  iput(ip);
  101c42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101c45:	83 c4 14             	add    $0x14,%esp
  101c48:	5b                   	pop    %ebx
  101c49:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101c4a:	e9 51 fd ff ff       	jmp    1019a0 <iput>
  101c4f:	90                   	nop

00101c50 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101c50:	55                   	push   %ebp
  101c51:	89 e5                	mov    %esp,%ebp
  101c53:	56                   	push   %esi
  101c54:	53                   	push   %ebx
  101c55:	83 ec 10             	sub    $0x10,%esp
  101c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101c5b:	85 db                	test   %ebx,%ebx
  101c5d:	0f 84 e5 00 00 00    	je     101d48 <ilock+0xf8>
  101c63:	8b 53 08             	mov    0x8(%ebx),%edx
  101c66:	85 d2                	test   %edx,%edx
  101c68:	0f 8e da 00 00 00    	jle    101d48 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101c6e:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101c75:	e8 c6 27 00 00       	call   104440 <acquire>
  while(ip->flags & I_BUSY)
  101c7a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101c7d:	a8 01                	test   $0x1,%al
  101c7f:	74 1e                	je     101c9f <ilock+0x4f>
  101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101c88:	c7 44 24 04 a0 a7 10 	movl   $0x10a7a0,0x4(%esp)
  101c8f:	00 
  101c90:	89 1c 24             	mov    %ebx,(%esp)
  101c93:	e8 18 1a 00 00       	call   1036b0 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101c98:	8b 43 0c             	mov    0xc(%ebx),%eax
  101c9b:	a8 01                	test   $0x1,%al
  101c9d:	75 e9                	jne    101c88 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101c9f:	83 c8 01             	or     $0x1,%eax
  101ca2:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  101ca5:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101cac:	e8 4f 27 00 00       	call   104400 <release>

  if(!(ip->flags & I_VALID)){
  101cb1:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  101cb5:	74 09                	je     101cc0 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101cb7:	83 c4 10             	add    $0x10,%esp
  101cba:	5b                   	pop    %ebx
  101cbb:	5e                   	pop    %esi
  101cbc:	5d                   	pop    %ebp
  101cbd:	c3                   	ret    
  101cbe:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101cc0:	8b 43 04             	mov    0x4(%ebx),%eax
  101cc3:	c1 e8 03             	shr    $0x3,%eax
  101cc6:	83 c0 02             	add    $0x2,%eax
  101cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccd:	8b 03                	mov    (%ebx),%eax
  101ccf:	89 04 24             	mov    %eax,(%esp)
  101cd2:	e8 d9 e3 ff ff       	call   1000b0 <bread>
  101cd7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101cd9:	8b 43 04             	mov    0x4(%ebx),%eax
  101cdc:	83 e0 07             	and    $0x7,%eax
  101cdf:	c1 e0 06             	shl    $0x6,%eax
  101ce2:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  101ce6:	0f b7 10             	movzwl (%eax),%edx
  101ce9:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  101ced:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101cf1:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  101cf5:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101cf9:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  101cfd:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101d01:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  101d05:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101d08:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101d0b:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d12:	8d 43 1c             	lea    0x1c(%ebx),%eax
  101d15:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101d1c:	00 
  101d1d:	89 04 24             	mov    %eax,(%esp)
  101d20:	e8 1b 28 00 00       	call   104540 <memmove>
    brelse(bp);
  101d25:	89 34 24             	mov    %esi,(%esp)
  101d28:	e8 d3 e2 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101d2d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101d31:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101d36:	0f 85 7b ff ff ff    	jne    101cb7 <ilock+0x67>
      panic("ilock: no type");
  101d3c:	c7 04 24 d7 66 10 00 	movl   $0x1066d7,(%esp)
  101d43:	e8 98 eb ff ff       	call   1008e0 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101d48:	c7 04 24 d1 66 10 00 	movl   $0x1066d1,(%esp)
  101d4f:	e8 8c eb ff ff       	call   1008e0 <panic>
  101d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101d60 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101d60:	55                   	push   %ebp
  101d61:	89 e5                	mov    %esp,%ebp
  101d63:	57                   	push   %edi
  101d64:	56                   	push   %esi
  101d65:	53                   	push   %ebx
  101d66:	89 c3                	mov    %eax,%ebx
  101d68:	83 ec 2c             	sub    $0x2c,%esp
  101d6b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101d71:	80 38 2f             	cmpb   $0x2f,(%eax)
  101d74:	0f 84 3b 01 00 00    	je     101eb5 <_namei+0x155>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101d7a:	e8 81 16 00 00       	call   103400 <curproc>
  101d7f:	8b 40 60             	mov    0x60(%eax),%eax
  101d82:	89 04 24             	mov    %eax,(%esp)
  101d85:	e8 96 f3 ff ff       	call   101120 <idup>
  101d8a:	89 c7                	mov    %eax,%edi
  101d8c:	eb 05                	jmp    101d93 <_namei+0x33>
  101d8e:	66 90                	xchg   %ax,%ax
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101d90:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101d93:	0f b6 03             	movzbl (%ebx),%eax
  101d96:	3c 2f                	cmp    $0x2f,%al
  101d98:	74 f6                	je     101d90 <_namei+0x30>
    path++;
  if(*path == 0)
  101d9a:	84 c0                	test   %al,%al
  101d9c:	75 1a                	jne    101db8 <_namei+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  101d9e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101da1:	85 c9                	test   %ecx,%ecx
  101da3:	0f 85 34 01 00 00    	jne    101edd <_namei+0x17d>
    iput(ip);
    return 0;
  }
  return ip;
}
  101da9:	83 c4 2c             	add    $0x2c,%esp
  101dac:	89 f8                	mov    %edi,%eax
  101dae:	5b                   	pop    %ebx
  101daf:	5e                   	pop    %esi
  101db0:	5f                   	pop    %edi
  101db1:	5d                   	pop    %ebp
  101db2:	c3                   	ret    
  101db3:	90                   	nop
  101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101db8:	3c 2f                	cmp    $0x2f,%al
  101dba:	0f 84 db 00 00 00    	je     101e9b <_namei+0x13b>
  101dc0:	89 de                	mov    %ebx,%esi
    path++;
  101dc2:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101dc5:	0f b6 06             	movzbl (%esi),%eax
  101dc8:	84 c0                	test   %al,%al
  101dca:	0f 85 90 00 00 00    	jne    101e60 <_namei+0x100>
  101dd0:	89 f2                	mov    %esi,%edx
  101dd2:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  101dd4:	83 fa 0d             	cmp    $0xd,%edx
  101dd7:	0f 8e 99 00 00 00    	jle    101e76 <_namei+0x116>
  101ddd:	8d 76 00             	lea    0x0(%esi),%esi
    memmove(name, s, DIRSIZ);
  101de0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101de7:	00 
  101de8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101def:	89 04 24             	mov    %eax,(%esp)
  101df2:	e8 49 27 00 00       	call   104540 <memmove>
  101df7:	eb 0a                	jmp    101e03 <_namei+0xa3>
  101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101e00:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101e03:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101e06:	74 f8                	je     101e00 <_namei+0xa0>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101e08:	85 f6                	test   %esi,%esi
  101e0a:	74 92                	je     101d9e <_namei+0x3e>
    ilock(ip);
  101e0c:	89 3c 24             	mov    %edi,(%esp)
  101e0f:	e8 3c fe ff ff       	call   101c50 <ilock>
    if(ip->type != T_DIR){
  101e14:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  101e19:	0f 85 82 00 00 00    	jne    101ea1 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101e1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  101e22:	85 db                	test   %ebx,%ebx
  101e24:	74 09                	je     101e2f <_namei+0xcf>
  101e26:	80 3e 00             	cmpb   $0x0,(%esi)
  101e29:	0f 84 9c 00 00 00    	je     101ecb <_namei+0x16b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101e36:	00 
  101e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e3a:	89 3c 24             	mov    %edi,(%esp)
  101e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e41:	e8 ca f8 ff ff       	call   101710 <dirlookup>
  101e46:	85 c0                	test   %eax,%eax
  101e48:	89 c3                	mov    %eax,%ebx
  101e4a:	74 55                	je     101ea1 <_namei+0x141>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101e4c:	89 3c 24             	mov    %edi,(%esp)
  101e4f:	89 df                	mov    %ebx,%edi
  101e51:	89 f3                	mov    %esi,%ebx
  101e53:	e8 d8 fd ff ff       	call   101c30 <iunlockput>
  101e58:	e9 36 ff ff ff       	jmp    101d93 <_namei+0x33>
  101e5d:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101e60:	3c 2f                	cmp    $0x2f,%al
  101e62:	0f 85 5a ff ff ff    	jne    101dc2 <_namei+0x62>
  101e68:	89 f2                	mov    %esi,%edx
  101e6a:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  101e6c:	83 fa 0d             	cmp    $0xd,%edx
  101e6f:	90                   	nop
  101e70:	0f 8f 6a ff ff ff    	jg     101de0 <_namei+0x80>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101e76:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e7a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e81:	89 04 24             	mov    %eax,(%esp)
  101e84:	89 55 dc             	mov    %edx,-0x24(%ebp)
  101e87:	e8 b4 26 00 00       	call   104540 <memmove>
    name[len] = 0;
  101e8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e92:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101e96:	e9 68 ff ff ff       	jmp    101e03 <_namei+0xa3>
  }
  while(*path == '/')
  101e9b:	89 de                	mov    %ebx,%esi
  101e9d:	31 d2                	xor    %edx,%edx
  101e9f:	eb d5                	jmp    101e76 <_namei+0x116>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101ea1:	89 3c 24             	mov    %edi,(%esp)
  101ea4:	31 ff                	xor    %edi,%edi
  101ea6:	e8 85 fd ff ff       	call   101c30 <iunlockput>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101eab:	83 c4 2c             	add    $0x2c,%esp
  101eae:	89 f8                	mov    %edi,%eax
  101eb0:	5b                   	pop    %ebx
  101eb1:	5e                   	pop    %esi
  101eb2:	5f                   	pop    %edi
  101eb3:	5d                   	pop    %ebp
  101eb4:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  101eb5:	ba 01 00 00 00       	mov    $0x1,%edx
  101eba:	b8 01 00 00 00       	mov    $0x1,%eax
  101ebf:	e8 8c f2 ff ff       	call   101150 <iget>
  101ec4:	89 c7                	mov    %eax,%edi
  101ec6:	e9 c8 fe ff ff       	jmp    101d93 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101ecb:	89 3c 24             	mov    %edi,(%esp)
  101ece:	e8 0d fd ff ff       	call   101be0 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101ed3:	83 c4 2c             	add    $0x2c,%esp
  101ed6:	89 f8                	mov    %edi,%eax
  101ed8:	5b                   	pop    %ebx
  101ed9:	5e                   	pop    %esi
  101eda:	5f                   	pop    %edi
  101edb:	5d                   	pop    %ebp
  101edc:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  101edd:	89 3c 24             	mov    %edi,(%esp)
  101ee0:	31 ff                	xor    %edi,%edi
  101ee2:	e8 b9 fa ff ff       	call   1019a0 <iput>
    return 0;
  101ee7:	e9 bd fe ff ff       	jmp    101da9 <_namei+0x49>
  101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101ef0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ef0:	55                   	push   %ebp
  return _namei(path, 1, name);
  101ef1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ef6:	89 e5                	mov    %esp,%ebp
  101ef8:	83 ec 08             	sub    $0x8,%esp
  return _namei(path, 1, name);
  101efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  101efe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  101f01:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  101f02:	e9 59 fe ff ff       	jmp    101d60 <_namei>
  101f07:	89 f6                	mov    %esi,%esi
  101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101f10 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101f11:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  101f13:	89 e5                	mov    %esp,%ebp
  101f15:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101f18:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  101f1e:	e8 3d fe ff ff       	call   101d60 <_namei>
}
  101f23:	c9                   	leave  
  101f24:	c3                   	ret    
  101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101f30 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  101f30:	55                   	push   %ebp
  101f31:	89 e5                	mov    %esp,%ebp
  101f33:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache.lock");
  101f36:	c7 44 24 04 e6 66 10 	movl   $0x1066e6,0x4(%esp)
  101f3d:	00 
  101f3e:	c7 04 24 a0 a7 10 00 	movl   $0x10a7a0,(%esp)
  101f45:	e8 36 23 00 00       	call   104280 <initlock>
}
  101f4a:	c9                   	leave  
  101f4b:	c3                   	ret    
  101f4c:	90                   	nop
  101f4d:	90                   	nop
  101f4e:	90                   	nop
  101f4f:	90                   	nop

00101f50 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  101f50:	55                   	push   %ebp
  101f51:	89 c1                	mov    %eax,%ecx
  101f53:	89 e5                	mov    %esp,%ebp
  101f55:	56                   	push   %esi
  101f56:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  101f59:	85 c0                	test   %eax,%eax
  101f5b:	0f 84 89 00 00 00    	je     101fea <ide_start_request+0x9a>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101f66:	66 90                	xchg   %ax,%ax
  101f68:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  101f69:	0f b6 c0             	movzbl %al,%eax
  101f6c:	84 c0                	test   %al,%al
  101f6e:	78 f8                	js     101f68 <ide_start_request+0x18>
  101f70:	a8 40                	test   $0x40,%al
  101f72:	74 f4                	je     101f68 <ide_start_request+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101f74:	ba f6 03 00 00       	mov    $0x3f6,%edx
  101f79:	31 c0                	xor    %eax,%eax
  101f7b:	ee                   	out    %al,(%dx)
  101f7c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  101f81:	b8 01 00 00 00       	mov    $0x1,%eax
  101f86:	ee                   	out    %al,(%dx)
    panic("ide_start_request");

  ide_wait_ready(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  101f87:	8b 71 08             	mov    0x8(%ecx),%esi
  101f8a:	b2 f3                	mov    $0xf3,%dl
  101f8c:	89 f0                	mov    %esi,%eax
  101f8e:	ee                   	out    %al,(%dx)
  101f8f:	89 f0                	mov    %esi,%eax
  101f91:	b2 f4                	mov    $0xf4,%dl
  101f93:	c1 e8 08             	shr    $0x8,%eax
  101f96:	ee                   	out    %al,(%dx)
  101f97:	89 f0                	mov    %esi,%eax
  101f99:	b2 f5                	mov    $0xf5,%dl
  101f9b:	c1 e8 10             	shr    $0x10,%eax
  101f9e:	ee                   	out    %al,(%dx)
  101f9f:	8b 41 04             	mov    0x4(%ecx),%eax
  101fa2:	c1 ee 18             	shr    $0x18,%esi
  101fa5:	b2 f6                	mov    $0xf6,%dl
  101fa7:	83 e6 0f             	and    $0xf,%esi
  101faa:	83 e0 01             	and    $0x1,%eax
  101fad:	c1 e0 04             	shl    $0x4,%eax
  101fb0:	09 f0                	or     %esi,%eax
  101fb2:	83 c8 e0             	or     $0xffffffe0,%eax
  101fb5:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  101fb6:	f6 01 04             	testb  $0x4,(%ecx)
  101fb9:	75 11                	jne    101fcc <ide_start_request+0x7c>
  101fbb:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101fc0:	b8 20 00 00 00       	mov    $0x20,%eax
  101fc5:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  101fc6:	83 c4 14             	add    $0x14,%esp
  101fc9:	5e                   	pop    %esi
  101fca:	5d                   	pop    %ebp
  101fcb:	c3                   	ret    
  101fcc:	b2 f7                	mov    $0xf7,%dl
  101fce:	b8 30 00 00 00       	mov    $0x30,%eax
  101fd3:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  101fd4:	ba f0 01 00 00       	mov    $0x1f0,%edx
  101fd9:	8d 71 18             	lea    0x18(%ecx),%esi
  101fdc:	b9 80 00 00 00       	mov    $0x80,%ecx
  101fe1:	fc                   	cld    
  101fe2:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  101fe4:	83 c4 14             	add    $0x14,%esp
  101fe7:	5e                   	pop    %esi
  101fe8:	5d                   	pop    %ebp
  101fe9:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  101fea:	c7 04 24 f2 66 10 00 	movl   $0x1066f2,(%esp)
  101ff1:	e8 ea e8 ff ff       	call   1008e0 <panic>
  101ff6:	8d 76 00             	lea    0x0(%esi),%esi
  101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102000 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102000:	55                   	push   %ebp
  102001:	89 e5                	mov    %esp,%ebp
  102003:	53                   	push   %ebx
  102004:	83 ec 14             	sub    $0x14,%esp
  102007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10200a:	8b 03                	mov    (%ebx),%eax
  10200c:	a8 01                	test   $0x1,%al
  10200e:	0f 84 90 00 00 00    	je     1020a4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102014:	83 e0 06             	and    $0x6,%eax
  102017:	83 f8 02             	cmp    $0x2,%eax
  10201a:	0f 84 9c 00 00 00    	je     1020bc <ide_rw+0xbc>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102020:	8b 53 04             	mov    0x4(%ebx),%edx
  102023:	85 d2                	test   %edx,%edx
  102025:	74 0d                	je     102034 <ide_rw+0x34>
  102027:	a1 58 85 10 00       	mov    0x108558,%eax
  10202c:	85 c0                	test   %eax,%eax
  10202e:	0f 84 7c 00 00 00    	je     1020b0 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102034:	c7 04 24 20 85 10 00 	movl   $0x108520,(%esp)
  10203b:	e8 00 24 00 00       	call   104440 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102040:	a1 54 85 10 00       	mov    0x108554,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102045:	ba 54 85 10 00       	mov    $0x108554,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10204a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102051:	85 c0                	test   %eax,%eax
  102053:	74 0d                	je     102062 <ide_rw+0x62>
  102055:	8d 76 00             	lea    0x0(%esi),%esi
  102058:	8d 50 14             	lea    0x14(%eax),%edx
  10205b:	8b 40 14             	mov    0x14(%eax),%eax
  10205e:	85 c0                	test   %eax,%eax
  102060:	75 f6                	jne    102058 <ide_rw+0x58>
    ;
  *pp = b;
  102062:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  102064:	39 1d 54 85 10 00    	cmp    %ebx,0x108554
  10206a:	75 14                	jne    102080 <ide_rw+0x80>
  10206c:	eb 2d                	jmp    10209b <ide_rw+0x9b>
  10206e:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102070:	c7 44 24 04 20 85 10 	movl   $0x108520,0x4(%esp)
  102077:	00 
  102078:	89 1c 24             	mov    %ebx,(%esp)
  10207b:	e8 30 16 00 00       	call   1036b0 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102080:	8b 03                	mov    (%ebx),%eax
  102082:	83 e0 06             	and    $0x6,%eax
  102085:	83 f8 02             	cmp    $0x2,%eax
  102088:	75 e6                	jne    102070 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10208a:	c7 45 08 20 85 10 00 	movl   $0x108520,0x8(%ebp)
}
  102091:	83 c4 14             	add    $0x14,%esp
  102094:	5b                   	pop    %ebx
  102095:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102096:	e9 65 23 00 00       	jmp    104400 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  10209b:	89 d8                	mov    %ebx,%eax
  10209d:	e8 ae fe ff ff       	call   101f50 <ide_start_request>
  1020a2:	eb dc                	jmp    102080 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1020a4:	c7 04 24 04 67 10 00 	movl   $0x106704,(%esp)
  1020ab:	e8 30 e8 ff ff       	call   1008e0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1020b0:	c7 04 24 2f 67 10 00 	movl   $0x10672f,(%esp)
  1020b7:	e8 24 e8 ff ff       	call   1008e0 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1020bc:	c7 04 24 19 67 10 00 	movl   $0x106719,(%esp)
  1020c3:	e8 18 e8 ff ff       	call   1008e0 <panic>
  1020c8:	90                   	nop
  1020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001020d0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1020d0:	55                   	push   %ebp
  1020d1:	89 e5                	mov    %esp,%ebp
  1020d3:	57                   	push   %edi
  1020d4:	53                   	push   %ebx
  1020d5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1020d8:	c7 04 24 20 85 10 00 	movl   $0x108520,(%esp)
  1020df:	e8 5c 23 00 00       	call   104440 <acquire>
  if((b = ide_queue) == 0){
  1020e4:	8b 1d 54 85 10 00    	mov    0x108554,%ebx
  1020ea:	85 db                	test   %ebx,%ebx
  1020ec:	74 28                	je     102116 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1020ee:	8b 0b                	mov    (%ebx),%ecx
  1020f0:	f6 c1 04             	test   $0x4,%cl
  1020f3:	74 3b                	je     102130 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1020f5:	83 c9 02             	or     $0x2,%ecx
  1020f8:	83 e1 fb             	and    $0xfffffffb,%ecx
  1020fb:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  1020fd:	89 1c 24             	mov    %ebx,(%esp)
  102100:	e8 fb 11 00 00       	call   103300 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102105:	8b 43 14             	mov    0x14(%ebx),%eax
  102108:	85 c0                	test   %eax,%eax
  10210a:	a3 54 85 10 00       	mov    %eax,0x108554
  10210f:	74 05                	je     102116 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102111:	e8 3a fe ff ff       	call   101f50 <ide_start_request>

  release(&ide_lock);
  102116:	c7 04 24 20 85 10 00 	movl   $0x108520,(%esp)
  10211d:	e8 de 22 00 00       	call   104400 <release>
}
  102122:	83 c4 10             	add    $0x10,%esp
  102125:	5b                   	pop    %ebx
  102126:	5f                   	pop    %edi
  102127:	5d                   	pop    %ebp
  102128:	c3                   	ret    
  102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102130:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102135:	8d 76 00             	lea    0x0(%esi),%esi
  102138:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  102139:	0f b6 c0             	movzbl %al,%eax
  10213c:	84 c0                	test   %al,%al
  10213e:	78 f8                	js     102138 <ide_intr+0x68>
  102140:	a8 40                	test   $0x40,%al
  102142:	74 f4                	je     102138 <ide_intr+0x68>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102144:	a8 21                	test   $0x21,%al
  102146:	75 ad                	jne    1020f5 <ide_intr+0x25>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102148:	8d 7b 18             	lea    0x18(%ebx),%edi
  10214b:	b9 80 00 00 00       	mov    $0x80,%ecx
  102150:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102155:	fc                   	cld    
  102156:	f2 6d                	repnz insl (%dx),%es:(%edi)
  102158:	8b 0b                	mov    (%ebx),%ecx
  10215a:	eb 99                	jmp    1020f5 <ide_intr+0x25>
  10215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102160 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102160:	55                   	push   %ebp
  102161:	89 e5                	mov    %esp,%ebp
  102163:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&ide_lock, "ide");
  102166:	c7 44 24 04 46 67 10 	movl   $0x106746,0x4(%esp)
  10216d:	00 
  10216e:	c7 04 24 20 85 10 00 	movl   $0x108520,(%esp)
  102175:	e8 06 21 00 00       	call   104280 <initlock>
  pic_enable(IRQ_IDE);
  10217a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102181:	e8 8a 0b 00 00       	call   102d10 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102186:	a1 40 be 10 00       	mov    0x10be40,%eax
  10218b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102192:	83 e8 01             	sub    $0x1,%eax
  102195:	89 44 24 04          	mov    %eax,0x4(%esp)
  102199:	e8 52 00 00 00       	call   1021f0 <ioapic_enable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10219e:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1021a3:	90                   	nop
  1021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1021a8:	ec                   	in     (%dx),%al
static int
ide_wait_ready(int check_error)
{
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  1021a9:	0f b6 c0             	movzbl %al,%eax
  1021ac:	84 c0                	test   %al,%al
  1021ae:	78 f8                	js     1021a8 <ide_init+0x48>
  1021b0:	a8 40                	test   $0x40,%al
  1021b2:	74 f4                	je     1021a8 <ide_init+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021b4:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1021b9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1021be:	ee                   	out    %al,(%dx)
  1021bf:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1021c1:	b2 f7                	mov    $0xf7,%dl
  1021c3:	eb 0e                	jmp    1021d3 <ide_init+0x73>
  1021c5:	8d 76 00             	lea    0x0(%esi),%esi
  ioapic_enable(IRQ_IDE, ncpu - 1);
  ide_wait_ready(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1021c8:	83 c1 01             	add    $0x1,%ecx
  1021cb:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1021d1:	74 0f                	je     1021e2 <ide_init+0x82>
  1021d3:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1021d4:	84 c0                	test   %al,%al
  1021d6:	74 f0                	je     1021c8 <ide_init+0x68>
      disk_1_present = 1;
  1021d8:	c7 05 58 85 10 00 01 	movl   $0x1,0x108558
  1021df:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021e2:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1021e7:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1021ec:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1021ed:	c9                   	leave  
  1021ee:	c3                   	ret    
  1021ef:	90                   	nop

001021f0 <ioapic_enable>:
}

void
ioapic_enable(int irq, int cpunum)
{
  if(!ismp)
  1021f0:	8b 15 c0 b7 10 00    	mov    0x10b7c0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1021f6:	55                   	push   %ebp
  1021f7:	89 e5                	mov    %esp,%ebp
  1021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  1021fc:	85 d2                	test   %edx,%edx
  1021fe:	74 1f                	je     10221f <ioapic_enable+0x2f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102200:	8d 48 20             	lea    0x20(%eax),%ecx
  102203:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102207:	a1 74 b7 10 00       	mov    0x10b774,%eax
  10220c:	89 10                	mov    %edx,(%eax)
  10220e:	83 c2 01             	add    $0x1,%edx
  ioapic->data = data;
  102211:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102217:	89 10                	mov    %edx,(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102219:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  10221c:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10221f:	5d                   	pop    %ebp
  102220:	c3                   	ret    
  102221:	eb 0d                	jmp    102230 <ioapic_init>
  102223:	90                   	nop
  102224:	90                   	nop
  102225:	90                   	nop
  102226:	90                   	nop
  102227:	90                   	nop
  102228:	90                   	nop
  102229:	90                   	nop
  10222a:	90                   	nop
  10222b:	90                   	nop
  10222c:	90                   	nop
  10222d:	90                   	nop
  10222e:	90                   	nop
  10222f:	90                   	nop

00102230 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102230:	55                   	push   %ebp
  102231:	89 e5                	mov    %esp,%ebp
  102233:	56                   	push   %esi
  102234:	53                   	push   %ebx
  102235:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102238:	8b 0d c0 b7 10 00    	mov    0x10b7c0,%ecx
  10223e:	85 c9                	test   %ecx,%ecx
  102240:	0f 84 86 00 00 00    	je     1022cc <ioapic_init+0x9c>
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  102246:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10224d:	00 00 00 
  return ioapic->data;
  102250:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102256:	b8 00 00 c0 fe       	mov    $0xfec00000,%eax
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  10225b:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102262:	00 00 00 
  return ioapic->data;
  102265:	8b 15 10 00 c0 fe    	mov    0xfec00010,%edx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10226b:	0f b6 0d c4 b7 10 00 	movzbl 0x10b7c4,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102272:	c7 05 74 b7 10 00 00 	movl   $0xfec00000,0x10b774
  102279:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10227c:	c1 ee 10             	shr    $0x10,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  10227f:	c1 ea 18             	shr    $0x18,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102282:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapic_read(REG_ID) >> 24;
  if(id != ioapic_id)
  102288:	39 d1                	cmp    %edx,%ecx
  10228a:	74 11                	je     10229d <ioapic_init+0x6d>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10228c:	c7 04 24 4c 67 10 00 	movl   $0x10674c,(%esp)
  102293:	e8 a8 e4 ff ff       	call   100740 <cprintf>
  102298:	a1 74 b7 10 00       	mov    0x10b774,%eax
  10229d:	b9 10 00 00 00       	mov    $0x10,%ecx
  1022a2:	31 d2                	xor    %edx,%edx
  1022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1022a8:	8d 5a 20             	lea    0x20(%edx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1022ab:	83 c2 01             	add    $0x1,%edx
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1022ae:	81 cb 00 00 01 00    	or     $0x10000,%ebx
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1022b4:	89 08                	mov    %ecx,(%eax)
  ioapic->data = data;
  1022b6:	89 58 10             	mov    %ebx,0x10(%eax)
  1022b9:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1022bc:	83 c1 02             	add    $0x2,%ecx
  1022bf:	39 d6                	cmp    %edx,%esi
}

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1022c1:	89 18                	mov    %ebx,(%eax)
  ioapic->data = data;
  1022c3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1022ca:	7d dc                	jge    1022a8 <ioapic_init+0x78>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1022cc:	83 c4 10             	add    $0x10,%esp
  1022cf:	5b                   	pop    %ebx
  1022d0:	5e                   	pop    %esi
  1022d1:	5d                   	pop    %ebp
  1022d2:	c3                   	ret    
  1022d3:	90                   	nop
  1022d4:	90                   	nop
  1022d5:	90                   	nop
  1022d6:	90                   	nop
  1022d7:	90                   	nop
  1022d8:	90                   	nop
  1022d9:	90                   	nop
  1022da:	90                   	nop
  1022db:	90                   	nop
  1022dc:	90                   	nop
  1022dd:	90                   	nop
  1022de:	90                   	nop
  1022df:	90                   	nop

001022e0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1022e0:	55                   	push   %ebp
  1022e1:	89 e5                	mov    %esp,%ebp
  1022e3:	56                   	push   %esi
  1022e4:	53                   	push   %ebx
  1022e5:	83 ec 10             	sub    $0x10,%esp
  1022e8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1022eb:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1022f1:	74 0d                	je     102300 <kalloc+0x20>
    panic("kalloc");
  1022f3:	c7 04 24 80 67 10 00 	movl   $0x106780,(%esp)
  1022fa:	e8 e1 e5 ff ff       	call   1008e0 <panic>
  1022ff:	90                   	nop
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  102300:	85 f6                	test   %esi,%esi
  102302:	7e ef                	jle    1022f3 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  102304:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  10230b:	e8 30 21 00 00       	call   104440 <acquire>
  102310:	8b 1d b4 b7 10 00    	mov    0x10b7b4,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102316:	85 db                	test   %ebx,%ebx
  102318:	74 3e                	je     102358 <kalloc+0x78>
    if(r->len == n){
  10231a:	8b 43 04             	mov    0x4(%ebx),%eax
  10231d:	ba b4 b7 10 00       	mov    $0x10b7b4,%edx
  102322:	39 f0                	cmp    %esi,%eax
  102324:	75 11                	jne    102337 <kalloc+0x57>
  102326:	eb 58                	jmp    102380 <kalloc+0xa0>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102328:	89 da                	mov    %ebx,%edx
  10232a:	8b 1b                	mov    (%ebx),%ebx
  10232c:	85 db                	test   %ebx,%ebx
  10232e:	74 28                	je     102358 <kalloc+0x78>
    if(r->len == n){
  102330:	8b 43 04             	mov    0x4(%ebx),%eax
  102333:	39 f0                	cmp    %esi,%eax
  102335:	74 49                	je     102380 <kalloc+0xa0>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102337:	39 c6                	cmp    %eax,%esi
  102339:	7d ed                	jge    102328 <kalloc+0x48>
      r->len -= n;
  10233b:	29 f0                	sub    %esi,%eax
  10233d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102340:	01 c3                	add    %eax,%ebx
      release(&kalloc_lock);
  102342:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  102349:	e8 b2 20 00 00       	call   104400 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10234e:	83 c4 10             	add    $0x10,%esp
  102351:	89 d8                	mov    %ebx,%eax
  102353:	5b                   	pop    %ebx
  102354:	5e                   	pop    %esi
  102355:	5d                   	pop    %ebp
  102356:	c3                   	ret    
  102357:	90                   	nop
      return p;
    }
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  102358:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  10235a:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  102361:	e8 9a 20 00 00       	call   104400 <release>

  cprintf("kalloc: out of memory\n");
  102366:	c7 04 24 87 67 10 00 	movl   $0x106787,(%esp)
  10236d:	e8 ce e3 ff ff       	call   100740 <cprintf>
  return 0;
}
  102372:	83 c4 10             	add    $0x10,%esp
  102375:	89 d8                	mov    %ebx,%eax
  102377:	5b                   	pop    %ebx
  102378:	5e                   	pop    %esi
  102379:	5d                   	pop    %ebp
  10237a:	c3                   	ret    
  10237b:	90                   	nop
  10237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  102380:	8b 03                	mov    (%ebx),%eax
  102382:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  102384:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  10238b:	e8 70 20 00 00       	call   104400 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  102390:	83 c4 10             	add    $0x10,%esp
  102393:	89 d8                	mov    %ebx,%eax
  102395:	5b                   	pop    %ebx
  102396:	5e                   	pop    %esi
  102397:	5d                   	pop    %ebp
  102398:	c3                   	ret    
  102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001023a0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1023a0:	55                   	push   %ebp
  1023a1:	89 e5                	mov    %esp,%ebp
  1023a3:	57                   	push   %edi
  1023a4:	56                   	push   %esi
  1023a5:	53                   	push   %ebx
  1023a6:	83 ec 2c             	sub    $0x2c,%esp
  1023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1023ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1023af:	85 c0                	test   %eax,%eax
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1023b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1023b4:	0f 8e e9 00 00 00    	jle    1024a3 <kfree+0x103>
  1023ba:	a9 ff 0f 00 00       	test   $0xfff,%eax
  1023bf:	0f 85 de 00 00 00    	jne    1024a3 <kfree+0x103>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1023c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1023c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1023cf:	00 
  1023d0:	89 1c 24             	mov    %ebx,(%esp)
  1023d3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1023d7:	e8 d4 20 00 00       	call   1044b0 <memset>

  acquire(&kalloc_lock);
  1023dc:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  1023e3:	e8 58 20 00 00       	call   104440 <acquire>
  p = (struct run*)v;
  1023e8:	a1 b4 b7 10 00       	mov    0x10b7b4,%eax
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023ed:	85 c0                	test   %eax,%eax
  1023ef:	74 61                	je     102452 <kfree+0xb2>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1023f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1023f4:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1023f7:	39 c1                	cmp    %eax,%ecx
  1023f9:	72 57                	jb     102452 <kfree+0xb2>
    rend = (struct run*)((char*)r + r->len);
  1023fb:	8b 70 04             	mov    0x4(%eax),%esi
  1023fe:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102401:	39 d3                	cmp    %edx,%ebx
  102403:	72 73                	jb     102478 <kfree+0xd8>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102405:	39 c1                	cmp    %eax,%ecx
  102407:	0f 84 8f 00 00 00    	je     10249c <kfree+0xfc>
  10240d:	8d 76 00             	lea    0x0(%esi),%esi
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102410:	39 da                	cmp    %ebx,%edx
  102412:	74 6c                	je     102480 <kfree+0xe0>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102414:	89 c7                	mov    %eax,%edi
  102416:	8b 00                	mov    (%eax),%eax
  102418:	85 c0                	test   %eax,%eax
  10241a:	74 3c                	je     102458 <kfree+0xb8>
  10241c:	39 c1                	cmp    %eax,%ecx
  10241e:	72 38                	jb     102458 <kfree+0xb8>
    rend = (struct run*)((char*)r + r->len);
  102420:	8b 70 04             	mov    0x4(%eax),%esi
  102423:	8d 14 30             	lea    (%eax,%esi,1),%edx
    if(r <= p && p < rend)
  102426:	39 d3                	cmp    %edx,%ebx
  102428:	73 16                	jae    102440 <kfree+0xa0>
  10242a:	39 c3                	cmp    %eax,%ebx
  10242c:	72 12                	jb     102440 <kfree+0xa0>
      panic("freeing free page");
  10242e:	c7 04 24 a4 67 10 00 	movl   $0x1067a4,(%esp)
  102435:	e8 a6 e4 ff ff       	call   1008e0 <panic>
  10243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  102440:	39 c1                	cmp    %eax,%ecx
  102442:	75 cc                	jne    102410 <kfree+0x70>
      p->len = len + r->len;
      p->next = r->next;
  102444:	8b 01                	mov    (%ecx),%eax
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  102446:	03 75 e4             	add    -0x1c(%ebp),%esi
      p->next = r->next;
  102449:	89 03                	mov    %eax,(%ebx)
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
      p->len = len + r->len;
  10244b:	89 73 04             	mov    %esi,0x4(%ebx)
      p->next = r->next;
      *rp = p;
  10244e:	89 1f                	mov    %ebx,(%edi)
      goto out;
  102450:	eb 10                	jmp    102462 <kfree+0xc2>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102452:	bf b4 b7 10 00       	mov    $0x10b7b4,%edi
  102457:	90                   	nop
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->next = r;
  10245b:	89 03                	mov    %eax,(%ebx)
  *rp = p;
  10245d:	89 1f                	mov    %ebx,(%edi)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  10245f:	89 53 04             	mov    %edx,0x4(%ebx)
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102462:	c7 45 08 80 b7 10 00 	movl   $0x10b780,0x8(%ebp)
}
  102469:	83 c4 2c             	add    $0x2c,%esp
  10246c:	5b                   	pop    %ebx
  10246d:	5e                   	pop    %esi
  10246e:	5f                   	pop    %edi
  10246f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102470:	e9 8b 1f 00 00       	jmp    104400 <release>
  102475:	8d 76 00             	lea    0x0(%esi),%esi
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102478:	39 c3                	cmp    %eax,%ebx
  10247a:	73 b2                	jae    10242e <kfree+0x8e>
  10247c:	eb 87                	jmp    102405 <kfree+0x65>
  10247e:	66 90                	xchg   %ax,%ax
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102480:	8b 10                	mov    (%eax),%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102482:	03 75 e4             	add    -0x1c(%ebp),%esi
      if(r->next && r->next == pend){  // r now next to r->next?
  102485:	85 d2                	test   %edx,%edx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102487:	89 70 04             	mov    %esi,0x4(%eax)
      if(r->next && r->next == pend){  // r now next to r->next?
  10248a:	74 d6                	je     102462 <kfree+0xc2>
  10248c:	39 d1                	cmp    %edx,%ecx
  10248e:	75 d2                	jne    102462 <kfree+0xc2>
        r->len += r->next->len;
        r->next = r->next->next;
  102490:	8b 11                	mov    (%ecx),%edx
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102492:	03 71 04             	add    0x4(%ecx),%esi
        r->next = r->next->next;
  102495:	89 10                	mov    %edx,(%eax)
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
        r->len += r->next->len;
  102497:	89 70 04             	mov    %esi,0x4(%eax)
  10249a:	eb c6                	jmp    102462 <kfree+0xc2>
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  10249c:	bf b4 b7 10 00       	mov    $0x10b7b4,%edi
  1024a1:	eb a1                	jmp    102444 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  1024a3:	c7 04 24 9e 67 10 00 	movl   $0x10679e,(%esp)
  1024aa:	e8 31 e4 ff ff       	call   1008e0 <panic>
  1024af:	90                   	nop

001024b0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1024b0:	55                   	push   %ebp
  1024b1:	89 e5                	mov    %esp,%ebp
  1024b3:	83 ec 18             	sub    $0x18,%esp
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1024b6:	c7 44 24 04 80 67 10 	movl   $0x106780,0x4(%esp)
  1024bd:	00 
  1024be:	c7 04 24 80 b7 10 00 	movl   $0x10b780,(%esp)
  1024c5:	e8 b6 1d 00 00       	call   104280 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1024ca:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024d1:	00 
  1024d2:	c7 04 24 b6 67 10 00 	movl   $0x1067b6,(%esp)
  1024d9:	e8 62 e2 ff ff       	call   100740 <cprintf>
  kfree(start, mem * PAGE);
  1024de:	b8 e4 fd 10 00       	mov    $0x10fde4,%eax
  1024e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1024e8:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024ef:	00 
  1024f0:	89 04 24             	mov    %eax,(%esp)
  1024f3:	e8 a8 fe ff ff       	call   1023a0 <kfree>
}
  1024f8:	c9                   	leave  
  1024f9:	c3                   	ret    
  1024fa:	90                   	nop
  1024fb:	90                   	nop
  1024fc:	90                   	nop
  1024fd:	90                   	nop
  1024fe:	90                   	nop
  1024ff:	90                   	nop

00102500 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102500:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102501:	ba 64 00 00 00       	mov    $0x64,%edx
  102506:	89 e5                	mov    %esp,%ebp
  102508:	ec                   	in     (%dx),%al
  102509:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  10250b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102510:	83 e2 01             	and    $0x1,%edx
  102513:	74 3e                	je     102553 <kbd_getc+0x53>
  102515:	ba 60 00 00 00       	mov    $0x60,%edx
  10251a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  10251b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  10251e:	3d e0 00 00 00       	cmp    $0xe0,%eax
  102523:	0f 84 7f 00 00 00    	je     1025a8 <kbd_getc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102529:	84 c0                	test   %al,%al
  10252b:	79 2b                	jns    102558 <kbd_getc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  10252d:	8b 15 5c 85 10 00    	mov    0x10855c,%edx
  102533:	f6 c2 40             	test   $0x40,%dl
  102536:	75 03                	jne    10253b <kbd_getc+0x3b>
  102538:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10253b:	0f b6 80 c0 67 10 00 	movzbl 0x1067c0(%eax),%eax
  102542:	83 c8 40             	or     $0x40,%eax
  102545:	0f b6 c0             	movzbl %al,%eax
  102548:	f7 d0                	not    %eax
  10254a:	21 d0                	and    %edx,%eax
  10254c:	a3 5c 85 10 00       	mov    %eax,0x10855c
  102551:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102553:	5d                   	pop    %ebp
  102554:	c3                   	ret    
  102555:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102558:	8b 0d 5c 85 10 00    	mov    0x10855c,%ecx
  10255e:	f6 c1 40             	test   $0x40,%cl
  102561:	74 05                	je     102568 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102563:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  102565:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102568:	0f b6 90 c0 67 10 00 	movzbl 0x1067c0(%eax),%edx
  10256f:	09 ca                	or     %ecx,%edx
  102571:	0f b6 88 c0 68 10 00 	movzbl 0x1068c0(%eax),%ecx
  102578:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  10257a:	89 d1                	mov    %edx,%ecx
  10257c:	83 e1 03             	and    $0x3,%ecx
  10257f:	8b 0c 8d c0 69 10 00 	mov    0x1069c0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102586:	89 15 5c 85 10 00    	mov    %edx,0x10855c
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  10258c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  10258f:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  102593:	74 be                	je     102553 <kbd_getc+0x53>
    if('a' <= c && c <= 'z')
  102595:	8d 50 9f             	lea    -0x61(%eax),%edx
  102598:	83 fa 19             	cmp    $0x19,%edx
  10259b:	77 1b                	ja     1025b8 <kbd_getc+0xb8>
      c += 'A' - 'a';
  10259d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1025a0:	5d                   	pop    %ebp
  1025a1:	c3                   	ret    
  1025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1025a8:	30 c0                	xor    %al,%al
  1025aa:	83 0d 5c 85 10 00 40 	orl    $0x40,0x10855c
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1025b1:	5d                   	pop    %ebp
  1025b2:	c3                   	ret    
  1025b3:	90                   	nop
  1025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1025b8:	8d 50 bf             	lea    -0x41(%eax),%edx
  1025bb:	83 fa 19             	cmp    $0x19,%edx
  1025be:	77 93                	ja     102553 <kbd_getc+0x53>
      c += 'a' - 'A';
  1025c0:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  1025c3:	5d                   	pop    %ebp
  1025c4:	c3                   	ret    
  1025c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001025d0 <kbd_intr>:

void
kbd_intr(void)
{
  1025d0:	55                   	push   %ebp
  1025d1:	89 e5                	mov    %esp,%ebp
  1025d3:	83 ec 18             	sub    $0x18,%esp
  console_intr(kbd_getc);
  1025d6:	c7 04 24 00 25 10 00 	movl   $0x102500,(%esp)
  1025dd:	e8 0e df ff ff       	call   1004f0 <console_intr>
}
  1025e2:	c9                   	leave  
  1025e3:	c3                   	ret    
  1025e4:	90                   	nop
  1025e5:	90                   	nop
  1025e6:	90                   	nop
  1025e7:	90                   	nop
  1025e8:	90                   	nop
  1025e9:	90                   	nop
  1025ea:	90                   	nop
  1025eb:	90                   	nop
  1025ec:	90                   	nop
  1025ed:	90                   	nop
  1025ee:	90                   	nop
  1025ef:	90                   	nop

001025f0 <lapic_init>:
}

void
lapic_init(int c)
{
  if(!lapic) 
  1025f0:	a1 b8 b7 10 00       	mov    0x10b7b8,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1025f5:	55                   	push   %ebp
  1025f6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1025f8:	85 c0                	test   %eax,%eax
  1025fa:	0f 84 c4 00 00 00    	je     1026c4 <lapic_init+0xd4>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102600:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  102607:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10260a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10260d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102617:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10261a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  102621:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  102624:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102627:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  10262e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  102631:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102634:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  10263b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10263e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102641:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102648:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  10264b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10264e:	8b 50 30             	mov    0x30(%eax),%edx
  102651:	c1 ea 10             	shr    $0x10,%edx
  102654:	80 fa 03             	cmp    $0x3,%dl
  102657:	77 6f                	ja     1026c8 <lapic_init+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102659:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  102660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102663:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102666:	8d 88 00 03 00 00    	lea    0x300(%eax),%ecx
  10266c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102673:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102676:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102679:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102680:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102683:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102686:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  10268d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102690:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102693:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  10269a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10269d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026a0:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1026a7:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  1026aa:	8b 50 20             	mov    0x20(%eax),%edx
  1026ad:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  1026b0:	8b 11                	mov    (%ecx),%edx
  1026b2:	80 e6 10             	and    $0x10,%dh
  1026b5:	75 f9                	jne    1026b0 <lapic_init+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026b7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  1026be:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026c1:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1026c4:	5d                   	pop    %ebp
  1026c5:	c3                   	ret    
  1026c6:	66 90                	xchg   %ax,%ax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026c8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  1026cf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1026d2:	8b 50 20             	mov    0x20(%eax),%edx
  1026d5:	eb 82                	jmp    102659 <lapic_init+0x69>
  1026d7:	89 f6                	mov    %esi,%esi
  1026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001026e0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1026e0:	a1 b8 b7 10 00       	mov    0x10b7b8,%eax
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1026e5:	55                   	push   %ebp
  1026e6:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1026e8:	85 c0                	test   %eax,%eax
  1026ea:	74 0d                	je     1026f9 <lapic_eoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1026f3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026f6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  1026f9:	5d                   	pop    %ebp
  1026fa:	c3                   	ret    
  1026fb:	90                   	nop
  1026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102700 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  102700:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102701:	ba 70 00 00 00       	mov    $0x70,%edx
  102706:	89 e5                	mov    %esp,%ebp
  102708:	b8 0f 00 00 00       	mov    $0xf,%eax
  10270d:	57                   	push   %edi
  10270e:	56                   	push   %esi
  10270f:	53                   	push   %ebx
  102710:	83 ec 18             	sub    $0x18,%esp
  102713:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  102717:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10271a:	ee                   	out    %al,(%dx)
  10271b:	b8 0a 00 00 00       	mov    $0xa,%eax
  102720:	b2 71                	mov    $0x71,%dl
  102722:	ee                   	out    %al,(%dx)
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102723:	8b 15 b8 b7 10 00    	mov    0x10b7b8,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102729:	89 d8                	mov    %ebx,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10272b:	89 cf                	mov    %ecx,%edi
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  10272d:	c1 e8 04             	shr    $0x4,%eax
  102730:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102736:	c1 e7 18             	shl    $0x18,%edi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102739:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102740:	00 00 
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102742:	8d 82 10 03 00 00    	lea    0x310(%edx),%eax
  102748:	89 ba 10 03 00 00    	mov    %edi,0x310(%edx)
  lapic[ID];  // wait for write to finish, by reading
  10274e:	8d 72 20             	lea    0x20(%edx),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102751:	89 45 dc             	mov    %eax,-0x24(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  102754:	8b 42 20             	mov    0x20(%edx),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102757:	8d 82 00 03 00 00    	lea    0x300(%edx),%eax
  10275d:	c7 82 00 03 00 00 00 	movl   $0xc500,0x300(%edx)
  102764:	c5 00 00 
  102767:	89 45 e0             	mov    %eax,-0x20(%ebp)
  lapic[ID];  // wait for write to finish, by reading
  10276a:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  10276d:	b8 c7 00 00 00       	mov    $0xc7,%eax
  102772:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102779:	eb 0c                	jmp    102787 <lapic_startap+0x87>
  10277b:	90                   	nop
  10277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  102780:	85 c0                	test   %eax,%eax
  102782:	74 2d                	je     1027b1 <lapic_startap+0xb1>
  102784:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  102787:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10278e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102791:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  102797:	7f e7                	jg     102780 <lapic_startap+0x80>
  102799:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10279c:	83 c1 01             	add    $0x1,%ecx
  10279f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1027a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1027a5:	81 f9 0f 27 00 00    	cmp    $0x270f,%ecx
  1027ab:	7e ec                	jle    102799 <lapic_startap+0x99>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  1027ad:	85 c0                	test   %eax,%eax
  1027af:	75 d3                	jne    102784 <lapic_startap+0x84>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b1:	c7 82 00 03 00 00 00 	movl   $0x8500,0x300(%edx)
  1027b8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027bb:	8b 42 20             	mov    0x20(%edx),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  1027be:	b8 63 00 00 00       	mov    $0x63,%eax
  1027c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1027ca:	eb 0b                	jmp    1027d7 <lapic_startap+0xd7>
  1027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  while(us-- > 0)
  1027d0:	85 c0                	test   %eax,%eax
  1027d2:	74 2d                	je     102801 <lapic_startap+0x101>
  1027d4:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  1027d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1027de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1027e1:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  1027e7:	7f e7                	jg     1027d0 <lapic_startap+0xd0>
  1027e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1027ec:	83 c2 01             	add    $0x1,%edx
  1027ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1027f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1027f5:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  1027fb:	7e ec                	jle    1027e9 <lapic_startap+0xe9>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  1027fd:	85 c0                	test   %eax,%eax
  1027ff:	75 d3                	jne    1027d4 <lapic_startap+0xd4>
  102801:	c1 eb 0c             	shr    $0xc,%ebx
  102804:	31 c9                	xor    %ecx,%ecx
  102806:	80 cf 06             	or     $0x6,%bh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102809:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10280c:	89 38                	mov    %edi,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  10280e:	8b 06                	mov    (%esi),%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102813:	89 18                	mov    %ebx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102815:	8b 06                	mov    (%esi),%eax
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  volatile int j = 0;
  102817:	b8 c7 00 00 00       	mov    $0xc7,%eax
  10281c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102823:	eb 0a                	jmp    10282f <lapic_startap+0x12f>
  102825:	8d 76 00             	lea    0x0(%esi),%esi
  
  while(us-- > 0)
  102828:	85 c0                	test   %eax,%eax
  10282a:	74 34                	je     102860 <lapic_startap+0x160>
  10282c:	83 e8 01             	sub    $0x1,%eax
    for(j=0; j<10000; j++);
  10282f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102839:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  10283f:	7f e7                	jg     102828 <lapic_startap+0x128>
  102841:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102844:	83 c2 01             	add    $0x1,%edx
  102847:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10284a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10284d:	81 fa 0f 27 00 00    	cmp    $0x270f,%edx
  102853:	7e ec                	jle    102841 <lapic_startap+0x141>
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102855:	85 c0                	test   %eax,%eax
  102857:	75 d3                	jne    10282c <lapic_startap+0x12c>
  102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Send startup IPI (twice!) to enter bootstrap code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
  102860:	83 c1 01             	add    $0x1,%ecx
  102863:	83 f9 02             	cmp    $0x2,%ecx
  102866:	75 a1                	jne    102809 <lapic_startap+0x109>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  102868:	83 c4 18             	add    $0x18,%esp
  10286b:	5b                   	pop    %ebx
  10286c:	5e                   	pop    %esi
  10286d:	5f                   	pop    %edi
  10286e:	5d                   	pop    %ebp
  10286f:	c3                   	ret    

00102870 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102870:	55                   	push   %ebp
  102871:	89 e5                	mov    %esp,%ebp
  102873:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102876:	9c                   	pushf  
  102877:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102878:	f6 c4 02             	test   $0x2,%ah
  10287b:	74 12                	je     10288f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10287d:	a1 60 85 10 00       	mov    0x108560,%eax
  102882:	8d 50 01             	lea    0x1(%eax),%edx
  102885:	85 c0                	test   %eax,%eax
  102887:	89 15 60 85 10 00    	mov    %edx,0x108560
  10288d:	74 19                	je     1028a8 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10288f:	8b 15 b8 b7 10 00    	mov    0x10b7b8,%edx
  102895:	31 c0                	xor    %eax,%eax
  102897:	85 d2                	test   %edx,%edx
  102899:	74 06                	je     1028a1 <cpu+0x31>
    return lapic[ID]>>24;
  10289b:	8b 42 20             	mov    0x20(%edx),%eax
  10289e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1028a1:	c9                   	leave  
  1028a2:	c3                   	ret    
  1028a3:	90                   	nop
  1028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1028a8:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1028aa:	8b 40 04             	mov    0x4(%eax),%eax
  1028ad:	c7 04 24 d0 69 10 00 	movl   $0x1069d0,(%esp)
  1028b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028b8:	e8 83 de ff ff       	call   100740 <cprintf>
  1028bd:	eb d0                	jmp    10288f <cpu+0x1f>
  1028bf:	90                   	nop

001028c0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  1028c0:	55                   	push   %ebp
  1028c1:	89 e5                	mov    %esp,%ebp
  1028c3:	53                   	push   %ebx
  1028c4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  1028c7:	e8 a4 ff ff ff       	call   102870 <cpu>
  1028cc:	c7 04 24 fc 69 10 00 	movl   $0x1069fc,(%esp)
  1028d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028d7:	e8 64 de ff ff       	call   100740 <cprintf>
  idtinit();
  1028dc:	e8 ff 2e 00 00       	call   1057e0 <idtinit>
  if(cpu() != mp_bcpu())
  1028e1:	e8 8a ff ff ff       	call   102870 <cpu>
  1028e6:	89 c3                	mov    %eax,%ebx
  1028e8:	e8 c3 01 00 00       	call   102ab0 <mp_bcpu>
  1028ed:	39 c3                	cmp    %eax,%ebx
  1028ef:	74 0d                	je     1028fe <mpmain+0x3e>
    lapic_init(cpu());
  1028f1:	e8 7a ff ff ff       	call   102870 <cpu>
  1028f6:	89 04 24             	mov    %eax,(%esp)
  1028f9:	e8 f2 fc ff ff       	call   1025f0 <lapic_init>
  setupsegs(0);
  1028fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102905:	e8 c6 10 00 00       	call   1039d0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  10290a:	e8 61 ff ff ff       	call   102870 <cpu>
  10290f:	69 d0 cc 00 00 00    	imul   $0xcc,%eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102915:	b8 01 00 00 00       	mov    $0x1,%eax
  10291a:	81 c2 c0 00 00 00    	add    $0xc0,%edx
  102920:	f0 87 82 e0 b7 10 00 	lock xchg %eax,0x10b7e0(%edx)

  cprintf("cpu%d: scheduling\n", cpu());
  102927:	e8 44 ff ff ff       	call   102870 <cpu>
  10292c:	c7 04 24 0b 6a 10 00 	movl   $0x106a0b,(%esp)
  102933:	89 44 24 04          	mov    %eax,0x4(%esp)
  102937:	e8 04 de ff ff       	call   100740 <cprintf>
  scheduler();
  10293c:	e8 6f 12 00 00       	call   103bb0 <scheduler>
  102941:	eb 0d                	jmp    102950 <main>
  102943:	90                   	nop
  102944:	90                   	nop
  102945:	90                   	nop
  102946:	90                   	nop
  102947:	90                   	nop
  102948:	90                   	nop
  102949:	90                   	nop
  10294a:	90                   	nop
  10294b:	90                   	nop
  10294c:	90                   	nop
  10294d:	90                   	nop
  10294e:	90                   	nop
  10294f:	90                   	nop

00102950 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102950:	55                   	push   %ebp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102951:	b8 e4 ed 10 00       	mov    $0x10ede4,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102956:	89 e5                	mov    %esp,%ebp
  102958:	83 e4 f0             	and    $0xfffffff0,%esp
  10295b:	53                   	push   %ebx
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10295c:	2d ae 84 10 00       	sub    $0x1084ae,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102961:	83 ec 1c             	sub    $0x1c,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102964:	89 44 24 08          	mov    %eax,0x8(%esp)
  102968:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10296f:	00 
  102970:	c7 04 24 ae 84 10 00 	movl   $0x1084ae,(%esp)
  102977:	e8 34 1b 00 00       	call   1044b0 <memset>

  mp_init(); // collect info about this machine
  10297c:	e8 bf 01 00 00       	call   102b40 <mp_init>
  lapic_init(mp_bcpu());
  102981:	e8 2a 01 00 00       	call   102ab0 <mp_bcpu>
  102986:	89 04 24             	mov    %eax,(%esp)
  102989:	e8 62 fc ff ff       	call   1025f0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  10298e:	e8 dd fe ff ff       	call   102870 <cpu>
  102993:	c7 04 24 1e 6a 10 00 	movl   $0x106a1e,(%esp)
  10299a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10299e:	e8 9d dd ff ff       	call   100740 <cprintf>

  pinit();         // process table
  1029a3:	e8 b8 18 00 00       	call   104260 <pinit>
  binit();         // buffer cache
  1029a8:	e8 e3 d7 ff ff       	call   100190 <binit>
  1029ad:	8d 76 00             	lea    0x0(%esi),%esi
  pic_init();      // interrupt controller
  1029b0:	e8 8b 03 00 00       	call   102d40 <pic_init>
  ioapic_init();   // another interrupt controller
  1029b5:	e8 76 f8 ff ff       	call   102230 <ioapic_init>
  kinit();         // physical memory allocator
  1029ba:	e8 f1 fa ff ff       	call   1024b0 <kinit>
  1029bf:	90                   	nop
  tvinit();        // trap vectors
  1029c0:	e8 cb 30 00 00       	call   105a90 <tvinit>
  fileinit();      // file table
  1029c5:	e8 06 e7 ff ff       	call   1010d0 <fileinit>
  iinit();         // inode cache
  1029ca:	e8 61 f5 ff ff       	call   101f30 <iinit>
  1029cf:	90                   	nop
  console_init();  // I/O devices & their interrupts
  1029d0:	e8 2b d8 ff ff       	call   100200 <console_init>
  ide_init();      // disk
  1029d5:	e8 86 f7 ff ff       	call   102160 <ide_init>
  if(!ismp)
  1029da:	a1 c0 b7 10 00       	mov    0x10b7c0,%eax
  1029df:	85 c0                	test   %eax,%eax
  1029e1:	0f 84 b1 00 00 00    	je     102a98 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  1029e7:	e8 84 17 00 00       	call   104170 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  1029ec:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  1029f3:	00 
  1029f4:	c7 44 24 04 54 84 10 	movl   $0x108454,0x4(%esp)
  1029fb:	00 
  1029fc:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102a03:	e8 38 1b 00 00       	call   104540 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102a08:	69 05 40 be 10 00 cc 	imul   $0xcc,0x10be40,%eax
  102a0f:	00 00 00 
  102a12:	05 e0 b7 10 00       	add    $0x10b7e0,%eax
  102a17:	3d e0 b7 10 00       	cmp    $0x10b7e0,%eax
  102a1c:	76 75                	jbe    102a93 <main+0x143>
  102a1e:	bb e0 b7 10 00       	mov    $0x10b7e0,%ebx
  102a23:	90                   	nop
  102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102a28:	e8 43 fe ff ff       	call   102870 <cpu>
  102a2d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102a33:	05 e0 b7 10 00       	add    $0x10b7e0,%eax
  102a38:	39 c3                	cmp    %eax,%ebx
  102a3a:	74 3e                	je     102a7a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102a3c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102a43:	e8 98 f8 ff ff       	call   1022e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102a48:	c7 05 f8 6f 00 00 c0 	movl   $0x1028c0,0x6ff8
  102a4f:	28 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102a52:	05 00 10 00 00       	add    $0x1000,%eax
  102a57:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102a5c:	0f b6 03             	movzbl (%ebx),%eax
  102a5f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102a66:	00 
  102a67:	89 04 24             	mov    %eax,(%esp)
  102a6a:	e8 91 fc ff ff       	call   102700 <lapic_startap>
  102a6f:	90                   	nop

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102a70:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102a76:	85 c0                	test   %eax,%eax
  102a78:	74 f6                	je     102a70 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102a7a:	69 05 40 be 10 00 cc 	imul   $0xcc,0x10be40,%eax
  102a81:	00 00 00 
  102a84:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102a8a:	05 e0 b7 10 00       	add    $0x10b7e0,%eax
  102a8f:	39 c3                	cmp    %eax,%ebx
  102a91:	72 95                	jb     102a28 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102a93:	e8 28 fe ff ff       	call   1028c0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102a98:	e8 e3 2c 00 00       	call   105780 <timer_init>
  102a9d:	8d 76 00             	lea    0x0(%esi),%esi
  102aa0:	e9 42 ff ff ff       	jmp    1029e7 <main+0x97>
  102aa5:	90                   	nop
  102aa6:	90                   	nop
  102aa7:	90                   	nop
  102aa8:	90                   	nop
  102aa9:	90                   	nop
  102aaa:	90                   	nop
  102aab:	90                   	nop
  102aac:	90                   	nop
  102aad:	90                   	nop
  102aae:	90                   	nop
  102aaf:	90                   	nop

00102ab0 <mp_bcpu>:
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102ab0:	a1 64 85 10 00       	mov    0x108564,%eax
  102ab5:	55                   	push   %ebp
  102ab6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102ab8:	5d                   	pop    %ebp
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102ab9:	2d e0 b7 10 00       	sub    $0x10b7e0,%eax
  102abe:	c1 f8 02             	sar    $0x2,%eax
  102ac1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  return bcpu-cpus;
}
  102ac7:	c3                   	ret    
  102ac8:	90                   	nop
  102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102ad0 <mp_search1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	56                   	push   %esi
  102ad4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102ad5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102ad8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102adb:	39 f0                	cmp    %esi,%eax
  102add:	73 42                	jae    102b21 <mp_search1+0x51>
  102adf:	89 c3                	mov    %eax,%ebx
  102ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102ae8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102aef:	00 
  102af0:	c7 44 24 04 35 6a 10 	movl   $0x106a35,0x4(%esp)
  102af7:	00 
  102af8:	89 1c 24             	mov    %ebx,(%esp)
  102afb:	e8 e0 19 00 00       	call   1044e0 <memcmp>
  102b00:	85 c0                	test   %eax,%eax
  102b02:	75 16                	jne    102b1a <mp_search1+0x4a>
  102b04:	31 d2                	xor    %edx,%edx
  102b06:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102b08:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b0c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102b0f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b11:	83 f8 10             	cmp    $0x10,%eax
  102b14:	75 f2                	jne    102b08 <mp_search1+0x38>
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b16:	84 d2                	test   %dl,%dl
  102b18:	74 10                	je     102b2a <mp_search1+0x5a>
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b1a:	83 c3 10             	add    $0x10,%ebx
  102b1d:	39 de                	cmp    %ebx,%esi
  102b1f:	77 c7                	ja     102ae8 <mp_search1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102b21:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b24:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102b26:	5b                   	pop    %ebx
  102b27:	5e                   	pop    %esi
  102b28:	5d                   	pop    %ebp
  102b29:	c3                   	ret    
  102b2a:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102b2d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102b2f:	5b                   	pop    %ebx
  102b30:	5e                   	pop    %esi
  102b31:	5d                   	pop    %ebp
  102b32:	c3                   	ret    
  102b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102b40 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102b40:	55                   	push   %ebp
  102b41:	89 e5                	mov    %esp,%ebp
  102b43:	57                   	push   %edi
  102b44:	56                   	push   %esi
  102b45:	53                   	push   %ebx
  102b46:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b49:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102b50:	69 05 40 be 10 00 cc 	imul   $0xcc,0x10be40,%eax
  102b57:	00 00 00 
  102b5a:	05 e0 b7 10 00       	add    $0x10b7e0,%eax
  102b5f:	a3 64 85 10 00       	mov    %eax,0x108564
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b64:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102b6b:	c1 e0 08             	shl    $0x8,%eax
  102b6e:	09 d0                	or     %edx,%eax
  102b70:	c1 e0 04             	shl    $0x4,%eax
  102b73:	85 c0                	test   %eax,%eax
  102b75:	75 1b                	jne    102b92 <mp_init+0x52>
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102b77:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102b7e:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102b85:	c1 e0 08             	shl    $0x8,%eax
  102b88:	09 d0                	or     %edx,%eax
  102b8a:	c1 e0 0a             	shl    $0xa,%eax
  102b8d:	2d 00 04 00 00       	sub    $0x400,%eax
  102b92:	ba 00 04 00 00       	mov    $0x400,%edx
  102b97:	e8 34 ff ff ff       	call   102ad0 <mp_search1>
  102b9c:	85 c0                	test   %eax,%eax
  102b9e:	89 c3                	mov    %eax,%ebx
  102ba0:	0f 84 b2 00 00 00    	je     102c58 <mp_init+0x118>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102ba6:	8b 73 04             	mov    0x4(%ebx),%esi
  102ba9:	85 f6                	test   %esi,%esi
  102bab:	75 0b                	jne    102bb8 <mp_init+0x78>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102bad:	83 c4 2c             	add    $0x2c,%esp
  102bb0:	5b                   	pop    %ebx
  102bb1:	5e                   	pop    %esi
  102bb2:	5f                   	pop    %edi
  102bb3:	5d                   	pop    %ebp
  102bb4:	c3                   	ret    
  102bb5:	8d 76 00             	lea    0x0(%esi),%esi
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102bb8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102bbf:	00 
  102bc0:	c7 44 24 04 3a 6a 10 	movl   $0x106a3a,0x4(%esp)
  102bc7:	00 
  102bc8:	89 34 24             	mov    %esi,(%esp)
  102bcb:	e8 10 19 00 00       	call   1044e0 <memcmp>
  102bd0:	85 c0                	test   %eax,%eax
  102bd2:	75 d9                	jne    102bad <mp_init+0x6d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102bd4:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  102bd8:	3c 04                	cmp    $0x4,%al
  102bda:	74 06                	je     102be2 <mp_init+0xa2>
  102bdc:	3c 01                	cmp    $0x1,%al
  102bde:	66 90                	xchg   %ax,%ax
  102be0:	75 cb                	jne    102bad <mp_init+0x6d>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102be2:	0f b7 56 04          	movzwl 0x4(%esi),%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102be6:	85 d2                	test   %edx,%edx
  102be8:	74 15                	je     102bff <mp_init+0xbf>
  102bea:	31 c9                	xor    %ecx,%ecx
  102bec:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  102bee:	0f b6 3c 06          	movzbl (%esi,%eax,1),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bf2:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102bf5:	01 f9                	add    %edi,%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bf7:	39 c2                	cmp    %eax,%edx
  102bf9:	7f f3                	jg     102bee <mp_init+0xae>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102bfb:	84 c9                	test   %cl,%cl
  102bfd:	75 ae                	jne    102bad <mp_init+0x6d>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102bff:	8b 46 24             	mov    0x24(%esi),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c02:	8d 14 16             	lea    (%esi,%edx,1),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102c05:	c7 05 c0 b7 10 00 01 	movl   $0x1,0x10b7c0
  102c0c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c0f:	a3 b8 b7 10 00       	mov    %eax,0x10b7b8

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c14:	8d 46 2c             	lea    0x2c(%esi),%eax
  102c17:	39 d0                	cmp    %edx,%eax
  102c19:	0f 83 81 00 00 00    	jae    102ca0 <mp_init+0x160>
  102c1f:	8b 35 64 85 10 00    	mov    0x108564,%esi
  102c25:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    switch(*p){
  102c28:	0f b6 08             	movzbl (%eax),%ecx
  102c2b:	80 f9 04             	cmp    $0x4,%cl
  102c2e:	76 50                	jbe    102c80 <mp_init+0x140>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102c30:	0f b6 c9             	movzbl %cl,%ecx
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c33:	89 35 64 85 10 00    	mov    %esi,0x108564
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102c39:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102c3d:	c7 04 24 48 6a 10 00 	movl   $0x106a48,(%esp)
  102c44:	e8 f7 da ff ff       	call   100740 <cprintf>
      panic("mp_init");
  102c49:	c7 04 24 3f 6a 10 00 	movl   $0x106a3f,(%esp)
  102c50:	e8 8b dc ff ff       	call   1008e0 <panic>
  102c55:	8d 76 00             	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102c58:	ba 00 00 01 00       	mov    $0x10000,%edx
  102c5d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102c62:	e8 69 fe ff ff       	call   102ad0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102c67:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102c69:	89 c3                	mov    %eax,%ebx
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102c6b:	0f 85 35 ff ff ff    	jne    102ba6 <mp_init+0x66>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102c71:	83 c4 2c             	add    $0x2c,%esp
  102c74:	5b                   	pop    %ebx
  102c75:	5e                   	pop    %esi
  102c76:	5f                   	pop    %edi
  102c77:	5d                   	pop    %ebp
  102c78:	c3                   	ret    
  102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102c80:	0f b6 c9             	movzbl %cl,%ecx
  102c83:	ff 24 8d 6c 6a 10 00 	jmp    *0x106a6c(,%ecx,4)
  102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102c90:	83 c0 08             	add    $0x8,%eax
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c93:	39 c2                	cmp    %eax,%edx
  102c95:	77 91                	ja     102c28 <mp_init+0xe8>
  102c97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  102c9a:	89 35 64 85 10 00    	mov    %esi,0x108564
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102ca0:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  102ca4:	0f 84 03 ff ff ff    	je     102bad <mp_init+0x6d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102caa:	ba 22 00 00 00       	mov    $0x22,%edx
  102caf:	b8 70 00 00 00       	mov    $0x70,%eax
  102cb4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102cb5:	b2 23                	mov    $0x23,%dl
  102cb7:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102cb8:	83 c8 01             	or     $0x1,%eax
  102cbb:	ee                   	out    %al,(%dx)
  102cbc:	e9 ec fe ff ff       	jmp    102bad <mp_init+0x6d>
  102cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102cc8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  102ccc:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102ccf:	88 0d c4 b7 10 00    	mov    %cl,0x10b7c4
      p += sizeof(struct mpioapic);
      continue;
  102cd5:	eb bc                	jmp    102c93 <mp_init+0x153>
  102cd7:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102cd8:	8b 0d 40 be 10 00    	mov    0x10be40,%ecx
  102cde:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102ce2:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  102ce8:	88 9f e0 b7 10 00    	mov    %bl,0x10b7e0(%edi)
      if(proc->flags & MPBOOT)
  102cee:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102cf2:	74 06                	je     102cfa <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  102cf4:	8d b7 e0 b7 10 00    	lea    0x10b7e0(%edi),%esi
      ncpu++;
  102cfa:	83 c1 01             	add    $0x1,%ecx
      p += sizeof(struct mpproc);
  102cfd:	83 c0 14             	add    $0x14,%eax
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102d00:	89 0d 40 be 10 00    	mov    %ecx,0x10be40
      p += sizeof(struct mpproc);
      continue;
  102d06:	eb 8b                	jmp    102c93 <mp_init+0x153>
  102d08:	90                   	nop
  102d09:	90                   	nop
  102d0a:	90                   	nop
  102d0b:	90                   	nop
  102d0c:	90                   	nop
  102d0d:	90                   	nop
  102d0e:	90                   	nop
  102d0f:	90                   	nop

00102d10 <pic_enable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102d10:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102d11:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102d16:	89 e5                	mov    %esp,%ebp
  102d18:	ba 21 00 00 00       	mov    $0x21,%edx
  pic_setmask(irqmask & ~(1<<irq));
  102d1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102d20:	d3 c0                	rol    %cl,%eax
  102d22:	66 23 05 20 80 10 00 	and    0x108020,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  102d29:	66 a3 20 80 10 00    	mov    %ax,0x108020
  102d2f:	ee                   	out    %al,(%dx)
  102d30:	66 c1 e8 08          	shr    $0x8,%ax
  102d34:	b2 a1                	mov    $0xa1,%dl
  102d36:	ee                   	out    %al,(%dx)

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
}
  102d37:	5d                   	pop    %ebp
  102d38:	c3                   	ret    
  102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102d40 <pic_init>:

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102d40:	55                   	push   %ebp
  102d41:	b9 21 00 00 00       	mov    $0x21,%ecx
  102d46:	89 e5                	mov    %esp,%ebp
  102d48:	83 ec 0c             	sub    $0xc,%esp
  102d4b:	89 1c 24             	mov    %ebx,(%esp)
  102d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102d53:	89 ca                	mov    %ecx,%edx
  102d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  102d59:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102d5d:	ee                   	out    %al,(%dx)
  102d5e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102d63:	89 da                	mov    %ebx,%edx
  102d65:	ee                   	out    %al,(%dx)
  102d66:	be 11 00 00 00       	mov    $0x11,%esi
  102d6b:	b2 20                	mov    $0x20,%dl
  102d6d:	89 f0                	mov    %esi,%eax
  102d6f:	ee                   	out    %al,(%dx)
  102d70:	b8 20 00 00 00       	mov    $0x20,%eax
  102d75:	89 ca                	mov    %ecx,%edx
  102d77:	ee                   	out    %al,(%dx)
  102d78:	b8 04 00 00 00       	mov    $0x4,%eax
  102d7d:	ee                   	out    %al,(%dx)
  102d7e:	bf 03 00 00 00       	mov    $0x3,%edi
  102d83:	89 f8                	mov    %edi,%eax
  102d85:	ee                   	out    %al,(%dx)
  102d86:	b1 a0                	mov    $0xa0,%cl
  102d88:	89 f0                	mov    %esi,%eax
  102d8a:	89 ca                	mov    %ecx,%edx
  102d8c:	ee                   	out    %al,(%dx)
  102d8d:	b8 28 00 00 00       	mov    $0x28,%eax
  102d92:	89 da                	mov    %ebx,%edx
  102d94:	ee                   	out    %al,(%dx)
  102d95:	b8 02 00 00 00       	mov    $0x2,%eax
  102d9a:	ee                   	out    %al,(%dx)
  102d9b:	89 f8                	mov    %edi,%eax
  102d9d:	ee                   	out    %al,(%dx)
  102d9e:	be 68 00 00 00       	mov    $0x68,%esi
  102da3:	b2 20                	mov    $0x20,%dl
  102da5:	89 f0                	mov    %esi,%eax
  102da7:	ee                   	out    %al,(%dx)
  102da8:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102dad:	89 d8                	mov    %ebx,%eax
  102daf:	ee                   	out    %al,(%dx)
  102db0:	89 f0                	mov    %esi,%eax
  102db2:	89 ca                	mov    %ecx,%edx
  102db4:	ee                   	out    %al,(%dx)
  102db5:	89 d8                	mov    %ebx,%eax
  102db7:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102db8:	0f b7 05 20 80 10 00 	movzwl 0x108020,%eax
  102dbf:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102dc3:	74 0a                	je     102dcf <pic_init+0x8f>
  102dc5:	b2 21                	mov    $0x21,%dl
  102dc7:	ee                   	out    %al,(%dx)
  102dc8:	66 c1 e8 08          	shr    $0x8,%ax
  102dcc:	b2 a1                	mov    $0xa1,%dl
  102dce:	ee                   	out    %al,(%dx)
    pic_setmask(irqmask);
}
  102dcf:	8b 1c 24             	mov    (%esp),%ebx
  102dd2:	8b 74 24 04          	mov    0x4(%esp),%esi
  102dd6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102dda:	89 ec                	mov    %ebp,%esp
  102ddc:	5d                   	pop    %ebp
  102ddd:	c3                   	ret    
  102dde:	90                   	nop
  102ddf:	90                   	nop

00102de0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102de0:	55                   	push   %ebp
  102de1:	89 e5                	mov    %esp,%ebp
  102de3:	57                   	push   %edi
  102de4:	56                   	push   %esi
  102de5:	53                   	push   %ebx
  102de6:	83 ec 2c             	sub    $0x2c,%esp
  102de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102dec:	8d 73 10             	lea    0x10(%ebx),%esi
  102def:	89 34 24             	mov    %esi,(%esp)
  102df2:	e8 49 16 00 00       	call   104440 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102df7:	8b 53 0c             	mov    0xc(%ebx),%edx
  102dfa:	3b 53 08             	cmp    0x8(%ebx),%edx
  102dfd:	75 51                	jne    102e50 <piperead+0x70>
  102dff:	8b 4b 04             	mov    0x4(%ebx),%ecx
  102e02:	85 c9                	test   %ecx,%ecx
  102e04:	74 4a                	je     102e50 <piperead+0x70>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102e06:	8d 7b 0c             	lea    0xc(%ebx),%edi
  102e09:	eb 20                	jmp    102e2b <piperead+0x4b>
  102e0b:	90                   	nop
  102e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102e10:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e14:	89 3c 24             	mov    %edi,(%esp)
  102e17:	e8 94 08 00 00       	call   1036b0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102e1c:	8b 53 0c             	mov    0xc(%ebx),%edx
  102e1f:	3b 53 08             	cmp    0x8(%ebx),%edx
  102e22:	75 2c                	jne    102e50 <piperead+0x70>
  102e24:	8b 43 04             	mov    0x4(%ebx),%eax
  102e27:	85 c0                	test   %eax,%eax
  102e29:	74 25                	je     102e50 <piperead+0x70>
    if(cp->killed){
  102e2b:	e8 d0 05 00 00       	call   103400 <curproc>
  102e30:	8b 40 1c             	mov    0x1c(%eax),%eax
  102e33:	85 c0                	test   %eax,%eax
  102e35:	74 d9                	je     102e10 <piperead+0x30>
      release(&p->lock);
  102e37:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  102e3c:	89 34 24             	mov    %esi,(%esp)
  102e3f:	e8 bc 15 00 00       	call   104400 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102e44:	83 c4 2c             	add    $0x2c,%esp
  102e47:	89 f8                	mov    %edi,%eax
  102e49:	5b                   	pop    %ebx
  102e4a:	5e                   	pop    %esi
  102e4b:	5f                   	pop    %edi
  102e4c:	5d                   	pop    %ebp
  102e4d:	c3                   	ret    
  102e4e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102e50:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102e53:	85 c9                	test   %ecx,%ecx
  102e55:	7e 5a                	jle    102eb1 <piperead+0xd1>
    if(p->readp == p->writep)
  102e57:	31 ff                	xor    %edi,%edi
  102e59:	3b 53 08             	cmp    0x8(%ebx),%edx
  102e5c:	74 53                	je     102eb1 <piperead+0xd1>
  102e5e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  102e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102e64:	8b 75 10             	mov    0x10(%ebp),%esi
  102e67:	eb 0c                	jmp    102e75 <piperead+0x95>
  102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102e70:	39 53 08             	cmp    %edx,0x8(%ebx)
  102e73:	74 1c                	je     102e91 <piperead+0xb1>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102e75:	89 d0                	mov    %edx,%eax
  102e77:	83 c2 01             	add    $0x1,%edx
  102e7a:	25 ff 01 00 00       	and    $0x1ff,%eax
  102e7f:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102e84:	88 04 39             	mov    %al,(%ecx,%edi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102e87:	83 c7 01             	add    $0x1,%edi
  102e8a:	39 fe                	cmp    %edi,%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102e8c:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102e8f:	7f df                	jg     102e70 <piperead+0x90>
  102e91:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102e94:	83 c3 08             	add    $0x8,%ebx
  102e97:	89 1c 24             	mov    %ebx,(%esp)
  102e9a:	e8 61 04 00 00       	call   103300 <wakeup>
  release(&p->lock);
  102e9f:	89 34 24             	mov    %esi,(%esp)
  102ea2:	e8 59 15 00 00       	call   104400 <release>
  return i;
}
  102ea7:	83 c4 2c             	add    $0x2c,%esp
  102eaa:	89 f8                	mov    %edi,%eax
  102eac:	5b                   	pop    %ebx
  102ead:	5e                   	pop    %esi
  102eae:	5f                   	pop    %edi
  102eaf:	5d                   	pop    %ebp
  102eb0:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102eb1:	31 ff                	xor    %edi,%edi
  102eb3:	eb df                	jmp    102e94 <piperead+0xb4>
  102eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ec0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102ec0:	55                   	push   %ebp
  102ec1:	89 e5                	mov    %esp,%ebp
  102ec3:	57                   	push   %edi
  102ec4:	56                   	push   %esi
  102ec5:	53                   	push   %ebx
  102ec6:	83 ec 3c             	sub    $0x3c,%esp
  102ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102ecc:	8d 73 10             	lea    0x10(%ebx),%esi
  102ecf:	89 34 24             	mov    %esi,(%esp)
  102ed2:	e8 69 15 00 00       	call   104440 <acquire>
  for(i = 0; i < n; i++){
  102ed7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102eda:	85 c9                	test   %ecx,%ecx
  102edc:	0f 8e d0 00 00 00    	jle    102fb2 <pipewrite+0xf2>
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  102ee2:	8d 53 08             	lea    0x8(%ebx),%edx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102ee5:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
  102ee8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102eeb:	8b 53 0c             	mov    0xc(%ebx),%edx
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102eee:	8d 7b 0c             	lea    0xc(%ebx),%edi
      sleep(&p->writep, &p->lock);
  102ef1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102ef8:	89 7d d0             	mov    %edi,-0x30(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  102efb:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  102f01:	39 c8                	cmp    %ecx,%eax
  102f03:	75 66                	jne    102f6b <pipewrite+0xab>
      if(p->readopen == 0 || cp->killed){
  102f05:	8b 3b                	mov    (%ebx),%edi
  102f07:	85 ff                	test   %edi,%edi
  102f09:	74 3e                	je     102f49 <pipewrite+0x89>
  102f0b:	8b 7d d0             	mov    -0x30(%ebp),%edi
  102f0e:	eb 2d                	jmp    102f3d <pipewrite+0x7d>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102f10:	89 3c 24             	mov    %edi,(%esp)
  102f13:	e8 e8 03 00 00       	call   103300 <wakeup>
      sleep(&p->writep, &p->lock);
  102f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  102f1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f1f:	89 0c 24             	mov    %ecx,(%esp)
  102f22:	e8 89 07 00 00       	call   1036b0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  102f27:	8b 53 0c             	mov    0xc(%ebx),%edx
  102f2a:	8b 43 08             	mov    0x8(%ebx),%eax
  102f2d:	8d 8a 00 02 00 00    	lea    0x200(%edx),%ecx
  102f33:	39 c8                	cmp    %ecx,%eax
  102f35:	75 31                	jne    102f68 <pipewrite+0xa8>
      if(p->readopen == 0 || cp->killed){
  102f37:	8b 13                	mov    (%ebx),%edx
  102f39:	85 d2                	test   %edx,%edx
  102f3b:	74 0c                	je     102f49 <pipewrite+0x89>
  102f3d:	e8 be 04 00 00       	call   103400 <curproc>
  102f42:	8b 40 1c             	mov    0x1c(%eax),%eax
  102f45:	85 c0                	test   %eax,%eax
  102f47:	74 c7                	je     102f10 <pipewrite+0x50>
        release(&p->lock);
  102f49:	89 34 24             	mov    %esi,(%esp)
  102f4c:	e8 af 14 00 00       	call   104400 <release>
  102f51:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  102f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f5b:	83 c4 3c             	add    $0x3c,%esp
  102f5e:	5b                   	pop    %ebx
  102f5f:	5e                   	pop    %esi
  102f60:	5f                   	pop    %edi
  102f61:	5d                   	pop    %ebp
  102f62:	c3                   	ret    
  102f63:	90                   	nop
  102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102f68:	89 7d d0             	mov    %edi,-0x30(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102f6b:	89 c7                	mov    %eax,%edi
  102f6d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  102f70:	83 c0 01             	add    $0x1,%eax
  102f73:	81 e7 ff 01 00 00    	and    $0x1ff,%edi
  102f79:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  102f7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  102f7f:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
  102f83:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  102f86:	89 43 08             	mov    %eax,0x8(%ebx)
  102f89:	88 4c 3b 44          	mov    %cl,0x44(%ebx,%edi,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f8d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  102f91:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  102f94:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  102f97:	0f 8f 5e ff ff ff    	jg     102efb <pipewrite+0x3b>
  102f9d:	8b 7d d0             	mov    -0x30(%ebp),%edi
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  102fa0:	89 3c 24             	mov    %edi,(%esp)
  102fa3:	e8 58 03 00 00       	call   103300 <wakeup>
  release(&p->lock);
  102fa8:	89 34 24             	mov    %esi,(%esp)
  102fab:	e8 50 14 00 00       	call   104400 <release>
  return i;
  102fb0:	eb a6                	jmp    102f58 <pipewrite+0x98>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102fb2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102fb9:	8d 7b 0c             	lea    0xc(%ebx),%edi
  102fbc:	eb e2                	jmp    102fa0 <pipewrite+0xe0>
  102fbe:	66 90                	xchg   %ax,%ax

00102fc0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102fc0:	55                   	push   %ebp
  102fc1:	89 e5                	mov    %esp,%ebp
  102fc3:	83 ec 28             	sub    $0x28,%esp
  102fc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  102fcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  102fcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  102fd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  acquire(&p->lock);
  102fd5:	8d 73 10             	lea    0x10(%ebx),%esi
  102fd8:	89 34 24             	mov    %esi,(%esp)
  102fdb:	e8 60 14 00 00       	call   104440 <acquire>
  if(writable){
  102fe0:	85 ff                	test   %edi,%edi
  102fe2:	74 34                	je     103018 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  102fe4:	8d 43 0c             	lea    0xc(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102fe7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    wakeup(&p->readp);
  102fee:	89 04 24             	mov    %eax,(%esp)
  102ff1:	e8 0a 03 00 00       	call   103300 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  102ff6:	89 34 24             	mov    %esi,(%esp)
  102ff9:	e8 02 14 00 00       	call   104400 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  102ffe:	8b 3b                	mov    (%ebx),%edi
  103000:	85 ff                	test   %edi,%edi
  103002:	75 07                	jne    10300b <pipeclose+0x4b>
  103004:	8b 73 04             	mov    0x4(%ebx),%esi
  103007:	85 f6                	test   %esi,%esi
  103009:	74 25                	je     103030 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  10300b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10300e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103011:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103014:	89 ec                	mov    %ebp,%esp
  103016:	5d                   	pop    %ebp
  103017:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  103018:	8d 43 08             	lea    0x8(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  10301b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    wakeup(&p->writep);
  103021:	89 04 24             	mov    %eax,(%esp)
  103024:	e8 d7 02 00 00       	call   103300 <wakeup>
  103029:	eb cb                	jmp    102ff6 <pipeclose+0x36>
  10302b:	90                   	nop
  10302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103030:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  103033:	8b 75 f8             	mov    -0x8(%ebp),%esi
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103036:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10303d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103040:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103043:	89 ec                	mov    %ebp,%esp
  103045:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103046:	e9 55 f3 ff ff       	jmp    1023a0 <kfree>
  10304b:	90                   	nop
  10304c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103050 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	57                   	push   %edi
  103054:	56                   	push   %esi
  103055:	53                   	push   %ebx
  103056:	83 ec 1c             	sub    $0x1c,%esp
  103059:	8b 75 08             	mov    0x8(%ebp),%esi
  10305c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  10305f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  103065:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  10306b:	e8 f0 de ff ff       	call   100f60 <filealloc>
  103070:	85 c0                	test   %eax,%eax
  103072:	89 06                	mov    %eax,(%esi)
  103074:	0f 84 92 00 00 00    	je     10310c <pipealloc+0xbc>
  10307a:	e8 e1 de ff ff       	call   100f60 <filealloc>
  10307f:	85 c0                	test   %eax,%eax
  103081:	89 03                	mov    %eax,(%ebx)
  103083:	74 73                	je     1030f8 <pipealloc+0xa8>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  103085:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  10308c:	e8 4f f2 ff ff       	call   1022e0 <kalloc>
  103091:	85 c0                	test   %eax,%eax
  103093:	89 c7                	mov    %eax,%edi
  103095:	74 61                	je     1030f8 <pipealloc+0xa8>
    goto bad;
  p->readopen = 1;
  103097:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  10309d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  1030a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  1030ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  1030b2:	8d 40 10             	lea    0x10(%eax),%eax
  1030b5:	89 04 24             	mov    %eax,(%esp)
  1030b8:	c7 44 24 04 80 6a 10 	movl   $0x106a80,0x4(%esp)
  1030bf:	00 
  1030c0:	e8 bb 11 00 00       	call   104280 <initlock>
  (*f0)->type = FD_PIPE;
  1030c5:	8b 06                	mov    (%esi),%eax
  1030c7:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  1030cd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  1030d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1030d5:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1030d8:	8b 03                	mov    (%ebx),%eax
  1030da:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  1030e0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  1030e4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1030e8:	89 78 0c             	mov    %edi,0xc(%eax)
  1030eb:	31 c0                	xor    %eax,%eax
  if(*f1){
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  1030ed:	83 c4 1c             	add    $0x1c,%esp
  1030f0:	5b                   	pop    %ebx
  1030f1:	5e                   	pop    %esi
  1030f2:	5f                   	pop    %edi
  1030f3:	5d                   	pop    %ebp
  1030f4:	c3                   	ret    
  1030f5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1030f8:	8b 06                	mov    (%esi),%eax
  1030fa:	85 c0                	test   %eax,%eax
  1030fc:	74 0e                	je     10310c <pipealloc+0xbc>
    (*f0)->type = FD_NONE;
  1030fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  103104:	89 04 24             	mov    %eax,(%esp)
  103107:	e8 e4 de ff ff       	call   100ff0 <fileclose>
  }
  if(*f1){
  10310c:	8b 13                	mov    (%ebx),%edx
  10310e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103113:	85 d2                	test   %edx,%edx
  103115:	74 d6                	je     1030ed <pipealloc+0x9d>
    (*f1)->type = FD_NONE;
  103117:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    fileclose(*f1);
  10311d:	89 14 24             	mov    %edx,(%esp)
  103120:	e8 cb de ff ff       	call   100ff0 <fileclose>
  103125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10312a:	eb c1                	jmp    1030ed <pipealloc+0x9d>
  10312c:	90                   	nop
  10312d:	90                   	nop
  10312e:	90                   	nop
  10312f:	90                   	nop

00103130 <wake_lock>:
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103130:	55                   	push   %ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103131:	b8 60 e5 10 00       	mov    $0x10e560,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  103136:	89 e5                	mov    %esp,%ebp
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103138:	3d 60 be 10 00       	cmp    $0x10be60,%eax
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
{
  10313d:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103140:	76 3e                	jbe    103180 <wake_lock+0x50>
	sched();
	release(&proc_table_lock); 
}

//Wake up given process
void wake_lock(int pid)
  103142:	b8 60 be 10 00       	mov    $0x10be60,%eax
  103147:	eb 13                	jmp    10315c <wake_lock+0x2c>
  103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103150:	05 9c 00 00 00       	add    $0x9c,%eax
  103155:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  10315a:	74 24                	je     103180 <wake_lock+0x50>
	{
		if(p->state == SLEEPING && p->pid == pid)
  10315c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103160:	75 ee                	jne    103150 <wake_lock+0x20>
  103162:	39 50 10             	cmp    %edx,0x10(%eax)
  103165:	75 e9                	jne    103150 <wake_lock+0x20>
			p->state = RUNNABLE;
  103167:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
//Wake up given process
void wake_lock(int pid)
{
	struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10316e:	05 9c 00 00 00       	add    $0x9c,%eax
  103173:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  103178:	75 e2                	jne    10315c <wake_lock+0x2c>
  10317a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
		if(p->state == SLEEPING && p->pid == pid)
			p->state = RUNNABLE;
	}
}
  103180:	5d                   	pop    %ebp
  103181:	c3                   	ret    
  103182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103190 <tick>:
  }
}

int
tick(void)
{
  103190:	55                   	push   %ebp
return ticks;
}
  103191:	a1 e0 ed 10 00       	mov    0x10ede0,%eax
  }
}

int
tick(void)
{
  103196:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103198:	5d                   	pop    %ebp
  103199:	c3                   	ret    
  10319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001031a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1031a0:	55                   	push   %ebp
  1031a1:	89 e5                	mov    %esp,%ebp
  1031a3:	57                   	push   %edi
  1031a4:	56                   	push   %esi
  1031a5:	53                   	push   %ebx
  1031a6:	bb 6c be 10 00       	mov    $0x10be6c,%ebx
  1031ab:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1031ae:	8d 7d c0             	lea    -0x40(%ebp),%edi
  1031b1:	eb 50                	jmp    103203 <procdump+0x63>
  1031b3:	90                   	nop
  1031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1031b8:	8b 04 85 48 6b 10 00 	mov    0x106b48(,%eax,4),%eax
  1031bf:	85 c0                	test   %eax,%eax
  1031c1:	74 4e                	je     103211 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  1031c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031c7:	8b 43 04             	mov    0x4(%ebx),%eax
  1031ca:	81 c2 88 00 00 00    	add    $0x88,%edx
  1031d0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031d4:	c7 04 24 89 6a 10 00 	movl   $0x106a89,(%esp)
  1031db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031df:	e8 5c d5 ff ff       	call   100740 <cprintf>
    if(p->state == SLEEPING){
  1031e4:	83 3b 02             	cmpl   $0x2,(%ebx)
  1031e7:	74 2f                	je     103218 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1031e9:	c7 04 24 33 6a 10 00 	movl   $0x106a33,(%esp)
  1031f0:	e8 4b d5 ff ff       	call   100740 <cprintf>
  1031f5:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1031fb:	81 fb 6c e5 10 00    	cmp    $0x10e56c,%ebx
  103201:	74 55                	je     103258 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  103203:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103205:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  103208:	85 c0                	test   %eax,%eax
  10320a:	74 e9                	je     1031f5 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  10320c:	83 f8 05             	cmp    $0x5,%eax
  10320f:	76 a7                	jbe    1031b8 <procdump+0x18>
  103211:	b8 85 6a 10 00       	mov    $0x106a85,%eax
  103216:	eb ab                	jmp    1031c3 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103218:	8b 43 74             	mov    0x74(%ebx),%eax
  10321b:	31 f6                	xor    %esi,%esi
  10321d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103221:	83 c0 08             	add    $0x8,%eax
  103224:	89 04 24             	mov    %eax,(%esp)
  103227:	e8 74 10 00 00       	call   1042a0 <getcallerpcs>
  10322c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103230:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103233:	85 c0                	test   %eax,%eax
  103235:	74 b2                	je     1031e9 <procdump+0x49>
  103237:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  10323a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10323e:	c7 04 24 f5 65 10 00 	movl   $0x1065f5,(%esp)
  103245:	e8 f6 d4 ff ff       	call   100740 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10324a:	83 fe 0a             	cmp    $0xa,%esi
  10324d:	75 e1                	jne    103230 <procdump+0x90>
  10324f:	eb 98                	jmp    1031e9 <procdump+0x49>
  103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103258:	83 c4 4c             	add    $0x4c,%esp
  10325b:	5b                   	pop    %ebx
  10325c:	5e                   	pop    %esi
  10325d:	5f                   	pop    %edi
  10325e:	5d                   	pop    %ebp
  10325f:	90                   	nop
  103260:	c3                   	ret    
  103261:	eb 0d                	jmp    103270 <kill>
  103263:	90                   	nop
  103264:	90                   	nop
  103265:	90                   	nop
  103266:	90                   	nop
  103267:	90                   	nop
  103268:	90                   	nop
  103269:	90                   	nop
  10326a:	90                   	nop
  10326b:	90                   	nop
  10326c:	90                   	nop
  10326d:	90                   	nop
  10326e:	90                   	nop
  10326f:	90                   	nop

00103270 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103270:	55                   	push   %ebp
  103271:	89 e5                	mov    %esp,%ebp
  103273:	53                   	push   %ebx
  103274:	83 ec 14             	sub    $0x14,%esp
  103277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10327a:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103281:	e8 ba 11 00 00       	call   104440 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103286:	b8 60 e5 10 00       	mov    $0x10e560,%eax
  10328b:	3d 60 be 10 00       	cmp    $0x10be60,%eax
  103290:	76 56                	jbe    1032e8 <kill+0x78>
    if(p->pid == pid){
  103292:	39 1d 70 be 10 00    	cmp    %ebx,0x10be70

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103298:	b8 60 be 10 00       	mov    $0x10be60,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10329d:	74 12                	je     1032b1 <kill+0x41>
  10329f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  1032a0:	05 9c 00 00 00       	add    $0x9c,%eax
  1032a5:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  1032aa:	74 3c                	je     1032e8 <kill+0x78>
    if(p->pid == pid){
  1032ac:	39 58 10             	cmp    %ebx,0x10(%eax)
  1032af:	75 ef                	jne    1032a0 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1032b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  1032b5:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  1032bc:	74 1a                	je     1032d8 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1032be:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1032c5:	e8 36 11 00 00       	call   104400 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1032ca:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1032cd:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1032cf:	5b                   	pop    %ebx
  1032d0:	5d                   	pop    %ebp
  1032d1:	c3                   	ret    
  1032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1032d8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1032df:	eb dd                	jmp    1032be <kill+0x4e>
  1032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1032e8:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1032ef:	e8 0c 11 00 00       	call   104400 <release>
  return -1;
}
  1032f4:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1032f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1032fc:	5b                   	pop    %ebx
  1032fd:	5d                   	pop    %ebp
  1032fe:	c3                   	ret    
  1032ff:	90                   	nop

00103300 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  103300:	55                   	push   %ebp
  103301:	89 e5                	mov    %esp,%ebp
  103303:	53                   	push   %ebx
  103304:	83 ec 14             	sub    $0x14,%esp
  103307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10330a:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103311:	e8 2a 11 00 00       	call   104440 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103316:	b8 60 e5 10 00       	mov    $0x10e560,%eax
  10331b:	3d 60 be 10 00       	cmp    $0x10be60,%eax
  103320:	76 3e                	jbe    103360 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  103322:	b8 60 be 10 00       	mov    $0x10be60,%eax
  103327:	eb 13                	jmp    10333c <wakeup+0x3c>
  103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103330:	05 9c 00 00 00       	add    $0x9c,%eax
  103335:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  10333a:	74 24                	je     103360 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  10333c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103340:	75 ee                	jne    103330 <wakeup+0x30>
  103342:	3b 58 18             	cmp    0x18(%eax),%ebx
  103345:	75 e9                	jne    103330 <wakeup+0x30>
      p->state = RUNNABLE;
  103347:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10334e:	05 9c 00 00 00       	add    $0x9c,%eax
  103353:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  103358:	75 e2                	jne    10333c <wakeup+0x3c>
  10335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103360:	c7 45 08 60 e5 10 00 	movl   $0x10e560,0x8(%ebp)
}
  103367:	83 c4 14             	add    $0x14,%esp
  10336a:	5b                   	pop    %ebx
  10336b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  10336c:	e9 8f 10 00 00       	jmp    104400 <release>
  103371:	eb 0d                	jmp    103380 <allocproc>
  103373:	90                   	nop
  103374:	90                   	nop
  103375:	90                   	nop
  103376:	90                   	nop
  103377:	90                   	nop
  103378:	90                   	nop
  103379:	90                   	nop
  10337a:	90                   	nop
  10337b:	90                   	nop
  10337c:	90                   	nop
  10337d:	90                   	nop
  10337e:	90                   	nop
  10337f:	90                   	nop

00103380 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103380:	55                   	push   %ebp
  103381:	89 e5                	mov    %esp,%ebp
  103383:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103384:	bb 60 be 10 00       	mov    $0x10be60,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103389:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10338c:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103393:	e8 a8 10 00 00       	call   104440 <acquire>
  103398:	eb 14                	jmp    1033ae <allocproc+0x2e>
  10339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  1033a0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  1033a6:	81 fb 60 e5 10 00    	cmp    $0x10e560,%ebx
  1033ac:	74 32                	je     1033e0 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  1033ae:	8b 43 0c             	mov    0xc(%ebx),%eax
  1033b1:	85 c0                	test   %eax,%eax
  1033b3:	75 eb                	jne    1033a0 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  1033b5:	a1 24 80 10 00       	mov    0x108024,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  1033ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  1033c1:	89 43 10             	mov    %eax,0x10(%ebx)
  1033c4:	83 c0 01             	add    $0x1,%eax
  1033c7:	a3 24 80 10 00       	mov    %eax,0x108024
      release(&proc_table_lock);
  1033cc:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1033d3:	e8 28 10 00 00       	call   104400 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  1033d8:	89 d8                	mov    %ebx,%eax
  1033da:	83 c4 14             	add    $0x14,%esp
  1033dd:	5b                   	pop    %ebx
  1033de:	5d                   	pop    %ebp
  1033df:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  1033e0:	31 db                	xor    %ebx,%ebx
  1033e2:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1033e9:	e8 12 10 00 00       	call   104400 <release>
  return 0;
}
  1033ee:	89 d8                	mov    %ebx,%eax
  1033f0:	83 c4 14             	add    $0x14,%esp
  1033f3:	5b                   	pop    %ebx
  1033f4:	5d                   	pop    %ebp
  1033f5:	c3                   	ret    
  1033f6:	8d 76 00             	lea    0x0(%esi),%esi
  1033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103400 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103400:	55                   	push   %ebp
  103401:	89 e5                	mov    %esp,%ebp
  103403:	53                   	push   %ebx
  103404:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103407:	e8 64 0f 00 00       	call   104370 <pushcli>
  p = cpus[cpu()].curproc;
  10340c:	e8 5f f4 ff ff       	call   102870 <cpu>
  103411:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103417:	8b 98 e4 b7 10 00    	mov    0x10b7e4(%eax),%ebx
  popcli();
  10341d:	e8 ce 0e 00 00       	call   1042f0 <popcli>
  return p;
}
  103422:	83 c4 04             	add    $0x4,%esp
  103425:	89 d8                	mov    %ebx,%eax
  103427:	5b                   	pop    %ebx
  103428:	5d                   	pop    %ebp
  103429:	c3                   	ret    
  10342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103430 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103430:	55                   	push   %ebp
  103431:	89 e5                	mov    %esp,%ebp
  103433:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103436:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10343d:	e8 be 0f 00 00       	call   104400 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103442:	e8 b9 ff ff ff       	call   103400 <curproc>
  103447:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10344d:	89 04 24             	mov    %eax,(%esp)
  103450:	e8 77 23 00 00       	call   1057cc <forkret1>
}
  103455:	c9                   	leave  
  103456:	c3                   	ret    
  103457:	89 f6                	mov    %esi,%esi
  103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103460 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103460:	55                   	push   %ebp
  103461:	89 e5                	mov    %esp,%ebp
  103463:	53                   	push   %ebx
  103464:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103467:	9c                   	pushf  
  103468:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103469:	f6 c4 02             	test   $0x2,%ah
  10346c:	75 5c                	jne    1034ca <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10346e:	e8 8d ff ff ff       	call   103400 <curproc>
  103473:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103477:	74 75                	je     1034ee <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103479:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103480:	e8 3b 0f 00 00       	call   1043c0 <holding>
  103485:	85 c0                	test   %eax,%eax
  103487:	74 59                	je     1034e2 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103489:	e8 e2 f3 ff ff       	call   102870 <cpu>
  10348e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103494:	83 b8 a4 b8 10 00 01 	cmpl   $0x1,0x10b8a4(%eax)
  10349b:	75 39                	jne    1034d6 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10349d:	e8 ce f3 ff ff       	call   102870 <cpu>
  1034a2:	89 c3                	mov    %eax,%ebx
  1034a4:	e8 57 ff ff ff       	call   103400 <curproc>
  1034a9:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  1034af:	81 c3 e8 b7 10 00    	add    $0x10b7e8,%ebx
  1034b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1034b9:	83 c0 64             	add    $0x64,%eax
  1034bc:	89 04 24             	mov    %eax,(%esp)
  1034bf:	e8 e8 11 00 00       	call   1046ac <swtch>
}
  1034c4:	83 c4 14             	add    $0x14,%esp
  1034c7:	5b                   	pop    %ebx
  1034c8:	5d                   	pop    %ebp
  1034c9:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  1034ca:	c7 04 24 92 6a 10 00 	movl   $0x106a92,(%esp)
  1034d1:	e8 0a d4 ff ff       	call   1008e0 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  1034d6:	c7 04 24 ca 6a 10 00 	movl   $0x106aca,(%esp)
  1034dd:	e8 fe d3 ff ff       	call   1008e0 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  1034e2:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1034e9:	e8 f2 d3 ff ff       	call   1008e0 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  1034ee:	c7 04 24 a6 6a 10 00 	movl   $0x106aa6,(%esp)
  1034f5:	e8 e6 d3 ff ff       	call   1008e0 <panic>
  1034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103500 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103500:	55                   	push   %ebp
  103501:	89 e5                	mov    %esp,%ebp
  103503:	56                   	push   %esi
  103504:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103505:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103507:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  10350a:	e8 f1 fe ff ff       	call   103400 <curproc>
  10350f:	3b 05 68 85 10 00    	cmp    0x108568,%eax
  103515:	0f 84 36 01 00 00    	je     103651 <exit+0x151>
  10351b:	90                   	nop
  10351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103520:	e8 db fe ff ff       	call   103400 <curproc>
  103525:	8d 73 08             	lea    0x8(%ebx),%esi
  103528:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  10352b:	85 d2                	test   %edx,%edx
  10352d:	74 1c                	je     10354b <exit+0x4b>
      fileclose(cp->ofile[fd]);
  10352f:	e8 cc fe ff ff       	call   103400 <curproc>
  103534:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  103537:	89 04 24             	mov    %eax,(%esp)
  10353a:	e8 b1 da ff ff       	call   100ff0 <fileclose>
      cp->ofile[fd] = 0;
  10353f:	e8 bc fe ff ff       	call   103400 <curproc>
  103544:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  10354b:	83 c3 01             	add    $0x1,%ebx
  10354e:	83 fb 10             	cmp    $0x10,%ebx
  103551:	75 cd                	jne    103520 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103553:	e8 a8 fe ff ff       	call   103400 <curproc>
  103558:	8b 40 60             	mov    0x60(%eax),%eax
  10355b:	89 04 24             	mov    %eax,(%esp)
  10355e:	e8 3d e4 ff ff       	call   1019a0 <iput>
  cp->cwd = 0;
  103563:	e8 98 fe ff ff       	call   103400 <curproc>
  103568:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  10356f:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103576:	e8 c5 0e 00 00       	call   104440 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10357b:	e8 80 fe ff ff       	call   103400 <curproc>
  103580:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103583:	b8 60 e5 10 00       	mov    $0x10e560,%eax
  103588:	3d 60 be 10 00       	cmp    $0x10be60,%eax
  10358d:	0f 86 95 00 00 00    	jbe    103628 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103593:	b8 60 be 10 00       	mov    $0x10be60,%eax
  103598:	eb 12                	jmp    1035ac <exit+0xac>
  10359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035a0:	05 9c 00 00 00       	add    $0x9c,%eax
  1035a5:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  1035aa:	74 1e                	je     1035ca <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  1035ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1035b0:	75 ee                	jne    1035a0 <exit+0xa0>
  1035b2:	3b 50 18             	cmp    0x18(%eax),%edx
  1035b5:	75 e9                	jne    1035a0 <exit+0xa0>
      p->state = RUNNABLE;
  1035b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035be:	05 9c 00 00 00       	add    $0x9c,%eax
  1035c3:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  1035c8:	75 e2                	jne    1035ac <exit+0xac>
  1035ca:	bb 60 be 10 00       	mov    $0x10be60,%ebx
  1035cf:	eb 15                	jmp    1035e6 <exit+0xe6>
  1035d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  1035d8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  1035de:	81 fb 60 e5 10 00    	cmp    $0x10e560,%ebx
  1035e4:	74 42                	je     103628 <exit+0x128>
    if(p->parent == cp){
  1035e6:	8b 73 14             	mov    0x14(%ebx),%esi
  1035e9:	e8 12 fe ff ff       	call   103400 <curproc>
  1035ee:	39 c6                	cmp    %eax,%esi
  1035f0:	75 e6                	jne    1035d8 <exit+0xd8>
      p->parent = initproc;
  1035f2:	8b 15 68 85 10 00    	mov    0x108568,%edx
      if(p->state == ZOMBIE)
  1035f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  1035fc:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  1035ff:	75 d7                	jne    1035d8 <exit+0xd8>
  103601:	b8 60 be 10 00       	mov    $0x10be60,%eax
  103606:	eb 0c                	jmp    103614 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103608:	05 9c 00 00 00       	add    $0x9c,%eax
  10360d:	3d 60 e5 10 00       	cmp    $0x10e560,%eax
  103612:	74 c4                	je     1035d8 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  103614:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103618:	75 ee                	jne    103608 <exit+0x108>
  10361a:	3b 50 18             	cmp    0x18(%eax),%edx
  10361d:	75 e9                	jne    103608 <exit+0x108>
      p->state = RUNNABLE;
  10361f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103626:	eb e0                	jmp    103608 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103628:	e8 d3 fd ff ff       	call   103400 <curproc>
  10362d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  103634:	e8 c7 fd ff ff       	call   103400 <curproc>
  103639:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103640:	e8 1b fe ff ff       	call   103460 <sched>
  panic("zombie exit");
  103645:	c7 04 24 e3 6a 10 00 	movl   $0x106ae3,(%esp)
  10364c:	e8 8f d2 ff ff       	call   1008e0 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103651:	c7 04 24 d6 6a 10 00 	movl   $0x106ad6,(%esp)
  103658:	e8 83 d2 ff ff       	call   1008e0 <panic>
  10365d:	8d 76 00             	lea    0x0(%esi),%esi

00103660 <sleep_lock>:
  }
}

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  103660:	55                   	push   %ebp
  103661:	89 e5                	mov    %esp,%ebp
  103663:	83 ec 18             	sub    $0x18,%esp
  if(cp == 0)
  103666:	e8 95 fd ff ff       	call   103400 <curproc>
  10366b:	85 c0                	test   %eax,%eax
  10366d:	74 2b                	je     10369a <sleep_lock+0x3a>
    panic("sleep");
  acquire(&proc_table_lock);
  10366f:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103676:	e8 c5 0d 00 00       	call   104440 <acquire>
  cp->state = SLEEPING;
  10367b:	e8 80 fd ff ff       	call   103400 <curproc>
  103680:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
	sched();
  103687:	e8 d4 fd ff ff       	call   103460 <sched>
	release(&proc_table_lock); 
  10368c:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103693:	e8 68 0d 00 00       	call   104400 <release>
}
  103698:	c9                   	leave  
  103699:	c3                   	ret    

//Put the current process to sleep (used by cond_wait)
void sleep_lock(void)
{
  if(cp == 0)
    panic("sleep");
  10369a:	c7 04 24 ef 6a 10 00 	movl   $0x106aef,(%esp)
  1036a1:	e8 3a d2 ff ff       	call   1008e0 <panic>
  1036a6:	8d 76 00             	lea    0x0(%esi),%esi
  1036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001036b0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1036b0:	55                   	push   %ebp
  1036b1:	89 e5                	mov    %esp,%ebp
  1036b3:	56                   	push   %esi
  1036b4:	53                   	push   %ebx
  1036b5:	83 ec 10             	sub    $0x10,%esp
  1036b8:	8b 75 08             	mov    0x8(%ebp),%esi
  1036bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1036be:	e8 3d fd ff ff       	call   103400 <curproc>
  1036c3:	85 c0                	test   %eax,%eax
  1036c5:	0f 84 9d 00 00 00    	je     103768 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  1036cb:	85 db                	test   %ebx,%ebx
  1036cd:	0f 84 89 00 00 00    	je     10375c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  1036d3:	81 fb 60 e5 10 00    	cmp    $0x10e560,%ebx
  1036d9:	74 55                	je     103730 <sleep+0x80>
    acquire(&proc_table_lock);
  1036db:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1036e2:	e8 59 0d 00 00       	call   104440 <acquire>
    release(lk);
  1036e7:	89 1c 24             	mov    %ebx,(%esp)
  1036ea:	e8 11 0d 00 00       	call   104400 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  1036ef:	e8 0c fd ff ff       	call   103400 <curproc>
  1036f4:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  1036f7:	e8 04 fd ff ff       	call   103400 <curproc>
  1036fc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103703:	e8 58 fd ff ff       	call   103460 <sched>

  // Tidy up.
  cp->chan = 0;
  103708:	e8 f3 fc ff ff       	call   103400 <curproc>
  10370d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103714:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10371b:	e8 e0 0c 00 00       	call   104400 <release>
    acquire(lk);
  103720:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103723:	83 c4 10             	add    $0x10,%esp
  103726:	5b                   	pop    %ebx
  103727:	5e                   	pop    %esi
  103728:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103729:	e9 12 0d 00 00       	jmp    104440 <acquire>
  10372e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103730:	e8 cb fc ff ff       	call   103400 <curproc>
  103735:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103738:	e8 c3 fc ff ff       	call   103400 <curproc>
  10373d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103744:	e8 17 fd ff ff       	call   103460 <sched>

  // Tidy up.
  cp->chan = 0;
  103749:	e8 b2 fc ff ff       	call   103400 <curproc>
  10374e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103755:	83 c4 10             	add    $0x10,%esp
  103758:	5b                   	pop    %ebx
  103759:	5e                   	pop    %esi
  10375a:	5d                   	pop    %ebp
  10375b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  10375c:	c7 04 24 f5 6a 10 00 	movl   $0x106af5,(%esp)
  103763:	e8 78 d1 ff ff       	call   1008e0 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103768:	c7 04 24 ef 6a 10 00 	movl   $0x106aef,(%esp)
  10376f:	e8 6c d1 ff ff       	call   1008e0 <panic>
  103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103780 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103780:	55                   	push   %ebp
  103781:	89 e5                	mov    %esp,%ebp
  103783:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103784:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103786:	56                   	push   %esi
  103787:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103788:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  10378a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10378d:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103794:	e8 a7 0c 00 00       	call   104440 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103799:	83 fb 3f             	cmp    $0x3f,%ebx
  10379c:	7e 2f                	jle    1037cd <wait_thread+0x4d>
  10379e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1037a0:	85 ff                	test   %edi,%edi
  1037a2:	74 74                	je     103818 <wait_thread+0x98>
  1037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1037a8:	e8 53 fc ff ff       	call   103400 <curproc>
  1037ad:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1037b0:	85 c9                	test   %ecx,%ecx
  1037b2:	75 64                	jne    103818 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1037b4:	e8 47 fc ff ff       	call   103400 <curproc>
  1037b9:	31 ff                	xor    %edi,%edi
  1037bb:	31 db                	xor    %ebx,%ebx
  1037bd:	c7 44 24 04 60 e5 10 	movl   $0x10e560,0x4(%esp)
  1037c4:	00 
  1037c5:	89 04 24             	mov    %eax,(%esp)
  1037c8:	e8 e3 fe ff ff       	call   1036b0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1037cd:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  1037d3:	81 c6 60 be 10 00    	add    $0x10be60,%esi
      if(p->state == UNUSED)
  1037d9:	8b 46 0c             	mov    0xc(%esi),%eax
  1037dc:	85 c0                	test   %eax,%eax
  1037de:	75 10                	jne    1037f0 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1037e0:	83 c3 01             	add    $0x1,%ebx
  1037e3:	83 fb 3f             	cmp    $0x3f,%ebx
  1037e6:	7e e5                	jle    1037cd <wait_thread+0x4d>
  1037e8:	eb b6                	jmp    1037a0 <wait_thread+0x20>
  1037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  1037f0:	8b 46 14             	mov    0x14(%esi),%eax
  1037f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037f6:	e8 05 fc ff ff       	call   103400 <curproc>
  1037fb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037fe:	66 90                	xchg   %ax,%ax
  103800:	75 de                	jne    1037e0 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103802:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103806:	74 29                	je     103831 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103808:	bf 01 00 00 00       	mov    $0x1,%edi
  10380d:	8d 76 00             	lea    0x0(%esi),%esi
  103810:	eb ce                	jmp    1037e0 <wait_thread+0x60>
  103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103818:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10381f:	e8 dc 0b 00 00       	call   104400 <release>
  103824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103829:	83 c4 2c             	add    $0x2c,%esp
  10382c:	5b                   	pop    %ebx
  10382d:	5e                   	pop    %esi
  10382e:	5f                   	pop    %edi
  10382f:	5d                   	pop    %ebp
  103830:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103831:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103838:	00 
  103839:	8b 46 08             	mov    0x8(%esi),%eax
  10383c:	89 04 24             	mov    %eax,(%esp)
  10383f:	e8 5c eb ff ff       	call   1023a0 <kfree>
          pid = p->pid;
  103844:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103847:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10384e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103855:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10385c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103863:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103866:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10386d:	e8 8e 0b 00 00       	call   104400 <release>
          return pid;
  103872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103875:	eb b2                	jmp    103829 <wait_thread+0xa9>
  103877:	89 f6                	mov    %esi,%esi
  103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103880 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103880:	55                   	push   %ebp
  103881:	89 e5                	mov    %esp,%ebp
  103883:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103884:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103886:	56                   	push   %esi
  103887:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103888:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  10388a:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  10388d:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103894:	e8 a7 0b 00 00       	call   104440 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103899:	83 fb 3f             	cmp    $0x3f,%ebx
  10389c:	7e 2f                	jle    1038cd <wait+0x4d>
  10389e:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1038a0:	85 ff                	test   %edi,%edi
  1038a2:	74 74                	je     103918 <wait+0x98>
  1038a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038a8:	e8 53 fb ff ff       	call   103400 <curproc>
  1038ad:	8b 50 1c             	mov    0x1c(%eax),%edx
  1038b0:	85 d2                	test   %edx,%edx
  1038b2:	75 64                	jne    103918 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1038b4:	e8 47 fb ff ff       	call   103400 <curproc>
  1038b9:	31 ff                	xor    %edi,%edi
  1038bb:	31 db                	xor    %ebx,%ebx
  1038bd:	c7 44 24 04 60 e5 10 	movl   $0x10e560,0x4(%esp)
  1038c4:	00 
  1038c5:	89 04 24             	mov    %eax,(%esp)
  1038c8:	e8 e3 fd ff ff       	call   1036b0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1038cd:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  1038d3:	81 c6 60 be 10 00    	add    $0x10be60,%esi
      if(p->state == UNUSED)
  1038d9:	8b 4e 0c             	mov    0xc(%esi),%ecx
  1038dc:	85 c9                	test   %ecx,%ecx
  1038de:	75 10                	jne    1038f0 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1038e0:	83 c3 01             	add    $0x1,%ebx
  1038e3:	83 fb 3f             	cmp    $0x3f,%ebx
  1038e6:	7e e5                	jle    1038cd <wait+0x4d>
  1038e8:	eb b6                	jmp    1038a0 <wait+0x20>
  1038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  1038f0:	8b 46 14             	mov    0x14(%esi),%eax
  1038f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038f6:	e8 05 fb ff ff       	call   103400 <curproc>
  1038fb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1038fe:	66 90                	xchg   %ax,%ax
  103900:	75 de                	jne    1038e0 <wait+0x60>
        if(p->state == ZOMBIE){
  103902:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103906:	74 29                	je     103931 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103908:	bf 01 00 00 00       	mov    $0x1,%edi
  10390d:	8d 76 00             	lea    0x0(%esi),%esi
  103910:	eb ce                	jmp    1038e0 <wait+0x60>
  103912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103918:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10391f:	e8 dc 0a 00 00       	call   104400 <release>
  103924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103929:	83 c4 2c             	add    $0x2c,%esp
  10392c:	5b                   	pop    %ebx
  10392d:	5e                   	pop    %esi
  10392e:	5f                   	pop    %edi
  10392f:	5d                   	pop    %ebp
  103930:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103931:	8b 46 04             	mov    0x4(%esi),%eax
  103934:	89 44 24 04          	mov    %eax,0x4(%esp)
  103938:	8b 06                	mov    (%esi),%eax
  10393a:	89 04 24             	mov    %eax,(%esp)
  10393d:	e8 5e ea ff ff       	call   1023a0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103942:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103949:	00 
  10394a:	8b 46 08             	mov    0x8(%esi),%eax
  10394d:	89 04 24             	mov    %eax,(%esp)
  103950:	e8 4b ea ff ff       	call   1023a0 <kfree>
          pid = p->pid;
  103955:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103958:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10395f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103966:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10396d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103974:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103977:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10397e:	e8 7d 0a 00 00       	call   104400 <release>
          return pid;
  103983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103986:	eb a1                	jmp    103929 <wait+0xa9>
  103988:	90                   	nop
  103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103990 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103990:	55                   	push   %ebp
  103991:	89 e5                	mov    %esp,%ebp
  103993:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  103996:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  10399d:	e8 9e 0a 00 00       	call   104440 <acquire>
  cp->state = RUNNABLE;
  1039a2:	e8 59 fa ff ff       	call   103400 <curproc>
  1039a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1039ae:	e8 ad fa ff ff       	call   103460 <sched>
  release(&proc_table_lock);
  1039b3:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  1039ba:	e8 41 0a 00 00       	call   104400 <release>
}
  1039bf:	c9                   	leave  
  1039c0:	c3                   	ret    
  1039c1:	eb 0d                	jmp    1039d0 <setupsegs>
  1039c3:	90                   	nop
  1039c4:	90                   	nop
  1039c5:	90                   	nop
  1039c6:	90                   	nop
  1039c7:	90                   	nop
  1039c8:	90                   	nop
  1039c9:	90                   	nop
  1039ca:	90                   	nop
  1039cb:	90                   	nop
  1039cc:	90                   	nop
  1039cd:	90                   	nop
  1039ce:	90                   	nop
  1039cf:	90                   	nop

001039d0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1039d0:	55                   	push   %ebp
  1039d1:	89 e5                	mov    %esp,%ebp
  1039d3:	57                   	push   %edi
  1039d4:	56                   	push   %esi
  1039d5:	53                   	push   %ebx
  1039d6:	83 ec 2c             	sub    $0x2c,%esp
  1039d9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  1039dc:	e8 8f 09 00 00       	call   104370 <pushcli>
  c = &cpus[cpu()];
  1039e1:	e8 8a ee ff ff       	call   102870 <cpu>
  1039e6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1039ec:	05 e0 b7 10 00       	add    $0x10b7e0,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1039f1:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  1039f3:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  1039f9:	0f 84 a1 01 00 00    	je     103ba0 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  1039ff:	8b 56 08             	mov    0x8(%esi),%edx
  103a02:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103a08:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103a0b:	8d 50 28             	lea    0x28(%eax),%edx
  103a0e:	89 d1                	mov    %edx,%ecx
  103a10:	c1 e9 10             	shr    $0x10,%ecx
  103a13:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103a1a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103a1d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103a1f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103a26:	00 00 00 
  103a29:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103a30:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103a33:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103a3a:	0f 01 
  103a3c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103a43:	00 00 
  103a45:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103a4c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103a53:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103a5a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103a61:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103a68:	ff ff 
  103a6a:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103a71:	00 00 
  103a73:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103a7a:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103a81:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103a88:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103a8f:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103a96:	67 00 
  103a98:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103a9e:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103aa5:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103aab:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103ab2:	0f 84 b8 00 00 00    	je     103b70 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103ab8:	8b 16                	mov    (%esi),%edx
  103aba:	8b 5e 04             	mov    0x4(%esi),%ebx
  103abd:	89 d6                	mov    %edx,%esi
  103abf:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103ac2:	89 d3                	mov    %edx,%ebx
  103ac4:	c1 ee 10             	shr    $0x10,%esi
  103ac7:	89 cf                	mov    %ecx,%edi
  103ac9:	c1 eb 18             	shr    $0x18,%ebx
  103acc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103acf:	89 f3                	mov    %esi,%ebx
  103ad1:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103ad7:	89 cb                	mov    %ecx,%ebx
  103ad9:	c1 eb 1c             	shr    $0x1c,%ebx
  103adc:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103ade:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103ae1:	83 c9 c0             	or     $0xffffffc0,%ecx
  103ae4:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103aeb:	c1 ef 0c             	shr    $0xc,%edi
  103aee:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103af4:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103af8:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103aff:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b05:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103b0c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b12:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103b16:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103b1d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b1f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b26:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103b2d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103b33:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103b39:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103b3e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103b44:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103b48:	c1 e8 10             	shr    $0x10,%eax
  103b4b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103b4f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103b52:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103b55:	b8 28 00 00 00       	mov    $0x28,%eax
  103b5a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103b5d:	e8 8e 07 00 00       	call   1042f0 <popcli>
}
  103b62:	83 c4 2c             	add    $0x2c,%esp
  103b65:	5b                   	pop    %ebx
  103b66:	5e                   	pop    %esi
  103b67:	5f                   	pop    %edi
  103b68:	5d                   	pop    %ebp
  103b69:	c3                   	ret    
  103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103b70:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103b77:	00 00 00 
  103b7a:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103b81:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103b84:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103b8b:	00 00 00 
  103b8e:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103b95:	00 00 00 
  103b98:	eb 9f                	jmp    103b39 <setupsegs+0x169>
  103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103ba0:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103ba7:	e9 5f fe ff ff       	jmp    103a0b <setupsegs+0x3b>
  103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103bb0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103bb0:	55                   	push   %ebp
  103bb1:	89 e5                	mov    %esp,%ebp
  103bb3:	57                   	push   %edi
  103bb4:	56                   	push   %esi
  103bb5:	53                   	push   %ebx
  103bb6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103bb9:	e8 b2 ec ff ff       	call   102870 <cpu>
  103bbe:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103bc4:	81 c3 e0 b7 10 00    	add    $0x10b7e0,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103bca:	8d 73 08             	lea    0x8(%ebx),%esi
  103bcd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103bd0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103bd1:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103bd8:	e8 63 08 00 00       	call   104440 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103bdd:	83 3d 70 be 10 00 01 	cmpl   $0x1,0x10be70
  103be4:	0f 84 c6 00 00 00    	je     103cb0 <scheduler+0x100>
  103bea:	31 d2                	xor    %edx,%edx
  103bec:	31 c0                	xor    %eax,%eax
  103bee:	eb 0e                	jmp    103bfe <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103bf0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103bf6:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103bfc:	74 1d                	je     103c1b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103bfe:	83 ba 6c be 10 00 03 	cmpl   $0x3,0x10be6c(%edx)
  103c05:	75 e9                	jne    103bf0 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c07:	03 82 f8 be 10 00    	add    0x10bef8(%edx),%eax
  103c0d:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103c13:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103c19:	75 e3                	jne    103bfe <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103c1b:	85 c0                	test   %eax,%eax
  103c1d:	74 16                	je     103c35 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103c1f:	8b 3d e0 ed 10 00    	mov    0x10ede0,%edi
  103c25:	89 c1                	mov    %eax,%ecx
  103c27:	c1 e7 08             	shl    $0x8,%edi
  103c2a:	89 fa                	mov    %edi,%edx
  103c2c:	89 f8                	mov    %edi,%eax
  103c2e:	c1 fa 1f             	sar    $0x1f,%edx
  103c31:	f7 f9                	idiv   %ecx
  103c33:	89 d7                	mov    %edx,%edi
  103c35:	b8 6c be 10 00       	mov    $0x10be6c,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c3a:	31 d2                	xor    %edx,%edx
  103c3c:	eb 12                	jmp    103c50 <scheduler+0xa0>
  103c3e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c40:	39 fa                	cmp    %edi,%edx
  103c42:	7f 1e                	jg     103c62 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103c44:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103c49:	3d 6c e5 10 00       	cmp    $0x10e56c,%eax
  103c4e:	74 4c                	je     103c9c <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c50:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c53:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c56:	75 e8                	jne    103c40 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c58:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c5e:	39 fa                	cmp    %edi,%edx
  103c60:	7e e2                	jle    103c44 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103c62:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103c65:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103c68:	89 0c 24             	mov    %ecx,(%esp)
  103c6b:	e8 60 fd ff ff       	call   1039d0 <setupsegs>
    	  p->state = RUNNING;
  103c70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103c73:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103c7a:	83 c1 64             	add    $0x64,%ecx
  103c7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103c81:	89 34 24             	mov    %esi,(%esp)
  103c84:	e8 23 0a 00 00       	call   1046ac <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103c89:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103c90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103c97:	e8 34 fd ff ff       	call   1039d0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103c9c:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103ca3:	e8 58 07 00 00       	call   104400 <release>
  103ca8:	e9 23 ff ff ff       	jmp    103bd0 <scheduler+0x20>
  103cad:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103cb0:	83 3d 6c be 10 00 03 	cmpl   $0x3,0x10be6c
  103cb7:	0f 85 2d ff ff ff    	jne    103bea <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103cbd:	c7 43 04 60 be 10 00 	movl   $0x10be60,0x4(%ebx)
      setupsegs(p);
  103cc4:	c7 04 24 60 be 10 00 	movl   $0x10be60,(%esp)
  103ccb:	e8 00 fd ff ff       	call   1039d0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103cd0:	c7 44 24 04 c4 be 10 	movl   $0x10bec4,0x4(%esp)
  103cd7:	00 
  103cd8:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103cdb:	c7 05 f8 be 10 00 4b 	movl   $0x4b,0x10bef8
  103ce2:	00 00 00 
      p->state = RUNNING;
  103ce5:	c7 05 6c be 10 00 04 	movl   $0x4,0x10be6c
  103cec:	00 00 00 
      swtch(&c->context, &p->context);
  103cef:	e8 b8 09 00 00       	call   1046ac <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103cf4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103cfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103d02:	e8 c9 fc ff ff       	call   1039d0 <setupsegs>
      release(&proc_table_lock);
  103d07:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  103d0e:	e8 ed 06 00 00       	call   104400 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d13:	e9 b8 fe ff ff       	jmp    103bd0 <scheduler+0x20>
  103d18:	90                   	nop
  103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103d20 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103d20:	55                   	push   %ebp
  103d21:	89 e5                	mov    %esp,%ebp
  103d23:	57                   	push   %edi
  103d24:	56                   	push   %esi
  103d25:	53                   	push   %ebx
  103d26:	83 ec 1c             	sub    $0x1c,%esp
  103d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103d2c:	e8 cf f6 ff ff       	call   103400 <curproc>
  103d31:	8b 50 04             	mov    0x4(%eax),%edx
  103d34:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103d37:	89 04 24             	mov    %eax,(%esp)
  103d3a:	e8 a1 e5 ff ff       	call   1022e0 <kalloc>
  103d3f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d46:	85 f6                	test   %esi,%esi
  103d48:	74 7f                	je     103dc9 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103d4a:	e8 b1 f6 ff ff       	call   103400 <curproc>
  103d4f:	8b 78 04             	mov    0x4(%eax),%edi
  103d52:	e8 a9 f6 ff ff       	call   103400 <curproc>
  103d57:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103d5b:	8b 00                	mov    (%eax),%eax
  103d5d:	89 34 24             	mov    %esi,(%esp)
  103d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d64:	e8 d7 07 00 00       	call   104540 <memmove>
  memset(newmem + cp->sz, 0, n);
  103d69:	e8 92 f6 ff ff       	call   103400 <curproc>
  103d6e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103d72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103d79:	00 
  103d7a:	8b 50 04             	mov    0x4(%eax),%edx
  103d7d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103d80:	89 04 24             	mov    %eax,(%esp)
  103d83:	e8 28 07 00 00       	call   1044b0 <memset>
  kfree(cp->mem, cp->sz);
  103d88:	e8 73 f6 ff ff       	call   103400 <curproc>
  103d8d:	8b 78 04             	mov    0x4(%eax),%edi
  103d90:	e8 6b f6 ff ff       	call   103400 <curproc>
  103d95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103d99:	8b 00                	mov    (%eax),%eax
  103d9b:	89 04 24             	mov    %eax,(%esp)
  103d9e:	e8 fd e5 ff ff       	call   1023a0 <kfree>
  cp->mem = newmem;
  103da3:	e8 58 f6 ff ff       	call   103400 <curproc>
  103da8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103daa:	e8 51 f6 ff ff       	call   103400 <curproc>
  103daf:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  103db2:	e8 49 f6 ff ff       	call   103400 <curproc>
  103db7:	89 04 24             	mov    %eax,(%esp)
  103dba:	e8 11 fc ff ff       	call   1039d0 <setupsegs>
  return cp->sz - n;
  103dbf:	e8 3c f6 ff ff       	call   103400 <curproc>
  103dc4:	8b 40 04             	mov    0x4(%eax),%eax
  103dc7:	29 d8                	sub    %ebx,%eax
}
  103dc9:	83 c4 1c             	add    $0x1c,%esp
  103dcc:	5b                   	pop    %ebx
  103dcd:	5e                   	pop    %esi
  103dce:	5f                   	pop    %edi
  103dcf:	5d                   	pop    %ebp
  103dd0:	c3                   	ret    
  103dd1:	eb 0d                	jmp    103de0 <copyproc_tix>
  103dd3:	90                   	nop
  103dd4:	90                   	nop
  103dd5:	90                   	nop
  103dd6:	90                   	nop
  103dd7:	90                   	nop
  103dd8:	90                   	nop
  103dd9:	90                   	nop
  103dda:	90                   	nop
  103ddb:	90                   	nop
  103ddc:	90                   	nop
  103ddd:	90                   	nop
  103dde:	90                   	nop
  103ddf:	90                   	nop

00103de0 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103de0:	55                   	push   %ebp
  103de1:	89 e5                	mov    %esp,%ebp
  103de3:	57                   	push   %edi
  103de4:	56                   	push   %esi
  103de5:	53                   	push   %ebx
  103de6:	83 ec 1c             	sub    $0x1c,%esp
  103de9:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103dec:	e8 8f f5 ff ff       	call   103380 <allocproc>
  103df1:	85 c0                	test   %eax,%eax
  103df3:	89 c6                	mov    %eax,%esi
  103df5:	0f 84 e1 00 00 00    	je     103edc <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103dfb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103e02:	e8 d9 e4 ff ff       	call   1022e0 <kalloc>
  103e07:	85 c0                	test   %eax,%eax
  103e09:	89 46 08             	mov    %eax,0x8(%esi)
  103e0c:	0f 84 d4 00 00 00    	je     103ee6 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e12:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103e17:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e19:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103e1f:	0f 84 85 00 00 00    	je     103eaa <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  103e25:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103e28:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103e2b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103e31:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103e38:	00 
  103e39:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103e3f:	89 04 24             	mov    %eax,(%esp)
  103e42:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e46:	e8 f5 06 00 00       	call   104540 <memmove>
  
    np->sz = p->sz;
  103e4b:	8b 47 04             	mov    0x4(%edi),%eax
  103e4e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103e51:	89 04 24             	mov    %eax,(%esp)
  103e54:	e8 87 e4 ff ff       	call   1022e0 <kalloc>
  103e59:	85 c0                	test   %eax,%eax
  103e5b:	89 06                	mov    %eax,(%esi)
  103e5d:	0f 84 8e 00 00 00    	je     103ef1 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103e63:	8b 56 04             	mov    0x4(%esi),%edx
  103e66:	31 db                	xor    %ebx,%ebx
  103e68:	89 54 24 08          	mov    %edx,0x8(%esp)
  103e6c:	8b 17                	mov    (%edi),%edx
  103e6e:	89 04 24             	mov    %eax,(%esp)
  103e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e75:	e8 c6 06 00 00       	call   104540 <memmove>
  103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103e80:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103e84:	85 c0                	test   %eax,%eax
  103e86:	74 0c                	je     103e94 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103e88:	89 04 24             	mov    %eax,(%esp)
  103e8b:	e8 80 d0 ff ff       	call   100f10 <filedup>
  103e90:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103e94:	83 c3 01             	add    $0x1,%ebx
  103e97:	83 fb 10             	cmp    $0x10,%ebx
  103e9a:	75 e4                	jne    103e80 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103e9c:	8b 47 60             	mov    0x60(%edi),%eax
  103e9f:	89 04 24             	mov    %eax,(%esp)
  103ea2:	e8 79 d2 ff ff       	call   101120 <idup>
  103ea7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103eaa:	8d 46 64             	lea    0x64(%esi),%eax
  103ead:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103eb4:	00 
  103eb5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ebc:	00 
  103ebd:	89 04 24             	mov    %eax,(%esp)
  103ec0:	e8 eb 05 00 00       	call   1044b0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103ec5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103ecb:	c7 46 64 30 34 10 00 	movl   $0x103430,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103ed2:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103ed5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103edc:	83 c4 1c             	add    $0x1c,%esp
  103edf:	89 f0                	mov    %esi,%eax
  103ee1:	5b                   	pop    %ebx
  103ee2:	5e                   	pop    %esi
  103ee3:	5f                   	pop    %edi
  103ee4:	5d                   	pop    %ebp
  103ee5:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103ee6:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103eed:	31 f6                	xor    %esi,%esi
    return 0;
  103eef:	eb eb                	jmp    103edc <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103ef1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ef8:	00 
  103ef9:	8b 46 08             	mov    0x8(%esi),%eax
  103efc:	89 04 24             	mov    %eax,(%esp)
  103eff:	e8 9c e4 ff ff       	call   1023a0 <kfree>
      np->kstack = 0;
  103f04:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103f0b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103f12:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103f19:	31 f6                	xor    %esi,%esi
      return 0;
  103f1b:	eb bf                	jmp    103edc <copyproc_tix+0xfc>
  103f1d:	8d 76 00             	lea    0x0(%esi),%esi

00103f20 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
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
  if((np = allocproc()) == 0){
  103f2c:	e8 4f f4 ff ff       	call   103380 <allocproc>
  103f31:	85 c0                	test   %eax,%eax
  103f33:	89 c6                	mov    %eax,%esi
  103f35:	0f 84 de 00 00 00    	je     104019 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103f3b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103f42:	e8 99 e3 ff ff       	call   1022e0 <kalloc>
  103f47:	85 c0                	test   %eax,%eax
  103f49:	89 46 08             	mov    %eax,0x8(%esi)
  103f4c:	0f 84 d1 00 00 00    	je     104023 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f52:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103f57:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f59:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103f5f:	74 61                	je     103fc2 <copyproc_threads+0xa2>
    np->parent = p;
  103f61:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  103f64:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  103f66:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  103f6d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103f70:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103f77:	00 
  103f78:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103f7e:	89 04 24             	mov    %eax,(%esp)
  103f81:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f85:	e8 b6 05 00 00       	call   104540 <memmove>
  
    np->sz = p->sz;
  103f8a:	8b 47 04             	mov    0x4(%edi),%eax
  103f8d:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  103f90:	8b 07                	mov    (%edi),%eax
  103f92:	89 06                	mov    %eax,(%esi)
  103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103f98:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103f9c:	85 c0                	test   %eax,%eax
  103f9e:	74 0c                	je     103fac <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  103fa0:	89 04 24             	mov    %eax,(%esp)
  103fa3:	e8 68 cf ff ff       	call   100f10 <filedup>
  103fa8:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103fac:	83 c3 01             	add    $0x1,%ebx
  103faf:	83 fb 10             	cmp    $0x10,%ebx
  103fb2:	75 e4                	jne    103f98 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103fb4:	8b 47 60             	mov    0x60(%edi),%eax
  103fb7:	89 04 24             	mov    %eax,(%esp)
  103fba:	e8 61 d1 ff ff       	call   101120 <idup>
  103fbf:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103fc2:	8d 46 64             	lea    0x64(%esi),%eax
  103fc5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103fcc:	00 
  103fcd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103fd4:	00 
  103fd5:	89 04 24             	mov    %eax,(%esp)
  103fd8:	e8 d3 04 00 00       	call   1044b0 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103fdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103fe0:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103fe6:	c7 46 64 30 34 10 00 	movl   $0x103430,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  103fed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103ff0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103ff3:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103ff9:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  103ffc:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  103fff:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104001:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104008:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  10400f:	8b 40 3c             	mov    0x3c(%eax),%eax
  104012:	8b 4d 14             	mov    0x14(%ebp),%ecx
  104015:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  104019:	83 c4 1c             	add    $0x1c,%esp
  10401c:	89 f0                	mov    %esi,%eax
  10401e:	5b                   	pop    %ebx
  10401f:	5e                   	pop    %esi
  104020:	5f                   	pop    %edi
  104021:	5d                   	pop    %ebp
  104022:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104023:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10402a:	31 f6                	xor    %esi,%esi
    return 0;
  10402c:	eb eb                	jmp    104019 <copyproc_threads+0xf9>
  10402e:	66 90                	xchg   %ax,%ax

00104030 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104030:	55                   	push   %ebp
  104031:	89 e5                	mov    %esp,%ebp
  104033:	57                   	push   %edi
  104034:	56                   	push   %esi
  104035:	53                   	push   %ebx
  104036:	83 ec 1c             	sub    $0x1c,%esp
  104039:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10403c:	e8 3f f3 ff ff       	call   103380 <allocproc>
  104041:	85 c0                	test   %eax,%eax
  104043:	89 c6                	mov    %eax,%esi
  104045:	0f 84 e1 00 00 00    	je     10412c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10404b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104052:	e8 89 e2 ff ff       	call   1022e0 <kalloc>
  104057:	85 c0                	test   %eax,%eax
  104059:	89 46 08             	mov    %eax,0x8(%esi)
  10405c:	0f 84 d4 00 00 00    	je     104136 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104062:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104067:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104069:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10406f:	0f 84 85 00 00 00    	je     1040fa <copyproc+0xca>
    np->parent = p;
  104075:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104078:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10407f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104082:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104089:	00 
  10408a:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  104090:	89 04 24             	mov    %eax,(%esp)
  104093:	89 54 24 04          	mov    %edx,0x4(%esp)
  104097:	e8 a4 04 00 00       	call   104540 <memmove>
  
    np->sz = p->sz;
  10409c:	8b 47 04             	mov    0x4(%edi),%eax
  10409f:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  1040a2:	89 04 24             	mov    %eax,(%esp)
  1040a5:	e8 36 e2 ff ff       	call   1022e0 <kalloc>
  1040aa:	85 c0                	test   %eax,%eax
  1040ac:	89 06                	mov    %eax,(%esi)
  1040ae:	0f 84 8d 00 00 00    	je     104141 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1040b4:	8b 56 04             	mov    0x4(%esi),%edx
  1040b7:	31 db                	xor    %ebx,%ebx
  1040b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1040bd:	8b 17                	mov    (%edi),%edx
  1040bf:	89 04 24             	mov    %eax,(%esp)
  1040c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040c6:	e8 75 04 00 00       	call   104540 <memmove>
  1040cb:	90                   	nop
  1040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1040d0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1040d4:	85 c0                	test   %eax,%eax
  1040d6:	74 0c                	je     1040e4 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  1040d8:	89 04 24             	mov    %eax,(%esp)
  1040db:	e8 30 ce ff ff       	call   100f10 <filedup>
  1040e0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1040e4:	83 c3 01             	add    $0x1,%ebx
  1040e7:	83 fb 10             	cmp    $0x10,%ebx
  1040ea:	75 e4                	jne    1040d0 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1040ec:	8b 47 60             	mov    0x60(%edi),%eax
  1040ef:	89 04 24             	mov    %eax,(%esp)
  1040f2:	e8 29 d0 ff ff       	call   101120 <idup>
  1040f7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1040fa:	8d 46 64             	lea    0x64(%esi),%eax
  1040fd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104104:	00 
  104105:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10410c:	00 
  10410d:	89 04 24             	mov    %eax,(%esp)
  104110:	e8 9b 03 00 00       	call   1044b0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104115:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10411b:	c7 46 64 30 34 10 00 	movl   $0x103430,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104122:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104125:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10412c:	83 c4 1c             	add    $0x1c,%esp
  10412f:	89 f0                	mov    %esi,%eax
  104131:	5b                   	pop    %ebx
  104132:	5e                   	pop    %esi
  104133:	5f                   	pop    %edi
  104134:	5d                   	pop    %ebp
  104135:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104136:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10413d:	31 f6                	xor    %esi,%esi
    return 0;
  10413f:	eb eb                	jmp    10412c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104141:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104148:	00 
  104149:	8b 46 08             	mov    0x8(%esi),%eax
  10414c:	89 04 24             	mov    %eax,(%esp)
  10414f:	e8 4c e2 ff ff       	call   1023a0 <kfree>
      np->kstack = 0;
  104154:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10415b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104162:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104169:	31 f6                	xor    %esi,%esi
      return 0;
  10416b:	eb bf                	jmp    10412c <copyproc+0xfc>
  10416d:	8d 76 00             	lea    0x0(%esi),%esi

00104170 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104170:	55                   	push   %ebp
  104171:	89 e5                	mov    %esp,%ebp
  104173:	53                   	push   %ebx
  104174:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10417e:	e8 ad fe ff ff       	call   104030 <copyproc>
  p->sz = PAGE;
  104183:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10418a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10418c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104193:	e8 48 e1 ff ff       	call   1022e0 <kalloc>
  104198:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10419a:	c7 04 24 06 6b 10 00 	movl   $0x106b06,(%esp)
  1041a1:	e8 6a dd ff ff       	call   101f10 <namei>
  1041a6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  1041a9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1041b0:	00 
  1041b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1041b8:	00 
  1041b9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  1041bf:	89 04 24             	mov    %eax,(%esp)
  1041c2:	e8 e9 02 00 00       	call   1044b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1041c7:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1041cd:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  1041cf:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  1041d6:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1041d9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1041df:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  1041e5:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  1041eb:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  1041ee:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1041f2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1041f5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1041fb:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104202:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104209:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104210:	00 
  104211:	c7 44 24 04 28 84 10 	movl   $0x108428,0x4(%esp)
  104218:	00 
  104219:	8b 03                	mov    (%ebx),%eax
  10421b:	89 04 24             	mov    %eax,(%esp)
  10421e:	e8 1d 03 00 00       	call   104540 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104223:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104229:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104230:	00 
  104231:	c7 44 24 04 08 6b 10 	movl   $0x106b08,0x4(%esp)
  104238:	00 
  104239:	89 04 24             	mov    %eax,(%esp)
  10423c:	e8 0f 04 00 00       	call   104650 <safestrcpy>
  p->state = RUNNABLE;
  104241:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104248:	89 1d 68 85 10 00    	mov    %ebx,0x108568
}
  10424e:	83 c4 14             	add    $0x14,%esp
  104251:	5b                   	pop    %ebx
  104252:	5d                   	pop    %ebp
  104253:	c3                   	ret    
  104254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10425a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104260 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104260:	55                   	push   %ebp
  104261:	89 e5                	mov    %esp,%ebp
  104263:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104266:	c7 44 24 04 11 6b 10 	movl   $0x106b11,0x4(%esp)
  10426d:	00 
  10426e:	c7 04 24 60 e5 10 00 	movl   $0x10e560,(%esp)
  104275:	e8 06 00 00 00       	call   104280 <initlock>
}
  10427a:	c9                   	leave  
  10427b:	c3                   	ret    
  10427c:	90                   	nop
  10427d:	90                   	nop
  10427e:	90                   	nop
  10427f:	90                   	nop

00104280 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104280:	55                   	push   %ebp
  104281:	89 e5                	mov    %esp,%ebp
  104283:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104286:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10428f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104292:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104299:	5d                   	pop    %ebp
  10429a:	c3                   	ret    
  10429b:	90                   	nop
  10429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1042a0:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1042a1:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1042a3:	89 e5                	mov    %esp,%ebp
  1042a5:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1042a6:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1042a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  1042ac:	83 ea 08             	sub    $0x8,%edx
  1042af:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  1042b0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1042b3:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  1042b6:	77 18                	ja     1042d0 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  1042b8:	8b 4a 04             	mov    0x4(%edx),%ecx
  1042bb:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1042be:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1042c1:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1042c3:	83 f8 0a             	cmp    $0xa,%eax
  1042c6:	75 e8                	jne    1042b0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  1042c8:	5b                   	pop    %ebx
  1042c9:	5d                   	pop    %ebp
  1042ca:	c3                   	ret    
  1042cb:	90                   	nop
  1042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1042d0:	83 f8 09             	cmp    $0x9,%eax
  1042d3:	7f f3                	jg     1042c8 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1042d5:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  1042d8:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  1042db:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1042e1:	83 c2 04             	add    $0x4,%edx
  1042e4:	83 f8 0a             	cmp    $0xa,%eax
  1042e7:	75 ef                	jne    1042d8 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  1042e9:	5b                   	pop    %ebx
  1042ea:	5d                   	pop    %ebp
  1042eb:	c3                   	ret    
  1042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042f0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1042f0:	55                   	push   %ebp
  1042f1:	89 e5                	mov    %esp,%ebp
  1042f3:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1042f6:	9c                   	pushf  
  1042f7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1042f8:	f6 c4 02             	test   $0x2,%ah
  1042fb:	75 5f                	jne    10435c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1042fd:	e8 6e e5 ff ff       	call   102870 <cpu>
  104302:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104308:	05 e4 b7 10 00       	add    $0x10b7e4,%eax
  10430d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104313:	83 ea 01             	sub    $0x1,%edx
  104316:	85 d2                	test   %edx,%edx
  104318:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10431e:	78 30                	js     104350 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104320:	e8 4b e5 ff ff       	call   102870 <cpu>
  104325:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10432b:	8b 90 a4 b8 10 00    	mov    0x10b8a4(%eax),%edx
  104331:	85 d2                	test   %edx,%edx
  104333:	74 03                	je     104338 <popcli+0x48>
    sti();
}
  104335:	c9                   	leave  
  104336:	c3                   	ret    
  104337:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104338:	e8 33 e5 ff ff       	call   102870 <cpu>
  10433d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104343:	8b 80 a8 b8 10 00    	mov    0x10b8a8(%eax),%eax
  104349:	85 c0                	test   %eax,%eax
  10434b:	74 e8                	je     104335 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10434d:	fb                   	sti    
    sti();
}
  10434e:	c9                   	leave  
  10434f:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104350:	c7 04 24 77 6b 10 00 	movl   $0x106b77,(%esp)
  104357:	e8 84 c5 ff ff       	call   1008e0 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10435c:	c7 04 24 60 6b 10 00 	movl   $0x106b60,(%esp)
  104363:	e8 78 c5 ff ff       	call   1008e0 <panic>
  104368:	90                   	nop
  104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104370 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104370:	55                   	push   %ebp
  104371:	89 e5                	mov    %esp,%ebp
  104373:	53                   	push   %ebx
  104374:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104377:	9c                   	pushf  
  104378:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104379:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10437a:	e8 f1 e4 ff ff       	call   102870 <cpu>
  10437f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104385:	05 e4 b7 10 00       	add    $0x10b7e4,%eax
  10438a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104390:	8d 4a 01             	lea    0x1(%edx),%ecx
  104393:	85 d2                	test   %edx,%edx
  104395:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  10439b:	75 17                	jne    1043b4 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  10439d:	e8 ce e4 ff ff       	call   102870 <cpu>
  1043a2:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1043a8:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043ae:	89 98 a8 b8 10 00    	mov    %ebx,0x10b8a8(%eax)
}
  1043b4:	83 c4 04             	add    $0x4,%esp
  1043b7:	5b                   	pop    %ebx
  1043b8:	5d                   	pop    %ebp
  1043b9:	c3                   	ret    
  1043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001043c0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1043c0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  1043c1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1043c3:	89 e5                	mov    %esp,%ebp
  1043c5:	53                   	push   %ebx
  1043c6:	83 ec 04             	sub    $0x4,%esp
  1043c9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  1043cc:	8b 0a                	mov    (%edx),%ecx
  1043ce:	85 c9                	test   %ecx,%ecx
  1043d0:	75 06                	jne    1043d8 <holding+0x18>
}
  1043d2:	83 c4 04             	add    $0x4,%esp
  1043d5:	5b                   	pop    %ebx
  1043d6:	5d                   	pop    %ebp
  1043d7:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1043d8:	8b 5a 08             	mov    0x8(%edx),%ebx
  1043db:	e8 90 e4 ff ff       	call   102870 <cpu>
  1043e0:	83 c0 0a             	add    $0xa,%eax
  1043e3:	39 c3                	cmp    %eax,%ebx
  1043e5:	0f 94 c0             	sete   %al
}
  1043e8:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  1043eb:	0f b6 c0             	movzbl %al,%eax
}
  1043ee:	5b                   	pop    %ebx
  1043ef:	5d                   	pop    %ebp
  1043f0:	c3                   	ret    
  1043f1:	eb 0d                	jmp    104400 <release>
  1043f3:	90                   	nop
  1043f4:	90                   	nop
  1043f5:	90                   	nop
  1043f6:	90                   	nop
  1043f7:	90                   	nop
  1043f8:	90                   	nop
  1043f9:	90                   	nop
  1043fa:	90                   	nop
  1043fb:	90                   	nop
  1043fc:	90                   	nop
  1043fd:	90                   	nop
  1043fe:	90                   	nop
  1043ff:	90                   	nop

00104400 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  104400:	55                   	push   %ebp
  104401:	89 e5                	mov    %esp,%ebp
  104403:	53                   	push   %ebx
  104404:	83 ec 14             	sub    $0x14,%esp
  104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10440a:	89 1c 24             	mov    %ebx,(%esp)
  10440d:	e8 ae ff ff ff       	call   1043c0 <holding>
  104412:	85 c0                	test   %eax,%eax
  104414:	74 1d                	je     104433 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104416:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10441d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10441f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104426:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104429:	83 c4 14             	add    $0x14,%esp
  10442c:	5b                   	pop    %ebx
  10442d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10442e:	e9 bd fe ff ff       	jmp    1042f0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104433:	c7 04 24 7e 6b 10 00 	movl   $0x106b7e,(%esp)
  10443a:	e8 a1 c4 ff ff       	call   1008e0 <panic>
  10443f:	90                   	nop

00104440 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104440:	55                   	push   %ebp
  104441:	89 e5                	mov    %esp,%ebp
  104443:	53                   	push   %ebx
  104444:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104447:	e8 24 ff ff ff       	call   104370 <pushcli>
  if(holding(lock))
  10444c:	8b 45 08             	mov    0x8(%ebp),%eax
  10444f:	89 04 24             	mov    %eax,(%esp)
  104452:	e8 69 ff ff ff       	call   1043c0 <holding>
  104457:	85 c0                	test   %eax,%eax
  104459:	75 3d                	jne    104498 <acquire+0x58>
    panic("acquire");
  10445b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10445e:	ba 01 00 00 00       	mov    $0x1,%edx
  104463:	90                   	nop
  104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104468:	89 d0                	mov    %edx,%eax
  10446a:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10446d:	83 f8 01             	cmp    $0x1,%eax
  104470:	74 f6                	je     104468 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  104472:	e8 f9 e3 ff ff       	call   102870 <cpu>
  104477:	83 c0 0a             	add    $0xa,%eax
  10447a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  10447d:	8b 45 08             	mov    0x8(%ebp),%eax
  104480:	83 c0 0c             	add    $0xc,%eax
  104483:	89 44 24 04          	mov    %eax,0x4(%esp)
  104487:	8d 45 08             	lea    0x8(%ebp),%eax
  10448a:	89 04 24             	mov    %eax,(%esp)
  10448d:	e8 0e fe ff ff       	call   1042a0 <getcallerpcs>
}
  104492:	83 c4 14             	add    $0x14,%esp
  104495:	5b                   	pop    %ebx
  104496:	5d                   	pop    %ebp
  104497:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104498:	c7 04 24 86 6b 10 00 	movl   $0x106b86,(%esp)
  10449f:	e8 3c c4 ff ff       	call   1008e0 <panic>
  1044a4:	90                   	nop
  1044a5:	90                   	nop
  1044a6:	90                   	nop
  1044a7:	90                   	nop
  1044a8:	90                   	nop
  1044a9:	90                   	nop
  1044aa:	90                   	nop
  1044ab:	90                   	nop
  1044ac:	90                   	nop
  1044ad:	90                   	nop
  1044ae:	90                   	nop
  1044af:	90                   	nop

001044b0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  1044b0:	55                   	push   %ebp
  1044b1:	89 e5                	mov    %esp,%ebp
  1044b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1044b6:	53                   	push   %ebx
  1044b7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1044ba:	85 c9                	test   %ecx,%ecx
  1044bc:	74 14                	je     1044d2 <memset+0x22>
  1044be:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  1044c2:	31 d2                	xor    %edx,%edx
  1044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  1044c8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  1044cb:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1044ce:	39 ca                	cmp    %ecx,%edx
  1044d0:	75 f6                	jne    1044c8 <memset+0x18>
    *d++ = c;

  return dst;
}
  1044d2:	5b                   	pop    %ebx
  1044d3:	5d                   	pop    %ebp
  1044d4:	c3                   	ret    
  1044d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001044e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  1044e0:	55                   	push   %ebp
  1044e1:	89 e5                	mov    %esp,%ebp
  1044e3:	57                   	push   %edi
  1044e4:	56                   	push   %esi
  1044e5:	53                   	push   %ebx
  1044e6:	8b 55 10             	mov    0x10(%ebp),%edx
  1044e9:	8b 75 08             	mov    0x8(%ebp),%esi
  1044ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1044ef:	85 d2                	test   %edx,%edx
  1044f1:	74 2d                	je     104520 <memcmp+0x40>
    if(*s1 != *s2)
  1044f3:	0f b6 1e             	movzbl (%esi),%ebx
  1044f6:	0f b6 0f             	movzbl (%edi),%ecx
  1044f9:	38 cb                	cmp    %cl,%bl
  1044fb:	75 2b                	jne    104528 <memcmp+0x48>
      return *s1 - *s2;
  1044fd:	83 ea 01             	sub    $0x1,%edx
  104500:	31 c0                	xor    %eax,%eax
  104502:	eb 18                	jmp    10451c <memcmp+0x3c>
  104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104508:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  10450d:	83 ea 01             	sub    $0x1,%edx
  104510:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  104515:	83 c0 01             	add    $0x1,%eax
  104518:	38 cb                	cmp    %cl,%bl
  10451a:	75 0c                	jne    104528 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10451c:	85 d2                	test   %edx,%edx
  10451e:	75 e8                	jne    104508 <memcmp+0x28>
  104520:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104522:	5b                   	pop    %ebx
  104523:	5e                   	pop    %esi
  104524:	5f                   	pop    %edi
  104525:	5d                   	pop    %ebp
  104526:	c3                   	ret    
  104527:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104528:	0f b6 c3             	movzbl %bl,%eax
  10452b:	0f b6 c9             	movzbl %cl,%ecx
  10452e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104530:	5b                   	pop    %ebx
  104531:	5e                   	pop    %esi
  104532:	5f                   	pop    %edi
  104533:	5d                   	pop    %ebp
  104534:	c3                   	ret    
  104535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104540 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104540:	55                   	push   %ebp
  104541:	89 e5                	mov    %esp,%ebp
  104543:	57                   	push   %edi
  104544:	56                   	push   %esi
  104545:	53                   	push   %ebx
  104546:	8b 45 08             	mov    0x8(%ebp),%eax
  104549:	8b 75 0c             	mov    0xc(%ebp),%esi
  10454c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10454f:	39 c6                	cmp    %eax,%esi
  104551:	73 2d                	jae    104580 <memmove+0x40>
  104553:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104556:	39 f8                	cmp    %edi,%eax
  104558:	73 26                	jae    104580 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10455a:	85 db                	test   %ebx,%ebx
  10455c:	74 1d                	je     10457b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10455e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104561:	31 d2                	xor    %edx,%edx
  104563:	90                   	nop
  104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104568:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  10456d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104571:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104574:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104577:	85 c9                	test   %ecx,%ecx
  104579:	75 ed                	jne    104568 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10457b:	5b                   	pop    %ebx
  10457c:	5e                   	pop    %esi
  10457d:	5f                   	pop    %edi
  10457e:	5d                   	pop    %ebp
  10457f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104580:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104582:	85 db                	test   %ebx,%ebx
  104584:	74 f5                	je     10457b <memmove+0x3b>
  104586:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104588:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  10458c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  10458f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104592:	39 d3                	cmp    %edx,%ebx
  104594:	75 f2                	jne    104588 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104596:	5b                   	pop    %ebx
  104597:	5e                   	pop    %esi
  104598:	5f                   	pop    %edi
  104599:	5d                   	pop    %ebp
  10459a:	c3                   	ret    
  10459b:	90                   	nop
  10459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001045a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  1045a0:	55                   	push   %ebp
  1045a1:	89 e5                	mov    %esp,%ebp
  1045a3:	57                   	push   %edi
  1045a4:	56                   	push   %esi
  1045a5:	53                   	push   %ebx
  1045a6:	8b 7d 10             	mov    0x10(%ebp),%edi
  1045a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1045ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  1045af:	85 ff                	test   %edi,%edi
  1045b1:	74 3d                	je     1045f0 <strncmp+0x50>
  1045b3:	0f b6 01             	movzbl (%ecx),%eax
  1045b6:	84 c0                	test   %al,%al
  1045b8:	75 18                	jne    1045d2 <strncmp+0x32>
  1045ba:	eb 3c                	jmp    1045f8 <strncmp+0x58>
  1045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045c0:	83 ef 01             	sub    $0x1,%edi
  1045c3:	74 2b                	je     1045f0 <strncmp+0x50>
    n--, p++, q++;
  1045c5:	83 c1 01             	add    $0x1,%ecx
  1045c8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1045cb:	0f b6 01             	movzbl (%ecx),%eax
  1045ce:	84 c0                	test   %al,%al
  1045d0:	74 26                	je     1045f8 <strncmp+0x58>
  1045d2:	0f b6 33             	movzbl (%ebx),%esi
  1045d5:	89 f2                	mov    %esi,%edx
  1045d7:	38 d0                	cmp    %dl,%al
  1045d9:	74 e5                	je     1045c0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1045db:	81 e6 ff 00 00 00    	and    $0xff,%esi
  1045e1:	0f b6 c0             	movzbl %al,%eax
  1045e4:	29 f0                	sub    %esi,%eax
}
  1045e6:	5b                   	pop    %ebx
  1045e7:	5e                   	pop    %esi
  1045e8:	5f                   	pop    %edi
  1045e9:	5d                   	pop    %ebp
  1045ea:	c3                   	ret    
  1045eb:	90                   	nop
  1045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1045f0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1045f2:	5b                   	pop    %ebx
  1045f3:	5e                   	pop    %esi
  1045f4:	5f                   	pop    %edi
  1045f5:	5d                   	pop    %ebp
  1045f6:	c3                   	ret    
  1045f7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1045f8:	0f b6 33             	movzbl (%ebx),%esi
  1045fb:	eb de                	jmp    1045db <strncmp+0x3b>
  1045fd:	8d 76 00             	lea    0x0(%esi),%esi

00104600 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	8b 45 08             	mov    0x8(%ebp),%eax
  104606:	56                   	push   %esi
  104607:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10460a:	53                   	push   %ebx
  10460b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10460e:	89 c3                	mov    %eax,%ebx
  104610:	eb 09                	jmp    10461b <strncpy+0x1b>
  104612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104618:	83 c6 01             	add    $0x1,%esi
  10461b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10461e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104621:	85 d2                	test   %edx,%edx
  104623:	7e 0c                	jle    104631 <strncpy+0x31>
  104625:	0f b6 16             	movzbl (%esi),%edx
  104628:	88 13                	mov    %dl,(%ebx)
  10462a:	83 c3 01             	add    $0x1,%ebx
  10462d:	84 d2                	test   %dl,%dl
  10462f:	75 e7                	jne    104618 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104631:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104633:	85 c9                	test   %ecx,%ecx
  104635:	7e 0c                	jle    104643 <strncpy+0x43>
  104637:	90                   	nop
    *s++ = 0;
  104638:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10463c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10463f:	39 ca                	cmp    %ecx,%edx
  104641:	75 f5                	jne    104638 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104643:	5b                   	pop    %ebx
  104644:	5e                   	pop    %esi
  104645:	5d                   	pop    %ebp
  104646:	c3                   	ret    
  104647:	89 f6                	mov    %esi,%esi
  104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104650 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104650:	55                   	push   %ebp
  104651:	89 e5                	mov    %esp,%ebp
  104653:	8b 55 10             	mov    0x10(%ebp),%edx
  104656:	56                   	push   %esi
  104657:	8b 45 08             	mov    0x8(%ebp),%eax
  10465a:	53                   	push   %ebx
  10465b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10465e:	85 d2                	test   %edx,%edx
  104660:	7e 1f                	jle    104681 <safestrcpy+0x31>
  104662:	89 c1                	mov    %eax,%ecx
  104664:	eb 05                	jmp    10466b <safestrcpy+0x1b>
  104666:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104668:	83 c6 01             	add    $0x1,%esi
  10466b:	83 ea 01             	sub    $0x1,%edx
  10466e:	85 d2                	test   %edx,%edx
  104670:	7e 0c                	jle    10467e <safestrcpy+0x2e>
  104672:	0f b6 1e             	movzbl (%esi),%ebx
  104675:	88 19                	mov    %bl,(%ecx)
  104677:	83 c1 01             	add    $0x1,%ecx
  10467a:	84 db                	test   %bl,%bl
  10467c:	75 ea                	jne    104668 <safestrcpy+0x18>
    ;
  *s = 0;
  10467e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104681:	5b                   	pop    %ebx
  104682:	5e                   	pop    %esi
  104683:	5d                   	pop    %ebp
  104684:	c3                   	ret    
  104685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104690 <strlen>:

int
strlen(const char *s)
{
  104690:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104691:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104693:	89 e5                	mov    %esp,%ebp
  104695:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104698:	80 3a 00             	cmpb   $0x0,(%edx)
  10469b:	74 0c                	je     1046a9 <strlen+0x19>
  10469d:	8d 76 00             	lea    0x0(%esi),%esi
  1046a0:	83 c0 01             	add    $0x1,%eax
  1046a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1046a7:	75 f7                	jne    1046a0 <strlen+0x10>
    ;
  return n;
}
  1046a9:	5d                   	pop    %ebp
  1046aa:	c3                   	ret    
  1046ab:	90                   	nop

001046ac <swtch>:
  1046ac:	8b 44 24 04          	mov    0x4(%esp),%eax
  1046b0:	8f 00                	popl   (%eax)
  1046b2:	89 60 04             	mov    %esp,0x4(%eax)
  1046b5:	89 58 08             	mov    %ebx,0x8(%eax)
  1046b8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1046bb:	89 50 10             	mov    %edx,0x10(%eax)
  1046be:	89 70 14             	mov    %esi,0x14(%eax)
  1046c1:	89 78 18             	mov    %edi,0x18(%eax)
  1046c4:	89 68 1c             	mov    %ebp,0x1c(%eax)
  1046c7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1046cb:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1046ce:	8b 78 18             	mov    0x18(%eax),%edi
  1046d1:	8b 70 14             	mov    0x14(%eax),%esi
  1046d4:	8b 50 10             	mov    0x10(%eax),%edx
  1046d7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1046da:	8b 58 08             	mov    0x8(%eax),%ebx
  1046dd:	8b 60 04             	mov    0x4(%eax),%esp
  1046e0:	ff 30                	pushl  (%eax)
  1046e2:	c3                   	ret    
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

001046f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1046f0:	55                   	push   %ebp
  1046f1:	89 e5                	mov    %esp,%ebp
  1046f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1046f6:	53                   	push   %ebx
  1046f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  1046fa:	8b 51 04             	mov    0x4(%ecx),%edx
  1046fd:	39 c2                	cmp    %eax,%edx
  1046ff:	77 0f                	ja     104710 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104706:	5b                   	pop    %ebx
  104707:	5d                   	pop    %ebp
  104708:	c3                   	ret    
  104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104710:	8d 58 04             	lea    0x4(%eax),%ebx
  104713:	39 da                	cmp    %ebx,%edx
  104715:	72 ea                	jb     104701 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104717:	8b 11                	mov    (%ecx),%edx
  104719:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10471c:	8b 45 10             	mov    0x10(%ebp),%eax
  10471f:	89 10                	mov    %edx,(%eax)
  104721:	31 c0                	xor    %eax,%eax
  return 0;
  104723:	eb e1                	jmp    104706 <fetchint+0x16>
  104725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104730 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104730:	55                   	push   %ebp
  104731:	89 e5                	mov    %esp,%ebp
  104733:	8b 45 08             	mov    0x8(%ebp),%eax
  104736:	8b 55 0c             	mov    0xc(%ebp),%edx
  104739:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10473a:	39 50 04             	cmp    %edx,0x4(%eax)
  10473d:	77 09                	ja     104748 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10473f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104744:	5b                   	pop    %ebx
  104745:	5d                   	pop    %ebp
  104746:	c3                   	ret    
  104747:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10474b:	03 10                	add    (%eax),%edx
  10474d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  10474f:	8b 18                	mov    (%eax),%ebx
  104751:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104754:	39 da                	cmp    %ebx,%edx
  104756:	73 e7                	jae    10473f <fetchstr+0xf>
    if(*s == 0)
  104758:	31 c0                	xor    %eax,%eax
  10475a:	89 d1                	mov    %edx,%ecx
  10475c:	80 3a 00             	cmpb   $0x0,(%edx)
  10475f:	74 e3                	je     104744 <fetchstr+0x14>
  104761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104768:	83 c1 01             	add    $0x1,%ecx
  10476b:	39 cb                	cmp    %ecx,%ebx
  10476d:	76 d0                	jbe    10473f <fetchstr+0xf>
    if(*s == 0)
  10476f:	80 39 00             	cmpb   $0x0,(%ecx)
  104772:	75 f4                	jne    104768 <fetchstr+0x38>
  104774:	89 c8                	mov    %ecx,%eax
  104776:	29 d0                	sub    %edx,%eax
  104778:	eb ca                	jmp    104744 <fetchstr+0x14>
  10477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104780 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104780:	55                   	push   %ebp
  104781:	89 e5                	mov    %esp,%ebp
  104783:	53                   	push   %ebx
  104784:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104787:	e8 74 ec ff ff       	call   103400 <curproc>
  10478c:	8b 55 08             	mov    0x8(%ebp),%edx
  10478f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104795:	8b 40 3c             	mov    0x3c(%eax),%eax
  104798:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  10479c:	e8 5f ec ff ff       	call   103400 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047a1:	8b 50 04             	mov    0x4(%eax),%edx
  1047a4:	39 d3                	cmp    %edx,%ebx
  1047a6:	72 10                	jb     1047b8 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  1047ad:	83 c4 04             	add    $0x4,%esp
  1047b0:	5b                   	pop    %ebx
  1047b1:	5d                   	pop    %ebp
  1047b2:	c3                   	ret    
  1047b3:	90                   	nop
  1047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047b8:	8d 4b 04             	lea    0x4(%ebx),%ecx
  1047bb:	39 ca                	cmp    %ecx,%edx
  1047bd:	72 e9                	jb     1047a8 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047bf:	8b 00                	mov    (%eax),%eax
  1047c1:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  1047c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047c7:	89 10                	mov    %edx,(%eax)
  1047c9:	31 c0                	xor    %eax,%eax
  1047cb:	eb e0                	jmp    1047ad <argint+0x2d>
  1047cd:	8d 76 00             	lea    0x0(%esi),%esi

001047d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  1047d0:	55                   	push   %ebp
  1047d1:	89 e5                	mov    %esp,%ebp
  1047d3:	53                   	push   %ebx
  1047d4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  1047d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1047da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047de:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e1:	89 04 24             	mov    %eax,(%esp)
  1047e4:	e8 97 ff ff ff       	call   104780 <argint>
  1047e9:	85 c0                	test   %eax,%eax
  1047eb:	78 3b                	js     104828 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  1047ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1047f0:	e8 0b ec ff ff       	call   103400 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  1047f5:	3b 58 04             	cmp    0x4(%eax),%ebx
  1047f8:	73 2e                	jae    104828 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  1047fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047fd:	03 18                	add    (%eax),%ebx
  1047ff:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104801:	8b 08                	mov    (%eax),%ecx
  104803:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104806:	39 cb                	cmp    %ecx,%ebx
  104808:	73 1e                	jae    104828 <argstr+0x58>
    if(*s == 0)
  10480a:	31 c0                	xor    %eax,%eax
  10480c:	89 da                	mov    %ebx,%edx
  10480e:	80 3b 00             	cmpb   $0x0,(%ebx)
  104811:	75 0a                	jne    10481d <argstr+0x4d>
  104813:	eb 18                	jmp    10482d <argstr+0x5d>
  104815:	8d 76 00             	lea    0x0(%esi),%esi
  104818:	80 3a 00             	cmpb   $0x0,(%edx)
  10481b:	74 1b                	je     104838 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10481d:	83 c2 01             	add    $0x1,%edx
  104820:	39 d1                	cmp    %edx,%ecx
  104822:	77 f4                	ja     104818 <argstr+0x48>
  104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10482d:	83 c4 24             	add    $0x24,%esp
  104830:	5b                   	pop    %ebx
  104831:	5d                   	pop    %ebp
  104832:	c3                   	ret    
  104833:	90                   	nop
  104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104838:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10483a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10483d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10483f:	5b                   	pop    %ebx
  104840:	5d                   	pop    %ebp
  104841:	c3                   	ret    
  104842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104850 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104850:	55                   	push   %ebp
  104851:	89 e5                	mov    %esp,%ebp
  104853:	53                   	push   %ebx
  104854:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104857:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10485a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10485e:	8b 45 08             	mov    0x8(%ebp),%eax
  104861:	89 04 24             	mov    %eax,(%esp)
  104864:	e8 17 ff ff ff       	call   104780 <argint>
  104869:	85 c0                	test   %eax,%eax
  10486b:	79 0b                	jns    104878 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  10486d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104872:	83 c4 24             	add    $0x24,%esp
  104875:	5b                   	pop    %ebx
  104876:	5d                   	pop    %ebp
  104877:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104878:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10487b:	e8 80 eb ff ff       	call   103400 <curproc>
  104880:	3b 58 04             	cmp    0x4(%eax),%ebx
  104883:	73 e8                	jae    10486d <argptr+0x1d>
  104885:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104888:	03 5d f4             	add    -0xc(%ebp),%ebx
  10488b:	e8 70 eb ff ff       	call   103400 <curproc>
  104890:	3b 58 04             	cmp    0x4(%eax),%ebx
  104893:	73 d8                	jae    10486d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104895:	e8 66 eb ff ff       	call   103400 <curproc>
  10489a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10489d:	8b 00                	mov    (%eax),%eax
  10489f:	03 45 f4             	add    -0xc(%ebp),%eax
  1048a2:	89 02                	mov    %eax,(%edx)
  1048a4:	31 c0                	xor    %eax,%eax
  return 0;
  1048a6:	eb ca                	jmp    104872 <argptr+0x22>
  1048a8:	90                   	nop
  1048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001048b0 <syscall>:
[SYS_wake_lock]		sys_wake_lock,
};

void
syscall(void)
{
  1048b0:	55                   	push   %ebp
  1048b1:	89 e5                	mov    %esp,%ebp
  1048b3:	83 ec 18             	sub    $0x18,%esp
  1048b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1048b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1048bc:	e8 3f eb ff ff       	call   103400 <curproc>
  1048c1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1048c7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  1048ca:	83 fb 1a             	cmp    $0x1a,%ebx
  1048cd:	77 29                	ja     1048f8 <syscall+0x48>
  1048cf:	8b 34 9d c0 6b 10 00 	mov    0x106bc0(,%ebx,4),%esi
  1048d6:	85 f6                	test   %esi,%esi
  1048d8:	74 1e                	je     1048f8 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  1048da:	e8 21 eb ff ff       	call   103400 <curproc>
  1048df:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  1048e5:	ff d6                	call   *%esi
  1048e7:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  1048ea:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1048ed:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1048f0:	89 ec                	mov    %ebp,%esp
  1048f2:	5d                   	pop    %ebp
  1048f3:	c3                   	ret    
  1048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  1048f8:	e8 03 eb ff ff       	call   103400 <curproc>
  1048fd:	89 c6                	mov    %eax,%esi
  1048ff:	e8 fc ea ff ff       	call   103400 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104904:	81 c6 88 00 00 00    	add    $0x88,%esi
  10490a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10490e:	89 74 24 08          	mov    %esi,0x8(%esp)
  104912:	8b 40 10             	mov    0x10(%eax),%eax
  104915:	c7 04 24 8e 6b 10 00 	movl   $0x106b8e,(%esp)
  10491c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104920:	e8 1b be ff ff       	call   100740 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104925:	e8 d6 ea ff ff       	call   103400 <curproc>
  10492a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104930:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104937:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10493a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10493d:	89 ec                	mov    %ebp,%esp
  10493f:	5d                   	pop    %ebp
  104940:	c3                   	ret    
  104941:	90                   	nop
  104942:	90                   	nop
  104943:	90                   	nop
  104944:	90                   	nop
  104945:	90                   	nop
  104946:	90                   	nop
  104947:	90                   	nop
  104948:	90                   	nop
  104949:	90                   	nop
  10494a:	90                   	nop
  10494b:	90                   	nop
  10494c:	90                   	nop
  10494d:	90                   	nop
  10494e:	90                   	nop
  10494f:	90                   	nop

00104950 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104950:	55                   	push   %ebp
  104951:	89 e5                	mov    %esp,%ebp
  104953:	57                   	push   %edi
  104954:	89 c7                	mov    %eax,%edi
  104956:	56                   	push   %esi
  104957:	53                   	push   %ebx
  104958:	31 db                	xor    %ebx,%ebx
  10495a:	83 ec 0c             	sub    $0xc,%esp
  10495d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104960:	e8 9b ea ff ff       	call   103400 <curproc>
  104965:	8d 73 08             	lea    0x8(%ebx),%esi
  104968:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  10496b:	85 c0                	test   %eax,%eax
  10496d:	74 19                	je     104988 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  10496f:	83 c3 01             	add    $0x1,%ebx
  104972:	83 fb 10             	cmp    $0x10,%ebx
  104975:	75 e9                	jne    104960 <fdalloc+0x10>
  104977:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  10497c:	83 c4 0c             	add    $0xc,%esp
  10497f:	89 d8                	mov    %ebx,%eax
  104981:	5b                   	pop    %ebx
  104982:	5e                   	pop    %esi
  104983:	5f                   	pop    %edi
  104984:	5d                   	pop    %ebp
  104985:	c3                   	ret    
  104986:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104988:	e8 73 ea ff ff       	call   103400 <curproc>
  10498d:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  104990:	83 c4 0c             	add    $0xc,%esp
  104993:	89 d8                	mov    %ebx,%eax
  104995:	5b                   	pop    %ebx
  104996:	5e                   	pop    %esi
  104997:	5f                   	pop    %edi
  104998:	5d                   	pop    %ebp
  104999:	c3                   	ret    
  10499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001049a0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  1049a0:	55                   	push   %ebp
  1049a1:	89 e5                	mov    %esp,%ebp
  1049a3:	53                   	push   %ebx
  1049a4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  1049a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1049aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1049b1:	00 
  1049b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1049bd:	e8 8e fe ff ff       	call   104850 <argptr>
  1049c2:	85 c0                	test   %eax,%eax
  1049c4:	79 12                	jns    1049d8 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  1049c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1049cb:	83 c4 24             	add    $0x24,%esp
  1049ce:	5b                   	pop    %ebx
  1049cf:	5d                   	pop    %ebp
  1049d0:	c3                   	ret    
  1049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1049d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1049db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1049e2:	89 04 24             	mov    %eax,(%esp)
  1049e5:	e8 66 e6 ff ff       	call   103050 <pipealloc>
  1049ea:	85 c0                	test   %eax,%eax
  1049ec:	78 d8                	js     1049c6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1049ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049f1:	e8 5a ff ff ff       	call   104950 <fdalloc>
  1049f6:	85 c0                	test   %eax,%eax
  1049f8:	89 c3                	mov    %eax,%ebx
  1049fa:	78 25                	js     104a21 <sys_pipe+0x81>
  1049fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ff:	e8 4c ff ff ff       	call   104950 <fdalloc>
  104a04:	85 c0                	test   %eax,%eax
  104a06:	78 0c                	js     104a14 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  104a0b:	89 42 04             	mov    %eax,0x4(%edx)
  104a0e:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104a10:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104a12:	eb b7                	jmp    1049cb <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104a14:	e8 e7 e9 ff ff       	call   103400 <curproc>
  104a19:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104a20:	00 
    fileclose(rf);
  104a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a24:	89 04 24             	mov    %eax,(%esp)
  104a27:	e8 c4 c5 ff ff       	call   100ff0 <fileclose>
    fileclose(wf);
  104a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a2f:	89 04 24             	mov    %eax,(%esp)
  104a32:	e8 b9 c5 ff ff       	call   100ff0 <fileclose>
  104a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104a3c:	eb 8d                	jmp    1049cb <sys_pipe+0x2b>
  104a3e:	66 90                	xchg   %ax,%ax

00104a40 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104a40:	55                   	push   %ebp
  104a41:	89 e5                	mov    %esp,%ebp
  104a43:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104a49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104a4c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104a4f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104a52:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a60:	e8 6b fd ff ff       	call   1047d0 <argstr>
  104a65:	85 c0                	test   %eax,%eax
  104a67:	79 17                	jns    104a80 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104a6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104a71:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104a74:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104a77:	89 ec                	mov    %ebp,%esp
  104a79:	5d                   	pop    %ebp
  104a7a:	c3                   	ret    
  104a7b:	90                   	nop
  104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104a80:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a8e:	e8 ed fc ff ff       	call   104780 <argint>
  104a93:	85 c0                	test   %eax,%eax
  104a95:	78 d2                	js     104a69 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  104a97:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104a9a:	31 ff                	xor    %edi,%edi
  104a9c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104aa3:	00 
  104aa4:	31 db                	xor    %ebx,%ebx
  104aa6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104aad:	00 
  104aae:	89 04 24             	mov    %eax,(%esp)
  104ab1:	e8 fa f9 ff ff       	call   1044b0 <memset>
  104ab6:	eb 27                	jmp    104adf <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104ab8:	e8 43 e9 ff ff       	call   103400 <curproc>
  104abd:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104ac5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104ac9:	89 04 24             	mov    %eax,(%esp)
  104acc:	e8 5f fc ff ff       	call   104730 <fetchstr>
  104ad1:	85 c0                	test   %eax,%eax
  104ad3:	78 94                	js     104a69 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104ad5:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104ad8:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104adb:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  104add:	74 8a                	je     104a69 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104adf:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104ae6:	03 75 e0             	add    -0x20(%ebp),%esi
  104ae9:	e8 12 e9 ff ff       	call   103400 <curproc>
  104aee:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104af1:	89 54 24 08          	mov    %edx,0x8(%esp)
  104af5:	89 74 24 04          	mov    %esi,0x4(%esp)
  104af9:	89 04 24             	mov    %eax,(%esp)
  104afc:	e8 ef fb ff ff       	call   1046f0 <fetchint>
  104b01:	85 c0                	test   %eax,%eax
  104b03:	0f 88 60 ff ff ff    	js     104a69 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104b09:	8b 75 dc             	mov    -0x24(%ebp),%esi
  104b0c:	85 f6                	test   %esi,%esi
  104b0e:	75 a8                	jne    104ab8 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104b10:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104b1a:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104b21:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104b22:	89 04 24             	mov    %eax,(%esp)
  104b25:	e8 36 be ff ff       	call   100960 <exec>
  104b2a:	e9 3f ff ff ff       	jmp    104a6e <sys_exec+0x2e>
  104b2f:	90                   	nop

00104b30 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	53                   	push   %ebx
  104b34:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104b37:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b45:	e8 86 fc ff ff       	call   1047d0 <argstr>
  104b4a:	85 c0                	test   %eax,%eax
  104b4c:	79 12                	jns    104b60 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104b4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b53:	83 c4 24             	add    $0x24,%esp
  104b56:	5b                   	pop    %ebx
  104b57:	5d                   	pop    %ebp
  104b58:	c3                   	ret    
  104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b63:	89 04 24             	mov    %eax,(%esp)
  104b66:	e8 a5 d3 ff ff       	call   101f10 <namei>
  104b6b:	85 c0                	test   %eax,%eax
  104b6d:	89 c3                	mov    %eax,%ebx
  104b6f:	74 dd                	je     104b4e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104b71:	89 04 24             	mov    %eax,(%esp)
  104b74:	e8 d7 d0 ff ff       	call   101c50 <ilock>
  if(ip->type != T_DIR){
  104b79:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104b7e:	75 24                	jne    104ba4 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104b80:	89 1c 24             	mov    %ebx,(%esp)
  104b83:	e8 58 d0 ff ff       	call   101be0 <iunlock>
  iput(cp->cwd);
  104b88:	e8 73 e8 ff ff       	call   103400 <curproc>
  104b8d:	8b 40 60             	mov    0x60(%eax),%eax
  104b90:	89 04 24             	mov    %eax,(%esp)
  104b93:	e8 08 ce ff ff       	call   1019a0 <iput>
  cp->cwd = ip;
  104b98:	e8 63 e8 ff ff       	call   103400 <curproc>
  104b9d:	89 58 60             	mov    %ebx,0x60(%eax)
  104ba0:	31 c0                	xor    %eax,%eax
  return 0;
  104ba2:	eb af                	jmp    104b53 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104ba4:	89 1c 24             	mov    %ebx,(%esp)
  104ba7:	e8 84 d0 ff ff       	call   101c30 <iunlockput>
  104bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104bb1:	eb a0                	jmp    104b53 <sys_chdir+0x23>
  104bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104bc0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104bc0:	55                   	push   %ebp
  104bc1:	89 e5                	mov    %esp,%ebp
  104bc3:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104bc6:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104bc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104bcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104bcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104bdd:	e8 ee fb ff ff       	call   1047d0 <argstr>
  104be2:	85 c0                	test   %eax,%eax
  104be4:	79 12                	jns    104bf8 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104beb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104bee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104bf1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104bf4:	89 ec                	mov    %ebp,%esp
  104bf6:	5d                   	pop    %ebp
  104bf7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104bf8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c06:	e8 c5 fb ff ff       	call   1047d0 <argstr>
  104c0b:	85 c0                	test   %eax,%eax
  104c0d:	78 d7                	js     104be6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c12:	89 04 24             	mov    %eax,(%esp)
  104c15:	e8 f6 d2 ff ff       	call   101f10 <namei>
  104c1a:	85 c0                	test   %eax,%eax
  104c1c:	89 c3                	mov    %eax,%ebx
  104c1e:	74 c6                	je     104be6 <sys_link+0x26>
    return -1;
  ilock(ip);
  104c20:	89 04 24             	mov    %eax,(%esp)
  104c23:	e8 28 d0 ff ff       	call   101c50 <ilock>
  if(ip->type == T_DIR){
  104c28:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104c2d:	0f 84 86 00 00 00    	je     104cb9 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104c33:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104c38:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104c3b:	89 1c 24             	mov    %ebx,(%esp)
  104c3e:	e8 dd c8 ff ff       	call   101520 <iupdate>
  iunlock(ip);
  104c43:	89 1c 24             	mov    %ebx,(%esp)
  104c46:	e8 95 cf ff ff       	call   101be0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104c4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104c52:	89 04 24             	mov    %eax,(%esp)
  104c55:	e8 96 d2 ff ff       	call   101ef0 <nameiparent>
  104c5a:	85 c0                	test   %eax,%eax
  104c5c:	89 c6                	mov    %eax,%esi
  104c5e:	74 44                	je     104ca4 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  104c60:	89 04 24             	mov    %eax,(%esp)
  104c63:	e8 e8 cf ff ff       	call   101c50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104c68:	8b 06                	mov    (%esi),%eax
  104c6a:	3b 03                	cmp    (%ebx),%eax
  104c6c:	75 2e                	jne    104c9c <sys_link+0xdc>
  104c6e:	8b 43 04             	mov    0x4(%ebx),%eax
  104c71:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104c75:	89 34 24             	mov    %esi,(%esp)
  104c78:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c7c:	e8 6f ce ff ff       	call   101af0 <dirlink>
  104c81:	85 c0                	test   %eax,%eax
  104c83:	78 17                	js     104c9c <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  104c85:	89 34 24             	mov    %esi,(%esp)
  104c88:	e8 a3 cf ff ff       	call   101c30 <iunlockput>
  iput(ip);
  104c8d:	89 1c 24             	mov    %ebx,(%esp)
  104c90:	e8 0b cd ff ff       	call   1019a0 <iput>
  104c95:	31 c0                	xor    %eax,%eax
  return 0;
  104c97:	e9 4f ff ff ff       	jmp    104beb <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  104c9c:	89 34 24             	mov    %esi,(%esp)
  104c9f:	e8 8c cf ff ff       	call   101c30 <iunlockput>
  ilock(ip);
  104ca4:	89 1c 24             	mov    %ebx,(%esp)
  104ca7:	e8 a4 cf ff ff       	call   101c50 <ilock>
  ip->nlink--;
  104cac:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104cb1:	89 1c 24             	mov    %ebx,(%esp)
  104cb4:	e8 67 c8 ff ff       	call   101520 <iupdate>
  iunlockput(ip);
  104cb9:	89 1c 24             	mov    %ebx,(%esp)
  104cbc:	e8 6f cf ff ff       	call   101c30 <iunlockput>
  104cc1:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104cc4:	e9 22 ff ff ff       	jmp    104beb <sys_link+0x2b>
  104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104cd0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104cd0:	55                   	push   %ebp
  104cd1:	89 e5                	mov    %esp,%ebp
  104cd3:	57                   	push   %edi
  104cd4:	89 cf                	mov    %ecx,%edi
  104cd6:	56                   	push   %esi
  104cd7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104cd8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104cda:	83 ec 4c             	sub    $0x4c,%esp
  104cdd:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104ce0:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104ce4:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104ce7:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  104ceb:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104cef:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104cf3:	89 74 24 04          	mov    %esi,0x4(%esp)
  104cf7:	89 04 24             	mov    %eax,(%esp)
  104cfa:	e8 f1 d1 ff ff       	call   101ef0 <nameiparent>
  104cff:	85 c0                	test   %eax,%eax
  104d01:	74 67                	je     104d6a <create+0x9a>
    return 0;
  ilock(dp);
  104d03:	89 04 24             	mov    %eax,(%esp)
  104d06:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104d09:	e8 42 cf ff ff       	call   101c50 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104d0e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104d11:	85 d2                	test   %edx,%edx
  104d13:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d16:	74 60                	je     104d78 <create+0xa8>
  104d18:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104d1b:	89 14 24             	mov    %edx,(%esp)
  104d1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d22:	89 74 24 04          	mov    %esi,0x4(%esp)
  104d26:	e8 e5 c9 ff ff       	call   101710 <dirlookup>
  104d2b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d2e:	85 c0                	test   %eax,%eax
  104d30:	89 c3                	mov    %eax,%ebx
  104d32:	74 44                	je     104d78 <create+0xa8>
    iunlockput(dp);
  104d34:	89 14 24             	mov    %edx,(%esp)
  104d37:	e8 f4 ce ff ff       	call   101c30 <iunlockput>
    ilock(ip);
  104d3c:	89 1c 24             	mov    %ebx,(%esp)
  104d3f:	e8 0c cf ff ff       	call   101c50 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104d44:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  104d48:	0f 85 02 01 00 00    	jne    104e50 <create+0x180>
  104d4e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  104d52:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104d56:	0f 85 f4 00 00 00    	jne    104e50 <create+0x180>
  104d5c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  104d60:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104d64:	0f 85 e6 00 00 00    	jne    104e50 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104d6a:	83 c4 4c             	add    $0x4c,%esp
  104d6d:	89 d8                	mov    %ebx,%eax
  104d6f:	5b                   	pop    %ebx
  104d70:	5e                   	pop    %esi
  104d71:	5f                   	pop    %edi
  104d72:	5d                   	pop    %ebp
  104d73:	c3                   	ret    
  104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104d78:	0f bf c7             	movswl %di,%eax
  104d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d7f:	8b 02                	mov    (%edx),%eax
  104d81:	89 04 24             	mov    %eax,(%esp)
  104d84:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104d87:	e8 84 ca ff ff       	call   101810 <ialloc>
  104d8c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d8f:	85 c0                	test   %eax,%eax
  104d91:	89 c3                	mov    %eax,%ebx
  104d93:	74 50                	je     104de5 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104d95:	89 04 24             	mov    %eax,(%esp)
  104d98:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104d9b:	e8 b0 ce ff ff       	call   101c50 <ilock>
  ip->major = major;
  104da0:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  104da4:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104daa:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104dae:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  104db2:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104db6:	89 1c 24             	mov    %ebx,(%esp)
  104db9:	e8 62 c7 ff ff       	call   101520 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104dbe:	8b 43 04             	mov    0x4(%ebx),%eax
  104dc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  104dc5:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dc9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104dcc:	89 14 24             	mov    %edx,(%esp)
  104dcf:	e8 1c cd ff ff       	call   101af0 <dirlink>
  104dd4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104dd7:	85 c0                	test   %eax,%eax
  104dd9:	0f 88 85 00 00 00    	js     104e64 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104ddf:	66 83 ff 01          	cmp    $0x1,%di
  104de3:	74 13                	je     104df8 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104de5:	89 14 24             	mov    %edx,(%esp)
  104de8:	e8 43 ce ff ff       	call   101c30 <iunlockput>
  return ip;
}
  104ded:	83 c4 4c             	add    $0x4c,%esp
  104df0:	89 d8                	mov    %ebx,%eax
  104df2:	5b                   	pop    %ebx
  104df3:	5e                   	pop    %esi
  104df4:	5f                   	pop    %edi
  104df5:	5d                   	pop    %ebp
  104df6:	c3                   	ret    
  104df7:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104df8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  104dfd:	89 14 24             	mov    %edx,(%esp)
  104e00:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104e03:	e8 18 c7 ff ff       	call   101520 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104e08:	8b 43 04             	mov    0x4(%ebx),%eax
  104e0b:	c7 44 24 04 2d 6c 10 	movl   $0x106c2d,0x4(%esp)
  104e12:	00 
  104e13:	89 1c 24             	mov    %ebx,(%esp)
  104e16:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e1a:	e8 d1 cc ff ff       	call   101af0 <dirlink>
  104e1f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e22:	85 c0                	test   %eax,%eax
  104e24:	78 1e                	js     104e44 <create+0x174>
  104e26:	8b 42 04             	mov    0x4(%edx),%eax
  104e29:	c7 44 24 04 2c 6c 10 	movl   $0x106c2c,0x4(%esp)
  104e30:	00 
  104e31:	89 1c 24             	mov    %ebx,(%esp)
  104e34:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e38:	e8 b3 cc ff ff       	call   101af0 <dirlink>
  104e3d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e40:	85 c0                	test   %eax,%eax
  104e42:	79 a1                	jns    104de5 <create+0x115>
      panic("create dots");
  104e44:	c7 04 24 2f 6c 10 00 	movl   $0x106c2f,(%esp)
  104e4b:	e8 90 ba ff ff       	call   1008e0 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  104e50:	89 1c 24             	mov    %ebx,(%esp)
  104e53:	31 db                	xor    %ebx,%ebx
  104e55:	e8 d6 cd ff ff       	call   101c30 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104e5a:	83 c4 4c             	add    $0x4c,%esp
  104e5d:	89 d8                	mov    %ebx,%eax
  104e5f:	5b                   	pop    %ebx
  104e60:	5e                   	pop    %esi
  104e61:	5f                   	pop    %edi
  104e62:	5d                   	pop    %ebp
  104e63:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104e64:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104e6a:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  104e6d:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  104e6f:	e8 bc cd ff ff       	call   101c30 <iunlockput>
    iunlockput(dp);
  104e74:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e77:	89 14 24             	mov    %edx,(%esp)
  104e7a:	e8 b1 cd ff ff       	call   101c30 <iunlockput>
    return 0;
  104e7f:	e9 e6 fe ff ff       	jmp    104d6a <create+0x9a>
  104e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104e90 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104e90:	55                   	push   %ebp
  104e91:	89 e5                	mov    %esp,%ebp
  104e93:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104e96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104e99:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ea4:	e8 27 f9 ff ff       	call   1047d0 <argstr>
  104ea9:	85 c0                	test   %eax,%eax
  104eab:	79 0b                	jns    104eb8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  104ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104eb2:	c9                   	leave  
  104eb3:	c3                   	ret    
  104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104eb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ebf:	00 
  104ec0:	31 d2                	xor    %edx,%edx
  104ec2:	b9 01 00 00 00       	mov    $0x1,%ecx
  104ec7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed1:	e8 fa fd ff ff       	call   104cd0 <create>
  104ed6:	85 c0                	test   %eax,%eax
  104ed8:	74 d3                	je     104ead <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104eda:	89 04 24             	mov    %eax,(%esp)
  104edd:	e8 4e cd ff ff       	call   101c30 <iunlockput>
  104ee2:	31 c0                	xor    %eax,%eax
  return 0;
}
  104ee4:	c9                   	leave  
  104ee5:	c3                   	ret    
  104ee6:	8d 76 00             	lea    0x0(%esi),%esi
  104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104ef0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  104ef0:	55                   	push   %ebp
  104ef1:	89 e5                	mov    %esp,%ebp
  104ef3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104efd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f04:	e8 c7 f8 ff ff       	call   1047d0 <argstr>
  104f09:	85 c0                	test   %eax,%eax
  104f0b:	79 0b                	jns    104f18 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  104f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104f12:	c9                   	leave  
  104f13:	c3                   	ret    
  104f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  104f18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f26:	e8 55 f8 ff ff       	call   104780 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104f2b:	85 c0                	test   %eax,%eax
  104f2d:	78 de                	js     104f0d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  104f2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f36:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104f3d:	e8 3e f8 ff ff       	call   104780 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104f42:	85 c0                	test   %eax,%eax
  104f44:	78 c7                	js     104f0d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  104f46:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  104f4a:	31 d2                	xor    %edx,%edx
  104f4c:	b9 03 00 00 00       	mov    $0x3,%ecx
  104f51:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f55:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  104f59:	89 04 24             	mov    %eax,(%esp)
  104f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f5f:	e8 6c fd ff ff       	call   104cd0 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104f64:	85 c0                	test   %eax,%eax
  104f66:	74 a5                	je     104f0d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104f68:	89 04 24             	mov    %eax,(%esp)
  104f6b:	e8 c0 cc ff ff       	call   101c30 <iunlockput>
  104f70:	31 c0                	xor    %eax,%eax
  return 0;
}
  104f72:	c9                   	leave  
  104f73:	c3                   	ret    
  104f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104f80 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104f80:	55                   	push   %ebp
  104f81:	89 e5                	mov    %esp,%ebp
  104f83:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104f89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104f8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f9a:	e8 31 f8 ff ff       	call   1047d0 <argstr>
  104f9f:	85 c0                	test   %eax,%eax
  104fa1:	79 15                	jns    104fb8 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  104fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104fa8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104fab:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104fae:	89 ec                	mov    %ebp,%esp
  104fb0:	5d                   	pop    %ebp
  104fb1:	c3                   	ret    
  104fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104fb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fc6:	e8 b5 f7 ff ff       	call   104780 <argint>
  104fcb:	85 c0                	test   %eax,%eax
  104fcd:	78 d4                	js     104fa3 <sys_open+0x23>
    return -1;

  if(omode & O_CREATE){
  104fcf:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  104fd3:	74 7b                	je     105050 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fd8:	b9 02 00 00 00       	mov    $0x2,%ecx
  104fdd:	ba 01 00 00 00       	mov    $0x1,%edx
  104fe2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104fe9:	00 
  104fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ff1:	e8 da fc ff ff       	call   104cd0 <create>
  104ff6:	85 c0                	test   %eax,%eax
  104ff8:	89 c6                	mov    %eax,%esi
  104ffa:	74 a7                	je     104fa3 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104ffc:	e8 5f bf ff ff       	call   100f60 <filealloc>
  105001:	85 c0                	test   %eax,%eax
  105003:	89 c3                	mov    %eax,%ebx
  105005:	74 73                	je     10507a <sys_open+0xfa>
  105007:	e8 44 f9 ff ff       	call   104950 <fdalloc>
  10500c:	85 c0                	test   %eax,%eax
  10500e:	66 90                	xchg   %ax,%ax
  105010:	78 7d                	js     10508f <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105015:	89 34 24             	mov    %esi,(%esp)
  105018:	e8 c3 cb ff ff       	call   101be0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10501d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  105020:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  105026:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  105029:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  105030:	89 d1                	mov    %edx,%ecx
  105032:	83 f1 01             	xor    $0x1,%ecx
  105035:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105038:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  10503b:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10503e:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  105042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105045:	e9 5e ff ff ff       	jmp    104fa8 <sys_open+0x28>
  10504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105053:	89 04 24             	mov    %eax,(%esp)
  105056:	e8 b5 ce ff ff       	call   101f10 <namei>
  10505b:	85 c0                	test   %eax,%eax
  10505d:	89 c6                	mov    %eax,%esi
  10505f:	0f 84 3e ff ff ff    	je     104fa3 <sys_open+0x23>
      return -1;
    ilock(ip);
  105065:	89 04 24             	mov    %eax,(%esp)
  105068:	e8 e3 cb ff ff       	call   101c50 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  10506d:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105072:	75 88                	jne    104ffc <sys_open+0x7c>
  105074:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  105078:	74 82                	je     104ffc <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  10507a:	89 34 24             	mov    %esi,(%esp)
  10507d:	8d 76 00             	lea    0x0(%esi),%esi
  105080:	e8 ab cb ff ff       	call   101c30 <iunlockput>
  105085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  10508a:	e9 19 ff ff ff       	jmp    104fa8 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10508f:	89 1c 24             	mov    %ebx,(%esp)
  105092:	e8 59 bf ff ff       	call   100ff0 <fileclose>
  105097:	eb e1                	jmp    10507a <sys_open+0xfa>
  105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001050a0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  1050a0:	55                   	push   %ebp
  1050a1:	89 e5                	mov    %esp,%ebp
  1050a3:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1050a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  1050a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1050ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1050af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1050b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050bd:	e8 0e f7 ff ff       	call   1047d0 <argstr>
  1050c2:	85 c0                	test   %eax,%eax
  1050c4:	79 12                	jns    1050d8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1050c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1050cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1050ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1050d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1050d4:	89 ec                	mov    %ebp,%esp
  1050d6:	5d                   	pop    %ebp
  1050d7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1050d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050db:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  1050de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1050e2:	89 04 24             	mov    %eax,(%esp)
  1050e5:	e8 06 ce ff ff       	call   101ef0 <nameiparent>
  1050ea:	85 c0                	test   %eax,%eax
  1050ec:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  1050ef:	74 d5                	je     1050c6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1050f1:	89 04 24             	mov    %eax,(%esp)
  1050f4:	e8 57 cb ff ff       	call   101c50 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1050f9:	c7 44 24 04 2d 6c 10 	movl   $0x106c2d,0x4(%esp)
  105100:	00 
  105101:	89 1c 24             	mov    %ebx,(%esp)
  105104:	e8 d7 c5 ff ff       	call   1016e0 <namecmp>
  105109:	85 c0                	test   %eax,%eax
  10510b:	0f 84 a4 00 00 00    	je     1051b5 <sys_unlink+0x115>
  105111:	c7 44 24 04 2c 6c 10 	movl   $0x106c2c,0x4(%esp)
  105118:	00 
  105119:	89 1c 24             	mov    %ebx,(%esp)
  10511c:	e8 bf c5 ff ff       	call   1016e0 <namecmp>
  105121:	85 c0                	test   %eax,%eax
  105123:	0f 84 8c 00 00 00    	je     1051b5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  105129:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10512c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105130:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105133:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105137:	89 04 24             	mov    %eax,(%esp)
  10513a:	e8 d1 c5 ff ff       	call   101710 <dirlookup>
  10513f:	85 c0                	test   %eax,%eax
  105141:	89 c6                	mov    %eax,%esi
  105143:	74 70                	je     1051b5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105145:	89 04 24             	mov    %eax,(%esp)
  105148:	e8 03 cb ff ff       	call   101c50 <ilock>

  if(ip->nlink < 1)
  10514d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105152:	0f 8e e9 00 00 00    	jle    105241 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  105158:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  10515d:	75 71                	jne    1051d0 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  10515f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105163:	76 6b                	jbe    1051d0 <sys_unlink+0x130>
  105165:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  105168:	bb 20 00 00 00       	mov    $0x20,%ebx
  10516d:	8d 76 00             	lea    0x0(%esi),%esi
  105170:	eb 0e                	jmp    105180 <sys_unlink+0xe0>
  105172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105178:	83 c3 10             	add    $0x10,%ebx
  10517b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10517e:	73 50                	jae    1051d0 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105180:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105187:	00 
  105188:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10518c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105190:	89 34 24             	mov    %esi,(%esp)
  105193:	e8 78 c2 ff ff       	call   101410 <readi>
  105198:	83 f8 10             	cmp    $0x10,%eax
  10519b:	0f 85 94 00 00 00    	jne    105235 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  1051a1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  1051a6:	74 d0                	je     105178 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  1051a8:	89 34 24             	mov    %esi,(%esp)
  1051ab:	90                   	nop
  1051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1051b0:	e8 7b ca ff ff       	call   101c30 <iunlockput>
    iunlockput(dp);
  1051b5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1051b8:	89 04 24             	mov    %eax,(%esp)
  1051bb:	e8 70 ca ff ff       	call   101c30 <iunlockput>
  1051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1051c5:	e9 01 ff ff ff       	jmp    1050cb <sys_unlink+0x2b>
  1051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  1051d0:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  1051d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1051da:	00 
  1051db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1051e2:	00 
  1051e3:	89 1c 24             	mov    %ebx,(%esp)
  1051e6:	e8 c5 f2 ff ff       	call   1044b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1051eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051ee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1051f5:	00 
  1051f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1051fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105201:	89 04 24             	mov    %eax,(%esp)
  105204:	e8 a7 c3 ff ff       	call   1015b0 <writei>
  105209:	83 f8 10             	cmp    $0x10,%eax
  10520c:	75 3f                	jne    10524d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  10520e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105211:	89 04 24             	mov    %eax,(%esp)
  105214:	e8 17 ca ff ff       	call   101c30 <iunlockput>

  ip->nlink--;
  105219:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  10521e:	89 34 24             	mov    %esi,(%esp)
  105221:	e8 fa c2 ff ff       	call   101520 <iupdate>
  iunlockput(ip);
  105226:	89 34 24             	mov    %esi,(%esp)
  105229:	e8 02 ca ff ff       	call   101c30 <iunlockput>
  10522e:	31 c0                	xor    %eax,%eax
  return 0;
  105230:	e9 96 fe ff ff       	jmp    1050cb <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  105235:	c7 04 24 4d 6c 10 00 	movl   $0x106c4d,(%esp)
  10523c:	e8 9f b6 ff ff       	call   1008e0 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105241:	c7 04 24 3b 6c 10 00 	movl   $0x106c3b,(%esp)
  105248:	e8 93 b6 ff ff       	call   1008e0 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  10524d:	c7 04 24 5f 6c 10 00 	movl   $0x106c5f,(%esp)
  105254:	e8 87 b6 ff ff       	call   1008e0 <panic>
  105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105260 <T.61>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  105260:	55                   	push   %ebp
  105261:	89 e5                	mov    %esp,%ebp
  105263:	83 ec 28             	sub    $0x28,%esp
  105266:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105269:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  10526b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  10526e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105271:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105273:	89 44 24 04          	mov    %eax,0x4(%esp)
  105277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10527e:	e8 fd f4 ff ff       	call   104780 <argint>
  105283:	85 c0                	test   %eax,%eax
  105285:	79 11                	jns    105298 <T.61+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  10528c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10528f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105292:	89 ec                	mov    %ebp,%esp
  105294:	5d                   	pop    %ebp
  105295:	c3                   	ret    
  105296:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105298:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  10529c:	77 e9                	ja     105287 <T.61+0x27>
  10529e:	e8 5d e1 ff ff       	call   103400 <curproc>
  1052a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  1052a6:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  1052aa:	85 d2                	test   %edx,%edx
  1052ac:	74 d9                	je     105287 <T.61+0x27>
    return -1;
  if(pfd)
  1052ae:	85 db                	test   %ebx,%ebx
  1052b0:	74 02                	je     1052b4 <T.61+0x54>
    *pfd = fd;
  1052b2:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  1052b4:	31 c0                	xor    %eax,%eax
  1052b6:	85 f6                	test   %esi,%esi
  1052b8:	74 d2                	je     10528c <T.61+0x2c>
    *pf = f;
  1052ba:	89 16                	mov    %edx,(%esi)
  1052bc:	eb ce                	jmp    10528c <T.61+0x2c>
  1052be:	66 90                	xchg   %ax,%ax

001052c0 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  1052c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1052c1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  1052c3:	89 e5                	mov    %esp,%ebp
  1052c5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1052c8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1052cb:	e8 90 ff ff ff       	call   105260 <T.61>
  1052d0:	85 c0                	test   %eax,%eax
  1052d2:	79 0c                	jns    1052e0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  1052d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1052d9:	c9                   	leave  
  1052da:	c3                   	ret    
  1052db:	90                   	nop
  1052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1052e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1052e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1052ee:	e8 8d f4 ff ff       	call   104780 <argint>
  1052f3:	85 c0                	test   %eax,%eax
  1052f5:	78 dd                	js     1052d4 <sys_read+0x14>
  1052f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105301:	89 44 24 08          	mov    %eax,0x8(%esp)
  105305:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105308:	89 44 24 04          	mov    %eax,0x4(%esp)
  10530c:	e8 3f f5 ff ff       	call   104850 <argptr>
  105311:	85 c0                	test   %eax,%eax
  105313:	78 bf                	js     1052d4 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105318:	89 44 24 08          	mov    %eax,0x8(%esp)
  10531c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10531f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105326:	89 04 24             	mov    %eax,(%esp)
  105329:	e8 e2 ba ff ff       	call   100e10 <fileread>
}
  10532e:	c9                   	leave  
  10532f:	c3                   	ret    

00105330 <sys_write>:

int
sys_write(void)
{
  105330:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105331:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105333:	89 e5                	mov    %esp,%ebp
  105335:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105338:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10533b:	e8 20 ff ff ff       	call   105260 <T.61>
  105340:	85 c0                	test   %eax,%eax
  105342:	79 0c                	jns    105350 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105349:	c9                   	leave  
  10534a:	c3                   	ret    
  10534b:	90                   	nop
  10534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105353:	89 44 24 04          	mov    %eax,0x4(%esp)
  105357:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10535e:	e8 1d f4 ff ff       	call   104780 <argint>
  105363:	85 c0                	test   %eax,%eax
  105365:	78 dd                	js     105344 <sys_write+0x14>
  105367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10536a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105371:	89 44 24 08          	mov    %eax,0x8(%esp)
  105375:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105378:	89 44 24 04          	mov    %eax,0x4(%esp)
  10537c:	e8 cf f4 ff ff       	call   104850 <argptr>
  105381:	85 c0                	test   %eax,%eax
  105383:	78 bf                	js     105344 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  105385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105388:	89 44 24 08          	mov    %eax,0x8(%esp)
  10538c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10538f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105396:	89 04 24             	mov    %eax,(%esp)
  105399:	e8 c2 b9 ff ff       	call   100d60 <filewrite>
}
  10539e:	c9                   	leave  
  10539f:	c3                   	ret    

001053a0 <sys_dup>:

int
sys_dup(void)
{
  1053a0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1053a1:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1053a3:	89 e5                	mov    %esp,%ebp
  1053a5:	53                   	push   %ebx
  1053a6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1053a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1053ac:	e8 af fe ff ff       	call   105260 <T.61>
  1053b1:	85 c0                	test   %eax,%eax
  1053b3:	79 13                	jns    1053c8 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1053b5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1053ba:	89 d8                	mov    %ebx,%eax
  1053bc:	83 c4 24             	add    $0x24,%esp
  1053bf:	5b                   	pop    %ebx
  1053c0:	5d                   	pop    %ebp
  1053c1:	c3                   	ret    
  1053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053cb:	e8 80 f5 ff ff       	call   104950 <fdalloc>
  1053d0:	85 c0                	test   %eax,%eax
  1053d2:	89 c3                	mov    %eax,%ebx
  1053d4:	78 df                	js     1053b5 <sys_dup+0x15>
    return -1;
  filedup(f);
  1053d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053d9:	89 04 24             	mov    %eax,(%esp)
  1053dc:	e8 2f bb ff ff       	call   100f10 <filedup>
  return fd;
  1053e1:	eb d7                	jmp    1053ba <sys_dup+0x1a>
  1053e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001053f0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  1053f0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1053f1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  1053f3:	89 e5                	mov    %esp,%ebp
  1053f5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  1053f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1053fb:	e8 60 fe ff ff       	call   105260 <T.61>
  105400:	85 c0                	test   %eax,%eax
  105402:	79 0c                	jns    105410 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  105404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105409:	c9                   	leave  
  10540a:	c3                   	ret    
  10540b:	90                   	nop
  10540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105410:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105413:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10541a:	00 
  10541b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10541f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105426:	e8 25 f4 ff ff       	call   104850 <argptr>
  10542b:	85 c0                	test   %eax,%eax
  10542d:	78 d5                	js     105404 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10542f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105432:	89 44 24 04          	mov    %eax,0x4(%esp)
  105436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105439:	89 04 24             	mov    %eax,(%esp)
  10543c:	e8 7f ba ff ff       	call   100ec0 <filestat>
}
  105441:	c9                   	leave  
  105442:	c3                   	ret    
  105443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105450 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105450:	55                   	push   %ebp
  105451:	89 e5                	mov    %esp,%ebp
  105453:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105456:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10545c:	e8 ff fd ff ff       	call   105260 <T.61>
  105461:	89 c2                	mov    %eax,%edx
  105463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105468:	85 d2                	test   %edx,%edx
  10546a:	78 1d                	js     105489 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  10546c:	e8 8f df ff ff       	call   103400 <curproc>
  105471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105474:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  10547b:	00 
  fileclose(f);
  10547c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10547f:	89 04 24             	mov    %eax,(%esp)
  105482:	e8 69 bb ff ff       	call   100ff0 <fileclose>
  105487:	31 c0                	xor    %eax,%eax
  return 0;
}
  105489:	c9                   	leave  
  10548a:	c3                   	ret    
  10548b:	90                   	nop
  10548c:	90                   	nop
  10548d:	90                   	nop
  10548e:	90                   	nop
  10548f:	90                   	nop

00105490 <sys_tick>:
	return 0;
}

int
sys_tick(void)
{
  105490:	55                   	push   %ebp
return ticks;
}
  105491:	a1 e0 ed 10 00       	mov    0x10ede0,%eax
	return 0;
}

int
sys_tick(void)
{
  105496:	89 e5                	mov    %esp,%ebp
return ticks;
}
  105498:	5d                   	pop    %ebp
  105499:	c3                   	ret    
  10549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054a0 <sys_wake_lock>:
	return 0;
}

int
sys_wake_lock(void)
{
  1054a0:	55                   	push   %ebp
  1054a1:	89 e5                	mov    %esp,%ebp
  1054a3:	83 ec 28             	sub    $0x28,%esp
	int pid;

	if(argint(0, &pid) < 0)
  1054a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1054a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054b4:	e8 c7 f2 ff ff       	call   104780 <argint>
  1054b9:	89 c2                	mov    %eax,%edx
  1054bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1054c0:	85 d2                	test   %edx,%edx
  1054c2:	78 0d                	js     1054d1 <sys_wake_lock+0x31>
		return -1;

	wake_lock(pid);
  1054c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054c7:	89 04 24             	mov    %eax,(%esp)
  1054ca:	e8 61 dc ff ff       	call   103130 <wake_lock>
  1054cf:	31 c0                	xor    %eax,%eax

	return 0;
}
  1054d1:	c9                   	leave  
  1054d2:	c3                   	ret    
  1054d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001054e0 <sys_sleep_lock>:
  return 0;
}

int
sys_sleep_lock(void)
{
  1054e0:	55                   	push   %ebp
  1054e1:	89 e5                	mov    %esp,%ebp
  1054e3:	83 ec 08             	sub    $0x8,%esp
	sleep_lock();
  1054e6:	e8 75 e1 ff ff       	call   103660 <sleep_lock>
	return 0;
}
  1054eb:	31 c0                	xor    %eax,%eax
  1054ed:	c9                   	leave  
  1054ee:	c3                   	ret    
  1054ef:	90                   	nop

001054f0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1054f0:	55                   	push   %ebp
  1054f1:	89 e5                	mov    %esp,%ebp
  1054f3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1054f6:	e8 05 df ff ff       	call   103400 <curproc>
  1054fb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1054fe:	c9                   	leave  
  1054ff:	c3                   	ret    

00105500 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105500:	55                   	push   %ebp
  105501:	89 e5                	mov    %esp,%ebp
  105503:	53                   	push   %ebx
  105504:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10550a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10550e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105515:	e8 66 f2 ff ff       	call   104780 <argint>
  10551a:	89 c2                	mov    %eax,%edx
  10551c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105521:	85 d2                	test   %edx,%edx
  105523:	78 58                	js     10557d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105525:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
  10552c:	e8 0f ef ff ff       	call   104440 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105534:	8b 1d e0 ed 10 00    	mov    0x10ede0,%ebx
  while(ticks - ticks0 < n){
  10553a:	85 d2                	test   %edx,%edx
  10553c:	7f 22                	jg     105560 <sys_sleep+0x60>
  10553e:	eb 48                	jmp    105588 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105540:	c7 44 24 04 a0 e5 10 	movl   $0x10e5a0,0x4(%esp)
  105547:	00 
  105548:	c7 04 24 e0 ed 10 00 	movl   $0x10ede0,(%esp)
  10554f:	e8 5c e1 ff ff       	call   1036b0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105554:	a1 e0 ed 10 00       	mov    0x10ede0,%eax
  105559:	29 d8                	sub    %ebx,%eax
  10555b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10555e:	7d 28                	jge    105588 <sys_sleep+0x88>
    if(cp->killed){
  105560:	e8 9b de ff ff       	call   103400 <curproc>
  105565:	8b 40 1c             	mov    0x1c(%eax),%eax
  105568:	85 c0                	test   %eax,%eax
  10556a:	74 d4                	je     105540 <sys_sleep+0x40>
      release(&tickslock);
  10556c:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
  105573:	e8 88 ee ff ff       	call   104400 <release>
  105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10557d:	83 c4 24             	add    $0x24,%esp
  105580:	5b                   	pop    %ebx
  105581:	5d                   	pop    %ebp
  105582:	c3                   	ret    
  105583:	90                   	nop
  105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105588:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
  10558f:	e8 6c ee ff ff       	call   104400 <release>
  return 0;
}
  105594:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105597:	31 c0                	xor    %eax,%eax
  return 0;
}
  105599:	5b                   	pop    %ebx
  10559a:	5d                   	pop    %ebp
  10559b:	c3                   	ret    
  10559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001055a0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1055a0:	55                   	push   %ebp
  1055a1:	89 e5                	mov    %esp,%ebp
  1055a3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1055a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055b4:	e8 c7 f1 ff ff       	call   104780 <argint>
  1055b9:	85 c0                	test   %eax,%eax
  1055bb:	79 0b                	jns    1055c8 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  1055bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1055c2:	c9                   	leave  
  1055c3:	c3                   	ret    
  1055c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1055c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055cb:	89 04 24             	mov    %eax,(%esp)
  1055ce:	e8 4d e7 ff ff       	call   103d20 <growproc>
  1055d3:	85 c0                	test   %eax,%eax
  1055d5:	78 e6                	js     1055bd <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1055d7:	c9                   	leave  
  1055d8:	c3                   	ret    
  1055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001055e0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1055e0:	55                   	push   %ebp
  1055e1:	89 e5                	mov    %esp,%ebp
  1055e3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1055e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055f4:	e8 87 f1 ff ff       	call   104780 <argint>
  1055f9:	89 c2                	mov    %eax,%edx
  1055fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105600:	85 d2                	test   %edx,%edx
  105602:	78 0b                	js     10560f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105607:	89 04 24             	mov    %eax,(%esp)
  10560a:	e8 61 dc ff ff       	call   103270 <kill>
}
  10560f:	c9                   	leave  
  105610:	c3                   	ret    
  105611:	eb 0d                	jmp    105620 <sys_wait>
  105613:	90                   	nop
  105614:	90                   	nop
  105615:	90                   	nop
  105616:	90                   	nop
  105617:	90                   	nop
  105618:	90                   	nop
  105619:	90                   	nop
  10561a:	90                   	nop
  10561b:	90                   	nop
  10561c:	90                   	nop
  10561d:	90                   	nop
  10561e:	90                   	nop
  10561f:	90                   	nop

00105620 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105620:	55                   	push   %ebp
  105621:	89 e5                	mov    %esp,%ebp
  105623:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105626:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105627:	e9 54 e2 ff ff       	jmp    103880 <wait>
  10562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105630 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  105630:	55                   	push   %ebp
  105631:	89 e5                	mov    %esp,%ebp
  105633:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  105636:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  105637:	e9 44 e1 ff ff       	jmp    103780 <wait_thread>
  10563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105640 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105640:	55                   	push   %ebp
  105641:	89 e5                	mov    %esp,%ebp
  105643:	83 ec 08             	sub    $0x8,%esp
  exit();
  105646:	e8 b5 de ff ff       	call   103500 <exit>
  return 0;  // not reached
}
  10564b:	31 c0                	xor    %eax,%eax
  10564d:	c9                   	leave  
  10564e:	c3                   	ret    
  10564f:	90                   	nop

00105650 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105650:	55                   	push   %ebp
  105651:	89 e5                	mov    %esp,%ebp
  105653:	53                   	push   %ebx
  105654:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105657:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10565a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10565e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105665:	e8 16 f1 ff ff       	call   104780 <argint>
  10566a:	85 c0                	test   %eax,%eax
  10566c:	79 12                	jns    105680 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10566e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105673:	83 c4 24             	add    $0x24,%esp
  105676:	5b                   	pop    %ebx
  105677:	5d                   	pop    %ebp
  105678:	c3                   	ret    
  105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105680:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105683:	e8 78 dd ff ff       	call   103400 <curproc>
  105688:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10568c:	89 04 24             	mov    %eax,(%esp)
  10568f:	e8 4c e7 ff ff       	call   103de0 <copyproc_tix>
  105694:	85 c0                	test   %eax,%eax
  105696:	89 c2                	mov    %eax,%edx
  105698:	74 d4                	je     10566e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10569a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10569d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  1056a0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  1056a7:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  1056ad:	eb c4                	jmp    105673 <sys_fork_tickets+0x23>
  1056af:	90                   	nop

001056b0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1056b0:	55                   	push   %ebp
  1056b1:	89 e5                	mov    %esp,%ebp
  1056b3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1056b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1056bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1056bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056cd:	e8 ae f0 ff ff       	call   104780 <argint>
  1056d2:	85 c0                	test   %eax,%eax
  1056d4:	79 12                	jns    1056e8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1056d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1056de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1056e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1056e4:	89 ec                	mov    %ebp,%esp
  1056e6:	5d                   	pop    %ebp
  1056e7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1056eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056f6:	e8 85 f0 ff ff       	call   104780 <argint>
  1056fb:	85 c0                	test   %eax,%eax
  1056fd:	78 d7                	js     1056d6 <sys_fork_thread+0x26>
  1056ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  105702:	89 44 24 04          	mov    %eax,0x4(%esp)
  105706:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10570d:	e8 6e f0 ff ff       	call   104780 <argint>
  105712:	85 c0                	test   %eax,%eax
  105714:	78 c0                	js     1056d6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105716:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105719:	8b 75 e0             	mov    -0x20(%ebp),%esi
  10571c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10571f:	e8 dc dc ff ff       	call   103400 <curproc>
  105724:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105728:	89 74 24 08          	mov    %esi,0x8(%esp)
  10572c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105730:	89 04 24             	mov    %eax,(%esp)
  105733:	e8 e8 e7 ff ff       	call   103f20 <copyproc_threads>
  105738:	89 c2                	mov    %eax,%edx
  10573a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10573f:	85 d2                	test   %edx,%edx
  105741:	74 98                	je     1056db <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  105743:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  10574a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  10574d:	eb 8c                	jmp    1056db <sys_fork_thread+0x2b>
  10574f:	90                   	nop

00105750 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105750:	55                   	push   %ebp
  105751:	89 e5                	mov    %esp,%ebp
  105753:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105756:	e8 a5 dc ff ff       	call   103400 <curproc>
  10575b:	89 04 24             	mov    %eax,(%esp)
  10575e:	e8 cd e8 ff ff       	call   104030 <copyproc>
  105763:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105768:	85 c0                	test   %eax,%eax
  10576a:	74 0a                	je     105776 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10576c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10576f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105776:	89 d0                	mov    %edx,%eax
  105778:	c9                   	leave  
  105779:	c3                   	ret    
  10577a:	90                   	nop
  10577b:	90                   	nop
  10577c:	90                   	nop
  10577d:	90                   	nop
  10577e:	90                   	nop
  10577f:	90                   	nop

00105780 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105780:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105781:	ba 43 00 00 00       	mov    $0x43,%edx
  105786:	89 e5                	mov    %esp,%ebp
  105788:	83 ec 18             	sub    $0x18,%esp
  10578b:	b8 34 00 00 00       	mov    $0x34,%eax
  105790:	ee                   	out    %al,(%dx)
  105791:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105796:	b2 40                	mov    $0x40,%dl
  105798:	ee                   	out    %al,(%dx)
  105799:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10579e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  10579f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057a6:	e8 65 d5 ff ff       	call   102d10 <pic_enable>
}
  1057ab:	c9                   	leave  
  1057ac:	c3                   	ret    
  1057ad:	90                   	nop
  1057ae:	90                   	nop
  1057af:	90                   	nop

001057b0 <alltraps>:
  1057b0:	1e                   	push   %ds
  1057b1:	06                   	push   %es
  1057b2:	60                   	pusha  
  1057b3:	b8 10 00 00 00       	mov    $0x10,%eax
  1057b8:	8e d8                	mov    %eax,%ds
  1057ba:	8e c0                	mov    %eax,%es
  1057bc:	54                   	push   %esp
  1057bd:	e8 4e 00 00 00       	call   105810 <trap>
  1057c2:	83 c4 04             	add    $0x4,%esp

001057c5 <trapret>:
  1057c5:	61                   	popa   
  1057c6:	07                   	pop    %es
  1057c7:	1f                   	pop    %ds
  1057c8:	83 c4 08             	add    $0x8,%esp
  1057cb:	cf                   	iret   

001057cc <forkret1>:
  1057cc:	8b 64 24 04          	mov    0x4(%esp),%esp
  1057d0:	e9 f0 ff ff ff       	jmp    1057c5 <trapret>
  1057d5:	90                   	nop
  1057d6:	90                   	nop
  1057d7:	90                   	nop
  1057d8:	90                   	nop
  1057d9:	90                   	nop
  1057da:	90                   	nop
  1057db:	90                   	nop
  1057dc:	90                   	nop
  1057dd:	90                   	nop
  1057de:	90                   	nop
  1057df:	90                   	nop

001057e0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1057e0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1057e1:	b8 e0 e5 10 00       	mov    $0x10e5e0,%eax
  1057e6:	89 e5                	mov    %esp,%ebp
  1057e8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1057eb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1057f1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1057f5:	c1 e8 10             	shr    $0x10,%eax
  1057f8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1057fc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1057ff:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105802:	c9                   	leave  
  105803:	c3                   	ret    
  105804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10580a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105810 <trap>:

void
trap(struct trapframe *tf)
{
  105810:	55                   	push   %ebp
  105811:	89 e5                	mov    %esp,%ebp
  105813:	83 ec 48             	sub    $0x48,%esp
  105816:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10581c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10581f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  105822:	8b 43 28             	mov    0x28(%ebx),%eax
  105825:	83 f8 30             	cmp    $0x30,%eax
  105828:	0f 84 8a 01 00 00    	je     1059b8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10582e:	83 f8 21             	cmp    $0x21,%eax
  105831:	0f 84 69 01 00 00    	je     1059a0 <trap+0x190>
  105837:	76 47                	jbe    105880 <trap+0x70>
  105839:	83 f8 2e             	cmp    $0x2e,%eax
  10583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105840:	0f 84 42 01 00 00    	je     105988 <trap+0x178>
  105846:	83 f8 3f             	cmp    $0x3f,%eax
  105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105850:	75 37                	jne    105889 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105852:	8b 7b 30             	mov    0x30(%ebx),%edi
  105855:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  105859:	e8 12 d0 ff ff       	call   102870 <cpu>
  10585e:	c7 04 24 70 6c 10 00 	movl   $0x106c70,(%esp)
  105865:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  105869:	89 74 24 08          	mov    %esi,0x8(%esp)
  10586d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105871:	e8 ca ae ff ff       	call   100740 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105876:	e8 65 ce ff ff       	call   1026e0 <lapic_eoi>
    break;
  10587b:	e9 90 00 00 00       	jmp    105910 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105880:	83 f8 20             	cmp    $0x20,%eax
  105883:	0f 84 e7 00 00 00    	je     105970 <trap+0x160>
  105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105890:	e8 6b db ff ff       	call   103400 <curproc>
  105895:	85 c0                	test   %eax,%eax
  105897:	0f 84 9b 01 00 00    	je     105a38 <trap+0x228>
  10589d:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  1058a1:	0f 84 91 01 00 00    	je     105a38 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1058a7:	8b 53 30             	mov    0x30(%ebx),%edx
  1058aa:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1058ad:	e8 be cf ff ff       	call   102870 <cpu>
  1058b2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  1058b5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1058b8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1058bb:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1058bd:	e8 3e db ff ff       	call   103400 <curproc>
  1058c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058c5:	e8 36 db ff ff       	call   103400 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1058ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1058cd:	89 7c 24 14          	mov    %edi,0x14(%esp)
  1058d1:	89 74 24 10          	mov    %esi,0x10(%esp)
  1058d5:	89 54 24 18          	mov    %edx,0x18(%esp)
  1058d9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1058dc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1058e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1058e3:	81 c2 88 00 00 00    	add    $0x88,%edx
  1058e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1058ed:	8b 40 10             	mov    0x10(%eax),%eax
  1058f0:	c7 04 24 bc 6c 10 00 	movl   $0x106cbc,(%esp)
  1058f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fb:	e8 40 ae ff ff       	call   100740 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105900:	e8 fb da ff ff       	call   103400 <curproc>
  105905:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  10590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105910:	e8 eb da ff ff       	call   103400 <curproc>
  105915:	85 c0                	test   %eax,%eax
  105917:	74 1c                	je     105935 <trap+0x125>
  105919:	e8 e2 da ff ff       	call   103400 <curproc>
  10591e:	8b 40 1c             	mov    0x1c(%eax),%eax
  105921:	85 c0                	test   %eax,%eax
  105923:	74 10                	je     105935 <trap+0x125>
  105925:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105929:	83 e0 03             	and    $0x3,%eax
  10592c:	83 f8 03             	cmp    $0x3,%eax
  10592f:	0f 84 33 01 00 00    	je     105a68 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105935:	e8 c6 da ff ff       	call   103400 <curproc>
  10593a:	85 c0                	test   %eax,%eax
  10593c:	74 0d                	je     10594b <trap+0x13b>
  10593e:	66 90                	xchg   %ax,%ax
  105940:	e8 bb da ff ff       	call   103400 <curproc>
  105945:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105949:	74 0d                	je     105958 <trap+0x148>
    yield();
}
  10594b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10594e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105951:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105954:	89 ec                	mov    %ebp,%esp
  105956:	5d                   	pop    %ebp
  105957:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105958:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  10595c:	75 ed                	jne    10594b <trap+0x13b>
    yield();
}
  10595e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105961:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105964:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105967:	89 ec                	mov    %ebp,%esp
  105969:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  10596a:	e9 21 e0 ff ff       	jmp    103990 <yield>
  10596f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105970:	e8 fb ce ff ff       	call   102870 <cpu>
  105975:	85 c0                	test   %eax,%eax
  105977:	0f 84 8b 00 00 00    	je     105a08 <trap+0x1f8>
  10597d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  105980:	e8 5b cd ff ff       	call   1026e0 <lapic_eoi>
    break;
  105985:	eb 89                	jmp    105910 <trap+0x100>
  105987:	90                   	nop
  105988:	90                   	nop
  105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105990:	e8 3b c7 ff ff       	call   1020d0 <ide_intr>
  105995:	8d 76 00             	lea    0x0(%esi),%esi
  105998:	eb e3                	jmp    10597d <trap+0x16d>
  10599a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  1059a0:	e8 2b cc ff ff       	call   1025d0 <kbd_intr>
  1059a5:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  1059a8:	e8 33 cd ff ff       	call   1026e0 <lapic_eoi>
  1059ad:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  1059b0:	e9 5b ff ff ff       	jmp    105910 <trap+0x100>
  1059b5:	8d 76 00             	lea    0x0(%esi),%esi
  1059b8:	90                   	nop
  1059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  1059c0:	e8 3b da ff ff       	call   103400 <curproc>
  1059c5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1059c8:	85 c9                	test   %ecx,%ecx
  1059ca:	0f 85 a8 00 00 00    	jne    105a78 <trap+0x268>
      exit();
    cp->tf = tf;
  1059d0:	e8 2b da ff ff       	call   103400 <curproc>
  1059d5:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  1059db:	e8 d0 ee ff ff       	call   1048b0 <syscall>
    if(cp->killed)
  1059e0:	e8 1b da ff ff       	call   103400 <curproc>
  1059e5:	8b 50 1c             	mov    0x1c(%eax),%edx
  1059e8:	85 d2                	test   %edx,%edx
  1059ea:	0f 84 5b ff ff ff    	je     10594b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  1059f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1059f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1059f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1059f9:	89 ec                	mov    %ebp,%esp
  1059fb:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  1059fc:	e9 ff da ff ff       	jmp    103500 <exit>
  105a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105a08:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
  105a0f:	e8 2c ea ff ff       	call   104440 <acquire>
      ticks++;
  105a14:	83 05 e0 ed 10 00 01 	addl   $0x1,0x10ede0
      wakeup(&ticks);
  105a1b:	c7 04 24 e0 ed 10 00 	movl   $0x10ede0,(%esp)
  105a22:	e8 d9 d8 ff ff       	call   103300 <wakeup>
      release(&tickslock);
  105a27:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
  105a2e:	e8 cd e9 ff ff       	call   104400 <release>
  105a33:	e9 45 ff ff ff       	jmp    10597d <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105a38:	8b 73 30             	mov    0x30(%ebx),%esi
  105a3b:	e8 30 ce ff ff       	call   102870 <cpu>
  105a40:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105a44:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a48:	8b 43 28             	mov    0x28(%ebx),%eax
  105a4b:	c7 04 24 94 6c 10 00 	movl   $0x106c94,(%esp)
  105a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a56:	e8 e5 ac ff ff       	call   100740 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105a5b:	c7 04 24 f8 6c 10 00 	movl   $0x106cf8,(%esp)
  105a62:	e8 79 ae ff ff       	call   1008e0 <panic>
  105a67:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105a68:	e8 93 da ff ff       	call   103500 <exit>
  105a6d:	e9 c3 fe ff ff       	jmp    105935 <trap+0x125>
  105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105a78:	90                   	nop
  105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105a80:	e8 7b da ff ff       	call   103500 <exit>
  105a85:	8d 76 00             	lea    0x0(%esi),%esi
  105a88:	e9 43 ff ff ff       	jmp    1059d0 <trap+0x1c0>
  105a8d:	8d 76 00             	lea    0x0(%esi),%esi

00105a90 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105a90:	55                   	push   %ebp
  105a91:	31 c0                	xor    %eax,%eax
  105a93:	89 e5                	mov    %esp,%ebp
  105a95:	ba e0 e5 10 00       	mov    $0x10e5e0,%edx
  105a9a:	83 ec 18             	sub    $0x18,%esp
  105a9d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105aa0:	8b 0c 85 28 80 10 00 	mov    0x108028(,%eax,4),%ecx
  105aa7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105aae:	66 89 0c c5 e0 e5 10 	mov    %cx,0x10e5e0(,%eax,8)
  105ab5:	00 
  105ab6:	c1 e9 10             	shr    $0x10,%ecx
  105ab9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  105abe:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105ac3:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105ac8:	83 c0 01             	add    $0x1,%eax
  105acb:	3d 00 01 00 00       	cmp    $0x100,%eax
  105ad0:	75 ce                	jne    105aa0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105ad2:	a1 e8 80 10 00       	mov    0x1080e8,%eax
  
  initlock(&tickslock, "time");
  105ad7:	c7 44 24 04 fd 6c 10 	movl   $0x106cfd,0x4(%esp)
  105ade:	00 
  105adf:	c7 04 24 a0 e5 10 00 	movl   $0x10e5a0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105ae6:	66 c7 05 62 e7 10 00 	movw   $0x8,0x10e762
  105aed:	08 00 
  105aef:	66 a3 60 e7 10 00    	mov    %ax,0x10e760
  105af5:	c1 e8 10             	shr    $0x10,%eax
  105af8:	c6 05 64 e7 10 00 00 	movb   $0x0,0x10e764
  105aff:	c6 05 65 e7 10 00 ef 	movb   $0xef,0x10e765
  105b06:	66 a3 66 e7 10 00    	mov    %ax,0x10e766
  
  initlock(&tickslock, "time");
  105b0c:	e8 6f e7 ff ff       	call   104280 <initlock>
}
  105b11:	c9                   	leave  
  105b12:	c3                   	ret    
  105b13:	90                   	nop

00105b14 <vector0>:
  105b14:	6a 00                	push   $0x0
  105b16:	6a 00                	push   $0x0
  105b18:	e9 93 fc ff ff       	jmp    1057b0 <alltraps>

00105b1d <vector1>:
  105b1d:	6a 00                	push   $0x0
  105b1f:	6a 01                	push   $0x1
  105b21:	e9 8a fc ff ff       	jmp    1057b0 <alltraps>

00105b26 <vector2>:
  105b26:	6a 00                	push   $0x0
  105b28:	6a 02                	push   $0x2
  105b2a:	e9 81 fc ff ff       	jmp    1057b0 <alltraps>

00105b2f <vector3>:
  105b2f:	6a 00                	push   $0x0
  105b31:	6a 03                	push   $0x3
  105b33:	e9 78 fc ff ff       	jmp    1057b0 <alltraps>

00105b38 <vector4>:
  105b38:	6a 00                	push   $0x0
  105b3a:	6a 04                	push   $0x4
  105b3c:	e9 6f fc ff ff       	jmp    1057b0 <alltraps>

00105b41 <vector5>:
  105b41:	6a 00                	push   $0x0
  105b43:	6a 05                	push   $0x5
  105b45:	e9 66 fc ff ff       	jmp    1057b0 <alltraps>

00105b4a <vector6>:
  105b4a:	6a 00                	push   $0x0
  105b4c:	6a 06                	push   $0x6
  105b4e:	e9 5d fc ff ff       	jmp    1057b0 <alltraps>

00105b53 <vector7>:
  105b53:	6a 00                	push   $0x0
  105b55:	6a 07                	push   $0x7
  105b57:	e9 54 fc ff ff       	jmp    1057b0 <alltraps>

00105b5c <vector8>:
  105b5c:	6a 08                	push   $0x8
  105b5e:	e9 4d fc ff ff       	jmp    1057b0 <alltraps>

00105b63 <vector9>:
  105b63:	6a 09                	push   $0x9
  105b65:	e9 46 fc ff ff       	jmp    1057b0 <alltraps>

00105b6a <vector10>:
  105b6a:	6a 0a                	push   $0xa
  105b6c:	e9 3f fc ff ff       	jmp    1057b0 <alltraps>

00105b71 <vector11>:
  105b71:	6a 0b                	push   $0xb
  105b73:	e9 38 fc ff ff       	jmp    1057b0 <alltraps>

00105b78 <vector12>:
  105b78:	6a 0c                	push   $0xc
  105b7a:	e9 31 fc ff ff       	jmp    1057b0 <alltraps>

00105b7f <vector13>:
  105b7f:	6a 0d                	push   $0xd
  105b81:	e9 2a fc ff ff       	jmp    1057b0 <alltraps>

00105b86 <vector14>:
  105b86:	6a 0e                	push   $0xe
  105b88:	e9 23 fc ff ff       	jmp    1057b0 <alltraps>

00105b8d <vector15>:
  105b8d:	6a 00                	push   $0x0
  105b8f:	6a 0f                	push   $0xf
  105b91:	e9 1a fc ff ff       	jmp    1057b0 <alltraps>

00105b96 <vector16>:
  105b96:	6a 00                	push   $0x0
  105b98:	6a 10                	push   $0x10
  105b9a:	e9 11 fc ff ff       	jmp    1057b0 <alltraps>

00105b9f <vector17>:
  105b9f:	6a 11                	push   $0x11
  105ba1:	e9 0a fc ff ff       	jmp    1057b0 <alltraps>

00105ba6 <vector18>:
  105ba6:	6a 00                	push   $0x0
  105ba8:	6a 12                	push   $0x12
  105baa:	e9 01 fc ff ff       	jmp    1057b0 <alltraps>

00105baf <vector19>:
  105baf:	6a 00                	push   $0x0
  105bb1:	6a 13                	push   $0x13
  105bb3:	e9 f8 fb ff ff       	jmp    1057b0 <alltraps>

00105bb8 <vector20>:
  105bb8:	6a 00                	push   $0x0
  105bba:	6a 14                	push   $0x14
  105bbc:	e9 ef fb ff ff       	jmp    1057b0 <alltraps>

00105bc1 <vector21>:
  105bc1:	6a 00                	push   $0x0
  105bc3:	6a 15                	push   $0x15
  105bc5:	e9 e6 fb ff ff       	jmp    1057b0 <alltraps>

00105bca <vector22>:
  105bca:	6a 00                	push   $0x0
  105bcc:	6a 16                	push   $0x16
  105bce:	e9 dd fb ff ff       	jmp    1057b0 <alltraps>

00105bd3 <vector23>:
  105bd3:	6a 00                	push   $0x0
  105bd5:	6a 17                	push   $0x17
  105bd7:	e9 d4 fb ff ff       	jmp    1057b0 <alltraps>

00105bdc <vector24>:
  105bdc:	6a 00                	push   $0x0
  105bde:	6a 18                	push   $0x18
  105be0:	e9 cb fb ff ff       	jmp    1057b0 <alltraps>

00105be5 <vector25>:
  105be5:	6a 00                	push   $0x0
  105be7:	6a 19                	push   $0x19
  105be9:	e9 c2 fb ff ff       	jmp    1057b0 <alltraps>

00105bee <vector26>:
  105bee:	6a 00                	push   $0x0
  105bf0:	6a 1a                	push   $0x1a
  105bf2:	e9 b9 fb ff ff       	jmp    1057b0 <alltraps>

00105bf7 <vector27>:
  105bf7:	6a 00                	push   $0x0
  105bf9:	6a 1b                	push   $0x1b
  105bfb:	e9 b0 fb ff ff       	jmp    1057b0 <alltraps>

00105c00 <vector28>:
  105c00:	6a 00                	push   $0x0
  105c02:	6a 1c                	push   $0x1c
  105c04:	e9 a7 fb ff ff       	jmp    1057b0 <alltraps>

00105c09 <vector29>:
  105c09:	6a 00                	push   $0x0
  105c0b:	6a 1d                	push   $0x1d
  105c0d:	e9 9e fb ff ff       	jmp    1057b0 <alltraps>

00105c12 <vector30>:
  105c12:	6a 00                	push   $0x0
  105c14:	6a 1e                	push   $0x1e
  105c16:	e9 95 fb ff ff       	jmp    1057b0 <alltraps>

00105c1b <vector31>:
  105c1b:	6a 00                	push   $0x0
  105c1d:	6a 1f                	push   $0x1f
  105c1f:	e9 8c fb ff ff       	jmp    1057b0 <alltraps>

00105c24 <vector32>:
  105c24:	6a 00                	push   $0x0
  105c26:	6a 20                	push   $0x20
  105c28:	e9 83 fb ff ff       	jmp    1057b0 <alltraps>

00105c2d <vector33>:
  105c2d:	6a 00                	push   $0x0
  105c2f:	6a 21                	push   $0x21
  105c31:	e9 7a fb ff ff       	jmp    1057b0 <alltraps>

00105c36 <vector34>:
  105c36:	6a 00                	push   $0x0
  105c38:	6a 22                	push   $0x22
  105c3a:	e9 71 fb ff ff       	jmp    1057b0 <alltraps>

00105c3f <vector35>:
  105c3f:	6a 00                	push   $0x0
  105c41:	6a 23                	push   $0x23
  105c43:	e9 68 fb ff ff       	jmp    1057b0 <alltraps>

00105c48 <vector36>:
  105c48:	6a 00                	push   $0x0
  105c4a:	6a 24                	push   $0x24
  105c4c:	e9 5f fb ff ff       	jmp    1057b0 <alltraps>

00105c51 <vector37>:
  105c51:	6a 00                	push   $0x0
  105c53:	6a 25                	push   $0x25
  105c55:	e9 56 fb ff ff       	jmp    1057b0 <alltraps>

00105c5a <vector38>:
  105c5a:	6a 00                	push   $0x0
  105c5c:	6a 26                	push   $0x26
  105c5e:	e9 4d fb ff ff       	jmp    1057b0 <alltraps>

00105c63 <vector39>:
  105c63:	6a 00                	push   $0x0
  105c65:	6a 27                	push   $0x27
  105c67:	e9 44 fb ff ff       	jmp    1057b0 <alltraps>

00105c6c <vector40>:
  105c6c:	6a 00                	push   $0x0
  105c6e:	6a 28                	push   $0x28
  105c70:	e9 3b fb ff ff       	jmp    1057b0 <alltraps>

00105c75 <vector41>:
  105c75:	6a 00                	push   $0x0
  105c77:	6a 29                	push   $0x29
  105c79:	e9 32 fb ff ff       	jmp    1057b0 <alltraps>

00105c7e <vector42>:
  105c7e:	6a 00                	push   $0x0
  105c80:	6a 2a                	push   $0x2a
  105c82:	e9 29 fb ff ff       	jmp    1057b0 <alltraps>

00105c87 <vector43>:
  105c87:	6a 00                	push   $0x0
  105c89:	6a 2b                	push   $0x2b
  105c8b:	e9 20 fb ff ff       	jmp    1057b0 <alltraps>

00105c90 <vector44>:
  105c90:	6a 00                	push   $0x0
  105c92:	6a 2c                	push   $0x2c
  105c94:	e9 17 fb ff ff       	jmp    1057b0 <alltraps>

00105c99 <vector45>:
  105c99:	6a 00                	push   $0x0
  105c9b:	6a 2d                	push   $0x2d
  105c9d:	e9 0e fb ff ff       	jmp    1057b0 <alltraps>

00105ca2 <vector46>:
  105ca2:	6a 00                	push   $0x0
  105ca4:	6a 2e                	push   $0x2e
  105ca6:	e9 05 fb ff ff       	jmp    1057b0 <alltraps>

00105cab <vector47>:
  105cab:	6a 00                	push   $0x0
  105cad:	6a 2f                	push   $0x2f
  105caf:	e9 fc fa ff ff       	jmp    1057b0 <alltraps>

00105cb4 <vector48>:
  105cb4:	6a 00                	push   $0x0
  105cb6:	6a 30                	push   $0x30
  105cb8:	e9 f3 fa ff ff       	jmp    1057b0 <alltraps>

00105cbd <vector49>:
  105cbd:	6a 00                	push   $0x0
  105cbf:	6a 31                	push   $0x31
  105cc1:	e9 ea fa ff ff       	jmp    1057b0 <alltraps>

00105cc6 <vector50>:
  105cc6:	6a 00                	push   $0x0
  105cc8:	6a 32                	push   $0x32
  105cca:	e9 e1 fa ff ff       	jmp    1057b0 <alltraps>

00105ccf <vector51>:
  105ccf:	6a 00                	push   $0x0
  105cd1:	6a 33                	push   $0x33
  105cd3:	e9 d8 fa ff ff       	jmp    1057b0 <alltraps>

00105cd8 <vector52>:
  105cd8:	6a 00                	push   $0x0
  105cda:	6a 34                	push   $0x34
  105cdc:	e9 cf fa ff ff       	jmp    1057b0 <alltraps>

00105ce1 <vector53>:
  105ce1:	6a 00                	push   $0x0
  105ce3:	6a 35                	push   $0x35
  105ce5:	e9 c6 fa ff ff       	jmp    1057b0 <alltraps>

00105cea <vector54>:
  105cea:	6a 00                	push   $0x0
  105cec:	6a 36                	push   $0x36
  105cee:	e9 bd fa ff ff       	jmp    1057b0 <alltraps>

00105cf3 <vector55>:
  105cf3:	6a 00                	push   $0x0
  105cf5:	6a 37                	push   $0x37
  105cf7:	e9 b4 fa ff ff       	jmp    1057b0 <alltraps>

00105cfc <vector56>:
  105cfc:	6a 00                	push   $0x0
  105cfe:	6a 38                	push   $0x38
  105d00:	e9 ab fa ff ff       	jmp    1057b0 <alltraps>

00105d05 <vector57>:
  105d05:	6a 00                	push   $0x0
  105d07:	6a 39                	push   $0x39
  105d09:	e9 a2 fa ff ff       	jmp    1057b0 <alltraps>

00105d0e <vector58>:
  105d0e:	6a 00                	push   $0x0
  105d10:	6a 3a                	push   $0x3a
  105d12:	e9 99 fa ff ff       	jmp    1057b0 <alltraps>

00105d17 <vector59>:
  105d17:	6a 00                	push   $0x0
  105d19:	6a 3b                	push   $0x3b
  105d1b:	e9 90 fa ff ff       	jmp    1057b0 <alltraps>

00105d20 <vector60>:
  105d20:	6a 00                	push   $0x0
  105d22:	6a 3c                	push   $0x3c
  105d24:	e9 87 fa ff ff       	jmp    1057b0 <alltraps>

00105d29 <vector61>:
  105d29:	6a 00                	push   $0x0
  105d2b:	6a 3d                	push   $0x3d
  105d2d:	e9 7e fa ff ff       	jmp    1057b0 <alltraps>

00105d32 <vector62>:
  105d32:	6a 00                	push   $0x0
  105d34:	6a 3e                	push   $0x3e
  105d36:	e9 75 fa ff ff       	jmp    1057b0 <alltraps>

00105d3b <vector63>:
  105d3b:	6a 00                	push   $0x0
  105d3d:	6a 3f                	push   $0x3f
  105d3f:	e9 6c fa ff ff       	jmp    1057b0 <alltraps>

00105d44 <vector64>:
  105d44:	6a 00                	push   $0x0
  105d46:	6a 40                	push   $0x40
  105d48:	e9 63 fa ff ff       	jmp    1057b0 <alltraps>

00105d4d <vector65>:
  105d4d:	6a 00                	push   $0x0
  105d4f:	6a 41                	push   $0x41
  105d51:	e9 5a fa ff ff       	jmp    1057b0 <alltraps>

00105d56 <vector66>:
  105d56:	6a 00                	push   $0x0
  105d58:	6a 42                	push   $0x42
  105d5a:	e9 51 fa ff ff       	jmp    1057b0 <alltraps>

00105d5f <vector67>:
  105d5f:	6a 00                	push   $0x0
  105d61:	6a 43                	push   $0x43
  105d63:	e9 48 fa ff ff       	jmp    1057b0 <alltraps>

00105d68 <vector68>:
  105d68:	6a 00                	push   $0x0
  105d6a:	6a 44                	push   $0x44
  105d6c:	e9 3f fa ff ff       	jmp    1057b0 <alltraps>

00105d71 <vector69>:
  105d71:	6a 00                	push   $0x0
  105d73:	6a 45                	push   $0x45
  105d75:	e9 36 fa ff ff       	jmp    1057b0 <alltraps>

00105d7a <vector70>:
  105d7a:	6a 00                	push   $0x0
  105d7c:	6a 46                	push   $0x46
  105d7e:	e9 2d fa ff ff       	jmp    1057b0 <alltraps>

00105d83 <vector71>:
  105d83:	6a 00                	push   $0x0
  105d85:	6a 47                	push   $0x47
  105d87:	e9 24 fa ff ff       	jmp    1057b0 <alltraps>

00105d8c <vector72>:
  105d8c:	6a 00                	push   $0x0
  105d8e:	6a 48                	push   $0x48
  105d90:	e9 1b fa ff ff       	jmp    1057b0 <alltraps>

00105d95 <vector73>:
  105d95:	6a 00                	push   $0x0
  105d97:	6a 49                	push   $0x49
  105d99:	e9 12 fa ff ff       	jmp    1057b0 <alltraps>

00105d9e <vector74>:
  105d9e:	6a 00                	push   $0x0
  105da0:	6a 4a                	push   $0x4a
  105da2:	e9 09 fa ff ff       	jmp    1057b0 <alltraps>

00105da7 <vector75>:
  105da7:	6a 00                	push   $0x0
  105da9:	6a 4b                	push   $0x4b
  105dab:	e9 00 fa ff ff       	jmp    1057b0 <alltraps>

00105db0 <vector76>:
  105db0:	6a 00                	push   $0x0
  105db2:	6a 4c                	push   $0x4c
  105db4:	e9 f7 f9 ff ff       	jmp    1057b0 <alltraps>

00105db9 <vector77>:
  105db9:	6a 00                	push   $0x0
  105dbb:	6a 4d                	push   $0x4d
  105dbd:	e9 ee f9 ff ff       	jmp    1057b0 <alltraps>

00105dc2 <vector78>:
  105dc2:	6a 00                	push   $0x0
  105dc4:	6a 4e                	push   $0x4e
  105dc6:	e9 e5 f9 ff ff       	jmp    1057b0 <alltraps>

00105dcb <vector79>:
  105dcb:	6a 00                	push   $0x0
  105dcd:	6a 4f                	push   $0x4f
  105dcf:	e9 dc f9 ff ff       	jmp    1057b0 <alltraps>

00105dd4 <vector80>:
  105dd4:	6a 00                	push   $0x0
  105dd6:	6a 50                	push   $0x50
  105dd8:	e9 d3 f9 ff ff       	jmp    1057b0 <alltraps>

00105ddd <vector81>:
  105ddd:	6a 00                	push   $0x0
  105ddf:	6a 51                	push   $0x51
  105de1:	e9 ca f9 ff ff       	jmp    1057b0 <alltraps>

00105de6 <vector82>:
  105de6:	6a 00                	push   $0x0
  105de8:	6a 52                	push   $0x52
  105dea:	e9 c1 f9 ff ff       	jmp    1057b0 <alltraps>

00105def <vector83>:
  105def:	6a 00                	push   $0x0
  105df1:	6a 53                	push   $0x53
  105df3:	e9 b8 f9 ff ff       	jmp    1057b0 <alltraps>

00105df8 <vector84>:
  105df8:	6a 00                	push   $0x0
  105dfa:	6a 54                	push   $0x54
  105dfc:	e9 af f9 ff ff       	jmp    1057b0 <alltraps>

00105e01 <vector85>:
  105e01:	6a 00                	push   $0x0
  105e03:	6a 55                	push   $0x55
  105e05:	e9 a6 f9 ff ff       	jmp    1057b0 <alltraps>

00105e0a <vector86>:
  105e0a:	6a 00                	push   $0x0
  105e0c:	6a 56                	push   $0x56
  105e0e:	e9 9d f9 ff ff       	jmp    1057b0 <alltraps>

00105e13 <vector87>:
  105e13:	6a 00                	push   $0x0
  105e15:	6a 57                	push   $0x57
  105e17:	e9 94 f9 ff ff       	jmp    1057b0 <alltraps>

00105e1c <vector88>:
  105e1c:	6a 00                	push   $0x0
  105e1e:	6a 58                	push   $0x58
  105e20:	e9 8b f9 ff ff       	jmp    1057b0 <alltraps>

00105e25 <vector89>:
  105e25:	6a 00                	push   $0x0
  105e27:	6a 59                	push   $0x59
  105e29:	e9 82 f9 ff ff       	jmp    1057b0 <alltraps>

00105e2e <vector90>:
  105e2e:	6a 00                	push   $0x0
  105e30:	6a 5a                	push   $0x5a
  105e32:	e9 79 f9 ff ff       	jmp    1057b0 <alltraps>

00105e37 <vector91>:
  105e37:	6a 00                	push   $0x0
  105e39:	6a 5b                	push   $0x5b
  105e3b:	e9 70 f9 ff ff       	jmp    1057b0 <alltraps>

00105e40 <vector92>:
  105e40:	6a 00                	push   $0x0
  105e42:	6a 5c                	push   $0x5c
  105e44:	e9 67 f9 ff ff       	jmp    1057b0 <alltraps>

00105e49 <vector93>:
  105e49:	6a 00                	push   $0x0
  105e4b:	6a 5d                	push   $0x5d
  105e4d:	e9 5e f9 ff ff       	jmp    1057b0 <alltraps>

00105e52 <vector94>:
  105e52:	6a 00                	push   $0x0
  105e54:	6a 5e                	push   $0x5e
  105e56:	e9 55 f9 ff ff       	jmp    1057b0 <alltraps>

00105e5b <vector95>:
  105e5b:	6a 00                	push   $0x0
  105e5d:	6a 5f                	push   $0x5f
  105e5f:	e9 4c f9 ff ff       	jmp    1057b0 <alltraps>

00105e64 <vector96>:
  105e64:	6a 00                	push   $0x0
  105e66:	6a 60                	push   $0x60
  105e68:	e9 43 f9 ff ff       	jmp    1057b0 <alltraps>

00105e6d <vector97>:
  105e6d:	6a 00                	push   $0x0
  105e6f:	6a 61                	push   $0x61
  105e71:	e9 3a f9 ff ff       	jmp    1057b0 <alltraps>

00105e76 <vector98>:
  105e76:	6a 00                	push   $0x0
  105e78:	6a 62                	push   $0x62
  105e7a:	e9 31 f9 ff ff       	jmp    1057b0 <alltraps>

00105e7f <vector99>:
  105e7f:	6a 00                	push   $0x0
  105e81:	6a 63                	push   $0x63
  105e83:	e9 28 f9 ff ff       	jmp    1057b0 <alltraps>

00105e88 <vector100>:
  105e88:	6a 00                	push   $0x0
  105e8a:	6a 64                	push   $0x64
  105e8c:	e9 1f f9 ff ff       	jmp    1057b0 <alltraps>

00105e91 <vector101>:
  105e91:	6a 00                	push   $0x0
  105e93:	6a 65                	push   $0x65
  105e95:	e9 16 f9 ff ff       	jmp    1057b0 <alltraps>

00105e9a <vector102>:
  105e9a:	6a 00                	push   $0x0
  105e9c:	6a 66                	push   $0x66
  105e9e:	e9 0d f9 ff ff       	jmp    1057b0 <alltraps>

00105ea3 <vector103>:
  105ea3:	6a 00                	push   $0x0
  105ea5:	6a 67                	push   $0x67
  105ea7:	e9 04 f9 ff ff       	jmp    1057b0 <alltraps>

00105eac <vector104>:
  105eac:	6a 00                	push   $0x0
  105eae:	6a 68                	push   $0x68
  105eb0:	e9 fb f8 ff ff       	jmp    1057b0 <alltraps>

00105eb5 <vector105>:
  105eb5:	6a 00                	push   $0x0
  105eb7:	6a 69                	push   $0x69
  105eb9:	e9 f2 f8 ff ff       	jmp    1057b0 <alltraps>

00105ebe <vector106>:
  105ebe:	6a 00                	push   $0x0
  105ec0:	6a 6a                	push   $0x6a
  105ec2:	e9 e9 f8 ff ff       	jmp    1057b0 <alltraps>

00105ec7 <vector107>:
  105ec7:	6a 00                	push   $0x0
  105ec9:	6a 6b                	push   $0x6b
  105ecb:	e9 e0 f8 ff ff       	jmp    1057b0 <alltraps>

00105ed0 <vector108>:
  105ed0:	6a 00                	push   $0x0
  105ed2:	6a 6c                	push   $0x6c
  105ed4:	e9 d7 f8 ff ff       	jmp    1057b0 <alltraps>

00105ed9 <vector109>:
  105ed9:	6a 00                	push   $0x0
  105edb:	6a 6d                	push   $0x6d
  105edd:	e9 ce f8 ff ff       	jmp    1057b0 <alltraps>

00105ee2 <vector110>:
  105ee2:	6a 00                	push   $0x0
  105ee4:	6a 6e                	push   $0x6e
  105ee6:	e9 c5 f8 ff ff       	jmp    1057b0 <alltraps>

00105eeb <vector111>:
  105eeb:	6a 00                	push   $0x0
  105eed:	6a 6f                	push   $0x6f
  105eef:	e9 bc f8 ff ff       	jmp    1057b0 <alltraps>

00105ef4 <vector112>:
  105ef4:	6a 00                	push   $0x0
  105ef6:	6a 70                	push   $0x70
  105ef8:	e9 b3 f8 ff ff       	jmp    1057b0 <alltraps>

00105efd <vector113>:
  105efd:	6a 00                	push   $0x0
  105eff:	6a 71                	push   $0x71
  105f01:	e9 aa f8 ff ff       	jmp    1057b0 <alltraps>

00105f06 <vector114>:
  105f06:	6a 00                	push   $0x0
  105f08:	6a 72                	push   $0x72
  105f0a:	e9 a1 f8 ff ff       	jmp    1057b0 <alltraps>

00105f0f <vector115>:
  105f0f:	6a 00                	push   $0x0
  105f11:	6a 73                	push   $0x73
  105f13:	e9 98 f8 ff ff       	jmp    1057b0 <alltraps>

00105f18 <vector116>:
  105f18:	6a 00                	push   $0x0
  105f1a:	6a 74                	push   $0x74
  105f1c:	e9 8f f8 ff ff       	jmp    1057b0 <alltraps>

00105f21 <vector117>:
  105f21:	6a 00                	push   $0x0
  105f23:	6a 75                	push   $0x75
  105f25:	e9 86 f8 ff ff       	jmp    1057b0 <alltraps>

00105f2a <vector118>:
  105f2a:	6a 00                	push   $0x0
  105f2c:	6a 76                	push   $0x76
  105f2e:	e9 7d f8 ff ff       	jmp    1057b0 <alltraps>

00105f33 <vector119>:
  105f33:	6a 00                	push   $0x0
  105f35:	6a 77                	push   $0x77
  105f37:	e9 74 f8 ff ff       	jmp    1057b0 <alltraps>

00105f3c <vector120>:
  105f3c:	6a 00                	push   $0x0
  105f3e:	6a 78                	push   $0x78
  105f40:	e9 6b f8 ff ff       	jmp    1057b0 <alltraps>

00105f45 <vector121>:
  105f45:	6a 00                	push   $0x0
  105f47:	6a 79                	push   $0x79
  105f49:	e9 62 f8 ff ff       	jmp    1057b0 <alltraps>

00105f4e <vector122>:
  105f4e:	6a 00                	push   $0x0
  105f50:	6a 7a                	push   $0x7a
  105f52:	e9 59 f8 ff ff       	jmp    1057b0 <alltraps>

00105f57 <vector123>:
  105f57:	6a 00                	push   $0x0
  105f59:	6a 7b                	push   $0x7b
  105f5b:	e9 50 f8 ff ff       	jmp    1057b0 <alltraps>

00105f60 <vector124>:
  105f60:	6a 00                	push   $0x0
  105f62:	6a 7c                	push   $0x7c
  105f64:	e9 47 f8 ff ff       	jmp    1057b0 <alltraps>

00105f69 <vector125>:
  105f69:	6a 00                	push   $0x0
  105f6b:	6a 7d                	push   $0x7d
  105f6d:	e9 3e f8 ff ff       	jmp    1057b0 <alltraps>

00105f72 <vector126>:
  105f72:	6a 00                	push   $0x0
  105f74:	6a 7e                	push   $0x7e
  105f76:	e9 35 f8 ff ff       	jmp    1057b0 <alltraps>

00105f7b <vector127>:
  105f7b:	6a 00                	push   $0x0
  105f7d:	6a 7f                	push   $0x7f
  105f7f:	e9 2c f8 ff ff       	jmp    1057b0 <alltraps>

00105f84 <vector128>:
  105f84:	6a 00                	push   $0x0
  105f86:	68 80 00 00 00       	push   $0x80
  105f8b:	e9 20 f8 ff ff       	jmp    1057b0 <alltraps>

00105f90 <vector129>:
  105f90:	6a 00                	push   $0x0
  105f92:	68 81 00 00 00       	push   $0x81
  105f97:	e9 14 f8 ff ff       	jmp    1057b0 <alltraps>

00105f9c <vector130>:
  105f9c:	6a 00                	push   $0x0
  105f9e:	68 82 00 00 00       	push   $0x82
  105fa3:	e9 08 f8 ff ff       	jmp    1057b0 <alltraps>

00105fa8 <vector131>:
  105fa8:	6a 00                	push   $0x0
  105faa:	68 83 00 00 00       	push   $0x83
  105faf:	e9 fc f7 ff ff       	jmp    1057b0 <alltraps>

00105fb4 <vector132>:
  105fb4:	6a 00                	push   $0x0
  105fb6:	68 84 00 00 00       	push   $0x84
  105fbb:	e9 f0 f7 ff ff       	jmp    1057b0 <alltraps>

00105fc0 <vector133>:
  105fc0:	6a 00                	push   $0x0
  105fc2:	68 85 00 00 00       	push   $0x85
  105fc7:	e9 e4 f7 ff ff       	jmp    1057b0 <alltraps>

00105fcc <vector134>:
  105fcc:	6a 00                	push   $0x0
  105fce:	68 86 00 00 00       	push   $0x86
  105fd3:	e9 d8 f7 ff ff       	jmp    1057b0 <alltraps>

00105fd8 <vector135>:
  105fd8:	6a 00                	push   $0x0
  105fda:	68 87 00 00 00       	push   $0x87
  105fdf:	e9 cc f7 ff ff       	jmp    1057b0 <alltraps>

00105fe4 <vector136>:
  105fe4:	6a 00                	push   $0x0
  105fe6:	68 88 00 00 00       	push   $0x88
  105feb:	e9 c0 f7 ff ff       	jmp    1057b0 <alltraps>

00105ff0 <vector137>:
  105ff0:	6a 00                	push   $0x0
  105ff2:	68 89 00 00 00       	push   $0x89
  105ff7:	e9 b4 f7 ff ff       	jmp    1057b0 <alltraps>

00105ffc <vector138>:
  105ffc:	6a 00                	push   $0x0
  105ffe:	68 8a 00 00 00       	push   $0x8a
  106003:	e9 a8 f7 ff ff       	jmp    1057b0 <alltraps>

00106008 <vector139>:
  106008:	6a 00                	push   $0x0
  10600a:	68 8b 00 00 00       	push   $0x8b
  10600f:	e9 9c f7 ff ff       	jmp    1057b0 <alltraps>

00106014 <vector140>:
  106014:	6a 00                	push   $0x0
  106016:	68 8c 00 00 00       	push   $0x8c
  10601b:	e9 90 f7 ff ff       	jmp    1057b0 <alltraps>

00106020 <vector141>:
  106020:	6a 00                	push   $0x0
  106022:	68 8d 00 00 00       	push   $0x8d
  106027:	e9 84 f7 ff ff       	jmp    1057b0 <alltraps>

0010602c <vector142>:
  10602c:	6a 00                	push   $0x0
  10602e:	68 8e 00 00 00       	push   $0x8e
  106033:	e9 78 f7 ff ff       	jmp    1057b0 <alltraps>

00106038 <vector143>:
  106038:	6a 00                	push   $0x0
  10603a:	68 8f 00 00 00       	push   $0x8f
  10603f:	e9 6c f7 ff ff       	jmp    1057b0 <alltraps>

00106044 <vector144>:
  106044:	6a 00                	push   $0x0
  106046:	68 90 00 00 00       	push   $0x90
  10604b:	e9 60 f7 ff ff       	jmp    1057b0 <alltraps>

00106050 <vector145>:
  106050:	6a 00                	push   $0x0
  106052:	68 91 00 00 00       	push   $0x91
  106057:	e9 54 f7 ff ff       	jmp    1057b0 <alltraps>

0010605c <vector146>:
  10605c:	6a 00                	push   $0x0
  10605e:	68 92 00 00 00       	push   $0x92
  106063:	e9 48 f7 ff ff       	jmp    1057b0 <alltraps>

00106068 <vector147>:
  106068:	6a 00                	push   $0x0
  10606a:	68 93 00 00 00       	push   $0x93
  10606f:	e9 3c f7 ff ff       	jmp    1057b0 <alltraps>

00106074 <vector148>:
  106074:	6a 00                	push   $0x0
  106076:	68 94 00 00 00       	push   $0x94
  10607b:	e9 30 f7 ff ff       	jmp    1057b0 <alltraps>

00106080 <vector149>:
  106080:	6a 00                	push   $0x0
  106082:	68 95 00 00 00       	push   $0x95
  106087:	e9 24 f7 ff ff       	jmp    1057b0 <alltraps>

0010608c <vector150>:
  10608c:	6a 00                	push   $0x0
  10608e:	68 96 00 00 00       	push   $0x96
  106093:	e9 18 f7 ff ff       	jmp    1057b0 <alltraps>

00106098 <vector151>:
  106098:	6a 00                	push   $0x0
  10609a:	68 97 00 00 00       	push   $0x97
  10609f:	e9 0c f7 ff ff       	jmp    1057b0 <alltraps>

001060a4 <vector152>:
  1060a4:	6a 00                	push   $0x0
  1060a6:	68 98 00 00 00       	push   $0x98
  1060ab:	e9 00 f7 ff ff       	jmp    1057b0 <alltraps>

001060b0 <vector153>:
  1060b0:	6a 00                	push   $0x0
  1060b2:	68 99 00 00 00       	push   $0x99
  1060b7:	e9 f4 f6 ff ff       	jmp    1057b0 <alltraps>

001060bc <vector154>:
  1060bc:	6a 00                	push   $0x0
  1060be:	68 9a 00 00 00       	push   $0x9a
  1060c3:	e9 e8 f6 ff ff       	jmp    1057b0 <alltraps>

001060c8 <vector155>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	68 9b 00 00 00       	push   $0x9b
  1060cf:	e9 dc f6 ff ff       	jmp    1057b0 <alltraps>

001060d4 <vector156>:
  1060d4:	6a 00                	push   $0x0
  1060d6:	68 9c 00 00 00       	push   $0x9c
  1060db:	e9 d0 f6 ff ff       	jmp    1057b0 <alltraps>

001060e0 <vector157>:
  1060e0:	6a 00                	push   $0x0
  1060e2:	68 9d 00 00 00       	push   $0x9d
  1060e7:	e9 c4 f6 ff ff       	jmp    1057b0 <alltraps>

001060ec <vector158>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	68 9e 00 00 00       	push   $0x9e
  1060f3:	e9 b8 f6 ff ff       	jmp    1057b0 <alltraps>

001060f8 <vector159>:
  1060f8:	6a 00                	push   $0x0
  1060fa:	68 9f 00 00 00       	push   $0x9f
  1060ff:	e9 ac f6 ff ff       	jmp    1057b0 <alltraps>

00106104 <vector160>:
  106104:	6a 00                	push   $0x0
  106106:	68 a0 00 00 00       	push   $0xa0
  10610b:	e9 a0 f6 ff ff       	jmp    1057b0 <alltraps>

00106110 <vector161>:
  106110:	6a 00                	push   $0x0
  106112:	68 a1 00 00 00       	push   $0xa1
  106117:	e9 94 f6 ff ff       	jmp    1057b0 <alltraps>

0010611c <vector162>:
  10611c:	6a 00                	push   $0x0
  10611e:	68 a2 00 00 00       	push   $0xa2
  106123:	e9 88 f6 ff ff       	jmp    1057b0 <alltraps>

00106128 <vector163>:
  106128:	6a 00                	push   $0x0
  10612a:	68 a3 00 00 00       	push   $0xa3
  10612f:	e9 7c f6 ff ff       	jmp    1057b0 <alltraps>

00106134 <vector164>:
  106134:	6a 00                	push   $0x0
  106136:	68 a4 00 00 00       	push   $0xa4
  10613b:	e9 70 f6 ff ff       	jmp    1057b0 <alltraps>

00106140 <vector165>:
  106140:	6a 00                	push   $0x0
  106142:	68 a5 00 00 00       	push   $0xa5
  106147:	e9 64 f6 ff ff       	jmp    1057b0 <alltraps>

0010614c <vector166>:
  10614c:	6a 00                	push   $0x0
  10614e:	68 a6 00 00 00       	push   $0xa6
  106153:	e9 58 f6 ff ff       	jmp    1057b0 <alltraps>

00106158 <vector167>:
  106158:	6a 00                	push   $0x0
  10615a:	68 a7 00 00 00       	push   $0xa7
  10615f:	e9 4c f6 ff ff       	jmp    1057b0 <alltraps>

00106164 <vector168>:
  106164:	6a 00                	push   $0x0
  106166:	68 a8 00 00 00       	push   $0xa8
  10616b:	e9 40 f6 ff ff       	jmp    1057b0 <alltraps>

00106170 <vector169>:
  106170:	6a 00                	push   $0x0
  106172:	68 a9 00 00 00       	push   $0xa9
  106177:	e9 34 f6 ff ff       	jmp    1057b0 <alltraps>

0010617c <vector170>:
  10617c:	6a 00                	push   $0x0
  10617e:	68 aa 00 00 00       	push   $0xaa
  106183:	e9 28 f6 ff ff       	jmp    1057b0 <alltraps>

00106188 <vector171>:
  106188:	6a 00                	push   $0x0
  10618a:	68 ab 00 00 00       	push   $0xab
  10618f:	e9 1c f6 ff ff       	jmp    1057b0 <alltraps>

00106194 <vector172>:
  106194:	6a 00                	push   $0x0
  106196:	68 ac 00 00 00       	push   $0xac
  10619b:	e9 10 f6 ff ff       	jmp    1057b0 <alltraps>

001061a0 <vector173>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	68 ad 00 00 00       	push   $0xad
  1061a7:	e9 04 f6 ff ff       	jmp    1057b0 <alltraps>

001061ac <vector174>:
  1061ac:	6a 00                	push   $0x0
  1061ae:	68 ae 00 00 00       	push   $0xae
  1061b3:	e9 f8 f5 ff ff       	jmp    1057b0 <alltraps>

001061b8 <vector175>:
  1061b8:	6a 00                	push   $0x0
  1061ba:	68 af 00 00 00       	push   $0xaf
  1061bf:	e9 ec f5 ff ff       	jmp    1057b0 <alltraps>

001061c4 <vector176>:
  1061c4:	6a 00                	push   $0x0
  1061c6:	68 b0 00 00 00       	push   $0xb0
  1061cb:	e9 e0 f5 ff ff       	jmp    1057b0 <alltraps>

001061d0 <vector177>:
  1061d0:	6a 00                	push   $0x0
  1061d2:	68 b1 00 00 00       	push   $0xb1
  1061d7:	e9 d4 f5 ff ff       	jmp    1057b0 <alltraps>

001061dc <vector178>:
  1061dc:	6a 00                	push   $0x0
  1061de:	68 b2 00 00 00       	push   $0xb2
  1061e3:	e9 c8 f5 ff ff       	jmp    1057b0 <alltraps>

001061e8 <vector179>:
  1061e8:	6a 00                	push   $0x0
  1061ea:	68 b3 00 00 00       	push   $0xb3
  1061ef:	e9 bc f5 ff ff       	jmp    1057b0 <alltraps>

001061f4 <vector180>:
  1061f4:	6a 00                	push   $0x0
  1061f6:	68 b4 00 00 00       	push   $0xb4
  1061fb:	e9 b0 f5 ff ff       	jmp    1057b0 <alltraps>

00106200 <vector181>:
  106200:	6a 00                	push   $0x0
  106202:	68 b5 00 00 00       	push   $0xb5
  106207:	e9 a4 f5 ff ff       	jmp    1057b0 <alltraps>

0010620c <vector182>:
  10620c:	6a 00                	push   $0x0
  10620e:	68 b6 00 00 00       	push   $0xb6
  106213:	e9 98 f5 ff ff       	jmp    1057b0 <alltraps>

00106218 <vector183>:
  106218:	6a 00                	push   $0x0
  10621a:	68 b7 00 00 00       	push   $0xb7
  10621f:	e9 8c f5 ff ff       	jmp    1057b0 <alltraps>

00106224 <vector184>:
  106224:	6a 00                	push   $0x0
  106226:	68 b8 00 00 00       	push   $0xb8
  10622b:	e9 80 f5 ff ff       	jmp    1057b0 <alltraps>

00106230 <vector185>:
  106230:	6a 00                	push   $0x0
  106232:	68 b9 00 00 00       	push   $0xb9
  106237:	e9 74 f5 ff ff       	jmp    1057b0 <alltraps>

0010623c <vector186>:
  10623c:	6a 00                	push   $0x0
  10623e:	68 ba 00 00 00       	push   $0xba
  106243:	e9 68 f5 ff ff       	jmp    1057b0 <alltraps>

00106248 <vector187>:
  106248:	6a 00                	push   $0x0
  10624a:	68 bb 00 00 00       	push   $0xbb
  10624f:	e9 5c f5 ff ff       	jmp    1057b0 <alltraps>

00106254 <vector188>:
  106254:	6a 00                	push   $0x0
  106256:	68 bc 00 00 00       	push   $0xbc
  10625b:	e9 50 f5 ff ff       	jmp    1057b0 <alltraps>

00106260 <vector189>:
  106260:	6a 00                	push   $0x0
  106262:	68 bd 00 00 00       	push   $0xbd
  106267:	e9 44 f5 ff ff       	jmp    1057b0 <alltraps>

0010626c <vector190>:
  10626c:	6a 00                	push   $0x0
  10626e:	68 be 00 00 00       	push   $0xbe
  106273:	e9 38 f5 ff ff       	jmp    1057b0 <alltraps>

00106278 <vector191>:
  106278:	6a 00                	push   $0x0
  10627a:	68 bf 00 00 00       	push   $0xbf
  10627f:	e9 2c f5 ff ff       	jmp    1057b0 <alltraps>

00106284 <vector192>:
  106284:	6a 00                	push   $0x0
  106286:	68 c0 00 00 00       	push   $0xc0
  10628b:	e9 20 f5 ff ff       	jmp    1057b0 <alltraps>

00106290 <vector193>:
  106290:	6a 00                	push   $0x0
  106292:	68 c1 00 00 00       	push   $0xc1
  106297:	e9 14 f5 ff ff       	jmp    1057b0 <alltraps>

0010629c <vector194>:
  10629c:	6a 00                	push   $0x0
  10629e:	68 c2 00 00 00       	push   $0xc2
  1062a3:	e9 08 f5 ff ff       	jmp    1057b0 <alltraps>

001062a8 <vector195>:
  1062a8:	6a 00                	push   $0x0
  1062aa:	68 c3 00 00 00       	push   $0xc3
  1062af:	e9 fc f4 ff ff       	jmp    1057b0 <alltraps>

001062b4 <vector196>:
  1062b4:	6a 00                	push   $0x0
  1062b6:	68 c4 00 00 00       	push   $0xc4
  1062bb:	e9 f0 f4 ff ff       	jmp    1057b0 <alltraps>

001062c0 <vector197>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	68 c5 00 00 00       	push   $0xc5
  1062c7:	e9 e4 f4 ff ff       	jmp    1057b0 <alltraps>

001062cc <vector198>:
  1062cc:	6a 00                	push   $0x0
  1062ce:	68 c6 00 00 00       	push   $0xc6
  1062d3:	e9 d8 f4 ff ff       	jmp    1057b0 <alltraps>

001062d8 <vector199>:
  1062d8:	6a 00                	push   $0x0
  1062da:	68 c7 00 00 00       	push   $0xc7
  1062df:	e9 cc f4 ff ff       	jmp    1057b0 <alltraps>

001062e4 <vector200>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	68 c8 00 00 00       	push   $0xc8
  1062eb:	e9 c0 f4 ff ff       	jmp    1057b0 <alltraps>

001062f0 <vector201>:
  1062f0:	6a 00                	push   $0x0
  1062f2:	68 c9 00 00 00       	push   $0xc9
  1062f7:	e9 b4 f4 ff ff       	jmp    1057b0 <alltraps>

001062fc <vector202>:
  1062fc:	6a 00                	push   $0x0
  1062fe:	68 ca 00 00 00       	push   $0xca
  106303:	e9 a8 f4 ff ff       	jmp    1057b0 <alltraps>

00106308 <vector203>:
  106308:	6a 00                	push   $0x0
  10630a:	68 cb 00 00 00       	push   $0xcb
  10630f:	e9 9c f4 ff ff       	jmp    1057b0 <alltraps>

00106314 <vector204>:
  106314:	6a 00                	push   $0x0
  106316:	68 cc 00 00 00       	push   $0xcc
  10631b:	e9 90 f4 ff ff       	jmp    1057b0 <alltraps>

00106320 <vector205>:
  106320:	6a 00                	push   $0x0
  106322:	68 cd 00 00 00       	push   $0xcd
  106327:	e9 84 f4 ff ff       	jmp    1057b0 <alltraps>

0010632c <vector206>:
  10632c:	6a 00                	push   $0x0
  10632e:	68 ce 00 00 00       	push   $0xce
  106333:	e9 78 f4 ff ff       	jmp    1057b0 <alltraps>

00106338 <vector207>:
  106338:	6a 00                	push   $0x0
  10633a:	68 cf 00 00 00       	push   $0xcf
  10633f:	e9 6c f4 ff ff       	jmp    1057b0 <alltraps>

00106344 <vector208>:
  106344:	6a 00                	push   $0x0
  106346:	68 d0 00 00 00       	push   $0xd0
  10634b:	e9 60 f4 ff ff       	jmp    1057b0 <alltraps>

00106350 <vector209>:
  106350:	6a 00                	push   $0x0
  106352:	68 d1 00 00 00       	push   $0xd1
  106357:	e9 54 f4 ff ff       	jmp    1057b0 <alltraps>

0010635c <vector210>:
  10635c:	6a 00                	push   $0x0
  10635e:	68 d2 00 00 00       	push   $0xd2
  106363:	e9 48 f4 ff ff       	jmp    1057b0 <alltraps>

00106368 <vector211>:
  106368:	6a 00                	push   $0x0
  10636a:	68 d3 00 00 00       	push   $0xd3
  10636f:	e9 3c f4 ff ff       	jmp    1057b0 <alltraps>

00106374 <vector212>:
  106374:	6a 00                	push   $0x0
  106376:	68 d4 00 00 00       	push   $0xd4
  10637b:	e9 30 f4 ff ff       	jmp    1057b0 <alltraps>

00106380 <vector213>:
  106380:	6a 00                	push   $0x0
  106382:	68 d5 00 00 00       	push   $0xd5
  106387:	e9 24 f4 ff ff       	jmp    1057b0 <alltraps>

0010638c <vector214>:
  10638c:	6a 00                	push   $0x0
  10638e:	68 d6 00 00 00       	push   $0xd6
  106393:	e9 18 f4 ff ff       	jmp    1057b0 <alltraps>

00106398 <vector215>:
  106398:	6a 00                	push   $0x0
  10639a:	68 d7 00 00 00       	push   $0xd7
  10639f:	e9 0c f4 ff ff       	jmp    1057b0 <alltraps>

001063a4 <vector216>:
  1063a4:	6a 00                	push   $0x0
  1063a6:	68 d8 00 00 00       	push   $0xd8
  1063ab:	e9 00 f4 ff ff       	jmp    1057b0 <alltraps>

001063b0 <vector217>:
  1063b0:	6a 00                	push   $0x0
  1063b2:	68 d9 00 00 00       	push   $0xd9
  1063b7:	e9 f4 f3 ff ff       	jmp    1057b0 <alltraps>

001063bc <vector218>:
  1063bc:	6a 00                	push   $0x0
  1063be:	68 da 00 00 00       	push   $0xda
  1063c3:	e9 e8 f3 ff ff       	jmp    1057b0 <alltraps>

001063c8 <vector219>:
  1063c8:	6a 00                	push   $0x0
  1063ca:	68 db 00 00 00       	push   $0xdb
  1063cf:	e9 dc f3 ff ff       	jmp    1057b0 <alltraps>

001063d4 <vector220>:
  1063d4:	6a 00                	push   $0x0
  1063d6:	68 dc 00 00 00       	push   $0xdc
  1063db:	e9 d0 f3 ff ff       	jmp    1057b0 <alltraps>

001063e0 <vector221>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	68 dd 00 00 00       	push   $0xdd
  1063e7:	e9 c4 f3 ff ff       	jmp    1057b0 <alltraps>

001063ec <vector222>:
  1063ec:	6a 00                	push   $0x0
  1063ee:	68 de 00 00 00       	push   $0xde
  1063f3:	e9 b8 f3 ff ff       	jmp    1057b0 <alltraps>

001063f8 <vector223>:
  1063f8:	6a 00                	push   $0x0
  1063fa:	68 df 00 00 00       	push   $0xdf
  1063ff:	e9 ac f3 ff ff       	jmp    1057b0 <alltraps>

00106404 <vector224>:
  106404:	6a 00                	push   $0x0
  106406:	68 e0 00 00 00       	push   $0xe0
  10640b:	e9 a0 f3 ff ff       	jmp    1057b0 <alltraps>

00106410 <vector225>:
  106410:	6a 00                	push   $0x0
  106412:	68 e1 00 00 00       	push   $0xe1
  106417:	e9 94 f3 ff ff       	jmp    1057b0 <alltraps>

0010641c <vector226>:
  10641c:	6a 00                	push   $0x0
  10641e:	68 e2 00 00 00       	push   $0xe2
  106423:	e9 88 f3 ff ff       	jmp    1057b0 <alltraps>

00106428 <vector227>:
  106428:	6a 00                	push   $0x0
  10642a:	68 e3 00 00 00       	push   $0xe3
  10642f:	e9 7c f3 ff ff       	jmp    1057b0 <alltraps>

00106434 <vector228>:
  106434:	6a 00                	push   $0x0
  106436:	68 e4 00 00 00       	push   $0xe4
  10643b:	e9 70 f3 ff ff       	jmp    1057b0 <alltraps>

00106440 <vector229>:
  106440:	6a 00                	push   $0x0
  106442:	68 e5 00 00 00       	push   $0xe5
  106447:	e9 64 f3 ff ff       	jmp    1057b0 <alltraps>

0010644c <vector230>:
  10644c:	6a 00                	push   $0x0
  10644e:	68 e6 00 00 00       	push   $0xe6
  106453:	e9 58 f3 ff ff       	jmp    1057b0 <alltraps>

00106458 <vector231>:
  106458:	6a 00                	push   $0x0
  10645a:	68 e7 00 00 00       	push   $0xe7
  10645f:	e9 4c f3 ff ff       	jmp    1057b0 <alltraps>

00106464 <vector232>:
  106464:	6a 00                	push   $0x0
  106466:	68 e8 00 00 00       	push   $0xe8
  10646b:	e9 40 f3 ff ff       	jmp    1057b0 <alltraps>

00106470 <vector233>:
  106470:	6a 00                	push   $0x0
  106472:	68 e9 00 00 00       	push   $0xe9
  106477:	e9 34 f3 ff ff       	jmp    1057b0 <alltraps>

0010647c <vector234>:
  10647c:	6a 00                	push   $0x0
  10647e:	68 ea 00 00 00       	push   $0xea
  106483:	e9 28 f3 ff ff       	jmp    1057b0 <alltraps>

00106488 <vector235>:
  106488:	6a 00                	push   $0x0
  10648a:	68 eb 00 00 00       	push   $0xeb
  10648f:	e9 1c f3 ff ff       	jmp    1057b0 <alltraps>

00106494 <vector236>:
  106494:	6a 00                	push   $0x0
  106496:	68 ec 00 00 00       	push   $0xec
  10649b:	e9 10 f3 ff ff       	jmp    1057b0 <alltraps>

001064a0 <vector237>:
  1064a0:	6a 00                	push   $0x0
  1064a2:	68 ed 00 00 00       	push   $0xed
  1064a7:	e9 04 f3 ff ff       	jmp    1057b0 <alltraps>

001064ac <vector238>:
  1064ac:	6a 00                	push   $0x0
  1064ae:	68 ee 00 00 00       	push   $0xee
  1064b3:	e9 f8 f2 ff ff       	jmp    1057b0 <alltraps>

001064b8 <vector239>:
  1064b8:	6a 00                	push   $0x0
  1064ba:	68 ef 00 00 00       	push   $0xef
  1064bf:	e9 ec f2 ff ff       	jmp    1057b0 <alltraps>

001064c4 <vector240>:
  1064c4:	6a 00                	push   $0x0
  1064c6:	68 f0 00 00 00       	push   $0xf0
  1064cb:	e9 e0 f2 ff ff       	jmp    1057b0 <alltraps>

001064d0 <vector241>:
  1064d0:	6a 00                	push   $0x0
  1064d2:	68 f1 00 00 00       	push   $0xf1
  1064d7:	e9 d4 f2 ff ff       	jmp    1057b0 <alltraps>

001064dc <vector242>:
  1064dc:	6a 00                	push   $0x0
  1064de:	68 f2 00 00 00       	push   $0xf2
  1064e3:	e9 c8 f2 ff ff       	jmp    1057b0 <alltraps>

001064e8 <vector243>:
  1064e8:	6a 00                	push   $0x0
  1064ea:	68 f3 00 00 00       	push   $0xf3
  1064ef:	e9 bc f2 ff ff       	jmp    1057b0 <alltraps>

001064f4 <vector244>:
  1064f4:	6a 00                	push   $0x0
  1064f6:	68 f4 00 00 00       	push   $0xf4
  1064fb:	e9 b0 f2 ff ff       	jmp    1057b0 <alltraps>

00106500 <vector245>:
  106500:	6a 00                	push   $0x0
  106502:	68 f5 00 00 00       	push   $0xf5
  106507:	e9 a4 f2 ff ff       	jmp    1057b0 <alltraps>

0010650c <vector246>:
  10650c:	6a 00                	push   $0x0
  10650e:	68 f6 00 00 00       	push   $0xf6
  106513:	e9 98 f2 ff ff       	jmp    1057b0 <alltraps>

00106518 <vector247>:
  106518:	6a 00                	push   $0x0
  10651a:	68 f7 00 00 00       	push   $0xf7
  10651f:	e9 8c f2 ff ff       	jmp    1057b0 <alltraps>

00106524 <vector248>:
  106524:	6a 00                	push   $0x0
  106526:	68 f8 00 00 00       	push   $0xf8
  10652b:	e9 80 f2 ff ff       	jmp    1057b0 <alltraps>

00106530 <vector249>:
  106530:	6a 00                	push   $0x0
  106532:	68 f9 00 00 00       	push   $0xf9
  106537:	e9 74 f2 ff ff       	jmp    1057b0 <alltraps>

0010653c <vector250>:
  10653c:	6a 00                	push   $0x0
  10653e:	68 fa 00 00 00       	push   $0xfa
  106543:	e9 68 f2 ff ff       	jmp    1057b0 <alltraps>

00106548 <vector251>:
  106548:	6a 00                	push   $0x0
  10654a:	68 fb 00 00 00       	push   $0xfb
  10654f:	e9 5c f2 ff ff       	jmp    1057b0 <alltraps>

00106554 <vector252>:
  106554:	6a 00                	push   $0x0
  106556:	68 fc 00 00 00       	push   $0xfc
  10655b:	e9 50 f2 ff ff       	jmp    1057b0 <alltraps>

00106560 <vector253>:
  106560:	6a 00                	push   $0x0
  106562:	68 fd 00 00 00       	push   $0xfd
  106567:	e9 44 f2 ff ff       	jmp    1057b0 <alltraps>

0010656c <vector254>:
  10656c:	6a 00                	push   $0x0
  10656e:	68 fe 00 00 00       	push   $0xfe
  106573:	e9 38 f2 ff ff       	jmp    1057b0 <alltraps>

00106578 <vector255>:
  106578:	6a 00                	push   $0x0
  10657a:	68 ff 00 00 00       	push   $0xff
  10657f:	e9 2c f2 ff ff       	jmp    1057b0 <alltraps>
