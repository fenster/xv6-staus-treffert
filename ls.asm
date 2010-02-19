
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	89 1c 24             	mov    %ebx,(%esp)
   e:	e8 cd 03 00 00       	call   3e0 <strlen>
  13:	01 d8                	add    %ebx,%eax
  15:	73 10                	jae    27 <fmtname+0x27>
  17:	eb 13                	jmp    2c <fmtname+0x2c>
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  20:	83 e8 01             	sub    $0x1,%eax
  23:	39 c3                	cmp    %eax,%ebx
  25:	77 05                	ja     2c <fmtname+0x2c>
  27:	80 38 2f             	cmpb   $0x2f,(%eax)
  2a:	75 f4                	jne    20 <fmtname+0x20>
    ;
  p++;
  2c:	8d 58 01             	lea    0x1(%eax),%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2f:	89 1c 24             	mov    %ebx,(%esp)
  32:	e8 a9 03 00 00       	call   3e0 <strlen>
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	77 53                	ja     8f <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  3c:	89 1c 24             	mov    %ebx,(%esp)
  3f:	e8 9c 03 00 00       	call   3e0 <strlen>
  44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  48:	c7 04 24 80 0a 00 00 	movl   $0xa80,(%esp)
  4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  53:	e8 58 04 00 00       	call   4b0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  58:	89 1c 24             	mov    %ebx,(%esp)
  5b:	e8 80 03 00 00       	call   3e0 <strlen>
  60:	89 1c 24             	mov    %ebx,(%esp)
  63:	bb 80 0a 00 00       	mov    $0xa80,%ebx
  68:	89 c6                	mov    %eax,%esi
  6a:	e8 71 03 00 00       	call   3e0 <strlen>
  6f:	ba 0e 00 00 00       	mov    $0xe,%edx
  74:	29 f2                	sub    %esi,%edx
  76:	89 54 24 08          	mov    %edx,0x8(%esp)
  7a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  81:	00 
  82:	05 80 0a 00 00       	add    $0xa80,%eax
  87:	89 04 24             	mov    %eax,(%esp)
  8a:	e8 71 03 00 00       	call   400 <memset>
  return buf;
}
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 d8                	mov    %ebx,%eax
  94:	5b                   	pop    %ebx
  95:	5e                   	pop    %esi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    
  98:	90                   	nop
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000a0 <ls>:

