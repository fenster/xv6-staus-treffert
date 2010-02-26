
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   a:	eb 1c                	jmp    28 <cat+0x28>
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    write(1, buf, n);
  10:	89 44 24 08          	mov    %eax,0x8(%esp)
  14:	c7 44 24 04 40 08 00 	movl   $0x840,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 40 03 00 00       	call   368 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2f:	00 
  30:	c7 44 24 04 40 08 00 	movl   $0x840,0x4(%esp)
  37:	00 
  38:	89 1c 24             	mov    %ebx,(%esp)
  3b:	e8 20 03 00 00       	call   360 <read>
  40:	83 f8 00             	cmp    $0x0,%eax
  43:	7f cb                	jg     10 <cat+0x10>
    write(1, buf, n);
  if(n < 0){
  45:	75 0a                	jne    51 <cat+0x51>
    printf(1, "cat: read error\n");
    exit();
  }
}
  47:	83 c4 14             	add    $0x14,%esp
  4a:	5b                   	pop    %ebx
  4b:	5d                   	pop    %ebp
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  50:	c3                   	ret    
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "cat: read error\n");
  51:	c7 44 24 04 de 07 00 	movl   $0x7de,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 6b 04 00 00       	call   4d0 <printf>
    exit();
  65:	e8 de 02 00 00       	call   348 <exit>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000070 <main>:
  }
}

int
main(int argc, char *argv[])
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 e4 f0             	and    $0xfffffff0,%esp
  76:	57                   	push   %edi
  77:	56                   	push   %esi
  78:	53                   	push   %ebx
  79:	83 ec 24             	sub    $0x24,%esp
  7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
  7f:	83 ff 01             	cmp    $0x1,%edi
  82:	7e 6c                	jle    f0 <main+0x80>
    cat(0);
    exit();
  84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  87:	be 01 00 00 00       	mov    $0x1,%esi
  8c:	83 c3 04             	add    $0x4,%ebx
  8f:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  97:	00 
  98:	8b 03                	mov    (%ebx),%eax
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 e6 02 00 00       	call   388 <open>
  a2:	85 c0                	test   %eax,%eax
  a4:	78 2a                	js     d0 <main+0x60>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  a6:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  a9:	83 c6 01             	add    $0x1,%esi
  ac:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  af:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  b3:	e8 48 ff ff ff       	call   0 <cat>
    close(fd);
  b8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  bc:	89 04 24             	mov    %eax,(%esp)
  bf:	e8 ac 02 00 00       	call   370 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  c4:	39 f7                	cmp    %esi,%edi
  c6:	7f c8                	jg     90 <main+0x20>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  c8:	e8 7b 02 00 00       	call   348 <exit>
  cd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  d0:	8b 03                	mov    (%ebx),%eax
  d2:	c7 44 24 04 ef 07 00 	movl   $0x7ef,0x4(%esp)
  d9:	00 
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  e5:	e8 e6 03 00 00       	call   4d0 <printf>
      exit();
  ea:	e8 59 02 00 00       	call   348 <exit>
  ef:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
  f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f7:	e8 04 ff ff ff       	call   0 <cat>
    exit();
  fc:	e8 47 02 00 00       	call   348 <exit>
 101:	90                   	nop
 102:	90                   	nop
 103:	90                   	nop
 104:	90                   	nop
 105:	90                   	nop
 106:	90                   	nop
 107:	90                   	nop
 108:	90                   	nop
 109:	90                   	nop
 10a:	90                   	nop
 10b:	90                   	nop
 10c:	90                   	nop
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	31 d2                	xor    %edx,%edx
 113:	89 e5                	mov    %esp,%ebp
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	53                   	push   %ebx
 119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 124:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 c9                	test   %cl,%cl
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <strcmp>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 4d 08             	mov    0x8(%ebp),%ecx
 147:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14a:	0f b6 01             	movzbl (%ecx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 14                	jne    165 <strcmp+0x25>
 151:	eb 25                	jmp    178 <strcmp+0x38>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 158:	83 c1 01             	add    $0x1,%ecx
 15b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	84 c0                	test   %al,%al
 163:	74 13                	je     178 <strcmp+0x38>
 165:	0f b6 1a             	movzbl (%edx),%ebx
 168:	38 d8                	cmp    %bl,%al
 16a:	74 ec                	je     158 <strcmp+0x18>
 16c:	0f b6 db             	movzbl %bl,%ebx
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	0f b6 1a             	movzbl (%edx),%ebx
 17b:	31 c0                	xor    %eax,%eax
 17d:	0f b6 db             	movzbl %bl,%ebx
 180:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 195:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 39 00             	cmpb   $0x0,(%ecx)
 19d:	74 0c                	je     1ab <strlen+0x1b>
 19f:	90                   	nop
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1b6:	53                   	push   %ebx
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ba:	85 c9                	test   %ecx,%ecx
 1bc:	74 14                	je     1d2 <memset+0x22>
 1be:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 1c2:	31 d2                	xor    %edx,%edx
 1c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 1c8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 1cb:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 1ce:	39 ca                	cmp    %ecx,%edx
 1d0:	75 f6                	jne    1c8 <memset+0x18>
    *d++ = c;
  return dst;
}
 1d2:	5b                   	pop    %ebx
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    
 1d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 11                	jne    202 <strchr+0x22>
 1f1:	eb 15                	jmp    208 <strchr+0x28>
 1f3:	90                   	nop
 1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 06                	je     208 <strchr+0x28>
    if(*s == c)
 202:	38 ca                	cmp    %cl,%dl
 204:	75 f2                	jne    1f8 <strchr+0x18>
      return (char*) s;
  return 0;
}
 206:	5d                   	pop    %ebp
 207:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 208:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 20a:	5d                   	pop    %ebp
 20b:	90                   	nop
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	c3                   	ret    
 211:	eb 0d                	jmp    220 <atoi>
 213:	90                   	nop
 214:	90                   	nop
 215:	90                   	nop
 216:	90                   	nop
 217:	90                   	nop
 218:	90                   	nop
 219:	90                   	nop
 21a:	90                   	nop
 21b:	90                   	nop
 21c:	90                   	nop
 21d:	90                   	nop
 21e:	90                   	nop
 21f:	90                   	nop

