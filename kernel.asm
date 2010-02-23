
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
  10000f:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  100016:	e8 75 44 00 00       	call   104490 <acquire>
  10001b:	8b 53 10             	mov    0x10(%ebx),%edx
  10001e:	8b 43 0c             	mov    0xc(%ebx),%eax
  100021:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  100024:	89 42 0c             	mov    %eax,0xc(%edx)
  100027:	8b 43 0c             	mov    0xc(%ebx),%eax
  10002a:	c7 43 0c 20 85 10 00 	movl   $0x108520,0xc(%ebx)
  100031:	89 50 10             	mov    %edx,0x10(%eax)
  100034:	a1 30 85 10 00       	mov    0x108530,%eax
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  10003c:	a1 30 85 10 00       	mov    0x108530,%eax
  100041:	89 1d 30 85 10 00    	mov    %ebx,0x108530
  100047:	89 58 0c             	mov    %ebx,0xc(%eax)
  10004a:	c7 04 24 40 87 10 00 	movl   $0x108740,(%esp)
  100051:	e8 3a 33 00 00       	call   103390 <wakeup>
  100056:	c7 45 08 40 9c 10 00 	movl   $0x109c40,0x8(%ebp)
  10005d:	83 c4 04             	add    $0x4,%esp
  100060:	5b                   	pop    %ebx
  100061:	5d                   	pop    %ebp
  100062:	e9 e9 43 00 00       	jmp    104450 <release>
  100067:	c7 04 24 60 65 10 00 	movl   $0x106560,(%esp)
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
  10009d:	c7 04 24 67 65 10 00 	movl   $0x106567,(%esp)
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
  1000bf:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  1000c6:	e8 c5 43 00 00       	call   104490 <acquire>
  1000cb:	8b 1d 30 85 10 00    	mov    0x108530,%ebx
  1000d1:	81 fb 20 85 10 00    	cmp    $0x108520,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 45                	jmp    100120 <bread+0x70>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb 20 85 10 00    	cmp    $0x108520,%ebx
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
  10010a:	c7 44 24 04 40 9c 10 	movl   $0x109c40,0x4(%esp)
  100111:	00 
  100112:	c7 04 24 40 87 10 00 	movl   $0x108740,(%esp)
  100119:	e8 d2 35 00 00       	call   1036f0 <sleep>
  10011e:	eb ab                	jmp    1000cb <bread+0x1b>
  100120:	a1 2c 85 10 00       	mov    0x10852c,%eax
  100125:	3d 20 85 10 00       	cmp    $0x108520,%eax
  10012a:	75 0e                	jne    10013a <bread+0x8a>
  10012c:	eb 45                	jmp    100173 <bread+0xc3>
  10012e:	66 90                	xchg   %ax,%ax
  100130:	8b 40 0c             	mov    0xc(%eax),%eax
  100133:	3d 20 85 10 00       	cmp    $0x108520,%eax
  100138:	74 39                	je     100173 <bread+0xc3>
  10013a:	f6 00 01             	testb  $0x1,(%eax)
  10013d:	8d 76 00             	lea    0x0(%esi),%esi
  100140:	75 ee                	jne    100130 <bread+0x80>
  100142:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  100148:	89 c3                	mov    %eax,%ebx
  10014a:	89 70 04             	mov    %esi,0x4(%eax)
  10014d:	89 78 08             	mov    %edi,0x8(%eax)
  100150:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  100157:	e8 f4 42 00 00       	call   104450 <release>
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
  100173:	c7 04 24 6e 65 10 00 	movl   $0x10656e,(%esp)
  10017a:	e8 f1 07 00 00       	call   100970 <panic>
  10017f:	83 c8 01             	or     $0x1,%eax
  100182:	89 03                	mov    %eax,(%ebx)
  100184:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  10018b:	e8 c0 42 00 00       	call   104450 <release>
  100190:	eb ca                	jmp    10015c <bread+0xac>
  100192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001001a0 <binit>:
  1001a0:	55                   	push   %ebp
  1001a1:	89 e5                	mov    %esp,%ebp
  1001a3:	83 ec 08             	sub    $0x8,%esp
  1001a6:	c7 44 24 04 7f 65 10 	movl   $0x10657f,0x4(%esp)
  1001ad:	00 
  1001ae:	c7 04 24 40 9c 10 00 	movl   $0x109c40,(%esp)
  1001b5:	e8 06 41 00 00       	call   1042c0 <initlock>
  1001ba:	b8 30 9c 10 00       	mov    $0x109c30,%eax
  1001bf:	3d 40 87 10 00       	cmp    $0x108740,%eax
  1001c4:	c7 05 2c 85 10 00 20 	movl   $0x108520,0x10852c
  1001cb:	85 10 00 
  1001ce:	c7 05 30 85 10 00 20 	movl   $0x108520,0x108530
  1001d5:	85 10 00 
  1001d8:	76 37                	jbe    100211 <binit+0x71>
  1001da:	b8 40 87 10 00       	mov    $0x108740,%eax
  1001df:	ba 20 85 10 00       	mov    $0x108520,%edx
  1001e4:	eb 06                	jmp    1001ec <binit+0x4c>
  1001e6:	66 90                	xchg   %ax,%ax
  1001e8:	89 c2                	mov    %eax,%edx
  1001ea:	89 c8                	mov    %ecx,%eax
  1001ec:	8d 88 18 02 00 00    	lea    0x218(%eax),%ecx
  1001f2:	81 f9 30 9c 10 00    	cmp    $0x109c30,%ecx
  1001f8:	c7 40 0c 20 85 10 00 	movl   $0x108520,0xc(%eax)
  1001ff:	89 50 10             	mov    %edx,0x10(%eax)
  100202:	89 42 0c             	mov    %eax,0xc(%edx)
  100205:	75 e1                	jne    1001e8 <binit+0x48>
  100207:	c7 05 30 85 10 00 18 	movl   $0x109a18,0x108530
  10020e:	9a 10 00 
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
  100226:	c7 44 24 04 89 65 10 	movl   $0x106589,0x4(%esp)
  10022d:	00 
  10022e:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  100235:	e8 86 40 00 00       	call   1042c0 <initlock>
  10023a:	c7 44 24 04 91 65 10 	movl   $0x106591,0x4(%esp)
  100241:	00 
  100242:	c7 04 24 80 9c 10 00 	movl   $0x109c80,(%esp)
  100249:	e8 72 40 00 00       	call   1042c0 <initlock>
  10024e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100255:	c7 05 ec a6 10 00 a0 	movl   $0x1006a0,0x10a6ec
  10025c:	06 10 00 
  10025f:	c7 05 e8 a6 10 00 90 	movl   $0x100290,0x10a6e8
  100266:	02 10 00 
  100269:	c7 05 64 84 10 00 01 	movl   $0x1,0x108464
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
  1002ad:	c7 04 24 80 9c 10 00 	movl   $0x109c80,(%esp)
  1002b4:	e8 d7 41 00 00       	call   104490 <acquire>
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
  1002e2:	c7 44 24 04 80 9c 10 	movl   $0x109c80,0x4(%esp)
  1002e9:	00 
  1002ea:	c7 04 24 34 9d 10 00 	movl   $0x109d34,(%esp)
  1002f1:	e8 fa 33 00 00       	call   1036f0 <sleep>
  1002f6:	8b 15 34 9d 10 00    	mov    0x109d34,%edx
  1002fc:	3b 15 38 9d 10 00    	cmp    0x109d38,%edx
  100302:	74 c4                	je     1002c8 <console_read+0x38>
  100304:	89 d0                	mov    %edx,%eax
  100306:	83 e0 7f             	and    $0x7f,%eax
  100309:	0f b6 88 b4 9c 10 00 	movzbl 0x109cb4(%eax),%ecx
  100310:	8d 42 01             	lea    0x1(%edx),%eax
  100313:	a3 34 9d 10 00       	mov    %eax,0x109d34
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
  100338:	c7 04 24 80 9c 10 00 	movl   $0x109c80,(%esp)
  10033f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  100344:	e8 07 41 00 00       	call   104450 <release>
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
  100363:	89 15 34 9d 10 00    	mov    %edx,0x109d34
  100369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10036c:	29 d8                	sub    %ebx,%eax
  10036e:	89 c3                	mov    %eax,%ebx
  100370:	c7 04 24 80 9c 10 00 	movl   $0x109c80,(%esp)
  100377:	e8 d4 40 00 00       	call   104450 <release>
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
  1003a9:	8b 15 60 84 10 00    	mov    0x108460,%edx
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
  1004ca:	e8 c1 40 00 00       	call   104590 <memmove>
  1004cf:	b8 80 07 00 00       	mov    $0x780,%eax
  1004d4:	29 d8                	sub    %ebx,%eax
  1004d6:	01 c0                	add    %eax,%eax
  1004d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004dc:	8d 86 00 80 0b 00    	lea    0xb8000(%esi),%eax
  1004e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1004e9:	00 
  1004ea:	89 04 24             	mov    %eax,(%esp)
  1004ed:	e8 0e 40 00 00       	call   104500 <memset>
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
  100534:	bf b0 9c 10 00       	mov    $0x109cb0,%edi
  100539:	56                   	push   %esi
  10053a:	53                   	push   %ebx
  10053b:	83 ec 0c             	sub    $0xc,%esp
  10053e:	8b 75 08             	mov    0x8(%ebp),%esi
  100541:	c7 04 24 80 9c 10 00 	movl   $0x109c80,(%esp)
  100548:	e8 43 3f 00 00       	call   104490 <acquire>
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
  10058a:	8b 15 3c 9d 10 00    	mov    0x109d3c,%edx
  100590:	89 d0                	mov    %edx,%eax
  100592:	2b 05 34 9d 10 00    	sub    0x109d34,%eax
  100598:	83 f8 7f             	cmp    $0x7f,%eax
  10059b:	77 b3                	ja     100550 <console_intr+0x20>
  10059d:	89 d0                	mov    %edx,%eax
  10059f:	83 e0 7f             	and    $0x7f,%eax
  1005a2:	88 5c 07 04          	mov    %bl,0x4(%edi,%eax,1)
  1005a6:	8d 42 01             	lea    0x1(%edx),%eax
  1005a9:	a3 3c 9d 10 00       	mov    %eax,0x109d3c
  1005ae:	89 1c 24             	mov    %ebx,(%esp)
  1005b1:	e8 ea fd ff ff       	call   1003a0 <cons_putc>
  1005b6:	83 fb 0a             	cmp    $0xa,%ebx
  1005b9:	0f 84 d3 00 00 00    	je     100692 <console_intr+0x162>
  1005bf:	83 fb 04             	cmp    $0x4,%ebx
  1005c2:	0f 84 ca 00 00 00    	je     100692 <console_intr+0x162>
  1005c8:	a1 34 9d 10 00       	mov    0x109d34,%eax
  1005cd:	8b 15 3c 9d 10 00    	mov    0x109d3c,%edx
  1005d3:	83 e8 80             	sub    $0xffffff80,%eax
  1005d6:	39 c2                	cmp    %eax,%edx
  1005d8:	0f 85 72 ff ff ff    	jne    100550 <console_intr+0x20>
  1005de:	89 15 38 9d 10 00    	mov    %edx,0x109d38
  1005e4:	c7 04 24 34 9d 10 00 	movl   $0x109d34,(%esp)
  1005eb:	e8 a0 2d 00 00       	call   103390 <wakeup>
  1005f0:	ff d6                	call   *%esi
  1005f2:	85 c0                	test   %eax,%eax
  1005f4:	89 c3                	mov    %eax,%ebx
  1005f6:	0f 89 60 ff ff ff    	jns    10055c <console_intr+0x2c>
  1005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100600:	c7 45 08 80 9c 10 00 	movl   $0x109c80,0x8(%ebp)
  100607:	83 c4 0c             	add    $0xc,%esp
  10060a:	5b                   	pop    %ebx
  10060b:	5e                   	pop    %esi
  10060c:	5f                   	pop    %edi
  10060d:	5d                   	pop    %ebp
  10060e:	e9 3d 3e 00 00       	jmp    104450 <release>
  100613:	90                   	nop
  100614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100618:	8d 50 ff             	lea    -0x1(%eax),%edx
  10061b:	89 d0                	mov    %edx,%eax
  10061d:	83 e0 7f             	and    $0x7f,%eax
  100620:	80 b8 b4 9c 10 00 0a 	cmpb   $0xa,0x109cb4(%eax)
  100627:	0f 84 23 ff ff ff    	je     100550 <console_intr+0x20>
  10062d:	89 15 3c 9d 10 00    	mov    %edx,0x109d3c
  100633:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10063a:	e8 61 fd ff ff       	call   1003a0 <cons_putc>
  10063f:	a1 3c 9d 10 00       	mov    0x109d3c,%eax
  100644:	3b 05 38 9d 10 00    	cmp    0x109d38,%eax
  10064a:	75 cc                	jne    100618 <console_intr+0xe8>
  10064c:	e9 ff fe ff ff       	jmp    100550 <console_intr+0x20>
  100651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100658:	e8 d3 2b 00 00       	call   103230 <procdump>
  10065d:	8d 76 00             	lea    0x0(%esi),%esi
  100660:	e9 eb fe ff ff       	jmp    100550 <console_intr+0x20>
  100665:	8d 76 00             	lea    0x0(%esi),%esi
  100668:	a1 3c 9d 10 00       	mov    0x109d3c,%eax
  10066d:	3b 05 38 9d 10 00    	cmp    0x109d38,%eax
  100673:	0f 84 d7 fe ff ff    	je     100550 <console_intr+0x20>
  100679:	83 e8 01             	sub    $0x1,%eax
  10067c:	a3 3c 9d 10 00       	mov    %eax,0x109d3c
  100681:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100688:	e8 13 fd ff ff       	call   1003a0 <cons_putc>
  10068d:	e9 be fe ff ff       	jmp    100550 <console_intr+0x20>
  100692:	8b 15 3c 9d 10 00    	mov    0x109d3c,%edx
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
  1006ba:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  1006c1:	e8 ca 3d 00 00       	call   104490 <acquire>
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
  1006e3:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  1006ea:	e8 61 3d 00 00       	call   104450 <release>
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
  10073e:	0f b6 82 b9 65 10 00 	movzbl 0x1065b9(%edx),%eax
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
  1007a9:	a1 64 84 10 00       	mov    0x108464,%eax
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
  100857:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  10085e:	e8 ed 3b 00 00       	call   104450 <release>
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
  100948:	c7 04 24 80 84 10 00 	movl   $0x108480,(%esp)
  10094f:	e8 3c 3b 00 00       	call   104490 <acquire>
  100954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100958:	e9 5c fe ff ff       	jmp    1007b9 <cprintf+0x19>
  10095d:	bb 9f 65 10 00       	mov    $0x10659f,%ebx
  100962:	e9 6c ff ff ff       	jmp    1008d3 <cprintf+0x133>
  100967:	89 f6                	mov    %esi,%esi
  100969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100970 <panic>:
  100970:	55                   	push   %ebp
  100971:	89 e5                	mov    %esp,%ebp
  100973:	53                   	push   %ebx
  100974:	83 ec 44             	sub    $0x44,%esp
  100977:	fa                   	cli    
  100978:	c7 05 64 84 10 00 00 	movl   $0x0,0x108464
  10097f:	00 00 00 
  100982:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
  100985:	e8 a6 1f 00 00       	call   102930 <cpu>
  10098a:	c7 04 24 a6 65 10 00 	movl   $0x1065a6,(%esp)
  100991:	89 44 24 04          	mov    %eax,0x4(%esp)
  100995:	e8 06 fe ff ff       	call   1007a0 <cprintf>
  10099a:	8b 45 08             	mov    0x8(%ebp),%eax
  10099d:	89 04 24             	mov    %eax,(%esp)
  1009a0:	e8 fb fd ff ff       	call   1007a0 <cprintf>
  1009a5:	c7 04 24 f3 69 10 00 	movl   $0x1069f3,(%esp)
  1009ac:	e8 ef fd ff ff       	call   1007a0 <cprintf>
  1009b1:	8d 45 08             	lea    0x8(%ebp),%eax
  1009b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1009b8:	89 04 24             	mov    %eax,(%esp)
  1009bb:	e8 20 39 00 00       	call   1042e0 <getcallerpcs>
  1009c0:	8b 03                	mov    (%ebx),%eax
  1009c2:	83 c3 04             	add    $0x4,%ebx
  1009c5:	c7 04 24 b5 65 10 00 	movl   $0x1065b5,(%esp)
  1009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d0:	e8 cb fd ff ff       	call   1007a0 <cprintf>
  1009d5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1009d8:	39 c3                	cmp    %eax,%ebx
  1009da:	75 e4                	jne    1009c0 <panic+0x50>
  1009dc:	c7 05 60 84 10 00 01 	movl   $0x1,0x108460
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
  100b0b:	e8 d0 3b 00 00       	call   1046e0 <strlen>
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
  100b79:	e8 82 39 00 00       	call   104500 <memset>
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
  100c25:	e8 d6 38 00 00       	call   104500 <memset>
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
  100ca5:	e8 36 3a 00 00       	call   1046e0 <strlen>
  100caa:	83 c0 01             	add    $0x1,%eax
  100cad:	29 c3                	sub    %eax,%ebx
  100caf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb3:	8b 06                	mov    (%esi),%eax
  100cb5:	83 ee 04             	sub    $0x4,%esi
  100cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbc:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  100cc2:	01 d8                	add    %ebx,%eax
  100cc4:	89 04 24             	mov    %eax,(%esp)
  100cc7:	e8 c4 38 00 00       	call   104590 <memmove>
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
  100d49:	e8 52 39 00 00       	call   1046a0 <safestrcpy>
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
  100da8:	e8 63 2c 00 00       	call   103a10 <setupsegs>
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
  100e57:	c7 04 24 ca 65 10 00 	movl   $0x1065ca,(%esp)
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
  100f07:	c7 04 24 d4 65 10 00 	movl   $0x1065d4,(%esp)
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
  100f7a:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  100f81:	e8 0a 35 00 00       	call   104490 <acquire>
  100f86:	8b 43 04             	mov    0x4(%ebx),%eax
  100f89:	85 c0                	test   %eax,%eax
  100f8b:	7e 06                	jle    100f93 <filedup+0x23>
  100f8d:	8b 13                	mov    (%ebx),%edx
  100f8f:	85 d2                	test   %edx,%edx
  100f91:	75 0d                	jne    100fa0 <filedup+0x30>
  100f93:	c7 04 24 dd 65 10 00 	movl   $0x1065dd,(%esp)
  100f9a:	e8 d1 f9 ff ff       	call   100970 <panic>
  100f9f:	90                   	nop
  100fa0:	83 c0 01             	add    $0x1,%eax
  100fa3:	89 43 04             	mov    %eax,0x4(%ebx)
  100fa6:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  100fad:	e8 9e 34 00 00       	call   104450 <release>
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
  100fc7:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  100fce:	e8 bd 34 00 00       	call   104490 <acquire>
  100fd3:	ba 40 9d 10 00       	mov    $0x109d40,%edx
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
  100ffb:	c7 04 c5 40 9d 10 00 	movl   $0x1,0x109d40(,%eax,8)
  101002:	01 00 00 00 
  101006:	c7 83 44 9d 10 00 01 	movl   $0x1,0x109d44(%ebx)
  10100d:	00 00 00 
  101010:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  101017:	e8 34 34 00 00       	call   104450 <release>
  10101c:	8d 83 40 9d 10 00    	lea    0x109d40(%ebx),%eax
  101022:	83 c4 04             	add    $0x4,%esp
  101025:	5b                   	pop    %ebx
  101026:	5d                   	pop    %ebp
  101027:	c3                   	ret    
  101028:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  10102f:	e8 1c 34 00 00       	call   104450 <release>
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
  101052:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  101059:	e8 32 34 00 00       	call   104490 <acquire>
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
  101075:	c7 45 08 a0 a6 10 00 	movl   $0x10a6a0,0x8(%ebp)
  10107c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10107f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101082:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101085:	89 ec                	mov    %ebp,%esp
  101087:	5d                   	pop    %ebp
  101088:	e9 c3 33 00 00       	jmp    104450 <release>
  10108d:	8d 76 00             	lea    0x0(%esi),%esi
  101090:	c7 04 24 e5 65 10 00 	movl   $0x1065e5,(%esp)
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
  1010bf:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  1010c6:	e8 85 33 00 00       	call   104450 <release>
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
  101116:	c7 44 24 04 ef 65 10 	movl   $0x1065ef,0x4(%esp)
  10111d:	00 
  10111e:	c7 04 24 a0 a6 10 00 	movl   $0x10a6a0,(%esp)
  101125:	e8 96 31 00 00       	call   1042c0 <initlock>
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
  10116a:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101171:	e8 1a 33 00 00       	call   104490 <acquire>
  101176:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  10117a:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101181:	e8 ca 32 00 00       	call   104450 <release>
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
  10119a:	bb 74 a7 10 00       	mov    $0x10a774,%ebx
  10119f:	83 ec 0c             	sub    $0xc,%esp
  1011a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1011a5:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  1011ac:	e8 df 32 00 00       	call   104490 <acquire>
  1011b1:	eb 17                	jmp    1011ca <iget+0x3a>
  1011b3:	90                   	nop
  1011b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1011b8:	85 f6                	test   %esi,%esi
  1011ba:	74 44                	je     101200 <iget+0x70>
  1011bc:	83 c3 50             	add    $0x50,%ebx
  1011bf:	81 fb 14 b7 10 00    	cmp    $0x10b714,%ebx
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
  1011e3:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  1011ea:	e8 61 32 00 00       	call   104450 <release>
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
  101209:	81 fb 14 b7 10 00    	cmp    $0x10b714,%ebx
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
  101234:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  10123b:	e8 10 32 00 00       	call   104450 <release>
  101240:	83 c4 0c             	add    $0xc,%esp
  101243:	89 d8                	mov    %ebx,%eax
  101245:	5b                   	pop    %ebx
  101246:	5e                   	pop    %esi
  101247:	5f                   	pop    %edi
  101248:	5d                   	pop    %ebp
  101249:	c3                   	ret    
  10124a:	c7 04 24 fa 65 10 00 	movl   $0x1065fa,(%esp)
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
  101292:	e8 f9 32 00 00       	call   104590 <memmove>
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
  10136b:	c7 04 24 0a 66 10 00 	movl   $0x10660a,(%esp)
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
  101469:	c7 04 24 20 66 10 00 	movl   $0x106620,(%esp)
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
  1014d3:	8b 0c c5 e0 a6 10 00 	mov    0x10a6e0(,%eax,8),%ecx
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
  101569:	e8 22 30 00 00       	call   104590 <memmove>
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
  1015fb:	e8 90 2f 00 00       	call   104590 <memmove>
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
  1016cc:	e8 bf 2e 00 00       	call   104590 <memmove>
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
  10173e:	8b 0c c5 e4 a6 10 00 	mov    0x10a6e4(,%eax,8),%ecx
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
  10177b:	e8 80 2e 00 00       	call   104600 <strncmp>
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
  101822:	e8 d9 2d 00 00       	call   104600 <strncmp>
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
  101888:	c7 04 24 33 66 10 00 	movl   $0x106633,(%esp)
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
  10192b:	e8 d0 2b 00 00       	call   104500 <memset>
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
  101960:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
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
  1019a1:	e8 5a 2b 00 00       	call   104500 <memset>
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
  101a24:	c7 04 24 57 66 10 00 	movl   $0x106657,(%esp)
  101a2b:	e8 40 ef ff ff       	call   100970 <panic>

