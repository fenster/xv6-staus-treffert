
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  12:	83 fe 01             	cmp    $0x1,%esi
  15:	7e 60                	jle    77 <main+0x77>
  17:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1c:	83 c3 01             	add    $0x1,%ebx
  1f:	39 de                	cmp    %ebx,%esi
  21:	7e 30                	jle    53 <main+0x53>
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  28:	c7 44 24 0c 3e 07 00 	movl   $0x73e,0xc(%esp)
  2f:	00 
  30:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  34:	83 c3 01             	add    $0x1,%ebx
  37:	c7 44 24 04 40 07 00 	movl   $0x740,0x4(%esp)
  3e:	00 
  3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  46:	89 44 24 08          	mov    %eax,0x8(%esp)
  4a:	e8 e1 03 00 00       	call   430 <printf>
  4f:	39 de                	cmp    %ebx,%esi
  51:	7f d5                	jg     28 <main+0x28>
  53:	c7 44 24 0c 45 07 00 	movl   $0x745,0xc(%esp)
  5a:	00 
  5b:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  5f:	c7 44 24 04 40 07 00 	movl   $0x740,0x4(%esp)
  66:	00 
  67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	e8 b9 03 00 00       	call   430 <printf>
  exit();
  77:	e8 3c 02 00 00       	call   2b8 <exit>
  7c:	90                   	nop
  7d:	90                   	nop
  7e:	90                   	nop
  7f:	90                   	nop

00000080 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	31 d2                	xor    %edx,%edx
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	53                   	push   %ebx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 c9                	test   %cl,%cl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	eb 0d                	jmp    b0 <strcmp>
  a3:	90                   	nop
  a4:	90                   	nop
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop
  a8:	90                   	nop
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop
  ac:	90                   	nop
  ad:	90                   	nop
  ae:	90                   	nop
  af:	90                   	nop

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	0f b6 01             	movzbl (%ecx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 14                	jne    d5 <strcmp+0x25>
  c1:	eb 25                	jmp    e8 <strcmp+0x38>
  c3:	90                   	nop
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  c8:	83 c1 01             	add    $0x1,%ecx
  cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	0f b6 01             	movzbl (%ecx),%eax
  d1:	84 c0                	test   %al,%al
  d3:	74 13                	je     e8 <strcmp+0x38>
  d5:	0f b6 1a             	movzbl (%edx),%ebx
  d8:	38 d8                	cmp    %bl,%al
  da:	74 ec                	je     c8 <strcmp+0x18>
  dc:	0f b6 db             	movzbl %bl,%ebx
  df:	0f b6 c0             	movzbl %al,%eax
  e2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	0f b6 1a             	movzbl (%edx),%ebx
  eb:	31 c0                	xor    %eax,%eax
  ed:	0f b6 db             	movzbl %bl,%ebx
  f0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f2:	5b                   	pop    %ebx
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 105:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10a:	80 39 00             	cmpb   $0x0,(%ecx)
 10d:	74 0c                	je     11b <strlen+0x1b>
 10f:	90                   	nop
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 4d 10             	mov    0x10(%ebp),%ecx
 126:	53                   	push   %ebx
 127:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 12a:	85 c9                	test   %ecx,%ecx
 12c:	74 14                	je     142 <memset+0x22>
 12e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 132:	31 d2                	xor    %edx,%edx
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 138:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 13b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 13e:	39 ca                	cmp    %ecx,%edx
 140:	75 f6                	jne    138 <memset+0x18>
    *d++ = c;
  return dst;
}
 142:	5b                   	pop    %ebx
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 11                	jne    172 <strchr+0x22>
 161:	eb 15                	jmp    178 <strchr+0x28>
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 168:	83 c0 01             	add    $0x1,%eax
 16b:	0f b6 10             	movzbl (%eax),%edx
 16e:	84 d2                	test   %dl,%dl
 170:	74 06                	je     178 <strchr+0x28>
    if(*s == c)
 172:	38 ca                	cmp    %cl,%dl
 174:	75 f2                	jne    168 <strchr+0x18>
      return (char*) s;
  return 0;
}
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 178:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 17a:	5d                   	pop    %ebp
 17b:	90                   	nop
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <atoi>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 190:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 191:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 193:	89 e5                	mov    %esp,%ebp
 195:	8b 4d 08             	mov    0x8(%ebp),%ecx
 198:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 199:	0f b6 11             	movzbl (%ecx),%edx
 19c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 19f:	80 fb 09             	cmp    $0x9,%bl
 1a2:	77 1c                	ja     1c0 <atoi+0x30>
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 1a8:	0f be d2             	movsbl %dl,%edx
 1ab:	83 c1 01             	add    $0x1,%ecx
 1ae:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1b1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b5:	0f b6 11             	movzbl (%ecx),%edx
 1b8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1bb:	80 fb 09             	cmp    $0x9,%bl
 1be:	76 e8                	jbe    1a8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	53                   	push   %ebx
 1d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1de:	85 db                	test   %ebx,%ebx
 1e0:	7e 14                	jle    1f6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1e2:	31 d2                	xor    %edx,%edx
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1f2:	39 da                	cmp    %ebx,%edx
 1f4:	75 f2                	jne    1e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1f6:	5b                   	pop    %ebx
 1f7:	5e                   	pop    %esi
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 206:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 209:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 20c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 20f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21b:	00 
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 d4 00 00 00       	call   2f8 <open>
  if(fd < 0)
 224:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 228:	78 19                	js     243 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 1c 24             	mov    %ebx,(%esp)
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	e8 d7 00 00 00       	call   310 <fstat>
  close(fd);
 239:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 23c:	89 c6                	mov    %eax,%esi
  close(fd);
 23e:	e8 9d 00 00 00       	call   2e0 <close>
  return r;
}
 243:	89 f0                	mov    %esi,%eax
 245:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 248:	8b 75 fc             	mov    -0x4(%ebp),%esi
 24b:	89 ec                	mov    %ebp,%esp
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    
 24f:	90                   	nop

