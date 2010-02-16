
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
  10000f:	c7 04 24 c0 98 10 00 	movl   $0x1098c0,(%esp)
  100016:	e8 65 41 00 00       	call   104180 <acquire>

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
  10002a:	c7 43 0c a0 81 10 00 	movl   $0x1081a0,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  100031:	89 42 10             	mov    %eax,0x10(%edx)
  b->next = bufhead.next;
  100034:	a1 b0 81 10 00       	mov    0x1081b0,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  10003c:	a1 b0 81 10 00       	mov    0x1081b0,%eax
  bufhead.next = b;
  100041:	89 1d b0 81 10 00    	mov    %ebx,0x1081b0

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  10004a:	c7 04 24 c0 83 10 00 	movl   $0x1083c0,(%esp)
  100051:	e8 4a 32 00 00       	call   1032a0 <wakeup>

  release(&buf_table_lock);
  100056:	c7 45 08 c0 98 10 00 	movl   $0x1098c0,0x8(%ebp)
}
  10005d:	83 c4 14             	add    $0x14,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  100062:	e9 d9 40 00 00       	jmp    104140 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100067:	c7 04 24 e0 61 10 00 	movl   $0x1061e0,(%esp)
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
  10009e:	c7 04 24 e7 61 10 00 	movl   $0x1061e7,(%esp)
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
  1000bf:	c7 04 24 c0 98 10 00 	movl   $0x1098c0,(%esp)
  1000c6:	e8 b5 40 00 00       	call   104180 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  1000cb:	8b 1d b0 81 10 00    	mov    0x1081b0,%ebx
  1000d1:	81 fb a0 81 10 00    	cmp    $0x1081a0,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 3d                	jmp    100118 <bread+0x68>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb a0 81 10 00    	cmp    $0x1081a0,%ebx
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
  100102:	c7 44 24 04 c0 98 10 	movl   $0x1098c0,0x4(%esp)
  100109:	00 
  10010a:	c7 04 24 c0 83 10 00 	movl   $0x1083c0,(%esp)
  100111:	e8 ea 34 00 00       	call   103600 <sleep>
  100116:	eb b3                	jmp    1000cb <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100118:	8b 1d ac 81 10 00    	mov    0x1081ac,%ebx
  10011e:	81 fb a0 81 10 00    	cmp    $0x1081a0,%ebx
  100124:	75 0d                	jne    100133 <bread+0x83>
  100126:	eb 3f                	jmp    100167 <bread+0xb7>
  100128:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10012b:	81 fb a0 81 10 00    	cmp    $0x1081a0,%ebx
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
  100144:	c7 04 24 c0 98 10 00 	movl   $0x1098c0,(%esp)
  10014b:	e8 f0 3f 00 00       	call   104140 <release>
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
  100167:	c7 04 24 ee 61 10 00 	movl   $0x1061ee,(%esp)
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
  100178:	c7 04 24 c0 98 10 00 	movl   $0x1098c0,(%esp)
  10017f:	e8 bc 3f 00 00       	call   104140 <release>
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
  100196:	c7 44 24 04 ff 61 10 	movl   $0x1061ff,0x4(%esp)
  10019d:	00 
  10019e:	c7 04 24 c0 98 10 00 	movl   $0x1098c0,(%esp)
  1001a5:	e8 16 3e 00 00       	call   103fc0 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001aa:	b8 b0 98 10 00       	mov    $0x1098b0,%eax
  1001af:	3d c0 83 10 00       	cmp    $0x1083c0,%eax
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  1001b4:	c7 05 ac 81 10 00 a0 	movl   $0x1081a0,0x1081ac
  1001bb:	81 10 00 
  bufhead.next = &bufhead;
  1001be:	c7 05 b0 81 10 00 a0 	movl   $0x1081a0,0x1081b0
  1001c5:	81 10 00 
  for(b = buf; b < buf+NBUF; b++){
  1001c8:	76 33                	jbe    1001fd <binit+0x6d>
// bufhead->next is most recently used.
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
  1001ca:	ba a0 81 10 00       	mov    $0x1081a0,%edx
  1001cf:	b8 c0 83 10 00       	mov    $0x1083c0,%eax
  1001d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  1001d8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bufhead;
  1001db:	c7 40 0c a0 81 10 00 	movl   $0x1081a0,0xc(%eax)
    bufhead.next->prev = b;
  1001e2:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  1001e5:	89 c2                	mov    %eax,%edx
  1001e7:	05 18 02 00 00       	add    $0x218,%eax
  1001ec:	3d b0 98 10 00       	cmp    $0x1098b0,%eax
  1001f1:	75 e5                	jne    1001d8 <binit+0x48>
  1001f3:	c7 05 b0 81 10 00 98 	movl   $0x109698,0x1081b0
  1001fa:	96 10 00 
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
  100206:	c7 44 24 04 09 62 10 	movl   $0x106209,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 00 81 10 00 	movl   $0x108100,(%esp)
  100215:	e8 a6 3d 00 00       	call   103fc0 <initlock>
  initlock(&input.lock, "console input");
  10021a:	c7 44 24 04 11 62 10 	movl   $0x106211,0x4(%esp)
  100221:	00 
  100222:	c7 04 24 00 99 10 00 	movl   $0x109900,(%esp)
  100229:	e8 92 3d 00 00       	call   103fc0 <initlock>

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
  100235:	c7 05 6c a3 10 00 50 	movl   $0x100650,0x10a36c
  10023c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10023f:	c7 05 68 a3 10 00 70 	movl   $0x100270,0x10a368
  100246:	02 10 00 
  use_console_lock = 1;
  100249:	c7 05 e4 80 10 00 01 	movl   $0x1,0x1080e4
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
  10028a:	c7 04 24 00 99 10 00 	movl   $0x109900,(%esp)
  100291:	e8 ea 3e 00 00       	call   104180 <acquire>
  while(n > 0){
  100296:	85 db                	test   %ebx,%ebx
  100298:	7f 26                	jg     1002c0 <console_read+0x50>
  10029a:	e9 bb 00 00 00       	jmp    10035a <console_read+0xea>
  10029f:	90                   	nop
    while(input.r == input.w){
      if(cp->killed){
  1002a0:	e8 fb 30 00 00       	call   1033a0 <curproc>
  1002a5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1002a8:	85 c0                	test   %eax,%eax
  1002aa:	75 5c                	jne    100308 <console_read+0x98>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  1002ac:	c7 44 24 04 00 99 10 	movl   $0x109900,0x4(%esp)
  1002b3:	00 
  1002b4:	c7 04 24 b4 99 10 00 	movl   $0x1099b4,(%esp)
  1002bb:	e8 40 33 00 00       	call   103600 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1002c0:	a1 b4 99 10 00       	mov    0x1099b4,%eax
  1002c5:	3b 05 b8 99 10 00    	cmp    0x1099b8,%eax
  1002cb:	74 d3                	je     1002a0 <console_read+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  1002cd:	89 c2                	mov    %eax,%edx
  1002cf:	83 e2 7f             	and    $0x7f,%edx
  1002d2:	0f b6 8a 34 99 10 00 	movzbl 0x109934(%edx),%ecx
  1002d9:	8d 78 01             	lea    0x1(%eax),%edi
  1002dc:	89 3d b4 99 10 00    	mov    %edi,0x1099b4
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
  100308:	c7 04 24 00 99 10 00 	movl   $0x109900,(%esp)
  10030f:	e8 2c 3e 00 00       	call   104140 <release>
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
  10032e:	a3 b4 99 10 00       	mov    %eax,0x1099b4
  100333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100336:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  100338:	c7 04 24 00 99 10 00 	movl   $0x109900,(%esp)
  10033f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  100342:	e8 f9 3d 00 00       	call   104140 <release>
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
  10036c:	83 3d e0 80 10 00 00 	cmpl   $0x0,0x1080e0
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
  100488:	e8 f3 3d 00 00       	call   104280 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  10048d:	b8 80 07 00 00       	mov    $0x780,%eax
  100492:	29 d8                	sub    %ebx,%eax
  100494:	01 c0                	add    %eax,%eax
  100496:	89 44 24 08          	mov    %eax,0x8(%esp)
  10049a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1004a1:	00 
  1004a2:	89 34 24             	mov    %esi,(%esp)
  1004a5:	e8 46 3d 00 00       	call   1041f0 <memset>
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
  1004f4:	be 30 99 10 00       	mov    $0x109930,%esi

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  1004f9:	53                   	push   %ebx
  1004fa:	83 ec 20             	sub    $0x20,%esp
  1004fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c;

  acquire(&input.lock);
  100500:	c7 04 24 00 99 10 00 	movl   $0x109900,(%esp)
  100507:	e8 74 3c 00 00       	call   104180 <acquire>
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
  10053c:	8b 15 bc 99 10 00    	mov    0x1099bc,%edx
  100542:	89 d1                	mov    %edx,%ecx
  100544:	2b 0d b4 99 10 00    	sub    0x1099b4,%ecx
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
  100561:	89 15 bc 99 10 00    	mov    %edx,0x1099bc
        cons_putc(c);
  100567:	e8 f4 fd ff ff       	call   100360 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10056c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10056f:	83 f8 04             	cmp    $0x4,%eax
  100572:	0f 84 ba 00 00 00    	je     100632 <console_intr+0x142>
  100578:	83 f8 0a             	cmp    $0xa,%eax
  10057b:	0f 84 b1 00 00 00    	je     100632 <console_intr+0x142>
  100581:	8b 15 b4 99 10 00    	mov    0x1099b4,%edx
  100587:	a1 bc 99 10 00       	mov    0x1099bc,%eax
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
  1005a8:	c7 45 08 00 99 10 00 	movl   $0x109900,0x8(%ebp)
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
  1005b5:	e9 86 3b 00 00       	jmp    104140 <release>
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
  1005c8:	80 ba 34 99 10 00 0a 	cmpb   $0xa,0x109934(%edx)
  1005cf:	0f 84 3b ff ff ff    	je     100510 <console_intr+0x20>
        input.e--;
  1005d5:	a3 bc 99 10 00       	mov    %eax,0x1099bc
        cons_putc(BACKSPACE);
  1005da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1005e1:	e8 7a fd ff ff       	call   100360 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1005e6:	a1 bc 99 10 00       	mov    0x1099bc,%eax
  1005eb:	3b 05 b8 99 10 00    	cmp    0x1099b8,%eax
  1005f1:	75 cd                	jne    1005c0 <console_intr+0xd0>
  1005f3:	e9 18 ff ff ff       	jmp    100510 <console_intr+0x20>

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  1005f8:	e8 43 2b 00 00       	call   103140 <procdump>
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
  100608:	a1 bc 99 10 00       	mov    0x1099bc,%eax
  10060d:	3b 05 b8 99 10 00    	cmp    0x1099b8,%eax
  100613:	0f 84 f7 fe ff ff    	je     100510 <console_intr+0x20>
        input.e--;
  100619:	83 e8 01             	sub    $0x1,%eax
  10061c:	a3 bc 99 10 00       	mov    %eax,0x1099bc
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
  100632:	a1 bc 99 10 00       	mov    0x1099bc,%eax
          input.w = input.e;
  100637:	a3 b8 99 10 00       	mov    %eax,0x1099b8
          wakeup(&input.r);
  10063c:	c7 04 24 b4 99 10 00 	movl   $0x1099b4,(%esp)
  100643:	e8 58 2c 00 00       	call   1032a0 <wakeup>
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
  10066a:	c7 04 24 00 81 10 00 	movl   $0x108100,(%esp)
  100671:	e8 0a 3b 00 00       	call   104180 <acquire>
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
  100693:	c7 04 24 00 81 10 00 	movl   $0x108100,(%esp)
  10069a:	e8 a1 3a 00 00       	call   104140 <release>
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
  1006ec:	0f b6 92 39 62 10 00 	movzbl 0x106239(%edx),%edx
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
  100749:	a1 e4 80 10 00       	mov    0x1080e4,%eax
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
  1007ef:	c7 04 24 00 81 10 00 	movl   $0x108100,(%esp)
  1007f6:	e8 45 39 00 00       	call   104140 <release>
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
  1008c0:	c7 04 24 00 81 10 00 	movl   $0x108100,(%esp)
  1008c7:	e8 b4 38 00 00       	call   104180 <acquire>
  1008cc:	e9 88 fe ff ff       	jmp    100759 <cprintf+0x19>
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
  1008d1:	be 1f 62 10 00       	mov    $0x10621f,%esi
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
  1008e8:	c7 05 e4 80 10 00 00 	movl   $0x0,0x1080e4
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
  1008fd:	c7 04 24 26 62 10 00 	movl   $0x106226,(%esp)
  100904:	89 44 24 04          	mov    %eax,0x4(%esp)
  100908:	e8 33 fe ff ff       	call   100740 <cprintf>
  cprintf(s);
  10090d:	8b 45 08             	mov    0x8(%ebp),%eax
  100910:	89 04 24             	mov    %eax,(%esp)
  100913:	e8 28 fe ff ff       	call   100740 <cprintf>
  cprintf("\n");
  100918:	c7 04 24 73 66 10 00 	movl   $0x106673,(%esp)
  10091f:	e8 1c fe ff ff       	call   100740 <cprintf>
  getcallerpcs(&s, pcs);
  100924:	8d 45 08             	lea    0x8(%ebp),%eax
  100927:	89 74 24 04          	mov    %esi,0x4(%esp)
  10092b:	89 04 24             	mov    %eax,(%esp)
  10092e:	e8 ad 36 00 00       	call   103fe0 <getcallerpcs>
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
  10093e:	c7 04 24 35 62 10 00 	movl   $0x106235,(%esp)
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
  100953:	c7 05 e0 80 10 00 01 	movl   $0x1,0x1080e0
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
  100a6e:	e8 5d 39 00 00       	call   1043d0 <strlen>
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
  100adb:	e8 10 37 00 00       	call   1041f0 <memset>

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
  100b88:	e8 63 36 00 00       	call   1041f0 <memset>
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
  100c06:	e8 c5 37 00 00       	call   1043d0 <strlen>
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
  100c25:	e8 56 36 00 00       	call   104280 <memmove>
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
  100c8b:	e8 10 27 00 00       	call   1033a0 <curproc>
  100c90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100c94:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100c9b:	00 
  100c9c:	05 88 00 00 00       	add    $0x88,%eax
  100ca1:	89 04 24             	mov    %eax,(%esp)
  100ca4:	e8 e7 36 00 00       	call   104390 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100ca9:	e8 f2 26 00 00       	call   1033a0 <curproc>
  100cae:	8b 58 04             	mov    0x4(%eax),%ebx
  100cb1:	e8 ea 26 00 00       	call   1033a0 <curproc>
  100cb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cba:	8b 00                	mov    (%eax),%eax
  100cbc:	89 04 24             	mov    %eax,(%esp)
  100cbf:	e8 dc 16 00 00       	call   1023a0 <kfree>
  cp->mem = mem;
  100cc4:	e8 d7 26 00 00       	call   1033a0 <curproc>
  100cc9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  100ccc:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cce:	e8 cd 26 00 00       	call   1033a0 <curproc>
  100cd3:	8b 4d 80             	mov    -0x80(%ebp),%ecx
  100cd6:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100cd9:	e8 c2 26 00 00       	call   1033a0 <curproc>
  100cde:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100ce1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100ce7:	89 50 30             	mov    %edx,0x30(%eax)
  cp->tf->esp = sp;
  100cea:	e8 b1 26 00 00       	call   1033a0 <curproc>
  100cef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100cf5:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100cf8:	e8 a3 26 00 00       	call   1033a0 <curproc>
  100cfd:	89 04 24             	mov    %eax,(%esp)
  100d00:	e8 1b 2b 00 00       	call   103820 <setupsegs>
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
  100df7:	c7 04 24 4a 62 10 00 	movl   $0x10624a,(%esp)
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
  100ea7:	c7 04 24 54 62 10 00 	movl   $0x106254,(%esp)
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
  100f1a:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  100f21:	e8 5a 32 00 00       	call   104180 <acquire>
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
  100f39:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  100f40:	e8 fb 31 00 00       	call   104140 <release>
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
  100f4d:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
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
  100f67:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  100f6e:	e8 0d 32 00 00       	call   104180 <acquire>
  100f73:	ba c0 99 10 00       	mov    $0x1099c0,%edx
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
  100f9b:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  int i;

  acquire(&file_table_lock);
  for(i = 0; i < NFILE; i++){
    if(file[i].type == FD_CLOSED){
      file[i].type = FD_NONE;
  100fa2:	c7 04 d5 c0 99 10 00 	movl   $0x1,0x1099c0(,%edx,8)
  100fa9:	01 00 00 00 
      file[i].ref = 1;
  100fad:	c7 04 d5 c4 99 10 00 	movl   $0x1,0x1099c4(,%edx,8)
  100fb4:	01 00 00 00 
      release(&file_table_lock);
  100fb8:	e8 83 31 00 00       	call   104140 <release>
      return file + i;
  100fbd:	8d 83 c0 99 10 00    	lea    0x1099c0(%ebx),%eax
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
  100fd0:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  100fd7:	e8 64 31 00 00       	call   104140 <release>
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
  101002:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  101009:	e8 72 31 00 00       	call   104180 <acquire>
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
  10102d:	c7 45 08 20 a3 10 00 	movl   $0x10a320,0x8(%ebp)
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
  101040:	e9 fb 30 00 00       	jmp    104140 <release>
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
  101067:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  10106e:	e8 cd 30 00 00       	call   104140 <release>
  
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
  1010b8:	c7 04 24 65 62 10 00 	movl   $0x106265,(%esp)
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
  1010d6:	c7 44 24 04 6f 62 10 	movl   $0x10626f,0x4(%esp)
  1010dd:	00 
  1010de:	c7 04 24 20 a3 10 00 	movl   $0x10a320,(%esp)
  1010e5:	e8 d6 2e 00 00       	call   103fc0 <initlock>
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
  10112a:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101131:	e8 4a 30 00 00       	call   104180 <acquire>
  ip->ref++;
  101136:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10113a:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101141:	e8 fa 2f 00 00       	call   104140 <release>
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
  10115f:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101166:	e8 15 30 00 00       	call   104180 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  10116b:	b8 f4 a3 10 00       	mov    $0x10a3f4,%eax
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
  10117f:	3d 94 b3 10 00       	cmp    $0x10b394,%eax
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
  10119c:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  1011a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1011a6:	e8 95 2f 00 00       	call   104140 <release>
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
  1011c1:	3d 94 b3 10 00       	cmp    $0x10b394,%eax
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
  1011df:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  1011e6:	e8 55 2f 00 00       	call   104140 <release>

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
  1011f5:	c7 04 24 7a 62 10 00 	movl   $0x10627a,(%esp)
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
  101242:	e8 39 30 00 00       	call   104280 <memmove>
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
  10131b:	c7 04 24 8a 62 10 00 	movl   $0x10628a,(%esp)
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
  101403:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
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
  10145b:	8b 04 c5 60 a3 10 00 	mov    0x10a360(,%eax,8),%eax
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
  1014f7:	e8 84 2d 00 00       	call   104280 <memmove>
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
  10158b:	e8 f0 2c 00 00       	call   104280 <memmove>
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
  10165a:	e8 21 2c 00 00       	call   104280 <memmove>
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
  1016be:	8b 04 c5 64 a3 10 00 	mov    0x10a364(,%eax,8),%eax
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
  1016fb:	e8 e0 2b 00 00       	call   1042e0 <strncmp>
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
  101803:	c7 04 24 b3 62 10 00 	movl   $0x1062b3,(%esp)
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
  10189b:	e8 50 29 00 00       	call   1041f0 <memset>
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
  1018cc:	c7 04 24 c5 62 10 00 	movl   $0x1062c5,(%esp)
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
  101911:	e8 da 28 00 00       	call   1041f0 <memset>
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
  101992:	c7 04 24 d7 62 10 00 	movl   $0x1062d7,(%esp)
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
  1019ac:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  1019b3:	e8 c8 27 00 00       	call   104180 <acquire>
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
  1019f1:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  1019f8:	e8 43 27 00 00       	call   104140 <release>
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
  101a47:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101a4e:	e8 2d 27 00 00       	call   104180 <acquire>
    ip->flags &= ~I_BUSY;
  101a53:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101a57:	89 34 24             	mov    %esi,(%esp)
  101a5a:	e8 41 18 00 00       	call   1032a0 <wakeup>
  101a5f:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
  101a62:	83 e8 01             	sub    $0x1,%eax
  101a65:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101a68:	c7 45 08 c0 a3 10 00 	movl   $0x10a3c0,0x8(%ebp)
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
  101a76:	e9 c5 26 00 00       	jmp    104140 <release>
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
  101ad5:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
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
  101b71:	e8 ca 27 00 00       	call   104340 <strncpy>
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
  101bba:	c7 04 24 f4 62 10 00 	movl   $0x1062f4,(%esp)
  101bc1:	e8 1a ed ff ff       	call   1008e0 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101bc6:	c7 04 24 01 63 10 00 	movl   $0x106301,(%esp)
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
  101bfb:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101c02:	e8 79 25 00 00       	call   104180 <acquire>
  ip->flags &= ~I_BUSY;
  101c07:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101c0b:	89 1c 24             	mov    %ebx,(%esp)
  101c0e:	e8 8d 16 00 00       	call   1032a0 <wakeup>
  release(&icache.lock);
  101c13:	c7 45 08 c0 a3 10 00 	movl   $0x10a3c0,0x8(%ebp)
}
  101c1a:	83 c4 14             	add    $0x14,%esp
  101c1d:	5b                   	pop    %ebx
  101c1e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101c1f:	e9 1c 25 00 00       	jmp    104140 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101c24:	c7 04 24 09 63 10 00 	movl   $0x106309,(%esp)
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
  101c6e:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101c75:	e8 06 25 00 00       	call   104180 <acquire>
  while(ip->flags & I_BUSY)
  101c7a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101c7d:	a8 01                	test   $0x1,%al
  101c7f:	74 1e                	je     101c9f <ilock+0x4f>
  101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101c88:	c7 44 24 04 c0 a3 10 	movl   $0x10a3c0,0x4(%esp)
  101c8f:	00 
  101c90:	89 1c 24             	mov    %ebx,(%esp)
  101c93:	e8 68 19 00 00       	call   103600 <sleep>

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
  101ca5:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101cac:	e8 8f 24 00 00       	call   104140 <release>

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
  101d20:	e8 5b 25 00 00       	call   104280 <memmove>
    brelse(bp);
  101d25:	89 34 24             	mov    %esi,(%esp)
  101d28:	e8 d3 e2 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101d2d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101d31:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101d36:	0f 85 7b ff ff ff    	jne    101cb7 <ilock+0x67>
      panic("ilock: no type");
  101d3c:	c7 04 24 17 63 10 00 	movl   $0x106317,(%esp)
  101d43:	e8 98 eb ff ff       	call   1008e0 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101d48:	c7 04 24 11 63 10 00 	movl   $0x106311,(%esp)
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
  101d7a:	e8 21 16 00 00       	call   1033a0 <curproc>
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
  101df2:	e8 89 24 00 00       	call   104280 <memmove>
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
  101e87:	e8 f4 23 00 00       	call   104280 <memmove>
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
  101f36:	c7 44 24 04 26 63 10 	movl   $0x106326,0x4(%esp)
  101f3d:	00 
  101f3e:	c7 04 24 c0 a3 10 00 	movl   $0x10a3c0,(%esp)
  101f45:	e8 76 20 00 00       	call   103fc0 <initlock>
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
  101fea:	c7 04 24 32 63 10 00 	movl   $0x106332,(%esp)
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
  102027:	a1 78 81 10 00       	mov    0x108178,%eax
  10202c:	85 c0                	test   %eax,%eax
  10202e:	0f 84 7c 00 00 00    	je     1020b0 <ide_rw+0xb0>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102034:	c7 04 24 40 81 10 00 	movl   $0x108140,(%esp)
  10203b:	e8 40 21 00 00       	call   104180 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  102040:	a1 74 81 10 00       	mov    0x108174,%eax
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102045:	ba 74 81 10 00       	mov    $0x108174,%edx
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
  102064:	39 1d 74 81 10 00    	cmp    %ebx,0x108174
  10206a:	75 14                	jne    102080 <ide_rw+0x80>
  10206c:	eb 2d                	jmp    10209b <ide_rw+0x9b>
  10206e:	66 90                	xchg   %ax,%ax
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102070:	c7 44 24 04 40 81 10 	movl   $0x108140,0x4(%esp)
  102077:	00 
  102078:	89 1c 24             	mov    %ebx,(%esp)
  10207b:	e8 80 15 00 00       	call   103600 <sleep>
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
  10208a:	c7 45 08 40 81 10 00 	movl   $0x108140,0x8(%ebp)
}
  102091:	83 c4 14             	add    $0x14,%esp
  102094:	5b                   	pop    %ebx
  102095:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102096:	e9 a5 20 00 00       	jmp    104140 <release>
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
  1020a4:	c7 04 24 44 63 10 00 	movl   $0x106344,(%esp)
  1020ab:	e8 30 e8 ff ff       	call   1008e0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1020b0:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  1020b7:	e8 24 e8 ff ff       	call   1008e0 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1020bc:	c7 04 24 59 63 10 00 	movl   $0x106359,(%esp)
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
  1020d8:	c7 04 24 40 81 10 00 	movl   $0x108140,(%esp)
  1020df:	e8 9c 20 00 00       	call   104180 <acquire>
  if((b = ide_queue) == 0){
  1020e4:	8b 1d 74 81 10 00    	mov    0x108174,%ebx
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
  102100:	e8 9b 11 00 00       	call   1032a0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102105:	8b 43 14             	mov    0x14(%ebx),%eax
  102108:	85 c0                	test   %eax,%eax
  10210a:	a3 74 81 10 00       	mov    %eax,0x108174
  10210f:	74 05                	je     102116 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102111:	e8 3a fe ff ff       	call   101f50 <ide_start_request>

  release(&ide_lock);
  102116:	c7 04 24 40 81 10 00 	movl   $0x108140,(%esp)
  10211d:	e8 1e 20 00 00       	call   104140 <release>
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
  102166:	c7 44 24 04 86 63 10 	movl   $0x106386,0x4(%esp)
  10216d:	00 
  10216e:	c7 04 24 40 81 10 00 	movl   $0x108140,(%esp)
  102175:	e8 46 1e 00 00       	call   103fc0 <initlock>
  pic_enable(IRQ_IDE);
  10217a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102181:	e8 8a 0b 00 00       	call   102d10 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102186:	a1 60 ba 10 00       	mov    0x10ba60,%eax
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
  1021d8:	c7 05 78 81 10 00 01 	movl   $0x1,0x108178
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
  1021f0:	8b 15 e0 b3 10 00    	mov    0x10b3e0,%edx
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
  102207:	a1 94 b3 10 00       	mov    0x10b394,%eax
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
  102238:	8b 0d e0 b3 10 00    	mov    0x10b3e0,%ecx
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
  10226b:	0f b6 0d e4 b3 10 00 	movzbl 0x10b3e4,%ecx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102272:	c7 05 94 b3 10 00 00 	movl   $0xfec00000,0x10b394
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
  10228c:	c7 04 24 8c 63 10 00 	movl   $0x10638c,(%esp)
  102293:	e8 a8 e4 ff ff       	call   100740 <cprintf>
  102298:	a1 94 b3 10 00       	mov    0x10b394,%eax
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
  1022f3:	c7 04 24 c0 63 10 00 	movl   $0x1063c0,(%esp)
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
  102304:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  10230b:	e8 70 1e 00 00       	call   104180 <acquire>
  102310:	8b 1d d4 b3 10 00    	mov    0x10b3d4,%ebx
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102316:	85 db                	test   %ebx,%ebx
  102318:	74 3e                	je     102358 <kalloc+0x78>
    if(r->len == n){
  10231a:	8b 43 04             	mov    0x4(%ebx),%eax
  10231d:	ba d4 b3 10 00       	mov    $0x10b3d4,%edx
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
  102342:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  102349:	e8 f2 1d 00 00       	call   104140 <release>
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
  10235a:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  102361:	e8 da 1d 00 00       	call   104140 <release>

  cprintf("kalloc: out of memory\n");
  102366:	c7 04 24 c7 63 10 00 	movl   $0x1063c7,(%esp)
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
  102384:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  10238b:	e8 b0 1d 00 00       	call   104140 <release>
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
  1023d7:	e8 14 1e 00 00       	call   1041f0 <memset>

  acquire(&kalloc_lock);
  1023dc:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  1023e3:	e8 98 1d 00 00       	call   104180 <acquire>
  p = (struct run*)v;
  1023e8:	a1 d4 b3 10 00       	mov    0x10b3d4,%eax
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
  10242e:	c7 04 24 e4 63 10 00 	movl   $0x1063e4,(%esp)
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
  102452:	bf d4 b3 10 00       	mov    $0x10b3d4,%edi
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
  102462:	c7 45 08 a0 b3 10 00 	movl   $0x10b3a0,0x8(%ebp)
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
  102470:	e9 cb 1c 00 00       	jmp    104140 <release>
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
  10249c:	bf d4 b3 10 00       	mov    $0x10b3d4,%edi
  1024a1:	eb a1                	jmp    102444 <kfree+0xa4>
kfree(char *v, int len)
{
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
    panic("kfree");
  1024a3:	c7 04 24 de 63 10 00 	movl   $0x1063de,(%esp)
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
  1024b6:	c7 44 24 04 c0 63 10 	movl   $0x1063c0,0x4(%esp)
  1024bd:	00 
  1024be:	c7 04 24 a0 b3 10 00 	movl   $0x10b3a0,(%esp)
  1024c5:	e8 f6 1a 00 00       	call   103fc0 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1024ca:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024d1:	00 
  1024d2:	c7 04 24 f6 63 10 00 	movl   $0x1063f6,(%esp)
  1024d9:	e8 62 e2 ff ff       	call   100740 <cprintf>
  kfree(start, mem * PAGE);
  1024de:	b8 04 fa 10 00       	mov    $0x10fa04,%eax
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
  10252d:	8b 15 7c 81 10 00    	mov    0x10817c,%edx
  102533:	f6 c2 40             	test   $0x40,%dl
  102536:	75 03                	jne    10253b <kbd_getc+0x3b>
  102538:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10253b:	0f b6 80 00 64 10 00 	movzbl 0x106400(%eax),%eax
  102542:	83 c8 40             	or     $0x40,%eax
  102545:	0f b6 c0             	movzbl %al,%eax
  102548:	f7 d0                	not    %eax
  10254a:	21 d0                	and    %edx,%eax
  10254c:	a3 7c 81 10 00       	mov    %eax,0x10817c
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
  102558:	8b 0d 7c 81 10 00    	mov    0x10817c,%ecx
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
  102568:	0f b6 90 00 64 10 00 	movzbl 0x106400(%eax),%edx
  10256f:	09 ca                	or     %ecx,%edx
  102571:	0f b6 88 00 65 10 00 	movzbl 0x106500(%eax),%ecx
  102578:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  10257a:	89 d1                	mov    %edx,%ecx
  10257c:	83 e1 03             	and    $0x3,%ecx
  10257f:	8b 0c 8d 00 66 10 00 	mov    0x106600(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102586:	89 15 7c 81 10 00    	mov    %edx,0x10817c
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
  1025aa:	83 0d 7c 81 10 00 40 	orl    $0x40,0x10817c
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
  1025f0:	a1 d8 b3 10 00       	mov    0x10b3d8,%eax
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
  1026e0:	a1 d8 b3 10 00       	mov    0x10b3d8,%eax
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
  102723:	8b 15 d8 b3 10 00    	mov    0x10b3d8,%edx
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
  10287d:	a1 80 81 10 00       	mov    0x108180,%eax
  102882:	8d 50 01             	lea    0x1(%eax),%edx
  102885:	85 c0                	test   %eax,%eax
  102887:	89 15 80 81 10 00    	mov    %edx,0x108180
  10288d:	74 19                	je     1028a8 <cpu+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10288f:	8b 15 d8 b3 10 00    	mov    0x10b3d8,%edx
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
  1028ad:	c7 04 24 10 66 10 00 	movl   $0x106610,(%esp)
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
  1028cc:	c7 04 24 3c 66 10 00 	movl   $0x10663c,(%esp)
  1028d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028d7:	e8 64 de ff ff       	call   100740 <cprintf>
  idtinit();
  1028dc:	e8 3f 2b 00 00       	call   105420 <idtinit>
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
  102905:	e8 16 0f 00 00       	call   103820 <setupsegs>
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
  102920:	f0 87 82 00 b4 10 00 	lock xchg %eax,0x10b400(%edx)

  cprintf("cpu%d: scheduling\n", cpu());
  102927:	e8 44 ff ff ff       	call   102870 <cpu>
  10292c:	c7 04 24 4b 66 10 00 	movl   $0x10664b,(%esp)
  102933:	89 44 24 04          	mov    %eax,0x4(%esp)
  102937:	e8 04 de ff ff       	call   100740 <cprintf>
  scheduler();
  10293c:	e8 bf 10 00 00       	call   103a00 <scheduler>
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
  102951:	b8 04 ea 10 00       	mov    $0x10ea04,%eax
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
  10295c:	2d ce 80 10 00       	sub    $0x1080ce,%eax
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
  102970:	c7 04 24 ce 80 10 00 	movl   $0x1080ce,(%esp)
  102977:	e8 74 18 00 00       	call   1041f0 <memset>

  mp_init(); // collect info about this machine
  10297c:	e8 bf 01 00 00       	call   102b40 <mp_init>
  lapic_init(mp_bcpu());
  102981:	e8 2a 01 00 00       	call   102ab0 <mp_bcpu>
  102986:	89 04 24             	mov    %eax,(%esp)
  102989:	e8 62 fc ff ff       	call   1025f0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  10298e:	e8 dd fe ff ff       	call   102870 <cpu>
  102993:	c7 04 24 5e 66 10 00 	movl   $0x10665e,(%esp)
  10299a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10299e:	e8 9d dd ff ff       	call   100740 <cprintf>

  pinit();         // process table
  1029a3:	e8 f8 15 00 00       	call   103fa0 <pinit>
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
  1029c0:	e8 0b 2d 00 00       	call   1056d0 <tvinit>
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
  1029da:	a1 e0 b3 10 00       	mov    0x10b3e0,%eax
  1029df:	85 c0                	test   %eax,%eax
  1029e1:	0f 84 b1 00 00 00    	je     102a98 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  1029e7:	e8 c4 14 00 00       	call   103eb0 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  1029ec:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  1029f3:	00 
  1029f4:	c7 44 24 04 74 80 10 	movl   $0x108074,0x4(%esp)
  1029fb:	00 
  1029fc:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102a03:	e8 78 18 00 00       	call   104280 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102a08:	69 05 60 ba 10 00 cc 	imul   $0xcc,0x10ba60,%eax
  102a0f:	00 00 00 
  102a12:	05 00 b4 10 00       	add    $0x10b400,%eax
  102a17:	3d 00 b4 10 00       	cmp    $0x10b400,%eax
  102a1c:	76 75                	jbe    102a93 <main+0x143>
  102a1e:	bb 00 b4 10 00       	mov    $0x10b400,%ebx
  102a23:	90                   	nop
  102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpu())  // We've started already.
  102a28:	e8 43 fe ff ff       	call   102870 <cpu>
  102a2d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102a33:	05 00 b4 10 00       	add    $0x10b400,%eax
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
  102a7a:	69 05 60 ba 10 00 cc 	imul   $0xcc,0x10ba60,%eax
  102a81:	00 00 00 
  102a84:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102a8a:	05 00 b4 10 00       	add    $0x10b400,%eax
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
  102a98:	e8 23 29 00 00       	call   1053c0 <timer_init>
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
  102ab0:	a1 84 81 10 00       	mov    0x108184,%eax
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
  102ab9:	2d 00 b4 10 00       	sub    $0x10b400,%eax
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
  102af0:	c7 44 24 04 75 66 10 	movl   $0x106675,0x4(%esp)
  102af7:	00 
  102af8:	89 1c 24             	mov    %ebx,(%esp)
  102afb:	e8 20 17 00 00       	call   104220 <memcmp>
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
  102b50:	69 05 60 ba 10 00 cc 	imul   $0xcc,0x10ba60,%eax
  102b57:	00 00 00 
  102b5a:	05 00 b4 10 00       	add    $0x10b400,%eax
  102b5f:	a3 84 81 10 00       	mov    %eax,0x108184
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
  102bc0:	c7 44 24 04 7a 66 10 	movl   $0x10667a,0x4(%esp)
  102bc7:	00 
  102bc8:	89 34 24             	mov    %esi,(%esp)
  102bcb:	e8 50 16 00 00       	call   104220 <memcmp>
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
  102c05:	c7 05 e0 b3 10 00 01 	movl   $0x1,0x10b3e0
  102c0c:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c0f:	a3 d8 b3 10 00       	mov    %eax,0x10b3d8

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c14:	8d 46 2c             	lea    0x2c(%esi),%eax
  102c17:	39 d0                	cmp    %edx,%eax
  102c19:	0f 83 81 00 00 00    	jae    102ca0 <mp_init+0x160>
  102c1f:	8b 35 84 81 10 00    	mov    0x108184,%esi
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
  102c33:	89 35 84 81 10 00    	mov    %esi,0x108184
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102c39:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102c3d:	c7 04 24 88 66 10 00 	movl   $0x106688,(%esp)
  102c44:	e8 f7 da ff ff       	call   100740 <cprintf>
      panic("mp_init");
  102c49:	c7 04 24 7f 66 10 00 	movl   $0x10667f,(%esp)
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
  102c83:	ff 24 8d ac 66 10 00 	jmp    *0x1066ac(,%ecx,4)
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
  102c9a:	89 35 84 81 10 00    	mov    %esi,0x108184
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
  102ccf:	88 0d e4 b3 10 00    	mov    %cl,0x10b3e4
      p += sizeof(struct mpioapic);
      continue;
  102cd5:	eb bc                	jmp    102c93 <mp_init+0x153>
  102cd7:	90                   	nop

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102cd8:	8b 0d 60 ba 10 00    	mov    0x10ba60,%ecx
  102cde:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102ce2:	69 f9 cc 00 00 00    	imul   $0xcc,%ecx,%edi
  102ce8:	88 9f 00 b4 10 00    	mov    %bl,0x10b400(%edi)
      if(proc->flags & MPBOOT)
  102cee:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102cf2:	74 06                	je     102cfa <mp_init+0x1ba>
        bcpu = &cpus[ncpu];
  102cf4:	8d b7 00 b4 10 00    	lea    0x10b400(%edi),%esi
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
  102d00:	89 0d 60 ba 10 00    	mov    %ecx,0x10ba60
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
  102d22:	66 23 05 40 7c 10 00 	and    0x107c40,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  irqmask = mask;
  102d29:	66 a3 40 7c 10 00    	mov    %ax,0x107c40
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
  102db8:	0f b7 05 40 7c 10 00 	movzwl 0x107c40,%eax
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
  102df2:	e8 89 13 00 00       	call   104180 <acquire>
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
  102e17:	e8 e4 07 00 00       	call   103600 <sleep>
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
  102e2b:	e8 70 05 00 00       	call   1033a0 <curproc>
  102e30:	8b 40 1c             	mov    0x1c(%eax),%eax
  102e33:	85 c0                	test   %eax,%eax
  102e35:	74 d9                	je     102e10 <piperead+0x30>
      release(&p->lock);
  102e37:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  102e3c:	89 34 24             	mov    %esi,(%esp)
  102e3f:	e8 fc 12 00 00       	call   104140 <release>
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
  102e9a:	e8 01 04 00 00       	call   1032a0 <wakeup>
  release(&p->lock);
  102e9f:	89 34 24             	mov    %esi,(%esp)
  102ea2:	e8 99 12 00 00       	call   104140 <release>
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
  102ed2:	e8 a9 12 00 00       	call   104180 <acquire>
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
  102f13:	e8 88 03 00 00       	call   1032a0 <wakeup>
      sleep(&p->writep, &p->lock);
  102f18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  102f1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f1f:	89 0c 24             	mov    %ecx,(%esp)
  102f22:	e8 d9 06 00 00       	call   103600 <sleep>
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
  102f3d:	e8 5e 04 00 00       	call   1033a0 <curproc>
  102f42:	8b 40 1c             	mov    0x1c(%eax),%eax
  102f45:	85 c0                	test   %eax,%eax
  102f47:	74 c7                	je     102f10 <pipewrite+0x50>
        release(&p->lock);
  102f49:	89 34 24             	mov    %esi,(%esp)
  102f4c:	e8 ef 11 00 00       	call   104140 <release>
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
  102fa3:	e8 f8 02 00 00       	call   1032a0 <wakeup>
  release(&p->lock);
  102fa8:	89 34 24             	mov    %esi,(%esp)
  102fab:	e8 90 11 00 00       	call   104140 <release>
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
  102fdb:	e8 a0 11 00 00       	call   104180 <acquire>
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
  102ff1:	e8 aa 02 00 00       	call   1032a0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  102ff6:	89 34 24             	mov    %esi,(%esp)
  102ff9:	e8 42 11 00 00       	call   104140 <release>

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
  103024:	e8 77 02 00 00       	call   1032a0 <wakeup>
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
  1030b8:	c7 44 24 04 c0 66 10 	movl   $0x1066c0,0x4(%esp)
  1030bf:	00 
  1030c0:	e8 fb 0e 00 00       	call   103fc0 <initlock>
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

00103130 <tick>:
  }
}

int
tick(void)
{
  103130:	55                   	push   %ebp
return ticks;
}
  103131:	a1 00 ea 10 00       	mov    0x10ea00,%eax
  }
}

int
tick(void)
{
  103136:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103138:	5d                   	pop    %ebp
  103139:	c3                   	ret    
  10313a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103140 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103140:	55                   	push   %ebp
  103141:	89 e5                	mov    %esp,%ebp
  103143:	57                   	push   %edi
  103144:	56                   	push   %esi
  103145:	53                   	push   %ebx
  103146:	bb 8c ba 10 00       	mov    $0x10ba8c,%ebx
  10314b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10314e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103151:	eb 50                	jmp    1031a3 <procdump+0x63>
  103153:	90                   	nop
  103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103158:	8b 04 85 88 67 10 00 	mov    0x106788(,%eax,4),%eax
  10315f:	85 c0                	test   %eax,%eax
  103161:	74 4e                	je     1031b1 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103163:	89 44 24 08          	mov    %eax,0x8(%esp)
  103167:	8b 43 04             	mov    0x4(%ebx),%eax
  10316a:	81 c2 88 00 00 00    	add    $0x88,%edx
  103170:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103174:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  10317b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10317f:	e8 bc d5 ff ff       	call   100740 <cprintf>
    if(p->state == SLEEPING){
  103184:	83 3b 02             	cmpl   $0x2,(%ebx)
  103187:	74 2f                	je     1031b8 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103189:	c7 04 24 73 66 10 00 	movl   $0x106673,(%esp)
  103190:	e8 ab d5 ff ff       	call   100740 <cprintf>
  103195:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  10319b:	81 fb 8c e1 10 00    	cmp    $0x10e18c,%ebx
  1031a1:	74 55                	je     1031f8 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  1031a3:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  1031a5:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1031a8:	85 c0                	test   %eax,%eax
  1031aa:	74 e9                	je     103195 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1031ac:	83 f8 05             	cmp    $0x5,%eax
  1031af:	76 a7                	jbe    103158 <procdump+0x18>
  1031b1:	b8 c5 66 10 00       	mov    $0x1066c5,%eax
  1031b6:	eb ab                	jmp    103163 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1031b8:	8b 43 74             	mov    0x74(%ebx),%eax
  1031bb:	31 f6                	xor    %esi,%esi
  1031bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1031c1:	83 c0 08             	add    $0x8,%eax
  1031c4:	89 04 24             	mov    %eax,(%esp)
  1031c7:	e8 14 0e 00 00       	call   103fe0 <getcallerpcs>
  1031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1031d0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  1031d3:	85 c0                	test   %eax,%eax
  1031d5:	74 b2                	je     103189 <procdump+0x49>
  1031d7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  1031da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031de:	c7 04 24 35 62 10 00 	movl   $0x106235,(%esp)
  1031e5:	e8 56 d5 ff ff       	call   100740 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  1031ea:	83 fe 0a             	cmp    $0xa,%esi
  1031ed:	75 e1                	jne    1031d0 <procdump+0x90>
  1031ef:	eb 98                	jmp    103189 <procdump+0x49>
  1031f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  1031f8:	83 c4 4c             	add    $0x4c,%esp
  1031fb:	5b                   	pop    %ebx
  1031fc:	5e                   	pop    %esi
  1031fd:	5f                   	pop    %edi
  1031fe:	5d                   	pop    %ebp
  1031ff:	90                   	nop
  103200:	c3                   	ret    
  103201:	eb 0d                	jmp    103210 <kill>
  103203:	90                   	nop
  103204:	90                   	nop
  103205:	90                   	nop
  103206:	90                   	nop
  103207:	90                   	nop
  103208:	90                   	nop
  103209:	90                   	nop
  10320a:	90                   	nop
  10320b:	90                   	nop
  10320c:	90                   	nop
  10320d:	90                   	nop
  10320e:	90                   	nop
  10320f:	90                   	nop

00103210 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103210:	55                   	push   %ebp
  103211:	89 e5                	mov    %esp,%ebp
  103213:	53                   	push   %ebx
  103214:	83 ec 14             	sub    $0x14,%esp
  103217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10321a:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103221:	e8 5a 0f 00 00       	call   104180 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103226:	b8 80 e1 10 00       	mov    $0x10e180,%eax
  10322b:	3d 80 ba 10 00       	cmp    $0x10ba80,%eax
  103230:	76 56                	jbe    103288 <kill+0x78>
    if(p->pid == pid){
  103232:	39 1d 90 ba 10 00    	cmp    %ebx,0x10ba90

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103238:	b8 80 ba 10 00       	mov    $0x10ba80,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10323d:	74 12                	je     103251 <kill+0x41>
  10323f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  103240:	05 9c 00 00 00       	add    $0x9c,%eax
  103245:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  10324a:	74 3c                	je     103288 <kill+0x78>
    if(p->pid == pid){
  10324c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10324f:	75 ef                	jne    103240 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103251:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103255:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10325c:	74 1a                	je     103278 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10325e:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103265:	e8 d6 0e 00 00       	call   104140 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10326a:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10326d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10326f:	5b                   	pop    %ebx
  103270:	5d                   	pop    %ebp
  103271:	c3                   	ret    
  103272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103278:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  10327f:	eb dd                	jmp    10325e <kill+0x4e>
  103281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103288:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  10328f:	e8 ac 0e 00 00       	call   104140 <release>
  return -1;
}
  103294:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  10329c:	5b                   	pop    %ebx
  10329d:	5d                   	pop    %ebp
  10329e:	c3                   	ret    
  10329f:	90                   	nop

001032a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1032a0:	55                   	push   %ebp
  1032a1:	89 e5                	mov    %esp,%ebp
  1032a3:	53                   	push   %ebx
  1032a4:	83 ec 14             	sub    $0x14,%esp
  1032a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1032aa:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  1032b1:	e8 ca 0e 00 00       	call   104180 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1032b6:	b8 80 e1 10 00       	mov    $0x10e180,%eax
  1032bb:	3d 80 ba 10 00       	cmp    $0x10ba80,%eax
  1032c0:	76 3e                	jbe    103300 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1032c2:	b8 80 ba 10 00       	mov    $0x10ba80,%eax
  1032c7:	eb 13                	jmp    1032dc <wakeup+0x3c>
  1032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1032d0:	05 9c 00 00 00       	add    $0x9c,%eax
  1032d5:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  1032da:	74 24                	je     103300 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  1032dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1032e0:	75 ee                	jne    1032d0 <wakeup+0x30>
  1032e2:	3b 58 18             	cmp    0x18(%eax),%ebx
  1032e5:	75 e9                	jne    1032d0 <wakeup+0x30>
      p->state = RUNNABLE;
  1032e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1032ee:	05 9c 00 00 00       	add    $0x9c,%eax
  1032f3:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  1032f8:	75 e2                	jne    1032dc <wakeup+0x3c>
  1032fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103300:	c7 45 08 80 e1 10 00 	movl   $0x10e180,0x8(%ebp)
}
  103307:	83 c4 14             	add    $0x14,%esp
  10330a:	5b                   	pop    %ebx
  10330b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  10330c:	e9 2f 0e 00 00       	jmp    104140 <release>
  103311:	eb 0d                	jmp    103320 <allocproc>
  103313:	90                   	nop
  103314:	90                   	nop
  103315:	90                   	nop
  103316:	90                   	nop
  103317:	90                   	nop
  103318:	90                   	nop
  103319:	90                   	nop
  10331a:	90                   	nop
  10331b:	90                   	nop
  10331c:	90                   	nop
  10331d:	90                   	nop
  10331e:	90                   	nop
  10331f:	90                   	nop

00103320 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103320:	55                   	push   %ebp
  103321:	89 e5                	mov    %esp,%ebp
  103323:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103324:	bb 80 ba 10 00       	mov    $0x10ba80,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103329:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10332c:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103333:	e8 48 0e 00 00       	call   104180 <acquire>
  103338:	eb 14                	jmp    10334e <allocproc+0x2e>
  10333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103340:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103346:	81 fb 80 e1 10 00    	cmp    $0x10e180,%ebx
  10334c:	74 32                	je     103380 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10334e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103351:	85 c0                	test   %eax,%eax
  103353:	75 eb                	jne    103340 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103355:	a1 44 7c 10 00       	mov    0x107c44,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10335a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103361:	89 43 10             	mov    %eax,0x10(%ebx)
  103364:	83 c0 01             	add    $0x1,%eax
  103367:	a3 44 7c 10 00       	mov    %eax,0x107c44
      release(&proc_table_lock);
  10336c:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103373:	e8 c8 0d 00 00       	call   104140 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  103378:	89 d8                	mov    %ebx,%eax
  10337a:	83 c4 14             	add    $0x14,%esp
  10337d:	5b                   	pop    %ebx
  10337e:	5d                   	pop    %ebp
  10337f:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103380:	31 db                	xor    %ebx,%ebx
  103382:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103389:	e8 b2 0d 00 00       	call   104140 <release>
  return 0;
}
  10338e:	89 d8                	mov    %ebx,%eax
  103390:	83 c4 14             	add    $0x14,%esp
  103393:	5b                   	pop    %ebx
  103394:	5d                   	pop    %ebp
  103395:	c3                   	ret    
  103396:	8d 76 00             	lea    0x0(%esi),%esi
  103399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001033a0 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  1033a0:	55                   	push   %ebp
  1033a1:	89 e5                	mov    %esp,%ebp
  1033a3:	53                   	push   %ebx
  1033a4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  1033a7:	e8 04 0d 00 00       	call   1040b0 <pushcli>
  p = cpus[cpu()].curproc;
  1033ac:	e8 bf f4 ff ff       	call   102870 <cpu>
  1033b1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1033b7:	8b 98 04 b4 10 00    	mov    0x10b404(%eax),%ebx
  popcli();
  1033bd:	e8 6e 0c 00 00       	call   104030 <popcli>
  return p;
}
  1033c2:	83 c4 04             	add    $0x4,%esp
  1033c5:	89 d8                	mov    %ebx,%eax
  1033c7:	5b                   	pop    %ebx
  1033c8:	5d                   	pop    %ebp
  1033c9:	c3                   	ret    
  1033ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001033d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  1033d0:	55                   	push   %ebp
  1033d1:	89 e5                	mov    %esp,%ebp
  1033d3:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  1033d6:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  1033dd:	e8 5e 0d 00 00       	call   104140 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1033e2:	e8 b9 ff ff ff       	call   1033a0 <curproc>
  1033e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1033ed:	89 04 24             	mov    %eax,(%esp)
  1033f0:	e8 17 20 00 00       	call   10540c <forkret1>
}
  1033f5:	c9                   	leave  
  1033f6:	c3                   	ret    
  1033f7:	89 f6                	mov    %esi,%esi
  1033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103400 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  103400:	55                   	push   %ebp
  103401:	89 e5                	mov    %esp,%ebp
  103403:	53                   	push   %ebx
  103404:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103407:	9c                   	pushf  
  103408:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  103409:	f6 c4 02             	test   $0x2,%ah
  10340c:	75 5c                	jne    10346a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10340e:	e8 8d ff ff ff       	call   1033a0 <curproc>
  103413:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103417:	74 75                	je     10348e <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103419:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103420:	e8 db 0c 00 00       	call   104100 <holding>
  103425:	85 c0                	test   %eax,%eax
  103427:	74 59                	je     103482 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103429:	e8 42 f4 ff ff       	call   102870 <cpu>
  10342e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103434:	83 b8 c4 b4 10 00 01 	cmpl   $0x1,0x10b4c4(%eax)
  10343b:	75 39                	jne    103476 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10343d:	e8 2e f4 ff ff       	call   102870 <cpu>
  103442:	89 c3                	mov    %eax,%ebx
  103444:	e8 57 ff ff ff       	call   1033a0 <curproc>
  103449:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10344f:	81 c3 08 b4 10 00    	add    $0x10b408,%ebx
  103455:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103459:	83 c0 64             	add    $0x64,%eax
  10345c:	89 04 24             	mov    %eax,(%esp)
  10345f:	e8 88 0f 00 00       	call   1043ec <swtch>
}
  103464:	83 c4 14             	add    $0x14,%esp
  103467:	5b                   	pop    %ebx
  103468:	5d                   	pop    %ebp
  103469:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10346a:	c7 04 24 d2 66 10 00 	movl   $0x1066d2,(%esp)
  103471:	e8 6a d4 ff ff       	call   1008e0 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  103476:	c7 04 24 0a 67 10 00 	movl   $0x10670a,(%esp)
  10347d:	e8 5e d4 ff ff       	call   1008e0 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103482:	c7 04 24 f4 66 10 00 	movl   $0x1066f4,(%esp)
  103489:	e8 52 d4 ff ff       	call   1008e0 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10348e:	c7 04 24 e6 66 10 00 	movl   $0x1066e6,(%esp)
  103495:	e8 46 d4 ff ff       	call   1008e0 <panic>
  10349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001034a0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1034a0:	55                   	push   %ebp
  1034a1:	89 e5                	mov    %esp,%ebp
  1034a3:	56                   	push   %esi
  1034a4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1034a5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1034a7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  1034aa:	e8 f1 fe ff ff       	call   1033a0 <curproc>
  1034af:	3b 05 88 81 10 00    	cmp    0x108188,%eax
  1034b5:	0f 84 36 01 00 00    	je     1035f1 <exit+0x151>
  1034bb:	90                   	nop
  1034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1034c0:	e8 db fe ff ff       	call   1033a0 <curproc>
  1034c5:	8d 73 08             	lea    0x8(%ebx),%esi
  1034c8:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  1034cb:	85 d2                	test   %edx,%edx
  1034cd:	74 1c                	je     1034eb <exit+0x4b>
      fileclose(cp->ofile[fd]);
  1034cf:	e8 cc fe ff ff       	call   1033a0 <curproc>
  1034d4:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1034d7:	89 04 24             	mov    %eax,(%esp)
  1034da:	e8 11 db ff ff       	call   100ff0 <fileclose>
      cp->ofile[fd] = 0;
  1034df:	e8 bc fe ff ff       	call   1033a0 <curproc>
  1034e4:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1034eb:	83 c3 01             	add    $0x1,%ebx
  1034ee:	83 fb 10             	cmp    $0x10,%ebx
  1034f1:	75 cd                	jne    1034c0 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  1034f3:	e8 a8 fe ff ff       	call   1033a0 <curproc>
  1034f8:	8b 40 60             	mov    0x60(%eax),%eax
  1034fb:	89 04 24             	mov    %eax,(%esp)
  1034fe:	e8 9d e4 ff ff       	call   1019a0 <iput>
  cp->cwd = 0;
  103503:	e8 98 fe ff ff       	call   1033a0 <curproc>
  103508:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  10350f:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103516:	e8 65 0c 00 00       	call   104180 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10351b:	e8 80 fe ff ff       	call   1033a0 <curproc>
  103520:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103523:	b8 80 e1 10 00       	mov    $0x10e180,%eax
  103528:	3d 80 ba 10 00       	cmp    $0x10ba80,%eax
  10352d:	0f 86 95 00 00 00    	jbe    1035c8 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103533:	b8 80 ba 10 00       	mov    $0x10ba80,%eax
  103538:	eb 12                	jmp    10354c <exit+0xac>
  10353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103540:	05 9c 00 00 00       	add    $0x9c,%eax
  103545:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  10354a:	74 1e                	je     10356a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  10354c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103550:	75 ee                	jne    103540 <exit+0xa0>
  103552:	3b 50 18             	cmp    0x18(%eax),%edx
  103555:	75 e9                	jne    103540 <exit+0xa0>
      p->state = RUNNABLE;
  103557:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10355e:	05 9c 00 00 00       	add    $0x9c,%eax
  103563:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  103568:	75 e2                	jne    10354c <exit+0xac>
  10356a:	bb 80 ba 10 00       	mov    $0x10ba80,%ebx
  10356f:	eb 15                	jmp    103586 <exit+0xe6>
  103571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103578:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  10357e:	81 fb 80 e1 10 00    	cmp    $0x10e180,%ebx
  103584:	74 42                	je     1035c8 <exit+0x128>
    if(p->parent == cp){
  103586:	8b 73 14             	mov    0x14(%ebx),%esi
  103589:	e8 12 fe ff ff       	call   1033a0 <curproc>
  10358e:	39 c6                	cmp    %eax,%esi
  103590:	75 e6                	jne    103578 <exit+0xd8>
      p->parent = initproc;
  103592:	8b 15 88 81 10 00    	mov    0x108188,%edx
      if(p->state == ZOMBIE)
  103598:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10359c:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  10359f:	75 d7                	jne    103578 <exit+0xd8>
  1035a1:	b8 80 ba 10 00       	mov    $0x10ba80,%eax
  1035a6:	eb 0c                	jmp    1035b4 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1035a8:	05 9c 00 00 00       	add    $0x9c,%eax
  1035ad:	3d 80 e1 10 00       	cmp    $0x10e180,%eax
  1035b2:	74 c4                	je     103578 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  1035b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1035b8:	75 ee                	jne    1035a8 <exit+0x108>
  1035ba:	3b 50 18             	cmp    0x18(%eax),%edx
  1035bd:	75 e9                	jne    1035a8 <exit+0x108>
      p->state = RUNNABLE;
  1035bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1035c6:	eb e0                	jmp    1035a8 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  1035c8:	e8 d3 fd ff ff       	call   1033a0 <curproc>
  1035cd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  1035d4:	e8 c7 fd ff ff       	call   1033a0 <curproc>
  1035d9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  1035e0:	e8 1b fe ff ff       	call   103400 <sched>
  panic("zombie exit");
  1035e5:	c7 04 24 23 67 10 00 	movl   $0x106723,(%esp)
  1035ec:	e8 ef d2 ff ff       	call   1008e0 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1035f1:	c7 04 24 16 67 10 00 	movl   $0x106716,(%esp)
  1035f8:	e8 e3 d2 ff ff       	call   1008e0 <panic>
  1035fd:	8d 76 00             	lea    0x0(%esi),%esi

00103600 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103600:	55                   	push   %ebp
  103601:	89 e5                	mov    %esp,%ebp
  103603:	56                   	push   %esi
  103604:	53                   	push   %ebx
  103605:	83 ec 10             	sub    $0x10,%esp
  103608:	8b 75 08             	mov    0x8(%ebp),%esi
  10360b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10360e:	e8 8d fd ff ff       	call   1033a0 <curproc>
  103613:	85 c0                	test   %eax,%eax
  103615:	0f 84 9d 00 00 00    	je     1036b8 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  10361b:	85 db                	test   %ebx,%ebx
  10361d:	0f 84 89 00 00 00    	je     1036ac <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103623:	81 fb 80 e1 10 00    	cmp    $0x10e180,%ebx
  103629:	74 55                	je     103680 <sleep+0x80>
    acquire(&proc_table_lock);
  10362b:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103632:	e8 49 0b 00 00       	call   104180 <acquire>
    release(lk);
  103637:	89 1c 24             	mov    %ebx,(%esp)
  10363a:	e8 01 0b 00 00       	call   104140 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  10363f:	e8 5c fd ff ff       	call   1033a0 <curproc>
  103644:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103647:	e8 54 fd ff ff       	call   1033a0 <curproc>
  10364c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103653:	e8 a8 fd ff ff       	call   103400 <sched>

  // Tidy up.
  cp->chan = 0;
  103658:	e8 43 fd ff ff       	call   1033a0 <curproc>
  10365d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103664:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  10366b:	e8 d0 0a 00 00       	call   104140 <release>
    acquire(lk);
  103670:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103673:	83 c4 10             	add    $0x10,%esp
  103676:	5b                   	pop    %ebx
  103677:	5e                   	pop    %esi
  103678:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103679:	e9 02 0b 00 00       	jmp    104180 <acquire>
  10367e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103680:	e8 1b fd ff ff       	call   1033a0 <curproc>
  103685:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103688:	e8 13 fd ff ff       	call   1033a0 <curproc>
  10368d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103694:	e8 67 fd ff ff       	call   103400 <sched>

  // Tidy up.
  cp->chan = 0;
  103699:	e8 02 fd ff ff       	call   1033a0 <curproc>
  10369e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  1036a5:	83 c4 10             	add    $0x10,%esp
  1036a8:	5b                   	pop    %ebx
  1036a9:	5e                   	pop    %esi
  1036aa:	5d                   	pop    %ebp
  1036ab:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  1036ac:	c7 04 24 35 67 10 00 	movl   $0x106735,(%esp)
  1036b3:	e8 28 d2 ff ff       	call   1008e0 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1036b8:	c7 04 24 2f 67 10 00 	movl   $0x10672f,(%esp)
  1036bf:	e8 1c d2 ff ff       	call   1008e0 <panic>
  1036c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1036ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001036d0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1036d0:	55                   	push   %ebp
  1036d1:	89 e5                	mov    %esp,%ebp
  1036d3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1036d4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1036d6:	56                   	push   %esi
  1036d7:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1036d8:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1036da:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1036dd:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  1036e4:	e8 97 0a 00 00       	call   104180 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1036e9:	83 fb 3f             	cmp    $0x3f,%ebx
  1036ec:	7e 2f                	jle    10371d <wait+0x4d>
  1036ee:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1036f0:	85 ff                	test   %edi,%edi
  1036f2:	74 74                	je     103768 <wait+0x98>
  1036f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1036f8:	e8 a3 fc ff ff       	call   1033a0 <curproc>
  1036fd:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103700:	85 c9                	test   %ecx,%ecx
  103702:	75 64                	jne    103768 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103704:	e8 97 fc ff ff       	call   1033a0 <curproc>
  103709:	31 ff                	xor    %edi,%edi
  10370b:	31 db                	xor    %ebx,%ebx
  10370d:	c7 44 24 04 80 e1 10 	movl   $0x10e180,0x4(%esp)
  103714:	00 
  103715:	89 04 24             	mov    %eax,(%esp)
  103718:	e8 e3 fe ff ff       	call   103600 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10371d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103723:	81 c6 80 ba 10 00    	add    $0x10ba80,%esi
      if(p->state == UNUSED)
  103729:	8b 46 0c             	mov    0xc(%esi),%eax
  10372c:	85 c0                	test   %eax,%eax
  10372e:	75 10                	jne    103740 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103730:	83 c3 01             	add    $0x1,%ebx
  103733:	83 fb 3f             	cmp    $0x3f,%ebx
  103736:	7e e5                	jle    10371d <wait+0x4d>
  103738:	eb b6                	jmp    1036f0 <wait+0x20>
  10373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103740:	8b 46 14             	mov    0x14(%esi),%eax
  103743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103746:	e8 55 fc ff ff       	call   1033a0 <curproc>
  10374b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10374e:	66 90                	xchg   %ax,%ax
  103750:	75 de                	jne    103730 <wait+0x60>
        if(p->state == ZOMBIE){
  103752:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103756:	74 29                	je     103781 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103758:	bf 01 00 00 00       	mov    $0x1,%edi
  10375d:	8d 76 00             	lea    0x0(%esi),%esi
  103760:	eb ce                	jmp    103730 <wait+0x60>
  103762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103768:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  10376f:	e8 cc 09 00 00       	call   104140 <release>
  103774:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103779:	83 c4 2c             	add    $0x2c,%esp
  10377c:	5b                   	pop    %ebx
  10377d:	5e                   	pop    %esi
  10377e:	5f                   	pop    %edi
  10377f:	5d                   	pop    %ebp
  103780:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103781:	8b 46 04             	mov    0x4(%esi),%eax
  103784:	89 44 24 04          	mov    %eax,0x4(%esp)
  103788:	8b 06                	mov    (%esi),%eax
  10378a:	89 04 24             	mov    %eax,(%esp)
  10378d:	e8 0e ec ff ff       	call   1023a0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103792:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103799:	00 
  10379a:	8b 46 08             	mov    0x8(%esi),%eax
  10379d:	89 04 24             	mov    %eax,(%esp)
  1037a0:	e8 fb eb ff ff       	call   1023a0 <kfree>
          pid = p->pid;
  1037a5:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  1037a8:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  1037af:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  1037b6:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  1037bd:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1037c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1037c7:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  1037ce:	e8 6d 09 00 00       	call   104140 <release>
          return pid;
  1037d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1037d6:	eb a1                	jmp    103779 <wait+0xa9>
  1037d8:	90                   	nop
  1037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001037e0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1037e0:	55                   	push   %ebp
  1037e1:	89 e5                	mov    %esp,%ebp
  1037e3:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  1037e6:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  1037ed:	e8 8e 09 00 00       	call   104180 <acquire>
  cp->state = RUNNABLE;
  1037f2:	e8 a9 fb ff ff       	call   1033a0 <curproc>
  1037f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1037fe:	e8 fd fb ff ff       	call   103400 <sched>
  release(&proc_table_lock);
  103803:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  10380a:	e8 31 09 00 00       	call   104140 <release>
}
  10380f:	c9                   	leave  
  103810:	c3                   	ret    
  103811:	eb 0d                	jmp    103820 <setupsegs>
  103813:	90                   	nop
  103814:	90                   	nop
  103815:	90                   	nop
  103816:	90                   	nop
  103817:	90                   	nop
  103818:	90                   	nop
  103819:	90                   	nop
  10381a:	90                   	nop
  10381b:	90                   	nop
  10381c:	90                   	nop
  10381d:	90                   	nop
  10381e:	90                   	nop
  10381f:	90                   	nop

00103820 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103820:	55                   	push   %ebp
  103821:	89 e5                	mov    %esp,%ebp
  103823:	57                   	push   %edi
  103824:	56                   	push   %esi
  103825:	53                   	push   %ebx
  103826:	83 ec 2c             	sub    $0x2c,%esp
  103829:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  10382c:	e8 7f 08 00 00       	call   1040b0 <pushcli>
  c = &cpus[cpu()];
  103831:	e8 3a f0 ff ff       	call   102870 <cpu>
  103836:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10383c:	05 00 b4 10 00       	add    $0x10b400,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103841:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103843:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103849:	0f 84 a1 01 00 00    	je     1039f0 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  10384f:	8b 56 08             	mov    0x8(%esi),%edx
  103852:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103858:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10385b:	8d 50 28             	lea    0x28(%eax),%edx
  10385e:	89 d1                	mov    %edx,%ecx
  103860:	c1 e9 10             	shr    $0x10,%ecx
  103863:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  10386a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  10386d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  10386f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103876:	00 00 00 
  103879:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103880:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103883:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  10388a:	0f 01 
  10388c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103893:	00 00 
  103895:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  10389c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  1038a3:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  1038aa:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  1038b1:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  1038b8:	ff ff 
  1038ba:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  1038c1:	00 00 
  1038c3:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  1038ca:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  1038d1:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  1038d8:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1038df:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  1038e6:	67 00 
  1038e8:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  1038ee:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  1038f5:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  1038fb:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103902:	0f 84 b8 00 00 00    	je     1039c0 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103908:	8b 16                	mov    (%esi),%edx
  10390a:	8b 5e 04             	mov    0x4(%esi),%ebx
  10390d:	89 d6                	mov    %edx,%esi
  10390f:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103912:	89 d3                	mov    %edx,%ebx
  103914:	c1 ee 10             	shr    $0x10,%esi
  103917:	89 cf                	mov    %ecx,%edi
  103919:	c1 eb 18             	shr    $0x18,%ebx
  10391c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  10391f:	89 f3                	mov    %esi,%ebx
  103921:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103927:	89 cb                	mov    %ecx,%ebx
  103929:	c1 eb 1c             	shr    $0x1c,%ebx
  10392c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  10392e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103931:	83 c9 c0             	or     $0xffffffc0,%ecx
  103934:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  10393b:	c1 ef 0c             	shr    $0xc,%edi
  10393e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103944:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103948:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  10394f:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103955:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  10395c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103962:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103966:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  10396d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10396f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103976:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  10397d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103983:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103989:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10398e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103994:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103998:	c1 e8 10             	shr    $0x10,%eax
  10399b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10399f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1039a2:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  1039a5:	b8 28 00 00 00       	mov    $0x28,%eax
  1039aa:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  1039ad:	e8 7e 06 00 00       	call   104030 <popcli>
}
  1039b2:	83 c4 2c             	add    $0x2c,%esp
  1039b5:	5b                   	pop    %ebx
  1039b6:	5e                   	pop    %esi
  1039b7:	5f                   	pop    %edi
  1039b8:	5d                   	pop    %ebp
  1039b9:	c3                   	ret    
  1039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  1039c0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  1039c7:	00 00 00 
  1039ca:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  1039d1:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  1039d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1039db:	00 00 00 
  1039de:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  1039e5:	00 00 00 
  1039e8:	eb 9f                	jmp    103989 <setupsegs+0x169>
  1039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  1039f0:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  1039f7:	e9 5f fe ff ff       	jmp    10385b <setupsegs+0x3b>
  1039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103a00 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103a00:	55                   	push   %ebp
  103a01:	89 e5                	mov    %esp,%ebp
  103a03:	57                   	push   %edi
  103a04:	56                   	push   %esi
  103a05:	53                   	push   %ebx
  103a06:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103a09:	e8 62 ee ff ff       	call   102870 <cpu>
  103a0e:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103a14:	81 c3 00 b4 10 00    	add    $0x10b400,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103a1a:	8d 73 08             	lea    0x8(%ebx),%esi
  103a1d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103a20:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103a21:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103a28:	e8 53 07 00 00       	call   104180 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103a2d:	83 3d 90 ba 10 00 01 	cmpl   $0x1,0x10ba90
  103a34:	0f 84 c6 00 00 00    	je     103b00 <scheduler+0x100>
  103a3a:	31 d2                	xor    %edx,%edx
  103a3c:	31 c0                	xor    %eax,%eax
  103a3e:	eb 0e                	jmp    103a4e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103a40:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103a46:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103a4c:	74 1d                	je     103a6b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103a4e:	83 ba 8c ba 10 00 03 	cmpl   $0x3,0x10ba8c(%edx)
  103a55:	75 e9                	jne    103a40 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103a57:	03 82 18 bb 10 00    	add    0x10bb18(%edx),%eax
  103a5d:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103a63:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103a69:	75 e3                	jne    103a4e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103a6b:	85 c0                	test   %eax,%eax
  103a6d:	74 16                	je     103a85 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103a6f:	8b 3d 00 ea 10 00    	mov    0x10ea00,%edi
  103a75:	89 c1                	mov    %eax,%ecx
  103a77:	c1 e7 08             	shl    $0x8,%edi
  103a7a:	89 fa                	mov    %edi,%edx
  103a7c:	89 f8                	mov    %edi,%eax
  103a7e:	c1 fa 1f             	sar    $0x1f,%edx
  103a81:	f7 f9                	idiv   %ecx
  103a83:	89 d7                	mov    %edx,%edi
  103a85:	b8 8c ba 10 00       	mov    $0x10ba8c,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103a8a:	31 d2                	xor    %edx,%edx
  103a8c:	eb 12                	jmp    103aa0 <scheduler+0xa0>
  103a8e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103a90:	39 fa                	cmp    %edi,%edx
  103a92:	7f 1e                	jg     103ab2 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103a94:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103a99:	3d 8c e1 10 00       	cmp    $0x10e18c,%eax
  103a9e:	74 4c                	je     103aec <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103aa0:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103aa3:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103aa6:	75 e8                	jne    103a90 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103aa8:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103aae:	39 fa                	cmp    %edi,%edx
  103ab0:	7e e2                	jle    103a94 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103ab2:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103ab5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103ab8:	89 0c 24             	mov    %ecx,(%esp)
  103abb:	e8 60 fd ff ff       	call   103820 <setupsegs>
    	  p->state = RUNNING;
  103ac0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103ac3:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103aca:	83 c1 64             	add    $0x64,%ecx
  103acd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103ad1:	89 34 24             	mov    %esi,(%esp)
  103ad4:	e8 13 09 00 00       	call   1043ec <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103ad9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103ae0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103ae7:	e8 34 fd ff ff       	call   103820 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103aec:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103af3:	e8 48 06 00 00       	call   104140 <release>
  103af8:	e9 23 ff ff ff       	jmp    103a20 <scheduler+0x20>
  103afd:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103b00:	83 3d 8c ba 10 00 03 	cmpl   $0x3,0x10ba8c
  103b07:	0f 85 2d ff ff ff    	jne    103a3a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103b0d:	c7 43 04 80 ba 10 00 	movl   $0x10ba80,0x4(%ebx)
      setupsegs(p);
  103b14:	c7 04 24 80 ba 10 00 	movl   $0x10ba80,(%esp)
  103b1b:	e8 00 fd ff ff       	call   103820 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103b20:	c7 44 24 04 e4 ba 10 	movl   $0x10bae4,0x4(%esp)
  103b27:	00 
  103b28:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103b2b:	c7 05 18 bb 10 00 4b 	movl   $0x4b,0x10bb18
  103b32:	00 00 00 
      p->state = RUNNING;
  103b35:	c7 05 8c ba 10 00 04 	movl   $0x4,0x10ba8c
  103b3c:	00 00 00 
      swtch(&c->context, &p->context);
  103b3f:	e8 a8 08 00 00       	call   1043ec <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103b44:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103b4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103b52:	e8 c9 fc ff ff       	call   103820 <setupsegs>
      release(&proc_table_lock);
  103b57:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103b5e:	e8 dd 05 00 00       	call   104140 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103b63:	e9 b8 fe ff ff       	jmp    103a20 <scheduler+0x20>
  103b68:	90                   	nop
  103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103b70 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103b70:	55                   	push   %ebp
  103b71:	89 e5                	mov    %esp,%ebp
  103b73:	57                   	push   %edi
  103b74:	56                   	push   %esi
  103b75:	53                   	push   %ebx
  103b76:	83 ec 1c             	sub    $0x1c,%esp
  103b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103b7c:	e8 1f f8 ff ff       	call   1033a0 <curproc>
  103b81:	8b 50 04             	mov    0x4(%eax),%edx
  103b84:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103b87:	89 04 24             	mov    %eax,(%esp)
  103b8a:	e8 51 e7 ff ff       	call   1022e0 <kalloc>
  103b8f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103b96:	85 f6                	test   %esi,%esi
  103b98:	74 7f                	je     103c19 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103b9a:	e8 01 f8 ff ff       	call   1033a0 <curproc>
  103b9f:	8b 78 04             	mov    0x4(%eax),%edi
  103ba2:	e8 f9 f7 ff ff       	call   1033a0 <curproc>
  103ba7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103bab:	8b 00                	mov    (%eax),%eax
  103bad:	89 34 24             	mov    %esi,(%esp)
  103bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bb4:	e8 c7 06 00 00       	call   104280 <memmove>
  memset(newmem + cp->sz, 0, n);
  103bb9:	e8 e2 f7 ff ff       	call   1033a0 <curproc>
  103bbe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103bc2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103bc9:	00 
  103bca:	8b 50 04             	mov    0x4(%eax),%edx
  103bcd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103bd0:	89 04 24             	mov    %eax,(%esp)
  103bd3:	e8 18 06 00 00       	call   1041f0 <memset>
  kfree(cp->mem, cp->sz);
  103bd8:	e8 c3 f7 ff ff       	call   1033a0 <curproc>
  103bdd:	8b 78 04             	mov    0x4(%eax),%edi
  103be0:	e8 bb f7 ff ff       	call   1033a0 <curproc>
  103be5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103be9:	8b 00                	mov    (%eax),%eax
  103beb:	89 04 24             	mov    %eax,(%esp)
  103bee:	e8 ad e7 ff ff       	call   1023a0 <kfree>
  cp->mem = newmem;
  103bf3:	e8 a8 f7 ff ff       	call   1033a0 <curproc>
  103bf8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103bfa:	e8 a1 f7 ff ff       	call   1033a0 <curproc>
  103bff:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  103c02:	e8 99 f7 ff ff       	call   1033a0 <curproc>
  103c07:	89 04 24             	mov    %eax,(%esp)
  103c0a:	e8 11 fc ff ff       	call   103820 <setupsegs>
  return cp->sz - n;
  103c0f:	e8 8c f7 ff ff       	call   1033a0 <curproc>
  103c14:	8b 40 04             	mov    0x4(%eax),%eax
  103c17:	29 d8                	sub    %ebx,%eax
}
  103c19:	83 c4 1c             	add    $0x1c,%esp
  103c1c:	5b                   	pop    %ebx
  103c1d:	5e                   	pop    %esi
  103c1e:	5f                   	pop    %edi
  103c1f:	5d                   	pop    %ebp
  103c20:	c3                   	ret    
  103c21:	eb 0d                	jmp    103c30 <copyproc_tix>
  103c23:	90                   	nop
  103c24:	90                   	nop
  103c25:	90                   	nop
  103c26:	90                   	nop
  103c27:	90                   	nop
  103c28:	90                   	nop
  103c29:	90                   	nop
  103c2a:	90                   	nop
  103c2b:	90                   	nop
  103c2c:	90                   	nop
  103c2d:	90                   	nop
  103c2e:	90                   	nop
  103c2f:	90                   	nop