void
ls(char *path)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 3c 24             	mov    %edi,(%esp)
  ba:	e8 19 05 00 00       	call   5d8 <open>
  bf:	85 c0                	test   %eax,%eax
  c1:	89 c3                	mov    %eax,%ebx
  c3:	0f 88 c7 01 00 00    	js     290 <ls+0x1f0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
  c9:	8d 75 c8             	lea    -0x38(%ebp),%esi
  cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 18 05 00 00       	call   5f0 <fstat>
  d8:	85 c0                	test   %eax,%eax
  da:	0f 88 00 02 00 00    	js     2e0 <ls+0x240>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  e0:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  e4:	66 83 f8 01          	cmp    $0x1,%ax
  e8:	74 66                	je     150 <ls+0xb0>
  ea:	66 83 f8 02          	cmp    $0x2,%ax
  ee:	66 90                	xchg   %ax,%ax
  f0:	74 16                	je     108 <ls+0x68>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
  f2:	89 1c 24             	mov    %ebx,(%esp)
  f5:	e8 c6 04 00 00       	call   5c0 <close>
}
  fa:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }
  
  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 108:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 10b:	8b 75 cc             	mov    -0x34(%ebp),%esi
 10e:	89 3c 24             	mov    %edi,(%esp)
 111:	89 95 bc fd ff ff    	mov    %edx,-0x244(%ebp)
 117:	e8 e4 fe ff ff       	call   0 <fmtname>
 11c:	8b 95 bc fd ff ff    	mov    -0x244(%ebp),%edx
 122:	89 74 24 10          	mov    %esi,0x10(%esp)
 126:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 12d:	00 
 12e:	c7 44 24 04 46 0a 00 	movl   $0xa46,0x4(%esp)
 135:	00 
 136:	89 54 24 14          	mov    %edx,0x14(%esp)
 13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 141:	89 44 24 08          	mov    %eax,0x8(%esp)
 145:	e8 c6 05 00 00       	call   710 <printf>
    break;
 14a:	eb a6                	jmp    f2 <ls+0x52>
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 150:	89 3c 24             	mov    %edi,(%esp)
 153:	e8 88 02 00 00       	call   3e0 <strlen>
 158:	83 c0 10             	add    $0x10,%eax
 15b:	3d 00 02 00 00       	cmp    $0x200,%eax
 160:	0f 87 0a 01 00 00    	ja     270 <ls+0x1d0>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 166:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
 16c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 170:	8d 7d d8             	lea    -0x28(%ebp),%edi
 173:	89 04 24             	mov    %eax,(%esp)
 176:	e8 e5 01 00 00       	call   360 <strcpy>
    p = buf+strlen(buf);
 17b:	8d 95 c8 fd ff ff    	lea    -0x238(%ebp),%edx
 181:	89 14 24             	mov    %edx,(%esp)
 184:	e8 57 02 00 00       	call   3e0 <strlen>
 189:	8d 95 c8 fd ff ff    	lea    -0x238(%ebp),%edx
 18f:	8d 04 02             	lea    (%edx,%eax,1),%eax
    *p++ = '/';
 192:	c6 00 2f             	movb   $0x2f,(%eax)
 195:	83 c0 01             	add    $0x1,%eax
 198:	89 85 c4 fd ff ff    	mov    %eax,-0x23c(%ebp)
 19e:	66 90                	xchg   %ax,%ax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1a7:	00 
 1a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ac:	89 1c 24             	mov    %ebx,(%esp)
 1af:	e8 fc 03 00 00       	call   5b0 <read>
 1b4:	83 f8 10             	cmp    $0x10,%eax
 1b7:	0f 85 35 ff ff ff    	jne    f2 <ls+0x52>
      if(de.inum == 0)
 1bd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
 1c2:	74 dc                	je     1a0 <ls+0x100>
        continue;
      memmove(p, de.name, DIRSIZ);
 1c4:	8d 45 da             	lea    -0x26(%ebp),%eax
 1c7:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 1ce:	00 
 1cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d3:	8b 95 c4 fd ff ff    	mov    -0x23c(%ebp),%edx
 1d9:	89 14 24             	mov    %edx,(%esp)
 1dc:	e8 cf 02 00 00       	call   4b0 <memmove>
      p[DIRSIZ] = 0;
 1e1:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
      if(stat(buf, &st) < 0){
 1e7:	8d 95 c8 fd ff ff    	lea    -0x238(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 1ed:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      if(stat(buf, &st) < 0){
 1f1:	89 74 24 04          	mov    %esi,0x4(%esp)
 1f5:	89 14 24             	mov    %edx,(%esp)
 1f8:	e8 e3 02 00 00       	call   4e0 <stat>
 1fd:	85 c0                	test   %eax,%eax
 1ff:	0f 88 b3 00 00 00    	js     2b8 <ls+0x218>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 205:	0f bf 45 d0          	movswl -0x30(%ebp),%eax
 209:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 20c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 20f:	89 85 c0 fd ff ff    	mov    %eax,-0x240(%ebp)
 215:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	89 95 bc fd ff ff    	mov    %edx,-0x244(%ebp)
 224:	89 8d b8 fd ff ff    	mov    %ecx,-0x248(%ebp)
 22a:	e8 d1 fd ff ff       	call   0 <fmtname>
 22f:	8b 95 bc fd ff ff    	mov    -0x244(%ebp),%edx
 235:	89 54 24 14          	mov    %edx,0x14(%esp)
 239:	8b 8d b8 fd ff ff    	mov    -0x248(%ebp),%ecx
 23f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 243:	8b 95 c0 fd ff ff    	mov    -0x240(%ebp),%edx
 249:	89 44 24 08          	mov    %eax,0x8(%esp)
 24d:	c7 44 24 04 46 0a 00 	movl   $0xa46,0x4(%esp)
 254:	00 
 255:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 260:	e8 ab 04 00 00       	call   710 <printf>
 265:	e9 36 ff ff ff       	jmp    1a0 <ls+0x100>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 270:	c7 44 24 04 53 0a 00 	movl   $0xa53,0x4(%esp)
 277:	00 
 278:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 27f:	e8 8c 04 00 00       	call   710 <printf>
      break;
 284:	e9 69 fe ff ff       	jmp    f2 <ls+0x52>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 290:	89 7c 24 08          	mov    %edi,0x8(%esp)
 294:	c7 44 24 04 1e 0a 00 	movl   $0xa1e,0x4(%esp)
 29b:	00 
 29c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2a3:	e8 68 04 00 00       	call   710 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2a8:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	90                   	nop
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 2b8:	8d 85 c8 fd ff ff    	lea    -0x238(%ebp),%eax
 2be:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c2:	c7 44 24 04 32 0a 00 	movl   $0xa32,0x4(%esp)
 2c9:	00 
 2ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d1:	e8 3a 04 00 00       	call   710 <printf>
        continue;
 2d6:	e9 c5 fe ff ff       	jmp    1a0 <ls+0x100>
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 2e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2e4:	c7 44 24 04 32 0a 00 	movl   $0xa32,0x4(%esp)
 2eb:	00 
 2ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2f3:	e8 18 04 00 00       	call   710 <printf>
    close(fd);
 2f8:	89 1c 24             	mov    %ebx,(%esp)
 2fb:	e8 c0 02 00 00       	call   5c0 <close>
    return;
 300:	e9 f5 fd ff ff       	jmp    fa <ls+0x5a>
 305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 e4 f0             	and    $0xfffffff0,%esp
 316:	57                   	push   %edi
 317:	56                   	push   %esi
 318:	53                   	push   %ebx
  int i;

  if(argc < 2){
    ls(".");
    exit();
 319:	bb 01 00 00 00       	mov    $0x1,%ebx
  close(fd);
}

int
main(int argc, char *argv[])
{
 31e:	83 ec 14             	sub    $0x14,%esp
 321:	8b 75 08             	mov    0x8(%ebp),%esi
 324:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
 327:	83 fe 01             	cmp    $0x1,%esi
 32a:	7e 1c                	jle    348 <main+0x38>
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 330:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 333:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 62 fd ff ff       	call   a0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 33e:	39 de                	cmp    %ebx,%esi
 340:	7f ee                	jg     330 <main+0x20>
    ls(argv[i]);
  exit();
 342:	e8 51 02 00 00       	call   598 <exit>
 347:	90                   	nop
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
 348:	c7 04 24 66 0a 00 00 	movl   $0xa66,(%esp)
 34f:	e8 4c fd ff ff       	call   a0 <ls>
    exit();
 354:	e8 3f 02 00 00       	call   598 <exit>
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 360:	55                   	push   %ebp
 361:	31 d2                	xor    %edx,%edx
 363:	89 e5                	mov    %esp,%ebp
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	53                   	push   %ebx
 369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 370:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 374:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 377:	83 c2 01             	add    $0x1,%edx
 37a:	84 c9                	test   %cl,%cl
 37c:	75 f2                	jne    370 <strcpy+0x10>
    ;
  return os;
}
 37e:	5b                   	pop    %ebx
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
 381:	eb 0d                	jmp    390 <strcmp>
 383:	90                   	nop
 384:	90                   	nop
 385:	90                   	nop
 386:	90                   	nop
 387:	90                   	nop
 388:	90                   	nop
 389:	90                   	nop
 38a:	90                   	nop
 38b:	90                   	nop
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
 397:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 39a:	0f b6 01             	movzbl (%ecx),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 14                	jne    3b5 <strcmp+0x25>
 3a1:	eb 25                	jmp    3c8 <strcmp+0x38>
 3a3:	90                   	nop
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 3a8:	83 c1 01             	add    $0x1,%ecx
 3ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ae:	0f b6 01             	movzbl (%ecx),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	74 13                	je     3c8 <strcmp+0x38>
 3b5:	0f b6 1a             	movzbl (%edx),%ebx
 3b8:	38 d8                	cmp    %bl,%al
 3ba:	74 ec                	je     3a8 <strcmp+0x18>
 3bc:	0f b6 db             	movzbl %bl,%ebx
 3bf:	0f b6 c0             	movzbl %al,%eax
 3c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3c4:	5b                   	pop    %ebx
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c8:	0f b6 1a             	movzbl (%edx),%ebx
 3cb:	31 c0                	xor    %eax,%eax
 3cd:	0f b6 db             	movzbl %bl,%ebx
 3d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3d2:	5b                   	pop    %ebx
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strlen>:

uint
strlen(char *s)
{
 3e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ea:	80 39 00             	cmpb   $0x0,(%ecx)
 3ed:	74 0c                	je     3fb <strlen+0x1b>
 3ef:	90                   	nop
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	75 f5                	jne    3f0 <strlen+0x10>
    ;
  return n;
}
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 4d 10             	mov    0x10(%ebp),%ecx
 406:	53                   	push   %ebx
 407:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 40a:	85 c9                	test   %ecx,%ecx
 40c:	74 14                	je     422 <memset+0x22>
 40e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 412:	31 d2                	xor    %edx,%edx
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 418:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 41b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 41e:	39 ca                	cmp    %ecx,%edx
 420:	75 f6                	jne    418 <memset+0x18>
    *d++ = c;
  return dst;
}
 422:	5b                   	pop    %ebx
 423:	5d                   	pop    %ebp
 424:	c3                   	ret    
 425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 43a:	0f b6 10             	movzbl (%eax),%edx
 43d:	84 d2                	test   %dl,%dl
 43f:	75 11                	jne    452 <strchr+0x22>
 441:	eb 15                	jmp    458 <strchr+0x28>
 443:	90                   	nop
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 448:	83 c0 01             	add    $0x1,%eax
 44b:	0f b6 10             	movzbl (%eax),%edx
 44e:	84 d2                	test   %dl,%dl
 450:	74 06                	je     458 <strchr+0x28>
    if(*s == c)
 452:	38 ca                	cmp    %cl,%dl
 454:	75 f2                	jne    448 <strchr+0x18>
      return (char*) s;
  return 0;
}
 456:	5d                   	pop    %ebp
 457:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 458:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 45a:	5d                   	pop    %ebp
 45b:	90                   	nop
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 460:	c3                   	ret    
 461:	eb 0d                	jmp    470 <atoi>
 463:	90                   	nop
 464:	90                   	nop
 465:	90                   	nop
 466:	90                   	nop
 467:	90                   	nop
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 470:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 471:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 473:	89 e5                	mov    %esp,%ebp
 475:	8b 4d 08             	mov    0x8(%ebp),%ecx
 478:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 479:	0f b6 11             	movzbl (%ecx),%edx
 47c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 47f:	80 fb 09             	cmp    $0x9,%bl
 482:	77 1c                	ja     4a0 <atoi+0x30>
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 488:	0f be d2             	movsbl %dl,%edx
 48b:	83 c1 01             	add    $0x1,%ecx
 48e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 491:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 495:	0f b6 11             	movzbl (%ecx),%edx
 498:	8d 5a d0             	lea    -0x30(%edx),%ebx
 49b:	80 fb 09             	cmp    $0x9,%bl
 49e:	76 e8                	jbe    488 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 4a0:	5b                   	pop    %ebx
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	56                   	push   %esi
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	53                   	push   %ebx
 4b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 db                	test   %ebx,%ebx
 4c0:	7e 14                	jle    4d6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 4c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d2:	39 da                	cmp    %ebx,%edx
 4d4:	75 f2                	jne    4c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004e0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4fb:	00 
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 d4 00 00 00       	call   5d8 <open>
  if(fd < 0)
 504:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 506:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 508:	78 19                	js     523 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 50a:	8b 45 0c             	mov    0xc(%ebp),%eax
 50d:	89 1c 24             	mov    %ebx,(%esp)
 510:	89 44 24 04          	mov    %eax,0x4(%esp)
 514:	e8 d7 00 00 00       	call   5f0 <fstat>
  close(fd);
 519:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 51c:	89 c6                	mov    %eax,%esi
  close(fd);
 51e:	e8 9d 00 00 00       	call   5c0 <close>
  return r;
}
 523:	89 f0                	mov    %esi,%eax
 525:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 528:	8b 75 fc             	mov    -0x4(%ebp),%esi
 52b:	89 ec                	mov    %ebp,%esp
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    
 52f:	90                   	nop