00000250 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	31 f6                	xor    %esi,%esi
 257:	53                   	push   %ebx
 258:	83 ec 2c             	sub    $0x2c,%esp
 25b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	eb 06                	jmp    266 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 260:	3c 0a                	cmp    $0xa,%al
 262:	74 39                	je     29d <gets+0x4d>
 264:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 266:	8d 5e 01             	lea    0x1(%esi),%ebx
 269:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 26c:	7d 31                	jge    29f <gets+0x4f>
    cc = read(0, &c, 1);
 26e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 271:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 278:	00 
 279:	89 44 24 04          	mov    %eax,0x4(%esp)
 27d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 284:	e8 47 00 00 00       	call   2d0 <read>
    if(cc < 1)
 289:	85 c0                	test   %eax,%eax
 28b:	7e 12                	jle    29f <gets+0x4f>
      break;
    buf[i++] = c;
 28d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 291:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 299:	3c 0d                	cmp    $0xd,%al
 29b:	75 c3                	jne    260 <gets+0x10>
 29d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 29f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2a3:	89 f8                	mov    %edi,%eax
 2a5:	83 c4 2c             	add    $0x2c,%esp
 2a8:	5b                   	pop    %ebx
 2a9:	5e                   	pop    %esi
 2aa:	5f                   	pop    %edi
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	90                   	nop
 2ae:	90                   	nop
 2af:	90                   	nop

000002b0 <fork>:
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	cd 30                	int    $0x30
 2b7:	c3                   	ret    

000002b8 <exit>:
 2b8:	b8 02 00 00 00       	mov    $0x2,%eax
 2bd:	cd 30                	int    $0x30
 2bf:	c3                   	ret    

000002c0 <wait>:
 2c0:	b8 03 00 00 00       	mov    $0x3,%eax
 2c5:	cd 30                	int    $0x30
 2c7:	c3                   	ret    