00103c30 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	57                   	push   %edi
  103c34:	56                   	push   %esi
  103c35:	53                   	push   %ebx
  103c36:	83 ec 1c             	sub    $0x1c,%esp
  103c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103c3c:	e8 df f6 ff ff       	call   103320 <allocproc>
  103c41:	85 c0                	test   %eax,%eax
  103c43:	89 c6                	mov    %eax,%esi
  103c45:	0f 84 e1 00 00 00    	je     103d2c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103c4b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103c52:	e8 89 e6 ff ff       	call   1022e0 <kalloc>
  103c57:	85 c0                	test   %eax,%eax
  103c59:	89 46 08             	mov    %eax,0x8(%esi)
  103c5c:	0f 84 d4 00 00 00    	je     103d36 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103c62:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103c67:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103c69:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103c6f:	0f 84 85 00 00 00    	je     103cfa <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;
  103c75:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103c78:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;
  103c7b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103c81:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103c88:	00 
  103c89:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103c8f:	89 04 24             	mov    %eax,(%esp)
  103c92:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c96:	e8 e5 05 00 00       	call   104280 <memmove>
  
    np->sz = p->sz;
  103c9b:	8b 47 04             	mov    0x4(%edi),%eax
  103c9e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103ca1:	89 04 24             	mov    %eax,(%esp)
  103ca4:	e8 37 e6 ff ff       	call   1022e0 <kalloc>
  103ca9:	85 c0                	test   %eax,%eax
  103cab:	89 06                	mov    %eax,(%esi)
  103cad:	0f 84 8e 00 00 00    	je     103d41 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103cb3:	8b 56 04             	mov    0x4(%esi),%edx
  103cb6:	31 db                	xor    %ebx,%ebx
  103cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
  103cbc:	8b 17                	mov    (%edi),%edx
  103cbe:	89 04 24             	mov    %eax,(%esp)
  103cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cc5:	e8 b6 05 00 00       	call   104280 <memmove>
  103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103cd0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103cd4:	85 c0                	test   %eax,%eax
  103cd6:	74 0c                	je     103ce4 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103cd8:	89 04 24             	mov    %eax,(%esp)
  103cdb:	e8 30 d2 ff ff       	call   100f10 <filedup>
  103ce0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103ce4:	83 c3 01             	add    $0x1,%ebx
  103ce7:	83 fb 10             	cmp    $0x10,%ebx
  103cea:	75 e4                	jne    103cd0 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103cec:	8b 47 60             	mov    0x60(%edi),%eax
  103cef:	89 04 24             	mov    %eax,(%esp)
  103cf2:	e8 29 d4 ff ff       	call   101120 <idup>
  103cf7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103cfa:	8d 46 64             	lea    0x64(%esi),%eax
  103cfd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103d04:	00 
  103d05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103d0c:	00 
  103d0d:	89 04 24             	mov    %eax,(%esp)
  103d10:	e8 db 04 00 00       	call   1041f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103d15:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103d1b:	c7 46 64 d0 33 10 00 	movl   $0x1033d0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103d22:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103d25:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103d2c:	83 c4 1c             	add    $0x1c,%esp
  103d2f:	89 f0                	mov    %esi,%eax
  103d31:	5b                   	pop    %ebx
  103d32:	5e                   	pop    %esi
  103d33:	5f                   	pop    %edi
  103d34:	5d                   	pop    %ebp
  103d35:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103d36:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103d3d:	31 f6                	xor    %esi,%esi
    return 0;
  103d3f:	eb eb                	jmp    103d2c <copyproc_tix+0xfc>
    np->num_tix = tix;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103d41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d48:	00 
  103d49:	8b 46 08             	mov    0x8(%esi),%eax
  103d4c:	89 04 24             	mov    %eax,(%esp)
  103d4f:	e8 4c e6 ff ff       	call   1023a0 <kfree>
      np->kstack = 0;
  103d54:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103d5b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103d62:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103d69:	31 f6                	xor    %esi,%esi
      return 0;
  103d6b:	eb bf                	jmp    103d2c <copyproc_tix+0xfc>
  103d6d:	8d 76 00             	lea    0x0(%esi),%esi