00101a30 <iput>:
  101a30:	55                   	push   %ebp
  101a31:	89 e5                	mov    %esp,%ebp
  101a33:	57                   	push   %edi
  101a34:	56                   	push   %esi
  101a35:	53                   	push   %ebx
  101a36:	83 ec 0c             	sub    $0xc,%esp
  101a39:	8b 75 08             	mov    0x8(%ebp),%esi
  101a3c:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101a43:	e8 48 2a 00 00       	call   104490 <acquire>
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
  101a81:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101a88:	e8 c3 29 00 00       	call   104450 <release>
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
  101adb:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101ae2:	e8 a9 29 00 00       	call   104490 <acquire>
  101ae7:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
  101aeb:	89 34 24             	mov    %esi,(%esp)
  101aee:	e8 9d 18 00 00       	call   103390 <wakeup>
  101af3:	8b 46 08             	mov    0x8(%esi),%eax
  101af6:	66 90                	xchg   %ax,%ax
  101af8:	83 e8 01             	sub    $0x1,%eax
  101afb:	89 46 08             	mov    %eax,0x8(%esi)
  101afe:	c7 45 08 40 a7 10 00 	movl   $0x10a740,0x8(%ebp)
  101b05:	83 c4 0c             	add    $0xc,%esp
  101b08:	5b                   	pop    %ebx
  101b09:	5e                   	pop    %esi
  101b0a:	5f                   	pop    %edi
  101b0b:	5d                   	pop    %ebp
  101b0c:	e9 3f 29 00 00       	jmp    104450 <release>
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
  101b7d:	c7 04 24 6a 66 10 00 	movl   $0x10666a,(%esp)
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
  101c11:	e8 3a 2a 00 00       	call   104650 <strncpy>
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
  101c47:	c7 04 24 74 66 10 00 	movl   $0x106674,(%esp)
  101c4e:	e8 1d ed ff ff       	call   100970 <panic>
  101c53:	89 04 24             	mov    %eax,(%esp)
  101c56:	e8 d5 fd ff ff       	call   101a30 <iput>
  101c5b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101c60:	eb db                	jmp    101c3d <dirlink+0xad>
  101c62:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  101c65:	31 db                	xor    %ebx,%ebx
  101c67:	eb 93                	jmp    101bfc <dirlink+0x6c>
  101c69:	c7 04 24 81 66 10 00 	movl   $0x106681,(%esp)
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
  101c9b:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101ca2:	e8 e9 27 00 00       	call   104490 <acquire>
  101ca7:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  101cab:	89 1c 24             	mov    %ebx,(%esp)
  101cae:	e8 dd 16 00 00       	call   103390 <wakeup>
  101cb3:	c7 45 08 40 a7 10 00 	movl   $0x10a740,0x8(%ebp)
  101cba:	83 c4 04             	add    $0x4,%esp
  101cbd:	5b                   	pop    %ebx
  101cbe:	5d                   	pop    %ebp
  101cbf:	e9 8c 27 00 00       	jmp    104450 <release>
  101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101cc8:	c7 04 24 89 66 10 00 	movl   $0x106689,(%esp)
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
  101d16:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101d1d:	e8 6e 27 00 00       	call   104490 <acquire>
  101d22:	8b 46 0c             	mov    0xc(%esi),%eax
  101d25:	a8 01                	test   $0x1,%al
  101d27:	74 1e                	je     101d47 <ilock+0x47>
  101d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101d30:	c7 44 24 04 40 a7 10 	movl   $0x10a740,0x4(%esp)
  101d37:	00 
  101d38:	89 34 24             	mov    %esi,(%esp)
  101d3b:	e8 b0 19 00 00       	call   1036f0 <sleep>
  101d40:	8b 46 0c             	mov    0xc(%esi),%eax
  101d43:	a8 01                	test   $0x1,%al
  101d45:	75 e9                	jne    101d30 <ilock+0x30>
  101d47:	83 c8 01             	or     $0x1,%eax
  101d4a:	89 46 0c             	mov    %eax,0xc(%esi)
  101d4d:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101d54:	e8 f7 26 00 00       	call   104450 <release>
  101d59:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101d5d:	74 19                	je     101d78 <ilock+0x78>
  101d5f:	83 c4 10             	add    $0x10,%esp
  101d62:	5b                   	pop    %ebx
  101d63:	5e                   	pop    %esi
  101d64:	5d                   	pop    %ebp
  101d65:	c3                   	ret    
  101d66:	66 90                	xchg   %ax,%ax
  101d68:	c7 04 24 91 66 10 00 	movl   $0x106691,(%esp)
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
  101dd8:	e8 b3 27 00 00       	call   104590 <memmove>
  101ddd:	89 1c 24             	mov    %ebx,(%esp)
  101de0:	e8 1b e2 ff ff       	call   100000 <brelse>
  101de5:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
  101de9:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101dee:	0f 85 6b ff ff ff    	jne    101d5f <ilock+0x5f>
  101df4:	c7 04 24 97 66 10 00 	movl   $0x106697,(%esp)
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
  101e8a:	e8 01 27 00 00       	call   104590 <memmove>
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
  101f19:	e8 72 26 00 00       	call   104590 <memmove>
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
  101fd6:	c7 44 24 04 a6 66 10 	movl   $0x1066a6,0x4(%esp)
  101fdd:	00 
  101fde:	c7 04 24 40 a7 10 00 	movl   $0x10a740,(%esp)
  101fe5:	e8 d6 22 00 00       	call   1042c0 <initlock>
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
  10208f:	c7 04 24 b2 66 10 00 	movl   $0x1066b2,(%esp)
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
  1020c7:	a1 f8 84 10 00       	mov    0x1084f8,%eax
  1020cc:	85 c0                	test   %eax,%eax
  1020ce:	0f 84 88 00 00 00    	je     10215c <ide_rw+0xbc>
  1020d4:	c7 04 24 c0 84 10 00 	movl   $0x1084c0,(%esp)
  1020db:	e8 b0 23 00 00       	call   104490 <acquire>
  1020e0:	a1 f4 84 10 00       	mov    0x1084f4,%eax
  1020e5:	ba f4 84 10 00       	mov    $0x1084f4,%edx
  1020ea:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  1020f1:	85 c0                	test   %eax,%eax
  1020f3:	74 0d                	je     102102 <ide_rw+0x62>
  1020f5:	8d 76 00             	lea    0x0(%esi),%esi
  1020f8:	8d 50 14             	lea    0x14(%eax),%edx
  1020fb:	8b 40 14             	mov    0x14(%eax),%eax
  1020fe:	85 c0                	test   %eax,%eax
  102100:	75 f6                	jne    1020f8 <ide_rw+0x58>
  102102:	89 1a                	mov    %ebx,(%edx)
  102104:	39 1d f4 84 10 00    	cmp    %ebx,0x1084f4
  10210a:	75 14                	jne    102120 <ide_rw+0x80>
  10210c:	eb 2d                	jmp    10213b <ide_rw+0x9b>
  10210e:	66 90                	xchg   %ax,%ax
  102110:	c7 44 24 04 c0 84 10 	movl   $0x1084c0,0x4(%esp)
  102117:	00 
  102118:	89 1c 24             	mov    %ebx,(%esp)
  10211b:	e8 d0 15 00 00       	call   1036f0 <sleep>
  102120:	8b 03                	mov    (%ebx),%eax
  102122:	83 e0 06             	and    $0x6,%eax
  102125:	83 f8 02             	cmp    $0x2,%eax
  102128:	75 e6                	jne    102110 <ide_rw+0x70>
  10212a:	c7 45 08 c0 84 10 00 	movl   $0x1084c0,0x8(%ebp)
  102131:	83 c4 14             	add    $0x14,%esp
  102134:	5b                   	pop    %ebx
  102135:	5d                   	pop    %ebp
  102136:	e9 15 23 00 00       	jmp    104450 <release>
  10213b:	89 d8                	mov    %ebx,%eax
  10213d:	e8 ae fe ff ff       	call   101ff0 <ide_start_request>
  102142:	eb dc                	jmp    102120 <ide_rw+0x80>
  102144:	c7 04 24 c4 66 10 00 	movl   $0x1066c4,(%esp)
  10214b:	e8 20 e8 ff ff       	call   100970 <panic>
  102150:	c7 04 24 d9 66 10 00 	movl   $0x1066d9,(%esp)
  102157:	e8 14 e8 ff ff       	call   100970 <panic>
  10215c:	c7 04 24 ef 66 10 00 	movl   $0x1066ef,(%esp)
  102163:	e8 08 e8 ff ff       	call   100970 <panic>
  102168:	90                   	nop
  102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102170 <ide_intr>:
  102170:	55                   	push   %ebp
  102171:	89 e5                	mov    %esp,%ebp
  102173:	57                   	push   %edi
  102174:	53                   	push   %ebx
  102175:	83 ec 10             	sub    $0x10,%esp
  102178:	c7 04 24 c0 84 10 00 	movl   $0x1084c0,(%esp)
  10217f:	e8 0c 23 00 00       	call   104490 <acquire>
  102184:	8b 1d f4 84 10 00    	mov    0x1084f4,%ebx
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
  1021aa:	a3 f4 84 10 00       	mov    %eax,0x1084f4
  1021af:	74 05                	je     1021b6 <ide_intr+0x46>
  1021b1:	e8 3a fe ff ff       	call   101ff0 <ide_start_request>
  1021b6:	c7 04 24 c0 84 10 00 	movl   $0x1084c0,(%esp)
  1021bd:	e8 8e 22 00 00       	call   104450 <release>
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
  102207:	c7 44 24 04 06 67 10 	movl   $0x106706,0x4(%esp)
  10220e:	00 
  10220f:	c7 04 24 c0 84 10 00 	movl   $0x1084c0,(%esp)
  102216:	e8 a5 20 00 00       	call   1042c0 <initlock>
  10221b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102222:	e8 a9 0b 00 00       	call   102dd0 <pic_enable>
  102227:	a1 e0 bd 10 00       	mov    0x10bde0,%eax
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
  10227a:	c7 05 f8 84 10 00 01 	movl   $0x1,0x1084f8
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
  1022a0:	a1 60 b7 10 00       	mov    0x10b760,%eax
  1022a5:	55                   	push   %ebp
  1022a6:	89 e5                	mov    %esp,%ebp
  1022a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1022ab:	85 c0                	test   %eax,%eax
  1022ad:	53                   	push   %ebx
  1022ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1022b1:	74 1d                	je     1022d0 <ioapic_enable+0x30>
  1022b3:	8b 0d 14 b7 10 00    	mov    0x10b714,%ecx
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
  1022e8:	8b 15 60 b7 10 00    	mov    0x10b760,%edx
  1022ee:	85 d2                	test   %edx,%edx
  1022f0:	74 71                	je     102363 <ioapic_init+0x83>
  1022f2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  1022f9:	00 00 00 
  1022fc:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
  102301:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  102308:	00 00 00 
  10230b:	0f b6 15 64 b7 10 00 	movzbl 0x10b764,%edx
  102312:	c7 05 14 b7 10 00 00 	movl   $0xfec00000,0x10b714
  102319:	00 c0 fe 
  10231c:	c1 e8 10             	shr    $0x10,%eax
  10231f:	0f b6 f0             	movzbl %al,%esi
  102322:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
  102327:	c1 e8 18             	shr    $0x18,%eax
  10232a:	39 c2                	cmp    %eax,%edx
  10232c:	75 42                	jne    102370 <ioapic_init+0x90>
  10232e:	8b 0d 14 b7 10 00    	mov    0x10b714,%ecx
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
  102370:	c7 04 24 0c 67 10 00 	movl   $0x10670c,(%esp)
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
  102393:	c7 04 24 40 67 10 00 	movl   $0x106740,(%esp)
  10239a:	e8 d1 e5 ff ff       	call   100970 <panic>
  10239f:	90                   	nop
  1023a0:	85 f6                	test   %esi,%esi
  1023a2:	7e ef                	jle    102393 <kalloc+0x13>
  1023a4:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  1023ab:	e8 e0 20 00 00       	call   104490 <acquire>
  1023b0:	8b 1d 54 b7 10 00    	mov    0x10b754,%ebx
  1023b6:	85 db                	test   %ebx,%ebx
  1023b8:	74 3e                	je     1023f8 <kalloc+0x78>
  1023ba:	8b 43 04             	mov    0x4(%ebx),%eax
  1023bd:	ba 54 b7 10 00       	mov    $0x10b754,%edx
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
  1023e2:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  1023e9:	e8 62 20 00 00       	call   104450 <release>
  1023ee:	83 c4 10             	add    $0x10,%esp
  1023f1:	89 d8                	mov    %ebx,%eax
  1023f3:	5b                   	pop    %ebx
  1023f4:	5e                   	pop    %esi
  1023f5:	5d                   	pop    %ebp
  1023f6:	c3                   	ret    
  1023f7:	90                   	nop
  1023f8:	31 db                	xor    %ebx,%ebx
  1023fa:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  102401:	e8 4a 20 00 00       	call   104450 <release>
  102406:	c7 04 24 47 67 10 00 	movl   $0x106747,(%esp)
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
  102424:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  10242b:	e8 20 20 00 00       	call   104450 <release>
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
  10245d:	c7 04 24 5e 67 10 00 	movl   $0x10675e,(%esp)
  102464:	e8 07 e5 ff ff       	call   100970 <panic>
  102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102473:	bf 54 b7 10 00       	mov    $0x10b754,%edi
  102478:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10247f:	00 
  102480:	89 1c 24             	mov    %ebx,(%esp)
  102483:	89 44 24 08          	mov    %eax,0x8(%esp)
  102487:	e8 74 20 00 00       	call   104500 <memset>
  10248c:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  102493:	e8 f8 1f 00 00       	call   104490 <acquire>
  102498:	8b 15 54 b7 10 00    	mov    0x10b754,%edx
  10249e:	85 d2                	test   %edx,%edx
  1024a0:	0f 84 82 00 00 00    	je     102528 <kfree+0xe8>
  1024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1024a9:	bf 54 b7 10 00       	mov    $0x10b754,%edi
  1024ae:	8d 34 03             	lea    (%ebx,%eax,1),%esi
  1024b1:	39 d6                	cmp    %edx,%esi
  1024b3:	72 73                	jb     102528 <kfree+0xe8>
  1024b5:	8b 42 04             	mov    0x4(%edx),%eax
  1024b8:	39 d3                	cmp    %edx,%ebx
  1024ba:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  1024bd:	73 61                	jae    102520 <kfree+0xe0>
  1024bf:	39 d6                	cmp    %edx,%esi
  1024c1:	bf 54 b7 10 00       	mov    $0x10b754,%edi
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
  1024e6:	c7 04 24 64 67 10 00 	movl   $0x106764,(%esp)
  1024ed:	e8 7e e4 ff ff       	call   100970 <panic>
  1024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1024f8:	39 d6                	cmp    %edx,%esi
  1024fa:	75 cc                	jne    1024c8 <kfree+0x88>
  1024fc:	03 45 f0             	add    -0x10(%ebp),%eax
  1024ff:	89 43 04             	mov    %eax,0x4(%ebx)
  102502:	8b 06                	mov    (%esi),%eax
  102504:	89 03                	mov    %eax,(%ebx)
  102506:	89 1f                	mov    %ebx,(%edi)
  102508:	c7 45 08 20 b7 10 00 	movl   $0x10b720,0x8(%ebp)
  10250f:	83 c4 1c             	add    $0x1c,%esp
  102512:	5b                   	pop    %ebx
  102513:	5e                   	pop    %esi
  102514:	5f                   	pop    %edi
  102515:	5d                   	pop    %ebp
  102516:	e9 35 1f 00 00       	jmp    104450 <release>
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
  102564:	bb 84 fd 10 00       	mov    $0x10fd84,%ebx
  102569:	83 ec 14             	sub    $0x14,%esp
  10256c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102572:	c7 44 24 04 40 67 10 	movl   $0x106740,0x4(%esp)
  102579:	00 
  10257a:	c7 04 24 20 b7 10 00 	movl   $0x10b720,(%esp)
  102581:	e8 3a 1d 00 00       	call   1042c0 <initlock>
  102586:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10258d:	00 
  10258e:	c7 04 24 76 67 10 00 	movl   $0x106776,(%esp)
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
  1025db:	a1 fc 84 10 00       	mov    0x1084fc,%eax
  1025e0:	a8 40                	test   $0x40,%al
  1025e2:	74 0b                	je     1025ef <kbd_getc+0x3f>
  1025e4:	83 e0 bf             	and    $0xffffffbf,%eax
  1025e7:	80 c9 80             	or     $0x80,%cl
  1025ea:	a3 fc 84 10 00       	mov    %eax,0x1084fc
  1025ef:	0f b6 91 80 68 10 00 	movzbl 0x106880(%ecx),%edx
  1025f6:	0f b6 81 80 67 10 00 	movzbl 0x106780(%ecx),%eax
  1025fd:	0b 05 fc 84 10 00    	or     0x1084fc,%eax
  102603:	31 d0                	xor    %edx,%eax
  102605:	89 c2                	mov    %eax,%edx
  102607:	83 e2 03             	and    $0x3,%edx
  10260a:	a8 08                	test   $0x8,%al
  10260c:	8b 14 95 80 69 10 00 	mov    0x106980(,%edx,4),%edx
  102613:	a3 fc 84 10 00       	mov    %eax,0x1084fc
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
  102640:	8b 15 fc 84 10 00    	mov    0x1084fc,%edx
  102646:	f6 c2 40             	test   $0x40,%dl
  102649:	75 03                	jne    10264e <kbd_getc+0x9e>
  10264b:	83 e1 7f             	and    $0x7f,%ecx
  10264e:	0f b6 81 80 67 10 00 	movzbl 0x106780(%ecx),%eax
  102655:	5d                   	pop    %ebp
  102656:	83 c8 40             	or     $0x40,%eax
  102659:	0f b6 c0             	movzbl %al,%eax
  10265c:	f7 d0                	not    %eax
  10265e:	21 d0                	and    %edx,%eax
  102660:	31 d2                	xor    %edx,%edx
  102662:	a3 fc 84 10 00       	mov    %eax,0x1084fc
  102667:	89 d0                	mov    %edx,%eax
  102669:	c3                   	ret    
  10266a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102670:	31 d2                	xor    %edx,%edx
  102672:	89 d0                	mov    %edx,%eax
  102674:	83 0d fc 84 10 00 40 	orl    $0x40,0x1084fc
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
  1026b0:	8b 15 58 b7 10 00    	mov    0x10b758,%edx
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
  1027a0:	a1 58 b7 10 00       	mov    0x10b758,%eax
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
  1027ea:	8b 1d 58 b7 10 00    	mov    0x10b758,%ebx
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
  10293d:	8b 15 00 85 10 00    	mov    0x108500,%edx
  102943:	8d 42 01             	lea    0x1(%edx),%eax
  102946:	85 d2                	test   %edx,%edx
  102948:	a3 00 85 10 00       	mov    %eax,0x108500
  10294d:	74 19                	je     102968 <cpu+0x38>
  10294f:	8b 15 58 b7 10 00    	mov    0x10b758,%edx
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
  10296d:	c7 04 24 90 69 10 00 	movl   $0x106990,(%esp)
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
  10298c:	c7 04 24 bc 69 10 00 	movl   $0x1069bc,(%esp)
  102993:	89 44 24 04          	mov    %eax,0x4(%esp)
  102997:	e8 04 de ff ff       	call   1007a0 <cprintf>
  10299c:	e8 0f 2e 00 00       	call   1057b0 <idtinit>
  1029a1:	e8 8a ff ff ff       	call   102930 <cpu>
  1029a6:	89 c3                	mov    %eax,%ebx
  1029a8:	e8 c3 01 00 00       	call   102b70 <mp_bcpu>
  1029ad:	39 c3                	cmp    %eax,%ebx
  1029af:	74 0d                	je     1029be <mpmain+0x3e>
  1029b1:	e8 7a ff ff ff       	call   102930 <cpu>
  1029b6:	89 04 24             	mov    %eax,(%esp)
  1029b9:	e8 f2 fc ff ff       	call   1026b0 <lapic_init>
  1029be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1029c5:	e8 46 10 00 00       	call   103a10 <setupsegs>
  1029ca:	e8 61 ff ff ff       	call   102930 <cpu>
  1029cf:	ba 01 00 00 00       	mov    $0x1,%edx
  1029d4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1029da:	8d 88 40 b8 10 00    	lea    0x10b840(%eax),%ecx
  1029e0:	89 d0                	mov    %edx,%eax
  1029e2:	f0 87 01             	lock xchg %eax,(%ecx)
  1029e5:	e8 46 ff ff ff       	call   102930 <cpu>
  1029ea:	c7 04 24 cb 69 10 00 	movl   $0x1069cb,(%esp)
  1029f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f5:	e8 a6 dd ff ff       	call   1007a0 <cprintf>
  1029fa:	e8 f1 11 00 00       	call   103bf0 <scheduler>
  1029ff:	90                   	nop

00102a00 <main>:
  102a00:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102a04:	83 e4 f0             	and    $0xfffffff0,%esp
  102a07:	ff 71 fc             	pushl  -0x4(%ecx)
  102a0a:	b8 84 ed 10 00       	mov    $0x10ed84,%eax
  102a0f:	2d 4e 84 10 00       	sub    $0x10844e,%eax
  102a14:	55                   	push   %ebp
  102a15:	89 e5                	mov    %esp,%ebp
  102a17:	53                   	push   %ebx
  102a18:	51                   	push   %ecx
  102a19:	83 ec 10             	sub    $0x10,%esp
  102a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a27:	00 
  102a28:	c7 04 24 4e 84 10 00 	movl   $0x10844e,(%esp)
  102a2f:	e8 cc 1a 00 00       	call   104500 <memset>
  102a34:	e8 c7 01 00 00       	call   102c00 <mp_init>
  102a39:	e8 32 01 00 00       	call   102b70 <mp_bcpu>
  102a3e:	89 04 24             	mov    %eax,(%esp)
  102a41:	e8 6a fc ff ff       	call   1026b0 <lapic_init>
  102a46:	e8 e5 fe ff ff       	call   102930 <cpu>
  102a4b:	c7 04 24 de 69 10 00 	movl   $0x1069de,(%esp)
  102a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a56:	e8 45 dd ff ff       	call   1007a0 <cprintf>
  102a5b:	e8 40 18 00 00       	call   1042a0 <pinit>
  102a60:	e8 3b d7 ff ff       	call   1001a0 <binit>
  102a65:	8d 76 00             	lea    0x0(%esi),%esi
  102a68:	e8 93 03 00 00       	call   102e00 <pic_init>
  102a6d:	8d 76 00             	lea    0x0(%esi),%esi
  102a70:	e8 6b f8 ff ff       	call   1022e0 <ioapic_init>
  102a75:	8d 76 00             	lea    0x0(%esi),%esi
  102a78:	e8 e3 fa ff ff       	call   102560 <kinit>
  102a7d:	8d 76 00             	lea    0x0(%esi),%esi
  102a80:	e8 db 2f 00 00       	call   105a60 <tvinit>
  102a85:	8d 76 00             	lea    0x0(%esi),%esi
  102a88:	e8 83 e6 ff ff       	call   101110 <fileinit>
  102a8d:	8d 76 00             	lea    0x0(%esi),%esi
  102a90:	e8 3b f5 ff ff       	call   101fd0 <iinit>
  102a95:	8d 76 00             	lea    0x0(%esi),%esi
  102a98:	e8 83 d7 ff ff       	call   100220 <console_init>
  102a9d:	8d 76 00             	lea    0x0(%esi),%esi
  102aa0:	e8 5b f7 ff ff       	call   102200 <ide_init>
  102aa5:	a1 60 b7 10 00       	mov    0x10b760,%eax
  102aaa:	85 c0                	test   %eax,%eax
  102aac:	0f 84 ae 00 00 00    	je     102b60 <main+0x160>
  102ab2:	e8 f9 16 00 00       	call   1041b0 <userinit>
  102ab7:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102abe:	00 
  102abf:	c7 44 24 04 f4 83 10 	movl   $0x1083f4,0x4(%esp)
  102ac6:	00 
  102ac7:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102ace:	e8 bd 1a 00 00       	call   104590 <memmove>
  102ad3:	69 05 e0 bd 10 00 cc 	imul   $0xcc,0x10bde0,%eax
  102ada:	00 00 00 
  102add:	05 80 b7 10 00       	add    $0x10b780,%eax
  102ae2:	3d 80 b7 10 00       	cmp    $0x10b780,%eax
  102ae7:	76 72                	jbe    102b5b <main+0x15b>
  102ae9:	bb 80 b7 10 00       	mov    $0x10b780,%ebx
  102aee:	66 90                	xchg   %ax,%ax
  102af0:	e8 3b fe ff ff       	call   102930 <cpu>
  102af5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102afb:	05 80 b7 10 00       	add    $0x10b780,%eax
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
  102b42:	69 05 e0 bd 10 00 cc 	imul   $0xcc,0x10bde0,%eax
  102b49:	00 00 00 
  102b4c:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102b52:	05 80 b7 10 00       	add    $0x10b780,%eax
  102b57:	39 c3                	cmp    %eax,%ebx
  102b59:	72 95                	jb     102af0 <main+0xf0>
  102b5b:	e8 20 fe ff ff       	call   102980 <mpmain>
  102b60:	e8 eb 2b 00 00       	call   105750 <timer_init>
  102b65:	8d 76 00             	lea    0x0(%esi),%esi
  102b68:	e9 45 ff ff ff       	jmp    102ab2 <main+0xb2>
  102b6d:	90                   	nop
  102b6e:	90                   	nop
  102b6f:	90                   	nop

