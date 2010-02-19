
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
  51:	c7 44 24 04 ce 07 00 	movl   $0x7ce,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 5b 04 00 00       	call   4c0 <printf>
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
  d2:	c7 44 24 04 df 07 00 	movl   $0x7df,0x4(%esp)
  d9:	00 
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  e5:	e8 d6 03 00 00       	call   4c0 <printf>
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
 3f0:	b8 17 00 00 00       	mov    $0x17,%eax
 3f5:	cd 30                	int    $0x30
 3f7:	c3                   	ret    

000003f8 <wait_thread>:
 3f8:	b8 18 00 00 00       	mov    $0x18,%eax
 3fd:	cd 30                	int    $0x30
 3ff:	c3                   	ret    

00000400 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 28             	sub    $0x28,%esp
 406:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 409:	8d 55 f4             	lea    -0xc(%ebp),%edx
 40c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 413:	00 
 414:	89 54 24 04          	mov    %edx,0x4(%esp)
 418:	89 04 24             	mov    %eax,(%esp)
 41b:	e8 48 ff ff ff       	call   368 <write>
}
 420:	c9                   	leave  
 421:	c3                   	ret    
 422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	89 c7                	mov    %eax,%edi
 436:	56                   	push   %esi
 437:	89 ce                	mov    %ecx,%esi
 439:	53                   	push   %ebx
 43a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 440:	85 c9                	test   %ecx,%ecx
 442:	74 04                	je     448 <printint+0x18>
 444:	85 d2                	test   %edx,%edx
 446:	78 5d                	js     4a5 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 448:	89 d0                	mov    %edx,%eax
 44a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 451:	31 c9                	xor    %ecx,%ecx
 453:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 456:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 458:	31 d2                	xor    %edx,%edx
 45a:	f7 f6                	div    %esi
 45c:	0f b6 92 fb 07 00 00 	movzbl 0x7fb(%edx),%edx
 463:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 466:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 469:	85 c0                	test   %eax,%eax
 46b:	75 eb                	jne    458 <printint+0x28>
  if(neg)
 46d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 470:	85 c0                	test   %eax,%eax
 472:	74 08                	je     47c <printint+0x4c>
    buf[i++] = '-';
 474:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 479:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 47c:	8d 71 ff             	lea    -0x1(%ecx),%esi
 47f:	01 f3                	add    %esi,%ebx
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 488:	0f be 13             	movsbl (%ebx),%edx
 48b:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48d:	83 ee 01             	sub    $0x1,%esi
 490:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 493:	e8 68 ff ff ff       	call   400 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 498:	83 fe ff             	cmp    $0xffffffff,%esi
 49b:	75 eb                	jne    488 <printint+0x58>
    putc(fd, buf[i]);
}
 49d:	83 c4 2c             	add    $0x2c,%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4a5:	89 d0                	mov    %edx,%eax
 4a7:	f7 d8                	neg    %eax
 4a9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 4b0:	eb 9f                	jmp    451 <printint+0x21>
 4b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c9:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4cf:	0f b6 08             	movzbl (%eax),%ecx
 4d2:	84 c9                	test   %cl,%cl
 4d4:	0f 84 96 00 00 00    	je     570 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4da:	8d 55 10             	lea    0x10(%ebp),%edx
 4dd:	31 f6                	xor    %esi,%esi
 4df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 4e2:	31 db                	xor    %ebx,%ebx
 4e4:	eb 1a                	jmp    500 <printf+0x40>
 4e6:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4e8:	83 f9 25             	cmp    $0x25,%ecx
 4eb:	0f 85 87 00 00 00    	jne    578 <printf+0xb8>
 4f1:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f5:	83 c3 01             	add    $0x1,%ebx
 4f8:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 4fc:	84 c9                	test   %cl,%cl
 4fe:	74 70                	je     570 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 500:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 502:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 505:	74 e1                	je     4e8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 507:	83 fe 25             	cmp    $0x25,%esi
 50a:	75 e9                	jne    4f5 <printf+0x35>
      if(c == 'd'){
 50c:	83 f9 64             	cmp    $0x64,%ecx
 50f:	90                   	nop
 510:	0f 84 fa 00 00 00    	je     610 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 516:	83 f9 70             	cmp    $0x70,%ecx
 519:	74 75                	je     590 <printf+0xd0>
 51b:	83 f9 78             	cmp    $0x78,%ecx
 51e:	66 90                	xchg   %ax,%ax
 520:	74 6e                	je     590 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 522:	83 f9 73             	cmp    $0x73,%ecx
 525:	0f 84 8d 00 00 00    	je     5b8 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52b:	83 f9 63             	cmp    $0x63,%ecx
 52e:	66 90                	xchg   %ax,%ax
 530:	0f 84 fe 00 00 00    	je     634 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 536:	83 f9 25             	cmp    $0x25,%ecx
 539:	0f 84 b9 00 00 00    	je     5f8 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 53f:	ba 25 00 00 00       	mov    $0x25,%edx
 544:	89 f8                	mov    %edi,%eax
 546:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 549:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 54c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 54e:	e8 ad fe ff ff       	call   400 <putc>
        putc(fd, c);
 553:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 556:	89 f8                	mov    %edi,%eax
 558:	0f be d1             	movsbl %cl,%edx
 55b:	e8 a0 fe ff ff       	call   400 <putc>
 560:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 563:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 567:	84 c9                	test   %cl,%cl
 569:	75 95                	jne    500 <printf+0x40>
 56b:	90                   	nop
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 570:	83 c4 2c             	add    $0x2c,%esp
 573:	5b                   	pop    %ebx
 574:	5e                   	pop    %esi
 575:	5f                   	pop    %edi
 576:	5d                   	pop    %ebp
 577:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 578:	89 f8                	mov    %edi,%eax
 57a:	0f be d1             	movsbl %cl,%edx
 57d:	e8 7e fe ff ff       	call   400 <putc>
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	e9 6b ff ff ff       	jmp    4f5 <printf+0x35>
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 598:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 59a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5a1:	8b 10                	mov    (%eax),%edx
 5a3:	89 f8                	mov    %edi,%eax
 5a5:	e8 86 fe ff ff       	call   430 <printint>
 5aa:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 5ad:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 5b1:	e9 3f ff ff ff       	jmp    4f5 <printf+0x35>
 5b6:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 5b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5bb:	8b 32                	mov    (%edx),%esi
        ap++;
 5bd:	83 c2 04             	add    $0x4,%edx
 5c0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 5c3:	85 f6                	test   %esi,%esi
 5c5:	0f 84 84 00 00 00    	je     64f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 5cb:	0f b6 16             	movzbl (%esi),%edx
 5ce:	84 d2                	test   %dl,%dl
 5d0:	74 1d                	je     5ef <printf+0x12f>
 5d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 5d8:	0f be d2             	movsbl %dl,%edx
          s++;
 5db:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 5de:	89 f8                	mov    %edi,%eax
 5e0:	e8 1b fe ff ff       	call   400 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e5:	0f b6 16             	movzbl (%esi),%edx
 5e8:	84 d2                	test   %dl,%dl
 5ea:	75 ec                	jne    5d8 <printf+0x118>
 5ec:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5ef:	31 f6                	xor    %esi,%esi
 5f1:	e9 ff fe ff ff       	jmp    4f5 <printf+0x35>
 5f6:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 5f8:	89 f8                	mov    %edi,%eax
 5fa:	ba 25 00 00 00       	mov    $0x25,%edx
 5ff:	e8 fc fd ff ff       	call   400 <putc>
 604:	31 f6                	xor    %esi,%esi
 606:	8b 45 0c             	mov    0xc(%ebp),%eax
 609:	e9 e7 fe ff ff       	jmp    4f5 <printf+0x35>
 60e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 613:	b1 0a                	mov    $0xa,%cl
        ap++;
 615:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 618:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 61f:	8b 10                	mov    (%eax),%edx
 621:	89 f8                	mov    %edi,%eax
 623:	e8 08 fe ff ff       	call   430 <printint>
 628:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 62b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 62f:	e9 c1 fe ff ff       	jmp    4f5 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 637:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 639:	0f be 10             	movsbl (%eax),%edx
 63c:	89 f8                	mov    %edi,%eax
 63e:	e8 bd fd ff ff       	call   400 <putc>
 643:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 646:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 64a:	e9 a6 fe ff ff       	jmp    4f5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 64f:	be f4 07 00 00       	mov    $0x7f4,%esi
 654:	e9 72 ff ff ff       	jmp    5cb <printf+0x10b>
 659:	90                   	nop
 65a:	90                   	nop
 65b:	90                   	nop
 65c:	90                   	nop
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 28 08 00 00       	mov    0x828,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	39 c8                	cmp    %ecx,%eax
 673:	73 1d                	jae    692 <free+0x32>
 675:	8d 76 00             	lea    0x0(%esi),%esi
 678:	8b 10                	mov    (%eax),%edx
 67a:	39 d1                	cmp    %edx,%ecx
 67c:	72 1a                	jb     698 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	39 d0                	cmp    %edx,%eax
 680:	72 08                	jb     68a <free+0x2a>
 682:	39 c8                	cmp    %ecx,%eax
 684:	72 12                	jb     698 <free+0x38>
 686:	39 d1                	cmp    %edx,%ecx
 688:	72 0e                	jb     698 <free+0x38>
 68a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	66 90                	xchg   %ax,%ax
 690:	72 e6                	jb     678 <free+0x18>
 692:	8b 10                	mov    (%eax),%edx
 694:	eb e8                	jmp    67e <free+0x1e>
 696:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 71 04             	mov    0x4(%ecx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 d7                	cmp    %edx,%edi
 6a0:	74 19                	je     6bb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ab:	39 ce                	cmp    %ecx,%esi
 6ad:	74 21                	je     6d0 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6af:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6b1:	a3 28 08 00 00       	mov    %eax,0x828
}
 6b6:	5b                   	pop    %ebx
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6bb:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c0:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6cc:	39 ce                	cmp    %ecx,%esi
 6ce:	75 df                	jne    6af <free+0x4f>
    p->s.size += bp->s.size;
 6d0:	03 51 04             	add    0x4(%ecx),%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 6db:	a3 28 08 00 00       	mov    %eax,0x828
}
 6e0:	5b                   	pop    %ebx
 6e1:	5e                   	pop    %esi
 6e2:	5f                   	pop    %edi
 6e3:	5d                   	pop    %ebp
 6e4:	c3                   	ret    
 6e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 6fc:	8b 0d 28 08 00 00    	mov    0x828,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	83 c3 07             	add    $0x7,%ebx
 705:	c1 eb 03             	shr    $0x3,%ebx
 708:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 70b:	85 c9                	test   %ecx,%ecx
 70d:	0f 84 93 00 00 00    	je     7a6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 713:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	39 d3                	cmp    %edx,%ebx
 71a:	76 1f                	jbe    73b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 71c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 723:	90                   	nop
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 728:	3b 05 28 08 00 00    	cmp    0x828,%eax
 72e:	74 30                	je     760 <malloc+0x70>
 730:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 732:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 734:	8b 50 04             	mov    0x4(%eax),%edx
 737:	39 d3                	cmp    %edx,%ebx
 739:	77 ed                	ja     728 <malloc+0x38>
      if(p->s.size == nunits)
 73b:	39 d3                	cmp    %edx,%ebx
 73d:	74 61                	je     7a0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 73f:	29 da                	sub    %ebx,%edx
 741:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 744:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 747:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 74a:	89 0d 28 08 00 00    	mov    %ecx,0x828
      return (void*) (p + 1);
 750:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 753:	83 c4 1c             	add    $0x1c,%esp
 756:	5b                   	pop    %ebx
 757:	5e                   	pop    %esi
 758:	5f                   	pop    %edi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    
 75b:	90                   	nop
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 760:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 766:	b8 00 80 00 00       	mov    $0x8000,%eax
 76b:	bf 00 10 00 00       	mov    $0x1000,%edi
 770:	76 04                	jbe    776 <malloc+0x86>
 772:	89 f0                	mov    %esi,%eax
 774:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 52 fc ff ff       	call   3d0 <sbrk>
  if(p == (char*) -1)
 77e:	83 f8 ff             	cmp    $0xffffffff,%eax
 781:	74 18                	je     79b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 783:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 786:	83 c0 08             	add    $0x8,%eax
 789:	89 04 24             	mov    %eax,(%esp)
 78c:	e8 cf fe ff ff       	call   660 <free>
  return freep;
 791:	8b 0d 28 08 00 00    	mov    0x828,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 797:	85 c9                	test   %ecx,%ecx
 799:	75 97                	jne    732 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 79b:	31 c0                	xor    %eax,%eax
 79d:	eb b4                	jmp    753 <malloc+0x63>
 79f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	89 11                	mov    %edx,(%ecx)
 7a4:	eb a4                	jmp    74a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7a6:	c7 05 28 08 00 00 20 	movl   $0x820,0x828
 7ad:	08 00 00 
    base.s.size = 0;
 7b0:	b9 20 08 00 00       	mov    $0x820,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7b5:	c7 05 20 08 00 00 20 	movl   $0x820,0x820
 7bc:	08 00 00 
    base.s.size = 0;
 7bf:	c7 05 24 08 00 00 00 	movl   $0x0,0x824
 7c6:	00 00 00 
 7c9:	e9 45 ff ff ff       	jmp    713 <malloc+0x23>