00103d70 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  103d70:	55                   	push   %ebp
  103d71:	89 e5                	mov    %esp,%ebp
  103d73:	57                   	push   %edi
  103d74:	56                   	push   %esi
  103d75:	53                   	push   %ebx
  103d76:	83 ec 1c             	sub    $0x1c,%esp
  103d79:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103d7c:	e8 9f f5 ff ff       	call   103320 <allocproc>
  103d81:	85 c0                	test   %eax,%eax
  103d83:	89 c6                	mov    %eax,%esi
  103d85:	0f 84 e1 00 00 00    	je     103e6c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103d8b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103d92:	e8 49 e5 ff ff       	call   1022e0 <kalloc>
  103d97:	85 c0                	test   %eax,%eax
  103d99:	89 46 08             	mov    %eax,0x8(%esi)
  103d9c:	0f 84 d4 00 00 00    	je     103e76 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103da2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103da7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103da9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103daf:	0f 84 85 00 00 00    	je     103e3a <copyproc+0xca>
    np->parent = p;
  103db5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  103db8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  103dbf:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103dc2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103dc9:	00 
  103dca:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103dd0:	89 04 24             	mov    %eax,(%esp)
  103dd3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dd7:	e8 a4 04 00 00       	call   104280 <memmove>
  
    np->sz = p->sz;
  103ddc:	8b 47 04             	mov    0x4(%edi),%eax
  103ddf:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103de2:	89 04 24             	mov    %eax,(%esp)
  103de5:	e8 f6 e4 ff ff       	call   1022e0 <kalloc>
  103dea:	85 c0                	test   %eax,%eax
  103dec:	89 06                	mov    %eax,(%esi)
  103dee:	0f 84 8d 00 00 00    	je     103e81 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103df4:	8b 56 04             	mov    0x4(%esi),%edx
  103df7:	31 db                	xor    %ebx,%ebx
  103df9:	89 54 24 08          	mov    %edx,0x8(%esp)
  103dfd:	8b 17                	mov    (%edi),%edx
  103dff:	89 04 24             	mov    %eax,(%esp)
  103e02:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e06:	e8 75 04 00 00       	call   104280 <memmove>
  103e0b:	90                   	nop
  103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103e10:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103e14:	85 c0                	test   %eax,%eax
  103e16:	74 0c                	je     103e24 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103e18:	89 04 24             	mov    %eax,(%esp)
  103e1b:	e8 f0 d0 ff ff       	call   100f10 <filedup>
  103e20:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103e24:	83 c3 01             	add    $0x1,%ebx
  103e27:	83 fb 10             	cmp    $0x10,%ebx
  103e2a:	75 e4                	jne    103e10 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103e2c:	8b 47 60             	mov    0x60(%edi),%eax
  103e2f:	89 04 24             	mov    %eax,(%esp)
  103e32:	e8 e9 d2 ff ff       	call   101120 <idup>
  103e37:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103e3a:	8d 46 64             	lea    0x64(%esi),%eax
  103e3d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103e44:	00 
  103e45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e4c:	00 
  103e4d:	89 04 24             	mov    %eax,(%esp)
  103e50:	e8 9b 03 00 00       	call   1041f0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103e55:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103e5b:	c7 46 64 d0 33 10 00 	movl   $0x1033d0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103e62:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103e65:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103e6c:	83 c4 1c             	add    $0x1c,%esp
  103e6f:	89 f0                	mov    %esi,%eax
  103e71:	5b                   	pop    %ebx
  103e72:	5e                   	pop    %esi
  103e73:	5f                   	pop    %edi
  103e74:	5d                   	pop    %ebp
  103e75:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103e76:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103e7d:	31 f6                	xor    %esi,%esi
    return 0;
  103e7f:	eb eb                	jmp    103e6c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103e81:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e88:	00 
  103e89:	8b 46 08             	mov    0x8(%esi),%eax
  103e8c:	89 04 24             	mov    %eax,(%esp)
  103e8f:	e8 0c e5 ff ff       	call   1023a0 <kfree>
      np->kstack = 0;
  103e94:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103e9b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103ea2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103ea9:	31 f6                	xor    %esi,%esi
      return 0;
  103eab:	eb bf                	jmp    103e6c <copyproc+0xfc>
  103ead:	8d 76 00             	lea    0x0(%esi),%esi

00103eb0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103eb0:	55                   	push   %ebp
  103eb1:	89 e5                	mov    %esp,%ebp
  103eb3:	53                   	push   %ebx
  103eb4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  103eb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103ebe:	e8 ad fe ff ff       	call   103d70 <copyproc>
  p->sz = PAGE;
  103ec3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  103eca:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  103ecc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103ed3:	e8 08 e4 ff ff       	call   1022e0 <kalloc>
  103ed8:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  103eda:	c7 04 24 46 67 10 00 	movl   $0x106746,(%esp)
  103ee1:	e8 2a e0 ff ff       	call   101f10 <namei>
  103ee6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  103ee9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103ef0:	00 
  103ef1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ef8:	00 
  103ef9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  103eff:	89 04 24             	mov    %eax,(%esp)
  103f02:	e8 e9 02 00 00       	call   1041f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103f07:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103f0d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  103f0f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  103f16:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103f19:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  103f1f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  103f25:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  103f2b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  103f2e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103f32:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  103f35:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  103f3b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  103f42:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  103f49:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103f50:	00 
  103f51:	c7 44 24 04 48 80 10 	movl   $0x108048,0x4(%esp)
  103f58:	00 
  103f59:	8b 03                	mov    (%ebx),%eax
  103f5b:	89 04 24             	mov    %eax,(%esp)
  103f5e:	e8 1d 03 00 00       	call   104280 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  103f63:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  103f69:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103f70:	00 
  103f71:	c7 44 24 04 48 67 10 	movl   $0x106748,0x4(%esp)
  103f78:	00 
  103f79:	89 04 24             	mov    %eax,(%esp)
  103f7c:	e8 0f 04 00 00       	call   104390 <safestrcpy>
  p->state = RUNNABLE;
  103f81:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  103f88:	89 1d 88 81 10 00    	mov    %ebx,0x108188
}
  103f8e:	83 c4 14             	add    $0x14,%esp
  103f91:	5b                   	pop    %ebx
  103f92:	5d                   	pop    %ebp
  103f93:	c3                   	ret    
  103f94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103f9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103fa0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  103fa0:	55                   	push   %ebp
  103fa1:	89 e5                	mov    %esp,%ebp
  103fa3:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  103fa6:	c7 44 24 04 51 67 10 	movl   $0x106751,0x4(%esp)
  103fad:	00 
  103fae:	c7 04 24 80 e1 10 00 	movl   $0x10e180,(%esp)
  103fb5:	e8 06 00 00 00       	call   103fc0 <initlock>
}
  103fba:	c9                   	leave  
  103fbb:	c3                   	ret    
  103fbc:	90                   	nop
  103fbd:	90                   	nop
  103fbe:	90                   	nop
  103fbf:	90                   	nop