00102b70 <mp_bcpu>:
  102b70:	a1 04 85 10 00       	mov    0x108504,%eax
  102b75:	55                   	push   %ebp
  102b76:	89 e5                	mov    %esp,%ebp
  102b78:	5d                   	pop    %ebp
  102b79:	2d 80 b7 10 00       	sub    $0x10b780,%eax
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
  102bb0:	c7 44 24 04 f5 69 10 	movl   $0x1069f5,0x4(%esp)
  102bb7:	00 
  102bb8:	89 1c 24             	mov    %ebx,(%esp)
  102bbb:	e8 70 19 00 00       	call   104530 <memcmp>
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
  102c10:	69 05 e0 bd 10 00 cc 	imul   $0xcc,0x10bde0,%eax
  102c17:	00 00 00 
  102c1a:	c1 e1 08             	shl    $0x8,%ecx
  102c1d:	05 80 b7 10 00       	add    $0x10b780,%eax
  102c22:	a3 04 85 10 00       	mov    %eax,0x108504
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
  102c58:	c7 44 24 04 fa 69 10 	movl   $0x1069fa,0x4(%esp)
  102c5f:	00 
  102c60:	89 1c 24             	mov    %ebx,(%esp)
  102c63:	e8 c8 18 00 00       	call   104530 <memcmp>
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
  102cfc:	c7 05 60 b7 10 00 01 	movl   $0x1,0x10b760
  102d03:	00 00 00 
  102d06:	a3 58 b7 10 00       	mov    %eax,0x10b758
  102d0b:	89 75 f0             	mov    %esi,-0x10(%ebp)
  102d0e:	73 5f                	jae    102d6f <mp_init+0x16f>
  102d10:	8b 35 04 85 10 00    	mov    0x108504,%esi
  102d16:	0f b6 02             	movzbl (%edx),%eax
  102d19:	3c 04                	cmp    $0x4,%al
  102d1b:	76 2b                	jbe    102d48 <mp_init+0x148>
  102d1d:	0f b6 c0             	movzbl %al,%eax
  102d20:	89 35 04 85 10 00    	mov    %esi,0x108504
  102d26:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d2a:	c7 04 24 08 6a 10 00 	movl   $0x106a08,(%esp)
  102d31:	e8 6a da ff ff       	call   1007a0 <cprintf>
  102d36:	c7 04 24 ff 69 10 00 	movl   $0x1069ff,(%esp)
  102d3d:	e8 2e dc ff ff       	call   100970 <panic>
  102d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d48:	0f b6 c0             	movzbl %al,%eax
  102d4b:	ff 24 85 2c 6a 10 00 	jmp    *0x106a2c(,%eax,4)
  102d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d58:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102d5c:	83 c2 08             	add    $0x8,%edx
  102d5f:	a2 64 b7 10 00       	mov    %al,0x10b764
  102d64:	39 55 f0             	cmp    %edx,-0x10(%ebp)
  102d67:	77 ad                	ja     102d16 <mp_init+0x116>
  102d69:	89 35 04 85 10 00    	mov    %esi,0x108504
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
  102d98:	8b 1d e0 bd 10 00    	mov    0x10bde0,%ebx
  102d9e:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102da2:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102da8:	88 81 80 b7 10 00    	mov    %al,0x10b780(%ecx)
  102dae:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102db2:	74 06                	je     102dba <mp_init+0x1ba>
  102db4:	8d b1 80 b7 10 00    	lea    0x10b780(%ecx),%esi
  102dba:	8d 43 01             	lea    0x1(%ebx),%eax
  102dbd:	83 c2 14             	add    $0x14,%edx
  102dc0:	a3 e0 bd 10 00       	mov    %eax,0x10bde0
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
  102de2:	66 23 05 c0 7f 10 00 	and    0x107fc0,%ax
  102de9:	66 a3 c0 7f 10 00    	mov    %ax,0x107fc0
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
  102e7e:	0f b7 05 c0 7f 10 00 	movzwl 0x107fc0,%eax
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
  102ec2:	e8 c9 15 00 00       	call   104490 <acquire>
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
  102f0f:	e8 3c 15 00 00       	call   104450 <release>
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
  102f70:	e8 db 14 00 00       	call   104450 <release>
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
  102fa5:	e8 e6 14 00 00       	call   104490 <acquire>
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
  103020:	e8 2b 14 00 00       	call   104450 <release>
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
  103078:	e8 d3 13 00 00       	call   104450 <release>
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
  1030ab:	e8 e0 13 00 00       	call   104490 <acquire>
  1030b0:	85 db                	test   %ebx,%ebx
  1030b2:	74 34                	je     1030e8 <pipeclose+0x58>
  1030b4:	8d 46 0c             	lea    0xc(%esi),%eax
  1030b7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
  1030be:	89 04 24             	mov    %eax,(%esp)
  1030c1:	e8 ca 02 00 00       	call   103390 <wakeup>
  1030c6:	89 3c 24             	mov    %edi,(%esp)
  1030c9:	e8 82 13 00 00       	call   104450 <release>
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
  103192:	c7 44 24 04 40 6a 10 	movl   $0x106a40,0x4(%esp)
  103199:	00 
  10319a:	e8 21 11 00 00       	call   1042c0 <initlock>
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
  103221:	a1 80 ed 10 00       	mov    0x10ed80,%eax
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
  103236:	bb 0c be 10 00       	mov    $0x10be0c,%ebx
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
  103248:	8b 04 85 08 6b 10 00 	mov    0x106b08(,%eax,4),%eax
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
  103264:	c7 04 24 49 6a 10 00 	movl   $0x106a49,(%esp)
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
  103279:	c7 04 24 f3 69 10 00 	movl   $0x1069f3,(%esp)
  103280:	e8 1b d5 ff ff       	call   1007a0 <cprintf>
  103285:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  10328b:	81 fb 0c e5 10 00    	cmp    $0x10e50c,%ebx
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
  1032a1:	b8 45 6a 10 00       	mov    $0x106a45,%eax
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
  1032b7:	e8 24 10 00 00       	call   1042e0 <getcallerpcs>
  1032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1032c0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  1032c3:	85 c0                	test   %eax,%eax
  1032c5:	74 b2                	je     103279 <procdump+0x49>
  1032c7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[j]);
  1032ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032ce:	c7 04 24 b5 65 10 00 	movl   $0x1065b5,(%esp)
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
  10330a:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103311:	e8 7a 11 00 00       	call   104490 <acquire>
  for(p = proc; p < &proc[NPROC]; p++){
  103316:	b8 00 e5 10 00       	mov    $0x10e500,%eax
  10331b:	3d 00 be 10 00       	cmp    $0x10be00,%eax
  103320:	76 56                	jbe    103378 <kill+0x78>
    if(p->pid == pid){
  103322:	39 1d 10 be 10 00    	cmp    %ebx,0x10be10

// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  103328:	b8 00 be 10 00       	mov    $0x10be00,%eax
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
  103335:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
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
  10334e:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103355:	e8 f6 10 00 00       	call   104450 <release>
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
  103378:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  10337f:	e8 cc 10 00 00       	call   104450 <release>
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
  10339a:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1033a1:	e8 ea 10 00 00       	call   104490 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1033a6:	b8 00 e5 10 00       	mov    $0x10e500,%eax
  1033ab:	3d 00 be 10 00       	cmp    $0x10be00,%eax
  1033b0:	76 3e                	jbe    1033f0 <wakeup+0x60>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1033b2:	b8 00 be 10 00       	mov    $0x10be00,%eax
  1033b7:	eb 13                	jmp    1033cc <wakeup+0x3c>
  1033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1033c0:	05 9c 00 00 00       	add    $0x9c,%eax
  1033c5:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
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
  1033e3:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
  1033e8:	75 e2                	jne    1033cc <wakeup+0x3c>
  1033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1033f0:	c7 45 08 00 e5 10 00 	movl   $0x10e500,0x8(%ebp)
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
  1033fc:	e9 4f 10 00 00       	jmp    104450 <release>
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
  103414:	bb 00 be 10 00       	mov    $0x10be00,%ebx
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
  10341c:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103423:	e8 68 10 00 00       	call   104490 <acquire>
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
  103436:	81 fb 00 e5 10 00    	cmp    $0x10e500,%ebx
  10343c:	74 32                	je     103470 <allocproc+0x60>
    p = &proc[i];
    if(p->state == UNUSED){
  10343e:	8b 43 0c             	mov    0xc(%ebx),%eax
  103441:	85 c0                	test   %eax,%eax
  103443:	75 eb                	jne    103430 <allocproc+0x20>
      p->state = EMBRYO;
      p->pid = nextpid++;
  103445:	a1 c4 7f 10 00       	mov    0x107fc4,%eax

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10344a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      p->pid = nextpid++;
  103451:	89 43 10             	mov    %eax,0x10(%ebx)
  103454:	83 c0 01             	add    $0x1,%eax
  103457:	a3 c4 7f 10 00       	mov    %eax,0x107fc4
      release(&proc_table_lock);
  10345c:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103463:	e8 e8 0f 00 00       	call   104450 <release>
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
  103472:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103479:	e8 d2 0f 00 00       	call   104450 <release>
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
  103497:	e8 24 0f 00 00       	call   1043c0 <pushcli>
  p = cpus[cpu()].curproc;
  10349c:	e8 8f f4 ff ff       	call   102930 <cpu>
  1034a1:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1034a7:	8b 98 84 b7 10 00    	mov    0x10b784(%eax),%ebx
  popcli();
  1034ad:	e8 8e 0e 00 00       	call   104340 <popcli>
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
  1034c6:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1034cd:	e8 7e 0f 00 00       	call   104450 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1034d2:	e8 b9 ff ff ff       	call   103490 <curproc>
  1034d7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1034dd:	89 04 24             	mov    %eax,(%esp)
  1034e0:	e8 b7 22 00 00       	call   10579c <forkret1>
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
  103509:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103510:	e8 fb 0e 00 00       	call   104410 <holding>
  103515:	85 c0                	test   %eax,%eax
  103517:	74 59                	je     103572 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103519:	e8 12 f4 ff ff       	call   102930 <cpu>
  10351e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103524:	83 b8 44 b8 10 00 01 	cmpl   $0x1,0x10b844(%eax)
  10352b:	75 39                	jne    103566 <sched+0x76>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10352d:	e8 fe f3 ff ff       	call   102930 <cpu>
  103532:	89 c3                	mov    %eax,%ebx
  103534:	e8 57 ff ff ff       	call   103490 <curproc>
  103539:	69 db cc 00 00 00    	imul   $0xcc,%ebx,%ebx
  10353f:	81 c3 88 b7 10 00    	add    $0x10b788,%ebx
  103545:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103549:	83 c0 64             	add    $0x64,%eax
  10354c:	89 04 24             	mov    %eax,(%esp)
  10354f:	e8 a8 11 00 00       	call   1046fc <swtch>
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
  10355a:	c7 04 24 52 6a 10 00 	movl   $0x106a52,(%esp)
  103561:	e8 0a d4 ff ff       	call   100970 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  103566:	c7 04 24 8a 6a 10 00 	movl   $0x106a8a,(%esp)
  10356d:	e8 fe d3 ff ff       	call   100970 <panic>
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103572:	c7 04 24 74 6a 10 00 	movl   $0x106a74,(%esp)
  103579:	e8 f2 d3 ff ff       	call   100970 <panic>
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  if(cp->state == RUNNING)
    panic("sched running");
  10357e:	c7 04 24 66 6a 10 00 	movl   $0x106a66,(%esp)
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
  10359f:	3b 05 08 85 10 00    	cmp    0x108508,%eax
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
  1035ff:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103606:	e8 85 0e 00 00       	call   104490 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10360b:	e8 80 fe ff ff       	call   103490 <curproc>
  103610:	8b 50 14             	mov    0x14(%eax),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103613:	b8 00 e5 10 00       	mov    $0x10e500,%eax
  103618:	3d 00 be 10 00       	cmp    $0x10be00,%eax
  10361d:	0f 86 95 00 00 00    	jbe    1036b8 <exit+0x128>

// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
  103623:	b8 00 be 10 00       	mov    $0x10be00,%eax
  103628:	eb 12                	jmp    10363c <exit+0xac>
  10362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103630:	05 9c 00 00 00       	add    $0x9c,%eax
  103635:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
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
  103653:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
  103658:	75 e2                	jne    10363c <exit+0xac>
  10365a:	bb 00 be 10 00       	mov    $0x10be00,%ebx
  10365f:	eb 15                	jmp    103676 <exit+0xe6>
  103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103668:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  10366e:	81 fb 00 e5 10 00    	cmp    $0x10e500,%ebx
  103674:	74 42                	je     1036b8 <exit+0x128>
    if(p->parent == cp){
  103676:	8b 73 14             	mov    0x14(%ebx),%esi
  103679:	e8 12 fe ff ff       	call   103490 <curproc>
  10367e:	39 c6                	cmp    %eax,%esi
  103680:	75 e6                	jne    103668 <exit+0xd8>
      p->parent = initproc;
  103682:	8b 15 08 85 10 00    	mov    0x108508,%edx
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
  103691:	b8 00 be 10 00       	mov    $0x10be00,%eax
  103696:	eb 0c                	jmp    1036a4 <exit+0x114>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103698:	05 9c 00 00 00       	add    $0x9c,%eax
  10369d:	3d 00 e5 10 00       	cmp    $0x10e500,%eax
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
  1036d5:	c7 04 24 a3 6a 10 00 	movl   $0x106aa3,(%esp)
  1036dc:	e8 8f d2 ff ff       	call   100970 <panic>
{
  struct proc *p;
  int fd;

  if(cp == initproc)
    panic("init exiting");
  1036e1:	c7 04 24 96 6a 10 00 	movl   $0x106a96,(%esp)
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
  103713:	81 fb 00 e5 10 00    	cmp    $0x10e500,%ebx
  103719:	74 55                	je     103770 <sleep+0x80>
    acquire(&proc_table_lock);
  10371b:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103722:	e8 69 0d 00 00       	call   104490 <acquire>
    release(lk);
  103727:	89 1c 24             	mov    %ebx,(%esp)
  10372a:	e8 21 0d 00 00       	call   104450 <release>
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
  103754:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  10375b:	e8 f0 0c 00 00       	call   104450 <release>
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
  103769:	e9 22 0d 00 00       	jmp    104490 <acquire>
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
  10379c:	c7 04 24 b5 6a 10 00 	movl   $0x106ab5,(%esp)
  1037a3:	e8 c8 d1 ff ff       	call   100970 <panic>
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1037a8:	c7 04 24 af 6a 10 00 	movl   $0x106aaf,(%esp)
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
  1037cd:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1037d4:	e8 b7 0c 00 00       	call   104490 <acquire>
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
  1037fd:	c7 44 24 04 00 e5 10 	movl   $0x10e500,0x4(%esp)
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
  103813:	81 c6 00 be 10 00    	add    $0x10be00,%esi
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
  103858:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  10385f:	e8 ec 0b 00 00       	call   104450 <release>
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
          kfree(p->kstack, KSTACKSIZE);
  103871:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103878:	00 
  103879:	8b 46 08             	mov    0x8(%esi),%eax
  10387c:	89 04 24             	mov    %eax,(%esp)
  10387f:	e8 bc eb ff ff       	call   102440 <kfree>
          pid = p->pid;
  103884:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103887:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10388e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103895:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  10389c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1038a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1038a6:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1038ad:	e8 9e 0b 00 00       	call   104450 <release>
          return pid;
  1038b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038b5:	eb b2                	jmp    103869 <wait_thread+0xa9>
  1038b7:	89 f6                	mov    %esi,%esi
  1038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001038c0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
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
wait(void)
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
wait(void)
{
  1038ca:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  1038cd:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1038d4:	e8 b7 0b 00 00       	call   104490 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  1038d9:	83 fb 3f             	cmp    $0x3f,%ebx
  1038dc:	7e 2f                	jle    10390d <wait+0x4d>
  1038de:	66 90                	xchg   %ax,%ax
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  1038e0:	85 ff                	test   %edi,%edi
  1038e2:	74 74                	je     103958 <wait+0x98>
  1038e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038e8:	e8 a3 fb ff ff       	call   103490 <curproc>
  1038ed:	8b 50 1c             	mov    0x1c(%eax),%edx
  1038f0:	85 d2                	test   %edx,%edx
  1038f2:	75 64                	jne    103958 <wait+0x98>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  1038f4:	e8 97 fb ff ff       	call   103490 <curproc>
  1038f9:	31 ff                	xor    %edi,%edi
  1038fb:	31 db                	xor    %ebx,%ebx
  1038fd:	c7 44 24 04 00 e5 10 	movl   $0x10e500,0x4(%esp)
  103904:	00 
  103905:	89 04 24             	mov    %eax,(%esp)
  103908:	e8 e3 fd ff ff       	call   1036f0 <sleep>
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  10390d:	69 f3 9c 00 00 00    	imul   $0x9c,%ebx,%esi
  103913:	81 c6 00 be 10 00    	add    $0x10be00,%esi
      if(p->state == UNUSED)
  103919:	8b 4e 0c             	mov    0xc(%esi),%ecx
  10391c:	85 c9                	test   %ecx,%ecx
  10391e:	75 10                	jne    103930 <wait+0x70>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103920:	83 c3 01             	add    $0x1,%ebx
  103923:	83 fb 3f             	cmp    $0x3f,%ebx
  103926:	7e e5                	jle    10390d <wait+0x4d>
  103928:	eb b6                	jmp    1038e0 <wait+0x20>
  10392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103930:	8b 46 14             	mov    0x14(%esi),%eax
  103933:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103936:	e8 55 fb ff ff       	call   103490 <curproc>
  10393b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10393e:	66 90                	xchg   %ax,%ax
  103940:	75 de                	jne    103920 <wait+0x60>
        if(p->state == ZOMBIE){
  103942:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103946:	74 29                	je     103971 <wait+0xb1>
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103948:	bf 01 00 00 00       	mov    $0x1,%edi
  10394d:	8d 76 00             	lea    0x0(%esi),%esi
  103950:	eb ce                	jmp    103920 <wait+0x60>
  103952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103958:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  10395f:	e8 ec 0a 00 00       	call   104450 <release>
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
          kfree(p->mem, p->sz);
  103971:	8b 46 04             	mov    0x4(%esi),%eax
  103974:	89 44 24 04          	mov    %eax,0x4(%esp)
  103978:	8b 06                	mov    (%esi),%eax
  10397a:	89 04 24             	mov    %eax,(%esp)
  10397d:	e8 be ea ff ff       	call   102440 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103982:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103989:	00 
  10398a:	8b 46 08             	mov    0x8(%esi),%eax
  10398d:	89 04 24             	mov    %eax,(%esp)
  103990:	e8 ab ea ff ff       	call   102440 <kfree>
          pid = p->pid;
  103995:	8b 46 10             	mov    0x10(%esi),%eax
          p->state = UNUSED;
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
  103998:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
          kfree(p->kstack, KSTACKSIZE);
          pid = p->pid;
          p->state = UNUSED;
  10399f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  1039a6:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  1039ad:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
          release(&proc_table_lock);
  1039b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1039b7:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1039be:	e8 8d 0a 00 00       	call   104450 <release>
          return pid;
  1039c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1039c6:	eb a1                	jmp    103969 <wait+0xa9>
  1039c8:	90                   	nop
  1039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001039d0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1039d0:	55                   	push   %ebp
  1039d1:	89 e5                	mov    %esp,%ebp
  1039d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&proc_table_lock);
  1039d6:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1039dd:	e8 ae 0a 00 00       	call   104490 <acquire>
  cp->state = RUNNABLE;
  1039e2:	e8 a9 fa ff ff       	call   103490 <curproc>
  1039e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1039ee:	e8 fd fa ff ff       	call   1034f0 <sched>
  release(&proc_table_lock);
  1039f3:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1039fa:	e8 51 0a 00 00       	call   104450 <release>
}
  1039ff:	c9                   	leave  
  103a00:	c3                   	ret    
  103a01:	eb 0d                	jmp    103a10 <setupsegs>
  103a03:	90                   	nop
  103a04:	90                   	nop
  103a05:	90                   	nop
  103a06:	90                   	nop
  103a07:	90                   	nop
  103a08:	90                   	nop
  103a09:	90                   	nop
  103a0a:	90                   	nop
  103a0b:	90                   	nop
  103a0c:	90                   	nop
  103a0d:	90                   	nop
  103a0e:	90                   	nop
  103a0f:	90                   	nop

00103a10 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103a10:	55                   	push   %ebp
  103a11:	89 e5                	mov    %esp,%ebp
  103a13:	57                   	push   %edi
  103a14:	56                   	push   %esi
  103a15:	53                   	push   %ebx
  103a16:	83 ec 2c             	sub    $0x2c,%esp
  103a19:	8b 75 08             	mov    0x8(%ebp),%esi
  struct cpu *c;
  
  pushcli();
  103a1c:	e8 9f 09 00 00       	call   1043c0 <pushcli>
  c = &cpus[cpu()];
  103a21:	e8 0a ef ff ff       	call   102930 <cpu>
  103a26:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103a2c:	05 80 b7 10 00       	add    $0x10b780,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  103a31:	85 f6                	test   %esi,%esi
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  103a33:	66 c7 40 30 10 00    	movw   $0x10,0x30(%eax)
  if(p)
  103a39:	0f 84 a1 01 00 00    	je     103be0 <setupsegs+0x1d0>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  103a3f:	8b 56 08             	mov    0x8(%esi),%edx
  103a42:	81 c2 00 10 00 00    	add    $0x1000,%edx
  103a48:	89 50 2c             	mov    %edx,0x2c(%eax)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103a4b:	8d 50 28             	lea    0x28(%eax),%edx
  103a4e:	89 d1                	mov    %edx,%ecx
  103a50:	c1 e9 10             	shr    $0x10,%ecx
  103a53:	66 89 90 ba 00 00 00 	mov    %dx,0xba(%eax)
  103a5a:	c1 ea 18             	shr    $0x18,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  103a5d:	85 f6                	test   %esi,%esi
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103a5f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
  103a66:	00 00 00 
  103a69:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
  103a70:	00 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  103a73:	66 c7 80 98 00 00 00 	movw   $0x10f,0x98(%eax)
  103a7a:	0f 01 
  103a7c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  103a83:	00 00 
  103a85:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  103a8c:	c6 80 9d 00 00 00 9a 	movb   $0x9a,0x9d(%eax)
  103a93:	c6 80 9e 00 00 00 c0 	movb   $0xc0,0x9e(%eax)
  103a9a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  103aa1:	66 c7 80 a0 00 00 00 	movw   $0xffff,0xa0(%eax)
  103aa8:	ff ff 
  103aaa:	66 c7 80 a2 00 00 00 	movw   $0x0,0xa2(%eax)
  103ab1:	00 00 
  103ab3:	c6 80 a4 00 00 00 00 	movb   $0x0,0xa4(%eax)
  103aba:	c6 80 a5 00 00 00 92 	movb   $0x92,0xa5(%eax)
  103ac1:	c6 80 a6 00 00 00 cf 	movb   $0xcf,0xa6(%eax)
  103ac8:	c6 80 a7 00 00 00 00 	movb   $0x0,0xa7(%eax)
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  103acf:	66 c7 80 b8 00 00 00 	movw   $0x67,0xb8(%eax)
  103ad6:	67 00 
  103ad8:	88 88 bc 00 00 00    	mov    %cl,0xbc(%eax)
  103ade:	c6 80 be 00 00 00 40 	movb   $0x40,0xbe(%eax)
  103ae5:	88 90 bf 00 00 00    	mov    %dl,0xbf(%eax)
  c->gdt[SEG_TSS].s = 0;
  103aeb:	c6 80 bd 00 00 00 89 	movb   $0x89,0xbd(%eax)
  if(p){
  103af2:	0f 84 b8 00 00 00    	je     103bb0 <setupsegs+0x1a0>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103af8:	8b 16                	mov    (%esi),%edx
  103afa:	8b 5e 04             	mov    0x4(%esi),%ebx
  103afd:	89 d6                	mov    %edx,%esi
  103aff:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  103b02:	89 d3                	mov    %edx,%ebx
  103b04:	c1 ee 10             	shr    $0x10,%esi
  103b07:	89 cf                	mov    %ecx,%edi
  103b09:	c1 eb 18             	shr    $0x18,%ebx
  103b0c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  103b0f:	89 f3                	mov    %esi,%ebx
  103b11:	88 98 ac 00 00 00    	mov    %bl,0xac(%eax)
  103b17:	89 cb                	mov    %ecx,%ebx
  103b19:	c1 eb 1c             	shr    $0x1c,%ebx
  103b1c:	89 d9                	mov    %ebx,%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b1e:	83 cb c0             	or     $0xffffffc0,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b21:	83 c9 c0             	or     $0xffffffc0,%ecx
  103b24:	c6 80 ad 00 00 00 fa 	movb   $0xfa,0xad(%eax)
  103b2b:	c1 ef 0c             	shr    $0xc,%edi
  103b2e:	88 88 ae 00 00 00    	mov    %cl,0xae(%eax)
  103b34:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b38:	c6 80 b5 00 00 00 f2 	movb   $0xf2,0xb5(%eax)
  103b3f:	88 98 b6 00 00 00    	mov    %bl,0xb6(%eax)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b45:	66 89 90 aa 00 00 00 	mov    %dx,0xaa(%eax)
  103b4c:	88 88 af 00 00 00    	mov    %cl,0xaf(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b52:	0f b6 4d d4          	movzbl -0x2c(%ebp),%ecx
  103b56:	66 89 90 b2 00 00 00 	mov    %dx,0xb2(%eax)
  103b5d:	89 f2                	mov    %esi,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103b5f:	66 89 b8 a8 00 00 00 	mov    %di,0xa8(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103b66:	66 89 b8 b0 00 00 00 	mov    %di,0xb0(%eax)
  103b6d:	88 90 b4 00 00 00    	mov    %dl,0xb4(%eax)
  103b73:	88 88 b7 00 00 00    	mov    %cl,0xb7(%eax)
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  103b79:	05 90 00 00 00       	add    $0x90,%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103b7e:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
  103b84:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
  103b88:	c1 e8 10             	shr    $0x10,%eax
  103b8b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  103b8f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103b92:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103b95:	b8 28 00 00 00       	mov    $0x28,%eax
  103b9a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  popcli();
  103b9d:	e8 9e 07 00 00       	call   104340 <popcli>
}
  103ba2:	83 c4 2c             	add    $0x2c,%esp
  103ba5:	5b                   	pop    %ebx
  103ba6:	5e                   	pop    %esi
  103ba7:	5f                   	pop    %edi
  103ba8:	5d                   	pop    %ebp
  103ba9:	c3                   	ret    
  103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103bb0:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
  103bb7:	00 00 00 
  103bba:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
  103bc1:	00 00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  103bc4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  103bcb:	00 00 00 
  103bce:	c7 80 b4 00 00 00 00 	movl   $0x0,0xb4(%eax)
  103bd5:	00 00 00 
  103bd8:	eb 9f                	jmp    103b79 <setupsegs+0x169>
  103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103be0:	c7 40 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%eax)
  103be7:	e9 5f fe ff ff       	jmp    103a4b <setupsegs+0x3b>
  103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103bf0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103bf0:	55                   	push   %ebp
  103bf1:	89 e5                	mov    %esp,%ebp
  103bf3:	57                   	push   %edi
  103bf4:	56                   	push   %esi
  103bf5:	53                   	push   %ebx
  103bf6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103bf9:	e8 32 ed ff ff       	call   102930 <cpu>
  103bfe:	69 d8 cc 00 00 00    	imul   $0xcc,%eax,%ebx
  103c04:	81 c3 80 b7 10 00    	add    $0x10b780,%ebx
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103c0a:	8d 73 08             	lea    0x8(%ebx),%esi
  103c0d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103c10:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103c11:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103c18:	e8 73 08 00 00       	call   104490 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103c1d:	83 3d 10 be 10 00 01 	cmpl   $0x1,0x10be10
  103c24:	0f 84 c6 00 00 00    	je     103cf0 <scheduler+0x100>
  103c2a:	31 d2                	xor    %edx,%edx
  103c2c:	31 c0                	xor    %eax,%eax
  103c2e:	eb 0e                	jmp    103c3e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c30:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103c36:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103c3c:	74 1d                	je     103c5b <scheduler+0x6b>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103c3e:	83 ba 0c be 10 00 03 	cmpl   $0x3,0x10be0c(%edx)
  103c45:	75 e9                	jne    103c30 <scheduler+0x40>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c47:	03 82 98 be 10 00    	add    0x10be98(%edx),%eax
  103c4d:	81 c2 9c 00 00 00    	add    $0x9c,%edx
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103c53:	81 fa 00 27 00 00    	cmp    $0x2700,%edx
  103c59:	75 e3                	jne    103c3e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103c5b:	85 c0                	test   %eax,%eax
  103c5d:	74 16                	je     103c75 <scheduler+0x85>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103c5f:	8b 3d 80 ed 10 00    	mov    0x10ed80,%edi
  103c65:	89 c1                	mov    %eax,%ecx
  103c67:	c1 e7 08             	shl    $0x8,%edi
  103c6a:	89 fa                	mov    %edi,%edx
  103c6c:	89 f8                	mov    %edi,%eax
  103c6e:	c1 fa 1f             	sar    $0x1f,%edx
  103c71:	f7 f9                	idiv   %ecx
  103c73:	89 d7                	mov    %edx,%edi
  103c75:	b8 0c be 10 00       	mov    $0x10be0c,%eax
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c7a:	31 d2                	xor    %edx,%edx
  103c7c:	eb 12                	jmp    103c90 <scheduler+0xa0>
  103c7e:	66 90                	xchg   %ax,%ax
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c80:	39 fa                	cmp    %edi,%edx
  103c82:	7f 1e                	jg     103ca2 <scheduler+0xb2>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103c84:	05 9c 00 00 00       	add    $0x9c,%eax
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103c89:	3d 0c e5 10 00       	cmp    $0x10e50c,%eax
  103c8e:	74 4c                	je     103cdc <scheduler+0xec>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c90:	83 38 03             	cmpl   $0x3,(%eax)
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103c93:	8d 48 f4             	lea    -0xc(%eax),%ecx
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103c96:	75 e8                	jne    103c80 <scheduler+0x90>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103c98:	03 90 8c 00 00 00    	add    0x8c(%eax),%edx
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103c9e:	39 fa                	cmp    %edi,%edx
  103ca0:	7e e2                	jle    103c84 <scheduler+0x94>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103ca2:	89 4b 04             	mov    %ecx,0x4(%ebx)
    	  setupsegs(p);
  103ca5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  103ca8:	89 0c 24             	mov    %ecx,(%esp)
  103cab:	e8 60 fd ff ff       	call   103a10 <setupsegs>
    	  p->state = RUNNING;
  103cb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  103cb3:	c7 41 0c 04 00 00 00 	movl   $0x4,0xc(%ecx)
    	  swtch(&c->context, &p->context);
  103cba:	83 c1 64             	add    $0x64,%ecx
  103cbd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103cc1:	89 34 24             	mov    %esi,(%esp)
  103cc4:	e8 33 0a 00 00       	call   1046fc <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103cc9:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	  setupsegs(0);
  103cd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103cd7:	e8 34 fd ff ff       	call   103a10 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103cdc:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103ce3:	e8 68 07 00 00       	call   104450 <release>
  103ce8:	e9 23 ff ff ff       	jmp    103c10 <scheduler+0x20>
  103ced:	8d 76 00             	lea    0x0(%esi),%esi
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103cf0:	83 3d 0c be 10 00 03 	cmpl   $0x3,0x10be0c
  103cf7:	0f 85 2d ff ff ff    	jne    103c2a <scheduler+0x3a>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103cfd:	c7 43 04 00 be 10 00 	movl   $0x10be00,0x4(%ebx)
      setupsegs(p);
  103d04:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  103d0b:	e8 00 fd ff ff       	call   103a10 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103d10:	c7 44 24 04 64 be 10 	movl   $0x10be64,0x4(%esp)
  103d17:	00 
  103d18:	89 34 24             	mov    %esi,(%esp)
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103d1b:	c7 05 98 be 10 00 4b 	movl   $0x4b,0x10be98
  103d22:	00 00 00 
      p->state = RUNNING;
  103d25:	c7 05 0c be 10 00 04 	movl   $0x4,0x10be0c
  103d2c:	00 00 00 
      swtch(&c->context, &p->context);
  103d2f:	e8 c8 09 00 00       	call   1046fc <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103d34:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
      setupsegs(0);
  103d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103d42:	e8 c9 fc ff ff       	call   103a10 <setupsegs>
      release(&proc_table_lock);
  103d47:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  103d4e:	e8 fd 06 00 00       	call   104450 <release>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d53:	e9 b8 fe ff ff       	jmp    103c10 <scheduler+0x20>
  103d58:	90                   	nop
  103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103d60 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103d60:	55                   	push   %ebp
  103d61:	89 e5                	mov    %esp,%ebp
  103d63:	57                   	push   %edi
  103d64:	56                   	push   %esi
  103d65:	53                   	push   %ebx
  103d66:	83 ec 1c             	sub    $0x1c,%esp
  103d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103d6c:	e8 1f f7 ff ff       	call   103490 <curproc>
  103d71:	8b 50 04             	mov    0x4(%eax),%edx
  103d74:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  103d77:	89 04 24             	mov    %eax,(%esp)
  103d7a:	e8 01 e6 ff ff       	call   102380 <kalloc>
  103d7f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103d86:	85 f6                	test   %esi,%esi
  103d88:	74 7f                	je     103e09 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103d8a:	e8 01 f7 ff ff       	call   103490 <curproc>
  103d8f:	8b 78 04             	mov    0x4(%eax),%edi
  103d92:	e8 f9 f6 ff ff       	call   103490 <curproc>
  103d97:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103d9b:	8b 00                	mov    (%eax),%eax
  103d9d:	89 34 24             	mov    %esi,(%esp)
  103da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103da4:	e8 e7 07 00 00       	call   104590 <memmove>
  memset(newmem + cp->sz, 0, n);
  103da9:	e8 e2 f6 ff ff       	call   103490 <curproc>
  103dae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103db2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103db9:	00 
  103dba:	8b 50 04             	mov    0x4(%eax),%edx
  103dbd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103dc0:	89 04 24             	mov    %eax,(%esp)
  103dc3:	e8 38 07 00 00       	call   104500 <memset>
  kfree(cp->mem, cp->sz);
  103dc8:	e8 c3 f6 ff ff       	call   103490 <curproc>
  103dcd:	8b 78 04             	mov    0x4(%eax),%edi
  103dd0:	e8 bb f6 ff ff       	call   103490 <curproc>
  103dd5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103dd9:	8b 00                	mov    (%eax),%eax
  103ddb:	89 04 24             	mov    %eax,(%esp)
  103dde:	e8 5d e6 ff ff       	call   102440 <kfree>
  cp->mem = newmem;
  103de3:	e8 a8 f6 ff ff       	call   103490 <curproc>
  103de8:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103dea:	e8 a1 f6 ff ff       	call   103490 <curproc>
  103def:	01 58 04             	add    %ebx,0x4(%eax)
  setupsegs(cp);
  103df2:	e8 99 f6 ff ff       	call   103490 <curproc>
  103df7:	89 04 24             	mov    %eax,(%esp)
  103dfa:	e8 11 fc ff ff       	call   103a10 <setupsegs>
  return cp->sz - n;
  103dff:	e8 8c f6 ff ff       	call   103490 <curproc>
  103e04:	8b 40 04             	mov    0x4(%eax),%eax
  103e07:	29 d8                	sub    %ebx,%eax
}
  103e09:	83 c4 1c             	add    $0x1c,%esp
  103e0c:	5b                   	pop    %ebx
  103e0d:	5e                   	pop    %esi
  103e0e:	5f                   	pop    %edi
  103e0f:	5d                   	pop    %ebp
  103e10:	c3                   	ret    
  103e11:	eb 0d                	jmp    103e20 <copyproc_tix>
  103e13:	90                   	nop
  103e14:	90                   	nop
  103e15:	90                   	nop
  103e16:	90                   	nop
  103e17:	90                   	nop
  103e18:	90                   	nop
  103e19:	90                   	nop
  103e1a:	90                   	nop
  103e1b:	90                   	nop
  103e1c:	90                   	nop
  103e1d:	90                   	nop
  103e1e:	90                   	nop
  103e1f:	90                   	nop

00103e20 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103e20:	55                   	push   %ebp
  103e21:	89 e5                	mov    %esp,%ebp
  103e23:	57                   	push   %edi
  103e24:	56                   	push   %esi
  103e25:	53                   	push   %ebx
  103e26:	83 ec 1c             	sub    $0x1c,%esp
  103e29:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103e2c:	e8 df f5 ff ff       	call   103410 <allocproc>
  103e31:	85 c0                	test   %eax,%eax
  103e33:	89 c6                	mov    %eax,%esi
  103e35:	0f 84 e1 00 00 00    	je     103f1c <copyproc_tix+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103e3b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103e42:	e8 39 e5 ff ff       	call   102380 <kalloc>
  103e47:	85 c0                	test   %eax,%eax
  103e49:	89 46 08             	mov    %eax,0x8(%esi)
  103e4c:	0f 84 d4 00 00 00    	je     103f26 <copyproc_tix+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e52:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103e57:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103e59:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103e5f:	0f 84 85 00 00 00    	je     103eea <copyproc_tix+0xca>
    np->parent = p;
    np->num_tix = tix;;
  103e65:	8b 55 0c             	mov    0xc(%ebp),%edx
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103e68:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103e6b:	89 96 98 00 00 00    	mov    %edx,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103e71:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103e78:	00 
  103e79:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103e7f:	89 04 24             	mov    %eax,(%esp)
  103e82:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e86:	e8 05 07 00 00       	call   104590 <memmove>
  
    np->sz = p->sz;
  103e8b:	8b 47 04             	mov    0x4(%edi),%eax
  103e8e:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103e91:	89 04 24             	mov    %eax,(%esp)
  103e94:	e8 e7 e4 ff ff       	call   102380 <kalloc>
  103e99:	85 c0                	test   %eax,%eax
  103e9b:	89 06                	mov    %eax,(%esi)
  103e9d:	0f 84 8e 00 00 00    	je     103f31 <copyproc_tix+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103ea3:	8b 56 04             	mov    0x4(%esi),%edx
  103ea6:	31 db                	xor    %ebx,%ebx
  103ea8:	89 54 24 08          	mov    %edx,0x8(%esp)
  103eac:	8b 17                	mov    (%edi),%edx
  103eae:	89 04 24             	mov    %eax,(%esp)
  103eb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103eb5:	e8 d6 06 00 00       	call   104590 <memmove>
  103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103ec0:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103ec4:	85 c0                	test   %eax,%eax
  103ec6:	74 0c                	je     103ed4 <copyproc_tix+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  103ec8:	89 04 24             	mov    %eax,(%esp)
  103ecb:	e8 a0 d0 ff ff       	call   100f70 <filedup>
  103ed0:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103ed4:	83 c3 01             	add    $0x1,%ebx
  103ed7:	83 fb 10             	cmp    $0x10,%ebx
  103eda:	75 e4                	jne    103ec0 <copyproc_tix+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103edc:	8b 47 60             	mov    0x60(%edi),%eax
  103edf:	89 04 24             	mov    %eax,(%esp)
  103ee2:	e8 79 d2 ff ff       	call   101160 <idup>
  103ee7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103eea:	8d 46 64             	lea    0x64(%esi),%eax
  103eed:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103ef4:	00 
  103ef5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103efc:	00 
  103efd:	89 04 24             	mov    %eax,(%esp)
  103f00:	e8 fb 05 00 00       	call   104500 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103f05:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103f0b:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103f12:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103f15:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103f1c:	83 c4 1c             	add    $0x1c,%esp
  103f1f:	89 f0                	mov    %esi,%eax
  103f21:	5b                   	pop    %ebx
  103f22:	5e                   	pop    %esi
  103f23:	5f                   	pop    %edi
  103f24:	5d                   	pop    %ebp
  103f25:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103f26:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103f2d:	31 f6                	xor    %esi,%esi
    return 0;
  103f2f:	eb eb                	jmp    103f1c <copyproc_tix+0xfc>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103f31:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103f38:	00 
  103f39:	8b 46 08             	mov    0x8(%esi),%eax
  103f3c:	89 04 24             	mov    %eax,(%esp)
  103f3f:	e8 fc e4 ff ff       	call   102440 <kfree>
      np->kstack = 0;
  103f44:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103f4b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103f52:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103f59:	31 f6                	xor    %esi,%esi
      return 0;
  103f5b:	eb bf                	jmp    103f1c <copyproc_tix+0xfc>
  103f5d:	8d 76 00             	lea    0x0(%esi),%esi

00103f60 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  103f60:	55                   	push   %ebp
  103f61:	89 e5                	mov    %esp,%ebp
  103f63:	57                   	push   %edi
  103f64:	56                   	push   %esi
  103f65:	53                   	push   %ebx
  103f66:	83 ec 1c             	sub    $0x1c,%esp
  103f69:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  103f6c:	e8 9f f4 ff ff       	call   103410 <allocproc>
  103f71:	85 c0                	test   %eax,%eax
  103f73:	89 c6                	mov    %eax,%esi
  103f75:	0f 84 de 00 00 00    	je     104059 <copyproc_threads+0xf9>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103f7b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103f82:	e8 f9 e3 ff ff       	call   102380 <kalloc>
  103f87:	85 c0                	test   %eax,%eax
  103f89:	89 46 08             	mov    %eax,0x8(%esi)
  103f8c:	0f 84 d1 00 00 00    	je     104063 <copyproc_threads+0x103>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f92:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103f97:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103f99:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103f9f:	74 61                	je     104002 <copyproc_threads+0xa2>
    np->parent = p;
  103fa1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  103fa4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  103fa6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  103fad:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103fb0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103fb7:	00 
  103fb8:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  103fbe:	89 04 24             	mov    %eax,(%esp)
  103fc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103fc5:	e8 c6 05 00 00       	call   104590 <memmove>
  
    np->sz = p->sz;
  103fca:	8b 47 04             	mov    0x4(%edi),%eax
  103fcd:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  103fd0:	8b 07                	mov    (%edi),%eax
  103fd2:	89 06                	mov    %eax,(%esi)
  103fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103fd8:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103fdc:	85 c0                	test   %eax,%eax
  103fde:	74 0c                	je     103fec <copyproc_threads+0x8c>
        np->ofile[i] = filedup(p->ofile[i]);
  103fe0:	89 04 24             	mov    %eax,(%esp)
  103fe3:	e8 88 cf ff ff       	call   100f70 <filedup>
  103fe8:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103fec:	83 c3 01             	add    $0x1,%ebx
  103fef:	83 fb 10             	cmp    $0x10,%ebx
  103ff2:	75 e4                	jne    103fd8 <copyproc_threads+0x78>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103ff4:	8b 47 60             	mov    0x60(%edi),%eax
  103ff7:	89 04 24             	mov    %eax,(%esp)
  103ffa:	e8 61 d1 ff ff       	call   101160 <idup>
  103fff:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  104002:	8d 46 64             	lea    0x64(%esi),%eax
  104005:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  10400c:	00 
  10400d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104014:	00 
  104015:	89 04 24             	mov    %eax,(%esp)
  104018:	e8 e3 04 00 00       	call   104500 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10401d:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104020:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  104026:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  10402d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104030:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104033:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104039:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10403c:	89 50 3c             	mov    %edx,0x3c(%eax)
  *(int *)(np->tf->esp + np->mem) = routine;
  10403f:	8b 16                	mov    (%esi),%edx
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104041:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104048:	89 8c 1a f4 03 00 00 	mov    %ecx,0x3f4(%edx,%ebx,1)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  10404f:	8b 40 3c             	mov    0x3c(%eax),%eax
  104052:	8b 4d 14             	mov    0x14(%ebp),%ecx
  104055:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
  return np;
}
  104059:	83 c4 1c             	add    $0x1c,%esp
  10405c:	89 f0                	mov    %esi,%eax
  10405e:	5b                   	pop    %ebx
  10405f:	5e                   	pop    %esi
  104060:	5f                   	pop    %edi
  104061:	5d                   	pop    %ebp
  104062:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104063:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10406a:	31 f6                	xor    %esi,%esi
    return 0;
  10406c:	eb eb                	jmp    104059 <copyproc_threads+0xf9>
  10406e:	66 90                	xchg   %ax,%ax

00104070 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  104070:	55                   	push   %ebp
  104071:	89 e5                	mov    %esp,%ebp
  104073:	57                   	push   %edi
  104074:	56                   	push   %esi
  104075:	53                   	push   %ebx
  104076:	83 ec 1c             	sub    $0x1c,%esp
  104079:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10407c:	e8 8f f3 ff ff       	call   103410 <allocproc>
  104081:	85 c0                	test   %eax,%eax
  104083:	89 c6                	mov    %eax,%esi
  104085:	0f 84 e1 00 00 00    	je     10416c <copyproc+0xfc>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10408b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104092:	e8 e9 e2 ff ff       	call   102380 <kalloc>
  104097:	85 c0                	test   %eax,%eax
  104099:	89 46 08             	mov    %eax,0x8(%esi)
  10409c:	0f 84 d4 00 00 00    	je     104176 <copyproc+0x106>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040a2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1040a7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040a9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1040af:	0f 84 85 00 00 00    	je     10413a <copyproc+0xca>
    np->parent = p;
  1040b5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  1040b8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1040bf:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1040c2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1040c9:	00 
  1040ca:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
  1040d0:	89 04 24             	mov    %eax,(%esp)
  1040d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040d7:	e8 b4 04 00 00       	call   104590 <memmove>
  
    np->sz = p->sz;
  1040dc:	8b 47 04             	mov    0x4(%edi),%eax
  1040df:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  1040e2:	89 04 24             	mov    %eax,(%esp)
  1040e5:	e8 96 e2 ff ff       	call   102380 <kalloc>
  1040ea:	85 c0                	test   %eax,%eax
  1040ec:	89 06                	mov    %eax,(%esi)
  1040ee:	0f 84 8d 00 00 00    	je     104181 <copyproc+0x111>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1040f4:	8b 56 04             	mov    0x4(%esi),%edx
  1040f7:	31 db                	xor    %ebx,%ebx
  1040f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1040fd:	8b 17                	mov    (%edi),%edx
  1040ff:	89 04 24             	mov    %eax,(%esp)
  104102:	89 54 24 04          	mov    %edx,0x4(%esp)
  104106:	e8 85 04 00 00       	call   104590 <memmove>
  10410b:	90                   	nop
  10410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104110:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104114:	85 c0                	test   %eax,%eax
  104116:	74 0c                	je     104124 <copyproc+0xb4>
        np->ofile[i] = filedup(p->ofile[i]);
  104118:	89 04 24             	mov    %eax,(%esp)
  10411b:	e8 50 ce ff ff       	call   100f70 <filedup>
  104120:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104124:	83 c3 01             	add    $0x1,%ebx
  104127:	83 fb 10             	cmp    $0x10,%ebx
  10412a:	75 e4                	jne    104110 <copyproc+0xa0>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10412c:	8b 47 60             	mov    0x60(%edi),%eax
  10412f:	89 04 24             	mov    %eax,(%esp)
  104132:	e8 29 d0 ff ff       	call   101160 <idup>
  104137:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10413a:	8d 46 64             	lea    0x64(%esi),%eax
  10413d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104144:	00 
  104145:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10414c:	00 
  10414d:	89 04 24             	mov    %eax,(%esp)
  104150:	e8 ab 03 00 00       	call   104500 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104155:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10415b:	c7 46 64 c0 34 10 00 	movl   $0x1034c0,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104162:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104165:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10416c:	83 c4 1c             	add    $0x1c,%esp
  10416f:	89 f0                	mov    %esi,%eax
  104171:	5b                   	pop    %ebx
  104172:	5e                   	pop    %esi
  104173:	5f                   	pop    %edi
  104174:	5d                   	pop    %ebp
  104175:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104176:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10417d:	31 f6                	xor    %esi,%esi
    return 0;
  10417f:	eb eb                	jmp    10416c <copyproc+0xfc>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104181:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104188:	00 
  104189:	8b 46 08             	mov    0x8(%esi),%eax
  10418c:	89 04 24             	mov    %eax,(%esp)
  10418f:	e8 ac e2 ff ff       	call   102440 <kfree>
      np->kstack = 0;
  104194:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10419b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1041a2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1041a9:	31 f6                	xor    %esi,%esi
      return 0;
  1041ab:	eb bf                	jmp    10416c <copyproc+0xfc>
  1041ad:	8d 76 00             	lea    0x0(%esi),%esi

001041b0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	53                   	push   %ebx
  1041b4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1041b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1041be:	e8 ad fe ff ff       	call   104070 <copyproc>
  p->sz = PAGE;
  1041c3:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1041ca:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  1041cc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1041d3:	e8 a8 e1 ff ff       	call   102380 <kalloc>
  1041d8:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  1041da:	c7 04 24 c6 6a 10 00 	movl   $0x106ac6,(%esp)
  1041e1:	e8 ca dd ff ff       	call   101fb0 <namei>
  1041e6:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  1041e9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1041f0:	00 
  1041f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1041f8:	00 
  1041f9:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  1041ff:	89 04 24             	mov    %eax,(%esp)
  104202:	e8 f9 02 00 00       	call   104500 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104207:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10420d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10420f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104216:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104219:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10421f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104225:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10422b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10422e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104232:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104235:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10423b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104242:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104249:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104250:	00 
  104251:	c7 44 24 04 c8 83 10 	movl   $0x1083c8,0x4(%esp)
  104258:	00 
  104259:	8b 03                	mov    (%ebx),%eax
  10425b:	89 04 24             	mov    %eax,(%esp)
  10425e:	e8 2d 03 00 00       	call   104590 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  104263:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  104269:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104270:	00 
  104271:	c7 44 24 04 c8 6a 10 	movl   $0x106ac8,0x4(%esp)
  104278:	00 
  104279:	89 04 24             	mov    %eax,(%esp)
  10427c:	e8 1f 04 00 00       	call   1046a0 <safestrcpy>
  p->state = RUNNABLE;
  104281:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104288:	89 1d 08 85 10 00    	mov    %ebx,0x108508
}
  10428e:	83 c4 14             	add    $0x14,%esp
  104291:	5b                   	pop    %ebx
  104292:	5d                   	pop    %ebp
  104293:	c3                   	ret    
  104294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10429a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001042a0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  1042a0:	55                   	push   %ebp
  1042a1:	89 e5                	mov    %esp,%ebp
  1042a3:	83 ec 18             	sub    $0x18,%esp
  initlock(&proc_table_lock, "proc_table");
  1042a6:	c7 44 24 04 d1 6a 10 	movl   $0x106ad1,0x4(%esp)
  1042ad:	00 
  1042ae:	c7 04 24 00 e5 10 00 	movl   $0x10e500,(%esp)
  1042b5:	e8 06 00 00 00       	call   1042c0 <initlock>
}
  1042ba:	c9                   	leave  
  1042bb:	c3                   	ret    
  1042bc:	90                   	nop
  1042bd:	90                   	nop
  1042be:	90                   	nop
  1042bf:	90                   	nop

001042c0 <initlock>:
  1042c0:	55                   	push   %ebp
  1042c1:	89 e5                	mov    %esp,%ebp
  1042c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1042c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  1042cf:	89 50 04             	mov    %edx,0x4(%eax)
  1042d2:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
  1042d9:	5d                   	pop    %ebp
  1042da:	c3                   	ret    
  1042db:	90                   	nop
  1042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042e0 <getcallerpcs>:
  1042e0:	55                   	push   %ebp
  1042e1:	31 d2                	xor    %edx,%edx
  1042e3:	89 e5                	mov    %esp,%ebp
  1042e5:	53                   	push   %ebx
  1042e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1042e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1042ec:	83 e9 08             	sub    $0x8,%ecx
  1042ef:	eb 09                	jmp    1042fa <getcallerpcs+0x1a>
  1042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1042f8:	89 c1                	mov    %eax,%ecx
  1042fa:	8d 41 ff             	lea    -0x1(%ecx),%eax
  1042fd:	83 f8 fd             	cmp    $0xfffffffd,%eax
  104300:	77 16                	ja     104318 <getcallerpcs+0x38>
  104302:	8b 41 04             	mov    0x4(%ecx),%eax
  104305:	89 04 93             	mov    %eax,(%ebx,%edx,4)
  104308:	83 c2 01             	add    $0x1,%edx
  10430b:	8b 01                	mov    (%ecx),%eax
  10430d:	83 fa 0a             	cmp    $0xa,%edx
  104310:	75 e6                	jne    1042f8 <getcallerpcs+0x18>
  104312:	5b                   	pop    %ebx
  104313:	5d                   	pop    %ebp
  104314:	c3                   	ret    
  104315:	8d 76 00             	lea    0x0(%esi),%esi
  104318:	83 fa 09             	cmp    $0x9,%edx
  10431b:	8d 04 93             	lea    (%ebx,%edx,4),%eax
  10431e:	7f f2                	jg     104312 <getcallerpcs+0x32>
  104320:	83 c2 01             	add    $0x1,%edx
  104323:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  104329:	83 c0 04             	add    $0x4,%eax
  10432c:	83 fa 09             	cmp    $0x9,%edx
  10432f:	7e ef                	jle    104320 <getcallerpcs+0x40>
  104331:	5b                   	pop    %ebx
  104332:	5d                   	pop    %ebp
  104333:	c3                   	ret    
  104334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10433a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104340 <popcli>:
  104340:	55                   	push   %ebp
  104341:	89 e5                	mov    %esp,%ebp
  104343:	83 ec 08             	sub    $0x8,%esp
  104346:	9c                   	pushf  
  104347:	58                   	pop    %eax
  104348:	f6 c4 02             	test   $0x2,%ah
  10434b:	75 53                	jne    1043a0 <popcli+0x60>
  10434d:	e8 de e5 ff ff       	call   102930 <cpu>
  104352:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104358:	05 84 b7 10 00       	add    $0x10b784,%eax
  10435d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104363:	83 ea 01             	sub    $0x1,%edx
  104366:	85 d2                	test   %edx,%edx
  104368:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10436e:	78 3c                	js     1043ac <popcli+0x6c>
  104370:	e8 bb e5 ff ff       	call   102930 <cpu>
  104375:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10437b:	8b 90 44 b8 10 00    	mov    0x10b844(%eax),%edx
  104381:	85 d2                	test   %edx,%edx
  104383:	74 03                	je     104388 <popcli+0x48>
  104385:	c9                   	leave  
  104386:	c3                   	ret    
  104387:	90                   	nop
  104388:	e8 a3 e5 ff ff       	call   102930 <cpu>
  10438d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104393:	8b 80 48 b8 10 00    	mov    0x10b848(%eax),%eax
  104399:	85 c0                	test   %eax,%eax
  10439b:	74 e8                	je     104385 <popcli+0x45>
  10439d:	fb                   	sti    
  10439e:	c9                   	leave  
  10439f:	c3                   	ret    
  1043a0:	c7 04 24 20 6b 10 00 	movl   $0x106b20,(%esp)
  1043a7:	e8 c4 c5 ff ff       	call   100970 <panic>
  1043ac:	c7 04 24 37 6b 10 00 	movl   $0x106b37,(%esp)
  1043b3:	e8 b8 c5 ff ff       	call   100970 <panic>
  1043b8:	90                   	nop
  1043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001043c0 <pushcli>:
  1043c0:	55                   	push   %ebp
  1043c1:	89 e5                	mov    %esp,%ebp
  1043c3:	53                   	push   %ebx
  1043c4:	83 ec 04             	sub    $0x4,%esp
  1043c7:	9c                   	pushf  
  1043c8:	5b                   	pop    %ebx
  1043c9:	fa                   	cli    
  1043ca:	e8 61 e5 ff ff       	call   102930 <cpu>
  1043cf:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043d5:	05 84 b7 10 00       	add    $0x10b784,%eax
  1043da:	8b 88 c0 00 00 00    	mov    0xc0(%eax),%ecx
  1043e0:	8d 51 01             	lea    0x1(%ecx),%edx
  1043e3:	85 c9                	test   %ecx,%ecx
  1043e5:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1043eb:	75 17                	jne    104404 <pushcli+0x44>
  1043ed:	e8 3e e5 ff ff       	call   102930 <cpu>
  1043f2:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1043f8:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043fe:	89 98 48 b8 10 00    	mov    %ebx,0x10b848(%eax)
  104404:	83 c4 04             	add    $0x4,%esp
  104407:	5b                   	pop    %ebx
  104408:	5d                   	pop    %ebp
  104409:	c3                   	ret    
  10440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104410 <holding>:
  104410:	55                   	push   %ebp
  104411:	31 c0                	xor    %eax,%eax
  104413:	89 e5                	mov    %esp,%ebp
  104415:	53                   	push   %ebx
  104416:	83 ec 04             	sub    $0x4,%esp
  104419:	8b 55 08             	mov    0x8(%ebp),%edx
  10441c:	8b 0a                	mov    (%edx),%ecx
  10441e:	85 c9                	test   %ecx,%ecx
  104420:	75 06                	jne    104428 <holding+0x18>
  104422:	83 c4 04             	add    $0x4,%esp
  104425:	5b                   	pop    %ebx
  104426:	5d                   	pop    %ebp
  104427:	c3                   	ret    
  104428:	8b 5a 08             	mov    0x8(%edx),%ebx
  10442b:	e8 00 e5 ff ff       	call   102930 <cpu>
  104430:	83 c0 0a             	add    $0xa,%eax
  104433:	39 c3                	cmp    %eax,%ebx
  104435:	0f 94 c0             	sete   %al
  104438:	83 c4 04             	add    $0x4,%esp
  10443b:	0f b6 c0             	movzbl %al,%eax
  10443e:	5b                   	pop    %ebx
  10443f:	5d                   	pop    %ebp
  104440:	c3                   	ret    
  104441:	eb 0d                	jmp    104450 <release>
  104443:	90                   	nop
  104444:	90                   	nop
  104445:	90                   	nop
  104446:	90                   	nop
  104447:	90                   	nop
  104448:	90                   	nop
  104449:	90                   	nop
  10444a:	90                   	nop
  10444b:	90                   	nop
  10444c:	90                   	nop
  10444d:	90                   	nop
  10444e:	90                   	nop
  10444f:	90                   	nop

00104450 <release>:
  104450:	55                   	push   %ebp
  104451:	89 e5                	mov    %esp,%ebp
  104453:	53                   	push   %ebx
  104454:	83 ec 04             	sub    $0x4,%esp
  104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10445a:	89 1c 24             	mov    %ebx,(%esp)
  10445d:	e8 ae ff ff ff       	call   104410 <holding>
  104462:	85 c0                	test   %eax,%eax
  104464:	74 1d                	je     104483 <release+0x33>
  104466:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  10446d:	31 c0                	xor    %eax,%eax
  10446f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  104476:	f0 87 03             	lock xchg %eax,(%ebx)
  104479:	83 c4 04             	add    $0x4,%esp
  10447c:	5b                   	pop    %ebx
  10447d:	5d                   	pop    %ebp
  10447e:	e9 bd fe ff ff       	jmp    104340 <popcli>
  104483:	c7 04 24 3e 6b 10 00 	movl   $0x106b3e,(%esp)
  10448a:	e8 e1 c4 ff ff       	call   100970 <panic>
  10448f:	90                   	nop

00104490 <acquire>:
  104490:	55                   	push   %ebp
  104491:	89 e5                	mov    %esp,%ebp
  104493:	53                   	push   %ebx
  104494:	83 ec 14             	sub    $0x14,%esp
  104497:	e8 24 ff ff ff       	call   1043c0 <pushcli>
  10449c:	8b 45 08             	mov    0x8(%ebp),%eax
  10449f:	89 04 24             	mov    %eax,(%esp)
  1044a2:	e8 69 ff ff ff       	call   104410 <holding>
  1044a7:	85 c0                	test   %eax,%eax
  1044a9:	75 3d                	jne    1044e8 <acquire+0x58>
  1044ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1044ae:	ba 01 00 00 00       	mov    $0x1,%edx
  1044b3:	90                   	nop
  1044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1044b8:	89 d0                	mov    %edx,%eax
  1044ba:	f0 87 03             	lock xchg %eax,(%ebx)
  1044bd:	83 e8 01             	sub    $0x1,%eax
  1044c0:	74 f6                	je     1044b8 <acquire+0x28>
  1044c2:	e8 69 e4 ff ff       	call   102930 <cpu>
  1044c7:	83 c0 0a             	add    $0xa,%eax
  1044ca:	89 43 08             	mov    %eax,0x8(%ebx)
  1044cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d0:	83 c0 0c             	add    $0xc,%eax
  1044d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044d7:	8d 45 08             	lea    0x8(%ebp),%eax
  1044da:	89 04 24             	mov    %eax,(%esp)
  1044dd:	e8 fe fd ff ff       	call   1042e0 <getcallerpcs>
  1044e2:	83 c4 14             	add    $0x14,%esp
  1044e5:	5b                   	pop    %ebx
  1044e6:	5d                   	pop    %ebp
  1044e7:	c3                   	ret    
  1044e8:	c7 04 24 46 6b 10 00 	movl   $0x106b46,(%esp)
  1044ef:	e8 7c c4 ff ff       	call   100970 <panic>
  1044f4:	90                   	nop
  1044f5:	90                   	nop
  1044f6:	90                   	nop
  1044f7:	90                   	nop
  1044f8:	90                   	nop
  1044f9:	90                   	nop
  1044fa:	90                   	nop
  1044fb:	90                   	nop
  1044fc:	90                   	nop
  1044fd:	90                   	nop
  1044fe:	90                   	nop
  1044ff:	90                   	nop

00104500 <memset>:
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	8b 45 10             	mov    0x10(%ebp),%eax
  104506:	53                   	push   %ebx
  104507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10450a:	85 c0                	test   %eax,%eax
  10450c:	74 14                	je     104522 <memset+0x22>
  10450e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  104512:	31 d2                	xor    %edx,%edx
  104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104518:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  10451b:	83 c2 01             	add    $0x1,%edx
  10451e:	39 c2                	cmp    %eax,%edx
  104520:	75 f6                	jne    104518 <memset+0x18>
  104522:	89 d8                	mov    %ebx,%eax
  104524:	5b                   	pop    %ebx
  104525:	5d                   	pop    %ebp
  104526:	c3                   	ret    
  104527:	89 f6                	mov    %esi,%esi
  104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104530 <memcmp>:
  104530:	55                   	push   %ebp
  104531:	89 e5                	mov    %esp,%ebp
  104533:	57                   	push   %edi
  104534:	56                   	push   %esi
  104535:	53                   	push   %ebx
  104536:	8b 55 10             	mov    0x10(%ebp),%edx
  104539:	8b 7d 08             	mov    0x8(%ebp),%edi
  10453c:	8b 75 0c             	mov    0xc(%ebp),%esi
  10453f:	85 d2                	test   %edx,%edx
  104541:	74 2d                	je     104570 <memcmp+0x40>
  104543:	0f b6 1f             	movzbl (%edi),%ebx
  104546:	0f b6 06             	movzbl (%esi),%eax
  104549:	38 c3                	cmp    %al,%bl
  10454b:	75 33                	jne    104580 <memcmp+0x50>
  10454d:	8d 4a ff             	lea    -0x1(%edx),%ecx
  104550:	31 d2                	xor    %edx,%edx
  104552:	eb 18                	jmp    10456c <memcmp+0x3c>
  104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104558:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  10455d:	83 e9 01             	sub    $0x1,%ecx
  104560:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  104565:	83 c2 01             	add    $0x1,%edx
  104568:	38 c3                	cmp    %al,%bl
  10456a:	75 14                	jne    104580 <memcmp+0x50>
  10456c:	85 c9                	test   %ecx,%ecx
  10456e:	75 e8                	jne    104558 <memcmp+0x28>
  104570:	31 d2                	xor    %edx,%edx
  104572:	89 d0                	mov    %edx,%eax
  104574:	5b                   	pop    %ebx
  104575:	5e                   	pop    %esi
  104576:	5f                   	pop    %edi
  104577:	5d                   	pop    %ebp
  104578:	c3                   	ret    
  104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104580:	0f b6 d3             	movzbl %bl,%edx
  104583:	0f b6 c0             	movzbl %al,%eax
  104586:	29 c2                	sub    %eax,%edx
  104588:	89 d0                	mov    %edx,%eax
  10458a:	5b                   	pop    %ebx
  10458b:	5e                   	pop    %esi
  10458c:	5f                   	pop    %edi
  10458d:	5d                   	pop    %ebp
  10458e:	c3                   	ret    
  10458f:	90                   	nop

00104590 <memmove>:
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	57                   	push   %edi
  104594:	56                   	push   %esi
  104595:	53                   	push   %ebx
  104596:	8b 75 08             	mov    0x8(%ebp),%esi
  104599:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10459c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10459f:	39 f1                	cmp    %esi,%ecx
  1045a1:	73 35                	jae    1045d8 <memmove+0x48>
  1045a3:	8d 3c 19             	lea    (%ecx,%ebx,1),%edi
  1045a6:	39 fe                	cmp    %edi,%esi
  1045a8:	73 2e                	jae    1045d8 <memmove+0x48>
  1045aa:	85 db                	test   %ebx,%ebx
  1045ac:	74 1d                	je     1045cb <memmove+0x3b>
  1045ae:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  1045b1:	31 d2                	xor    %edx,%edx
  1045b3:	90                   	nop
  1045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045b8:	0f b6 44 17 ff       	movzbl -0x1(%edi,%edx,1),%eax
  1045bd:	88 44 11 ff          	mov    %al,-0x1(%ecx,%edx,1)
  1045c1:	83 ea 01             	sub    $0x1,%edx
  1045c4:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  1045c7:	85 c0                	test   %eax,%eax
  1045c9:	75 ed                	jne    1045b8 <memmove+0x28>
  1045cb:	89 f0                	mov    %esi,%eax
  1045cd:	5b                   	pop    %ebx
  1045ce:	5e                   	pop    %esi
  1045cf:	5f                   	pop    %edi
  1045d0:	5d                   	pop    %ebp
  1045d1:	c3                   	ret    
  1045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1045d8:	31 d2                	xor    %edx,%edx
  1045da:	85 db                	test   %ebx,%ebx
  1045dc:	74 ed                	je     1045cb <memmove+0x3b>
  1045de:	66 90                	xchg   %ax,%ax
  1045e0:	0f b6 04 11          	movzbl (%ecx,%edx,1),%eax
  1045e4:	88 04 16             	mov    %al,(%esi,%edx,1)
  1045e7:	83 c2 01             	add    $0x1,%edx
  1045ea:	39 d3                	cmp    %edx,%ebx
  1045ec:	75 f2                	jne    1045e0 <memmove+0x50>
  1045ee:	89 f0                	mov    %esi,%eax
  1045f0:	5b                   	pop    %ebx
  1045f1:	5e                   	pop    %esi
  1045f2:	5f                   	pop    %edi
  1045f3:	5d                   	pop    %ebp
  1045f4:	c3                   	ret    
  1045f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104600 <strncmp>:
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	56                   	push   %esi
  104604:	53                   	push   %ebx
  104605:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10460b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10460e:	85 c9                	test   %ecx,%ecx
  104610:	75 1e                	jne    104630 <strncmp+0x30>
  104612:	eb 34                	jmp    104648 <strncmp+0x48>
  104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104618:	0f b6 16             	movzbl (%esi),%edx
  10461b:	38 d0                	cmp    %dl,%al
  10461d:	75 1b                	jne    10463a <strncmp+0x3a>
  10461f:	83 e9 01             	sub    $0x1,%ecx
  104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104628:	74 1e                	je     104648 <strncmp+0x48>
  10462a:	83 c3 01             	add    $0x1,%ebx
  10462d:	83 c6 01             	add    $0x1,%esi
  104630:	0f b6 03             	movzbl (%ebx),%eax
  104633:	84 c0                	test   %al,%al
  104635:	75 e1                	jne    104618 <strncmp+0x18>
  104637:	0f b6 16             	movzbl (%esi),%edx
  10463a:	0f b6 c8             	movzbl %al,%ecx
  10463d:	0f b6 c2             	movzbl %dl,%eax
  104640:	29 c1                	sub    %eax,%ecx
  104642:	89 c8                	mov    %ecx,%eax
  104644:	5b                   	pop    %ebx
  104645:	5e                   	pop    %esi
  104646:	5d                   	pop    %ebp
  104647:	c3                   	ret    
  104648:	31 c9                	xor    %ecx,%ecx
  10464a:	89 c8                	mov    %ecx,%eax
  10464c:	5b                   	pop    %ebx
  10464d:	5e                   	pop    %esi
  10464e:	5d                   	pop    %ebp
  10464f:	c3                   	ret    

00104650 <strncpy>:
  104650:	55                   	push   %ebp
  104651:	89 e5                	mov    %esp,%ebp
  104653:	56                   	push   %esi
  104654:	8b 75 08             	mov    0x8(%ebp),%esi
  104657:	53                   	push   %ebx
  104658:	8b 55 10             	mov    0x10(%ebp),%edx
  10465b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10465e:	89 f1                	mov    %esi,%ecx
  104660:	eb 09                	jmp    10466b <strncpy+0x1b>
  104662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104668:	83 c3 01             	add    $0x1,%ebx
  10466b:	83 ea 01             	sub    $0x1,%edx
  10466e:	8d 42 01             	lea    0x1(%edx),%eax
  104671:	85 c0                	test   %eax,%eax
  104673:	7e 0c                	jle    104681 <strncpy+0x31>
  104675:	0f b6 03             	movzbl (%ebx),%eax
  104678:	88 01                	mov    %al,(%ecx)
  10467a:	83 c1 01             	add    $0x1,%ecx
  10467d:	84 c0                	test   %al,%al
  10467f:	75 e7                	jne    104668 <strncpy+0x18>
  104681:	31 c0                	xor    %eax,%eax
  104683:	85 d2                	test   %edx,%edx
  104685:	7e 0c                	jle    104693 <strncpy+0x43>
  104687:	90                   	nop
  104688:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
  10468c:	83 c0 01             	add    $0x1,%eax
  10468f:	39 d0                	cmp    %edx,%eax
  104691:	75 f5                	jne    104688 <strncpy+0x38>
  104693:	89 f0                	mov    %esi,%eax
  104695:	5b                   	pop    %ebx
  104696:	5e                   	pop    %esi
  104697:	5d                   	pop    %ebp
  104698:	c3                   	ret    
  104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001046a0 <safestrcpy>:
  1046a0:	55                   	push   %ebp
  1046a1:	89 e5                	mov    %esp,%ebp
  1046a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1046a6:	56                   	push   %esi
  1046a7:	8b 75 08             	mov    0x8(%ebp),%esi
  1046aa:	53                   	push   %ebx
  1046ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1046ae:	85 c9                	test   %ecx,%ecx
  1046b0:	7e 1f                	jle    1046d1 <safestrcpy+0x31>
  1046b2:	89 f2                	mov    %esi,%edx
  1046b4:	eb 05                	jmp    1046bb <safestrcpy+0x1b>
  1046b6:	66 90                	xchg   %ax,%ax
  1046b8:	83 c3 01             	add    $0x1,%ebx
  1046bb:	83 e9 01             	sub    $0x1,%ecx
  1046be:	85 c9                	test   %ecx,%ecx
  1046c0:	7e 0c                	jle    1046ce <safestrcpy+0x2e>
  1046c2:	0f b6 03             	movzbl (%ebx),%eax
  1046c5:	88 02                	mov    %al,(%edx)
  1046c7:	83 c2 01             	add    $0x1,%edx
  1046ca:	84 c0                	test   %al,%al
  1046cc:	75 ea                	jne    1046b8 <safestrcpy+0x18>
  1046ce:	c6 02 00             	movb   $0x0,(%edx)
  1046d1:	89 f0                	mov    %esi,%eax
  1046d3:	5b                   	pop    %ebx
  1046d4:	5e                   	pop    %esi
  1046d5:	5d                   	pop    %ebp
  1046d6:	c3                   	ret    
  1046d7:	89 f6                	mov    %esi,%esi
  1046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001046e0 <strlen>:
  1046e0:	55                   	push   %ebp
  1046e1:	31 c0                	xor    %eax,%eax
  1046e3:	89 e5                	mov    %esp,%ebp
  1046e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1046e8:	80 3a 00             	cmpb   $0x0,(%edx)
  1046eb:	74 0c                	je     1046f9 <strlen+0x19>
  1046ed:	8d 76 00             	lea    0x0(%esi),%esi
  1046f0:	83 c0 01             	add    $0x1,%eax
  1046f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1046f7:	75 f7                	jne    1046f0 <strlen+0x10>
  1046f9:	5d                   	pop    %ebp
  1046fa:	c3                   	ret    
  1046fb:	90                   	nop

001046fc <swtch>:
  1046fc:	8b 44 24 04          	mov    0x4(%esp),%eax
  104700:	8f 00                	popl   (%eax)
  104702:	89 60 04             	mov    %esp,0x4(%eax)
  104705:	89 58 08             	mov    %ebx,0x8(%eax)
  104708:	89 48 0c             	mov    %ecx,0xc(%eax)
  10470b:	89 50 10             	mov    %edx,0x10(%eax)
  10470e:	89 70 14             	mov    %esi,0x14(%eax)
  104711:	89 78 18             	mov    %edi,0x18(%eax)
  104714:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104717:	8b 44 24 04          	mov    0x4(%esp),%eax
  10471b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10471e:	8b 78 18             	mov    0x18(%eax),%edi
  104721:	8b 70 14             	mov    0x14(%eax),%esi
  104724:	8b 50 10             	mov    0x10(%eax),%edx
  104727:	8b 48 0c             	mov    0xc(%eax),%ecx
  10472a:	8b 58 08             	mov    0x8(%eax),%ebx
  10472d:	8b 60 04             	mov    0x4(%eax),%esp
  104730:	ff 30                	pushl  (%eax)
  104732:	c3                   	ret    
  104733:	90                   	nop
  104734:	90                   	nop
  104735:	90                   	nop
  104736:	90                   	nop
  104737:	90                   	nop
  104738:	90                   	nop
  104739:	90                   	nop
  10473a:	90                   	nop
  10473b:	90                   	nop
  10473c:	90                   	nop
  10473d:	90                   	nop
  10473e:	90                   	nop
  10473f:	90                   	nop

00104740 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104740:	55                   	push   %ebp
  104741:	89 e5                	mov    %esp,%ebp
  104743:	8b 4d 08             	mov    0x8(%ebp),%ecx
  104746:	53                   	push   %ebx
  104747:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  10474a:	8b 51 04             	mov    0x4(%ecx),%edx
  10474d:	39 c2                	cmp    %eax,%edx
  10474f:	77 0f                	ja     104760 <fetchint+0x20>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  104751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104756:	5b                   	pop    %ebx
  104757:	5d                   	pop    %ebp
  104758:	c3                   	ret    
  104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104760:	8d 58 04             	lea    0x4(%eax),%ebx
  104763:	39 da                	cmp    %ebx,%edx
  104765:	72 ea                	jb     104751 <fetchint+0x11>
    return -1;
  *ip = *(int*)(p->mem + addr);
  104767:	8b 11                	mov    (%ecx),%edx
  104769:	8b 14 02             	mov    (%edx,%eax,1),%edx
  10476c:	8b 45 10             	mov    0x10(%ebp),%eax
  10476f:	89 10                	mov    %edx,(%eax)
  104771:	31 c0                	xor    %eax,%eax
  return 0;
  104773:	eb e1                	jmp    104756 <fetchint+0x16>
  104775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104780 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104780:	55                   	push   %ebp
  104781:	89 e5                	mov    %esp,%ebp
  104783:	8b 45 08             	mov    0x8(%ebp),%eax
  104786:	8b 55 0c             	mov    0xc(%ebp),%edx
  104789:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10478a:	39 50 04             	cmp    %edx,0x4(%eax)
  10478d:	77 09                	ja     104798 <fetchstr+0x18>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10478f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104794:	5b                   	pop    %ebx
  104795:	5d                   	pop    %ebp
  104796:	c3                   	ret    
  104797:	90                   	nop
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104798:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10479b:	03 10                	add    (%eax),%edx
  10479d:	89 11                	mov    %edx,(%ecx)
  ep = p->mem + p->sz;
  10479f:	8b 18                	mov    (%eax),%ebx
  1047a1:	03 58 04             	add    0x4(%eax),%ebx
  for(s = *pp; s < ep; s++)
  1047a4:	39 da                	cmp    %ebx,%edx
  1047a6:	73 e7                	jae    10478f <fetchstr+0xf>
    if(*s == 0)
  1047a8:	31 c0                	xor    %eax,%eax
  1047aa:	89 d1                	mov    %edx,%ecx
  1047ac:	80 3a 00             	cmpb   $0x0,(%edx)
  1047af:	74 e3                	je     104794 <fetchstr+0x14>
  1047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1047b8:	83 c1 01             	add    $0x1,%ecx
  1047bb:	39 cb                	cmp    %ecx,%ebx
  1047bd:	76 d0                	jbe    10478f <fetchstr+0xf>
    if(*s == 0)
  1047bf:	80 39 00             	cmpb   $0x0,(%ecx)
  1047c2:	75 f4                	jne    1047b8 <fetchstr+0x38>
  1047c4:	89 c8                	mov    %ecx,%eax
  1047c6:	29 d0                	sub    %edx,%eax
  1047c8:	eb ca                	jmp    104794 <fetchstr+0x14>
  1047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001047d0 <argint>:
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1047d0:	55                   	push   %ebp
  1047d1:	89 e5                	mov    %esp,%ebp
  1047d3:	53                   	push   %ebx
  1047d4:	83 ec 04             	sub    $0x4,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1047d7:	e8 b4 ec ff ff       	call   103490 <curproc>
  1047dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1047df:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1047e5:	8b 40 3c             	mov    0x3c(%eax),%eax
  1047e8:	8d 5c 90 04          	lea    0x4(%eax,%edx,4),%ebx
  1047ec:	e8 9f ec ff ff       	call   103490 <curproc>

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047f1:	8b 50 04             	mov    0x4(%eax),%edx
  1047f4:	39 d3                	cmp    %edx,%ebx
  1047f6:	72 10                	jb     104808 <argint+0x38>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
}
  1047fd:	83 c4 04             	add    $0x4,%esp
  104800:	5b                   	pop    %ebx
  104801:	5d                   	pop    %ebp
  104802:	c3                   	ret    
  104803:	90                   	nop
  104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104808:	8d 4b 04             	lea    0x4(%ebx),%ecx
  10480b:	39 ca                	cmp    %ecx,%edx
  10480d:	72 e9                	jb     1047f8 <argint+0x28>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10480f:	8b 00                	mov    (%eax),%eax
  104811:	8b 14 18             	mov    (%eax,%ebx,1),%edx
  104814:	8b 45 0c             	mov    0xc(%ebp),%eax
  104817:	89 10                	mov    %edx,(%eax)
  104819:	31 c0                	xor    %eax,%eax
  10481b:	eb e0                	jmp    1047fd <argint+0x2d>
  10481d:	8d 76 00             	lea    0x0(%esi),%esi

00104820 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104820:	55                   	push   %ebp
  104821:	89 e5                	mov    %esp,%ebp
  104823:	53                   	push   %ebx
  104824:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104827:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10482a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10482e:	8b 45 08             	mov    0x8(%ebp),%eax
  104831:	89 04 24             	mov    %eax,(%esp)
  104834:	e8 97 ff ff ff       	call   1047d0 <argint>
  104839:	85 c0                	test   %eax,%eax
  10483b:	78 3b                	js     104878 <argstr+0x58>
    return -1;
  return fetchstr(cp, addr, pp);
  10483d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104840:	e8 4b ec ff ff       	call   103490 <curproc>
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104845:	3b 58 04             	cmp    0x4(%eax),%ebx
  104848:	73 2e                	jae    104878 <argstr+0x58>
    return -1;
  *pp = p->mem + addr;
  10484a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10484d:	03 18                	add    (%eax),%ebx
  10484f:	89 1a                	mov    %ebx,(%edx)
  ep = p->mem + p->sz;
  104851:	8b 08                	mov    (%eax),%ecx
  104853:	03 48 04             	add    0x4(%eax),%ecx
  for(s = *pp; s < ep; s++)
  104856:	39 cb                	cmp    %ecx,%ebx
  104858:	73 1e                	jae    104878 <argstr+0x58>
    if(*s == 0)
  10485a:	31 c0                	xor    %eax,%eax
  10485c:	89 da                	mov    %ebx,%edx
  10485e:	80 3b 00             	cmpb   $0x0,(%ebx)
  104861:	75 0a                	jne    10486d <argstr+0x4d>
  104863:	eb 18                	jmp    10487d <argstr+0x5d>
  104865:	8d 76 00             	lea    0x0(%esi),%esi
  104868:	80 3a 00             	cmpb   $0x0,(%edx)
  10486b:	74 1b                	je     104888 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10486d:	83 c2 01             	add    $0x1,%edx
  104870:	39 d1                	cmp    %edx,%ecx
  104872:	77 f4                	ja     104868 <argstr+0x48>
  104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10487d:	83 c4 24             	add    $0x24,%esp
  104880:	5b                   	pop    %ebx
  104881:	5d                   	pop    %ebp
  104882:	c3                   	ret    
  104883:	90                   	nop
  104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  104888:	89 d0                	mov    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10488a:	83 c4 24             	add    $0x24,%esp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10488d:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(cp, addr, pp);
}
  10488f:	5b                   	pop    %ebx
  104890:	5d                   	pop    %ebp
  104891:	c3                   	ret    
  104892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001048a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	53                   	push   %ebx
  1048a4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1048a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1048aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1048b1:	89 04 24             	mov    %eax,(%esp)
  1048b4:	e8 17 ff ff ff       	call   1047d0 <argint>
  1048b9:	85 c0                	test   %eax,%eax
  1048bb:	79 0b                	jns    1048c8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048c2:	83 c4 24             	add    $0x24,%esp
  1048c5:	5b                   	pop    %ebx
  1048c6:	5d                   	pop    %ebp
  1048c7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1048c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1048cb:	e8 c0 eb ff ff       	call   103490 <curproc>
  1048d0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1048d3:	73 e8                	jae    1048bd <argptr+0x1d>
  1048d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1048d8:	03 5d f4             	add    -0xc(%ebp),%ebx
  1048db:	e8 b0 eb ff ff       	call   103490 <curproc>
  1048e0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1048e3:	73 d8                	jae    1048bd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1048e5:	e8 a6 eb ff ff       	call   103490 <curproc>
  1048ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048ed:	8b 00                	mov    (%eax),%eax
  1048ef:	03 45 f4             	add    -0xc(%ebp),%eax
  1048f2:	89 02                	mov    %eax,(%edx)
  1048f4:	31 c0                	xor    %eax,%eax
  return 0;
  1048f6:	eb ca                	jmp    1048c2 <argptr+0x22>
  1048f8:	90                   	nop
  1048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104900 <syscall>:
[SYS_wait_thread] sys_wait_thread,
};

void
syscall(void)
{
  104900:	55                   	push   %ebp
  104901:	89 e5                	mov    %esp,%ebp
  104903:	83 ec 18             	sub    $0x18,%esp
  104906:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104909:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  10490c:	e8 7f eb ff ff       	call   103490 <curproc>
  104911:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104917:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  10491a:	83 fb 18             	cmp    $0x18,%ebx
  10491d:	77 29                	ja     104948 <syscall+0x48>
  10491f:	8b 34 9d 80 6b 10 00 	mov    0x106b80(,%ebx,4),%esi
  104926:	85 f6                	test   %esi,%esi
  104928:	74 1e                	je     104948 <syscall+0x48>
    cp->tf->eax = syscalls[num]();
  10492a:	e8 61 eb ff ff       	call   103490 <curproc>
  10492f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104935:	ff d6                	call   *%esi
  104937:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10493a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10493d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104940:	89 ec                	mov    %ebp,%esp
  104942:	5d                   	pop    %ebp
  104943:	c3                   	ret    
  104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
  104948:	e8 43 eb ff ff       	call   103490 <curproc>
  10494d:	89 c6                	mov    %eax,%esi
  10494f:	e8 3c eb ff ff       	call   103490 <curproc>
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104954:	81 c6 88 00 00 00    	add    $0x88,%esi
  10495a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10495e:	89 74 24 08          	mov    %esi,0x8(%esp)
  104962:	8b 40 10             	mov    0x10(%eax),%eax
  104965:	c7 04 24 4e 6b 10 00 	movl   $0x106b4e,(%esp)
  10496c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104970:	e8 2b be ff ff       	call   1007a0 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104975:	e8 16 eb ff ff       	call   103490 <curproc>
  10497a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104980:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104987:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10498a:	8b 75 fc             	mov    -0x4(%ebp),%esi
  10498d:	89 ec                	mov    %ebp,%esp
  10498f:	5d                   	pop    %ebp
  104990:	c3                   	ret    
  104991:	90                   	nop
  104992:	90                   	nop
  104993:	90                   	nop
  104994:	90                   	nop
  104995:	90                   	nop
  104996:	90                   	nop
  104997:	90                   	nop
  104998:	90                   	nop
  104999:	90                   	nop
  10499a:	90                   	nop
  10499b:	90                   	nop
  10499c:	90                   	nop
  10499d:	90                   	nop
  10499e:	90                   	nop
  10499f:	90                   	nop

001049a0 <fdalloc>:
  1049a0:	55                   	push   %ebp
  1049a1:	89 e5                	mov    %esp,%ebp
  1049a3:	57                   	push   %edi
  1049a4:	89 c7                	mov    %eax,%edi
  1049a6:	56                   	push   %esi
  1049a7:	53                   	push   %ebx
  1049a8:	31 db                	xor    %ebx,%ebx
  1049aa:	83 ec 0c             	sub    $0xc,%esp
  1049ad:	8d 76 00             	lea    0x0(%esi),%esi
  1049b0:	e8 db ea ff ff       	call   103490 <curproc>
  1049b5:	8d 73 08             	lea    0x8(%ebx),%esi
  1049b8:	8b 04 b0             	mov    (%eax,%esi,4),%eax
  1049bb:	85 c0                	test   %eax,%eax
  1049bd:	74 19                	je     1049d8 <fdalloc+0x38>
  1049bf:	83 c3 01             	add    $0x1,%ebx
  1049c2:	83 fb 10             	cmp    $0x10,%ebx
  1049c5:	75 e9                	jne    1049b0 <fdalloc+0x10>
  1049c7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1049cc:	83 c4 0c             	add    $0xc,%esp
  1049cf:	89 d8                	mov    %ebx,%eax
  1049d1:	5b                   	pop    %ebx
  1049d2:	5e                   	pop    %esi
  1049d3:	5f                   	pop    %edi
  1049d4:	5d                   	pop    %ebp
  1049d5:	c3                   	ret    
  1049d6:	66 90                	xchg   %ax,%ax
  1049d8:	e8 b3 ea ff ff       	call   103490 <curproc>
  1049dd:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  1049e0:	83 c4 0c             	add    $0xc,%esp
  1049e3:	89 d8                	mov    %ebx,%eax
  1049e5:	5b                   	pop    %ebx
  1049e6:	5e                   	pop    %esi
  1049e7:	5f                   	pop    %edi
  1049e8:	5d                   	pop    %ebp
  1049e9:	c3                   	ret    
  1049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001049f0 <sys_pipe>:
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	53                   	push   %ebx
  1049f4:	83 ec 24             	sub    $0x24,%esp
  1049f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1049fa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104a01:	00 
  104a02:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a0d:	e8 8e fe ff ff       	call   1048a0 <argptr>
  104a12:	85 c0                	test   %eax,%eax
  104a14:	79 12                	jns    104a28 <sys_pipe+0x38>
  104a16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104a1b:	83 c4 24             	add    $0x24,%esp
  104a1e:	5b                   	pop    %ebx
  104a1f:	5d                   	pop    %ebp
  104a20:	c3                   	ret    
  104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104a28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104a32:	89 04 24             	mov    %eax,(%esp)
  104a35:	e8 e6 e6 ff ff       	call   103120 <pipealloc>
  104a3a:	85 c0                	test   %eax,%eax
  104a3c:	78 d8                	js     104a16 <sys_pipe+0x26>
  104a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a41:	e8 5a ff ff ff       	call   1049a0 <fdalloc>
  104a46:	85 c0                	test   %eax,%eax
  104a48:	89 c3                	mov    %eax,%ebx
  104a4a:	78 27                	js     104a73 <sys_pipe+0x83>
  104a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a4f:	e8 4c ff ff ff       	call   1049a0 <fdalloc>
  104a54:	85 c0                	test   %eax,%eax
  104a56:	89 c2                	mov    %eax,%edx
  104a58:	78 0c                	js     104a66 <sys_pipe+0x76>
  104a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104a5d:	89 18                	mov    %ebx,(%eax)
  104a5f:	89 50 04             	mov    %edx,0x4(%eax)
  104a62:	31 c0                	xor    %eax,%eax
  104a64:	eb b5                	jmp    104a1b <sys_pipe+0x2b>
  104a66:	e8 25 ea ff ff       	call   103490 <curproc>
  104a6b:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104a72:	00 
  104a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a76:	89 04 24             	mov    %eax,(%esp)
  104a79:	e8 c2 c5 ff ff       	call   101040 <fileclose>
  104a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a81:	89 04 24             	mov    %eax,(%esp)
  104a84:	e8 b7 c5 ff ff       	call   101040 <fileclose>
  104a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104a8e:	eb 8b                	jmp    104a1b <sys_pipe+0x2b>

00104a90 <argfd>:
  104a90:	55                   	push   %ebp
  104a91:	89 e5                	mov    %esp,%ebp
  104a93:	83 ec 28             	sub    $0x28,%esp
  104a96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a99:	89 d3                	mov    %edx,%ebx
  104a9b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104a9e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104aa1:	89 ce                	mov    %ecx,%esi
  104aa3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104aa7:	89 04 24             	mov    %eax,(%esp)
  104aaa:	e8 21 fd ff ff       	call   1047d0 <argint>
  104aaf:	85 c0                	test   %eax,%eax
  104ab1:	79 15                	jns    104ac8 <argfd+0x38>
  104ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ab8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104abb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104abe:	89 ec                	mov    %ebp,%esp
  104ac0:	5d                   	pop    %ebp
  104ac1:	c3                   	ret    
  104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ac8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104acc:	77 e5                	ja     104ab3 <argfd+0x23>
  104ace:	e8 bd e9 ff ff       	call   103490 <curproc>
  104ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ad6:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104ada:	85 c9                	test   %ecx,%ecx
  104adc:	74 d5                	je     104ab3 <argfd+0x23>
  104ade:	85 db                	test   %ebx,%ebx
  104ae0:	74 02                	je     104ae4 <argfd+0x54>
  104ae2:	89 13                	mov    %edx,(%ebx)
  104ae4:	31 c0                	xor    %eax,%eax
  104ae6:	85 f6                	test   %esi,%esi
  104ae8:	74 ce                	je     104ab8 <argfd+0x28>
  104aea:	89 0e                	mov    %ecx,(%esi)
  104aec:	31 c0                	xor    %eax,%eax
  104aee:	eb c8                	jmp    104ab8 <argfd+0x28>

00104af0 <sys_close>:
  104af0:	55                   	push   %ebp
  104af1:	31 c0                	xor    %eax,%eax
  104af3:	89 e5                	mov    %esp,%ebp
  104af5:	83 ec 18             	sub    $0x18,%esp
  104af8:	8d 55 fc             	lea    -0x4(%ebp),%edx
  104afb:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104afe:	e8 8d ff ff ff       	call   104a90 <argfd>
  104b03:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104b08:	85 c0                	test   %eax,%eax
  104b0a:	78 1d                	js     104b29 <sys_close+0x39>
  104b0c:	e8 7f e9 ff ff       	call   103490 <curproc>
  104b11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104b14:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  104b1b:	00 
  104b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104b1f:	89 04 24             	mov    %eax,(%esp)
  104b22:	e8 19 c5 ff ff       	call   101040 <fileclose>
  104b27:	31 d2                	xor    %edx,%edx
  104b29:	89 d0                	mov    %edx,%eax
  104b2b:	c9                   	leave  
  104b2c:	c3                   	ret    
  104b2d:	8d 76 00             	lea    0x0(%esi),%esi

00104b30 <sys_exec>:
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	83 ec 78             	sub    $0x78,%esp
  104b36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104b39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  104b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b4d:	e8 ce fc ff ff       	call   104820 <argstr>
  104b52:	85 c0                	test   %eax,%eax
  104b54:	79 12                	jns    104b68 <sys_exec+0x38>
  104b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104b5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b64:	89 ec                	mov    %ebp,%esp
  104b66:	5d                   	pop    %ebp
  104b67:	c3                   	ret    
  104b68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b76:	e8 55 fc ff ff       	call   1047d0 <argint>
  104b7b:	85 c0                	test   %eax,%eax
  104b7d:	78 d7                	js     104b56 <sys_exec+0x26>
  104b7f:	8d 45 98             	lea    -0x68(%ebp),%eax
  104b82:	31 f6                	xor    %esi,%esi
  104b84:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104b8b:	00 
  104b8c:	31 ff                	xor    %edi,%edi
  104b8e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b95:	00 
  104b96:	89 04 24             	mov    %eax,(%esp)
  104b99:	e8 62 f9 ff ff       	call   104500 <memset>
  104b9e:	eb 27                	jmp    104bc7 <sys_exec+0x97>
  104ba0:	e8 eb e8 ff ff       	call   103490 <curproc>
  104ba5:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104ba9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104bad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104bb1:	89 04 24             	mov    %eax,(%esp)
  104bb4:	e8 c7 fb ff ff       	call   104780 <fetchstr>
  104bb9:	85 c0                	test   %eax,%eax
  104bbb:	78 99                	js     104b56 <sys_exec+0x26>
  104bbd:	83 c6 01             	add    $0x1,%esi
  104bc0:	83 fe 14             	cmp    $0x14,%esi
  104bc3:	89 f7                	mov    %esi,%edi
  104bc5:	74 8f                	je     104b56 <sys_exec+0x26>
  104bc7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104bce:	03 5d ec             	add    -0x14(%ebp),%ebx
  104bd1:	e8 ba e8 ff ff       	call   103490 <curproc>
  104bd6:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104bd9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104bdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104be1:	89 04 24             	mov    %eax,(%esp)
  104be4:	e8 57 fb ff ff       	call   104740 <fetchint>
  104be9:	85 c0                	test   %eax,%eax
  104beb:	0f 88 65 ff ff ff    	js     104b56 <sys_exec+0x26>
  104bf1:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104bf4:	85 db                	test   %ebx,%ebx
  104bf6:	75 a8                	jne    104ba0 <sys_exec+0x70>
  104bf8:	8d 45 98             	lea    -0x68(%ebp),%eax
  104bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c02:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104c09:	00 
  104c0a:	89 04 24             	mov    %eax,(%esp)
  104c0d:	e8 de bd ff ff       	call   1009f0 <exec>
  104c12:	e9 44 ff ff ff       	jmp    104b5b <sys_exec+0x2b>
  104c17:	89 f6                	mov    %esi,%esi
  104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104c20 <sys_chdir>:
  104c20:	55                   	push   %ebp
  104c21:	89 e5                	mov    %esp,%ebp
  104c23:	53                   	push   %ebx
  104c24:	83 ec 24             	sub    $0x24,%esp
  104c27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c35:	e8 e6 fb ff ff       	call   104820 <argstr>
  104c3a:	85 c0                	test   %eax,%eax
  104c3c:	79 12                	jns    104c50 <sys_chdir+0x30>
  104c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104c43:	83 c4 24             	add    $0x24,%esp
  104c46:	5b                   	pop    %ebx
  104c47:	5d                   	pop    %ebp
  104c48:	c3                   	ret    
  104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c53:	89 04 24             	mov    %eax,(%esp)
  104c56:	e8 55 d3 ff ff       	call   101fb0 <namei>
  104c5b:	85 c0                	test   %eax,%eax
  104c5d:	89 c3                	mov    %eax,%ebx
  104c5f:	74 dd                	je     104c3e <sys_chdir+0x1e>
  104c61:	89 04 24             	mov    %eax,(%esp)
  104c64:	e8 97 d0 ff ff       	call   101d00 <ilock>
  104c69:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104c6e:	75 24                	jne    104c94 <sys_chdir+0x74>
  104c70:	89 1c 24             	mov    %ebx,(%esp)
  104c73:	e8 08 d0 ff ff       	call   101c80 <iunlock>
  104c78:	e8 13 e8 ff ff       	call   103490 <curproc>
  104c7d:	8b 40 60             	mov    0x60(%eax),%eax
  104c80:	89 04 24             	mov    %eax,(%esp)
  104c83:	e8 a8 cd ff ff       	call   101a30 <iput>
  104c88:	e8 03 e8 ff ff       	call   103490 <curproc>
  104c8d:	89 58 60             	mov    %ebx,0x60(%eax)
  104c90:	31 c0                	xor    %eax,%eax
  104c92:	eb af                	jmp    104c43 <sys_chdir+0x23>
  104c94:	89 1c 24             	mov    %ebx,(%esp)
  104c97:	e8 44 d0 ff ff       	call   101ce0 <iunlockput>
  104c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ca1:	eb a0                	jmp    104c43 <sys_chdir+0x23>
  104ca3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104cb0 <sys_link>:
  104cb0:	55                   	push   %ebp
  104cb1:	89 e5                	mov    %esp,%ebp
  104cb3:	83 ec 38             	sub    $0x38,%esp
  104cb6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104cb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104cbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104cbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  104cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ccd:	e8 4e fb ff ff       	call   104820 <argstr>
  104cd2:	85 c0                	test   %eax,%eax
  104cd4:	79 12                	jns    104ce8 <sys_link+0x38>
  104cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104cdb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104cde:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104ce1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104ce4:	89 ec                	mov    %ebp,%esp
  104ce6:	5d                   	pop    %ebp
  104ce7:	c3                   	ret    
  104ce8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104cef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cf6:	e8 25 fb ff ff       	call   104820 <argstr>
  104cfb:	85 c0                	test   %eax,%eax
  104cfd:	78 d7                	js     104cd6 <sys_link+0x26>
  104cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d02:	89 04 24             	mov    %eax,(%esp)
  104d05:	e8 a6 d2 ff ff       	call   101fb0 <namei>
  104d0a:	85 c0                	test   %eax,%eax
  104d0c:	89 c3                	mov    %eax,%ebx
  104d0e:	74 c6                	je     104cd6 <sys_link+0x26>
  104d10:	89 04 24             	mov    %eax,(%esp)
  104d13:	e8 e8 cf ff ff       	call   101d00 <ilock>
  104d18:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104d1d:	74 58                	je     104d77 <sys_link+0xc7>
  104d1f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  104d24:	8d 7d de             	lea    -0x22(%ebp),%edi
  104d27:	89 1c 24             	mov    %ebx,(%esp)
  104d2a:	e8 61 c8 ff ff       	call   101590 <iupdate>
  104d2f:	89 1c 24             	mov    %ebx,(%esp)
  104d32:	e8 49 cf ff ff       	call   101c80 <iunlock>
  104d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d3e:	89 04 24             	mov    %eax,(%esp)
  104d41:	e8 4a d2 ff ff       	call   101f90 <nameiparent>
  104d46:	85 c0                	test   %eax,%eax
  104d48:	89 c6                	mov    %eax,%esi
  104d4a:	74 16                	je     104d62 <sys_link+0xb2>
  104d4c:	89 04 24             	mov    %eax,(%esp)
  104d4f:	e8 ac cf ff ff       	call   101d00 <ilock>
  104d54:	8b 06                	mov    (%esi),%eax
  104d56:	3b 03                	cmp    (%ebx),%eax
  104d58:	74 2f                	je     104d89 <sys_link+0xd9>
  104d5a:	89 34 24             	mov    %esi,(%esp)
  104d5d:	e8 7e cf ff ff       	call   101ce0 <iunlockput>
  104d62:	89 1c 24             	mov    %ebx,(%esp)
  104d65:	e8 96 cf ff ff       	call   101d00 <ilock>
  104d6a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  104d6f:	89 1c 24             	mov    %ebx,(%esp)
  104d72:	e8 19 c8 ff ff       	call   101590 <iupdate>
  104d77:	89 1c 24             	mov    %ebx,(%esp)
  104d7a:	e8 61 cf ff ff       	call   101ce0 <iunlockput>
  104d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104d84:	e9 52 ff ff ff       	jmp    104cdb <sys_link+0x2b>
  104d89:	8b 43 04             	mov    0x4(%ebx),%eax
  104d8c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d90:	89 34 24             	mov    %esi,(%esp)
  104d93:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d97:	e8 f4 cd ff ff       	call   101b90 <dirlink>
  104d9c:	85 c0                	test   %eax,%eax
  104d9e:	78 ba                	js     104d5a <sys_link+0xaa>
  104da0:	89 34 24             	mov    %esi,(%esp)
  104da3:	e8 38 cf ff ff       	call   101ce0 <iunlockput>
  104da8:	89 1c 24             	mov    %ebx,(%esp)
  104dab:	e8 80 cc ff ff       	call   101a30 <iput>
  104db0:	31 c0                	xor    %eax,%eax
  104db2:	e9 24 ff ff ff       	jmp    104cdb <sys_link+0x2b>
  104db7:	89 f6                	mov    %esi,%esi
  104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104dc0 <create>:
  104dc0:	55                   	push   %ebp
  104dc1:	89 e5                	mov    %esp,%ebp
  104dc3:	57                   	push   %edi
  104dc4:	89 d7                	mov    %edx,%edi
  104dc6:	56                   	push   %esi
  104dc7:	53                   	push   %ebx
  104dc8:	31 db                	xor    %ebx,%ebx
  104dca:	83 ec 3c             	sub    $0x3c,%esp
  104dcd:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104dd1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104dd5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104dd9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104ddd:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  104de1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104de4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104de8:	89 04 24             	mov    %eax,(%esp)
  104deb:	e8 a0 d1 ff ff       	call   101f90 <nameiparent>
  104df0:	85 c0                	test   %eax,%eax
  104df2:	89 c6                	mov    %eax,%esi
  104df4:	74 77                	je     104e6d <create+0xad>
  104df6:	89 04 24             	mov    %eax,(%esp)
  104df9:	e8 02 cf ff ff       	call   101d00 <ilock>
  104dfe:	85 ff                	test   %edi,%edi
  104e00:	75 76                	jne    104e78 <create+0xb8>
  104e02:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104e06:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e0a:	8b 06                	mov    (%esi),%eax
  104e0c:	89 04 24             	mov    %eax,(%esp)
  104e0f:	e8 8c ca ff ff       	call   1018a0 <ialloc>
  104e14:	85 c0                	test   %eax,%eax
  104e16:	89 c3                	mov    %eax,%ebx
  104e18:	74 4b                	je     104e65 <create+0xa5>
  104e1a:	89 04 24             	mov    %eax,(%esp)
  104e1d:	e8 de ce ff ff       	call   101d00 <ilock>
  104e22:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104e26:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104e2a:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  104e30:	66 89 43 12          	mov    %ax,0x12(%ebx)
  104e34:	66 89 53 14          	mov    %dx,0x14(%ebx)
  104e38:	89 1c 24             	mov    %ebx,(%esp)
  104e3b:	e8 50 c7 ff ff       	call   101590 <iupdate>
  104e40:	8b 43 04             	mov    0x4(%ebx),%eax
  104e43:	89 34 24             	mov    %esi,(%esp)
  104e46:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e4a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e51:	e8 3a cd ff ff       	call   101b90 <dirlink>
  104e56:	85 c0                	test   %eax,%eax
  104e58:	0f 88 d5 00 00 00    	js     104f33 <create+0x173>
  104e5e:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  104e63:	74 7b                	je     104ee0 <create+0x120>
  104e65:	89 34 24             	mov    %esi,(%esp)
  104e68:	e8 73 ce ff ff       	call   101ce0 <iunlockput>
  104e6d:	83 c4 3c             	add    $0x3c,%esp
  104e70:	89 d8                	mov    %ebx,%eax
  104e72:	5b                   	pop    %ebx
  104e73:	5e                   	pop    %esi
  104e74:	5f                   	pop    %edi
  104e75:	5d                   	pop    %ebp
  104e76:	c3                   	ret    
  104e77:	90                   	nop
  104e78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e7f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104e82:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e86:	89 34 24             	mov    %esi,(%esp)
  104e89:	e8 02 c9 ff ff       	call   101790 <dirlookup>
  104e8e:	85 c0                	test   %eax,%eax
  104e90:	89 c3                	mov    %eax,%ebx
  104e92:	0f 84 6a ff ff ff    	je     104e02 <create+0x42>
  104e98:	89 34 24             	mov    %esi,(%esp)
  104e9b:	e8 40 ce ff ff       	call   101ce0 <iunlockput>
  104ea0:	89 1c 24             	mov    %ebx,(%esp)
  104ea3:	e8 58 ce ff ff       	call   101d00 <ilock>
  104ea8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104eac:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104eb0:	75 0a                	jne    104ebc <create+0xfc>
  104eb2:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104eb6:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104eba:	74 14                	je     104ed0 <create+0x110>
  104ebc:	89 1c 24             	mov    %ebx,(%esp)
  104ebf:	31 db                	xor    %ebx,%ebx
  104ec1:	e8 1a ce ff ff       	call   101ce0 <iunlockput>
  104ec6:	83 c4 3c             	add    $0x3c,%esp
  104ec9:	89 d8                	mov    %ebx,%eax
  104ecb:	5b                   	pop    %ebx
  104ecc:	5e                   	pop    %esi
  104ecd:	5f                   	pop    %edi
  104ece:	5d                   	pop    %ebp
  104ecf:	c3                   	ret    
  104ed0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104ed4:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104ed8:	75 e2                	jne    104ebc <create+0xfc>
  104eda:	eb 91                	jmp    104e6d <create+0xad>
  104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104ee0:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
  104ee5:	89 34 24             	mov    %esi,(%esp)
  104ee8:	e8 a3 c6 ff ff       	call   101590 <iupdate>
  104eed:	8b 43 04             	mov    0x4(%ebx),%eax
  104ef0:	c7 44 24 04 e5 6b 10 	movl   $0x106be5,0x4(%esp)
  104ef7:	00 
  104ef8:	89 1c 24             	mov    %ebx,(%esp)
  104efb:	89 44 24 08          	mov    %eax,0x8(%esp)
  104eff:	e8 8c cc ff ff       	call   101b90 <dirlink>
  104f04:	85 c0                	test   %eax,%eax
  104f06:	78 1f                	js     104f27 <create+0x167>
  104f08:	8b 46 04             	mov    0x4(%esi),%eax
  104f0b:	c7 44 24 04 e4 6b 10 	movl   $0x106be4,0x4(%esp)
  104f12:	00 
  104f13:	89 1c 24             	mov    %ebx,(%esp)
  104f16:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f1a:	e8 71 cc ff ff       	call   101b90 <dirlink>
  104f1f:	85 c0                	test   %eax,%eax
  104f21:	0f 89 3e ff ff ff    	jns    104e65 <create+0xa5>
  104f27:	c7 04 24 e7 6b 10 00 	movl   $0x106be7,(%esp)
  104f2e:	e8 3d ba ff ff       	call   100970 <panic>
  104f33:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
  104f39:	89 1c 24             	mov    %ebx,(%esp)
  104f3c:	31 db                	xor    %ebx,%ebx
  104f3e:	e8 9d cd ff ff       	call   101ce0 <iunlockput>
  104f43:	89 34 24             	mov    %esi,(%esp)
  104f46:	e8 95 cd ff ff       	call   101ce0 <iunlockput>
  104f4b:	e9 1d ff ff ff       	jmp    104e6d <create+0xad>

00104f50 <sys_mkdir>:
  104f50:	55                   	push   %ebp
  104f51:	89 e5                	mov    %esp,%ebp
  104f53:	83 ec 18             	sub    $0x18,%esp
  104f56:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f64:	e8 b7 f8 ff ff       	call   104820 <argstr>
  104f69:	85 c0                	test   %eax,%eax
  104f6b:	79 0b                	jns    104f78 <sys_mkdir+0x28>
  104f6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104f72:	c9                   	leave  
  104f73:	c3                   	ret    
  104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104f7b:	31 d2                	xor    %edx,%edx
  104f7d:	b9 01 00 00 00       	mov    $0x1,%ecx
  104f82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f89:	00 
  104f8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104f91:	e8 2a fe ff ff       	call   104dc0 <create>
  104f96:	85 c0                	test   %eax,%eax
  104f98:	74 d3                	je     104f6d <sys_mkdir+0x1d>
  104f9a:	89 04 24             	mov    %eax,(%esp)
  104f9d:	e8 3e cd ff ff       	call   101ce0 <iunlockput>
  104fa2:	31 c0                	xor    %eax,%eax
  104fa4:	c9                   	leave  
  104fa5:	8d 76 00             	lea    0x0(%esi),%esi
  104fa8:	c3                   	ret    
  104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104fb0 <sys_mknod>:
  104fb0:	55                   	push   %ebp
  104fb1:	89 e5                	mov    %esp,%ebp
  104fb3:	83 ec 18             	sub    $0x18,%esp
  104fb6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fc4:	e8 57 f8 ff ff       	call   104820 <argstr>
  104fc9:	85 c0                	test   %eax,%eax
  104fcb:	79 0b                	jns    104fd8 <sys_mknod+0x28>
  104fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104fd2:	c9                   	leave  
  104fd3:	c3                   	ret    
  104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104fd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fe6:	e8 e5 f7 ff ff       	call   1047d0 <argint>
  104feb:	85 c0                	test   %eax,%eax
  104fed:	78 de                	js     104fcd <sys_mknod+0x1d>
  104fef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ff6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104ffd:	e8 ce f7 ff ff       	call   1047d0 <argint>
  105002:	85 c0                	test   %eax,%eax
  105004:	78 c7                	js     104fcd <sys_mknod+0x1d>
  105006:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  10500a:	b9 03 00 00 00       	mov    $0x3,%ecx
  10500f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105012:	89 54 24 04          	mov    %edx,0x4(%esp)
  105016:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  10501a:	89 14 24             	mov    %edx,(%esp)
  10501d:	31 d2                	xor    %edx,%edx
  10501f:	e8 9c fd ff ff       	call   104dc0 <create>
  105024:	85 c0                	test   %eax,%eax
  105026:	74 a5                	je     104fcd <sys_mknod+0x1d>
  105028:	89 04 24             	mov    %eax,(%esp)
  10502b:	e8 b0 cc ff ff       	call   101ce0 <iunlockput>
  105030:	31 c0                	xor    %eax,%eax
  105032:	c9                   	leave  
  105033:	90                   	nop
  105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105038:	c3                   	ret    
  105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105040 <sys_open>:
  105040:	55                   	push   %ebp
  105041:	89 e5                	mov    %esp,%ebp
  105043:	83 ec 28             	sub    $0x28,%esp
  105046:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105049:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10504c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10504f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105052:	89 44 24 04          	mov    %eax,0x4(%esp)
  105056:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10505d:	e8 be f7 ff ff       	call   104820 <argstr>
  105062:	85 c0                	test   %eax,%eax
  105064:	79 1a                	jns    105080 <sys_open+0x40>
  105066:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10506b:	89 d8                	mov    %ebx,%eax
  10506d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105070:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105073:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105076:	89 ec                	mov    %ebp,%esp
  105078:	5d                   	pop    %ebp
  105079:	c3                   	ret    
  10507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105080:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105083:	89 44 24 04          	mov    %eax,0x4(%esp)
  105087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10508e:	e8 3d f7 ff ff       	call   1047d0 <argint>
  105093:	85 c0                	test   %eax,%eax
  105095:	78 cf                	js     105066 <sys_open+0x26>
  105097:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  10509b:	74 5b                	je     1050f8 <sys_open+0xb8>
  10509d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050a0:	b9 02 00 00 00       	mov    $0x2,%ecx
  1050a5:	ba 01 00 00 00       	mov    $0x1,%edx
  1050aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1050b1:	00 
  1050b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050b9:	e8 02 fd ff ff       	call   104dc0 <create>
  1050be:	85 c0                	test   %eax,%eax
  1050c0:	89 c7                	mov    %eax,%edi
  1050c2:	74 a2                	je     105066 <sys_open+0x26>
  1050c4:	e8 f7 be ff ff       	call   100fc0 <filealloc>
  1050c9:	85 c0                	test   %eax,%eax
  1050cb:	89 c6                	mov    %eax,%esi
  1050cd:	74 13                	je     1050e2 <sys_open+0xa2>
  1050cf:	e8 cc f8 ff ff       	call   1049a0 <fdalloc>
  1050d4:	85 c0                	test   %eax,%eax
  1050d6:	89 c3                	mov    %eax,%ebx
  1050d8:	79 56                	jns    105130 <sys_open+0xf0>
  1050da:	89 34 24             	mov    %esi,(%esp)
  1050dd:	e8 5e bf ff ff       	call   101040 <fileclose>
  1050e2:	89 3c 24             	mov    %edi,(%esp)
  1050e5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1050ea:	e8 f1 cb ff ff       	call   101ce0 <iunlockput>
  1050ef:	e9 77 ff ff ff       	jmp    10506b <sys_open+0x2b>
  1050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1050f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050fb:	89 04 24             	mov    %eax,(%esp)
  1050fe:	e8 ad ce ff ff       	call   101fb0 <namei>
  105103:	85 c0                	test   %eax,%eax
  105105:	89 c7                	mov    %eax,%edi
  105107:	0f 84 59 ff ff ff    	je     105066 <sys_open+0x26>
  10510d:	89 04 24             	mov    %eax,(%esp)
  105110:	e8 eb cb ff ff       	call   101d00 <ilock>
  105115:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  10511a:	75 a8                	jne    1050c4 <sys_open+0x84>
  10511c:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  105120:	74 a2                	je     1050c4 <sys_open+0x84>
  105122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105128:	eb b8                	jmp    1050e2 <sys_open+0xa2>
  10512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105130:	89 3c 24             	mov    %edi,(%esp)
  105133:	90                   	nop
  105134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105138:	e8 43 cb ff ff       	call   101c80 <iunlock>
  10513d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105140:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  105146:	89 7e 10             	mov    %edi,0x10(%esi)
  105149:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  105150:	89 d0                	mov    %edx,%eax
  105152:	83 f0 01             	xor    $0x1,%eax
  105155:	83 e0 01             	and    $0x1,%eax
  105158:	83 e2 03             	and    $0x3,%edx
  10515b:	88 46 08             	mov    %al,0x8(%esi)
  10515e:	0f 95 46 09          	setne  0x9(%esi)
  105162:	e9 04 ff ff ff       	jmp    10506b <sys_open+0x2b>
  105167:	89 f6                	mov    %esi,%esi
  105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105170 <sys_unlink>:
  105170:	55                   	push   %ebp
  105171:	89 e5                	mov    %esp,%ebp
  105173:	83 ec 68             	sub    $0x68,%esp
  105176:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105179:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10517c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10517f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105182:	89 44 24 04          	mov    %eax,0x4(%esp)
  105186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10518d:	e8 8e f6 ff ff       	call   104820 <argstr>
  105192:	85 c0                	test   %eax,%eax
  105194:	79 12                	jns    1051a8 <sys_unlink+0x38>
  105196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10519b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10519e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1051a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1051a4:	89 ec                	mov    %ebp,%esp
  1051a6:	5d                   	pop    %ebp
  1051a7:	c3                   	ret    
  1051a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051ab:	8d 5d de             	lea    -0x22(%ebp),%ebx
  1051ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1051b2:	89 04 24             	mov    %eax,(%esp)
  1051b5:	e8 d6 cd ff ff       	call   101f90 <nameiparent>
  1051ba:	85 c0                	test   %eax,%eax
  1051bc:	89 c7                	mov    %eax,%edi
  1051be:	74 d6                	je     105196 <sys_unlink+0x26>
  1051c0:	89 04 24             	mov    %eax,(%esp)
  1051c3:	e8 38 cb ff ff       	call   101d00 <ilock>
  1051c8:	c7 44 24 04 e5 6b 10 	movl   $0x106be5,0x4(%esp)
  1051cf:	00 
  1051d0:	89 1c 24             	mov    %ebx,(%esp)
  1051d3:	e8 88 c5 ff ff       	call   101760 <namecmp>
  1051d8:	85 c0                	test   %eax,%eax
  1051da:	74 14                	je     1051f0 <sys_unlink+0x80>
  1051dc:	c7 44 24 04 e4 6b 10 	movl   $0x106be4,0x4(%esp)
  1051e3:	00 
  1051e4:	89 1c 24             	mov    %ebx,(%esp)
  1051e7:	e8 74 c5 ff ff       	call   101760 <namecmp>
  1051ec:	85 c0                	test   %eax,%eax
  1051ee:	75 18                	jne    105208 <sys_unlink+0x98>
  1051f0:	89 3c 24             	mov    %edi,(%esp)
  1051f3:	e8 e8 ca ff ff       	call   101ce0 <iunlockput>
  1051f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1051fd:	8d 76 00             	lea    0x0(%esi),%esi
  105200:	eb 99                	jmp    10519b <sys_unlink+0x2b>
  105202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105208:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10520b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10520f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105213:	89 3c 24             	mov    %edi,(%esp)
  105216:	e8 75 c5 ff ff       	call   101790 <dirlookup>
  10521b:	85 c0                	test   %eax,%eax
  10521d:	89 c6                	mov    %eax,%esi
  10521f:	74 cf                	je     1051f0 <sys_unlink+0x80>
  105221:	89 04 24             	mov    %eax,(%esp)
  105224:	e8 d7 ca ff ff       	call   101d00 <ilock>
  105229:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  10522e:	0f 8e d4 00 00 00    	jle    105308 <sys_unlink+0x198>
  105234:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105240:	75 5b                	jne    10529d <sys_unlink+0x12d>
  105242:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105246:	66 90                	xchg   %ax,%ax
  105248:	76 53                	jbe    10529d <sys_unlink+0x12d>
  10524a:	bb 20 00 00 00       	mov    $0x20,%ebx
  10524f:	90                   	nop
  105250:	eb 10                	jmp    105262 <sys_unlink+0xf2>
  105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105258:	83 c3 10             	add    $0x10,%ebx
  10525b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  10525e:	66 90                	xchg   %ax,%ax
  105260:	73 3b                	jae    10529d <sys_unlink+0x12d>
  105262:	8d 45 be             	lea    -0x42(%ebp),%eax
  105265:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  10526c:	00 
  10526d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105271:	89 44 24 04          	mov    %eax,0x4(%esp)
  105275:	89 34 24             	mov    %esi,(%esp)
  105278:	e8 03 c2 ff ff       	call   101480 <readi>
  10527d:	83 f8 10             	cmp    $0x10,%eax
  105280:	75 7a                	jne    1052fc <sys_unlink+0x18c>
  105282:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  105287:	74 cf                	je     105258 <sys_unlink+0xe8>
  105289:	89 34 24             	mov    %esi,(%esp)
  10528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105290:	e8 4b ca ff ff       	call   101ce0 <iunlockput>
  105295:	8d 76 00             	lea    0x0(%esi),%esi
  105298:	e9 53 ff ff ff       	jmp    1051f0 <sys_unlink+0x80>
  10529d:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  1052a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1052a7:	00 
  1052a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052af:	00 
  1052b0:	89 1c 24             	mov    %ebx,(%esp)
  1052b3:	e8 48 f2 ff ff       	call   104500 <memset>
  1052b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052bb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1052c2:	00 
  1052c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1052c7:	89 3c 24             	mov    %edi,(%esp)
  1052ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052ce:	e8 4d c3 ff ff       	call   101620 <writei>
  1052d3:	83 f8 10             	cmp    $0x10,%eax
  1052d6:	75 3c                	jne    105314 <sys_unlink+0x1a4>
  1052d8:	89 3c 24             	mov    %edi,(%esp)
  1052db:	e8 00 ca ff ff       	call   101ce0 <iunlockput>
  1052e0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  1052e5:	89 34 24             	mov    %esi,(%esp)
  1052e8:	e8 a3 c2 ff ff       	call   101590 <iupdate>
  1052ed:	89 34 24             	mov    %esi,(%esp)
  1052f0:	e8 eb c9 ff ff       	call   101ce0 <iunlockput>
  1052f5:	31 c0                	xor    %eax,%eax
  1052f7:	e9 9f fe ff ff       	jmp    10519b <sys_unlink+0x2b>
  1052fc:	c7 04 24 05 6c 10 00 	movl   $0x106c05,(%esp)
  105303:	e8 68 b6 ff ff       	call   100970 <panic>
  105308:	c7 04 24 f3 6b 10 00 	movl   $0x106bf3,(%esp)
  10530f:	e8 5c b6 ff ff       	call   100970 <panic>
  105314:	c7 04 24 17 6c 10 00 	movl   $0x106c17,(%esp)
  10531b:	e8 50 b6 ff ff       	call   100970 <panic>

00105320 <sys_fstat>:
  105320:	55                   	push   %ebp
  105321:	31 d2                	xor    %edx,%edx
  105323:	89 e5                	mov    %esp,%ebp
  105325:	31 c0                	xor    %eax,%eax
  105327:	83 ec 28             	sub    $0x28,%esp
  10532a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10532d:	e8 5e f7 ff ff       	call   104a90 <argfd>
  105332:	85 c0                	test   %eax,%eax
  105334:	79 0a                	jns    105340 <sys_fstat+0x20>
  105336:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10533b:	c9                   	leave  
  10533c:	c3                   	ret    
  10533d:	8d 76 00             	lea    0x0(%esi),%esi
  105340:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105343:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  10534a:	00 
  10534b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10534f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105356:	e8 45 f5 ff ff       	call   1048a0 <argptr>
  10535b:	85 c0                	test   %eax,%eax
  10535d:	78 d7                	js     105336 <sys_fstat+0x16>
  10535f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105362:	89 44 24 04          	mov    %eax,0x4(%esp)
  105366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105369:	89 04 24             	mov    %eax,(%esp)
  10536c:	e8 af bb ff ff       	call   100f20 <filestat>
  105371:	c9                   	leave  
  105372:	c3                   	ret    
  105373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105380 <sys_dup>:
  105380:	55                   	push   %ebp
  105381:	31 d2                	xor    %edx,%edx
  105383:	89 e5                	mov    %esp,%ebp
  105385:	31 c0                	xor    %eax,%eax
  105387:	53                   	push   %ebx
  105388:	83 ec 14             	sub    $0x14,%esp
  10538b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10538e:	e8 fd f6 ff ff       	call   104a90 <argfd>
  105393:	85 c0                	test   %eax,%eax
  105395:	79 11                	jns    1053a8 <sys_dup+0x28>
  105397:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10539c:	89 d8                	mov    %ebx,%eax
  10539e:	83 c4 14             	add    $0x14,%esp
  1053a1:	5b                   	pop    %ebx
  1053a2:	5d                   	pop    %ebp
  1053a3:	c3                   	ret    
  1053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1053a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053ab:	e8 f0 f5 ff ff       	call   1049a0 <fdalloc>
  1053b0:	85 c0                	test   %eax,%eax
  1053b2:	89 c3                	mov    %eax,%ebx
  1053b4:	78 e1                	js     105397 <sys_dup+0x17>
  1053b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053b9:	89 04 24             	mov    %eax,(%esp)
  1053bc:	e8 af bb ff ff       	call   100f70 <filedup>
  1053c1:	eb d9                	jmp    10539c <sys_dup+0x1c>
  1053c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001053d0 <sys_write>:
  1053d0:	55                   	push   %ebp
  1053d1:	31 d2                	xor    %edx,%edx
  1053d3:	89 e5                	mov    %esp,%ebp
  1053d5:	31 c0                	xor    %eax,%eax
  1053d7:	83 ec 28             	sub    $0x28,%esp
  1053da:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1053dd:	e8 ae f6 ff ff       	call   104a90 <argfd>
  1053e2:	85 c0                	test   %eax,%eax
  1053e4:	79 0a                	jns    1053f0 <sys_write+0x20>
  1053e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1053eb:	c9                   	leave  
  1053ec:	c3                   	ret    
  1053ed:	8d 76 00             	lea    0x0(%esi),%esi
  1053f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1053f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053f7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053fe:	e8 cd f3 ff ff       	call   1047d0 <argint>
  105403:	85 c0                	test   %eax,%eax
  105405:	78 df                	js     1053e6 <sys_write+0x16>
  105407:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10540a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105411:	89 44 24 08          	mov    %eax,0x8(%esp)
  105415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105418:	89 44 24 04          	mov    %eax,0x4(%esp)
  10541c:	e8 7f f4 ff ff       	call   1048a0 <argptr>
  105421:	85 c0                	test   %eax,%eax
  105423:	78 c1                	js     1053e6 <sys_write+0x16>
  105425:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105428:	89 44 24 08          	mov    %eax,0x8(%esp)
  10542c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10542f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105433:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105436:	89 04 24             	mov    %eax,(%esp)
  105439:	e8 82 b9 ff ff       	call   100dc0 <filewrite>
  10543e:	c9                   	leave  
  10543f:	c3                   	ret    

00105440 <sys_read>:
  105440:	55                   	push   %ebp
  105441:	31 d2                	xor    %edx,%edx
  105443:	89 e5                	mov    %esp,%ebp
  105445:	31 c0                	xor    %eax,%eax
  105447:	83 ec 28             	sub    $0x28,%esp
  10544a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10544d:	e8 3e f6 ff ff       	call   104a90 <argfd>
  105452:	85 c0                	test   %eax,%eax
  105454:	79 0a                	jns    105460 <sys_read+0x20>
  105456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10545b:	c9                   	leave  
  10545c:	c3                   	ret    
  10545d:	8d 76 00             	lea    0x0(%esi),%esi
  105460:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105463:	89 44 24 04          	mov    %eax,0x4(%esp)
  105467:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10546e:	e8 5d f3 ff ff       	call   1047d0 <argint>
  105473:	85 c0                	test   %eax,%eax
  105475:	78 df                	js     105456 <sys_read+0x16>
  105477:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10547a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105481:	89 44 24 08          	mov    %eax,0x8(%esp)
  105485:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105488:	89 44 24 04          	mov    %eax,0x4(%esp)
  10548c:	e8 0f f4 ff ff       	call   1048a0 <argptr>
  105491:	85 c0                	test   %eax,%eax
  105493:	78 c1                	js     105456 <sys_read+0x16>
  105495:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105498:	89 44 24 08          	mov    %eax,0x8(%esp)
  10549c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10549f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054a6:	89 04 24             	mov    %eax,(%esp)
  1054a9:	e8 c2 b9 ff ff       	call   100e70 <fileread>
  1054ae:	c9                   	leave  
  1054af:	c3                   	ret    

001054b0 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  1054b0:	55                   	push   %ebp
return ticks;
}
  1054b1:	a1 80 ed 10 00       	mov    0x10ed80,%eax
  return 0;
}