00000530 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	31 f6                	xor    %esi,%esi
 537:	53                   	push   %ebx
 538:	83 ec 2c             	sub    $0x2c,%esp
 53b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 53e:	eb 06                	jmp    546 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 540:	3c 0a                	cmp    $0xa,%al
 542:	74 39                	je     57d <gets+0x4d>
 544:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 546:	8d 5e 01             	lea    0x1(%esi),%ebx
 549:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 54c:	7d 31                	jge    57f <gets+0x4f>
    cc = read(0, &c, 1);
 54e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 551:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 558:	00 
 559:	89 44 24 04          	mov    %eax,0x4(%esp)
 55d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 564:	e8 47 00 00 00       	call   5b0 <read>
    if(cc < 1)
 569:	85 c0                	test   %eax,%eax
 56b:	7e 12                	jle    57f <gets+0x4f>
      break;
    buf[i++] = c;
 56d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 571:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 575:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 579:	3c 0d                	cmp    $0xd,%al
 57b:	75 c3                	jne    540 <gets+0x10>
 57d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 57f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 583:	89 f8                	mov    %edi,%eax
 585:	83 c4 2c             	add    $0x2c,%esp
 588:	5b                   	pop    %ebx
 589:	5e                   	pop    %esi
 58a:	5f                   	pop    %edi
 58b:	5d                   	pop    %ebp
 58c:	c3                   	ret    
 58d:	90                   	nop
 58e:	90                   	nop
 58f:	90                   	nop