00103fc0 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  103fc0:	55                   	push   %ebp
  103fc1:	89 e5                	mov    %esp,%ebp
  103fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  103fc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  103fc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  103fcf:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  103fd2:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  103fd9:	5d                   	pop    %ebp
  103fda:	c3                   	ret    
  103fdb:	90                   	nop
  103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103fe0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103fe0:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103fe1:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103fe3:	89 e5                	mov    %esp,%ebp
  103fe5:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103fe6:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103fe9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103fec:	83 ea 08             	sub    $0x8,%edx
  103fef:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  103ff0:	8d 4a ff             	lea    -0x1(%edx),%ecx
  103ff3:	83 f9 fd             	cmp    $0xfffffffd,%ecx
  103ff6:	77 18                	ja     104010 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103ff8:	8b 4a 04             	mov    0x4(%edx),%ecx
  103ffb:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103ffe:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104001:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104003:	83 f8 0a             	cmp    $0xa,%eax
  104006:	75 e8                	jne    103ff0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  104008:	5b                   	pop    %ebx
  104009:	5d                   	pop    %ebp
  10400a:	c3                   	ret    
  10400b:	90                   	nop
  10400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104010:	83 f8 09             	cmp    $0x9,%eax
  104013:	7f f3                	jg     104008 <getcallerpcs+0x28>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104015:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  104018:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  10401b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  104021:	83 c2 04             	add    $0x4,%edx
  104024:	83 f8 0a             	cmp    $0xa,%eax
  104027:	75 ef                	jne    104018 <getcallerpcs+0x38>
    pcs[i] = 0;
}
  104029:	5b                   	pop    %ebx
  10402a:	5d                   	pop    %ebp
  10402b:	c3                   	ret    
  10402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104030 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  104030:	55                   	push   %ebp
  104031:	89 e5                	mov    %esp,%ebp
  104033:	83 ec 18             	sub    $0x18,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104036:	9c                   	pushf  
  104037:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104038:	f6 c4 02             	test   $0x2,%ah
  10403b:	75 5f                	jne    10409c <popcli+0x6c>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10403d:	e8 2e e8 ff ff       	call   102870 <cpu>
  104042:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104048:	05 04 b4 10 00       	add    $0x10b404,%eax
  10404d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104053:	83 ea 01             	sub    $0x1,%edx
  104056:	85 d2                	test   %edx,%edx
  104058:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10405e:	78 30                	js     104090 <popcli+0x60>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104060:	e8 0b e8 ff ff       	call   102870 <cpu>
  104065:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10406b:	8b 90 c4 b4 10 00    	mov    0x10b4c4(%eax),%edx
  104071:	85 d2                	test   %edx,%edx
  104073:	74 03                	je     104078 <popcli+0x48>
    sti();
}
  104075:	c9                   	leave  
  104076:	c3                   	ret    
  104077:	90                   	nop
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  104078:	e8 f3 e7 ff ff       	call   102870 <cpu>
  10407d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104083:	8b 80 c8 b4 10 00    	mov    0x10b4c8(%eax),%eax
  104089:	85 c0                	test   %eax,%eax
  10408b:	74 e8                	je     104075 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10408d:	fb                   	sti    
    sti();
}
  10408e:	c9                   	leave  
  10408f:	c3                   	ret    
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  104090:	c7 04 24 b7 67 10 00 	movl   $0x1067b7,(%esp)
  104097:	e8 44 c8 ff ff       	call   1008e0 <panic>

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10409c:	c7 04 24 a0 67 10 00 	movl   $0x1067a0,(%esp)
  1040a3:	e8 38 c8 ff ff       	call   1008e0 <panic>
  1040a8:	90                   	nop
  1040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001040b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1040b0:	55                   	push   %ebp
  1040b1:	89 e5                	mov    %esp,%ebp
  1040b3:	53                   	push   %ebx
  1040b4:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1040b7:	9c                   	pushf  
  1040b8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1040b9:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  1040ba:	e8 b1 e7 ff ff       	call   102870 <cpu>
  1040bf:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1040c5:	05 04 b4 10 00       	add    $0x10b404,%eax
  1040ca:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1040d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  1040d3:	85 d2                	test   %edx,%edx
  1040d5:	89 88 c0 00 00 00    	mov    %ecx,0xc0(%eax)
  1040db:	75 17                	jne    1040f4 <pushcli+0x44>
    cpus[cpu()].intena = eflags & FL_IF;
  1040dd:	e8 8e e7 ff ff       	call   102870 <cpu>
  1040e2:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1040e8:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1040ee:	89 98 c8 b4 10 00    	mov    %ebx,0x10b4c8(%eax)
}
  1040f4:	83 c4 04             	add    $0x4,%esp
  1040f7:	5b                   	pop    %ebx
  1040f8:	5d                   	pop    %ebp
  1040f9:	c3                   	ret    
  1040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104100 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104100:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104101:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104103:	89 e5                	mov    %esp,%ebp
  104105:	53                   	push   %ebx
  104106:	83 ec 04             	sub    $0x4,%esp
  104109:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10410c:	8b 0a                	mov    (%edx),%ecx
  10410e:	85 c9                	test   %ecx,%ecx
  104110:	75 06                	jne    104118 <holding+0x18>
}
  104112:	83 c4 04             	add    $0x4,%esp
  104115:	5b                   	pop    %ebx
  104116:	5d                   	pop    %ebp
  104117:	c3                   	ret    

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  104118:	8b 5a 08             	mov    0x8(%edx),%ebx
  10411b:	e8 50 e7 ff ff       	call   102870 <cpu>
  104120:	83 c0 0a             	add    $0xa,%eax
  104123:	39 c3                	cmp    %eax,%ebx
  104125:	0f 94 c0             	sete   %al
}
  104128:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu() + 10;
  10412b:	0f b6 c0             	movzbl %al,%eax
}
  10412e:	5b                   	pop    %ebx
  10412f:	5d                   	pop    %ebp
  104130:	c3                   	ret    
  104131:	eb 0d                	jmp    104140 <release>
  104133:	90                   	nop
  104134:	90                   	nop
  104135:	90                   	nop
  104136:	90                   	nop
  104137:	90                   	nop
  104138:	90                   	nop
  104139:	90                   	nop
  10413a:	90                   	nop
  10413b:	90                   	nop
  10413c:	90                   	nop
  10413d:	90                   	nop
  10413e:	90                   	nop
  10413f:	90                   	nop

00104140 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  104140:	55                   	push   %ebp
  104141:	89 e5                	mov    %esp,%ebp
  104143:	53                   	push   %ebx
  104144:	83 ec 14             	sub    $0x14,%esp
  104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10414a:	89 1c 24             	mov    %ebx,(%esp)
  10414d:	e8 ae ff ff ff       	call   104100 <holding>
  104152:	85 c0                	test   %eax,%eax
  104154:	74 1d                	je     104173 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104156:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10415d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10415f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104166:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  104169:	83 c4 14             	add    $0x14,%esp
  10416c:	5b                   	pop    %ebx
  10416d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10416e:	e9 bd fe ff ff       	jmp    104030 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  104173:	c7 04 24 be 67 10 00 	movl   $0x1067be,(%esp)
  10417a:	e8 61 c7 ff ff       	call   1008e0 <panic>
  10417f:	90                   	nop

00104180 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104180:	55                   	push   %ebp
  104181:	89 e5                	mov    %esp,%ebp
  104183:	53                   	push   %ebx
  104184:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104187:	e8 24 ff ff ff       	call   1040b0 <pushcli>
  if(holding(lock))
  10418c:	8b 45 08             	mov    0x8(%ebp),%eax
  10418f:	89 04 24             	mov    %eax,(%esp)
  104192:	e8 69 ff ff ff       	call   104100 <holding>
  104197:	85 c0                	test   %eax,%eax
  104199:	75 3d                	jne    1041d8 <acquire+0x58>
    panic("acquire");
  10419b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10419e:	ba 01 00 00 00       	mov    $0x1,%edx
  1041a3:	90                   	nop
  1041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1041a8:	89 d0                	mov    %edx,%eax
  1041aa:	f0 87 03             	lock xchg %eax,(%ebx)

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1041ad:	83 f8 01             	cmp    $0x1,%eax
  1041b0:	74 f6                	je     1041a8 <acquire+0x28>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1041b2:	e8 b9 e6 ff ff       	call   102870 <cpu>
  1041b7:	83 c0 0a             	add    $0xa,%eax
  1041ba:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  1041bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1041c0:	83 c0 0c             	add    $0xc,%eax
  1041c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1041c7:	8d 45 08             	lea    0x8(%ebp),%eax
  1041ca:	89 04 24             	mov    %eax,(%esp)
  1041cd:	e8 0e fe ff ff       	call   103fe0 <getcallerpcs>
}
  1041d2:	83 c4 14             	add    $0x14,%esp
  1041d5:	5b                   	pop    %ebx
  1041d6:	5d                   	pop    %ebp
  1041d7:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  1041d8:	c7 04 24 c6 67 10 00 	movl   $0x1067c6,(%esp)
  1041df:	e8 fc c6 ff ff       	call   1008e0 <panic>
  1041e4:	90                   	nop
  1041e5:	90                   	nop
  1041e6:	90                   	nop
  1041e7:	90                   	nop
  1041e8:	90                   	nop
  1041e9:	90                   	nop
  1041ea:	90                   	nop
  1041eb:	90                   	nop
  1041ec:	90                   	nop
  1041ed:	90                   	nop
  1041ee:	90                   	nop
  1041ef:	90                   	nop

001041f0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  1041f0:	55                   	push   %ebp
  1041f1:	89 e5                	mov    %esp,%ebp
  1041f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1041f6:	53                   	push   %ebx
  1041f7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  1041fa:	85 c9                	test   %ecx,%ecx
  1041fc:	74 14                	je     104212 <memset+0x22>
  1041fe:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
  104202:	31 d2                	xor    %edx,%edx
  104204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
  104208:	88 1c 10             	mov    %bl,(%eax,%edx,1)
  10420b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10420e:	39 ca                	cmp    %ecx,%edx
  104210:	75 f6                	jne    104208 <memset+0x18>
    *d++ = c;

  return dst;
}
  104212:	5b                   	pop    %ebx
  104213:	5d                   	pop    %ebp
  104214:	c3                   	ret    
  104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104220 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104220:	55                   	push   %ebp
  104221:	89 e5                	mov    %esp,%ebp
  104223:	57                   	push   %edi
  104224:	56                   	push   %esi
  104225:	53                   	push   %ebx
  104226:	8b 55 10             	mov    0x10(%ebp),%edx
  104229:	8b 75 08             	mov    0x8(%ebp),%esi
  10422c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10422f:	85 d2                	test   %edx,%edx
  104231:	74 2d                	je     104260 <memcmp+0x40>
    if(*s1 != *s2)
  104233:	0f b6 1e             	movzbl (%esi),%ebx
  104236:	0f b6 0f             	movzbl (%edi),%ecx
  104239:	38 cb                	cmp    %cl,%bl
  10423b:	75 2b                	jne    104268 <memcmp+0x48>
      return *s1 - *s2;
  10423d:	83 ea 01             	sub    $0x1,%edx
  104240:	31 c0                	xor    %eax,%eax
  104242:	eb 18                	jmp    10425c <memcmp+0x3c>
  104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104248:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  10424d:	83 ea 01             	sub    $0x1,%edx
  104250:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  104255:	83 c0 01             	add    $0x1,%eax
  104258:	38 cb                	cmp    %cl,%bl
  10425a:	75 0c                	jne    104268 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10425c:	85 d2                	test   %edx,%edx
  10425e:	75 e8                	jne    104248 <memcmp+0x28>
  104260:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104262:	5b                   	pop    %ebx
  104263:	5e                   	pop    %esi
  104264:	5f                   	pop    %edi
  104265:	5d                   	pop    %ebp
  104266:	c3                   	ret    
  104267:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104268:	0f b6 c3             	movzbl %bl,%eax
  10426b:	0f b6 c9             	movzbl %cl,%ecx
  10426e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104270:	5b                   	pop    %ebx
  104271:	5e                   	pop    %esi
  104272:	5f                   	pop    %edi
  104273:	5d                   	pop    %ebp
  104274:	c3                   	ret    
  104275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104280 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104280:	55                   	push   %ebp
  104281:	89 e5                	mov    %esp,%ebp
  104283:	57                   	push   %edi
  104284:	56                   	push   %esi
  104285:	53                   	push   %ebx
  104286:	8b 45 08             	mov    0x8(%ebp),%eax
  104289:	8b 75 0c             	mov    0xc(%ebp),%esi
  10428c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10428f:	39 c6                	cmp    %eax,%esi
  104291:	73 2d                	jae    1042c0 <memmove+0x40>
  104293:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104296:	39 f8                	cmp    %edi,%eax
  104298:	73 26                	jae    1042c0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10429a:	85 db                	test   %ebx,%ebx
  10429c:	74 1d                	je     1042bb <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10429e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  1042a1:	31 d2                	xor    %edx,%edx
  1042a3:	90                   	nop
  1042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  1042a8:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  1042ad:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  1042b1:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1042b4:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  1042b7:	85 c9                	test   %ecx,%ecx
  1042b9:	75 ed                	jne    1042a8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  1042bb:	5b                   	pop    %ebx
  1042bc:	5e                   	pop    %esi
  1042bd:	5f                   	pop    %edi
  1042be:	5d                   	pop    %ebp
  1042bf:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1042c0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  1042c2:	85 db                	test   %ebx,%ebx
  1042c4:	74 f5                	je     1042bb <memmove+0x3b>
  1042c6:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  1042c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  1042cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1042cf:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  1042d2:	39 d3                	cmp    %edx,%ebx
  1042d4:	75 f2                	jne    1042c8 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  1042d6:	5b                   	pop    %ebx
  1042d7:	5e                   	pop    %esi
  1042d8:	5f                   	pop    %edi
  1042d9:	5d                   	pop    %ebp
  1042da:	c3                   	ret    
  1042db:	90                   	nop
  1042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  1042e0:	55                   	push   %ebp
  1042e1:	89 e5                	mov    %esp,%ebp
  1042e3:	57                   	push   %edi
  1042e4:	56                   	push   %esi
  1042e5:	53                   	push   %ebx
  1042e6:	8b 7d 10             	mov    0x10(%ebp),%edi
  1042e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1042ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  1042ef:	85 ff                	test   %edi,%edi
  1042f1:	74 3d                	je     104330 <strncmp+0x50>
  1042f3:	0f b6 01             	movzbl (%ecx),%eax
  1042f6:	84 c0                	test   %al,%al
  1042f8:	75 18                	jne    104312 <strncmp+0x32>
  1042fa:	eb 3c                	jmp    104338 <strncmp+0x58>
  1042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104300:	83 ef 01             	sub    $0x1,%edi
  104303:	74 2b                	je     104330 <strncmp+0x50>
    n--, p++, q++;
  104305:	83 c1 01             	add    $0x1,%ecx
  104308:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  10430b:	0f b6 01             	movzbl (%ecx),%eax
  10430e:	84 c0                	test   %al,%al
  104310:	74 26                	je     104338 <strncmp+0x58>
  104312:	0f b6 33             	movzbl (%ebx),%esi
  104315:	89 f2                	mov    %esi,%edx
  104317:	38 d0                	cmp    %dl,%al
  104319:	74 e5                	je     104300 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10431b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  104321:	0f b6 c0             	movzbl %al,%eax
  104324:	29 f0                	sub    %esi,%eax
}
  104326:	5b                   	pop    %ebx
  104327:	5e                   	pop    %esi
  104328:	5f                   	pop    %edi
  104329:	5d                   	pop    %ebp
  10432a:	c3                   	ret    
  10432b:	90                   	nop
  10432c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104330:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  104332:	5b                   	pop    %ebx
  104333:	5e                   	pop    %esi
  104334:	5f                   	pop    %edi
  104335:	5d                   	pop    %ebp
  104336:	c3                   	ret    
  104337:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104338:	0f b6 33             	movzbl (%ebx),%esi
  10433b:	eb de                	jmp    10431b <strncmp+0x3b>
  10433d:	8d 76 00             	lea    0x0(%esi),%esi

00104340 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  104340:	55                   	push   %ebp
  104341:	89 e5                	mov    %esp,%ebp
  104343:	8b 45 08             	mov    0x8(%ebp),%eax
  104346:	56                   	push   %esi
  104347:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10434a:	53                   	push   %ebx
  10434b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10434e:	89 c3                	mov    %eax,%ebx
  104350:	eb 09                	jmp    10435b <strncpy+0x1b>
  104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104358:	83 c6 01             	add    $0x1,%esi
  10435b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10435e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104361:	85 d2                	test   %edx,%edx
  104363:	7e 0c                	jle    104371 <strncpy+0x31>
  104365:	0f b6 16             	movzbl (%esi),%edx
  104368:	88 13                	mov    %dl,(%ebx)
  10436a:	83 c3 01             	add    $0x1,%ebx
  10436d:	84 d2                	test   %dl,%dl
  10436f:	75 e7                	jne    104358 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104371:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104373:	85 c9                	test   %ecx,%ecx
  104375:	7e 0c                	jle    104383 <strncpy+0x43>
  104377:	90                   	nop
    *s++ = 0;
  104378:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10437c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10437f:	39 ca                	cmp    %ecx,%edx
  104381:	75 f5                	jne    104378 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104383:	5b                   	pop    %ebx
  104384:	5e                   	pop    %esi
  104385:	5d                   	pop    %ebp
  104386:	c3                   	ret    
  104387:	89 f6                	mov    %esi,%esi
  104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104390 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104390:	55                   	push   %ebp
  104391:	89 e5                	mov    %esp,%ebp
  104393:	8b 55 10             	mov    0x10(%ebp),%edx
  104396:	56                   	push   %esi
  104397:	8b 45 08             	mov    0x8(%ebp),%eax
  10439a:	53                   	push   %ebx
  10439b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10439e:	85 d2                	test   %edx,%edx
  1043a0:	7e 1f                	jle    1043c1 <safestrcpy+0x31>
  1043a2:	89 c1                	mov    %eax,%ecx
  1043a4:	eb 05                	jmp    1043ab <safestrcpy+0x1b>
  1043a6:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1043a8:	83 c6 01             	add    $0x1,%esi
  1043ab:	83 ea 01             	sub    $0x1,%edx
  1043ae:	85 d2                	test   %edx,%edx
  1043b0:	7e 0c                	jle    1043be <safestrcpy+0x2e>
  1043b2:	0f b6 1e             	movzbl (%esi),%ebx
  1043b5:	88 19                	mov    %bl,(%ecx)
  1043b7:	83 c1 01             	add    $0x1,%ecx
  1043ba:	84 db                	test   %bl,%bl
  1043bc:	75 ea                	jne    1043a8 <safestrcpy+0x18>
    ;
  *s = 0;
  1043be:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  1043c1:	5b                   	pop    %ebx
  1043c2:	5e                   	pop    %esi
  1043c3:	5d                   	pop    %ebp
  1043c4:	c3                   	ret    
  1043c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001043d0 <strlen>:

int
strlen(const char *s)
{
  1043d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  1043d1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  1043d3:	89 e5                	mov    %esp,%ebp
  1043d5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  1043d8:	80 3a 00             	cmpb   $0x0,(%edx)
  1043db:	74 0c                	je     1043e9 <strlen+0x19>
  1043dd:	8d 76 00             	lea    0x0(%esi),%esi
  1043e0:	83 c0 01             	add    $0x1,%eax
  1043e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1043e7:	75 f7                	jne    1043e0 <strlen+0x10>
    ;
  return n;
}
  1043e9:	5d                   	pop    %ebp
  1043ea:	c3                   	ret    
  1043eb:	90                   	nop

001043ec <swtch>:
  1043ec:	8b 44 24 04          	mov    0x4(%esp),%eax
  1043f0:	8f 00                	popl   (%eax)
  1043f2:	89 60 04             	mov    %esp,0x4(%eax)
  1043f5:	89 58 08             	mov    %ebx,0x8(%eax)
  1043f8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1043fb:	89 50 10             	mov    %edx,0x10(%eax)
  1043fe:	89 70 14             	mov    %esi,0x14(%eax)
  104401:	89 78 18             	mov    %edi,0x18(%eax)
  104404:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104407:	8b 44 24 04          	mov    0x4(%esp),%eax
  10440b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10440e:	8b 78 18             	mov    0x18(%eax),%edi
  104411:	8b 70 14             	mov    0x14(%eax),%esi
  104414:	8b 50 10             	mov    0x10(%eax),%edx
  104417:	8b 48 0c             	mov    0xc(%eax),%ecx
  10441a:	8b 58 08             	mov    0x8(%eax),%ebx
  10441d:	8b 60 04             	mov    0x4(%eax),%esp
  104420:	ff 30                	pushl  (%eax)
  104422:	c3                   	ret    
  104423:	90                   	nop
  104424:	90                   	nop
  104425:	90                   	nop
  104426:	90                   	nop
  104427:	90                   	nop
  104428:	90                   	nop
  104429:	90                   	nop
  10442a:	90                   	nop
  10442b:	90                   	nop
  10442c:	90                   	nop
  10442d:	90                   	nop
  10442e:	90                   	nop
  10442f:	90                   	nop

00104430 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104436:	53                   	push   %ebx
  104437:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  10443a:	8b 51 04             	mov    0x4(%ecx),%edx
  10443d:	39 c2                	cmp    %eax,%edx
  10443f:	77 0f                	ja     104450 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104446:	5b                   	pop    %ebx
  104447:	5d                   	pop    %ebp
  104448:	c3                   	ret    
  104449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104450:	8d 58 04             	lea    0x4(%eax),%ebx
  104453:	39 da                	cmp    %ebx,%edx
  104455:	72 ea                	jb     104441 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104457:	8b 11                	mov    (%ecx),%edx
  104459:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10445c:	8b 45 10             	mov    0x10(%ebp),%eax
  10445f:	89 10                	mov    %edx,(%eax)
  104461:	31 c0                	xor    %eax,%eax
  return 0;
  104463:	eb e1                	jmp    104446 <fetchint+0x16>
  104465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104470 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104470:	55                   	push   %ebp
  104471:	89 e5                	mov    %esp,%ebp
  104473:	8b 45 08             	mov    0x8(%ebp),%eax
  104476:	8b 55 0c             	mov    0xc(%ebp),%edx
  104479:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10447a:	39 50 04             	cmp    %edx,0x4(%eax)
  10447d:	77 09                	ja     104488 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10447f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104484:	5b                   	pop    %ebx
  104485:	5d                   	pop    %ebp
  104486:	c3                   	ret    
  104487:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104488:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10448b:	03 10                	add    (%eax),%edx
  10448d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  10448f:	8b 18                	mov    (%eax),%ebx
  104491:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104494:	39 da                	cmp    %ebx,%edx
  104496:	73 e7                	jae    10447f <fetchstr+0xf>
    if(*s == 0)
  104498:	31 c0                	xor    %eax,%eax
  10449a:	89 d1                	mov    %edx,%ecx
  10449c:	80 3a 00             	cmpb   $0x0,(%edx)
  10449f:	74 e3                	je     104484 <fetchstr+0x14>
  1044a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1044a8:	83 c1 01             	add    $0x1,%ecx
  1044ab:	39 cb                	cmp    %ecx,%ebx
  1044ad:	76 d0                	jbe    10447f <fetchstr+0xf>
    if(*s == 0)
  1044af:	80 39 00             	cmpb   $0x0,(%ecx)
  1044b2:	75 f4                	jne    1044a8 <fetchstr+0x38>
  1044b4:	89 c8                	mov    %ecx,%eax
  1044b6:	29 d0                	sub    %edx,%eax
  1044b8:	eb ca                	jmp    104484 <fetchstr+0x14>
  1044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001044c0 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1044c0:	55                   	push   %ebp
  1044c1:	89 e5                	mov    %esp,%ebp
  1044c3:	53                   	push   %ebx
  1044c4:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1044c7:	e8 d4 ee ff ff       	call   1033a0 <curproc>
  1044cc:	8b 55 08             	mov    0x8(%ebp),%edx
  1044cf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1044d5:	8b 40 3c             	mov    0x3c(%eax),%eax
  1044d8:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  1044dc:	e8 bf ee ff ff       	call   1033a0 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1044e1:	8b 50 04             	mov    0x4(%eax),%edx
  1044e4:	39 d3                	cmp    %edx,%ebx
  1044e6:	72 10                	jb     1044f8 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1044e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  1044ed:	83 c4 04             	add    $0x4,%esp
  1044f0:	5b                   	pop    %ebx
  1044f1:	5d                   	pop    %ebp
  1044f2:	c3                   	ret    
  1044f3:	90                   	nop
  1044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1044f8:	8d 4b 04             	lea    0x4(%ebx),%ecx
  1044fb:	39 ca                	cmp    %ecx,%edx
  1044fd:	72 e9                	jb     1044e8 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1044ff:	8b 00                	mov    (%eax),%eax
  104501:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104504:	8b 45 0c             	mov    0xc(%ebp),%eax
  104507:	89 10                	mov    %edx,(%eax)
  104509:	31 c0                	xor    %eax,%eax
  10450b:	eb e0                	jmp    1044ed <argint+0x2d>
  10450d:	8d 76 00             	lea    0x0(%esi),%esi

00104510 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	53                   	push   %ebx
  104514:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104517:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10451a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10451e:	8b 45 08             	mov    0x8(%ebp),%eax
  104521:	89 04 24             	mov    %eax,(%esp)
  104524:	e8 97 ff ff ff       	call   1044c0 <argint>
  104529:	85 c0                	test   %eax,%eax
  10452b:	78 3b                	js     104568 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  10452d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104530:	e8 6b ee ff ff       	call   1033a0 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104535:	3b 58 04             	cmp    0x4(%eax),%ebx
  104538:	73 2e                	jae    104568 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  10453a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10453d:	03 18                	add    (%eax),%ebx
  10453f:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104541:	8b 08                	mov    (%eax),%ecx
  104543:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104546:	39 cb                	cmp    %ecx,%ebx
  104548:	73 1e                	jae    104568 <argstr+0x58>
    if(*s == 0)
  10454a:	31 c0                	xor    %eax,%eax
  10454c:	89 da                	mov    %ebx,%edx
  10454e:	80 3b 00             	cmpb   $0x0,(%ebx)
  104551:	75 0a                	jne    10455d <argstr+0x4d>
  104553:	eb 18                	jmp    10456d <argstr+0x5d>
  104555:	8d 76 00             	lea    0x0(%esi),%esi
  104558:	80 3a 00             	cmpb   $0x0,(%edx)
  10455b:	74 1b                	je     104578 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10455d:	83 c2 01             	add    $0x1,%edx
  104560:	39 d1                	cmp    %edx,%ecx
  104562:	77 f4                	ja     104558 <argstr+0x48>
  104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10456d:	83 c4 24             	add    $0x24,%esp
  104570:	5b                   	pop    %ebx
  104571:	5d                   	pop    %ebp
  104572:	c3                   	ret    
  104573:	90                   	nop
  104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104578:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10457a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10457d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10457f:	5b                   	pop    %ebx
  104580:	5d                   	pop    %ebp
  104581:	c3                   	ret    
  104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104590 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	53                   	push   %ebx
  104594:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10459a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10459e:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a1:	89 04 24             	mov    %eax,(%esp)
  1045a4:	e8 17 ff ff ff       	call   1044c0 <argint>
  1045a9:	85 c0                	test   %eax,%eax
  1045ab:	79 0b                	jns    1045b8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1045ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1045b2:	83 c4 24             	add    $0x24,%esp
  1045b5:	5b                   	pop    %ebx
  1045b6:	5d                   	pop    %ebp
  1045b7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1045b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1045bb:	e8 e0 ed ff ff       	call   1033a0 <curproc>
  1045c0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1045c3:	73 e8                	jae    1045ad <argptr+0x1d>
  1045c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1045c8:	03 5d f4             	add    -0xc(%ebp),%ebx
  1045cb:	e8 d0 ed ff ff       	call   1033a0 <curproc>
  1045d0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1045d3:	73 d8                	jae    1045ad <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1045d5:	e8 c6 ed ff ff       	call   1033a0 <curproc>
  1045da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1045dd:	8b 00                	mov    (%eax),%eax
  1045df:	03 45 f4             	add    -0xc(%ebp),%eax
  1045e2:	89 02                	mov    %eax,(%edx)
  1045e4:	31 c0                	xor    %eax,%eax
  return 0;
  1045e6:	eb ca                	jmp    1045b2 <argptr+0x22>
  1045e8:	90                   	nop
  1045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001045f0 <syscall>:
[SYS_fork_tickets]   	sys_fork_tickets,
};