int
sys_tick(void)
{
  1054b6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1054b8:	5d                   	pop    %ebp
  1054b9:	c3                   	ret    
  1054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054c0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1054c0:	55                   	push   %ebp
  1054c1:	89 e5                	mov    %esp,%ebp
  1054c3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1054c6:	e8 c5 df ff ff       	call   103490 <curproc>
  1054cb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1054ce:	c9                   	leave  
  1054cf:	c3                   	ret    

001054d0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1054d0:	55                   	push   %ebp
  1054d1:	89 e5                	mov    %esp,%ebp
  1054d3:	53                   	push   %ebx
  1054d4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  1054d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1054da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054e5:	e8 e6 f2 ff ff       	call   1047d0 <argint>
  1054ea:	89 c2                	mov    %eax,%edx
  1054ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1054f1:	85 d2                	test   %edx,%edx
  1054f3:	78 58                	js     10554d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  1054f5:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  1054fc:	e8 8f ef ff ff       	call   104490 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105501:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105504:	8b 1d 80 ed 10 00    	mov    0x10ed80,%ebx
  while(ticks - ticks0 < n){
  10550a:	85 d2                	test   %edx,%edx
  10550c:	7f 22                	jg     105530 <sys_sleep+0x60>
  10550e:	eb 48                	jmp    105558 <sys_sleep+0x88>
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105510:	c7 44 24 04 40 e5 10 	movl   $0x10e540,0x4(%esp)
  105517:	00 
  105518:	c7 04 24 80 ed 10 00 	movl   $0x10ed80,(%esp)
  10551f:	e8 cc e1 ff ff       	call   1036f0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105524:	a1 80 ed 10 00       	mov    0x10ed80,%eax
  105529:	29 d8                	sub    %ebx,%eax
  10552b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10552e:	7d 28                	jge    105558 <sys_sleep+0x88>
    if(cp->killed){
  105530:	e8 5b df ff ff       	call   103490 <curproc>
  105535:	8b 40 1c             	mov    0x1c(%eax),%eax
  105538:	85 c0                	test   %eax,%eax
  10553a:	74 d4                	je     105510 <sys_sleep+0x40>
      release(&tickslock);
  10553c:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  105543:	e8 08 ef ff ff       	call   104450 <release>
  105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10554d:	83 c4 24             	add    $0x24,%esp
  105550:	5b                   	pop    %ebx
  105551:	5d                   	pop    %ebp
  105552:	c3                   	ret    
  105553:	90                   	nop
  105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105558:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  10555f:	e8 ec ee ff ff       	call   104450 <release>
  return 0;
}
  105564:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105567:	31 c0                	xor    %eax,%eax
  return 0;
}
  105569:	5b                   	pop    %ebx
  10556a:	5d                   	pop    %ebp
  10556b:	c3                   	ret    
  10556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105570 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105570:	55                   	push   %ebp
  105571:	89 e5                	mov    %esp,%ebp
  105573:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105576:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105579:	89 44 24 04          	mov    %eax,0x4(%esp)
  10557d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105584:	e8 47 f2 ff ff       	call   1047d0 <argint>
  105589:	85 c0                	test   %eax,%eax
  10558b:	79 0b                	jns    105598 <sys_sbrk+0x28>
    return -1;
  if((addr = growproc(n)) < 0)
  10558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  105592:	c9                   	leave  
  105593:	c3                   	ret    
  105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  105598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10559b:	89 04 24             	mov    %eax,(%esp)
  10559e:	e8 bd e7 ff ff       	call   103d60 <growproc>
  1055a3:	85 c0                	test   %eax,%eax
  1055a5:	78 e6                	js     10558d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1055a7:	c9                   	leave  
  1055a8:	c3                   	ret    
  1055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001055b0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1055b0:	55                   	push   %ebp
  1055b1:	89 e5                	mov    %esp,%ebp
  1055b3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1055b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055c4:	e8 07 f2 ff ff       	call   1047d0 <argint>
  1055c9:	89 c2                	mov    %eax,%edx
  1055cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1055d0:	85 d2                	test   %edx,%edx
  1055d2:	78 0b                	js     1055df <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1055d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d7:	89 04 24             	mov    %eax,(%esp)
  1055da:	e8 21 dd ff ff       	call   103300 <kill>
}
  1055df:	c9                   	leave  
  1055e0:	c3                   	ret    
  1055e1:	eb 0d                	jmp    1055f0 <sys_wait>
  1055e3:	90                   	nop
  1055e4:	90                   	nop
  1055e5:	90                   	nop
  1055e6:	90                   	nop
  1055e7:	90                   	nop
  1055e8:	90                   	nop
  1055e9:	90                   	nop
  1055ea:	90                   	nop
  1055eb:	90                   	nop
  1055ec:	90                   	nop
  1055ed:	90                   	nop
  1055ee:	90                   	nop
  1055ef:	90                   	nop