00000220 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 221:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 223:	89 e5                	mov    %esp,%ebp
 225:	8b 4d 08             	mov    0x8(%ebp),%ecx
 228:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 229:	0f b6 11             	movzbl (%ecx),%edx
 22c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 22f:	80 fb 09             	cmp    $0x9,%bl
 232:	77 1c                	ja     250 <atoi+0x30>
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 238:	0f be d2             	movsbl %dl,%edx
 23b:	83 c1 01             	add    $0x1,%ecx
 23e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 241:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 245:	0f b6 11             	movzbl (%ecx),%edx
 248:	8d 5a d0             	lea    -0x30(%edx),%ebx
 24b:	80 fb 09             	cmp    $0x9,%bl
 24e:	76 e8                	jbe    238 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 250:	5b                   	pop    %ebx
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	53                   	push   %ebx
 268:	8b 5d 10             	mov    0x10(%ebp),%ebx
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 db                	test   %ebx,%ebx
 270:	7e 14                	jle    286 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 272:	31 d2                	xor    %edx,%edx
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 278:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 27c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 27f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	39 da                	cmp    %ebx,%edx
 284:	75 f2                	jne    278 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 286:	5b                   	pop    %ebx
 287:	5e                   	pop    %esi
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 296:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 299:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 29c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 29f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ab:	00 
 2ac:	89 04 24             	mov    %eax,(%esp)
 2af:	e8 d4 00 00 00       	call   388 <open>
  if(fd < 0)
 2b4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2b8:	78 19                	js     2d3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 1c 24             	mov    %ebx,(%esp)
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	e8 d7 00 00 00       	call   3a0 <fstat>
  close(fd);
 2c9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 2cc:	89 c6                	mov    %eax,%esi
  close(fd);
 2ce:	e8 9d 00 00 00       	call   370 <close>
  return r;
}
 2d3:	89 f0                	mov    %esi,%eax
 2d5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 2d8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 2db:	89 ec                	mov    %ebp,%esp
 2dd:	5d                   	pop    %ebp
 2de:	c3                   	ret    
 2df:	90                   	nop