000002c8 <pipe>:
 2c8:	b8 04 00 00 00       	mov    $0x4,%eax
 2cd:	cd 30                	int    $0x30
 2cf:	c3                   	ret    

000002d0 <read>:
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 30                	int    $0x30
 2d7:	c3                   	ret    

000002d8 <write>:
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 30                	int    $0x30
 2df:	c3                   	ret    

000002e0 <close>:
 2e0:	b8 07 00 00 00       	mov    $0x7,%eax
 2e5:	cd 30                	int    $0x30
 2e7:	c3                   	ret    

000002e8 <kill>:
 2e8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ed:	cd 30                	int    $0x30
 2ef:	c3                   	ret    

000002f0 <exec>:
 2f0:	b8 09 00 00 00       	mov    $0x9,%eax
 2f5:	cd 30                	int    $0x30
 2f7:	c3                   	ret    

000002f8 <open>:
 2f8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fd:	cd 30                	int    $0x30
 2ff:	c3                   	ret    

00000300 <mknod>:
 300:	b8 0b 00 00 00       	mov    $0xb,%eax
 305:	cd 30                	int    $0x30
 307:	c3                   	ret    

00000308 <unlink>:
 308:	b8 0c 00 00 00       	mov    $0xc,%eax
 30d:	cd 30                	int    $0x30
 30f:	c3                   	ret    

00000310 <fstat>:
 310:	b8 0d 00 00 00       	mov    $0xd,%eax
 315:	cd 30                	int    $0x30
 317:	c3                   	ret    

00000318 <link>:
 318:	b8 0e 00 00 00       	mov    $0xe,%eax
 31d:	cd 30                	int    $0x30
 31f:	c3                   	ret    

00000320 <mkdir>:
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 30                	int    $0x30
 327:	c3                   	ret    

00000328 <chdir>:
 328:	b8 10 00 00 00       	mov    $0x10,%eax
 32d:	cd 30                	int    $0x30
 32f:	c3                   	ret    

00000330 <dup>:
 330:	b8 11 00 00 00       	mov    $0x11,%eax
 335:	cd 30                	int    $0x30
 337:	c3                   	ret    

00000338 <getpid>:
 338:	b8 12 00 00 00       	mov    $0x12,%eax
 33d:	cd 30                	int    $0x30
 33f:	c3                   	ret    

