
_rm:     file format elf32-i386


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
   c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  if(argc < 2){
   f:	83 ff 01             	cmp    $0x1,%edi
  12:	7e 4c                	jle    60 <main+0x60>
    printf(2, "Usage: rm files...\n");
    exit();
  14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  17:	be 01 00 00 00       	mov    $0x1,%esi
  1c:	83 c3 04             	add    $0x4,%ebx
  1f:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  20:	8b 03                	mov    (%ebx),%eax
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 de 02 00 00       	call   308 <unlink>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 12                	js     40 <main+0x40>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  2e:	83 c6 01             	add    $0x1,%esi
  31:	83 c3 04             	add    $0x4,%ebx
  34:	39 f7                	cmp    %esi,%edi
  36:	7f e8                	jg     20 <main+0x20>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  38:	e8 7b 02 00 00       	call   2b8 <exit>
  3d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
      printf(2, "rm: %s failed to delete\n", argv[i]);
  40:	8b 03                	mov    (%ebx),%eax
  42:	c7 44 24 04 c2 07 00 	movl   $0x7c2,0x4(%esp)
  49:	00 
  4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  51:	89 44 24 08          	mov    %eax,0x8(%esp)
  55:	e8 d6 03 00 00       	call   430 <printf>
      break;
    }
  }

  exit();
  5a:	e8 59 02 00 00       	call   2b8 <exit>
  5f:	90                   	nop
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    printf(2, "Usage: rm files...\n");
  60:	c7 44 24 04 ae 07 00 	movl   $0x7ae,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 bc 03 00 00       	call   430 <printf>
    exit();
  74:	e8 3f 02 00 00       	call   2b8 <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop
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
 360:	b8 19 00 00 00       	mov    $0x19,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <wait_thread>:
 368:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <sleep_lock>:
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <wake_lock>:
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <check>:
 380:	b8 1b 00 00 00       	mov    $0x1b,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <log_init>:
 388:	b8 1c 00 00 00       	mov    $0x1c,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	89 cf                	mov    %ecx,%edi
 396:	56                   	push   %esi
 397:	89 c6                	mov    %eax,%esi
 399:	53                   	push   %ebx
 39a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a0:	85 c9                	test   %ecx,%ecx
 3a2:	74 04                	je     3a8 <printint+0x18>
 3a4:	85 d2                	test   %edx,%edx
 3a6:	78 70                	js     418 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3b1:	31 c9                	xor    %ecx,%ecx
 3b3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3b6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3b8:	31 d2                	xor    %edx,%edx
 3ba:	f7 f7                	div    %edi
 3bc:	0f b6 92 e2 07 00 00 	movzbl 0x7e2(%edx),%edx
 3c3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3c6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3c9:	85 c0                	test   %eax,%eax
 3cb:	75 eb                	jne    3b8 <printint+0x28>
  if(neg)
 3cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3d0:	85 c0                	test   %eax,%eax
 3d2:	74 08                	je     3dc <printint+0x4c>
    buf[i++] = '-';
 3d4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 3d9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3dc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3df:	01 fb                	add    %edi,%ebx
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 03             	movzbl (%ebx),%eax
 3eb:	83 ef 01             	sub    $0x1,%edi
 3ee:	83 eb 01             	sub    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f8:	00 
 3f9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3fc:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3ff:	8d 45 e7             	lea    -0x19(%ebp),%eax
 402:	89 44 24 04          	mov    %eax,0x4(%esp)
 406:	e8 cd fe ff ff       	call   2d8 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40b:	83 ff ff             	cmp    $0xffffffff,%edi
 40e:	75 d8                	jne    3e8 <printint+0x58>
    putc(fd, buf[i]);
}
 410:	83 c4 4c             	add    $0x4c,%esp
 413:	5b                   	pop    %ebx
 414:	5e                   	pop    %esi
 415:	5f                   	pop    %edi
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 418:	89 d0                	mov    %edx,%eax
 41a:	f7 d8                	neg    %eax
 41c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 423:	eb 8c                	jmp    3b1 <printint+0x21>
 425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
 436:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
 43c:	0f b6 10             	movzbl (%eax),%edx
 43f:	84 d2                	test   %dl,%dl
 441:	0f 84 c9 00 00 00    	je     510 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 447:	8d 4d 10             	lea    0x10(%ebp),%ecx
 44a:	31 ff                	xor    %edi,%edi
 44c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 44f:	31 db                	xor    %ebx,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 451:	8d 75 e7             	lea    -0x19(%ebp),%esi
 454:	eb 1e                	jmp    474 <printf+0x44>
 456:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 458:	83 fa 25             	cmp    $0x25,%edx
 45b:	0f 85 b7 00 00 00    	jne    518 <printf+0xe8>
 461:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 465:	83 c3 01             	add    $0x1,%ebx
 468:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 46c:	84 d2                	test   %dl,%dl
 46e:	0f 84 9c 00 00 00    	je     510 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 474:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 476:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 479:	74 dd                	je     458 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47b:	83 ff 25             	cmp    $0x25,%edi
 47e:	75 e5                	jne    465 <printf+0x35>
      if(c == 'd'){
 480:	83 fa 64             	cmp    $0x64,%edx
 483:	0f 84 57 01 00 00    	je     5e0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 489:	83 fa 70             	cmp    $0x70,%edx
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	0f 84 aa 00 00 00    	je     540 <printf+0x110>
 496:	83 fa 78             	cmp    $0x78,%edx
 499:	0f 84 a1 00 00 00    	je     540 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 49f:	83 fa 73             	cmp    $0x73,%edx
 4a2:	0f 84 c0 00 00 00    	je     568 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a8:	83 fa 63             	cmp    $0x63,%edx
 4ab:	90                   	nop
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b0:	0f 84 52 01 00 00    	je     608 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b6:	83 fa 25             	cmp    $0x25,%edx
 4b9:	0f 84 f9 00 00 00    	je     5b8 <printf+0x188>
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c2:	83 c3 01             	add    $0x1,%ebx
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c5:	31 ff                	xor    %edi,%edi
 4c7:	89 55 cc             	mov    %edx,-0x34(%ebp)
 4ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d5:	00 
 4d6:	89 0c 24             	mov    %ecx,(%esp)
 4d9:	89 74 24 04          	mov    %esi,0x4(%esp)
 4dd:	e8 f6 fd ff ff       	call   2d8 <write>
 4e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
 4e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ef:	00 
 4f0:	89 74 24 04          	mov    %esi,0x4(%esp)
 4f4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 d9 fd ff ff       	call   2d8 <write>
 4ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 502:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 506:	84 d2                	test   %dl,%dl
 508:	0f 85 66 ff ff ff    	jne    474 <printf+0x44>
 50e:	66 90                	xchg   %ax,%ax
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
 510:	83 c4 3c             	add    $0x3c,%esp
 513:	5b                   	pop    %ebx
 514:	5e                   	pop    %esi
 515:	5f                   	pop    %edi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 51b:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 525:	00 
 526:	89 74 24 04          	mov    %esi,0x4(%esp)
 52a:	89 04 24             	mov    %eax,(%esp)
 52d:	e8 a6 fd ff ff       	call   2d8 <write>
 532:	8b 45 0c             	mov    0xc(%ebp),%eax
 535:	e9 2b ff ff ff       	jmp    465 <printf+0x35>
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 548:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 54a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 551:	8b 10                	mov    (%eax),%edx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	e8 35 fe ff ff       	call   390 <printint>
 55b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 55e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 562:	e9 fe fe ff ff       	jmp    465 <printf+0x35>
 567:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 56b:	8b 3a                	mov    (%edx),%edi
        ap++;
 56d:	83 c2 04             	add    $0x4,%edx
 570:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 573:	85 ff                	test   %edi,%edi
 575:	0f 84 ba 00 00 00    	je     635 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 57b:	0f b6 17             	movzbl (%edi),%edx
 57e:	84 d2                	test   %dl,%dl
 580:	74 2d                	je     5af <printf+0x17f>
 582:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 585:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 588:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58b:	88 55 e7             	mov    %dl,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 595:	00 
 596:	89 74 24 04          	mov    %esi,0x4(%esp)
 59a:	89 1c 24             	mov    %ebx,(%esp)
 59d:	e8 36 fd ff ff       	call   2d8 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a2:	0f b6 17             	movzbl (%edi),%edx
 5a5:	84 d2                	test   %dl,%dl
 5a7:	75 df                	jne    588 <printf+0x158>
 5a9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5ac:	8b 45 0c             	mov    0xc(%ebp),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5af:	31 ff                	xor    %edi,%edi
 5b1:	e9 af fe ff ff       	jmp    465 <printf+0x35>
 5b6:	66 90                	xchg   %ax,%ax
 5b8:	8b 55 08             	mov    0x8(%ebp),%edx
 5bb:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5bd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c8:	00 
 5c9:	89 74 24 04          	mov    %esi,0x4(%esp)
 5cd:	89 14 24             	mov    %edx,(%esp)
 5d0:	e8 03 fd ff ff       	call   2d8 <write>
 5d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d8:	e9 88 fe ff ff       	jmp    465 <printf+0x35>
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 5e8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5f2:	8b 10                	mov    (%eax),%edx
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	e8 94 fd ff ff       	call   390 <printint>
 5fc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5ff:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 603:	e9 5d fe ff ff       	jmp    465 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 608:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 60b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60d:	8b 01                	mov    (%ecx),%eax
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 60f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 616:	00 
 617:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61b:	88 45 e7             	mov    %al,-0x19(%ebp)
//struct mutex_t plock;

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	89 04 24             	mov    %eax,(%esp)
 624:	e8 af fc ff ff       	call   2d8 <write>
 629:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 62c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 630:	e9 30 fe ff ff       	jmp    465 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 635:	bf db 07 00 00       	mov    $0x7db,%edi
 63a:	e9 3c ff ff ff       	jmp    57b <printf+0x14b>
 63f:	90                   	nop

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 fc 07 00 00       	mov    0x7fc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	39 c8                	cmp    %ecx,%eax
 653:	73 1d                	jae    672 <free+0x32>
 655:	8d 76 00             	lea    0x0(%esi),%esi
 658:	8b 10                	mov    (%eax),%edx
 65a:	39 d1                	cmp    %edx,%ecx
 65c:	72 1a                	jb     678 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65e:	39 d0                	cmp    %edx,%eax
 660:	72 08                	jb     66a <free+0x2a>
 662:	39 c8                	cmp    %ecx,%eax
 664:	72 12                	jb     678 <free+0x38>
 666:	39 d1                	cmp    %edx,%ecx
 668:	72 0e                	jb     678 <free+0x38>
 66a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	39 c8                	cmp    %ecx,%eax
 66e:	66 90                	xchg   %ax,%ax
 670:	72 e6                	jb     658 <free+0x18>
 672:	8b 10                	mov    (%eax),%edx
 674:	eb e8                	jmp    65e <free+0x1e>
 676:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 71 04             	mov    0x4(%ecx),%esi
 67b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67e:	39 d7                	cmp    %edx,%edi
 680:	74 19                	je     69b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 682:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 68b:	39 ce                	cmp    %ecx,%esi
 68d:	74 21                	je     6b0 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 691:	a3 fc 07 00 00       	mov    %eax,0x7fc
}
 696:	5b                   	pop    %ebx
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a0:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6a6:	8b 50 04             	mov    0x4(%eax),%edx
 6a9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ac:	39 ce                	cmp    %ecx,%esi
 6ae:	75 df                	jne    68f <free+0x4f>
    p->s.size += bp->s.size;
 6b0:	03 51 04             	add    0x4(%ecx),%edx
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b9:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6bb:	a3 fc 07 00 00       	mov    %eax,0x7fc
}
 6c0:	5b                   	pop    %ebx
 6c1:	5e                   	pop    %esi
 6c2:	5f                   	pop    %edi
 6c3:	5d                   	pop    %ebp
 6c4:	c3                   	ret    
 6c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6dc:	8b 0d fc 07 00 00    	mov    0x7fc,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	83 c3 07             	add    $0x7,%ebx
 6e5:	c1 eb 03             	shr    $0x3,%ebx
 6e8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6eb:	85 c9                	test   %ecx,%ecx
 6ed:	0f 84 93 00 00 00    	je     786 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6f5:	8b 50 04             	mov    0x4(%eax),%edx
 6f8:	39 d3                	cmp    %edx,%ebx
 6fa:	76 1f                	jbe    71b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 6fc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 703:	90                   	nop
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 708:	3b 05 fc 07 00 00    	cmp    0x7fc,%eax
 70e:	74 30                	je     740 <malloc+0x70>
 710:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 712:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 714:	8b 50 04             	mov    0x4(%eax),%edx
 717:	39 d3                	cmp    %edx,%ebx
 719:	77 ed                	ja     708 <malloc+0x38>
      if(p->s.size == nunits)
 71b:	39 d3                	cmp    %edx,%ebx
 71d:	74 61                	je     780 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 71f:	29 da                	sub    %ebx,%edx
 721:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 724:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 727:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 72a:	89 0d fc 07 00 00    	mov    %ecx,0x7fc
      return (void*) (p + 1);
 730:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 733:	83 c4 1c             	add    $0x1c,%esp
 736:	5b                   	pop    %ebx
 737:	5e                   	pop    %esi
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret    
 73b:	90                   	nop
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 740:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 746:	b8 00 80 00 00       	mov    $0x8000,%eax
 74b:	bf 00 10 00 00       	mov    $0x1000,%edi
 750:	76 04                	jbe    756 <malloc+0x86>
 752:	89 f0                	mov    %esi,%eax
 754:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 756:	89 04 24             	mov    %eax,(%esp)
 759:	e8 e2 fb ff ff       	call   340 <sbrk>
  if(p == (char*) -1)
 75e:	83 f8 ff             	cmp    $0xffffffff,%eax
 761:	74 18                	je     77b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 763:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 766:	83 c0 08             	add    $0x8,%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 cf fe ff ff       	call   640 <free>
  return freep;
 771:	8b 0d fc 07 00 00    	mov    0x7fc,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 777:	85 c9                	test   %ecx,%ecx
 779:	75 97                	jne    712 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 77b:	31 c0                	xor    %eax,%eax
 77d:	eb b4                	jmp    733 <malloc+0x63>
 77f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 780:	8b 10                	mov    (%eax),%edx
 782:	89 11                	mov    %edx,(%ecx)
 784:	eb a4                	jmp    72a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 786:	c7 05 fc 07 00 00 f4 	movl   $0x7f4,0x7fc
 78d:	07 00 00 
    base.s.size = 0;
 790:	b9 f4 07 00 00       	mov    $0x7f4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 795:	c7 05 f4 07 00 00 f4 	movl   $0x7f4,0x7f4
 79c:	07 00 00 
    base.s.size = 0;
 79f:	c7 05 f8 07 00 00 00 	movl   $0x0,0x7f8
 7a6:	00 00 00 
 7a9:	e9 45 ff ff ff       	jmp    6f3 <malloc+0x23>
