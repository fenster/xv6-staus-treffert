
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
  40:	c7 44 24 04 1e 07 00 	movl   $0x71e,0x4(%esp)
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
 340:	b8 17 00 00 00       	mov    $0x17,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <wait_thread>:
 348:	b8 18 00 00 00       	mov    $0x18,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 28             	sub    $0x28,%esp
 356:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 359:	8d 55 f4             	lea    -0xc(%ebp),%edx
 35c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 363:	00 
 364:	89 54 24 04          	mov    %edx,0x4(%esp)
 368:	89 04 24             	mov    %eax,(%esp)
 36b:	e8 48 ff ff ff       	call   2b8 <write>
}
 370:	c9                   	leave  
 371:	c3                   	ret    
 372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000380 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	89 c7                	mov    %eax,%edi
 386:	56                   	push   %esi
 387:	89 ce                	mov    %ecx,%esi
 389:	53                   	push   %ebx
 38a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 390:	85 c9                	test   %ecx,%ecx
 392:	74 04                	je     398 <printint+0x18>
 394:	85 d2                	test   %edx,%edx
 396:	78 5d                	js     3f5 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 398:	89 d0                	mov    %edx,%eax
 39a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3a1:	31 c9                	xor    %ecx,%ecx
 3a3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3a6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3a8:	31 d2                	xor    %edx,%edx
 3aa:	f7 f6                	div    %esi
 3ac:	0f b6 92 39 07 00 00 	movzbl 0x739(%edx),%edx
 3b3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3b6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3b9:	85 c0                	test   %eax,%eax
 3bb:	75 eb                	jne    3a8 <printint+0x28>
  if(neg)
 3bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3c0:	85 c0                	test   %eax,%eax
 3c2:	74 08                	je     3cc <printint+0x4c>
    buf[i++] = '-';
 3c4:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3c9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3cc:	8d 71 ff             	lea    -0x1(%ecx),%esi
 3cf:	01 f3                	add    %esi,%ebx
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3d8:	0f be 13             	movsbl (%ebx),%edx
 3db:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dd:	83 ee 01             	sub    $0x1,%esi
 3e0:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 3e3:	e8 68 ff ff ff       	call   350 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e8:	83 fe ff             	cmp    $0xffffffff,%esi
 3eb:	75 eb                	jne    3d8 <printint+0x58>
    putc(fd, buf[i]);
}
 3ed:	83 c4 2c             	add    $0x2c,%esp
 3f0:	5b                   	pop    %ebx
 3f1:	5e                   	pop    %esi
 3f2:	5f                   	pop    %edi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	f7 d8                	neg    %eax
 3f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 400:	eb 9f                	jmp    3a1 <printint+0x21>
 402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
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
 416:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 41f:	0f b6 08             	movzbl (%eax),%ecx
 422:	84 c9                	test   %cl,%cl
 424:	0f 84 96 00 00 00    	je     4c0 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 42a:	8d 55 10             	lea    0x10(%ebp),%edx
 42d:	31 f6                	xor    %esi,%esi
 42f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 432:	31 db                	xor    %ebx,%ebx
 434:	eb 1a                	jmp    450 <printf+0x40>
 436:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 438:	83 f9 25             	cmp    $0x25,%ecx
 43b:	0f 85 87 00 00 00    	jne    4c8 <printf+0xb8>
 441:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 445:	83 c3 01             	add    $0x1,%ebx
 448:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 44c:	84 c9                	test   %cl,%cl
 44e:	74 70                	je     4c0 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 450:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 452:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 455:	74 e1                	je     438 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 457:	83 fe 25             	cmp    $0x25,%esi
 45a:	75 e9                	jne    445 <printf+0x35>
      if(c == 'd'){
 45c:	83 f9 64             	cmp    $0x64,%ecx
 45f:	90                   	nop
 460:	0f 84 fa 00 00 00    	je     560 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 466:	83 f9 70             	cmp    $0x70,%ecx
 469:	74 75                	je     4e0 <printf+0xd0>
 46b:	83 f9 78             	cmp    $0x78,%ecx
 46e:	66 90                	xchg   %ax,%ax
 470:	74 6e                	je     4e0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 472:	83 f9 73             	cmp    $0x73,%ecx
 475:	0f 84 8d 00 00 00    	je     508 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47b:	83 f9 63             	cmp    $0x63,%ecx
 47e:	66 90                	xchg   %ax,%ax
 480:	0f 84 fe 00 00 00    	je     584 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 486:	83 f9 25             	cmp    $0x25,%ecx
 489:	0f 84 b9 00 00 00    	je     548 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 48f:	ba 25 00 00 00       	mov    $0x25,%edx
 494:	89 f8                	mov    %edi,%eax
 496:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 49c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 49e:	e8 ad fe ff ff       	call   350 <putc>
        putc(fd, c);
 4a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 4a6:	89 f8                	mov    %edi,%eax
 4a8:	0f be d1             	movsbl %cl,%edx
 4ab:	e8 a0 fe ff ff       	call   350 <putc>
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b3:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 4b7:	84 c9                	test   %cl,%cl
 4b9:	75 95                	jne    450 <printf+0x40>
 4bb:	90                   	nop
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
 // mutex_unlock(&plock);
}
 4c0:	83 c4 2c             	add    $0x2c,%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4c8:	89 f8                	mov    %edi,%eax
 4ca:	0f be d1             	movsbl %cl,%edx
 4cd:	e8 7e fe ff ff       	call   350 <putc>
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	e9 6b ff ff ff       	jmp    445 <printf+0x35>
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 4e8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4f1:	8b 10                	mov    (%eax),%edx
 4f3:	89 f8                	mov    %edi,%eax
 4f5:	e8 86 fe ff ff       	call   380 <printint>
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 4fd:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 501:	e9 3f ff ff ff       	jmp    445 <printf+0x35>
 506:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 50b:	8b 32                	mov    (%edx),%esi
        ap++;
 50d:	83 c2 04             	add    $0x4,%edx
 510:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 513:	85 f6                	test   %esi,%esi
 515:	0f 84 84 00 00 00    	je     59f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 51b:	0f b6 16             	movzbl (%esi),%edx
 51e:	84 d2                	test   %dl,%dl
 520:	74 1d                	je     53f <printf+0x12f>
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 528:	0f be d2             	movsbl %dl,%edx
          s++;
 52b:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 52e:	89 f8                	mov    %edi,%eax
 530:	e8 1b fe ff ff       	call   350 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 535:	0f b6 16             	movzbl (%esi),%edx
 538:	84 d2                	test   %dl,%dl
 53a:	75 ec                	jne    528 <printf+0x118>
 53c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 53f:	31 f6                	xor    %esi,%esi
 541:	e9 ff fe ff ff       	jmp    445 <printf+0x35>
 546:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 548:	89 f8                	mov    %edi,%eax
 54a:	ba 25 00 00 00       	mov    $0x25,%edx
 54f:	e8 fc fd ff ff       	call   350 <putc>
 554:	31 f6                	xor    %esi,%esi
 556:	8b 45 0c             	mov    0xc(%ebp),%eax
 559:	e9 e7 fe ff ff       	jmp    445 <printf+0x35>
 55e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 563:	b1 0a                	mov    $0xa,%cl
        ap++;
 565:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 56f:	8b 10                	mov    (%eax),%edx
 571:	89 f8                	mov    %edi,%eax
 573:	e8 08 fe ff ff       	call   380 <printint>
 578:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 57b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 57f:	e9 c1 fe ff ff       	jmp    445 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 587:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 589:	0f be 10             	movsbl (%eax),%edx
 58c:	89 f8                	mov    %edi,%eax
 58e:	e8 bd fd ff ff       	call   350 <putc>
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 596:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 59a:	e9 a6 fe ff ff       	jmp    445 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 59f:	be 32 07 00 00       	mov    $0x732,%esi
 5a4:	e9 72 ff ff ff       	jmp    51b <printf+0x10b>
 5a9:	90                   	nop
 5aa:	90                   	nop
 5ab:	90                   	nop
 5ac:	90                   	nop
 5ad:	90                   	nop
 5ae:	90                   	nop
 5af:	90                   	nop

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 54 07 00 00       	mov    0x754,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	39 c8                	cmp    %ecx,%eax
 5c3:	73 1d                	jae    5e2 <free+0x32>
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
 5c8:	8b 10                	mov    (%eax),%edx
 5ca:	39 d1                	cmp    %edx,%ecx
 5cc:	72 1a                	jb     5e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ce:	39 d0                	cmp    %edx,%eax
 5d0:	72 08                	jb     5da <free+0x2a>
 5d2:	39 c8                	cmp    %ecx,%eax
 5d4:	72 12                	jb     5e8 <free+0x38>
 5d6:	39 d1                	cmp    %edx,%ecx
 5d8:	72 0e                	jb     5e8 <free+0x38>
 5da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	66 90                	xchg   %ax,%ax
 5e0:	72 e6                	jb     5c8 <free+0x18>
 5e2:	8b 10                	mov    (%eax),%edx
 5e4:	eb e8                	jmp    5ce <free+0x1e>
 5e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e8:	8b 71 04             	mov    0x4(%ecx),%esi
 5eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ee:	39 d7                	cmp    %edx,%edi
 5f0:	74 19                	je     60b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5f5:	8b 50 04             	mov    0x4(%eax),%edx
 5f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5fb:	39 ce                	cmp    %ecx,%esi
 5fd:	74 21                	je     620 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 601:	a3 54 07 00 00       	mov    %eax,0x754
}
 606:	5b                   	pop    %ebx
 607:	5e                   	pop    %esi
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 60b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 610:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 613:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 616:	8b 50 04             	mov    0x4(%eax),%edx
 619:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61c:	39 ce                	cmp    %ecx,%esi
 61e:	75 df                	jne    5ff <free+0x4f>
    p->s.size += bp->s.size;
 620:	03 51 04             	add    0x4(%ecx),%edx
 623:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 626:	8b 53 f8             	mov    -0x8(%ebx),%edx
 629:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 62b:	a3 54 07 00 00       	mov    %eax,0x754
}
 630:	5b                   	pop    %ebx
 631:	5e                   	pop    %esi
 632:	5f                   	pop    %edi
 633:	5d                   	pop    %ebp
 634:	c3                   	ret    
 635:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 64c:	8b 0d 54 07 00 00    	mov    0x754,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	83 c3 07             	add    $0x7,%ebx
 655:	c1 eb 03             	shr    $0x3,%ebx
 658:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 65b:	85 c9                	test   %ecx,%ecx
 65d:	0f 84 93 00 00 00    	je     6f6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 663:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	39 d3                	cmp    %edx,%ebx
 66a:	76 1f                	jbe    68b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 66c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 673:	90                   	nop
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 678:	3b 05 54 07 00 00    	cmp    0x754,%eax
 67e:	74 30                	je     6b0 <malloc+0x70>
 680:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 682:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 684:	8b 50 04             	mov    0x4(%eax),%edx
 687:	39 d3                	cmp    %edx,%ebx
 689:	77 ed                	ja     678 <malloc+0x38>
      if(p->s.size == nunits)
 68b:	39 d3                	cmp    %edx,%ebx
 68d:	74 61                	je     6f0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 68f:	29 da                	sub    %ebx,%edx
 691:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 694:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 697:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 69a:	89 0d 54 07 00 00    	mov    %ecx,0x754
      return (void*) (p + 1);
 6a0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a3:	83 c4 1c             	add    $0x1c,%esp
 6a6:	5b                   	pop    %ebx
 6a7:	5e                   	pop    %esi
 6a8:	5f                   	pop    %edi
 6a9:	5d                   	pop    %ebp
 6aa:	c3                   	ret    
 6ab:	90                   	nop
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6b0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6b6:	b8 00 80 00 00       	mov    $0x8000,%eax
 6bb:	bf 00 10 00 00       	mov    $0x1000,%edi
 6c0:	76 04                	jbe    6c6 <malloc+0x86>
 6c2:	89 f0                	mov    %esi,%eax
 6c4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 6c6:	89 04 24             	mov    %eax,(%esp)
 6c9:	e8 52 fc ff ff       	call   320 <sbrk>
  if(p == (char*) -1)
 6ce:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d1:	74 18                	je     6eb <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6d3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6d6:	83 c0 08             	add    $0x8,%eax
 6d9:	89 04 24             	mov    %eax,(%esp)
 6dc:	e8 cf fe ff ff       	call   5b0 <free>
  return freep;
 6e1:	8b 0d 54 07 00 00    	mov    0x754,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6e7:	85 c9                	test   %ecx,%ecx
 6e9:	75 97                	jne    682 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6eb:	31 c0                	xor    %eax,%eax
 6ed:	eb b4                	jmp    6a3 <malloc+0x63>
 6ef:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	89 11                	mov    %edx,(%ecx)
 6f4:	eb a4                	jmp    69a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6f6:	c7 05 54 07 00 00 4c 	movl   $0x74c,0x754
 6fd:	07 00 00 
    base.s.size = 0;
 700:	b9 4c 07 00 00       	mov    $0x74c,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 705:	c7 05 4c 07 00 00 4c 	movl   $0x74c,0x74c
 70c:	07 00 00 
    base.s.size = 0;
 70f:	c7 05 50 07 00 00 00 	movl   $0x0,0x750
 716:	00 00 00 
 719:	e9 45 ff ff ff       	jmp    663 <malloc+0x23>