000002e0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
 2e5:	31 f6                	xor    %esi,%esi
 2e7:	53                   	push   %ebx
 2e8:	83 ec 2c             	sub    $0x2c,%esp
 2eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ee:	eb 06                	jmp    2f6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f0:	3c 0a                	cmp    $0xa,%al
 2f2:	74 39                	je     32d <gets+0x4d>
 2f4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f6:	8d 5e 01             	lea    0x1(%esi),%ebx
 2f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2fc:	7d 31                	jge    32f <gets+0x4f>
    cc = read(0, &c, 1);
 2fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 301:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 308:	00 
 309:	89 44 24 04          	mov    %eax,0x4(%esp)
 30d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 314:	e8 47 00 00 00       	call   360 <read>
    if(cc < 1)
 319:	85 c0                	test   %eax,%eax
 31b:	7e 12                	jle    32f <gets+0x4f>
      break;
    buf[i++] = c;
 31d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 321:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 325:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 329:	3c 0d                	cmp    $0xd,%al
 32b:	75 c3                	jne    2f0 <gets+0x10>
 32d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 32f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 333:	89 f8                	mov    %edi,%eax
 335:	83 c4 2c             	add    $0x2c,%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	90                   	nop
 33e:	90                   	nop
 33f:	90                   	nop

00000340 <fork>:
 340:	b8 01 00 00 00       	mov    $0x1,%eax
 345:	cd 30                	int    $0x30
 347:	c3                   	ret    

00000348 <exit>:
 348:	b8 02 00 00 00       	mov    $0x2,%eax
 34d:	cd 30                	int    $0x30
 34f:	c3                   	ret    

00000350 <wait>:
 350:	b8 03 00 00 00       	mov    $0x3,%eax
 355:	cd 30                	int    $0x30
 357:	c3                   	ret    

00000358 <pipe>:
 358:	b8 04 00 00 00       	mov    $0x4,%eax
 35d:	cd 30                	int    $0x30
 35f:	c3                   	ret    

00000360 <read>:
 360:	b8 06 00 00 00       	mov    $0x6,%eax
 365:	cd 30                	int    $0x30
 367:	c3                   	ret    

00000368 <write>:
 368:	b8 05 00 00 00       	mov    $0x5,%eax
 36d:	cd 30                	int    $0x30
 36f:	c3                   	ret    

00000370 <close>:
 370:	b8 07 00 00 00       	mov    $0x7,%eax
 375:	cd 30                	int    $0x30
 377:	c3                   	ret    

00000378 <kill>:
 378:	b8 08 00 00 00       	mov    $0x8,%eax
 37d:	cd 30                	int    $0x30
 37f:	c3                   	ret    

00000380 <exec>:
 380:	b8 09 00 00 00       	mov    $0x9,%eax
 385:	cd 30                	int    $0x30
 387:	c3                   	ret    

00000388 <open>:
 388:	b8 0a 00 00 00       	mov    $0xa,%eax
 38d:	cd 30                	int    $0x30
 38f:	c3                   	ret    

00000390 <mknod>:
 390:	b8 0b 00 00 00       	mov    $0xb,%eax
 395:	cd 30                	int    $0x30
 397:	c3                   	ret    

