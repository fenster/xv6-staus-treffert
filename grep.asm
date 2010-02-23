
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1c:	89 3c 24             	mov    %edi,(%esp)
  1f:	e8 3c 00 00 00       	call   60 <matchhere>
  24:	85 c0                	test   %eax,%eax
  26:	75 20                	jne    48 <matchstar+0x48>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0f b6 03             	movzbl (%ebx),%eax
  2b:	84 c0                	test   %al,%al
  2d:	74 0f                	je     3e <matchstar+0x3e>
  2f:	0f be c0             	movsbl %al,%eax
  32:	83 c3 01             	add    $0x1,%ebx
  35:	39 f0                	cmp    %esi,%eax
  37:	74 df                	je     18 <matchstar+0x18>
  39:	83 fe 2e             	cmp    $0x2e,%esi
  3c:	74 da                	je     18 <matchstar+0x18>
  return 0;
}
  3e:	83 c4 1c             	add    $0x1c,%esp
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  41:	31 c0                	xor    %eax,%eax
  return 0;
}
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
  48:	83 c4 1c             	add    $0x1c,%esp

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  4b:	b8 01 00 00 00       	mov    $0x1,%eax
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5f                   	pop    %edi
  53:	5d                   	pop    %ebp
  54:	c3                   	ret    
  55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	83 ec 10             	sub    $0x10,%esp
  68:	8b 55 08             	mov    0x8(%ebp),%edx
  6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(re[0] == '\0')
  6e:	0f b6 02             	movzbl (%edx),%eax
  71:	84 c0                	test   %al,%al
  73:	75 1c                	jne    91 <matchhere+0x31>
  75:	eb 51                	jmp    c8 <matchhere+0x68>
  77:	90                   	nop
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	0f b6 19             	movzbl (%ecx),%ebx
  7b:	84 db                	test   %bl,%bl
  7d:	74 39                	je     b8 <matchhere+0x58>
  7f:	3c 2e                	cmp    $0x2e,%al
  81:	74 04                	je     87 <matchhere+0x27>
  83:	38 d8                	cmp    %bl,%al
  85:	75 31                	jne    b8 <matchhere+0x58>
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  87:	0f b6 02             	movzbl (%edx),%eax
  8a:	84 c0                	test   %al,%al
  8c:	74 3a                	je     c8 <matchhere+0x68>
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  8e:	83 c1 01             	add    $0x1,%ecx
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
  91:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  95:	8d 72 01             	lea    0x1(%edx),%esi
  98:	80 fb 2a             	cmp    $0x2a,%bl
  9b:	74 3b                	je     d8 <matchhere+0x78>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
  9d:	3c 24                	cmp    $0x24,%al
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  9f:	89 f2                	mov    %esi,%edx
  if(re[0] == '$' && re[1] == '\0')
  a1:	75 d5                	jne    78 <matchhere+0x18>
  a3:	84 db                	test   %bl,%bl
  a5:	75 d1                	jne    78 <matchhere+0x18>
    return *text == '\0';
  a7:	31 c0                	xor    %eax,%eax
  a9:	80 39 00             	cmpb   $0x0,(%ecx)
  ac:	0f 94 c0             	sete   %al
  af:	eb 09                	jmp    ba <matchhere+0x5a>
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  b8:	31 c0                	xor    %eax,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	5b                   	pop    %ebx
  be:	5e                   	pop    %esi
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    
  c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  c8:	83 c4 10             	add    $0x10,%esp
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  cb:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  d0:	5b                   	pop    %ebx
  d1:	5e                   	pop    %esi
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  d8:	83 c2 02             	add    $0x2,%edx
  db:	0f be c0             	movsbl %al,%eax
  de:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 12 ff ff ff       	call   0 <matchstar>
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	8b 75 08             	mov    0x8(%ebp),%esi
 10b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
 10e:	80 3e 5e             	cmpb   $0x5e,(%esi)
 111:	75 08                	jne    11b <match+0x1b>
 113:	eb 2f                	jmp    144 <match+0x44>
 115:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 118:	83 c3 01             	add    $0x1,%ebx
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 11b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 11f:	89 34 24             	mov    %esi,(%esp)
 122:	e8 39 ff ff ff       	call   60 <matchhere>
 127:	85 c0                	test   %eax,%eax
 129:	75 0d                	jne    138 <match+0x38>
      return 1;
  }while(*text++ != '\0');
 12b:	80 3b 00             	cmpb   $0x0,(%ebx)
 12e:	75 e8                	jne    118 <match+0x18>
  return 0;
}
 130:	83 c4 10             	add    $0x10,%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	90                   	nop
 138:	83 c4 10             	add    $0x10,%esp
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 13b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 144:	83 c6 01             	add    $0x1,%esi
 147:	89 75 08             	mov    %esi,0x8(%ebp)
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 14a:	83 c4 10             	add    $0x10,%esp
 14d:	5b                   	pop    %ebx
 14e:	5e                   	pop    %esi
 14f:	5d                   	pop    %ebp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 150:	e9 0b ff ff ff       	jmp    60 <matchhere>
 155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	83 ec 2c             	sub    $0x2c,%esp
 169:	8b 7d 08             	mov    0x8(%ebp),%edi
 16c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 173:	90                   	nop
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
 178:	b8 00 04 00 00       	mov    $0x400,%eax
 17d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 180:	89 44 24 08          	mov    %eax,0x8(%esp)
 184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 187:	05 60 0a 00 00       	add    $0xa60,%eax
 18c:	89 44 24 04          	mov    %eax,0x4(%esp)
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 e5 03 00 00       	call   580 <read>
 19b:	85 c0                	test   %eax,%eax
 19d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 1a0:	0f 8e ae 00 00 00    	jle    254 <grep+0xf4>
 1a6:	be 60 0a 00 00       	mov    $0xa60,%esi
 1ab:	90                   	nop
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 1b0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 1b7:	00 
 1b8:	89 34 24             	mov    %esi,(%esp)
 1bb:	e8 40 02 00 00       	call   400 <strchr>
 1c0:	85 c0                	test   %eax,%eax
 1c2:	89 c3                	mov    %eax,%ebx
 1c4:	74 42                	je     208 <grep+0xa8>
      *q = 0;
 1c6:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 1c9:	89 74 24 04          	mov    %esi,0x4(%esp)
 1cd:	89 3c 24             	mov    %edi,(%esp)
 1d0:	e8 2b ff ff ff       	call   100 <match>
 1d5:	85 c0                	test   %eax,%eax
 1d7:	75 07                	jne    1e0 <grep+0x80>
 1d9:	83 c3 01             	add    $0x1,%ebx
        *q = '\n';
        write(1, p, q+1 - p);
 1dc:	89 de                	mov    %ebx,%esi
 1de:	eb d0                	jmp    1b0 <grep+0x50>
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      if(match(pattern, p)){
        *q = '\n';
 1e0:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 1e3:	83 c3 01             	add    $0x1,%ebx
 1e6:	89 d8                	mov    %ebx,%eax
 1e8:	29 f0                	sub    %esi,%eax
 1ea:	89 74 24 04          	mov    %esi,0x4(%esp)
 1ee:	89 de                	mov    %ebx,%esi
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1fb:	e8 88 03 00 00       	call   588 <write>
 200:	eb ae                	jmp    1b0 <grep+0x50>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
      p = q+1;
    }
    if(p == buf)
 208:	81 fe 60 0a 00 00    	cmp    $0xa60,%esi
 20e:	74 38                	je     248 <grep+0xe8>
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
 210:	8b 45 e0             	mov    -0x20(%ebp),%eax
 213:	01 45 e4             	add    %eax,-0x1c(%ebp)
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
 216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 219:	85 c0                	test   %eax,%eax
 21b:	0f 8e 57 ff ff ff    	jle    178 <grep+0x18>
      m -= p - buf;
 221:	81 45 e4 60 0a 00 00 	addl   $0xa60,-0x1c(%ebp)
 228:	29 75 e4             	sub    %esi,-0x1c(%ebp)
      memmove(buf, p, m);
 22b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 22e:	89 74 24 04          	mov    %esi,0x4(%esp)
 232:	c7 04 24 60 0a 00 00 	movl   $0xa60,(%esp)
 239:	89 44 24 08          	mov    %eax,0x8(%esp)
 23d:	e8 3e 02 00 00       	call   480 <memmove>
 242:	e9 31 ff ff ff       	jmp    178 <grep+0x18>
 247:	90                   	nop
 248:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 24f:	e9 24 ff ff ff       	jmp    178 <grep+0x18>
    }
  }
}
 254:	83 c4 2c             	add    $0x2c,%esp
 257:	5b                   	pop    %ebx
 258:	5e                   	pop    %esi
 259:	5f                   	pop    %edi
 25a:	5d                   	pop    %ebp
 25b:	c3                   	ret    
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <main>:

int
main(int argc, char *argv[])
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 e4 f0             	and    $0xfffffff0,%esp
 266:	57                   	push   %edi
 267:	56                   	push   %esi
 268:	53                   	push   %ebx
 269:	83 ec 24             	sub    $0x24,%esp
 26c:	8b 7d 08             	mov    0x8(%ebp),%edi
 26f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 272:	83 ff 01             	cmp    $0x1,%edi
 275:	0f 8e 95 00 00 00    	jle    310 <main+0xb0>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 27b:	8b 43 04             	mov    0x4(%ebx),%eax
  
  if(argc <= 2){
 27e:	83 ff 02             	cmp    $0x2,%edi
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 281:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  
  if(argc <= 2){
 285:	74 71                	je     2f8 <main+0x98>
    grep(pattern, 0);
    exit();
 287:	83 c3 08             	add    $0x8,%ebx
 28a:	be 02 00 00 00       	mov    $0x2,%esi
 28f:	90                   	nop
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 297:	00 
 298:	8b 03                	mov    (%ebx),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 06 03 00 00       	call   5a8 <open>
 2a2:	85 c0                	test   %eax,%eax
 2a4:	78 32                	js     2d8 <main+0x78>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2a6:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2aa:	83 c6 01             	add    $0x1,%esi
 2ad:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	89 44 24 18          	mov    %eax,0x18(%esp)
 2b8:	89 14 24             	mov    %edx,(%esp)
 2bb:	e8 a0 fe ff ff       	call   160 <grep>
    close(fd);
 2c0:	8b 44 24 18          	mov    0x18(%esp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 c4 02 00 00       	call   590 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2cc:	39 f7                	cmp    %esi,%edi
 2ce:	7f c0                	jg     290 <main+0x30>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 2d0:	e8 93 02 00 00       	call   568 <exit>
 2d5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
 2d8:	8b 03                	mov    (%ebx),%eax
 2da:	c7 44 24 04 10 0a 00 	movl   $0xa10,0x4(%esp)
 2e1:	00 
 2e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ed:	e8 ee 03 00 00       	call   6e0 <printf>
      exit();
 2f2:	e8 71 02 00 00       	call   568 <exit>
 2f7:	90                   	nop
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
    grep(pattern, 0);
 2f8:	89 04 24             	mov    %eax,(%esp)
 2fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 302:	00 
 303:	e8 58 fe ff ff       	call   160 <grep>
    exit();
 308:	e8 5b 02 00 00       	call   568 <exit>
 30d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
 310:	c7 44 24 04 f0 09 00 	movl   $0x9f0,0x4(%esp)
 317:	00 
 318:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 31f:	e8 bc 03 00 00       	call   6e0 <printf>
    exit();
 324:	e8 3f 02 00 00       	call   568 <exit>
 329:	90                   	nop
 32a:	90                   	nop
 32b:	90                   	nop
 32c:	90                   	nop
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
 330:	55                   	push   %ebp
 331:	31 d2                	xor    %edx,%edx
 333:	89 e5                	mov    %esp,%ebp
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	53                   	push   %ebx
 339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 340:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 344:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 347:	83 c2 01             	add    $0x1,%edx
 34a:	84 c9                	test   %cl,%cl
 34c:	75 f2                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 34e:	5b                   	pop    %ebx
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
 351:	eb 0d                	jmp    360 <strcmp>
 353:	90                   	nop
 354:	90                   	nop
 355:	90                   	nop
 356:	90                   	nop
 357:	90                   	nop
 358:	90                   	nop
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 4d 08             	mov    0x8(%ebp),%ecx
 367:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 36a:	0f b6 01             	movzbl (%ecx),%eax
 36d:	84 c0                	test   %al,%al
 36f:	75 14                	jne    385 <strcmp+0x25>
 371:	eb 25                	jmp    398 <strcmp+0x38>
 373:	90                   	nop
 374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 378:	83 c1 01             	add    $0x1,%ecx
 37b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 37e:	0f b6 01             	movzbl (%ecx),%eax
 381:	84 c0                	test   %al,%al
 383:	74 13                	je     398 <strcmp+0x38>
 385:	0f b6 1a             	movzbl (%edx),%ebx
 388:	38 d8                	cmp    %bl,%al
 38a:	74 ec                	je     378 <strcmp+0x18>
 38c:	0f b6 db             	movzbl %bl,%ebx
 38f:	0f b6 c0             	movzbl %al,%eax
 392:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 394:	5b                   	pop    %ebx
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 398:	0f b6 1a             	movzbl (%edx),%ebx
 39b:	31 c0                	xor    %eax,%eax
 39d:	0f b6 db             	movzbl %bl,%ebx
 3a0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3a2:	5b                   	pop    %ebx
 3a3:	5d                   	pop    %ebp
 3a4:	c3                   	ret    
 3a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strlen>:

uint
strlen(char *s)
{
 3b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3b1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3b5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ba:	80 39 00             	cmpb   $0x0,(%ecx)
 3bd:	74 0c                	je     3cb <strlen+0x1b>
 3bf:	90                   	nop
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
    ;
  return n;
}
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d6:	53                   	push   %ebx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
 3da:	85 c9                	test   %ecx,%ecx
 3dc:	74 14                	je     3f2 <memset+0x22>
 3de:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
 3e8:	88 1c 10             	mov    %bl,(%eax,%edx,1)
 3eb:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
 3ee:	39 ca                	cmp    %ecx,%edx
 3f0:	75 f6                	jne    3e8 <memset+0x18>
    *d++ = c;
  return dst;
}
 3f2:	5b                   	pop    %ebx
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    
 3f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 40a:	0f b6 10             	movzbl (%eax),%edx
 40d:	84 d2                	test   %dl,%dl
 40f:	75 11                	jne    422 <strchr+0x22>
 411:	eb 15                	jmp    428 <strchr+0x28>
 413:	90                   	nop
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 418:	83 c0 01             	add    $0x1,%eax
 41b:	0f b6 10             	movzbl (%eax),%edx
 41e:	84 d2                	test   %dl,%dl
 420:	74 06                	je     428 <strchr+0x28>
    if(*s == c)
 422:	38 ca                	cmp    %cl,%dl
 424:	75 f2                	jne    418 <strchr+0x18>
      return (char*) s;
  return 0;
}
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 428:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 42a:	5d                   	pop    %ebp
 42b:	90                   	nop
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 430:	c3                   	ret    
 431:	eb 0d                	jmp    440 <atoi>
 433:	90                   	nop
 434:	90                   	nop
 435:	90                   	nop
 436:	90                   	nop
 437:	90                   	nop
 438:	90                   	nop
 439:	90                   	nop
 43a:	90                   	nop
 43b:	90                   	nop
 43c:	90                   	nop
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 441:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 443:	89 e5                	mov    %esp,%ebp
 445:	8b 4d 08             	mov    0x8(%ebp),%ecx
 448:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 449:	0f b6 11             	movzbl (%ecx),%edx
 44c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 44f:	80 fb 09             	cmp    $0x9,%bl
 452:	77 1c                	ja     470 <atoi+0x30>
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 458:	0f be d2             	movsbl %dl,%edx
 45b:	83 c1 01             	add    $0x1,%ecx
 45e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 461:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 465:	0f b6 11             	movzbl (%ecx),%edx
 468:	8d 5a d0             	lea    -0x30(%edx),%ebx
 46b:	80 fb 09             	cmp    $0x9,%bl
 46e:	76 e8                	jbe    458 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 470:	5b                   	pop    %ebx
 471:	5d                   	pop    %ebp
 472:	c3                   	ret    
 473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	56                   	push   %esi
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	53                   	push   %ebx
 488:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 db                	test   %ebx,%ebx
 490:	7e 14                	jle    4a6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 492:	31 d2                	xor    %edx,%edx
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 498:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 49c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 49f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4a2:	39 da                	cmp    %ebx,%edx
 4a4:	75 f2                	jne    498 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5d                   	pop    %ebp
 4a9:	c3                   	ret    
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 4b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 4bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 4bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4cb:	00 
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 d4 00 00 00       	call   5a8 <open>
  if(fd < 0)
 4d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 4d8:	78 19                	js     4f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 4da:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dd:	89 1c 24             	mov    %ebx,(%esp)
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	e8 d7 00 00 00       	call   5c0 <fstat>
  close(fd);
 4e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 4ec:	89 c6                	mov    %eax,%esi
  close(fd);
 4ee:	e8 9d 00 00 00       	call   590 <close>
  return r;
}
 4f3:	89 f0                	mov    %esi,%eax
 4f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 4f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 4fb:	89 ec                	mov    %ebp,%esp
 4fd:	5d                   	pop    %ebp
 4fe:	c3                   	ret    
 4ff:	90                   	nop