00000590 <fork>:
 590:	b8 01 00 00 00       	mov    $0x1,%eax
 595:	cd 30                	int    $0x30
 597:	c3                   	ret    

00000598 <exit>:
 598:	b8 02 00 00 00       	mov    $0x2,%eax
 59d:	cd 30                	int    $0x30
 59f:	c3                   	ret    

000005a0 <wait>:
 5a0:	b8 03 00 00 00       	mov    $0x3,%eax
 5a5:	cd 30                	int    $0x30
 5a7:	c3                   	ret    

000005a8 <pipe>:
 5a8:	b8 04 00 00 00       	mov    $0x4,%eax
 5ad:	cd 30                	int    $0x30
 5af:	c3                   	ret    

000005b0 <read>:
 5b0:	b8 06 00 00 00       	mov    $0x6,%eax
 5b5:	cd 30                	int    $0x30
 5b7:	c3                   	ret    

000005b8 <write>:
 5b8:	b8 05 00 00 00       	mov    $0x5,%eax
 5bd:	cd 30                	int    $0x30
 5bf:	c3                   	ret    

000005c0 <close>:
 5c0:	b8 07 00 00 00       	mov    $0x7,%eax
 5c5:	cd 30                	int    $0x30
 5c7:	c3                   	ret    

000005c8 <kill>:
 5c8:	b8 08 00 00 00       	mov    $0x8,%eax
 5cd:	cd 30                	int    $0x30
 5cf:	c3                   	ret    