001055f0 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  1055f0:	55                   	push   %ebp
  1055f1:	89 e5                	mov    %esp,%ebp
  1055f3:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  1055f6:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  1055f7:	e9 c4 e2 ff ff       	jmp    1038c0 <wait>
  1055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105600 <sys_wait_thread>:
  return 0;  // not reached
}

int
sys_wait_thread(void)
{
  105600:	55                   	push   %ebp
  105601:	89 e5                	mov    %esp,%ebp
  105603:	83 ec 08             	sub    $0x8,%esp
  return wait_thread();
}
  105606:	c9                   	leave  
}

int
sys_wait_thread(void)
{
  return wait_thread();
  105607:	e9 b4 e1 ff ff       	jmp    1037c0 <wait_thread>
  10560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105610 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105610:	55                   	push   %ebp
  105611:	89 e5                	mov    %esp,%ebp
  105613:	83 ec 08             	sub    $0x8,%esp
  exit();
  105616:	e8 75 df ff ff       	call   103590 <exit>
  return 0;  // not reached
}
  10561b:	31 c0                	xor    %eax,%eax
  10561d:	c9                   	leave  
  10561e:	c3                   	ret    
  10561f:	90                   	nop

00105620 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105620:	55                   	push   %ebp
  105621:	89 e5                	mov    %esp,%ebp
  105623:	53                   	push   %ebx
  105624:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105627:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10562a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10562e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105635:	e8 96 f1 ff ff       	call   1047d0 <argint>
  10563a:	85 c0                	test   %eax,%eax
  10563c:	79 12                	jns    105650 <sys_fork_tickets+0x30>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10563e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105643:	83 c4 24             	add    $0x24,%esp
  105646:	5b                   	pop    %ebx
  105647:	5d                   	pop    %ebp
  105648:	c3                   	ret    
  105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  105650:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105653:	e8 38 de ff ff       	call   103490 <curproc>
  105658:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10565c:	89 04 24             	mov    %eax,(%esp)
  10565f:	e8 bc e7 ff ff       	call   103e20 <copyproc_tix>
  105664:	85 c0                	test   %eax,%eax
  105666:	89 c2                	mov    %eax,%edx
  105668:	74 d4                	je     10563e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  10566a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  10566d:	8b 40 10             	mov    0x10(%eax),%eax
  np->state = RUNNABLE;
  105670:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  np->num_tix = numTix;
  105677:	89 8a 98 00 00 00    	mov    %ecx,0x98(%edx)
  return pid;
  10567d:	eb c4                	jmp    105643 <sys_fork_tickets+0x23>
  10567f:	90                   	nop

00105680 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105686:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  105689:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10568c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10568f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105692:	89 44 24 04          	mov    %eax,0x4(%esp)
  105696:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10569d:	e8 2e f1 ff ff       	call   1047d0 <argint>
  1056a2:	85 c0                	test   %eax,%eax
  1056a4:	79 12                	jns    1056b8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1056a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1056ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1056b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1056b4:	89 ec                	mov    %ebp,%esp
  1056b6:	5d                   	pop    %ebp
  1056b7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1056bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056c6:	e8 05 f1 ff ff       	call   1047d0 <argint>
  1056cb:	85 c0                	test   %eax,%eax
  1056cd:	78 d7                	js     1056a6 <sys_fork_thread+0x26>
  1056cf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1056d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056d6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1056dd:	e8 ee f0 ff ff       	call   1047d0 <argint>
  1056e2:	85 c0                	test   %eax,%eax
  1056e4:	78 c0                	js     1056a6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  1056e6:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1056e9:	8b 75 e0             	mov    -0x20(%ebp),%esi
  1056ec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  1056ef:	e8 9c dd ff ff       	call   103490 <curproc>
  1056f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1056f8:	89 74 24 08          	mov    %esi,0x8(%esp)
  1056fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105700:	89 04 24             	mov    %eax,(%esp)
  105703:	e8 58 e8 ff ff       	call   103f60 <copyproc_threads>
  105708:	89 c2                	mov    %eax,%edx
  10570a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10570f:	85 d2                	test   %edx,%edx
  105711:	74 98                	je     1056ab <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  105713:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  pid = np->pid;
  10571a:	8b 42 10             	mov    0x10(%edx),%eax
  return pid;
  10571d:	eb 8c                	jmp    1056ab <sys_fork_thread+0x2b>
  10571f:	90                   	nop

00105720 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105720:	55                   	push   %ebp
  105721:	89 e5                	mov    %esp,%ebp
  105723:	83 ec 18             	sub    $0x18,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105726:	e8 65 dd ff ff       	call   103490 <curproc>
  10572b:	89 04 24             	mov    %eax,(%esp)
  10572e:	e8 3d e9 ff ff       	call   104070 <copyproc>
  105733:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105738:	85 c0                	test   %eax,%eax
  10573a:	74 0a                	je     105746 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10573c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10573f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105746:	89 d0                	mov    %edx,%eax
  105748:	c9                   	leave  
  105749:	c3                   	ret    
  10574a:	90                   	nop
  10574b:	90                   	nop
  10574c:	90                   	nop
  10574d:	90                   	nop
  10574e:	90                   	nop
  10574f:	90                   	nop

00105750 <timer_init>:
  105750:	55                   	push   %ebp
  105751:	ba 43 00 00 00       	mov    $0x43,%edx
  105756:	89 e5                	mov    %esp,%ebp
  105758:	b8 34 00 00 00       	mov    $0x34,%eax
  10575d:	83 ec 08             	sub    $0x8,%esp
  105760:	ee                   	out    %al,(%dx)
  105761:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105766:	b2 40                	mov    $0x40,%dl
  105768:	ee                   	out    %al,(%dx)
  105769:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10576e:	ee                   	out    %al,(%dx)
  10576f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105776:	e8 55 d6 ff ff       	call   102dd0 <pic_enable>
  10577b:	c9                   	leave  
  10577c:	c3                   	ret    
  10577d:	90                   	nop
  10577e:	90                   	nop
  10577f:	90                   	nop

00105780 <alltraps>:
  105780:	1e                   	push   %ds
  105781:	06                   	push   %es
  105782:	60                   	pusha  
  105783:	b8 10 00 00 00       	mov    $0x10,%eax
  105788:	8e d8                	mov    %eax,%ds
  10578a:	8e c0                	mov    %eax,%es
  10578c:	54                   	push   %esp
  10578d:	e8 4e 00 00 00       	call   1057e0 <trap>
  105792:	83 c4 04             	add    $0x4,%esp

00105795 <trapret>:
  105795:	61                   	popa   
  105796:	07                   	pop    %es
  105797:	1f                   	pop    %ds
  105798:	83 c4 08             	add    $0x8,%esp
  10579b:	cf                   	iret   

0010579c <forkret1>:
  10579c:	8b 64 24 04          	mov    0x4(%esp),%esp
  1057a0:	e9 f0 ff ff ff       	jmp    105795 <trapret>
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