00000500 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	31 f6                	xor    %esi,%esi
 507:	53                   	push   %ebx
 508:	83 ec 2c             	sub    $0x2c,%esp
 50b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 50e:	eb 06                	jmp    516 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 510:	3c 0a                	cmp    $0xa,%al
 512:	74 39                	je     54d <gets+0x4d>
 514:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 516:	8d 5e 01             	lea    0x1(%esi),%ebx
 519:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 51c:	7d 31                	jge    54f <gets+0x4f>
    cc = read(0, &c, 1);
 51e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 534:	e8 47 00 00 00       	call   580 <read>
    if(cc < 1)
 539:	85 c0                	test   %eax,%eax
 53b:	7e 12                	jle    54f <gets+0x4f>
      break;
    buf[i++] = c;
 53d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 541:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 545:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 549:	3c 0d                	cmp    $0xd,%al
 54b:	75 c3                	jne    510 <gets+0x10>
 54d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 54f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 553:	89 f8                	mov    %edi,%eax
 555:	83 c4 2c             	add    $0x2c,%esp
 558:	5b                   	pop    %ebx
 559:	5e                   	pop    %esi
 55a:	5f                   	pop    %edi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	90                   	nop
 55e:	90                   	nop
 55f:	90                   	nop

00000560 <fork>:
 560:	b8 01 00 00 00       	mov    $0x1,%eax
 565:	cd 30                	int    $0x30
 567:	c3                   	ret    

