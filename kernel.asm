
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <brelse>:
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 04             	sub    $0x4,%esp
  100007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10000a:	f6 03 01             	testb  $0x1,(%ebx)
  10000d:	74 58                	je     100067 <brelse+0x67>
  10000f:	c7 04 24 00 9c 10 00 	movl   $0x109c00,(%esp)
  100016:	e8 55 44 00 00       	call   104470 <acquire>
  10001b:	8b 53 10             	mov    0x10(%ebx),%edx
  10001e:	8b 43 0c             	mov    0xc(%ebx),%eax
  100021:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  100024:	89 42 0c             	mov    %eax,0xc(%edx)
  100027:	8b 43 0c             	mov    0xc(%ebx),%eax
  10002a:	c7 43 0c e0 84 10 00 	movl   $0x1084e0,0xc(%ebx)
  100031:	89 50 10             	mov    %edx,0x10(%eax)
  100034:	a1 f0 84 10 00       	mov    0x1084f0,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  10003c:	a1 f0 84 10 00       	mov    0x1084f0,%eax
  100041:	89 1d f0 84 10 00    	mov    %ebx,0x1084f0
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  10004a:	c7 04 24 00 87 10 00 	movl   $0x108700,(%esp)
  100051:	e8 3a 33 00 00       	call   103390 <wakeup>
  100056:	c7 45 08 00 9c 10 00 	movl   $0x109c00,0x8(%ebp)
  10005d:	83 c4 04             	add    $0x4,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  100062:	e9 c9 43 00 00       	jmp    104430 <release>
  100067:	c7 04 24 00 65 10 00 	movl   $0x106500,(%esp)
  10006e:	e8 fd 08 00 00       	call   100970 <panic>
  100073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100080 <bwrite>:
  100080:	55                   	push   %ebp
  100081:	89 e5                	mov    %esp,%ebp
  100083:	83 ec 08             	sub    $0x8,%esp
  100086:	8b 55 08             	mov    0x8(%ebp),%edx
  100089:	8b 02                	mov    (%edx),%eax
  10008b:	a8 01                	test   $0x1,%al
  10008d:	74 0e                	je     10009d <bwrite+0x1d>
  10008f:	83 c8 04             	or     $0x4,%eax
  100092:	89 02                	mov    %eax,(%edx)
  100094:	89 55 08             	mov    %edx,0x8(%ebp)
  100097:	c9                   	leave  
  100098:	e9 03 20 00 00       	jmp    1020a0 <ide_rw>
  10009d:	c7 04 24 07 65 10 00 	movl   $0x106507,(%esp)
  1000a4:	e8 c7 08 00 00       	call   100970 <panic>
  1000a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001000b0 <bread>:
  1000b0:	55                   	push   %ebp
  1000b1:	89 e5                	mov    %esp,%ebp
  1000b3:	57                   	push   %edi
  1000b4:	56                   	push   %esi
  1000b5:	53                   	push   %ebx
  1000b6:	83 ec 0c             	sub    $0xc,%esp
  1000b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1000bf:	c7 04 24 00 9c 10 00 	movl   $0x109c00,(%esp)
  1000c6:	e8 a5 43 00 00       	call   104470 <acquire>
  1000cb:	8b 1d f0 84 10 00    	mov    0x1084f0,%ebx
  1000d1:	81 fb e0 84 10 00    	cmp    $0x1084e0,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 45                	jmp    100120 <bread+0x70>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb e0 84 10 00    	cmp    $0x1084e0,%ebx
  1000e9:	74 35                	je     100120 <bread+0x70>
  1000eb:	8b 03                	mov    (%ebx),%eax
  1000ed:	a8 03                	test   $0x3,%al
  1000ef:	74 ef                	je     1000e0 <bread+0x30>
  1000f1:	3b 73 04             	cmp    0x4(%ebx),%esi
  1000f4:	75 ea                	jne    1000e0 <bread+0x30>
  1000f6:	3b 7b 08             	cmp    0x8(%ebx),%edi
  1000f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100100:	75 de                	jne    1000e0 <bread+0x30>
  100102:	a8 01                	test   $0x1,%al
  100104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100108:	74 75                	je     10017f <bread+0xcf>
  10010a:	c7 44 24 04 00 9c 10 	movl   $0x109c00,0x4(%esp)
  100111:	00 
  100112:	c7 04 24 00 87 10 00 	movl   $0x108700,(%esp)
  100119:	e8 d2 35 00 00       	call   1036f0 <sleep>
  10011e:	eb ab                	jmp    1000cb <bread+0x1b>
  100120:	a1 ec 84 10 00       	mov    0x1084ec,%eax
  100125:	3d e0 84 10 00       	cmp    $0x1084e0,%eax
  10012a:	75 0e                	jne    10013a <bread+0x8a>
  10012c:	eb 45                	jmp    100173 <bread+0xc3>
  10012e:	66 90                	xchg   %ax,%ax
  100130:	8b 40 0c             	mov    0xc(%eax),%eax
  100133:	3d e0 84 10 00       	cmp    $0x1084e0,%eax
  100138:	74 39                	je     100173 <bread+0xc3>
  10013a:	f6 00 01             	testb  $0x1,(%eax)
  10013d:	8d 76 00             	lea    0x0(%esi),%esi
  100140:	75 ee                	jne    100130 <bread+0x80>
  100142:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  100148:	89 c3                	mov    %eax,%ebx
  10014a:	89 70 04             	mov    %esi,0x4(%eax)
  10014d:	89 78 08             	mov    %edi,0x8(%eax)
  100150:	c7 04 24 00 9c 10 00 	movl   $0x109c00,(%esp)
  100157:	e8 d4 42 00 00       	call   104430 <release>
  10015c:	f6 03 02             	testb  $0x2,(%ebx)
  10015f:	75 08                	jne    100169 <bread+0xb9>
  100161:	89 1c 24             	mov    %ebx,(%esp)
  100164:	e8 37 1f 00 00       	call   1020a0 <ide_rw>
  100169:	83 c4 0c             	add    $0xc,%esp
  10016c:	89 d8                	mov    %ebx,%eax
  10016e:	5b                   	pop    %ebx
  10016f:	5e                   	pop    %esi
  100170:	5f                   	pop    %edi
  100171:	5d                   	pop    %ebp
  100172:	c3                   	ret    
  100173:	c7 04 24 0e 65 10 00 	movl   $0x10650e,(%esp)
  10017a:	e8 f1 07 00 00       	call   100970 <panic>
  10017f:	83 c8 01             	or     $0x1,%eax
  100182:	89 03                	mov    %eax,(%ebx)
  100184:	c7 04 24 00 9c 10 00 	movl   $0x109c00,(%esp)
  10018b:	e8 a0 42 00 00       	call   104430 <release>
  100190:	eb ca                	jmp    10015c <bread+0xac>
  100192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001001a0 <binit>:
  1001a0:	55                   	push   %ebp
  1001a1:	89 e5                	mov    %esp,%ebp
  1001a3:	83 ec 08             	sub    $0x8,%esp
  1001a6:	c7 44 24 04 1f 65 10 	movl   $0x10651f,0x4(%esp)
  1001ad:	00 
  1001ae:	c7 04 24 00 9c 10 00 	movl   $0x109c00,(%esp)
  1001b5:	e8 e6 40 00 00       	call   1042a0 <initlock>
  1001ba:	b8 f0 9b 10 00       	mov    $0x109bf0,%eax
  1001bf:	3d 00 87 10 00       	cmp    $0x108700,%eax
  1001c4:	c7 05 ec 84 10 00 e0 	movl   $0x1084e0,0x1084ec
  1001cb:	84 10 00 
  1001ce:	c7 05 f0 84 10 00 e0 	movl   $0x1084e0,0x1084f0
  1001d5:	84 10 00 
  1001d8:	76 37                	jbe    100211 <binit+0x71>
  1001da:	b8 00 87 10 00       	mov    $0x108700,%eax
  1001df:	ba e0 84 10 00       	mov    $0x1084e0,%edx
  1001e4:	eb 06                	jmp    1001ec <binit+0x4c>
  1001e6:	66 90                	xchg   %ax,%ax
  1001e8:	89 c2                	mov    %eax,%edx
  1001ea:	89 c8                	mov    %ecx,%eax
  1001ec:	8d 88 18 02 00 00    	lea    0x218(%eax),%ecx
  1001f2:	81 f9 f0 9b 10 00    	cmp    $0x109bf0,%ecx
  1001f8:	c7 40 0c e0 84 10 00 	movl   $0x1084e0,0xc(%eax)
  1001ff:	89 50 10             	mov    %edx,0x10(%eax)
  100202:	89 42 0c             	mov    %eax,0xc(%edx)
  100205:	75 e1                	jne    1001e8 <binit+0x48>
  100207:	c7 05 f0 84 10 00 d8 	movl   $0x1099d8,0x1084f0
  10020e:	99 10 00 
  100211:	c9                   	leave  
  100212:	c3                   	ret    
  100213:	90                   	nop
  100214:	90                   	nop
  100215:	90                   	nop
  100216:	90                   	nop
  100217:	90                   	nop
  100218:	90                   	nop
  100219:	90                   	nop
  10021a:	90                   	nop
  10021b:	90                   	nop
  10021c:	90                   	nop
  10021d:	90                   	nop
  10021e:	90                   	nop
  10021f:	90                   	nop

00100220 <console_init>:
  100220:	55                   	push   %ebp
  100221:	89 e5                	mov    %esp,%ebp
  100223:	83 ec 08             	sub    $0x8,%esp
  100226:	c7 44 24 04 29 65 10 	movl   $0x106529,0x4(%esp)
  10022d:	00 
  10022e:	c7 04 24 40 84 10 00 	movl   $0x108440,(%esp)
  100235:	e8 66 40 00 00       	call   1042a0 <initlock>
  10023a:	c7 44 24 04 31 65 10 	movl   $0x106531,0x4(%esp)
  100241:	00 
  100242:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  100249:	e8 52 40 00 00       	call   1042a0 <initlock>
  10024e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100255:	c7 05 ac a6 10 00 a0 	movl   $0x1006a0,0x10a6ac
  10025c:	06 10 00 
  10025f:	c7 05 a8 a6 10 00 90 	movl   $0x100290,0x10a6a8
  100266:	02 10 00 
  100269:	c7 05 24 84 10 00 01 	movl   $0x1,0x108424
  100270:	00 00 00 
  100273:	e8 58 2b 00 00       	call   102dd0 <pic_enable>
  100278:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10027f:	00 
  100280:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100287:	e8 14 20 00 00       	call   1022a0 <ioapic_enable>
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    
  10028e:	66 90                	xchg   %ax,%ax

00100290 <console_read>:
  100290:	55                   	push   %ebp
  100291:	89 e5                	mov    %esp,%ebp
  100293:	57                   	push   %edi
  100294:	56                   	push   %esi
  100295:	53                   	push   %ebx
  100296:	83 ec 0c             	sub    $0xc,%esp
  100299:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10029c:	8b 45 08             	mov    0x8(%ebp),%eax
  10029f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1002a2:	89 04 24             	mov    %eax,(%esp)
  1002a5:	e8 d6 19 00 00       	call   101c80 <iunlock>
  1002aa:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  1002ad:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  1002b4:	e8 b7 41 00 00       	call   104470 <acquire>
  1002b9:	85 db                	test   %ebx,%ebx
  1002bb:	7f 39                	jg     1002f6 <console_read+0x66>
  1002bd:	e9 cf 00 00 00       	jmp    100391 <console_read+0x101>
  1002c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1002c8:	90                   	nop
  1002c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1002d0:	e8 bb 31 00 00       	call   103490 <curproc>
  1002d5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1002d8:	85 c0                	test   %eax,%eax
  1002da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1002e0:	75 56                	jne    100338 <console_read+0xa8>
  1002e2:	c7 44 24 04 40 9c 10 	movl   $0x109c40,0x4(%esp)
  1002e9:	00 
  1002ea:	c7 04 24 f4 9c 10 00 	movl   $0x109cf4,(%esp)
  1002f1:	e8 fa 33 00 00       	call   1036f0 <sleep>
  1002f6:	8b 15 f4 9c 10 00    	mov    0x109cf4,%edx
  1002fc:	3b 15 f8 9c 10 00    	cmp    0x109cf8,%edx
  100302:	74 c4                	je     1002c8 <console_read+0x38>
  100304:	89 d0                	mov    %edx,%eax
  100306:	83 e0 7f             	and    $0x7f,%eax
  100309:	0f b6 88 74 9c 10 00 	movzbl 0x109c74(%eax),%ecx
  100310:	8d 42 01             	lea    0x1(%edx),%eax
  100313:	a3 f4 9c 10 00       	mov    %eax,0x109cf4
  100318:	0f be f1             	movsbl %cl,%esi
  10031b:	83 fe 04             	cmp    $0x4,%esi
  10031e:	74 3e                	je     10035e <console_read+0xce>
  100320:	83 eb 01             	sub    $0x1,%ebx
  100323:	83 fe 0a             	cmp    $0xa,%esi
  100326:	88 0f                	mov    %cl,(%edi)
  100328:	74 3f                	je     100369 <console_read+0xd9>
  10032a:	85 db                	test   %ebx,%ebx
  10032c:	7e 3b                	jle    100369 <console_read+0xd9>
  10032e:	83 c7 01             	add    $0x1,%edi
  100331:	eb c3                	jmp    1002f6 <console_read+0x66>
  100333:	90                   	nop
  100334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100338:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  10033f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  100344:	e8 e7 40 00 00       	call   104430 <release>
  100349:	8b 45 08             	mov    0x8(%ebp),%eax
  10034c:	89 04 24             	mov    %eax,(%esp)
  10034f:	e8 ac 19 00 00       	call   101d00 <ilock>
  100354:	83 c4 0c             	add    $0xc,%esp
  100357:	89 d8                	mov    %ebx,%eax
  100359:	5b                   	pop    %ebx
  10035a:	5e                   	pop    %esi
  10035b:	5f                   	pop    %edi
  10035c:	5d                   	pop    %ebp
  10035d:	c3                   	ret    
  10035e:	39 5d f0             	cmp    %ebx,-0x10(%ebp)
  100361:	76 06                	jbe    100369 <console_read+0xd9>
  100363:	89 15 f4 9c 10 00    	mov    %edx,0x109cf4
  100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10036c:	29 d8                	sub    %ebx,%eax
  10036e:	89 c3                	mov    %eax,%ebx
  100370:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  100377:	e8 b4 40 00 00       	call   104430 <release>
  10037c:	8b 45 08             	mov    0x8(%ebp),%eax
  10037f:	89 04 24             	mov    %eax,(%esp)
  100382:	e8 79 19 00 00       	call   101d00 <ilock>
  100387:	83 c4 0c             	add    $0xc,%esp
  10038a:	89 d8                	mov    %ebx,%eax
  10038c:	5b                   	pop    %ebx
  10038d:	5e                   	pop    %esi
  10038e:	5f                   	pop    %edi
  10038f:	5d                   	pop    %ebp
  100390:	c3                   	ret    
  100391:	31 db                	xor    %ebx,%ebx
  100393:	eb db                	jmp    100370 <console_read+0xe0>
  100395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001003a0 <cons_putc>:
  1003a0:	55                   	push   %ebp
  1003a1:	89 e5                	mov    %esp,%ebp
  1003a3:	57                   	push   %edi
  1003a4:	56                   	push   %esi
  1003a5:	53                   	push   %ebx
  1003a6:	83 ec 0c             	sub    $0xc,%esp
  1003a9:	8b 15 20 84 10 00    	mov    0x108420,%edx
  1003af:	8b 75 08             	mov    0x8(%ebp),%esi
  1003b2:	85 d2                	test   %edx,%edx
  1003b4:	0f 85 e6 00 00 00    	jne    1004a0 <cons_putc+0x100>
  1003ba:	ba 79 03 00 00       	mov    $0x379,%edx
  1003bf:	ec                   	in     (%dx),%al
  1003c0:	31 db                	xor    %ebx,%ebx
  1003c2:	84 c0                	test   %al,%al
  1003c4:	b9 79 03 00 00       	mov    $0x379,%ecx
  1003c9:	79 10                	jns    1003db <cons_putc+0x3b>
  1003cb:	eb 15                	jmp    1003e2 <cons_putc+0x42>
  1003cd:	8d 76 00             	lea    0x0(%esi),%esi
  1003d0:	83 c3 01             	add    $0x1,%ebx
  1003d3:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
  1003d9:	74 07                	je     1003e2 <cons_putc+0x42>
  1003db:	89 ca                	mov    %ecx,%edx
  1003dd:	ec                   	in     (%dx),%al
  1003de:	84 c0                	test   %al,%al
  1003e0:	79 ee                	jns    1003d0 <cons_putc+0x30>
  1003e2:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  1003e8:	89 f0                	mov    %esi,%eax
  1003ea:	0f 84 b3 00 00 00    	je     1004a3 <cons_putc+0x103>
  1003f0:	ba 78 03 00 00       	mov    $0x378,%edx
  1003f5:	ee                   	out    %al,(%dx)
  1003f6:	b8 0d 00 00 00       	mov    $0xd,%eax
  1003fb:	b2 7a                	mov    $0x7a,%dl
  1003fd:	ee                   	out    %al,(%dx)
  1003fe:	b8 08 00 00 00       	mov    $0x8,%eax
  100403:	ee                   	out    %al,(%dx)
  100404:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  100409:	b8 0e 00 00 00       	mov    $0xe,%eax
  10040e:	89 ca                	mov    %ecx,%edx
  100410:	ee                   	out    %al,(%dx)
  100411:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100416:	89 fa                	mov    %edi,%edx
  100418:	ec                   	in     (%dx),%al
  100419:	0f b6 d8             	movzbl %al,%ebx
  10041c:	89 ca                	mov    %ecx,%edx
  10041e:	c1 e3 08             	shl    $0x8,%ebx
  100421:	b8 0f 00 00 00       	mov    $0xf,%eax
  100426:	ee                   	out    %al,(%dx)
  100427:	89 fa                	mov    %edi,%edx
  100429:	ec                   	in     (%dx),%al
  10042a:	0f b6 c0             	movzbl %al,%eax
  10042d:	09 c3                	or     %eax,%ebx
  10042f:	83 fe 0a             	cmp    $0xa,%esi
  100432:	0f 84 d9 00 00 00    	je     100511 <cons_putc+0x171>
  100438:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  10043e:	0f 84 b3 00 00 00    	je     1004f7 <cons_putc+0x157>
  100444:	89 f0                	mov    %esi,%eax
  100446:	66 25 ff 00          	and    $0xff,%ax
  10044a:	80 cc 07             	or     $0x7,%ah
  10044d:	66 89 84 1b 00 80 0b 	mov    %ax,0xb8000(%ebx,%ebx,1)
  100454:	00 
  100455:	83 c3 01             	add    $0x1,%ebx
  100458:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  10045e:	7f 4d                	jg     1004ad <cons_putc+0x10d>
  100460:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
  100463:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  100468:	b8 0e 00 00 00       	mov    $0xe,%eax
  10046d:	89 ca                	mov    %ecx,%edx
  10046f:	ee                   	out    %al,(%dx)
  100470:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100475:	89 d8                	mov    %ebx,%eax
  100477:	c1 f8 08             	sar    $0x8,%eax
  10047a:	89 fa                	mov    %edi,%edx
  10047c:	ee                   	out    %al,(%dx)
  10047d:	b8 0f 00 00 00       	mov    $0xf,%eax
  100482:	89 ca                	mov    %ecx,%edx
  100484:	ee                   	out    %al,(%dx)
  100485:	89 d8                	mov    %ebx,%eax
  100487:	89 fa                	mov    %edi,%edx
  100489:	ee                   	out    %al,(%dx)
  10048a:	66 c7 86 00 80 0b 00 	movw   $0x720,0xb8000(%esi)
  100491:	20 07 
  100493:	83 c4 0c             	add    $0xc,%esp
  100496:	5b                   	pop    %ebx
  100497:	5e                   	pop    %esi
  100498:	5f                   	pop    %edi
  100499:	5d                   	pop    %ebp
  10049a:	c3                   	ret    
  10049b:	90                   	nop
  10049c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1004a0:	fa                   	cli    
  1004a1:	eb fe                	jmp    1004a1 <cons_putc+0x101>
  1004a3:	b8 08 00 00 00       	mov    $0x8,%eax
  1004a8:	e9 43 ff ff ff       	jmp    1003f0 <cons_putc+0x50>
  1004ad:	83 eb 50             	sub    $0x50,%ebx
  1004b0:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  1004b7:	00 
  1004b8:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
  1004bb:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  1004c2:	00 
  1004c3:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  1004ca:	e8 a1 40 00 00       	call   104570 <memmove>
  1004cf:	b8 80 07 00 00       	mov    $0x780,%eax
  1004d4:	29 d8                	sub    %ebx,%eax
  1004d6:	01 c0                	add    %eax,%eax
  1004d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004dc:	8d 86 00 80 0b 00    	lea    0xb8000(%esi),%eax
  1004e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1004e9:	00 
  1004ea:	89 04 24             	mov    %eax,(%esp)
  1004ed:	e8 ee 3f 00 00       	call   1044e0 <memset>
  1004f2:	e9 6c ff ff ff       	jmp    100463 <cons_putc+0xc3>
  1004f7:	85 db                	test   %ebx,%ebx
  1004f9:	0f 8e 61 ff ff ff    	jle    100460 <cons_putc+0xc0>
  1004ff:	83 eb 01             	sub    $0x1,%ebx
  100502:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  100509:	00 20 07 
  10050c:	e9 47 ff ff ff       	jmp    100458 <cons_putc+0xb8>
  100511:	89 d8                	mov    %ebx,%eax
  100513:	ba 67 66 66 66       	mov    $0x66666667,%edx
  100518:	f7 ea                	imul   %edx
  10051a:	c1 ea 05             	shr    $0x5,%edx
  10051d:	8d 14 92             	lea    (%edx,%edx,4),%edx
  100520:	c1 e2 04             	shl    $0x4,%edx
  100523:	8d 5a 50             	lea    0x50(%edx),%ebx
  100526:	e9 2d ff ff ff       	jmp    100458 <cons_putc+0xb8>
  10052b:	90                   	nop
  10052c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100530 <console_intr>:
  100530:	55                   	push   %ebp
  100531:	89 e5                	mov    %esp,%ebp
  100533:	57                   	push   %edi
  100534:	bf 70 9c 10 00       	mov    $0x109c70,%edi
  100539:	56                   	push   %esi
  10053a:	53                   	push   %ebx
  10053b:	83 ec 0c             	sub    $0xc,%esp
  10053e:	8b 75 08             	mov    0x8(%ebp),%esi
  100541:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  100548:	e8 23 3f 00 00       	call   104470 <acquire>
  10054d:	8d 76 00             	lea    0x0(%esi),%esi
  100550:	ff d6                	call   *%esi
  100552:	85 c0                	test   %eax,%eax
  100554:	89 c3                	mov    %eax,%ebx
  100556:	0f 88 a4 00 00 00    	js     100600 <console_intr+0xd0>
  10055c:	83 fb 10             	cmp    $0x10,%ebx
  10055f:	90                   	nop
  100560:	0f 84 f2 00 00 00    	je     100658 <console_intr+0x128>
  100566:	83 fb 15             	cmp    $0x15,%ebx
  100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100570:	0f 84 c9 00 00 00    	je     10063f <console_intr+0x10f>
  100576:	83 fb 08             	cmp    $0x8,%ebx
  100579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100580:	0f 84 e2 00 00 00    	je     100668 <console_intr+0x138>
  100586:	85 db                	test   %ebx,%ebx
  100588:	74 c6                	je     100550 <console_intr+0x20>
  10058a:	8b 15 fc 9c 10 00    	mov    0x109cfc,%edx
  100590:	89 d0                	mov    %edx,%eax
  100592:	2b 05 f4 9c 10 00    	sub    0x109cf4,%eax
  100598:	83 f8 7f             	cmp    $0x7f,%eax
  10059b:	77 b3                	ja     100550 <console_intr+0x20>
  10059d:	89 d0                	mov    %edx,%eax
  10059f:	83 e0 7f             	and    $0x7f,%eax
  1005a2:	88 5c 07 04          	mov    %bl,0x4(%edi,%eax,1)
  1005a6:	8d 42 01             	lea    0x1(%edx),%eax
  1005a9:	a3 fc 9c 10 00       	mov    %eax,0x109cfc
  1005ae:	89 1c 24             	mov    %ebx,(%esp)
  1005b1:	e8 ea fd ff ff       	call   1003a0 <cons_putc>
  1005b6:	83 fb 0a             	cmp    $0xa,%ebx
  1005b9:	0f 84 d3 00 00 00    	je     100692 <console_intr+0x162>
  1005bf:	83 fb 04             	cmp    $0x4,%ebx
  1005c2:	0f 84 ca 00 00 00    	je     100692 <console_intr+0x162>
  1005c8:	a1 f4 9c 10 00       	mov    0x109cf4,%eax
  1005cd:	8b 15 fc 9c 10 00    	mov    0x109cfc,%edx
  1005d3:	83 e8 80             	sub    $0xffffff80,%eax
  1005d6:	39 c2                	cmp    %eax,%edx
  1005d8:	0f 85 72 ff ff ff    	jne    100550 <console_intr+0x20>
  1005de:	89 15 f8 9c 10 00    	mov    %edx,0x109cf8
  1005e4:	c7 04 24 f4 9c 10 00 	movl   $0x109cf4,(%esp)
  1005eb:	e8 a0 2d 00 00       	call   103390 <wakeup>
  1005f0:	ff d6                	call   *%esi
  1005f2:	85 c0                	test   %eax,%eax
  1005f4:	89 c3                	mov    %eax,%ebx
  1005f6:	0f 89 60 ff ff ff    	jns    10055c <console_intr+0x2c>
  1005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100600:	c7 45 08 40 9c 10 00 	movl   $0x109c40,0x8(%ebp)
  100607:	83 c4 0c             	add    $0xc,%esp
  10060a:	5b                   	pop    %ebx
  10060b:	5e                   	pop    %esi
  10060c:	5f                   	pop    %edi
  10060d:	5d                   	pop    %ebp
  10060e:	e9 1d 3e 00 00       	jmp    104430 <release>
  100613:	90                   	nop
  100614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100618:	8d 50 ff             	lea    -0x1(%eax),%edx
  10061b:	89 d0                	mov    %edx,%eax
  10061d:	83 e0 7f             	and    $0x7f,%eax
  100620:	80 b8 74 9c 10 00 0a 	cmpb   $0xa,0x109c74(%eax)
  100627:	0f 84 23 ff ff ff    	je     100550 <console_intr+0x20>
  10062d:	89 15 fc 9c 10 00    	mov    %edx,0x109cfc
  100633:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10063a:	e8 61 fd ff ff       	call   1003a0 <cons_putc>
  10063f:	a1 fc 9c 10 00       	mov    0x109cfc,%eax
  100644:	3b 05 f8 9c 10 00    	cmp    0x109cf8,%eax
  10064a:	75 cc                	jne    100618 <console_intr+0xe8>
  10064c:	e9 ff fe ff ff       	jmp    100550 <console_intr+0x20>
  100651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100658:	e8 d3 2b 00 00       	call   103230 <procdump>
  10065d:	8d 76 00             	lea    0x0(%esi),%esi
  100660:	e9 eb fe ff ff       	jmp    100550 <console_intr+0x20>
  100665:	8d 76 00             	lea    0x0(%esi),%esi
  100668:	a1 fc 9c 10 00       	mov    0x109cfc,%eax
  10066d:	3b 05 f8 9c 10 00    	cmp    0x109cf8,%eax
  100673:	0f 84 d7 fe ff ff    	je     100550 <console_intr+0x20>
  100679:	83 e8 01             	sub    $0x1,%eax
  10067c:	a3 fc 9c 10 00       	mov    %eax,0x109cfc
  100681:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100688:	e8 13 fd ff ff       	call   1003a0 <cons_putc>
  10068d:	e9 be fe ff ff       	jmp    100550 <console_intr+0x20>
  100692:	8b 15 fc 9c 10 00    	mov    0x109cfc,%edx
  100698:	e9 41 ff ff ff       	jmp    1005de <console_intr+0xae>
  10069d:	8d 76 00             	lea    0x0(%esi),%esi

001006a0 <console_write>:
  1006a0:	55                   	push   %ebp
  1006a1:	89 e5                	mov    %esp,%ebp
  1006a3:	57                   	push   %edi
  1006a4:	56                   	push   %esi
  1006a5:	53                   	push   %ebx
  1006a6:	83 ec 0c             	sub    $0xc,%esp
  1006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ac:	8b 75 10             	mov    0x10(%ebp),%esi
  1006af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1006b2:	89 04 24             	mov    %eax,(%esp)
  1006b5:	e8 c6 15 00 00       	call   101c80 <iunlock>
  1006ba:	c7 04 24 40 84 10 00 	movl   $0x108440,(%esp)
  1006c1:	e8 aa 3d 00 00       	call   104470 <acquire>
  1006c6:	85 f6                	test   %esi,%esi
  1006c8:	7e 19                	jle    1006e3 <console_write+0x43>
  1006ca:	31 db                	xor    %ebx,%ebx
  1006cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006d0:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
  1006d4:	83 c3 01             	add    $0x1,%ebx
  1006d7:	89 04 24             	mov    %eax,(%esp)
  1006da:	e8 c1 fc ff ff       	call   1003a0 <cons_putc>
  1006df:	39 de                	cmp    %ebx,%esi
  1006e1:	7f ed                	jg     1006d0 <console_write+0x30>
  1006e3:	c7 04 24 40 84 10 00 	movl   $0x108440,(%esp)
  1006ea:	e8 41 3d 00 00       	call   104430 <release>
  1006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 06 16 00 00       	call   101d00 <ilock>
  1006fa:	83 c4 0c             	add    $0xc,%esp
  1006fd:	89 f0                	mov    %esi,%eax
  1006ff:	5b                   	pop    %ebx
  100700:	5e                   	pop    %esi
  100701:	5f                   	pop    %edi
  100702:	5d                   	pop    %ebp
  100703:	c3                   	ret    
  100704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10070a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00100710 <printint>:
  100710:	55                   	push   %ebp
  100711:	89 e5                	mov    %esp,%ebp
  100713:	57                   	push   %edi
  100714:	56                   	push   %esi
  100715:	53                   	push   %ebx
  100716:	83 ec 1c             	sub    $0x1c,%esp
  100719:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10071c:	8b 45 08             	mov    0x8(%ebp),%eax
  10071f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100722:	85 db                	test   %ebx,%ebx
  100724:	74 04                	je     10072a <printint+0x1a>
  100726:	85 c0                	test   %eax,%eax
  100728:	78 5c                	js     100786 <printint+0x76>
  10072a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  100731:	31 db                	xor    %ebx,%ebx
  100733:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  100736:	66 90                	xchg   %ax,%ax
  100738:	31 d2                	xor    %edx,%edx
  10073a:	f7 f6                	div    %esi
  10073c:	89 c1                	mov    %eax,%ecx
  10073e:	0f b6 82 59 65 10 00 	movzbl 0x106559(%edx),%eax
  100745:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  100748:	83 c3 01             	add    $0x1,%ebx
  10074b:	85 c9                	test   %ecx,%ecx
  10074d:	89 c8                	mov    %ecx,%eax
  10074f:	75 e7                	jne    100738 <printint+0x28>
  100751:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  100754:	85 c9                	test   %ecx,%ecx
  100756:	74 08                	je     100760 <printint+0x50>
  100758:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
  10075d:	83 c3 01             	add    $0x1,%ebx
  100760:	8d 73 ff             	lea    -0x1(%ebx),%esi
  100763:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
  100766:	66 90                	xchg   %ax,%ax
  100768:	0f be 03             	movsbl (%ebx),%eax
  10076b:	83 ee 01             	sub    $0x1,%esi
  10076e:	83 eb 01             	sub    $0x1,%ebx
  100771:	89 04 24             	mov    %eax,(%esp)
  100774:	e8 27 fc ff ff       	call   1003a0 <cons_putc>
  100779:	83 fe ff             	cmp    $0xffffffff,%esi
  10077c:	75 ea                	jne    100768 <printint+0x58>
  10077e:	83 c4 1c             	add    $0x1c,%esp
  100781:	5b                   	pop    %ebx
  100782:	5e                   	pop    %esi
  100783:	5f                   	pop    %edi
  100784:	5d                   	pop    %ebp
  100785:	c3                   	ret    
  100786:	f7 d8                	neg    %eax
  100788:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10078f:	eb a0                	jmp    100731 <printint+0x21>
  100791:	eb 0d                	jmp    1007a0 <cprintf>
  100793:	90                   	nop
  100794:	90                   	nop
  100795:	90                   	nop
  100796:	90                   	nop
  100797:	90                   	nop
  100798:	90                   	nop
  100799:	90                   	nop
  10079a:	90                   	nop
  10079b:	90                   	nop
  10079c:	90                   	nop
  10079d:	90                   	nop
  10079e:	90                   	nop
  10079f:	90                   	nop

001007a0 <cprintf>:
  1007a0:	55                   	push   %ebp
  1007a1:	89 e5                	mov    %esp,%ebp
  1007a3:	57                   	push   %edi
  1007a4:	56                   	push   %esi
  1007a5:	53                   	push   %ebx
  1007a6:	83 ec 1c             	sub    $0x1c,%esp
  1007a9:	a1 24 84 10 00       	mov    0x108424,%eax
  1007ae:	85 c0                	test   %eax,%eax
  1007b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1007b3:	0f 85 8f 01 00 00    	jne    100948 <cprintf+0x1a8>
  1007b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1007bc:	0f b6 02             	movzbl (%edx),%eax
  1007bf:	84 c0                	test   %al,%al
  1007c1:	0f 84 89 00 00 00    	je     100850 <cprintf+0xb0>
  1007c7:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1007ca:	89 d7                	mov    %edx,%edi
  1007cc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  1007cf:	31 f6                	xor    %esi,%esi
  1007d1:	eb 20                	jmp    1007f3 <cprintf+0x53>
  1007d3:	90                   	nop
  1007d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1007d8:	83 fb 25             	cmp    $0x25,%ebx
  1007db:	0f 85 8f 00 00 00    	jne    100870 <cprintf+0xd0>
  1007e1:	be 25 00 00 00       	mov    $0x25,%esi
  1007e6:	66 90                	xchg   %ax,%ax
  1007e8:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  1007ec:	83 c7 01             	add    $0x1,%edi
  1007ef:	84 c0                	test   %al,%al
  1007f1:	74 5d                	je     100850 <cprintf+0xb0>
  1007f3:	85 f6                	test   %esi,%esi
  1007f5:	0f b6 d8             	movzbl %al,%ebx
  1007f8:	74 de                	je     1007d8 <cprintf+0x38>
  1007fa:	83 fe 25             	cmp    $0x25,%esi
  1007fd:	75 e9                	jne    1007e8 <cprintf+0x48>
  1007ff:	83 fb 70             	cmp    $0x70,%ebx
  100802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100808:	0f 84 84 00 00 00    	je     100892 <cprintf+0xf2>
  10080e:	66 90                	xchg   %ax,%ax
  100810:	7f 6e                	jg     100880 <cprintf+0xe0>
  100812:	83 fb 25             	cmp    $0x25,%ebx
  100815:	8d 76 00             	lea    0x0(%esi),%esi
  100818:	0f 84 12 01 00 00    	je     100930 <cprintf+0x190>
  10081e:	83 fb 64             	cmp    $0x64,%ebx
  100821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100828:	0f 84 d2 00 00 00    	je     100900 <cprintf+0x160>
  10082e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100835:	31 f6                	xor    %esi,%esi
  100837:	e8 64 fb ff ff       	call   1003a0 <cons_putc>
  10083c:	89 1c 24             	mov    %ebx,(%esp)
  10083f:	e8 5c fb ff ff       	call   1003a0 <cons_putc>
  100844:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  100848:	83 c7 01             	add    $0x1,%edi
  10084b:	84 c0                	test   %al,%al
  10084d:	75 a4                	jne    1007f3 <cprintf+0x53>
  10084f:	90                   	nop
  100850:	8b 75 ec             	mov    -0x14(%ebp),%esi
  100853:	85 f6                	test   %esi,%esi
  100855:	74 0c                	je     100863 <cprintf+0xc3>
  100857:	c7 04 24 40 84 10 00 	movl   $0x108440,(%esp)
  10085e:	e8 cd 3b 00 00       	call   104430 <release>
  100863:	83 c4 1c             	add    $0x1c,%esp
  100866:	5b                   	pop    %ebx
  100867:	5e                   	pop    %esi
  100868:	5f                   	pop    %edi
  100869:	5d                   	pop    %ebp
  10086a:	c3                   	ret    
  10086b:	90                   	nop
  10086c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100870:	89 1c 24             	mov    %ebx,(%esp)
  100873:	e8 28 fb ff ff       	call   1003a0 <cons_putc>
  100878:	e9 6b ff ff ff       	jmp    1007e8 <cprintf+0x48>
  10087d:	8d 76 00             	lea    0x0(%esi),%esi
  100880:	83 fb 73             	cmp    $0x73,%ebx
  100883:	90                   	nop
  100884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100888:	74 36                	je     1008c0 <cprintf+0x120>
  10088a:	83 fb 78             	cmp    $0x78,%ebx
  10088d:	8d 76 00             	lea    0x0(%esi),%esi
  100890:	75 9c                	jne    10082e <cprintf+0x8e>
  100892:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100895:	31 f6                	xor    %esi,%esi
  100897:	8b 01                	mov    (%ecx),%eax
  100899:	83 c1 04             	add    $0x4,%ecx
  10089c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  10089f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1008a6:	00 
  1008a7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  1008ae:	00 
  1008af:	89 04 24             	mov    %eax,(%esp)
  1008b2:	e8 59 fe ff ff       	call   100710 <printint>
  1008b7:	e9 2c ff ff ff       	jmp    1007e8 <cprintf+0x48>
  1008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1008c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1008c3:	8b 18                	mov    (%eax),%ebx
  1008c5:	83 c0 04             	add    $0x4,%eax
  1008c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1008cb:	85 db                	test   %ebx,%ebx
  1008cd:	0f 84 8a 00 00 00    	je     10095d <cprintf+0x1bd>
  1008d3:	0f b6 03             	movzbl (%ebx),%eax
  1008d6:	84 c0                	test   %al,%al
  1008d8:	74 1b                	je     1008f5 <cprintf+0x155>
  1008da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1008e0:	0f be c0             	movsbl %al,%eax
  1008e3:	83 c3 01             	add    $0x1,%ebx
  1008e6:	89 04 24             	mov    %eax,(%esp)
  1008e9:	e8 b2 fa ff ff       	call   1003a0 <cons_putc>
  1008ee:	0f b6 03             	movzbl (%ebx),%eax
  1008f1:	84 c0                	test   %al,%al
  1008f3:	75 eb                	jne    1008e0 <cprintf+0x140>
  1008f5:	31 f6                	xor    %esi,%esi
  1008f7:	e9 ec fe ff ff       	jmp    1007e8 <cprintf+0x48>
  1008fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100900:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100903:	31 f6                	xor    %esi,%esi
  100905:	8b 02                	mov    (%edx),%eax
  100907:	83 c2 04             	add    $0x4,%edx
  10090a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10090d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  100914:	00 
  100915:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  10091c:	00 
  10091d:	89 04 24             	mov    %eax,(%esp)
  100920:	e8 eb fd ff ff       	call   100710 <printint>
  100925:	e9 be fe ff ff       	jmp    1007e8 <cprintf+0x48>
  10092a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100930:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100937:	31 f6                	xor    %esi,%esi
  100939:	e8 62 fa ff ff       	call   1003a0 <cons_putc>
  10093e:	66 90                	xchg   %ax,%ax
  100940:	e9 a3 fe ff ff       	jmp    1007e8 <cprintf+0x48>
  100945:	8d 76 00             	lea    0x0(%esi),%esi
  100948:	c7 04 24 40 84 10 00 	movl   $0x108440,(%esp)
  10094f:	e8 1c 3b 00 00       	call   104470 <acquire>
  100954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100958:	e9 5c fe ff ff       	jmp    1007b9 <cprintf+0x19>
  10095d:	bb 3f 65 10 00       	mov    $0x10653f,%ebx
  100962:	e9 6c ff ff ff       	jmp    1008d3 <cprintf+0x133>
  100967:	89 f6                	mov    %esi,%esi
  100969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100970 <panic>:
  100970:	55                   	push   %ebp
  100971:	89 e5                	mov    %esp,%ebp
  100973:	53                   	push   %ebx
  100974:	83 ec 44             	sub    $0x44,%esp
  100977:	fa                   	cli    
  100978:	c7 05 24 84 10 00 00 	movl   $0x0,0x108424
  10097f:	00 00 00 
  100982:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
  100985:	e8 a6 1f 00 00       	call   102930 <cpu>
  10098a:	c7 04 24 46 65 10 00 	movl   $0x106546,(%esp)
  100991:	89 44 24 04          	mov    %eax,0x4(%esp)
  100995:	e8 06 fe ff ff       	call   1007a0 <cprintf>
  10099a:	8b 45 08             	mov    0x8(%ebp),%eax
  10099d:	89 04 24             	mov    %eax,(%esp)
  1009a0:	e8 fb fd ff ff       	call   1007a0 <cprintf>
  1009a5:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1009ac:	e8 ef fd ff ff       	call   1007a0 <cprintf>
  1009b1:	8d 45 08             	lea    0x8(%ebp),%eax
  1009b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1009b8:	89 04 24             	mov    %eax,(%esp)
  1009bb:	e8 00 39 00 00       	call   1042c0 <getcallerpcs>
  1009c0:	8b 03                	mov    (%ebx),%eax
  1009c2:	83 c3 04             	add    $0x4,%ebx
  1009c5:	c7 04 24 55 65 10 00 	movl   $0x106555,(%esp)
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	e8 cb fd ff ff       	call   1007a0 <cprintf>
  1009d5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1009d8:	39 c3                	cmp    %eax,%ebx
  1009da:	75 e4                	jne    1009c0 <panic+0x50>
  1009dc:	c7 05 20 84 10 00 01 	movl   $0x1,0x108420
  1009e3:	00 00 00 
  1009e6:	eb fe                	jmp    1009e6 <panic+0x76>
  1009e8:	90                   	nop
  1009e9:	90                   	nop
  1009ea:	90                   	nop
  1009eb:	90                   	nop
  1009ec:	90                   	nop
  1009ed:	90                   	nop
  1009ee:	90                   	nop
  1009ef:	90                   	nop

001009f0 <exec>:
  1009f0:	55                   	push   %ebp
  1009f1:	89 e5                	mov    %esp,%ebp
  1009f3:	57                   	push   %edi
  1009f4:	56                   	push   %esi
  1009f5:	53                   	push   %ebx
  1009f6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  1009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ff:	89 04 24             	mov    %eax,(%esp)
  100a02:	e8 a9 15 00 00       	call   101fb0 <namei>
  100a07:	89 c6                	mov    %eax,%esi
  100a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100a0e:	85 f6                	test   %esi,%esi
  100a10:	74 48                	je     100a5a <exec+0x6a>
  100a12:	89 34 24             	mov    %esi,(%esp)
  100a15:	e8 e6 12 00 00       	call   101d00 <ilock>
  100a1a:	8d 45 a0             	lea    -0x60(%ebp),%eax
  100a1d:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100a24:	00 
  100a25:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100a2c:	00 
  100a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a31:	89 34 24             	mov    %esi,(%esp)
  100a34:	e8 47 0a 00 00       	call   101480 <readi>
  100a39:	83 f8 33             	cmp    $0x33,%eax
  100a3c:	76 09                	jbe    100a47 <exec+0x57>
  100a3e:	81 7d a0 7f 45 4c 46 	cmpl   $0x464c457f,-0x60(%ebp)
  100a45:	74 21                	je     100a68 <exec+0x78>
  100a47:	89 34 24             	mov    %esi,(%esp)
  100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100a50:	e8 8b 12 00 00       	call   101ce0 <iunlockput>
  100a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100a5a:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  100a60:	5b                   	pop    %ebx
  100a61:	5e                   	pop    %esi
  100a62:	5f                   	pop    %edi
  100a63:	5d                   	pop    %ebp
  100a64:	c3                   	ret    
  100a65:	8d 76 00             	lea    0x0(%esi),%esi
  100a68:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100a6d:	8b 7d bc             	mov    -0x44(%ebp),%edi
  100a70:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
  100a77:	74 67                	je     100ae0 <exec+0xf0>
  100a79:	31 db                	xor    %ebx,%ebx
  100a7b:	c7 45 80 00 00 00 00 	movl   $0x0,-0x80(%ebp)
  100a82:	eb 0f                	jmp    100a93 <exec+0xa3>
  100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100a88:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100a8c:	83 c3 01             	add    $0x1,%ebx
  100a8f:	39 d8                	cmp    %ebx,%eax
  100a91:	7e 4d                	jle    100ae0 <exec+0xf0>
  100a93:	89 d8                	mov    %ebx,%eax
  100a95:	c1 e0 05             	shl    $0x5,%eax
  100a98:	01 f8                	add    %edi,%eax
  100a9a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  100a9d:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100aa4:	00 
  100aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aa9:	89 54 24 04          	mov    %edx,0x4(%esp)
  100aad:	89 34 24             	mov    %esi,(%esp)
  100ab0:	e8 cb 09 00 00       	call   101480 <readi>
  100ab5:	83 f8 20             	cmp    $0x20,%eax
  100ab8:	75 8d                	jne    100a47 <exec+0x57>
  100aba:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100abe:	75 c8                	jne    100a88 <exec+0x98>
  100ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ac3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100ac6:	66 90                	xchg   %ax,%ax
  100ac8:	0f 82 79 ff ff ff    	jb     100a47 <exec+0x57>
  100ace:	01 45 80             	add    %eax,-0x80(%ebp)
  100ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ad8:	eb ae                	jmp    100a88 <exec+0x98>
  100ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100ae0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ae3:	31 db                	xor    %ebx,%ebx
  100ae5:	b8 04 00 00 00       	mov    $0x4,%eax
  100aea:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100af1:	00 00 00 
  100af4:	c7 45 88 00 00 00 00 	movl   $0x0,-0x78(%ebp)
  100afb:	8b 11                	mov    (%ecx),%edx
  100afd:	85 d2                	test   %edx,%edx
  100aff:	74 38                	je     100b39 <exec+0x149>
  100b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100b08:	89 14 24             	mov    %edx,(%esp)
  100b0b:	e8 b0 3b 00 00       	call   1046c0 <strlen>
  100b10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b13:	83 85 7c ff ff ff 01 	addl   $0x1,-0x84(%ebp)
  100b1a:	8b bd 7c ff ff ff    	mov    -0x84(%ebp),%edi
  100b20:	8b 14 b9             	mov    (%ecx,%edi,4),%edx
  100b23:	01 d8                	add    %ebx,%eax
  100b25:	8d 58 01             	lea    0x1(%eax),%ebx
  100b28:	85 d2                	test   %edx,%edx
  100b2a:	75 dc                	jne    100b08 <exec+0x118>
  100b2c:	83 c0 04             	add    $0x4,%eax
  100b2f:	83 e0 fc             	and    $0xfffffffc,%eax
  100b32:	89 45 88             	mov    %eax,-0x78(%ebp)
  100b35:	8d 44 b8 04          	lea    0x4(%eax,%edi,4),%eax
  100b39:	8b 7d 80             	mov    -0x80(%ebp),%edi
  100b3c:	8d 84 38 ff 1f 00 00 	lea    0x1fff(%eax,%edi,1),%eax
  100b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100b48:	89 45 8c             	mov    %eax,-0x74(%ebp)
  100b4b:	89 04 24             	mov    %eax,(%esp)
  100b4e:	e8 2d 18 00 00       	call   102380 <kalloc>
  100b53:	85 c0                	test   %eax,%eax
  100b55:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  100b5b:	0f 84 e6 fe ff ff    	je     100a47 <exec+0x57>
  100b61:	8b 45 8c             	mov    -0x74(%ebp),%eax
  100b64:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  100b6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b71:	00 
  100b72:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b76:	89 14 24             	mov    %edx,(%esp)
  100b79:	e8 62 39 00 00       	call   1044e0 <memset>
  100b7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  100b81:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100b86:	0f 84 be 00 00 00    	je     100c4a <exec+0x25a>
  100b8c:	89 c7                	mov    %eax,%edi
  100b8e:	31 db                	xor    %ebx,%ebx
  100b90:	eb 18                	jmp    100baa <exec+0x1ba>
  100b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100b98:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100b9c:	83 c3 01             	add    $0x1,%ebx
  100b9f:	39 d8                	cmp    %ebx,%eax
  100ba1:	0f 8e a3 00 00 00    	jle    100c4a <exec+0x25a>
  100ba7:	83 c7 20             	add    $0x20,%edi
  100baa:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  100bad:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100bb4:	00 
  100bb5:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100bb9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bbd:	89 34 24             	mov    %esi,(%esp)
  100bc0:	e8 bb 08 00 00       	call   101480 <readi>
  100bc5:	83 f8 20             	cmp    $0x20,%eax
  100bc8:	75 66                	jne    100c30 <exec+0x240>
  100bca:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100bce:	75 c8                	jne    100b98 <exec+0x1a8>
  100bd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100bd3:	89 d0                	mov    %edx,%eax
  100bd5:	03 45 e8             	add    -0x18(%ebp),%eax
  100bd8:	39 45 8c             	cmp    %eax,-0x74(%ebp)
  100bdb:	72 53                	jb     100c30 <exec+0x240>
  100bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100be0:	89 34 24             	mov    %esi,(%esp)
  100be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100be7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100bea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100bee:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100bf4:	01 d0                	add    %edx,%eax
  100bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bfa:	e8 81 08 00 00       	call   101480 <readi>
  100bff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100c02:	89 c2                	mov    %eax,%edx
  100c04:	75 2a                	jne    100c30 <exec+0x240>
  100c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100c09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100c10:	00 
  100c11:	29 d0                	sub    %edx,%eax
  100c13:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c17:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100c1d:	03 55 dc             	add    -0x24(%ebp),%edx
  100c20:	01 d0                	add    %edx,%eax
  100c22:	89 04 24             	mov    %eax,(%esp)
  100c25:	e8 b6 38 00 00       	call   1044e0 <memset>
  100c2a:	e9 69 ff ff ff       	jmp    100b98 <exec+0x1a8>
  100c2f:	90                   	nop
  100c30:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
  100c33:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100c39:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c3d:	89 3c 24             	mov    %edi,(%esp)
  100c40:	e8 fb 17 00 00       	call   102440 <kfree>
  100c45:	e9 fd fd ff ff       	jmp    100a47 <exec+0x57>
  100c4a:	89 34 24             	mov    %esi,(%esp)
  100c4d:	e8 8e 10 00 00       	call   101ce0 <iunlockput>
  100c52:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  100c58:	8b 45 8c             	mov    -0x74(%ebp),%eax
  100c5b:	2b 45 88             	sub    -0x78(%ebp),%eax
  100c5e:	8b bd 7c ff ff ff    	mov    -0x84(%ebp),%edi
  100c64:	f7 d2                	not    %edx
  100c66:	8d 14 90             	lea    (%eax,%edx,4),%edx
  100c69:	89 55 84             	mov    %edx,-0x7c(%ebp)
  100c6c:	8d 04 ba             	lea    (%edx,%edi,4),%eax
  100c6f:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  100c75:	83 ef 01             	sub    $0x1,%edi
  100c78:	83 ff ff             	cmp    $0xffffffff,%edi
  100c7b:	89 7d 90             	mov    %edi,-0x70(%ebp)
  100c7e:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
  100c85:	74 54                	je     100cdb <exec+0x2eb>
  100c87:	8b 75 0c             	mov    0xc(%ebp),%esi
  100c8a:	89 f8                	mov    %edi,%eax
  100c8c:	89 d7                	mov    %edx,%edi
  100c8e:	c1 e0 02             	shl    $0x2,%eax
  100c91:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  100c94:	01 c6                	add    %eax,%esi
  100c96:	03 45 84             	add    -0x7c(%ebp),%eax
  100c99:	01 c7                	add    %eax,%edi
  100c9b:	90                   	nop
  100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100ca0:	8b 06                	mov    (%esi),%eax
  100ca2:	89 04 24             	mov    %eax,(%esp)
  100ca5:	e8 16 3a 00 00       	call   1046c0 <strlen>
  100caa:	83 c0 01             	add    $0x1,%eax
  100cad:	29 c3                	sub    %eax,%ebx
  100caf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb3:	8b 06                	mov    (%esi),%eax
  100cb5:	83 ee 04             	sub    $0x4,%esi
  100cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbc:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100cc2:	01 d8                	add    %ebx,%eax
  100cc4:	89 04 24             	mov    %eax,(%esp)
  100cc7:	e8 a4 38 00 00       	call   104570 <memmove>
  100ccc:	83 6d 90 01          	subl   $0x1,-0x70(%ebp)
  100cd0:	89 1f                	mov    %ebx,(%edi)
  100cd2:	83 ef 04             	sub    $0x4,%edi
  100cd5:	83 7d 90 ff          	cmpl   $0xffffffff,-0x70(%ebp)
  100cd9:	75 c5                	jne    100ca0 <exec+0x2b0>
  100cdb:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100cde:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100ce4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  100cea:	89 ce                	mov    %ecx,%esi
  100cec:	89 4c 0f fc          	mov    %ecx,-0x4(%edi,%ecx,1)
  100cf0:	83 ee 0c             	sub    $0xc,%esi
  100cf3:	89 44 0f f8          	mov    %eax,-0x8(%edi,%ecx,1)
  100cf7:	c7 44 0f f4 ff ff ff 	movl   $0xffffffff,-0xc(%edi,%ecx,1)
  100cfe:	ff 
  100cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100d02:	0f b6 11             	movzbl (%ecx),%edx
  100d05:	89 cb                	mov    %ecx,%ebx
  100d07:	84 d2                	test   %dl,%dl
  100d09:	74 20                	je     100d2b <exec+0x33b>
  100d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100d11:	83 c0 01             	add    $0x1,%eax
  100d14:	eb 0c                	jmp    100d22 <exec+0x332>
  100d16:	66 90                	xchg   %ax,%ax
  100d18:	0f b6 10             	movzbl (%eax),%edx
  100d1b:	83 c0 01             	add    $0x1,%eax
  100d1e:	84 d2                	test   %dl,%dl
  100d20:	74 09                	je     100d2b <exec+0x33b>
  100d22:	80 fa 2f             	cmp    $0x2f,%dl
  100d25:	75 f1                	jne    100d18 <exec+0x328>
  100d27:	89 c3                	mov    %eax,%ebx
  100d29:	eb ed                	jmp    100d18 <exec+0x328>
  100d2b:	90                   	nop
  100d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100d30:	e8 5b 27 00 00       	call   103490 <curproc>
  100d35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d39:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100d40:	00 
  100d41:	05 88 00 00 00       	add    $0x88,%eax
  100d46:	89 04 24             	mov    %eax,(%esp)
  100d49:	e8 32 39 00 00       	call   104680 <safestrcpy>
  100d4e:	e8 3d 27 00 00       	call   103490 <curproc>
  100d53:	8b 58 04             	mov    0x4(%eax),%ebx
  100d56:	e8 35 27 00 00       	call   103490 <curproc>
  100d5b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100d5f:	8b 00                	mov    (%eax),%eax
  100d61:	89 04 24             	mov    %eax,(%esp)
  100d64:	e8 d7 16 00 00       	call   102440 <kfree>
  100d69:	e8 22 27 00 00       	call   103490 <curproc>
  100d6e:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100d74:	89 38                	mov    %edi,(%eax)
  100d76:	e8 15 27 00 00       	call   103490 <curproc>
  100d7b:	8b 55 8c             	mov    -0x74(%ebp),%edx
  100d7e:	89 50 04             	mov    %edx,0x4(%eax)
  100d81:	e8 0a 27 00 00       	call   103490 <curproc>
  100d86:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d8f:	89 42 30             	mov    %eax,0x30(%edx)
  100d92:	e8 f9 26 00 00       	call   103490 <curproc>
  100d97:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d9d:	89 70 3c             	mov    %esi,0x3c(%eax)
  100da0:	e8 eb 26 00 00       	call   103490 <curproc>
  100da5:	89 04 24             	mov    %eax,(%esp)
  100da8:	e8 53 2c 00 00       	call   103a00 <setupsegs>
  100dad:	31 c0                	xor    %eax,%eax
  100daf:	e9 a6 fc ff ff       	jmp    100a5a <exec+0x6a>
  100db4:	90                   	nop
  100db5:	90                   	nop
  100db6:	90                   	nop
  100db7:	90                   	nop
  100db8:	90                   	nop
  100db9:	90                   	nop
  100dba:	90                   	nop
  100dbb:	90                   	nop
  100dbc:	90                   	nop
  100dbd:	90                   	nop
  100dbe:	90                   	nop
  100dbf:	90                   	nop

00100dc0 <filewrite>:
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 28             	sub    $0x28,%esp
  100dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100dcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100dcf:	8b 75 10             	mov    0x10(%ebp),%esi
  100dd2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100dd5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100dd8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100ddc:	74 5a                	je     100e38 <filewrite+0x78>
  100dde:	8b 03                	mov    (%ebx),%eax
  100de0:	83 f8 02             	cmp    $0x2,%eax
  100de3:	74 5b                	je     100e40 <filewrite+0x80>
  100de5:	83 f8 03             	cmp    $0x3,%eax
  100de8:	75 6d                	jne    100e57 <filewrite+0x97>
  100dea:	8b 43 10             	mov    0x10(%ebx),%eax
  100ded:	89 04 24             	mov    %eax,(%esp)
  100df0:	e8 0b 0f 00 00       	call   101d00 <ilock>
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 11 08 00 00       	call   101620 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 5d 0e 00 00       	call   101c80 <iunlock>
  100e23:	89 f0                	mov    %esi,%eax
  100e25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e28:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e2b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e2e:	89 ec                	mov    %ebp,%esp
  100e30:	5d                   	pop    %ebp
  100e31:	c3                   	ret    
  100e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e38:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100e3d:	eb e4                	jmp    100e23 <filewrite+0x63>
  100e3f:	90                   	nop
  100e40:	8b 43 0c             	mov    0xc(%ebx),%eax
  100e43:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e49:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e4c:	89 45 08             	mov    %eax,0x8(%ebp)
  100e4f:	89 ec                	mov    %ebp,%esp
  100e51:	5d                   	pop    %ebp
  100e52:	e9 39 21 00 00       	jmp    102f90 <pipewrite>
  100e57:	c7 04 24 6a 65 10 00 	movl   $0x10656a,(%esp)
  100e5e:	e8 0d fb ff ff       	call   100970 <panic>
  100e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100e70 <fileread>:
  100e70:	55                   	push   %ebp
  100e71:	89 e5                	mov    %esp,%ebp
  100e73:	83 ec 28             	sub    $0x28,%esp
  100e76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100e7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100e7f:	8b 75 10             	mov    0x10(%ebp),%esi
  100e82:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100e85:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100e88:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100e8c:	74 5a                	je     100ee8 <fileread+0x78>
  100e8e:	8b 03                	mov    (%ebx),%eax
  100e90:	83 f8 02             	cmp    $0x2,%eax
  100e93:	74 5b                	je     100ef0 <fileread+0x80>
  100e95:	83 f8 03             	cmp    $0x3,%eax
  100e98:	75 6d                	jne    100f07 <fileread+0x97>
  100e9a:	8b 43 10             	mov    0x10(%ebx),%eax
  100e9d:	89 04 24             	mov    %eax,(%esp)
  100ea0:	e8 5b 0e 00 00       	call   101d00 <ilock>
  100ea5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100ea9:	8b 43 14             	mov    0x14(%ebx),%eax
  100eac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100eb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100eb4:	8b 43 10             	mov    0x10(%ebx),%eax
  100eb7:	89 04 24             	mov    %eax,(%esp)
  100eba:	e8 c1 05 00 00       	call   101480 <readi>
  100ebf:	85 c0                	test   %eax,%eax
  100ec1:	89 c6                	mov    %eax,%esi
  100ec3:	7e 03                	jle    100ec8 <fileread+0x58>
  100ec5:	01 43 14             	add    %eax,0x14(%ebx)
  100ec8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ecb:	89 04 24             	mov    %eax,(%esp)
  100ece:	e8 ad 0d 00 00       	call   101c80 <iunlock>
  100ed3:	89 f0                	mov    %esi,%eax
  100ed5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ed8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100edb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100ede:	89 ec                	mov    %ebp,%esp
  100ee0:	5d                   	pop    %ebp
  100ee1:	c3                   	ret    
  100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100ee8:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100eed:	eb e4                	jmp    100ed3 <fileread+0x63>
  100eef:	90                   	nop
  100ef0:	8b 43 0c             	mov    0xc(%ebx),%eax
  100ef3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100ef6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ef9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100efc:	89 45 08             	mov    %eax,0x8(%ebp)
  100eff:	89 ec                	mov    %ebp,%esp
  100f01:	5d                   	pop    %ebp
  100f02:	e9 a9 1f 00 00       	jmp    102eb0 <piperead>
  100f07:	c7 04 24 74 65 10 00 	movl   $0x106574,(%esp)
  100f0e:	e8 5d fa ff ff       	call   100970 <panic>
  100f13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100f20 <filestat>:
  100f20:	55                   	push   %ebp
  100f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100f26:	89 e5                	mov    %esp,%ebp
  100f28:	53                   	push   %ebx
  100f29:	83 ec 14             	sub    $0x14,%esp
  100f2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f2f:	83 3b 03             	cmpl   $0x3,(%ebx)
  100f32:	74 0c                	je     100f40 <filestat+0x20>
  100f34:	83 c4 14             	add    $0x14,%esp
  100f37:	5b                   	pop    %ebx
  100f38:	5d                   	pop    %ebp
  100f39:	c3                   	ret    
  100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100f40:	8b 43 10             	mov    0x10(%ebx),%eax
  100f43:	89 04 24             	mov    %eax,(%esp)
  100f46:	e8 b5 0d 00 00       	call   101d00 <ilock>
  100f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f52:	8b 43 10             	mov    0x10(%ebx),%eax
  100f55:	89 04 24             	mov    %eax,(%esp)
  100f58:	e8 d3 01 00 00       	call   101130 <stati>
  100f5d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f60:	89 04 24             	mov    %eax,(%esp)
  100f63:	e8 18 0d 00 00       	call   101c80 <iunlock>
  100f68:	83 c4 14             	add    $0x14,%esp
  100f6b:	31 c0                	xor    %eax,%eax
  100f6d:	5b                   	pop    %ebx
  100f6e:	5d                   	pop    %ebp
  100f6f:	c3                   	ret    

00100f70 <filedup>:
  100f70:	55                   	push   %ebp
  100f71:	89 e5                	mov    %esp,%ebp
  100f73:	53                   	push   %ebx
  100f74:	83 ec 04             	sub    $0x4,%esp
  100f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f7a:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  100f81:	e8 ea 34 00 00       	call   104470 <acquire>
  100f86:	8b 43 04             	mov    0x4(%ebx),%eax
  100f89:	85 c0                	test   %eax,%eax
  100f8b:	7e 06                	jle    100f93 <filedup+0x23>
  100f8d:	8b 13                	mov    (%ebx),%edx
  100f8f:	85 d2                	test   %edx,%edx
  100f91:	75 0d                	jne    100fa0 <filedup+0x30>
  100f93:	c7 04 24 7d 65 10 00 	movl   $0x10657d,(%esp)
  100f9a:	e8 d1 f9 ff ff       	call   100970 <panic>
  100f9f:	90                   	nop
  100fa0:	83 c0 01             	add    $0x1,%eax
  100fa3:	89 43 04             	mov    %eax,0x4(%ebx)
  100fa6:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  100fad:	e8 7e 34 00 00       	call   104430 <release>
  100fb2:	89 d8                	mov    %ebx,%eax
  100fb4:	83 c4 04             	add    $0x4,%esp
  100fb7:	5b                   	pop    %ebx
  100fb8:	5d                   	pop    %ebp
  100fb9:	c3                   	ret    
  100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100fc0 <filealloc>:
  100fc0:	55                   	push   %ebp
  100fc1:	89 e5                	mov    %esp,%ebp
  100fc3:	53                   	push   %ebx
  100fc4:	83 ec 04             	sub    $0x4,%esp
  100fc7:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  100fce:	e8 9d 34 00 00       	call   104470 <acquire>
  100fd3:	ba 00 9d 10 00       	mov    $0x109d00,%edx
  100fd8:	31 c0                	xor    %eax,%eax
  100fda:	eb 0f                	jmp    100feb <filealloc+0x2b>
  100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100fe0:	83 c0 01             	add    $0x1,%eax
  100fe3:	83 c2 18             	add    $0x18,%edx
  100fe6:	83 f8 64             	cmp    $0x64,%eax
  100fe9:	74 3d                	je     101028 <filealloc+0x68>
  100feb:	8b 0a                	mov    (%edx),%ecx
  100fed:	85 c9                	test   %ecx,%ecx
  100fef:	75 ef                	jne    100fe0 <filealloc+0x20>
  100ff1:	8d 04 40             	lea    (%eax,%eax,2),%eax
  100ff4:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100ffb:	c7 04 c5 00 9d 10 00 	movl   $0x1,0x109d00(,%eax,8)
  101002:	01 00 00 00 
  101006:	c7 83 04 9d 10 00 01 	movl   $0x1,0x109d04(%ebx)
  10100d:	00 00 00 
  101010:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101017:	e8 14 34 00 00       	call   104430 <release>
  10101c:	8d 83 00 9d 10 00    	lea    0x109d00(%ebx),%eax
  101022:	83 c4 04             	add    $0x4,%esp
  101025:	5b                   	pop    %ebx
  101026:	5d                   	pop    %ebp
  101027:	c3                   	ret    
  101028:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  10102f:	e8 fc 33 00 00       	call   104430 <release>
  101034:	83 c4 04             	add    $0x4,%esp
  101037:	31 c0                	xor    %eax,%eax
  101039:	5b                   	pop    %ebx
  10103a:	5d                   	pop    %ebp
  10103b:	c3                   	ret    
  10103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101040 <fileclose>:
  101040:	55                   	push   %ebp
  101041:	89 e5                	mov    %esp,%ebp
  101043:	83 ec 28             	sub    $0x28,%esp
  101046:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10104c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10104f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101052:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101059:	e8 12 34 00 00       	call   104470 <acquire>
  10105e:	8b 43 04             	mov    0x4(%ebx),%eax
  101061:	85 c0                	test   %eax,%eax
  101063:	7e 2b                	jle    101090 <fileclose+0x50>
  101065:	8b 33                	mov    (%ebx),%esi
  101067:	85 f6                	test   %esi,%esi
  101069:	74 25                	je     101090 <fileclose+0x50>
  10106b:	83 e8 01             	sub    $0x1,%eax
  10106e:	85 c0                	test   %eax,%eax
  101070:	89 43 04             	mov    %eax,0x4(%ebx)
  101073:	74 2b                	je     1010a0 <fileclose+0x60>
  101075:	c7 45 08 60 a6 10 00 	movl   $0x10a660,0x8(%ebp)
  10107c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10107f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101082:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101085:	89 ec                	mov    %ebp,%esp
  101087:	5d                   	pop    %ebp
  101088:	e9 a3 33 00 00       	jmp    104430 <release>
  10108d:	8d 76 00             	lea    0x0(%esi),%esi
  101090:	c7 04 24 85 65 10 00 	movl   $0x106585,(%esp)
  101097:	e8 d4 f8 ff ff       	call   100970 <panic>
  10109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
  1010a3:	8b 33                	mov    (%ebx),%esi
  1010a5:	8b 7b 10             	mov    0x10(%ebx),%edi
  1010a8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  1010af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1010b2:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  1010b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  1010bc:	88 45 f3             	mov    %al,-0xd(%ebp)
  1010bf:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  1010c6:	e8 65 33 00 00       	call   104430 <release>
  1010cb:	83 fe 02             	cmp    $0x2,%esi
  1010ce:	74 20                	je     1010f0 <fileclose+0xb0>
  1010d0:	83 fe 03             	cmp    $0x3,%esi
  1010d3:	75 bb                	jne    101090 <fileclose+0x50>
  1010d5:	89 7d 08             	mov    %edi,0x8(%ebp)
  1010d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1010db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1010de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1010e1:	89 ec                	mov    %ebp,%esp
  1010e3:	5d                   	pop    %ebp
  1010e4:	e9 47 09 00 00       	jmp    101a30 <iput>
  1010e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1010f0:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010fb:	89 04 24             	mov    %eax,(%esp)
  1010fe:	e8 8d 1f 00 00       	call   103090 <pipeclose>
  101103:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101106:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101109:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10110c:	89 ec                	mov    %ebp,%esp
  10110e:	5d                   	pop    %ebp
  10110f:	c3                   	ret    

00101110 <fileinit>:
  101110:	55                   	push   %ebp
  101111:	89 e5                	mov    %esp,%ebp
  101113:	83 ec 08             	sub    $0x8,%esp
  101116:	c7 44 24 04 8f 65 10 	movl   $0x10658f,0x4(%esp)
  10111d:	00 
  10111e:	c7 04 24 60 a6 10 00 	movl   $0x10a660,(%esp)
  101125:	e8 76 31 00 00       	call   1042a0 <initlock>
  10112a:	c9                   	leave  
  10112b:	c3                   	ret    
  10112c:	90                   	nop
  10112d:	90                   	nop
  10112e:	90                   	nop
  10112f:	90                   	nop

00101130 <stati>:
  101130:	55                   	push   %ebp
  101131:	89 e5                	mov    %esp,%ebp
  101133:	8b 55 08             	mov    0x8(%ebp),%edx
  101136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  101139:	8b 02                	mov    (%edx),%eax
  10113b:	89 01                	mov    %eax,(%ecx)
  10113d:	8b 42 04             	mov    0x4(%edx),%eax
  101140:	89 41 04             	mov    %eax,0x4(%ecx)
  101143:	0f b7 42 10          	movzwl 0x10(%edx),%eax
  101147:	66 89 41 08          	mov    %ax,0x8(%ecx)
  10114b:	0f b7 42 16          	movzwl 0x16(%edx),%eax
  10114f:	66 89 41 0a          	mov    %ax,0xa(%ecx)
  101153:	8b 42 18             	mov    0x18(%edx),%eax
  101156:	89 41 0c             	mov    %eax,0xc(%ecx)
  101159:	5d                   	pop    %ebp
  10115a:	c3                   	ret    
  10115b:	90                   	nop
  10115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101160 <idup>:
  101160:	55                   	push   %ebp
  101161:	89 e5                	mov    %esp,%ebp
  101163:	53                   	push   %ebx
  101164:	83 ec 04             	sub    $0x4,%esp
  101167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10116a:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101171:	e8 fa 32 00 00       	call   104470 <acquire>
  101176:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  10117a:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101181:	e8 aa 32 00 00       	call   104430 <release>
  101186:	89 d8                	mov    %ebx,%eax
  101188:	83 c4 04             	add    $0x4,%esp
  10118b:	5b                   	pop    %ebx
  10118c:	5d                   	pop    %ebp
  10118d:	c3                   	ret    
  10118e:	66 90                	xchg   %ax,%ax

00101190 <iget>:
  101190:	55                   	push   %ebp
  101191:	89 e5                	mov    %esp,%ebp
  101193:	57                   	push   %edi
  101194:	89 c7                	mov    %eax,%edi
  101196:	56                   	push   %esi
  101197:	31 f6                	xor    %esi,%esi
  101199:	53                   	push   %ebx
  10119a:	bb 34 a7 10 00       	mov    $0x10a734,%ebx
  10119f:	83 ec 0c             	sub    $0xc,%esp
  1011a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1011a5:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  1011ac:	e8 bf 32 00 00       	call   104470 <acquire>
  1011b1:	eb 17                	jmp    1011ca <iget+0x3a>
  1011b3:	90                   	nop
  1011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1011b8:	85 f6                	test   %esi,%esi
  1011ba:	74 44                	je     101200 <iget+0x70>
  1011bc:	83 c3 50             	add    $0x50,%ebx
  1011bf:	81 fb d4 b6 10 00    	cmp    $0x10b6d4,%ebx
  1011c5:	8d 76 00             	lea    0x0(%esi),%esi
  1011c8:	74 4e                	je     101218 <iget+0x88>
  1011ca:	8b 43 08             	mov    0x8(%ebx),%eax
  1011cd:	85 c0                	test   %eax,%eax
  1011cf:	7e e7                	jle    1011b8 <iget+0x28>
  1011d1:	39 3b                	cmp    %edi,(%ebx)
  1011d3:	75 e3                	jne    1011b8 <iget+0x28>
  1011d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1011d8:	39 53 04             	cmp    %edx,0x4(%ebx)
  1011db:	75 db                	jne    1011b8 <iget+0x28>
  1011dd:	83 c0 01             	add    $0x1,%eax
  1011e0:	89 43 08             	mov    %eax,0x8(%ebx)
  1011e3:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  1011ea:	e8 41 32 00 00       	call   104430 <release>
  1011ef:	83 c4 0c             	add    $0xc,%esp
  1011f2:	89 d8                	mov    %ebx,%eax
  1011f4:	5b                   	pop    %ebx
  1011f5:	5e                   	pop    %esi
  1011f6:	5f                   	pop    %edi
  1011f7:	5d                   	pop    %ebp
  1011f8:	c3                   	ret    
  1011f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101200:	85 c0                	test   %eax,%eax
  101202:	75 b8                	jne    1011bc <iget+0x2c>
  101204:	89 de                	mov    %ebx,%esi
  101206:	83 c3 50             	add    $0x50,%ebx
  101209:	81 fb d4 b6 10 00    	cmp    $0x10b6d4,%ebx
  10120f:	75 b9                	jne    1011ca <iget+0x3a>
  101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101218:	85 f6                	test   %esi,%esi
  10121a:	74 2e                	je     10124a <iget+0xba>
  10121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10121f:	89 f3                	mov    %esi,%ebx
  101221:	89 3e                	mov    %edi,(%esi)
  101223:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  10122a:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  101231:	89 46 04             	mov    %eax,0x4(%esi)
  101234:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  10123b:	e8 f0 31 00 00       	call   104430 <release>
  101240:	83 c4 0c             	add    $0xc,%esp
  101243:	89 d8                	mov    %ebx,%eax
  101245:	5b                   	pop    %ebx
  101246:	5e                   	pop    %esi
  101247:	5f                   	pop    %edi
  101248:	5d                   	pop    %ebp
  101249:	c3                   	ret    
  10124a:	c7 04 24 9a 65 10 00 	movl   $0x10659a,(%esp)
  101251:	e8 1a f7 ff ff       	call   100970 <panic>
  101256:	8d 76 00             	lea    0x0(%esi),%esi
  101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101260 <readsb>:
  101260:	55                   	push   %ebp
  101261:	89 e5                	mov    %esp,%ebp
  101263:	83 ec 18             	sub    $0x18,%esp
  101266:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10126d:	00 
  10126e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101271:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101274:	89 d6                	mov    %edx,%esi
  101276:	89 04 24             	mov    %eax,(%esp)
  101279:	e8 32 ee ff ff       	call   1000b0 <bread>
  10127e:	89 34 24             	mov    %esi,(%esp)
  101281:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101288:	00 
  101289:	89 c3                	mov    %eax,%ebx
  10128b:	8d 40 18             	lea    0x18(%eax),%eax
  10128e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101292:	e8 d9 32 00 00       	call   104570 <memmove>
  101297:	89 1c 24             	mov    %ebx,(%esp)
  10129a:	e8 61 ed ff ff       	call   100000 <brelse>
  10129f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1012a2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1012a5:	89 ec                	mov    %ebp,%esp
  1012a7:	5d                   	pop    %ebp
  1012a8:	c3                   	ret    
  1012a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001012b0 <balloc>:
  1012b0:	55                   	push   %ebp
  1012b1:	89 e5                	mov    %esp,%ebp
  1012b3:	57                   	push   %edi
  1012b4:	56                   	push   %esi
  1012b5:	53                   	push   %ebx
  1012b6:	83 ec 2c             	sub    $0x2c,%esp
  1012b9:	8d 55 e8             	lea    -0x18(%ebp),%edx
  1012bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1012bf:	e8 9c ff ff ff       	call   101260 <readsb>
  1012c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1012c7:	85 c0                	test   %eax,%eax
  1012c9:	0f 84 9c 00 00 00    	je     10136b <balloc+0xbb>
  1012cf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1012d9:	31 db                	xor    %ebx,%ebx
  1012db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1012de:	c1 e8 03             	shr    $0x3,%eax
  1012e1:	c1 fa 0c             	sar    $0xc,%edx
  1012e4:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1012e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1012ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1012ef:	89 04 24             	mov    %eax,(%esp)
  1012f2:	e8 b9 ed ff ff       	call   1000b0 <bread>
  1012f7:	89 c7                	mov    %eax,%edi
  1012f9:	eb 10                	jmp    10130b <balloc+0x5b>
  1012fb:	90                   	nop
  1012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101300:	83 c3 01             	add    $0x1,%ebx
  101303:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  101309:	74 45                	je     101350 <balloc+0xa0>
  10130b:	89 d9                	mov    %ebx,%ecx
  10130d:	ba 01 00 00 00       	mov    $0x1,%edx
  101312:	83 e1 07             	and    $0x7,%ecx
  101315:	89 de                	mov    %ebx,%esi
  101317:	d3 e2                	shl    %cl,%edx
  101319:	c1 fe 03             	sar    $0x3,%esi
  10131c:	89 d1                	mov    %edx,%ecx
  10131e:	0f b6 54 37 18       	movzbl 0x18(%edi,%esi,1),%edx
  101323:	0f b6 c2             	movzbl %dl,%eax
  101326:	85 c8                	test   %ecx,%eax
  101328:	75 d6                	jne    101300 <balloc+0x50>
  10132a:	09 ca                	or     %ecx,%edx
  10132c:	88 54 37 18          	mov    %dl,0x18(%edi,%esi,1)
  101330:	89 3c 24             	mov    %edi,(%esp)
  101333:	e8 48 ed ff ff       	call   100080 <bwrite>
  101338:	89 3c 24             	mov    %edi,(%esp)
  10133b:	e8 c0 ec ff ff       	call   100000 <brelse>
  101340:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101343:	83 c4 2c             	add    $0x2c,%esp
  101346:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101349:	5b                   	pop    %ebx
  10134a:	5e                   	pop    %esi
  10134b:	5f                   	pop    %edi
  10134c:	5d                   	pop    %ebp
  10134d:	c3                   	ret    
  10134e:	66 90                	xchg   %ax,%ax
  101350:	89 3c 24             	mov    %edi,(%esp)
  101353:	e8 a8 ec ff ff       	call   100000 <brelse>
  101358:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  10135f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101362:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  101365:	0f 87 6b ff ff ff    	ja     1012d6 <balloc+0x26>
  10136b:	c7 04 24 aa 65 10 00 	movl   $0x1065aa,(%esp)
  101372:	e8 f9 f5 ff ff       	call   100970 <panic>
  101377:	89 f6                	mov    %esi,%esi
  101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101380 <bmap>:
  101380:	55                   	push   %ebp
  101381:	89 e5                	mov    %esp,%ebp
  101383:	83 ec 28             	sub    $0x28,%esp
  101386:	83 fa 0b             	cmp    $0xb,%edx
  101389:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10138c:	89 c6                	mov    %eax,%esi
  10138e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101391:	89 cf                	mov    %ecx,%edi
  101393:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101396:	77 38                	ja     1013d0 <bmap+0x50>
  101398:	83 c2 04             	add    $0x4,%edx
  10139b:	8b 5c 90 0c          	mov    0xc(%eax,%edx,4),%ebx
  10139f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1013a2:	85 db                	test   %ebx,%ebx
  1013a4:	75 1a                	jne    1013c0 <bmap+0x40>
  1013a6:	85 c9                	test   %ecx,%ecx
  1013a8:	74 3d                	je     1013e7 <bmap+0x67>
  1013aa:	8b 00                	mov    (%eax),%eax
  1013ac:	e8 ff fe ff ff       	call   1012b0 <balloc>
  1013b1:	89 c3                	mov    %eax,%ebx
  1013b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1013b6:	89 5c 86 0c          	mov    %ebx,0xc(%esi,%eax,4)
  1013ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1013c0:	89 d8                	mov    %ebx,%eax
  1013c2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1013c5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1013c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1013cb:	89 ec                	mov    %ebp,%esp
  1013cd:	5d                   	pop    %ebp
  1013ce:	c3                   	ret    
  1013cf:	90                   	nop
  1013d0:	8d 5a f4             	lea    -0xc(%edx),%ebx
  1013d3:	83 fb 7f             	cmp    $0x7f,%ebx
  1013d6:	0f 87 8d 00 00 00    	ja     101469 <bmap+0xe9>
  1013dc:	8b 40 4c             	mov    0x4c(%eax),%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 25                	jne    101408 <bmap+0x88>
  1013e3:	85 c9                	test   %ecx,%ecx
  1013e5:	75 11                	jne    1013f8 <bmap+0x78>
  1013e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1013f0:	eb ce                	jmp    1013c0 <bmap+0x40>
  1013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1013f8:	8b 06                	mov    (%esi),%eax
  1013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101400:	e8 ab fe ff ff       	call   1012b0 <balloc>
  101405:	89 46 4c             	mov    %eax,0x4c(%esi)
  101408:	89 44 24 04          	mov    %eax,0x4(%esp)
  10140c:	8b 06                	mov    (%esi),%eax
  10140e:	89 04 24             	mov    %eax,(%esp)
  101411:	e8 9a ec ff ff       	call   1000b0 <bread>
  101416:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx
  10141a:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  10141d:	8b 1b                	mov    (%ebx),%ebx
  10141f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101422:	85 db                	test   %ebx,%ebx
  101424:	75 33                	jne    101459 <bmap+0xd9>
  101426:	85 ff                	test   %edi,%edi
  101428:	75 16                	jne    101440 <bmap+0xc0>
  10142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10142d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  101432:	89 04 24             	mov    %eax,(%esp)
  101435:	e8 c6 eb ff ff       	call   100000 <brelse>
  10143a:	eb 84                	jmp    1013c0 <bmap+0x40>
  10143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101440:	8b 06                	mov    (%esi),%eax
  101442:	e8 69 fe ff ff       	call   1012b0 <balloc>
  101447:	89 c3                	mov    %eax,%ebx
  101449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10144c:	89 18                	mov    %ebx,(%eax)
  10144e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101451:	89 04 24             	mov    %eax,(%esp)
  101454:	e8 27 ec ff ff       	call   100080 <bwrite>
  101459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10145c:	89 04 24             	mov    %eax,(%esp)
  10145f:	e8 9c eb ff ff       	call   100000 <brelse>
  101464:	e9 57 ff ff ff       	jmp    1013c0 <bmap+0x40>
  101469:	c7 04 24 c0 65 10 00 	movl   $0x1065c0,(%esp)
  101470:	e8 fb f4 ff ff       	call   100970 <panic>
  101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101480 <readi>:
  101480:	55                   	push   %ebp
  101481:	89 e5                	mov    %esp,%ebp
  101483:	83 ec 28             	sub    $0x28,%esp
  101486:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101489:	8b 7d 08             	mov    0x8(%ebp),%edi
  10148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10148f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101492:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101495:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101498:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10149b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
  1014a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1014a3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1014a6:	74 20                	je     1014c8 <readi+0x48>
  1014a8:	8b 47 18             	mov    0x18(%edi),%eax
  1014ab:	39 d8                	cmp    %ebx,%eax
  1014ad:	73 49                	jae    1014f8 <readi+0x78>
  1014af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014b4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1014b7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1014ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1014bd:	89 ec                	mov    %ebp,%esp
  1014bf:	5d                   	pop    %ebp
  1014c0:	c3                   	ret    
  1014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1014c8:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  1014cc:	66 83 f8 09          	cmp    $0x9,%ax
  1014d0:	77 dd                	ja     1014af <readi+0x2f>
  1014d2:	98                   	cwtl   
  1014d3:	8b 0c c5 a0 a6 10 00 	mov    0x10a6a0(,%eax,8),%ecx
  1014da:	85 c9                	test   %ecx,%ecx
  1014dc:	74 d1                	je     1014af <readi+0x2f>
  1014de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1014e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1014e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1014ea:	89 45 10             	mov    %eax,0x10(%ebp)
  1014ed:	89 ec                	mov    %ebp,%esp
  1014ef:	5d                   	pop    %ebp
  1014f0:	ff e1                	jmp    *%ecx
  1014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1014f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1014fb:	01 da                	add    %ebx,%edx
  1014fd:	72 b0                	jb     1014af <readi+0x2f>
  1014ff:	39 d0                	cmp    %edx,%eax
  101501:	73 05                	jae    101508 <readi+0x88>
  101503:	29 d8                	sub    %ebx,%eax
  101505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10150b:	85 d2                	test   %edx,%edx
  10150d:	74 78                	je     101587 <readi+0x107>
  10150f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101516:	66 90                	xchg   %ax,%ax
  101518:	89 da                	mov    %ebx,%edx
  10151a:	31 c9                	xor    %ecx,%ecx
  10151c:	c1 ea 09             	shr    $0x9,%edx
  10151f:	89 f8                	mov    %edi,%eax
  101521:	e8 5a fe ff ff       	call   101380 <bmap>
  101526:	be 00 02 00 00       	mov    $0x200,%esi
  10152b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10152f:	8b 07                	mov    (%edi),%eax
  101531:	89 04 24             	mov    %eax,(%esp)
  101534:	e8 77 eb ff ff       	call   1000b0 <bread>
  101539:	89 da                	mov    %ebx,%edx
  10153b:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101541:	29 d6                	sub    %edx,%esi
  101543:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101549:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10154c:	39 c6                	cmp    %eax,%esi
  10154e:	76 02                	jbe    101552 <readi+0xd2>
  101550:	89 c6                	mov    %eax,%esi
  101552:	89 74 24 08          	mov    %esi,0x8(%esp)
  101556:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101559:	01 f3                	add    %esi,%ebx
  10155b:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  10155f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101566:	89 04 24             	mov    %eax,(%esp)
  101569:	e8 02 30 00 00       	call   104570 <memmove>
  10156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101571:	89 0c 24             	mov    %ecx,(%esp)
  101574:	e8 87 ea ff ff       	call   100000 <brelse>
  101579:	01 75 ec             	add    %esi,-0x14(%ebp)
  10157c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10157f:	01 75 e8             	add    %esi,-0x18(%ebp)
  101582:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  101585:	77 91                	ja     101518 <readi+0x98>
  101587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10158a:	e9 25 ff ff ff       	jmp    1014b4 <readi+0x34>
  10158f:	90                   	nop

00101590 <iupdate>:
  101590:	55                   	push   %ebp
  101591:	89 e5                	mov    %esp,%ebp
  101593:	56                   	push   %esi
  101594:	53                   	push   %ebx
  101595:	83 ec 10             	sub    $0x10,%esp
  101598:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10159b:	8b 43 04             	mov    0x4(%ebx),%eax
  10159e:	c1 e8 03             	shr    $0x3,%eax
  1015a1:	83 c0 02             	add    $0x2,%eax
  1015a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015a8:	8b 03                	mov    (%ebx),%eax
  1015aa:	89 04 24             	mov    %eax,(%esp)
  1015ad:	e8 fe ea ff ff       	call   1000b0 <bread>
  1015b2:	89 c6                	mov    %eax,%esi
  1015b4:	8b 43 04             	mov    0x4(%ebx),%eax
  1015b7:	83 e0 07             	and    $0x7,%eax
  1015ba:	c1 e0 06             	shl    $0x6,%eax
  1015bd:	8d 54 06 18          	lea    0x18(%esi,%eax,1),%edx
  1015c1:	0f b7 43 10          	movzwl 0x10(%ebx),%eax
  1015c5:	66 89 02             	mov    %ax,(%edx)
  1015c8:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  1015cc:	66 89 42 02          	mov    %ax,0x2(%edx)
  1015d0:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
  1015d4:	66 89 42 04          	mov    %ax,0x4(%edx)
  1015d8:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
  1015dc:	66 89 42 06          	mov    %ax,0x6(%edx)
  1015e0:	8b 43 18             	mov    0x18(%ebx),%eax
  1015e3:	83 c3 1c             	add    $0x1c,%ebx
  1015e6:	89 42 08             	mov    %eax,0x8(%edx)
  1015e9:	83 c2 0c             	add    $0xc,%edx
  1015ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1015f0:	89 14 24             	mov    %edx,(%esp)
  1015f3:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  1015fa:	00 
  1015fb:	e8 70 2f 00 00       	call   104570 <memmove>
  101600:	89 34 24             	mov    %esi,(%esp)
  101603:	e8 78 ea ff ff       	call   100080 <bwrite>
  101608:	89 75 08             	mov    %esi,0x8(%ebp)
  10160b:	83 c4 10             	add    $0x10,%esp
  10160e:	5b                   	pop    %ebx
  10160f:	5e                   	pop    %esi
  101610:	5d                   	pop    %ebp
  101611:	e9 ea e9 ff ff       	jmp    100000 <brelse>
  101616:	8d 76 00             	lea    0x0(%esi),%esi
  101619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101620 <writei>:
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	57                   	push   %edi
  101624:	56                   	push   %esi
  101625:	53                   	push   %ebx
  101626:	83 ec 1c             	sub    $0x1c,%esp
  101629:	8b 45 08             	mov    0x8(%ebp),%eax
  10162c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10162f:	8b 7d 10             	mov    0x10(%ebp),%edi
  101632:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101635:	8b 45 14             	mov    0x14(%ebp),%eax
  101638:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10163b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  101641:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  101646:	0f 84 bc 00 00 00    	je     101708 <writei+0xe8>
  10164c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10164f:	01 f8                	add    %edi,%eax
  101651:	0f 82 bb 00 00 00    	jb     101712 <writei+0xf2>
  101657:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10165c:	0f 87 be 00 00 00    	ja     101720 <writei+0x100>
  101662:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  101665:	85 c9                	test   %ecx,%ecx
  101667:	0f 84 8a 00 00 00    	je     1016f7 <writei+0xd7>
  10166d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  101674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10167b:	89 fa                	mov    %edi,%edx
  10167d:	b9 01 00 00 00       	mov    $0x1,%ecx
  101682:	c1 ea 09             	shr    $0x9,%edx
  101685:	bb 00 02 00 00       	mov    $0x200,%ebx
  10168a:	e8 f1 fc ff ff       	call   101380 <bmap>
  10168f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101693:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101696:	8b 02                	mov    (%edx),%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 10 ea ff ff       	call   1000b0 <bread>
  1016a0:	89 fa                	mov    %edi,%edx
  1016a2:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1016a8:	29 d3                	sub    %edx,%ebx
  1016aa:	89 c6                	mov    %eax,%esi
  1016ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016af:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1016b2:	39 c3                	cmp    %eax,%ebx
  1016b4:	76 02                	jbe    1016b8 <writei+0x98>
  1016b6:	89 c3                	mov    %eax,%ebx
  1016b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1016bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1016bf:	01 df                	add    %ebx,%edi
  1016c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016c5:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  1016c9:	89 04 24             	mov    %eax,(%esp)
  1016cc:	e8 9f 2e 00 00       	call   104570 <memmove>
  1016d1:	89 34 24             	mov    %esi,(%esp)
  1016d4:	e8 a7 e9 ff ff       	call   100080 <bwrite>
  1016d9:	89 34 24             	mov    %esi,(%esp)
  1016dc:	e8 1f e9 ff ff       	call   100000 <brelse>
  1016e1:	01 5d f0             	add    %ebx,-0x10(%ebp)
  1016e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1016e7:	01 5d e8             	add    %ebx,-0x18(%ebp)
  1016ea:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  1016ed:	77 89                	ja     101678 <writei+0x58>
  1016ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016f2:	3b 78 18             	cmp    0x18(%eax),%edi
  1016f5:	77 39                	ja     101730 <writei+0x110>
  1016f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016fa:	83 c4 1c             	add    $0x1c,%esp
  1016fd:	5b                   	pop    %ebx
  1016fe:	5e                   	pop    %esi
  1016ff:	5f                   	pop    %edi
  101700:	5d                   	pop    %ebp
  101701:	c3                   	ret    
  101702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101708:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  10170c:	66 83 f8 09          	cmp    $0x9,%ax
  101710:	76 2b                	jbe    10173d <writei+0x11d>
  101712:	83 c4 1c             	add    $0x1c,%esp
  101715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10171a:	5b                   	pop    %ebx
  10171b:	5e                   	pop    %esi
  10171c:	5f                   	pop    %edi
  10171d:	5d                   	pop    %ebp
  10171e:	c3                   	ret    
  10171f:	90                   	nop
  101720:	c7 45 e4 00 18 01 00 	movl   $0x11800,-0x1c(%ebp)
  101727:	29 7d e4             	sub    %edi,-0x1c(%ebp)
  10172a:	e9 33 ff ff ff       	jmp    101662 <writei+0x42>
  10172f:	90                   	nop
  101730:	89 78 18             	mov    %edi,0x18(%eax)
  101733:	89 04 24             	mov    %eax,(%esp)
  101736:	e8 55 fe ff ff       	call   101590 <iupdate>
  10173b:	eb ba                	jmp    1016f7 <writei+0xd7>
  10173d:	98                   	cwtl   
  10173e:	8b 0c c5 a4 a6 10 00 	mov    0x10a6a4(,%eax,8),%ecx
  101745:	85 c9                	test   %ecx,%ecx
  101747:	74 c9                	je     101712 <writei+0xf2>
  101749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10174c:	89 45 10             	mov    %eax,0x10(%ebp)
  10174f:	83 c4 1c             	add    $0x1c,%esp
  101752:	5b                   	pop    %ebx
  101753:	5e                   	pop    %esi
  101754:	5f                   	pop    %edi
  101755:	5d                   	pop    %ebp
  101756:	ff e1                	jmp    *%ecx
  101758:	90                   	nop
  101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101760 <namecmp>:
  101760:	55                   	push   %ebp
  101761:	89 e5                	mov    %esp,%ebp
  101763:	83 ec 18             	sub    $0x18,%esp
  101766:	8b 45 0c             	mov    0xc(%ebp),%eax
  101769:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101770:	00 
  101771:	89 44 24 04          	mov    %eax,0x4(%esp)
  101775:	8b 45 08             	mov    0x8(%ebp),%eax
  101778:	89 04 24             	mov    %eax,(%esp)
  10177b:	e8 60 2e 00 00       	call   1045e0 <strncmp>
  101780:	c9                   	leave  
  101781:	c3                   	ret    
  101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101790 <dirlookup>:
  101790:	55                   	push   %ebp
  101791:	89 e5                	mov    %esp,%ebp
  101793:	57                   	push   %edi
  101794:	56                   	push   %esi
  101795:	53                   	push   %ebx
  101796:	83 ec 2c             	sub    $0x2c,%esp
  101799:	8b 45 08             	mov    0x8(%ebp),%eax
  10179c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10179f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1017a2:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  1017a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1017aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1017ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  1017b0:	0f 85 d2 00 00 00    	jne    101888 <dirlookup+0xf8>
  1017b6:	8b 78 18             	mov    0x18(%eax),%edi
  1017b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1017c0:	85 ff                	test   %edi,%edi
  1017c2:	0f 84 b6 00 00 00    	je     10187e <dirlookup+0xee>
  1017c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1017cb:	31 c9                	xor    %ecx,%ecx
  1017cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1017d0:	c1 ea 09             	shr    $0x9,%edx
  1017d3:	e8 a8 fb ff ff       	call   101380 <bmap>
  1017d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1017df:	8b 02                	mov    (%edx),%eax
  1017e1:	89 04 24             	mov    %eax,(%esp)
  1017e4:	e8 c7 e8 ff ff       	call   1000b0 <bread>
  1017e9:	8d 48 18             	lea    0x18(%eax),%ecx
  1017ec:	89 c7                	mov    %eax,%edi
  1017ee:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1017f1:	89 cb                	mov    %ecx,%ebx
  1017f3:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  1017f9:	eb 0c                	jmp    101807 <dirlookup+0x77>
  1017fb:	90                   	nop
  1017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101800:	83 c3 10             	add    $0x10,%ebx
  101803:	39 f3                	cmp    %esi,%ebx
  101805:	74 59                	je     101860 <dirlookup+0xd0>
  101807:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  10180b:	74 f3                	je     101800 <dirlookup+0x70>
  10180d:	8d 43 02             	lea    0x2(%ebx),%eax
  101810:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101817:	00 
  101818:	89 44 24 04          	mov    %eax,0x4(%esp)
  10181c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10181f:	89 04 24             	mov    %eax,(%esp)
  101822:	e8 b9 2d 00 00       	call   1045e0 <strncmp>
  101827:	85 c0                	test   %eax,%eax
  101829:	75 d5                	jne    101800 <dirlookup+0x70>
  10182b:	8b 75 e0             	mov    -0x20(%ebp),%esi
  10182e:	85 f6                	test   %esi,%esi
  101830:	74 0e                	je     101840 <dirlookup+0xb0>
  101832:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101835:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101838:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  10183b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10183e:	89 01                	mov    %eax,(%ecx)
  101840:	0f b7 1b             	movzwl (%ebx),%ebx
  101843:	89 3c 24             	mov    %edi,(%esp)
  101846:	e8 b5 e7 ff ff       	call   100000 <brelse>
  10184b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10184e:	89 da                	mov    %ebx,%edx
  101850:	8b 01                	mov    (%ecx),%eax
  101852:	83 c4 2c             	add    $0x2c,%esp
  101855:	5b                   	pop    %ebx
  101856:	5e                   	pop    %esi
  101857:	5f                   	pop    %edi
  101858:	5d                   	pop    %ebp
  101859:	e9 32 f9 ff ff       	jmp    101190 <iget>
  10185e:	66 90                	xchg   %ax,%ax
  101860:	89 3c 24             	mov    %edi,(%esp)
  101863:	e8 98 e7 ff ff       	call   100000 <brelse>
  101868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10186b:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  101872:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101875:	39 50 18             	cmp    %edx,0x18(%eax)
  101878:	0f 87 4a ff ff ff    	ja     1017c8 <dirlookup+0x38>
  10187e:	83 c4 2c             	add    $0x2c,%esp
  101881:	31 c0                	xor    %eax,%eax
  101883:	5b                   	pop    %ebx
  101884:	5e                   	pop    %esi
  101885:	5f                   	pop    %edi
  101886:	5d                   	pop    %ebp
  101887:	c3                   	ret    
  101888:	c7 04 24 d3 65 10 00 	movl   $0x1065d3,(%esp)
  10188f:	e8 dc f0 ff ff       	call   100970 <panic>
  101894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10189a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001018a0 <ialloc>:
  1018a0:	55                   	push   %ebp
  1018a1:	89 e5                	mov    %esp,%ebp
  1018a3:	57                   	push   %edi
  1018a4:	56                   	push   %esi
  1018a5:	53                   	push   %ebx
  1018a6:	83 ec 2c             	sub    $0x2c,%esp
  1018a9:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  1018ad:	8d 55 e8             	lea    -0x18(%ebp),%edx
  1018b0:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  1018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b7:	e8 a4 f9 ff ff       	call   101260 <readsb>
  1018bc:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  1018c0:	0f 86 9a 00 00 00    	jbe    101960 <ialloc+0xc0>
  1018c6:	bf 01 00 00 00       	mov    $0x1,%edi
  1018cb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1018d2:	eb 17                	jmp    1018eb <ialloc+0x4b>
  1018d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1018d8:	83 c7 01             	add    $0x1,%edi
  1018db:	89 34 24             	mov    %esi,(%esp)
  1018de:	e8 1d e7 ff ff       	call   100000 <brelse>
  1018e3:	3b 7d f0             	cmp    -0x10(%ebp),%edi
  1018e6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  1018e9:	73 75                	jae    101960 <ialloc+0xc0>
  1018eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1018ee:	c1 e8 03             	shr    $0x3,%eax
  1018f1:	83 c0 02             	add    $0x2,%eax
  1018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018fb:	89 04 24             	mov    %eax,(%esp)
  1018fe:	e8 ad e7 ff ff       	call   1000b0 <bread>
  101903:	89 c6                	mov    %eax,%esi
  101905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101908:	83 e0 07             	and    $0x7,%eax
  10190b:	c1 e0 06             	shl    $0x6,%eax
  10190e:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
  101912:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101916:	75 c0                	jne    1018d8 <ialloc+0x38>
  101918:	89 1c 24             	mov    %ebx,(%esp)
  10191b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101922:	00 
  101923:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10192a:	00 
  10192b:	e8 b0 2b 00 00       	call   1044e0 <memset>
  101930:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  101934:	66 89 03             	mov    %ax,(%ebx)
  101937:	89 34 24             	mov    %esi,(%esp)
  10193a:	e8 41 e7 ff ff       	call   100080 <bwrite>
  10193f:	89 34 24             	mov    %esi,(%esp)
  101942:	e8 b9 e6 ff ff       	call   100000 <brelse>
  101947:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10194a:	8b 45 08             	mov    0x8(%ebp),%eax
  10194d:	e8 3e f8 ff ff       	call   101190 <iget>
  101952:	83 c4 2c             	add    $0x2c,%esp
  101955:	5b                   	pop    %ebx
  101956:	5e                   	pop    %esi
  101957:	5f                   	pop    %edi
  101958:	5d                   	pop    %ebp
  101959:	c3                   	ret    
  10195a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101960:	c7 04 24 e5 65 10 00 	movl   $0x1065e5,(%esp)
  101967:	e8 04 f0 ff ff       	call   100970 <panic>
  10196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101970 <bfree>:
  101970:	55                   	push   %ebp
  101971:	89 e5                	mov    %esp,%ebp
  101973:	57                   	push   %edi
  101974:	89 c7                	mov    %eax,%edi
  101976:	56                   	push   %esi
  101977:	89 d6                	mov    %edx,%esi
  101979:	53                   	push   %ebx
  10197a:	83 ec 1c             	sub    $0x1c,%esp
  10197d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101981:	89 04 24             	mov    %eax,(%esp)
  101984:	e8 27 e7 ff ff       	call   1000b0 <bread>
  101989:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101990:	00 
  101991:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101998:	00 
  101999:	89 c3                	mov    %eax,%ebx
  10199b:	8d 40 18             	lea    0x18(%eax),%eax
  10199e:	89 04 24             	mov    %eax,(%esp)
  1019a1:	e8 3a 2b 00 00       	call   1044e0 <memset>
  1019a6:	89 1c 24             	mov    %ebx,(%esp)
  1019a9:	e8 d2 e6 ff ff       	call   100080 <bwrite>
  1019ae:	89 1c 24             	mov    %ebx,(%esp)
  1019b1:	e8 4a e6 ff ff       	call   100000 <brelse>
  1019b6:	89 f8                	mov    %edi,%eax
  1019b8:	8d 55 e8             	lea    -0x18(%ebp),%edx
  1019bb:	e8 a0 f8 ff ff       	call   101260 <readsb>
  1019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019c3:	89 f2                	mov    %esi,%edx
  1019c5:	c1 ea 0c             	shr    $0xc,%edx
  1019c8:	89 3c 24             	mov    %edi,(%esp)
  1019cb:	89 f7                	mov    %esi,%edi
  1019cd:	83 e6 07             	and    $0x7,%esi
  1019d0:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  1019d6:	c1 e8 03             	shr    $0x3,%eax
  1019d9:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e1:	c1 ff 03             	sar    $0x3,%edi
  1019e4:	e8 c7 e6 ff ff       	call   1000b0 <bread>
  1019e9:	89 f1                	mov    %esi,%ecx
  1019eb:	ba 01 00 00 00       	mov    $0x1,%edx
  1019f0:	d3 e2                	shl    %cl,%edx
  1019f2:	0f b6 74 38 18       	movzbl 0x18(%eax,%edi,1),%esi
  1019f7:	89 c3                	mov    %eax,%ebx
  1019f9:	89 f1                	mov    %esi,%ecx
  1019fb:	0f b6 c1             	movzbl %cl,%eax
  1019fe:	85 d0                	test   %edx,%eax
  101a00:	74 22                	je     101a24 <bfree+0xb4>
  101a02:	89 d0                	mov    %edx,%eax
  101a04:	f7 d0                	not    %eax
  101a06:	21 f0                	and    %esi,%eax
  101a08:	88 44 3b 18          	mov    %al,0x18(%ebx,%edi,1)
  101a0c:	89 1c 24             	mov    %ebx,(%esp)
  101a0f:	e8 6c e6 ff ff       	call   100080 <bwrite>
  101a14:	89 1c 24             	mov    %ebx,(%esp)
  101a17:	e8 e4 e5 ff ff       	call   100000 <brelse>
  101a1c:	83 c4 1c             	add    $0x1c,%esp
  101a1f:	5b                   	pop    %ebx
  101a20:	5e                   	pop    %esi
  101a21:	5f                   	pop    %edi
  101a22:	5d                   	pop    %ebp
  101a23:	c3                   	ret    
  101a24:	c7 04 24 f7 65 10 00 	movl   $0x1065f7,(%esp)
  101a2b:	e8 40 ef ff ff       	call   100970 <panic>

00101a30 <iput>:
  101a30:	55                   	push   %ebp
  101a31:	89 e5                	mov    %esp,%ebp
  101a33:	57                   	push   %edi
  101a34:	56                   	push   %esi
  101a35:	53                   	push   %ebx
  101a36:	83 ec 0c             	sub    $0xc,%esp
  101a39:	8b 75 08             	mov    0x8(%ebp),%esi
  101a3c:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101a43:	e8 28 2a 00 00       	call   104470 <acquire>
  101a48:	8b 46 08             	mov    0x8(%esi),%eax
  101a4b:	83 f8 01             	cmp    $0x1,%eax
  101a4e:	0f 85 a4 00 00 00    	jne    101af8 <iput+0xc8>
  101a54:	8b 56 0c             	mov    0xc(%esi),%edx
  101a57:	f6 c2 02             	test   $0x2,%dl
  101a5a:	0f 84 98 00 00 00    	je     101af8 <iput+0xc8>
  101a60:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101a65:	0f 85 8d 00 00 00    	jne    101af8 <iput+0xc8>
  101a6b:	f6 c2 01             	test   $0x1,%dl
  101a6e:	66 90                	xchg   %ax,%ax
  101a70:	0f 85 07 01 00 00    	jne    101b7d <iput+0x14d>
  101a76:	83 ca 01             	or     $0x1,%edx
  101a79:	89 f3                	mov    %esi,%ebx
  101a7b:	89 56 0c             	mov    %edx,0xc(%esi)
  101a7e:	8d 7e 30             	lea    0x30(%esi),%edi
  101a81:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101a88:	e8 a3 29 00 00       	call   104430 <release>
  101a8d:	eb 08                	jmp    101a97 <iput+0x67>
  101a8f:	90                   	nop
  101a90:	83 c3 04             	add    $0x4,%ebx
  101a93:	39 fb                	cmp    %edi,%ebx
  101a95:	74 20                	je     101ab7 <iput+0x87>
  101a97:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101a9a:	85 d2                	test   %edx,%edx
  101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101aa0:	74 ee                	je     101a90 <iput+0x60>
  101aa2:	8b 06                	mov    (%esi),%eax
  101aa4:	e8 c7 fe ff ff       	call   101970 <bfree>
  101aa9:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101ab0:	83 c3 04             	add    $0x4,%ebx
  101ab3:	39 fb                	cmp    %edi,%ebx
  101ab5:	75 e0                	jne    101a97 <iput+0x67>
  101ab7:	8b 46 4c             	mov    0x4c(%esi),%eax
  101aba:	85 c0                	test   %eax,%eax
  101abc:	75 5a                	jne    101b18 <iput+0xe8>
  101abe:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  101ac5:	89 34 24             	mov    %esi,(%esp)
  101ac8:	e8 c3 fa ff ff       	call   101590 <iupdate>
  101acd:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
  101ad3:	89 34 24             	mov    %esi,(%esp)
  101ad6:	e8 b5 fa ff ff       	call   101590 <iupdate>
  101adb:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101ae2:	e8 89 29 00 00       	call   104470 <acquire>
  101ae7:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
  101aeb:	89 34 24             	mov    %esi,(%esp)
  101aee:	e8 9d 18 00 00       	call   103390 <wakeup>
  101af3:	8b 46 08             	mov    0x8(%esi),%eax
  101af6:	66 90                	xchg   %ax,%ax
  101af8:	83 e8 01             	sub    $0x1,%eax
  101afb:	89 46 08             	mov    %eax,0x8(%esi)
  101afe:	c7 45 08 00 a7 10 00 	movl   $0x10a700,0x8(%ebp)
  101b05:	83 c4 0c             	add    $0xc,%esp
  101b08:	5b                   	pop    %ebx
  101b09:	5e                   	pop    %esi
  101b0a:	5f                   	pop    %edi
  101b0b:	5d                   	pop    %ebp
  101b0c:	e9 1f 29 00 00       	jmp    104430 <release>
  101b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1c:	8b 06                	mov    (%esi),%eax
  101b1e:	31 db                	xor    %ebx,%ebx
  101b20:	89 04 24             	mov    %eax,(%esp)
  101b23:	e8 88 e5 ff ff       	call   1000b0 <bread>
  101b28:	89 c7                	mov    %eax,%edi
  101b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101b2d:	83 c7 18             	add    $0x18,%edi
  101b30:	31 c0                	xor    %eax,%eax
  101b32:	eb 11                	jmp    101b45 <iput+0x115>
  101b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101b38:	83 c3 01             	add    $0x1,%ebx
  101b3b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101b41:	89 d8                	mov    %ebx,%eax
  101b43:	74 1b                	je     101b60 <iput+0x130>
  101b45:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101b48:	85 d2                	test   %edx,%edx
  101b4a:	74 ec                	je     101b38 <iput+0x108>
  101b4c:	8b 06                	mov    (%esi),%eax
  101b4e:	e8 1d fe ff ff       	call   101970 <bfree>
  101b53:	90                   	nop
  101b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101b58:	eb de                	jmp    101b38 <iput+0x108>
  101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b63:	89 04 24             	mov    %eax,(%esp)
  101b66:	e8 95 e4 ff ff       	call   100000 <brelse>
  101b6b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101b78:	e9 41 ff ff ff       	jmp    101abe <iput+0x8e>
  101b7d:	c7 04 24 0a 66 10 00 	movl   $0x10660a,(%esp)
  101b84:	e8 e7 ed ff ff       	call   100970 <panic>
  101b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101b90 <dirlink>:
  101b90:	55                   	push   %ebp
  101b91:	89 e5                	mov    %esp,%ebp
  101b93:	57                   	push   %edi
  101b94:	56                   	push   %esi
  101b95:	53                   	push   %ebx
  101b96:	83 ec 2c             	sub    $0x2c,%esp
  101b99:	8b 7d 08             	mov    0x8(%ebp),%edi
  101b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101b9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101ba6:	00 
  101ba7:	89 3c 24             	mov    %edi,(%esp)
  101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bae:	e8 dd fb ff ff       	call   101790 <dirlookup>
  101bb3:	85 c0                	test   %eax,%eax
  101bb5:	0f 85 98 00 00 00    	jne    101c53 <dirlink+0xc3>
  101bbb:	8b 47 18             	mov    0x18(%edi),%eax
  101bbe:	85 c0                	test   %eax,%eax
  101bc0:	0f 84 9c 00 00 00    	je     101c62 <dirlink+0xd2>
  101bc6:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101bc9:	31 db                	xor    %ebx,%ebx
  101bcb:	eb 0b                	jmp    101bd8 <dirlink+0x48>
  101bcd:	8d 76 00             	lea    0x0(%esi),%esi
  101bd0:	83 c3 10             	add    $0x10,%ebx
  101bd3:	39 5f 18             	cmp    %ebx,0x18(%edi)
  101bd6:	76 24                	jbe    101bfc <dirlink+0x6c>
  101bd8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101bdf:	00 
  101be0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101be4:	89 74 24 04          	mov    %esi,0x4(%esp)
  101be8:	89 3c 24             	mov    %edi,(%esp)
  101beb:	e8 90 f8 ff ff       	call   101480 <readi>
  101bf0:	83 f8 10             	cmp    $0x10,%eax
  101bf3:	75 52                	jne    101c47 <dirlink+0xb7>
  101bf5:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101bfa:	75 d4                	jne    101bd0 <dirlink+0x40>
  101bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  101bff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101c06:	00 
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101c0e:	89 04 24             	mov    %eax,(%esp)
  101c11:	e8 1a 2a 00 00       	call   104630 <strncpy>
  101c16:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  101c1a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101c21:	00 
  101c22:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101c26:	89 74 24 04          	mov    %esi,0x4(%esp)
  101c2a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  101c2e:	89 3c 24             	mov    %edi,(%esp)
  101c31:	e8 ea f9 ff ff       	call   101620 <writei>
  101c36:	31 d2                	xor    %edx,%edx
  101c38:	83 f8 10             	cmp    $0x10,%eax
  101c3b:	75 2c                	jne    101c69 <dirlink+0xd9>
  101c3d:	83 c4 2c             	add    $0x2c,%esp
  101c40:	89 d0                	mov    %edx,%eax
  101c42:	5b                   	pop    %ebx
  101c43:	5e                   	pop    %esi
  101c44:	5f                   	pop    %edi
  101c45:	5d                   	pop    %ebp
  101c46:	c3                   	ret    
  101c47:	c7 04 24 14 66 10 00 	movl   $0x106614,(%esp)
  101c4e:	e8 1d ed ff ff       	call   100970 <panic>
  101c53:	89 04 24             	mov    %eax,(%esp)
  101c56:	e8 d5 fd ff ff       	call   101a30 <iput>
  101c5b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101c60:	eb db                	jmp    101c3d <dirlink+0xad>
  101c62:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101c65:	31 db                	xor    %ebx,%ebx
  101c67:	eb 93                	jmp    101bfc <dirlink+0x6c>
  101c69:	c7 04 24 21 66 10 00 	movl   $0x106621,(%esp)
  101c70:	e8 fb ec ff ff       	call   100970 <panic>
  101c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101c80 <iunlock>:
  101c80:	55                   	push   %ebp
  101c81:	89 e5                	mov    %esp,%ebp
  101c83:	53                   	push   %ebx
  101c84:	83 ec 04             	sub    $0x4,%esp
  101c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101c8a:	85 db                	test   %ebx,%ebx
  101c8c:	74 3a                	je     101cc8 <iunlock+0x48>
  101c8e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101c92:	74 34                	je     101cc8 <iunlock+0x48>
  101c94:	8b 43 08             	mov    0x8(%ebx),%eax
  101c97:	85 c0                	test   %eax,%eax
  101c99:	7e 2d                	jle    101cc8 <iunlock+0x48>
  101c9b:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101ca2:	e8 c9 27 00 00       	call   104470 <acquire>
  101ca7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  101cab:	89 1c 24             	mov    %ebx,(%esp)
  101cae:	e8 dd 16 00 00       	call   103390 <wakeup>
  101cb3:	c7 45 08 00 a7 10 00 	movl   $0x10a700,0x8(%ebp)
  101cba:	83 c4 04             	add    $0x4,%esp
  101cbd:	5b                   	pop    %ebx
  101cbe:	5d                   	pop    %ebp
  101cbf:	e9 6c 27 00 00       	jmp    104430 <release>
  101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101cc8:	c7 04 24 29 66 10 00 	movl   $0x106629,(%esp)
  101ccf:	e8 9c ec ff ff       	call   100970 <panic>
  101cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101ce0 <iunlockput>:
  101ce0:	55                   	push   %ebp
  101ce1:	89 e5                	mov    %esp,%ebp
  101ce3:	53                   	push   %ebx
  101ce4:	83 ec 04             	sub    $0x4,%esp
  101ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101cea:	89 1c 24             	mov    %ebx,(%esp)
  101ced:	e8 8e ff ff ff       	call   101c80 <iunlock>
  101cf2:	89 5d 08             	mov    %ebx,0x8(%ebp)
  101cf5:	83 c4 04             	add    $0x4,%esp
  101cf8:	5b                   	pop    %ebx
  101cf9:	5d                   	pop    %ebp
  101cfa:	e9 31 fd ff ff       	jmp    101a30 <iput>
  101cff:	90                   	nop

00101d00 <ilock>:
  101d00:	55                   	push   %ebp
  101d01:	89 e5                	mov    %esp,%ebp
  101d03:	56                   	push   %esi
  101d04:	53                   	push   %ebx
  101d05:	83 ec 10             	sub    $0x10,%esp
  101d08:	8b 75 08             	mov    0x8(%ebp),%esi
  101d0b:	85 f6                	test   %esi,%esi
  101d0d:	74 59                	je     101d68 <ilock+0x68>
  101d0f:	8b 46 08             	mov    0x8(%esi),%eax
  101d12:	85 c0                	test   %eax,%eax
  101d14:	7e 52                	jle    101d68 <ilock+0x68>
  101d16:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101d1d:	e8 4e 27 00 00       	call   104470 <acquire>
  101d22:	8b 46 0c             	mov    0xc(%esi),%eax
  101d25:	a8 01                	test   $0x1,%al
  101d27:	74 1e                	je     101d47 <ilock+0x47>
  101d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101d30:	c7 44 24 04 00 a7 10 	movl   $0x10a700,0x4(%esp)
  101d37:	00 
  101d38:	89 34 24             	mov    %esi,(%esp)
  101d3b:	e8 b0 19 00 00       	call   1036f0 <sleep>
  101d40:	8b 46 0c             	mov    0xc(%esi),%eax
  101d43:	a8 01                	test   $0x1,%al
  101d45:	75 e9                	jne    101d30 <ilock+0x30>
  101d47:	83 c8 01             	or     $0x1,%eax
  101d4a:	89 46 0c             	mov    %eax,0xc(%esi)
  101d4d:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101d54:	e8 d7 26 00 00       	call   104430 <release>
  101d59:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101d5d:	74 19                	je     101d78 <ilock+0x78>
  101d5f:	83 c4 10             	add    $0x10,%esp
  101d62:	5b                   	pop    %ebx
  101d63:	5e                   	pop    %esi
  101d64:	5d                   	pop    %ebp
  101d65:	c3                   	ret    
  101d66:	66 90                	xchg   %ax,%ax
  101d68:	c7 04 24 31 66 10 00 	movl   $0x106631,(%esp)
  101d6f:	e8 fc eb ff ff       	call   100970 <panic>
  101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101d78:	8b 46 04             	mov    0x4(%esi),%eax
  101d7b:	c1 e8 03             	shr    $0x3,%eax
  101d7e:	83 c0 02             	add    $0x2,%eax
  101d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d85:	8b 06                	mov    (%esi),%eax
  101d87:	89 04 24             	mov    %eax,(%esp)
  101d8a:	e8 21 e3 ff ff       	call   1000b0 <bread>
  101d8f:	89 c3                	mov    %eax,%ebx
  101d91:	8b 46 04             	mov    0x4(%esi),%eax
  101d94:	83 e0 07             	and    $0x7,%eax
  101d97:	c1 e0 06             	shl    $0x6,%eax
  101d9a:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
  101d9e:	0f b7 10             	movzwl (%eax),%edx
  101da1:	66 89 56 10          	mov    %dx,0x10(%esi)
  101da5:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101da9:	66 89 56 12          	mov    %dx,0x12(%esi)
  101dad:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101db1:	66 89 56 14          	mov    %dx,0x14(%esi)
  101db5:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101db9:	66 89 56 16          	mov    %dx,0x16(%esi)
  101dbd:	8b 50 08             	mov    0x8(%eax),%edx
  101dc0:	83 c0 0c             	add    $0xc,%eax
  101dc3:	89 56 18             	mov    %edx,0x18(%esi)
  101dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dca:	8d 46 1c             	lea    0x1c(%esi),%eax
  101dcd:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101dd4:	00 
  101dd5:	89 04 24             	mov    %eax,(%esp)
  101dd8:	e8 93 27 00 00       	call   104570 <memmove>
  101ddd:	89 1c 24             	mov    %ebx,(%esp)
  101de0:	e8 1b e2 ff ff       	call   100000 <brelse>
  101de5:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
  101de9:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101dee:	0f 85 6b ff ff ff    	jne    101d5f <ilock+0x5f>
  101df4:	c7 04 24 37 66 10 00 	movl   $0x106637,(%esp)
  101dfb:	e8 70 eb ff ff       	call   100970 <panic>

00101e00 <_namei>:
  101e00:	55                   	push   %ebp
  101e01:	89 e5                	mov    %esp,%ebp
  101e03:	57                   	push   %edi
  101e04:	56                   	push   %esi
  101e05:	53                   	push   %ebx
  101e06:	89 c3                	mov    %eax,%ebx
  101e08:	83 ec 1c             	sub    $0x1c,%esp
  101e0b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  101e0e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  101e11:	80 38 2f             	cmpb   $0x2f,(%eax)
  101e14:	0f 84 30 01 00 00    	je     101f4a <_namei+0x14a>
  101e1a:	e8 71 16 00 00       	call   103490 <curproc>
  101e1f:	8b 40 60             	mov    0x60(%eax),%eax
  101e22:	89 04 24             	mov    %eax,(%esp)
  101e25:	e8 36 f3 ff ff       	call   101160 <idup>
  101e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101e2d:	eb 04                	jmp    101e33 <_namei+0x33>
  101e2f:	90                   	nop
  101e30:	83 c3 01             	add    $0x1,%ebx
  101e33:	0f b6 03             	movzbl (%ebx),%eax
  101e36:	3c 2f                	cmp    $0x2f,%al
  101e38:	74 f6                	je     101e30 <_namei+0x30>
  101e3a:	84 c0                	test   %al,%al
  101e3c:	89 de                	mov    %ebx,%esi
  101e3e:	75 1e                	jne    101e5e <_namei+0x5e>
  101e40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101e43:	85 c0                	test   %eax,%eax
  101e45:	0f 85 2c 01 00 00    	jne    101f77 <_namei+0x177>
  101e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101e4e:	83 c4 1c             	add    $0x1c,%esp
  101e51:	5b                   	pop    %ebx
  101e52:	5e                   	pop    %esi
  101e53:	5f                   	pop    %edi
  101e54:	5d                   	pop    %ebp
  101e55:	c3                   	ret    
  101e56:	66 90                	xchg   %ax,%ax
  101e58:	83 c6 01             	add    $0x1,%esi
  101e5b:	0f b6 06             	movzbl (%esi),%eax
  101e5e:	3c 2f                	cmp    $0x2f,%al
  101e60:	74 04                	je     101e66 <_namei+0x66>
  101e62:	84 c0                	test   %al,%al
  101e64:	75 f2                	jne    101e58 <_namei+0x58>
  101e66:	89 f2                	mov    %esi,%edx
  101e68:	89 f7                	mov    %esi,%edi
  101e6a:	29 da                	sub    %ebx,%edx
  101e6c:	83 fa 0d             	cmp    $0xd,%edx
  101e6f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  101e72:	0f 8e 90 00 00 00    	jle    101f08 <_namei+0x108>
  101e78:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e7f:	00 
  101e80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101e87:	89 04 24             	mov    %eax,(%esp)
  101e8a:	e8 e1 26 00 00       	call   104570 <memmove>
  101e8f:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101e92:	75 0c                	jne    101ea0 <_namei+0xa0>
  101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101e98:	83 c7 01             	add    $0x1,%edi
  101e9b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  101e9e:	74 f8                	je     101e98 <_namei+0x98>
  101ea0:	85 ff                	test   %edi,%edi
  101ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101ea8:	74 96                	je     101e40 <_namei+0x40>
  101eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ead:	89 04 24             	mov    %eax,(%esp)
  101eb0:	e8 4b fe ff ff       	call   101d00 <ilock>
  101eb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101eb8:	66 83 7a 10 01       	cmpw   $0x1,0x10(%edx)
  101ebd:	75 71                	jne    101f30 <_namei+0x130>
  101ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101ec2:	85 c0                	test   %eax,%eax
  101ec4:	74 09                	je     101ecf <_namei+0xcf>
  101ec6:	80 3f 00             	cmpb   $0x0,(%edi)
  101ec9:	0f 84 92 00 00 00    	je     101f61 <_namei+0x161>
  101ecf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101ed6:	00 
  101ed7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101eda:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ee1:	89 04 24             	mov    %eax,(%esp)
  101ee4:	e8 a7 f8 ff ff       	call   101790 <dirlookup>
  101ee9:	85 c0                	test   %eax,%eax
  101eeb:	89 c3                	mov    %eax,%ebx
  101eed:	74 3e                	je     101f2d <_namei+0x12d>
  101eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ef2:	89 04 24             	mov    %eax,(%esp)
  101ef5:	e8 e6 fd ff ff       	call   101ce0 <iunlockput>
  101efa:	89 5d ec             	mov    %ebx,-0x14(%ebp)
  101efd:	89 fb                	mov    %edi,%ebx
  101eff:	e9 2f ff ff ff       	jmp    101e33 <_namei+0x33>
  101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101f08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f0b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101f0f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f16:	89 04 24             	mov    %eax,(%esp)
  101f19:	e8 52 26 00 00       	call   104570 <memmove>
  101f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f24:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101f28:	e9 62 ff ff ff       	jmp    101e8f <_namei+0x8f>
  101f2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101f30:	89 14 24             	mov    %edx,(%esp)
  101f33:	e8 a8 fd ff ff       	call   101ce0 <iunlockput>
  101f38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101f42:	83 c4 1c             	add    $0x1c,%esp
  101f45:	5b                   	pop    %ebx
  101f46:	5e                   	pop    %esi
  101f47:	5f                   	pop    %edi
  101f48:	5d                   	pop    %ebp
  101f49:	c3                   	ret    
  101f4a:	ba 01 00 00 00       	mov    $0x1,%edx
  101f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  101f54:	e8 37 f2 ff ff       	call   101190 <iget>
  101f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101f5c:	e9 d2 fe ff ff       	jmp    101e33 <_namei+0x33>
  101f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101f64:	89 04 24             	mov    %eax,(%esp)
  101f67:	e8 14 fd ff ff       	call   101c80 <iunlock>
  101f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101f6f:	83 c4 1c             	add    $0x1c,%esp
  101f72:	5b                   	pop    %ebx
  101f73:	5e                   	pop    %esi
  101f74:	5f                   	pop    %edi
  101f75:	5d                   	pop    %ebp
  101f76:	c3                   	ret    
  101f77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101f7a:	89 14 24             	mov    %edx,(%esp)
  101f7d:	e8 ae fa ff ff       	call   101a30 <iput>
  101f82:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101f89:	e9 bd fe ff ff       	jmp    101e4b <_namei+0x4b>
  101f8e:	66 90                	xchg   %ax,%ax

00101f90 <nameiparent>:
  101f90:	55                   	push   %ebp
  101f91:	ba 01 00 00 00       	mov    $0x1,%edx
  101f96:	89 e5                	mov    %esp,%ebp
  101f98:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  101f9e:	5d                   	pop    %ebp
  101f9f:	e9 5c fe ff ff       	jmp    101e00 <_namei>
  101fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101fb0 <namei>:
  101fb0:	55                   	push   %ebp
  101fb1:	31 d2                	xor    %edx,%edx
  101fb3:	89 e5                	mov    %esp,%ebp
  101fb5:	83 ec 18             	sub    $0x18,%esp
  101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbb:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  101fbe:	e8 3d fe ff ff       	call   101e00 <_namei>
  101fc3:	c9                   	leave  
  101fc4:	c3                   	ret    
  101fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101fd0 <iinit>:
  101fd0:	55                   	push   %ebp
  101fd1:	89 e5                	mov    %esp,%ebp
  101fd3:	83 ec 08             	sub    $0x8,%esp
  101fd6:	c7 44 24 04 46 66 10 	movl   $0x106646,0x4(%esp)
  101fdd:	00 
  101fde:	c7 04 24 00 a7 10 00 	movl   $0x10a700,(%esp)
  101fe5:	e8 b6 22 00 00       	call   1042a0 <initlock>
  101fea:	c9                   	leave  
  101feb:	c3                   	ret    
  101fec:	90                   	nop
  101fed:	90                   	nop
  101fee:	90                   	nop
  101fef:	90                   	nop

00101ff0 <ide_start_request>:
  101ff0:	55                   	push   %ebp
  101ff1:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101ff6:	89 e5                	mov    %esp,%ebp
  101ff8:	56                   	push   %esi
  101ff9:	89 c6                	mov    %eax,%esi
  101ffb:	83 ec 04             	sub    $0x4,%esp
  101ffe:	85 c0                	test   %eax,%eax
  102000:	0f 84 89 00 00 00    	je     10208f <ide_start_request+0x9f>
  102006:	66 90                	xchg   %ax,%ax
  102008:	ec                   	in     (%dx),%al
  102009:	0f b6 c0             	movzbl %al,%eax
  10200c:	84 c0                	test   %al,%al
  10200e:	78 f8                	js     102008 <ide_start_request+0x18>
  102010:	a8 40                	test   $0x40,%al
  102012:	74 f4                	je     102008 <ide_start_request+0x18>
  102014:	ba f6 03 00 00       	mov    $0x3f6,%edx
  102019:	31 c0                	xor    %eax,%eax
  10201b:	ee                   	out    %al,(%dx)
  10201c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  102021:	b8 01 00 00 00       	mov    $0x1,%eax
  102026:	ee                   	out    %al,(%dx)
  102027:	8b 4e 08             	mov    0x8(%esi),%ecx
  10202a:	b2 f3                	mov    $0xf3,%dl
  10202c:	89 c8                	mov    %ecx,%eax
  10202e:	ee                   	out    %al,(%dx)
  10202f:	c1 e9 08             	shr    $0x8,%ecx
  102032:	b2 f4                	mov    $0xf4,%dl
  102034:	89 c8                	mov    %ecx,%eax
  102036:	ee                   	out    %al,(%dx)
  102037:	c1 e9 08             	shr    $0x8,%ecx
  10203a:	b2 f5                	mov    $0xf5,%dl
  10203c:	89 c8                	mov    %ecx,%eax
  10203e:	ee                   	out    %al,(%dx)
  10203f:	8b 46 04             	mov    0x4(%esi),%eax
  102042:	c1 e9 08             	shr    $0x8,%ecx
  102045:	89 ca                	mov    %ecx,%edx
  102047:	83 e2 0f             	and    $0xf,%edx
  10204a:	83 e0 01             	and    $0x1,%eax
  10204d:	c1 e0 04             	shl    $0x4,%eax
  102050:	09 d0                	or     %edx,%eax
  102052:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102057:	83 c8 e0             	or     $0xffffffe0,%eax
  10205a:	ee                   	out    %al,(%dx)
  10205b:	f6 06 04             	testb  $0x4,(%esi)
  10205e:	75 11                	jne    102071 <ide_start_request+0x81>
  102060:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102065:	b8 20 00 00 00       	mov    $0x20,%eax
  10206a:	ee                   	out    %al,(%dx)
  10206b:	83 c4 04             	add    $0x4,%esp
  10206e:	5e                   	pop    %esi
  10206f:	5d                   	pop    %ebp
  102070:	c3                   	ret    
  102071:	b2 f7                	mov    $0xf7,%dl
  102073:	b8 30 00 00 00       	mov    $0x30,%eax
  102078:	ee                   	out    %al,(%dx)
  102079:	b9 80 00 00 00       	mov    $0x80,%ecx
  10207e:	83 c6 18             	add    $0x18,%esi
  102081:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102086:	fc                   	cld    
  102087:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  102089:	83 c4 04             	add    $0x4,%esp
  10208c:	5e                   	pop    %esi
  10208d:	5d                   	pop    %ebp
  10208e:	c3                   	ret    
  10208f:	c7 04 24 52 66 10 00 	movl   $0x106652,(%esp)
  102096:	e8 d5 e8 ff ff       	call   100970 <panic>
  10209b:	90                   	nop
  10209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001020a0 <ide_rw>:
  1020a0:	55                   	push   %ebp
  1020a1:	89 e5                	mov    %esp,%ebp
  1020a3:	53                   	push   %ebx
  1020a4:	83 ec 14             	sub    $0x14,%esp
  1020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1020aa:	8b 03                	mov    (%ebx),%eax
  1020ac:	a8 01                	test   $0x1,%al
  1020ae:	0f 84 90 00 00 00    	je     102144 <ide_rw+0xa4>
  1020b4:	83 e0 06             	and    $0x6,%eax
  1020b7:	83 f8 02             	cmp    $0x2,%eax
  1020ba:	0f 84 90 00 00 00    	je     102150 <ide_rw+0xb0>
  1020c0:	8b 53 04             	mov    0x4(%ebx),%edx
  1020c3:	85 d2                	test   %edx,%edx
  1020c5:	74 0d                	je     1020d4 <ide_rw+0x34>
  1020c7:	a1 b8 84 10 00       	mov    0x1084b8,%eax
  1020cc:	85 c0                	test   %eax,%eax
  1020ce:	0f 84 88 00 00 00    	je     10215c <ide_rw+0xbc>
  1020d4:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  1020db:	e8 90 23 00 00       	call   104470 <acquire>
  1020e0:	a1 b4 84 10 00       	mov    0x1084b4,%eax
  1020e5:	ba b4 84 10 00       	mov    $0x1084b4,%edx
  1020ea:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  1020f1:	85 c0                	test   %eax,%eax
  1020f3:	74 0d                	je     102102 <ide_rw+0x62>
  1020f5:	8d 76 00             	lea    0x0(%esi),%esi
  1020f8:	8d 50 14             	lea    0x14(%eax),%edx
  1020fb:	8b 40 14             	mov    0x14(%eax),%eax
  1020fe:	85 c0                	test   %eax,%eax
  102100:	75 f6                	jne    1020f8 <ide_rw+0x58>
  102102:	89 1a                	mov    %ebx,(%edx)
  102104:	39 1d b4 84 10 00    	cmp    %ebx,0x1084b4
  10210a:	75 14                	jne    102120 <ide_rw+0x80>
  10210c:	eb 2d                	jmp    10213b <ide_rw+0x9b>
  10210e:	66 90                	xchg   %ax,%ax
  102110:	c7 44 24 04 80 84 10 	movl   $0x108480,0x4(%esp)
  102117:	00 
  102118:	89 1c 24             	mov    %ebx,(%esp)
  10211b:	e8 d0 15 00 00       	call   1036f0 <sleep>
  102120:	8b 03                	mov    (%ebx),%eax
  102122:	83 e0 06             	and    $0x6,%eax
  102125:	83 f8 02             	cmp    $0x2,%eax
  102128:	75 e6                	jne    102110 <ide_rw+0x70>
  10212a:	c7 45 08 80 84 10 00 	movl   $0x108480,0x8(%ebp)
  102131:	83 c4 14             	add    $0x14,%esp
  102134:	5b                   	pop    %ebx
  102135:	5d                   	pop    %ebp
  102136:	e9 f5 22 00 00       	jmp    104430 <release>
  10213b:	89 d8                	mov    %ebx,%eax
  10213d:	e8 ae fe ff ff       	call   101ff0 <ide_start_request>
  102142:	eb dc                	jmp    102120 <ide_rw+0x80>
  102144:	c7 04 24 64 66 10 00 	movl   $0x106664,(%esp)
  10214b:	e8 20 e8 ff ff       	call   100970 <panic>
  102150:	c7 04 24 79 66 10 00 	movl   $0x106679,(%esp)
  102157:	e8 14 e8 ff ff       	call   100970 <panic>
  10215c:	c7 04 24 8f 66 10 00 	movl   $0x10668f,(%esp)
  102163:	e8 08 e8 ff ff       	call   100970 <panic>
  102168:	90                   	nop
  102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102170 <ide_intr>:
  102170:	55                   	push   %ebp
  102171:	89 e5                	mov    %esp,%ebp
  102173:	57                   	push   %edi
  102174:	53                   	push   %ebx
  102175:	83 ec 10             	sub    $0x10,%esp
  102178:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  10217f:	e8 ec 22 00 00       	call   104470 <acquire>
  102184:	8b 1d b4 84 10 00    	mov    0x1084b4,%ebx
  10218a:	85 db                	test   %ebx,%ebx
  10218c:	74 28                	je     1021b6 <ide_intr+0x46>
  10218e:	8b 0b                	mov    (%ebx),%ecx
  102190:	f6 c1 04             	test   $0x4,%cl
  102193:	74 3b                	je     1021d0 <ide_intr+0x60>
  102195:	83 c9 02             	or     $0x2,%ecx
  102198:	83 e1 fb             	and    $0xfffffffb,%ecx
  10219b:	89 0b                	mov    %ecx,(%ebx)
  10219d:	89 1c 24             	mov    %ebx,(%esp)
  1021a0:	e8 eb 11 00 00       	call   103390 <wakeup>
  1021a5:	8b 43 14             	mov    0x14(%ebx),%eax
  1021a8:	85 c0                	test   %eax,%eax
  1021aa:	a3 b4 84 10 00       	mov    %eax,0x1084b4
  1021af:	74 05                	je     1021b6 <ide_intr+0x46>
  1021b1:	e8 3a fe ff ff       	call   101ff0 <ide_start_request>
  1021b6:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  1021bd:	e8 6e 22 00 00       	call   104430 <release>
  1021c2:	83 c4 10             	add    $0x10,%esp
  1021c5:	5b                   	pop    %ebx
  1021c6:	5f                   	pop    %edi
  1021c7:	5d                   	pop    %ebp
  1021c8:	c3                   	ret    
  1021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1021d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1021d5:	8d 76 00             	lea    0x0(%esi),%esi
  1021d8:	ec                   	in     (%dx),%al
  1021d9:	0f b6 c0             	movzbl %al,%eax
  1021dc:	84 c0                	test   %al,%al
  1021de:	78 f8                	js     1021d8 <ide_intr+0x68>
  1021e0:	a8 40                	test   $0x40,%al
  1021e2:	74 f4                	je     1021d8 <ide_intr+0x68>
  1021e4:	a8 21                	test   $0x21,%al
  1021e6:	75 ad                	jne    102195 <ide_intr+0x25>
  1021e8:	8d 7b 18             	lea    0x18(%ebx),%edi
  1021eb:	b9 80 00 00 00       	mov    $0x80,%ecx
  1021f0:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1021f5:	fc                   	cld    
  1021f6:	f2 6d                	repnz insl (%dx),%es:(%edi)
  1021f8:	8b 0b                	mov    (%ebx),%ecx
  1021fa:	eb 99                	jmp    102195 <ide_intr+0x25>
  1021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102200 <ide_init>:
  102200:	55                   	push   %ebp
  102201:	89 e5                	mov    %esp,%ebp
  102203:	53                   	push   %ebx
  102204:	83 ec 14             	sub    $0x14,%esp
  102207:	c7 44 24 04 a6 66 10 	movl   $0x1066a6,0x4(%esp)
  10220e:	00 
  10220f:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  102216:	e8 85 20 00 00       	call   1042a0 <initlock>
  10221b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102222:	e8 a9 0b 00 00       	call   102dd0 <pic_enable>
  102227:	a1 a0 bd 10 00       	mov    0x10bda0,%eax
  10222c:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102233:	83 e8 01             	sub    $0x1,%eax
  102236:	89 44 24 04          	mov    %eax,0x4(%esp)
  10223a:	e8 61 00 00 00       	call   1022a0 <ioapic_enable>
  10223f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102248:	ec                   	in     (%dx),%al
  102249:	0f b6 c0             	movzbl %al,%eax
  10224c:	84 c0                	test   %al,%al
  10224e:	78 f8                	js     102248 <ide_init+0x48>
  102250:	a8 40                	test   $0x40,%al
  102252:	74 f4                	je     102248 <ide_init+0x48>
  102254:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102259:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10225e:	ee                   	out    %al,(%dx)
  10225f:	31 db                	xor    %ebx,%ebx
  102261:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
  102266:	eb 0b                	jmp    102273 <ide_init+0x73>
  102268:	83 c3 01             	add    $0x1,%ebx
  10226b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  102271:	74 11                	je     102284 <ide_init+0x84>
  102273:	89 ca                	mov    %ecx,%edx
  102275:	ec                   	in     (%dx),%al
  102276:	84 c0                	test   %al,%al
  102278:	74 ee                	je     102268 <ide_init+0x68>
  10227a:	c7 05 b8 84 10 00 01 	movl   $0x1,0x1084b8
  102281:	00 00 00 
  102284:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102289:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  10228e:	ee                   	out    %al,(%dx)
  10228f:	83 c4 14             	add    $0x14,%esp
  102292:	5b                   	pop    %ebx
  102293:	5d                   	pop    %ebp
  102294:	c3                   	ret    
  102295:	90                   	nop
  102296:	90                   	nop
  102297:	90                   	nop
  102298:	90                   	nop
  102299:	90                   	nop
  10229a:	90                   	nop
  10229b:	90                   	nop
  10229c:	90                   	nop
  10229d:	90                   	nop
  10229e:	90                   	nop
  10229f:	90                   	nop

001022a0 <ioapic_enable>:
  1022a0:	a1 20 b7 10 00       	mov    0x10b720,%eax
  1022a5:	55                   	push   %ebp
  1022a6:	89 e5                	mov    %esp,%ebp
  1022a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1022ab:	85 c0                	test   %eax,%eax
  1022ad:	53                   	push   %ebx
  1022ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1022b1:	74 1d                	je     1022d0 <ioapic_enable+0x30>
  1022b3:	8b 0d d4 b6 10 00    	mov    0x10b6d4,%ecx
  1022b9:	8d 42 20             	lea    0x20(%edx),%eax
  1022bc:	8d 54 12 10          	lea    0x10(%edx,%edx,1),%edx
  1022c0:	c1 e3 18             	shl    $0x18,%ebx
  1022c3:	89 11                	mov    %edx,(%ecx)
  1022c5:	83 c2 01             	add    $0x1,%edx
  1022c8:	89 41 10             	mov    %eax,0x10(%ecx)
  1022cb:	89 11                	mov    %edx,(%ecx)
  1022cd:	89 59 10             	mov    %ebx,0x10(%ecx)
  1022d0:	5b                   	pop    %ebx
  1022d1:	5d                   	pop    %ebp
  1022d2:	c3                   	ret    
  1022d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001022e0 <ioapic_init>:
  1022e0:	55                   	push   %ebp
  1022e1:	89 e5                	mov    %esp,%ebp
  1022e3:	56                   	push   %esi
  1022e4:	53                   	push   %ebx
  1022e5:	83 ec 10             	sub    $0x10,%esp
  1022e8:	8b 15 20 b7 10 00    	mov    0x10b720,%edx
  1022ee:	85 d2                	test   %edx,%edx
  1022f0:	74 71                	je     102363 <ioapic_init+0x83>
  1022f2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  1022f9:	00 00 00 
  1022fc:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
  102301:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102308:	00 00 00 
  10230b:	0f b6 15 24 b7 10 00 	movzbl 0x10b724,%edx
  102312:	c7 05 d4 b6 10 00 00 	movl   $0xfec00000,0x10b6d4
  102319:	00 c0 fe 
  10231c:	c1 e8 10             	shr    $0x10,%eax
  10231f:	0f b6 f0             	movzbl %al,%esi
  102322:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
  102327:	c1 e8 18             	shr    $0x18,%eax
  10232a:	39 c2                	cmp    %eax,%edx
  10232c:	75 42                	jne    102370 <ioapic_init+0x90>
  10232e:	8b 0d d4 b6 10 00    	mov    0x10b6d4,%ecx
  102334:	31 db                	xor    %ebx,%ebx
  102336:	ba 10 00 00 00       	mov    $0x10,%edx
  10233b:	90                   	nop
  10233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102340:	8d 43 20             	lea    0x20(%ebx),%eax
  102343:	83 c3 01             	add    $0x1,%ebx
  102346:	0d 00 00 01 00       	or     $0x10000,%eax
  10234b:	89 11                	mov    %edx,(%ecx)
  10234d:	89 41 10             	mov    %eax,0x10(%ecx)
  102350:	8d 42 01             	lea    0x1(%edx),%eax
  102353:	83 c2 02             	add    $0x2,%edx
  102356:	39 de                	cmp    %ebx,%esi
  102358:	89 01                	mov    %eax,(%ecx)
  10235a:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  102361:	7d dd                	jge    102340 <ioapic_init+0x60>
  102363:	83 c4 10             	add    $0x10,%esp
  102366:	5b                   	pop    %ebx
  102367:	5e                   	pop    %esi
  102368:	5d                   	pop    %ebp
  102369:	c3                   	ret    
  10236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102370:	c7 04 24 ac 66 10 00 	movl   $0x1066ac,(%esp)
  102377:	e8 24 e4 ff ff       	call   1007a0 <cprintf>
  10237c:	eb b0                	jmp    10232e <ioapic_init+0x4e>
  10237e:	90                   	nop
  10237f:	90                   	nop

00102380 <kalloc>:
  102380:	55                   	push   %ebp
  102381:	89 e5                	mov    %esp,%ebp
  102383:	56                   	push   %esi
  102384:	53                   	push   %ebx
  102385:	83 ec 10             	sub    $0x10,%esp
  102388:	8b 75 08             	mov    0x8(%ebp),%esi
  10238b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102391:	74 0d                	je     1023a0 <kalloc+0x20>
  102393:	c7 04 24 e0 66 10 00 	movl   $0x1066e0,(%esp)
  10239a:	e8 d1 e5 ff ff       	call   100970 <panic>
  10239f:	90                   	nop
  1023a0:	85 f6                	test   %esi,%esi
  1023a2:	7e ef                	jle    102393 <kalloc+0x13>
  1023a4:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  1023ab:	e8 c0 20 00 00       	call   104470 <acquire>
  1023b0:	8b 1d 14 b7 10 00    	mov    0x10b714,%ebx
  1023b6:	85 db                	test   %ebx,%ebx
  1023b8:	74 3e                	je     1023f8 <kalloc+0x78>
  1023ba:	8b 43 04             	mov    0x4(%ebx),%eax
  1023bd:	ba 14 b7 10 00       	mov    $0x10b714,%edx
  1023c2:	39 f0                	cmp    %esi,%eax
  1023c4:	75 11                	jne    1023d7 <kalloc+0x57>
  1023c6:	eb 58                	jmp    102420 <kalloc+0xa0>
  1023c8:	89 da                	mov    %ebx,%edx
  1023ca:	8b 1b                	mov    (%ebx),%ebx
  1023cc:	85 db                	test   %ebx,%ebx
  1023ce:	74 28                	je     1023f8 <kalloc+0x78>
  1023d0:	8b 43 04             	mov    0x4(%ebx),%eax
  1023d3:	39 f0                	cmp    %esi,%eax
  1023d5:	74 49                	je     102420 <kalloc+0xa0>
  1023d7:	39 c6                	cmp    %eax,%esi
  1023d9:	7d ed                	jge    1023c8 <kalloc+0x48>
  1023db:	29 f0                	sub    %esi,%eax
  1023dd:	89 43 04             	mov    %eax,0x4(%ebx)
  1023e0:	01 c3                	add    %eax,%ebx
  1023e2:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  1023e9:	e8 42 20 00 00       	call   104430 <release>
  1023ee:	83 c4 10             	add    $0x10,%esp
  1023f1:	89 d8                	mov    %ebx,%eax
  1023f3:	5b                   	pop    %ebx
  1023f4:	5e                   	pop    %esi
  1023f5:	5d                   	pop    %ebp
  1023f6:	c3                   	ret    
  1023f7:	90                   	nop
  1023f8:	31 db                	xor    %ebx,%ebx
  1023fa:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  102401:	e8 2a 20 00 00       	call   104430 <release>
  102406:	c7 04 24 e7 66 10 00 	movl   $0x1066e7,(%esp)
  10240d:	e8 8e e3 ff ff       	call   1007a0 <cprintf>
  102412:	83 c4 10             	add    $0x10,%esp
  102415:	89 d8                	mov    %ebx,%eax
  102417:	5b                   	pop    %ebx
  102418:	5e                   	pop    %esi
  102419:	5d                   	pop    %ebp
  10241a:	c3                   	ret    
  10241b:	90                   	nop
  10241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102420:	8b 03                	mov    (%ebx),%eax
  102422:	89 02                	mov    %eax,(%edx)
  102424:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  10242b:	e8 00 20 00 00       	call   104430 <release>
  102430:	83 c4 10             	add    $0x10,%esp
  102433:	89 d8                	mov    %ebx,%eax
  102435:	5b                   	pop    %ebx
  102436:	5e                   	pop    %esi
  102437:	5d                   	pop    %ebp
  102438:	c3                   	ret    
  102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102440 <kfree>:
  102440:	55                   	push   %ebp
  102441:	89 e5                	mov    %esp,%ebp
  102443:	57                   	push   %edi
  102444:	56                   	push   %esi
  102445:	53                   	push   %ebx
  102446:	83 ec 1c             	sub    $0x1c,%esp
  102449:	8b 45 0c             	mov    0xc(%ebp),%eax
  10244c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10244f:	85 c0                	test   %eax,%eax
  102451:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102454:	7e 07                	jle    10245d <kfree+0x1d>
  102456:	a9 ff 0f 00 00       	test   $0xfff,%eax
  10245b:	74 13                	je     102470 <kfree+0x30>
  10245d:	c7 04 24 fe 66 10 00 	movl   $0x1066fe,(%esp)
  102464:	e8 07 e5 ff ff       	call   100970 <panic>
  102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102473:	bf 14 b7 10 00       	mov    $0x10b714,%edi
  102478:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10247f:	00 
  102480:	89 1c 24             	mov    %ebx,(%esp)
  102483:	89 44 24 08          	mov    %eax,0x8(%esp)
  102487:	e8 54 20 00 00       	call   1044e0 <memset>
  10248c:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  102493:	e8 d8 1f 00 00       	call   104470 <acquire>
  102498:	8b 15 14 b7 10 00    	mov    0x10b714,%edx
  10249e:	85 d2                	test   %edx,%edx
  1024a0:	0f 84 82 00 00 00    	je     102528 <kfree+0xe8>
  1024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1024a9:	bf 14 b7 10 00       	mov    $0x10b714,%edi
  1024ae:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  1024b1:	39 d6                	cmp    %edx,%esi
  1024b3:	72 73                	jb     102528 <kfree+0xe8>
  1024b5:	8b 42 04             	mov    0x4(%edx),%eax
  1024b8:	39 d3                	cmp    %edx,%ebx
  1024ba:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  1024bd:	73 61                	jae    102520 <kfree+0xe0>
  1024bf:	39 d6                	cmp    %edx,%esi
  1024c1:	bf 14 b7 10 00       	mov    $0x10b714,%edi
  1024c6:	74 34                	je     1024fc <kfree+0xbc>
  1024c8:	39 d9                	cmp    %ebx,%ecx
  1024ca:	74 6c                	je     102538 <kfree+0xf8>
  1024cc:	89 d7                	mov    %edx,%edi
  1024ce:	8b 12                	mov    (%edx),%edx
  1024d0:	85 d2                	test   %edx,%edx
  1024d2:	74 54                	je     102528 <kfree+0xe8>
  1024d4:	39 d6                	cmp    %edx,%esi
  1024d6:	72 50                	jb     102528 <kfree+0xe8>
  1024d8:	8b 42 04             	mov    0x4(%edx),%eax
  1024db:	39 d3                	cmp    %edx,%ebx
  1024dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  1024e0:	72 16                	jb     1024f8 <kfree+0xb8>
  1024e2:	39 cb                	cmp    %ecx,%ebx
  1024e4:	73 12                	jae    1024f8 <kfree+0xb8>
  1024e6:	c7 04 24 04 67 10 00 	movl   $0x106704,(%esp)
  1024ed:	e8 7e e4 ff ff       	call   100970 <panic>
  1024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1024f8:	39 d6                	cmp    %edx,%esi
  1024fa:	75 cc                	jne    1024c8 <kfree+0x88>
  1024fc:	03 45 f0             	add    -0x10(%ebp),%eax
  1024ff:	89 43 04             	mov    %eax,0x4(%ebx)
  102502:	8b 06                	mov    (%esi),%eax
  102504:	89 03                	mov    %eax,(%ebx)
  102506:	89 1f                	mov    %ebx,(%edi)
  102508:	c7 45 08 e0 b6 10 00 	movl   $0x10b6e0,0x8(%ebp)
  10250f:	83 c4 1c             	add    $0x1c,%esp
  102512:	5b                   	pop    %ebx
  102513:	5e                   	pop    %esi
  102514:	5f                   	pop    %edi
  102515:	5d                   	pop    %ebp
  102516:	e9 15 1f 00 00       	jmp    104430 <release>
  10251b:	90                   	nop
  10251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102520:	39 cb                	cmp    %ecx,%ebx
  102522:	72 c2                	jb     1024e6 <kfree+0xa6>
  102524:	eb 99                	jmp    1024bf <kfree+0x7f>
  102526:	66 90                	xchg   %ax,%ax
  102528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10252b:	89 13                	mov    %edx,(%ebx)
  10252d:	89 1f                	mov    %ebx,(%edi)
  10252f:	89 43 04             	mov    %eax,0x4(%ebx)
  102532:	eb d4                	jmp    102508 <kfree+0xc8>
  102534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102538:	8b 0a                	mov    (%edx),%ecx
  10253a:	03 45 f0             	add    -0x10(%ebp),%eax
  10253d:	85 c9                	test   %ecx,%ecx
  10253f:	89 42 04             	mov    %eax,0x4(%edx)
  102542:	74 c4                	je     102508 <kfree+0xc8>
  102544:	39 ce                	cmp    %ecx,%esi
  102546:	75 c0                	jne    102508 <kfree+0xc8>
  102548:	03 46 04             	add    0x4(%esi),%eax
  10254b:	89 42 04             	mov    %eax,0x4(%edx)
  10254e:	8b 06                	mov    (%esi),%eax
  102550:	89 02                	mov    %eax,(%edx)
  102552:	eb b4                	jmp    102508 <kfree+0xc8>
  102554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10255a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102560 <kinit>:
  102560:	55                   	push   %ebp
  102561:	89 e5                	mov    %esp,%ebp
  102563:	53                   	push   %ebx
  102564:	bb 44 fd 10 00       	mov    $0x10fd44,%ebx
  102569:	83 ec 14             	sub    $0x14,%esp
  10256c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102572:	c7 44 24 04 e0 66 10 	movl   $0x1066e0,0x4(%esp)
  102579:	00 
  10257a:	c7 04 24 e0 b6 10 00 	movl   $0x10b6e0,(%esp)
  102581:	e8 1a 1d 00 00       	call   1042a0 <initlock>
  102586:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10258d:	00 
  10258e:	c7 04 24 16 67 10 00 	movl   $0x106716,(%esp)
  102595:	e8 06 e2 ff ff       	call   1007a0 <cprintf>
  10259a:	89 1c 24             	mov    %ebx,(%esp)
  10259d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1025a4:	00 
  1025a5:	e8 96 fe ff ff       	call   102440 <kfree>
  1025aa:	83 c4 14             	add    $0x14,%esp
  1025ad:	5b                   	pop    %ebx
  1025ae:	5d                   	pop    %ebp
  1025af:	c3                   	ret    

001025b0 <kbd_getc>:
  1025b0:	55                   	push   %ebp
  1025b1:	ba 64 00 00 00       	mov    $0x64,%edx
  1025b6:	89 e5                	mov    %esp,%ebp
  1025b8:	ec                   	in     (%dx),%al
  1025b9:	a8 01                	test   $0x1,%al
  1025bb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1025c0:	74 76                	je     102638 <kbd_getc+0x88>
  1025c2:	ba 60 00 00 00       	mov    $0x60,%edx
  1025c7:	ec                   	in     (%dx),%al
  1025c8:	0f b6 c8             	movzbl %al,%ecx
  1025cb:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
  1025d1:	0f 84 99 00 00 00    	je     102670 <kbd_getc+0xc0>
  1025d7:	84 c9                	test   %cl,%cl
  1025d9:	78 65                	js     102640 <kbd_getc+0x90>
  1025db:	a1 bc 84 10 00       	mov    0x1084bc,%eax
  1025e0:	a8 40                	test   $0x40,%al
  1025e2:	74 0b                	je     1025ef <kbd_getc+0x3f>
  1025e4:	83 e0 bf             	and    $0xffffffbf,%eax
  1025e7:	80 c9 80             	or     $0x80,%cl
  1025ea:	a3 bc 84 10 00       	mov    %eax,0x1084bc
  1025ef:	0f b6 91 20 68 10 00 	movzbl 0x106820(%ecx),%edx
  1025f6:	0f b6 81 20 67 10 00 	movzbl 0x106720(%ecx),%eax
  1025fd:	0b 05 bc 84 10 00    	or     0x1084bc,%eax
  102603:	31 d0                	xor    %edx,%eax
  102605:	89 c2                	mov    %eax,%edx
  102607:	83 e2 03             	and    $0x3,%edx
  10260a:	a8 08                	test   $0x8,%al
  10260c:	8b 14 95 20 69 10 00 	mov    0x106920(,%edx,4),%edx
  102613:	a3 bc 84 10 00       	mov    %eax,0x1084bc
  102618:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  10261c:	74 1a                	je     102638 <kbd_getc+0x88>
  10261e:	8d 42 9f             	lea    -0x61(%edx),%eax
  102621:	83 f8 19             	cmp    $0x19,%eax
  102624:	76 5a                	jbe    102680 <kbd_getc+0xd0>
  102626:	8d 42 bf             	lea    -0x41(%edx),%eax
  102629:	83 f8 19             	cmp    $0x19,%eax
  10262c:	77 0a                	ja     102638 <kbd_getc+0x88>
  10262e:	83 c2 20             	add    $0x20,%edx
  102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102638:	89 d0                	mov    %edx,%eax
  10263a:	5d                   	pop    %ebp
  10263b:	c3                   	ret    
  10263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102640:	8b 15 bc 84 10 00    	mov    0x1084bc,%edx
  102646:	f6 c2 40             	test   $0x40,%dl
  102649:	75 03                	jne    10264e <kbd_getc+0x9e>
  10264b:	83 e1 7f             	and    $0x7f,%ecx
  10264e:	0f b6 81 20 67 10 00 	movzbl 0x106720(%ecx),%eax
  102655:	5d                   	pop    %ebp
  102656:	83 c8 40             	or     $0x40,%eax
  102659:	0f b6 c0             	movzbl %al,%eax
  10265c:	f7 d0                	not    %eax
  10265e:	21 d0                	and    %edx,%eax
  102660:	31 d2                	xor    %edx,%edx
  102662:	a3 bc 84 10 00       	mov    %eax,0x1084bc
  102667:	89 d0                	mov    %edx,%eax
  102669:	c3                   	ret    
  10266a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102670:	31 d2                	xor    %edx,%edx
  102672:	89 d0                	mov    %edx,%eax
  102674:	83 0d bc 84 10 00 40 	orl    $0x40,0x1084bc
  10267b:	5d                   	pop    %ebp
  10267c:	c3                   	ret    
  10267d:	8d 76 00             	lea    0x0(%esi),%esi
  102680:	83 ea 20             	sub    $0x20,%edx
  102683:	eb b3                	jmp    102638 <kbd_getc+0x88>
  102685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102690 <kbd_intr>:
  102690:	55                   	push   %ebp
  102691:	89 e5                	mov    %esp,%ebp
  102693:	83 ec 08             	sub    $0x8,%esp
  102696:	c7 04 24 b0 25 10 00 	movl   $0x1025b0,(%esp)
  10269d:	e8 8e de ff ff       	call   100530 <console_intr>
  1026a2:	c9                   	leave  
  1026a3:	c3                   	ret    
  1026a4:	90                   	nop
  1026a5:	90                   	nop
  1026a6:	90                   	nop
  1026a7:	90                   	nop
  1026a8:	90                   	nop
  1026a9:	90                   	nop
  1026aa:	90                   	nop
  1026ab:	90                   	nop
  1026ac:	90                   	nop
  1026ad:	90                   	nop
  1026ae:	90                   	nop
  1026af:	90                   	nop

001026b0 <lapic_init>:
  1026b0:	8b 15 18 b7 10 00    	mov    0x10b718,%edx
  1026b6:	55                   	push   %ebp
  1026b7:	89 e5                	mov    %esp,%ebp
  1026b9:	85 d2                	test   %edx,%edx
  1026bb:	0f 84 c3 00 00 00    	je     102784 <lapic_init+0xd4>
  1026c1:	c7 82 f0 00 00 00 3f 	movl   $0x13f,0xf0(%edx)
  1026c8:	01 00 00 
  1026cb:	8b 42 20             	mov    0x20(%edx),%eax
  1026ce:	c7 82 e0 03 00 00 0b 	movl   $0xb,0x3e0(%edx)
  1026d5:	00 00 00 
  1026d8:	8b 42 20             	mov    0x20(%edx),%eax
  1026db:	c7 82 20 03 00 00 20 	movl   $0x20020,0x320(%edx)
  1026e2:	00 02 00 
  1026e5:	8b 42 20             	mov    0x20(%edx),%eax
  1026e8:	c7 82 80 03 00 00 80 	movl   $0x989680,0x380(%edx)
  1026ef:	96 98 00 
  1026f2:	8b 42 20             	mov    0x20(%edx),%eax
  1026f5:	c7 82 50 03 00 00 00 	movl   $0x10000,0x350(%edx)
  1026fc:	00 01 00 
  1026ff:	8b 42 20             	mov    0x20(%edx),%eax
  102702:	c7 82 60 03 00 00 00 	movl   $0x10000,0x360(%edx)
  102709:	00 01 00 
  10270c:	8b 42 20             	mov    0x20(%edx),%eax
  10270f:	8b 42 30             	mov    0x30(%edx),%eax
  102712:	c1 e8 10             	shr    $0x10,%eax
  102715:	3c 03                	cmp    $0x3,%al
  102717:	77 6f                	ja     102788 <lapic_init+0xd8>
  102719:	c7 82 70 03 00 00 33 	movl   $0x33,0x370(%edx)
  102720:	00 00 00 
  102723:	8b 42 20             	mov    0x20(%edx),%eax
  102726:	8d 8a 00 03 00 00    	lea    0x300(%edx),%ecx
  10272c:	c7 82 80 02 00 00 00 	movl   $0x0,0x280(%edx)
  102733:	00 00 00 
  102736:	8b 42 20             	mov    0x20(%edx),%eax
  102739:	c7 82 80 02 00 00 00 	movl   $0x0,0x280(%edx)
  102740:	00 00 00 
  102743:	8b 42 20             	mov    0x20(%edx),%eax
  102746:	c7 82 b0 00 00 00 00 	movl   $0x0,0xb0(%edx)
  10274d:	00 00 00 
  102750:	8b 42 20             	mov    0x20(%edx),%eax
  102753:	c7 82 10 03 00 00 00 	movl   $0x0,0x310(%edx)
  10275a:	00 00 00 
  10275d:	8b 42 20             	mov    0x20(%edx),%eax
  102760:	c7 82 00 03 00 00 00 	movl   $0x88500,0x300(%edx)
  102767:	85 08 00 
  10276a:	8b 42 20             	mov    0x20(%edx),%eax
  10276d:	8d 76 00             	lea    0x0(%esi),%esi
  102770:	8b 01                	mov    (%ecx),%eax
  102772:	f6 c4 10             	test   $0x10,%ah
  102775:	75 f9                	jne    102770 <lapic_init+0xc0>
  102777:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
  10277e:	00 00 00 
  102781:	8b 42 20             	mov    0x20(%edx),%eax
  102784:	5d                   	pop    %ebp
  102785:	c3                   	ret    
  102786:	66 90                	xchg   %ax,%ax
  102788:	c7 82 40 03 00 00 00 	movl   $0x10000,0x340(%edx)
  10278f:	00 01 00 
  102792:	8b 42 20             	mov    0x20(%edx),%eax
  102795:	eb 82                	jmp    102719 <lapic_init+0x69>
  102797:	89 f6                	mov    %esi,%esi
  102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001027a0 <lapic_eoi>:
  1027a0:	a1 18 b7 10 00       	mov    0x10b718,%eax
  1027a5:	55                   	push   %ebp
  1027a6:	89 e5                	mov    %esp,%ebp
  1027a8:	85 c0                	test   %eax,%eax
  1027aa:	74 0d                	je     1027b9 <lapic_eoi+0x19>
  1027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  1027b3:	00 00 00 
  1027b6:	8b 40 20             	mov    0x20(%eax),%eax
  1027b9:	5d                   	pop    %ebp
  1027ba:	c3                   	ret    
  1027bb:	90                   	nop
  1027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001027c0 <lapic_startap>:
  1027c0:	55                   	push   %ebp
  1027c1:	ba 70 00 00 00       	mov    $0x70,%edx
  1027c6:	89 e5                	mov    %esp,%ebp
  1027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
  1027cd:	57                   	push   %edi
  1027ce:	56                   	push   %esi
  1027cf:	53                   	push   %ebx
  1027d0:	83 ec 18             	sub    $0x18,%esp
  1027d3:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
  1027d7:	ee                   	out    %al,(%dx)
  1027d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  1027dd:	b2 71                	mov    $0x71,%dl
  1027df:	ee                   	out    %al,(%dx)
  1027e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027e3:	89 cf                	mov    %ecx,%edi
  1027e5:	ba c7 00 00 00       	mov    $0xc7,%edx
  1027ea:	8b 1d 18 b7 10 00    	mov    0x10b718,%ebx
  1027f0:	c1 e7 18             	shl    $0x18,%edi
  1027f3:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  1027fa:	00 00 
  1027fc:	c1 e8 04             	shr    $0x4,%eax
  1027ff:	66 a3 69 04 00 00    	mov    %ax,0x469
  102805:	8d 83 10 03 00 00    	lea    0x310(%ebx),%eax
  10280b:	89 bb 10 03 00 00    	mov    %edi,0x310(%ebx)
  102811:	8d 73 20             	lea    0x20(%ebx),%esi
  102814:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102817:	8b 43 20             	mov    0x20(%ebx),%eax
  10281a:	8d 83 00 03 00 00    	lea    0x300(%ebx),%eax
  102820:	c7 83 00 03 00 00 00 	movl   $0xc500,0x300(%ebx)
  102827:	c5 00 00 
  10282a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10282d:	8b 43 20             	mov    0x20(%ebx),%eax
  102830:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102837:	eb 0e                	jmp    102847 <lapic_startap+0x87>
  102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102840:	85 d2                	test   %edx,%edx
  102842:	74 2b                	je     10286f <lapic_startap+0xaf>
  102844:	83 ea 01             	sub    $0x1,%edx
  102847:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102851:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102856:	7f e8                	jg     102840 <lapic_startap+0x80>
  102858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10285b:	83 c0 01             	add    $0x1,%eax
  10285e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102864:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102869:	7e ed                	jle    102858 <lapic_startap+0x98>
  10286b:	85 d2                	test   %edx,%edx
  10286d:	75 d5                	jne    102844 <lapic_startap+0x84>
  10286f:	c7 83 00 03 00 00 00 	movl   $0x8500,0x300(%ebx)
  102876:	85 00 00 
  102879:	ba 63 00 00 00       	mov    $0x63,%edx
  10287e:	8b 43 20             	mov    0x20(%ebx),%eax
  102881:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102888:	eb 0d                	jmp    102897 <lapic_startap+0xd7>
  10288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102890:	85 d2                	test   %edx,%edx
  102892:	74 2b                	je     1028bf <lapic_startap+0xff>
  102894:	83 ea 01             	sub    $0x1,%edx
  102897:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028a1:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  1028a6:	7f e8                	jg     102890 <lapic_startap+0xd0>
  1028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028ab:	83 c0 01             	add    $0x1,%eax
  1028ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028b4:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  1028b9:	7e ed                	jle    1028a8 <lapic_startap+0xe8>
  1028bb:	85 d2                	test   %edx,%edx
  1028bd:	75 d5                	jne    102894 <lapic_startap+0xd4>
  1028bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1028c2:	31 db                	xor    %ebx,%ebx
  1028c4:	c1 e9 0c             	shr    $0xc,%ecx
  1028c7:	80 cd 06             	or     $0x6,%ch
  1028ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1028cd:	ba c7 00 00 00       	mov    $0xc7,%edx
  1028d2:	89 38                	mov    %edi,(%eax)
  1028d4:	8b 06                	mov    (%esi),%eax
  1028d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1028d9:	89 08                	mov    %ecx,(%eax)
  1028db:	8b 06                	mov    (%esi),%eax
  1028dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028e4:	eb 09                	jmp    1028ef <lapic_startap+0x12f>
  1028e6:	66 90                	xchg   %ax,%ax
  1028e8:	85 d2                	test   %edx,%edx
  1028ea:	74 2c                	je     102918 <lapic_startap+0x158>
  1028ec:	83 ea 01             	sub    $0x1,%edx
  1028ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1028f9:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  1028fe:	7f e8                	jg     1028e8 <lapic_startap+0x128>
  102900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102903:	83 c0 01             	add    $0x1,%eax
  102906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10290c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102911:	7e ed                	jle    102900 <lapic_startap+0x140>
  102913:	85 d2                	test   %edx,%edx
  102915:	75 d5                	jne    1028ec <lapic_startap+0x12c>
  102917:	90                   	nop
  102918:	83 c3 01             	add    $0x1,%ebx
  10291b:	83 fb 02             	cmp    $0x2,%ebx
  10291e:	75 aa                	jne    1028ca <lapic_startap+0x10a>
  102920:	83 c4 18             	add    $0x18,%esp
  102923:	5b                   	pop    %ebx
  102924:	5e                   	pop    %esi
  102925:	5f                   	pop    %edi
  102926:	5d                   	pop    %ebp
  102927:	c3                   	ret    
  102928:	90                   	nop
  102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102930 <cpu>:
  102930:	55                   	push   %ebp
  102931:	89 e5                	mov    %esp,%ebp
  102933:	83 ec 08             	sub    $0x8,%esp
  102936:	9c                   	pushf  
  102937:	58                   	pop    %eax
  102938:	f6 c4 02             	test   $0x2,%ah
  10293b:	74 12                	je     10294f <cpu+0x1f>
  10293d:	8b 15 c0 84 10 00    	mov    0x1084c0,%edx
  102943:	8d 42 01             	lea    0x1(%edx),%eax
  102946:	85 d2                	test   %edx,%edx
  102948:	a3 c0 84 10 00       	mov    %eax,0x1084c0
  10294d:	74 19                	je     102968 <cpu+0x38>
  10294f:	8b 15 18 b7 10 00    	mov    0x10b718,%edx
  102955:	31 c0                	xor    %eax,%eax
  102957:	85 d2                	test   %edx,%edx
  102959:	74 06                	je     102961 <cpu+0x31>
  10295b:	8b 42 20             	mov    0x20(%edx),%eax
  10295e:	c1 e8 18             	shr    $0x18,%eax
  102961:	c9                   	leave  
  102962:	c3                   	ret    
  102963:	90                   	nop
  102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102968:	89 e8                	mov    %ebp,%eax
  10296a:	8b 40 04             	mov    0x4(%eax),%eax
  10296d:	c7 04 24 30 69 10 00 	movl   $0x106930,(%esp)
  102974:	89 44 24 04          	mov    %eax,0x4(%esp)
  102978:	e8 23 de ff ff       	call   1007a0 <cprintf>
  10297d:	eb d0                	jmp    10294f <cpu+0x1f>
  10297f:	90                   	nop

00102980 <mpmain>:
  102980:	55                   	push   %ebp
  102981:	89 e5                	mov    %esp,%ebp
  102983:	53                   	push   %ebx
  102984:	83 ec 14             	sub    $0x14,%esp
  102987:	e8 a4 ff ff ff       	call   102930 <cpu>
  10298c:	c7 04 24 5c 69 10 00 	movl   $0x10695c,(%esp)
  102993:	89 44 24 04          	mov    %eax,0x4(%esp)
  102997:	e8 04 de ff ff       	call   1007a0 <cprintf>
  10299c:	e8 9f 2d 00 00       	call   105740 <idtinit>
  1029a1:	e8 8a ff ff ff       	call   102930 <cpu>
  1029a6:	89 c3                	mov    %eax,%ebx
  1029a8:	e8 c3 01 00 00       	call   102b70 <mp_bcpu>
  1029ad:	39 c3                	cmp    %eax,%ebx
  1029af:	74 0d                	je     1029be <mpmain+0x3e>
  1029b1:	e8 7a ff ff ff       	call   102930 <cpu>
  1029b6:	89 04 24             	mov    %eax,(%esp)
  1029b9:	e8 f2 fc ff ff       	call   1026b0 <lapic_init>
  1029be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1029c5:	e8 36 10 00 00       	call   103a00 <setupsegs>
  1029ca:	e8 61 ff ff ff       	call   102930 <cpu>
  1029cf:	ba 01 00 00 00       	mov    $0x1,%edx
  1029d4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1029da:	8d 88 00 b8 10 00    	lea    0x10b800(%eax),%ecx
  1029e0:	89 d0                	mov    %edx,%eax
  1029e2:	f0 87 01             	lock xchg %eax,(%ecx)
  1029e5:	e8 46 ff ff ff       	call   102930 <cpu>
  1029ea:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1029f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f5:	e8 a6 dd ff ff       	call   1007a0 <cprintf>
  1029fa:	e8 e1 11 00 00       	call   103be0 <scheduler>
  1029ff:	90                   	nop

00102a00 <main>:
  102a00:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102a04:	83 e4 f0             	and    $0xfffffff0,%esp
  102a07:	ff 71 fc             	pushl  -0x4(%ecx)
  102a0a:	b8 44 ed 10 00       	mov    $0x10ed44,%eax
  102a0f:	2d 0e 84 10 00       	sub    $0x10840e,%eax
  102a14:	55                   	push   %ebp
  102a15:	89 e5                	mov    %esp,%ebp
  102a17:	53                   	push   %ebx
  102a18:	51                   	push   %ecx
  102a19:	83 ec 10             	sub    $0x10,%esp
  102a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a27:	00 
  102a28:	c7 04 24 0e 84 10 00 	movl   $0x10840e,(%esp)
  102a2f:	e8 ac 1a 00 00       	call   1044e0 <memset>
  102a34:	e8 c7 01 00 00       	call   102c00 <mp_init>
  102a39:	e8 32 01 00 00       	call   102b70 <mp_bcpu>
  102a3e:	89 04 24             	mov    %eax,(%esp)
  102a41:	e8 6a fc ff ff       	call   1026b0 <lapic_init>
  102a46:	e8 e5 fe ff ff       	call   102930 <cpu>
  102a4b:	c7 04 24 7e 69 10 00 	movl   $0x10697e,(%esp)
  102a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a56:	e8 45 dd ff ff       	call   1007a0 <cprintf>
  102a5b:	e8 20 18 00 00       	call   104280 <pinit>
  102a60:	e8 3b d7 ff ff       	call   1001a0 <binit>
  102a65:	8d 76 00             	lea    0x0(%esi),%esi
  102a68:	e8 93 03 00 00       	call   102e00 <pic_init>
  102a6d:	8d 76 00             	lea    0x0(%esi),%esi
  102a70:	e8 6b f8 ff ff       	call   1022e0 <ioapic_init>
  102a75:	8d 76 00             	lea    0x0(%esi),%esi
  102a78:	e8 e3 fa ff ff       	call   102560 <kinit>
  102a7d:	8d 76 00             	lea    0x0(%esi),%esi
  102a80:	e8 6b 2f 00 00       	call   1059f0 <tvinit>
  102a85:	8d 76 00             	lea    0x0(%esi),%esi
  102a88:	e8 83 e6 ff ff       	call   101110 <fileinit>
  102a8d:	8d 76 00             	lea    0x0(%esi),%esi
  102a90:	e8 3b f5 ff ff       	call   101fd0 <iinit>
  102a95:	8d 76 00             	lea    0x0(%esi),%esi
  102a98:	e8 83 d7 ff ff       	call   100220 <console_init>
  102a9d:	8d 76 00             	lea    0x0(%esi),%esi
  102aa0:	e8 5b f7 ff ff       	call   102200 <ide_init>
  102aa5:	a1 20 b7 10 00       	mov    0x10b720,%eax
  102aaa:	85 c0                	test   %eax,%eax
  102aac:	0f 84 ae 00 00 00    	je     102b60 <main+0x160>
  102ab2:	e8 d9 16 00 00       	call   104190 <userinit>
  102ab7:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102abe:	00 
  102abf:	c7 44 24 04 b4 83 10 	movl   $0x1083b4,0x4(%esp)
  102ac6:	00 
  102ac7:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102ace:	e8 9d 1a 00 00       	call   104570 <memmove>
  102ad3:	69 05 a0 bd 10 00 cc 	imul   $0xcc,0x10bda0,%eax
  102ada:	00 00 00 
  102add:	05 40 b7 10 00       	add    $0x10b740,%eax
  102ae2:	3d 40 b7 10 00       	cmp    $0x10b740,%eax
  102ae7:	76 72                	jbe    102b5b <main+0x15b>
  102ae9:	bb 40 b7 10 00       	mov    $0x10b740,%ebx
  102aee:	66 90                	xchg   %ax,%ax
  102af0:	e8 3b fe ff ff       	call   102930 <cpu>
  102af5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102afb:	05 40 b7 10 00       	add    $0x10b740,%eax
  102b00:	39 c3                	cmp    %eax,%ebx
  102b02:	74 3e                	je     102b42 <main+0x142>
  102b04:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102b0b:	e8 70 f8 ff ff       	call   102380 <kalloc>
  102b10:	c7 05 f8 6f 00 00 80 	movl   $0x102980,0x6ff8
  102b17:	29 10 00 
  102b1a:	05 00 10 00 00       	add    $0x1000,%eax
  102b1f:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
  102b24:	0f b6 03             	movzbl (%ebx),%eax
  102b27:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102b2e:	00 
  102b2f:	89 04 24             	mov    %eax,(%esp)
  102b32:	e8 89 fc ff ff       	call   1027c0 <lapic_startap>
  102b37:	90                   	nop
  102b38:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102b3e:	85 c0                	test   %eax,%eax
  102b40:	74 f6                	je     102b38 <main+0x138>
  102b42:	69 05 a0 bd 10 00 cc 	imul   $0xcc,0x10bda0,%eax
  102b49:	00 00 00 
  102b4c:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102b52:	05 40 b7 10 00       	add    $0x10b740,%eax
  102b57:	39 c3                	cmp    %eax,%ebx
  102b59:	72 95                	jb     102af0 <main+0xf0>
  102b5b:	e8 20 fe ff ff       	call   102980 <mpmain>
  102b60:	e8 7b 2b 00 00       	call   1056e0 <timer_init>
  102b65:	8d 76 00             	lea    0x0(%esi),%esi
  102b68:	e9 45 ff ff ff       	jmp    102ab2 <main+0xb2>
  102b6d:	90                   	nop
  102b6e:	90                   	nop
  102b6f:	90                   	nop

00102b70 <mp_bcpu>:
  102b70:	a1 c4 84 10 00       	mov    0x1084c4,%eax
  102b75:	55                   	push   %ebp
  102b76:	89 e5                	mov    %esp,%ebp
  102b78:	5d                   	pop    %ebp
  102b79:	2d 40 b7 10 00       	sub    $0x10b740,%eax
  102b7e:	c1 f8 02             	sar    $0x2,%eax
  102b81:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
  102b87:	c3                   	ret    
  102b88:	90                   	nop
  102b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102b90 <mp_search1>:
  102b90:	55                   	push   %ebp
  102b91:	89 e5                	mov    %esp,%ebp
  102b93:	56                   	push   %esi
  102b94:	53                   	push   %ebx
  102b95:	8d 34 10             	lea    (%eax,%edx,1),%esi
  102b98:	83 ec 10             	sub    $0x10,%esp
  102b9b:	39 f0                	cmp    %esi,%eax
  102b9d:	73 42                	jae    102be1 <mp_search1+0x51>
  102b9f:	89 c3                	mov    %eax,%ebx
  102ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102ba8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102baf:	00 
  102bb0:	c7 44 24 04 95 69 10 	movl   $0x106995,0x4(%esp)
  102bb7:	00 
  102bb8:	89 1c 24             	mov    %ebx,(%esp)
  102bbb:	e8 50 19 00 00       	call   104510 <memcmp>
  102bc0:	85 c0                	test   %eax,%eax
  102bc2:	75 16                	jne    102bda <mp_search1+0x4a>
  102bc4:	31 d2                	xor    %edx,%edx
  102bc6:	31 c9                	xor    %ecx,%ecx
  102bc8:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
  102bcc:	83 c2 01             	add    $0x1,%edx
  102bcf:	01 c1                	add    %eax,%ecx
  102bd1:	83 fa 10             	cmp    $0x10,%edx
  102bd4:	75 f2                	jne    102bc8 <mp_search1+0x38>
  102bd6:	84 c9                	test   %cl,%cl
  102bd8:	74 10                	je     102bea <mp_search1+0x5a>
  102bda:	83 c3 10             	add    $0x10,%ebx
  102bdd:	39 de                	cmp    %ebx,%esi
  102bdf:	77 c7                	ja     102ba8 <mp_search1+0x18>
  102be1:	83 c4 10             	add    $0x10,%esp
  102be4:	31 c0                	xor    %eax,%eax
  102be6:	5b                   	pop    %ebx
  102be7:	5e                   	pop    %esi
  102be8:	5d                   	pop    %ebp
  102be9:	c3                   	ret    
  102bea:	83 c4 10             	add    $0x10,%esp
  102bed:	89 d8                	mov    %ebx,%eax
  102bef:	5b                   	pop    %ebx
  102bf0:	5e                   	pop    %esi
  102bf1:	5d                   	pop    %ebp
  102bf2:	c3                   	ret    
  102bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102c00 <mp_init>:
  102c00:	55                   	push   %ebp
  102c01:	89 e5                	mov    %esp,%ebp
  102c03:	57                   	push   %edi
  102c04:	56                   	push   %esi
  102c05:	53                   	push   %ebx
  102c06:	83 ec 1c             	sub    $0x1c,%esp
  102c09:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  102c10:	69 05 a0 bd 10 00 cc 	imul   $0xcc,0x10bda0,%eax
  102c17:	00 00 00 
  102c1a:	c1 e1 08             	shl    $0x8,%ecx
  102c1d:	05 40 b7 10 00       	add    $0x10b740,%eax
  102c22:	a3 c4 84 10 00       	mov    %eax,0x1084c4
  102c27:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102c2e:	09 c1                	or     %eax,%ecx
  102c30:	c1 e1 04             	shl    $0x4,%ecx
  102c33:	85 c9                	test   %ecx,%ecx
  102c35:	74 51                	je     102c88 <mp_init+0x88>
  102c37:	ba 00 04 00 00       	mov    $0x400,%edx
  102c3c:	89 c8                	mov    %ecx,%eax
  102c3e:	e8 4d ff ff ff       	call   102b90 <mp_search1>
  102c43:	85 c0                	test   %eax,%eax
  102c45:	89 c7                	mov    %eax,%edi
  102c47:	74 6a                	je     102cb3 <mp_init+0xb3>
  102c49:	8b 5f 04             	mov    0x4(%edi),%ebx
  102c4c:	85 db                	test   %ebx,%ebx
  102c4e:	74 30                	je     102c80 <mp_init+0x80>
  102c50:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102c57:	00 
  102c58:	c7 44 24 04 9a 69 10 	movl   $0x10699a,0x4(%esp)
  102c5f:	00 
  102c60:	89 1c 24             	mov    %ebx,(%esp)
  102c63:	e8 a8 18 00 00       	call   104510 <memcmp>
  102c68:	85 c0                	test   %eax,%eax
  102c6a:	75 14                	jne    102c80 <mp_init+0x80>
  102c6c:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102c70:	3c 01                	cmp    $0x1,%al
  102c72:	74 5c                	je     102cd0 <mp_init+0xd0>
  102c74:	3c 04                	cmp    $0x4,%al
  102c76:	66 90                	xchg   %ax,%ax
  102c78:	74 56                	je     102cd0 <mp_init+0xd0>
  102c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102c80:	83 c4 1c             	add    $0x1c,%esp
  102c83:	5b                   	pop    %ebx
  102c84:	5e                   	pop    %esi
  102c85:	5f                   	pop    %edi
  102c86:	5d                   	pop    %ebp
  102c87:	c3                   	ret    
  102c88:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102c8f:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102c96:	c1 e0 08             	shl    $0x8,%eax
  102c99:	09 d0                	or     %edx,%eax
  102c9b:	ba 00 04 00 00       	mov    $0x400,%edx
  102ca0:	c1 e0 0a             	shl    $0xa,%eax
  102ca3:	2d 00 04 00 00       	sub    $0x400,%eax
  102ca8:	e8 e3 fe ff ff       	call   102b90 <mp_search1>
  102cad:	85 c0                	test   %eax,%eax
  102caf:	89 c7                	mov    %eax,%edi
  102cb1:	75 96                	jne    102c49 <mp_init+0x49>
  102cb3:	ba 00 00 01 00       	mov    $0x10000,%edx
  102cb8:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102cbd:	e8 ce fe ff ff       	call   102b90 <mp_search1>
  102cc2:	85 c0                	test   %eax,%eax
  102cc4:	89 c7                	mov    %eax,%edi
  102cc6:	75 81                	jne    102c49 <mp_init+0x49>
  102cc8:	83 c4 1c             	add    $0x1c,%esp
  102ccb:	5b                   	pop    %ebx
  102ccc:	5e                   	pop    %esi
  102ccd:	5f                   	pop    %edi
  102cce:	5d                   	pop    %ebp
  102ccf:	c3                   	ret    
  102cd0:	0f b7 73 04          	movzwl 0x4(%ebx),%esi
  102cd4:	85 f6                	test   %esi,%esi
  102cd6:	74 19                	je     102cf1 <mp_init+0xf1>
  102cd8:	31 d2                	xor    %edx,%edx
  102cda:	31 c9                	xor    %ecx,%ecx
  102cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102ce0:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
  102ce4:	83 c2 01             	add    $0x1,%edx
  102ce7:	01 c1                	add    %eax,%ecx
  102ce9:	39 d6                	cmp    %edx,%esi
  102ceb:	7f f3                	jg     102ce0 <mp_init+0xe0>
  102ced:	84 c9                	test   %cl,%cl
  102cef:	75 8f                	jne    102c80 <mp_init+0x80>
  102cf1:	8b 43 24             	mov    0x24(%ebx),%eax
  102cf4:	8d 34 33             	lea    (%ebx,%esi,1),%esi
  102cf7:	8d 53 2c             	lea    0x2c(%ebx),%edx
  102cfa:	39 f2                	cmp    %esi,%edx
  102cfc:	c7 05 20 b7 10 00 01 	movl   $0x1,0x10b720
  102d03:	00 00 00 
  102d06:	a3 18 b7 10 00       	mov    %eax,0x10b718
  102d0b:	89 75 f0             	mov    %esi,-0x10(%ebp)
  102d0e:	73 5f                	jae    102d6f <mp_init+0x16f>
  102d10:	8b 35 c4 84 10 00    	mov    0x1084c4,%esi
  102d16:	0f b6 02             	movzbl (%edx),%eax
  102d19:	3c 04                	cmp    $0x4,%al
  102d1b:	76 2b                	jbe    102d48 <mp_init+0x148>
  102d1d:	0f b6 c0             	movzbl %al,%eax
  102d20:	89 35 c4 84 10 00    	mov    %esi,0x1084c4
  102d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d2a:	c7 04 24 a8 69 10 00 	movl   $0x1069a8,(%esp)
  102d31:	e8 6a da ff ff       	call   1007a0 <cprintf>
  102d36:	c7 04 24 9f 69 10 00 	movl   $0x10699f,(%esp)
  102d3d:	e8 2e dc ff ff       	call   100970 <panic>
  102d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d48:	0f b6 c0             	movzbl %al,%eax
  102d4b:	ff 24 85 cc 69 10 00 	jmp    *0x1069cc(,%eax,4)
  102d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d58:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102d5c:	83 c2 08             	add    $0x8,%edx
  102d5f:	a2 24 b7 10 00       	mov    %al,0x10b724
  102d64:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  102d67:	77 ad                	ja     102d16 <mp_init+0x116>
  102d69:	89 35 c4 84 10 00    	mov    %esi,0x1084c4
  102d6f:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
  102d73:	0f 84 07 ff ff ff    	je     102c80 <mp_init+0x80>
  102d79:	ba 22 00 00 00       	mov    $0x22,%edx
  102d7e:	b8 70 00 00 00       	mov    $0x70,%eax
  102d83:	ee                   	out    %al,(%dx)
  102d84:	b2 23                	mov    $0x23,%dl
  102d86:	ec                   	in     (%dx),%al
  102d87:	83 c8 01             	or     $0x1,%eax
  102d8a:	ee                   	out    %al,(%dx)
  102d8b:	e9 f0 fe ff ff       	jmp    102c80 <mp_init+0x80>
  102d90:	83 c2 08             	add    $0x8,%edx
  102d93:	eb cf                	jmp    102d64 <mp_init+0x164>
  102d95:	8d 76 00             	lea    0x0(%esi),%esi
  102d98:	8b 1d a0 bd 10 00    	mov    0x10bda0,%ebx
  102d9e:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102da2:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102da8:	88 81 40 b7 10 00    	mov    %al,0x10b740(%ecx)
  102dae:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102db2:	74 06                	je     102dba <mp_init+0x1ba>
  102db4:	8d b1 40 b7 10 00    	lea    0x10b740(%ecx),%esi
  102dba:	8d 43 01             	lea    0x1(%ebx),%eax
  102dbd:	83 c2 14             	add    $0x14,%edx
  102dc0:	a3 a0 bd 10 00       	mov    %eax,0x10bda0
  102dc5:	eb 9d                	jmp    102d64 <mp_init+0x164>
  102dc7:	90                   	nop
  102dc8:	90                   	nop
  102dc9:	90                   	nop
  102dca:	90                   	nop
  102dcb:	90                   	nop
  102dcc:	90                   	nop
  102dcd:	90                   	nop
  102dce:	90                   	nop
  102dcf:	90                   	nop

00102dd0 <pic_enable>:
  102dd0:	55                   	push   %ebp
  102dd1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  102dd6:	89 e5                	mov    %esp,%ebp
  102dd8:	ba 21 00 00 00       	mov    $0x21,%edx
  102ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102de0:	d3 c0                	rol    %cl,%eax
  102de2:	66 23 05 80 7f 10 00 	and    0x107f80,%ax
  102de9:	66 a3 80 7f 10 00    	mov    %ax,0x107f80
  102def:	ee                   	out    %al,(%dx)
  102df0:	66 c1 e8 08          	shr    $0x8,%ax
  102df4:	b2 a1                	mov    $0xa1,%dl
  102df6:	ee                   	out    %al,(%dx)
  102df7:	5d                   	pop    %ebp
  102df8:	c3                   	ret    
  102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102e00 <pic_init>:
  102e00:	55                   	push   %ebp
  102e01:	b9 21 00 00 00       	mov    $0x21,%ecx
  102e06:	89 e5                	mov    %esp,%ebp
  102e08:	83 ec 0c             	sub    $0xc,%esp
  102e0b:	89 1c 24             	mov    %ebx,(%esp)
  102e0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102e13:	89 ca                	mov    %ecx,%edx
  102e15:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e19:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102e1d:	ee                   	out    %al,(%dx)
  102e1e:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102e23:	89 da                	mov    %ebx,%edx
  102e25:	ee                   	out    %al,(%dx)
  102e26:	be 20 00 00 00       	mov    $0x20,%esi
  102e2b:	b8 11 00 00 00       	mov    $0x11,%eax
  102e30:	89 f2                	mov    %esi,%edx
  102e32:	ee                   	out    %al,(%dx)
  102e33:	b8 20 00 00 00       	mov    $0x20,%eax
  102e38:	89 ca                	mov    %ecx,%edx
  102e3a:	ee                   	out    %al,(%dx)
  102e3b:	b8 04 00 00 00       	mov    $0x4,%eax
  102e40:	ee                   	out    %al,(%dx)
  102e41:	bf 03 00 00 00       	mov    $0x3,%edi
  102e46:	89 f8                	mov    %edi,%eax
  102e48:	ee                   	out    %al,(%dx)
  102e49:	b1 a0                	mov    $0xa0,%cl
  102e4b:	b8 11 00 00 00       	mov    $0x11,%eax
  102e50:	89 ca                	mov    %ecx,%edx
  102e52:	ee                   	out    %al,(%dx)
  102e53:	b8 28 00 00 00       	mov    $0x28,%eax
  102e58:	89 da                	mov    %ebx,%edx
  102e5a:	ee                   	out    %al,(%dx)
  102e5b:	b8 02 00 00 00       	mov    $0x2,%eax
  102e60:	ee                   	out    %al,(%dx)
  102e61:	89 f8                	mov    %edi,%eax
  102e63:	ee                   	out    %al,(%dx)
  102e64:	bb 68 00 00 00       	mov    $0x68,%ebx
  102e69:	89 f2                	mov    %esi,%edx
  102e6b:	89 d8                	mov    %ebx,%eax
  102e6d:	ee                   	out    %al,(%dx)
  102e6e:	bf 0a 00 00 00       	mov    $0xa,%edi
  102e73:	89 f8                	mov    %edi,%eax
  102e75:	ee                   	out    %al,(%dx)
  102e76:	89 d8                	mov    %ebx,%eax
  102e78:	89 ca                	mov    %ecx,%edx
  102e7a:	ee                   	out    %al,(%dx)
  102e7b:	89 f8                	mov    %edi,%eax
  102e7d:	ee                   	out    %al,(%dx)
  102e7e:	0f b7 05 80 7f 10 00 	movzwl 0x107f80,%eax
  102e85:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102e89:	74 0a                	je     102e95 <pic_init+0x95>
  102e8b:	b2 21                	mov    $0x21,%dl
  102e8d:	ee                   	out    %al,(%dx)
  102e8e:	66 c1 e8 08          	shr    $0x8,%ax
  102e92:	b2 a1                	mov    $0xa1,%dl
  102e94:	ee                   	out    %al,(%dx)
  102e95:	8b 1c 24             	mov    (%esp),%ebx
  102e98:	8b 74 24 04          	mov    0x4(%esp),%esi
  102e9c:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102ea0:	89 ec                	mov    %ebp,%esp
  102ea2:	5d                   	pop    %ebp
  102ea3:	c3                   	ret    
  102ea4:	90                   	nop
  102ea5:	90                   	nop
  102ea6:	90                   	nop
  102ea7:	90                   	nop
  102ea8:	90                   	nop
  102ea9:	90                   	nop
  102eaa:	90                   	nop
  102eab:	90                   	nop
  102eac:	90                   	nop
  102ead:	90                   	nop
  102eae:	90                   	nop
  102eaf:	90                   	nop

00102eb0 <piperead>:
  102eb0:	55                   	push   %ebp
  102eb1:	89 e5                	mov    %esp,%ebp
  102eb3:	57                   	push   %edi
  102eb4:	56                   	push   %esi
  102eb5:	53                   	push   %ebx
  102eb6:	83 ec 0c             	sub    $0xc,%esp
  102eb9:	8b 75 08             	mov    0x8(%ebp),%esi
  102ebc:	8d 7e 10             	lea    0x10(%esi),%edi
  102ebf:	89 3c 24             	mov    %edi,(%esp)
  102ec2:	e8 a9 15 00 00       	call   104470 <acquire>
  102ec7:	8b 46 0c             	mov    0xc(%esi),%eax
  102eca:	3b 46 08             	cmp    0x8(%esi),%eax
  102ecd:	75 51                	jne    102f20 <piperead+0x70>
  102ecf:	8b 56 04             	mov    0x4(%esi),%edx
  102ed2:	85 d2                	test   %edx,%edx
  102ed4:	74 4a                	je     102f20 <piperead+0x70>
  102ed6:	8d 5e 0c             	lea    0xc(%esi),%ebx
  102ed9:	eb 20                	jmp    102efb <piperead+0x4b>
  102edb:	90                   	nop
  102edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102ee0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102ee4:	89 1c 24             	mov    %ebx,(%esp)
  102ee7:	e8 04 08 00 00       	call   1036f0 <sleep>
  102eec:	8b 46 0c             	mov    0xc(%esi),%eax
  102eef:	3b 46 08             	cmp    0x8(%esi),%eax
  102ef2:	75 2c                	jne    102f20 <piperead+0x70>
  102ef4:	8b 4e 04             	mov    0x4(%esi),%ecx
  102ef7:	85 c9                	test   %ecx,%ecx
  102ef9:	74 25                	je     102f20 <piperead+0x70>
  102efb:	e8 90 05 00 00       	call   103490 <curproc>
  102f00:	8b 40 1c             	mov    0x1c(%eax),%eax
  102f03:	85 c0                	test   %eax,%eax
  102f05:	74 d9                	je     102ee0 <piperead+0x30>
  102f07:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  102f0c:	89 3c 24             	mov    %edi,(%esp)
  102f0f:	e8 1c 15 00 00       	call   104430 <release>
  102f14:	83 c4 0c             	add    $0xc,%esp
  102f17:	89 d8                	mov    %ebx,%eax
  102f19:	5b                   	pop    %ebx
  102f1a:	5e                   	pop    %esi
  102f1b:	5f                   	pop    %edi
  102f1c:	5d                   	pop    %ebp
  102f1d:	c3                   	ret    
  102f1e:	66 90                	xchg   %ax,%ax
  102f20:	8b 55 10             	mov    0x10(%ebp),%edx
  102f23:	85 d2                	test   %edx,%edx
  102f25:	7e 58                	jle    102f7f <piperead+0xcf>
  102f27:	31 db                	xor    %ebx,%ebx
  102f29:	89 c2                	mov    %eax,%edx
  102f2b:	3b 46 08             	cmp    0x8(%esi),%eax
  102f2e:	75 12                	jne    102f42 <piperead+0x92>
  102f30:	eb 4d                	jmp    102f7f <piperead+0xcf>
  102f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102f38:	39 56 08             	cmp    %edx,0x8(%esi)
  102f3b:	90                   	nop
  102f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102f40:	74 20                	je     102f62 <piperead+0xb2>
  102f42:	89 d0                	mov    %edx,%eax
  102f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102f47:	83 c2 01             	add    $0x1,%edx
  102f4a:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f4f:	0f b6 44 06 44       	movzbl 0x44(%esi,%eax,1),%eax
  102f54:	88 04 19             	mov    %al,(%ecx,%ebx,1)
  102f57:	83 c3 01             	add    $0x1,%ebx
  102f5a:	39 5d 10             	cmp    %ebx,0x10(%ebp)
  102f5d:	89 56 0c             	mov    %edx,0xc(%esi)
  102f60:	7f d6                	jg     102f38 <piperead+0x88>
  102f62:	8d 46 08             	lea    0x8(%esi),%eax
  102f65:	89 04 24             	mov    %eax,(%esp)
  102f68:	e8 23 04 00 00       	call   103390 <wakeup>
  102f6d:	89 3c 24             	mov    %edi,(%esp)
  102f70:	e8 bb 14 00 00       	call   104430 <release>
  102f75:	83 c4 0c             	add    $0xc,%esp
  102f78:	89 d8                	mov    %ebx,%eax
  102f7a:	5b                   	pop    %ebx
  102f7b:	5e                   	pop    %esi
  102f7c:	5f                   	pop    %edi
  102f7d:	5d                   	pop    %ebp
  102f7e:	c3                   	ret    
  102f7f:	31 db                	xor    %ebx,%ebx
  102f81:	eb df                	jmp    102f62 <piperead+0xb2>
  102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102f90 <pipewrite>:
  102f90:	55                   	push   %ebp
  102f91:	89 e5                	mov    %esp,%ebp
  102f93:	57                   	push   %edi
  102f94:	56                   	push   %esi
  102f95:	53                   	push   %ebx
  102f96:	83 ec 1c             	sub    $0x1c,%esp
  102f99:	8b 75 08             	mov    0x8(%ebp),%esi
  102f9c:	8d 46 10             	lea    0x10(%esi),%eax
  102f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fa2:	89 04 24             	mov    %eax,(%esp)
  102fa5:	e8 c6 14 00 00       	call   104470 <acquire>
  102faa:	8b 7d 10             	mov    0x10(%ebp),%edi
  102fad:	85 ff                	test   %edi,%edi
  102faf:	0f 8e ca 00 00 00    	jle    10307f <pipewrite+0xef>
  102fb5:	8b 5e 0c             	mov    0xc(%esi),%ebx
  102fb8:	8d 56 08             	lea    0x8(%esi),%edx
  102fbb:	8d 7e 0c             	lea    0xc(%esi),%edi
  102fbe:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102fc8:	8b 4e 08             	mov    0x8(%esi),%ecx
  102fcb:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  102fd1:	39 c1                	cmp    %eax,%ecx
  102fd3:	74 3f                	je     103014 <pipewrite+0x84>
  102fd5:	eb 61                	jmp    103038 <pipewrite+0xa8>
  102fd7:	90                   	nop
  102fd8:	e8 b3 04 00 00       	call   103490 <curproc>
  102fdd:	8b 48 1c             	mov    0x1c(%eax),%ecx
  102fe0:	85 c9                	test   %ecx,%ecx
  102fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102fe8:	75 30                	jne    10301a <pipewrite+0x8a>
  102fea:	89 3c 24             	mov    %edi,(%esp)
  102fed:	e8 9e 03 00 00       	call   103390 <wakeup>
  102ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ff8:	89 04 24             	mov    %eax,(%esp)
  102ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
  102fff:	e8 ec 06 00 00       	call   1036f0 <sleep>
  103004:	8b 5e 0c             	mov    0xc(%esi),%ebx
  103007:	8b 4e 08             	mov    0x8(%esi),%ecx
  10300a:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  103010:	39 c1                	cmp    %eax,%ecx
  103012:	75 24                	jne    103038 <pipewrite+0xa8>
  103014:	8b 1e                	mov    (%esi),%ebx
  103016:	85 db                	test   %ebx,%ebx
  103018:	75 be                	jne    102fd8 <pipewrite+0x48>
  10301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10301d:	89 04 24             	mov    %eax,(%esp)
  103020:	e8 0b 14 00 00       	call   104430 <release>
  103025:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
  10302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10302f:	83 c4 1c             	add    $0x1c,%esp
  103032:	5b                   	pop    %ebx
  103033:	5e                   	pop    %esi
  103034:	5f                   	pop    %edi
  103035:	5d                   	pop    %ebp
  103036:	c3                   	ret    
  103037:	90                   	nop
  103038:	89 ca                	mov    %ecx,%edx
  10303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303d:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  103043:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103046:	8b 55 0c             	mov    0xc(%ebp),%edx
  103049:	0f b6 04 02          	movzbl (%edx,%eax,1),%eax
  10304d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103050:	88 44 16 44          	mov    %al,0x44(%esi,%edx,1)
  103054:	8d 41 01             	lea    0x1(%ecx),%eax
  103057:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  10305b:	89 46 08             	mov    %eax,0x8(%esi)
  10305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103061:	39 45 10             	cmp    %eax,0x10(%ebp)
  103064:	0f 8f 5e ff ff ff    	jg     102fc8 <pipewrite+0x38>
  10306a:	89 3c 24             	mov    %edi,(%esp)
  10306d:	e8 1e 03 00 00       	call   103390 <wakeup>
  103072:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103075:	89 14 24             	mov    %edx,(%esp)
  103078:	e8 b3 13 00 00       	call   104430 <release>
  10307d:	eb ad                	jmp    10302c <pipewrite+0x9c>
  10307f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103086:	8d 7e 0c             	lea    0xc(%esi),%edi
  103089:	eb df                	jmp    10306a <pipewrite+0xda>
  10308b:	90                   	nop
  10308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103090 <pipeclose>:
  103090:	55                   	push   %ebp
  103091:	89 e5                	mov    %esp,%ebp
  103093:	83 ec 18             	sub    $0x18,%esp
  103096:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103099:	8b 75 08             	mov    0x8(%ebp),%esi
  10309c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10309f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1030a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1030a5:	8d 7e 10             	lea    0x10(%esi),%edi
  1030a8:	89 3c 24             	mov    %edi,(%esp)
  1030ab:	e8 c0 13 00 00       	call   104470 <acquire>
  1030b0:	85 db                	test   %ebx,%ebx
  1030b2:	74 34                	je     1030e8 <pipeclose+0x58>
  1030b4:	8d 46 0c             	lea    0xc(%esi),%eax
  1030b7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
  1030be:	89 04 24             	mov    %eax,(%esp)
  1030c1:	e8 ca 02 00 00       	call   103390 <wakeup>
  1030c6:	89 3c 24             	mov    %edi,(%esp)
  1030c9:	e8 62 13 00 00       	call   104430 <release>
  1030ce:	8b 06                	mov    (%esi),%eax
  1030d0:	85 c0                	test   %eax,%eax
  1030d2:	75 07                	jne    1030db <pipeclose+0x4b>
  1030d4:	8b 46 04             	mov    0x4(%esi),%eax
  1030d7:	85 c0                	test   %eax,%eax
  1030d9:	74 25                	je     103100 <pipeclose+0x70>
  1030db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1030de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1030e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1030e4:	89 ec                	mov    %ebp,%esp
  1030e6:	5d                   	pop    %ebp
  1030e7:	c3                   	ret    
  1030e8:	8d 46 08             	lea    0x8(%esi),%eax
  1030eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  1030f1:	89 04 24             	mov    %eax,(%esp)
  1030f4:	e8 97 02 00 00       	call   103390 <wakeup>
  1030f9:	eb cb                	jmp    1030c6 <pipeclose+0x36>
  1030fb:	90                   	nop
  1030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103100:	89 75 08             	mov    %esi,0x8(%ebp)
  103103:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103106:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
  10310d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103110:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103113:	89 ec                	mov    %ebp,%esp
  103115:	5d                   	pop    %ebp
  103116:	e9 25 f3 ff ff       	jmp    102440 <kfree>
  10311b:	90                   	nop
  10311c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103120 <pipealloc>:
  103120:	55                   	push   %ebp
  103121:	89 e5                	mov    %esp,%ebp
  103123:	83 ec 18             	sub    $0x18,%esp
  103126:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103129:	8b 75 08             	mov    0x8(%ebp),%esi
  10312c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10312f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103132:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103135:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10313b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  103141:	e8 7a de ff ff       	call   100fc0 <filealloc>
  103146:	85 c0                	test   %eax,%eax
  103148:	89 06                	mov    %eax,(%esi)
  10314a:	0f 84 a4 00 00 00    	je     1031f4 <pipealloc+0xd4>
  103150:	e8 6b de ff ff       	call   100fc0 <filealloc>
  103155:	85 c0                	test   %eax,%eax
  103157:	89 07                	mov    %eax,(%edi)
  103159:	0f 84 81 00 00 00    	je     1031e0 <pipealloc+0xc0>
  10315f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103166:	e8 15 f2 ff ff       	call   102380 <kalloc>
  10316b:	85 c0                	test   %eax,%eax
  10316d:	89 c3                	mov    %eax,%ebx
  10316f:	74 6f                	je     1031e0 <pipealloc+0xc0>
  103171:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  103177:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  10317e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  103185:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  10318c:	8d 40 10             	lea    0x10(%eax),%eax
  10318f:	89 04 24             	mov    %eax,(%esp)
  103192:	c7 44 24 04 e0 69 10 	movl   $0x1069e0,0x4(%esp)
  103199:	00 
  10319a:	e8 01 11 00 00       	call   1042a0 <initlock>
  10319f:	8b 06                	mov    (%esi),%eax
  1031a1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  1031a5:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  1031ab:	8b 06                	mov    (%esi),%eax
  1031ad:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  1031b1:	8b 06                	mov    (%esi),%eax
  1031b3:	89 58 0c             	mov    %ebx,0xc(%eax)
  1031b6:	8b 07                	mov    (%edi),%eax
  1031b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  1031bc:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  1031c2:	8b 07                	mov    (%edi),%eax
  1031c4:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  1031c8:	8b 07                	mov    (%edi),%eax
  1031ca:	89 58 0c             	mov    %ebx,0xc(%eax)
  1031cd:	31 c0                	xor    %eax,%eax
  1031cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1031d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1031d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1031d8:	89 ec                	mov    %ebp,%esp
  1031da:	5d                   	pop    %ebp
  1031db:	c3                   	ret    
  1031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1031e0:	8b 06                	mov    (%esi),%eax
  1031e2:	85 c0                	test   %eax,%eax
  1031e4:	74 0e                	je     1031f4 <pipealloc+0xd4>
  1031e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  1031ec:	89 04 24             	mov    %eax,(%esp)
  1031ef:	e8 4c de ff ff       	call   101040 <fileclose>
  1031f4:	8b 17                	mov    (%edi),%edx
  1031f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1031fb:	85 d2                	test   %edx,%edx
  1031fd:	74 d0                	je     1031cf <pipealloc+0xaf>
  1031ff:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  103205:	89 14 24             	mov    %edx,(%esp)
  103208:	e8 33 de ff ff       	call   101040 <fileclose>
  10320d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103212:	eb bb                	jmp    1031cf <pipealloc+0xaf>
  103214:	90                   	nop
  103215:	90                   	nop
  103216:	90                   	nop
  103217:	90                   	nop
  103218:	90                   	nop
  103219:	90                   	nop
  10321a:	90                   	nop
  10321b:	90                   	nop
  10321c:	90                   	nop
  10321d:	90                   	nop
  10321e:	90                   	nop
  10321f:	90                   	nop

00103220 <tick>:
  }
}

int
tick(void)
{
  103220:	55                   	push   %ebp
return ticks;
}
  103221:	a1 40 ed 10 00       	mov    0x10ed40,%eax
  }
}

int
tick(void)
{
  103226:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103228:	5d                   	pop    %ebp
  103229:	c3                   	ret    
  10322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103230:	55                   	push   %ebp
  103231:	89 e5                	mov    %esp,%ebp
  103233:	57                   	push   %edi
  103234:	56                   	push   %esi
  103235:	53                   	push   %ebx
  103236:	bb cc bd 10 00       	mov    $0x10bdcc,%ebx
  10323b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10323e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103241:	eb 50                	jmp    103293 <procdump+0x63>
  103243:	90                   	nop
  103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103248:	8b 04 85 c0 6a 10 00 	mov    0x106ac0(,%eax,4),%eax
  10324f:	85 c0                	test   %eax,%eax
  103251:	74 4e                	je     1032a1 <procdump+0x71>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103253:	89 44 24 08          	mov    %eax,0x8(%esp)
  103257:	8b 43 04             	mov    0x4(%ebx),%eax
  10325a:	81 c2 88 00 00 00    	add    $0x88,%edx
  103260:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103264:	c7 04 24 e9 69 10 00 	movl   $0x1069e9,(%esp)
  10326b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326f:	e8 2c d5 ff ff       	call   1007a0 <cprintf>
    if(p->state == SLEEPING){
  103274:	83 3b 02             	cmpl   $0x2,(%ebx)
  103277:	74 2f                	je     1032a8 <procdump+0x78>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  103279:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  103280:	e8 1b d5 ff ff       	call   1007a0 <cprintf>
  103285:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  10328b:	81 fb cc e4 10 00    	cmp    $0x10e4cc,%ebx
  103291:	74 55                	je     1032e8 <procdump+0xb8>
    p = &proc[i];
    if(p->state == UNUSED)
  103293:	8b 03                	mov    (%ebx),%eax

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103295:	8d 53 f4             	lea    -0xc(%ebx),%edx
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  103298:	85 c0                	test   %eax,%eax
  10329a:	74 e9                	je     103285 <procdump+0x55>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  10329c:	83 f8 05             	cmp    $0x5,%eax
  10329f:	76 a7                	jbe    103248 <procdump+0x18>
  1032a1:	b8 e5 69 10 00       	mov    $0x1069e5,%eax
  1032a6:	eb ab                	jmp    103253 <procdump+0x23>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1032a8:	8b 43 74             	mov    0x74(%ebx),%eax
  1032ab:	31 f6                	xor    %esi,%esi
  1032ad:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1032b1:	83 c0 08             	add    $0x8,%eax
  1032b4:	89 04 24             	mov    %eax,(%esp)
  1032b7:	e8 04 10 00 00       	call   1042c0 <getcallerpcs>
  1032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1032c0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  1032c3:	85 c0                	test   %eax,%eax
  1032c5:	74 b2                	je     103279 <procdump+0x49>
  1032c7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  1032ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ce:	c7 04 24 55 65 10 00 	movl   $0x106555,(%esp)
  1032d5:	e8 c6 d4 ff ff       	call   1007a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  1032da:	83 fe 0a             	cmp    $0xa,%esi
  1032dd:	75 e1                	jne    1032c0 <procdump+0x90>
  1032df:	eb 98                	jmp    103279 <procdump+0x49>
  1032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  1032e8:	83 c4 4c             	add    $0x4c,%esp
  1032eb:	5b                   	pop    %ebx
  1032ec:	5e                   	pop    %esi
  1032ed:	5f                   	pop    %edi
  1032ee:	5d                   	pop    %ebp
  1032ef:	90                   	nop
  1032f0:	c3                   	ret    
  1032f1:	eb 0d                	jmp    103300 <kill>
  1032f3:	90                   	nop
  1032f4:	90                   	nop
  1032f5:	90                   	nop
  1032f6:	90                   	nop
  1032f7:	90                   	nop
  1032f8:	90                   	nop
  1032f9:	90                   	nop
  1032fa:	90                   	nop
  1032fb:	90                   	nop
  1032fc:	90                   	nop
  1032fd:	90                   	nop
  1032fe:	90                   	nop
  1032ff:	90                   	nop

00103300 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103300:	55                   	push   %ebp
  103301:	89 e5                	mov    %esp,%ebp
  103303:	53                   	push   %ebx
  103304:	83 ec 14             	sub    $0x14,%esp
  103307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10330a:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103311:	e8 5a 11 00 00       	call   104470 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103316:	b8 c0 e4 10 00       	mov    $0x10e4c0,%eax
  10331b:	3d c0 bd 10 00       	cmp    $0x10bdc0,%eax
  103320:	76 56                	jbe    103378 <kill+0x78>
    if(p->pid == pid){
  103322:	39 1d d0 bd 10 00    	cmp    %ebx,0x10bdd0

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103328:	b8 c0 bd 10 00       	mov    $0x10bdc0,%eax
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
  10332d:	74 12                	je     103341 <kill+0x41>
  10332f:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
  103330:	05 9c 00 00 00       	add    $0x9c,%eax
  103335:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  10333a:	74 3c                	je     103378 <kill+0x78>
    if(p->pid == pid){
  10333c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10333f:	75 ef                	jne    103330 <kill+0x30>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103341:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103345:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10334c:	74 1a                	je     103368 <kill+0x68>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10334e:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103355:	e8 d6 10 00 00       	call   104430 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10335a:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10335d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10335f:	5b                   	pop    %ebx
  103360:	5d                   	pop    %ebp
  103361:	c3                   	ret    
  103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103368:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  10336f:	eb dd                	jmp    10334e <kill+0x4e>
  103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103378:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  10337f:	e8 ac 10 00 00       	call   104430 <release>
  return -1;
}
  103384:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  10338c:	5b                   	pop    %ebx
  10338d:	5d                   	pop    %ebp
  10338e:	c3                   	ret    
  10338f:	90                   	nop

00103390 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  103390:	55                   	push   %ebp
  103391:	89 e5                	mov    %esp,%ebp
  103393:	53                   	push   %ebx
  103394:	83 ec 14             	sub    $0x14,%esp
  103397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10339a:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1033a1:	e8 ca 10 00 00       	call   104470 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1033a6:	b8 c0 e4 10 00       	mov    $0x10e4c0,%eax
  1033ab:	3d c0 bd 10 00       	cmp    $0x10bdc0,%eax
  1033b0:	76 3e                	jbe    1033f0 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1033b2:	b8 c0 bd 10 00       	mov    $0x10bdc0,%eax
  1033b7:	eb 13                	jmp    1033cc <wakeup+0x3c>
  1033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1033c0:	05 9c 00 00 00       	add    $0x9c,%eax
  1033c5:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  1033ca:	74 24                	je     1033f0 <wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan)
  1033cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1033d0:	75 ee                	jne    1033c0 <wakeup+0x30>
  1033d2:	3b 58 18             	cmp    0x18(%eax),%ebx
  1033d5:	75 e9                	jne    1033c0 <wakeup+0x30>
      p->state = RUNNABLE;
  1033d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1033de:	05 9c 00 00 00       	add    $0x9c,%eax
  1033e3:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  1033e8:	75 e2                	jne    1033cc <wakeup+0x3c>
  1033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1033f0:	c7 45 08 c0 e4 10 00 	movl   $0x10e4c0,0x8(%ebp)
}
  1033f7:	83 c4 14             	add    $0x14,%esp
  1033fa:	5b                   	pop    %ebx
  1033fb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1033fc:	e9 2f 10 00 00       	jmp    104430 <release>
  103401:	eb 0d                	jmp    103410 <allocproc>
  103403:	90                   	nop
  103404:	90                   	nop
  103405:	90                   	nop
  103406:	90                   	nop
  103407:	90                   	nop
  103408:	90                   	nop
  103409:	90                   	nop
  10340a:	90                   	nop
  10340b:	90                   	nop
  10340c:	90                   	nop
  10340d:	90                   	nop
  10340e:	90                   	nop
  10340f:	90                   	nop

00103410 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103410:	55                   	push   %ebp
  103411:	89 e5                	mov    %esp,%ebp
  103413:	53                   	push   %ebx
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103414:	bb c0 bd 10 00       	mov    $0x10bdc0,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103419:	83 ec 14             	sub    $0x14,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10341c:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103423:	e8 48 10 00 00       	call   104470 <acquire>
  103428:	eb 14                	jmp    10343e <allocproc+0x2e>
  10342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103430:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103436:	81 fb c0 e4 10 00    	cmp    $0x10e4c0,%ebx
  10343c:	74 32                	je     103470 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10343e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103441:	85 c0                	test   %eax,%eax
  103443:	75 eb                	jne    103430 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103445:	a1 84 7f 10 00       	mov    0x107f84,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10344a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103451:	89 43 10             	mov    %eax,0x10(%ebx)
  103454:	83 c0 01             	add    $0x1,%eax
  103457:	a3 84 7f 10 00       	mov    %eax,0x107f84
      release(&proc_table_lock);
  10345c:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103463:	e8 c8 0f 00 00       	call   104430 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  103468:	89 d8                	mov    %ebx,%eax
  10346a:	83 c4 14             	add    $0x14,%esp
  10346d:	5b                   	pop    %ebx
  10346e:	5d                   	pop    %ebp
  10346f:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103470:	31 db                	xor    %ebx,%ebx
  103472:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103479:	e8 b2 0f 00 00       	call   104430 <release>
  return 0;
}
  10347e:	89 d8                	mov    %ebx,%eax
  103480:	83 c4 14             	add    $0x14,%esp
  103483:	5b                   	pop    %ebx
  103484:	5d                   	pop    %ebp
  103485:	c3                   	ret    
  103486:	8d 76 00             	lea    0x0(%esi),%esi
  103489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103490 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	53                   	push   %ebx
  103494:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103497:	e8 04 0f 00 00       	call   1043a0 <pushcli>
  p = cpus[cpu()].curproc;
  10349c:	e8 8f f4 ff ff       	call   102930 <cpu>
  1034a1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1034a7:	8b 98 44 b7 10 00    	mov    0x10b744(%eax),%ebx
  popcli();
  1034ad:	e8 6e 0e 00 00       	call   104320 <popcli>
  return p;
}
  1034b2:	83 c4 04             	add    $0x4,%esp
  1034b5:	89 d8                	mov    %ebx,%eax
  1034b7:	5b                   	pop    %ebx
  1034b8:	5d                   	pop    %ebp
  1034b9:	c3                   	ret    
  1034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001034c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  1034c0:	55                   	push   %ebp
  1034c1:	89 e5                	mov    %esp,%ebp
  1034c3:	83 ec 18             	sub    $0x18,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  1034c6:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1034cd:	e8 5e 0f 00 00       	call   104430 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1034d2:	e8 b9 ff ff ff       	call   103490 <curproc>
  1034d7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1034dd:	89 04 24             	mov    %eax,(%esp)
  1034e0:	e8 47 22 00 00       	call   10572c <forkret1>
}
  1034e5:	c9                   	leave  
  1034e6:	c3                   	ret    
  1034e7:	89 f6                	mov    %esi,%esi
  1034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001034f0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1034f0:	55                   	push   %ebp
  1034f1:	89 e5                	mov    %esp,%ebp
  1034f3:	53                   	push   %ebx
  1034f4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1034f7:	9c                   	pushf  
  1034f8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1034f9:	f6 c4 02             	test   $0x2,%ah
  1034fc:	75 5c                	jne    10355a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1034fe:	e8 8d ff ff ff       	call   103490 <curproc>
  103503:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103507:	74 75                	je     10357e <sched+0x8e>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103509:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103510:	e8 db 0e 00 00       	call   1043f0 <holding>
  103515:	85 c0                	test   %eax,%eax
  103517:	74 59                	je     103572 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103519:	e8 12 f4 ff ff       	call   102930 <cpu>
  10351e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103524:	83 b8 04 b8 10 00 01 	cmpl   $0x1,0x10b804(%eax)
  10352b:	75 39                	jne    103566 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10352d:	e8 fe f3 ff ff       	call   102930 <cpu>
  103532:	89 c3                	mov    %eax,%ebx
  103534:	e8 57 ff ff ff       	call   103490 <curproc>
  103539:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10353f:	81 c3 48 b7 10 00    	add    $0x10b748,%ebx
  103545:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103549:	83 c0 64             	add    $0x64,%eax
  10354c:	89 04 24             	mov    %eax,(%esp)
  10354f:	e8 88 11 00 00       	call   1046dc <swtch>
}
  103554:	83 c4 14             	add    $0x14,%esp
  103557:	5b                   	pop    %ebx
  103558:	5d                   	pop    %ebp
  103559:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10355a:	c7 04 24 f2 69 10 00 	movl   $0x1069f2,(%esp)
  103561:	e8 0a d4 ff ff       	call   100970 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  103566:	c7 04 24 2a 6a 10 00 	movl   $0x106a2a,(%esp)
  10356d:	e8 fe d3 ff ff       	call   100970 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103572:	c7 04 24 14 6a 10 00 	movl   $0x106a14,(%esp)
  103579:	e8 f2 d3 ff ff       	call   100970 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10357e:	c7 04 24 06 6a 10 00 	movl   $0x106a06,(%esp)
  103585:	e8 e6 d3 ff ff       	call   100970 <panic>
  10358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103590 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103590:	55                   	push   %ebp
  103591:	89 e5                	mov    %esp,%ebp
  103593:	56                   	push   %esi
  103594:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  103595:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103597:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(cp == initproc)
  10359a:	e8 f1 fe ff ff       	call   103490 <curproc>
  10359f:	3b 05 c8 84 10 00    	cmp    0x1084c8,%eax
  1035a5:	0f 84 36 01 00 00    	je     1036e1 <exit+0x151>
  1035ab:	90                   	nop
  1035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  1035b0:	e8 db fe ff ff       	call   103490 <curproc>
  1035b5:	8d 73 08             	lea    0x8(%ebx),%esi
  1035b8:	8b 14 b0             	mov    (%eax,%esi,4),%edx
  1035bb:	85 d2                	test   %edx,%edx
  1035bd:	74 1c                	je     1035db <exit+0x4b>
      fileclose(cp->ofile[fd]);
  1035bf:	e8 cc fe ff ff       	call   103490 <curproc>
  1035c4:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1035c7:	89 04 24             	mov    %eax,(%esp)
  1035ca:	e8 71 da ff ff       	call   101040 <fileclose>
      cp->ofile[fd] = 0;
  1035cf:	e8 bc fe ff ff       	call   103490 <curproc>
  1035d4:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1035db:	83 c3 01             	add    $0x1,%ebx
  1035de:	83 fb 10             	cmp    $0x10,%ebx
  1035e1:	75 cd                	jne    1035b0 <exit+0x20>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  1035e3:	e8 a8 fe ff ff       	call   103490 <curproc>
  1035e8:	8b 40 60             	mov    0x60(%eax),%eax
  1035eb:	89 04 24             	mov    %eax,(%esp)
  1035ee:	e8 3d e4 ff ff       	call   101a30 <iput>
  cp->cwd = 0;
  1035f3:	e8 98 fe ff ff       	call   103490 <curproc>
  1035f8:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  1035ff:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103606:	e8 65 0e 00 00       	call   104470 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10360b:	e8 80 fe ff ff       	call   103490 <curproc>
  103610:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103613:	b8 c0 e4 10 00       	mov    $0x10e4c0,%eax
  103618:	3d c0 bd 10 00       	cmp    $0x10bdc0,%eax
  10361d:	0f 86 95 00 00 00    	jbe    1036b8 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103623:	b8 c0 bd 10 00       	mov    $0x10bdc0,%eax
  103628:	eb 12                	jmp    10363c <exit+0xac>
  10362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103630:	05 9c 00 00 00       	add    $0x9c,%eax
  103635:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  10363a:	74 1e                	je     10365a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
  10363c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103640:	75 ee                	jne    103630 <exit+0xa0>
  103642:	3b 50 18             	cmp    0x18(%eax),%edx
  103645:	75 e9                	jne    103630 <exit+0xa0>
      p->state = RUNNABLE;
  103647:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10364e:	05 9c 00 00 00       	add    $0x9c,%eax
  103653:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  103658:	75 e2                	jne    10363c <exit+0xac>
  10365a:	bb c0 bd 10 00       	mov    $0x10bdc0,%ebx
  10365f:	eb 15                	jmp    103676 <exit+0xe6>
  103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103668:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  10366e:	81 fb c0 e4 10 00    	cmp    $0x10e4c0,%ebx
  103674:	74 42                	je     1036b8 <exit+0x128>
    if(p->parent == cp){
  103676:	8b 73 14             	mov    0x14(%ebx),%esi
  103679:	e8 12 fe ff ff       	call   103490 <curproc>
  10367e:	39 c6                	cmp    %eax,%esi
  103680:	75 e6                	jne    103668 <exit+0xd8>
      p->parent = initproc;
  103682:	8b 15 c8 84 10 00    	mov    0x1084c8,%edx
      if(p->state == ZOMBIE)
  103688:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  10368c:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE)
  10368f:	75 d7                	jne    103668 <exit+0xd8>
  103691:	b8 c0 bd 10 00       	mov    $0x10bdc0,%eax
  103696:	eb 0c                	jmp    1036a4 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103698:	05 9c 00 00 00       	add    $0x9c,%eax
  10369d:	3d c0 e4 10 00       	cmp    $0x10e4c0,%eax
  1036a2:	74 c4                	je     103668 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
  1036a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1036a8:	75 ee                	jne    103698 <exit+0x108>
  1036aa:	3b 50 18             	cmp    0x18(%eax),%edx
  1036ad:	75 e9                	jne    103698 <exit+0x108>
      p->state = RUNNABLE;
  1036af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1036b6:	eb e0                	jmp    103698 <exit+0x108>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  1036b8:	e8 d3 fd ff ff       	call   103490 <curproc>
  1036bd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  cp->state = ZOMBIE;
  1036c4:	e8 c7 fd ff ff       	call   103490 <curproc>
  1036c9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  1036d0:	e8 1b fe ff ff       	call   1034f0 <sched>
  panic("zombie exit");
  1036d5:	c7 04 24 43 6a 10 00 	movl   $0x106a43,(%esp)
  1036dc:	e8 8f d2 ff ff       	call   100970 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1036e1:	c7 04 24 36 6a 10 00 	movl   $0x106a36,(%esp)
  1036e8:	e8 83 d2 ff ff       	call   100970 <panic>
  1036ed:	8d 76 00             	lea    0x0(%esi),%esi

001036f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  1036f0:	55                   	push   %ebp
  1036f1:	89 e5                	mov    %esp,%ebp
  1036f3:	56                   	push   %esi
  1036f4:	53                   	push   %ebx
  1036f5:	83 ec 10             	sub    $0x10,%esp
  1036f8:	8b 75 08             	mov    0x8(%ebp),%esi
  1036fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  1036fe:	e8 8d fd ff ff       	call   103490 <curproc>
  103703:	85 c0                	test   %eax,%eax
  103705:	0f 84 9d 00 00 00    	je     1037a8 <sleep+0xb8>
    panic("sleep");

  if(lk == 0)
  10370b:	85 db                	test   %ebx,%ebx
  10370d:	0f 84 89 00 00 00    	je     10379c <sleep+0xac>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103713:	81 fb c0 e4 10 00    	cmp    $0x10e4c0,%ebx
  103719:	74 55                	je     103770 <sleep+0x80>
    acquire(&proc_table_lock);
  10371b:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103722:	e8 49 0d 00 00       	call   104470 <acquire>
    release(lk);
  103727:	89 1c 24             	mov    %ebx,(%esp)
  10372a:	e8 01 0d 00 00       	call   104430 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  10372f:	e8 5c fd ff ff       	call   103490 <curproc>
  103734:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103737:	e8 54 fd ff ff       	call   103490 <curproc>
  10373c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103743:	e8 a8 fd ff ff       	call   1034f0 <sched>

  // Tidy up.
  cp->chan = 0;
  103748:	e8 43 fd ff ff       	call   103490 <curproc>
  10374d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103754:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  10375b:	e8 d0 0c 00 00       	call   104430 <release>
    acquire(lk);
  103760:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103763:	83 c4 10             	add    $0x10,%esp
  103766:	5b                   	pop    %ebx
  103767:	5e                   	pop    %esi
  103768:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103769:	e9 02 0d 00 00       	jmp    104470 <acquire>
  10376e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103770:	e8 1b fd ff ff       	call   103490 <curproc>
  103775:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103778:	e8 13 fd ff ff       	call   103490 <curproc>
  10377d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103784:	e8 67 fd ff ff       	call   1034f0 <sched>

  // Tidy up.
  cp->chan = 0;
  103789:	e8 02 fd ff ff       	call   103490 <curproc>
  10378e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103795:	83 c4 10             	add    $0x10,%esp
  103798:	5b                   	pop    %ebx
  103799:	5e                   	pop    %esi
  10379a:	5d                   	pop    %ebp
  10379b:	c3                   	ret    
{
  if(cp == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  10379c:	c7 04 24 55 6a 10 00 	movl   $0x106a55,(%esp)
  1037a3:	e8 c8 d1 ff ff       	call   100970 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1037a8:	c7 04 24 4f 6a 10 00 	movl   $0x106a4f,(%esp)
  1037af:	e8 bc d1 ff ff       	call   100970 <panic>
  1037b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1037ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001037c0 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1037c0:	55                   	push   %ebp
  1037c1:	89 e5                	mov    %esp,%ebp
  1037c3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1037c4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1037c6:	56                   	push   %esi
  1037c7:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1037c8:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  1037ca:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1037cd:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1037d4:	e8 97 0c 00 00       	call   104470 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1037d9:	83 fb 3f             	cmp    $0x3f,%ebx
  1037dc:	7e 2f                	jle    10380d <wait_thread+0x4d>
  1037de:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1037e0:	85 ff                	test   %edi,%edi
  1037e2:	74 74                	je     103858 <wait_thread+0x98>
  1037e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1037e8:	e8 a3 fc ff ff       	call   103490 <curproc>
  1037ed:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1037f0:	85 c9                	test   %ecx,%ecx
  1037f2:	75 64                	jne    103858 <wait_thread+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1037f4:	e8 97 fc ff ff       	call   103490 <curproc>
  1037f9:	31 ff                	xor    %edi,%edi
  1037fb:	31 db                	xor    %ebx,%ebx
  1037fd:	c7 44 24 04 c0 e4 10 	movl   $0x10e4c0,0x4(%esp)
  103804:	00 
  103805:	89 04 24             	mov    %eax,(%esp)
  103808:	e8 e3 fe ff ff       	call   1036f0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10380d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103813:	81 c6 c0 bd 10 00    	add    $0x10bdc0,%esi
      if(p->state == UNUSED)
  103819:	8b 46 0c             	mov    0xc(%esi),%eax
  10381c:	85 c0                	test   %eax,%eax
  10381e:	75 10                	jne    103830 <wait_thread+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103820:	83 c3 01             	add    $0x1,%ebx
  103823:	83 fb 3f             	cmp    $0x3f,%ebx
  103826:	7e e5                	jle    10380d <wait_thread+0x4d>
  103828:	eb b6                	jmp    1037e0 <wait_thread+0x20>
  10382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103830:	8b 46 14             	mov    0x14(%esi),%eax
  103833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103836:	e8 55 fc ff ff       	call   103490 <curproc>
  10383b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10383e:	66 90                	xchg   %ax,%ax
  103840:	75 de                	jne    103820 <wait_thread+0x60>
        if(p->state == ZOMBIE){
  103842:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103846:	74 29                	je     103871 <wait_thread+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103848:	bf 01 00 00 00       	mov    $0x1,%edi
  10384d:	8d 76 00             	lea    0x0(%esi),%esi
  103850:	eb ce                	jmp    103820 <wait_thread+0x60>
  103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103858:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  10385f:	e8 cc 0b 00 00       	call   104430 <release>
  103864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103869:	83 c4 2c             	add    $0x2c,%esp
  10386c:	5b                   	pop    %ebx
  10386d:	5e                   	pop    %esi
  10386e:	5f                   	pop    %edi
  10386f:	5d                   	pop    %ebp
  103870:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          pid = p->pid;
  103871:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103874:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          pid = p->pid;
          p->state = UNUSED;
  10387b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103882:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103889:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  103890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103893:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  10389a:	e8 91 0b 00 00       	call   104430 <release>
          return pid;
  10389f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038a2:	eb c5                	jmp    103869 <wait_thread+0xa9>
  1038a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1038aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001038b0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1038b0:	55                   	push   %ebp
  1038b1:	89 e5                	mov    %esp,%ebp
  1038b3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038b4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1038b6:	56                   	push   %esi
  1038b7:	53                   	push   %ebx
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038b8:	31 db                	xor    %ebx,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  1038ba:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038bd:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1038c4:	e8 a7 0b 00 00       	call   104470 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1038c9:	83 fb 3f             	cmp    $0x3f,%ebx
  1038cc:	7e 2f                	jle    1038fd <wait+0x4d>
  1038ce:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1038d0:	85 ff                	test   %edi,%edi
  1038d2:	74 74                	je     103948 <wait+0x98>
  1038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038d8:	e8 b3 fb ff ff       	call   103490 <curproc>
  1038dd:	8b 50 1c             	mov    0x1c(%eax),%edx
  1038e0:	85 d2                	test   %edx,%edx
  1038e2:	75 64                	jne    103948 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1038e4:	e8 a7 fb ff ff       	call   103490 <curproc>
  1038e9:	31 ff                	xor    %edi,%edi
  1038eb:	31 db                	xor    %ebx,%ebx
  1038ed:	c7 44 24 04 c0 e4 10 	movl   $0x10e4c0,0x4(%esp)
  1038f4:	00 
  1038f5:	89 04 24             	mov    %eax,(%esp)
  1038f8:	e8 f3 fd ff ff       	call   1036f0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  1038fd:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103903:	81 c6 c0 bd 10 00    	add    $0x10bdc0,%esi
      if(p->state == UNUSED)
  103909:	8b 4e 0c             	mov    0xc(%esi),%ecx
  10390c:	85 c9                	test   %ecx,%ecx
  10390e:	75 10                	jne    103920 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103910:	83 c3 01             	add    $0x1,%ebx
  103913:	83 fb 3f             	cmp    $0x3f,%ebx
  103916:	7e e5                	jle    1038fd <wait+0x4d>
  103918:	eb b6                	jmp    1038d0 <wait+0x20>
  10391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103920:	8b 46 14             	mov    0x14(%esi),%eax
  103923:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103926:	e8 65 fb ff ff       	call   103490 <curproc>
  10392b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10392e:	66 90                	xchg   %ax,%ax
  103930:	75 de                	jne    103910 <wait+0x60>
        if(p->state == ZOMBIE){
  103932:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103936:	74 29                	je     103961 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103938:	bf 01 00 00 00       	mov    $0x1,%edi
  10393d:	8d 76 00             	lea    0x0(%esi),%esi
  103940:	eb ce                	jmp    103910 <wait+0x60>
  103942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103948:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  10394f:	e8 dc 0a 00 00       	call   104430 <release>
  103954:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103959:	83 c4 2c             	add    $0x2c,%esp
  10395c:	5b                   	pop    %ebx
  10395d:	5e                   	pop    %esi
  10395e:	5f                   	pop    %edi
  10395f:	5d                   	pop    %ebp
  103960:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103961:	8b 46 04             	mov    0x4(%esi),%eax
  103964:	89 44 24 04          	mov    %eax,0x4(%esp)
  103968:	8b 06                	mov    (%esi),%eax
  10396a:	89 04 24             	mov    %eax,(%esp)
  10396d:	e8 ce ea ff ff       	call   102440 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103972:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103979:	00 
  10397a:	8b 46 08             	mov    0x8(%esi),%eax
  10397d:	89 04 24             	mov    %eax,(%esp)
  103980:	e8 bb ea ff ff       	call   102440 <kfree>
          pid = p->pid;
  103985:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103988:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10398f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103996:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10399d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1039a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1039a7:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1039ae:	e8 7d 0a 00 00       	call   104430 <release>
          return pid;
  1039b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039b6:	eb a1                	jmp    103959 <wait+0xa9>
  1039b8:	90                   	nop
  1039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001039c0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1039c0:	55                   	push   %ebp
  1039c1:	89 e5                	mov    %esp,%ebp
  1039c3:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  1039c6:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1039cd:	e8 9e 0a 00 00       	call   104470 <acquire>
  cp->state = RUNNABLE;
  1039d2:	e8 b9 fa ff ff       	call   103490 <curproc>
  1039d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1039de:	e8 0d fb ff ff       	call   1034f0 <sched>
  release(&proc_table_lock);
  1039e3:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  1039ea:	e8 41 0a 00 00       	call   104430 <release>
}
  1039ef:	c9                   	leave  
  1039f0:	c3                   	ret    
  1039f1:	eb 0d                	jmp    103a00 <setupsegs>
  1039f3:	90                   	nop
  1039f4:	90                   	nop
  1039f5:	90                   	nop
  1039f6:	90                   	nop
  1039f7:	90                   	nop
  1039f8:	90                   	nop
  1039f9:	90                   	nop
  1039fa:	90                   	nop
  1039fb:	90                   	nop
  1039fc:	90                   	nop
  1039fd:	90                   	nop
  1039fe:	90                   	nop
  1039ff:	90                   	nop

00103a00 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103a00:	55                   	push   %ebp
  103a01:	89 e5                	mov    %esp,%ebp
  103a03:	57                   	push   %edi
  103a04:	56                   	push   %esi
  103a05:	53                   	push   %ebx
  103a06:	83 ec 2c             	sub    $0x2c,%esp
  103a09:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103a0c:	e8 8f 09 00 00       	call   1043a0 <pushcli>
  c = &cpus[cpu()];
  103a11:	e8 1a ef ff ff       	call   102930 <cpu>
  103a16:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103a1c:	05 40 b7 10 00       	add    $0x10b740,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103a21:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103a23:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103a29:	0f 84 a1 01 00 00    	je     103bd0 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103a2f:	8b 56 08             	mov    0x8(%esi),%edx
  103a32:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103a38:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103a3b:	8d 50 28             	lea    0x28(%eax),%edx
  103a3e:	89 d1                	mov    %edx,%ecx
  103a40:	c1 e9 10             	shr    $0x10,%ecx
  103a43:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103a4a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103a4d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103a4f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103a56:	00 00 00 
  103a59:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103a60:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103a63:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103a6a:	0f 01 
  103a6c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103a73:	00 00 
  103a75:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103a7c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103a83:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103a8a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103a91:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103a98:	ff ff 
  103a9a:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103aa1:	00 00 
  103aa3:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103aaa:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103ab1:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103ab8:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103abf:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103ac6:	67 00 
  103ac8:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103ace:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103ad5:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103adb:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103ae2:	0f 84 b8 00 00 00    	je     103ba0 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103ae8:	8b 16                	mov    (%esi),%edx
  103aea:	8b 5e 04             	mov    0x4(%esi),%ebx
  103aed:	89 d6                	mov    %edx,%esi
  103aef:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103af2:	89 d3                	mov    %edx,%ebx
  103af4:	c1 ee 10             	shr    $0x10,%esi
  103af7:	89 cf                	mov    %ecx,%edi
  103af9:	c1 eb 18             	shr    $0x18,%ebx
  103afc:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103aff:	89 f3                	mov    %esi,%ebx
  103b01:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103b07:	89 cb                	mov    %ecx,%ebx
  103b09:	c1 eb 1c             	shr    $0x1c,%ebx
  103b0c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b0e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b11:	83 c9 c0             	or     $0xffffffc0,%ecx
  103b14:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103b1b:	c1 ef 0c             	shr    $0xc,%edi
  103b1e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103b24:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b28:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103b2f:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b35:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103b3c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b42:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103b46:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103b4d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b4f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b56:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103b5d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103b63:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103b69:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103b6e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103b74:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103b78:	c1 e8 10             	shr    $0x10,%eax
  103b7b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103b7f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103b82:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103b85:	b8 28 00 00 00       	mov    $0x28,%eax
  103b8a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103b8d:	e8 8e 07 00 00       	call   104320 <popcli>
}
  103b92:	83 c4 2c             	add    $0x2c,%esp
  103b95:	5b                   	pop    %ebx
  103b96:	5e                   	pop    %esi
  103b97:	5f                   	pop    %edi
  103b98:	5d                   	pop    %ebp
  103b99:	c3                   	ret    
  103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103ba0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103ba7:	00 00 00 
  103baa:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103bb1:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103bb4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103bbb:	00 00 00 
  103bbe:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103bc5:	00 00 00 
  103bc8:	eb 9f                	jmp    103b69 <setupsegs+0x169>
  103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103bd0:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103bd7:	e9 5f fe ff ff       	jmp    103a3b <setupsegs+0x3b>
  103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103be0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103be0:	55                   	push   %ebp
  103be1:	89 e5                	mov    %esp,%ebp
  103be3:	57                   	push   %edi
  103be4:	56                   	push   %esi
  103be5:	53                   	push   %ebx
  103be6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103be9:	e8 42 ed ff ff       	call   102930 <cpu>
  103bee:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103bf4:	81 c3 40 b7 10 00    	add    $0x10b740,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103bfa:	8d 73 08             	lea    0x8(%ebx),%esi
  103bfd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103c00:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103c01:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103c08:	e8 63 08 00 00       	call   104470 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103c0d:	83 3d d0 bd 10 00 01 	cmpl   $0x1,0x10bdd0
  103c14:	0f 84 c6 00 00 00    	je     103ce0 <scheduler+0x100>
  103c1a:	31 d2                	xor    %edx,%edx
  103c1c:	31 c0                	xor    %eax,%eax
  103c1e:	eb 0e                	jmp    103c2e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c20:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103c26:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103c2c:	74 1d                	je     103c4b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103c2e:	83 ba cc bd 10 00 03 	cmpl   $0x3,0x10bdcc(%edx)
  103c35:	75 e9                	jne    103c20 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c37:	03 82 58 be 10 00    	add    0x10be58(%edx),%eax
  103c3d:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103c43:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103c49:	75 e3                	jne    103c2e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103c4b:	85 c0                	test   %eax,%eax
  103c4d:	74 16                	je     103c65 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103c4f:	8b 3d 40 ed 10 00    	mov    0x10ed40,%edi
  103c55:	89 c1                	mov    %eax,%ecx
  103c57:	c1 e7 08             	shl    $0x8,%edi
  103c5a:	89 fa                	mov    %edi,%edx
  103c5c:	89 f8                	mov    %edi,%eax
  103c5e:	c1 fa 1f             	sar    $0x1f,%edx
  103c61:	f7 f9                	idiv   %ecx
  103c63:	89 d7                	mov    %edx,%edi
  103c65:	b8 cc bd 10 00       	mov    $0x10bdcc,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c6a:	31 d2                	xor    %edx,%edx
  103c6c:	eb 12                	jmp    103c80 <scheduler+0xa0>
  103c6e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c70:	39 fa                	cmp    %edi,%edx
  103c72:	7f 1e                	jg     103c92 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103c74:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103c79:	3d cc e4 10 00       	cmp    $0x10e4cc,%eax
  103c7e:	74 4c                	je     103ccc <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c80:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c83:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c86:	75 e8                	jne    103c70 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c88:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c8e:	39 fa                	cmp    %edi,%edx
  103c90:	7e e2                	jle    103c74 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103c92:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103c95:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103c98:	89 0c 24             	mov    %ecx,(%esp)
  103c9b:	e8 60 fd ff ff       	call   103a00 <setupsegs>
    	  p->state = RUNNING;
  103ca0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103ca3:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103caa:	83 c1 64             	add    $0x64,%ecx
  103cad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103cb1:	89 34 24             	mov    %esi,(%esp)
  103cb4:	e8 23 0a 00 00       	call   1046dc <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103cb9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103cc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103cc7:	e8 34 fd ff ff       	call   103a00 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103ccc:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103cd3:	e8 58 07 00 00       	call   104430 <release>
  103cd8:	e9 23 ff ff ff       	jmp    103c00 <scheduler+0x20>
  103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103ce0:	83 3d cc bd 10 00 03 	cmpl   $0x3,0x10bdcc
  103ce7:	0f 85 2d ff ff ff    	jne    103c1a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103ced:	c7 43 04 c0 bd 10 00 	movl   $0x10bdc0,0x4(%ebx)
      setupsegs(p);
  103cf4:	c7 04 24 c0 bd 10 00 	movl   $0x10bdc0,(%esp)
  103cfb:	e8 00 fd ff ff       	call   103a00 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103d00:	c7 44 24 04 24 be 10 	movl   $0x10be24,0x4(%esp)
  103d07:	00 
  103d08:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103d0b:	c7 05 58 be 10 00 4b 	movl   $0x4b,0x10be58
  103d12:	00 00 00 
      p->state = RUNNING;
  103d15:	c7 05 cc bd 10 00 04 	movl   $0x4,0x10bdcc
  103d1c:	00 00 00 
      swtch(&c->context, &p->context);
  103d1f:	e8 b8 09 00 00       	call   1046dc <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103d24:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103d32:	e8 c9 fc ff ff       	call   103a00 <setupsegs>
      release(&proc_table_lock);
  103d37:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  103d3e:	e8 ed 06 00 00       	call   104430 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d43:	e9 b8 fe ff ff       	jmp    103c00 <scheduler+0x20>
  103d48:	90                   	nop
  103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103d50 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103d50:	55                   	push   %ebp
  103d51:	89 e5                	mov    %esp,%ebp
  103d53:	57                   	push   %edi
  103d54:	56                   	push   %esi
  103d55:	53                   	push   %ebx
  103d56:	83 ec 1c             	sub    $0x1c,%esp
  103d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103d5c:	e8 2f f7 ff ff       	call   103490 <curproc>
  103d61:	8b 50 04             	mov    0x4(%eax),%edx
  103d64:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103d67:	89 04 24             	mov    %eax,(%esp)
  103d6a:	e8 11 e6 ff ff       	call   102380 <kalloc>
  103d6f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d76:	85 f6                	test   %esi,%esi
  103d78:	74 7f                	je     103df9 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103d7a:	e8 11 f7 ff ff       	call   103490 <curproc>
  103d7f:	8b 78 04             	mov    0x4(%eax),%edi
  103d82:	e8 09 f7 ff ff       	call   103490 <curproc>
  103d87:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103d8b:	8b 00                	mov    (%eax),%eax
  103d8d:	89 34 24             	mov    %esi,(%esp)
  103d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d94:	e8 d7 07 00 00       	call   104570 <memmove>
  memset(newmem + cp->sz, 0, n);
  103d99:	e8 f2 f6 ff ff       	call   103490 <curproc>
  103d9e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103da2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103da9:	00 
  103daa:	8b 50 04             	mov    0x4(%eax),%edx
  103dad:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103db0:	89 04 24             	mov    %eax,(%esp)
  103db3:	e8 28 07 00 00       	call   1044e0 <memset>
  kfree(cp->mem, cp->sz);
  103db8:	e8 d3 f6 ff ff       	call   103490 <curproc>
  103dbd:	8b 78 04             	mov    0x4(%eax),%edi
  103dc0:	e8 cb f6 ff ff       	call   103490 <curproc>
  103dc5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103dc9:	8b 00                	mov    (%eax),%eax
  103dcb:	89 04 24             	mov    %eax,(%esp)
  103dce:	e8 6d e6 ff ff       	call   102440 <kfree>
  cp->mem = newmem;
  103dd3:	e8 b8 f6 ff ff       	call   103490 <curproc>
  103dd8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103dda:	e8 b1 f6 ff ff       	call   103490 <curproc>
  103ddf:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  103de2:	e8 a9 f6 ff ff       	call   103490 <curproc>
  103de7:	89 04 24             	mov    %eax,(%esp)
  103dea:	e8 11 fc ff ff       	call   103a00 <setupsegs>
  return cp->sz - n;
  103def:	e8 9c f6 ff ff       	call   103490 <curproc>
  103df4:	8b 40 04             	mov    0x4(%eax),%eax
  103df7:	29 d8                	sub    %ebx,%eax
}
  103df9:	83 c4 1c             	add    $0x1c,%esp
  103dfc:	5b                   	pop    %ebx
  103dfd:	5e                   	pop    %esi
  103dfe:	5f                   	pop    %edi
  103dff:	5d                   	pop    %ebp
  103e00:	c3                   	ret    
  103e01:	eb 0d                	jmp    103e10 <copyproc_tix>
  103e03:	90                   	nop
  103e04:	90                   	nop
  103e05:	90                   	nop
  103e06:	90                   	nop
  103e07:	90                   	nop
  103e08:	90                   	nop
  103e09:	90                   	nop
  103e0a:	90                   	nop
  103e0b:	90                   	nop
  103e0c:	90                   	nop
  103e0d:	90                   	nop
  103e0e:	90                   	nop
  103e0f:	90                   	nop

00103e10 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103e10:	55                   	push   %ebp
  103e11:	89 e5                	mov    %esp,%ebp
  103e13:	57                   	push   %edi
  103e14:	56                   	push   %esi
  103e15:	53                   	push   %ebx
  103e16:	83 ec 1c             	sub    $0x1c,%esp
  103e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103e1c:	e8 ef f5 ff ff       	call   103410 <allocproc>
  103e21:	85 c0                	test   %eax,%eax
  103e23:	89 c6                	mov    %eax,%esi
  103e25:	0f 84 e1 00 00 00    	je     103f0c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103e2b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103e32:	e8 49 e5 ff ff       	call   102380 <kalloc>
  103e37:	85 c0                	test   %eax,%eax
  103e39:	89 46 08             	mov    %eax,0x8(%esi)
  103e3c:	0f 84 d4 00 00 00    	je     103f16 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e42:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103e47:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e49:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103e4f:	0f 84 85 00 00 00    	je     103eda <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;
  103e55:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103e58:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;
  103e5b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103e61:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103e68:	00 
  103e69:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103e6f:	89 04 24             	mov    %eax,(%esp)
  103e72:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e76:	e8 f5 06 00 00       	call   104570 <memmove>
  
    np->sz = p->sz;
  103e7b:	8b 47 04             	mov    0x4(%edi),%eax
  103e7e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103e81:	89 04 24             	mov    %eax,(%esp)
  103e84:	e8 f7 e4 ff ff       	call   102380 <kalloc>
  103e89:	85 c0                	test   %eax,%eax
  103e8b:	89 06                	mov    %eax,(%esi)
  103e8d:	0f 84 8e 00 00 00    	je     103f21 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103e93:	8b 56 04             	mov    0x4(%esi),%edx
  103e96:	31 db                	xor    %ebx,%ebx
  103e98:	89 54 24 08          	mov    %edx,0x8(%esp)
  103e9c:	8b 17                	mov    (%edi),%edx
  103e9e:	89 04 24             	mov    %eax,(%esp)
  103ea1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ea5:	e8 c6 06 00 00       	call   104570 <memmove>
  103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103eb0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103eb4:	85 c0                	test   %eax,%eax
  103eb6:	74 0c                	je     103ec4 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103eb8:	89 04 24             	mov    %eax,(%esp)
  103ebb:	e8 b0 d0 ff ff       	call   100f70 <filedup>
  103ec0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103ec4:	83 c3 01             	add    $0x1,%ebx
  103ec7:	83 fb 10             	cmp    $0x10,%ebx
  103eca:	75 e4                	jne    103eb0 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103ecc:	8b 47 60             	mov    0x60(%edi),%eax
  103ecf:	89 04 24             	mov    %eax,(%esp)
  103ed2:	e8 89 d2 ff ff       	call   101160 <idup>
  103ed7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103eda:	8d 46 64             	lea    0x64(%esi),%eax
  103edd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103ee4:	00 
  103ee5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103eec:	00 
  103eed:	89 04 24             	mov    %eax,(%esp)
  103ef0:	e8 eb 05 00 00       	call   1044e0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103ef5:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103efb:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103f02:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103f05:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103f0c:	83 c4 1c             	add    $0x1c,%esp
  103f0f:	89 f0                	mov    %esi,%eax
  103f11:	5b                   	pop    %ebx
  103f12:	5e                   	pop    %esi
  103f13:	5f                   	pop    %edi
  103f14:	5d                   	pop    %ebp
  103f15:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103f16:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103f1d:	31 f6                	xor    %esi,%esi
    return 0;
  103f1f:	eb eb                	jmp    103f0c <copyproc_tix+0xfc>
    np->num_tix = tix;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103f21:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103f28:	00 
  103f29:	8b 46 08             	mov    0x8(%esi),%eax
  103f2c:	89 04 24             	mov    %eax,(%esp)
  103f2f:	e8 0c e5 ff ff       	call   102440 <kfree>
      np->kstack = 0;
  103f34:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103f3b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103f42:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103f49:	31 f6                	xor    %esi,%esi
      return 0;
  103f4b:	eb bf                	jmp    103f0c <copyproc_tix+0xfc>
  103f4d:	8d 76 00             	lea    0x0(%esi),%esi

00103f50 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, void *stack)
{
  103f50:	55                   	push   %ebp
  103f51:	89 e5                	mov    %esp,%ebp
  103f53:	57                   	push   %edi
  103f54:	56                   	push   %esi
  103f55:	53                   	push   %ebx
  103f56:	83 ec 1c             	sub    $0x1c,%esp
  103f59:	8b 7d 08             	mov    0x8(%ebp),%edi
  103f5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103f5f:	e8 ac f4 ff ff       	call   103410 <allocproc>
  103f64:	85 c0                	test   %eax,%eax
  103f66:	89 c6                	mov    %eax,%esi
  103f68:	0f 84 d0 00 00 00    	je     10403e <copyproc_threads+0xee>
    return 0;
	np->kstack = (char *)stack;
  103f6e:	89 58 08             	mov    %ebx,0x8(%eax)

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f71:	81 c3 bc 0f 00 00    	add    $0xfbc,%ebx

  if(p){  // Copy process state from p.
  103f77:	85 ff                	test   %edi,%edi
  // Allocate process.
  if((np = allocproc()) == 0)
    return 0;
	np->kstack = (char *)stack;

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f79:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)

  if(p){  // Copy process state from p.
  103f7f:	74 71                	je     103ff2 <copyproc_threads+0xa2>
    np->parent = p;
  103f81:	89 78 14             	mov    %edi,0x14(%eax)
    np->num_tix = DEFAULT_NUM_TIX;
  103f84:	c7 80 98 00 00 00 4b 	movl   $0x4b,0x98(%eax)
  103f8b:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103f8e:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103f95:	00 
  103f96:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103f9c:	89 1c 24             	mov    %ebx,(%esp)
  
    np->sz = p->sz;
    np->mem = p->mem;
    memmove(np->mem, p->mem, np->sz);
  103f9f:	31 db                	xor    %ebx,%ebx
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fa5:	e8 c6 05 00 00       	call   104570 <memmove>
  
    np->sz = p->sz;
  103faa:	8b 57 04             	mov    0x4(%edi),%edx
    np->mem = p->mem;
  103fad:	8b 07                	mov    (%edi),%eax
  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
  103faf:	89 56 04             	mov    %edx,0x4(%esi)
    np->mem = p->mem;
  103fb2:	89 06                	mov    %eax,(%esi)
    memmove(np->mem, p->mem, np->sz);
  103fb4:	89 54 24 08          	mov    %edx,0x8(%esp)
  103fb8:	8b 17                	mov    (%edi),%edx
  103fba:	89 04 24             	mov    %eax,(%esp)
  103fbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fc1:	e8 aa 05 00 00       	call   104570 <memmove>
  103fc6:	66 90                	xchg   %ax,%ax

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103fc8:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103fcc:	85 c0                	test   %eax,%eax
  103fce:	74 0c                	je     103fdc <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  103fd0:	89 04 24             	mov    %eax,(%esp)
  103fd3:	e8 98 cf ff ff       	call   100f70 <filedup>
  103fd8:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103fdc:	83 c3 01             	add    $0x1,%ebx
  103fdf:	83 fb 10             	cmp    $0x10,%ebx
  103fe2:	75 e4                	jne    103fc8 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103fe4:	8b 47 60             	mov    0x60(%edi),%eax
  103fe7:	89 04 24             	mov    %eax,(%esp)
  103fea:	e8 71 d1 ff ff       	call   101160 <idup>
  103fef:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103ff2:	8d 46 64             	lea    0x64(%esi),%eax
  103ff5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103ffc:	00 
  103ffd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104004:	00 
  104005:	89 04 24             	mov    %eax,(%esp)
  104008:	e8 d3 04 00 00       	call   1044e0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  10400d:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104013:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  10401a:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  10401d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  cprintf("Parent PID: %d PID: %d\n", p->pid, np->pid);
  104024:	8b 46 10             	mov    0x10(%esi),%eax
  104027:	89 44 24 08          	mov    %eax,0x8(%esp)
  10402b:	8b 47 10             	mov    0x10(%edi),%eax
  10402e:	c7 04 24 66 6a 10 00 	movl   $0x106a66,(%esp)
  104035:	89 44 24 04          	mov    %eax,0x4(%esp)
  104039:	e8 62 c7 ff ff       	call   1007a0 <cprintf>
  return np;
}
  10403e:	83 c4 1c             	add    $0x1c,%esp
  104041:	89 f0                	mov    %esi,%eax
  104043:	5b                   	pop    %ebx
  104044:	5e                   	pop    %esi
  104045:	5f                   	pop    %edi
  104046:	5d                   	pop    %ebp
  104047:	c3                   	ret    
  104048:	90                   	nop
  104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104050 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104050:	55                   	push   %ebp
  104051:	89 e5                	mov    %esp,%ebp
  104053:	57                   	push   %edi
  104054:	56                   	push   %esi
  104055:	53                   	push   %ebx
  104056:	83 ec 1c             	sub    $0x1c,%esp
  104059:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10405c:	e8 af f3 ff ff       	call   103410 <allocproc>
  104061:	85 c0                	test   %eax,%eax
  104063:	89 c6                	mov    %eax,%esi
  104065:	0f 84 e1 00 00 00    	je     10414c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10406b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104072:	e8 09 e3 ff ff       	call   102380 <kalloc>
  104077:	85 c0                	test   %eax,%eax
  104079:	89 46 08             	mov    %eax,0x8(%esi)
  10407c:	0f 84 d4 00 00 00    	je     104156 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104082:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104087:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104089:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10408f:	0f 84 85 00 00 00    	je     10411a <copyproc+0xca>
    np->parent = p;
  104095:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104098:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10409f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1040a2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1040a9:	00 
  1040aa:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  1040b0:	89 04 24             	mov    %eax,(%esp)
  1040b3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040b7:	e8 b4 04 00 00       	call   104570 <memmove>
  
    np->sz = p->sz;
  1040bc:	8b 47 04             	mov    0x4(%edi),%eax
  1040bf:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  1040c2:	89 04 24             	mov    %eax,(%esp)
  1040c5:	e8 b6 e2 ff ff       	call   102380 <kalloc>
  1040ca:	85 c0                	test   %eax,%eax
  1040cc:	89 06                	mov    %eax,(%esi)
  1040ce:	0f 84 8d 00 00 00    	je     104161 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1040d4:	8b 56 04             	mov    0x4(%esi),%edx
  1040d7:	31 db                	xor    %ebx,%ebx
  1040d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1040dd:	8b 17                	mov    (%edi),%edx
  1040df:	89 04 24             	mov    %eax,(%esp)
  1040e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040e6:	e8 85 04 00 00       	call   104570 <memmove>
  1040eb:	90                   	nop
  1040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1040f0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1040f4:	85 c0                	test   %eax,%eax
  1040f6:	74 0c                	je     104104 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  1040f8:	89 04 24             	mov    %eax,(%esp)
  1040fb:	e8 70 ce ff ff       	call   100f70 <filedup>
  104100:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104104:	83 c3 01             	add    $0x1,%ebx
  104107:	83 fb 10             	cmp    $0x10,%ebx
  10410a:	75 e4                	jne    1040f0 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10410c:	8b 47 60             	mov    0x60(%edi),%eax
  10410f:	89 04 24             	mov    %eax,(%esp)
  104112:	e8 49 d0 ff ff       	call   101160 <idup>
  104117:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10411a:	8d 46 64             	lea    0x64(%esi),%eax
  10411d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104124:	00 
  104125:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10412c:	00 
  10412d:	89 04 24             	mov    %eax,(%esp)
  104130:	e8 ab 03 00 00       	call   1044e0 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104135:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10413b:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104142:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104145:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10414c:	83 c4 1c             	add    $0x1c,%esp
  10414f:	89 f0                	mov    %esi,%eax
  104151:	5b                   	pop    %ebx
  104152:	5e                   	pop    %esi
  104153:	5f                   	pop    %edi
  104154:	5d                   	pop    %ebp
  104155:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104156:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10415d:	31 f6                	xor    %esi,%esi
    return 0;
  10415f:	eb eb                	jmp    10414c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104161:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104168:	00 
  104169:	8b 46 08             	mov    0x8(%esi),%eax
  10416c:	89 04 24             	mov    %eax,(%esp)
  10416f:	e8 cc e2 ff ff       	call   102440 <kfree>
      np->kstack = 0;
  104174:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10417b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104182:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  104189:	31 f6                	xor    %esi,%esi
      return 0;
  10418b:	eb bf                	jmp    10414c <copyproc+0xfc>
  10418d:	8d 76 00             	lea    0x0(%esi),%esi

00104190 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104190:	55                   	push   %ebp
  104191:	89 e5                	mov    %esp,%ebp
  104193:	53                   	push   %ebx
  104194:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10419e:	e8 ad fe ff ff       	call   104050 <copyproc>
  p->sz = PAGE;
  1041a3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1041aa:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  1041ac:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1041b3:	e8 c8 e1 ff ff       	call   102380 <kalloc>
  1041b8:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  1041ba:	c7 04 24 7e 6a 10 00 	movl   $0x106a7e,(%esp)
  1041c1:	e8 ea dd ff ff       	call   101fb0 <namei>
  1041c6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  1041c9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1041d0:	00 
  1041d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1041d8:	00 
  1041d9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  1041df:	89 04 24             	mov    %eax,(%esp)
  1041e2:	e8 f9 02 00 00       	call   1044e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1041e7:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1041ed:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  1041ef:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  1041f6:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1041f9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1041ff:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104205:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10420b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10420e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104212:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104215:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10421b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104222:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104229:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104230:	00 
  104231:	c7 44 24 04 88 83 10 	movl   $0x108388,0x4(%esp)
  104238:	00 
  104239:	8b 03                	mov    (%ebx),%eax
  10423b:	89 04 24             	mov    %eax,(%esp)
  10423e:	e8 2d 03 00 00       	call   104570 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104243:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104249:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104250:	00 
  104251:	c7 44 24 04 80 6a 10 	movl   $0x106a80,0x4(%esp)
  104258:	00 
  104259:	89 04 24             	mov    %eax,(%esp)
  10425c:	e8 1f 04 00 00       	call   104680 <safestrcpy>
  p->state = RUNNABLE;
  104261:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104268:	89 1d c8 84 10 00    	mov    %ebx,0x1084c8
}
  10426e:	83 c4 14             	add    $0x14,%esp
  104271:	5b                   	pop    %ebx
  104272:	5d                   	pop    %ebp
  104273:	c3                   	ret    
  104274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10427a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104280 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104280:	55                   	push   %ebp
  104281:	89 e5                	mov    %esp,%ebp
  104283:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  104286:	c7 44 24 04 89 6a 10 	movl   $0x106a89,0x4(%esp)
  10428d:	00 
  10428e:	c7 04 24 c0 e4 10 00 	movl   $0x10e4c0,(%esp)
  104295:	e8 06 00 00 00       	call   1042a0 <initlock>
}
  10429a:	c9                   	leave  
  10429b:	c3                   	ret    
  10429c:	90                   	nop
  10429d:	90                   	nop
  10429e:	90                   	nop
  10429f:	90                   	nop

001042a0 <initlock>:
  1042a0:	55                   	push   %ebp
  1042a1:	89 e5                	mov    %esp,%ebp
  1042a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1042a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  1042af:	89 50 04             	mov    %edx,0x4(%eax)
  1042b2:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
  1042b9:	5d                   	pop    %ebp
  1042ba:	c3                   	ret    
  1042bb:	90                   	nop
  1042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042c0 <getcallerpcs>:
  1042c0:	55                   	push   %ebp
  1042c1:	31 d2                	xor    %edx,%edx
  1042c3:	89 e5                	mov    %esp,%ebp
  1042c5:	53                   	push   %ebx
  1042c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1042c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1042cc:	83 e9 08             	sub    $0x8,%ecx
  1042cf:	eb 09                	jmp    1042da <getcallerpcs+0x1a>
  1042d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1042d8:	89 c1                	mov    %eax,%ecx
  1042da:	8d 41 ff             	lea    -0x1(%ecx),%eax
  1042dd:	83 f8 fd             	cmp    $0xfffffffd,%eax
  1042e0:	77 16                	ja     1042f8 <getcallerpcs+0x38>
  1042e2:	8b 41 04             	mov    0x4(%ecx),%eax
  1042e5:	89 04 93             	mov    %eax,(%ebx,%edx,4)
  1042e8:	83 c2 01             	add    $0x1,%edx
  1042eb:	8b 01                	mov    (%ecx),%eax
  1042ed:	83 fa 0a             	cmp    $0xa,%edx
  1042f0:	75 e6                	jne    1042d8 <getcallerpcs+0x18>
  1042f2:	5b                   	pop    %ebx
  1042f3:	5d                   	pop    %ebp
  1042f4:	c3                   	ret    
  1042f5:	8d 76 00             	lea    0x0(%esi),%esi
  1042f8:	83 fa 09             	cmp    $0x9,%edx
  1042fb:	8d 04 93             	lea    (%ebx,%edx,4),%eax
  1042fe:	7f f2                	jg     1042f2 <getcallerpcs+0x32>
  104300:	83 c2 01             	add    $0x1,%edx
  104303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  104309:	83 c0 04             	add    $0x4,%eax
  10430c:	83 fa 09             	cmp    $0x9,%edx
  10430f:	7e ef                	jle    104300 <getcallerpcs+0x40>
  104311:	5b                   	pop    %ebx
  104312:	5d                   	pop    %ebp
  104313:	c3                   	ret    
  104314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10431a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104320 <popcli>:
  104320:	55                   	push   %ebp
  104321:	89 e5                	mov    %esp,%ebp
  104323:	83 ec 08             	sub    $0x8,%esp
  104326:	9c                   	pushf  
  104327:	58                   	pop    %eax
  104328:	f6 c4 02             	test   $0x2,%ah
  10432b:	75 53                	jne    104380 <popcli+0x60>
  10432d:	e8 fe e5 ff ff       	call   102930 <cpu>
  104332:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104338:	05 44 b7 10 00       	add    $0x10b744,%eax
  10433d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104343:	83 ea 01             	sub    $0x1,%edx
  104346:	85 d2                	test   %edx,%edx
  104348:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10434e:	78 3c                	js     10438c <popcli+0x6c>
  104350:	e8 db e5 ff ff       	call   102930 <cpu>
  104355:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10435b:	8b 90 04 b8 10 00    	mov    0x10b804(%eax),%edx
  104361:	85 d2                	test   %edx,%edx
  104363:	74 03                	je     104368 <popcli+0x48>
  104365:	c9                   	leave  
  104366:	c3                   	ret    
  104367:	90                   	nop
  104368:	e8 c3 e5 ff ff       	call   102930 <cpu>
  10436d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104373:	8b 80 08 b8 10 00    	mov    0x10b808(%eax),%eax
  104379:	85 c0                	test   %eax,%eax
  10437b:	74 e8                	je     104365 <popcli+0x45>
  10437d:	fb                   	sti    
  10437e:	c9                   	leave  
  10437f:	c3                   	ret    
  104380:	c7 04 24 d8 6a 10 00 	movl   $0x106ad8,(%esp)
  104387:	e8 e4 c5 ff ff       	call   100970 <panic>
  10438c:	c7 04 24 ef 6a 10 00 	movl   $0x106aef,(%esp)
  104393:	e8 d8 c5 ff ff       	call   100970 <panic>
  104398:	90                   	nop
  104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001043a0 <pushcli>:
  1043a0:	55                   	push   %ebp
  1043a1:	89 e5                	mov    %esp,%ebp
  1043a3:	53                   	push   %ebx
  1043a4:	83 ec 04             	sub    $0x4,%esp
  1043a7:	9c                   	pushf  
  1043a8:	5b                   	pop    %ebx
  1043a9:	fa                   	cli    
  1043aa:	e8 81 e5 ff ff       	call   102930 <cpu>
  1043af:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043b5:	05 44 b7 10 00       	add    $0x10b744,%eax
  1043ba:	8b 88 c0 00 00 00    	mov    0xc0(%eax),%ecx
  1043c0:	8d 51 01             	lea    0x1(%ecx),%edx
  1043c3:	85 c9                	test   %ecx,%ecx
  1043c5:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1043cb:	75 17                	jne    1043e4 <pushcli+0x44>
  1043cd:	e8 5e e5 ff ff       	call   102930 <cpu>
  1043d2:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1043d8:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043de:	89 98 08 b8 10 00    	mov    %ebx,0x10b808(%eax)
  1043e4:	83 c4 04             	add    $0x4,%esp
  1043e7:	5b                   	pop    %ebx
  1043e8:	5d                   	pop    %ebp
  1043e9:	c3                   	ret    
  1043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001043f0 <holding>:
  1043f0:	55                   	push   %ebp
  1043f1:	31 c0                	xor    %eax,%eax
  1043f3:	89 e5                	mov    %esp,%ebp
  1043f5:	53                   	push   %ebx
  1043f6:	83 ec 04             	sub    $0x4,%esp
  1043f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1043fc:	8b 0a                	mov    (%edx),%ecx
  1043fe:	85 c9                	test   %ecx,%ecx
  104400:	75 06                	jne    104408 <holding+0x18>
  104402:	83 c4 04             	add    $0x4,%esp
  104405:	5b                   	pop    %ebx
  104406:	5d                   	pop    %ebp
  104407:	c3                   	ret    
  104408:	8b 5a 08             	mov    0x8(%edx),%ebx
  10440b:	e8 20 e5 ff ff       	call   102930 <cpu>
  104410:	83 c0 0a             	add    $0xa,%eax
  104413:	39 c3                	cmp    %eax,%ebx
  104415:	0f 94 c0             	sete   %al
  104418:	83 c4 04             	add    $0x4,%esp
  10441b:	0f b6 c0             	movzbl %al,%eax
  10441e:	5b                   	pop    %ebx
  10441f:	5d                   	pop    %ebp
  104420:	c3                   	ret    
  104421:	eb 0d                	jmp    104430 <release>
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

00104430 <release>:
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	53                   	push   %ebx
  104434:	83 ec 04             	sub    $0x4,%esp
  104437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10443a:	89 1c 24             	mov    %ebx,(%esp)
  10443d:	e8 ae ff ff ff       	call   1043f0 <holding>
  104442:	85 c0                	test   %eax,%eax
  104444:	74 1d                	je     104463 <release+0x33>
  104446:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  10444d:	31 c0                	xor    %eax,%eax
  10444f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104456:	f0 87 03             	lock xchg %eax,(%ebx)
  104459:	83 c4 04             	add    $0x4,%esp
  10445c:	5b                   	pop    %ebx
  10445d:	5d                   	pop    %ebp
  10445e:	e9 bd fe ff ff       	jmp    104320 <popcli>
  104463:	c7 04 24 f6 6a 10 00 	movl   $0x106af6,(%esp)
  10446a:	e8 01 c5 ff ff       	call   100970 <panic>
  10446f:	90                   	nop

00104470 <acquire>:
  104470:	55                   	push   %ebp
  104471:	89 e5                	mov    %esp,%ebp
  104473:	53                   	push   %ebx
  104474:	83 ec 14             	sub    $0x14,%esp
  104477:	e8 24 ff ff ff       	call   1043a0 <pushcli>
  10447c:	8b 45 08             	mov    0x8(%ebp),%eax
  10447f:	89 04 24             	mov    %eax,(%esp)
  104482:	e8 69 ff ff ff       	call   1043f0 <holding>
  104487:	85 c0                	test   %eax,%eax
  104489:	75 3d                	jne    1044c8 <acquire+0x58>
  10448b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10448e:	ba 01 00 00 00       	mov    $0x1,%edx
  104493:	90                   	nop
  104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104498:	89 d0                	mov    %edx,%eax
  10449a:	f0 87 03             	lock xchg %eax,(%ebx)
  10449d:	83 e8 01             	sub    $0x1,%eax
  1044a0:	74 f6                	je     104498 <acquire+0x28>
  1044a2:	e8 89 e4 ff ff       	call   102930 <cpu>
  1044a7:	83 c0 0a             	add    $0xa,%eax
  1044aa:	89 43 08             	mov    %eax,0x8(%ebx)
  1044ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1044b0:	83 c0 0c             	add    $0xc,%eax
  1044b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044b7:	8d 45 08             	lea    0x8(%ebp),%eax
  1044ba:	89 04 24             	mov    %eax,(%esp)
  1044bd:	e8 fe fd ff ff       	call   1042c0 <getcallerpcs>
  1044c2:	83 c4 14             	add    $0x14,%esp
  1044c5:	5b                   	pop    %ebx
  1044c6:	5d                   	pop    %ebp
  1044c7:	c3                   	ret    
  1044c8:	c7 04 24 fe 6a 10 00 	movl   $0x106afe,(%esp)
  1044cf:	e8 9c c4 ff ff       	call   100970 <panic>
  1044d4:	90                   	nop
  1044d5:	90                   	nop
  1044d6:	90                   	nop
  1044d7:	90                   	nop
  1044d8:	90                   	nop
  1044d9:	90                   	nop
  1044da:	90                   	nop
  1044db:	90                   	nop
  1044dc:	90                   	nop
  1044dd:	90                   	nop
  1044de:	90                   	nop
  1044df:	90                   	nop

001044e0 <memset>:
  1044e0:	55                   	push   %ebp
  1044e1:	89 e5                	mov    %esp,%ebp
  1044e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1044e6:	53                   	push   %ebx
  1044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1044ea:	85 c0                	test   %eax,%eax
  1044ec:	74 14                	je     104502 <memset+0x22>
  1044ee:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  1044f2:	31 d2                	xor    %edx,%edx
  1044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1044f8:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  1044fb:	83 c2 01             	add    $0x1,%edx
  1044fe:	39 c2                	cmp    %eax,%edx
  104500:	75 f6                	jne    1044f8 <memset+0x18>
  104502:	89 d8                	mov    %ebx,%eax
  104504:	5b                   	pop    %ebx
  104505:	5d                   	pop    %ebp
  104506:	c3                   	ret    
  104507:	89 f6                	mov    %esi,%esi
  104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104510 <memcmp>:
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	57                   	push   %edi
  104514:	56                   	push   %esi
  104515:	53                   	push   %ebx
  104516:	8b 55 10             	mov    0x10(%ebp),%edx
  104519:	8b 7d 08             	mov    0x8(%ebp),%edi
  10451c:	8b 75 0c             	mov    0xc(%ebp),%esi
  10451f:	85 d2                	test   %edx,%edx
  104521:	74 2d                	je     104550 <memcmp+0x40>
  104523:	0f b6 1f             	movzbl (%edi),%ebx
  104526:	0f b6 06             	movzbl (%esi),%eax
  104529:	38 c3                	cmp    %al,%bl
  10452b:	75 33                	jne    104560 <memcmp+0x50>
  10452d:	8d 4a ff             	lea    -0x1(%edx),%ecx
  104530:	31 d2                	xor    %edx,%edx
  104532:	eb 18                	jmp    10454c <memcmp+0x3c>
  104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104538:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  10453d:	83 e9 01             	sub    $0x1,%ecx
  104540:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  104545:	83 c2 01             	add    $0x1,%edx
  104548:	38 c3                	cmp    %al,%bl
  10454a:	75 14                	jne    104560 <memcmp+0x50>
  10454c:	85 c9                	test   %ecx,%ecx
  10454e:	75 e8                	jne    104538 <memcmp+0x28>
  104550:	31 d2                	xor    %edx,%edx
  104552:	89 d0                	mov    %edx,%eax
  104554:	5b                   	pop    %ebx
  104555:	5e                   	pop    %esi
  104556:	5f                   	pop    %edi
  104557:	5d                   	pop    %ebp
  104558:	c3                   	ret    
  104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104560:	0f b6 d3             	movzbl %bl,%edx
  104563:	0f b6 c0             	movzbl %al,%eax
  104566:	29 c2                	sub    %eax,%edx
  104568:	89 d0                	mov    %edx,%eax
  10456a:	5b                   	pop    %ebx
  10456b:	5e                   	pop    %esi
  10456c:	5f                   	pop    %edi
  10456d:	5d                   	pop    %ebp
  10456e:	c3                   	ret    
  10456f:	90                   	nop

00104570 <memmove>:
  104570:	55                   	push   %ebp
  104571:	89 e5                	mov    %esp,%ebp
  104573:	57                   	push   %edi
  104574:	56                   	push   %esi
  104575:	53                   	push   %ebx
  104576:	8b 75 08             	mov    0x8(%ebp),%esi
  104579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10457c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10457f:	39 f1                	cmp    %esi,%ecx
  104581:	73 35                	jae    1045b8 <memmove+0x48>
  104583:	8d 3c 19             	lea    (%ecx,%ebx,1),%edi
  104586:	39 fe                	cmp    %edi,%esi
  104588:	73 2e                	jae    1045b8 <memmove+0x48>
  10458a:	85 db                	test   %ebx,%ebx
  10458c:	74 1d                	je     1045ab <memmove+0x3b>
  10458e:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  104591:	31 d2                	xor    %edx,%edx
  104593:	90                   	nop
  104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104598:	0f b6 44 17 ff       	movzbl -0x1(%edi,%edx,1),%eax
  10459d:	88 44 11 ff          	mov    %al,-0x1(%ecx,%edx,1)
  1045a1:	83 ea 01             	sub    $0x1,%edx
  1045a4:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  1045a7:	85 c0                	test   %eax,%eax
  1045a9:	75 ed                	jne    104598 <memmove+0x28>
  1045ab:	89 f0                	mov    %esi,%eax
  1045ad:	5b                   	pop    %ebx
  1045ae:	5e                   	pop    %esi
  1045af:	5f                   	pop    %edi
  1045b0:	5d                   	pop    %ebp
  1045b1:	c3                   	ret    
  1045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1045b8:	31 d2                	xor    %edx,%edx
  1045ba:	85 db                	test   %ebx,%ebx
  1045bc:	74 ed                	je     1045ab <memmove+0x3b>
  1045be:	66 90                	xchg   %ax,%ax
  1045c0:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  1045c4:	88 04 16             	mov    %al,(%esi,%edx,1)
  1045c7:	83 c2 01             	add    $0x1,%edx
  1045ca:	39 d3                	cmp    %edx,%ebx
  1045cc:	75 f2                	jne    1045c0 <memmove+0x50>
  1045ce:	89 f0                	mov    %esi,%eax
  1045d0:	5b                   	pop    %ebx
  1045d1:	5e                   	pop    %esi
  1045d2:	5f                   	pop    %edi
  1045d3:	5d                   	pop    %ebp
  1045d4:	c3                   	ret    
  1045d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001045e0 <strncmp>:
  1045e0:	55                   	push   %ebp
  1045e1:	89 e5                	mov    %esp,%ebp
  1045e3:	56                   	push   %esi
  1045e4:	53                   	push   %ebx
  1045e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1045e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1045eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  1045ee:	85 c9                	test   %ecx,%ecx
  1045f0:	75 1e                	jne    104610 <strncmp+0x30>
  1045f2:	eb 34                	jmp    104628 <strncmp+0x48>
  1045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045f8:	0f b6 16             	movzbl (%esi),%edx
  1045fb:	38 d0                	cmp    %dl,%al
  1045fd:	75 1b                	jne    10461a <strncmp+0x3a>
  1045ff:	83 e9 01             	sub    $0x1,%ecx
  104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104608:	74 1e                	je     104628 <strncmp+0x48>
  10460a:	83 c3 01             	add    $0x1,%ebx
  10460d:	83 c6 01             	add    $0x1,%esi
  104610:	0f b6 03             	movzbl (%ebx),%eax
  104613:	84 c0                	test   %al,%al
  104615:	75 e1                	jne    1045f8 <strncmp+0x18>
  104617:	0f b6 16             	movzbl (%esi),%edx
  10461a:	0f b6 c8             	movzbl %al,%ecx
  10461d:	0f b6 c2             	movzbl %dl,%eax
  104620:	29 c1                	sub    %eax,%ecx
  104622:	89 c8                	mov    %ecx,%eax
  104624:	5b                   	pop    %ebx
  104625:	5e                   	pop    %esi
  104626:	5d                   	pop    %ebp
  104627:	c3                   	ret    
  104628:	31 c9                	xor    %ecx,%ecx
  10462a:	89 c8                	mov    %ecx,%eax
  10462c:	5b                   	pop    %ebx
  10462d:	5e                   	pop    %esi
  10462e:	5d                   	pop    %ebp
  10462f:	c3                   	ret    

00104630 <strncpy>:
  104630:	55                   	push   %ebp
  104631:	89 e5                	mov    %esp,%ebp
  104633:	56                   	push   %esi
  104634:	8b 75 08             	mov    0x8(%ebp),%esi
  104637:	53                   	push   %ebx
  104638:	8b 55 10             	mov    0x10(%ebp),%edx
  10463b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10463e:	89 f1                	mov    %esi,%ecx
  104640:	eb 09                	jmp    10464b <strncpy+0x1b>
  104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104648:	83 c3 01             	add    $0x1,%ebx
  10464b:	83 ea 01             	sub    $0x1,%edx
  10464e:	8d 42 01             	lea    0x1(%edx),%eax
  104651:	85 c0                	test   %eax,%eax
  104653:	7e 0c                	jle    104661 <strncpy+0x31>
  104655:	0f b6 03             	movzbl (%ebx),%eax
  104658:	88 01                	mov    %al,(%ecx)
  10465a:	83 c1 01             	add    $0x1,%ecx
  10465d:	84 c0                	test   %al,%al
  10465f:	75 e7                	jne    104648 <strncpy+0x18>
  104661:	31 c0                	xor    %eax,%eax
  104663:	85 d2                	test   %edx,%edx
  104665:	7e 0c                	jle    104673 <strncpy+0x43>
  104667:	90                   	nop
  104668:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
  10466c:	83 c0 01             	add    $0x1,%eax
  10466f:	39 d0                	cmp    %edx,%eax
  104671:	75 f5                	jne    104668 <strncpy+0x38>
  104673:	89 f0                	mov    %esi,%eax
  104675:	5b                   	pop    %ebx
  104676:	5e                   	pop    %esi
  104677:	5d                   	pop    %ebp
  104678:	c3                   	ret    
  104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104680 <safestrcpy>:
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104686:	56                   	push   %esi
  104687:	8b 75 08             	mov    0x8(%ebp),%esi
  10468a:	53                   	push   %ebx
  10468b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10468e:	85 c9                	test   %ecx,%ecx
  104690:	7e 1f                	jle    1046b1 <safestrcpy+0x31>
  104692:	89 f2                	mov    %esi,%edx
  104694:	eb 05                	jmp    10469b <safestrcpy+0x1b>
  104696:	66 90                	xchg   %ax,%ax
  104698:	83 c3 01             	add    $0x1,%ebx
  10469b:	83 e9 01             	sub    $0x1,%ecx
  10469e:	85 c9                	test   %ecx,%ecx
  1046a0:	7e 0c                	jle    1046ae <safestrcpy+0x2e>
  1046a2:	0f b6 03             	movzbl (%ebx),%eax
  1046a5:	88 02                	mov    %al,(%edx)
  1046a7:	83 c2 01             	add    $0x1,%edx
  1046aa:	84 c0                	test   %al,%al
  1046ac:	75 ea                	jne    104698 <safestrcpy+0x18>
  1046ae:	c6 02 00             	movb   $0x0,(%edx)
  1046b1:	89 f0                	mov    %esi,%eax
  1046b3:	5b                   	pop    %ebx
  1046b4:	5e                   	pop    %esi
  1046b5:	5d                   	pop    %ebp
  1046b6:	c3                   	ret    
  1046b7:	89 f6                	mov    %esi,%esi
  1046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001046c0 <strlen>:
  1046c0:	55                   	push   %ebp
  1046c1:	31 c0                	xor    %eax,%eax
  1046c3:	89 e5                	mov    %esp,%ebp
  1046c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1046c8:	80 3a 00             	cmpb   $0x0,(%edx)
  1046cb:	74 0c                	je     1046d9 <strlen+0x19>
  1046cd:	8d 76 00             	lea    0x0(%esi),%esi
  1046d0:	83 c0 01             	add    $0x1,%eax
  1046d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1046d7:	75 f7                	jne    1046d0 <strlen+0x10>
  1046d9:	5d                   	pop    %ebp
  1046da:	c3                   	ret    
  1046db:	90                   	nop

001046dc <swtch>:
  1046dc:	8b 44 24 04          	mov    0x4(%esp),%eax
  1046e0:	8f 00                	popl   (%eax)
  1046e2:	89 60 04             	mov    %esp,0x4(%eax)
  1046e5:	89 58 08             	mov    %ebx,0x8(%eax)
  1046e8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1046eb:	89 50 10             	mov    %edx,0x10(%eax)
  1046ee:	89 70 14             	mov    %esi,0x14(%eax)
  1046f1:	89 78 18             	mov    %edi,0x18(%eax)
  1046f4:	89 68 1c             	mov    %ebp,0x1c(%eax)
  1046f7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1046fb:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1046fe:	8b 78 18             	mov    0x18(%eax),%edi
  104701:	8b 70 14             	mov    0x14(%eax),%esi
  104704:	8b 50 10             	mov    0x10(%eax),%edx
  104707:	8b 48 0c             	mov    0xc(%eax),%ecx
  10470a:	8b 58 08             	mov    0x8(%eax),%ebx
  10470d:	8b 60 04             	mov    0x4(%eax),%esp
  104710:	ff 30                	pushl  (%eax)
  104712:	c3                   	ret    
  104713:	90                   	nop
  104714:	90                   	nop
  104715:	90                   	nop
  104716:	90                   	nop
  104717:	90                   	nop
  104718:	90                   	nop
  104719:	90                   	nop
  10471a:	90                   	nop
  10471b:	90                   	nop
  10471c:	90                   	nop
  10471d:	90                   	nop
  10471e:	90                   	nop
  10471f:	90                   	nop

00104720 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104720:	55                   	push   %ebp
  104721:	89 e5                	mov    %esp,%ebp
  104723:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104726:	53                   	push   %ebx
  104727:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  10472a:	8b 51 04             	mov    0x4(%ecx),%edx
  10472d:	39 c2                	cmp    %eax,%edx
  10472f:	77 0f                	ja     104740 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104736:	5b                   	pop    %ebx
  104737:	5d                   	pop    %ebp
  104738:	c3                   	ret    
  104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104740:	8d 58 04             	lea    0x4(%eax),%ebx
  104743:	39 da                	cmp    %ebx,%edx
  104745:	72 ea                	jb     104731 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104747:	8b 11                	mov    (%ecx),%edx
  104749:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10474c:	8b 45 10             	mov    0x10(%ebp),%eax
  10474f:	89 10                	mov    %edx,(%eax)
  104751:	31 c0                	xor    %eax,%eax
  return 0;
  104753:	eb e1                	jmp    104736 <fetchint+0x16>
  104755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104760 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104760:	55                   	push   %ebp
  104761:	89 e5                	mov    %esp,%ebp
  104763:	8b 45 08             	mov    0x8(%ebp),%eax
  104766:	8b 55 0c             	mov    0xc(%ebp),%edx
  104769:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10476a:	39 50 04             	cmp    %edx,0x4(%eax)
  10476d:	77 09                	ja     104778 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10476f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104774:	5b                   	pop    %ebx
  104775:	5d                   	pop    %ebp
  104776:	c3                   	ret    
  104777:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104778:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10477b:	03 10                	add    (%eax),%edx
  10477d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  10477f:	8b 18                	mov    (%eax),%ebx
  104781:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  104784:	39 da                	cmp    %ebx,%edx
  104786:	73 e7                	jae    10476f <fetchstr+0xf>
    if(*s == 0)
  104788:	31 c0                	xor    %eax,%eax
  10478a:	89 d1                	mov    %edx,%ecx
  10478c:	80 3a 00             	cmpb   $0x0,(%edx)
  10478f:	74 e3                	je     104774 <fetchstr+0x14>
  104791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104798:	83 c1 01             	add    $0x1,%ecx
  10479b:	39 cb                	cmp    %ecx,%ebx
  10479d:	76 d0                	jbe    10476f <fetchstr+0xf>
    if(*s == 0)
  10479f:	80 39 00             	cmpb   $0x0,(%ecx)
  1047a2:	75 f4                	jne    104798 <fetchstr+0x38>
  1047a4:	89 c8                	mov    %ecx,%eax
  1047a6:	29 d0                	sub    %edx,%eax
  1047a8:	eb ca                	jmp    104774 <fetchstr+0x14>
  1047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001047b0 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1047b0:	55                   	push   %ebp
  1047b1:	89 e5                	mov    %esp,%ebp
  1047b3:	53                   	push   %ebx
  1047b4:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1047b7:	e8 d4 ec ff ff       	call   103490 <curproc>
  1047bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1047bf:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1047c5:	8b 40 3c             	mov    0x3c(%eax),%eax
  1047c8:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  1047cc:	e8 bf ec ff ff       	call   103490 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047d1:	8b 50 04             	mov    0x4(%eax),%edx
  1047d4:	39 d3                	cmp    %edx,%ebx
  1047d6:	72 10                	jb     1047e8 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  1047dd:	83 c4 04             	add    $0x4,%esp
  1047e0:	5b                   	pop    %ebx
  1047e1:	5d                   	pop    %ebp
  1047e2:	c3                   	ret    
  1047e3:	90                   	nop
  1047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047e8:	8d 4b 04             	lea    0x4(%ebx),%ecx
  1047eb:	39 ca                	cmp    %ecx,%edx
  1047ed:	72 e9                	jb     1047d8 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047ef:	8b 00                	mov    (%eax),%eax
  1047f1:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  1047f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047f7:	89 10                	mov    %edx,(%eax)
  1047f9:	31 c0                	xor    %eax,%eax
  1047fb:	eb e0                	jmp    1047dd <argint+0x2d>
  1047fd:	8d 76 00             	lea    0x0(%esi),%esi

00104800 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104800:	55                   	push   %ebp
  104801:	89 e5                	mov    %esp,%ebp
  104803:	53                   	push   %ebx
  104804:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10480a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10480e:	8b 45 08             	mov    0x8(%ebp),%eax
  104811:	89 04 24             	mov    %eax,(%esp)
  104814:	e8 97 ff ff ff       	call   1047b0 <argint>
  104819:	85 c0                	test   %eax,%eax
  10481b:	78 3b                	js     104858 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  10481d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104820:	e8 6b ec ff ff       	call   103490 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104825:	3b 58 04             	cmp    0x4(%eax),%ebx
  104828:	73 2e                	jae    104858 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  10482a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10482d:	03 18                	add    (%eax),%ebx
  10482f:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104831:	8b 08                	mov    (%eax),%ecx
  104833:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104836:	39 cb                	cmp    %ecx,%ebx
  104838:	73 1e                	jae    104858 <argstr+0x58>
    if(*s == 0)
  10483a:	31 c0                	xor    %eax,%eax
  10483c:	89 da                	mov    %ebx,%edx
  10483e:	80 3b 00             	cmpb   $0x0,(%ebx)
  104841:	75 0a                	jne    10484d <argstr+0x4d>
  104843:	eb 18                	jmp    10485d <argstr+0x5d>
  104845:	8d 76 00             	lea    0x0(%esi),%esi
  104848:	80 3a 00             	cmpb   $0x0,(%edx)
  10484b:	74 1b                	je     104868 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10484d:	83 c2 01             	add    $0x1,%edx
  104850:	39 d1                	cmp    %edx,%ecx
  104852:	77 f4                	ja     104848 <argstr+0x48>
  104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10485d:	83 c4 24             	add    $0x24,%esp
  104860:	5b                   	pop    %ebx
  104861:	5d                   	pop    %ebp
  104862:	c3                   	ret    
  104863:	90                   	nop
  104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104868:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10486a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10486d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10486f:	5b                   	pop    %ebx
  104870:	5d                   	pop    %ebp
  104871:	c3                   	ret    
  104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104880 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104880:	55                   	push   %ebp
  104881:	89 e5                	mov    %esp,%ebp
  104883:	53                   	push   %ebx
  104884:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104887:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10488a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10488e:	8b 45 08             	mov    0x8(%ebp),%eax
  104891:	89 04 24             	mov    %eax,(%esp)
  104894:	e8 17 ff ff ff       	call   1047b0 <argint>
  104899:	85 c0                	test   %eax,%eax
  10489b:	79 0b                	jns    1048a8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  10489d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048a2:	83 c4 24             	add    $0x24,%esp
  1048a5:	5b                   	pop    %ebx
  1048a6:	5d                   	pop    %ebp
  1048a7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1048a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1048ab:	e8 e0 eb ff ff       	call   103490 <curproc>
  1048b0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1048b3:	73 e8                	jae    10489d <argptr+0x1d>
  1048b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1048b8:	03 5d f4             	add    -0xc(%ebp),%ebx
  1048bb:	e8 d0 eb ff ff       	call   103490 <curproc>
  1048c0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1048c3:	73 d8                	jae    10489d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1048c5:	e8 c6 eb ff ff       	call   103490 <curproc>
  1048ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048cd:	8b 00                	mov    (%eax),%eax
  1048cf:	03 45 f4             	add    -0xc(%ebp),%eax
  1048d2:	89 02                	mov    %eax,(%edx)
  1048d4:	31 c0                	xor    %eax,%eax
  return 0;
  1048d6:	eb ca                	jmp    1048a2 <argptr+0x22>
  1048d8:	90                   	nop
  1048d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001048e0 <syscall>:
[SYS_wait_thread] sys_wait_thread,
};

void
syscall(void)
{
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	83 ec 18             	sub    $0x18,%esp
  1048e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1048e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1048ec:	e8 9f eb ff ff       	call   103490 <curproc>
  1048f1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1048f7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  1048fa:	83 fb 18             	cmp    $0x18,%ebx
  1048fd:	77 29                	ja     104928 <syscall+0x48>
  1048ff:	8b 34 9d 40 6b 10 00 	mov    0x106b40(,%ebx,4),%esi
  104906:	85 f6                	test   %esi,%esi
  104908:	74 1e                	je     104928 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  10490a:	e8 81 eb ff ff       	call   103490 <curproc>
  10490f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104915:	ff d6                	call   *%esi
  104917:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10491a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10491d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104920:	89 ec                	mov    %ebp,%esp
  104922:	5d                   	pop    %ebp
  104923:	c3                   	ret    
  104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104928:	e8 63 eb ff ff       	call   103490 <curproc>
  10492d:	89 c6                	mov    %eax,%esi
  10492f:	e8 5c eb ff ff       	call   103490 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104934:	81 c6 88 00 00 00    	add    $0x88,%esi
  10493a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10493e:	89 74 24 08          	mov    %esi,0x8(%esp)
  104942:	8b 40 10             	mov    0x10(%eax),%eax
  104945:	c7 04 24 06 6b 10 00 	movl   $0x106b06,(%esp)
  10494c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104950:	e8 4b be ff ff       	call   1007a0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104955:	e8 36 eb ff ff       	call   103490 <curproc>
  10495a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104960:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104967:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10496a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10496d:	89 ec                	mov    %ebp,%esp
  10496f:	5d                   	pop    %ebp
  104970:	c3                   	ret    
  104971:	90                   	nop
  104972:	90                   	nop
  104973:	90                   	nop
  104974:	90                   	nop
  104975:	90                   	nop
  104976:	90                   	nop
  104977:	90                   	nop
  104978:	90                   	nop
  104979:	90                   	nop
  10497a:	90                   	nop
  10497b:	90                   	nop
  10497c:	90                   	nop
  10497d:	90                   	nop
  10497e:	90                   	nop
  10497f:	90                   	nop

00104980 <fdalloc>:
  104980:	55                   	push   %ebp
  104981:	89 e5                	mov    %esp,%ebp
  104983:	57                   	push   %edi
  104984:	89 c7                	mov    %eax,%edi
  104986:	56                   	push   %esi
  104987:	53                   	push   %ebx
  104988:	31 db                	xor    %ebx,%ebx
  10498a:	83 ec 0c             	sub    $0xc,%esp
  10498d:	8d 76 00             	lea    0x0(%esi),%esi
  104990:	e8 fb ea ff ff       	call   103490 <curproc>
  104995:	8d 73 08             	lea    0x8(%ebx),%esi
  104998:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  10499b:	85 c0                	test   %eax,%eax
  10499d:	74 19                	je     1049b8 <fdalloc+0x38>
  10499f:	83 c3 01             	add    $0x1,%ebx
  1049a2:	83 fb 10             	cmp    $0x10,%ebx
  1049a5:	75 e9                	jne    104990 <fdalloc+0x10>
  1049a7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1049ac:	83 c4 0c             	add    $0xc,%esp
  1049af:	89 d8                	mov    %ebx,%eax
  1049b1:	5b                   	pop    %ebx
  1049b2:	5e                   	pop    %esi
  1049b3:	5f                   	pop    %edi
  1049b4:	5d                   	pop    %ebp
  1049b5:	c3                   	ret    
  1049b6:	66 90                	xchg   %ax,%ax
  1049b8:	e8 d3 ea ff ff       	call   103490 <curproc>
  1049bd:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  1049c0:	83 c4 0c             	add    $0xc,%esp
  1049c3:	89 d8                	mov    %ebx,%eax
  1049c5:	5b                   	pop    %ebx
  1049c6:	5e                   	pop    %esi
  1049c7:	5f                   	pop    %edi
  1049c8:	5d                   	pop    %ebp
  1049c9:	c3                   	ret    
  1049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001049d0 <sys_pipe>:
  1049d0:	55                   	push   %ebp
  1049d1:	89 e5                	mov    %esp,%ebp
  1049d3:	53                   	push   %ebx
  1049d4:	83 ec 24             	sub    $0x24,%esp
  1049d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1049da:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1049e1:	00 
  1049e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1049ed:	e8 8e fe ff ff       	call   104880 <argptr>
  1049f2:	85 c0                	test   %eax,%eax
  1049f4:	79 12                	jns    104a08 <sys_pipe+0x38>
  1049f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1049fb:	83 c4 24             	add    $0x24,%esp
  1049fe:	5b                   	pop    %ebx
  1049ff:	5d                   	pop    %ebp
  104a00:	c3                   	ret    
  104a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104a08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104a12:	89 04 24             	mov    %eax,(%esp)
  104a15:	e8 06 e7 ff ff       	call   103120 <pipealloc>
  104a1a:	85 c0                	test   %eax,%eax
  104a1c:	78 d8                	js     1049f6 <sys_pipe+0x26>
  104a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a21:	e8 5a ff ff ff       	call   104980 <fdalloc>
  104a26:	85 c0                	test   %eax,%eax
  104a28:	89 c3                	mov    %eax,%ebx
  104a2a:	78 27                	js     104a53 <sys_pipe+0x83>
  104a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a2f:	e8 4c ff ff ff       	call   104980 <fdalloc>
  104a34:	85 c0                	test   %eax,%eax
  104a36:	89 c2                	mov    %eax,%edx
  104a38:	78 0c                	js     104a46 <sys_pipe+0x76>
  104a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104a3d:	89 18                	mov    %ebx,(%eax)
  104a3f:	89 50 04             	mov    %edx,0x4(%eax)
  104a42:	31 c0                	xor    %eax,%eax
  104a44:	eb b5                	jmp    1049fb <sys_pipe+0x2b>
  104a46:	e8 45 ea ff ff       	call   103490 <curproc>
  104a4b:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104a52:	00 
  104a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a56:	89 04 24             	mov    %eax,(%esp)
  104a59:	e8 e2 c5 ff ff       	call   101040 <fileclose>
  104a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a61:	89 04 24             	mov    %eax,(%esp)
  104a64:	e8 d7 c5 ff ff       	call   101040 <fileclose>
  104a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104a6e:	eb 8b                	jmp    1049fb <sys_pipe+0x2b>

00104a70 <argfd>:
  104a70:	55                   	push   %ebp
  104a71:	89 e5                	mov    %esp,%ebp
  104a73:	83 ec 28             	sub    $0x28,%esp
  104a76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a79:	89 d3                	mov    %edx,%ebx
  104a7b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104a7e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104a81:	89 ce                	mov    %ecx,%esi
  104a83:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a87:	89 04 24             	mov    %eax,(%esp)
  104a8a:	e8 21 fd ff ff       	call   1047b0 <argint>
  104a8f:	85 c0                	test   %eax,%eax
  104a91:	79 15                	jns    104aa8 <argfd+0x38>
  104a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104a98:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a9b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a9e:	89 ec                	mov    %ebp,%esp
  104aa0:	5d                   	pop    %ebp
  104aa1:	c3                   	ret    
  104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104aa8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104aac:	77 e5                	ja     104a93 <argfd+0x23>
  104aae:	e8 dd e9 ff ff       	call   103490 <curproc>
  104ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ab6:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104aba:	85 c9                	test   %ecx,%ecx
  104abc:	74 d5                	je     104a93 <argfd+0x23>
  104abe:	85 db                	test   %ebx,%ebx
  104ac0:	74 02                	je     104ac4 <argfd+0x54>
  104ac2:	89 13                	mov    %edx,(%ebx)
  104ac4:	31 c0                	xor    %eax,%eax
  104ac6:	85 f6                	test   %esi,%esi
  104ac8:	74 ce                	je     104a98 <argfd+0x28>
  104aca:	89 0e                	mov    %ecx,(%esi)
  104acc:	31 c0                	xor    %eax,%eax
  104ace:	eb c8                	jmp    104a98 <argfd+0x28>

00104ad0 <sys_close>:
  104ad0:	55                   	push   %ebp
  104ad1:	31 c0                	xor    %eax,%eax
  104ad3:	89 e5                	mov    %esp,%ebp
  104ad5:	83 ec 18             	sub    $0x18,%esp
  104ad8:	8d 55 fc             	lea    -0x4(%ebp),%edx
  104adb:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104ade:	e8 8d ff ff ff       	call   104a70 <argfd>
  104ae3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104ae8:	85 c0                	test   %eax,%eax
  104aea:	78 1d                	js     104b09 <sys_close+0x39>
  104aec:	e8 9f e9 ff ff       	call   103490 <curproc>
  104af1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104af4:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  104afb:	00 
  104afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104aff:	89 04 24             	mov    %eax,(%esp)
  104b02:	e8 39 c5 ff ff       	call   101040 <fileclose>
  104b07:	31 d2                	xor    %edx,%edx
  104b09:	89 d0                	mov    %edx,%eax
  104b0b:	c9                   	leave  
  104b0c:	c3                   	ret    
  104b0d:	8d 76 00             	lea    0x0(%esi),%esi

00104b10 <sys_exec>:
  104b10:	55                   	push   %ebp
  104b11:	89 e5                	mov    %esp,%ebp
  104b13:	83 ec 78             	sub    $0x78,%esp
  104b16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104b19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  104b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b2d:	e8 ce fc ff ff       	call   104800 <argstr>
  104b32:	85 c0                	test   %eax,%eax
  104b34:	79 12                	jns    104b48 <sys_exec+0x38>
  104b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104b3b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b3e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b41:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b44:	89 ec                	mov    %ebp,%esp
  104b46:	5d                   	pop    %ebp
  104b47:	c3                   	ret    
  104b48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b56:	e8 55 fc ff ff       	call   1047b0 <argint>
  104b5b:	85 c0                	test   %eax,%eax
  104b5d:	78 d7                	js     104b36 <sys_exec+0x26>
  104b5f:	8d 45 98             	lea    -0x68(%ebp),%eax
  104b62:	31 f6                	xor    %esi,%esi
  104b64:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104b6b:	00 
  104b6c:	31 ff                	xor    %edi,%edi
  104b6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b75:	00 
  104b76:	89 04 24             	mov    %eax,(%esp)
  104b79:	e8 62 f9 ff ff       	call   1044e0 <memset>
  104b7e:	eb 27                	jmp    104ba7 <sys_exec+0x97>
  104b80:	e8 0b e9 ff ff       	call   103490 <curproc>
  104b85:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104b89:	89 54 24 08          	mov    %edx,0x8(%esp)
  104b8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104b91:	89 04 24             	mov    %eax,(%esp)
  104b94:	e8 c7 fb ff ff       	call   104760 <fetchstr>
  104b99:	85 c0                	test   %eax,%eax
  104b9b:	78 99                	js     104b36 <sys_exec+0x26>
  104b9d:	83 c6 01             	add    $0x1,%esi
  104ba0:	83 fe 14             	cmp    $0x14,%esi
  104ba3:	89 f7                	mov    %esi,%edi
  104ba5:	74 8f                	je     104b36 <sys_exec+0x26>
  104ba7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104bae:	03 5d ec             	add    -0x14(%ebp),%ebx
  104bb1:	e8 da e8 ff ff       	call   103490 <curproc>
  104bb6:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104bb9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104bbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104bc1:	89 04 24             	mov    %eax,(%esp)
  104bc4:	e8 57 fb ff ff       	call   104720 <fetchint>
  104bc9:	85 c0                	test   %eax,%eax
  104bcb:	0f 88 65 ff ff ff    	js     104b36 <sys_exec+0x26>
  104bd1:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104bd4:	85 db                	test   %ebx,%ebx
  104bd6:	75 a8                	jne    104b80 <sys_exec+0x70>
  104bd8:	8d 45 98             	lea    -0x68(%ebp),%eax
  104bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104be2:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104be9:	00 
  104bea:	89 04 24             	mov    %eax,(%esp)
  104bed:	e8 fe bd ff ff       	call   1009f0 <exec>
  104bf2:	e9 44 ff ff ff       	jmp    104b3b <sys_exec+0x2b>
  104bf7:	89 f6                	mov    %esi,%esi
  104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104c00 <sys_chdir>:
  104c00:	55                   	push   %ebp
  104c01:	89 e5                	mov    %esp,%ebp
  104c03:	53                   	push   %ebx
  104c04:	83 ec 24             	sub    $0x24,%esp
  104c07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c15:	e8 e6 fb ff ff       	call   104800 <argstr>
  104c1a:	85 c0                	test   %eax,%eax
  104c1c:	79 12                	jns    104c30 <sys_chdir+0x30>
  104c1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104c23:	83 c4 24             	add    $0x24,%esp
  104c26:	5b                   	pop    %ebx
  104c27:	5d                   	pop    %ebp
  104c28:	c3                   	ret    
  104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c33:	89 04 24             	mov    %eax,(%esp)
  104c36:	e8 75 d3 ff ff       	call   101fb0 <namei>
  104c3b:	85 c0                	test   %eax,%eax
  104c3d:	89 c3                	mov    %eax,%ebx
  104c3f:	74 dd                	je     104c1e <sys_chdir+0x1e>
  104c41:	89 04 24             	mov    %eax,(%esp)
  104c44:	e8 b7 d0 ff ff       	call   101d00 <ilock>
  104c49:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104c4e:	75 24                	jne    104c74 <sys_chdir+0x74>
  104c50:	89 1c 24             	mov    %ebx,(%esp)
  104c53:	e8 28 d0 ff ff       	call   101c80 <iunlock>
  104c58:	e8 33 e8 ff ff       	call   103490 <curproc>
  104c5d:	8b 40 60             	mov    0x60(%eax),%eax
  104c60:	89 04 24             	mov    %eax,(%esp)
  104c63:	e8 c8 cd ff ff       	call   101a30 <iput>
  104c68:	e8 23 e8 ff ff       	call   103490 <curproc>
  104c6d:	89 58 60             	mov    %ebx,0x60(%eax)
  104c70:	31 c0                	xor    %eax,%eax
  104c72:	eb af                	jmp    104c23 <sys_chdir+0x23>
  104c74:	89 1c 24             	mov    %ebx,(%esp)
  104c77:	e8 64 d0 ff ff       	call   101ce0 <iunlockput>
  104c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104c81:	eb a0                	jmp    104c23 <sys_chdir+0x23>
  104c83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104c90 <sys_link>:
  104c90:	55                   	push   %ebp
  104c91:	89 e5                	mov    %esp,%ebp
  104c93:	83 ec 38             	sub    $0x38,%esp
  104c96:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104c99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104c9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104c9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  104ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ca6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104cad:	e8 4e fb ff ff       	call   104800 <argstr>
  104cb2:	85 c0                	test   %eax,%eax
  104cb4:	79 12                	jns    104cc8 <sys_link+0x38>
  104cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104cbb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104cbe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104cc1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104cc4:	89 ec                	mov    %ebp,%esp
  104cc6:	5d                   	pop    %ebp
  104cc7:	c3                   	ret    
  104cc8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ccf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cd6:	e8 25 fb ff ff       	call   104800 <argstr>
  104cdb:	85 c0                	test   %eax,%eax
  104cdd:	78 d7                	js     104cb6 <sys_link+0x26>
  104cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ce2:	89 04 24             	mov    %eax,(%esp)
  104ce5:	e8 c6 d2 ff ff       	call   101fb0 <namei>
  104cea:	85 c0                	test   %eax,%eax
  104cec:	89 c3                	mov    %eax,%ebx
  104cee:	74 c6                	je     104cb6 <sys_link+0x26>
  104cf0:	89 04 24             	mov    %eax,(%esp)
  104cf3:	e8 08 d0 ff ff       	call   101d00 <ilock>
  104cf8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104cfd:	74 58                	je     104d57 <sys_link+0xc7>
  104cff:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  104d04:	8d 7d de             	lea    -0x22(%ebp),%edi
  104d07:	89 1c 24             	mov    %ebx,(%esp)
  104d0a:	e8 81 c8 ff ff       	call   101590 <iupdate>
  104d0f:	89 1c 24             	mov    %ebx,(%esp)
  104d12:	e8 69 cf ff ff       	call   101c80 <iunlock>
  104d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d1e:	89 04 24             	mov    %eax,(%esp)
  104d21:	e8 6a d2 ff ff       	call   101f90 <nameiparent>
  104d26:	85 c0                	test   %eax,%eax
  104d28:	89 c6                	mov    %eax,%esi
  104d2a:	74 16                	je     104d42 <sys_link+0xb2>
  104d2c:	89 04 24             	mov    %eax,(%esp)
  104d2f:	e8 cc cf ff ff       	call   101d00 <ilock>
  104d34:	8b 06                	mov    (%esi),%eax
  104d36:	3b 03                	cmp    (%ebx),%eax
  104d38:	74 2f                	je     104d69 <sys_link+0xd9>
  104d3a:	89 34 24             	mov    %esi,(%esp)
  104d3d:	e8 9e cf ff ff       	call   101ce0 <iunlockput>
  104d42:	89 1c 24             	mov    %ebx,(%esp)
  104d45:	e8 b6 cf ff ff       	call   101d00 <ilock>
  104d4a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  104d4f:	89 1c 24             	mov    %ebx,(%esp)
  104d52:	e8 39 c8 ff ff       	call   101590 <iupdate>
  104d57:	89 1c 24             	mov    %ebx,(%esp)
  104d5a:	e8 81 cf ff ff       	call   101ce0 <iunlockput>
  104d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104d64:	e9 52 ff ff ff       	jmp    104cbb <sys_link+0x2b>
  104d69:	8b 43 04             	mov    0x4(%ebx),%eax
  104d6c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d70:	89 34 24             	mov    %esi,(%esp)
  104d73:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d77:	e8 14 ce ff ff       	call   101b90 <dirlink>
  104d7c:	85 c0                	test   %eax,%eax
  104d7e:	78 ba                	js     104d3a <sys_link+0xaa>
  104d80:	89 34 24             	mov    %esi,(%esp)
  104d83:	e8 58 cf ff ff       	call   101ce0 <iunlockput>
  104d88:	89 1c 24             	mov    %ebx,(%esp)
  104d8b:	e8 a0 cc ff ff       	call   101a30 <iput>
  104d90:	31 c0                	xor    %eax,%eax
  104d92:	e9 24 ff ff ff       	jmp    104cbb <sys_link+0x2b>
  104d97:	89 f6                	mov    %esi,%esi
  104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104da0 <create>:
  104da0:	55                   	push   %ebp
  104da1:	89 e5                	mov    %esp,%ebp
  104da3:	57                   	push   %edi
  104da4:	89 d7                	mov    %edx,%edi
  104da6:	56                   	push   %esi
  104da7:	53                   	push   %ebx
  104da8:	31 db                	xor    %ebx,%ebx
  104daa:	83 ec 3c             	sub    $0x3c,%esp
  104dad:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104db1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104db5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104db9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104dbd:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  104dc1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104dc4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104dc8:	89 04 24             	mov    %eax,(%esp)
  104dcb:	e8 c0 d1 ff ff       	call   101f90 <nameiparent>
  104dd0:	85 c0                	test   %eax,%eax
  104dd2:	89 c6                	mov    %eax,%esi
  104dd4:	74 77                	je     104e4d <create+0xad>
  104dd6:	89 04 24             	mov    %eax,(%esp)
  104dd9:	e8 22 cf ff ff       	call   101d00 <ilock>
  104dde:	85 ff                	test   %edi,%edi
  104de0:	75 76                	jne    104e58 <create+0xb8>
  104de2:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104de6:	89 44 24 04          	mov    %eax,0x4(%esp)
  104dea:	8b 06                	mov    (%esi),%eax
  104dec:	89 04 24             	mov    %eax,(%esp)
  104def:	e8 ac ca ff ff       	call   1018a0 <ialloc>
  104df4:	85 c0                	test   %eax,%eax
  104df6:	89 c3                	mov    %eax,%ebx
  104df8:	74 4b                	je     104e45 <create+0xa5>
  104dfa:	89 04 24             	mov    %eax,(%esp)
  104dfd:	e8 fe ce ff ff       	call   101d00 <ilock>
  104e02:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104e06:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104e0a:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  104e10:	66 89 43 12          	mov    %ax,0x12(%ebx)
  104e14:	66 89 53 14          	mov    %dx,0x14(%ebx)
  104e18:	89 1c 24             	mov    %ebx,(%esp)
  104e1b:	e8 70 c7 ff ff       	call   101590 <iupdate>
  104e20:	8b 43 04             	mov    0x4(%ebx),%eax
  104e23:	89 34 24             	mov    %esi,(%esp)
  104e26:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e2a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e31:	e8 5a cd ff ff       	call   101b90 <dirlink>
  104e36:	85 c0                	test   %eax,%eax
  104e38:	0f 88 d5 00 00 00    	js     104f13 <create+0x173>
  104e3e:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  104e43:	74 7b                	je     104ec0 <create+0x120>
  104e45:	89 34 24             	mov    %esi,(%esp)
  104e48:	e8 93 ce ff ff       	call   101ce0 <iunlockput>
  104e4d:	83 c4 3c             	add    $0x3c,%esp
  104e50:	89 d8                	mov    %ebx,%eax
  104e52:	5b                   	pop    %ebx
  104e53:	5e                   	pop    %esi
  104e54:	5f                   	pop    %edi
  104e55:	5d                   	pop    %ebp
  104e56:	c3                   	ret    
  104e57:	90                   	nop
  104e58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e5f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104e62:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e66:	89 34 24             	mov    %esi,(%esp)
  104e69:	e8 22 c9 ff ff       	call   101790 <dirlookup>
  104e6e:	85 c0                	test   %eax,%eax
  104e70:	89 c3                	mov    %eax,%ebx
  104e72:	0f 84 6a ff ff ff    	je     104de2 <create+0x42>
  104e78:	89 34 24             	mov    %esi,(%esp)
  104e7b:	e8 60 ce ff ff       	call   101ce0 <iunlockput>
  104e80:	89 1c 24             	mov    %ebx,(%esp)
  104e83:	e8 78 ce ff ff       	call   101d00 <ilock>
  104e88:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104e8c:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104e90:	75 0a                	jne    104e9c <create+0xfc>
  104e92:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104e96:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104e9a:	74 14                	je     104eb0 <create+0x110>
  104e9c:	89 1c 24             	mov    %ebx,(%esp)
  104e9f:	31 db                	xor    %ebx,%ebx
  104ea1:	e8 3a ce ff ff       	call   101ce0 <iunlockput>
  104ea6:	83 c4 3c             	add    $0x3c,%esp
  104ea9:	89 d8                	mov    %ebx,%eax
  104eab:	5b                   	pop    %ebx
  104eac:	5e                   	pop    %esi
  104ead:	5f                   	pop    %edi
  104eae:	5d                   	pop    %ebp
  104eaf:	c3                   	ret    
  104eb0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104eb4:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104eb8:	75 e2                	jne    104e9c <create+0xfc>
  104eba:	eb 91                	jmp    104e4d <create+0xad>
  104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104ec0:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
  104ec5:	89 34 24             	mov    %esi,(%esp)
  104ec8:	e8 c3 c6 ff ff       	call   101590 <iupdate>
  104ecd:	8b 43 04             	mov    0x4(%ebx),%eax
  104ed0:	c7 44 24 04 a5 6b 10 	movl   $0x106ba5,0x4(%esp)
  104ed7:	00 
  104ed8:	89 1c 24             	mov    %ebx,(%esp)
  104edb:	89 44 24 08          	mov    %eax,0x8(%esp)
  104edf:	e8 ac cc ff ff       	call   101b90 <dirlink>
  104ee4:	85 c0                	test   %eax,%eax
  104ee6:	78 1f                	js     104f07 <create+0x167>
  104ee8:	8b 46 04             	mov    0x4(%esi),%eax
  104eeb:	c7 44 24 04 a4 6b 10 	movl   $0x106ba4,0x4(%esp)
  104ef2:	00 
  104ef3:	89 1c 24             	mov    %ebx,(%esp)
  104ef6:	89 44 24 08          	mov    %eax,0x8(%esp)
  104efa:	e8 91 cc ff ff       	call   101b90 <dirlink>
  104eff:	85 c0                	test   %eax,%eax
  104f01:	0f 89 3e ff ff ff    	jns    104e45 <create+0xa5>
  104f07:	c7 04 24 a7 6b 10 00 	movl   $0x106ba7,(%esp)
  104f0e:	e8 5d ba ff ff       	call   100970 <panic>
  104f13:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
  104f19:	89 1c 24             	mov    %ebx,(%esp)
  104f1c:	31 db                	xor    %ebx,%ebx
  104f1e:	e8 bd cd ff ff       	call   101ce0 <iunlockput>
  104f23:	89 34 24             	mov    %esi,(%esp)
  104f26:	e8 b5 cd ff ff       	call   101ce0 <iunlockput>
  104f2b:	e9 1d ff ff ff       	jmp    104e4d <create+0xad>

00104f30 <sys_mkdir>:
  104f30:	55                   	push   %ebp
  104f31:	89 e5                	mov    %esp,%ebp
  104f33:	83 ec 18             	sub    $0x18,%esp
  104f36:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f3d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f44:	e8 b7 f8 ff ff       	call   104800 <argstr>
  104f49:	85 c0                	test   %eax,%eax
  104f4b:	79 0b                	jns    104f58 <sys_mkdir+0x28>
  104f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104f52:	c9                   	leave  
  104f53:	c3                   	ret    
  104f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104f5b:	31 d2                	xor    %edx,%edx
  104f5d:	b9 01 00 00 00       	mov    $0x1,%ecx
  104f62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f69:	00 
  104f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f71:	e8 2a fe ff ff       	call   104da0 <create>
  104f76:	85 c0                	test   %eax,%eax
  104f78:	74 d3                	je     104f4d <sys_mkdir+0x1d>
  104f7a:	89 04 24             	mov    %eax,(%esp)
  104f7d:	e8 5e cd ff ff       	call   101ce0 <iunlockput>
  104f82:	31 c0                	xor    %eax,%eax
  104f84:	c9                   	leave  
  104f85:	8d 76 00             	lea    0x0(%esi),%esi
  104f88:	c3                   	ret    
  104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104f90 <sys_mknod>:
  104f90:	55                   	push   %ebp
  104f91:	89 e5                	mov    %esp,%ebp
  104f93:	83 ec 18             	sub    $0x18,%esp
  104f96:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fa4:	e8 57 f8 ff ff       	call   104800 <argstr>
  104fa9:	85 c0                	test   %eax,%eax
  104fab:	79 0b                	jns    104fb8 <sys_mknod+0x28>
  104fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104fb2:	c9                   	leave  
  104fb3:	c3                   	ret    
  104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104fb8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fc6:	e8 e5 f7 ff ff       	call   1047b0 <argint>
  104fcb:	85 c0                	test   %eax,%eax
  104fcd:	78 de                	js     104fad <sys_mknod+0x1d>
  104fcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104fd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fd6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104fdd:	e8 ce f7 ff ff       	call   1047b0 <argint>
  104fe2:	85 c0                	test   %eax,%eax
  104fe4:	78 c7                	js     104fad <sys_mknod+0x1d>
  104fe6:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  104fea:	b9 03 00 00 00       	mov    $0x3,%ecx
  104fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104ff2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ff6:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  104ffa:	89 14 24             	mov    %edx,(%esp)
  104ffd:	31 d2                	xor    %edx,%edx
  104fff:	e8 9c fd ff ff       	call   104da0 <create>
  105004:	85 c0                	test   %eax,%eax
  105006:	74 a5                	je     104fad <sys_mknod+0x1d>
  105008:	89 04 24             	mov    %eax,(%esp)
  10500b:	e8 d0 cc ff ff       	call   101ce0 <iunlockput>
  105010:	31 c0                	xor    %eax,%eax
  105012:	c9                   	leave  
  105013:	90                   	nop
  105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105018:	c3                   	ret    
  105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105020 <sys_open>:
  105020:	55                   	push   %ebp
  105021:	89 e5                	mov    %esp,%ebp
  105023:	83 ec 28             	sub    $0x28,%esp
  105026:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105029:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10502c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10502f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105032:	89 44 24 04          	mov    %eax,0x4(%esp)
  105036:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10503d:	e8 be f7 ff ff       	call   104800 <argstr>
  105042:	85 c0                	test   %eax,%eax
  105044:	79 1a                	jns    105060 <sys_open+0x40>
  105046:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10504b:	89 d8                	mov    %ebx,%eax
  10504d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105050:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105053:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105056:	89 ec                	mov    %ebp,%esp
  105058:	5d                   	pop    %ebp
  105059:	c3                   	ret    
  10505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105060:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105063:	89 44 24 04          	mov    %eax,0x4(%esp)
  105067:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10506e:	e8 3d f7 ff ff       	call   1047b0 <argint>
  105073:	85 c0                	test   %eax,%eax
  105075:	78 cf                	js     105046 <sys_open+0x26>
  105077:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  10507b:	74 5b                	je     1050d8 <sys_open+0xb8>
  10507d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105080:	b9 02 00 00 00       	mov    $0x2,%ecx
  105085:	ba 01 00 00 00       	mov    $0x1,%edx
  10508a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105091:	00 
  105092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105099:	e8 02 fd ff ff       	call   104da0 <create>
  10509e:	85 c0                	test   %eax,%eax
  1050a0:	89 c7                	mov    %eax,%edi
  1050a2:	74 a2                	je     105046 <sys_open+0x26>
  1050a4:	e8 17 bf ff ff       	call   100fc0 <filealloc>
  1050a9:	85 c0                	test   %eax,%eax
  1050ab:	89 c6                	mov    %eax,%esi
  1050ad:	74 13                	je     1050c2 <sys_open+0xa2>
  1050af:	e8 cc f8 ff ff       	call   104980 <fdalloc>
  1050b4:	85 c0                	test   %eax,%eax
  1050b6:	89 c3                	mov    %eax,%ebx
  1050b8:	79 56                	jns    105110 <sys_open+0xf0>
  1050ba:	89 34 24             	mov    %esi,(%esp)
  1050bd:	e8 7e bf ff ff       	call   101040 <fileclose>
  1050c2:	89 3c 24             	mov    %edi,(%esp)
  1050c5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1050ca:	e8 11 cc ff ff       	call   101ce0 <iunlockput>
  1050cf:	e9 77 ff ff ff       	jmp    10504b <sys_open+0x2b>
  1050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1050d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050db:	89 04 24             	mov    %eax,(%esp)
  1050de:	e8 cd ce ff ff       	call   101fb0 <namei>
  1050e3:	85 c0                	test   %eax,%eax
  1050e5:	89 c7                	mov    %eax,%edi
  1050e7:	0f 84 59 ff ff ff    	je     105046 <sys_open+0x26>
  1050ed:	89 04 24             	mov    %eax,(%esp)
  1050f0:	e8 0b cc ff ff       	call   101d00 <ilock>
  1050f5:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1050fa:	75 a8                	jne    1050a4 <sys_open+0x84>
  1050fc:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  105100:	74 a2                	je     1050a4 <sys_open+0x84>
  105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105108:	eb b8                	jmp    1050c2 <sys_open+0xa2>
  10510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105110:	89 3c 24             	mov    %edi,(%esp)
  105113:	90                   	nop
  105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105118:	e8 63 cb ff ff       	call   101c80 <iunlock>
  10511d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105120:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  105126:	89 7e 10             	mov    %edi,0x10(%esi)
  105129:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  105130:	89 d0                	mov    %edx,%eax
  105132:	83 f0 01             	xor    $0x1,%eax
  105135:	83 e0 01             	and    $0x1,%eax
  105138:	83 e2 03             	and    $0x3,%edx
  10513b:	88 46 08             	mov    %al,0x8(%esi)
  10513e:	0f 95 46 09          	setne  0x9(%esi)
  105142:	e9 04 ff ff ff       	jmp    10504b <sys_open+0x2b>
  105147:	89 f6                	mov    %esi,%esi
  105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105150 <sys_unlink>:
  105150:	55                   	push   %ebp
  105151:	89 e5                	mov    %esp,%ebp
  105153:	83 ec 68             	sub    $0x68,%esp
  105156:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105159:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10515c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10515f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105162:	89 44 24 04          	mov    %eax,0x4(%esp)
  105166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10516d:	e8 8e f6 ff ff       	call   104800 <argstr>
  105172:	85 c0                	test   %eax,%eax
  105174:	79 12                	jns    105188 <sys_unlink+0x38>
  105176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10517b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10517e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105181:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105184:	89 ec                	mov    %ebp,%esp
  105186:	5d                   	pop    %ebp
  105187:	c3                   	ret    
  105188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10518b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  10518e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105192:	89 04 24             	mov    %eax,(%esp)
  105195:	e8 f6 cd ff ff       	call   101f90 <nameiparent>
  10519a:	85 c0                	test   %eax,%eax
  10519c:	89 c7                	mov    %eax,%edi
  10519e:	74 d6                	je     105176 <sys_unlink+0x26>
  1051a0:	89 04 24             	mov    %eax,(%esp)
  1051a3:	e8 58 cb ff ff       	call   101d00 <ilock>
  1051a8:	c7 44 24 04 a5 6b 10 	movl   $0x106ba5,0x4(%esp)
  1051af:	00 
  1051b0:	89 1c 24             	mov    %ebx,(%esp)
  1051b3:	e8 a8 c5 ff ff       	call   101760 <namecmp>
  1051b8:	85 c0                	test   %eax,%eax
  1051ba:	74 14                	je     1051d0 <sys_unlink+0x80>
  1051bc:	c7 44 24 04 a4 6b 10 	movl   $0x106ba4,0x4(%esp)
  1051c3:	00 
  1051c4:	89 1c 24             	mov    %ebx,(%esp)
  1051c7:	e8 94 c5 ff ff       	call   101760 <namecmp>
  1051cc:	85 c0                	test   %eax,%eax
  1051ce:	75 18                	jne    1051e8 <sys_unlink+0x98>
  1051d0:	89 3c 24             	mov    %edi,(%esp)
  1051d3:	e8 08 cb ff ff       	call   101ce0 <iunlockput>
  1051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1051dd:	8d 76 00             	lea    0x0(%esi),%esi
  1051e0:	eb 99                	jmp    10517b <sys_unlink+0x2b>
  1051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1051e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1051eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1051f3:	89 3c 24             	mov    %edi,(%esp)
  1051f6:	e8 95 c5 ff ff       	call   101790 <dirlookup>
  1051fb:	85 c0                	test   %eax,%eax
  1051fd:	89 c6                	mov    %eax,%esi
  1051ff:	74 cf                	je     1051d0 <sys_unlink+0x80>
  105201:	89 04 24             	mov    %eax,(%esp)
  105204:	e8 f7 ca ff ff       	call   101d00 <ilock>
  105209:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  10520e:	0f 8e d4 00 00 00    	jle    1052e8 <sys_unlink+0x198>
  105214:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105220:	75 5b                	jne    10527d <sys_unlink+0x12d>
  105222:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105226:	66 90                	xchg   %ax,%ax
  105228:	76 53                	jbe    10527d <sys_unlink+0x12d>
  10522a:	bb 20 00 00 00       	mov    $0x20,%ebx
  10522f:	90                   	nop
  105230:	eb 10                	jmp    105242 <sys_unlink+0xf2>
  105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105238:	83 c3 10             	add    $0x10,%ebx
  10523b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10523e:	66 90                	xchg   %ax,%ax
  105240:	73 3b                	jae    10527d <sys_unlink+0x12d>
  105242:	8d 45 be             	lea    -0x42(%ebp),%eax
  105245:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  10524c:	00 
  10524d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105251:	89 44 24 04          	mov    %eax,0x4(%esp)
  105255:	89 34 24             	mov    %esi,(%esp)
  105258:	e8 23 c2 ff ff       	call   101480 <readi>
  10525d:	83 f8 10             	cmp    $0x10,%eax
  105260:	75 7a                	jne    1052dc <sys_unlink+0x18c>
  105262:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  105267:	74 cf                	je     105238 <sys_unlink+0xe8>
  105269:	89 34 24             	mov    %esi,(%esp)
  10526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105270:	e8 6b ca ff ff       	call   101ce0 <iunlockput>
  105275:	8d 76 00             	lea    0x0(%esi),%esi
  105278:	e9 53 ff ff ff       	jmp    1051d0 <sys_unlink+0x80>
  10527d:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  105280:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105287:	00 
  105288:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10528f:	00 
  105290:	89 1c 24             	mov    %ebx,(%esp)
  105293:	e8 48 f2 ff ff       	call   1044e0 <memset>
  105298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10529b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1052a2:	00 
  1052a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1052a7:	89 3c 24             	mov    %edi,(%esp)
  1052aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052ae:	e8 6d c3 ff ff       	call   101620 <writei>
  1052b3:	83 f8 10             	cmp    $0x10,%eax
  1052b6:	75 3c                	jne    1052f4 <sys_unlink+0x1a4>
  1052b8:	89 3c 24             	mov    %edi,(%esp)
  1052bb:	e8 20 ca ff ff       	call   101ce0 <iunlockput>
  1052c0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  1052c5:	89 34 24             	mov    %esi,(%esp)
  1052c8:	e8 c3 c2 ff ff       	call   101590 <iupdate>
  1052cd:	89 34 24             	mov    %esi,(%esp)
  1052d0:	e8 0b ca ff ff       	call   101ce0 <iunlockput>
  1052d5:	31 c0                	xor    %eax,%eax
  1052d7:	e9 9f fe ff ff       	jmp    10517b <sys_unlink+0x2b>
  1052dc:	c7 04 24 c5 6b 10 00 	movl   $0x106bc5,(%esp)
  1052e3:	e8 88 b6 ff ff       	call   100970 <panic>
  1052e8:	c7 04 24 b3 6b 10 00 	movl   $0x106bb3,(%esp)
  1052ef:	e8 7c b6 ff ff       	call   100970 <panic>
  1052f4:	c7 04 24 d7 6b 10 00 	movl   $0x106bd7,(%esp)
  1052fb:	e8 70 b6 ff ff       	call   100970 <panic>

00105300 <sys_fstat>:
  105300:	55                   	push   %ebp
  105301:	31 d2                	xor    %edx,%edx
  105303:	89 e5                	mov    %esp,%ebp
  105305:	31 c0                	xor    %eax,%eax
  105307:	83 ec 28             	sub    $0x28,%esp
  10530a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10530d:	e8 5e f7 ff ff       	call   104a70 <argfd>
  105312:	85 c0                	test   %eax,%eax
  105314:	79 0a                	jns    105320 <sys_fstat+0x20>
  105316:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10531b:	c9                   	leave  
  10531c:	c3                   	ret    
  10531d:	8d 76 00             	lea    0x0(%esi),%esi
  105320:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105323:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10532a:	00 
  10532b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10532f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105336:	e8 45 f5 ff ff       	call   104880 <argptr>
  10533b:	85 c0                	test   %eax,%eax
  10533d:	78 d7                	js     105316 <sys_fstat+0x16>
  10533f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105342:	89 44 24 04          	mov    %eax,0x4(%esp)
  105346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105349:	89 04 24             	mov    %eax,(%esp)
  10534c:	e8 cf bb ff ff       	call   100f20 <filestat>
  105351:	c9                   	leave  
  105352:	c3                   	ret    
  105353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105360 <sys_dup>:
  105360:	55                   	push   %ebp
  105361:	31 d2                	xor    %edx,%edx
  105363:	89 e5                	mov    %esp,%ebp
  105365:	31 c0                	xor    %eax,%eax
  105367:	53                   	push   %ebx
  105368:	83 ec 14             	sub    $0x14,%esp
  10536b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10536e:	e8 fd f6 ff ff       	call   104a70 <argfd>
  105373:	85 c0                	test   %eax,%eax
  105375:	79 11                	jns    105388 <sys_dup+0x28>
  105377:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10537c:	89 d8                	mov    %ebx,%eax
  10537e:	83 c4 14             	add    $0x14,%esp
  105381:	5b                   	pop    %ebx
  105382:	5d                   	pop    %ebp
  105383:	c3                   	ret    
  105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105388:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10538b:	e8 f0 f5 ff ff       	call   104980 <fdalloc>
  105390:	85 c0                	test   %eax,%eax
  105392:	89 c3                	mov    %eax,%ebx
  105394:	78 e1                	js     105377 <sys_dup+0x17>
  105396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105399:	89 04 24             	mov    %eax,(%esp)
  10539c:	e8 cf bb ff ff       	call   100f70 <filedup>
  1053a1:	eb d9                	jmp    10537c <sys_dup+0x1c>
  1053a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001053b0 <sys_write>:
  1053b0:	55                   	push   %ebp
  1053b1:	31 d2                	xor    %edx,%edx
  1053b3:	89 e5                	mov    %esp,%ebp
  1053b5:	31 c0                	xor    %eax,%eax
  1053b7:	83 ec 28             	sub    $0x28,%esp
  1053ba:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1053bd:	e8 ae f6 ff ff       	call   104a70 <argfd>
  1053c2:	85 c0                	test   %eax,%eax
  1053c4:	79 0a                	jns    1053d0 <sys_write+0x20>
  1053c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1053cb:	c9                   	leave  
  1053cc:	c3                   	ret    
  1053cd:	8d 76 00             	lea    0x0(%esi),%esi
  1053d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1053d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053d7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053de:	e8 cd f3 ff ff       	call   1047b0 <argint>
  1053e3:	85 c0                	test   %eax,%eax
  1053e5:	78 df                	js     1053c6 <sys_write+0x16>
  1053e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1053f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1053f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053fc:	e8 7f f4 ff ff       	call   104880 <argptr>
  105401:	85 c0                	test   %eax,%eax
  105403:	78 c1                	js     1053c6 <sys_write+0x16>
  105405:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105408:	89 44 24 08          	mov    %eax,0x8(%esp)
  10540c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10540f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105413:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105416:	89 04 24             	mov    %eax,(%esp)
  105419:	e8 a2 b9 ff ff       	call   100dc0 <filewrite>
  10541e:	c9                   	leave  
  10541f:	c3                   	ret    

00105420 <sys_read>:
  105420:	55                   	push   %ebp
  105421:	31 d2                	xor    %edx,%edx
  105423:	89 e5                	mov    %esp,%ebp
  105425:	31 c0                	xor    %eax,%eax
  105427:	83 ec 28             	sub    $0x28,%esp
  10542a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10542d:	e8 3e f6 ff ff       	call   104a70 <argfd>
  105432:	85 c0                	test   %eax,%eax
  105434:	79 0a                	jns    105440 <sys_read+0x20>
  105436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10543b:	c9                   	leave  
  10543c:	c3                   	ret    
  10543d:	8d 76 00             	lea    0x0(%esi),%esi
  105440:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105443:	89 44 24 04          	mov    %eax,0x4(%esp)
  105447:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10544e:	e8 5d f3 ff ff       	call   1047b0 <argint>
  105453:	85 c0                	test   %eax,%eax
  105455:	78 df                	js     105436 <sys_read+0x16>
  105457:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10545a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105461:	89 44 24 08          	mov    %eax,0x8(%esp)
  105465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105468:	89 44 24 04          	mov    %eax,0x4(%esp)
  10546c:	e8 0f f4 ff ff       	call   104880 <argptr>
  105471:	85 c0                	test   %eax,%eax
  105473:	78 c1                	js     105436 <sys_read+0x16>
  105475:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105478:	89 44 24 08          	mov    %eax,0x8(%esp)
  10547c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10547f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105486:	89 04 24             	mov    %eax,(%esp)
  105489:	e8 e2 b9 ff ff       	call   100e70 <fileread>
  10548e:	c9                   	leave  
  10548f:	c3                   	ret    

00105490 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  105490:	55                   	push   %ebp
return ticks;
}
  105491:	a1 40 ed 10 00       	mov    0x10ed40,%eax
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

001054a0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1054a0:	55                   	push   %ebp
  1054a1:	89 e5                	mov    %esp,%ebp
  1054a3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1054a6:	e8 e5 df ff ff       	call   103490 <curproc>
  1054ab:	8b 40 10             	mov    0x10(%eax),%eax
}
  1054ae:	c9                   	leave  
  1054af:	c3                   	ret    

001054b0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1054b0:	55                   	push   %ebp
  1054b1:	89 e5                	mov    %esp,%ebp
  1054b3:	53                   	push   %ebx
  1054b4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  1054b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1054ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054c5:	e8 e6 f2 ff ff       	call   1047b0 <argint>
  1054ca:	89 c2                	mov    %eax,%edx
  1054cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1054d1:	85 d2                	test   %edx,%edx
  1054d3:	78 58                	js     10552d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  1054d5:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1054dc:	e8 8f ef ff ff       	call   104470 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  1054e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  1054e4:	8b 1d 40 ed 10 00    	mov    0x10ed40,%ebx
  while(ticks - ticks0 < n){
  1054ea:	85 d2                	test   %edx,%edx
  1054ec:	7f 22                	jg     105510 <sys_sleep+0x60>
  1054ee:	eb 48                	jmp    105538 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  1054f0:	c7 44 24 04 00 e5 10 	movl   $0x10e500,0x4(%esp)
  1054f7:	00 
  1054f8:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  1054ff:	e8 ec e1 ff ff       	call   1036f0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105504:	a1 40 ed 10 00       	mov    0x10ed40,%eax
  105509:	29 d8                	sub    %ebx,%eax
  10550b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10550e:	7d 28                	jge    105538 <sys_sleep+0x88>
    if(cp->killed){
  105510:	e8 7b df ff ff       	call   103490 <curproc>
  105515:	8b 40 1c             	mov    0x1c(%eax),%eax
  105518:	85 c0                	test   %eax,%eax
  10551a:	74 d4                	je     1054f0 <sys_sleep+0x40>
      release(&tickslock);
  10551c:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  105523:	e8 08 ef ff ff       	call   104430 <release>
  105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10552d:	83 c4 24             	add    $0x24,%esp
  105530:	5b                   	pop    %ebx
  105531:	5d                   	pop    %ebp
  105532:	c3                   	ret    
  105533:	90                   	nop
  105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105538:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  10553f:	e8 ec ee ff ff       	call   104430 <release>
  return 0;
}
  105544:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105547:	31 c0                	xor    %eax,%eax
  return 0;
}
  105549:	5b                   	pop    %ebx
  10554a:	5d                   	pop    %ebp
  10554b:	c3                   	ret    
  10554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105550 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105550:	55                   	push   %ebp
  105551:	89 e5                	mov    %esp,%ebp
  105553:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105556:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105559:	89 44 24 04          	mov    %eax,0x4(%esp)
  10555d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105564:	e8 47 f2 ff ff       	call   1047b0 <argint>
  105569:	85 c0                	test   %eax,%eax
  10556b:	79 0b                	jns    105578 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  10556d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105572:	c9                   	leave  
  105573:	c3                   	ret    
  105574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10557b:	89 04 24             	mov    %eax,(%esp)
  10557e:	e8 cd e7 ff ff       	call   103d50 <growproc>
  105583:	85 c0                	test   %eax,%eax
  105585:	78 e6                	js     10556d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105587:	c9                   	leave  
  105588:	c3                   	ret    
  105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105590 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105590:	55                   	push   %ebp
  105591:	89 e5                	mov    %esp,%ebp
  105593:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105599:	89 44 24 04          	mov    %eax,0x4(%esp)
  10559d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055a4:	e8 07 f2 ff ff       	call   1047b0 <argint>
  1055a9:	89 c2                	mov    %eax,%edx
  1055ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1055b0:	85 d2                	test   %edx,%edx
  1055b2:	78 0b                	js     1055bf <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1055b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055b7:	89 04 24             	mov    %eax,(%esp)
  1055ba:	e8 41 dd ff ff       	call   103300 <kill>
}
  1055bf:	c9                   	leave  
  1055c0:	c3                   	ret    
  1055c1:	eb 0d                	jmp    1055d0 <sys_wait>
  1055c3:	90                   	nop
  1055c4:	90                   	nop
  1055c5:	90                   	nop
  1055c6:	90                   	nop
  1055c7:	90                   	nop
  1055c8:	90                   	nop
  1055c9:	90                   	nop
  1055ca:	90                   	nop
  1055cb:	90                   	nop
  1055cc:	90                   	nop
  1055cd:	90                   	nop
  1055ce:	90                   	nop
  1055cf:	90                   	nop

001055d0 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  1055d0:	55                   	push   %ebp
  1055d1:	89 e5                	mov    %esp,%ebp
  1055d3:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  1055d6:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  1055d7:	e9 d4 e2 ff ff       	jmp    1038b0 <wait>
  1055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001055e0 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  1055e0:	55                   	push   %ebp
  1055e1:	89 e5                	mov    %esp,%ebp
  1055e3:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  1055e6:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  1055e7:	e9 d4 e1 ff ff       	jmp    1037c0 <wait_thread>
  1055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001055f0 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  1055f0:	55                   	push   %ebp
  1055f1:	89 e5                	mov    %esp,%ebp
  1055f3:	83 ec 08             	sub    $0x8,%esp
  exit();
  1055f6:	e8 95 df ff ff       	call   103590 <exit>
  return 0;  // not reached
}
  1055fb:	31 c0                	xor    %eax,%eax
  1055fd:	c9                   	leave  
  1055fe:	c3                   	ret    
  1055ff:	90                   	nop

00105600 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105600:	55                   	push   %ebp
  105601:	89 e5                	mov    %esp,%ebp
  105603:	53                   	push   %ebx
  105604:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10560a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105615:	e8 96 f1 ff ff       	call   1047b0 <argint>
  10561a:	85 c0                	test   %eax,%eax
  10561c:	79 12                	jns    105630 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10561e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105623:	83 c4 24             	add    $0x24,%esp
  105626:	5b                   	pop    %ebx
  105627:	5d                   	pop    %ebp
  105628:	c3                   	ret    
  105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105630:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105633:	e8 58 de ff ff       	call   103490 <curproc>
  105638:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10563c:	89 04 24             	mov    %eax,(%esp)
  10563f:	e8 cc e7 ff ff       	call   103e10 <copyproc_tix>
  105644:	85 c0                	test   %eax,%eax
  105646:	89 c2                	mov    %eax,%edx
  105648:	74 d4                	je     10561e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10564a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10564d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  105650:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  105657:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  10565d:	eb c4                	jmp    105623 <sys_fork_tickets+0x23>
  10565f:	90                   	nop

00105660 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  105660:	55                   	push   %ebp
  105661:	89 e5                	mov    %esp,%ebp
  105663:	53                   	push   %ebx
  105664:	83 ec 24             	sub    $0x24,%esp
  int pid;
  char *stack;
  char *addrspace;
  struct proc *np;

 if(argstr(0, &stack) < 0)
  105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10566a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10566e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105675:	e8 86 f1 ff ff       	call   104800 <argstr>
  10567a:	85 c0                	test   %eax,%eax
  10567c:	78 1f                	js     10569d <sys_fork_thread+0x3d>
    return -1;

  if((np = copyproc_threads(cp, stack)) == 0)
  10567e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105681:	e8 0a de ff ff       	call   103490 <curproc>
  105686:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10568a:	89 04 24             	mov    %eax,(%esp)
  10568d:	e8 be e8 ff ff       	call   103f50 <copyproc_threads>
  105692:	85 c0                	test   %eax,%eax
  105694:	74 07                	je     10569d <sys_fork_thread+0x3d>
    return -1;

  np->state = RUNNABLE;
  105696:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  
  return pid;
}
  10569d:	83 c4 24             	add    $0x24,%esp
  1056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1056a5:	5b                   	pop    %ebx
  1056a6:	5d                   	pop    %ebp
  1056a7:	c3                   	ret    
  1056a8:	90                   	nop
  1056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001056b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  1056b0:	55                   	push   %ebp
  1056b1:	89 e5                	mov    %esp,%ebp
  1056b3:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  1056b6:	e8 d5 dd ff ff       	call   103490 <curproc>
  1056bb:	89 04 24             	mov    %eax,(%esp)
  1056be:	e8 8d e9 ff ff       	call   104050 <copyproc>
  1056c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1056c8:	85 c0                	test   %eax,%eax
  1056ca:	74 0a                	je     1056d6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1056cc:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1056cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1056d6:	89 d0                	mov    %edx,%eax
  1056d8:	c9                   	leave  
  1056d9:	c3                   	ret    
  1056da:	90                   	nop
  1056db:	90                   	nop
  1056dc:	90                   	nop
  1056dd:	90                   	nop
  1056de:	90                   	nop
  1056df:	90                   	nop

001056e0 <timer_init>:
  1056e0:	55                   	push   %ebp
  1056e1:	ba 43 00 00 00       	mov    $0x43,%edx
  1056e6:	89 e5                	mov    %esp,%ebp
  1056e8:	b8 34 00 00 00       	mov    $0x34,%eax
  1056ed:	83 ec 08             	sub    $0x8,%esp
  1056f0:	ee                   	out    %al,(%dx)
  1056f1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  1056f6:	b2 40                	mov    $0x40,%dl
  1056f8:	ee                   	out    %al,(%dx)
  1056f9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  1056fe:	ee                   	out    %al,(%dx)
  1056ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105706:	e8 c5 d6 ff ff       	call   102dd0 <pic_enable>
  10570b:	c9                   	leave  
  10570c:	c3                   	ret    
  10570d:	90                   	nop
  10570e:	90                   	nop
  10570f:	90                   	nop

00105710 <alltraps>:
  105710:	1e                   	push   %ds
  105711:	06                   	push   %es
  105712:	60                   	pusha  
  105713:	b8 10 00 00 00       	mov    $0x10,%eax
  105718:	8e d8                	mov    %eax,%ds
  10571a:	8e c0                	mov    %eax,%es
  10571c:	54                   	push   %esp
  10571d:	e8 4e 00 00 00       	call   105770 <trap>
  105722:	83 c4 04             	add    $0x4,%esp

00105725 <trapret>:
  105725:	61                   	popa   
  105726:	07                   	pop    %es
  105727:	1f                   	pop    %ds
  105728:	83 c4 08             	add    $0x8,%esp
  10572b:	cf                   	iret   

0010572c <forkret1>:
  10572c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105730:	e9 f0 ff ff ff       	jmp    105725 <trapret>
  105735:	90                   	nop
  105736:	90                   	nop
  105737:	90                   	nop
  105738:	90                   	nop
  105739:	90                   	nop
  10573a:	90                   	nop
  10573b:	90                   	nop
  10573c:	90                   	nop
  10573d:	90                   	nop
  10573e:	90                   	nop
  10573f:	90                   	nop

00105740 <idtinit>:
  105740:	55                   	push   %ebp
  105741:	b8 40 e5 10 00       	mov    $0x10e540,%eax
  105746:	89 e5                	mov    %esp,%ebp
  105748:	83 ec 10             	sub    $0x10,%esp
  10574b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  105751:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  105755:	c1 e8 10             	shr    $0x10,%eax
  105758:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  10575c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10575f:	0f 01 18             	lidtl  (%eax)
  105762:	c9                   	leave  
  105763:	c3                   	ret    
  105764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10576a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105770 <trap>:
  105770:	55                   	push   %ebp
  105771:	89 e5                	mov    %esp,%ebp
  105773:	83 ec 38             	sub    $0x38,%esp
  105776:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105779:	8b 7d 08             	mov    0x8(%ebp),%edi
  10577c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10577f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105782:	8b 47 28             	mov    0x28(%edi),%eax
  105785:	83 f8 30             	cmp    $0x30,%eax
  105788:	0f 84 22 01 00 00    	je     1058b0 <trap+0x140>
  10578e:	83 f8 21             	cmp    $0x21,%eax
  105791:	0f 84 b1 01 00 00    	je     105948 <trap+0x1d8>
  105797:	0f 86 a3 00 00 00    	jbe    105840 <trap+0xd0>
  10579d:	83 f8 2e             	cmp    $0x2e,%eax
  1057a0:	0f 84 52 01 00 00    	je     1058f8 <trap+0x188>
  1057a6:	83 f8 3f             	cmp    $0x3f,%eax
  1057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1057b0:	0f 85 93 00 00 00    	jne    105849 <trap+0xd9>
  1057b6:	8b 5f 30             	mov    0x30(%edi),%ebx
  1057b9:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  1057bd:	e8 6e d1 ff ff       	call   102930 <cpu>
  1057c2:	c7 04 24 e8 6b 10 00 	movl   $0x106be8,(%esp)
  1057c9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057cd:	89 74 24 08          	mov    %esi,0x8(%esp)
  1057d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d5:	e8 c6 af ff ff       	call   1007a0 <cprintf>
  1057da:	e8 c1 cf ff ff       	call   1027a0 <lapic_eoi>
  1057df:	e8 ac dc ff ff       	call   103490 <curproc>
  1057e4:	85 c0                	test   %eax,%eax
  1057e6:	66 90                	xchg   %ax,%ax
  1057e8:	74 28                	je     105812 <trap+0xa2>
  1057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1057f0:	e8 9b dc ff ff       	call   103490 <curproc>
  1057f5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1057f8:	85 c0                	test   %eax,%eax
  1057fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105800:	74 10                	je     105812 <trap+0xa2>
  105802:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  105806:	83 e0 03             	and    $0x3,%eax
  105809:	83 f8 03             	cmp    $0x3,%eax
  10580c:	0f 84 ce 01 00 00    	je     1059e0 <trap+0x270>
  105812:	e8 79 dc ff ff       	call   103490 <curproc>
  105817:	85 c0                	test   %eax,%eax
  105819:	74 17                	je     105832 <trap+0xc2>
  10581b:	90                   	nop
  10581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105820:	e8 6b dc ff ff       	call   103490 <curproc>
  105825:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105830:	74 66                	je     105898 <trap+0x128>
  105832:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105835:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105838:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10583b:	89 ec                	mov    %ebp,%esp
  10583d:	5d                   	pop    %ebp
  10583e:	c3                   	ret    
  10583f:	90                   	nop
  105840:	83 f8 20             	cmp    $0x20,%eax
  105843:	0f 84 c7 00 00 00    	je     105910 <trap+0x1a0>
  105849:	e8 42 dc ff ff       	call   103490 <curproc>
  10584e:	85 c0                	test   %eax,%eax
  105850:	74 0c                	je     10585e <trap+0xee>
  105852:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  105856:	66 90                	xchg   %ax,%ax
  105858:	0f 85 12 01 00 00    	jne    105970 <trap+0x200>
  10585e:	8b 5f 30             	mov    0x30(%edi),%ebx
  105861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105868:	e8 c3 d0 ff ff       	call   102930 <cpu>
  10586d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105871:	89 44 24 08          	mov    %eax,0x8(%esp)
  105875:	8b 47 28             	mov    0x28(%edi),%eax
  105878:	c7 04 24 0c 6c 10 00 	movl   $0x106c0c,(%esp)
  10587f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105883:	e8 18 af ff ff       	call   1007a0 <cprintf>
  105888:	c7 04 24 70 6c 10 00 	movl   $0x106c70,(%esp)
  10588f:	e8 dc b0 ff ff       	call   100970 <panic>
  105894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105898:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  10589c:	75 94                	jne    105832 <trap+0xc2>
  10589e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1058a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1058a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1058a7:	89 ec                	mov    %ebp,%esp
  1058a9:	5d                   	pop    %ebp
  1058aa:	e9 11 e1 ff ff       	jmp    1039c0 <yield>
  1058af:	90                   	nop
  1058b0:	e8 db db ff ff       	call   103490 <curproc>
  1058b5:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1058b8:	85 c9                	test   %ecx,%ecx
  1058ba:	0f 85 a0 00 00 00    	jne    105960 <trap+0x1f0>
  1058c0:	e8 cb db ff ff       	call   103490 <curproc>
  1058c5:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
  1058cb:	e8 10 f0 ff ff       	call   1048e0 <syscall>
  1058d0:	e8 bb db ff ff       	call   103490 <curproc>
  1058d5:	8b 50 1c             	mov    0x1c(%eax),%edx
  1058d8:	85 d2                	test   %edx,%edx
  1058da:	0f 84 52 ff ff ff    	je     105832 <trap+0xc2>
  1058e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1058e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1058e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1058e9:	89 ec                	mov    %ebp,%esp
  1058eb:	5d                   	pop    %ebp
  1058ec:	e9 9f dc ff ff       	jmp    103590 <exit>
  1058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058f8:	e8 73 c8 ff ff       	call   102170 <ide_intr>
  1058fd:	e8 9e ce ff ff       	call   1027a0 <lapic_eoi>
  105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105908:	e9 d2 fe ff ff       	jmp    1057df <trap+0x6f>
  10590d:	8d 76 00             	lea    0x0(%esi),%esi
  105910:	e8 1b d0 ff ff       	call   102930 <cpu>
  105915:	85 c0                	test   %eax,%eax
  105917:	90                   	nop
  105918:	75 e3                	jne    1058fd <trap+0x18d>
  10591a:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  105921:	e8 4a eb ff ff       	call   104470 <acquire>
  105926:	83 05 40 ed 10 00 01 	addl   $0x1,0x10ed40
  10592d:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  105934:	e8 57 da ff ff       	call   103390 <wakeup>
  105939:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  105940:	e8 eb ea ff ff       	call   104430 <release>
  105945:	eb b6                	jmp    1058fd <trap+0x18d>
  105947:	90                   	nop
  105948:	e8 43 cd ff ff       	call   102690 <kbd_intr>
  10594d:	8d 76 00             	lea    0x0(%esi),%esi
  105950:	e8 4b ce ff ff       	call   1027a0 <lapic_eoi>
  105955:	8d 76 00             	lea    0x0(%esi),%esi
  105958:	e9 82 fe ff ff       	jmp    1057df <trap+0x6f>
  10595d:	8d 76 00             	lea    0x0(%esi),%esi
  105960:	e8 2b dc ff ff       	call   103590 <exit>
  105965:	8d 76 00             	lea    0x0(%esi),%esi
  105968:	e9 53 ff ff ff       	jmp    1058c0 <trap+0x150>
  10596d:	8d 76 00             	lea    0x0(%esi),%esi
  105970:	8b 47 30             	mov    0x30(%edi),%eax
  105973:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105976:	e8 b5 cf ff ff       	call   102930 <cpu>
  10597b:	8b 57 28             	mov    0x28(%edi),%edx
  10597e:	8b 77 2c             	mov    0x2c(%edi),%esi
  105981:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105984:	89 c3                	mov    %eax,%ebx
  105986:	e8 05 db ff ff       	call   103490 <curproc>
  10598b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10598e:	e8 fd da ff ff       	call   103490 <curproc>
  105993:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105996:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  10599a:	89 74 24 10          	mov    %esi,0x10(%esp)
  10599e:	89 54 24 18          	mov    %edx,0x18(%esp)
  1059a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1059ac:	81 c2 88 00 00 00    	add    $0x88,%edx
  1059b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1059b6:	8b 40 10             	mov    0x10(%eax),%eax
  1059b9:	c7 04 24 34 6c 10 00 	movl   $0x106c34,(%esp)
  1059c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c4:	e8 d7 ad ff ff       	call   1007a0 <cprintf>
  1059c9:	e8 c2 da ff ff       	call   103490 <curproc>
  1059ce:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  1059d5:	e9 05 fe ff ff       	jmp    1057df <trap+0x6f>
  1059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1059e0:	e8 ab db ff ff       	call   103590 <exit>
  1059e5:	8d 76 00             	lea    0x0(%esi),%esi
  1059e8:	e9 25 fe ff ff       	jmp    105812 <trap+0xa2>
  1059ed:	8d 76 00             	lea    0x0(%esi),%esi

001059f0 <tvinit>:
  1059f0:	55                   	push   %ebp
  1059f1:	31 d2                	xor    %edx,%edx
  1059f3:	89 e5                	mov    %esp,%ebp
  1059f5:	b9 40 e5 10 00       	mov    $0x10e540,%ecx
  1059fa:	83 ec 08             	sub    $0x8,%esp
  1059fd:	8d 76 00             	lea    0x0(%esi),%esi
  105a00:	8b 04 95 88 7f 10 00 	mov    0x107f88(,%edx,4),%eax
  105a07:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
  105a0e:	66 89 04 d5 40 e5 10 	mov    %ax,0x10e540(,%edx,8)
  105a15:	00 
  105a16:	c1 e8 10             	shr    $0x10,%eax
  105a19:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
  105a1e:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
  105a23:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
  105a28:	83 c2 01             	add    $0x1,%edx
  105a2b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105a31:	75 cd                	jne    105a00 <tvinit+0x10>
  105a33:	a1 48 80 10 00       	mov    0x108048,%eax
  105a38:	c7 44 24 04 75 6c 10 	movl   $0x106c75,0x4(%esp)
  105a3f:	00 
  105a40:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  105a47:	66 c7 05 c2 e6 10 00 	movw   $0x8,0x10e6c2
  105a4e:	08 00 
  105a50:	66 a3 c0 e6 10 00    	mov    %ax,0x10e6c0
  105a56:	c1 e8 10             	shr    $0x10,%eax
  105a59:	c6 05 c4 e6 10 00 00 	movb   $0x0,0x10e6c4
  105a60:	c6 05 c5 e6 10 00 ef 	movb   $0xef,0x10e6c5
  105a67:	66 a3 c6 e6 10 00    	mov    %ax,0x10e6c6
  105a6d:	e8 2e e8 ff ff       	call   1042a0 <initlock>
  105a72:	c9                   	leave  
  105a73:	c3                   	ret    

00105a74 <vector0>:
  105a74:	6a 00                	push   $0x0
  105a76:	6a 00                	push   $0x0
  105a78:	e9 93 fc ff ff       	jmp    105710 <alltraps>

00105a7d <vector1>:
  105a7d:	6a 00                	push   $0x0
  105a7f:	6a 01                	push   $0x1
  105a81:	e9 8a fc ff ff       	jmp    105710 <alltraps>

00105a86 <vector2>:
  105a86:	6a 00                	push   $0x0
  105a88:	6a 02                	push   $0x2
  105a8a:	e9 81 fc ff ff       	jmp    105710 <alltraps>

00105a8f <vector3>:
  105a8f:	6a 00                	push   $0x0
  105a91:	6a 03                	push   $0x3
  105a93:	e9 78 fc ff ff       	jmp    105710 <alltraps>

00105a98 <vector4>:
  105a98:	6a 00                	push   $0x0
  105a9a:	6a 04                	push   $0x4
  105a9c:	e9 6f fc ff ff       	jmp    105710 <alltraps>

00105aa1 <vector5>:
  105aa1:	6a 00                	push   $0x0
  105aa3:	6a 05                	push   $0x5
  105aa5:	e9 66 fc ff ff       	jmp    105710 <alltraps>

00105aaa <vector6>:
  105aaa:	6a 00                	push   $0x0
  105aac:	6a 06                	push   $0x6
  105aae:	e9 5d fc ff ff       	jmp    105710 <alltraps>

00105ab3 <vector7>:
  105ab3:	6a 00                	push   $0x0
  105ab5:	6a 07                	push   $0x7
  105ab7:	e9 54 fc ff ff       	jmp    105710 <alltraps>

00105abc <vector8>:
  105abc:	6a 08                	push   $0x8
  105abe:	e9 4d fc ff ff       	jmp    105710 <alltraps>

00105ac3 <vector9>:
  105ac3:	6a 09                	push   $0x9
  105ac5:	e9 46 fc ff ff       	jmp    105710 <alltraps>

00105aca <vector10>:
  105aca:	6a 0a                	push   $0xa
  105acc:	e9 3f fc ff ff       	jmp    105710 <alltraps>

00105ad1 <vector11>:
  105ad1:	6a 0b                	push   $0xb
  105ad3:	e9 38 fc ff ff       	jmp    105710 <alltraps>

00105ad8 <vector12>:
  105ad8:	6a 0c                	push   $0xc
  105ada:	e9 31 fc ff ff       	jmp    105710 <alltraps>

00105adf <vector13>:
  105adf:	6a 0d                	push   $0xd
  105ae1:	e9 2a fc ff ff       	jmp    105710 <alltraps>

00105ae6 <vector14>:
  105ae6:	6a 0e                	push   $0xe
  105ae8:	e9 23 fc ff ff       	jmp    105710 <alltraps>

00105aed <vector15>:
  105aed:	6a 00                	push   $0x0
  105aef:	6a 0f                	push   $0xf
  105af1:	e9 1a fc ff ff       	jmp    105710 <alltraps>

00105af6 <vector16>:
  105af6:	6a 00                	push   $0x0
  105af8:	6a 10                	push   $0x10
  105afa:	e9 11 fc ff ff       	jmp    105710 <alltraps>

00105aff <vector17>:
  105aff:	6a 11                	push   $0x11
  105b01:	e9 0a fc ff ff       	jmp    105710 <alltraps>

00105b06 <vector18>:
  105b06:	6a 00                	push   $0x0
  105b08:	6a 12                	push   $0x12
  105b0a:	e9 01 fc ff ff       	jmp    105710 <alltraps>

00105b0f <vector19>:
  105b0f:	6a 00                	push   $0x0
  105b11:	6a 13                	push   $0x13
  105b13:	e9 f8 fb ff ff       	jmp    105710 <alltraps>

00105b18 <vector20>:
  105b18:	6a 00                	push   $0x0
  105b1a:	6a 14                	push   $0x14
  105b1c:	e9 ef fb ff ff       	jmp    105710 <alltraps>

00105b21 <vector21>:
  105b21:	6a 00                	push   $0x0
  105b23:	6a 15                	push   $0x15
  105b25:	e9 e6 fb ff ff       	jmp    105710 <alltraps>

00105b2a <vector22>:
  105b2a:	6a 00                	push   $0x0
  105b2c:	6a 16                	push   $0x16
  105b2e:	e9 dd fb ff ff       	jmp    105710 <alltraps>

00105b33 <vector23>:
  105b33:	6a 00                	push   $0x0
  105b35:	6a 17                	push   $0x17
  105b37:	e9 d4 fb ff ff       	jmp    105710 <alltraps>

00105b3c <vector24>:
  105b3c:	6a 00                	push   $0x0
  105b3e:	6a 18                	push   $0x18
  105b40:	e9 cb fb ff ff       	jmp    105710 <alltraps>

00105b45 <vector25>:
  105b45:	6a 00                	push   $0x0
  105b47:	6a 19                	push   $0x19
  105b49:	e9 c2 fb ff ff       	jmp    105710 <alltraps>

00105b4e <vector26>:
  105b4e:	6a 00                	push   $0x0
  105b50:	6a 1a                	push   $0x1a
  105b52:	e9 b9 fb ff ff       	jmp    105710 <alltraps>

00105b57 <vector27>:
  105b57:	6a 00                	push   $0x0
  105b59:	6a 1b                	push   $0x1b
  105b5b:	e9 b0 fb ff ff       	jmp    105710 <alltraps>

00105b60 <vector28>:
  105b60:	6a 00                	push   $0x0
  105b62:	6a 1c                	push   $0x1c
  105b64:	e9 a7 fb ff ff       	jmp    105710 <alltraps>

00105b69 <vector29>:
  105b69:	6a 00                	push   $0x0
  105b6b:	6a 1d                	push   $0x1d
  105b6d:	e9 9e fb ff ff       	jmp    105710 <alltraps>

00105b72 <vector30>:
  105b72:	6a 00                	push   $0x0
  105b74:	6a 1e                	push   $0x1e
  105b76:	e9 95 fb ff ff       	jmp    105710 <alltraps>

00105b7b <vector31>:
  105b7b:	6a 00                	push   $0x0
  105b7d:	6a 1f                	push   $0x1f
  105b7f:	e9 8c fb ff ff       	jmp    105710 <alltraps>

00105b84 <vector32>:
  105b84:	6a 00                	push   $0x0
  105b86:	6a 20                	push   $0x20
  105b88:	e9 83 fb ff ff       	jmp    105710 <alltraps>

00105b8d <vector33>:
  105b8d:	6a 00                	push   $0x0
  105b8f:	6a 21                	push   $0x21
  105b91:	e9 7a fb ff ff       	jmp    105710 <alltraps>

00105b96 <vector34>:
  105b96:	6a 00                	push   $0x0
  105b98:	6a 22                	push   $0x22
  105b9a:	e9 71 fb ff ff       	jmp    105710 <alltraps>

00105b9f <vector35>:
  105b9f:	6a 00                	push   $0x0
  105ba1:	6a 23                	push   $0x23
  105ba3:	e9 68 fb ff ff       	jmp    105710 <alltraps>

00105ba8 <vector36>:
  105ba8:	6a 00                	push   $0x0
  105baa:	6a 24                	push   $0x24
  105bac:	e9 5f fb ff ff       	jmp    105710 <alltraps>

00105bb1 <vector37>:
  105bb1:	6a 00                	push   $0x0
  105bb3:	6a 25                	push   $0x25
  105bb5:	e9 56 fb ff ff       	jmp    105710 <alltraps>

00105bba <vector38>:
  105bba:	6a 00                	push   $0x0
  105bbc:	6a 26                	push   $0x26
  105bbe:	e9 4d fb ff ff       	jmp    105710 <alltraps>

00105bc3 <vector39>:
  105bc3:	6a 00                	push   $0x0
  105bc5:	6a 27                	push   $0x27
  105bc7:	e9 44 fb ff ff       	jmp    105710 <alltraps>

00105bcc <vector40>:
  105bcc:	6a 00                	push   $0x0
  105bce:	6a 28                	push   $0x28
  105bd0:	e9 3b fb ff ff       	jmp    105710 <alltraps>

00105bd5 <vector41>:
  105bd5:	6a 00                	push   $0x0
  105bd7:	6a 29                	push   $0x29
  105bd9:	e9 32 fb ff ff       	jmp    105710 <alltraps>

00105bde <vector42>:
  105bde:	6a 00                	push   $0x0
  105be0:	6a 2a                	push   $0x2a
  105be2:	e9 29 fb ff ff       	jmp    105710 <alltraps>

00105be7 <vector43>:
  105be7:	6a 00                	push   $0x0
  105be9:	6a 2b                	push   $0x2b
  105beb:	e9 20 fb ff ff       	jmp    105710 <alltraps>

00105bf0 <vector44>:
  105bf0:	6a 00                	push   $0x0
  105bf2:	6a 2c                	push   $0x2c
  105bf4:	e9 17 fb ff ff       	jmp    105710 <alltraps>

00105bf9 <vector45>:
  105bf9:	6a 00                	push   $0x0
  105bfb:	6a 2d                	push   $0x2d
  105bfd:	e9 0e fb ff ff       	jmp    105710 <alltraps>

00105c02 <vector46>:
  105c02:	6a 00                	push   $0x0
  105c04:	6a 2e                	push   $0x2e
  105c06:	e9 05 fb ff ff       	jmp    105710 <alltraps>

00105c0b <vector47>:
  105c0b:	6a 00                	push   $0x0
  105c0d:	6a 2f                	push   $0x2f
  105c0f:	e9 fc fa ff ff       	jmp    105710 <alltraps>

00105c14 <vector48>:
  105c14:	6a 00                	push   $0x0
  105c16:	6a 30                	push   $0x30
  105c18:	e9 f3 fa ff ff       	jmp    105710 <alltraps>

00105c1d <vector49>:
  105c1d:	6a 00                	push   $0x0
  105c1f:	6a 31                	push   $0x31
  105c21:	e9 ea fa ff ff       	jmp    105710 <alltraps>

00105c26 <vector50>:
  105c26:	6a 00                	push   $0x0
  105c28:	6a 32                	push   $0x32
  105c2a:	e9 e1 fa ff ff       	jmp    105710 <alltraps>

00105c2f <vector51>:
  105c2f:	6a 00                	push   $0x0
  105c31:	6a 33                	push   $0x33
  105c33:	e9 d8 fa ff ff       	jmp    105710 <alltraps>

00105c38 <vector52>:
  105c38:	6a 00                	push   $0x0
  105c3a:	6a 34                	push   $0x34
  105c3c:	e9 cf fa ff ff       	jmp    105710 <alltraps>

00105c41 <vector53>:
  105c41:	6a 00                	push   $0x0
  105c43:	6a 35                	push   $0x35
  105c45:	e9 c6 fa ff ff       	jmp    105710 <alltraps>

00105c4a <vector54>:
  105c4a:	6a 00                	push   $0x0
  105c4c:	6a 36                	push   $0x36
  105c4e:	e9 bd fa ff ff       	jmp    105710 <alltraps>

00105c53 <vector55>:
  105c53:	6a 00                	push   $0x0
  105c55:	6a 37                	push   $0x37
  105c57:	e9 b4 fa ff ff       	jmp    105710 <alltraps>

00105c5c <vector56>:
  105c5c:	6a 00                	push   $0x0
  105c5e:	6a 38                	push   $0x38
  105c60:	e9 ab fa ff ff       	jmp    105710 <alltraps>

00105c65 <vector57>:
  105c65:	6a 00                	push   $0x0
  105c67:	6a 39                	push   $0x39
  105c69:	e9 a2 fa ff ff       	jmp    105710 <alltraps>

00105c6e <vector58>:
  105c6e:	6a 00                	push   $0x0
  105c70:	6a 3a                	push   $0x3a
  105c72:	e9 99 fa ff ff       	jmp    105710 <alltraps>

00105c77 <vector59>:
  105c77:	6a 00                	push   $0x0
  105c79:	6a 3b                	push   $0x3b
  105c7b:	e9 90 fa ff ff       	jmp    105710 <alltraps>

00105c80 <vector60>:
  105c80:	6a 00                	push   $0x0
  105c82:	6a 3c                	push   $0x3c
  105c84:	e9 87 fa ff ff       	jmp    105710 <alltraps>

00105c89 <vector61>:
  105c89:	6a 00                	push   $0x0
  105c8b:	6a 3d                	push   $0x3d
  105c8d:	e9 7e fa ff ff       	jmp    105710 <alltraps>

00105c92 <vector62>:
  105c92:	6a 00                	push   $0x0
  105c94:	6a 3e                	push   $0x3e
  105c96:	e9 75 fa ff ff       	jmp    105710 <alltraps>

00105c9b <vector63>:
  105c9b:	6a 00                	push   $0x0
  105c9d:	6a 3f                	push   $0x3f
  105c9f:	e9 6c fa ff ff       	jmp    105710 <alltraps>

00105ca4 <vector64>:
  105ca4:	6a 00                	push   $0x0
  105ca6:	6a 40                	push   $0x40
  105ca8:	e9 63 fa ff ff       	jmp    105710 <alltraps>

00105cad <vector65>:
  105cad:	6a 00                	push   $0x0
  105caf:	6a 41                	push   $0x41
  105cb1:	e9 5a fa ff ff       	jmp    105710 <alltraps>

00105cb6 <vector66>:
  105cb6:	6a 00                	push   $0x0
  105cb8:	6a 42                	push   $0x42
  105cba:	e9 51 fa ff ff       	jmp    105710 <alltraps>

00105cbf <vector67>:
  105cbf:	6a 00                	push   $0x0
  105cc1:	6a 43                	push   $0x43
  105cc3:	e9 48 fa ff ff       	jmp    105710 <alltraps>

00105cc8 <vector68>:
  105cc8:	6a 00                	push   $0x0
  105cca:	6a 44                	push   $0x44
  105ccc:	e9 3f fa ff ff       	jmp    105710 <alltraps>

00105cd1 <vector69>:
  105cd1:	6a 00                	push   $0x0
  105cd3:	6a 45                	push   $0x45
  105cd5:	e9 36 fa ff ff       	jmp    105710 <alltraps>

00105cda <vector70>:
  105cda:	6a 00                	push   $0x0
  105cdc:	6a 46                	push   $0x46
  105cde:	e9 2d fa ff ff       	jmp    105710 <alltraps>

00105ce3 <vector71>:
  105ce3:	6a 00                	push   $0x0
  105ce5:	6a 47                	push   $0x47
  105ce7:	e9 24 fa ff ff       	jmp    105710 <alltraps>

00105cec <vector72>:
  105cec:	6a 00                	push   $0x0
  105cee:	6a 48                	push   $0x48
  105cf0:	e9 1b fa ff ff       	jmp    105710 <alltraps>

00105cf5 <vector73>:
  105cf5:	6a 00                	push   $0x0
  105cf7:	6a 49                	push   $0x49
  105cf9:	e9 12 fa ff ff       	jmp    105710 <alltraps>

00105cfe <vector74>:
  105cfe:	6a 00                	push   $0x0
  105d00:	6a 4a                	push   $0x4a
  105d02:	e9 09 fa ff ff       	jmp    105710 <alltraps>

00105d07 <vector75>:
  105d07:	6a 00                	push   $0x0
  105d09:	6a 4b                	push   $0x4b
  105d0b:	e9 00 fa ff ff       	jmp    105710 <alltraps>

00105d10 <vector76>:
  105d10:	6a 00                	push   $0x0
  105d12:	6a 4c                	push   $0x4c
  105d14:	e9 f7 f9 ff ff       	jmp    105710 <alltraps>

00105d19 <vector77>:
  105d19:	6a 00                	push   $0x0
  105d1b:	6a 4d                	push   $0x4d
  105d1d:	e9 ee f9 ff ff       	jmp    105710 <alltraps>

00105d22 <vector78>:
  105d22:	6a 00                	push   $0x0
  105d24:	6a 4e                	push   $0x4e
  105d26:	e9 e5 f9 ff ff       	jmp    105710 <alltraps>

00105d2b <vector79>:
  105d2b:	6a 00                	push   $0x0
  105d2d:	6a 4f                	push   $0x4f
  105d2f:	e9 dc f9 ff ff       	jmp    105710 <alltraps>

00105d34 <vector80>:
  105d34:	6a 00                	push   $0x0
  105d36:	6a 50                	push   $0x50
  105d38:	e9 d3 f9 ff ff       	jmp    105710 <alltraps>

00105d3d <vector81>:
  105d3d:	6a 00                	push   $0x0
  105d3f:	6a 51                	push   $0x51
  105d41:	e9 ca f9 ff ff       	jmp    105710 <alltraps>

00105d46 <vector82>:
  105d46:	6a 00                	push   $0x0
  105d48:	6a 52                	push   $0x52
  105d4a:	e9 c1 f9 ff ff       	jmp    105710 <alltraps>

00105d4f <vector83>:
  105d4f:	6a 00                	push   $0x0
  105d51:	6a 53                	push   $0x53
  105d53:	e9 b8 f9 ff ff       	jmp    105710 <alltraps>

00105d58 <vector84>:
  105d58:	6a 00                	push   $0x0
  105d5a:	6a 54                	push   $0x54
  105d5c:	e9 af f9 ff ff       	jmp    105710 <alltraps>

00105d61 <vector85>:
  105d61:	6a 00                	push   $0x0
  105d63:	6a 55                	push   $0x55
  105d65:	e9 a6 f9 ff ff       	jmp    105710 <alltraps>

00105d6a <vector86>:
  105d6a:	6a 00                	push   $0x0
  105d6c:	6a 56                	push   $0x56
  105d6e:	e9 9d f9 ff ff       	jmp    105710 <alltraps>

00105d73 <vector87>:
  105d73:	6a 00                	push   $0x0
  105d75:	6a 57                	push   $0x57
  105d77:	e9 94 f9 ff ff       	jmp    105710 <alltraps>

00105d7c <vector88>:
  105d7c:	6a 00                	push   $0x0
  105d7e:	6a 58                	push   $0x58
  105d80:	e9 8b f9 ff ff       	jmp    105710 <alltraps>

00105d85 <vector89>:
  105d85:	6a 00                	push   $0x0
  105d87:	6a 59                	push   $0x59
  105d89:	e9 82 f9 ff ff       	jmp    105710 <alltraps>

00105d8e <vector90>:
  105d8e:	6a 00                	push   $0x0
  105d90:	6a 5a                	push   $0x5a
  105d92:	e9 79 f9 ff ff       	jmp    105710 <alltraps>

00105d97 <vector91>:
  105d97:	6a 00                	push   $0x0
  105d99:	6a 5b                	push   $0x5b
  105d9b:	e9 70 f9 ff ff       	jmp    105710 <alltraps>

00105da0 <vector92>:
  105da0:	6a 00                	push   $0x0
  105da2:	6a 5c                	push   $0x5c
  105da4:	e9 67 f9 ff ff       	jmp    105710 <alltraps>

00105da9 <vector93>:
  105da9:	6a 00                	push   $0x0
  105dab:	6a 5d                	push   $0x5d
  105dad:	e9 5e f9 ff ff       	jmp    105710 <alltraps>

00105db2 <vector94>:
  105db2:	6a 00                	push   $0x0
  105db4:	6a 5e                	push   $0x5e
  105db6:	e9 55 f9 ff ff       	jmp    105710 <alltraps>

00105dbb <vector95>:
  105dbb:	6a 00                	push   $0x0
  105dbd:	6a 5f                	push   $0x5f
  105dbf:	e9 4c f9 ff ff       	jmp    105710 <alltraps>

00105dc4 <vector96>:
  105dc4:	6a 00                	push   $0x0
  105dc6:	6a 60                	push   $0x60
  105dc8:	e9 43 f9 ff ff       	jmp    105710 <alltraps>

00105dcd <vector97>:
  105dcd:	6a 00                	push   $0x0
  105dcf:	6a 61                	push   $0x61
  105dd1:	e9 3a f9 ff ff       	jmp    105710 <alltraps>

00105dd6 <vector98>:
  105dd6:	6a 00                	push   $0x0
  105dd8:	6a 62                	push   $0x62
  105dda:	e9 31 f9 ff ff       	jmp    105710 <alltraps>

00105ddf <vector99>:
  105ddf:	6a 00                	push   $0x0
  105de1:	6a 63                	push   $0x63
  105de3:	e9 28 f9 ff ff       	jmp    105710 <alltraps>

00105de8 <vector100>:
  105de8:	6a 00                	push   $0x0
  105dea:	6a 64                	push   $0x64
  105dec:	e9 1f f9 ff ff       	jmp    105710 <alltraps>

00105df1 <vector101>:
  105df1:	6a 00                	push   $0x0
  105df3:	6a 65                	push   $0x65
  105df5:	e9 16 f9 ff ff       	jmp    105710 <alltraps>

00105dfa <vector102>:
  105dfa:	6a 00                	push   $0x0
  105dfc:	6a 66                	push   $0x66
  105dfe:	e9 0d f9 ff ff       	jmp    105710 <alltraps>

00105e03 <vector103>:
  105e03:	6a 00                	push   $0x0
  105e05:	6a 67                	push   $0x67
  105e07:	e9 04 f9 ff ff       	jmp    105710 <alltraps>

00105e0c <vector104>:
  105e0c:	6a 00                	push   $0x0
  105e0e:	6a 68                	push   $0x68
  105e10:	e9 fb f8 ff ff       	jmp    105710 <alltraps>

00105e15 <vector105>:
  105e15:	6a 00                	push   $0x0
  105e17:	6a 69                	push   $0x69
  105e19:	e9 f2 f8 ff ff       	jmp    105710 <alltraps>

00105e1e <vector106>:
  105e1e:	6a 00                	push   $0x0
  105e20:	6a 6a                	push   $0x6a
  105e22:	e9 e9 f8 ff ff       	jmp    105710 <alltraps>

00105e27 <vector107>:
  105e27:	6a 00                	push   $0x0
  105e29:	6a 6b                	push   $0x6b
  105e2b:	e9 e0 f8 ff ff       	jmp    105710 <alltraps>

00105e30 <vector108>:
  105e30:	6a 00                	push   $0x0
  105e32:	6a 6c                	push   $0x6c
  105e34:	e9 d7 f8 ff ff       	jmp    105710 <alltraps>

00105e39 <vector109>:
  105e39:	6a 00                	push   $0x0
  105e3b:	6a 6d                	push   $0x6d
  105e3d:	e9 ce f8 ff ff       	jmp    105710 <alltraps>

00105e42 <vector110>:
  105e42:	6a 00                	push   $0x0
  105e44:	6a 6e                	push   $0x6e
  105e46:	e9 c5 f8 ff ff       	jmp    105710 <alltraps>

00105e4b <vector111>:
  105e4b:	6a 00                	push   $0x0
  105e4d:	6a 6f                	push   $0x6f
  105e4f:	e9 bc f8 ff ff       	jmp    105710 <alltraps>

00105e54 <vector112>:
  105e54:	6a 00                	push   $0x0
  105e56:	6a 70                	push   $0x70
  105e58:	e9 b3 f8 ff ff       	jmp    105710 <alltraps>

00105e5d <vector113>:
  105e5d:	6a 00                	push   $0x0
  105e5f:	6a 71                	push   $0x71
  105e61:	e9 aa f8 ff ff       	jmp    105710 <alltraps>

00105e66 <vector114>:
  105e66:	6a 00                	push   $0x0
  105e68:	6a 72                	push   $0x72
  105e6a:	e9 a1 f8 ff ff       	jmp    105710 <alltraps>

00105e6f <vector115>:
  105e6f:	6a 00                	push   $0x0
  105e71:	6a 73                	push   $0x73
  105e73:	e9 98 f8 ff ff       	jmp    105710 <alltraps>

00105e78 <vector116>:
  105e78:	6a 00                	push   $0x0
  105e7a:	6a 74                	push   $0x74
  105e7c:	e9 8f f8 ff ff       	jmp    105710 <alltraps>

00105e81 <vector117>:
  105e81:	6a 00                	push   $0x0
  105e83:	6a 75                	push   $0x75
  105e85:	e9 86 f8 ff ff       	jmp    105710 <alltraps>

00105e8a <vector118>:
  105e8a:	6a 00                	push   $0x0
  105e8c:	6a 76                	push   $0x76
  105e8e:	e9 7d f8 ff ff       	jmp    105710 <alltraps>

00105e93 <vector119>:
  105e93:	6a 00                	push   $0x0
  105e95:	6a 77                	push   $0x77
  105e97:	e9 74 f8 ff ff       	jmp    105710 <alltraps>

00105e9c <vector120>:
  105e9c:	6a 00                	push   $0x0
  105e9e:	6a 78                	push   $0x78
  105ea0:	e9 6b f8 ff ff       	jmp    105710 <alltraps>

00105ea5 <vector121>:
  105ea5:	6a 00                	push   $0x0
  105ea7:	6a 79                	push   $0x79
  105ea9:	e9 62 f8 ff ff       	jmp    105710 <alltraps>

00105eae <vector122>:
  105eae:	6a 00                	push   $0x0
  105eb0:	6a 7a                	push   $0x7a
  105eb2:	e9 59 f8 ff ff       	jmp    105710 <alltraps>

00105eb7 <vector123>:
  105eb7:	6a 00                	push   $0x0
  105eb9:	6a 7b                	push   $0x7b
  105ebb:	e9 50 f8 ff ff       	jmp    105710 <alltraps>

00105ec0 <vector124>:
  105ec0:	6a 00                	push   $0x0
  105ec2:	6a 7c                	push   $0x7c
  105ec4:	e9 47 f8 ff ff       	jmp    105710 <alltraps>

00105ec9 <vector125>:
  105ec9:	6a 00                	push   $0x0
  105ecb:	6a 7d                	push   $0x7d
  105ecd:	e9 3e f8 ff ff       	jmp    105710 <alltraps>

00105ed2 <vector126>:
  105ed2:	6a 00                	push   $0x0
  105ed4:	6a 7e                	push   $0x7e
  105ed6:	e9 35 f8 ff ff       	jmp    105710 <alltraps>

00105edb <vector127>:
  105edb:	6a 00                	push   $0x0
  105edd:	6a 7f                	push   $0x7f
  105edf:	e9 2c f8 ff ff       	jmp    105710 <alltraps>

00105ee4 <vector128>:
  105ee4:	6a 00                	push   $0x0
  105ee6:	68 80 00 00 00       	push   $0x80
  105eeb:	e9 20 f8 ff ff       	jmp    105710 <alltraps>

00105ef0 <vector129>:
  105ef0:	6a 00                	push   $0x0
  105ef2:	68 81 00 00 00       	push   $0x81
  105ef7:	e9 14 f8 ff ff       	jmp    105710 <alltraps>

00105efc <vector130>:
  105efc:	6a 00                	push   $0x0
  105efe:	68 82 00 00 00       	push   $0x82
  105f03:	e9 08 f8 ff ff       	jmp    105710 <alltraps>

00105f08 <vector131>:
  105f08:	6a 00                	push   $0x0
  105f0a:	68 83 00 00 00       	push   $0x83
  105f0f:	e9 fc f7 ff ff       	jmp    105710 <alltraps>

00105f14 <vector132>:
  105f14:	6a 00                	push   $0x0
  105f16:	68 84 00 00 00       	push   $0x84
  105f1b:	e9 f0 f7 ff ff       	jmp    105710 <alltraps>

00105f20 <vector133>:
  105f20:	6a 00                	push   $0x0
  105f22:	68 85 00 00 00       	push   $0x85
  105f27:	e9 e4 f7 ff ff       	jmp    105710 <alltraps>

00105f2c <vector134>:
  105f2c:	6a 00                	push   $0x0
  105f2e:	68 86 00 00 00       	push   $0x86
  105f33:	e9 d8 f7 ff ff       	jmp    105710 <alltraps>

00105f38 <vector135>:
  105f38:	6a 00                	push   $0x0
  105f3a:	68 87 00 00 00       	push   $0x87
  105f3f:	e9 cc f7 ff ff       	jmp    105710 <alltraps>

00105f44 <vector136>:
  105f44:	6a 00                	push   $0x0
  105f46:	68 88 00 00 00       	push   $0x88
  105f4b:	e9 c0 f7 ff ff       	jmp    105710 <alltraps>

00105f50 <vector137>:
  105f50:	6a 00                	push   $0x0
  105f52:	68 89 00 00 00       	push   $0x89
  105f57:	e9 b4 f7 ff ff       	jmp    105710 <alltraps>

00105f5c <vector138>:
  105f5c:	6a 00                	push   $0x0
  105f5e:	68 8a 00 00 00       	push   $0x8a
  105f63:	e9 a8 f7 ff ff       	jmp    105710 <alltraps>

00105f68 <vector139>:
  105f68:	6a 00                	push   $0x0
  105f6a:	68 8b 00 00 00       	push   $0x8b
  105f6f:	e9 9c f7 ff ff       	jmp    105710 <alltraps>

00105f74 <vector140>:
  105f74:	6a 00                	push   $0x0
  105f76:	68 8c 00 00 00       	push   $0x8c
  105f7b:	e9 90 f7 ff ff       	jmp    105710 <alltraps>

00105f80 <vector141>:
  105f80:	6a 00                	push   $0x0
  105f82:	68 8d 00 00 00       	push   $0x8d
  105f87:	e9 84 f7 ff ff       	jmp    105710 <alltraps>

00105f8c <vector142>:
  105f8c:	6a 00                	push   $0x0
  105f8e:	68 8e 00 00 00       	push   $0x8e
  105f93:	e9 78 f7 ff ff       	jmp    105710 <alltraps>

00105f98 <vector143>:
  105f98:	6a 00                	push   $0x0
  105f9a:	68 8f 00 00 00       	push   $0x8f
  105f9f:	e9 6c f7 ff ff       	jmp    105710 <alltraps>

00105fa4 <vector144>:
  105fa4:	6a 00                	push   $0x0
  105fa6:	68 90 00 00 00       	push   $0x90
  105fab:	e9 60 f7 ff ff       	jmp    105710 <alltraps>

00105fb0 <vector145>:
  105fb0:	6a 00                	push   $0x0
  105fb2:	68 91 00 00 00       	push   $0x91
  105fb7:	e9 54 f7 ff ff       	jmp    105710 <alltraps>

00105fbc <vector146>:
  105fbc:	6a 00                	push   $0x0
  105fbe:	68 92 00 00 00       	push   $0x92
  105fc3:	e9 48 f7 ff ff       	jmp    105710 <alltraps>

00105fc8 <vector147>:
  105fc8:	6a 00                	push   $0x0
  105fca:	68 93 00 00 00       	push   $0x93
  105fcf:	e9 3c f7 ff ff       	jmp    105710 <alltraps>

00105fd4 <vector148>:
  105fd4:	6a 00                	push   $0x0
  105fd6:	68 94 00 00 00       	push   $0x94
  105fdb:	e9 30 f7 ff ff       	jmp    105710 <alltraps>

00105fe0 <vector149>:
  105fe0:	6a 00                	push   $0x0
  105fe2:	68 95 00 00 00       	push   $0x95
  105fe7:	e9 24 f7 ff ff       	jmp    105710 <alltraps>

00105fec <vector150>:
  105fec:	6a 00                	push   $0x0
  105fee:	68 96 00 00 00       	push   $0x96
  105ff3:	e9 18 f7 ff ff       	jmp    105710 <alltraps>

00105ff8 <vector151>:
  105ff8:	6a 00                	push   $0x0
  105ffa:	68 97 00 00 00       	push   $0x97
  105fff:	e9 0c f7 ff ff       	jmp    105710 <alltraps>

00106004 <vector152>:
  106004:	6a 00                	push   $0x0
  106006:	68 98 00 00 00       	push   $0x98
  10600b:	e9 00 f7 ff ff       	jmp    105710 <alltraps>

00106010 <vector153>:
  106010:	6a 00                	push   $0x0
  106012:	68 99 00 00 00       	push   $0x99
  106017:	e9 f4 f6 ff ff       	jmp    105710 <alltraps>

0010601c <vector154>:
  10601c:	6a 00                	push   $0x0
  10601e:	68 9a 00 00 00       	push   $0x9a
  106023:	e9 e8 f6 ff ff       	jmp    105710 <alltraps>

00106028 <vector155>:
  106028:	6a 00                	push   $0x0
  10602a:	68 9b 00 00 00       	push   $0x9b
  10602f:	e9 dc f6 ff ff       	jmp    105710 <alltraps>

00106034 <vector156>:
  106034:	6a 00                	push   $0x0
  106036:	68 9c 00 00 00       	push   $0x9c
  10603b:	e9 d0 f6 ff ff       	jmp    105710 <alltraps>

00106040 <vector157>:
  106040:	6a 00                	push   $0x0
  106042:	68 9d 00 00 00       	push   $0x9d
  106047:	e9 c4 f6 ff ff       	jmp    105710 <alltraps>

0010604c <vector158>:
  10604c:	6a 00                	push   $0x0
  10604e:	68 9e 00 00 00       	push   $0x9e
  106053:	e9 b8 f6 ff ff       	jmp    105710 <alltraps>

00106058 <vector159>:
  106058:	6a 00                	push   $0x0
  10605a:	68 9f 00 00 00       	push   $0x9f
  10605f:	e9 ac f6 ff ff       	jmp    105710 <alltraps>

00106064 <vector160>:
  106064:	6a 00                	push   $0x0
  106066:	68 a0 00 00 00       	push   $0xa0
  10606b:	e9 a0 f6 ff ff       	jmp    105710 <alltraps>

00106070 <vector161>:
  106070:	6a 00                	push   $0x0
  106072:	68 a1 00 00 00       	push   $0xa1
  106077:	e9 94 f6 ff ff       	jmp    105710 <alltraps>

0010607c <vector162>:
  10607c:	6a 00                	push   $0x0
  10607e:	68 a2 00 00 00       	push   $0xa2
  106083:	e9 88 f6 ff ff       	jmp    105710 <alltraps>

00106088 <vector163>:
  106088:	6a 00                	push   $0x0
  10608a:	68 a3 00 00 00       	push   $0xa3
  10608f:	e9 7c f6 ff ff       	jmp    105710 <alltraps>

00106094 <vector164>:
  106094:	6a 00                	push   $0x0
  106096:	68 a4 00 00 00       	push   $0xa4
  10609b:	e9 70 f6 ff ff       	jmp    105710 <alltraps>

001060a0 <vector165>:
  1060a0:	6a 00                	push   $0x0
  1060a2:	68 a5 00 00 00       	push   $0xa5
  1060a7:	e9 64 f6 ff ff       	jmp    105710 <alltraps>

001060ac <vector166>:
  1060ac:	6a 00                	push   $0x0
  1060ae:	68 a6 00 00 00       	push   $0xa6
  1060b3:	e9 58 f6 ff ff       	jmp    105710 <alltraps>

001060b8 <vector167>:
  1060b8:	6a 00                	push   $0x0
  1060ba:	68 a7 00 00 00       	push   $0xa7
  1060bf:	e9 4c f6 ff ff       	jmp    105710 <alltraps>

001060c4 <vector168>:
  1060c4:	6a 00                	push   $0x0
  1060c6:	68 a8 00 00 00       	push   $0xa8
  1060cb:	e9 40 f6 ff ff       	jmp    105710 <alltraps>

001060d0 <vector169>:
  1060d0:	6a 00                	push   $0x0
  1060d2:	68 a9 00 00 00       	push   $0xa9
  1060d7:	e9 34 f6 ff ff       	jmp    105710 <alltraps>

001060dc <vector170>:
  1060dc:	6a 00                	push   $0x0
  1060de:	68 aa 00 00 00       	push   $0xaa
  1060e3:	e9 28 f6 ff ff       	jmp    105710 <alltraps>

001060e8 <vector171>:
  1060e8:	6a 00                	push   $0x0
  1060ea:	68 ab 00 00 00       	push   $0xab
  1060ef:	e9 1c f6 ff ff       	jmp    105710 <alltraps>

001060f4 <vector172>:
  1060f4:	6a 00                	push   $0x0
  1060f6:	68 ac 00 00 00       	push   $0xac
  1060fb:	e9 10 f6 ff ff       	jmp    105710 <alltraps>

00106100 <vector173>:
  106100:	6a 00                	push   $0x0
  106102:	68 ad 00 00 00       	push   $0xad
  106107:	e9 04 f6 ff ff       	jmp    105710 <alltraps>

0010610c <vector174>:
  10610c:	6a 00                	push   $0x0
  10610e:	68 ae 00 00 00       	push   $0xae
  106113:	e9 f8 f5 ff ff       	jmp    105710 <alltraps>

00106118 <vector175>:
  106118:	6a 00                	push   $0x0
  10611a:	68 af 00 00 00       	push   $0xaf
  10611f:	e9 ec f5 ff ff       	jmp    105710 <alltraps>

00106124 <vector176>:
  106124:	6a 00                	push   $0x0
  106126:	68 b0 00 00 00       	push   $0xb0
  10612b:	e9 e0 f5 ff ff       	jmp    105710 <alltraps>

00106130 <vector177>:
  106130:	6a 00                	push   $0x0
  106132:	68 b1 00 00 00       	push   $0xb1
  106137:	e9 d4 f5 ff ff       	jmp    105710 <alltraps>

0010613c <vector178>:
  10613c:	6a 00                	push   $0x0
  10613e:	68 b2 00 00 00       	push   $0xb2
  106143:	e9 c8 f5 ff ff       	jmp    105710 <alltraps>

00106148 <vector179>:
  106148:	6a 00                	push   $0x0
  10614a:	68 b3 00 00 00       	push   $0xb3
  10614f:	e9 bc f5 ff ff       	jmp    105710 <alltraps>

00106154 <vector180>:
  106154:	6a 00                	push   $0x0
  106156:	68 b4 00 00 00       	push   $0xb4
  10615b:	e9 b0 f5 ff ff       	jmp    105710 <alltraps>

00106160 <vector181>:
  106160:	6a 00                	push   $0x0
  106162:	68 b5 00 00 00       	push   $0xb5
  106167:	e9 a4 f5 ff ff       	jmp    105710 <alltraps>

0010616c <vector182>:
  10616c:	6a 00                	push   $0x0
  10616e:	68 b6 00 00 00       	push   $0xb6
  106173:	e9 98 f5 ff ff       	jmp    105710 <alltraps>

00106178 <vector183>:
  106178:	6a 00                	push   $0x0
  10617a:	68 b7 00 00 00       	push   $0xb7
  10617f:	e9 8c f5 ff ff       	jmp    105710 <alltraps>

00106184 <vector184>:
  106184:	6a 00                	push   $0x0
  106186:	68 b8 00 00 00       	push   $0xb8
  10618b:	e9 80 f5 ff ff       	jmp    105710 <alltraps>

00106190 <vector185>:
  106190:	6a 00                	push   $0x0
  106192:	68 b9 00 00 00       	push   $0xb9
  106197:	e9 74 f5 ff ff       	jmp    105710 <alltraps>

0010619c <vector186>:
  10619c:	6a 00                	push   $0x0
  10619e:	68 ba 00 00 00       	push   $0xba
  1061a3:	e9 68 f5 ff ff       	jmp    105710 <alltraps>

001061a8 <vector187>:
  1061a8:	6a 00                	push   $0x0
  1061aa:	68 bb 00 00 00       	push   $0xbb
  1061af:	e9 5c f5 ff ff       	jmp    105710 <alltraps>

001061b4 <vector188>:
  1061b4:	6a 00                	push   $0x0
  1061b6:	68 bc 00 00 00       	push   $0xbc
  1061bb:	e9 50 f5 ff ff       	jmp    105710 <alltraps>

001061c0 <vector189>:
  1061c0:	6a 00                	push   $0x0
  1061c2:	68 bd 00 00 00       	push   $0xbd
  1061c7:	e9 44 f5 ff ff       	jmp    105710 <alltraps>

001061cc <vector190>:
  1061cc:	6a 00                	push   $0x0
  1061ce:	68 be 00 00 00       	push   $0xbe
  1061d3:	e9 38 f5 ff ff       	jmp    105710 <alltraps>

001061d8 <vector191>:
  1061d8:	6a 00                	push   $0x0
  1061da:	68 bf 00 00 00       	push   $0xbf
  1061df:	e9 2c f5 ff ff       	jmp    105710 <alltraps>

001061e4 <vector192>:
  1061e4:	6a 00                	push   $0x0
  1061e6:	68 c0 00 00 00       	push   $0xc0
  1061eb:	e9 20 f5 ff ff       	jmp    105710 <alltraps>

001061f0 <vector193>:
  1061f0:	6a 00                	push   $0x0
  1061f2:	68 c1 00 00 00       	push   $0xc1
  1061f7:	e9 14 f5 ff ff       	jmp    105710 <alltraps>

001061fc <vector194>:
  1061fc:	6a 00                	push   $0x0
  1061fe:	68 c2 00 00 00       	push   $0xc2
  106203:	e9 08 f5 ff ff       	jmp    105710 <alltraps>

00106208 <vector195>:
  106208:	6a 00                	push   $0x0
  10620a:	68 c3 00 00 00       	push   $0xc3
  10620f:	e9 fc f4 ff ff       	jmp    105710 <alltraps>

00106214 <vector196>:
  106214:	6a 00                	push   $0x0
  106216:	68 c4 00 00 00       	push   $0xc4
  10621b:	e9 f0 f4 ff ff       	jmp    105710 <alltraps>

00106220 <vector197>:
  106220:	6a 00                	push   $0x0
  106222:	68 c5 00 00 00       	push   $0xc5
  106227:	e9 e4 f4 ff ff       	jmp    105710 <alltraps>

0010622c <vector198>:
  10622c:	6a 00                	push   $0x0
  10622e:	68 c6 00 00 00       	push   $0xc6
  106233:	e9 d8 f4 ff ff       	jmp    105710 <alltraps>

00106238 <vector199>:
  106238:	6a 00                	push   $0x0
  10623a:	68 c7 00 00 00       	push   $0xc7
  10623f:	e9 cc f4 ff ff       	jmp    105710 <alltraps>

00106244 <vector200>:
  106244:	6a 00                	push   $0x0
  106246:	68 c8 00 00 00       	push   $0xc8
  10624b:	e9 c0 f4 ff ff       	jmp    105710 <alltraps>

00106250 <vector201>:
  106250:	6a 00                	push   $0x0
  106252:	68 c9 00 00 00       	push   $0xc9
  106257:	e9 b4 f4 ff ff       	jmp    105710 <alltraps>

0010625c <vector202>:
  10625c:	6a 00                	push   $0x0
  10625e:	68 ca 00 00 00       	push   $0xca
  106263:	e9 a8 f4 ff ff       	jmp    105710 <alltraps>

00106268 <vector203>:
  106268:	6a 00                	push   $0x0
  10626a:	68 cb 00 00 00       	push   $0xcb
  10626f:	e9 9c f4 ff ff       	jmp    105710 <alltraps>

00106274 <vector204>:
  106274:	6a 00                	push   $0x0
  106276:	68 cc 00 00 00       	push   $0xcc
  10627b:	e9 90 f4 ff ff       	jmp    105710 <alltraps>

00106280 <vector205>:
  106280:	6a 00                	push   $0x0
  106282:	68 cd 00 00 00       	push   $0xcd
  106287:	e9 84 f4 ff ff       	jmp    105710 <alltraps>

0010628c <vector206>:
  10628c:	6a 00                	push   $0x0
  10628e:	68 ce 00 00 00       	push   $0xce
  106293:	e9 78 f4 ff ff       	jmp    105710 <alltraps>

00106298 <vector207>:
  106298:	6a 00                	push   $0x0
  10629a:	68 cf 00 00 00       	push   $0xcf
  10629f:	e9 6c f4 ff ff       	jmp    105710 <alltraps>

001062a4 <vector208>:
  1062a4:	6a 00                	push   $0x0
  1062a6:	68 d0 00 00 00       	push   $0xd0
  1062ab:	e9 60 f4 ff ff       	jmp    105710 <alltraps>

001062b0 <vector209>:
  1062b0:	6a 00                	push   $0x0
  1062b2:	68 d1 00 00 00       	push   $0xd1
  1062b7:	e9 54 f4 ff ff       	jmp    105710 <alltraps>

001062bc <vector210>:
  1062bc:	6a 00                	push   $0x0
  1062be:	68 d2 00 00 00       	push   $0xd2
  1062c3:	e9 48 f4 ff ff       	jmp    105710 <alltraps>

001062c8 <vector211>:
  1062c8:	6a 00                	push   $0x0
  1062ca:	68 d3 00 00 00       	push   $0xd3
  1062cf:	e9 3c f4 ff ff       	jmp    105710 <alltraps>

001062d4 <vector212>:
  1062d4:	6a 00                	push   $0x0
  1062d6:	68 d4 00 00 00       	push   $0xd4
  1062db:	e9 30 f4 ff ff       	jmp    105710 <alltraps>

001062e0 <vector213>:
  1062e0:	6a 00                	push   $0x0
  1062e2:	68 d5 00 00 00       	push   $0xd5
  1062e7:	e9 24 f4 ff ff       	jmp    105710 <alltraps>

001062ec <vector214>:
  1062ec:	6a 00                	push   $0x0
  1062ee:	68 d6 00 00 00       	push   $0xd6
  1062f3:	e9 18 f4 ff ff       	jmp    105710 <alltraps>

001062f8 <vector215>:
  1062f8:	6a 00                	push   $0x0
  1062fa:	68 d7 00 00 00       	push   $0xd7
  1062ff:	e9 0c f4 ff ff       	jmp    105710 <alltraps>

00106304 <vector216>:
  106304:	6a 00                	push   $0x0
  106306:	68 d8 00 00 00       	push   $0xd8
  10630b:	e9 00 f4 ff ff       	jmp    105710 <alltraps>

00106310 <vector217>:
  106310:	6a 00                	push   $0x0
  106312:	68 d9 00 00 00       	push   $0xd9
  106317:	e9 f4 f3 ff ff       	jmp    105710 <alltraps>

0010631c <vector218>:
  10631c:	6a 00                	push   $0x0
  10631e:	68 da 00 00 00       	push   $0xda
  106323:	e9 e8 f3 ff ff       	jmp    105710 <alltraps>

00106328 <vector219>:
  106328:	6a 00                	push   $0x0
  10632a:	68 db 00 00 00       	push   $0xdb
  10632f:	e9 dc f3 ff ff       	jmp    105710 <alltraps>

00106334 <vector220>:
  106334:	6a 00                	push   $0x0
  106336:	68 dc 00 00 00       	push   $0xdc
  10633b:	e9 d0 f3 ff ff       	jmp    105710 <alltraps>

00106340 <vector221>:
  106340:	6a 00                	push   $0x0
  106342:	68 dd 00 00 00       	push   $0xdd
  106347:	e9 c4 f3 ff ff       	jmp    105710 <alltraps>

0010634c <vector222>:
  10634c:	6a 00                	push   $0x0
  10634e:	68 de 00 00 00       	push   $0xde
  106353:	e9 b8 f3 ff ff       	jmp    105710 <alltraps>

00106358 <vector223>:
  106358:	6a 00                	push   $0x0
  10635a:	68 df 00 00 00       	push   $0xdf
  10635f:	e9 ac f3 ff ff       	jmp    105710 <alltraps>

00106364 <vector224>:
  106364:	6a 00                	push   $0x0
  106366:	68 e0 00 00 00       	push   $0xe0
  10636b:	e9 a0 f3 ff ff       	jmp    105710 <alltraps>

00106370 <vector225>:
  106370:	6a 00                	push   $0x0
  106372:	68 e1 00 00 00       	push   $0xe1
  106377:	e9 94 f3 ff ff       	jmp    105710 <alltraps>

0010637c <vector226>:
  10637c:	6a 00                	push   $0x0
  10637e:	68 e2 00 00 00       	push   $0xe2
  106383:	e9 88 f3 ff ff       	jmp    105710 <alltraps>

00106388 <vector227>:
  106388:	6a 00                	push   $0x0
  10638a:	68 e3 00 00 00       	push   $0xe3
  10638f:	e9 7c f3 ff ff       	jmp    105710 <alltraps>

00106394 <vector228>:
  106394:	6a 00                	push   $0x0
  106396:	68 e4 00 00 00       	push   $0xe4
  10639b:	e9 70 f3 ff ff       	jmp    105710 <alltraps>

001063a0 <vector229>:
  1063a0:	6a 00                	push   $0x0
  1063a2:	68 e5 00 00 00       	push   $0xe5
  1063a7:	e9 64 f3 ff ff       	jmp    105710 <alltraps>

001063ac <vector230>:
  1063ac:	6a 00                	push   $0x0
  1063ae:	68 e6 00 00 00       	push   $0xe6
  1063b3:	e9 58 f3 ff ff       	jmp    105710 <alltraps>

001063b8 <vector231>:
  1063b8:	6a 00                	push   $0x0
  1063ba:	68 e7 00 00 00       	push   $0xe7
  1063bf:	e9 4c f3 ff ff       	jmp    105710 <alltraps>

001063c4 <vector232>:
  1063c4:	6a 00                	push   $0x0
  1063c6:	68 e8 00 00 00       	push   $0xe8
  1063cb:	e9 40 f3 ff ff       	jmp    105710 <alltraps>

001063d0 <vector233>:
  1063d0:	6a 00                	push   $0x0
  1063d2:	68 e9 00 00 00       	push   $0xe9
  1063d7:	e9 34 f3 ff ff       	jmp    105710 <alltraps>

001063dc <vector234>:
  1063dc:	6a 00                	push   $0x0
  1063de:	68 ea 00 00 00       	push   $0xea
  1063e3:	e9 28 f3 ff ff       	jmp    105710 <alltraps>

001063e8 <vector235>:
  1063e8:	6a 00                	push   $0x0
  1063ea:	68 eb 00 00 00       	push   $0xeb
  1063ef:	e9 1c f3 ff ff       	jmp    105710 <alltraps>

001063f4 <vector236>:
  1063f4:	6a 00                	push   $0x0
  1063f6:	68 ec 00 00 00       	push   $0xec
  1063fb:	e9 10 f3 ff ff       	jmp    105710 <alltraps>

00106400 <vector237>:
  106400:	6a 00                	push   $0x0
  106402:	68 ed 00 00 00       	push   $0xed
  106407:	e9 04 f3 ff ff       	jmp    105710 <alltraps>

0010640c <vector238>:
  10640c:	6a 00                	push   $0x0
  10640e:	68 ee 00 00 00       	push   $0xee
  106413:	e9 f8 f2 ff ff       	jmp    105710 <alltraps>

00106418 <vector239>:
  106418:	6a 00                	push   $0x0
  10641a:	68 ef 00 00 00       	push   $0xef
  10641f:	e9 ec f2 ff ff       	jmp    105710 <alltraps>

00106424 <vector240>:
  106424:	6a 00                	push   $0x0
  106426:	68 f0 00 00 00       	push   $0xf0
  10642b:	e9 e0 f2 ff ff       	jmp    105710 <alltraps>

00106430 <vector241>:
  106430:	6a 00                	push   $0x0
  106432:	68 f1 00 00 00       	push   $0xf1
  106437:	e9 d4 f2 ff ff       	jmp    105710 <alltraps>

0010643c <vector242>:
  10643c:	6a 00                	push   $0x0
  10643e:	68 f2 00 00 00       	push   $0xf2
  106443:	e9 c8 f2 ff ff       	jmp    105710 <alltraps>

00106448 <vector243>:
  106448:	6a 00                	push   $0x0
  10644a:	68 f3 00 00 00       	push   $0xf3
  10644f:	e9 bc f2 ff ff       	jmp    105710 <alltraps>

00106454 <vector244>:
  106454:	6a 00                	push   $0x0
  106456:	68 f4 00 00 00       	push   $0xf4
  10645b:	e9 b0 f2 ff ff       	jmp    105710 <alltraps>

00106460 <vector245>:
  106460:	6a 00                	push   $0x0
  106462:	68 f5 00 00 00       	push   $0xf5
  106467:	e9 a4 f2 ff ff       	jmp    105710 <alltraps>

0010646c <vector246>:
  10646c:	6a 00                	push   $0x0
  10646e:	68 f6 00 00 00       	push   $0xf6
  106473:	e9 98 f2 ff ff       	jmp    105710 <alltraps>

00106478 <vector247>:
  106478:	6a 00                	push   $0x0
  10647a:	68 f7 00 00 00       	push   $0xf7
  10647f:	e9 8c f2 ff ff       	jmp    105710 <alltraps>

00106484 <vector248>:
  106484:	6a 00                	push   $0x0
  106486:	68 f8 00 00 00       	push   $0xf8
  10648b:	e9 80 f2 ff ff       	jmp    105710 <alltraps>

00106490 <vector249>:
  106490:	6a 00                	push   $0x0
  106492:	68 f9 00 00 00       	push   $0xf9
  106497:	e9 74 f2 ff ff       	jmp    105710 <alltraps>

0010649c <vector250>:
  10649c:	6a 00                	push   $0x0
  10649e:	68 fa 00 00 00       	push   $0xfa
  1064a3:	e9 68 f2 ff ff       	jmp    105710 <alltraps>

001064a8 <vector251>:
  1064a8:	6a 00                	push   $0x0
  1064aa:	68 fb 00 00 00       	push   $0xfb
  1064af:	e9 5c f2 ff ff       	jmp    105710 <alltraps>

001064b4 <vector252>:
  1064b4:	6a 00                	push   $0x0
  1064b6:	68 fc 00 00 00       	push   $0xfc
  1064bb:	e9 50 f2 ff ff       	jmp    105710 <alltraps>

001064c0 <vector253>:
  1064c0:	6a 00                	push   $0x0
  1064c2:	68 fd 00 00 00       	push   $0xfd
  1064c7:	e9 44 f2 ff ff       	jmp    105710 <alltraps>

001064cc <vector254>:
  1064cc:	6a 00                	push   $0x0
  1064ce:	68 fe 00 00 00       	push   $0xfe
  1064d3:	e9 38 f2 ff ff       	jmp    105710 <alltraps>

001064d8 <vector255>:
  1064d8:	6a 00                	push   $0x0
  1064da:	68 ff 00 00 00       	push   $0xff
  1064df:	e9 2c f2 ff ff       	jmp    105710 <alltraps>