001057b0 <idtinit>:
  1057b0:	55                   	push   %ebp
  1057b1:	b8 80 e5 10 00       	mov    $0x10e580,%eax
  1057b6:	89 e5                	mov    %esp,%ebp
  1057b8:	83 ec 10             	sub    $0x10,%esp
  1057bb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  1057c1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  1057c5:	c1 e8 10             	shr    $0x10,%eax
  1057c8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  1057cc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1057cf:	0f 01 18             	lidtl  (%eax)
  1057d2:	c9                   	leave  
  1057d3:	c3                   	ret    
  1057d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1057da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001057e0 <trap>:
  1057e0:	55                   	push   %ebp
  1057e1:	89 e5                	mov    %esp,%ebp
  1057e3:	83 ec 38             	sub    $0x38,%esp
  1057e6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1057e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  1057ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1057ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1057f2:	8b 47 28             	mov    0x28(%edi),%eax
  1057f5:	83 f8 30             	cmp    $0x30,%eax
  1057f8:	0f 84 22 01 00 00    	je     105920 <trap+0x140>
  1057fe:	83 f8 21             	cmp    $0x21,%eax
  105801:	0f 84 b1 01 00 00    	je     1059b8 <trap+0x1d8>
  105807:	0f 86 a3 00 00 00    	jbe    1058b0 <trap+0xd0>
  10580d:	83 f8 2e             	cmp    $0x2e,%eax
  105810:	0f 84 52 01 00 00    	je     105968 <trap+0x188>
  105816:	83 f8 3f             	cmp    $0x3f,%eax
  105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105820:	0f 85 93 00 00 00    	jne    1058b9 <trap+0xd9>
  105826:	8b 5f 30             	mov    0x30(%edi),%ebx
  105829:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  10582d:	e8 fe d0 ff ff       	call   102930 <cpu>
  105832:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  105839:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10583d:	89 74 24 08          	mov    %esi,0x8(%esp)
  105841:	89 44 24 04          	mov    %eax,0x4(%esp)
  105845:	e8 56 af ff ff       	call   1007a0 <cprintf>
  10584a:	e8 51 cf ff ff       	call   1027a0 <lapic_eoi>
  10584f:	e8 3c dc ff ff       	call   103490 <curproc>
  105854:	85 c0                	test   %eax,%eax
  105856:	66 90                	xchg   %ax,%ax
  105858:	74 28                	je     105882 <trap+0xa2>
  10585a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105860:	e8 2b dc ff ff       	call   103490 <curproc>
  105865:	8b 40 1c             	mov    0x1c(%eax),%eax
  105868:	85 c0                	test   %eax,%eax
  10586a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105870:	74 10                	je     105882 <trap+0xa2>
  105872:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  105876:	83 e0 03             	and    $0x3,%eax
  105879:	83 f8 03             	cmp    $0x3,%eax
  10587c:	0f 84 ce 01 00 00    	je     105a50 <trap+0x270>
  105882:	e8 09 dc ff ff       	call   103490 <curproc>
  105887:	85 c0                	test   %eax,%eax
  105889:	74 17                	je     1058a2 <trap+0xc2>
  10588b:	90                   	nop
  10588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105890:	e8 fb db ff ff       	call   103490 <curproc>
  105895:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058a0:	74 66                	je     105908 <trap+0x128>
  1058a2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1058a5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1058a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1058ab:	89 ec                	mov    %ebp,%esp
  1058ad:	5d                   	pop    %ebp
  1058ae:	c3                   	ret    
  1058af:	90                   	nop
  1058b0:	83 f8 20             	cmp    $0x20,%eax
  1058b3:	0f 84 c7 00 00 00    	je     105980 <trap+0x1a0>
  1058b9:	e8 d2 db ff ff       	call   103490 <curproc>
  1058be:	85 c0                	test   %eax,%eax
  1058c0:	74 0c                	je     1058ce <trap+0xee>
  1058c2:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  1058c6:	66 90                	xchg   %ax,%ax
  1058c8:	0f 85 12 01 00 00    	jne    1059e0 <trap+0x200>
  1058ce:	8b 5f 30             	mov    0x30(%edi),%ebx
  1058d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058d8:	e8 53 d0 ff ff       	call   102930 <cpu>
  1058dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058e5:	8b 47 28             	mov    0x28(%edi),%eax
  1058e8:	c7 04 24 4c 6c 10 00 	movl   $0x106c4c,(%esp)
  1058ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f3:	e8 a8 ae ff ff       	call   1007a0 <cprintf>
  1058f8:	c7 04 24 b0 6c 10 00 	movl   $0x106cb0,(%esp)
  1058ff:	e8 6c b0 ff ff       	call   100970 <panic>
  105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105908:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  10590c:	75 94                	jne    1058a2 <trap+0xc2>
  10590e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105911:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105914:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105917:	89 ec                	mov    %ebp,%esp
  105919:	5d                   	pop    %ebp
  10591a:	e9 b1 e0 ff ff       	jmp    1039d0 <yield>
  10591f:	90                   	nop
  105920:	e8 6b db ff ff       	call   103490 <curproc>
  105925:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105928:	85 c9                	test   %ecx,%ecx
  10592a:	0f 85 a0 00 00 00    	jne    1059d0 <trap+0x1f0>
  105930:	e8 5b db ff ff       	call   103490 <curproc>
  105935:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
  10593b:	e8 c0 ef ff ff       	call   104900 <syscall>
  105940:	e8 4b db ff ff       	call   103490 <curproc>
  105945:	8b 50 1c             	mov    0x1c(%eax),%edx
  105948:	85 d2                	test   %edx,%edx
  10594a:	0f 84 52 ff ff ff    	je     1058a2 <trap+0xc2>
  105950:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105953:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105956:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105959:	89 ec                	mov    %ebp,%esp
  10595b:	5d                   	pop    %ebp
  10595c:	e9 2f dc ff ff       	jmp    103590 <exit>
  105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105968:	e8 03 c8 ff ff       	call   102170 <ide_intr>
  10596d:	e8 2e ce ff ff       	call   1027a0 <lapic_eoi>
  105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105978:	e9 d2 fe ff ff       	jmp    10584f <trap+0x6f>
  10597d:	8d 76 00             	lea    0x0(%esi),%esi
  105980:	e8 ab cf ff ff       	call   102930 <cpu>
  105985:	85 c0                	test   %eax,%eax
  105987:	90                   	nop
  105988:	75 e3                	jne    10596d <trap+0x18d>
  10598a:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  105991:	e8 fa ea ff ff       	call   104490 <acquire>
  105996:	83 05 80 ed 10 00 01 	addl   $0x1,0x10ed80
  10599d:	c7 04 24 80 ed 10 00 	movl   $0x10ed80,(%esp)
  1059a4:	e8 e7 d9 ff ff       	call   103390 <wakeup>
  1059a9:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  1059b0:	e8 9b ea ff ff       	call   104450 <release>
  1059b5:	eb b6                	jmp    10596d <trap+0x18d>
  1059b7:	90                   	nop
  1059b8:	e8 d3 cc ff ff       	call   102690 <kbd_intr>
  1059bd:	8d 76 00             	lea    0x0(%esi),%esi
  1059c0:	e8 db cd ff ff       	call   1027a0 <lapic_eoi>
  1059c5:	8d 76 00             	lea    0x0(%esi),%esi
  1059c8:	e9 82 fe ff ff       	jmp    10584f <trap+0x6f>
  1059cd:	8d 76 00             	lea    0x0(%esi),%esi
  1059d0:	e8 bb db ff ff       	call   103590 <exit>
  1059d5:	8d 76 00             	lea    0x0(%esi),%esi
  1059d8:	e9 53 ff ff ff       	jmp    105930 <trap+0x150>
  1059dd:	8d 76 00             	lea    0x0(%esi),%esi
  1059e0:	8b 47 30             	mov    0x30(%edi),%eax
  1059e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059e6:	e8 45 cf ff ff       	call   102930 <cpu>
  1059eb:	8b 57 28             	mov    0x28(%edi),%edx
  1059ee:	8b 77 2c             	mov    0x2c(%edi),%esi
  1059f1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1059f4:	89 c3                	mov    %eax,%ebx
  1059f6:	e8 95 da ff ff       	call   103490 <curproc>
  1059fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059fe:	e8 8d da ff ff       	call   103490 <curproc>
  105a03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a06:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  105a0a:	89 74 24 10          	mov    %esi,0x10(%esp)
  105a0e:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a15:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a1c:	81 c2 88 00 00 00    	add    $0x88,%edx
  105a22:	89 54 24 08          	mov    %edx,0x8(%esp)
  105a26:	8b 40 10             	mov    0x10(%eax),%eax
  105a29:	c7 04 24 74 6c 10 00 	movl   $0x106c74,(%esp)
  105a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a34:	e8 67 ad ff ff       	call   1007a0 <cprintf>
  105a39:	e8 52 da ff ff       	call   103490 <curproc>
  105a3e:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105a45:	e9 05 fe ff ff       	jmp    10584f <trap+0x6f>
  105a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105a50:	e8 3b db ff ff       	call   103590 <exit>
  105a55:	8d 76 00             	lea    0x0(%esi),%esi
  105a58:	e9 25 fe ff ff       	jmp    105882 <trap+0xa2>
  105a5d:	8d 76 00             	lea    0x0(%esi),%esi

00105a60 <tvinit>:
  105a60:	55                   	push   %ebp
  105a61:	31 d2                	xor    %edx,%edx
  105a63:	89 e5                	mov    %esp,%ebp
  105a65:	b9 80 e5 10 00       	mov    $0x10e580,%ecx
  105a6a:	83 ec 08             	sub    $0x8,%esp
  105a6d:	8d 76 00             	lea    0x0(%esi),%esi
  105a70:	8b 04 95 c8 7f 10 00 	mov    0x107fc8(,%edx,4),%eax
  105a77:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
  105a7e:	66 89 04 d5 80 e5 10 	mov    %ax,0x10e580(,%edx,8)
  105a85:	00 
  105a86:	c1 e8 10             	shr    $0x10,%eax
  105a89:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
  105a8e:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
  105a93:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
  105a98:	83 c2 01             	add    $0x1,%edx
  105a9b:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105aa1:	75 cd                	jne    105a70 <tvinit+0x10>
  105aa3:	a1 88 80 10 00       	mov    0x108088,%eax
  105aa8:	c7 44 24 04 b5 6c 10 	movl   $0x106cb5,0x4(%esp)
  105aaf:	00 
  105ab0:	c7 04 24 40 e5 10 00 	movl   $0x10e540,(%esp)
  105ab7:	66 c7 05 02 e7 10 00 	movw   $0x8,0x10e702
  105abe:	08 00 
  105ac0:	66 a3 00 e7 10 00    	mov    %ax,0x10e700
  105ac6:	c1 e8 10             	shr    $0x10,%eax
  105ac9:	c6 05 04 e7 10 00 00 	movb   $0x0,0x10e704
  105ad0:	c6 05 05 e7 10 00 ef 	movb   $0xef,0x10e705
  105ad7:	66 a3 06 e7 10 00    	mov    %ax,0x10e706
  105add:	e8 de e7 ff ff       	call   1042c0 <initlock>
  105ae2:	c9                   	leave  
  105ae3:	c3                   	ret    

00105ae4 <vector0>:
  105ae4:	6a 00                	push   $0x0
  105ae6:	6a 00                	push   $0x0
  105ae8:	e9 93 fc ff ff       	jmp    105780 <alltraps>

00105aed <vector1>:
  105aed:	6a 00                	push   $0x0
  105aef:	6a 01                	push   $0x1
  105af1:	e9 8a fc ff ff       	jmp    105780 <alltraps>

00105af6 <vector2>:
  105af6:	6a 00                	push   $0x0
  105af8:	6a 02                	push   $0x2
  105afa:	e9 81 fc ff ff       	jmp    105780 <alltraps>

00105aff <vector3>:
  105aff:	6a 00                	push   $0x0
  105b01:	6a 03                	push   $0x3
  105b03:	e9 78 fc ff ff       	jmp    105780 <alltraps>

00105b08 <vector4>:
  105b08:	6a 00                	push   $0x0
  105b0a:	6a 04                	push   $0x4
  105b0c:	e9 6f fc ff ff       	jmp    105780 <alltraps>

00105b11 <vector5>:
  105b11:	6a 00                	push   $0x0
  105b13:	6a 05                	push   $0x5
  105b15:	e9 66 fc ff ff       	jmp    105780 <alltraps>

00105b1a <vector6>:
  105b1a:	6a 00                	push   $0x0
  105b1c:	6a 06                	push   $0x6
  105b1e:	e9 5d fc ff ff       	jmp    105780 <alltraps>

00105b23 <vector7>:
  105b23:	6a 00                	push   $0x0
  105b25:	6a 07                	push   $0x7
  105b27:	e9 54 fc ff ff       	jmp    105780 <alltraps>

00105b2c <vector8>:
  105b2c:	6a 08                	push   $0x8
  105b2e:	e9 4d fc ff ff       	jmp    105780 <alltraps>

00105b33 <vector9>:
  105b33:	6a 09                	push   $0x9
  105b35:	e9 46 fc ff ff       	jmp    105780 <alltraps>

00105b3a <vector10>:
  105b3a:	6a 0a                	push   $0xa
  105b3c:	e9 3f fc ff ff       	jmp    105780 <alltraps>

00105b41 <vector11>:
  105b41:	6a 0b                	push   $0xb
  105b43:	e9 38 fc ff ff       	jmp    105780 <alltraps>

00105b48 <vector12>:
  105b48:	6a 0c                	push   $0xc
  105b4a:	e9 31 fc ff ff       	jmp    105780 <alltraps>

00105b4f <vector13>:
  105b4f:	6a 0d                	push   $0xd
  105b51:	e9 2a fc ff ff       	jmp    105780 <alltraps>

00105b56 <vector14>:
  105b56:	6a 0e                	push   $0xe
  105b58:	e9 23 fc ff ff       	jmp    105780 <alltraps>

00105b5d <vector15>:
  105b5d:	6a 00                	push   $0x0
  105b5f:	6a 0f                	push   $0xf
  105b61:	e9 1a fc ff ff       	jmp    105780 <alltraps>

00105b66 <vector16>:
  105b66:	6a 00                	push   $0x0
  105b68:	6a 10                	push   $0x10
  105b6a:	e9 11 fc ff ff       	jmp    105780 <alltraps>

00105b6f <vector17>:
  105b6f:	6a 11                	push   $0x11
  105b71:	e9 0a fc ff ff       	jmp    105780 <alltraps>

00105b76 <vector18>:
  105b76:	6a 00                	push   $0x0
  105b78:	6a 12                	push   $0x12
  105b7a:	e9 01 fc ff ff       	jmp    105780 <alltraps>

00105b7f <vector19>:
  105b7f:	6a 00                	push   $0x0
  105b81:	6a 13                	push   $0x13
  105b83:	e9 f8 fb ff ff       	jmp    105780 <alltraps>

00105b88 <vector20>:
  105b88:	6a 00                	push   $0x0
  105b8a:	6a 14                	push   $0x14
  105b8c:	e9 ef fb ff ff       	jmp    105780 <alltraps>

00105b91 <vector21>:
  105b91:	6a 00                	push   $0x0
  105b93:	6a 15                	push   $0x15
  105b95:	e9 e6 fb ff ff       	jmp    105780 <alltraps>

00105b9a <vector22>:
  105b9a:	6a 00                	push   $0x0
  105b9c:	6a 16                	push   $0x16
  105b9e:	e9 dd fb ff ff       	jmp    105780 <alltraps>

00105ba3 <vector23>:
  105ba3:	6a 00                	push   $0x0
  105ba5:	6a 17                	push   $0x17
  105ba7:	e9 d4 fb ff ff       	jmp    105780 <alltraps>

00105bac <vector24>:
  105bac:	6a 00                	push   $0x0
  105bae:	6a 18                	push   $0x18
  105bb0:	e9 cb fb ff ff       	jmp    105780 <alltraps>

00105bb5 <vector25>:
  105bb5:	6a 00                	push   $0x0
  105bb7:	6a 19                	push   $0x19
  105bb9:	e9 c2 fb ff ff       	jmp    105780 <alltraps>

00105bbe <vector26>:
  105bbe:	6a 00                	push   $0x0
  105bc0:	6a 1a                	push   $0x1a
  105bc2:	e9 b9 fb ff ff       	jmp    105780 <alltraps>

00105bc7 <vector27>:
  105bc7:	6a 00                	push   $0x0
  105bc9:	6a 1b                	push   $0x1b
  105bcb:	e9 b0 fb ff ff       	jmp    105780 <alltraps>

00105bd0 <vector28>:
  105bd0:	6a 00                	push   $0x0
  105bd2:	6a 1c                	push   $0x1c
  105bd4:	e9 a7 fb ff ff       	jmp    105780 <alltraps>

00105bd9 <vector29>:
  105bd9:	6a 00                	push   $0x0
  105bdb:	6a 1d                	push   $0x1d
  105bdd:	e9 9e fb ff ff       	jmp    105780 <alltraps>

00105be2 <vector30>:
  105be2:	6a 00                	push   $0x0
  105be4:	6a 1e                	push   $0x1e
  105be6:	e9 95 fb ff ff       	jmp    105780 <alltraps>

00105beb <vector31>:
  105beb:	6a 00                	push   $0x0
  105bed:	6a 1f                	push   $0x1f
  105bef:	e9 8c fb ff ff       	jmp    105780 <alltraps>

00105bf4 <vector32>:
  105bf4:	6a 00                	push   $0x0
  105bf6:	6a 20                	push   $0x20
  105bf8:	e9 83 fb ff ff       	jmp    105780 <alltraps>

00105bfd <vector33>:
  105bfd:	6a 00                	push   $0x0
  105bff:	6a 21                	push   $0x21
  105c01:	e9 7a fb ff ff       	jmp    105780 <alltraps>

00105c06 <vector34>:
  105c06:	6a 00                	push   $0x0
  105c08:	6a 22                	push   $0x22
  105c0a:	e9 71 fb ff ff       	jmp    105780 <alltraps>

00105c0f <vector35>:
  105c0f:	6a 00                	push   $0x0
  105c11:	6a 23                	push   $0x23
  105c13:	e9 68 fb ff ff       	jmp    105780 <alltraps>

00105c18 <vector36>:
  105c18:	6a 00                	push   $0x0
  105c1a:	6a 24                	push   $0x24
  105c1c:	e9 5f fb ff ff       	jmp    105780 <alltraps>

00105c21 <vector37>:
  105c21:	6a 00                	push   $0x0
  105c23:	6a 25                	push   $0x25
  105c25:	e9 56 fb ff ff       	jmp    105780 <alltraps>

00105c2a <vector38>:
  105c2a:	6a 00                	push   $0x0
  105c2c:	6a 26                	push   $0x26
  105c2e:	e9 4d fb ff ff       	jmp    105780 <alltraps>

00105c33 <vector39>:
  105c33:	6a 00                	push   $0x0
  105c35:	6a 27                	push   $0x27
  105c37:	e9 44 fb ff ff       	jmp    105780 <alltraps>

00105c3c <vector40>:
  105c3c:	6a 00                	push   $0x0
  105c3e:	6a 28                	push   $0x28
  105c40:	e9 3b fb ff ff       	jmp    105780 <alltraps>

00105c45 <vector41>:
  105c45:	6a 00                	push   $0x0
  105c47:	6a 29                	push   $0x29
  105c49:	e9 32 fb ff ff       	jmp    105780 <alltraps>

00105c4e <vector42>:
  105c4e:	6a 00                	push   $0x0
  105c50:	6a 2a                	push   $0x2a
  105c52:	e9 29 fb ff ff       	jmp    105780 <alltraps>

00105c57 <vector43>:
  105c57:	6a 00                	push   $0x0
  105c59:	6a 2b                	push   $0x2b
  105c5b:	e9 20 fb ff ff       	jmp    105780 <alltraps>

00105c60 <vector44>:
  105c60:	6a 00                	push   $0x0
  105c62:	6a 2c                	push   $0x2c
  105c64:	e9 17 fb ff ff       	jmp    105780 <alltraps>

00105c69 <vector45>:
  105c69:	6a 00                	push   $0x0
  105c6b:	6a 2d                	push   $0x2d
  105c6d:	e9 0e fb ff ff       	jmp    105780 <alltraps>

00105c72 <vector46>:
  105c72:	6a 00                	push   $0x0
  105c74:	6a 2e                	push   $0x2e
  105c76:	e9 05 fb ff ff       	jmp    105780 <alltraps>

00105c7b <vector47>:
  105c7b:	6a 00                	push   $0x0
  105c7d:	6a 2f                	push   $0x2f
  105c7f:	e9 fc fa ff ff       	jmp    105780 <alltraps>

00105c84 <vector48>:
  105c84:	6a 00                	push   $0x0
  105c86:	6a 30                	push   $0x30
  105c88:	e9 f3 fa ff ff       	jmp    105780 <alltraps>

00105c8d <vector49>:
  105c8d:	6a 00                	push   $0x0
  105c8f:	6a 31                	push   $0x31
  105c91:	e9 ea fa ff ff       	jmp    105780 <alltraps>

00105c96 <vector50>:
  105c96:	6a 00                	push   $0x0
  105c98:	6a 32                	push   $0x32
  105c9a:	e9 e1 fa ff ff       	jmp    105780 <alltraps>

00105c9f <vector51>:
  105c9f:	6a 00                	push   $0x0
  105ca1:	6a 33                	push   $0x33
  105ca3:	e9 d8 fa ff ff       	jmp    105780 <alltraps>

00105ca8 <vector52>:
  105ca8:	6a 00                	push   $0x0
  105caa:	6a 34                	push   $0x34
  105cac:	e9 cf fa ff ff       	jmp    105780 <alltraps>

00105cb1 <vector53>:
  105cb1:	6a 00                	push   $0x0
  105cb3:	6a 35                	push   $0x35
  105cb5:	e9 c6 fa ff ff       	jmp    105780 <alltraps>

00105cba <vector54>:
  105cba:	6a 00                	push   $0x0
  105cbc:	6a 36                	push   $0x36
  105cbe:	e9 bd fa ff ff       	jmp    105780 <alltraps>

00105cc3 <vector55>:
  105cc3:	6a 00                	push   $0x0
  105cc5:	6a 37                	push   $0x37
  105cc7:	e9 b4 fa ff ff       	jmp    105780 <alltraps>

00105ccc <vector56>:
  105ccc:	6a 00                	push   $0x0
  105cce:	6a 38                	push   $0x38
  105cd0:	e9 ab fa ff ff       	jmp    105780 <alltraps>

00105cd5 <vector57>:
  105cd5:	6a 00                	push   $0x0
  105cd7:	6a 39                	push   $0x39
  105cd9:	e9 a2 fa ff ff       	jmp    105780 <alltraps>

00105cde <vector58>:
  105cde:	6a 00                	push   $0x0
  105ce0:	6a 3a                	push   $0x3a
  105ce2:	e9 99 fa ff ff       	jmp    105780 <alltraps>

00105ce7 <vector59>:
  105ce7:	6a 00                	push   $0x0
  105ce9:	6a 3b                	push   $0x3b
  105ceb:	e9 90 fa ff ff       	jmp    105780 <alltraps>

00105cf0 <vector60>:
  105cf0:	6a 00                	push   $0x0
  105cf2:	6a 3c                	push   $0x3c
  105cf4:	e9 87 fa ff ff       	jmp    105780 <alltraps>

00105cf9 <vector61>:
  105cf9:	6a 00                	push   $0x0
  105cfb:	6a 3d                	push   $0x3d
  105cfd:	e9 7e fa ff ff       	jmp    105780 <alltraps>

00105d02 <vector62>:
  105d02:	6a 00                	push   $0x0
  105d04:	6a 3e                	push   $0x3e
  105d06:	e9 75 fa ff ff       	jmp    105780 <alltraps>

00105d0b <vector63>:
  105d0b:	6a 00                	push   $0x0
  105d0d:	6a 3f                	push   $0x3f
  105d0f:	e9 6c fa ff ff       	jmp    105780 <alltraps>

00105d14 <vector64>:
  105d14:	6a 00                	push   $0x0
  105d16:	6a 40                	push   $0x40
  105d18:	e9 63 fa ff ff       	jmp    105780 <alltraps>

00105d1d <vector65>:
  105d1d:	6a 00                	push   $0x0
  105d1f:	6a 41                	push   $0x41
  105d21:	e9 5a fa ff ff       	jmp    105780 <alltraps>

00105d26 <vector66>:
  105d26:	6a 00                	push   $0x0
  105d28:	6a 42                	push   $0x42
  105d2a:	e9 51 fa ff ff       	jmp    105780 <alltraps>

00105d2f <vector67>:
  105d2f:	6a 00                	push   $0x0
  105d31:	6a 43                	push   $0x43
  105d33:	e9 48 fa ff ff       	jmp    105780 <alltraps>

00105d38 <vector68>:
  105d38:	6a 00                	push   $0x0
  105d3a:	6a 44                	push   $0x44
  105d3c:	e9 3f fa ff ff       	jmp    105780 <alltraps>

00105d41 <vector69>:
  105d41:	6a 00                	push   $0x0
  105d43:	6a 45                	push   $0x45
  105d45:	e9 36 fa ff ff       	jmp    105780 <alltraps>

00105d4a <vector70>:
  105d4a:	6a 00                	push   $0x0
  105d4c:	6a 46                	push   $0x46
  105d4e:	e9 2d fa ff ff       	jmp    105780 <alltraps>

00105d53 <vector71>:
  105d53:	6a 00                	push   $0x0
  105d55:	6a 47                	push   $0x47
  105d57:	e9 24 fa ff ff       	jmp    105780 <alltraps>

00105d5c <vector72>:
  105d5c:	6a 00                	push   $0x0
  105d5e:	6a 48                	push   $0x48
  105d60:	e9 1b fa ff ff       	jmp    105780 <alltraps>

00105d65 <vector73>:
  105d65:	6a 00                	push   $0x0
  105d67:	6a 49                	push   $0x49
  105d69:	e9 12 fa ff ff       	jmp    105780 <alltraps>

00105d6e <vector74>:
  105d6e:	6a 00                	push   $0x0
  105d70:	6a 4a                	push   $0x4a
  105d72:	e9 09 fa ff ff       	jmp    105780 <alltraps>

00105d77 <vector75>:
  105d77:	6a 00                	push   $0x0
  105d79:	6a 4b                	push   $0x4b
  105d7b:	e9 00 fa ff ff       	jmp    105780 <alltraps>

00105d80 <vector76>:
  105d80:	6a 00                	push   $0x0
  105d82:	6a 4c                	push   $0x4c
  105d84:	e9 f7 f9 ff ff       	jmp    105780 <alltraps>

00105d89 <vector77>:
  105d89:	6a 00                	push   $0x0
  105d8b:	6a 4d                	push   $0x4d
  105d8d:	e9 ee f9 ff ff       	jmp    105780 <alltraps>

00105d92 <vector78>:
  105d92:	6a 00                	push   $0x0
  105d94:	6a 4e                	push   $0x4e
  105d96:	e9 e5 f9 ff ff       	jmp    105780 <alltraps>

00105d9b <vector79>:
  105d9b:	6a 00                	push   $0x0
  105d9d:	6a 4f                	push   $0x4f
  105d9f:	e9 dc f9 ff ff       	jmp    105780 <alltraps>

00105da4 <vector80>:
  105da4:	6a 00                	push   $0x0
  105da6:	6a 50                	push   $0x50
  105da8:	e9 d3 f9 ff ff       	jmp    105780 <alltraps>

00105dad <vector81>:
  105dad:	6a 00                	push   $0x0
  105daf:	6a 51                	push   $0x51
  105db1:	e9 ca f9 ff ff       	jmp    105780 <alltraps>

00105db6 <vector82>:
  105db6:	6a 00                	push   $0x0
  105db8:	6a 52                	push   $0x52
  105dba:	e9 c1 f9 ff ff       	jmp    105780 <alltraps>

00105dbf <vector83>:
  105dbf:	6a 00                	push   $0x0
  105dc1:	6a 53                	push   $0x53
  105dc3:	e9 b8 f9 ff ff       	jmp    105780 <alltraps>

00105dc8 <vector84>:
  105dc8:	6a 00                	push   $0x0
  105dca:	6a 54                	push   $0x54
  105dcc:	e9 af f9 ff ff       	jmp    105780 <alltraps>

00105dd1 <vector85>:
  105dd1:	6a 00                	push   $0x0
  105dd3:	6a 55                	push   $0x55
  105dd5:	e9 a6 f9 ff ff       	jmp    105780 <alltraps>

00105dda <vector86>:
  105dda:	6a 00                	push   $0x0
  105ddc:	6a 56                	push   $0x56
  105dde:	e9 9d f9 ff ff       	jmp    105780 <alltraps>

00105de3 <vector87>:
  105de3:	6a 00                	push   $0x0
  105de5:	6a 57                	push   $0x57
  105de7:	e9 94 f9 ff ff       	jmp    105780 <alltraps>

00105dec <vector88>:
  105dec:	6a 00                	push   $0x0
  105dee:	6a 58                	push   $0x58
  105df0:	e9 8b f9 ff ff       	jmp    105780 <alltraps>

00105df5 <vector89>:
  105df5:	6a 00                	push   $0x0
  105df7:	6a 59                	push   $0x59
  105df9:	e9 82 f9 ff ff       	jmp    105780 <alltraps>

00105dfe <vector90>:
  105dfe:	6a 00                	push   $0x0
  105e00:	6a 5a                	push   $0x5a
  105e02:	e9 79 f9 ff ff       	jmp    105780 <alltraps>

00105e07 <vector91>:
  105e07:	6a 00                	push   $0x0
  105e09:	6a 5b                	push   $0x5b
  105e0b:	e9 70 f9 ff ff       	jmp    105780 <alltraps>

00105e10 <vector92>:
  105e10:	6a 00                	push   $0x0
  105e12:	6a 5c                	push   $0x5c
  105e14:	e9 67 f9 ff ff       	jmp    105780 <alltraps>

00105e19 <vector93>:
  105e19:	6a 00                	push   $0x0
  105e1b:	6a 5d                	push   $0x5d
  105e1d:	e9 5e f9 ff ff       	jmp    105780 <alltraps>

00105e22 <vector94>:
  105e22:	6a 00                	push   $0x0
  105e24:	6a 5e                	push   $0x5e
  105e26:	e9 55 f9 ff ff       	jmp    105780 <alltraps>

00105e2b <vector95>:
  105e2b:	6a 00                	push   $0x0
  105e2d:	6a 5f                	push   $0x5f
  105e2f:	e9 4c f9 ff ff       	jmp    105780 <alltraps>

00105e34 <vector96>:
  105e34:	6a 00                	push   $0x0
  105e36:	6a 60                	push   $0x60
  105e38:	e9 43 f9 ff ff       	jmp    105780 <alltraps>

00105e3d <vector97>:
  105e3d:	6a 00                	push   $0x0
  105e3f:	6a 61                	push   $0x61
  105e41:	e9 3a f9 ff ff       	jmp    105780 <alltraps>

00105e46 <vector98>:
  105e46:	6a 00                	push   $0x0
  105e48:	6a 62                	push   $0x62
  105e4a:	e9 31 f9 ff ff       	jmp    105780 <alltraps>

00105e4f <vector99>:
  105e4f:	6a 00                	push   $0x0
  105e51:	6a 63                	push   $0x63
  105e53:	e9 28 f9 ff ff       	jmp    105780 <alltraps>

00105e58 <vector100>:
  105e58:	6a 00                	push   $0x0
  105e5a:	6a 64                	push   $0x64
  105e5c:	e9 1f f9 ff ff       	jmp    105780 <alltraps>

00105e61 <vector101>:
  105e61:	6a 00                	push   $0x0
  105e63:	6a 65                	push   $0x65
  105e65:	e9 16 f9 ff ff       	jmp    105780 <alltraps>

00105e6a <vector102>:
  105e6a:	6a 00                	push   $0x0
  105e6c:	6a 66                	push   $0x66
  105e6e:	e9 0d f9 ff ff       	jmp    105780 <alltraps>

00105e73 <vector103>:
  105e73:	6a 00                	push   $0x0
  105e75:	6a 67                	push   $0x67
  105e77:	e9 04 f9 ff ff       	jmp    105780 <alltraps>

00105e7c <vector104>:
  105e7c:	6a 00                	push   $0x0
  105e7e:	6a 68                	push   $0x68
  105e80:	e9 fb f8 ff ff       	jmp    105780 <alltraps>

00105e85 <vector105>:
  105e85:	6a 00                	push   $0x0
  105e87:	6a 69                	push   $0x69
  105e89:	e9 f2 f8 ff ff       	jmp    105780 <alltraps>

00105e8e <vector106>:
  105e8e:	6a 00                	push   $0x0
  105e90:	6a 6a                	push   $0x6a
  105e92:	e9 e9 f8 ff ff       	jmp    105780 <alltraps>

00105e97 <vector107>:
  105e97:	6a 00                	push   $0x0
  105e99:	6a 6b                	push   $0x6b
  105e9b:	e9 e0 f8 ff ff       	jmp    105780 <alltraps>

00105ea0 <vector108>:
  105ea0:	6a 00                	push   $0x0
  105ea2:	6a 6c                	push   $0x6c
  105ea4:	e9 d7 f8 ff ff       	jmp    105780 <alltraps>