void
syscall(void)
{
  1045f0:	55                   	push   %ebp
  1045f1:	89 e5                	mov    %esp,%ebp
  1045f3:	83 ec 18             	sub    $0x18,%esp
  1045f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1045f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1045fc:	e8 9f ed ff ff       	call   1033a0 <curproc>
  104601:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104607:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  10460a:	83 fb 16             	cmp    $0x16,%ebx
  10460d:	77 29                	ja     104638 <syscall+0x48>
  10460f:	8b 34 9d 00 68 10 00 	mov    0x106800(,%ebx,4),%esi
  104616:	85 f6                	test   %esi,%esi
  104618:	74 1e                	je     104638 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  10461a:	e8 81 ed ff ff       	call   1033a0 <curproc>
  10461f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104625:	ff d6                	call   *%esi
  104627:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10462a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10462d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104630:	89 ec                	mov    %ebp,%esp
  104632:	5d                   	pop    %ebp
  104633:	c3                   	ret    
  104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104638:	e8 63 ed ff ff       	call   1033a0 <curproc>
  10463d:	89 c6                	mov    %eax,%esi
  10463f:	e8 5c ed ff ff       	call   1033a0 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104644:	81 c6 88 00 00 00    	add    $0x88,%esi
  10464a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10464e:	89 74 24 08          	mov    %esi,0x8(%esp)
  104652:	8b 40 10             	mov    0x10(%eax),%eax
  104655:	c7 04 24 ce 67 10 00 	movl   $0x1067ce,(%esp)
  10465c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104660:	e8 db c0 ff ff       	call   100740 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104665:	e8 36 ed ff ff       	call   1033a0 <curproc>
  10466a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104670:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104677:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10467a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10467d:	89 ec                	mov    %ebp,%esp
  10467f:	5d                   	pop    %ebp
  104680:	c3                   	ret    
  104681:	90                   	nop
  104682:	90                   	nop
  104683:	90                   	nop
  104684:	90                   	nop
  104685:	90                   	nop
  104686:	90                   	nop
  104687:	90                   	nop
  104688:	90                   	nop
  104689:	90                   	nop
  10468a:	90                   	nop
  10468b:	90                   	nop
  10468c:	90                   	nop
  10468d:	90                   	nop
  10468e:	90                   	nop
  10468f:	90                   	nop

00104690 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104690:	55                   	push   %ebp
  104691:	89 e5                	mov    %esp,%ebp
  104693:	57                   	push   %edi
  104694:	89 c7                	mov    %eax,%edi
  104696:	56                   	push   %esi
  104697:	53                   	push   %ebx
  104698:	31 db                	xor    %ebx,%ebx
  10469a:	83 ec 0c             	sub    $0xc,%esp
  10469d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  1046a0:	e8 fb ec ff ff       	call   1033a0 <curproc>
  1046a5:	8d 73 08             	lea    0x8(%ebx),%esi
  1046a8:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1046ab:	85 c0                	test   %eax,%eax
  1046ad:	74 19                	je     1046c8 <fdalloc+0x38>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1046af:	83 c3 01             	add    $0x1,%ebx
  1046b2:	83 fb 10             	cmp    $0x10,%ebx
  1046b5:	75 e9                	jne    1046a0 <fdalloc+0x10>
  1046b7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  1046bc:	83 c4 0c             	add    $0xc,%esp
  1046bf:	89 d8                	mov    %ebx,%eax
  1046c1:	5b                   	pop    %ebx
  1046c2:	5e                   	pop    %esi
  1046c3:	5f                   	pop    %edi
  1046c4:	5d                   	pop    %ebp
  1046c5:	c3                   	ret    
  1046c6:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  1046c8:	e8 d3 ec ff ff       	call   1033a0 <curproc>
  1046cd:	89 3c b0             	mov    %edi,(%eax,%esi,4)
      return fd;
    }
  }
  return -1;
}
  1046d0:	83 c4 0c             	add    $0xc,%esp
  1046d3:	89 d8                	mov    %ebx,%eax
  1046d5:	5b                   	pop    %ebx
  1046d6:	5e                   	pop    %esi
  1046d7:	5f                   	pop    %edi
  1046d8:	5d                   	pop    %ebp
  1046d9:	c3                   	ret    
  1046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001046e0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  1046e0:	55                   	push   %ebp
  1046e1:	89 e5                	mov    %esp,%ebp
  1046e3:	53                   	push   %ebx
  1046e4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  1046e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1046ea:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1046f1:	00 
  1046f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1046fd:	e8 8e fe ff ff       	call   104590 <argptr>
  104702:	85 c0                	test   %eax,%eax
  104704:	79 12                	jns    104718 <sys_pipe+0x38>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10470b:	83 c4 24             	add    $0x24,%esp
  10470e:	5b                   	pop    %ebx
  10470f:	5d                   	pop    %ebp
  104710:	c3                   	ret    
  104711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104718:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10471b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10471f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104722:	89 04 24             	mov    %eax,(%esp)
  104725:	e8 26 e9 ff ff       	call   103050 <pipealloc>
  10472a:	85 c0                	test   %eax,%eax
  10472c:	78 d8                	js     104706 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10472e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104731:	e8 5a ff ff ff       	call   104690 <fdalloc>
  104736:	85 c0                	test   %eax,%eax
  104738:	89 c3                	mov    %eax,%ebx
  10473a:	78 25                	js     104761 <sys_pipe+0x81>
  10473c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10473f:	e8 4c ff ff ff       	call   104690 <fdalloc>
  104744:	85 c0                	test   %eax,%eax
  104746:	78 0c                	js     104754 <sys_pipe+0x74>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  fd[1] = fd1;
  10474b:	89 42 04             	mov    %eax,0x4(%edx)
  10474e:	31 c0                	xor    %eax,%eax
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104750:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
  return 0;
  104752:	eb b7                	jmp    10470b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104754:	e8 47 ec ff ff       	call   1033a0 <curproc>
  104759:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104760:	00 
    fileclose(rf);
  104761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104764:	89 04 24             	mov    %eax,(%esp)
  104767:	e8 84 c8 ff ff       	call   100ff0 <fileclose>
    fileclose(wf);
  10476c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10476f:	89 04 24             	mov    %eax,(%esp)
  104772:	e8 79 c8 ff ff       	call   100ff0 <fileclose>
  104777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  10477c:	eb 8d                	jmp    10470b <sys_pipe+0x2b>
  10477e:	66 90                	xchg   %ax,%ax

00104780 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104780:	55                   	push   %ebp
  104781:	89 e5                	mov    %esp,%ebp
  104783:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104789:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  10478c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10478f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104792:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104795:	89 44 24 04          	mov    %eax,0x4(%esp)
  104799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1047a0:	e8 6b fd ff ff       	call   104510 <argstr>
  1047a5:	85 c0                	test   %eax,%eax
  1047a7:	79 17                	jns    1047c0 <sys_exec+0x40>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  1047a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  1047ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1047b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1047b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1047b7:	89 ec                	mov    %ebp,%esp
  1047b9:	5d                   	pop    %ebp
  1047ba:	c3                   	ret    
  1047bb:	90                   	nop
  1047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  1047c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1047c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1047ce:	e8 ed fc ff ff       	call   1044c0 <argint>
  1047d3:	85 c0                	test   %eax,%eax
  1047d5:	78 d2                	js     1047a9 <sys_exec+0x29>
    return -1;
  memset(argv, 0, sizeof(argv));
  1047d7:	8d 45 8c             	lea    -0x74(%ebp),%eax
  1047da:	31 ff                	xor    %edi,%edi
  1047dc:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  1047e3:	00 
  1047e4:	31 db                	xor    %ebx,%ebx
  1047e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047ed:	00 
  1047ee:	89 04 24             	mov    %eax,(%esp)
  1047f1:	e8 fa f9 ff ff       	call   1041f0 <memset>
  1047f6:	eb 27                	jmp    10481f <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  1047f8:	e8 a3 eb ff ff       	call   1033a0 <curproc>
  1047fd:	8d 54 bd 8c          	lea    -0x74(%ebp,%edi,4),%edx
  104801:	89 54 24 08          	mov    %edx,0x8(%esp)
  104805:	89 74 24 04          	mov    %esi,0x4(%esp)
  104809:	89 04 24             	mov    %eax,(%esp)
  10480c:	e8 5f fc ff ff       	call   104470 <fetchstr>
  104811:	85 c0                	test   %eax,%eax
  104813:	78 94                	js     1047a9 <sys_exec+0x29>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104815:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104818:	83 fb 14             	cmp    $0x14,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  10481b:	89 df                	mov    %ebx,%edi
    if(i >= NELEM(argv))
  10481d:	74 8a                	je     1047a9 <sys_exec+0x29>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  10481f:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
  104826:	03 75 e0             	add    -0x20(%ebp),%esi
  104829:	e8 72 eb ff ff       	call   1033a0 <curproc>
  10482e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104831:	89 54 24 08          	mov    %edx,0x8(%esp)
  104835:	89 74 24 04          	mov    %esi,0x4(%esp)
  104839:	89 04 24             	mov    %eax,(%esp)
  10483c:	e8 ef fb ff ff       	call   104430 <fetchint>
  104841:	85 c0                	test   %eax,%eax
  104843:	0f 88 60 ff ff ff    	js     1047a9 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  104849:	8b 75 dc             	mov    -0x24(%ebp),%esi
  10484c:	85 f6                	test   %esi,%esi
  10484e:	75 a8                	jne    1047f8 <sys_exec+0x78>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104850:	8d 45 8c             	lea    -0x74(%ebp),%eax
  104853:	89 44 24 04          	mov    %eax,0x4(%esp)
  104857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  10485a:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  104861:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104862:	89 04 24             	mov    %eax,(%esp)
  104865:	e8 f6 c0 ff ff       	call   100960 <exec>
  10486a:	e9 3f ff ff ff       	jmp    1047ae <sys_exec+0x2e>
  10486f:	90                   	nop

00104870 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104870:	55                   	push   %ebp
  104871:	89 e5                	mov    %esp,%ebp
  104873:	53                   	push   %ebx
  104874:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10487a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10487e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104885:	e8 86 fc ff ff       	call   104510 <argstr>
  10488a:	85 c0                	test   %eax,%eax
  10488c:	79 12                	jns    1048a0 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  10488e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104893:	83 c4 24             	add    $0x24,%esp
  104896:	5b                   	pop    %ebx
  104897:	5d                   	pop    %ebp
  104898:	c3                   	ret    
  104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  1048a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048a3:	89 04 24             	mov    %eax,(%esp)
  1048a6:	e8 65 d6 ff ff       	call   101f10 <namei>
  1048ab:	85 c0                	test   %eax,%eax
  1048ad:	89 c3                	mov    %eax,%ebx
  1048af:	74 dd                	je     10488e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  1048b1:	89 04 24             	mov    %eax,(%esp)
  1048b4:	e8 97 d3 ff ff       	call   101c50 <ilock>
  if(ip->type != T_DIR){
  1048b9:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1048be:	75 24                	jne    1048e4 <sys_chdir+0x74>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1048c0:	89 1c 24             	mov    %ebx,(%esp)
  1048c3:	e8 18 d3 ff ff       	call   101be0 <iunlock>
  iput(cp->cwd);
  1048c8:	e8 d3 ea ff ff       	call   1033a0 <curproc>
  1048cd:	8b 40 60             	mov    0x60(%eax),%eax
  1048d0:	89 04 24             	mov    %eax,(%esp)
  1048d3:	e8 c8 d0 ff ff       	call   1019a0 <iput>
  cp->cwd = ip;
  1048d8:	e8 c3 ea ff ff       	call   1033a0 <curproc>
  1048dd:	89 58 60             	mov    %ebx,0x60(%eax)
  1048e0:	31 c0                	xor    %eax,%eax
  return 0;
  1048e2:	eb af                	jmp    104893 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  1048e4:	89 1c 24             	mov    %ebx,(%esp)
  1048e7:	e8 44 d3 ff ff       	call   101c30 <iunlockput>
  1048ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1048f1:	eb a0                	jmp    104893 <sys_chdir+0x23>
  1048f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104900 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104900:	55                   	push   %ebp
  104901:	89 e5                	mov    %esp,%ebp
  104903:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104906:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104909:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10490c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10490f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104912:	89 44 24 04          	mov    %eax,0x4(%esp)
  104916:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10491d:	e8 ee fb ff ff       	call   104510 <argstr>
  104922:	85 c0                	test   %eax,%eax
  104924:	79 12                	jns    104938 <sys_link+0x38>
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10492b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10492e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104931:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104934:	89 ec                	mov    %ebp,%esp
  104936:	5d                   	pop    %ebp
  104937:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104938:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10493b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10493f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104946:	e8 c5 fb ff ff       	call   104510 <argstr>
  10494b:	85 c0                	test   %eax,%eax
  10494d:	78 d7                	js     104926 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  10494f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104952:	89 04 24             	mov    %eax,(%esp)
  104955:	e8 b6 d5 ff ff       	call   101f10 <namei>
  10495a:	85 c0                	test   %eax,%eax
  10495c:	89 c3                	mov    %eax,%ebx
  10495e:	74 c6                	je     104926 <sys_link+0x26>
    return -1;
  ilock(ip);
  104960:	89 04 24             	mov    %eax,(%esp)
  104963:	e8 e8 d2 ff ff       	call   101c50 <ilock>
  if(ip->type == T_DIR){
  104968:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10496d:	0f 84 86 00 00 00    	je     1049f9 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104973:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104978:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  10497b:	89 1c 24             	mov    %ebx,(%esp)
  10497e:	e8 9d cb ff ff       	call   101520 <iupdate>
  iunlock(ip);
  104983:	89 1c 24             	mov    %ebx,(%esp)
  104986:	e8 55 d2 ff ff       	call   101be0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  10498b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10498e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104992:	89 04 24             	mov    %eax,(%esp)
  104995:	e8 56 d5 ff ff       	call   101ef0 <nameiparent>
  10499a:	85 c0                	test   %eax,%eax
  10499c:	89 c6                	mov    %eax,%esi
  10499e:	74 44                	je     1049e4 <sys_link+0xe4>
    goto  bad;
  ilock(dp);
  1049a0:	89 04 24             	mov    %eax,(%esp)
  1049a3:	e8 a8 d2 ff ff       	call   101c50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  1049a8:	8b 06                	mov    (%esi),%eax
  1049aa:	3b 03                	cmp    (%ebx),%eax
  1049ac:	75 2e                	jne    1049dc <sys_link+0xdc>
  1049ae:	8b 43 04             	mov    0x4(%ebx),%eax
  1049b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1049b5:	89 34 24             	mov    %esi,(%esp)
  1049b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1049bc:	e8 2f d1 ff ff       	call   101af0 <dirlink>
  1049c1:	85 c0                	test   %eax,%eax
  1049c3:	78 17                	js     1049dc <sys_link+0xdc>
    goto bad;
  iunlockput(dp);
  1049c5:	89 34 24             	mov    %esi,(%esp)
  1049c8:	e8 63 d2 ff ff       	call   101c30 <iunlockput>
  iput(ip);
  1049cd:	89 1c 24             	mov    %ebx,(%esp)
  1049d0:	e8 cb cf ff ff       	call   1019a0 <iput>
  1049d5:	31 c0                	xor    %eax,%eax
  return 0;
  1049d7:	e9 4f ff ff ff       	jmp    10492b <sys_link+0x2b>

bad:
  if(dp)
    iunlockput(dp);
  1049dc:	89 34 24             	mov    %esi,(%esp)
  1049df:	e8 4c d2 ff ff       	call   101c30 <iunlockput>
  ilock(ip);
  1049e4:	89 1c 24             	mov    %ebx,(%esp)
  1049e7:	e8 64 d2 ff ff       	call   101c50 <ilock>
  ip->nlink--;
  1049ec:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  1049f1:	89 1c 24             	mov    %ebx,(%esp)
  1049f4:	e8 27 cb ff ff       	call   101520 <iupdate>
  iunlockput(ip);
  1049f9:	89 1c 24             	mov    %ebx,(%esp)
  1049fc:	e8 2f d2 ff ff       	call   101c30 <iunlockput>
  104a01:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104a04:	e9 22 ff ff ff       	jmp    10492b <sys_link+0x2b>
  104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104a10 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104a10:	55                   	push   %ebp
  104a11:	89 e5                	mov    %esp,%ebp
  104a13:	57                   	push   %edi
  104a14:	89 cf                	mov    %ecx,%edi
  104a16:	56                   	push   %esi
  104a17:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104a18:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104a1a:	83 ec 4c             	sub    $0x4c,%esp
  104a1d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104a20:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104a24:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104a27:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
  104a2b:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104a2f:	66 89 55 c0          	mov    %dx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104a33:	89 74 24 04          	mov    %esi,0x4(%esp)
  104a37:	89 04 24             	mov    %eax,(%esp)
  104a3a:	e8 b1 d4 ff ff       	call   101ef0 <nameiparent>
  104a3f:	85 c0                	test   %eax,%eax
  104a41:	74 67                	je     104aaa <create+0x9a>
    return 0;
  ilock(dp);
  104a43:	89 04 24             	mov    %eax,(%esp)
  104a46:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104a49:	e8 02 d2 ff ff       	call   101c50 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104a4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104a51:	85 d2                	test   %edx,%edx
  104a53:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104a56:	74 60                	je     104ab8 <create+0xa8>
  104a58:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104a5b:	89 14 24             	mov    %edx,(%esp)
  104a5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104a62:	89 74 24 04          	mov    %esi,0x4(%esp)
  104a66:	e8 a5 cc ff ff       	call   101710 <dirlookup>
  104a6b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104a6e:	85 c0                	test   %eax,%eax
  104a70:	89 c3                	mov    %eax,%ebx
  104a72:	74 44                	je     104ab8 <create+0xa8>
    iunlockput(dp);
  104a74:	89 14 24             	mov    %edx,(%esp)
  104a77:	e8 b4 d1 ff ff       	call   101c30 <iunlockput>
    ilock(ip);
  104a7c:	89 1c 24             	mov    %ebx,(%esp)
  104a7f:	e8 cc d1 ff ff       	call   101c50 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104a84:	66 39 7b 10          	cmp    %di,0x10(%ebx)
  104a88:	0f 85 02 01 00 00    	jne    104b90 <create+0x180>
  104a8e:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  104a92:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104a96:	0f 85 f4 00 00 00    	jne    104b90 <create+0x180>
  104a9c:	0f b7 55 c0          	movzwl -0x40(%ebp),%edx
  104aa0:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104aa4:	0f 85 e6 00 00 00    	jne    104b90 <create+0x180>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104aaa:	83 c4 4c             	add    $0x4c,%esp
  104aad:	89 d8                	mov    %ebx,%eax
  104aaf:	5b                   	pop    %ebx
  104ab0:	5e                   	pop    %esi
  104ab1:	5f                   	pop    %edi
  104ab2:	5d                   	pop    %ebp
  104ab3:	c3                   	ret    
  104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104ab8:	0f bf c7             	movswl %di,%eax
  104abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104abf:	8b 02                	mov    (%edx),%eax
  104ac1:	89 04 24             	mov    %eax,(%esp)
  104ac4:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104ac7:	e8 44 cd ff ff       	call   101810 <ialloc>
  104acc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104acf:	85 c0                	test   %eax,%eax
  104ad1:	89 c3                	mov    %eax,%ebx
  104ad3:	74 50                	je     104b25 <create+0x115>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104ad5:	89 04 24             	mov    %eax,(%esp)
  104ad8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104adb:	e8 70 d1 ff ff       	call   101c50 <ilock>
  ip->major = major;
  104ae0:	0f b7 45 c2          	movzwl -0x3e(%ebp),%eax
  ip->minor = minor;
  ip->nlink = 1;
  104ae4:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104aea:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104aee:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  104af2:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104af6:	89 1c 24             	mov    %ebx,(%esp)
  104af9:	e8 22 ca ff ff       	call   101520 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104afe:	8b 43 04             	mov    0x4(%ebx),%eax
  104b01:	89 74 24 04          	mov    %esi,0x4(%esp)
  104b05:	89 44 24 08          	mov    %eax,0x8(%esp)
  104b09:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b0c:	89 14 24             	mov    %edx,(%esp)
  104b0f:	e8 dc cf ff ff       	call   101af0 <dirlink>
  104b14:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b17:	85 c0                	test   %eax,%eax
  104b19:	0f 88 85 00 00 00    	js     104ba4 <create+0x194>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104b1f:	66 83 ff 01          	cmp    $0x1,%di
  104b23:	74 13                	je     104b38 <create+0x128>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104b25:	89 14 24             	mov    %edx,(%esp)
  104b28:	e8 03 d1 ff ff       	call   101c30 <iunlockput>
  return ip;
}
  104b2d:	83 c4 4c             	add    $0x4c,%esp
  104b30:	89 d8                	mov    %ebx,%eax
  104b32:	5b                   	pop    %ebx
  104b33:	5e                   	pop    %esi
  104b34:	5f                   	pop    %edi
  104b35:	5d                   	pop    %ebp
  104b36:	c3                   	ret    
  104b37:	90                   	nop
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104b38:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  104b3d:	89 14 24             	mov    %edx,(%esp)
  104b40:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104b43:	e8 d8 c9 ff ff       	call   101520 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104b48:	8b 43 04             	mov    0x4(%ebx),%eax
  104b4b:	c7 44 24 04 5d 68 10 	movl   $0x10685d,0x4(%esp)
  104b52:	00 
  104b53:	89 1c 24             	mov    %ebx,(%esp)
  104b56:	89 44 24 08          	mov    %eax,0x8(%esp)
  104b5a:	e8 91 cf ff ff       	call   101af0 <dirlink>
  104b5f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b62:	85 c0                	test   %eax,%eax
  104b64:	78 1e                	js     104b84 <create+0x174>
  104b66:	8b 42 04             	mov    0x4(%edx),%eax
  104b69:	c7 44 24 04 5c 68 10 	movl   $0x10685c,0x4(%esp)
  104b70:	00 
  104b71:	89 1c 24             	mov    %ebx,(%esp)
  104b74:	89 44 24 08          	mov    %eax,0x8(%esp)
  104b78:	e8 73 cf ff ff       	call   101af0 <dirlink>
  104b7d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b80:	85 c0                	test   %eax,%eax
  104b82:	79 a1                	jns    104b25 <create+0x115>
      panic("create dots");
  104b84:	c7 04 24 5f 68 10 00 	movl   $0x10685f,(%esp)
  104b8b:	e8 50 bd ff ff       	call   1008e0 <panic>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
      iunlockput(ip);
  104b90:	89 1c 24             	mov    %ebx,(%esp)
  104b93:	31 db                	xor    %ebx,%ebx
  104b95:	e8 96 d0 ff ff       	call   101c30 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104b9a:	83 c4 4c             	add    $0x4c,%esp
  104b9d:	89 d8                	mov    %ebx,%eax
  104b9f:	5b                   	pop    %ebx
  104ba0:	5e                   	pop    %esi
  104ba1:	5f                   	pop    %edi
  104ba2:	5d                   	pop    %ebp
  104ba3:	c3                   	ret    
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104ba4:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104baa:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  104bad:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  104baf:	e8 7c d0 ff ff       	call   101c30 <iunlockput>
    iunlockput(dp);
  104bb4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104bb7:	89 14 24             	mov    %edx,(%esp)
  104bba:	e8 71 d0 ff ff       	call   101c30 <iunlockput>
    return 0;
  104bbf:	e9 e6 fe ff ff       	jmp    104aaa <create+0x9a>
  104bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104bd0 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104bd0:	55                   	push   %ebp
  104bd1:	89 e5                	mov    %esp,%ebp
  104bd3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104bd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104be4:	e8 27 f9 ff ff       	call   104510 <argstr>
  104be9:	85 c0                	test   %eax,%eax
  104beb:	79 0b                	jns    104bf8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  104bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104bf2:	c9                   	leave  
  104bf3:	c3                   	ret    
  104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104bf8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104bff:	00 
  104c00:	31 d2                	xor    %edx,%edx
  104c02:	b9 01 00 00 00       	mov    $0x1,%ecx
  104c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c11:	e8 fa fd ff ff       	call   104a10 <create>
  104c16:	85 c0                	test   %eax,%eax
  104c18:	74 d3                	je     104bed <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104c1a:	89 04 24             	mov    %eax,(%esp)
  104c1d:	e8 0e d0 ff ff       	call   101c30 <iunlockput>
  104c22:	31 c0                	xor    %eax,%eax
  return 0;
}
  104c24:	c9                   	leave  
  104c25:	c3                   	ret    
  104c26:	8d 76 00             	lea    0x0(%esi),%esi
  104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104c30 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  104c30:	55                   	push   %ebp
  104c31:	89 e5                	mov    %esp,%ebp
  104c33:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c44:	e8 c7 f8 ff ff       	call   104510 <argstr>
  104c49:	85 c0                	test   %eax,%eax
  104c4b:	79 0b                	jns    104c58 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  104c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c52:	c9                   	leave  
  104c53:	c3                   	ret    
  104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  104c58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c66:	e8 55 f8 ff ff       	call   1044c0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104c6b:	85 c0                	test   %eax,%eax
  104c6d:	78 de                	js     104c4d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  104c6f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c76:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104c7d:	e8 3e f8 ff ff       	call   1044c0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104c82:	85 c0                	test   %eax,%eax
  104c84:	78 c7                	js     104c4d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
  104c86:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  104c8a:	31 d2                	xor    %edx,%edx
  104c8c:	b9 03 00 00 00       	mov    $0x3,%ecx
  104c91:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c95:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
  104c99:	89 04 24             	mov    %eax,(%esp)
  104c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c9f:	e8 6c fd ff ff       	call   104a10 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104ca4:	85 c0                	test   %eax,%eax
  104ca6:	74 a5                	je     104c4d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104ca8:	89 04 24             	mov    %eax,(%esp)
  104cab:	e8 80 cf ff ff       	call   101c30 <iunlockput>
  104cb0:	31 c0                	xor    %eax,%eax
  return 0;
}
  104cb2:	c9                   	leave  
  104cb3:	c3                   	ret    
  104cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104cc0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104cc0:	55                   	push   %ebp
  104cc1:	89 e5                	mov    %esp,%ebp
  104cc3:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104cc9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104ccc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104cda:	e8 31 f8 ff ff       	call   104510 <argstr>
  104cdf:	85 c0                	test   %eax,%eax
  104ce1:	79 15                	jns    104cf8 <sys_open+0x38>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  104ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ce8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104ceb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104cee:	89 ec                	mov    %ebp,%esp
  104cf0:	5d                   	pop    %ebp
  104cf1:	c3                   	ret    
  104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104cf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d06:	e8 b5 f7 ff ff       	call   1044c0 <argint>
  104d0b:	85 c0                	test   %eax,%eax
  104d0d:	78 d4                	js     104ce3 <sys_open+0x23>
    return -1;

  if(omode & O_CREATE){
  104d0f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  104d13:	74 7b                	je     104d90 <sys_open+0xd0>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  104d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d18:	b9 02 00 00 00       	mov    $0x2,%ecx
  104d1d:	ba 01 00 00 00       	mov    $0x1,%edx
  104d22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d29:	00 
  104d2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d31:	e8 da fc ff ff       	call   104a10 <create>
  104d36:	85 c0                	test   %eax,%eax
  104d38:	89 c6                	mov    %eax,%esi
  104d3a:	74 a7                	je     104ce3 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104d3c:	e8 1f c2 ff ff       	call   100f60 <filealloc>
  104d41:	85 c0                	test   %eax,%eax
  104d43:	89 c3                	mov    %eax,%ebx
  104d45:	74 73                	je     104dba <sys_open+0xfa>
  104d47:	e8 44 f9 ff ff       	call   104690 <fdalloc>
  104d4c:	85 c0                	test   %eax,%eax
  104d4e:	66 90                	xchg   %ax,%ax
  104d50:	78 7d                	js     104dcf <sys_open+0x10f>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d55:	89 34 24             	mov    %esi,(%esp)
  104d58:	e8 83 ce ff ff       	call   101be0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  104d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  104d60:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  f->ip = ip;
  104d66:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
  104d69:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
  104d70:	89 d1                	mov    %edx,%ecx
  104d72:	83 f1 01             	xor    $0x1,%ecx
  104d75:	83 e1 01             	and    $0x1,%ecx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104d78:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  104d7b:	88 4b 08             	mov    %cl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104d7e:	0f 95 43 09          	setne  0x9(%ebx)

  return fd;
  104d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d85:	e9 5e ff ff ff       	jmp    104ce8 <sys_open+0x28>
  104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d93:	89 04 24             	mov    %eax,(%esp)
  104d96:	e8 75 d1 ff ff       	call   101f10 <namei>
  104d9b:	85 c0                	test   %eax,%eax
  104d9d:	89 c6                	mov    %eax,%esi
  104d9f:	0f 84 3e ff ff ff    	je     104ce3 <sys_open+0x23>
      return -1;
    ilock(ip);
  104da5:	89 04 24             	mov    %eax,(%esp)
  104da8:	e8 a3 ce ff ff       	call   101c50 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  104dad:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104db2:	75 88                	jne    104d3c <sys_open+0x7c>
  104db4:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  104db8:	74 82                	je     104d3c <sys_open+0x7c>
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
  104dba:	89 34 24             	mov    %esi,(%esp)
  104dbd:	8d 76 00             	lea    0x0(%esi),%esi
  104dc0:	e8 6b ce ff ff       	call   101c30 <iunlockput>
  104dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104dca:	e9 19 ff ff ff       	jmp    104ce8 <sys_open+0x28>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104dcf:	89 1c 24             	mov    %ebx,(%esp)
  104dd2:	e8 19 c2 ff ff       	call   100ff0 <fileclose>
  104dd7:	eb e1                	jmp    104dba <sys_open+0xfa>
  104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104de0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104de0:	55                   	push   %ebp
  104de1:	89 e5                	mov    %esp,%ebp
  104de3:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104de6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104de9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104dec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104def:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104df2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104df6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104dfd:	e8 0e f7 ff ff       	call   104510 <argstr>
  104e02:	85 c0                	test   %eax,%eax
  104e04:	79 12                	jns    104e18 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104e0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104e11:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104e14:	89 ec                	mov    %ebp,%esp
  104e16:	5d                   	pop    %ebp
  104e17:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e1b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  104e1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104e22:	89 04 24             	mov    %eax,(%esp)
  104e25:	e8 c6 d0 ff ff       	call   101ef0 <nameiparent>
  104e2a:	85 c0                	test   %eax,%eax
  104e2c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104e2f:	74 d5                	je     104e06 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104e31:	89 04 24             	mov    %eax,(%esp)
  104e34:	e8 17 ce ff ff       	call   101c50 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104e39:	c7 44 24 04 5d 68 10 	movl   $0x10685d,0x4(%esp)
  104e40:	00 
  104e41:	89 1c 24             	mov    %ebx,(%esp)
  104e44:	e8 97 c8 ff ff       	call   1016e0 <namecmp>
  104e49:	85 c0                	test   %eax,%eax
  104e4b:	0f 84 a4 00 00 00    	je     104ef5 <sys_unlink+0x115>
  104e51:	c7 44 24 04 5c 68 10 	movl   $0x10685c,0x4(%esp)
  104e58:	00 
  104e59:	89 1c 24             	mov    %ebx,(%esp)
  104e5c:	e8 7f c8 ff ff       	call   1016e0 <namecmp>
  104e61:	85 c0                	test   %eax,%eax
  104e63:	0f 84 8c 00 00 00    	je     104ef5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104e69:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104e6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e70:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104e73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104e77:	89 04 24             	mov    %eax,(%esp)
  104e7a:	e8 91 c8 ff ff       	call   101710 <dirlookup>
  104e7f:	85 c0                	test   %eax,%eax
  104e81:	89 c6                	mov    %eax,%esi
  104e83:	74 70                	je     104ef5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104e85:	89 04 24             	mov    %eax,(%esp)
  104e88:	e8 c3 cd ff ff       	call   101c50 <ilock>

  if(ip->nlink < 1)
  104e8d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104e92:	0f 8e e9 00 00 00    	jle    104f81 <sys_unlink+0x1a1>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104e98:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104e9d:	75 71                	jne    104f10 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104e9f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104ea3:	76 6b                	jbe    104f10 <sys_unlink+0x130>
  104ea5:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  104ea8:	bb 20 00 00 00       	mov    $0x20,%ebx
  104ead:	8d 76 00             	lea    0x0(%esi),%esi
  104eb0:	eb 0e                	jmp    104ec0 <sys_unlink+0xe0>
  104eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104eb8:	83 c3 10             	add    $0x10,%ebx
  104ebb:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104ebe:	73 50                	jae    104f10 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104ec0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104ec7:	00 
  104ec8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104ecc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104ed0:	89 34 24             	mov    %esi,(%esp)
  104ed3:	e8 38 c5 ff ff       	call   101410 <readi>
  104ed8:	83 f8 10             	cmp    $0x10,%eax
  104edb:	0f 85 94 00 00 00    	jne    104f75 <sys_unlink+0x195>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104ee1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  104ee6:	74 d0                	je     104eb8 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104ee8:	89 34 24             	mov    %esi,(%esp)
  104eeb:	90                   	nop
  104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104ef0:	e8 3b cd ff ff       	call   101c30 <iunlockput>
    iunlockput(dp);
  104ef5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104ef8:	89 04 24             	mov    %eax,(%esp)
  104efb:	e8 30 cd ff ff       	call   101c30 <iunlockput>
  104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104f05:	e9 01 ff ff ff       	jmp    104e0b <sys_unlink+0x2b>
  104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  104f10:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  104f13:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104f1a:	00 
  104f1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f22:	00 
  104f23:	89 1c 24             	mov    %ebx,(%esp)
  104f26:	e8 c5 f2 ff ff       	call   1041f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104f35:	00 
  104f36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104f3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f3e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104f41:	89 04 24             	mov    %eax,(%esp)
  104f44:	e8 67 c6 ff ff       	call   1015b0 <writei>
  104f49:	83 f8 10             	cmp    $0x10,%eax
  104f4c:	75 3f                	jne    104f8d <sys_unlink+0x1ad>
    panic("unlink: writei");
  iunlockput(dp);
  104f4e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104f51:	89 04 24             	mov    %eax,(%esp)
  104f54:	e8 d7 cc ff ff       	call   101c30 <iunlockput>

  ip->nlink--;
  104f59:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104f5e:	89 34 24             	mov    %esi,(%esp)
  104f61:	e8 ba c5 ff ff       	call   101520 <iupdate>
  iunlockput(ip);
  104f66:	89 34 24             	mov    %esi,(%esp)
  104f69:	e8 c2 cc ff ff       	call   101c30 <iunlockput>
  104f6e:	31 c0                	xor    %eax,%eax
  return 0;
  104f70:	e9 96 fe ff ff       	jmp    104e0b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104f75:	c7 04 24 7d 68 10 00 	movl   $0x10687d,(%esp)
  104f7c:	e8 5f b9 ff ff       	call   1008e0 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104f81:	c7 04 24 6b 68 10 00 	movl   $0x10686b,(%esp)
  104f88:	e8 53 b9 ff ff       	call   1008e0 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104f8d:	c7 04 24 8f 68 10 00 	movl   $0x10688f,(%esp)
  104f94:	e8 47 b9 ff ff       	call   1008e0 <panic>
  104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104fa0 <T.61>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104fa0:	55                   	push   %ebp
  104fa1:	89 e5                	mov    %esp,%ebp
  104fa3:	83 ec 28             	sub    $0x28,%esp
  104fa6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104fa9:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104fae:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104fb1:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fbe:	e8 fd f4 ff ff       	call   1044c0 <argint>
  104fc3:	85 c0                	test   %eax,%eax
  104fc5:	79 11                	jns    104fd8 <T.61+0x38>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104fc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104fcc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104fcf:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104fd2:	89 ec                	mov    %ebp,%esp
  104fd4:	5d                   	pop    %ebp
  104fd5:	c3                   	ret    
  104fd6:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  104fd8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104fdc:	77 e9                	ja     104fc7 <T.61+0x27>
  104fde:	e8 bd e3 ff ff       	call   1033a0 <curproc>
  104fe3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  104fe6:	8b 54 88 20          	mov    0x20(%eax,%ecx,4),%edx
  104fea:	85 d2                	test   %edx,%edx
  104fec:	74 d9                	je     104fc7 <T.61+0x27>
    return -1;
  if(pfd)
  104fee:	85 db                	test   %ebx,%ebx
  104ff0:	74 02                	je     104ff4 <T.61+0x54>
    *pfd = fd;
  104ff2:	89 0b                	mov    %ecx,(%ebx)
  if(pf)
  104ff4:	31 c0                	xor    %eax,%eax
  104ff6:	85 f6                	test   %esi,%esi
  104ff8:	74 d2                	je     104fcc <T.61+0x2c>
    *pf = f;
  104ffa:	89 16                	mov    %edx,(%esi)
  104ffc:	eb ce                	jmp    104fcc <T.61+0x2c>
  104ffe:	66 90                	xchg   %ax,%ax

00105000 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105000:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105001:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105003:	89 e5                	mov    %esp,%ebp
  105005:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105008:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10500b:	e8 90 ff ff ff       	call   104fa0 <T.61>
  105010:	85 c0                	test   %eax,%eax
  105012:	79 0c                	jns    105020 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  105014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105019:	c9                   	leave  
  10501a:	c3                   	ret    
  10501b:	90                   	nop
  10501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105020:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105023:	89 44 24 04          	mov    %eax,0x4(%esp)
  105027:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10502e:	e8 8d f4 ff ff       	call   1044c0 <argint>
  105033:	85 c0                	test   %eax,%eax
  105035:	78 dd                	js     105014 <sys_read+0x14>
  105037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10503a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105041:	89 44 24 08          	mov    %eax,0x8(%esp)
  105045:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105048:	89 44 24 04          	mov    %eax,0x4(%esp)
  10504c:	e8 3f f5 ff ff       	call   104590 <argptr>
  105051:	85 c0                	test   %eax,%eax
  105053:	78 bf                	js     105014 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  105055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105058:	89 44 24 08          	mov    %eax,0x8(%esp)
  10505c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10505f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105066:	89 04 24             	mov    %eax,(%esp)
  105069:	e8 a2 bd ff ff       	call   100e10 <fileread>
}
  10506e:	c9                   	leave  
  10506f:	c3                   	ret    