00000398 <unlink>:
 398:	b8 0c 00 00 00       	mov    $0xc,%eax
 39d:	cd 30                	int    $0x30
 39f:	c3                   	ret    

000003a0 <fstat>:
 3a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a5:	cd 30                	int    $0x30
 3a7:	c3                   	ret    

000003a8 <link>:
 3a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ad:	cd 30                	int    $0x30
 3af:	c3                   	ret    

000003b0 <mkdir>:
 3b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b5:	cd 30                	int    $0x30
 3b7:	c3                   	ret    

000003b8 <chdir>:
 3b8:	b8 10 00 00 00       	mov    $0x10,%eax
 3bd:	cd 30                	int    $0x30
 3bf:	c3                   	ret    

000003c0 <dup>:
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 30                	int    $0x30
 3c7:	c3                   	ret    

000003c8 <getpid>:
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 30                	int    $0x30
 3cf:	c3                   	ret    

000003d0 <sbrk>:
 3d0:	b8 13 00 00 00       	mov    $0x13,%eax
 3d5:	cd 30                	int    $0x30
 3d7:	c3                   	ret    

000003d8 <sleep>:
 3d8:	b8 14 00 00 00       	mov    $0x14,%eax
 3dd:	cd 30                	int    $0x30
 3df:	c3                   	ret    

000003e0 <tick>:
 3e0:	b8 15 00 00 00       	mov    $0x15,%eax
 3e5:	cd 30                	int    $0x30
 3e7:	c3                   	ret    

000003e8 <fork_tickets>:
 3e8:	b8 16 00 00 00       	mov    $0x16,%eax
 3ed:	cd 30                	int    $0x30
 3ef:	c3                   	ret    

000003f0 <fork_thread>:
 3f0:	b8 19 00 00 00       	mov    $0x19,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <wait_thread>:
 3f8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <sleep_lock>:
 400:	b8 17 00 00 00       	mov    $0x17,%eax
 405:	cd 30                	int    $0x30
 407:	c3                   	ret    

00000408 <wake_lock>:
 408:	b8 18 00 00 00       	mov    $0x18,%eax
 40d:	cd 30                	int    $0x30
 40f:	c3                   	ret    