000005d0 <exec>:
 5d0:	b8 09 00 00 00       	mov    $0x9,%eax
 5d5:	cd 30                	int    $0x30
 5d7:	c3                   	ret    

000005d8 <open>:
 5d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5dd:	cd 30                	int    $0x30
 5df:	c3                   	ret    

000005e0 <mknod>:
 5e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e5:	cd 30                	int    $0x30
 5e7:	c3                   	ret    

000005e8 <unlink>:
 5e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ed:	cd 30                	int    $0x30
 5ef:	c3                   	ret    

000005f0 <fstat>:
 5f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f5:	cd 30                	int    $0x30
 5f7:	c3                   	ret    

000005f8 <link>:
 5f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fd:	cd 30                	int    $0x30
 5ff:	c3                   	ret    

00000600 <mkdir>:
 600:	b8 0f 00 00 00       	mov    $0xf,%eax
 605:	cd 30                	int    $0x30
 607:	c3                   	ret    

00000608 <chdir>:
 608:	b8 10 00 00 00       	mov    $0x10,%eax
 60d:	cd 30                	int    $0x30
 60f:	c3                   	ret    

00000610 <dup>:
 610:	b8 11 00 00 00       	mov    $0x11,%eax
 615:	cd 30                	int    $0x30
 617:	c3                   	ret    

00000618 <getpid>:
 618:	b8 12 00 00 00       	mov    $0x12,%eax
 61d:	cd 30                	int    $0x30
 61f:	c3                   	ret    

00000620 <sbrk>:
 620:	b8 13 00 00 00       	mov    $0x13,%eax
 625:	cd 30                	int    $0x30
 627:	c3                   	ret    

00000628 <sleep>:
 628:	b8 14 00 00 00       	mov    $0x14,%eax
 62d:	cd 30                	int    $0x30
 62f:	c3                   	ret    

00000630 <tick>:
 630:	b8 15 00 00 00       	mov    $0x15,%eax
 635:	cd 30                	int    $0x30
 637:	c3                   	ret    

00000638 <fork_tickets>:
 638:	b8 16 00 00 00       	mov    $0x16,%eax
 63d:	cd 30                	int    $0x30
 63f:	c3                   	ret    

00000640 <fork_thread>:
 640:	b8 17 00 00 00       	mov    $0x17,%eax
 645:	cd 30                	int    $0x30
 647:	c3                   	ret    

00000648 <wait_thread>:
 648:	b8 18 00 00 00       	mov    $0x18,%eax
 64d:	cd 30                	int    $0x30
 64f:	c3                   	ret    