00105070 <sys_write>:

int
sys_write(void)
{
  105070:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105071:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105073:	89 e5                	mov    %esp,%ebp
  105075:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105078:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10507b:	e8 20 ff ff ff       	call   104fa0 <T.61>
  105080:	85 c0                	test   %eax,%eax
  105082:	79 0c                	jns    105090 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  105084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105089:	c9                   	leave  
  10508a:	c3                   	ret    
  10508b:	90                   	nop
  10508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105090:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105093:	89 44 24 04          	mov    %eax,0x4(%esp)
  105097:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10509e:	e8 1d f4 ff ff       	call   1044c0 <argint>
  1050a3:	85 c0                	test   %eax,%eax
  1050a5:	78 dd                	js     105084 <sys_write+0x14>
  1050a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1050b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050bc:	e8 cf f4 ff ff       	call   104590 <argptr>
  1050c1:	85 c0                	test   %eax,%eax
  1050c3:	78 bf                	js     105084 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  1050c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050d6:	89 04 24             	mov    %eax,(%esp)
  1050d9:	e8 82 bc ff ff       	call   100d60 <filewrite>
}
  1050de:	c9                   	leave  
  1050df:	c3                   	ret    

001050e0 <sys_dup>:

int
sys_dup(void)
{
  1050e0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1050e1:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1050e3:	89 e5                	mov    %esp,%ebp
  1050e5:	53                   	push   %ebx
  1050e6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1050e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  1050ec:	e8 af fe ff ff       	call   104fa0 <T.61>
  1050f1:	85 c0                	test   %eax,%eax
  1050f3:	79 13                	jns    105108 <sys_dup+0x28>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1050f5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1050fa:	89 d8                	mov    %ebx,%eax
  1050fc:	83 c4 24             	add    $0x24,%esp
  1050ff:	5b                   	pop    %ebx
  105100:	5d                   	pop    %ebp
  105101:	c3                   	ret    
  105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  105108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10510b:	e8 80 f5 ff ff       	call   104690 <fdalloc>
  105110:	85 c0                	test   %eax,%eax
  105112:	89 c3                	mov    %eax,%ebx
  105114:	78 df                	js     1050f5 <sys_dup+0x15>
    return -1;
  filedup(f);
  105116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105119:	89 04 24             	mov    %eax,(%esp)
  10511c:	e8 ef bd ff ff       	call   100f10 <filedup>
  return fd;
  105121:	eb d7                	jmp    1050fa <sys_dup+0x1a>
  105123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105130 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105130:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105131:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105133:	89 e5                	mov    %esp,%ebp
  105135:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105138:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10513b:	e8 60 fe ff ff       	call   104fa0 <T.61>
  105140:	85 c0                	test   %eax,%eax
  105142:	79 0c                	jns    105150 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  105144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105149:	c9                   	leave  
  10514a:	c3                   	ret    
  10514b:	90                   	nop
  10514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105150:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105153:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10515a:	00 
  10515b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10515f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105166:	e8 25 f4 ff ff       	call   104590 <argptr>
  10516b:	85 c0                	test   %eax,%eax
  10516d:	78 d5                	js     105144 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10516f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105172:	89 44 24 04          	mov    %eax,0x4(%esp)
  105176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105179:	89 04 24             	mov    %eax,(%esp)
  10517c:	e8 3f bd ff ff       	call   100ec0 <filestat>
}
  105181:	c9                   	leave  
  105182:	c3                   	ret    
  105183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105190 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105190:	55                   	push   %ebp
  105191:	89 e5                	mov    %esp,%ebp
  105193:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105196:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105199:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10519c:	e8 ff fd ff ff       	call   104fa0 <T.61>
  1051a1:	89 c2                	mov    %eax,%edx
  1051a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1051a8:	85 d2                	test   %edx,%edx
  1051aa:	78 1d                	js     1051c9 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  1051ac:	e8 ef e1 ff ff       	call   1033a0 <curproc>
  1051b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1051b4:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  1051bb:	00 
  fileclose(f);
  1051bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051bf:	89 04 24             	mov    %eax,(%esp)
  1051c2:	e8 29 be ff ff       	call   100ff0 <fileclose>
  1051c7:	31 c0                	xor    %eax,%eax
  return 0;
}
  1051c9:	c9                   	leave  
  1051ca:	c3                   	ret    
  1051cb:	90                   	nop
  1051cc:	90                   	nop
  1051cd:	90                   	nop
  1051ce:	90                   	nop
  1051cf:	90                   	nop

001051d0 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  1051d0:	55                   	push   %ebp
return ticks;
}
  1051d1:	a1 00 ea 10 00       	mov    0x10ea00,%eax
  return 0;
}

int
sys_tick(void)
{
  1051d6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1051d8:	5d                   	pop    %ebp
  1051d9:	c3                   	ret    
  1051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001051e0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1051e0:	55                   	push   %ebp
  1051e1:	89 e5                	mov    %esp,%ebp
  1051e3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1051e6:	e8 b5 e1 ff ff       	call   1033a0 <curproc>
  1051eb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1051ee:	c9                   	leave  
  1051ef:	c3                   	ret    

001051f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1051f0:	55                   	push   %ebp
  1051f1:	89 e5                	mov    %esp,%ebp
  1051f3:	53                   	push   %ebx
  1051f4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  1051f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1051fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105205:	e8 b6 f2 ff ff       	call   1044c0 <argint>
  10520a:	89 c2                	mov    %eax,%edx
  10520c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105211:	85 d2                	test   %edx,%edx
  105213:	78 58                	js     10526d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105215:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
  10521c:	e8 5f ef ff ff       	call   104180 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105224:	8b 1d 00 ea 10 00    	mov    0x10ea00,%ebx
  while(ticks - ticks0 < n){
  10522a:	85 d2                	test   %edx,%edx
  10522c:	7f 22                	jg     105250 <sys_sleep+0x60>
  10522e:	eb 48                	jmp    105278 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105230:	c7 44 24 04 c0 e1 10 	movl   $0x10e1c0,0x4(%esp)
  105237:	00 
  105238:	c7 04 24 00 ea 10 00 	movl   $0x10ea00,(%esp)
  10523f:	e8 bc e3 ff ff       	call   103600 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105244:	a1 00 ea 10 00       	mov    0x10ea00,%eax
  105249:	29 d8                	sub    %ebx,%eax
  10524b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10524e:	7d 28                	jge    105278 <sys_sleep+0x88>
    if(cp->killed){
  105250:	e8 4b e1 ff ff       	call   1033a0 <curproc>
  105255:	8b 40 1c             	mov    0x1c(%eax),%eax
  105258:	85 c0                	test   %eax,%eax
  10525a:	74 d4                	je     105230 <sys_sleep+0x40>
      release(&tickslock);
  10525c:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
  105263:	e8 d8 ee ff ff       	call   104140 <release>
  105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10526d:	83 c4 24             	add    $0x24,%esp
  105270:	5b                   	pop    %ebx
  105271:	5d                   	pop    %ebp
  105272:	c3                   	ret    
  105273:	90                   	nop
  105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105278:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
  10527f:	e8 bc ee ff ff       	call   104140 <release>
  return 0;
}
  105284:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105287:	31 c0                	xor    %eax,%eax
  return 0;
}
  105289:	5b                   	pop    %ebx
  10528a:	5d                   	pop    %ebp
  10528b:	c3                   	ret    
  10528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105290 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105290:	55                   	push   %ebp
  105291:	89 e5                	mov    %esp,%ebp
  105293:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105299:	89 44 24 04          	mov    %eax,0x4(%esp)
  10529d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052a4:	e8 17 f2 ff ff       	call   1044c0 <argint>
  1052a9:	85 c0                	test   %eax,%eax
  1052ab:	79 0b                	jns    1052b8 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  1052ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1052b2:	c9                   	leave  
  1052b3:	c3                   	ret    
  1052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1052b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052bb:	89 04 24             	mov    %eax,(%esp)
  1052be:	e8 ad e8 ff ff       	call   103b70 <growproc>
  1052c3:	85 c0                	test   %eax,%eax
  1052c5:	78 e6                	js     1052ad <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1052c7:	c9                   	leave  
  1052c8:	c3                   	ret    
  1052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001052d0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1052d0:	55                   	push   %ebp
  1052d1:	89 e5                	mov    %esp,%ebp
  1052d3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1052d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1052d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052e4:	e8 d7 f1 ff ff       	call   1044c0 <argint>
  1052e9:	89 c2                	mov    %eax,%edx
  1052eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1052f0:	85 d2                	test   %edx,%edx
  1052f2:	78 0b                	js     1052ff <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1052f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052f7:	89 04 24             	mov    %eax,(%esp)
  1052fa:	e8 11 df ff ff       	call   103210 <kill>
}
  1052ff:	c9                   	leave  
  105300:	c3                   	ret    
  105301:	eb 0d                	jmp    105310 <sys_wait>
  105303:	90                   	nop
  105304:	90                   	nop
  105305:	90                   	nop
  105306:	90                   	nop
  105307:	90                   	nop
  105308:	90                   	nop
  105309:	90                   	nop
  10530a:	90                   	nop
  10530b:	90                   	nop
  10530c:	90                   	nop
  10530d:	90                   	nop
  10530e:	90                   	nop
  10530f:	90                   	nop

00105310 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  105310:	55                   	push   %ebp
  105311:	89 e5                	mov    %esp,%ebp
  105313:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105316:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105317:	e9 b4 e3 ff ff       	jmp    1036d0 <wait>
  10531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105320 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105320:	55                   	push   %ebp
  105321:	89 e5                	mov    %esp,%ebp
  105323:	83 ec 08             	sub    $0x8,%esp
  exit();
  105326:	e8 75 e1 ff ff       	call   1034a0 <exit>
  return 0;  // not reached
}
  10532b:	31 c0                	xor    %eax,%eax
  10532d:	c9                   	leave  
  10532e:	c3                   	ret    
  10532f:	90                   	nop

00105330 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105330:	55                   	push   %ebp
  105331:	89 e5                	mov    %esp,%ebp
  105333:	53                   	push   %ebx
  105334:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10533a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105345:	e8 76 f1 ff ff       	call   1044c0 <argint>
  10534a:	85 c0                	test   %eax,%eax
  10534c:	79 12                	jns    105360 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10534e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105353:	83 c4 24             	add    $0x24,%esp
  105356:	5b                   	pop    %ebx
  105357:	5d                   	pop    %ebp
  105358:	c3                   	ret    
  105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105360:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105363:	e8 38 e0 ff ff       	call   1033a0 <curproc>
  105368:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10536c:	89 04 24             	mov    %eax,(%esp)
  10536f:	e8 bc e8 ff ff       	call   103c30 <copyproc_tix>
  105374:	85 c0                	test   %eax,%eax
  105376:	89 c2                	mov    %eax,%edx
  105378:	74 d4                	je     10534e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10537a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10537d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  105380:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  105387:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  10538d:	eb c4                	jmp    105353 <sys_fork_tickets+0x23>
  10538f:	90                   	nop

00105390 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105390:	55                   	push   %ebp
  105391:	89 e5                	mov    %esp,%ebp
  105393:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105396:	e8 05 e0 ff ff       	call   1033a0 <curproc>
  10539b:	89 04 24             	mov    %eax,(%esp)
  10539e:	e8 cd e9 ff ff       	call   103d70 <copyproc>
  1053a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1053a8:	85 c0                	test   %eax,%eax
  1053aa:	74 0a                	je     1053b6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1053ac:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1053af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1053b6:	89 d0                	mov    %edx,%eax
  1053b8:	c9                   	leave  
  1053b9:	c3                   	ret    
  1053ba:	90                   	nop
  1053bb:	90                   	nop
  1053bc:	90                   	nop
  1053bd:	90                   	nop
  1053be:	90                   	nop
  1053bf:	90                   	nop

001053c0 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  1053c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1053c1:	ba 43 00 00 00       	mov    $0x43,%edx
  1053c6:	89 e5                	mov    %esp,%ebp
  1053c8:	83 ec 18             	sub    $0x18,%esp
  1053cb:	b8 34 00 00 00       	mov    $0x34,%eax
  1053d0:	ee                   	out    %al,(%dx)
  1053d1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  1053d6:	b2 40                	mov    $0x40,%dl
  1053d8:	ee                   	out    %al,(%dx)
  1053d9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  1053de:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  1053df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053e6:	e8 25 d9 ff ff       	call   102d10 <pic_enable>
}
  1053eb:	c9                   	leave  
  1053ec:	c3                   	ret    
  1053ed:	90                   	nop
  1053ee:	90                   	nop
  1053ef:	90                   	nop

001053f0 <alltraps>:
  1053f0:	1e                   	push   %ds
  1053f1:	06                   	push   %es
  1053f2:	60                   	pusha  
  1053f3:	b8 10 00 00 00       	mov    $0x10,%eax
  1053f8:	8e d8                	mov    %eax,%ds
  1053fa:	8e c0                	mov    %eax,%es
  1053fc:	54                   	push   %esp
  1053fd:	e8 4e 00 00 00       	call   105450 <trap>
  105402:	83 c4 04             	add    $0x4,%esp

00105405 <trapret>:
  105405:	61                   	popa   
  105406:	07                   	pop    %es
  105407:	1f                   	pop    %ds
  105408:	83 c4 08             	add    $0x8,%esp
  10540b:	cf                   	iret   

0010540c <forkret1>:
  10540c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105410:	e9 f0 ff ff ff       	jmp    105405 <trapret>
  105415:	90                   	nop
  105416:	90                   	nop
  105417:	90                   	nop
  105418:	90                   	nop
  105419:	90                   	nop
  10541a:	90                   	nop
  10541b:	90                   	nop
  10541c:	90                   	nop
  10541d:	90                   	nop
  10541e:	90                   	nop
  10541f:	90                   	nop

00105420 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105420:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105421:	b8 00 e2 10 00       	mov    $0x10e200,%eax
  105426:	89 e5                	mov    %esp,%ebp
  105428:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10542b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105431:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105435:	c1 e8 10             	shr    $0x10,%eax
  105438:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10543c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10543f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105442:	c9                   	leave  
  105443:	c3                   	ret    
  105444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10544a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105450 <trap>:

void
trap(struct trapframe *tf)
{
  105450:	55                   	push   %ebp
  105451:	89 e5                	mov    %esp,%ebp
  105453:	83 ec 48             	sub    $0x48,%esp
  105456:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105459:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10545c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10545f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(tf->trapno == T_SYSCALL){
  105462:	8b 43 28             	mov    0x28(%ebx),%eax
  105465:	83 f8 30             	cmp    $0x30,%eax
  105468:	0f 84 8a 01 00 00    	je     1055f8 <trap+0x1a8>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10546e:	83 f8 21             	cmp    $0x21,%eax
  105471:	0f 84 69 01 00 00    	je     1055e0 <trap+0x190>
  105477:	76 47                	jbe    1054c0 <trap+0x70>
  105479:	83 f8 2e             	cmp    $0x2e,%eax
  10547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105480:	0f 84 42 01 00 00    	je     1055c8 <trap+0x178>
  105486:	83 f8 3f             	cmp    $0x3f,%eax
  105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105490:	75 37                	jne    1054c9 <trap+0x79>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105492:	8b 7b 30             	mov    0x30(%ebx),%edi
  105495:	0f b7 73 34          	movzwl 0x34(%ebx),%esi
  105499:	e8 d2 d3 ff ff       	call   102870 <cpu>
  10549e:	c7 04 24 a0 68 10 00 	movl   $0x1068a0,(%esp)
  1054a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1054a9:	89 74 24 08          	mov    %esi,0x8(%esp)
  1054ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054b1:	e8 8a b2 ff ff       	call   100740 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  1054b6:	e8 25 d2 ff ff       	call   1026e0 <lapic_eoi>
    break;
  1054bb:	e9 90 00 00 00       	jmp    105550 <trap+0x100>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1054c0:	83 f8 20             	cmp    $0x20,%eax
  1054c3:	0f 84 e7 00 00 00    	je     1055b0 <trap+0x160>
  1054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  1054d0:	e8 cb de ff ff       	call   1033a0 <curproc>
  1054d5:	85 c0                	test   %eax,%eax
  1054d7:	0f 84 9b 01 00 00    	je     105678 <trap+0x228>
  1054dd:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  1054e1:	0f 84 91 01 00 00    	je     105678 <trap+0x228>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1054e7:	8b 53 30             	mov    0x30(%ebx),%edx
  1054ea:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1054ed:	e8 7e d3 ff ff       	call   102870 <cpu>
  1054f2:	8b 4b 28             	mov    0x28(%ebx),%ecx
  1054f5:	8b 73 2c             	mov    0x2c(%ebx),%esi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1054f8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  1054fb:	89 c7                	mov    %eax,%edi
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
  1054fd:	e8 9e de ff ff       	call   1033a0 <curproc>
  105502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105505:	e8 96 de ff ff       	call   1033a0 <curproc>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  10550a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10550d:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105511:	89 74 24 10          	mov    %esi,0x10(%esp)
  105515:	89 54 24 18          	mov    %edx,0x18(%esp)
  105519:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10551c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105523:	81 c2 88 00 00 00    	add    $0x88,%edx
  105529:	89 54 24 08          	mov    %edx,0x8(%esp)
  10552d:	8b 40 10             	mov    0x10(%eax),%eax
  105530:	c7 04 24 ec 68 10 00 	movl   $0x1068ec,(%esp)
  105537:	89 44 24 04          	mov    %eax,0x4(%esp)
  10553b:	e8 00 b2 ff ff       	call   100740 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105540:	e8 5b de ff ff       	call   1033a0 <curproc>
  105545:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  10554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105550:	e8 4b de ff ff       	call   1033a0 <curproc>
  105555:	85 c0                	test   %eax,%eax
  105557:	74 1c                	je     105575 <trap+0x125>
  105559:	e8 42 de ff ff       	call   1033a0 <curproc>
  10555e:	8b 40 1c             	mov    0x1c(%eax),%eax
  105561:	85 c0                	test   %eax,%eax
  105563:	74 10                	je     105575 <trap+0x125>
  105565:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  105569:	83 e0 03             	and    $0x3,%eax
  10556c:	83 f8 03             	cmp    $0x3,%eax
  10556f:	0f 84 33 01 00 00    	je     1056a8 <trap+0x258>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105575:	e8 26 de ff ff       	call   1033a0 <curproc>
  10557a:	85 c0                	test   %eax,%eax
  10557c:	74 0d                	je     10558b <trap+0x13b>
  10557e:	66 90                	xchg   %ax,%ax
  105580:	e8 1b de ff ff       	call   1033a0 <curproc>
  105585:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105589:	74 0d                	je     105598 <trap+0x148>
    yield();
}
  10558b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10558e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105591:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105594:	89 ec                	mov    %ebp,%esp
  105596:	5d                   	pop    %ebp
  105597:	c3                   	ret    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105598:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
  10559c:	75 ed                	jne    10558b <trap+0x13b>
    yield();
}
  10559e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1055a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1055a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1055a7:	89 ec                	mov    %ebp,%esp
  1055a9:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  1055aa:	e9 31 e2 ff ff       	jmp    1037e0 <yield>
  1055af:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  1055b0:	e8 bb d2 ff ff       	call   102870 <cpu>
  1055b5:	85 c0                	test   %eax,%eax
  1055b7:	0f 84 8b 00 00 00    	je     105648 <trap+0x1f8>
  1055bd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
  1055c0:	e8 1b d1 ff ff       	call   1026e0 <lapic_eoi>
    break;
  1055c5:	eb 89                	jmp    105550 <trap+0x100>
  1055c7:	90                   	nop
  1055c8:	90                   	nop
  1055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  1055d0:	e8 fb ca ff ff       	call   1020d0 <ide_intr>
  1055d5:	8d 76 00             	lea    0x0(%esi),%esi
  1055d8:	eb e3                	jmp    1055bd <trap+0x16d>
  1055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  1055e0:	e8 eb cf ff ff       	call   1025d0 <kbd_intr>
  1055e5:	8d 76 00             	lea    0x0(%esi),%esi
    lapic_eoi();
  1055e8:	e8 f3 d0 ff ff       	call   1026e0 <lapic_eoi>
  1055ed:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  1055f0:	e9 5b ff ff ff       	jmp    105550 <trap+0x100>
  1055f5:	8d 76 00             	lea    0x0(%esi),%esi
  1055f8:	90                   	nop
  1055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105600:	e8 9b dd ff ff       	call   1033a0 <curproc>
  105605:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105608:	85 c9                	test   %ecx,%ecx
  10560a:	0f 85 a8 00 00 00    	jne    1056b8 <trap+0x268>
      exit();
    cp->tf = tf;
  105610:	e8 8b dd ff ff       	call   1033a0 <curproc>
  105615:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    syscall();
  10561b:	e8 d0 ef ff ff       	call   1045f0 <syscall>
    if(cp->killed)
  105620:	e8 7b dd ff ff       	call   1033a0 <curproc>
  105625:	8b 50 1c             	mov    0x1c(%eax),%edx
  105628:	85 d2                	test   %edx,%edx
  10562a:	0f 84 5b ff ff ff    	je     10558b <trap+0x13b>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105630:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105633:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105636:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105639:	89 ec                	mov    %ebp,%esp
  10563b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  10563c:	e9 5f de ff ff       	jmp    1034a0 <exit>
  105641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
      acquire(&tickslock);
  105648:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
  10564f:	e8 2c eb ff ff       	call   104180 <acquire>
      ticks++;
  105654:	83 05 00 ea 10 00 01 	addl   $0x1,0x10ea00
      wakeup(&ticks);
  10565b:	c7 04 24 00 ea 10 00 	movl   $0x10ea00,(%esp)
  105662:	e8 39 dc ff ff       	call   1032a0 <wakeup>
      release(&tickslock);
  105667:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
  10566e:	e8 cd ea ff ff       	call   104140 <release>
  105673:	e9 45 ff ff ff       	jmp    1055bd <trap+0x16d>
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105678:	8b 73 30             	mov    0x30(%ebx),%esi
  10567b:	e8 f0 d1 ff ff       	call   102870 <cpu>
  105680:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105684:	89 44 24 08          	mov    %eax,0x8(%esp)
  105688:	8b 43 28             	mov    0x28(%ebx),%eax
  10568b:	c7 04 24 c4 68 10 00 	movl   $0x1068c4,(%esp)
  105692:	89 44 24 04          	mov    %eax,0x4(%esp)
  105696:	e8 a5 b0 ff ff       	call   100740 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  10569b:	c7 04 24 28 69 10 00 	movl   $0x106928,(%esp)
  1056a2:	e8 39 b2 ff ff       	call   1008e0 <panic>
  1056a7:	90                   	nop

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  1056a8:	e8 f3 dd ff ff       	call   1034a0 <exit>
  1056ad:	e9 c3 fe ff ff       	jmp    105575 <trap+0x125>
  1056b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056b8:	90                   	nop
  1056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  1056c0:	e8 db dd ff ff       	call   1034a0 <exit>
  1056c5:	8d 76 00             	lea    0x0(%esi),%esi
  1056c8:	e9 43 ff ff ff       	jmp    105610 <trap+0x1c0>
  1056cd:	8d 76 00             	lea    0x0(%esi),%esi

