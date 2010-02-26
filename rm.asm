
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
  42:	c7 44 24 04 62 07 00 	movl   $0x762,0x4(%esp)
  49:	00 
  4a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  51:	89 44 24 08          	mov    %eax,0x8(%esp)
  55:	e8 e6 03 00 00       	call   440 <printf>
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
  60:	c7 44 24 04 4e 07 00 	movl   $0x74e,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 cc 03 00 00       	call   440 <printf>
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

00000380 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 28             	sub    $0x28,%esp
 386:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 389:	8d 55 f4             	lea    -0xc(%ebp),%edx
 38c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 393:	00 
 394:	89 54 24 04          	mov    %edx,0x4(%esp)
 398:	89 04 24             	mov    %eax,(%esp)
 39b:	e8 38 ff ff ff       	call   2d8 <write>
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    
 3a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	89 c7                	mov    %eax,%edi
 3b6:	56                   	push   %esi
 3b7:	89 ce                	mov    %ecx,%esi
 3b9:	53                   	push   %ebx
 3ba:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3c0:	85 c9                	test   %ecx,%ecx
 3c2:	74 04                	je     3c8 <printint+0x18>
 3c4:	85 d2                	test   %edx,%edx
 3c6:	78 5d                	js     425 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3d1:	31 c9                	xor    %ecx,%ecx
 3d3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3d6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3d8:	31 d2                	xor    %edx,%edx
 3da:	f7 f6                	div    %esi
 3dc:	0f b6 92 82 07 00 00 	movzbl 0x782(%edx),%edx
 3e3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 3e6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 3e9:	85 c0                	test   %eax,%eax
 3eb:	75 eb                	jne    3d8 <printint+0x28>
  if(neg)
 3ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3f0:	85 c0                	test   %eax,%eax
 3f2:	74 08                	je     3fc <printint+0x4c>
    buf[i++] = '-';
 3f4:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3f9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 3fc:	8d 71 ff             	lea    -0x1(%ecx),%esi
 3ff:	01 f3                	add    %esi,%ebx
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 408:	0f be 13             	movsbl (%ebx),%edx
 40b:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40d:	83 ee 01             	sub    $0x1,%esi
 410:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 413:	e8 68 ff ff ff       	call   380 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 418:	83 fe ff             	cmp    $0xffffffff,%esi
 41b:	75 eb                	jne    408 <printint+0x58>
    putc(fd, buf[i]);
}
 41d:	83 c4 2c             	add    $0x2c,%esp
 420:	5b                   	pop    %ebx
 421:	5e                   	pop    %esi
 422:	5f                   	pop    %edi
 423:	5d                   	pop    %ebp
 424:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 425:	89 d0                	mov    %edx,%eax
 427:	f7 d8                	neg    %eax
 429:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 430:	eb 9f                	jmp    3d1 <printint+0x21>
 432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 44f:	0f b6 08             	movzbl (%eax),%ecx
 452:	84 c9                	test   %cl,%cl
 454:	0f 84 96 00 00 00    	je     4f0 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 45a:	8d 55 10             	lea    0x10(%ebp),%edx
 45d:	31 f6                	xor    %esi,%esi
 45f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 462:	31 db                	xor    %ebx,%ebx
 464:	eb 1a                	jmp    480 <printf+0x40>
 466:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 468:	83 f9 25             	cmp    $0x25,%ecx
 46b:	0f 85 87 00 00 00    	jne    4f8 <printf+0xb8>
 471:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 475:	83 c3 01             	add    $0x1,%ebx
 478:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 47c:	84 c9                	test   %cl,%cl
 47e:	74 70                	je     4f0 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 480:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 482:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 485:	74 e1                	je     468 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 487:	83 fe 25             	cmp    $0x25,%esi
 48a:	75 e9                	jne    475 <printf+0x35>
      if(c == 'd'){
 48c:	83 f9 64             	cmp    $0x64,%ecx
 48f:	90                   	nop
 490:	0f 84 fa 00 00 00    	je     590 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 496:	83 f9 70             	cmp    $0x70,%ecx
 499:	74 75                	je     510 <printf+0xd0>
 49b:	83 f9 78             	cmp    $0x78,%ecx
 49e:	66 90                	xchg   %ax,%ax
 4a0:	74 6e                	je     510 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a2:	83 f9 73             	cmp    $0x73,%ecx
 4a5:	0f 84 8d 00 00 00    	je     538 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ab:	83 f9 63             	cmp    $0x63,%ecx
 4ae:	66 90                	xchg   %ax,%ax
 4b0:	0f 84 fe 00 00 00    	je     5b4 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b6:	83 f9 25             	cmp    $0x25,%ecx
 4b9:	0f 84 b9 00 00 00    	je     578 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4bf:	ba 25 00 00 00       	mov    $0x25,%edx
 4c4:	89 f8                	mov    %edi,%eax
 4c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4cc:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ce:	e8 ad fe ff ff       	call   380 <putc>
        putc(fd, c);
 4d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 4d6:	89 f8                	mov    %edi,%eax
 4d8:	0f be d1             	movsbl %cl,%edx
 4db:	e8 a0 fe ff ff       	call   380 <putc>
 4e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e3:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 4e7:	84 c9                	test   %cl,%cl
 4e9:	75 95                	jne    480 <printf+0x40>
 4eb:	90                   	nop
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
 4f0:	83 c4 2c             	add    $0x2c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4f8:	89 f8                	mov    %edi,%eax
 4fa:	0f be d1             	movsbl %cl,%edx
 4fd:	e8 7e fe ff ff       	call   380 <putc>
 502:	8b 45 0c             	mov    0xc(%ebp),%eax
 505:	e9 6b ff ff ff       	jmp    475 <printf+0x35>
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 510:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 513:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 518:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 51a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 521:	8b 10                	mov    (%eax),%edx
 523:	89 f8                	mov    %edi,%eax
 525:	e8 86 fe ff ff       	call   3b0 <printint>
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 52d:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 531:	e9 3f ff ff ff       	jmp    475 <printf+0x35>
 536:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 53b:	8b 32                	mov    (%edx),%esi
        ap++;
 53d:	83 c2 04             	add    $0x4,%edx
 540:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 543:	85 f6                	test   %esi,%esi
 545:	0f 84 84 00 00 00    	je     5cf <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 54b:	0f b6 16             	movzbl (%esi),%edx
 54e:	84 d2                	test   %dl,%dl
 550:	74 1d                	je     56f <printf+0x12f>
 552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 558:	0f be d2             	movsbl %dl,%edx
          s++;
 55b:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 55e:	89 f8                	mov    %edi,%eax
 560:	e8 1b fe ff ff       	call   380 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 565:	0f b6 16             	movzbl (%esi),%edx
 568:	84 d2                	test   %dl,%dl
 56a:	75 ec                	jne    558 <printf+0x118>
 56c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 56f:	31 f6                	xor    %esi,%esi
 571:	e9 ff fe ff ff       	jmp    475 <printf+0x35>
 576:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 578:	89 f8                	mov    %edi,%eax
 57a:	ba 25 00 00 00       	mov    $0x25,%edx
 57f:	e8 fc fd ff ff       	call   380 <putc>
 584:	31 f6                	xor    %esi,%esi
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	e9 e7 fe ff ff       	jmp    475 <printf+0x35>
 58e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	b1 0a                	mov    $0xa,%cl
        ap++;
 595:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 598:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 59f:	8b 10                	mov    (%eax),%edx
 5a1:	89 f8                	mov    %edi,%eax
 5a3:	e8 08 fe ff ff       	call   3b0 <printint>
 5a8:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5ab:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 5af:	e9 c1 fe ff ff       	jmp    475 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 5b7:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 5b9:	0f be 10             	movsbl (%eax),%edx
 5bc:	89 f8                	mov    %edi,%eax
 5be:	e8 bd fd ff ff       	call   380 <putc>
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5c6:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 5ca:	e9 a6 fe ff ff       	jmp    475 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 5cf:	be 7b 07 00 00       	mov    $0x77b,%esi
 5d4:	e9 72 ff ff ff       	jmp    54b <printf+0x10b>
 5d9:	90                   	nop
 5da:	90                   	nop
 5db:	90                   	nop
 5dc:	90                   	nop
 5dd:	90                   	nop
 5de:	90                   	nop
 5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 9c 07 00 00       	mov    0x79c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	39 c8                	cmp    %ecx,%eax
 5f3:	73 1d                	jae    612 <free+0x32>
 5f5:	8d 76 00             	lea    0x0(%esi),%esi
 5f8:	8b 10                	mov    (%eax),%edx
 5fa:	39 d1                	cmp    %edx,%ecx
 5fc:	72 1a                	jb     618 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fe:	39 d0                	cmp    %edx,%eax
 600:	72 08                	jb     60a <free+0x2a>
 602:	39 c8                	cmp    %ecx,%eax
 604:	72 12                	jb     618 <free+0x38>
 606:	39 d1                	cmp    %edx,%ecx
 608:	72 0e                	jb     618 <free+0x38>
 60a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	66 90                	xchg   %ax,%ax
 610:	72 e6                	jb     5f8 <free+0x18>
 612:	8b 10                	mov    (%eax),%edx
 614:	eb e8                	jmp    5fe <free+0x1e>
 616:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 618:	8b 71 04             	mov    0x4(%ecx),%esi
 61b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61e:	39 d7                	cmp    %edx,%edi
 620:	74 19                	je     63b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 622:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62b:	39 ce                	cmp    %ecx,%esi
 62d:	74 21                	je     650 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 62f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 631:	a3 9c 07 00 00       	mov    %eax,0x79c
}
 636:	5b                   	pop    %ebx
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 63b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 63e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 640:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 643:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 646:	8b 50 04             	mov    0x4(%eax),%edx
 649:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 64c:	39 ce                	cmp    %ecx,%esi
 64e:	75 df                	jne    62f <free+0x4f>
    p->s.size += bp->s.size;
 650:	03 51 04             	add    0x4(%ecx),%edx
 653:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 656:	8b 53 f8             	mov    -0x8(%ebx),%edx
 659:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 65b:	a3 9c 07 00 00       	mov    %eax,0x79c
}
 660:	5b                   	pop    %ebx
 661:	5e                   	pop    %esi
 662:	5f                   	pop    %edi
 663:	5d                   	pop    %ebp
 664:	c3                   	ret    
 665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 67c:	8b 0d 9c 07 00 00    	mov    0x79c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	83 c3 07             	add    $0x7,%ebx
 685:	c1 eb 03             	shr    $0x3,%ebx
 688:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 68b:	85 c9                	test   %ecx,%ecx
 68d:	0f 84 93 00 00 00    	je     726 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 695:	8b 50 04             	mov    0x4(%eax),%edx
 698:	39 d3                	cmp    %edx,%ebx
 69a:	76 1f                	jbe    6bb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 69c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 6a8:	3b 05 9c 07 00 00    	cmp    0x79c,%eax
 6ae:	74 30                	je     6e0 <malloc+0x70>
 6b0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 6b4:	8b 50 04             	mov    0x4(%eax),%edx
 6b7:	39 d3                	cmp    %edx,%ebx
 6b9:	77 ed                	ja     6a8 <malloc+0x38>
      if(p->s.size == nunits)
 6bb:	39 d3                	cmp    %edx,%ebx
 6bd:	74 61                	je     720 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6bf:	29 da                	sub    %ebx,%edx
 6c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6c4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6c7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6ca:	89 0d 9c 07 00 00    	mov    %ecx,0x79c
      return (void*) (p + 1);
 6d0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6d3:	83 c4 1c             	add    $0x1c,%esp
 6d6:	5b                   	pop    %ebx
 6d7:	5e                   	pop    %esi
 6d8:	5f                   	pop    %edi
 6d9:	5d                   	pop    %ebp
 6da:	c3                   	ret    
 6db:	90                   	nop
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 6e0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 6e6:	b8 00 80 00 00       	mov    $0x8000,%eax
 6eb:	bf 00 10 00 00       	mov    $0x1000,%edi
 6f0:	76 04                	jbe    6f6 <malloc+0x86>
 6f2:	89 f0                	mov    %esi,%eax
 6f4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 6f6:	89 04 24             	mov    %eax,(%esp)
 6f9:	e8 42 fc ff ff       	call   340 <sbrk>
  if(p == (char*) -1)
 6fe:	83 f8 ff             	cmp    $0xffffffff,%eax
 701:	74 18                	je     71b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 703:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 706:	83 c0 08             	add    $0x8,%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 cf fe ff ff       	call   5e0 <free>
  return freep;
 711:	8b 0d 9c 07 00 00    	mov    0x79c,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 717:	85 c9                	test   %ecx,%ecx
 719:	75 97                	jne    6b2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 71b:	31 c0                	xor    %eax,%eax
 71d:	eb b4                	jmp    6d3 <malloc+0x63>
 71f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 720:	8b 10                	mov    (%eax),%edx
 722:	89 11                	mov    %edx,(%ecx)
 724:	eb a4                	jmp    6ca <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 726:	c7 05 9c 07 00 00 94 	movl   $0x794,0x79c
 72d:	07 00 00 
    base.s.size = 0;
 730:	b9 94 07 00 00       	mov    $0x794,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 735:	c7 05 94 07 00 00 94 	movl   $0x794,0x794
 73c:	07 00 00 
    base.s.size = 0;
 73f:	c7 05 98 07 00 00 00 	movl   $0x0,0x798
 746:	00 00 00 
 749:	e9 45 ff ff ff       	jmp    693 <malloc+0x23>
