
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 28 44 00 00       	mov    0x4428,%eax
       b:	c7 44 24 04 b0 31 00 	movl   $0x31b0,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 85 2e 00 00       	call   2ea0 <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 bb 31 00 00 	movl   $0x31bb,(%esp)
      2a:	e8 29 2d 00 00       	call   2d58 <open>
  if(fd < 0){
      2f:	85 c0                	test   %eax,%eax
      31:	78 37                	js     6a <opentest+0x6a>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 05 2d 00 00       	call   2d40 <close>
  fd = open("doesnotexist", 0);
      3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      42:	00 
      43:	c7 04 24 d3 31 00 00 	movl   $0x31d3,(%esp)
      4a:	e8 09 2d 00 00       	call   2d58 <open>
  if(fd >= 0){
      4f:	85 c0                	test   %eax,%eax
      51:	79 31                	jns    84 <opentest+0x84>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
      53:	a1 28 44 00 00       	mov    0x4428,%eax
      58:	c7 44 24 04 fe 31 00 	movl   $0x31fe,0x4(%esp)
      5f:	00 
      60:	89 04 24             	mov    %eax,(%esp)
      63:	e8 38 2e 00 00       	call   2ea0 <printf>
}
      68:	c9                   	leave  
      69:	c3                   	ret    
  int fd;

  printf(stdout, "open test\n");
  fd = open("echo", 0);
  if(fd < 0){
    printf(stdout, "open echo failed!\n");
      6a:	a1 28 44 00 00       	mov    0x4428,%eax
      6f:	c7 44 24 04 c0 31 00 	movl   $0x31c0,0x4(%esp)
      76:	00 
      77:	89 04 24             	mov    %eax,(%esp)
      7a:	e8 21 2e 00 00       	call   2ea0 <printf>
    exit();
      7f:	e8 94 2c 00 00       	call   2d18 <exit>
  }
  close(fd);
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
      84:	a1 28 44 00 00       	mov    0x4428,%eax
      89:	c7 44 24 04 e0 31 00 	movl   $0x31e0,0x4(%esp)
      90:	00 
      91:	89 04 24             	mov    %eax,(%esp)
      94:	e8 07 2e 00 00       	call   2ea0 <printf>
    exit();
      99:	e8 7a 2c 00 00       	call   2d18 <exit>
      9e:	66 90                	xchg   %ax,%ax

000000a0 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a0:	55                   	push   %ebp
      a1:	89 e5                	mov    %esp,%ebp
      a3:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
      a4:	31 db                	xor    %ebx,%ebx
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
      a6:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
      a9:	c7 44 24 04 0c 32 00 	movl   $0x320c,0x4(%esp)
      b0:	00 
      b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b8:	e8 e3 2d 00 00       	call   2ea0 <printf>
      bd:	eb 13                	jmp    d2 <forktest+0x32>
      bf:	90                   	nop

  for(n=0; n<1000; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
      c0:	74 72                	je     134 <forktest+0x94>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
      c2:	83 c3 01             	add    $0x1,%ebx
      c5:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
      cb:	90                   	nop
      cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      d0:	74 4e                	je     120 <forktest+0x80>
      d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
      d8:	e8 33 2c 00 00       	call   2d10 <fork>
    if(pid < 0)
      dd:	83 f8 00             	cmp    $0x0,%eax
      e0:	7d de                	jge    c0 <forktest+0x20>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      e2:	85 db                	test   %ebx,%ebx
      e4:	74 11                	je     f7 <forktest+0x57>
      e6:	66 90                	xchg   %ax,%ax
    if(wait() < 0){
      e8:	e8 33 2c 00 00       	call   2d20 <wait>
      ed:	85 c0                	test   %eax,%eax
      ef:	90                   	nop
      f0:	78 47                	js     139 <forktest+0x99>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
      f2:	83 eb 01             	sub    $0x1,%ebx
      f5:	75 f1                	jne    e8 <forktest+0x48>
      f7:	90                   	nop
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
      f8:	e8 23 2c 00 00       	call   2d20 <wait>
      fd:	83 f8 ff             	cmp    $0xffffffff,%eax
     100:	75 50                	jne    152 <forktest+0xb2>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
     102:	c7 44 24 04 3e 32 00 	movl   $0x323e,0x4(%esp)
     109:	00 
     10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     111:	e8 8a 2d 00 00       	call   2ea0 <printf>
}
     116:	83 c4 14             	add    $0x14,%esp
     119:	5b                   	pop    %ebx
     11a:	5d                   	pop    %ebp
     11b:	c3                   	ret    
     11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
     120:	c7 44 24 04 98 3e 00 	movl   $0x3e98,0x4(%esp)
     127:	00 
     128:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     12f:	e8 6c 2d 00 00       	call   2ea0 <printf>
    exit();
     134:	e8 df 2b 00 00       	call   2d18 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
     139:	c7 44 24 04 17 32 00 	movl   $0x3217,0x4(%esp)
     140:	00 
     141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     148:	e8 53 2d 00 00       	call   2ea0 <printf>
      exit();
     14d:	e8 c6 2b 00 00       	call   2d18 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
     152:	c7 44 24 04 2b 32 00 	movl   $0x322b,0x4(%esp)
     159:	00 
     15a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     161:	e8 3a 2d 00 00       	call   2ea0 <printf>
    exit();
     166:	e8 ad 2b 00 00       	call   2d18 <exit>
     16b:	90                   	nop
     16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000170 <exitwait>:
}

// try to find any races between exit and wait
void
exitwait(void)
{
     170:	55                   	push   %ebp
     171:	89 e5                	mov    %esp,%ebp
     173:	56                   	push   %esi
     174:	31 f6                	xor    %esi,%esi
     176:	53                   	push   %ebx
     177:	83 ec 10             	sub    $0x10,%esp
     17a:	eb 17                	jmp    193 <exitwait+0x23>
     17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     180:	74 79                	je     1fb <exitwait+0x8b>
      if(wait() != pid){
     182:	e8 99 2b 00 00       	call   2d20 <wait>
     187:	39 c3                	cmp    %eax,%ebx
     189:	75 35                	jne    1c0 <exitwait+0x50>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     18b:	83 c6 01             	add    $0x1,%esi
     18e:	83 fe 64             	cmp    $0x64,%esi
     191:	74 4d                	je     1e0 <exitwait+0x70>
    pid = fork();
     193:	e8 78 2b 00 00       	call   2d10 <fork>
    if(pid < 0){
     198:	83 f8 00             	cmp    $0x0,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     19b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     19d:	7d e1                	jge    180 <exitwait+0x10>
      printf(1, "fork failed\n");
     19f:	c7 44 24 04 4c 32 00 	movl   $0x324c,0x4(%esp)
     1a6:	00 
     1a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ae:	e8 ed 2c 00 00       	call   2ea0 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1b3:	83 c4 10             	add    $0x10,%esp
     1b6:	5b                   	pop    %ebx
     1b7:	5e                   	pop    %esi
     1b8:	5d                   	pop    %ebp
     1b9:	c3                   	ret    
     1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
     1c0:	c7 44 24 04 59 32 00 	movl   $0x3259,0x4(%esp)
     1c7:	00 
     1c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1cf:	e8 cc 2c 00 00       	call   2ea0 <printf>
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     1d4:	83 c4 10             	add    $0x10,%esp
     1d7:	5b                   	pop    %ebx
     1d8:	5e                   	pop    %esi
     1d9:	5d                   	pop    %ebp
     1da:	c3                   	ret    
     1db:	90                   	nop
     1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     1e0:	c7 44 24 04 69 32 00 	movl   $0x3269,0x4(%esp)
     1e7:	00 
     1e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ef:	e8 ac 2c 00 00       	call   2ea0 <printf>
}
     1f4:	83 c4 10             	add    $0x10,%esp
     1f7:	5b                   	pop    %ebx
     1f8:	5e                   	pop    %esi
     1f9:	5d                   	pop    %ebp
     1fa:	c3                   	ret    
      if(wait() != pid){
        printf(1, "wait wrong pid\n");
        return;
      }
    } else {
      exit();
     1fb:	e8 18 2b 00 00       	call   2d18 <exit>

00000200 <fourteen>:
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
     206:	c7 44 24 04 76 32 00 	movl   $0x3276,0x4(%esp)
     20d:	00 
     20e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     215:	e8 86 2c 00 00       	call   2ea0 <printf>

  if(mkdir("12345678901234") != 0){
     21a:	c7 04 24 b1 32 00 00 	movl   $0x32b1,(%esp)
     221:	e8 5a 2b 00 00       	call   2d80 <mkdir>
     226:	85 c0                	test   %eax,%eax
     228:	0f 85 92 00 00 00    	jne    2c0 <fourteen+0xc0>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
     22e:	c7 04 24 bc 3e 00 00 	movl   $0x3ebc,(%esp)
     235:	e8 46 2b 00 00       	call   2d80 <mkdir>
     23a:	85 c0                	test   %eax,%eax
     23c:	0f 85 fb 00 00 00    	jne    33d <fourteen+0x13d>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     242:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     249:	00 
     24a:	c7 04 24 0c 3f 00 00 	movl   $0x3f0c,(%esp)
     251:	e8 02 2b 00 00       	call   2d58 <open>
  if(fd < 0){
     256:	85 c0                	test   %eax,%eax
     258:	0f 88 c6 00 00 00    	js     324 <fourteen+0x124>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
     25e:	89 04 24             	mov    %eax,(%esp)
     261:	e8 da 2a 00 00       	call   2d40 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     266:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     26d:	00 
     26e:	c7 04 24 7c 3f 00 00 	movl   $0x3f7c,(%esp)
     275:	e8 de 2a 00 00       	call   2d58 <open>
  if(fd < 0){
     27a:	85 c0                	test   %eax,%eax
     27c:	0f 88 89 00 00 00    	js     30b <fourteen+0x10b>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
     282:	89 04 24             	mov    %eax,(%esp)
     285:	e8 b6 2a 00 00       	call   2d40 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
     28a:	c7 04 24 a2 32 00 00 	movl   $0x32a2,(%esp)
     291:	e8 ea 2a 00 00       	call   2d80 <mkdir>
     296:	85 c0                	test   %eax,%eax
     298:	74 58                	je     2f2 <fourteen+0xf2>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
     29a:	c7 04 24 18 40 00 00 	movl   $0x4018,(%esp)
     2a1:	e8 da 2a 00 00       	call   2d80 <mkdir>
     2a6:	85 c0                	test   %eax,%eax
     2a8:	74 2f                	je     2d9 <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
     2aa:	c7 44 24 04 c0 32 00 	movl   $0x32c0,0x4(%esp)
     2b1:	00 
     2b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2b9:	e8 e2 2b 00 00       	call   2ea0 <printf>
}
     2be:	c9                   	leave  
     2bf:	c3                   	ret    

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
     2c0:	c7 44 24 04 85 32 00 	movl   $0x3285,0x4(%esp)
     2c7:	00 
     2c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2cf:	e8 cc 2b 00 00       	call   2ea0 <printf>
    exit();
     2d4:	e8 3f 2a 00 00       	call   2d18 <exit>
  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
     2d9:	c7 44 24 04 38 40 00 	movl   $0x4038,0x4(%esp)
     2e0:	00 
     2e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2e8:	e8 b3 2b 00 00       	call   2ea0 <printf>
    exit();
     2ed:	e8 26 2a 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
     2f2:	c7 44 24 04 e8 3f 00 	movl   $0x3fe8,0x4(%esp)
     2f9:	00 
     2fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     301:	e8 9a 2b 00 00       	call   2ea0 <printf>
    exit();
     306:	e8 0d 2a 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
     30b:	c7 44 24 04 ac 3f 00 	movl   $0x3fac,0x4(%esp)
     312:	00 
     313:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     31a:	e8 81 2b 00 00       	call   2ea0 <printf>
    exit();
     31f:	e8 f4 29 00 00       	call   2d18 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
     324:	c7 44 24 04 3c 3f 00 	movl   $0x3f3c,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     333:	e8 68 2b 00 00       	call   2ea0 <printf>
    exit();
     338:	e8 db 29 00 00       	call   2d18 <exit>
  if(mkdir("12345678901234") != 0){
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
     33d:	c7 44 24 04 dc 3e 00 	movl   $0x3edc,0x4(%esp)
     344:	00 
     345:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     34c:	e8 4f 2b 00 00       	call   2ea0 <printf>
    exit();
     351:	e8 c2 29 00 00       	call   2d18 <exit>
     356:	8d 76 00             	lea    0x0(%esi),%esi
     359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	53                   	push   %ebx
  int i, fd;

  printf(1, "empty file name\n");
     364:	31 db                	xor    %ebx,%ebx
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
     366:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(1, "empty file name\n");
     369:	c7 44 24 04 cd 32 00 	movl   $0x32cd,0x4(%esp)
     370:	00 
     371:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     378:	e8 23 2b 00 00       	call   2ea0 <printf>
     37d:	8d 76 00             	lea    0x0(%esi),%esi

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
     380:	c7 04 24 de 32 00 00 	movl   $0x32de,(%esp)
     387:	e8 f4 29 00 00       	call   2d80 <mkdir>
     38c:	85 c0                	test   %eax,%eax
     38e:	0f 85 b2 00 00 00    	jne    446 <iref+0xe6>
      printf(1, "mkdir irefd failed\n");
      exit();
    }
    if(chdir("irefd") != 0){
     394:	c7 04 24 de 32 00 00 	movl   $0x32de,(%esp)
     39b:	e8 e8 29 00 00       	call   2d88 <chdir>
     3a0:	85 c0                	test   %eax,%eax
     3a2:	0f 85 b7 00 00 00    	jne    45f <iref+0xff>
      printf(1, "chdir irefd failed\n");
      exit();
    }

    mkdir("");
     3a8:	c7 04 24 8f 3d 00 00 	movl   $0x3d8f,(%esp)
     3af:	e8 cc 29 00 00       	call   2d80 <mkdir>
    link("README", "");
     3b4:	c7 44 24 04 8f 3d 00 	movl   $0x3d8f,0x4(%esp)
     3bb:	00 
     3bc:	c7 04 24 0c 33 00 00 	movl   $0x330c,(%esp)
     3c3:	e8 b0 29 00 00       	call   2d78 <link>
    fd = open("", O_CREATE);
     3c8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     3cf:	00 
     3d0:	c7 04 24 8f 3d 00 00 	movl   $0x3d8f,(%esp)
     3d7:	e8 7c 29 00 00       	call   2d58 <open>
    if(fd >= 0)
     3dc:	85 c0                	test   %eax,%eax
     3de:	78 08                	js     3e8 <iref+0x88>
      close(fd);
     3e0:	89 04 24             	mov    %eax,(%esp)
     3e3:	e8 58 29 00 00       	call   2d40 <close>
    fd = open("xx", O_CREATE);
     3e8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     3ef:	00 
     3f0:	c7 04 24 7e 38 00 00 	movl   $0x387e,(%esp)
     3f7:	e8 5c 29 00 00       	call   2d58 <open>
    if(fd >= 0)
     3fc:	85 c0                	test   %eax,%eax
     3fe:	78 08                	js     408 <iref+0xa8>
      close(fd);
     400:	89 04 24             	mov    %eax,(%esp)
     403:	e8 38 29 00 00       	call   2d40 <close>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     408:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
     40b:	c7 04 24 7e 38 00 00 	movl   $0x387e,(%esp)
     412:	e8 51 29 00 00       	call   2d68 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
     417:	83 fb 33             	cmp    $0x33,%ebx
     41a:	0f 85 60 ff ff ff    	jne    380 <iref+0x20>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
     420:	c7 04 24 13 33 00 00 	movl   $0x3313,(%esp)
     427:	e8 5c 29 00 00       	call   2d88 <chdir>
  printf(1, "empty file name OK\n");
     42c:	c7 44 24 04 15 33 00 	movl   $0x3315,0x4(%esp)
     433:	00 
     434:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     43b:	e8 60 2a 00 00       	call   2ea0 <printf>
}
     440:	83 c4 14             	add    $0x14,%esp
     443:	5b                   	pop    %ebx
     444:	5d                   	pop    %ebp
     445:	c3                   	ret    
  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
     446:	c7 44 24 04 e4 32 00 	movl   $0x32e4,0x4(%esp)
     44d:	00 
     44e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     455:	e8 46 2a 00 00       	call   2ea0 <printf>
      exit();
     45a:	e8 b9 28 00 00       	call   2d18 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
     45f:	c7 44 24 04 f8 32 00 	movl   $0x32f8,0x4(%esp)
     466:	00 
     467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     46e:	e8 2d 2a 00 00       	call   2ea0 <printf>
      exit();
     473:	e8 a0 28 00 00       	call   2d18 <exit>
     478:	90                   	nop
     479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <rmdot>:
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
     486:	c7 44 24 04 29 33 00 	movl   $0x3329,0x4(%esp)
     48d:	00 
     48e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     495:	e8 06 2a 00 00       	call   2ea0 <printf>
  if(mkdir("dots") != 0){
     49a:	c7 04 24 35 33 00 00 	movl   $0x3335,(%esp)
     4a1:	e8 da 28 00 00       	call   2d80 <mkdir>
     4a6:	85 c0                	test   %eax,%eax
     4a8:	0f 85 9a 00 00 00    	jne    548 <rmdot+0xc8>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
     4ae:	c7 04 24 35 33 00 00 	movl   $0x3335,(%esp)
     4b5:	e8 ce 28 00 00       	call   2d88 <chdir>
     4ba:	85 c0                	test   %eax,%eax
     4bc:	0f 85 35 01 00 00    	jne    5f7 <rmdot+0x177>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
     4c2:	c7 04 24 9c 37 00 00 	movl   $0x379c,(%esp)
     4c9:	e8 9a 28 00 00       	call   2d68 <unlink>
     4ce:	85 c0                	test   %eax,%eax
     4d0:	0f 84 08 01 00 00    	je     5de <rmdot+0x15e>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
     4d6:	c7 04 24 9b 37 00 00 	movl   $0x379b,(%esp)
     4dd:	e8 86 28 00 00       	call   2d68 <unlink>
     4e2:	85 c0                	test   %eax,%eax
     4e4:	0f 84 db 00 00 00    	je     5c5 <rmdot+0x145>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
     4ea:	c7 04 24 13 33 00 00 	movl   $0x3313,(%esp)
     4f1:	e8 92 28 00 00       	call   2d88 <chdir>
     4f6:	85 c0                	test   %eax,%eax
     4f8:	0f 85 ae 00 00 00    	jne    5ac <rmdot+0x12c>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
     4fe:	c7 04 24 8d 33 00 00 	movl   $0x338d,(%esp)
     505:	e8 5e 28 00 00       	call   2d68 <unlink>
     50a:	85 c0                	test   %eax,%eax
     50c:	0f 84 81 00 00 00    	je     593 <rmdot+0x113>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
     512:	c7 04 24 ab 33 00 00 	movl   $0x33ab,(%esp)
     519:	e8 4a 28 00 00       	call   2d68 <unlink>
     51e:	85 c0                	test   %eax,%eax
     520:	74 58                	je     57a <rmdot+0xfa>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
     522:	c7 04 24 35 33 00 00 	movl   $0x3335,(%esp)
     529:	e8 3a 28 00 00       	call   2d68 <unlink>
     52e:	85 c0                	test   %eax,%eax
     530:	75 2f                	jne    561 <rmdot+0xe1>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
     532:	c7 44 24 04 e0 33 00 	movl   $0x33e0,0x4(%esp)
     539:	00 
     53a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     541:	e8 5a 29 00 00       	call   2ea0 <printf>
}
     546:	c9                   	leave  
     547:	c3                   	ret    
void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
     548:	c7 44 24 04 3a 33 00 	movl   $0x333a,0x4(%esp)
     54f:	00 
     550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     557:	e8 44 29 00 00       	call   2ea0 <printf>
    exit();
     55c:	e8 b7 27 00 00       	call   2d18 <exit>
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
     561:	c7 44 24 04 cb 33 00 	movl   $0x33cb,0x4(%esp)
     568:	00 
     569:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     570:	e8 2b 29 00 00       	call   2ea0 <printf>
    exit();
     575:	e8 9e 27 00 00       	call   2d18 <exit>
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
     57a:	c7 44 24 04 b3 33 00 	movl   $0x33b3,0x4(%esp)
     581:	00 
     582:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     589:	e8 12 29 00 00       	call   2ea0 <printf>
    exit();
     58e:	e8 85 27 00 00       	call   2d18 <exit>
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    printf(1, "unlink dots/. worked!\n");
     593:	c7 44 24 04 94 33 00 	movl   $0x3394,0x4(%esp)
     59a:	00 
     59b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5a2:	e8 f9 28 00 00       	call   2ea0 <printf>
    exit();
     5a7:	e8 6c 27 00 00       	call   2d18 <exit>
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
     5ac:	c7 44 24 04 7d 33 00 	movl   $0x337d,0x4(%esp)
     5b3:	00 
     5b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5bb:	e8 e0 28 00 00       	call   2ea0 <printf>
    exit();
     5c0:	e8 53 27 00 00       	call   2d18 <exit>
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
     5c5:	c7 44 24 04 6e 33 00 	movl   $0x336e,0x4(%esp)
     5cc:	00 
     5cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5d4:	e8 c7 28 00 00       	call   2ea0 <printf>
    exit();
     5d9:	e8 3a 27 00 00       	call   2d18 <exit>
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
     5de:	c7 44 24 04 60 33 00 	movl   $0x3360,0x4(%esp)
     5e5:	00 
     5e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5ed:	e8 ae 28 00 00       	call   2ea0 <printf>
    exit();
     5f2:	e8 21 27 00 00       	call   2d18 <exit>
  if(mkdir("dots") != 0){
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
     5f7:	c7 44 24 04 4d 33 00 	movl   $0x334d,0x4(%esp)
     5fe:	00 
     5ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     606:	e8 95 28 00 00       	call   2ea0 <printf>
    exit();
     60b:	e8 08 27 00 00       	call   2d18 <exit>

00000610 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
     610:	55                   	push   %ebp
     611:	89 e5                	mov    %esp,%ebp
     613:	56                   	push   %esi
     614:	53                   	push   %ebx
     615:	83 ec 20             	sub    $0x20,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
     618:	c7 44 24 04 ea 33 00 	movl   $0x33ea,0x4(%esp)
     61f:	00 
     620:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     627:	e8 74 28 00 00       	call   2ea0 <printf>
  unlink("bd");
     62c:	c7 04 24 f7 33 00 00 	movl   $0x33f7,(%esp)
     633:	e8 30 27 00 00       	call   2d68 <unlink>

  fd = open("bd", O_CREATE);
     638:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     63f:	00 
     640:	c7 04 24 f7 33 00 00 	movl   $0x33f7,(%esp)
     647:	e8 0c 27 00 00       	call   2d58 <open>
  if(fd < 0){
     64c:	85 c0                	test   %eax,%eax
     64e:	0f 88 e6 00 00 00    	js     73a <bigdir+0x12a>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
     654:	89 04 24             	mov    %eax,(%esp)
     657:	31 db                	xor    %ebx,%ebx
     659:	e8 e2 26 00 00       	call   2d40 <close>
     65e:	8d 75 ee             	lea    -0x12(%ebp),%esi
     661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     668:	89 d8                	mov    %ebx,%eax
     66a:	c1 f8 06             	sar    $0x6,%eax
     66d:	83 c0 30             	add    $0x30,%eax
     670:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     673:	89 d8                	mov    %ebx,%eax
     675:	83 e0 3f             	and    $0x3f,%eax
     678:	83 c0 30             	add    $0x30,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
     67b:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     67f:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     682:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
     686:	89 74 24 04          	mov    %esi,0x4(%esp)
     68a:	c7 04 24 f7 33 00 00 	movl   $0x33f7,(%esp)
     691:	e8 e2 26 00 00       	call   2d78 <link>
     696:	85 c0                	test   %eax,%eax
     698:	75 6e                	jne    708 <bigdir+0xf8>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
     69a:	83 c3 01             	add    $0x1,%ebx
     69d:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     6a3:	75 c3                	jne    668 <bigdir+0x58>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
     6a5:	c7 04 24 f7 33 00 00 	movl   $0x33f7,(%esp)
     6ac:	66 31 db             	xor    %bx,%bx
     6af:	e8 b4 26 00 00       	call   2d68 <unlink>
     6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
     6b8:	89 d8                	mov    %ebx,%eax
     6ba:	c1 f8 06             	sar    $0x6,%eax
     6bd:	83 c0 30             	add    $0x30,%eax
     6c0:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
     6c3:	89 d8                	mov    %ebx,%eax
     6c5:	83 e0 3f             	and    $0x3f,%eax
     6c8:	83 c0 30             	add    $0x30,%eax
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
     6cb:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
     6cf:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
     6d2:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
     6d6:	89 34 24             	mov    %esi,(%esp)
     6d9:	e8 8a 26 00 00       	call   2d68 <unlink>
     6de:	85 c0                	test   %eax,%eax
     6e0:	75 3f                	jne    721 <bigdir+0x111>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
     6e2:	83 c3 01             	add    $0x1,%ebx
     6e5:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
     6eb:	75 cb                	jne    6b8 <bigdir+0xa8>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
     6ed:	c7 44 24 04 39 34 00 	movl   $0x3439,0x4(%esp)
     6f4:	00 
     6f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6fc:	e8 9f 27 00 00       	call   2ea0 <printf>
}
     701:	83 c4 20             	add    $0x20,%esp
     704:	5b                   	pop    %ebx
     705:	5e                   	pop    %esi
     706:	5d                   	pop    %ebp
     707:	c3                   	ret    
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
      printf(1, "bigdir link failed\n");
     708:	c7 44 24 04 10 34 00 	movl   $0x3410,0x4(%esp)
     70f:	00 
     710:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     717:	e8 84 27 00 00       	call   2ea0 <printf>
      exit();
     71c:	e8 f7 25 00 00       	call   2d18 <exit>
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
      printf(1, "bigdir unlink failed");
     721:	c7 44 24 04 24 34 00 	movl   $0x3424,0x4(%esp)
     728:	00 
     729:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     730:	e8 6b 27 00 00       	call   2ea0 <printf>
      exit();
     735:	e8 de 25 00 00       	call   2d18 <exit>
  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
     73a:	c7 44 24 04 fa 33 00 	movl   $0x33fa,0x4(%esp)
     741:	00 
     742:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     749:	e8 52 27 00 00       	call   2ea0 <printf>
    exit();
     74e:	e8 c5 25 00 00       	call   2d18 <exit>
     753:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000760 <createdelete>:
}

// two processes create and delete different files in same directory
void
createdelete(void)
{
     760:	55                   	push   %ebp
     761:	89 e5                	mov    %esp,%ebp
     763:	57                   	push   %edi
     764:	56                   	push   %esi
     765:	53                   	push   %ebx
     766:	83 ec 4c             	sub    $0x4c,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     769:	c7 44 24 04 44 34 00 	movl   $0x3444,0x4(%esp)
     770:	00 
     771:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     778:	e8 23 27 00 00       	call   2ea0 <printf>
  pid = fork();
     77d:	e8 8e 25 00 00       	call   2d10 <fork>
  if(pid < 0){
     782:	85 c0                	test   %eax,%eax
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
     784:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if(pid < 0){
     787:	0f 88 0d 02 00 00    	js     99a <createdelete+0x23a>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     78d:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
  name[2] = '\0';
     791:	bf 01 00 00 00       	mov    $0x1,%edi
     796:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
     79a:	8d 75 c8             	lea    -0x38(%ebp),%esi
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     79d:	19 c0                	sbb    %eax,%eax
  name[2] = '\0';
     79f:	31 db                	xor    %ebx,%ebx
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
     7a1:	83 e0 f3             	and    $0xfffffff3,%eax
     7a4:	83 c0 70             	add    $0x70,%eax
     7a7:	88 45 c8             	mov    %al,-0x38(%ebp)
     7aa:	eb 0f                	jmp    7bb <createdelete+0x5b>
     7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  name[2] = '\0';
  for(i = 0; i < N; i++){
     7b0:	83 ff 13             	cmp    $0x13,%edi
     7b3:	7f 6b                	jg     820 <createdelete+0xc0>
    printf(1, "fork failed\n");
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
     7b5:	83 c3 01             	add    $0x1,%ebx
     7b8:	83 c7 01             	add    $0x1,%edi
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
     7bb:	8d 43 30             	lea    0x30(%ebx),%eax
     7be:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
     7c1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7c8:	00 
     7c9:	89 34 24             	mov    %esi,(%esp)
     7cc:	e8 87 25 00 00       	call   2d58 <open>
    if(fd < 0){
     7d1:	85 c0                	test   %eax,%eax
     7d3:	0f 88 6e 01 00 00    	js     947 <createdelete+0x1e7>
      printf(1, "create failed\n");
      exit();
    }
    close(fd);
     7d9:	89 04 24             	mov    %eax,(%esp)
     7dc:	e8 5f 25 00 00       	call   2d40 <close>
    if(i > 0 && (i % 2 ) == 0){
     7e1:	85 db                	test   %ebx,%ebx
     7e3:	74 d0                	je     7b5 <createdelete+0x55>
     7e5:	f6 c3 01             	test   $0x1,%bl
     7e8:	75 c6                	jne    7b0 <createdelete+0x50>
      name[1] = '0' + (i / 2);
     7ea:	89 d8                	mov    %ebx,%eax
     7ec:	d1 f8                	sar    %eax
     7ee:	83 c0 30             	add    $0x30,%eax
     7f1:	88 45 c9             	mov    %al,-0x37(%ebp)
      if(unlink(name) < 0){
     7f4:	89 34 24             	mov    %esi,(%esp)
     7f7:	e8 6c 25 00 00       	call   2d68 <unlink>
     7fc:	85 c0                	test   %eax,%eax
     7fe:	79 b0                	jns    7b0 <createdelete+0x50>
        printf(1, "unlink failed\n");
     800:	c7 44 24 04 57 34 00 	movl   $0x3457,0x4(%esp)
     807:	00 
     808:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     80f:	e8 8c 26 00 00       	call   2ea0 <printf>
        exit();
     814:	e8 ff 24 00 00       	call   2d18 <exit>
     819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      }
    }
  }

  if(pid==0)
     820:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     823:	85 c0                	test   %eax,%eax
     825:	0f 84 6a 01 00 00    	je     995 <createdelete+0x235>
    exit();
  else
    wait();
     82b:	e8 f0 24 00 00       	call   2d20 <wait>
     830:	31 db                	xor    %ebx,%ebx
     832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < N; i++){
    name[0] = 'p';
     838:	8d 7b 30             	lea    0x30(%ebx),%edi
    name[1] = '0' + i;
     83b:	89 f8                	mov    %edi,%eax
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    name[0] = 'p';
     83d:	c6 45 c8 70          	movb   $0x70,-0x38(%ebp)
    name[1] = '0' + i;
     841:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, 0);
     844:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     84b:	00 
     84c:	89 34 24             	mov    %esi,(%esp)
     84f:	e8 04 25 00 00       	call   2d58 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     854:	83 fb 09             	cmp    $0x9,%ebx
     857:	0f 9f c1             	setg   %cl
     85a:	85 db                	test   %ebx,%ebx
     85c:	0f 94 c2             	sete   %dl
     85f:	08 d1                	or     %dl,%cl
     861:	88 4d c3             	mov    %cl,-0x3d(%ebp)
     864:	74 08                	je     86e <createdelete+0x10e>
     866:	85 c0                	test   %eax,%eax
     868:	0f 88 0f 01 00 00    	js     97d <createdelete+0x21d>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     86e:	8d 53 ff             	lea    -0x1(%ebx),%edx
     871:	83 fa 08             	cmp    $0x8,%edx
     874:	89 c2                	mov    %eax,%edx
     876:	f7 d2                	not    %edx
     878:	0f 96 45 c4          	setbe  -0x3c(%ebp)
     87c:	c1 ea 1f             	shr    $0x1f,%edx
     87f:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
     883:	74 23                	je     8a8 <createdelete+0x148>
     885:	84 d2                	test   %dl,%dl
     887:	74 2b                	je     8b4 <createdelete+0x154>
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
      printf(1, "oops createdelete %s did exist\n", name);
     889:	89 74 24 08          	mov    %esi,0x8(%esp)
     88d:	c7 44 24 04 90 40 00 	movl   $0x4090,0x4(%esp)
     894:	00 
     895:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     89c:	e8 ff 25 00 00       	call   2ea0 <printf>
      exit();
     8a1:	e8 72 24 00 00       	call   2d18 <exit>
     8a6:	66 90                	xchg   %ax,%ax
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
      printf(1, "oops createdelete %s did exist\n", name);
      exit();
    }
    if(fd >= 0)
     8a8:	84 d2                	test   %dl,%dl
     8aa:	74 08                	je     8b4 <createdelete+0x154>
      close(fd);
     8ac:	89 04 24             	mov    %eax,(%esp)
     8af:	e8 8c 24 00 00       	call   2d40 <close>

    name[0] = 'c';
    name[1] = '0' + i;
     8b4:	89 f8                	mov    %edi,%eax
      exit();
    }
    if(fd >= 0)
      close(fd);

    name[0] = 'c';
     8b6:	c6 45 c8 63          	movb   $0x63,-0x38(%ebp)
    name[1] = '0' + i;
     8ba:	88 45 c9             	mov    %al,-0x37(%ebp)
    fd = open(name, 0);
     8bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8c4:	00 
     8c5:	89 34 24             	mov    %esi,(%esp)
     8c8:	e8 8b 24 00 00       	call   2d58 <open>
    if((i == 0 || i >= N/2) && fd < 0){
     8cd:	80 7d c3 00          	cmpb   $0x0,-0x3d(%ebp)
     8d1:	74 08                	je     8db <createdelete+0x17b>
     8d3:	85 c0                	test   %eax,%eax
     8d5:	0f 88 85 00 00 00    	js     960 <createdelete+0x200>
      printf(1, "oops createdelete %s didn't exist\n", name);
      exit();
    } else if((i >= 1 && i < N/2) && fd >= 0){
     8db:	85 c0                	test   %eax,%eax
     8dd:	8d 76 00             	lea    0x0(%esi),%esi
     8e0:	78 13                	js     8f5 <createdelete+0x195>
     8e2:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
     8e6:	75 a1                	jne    889 <createdelete+0x129>
      printf(1, "oops createdelete %s did exist\n", name);
      exit();
    }
    if(fd >= 0)
      close(fd);
     8e8:	89 04 24             	mov    %eax,(%esp)
     8eb:	90                   	nop
     8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     8f0:	e8 4b 24 00 00       	call   2d40 <close>
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
     8f5:	83 c3 01             	add    $0x1,%ebx
     8f8:	83 fb 14             	cmp    $0x14,%ebx
     8fb:	0f 85 37 ff ff ff    	jne    838 <createdelete+0xd8>
     901:	bb 30 00 00 00       	mov    $0x30,%ebx
     906:	66 90                	xchg   %ax,%ax
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
     908:	88 5d c9             	mov    %bl,-0x37(%ebp)
    unlink(name);
    name[0] = 'c';
    unlink(name);
     90b:	83 c3 01             	add    $0x1,%ebx
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    name[0] = 'p';
     90e:	c6 45 c8 70          	movb   $0x70,-0x38(%ebp)
    name[1] = '0' + i;
    unlink(name);
     912:	89 34 24             	mov    %esi,(%esp)
     915:	e8 4e 24 00 00       	call   2d68 <unlink>
    name[0] = 'c';
     91a:	c6 45 c8 63          	movb   $0x63,-0x38(%ebp)
    unlink(name);
     91e:	89 34 24             	mov    %esi,(%esp)
     921:	e8 42 24 00 00       	call   2d68 <unlink>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
     926:	80 fb 44             	cmp    $0x44,%bl
     929:	75 dd                	jne    908 <createdelete+0x1a8>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
     92b:	c7 44 24 04 66 34 00 	movl   $0x3466,0x4(%esp)
     932:	00 
     933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     93a:	e8 61 25 00 00       	call   2ea0 <printf>
}
     93f:	83 c4 4c             	add    $0x4c,%esp
     942:	5b                   	pop    %ebx
     943:	5e                   	pop    %esi
     944:	5f                   	pop    %edi
     945:	5d                   	pop    %ebp
     946:	c3                   	ret    
  name[2] = '\0';
  for(i = 0; i < N; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "create failed\n");
     947:	c7 44 24 04 01 34 00 	movl   $0x3401,0x4(%esp)
     94e:	00 
     94f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     956:	e8 45 25 00 00       	call   2ea0 <printf>
      exit();
     95b:	e8 b8 23 00 00       	call   2d18 <exit>

    name[0] = 'c';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     960:	89 74 24 08          	mov    %esi,0x8(%esp)
     964:	c7 44 24 04 6c 40 00 	movl   $0x406c,0x4(%esp)
     96b:	00 
     96c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     973:	e8 28 25 00 00       	call   2ea0 <printf>
      exit();
     978:	e8 9b 23 00 00       	call   2d18 <exit>
  for(i = 0; i < N; i++){
    name[0] = 'p';
    name[1] = '0' + i;
    fd = open(name, 0);
    if((i == 0 || i >= N/2) && fd < 0){
      printf(1, "oops createdelete %s didn't exist\n", name);
     97d:	89 74 24 08          	mov    %esi,0x8(%esp)
     981:	c7 44 24 04 6c 40 00 	movl   $0x406c,0x4(%esp)
     988:	00 
     989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     990:	e8 0b 25 00 00       	call   2ea0 <printf>
      exit();
     995:	e8 7e 23 00 00       	call   2d18 <exit>
  char name[32];

  printf(1, "createdelete test\n");
  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
     99a:	c7 44 24 04 4c 32 00 	movl   $0x324c,0x4(%esp)
     9a1:	00 
     9a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9a9:	e8 f2 24 00 00       	call   2ea0 <printf>
    exit();
     9ae:	e8 65 23 00 00       	call   2d18 <exit>
     9b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     9b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009c0 <dirtest>:
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     9c6:	a1 28 44 00 00       	mov    0x4428,%eax
     9cb:	c7 44 24 04 77 34 00 	movl   $0x3477,0x4(%esp)
     9d2:	00 
     9d3:	89 04 24             	mov    %eax,(%esp)
     9d6:	e8 c5 24 00 00       	call   2ea0 <printf>

  if(mkdir("dir0") < 0) {
     9db:	c7 04 24 83 34 00 00 	movl   $0x3483,(%esp)
     9e2:	e8 99 23 00 00       	call   2d80 <mkdir>
     9e7:	85 c0                	test   %eax,%eax
     9e9:	78 4b                	js     a36 <dirtest+0x76>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0) {
     9eb:	c7 04 24 83 34 00 00 	movl   $0x3483,(%esp)
     9f2:	e8 91 23 00 00       	call   2d88 <chdir>
     9f7:	85 c0                	test   %eax,%eax
     9f9:	0f 88 85 00 00 00    	js     a84 <dirtest+0xc4>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0) {
     9ff:	c7 04 24 9b 37 00 00 	movl   $0x379b,(%esp)
     a06:	e8 7d 23 00 00       	call   2d88 <chdir>
     a0b:	85 c0                	test   %eax,%eax
     a0d:	78 5b                	js     a6a <dirtest+0xaa>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0) {
     a0f:	c7 04 24 83 34 00 00 	movl   $0x3483,(%esp)
     a16:	e8 4d 23 00 00       	call   2d68 <unlink>
     a1b:	85 c0                	test   %eax,%eax
     a1d:	78 31                	js     a50 <dirtest+0x90>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test\n");
     a1f:	a1 28 44 00 00       	mov    0x4428,%eax
     a24:	c7 44 24 04 77 34 00 	movl   $0x3477,0x4(%esp)
     a2b:	00 
     a2c:	89 04 24             	mov    %eax,(%esp)
     a2f:	e8 6c 24 00 00       	call   2ea0 <printf>
}
     a34:	c9                   	leave  
     a35:	c3                   	ret    
void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0) {
    printf(stdout, "mkdir failed\n");
     a36:	a1 28 44 00 00       	mov    0x4428,%eax
     a3b:	c7 44 24 04 88 34 00 	movl   $0x3488,0x4(%esp)
     a42:	00 
     a43:	89 04 24             	mov    %eax,(%esp)
     a46:	e8 55 24 00 00       	call   2ea0 <printf>
    exit();
     a4b:	e8 c8 22 00 00       	call   2d18 <exit>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0) {
    printf(stdout, "unlink dir0 failed\n");
     a50:	a1 28 44 00 00       	mov    0x4428,%eax
     a55:	c7 44 24 04 ba 34 00 	movl   $0x34ba,0x4(%esp)
     a5c:	00 
     a5d:	89 04 24             	mov    %eax,(%esp)
     a60:	e8 3b 24 00 00       	call   2ea0 <printf>
    exit();
     a65:	e8 ae 22 00 00       	call   2d18 <exit>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0) {
    printf(stdout, "chdir .. failed\n");
     a6a:	a1 28 44 00 00       	mov    0x4428,%eax
     a6f:	c7 44 24 04 a9 34 00 	movl   $0x34a9,0x4(%esp)
     a76:	00 
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 21 24 00 00       	call   2ea0 <printf>
    exit();
     a7f:	e8 94 22 00 00       	call   2d18 <exit>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0) {
    printf(stdout, "chdir dir0 failed\n");
     a84:	a1 28 44 00 00       	mov    0x4428,%eax
     a89:	c7 44 24 04 96 34 00 	movl   $0x3496,0x4(%esp)
     a90:	00 
     a91:	89 04 24             	mov    %eax,(%esp)
     a94:	e8 07 24 00 00       	call   2ea0 <printf>
    exit();
     a99:	e8 7a 22 00 00       	call   2d18 <exit>
     a9e:	66 90                	xchg   %ax,%ax

00000aa0 <createtest>:
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     aa0:	55                   	push   %ebp
     aa1:	89 e5                	mov    %esp,%ebp
     aa3:	53                   	push   %ebx
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
     aa4:	bb 30 00 00 00       	mov    $0x30,%ebx
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     aa9:	83 ec 14             	sub    $0x14,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     aac:	a1 28 44 00 00       	mov    0x4428,%eax
     ab1:	c7 44 24 04 b0 40 00 	movl   $0x40b0,0x4(%esp)
     ab8:	00 
     ab9:	89 04 24             	mov    %eax,(%esp)
     abc:	e8 df 23 00 00       	call   2ea0 <printf>

  name[0] = 'a';
     ac1:	c6 05 60 4c 00 00 61 	movb   $0x61,0x4c60
  name[2] = '\0';
     ac8:	c6 05 62 4c 00 00 00 	movb   $0x0,0x4c62
     acf:	90                   	nop
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     ad0:	88 1d 61 4c 00 00    	mov    %bl,0x4c61
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
     ad6:	83 c3 01             	add    $0x1,%ebx

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
     ad9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     ae0:	00 
     ae1:	c7 04 24 60 4c 00 00 	movl   $0x4c60,(%esp)
     ae8:	e8 6b 22 00 00       	call   2d58 <open>
    close(fd);
     aed:	89 04 24             	mov    %eax,(%esp)
     af0:	e8 4b 22 00 00       	call   2d40 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     af5:	80 fb 64             	cmp    $0x64,%bl
     af8:	75 d6                	jne    ad0 <createtest+0x30>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     afa:	c6 05 60 4c 00 00 61 	movb   $0x61,0x4c60
  name[2] = '\0';
     b01:	bb 30 00 00 00       	mov    $0x30,%ebx
     b06:	c6 05 62 4c 00 00 00 	movb   $0x0,0x4c62
     b0d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < 52; i++) {
    name[1] = '0' + i;
     b10:	88 1d 61 4c 00 00    	mov    %bl,0x4c61
    unlink(name);
     b16:	83 c3 01             	add    $0x1,%ebx
     b19:	c7 04 24 60 4c 00 00 	movl   $0x4c60,(%esp)
     b20:	e8 43 22 00 00       	call   2d68 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++) {
     b25:	80 fb 64             	cmp    $0x64,%bl
     b28:	75 e6                	jne    b10 <createtest+0x70>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     b2a:	a1 28 44 00 00       	mov    0x4428,%eax
     b2f:	c7 44 24 04 d8 40 00 	movl   $0x40d8,0x4(%esp)
     b36:	00 
     b37:	89 04 24             	mov    %eax,(%esp)
     b3a:	e8 61 23 00 00       	call   2ea0 <printf>
}
     b3f:	83 c4 14             	add    $0x14,%esp
     b42:	5b                   	pop    %ebx
     b43:	5d                   	pop    %ebp
     b44:	c3                   	ret    
     b45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b50 <dirfile>:
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	53                   	push   %ebx
     b54:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "dir vs file\n");
     b57:	c7 44 24 04 ce 34 00 	movl   $0x34ce,0x4(%esp)
     b5e:	00 
     b5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b66:	e8 35 23 00 00       	call   2ea0 <printf>

  fd = open("dirfile", O_CREATE);
     b6b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     b72:	00 
     b73:	c7 04 24 db 34 00 00 	movl   $0x34db,(%esp)
     b7a:	e8 d9 21 00 00       	call   2d58 <open>
  if(fd < 0){
     b7f:	85 c0                	test   %eax,%eax
     b81:	0f 88 4e 01 00 00    	js     cd5 <dirfile+0x185>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
     b87:	89 04 24             	mov    %eax,(%esp)
     b8a:	e8 b1 21 00 00       	call   2d40 <close>
  if(chdir("dirfile") == 0){
     b8f:	c7 04 24 db 34 00 00 	movl   $0x34db,(%esp)
     b96:	e8 ed 21 00 00       	call   2d88 <chdir>
     b9b:	85 c0                	test   %eax,%eax
     b9d:	0f 84 19 01 00 00    	je     cbc <dirfile+0x16c>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
     ba3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     baa:	00 
     bab:	c7 04 24 14 35 00 00 	movl   $0x3514,(%esp)
     bb2:	e8 a1 21 00 00       	call   2d58 <open>
  if(fd >= 0){
     bb7:	85 c0                	test   %eax,%eax
     bb9:	0f 89 e4 00 00 00    	jns    ca3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
     bbf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     bc6:	00 
     bc7:	c7 04 24 14 35 00 00 	movl   $0x3514,(%esp)
     bce:	e8 85 21 00 00       	call   2d58 <open>
  if(fd >= 0){
     bd3:	85 c0                	test   %eax,%eax
     bd5:	0f 89 c8 00 00 00    	jns    ca3 <dirfile+0x153>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
     bdb:	c7 04 24 14 35 00 00 	movl   $0x3514,(%esp)
     be2:	e8 99 21 00 00       	call   2d80 <mkdir>
     be7:	85 c0                	test   %eax,%eax
     be9:	0f 84 7c 01 00 00    	je     d6b <dirfile+0x21b>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
     bef:	c7 04 24 14 35 00 00 	movl   $0x3514,(%esp)
     bf6:	e8 6d 21 00 00       	call   2d68 <unlink>
     bfb:	85 c0                	test   %eax,%eax
     bfd:	0f 84 4f 01 00 00    	je     d52 <dirfile+0x202>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
     c03:	c7 44 24 04 14 35 00 	movl   $0x3514,0x4(%esp)
     c0a:	00 
     c0b:	c7 04 24 0c 33 00 00 	movl   $0x330c,(%esp)
     c12:	e8 61 21 00 00       	call   2d78 <link>
     c17:	85 c0                	test   %eax,%eax
     c19:	0f 84 1a 01 00 00    	je     d39 <dirfile+0x1e9>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
     c1f:	c7 04 24 db 34 00 00 	movl   $0x34db,(%esp)
     c26:	e8 3d 21 00 00       	call   2d68 <unlink>
     c2b:	85 c0                	test   %eax,%eax
     c2d:	0f 85 ed 00 00 00    	jne    d20 <dirfile+0x1d0>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
     c33:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     c3a:	00 
     c3b:	c7 04 24 9c 37 00 00 	movl   $0x379c,(%esp)
     c42:	e8 11 21 00 00       	call   2d58 <open>
  if(fd >= 0){
     c47:	85 c0                	test   %eax,%eax
     c49:	0f 89 b8 00 00 00    	jns    d07 <dirfile+0x1b7>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     c4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c56:	00 
     c57:	c7 04 24 9c 37 00 00 	movl   $0x379c,(%esp)
     c5e:	e8 f5 20 00 00       	call   2d58 <open>
  if(write(fd, "x", 1) > 0){
     c63:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c6a:	00 
     c6b:	c7 44 24 04 7f 38 00 	movl   $0x387f,0x4(%esp)
     c72:	00 
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
     c73:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
     c75:	89 04 24             	mov    %eax,(%esp)
     c78:	e8 bb 20 00 00       	call   2d38 <write>
     c7d:	85 c0                	test   %eax,%eax
     c7f:	7f 6d                	jg     cee <dirfile+0x19e>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
     c81:	89 1c 24             	mov    %ebx,(%esp)
     c84:	e8 b7 20 00 00       	call   2d40 <close>

  printf(1, "dir vs file OK\n");
     c89:	c7 44 24 04 a4 35 00 	movl   $0x35a4,0x4(%esp)
     c90:	00 
     c91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c98:	e8 03 22 00 00       	call   2ea0 <printf>
}
     c9d:	83 c4 14             	add    $0x14,%esp
     ca0:	5b                   	pop    %ebx
     ca1:	5d                   	pop    %ebp
     ca2:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
     ca3:	c7 44 24 04 1f 35 00 	movl   $0x351f,0x4(%esp)
     caa:	00 
     cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb2:	e8 e9 21 00 00       	call   2ea0 <printf>
    exit();
     cb7:	e8 5c 20 00 00       	call   2d18 <exit>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
  if(chdir("dirfile") == 0){
    printf(1, "chdir dirfile succeeded!\n");
     cbc:	c7 44 24 04 fa 34 00 	movl   $0x34fa,0x4(%esp)
     cc3:	00 
     cc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ccb:	e8 d0 21 00 00       	call   2ea0 <printf>
    exit();
     cd0:	e8 43 20 00 00       	call   2d18 <exit>

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    printf(1, "create dirfile failed\n");
     cd5:	c7 44 24 04 e3 34 00 	movl   $0x34e3,0x4(%esp)
     cdc:	00 
     cdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ce4:	e8 b7 21 00 00       	call   2ea0 <printf>
    exit();
     ce9:	e8 2a 20 00 00       	call   2d18 <exit>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
  if(write(fd, "x", 1) > 0){
    printf(1, "write . succeeded!\n");
     cee:	c7 44 24 04 90 35 00 	movl   $0x3590,0x4(%esp)
     cf5:	00 
     cf6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cfd:	e8 9e 21 00 00       	call   2ea0 <printf>
    exit();
     d02:	e8 11 20 00 00       	call   2d18 <exit>
    exit();
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
     d07:	c7 44 24 04 20 41 00 	movl   $0x4120,0x4(%esp)
     d0e:	00 
     d0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d16:	e8 85 21 00 00       	call   2ea0 <printf>
    exit();
     d1b:	e8 f8 1f 00 00       	call   2d18 <exit>
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    printf(1, "unlink dirfile failed!\n");
     d20:	c7 44 24 04 78 35 00 	movl   $0x3578,0x4(%esp)
     d27:	00 
     d28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d2f:	e8 6c 21 00 00       	call   2ea0 <printf>
    exit();
     d34:	e8 df 1f 00 00       	call   2d18 <exit>
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
     d39:	c7 44 24 04 00 41 00 	movl   $0x4100,0x4(%esp)
     d40:	00 
     d41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d48:	e8 53 21 00 00       	call   2ea0 <printf>
    exit();
     d4d:	e8 c6 1f 00 00       	call   2d18 <exit>
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
     d52:	c7 44 24 04 5a 35 00 	movl   $0x355a,0x4(%esp)
     d59:	00 
     d5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d61:	e8 3a 21 00 00       	call   2ea0 <printf>
    exit();
     d66:	e8 ad 1f 00 00       	call   2d18 <exit>
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
     d6b:	c7 44 24 04 3d 35 00 	movl   $0x353d,0x4(%esp)
     d72:	00 
     d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d7a:	e8 21 21 00 00       	call   2ea0 <printf>
    exit();
     d7f:	e8 94 1f 00 00       	call   2d18 <exit>
     d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000d90 <bigfile>:
  printf(1, "subdir ok\n");
}

void
bigfile(void)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	57                   	push   %edi
     d94:	56                   	push   %esi
     d95:	53                   	push   %ebx
     d96:	83 ec 1c             	sub    $0x1c,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
     d99:	c7 44 24 04 b4 35 00 	movl   $0x35b4,0x4(%esp)
     da0:	00 
     da1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     da8:	e8 f3 20 00 00       	call   2ea0 <printf>

  unlink("bigfile");
     dad:	c7 04 24 d0 35 00 00 	movl   $0x35d0,(%esp)
     db4:	e8 af 1f 00 00       	call   2d68 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
     db9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     dc0:	00 
     dc1:	c7 04 24 d0 35 00 00 	movl   $0x35d0,(%esp)
     dc8:	e8 8b 1f 00 00       	call   2d58 <open>
  if(fd < 0){
     dcd:	85 c0                	test   %eax,%eax
  int fd, i, total, cc;

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
     dcf:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     dd1:	0f 88 7f 01 00 00    	js     f56 <bigfile+0x1c6>
    printf(1, "cannot create bigfile");
    exit();
     dd7:	31 db                	xor    %ebx,%ebx
     dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
     de0:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     de7:	00 
     de8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     dec:	c7 04 24 60 44 00 00 	movl   $0x4460,(%esp)
     df3:	e8 88 1d 00 00       	call   2b80 <memset>
    if(write(fd, buf, 600) != 600){
     df8:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
     dff:	00 
     e00:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
     e07:	00 
     e08:	89 34 24             	mov    %esi,(%esp)
     e0b:	e8 28 1f 00 00       	call   2d38 <write>
     e10:	3d 58 02 00 00       	cmp    $0x258,%eax
     e15:	0f 85 09 01 00 00    	jne    f24 <bigfile+0x194>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
     e1b:	83 c3 01             	add    $0x1,%ebx
     e1e:	83 fb 14             	cmp    $0x14,%ebx
     e21:	75 bd                	jne    de0 <bigfile+0x50>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
     e23:	89 34 24             	mov    %esi,(%esp)
     e26:	e8 15 1f 00 00       	call   2d40 <close>

  fd = open("bigfile", 0);
     e2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e32:	00 
     e33:	c7 04 24 d0 35 00 00 	movl   $0x35d0,(%esp)
     e3a:	e8 19 1f 00 00       	call   2d58 <open>
  if(fd < 0){
     e3f:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
     e41:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     e43:	0f 88 f4 00 00 00    	js     f3d <bigfile+0x1ad>
    printf(1, "cannot open bigfile\n");
    exit();
     e49:	31 f6                	xor    %esi,%esi
     e4b:	31 db                	xor    %ebx,%ebx
     e4d:	eb 2f                	jmp    e7e <bigfile+0xee>
     e4f:	90                   	nop
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
     e50:	3d 2c 01 00 00       	cmp    $0x12c,%eax
     e55:	0f 85 97 00 00 00    	jne    ef2 <bigfile+0x162>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
     e5b:	0f be 05 60 44 00 00 	movsbl 0x4460,%eax
     e62:	89 da                	mov    %ebx,%edx
     e64:	d1 fa                	sar    %edx
     e66:	39 d0                	cmp    %edx,%eax
     e68:	75 6f                	jne    ed9 <bigfile+0x149>
     e6a:	0f be 15 8b 45 00 00 	movsbl 0x458b,%edx
     e71:	39 d0                	cmp    %edx,%eax
     e73:	75 64                	jne    ed9 <bigfile+0x149>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
     e75:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
     e7b:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
     e7e:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
     e85:	00 
     e86:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
     e8d:	00 
     e8e:	89 3c 24             	mov    %edi,(%esp)
     e91:	e8 9a 1e 00 00       	call   2d30 <read>
    if(cc < 0){
     e96:	83 f8 00             	cmp    $0x0,%eax
     e99:	7c 70                	jl     f0b <bigfile+0x17b>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
     e9b:	75 b3                	jne    e50 <bigfile+0xc0>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
     e9d:	89 3c 24             	mov    %edi,(%esp)
     ea0:	e8 9b 1e 00 00       	call   2d40 <close>
  if(total != 20*600){
     ea5:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
     eab:	0f 85 be 00 00 00    	jne    f6f <bigfile+0x1df>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
     eb1:	c7 04 24 d0 35 00 00 	movl   $0x35d0,(%esp)
     eb8:	e8 ab 1e 00 00       	call   2d68 <unlink>

  printf(1, "bigfile test ok\n");
     ebd:	c7 44 24 04 5f 36 00 	movl   $0x365f,0x4(%esp)
     ec4:	00 
     ec5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ecc:	e8 cf 1f 00 00       	call   2ea0 <printf>
}
     ed1:	83 c4 1c             	add    $0x1c,%esp
     ed4:	5b                   	pop    %ebx
     ed5:	5e                   	pop    %esi
     ed6:	5f                   	pop    %edi
     ed7:	5d                   	pop    %ebp
     ed8:	c3                   	ret    
    if(cc != 300){
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
     ed9:	c7 44 24 04 2c 36 00 	movl   $0x362c,0x4(%esp)
     ee0:	00 
     ee1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ee8:	e8 b3 1f 00 00       	call   2ea0 <printf>
      exit();
     eed:	e8 26 1e 00 00       	call   2d18 <exit>
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
      printf(1, "short read bigfile\n");
     ef2:	c7 44 24 04 18 36 00 	movl   $0x3618,0x4(%esp)
     ef9:	00 
     efa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f01:	e8 9a 1f 00 00       	call   2ea0 <printf>
      exit();
     f06:	e8 0d 1e 00 00       	call   2d18 <exit>
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    if(cc < 0){
      printf(1, "read bigfile failed\n");
     f0b:	c7 44 24 04 03 36 00 	movl   $0x3603,0x4(%esp)
     f12:	00 
     f13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f1a:	e8 81 1f 00 00       	call   2ea0 <printf>
      exit();
     f1f:	e8 f4 1d 00 00       	call   2d18 <exit>
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
     f24:	c7 44 24 04 d8 35 00 	movl   $0x35d8,0x4(%esp)
     f2b:	00 
     f2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f33:	e8 68 1f 00 00       	call   2ea0 <printf>
      exit();
     f38:	e8 db 1d 00 00       	call   2d18 <exit>
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
     f3d:	c7 44 24 04 ee 35 00 	movl   $0x35ee,0x4(%esp)
     f44:	00 
     f45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f4c:	e8 4f 1f 00 00       	call   2ea0 <printf>
    exit();
     f51:	e8 c2 1d 00 00       	call   2d18 <exit>
  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
     f56:	c7 44 24 04 c2 35 00 	movl   $0x35c2,0x4(%esp)
     f5d:	00 
     f5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f65:	e8 36 1f 00 00       	call   2ea0 <printf>
    exit();
     f6a:	e8 a9 1d 00 00       	call   2d18 <exit>
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
     f6f:	c7 44 24 04 45 36 00 	movl   $0x3645,0x4(%esp)
     f76:	00 
     f77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f7e:	e8 1d 1f 00 00       	call   2ea0 <printf>
    exit();
     f83:	e8 90 1d 00 00       	call   2d18 <exit>
     f88:	90                   	nop
     f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000f90 <subdir>:
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	53                   	push   %ebx
     f94:	83 ec 14             	sub    $0x14,%esp
  int fd, cc;

  printf(1, "subdir test\n");
     f97:	c7 44 24 04 70 36 00 	movl   $0x3670,0x4(%esp)
     f9e:	00 
     f9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fa6:	e8 f5 1e 00 00       	call   2ea0 <printf>

  unlink("ff");
     fab:	c7 04 24 f9 36 00 00 	movl   $0x36f9,(%esp)
     fb2:	e8 b1 1d 00 00       	call   2d68 <unlink>
  if(mkdir("dd") != 0){
     fb7:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
     fbe:	e8 bd 1d 00 00       	call   2d80 <mkdir>
     fc3:	85 c0                	test   %eax,%eax
     fc5:	0f 85 07 06 00 00    	jne    15d2 <subdir+0x642>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
     fcb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     fd2:	00 
     fd3:	c7 04 24 cf 36 00 00 	movl   $0x36cf,(%esp)
     fda:	e8 79 1d 00 00       	call   2d58 <open>
  if(fd < 0){
     fdf:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
     fe1:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     fe3:	0f 88 d0 05 00 00    	js     15b9 <subdir+0x629>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
     fe9:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
     ff0:	00 
     ff1:	c7 44 24 04 f9 36 00 	movl   $0x36f9,0x4(%esp)
     ff8:	00 
     ff9:	89 04 24             	mov    %eax,(%esp)
     ffc:	e8 37 1d 00 00       	call   2d38 <write>
  close(fd);
    1001:	89 1c 24             	mov    %ebx,(%esp)
    1004:	e8 37 1d 00 00       	call   2d40 <close>
  
  if(unlink("dd") >= 0){
    1009:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1010:	e8 53 1d 00 00       	call   2d68 <unlink>
    1015:	85 c0                	test   %eax,%eax
    1017:	0f 89 83 05 00 00    	jns    15a0 <subdir+0x610>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    101d:	c7 04 24 aa 36 00 00 	movl   $0x36aa,(%esp)
    1024:	e8 57 1d 00 00       	call   2d80 <mkdir>
    1029:	85 c0                	test   %eax,%eax
    102b:	0f 85 56 05 00 00    	jne    1587 <subdir+0x5f7>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1031:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1038:	00 
    1039:	c7 04 24 cc 36 00 00 	movl   $0x36cc,(%esp)
    1040:	e8 13 1d 00 00       	call   2d58 <open>
  if(fd < 0){
    1045:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1047:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1049:	0f 88 25 04 00 00    	js     1474 <subdir+0x4e4>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    104f:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1056:	00 
    1057:	c7 44 24 04 ed 36 00 	movl   $0x36ed,0x4(%esp)
    105e:	00 
    105f:	89 04 24             	mov    %eax,(%esp)
    1062:	e8 d1 1c 00 00       	call   2d38 <write>
  close(fd);
    1067:	89 1c 24             	mov    %ebx,(%esp)
    106a:	e8 d1 1c 00 00       	call   2d40 <close>

  fd = open("dd/dd/../ff", 0);
    106f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1076:	00 
    1077:	c7 04 24 f0 36 00 00 	movl   $0x36f0,(%esp)
    107e:	e8 d5 1c 00 00       	call   2d58 <open>
  if(fd < 0){
    1083:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    1085:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1087:	0f 88 ce 03 00 00    	js     145b <subdir+0x4cb>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    108d:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1094:	00 
    1095:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    109c:	00 
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 8b 1c 00 00       	call   2d30 <read>
  if(cc != 2 || buf[0] != 'f'){
    10a5:	83 f8 02             	cmp    $0x2,%eax
    10a8:	0f 85 fe 02 00 00    	jne    13ac <subdir+0x41c>
    10ae:	80 3d 60 44 00 00 66 	cmpb   $0x66,0x4460
    10b5:	0f 85 f1 02 00 00    	jne    13ac <subdir+0x41c>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    10bb:	89 1c 24             	mov    %ebx,(%esp)
    10be:	e8 7d 1c 00 00       	call   2d40 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    10c3:	c7 44 24 04 30 37 00 	movl   $0x3730,0x4(%esp)
    10ca:	00 
    10cb:	c7 04 24 cc 36 00 00 	movl   $0x36cc,(%esp)
    10d2:	e8 a1 1c 00 00       	call   2d78 <link>
    10d7:	85 c0                	test   %eax,%eax
    10d9:	0f 85 c7 03 00 00    	jne    14a6 <subdir+0x516>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    10df:	c7 04 24 cc 36 00 00 	movl   $0x36cc,(%esp)
    10e6:	e8 7d 1c 00 00       	call   2d68 <unlink>
    10eb:	85 c0                	test   %eax,%eax
    10ed:	0f 85 eb 02 00 00    	jne    13de <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    10f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10fa:	00 
    10fb:	c7 04 24 cc 36 00 00 	movl   $0x36cc,(%esp)
    1102:	e8 51 1c 00 00       	call   2d58 <open>
    1107:	85 c0                	test   %eax,%eax
    1109:	0f 89 5f 04 00 00    	jns    156e <subdir+0x5de>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    110f:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1116:	e8 6d 1c 00 00       	call   2d88 <chdir>
    111b:	85 c0                	test   %eax,%eax
    111d:	0f 85 32 04 00 00    	jne    1555 <subdir+0x5c5>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1123:	c7 04 24 64 37 00 00 	movl   $0x3764,(%esp)
    112a:	e8 59 1c 00 00       	call   2d88 <chdir>
    112f:	85 c0                	test   %eax,%eax
    1131:	0f 85 8e 02 00 00    	jne    13c5 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1137:	c7 04 24 8a 37 00 00 	movl   $0x378a,(%esp)
    113e:	e8 45 1c 00 00       	call   2d88 <chdir>
    1143:	85 c0                	test   %eax,%eax
    1145:	0f 85 7a 02 00 00    	jne    13c5 <subdir+0x435>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    114b:	c7 04 24 99 37 00 00 	movl   $0x3799,(%esp)
    1152:	e8 31 1c 00 00       	call   2d88 <chdir>
    1157:	85 c0                	test   %eax,%eax
    1159:	0f 85 2e 03 00 00    	jne    148d <subdir+0x4fd>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    115f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1166:	00 
    1167:	c7 04 24 30 37 00 00 	movl   $0x3730,(%esp)
    116e:	e8 e5 1b 00 00       	call   2d58 <open>
  if(fd < 0){
    1173:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1175:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1177:	0f 88 81 05 00 00    	js     16fe <subdir+0x76e>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    117d:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1184:	00 
    1185:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    118c:	00 
    118d:	89 04 24             	mov    %eax,(%esp)
    1190:	e8 9b 1b 00 00       	call   2d30 <read>
    1195:	83 f8 02             	cmp    $0x2,%eax
    1198:	0f 85 47 05 00 00    	jne    16e5 <subdir+0x755>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    119e:	89 1c 24             	mov    %ebx,(%esp)
    11a1:	e8 9a 1b 00 00       	call   2d40 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    11a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11ad:	00 
    11ae:	c7 04 24 cc 36 00 00 	movl   $0x36cc,(%esp)
    11b5:	e8 9e 1b 00 00       	call   2d58 <open>
    11ba:	85 c0                	test   %eax,%eax
    11bc:	0f 89 4e 02 00 00    	jns    1410 <subdir+0x480>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    11c2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    11c9:	00 
    11ca:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    11d1:	e8 82 1b 00 00       	call   2d58 <open>
    11d6:	85 c0                	test   %eax,%eax
    11d8:	0f 89 19 02 00 00    	jns    13f7 <subdir+0x467>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    11de:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    11e5:	00 
    11e6:	c7 04 24 09 38 00 00 	movl   $0x3809,(%esp)
    11ed:	e8 66 1b 00 00       	call   2d58 <open>
    11f2:	85 c0                	test   %eax,%eax
    11f4:	0f 89 42 03 00 00    	jns    153c <subdir+0x5ac>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    11fa:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1201:	00 
    1202:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1209:	e8 4a 1b 00 00       	call   2d58 <open>
    120e:	85 c0                	test   %eax,%eax
    1210:	0f 89 0d 03 00 00    	jns    1523 <subdir+0x593>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1216:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    121d:	00 
    121e:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1225:	e8 2e 1b 00 00       	call   2d58 <open>
    122a:	85 c0                	test   %eax,%eax
    122c:	0f 89 d8 02 00 00    	jns    150a <subdir+0x57a>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1232:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1239:	00 
    123a:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1241:	e8 12 1b 00 00       	call   2d58 <open>
    1246:	85 c0                	test   %eax,%eax
    1248:	0f 89 a3 02 00 00    	jns    14f1 <subdir+0x561>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    124e:	c7 44 24 04 78 38 00 	movl   $0x3878,0x4(%esp)
    1255:	00 
    1256:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    125d:	e8 16 1b 00 00       	call   2d78 <link>
    1262:	85 c0                	test   %eax,%eax
    1264:	0f 84 6e 02 00 00    	je     14d8 <subdir+0x548>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    126a:	c7 44 24 04 78 38 00 	movl   $0x3878,0x4(%esp)
    1271:	00 
    1272:	c7 04 24 09 38 00 00 	movl   $0x3809,(%esp)
    1279:	e8 fa 1a 00 00       	call   2d78 <link>
    127e:	85 c0                	test   %eax,%eax
    1280:	0f 84 39 02 00 00    	je     14bf <subdir+0x52f>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1286:	c7 44 24 04 30 37 00 	movl   $0x3730,0x4(%esp)
    128d:	00 
    128e:	c7 04 24 cf 36 00 00 	movl   $0x36cf,(%esp)
    1295:	e8 de 1a 00 00       	call   2d78 <link>
    129a:	85 c0                	test   %eax,%eax
    129c:	0f 84 a0 01 00 00    	je     1442 <subdir+0x4b2>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    12a2:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    12a9:	e8 d2 1a 00 00       	call   2d80 <mkdir>
    12ae:	85 c0                	test   %eax,%eax
    12b0:	0f 84 73 01 00 00    	je     1429 <subdir+0x499>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    12b6:	c7 04 24 09 38 00 00 	movl   $0x3809,(%esp)
    12bd:	e8 be 1a 00 00       	call   2d80 <mkdir>
    12c2:	85 c0                	test   %eax,%eax
    12c4:	0f 84 02 04 00 00    	je     16cc <subdir+0x73c>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    12ca:	c7 04 24 30 37 00 00 	movl   $0x3730,(%esp)
    12d1:	e8 aa 1a 00 00       	call   2d80 <mkdir>
    12d6:	85 c0                	test   %eax,%eax
    12d8:	0f 84 d5 03 00 00    	je     16b3 <subdir+0x723>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    12de:	c7 04 24 09 38 00 00 	movl   $0x3809,(%esp)
    12e5:	e8 7e 1a 00 00       	call   2d68 <unlink>
    12ea:	85 c0                	test   %eax,%eax
    12ec:	0f 84 a8 03 00 00    	je     169a <subdir+0x70a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    12f2:	c7 04 24 e4 37 00 00 	movl   $0x37e4,(%esp)
    12f9:	e8 6a 1a 00 00       	call   2d68 <unlink>
    12fe:	85 c0                	test   %eax,%eax
    1300:	0f 84 7b 03 00 00    	je     1681 <subdir+0x6f1>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1306:	c7 04 24 cf 36 00 00 	movl   $0x36cf,(%esp)
    130d:	e8 76 1a 00 00       	call   2d88 <chdir>
    1312:	85 c0                	test   %eax,%eax
    1314:	0f 84 4e 03 00 00    	je     1668 <subdir+0x6d8>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    131a:	c7 04 24 7b 38 00 00 	movl   $0x387b,(%esp)
    1321:	e8 62 1a 00 00       	call   2d88 <chdir>
    1326:	85 c0                	test   %eax,%eax
    1328:	0f 84 21 03 00 00    	je     164f <subdir+0x6bf>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    132e:	c7 04 24 30 37 00 00 	movl   $0x3730,(%esp)
    1335:	e8 2e 1a 00 00       	call   2d68 <unlink>
    133a:	85 c0                	test   %eax,%eax
    133c:	0f 85 9c 00 00 00    	jne    13de <subdir+0x44e>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1342:	c7 04 24 cf 36 00 00 	movl   $0x36cf,(%esp)
    1349:	e8 1a 1a 00 00       	call   2d68 <unlink>
    134e:	85 c0                	test   %eax,%eax
    1350:	0f 85 e0 02 00 00    	jne    1636 <subdir+0x6a6>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1356:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    135d:	e8 06 1a 00 00       	call   2d68 <unlink>
    1362:	85 c0                	test   %eax,%eax
    1364:	0f 84 b3 02 00 00    	je     161d <subdir+0x68d>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    136a:	c7 04 24 ab 36 00 00 	movl   $0x36ab,(%esp)
    1371:	e8 f2 19 00 00       	call   2d68 <unlink>
    1376:	85 c0                	test   %eax,%eax
    1378:	0f 88 86 02 00 00    	js     1604 <subdir+0x674>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    137e:	c7 04 24 96 37 00 00 	movl   $0x3796,(%esp)
    1385:	e8 de 19 00 00       	call   2d68 <unlink>
    138a:	85 c0                	test   %eax,%eax
    138c:	0f 88 59 02 00 00    	js     15eb <subdir+0x65b>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1392:	c7 44 24 04 78 39 00 	movl   $0x3978,0x4(%esp)
    1399:	00 
    139a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a1:	e8 fa 1a 00 00       	call   2ea0 <printf>
}
    13a6:	83 c4 14             	add    $0x14,%esp
    13a9:	5b                   	pop    %ebx
    13aa:	5d                   	pop    %ebp
    13ab:	c3                   	ret    
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
  if(cc != 2 || buf[0] != 'f'){
    printf(1, "dd/dd/../ff wrong content\n");
    13ac:	c7 44 24 04 15 37 00 	movl   $0x3715,0x4(%esp)
    13b3:	00 
    13b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13bb:	e8 e0 1a 00 00       	call   2ea0 <printf>
    exit();
    13c0:	e8 53 19 00 00       	call   2d18 <exit>
  if(chdir("dd/../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    13c5:	c7 44 24 04 70 37 00 	movl   $0x3770,0x4(%esp)
    13cc:	00 
    13cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13d4:	e8 c7 1a 00 00       	call   2ea0 <printf>
    exit();
    13d9:	e8 3a 19 00 00       	call   2d18 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    13de:	c7 44 24 04 3b 37 00 	movl   $0x373b,0x4(%esp)
    13e5:	00 
    13e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13ed:	e8 ae 1a 00 00       	call   2ea0 <printf>
    exit();
    13f2:	e8 21 19 00 00       	call   2d18 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    13f7:	c7 44 24 04 ed 37 00 	movl   $0x37ed,0x4(%esp)
    13fe:	00 
    13ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1406:	e8 95 1a 00 00       	call   2ea0 <printf>
    exit();
    140b:	e8 08 19 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    1410:	c7 44 24 04 b0 41 00 	movl   $0x41b0,0x4(%esp)
    1417:	00 
    1418:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    141f:	e8 7c 1a 00 00       	call   2ea0 <printf>
    exit();
    1424:	e8 ef 18 00 00       	call   2d18 <exit>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    1429:	c7 44 24 04 81 38 00 	movl   $0x3881,0x4(%esp)
    1430:	00 
    1431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1438:	e8 63 1a 00 00       	call   2ea0 <printf>
    exit();
    143d:	e8 d6 18 00 00       	call   2d18 <exit>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1442:	c7 44 24 04 20 42 00 	movl   $0x4220,0x4(%esp)
    1449:	00 
    144a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1451:	e8 4a 1a 00 00       	call   2ea0 <printf>
    exit();
    1456:	e8 bd 18 00 00       	call   2d18 <exit>
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    145b:	c7 44 24 04 fc 36 00 	movl   $0x36fc,0x4(%esp)
    1462:	00 
    1463:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    146a:	e8 31 1a 00 00       	call   2ea0 <printf>
    exit();
    146f:	e8 a4 18 00 00       	call   2d18 <exit>
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    1474:	c7 44 24 04 d5 36 00 	movl   $0x36d5,0x4(%esp)
    147b:	00 
    147c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1483:	e8 18 1a 00 00       	call   2ea0 <printf>
    exit();
    1488:	e8 8b 18 00 00       	call   2d18 <exit>
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    148d:	c7 44 24 04 9e 37 00 	movl   $0x379e,0x4(%esp)
    1494:	00 
    1495:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    149c:	e8 ff 19 00 00       	call   2ea0 <printf>
    exit();
    14a1:	e8 72 18 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    14a6:	c7 44 24 04 68 41 00 	movl   $0x4168,0x4(%esp)
    14ad:	00 
    14ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14b5:	e8 e6 19 00 00       	call   2ea0 <printf>
    exit();
    14ba:	e8 59 18 00 00       	call   2d18 <exit>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    14bf:	c7 44 24 04 fc 41 00 	movl   $0x41fc,0x4(%esp)
    14c6:	00 
    14c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ce:	e8 cd 19 00 00       	call   2ea0 <printf>
    exit();
    14d3:	e8 40 18 00 00       	call   2d18 <exit>
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    14d8:	c7 44 24 04 d8 41 00 	movl   $0x41d8,0x4(%esp)
    14df:	00 
    14e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14e7:	e8 b4 19 00 00       	call   2ea0 <printf>
    exit();
    14ec:	e8 27 18 00 00       	call   2d18 <exit>
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    14f1:	c7 44 24 04 5d 38 00 	movl   $0x385d,0x4(%esp)
    14f8:	00 
    14f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1500:	e8 9b 19 00 00       	call   2ea0 <printf>
    exit();
    1505:	e8 0e 18 00 00       	call   2d18 <exit>
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    150a:	c7 44 24 04 44 38 00 	movl   $0x3844,0x4(%esp)
    1511:	00 
    1512:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1519:	e8 82 19 00 00       	call   2ea0 <printf>
    exit();
    151e:	e8 f5 17 00 00       	call   2d18 <exit>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    1523:	c7 44 24 04 2e 38 00 	movl   $0x382e,0x4(%esp)
    152a:	00 
    152b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1532:	e8 69 19 00 00       	call   2ea0 <printf>
    exit();
    1537:	e8 dc 17 00 00       	call   2d18 <exit>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    153c:	c7 44 24 04 12 38 00 	movl   $0x3812,0x4(%esp)
    1543:	00 
    1544:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    154b:	e8 50 19 00 00       	call   2ea0 <printf>
    exit();
    1550:	e8 c3 17 00 00       	call   2d18 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    printf(1, "chdir dd failed\n");
    1555:	c7 44 24 04 53 37 00 	movl   $0x3753,0x4(%esp)
    155c:	00 
    155d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1564:	e8 37 19 00 00       	call   2ea0 <printf>
    exit();
    1569:	e8 aa 17 00 00       	call   2d18 <exit>
  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    156e:	c7 44 24 04 8c 41 00 	movl   $0x418c,0x4(%esp)
    1575:	00 
    1576:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    157d:	e8 1e 19 00 00       	call   2ea0 <printf>
    exit();
    1582:	e8 91 17 00 00       	call   2d18 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    1587:	c7 44 24 04 b1 36 00 	movl   $0x36b1,0x4(%esp)
    158e:	00 
    158f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1596:	e8 05 19 00 00       	call   2ea0 <printf>
    exit();
    159b:	e8 78 17 00 00       	call   2d18 <exit>
  }
  write(fd, "ff", 2);
  close(fd);
  
  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    15a0:	c7 44 24 04 40 41 00 	movl   $0x4140,0x4(%esp)
    15a7:	00 
    15a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15af:	e8 ec 18 00 00       	call   2ea0 <printf>
    exit();
    15b4:	e8 5f 17 00 00       	call   2d18 <exit>
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create dd/ff failed\n");
    15b9:	c7 44 24 04 95 36 00 	movl   $0x3695,0x4(%esp)
    15c0:	00 
    15c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15c8:	e8 d3 18 00 00       	call   2ea0 <printf>
    exit();
    15cd:	e8 46 17 00 00       	call   2d18 <exit>

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    15d2:	c7 44 24 04 7d 36 00 	movl   $0x367d,0x4(%esp)
    15d9:	00 
    15da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e1:	e8 ba 18 00 00       	call   2ea0 <printf>
    exit();
    15e6:	e8 2d 17 00 00       	call   2d18 <exit>
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    15eb:	c7 44 24 04 66 39 00 	movl   $0x3966,0x4(%esp)
    15f2:	00 
    15f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15fa:	e8 a1 18 00 00       	call   2ea0 <printf>
    exit();
    15ff:	e8 14 17 00 00       	call   2d18 <exit>
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    1604:	c7 44 24 04 51 39 00 	movl   $0x3951,0x4(%esp)
    160b:	00 
    160c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1613:	e8 88 18 00 00       	call   2ea0 <printf>
    exit();
    1618:	e8 fb 16 00 00       	call   2d18 <exit>
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    161d:	c7 44 24 04 44 42 00 	movl   $0x4244,0x4(%esp)
    1624:	00 
    1625:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    162c:	e8 6f 18 00 00       	call   2ea0 <printf>
    exit();
    1631:	e8 e2 16 00 00       	call   2d18 <exit>
  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    printf(1, "unlink dd/ff failed\n");
    1636:	c7 44 24 04 3c 39 00 	movl   $0x393c,0x4(%esp)
    163d:	00 
    163e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1645:	e8 56 18 00 00       	call   2ea0 <printf>
    exit();
    164a:	e8 c9 16 00 00       	call   2d18 <exit>
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    printf(1, "chdir dd/xx succeeded!\n");
    164f:	c7 44 24 04 24 39 00 	movl   $0x3924,0x4(%esp)
    1656:	00 
    1657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    165e:	e8 3d 18 00 00       	call   2ea0 <printf>
    exit();
    1663:	e8 b0 16 00 00       	call   2d18 <exit>
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    1668:	c7 44 24 04 0c 39 00 	movl   $0x390c,0x4(%esp)
    166f:	00 
    1670:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1677:	e8 24 18 00 00       	call   2ea0 <printf>
    exit();
    167c:	e8 97 16 00 00       	call   2d18 <exit>
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    1681:	c7 44 24 04 f0 38 00 	movl   $0x38f0,0x4(%esp)
    1688:	00 
    1689:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1690:	e8 0b 18 00 00       	call   2ea0 <printf>
    exit();
    1695:	e8 7e 16 00 00       	call   2d18 <exit>
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    169a:	c7 44 24 04 d4 38 00 	movl   $0x38d4,0x4(%esp)
    16a1:	00 
    16a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16a9:	e8 f2 17 00 00       	call   2ea0 <printf>
    exit();
    16ae:	e8 65 16 00 00       	call   2d18 <exit>
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    16b3:	c7 44 24 04 b7 38 00 	movl   $0x38b7,0x4(%esp)
    16ba:	00 
    16bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c2:	e8 d9 17 00 00       	call   2ea0 <printf>
    exit();
    16c7:	e8 4c 16 00 00       	call   2d18 <exit>
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    16cc:	c7 44 24 04 9c 38 00 	movl   $0x389c,0x4(%esp)
    16d3:	00 
    16d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16db:	e8 c0 17 00 00       	call   2ea0 <printf>
    exit();
    16e0:	e8 33 16 00 00       	call   2d18 <exit>
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    printf(1, "read dd/dd/ffff wrong len\n");
    16e5:	c7 44 24 04 c9 37 00 	movl   $0x37c9,0x4(%esp)
    16ec:	00 
    16ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16f4:	e8 a7 17 00 00       	call   2ea0 <printf>
    exit();
    16f9:	e8 1a 16 00 00       	call   2d18 <exit>
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    16fe:	c7 44 24 04 b1 37 00 	movl   $0x37b1,0x4(%esp)
    1705:	00 
    1706:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    170d:	e8 8e 17 00 00       	call   2ea0 <printf>
    exit();
    1712:	e8 01 16 00 00       	call   2d18 <exit>
    1717:	89 f6                	mov    %esi,%esi
    1719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001720 <concreate>:
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    1720:	55                   	push   %ebp
    1721:	89 e5                	mov    %esp,%ebp
    1723:	57                   	push   %edi
    1724:	56                   	push   %esi
    1725:	53                   	push   %ebx
    char name[14];
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
    1726:	31 db                	xor    %ebx,%ebx
}

// test concurrent create and unlink of the same file
void
concreate(void)
{
    1728:	83 ec 6c             	sub    $0x6c,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    172b:	c7 44 24 04 83 39 00 	movl   $0x3983,0x4(%esp)
    1732:	00 
    1733:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1736:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    173d:	e8 5e 17 00 00       	call   2ea0 <printf>
  file[0] = 'C';
    1742:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1746:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    174a:	eb 4f                	jmp    179b <concreate+0x7b>
    174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
    1750:	b8 56 55 55 55       	mov    $0x55555556,%eax
    1755:	f7 eb                	imul   %ebx
    1757:	89 d8                	mov    %ebx,%eax
    1759:	c1 f8 1f             	sar    $0x1f,%eax
    175c:	29 c2                	sub    %eax,%edx
    175e:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1761:	89 da                	mov    %ebx,%edx
    1763:	29 c2                	sub    %eax,%edx
    1765:	83 fa 01             	cmp    $0x1,%edx
    1768:	74 7e                	je     17e8 <concreate+0xc8>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    176a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1771:	00 
    1772:	89 3c 24             	mov    %edi,(%esp)
    1775:	e8 de 15 00 00       	call   2d58 <open>
      if(fd < 0){
    177a:	85 c0                	test   %eax,%eax
    177c:	0f 88 db 01 00 00    	js     195d <concreate+0x23d>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1782:	89 04 24             	mov    %eax,(%esp)
    1785:	e8 b6 15 00 00       	call   2d40 <close>
    }
    if(pid == 0)
    178a:	85 f6                	test   %esi,%esi
    178c:	74 52                	je     17e0 <concreate+0xc0>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    178e:	83 c3 01             	add    $0x1,%ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1791:	e8 8a 15 00 00       	call   2d20 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1796:	83 fb 28             	cmp    $0x28,%ebx
    1799:	74 6d                	je     1808 <concreate+0xe8>
    file[1] = '0' + i;
    179b:	8d 43 30             	lea    0x30(%ebx),%eax
    179e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    17a1:	89 3c 24             	mov    %edi,(%esp)
    17a4:	e8 bf 15 00 00       	call   2d68 <unlink>
    pid = fork();
    17a9:	e8 62 15 00 00       	call   2d10 <fork>
    if(pid && (i % 3) == 1){
    17ae:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    17b0:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    17b2:	75 9c                	jne    1750 <concreate+0x30>
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    17b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
    17b9:	f7 eb                	imul   %ebx
    17bb:	89 d8                	mov    %ebx,%eax
    17bd:	c1 f8 1f             	sar    $0x1f,%eax
    17c0:	d1 fa                	sar    %edx
    17c2:	29 c2                	sub    %eax,%edx
    17c4:	8d 04 92             	lea    (%edx,%edx,4),%eax
    17c7:	89 da                	mov    %ebx,%edx
    17c9:	29 c2                	sub    %eax,%edx
    17cb:	83 fa 01             	cmp    $0x1,%edx
    17ce:	75 9a                	jne    176a <concreate+0x4a>
      link("C0", file);
    17d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
    17d4:	c7 04 24 93 39 00 00 	movl   $0x3993,(%esp)
    17db:	e8 98 15 00 00       	call   2d78 <link>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
    17e0:	e8 33 15 00 00       	call   2d18 <exit>
    17e5:	8d 76 00             	lea    0x0(%esi),%esi
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    17e8:	83 c3 01             	add    $0x1,%ebx
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    17eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
    17ef:	c7 04 24 93 39 00 00 	movl   $0x3993,(%esp)
    17f6:	e8 7d 15 00 00       	call   2d78 <link>
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    17fb:	e8 20 15 00 00       	call   2d20 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1800:	83 fb 28             	cmp    $0x28,%ebx
    1803:	75 96                	jne    179b <concreate+0x7b>
    1805:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1808:	8d 45 ac             	lea    -0x54(%ebp),%eax
    180b:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1812:	00 
    1813:	8d 75 d4             	lea    -0x2c(%ebp),%esi
    1816:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    181d:	00 
    181e:	89 04 24             	mov    %eax,(%esp)
    1821:	e8 5a 13 00 00       	call   2b80 <memset>
  fd = open(".", 0);
    1826:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    182d:	00 
    182e:	c7 04 24 9c 37 00 00 	movl   $0x379c,(%esp)
    1835:	e8 1e 15 00 00       	call   2d58 <open>
    183a:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    1841:	89 c3                	mov    %eax,%ebx
    1843:	90                   	nop
    1844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1848:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    184f:	00 
    1850:	89 74 24 04          	mov    %esi,0x4(%esp)
    1854:	89 1c 24             	mov    %ebx,(%esp)
    1857:	e8 d4 14 00 00       	call   2d30 <read>
    185c:	85 c0                	test   %eax,%eax
    185e:	7e 40                	jle    18a0 <concreate+0x180>
    if(de.inum == 0)
    1860:	66 83 7d d4 00       	cmpw   $0x0,-0x2c(%ebp)
    1865:	74 e1                	je     1848 <concreate+0x128>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1867:	80 7d d6 43          	cmpb   $0x43,-0x2a(%ebp)
    186b:	90                   	nop
    186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1870:	75 d6                	jne    1848 <concreate+0x128>
    1872:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
    1876:	75 d0                	jne    1848 <concreate+0x128>
      i = de.name[1] - '0';
    1878:	0f be 45 d7          	movsbl -0x29(%ebp),%eax
    187c:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    187f:	83 f8 27             	cmp    $0x27,%eax
    1882:	0f 87 f2 00 00 00    	ja     197a <concreate+0x25a>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1888:	80 7c 05 ac 00       	cmpb   $0x0,-0x54(%ebp,%eax,1)
    188d:	0f 85 20 01 00 00    	jne    19b3 <concreate+0x293>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    1893:	c6 44 05 ac 01       	movb   $0x1,-0x54(%ebp,%eax,1)
      n++;
    1898:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    189c:	eb aa                	jmp    1848 <concreate+0x128>
    189e:	66 90                	xchg   %ax,%ax
    }
  }
  close(fd);
    18a0:	89 1c 24             	mov    %ebx,(%esp)
    18a3:	e8 98 14 00 00       	call   2d40 <close>

  if(n != 40){
    18a8:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    18ac:	0f 85 e8 00 00 00    	jne    199a <concreate+0x27a>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
    18b2:	31 db                	xor    %ebx,%ebx
    18b4:	eb 24                	jmp    18da <concreate+0x1ba>
    18b6:	66 90                	xchg   %ax,%ax
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    18b8:	85 f6                	test   %esi,%esi
    18ba:	74 4f                	je     190b <concreate+0x1eb>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
      close(fd);
    } else {
      unlink(file);
    18bc:	89 3c 24             	mov    %edi,(%esp)
    18bf:	90                   	nop
    18c0:	e8 a3 14 00 00       	call   2d68 <unlink>
    }
    if(pid == 0)
    18c5:	85 f6                	test   %esi,%esi
    18c7:	0f 84 13 ff ff ff    	je     17e0 <concreate+0xc0>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    18cd:	83 c3 01             	add    $0x1,%ebx
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    18d0:	e8 4b 14 00 00       	call   2d20 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    18d5:	83 fb 28             	cmp    $0x28,%ebx
    18d8:	74 4e                	je     1928 <concreate+0x208>
    file[1] = '0' + i;
    18da:	8d 43 30             	lea    0x30(%ebx),%eax
    18dd:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    18e0:	e8 2b 14 00 00       	call   2d10 <fork>
    if(pid < 0){
    18e5:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    18e7:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    18e9:	78 59                	js     1944 <concreate+0x224>
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    18eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
    18f0:	f7 eb                	imul   %ebx
    18f2:	89 d8                	mov    %ebx,%eax
    18f4:	c1 f8 1f             	sar    $0x1f,%eax
    18f7:	29 c2                	sub    %eax,%edx
    18f9:	89 d8                	mov    %ebx,%eax
    18fb:	8d 14 52             	lea    (%edx,%edx,2),%edx
    18fe:	29 d0                	sub    %edx,%eax
    1900:	74 b6                	je     18b8 <concreate+0x198>
    1902:	83 f8 01             	cmp    $0x1,%eax
    1905:	75 b5                	jne    18bc <concreate+0x19c>
    1907:	85 f6                	test   %esi,%esi
    1909:	74 b1                	je     18bc <concreate+0x19c>
       ((i % 3) == 1 && pid != 0)){
      fd = open(file, 0);
    190b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1912:	00 
    1913:	89 3c 24             	mov    %edi,(%esp)
    1916:	e8 3d 14 00 00       	call   2d58 <open>
      close(fd);
    191b:	89 04 24             	mov    %eax,(%esp)
    191e:	e8 1d 14 00 00       	call   2d40 <close>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1923:	eb a0                	jmp    18c5 <concreate+0x1a5>
    1925:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1928:	c7 44 24 04 e8 39 00 	movl   $0x39e8,0x4(%esp)
    192f:	00 
    1930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1937:	e8 64 15 00 00       	call   2ea0 <printf>
}
    193c:	83 c4 6c             	add    $0x6c,%esp
    193f:	5b                   	pop    %ebx
    1940:	5e                   	pop    %esi
    1941:	5f                   	pop    %edi
    1942:	5d                   	pop    %ebp
    1943:	c3                   	ret    

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    1944:	c7 44 24 04 4c 32 00 	movl   $0x324c,0x4(%esp)
    194b:	00 
    194c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1953:	e8 48 15 00 00       	call   2ea0 <printf>
      exit();
    1958:	e8 bb 13 00 00       	call   2d18 <exit>
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    195d:	89 7c 24 08          	mov    %edi,0x8(%esp)
    1961:	c7 44 24 04 96 39 00 	movl   $0x3996,0x4(%esp)
    1968:	00 
    1969:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1970:	e8 2b 15 00 00       	call   2ea0 <printf>
        exit();
    1975:	e8 9e 13 00 00       	call   2d18 <exit>
    if(de.inum == 0)
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
    197a:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    197d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1981:	c7 44 24 04 b2 39 00 	movl   $0x39b2,0x4(%esp)
    1988:	00 
    1989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1990:	e8 0b 15 00 00       	call   2ea0 <printf>
    1995:	e9 46 fe ff ff       	jmp    17e0 <concreate+0xc0>
    }
  }
  close(fd);

  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    199a:	c7 44 24 04 64 42 00 	movl   $0x4264,0x4(%esp)
    19a1:	00 
    19a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19a9:	e8 f2 14 00 00       	call   2ea0 <printf>
    exit();
    19ae:	e8 65 13 00 00       	call   2d18 <exit>
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    19b3:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    19b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    19ba:	c7 44 24 04 cb 39 00 	movl   $0x39cb,0x4(%esp)
    19c1:	00 
    19c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19c9:	e8 d2 14 00 00       	call   2ea0 <printf>
        exit();
    19ce:	e8 45 13 00 00       	call   2d18 <exit>
    19d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    19d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000019e0 <linktest>:
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    19e0:	55                   	push   %ebp
    19e1:	89 e5                	mov    %esp,%ebp
    19e3:	53                   	push   %ebx
    19e4:	83 ec 14             	sub    $0x14,%esp
  int fd;

  printf(1, "linktest\n");
    19e7:	c7 44 24 04 f6 39 00 	movl   $0x39f6,0x4(%esp)
    19ee:	00 
    19ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19f6:	e8 a5 14 00 00       	call   2ea0 <printf>

  unlink("lf1");
    19fb:	c7 04 24 00 3a 00 00 	movl   $0x3a00,(%esp)
    1a02:	e8 61 13 00 00       	call   2d68 <unlink>
  unlink("lf2");
    1a07:	c7 04 24 04 3a 00 00 	movl   $0x3a04,(%esp)
    1a0e:	e8 55 13 00 00       	call   2d68 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1a13:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1a1a:	00 
    1a1b:	c7 04 24 00 3a 00 00 	movl   $0x3a00,(%esp)
    1a22:	e8 31 13 00 00       	call   2d58 <open>
  if(fd < 0){
    1a27:	85 c0                	test   %eax,%eax
  printf(1, "linktest\n");

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
    1a29:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1a2b:	0f 88 26 01 00 00    	js     1b57 <linktest+0x177>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    1a31:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1a38:	00 
    1a39:	c7 44 24 04 1b 3a 00 	movl   $0x3a1b,0x4(%esp)
    1a40:	00 
    1a41:	89 04 24             	mov    %eax,(%esp)
    1a44:	e8 ef 12 00 00       	call   2d38 <write>
    1a49:	83 f8 05             	cmp    $0x5,%eax
    1a4c:	0f 85 cd 01 00 00    	jne    1c1f <linktest+0x23f>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1a52:	89 1c 24             	mov    %ebx,(%esp)
    1a55:	e8 e6 12 00 00       	call   2d40 <close>

  if(link("lf1", "lf2") < 0){
    1a5a:	c7 44 24 04 04 3a 00 	movl   $0x3a04,0x4(%esp)
    1a61:	00 
    1a62:	c7 04 24 00 3a 00 00 	movl   $0x3a00,(%esp)
    1a69:	e8 0a 13 00 00       	call   2d78 <link>
    1a6e:	85 c0                	test   %eax,%eax
    1a70:	0f 88 90 01 00 00    	js     1c06 <linktest+0x226>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    1a76:	c7 04 24 00 3a 00 00 	movl   $0x3a00,(%esp)
    1a7d:	e8 e6 12 00 00       	call   2d68 <unlink>

  if(open("lf1", 0) >= 0){
    1a82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a89:	00 
    1a8a:	c7 04 24 00 3a 00 00 	movl   $0x3a00,(%esp)
    1a91:	e8 c2 12 00 00       	call   2d58 <open>
    1a96:	85 c0                	test   %eax,%eax
    1a98:	0f 89 4f 01 00 00    	jns    1bed <linktest+0x20d>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1a9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1aa5:	00 
    1aa6:	c7 04 24 04 3a 00 00 	movl   $0x3a04,(%esp)
    1aad:	e8 a6 12 00 00       	call   2d58 <open>
  if(fd < 0){
    1ab2:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1ab4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1ab6:	0f 88 18 01 00 00    	js     1bd4 <linktest+0x1f4>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1abc:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1ac3:	00 
    1ac4:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    1acb:	00 
    1acc:	89 04 24             	mov    %eax,(%esp)
    1acf:	e8 5c 12 00 00       	call   2d30 <read>
    1ad4:	83 f8 05             	cmp    $0x5,%eax
    1ad7:	0f 85 de 00 00 00    	jne    1bbb <linktest+0x1db>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    1add:	89 1c 24             	mov    %ebx,(%esp)
    1ae0:	e8 5b 12 00 00       	call   2d40 <close>

  if(link("lf2", "lf2") >= 0){
    1ae5:	c7 44 24 04 04 3a 00 	movl   $0x3a04,0x4(%esp)
    1aec:	00 
    1aed:	c7 04 24 04 3a 00 00 	movl   $0x3a04,(%esp)
    1af4:	e8 7f 12 00 00       	call   2d78 <link>
    1af9:	85 c0                	test   %eax,%eax
    1afb:	0f 89 a1 00 00 00    	jns    1ba2 <linktest+0x1c2>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1b01:	c7 04 24 04 3a 00 00 	movl   $0x3a04,(%esp)
    1b08:	e8 5b 12 00 00       	call   2d68 <unlink>
  if(link("lf2", "lf1") >= 0){
    1b0d:	c7 44 24 04 00 3a 00 	movl   $0x3a00,0x4(%esp)
    1b14:	00 
    1b15:	c7 04 24 04 3a 00 00 	movl   $0x3a04,(%esp)
    1b1c:	e8 57 12 00 00       	call   2d78 <link>
    1b21:	85 c0                	test   %eax,%eax
    1b23:	79 64                	jns    1b89 <linktest+0x1a9>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1b25:	c7 44 24 04 00 3a 00 	movl   $0x3a00,0x4(%esp)
    1b2c:	00 
    1b2d:	c7 04 24 9c 37 00 00 	movl   $0x379c,(%esp)
    1b34:	e8 3f 12 00 00       	call   2d78 <link>
    1b39:	85 c0                	test   %eax,%eax
    1b3b:	79 33                	jns    1b70 <linktest+0x190>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    1b3d:	c7 44 24 04 a4 3a 00 	movl   $0x3aa4,0x4(%esp)
    1b44:	00 
    1b45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b4c:	e8 4f 13 00 00       	call   2ea0 <printf>
}
    1b51:	83 c4 14             	add    $0x14,%esp
    1b54:	5b                   	pop    %ebx
    1b55:	5d                   	pop    %ebp
    1b56:	c3                   	ret    
  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    1b57:	c7 44 24 04 08 3a 00 	movl   $0x3a08,0x4(%esp)
    1b5e:	00 
    1b5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b66:	e8 35 13 00 00       	call   2ea0 <printf>
    exit();
    1b6b:	e8 a8 11 00 00       	call   2d18 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    1b70:	c7 44 24 04 88 3a 00 	movl   $0x3a88,0x4(%esp)
    1b77:	00 
    1b78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b7f:	e8 1c 13 00 00       	call   2ea0 <printf>
    exit();
    1b84:	e8 8f 11 00 00       	call   2d18 <exit>
    exit();
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    1b89:	c7 44 24 04 c0 42 00 	movl   $0x42c0,0x4(%esp)
    1b90:	00 
    1b91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b98:	e8 03 13 00 00       	call   2ea0 <printf>
    exit();
    1b9d:	e8 76 11 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1ba2:	c7 44 24 04 6a 3a 00 	movl   $0x3a6a,0x4(%esp)
    1ba9:	00 
    1baa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bb1:	e8 ea 12 00 00       	call   2ea0 <printf>
    exit();
    1bb6:	e8 5d 11 00 00       	call   2d18 <exit>
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "read lf2 failed\n");
    1bbb:	c7 44 24 04 59 3a 00 	movl   $0x3a59,0x4(%esp)
    1bc2:	00 
    1bc3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bca:	e8 d1 12 00 00       	call   2ea0 <printf>
    exit();
    1bcf:	e8 44 11 00 00       	call   2d18 <exit>
    exit();
  }

  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    1bd4:	c7 44 24 04 48 3a 00 	movl   $0x3a48,0x4(%esp)
    1bdb:	00 
    1bdc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1be3:	e8 b8 12 00 00       	call   2ea0 <printf>
    exit();
    1be8:	e8 2b 11 00 00       	call   2d18 <exit>
    exit();
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    1bed:	c7 44 24 04 98 42 00 	movl   $0x4298,0x4(%esp)
    1bf4:	00 
    1bf5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bfc:	e8 9f 12 00 00       	call   2ea0 <printf>
    exit();
    1c01:	e8 12 11 00 00       	call   2d18 <exit>
    exit();
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    printf(1, "link lf1 lf2 failed\n");
    1c06:	c7 44 24 04 33 3a 00 	movl   $0x3a33,0x4(%esp)
    1c0d:	00 
    1c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c15:	e8 86 12 00 00       	call   2ea0 <printf>
    exit();
    1c1a:	e8 f9 10 00 00       	call   2d18 <exit>
  if(fd < 0){
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    printf(1, "write lf1 failed\n");
    1c1f:	c7 44 24 04 21 3a 00 	movl   $0x3a21,0x4(%esp)
    1c26:	00 
    1c27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c2e:	e8 6d 12 00 00       	call   2ea0 <printf>
    exit();
    1c33:	e8 e0 10 00 00       	call   2d18 <exit>
    1c38:	90                   	nop
    1c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001c40 <unlinkread>:
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1c40:	55                   	push   %ebp
    1c41:	89 e5                	mov    %esp,%ebp
    1c43:	56                   	push   %esi
    1c44:	53                   	push   %ebx
    1c45:	83 ec 10             	sub    $0x10,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1c48:	c7 44 24 04 b1 3a 00 	movl   $0x3ab1,0x4(%esp)
    1c4f:	00 
    1c50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c57:	e8 44 12 00 00       	call   2ea0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1c5c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1c63:	00 
    1c64:	c7 04 24 c2 3a 00 00 	movl   $0x3ac2,(%esp)
    1c6b:	e8 e8 10 00 00       	call   2d58 <open>
  if(fd < 0){
    1c70:	85 c0                	test   %eax,%eax
unlinkread(void)
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1c72:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1c74:	0f 88 fe 00 00 00    	js     1d78 <unlinkread+0x138>
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1c7a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1c81:	00 
    1c82:	c7 44 24 04 1b 3a 00 	movl   $0x3a1b,0x4(%esp)
    1c89:	00 
    1c8a:	89 04 24             	mov    %eax,(%esp)
    1c8d:	e8 a6 10 00 00       	call   2d38 <write>
  close(fd);
    1c92:	89 1c 24             	mov    %ebx,(%esp)
    1c95:	e8 a6 10 00 00       	call   2d40 <close>

  fd = open("unlinkread", O_RDWR);
    1c9a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1ca1:	00 
    1ca2:	c7 04 24 c2 3a 00 00 	movl   $0x3ac2,(%esp)
    1ca9:	e8 aa 10 00 00       	call   2d58 <open>
  if(fd < 0){
    1cae:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
    1cb0:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1cb2:	0f 88 3d 01 00 00    	js     1df5 <unlinkread+0x1b5>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1cb8:	c7 04 24 c2 3a 00 00 	movl   $0x3ac2,(%esp)
    1cbf:	e8 a4 10 00 00       	call   2d68 <unlink>
    1cc4:	85 c0                	test   %eax,%eax
    1cc6:	0f 85 10 01 00 00    	jne    1ddc <unlinkread+0x19c>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1ccc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1cd3:	00 
    1cd4:	c7 04 24 c2 3a 00 00 	movl   $0x3ac2,(%esp)
    1cdb:	e8 78 10 00 00       	call   2d58 <open>
  write(fd1, "yyy", 3);
    1ce0:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    1ce7:	00 
    1ce8:	c7 44 24 04 19 3b 00 	movl   $0x3b19,0x4(%esp)
    1cef:	00 
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1cf0:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    1cf2:	89 04 24             	mov    %eax,(%esp)
    1cf5:	e8 3e 10 00 00       	call   2d38 <write>
  close(fd1);
    1cfa:	89 34 24             	mov    %esi,(%esp)
    1cfd:	e8 3e 10 00 00       	call   2d40 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    1d02:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1d09:	00 
    1d0a:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    1d11:	00 
    1d12:	89 1c 24             	mov    %ebx,(%esp)
    1d15:	e8 16 10 00 00       	call   2d30 <read>
    1d1a:	83 f8 05             	cmp    $0x5,%eax
    1d1d:	0f 85 a0 00 00 00    	jne    1dc3 <unlinkread+0x183>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    1d23:	80 3d 60 44 00 00 68 	cmpb   $0x68,0x4460
    1d2a:	75 7e                	jne    1daa <unlinkread+0x16a>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    1d2c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1d33:	00 
    1d34:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    1d3b:	00 
    1d3c:	89 1c 24             	mov    %ebx,(%esp)
    1d3f:	e8 f4 0f 00 00       	call   2d38 <write>
    1d44:	83 f8 0a             	cmp    $0xa,%eax
    1d47:	75 48                	jne    1d91 <unlinkread+0x151>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1d49:	89 1c 24             	mov    %ebx,(%esp)
    1d4c:	e8 ef 0f 00 00       	call   2d40 <close>
  unlink("unlinkread");
    1d51:	c7 04 24 c2 3a 00 00 	movl   $0x3ac2,(%esp)
    1d58:	e8 0b 10 00 00       	call   2d68 <unlink>
  printf(1, "unlinkread ok\n");
    1d5d:	c7 44 24 04 64 3b 00 	movl   $0x3b64,0x4(%esp)
    1d64:	00 
    1d65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d6c:	e8 2f 11 00 00       	call   2ea0 <printf>
}
    1d71:	83 c4 10             	add    $0x10,%esp
    1d74:	5b                   	pop    %ebx
    1d75:	5e                   	pop    %esi
    1d76:	5d                   	pop    %ebp
    1d77:	c3                   	ret    
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create unlinkread failed\n");
    1d78:	c7 44 24 04 cd 3a 00 	movl   $0x3acd,0x4(%esp)
    1d7f:	00 
    1d80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d87:	e8 14 11 00 00       	call   2ea0 <printf>
    exit();
    1d8c:	e8 87 0f 00 00       	call   2d18 <exit>
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    printf(1, "unlinkread write failed\n");
    1d91:	c7 44 24 04 4b 3b 00 	movl   $0x3b4b,0x4(%esp)
    1d98:	00 
    1d99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1da0:	e8 fb 10 00 00       	call   2ea0 <printf>
    exit();
    1da5:	e8 6e 0f 00 00       	call   2d18 <exit>
  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    1daa:	c7 44 24 04 34 3b 00 	movl   $0x3b34,0x4(%esp)
    1db1:	00 
    1db2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1db9:	e8 e2 10 00 00       	call   2ea0 <printf>
    exit();
    1dbe:	e8 55 0f 00 00       	call   2d18 <exit>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    1dc3:	c7 44 24 04 1d 3b 00 	movl   $0x3b1d,0x4(%esp)
    1dca:	00 
    1dcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dd2:	e8 c9 10 00 00       	call   2ea0 <printf>
    exit();
    1dd7:	e8 3c 0f 00 00       	call   2d18 <exit>
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    1ddc:	c7 44 24 04 ff 3a 00 	movl   $0x3aff,0x4(%esp)
    1de3:	00 
    1de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1deb:	e8 b0 10 00 00       	call   2ea0 <printf>
    exit();
    1df0:	e8 23 0f 00 00       	call   2d18 <exit>
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    1df5:	c7 44 24 04 e7 3a 00 	movl   $0x3ae7,0x4(%esp)
    1dfc:	00 
    1dfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e04:	e8 97 10 00 00       	call   2ea0 <printf>
    exit();
    1e09:	e8 0a 0f 00 00       	call   2d18 <exit>
    1e0e:	66 90                	xchg   %ax,%ax

00001e10 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
    1e10:	55                   	push   %ebp
    1e11:	89 e5                	mov    %esp,%ebp
    1e13:	57                   	push   %edi
    1e14:	56                   	push   %esi
    1e15:	53                   	push   %ebx
    1e16:	83 ec 2c             	sub    $0x2c,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
    1e19:	c7 44 24 04 73 3b 00 	movl   $0x3b73,0x4(%esp)
    1e20:	00 
    1e21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e28:	e8 73 10 00 00       	call   2ea0 <printf>

  unlink("f1");
    1e2d:	c7 04 24 01 3a 00 00 	movl   $0x3a01,(%esp)
    1e34:	e8 2f 0f 00 00       	call   2d68 <unlink>
  unlink("f2");
    1e39:	c7 04 24 05 3a 00 00 	movl   $0x3a05,(%esp)
    1e40:	e8 23 0f 00 00       	call   2d68 <unlink>

  pid = fork();
    1e45:	e8 c6 0e 00 00       	call   2d10 <fork>
  if(pid < 0){
    1e4a:	83 f8 00             	cmp    $0x0,%eax
  printf(1, "twofiles test\n");

  unlink("f1");
  unlink("f2");

  pid = fork();
    1e4d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    1e4f:	0f 8c 64 01 00 00    	jl     1fb9 <twofiles+0x1a9>
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
    1e55:	b8 01 3a 00 00       	mov    $0x3a01,%eax
    1e5a:	75 05                	jne    1e61 <twofiles+0x51>
    1e5c:	b8 05 3a 00 00       	mov    $0x3a05,%eax
  fd = open(fname, O_CREATE | O_RDWR);
    1e61:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1e68:	00 
    1e69:	89 04 24             	mov    %eax,(%esp)
    1e6c:	e8 e7 0e 00 00       	call   2d58 <open>
  if(fd < 0){
    1e71:	85 c0                	test   %eax,%eax
    printf(1, "fork failed\n");
    return;
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
    1e73:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    1e75:	0f 88 8e 01 00 00    	js     2009 <twofiles+0x1f9>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
    1e7b:	83 ff 01             	cmp    $0x1,%edi
    1e7e:	19 c0                	sbb    %eax,%eax
    1e80:	31 db                	xor    %ebx,%ebx
    1e82:	83 e0 f3             	and    $0xfffffff3,%eax
    1e85:	83 c0 70             	add    $0x70,%eax
    1e88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1e8f:	00 
    1e90:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e94:	c7 04 24 60 44 00 00 	movl   $0x4460,(%esp)
    1e9b:	e8 e0 0c 00 00       	call   2b80 <memset>
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
    1ea0:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    1ea7:	00 
    1ea8:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    1eaf:	00 
    1eb0:	89 34 24             	mov    %esi,(%esp)
    1eb3:	e8 80 0e 00 00       	call   2d38 <write>
    1eb8:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1ebd:	0f 85 29 01 00 00    	jne    1fec <twofiles+0x1dc>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    1ec3:	83 c3 01             	add    $0x1,%ebx
    1ec6:	83 fb 0c             	cmp    $0xc,%ebx
    1ec9:	75 d5                	jne    1ea0 <twofiles+0x90>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
    1ecb:	89 34 24             	mov    %esi,(%esp)
    1ece:	e8 6d 0e 00 00       	call   2d40 <close>
  if(pid)
    1ed3:	85 ff                	test   %edi,%edi
    1ed5:	0f 84 d9 00 00 00    	je     1fb4 <twofiles+0x1a4>
    wait();
    1edb:	e8 40 0e 00 00       	call   2d20 <wait>
    1ee0:	30 db                	xor    %bl,%bl
    1ee2:	b8 05 3a 00 00       	mov    $0x3a05,%eax
  else
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    1ee7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1eee:	00 
    1eef:	31 f6                	xor    %esi,%esi
    1ef1:	89 04 24             	mov    %eax,(%esp)
    1ef4:	e8 5f 0e 00 00       	call   2d58 <open>
    1ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1f03:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    1f0a:	00 
    1f0b:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    1f12:	00 
    1f13:	89 04 24             	mov    %eax,(%esp)
    1f16:	e8 15 0e 00 00       	call   2d30 <read>
    1f1b:	85 c0                	test   %eax,%eax
    1f1d:	7e 2a                	jle    1f49 <twofiles+0x139>
    1f1f:	31 c9                	xor    %ecx,%ecx
    1f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
    1f28:	83 fb 01             	cmp    $0x1,%ebx
    1f2b:	0f be b9 60 44 00 00 	movsbl 0x4460(%ecx),%edi
    1f32:	19 d2                	sbb    %edx,%edx
    1f34:	83 e2 f3             	and    $0xfffffff3,%edx
    1f37:	83 c2 70             	add    $0x70,%edx
    1f3a:	39 d7                	cmp    %edx,%edi
    1f3c:	75 62                	jne    1fa0 <twofiles+0x190>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    1f3e:	83 c1 01             	add    $0x1,%ecx
    1f41:	39 c8                	cmp    %ecx,%eax
    1f43:	7f e3                	jg     1f28 <twofiles+0x118>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    1f45:	01 c6                	add    %eax,%esi
    1f47:	eb b7                	jmp    1f00 <twofiles+0xf0>
    }
    close(fd);
    1f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1f4c:	89 04 24             	mov    %eax,(%esp)
    1f4f:	e8 ec 0d 00 00       	call   2d40 <close>
    if(total != 12*500){
    1f54:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
    1f5a:	75 73                	jne    1fcf <twofiles+0x1bf>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    1f5c:	83 fb 01             	cmp    $0x1,%ebx
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
      exit();
    1f5f:	b8 01 3a 00 00       	mov    $0x3a01,%eax
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
    1f64:	75 30                	jne    1f96 <twofiles+0x186>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
    1f66:	89 04 24             	mov    %eax,(%esp)
    1f69:	e8 fa 0d 00 00       	call   2d68 <unlink>
  unlink("f2");
    1f6e:	c7 04 24 05 3a 00 00 	movl   $0x3a05,(%esp)
    1f75:	e8 ee 0d 00 00       	call   2d68 <unlink>

  printf(1, "twofiles ok\n");
    1f7a:	c7 44 24 04 b0 3b 00 	movl   $0x3bb0,0x4(%esp)
    1f81:	00 
    1f82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f89:	e8 12 0f 00 00       	call   2ea0 <printf>
}
    1f8e:	83 c4 2c             	add    $0x2c,%esp
    1f91:	5b                   	pop    %ebx
    1f92:	5e                   	pop    %esi
    1f93:	5f                   	pop    %edi
    1f94:	5d                   	pop    %ebp
    1f95:	c3                   	ret    
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
    1f96:	bb 01 00 00 00       	mov    $0x1,%ebx
    1f9b:	e9 47 ff ff ff       	jmp    1ee7 <twofiles+0xd7>
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
    1fa0:	c7 44 24 04 93 3b 00 	movl   $0x3b93,0x4(%esp)
    1fa7:	00 
    1fa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1faf:	e8 ec 0e 00 00       	call   2ea0 <printf>
          exit();
    1fb4:	e8 5f 0d 00 00       	call   2d18 <exit>
  unlink("f1");
  unlink("f2");

  pid = fork();
  if(pid < 0){
    printf(1, "fork failed\n");
    1fb9:	c7 44 24 04 4c 32 00 	movl   $0x324c,0x4(%esp)
    1fc0:	00 
    1fc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fc8:	e8 d3 0e 00 00       	call   2ea0 <printf>
    return;
    1fcd:	eb bf                	jmp    1f8e <twofiles+0x17e>
      }
      total += n;
    }
    close(fd);
    if(total != 12*500){
      printf(1, "wrong length %d\n", total);
    1fcf:	89 74 24 08          	mov    %esi,0x8(%esp)
    1fd3:	c7 44 24 04 9f 3b 00 	movl   $0x3b9f,0x4(%esp)
    1fda:	00 
    1fdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fe2:	e8 b9 0e 00 00       	call   2ea0 <printf>
      exit();
    1fe7:	e8 2c 0d 00 00       	call   2d18 <exit>
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
    1fec:	89 44 24 08          	mov    %eax,0x8(%esp)
    1ff0:	c7 44 24 04 82 3b 00 	movl   $0x3b82,0x4(%esp)
    1ff7:	00 
    1ff8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fff:	e8 9c 0e 00 00       	call   2ea0 <printf>
      exit();
    2004:	e8 0f 0d 00 00       	call   2d18 <exit>
  }

  fname = pid ? "f1" : "f2";
  fd = open(fname, O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "create failed\n");
    2009:	c7 44 24 04 01 34 00 	movl   $0x3401,0x4(%esp)
    2010:	00 
    2011:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2018:	e8 83 0e 00 00       	call   2ea0 <printf>
    exit();
    201d:	e8 f6 0c 00 00       	call   2d18 <exit>
    2022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002030 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    2030:	55                   	push   %ebp
    2031:	89 e5                	mov    %esp,%ebp
    2033:	57                   	push   %edi
    2034:	56                   	push   %esi
    2035:	53                   	push   %ebx
    2036:	83 ec 3c             	sub    $0x3c,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
    2039:	c7 04 24 bd 3b 00 00 	movl   $0x3bbd,(%esp)
    2040:	e8 23 0d 00 00       	call   2d68 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    2045:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    204c:	00 
    204d:	c7 04 24 bd 3b 00 00 	movl   $0x3bbd,(%esp)
    2054:	e8 ff 0c 00 00       	call   2d58 <open>
  if(fd < 0){
    2059:	85 c0                	test   %eax,%eax
{
  int fd, pid, i, n, nc, np;
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
    205b:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    205d:	0f 88 55 01 00 00    	js     21b8 <sharedfd+0x188>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    2063:	e8 a8 0c 00 00       	call   2d10 <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2068:	8d 75 de             	lea    -0x22(%ebp),%esi
    206b:	83 f8 01             	cmp    $0x1,%eax
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
    206e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    2071:	19 c0                	sbb    %eax,%eax
    2073:	31 db                	xor    %ebx,%ebx
    2075:	83 e0 f3             	and    $0xfffffff3,%eax
    2078:	83 c0 70             	add    $0x70,%eax
    207b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2082:	00 
    2083:	89 44 24 04          	mov    %eax,0x4(%esp)
    2087:	89 34 24             	mov    %esi,(%esp)
    208a:	e8 f1 0a 00 00       	call   2b80 <memset>
    208f:	eb 12                	jmp    20a3 <sharedfd+0x73>
    2091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < 1000; i++){
    2098:	83 c3 01             	add    $0x1,%ebx
    209b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    20a1:	74 2d                	je     20d0 <sharedfd+0xa0>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    20a3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    20aa:	00 
    20ab:	89 74 24 04          	mov    %esi,0x4(%esp)
    20af:	89 3c 24             	mov    %edi,(%esp)
    20b2:	e8 81 0c 00 00       	call   2d38 <write>
    20b7:	83 f8 0a             	cmp    $0xa,%eax
    20ba:	74 dc                	je     2098 <sharedfd+0x68>
      printf(1, "fstests: write sharedfd failed\n");
    20bc:	c7 44 24 04 10 43 00 	movl   $0x4310,0x4(%esp)
    20c3:	00 
    20c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20cb:	e8 d0 0d 00 00       	call   2ea0 <printf>
      break;
    }
  }
  if(pid == 0)
    20d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    20d3:	85 d2                	test   %edx,%edx
    20d5:	0f 84 0f 01 00 00    	je     21ea <sharedfd+0x1ba>
    exit();
  else
    wait();
    20db:	e8 40 0c 00 00       	call   2d20 <wait>
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    20e0:	31 db                	xor    %ebx,%ebx
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    20e2:	89 3c 24             	mov    %edi,(%esp)
  fd = open("sharedfd", 0);
  if(fd < 0){
    20e5:	31 ff                	xor    %edi,%edi
  }
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
    20e7:	e8 54 0c 00 00       	call   2d40 <close>
  fd = open("sharedfd", 0);
    20ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    20f3:	00 
    20f4:	c7 04 24 bd 3b 00 00 	movl   $0x3bbd,(%esp)
    20fb:	e8 58 0c 00 00       	call   2d58 <open>
  if(fd < 0){
    2100:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
    2102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
    2105:	0f 88 c9 00 00 00    	js     21d4 <sharedfd+0x1a4>
    210b:	90                   	nop
    210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    2110:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2117:	00 
    2118:	89 74 24 04          	mov    %esi,0x4(%esp)
    211c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    211f:	89 04 24             	mov    %eax,(%esp)
    2122:	e8 09 0c 00 00       	call   2d30 <read>
    2127:	85 c0                	test   %eax,%eax
    2129:	7e 26                	jle    2151 <sharedfd+0x121>
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
    212b:	31 c0                	xor    %eax,%eax
    212d:	eb 14                	jmp    2143 <sharedfd+0x113>
    212f:	90                   	nop
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
        nc++;
      if(buf[i] == 'p')
        np++;
    2130:	80 fa 70             	cmp    $0x70,%dl
    2133:	0f 94 c2             	sete   %dl
    2136:	0f b6 d2             	movzbl %dl,%edx
    2139:	01 d3                	add    %edx,%ebx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
    213b:	83 c0 01             	add    $0x1,%eax
    213e:	83 f8 0a             	cmp    $0xa,%eax
    2141:	74 cd                	je     2110 <sharedfd+0xe0>
      if(buf[i] == 'c')
    2143:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
    2147:	80 fa 63             	cmp    $0x63,%dl
    214a:	75 e4                	jne    2130 <sharedfd+0x100>
        nc++;
    214c:	83 c7 01             	add    $0x1,%edi
    214f:	eb ea                	jmp    213b <sharedfd+0x10b>
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
    2151:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2154:	89 04 24             	mov    %eax,(%esp)
    2157:	e8 e4 0b 00 00       	call   2d40 <close>
  unlink("sharedfd");
    215c:	c7 04 24 bd 3b 00 00 	movl   $0x3bbd,(%esp)
    2163:	e8 00 0c 00 00       	call   2d68 <unlink>
  if(nc == 10000 && np == 10000)
    2168:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    216e:	74 24                	je     2194 <sharedfd+0x164>
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
    2170:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    2174:	89 7c 24 08          	mov    %edi,0x8(%esp)
    2178:	c7 44 24 04 d3 3b 00 	movl   $0x3bd3,0x4(%esp)
    217f:	00 
    2180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2187:	e8 14 0d 00 00       	call   2ea0 <printf>
}
    218c:	83 c4 3c             	add    $0x3c,%esp
    218f:	5b                   	pop    %ebx
    2190:	5e                   	pop    %esi
    2191:	5f                   	pop    %edi
    2192:	5d                   	pop    %ebp
    2193:	c3                   	ret    
        np++;
    }
  }
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    2194:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
    219a:	75 d4                	jne    2170 <sharedfd+0x140>
    printf(1, "sharedfd ok\n");
    219c:	c7 44 24 04 c6 3b 00 	movl   $0x3bc6,0x4(%esp)
    21a3:	00 
    21a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ab:	e8 f0 0c 00 00       	call   2ea0 <printf>
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    21b0:	83 c4 3c             	add    $0x3c,%esp
    21b3:	5b                   	pop    %ebx
    21b4:	5e                   	pop    %esi
    21b5:	5f                   	pop    %edi
    21b6:	5d                   	pop    %ebp
    21b7:	c3                   	ret    
  char buf[10];

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    21b8:	c7 44 24 04 e4 42 00 	movl   $0x42e4,0x4(%esp)
    21bf:	00 
    21c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c7:	e8 d4 0c 00 00       	call   2ea0 <printf>
  unlink("sharedfd");
  if(nc == 10000 && np == 10000)
    printf(1, "sharedfd ok\n");
  else
    printf(1, "sharedfd oops %d %d\n", nc, np);
}
    21cc:	83 c4 3c             	add    $0x3c,%esp
    21cf:	5b                   	pop    %ebx
    21d0:	5e                   	pop    %esi
    21d1:	5f                   	pop    %edi
    21d2:	5d                   	pop    %ebp
    21d3:	c3                   	ret    
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    21d4:	c7 44 24 04 30 43 00 	movl   $0x4330,0x4(%esp)
    21db:	00 
    21dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21e3:	e8 b8 0c 00 00       	call   2ea0 <printf>
    return;
    21e8:	eb a2                	jmp    218c <sharedfd+0x15c>
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
    exit();
    21ea:	e8 29 0b 00 00       	call   2d18 <exit>
    21ef:	90                   	nop

000021f0 <writetest1>:
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
    21f0:	55                   	push   %ebp
    21f1:	89 e5                	mov    %esp,%ebp
    21f3:	56                   	push   %esi
    21f4:	53                   	push   %ebx
    21f5:	83 ec 10             	sub    $0x10,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    21f8:	a1 28 44 00 00       	mov    0x4428,%eax
    21fd:	c7 44 24 04 e8 3b 00 	movl   $0x3be8,0x4(%esp)
    2204:	00 
    2205:	89 04 24             	mov    %eax,(%esp)
    2208:	e8 93 0c 00 00       	call   2ea0 <printf>

  fd = open("big", O_CREATE|O_RDWR);
    220d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2214:	00 
    2215:	c7 04 24 62 3c 00 00 	movl   $0x3c62,(%esp)
    221c:	e8 37 0b 00 00       	call   2d58 <open>
  if(fd < 0){
    2221:	85 c0                	test   %eax,%eax
{
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
    2223:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2225:	0f 88 7a 01 00 00    	js     23a5 <writetest1+0x1b5>
    printf(stdout, "error: creat big failed!\n");
    exit();
    222b:	31 db                	xor    %ebx,%ebx
    222d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  for(i = 0; i < MAXFILE; i++) {
    ((int*) buf)[0] = i;
    2230:	89 1d 60 44 00 00    	mov    %ebx,0x4460
    if(write(fd, buf, 512) != 512) {
    2236:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    223d:	00 
    223e:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    2245:	00 
    2246:	89 34 24             	mov    %esi,(%esp)
    2249:	e8 ea 0a 00 00       	call   2d38 <write>
    224e:	3d 00 02 00 00       	cmp    $0x200,%eax
    2253:	0f 85 b2 00 00 00    	jne    230b <writetest1+0x11b>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++) {
    2259:	83 c3 01             	add    $0x1,%ebx
    225c:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
    2262:	75 cc                	jne    2230 <writetest1+0x40>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
    2264:	89 34 24             	mov    %esi,(%esp)
    2267:	e8 d4 0a 00 00       	call   2d40 <close>

  fd = open("big", O_RDONLY);
    226c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2273:	00 
    2274:	c7 04 24 62 3c 00 00 	movl   $0x3c62,(%esp)
    227b:	e8 d8 0a 00 00       	call   2d58 <open>
  if(fd < 0){
    2280:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
    2282:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2284:	0f 88 01 01 00 00    	js     238b <writetest1+0x19b>
    printf(stdout, "error: open big failed!\n");
    exit();
    228a:	31 db                	xor    %ebx,%ebx
    228c:	eb 1d                	jmp    22ab <writetest1+0xbb>
    228e:	66 90                	xchg   %ax,%ax
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
    2290:	3d 00 02 00 00       	cmp    $0x200,%eax
    2295:	0f 85 b0 00 00 00    	jne    234b <writetest1+0x15b>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n) {
    229b:	a1 60 44 00 00       	mov    0x4460,%eax
    22a0:	39 d8                	cmp    %ebx,%eax
    22a2:	0f 85 81 00 00 00    	jne    2329 <writetest1+0x139>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
    22a8:	83 c3 01             	add    $0x1,%ebx
    exit();
  }

  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    22ab:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    22b2:	00 
    22b3:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    22ba:	00 
    22bb:	89 34 24             	mov    %esi,(%esp)
    22be:	e8 6d 0a 00 00       	call   2d30 <read>
    if(i == 0) {
    22c3:	85 c0                	test   %eax,%eax
    22c5:	75 c9                	jne    2290 <writetest1+0xa0>
      if(n == MAXFILE - 1) {
    22c7:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
    22cd:	0f 84 96 00 00 00    	je     2369 <writetest1+0x179>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    22d3:	89 34 24             	mov    %esi,(%esp)
    22d6:	e8 65 0a 00 00       	call   2d40 <close>
  if(unlink("big") < 0) {
    22db:	c7 04 24 62 3c 00 00 	movl   $0x3c62,(%esp)
    22e2:	e8 81 0a 00 00       	call   2d68 <unlink>
    22e7:	85 c0                	test   %eax,%eax
    22e9:	0f 88 d0 00 00 00    	js     23bf <writetest1+0x1cf>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
    22ef:	a1 28 44 00 00       	mov    0x4428,%eax
    22f4:	c7 44 24 04 89 3c 00 	movl   $0x3c89,0x4(%esp)
    22fb:	00 
    22fc:	89 04 24             	mov    %eax,(%esp)
    22ff:	e8 9c 0b 00 00       	call   2ea0 <printf>
}
    2304:	83 c4 10             	add    $0x10,%esp
    2307:	5b                   	pop    %ebx
    2308:	5e                   	pop    %esi
    2309:	5d                   	pop    %ebp
    230a:	c3                   	ret    
  }

  for(i = 0; i < MAXFILE; i++) {
    ((int*) buf)[0] = i;
    if(write(fd, buf, 512) != 512) {
      printf(stdout, "error: write big file failed\n", i);
    230b:	a1 28 44 00 00       	mov    0x4428,%eax
    2310:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2314:	c7 44 24 04 12 3c 00 	movl   $0x3c12,0x4(%esp)
    231b:	00 
    231c:	89 04 24             	mov    %eax,(%esp)
    231f:	e8 7c 0b 00 00       	call   2ea0 <printf>
      exit();
    2324:	e8 ef 09 00 00       	call   2d18 <exit>
    } else if(i != 512) {
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n) {
      printf(stdout, "read content of block %d is %d\n",
    2329:	89 44 24 0c          	mov    %eax,0xc(%esp)
    232d:	a1 28 44 00 00       	mov    0x4428,%eax
    2332:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2336:	c7 44 24 04 5c 43 00 	movl   $0x435c,0x4(%esp)
    233d:	00 
    233e:	89 04 24             	mov    %eax,(%esp)
    2341:	e8 5a 0b 00 00       	call   2ea0 <printf>
             n, ((int*)buf)[0]);
      exit();
    2346:	e8 cd 09 00 00       	call   2d18 <exit>
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512) {
      printf(stdout, "read failed %d\n", i);
    234b:	89 44 24 08          	mov    %eax,0x8(%esp)
    234f:	a1 28 44 00 00       	mov    0x4428,%eax
    2354:	c7 44 24 04 66 3c 00 	movl   $0x3c66,0x4(%esp)
    235b:	00 
    235c:	89 04 24             	mov    %eax,(%esp)
    235f:	e8 3c 0b 00 00       	call   2ea0 <printf>
      exit();
    2364:	e8 af 09 00 00       	call   2d18 <exit>
  n = 0;
  for(;;) {
    i = read(fd, buf, 512);
    if(i == 0) {
      if(n == MAXFILE - 1) {
        printf(stdout, "read only %d blocks from big", n);
    2369:	a1 28 44 00 00       	mov    0x4428,%eax
    236e:	c7 44 24 08 8b 00 00 	movl   $0x8b,0x8(%esp)
    2375:	00 
    2376:	c7 44 24 04 49 3c 00 	movl   $0x3c49,0x4(%esp)
    237d:	00 
    237e:	89 04 24             	mov    %eax,(%esp)
    2381:	e8 1a 0b 00 00       	call   2ea0 <printf>
        exit();
    2386:	e8 8d 09 00 00       	call   2d18 <exit>

  close(fd);

  fd = open("big", O_RDONLY);
  if(fd < 0){
    printf(stdout, "error: open big failed!\n");
    238b:	a1 28 44 00 00       	mov    0x4428,%eax
    2390:	c7 44 24 04 30 3c 00 	movl   $0x3c30,0x4(%esp)
    2397:	00 
    2398:	89 04 24             	mov    %eax,(%esp)
    239b:	e8 00 0b 00 00       	call   2ea0 <printf>
    exit();
    23a0:	e8 73 09 00 00       	call   2d18 <exit>

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    23a5:	a1 28 44 00 00       	mov    0x4428,%eax
    23aa:	c7 44 24 04 f8 3b 00 	movl   $0x3bf8,0x4(%esp)
    23b1:	00 
    23b2:	89 04 24             	mov    %eax,(%esp)
    23b5:	e8 e6 0a 00 00       	call   2ea0 <printf>
    exit();
    23ba:	e8 59 09 00 00       	call   2d18 <exit>
    }
    n++;
  }
  close(fd);
  if(unlink("big") < 0) {
    printf(stdout, "unlink big failed\n");
    23bf:	a1 28 44 00 00       	mov    0x4428,%eax
    23c4:	c7 44 24 04 76 3c 00 	movl   $0x3c76,0x4(%esp)
    23cb:	00 
    23cc:	89 04 24             	mov    %eax,(%esp)
    23cf:	e8 cc 0a 00 00       	call   2ea0 <printf>
    exit();
    23d4:	e8 3f 09 00 00       	call   2d18 <exit>
    23d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000023e0 <writetest>:
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
    23e0:	55                   	push   %ebp
    23e1:	89 e5                	mov    %esp,%ebp
    23e3:	56                   	push   %esi
    23e4:	53                   	push   %ebx
    23e5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    23e8:	a1 28 44 00 00       	mov    0x4428,%eax
    23ed:	c7 44 24 04 97 3c 00 	movl   $0x3c97,0x4(%esp)
    23f4:	00 
    23f5:	89 04 24             	mov    %eax,(%esp)
    23f8:	e8 a3 0a 00 00       	call   2ea0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
    23fd:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2404:	00 
    2405:	c7 04 24 a8 3c 00 00 	movl   $0x3ca8,(%esp)
    240c:	e8 47 09 00 00       	call   2d58 <open>
  if(fd >= 0){
    2411:	85 c0                	test   %eax,%eax
{
  int fd;
  int i;

  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
    2413:	89 c6                	mov    %eax,%esi
  if(fd >= 0){
    2415:	0f 88 b1 01 00 00    	js     25cc <writetest+0x1ec>
    printf(stdout, "creat small succeeded; ok\n");
    241b:	a1 28 44 00 00       	mov    0x4428,%eax
    2420:	31 db                	xor    %ebx,%ebx
    2422:	c7 44 24 04 ae 3c 00 	movl   $0x3cae,0x4(%esp)
    2429:	00 
    242a:	89 04 24             	mov    %eax,(%esp)
    242d:	e8 6e 0a 00 00       	call   2ea0 <printf>
    2432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
    2438:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    243f:	00 
    2440:	c7 44 24 04 e5 3c 00 	movl   $0x3ce5,0x4(%esp)
    2447:	00 
    2448:	89 34 24             	mov    %esi,(%esp)
    244b:	e8 e8 08 00 00       	call   2d38 <write>
    2450:	83 f8 0a             	cmp    $0xa,%eax
    2453:	0f 85 e9 00 00 00    	jne    2542 <writetest+0x162>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
    2459:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2460:	00 
    2461:	c7 44 24 04 f0 3c 00 	movl   $0x3cf0,0x4(%esp)
    2468:	00 
    2469:	89 34 24             	mov    %esi,(%esp)
    246c:	e8 c7 08 00 00       	call   2d38 <write>
    2471:	83 f8 0a             	cmp    $0xa,%eax
    2474:	0f 85 e6 00 00 00    	jne    2560 <writetest+0x180>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    247a:	83 c3 01             	add    $0x1,%ebx
    247d:	83 fb 64             	cmp    $0x64,%ebx
    2480:	75 b6                	jne    2438 <writetest+0x58>
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
    2482:	a1 28 44 00 00       	mov    0x4428,%eax
    2487:	c7 44 24 04 fb 3c 00 	movl   $0x3cfb,0x4(%esp)
    248e:	00 
    248f:	89 04 24             	mov    %eax,(%esp)
    2492:	e8 09 0a 00 00       	call   2ea0 <printf>
  close(fd);
    2497:	89 34 24             	mov    %esi,(%esp)
    249a:	e8 a1 08 00 00       	call   2d40 <close>
  fd = open("small", O_RDONLY);
    249f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    24a6:	00 
    24a7:	c7 04 24 a8 3c 00 00 	movl   $0x3ca8,(%esp)
    24ae:	e8 a5 08 00 00       	call   2d58 <open>
  if(fd >= 0){
    24b3:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
    24b5:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
    24b7:	0f 88 c1 00 00 00    	js     257e <writetest+0x19e>
    printf(stdout, "open small succeeded ok\n");
    24bd:	a1 28 44 00 00       	mov    0x4428,%eax
    24c2:	c7 44 24 04 06 3d 00 	movl   $0x3d06,0x4(%esp)
    24c9:	00 
    24ca:	89 04 24             	mov    %eax,(%esp)
    24cd:	e8 ce 09 00 00       	call   2ea0 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    24d2:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    24d9:	00 
    24da:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    24e1:	00 
    24e2:	89 1c 24             	mov    %ebx,(%esp)
    24e5:	e8 46 08 00 00       	call   2d30 <read>
  if(i == 2000) {
    24ea:	3d d0 07 00 00       	cmp    $0x7d0,%eax
    24ef:	0f 85 a3 00 00 00    	jne    2598 <writetest+0x1b8>
    printf(stdout, "read succeeded ok\n");
    24f5:	a1 28 44 00 00       	mov    0x4428,%eax
    24fa:	c7 44 24 04 3a 3d 00 	movl   $0x3d3a,0x4(%esp)
    2501:	00 
    2502:	89 04 24             	mov    %eax,(%esp)
    2505:	e8 96 09 00 00       	call   2ea0 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    250a:	89 1c 24             	mov    %ebx,(%esp)
    250d:	e8 2e 08 00 00       	call   2d40 <close>

  if(unlink("small") < 0) {
    2512:	c7 04 24 a8 3c 00 00 	movl   $0x3ca8,(%esp)
    2519:	e8 4a 08 00 00       	call   2d68 <unlink>
    251e:	85 c0                	test   %eax,%eax
    2520:	0f 88 8c 00 00 00    	js     25b2 <writetest+0x1d2>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
    2526:	a1 28 44 00 00       	mov    0x4428,%eax
    252b:	c7 44 24 04 62 3d 00 	movl   $0x3d62,0x4(%esp)
    2532:	00 
    2533:	89 04 24             	mov    %eax,(%esp)
    2536:	e8 65 09 00 00       	call   2ea0 <printf>
}
    253b:	83 c4 10             	add    $0x10,%esp
    253e:	5b                   	pop    %ebx
    253f:	5e                   	pop    %esi
    2540:	5d                   	pop    %ebp
    2541:	c3                   	ret    
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++) {
    if(write(fd, "aaaaaaaaaa", 10) != 10) {
      printf(stdout, "error: write aa %d new file failed\n", i);
    2542:	a1 28 44 00 00       	mov    0x4428,%eax
    2547:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    254b:	c7 44 24 04 7c 43 00 	movl   $0x437c,0x4(%esp)
    2552:	00 
    2553:	89 04 24             	mov    %eax,(%esp)
    2556:	e8 45 09 00 00       	call   2ea0 <printf>
      exit();
    255b:	e8 b8 07 00 00       	call   2d18 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10) {
      printf(stdout, "error: write bb %d new file failed\n", i);
    2560:	a1 28 44 00 00       	mov    0x4428,%eax
    2565:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    2569:	c7 44 24 04 a0 43 00 	movl   $0x43a0,0x4(%esp)
    2570:	00 
    2571:	89 04 24             	mov    %eax,(%esp)
    2574:	e8 27 09 00 00       	call   2ea0 <printf>
      exit();
    2579:	e8 9a 07 00 00       	call   2d18 <exit>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
    257e:	a1 28 44 00 00       	mov    0x4428,%eax
    2583:	c7 44 24 04 1f 3d 00 	movl   $0x3d1f,0x4(%esp)
    258a:	00 
    258b:	89 04 24             	mov    %eax,(%esp)
    258e:	e8 0d 09 00 00       	call   2ea0 <printf>
    exit();
    2593:	e8 80 07 00 00       	call   2d18 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000) {
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
    2598:	a1 28 44 00 00       	mov    0x4428,%eax
    259d:	c7 44 24 04 da 3a 00 	movl   $0x3ada,0x4(%esp)
    25a4:	00 
    25a5:	89 04 24             	mov    %eax,(%esp)
    25a8:	e8 f3 08 00 00       	call   2ea0 <printf>
    exit();
    25ad:	e8 66 07 00 00       	call   2d18 <exit>
  }
  close(fd);

  if(unlink("small") < 0) {
    printf(stdout, "unlink small failed\n");
    25b2:	a1 28 44 00 00       	mov    0x4428,%eax
    25b7:	c7 44 24 04 4d 3d 00 	movl   $0x3d4d,0x4(%esp)
    25be:	00 
    25bf:	89 04 24             	mov    %eax,(%esp)
    25c2:	e8 d9 08 00 00       	call   2ea0 <printf>
    exit();
    25c7:	e8 4c 07 00 00       	call   2d18 <exit>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    25cc:	a1 28 44 00 00       	mov    0x4428,%eax
    25d1:	c7 44 24 04 c9 3c 00 	movl   $0x3cc9,0x4(%esp)
    25d8:	00 
    25d9:	89 04 24             	mov    %eax,(%esp)
    25dc:	e8 bf 08 00 00       	call   2ea0 <printf>
    exit();
    25e1:	e8 32 07 00 00       	call   2d18 <exit>
    25e6:	8d 76 00             	lea    0x0(%esi),%esi
    25e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000025f0 <mem>:
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    25f0:	55                   	push   %ebp
    25f1:	89 e5                	mov    %esp,%ebp
    25f3:	56                   	push   %esi
    25f4:	53                   	push   %ebx
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    25f5:	31 db                	xor    %ebx,%ebx
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
    25f7:	83 ec 10             	sub    $0x10,%esp
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    25fa:	e8 11 07 00 00       	call   2d10 <fork>
    25ff:	85 c0                	test   %eax,%eax
    2601:	74 09                	je     260c <mem+0x1c>
    2603:	eb 5c                	jmp    2661 <mem+0x71>
    2605:	8d 76 00             	lea    0x0(%esi),%esi
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
    2608:	89 18                	mov    %ebx,(%eax)
    260a:	89 c3                	mov    %eax,%ebx
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
    260c:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    2613:	e8 b8 0a 00 00       	call   30d0 <malloc>
    2618:	85 c0                	test   %eax,%eax
    261a:	75 ec                	jne    2608 <mem+0x18>
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    261c:	85 db                	test   %ebx,%ebx
    261e:	74 10                	je     2630 <mem+0x40>
      m2 = *(char**)m1;
    2620:	8b 33                	mov    (%ebx),%esi
      free(m1);
    2622:	89 1c 24             	mov    %ebx,(%esp)
    2625:	e8 16 0a 00 00       	call   3040 <free>
    262a:	89 f3                	mov    %esi,%ebx
    m1 = 0;
    while((m2 = malloc(10001)) != 0) {
      *(char**) m2 = m1;
      m1 = m2;
    }
    while(m1) {
    262c:	85 db                	test   %ebx,%ebx
    262e:	75 f0                	jne    2620 <mem+0x30>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    2630:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    2637:	e8 94 0a 00 00       	call   30d0 <malloc>
    if(m1 == 0) {
    263c:	85 c0                	test   %eax,%eax
    263e:	74 30                	je     2670 <mem+0x80>
      printf(1, "couldn't allocate mem?!!\n");
      exit();
    }
    free(m1);
    2640:	89 04 24             	mov    %eax,(%esp)
    2643:	e8 f8 09 00 00       	call   3040 <free>
    printf(1, "mem ok\n");
    2648:	c7 44 24 04 90 3d 00 	movl   $0x3d90,0x4(%esp)
    264f:	00 
    2650:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2657:	e8 44 08 00 00       	call   2ea0 <printf>
    exit();
    265c:	e8 b7 06 00 00       	call   2d18 <exit>
  } else {
    wait();
  }
}
    2661:	83 c4 10             	add    $0x10,%esp
    2664:	5b                   	pop    %ebx
    2665:	5e                   	pop    %esi
    2666:	5d                   	pop    %ebp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
    2667:	e9 b4 06 00 00       	jmp    2d20 <wait>
    266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
    if(m1 == 0) {
      printf(1, "couldn't allocate mem?!!\n");
    2670:	c7 44 24 04 76 3d 00 	movl   $0x3d76,0x4(%esp)
    2677:	00 
    2678:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    267f:	e8 1c 08 00 00       	call   2ea0 <printf>
      exit();
    2684:	e8 8f 06 00 00       	call   2d18 <exit>
    2689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002690 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    2690:	55                   	push   %ebp
    2691:	89 e5                	mov    %esp,%ebp
    2693:	57                   	push   %edi
    2694:	56                   	push   %esi
    2695:	53                   	push   %ebx
    2696:	83 ec 2c             	sub    $0x2c,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    2699:	8d 45 e0             	lea    -0x20(%ebp),%eax
    269c:	89 04 24             	mov    %eax,(%esp)
    269f:	e8 84 06 00 00       	call   2d28 <pipe>
    26a4:	85 c0                	test   %eax,%eax
    26a6:	0f 85 53 01 00 00    	jne    27ff <pipe1+0x16f>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
    26ac:	e8 5f 06 00 00       	call   2d10 <fork>
  seq = 0;
  if(pid == 0){
    26b1:	83 f8 00             	cmp    $0x0,%eax
    26b4:	0f 84 87 00 00 00    	je     2741 <pipe1+0xb1>
    26ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    26c0:	0f 8e 52 01 00 00    	jle    2818 <pipe1+0x188>
    close(fds[1]);
    26c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    26c9:	31 ff                	xor    %edi,%edi
    26cb:	be 01 00 00 00       	mov    $0x1,%esi
    26d0:	31 db                	xor    %ebx,%ebx
    26d2:	89 04 24             	mov    %eax,(%esp)
    26d5:	e8 66 06 00 00       	call   2d40 <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
    26da:	8b 45 e0             	mov    -0x20(%ebp),%eax
    26dd:	89 74 24 08          	mov    %esi,0x8(%esp)
    26e1:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    26e8:	00 
    26e9:	89 04 24             	mov    %eax,(%esp)
    26ec:	e8 3f 06 00 00       	call   2d30 <read>
    26f1:	85 c0                	test   %eax,%eax
    26f3:	0f 8e a4 00 00 00    	jle    279d <pipe1+0x10d>
    26f9:	31 d2                	xor    %edx,%edx
    26fb:	90                   	nop
    26fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    2700:	38 9a 60 44 00 00    	cmp    %bl,0x4460(%edx)
    2706:	75 1d                	jne    2725 <pipe1+0x95>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    2708:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    270b:	83 c3 01             	add    $0x1,%ebx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
    270e:	39 d0                	cmp    %edx,%eax
    2710:	7f ee                	jg     2700 <pipe1+0x70>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
    2712:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
    2714:	81 fe 00 08 00 00    	cmp    $0x800,%esi
    271a:	76 05                	jbe    2721 <pipe1+0x91>
    271c:	be 00 08 00 00       	mov    $0x800,%esi
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
    2721:	01 c7                	add    %eax,%edi
    2723:	eb b5                	jmp    26da <pipe1+0x4a>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
    2725:	c7 44 24 04 b5 3d 00 	movl   $0x3db5,0x4(%esp)
    272c:	00 
    272d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2734:	e8 67 07 00 00       	call   2ea0 <printf>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
    2739:	83 c4 2c             	add    $0x2c,%esp
    273c:	5b                   	pop    %ebx
    273d:	5e                   	pop    %esi
    273e:	5f                   	pop    %edi
    273f:	5d                   	pop    %ebp
    2740:	c3                   	ret    
    exit();
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    2741:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2744:	31 db                	xor    %ebx,%ebx
    2746:	89 04 24             	mov    %eax,(%esp)
    2749:	e8 f2 05 00 00       	call   2d40 <close>
    for(n = 0; n < 5; n++){
    274e:	31 c0                	xor    %eax,%eax
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
    2750:	8d 14 18             	lea    (%eax,%ebx,1),%edx
    2753:	88 90 60 44 00 00    	mov    %dl,0x4460(%eax)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    2759:	83 c0 01             	add    $0x1,%eax
    275c:	3d 09 04 00 00       	cmp    $0x409,%eax
    2761:	75 ed                	jne    2750 <pipe1+0xc0>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    2763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
    2766:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
    276c:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    2773:	00 
    2774:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    277b:	00 
    277c:	89 04 24             	mov    %eax,(%esp)
    277f:	e8 b4 05 00 00       	call   2d38 <write>
    2784:	3d 09 04 00 00       	cmp    $0x409,%eax
    2789:	75 5b                	jne    27e6 <pipe1+0x156>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
    278b:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
    2791:	75 bb                	jne    274e <pipe1+0xbe>
    2793:	90                   	nop
    2794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    exit();
    2798:	e8 7b 05 00 00       	call   2d18 <exit>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033)
    279d:	81 ff 2d 14 00 00    	cmp    $0x142d,%edi
    27a3:	74 18                	je     27bd <pipe1+0x12d>
      printf(1, "pipe1 oops 3 total %d\n", total);
    27a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
    27a9:	c7 44 24 04 c3 3d 00 	movl   $0x3dc3,0x4(%esp)
    27b0:	00 
    27b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27b8:	e8 e3 06 00 00       	call   2ea0 <printf>
    close(fds[0]);
    27bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
    27c0:	89 04 24             	mov    %eax,(%esp)
    27c3:	e8 78 05 00 00       	call   2d40 <close>
    wait();
    27c8:	e8 53 05 00 00       	call   2d20 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    27cd:	c7 44 24 04 da 3d 00 	movl   $0x3dda,0x4(%esp)
    27d4:	00 
    27d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27dc:	e8 bf 06 00 00       	call   2ea0 <printf>
    27e1:	e9 53 ff ff ff       	jmp    2739 <pipe1+0xa9>
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
    27e6:	c7 44 24 04 a7 3d 00 	movl   $0x3da7,0x4(%esp)
    27ed:	00 
    27ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f5:	e8 a6 06 00 00       	call   2ea0 <printf>
        exit();
    27fa:	e8 19 05 00 00       	call   2d18 <exit>
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    27ff:	c7 44 24 04 98 3d 00 	movl   $0x3d98,0x4(%esp)
    2806:	00 
    2807:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    280e:	e8 8d 06 00 00       	call   2ea0 <printf>
    exit();
    2813:	e8 00 05 00 00       	call   2d18 <exit>
    if(total != 5 * 1033)
      printf(1, "pipe1 oops 3 total %d\n", total);
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
    2818:	c7 44 24 04 e4 3d 00 	movl   $0x3de4,0x4(%esp)
    281f:	00 
    2820:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2827:	e8 74 06 00 00       	call   2ea0 <printf>
    282c:	e9 62 ff ff ff       	jmp    2793 <pipe1+0x103>
    2831:	eb 0d                	jmp    2840 <preempt>
    2833:	90                   	nop
    2834:	90                   	nop
    2835:	90                   	nop
    2836:	90                   	nop
    2837:	90                   	nop
    2838:	90                   	nop
    2839:	90                   	nop
    283a:	90                   	nop
    283b:	90                   	nop
    283c:	90                   	nop
    283d:	90                   	nop
    283e:	90                   	nop
    283f:	90                   	nop

00002840 <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    2840:	55                   	push   %ebp
    2841:	89 e5                	mov    %esp,%ebp
    2843:	57                   	push   %edi
    2844:	56                   	push   %esi
    2845:	53                   	push   %ebx
    2846:	83 ec 2c             	sub    $0x2c,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    2849:	c7 44 24 04 f3 3d 00 	movl   $0x3df3,0x4(%esp)
    2850:	00 
    2851:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2858:	e8 43 06 00 00       	call   2ea0 <printf>
  pid1 = fork();
    285d:	e8 ae 04 00 00       	call   2d10 <fork>
  if(pid1 == 0)
    2862:	85 c0                	test   %eax,%eax
{
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
  pid1 = fork();
    2864:	89 c7                	mov    %eax,%edi
  if(pid1 == 0)
    2866:	75 02                	jne    286a <preempt+0x2a>
    2868:	eb fe                	jmp    2868 <preempt+0x28>
    286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(;;)
      ;

  pid2 = fork();
    2870:	e8 9b 04 00 00       	call   2d10 <fork>
  if(pid2 == 0)
    2875:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
    2877:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
    2879:	75 02                	jne    287d <preempt+0x3d>
    287b:	eb fe                	jmp    287b <preempt+0x3b>
    for(;;)
      ;

  pipe(pfds);
    287d:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2880:	89 04 24             	mov    %eax,(%esp)
    2883:	e8 a0 04 00 00       	call   2d28 <pipe>
  pid3 = fork();
    2888:	e8 83 04 00 00       	call   2d10 <fork>
  if(pid3 == 0){
    288d:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
    288f:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
    2891:	75 4c                	jne    28df <preempt+0x9f>
    close(pfds[0]);
    2893:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2896:	89 04 24             	mov    %eax,(%esp)
    2899:	e8 a2 04 00 00       	call   2d40 <close>
    if(write(pfds[1], "x", 1) != 1)
    289e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    28a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    28a8:	00 
    28a9:	c7 44 24 04 7f 38 00 	movl   $0x387f,0x4(%esp)
    28b0:	00 
    28b1:	89 04 24             	mov    %eax,(%esp)
    28b4:	e8 7f 04 00 00       	call   2d38 <write>
    28b9:	83 f8 01             	cmp    $0x1,%eax
    28bc:	74 14                	je     28d2 <preempt+0x92>
      printf(1, "preempt write error");
    28be:	c7 44 24 04 fd 3d 00 	movl   $0x3dfd,0x4(%esp)
    28c5:	00 
    28c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28cd:	e8 ce 05 00 00       	call   2ea0 <printf>
    close(pfds[1]);
    28d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    28d5:	89 04 24             	mov    %eax,(%esp)
    28d8:	e8 63 04 00 00       	call   2d40 <close>
    28dd:	eb fe                	jmp    28dd <preempt+0x9d>
    for(;;)
      ;
  }

  close(pfds[1]);
    28df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    28e2:	89 04 24             	mov    %eax,(%esp)
    28e5:	e8 56 04 00 00       	call   2d40 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    28ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
    28ed:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
    28f4:	00 
    28f5:	c7 44 24 04 60 44 00 	movl   $0x4460,0x4(%esp)
    28fc:	00 
    28fd:	89 04 24             	mov    %eax,(%esp)
    2900:	e8 2b 04 00 00       	call   2d30 <read>
    2905:	83 f8 01             	cmp    $0x1,%eax
    2908:	74 1c                	je     2926 <preempt+0xe6>
    printf(1, "preempt read error");
    290a:	c7 44 24 04 11 3e 00 	movl   $0x3e11,0x4(%esp)
    2911:	00 
    2912:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2919:	e8 82 05 00 00       	call   2ea0 <printf>
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
    291e:	83 c4 2c             	add    $0x2c,%esp
    2921:	5b                   	pop    %ebx
    2922:	5e                   	pop    %esi
    2923:	5f                   	pop    %edi
    2924:	5d                   	pop    %ebp
    2925:	c3                   	ret    
  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
    2926:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2929:	89 04 24             	mov    %eax,(%esp)
    292c:	e8 0f 04 00 00       	call   2d40 <close>
  printf(1, "kill... ");
    2931:	c7 44 24 04 24 3e 00 	movl   $0x3e24,0x4(%esp)
    2938:	00 
    2939:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2940:	e8 5b 05 00 00       	call   2ea0 <printf>
  kill(pid1);
    2945:	89 3c 24             	mov    %edi,(%esp)
    2948:	e8 fb 03 00 00       	call   2d48 <kill>
  kill(pid2);
    294d:	89 34 24             	mov    %esi,(%esp)
    2950:	e8 f3 03 00 00       	call   2d48 <kill>
  kill(pid3);
    2955:	89 1c 24             	mov    %ebx,(%esp)
    2958:	e8 eb 03 00 00       	call   2d48 <kill>
  printf(1, "wait... ");
    295d:	c7 44 24 04 2d 3e 00 	movl   $0x3e2d,0x4(%esp)
    2964:	00 
    2965:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    296c:	e8 2f 05 00 00       	call   2ea0 <printf>
  wait();
    2971:	e8 aa 03 00 00       	call   2d20 <wait>
  wait();
    2976:	e8 a5 03 00 00       	call   2d20 <wait>
    297b:	90                   	nop
    297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  wait();
    2980:	e8 9b 03 00 00       	call   2d20 <wait>
  printf(1, "preempt ok\n");
    2985:	c7 44 24 04 36 3e 00 	movl   $0x3e36,0x4(%esp)
    298c:	00 
    298d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2994:	e8 07 05 00 00       	call   2ea0 <printf>
    2999:	eb 83                	jmp    291e <preempt+0xde>
    299b:	90                   	nop
    299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000029a0 <exectest>:
  printf(stdout, "mkdir test\n");
}

void
exectest(void)
{
    29a0:	55                   	push   %ebp
    29a1:	89 e5                	mov    %esp,%ebp
    29a3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
    29a6:	a1 28 44 00 00       	mov    0x4428,%eax
    29ab:	c7 44 24 04 42 3e 00 	movl   $0x3e42,0x4(%esp)
    29b2:	00 
    29b3:	89 04 24             	mov    %eax,(%esp)
    29b6:	e8 e5 04 00 00       	call   2ea0 <printf>
  if(exec("echo", echo_args) < 0) {
    29bb:	c7 44 24 04 08 44 00 	movl   $0x4408,0x4(%esp)
    29c2:	00 
    29c3:	c7 04 24 bb 31 00 00 	movl   $0x31bb,(%esp)
    29ca:	e8 81 03 00 00       	call   2d50 <exec>
    29cf:	85 c0                	test   %eax,%eax
    29d1:	78 02                	js     29d5 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
    29d3:	c9                   	leave  
    29d4:	c3                   	ret    
void
exectest(void)
{
  printf(stdout, "exec test\n");
  if(exec("echo", echo_args) < 0) {
    printf(stdout, "exec echo failed\n");
    29d5:	a1 28 44 00 00       	mov    0x4428,%eax
    29da:	c7 44 24 04 4d 3e 00 	movl   $0x3e4d,0x4(%esp)
    29e1:	00 
    29e2:	89 04 24             	mov    %eax,(%esp)
    29e5:	e8 b6 04 00 00       	call   2ea0 <printf>
    exit();
    29ea:	e8 29 03 00 00       	call   2d18 <exit>
    29ef:	90                   	nop

000029f0 <main>:
  printf(1, "fork test OK\n");
}

int
main(int argc, char *argv[])
{
    29f0:	55                   	push   %ebp
    29f1:	89 e5                	mov    %esp,%ebp
    29f3:	83 e4 f0             	and    $0xfffffff0,%esp
    29f6:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    29f9:	c7 44 24 04 5f 3e 00 	movl   $0x3e5f,0x4(%esp)
    2a00:	00 
    2a01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a08:	e8 93 04 00 00       	call   2ea0 <printf>

  if(open("usertests.ran", 0) >= 0){
    2a0d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a14:	00 
    2a15:	c7 04 24 73 3e 00 00 	movl   $0x3e73,(%esp)
    2a1c:	e8 37 03 00 00       	call   2d58 <open>
    2a21:	85 c0                	test   %eax,%eax
    2a23:	78 1b                	js     2a40 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    2a25:	c7 44 24 04 c4 43 00 	movl   $0x43c4,0x4(%esp)
    2a2c:	00 
    2a2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a34:	e8 67 04 00 00       	call   2ea0 <printf>
    exit();
    2a39:	e8 da 02 00 00       	call   2d18 <exit>
    2a3e:	66 90                	xchg   %ax,%ax
  }
  close(open("usertests.ran", O_CREATE));
    2a40:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a47:	00 
    2a48:	c7 04 24 73 3e 00 00 	movl   $0x3e73,(%esp)
    2a4f:	e8 04 03 00 00       	call   2d58 <open>
    2a54:	89 04 24             	mov    %eax,(%esp)
    2a57:	e8 e4 02 00 00       	call   2d40 <close>

  opentest();
    2a5c:	e8 9f d5 ff ff       	call   0 <opentest>
  writetest();
    2a61:	e8 7a f9 ff ff       	call   23e0 <writetest>
  writetest1();
    2a66:	e8 85 f7 ff ff       	call   21f0 <writetest1>
    2a6b:	90                   	nop
    2a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  createtest();
    2a70:	e8 2b e0 ff ff       	call   aa0 <createtest>

  mem();
    2a75:	e8 76 fb ff ff       	call   25f0 <mem>
  pipe1();
    2a7a:	e8 11 fc ff ff       	call   2690 <pipe1>
    2a7f:	90                   	nop
  preempt();
    2a80:	e8 bb fd ff ff       	call   2840 <preempt>
  exitwait();
    2a85:	e8 e6 d6 ff ff       	call   170 <exitwait>

  rmdot();
    2a8a:	e8 f1 d9 ff ff       	call   480 <rmdot>
    2a8f:	90                   	nop
  fourteen();
    2a90:	e8 6b d7 ff ff       	call   200 <fourteen>
  bigfile();
    2a95:	e8 f6 e2 ff ff       	call   d90 <bigfile>
  subdir();
    2a9a:	e8 f1 e4 ff ff       	call   f90 <subdir>
    2a9f:	90                   	nop
  concreate();
    2aa0:	e8 7b ec ff ff       	call   1720 <concreate>
  linktest();
    2aa5:	e8 36 ef ff ff       	call   19e0 <linktest>
  unlinkread();
    2aaa:	e8 91 f1 ff ff       	call   1c40 <unlinkread>
    2aaf:	90                   	nop
  createdelete();
    2ab0:	e8 ab dc ff ff       	call   760 <createdelete>
  twofiles();
    2ab5:	e8 56 f3 ff ff       	call   1e10 <twofiles>
  sharedfd();
    2aba:	e8 71 f5 ff ff       	call   2030 <sharedfd>
    2abf:	90                   	nop
  dirfile();
    2ac0:	e8 8b e0 ff ff       	call   b50 <dirfile>
  iref();
    2ac5:	e8 96 d8 ff ff       	call   360 <iref>
  forktest();
    2aca:	e8 d1 d5 ff ff       	call   a0 <forktest>
    2acf:	90                   	nop
  bigdir(); // slow
    2ad0:	e8 3b db ff ff       	call   610 <bigdir>

  exectest();
    2ad5:	e8 c6 fe ff ff       	call   29a0 <exectest>

  exit();
    2ada:	e8 39 02 00 00       	call   2d18 <exit>
    2adf:	90                   	nop

00002ae0 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
    2ae0:	55                   	push   %ebp
    2ae1:	31 d2                	xor    %edx,%edx
    2ae3:	89 e5                	mov    %esp,%ebp
    2ae5:	8b 45 08             	mov    0x8(%ebp),%eax
    2ae8:	53                   	push   %ebx
    2ae9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    2aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    2af0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
    2af4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    2af7:	83 c2 01             	add    $0x1,%edx
    2afa:	84 c9                	test   %cl,%cl
    2afc:	75 f2                	jne    2af0 <strcpy+0x10>
    ;
  return os;
}
    2afe:	5b                   	pop    %ebx
    2aff:	5d                   	pop    %ebp
    2b00:	c3                   	ret    
    2b01:	eb 0d                	jmp    2b10 <strcmp>
    2b03:	90                   	nop
    2b04:	90                   	nop
    2b05:	90                   	nop
    2b06:	90                   	nop
    2b07:	90                   	nop
    2b08:	90                   	nop
    2b09:	90                   	nop
    2b0a:	90                   	nop
    2b0b:	90                   	nop
    2b0c:	90                   	nop
    2b0d:	90                   	nop
    2b0e:	90                   	nop
    2b0f:	90                   	nop

00002b10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    2b10:	55                   	push   %ebp
    2b11:	89 e5                	mov    %esp,%ebp
    2b13:	53                   	push   %ebx
    2b14:	8b 4d 08             	mov    0x8(%ebp),%ecx
    2b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    2b1a:	0f b6 01             	movzbl (%ecx),%eax
    2b1d:	84 c0                	test   %al,%al
    2b1f:	75 14                	jne    2b35 <strcmp+0x25>
    2b21:	eb 25                	jmp    2b48 <strcmp+0x38>
    2b23:	90                   	nop
    2b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
    2b28:	83 c1 01             	add    $0x1,%ecx
    2b2b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2b2e:	0f b6 01             	movzbl (%ecx),%eax
    2b31:	84 c0                	test   %al,%al
    2b33:	74 13                	je     2b48 <strcmp+0x38>
    2b35:	0f b6 1a             	movzbl (%edx),%ebx
    2b38:	38 d8                	cmp    %bl,%al
    2b3a:	74 ec                	je     2b28 <strcmp+0x18>
    2b3c:	0f b6 db             	movzbl %bl,%ebx
    2b3f:	0f b6 c0             	movzbl %al,%eax
    2b42:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2b44:	5b                   	pop    %ebx
    2b45:	5d                   	pop    %ebp
    2b46:	c3                   	ret    
    2b47:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    2b48:	0f b6 1a             	movzbl (%edx),%ebx
    2b4b:	31 c0                	xor    %eax,%eax
    2b4d:	0f b6 db             	movzbl %bl,%ebx
    2b50:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
    2b52:	5b                   	pop    %ebx
    2b53:	5d                   	pop    %ebp
    2b54:	c3                   	ret    
    2b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002b60 <strlen>:

uint
strlen(char *s)
{
    2b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
    2b61:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    2b63:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
    2b65:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    2b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    2b6a:	80 39 00             	cmpb   $0x0,(%ecx)
    2b6d:	74 0c                	je     2b7b <strlen+0x1b>
    2b6f:	90                   	nop
    2b70:	83 c2 01             	add    $0x1,%edx
    2b73:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    2b77:	89 d0                	mov    %edx,%eax
    2b79:	75 f5                	jne    2b70 <strlen+0x10>
    ;
  return n;
}
    2b7b:	5d                   	pop    %ebp
    2b7c:	c3                   	ret    
    2b7d:	8d 76 00             	lea    0x0(%esi),%esi

00002b80 <memset>:

void*
memset(void *dst, int c, uint n)
{
    2b80:	55                   	push   %ebp
    2b81:	89 e5                	mov    %esp,%ebp
    2b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
    2b86:	53                   	push   %ebx
    2b87:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
    2b8a:	85 c9                	test   %ecx,%ecx
    2b8c:	74 14                	je     2ba2 <memset+0x22>
    2b8e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
    2b92:	31 d2                	xor    %edx,%edx
    2b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
    2b98:	88 1c 10             	mov    %bl,(%eax,%edx,1)
    2b9b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
    2b9e:	39 ca                	cmp    %ecx,%edx
    2ba0:	75 f6                	jne    2b98 <memset+0x18>
    *d++ = c;
  return dst;
}
    2ba2:	5b                   	pop    %ebx
    2ba3:	5d                   	pop    %ebp
    2ba4:	c3                   	ret    
    2ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002bb0 <strchr>:

char*
strchr(const char *s, char c)
{
    2bb0:	55                   	push   %ebp
    2bb1:	89 e5                	mov    %esp,%ebp
    2bb3:	8b 45 08             	mov    0x8(%ebp),%eax
    2bb6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    2bba:	0f b6 10             	movzbl (%eax),%edx
    2bbd:	84 d2                	test   %dl,%dl
    2bbf:	75 11                	jne    2bd2 <strchr+0x22>
    2bc1:	eb 15                	jmp    2bd8 <strchr+0x28>
    2bc3:	90                   	nop
    2bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2bc8:	83 c0 01             	add    $0x1,%eax
    2bcb:	0f b6 10             	movzbl (%eax),%edx
    2bce:	84 d2                	test   %dl,%dl
    2bd0:	74 06                	je     2bd8 <strchr+0x28>
    if(*s == c)
    2bd2:	38 ca                	cmp    %cl,%dl
    2bd4:	75 f2                	jne    2bc8 <strchr+0x18>
      return (char*) s;
  return 0;
}
    2bd6:	5d                   	pop    %ebp
    2bd7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    2bd8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
    2bda:	5d                   	pop    %ebp
    2bdb:	90                   	nop
    2bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2be0:	c3                   	ret    
    2be1:	eb 0d                	jmp    2bf0 <atoi>
    2be3:	90                   	nop
    2be4:	90                   	nop
    2be5:	90                   	nop
    2be6:	90                   	nop
    2be7:	90                   	nop
    2be8:	90                   	nop
    2be9:	90                   	nop
    2bea:	90                   	nop
    2beb:	90                   	nop
    2bec:	90                   	nop
    2bed:	90                   	nop
    2bee:	90                   	nop
    2bef:	90                   	nop

00002bf0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    2bf0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2bf1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
    2bf3:	89 e5                	mov    %esp,%ebp
    2bf5:	8b 4d 08             	mov    0x8(%ebp),%ecx
    2bf8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2bf9:	0f b6 11             	movzbl (%ecx),%edx
    2bfc:	8d 5a d0             	lea    -0x30(%edx),%ebx
    2bff:	80 fb 09             	cmp    $0x9,%bl
    2c02:	77 1c                	ja     2c20 <atoi+0x30>
    2c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
    2c08:	0f be d2             	movsbl %dl,%edx
    2c0b:	83 c1 01             	add    $0x1,%ecx
    2c0e:	8d 04 80             	lea    (%eax,%eax,4),%eax
    2c11:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2c15:	0f b6 11             	movzbl (%ecx),%edx
    2c18:	8d 5a d0             	lea    -0x30(%edx),%ebx
    2c1b:	80 fb 09             	cmp    $0x9,%bl
    2c1e:	76 e8                	jbe    2c08 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    2c20:	5b                   	pop    %ebx
    2c21:	5d                   	pop    %ebp
    2c22:	c3                   	ret    
    2c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    2c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002c30 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    2c30:	55                   	push   %ebp
    2c31:	89 e5                	mov    %esp,%ebp
    2c33:	56                   	push   %esi
    2c34:	8b 45 08             	mov    0x8(%ebp),%eax
    2c37:	53                   	push   %ebx
    2c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
    2c3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2c3e:	85 db                	test   %ebx,%ebx
    2c40:	7e 14                	jle    2c56 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
    2c42:	31 d2                	xor    %edx,%edx
    2c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
    2c48:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    2c4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    2c4f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2c52:	39 da                	cmp    %ebx,%edx
    2c54:	75 f2                	jne    2c48 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    2c56:	5b                   	pop    %ebx
    2c57:	5e                   	pop    %esi
    2c58:	5d                   	pop    %ebp
    2c59:	c3                   	ret    
    2c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00002c60 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2c60:	55                   	push   %ebp
    2c61:	89 e5                	mov    %esp,%ebp
    2c63:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2c66:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    2c69:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    2c6c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    2c6f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2c74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c7b:	00 
    2c7c:	89 04 24             	mov    %eax,(%esp)
    2c7f:	e8 d4 00 00 00       	call   2d58 <open>
  if(fd < 0)
    2c84:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2c86:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    2c88:	78 19                	js     2ca3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    2c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
    2c8d:	89 1c 24             	mov    %ebx,(%esp)
    2c90:	89 44 24 04          	mov    %eax,0x4(%esp)
    2c94:	e8 d7 00 00 00       	call   2d70 <fstat>
  close(fd);
    2c99:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    2c9c:	89 c6                	mov    %eax,%esi
  close(fd);
    2c9e:	e8 9d 00 00 00       	call   2d40 <close>
  return r;
}
    2ca3:	89 f0                	mov    %esi,%eax
    2ca5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    2ca8:	8b 75 fc             	mov    -0x4(%ebp),%esi
    2cab:	89 ec                	mov    %ebp,%esp
    2cad:	5d                   	pop    %ebp
    2cae:	c3                   	ret    
    2caf:	90                   	nop

00002cb0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    2cb0:	55                   	push   %ebp
    2cb1:	89 e5                	mov    %esp,%ebp
    2cb3:	57                   	push   %edi
    2cb4:	56                   	push   %esi
    2cb5:	31 f6                	xor    %esi,%esi
    2cb7:	53                   	push   %ebx
    2cb8:	83 ec 2c             	sub    $0x2c,%esp
    2cbb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2cbe:	eb 06                	jmp    2cc6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    2cc0:	3c 0a                	cmp    $0xa,%al
    2cc2:	74 39                	je     2cfd <gets+0x4d>
    2cc4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2cc6:	8d 5e 01             	lea    0x1(%esi),%ebx
    2cc9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    2ccc:	7d 31                	jge    2cff <gets+0x4f>
    cc = read(0, &c, 1);
    2cce:	8d 45 e7             	lea    -0x19(%ebp),%eax
    2cd1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2cd8:	00 
    2cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
    2cdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ce4:	e8 47 00 00 00       	call   2d30 <read>
    if(cc < 1)
    2ce9:	85 c0                	test   %eax,%eax
    2ceb:	7e 12                	jle    2cff <gets+0x4f>
      break;
    buf[i++] = c;
    2ced:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    2cf1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    2cf5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    2cf9:	3c 0d                	cmp    $0xd,%al
    2cfb:	75 c3                	jne    2cc0 <gets+0x10>
    2cfd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    2cff:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    2d03:	89 f8                	mov    %edi,%eax
    2d05:	83 c4 2c             	add    $0x2c,%esp
    2d08:	5b                   	pop    %ebx
    2d09:	5e                   	pop    %esi
    2d0a:	5f                   	pop    %edi
    2d0b:	5d                   	pop    %ebp
    2d0c:	c3                   	ret    
    2d0d:	90                   	nop
    2d0e:	90                   	nop
    2d0f:	90                   	nop

00002d10 <fork>:
    2d10:	b8 01 00 00 00       	mov    $0x1,%eax
    2d15:	cd 30                	int    $0x30
    2d17:	c3                   	ret    

00002d18 <exit>:
    2d18:	b8 02 00 00 00       	mov    $0x2,%eax
    2d1d:	cd 30                	int    $0x30
    2d1f:	c3                   	ret    

00002d20 <wait>:
    2d20:	b8 03 00 00 00       	mov    $0x3,%eax
    2d25:	cd 30                	int    $0x30
    2d27:	c3                   	ret    

00002d28 <pipe>:
    2d28:	b8 04 00 00 00       	mov    $0x4,%eax
    2d2d:	cd 30                	int    $0x30
    2d2f:	c3                   	ret    

00002d30 <read>:
    2d30:	b8 06 00 00 00       	mov    $0x6,%eax
    2d35:	cd 30                	int    $0x30
    2d37:	c3                   	ret    

00002d38 <write>:
    2d38:	b8 05 00 00 00       	mov    $0x5,%eax
    2d3d:	cd 30                	int    $0x30
    2d3f:	c3                   	ret    

00002d40 <close>:
    2d40:	b8 07 00 00 00       	mov    $0x7,%eax
    2d45:	cd 30                	int    $0x30
    2d47:	c3                   	ret    

00002d48 <kill>:
    2d48:	b8 08 00 00 00       	mov    $0x8,%eax
    2d4d:	cd 30                	int    $0x30
    2d4f:	c3                   	ret    

00002d50 <exec>:
    2d50:	b8 09 00 00 00       	mov    $0x9,%eax
    2d55:	cd 30                	int    $0x30
    2d57:	c3                   	ret    

00002d58 <open>:
    2d58:	b8 0a 00 00 00       	mov    $0xa,%eax
    2d5d:	cd 30                	int    $0x30
    2d5f:	c3                   	ret    

00002d60 <mknod>:
    2d60:	b8 0b 00 00 00       	mov    $0xb,%eax
    2d65:	cd 30                	int    $0x30
    2d67:	c3                   	ret    

00002d68 <unlink>:
    2d68:	b8 0c 00 00 00       	mov    $0xc,%eax
    2d6d:	cd 30                	int    $0x30
    2d6f:	c3                   	ret    

00002d70 <fstat>:
    2d70:	b8 0d 00 00 00       	mov    $0xd,%eax
    2d75:	cd 30                	int    $0x30
    2d77:	c3                   	ret    

00002d78 <link>:
    2d78:	b8 0e 00 00 00       	mov    $0xe,%eax
    2d7d:	cd 30                	int    $0x30
    2d7f:	c3                   	ret    

00002d80 <mkdir>:
    2d80:	b8 0f 00 00 00       	mov    $0xf,%eax
    2d85:	cd 30                	int    $0x30
    2d87:	c3                   	ret    

00002d88 <chdir>:
    2d88:	b8 10 00 00 00       	mov    $0x10,%eax
    2d8d:	cd 30                	int    $0x30
    2d8f:	c3                   	ret    

00002d90 <dup>:
    2d90:	b8 11 00 00 00       	mov    $0x11,%eax
    2d95:	cd 30                	int    $0x30
    2d97:	c3                   	ret    

00002d98 <getpid>:
    2d98:	b8 12 00 00 00       	mov    $0x12,%eax
    2d9d:	cd 30                	int    $0x30
    2d9f:	c3                   	ret    

00002da0 <sbrk>:
    2da0:	b8 13 00 00 00       	mov    $0x13,%eax
    2da5:	cd 30                	int    $0x30
    2da7:	c3                   	ret    

00002da8 <sleep>:
    2da8:	b8 14 00 00 00       	mov    $0x14,%eax
    2dad:	cd 30                	int    $0x30
    2daf:	c3                   	ret    

00002db0 <tick>:
    2db0:	b8 15 00 00 00       	mov    $0x15,%eax
    2db5:	cd 30                	int    $0x30
    2db7:	c3                   	ret    

00002db8 <fork_tickets>:
    2db8:	b8 16 00 00 00       	mov    $0x16,%eax
    2dbd:	cd 30                	int    $0x30
    2dbf:	c3                   	ret    

00002dc0 <fork_thread>:
    2dc0:	b8 19 00 00 00       	mov    $0x19,%eax
    2dc5:	cd 30                	int    $0x30
    2dc7:	c3                   	ret    

00002dc8 <wait_thread>:
    2dc8:	b8 1a 00 00 00       	mov    $0x1a,%eax
    2dcd:	cd 30                	int    $0x30
    2dcf:	c3                   	ret    

00002dd0 <sleep_lock>:
    2dd0:	b8 17 00 00 00       	mov    $0x17,%eax
    2dd5:	cd 30                	int    $0x30
    2dd7:	c3                   	ret    

00002dd8 <wake_lock>:
    2dd8:	b8 18 00 00 00       	mov    $0x18,%eax
    2ddd:	cd 30                	int    $0x30
    2ddf:	c3                   	ret    

00002de0 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
    2de0:	55                   	push   %ebp
    2de1:	89 e5                	mov    %esp,%ebp
    2de3:	83 ec 28             	sub    $0x28,%esp
    2de6:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    2de9:	8d 55 f4             	lea    -0xc(%ebp),%edx
    2dec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2df3:	00 
    2df4:	89 54 24 04          	mov    %edx,0x4(%esp)
    2df8:	89 04 24             	mov    %eax,(%esp)
    2dfb:	e8 38 ff ff ff       	call   2d38 <write>
}
    2e00:	c9                   	leave  
    2e01:	c3                   	ret    
    2e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002e10 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    2e10:	55                   	push   %ebp
    2e11:	89 e5                	mov    %esp,%ebp
    2e13:	57                   	push   %edi
    2e14:	89 c7                	mov    %eax,%edi
    2e16:	56                   	push   %esi
    2e17:	89 ce                	mov    %ecx,%esi
    2e19:	53                   	push   %ebx
    2e1a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2e1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    2e20:	85 c9                	test   %ecx,%ecx
    2e22:	74 04                	je     2e28 <printint+0x18>
    2e24:	85 d2                	test   %edx,%edx
    2e26:	78 5d                	js     2e85 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    2e28:	89 d0                	mov    %edx,%eax
    2e2a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    2e31:	31 c9                	xor    %ecx,%ecx
    2e33:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    2e36:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    2e38:	31 d2                	xor    %edx,%edx
    2e3a:	f7 f6                	div    %esi
    2e3c:	0f b6 92 f7 43 00 00 	movzbl 0x43f7(%edx),%edx
    2e43:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    2e46:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    2e49:	85 c0                	test   %eax,%eax
    2e4b:	75 eb                	jne    2e38 <printint+0x28>
  if(neg)
    2e4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2e50:	85 c0                	test   %eax,%eax
    2e52:	74 08                	je     2e5c <printint+0x4c>
    buf[i++] = '-';
    2e54:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
    2e59:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    2e5c:	8d 71 ff             	lea    -0x1(%ecx),%esi
    2e5f:	01 f3                	add    %esi,%ebx
    2e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
    2e68:	0f be 13             	movsbl (%ebx),%edx
    2e6b:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2e6d:	83 ee 01             	sub    $0x1,%esi
    2e70:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
    2e73:	e8 68 ff ff ff       	call   2de0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    2e78:	83 fe ff             	cmp    $0xffffffff,%esi
    2e7b:	75 eb                	jne    2e68 <printint+0x58>
    putc(fd, buf[i]);
}
    2e7d:	83 c4 2c             	add    $0x2c,%esp
    2e80:	5b                   	pop    %ebx
    2e81:	5e                   	pop    %esi
    2e82:	5f                   	pop    %edi
    2e83:	5d                   	pop    %ebp
    2e84:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    2e85:	89 d0                	mov    %edx,%eax
    2e87:	f7 d8                	neg    %eax
    2e89:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    2e90:	eb 9f                	jmp    2e31 <printint+0x21>
    2e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002ea0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2ea0:	55                   	push   %ebp
    2ea1:	89 e5                	mov    %esp,%ebp
    2ea3:	57                   	push   %edi
    2ea4:	56                   	push   %esi
    2ea5:	53                   	push   %ebx
    2ea6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2eac:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2eaf:	0f b6 08             	movzbl (%eax),%ecx
    2eb2:	84 c9                	test   %cl,%cl
    2eb4:	0f 84 96 00 00 00    	je     2f50 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    2eba:	8d 55 10             	lea    0x10(%ebp),%edx
    2ebd:	31 f6                	xor    %esi,%esi
    2ebf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    2ec2:	31 db                	xor    %ebx,%ebx
    2ec4:	eb 1a                	jmp    2ee0 <printf+0x40>
    2ec6:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    2ec8:	83 f9 25             	cmp    $0x25,%ecx
    2ecb:	0f 85 87 00 00 00    	jne    2f58 <printf+0xb8>
    2ed1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2ed5:	83 c3 01             	add    $0x1,%ebx
    2ed8:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
    2edc:	84 c9                	test   %cl,%cl
    2ede:	74 70                	je     2f50 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
    2ee0:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    2ee2:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
    2ee5:	74 e1                	je     2ec8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    2ee7:	83 fe 25             	cmp    $0x25,%esi
    2eea:	75 e9                	jne    2ed5 <printf+0x35>
      if(c == 'd'){
    2eec:	83 f9 64             	cmp    $0x64,%ecx
    2eef:	90                   	nop
    2ef0:	0f 84 fa 00 00 00    	je     2ff0 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    2ef6:	83 f9 70             	cmp    $0x70,%ecx
    2ef9:	74 75                	je     2f70 <printf+0xd0>
    2efb:	83 f9 78             	cmp    $0x78,%ecx
    2efe:	66 90                	xchg   %ax,%ax
    2f00:	74 6e                	je     2f70 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    2f02:	83 f9 73             	cmp    $0x73,%ecx
    2f05:	0f 84 8d 00 00 00    	je     2f98 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    2f0b:	83 f9 63             	cmp    $0x63,%ecx
    2f0e:	66 90                	xchg   %ax,%ax
    2f10:	0f 84 fe 00 00 00    	je     3014 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    2f16:	83 f9 25             	cmp    $0x25,%ecx
    2f19:	0f 84 b9 00 00 00    	je     2fd8 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2f1f:	ba 25 00 00 00       	mov    $0x25,%edx
    2f24:	89 f8                	mov    %edi,%eax
    2f26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2f29:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    2f2c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2f2e:	e8 ad fe ff ff       	call   2de0 <putc>
        putc(fd, c);
    2f33:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    2f36:	89 f8                	mov    %edi,%eax
    2f38:	0f be d1             	movsbl %cl,%edx
    2f3b:	e8 a0 fe ff ff       	call   2de0 <putc>
    2f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    2f43:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
    2f47:	84 c9                	test   %cl,%cl
    2f49:	75 95                	jne    2ee0 <printf+0x40>
    2f4b:	90                   	nop
    2f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
    2f50:	83 c4 2c             	add    $0x2c,%esp
    2f53:	5b                   	pop    %ebx
    2f54:	5e                   	pop    %esi
    2f55:	5f                   	pop    %edi
    2f56:	5d                   	pop    %ebp
    2f57:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    2f58:	89 f8                	mov    %edi,%eax
    2f5a:	0f be d1             	movsbl %cl,%edx
    2f5d:	e8 7e fe ff ff       	call   2de0 <putc>
    2f62:	8b 45 0c             	mov    0xc(%ebp),%eax
    2f65:	e9 6b ff ff ff       	jmp    2ed5 <printf+0x35>
    2f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2f73:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    2f78:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    2f7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f81:	8b 10                	mov    (%eax),%edx
    2f83:	89 f8                	mov    %edi,%eax
    2f85:	e8 86 fe ff ff       	call   2e10 <printint>
    2f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    2f8d:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    2f91:	e9 3f ff ff ff       	jmp    2ed5 <printf+0x35>
    2f96:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
    2f98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    2f9b:	8b 32                	mov    (%edx),%esi
        ap++;
    2f9d:	83 c2 04             	add    $0x4,%edx
    2fa0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
    2fa3:	85 f6                	test   %esi,%esi
    2fa5:	0f 84 84 00 00 00    	je     302f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
    2fab:	0f b6 16             	movzbl (%esi),%edx
    2fae:	84 d2                	test   %dl,%dl
    2fb0:	74 1d                	je     2fcf <printf+0x12f>
    2fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
    2fb8:	0f be d2             	movsbl %dl,%edx
          s++;
    2fbb:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
    2fbe:	89 f8                	mov    %edi,%eax
    2fc0:	e8 1b fe ff ff       	call   2de0 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    2fc5:	0f b6 16             	movzbl (%esi),%edx
    2fc8:	84 d2                	test   %dl,%dl
    2fca:	75 ec                	jne    2fb8 <printf+0x118>
    2fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    2fcf:	31 f6                	xor    %esi,%esi
    2fd1:	e9 ff fe ff ff       	jmp    2ed5 <printf+0x35>
    2fd6:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
    2fd8:	89 f8                	mov    %edi,%eax
    2fda:	ba 25 00 00 00       	mov    $0x25,%edx
    2fdf:	e8 fc fd ff ff       	call   2de0 <putc>
    2fe4:	31 f6                	xor    %esi,%esi
    2fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
    2fe9:	e9 e7 fe ff ff       	jmp    2ed5 <printf+0x35>
    2fee:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    2ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2ff3:	b1 0a                	mov    $0xa,%cl
        ap++;
    2ff5:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    2ff8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fff:	8b 10                	mov    (%eax),%edx
    3001:	89 f8                	mov    %edi,%eax
    3003:	e8 08 fe ff ff       	call   2e10 <printint>
    3008:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    300b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    300f:	e9 c1 fe ff ff       	jmp    2ed5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
    3017:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    3019:	0f be 10             	movsbl (%eax),%edx
    301c:	89 f8                	mov    %edi,%eax
    301e:	e8 bd fd ff ff       	call   2de0 <putc>
    3023:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    3026:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    302a:	e9 a6 fe ff ff       	jmp    2ed5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
    302f:	be f0 43 00 00       	mov    $0x43f0,%esi
    3034:	e9 72 ff ff ff       	jmp    2fab <printf+0x10b>
    3039:	90                   	nop
    303a:	90                   	nop
    303b:	90                   	nop
    303c:	90                   	nop
    303d:	90                   	nop
    303e:	90                   	nop
    303f:	90                   	nop

00003040 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3040:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3041:	a1 48 44 00 00       	mov    0x4448,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    3046:	89 e5                	mov    %esp,%ebp
    3048:	57                   	push   %edi
    3049:	56                   	push   %esi
    304a:	53                   	push   %ebx
    304b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    304e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3051:	39 c8                	cmp    %ecx,%eax
    3053:	73 1d                	jae    3072 <free+0x32>
    3055:	8d 76 00             	lea    0x0(%esi),%esi
    3058:	8b 10                	mov    (%eax),%edx
    305a:	39 d1                	cmp    %edx,%ecx
    305c:	72 1a                	jb     3078 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    305e:	39 d0                	cmp    %edx,%eax
    3060:	72 08                	jb     306a <free+0x2a>
    3062:	39 c8                	cmp    %ecx,%eax
    3064:	72 12                	jb     3078 <free+0x38>
    3066:	39 d1                	cmp    %edx,%ecx
    3068:	72 0e                	jb     3078 <free+0x38>
    306a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    306c:	39 c8                	cmp    %ecx,%eax
    306e:	66 90                	xchg   %ax,%ax
    3070:	72 e6                	jb     3058 <free+0x18>
    3072:	8b 10                	mov    (%eax),%edx
    3074:	eb e8                	jmp    305e <free+0x1e>
    3076:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3078:	8b 71 04             	mov    0x4(%ecx),%esi
    307b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    307e:	39 d7                	cmp    %edx,%edi
    3080:	74 19                	je     309b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3082:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3085:	8b 50 04             	mov    0x4(%eax),%edx
    3088:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    308b:	39 ce                	cmp    %ecx,%esi
    308d:	74 21                	je     30b0 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    308f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3091:	a3 48 44 00 00       	mov    %eax,0x4448
}
    3096:	5b                   	pop    %ebx
    3097:	5e                   	pop    %esi
    3098:	5f                   	pop    %edi
    3099:	5d                   	pop    %ebp
    309a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    309b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
    309e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    30a0:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    30a3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    30a6:	8b 50 04             	mov    0x4(%eax),%edx
    30a9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    30ac:	39 ce                	cmp    %ecx,%esi
    30ae:	75 df                	jne    308f <free+0x4f>
    p->s.size += bp->s.size;
    30b0:	03 51 04             	add    0x4(%ecx),%edx
    30b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    30b6:	8b 53 f8             	mov    -0x8(%ebx),%edx
    30b9:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    30bb:	a3 48 44 00 00       	mov    %eax,0x4448
}
    30c0:	5b                   	pop    %ebx
    30c1:	5e                   	pop    %esi
    30c2:	5f                   	pop    %edi
    30c3:	5d                   	pop    %ebp
    30c4:	c3                   	ret    
    30c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    30c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000030d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    30d0:	55                   	push   %ebp
    30d1:	89 e5                	mov    %esp,%ebp
    30d3:	57                   	push   %edi
    30d4:	56                   	push   %esi
    30d5:	53                   	push   %ebx
    30d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    30d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    30dc:	8b 0d 48 44 00 00    	mov    0x4448,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    30e2:	83 c3 07             	add    $0x7,%ebx
    30e5:	c1 eb 03             	shr    $0x3,%ebx
    30e8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    30eb:	85 c9                	test   %ecx,%ecx
    30ed:	0f 84 93 00 00 00    	je     3186 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    30f3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    30f5:	8b 50 04             	mov    0x4(%eax),%edx
    30f8:	39 d3                	cmp    %edx,%ebx
    30fa:	76 1f                	jbe    311b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    30fc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    3103:	90                   	nop
    3104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
    3108:	3b 05 48 44 00 00    	cmp    0x4448,%eax
    310e:	74 30                	je     3140 <malloc+0x70>
    3110:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3112:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    3114:	8b 50 04             	mov    0x4(%eax),%edx
    3117:	39 d3                	cmp    %edx,%ebx
    3119:	77 ed                	ja     3108 <malloc+0x38>
      if(p->s.size == nunits)
    311b:	39 d3                	cmp    %edx,%ebx
    311d:	74 61                	je     3180 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    311f:	29 da                	sub    %ebx,%edx
    3121:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    3124:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    3127:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    312a:	89 0d 48 44 00 00    	mov    %ecx,0x4448
      return (void*) (p + 1);
    3130:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3133:	83 c4 1c             	add    $0x1c,%esp
    3136:	5b                   	pop    %ebx
    3137:	5e                   	pop    %esi
    3138:	5f                   	pop    %edi
    3139:	5d                   	pop    %ebp
    313a:	c3                   	ret    
    313b:	90                   	nop
    313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    3140:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    3146:	b8 00 80 00 00       	mov    $0x8000,%eax
    314b:	bf 00 10 00 00       	mov    $0x1000,%edi
    3150:	76 04                	jbe    3156 <malloc+0x86>
    3152:	89 f0                	mov    %esi,%eax
    3154:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
    3156:	89 04 24             	mov    %eax,(%esp)
    3159:	e8 42 fc ff ff       	call   2da0 <sbrk>
  if(p == (char*) -1)
    315e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3161:	74 18                	je     317b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3163:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    3166:	83 c0 08             	add    $0x8,%eax
    3169:	89 04 24             	mov    %eax,(%esp)
    316c:	e8 cf fe ff ff       	call   3040 <free>
  return freep;
    3171:	8b 0d 48 44 00 00    	mov    0x4448,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    3177:	85 c9                	test   %ecx,%ecx
    3179:	75 97                	jne    3112 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    317b:	31 c0                	xor    %eax,%eax
    317d:	eb b4                	jmp    3133 <malloc+0x63>
    317f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    3180:	8b 10                	mov    (%eax),%edx
    3182:	89 11                	mov    %edx,(%ecx)
    3184:	eb a4                	jmp    312a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3186:	c7 05 48 44 00 00 40 	movl   $0x4440,0x4448
    318d:	44 00 00 
    base.s.size = 0;
    3190:	b9 40 44 00 00       	mov    $0x4440,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    3195:	c7 05 40 44 00 00 40 	movl   $0x4440,0x4440
    319c:	44 00 00 
    base.s.size = 0;
    319f:	c7 05 44 44 00 00 00 	movl   $0x0,0x4444
    31a6:	00 00 00 
    31a9:	e9 45 ff ff ff       	jmp    30f3 <malloc+0x23>