001056d0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  1056d0:	55                   	push   %ebp
  1056d1:	31 c0                	xor    %eax,%eax
  1056d3:	89 e5                	mov    %esp,%ebp
  1056d5:	ba 00 e2 10 00       	mov    $0x10e200,%edx
  1056da:	83 ec 18             	sub    $0x18,%esp
  1056dd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  1056e0:	8b 0c 85 48 7c 10 00 	mov    0x107c48(,%eax,4),%ecx
  1056e7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  1056ee:	66 89 0c c5 00 e2 10 	mov    %cx,0x10e200(,%eax,8)
  1056f5:	00 
  1056f6:	c1 e9 10             	shr    $0x10,%ecx
  1056f9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1056fe:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105703:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105708:	83 c0 01             	add    $0x1,%eax
  10570b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105710:	75 ce                	jne    1056e0 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105712:	a1 08 7d 10 00       	mov    0x107d08,%eax
  
  initlock(&tickslock, "time");
  105717:	c7 44 24 04 2d 69 10 	movl   $0x10692d,0x4(%esp)
  10571e:	00 
  10571f:	c7 04 24 c0 e1 10 00 	movl   $0x10e1c0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105726:	66 c7 05 82 e3 10 00 	movw   $0x8,0x10e382
  10572d:	08 00 
  10572f:	66 a3 80 e3 10 00    	mov    %ax,0x10e380
  105735:	c1 e8 10             	shr    $0x10,%eax
  105738:	c6 05 84 e3 10 00 00 	movb   $0x0,0x10e384
  10573f:	c6 05 85 e3 10 00 ef 	movb   $0xef,0x10e385
  105746:	66 a3 86 e3 10 00    	mov    %ax,0x10e386
  
  initlock(&tickslock, "time");
  10574c:	e8 6f e8 ff ff       	call   103fc0 <initlock>
}
  105751:	c9                   	leave  
  105752:	c3                   	ret    
  105753:	90                   	nop

00105754 <vector0>:
  105754:	6a 00                	push   $0x0
  105756:	6a 00                	push   $0x0
  105758:	e9 93 fc ff ff       	jmp    1053f0 <alltraps>

0010575d <vector1>:
  10575d:	6a 00                	push   $0x0
  10575f:	6a 01                	push   $0x1
  105761:	e9 8a fc ff ff       	jmp    1053f0 <alltraps>

00105766 <vector2>:
  105766:	6a 00                	push   $0x0
  105768:	6a 02                	push   $0x2
  10576a:	e9 81 fc ff ff       	jmp    1053f0 <alltraps>

0010576f <vector3>:
  10576f:	6a 00                	push   $0x0
  105771:	6a 03                	push   $0x3
  105773:	e9 78 fc ff ff       	jmp    1053f0 <alltraps>

00105778 <vector4>:
  105778:	6a 00                	push   $0x0
  10577a:	6a 04                	push   $0x4
  10577c:	e9 6f fc ff ff       	jmp    1053f0 <alltraps>

00105781 <vector5>:
  105781:	6a 00                	push   $0x0
  105783:	6a 05                	push   $0x5
  105785:	e9 66 fc ff ff       	jmp    1053f0 <alltraps>

0010578a <vector6>:
  10578a:	6a 00                	push   $0x0
  10578c:	6a 06                	push   $0x6
  10578e:	e9 5d fc ff ff       	jmp    1053f0 <alltraps>

00105793 <vector7>:
  105793:	6a 00                	push   $0x0
  105795:	6a 07                	push   $0x7
  105797:	e9 54 fc ff ff       	jmp    1053f0 <alltraps>

0010579c <vector8>:
  10579c:	6a 08                	push   $0x8
  10579e:	e9 4d fc ff ff       	jmp    1053f0 <alltraps>

001057a3 <vector9>:
  1057a3:	6a 09                	push   $0x9
  1057a5:	e9 46 fc ff ff       	jmp    1053f0 <alltraps>

001057aa <vector10>:
  1057aa:	6a 0a                	push   $0xa
  1057ac:	e9 3f fc ff ff       	jmp    1053f0 <alltraps>

001057b1 <vector11>:
  1057b1:	6a 0b                	push   $0xb
  1057b3:	e9 38 fc ff ff       	jmp    1053f0 <alltraps>

001057b8 <vector12>:
  1057b8:	6a 0c                	push   $0xc
  1057ba:	e9 31 fc ff ff       	jmp    1053f0 <alltraps>

001057bf <vector13>:
  1057bf:	6a 0d                	push   $0xd
  1057c1:	e9 2a fc ff ff       	jmp    1053f0 <alltraps>

001057c6 <vector14>:
  1057c6:	6a 0e                	push   $0xe
  1057c8:	e9 23 fc ff ff       	jmp    1053f0 <alltraps>

001057cd <vector15>:
  1057cd:	6a 00                	push   $0x0
  1057cf:	6a 0f                	push   $0xf
  1057d1:	e9 1a fc ff ff       	jmp    1053f0 <alltraps>

001057d6 <vector16>:
  1057d6:	6a 00                	push   $0x0
  1057d8:	6a 10                	push   $0x10
  1057da:	e9 11 fc ff ff       	jmp    1053f0 <alltraps>

001057df <vector17>:
  1057df:	6a 11                	push   $0x11
  1057e1:	e9 0a fc ff ff       	jmp    1053f0 <alltraps>

001057e6 <vector18>:
  1057e6:	6a 00                	push   $0x0
  1057e8:	6a 12                	push   $0x12
  1057ea:	e9 01 fc ff ff       	jmp    1053f0 <alltraps>

001057ef <vector19>:
  1057ef:	6a 00                	push   $0x0
  1057f1:	6a 13                	push   $0x13
  1057f3:	e9 f8 fb ff ff       	jmp    1053f0 <alltraps>

001057f8 <vector20>:
  1057f8:	6a 00                	push   $0x0
  1057fa:	6a 14                	push   $0x14
  1057fc:	e9 ef fb ff ff       	jmp    1053f0 <alltraps>

00105801 <vector21>:
  105801:	6a 00                	push   $0x0
  105803:	6a 15                	push   $0x15
  105805:	e9 e6 fb ff ff       	jmp    1053f0 <alltraps>

0010580a <vector22>:
  10580a:	6a 00                	push   $0x0
  10580c:	6a 16                	push   $0x16
  10580e:	e9 dd fb ff ff       	jmp    1053f0 <alltraps>

00105813 <vector23>:
  105813:	6a 00                	push   $0x0
  105815:	6a 17                	push   $0x17
  105817:	e9 d4 fb ff ff       	jmp    1053f0 <alltraps>

0010581c <vector24>:
  10581c:	6a 00                	push   $0x0
  10581e:	6a 18                	push   $0x18
  105820:	e9 cb fb ff ff       	jmp    1053f0 <alltraps>

00105825 <vector25>:
  105825:	6a 00                	push   $0x0
  105827:	6a 19                	push   $0x19
  105829:	e9 c2 fb ff ff       	jmp    1053f0 <alltraps>

0010582e <vector26>:
  10582e:	6a 00                	push   $0x0
  105830:	6a 1a                	push   $0x1a
  105832:	e9 b9 fb ff ff       	jmp    1053f0 <alltraps>

00105837 <vector27>:
  105837:	6a 00                	push   $0x0
  105839:	6a 1b                	push   $0x1b
  10583b:	e9 b0 fb ff ff       	jmp    1053f0 <alltraps>

00105840 <vector28>:
  105840:	6a 00                	push   $0x0
  105842:	6a 1c                	push   $0x1c
  105844:	e9 a7 fb ff ff       	jmp    1053f0 <alltraps>

00105849 <vector29>:
  105849:	6a 00                	push   $0x0
  10584b:	6a 1d                	push   $0x1d
  10584d:	e9 9e fb ff ff       	jmp    1053f0 <alltraps>

00105852 <vector30>:
  105852:	6a 00                	push   $0x0
  105854:	6a 1e                	push   $0x1e
  105856:	e9 95 fb ff ff       	jmp    1053f0 <alltraps>

0010585b <vector31>:
  10585b:	6a 00                	push   $0x0
  10585d:	6a 1f                	push   $0x1f
  10585f:	e9 8c fb ff ff       	jmp    1053f0 <alltraps>

00105864 <vector32>:
  105864:	6a 00                	push   $0x0
  105866:	6a 20                	push   $0x20
  105868:	e9 83 fb ff ff       	jmp    1053f0 <alltraps>

0010586d <vector33>:
  10586d:	6a 00                	push   $0x0
  10586f:	6a 21                	push   $0x21
  105871:	e9 7a fb ff ff       	jmp    1053f0 <alltraps>

00105876 <vector34>:
  105876:	6a 00                	push   $0x0
  105878:	6a 22                	push   $0x22
  10587a:	e9 71 fb ff ff       	jmp    1053f0 <alltraps>

0010587f <vector35>:
  10587f:	6a 00                	push   $0x0
  105881:	6a 23                	push   $0x23
  105883:	e9 68 fb ff ff       	jmp    1053f0 <alltraps>

00105888 <vector36>:
  105888:	6a 00                	push   $0x0
  10588a:	6a 24                	push   $0x24
  10588c:	e9 5f fb ff ff       	jmp    1053f0 <alltraps>

00105891 <vector37>:
  105891:	6a 00                	push   $0x0
  105893:	6a 25                	push   $0x25
  105895:	e9 56 fb ff ff       	jmp    1053f0 <alltraps>

0010589a <vector38>:
  10589a:	6a 00                	push   $0x0
  10589c:	6a 26                	push   $0x26
  10589e:	e9 4d fb ff ff       	jmp    1053f0 <alltraps>

001058a3 <vector39>:
  1058a3:	6a 00                	push   $0x0
  1058a5:	6a 27                	push   $0x27
  1058a7:	e9 44 fb ff ff       	jmp    1053f0 <alltraps>

001058ac <vector40>:
  1058ac:	6a 00                	push   $0x0
  1058ae:	6a 28                	push   $0x28
  1058b0:	e9 3b fb ff ff       	jmp    1053f0 <alltraps>

001058b5 <vector41>:
  1058b5:	6a 00                	push   $0x0
  1058b7:	6a 29                	push   $0x29
  1058b9:	e9 32 fb ff ff       	jmp    1053f0 <alltraps>

001058be <vector42>:
  1058be:	6a 00                	push   $0x0
  1058c0:	6a 2a                	push   $0x2a
  1058c2:	e9 29 fb ff ff       	jmp    1053f0 <alltraps>

001058c7 <vector43>:
  1058c7:	6a 00                	push   $0x0
  1058c9:	6a 2b                	push   $0x2b
  1058cb:	e9 20 fb ff ff       	jmp    1053f0 <alltraps>

001058d0 <vector44>:
  1058d0:	6a 00                	push   $0x0
  1058d2:	6a 2c                	push   $0x2c
  1058d4:	e9 17 fb ff ff       	jmp    1053f0 <alltraps>

001058d9 <vector45>:
  1058d9:	6a 00                	push   $0x0
  1058db:	6a 2d                	push   $0x2d
  1058dd:	e9 0e fb ff ff       	jmp    1053f0 <alltraps>

001058e2 <vector46>:
  1058e2:	6a 00                	push   $0x0
  1058e4:	6a 2e                	push   $0x2e
  1058e6:	e9 05 fb ff ff       	jmp    1053f0 <alltraps>

001058eb <vector47>:
  1058eb:	6a 00                	push   $0x0
  1058ed:	6a 2f                	push   $0x2f
  1058ef:	e9 fc fa ff ff       	jmp    1053f0 <alltraps>

001058f4 <vector48>:
  1058f4:	6a 00                	push   $0x0
  1058f6:	6a 30                	push   $0x30
  1058f8:	e9 f3 fa ff ff       	jmp    1053f0 <alltraps>

001058fd <vector49>:
  1058fd:	6a 00                	push   $0x0
  1058ff:	6a 31                	push   $0x31
  105901:	e9 ea fa ff ff       	jmp    1053f0 <alltraps>

00105906 <vector50>:
  105906:	6a 00                	push   $0x0
  105908:	6a 32                	push   $0x32
  10590a:	e9 e1 fa ff ff       	jmp    1053f0 <alltraps>

0010590f <vector51>:
  10590f:	6a 00                	push   $0x0
  105911:	6a 33                	push   $0x33
  105913:	e9 d8 fa ff ff       	jmp    1053f0 <alltraps>

00105918 <vector52>:
  105918:	6a 00                	push   $0x0
  10591a:	6a 34                	push   $0x34
  10591c:	e9 cf fa ff ff       	jmp    1053f0 <alltraps>

00105921 <vector53>:
  105921:	6a 00                	push   $0x0
  105923:	6a 35                	push   $0x35
  105925:	e9 c6 fa ff ff       	jmp    1053f0 <alltraps>

0010592a <vector54>:
  10592a:	6a 00                	push   $0x0
  10592c:	6a 36                	push   $0x36
  10592e:	e9 bd fa ff ff       	jmp    1053f0 <alltraps>

00105933 <vector55>:
  105933:	6a 00                	push   $0x0
  105935:	6a 37                	push   $0x37
  105937:	e9 b4 fa ff ff       	jmp    1053f0 <alltraps>

0010593c <vector56>:
  10593c:	6a 00                	push   $0x0
  10593e:	6a 38                	push   $0x38
  105940:	e9 ab fa ff ff       	jmp    1053f0 <alltraps>

00105945 <vector57>:
  105945:	6a 00                	push   $0x0
  105947:	6a 39                	push   $0x39
  105949:	e9 a2 fa ff ff       	jmp    1053f0 <alltraps>

0010594e <vector58>:
  10594e:	6a 00                	push   $0x0
  105950:	6a 3a                	push   $0x3a
  105952:	e9 99 fa ff ff       	jmp    1053f0 <alltraps>

00105957 <vector59>:
  105957:	6a 00                	push   $0x0
  105959:	6a 3b                	push   $0x3b
  10595b:	e9 90 fa ff ff       	jmp    1053f0 <alltraps>

00105960 <vector60>:
  105960:	6a 00                	push   $0x0
  105962:	6a 3c                	push   $0x3c
  105964:	e9 87 fa ff ff       	jmp    1053f0 <alltraps>

00105969 <vector61>:
  105969:	6a 00                	push   $0x0
  10596b:	6a 3d                	push   $0x3d
  10596d:	e9 7e fa ff ff       	jmp    1053f0 <alltraps>

00105972 <vector62>:
  105972:	6a 00                	push   $0x0
  105974:	6a 3e                	push   $0x3e
  105976:	e9 75 fa ff ff       	jmp    1053f0 <alltraps>

0010597b <vector63>:
  10597b:	6a 00                	push   $0x0
  10597d:	6a 3f                	push   $0x3f
  10597f:	e9 6c fa ff ff       	jmp    1053f0 <alltraps>

00105984 <vector64>:
  105984:	6a 00                	push   $0x0
  105986:	6a 40                	push   $0x40
  105988:	e9 63 fa ff ff       	jmp    1053f0 <alltraps>

0010598d <vector65>:
  10598d:	6a 00                	push   $0x0
  10598f:	6a 41                	push   $0x41
  105991:	e9 5a fa ff ff       	jmp    1053f0 <alltraps>

00105996 <vector66>:
  105996:	6a 00                	push   $0x0
  105998:	6a 42                	push   $0x42
  10599a:	e9 51 fa ff ff       	jmp    1053f0 <alltraps>

0010599f <vector67>:
  10599f:	6a 00                	push   $0x0
  1059a1:	6a 43                	push   $0x43
  1059a3:	e9 48 fa ff ff       	jmp    1053f0 <alltraps>

001059a8 <vector68>:
  1059a8:	6a 00                	push   $0x0
  1059aa:	6a 44                	push   $0x44
  1059ac:	e9 3f fa ff ff       	jmp    1053f0 <alltraps>

001059b1 <vector69>:
  1059b1:	6a 00                	push   $0x0
  1059b3:	6a 45                	push   $0x45
  1059b5:	e9 36 fa ff ff       	jmp    1053f0 <alltraps>

001059ba <vector70>:
  1059ba:	6a 00                	push   $0x0
  1059bc:	6a 46                	push   $0x46
  1059be:	e9 2d fa ff ff       	jmp    1053f0 <alltraps>

001059c3 <vector71>:
  1059c3:	6a 00                	push   $0x0
  1059c5:	6a 47                	push   $0x47
  1059c7:	e9 24 fa ff ff       	jmp    1053f0 <alltraps>

001059cc <vector72>:
  1059cc:	6a 00                	push   $0x0
  1059ce:	6a 48                	push   $0x48
  1059d0:	e9 1b fa ff ff       	jmp    1053f0 <alltraps>

001059d5 <vector73>:
  1059d5:	6a 00                	push   $0x0
  1059d7:	6a 49                	push   $0x49
  1059d9:	e9 12 fa ff ff       	jmp    1053f0 <alltraps>

001059de <vector74>:
  1059de:	6a 00                	push   $0x0
  1059e0:	6a 4a                	push   $0x4a
  1059e2:	e9 09 fa ff ff       	jmp    1053f0 <alltraps>

001059e7 <vector75>:
  1059e7:	6a 00                	push   $0x0
  1059e9:	6a 4b                	push   $0x4b
  1059eb:	e9 00 fa ff ff       	jmp    1053f0 <alltraps>

001059f0 <vector76>:
  1059f0:	6a 00                	push   $0x0
  1059f2:	6a 4c                	push   $0x4c
  1059f4:	e9 f7 f9 ff ff       	jmp    1053f0 <alltraps>

001059f9 <vector77>:
  1059f9:	6a 00                	push   $0x0
  1059fb:	6a 4d                	push   $0x4d
  1059fd:	e9 ee f9 ff ff       	jmp    1053f0 <alltraps>

00105a02 <vector78>:
  105a02:	6a 00                	push   $0x0
  105a04:	6a 4e                	push   $0x4e
  105a06:	e9 e5 f9 ff ff       	jmp    1053f0 <alltraps>

00105a0b <vector79>:
  105a0b:	6a 00                	push   $0x0
  105a0d:	6a 4f                	push   $0x4f
  105a0f:	e9 dc f9 ff ff       	jmp    1053f0 <alltraps>

00105a14 <vector80>:
  105a14:	6a 00                	push   $0x0
  105a16:	6a 50                	push   $0x50
  105a18:	e9 d3 f9 ff ff       	jmp    1053f0 <alltraps>

00105a1d <vector81>:
  105a1d:	6a 00                	push   $0x0
  105a1f:	6a 51                	push   $0x51
  105a21:	e9 ca f9 ff ff       	jmp    1053f0 <alltraps>

00105a26 <vector82>:
  105a26:	6a 00                	push   $0x0
  105a28:	6a 52                	push   $0x52
  105a2a:	e9 c1 f9 ff ff       	jmp    1053f0 <alltraps>

00105a2f <vector83>:
  105a2f:	6a 00                	push   $0x0
  105a31:	6a 53                	push   $0x53
  105a33:	e9 b8 f9 ff ff       	jmp    1053f0 <alltraps>

00105a38 <vector84>:
  105a38:	6a 00                	push   $0x0
  105a3a:	6a 54                	push   $0x54
  105a3c:	e9 af f9 ff ff       	jmp    1053f0 <alltraps>

00105a41 <vector85>:
  105a41:	6a 00                	push   $0x0
  105a43:	6a 55                	push   $0x55
  105a45:	e9 a6 f9 ff ff       	jmp    1053f0 <alltraps>

00105a4a <vector86>:
  105a4a:	6a 00                	push   $0x0
  105a4c:	6a 56                	push   $0x56
  105a4e:	e9 9d f9 ff ff       	jmp    1053f0 <alltraps>

00105a53 <vector87>:
  105a53:	6a 00                	push   $0x0
  105a55:	6a 57                	push   $0x57
  105a57:	e9 94 f9 ff ff       	jmp    1053f0 <alltraps>

00105a5c <vector88>:
  105a5c:	6a 00                	push   $0x0
  105a5e:	6a 58                	push   $0x58
  105a60:	e9 8b f9 ff ff       	jmp    1053f0 <alltraps>

00105a65 <vector89>:
  105a65:	6a 00                	push   $0x0
  105a67:	6a 59                	push   $0x59
  105a69:	e9 82 f9 ff ff       	jmp    1053f0 <alltraps>

00105a6e <vector90>:
  105a6e:	6a 00                	push   $0x0
  105a70:	6a 5a                	push   $0x5a
  105a72:	e9 79 f9 ff ff       	jmp    1053f0 <alltraps>

00105a77 <vector91>:
  105a77:	6a 00                	push   $0x0
  105a79:	6a 5b                	push   $0x5b
  105a7b:	e9 70 f9 ff ff       	jmp    1053f0 <alltraps>

00105a80 <vector92>:
  105a80:	6a 00                	push   $0x0
  105a82:	6a 5c                	push   $0x5c
  105a84:	e9 67 f9 ff ff       	jmp    1053f0 <alltraps>

00105a89 <vector93>:
  105a89:	6a 00                	push   $0x0
  105a8b:	6a 5d                	push   $0x5d
  105a8d:	e9 5e f9 ff ff       	jmp    1053f0 <alltraps>

00105a92 <vector94>:
  105a92:	6a 00                	push   $0x0
  105a94:	6a 5e                	push   $0x5e
  105a96:	e9 55 f9 ff ff       	jmp    1053f0 <alltraps>

00105a9b <vector95>:
  105a9b:	6a 00                	push   $0x0
  105a9d:	6a 5f                	push   $0x5f
  105a9f:	e9 4c f9 ff ff       	jmp    1053f0 <alltraps>

00105aa4 <vector96>:
  105aa4:	6a 00                	push   $0x0
  105aa6:	6a 60                	push   $0x60
  105aa8:	e9 43 f9 ff ff       	jmp    1053f0 <alltraps>

00105aad <vector97>:
  105aad:	6a 00                	push   $0x0
  105aaf:	6a 61                	push   $0x61
  105ab1:	e9 3a f9 ff ff       	jmp    1053f0 <alltraps>

00105ab6 <vector98>:
  105ab6:	6a 00                	push   $0x0
  105ab8:	6a 62                	push   $0x62
  105aba:	e9 31 f9 ff ff       	jmp    1053f0 <alltraps>

00105abf <vector99>:
  105abf:	6a 00                	push   $0x0
  105ac1:	6a 63                	push   $0x63
  105ac3:	e9 28 f9 ff ff       	jmp    1053f0 <alltraps>

00105ac8 <vector100>:
  105ac8:	6a 00                	push   $0x0
  105aca:	6a 64                	push   $0x64
  105acc:	e9 1f f9 ff ff       	jmp    1053f0 <alltraps>

00105ad1 <vector101>:
  105ad1:	6a 00                	push   $0x0
  105ad3:	6a 65                	push   $0x65
  105ad5:	e9 16 f9 ff ff       	jmp    1053f0 <alltraps>

00105ada <vector102>:
  105ada:	6a 00                	push   $0x0
  105adc:	6a 66                	push   $0x66
  105ade:	e9 0d f9 ff ff       	jmp    1053f0 <alltraps>

00105ae3 <vector103>:
  105ae3:	6a 00                	push   $0x0
  105ae5:	6a 67                	push   $0x67
  105ae7:	e9 04 f9 ff ff       	jmp    1053f0 <alltraps>

00105aec <vector104>:
  105aec:	6a 00                	push   $0x0
  105aee:	6a 68                	push   $0x68
  105af0:	e9 fb f8 ff ff       	jmp    1053f0 <alltraps>

00105af5 <vector105>:
  105af5:	6a 00                	push   $0x0
  105af7:	6a 69                	push   $0x69
  105af9:	e9 f2 f8 ff ff       	jmp    1053f0 <alltraps>

00105afe <vector106>:
  105afe:	6a 00                	push   $0x0
  105b00:	6a 6a                	push   $0x6a
  105b02:	e9 e9 f8 ff ff       	jmp    1053f0 <alltraps>

00105b07 <vector107>:
  105b07:	6a 00                	push   $0x0
  105b09:	6a 6b                	push   $0x6b
  105b0b:	e9 e0 f8 ff ff       	jmp    1053f0 <alltraps>

00105b10 <vector108>:
  105b10:	6a 00                	push   $0x0
  105b12:	6a 6c                	push   $0x6c
  105b14:	e9 d7 f8 ff ff       	jmp    1053f0 <alltraps>

00105b19 <vector109>:
  105b19:	6a 00                	push   $0x0
  105b1b:	6a 6d                	push   $0x6d
  105b1d:	e9 ce f8 ff ff       	jmp    1053f0 <alltraps>

00105b22 <vector110>:
  105b22:	6a 00                	push   $0x0
  105b24:	6a 6e                	push   $0x6e
  105b26:	e9 c5 f8 ff ff       	jmp    1053f0 <alltraps>

00105b2b <vector111>:
  105b2b:	6a 00                	push   $0x0
  105b2d:	6a 6f                	push   $0x6f
  105b2f:	e9 bc f8 ff ff       	jmp    1053f0 <alltraps>

00105b34 <vector112>:
  105b34:	6a 00                	push   $0x0
  105b36:	6a 70                	push   $0x70
  105b38:	e9 b3 f8 ff ff       	jmp    1053f0 <alltraps>

00105b3d <vector113>:
  105b3d:	6a 00                	push   $0x0
  105b3f:	6a 71                	push   $0x71
  105b41:	e9 aa f8 ff ff       	jmp    1053f0 <alltraps>

00105b46 <vector114>:
  105b46:	6a 00                	push   $0x0
  105b48:	6a 72                	push   $0x72
  105b4a:	e9 a1 f8 ff ff       	jmp    1053f0 <alltraps>

00105b4f <vector115>:
  105b4f:	6a 00                	push   $0x0
  105b51:	6a 73                	push   $0x73
  105b53:	e9 98 f8 ff ff       	jmp    1053f0 <alltraps>

00105b58 <vector116>:
  105b58:	6a 00                	push   $0x0
  105b5a:	6a 74                	push   $0x74
  105b5c:	e9 8f f8 ff ff       	jmp    1053f0 <alltraps>

00105b61 <vector117>:
  105b61:	6a 00                	push   $0x0
  105b63:	6a 75                	push   $0x75
  105b65:	e9 86 f8 ff ff       	jmp    1053f0 <alltraps>

00105b6a <vector118>:
  105b6a:	6a 00                	push   $0x0
  105b6c:	6a 76                	push   $0x76
  105b6e:	e9 7d f8 ff ff       	jmp    1053f0 <alltraps>

00105b73 <vector119>:
  105b73:	6a 00                	push   $0x0
  105b75:	6a 77                	push   $0x77
  105b77:	e9 74 f8 ff ff       	jmp    1053f0 <alltraps>

00105b7c <vector120>:
  105b7c:	6a 00                	push   $0x0
  105b7e:	6a 78                	push   $0x78
  105b80:	e9 6b f8 ff ff       	jmp    1053f0 <alltraps>

00105b85 <vector121>:
  105b85:	6a 00                	push   $0x0
  105b87:	6a 79                	push   $0x79
  105b89:	e9 62 f8 ff ff       	jmp    1053f0 <alltraps>

00105b8e <vector122>:
  105b8e:	6a 00                	push   $0x0
  105b90:	6a 7a                	push   $0x7a
  105b92:	e9 59 f8 ff ff       	jmp    1053f0 <alltraps>

00105b97 <vector123>:
  105b97:	6a 00                	push   $0x0
  105b99:	6a 7b                	push   $0x7b
  105b9b:	e9 50 f8 ff ff       	jmp    1053f0 <alltraps>

00105ba0 <vector124>:
  105ba0:	6a 00                	push   $0x0
  105ba2:	6a 7c                	push   $0x7c
  105ba4:	e9 47 f8 ff ff       	jmp    1053f0 <alltraps>