00000568 <exit>:
 568:	b8 02 00 00 00       	mov    $0x2,%eax
 56d:	cd 30                	int    $0x30
 56f:	c3                   	ret    

00000570 <wait>:
 570:	b8 03 00 00 00       	mov    $0x3,%eax
 575:	cd 30                	int    $0x30
 577:	c3                   	ret    

00000578 <pipe>:
 578:	b8 04 00 00 00       	mov    $0x4,%eax
 57d:	cd 30                	int    $0x30
 57f:	c3                   	ret    

00000580 <read>:
 580:	b8 06 00 00 00       	mov    $0x6,%eax
 585:	cd 30                	int    $0x30
 587:	c3                   	ret    

00000588 <write>:
 588:	b8 05 00 00 00       	mov    $0x5,%eax
 58d:	cd 30                	int    $0x30
 58f:	c3                   	ret    

00000590 <close>:
 590:	b8 07 00 00 00       	mov    $0x7,%eax
 595:	cd 30                	int    $0x30
 597:	c3                   	ret    

00000598 <kill>:
 598:	b8 08 00 00 00       	mov    $0x8,%eax
 59d:	cd 30                	int    $0x30
 59f:	c3                   	ret    

000005a0 <exec>:
 5a0:	b8 09 00 00 00       	mov    $0x9,%eax
 5a5:	cd 30                	int    $0x30
 5a7:	c3                   	ret    

