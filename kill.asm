
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	83 ec 14             	sub    $0x14,%esp
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;
	
  if(argc < 1){
  12:	85 f6                	test   %esi,%esi
  14:	7e 2a                	jle    40 <main+0x40>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  16:	83 fe 01             	cmp    $0x1,%esi
{
  int i;
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  19:	bb 01 00 00 00       	mov    $0x1,%ebx
  }
  for(i=1; i<argc; i++)
  1e:	74 1a                	je     3a <main+0x3a>
    kill(atoi(argv[i]));
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    kill(atoi(argv[i]));
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 42 01 00 00       	call   170 <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 92 02 00 00       	call   2c8 <kill>
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	39 de                	cmp    %ebx,%esi
  38:	7f e6                	jg     20 <main+0x20>
    kill(atoi(argv[i]));
  exit();
  3a:	e8 59 02 00 00       	call   298 <exit>
  3f:	90                   	nop
main(int argc, char **argv)
{
  int i;
	
  if(argc < 1){
    printf(2, "usage: kill pid...\n");
  40:	c7 44 24 04 8e 07 00 	movl   $0x78e,0x4(%esp)
  47:	00 
  48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4f:	e8 bc 03 00 00       	call   410 <printf>
    exit();
  54:	e8 3f 02 00 00       	call   298 <exit>
  59:	90                   	nop
  5a:	90                   	nop
  5b:	90                   	nop
  5c:	90                   	nop
  5d:	90                   	nop
  5e:	90                   	nop
  5f:	90                   	nop

00000060 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	31 d2                	xor    %edx,%edx
  63:	89 e5                	mov    %esp,%ebp
  65:	8b 45 08             	mov    0x8(%ebp),%eax
  68:	53                   	push   %ebx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 c9                	test   %cl,%cl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	eb 0d                	jmp    90 <strcmp>
  83:	90                   	nop
  84:	90                   	nop
  85:	90                   	nop
  86:	90                   	nop
  87:	90                   	nop
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9a:	0f b6 01             	movzbl (%ecx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 14                	jne    b5 <strcmp+0x25>
  a1:	eb 25                	jmp    c8 <strcmp+0x38>
  a3:	90                   	nop
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 13                	je     c8 <strcmp+0x38>
  b5:	0f b6 1a             	movzbl (%edx),%ebx
  b8:	38 d8                	cmp    %bl,%al
  ba:	74 ec                	je     a8 <strcmp+0x18>
  bc:	0f b6 db             	movzbl %bl,%ebx
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	0f b6 1a             	movzbl (%edx),%ebx
  cb:	31 c0                	xor    %eax,%eax
  cd:	0f b6 db             	movzbl %bl,%ebx
  d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d2:	5b                   	pop    %ebx
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ea:	80 39 00             	cmpb   $0x0,(%ecx)
  ed:	74 0c                	je     fb <strlen+0x1b>
  ef:	90                   	nop
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 4d 10             	mov    0x10(%ebp),%ecx
 106:	53                   	push   %ebx
 107:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 10a:	85 c9                	test   %ecx,%ecx
 10c:	74 14                	je     122 <memset+0x22>
 10e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 112:	31 d2                	xor    %edx,%edx
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 118:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 11b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 11e:	39 ca                	cmp    %ecx,%edx
 120:	75 f6                	jne    118 <memset+0x18>
    *d++ = c;
  return dst;
}
 122:	5b                   	pop    %ebx
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    
 125:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	75 11                	jne    152 <strchr+0x22>
 141:	eb 15                	jmp    158 <strchr+0x28>
 143:	90                   	nop
 144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 148:	83 c0 01             	add    $0x1,%eax
 14b:	0f b6 10             	movzbl (%eax),%edx
 14e:	84 d2                	test   %dl,%dl
 150:	74 06                	je     158 <strchr+0x28>
    if(*s == c)
 152:	38 ca                	cmp    %cl,%dl
 154:	75 f2                	jne    148 <strchr+0x18>
      return (char*) s;
  return 0;
}
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 158:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 15a:	5d                   	pop    %ebp
 15b:	90                   	nop
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 160:	c3                   	ret    
 161:	eb 0d                	jmp    170 <atoi>
 163:	90                   	nop
 164:	90                   	nop
 165:	90                   	nop
 166:	90                   	nop
 167:	90                   	nop
 168:	90                   	nop
 169:	90                   	nop
 16a:	90                   	nop
 16b:	90                   	nop
 16c:	90                   	nop
 16d:	90                   	nop
 16e:	90                   	nop
 16f:	90                   	nop

00000170 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 170:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 171:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 173:	89 e5                	mov    %esp,%ebp
 175:	8b 4d 08             	mov    0x8(%ebp),%ecx
 178:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 179:	0f b6 11             	movzbl (%ecx),%edx
 17c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 17f:	80 fb 09             	cmp    $0x9,%bl
 182:	77 1c                	ja     1a0 <atoi+0x30>
 184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 188:	0f be d2             	movsbl %dl,%edx
 18b:	83 c1 01             	add    $0x1,%ecx
 18e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 191:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 195:	0f b6 11             	movzbl (%ecx),%edx
 198:	8d 5a d0             	lea    -0x30(%edx),%ebx
 19b:	80 fb 09             	cmp    $0x9,%bl
 19e:	76 e8                	jbe    188 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1a0:	5b                   	pop    %ebx
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    
 1a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	53                   	push   %ebx
 1b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1be:	85 db                	test   %ebx,%ebx
 1c0:	7e 14                	jle    1d6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1c2:	31 d2                	xor    %edx,%edx
 1c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1d2:	39 da                	cmp    %ebx,%edx
 1d4:	75 f2                	jne    1c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1d6:	5b                   	pop    %ebx
 1d7:	5e                   	pop    %esi
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 1e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 1ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 1ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fb:	00 
 1fc:	89 04 24             	mov    %eax,(%esp)
 1ff:	e8 d4 00 00 00       	call   2d8 <open>
  if(fd < 0)
 204:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 208:	78 19                	js     223 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 20a:	8b 45 0c             	mov    0xc(%ebp),%eax
 20d:	89 1c 24             	mov    %ebx,(%esp)
 210:	89 44 24 04          	mov    %eax,0x4(%esp)
 214:	e8 d7 00 00 00       	call   2f0 <fstat>
  close(fd);
 219:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 21c:	89 c6                	mov    %eax,%esi
  close(fd);
 21e:	e8 9d 00 00 00       	call   2c0 <close>
  return r;
}
 223:	89 f0                	mov    %esi,%eax
 225:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 228:	8b 75 fc             	mov    -0x4(%ebp),%esi
 22b:	89 ec                	mov    %ebp,%esp
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop

00000230 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	31 f6                	xor    %esi,%esi
 237:	53                   	push   %ebx
 238:	83 ec 2c             	sub    $0x2c,%esp
 23b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23e:	eb 06                	jmp    246 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 240:	3c 0a                	cmp    $0xa,%al
 242:	74 39                	je     27d <gets+0x4d>
 244:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 246:	8d 5e 01             	lea    0x1(%esi),%ebx
 249:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 24c:	7d 31                	jge    27f <gets+0x4f>
    cc = read(0, &c, 1);
 24e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 251:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 258:	00 
 259:	89 44 24 04          	mov    %eax,0x4(%esp)
 25d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 264:	e8 47 00 00 00       	call   2b0 <read>
    if(cc < 1)
 269:	85 c0                	test   %eax,%eax
 26b:	7e 12                	jle    27f <gets+0x4f>
      break;
    buf[i++] = c;
 26d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 271:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 275:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 279:	3c 0d                	cmp    $0xd,%al
 27b:	75 c3                	jne    240 <gets+0x10>
 27d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 27f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 283:	89 f8                	mov    %edi,%eax
 285:	83 c4 2c             	add    $0x2c,%esp
 288:	5b                   	pop    %ebx
 289:	5e                   	pop    %esi
 28a:	5f                   	pop    %edi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	90                   	nop
 28e:	90                   	nop
 28f:	90                   	nop

00000290 <fork>:
 290:	b8 01 00 00 00       	mov    $0x1,%eax
 295:	cd 30                	int    $0x30
 297:	c3                   	ret    

00000298 <exit>:
 298:	b8 02 00 00 00       	mov    $0x2,%eax
 29d:	cd 30                	int    $0x30
 29f:	c3                   	ret    

000002a0 <wait>:
 2a0:	b8 03 00 00 00       	mov    $0x3,%eax
 2a5:	cd 30                	int    $0x30
 2a7:	c3                   	ret    

000002a8 <pipe>:
 2a8:	b8 04 00 00 00       	mov    $0x4,%eax
 2ad:	cd 30                	int    $0x30
 2af:	c3                   	ret    

000002b0 <read>:
 2b0:	b8 06 00 00 00       	mov    $0x6,%eax
 2b5:	cd 30                	int    $0x30
 2b7:	c3                   	ret    

000002b8 <write>:
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 30                	int    $0x30
 2bf:	c3                   	ret    

000002c0 <close>:
 2c0:	b8 07 00 00 00       	mov    $0x7,%eax
 2c5:	cd 30                	int    $0x30
 2c7:	c3                   	ret    

000002c8 <kill>:
 2c8:	b8 08 00 00 00       	mov    $0x8,%eax
 2cd:	cd 30                	int    $0x30
 2cf:	c3                   	ret    

000002d0 <exec>:
 2d0:	b8 09 00 00 00       	mov    $0x9,%eax
 2d5:	cd 30                	int    $0x30
 2d7:	c3                   	ret    

000002d8 <open>:
 2d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2dd:	cd 30                	int    $0x30
 2df:	c3                   	ret    

000002e0 <mknod>:
 2e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    

000002e8 <unlink>:
 2e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ed:	cd 30                	int    $0x30
 2ef:	c3                   	ret    

000002f0 <fstat>:
 2f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <link>:
 2f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <mkdir>:
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <chdir>:
 308:	b8 10 00 00 00       	mov    $0x10,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <dup>:
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <getpid>:
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <sbrk>:
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <sleep>:
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <tick>:
 330:	b8 15 00 00 00       	mov    $0x15,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <fork_tickets>:
 338:	b8 16 00 00 00       	mov    $0x16,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <fork_thread>:
 340:	b8 19 00 00 00       	mov    $0x19,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <wait_thread>:
 348:	b8 1a 00 00 00       	mov    $0x1a,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <sleep_lock>:
 350:	b8 17 00 00 00       	mov    $0x17,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <wake_lock>:
 358:	b8 18 00 00 00       	mov    $0x18,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <check>:
 360:	b8 1b 00 00 00       	mov    $0x1b,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <log_init>:
 368:	b8 1c 00 00 00       	mov    $0x1c,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	89 cf                	mov    %ecx,%edi
 376:	56                   	push   %esi
 377:	89 c6                	mov    %eax,%esi
 379:	53                   	push   %ebx
 37a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 380:	85 c9                	test   %ecx,%ecx
 382:	74 04                	je     388 <printint+0x18>
 384:	85 d2                	test   %edx,%edx
 386:	78 70                	js     3f8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 388:	89 d0                	mov    %edx,%eax
 38a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 391:	31 c9                	xor    %ecx,%ecx
 393:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 396:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 398:	31 d2                	xor    %edx,%edx
 39a:	f7 f7                	div    %edi
 39c:	0f b6 92 a9 07 00 00 	movzbl 0x7a9(%edx),%edx
 3a3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3a6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3a9:	85 c0                	test   %eax,%eax
 3ab:	75 eb                	jne    398 <printint+0x28>
  if(neg)
 3ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b0:	85 c0                	test   %eax,%eax
 3b2:	74 08                	je     3bc <printint+0x4c>
    buf[i++] = '-';
 3b4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 3b9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3bc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3bf:	01 fb                	add    %edi,%ebx
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3c8:	0f b6 03             	movzbl (%ebx),%eax
 3cb:	83 ef 01             	sub    $0x1,%edi
 3ce:	83 eb 01             	sub    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d8:	00 
 3d9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dc:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3df:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e6:	e8 cd fe ff ff       	call   2b8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3eb:	83 ff ff             	cmp    $0xffffffff,%edi
 3ee:	75 d8                	jne    3c8 <printint+0x58>
    putc(fd, buf[i]);
}
 3f0:	83 c4 4c             	add    $0x4c,%esp
 3f3:	5b                   	pop    %ebx
 3f4:	5e                   	pop    %esi
 3f5:	5f                   	pop    %edi
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3f8:	89 d0                	mov    %edx,%eax
 3fa:	f7 d8                	neg    %eax
 3fc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 403:	eb 8c                	jmp    391 <printint+0x21>
 405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	0f b6 10             	movzbl (%eax),%edx
 41f:	84 d2                	test   %dl,%dl
 421:	0f 84 c9 00 00 00    	je     4f0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 4d 10             	lea    0x10(%ebp),%ecx
 42a:	31 ff                	xor    %edi,%edi
 42c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 42f:	31 db                	xor    %ebx,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 431:	8d 75 e7             	lea    -0x19(%ebp),%esi
 434:	eb 1e                	jmp    454 <printf+0x44>
 436:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 438:	83 fa 25             	cmp    $0x25,%edx
 43b:	0f 85 b7 00 00 00    	jne    4f8 <printf+0xe8>
 441:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 445:	83 c3 01             	add    $0x1,%ebx
 448:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 44c:	84 d2                	test   %dl,%dl
 44e:	0f 84 9c 00 00 00    	je     4f0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 454:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 456:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 459:	74 dd                	je     438 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45b:	83 ff 25             	cmp    $0x25,%edi
 45e:	75 e5                	jne    445 <printf+0x35>
      if(c == 'd'){
 460:	83 fa 64             	cmp    $0x64,%edx
 463:	0f 84 57 01 00 00    	je     5c0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 469:	83 fa 70             	cmp    $0x70,%edx
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 470:	0f 84 aa 00 00 00    	je     520 <printf+0x110>
 476:	83 fa 78             	cmp    $0x78,%edx
 479:	0f 84 a1 00 00 00    	je     520 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 47f:	83 fa 73             	cmp    $0x73,%edx
 482:	0f 84 c0 00 00 00    	je     548 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 488:	83 fa 63             	cmp    $0x63,%edx
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	0f 84 52 01 00 00    	je     5e8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 496:	83 fa 25             	cmp    $0x25,%edx
 499:	0f 84 f9 00 00 00    	je     598 <printf+0x188>
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a2:	83 c3 01             	add    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a5:	31 ff                	xor    %edi,%edi
 4a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4aa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b5:	00 
 4b6:	89 0c 24             	mov    %ecx,(%esp)
 4b9:	89 74 24 04          	mov    %esi,0x4(%esp)
 4bd:	e8 f6 fd ff ff       	call   2b8 <write>
 4c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	89 74 24 04          	mov    %esi,0x4(%esp)
 4d4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4d7:	89 04 24             	mov    %eax,(%esp)
 4da:	e8 d9 fd ff ff       	call   2b8 <write>
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 4e6:	84 d2                	test   %dl,%dl
 4e8:	0f 85 66 ff ff ff    	jne    454 <printf+0x44>
 4ee:	66 90                	xchg   %ax,%ax
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
 4f0:	83 c4 3c             	add    $0x3c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
 506:	89 74 24 04          	mov    %esi,0x4(%esp)
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 a6 fd ff ff       	call   2b8 <write>
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	e9 2b ff ff ff       	jmp    445 <printf+0x35>
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 520:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 523:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 528:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 52a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 531:	8b 10                	mov    (%eax),%edx
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	e8 35 fe ff ff       	call   370 <printint>
 53b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 53e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 542:	e9 fe fe ff ff       	jmp    445 <printf+0x35>
 547:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 548:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 54b:	8b 3a                	mov    (%edx),%edi
        ap++;
 54d:	83 c2 04             	add    $0x4,%edx
 550:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 553:	85 ff                	test   %edi,%edi
 555:	0f 84 ba 00 00 00    	je     615 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 55b:	0f b6 17             	movzbl (%edi),%edx
 55e:	84 d2                	test   %dl,%dl
 560:	74 2d                	je     58f <printf+0x17f>
 562:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 565:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 568:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56b:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 575:	00 
 576:	89 74 24 04          	mov    %esi,0x4(%esp)
 57a:	89 1c 24             	mov    %ebx,(%esp)
 57d:	e8 36 fd ff ff       	call   2b8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 582:	0f b6 17             	movzbl (%edi),%edx
 585:	84 d2                	test   %dl,%dl
 587:	75 df                	jne    568 <printf+0x158>
 589:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 58c:	8b 45 0c             	mov    0xc(%ebp),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58f:	31 ff                	xor    %edi,%edi
 591:	e9 af fe ff ff       	jmp    445 <printf+0x35>
 596:	66 90                	xchg   %ax,%ax
 598:	8b 55 08             	mov    0x8(%ebp),%edx
 59b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 59d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a8:	00 
 5a9:	89 74 24 04          	mov    %esi,0x4(%esp)
 5ad:	89 14 24             	mov    %edx,(%esp)
 5b0:	e8 03 fd ff ff       	call   2b8 <write>
 5b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b8:	e9 88 fe ff ff       	jmp    445 <printf+0x35>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5c8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5d2:	8b 10                	mov    (%eax),%edx
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	e8 94 fd ff ff       	call   370 <printint>
 5dc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5df:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5e3:	e9 5d fe ff ff       	jmp    445 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 5eb:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ed:	8b 01                	mov    (%ecx),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f6:	00 
 5f7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fb:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 04 24             	mov    %eax,(%esp)
 604:	e8 af fc ff ff       	call   2b8 <write>
 609:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 60c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 610:	e9 30 fe ff ff       	jmp    445 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 615:	bf a2 07 00 00       	mov    $0x7a2,%edi
 61a:	e9 3c ff ff ff       	jmp    55b <printf+0x14b>
 61f:	90                   	nop

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 c4 07 00 00       	mov    0x7c4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 62e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	39 c8                	cmp    %ecx,%eax
 633:	73 1d                	jae    652 <free+0x32>
 635:	8d 76 00             	lea    0x0(%esi),%esi
 638:	8b 10                	mov    (%eax),%edx
 63a:	39 d1                	cmp    %edx,%ecx
 63c:	72 1a                	jb     658 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	39 d0                	cmp    %edx,%eax
 640:	72 08                	jb     64a <free+0x2a>
 642:	39 c8                	cmp    %ecx,%eax
 644:	72 12                	jb     658 <free+0x38>
 646:	39 d1                	cmp    %edx,%ecx
 648:	72 0e                	jb     658 <free+0x38>
 64a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	39 c8                	cmp    %ecx,%eax
 64e:	66 90                	xchg   %ax,%ax
 650:	72 e6                	jb     638 <free+0x18>
 652:	8b 10                	mov    (%eax),%edx
 654:	eb e8                	jmp    63e <free+0x1e>
 656:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 71 04             	mov    0x4(%ecx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 d7                	cmp    %edx,%edi
 660:	74 19                	je     67b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 662:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 66b:	39 ce                	cmp    %ecx,%esi
 66d:	74 21                	je     690 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 66f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 671:	a3 c4 07 00 00       	mov    %eax,0x7c4
}
 676:	5b                   	pop    %ebx
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 67b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 67e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 680:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 683:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 68c:	39 ce                	cmp    %ecx,%esi
 68e:	75 df                	jne    66f <free+0x4f>
    p->s.size += bp->s.size;
 690:	03 51 04             	add    0x4(%ecx),%edx
 693:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 696:	8b 53 f8             	mov    -0x8(%ebx),%edx
 699:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 69b:	a3 c4 07 00 00       	mov    %eax,0x7c4
}
 6a0:	5b                   	pop    %ebx
 6a1:	5e                   	pop    %esi
 6a2:	5f                   	pop    %edi
 6a3:	5d                   	pop    %ebp
 6a4:	c3                   	ret    
 6a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6bc:	8b 0d c4 07 00 00    	mov    0x7c4,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	83 c3 07             	add    $0x7,%ebx
 6c5:	c1 eb 03             	shr    $0x3,%ebx
 6c8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6cb:	85 c9                	test   %ecx,%ecx
 6cd:	0f 84 93 00 00 00    	je     766 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	39 d3                	cmp    %edx,%ebx
 6da:	76 1f                	jbe    6fb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6dc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 6e8:	3b 05 c4 07 00 00    	cmp    0x7c4,%eax
 6ee:	74 30                	je     720 <malloc+0x70>
 6f0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6f4:	8b 50 04             	mov    0x4(%eax),%edx
 6f7:	39 d3                	cmp    %edx,%ebx
 6f9:	77 ed                	ja     6e8 <malloc+0x38>
      if(p->s.size == nunits)
 6fb:	39 d3                	cmp    %edx,%ebx
 6fd:	74 61                	je     760 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ff:	29 da                	sub    %ebx,%edx
 701:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 704:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 707:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 70a:	89 0d c4 07 00 00    	mov    %ecx,0x7c4
      return (void*) (p + 1);
 710:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 713:	83 c4 1c             	add    $0x1c,%esp
 716:	5b                   	pop    %ebx
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
 71b:	90                   	nop
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 720:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 726:	b8 00 80 00 00       	mov    $0x8000,%eax
 72b:	bf 00 10 00 00       	mov    $0x1000,%edi
 730:	76 04                	jbe    736 <malloc+0x86>
 732:	89 f0                	mov    %esi,%eax
 734:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 e2 fb ff ff       	call   320 <sbrk>
  if(p == (char*) -1)
 73e:	83 f8 ff             	cmp    $0xffffffff,%eax
 741:	74 18                	je     75b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 743:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 746:	83 c0 08             	add    $0x8,%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 cf fe ff ff       	call   620 <free>
  return freep;
 751:	8b 0d c4 07 00 00    	mov    0x7c4,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 757:	85 c9                	test   %ecx,%ecx
 759:	75 97                	jne    6f2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 75b:	31 c0                	xor    %eax,%eax
 75d:	eb b4                	jmp    713 <malloc+0x63>
 75f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 760:	8b 10                	mov    (%eax),%edx
 762:	89 11                	mov    %edx,(%ecx)
 764:	eb a4                	jmp    70a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 766:	c7 05 c4 07 00 00 bc 	movl   $0x7bc,0x7c4
 76d:	07 00 00 
    base.s.size = 0;
 770:	b9 bc 07 00 00       	mov    $0x7bc,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 775:	c7 05 bc 07 00 00 bc 	movl   $0x7bc,0x7bc
 77c:	07 00 00 
    base.s.size = 0;
 77f:	c7 05 c0 07 00 00 00 	movl   $0x0,0x7c0
 786:	00 00 00 
 789:	e9 45 ff ff ff       	jmp    6d3 <malloc+0x23>