00000650 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 28             	sub    $0x28,%esp
 656:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 659:	8d 55 f4             	lea    -0xc(%ebp),%edx
 65c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 663:	00 
 664:	89 54 24 04          	mov    %edx,0x4(%esp)
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 48 ff ff ff       	call   5b8 <write>
}
 670:	c9                   	leave  
 671:	c3                   	ret    
 672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000680 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	89 c7                	mov    %eax,%edi
 686:	56                   	push   %esi
 687:	89 ce                	mov    %ecx,%esi
 689:	53                   	push   %ebx
 68a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 68d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 690:	85 c9                	test   %ecx,%ecx
 692:	74 04                	je     698 <printint+0x18>
 694:	85 d2                	test   %edx,%edx
 696:	78 5d                	js     6f5 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 698:	89 d0                	mov    %edx,%eax
 69a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 6a1:	31 c9                	xor    %ecx,%ecx
 6a3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 6a6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 6a8:	31 d2                	xor    %edx,%edx
 6aa:	f7 f6                	div    %esi
 6ac:	0f b6 92 6f 0a 00 00 	movzbl 0xa6f(%edx),%edx
 6b3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 6b6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 6b9:	85 c0                	test   %eax,%eax
 6bb:	75 eb                	jne    6a8 <printint+0x28>
  if(neg)
 6bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6c0:	85 c0                	test   %eax,%eax
 6c2:	74 08                	je     6cc <printint+0x4c>
    buf[i++] = '-';
 6c4:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 6c9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 6cc:	8d 71 ff             	lea    -0x1(%ecx),%esi
 6cf:	01 f3                	add    %esi,%ebx
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6d8:	0f be 13             	movsbl (%ebx),%edx
 6db:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6dd:	83 ee 01             	sub    $0x1,%esi
 6e0:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 6e3:	e8 68 ff ff ff       	call   650 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6e8:	83 fe ff             	cmp    $0xffffffff,%esi
 6eb:	75 eb                	jne    6d8 <printint+0x58>
    putc(fd, buf[i]);
}
 6ed:	83 c4 2c             	add    $0x2c,%esp
 6f0:	5b                   	pop    %ebx
 6f1:	5e                   	pop    %esi
 6f2:	5f                   	pop    %edi
 6f3:	5d                   	pop    %ebp
 6f4:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6f5:	89 d0                	mov    %edx,%eax
 6f7:	f7 d8                	neg    %eax
 6f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 700:	eb 9f                	jmp    6a1 <printint+0x21>
 702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 719:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 71c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71f:	0f b6 08             	movzbl (%eax),%ecx
 722:	84 c9                	test   %cl,%cl
 724:	0f 84 96 00 00 00    	je     7c0 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 72a:	8d 55 10             	lea    0x10(%ebp),%edx
 72d:	31 f6                	xor    %esi,%esi
 72f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 732:	31 db                	xor    %ebx,%ebx
 734:	eb 1a                	jmp    750 <printf+0x40>
 736:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 738:	83 f9 25             	cmp    $0x25,%ecx
 73b:	0f 85 87 00 00 00    	jne    7c8 <printf+0xb8>
 741:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 745:	83 c3 01             	add    $0x1,%ebx
 748:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 74c:	84 c9                	test   %cl,%cl
 74e:	74 70                	je     7c0 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 750:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 752:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 755:	74 e1                	je     738 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 757:	83 fe 25             	cmp    $0x25,%esi
 75a:	75 e9                	jne    745 <printf+0x35>
      if(c == 'd'){
 75c:	83 f9 64             	cmp    $0x64,%ecx
 75f:	90                   	nop
 760:	0f 84 fa 00 00 00    	je     860 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 766:	83 f9 70             	cmp    $0x70,%ecx
 769:	74 75                	je     7e0 <printf+0xd0>
 76b:	83 f9 78             	cmp    $0x78,%ecx
 76e:	66 90                	xchg   %ax,%ax
 770:	74 6e                	je     7e0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 772:	83 f9 73             	cmp    $0x73,%ecx
 775:	0f 84 8d 00 00 00    	je     808 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77b:	83 f9 63             	cmp    $0x63,%ecx
 77e:	66 90                	xchg   %ax,%ax
 780:	0f 84 fe 00 00 00    	je     884 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 786:	83 f9 25             	cmp    $0x25,%ecx
 789:	0f 84 b9 00 00 00    	je     848 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78f:	ba 25 00 00 00       	mov    $0x25,%edx
 794:	89 f8                	mov    %edi,%eax
 796:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 799:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 79c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79e:	e8 ad fe ff ff       	call   650 <putc>
        putc(fd, c);
 7a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 7a6:	89 f8                	mov    %edi,%eax
 7a8:	0f be d1             	movsbl %cl,%edx
 7ab:	e8 a0 fe ff ff       	call   650 <putc>
 7b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7b3:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 7b7:	84 c9                	test   %cl,%cl
 7b9:	75 95                	jne    750 <printf+0x40>
 7bb:	90                   	nop
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7c0:	83 c4 2c             	add    $0x2c,%esp
 7c3:	5b                   	pop    %ebx
 7c4:	5e                   	pop    %esi
 7c5:	5f                   	pop    %edi
 7c6:	5d                   	pop    %ebp
 7c7:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7c8:	89 f8                	mov    %edi,%eax
 7ca:	0f be d1             	movsbl %cl,%edx
 7cd:	e8 7e fe ff ff       	call   650 <putc>
 7d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d5:	e9 6b ff ff ff       	jmp    745 <printf+0x35>
 7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 7e8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	89 f8                	mov    %edi,%eax
 7f5:	e8 86 fe ff ff       	call   680 <printint>
 7fa:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 7fd:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 801:	e9 3f ff ff ff       	jmp    745 <printf+0x35>
 806:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 80b:	8b 32                	mov    (%edx),%esi
        ap++;
 80d:	83 c2 04             	add    $0x4,%edx
 810:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 813:	85 f6                	test   %esi,%esi
 815:	0f 84 84 00 00 00    	je     89f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 81b:	0f b6 16             	movzbl (%esi),%edx
 81e:	84 d2                	test   %dl,%dl
 820:	74 1d                	je     83f <printf+0x12f>
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 828:	0f be d2             	movsbl %dl,%edx
          s++;
 82b:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 82e:	89 f8                	mov    %edi,%eax
 830:	e8 1b fe ff ff       	call   650 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 835:	0f b6 16             	movzbl (%esi),%edx
 838:	84 d2                	test   %dl,%dl
 83a:	75 ec                	jne    828 <printf+0x118>
 83c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 83f:	31 f6                	xor    %esi,%esi
 841:	e9 ff fe ff ff       	jmp    745 <printf+0x35>
 846:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 848:	89 f8                	mov    %edi,%eax
 84a:	ba 25 00 00 00       	mov    $0x25,%edx
 84f:	e8 fc fd ff ff       	call   650 <putc>
 854:	31 f6                	xor    %esi,%esi
 856:	8b 45 0c             	mov    0xc(%ebp),%eax
 859:	e9 e7 fe ff ff       	jmp    745 <printf+0x35>
 85e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 863:	b1 0a                	mov    $0xa,%cl
        ap++;
 865:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 86f:	8b 10                	mov    (%eax),%edx
 871:	89 f8                	mov    %edi,%eax
 873:	e8 08 fe ff ff       	call   680 <printint>
 878:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 87b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 87f:	e9 c1 fe ff ff       	jmp    745 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 887:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 889:	0f be 10             	movsbl (%eax),%edx
 88c:	89 f8                	mov    %edi,%eax
 88e:	e8 bd fd ff ff       	call   650 <putc>
 893:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 896:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 89a:	e9 a6 fe ff ff       	jmp    745 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 89f:	be 68 0a 00 00       	mov    $0xa68,%esi
 8a4:	e9 72 ff ff ff       	jmp    81b <printf+0x10b>
 8a9:	90                   	nop
 8aa:	90                   	nop
 8ab:	90                   	nop
 8ac:	90                   	nop
 8ad:	90                   	nop
 8ae:	90                   	nop
 8af:	90                   	nop

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b1:	a1 98 0a 00 00       	mov    0xa98,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b6:	89 e5                	mov    %esp,%ebp
 8b8:	57                   	push   %edi
 8b9:	56                   	push   %esi
 8ba:	53                   	push   %ebx
 8bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 8be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	39 c8                	cmp    %ecx,%eax
 8c3:	73 1d                	jae    8e2 <free+0x32>
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
 8c8:	8b 10                	mov    (%eax),%edx
 8ca:	39 d1                	cmp    %edx,%ecx
 8cc:	72 1a                	jb     8e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	39 d0                	cmp    %edx,%eax
 8d0:	72 08                	jb     8da <free+0x2a>
 8d2:	39 c8                	cmp    %ecx,%eax
 8d4:	72 12                	jb     8e8 <free+0x38>
 8d6:	39 d1                	cmp    %edx,%ecx
 8d8:	72 0e                	jb     8e8 <free+0x38>
 8da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8dc:	39 c8                	cmp    %ecx,%eax
 8de:	66 90                	xchg   %ax,%ax
 8e0:	72 e6                	jb     8c8 <free+0x18>
 8e2:	8b 10                	mov    (%eax),%edx
 8e4:	eb e8                	jmp    8ce <free+0x1e>
 8e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 71 04             	mov    0x4(%ecx),%esi
 8eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ee:	39 d7                	cmp    %edx,%edi
 8f0:	74 19                	je     90b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8f5:	8b 50 04             	mov    0x4(%eax),%edx
 8f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8fb:	39 ce                	cmp    %ecx,%esi
 8fd:	74 21                	je     920 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 901:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 906:	5b                   	pop    %ebx
 907:	5e                   	pop    %esi
 908:	5f                   	pop    %edi
 909:	5d                   	pop    %ebp
 90a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 90b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 90e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 910:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 913:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 916:	8b 50 04             	mov    0x4(%eax),%edx
 919:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 91c:	39 ce                	cmp    %ecx,%esi
 91e:	75 df                	jne    8ff <free+0x4f>
    p->s.size += bp->s.size;
 920:	03 51 04             	add    0x4(%ecx),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 926:	8b 53 f8             	mov    -0x8(%ebx),%edx
 929:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 92b:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 930:	5b                   	pop    %ebx
 931:	5e                   	pop    %esi
 932:	5f                   	pop    %edi
 933:	5d                   	pop    %ebp
 934:	c3                   	ret    
 935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	56                   	push   %esi
 945:	53                   	push   %ebx
 946:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 94c:	8b 0d 98 0a 00 00    	mov    0xa98,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	83 c3 07             	add    $0x7,%ebx
 955:	c1 eb 03             	shr    $0x3,%ebx
 958:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 95b:	85 c9                	test   %ecx,%ecx
 95d:	0f 84 93 00 00 00    	je     9f6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 963:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 965:	8b 50 04             	mov    0x4(%eax),%edx
 968:	39 d3                	cmp    %edx,%ebx
 96a:	76 1f                	jbe    98b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 96c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 973:	90                   	nop
 974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 978:	3b 05 98 0a 00 00    	cmp    0xa98,%eax
 97e:	74 30                	je     9b0 <malloc+0x70>
 980:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 984:	8b 50 04             	mov    0x4(%eax),%edx
 987:	39 d3                	cmp    %edx,%ebx
 989:	77 ed                	ja     978 <malloc+0x38>
      if(p->s.size == nunits)
 98b:	39 d3                	cmp    %edx,%ebx
 98d:	74 61                	je     9f0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 98f:	29 da                	sub    %ebx,%edx
 991:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 994:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 997:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 99a:	89 0d 98 0a 00 00    	mov    %ecx,0xa98
      return (void*) (p + 1);
 9a0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a3:	83 c4 1c             	add    $0x1c,%esp
 9a6:	5b                   	pop    %ebx
 9a7:	5e                   	pop    %esi
 9a8:	5f                   	pop    %edi
 9a9:	5d                   	pop    %ebp
 9aa:	c3                   	ret    
 9ab:	90                   	nop
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 9b0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 9b6:	b8 00 80 00 00       	mov    $0x8000,%eax
 9bb:	bf 00 10 00 00       	mov    $0x1000,%edi
 9c0:	76 04                	jbe    9c6 <malloc+0x86>
 9c2:	89 f0                	mov    %esi,%eax
 9c4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 9c6:	89 04 24             	mov    %eax,(%esp)
 9c9:	e8 52 fc ff ff       	call   620 <sbrk>
  if(p == (char*) -1)
 9ce:	83 f8 ff             	cmp    $0xffffffff,%eax
 9d1:	74 18                	je     9eb <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9d3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 9d6:	83 c0 08             	add    $0x8,%eax
 9d9:	89 04 24             	mov    %eax,(%esp)
 9dc:	e8 cf fe ff ff       	call   8b0 <free>
  return freep;
 9e1:	8b 0d 98 0a 00 00    	mov    0xa98,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9e7:	85 c9                	test   %ecx,%ecx
 9e9:	75 97                	jne    982 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9eb:	31 c0                	xor    %eax,%eax
 9ed:	eb b4                	jmp    9a3 <malloc+0x63>
 9ef:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 9f0:	8b 10                	mov    (%eax),%edx
 9f2:	89 11                	mov    %edx,(%ecx)
 9f4:	eb a4                	jmp    99a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 9f6:	c7 05 98 0a 00 00 90 	movl   $0xa90,0xa98
 9fd:	0a 00 00 
    base.s.size = 0;
 a00:	b9 90 0a 00 00       	mov    $0xa90,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 a05:	c7 05 90 0a 00 00 90 	movl   $0xa90,0xa90
 a0c:	0a 00 00 
    base.s.size = 0;
 a0f:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 a16:	00 00 00 
 a19:	e9 45 ff ff ff       	jmp    963 <malloc+0x23>
