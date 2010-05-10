
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *sh_args[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 4e 08 00 00 	movl   $0x84e,(%esp)
  19:	e8 7a 03 00 00       	call   398 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	0f 88 bf 00 00 00    	js     e5 <main+0xe5>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2d:	e8 9e 03 00 00       	call   3d0 <dup>
  dup(0);  // stderr
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 92 03 00 00       	call   3d0 <dup>

  log_init();
  3e:	e8 e5 03 00 00       	call   428 <log_init>
  43:	90                   	nop
  44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	c7 44 24 04 56 08 00 	movl   $0x856,0x4(%esp)
  4f:	00 
  50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  57:	e8 74 04 00 00       	call   4d0 <printf>
    pid = fork();
  5c:	e8 ef 02 00 00       	call   350 <fork>
    if(pid < 0){
  61:	83 f8 00             	cmp    $0x0,%eax

  log_init();

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  64:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  66:	7c 30                	jl     98 <main+0x98>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  68:	74 4e                	je     b8 <main+0xb8>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exec("sh", sh_args);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 eb 02 00 00       	call   360 <wait>
  75:	85 c0                	test   %eax,%eax
  77:	78 cf                	js     48 <main+0x48>
  79:	39 c3                	cmp    %eax,%ebx
  7b:	74 cb                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  7d:	c7 44 24 04 95 08 00 	movl   $0x895,0x4(%esp)
  84:	00 
  85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8c:	e8 3f 04 00 00       	call   4d0 <printf>
  91:	eb d7                	jmp    6a <main+0x6a>
  93:	90                   	nop
  94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  98:	c7 44 24 04 69 08 00 	movl   $0x869,0x4(%esp)
  9f:	00 
  a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a7:	e8 24 04 00 00       	call   4d0 <printf>
      exit();
  ac:	e8 a7 02 00 00       	call   358 <exit>
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(pid == 0){
      exec("sh", sh_args);
  b8:	c7 44 24 04 b8 08 00 	movl   $0x8b8,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 7c 08 00 00 	movl   $0x87c,(%esp)
  c7:	e8 c4 02 00 00       	call   390 <exec>
      printf(1, "init: exec sh failed\n");
  cc:	c7 44 24 04 7f 08 00 	movl   $0x87f,0x4(%esp)
  d3:	00 
  d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  db:	e8 f0 03 00 00       	call   4d0 <printf>
      exit();
  e0:	e8 73 02 00 00       	call   358 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  ec:	00 
  ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 4e 08 00 00 	movl   $0x84e,(%esp)
  fc:	e8 9f 02 00 00       	call   3a0 <mknod>
    open("console", O_RDWR);
 101:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 108:	00 
 109:	c7 04 24 4e 08 00 00 	movl   $0x84e,(%esp)
 110:	e8 83 02 00 00       	call   398 <open>
 115:	e9 0c ff ff ff       	jmp    26 <main+0x26>
 11a:	90                   	nop
 11b:	90                   	nop
 11c:	90                   	nop
 11d:	90                   	nop
 11e:	90                   	nop
 11f:	90                   	nop

00000120 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 120:	55                   	push   %ebp
 121:	31 d2                	xor    %edx,%edx
 123:	89 e5                	mov    %esp,%ebp
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	53                   	push   %ebx
 129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 130:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 134:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 137:	83 c2 01             	add    $0x1,%edx
 13a:	84 c9                	test   %cl,%cl
 13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13e:	5b                   	pop    %ebx
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	eb 0d                	jmp    150 <strcmp>
 143:	90                   	nop
 144:	90                   	nop
 145:	90                   	nop
 146:	90                   	nop
 147:	90                   	nop
 148:	90                   	nop
 149:	90                   	nop
 14a:	90                   	nop
 14b:	90                   	nop
 14c:	90                   	nop
 14d:	90                   	nop
 14e:	90                   	nop
 14f:	90                   	nop

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 4d 08             	mov    0x8(%ebp),%ecx
 157:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15a:	0f b6 01             	movzbl (%ecx),%eax
 15d:	84 c0                	test   %al,%al
 15f:	75 14                	jne    175 <strcmp+0x25>
 161:	eb 25                	jmp    188 <strcmp+0x38>
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 168:	83 c1 01             	add    $0x1,%ecx
 16b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16e:	0f b6 01             	movzbl (%ecx),%eax
 171:	84 c0                	test   %al,%al
 173:	74 13                	je     188 <strcmp+0x38>
 175:	0f b6 1a             	movzbl (%edx),%ebx
 178:	38 d8                	cmp    %bl,%al
 17a:	74 ec                	je     168 <strcmp+0x18>
 17c:	0f b6 db             	movzbl %bl,%ebx
 17f:	0f b6 c0             	movzbl %al,%eax
 182:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 188:	0f b6 1a             	movzbl (%edx),%ebx
 18b:	31 c0                	xor    %eax,%eax
 18d:	0f b6 db             	movzbl %bl,%ebx
 190:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 192:	5b                   	pop    %ebx
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
 195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <strlen>:

uint
strlen(char *s)
{
 1a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1a1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1a5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1aa:	80 39 00             	cmpb   $0x0,(%ecx)
 1ad:	74 0c                	je     1bb <strlen+0x1b>
 1af:	90                   	nop
 1b0:	83 c2 01             	add    $0x1,%edx
 1b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1b7:	89 d0                	mov    %edx,%eax
 1b9:	75 f5                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1c6:	53                   	push   %ebx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ca:	85 c9                	test   %ecx,%ecx
 1cc:	74 14                	je     1e2 <memset+0x22>
 1ce:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 1d2:	31 d2                	xor    %edx,%edx
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 1d8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 1db:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 1de:	39 ca                	cmp    %ecx,%edx
 1e0:	75 f6                	jne    1d8 <memset+0x18>
    *d++ = c;
  return dst;
}
 1e2:	5b                   	pop    %ebx
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1fa:	0f b6 10             	movzbl (%eax),%edx
 1fd:	84 d2                	test   %dl,%dl
 1ff:	75 11                	jne    212 <strchr+0x22>
 201:	eb 15                	jmp    218 <strchr+0x28>
 203:	90                   	nop
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 06                	je     218 <strchr+0x28>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	75 f2                	jne    208 <strchr+0x18>
      return (char*) s;
  return 0;
}
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 21a:	5d                   	pop    %ebp
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	c3                   	ret    
 221:	eb 0d                	jmp    230 <atoi>
 223:	90                   	nop
 224:	90                   	nop
 225:	90                   	nop
 226:	90                   	nop
 227:	90                   	nop
 228:	90                   	nop
 229:	90                   	nop
 22a:	90                   	nop
 22b:	90                   	nop
 22c:	90                   	nop
 22d:	90                   	nop
 22e:	90                   	nop
 22f:	90                   	nop

00000230 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 230:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 231:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 233:	89 e5                	mov    %esp,%ebp
 235:	8b 4d 08             	mov    0x8(%ebp),%ecx
 238:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 239:	0f b6 11             	movzbl (%ecx),%edx
 23c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23f:	80 fb 09             	cmp    $0x9,%bl
 242:	77 1c                	ja     260 <atoi+0x30>
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 248:	0f be d2             	movsbl %dl,%edx
 24b:	83 c1 01             	add    $0x1,%ecx
 24e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 251:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 255:	0f b6 11             	movzbl (%ecx),%edx
 258:	8d 5a d0             	lea    -0x30(%edx),%ebx
 25b:	80 fb 09             	cmp    $0x9,%bl
 25e:	76 e8                	jbe    248 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	53                   	push   %ebx
 278:	8b 5d 10             	mov    0x10(%ebp),%ebx
 27b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 14                	jle    296 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 282:	31 d2                	xor    %edx,%edx
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 288:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 28c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 292:	39 da                	cmp    %ebx,%edx
 294:	75 f2                	jne    288 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    
 29a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002a0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2af:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2bb:	00 
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 d4 00 00 00       	call   398 <open>
  if(fd < 0)
 2c4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2c8:	78 19                	js     2e3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 1c 24             	mov    %ebx,(%esp)
 2d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d4:	e8 d7 00 00 00       	call   3b0 <fstat>
  close(fd);
 2d9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2dc:	89 c6                	mov    %eax,%esi
  close(fd);
 2de:	e8 9d 00 00 00       	call   380 <close>
  return r;
}
 2e3:	89 f0                	mov    %esi,%eax
 2e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2eb:	89 ec                	mov    %ebp,%esp
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
 2ef:	90                   	nop

000002f0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	31 f6                	xor    %esi,%esi
 2f7:	53                   	push   %ebx
 2f8:	83 ec 2c             	sub    $0x2c,%esp
 2fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fe:	eb 06                	jmp    306 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 300:	3c 0a                	cmp    $0xa,%al
 302:	74 39                	je     33d <gets+0x4d>
 304:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	8d 5e 01             	lea    0x1(%esi),%ebx
 309:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30c:	7d 31                	jge    33f <gets+0x4f>
    cc = read(0, &c, 1);
 30e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 311:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 318:	00 
 319:	89 44 24 04          	mov    %eax,0x4(%esp)
 31d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 324:	e8 47 00 00 00       	call   370 <read>
    if(cc < 1)
 329:	85 c0                	test   %eax,%eax
 32b:	7e 12                	jle    33f <gets+0x4f>
      break;
    buf[i++] = c;
 32d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 331:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 335:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 339:	3c 0d                	cmp    $0xd,%al
 33b:	75 c3                	jne    300 <gets+0x10>
 33d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 33f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 343:	89 f8                	mov    %edi,%eax
 345:	83 c4 2c             	add    $0x2c,%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <fork>:
 350:	b8 01 00 00 00       	mov    $0x1,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <exit>:
 358:	b8 02 00 00 00       	mov    $0x2,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <wait>:
 360:	b8 03 00 00 00       	mov    $0x3,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <pipe>:
 368:	b8 04 00 00 00       	mov    $0x4,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <read>:
 370:	b8 06 00 00 00       	mov    $0x6,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <write>:
 378:	b8 05 00 00 00       	mov    $0x5,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <close>:
 380:	b8 07 00 00 00       	mov    $0x7,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <kill>:
 388:	b8 08 00 00 00       	mov    $0x8,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <exec>:
 390:	b8 09 00 00 00       	mov    $0x9,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <open>:
 398:	b8 0a 00 00 00       	mov    $0xa,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <mknod>:
 3a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <unlink>:
 3a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <fstat>:
 3b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <link>:
 3b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <mkdir>:
 3c0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <chdir>:
 3c8:	b8 10 00 00 00       	mov    $0x10,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <dup>:
 3d0:	b8 11 00 00 00       	mov    $0x11,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <getpid>:
 3d8:	b8 12 00 00 00       	mov    $0x12,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <sbrk>:
 3e0:	b8 13 00 00 00       	mov    $0x13,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <sleep>:
 3e8:	b8 14 00 00 00       	mov    $0x14,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <tick>:
 3f0:	b8 15 00 00 00       	mov    $0x15,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <fork_tickets>:
 3f8:	b8 16 00 00 00       	mov    $0x16,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <fork_thread>:
 400:	b8 19 00 00 00       	mov    $0x19,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <wait_thread>:
 408:	b8 1a 00 00 00       	mov    $0x1a,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <sleep_lock>:
 410:	b8 17 00 00 00       	mov    $0x17,%eax
 415:	cd 30                	int    $0x30
 417:	c3                   	ret    

00000418 <wake_lock>:
 418:	b8 18 00 00 00       	mov    $0x18,%eax
 41d:	cd 30                	int    $0x30
 41f:	c3                   	ret    

00000420 <check>:
 420:	b8 1b 00 00 00       	mov    $0x1b,%eax
 425:	cd 30                	int    $0x30
 427:	c3                   	ret    

00000428 <log_init>:
 428:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42d:	cd 30                	int    $0x30
 42f:	c3                   	ret    

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	89 cf                	mov    %ecx,%edi
 436:	56                   	push   %esi
 437:	89 c6                	mov    %eax,%esi
 439:	53                   	push   %ebx
 43a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 440:	85 c9                	test   %ecx,%ecx
 442:	74 04                	je     448 <printint+0x18>
 444:	85 d2                	test   %edx,%edx
 446:	78 70                	js     4b8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 448:	89 d0                	mov    %edx,%eax
 44a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 451:	31 c9                	xor    %ecx,%ecx
 453:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 456:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 458:	31 d2                	xor    %edx,%edx
 45a:	f7 f7                	div    %edi
 45c:	0f b6 92 a5 08 00 00 	movzbl 0x8a5(%edx),%edx
 463:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 466:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 469:	85 c0                	test   %eax,%eax
 46b:	75 eb                	jne    458 <printint+0x28>
  if(neg)
 46d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 470:	85 c0                	test   %eax,%eax
 472:	74 08                	je     47c <printint+0x4c>
    buf[i++] = '-';
 474:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 479:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 47c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 47f:	01 fb                	add    %edi,%ebx
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 488:	0f b6 03             	movzbl (%ebx),%eax
 48b:	83 ef 01             	sub    $0x1,%edi
 48e:	83 eb 01             	sub    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 498:	00 
 499:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 49c:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	e8 cd fe ff ff       	call   378 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ab:	83 ff ff             	cmp    $0xffffffff,%edi
 4ae:	75 d8                	jne    488 <printint+0x58>
    putc(fd, buf[i]);
}
 4b0:	83 c4 4c             	add    $0x4c,%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	f7 d8                	neg    %eax
 4bc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4c3:	eb 8c                	jmp    451 <printint+0x21>
 4c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dc:	0f b6 10             	movzbl (%eax),%edx
 4df:	84 d2                	test   %dl,%dl
 4e1:	0f 84 c9 00 00 00    	je     5b0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4e7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4ea:	31 ff                	xor    %edi,%edi
 4ec:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 4ef:	31 db                	xor    %ebx,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 4f4:	eb 1e                	jmp    514 <printf+0x44>
 4f6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f8:	83 fa 25             	cmp    $0x25,%edx
 4fb:	0f 85 b7 00 00 00    	jne    5b8 <printf+0xe8>
 501:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 505:	83 c3 01             	add    $0x1,%ebx
 508:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 50c:	84 d2                	test   %dl,%dl
 50e:	0f 84 9c 00 00 00    	je     5b0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 514:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 516:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 519:	74 dd                	je     4f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 51b:	83 ff 25             	cmp    $0x25,%edi
 51e:	75 e5                	jne    505 <printf+0x35>
      if(c == 'd'){
 520:	83 fa 64             	cmp    $0x64,%edx
 523:	0f 84 57 01 00 00    	je     680 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 529:	83 fa 70             	cmp    $0x70,%edx
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 530:	0f 84 aa 00 00 00    	je     5e0 <printf+0x110>
 536:	83 fa 78             	cmp    $0x78,%edx
 539:	0f 84 a1 00 00 00    	je     5e0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 53f:	83 fa 73             	cmp    $0x73,%edx
 542:	0f 84 c0 00 00 00    	je     608 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 548:	83 fa 63             	cmp    $0x63,%edx
 54b:	90                   	nop
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 550:	0f 84 52 01 00 00    	je     6a8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 556:	83 fa 25             	cmp    $0x25,%edx
 559:	0f 84 f9 00 00 00    	je     658 <printf+0x188>
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 55f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 562:	83 c3 01             	add    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 565:	31 ff                	xor    %edi,%edi
 567:	89 55 cc             	mov    %edx,-0x34(%ebp)
 56a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 575:	00 
 576:	89 0c 24             	mov    %ecx,(%esp)
 579:	89 74 24 04          	mov    %esi,0x4(%esp)
 57d:	e8 f6 fd ff ff       	call   378 <write>
 582:	8b 55 cc             	mov    -0x34(%ebp),%edx
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58f:	00 
 590:	89 74 24 04          	mov    %esi,0x4(%esp)
 594:	88 55 e7             	mov    %dl,-0x19(%ebp)
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 d9 fd ff ff       	call   378 <write>
 59f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 5a6:	84 d2                	test   %dl,%dl
 5a8:	0f 85 66 ff ff ff    	jne    514 <printf+0x44>
 5ae:	66 90                	xchg   %ax,%ax
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
 5b0:	83 c4 3c             	add    $0x3c,%esp
 5b3:	5b                   	pop    %ebx
 5b4:	5e                   	pop    %esi
 5b5:	5f                   	pop    %edi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5bb:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c5:	00 
 5c6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 a6 fd ff ff       	call   378 <write>
 5d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d5:	e9 2b ff ff ff       	jmp    505 <printf+0x35>
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5e8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	e8 35 fe ff ff       	call   430 <printint>
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5fe:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 602:	e9 fe fe ff ff       	jmp    505 <printf+0x35>
 607:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 608:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 60b:	8b 3a                	mov    (%edx),%edi
        ap++;
 60d:	83 c2 04             	add    $0x4,%edx
 610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 613:	85 ff                	test   %edi,%edi
 615:	0f 84 ba 00 00 00    	je     6d5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 61b:	0f b6 17             	movzbl (%edi),%edx
 61e:	84 d2                	test   %dl,%dl
 620:	74 2d                	je     64f <printf+0x17f>
 622:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 625:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 628:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 62b:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 635:	00 
 636:	89 74 24 04          	mov    %esi,0x4(%esp)
 63a:	89 1c 24             	mov    %ebx,(%esp)
 63d:	e8 36 fd ff ff       	call   378 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 642:	0f b6 17             	movzbl (%edi),%edx
 645:	84 d2                	test   %dl,%dl
 647:	75 df                	jne    628 <printf+0x158>
 649:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 64c:	8b 45 0c             	mov    0xc(%ebp),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64f:	31 ff                	xor    %edi,%edi
 651:	e9 af fe ff ff       	jmp    505 <printf+0x35>
 656:	66 90                	xchg   %ax,%ax
 658:	8b 55 08             	mov    0x8(%ebp),%edx
 65b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 65d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 661:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 668:	00 
 669:	89 74 24 04          	mov    %esi,0x4(%esp)
 66d:	89 14 24             	mov    %edx,(%esp)
 670:	e8 03 fd ff ff       	call   378 <write>
 675:	8b 45 0c             	mov    0xc(%ebp),%eax
 678:	e9 88 fe ff ff       	jmp    505 <printf+0x35>
 67d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 680:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 683:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 688:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 68b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 692:	8b 10                	mov    (%eax),%edx
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	e8 94 fd ff ff       	call   430 <printint>
 69c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 69f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6a3:	e9 5d fe ff ff       	jmp    505 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 6ab:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ad:	8b 01                	mov    (%ecx),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6af:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b6:	00 
 6b7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bb:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 af fc ff ff       	call   378 <write>
 6c9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6cc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6d0:	e9 30 fe ff ff       	jmp    505 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 6d5:	bf 9e 08 00 00       	mov    $0x89e,%edi
 6da:	e9 3c ff ff ff       	jmp    61b <printf+0x14b>
 6df:	90                   	nop

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 c8 08 00 00       	mov    0x8c8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 6ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	39 c8                	cmp    %ecx,%eax
 6f3:	73 1d                	jae    712 <free+0x32>
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	39 d1                	cmp    %edx,%ecx
 6fc:	72 1a                	jb     718 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	39 d0                	cmp    %edx,%eax
 700:	72 08                	jb     70a <free+0x2a>
 702:	39 c8                	cmp    %ecx,%eax
 704:	72 12                	jb     718 <free+0x38>
 706:	39 d1                	cmp    %edx,%ecx
 708:	72 0e                	jb     718 <free+0x38>
 70a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	39 c8                	cmp    %ecx,%eax
 70e:	66 90                	xchg   %ax,%ax
 710:	72 e6                	jb     6f8 <free+0x18>
 712:	8b 10                	mov    (%eax),%edx
 714:	eb e8                	jmp    6fe <free+0x1e>
 716:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 71 04             	mov    0x4(%ecx),%esi
 71b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 71e:	39 d7                	cmp    %edx,%edi
 720:	74 19                	je     73b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 722:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 72b:	39 ce                	cmp    %ecx,%esi
 72d:	74 21                	je     750 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 72f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 731:	a3 c8 08 00 00       	mov    %eax,0x8c8
}
 736:	5b                   	pop    %ebx
 737:	5e                   	pop    %esi
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 740:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 743:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 746:	8b 50 04             	mov    0x4(%eax),%edx
 749:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 74c:	39 ce                	cmp    %ecx,%esi
 74e:	75 df                	jne    72f <free+0x4f>
    p->s.size += bp->s.size;
 750:	03 51 04             	add    0x4(%ecx),%edx
 753:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 756:	8b 53 f8             	mov    -0x8(%ebx),%edx
 759:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 75b:	a3 c8 08 00 00       	mov    %eax,0x8c8
}
 760:	5b                   	pop    %ebx
 761:	5e                   	pop    %esi
 762:	5f                   	pop    %edi
 763:	5d                   	pop    %ebp
 764:	c3                   	ret    
 765:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 77c:	8b 0d c8 08 00 00    	mov    0x8c8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	83 c3 07             	add    $0x7,%ebx
 785:	c1 eb 03             	shr    $0x3,%ebx
 788:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 78b:	85 c9                	test   %ecx,%ecx
 78d:	0f 84 93 00 00 00    	je     826 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	39 d3                	cmp    %edx,%ebx
 79a:	76 1f                	jbe    7bb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 79c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7a3:	90                   	nop
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 7a8:	3b 05 c8 08 00 00    	cmp    0x8c8,%eax
 7ae:	74 30                	je     7e0 <malloc+0x70>
 7b0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 7b4:	8b 50 04             	mov    0x4(%eax),%edx
 7b7:	39 d3                	cmp    %edx,%ebx
 7b9:	77 ed                	ja     7a8 <malloc+0x38>
      if(p->s.size == nunits)
 7bb:	39 d3                	cmp    %edx,%ebx
 7bd:	74 61                	je     820 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7bf:	29 da                	sub    %ebx,%edx
 7c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7c7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7ca:	89 0d c8 08 00 00    	mov    %ecx,0x8c8
      return (void*) (p + 1);
 7d0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d3:	83 c4 1c             	add    $0x1c,%esp
 7d6:	5b                   	pop    %ebx
 7d7:	5e                   	pop    %esi
 7d8:	5f                   	pop    %edi
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    
 7db:	90                   	nop
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 7e0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 7e6:	b8 00 80 00 00       	mov    $0x8000,%eax
 7eb:	bf 00 10 00 00       	mov    $0x1000,%edi
 7f0:	76 04                	jbe    7f6 <malloc+0x86>
 7f2:	89 f0                	mov    %esi,%eax
 7f4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 e2 fb ff ff       	call   3e0 <sbrk>
  if(p == (char*) -1)
 7fe:	83 f8 ff             	cmp    $0xffffffff,%eax
 801:	74 18                	je     81b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 803:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 806:	83 c0 08             	add    $0x8,%eax
 809:	89 04 24             	mov    %eax,(%esp)
 80c:	e8 cf fe ff ff       	call   6e0 <free>
  return freep;
 811:	8b 0d c8 08 00 00    	mov    0x8c8,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 817:	85 c9                	test   %ecx,%ecx
 819:	75 97                	jne    7b2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 81b:	31 c0                	xor    %eax,%eax
 81d:	eb b4                	jmp    7d3 <malloc+0x63>
 81f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 820:	8b 10                	mov    (%eax),%edx
 822:	89 11                	mov    %edx,(%ecx)
 824:	eb a4                	jmp    7ca <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 826:	c7 05 c8 08 00 00 c0 	movl   $0x8c0,0x8c8
 82d:	08 00 00 
    base.s.size = 0;
 830:	b9 c0 08 00 00       	mov    $0x8c0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 835:	c7 05 c0 08 00 00 c0 	movl   $0x8c0,0x8c0
 83c:	08 00 00 
    base.s.size = 0;
 83f:	c7 05 c4 08 00 00 00 	movl   $0x0,0x8c4
 846:	00 00 00 
 849:	e9 45 ff ff ff       	jmp    793 <malloc+0x23>