000005a8 <open>:
 5a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ad:	cd 30                	int    $0x30
 5af:	c3                   	ret    

000005b0 <mknod>:
 5b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b5:	cd 30                	int    $0x30
 5b7:	c3                   	ret    

000005b8 <unlink>:
 5b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5bd:	cd 30                	int    $0x30
 5bf:	c3                   	ret    

000005c0 <fstat>:
 5c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c5:	cd 30                	int    $0x30
 5c7:	c3                   	ret    

000005c8 <link>:
 5c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5cd:	cd 30                	int    $0x30
 5cf:	c3                   	ret    

000005d0 <mkdir>:
 5d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d5:	cd 30                	int    $0x30
 5d7:	c3                   	ret    

000005d8 <chdir>:
 5d8:	b8 10 00 00 00       	mov    $0x10,%eax
 5dd:	cd 30                	int    $0x30
 5df:	c3                   	ret    

000005e0 <dup>:
 5e0:	b8 11 00 00 00       	mov    $0x11,%eax
 5e5:	cd 30                	int    $0x30
 5e7:	c3                   	ret    

000005e8 <getpid>:
 5e8:	b8 12 00 00 00       	mov    $0x12,%eax
 5ed:	cd 30                	int    $0x30
 5ef:	c3                   	ret    

000005f0 <sbrk>:
 5f0:	b8 13 00 00 00       	mov    $0x13,%eax
 5f5:	cd 30                	int    $0x30
 5f7:	c3                   	ret    

000005f8 <sleep>:
 5f8:	b8 14 00 00 00       	mov    $0x14,%eax
 5fd:	cd 30                	int    $0x30
 5ff:	c3                   	ret    

00000600 <tick>:
 600:	b8 15 00 00 00       	mov    $0x15,%eax
 605:	cd 30                	int    $0x30
 607:	c3                   	ret    

00000608 <fork_tickets>:
 608:	b8 16 00 00 00       	mov    $0x16,%eax
 60d:	cd 30                	int    $0x30
 60f:	c3                   	ret    

00000610 <fork_thread>:
 610:	b8 17 00 00 00       	mov    $0x17,%eax
 615:	cd 30                	int    $0x30
 617:	c3                   	ret    

00000618 <wait_thread>:
 618:	b8 18 00 00 00       	mov    $0x18,%eax
 61d:	cd 30                	int    $0x30
 61f:	c3                   	ret    