00000340 <sbrk>:
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <sleep>:
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <tick>:
 350:	b8 15 00 00 00       	mov    $0x15,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <fork_tickets>:
 358:	b8 16 00 00 00       	mov    $0x16,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <fork_thread>:
 360:	b8 17 00 00 00       	mov    $0x17,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <wait_thread>:
 368:	b8 18 00 00 00       	mov    $0x18,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 28             	sub    $0x28,%esp
 376:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 379:	8d 55 f4             	lea    -0xc(%ebp),%edx
 37c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 383:	00 
 384:	89 54 24 04          	mov    %edx,0x4(%esp)
 388:	89 04 24             	mov    %eax,(%esp)
 38b:	e8 48 ff ff ff       	call   2d8 <write>
}
 390:	c9                   	leave  
 391:	c3                   	ret    
 392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	89 c7                	mov    %eax,%edi
 3a6:	56                   	push   %esi
 3a7:	89 ce                	mov    %ecx,%esi
 3a9:	53                   	push   %ebx
 3aa:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3b0:	85 c9                	test   %ecx,%ecx
 3b2:	74 04                	je     3b8 <printint+0x18>
 3b4:	85 d2                	test   %edx,%edx
 3b6:	78 5d                	js     415 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b8:	89 d0                	mov    %edx,%eax
 3ba:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3c1:	31 c9                	xor    %ecx,%ecx
 3c3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3c6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3c8:	31 d2                	xor    %edx,%edx
 3ca:	f7 f6                	div    %esi
 3cc:	0f b6 92 4e 07 00 00 	movzbl 0x74e(%edx),%edx
 3d3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3d6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3d9:	85 c0                	test   %eax,%eax
 3db:	75 eb                	jne    3c8 <printint+0x28>
  if(neg)
 3dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3e0:	85 c0                	test   %eax,%eax
 3e2:	74 08                	je     3ec <printint+0x4c>
    buf[i++] = '-';
 3e4:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3e9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3ec:	8d 71 ff             	lea    -0x1(%ecx),%esi
 3ef:	01 f3                	add    %esi,%ebx
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3f8:	0f be 13             	movsbl (%ebx),%edx
 3fb:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3fd:	83 ee 01             	sub    $0x1,%esi
 400:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 403:	e8 68 ff ff ff       	call   370 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 408:	83 fe ff             	cmp    $0xffffffff,%esi
 40b:	75 eb                	jne    3f8 <printint+0x58>
    putc(fd, buf[i]);
}
 40d:	83 c4 2c             	add    $0x2c,%esp
 410:	5b                   	pop    %ebx
 411:	5e                   	pop    %esi
 412:	5f                   	pop    %edi
 413:	5d                   	pop    %ebp
 414:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 415:	89 d0                	mov    %edx,%eax
 417:	f7 d8                	neg    %eax
 419:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 420:	eb 9f                	jmp    3c1 <printint+0x21>
 422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 43f:	0f b6 08             	movzbl (%eax),%ecx
 442:	84 c9                	test   %cl,%cl
 444:	0f 84 96 00 00 00    	je     4e0 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 44a:	8d 55 10             	lea    0x10(%ebp),%edx
 44d:	31 f6                	xor    %esi,%esi
 44f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 452:	31 db                	xor    %ebx,%ebx
 454:	eb 1a                	jmp    470 <printf+0x40>
 456:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 458:	83 f9 25             	cmp    $0x25,%ecx
 45b:	0f 85 87 00 00 00    	jne    4e8 <printf+0xb8>
 461:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 465:	83 c3 01             	add    $0x1,%ebx
 468:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 46c:	84 c9                	test   %cl,%cl
 46e:	74 70                	je     4e0 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 470:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 472:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 475:	74 e1                	je     458 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 477:	83 fe 25             	cmp    $0x25,%esi
 47a:	75 e9                	jne    465 <printf+0x35>
      if(c == 'd'){
 47c:	83 f9 64             	cmp    $0x64,%ecx
 47f:	90                   	nop
 480:	0f 84 fa 00 00 00    	je     580 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 486:	83 f9 70             	cmp    $0x70,%ecx
 489:	74 75                	je     500 <printf+0xd0>
 48b:	83 f9 78             	cmp    $0x78,%ecx
 48e:	66 90                	xchg   %ax,%ax
 490:	74 6e                	je     500 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 492:	83 f9 73             	cmp    $0x73,%ecx
 495:	0f 84 8d 00 00 00    	je     528 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49b:	83 f9 63             	cmp    $0x63,%ecx
 49e:	66 90                	xchg   %ax,%ax
 4a0:	0f 84 fe 00 00 00    	je     5a4 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a6:	83 f9 25             	cmp    $0x25,%ecx
 4a9:	0f 84 b9 00 00 00    	je     568 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4af:	ba 25 00 00 00       	mov    $0x25,%edx
 4b4:	89 f8                	mov    %edi,%eax
 4b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4bc:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4be:	e8 ad fe ff ff       	call   370 <putc>
        putc(fd, c);
 4c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 4c6:	89 f8                	mov    %edi,%eax
 4c8:	0f be d1             	movsbl %cl,%edx
 4cb:	e8 a0 fe ff ff       	call   370 <putc>
 4d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d3:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 4d7:	84 c9                	test   %cl,%cl
 4d9:	75 95                	jne    470 <printf+0x40>
 4db:	90                   	nop
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
 // mutex_unlock(&plock);
}
 4e0:	83 c4 2c             	add    $0x2c,%esp
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5f                   	pop    %edi
 4e6:	5d                   	pop    %ebp
 4e7:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e8:	89 f8                	mov    %edi,%eax
 4ea:	0f be d1             	movsbl %cl,%edx
 4ed:	e8 7e fe ff ff       	call   370 <putc>
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	e9 6b ff ff ff       	jmp    465 <printf+0x35>
 4fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 508:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 50a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 511:	8b 10                	mov    (%eax),%edx
 513:	89 f8                	mov    %edi,%eax
 515:	e8 86 fe ff ff       	call   3a0 <printint>
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 51d:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 521:	e9 3f ff ff ff       	jmp    465 <printf+0x35>
 526:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 528:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 52b:	8b 32                	mov    (%edx),%esi
        ap++;
 52d:	83 c2 04             	add    $0x4,%edx
 530:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 533:	85 f6                	test   %esi,%esi
 535:	0f 84 84 00 00 00    	je     5bf <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 53b:	0f b6 16             	movzbl (%esi),%edx
 53e:	84 d2                	test   %dl,%dl
 540:	74 1d                	je     55f <printf+0x12f>
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 548:	0f be d2             	movsbl %dl,%edx
          s++;
 54b:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 54e:	89 f8                	mov    %edi,%eax
 550:	e8 1b fe ff ff       	call   370 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 555:	0f b6 16             	movzbl (%esi),%edx
 558:	84 d2                	test   %dl,%dl
 55a:	75 ec                	jne    548 <printf+0x118>
 55c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 55f:	31 f6                	xor    %esi,%esi
 561:	e9 ff fe ff ff       	jmp    465 <printf+0x35>
 566:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 568:	89 f8                	mov    %edi,%eax
 56a:	ba 25 00 00 00       	mov    $0x25,%edx
 56f:	e8 fc fd ff ff       	call   370 <putc>
 574:	31 f6                	xor    %esi,%esi
 576:	8b 45 0c             	mov    0xc(%ebp),%eax
 579:	e9 e7 fe ff ff       	jmp    465 <printf+0x35>
 57e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 580:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 583:	b1 0a                	mov    $0xa,%cl
        ap++;
 585:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 58f:	8b 10                	mov    (%eax),%edx
 591:	89 f8                	mov    %edi,%eax
 593:	e8 08 fe ff ff       	call   3a0 <printint>
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 59b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 59f:	e9 c1 fe ff ff       	jmp    465 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 5a7:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5a9:	0f be 10             	movsbl (%eax),%edx
 5ac:	89 f8                	mov    %edi,%eax
 5ae:	e8 bd fd ff ff       	call   370 <putc>
 5b3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5b6:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 5ba:	e9 a6 fe ff ff       	jmp    465 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 5bf:	be 47 07 00 00       	mov    $0x747,%esi
 5c4:	e9 72 ff ff ff       	jmp    53b <printf+0x10b>
 5c9:	90                   	nop
 5ca:	90                   	nop
 5cb:	90                   	nop
 5cc:	90                   	nop
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 68 07 00 00       	mov    0x768,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	39 c8                	cmp    %ecx,%eax
 5e3:	73 1d                	jae    602 <free+0x32>
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
 5e8:	8b 10                	mov    (%eax),%edx
 5ea:	39 d1                	cmp    %edx,%ecx
 5ec:	72 1a                	jb     608 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ee:	39 d0                	cmp    %edx,%eax
 5f0:	72 08                	jb     5fa <free+0x2a>
 5f2:	39 c8                	cmp    %ecx,%eax
 5f4:	72 12                	jb     608 <free+0x38>
 5f6:	39 d1                	cmp    %edx,%ecx
 5f8:	72 0e                	jb     608 <free+0x38>
 5fa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	66 90                	xchg   %ax,%ax
 600:	72 e6                	jb     5e8 <free+0x18>
 602:	8b 10                	mov    (%eax),%edx
 604:	eb e8                	jmp    5ee <free+0x1e>
 606:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 71 04             	mov    0x4(%ecx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 d7                	cmp    %edx,%edi
 610:	74 19                	je     62b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 50 04             	mov    0x4(%eax),%edx
 618:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61b:	39 ce                	cmp    %ecx,%esi
 61d:	74 21                	je     640 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 61f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 621:	a3 68 07 00 00       	mov    %eax,0x768
}
 626:	5b                   	pop    %ebx
 627:	5e                   	pop    %esi
 628:	5f                   	pop    %edi
 629:	5d                   	pop    %ebp
 62a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 62b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 62e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 630:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 633:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 636:	8b 50 04             	mov    0x4(%eax),%edx
 639:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 63c:	39 ce                	cmp    %ecx,%esi
 63e:	75 df                	jne    61f <free+0x4f>
    p->s.size += bp->s.size;
 640:	03 51 04             	add    0x4(%ecx),%edx
 643:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 646:	8b 53 f8             	mov    -0x8(%ebx),%edx
 649:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 64b:	a3 68 07 00 00       	mov    %eax,0x768
}
 650:	5b                   	pop    %ebx
 651:	5e                   	pop    %esi
 652:	5f                   	pop    %edi
 653:	5d                   	pop    %ebp
 654:	c3                   	ret    
 655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 66c:	8b 0d 68 07 00 00    	mov    0x768,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	83 c3 07             	add    $0x7,%ebx
 675:	c1 eb 03             	shr    $0x3,%ebx
 678:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67b:	85 c9                	test   %ecx,%ecx
 67d:	0f 84 93 00 00 00    	je     716 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	39 d3                	cmp    %edx,%ebx
 68a:	76 1f                	jbe    6ab <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 68c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 693:	90                   	nop
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 698:	3b 05 68 07 00 00    	cmp    0x768,%eax
 69e:	74 30                	je     6d0 <malloc+0x70>
 6a0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6a4:	8b 50 04             	mov    0x4(%eax),%edx
 6a7:	39 d3                	cmp    %edx,%ebx
 6a9:	77 ed                	ja     698 <malloc+0x38>
      if(p->s.size == nunits)
 6ab:	39 d3                	cmp    %edx,%ebx
 6ad:	74 61                	je     710 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6af:	29 da                	sub    %ebx,%edx
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6b4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6b7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6ba:	89 0d 68 07 00 00    	mov    %ecx,0x768
      return (void*) (p + 1);
 6c0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c3:	83 c4 1c             	add    $0x1c,%esp
 6c6:	5b                   	pop    %ebx
 6c7:	5e                   	pop    %esi
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    
 6cb:	90                   	nop
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6d0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6d6:	b8 00 80 00 00       	mov    $0x8000,%eax
 6db:	bf 00 10 00 00       	mov    $0x1000,%edi
 6e0:	76 04                	jbe    6e6 <malloc+0x86>
 6e2:	89 f0                	mov    %esi,%eax
 6e4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 52 fc ff ff       	call   340 <sbrk>
  if(p == (char*) -1)
 6ee:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f1:	74 18                	je     70b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6f3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6f6:	83 c0 08             	add    $0x8,%eax
 6f9:	89 04 24             	mov    %eax,(%esp)
 6fc:	e8 cf fe ff ff       	call   5d0 <free>
  return freep;
 701:	8b 0d 68 07 00 00    	mov    0x768,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 707:	85 c9                	test   %ecx,%ecx
 709:	75 97                	jne    6a2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 70b:	31 c0                	xor    %eax,%eax
 70d:	eb b4                	jmp    6c3 <malloc+0x63>
 70f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 710:	8b 10                	mov    (%eax),%edx
 712:	89 11                	mov    %edx,(%ecx)
 714:	eb a4                	jmp    6ba <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 716:	c7 05 68 07 00 00 60 	movl   $0x760,0x768
 71d:	07 00 00 
    base.s.size = 0;
 720:	b9 60 07 00 00       	mov    $0x760,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 725:	c7 05 60 07 00 00 60 	movl   $0x760,0x760
 72c:	07 00 00 
    base.s.size = 0;
 72f:	c7 05 64 07 00 00 00 	movl   $0x0,0x764
 736:	00 00 00 
 739:	e9 45 ff ff ff       	jmp    683 <malloc+0x23>