00105ea9 <vector109>:
  105ea9:	6a 00                	push   $0x0
  105eab:	6a 6d                	push   $0x6d
  105ead:	e9 ce f8 ff ff       	jmp    105780 <alltraps>

00105eb2 <vector110>:
  105eb2:	6a 00                	push   $0x0
  105eb4:	6a 6e                	push   $0x6e
  105eb6:	e9 c5 f8 ff ff       	jmp    105780 <alltraps>

00105ebb <vector111>:
  105ebb:	6a 00                	push   $0x0
  105ebd:	6a 6f                	push   $0x6f
  105ebf:	e9 bc f8 ff ff       	jmp    105780 <alltraps>

00105ec4 <vector112>:
  105ec4:	6a 00                	push   $0x0
  105ec6:	6a 70                	push   $0x70
  105ec8:	e9 b3 f8 ff ff       	jmp    105780 <alltraps>

00105ecd <vector113>:
  105ecd:	6a 00                	push   $0x0
  105ecf:	6a 71                	push   $0x71
  105ed1:	e9 aa f8 ff ff       	jmp    105780 <alltraps>

00105ed6 <vector114>:
  105ed6:	6a 00                	push   $0x0
  105ed8:	6a 72                	push   $0x72
  105eda:	e9 a1 f8 ff ff       	jmp    105780 <alltraps>

00105edf <vector115>:
  105edf:	6a 00                	push   $0x0
  105ee1:	6a 73                	push   $0x73
  105ee3:	e9 98 f8 ff ff       	jmp    105780 <alltraps>

00105ee8 <vector116>:
  105ee8:	6a 00                	push   $0x0
  105eea:	6a 74                	push   $0x74
  105eec:	e9 8f f8 ff ff       	jmp    105780 <alltraps>

00105ef1 <vector117>:
  105ef1:	6a 00                	push   $0x0
  105ef3:	6a 75                	push   $0x75
  105ef5:	e9 86 f8 ff ff       	jmp    105780 <alltraps>

00105efa <vector118>:
  105efa:	6a 00                	push   $0x0
  105efc:	6a 76                	push   $0x76
  105efe:	e9 7d f8 ff ff       	jmp    105780 <alltraps>

00105f03 <vector119>:
  105f03:	6a 00                	push   $0x0
  105f05:	6a 77                	push   $0x77
  105f07:	e9 74 f8 ff ff       	jmp    105780 <alltraps>

00105f0c <vector120>:
  105f0c:	6a 00                	push   $0x0
  105f0e:	6a 78                	push   $0x78
  105f10:	e9 6b f8 ff ff       	jmp    105780 <alltraps>

00105f15 <vector121>:
  105f15:	6a 00                	push   $0x0
  105f17:	6a 79                	push   $0x79
  105f19:	e9 62 f8 ff ff       	jmp    105780 <alltraps>

00105f1e <vector122>:
  105f1e:	6a 00                	push   $0x0
  105f20:	6a 7a                	push   $0x7a
  105f22:	e9 59 f8 ff ff       	jmp    105780 <alltraps>

00105f27 <vector123>:
  105f27:	6a 00                	push   $0x0
  105f29:	6a 7b                	push   $0x7b
  105f2b:	e9 50 f8 ff ff       	jmp    105780 <alltraps>

00105f30 <vector124>:
  105f30:	6a 00                	push   $0x0
  105f32:	6a 7c                	push   $0x7c
  105f34:	e9 47 f8 ff ff       	jmp    105780 <alltraps>

00105f39 <vector125>:
  105f39:	6a 00                	push   $0x0
  105f3b:	6a 7d                	push   $0x7d
  105f3d:	e9 3e f8 ff ff       	jmp    105780 <alltraps>

00105f42 <vector126>:
  105f42:	6a 00                	push   $0x0
  105f44:	6a 7e                	push   $0x7e
  105f46:	e9 35 f8 ff ff       	jmp    105780 <alltraps>

00105f4b <vector127>:
  105f4b:	6a 00                	push   $0x0
  105f4d:	6a 7f                	push   $0x7f
  105f4f:	e9 2c f8 ff ff       	jmp    105780 <alltraps>

00105f54 <vector128>:
  105f54:	6a 00                	push   $0x0
  105f56:	68 80 00 00 00       	push   $0x80
  105f5b:	e9 20 f8 ff ff       	jmp    105780 <alltraps>

00105f60 <vector129>:
  105f60:	6a 00                	push   $0x0
  105f62:	68 81 00 00 00       	push   $0x81
  105f67:	e9 14 f8 ff ff       	jmp    105780 <alltraps>

00105f6c <vector130>:
  105f6c:	6a 00                	push   $0x0
  105f6e:	68 82 00 00 00       	push   $0x82
  105f73:	e9 08 f8 ff ff       	jmp    105780 <alltraps>

00105f78 <vector131>:
  105f78:	6a 00                	push   $0x0
  105f7a:	68 83 00 00 00       	push   $0x83
  105f7f:	e9 fc f7 ff ff       	jmp    105780 <alltraps>

00105f84 <vector132>:
  105f84:	6a 00                	push   $0x0
  105f86:	68 84 00 00 00       	push   $0x84
  105f8b:	e9 f0 f7 ff ff       	jmp    105780 <alltraps>

00105f90 <vector133>:
  105f90:	6a 00                	push   $0x0
  105f92:	68 85 00 00 00       	push   $0x85
  105f97:	e9 e4 f7 ff ff       	jmp    105780 <alltraps>

00105f9c <vector134>:
  105f9c:	6a 00                	push   $0x0
  105f9e:	68 86 00 00 00       	push   $0x86
  105fa3:	e9 d8 f7 ff ff       	jmp    105780 <alltraps>

00105fa8 <vector135>:
  105fa8:	6a 00                	push   $0x0
  105faa:	68 87 00 00 00       	push   $0x87
  105faf:	e9 cc f7 ff ff       	jmp    105780 <alltraps>

00105fb4 <vector136>:
  105fb4:	6a 00                	push   $0x0
  105fb6:	68 88 00 00 00       	push   $0x88
  105fbb:	e9 c0 f7 ff ff       	jmp    105780 <alltraps>

00105fc0 <vector137>:
  105fc0:	6a 00                	push   $0x0
  105fc2:	68 89 00 00 00       	push   $0x89
  105fc7:	e9 b4 f7 ff ff       	jmp    105780 <alltraps>

00105fcc <vector138>:
  105fcc:	6a 00                	push   $0x0
  105fce:	68 8a 00 00 00       	push   $0x8a
  105fd3:	e9 a8 f7 ff ff       	jmp    105780 <alltraps>

00105fd8 <vector139>:
  105fd8:	6a 00                	push   $0x0
  105fda:	68 8b 00 00 00       	push   $0x8b
  105fdf:	e9 9c f7 ff ff       	jmp    105780 <alltraps>

00105fe4 <vector140>:
  105fe4:	6a 00                	push   $0x0
  105fe6:	68 8c 00 00 00       	push   $0x8c
  105feb:	e9 90 f7 ff ff       	jmp    105780 <alltraps>

00105ff0 <vector141>:
  105ff0:	6a 00                	push   $0x0
  105ff2:	68 8d 00 00 00       	push   $0x8d
  105ff7:	e9 84 f7 ff ff       	jmp    105780 <alltraps>

00105ffc <vector142>:
  105ffc:	6a 00                	push   $0x0
  105ffe:	68 8e 00 00 00       	push   $0x8e
  106003:	e9 78 f7 ff ff       	jmp    105780 <alltraps>

00106008 <vector143>:
  106008:	6a 00                	push   $0x0
  10600a:	68 8f 00 00 00       	push   $0x8f
  10600f:	e9 6c f7 ff ff       	jmp    105780 <alltraps>

00106014 <vector144>:
  106014:	6a 00                	push   $0x0
  106016:	68 90 00 00 00       	push   $0x90
  10601b:	e9 60 f7 ff ff       	jmp    105780 <alltraps>

00106020 <vector145>:
  106020:	6a 00                	push   $0x0
  106022:	68 91 00 00 00       	push   $0x91
  106027:	e9 54 f7 ff ff       	jmp    105780 <alltraps>

0010602c <vector146>:
  10602c:	6a 00                	push   $0x0
  10602e:	68 92 00 00 00       	push   $0x92
  106033:	e9 48 f7 ff ff       	jmp    105780 <alltraps>

00106038 <vector147>:
  106038:	6a 00                	push   $0x0
  10603a:	68 93 00 00 00       	push   $0x93
  10603f:	e9 3c f7 ff ff       	jmp    105780 <alltraps>

00106044 <vector148>:
  106044:	6a 00                	push   $0x0
  106046:	68 94 00 00 00       	push   $0x94
  10604b:	e9 30 f7 ff ff       	jmp    105780 <alltraps>

00106050 <vector149>:
  106050:	6a 00                	push   $0x0
  106052:	68 95 00 00 00       	push   $0x95
  106057:	e9 24 f7 ff ff       	jmp    105780 <alltraps>

0010605c <vector150>:
  10605c:	6a 00                	push   $0x0
  10605e:	68 96 00 00 00       	push   $0x96
  106063:	e9 18 f7 ff ff       	jmp    105780 <alltraps>

00106068 <vector151>:
  106068:	6a 00                	push   $0x0
  10606a:	68 97 00 00 00       	push   $0x97
  10606f:	e9 0c f7 ff ff       	jmp    105780 <alltraps>

00106074 <vector152>:
  106074:	6a 00                	push   $0x0
  106076:	68 98 00 00 00       	push   $0x98
  10607b:	e9 00 f7 ff ff       	jmp    105780 <alltraps>

00106080 <vector153>:
  106080:	6a 00                	push   $0x0
  106082:	68 99 00 00 00       	push   $0x99
  106087:	e9 f4 f6 ff ff       	jmp    105780 <alltraps>

0010608c <vector154>:
  10608c:	6a 00                	push   $0x0
  10608e:	68 9a 00 00 00       	push   $0x9a
  106093:	e9 e8 f6 ff ff       	jmp    105780 <alltraps>

00106098 <vector155>:
  106098:	6a 00                	push   $0x0
  10609a:	68 9b 00 00 00       	push   $0x9b
  10609f:	e9 dc f6 ff ff       	jmp    105780 <alltraps>

001060a4 <vector156>:
  1060a4:	6a 00                	push   $0x0
  1060a6:	68 9c 00 00 00       	push   $0x9c
  1060ab:	e9 d0 f6 ff ff       	jmp    105780 <alltraps>

001060b0 <vector157>:
  1060b0:	6a 00                	push   $0x0
  1060b2:	68 9d 00 00 00       	push   $0x9d
  1060b7:	e9 c4 f6 ff ff       	jmp    105780 <alltraps>

001060bc <vector158>:
  1060bc:	6a 00                	push   $0x0
  1060be:	68 9e 00 00 00       	push   $0x9e
  1060c3:	e9 b8 f6 ff ff       	jmp    105780 <alltraps>

001060c8 <vector159>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	68 9f 00 00 00       	push   $0x9f
  1060cf:	e9 ac f6 ff ff       	jmp    105780 <alltraps>

001060d4 <vector160>:
  1060d4:	6a 00                	push   $0x0
  1060d6:	68 a0 00 00 00       	push   $0xa0
  1060db:	e9 a0 f6 ff ff       	jmp    105780 <alltraps>

001060e0 <vector161>:
  1060e0:	6a 00                	push   $0x0
  1060e2:	68 a1 00 00 00       	push   $0xa1
  1060e7:	e9 94 f6 ff ff       	jmp    105780 <alltraps>

001060ec <vector162>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	68 a2 00 00 00       	push   $0xa2
  1060f3:	e9 88 f6 ff ff       	jmp    105780 <alltraps>

001060f8 <vector163>:
  1060f8:	6a 00                	push   $0x0
  1060fa:	68 a3 00 00 00       	push   $0xa3
  1060ff:	e9 7c f6 ff ff       	jmp    105780 <alltraps>

00106104 <vector164>:
  106104:	6a 00                	push   $0x0
  106106:	68 a4 00 00 00       	push   $0xa4
  10610b:	e9 70 f6 ff ff       	jmp    105780 <alltraps>

00106110 <vector165>:
  106110:	6a 00                	push   $0x0
  106112:	68 a5 00 00 00       	push   $0xa5
  106117:	e9 64 f6 ff ff       	jmp    105780 <alltraps>

0010611c <vector166>:
  10611c:	6a 00                	push   $0x0
  10611e:	68 a6 00 00 00       	push   $0xa6
  106123:	e9 58 f6 ff ff       	jmp    105780 <alltraps>

00106128 <vector167>:
  106128:	6a 00                	push   $0x0
  10612a:	68 a7 00 00 00       	push   $0xa7
  10612f:	e9 4c f6 ff ff       	jmp    105780 <alltraps>

00106134 <vector168>:
  106134:	6a 00                	push   $0x0
  106136:	68 a8 00 00 00       	push   $0xa8
  10613b:	e9 40 f6 ff ff       	jmp    105780 <alltraps>

00106140 <vector169>:
  106140:	6a 00                	push   $0x0
  106142:	68 a9 00 00 00       	push   $0xa9
  106147:	e9 34 f6 ff ff       	jmp    105780 <alltraps>

0010614c <vector170>:
  10614c:	6a 00                	push   $0x0
  10614e:	68 aa 00 00 00       	push   $0xaa
  106153:	e9 28 f6 ff ff       	jmp    105780 <alltraps>

00106158 <vector171>:
  106158:	6a 00                	push   $0x0
  10615a:	68 ab 00 00 00       	push   $0xab
  10615f:	e9 1c f6 ff ff       	jmp    105780 <alltraps>

00106164 <vector172>:
  106164:	6a 00                	push   $0x0
  106166:	68 ac 00 00 00       	push   $0xac
  10616b:	e9 10 f6 ff ff       	jmp    105780 <alltraps>

00106170 <vector173>:
  106170:	6a 00                	push   $0x0
  106172:	68 ad 00 00 00       	push   $0xad
  106177:	e9 04 f6 ff ff       	jmp    105780 <alltraps>

0010617c <vector174>:
  10617c:	6a 00                	push   $0x0
  10617e:	68 ae 00 00 00       	push   $0xae
  106183:	e9 f8 f5 ff ff       	jmp    105780 <alltraps>

00106188 <vector175>:
  106188:	6a 00                	push   $0x0
  10618a:	68 af 00 00 00       	push   $0xaf
  10618f:	e9 ec f5 ff ff       	jmp    105780 <alltraps>

00106194 <vector176>:
  106194:	6a 00                	push   $0x0
  106196:	68 b0 00 00 00       	push   $0xb0
  10619b:	e9 e0 f5 ff ff       	jmp    105780 <alltraps>

001061a0 <vector177>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	68 b1 00 00 00       	push   $0xb1
  1061a7:	e9 d4 f5 ff ff       	jmp    105780 <alltraps>

001061ac <vector178>:
  1061ac:	6a 00                	push   $0x0
  1061ae:	68 b2 00 00 00       	push   $0xb2
  1061b3:	e9 c8 f5 ff ff       	jmp    105780 <alltraps>

001061b8 <vector179>:
  1061b8:	6a 00                	push   $0x0
  1061ba:	68 b3 00 00 00       	push   $0xb3
  1061bf:	e9 bc f5 ff ff       	jmp    105780 <alltraps>

001061c4 <vector180>:
  1061c4:	6a 00                	push   $0x0
  1061c6:	68 b4 00 00 00       	push   $0xb4
  1061cb:	e9 b0 f5 ff ff       	jmp    105780 <alltraps>

001061d0 <vector181>:
  1061d0:	6a 00                	push   $0x0
  1061d2:	68 b5 00 00 00       	push   $0xb5
  1061d7:	e9 a4 f5 ff ff       	jmp    105780 <alltraps>

001061dc <vector182>:
  1061dc:	6a 00                	push   $0x0
  1061de:	68 b6 00 00 00       	push   $0xb6
  1061e3:	e9 98 f5 ff ff       	jmp    105780 <alltraps>

001061e8 <vector183>:
  1061e8:	6a 00                	push   $0x0
  1061ea:	68 b7 00 00 00       	push   $0xb7
  1061ef:	e9 8c f5 ff ff       	jmp    105780 <alltraps>

001061f4 <vector184>:
  1061f4:	6a 00                	push   $0x0
  1061f6:	68 b8 00 00 00       	push   $0xb8
  1061fb:	e9 80 f5 ff ff       	jmp    105780 <alltraps>

00106200 <vector185>:
  106200:	6a 00                	push   $0x0
  106202:	68 b9 00 00 00       	push   $0xb9
  106207:	e9 74 f5 ff ff       	jmp    105780 <alltraps>

0010620c <vector186>:
  10620c:	6a 00                	push   $0x0
  10620e:	68 ba 00 00 00       	push   $0xba
  106213:	e9 68 f5 ff ff       	jmp    105780 <alltraps>

00106218 <vector187>:
  106218:	6a 00                	push   $0x0
  10621a:	68 bb 00 00 00       	push   $0xbb
  10621f:	e9 5c f5 ff ff       	jmp    105780 <alltraps>

00106224 <vector188>:
  106224:	6a 00                	push   $0x0
  106226:	68 bc 00 00 00       	push   $0xbc
  10622b:	e9 50 f5 ff ff       	jmp    105780 <alltraps>

00106230 <vector189>:
  106230:	6a 00                	push   $0x0
  106232:	68 bd 00 00 00       	push   $0xbd
  106237:	e9 44 f5 ff ff       	jmp    105780 <alltraps>

0010623c <vector190>:
  10623c:	6a 00                	push   $0x0
  10623e:	68 be 00 00 00       	push   $0xbe
  106243:	e9 38 f5 ff ff       	jmp    105780 <alltraps>

00106248 <vector191>:
  106248:	6a 00                	push   $0x0
  10624a:	68 bf 00 00 00       	push   $0xbf
  10624f:	e9 2c f5 ff ff       	jmp    105780 <alltraps>

00106254 <vector192>:
  106254:	6a 00                	push   $0x0
  106256:	68 c0 00 00 00       	push   $0xc0
  10625b:	e9 20 f5 ff ff       	jmp    105780 <alltraps>

00106260 <vector193>:
  106260:	6a 00                	push   $0x0
  106262:	68 c1 00 00 00       	push   $0xc1
  106267:	e9 14 f5 ff ff       	jmp    105780 <alltraps>

0010626c <vector194>:
  10626c:	6a 00                	push   $0x0
  10626e:	68 c2 00 00 00       	push   $0xc2
  106273:	e9 08 f5 ff ff       	jmp    105780 <alltraps>

00106278 <vector195>:
  106278:	6a 00                	push   $0x0
  10627a:	68 c3 00 00 00       	push   $0xc3
  10627f:	e9 fc f4 ff ff       	jmp    105780 <alltraps>

00106284 <vector196>:
  106284:	6a 00                	push   $0x0
  106286:	68 c4 00 00 00       	push   $0xc4
  10628b:	e9 f0 f4 ff ff       	jmp    105780 <alltraps>

00106290 <vector197>:
  106290:	6a 00                	push   $0x0
  106292:	68 c5 00 00 00       	push   $0xc5
  106297:	e9 e4 f4 ff ff       	jmp    105780 <alltraps>

0010629c <vector198>:
  10629c:	6a 00                	push   $0x0
  10629e:	68 c6 00 00 00       	push   $0xc6
  1062a3:	e9 d8 f4 ff ff       	jmp    105780 <alltraps>

001062a8 <vector199>:
  1062a8:	6a 00                	push   $0x0
  1062aa:	68 c7 00 00 00       	push   $0xc7
  1062af:	e9 cc f4 ff ff       	jmp    105780 <alltraps>

001062b4 <vector200>:
  1062b4:	6a 00                	push   $0x0
  1062b6:	68 c8 00 00 00       	push   $0xc8
  1062bb:	e9 c0 f4 ff ff       	jmp    105780 <alltraps>

001062c0 <vector201>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	68 c9 00 00 00       	push   $0xc9
  1062c7:	e9 b4 f4 ff ff       	jmp    105780 <alltraps>

001062cc <vector202>:
  1062cc:	6a 00                	push   $0x0
  1062ce:	68 ca 00 00 00       	push   $0xca
  1062d3:	e9 a8 f4 ff ff       	jmp    105780 <alltraps>

001062d8 <vector203>:
  1062d8:	6a 00                	push   $0x0
  1062da:	68 cb 00 00 00       	push   $0xcb
  1062df:	e9 9c f4 ff ff       	jmp    105780 <alltraps>

001062e4 <vector204>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	68 cc 00 00 00       	push   $0xcc
  1062eb:	e9 90 f4 ff ff       	jmp    105780 <alltraps>

001062f0 <vector205>:
  1062f0:	6a 00                	push   $0x0
  1062f2:	68 cd 00 00 00       	push   $0xcd
  1062f7:	e9 84 f4 ff ff       	jmp    105780 <alltraps>

001062fc <vector206>:
  1062fc:	6a 00                	push   $0x0
  1062fe:	68 ce 00 00 00       	push   $0xce
  106303:	e9 78 f4 ff ff       	jmp    105780 <alltraps>

00106308 <vector207>:
  106308:	6a 00                	push   $0x0
  10630a:	68 cf 00 00 00       	push   $0xcf
  10630f:	e9 6c f4 ff ff       	jmp    105780 <alltraps>

00106314 <vector208>:
  106314:	6a 00                	push   $0x0
  106316:	68 d0 00 00 00       	push   $0xd0
  10631b:	e9 60 f4 ff ff       	jmp    105780 <alltraps>

00106320 <vector209>:
  106320:	6a 00                	push   $0x0
  106322:	68 d1 00 00 00       	push   $0xd1
  106327:	e9 54 f4 ff ff       	jmp    105780 <alltraps>

0010632c <vector210>:
  10632c:	6a 00                	push   $0x0
  10632e:	68 d2 00 00 00       	push   $0xd2
  106333:	e9 48 f4 ff ff       	jmp    105780 <alltraps>

00106338 <vector211>:
  106338:	6a 00                	push   $0x0
  10633a:	68 d3 00 00 00       	push   $0xd3
  10633f:	e9 3c f4 ff ff       	jmp    105780 <alltraps>

00106344 <vector212>:
  106344:	6a 00                	push   $0x0
  106346:	68 d4 00 00 00       	push   $0xd4
  10634b:	e9 30 f4 ff ff       	jmp    105780 <alltraps>

00106350 <vector213>:
  106350:	6a 00                	push   $0x0
  106352:	68 d5 00 00 00       	push   $0xd5
  106357:	e9 24 f4 ff ff       	jmp    105780 <alltraps>

0010635c <vector214>:
  10635c:	6a 00                	push   $0x0
  10635e:	68 d6 00 00 00       	push   $0xd6
  106363:	e9 18 f4 ff ff       	jmp    105780 <alltraps>

00106368 <vector215>:
  106368:	6a 00                	push   $0x0
  10636a:	68 d7 00 00 00       	push   $0xd7
  10636f:	e9 0c f4 ff ff       	jmp    105780 <alltraps>

00106374 <vector216>:
  106374:	6a 00                	push   $0x0
  106376:	68 d8 00 00 00       	push   $0xd8
  10637b:	e9 00 f4 ff ff       	jmp    105780 <alltraps>

00106380 <vector217>:
  106380:	6a 00                	push   $0x0
  106382:	68 d9 00 00 00       	push   $0xd9
  106387:	e9 f4 f3 ff ff       	jmp    105780 <alltraps>

0010638c <vector218>:
  10638c:	6a 00                	push   $0x0
  10638e:	68 da 00 00 00       	push   $0xda
  106393:	e9 e8 f3 ff ff       	jmp    105780 <alltraps>

00106398 <vector219>:
  106398:	6a 00                	push   $0x0
  10639a:	68 db 00 00 00       	push   $0xdb
  10639f:	e9 dc f3 ff ff       	jmp    105780 <alltraps>

001063a4 <vector220>:
  1063a4:	6a 00                	push   $0x0
  1063a6:	68 dc 00 00 00       	push   $0xdc
  1063ab:	e9 d0 f3 ff ff       	jmp    105780 <alltraps>

001063b0 <vector221>:
  1063b0:	6a 00                	push   $0x0
  1063b2:	68 dd 00 00 00       	push   $0xdd
  1063b7:	e9 c4 f3 ff ff       	jmp    105780 <alltraps>

001063bc <vector222>:
  1063bc:	6a 00                	push   $0x0
  1063be:	68 de 00 00 00       	push   $0xde
  1063c3:	e9 b8 f3 ff ff       	jmp    105780 <alltraps>

001063c8 <vector223>:
  1063c8:	6a 00                	push   $0x0
  1063ca:	68 df 00 00 00       	push   $0xdf
  1063cf:	e9 ac f3 ff ff       	jmp    105780 <alltraps>

001063d4 <vector224>:
  1063d4:	6a 00                	push   $0x0
  1063d6:	68 e0 00 00 00       	push   $0xe0
  1063db:	e9 a0 f3 ff ff       	jmp    105780 <alltraps>

001063e0 <vector225>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	68 e1 00 00 00       	push   $0xe1
  1063e7:	e9 94 f3 ff ff       	jmp    105780 <alltraps>

001063ec <vector226>:
  1063ec:	6a 00                	push   $0x0
  1063ee:	68 e2 00 00 00       	push   $0xe2
  1063f3:	e9 88 f3 ff ff       	jmp    105780 <alltraps>

001063f8 <vector227>:
  1063f8:	6a 00                	push   $0x0
  1063fa:	68 e3 00 00 00       	push   $0xe3
  1063ff:	e9 7c f3 ff ff       	jmp    105780 <alltraps>

00106404 <vector228>:
  106404:	6a 00                	push   $0x0
  106406:	68 e4 00 00 00       	push   $0xe4
  10640b:	e9 70 f3 ff ff       	jmp    105780 <alltraps>

00106410 <vector229>:
  106410:	6a 00                	push   $0x0
  106412:	68 e5 00 00 00       	push   $0xe5
  106417:	e9 64 f3 ff ff       	jmp    105780 <alltraps>

0010641c <vector230>:
  10641c:	6a 00                	push   $0x0
  10641e:	68 e6 00 00 00       	push   $0xe6
  106423:	e9 58 f3 ff ff       	jmp    105780 <alltraps>

00106428 <vector231>:
  106428:	6a 00                	push   $0x0
  10642a:	68 e7 00 00 00       	push   $0xe7
  10642f:	e9 4c f3 ff ff       	jmp    105780 <alltraps>

00106434 <vector232>:
  106434:	6a 00                	push   $0x0
  106436:	68 e8 00 00 00       	push   $0xe8
  10643b:	e9 40 f3 ff ff       	jmp    105780 <alltraps>

00106440 <vector233>:
  106440:	6a 00                	push   $0x0
  106442:	68 e9 00 00 00       	push   $0xe9
  106447:	e9 34 f3 ff ff       	jmp    105780 <alltraps>

0010644c <vector234>:
  10644c:	6a 00                	push   $0x0
  10644e:	68 ea 00 00 00       	push   $0xea
  106453:	e9 28 f3 ff ff       	jmp    105780 <alltraps>

00106458 <vector235>:
  106458:	6a 00                	push   $0x0
  10645a:	68 eb 00 00 00       	push   $0xeb
  10645f:	e9 1c f3 ff ff       	jmp    105780 <alltraps>

00106464 <vector236>:
  106464:	6a 00                	push   $0x0
  106466:	68 ec 00 00 00       	push   $0xec
  10646b:	e9 10 f3 ff ff       	jmp    105780 <alltraps>

00106470 <vector237>:
  106470:	6a 00                	push   $0x0
  106472:	68 ed 00 00 00       	push   $0xed
  106477:	e9 04 f3 ff ff       	jmp    105780 <alltraps>

0010647c <vector238>:
  10647c:	6a 00                	push   $0x0
  10647e:	68 ee 00 00 00       	push   $0xee
  106483:	e9 f8 f2 ff ff       	jmp    105780 <alltraps>

00106488 <vector239>:
  106488:	6a 00                	push   $0x0
  10648a:	68 ef 00 00 00       	push   $0xef
  10648f:	e9 ec f2 ff ff       	jmp    105780 <alltraps>

00106494 <vector240>:
  106494:	6a 00                	push   $0x0
  106496:	68 f0 00 00 00       	push   $0xf0
  10649b:	e9 e0 f2 ff ff       	jmp    105780 <alltraps>

001064a0 <vector241>:
  1064a0:	6a 00                	push   $0x0
  1064a2:	68 f1 00 00 00       	push   $0xf1
  1064a7:	e9 d4 f2 ff ff       	jmp    105780 <alltraps>

001064ac <vector242>:
  1064ac:	6a 00                	push   $0x0
  1064ae:	68 f2 00 00 00       	push   $0xf2
  1064b3:	e9 c8 f2 ff ff       	jmp    105780 <alltraps>

001064b8 <vector243>:
  1064b8:	6a 00                	push   $0x0
  1064ba:	68 f3 00 00 00       	push   $0xf3
  1064bf:	e9 bc f2 ff ff       	jmp    105780 <alltraps>

001064c4 <vector244>:
  1064c4:	6a 00                	push   $0x0
  1064c6:	68 f4 00 00 00       	push   $0xf4
  1064cb:	e9 b0 f2 ff ff       	jmp    105780 <alltraps>

001064d0 <vector245>:
  1064d0:	6a 00                	push   $0x0
  1064d2:	68 f5 00 00 00       	push   $0xf5
  1064d7:	e9 a4 f2 ff ff       	jmp    105780 <alltraps>

001064dc <vector246>:
  1064dc:	6a 00                	push   $0x0
  1064de:	68 f6 00 00 00       	push   $0xf6
  1064e3:	e9 98 f2 ff ff       	jmp    105780 <alltraps>

001064e8 <vector247>:
  1064e8:	6a 00                	push   $0x0
  1064ea:	68 f7 00 00 00       	push   $0xf7
  1064ef:	e9 8c f2 ff ff       	jmp    105780 <alltraps>

001064f4 <vector248>:
  1064f4:	6a 00                	push   $0x0
  1064f6:	68 f8 00 00 00       	push   $0xf8
  1064fb:	e9 80 f2 ff ff       	jmp    105780 <alltraps>

00106500 <vector249>:
  106500:	6a 00                	push   $0x0
  106502:	68 f9 00 00 00       	push   $0xf9
  106507:	e9 74 f2 ff ff       	jmp    105780 <alltraps>

0010650c <vector250>:
  10650c:	6a 00                	push   $0x0
  10650e:	68 fa 00 00 00       	push   $0xfa
  106513:	e9 68 f2 ff ff       	jmp    105780 <alltraps>

00106518 <vector251>:
  106518:	6a 00                	push   $0x0
  10651a:	68 fb 00 00 00       	push   $0xfb
  10651f:	e9 5c f2 ff ff       	jmp    105780 <alltraps>

00106524 <vector252>:
  106524:	6a 00                	push   $0x0
  106526:	68 fc 00 00 00       	push   $0xfc
  10652b:	e9 50 f2 ff ff       	jmp    105780 <alltraps>

00106530 <vector253>:
  106530:	6a 00                	push   $0x0
  106532:	68 fd 00 00 00       	push   $0xfd
  106537:	e9 44 f2 ff ff       	jmp    105780 <alltraps>

0010653c <vector254>:
  10653c:	6a 00                	push   $0x0
  10653e:	68 fe 00 00 00       	push   $0xfe
  106543:	e9 38 f2 ff ff       	jmp    105780 <alltraps>

00106548 <vector255>:
  106548:	6a 00                	push   $0x0
  10654a:	68 ff 00 00 00       	push   $0xff
  10654f:	e9 2c f2 ff ff       	jmp    105780 <alltraps>