00000620 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	83 ec 28             	sub    $0x28,%esp
 626:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 629:	8d 55 f4             	lea    -0xc(%ebp),%edx
 62c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 633:	00 
 634:	89 54 24 04          	mov    %edx,0x4(%esp)
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 48 ff ff ff       	call   588 <write>
}
 640:	c9                   	leave  
 641:	c3                   	ret    
 642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	89 c7                	mov    %eax,%edi
 656:	56                   	push   %esi
 657:	89 ce                	mov    %ecx,%esi
 659:	53                   	push   %ebx
 65a:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 65d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 660:	85 c9                	test   %ecx,%ecx
 662:	74 04                	je     668 <printint+0x18>
 664:	85 d2                	test   %edx,%edx
 666:	78 5d                	js     6c5 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 668:	89 d0                	mov    %edx,%eax
 66a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 671:	31 c9                	xor    %ecx,%ecx
 673:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 676:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 678:	31 d2                	xor    %edx,%edx
 67a:	f7 f6                	div    %esi
 67c:	0f b6 92 2d 0a 00 00 	movzbl 0xa2d(%edx),%edx
 683:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 686:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 689:	85 c0                	test   %eax,%eax
 68b:	75 eb                	jne    678 <printint+0x28>
  if(neg)
 68d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 690:	85 c0                	test   %eax,%eax
 692:	74 08                	je     69c <printint+0x4c>
    buf[i++] = '-';
 694:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 699:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 69c:	8d 71 ff             	lea    -0x1(%ecx),%esi
 69f:	01 f3                	add    %esi,%ebx
 6a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6a8:	0f be 13             	movsbl (%ebx),%edx
 6ab:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ad:	83 ee 01             	sub    $0x1,%esi
 6b0:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
 6b3:	e8 68 ff ff ff       	call   620 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6b8:	83 fe ff             	cmp    $0xffffffff,%esi
 6bb:	75 eb                	jne    6a8 <printint+0x58>
    putc(fd, buf[i]);
}
 6bd:	83 c4 2c             	add    $0x2c,%esp
 6c0:	5b                   	pop    %ebx
 6c1:	5e                   	pop    %esi
 6c2:	5f                   	pop    %edi
 6c3:	5d                   	pop    %ebp
 6c4:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6c5:	89 d0                	mov    %edx,%eax
 6c7:	f7 d8                	neg    %eax
 6c9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 6d0:	eb 9f                	jmp    671 <printint+0x21>
 6d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e9:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ef:	0f b6 08             	movzbl (%eax),%ecx
 6f2:	84 c9                	test   %cl,%cl
 6f4:	0f 84 96 00 00 00    	je     790 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 6fa:	8d 55 10             	lea    0x10(%ebp),%edx
 6fd:	31 f6                	xor    %esi,%esi
 6ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 702:	31 db                	xor    %ebx,%ebx
 704:	eb 1a                	jmp    720 <printf+0x40>
 706:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 708:	83 f9 25             	cmp    $0x25,%ecx
 70b:	0f 85 87 00 00 00    	jne    798 <printf+0xb8>
 711:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 715:	83 c3 01             	add    $0x1,%ebx
 718:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 71c:	84 c9                	test   %cl,%cl
 71e:	74 70                	je     790 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
 720:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 722:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
 725:	74 e1                	je     708 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 727:	83 fe 25             	cmp    $0x25,%esi
 72a:	75 e9                	jne    715 <printf+0x35>
      if(c == 'd'){
 72c:	83 f9 64             	cmp    $0x64,%ecx
 72f:	90                   	nop
 730:	0f 84 fa 00 00 00    	je     830 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 736:	83 f9 70             	cmp    $0x70,%ecx
 739:	74 75                	je     7b0 <printf+0xd0>
 73b:	83 f9 78             	cmp    $0x78,%ecx
 73e:	66 90                	xchg   %ax,%ax
 740:	74 6e                	je     7b0 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 742:	83 f9 73             	cmp    $0x73,%ecx
 745:	0f 84 8d 00 00 00    	je     7d8 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74b:	83 f9 63             	cmp    $0x63,%ecx
 74e:	66 90                	xchg   %ax,%ax
 750:	0f 84 fe 00 00 00    	je     854 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 756:	83 f9 25             	cmp    $0x25,%ecx
 759:	0f 84 b9 00 00 00    	je     818 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75f:	ba 25 00 00 00       	mov    $0x25,%edx
 764:	89 f8                	mov    %edi,%eax
 766:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 769:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 76c:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 76e:	e8 ad fe ff ff       	call   620 <putc>
        putc(fd, c);
 773:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 776:	89 f8                	mov    %edi,%eax
 778:	0f be d1             	movsbl %cl,%edx
 77b:	e8 a0 fe ff ff       	call   620 <putc>
 780:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 783:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
 787:	84 c9                	test   %cl,%cl
 789:	75 95                	jne    720 <printf+0x40>
 78b:	90                   	nop
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
 // mutex_unlock(&plock);
}
 790:	83 c4 2c             	add    $0x2c,%esp
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 798:	89 f8                	mov    %edi,%eax
 79a:	0f be d1             	movsbl %cl,%edx
 79d:	e8 7e fe ff ff       	call   620 <putc>
 7a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a5:	e9 6b ff ff ff       	jmp    715 <printf+0x35>
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 7b8:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	89 f8                	mov    %edi,%eax
 7c5:	e8 86 fe ff ff       	call   650 <printint>
 7ca:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 7cd:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 7d1:	e9 3f ff ff ff       	jmp    715 <printf+0x35>
 7d6:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
 7d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 7db:	8b 32                	mov    (%edx),%esi
        ap++;
 7dd:	83 c2 04             	add    $0x4,%edx
 7e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
 7e3:	85 f6                	test   %esi,%esi
 7e5:	0f 84 84 00 00 00    	je     86f <printf+0x18f>
          s = "(null)";
        while(*s != 0){
 7eb:	0f b6 16             	movzbl (%esi),%edx
 7ee:	84 d2                	test   %dl,%dl
 7f0:	74 1d                	je     80f <printf+0x12f>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
 7f8:	0f be d2             	movsbl %dl,%edx
          s++;
 7fb:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
 7fe:	89 f8                	mov    %edi,%eax
 800:	e8 1b fe ff ff       	call   620 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 805:	0f b6 16             	movzbl (%esi),%edx
 808:	84 d2                	test   %dl,%dl
 80a:	75 ec                	jne    7f8 <printf+0x118>
 80c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 80f:	31 f6                	xor    %esi,%esi
 811:	e9 ff fe ff ff       	jmp    715 <printf+0x35>
 816:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
 818:	89 f8                	mov    %edi,%eax
 81a:	ba 25 00 00 00       	mov    $0x25,%edx
 81f:	e8 fc fd ff ff       	call   620 <putc>
 824:	31 f6                	xor    %esi,%esi
 826:	8b 45 0c             	mov    0xc(%ebp),%eax
 829:	e9 e7 fe ff ff       	jmp    715 <printf+0x35>
 82e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 833:	b1 0a                	mov    $0xa,%cl
        ap++;
 835:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 838:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 83f:	8b 10                	mov    (%eax),%edx
 841:	89 f8                	mov    %edi,%eax
 843:	e8 08 fe ff ff       	call   650 <printint>
 848:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 84b:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 84f:	e9 c1 fe ff ff       	jmp    715 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 854:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
 857:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 859:	0f be 10             	movsbl (%eax),%edx
 85c:	89 f8                	mov    %edi,%eax
 85e:	e8 bd fd ff ff       	call   620 <putc>
 863:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 866:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
 86a:	e9 a6 fe ff ff       	jmp    715 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 86f:	be 26 0a 00 00       	mov    $0xa26,%esi
 874:	e9 72 ff ff ff       	jmp    7eb <printf+0x10b>
 879:	90                   	nop
 87a:	90                   	nop
 87b:	90                   	nop
 87c:	90                   	nop
 87d:	90                   	nop
 87e:	90                   	nop
 87f:	90                   	nop

00000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	a1 48 0a 00 00       	mov    0xa48,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 886:	89 e5                	mov    %esp,%ebp
 888:	57                   	push   %edi
 889:	56                   	push   %esi
 88a:	53                   	push   %ebx
 88b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 88e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	39 c8                	cmp    %ecx,%eax
 893:	73 1d                	jae    8b2 <free+0x32>
 895:	8d 76 00             	lea    0x0(%esi),%esi
 898:	8b 10                	mov    (%eax),%edx
 89a:	39 d1                	cmp    %edx,%ecx
 89c:	72 1a                	jb     8b8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	39 d0                	cmp    %edx,%eax
 8a0:	72 08                	jb     8aa <free+0x2a>
 8a2:	39 c8                	cmp    %ecx,%eax
 8a4:	72 12                	jb     8b8 <free+0x38>
 8a6:	39 d1                	cmp    %edx,%ecx
 8a8:	72 0e                	jb     8b8 <free+0x38>
 8aa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	39 c8                	cmp    %ecx,%eax
 8ae:	66 90                	xchg   %ax,%ax
 8b0:	72 e6                	jb     898 <free+0x18>
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	eb e8                	jmp    89e <free+0x1e>
 8b6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b8:	8b 71 04             	mov    0x4(%ecx),%esi
 8bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8be:	39 d7                	cmp    %edx,%edi
 8c0:	74 19                	je     8db <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8c5:	8b 50 04             	mov    0x4(%eax),%edx
 8c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8cb:	39 ce                	cmp    %ecx,%esi
 8cd:	74 21                	je     8f0 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8d1:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 8d6:	5b                   	pop    %ebx
 8d7:	5e                   	pop    %esi
 8d8:	5f                   	pop    %edi
 8d9:	5d                   	pop    %ebp
 8da:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8db:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e0:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e3:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8e6:	8b 50 04             	mov    0x4(%eax),%edx
 8e9:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ec:	39 ce                	cmp    %ecx,%esi
 8ee:	75 df                	jne    8cf <free+0x4f>
    p->s.size += bp->s.size;
 8f0:	03 51 04             	add    0x4(%ecx),%edx
 8f3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8f9:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 8fb:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 900:	5b                   	pop    %ebx
 901:	5e                   	pop    %esi
 902:	5f                   	pop    %edi
 903:	5d                   	pop    %ebp
 904:	c3                   	ret    
 905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000910 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	57                   	push   %edi
 914:	56                   	push   %esi
 915:	53                   	push   %ebx
 916:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 91c:	8b 0d 48 0a 00 00    	mov    0xa48,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 922:	83 c3 07             	add    $0x7,%ebx
 925:	c1 eb 03             	shr    $0x3,%ebx
 928:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 92b:	85 c9                	test   %ecx,%ecx
 92d:	0f 84 93 00 00 00    	je     9c6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 933:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 935:	8b 50 04             	mov    0x4(%eax),%edx
 938:	39 d3                	cmp    %edx,%ebx
 93a:	76 1f                	jbe    95b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 93c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 943:	90                   	nop
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 948:	3b 05 48 0a 00 00    	cmp    0xa48,%eax
 94e:	74 30                	je     980 <malloc+0x70>
 950:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 952:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 954:	8b 50 04             	mov    0x4(%eax),%edx
 957:	39 d3                	cmp    %edx,%ebx
 959:	77 ed                	ja     948 <malloc+0x38>
      if(p->s.size == nunits)
 95b:	39 d3                	cmp    %edx,%ebx
 95d:	74 61                	je     9c0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 95f:	29 da                	sub    %ebx,%edx
 961:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 964:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 967:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 96a:	89 0d 48 0a 00 00    	mov    %ecx,0xa48
      return (void*) (p + 1);
 970:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 973:	83 c4 1c             	add    $0x1c,%esp
 976:	5b                   	pop    %ebx
 977:	5e                   	pop    %esi
 978:	5f                   	pop    %edi
 979:	5d                   	pop    %ebp
 97a:	c3                   	ret    
 97b:	90                   	nop
 97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
 980:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 986:	b8 00 80 00 00       	mov    $0x8000,%eax
 98b:	bf 00 10 00 00       	mov    $0x1000,%edi
 990:	76 04                	jbe    996 <malloc+0x86>
 992:	89 f0                	mov    %esi,%eax
 994:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
 996:	89 04 24             	mov    %eax,(%esp)
 999:	e8 52 fc ff ff       	call   5f0 <sbrk>
  if(p == (char*) -1)
 99e:	83 f8 ff             	cmp    $0xffffffff,%eax
 9a1:	74 18                	je     9bb <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9a3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 9a6:	83 c0 08             	add    $0x8,%eax
 9a9:	89 04 24             	mov    %eax,(%esp)
 9ac:	e8 cf fe ff ff       	call   880 <free>
  return freep;
 9b1:	8b 0d 48 0a 00 00    	mov    0xa48,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 9b7:	85 c9                	test   %ecx,%ecx
 9b9:	75 97                	jne    952 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9bb:	31 c0                	xor    %eax,%eax
 9bd:	eb b4                	jmp    973 <malloc+0x63>
 9bf:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 9c0:	8b 10                	mov    (%eax),%edx
 9c2:	89 11                	mov    %edx,(%ecx)
 9c4:	eb a4                	jmp    96a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 9c6:	c7 05 48 0a 00 00 40 	movl   $0xa40,0xa48
 9cd:	0a 00 00 
    base.s.size = 0;
 9d0:	b9 40 0a 00 00       	mov    $0xa40,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 9d5:	c7 05 40 0a 00 00 40 	movl   $0xa40,0xa40
 9dc:	0a 00 00 
    base.s.size = 0;
 9df:	c7 05 44 0a 00 00 00 	movl   $0x0,0xa44
 9e6:	00 00 00 
 9e9:	e9 45 ff ff ff       	jmp    933 <malloc+0x23>