00105ba9 <vector125>:
  105ba9:	6a 00                	push   $0x0
  105bab:	6a 7d                	push   $0x7d
  105bad:	e9 3e f8 ff ff       	jmp    1053f0 <alltraps>

00105bb2 <vector126>:
  105bb2:	6a 00                	push   $0x0
  105bb4:	6a 7e                	push   $0x7e
  105bb6:	e9 35 f8 ff ff       	jmp    1053f0 <alltraps>

00105bbb <vector127>:
  105bbb:	6a 00                	push   $0x0
  105bbd:	6a 7f                	push   $0x7f
  105bbf:	e9 2c f8 ff ff       	jmp    1053f0 <alltraps>

00105bc4 <vector128>:
  105bc4:	6a 00                	push   $0x0
  105bc6:	68 80 00 00 00       	push   $0x80
  105bcb:	e9 20 f8 ff ff       	jmp    1053f0 <alltraps>

00105bd0 <vector129>:
  105bd0:	6a 00                	push   $0x0
  105bd2:	68 81 00 00 00       	push   $0x81
  105bd7:	e9 14 f8 ff ff       	jmp    1053f0 <alltraps>

00105bdc <vector130>:
  105bdc:	6a 00                	push   $0x0
  105bde:	68 82 00 00 00       	push   $0x82
  105be3:	e9 08 f8 ff ff       	jmp    1053f0 <alltraps>

00105be8 <vector131>:
  105be8:	6a 00                	push   $0x0
  105bea:	68 83 00 00 00       	push   $0x83
  105bef:	e9 fc f7 ff ff       	jmp    1053f0 <alltraps>

00105bf4 <vector132>:
  105bf4:	6a 00                	push   $0x0
  105bf6:	68 84 00 00 00       	push   $0x84
  105bfb:	e9 f0 f7 ff ff       	jmp    1053f0 <alltraps>

00105c00 <vector133>:
  105c00:	6a 00                	push   $0x0
  105c02:	68 85 00 00 00       	push   $0x85
  105c07:	e9 e4 f7 ff ff       	jmp    1053f0 <alltraps>

00105c0c <vector134>:
  105c0c:	6a 00                	push   $0x0
  105c0e:	68 86 00 00 00       	push   $0x86
  105c13:	e9 d8 f7 ff ff       	jmp    1053f0 <alltraps>

00105c18 <vector135>:
  105c18:	6a 00                	push   $0x0
  105c1a:	68 87 00 00 00       	push   $0x87
  105c1f:	e9 cc f7 ff ff       	jmp    1053f0 <alltraps>

00105c24 <vector136>:
  105c24:	6a 00                	push   $0x0
  105c26:	68 88 00 00 00       	push   $0x88
  105c2b:	e9 c0 f7 ff ff       	jmp    1053f0 <alltraps>

00105c30 <vector137>:
  105c30:	6a 00                	push   $0x0
  105c32:	68 89 00 00 00       	push   $0x89
  105c37:	e9 b4 f7 ff ff       	jmp    1053f0 <alltraps>

00105c3c <vector138>:
  105c3c:	6a 00                	push   $0x0
  105c3e:	68 8a 00 00 00       	push   $0x8a
  105c43:	e9 a8 f7 ff ff       	jmp    1053f0 <alltraps>

00105c48 <vector139>:
  105c48:	6a 00                	push   $0x0
  105c4a:	68 8b 00 00 00       	push   $0x8b
  105c4f:	e9 9c f7 ff ff       	jmp    1053f0 <alltraps>

00105c54 <vector140>:
  105c54:	6a 00                	push   $0x0
  105c56:	68 8c 00 00 00       	push   $0x8c
  105c5b:	e9 90 f7 ff ff       	jmp    1053f0 <alltraps>

00105c60 <vector141>:
  105c60:	6a 00                	push   $0x0
  105c62:	68 8d 00 00 00       	push   $0x8d
  105c67:	e9 84 f7 ff ff       	jmp    1053f0 <alltraps>

00105c6c <vector142>:
  105c6c:	6a 00                	push   $0x0
  105c6e:	68 8e 00 00 00       	push   $0x8e
  105c73:	e9 78 f7 ff ff       	jmp    1053f0 <alltraps>

00105c78 <vector143>:
  105c78:	6a 00                	push   $0x0
  105c7a:	68 8f 00 00 00       	push   $0x8f
  105c7f:	e9 6c f7 ff ff       	jmp    1053f0 <alltraps>

00105c84 <vector144>:
  105c84:	6a 00                	push   $0x0
  105c86:	68 90 00 00 00       	push   $0x90
  105c8b:	e9 60 f7 ff ff       	jmp    1053f0 <alltraps>

00105c90 <vector145>:
  105c90:	6a 00                	push   $0x0
  105c92:	68 91 00 00 00       	push   $0x91
  105c97:	e9 54 f7 ff ff       	jmp    1053f0 <alltraps>

00105c9c <vector146>:
  105c9c:	6a 00                	push   $0x0
  105c9e:	68 92 00 00 00       	push   $0x92
  105ca3:	e9 48 f7 ff ff       	jmp    1053f0 <alltraps>

00105ca8 <vector147>:
  105ca8:	6a 00                	push   $0x0
  105caa:	68 93 00 00 00       	push   $0x93
  105caf:	e9 3c f7 ff ff       	jmp    1053f0 <alltraps>

00105cb4 <vector148>:
  105cb4:	6a 00                	push   $0x0
  105cb6:	68 94 00 00 00       	push   $0x94
  105cbb:	e9 30 f7 ff ff       	jmp    1053f0 <alltraps>

00105cc0 <vector149>:
  105cc0:	6a 00                	push   $0x0
  105cc2:	68 95 00 00 00       	push   $0x95
  105cc7:	e9 24 f7 ff ff       	jmp    1053f0 <alltraps>

00105ccc <vector150>:
  105ccc:	6a 00                	push   $0x0
  105cce:	68 96 00 00 00       	push   $0x96
  105cd3:	e9 18 f7 ff ff       	jmp    1053f0 <alltraps>

00105cd8 <vector151>:
  105cd8:	6a 00                	push   $0x0
  105cda:	68 97 00 00 00       	push   $0x97
  105cdf:	e9 0c f7 ff ff       	jmp    1053f0 <alltraps>

00105ce4 <vector152>:
  105ce4:	6a 00                	push   $0x0
  105ce6:	68 98 00 00 00       	push   $0x98
  105ceb:	e9 00 f7 ff ff       	jmp    1053f0 <alltraps>

00105cf0 <vector153>:
  105cf0:	6a 00                	push   $0x0
  105cf2:	68 99 00 00 00       	push   $0x99
  105cf7:	e9 f4 f6 ff ff       	jmp    1053f0 <alltraps>

00105cfc <vector154>:
  105cfc:	6a 00                	push   $0x0
  105cfe:	68 9a 00 00 00       	push   $0x9a
  105d03:	e9 e8 f6 ff ff       	jmp    1053f0 <alltraps>

00105d08 <vector155>:
  105d08:	6a 00                	push   $0x0
  105d0a:	68 9b 00 00 00       	push   $0x9b
  105d0f:	e9 dc f6 ff ff       	jmp    1053f0 <alltraps>

00105d14 <vector156>:
  105d14:	6a 00                	push   $0x0
  105d16:	68 9c 00 00 00       	push   $0x9c
  105d1b:	e9 d0 f6 ff ff       	jmp    1053f0 <alltraps>

00105d20 <vector157>:
  105d20:	6a 00                	push   $0x0
  105d22:	68 9d 00 00 00       	push   $0x9d
  105d27:	e9 c4 f6 ff ff       	jmp    1053f0 <alltraps>

00105d2c <vector158>:
  105d2c:	6a 00                	push   $0x0
  105d2e:	68 9e 00 00 00       	push   $0x9e
  105d33:	e9 b8 f6 ff ff       	jmp    1053f0 <alltraps>

00105d38 <vector159>:
  105d38:	6a 00                	push   $0x0
  105d3a:	68 9f 00 00 00       	push   $0x9f
  105d3f:	e9 ac f6 ff ff       	jmp    1053f0 <alltraps>

00105d44 <vector160>:
  105d44:	6a 00                	push   $0x0
  105d46:	68 a0 00 00 00       	push   $0xa0
  105d4b:	e9 a0 f6 ff ff       	jmp    1053f0 <alltraps>

00105d50 <vector161>:
  105d50:	6a 00                	push   $0x0
  105d52:	68 a1 00 00 00       	push   $0xa1
  105d57:	e9 94 f6 ff ff       	jmp    1053f0 <alltraps>

00105d5c <vector162>:
  105d5c:	6a 00                	push   $0x0
  105d5e:	68 a2 00 00 00       	push   $0xa2
  105d63:	e9 88 f6 ff ff       	jmp    1053f0 <alltraps>

00105d68 <vector163>:
  105d68:	6a 00                	push   $0x0
  105d6a:	68 a3 00 00 00       	push   $0xa3
  105d6f:	e9 7c f6 ff ff       	jmp    1053f0 <alltraps>

00105d74 <vector164>:
  105d74:	6a 00                	push   $0x0
  105d76:	68 a4 00 00 00       	push   $0xa4
  105d7b:	e9 70 f6 ff ff       	jmp    1053f0 <alltraps>

00105d80 <vector165>:
  105d80:	6a 00                	push   $0x0
  105d82:	68 a5 00 00 00       	push   $0xa5
  105d87:	e9 64 f6 ff ff       	jmp    1053f0 <alltraps>

00105d8c <vector166>:
  105d8c:	6a 00                	push   $0x0
  105d8e:	68 a6 00 00 00       	push   $0xa6
  105d93:	e9 58 f6 ff ff       	jmp    1053f0 <alltraps>

00105d98 <vector167>:
  105d98:	6a 00                	push   $0x0
  105d9a:	68 a7 00 00 00       	push   $0xa7
  105d9f:	e9 4c f6 ff ff       	jmp    1053f0 <alltraps>

00105da4 <vector168>:
  105da4:	6a 00                	push   $0x0
  105da6:	68 a8 00 00 00       	push   $0xa8
  105dab:	e9 40 f6 ff ff       	jmp    1053f0 <alltraps>

00105db0 <vector169>:
  105db0:	6a 00                	push   $0x0
  105db2:	68 a9 00 00 00       	push   $0xa9
  105db7:	e9 34 f6 ff ff       	jmp    1053f0 <alltraps>

00105dbc <vector170>:
  105dbc:	6a 00                	push   $0x0
  105dbe:	68 aa 00 00 00       	push   $0xaa
  105dc3:	e9 28 f6 ff ff       	jmp    1053f0 <alltraps>

00105dc8 <vector171>:
  105dc8:	6a 00                	push   $0x0
  105dca:	68 ab 00 00 00       	push   $0xab
  105dcf:	e9 1c f6 ff ff       	jmp    1053f0 <alltraps>

00105dd4 <vector172>:
  105dd4:	6a 00                	push   $0x0
  105dd6:	68 ac 00 00 00       	push   $0xac
  105ddb:	e9 10 f6 ff ff       	jmp    1053f0 <alltraps>

00105de0 <vector173>:
  105de0:	6a 00                	push   $0x0
  105de2:	68 ad 00 00 00       	push   $0xad
  105de7:	e9 04 f6 ff ff       	jmp    1053f0 <alltraps>

00105dec <vector174>:
  105dec:	6a 00                	push   $0x0
  105dee:	68 ae 00 00 00       	push   $0xae
  105df3:	e9 f8 f5 ff ff       	jmp    1053f0 <alltraps>

00105df8 <vector175>:
  105df8:	6a 00                	push   $0x0
  105dfa:	68 af 00 00 00       	push   $0xaf
  105dff:	e9 ec f5 ff ff       	jmp    1053f0 <alltraps>

00105e04 <vector176>:
  105e04:	6a 00                	push   $0x0
  105e06:	68 b0 00 00 00       	push   $0xb0
  105e0b:	e9 e0 f5 ff ff       	jmp    1053f0 <alltraps>

00105e10 <vector177>:
  105e10:	6a 00                	push   $0x0
  105e12:	68 b1 00 00 00       	push   $0xb1
  105e17:	e9 d4 f5 ff ff       	jmp    1053f0 <alltraps>

00105e1c <vector178>:
  105e1c:	6a 00                	push   $0x0
  105e1e:	68 b2 00 00 00       	push   $0xb2
  105e23:	e9 c8 f5 ff ff       	jmp    1053f0 <alltraps>

00105e28 <vector179>:
  105e28:	6a 00                	push   $0x0
  105e2a:	68 b3 00 00 00       	push   $0xb3
  105e2f:	e9 bc f5 ff ff       	jmp    1053f0 <alltraps>

00105e34 <vector180>:
  105e34:	6a 00                	push   $0x0
  105e36:	68 b4 00 00 00       	push   $0xb4
  105e3b:	e9 b0 f5 ff ff       	jmp    1053f0 <alltraps>

00105e40 <vector181>:
  105e40:	6a 00                	push   $0x0
  105e42:	68 b5 00 00 00       	push   $0xb5
  105e47:	e9 a4 f5 ff ff       	jmp    1053f0 <alltraps>

00105e4c <vector182>:
  105e4c:	6a 00                	push   $0x0
  105e4e:	68 b6 00 00 00       	push   $0xb6
  105e53:	e9 98 f5 ff ff       	jmp    1053f0 <alltraps>

00105e58 <vector183>:
  105e58:	6a 00                	push   $0x0
  105e5a:	68 b7 00 00 00       	push   $0xb7
  105e5f:	e9 8c f5 ff ff       	jmp    1053f0 <alltraps>

00105e64 <vector184>:
  105e64:	6a 00                	push   $0x0
  105e66:	68 b8 00 00 00       	push   $0xb8
  105e6b:	e9 80 f5 ff ff       	jmp    1053f0 <alltraps>

00105e70 <vector185>:
  105e70:	6a 00                	push   $0x0
  105e72:	68 b9 00 00 00       	push   $0xb9
  105e77:	e9 74 f5 ff ff       	jmp    1053f0 <alltraps>

00105e7c <vector186>:
  105e7c:	6a 00                	push   $0x0
  105e7e:	68 ba 00 00 00       	push   $0xba
  105e83:	e9 68 f5 ff ff       	jmp    1053f0 <alltraps>

00105e88 <vector187>:
  105e88:	6a 00                	push   $0x0
  105e8a:	68 bb 00 00 00       	push   $0xbb
  105e8f:	e9 5c f5 ff ff       	jmp    1053f0 <alltraps>

00105e94 <vector188>:
  105e94:	6a 00                	push   $0x0
  105e96:	68 bc 00 00 00       	push   $0xbc
  105e9b:	e9 50 f5 ff ff       	jmp    1053f0 <alltraps>

00105ea0 <vector189>:
  105ea0:	6a 00                	push   $0x0
  105ea2:	68 bd 00 00 00       	push   $0xbd
  105ea7:	e9 44 f5 ff ff       	jmp    1053f0 <alltraps>

00105eac <vector190>:
  105eac:	6a 00                	push   $0x0
  105eae:	68 be 00 00 00       	push   $0xbe
  105eb3:	e9 38 f5 ff ff       	jmp    1053f0 <alltraps>

00105eb8 <vector191>:
  105eb8:	6a 00                	push   $0x0
  105eba:	68 bf 00 00 00       	push   $0xbf
  105ebf:	e9 2c f5 ff ff       	jmp    1053f0 <alltraps>

00105ec4 <vector192>:
  105ec4:	6a 00                	push   $0x0
  105ec6:	68 c0 00 00 00       	push   $0xc0
  105ecb:	e9 20 f5 ff ff       	jmp    1053f0 <alltraps>

00105ed0 <vector193>:
  105ed0:	6a 00                	push   $0x0
  105ed2:	68 c1 00 00 00       	push   $0xc1
  105ed7:	e9 14 f5 ff ff       	jmp    1053f0 <alltraps>

00105edc <vector194>:
  105edc:	6a 00                	push   $0x0
  105ede:	68 c2 00 00 00       	push   $0xc2
  105ee3:	e9 08 f5 ff ff       	jmp    1053f0 <alltraps>

00105ee8 <vector195>:
  105ee8:	6a 00                	push   $0x0
  105eea:	68 c3 00 00 00       	push   $0xc3
  105eef:	e9 fc f4 ff ff       	jmp    1053f0 <alltraps>

00105ef4 <vector196>:
  105ef4:	6a 00                	push   $0x0
  105ef6:	68 c4 00 00 00       	push   $0xc4
  105efb:	e9 f0 f4 ff ff       	jmp    1053f0 <alltraps>

00105f00 <vector197>:
  105f00:	6a 00                	push   $0x0
  105f02:	68 c5 00 00 00       	push   $0xc5
  105f07:	e9 e4 f4 ff ff       	jmp    1053f0 <alltraps>

00105f0c <vector198>:
  105f0c:	6a 00                	push   $0x0
  105f0e:	68 c6 00 00 00       	push   $0xc6
  105f13:	e9 d8 f4 ff ff       	jmp    1053f0 <alltraps>

00105f18 <vector199>:
  105f18:	6a 00                	push   $0x0
  105f1a:	68 c7 00 00 00       	push   $0xc7
  105f1f:	e9 cc f4 ff ff       	jmp    1053f0 <alltraps>

00105f24 <vector200>:
  105f24:	6a 00                	push   $0x0
  105f26:	68 c8 00 00 00       	push   $0xc8
  105f2b:	e9 c0 f4 ff ff       	jmp    1053f0 <alltraps>

00105f30 <vector201>:
  105f30:	6a 00                	push   $0x0
  105f32:	68 c9 00 00 00       	push   $0xc9
  105f37:	e9 b4 f4 ff ff       	jmp    1053f0 <alltraps>

00105f3c <vector202>:
  105f3c:	6a 00                	push   $0x0
  105f3e:	68 ca 00 00 00       	push   $0xca
  105f43:	e9 a8 f4 ff ff       	jmp    1053f0 <alltraps>

00105f48 <vector203>:
  105f48:	6a 00                	push   $0x0
  105f4a:	68 cb 00 00 00       	push   $0xcb
  105f4f:	e9 9c f4 ff ff       	jmp    1053f0 <alltraps>

00105f54 <vector204>:
  105f54:	6a 00                	push   $0x0
  105f56:	68 cc 00 00 00       	push   $0xcc
  105f5b:	e9 90 f4 ff ff       	jmp    1053f0 <alltraps>

00105f60 <vector205>:
  105f60:	6a 00                	push   $0x0
  105f62:	68 cd 00 00 00       	push   $0xcd
  105f67:	e9 84 f4 ff ff       	jmp    1053f0 <alltraps>

00105f6c <vector206>:
  105f6c:	6a 00                	push   $0x0
  105f6e:	68 ce 00 00 00       	push   $0xce
  105f73:	e9 78 f4 ff ff       	jmp    1053f0 <alltraps>

00105f78 <vector207>:
  105f78:	6a 00                	push   $0x0
  105f7a:	68 cf 00 00 00       	push   $0xcf
  105f7f:	e9 6c f4 ff ff       	jmp    1053f0 <alltraps>

00105f84 <vector208>:
  105f84:	6a 00                	push   $0x0
  105f86:	68 d0 00 00 00       	push   $0xd0
  105f8b:	e9 60 f4 ff ff       	jmp    1053f0 <alltraps>

00105f90 <vector209>:
  105f90:	6a 00                	push   $0x0
  105f92:	68 d1 00 00 00       	push   $0xd1
  105f97:	e9 54 f4 ff ff       	jmp    1053f0 <alltraps>

00105f9c <vector210>:
  105f9c:	6a 00                	push   $0x0
  105f9e:	68 d2 00 00 00       	push   $0xd2
  105fa3:	e9 48 f4 ff ff       	jmp    1053f0 <alltraps>

00105fa8 <vector211>:
  105fa8:	6a 00                	push   $0x0
  105faa:	68 d3 00 00 00       	push   $0xd3
  105faf:	e9 3c f4 ff ff       	jmp    1053f0 <alltraps>

00105fb4 <vector212>:
  105fb4:	6a 00                	push   $0x0
  105fb6:	68 d4 00 00 00       	push   $0xd4
  105fbb:	e9 30 f4 ff ff       	jmp    1053f0 <alltraps>

00105fc0 <vector213>:
  105fc0:	6a 00                	push   $0x0
  105fc2:	68 d5 00 00 00       	push   $0xd5
  105fc7:	e9 24 f4 ff ff       	jmp    1053f0 <alltraps>

00105fcc <vector214>:
  105fcc:	6a 00                	push   $0x0
  105fce:	68 d6 00 00 00       	push   $0xd6
  105fd3:	e9 18 f4 ff ff       	jmp    1053f0 <alltraps>

00105fd8 <vector215>:
  105fd8:	6a 00                	push   $0x0
  105fda:	68 d7 00 00 00       	push   $0xd7
  105fdf:	e9 0c f4 ff ff       	jmp    1053f0 <alltraps>

00105fe4 <vector216>:
  105fe4:	6a 00                	push   $0x0
  105fe6:	68 d8 00 00 00       	push   $0xd8
  105feb:	e9 00 f4 ff ff       	jmp    1053f0 <alltraps>

00105ff0 <vector217>:
  105ff0:	6a 00                	push   $0x0
  105ff2:	68 d9 00 00 00       	push   $0xd9
  105ff7:	e9 f4 f3 ff ff       	jmp    1053f0 <alltraps>

00105ffc <vector218>:
  105ffc:	6a 00                	push   $0x0
  105ffe:	68 da 00 00 00       	push   $0xda
  106003:	e9 e8 f3 ff ff       	jmp    1053f0 <alltraps>

00106008 <vector219>:
  106008:	6a 00                	push   $0x0
  10600a:	68 db 00 00 00       	push   $0xdb
  10600f:	e9 dc f3 ff ff       	jmp    1053f0 <alltraps>

00106014 <vector220>:
  106014:	6a 00                	push   $0x0
  106016:	68 dc 00 00 00       	push   $0xdc
  10601b:	e9 d0 f3 ff ff       	jmp    1053f0 <alltraps>

00106020 <vector221>:
  106020:	6a 00                	push   $0x0
  106022:	68 dd 00 00 00       	push   $0xdd
  106027:	e9 c4 f3 ff ff       	jmp    1053f0 <alltraps>

0010602c <vector222>:
  10602c:	6a 00                	push   $0x0
  10602e:	68 de 00 00 00       	push   $0xde
  106033:	e9 b8 f3 ff ff       	jmp    1053f0 <alltraps>

00106038 <vector223>:
  106038:	6a 00                	push   $0x0
  10603a:	68 df 00 00 00       	push   $0xdf
  10603f:	e9 ac f3 ff ff       	jmp    1053f0 <alltraps>

00106044 <vector224>:
  106044:	6a 00                	push   $0x0
  106046:	68 e0 00 00 00       	push   $0xe0
  10604b:	e9 a0 f3 ff ff       	jmp    1053f0 <alltraps>

00106050 <vector225>:
  106050:	6a 00                	push   $0x0
  106052:	68 e1 00 00 00       	push   $0xe1
  106057:	e9 94 f3 ff ff       	jmp    1053f0 <alltraps>

0010605c <vector226>:
  10605c:	6a 00                	push   $0x0
  10605e:	68 e2 00 00 00       	push   $0xe2
  106063:	e9 88 f3 ff ff       	jmp    1053f0 <alltraps>

00106068 <vector227>:
  106068:	6a 00                	push   $0x0
  10606a:	68 e3 00 00 00       	push   $0xe3
  10606f:	e9 7c f3 ff ff       	jmp    1053f0 <alltraps>

00106074 <vector228>:
  106074:	6a 00                	push   $0x0
  106076:	68 e4 00 00 00       	push   $0xe4
  10607b:	e9 70 f3 ff ff       	jmp    1053f0 <alltraps>

00106080 <vector229>:
  106080:	6a 00                	push   $0x0
  106082:	68 e5 00 00 00       	push   $0xe5
  106087:	e9 64 f3 ff ff       	jmp    1053f0 <alltraps>

0010608c <vector230>:
  10608c:	6a 00                	push   $0x0
  10608e:	68 e6 00 00 00       	push   $0xe6
  106093:	e9 58 f3 ff ff       	jmp    1053f0 <alltraps>

00106098 <vector231>:
  106098:	6a 00                	push   $0x0
  10609a:	68 e7 00 00 00       	push   $0xe7
  10609f:	e9 4c f3 ff ff       	jmp    1053f0 <alltraps>

001060a4 <vector232>:
  1060a4:	6a 00                	push   $0x0
  1060a6:	68 e8 00 00 00       	push   $0xe8
  1060ab:	e9 40 f3 ff ff       	jmp    1053f0 <alltraps>

001060b0 <vector233>:
  1060b0:	6a 00                	push   $0x0
  1060b2:	68 e9 00 00 00       	push   $0xe9
  1060b7:	e9 34 f3 ff ff       	jmp    1053f0 <alltraps>

001060bc <vector234>:
  1060bc:	6a 00                	push   $0x0
  1060be:	68 ea 00 00 00       	push   $0xea
  1060c3:	e9 28 f3 ff ff       	jmp    1053f0 <alltraps>

001060c8 <vector235>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	68 eb 00 00 00       	push   $0xeb
  1060cf:	e9 1c f3 ff ff       	jmp    1053f0 <alltraps>

001060d4 <vector236>:
  1060d4:	6a 00                	push   $0x0
  1060d6:	68 ec 00 00 00       	push   $0xec
  1060db:	e9 10 f3 ff ff       	jmp    1053f0 <alltraps>

001060e0 <vector237>:
  1060e0:	6a 00                	push   $0x0
  1060e2:	68 ed 00 00 00       	push   $0xed
  1060e7:	e9 04 f3 ff ff       	jmp    1053f0 <alltraps>

001060ec <vector238>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	68 ee 00 00 00       	push   $0xee
  1060f3:	e9 f8 f2 ff ff       	jmp    1053f0 <alltraps>

001060f8 <vector239>:
  1060f8:	6a 00                	push   $0x0
  1060fa:	68 ef 00 00 00       	push   $0xef
  1060ff:	e9 ec f2 ff ff       	jmp    1053f0 <alltraps>

00106104 <vector240>:
  106104:	6a 00                	push   $0x0
  106106:	68 f0 00 00 00       	push   $0xf0
  10610b:	e9 e0 f2 ff ff       	jmp    1053f0 <alltraps>

00106110 <vector241>:
  106110:	6a 00                	push   $0x0
  106112:	68 f1 00 00 00       	push   $0xf1
  106117:	e9 d4 f2 ff ff       	jmp    1053f0 <alltraps>

0010611c <vector242>:
  10611c:	6a 00                	push   $0x0
  10611e:	68 f2 00 00 00       	push   $0xf2
  106123:	e9 c8 f2 ff ff       	jmp    1053f0 <alltraps>

00106128 <vector243>:
  106128:	6a 00                	push   $0x0
  10612a:	68 f3 00 00 00       	push   $0xf3
  10612f:	e9 bc f2 ff ff       	jmp    1053f0 <alltraps>

00106134 <vector244>:
  106134:	6a 00                	push   $0x0
  106136:	68 f4 00 00 00       	push   $0xf4
  10613b:	e9 b0 f2 ff ff       	jmp    1053f0 <alltraps>

00106140 <vector245>:
  106140:	6a 00                	push   $0x0
  106142:	68 f5 00 00 00       	push   $0xf5
  106147:	e9 a4 f2 ff ff       	jmp    1053f0 <alltraps>

0010614c <vector246>:
  10614c:	6a 00                	push   $0x0
  10614e:	68 f6 00 00 00       	push   $0xf6
  106153:	e9 98 f2 ff ff       	jmp    1053f0 <alltraps>

00106158 <vector247>:
  106158:	6a 00                	push   $0x0
  10615a:	68 f7 00 00 00       	push   $0xf7
  10615f:	e9 8c f2 ff ff       	jmp    1053f0 <alltraps>

00106164 <vector248>:
  106164:	6a 00                	push   $0x0
  106166:	68 f8 00 00 00       	push   $0xf8
  10616b:	e9 80 f2 ff ff       	jmp    1053f0 <alltraps>

00106170 <vector249>:
  106170:	6a 00                	push   $0x0
  106172:	68 f9 00 00 00       	push   $0xf9
  106177:	e9 74 f2 ff ff       	jmp    1053f0 <alltraps>

0010617c <vector250>:
  10617c:	6a 00                	push   $0x0
  10617e:	68 fa 00 00 00       	push   $0xfa
  106183:	e9 68 f2 ff ff       	jmp    1053f0 <alltraps>

00106188 <vector251>:
  106188:	6a 00                	push   $0x0
  10618a:	68 fb 00 00 00       	push   $0xfb
  10618f:	e9 5c f2 ff ff       	jmp    1053f0 <alltraps>

00106194 <vector252>:
  106194:	6a 00                	push   $0x0
  106196:	68 fc 00 00 00       	push   $0xfc
  10619b:	e9 50 f2 ff ff       	jmp    1053f0 <alltraps>

001061a0 <vector253>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	68 fd 00 00 00       	push   $0xfd
  1061a7:	e9 44 f2 ff ff       	jmp    1053f0 <alltraps>

001061ac <vector254>:
  1061ac:	6a 00                	push   $0x0
  1061ae:	68 fe 00 00 00       	push   $0xfe
  1061b3:	e9 38 f2 ff ff       	jmp    1053f0 <alltraps>

001061b8 <vector255>:
  1061b8:	6a 00                	push   $0x0
  1061ba:	68 ff 00 00 00       	push   $0xff
  1061bf:	e9 2c f2 ff ff       	jmp    1053f0 <alltraps>