00000410 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	83 ec 28             	sub    $0x28,%esp
 416:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 419:	8d 55 f4             	lea    -0xc(%ebp),%edx
 41c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 423:	00 
 424:	89 54 24 04          	mov    %edx,0x4(%esp)
 428:	89 04 24             	mov    %eax,(%esp)
 42b:	e8 38 ff ff ff       	call   368 <write>
}
 430:	c9                   	leave  
 431:	c3                   	ret    
 432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	89 c7                	mov    %eax,%edi
 446:	56                   	push   %esi
 447:	89 ce                	mov    %ecx,%esi
 449:	53                   	push   %ebx
 44a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 450:	85 c9                	test   %ecx,%ecx
 452:	74 04                	je     458 <printint+0x18>
 454:	85 d2                	test   %edx,%edx
 456:	78 5d                	js     4b5 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 458:	89 d0                	mov    %edx,%eax
 45a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 461:	31 c9                	xor    %ecx,%ecx
 463:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 466:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 468:	31 d2                	xor    %edx,%edx
 46a:	f7 f6                	div    %esi
 46c:	0f b6 92 0b 08 00 00 	movzbl 0x80b(%edx),%edx
 473:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 476:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 479:	85 c0                	test   %eax,%eax
 47b:	75 eb                	jne    468 <printint+0x28>
  if(neg)
 47d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 480:	85 c0                	test   %eax,%eax
 482:	74 08                	je     48c <printint+0x4c>
    buf[i++] = '-';
 484:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 489:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 48c:	8d 71 ff             	lea    -0x1(%ecx),%esi
 48f:	01 f3                	add    %esi,%ebx
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 498:	0f be 13             	movsbl (%ebx),%edx
 49b:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 49d:	83 ee 01             	sub    $0x1,%esi
 4a0:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 4a3:	e8 68 ff ff ff       	call   410 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a8:	83 fe ff             	cmp    $0xffffffff,%esi
 4ab:	75 eb                	jne    498 <printint+0x58>
    putc(fd, buf[i]);
}
 4ad:	83 c4 2c             	add    $0x2c,%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4b5:	89 d0                	mov    %edx,%eax
 4b7:	f7 d8                	neg    %eax
 4b9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 4c0:	eb 9f                	jmp    461 <printint+0x21>
 4c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
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
 4d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4df:	0f b6 08             	movzbl (%eax),%ecx
 4e2:	84 c9                	test   %cl,%cl
 4e4:	0f 84 96 00 00 00    	je     580 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ea:	8d 55 10             	lea    0x10(%ebp),%edx
 4ed:	31 f6                	xor    %esi,%esi
 4ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 4f2:	31 db                	xor    %ebx,%ebx
 4f4:	eb 1a                	jmp    510 <printf+0x40>
 4f6:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4f8:	83 f9 25             	cmp    $0x25,%ecx
 4fb:	0f 85 87 00 00 00    	jne    588 <printf+0xb8>
 501:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 505:	83 c3 01             	add    $0x1,%ebx
 508:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 50c:	84 c9                	test   %cl,%cl
 50e:	74 70                	je     580 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 510:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 512:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 515:	74 e1                	je     4f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 517:	83 fe 25             	cmp    $0x25,%esi
 51a:	75 e9                	jne    505 <printf+0x35>
      if(c == 'd'){
 51c:	83 f9 64             	cmp    $0x64,%ecx
 51f:	90                   	nop
 520:	0f 84 fa 00 00 00    	je     620 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 526:	83 f9 70             	cmp    $0x70,%ecx
 529:	74 75                	je     5a0 <printf+0xd0>
 52b:	83 f9 78             	cmp    $0x78,%ecx
 52e:	66 90                	xchg   %ax,%ax
 530:	74 6e                	je     5a0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 532:	83 f9 73             	cmp    $0x73,%ecx
 535:	0f 84 8d 00 00 00    	je     5c8 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53b:	83 f9 63             	cmp    $0x63,%ecx
 53e:	66 90                	xchg   %ax,%ax
 540:	0f 84 fe 00 00 00    	je     644 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 546:	83 f9 25             	cmp    $0x25,%ecx
 549:	0f 84 b9 00 00 00    	je     608 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54f:	ba 25 00 00 00       	mov    $0x25,%edx
 554:	89 f8                	mov    %edi,%eax
 556:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 559:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 55c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55e:	e8 ad fe ff ff       	call   410 <putc>
        putc(fd, c);
 563:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 566:	89 f8                	mov    %edi,%eax
 568:	0f be d1             	movsbl %cl,%edx
 56b:	e8 a0 fe ff ff       	call   410 <putc>
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 573:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 577:	84 c9                	test   %cl,%cl
 579:	75 95                	jne    510 <printf+0x40>
 57b:	90                   	nop
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
  //mutex_unlock(&plock);
}
 580:	83 c4 2c             	add    $0x2c,%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 588:	89 f8                	mov    %edi,%eax
 58a:	0f be d1             	movsbl %cl,%edx
 58d:	e8 7e fe ff ff       	call   410 <putc>
 592:	8b 45 0c             	mov    0xc(%ebp),%eax
 595:	e9 6b ff ff ff       	jmp    505 <printf+0x35>
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 5a8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5b1:	8b 10                	mov    (%eax),%edx
 5b3:	89 f8                	mov    %edi,%eax
 5b5:	e8 86 fe ff ff       	call   440 <printint>
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5bd:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 5c1:	e9 3f ff ff ff       	jmp    505 <printf+0x35>
 5c6:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 5c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5cb:	8b 32                	mov    (%edx),%esi
        ap++;
 5cd:	83 c2 04             	add    $0x4,%edx
 5d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 5d3:	85 f6                	test   %esi,%esi
 5d5:	0f 84 84 00 00 00    	je     65f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 5db:	0f b6 16             	movzbl (%esi),%edx
 5de:	84 d2                	test   %dl,%dl
 5e0:	74 1d                	je     5ff <printf+0x12f>
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 5e8:	0f be d2             	movsbl %dl,%edx
          s++;
 5eb:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 5ee:	89 f8                	mov    %edi,%eax
 5f0:	e8 1b fe ff ff       	call   410 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f5:	0f b6 16             	movzbl (%esi),%edx
 5f8:	84 d2                	test   %dl,%dl
 5fa:	75 ec                	jne    5e8 <printf+0x118>
 5fc:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5ff:	31 f6                	xor    %esi,%esi
 601:	e9 ff fe ff ff       	jmp    505 <printf+0x35>
 606:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 608:	89 f8                	mov    %edi,%eax
 60a:	ba 25 00 00 00       	mov    $0x25,%edx
 60f:	e8 fc fd ff ff       	call   410 <putc>
 614:	31 f6                	xor    %esi,%esi
 616:	8b 45 0c             	mov    0xc(%ebp),%eax
 619:	e9 e7 fe ff ff       	jmp    505 <printf+0x35>
 61e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 623:	b1 0a                	mov    $0xa,%cl
        ap++;
 625:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 628:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 62f:	8b 10                	mov    (%eax),%edx
 631:	89 f8                	mov    %edi,%eax
 633:	e8 08 fe ff ff       	call   440 <printint>
 638:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 63b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 63f:	e9 c1 fe ff ff       	jmp    505 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 644:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 647:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 649:	0f be 10             	movsbl (%eax),%edx
 64c:	89 f8                	mov    %edi,%eax
 64e:	e8 bd fd ff ff       	call   410 <putc>
 653:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 656:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 65a:	e9 a6 fe ff ff       	jmp    505 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 65f:	be 04 08 00 00       	mov    $0x804,%esi
 664:	e9 72 ff ff ff       	jmp    5db <printf+0x10b>
 669:	90                   	nop
 66a:	90                   	nop
 66b:	90                   	nop
 66c:	90                   	nop
 66d:	90                   	nop
 66e:	90                   	nop
 66f:	90                   	nop

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 28 08 00 00       	mov    0x828,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	39 c8                	cmp    %ecx,%eax
 683:	73 1d                	jae    6a2 <free+0x32>
 685:	8d 76 00             	lea    0x0(%esi),%esi
 688:	8b 10                	mov    (%eax),%edx
 68a:	39 d1                	cmp    %edx,%ecx
 68c:	72 1a                	jb     6a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68e:	39 d0                	cmp    %edx,%eax
 690:	72 08                	jb     69a <free+0x2a>
 692:	39 c8                	cmp    %ecx,%eax
 694:	72 12                	jb     6a8 <free+0x38>
 696:	39 d1                	cmp    %edx,%ecx
 698:	72 0e                	jb     6a8 <free+0x38>
 69a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	39 c8                	cmp    %ecx,%eax
 69e:	66 90                	xchg   %ax,%ax
 6a0:	72 e6                	jb     688 <free+0x18>
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	eb e8                	jmp    68e <free+0x1e>
 6a6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 71 04             	mov    0x4(%ecx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 d7                	cmp    %edx,%edi
 6b0:	74 19                	je     6cb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6bb:	39 ce                	cmp    %ecx,%esi
 6bd:	74 21                	je     6e0 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6c1:	a3 28 08 00 00       	mov    %eax,0x828
}
 6c6:	5b                   	pop    %ebx
 6c7:	5e                   	pop    %esi
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cb:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 6ce:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d0:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d6:	8b 50 04             	mov    0x4(%eax),%edx
 6d9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6dc:	39 ce                	cmp    %ecx,%esi
 6de:	75 df                	jne    6bf <free+0x4f>
    p->s.size += bp->s.size;
 6e0:	03 51 04             	add    0x4(%ecx),%edx
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e9:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6eb:	a3 28 08 00 00       	mov    %eax,0x828
}
 6f0:	5b                   	pop    %ebx
 6f1:	5e                   	pop    %esi
 6f2:	5f                   	pop    %edi
 6f3:	5d                   	pop    %ebp
 6f4:	c3                   	ret    
 6f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 70c:	8b 0d 28 08 00 00    	mov    0x828,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	83 c3 07             	add    $0x7,%ebx
 715:	c1 eb 03             	shr    $0x3,%ebx
 718:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 71b:	85 c9                	test   %ecx,%ecx
 71d:	0f 84 93 00 00 00    	je     7b6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 725:	8b 50 04             	mov    0x4(%eax),%edx
 728:	39 d3                	cmp    %edx,%ebx
 72a:	76 1f                	jbe    74b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 72c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 733:	90                   	nop
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 738:	3b 05 28 08 00 00    	cmp    0x828,%eax
 73e:	74 30                	je     770 <malloc+0x70>
 740:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 742:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 744:	8b 50 04             	mov    0x4(%eax),%edx
 747:	39 d3                	cmp    %edx,%ebx
 749:	77 ed                	ja     738 <malloc+0x38>
      if(p->s.size == nunits)
 74b:	39 d3                	cmp    %edx,%ebx
 74d:	74 61                	je     7b0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 74f:	29 da                	sub    %ebx,%edx
 751:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 754:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 757:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 75a:	89 0d 28 08 00 00    	mov    %ecx,0x828
      return (void*) (p + 1);
 760:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 763:	83 c4 1c             	add    $0x1c,%esp
 766:	5b                   	pop    %ebx
 767:	5e                   	pop    %esi
 768:	5f                   	pop    %edi
 769:	5d                   	pop    %ebp
 76a:	c3                   	ret    
 76b:	90                   	nop
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 770:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 776:	b8 00 80 00 00       	mov    $0x8000,%eax
 77b:	bf 00 10 00 00       	mov    $0x1000,%edi
 780:	76 04                	jbe    786 <malloc+0x86>
 782:	89 f0                	mov    %esi,%eax
 784:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 786:	89 04 24             	mov    %eax,(%esp)
 789:	e8 42 fc ff ff       	call   3d0 <sbrk>
  if(p == (char*) -1)
 78e:	83 f8 ff             	cmp    $0xffffffff,%eax
 791:	74 18                	je     7ab <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 793:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 796:	83 c0 08             	add    $0x8,%eax
 799:	89 04 24             	mov    %eax,(%esp)
 79c:	e8 cf fe ff ff       	call   670 <free>
  return freep;
 7a1:	8b 0d 28 08 00 00    	mov    0x828,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7a7:	85 c9                	test   %ecx,%ecx
 7a9:	75 97                	jne    742 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7ab:	31 c0                	xor    %eax,%eax
 7ad:	eb b4                	jmp    763 <malloc+0x63>
 7af:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	89 11                	mov    %edx,(%ecx)
 7b4:	eb a4                	jmp    75a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7b6:	c7 05 28 08 00 00 20 	movl   $0x820,0x828
 7bd:	08 00 00 
    base.s.size = 0;
 7c0:	b9 20 08 00 00       	mov    $0x820,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7c5:	c7 05 20 08 00 00 20 	movl   $0x820,0x820
 7cc:	08 00 00 
    base.s.size = 0;
 7cf:	c7 05 24 08 00 00 00 	movl   $0x0,0x824
 7d6:	00 00 00 
 7d9:	e9 45 ff ff ff       	jmp    723 <malloc+0x23>
