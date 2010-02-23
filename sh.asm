
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 14             	sub    $0x14,%esp
       7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	85 db                	test   %ebx,%ebx
       c:	74 05                	je     13 <nulterminate+0x13>
    return 0;
  
  switch(cmd->type){
       e:	83 3b 05             	cmpl   $0x5,(%ebx)
      11:	76 0d                	jbe    20 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      13:	89 d8                	mov    %ebx,%eax
      15:	83 c4 14             	add    $0x14,%esp
      18:	5b                   	pop    %ebx
      19:	5d                   	pop    %ebp
      1a:	c3                   	ret    
      1b:	90                   	nop
      1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
      20:	8b 03                	mov    (%ebx),%eax
      22:	ff 24 85 50 15 00 00 	jmp    *0x1550(,%eax,4)
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      30:	8b 43 04             	mov    0x4(%ebx),%eax
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 c5 ff ff ff       	call   0 <nulterminate>
    nulterminate(lcmd->right);
      3b:	8b 43 08             	mov    0x8(%ebx),%eax
      3e:	89 04 24             	mov    %eax,(%esp)
      41:	e8 ba ff ff ff       	call   0 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      46:	89 d8                	mov    %ebx,%eax
      48:	83 c4 14             	add    $0x14,%esp
      4b:	5b                   	pop    %ebx
      4c:	5d                   	pop    %ebp
      4d:	c3                   	ret    
      4e:	66 90                	xchg   %ax,%ax
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      50:	8b 43 04             	mov    0x4(%ebx),%eax
      53:	89 04 24             	mov    %eax,(%esp)
      56:	e8 a5 ff ff ff       	call   0 <nulterminate>
    break;
  }
  return cmd;
}
      5b:	89 d8                	mov    %ebx,%eax
      5d:	83 c4 14             	add    $0x14,%esp
      60:	5b                   	pop    %ebx
      61:	5d                   	pop    %ebp
      62:	c3                   	ret    
      63:	90                   	nop
      64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      68:	8b 43 04             	mov    0x4(%ebx),%eax
      6b:	89 04 24             	mov    %eax,(%esp)
      6e:	e8 8d ff ff ff       	call   0 <nulterminate>
    *rcmd->efile = 0;
      73:	8b 43 0c             	mov    0xc(%ebx),%eax
      76:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      79:	89 d8                	mov    %ebx,%eax
      7b:	83 c4 14             	add    $0x14,%esp
      7e:	5b                   	pop    %ebx
      7f:	5d                   	pop    %ebp
      80:	c3                   	ret    
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      88:	8b 43 04             	mov    0x4(%ebx),%eax
      8b:	85 c0                	test   %eax,%eax
      8d:	74 84                	je     13 <nulterminate+0x13>
      8f:	89 d8                	mov    %ebx,%eax
      91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
      98:	8b 50 2c             	mov    0x2c(%eax),%edx
      9b:	c6 02 00             	movb   $0x0,(%edx)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      9e:	8b 50 08             	mov    0x8(%eax),%edx
      a1:	83 c0 04             	add    $0x4,%eax
      a4:	85 d2                	test   %edx,%edx
      a6:	75 f0                	jne    98 <nulterminate+0x98>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      a8:	89 d8                	mov    %ebx,%eax
      aa:	83 c4 14             	add    $0x14,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <panic>:
  exit();
}

void
panic(char *s)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
      b6:	8b 45 08             	mov    0x8(%ebp),%eax
      b9:	c7 44 24 04 e9 15 00 	movl   $0x15e9,0x4(%esp)
      c0:	00 
      c1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c8:	89 44 24 08          	mov    %eax,0x8(%esp)
      cc:	e8 6f 11 00 00       	call   1240 <printf>
  exit();
      d1:	e8 f2 0f 00 00       	call   10c8 <exit>
      d6:	8d 76 00             	lea    0x0(%esi),%esi
      d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
      e0:	55                   	push   %ebp
      e1:	89 e5                	mov    %esp,%ebp
      e3:	57                   	push   %edi
      e4:	56                   	push   %esi
      e5:	53                   	push   %ebx
      e6:	83 ec 1c             	sub    $0x1c,%esp
      e9:	8b 7d 08             	mov    0x8(%ebp),%edi
      ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;
  
  s = *ps;
      ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
      f1:	39 f3                	cmp    %esi,%ebx
      f3:	72 0a                	jb     ff <peek+0x1f>
      f5:	eb 1f                	jmp    116 <peek+0x36>
      f7:	90                   	nop
    s++;
      f8:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
      fb:	39 de                	cmp    %ebx,%esi
      fd:	76 17                	jbe    116 <peek+0x36>
      ff:	0f be 03             	movsbl (%ebx),%eax
     102:	c7 04 24 a0 16 00 00 	movl   $0x16a0,(%esp)
     109:	89 44 24 04          	mov    %eax,0x4(%esp)
     10d:	e8 4e 0e 00 00       	call   f60 <strchr>
     112:	85 c0                	test   %eax,%eax
     114:	75 e2                	jne    f8 <peek+0x18>
    s++;
  *ps = s;
     116:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     118:	0f b6 13             	movzbl (%ebx),%edx
     11b:	31 c0                	xor    %eax,%eax
     11d:	84 d2                	test   %dl,%dl
     11f:	75 0f                	jne    130 <peek+0x50>
}
     121:	83 c4 1c             	add    $0x1c,%esp
     124:	5b                   	pop    %ebx
     125:	5e                   	pop    %esi
     126:	5f                   	pop    %edi
     127:	5d                   	pop    %ebp
     128:	c3                   	ret    
     129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     130:	0f be d2             	movsbl %dl,%edx
     133:	89 54 24 04          	mov    %edx,0x4(%esp)
     137:	8b 45 10             	mov    0x10(%ebp),%eax
     13a:	89 04 24             	mov    %eax,(%esp)
     13d:	e8 1e 0e 00 00       	call   f60 <strchr>
     142:	85 c0                	test   %eax,%eax
     144:	0f 95 c0             	setne  %al
}
     147:	83 c4 1c             	add    $0x1c,%esp
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     14a:	0f b6 c0             	movzbl %al,%eax
}
     14d:	5b                   	pop    %ebx
     14e:	5e                   	pop    %esi
     14f:	5f                   	pop    %edi
     150:	5d                   	pop    %ebp
     151:	c3                   	ret    
     152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     160:	55                   	push   %ebp
     161:	89 e5                	mov    %esp,%ebp
     163:	57                   	push   %edi
     164:	56                   	push   %esi
     165:	53                   	push   %ebx
     166:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;
  
  s = *ps;
     169:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     16c:	8b 75 0c             	mov    0xc(%ebp),%esi
     16f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;
  
  s = *ps;
     172:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     174:	39 f3                	cmp    %esi,%ebx
     176:	72 0f                	jb     187 <gettoken+0x27>
     178:	eb 24                	jmp    19e <gettoken+0x3e>
     17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     180:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     183:	39 de                	cmp    %ebx,%esi
     185:	76 17                	jbe    19e <gettoken+0x3e>
     187:	0f be 03             	movsbl (%ebx),%eax
     18a:	c7 04 24 a0 16 00 00 	movl   $0x16a0,(%esp)
     191:	89 44 24 04          	mov    %eax,0x4(%esp)
     195:	e8 c6 0d 00 00       	call   f60 <strchr>
     19a:	85 c0                	test   %eax,%eax
     19c:	75 e2                	jne    180 <gettoken+0x20>
    s++;
  if(q)
     19e:	85 ff                	test   %edi,%edi
     1a0:	74 02                	je     1a4 <gettoken+0x44>
    *q = s;
     1a2:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     1a4:	0f b6 13             	movzbl (%ebx),%edx
     1a7:	0f be fa             	movsbl %dl,%edi
  switch(*s){
     1aa:	80 fa 3c             	cmp    $0x3c,%dl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     1ad:	89 f8                	mov    %edi,%eax
  switch(*s){
     1af:	7f 4f                	jg     200 <gettoken+0xa0>
     1b1:	80 fa 3b             	cmp    $0x3b,%dl
     1b4:	0f 8c a6 00 00 00    	jl     260 <gettoken+0x100>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     1ba:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     1bd:	8b 55 14             	mov    0x14(%ebp),%edx
     1c0:	85 d2                	test   %edx,%edx
     1c2:	74 05                	je     1c9 <gettoken+0x69>
    *eq = s;
     1c4:	8b 45 14             	mov    0x14(%ebp),%eax
     1c7:	89 18                	mov    %ebx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     1c9:	39 f3                	cmp    %esi,%ebx
     1cb:	72 0a                	jb     1d7 <gettoken+0x77>
     1cd:	eb 1f                	jmp    1ee <gettoken+0x8e>
     1cf:	90                   	nop
    s++;
     1d0:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     1d3:	39 de                	cmp    %ebx,%esi
     1d5:	76 17                	jbe    1ee <gettoken+0x8e>
     1d7:	0f be 03             	movsbl (%ebx),%eax
     1da:	c7 04 24 a0 16 00 00 	movl   $0x16a0,(%esp)
     1e1:	89 44 24 04          	mov    %eax,0x4(%esp)
     1e5:	e8 76 0d 00 00       	call   f60 <strchr>
     1ea:	85 c0                	test   %eax,%eax
     1ec:	75 e2                	jne    1d0 <gettoken+0x70>
    s++;
  *ps = s;
     1ee:	8b 45 08             	mov    0x8(%ebp),%eax
     1f1:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     1f3:	83 c4 1c             	add    $0x1c,%esp
     1f6:	89 f8                	mov    %edi,%eax
     1f8:	5b                   	pop    %ebx
     1f9:	5e                   	pop    %esi
     1fa:	5f                   	pop    %edi
     1fb:	5d                   	pop    %ebp
     1fc:	c3                   	ret    
     1fd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     200:	80 fa 3e             	cmp    $0x3e,%dl
     203:	0f 84 7f 00 00 00    	je     288 <gettoken+0x128>
     209:	80 fa 7c             	cmp    $0x7c,%dl
     20c:	74 ac                	je     1ba <gettoken+0x5a>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     20e:	39 de                	cmp    %ebx,%esi
     210:	77 2f                	ja     241 <gettoken+0xe1>
     212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     218:	eb 3b                	jmp    255 <gettoken+0xf5>
     21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     220:	0f be 03             	movsbl (%ebx),%eax
     223:	c7 04 24 a6 16 00 00 	movl   $0x16a6,(%esp)
     22a:	89 44 24 04          	mov    %eax,0x4(%esp)
     22e:	e8 2d 0d 00 00       	call   f60 <strchr>
     233:	85 c0                	test   %eax,%eax
     235:	75 1e                	jne    255 <gettoken+0xf5>
      s++;
     237:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     23a:	39 de                	cmp    %ebx,%esi
     23c:	76 17                	jbe    255 <gettoken+0xf5>
     23e:	0f be 03             	movsbl (%ebx),%eax
     241:	89 44 24 04          	mov    %eax,0x4(%esp)
     245:	c7 04 24 a0 16 00 00 	movl   $0x16a0,(%esp)
     24c:	e8 0f 0d 00 00       	call   f60 <strchr>
     251:	85 c0                	test   %eax,%eax
     253:	74 cb                	je     220 <gettoken+0xc0>
     255:	bf 61 00 00 00       	mov    $0x61,%edi
     25a:	e9 5e ff ff ff       	jmp    1bd <gettoken+0x5d>
     25f:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     260:	80 fa 29             	cmp    $0x29,%dl
     263:	7f a9                	jg     20e <gettoken+0xae>
     265:	80 fa 28             	cmp    $0x28,%dl
     268:	0f 8d 4c ff ff ff    	jge    1ba <gettoken+0x5a>
     26e:	84 d2                	test   %dl,%dl
     270:	0f 84 47 ff ff ff    	je     1bd <gettoken+0x5d>
     276:	80 fa 26             	cmp    $0x26,%dl
     279:	75 93                	jne    20e <gettoken+0xae>
     27b:	90                   	nop
     27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     280:	e9 35 ff ff ff       	jmp    1ba <gettoken+0x5a>
     285:	8d 76 00             	lea    0x0(%esi),%esi
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     288:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     28b:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     28e:	66 90                	xchg   %ax,%ax
     290:	0f 85 27 ff ff ff    	jne    1bd <gettoken+0x5d>
      ret = '+';
      s++;
     296:	83 c3 01             	add    $0x1,%ebx
     299:	bf 2b 00 00 00       	mov    $0x2b,%edi
     29e:	66 90                	xchg   %ax,%ax
     2a0:	e9 18 ff ff ff       	jmp    1bd <gettoken+0x5d>
     2a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	53                   	push   %ebx
     2b4:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     2be:	e8 ad 11 00 00       	call   1470 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2c3:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     2ca:	00 
     2cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2d2:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2d5:	89 04 24             	mov    %eax,(%esp)
     2d8:	e8 53 0c 00 00       	call   f30 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     2dd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
     2e0:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     2e6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     2e9:	89 d8                	mov    %ebx,%eax
     2eb:	83 c4 14             	add    $0x14,%esp
     2ee:	5b                   	pop    %ebx
     2ef:	5d                   	pop    %ebp
     2f0:	c3                   	ret    
     2f1:	eb 0d                	jmp    300 <listcmd>
     2f3:	90                   	nop
     2f4:	90                   	nop
     2f5:	90                   	nop
     2f6:	90                   	nop
     2f7:	90                   	nop
     2f8:	90                   	nop
     2f9:	90                   	nop
     2fa:	90                   	nop
     2fb:	90                   	nop
     2fc:	90                   	nop
     2fd:	90                   	nop
     2fe:	90                   	nop
     2ff:	90                   	nop

00000300 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     300:	55                   	push   %ebp
     301:	89 e5                	mov    %esp,%ebp
     303:	53                   	push   %ebx
     304:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     307:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     30e:	e8 5d 11 00 00       	call   1470 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     313:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     31a:	00 
     31b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     322:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     323:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     325:	89 04 24             	mov    %eax,(%esp)
     328:	e8 03 0c 00 00       	call   f30 <memset>
  cmd->type = LIST;
  cmd->left = left;
     32d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
     330:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     336:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     339:	8b 45 0c             	mov    0xc(%ebp),%eax
     33c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     33f:	89 d8                	mov    %ebx,%eax
     341:	83 c4 14             	add    $0x14,%esp
     344:	5b                   	pop    %ebx
     345:	5d                   	pop    %ebp
     346:	c3                   	ret    
     347:	89 f6                	mov    %esi,%esi
     349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	53                   	push   %ebx
     354:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     357:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     35e:	e8 0d 11 00 00       	call   1470 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     363:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     36a:	00 
     36b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     372:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     373:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     375:	89 04 24             	mov    %eax,(%esp)
     378:	e8 b3 0b 00 00       	call   f30 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     37d:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
     380:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     386:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     389:	8b 45 0c             	mov    0xc(%ebp),%eax
     38c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     38f:	89 d8                	mov    %ebx,%eax
     391:	83 c4 14             	add    $0x14,%esp
     394:	5b                   	pop    %ebx
     395:	5d                   	pop    %ebp
     396:	c3                   	ret    
     397:	89 f6                	mov    %esi,%esi
     399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3a0:	55                   	push   %ebp
     3a1:	89 e5                	mov    %esp,%ebp
     3a3:	53                   	push   %ebx
     3a4:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3a7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ae:	e8 bd 10 00 00       	call   1470 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3b3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3ba:	00 
     3bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3c2:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3c5:	89 04 24             	mov    %eax,(%esp)
     3c8:	e8 63 0b 00 00       	call   f30 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     3cd:	8b 45 08             	mov    0x8(%ebp),%eax
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
     3d0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3d6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3dc:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3df:	8b 45 10             	mov    0x10(%ebp),%eax
     3e2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3e5:	8b 45 14             	mov    0x14(%ebp),%eax
     3e8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3eb:	8b 45 18             	mov    0x18(%ebp),%eax
     3ee:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3f1:	89 d8                	mov    %ebx,%eax
     3f3:	83 c4 14             	add    $0x14,%esp
     3f6:	5b                   	pop    %ebx
     3f7:	5d                   	pop    %ebp
     3f8:	c3                   	ret    
     3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     400:	55                   	push   %ebp
     401:	89 e5                	mov    %esp,%ebp
     403:	57                   	push   %edi
     404:	56                   	push   %esi
     405:	53                   	push   %ebx
     406:	83 ec 3c             	sub    $0x3c,%esp
     409:	8b 7d 0c             	mov    0xc(%ebp),%edi
     40c:	8b 75 10             	mov    0x10(%ebp),%esi
     40f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     410:	c7 44 24 08 9d 15 00 	movl   $0x159d,0x8(%esp)
     417:	00 
     418:	89 74 24 04          	mov    %esi,0x4(%esp)
     41c:	89 3c 24             	mov    %edi,(%esp)
     41f:	e8 bc fc ff ff       	call   e0 <peek>
     424:	85 c0                	test   %eax,%eax
     426:	0f 84 a4 00 00 00    	je     4d0 <parseredirs+0xd0>
    tok = gettoken(ps, es, 0, 0);
     42c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     433:	00 
     434:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     43b:	00 
     43c:	89 74 24 04          	mov    %esi,0x4(%esp)
     440:	89 3c 24             	mov    %edi,(%esp)
     443:	e8 18 fd ff ff       	call   160 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     448:	89 74 24 04          	mov    %esi,0x4(%esp)
     44c:	89 3c 24             	mov    %edi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     44f:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     451:	8d 45 e0             	lea    -0x20(%ebp),%eax
     454:	89 44 24 0c          	mov    %eax,0xc(%esp)
     458:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     45b:	89 44 24 08          	mov    %eax,0x8(%esp)
     45f:	e8 fc fc ff ff       	call   160 <gettoken>
     464:	83 f8 61             	cmp    $0x61,%eax
     467:	74 0c                	je     475 <parseredirs+0x75>
      panic("missing file for redirection");
     469:	c7 04 24 80 15 00 00 	movl   $0x1580,(%esp)
     470:	e8 3b fc ff ff       	call   b0 <panic>
    switch(tok){
     475:	83 fb 3c             	cmp    $0x3c,%ebx
     478:	74 3e                	je     4b8 <parseredirs+0xb8>
     47a:	83 fb 3e             	cmp    $0x3e,%ebx
     47d:	74 05                	je     484 <parseredirs+0x84>
     47f:	83 fb 2b             	cmp    $0x2b,%ebx
     482:	75 8c                	jne    410 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     484:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     48b:	00 
     48c:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     493:	00 
     494:	8b 45 e0             	mov    -0x20(%ebp),%eax
     497:	89 44 24 08          	mov    %eax,0x8(%esp)
     49b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     49e:	89 44 24 04          	mov    %eax,0x4(%esp)
     4a2:	8b 45 08             	mov    0x8(%ebp),%eax
     4a5:	89 04 24             	mov    %eax,(%esp)
     4a8:	e8 f3 fe ff ff       	call   3a0 <redircmd>
     4ad:	89 45 08             	mov    %eax,0x8(%ebp)
     4b0:	e9 5b ff ff ff       	jmp    410 <parseredirs+0x10>
     4b5:	8d 76 00             	lea    0x0(%esi),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4b8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     4bf:	00 
     4c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     4c7:	00 
     4c8:	eb ca                	jmp    494 <parseredirs+0x94>
     4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     4d0:	8b 45 08             	mov    0x8(%ebp),%eax
     4d3:	83 c4 3c             	add    $0x3c,%esp
     4d6:	5b                   	pop    %ebx
     4d7:	5e                   	pop    %esi
     4d8:	5f                   	pop    %edi
     4d9:	5d                   	pop    %ebp
     4da:	c3                   	ret    
     4db:	90                   	nop
     4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004e0 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     4e0:	55                   	push   %ebp
     4e1:	89 e5                	mov    %esp,%ebp
     4e3:	53                   	push   %ebx
     4e4:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4e7:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     4ee:	e8 7d 0f 00 00       	call   1470 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     4f3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     4fa:	00 
     4fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     502:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     503:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     505:	89 04 24             	mov    %eax,(%esp)
     508:	e8 23 0a 00 00       	call   f30 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     50d:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     50f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     515:	83 c4 14             	add    $0x14,%esp
     518:	5b                   	pop    %ebx
     519:	5d                   	pop    %ebp
     51a:	c3                   	ret    
     51b:	90                   	nop
     51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     520:	55                   	push   %ebp
     521:	89 e5                	mov    %esp,%ebp
     523:	57                   	push   %edi
     524:	56                   	push   %esi
     525:	53                   	push   %ebx
     526:	83 ec 3c             	sub    $0x3c,%esp
     529:	8b 75 08             	mov    0x8(%ebp),%esi
     52c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     52f:	c7 44 24 08 a0 15 00 	movl   $0x15a0,0x8(%esp)
     536:	00 
     537:	89 34 24             	mov    %esi,(%esp)
     53a:	89 7c 24 04          	mov    %edi,0x4(%esp)
     53e:	e8 9d fb ff ff       	call   e0 <peek>
     543:	85 c0                	test   %eax,%eax
     545:	0f 85 cd 00 00 00    	jne    618 <parseexec+0xf8>
    return parseblock(ps, es);

  ret = execcmd();
     54b:	e8 90 ff ff ff       	call   4e0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     550:	31 db                	xor    %ebx,%ebx
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     555:	89 7c 24 08          	mov    %edi,0x8(%esp)
     559:	89 74 24 04          	mov    %esi,0x4(%esp)
     55d:	89 04 24             	mov    %eax,(%esp)
     560:	e8 9b fe ff ff       	call   400 <parseredirs>
     565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
     568:	eb 1c                	jmp    586 <parseexec+0x66>
     56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     570:	89 7c 24 08          	mov    %edi,0x8(%esp)
     574:	89 74 24 04          	mov    %esi,0x4(%esp)
     578:	8b 45 d0             	mov    -0x30(%ebp),%eax
     57b:	89 04 24             	mov    %eax,(%esp)
     57e:	e8 7d fe ff ff       	call   400 <parseredirs>
     583:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     586:	c7 44 24 08 b7 15 00 	movl   $0x15b7,0x8(%esp)
     58d:	00 
     58e:	89 7c 24 04          	mov    %edi,0x4(%esp)
     592:	89 34 24             	mov    %esi,(%esp)
     595:	e8 46 fb ff ff       	call   e0 <peek>
     59a:	85 c0                	test   %eax,%eax
     59c:	75 5a                	jne    5f8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     59e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5a1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
     5a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     5a8:	89 54 24 08          	mov    %edx,0x8(%esp)
     5ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
     5b0:	89 34 24             	mov    %esi,(%esp)
     5b3:	e8 a8 fb ff ff       	call   160 <gettoken>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 3c                	je     5f8 <parseexec+0xd8>
      break;
    if(tok != 'a')
     5bc:	83 f8 61             	cmp    $0x61,%eax
     5bf:	74 0c                	je     5cd <parseexec+0xad>
      panic("syntax");
     5c1:	c7 04 24 a2 15 00 00 	movl   $0x15a2,(%esp)
     5c8:	e8 e3 fa ff ff       	call   b0 <panic>
    cmd->argv[argc] = q;
     5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5d3:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     5d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     5da:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     5de:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     5e1:	83 fb 09             	cmp    $0x9,%ebx
     5e4:	7e 8a                	jle    570 <parseexec+0x50>
      panic("too many args");
     5e6:	c7 04 24 a9 15 00 00 	movl   $0x15a9,(%esp)
     5ed:	e8 be fa ff ff       	call   b0 <panic>
     5f2:	e9 79 ff ff ff       	jmp    570 <parseexec+0x50>
     5f7:	90                   	nop
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     5f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  cmd->eargv[argc] = 0;
  return ret;
}
     5fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     5fe:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
     605:	00 
  cmd->eargv[argc] = 0;
     606:	c7 44 9a 2c 00 00 00 	movl   $0x0,0x2c(%edx,%ebx,4)
     60d:	00 
  return ret;
}
     60e:	83 c4 3c             	add    $0x3c,%esp
     611:	5b                   	pop    %ebx
     612:	5e                   	pop    %esi
     613:	5f                   	pop    %edi
     614:	5d                   	pop    %ebp
     615:	c3                   	ret    
     616:	66 90                	xchg   %ax,%ax
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);
     618:	89 7c 24 04          	mov    %edi,0x4(%esp)
     61c:	89 34 24             	mov    %esi,(%esp)
     61f:	e8 6c 01 00 00       	call   790 <parseblock>
     624:	89 45 d0             	mov    %eax,-0x30(%ebp)
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     627:	8b 45 d0             	mov    -0x30(%ebp),%eax
     62a:	83 c4 3c             	add    $0x3c,%esp
     62d:	5b                   	pop    %ebx
     62e:	5e                   	pop    %esi
     62f:	5f                   	pop    %edi
     630:	5d                   	pop    %ebp
     631:	c3                   	ret    
     632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	83 ec 28             	sub    $0x28,%esp
     646:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     649:	8b 5d 08             	mov    0x8(%ebp),%ebx
     64c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     64f:	8b 75 0c             	mov    0xc(%ebp),%esi
     652:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
     655:	89 1c 24             	mov    %ebx,(%esp)
     658:	89 74 24 04          	mov    %esi,0x4(%esp)
     65c:	e8 bf fe ff ff       	call   520 <parseexec>
  if(peek(ps, es, "|")){
     661:	c7 44 24 08 bc 15 00 	movl   $0x15bc,0x8(%esp)
     668:	00 
     669:	89 74 24 04          	mov    %esi,0x4(%esp)
     66d:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
     670:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     672:	e8 69 fa ff ff       	call   e0 <peek>
     677:	85 c0                	test   %eax,%eax
     679:	75 15                	jne    690 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     67b:	89 f8                	mov    %edi,%eax
     67d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     680:	8b 75 f8             	mov    -0x8(%ebp),%esi
     683:	8b 7d fc             	mov    -0x4(%ebp),%edi
     686:	89 ec                	mov    %ebp,%esp
     688:	5d                   	pop    %ebp
     689:	c3                   	ret    
     68a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     690:	89 74 24 04          	mov    %esi,0x4(%esp)
     694:	89 1c 24             	mov    %ebx,(%esp)
     697:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     69e:	00 
     69f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6a6:	00 
     6a7:	e8 b4 fa ff ff       	call   160 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ac:	89 74 24 04          	mov    %esi,0x4(%esp)
     6b0:	89 1c 24             	mov    %ebx,(%esp)
     6b3:	e8 88 ff ff ff       	call   640 <parsepipe>
  }
  return cmd;
}
     6b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6bb:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     6be:	8b 75 f8             	mov    -0x8(%ebp),%esi
     6c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6c4:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     6c7:	89 ec                	mov    %ebp,%esp
     6c9:	5d                   	pop    %ebp
  struct cmd *cmd;
  
  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	e9 81 fc ff ff       	jmp    350 <pipecmd>
     6cf:	90                   	nop

000006d0 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	57                   	push   %edi
     6d4:	56                   	push   %esi
     6d5:	53                   	push   %ebx
     6d6:	83 ec 1c             	sub    $0x1c,%esp
     6d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     6df:	89 1c 24             	mov    %ebx,(%esp)
     6e2:	89 74 24 04          	mov    %esi,0x4(%esp)
     6e6:	e8 55 ff ff ff       	call   640 <parsepipe>
     6eb:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6ed:	eb 27                	jmp    716 <parseline+0x46>
     6ef:	90                   	nop
    gettoken(ps, es, 0, 0);
     6f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6f7:	00 
     6f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6ff:	00 
     700:	89 74 24 04          	mov    %esi,0x4(%esp)
     704:	89 1c 24             	mov    %ebx,(%esp)
     707:	e8 54 fa ff ff       	call   160 <gettoken>
    cmd = backcmd(cmd);
     70c:	89 3c 24             	mov    %edi,(%esp)
     70f:	e8 9c fb ff ff       	call   2b0 <backcmd>
     714:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     716:	c7 44 24 08 be 15 00 	movl   $0x15be,0x8(%esp)
     71d:	00 
     71e:	89 74 24 04          	mov    %esi,0x4(%esp)
     722:	89 1c 24             	mov    %ebx,(%esp)
     725:	e8 b6 f9 ff ff       	call   e0 <peek>
     72a:	85 c0                	test   %eax,%eax
     72c:	75 c2                	jne    6f0 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     72e:	c7 44 24 08 ba 15 00 	movl   $0x15ba,0x8(%esp)
     735:	00 
     736:	89 74 24 04          	mov    %esi,0x4(%esp)
     73a:	89 1c 24             	mov    %ebx,(%esp)
     73d:	e8 9e f9 ff ff       	call   e0 <peek>
     742:	85 c0                	test   %eax,%eax
     744:	75 0a                	jne    750 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     746:	83 c4 1c             	add    $0x1c,%esp
     749:	89 f8                	mov    %edi,%eax
     74b:	5b                   	pop    %ebx
     74c:	5e                   	pop    %esi
     74d:	5f                   	pop    %edi
     74e:	5d                   	pop    %ebp
     74f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     750:	89 74 24 04          	mov    %esi,0x4(%esp)
     754:	89 1c 24             	mov    %ebx,(%esp)
     757:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     75e:	00 
     75f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     766:	00 
     767:	e8 f4 f9 ff ff       	call   160 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     76c:	89 74 24 04          	mov    %esi,0x4(%esp)
     770:	89 1c 24             	mov    %ebx,(%esp)
     773:	e8 58 ff ff ff       	call   6d0 <parseline>
     778:	89 7d 08             	mov    %edi,0x8(%ebp)
     77b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     77e:	83 c4 1c             	add    $0x1c,%esp
     781:	5b                   	pop    %ebx
     782:	5e                   	pop    %esi
     783:	5f                   	pop    %edi
     784:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     785:	e9 76 fb ff ff       	jmp    300 <listcmd>
     78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000790 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
     796:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     799:	8b 5d 08             	mov    0x8(%ebp),%ebx
     79c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     79f:	8b 75 0c             	mov    0xc(%ebp),%esi
     7a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     7a5:	c7 44 24 08 a0 15 00 	movl   $0x15a0,0x8(%esp)
     7ac:	00 
     7ad:	89 1c 24             	mov    %ebx,(%esp)
     7b0:	89 74 24 04          	mov    %esi,0x4(%esp)
     7b4:	e8 27 f9 ff ff       	call   e0 <peek>
     7b9:	85 c0                	test   %eax,%eax
     7bb:	0f 84 87 00 00 00    	je     848 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     7c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7c8:	00 
     7c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7d0:	00 
     7d1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7d5:	89 1c 24             	mov    %ebx,(%esp)
     7d8:	e8 83 f9 ff ff       	call   160 <gettoken>
  cmd = parseline(ps, es);
     7dd:	89 74 24 04          	mov    %esi,0x4(%esp)
     7e1:	89 1c 24             	mov    %ebx,(%esp)
     7e4:	e8 e7 fe ff ff       	call   6d0 <parseline>
  if(!peek(ps, es, ")"))
     7e9:	c7 44 24 08 dc 15 00 	movl   $0x15dc,0x8(%esp)
     7f0:	00 
     7f1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7f5:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     7f8:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7fa:	e8 e1 f8 ff ff       	call   e0 <peek>
     7ff:	85 c0                	test   %eax,%eax
     801:	75 0c                	jne    80f <parseblock+0x7f>
    panic("syntax - missing )");
     803:	c7 04 24 cb 15 00 00 	movl   $0x15cb,(%esp)
     80a:	e8 a1 f8 ff ff       	call   b0 <panic>
  gettoken(ps, es, 0, 0);
     80f:	89 74 24 04          	mov    %esi,0x4(%esp)
     813:	89 1c 24             	mov    %ebx,(%esp)
     816:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     81d:	00 
     81e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     825:	00 
     826:	e8 35 f9 ff ff       	call   160 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     82b:	89 74 24 08          	mov    %esi,0x8(%esp)
     82f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     833:	89 3c 24             	mov    %edi,(%esp)
     836:	e8 c5 fb ff ff       	call   400 <parseredirs>
  return cmd;
}
     83b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     83e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     841:	8b 7d fc             	mov    -0x4(%ebp),%edi
     844:	89 ec                	mov    %ebp,%esp
     846:	5d                   	pop    %ebp
     847:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     848:	c7 04 24 c0 15 00 00 	movl   $0x15c0,(%esp)
     84f:	e8 5c f8 ff ff       	call   b0 <panic>
     854:	e9 68 ff ff ff       	jmp    7c1 <parseblock+0x31>
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000860 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	56                   	push   %esi
     864:	53                   	push   %ebx
     865:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;
  
  es = s + strlen(s);
     868:	8b 5d 08             	mov    0x8(%ebp),%ebx
     86b:	89 1c 24             	mov    %ebx,(%esp)
     86e:	e8 9d 06 00 00       	call   f10 <strlen>
     873:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     875:	8d 45 08             	lea    0x8(%ebp),%eax
     878:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     87c:	89 04 24             	mov    %eax,(%esp)
     87f:	e8 4c fe ff ff       	call   6d0 <parseline>
  peek(&s, es, "");
     884:	c7 44 24 08 87 16 00 	movl   $0x1687,0x8(%esp)
     88b:	00 
     88c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;
  
  es = s + strlen(s);
  cmd = parseline(&s, es);
     890:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     892:	8d 45 08             	lea    0x8(%ebp),%eax
     895:	89 04 24             	mov    %eax,(%esp)
     898:	e8 43 f8 ff ff       	call   e0 <peek>
  if(s != es){
     89d:	8b 45 08             	mov    0x8(%ebp),%eax
     8a0:	39 d8                	cmp    %ebx,%eax
     8a2:	74 24                	je     8c8 <parsecmd+0x68>
    printf(2, "leftovers: %s\n", s);
     8a4:	89 44 24 08          	mov    %eax,0x8(%esp)
     8a8:	c7 44 24 04 de 15 00 	movl   $0x15de,0x4(%esp)
     8af:	00 
     8b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8b7:	e8 84 09 00 00       	call   1240 <printf>
    panic("syntax");
     8bc:	c7 04 24 a2 15 00 00 	movl   $0x15a2,(%esp)
     8c3:	e8 e8 f7 ff ff       	call   b0 <panic>
  }
  nulterminate(cmd);
     8c8:	89 34 24             	mov    %esi,(%esp)
     8cb:	e8 30 f7 ff ff       	call   0 <nulterminate>
  return cmd;
}
     8d0:	83 c4 10             	add    $0x10,%esp
     8d3:	89 f0                	mov    %esi,%eax
     8d5:	5b                   	pop    %ebx
     8d6:	5e                   	pop    %esi
     8d7:	5d                   	pop    %ebp
     8d8:	c3                   	ret    
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <fork1>:
  return pid;
}

int
fork1(void)
{
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     8e6:	e8 d5 07 00 00       	call   10c0 <fork>
  if(pid == -1)
     8eb:	83 f8 ff             	cmp    $0xffffffff,%eax
     8ee:	74 08                	je     8f8 <fork1+0x18>
    panic("fork");
  return pid;
}
     8f0:	c9                   	leave  
     8f1:	c3                   	ret    
     8f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
     8f8:	c7 04 24 ed 15 00 00 	movl   $0x15ed,(%esp)
     8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     902:	e8 a9 f7 ff ff       	call   b0 <panic>
     907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     90a:	c9                   	leave  
     90b:	c3                   	ret    
     90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <fork2>:
  exit();
}

int
fork2(int numTix)
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 28             	sub    $0x28,%esp
int pid;
  
  pid = fork_tickets(numTix);
     916:	8b 45 08             	mov    0x8(%ebp),%eax
     919:	89 04 24             	mov    %eax,(%esp)
     91c:	e8 47 08 00 00       	call   1168 <fork_tickets>
  if(pid == -1)
     921:	83 f8 ff             	cmp    $0xffffffff,%eax
     924:	74 02                	je     928 <fork2+0x18>
    panic("fork");
  return pid;
}
     926:	c9                   	leave  
     927:	c3                   	ret    
{
int pid;
  
  pid = fork_tickets(numTix);
  if(pid == -1)
    panic("fork");
     928:	c7 04 24 ed 15 00 00 	movl   $0x15ed,(%esp)
     92f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     932:	e8 79 f7 ff ff       	call   b0 <panic>
     937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     93a:	c9                   	leave  
     93b:	c3                   	ret    
     93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000940 <lottery_test>:
    break;
  }
  return cmd;
}

void lottery_test(int tickets){
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	83 ec 18             	sub    $0x18,%esp
     946:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     949:	8b 5d 08             	mov    0x8(%ebp),%ebx
     94c:	89 75 fc             	mov    %esi,-0x4(%ebp)

		int start_ticks = tick();
     94f:	e8 0c 08 00 00       	call   1160 <tick>
		if(fork2(tickets) == 0)
     954:	89 1c 24             	mov    %ebx,(%esp)
  return cmd;
}

void lottery_test(int tickets){

		int start_ticks = tick();
     957:	89 c6                	mov    %eax,%esi
		if(fork2(tickets) == 0)
     959:	e8 b2 ff ff ff       	call   910 <fork2>
     95e:	85 c0                	test   %eax,%eax
     960:	74 0a                	je     96c <lottery_test+0x2c>
		}

 		exit();
    }

}
     962:	8b 5d f8             	mov    -0x8(%ebp),%ebx
     965:	8b 75 fc             	mov    -0x4(%ebp),%esi
     968:	89 ec                	mov    %ebp,%esp
     96a:	5d                   	pop    %ebp
     96b:	c3                   	ret    
}

void lottery_test(int tickets){

		int start_ticks = tick();
		if(fork2(tickets) == 0)
     96c:	b0 01                	mov    $0x1,%al
     96e:	66 90                	xchg   %ax,%ax
		
		int temp = 0;
		int dummy;
		while(temp < 10000000)
		{
			temp = temp + 1;
     970:	83 c0 01             	add    $0x1,%eax
			if(temp == 10000000)
     973:	3d 80 96 98 00       	cmp    $0x989680,%eax
     978:	75 f6                	jne    970 <lottery_test+0x30>
					printf(2, "%d tickets, %d ticks\n", tickets, tick() - start_ticks);
     97a:	e8 e1 07 00 00       	call   1160 <tick>
     97f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     983:	c7 44 24 04 f2 15 00 	movl   $0x15f2,0x4(%esp)
     98a:	00 
     98b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     992:	29 f0                	sub    %esi,%eax
     994:	89 44 24 0c          	mov    %eax,0xc(%esp)
     998:	e8 a3 08 00 00       	call   1240 <printf>
		}

 		exit();
     99d:	e8 26 07 00 00       	call   10c8 <exit>
     9a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009b0 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     9b0:	55                   	push   %ebp
     9b1:	89 e5                	mov    %esp,%ebp
     9b3:	83 ec 18             	sub    $0x18,%esp
     9b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     9b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
     9bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     9c2:	c7 44 24 04 08 16 00 	movl   $0x1608,0x4(%esp)
     9c9:	00 
     9ca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9d1:	e8 6a 08 00 00       	call   1240 <printf>
  memset(buf, 0, nbuf);
     9d6:	89 74 24 08          	mov    %esi,0x8(%esp)
     9da:	89 1c 24             	mov    %ebx,(%esp)
     9dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9e4:	00 
     9e5:	e8 46 05 00 00       	call   f30 <memset>
  gets(buf, nbuf);
     9ea:	89 74 24 04          	mov    %esi,0x4(%esp)
     9ee:	89 1c 24             	mov    %ebx,(%esp)
     9f1:	e8 6a 06 00 00       	call   1060 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     9f6:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     9f9:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     9fc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     9ff:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     a01:	89 ec                	mov    %ebp,%esp
     a03:	5d                   	pop    %ebp
     a04:	c3                   	ret    
     a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a10 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	53                   	push   %ebx
     a14:	83 ec 24             	sub    $0x24,%esp
     a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a1a:	85 db                	test   %ebx,%ebx
     a1c:	74 42                	je     a60 <runcmd+0x50>
    exit();
  
  switch(cmd->type){
     a1e:	83 3b 05             	cmpl   $0x5,(%ebx)
     a21:	76 45                	jbe    a68 <runcmd+0x58>
  default:
    panic("runcmd");
     a23:	c7 04 24 0b 16 00 00 	movl   $0x160b,(%esp)
     a2a:	e8 81 f6 ff ff       	call   b0 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     a2f:	8b 43 04             	mov    0x4(%ebx),%eax
     a32:	85 c0                	test   %eax,%eax
     a34:	74 2a                	je     a60 <runcmd+0x50>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
     a36:	8d 53 04             	lea    0x4(%ebx),%edx
     a39:	89 54 24 04          	mov    %edx,0x4(%esp)
     a3d:	89 04 24             	mov    %eax,(%esp)
     a40:	e8 bb 06 00 00       	call   1100 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     a45:	8b 43 04             	mov    0x4(%ebx),%eax
     a48:	c7 44 24 04 12 16 00 	movl   $0x1612,0x4(%esp)
     a4f:	00 
     a50:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a57:	89 44 24 08          	mov    %eax,0x8(%esp)
     a5b:	e8 e0 07 00 00       	call   1240 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a60:	e8 63 06 00 00       	call   10c8 <exit>
     a65:	8d 76 00             	lea    0x0(%esi),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
  
  switch(cmd->type){
     a68:	8b 03                	mov    (%ebx),%eax
     a6a:	ff 24 85 68 15 00 00 	jmp    *0x1568(,%eax,4)
     a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     a78:	e8 63 fe ff ff       	call   8e0 <fork1>
     a7d:	85 c0                	test   %eax,%eax
     a7f:	90                   	nop
     a80:	0f 84 a7 00 00 00    	je     b2d <runcmd+0x11d>
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     a86:	e8 3d 06 00 00       	call   10c8 <exit>
     a8b:	90                   	nop
     a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     a90:	e8 4b fe ff ff       	call   8e0 <fork1>
     a95:	85 c0                	test   %eax,%eax
     a97:	0f 84 a3 00 00 00    	je     b40 <runcmd+0x130>
     a9d:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(lcmd->left);
    wait();
     aa0:	e8 2b 06 00 00       	call   10d0 <wait>
    runcmd(lcmd->right);
     aa5:	8b 43 08             	mov    0x8(%ebx),%eax
     aa8:	89 04 24             	mov    %eax,(%esp)
     aab:	e8 60 ff ff ff       	call   a10 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     ab0:	e8 13 06 00 00       	call   10c8 <exit>
     ab5:	8d 76 00             	lea    0x0(%esi),%esi
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     ab8:	8d 45 f0             	lea    -0x10(%ebp),%eax
     abb:	89 04 24             	mov    %eax,(%esp)
     abe:	e8 15 06 00 00       	call   10d8 <pipe>
     ac3:	85 c0                	test   %eax,%eax
     ac5:	0f 88 25 01 00 00    	js     bf0 <runcmd+0x1e0>
      panic("pipe");
    if(fork1() == 0){
     acb:	e8 10 fe ff ff       	call   8e0 <fork1>
     ad0:	85 c0                	test   %eax,%eax
     ad2:	0f 84 b8 00 00 00    	je     b90 <runcmd+0x180>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
     ad8:	e8 03 fe ff ff       	call   8e0 <fork1>
     add:	85 c0                	test   %eax,%eax
     adf:	90                   	nop
     ae0:	74 6e                	je     b50 <runcmd+0x140>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
     ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ae5:	89 04 24             	mov    %eax,(%esp)
     ae8:	e8 03 06 00 00       	call   10f0 <close>
    close(p[1]);
     aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af0:	89 04 24             	mov    %eax,(%esp)
     af3:	e8 f8 05 00 00       	call   10f0 <close>
    wait();
     af8:	e8 d3 05 00 00       	call   10d0 <wait>
    wait();
     afd:	e8 ce 05 00 00       	call   10d0 <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
     b02:	e8 c1 05 00 00       	call   10c8 <exit>
     b07:	90                   	nop
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     b08:	8b 43 14             	mov    0x14(%ebx),%eax
     b0b:	89 04 24             	mov    %eax,(%esp)
     b0e:	e8 dd 05 00 00       	call   10f0 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     b13:	8b 43 10             	mov    0x10(%ebx),%eax
     b16:	89 44 24 04          	mov    %eax,0x4(%esp)
     b1a:	8b 43 08             	mov    0x8(%ebx),%eax
     b1d:	89 04 24             	mov    %eax,(%esp)
     b20:	e8 e3 05 00 00       	call   1108 <open>
     b25:	85 c0                	test   %eax,%eax
     b27:	0f 88 a3 00 00 00    	js     bd0 <runcmd+0x1c0>
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
     b2d:	8b 43 04             	mov    0x4(%ebx),%eax
     b30:	89 04 24             	mov    %eax,(%esp)
     b33:	e8 d8 fe ff ff       	call   a10 <runcmd>
    break;
  }
  exit();
     b38:	e8 8b 05 00 00       	call   10c8 <exit>
     b3d:	8d 76 00             	lea    0x0(%esi),%esi
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
     b40:	8b 43 04             	mov    0x4(%ebx),%eax
     b43:	89 04 24             	mov    %eax,(%esp)
     b46:	e8 c5 fe ff ff       	call   a10 <runcmd>
     b4b:	e9 4d ff ff ff       	jmp    a9d <runcmd+0x8d>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
     b50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b57:	e8 94 05 00 00       	call   10f0 <close>
      dup(p[0]);
     b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b5f:	89 04 24             	mov    %eax,(%esp)
     b62:	e8 d9 05 00 00       	call   1140 <dup>
      close(p[0]);
     b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b6a:	89 04 24             	mov    %eax,(%esp)
     b6d:	e8 7e 05 00 00       	call   10f0 <close>
      close(p[1]);
     b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b75:	89 04 24             	mov    %eax,(%esp)
     b78:	e8 73 05 00 00       	call   10f0 <close>
      runcmd(pcmd->right);
     b7d:	8b 43 08             	mov    0x8(%ebx),%eax
     b80:	89 04 24             	mov    %eax,(%esp)
     b83:	e8 88 fe ff ff       	call   a10 <runcmd>
     b88:	e9 55 ff ff ff       	jmp    ae2 <runcmd+0xd2>
     b8d:	8d 76 00             	lea    0x0(%esi),%esi
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b97:	e8 54 05 00 00       	call   10f0 <close>
      dup(p[1]);
     b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b9f:	89 04 24             	mov    %eax,(%esp)
     ba2:	e8 99 05 00 00       	call   1140 <dup>
      close(p[0]);
     ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     baa:	89 04 24             	mov    %eax,(%esp)
     bad:	e8 3e 05 00 00       	call   10f0 <close>
      close(p[1]);
     bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bb5:	89 04 24             	mov    %eax,(%esp)
     bb8:	e8 33 05 00 00       	call   10f0 <close>
      runcmd(pcmd->left);
     bbd:	8b 43 04             	mov    0x4(%ebx),%eax
     bc0:	89 04 24             	mov    %eax,(%esp)
     bc3:	e8 48 fe ff ff       	call   a10 <runcmd>
     bc8:	e9 0b ff ff ff       	jmp    ad8 <runcmd+0xc8>
     bcd:	8d 76 00             	lea    0x0(%esi),%esi

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     bd0:	8b 43 08             	mov    0x8(%ebx),%eax
     bd3:	c7 44 24 04 22 16 00 	movl   $0x1622,0x4(%esp)
     bda:	00 
     bdb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     be2:	89 44 24 08          	mov    %eax,0x8(%esp)
     be6:	e8 55 06 00 00       	call   1240 <printf>
      exit();
     beb:	e8 d8 04 00 00       	call   10c8 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     bf0:	c7 04 24 32 16 00 00 	movl   $0x1632,(%esp)
     bf7:	e8 b4 f4 ff ff       	call   b0 <panic>
     bfc:	e9 ca fe ff ff       	jmp    acb <runcmd+0xbb>
     c01:	eb 0d                	jmp    c10 <main>
     c03:	90                   	nop
     c04:	90                   	nop
     c05:	90                   	nop
     c06:	90                   	nop
     c07:	90                   	nop
     c08:	90                   	nop
     c09:	90                   	nop
     c0a:	90                   	nop
     c0b:	90                   	nop
     c0c:	90                   	nop
     c0d:	90                   	nop
     c0e:	90                   	nop
     c0f:	90                   	nop

00000c10 <main>:
  return 0;
}

int
main(void)
{
     c10:	55                   	push   %ebp
     c11:	89 e5                	mov    %esp,%ebp
     c13:	83 e4 f0             	and    $0xfffffff0,%esp
     c16:	83 ec 10             	sub    $0x10,%esp
     c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     c20:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     c27:	00 
     c28:	c7 04 24 37 16 00 00 	movl   $0x1637,(%esp)
     c2f:	e8 d4 04 00 00       	call   1108 <open>
     c34:	85 c0                	test   %eax,%eax
     c36:	78 10                	js     c48 <main+0x38>
    if(fd >= 3){
     c38:	83 f8 02             	cmp    $0x2,%eax
     c3b:	7e e3                	jle    c20 <main+0x10>
      close(fd);
     c3d:	89 04 24             	mov    %eax,(%esp)
     c40:	e8 ab 04 00 00       	call   10f0 <close>
     c45:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     c48:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     c4f:	00 
     c50:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     c57:	e8 54 fd ff ff       	call   9b0 <getcmd>
     c5c:	85 c0                	test   %eax,%eax
     c5e:	0f 88 fc 01 00 00    	js     e60 <main+0x250>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     c64:	80 3d c0 16 00 00 63 	cmpb   $0x63,0x16c0
     c6b:	75 0d                	jne    c7a <main+0x6a>
     c6d:	80 3d c1 16 00 00 64 	cmpb   $0x64,0x16c1
     c74:	0f 84 8e 01 00 00    	je     e08 <main+0x1f8>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(strcmp(buf, "tick\n") == 0)
     c7a:	c7 44 24 04 4d 16 00 	movl   $0x164d,0x4(%esp)
     c81:	00 
     c82:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     c89:	e8 32 02 00 00       	call   ec0 <strcmp>
     c8e:	85 c0                	test   %eax,%eax
     c90:	75 26                	jne    cb8 <main+0xa8>
     {
    	  printf(2, "Num Ticks: %d\n", tick());
     c92:	e8 c9 04 00 00       	call   1160 <tick>
     c97:	c7 44 24 04 53 16 00 	movl   $0x1653,0x4(%esp)
     c9e:	00 
     c9f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ca6:	89 44 24 08          	mov    %eax,0x8(%esp)
     caa:	e8 91 05 00 00       	call   1240 <printf>
     caf:	eb 97                	jmp    c48 <main+0x38>
     cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     }
    else if (strcmp(buf, "lottery_test\n") == 0)
     cb8:	c7 44 24 04 62 16 00 	movl   $0x1662,0x4(%esp)
     cbf:	00 
     cc0:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     cc7:	e8 f4 01 00 00       	call   ec0 <strcmp>
     ccc:	85 c0                	test   %eax,%eax
     cce:	0f 85 14 01 00 00    	jne    de8 <main+0x1d8>
     { 
     	 printf(2, "Starting lottery test.\n");
     cd4:	c7 44 24 04 70 16 00 	movl   $0x1670,0x4(%esp)
     cdb:	00 
     cdc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ce3:	e8 58 05 00 00       	call   1240 <printf>
     	 //this is a test 
     	 lottery_test(1);
     ce8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cef:	e8 4c fc ff ff       	call   940 <lottery_test>
     	 lottery_test(100);
     cf4:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     cfb:	e8 40 fc ff ff       	call   940 <lottery_test>
    	 lottery_test(50);
     d00:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     d07:	e8 34 fc ff ff       	call   940 <lottery_test>
     	 lottery_test(10000);
     d0c:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
     d13:	e8 28 fc ff ff       	call   940 <lottery_test>
     	 lottery_test(2);
     d18:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     d1f:	e8 1c fc ff ff       	call   940 <lottery_test>
     	 lottery_test(100);
     d24:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     d2b:	e8 10 fc ff ff       	call   940 <lottery_test>
     	 lottery_test(500);
     d30:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
     d37:	e8 04 fc ff ff       	call   940 <lottery_test>
     	 lottery_test(750);
     d3c:	c7 04 24 ee 02 00 00 	movl   $0x2ee,(%esp)
     d43:	e8 f8 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(250);
     d48:	c7 04 24 fa 00 00 00 	movl   $0xfa,(%esp)
     d4f:	e8 ec fb ff ff       	call   940 <lottery_test>
     	 lottery_test(225);
     d54:	c7 04 24 e1 00 00 00 	movl   $0xe1,(%esp)
     d5b:	e8 e0 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(10);
     d60:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
     d67:	e8 d4 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(75);
     d6c:	c7 04 24 4b 00 00 00 	movl   $0x4b,(%esp)
     d73:	e8 c8 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(900);
     d78:	c7 04 24 84 03 00 00 	movl   $0x384,(%esp)
     d7f:	e8 bc fb ff ff       	call   940 <lottery_test>
     	 lottery_test(600);
     d84:	c7 04 24 58 02 00 00 	movl   $0x258,(%esp)
     d8b:	e8 b0 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(835);
     d90:	c7 04 24 43 03 00 00 	movl   $0x343,(%esp)
     d97:	e8 a4 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(837);
     d9c:	c7 04 24 45 03 00 00 	movl   $0x345,(%esp)
     da3:	e8 98 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(234);
     da8:	c7 04 24 ea 00 00 00 	movl   $0xea,(%esp)
     daf:	e8 8c fb ff ff       	call   940 <lottery_test>
     	 lottery_test(234);
     db4:	c7 04 24 ea 00 00 00 	movl   $0xea,(%esp)
     dbb:	e8 80 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(400);
     dc0:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
     dc7:	e8 74 fb ff ff       	call   940 <lottery_test>
     	 lottery_test(25);
     dcc:	c7 04 24 19 00 00 00 	movl   $0x19,(%esp)
     dd3:	e8 68 fb ff ff       	call   940 <lottery_test>
     	 wait();
     dd8:	e8 f3 02 00 00       	call   10d0 <wait>
     ddd:	8d 76 00             	lea    0x0(%esi),%esi
     de0:	e9 63 fe ff ff       	jmp    c48 <main+0x38>
     de5:	8d 76 00             	lea    0x0(%esi),%esi
     de8:	90                   	nop
     de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     } 
     else
     {
    	if(fork1() == 0)
     df0:	e8 eb fa ff ff       	call   8e0 <fork1>
     df5:	85 c0                	test   %eax,%eax
     df7:	74 6f                	je     e68 <main+0x258>
      	  runcmd(parsecmd(buf));
    	wait();
     df9:	e8 d2 02 00 00       	call   10d0 <wait>
     dfe:	66 90                	xchg   %ax,%ax
     e00:	e9 43 fe ff ff       	jmp    c48 <main+0x38>
     e05:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e08:	80 3d c2 16 00 00 20 	cmpb   $0x20,0x16c2
     e0f:	90                   	nop
     e10:	0f 85 64 fe ff ff    	jne    c7a <main+0x6a>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e16:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     e1d:	e8 ee 00 00 00       	call   f10 <strlen>
      if(chdir(buf+3) < 0)
     e22:	c7 04 24 c3 16 00 00 	movl   $0x16c3,(%esp)
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e29:	c6 80 bf 16 00 00 00 	movb   $0x0,0x16bf(%eax)
      if(chdir(buf+3) < 0)
     e30:	e8 03 03 00 00       	call   1138 <chdir>
     e35:	85 c0                	test   %eax,%eax
     e37:	0f 89 0b fe ff ff    	jns    c48 <main+0x38>
        printf(2, "cannot cd %s\n", buf+3);
     e3d:	c7 44 24 08 c3 16 00 	movl   $0x16c3,0x8(%esp)
     e44:	00 
     e45:	c7 44 24 04 3f 16 00 	movl   $0x163f,0x4(%esp)
     e4c:	00 
     e4d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e54:	e8 e7 03 00 00       	call   1240 <printf>
     e59:	e9 ea fd ff ff       	jmp    c48 <main+0x38>
     e5e:	66 90                	xchg   %ax,%ax
    	if(fork1() == 0)
      	  runcmd(parsecmd(buf));
    	wait();
     }
  }
  exit();
     e60:	e8 63 02 00 00       	call   10c8 <exit>
     e65:	8d 76 00             	lea    0x0(%esi),%esi
     	 wait();
     } 
     else
     {
    	if(fork1() == 0)
      	  runcmd(parsecmd(buf));
     e68:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     e6f:	e8 ec f9 ff ff       	call   860 <parsecmd>
     e74:	89 04 24             	mov    %eax,(%esp)
     e77:	e8 94 fb ff ff       	call   a10 <runcmd>
     e7c:	e9 78 ff ff ff       	jmp    df9 <main+0x1e9>
     e81:	90                   	nop
     e82:	90                   	nop
     e83:	90                   	nop
     e84:	90                   	nop
     e85:	90                   	nop
     e86:	90                   	nop
     e87:	90                   	nop
     e88:	90                   	nop
     e89:	90                   	nop
     e8a:	90                   	nop
     e8b:	90                   	nop
     e8c:	90                   	nop
     e8d:	90                   	nop
     e8e:	90                   	nop
     e8f:	90                   	nop

00000e90 <strcpy>:
#include "fcntl.h"
#include "user.h"

char*
strcpy(char *s, char *t)
{
     e90:	55                   	push   %ebp
     e91:	31 d2                	xor    %edx,%edx
     e93:	89 e5                	mov    %esp,%ebp
     e95:	8b 45 08             	mov    0x8(%ebp),%eax
     e98:	53                   	push   %ebx
     e99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ea0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     ea4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     ea7:	83 c2 01             	add    $0x1,%edx
     eaa:	84 c9                	test   %cl,%cl
     eac:	75 f2                	jne    ea0 <strcpy+0x10>
    ;
  return os;
}
     eae:	5b                   	pop    %ebx
     eaf:	5d                   	pop    %ebp
     eb0:	c3                   	ret    
     eb1:	eb 0d                	jmp    ec0 <strcmp>
     eb3:	90                   	nop
     eb4:	90                   	nop
     eb5:	90                   	nop
     eb6:	90                   	nop
     eb7:	90                   	nop
     eb8:	90                   	nop
     eb9:	90                   	nop
     eba:	90                   	nop
     ebb:	90                   	nop
     ebc:	90                   	nop
     ebd:	90                   	nop
     ebe:	90                   	nop
     ebf:	90                   	nop

00000ec0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	53                   	push   %ebx
     ec4:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     eca:	0f b6 01             	movzbl (%ecx),%eax
     ecd:	84 c0                	test   %al,%al
     ecf:	75 14                	jne    ee5 <strcmp+0x25>
     ed1:	eb 25                	jmp    ef8 <strcmp+0x38>
     ed3:	90                   	nop
     ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
     ed8:	83 c1 01             	add    $0x1,%ecx
     edb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ede:	0f b6 01             	movzbl (%ecx),%eax
     ee1:	84 c0                	test   %al,%al
     ee3:	74 13                	je     ef8 <strcmp+0x38>
     ee5:	0f b6 1a             	movzbl (%edx),%ebx
     ee8:	38 d8                	cmp    %bl,%al
     eea:	74 ec                	je     ed8 <strcmp+0x18>
     eec:	0f b6 db             	movzbl %bl,%ebx
     eef:	0f b6 c0             	movzbl %al,%eax
     ef2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     ef4:	5b                   	pop    %ebx
     ef5:	5d                   	pop    %ebp
     ef6:	c3                   	ret    
     ef7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ef8:	0f b6 1a             	movzbl (%edx),%ebx
     efb:	31 c0                	xor    %eax,%eax
     efd:	0f b6 db             	movzbl %bl,%ebx
     f00:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     f02:	5b                   	pop    %ebx
     f03:	5d                   	pop    %ebp
     f04:	c3                   	ret    
     f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f10 <strlen>:

uint
strlen(char *s)
{
     f10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     f11:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f13:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
     f15:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     f1a:	80 39 00             	cmpb   $0x0,(%ecx)
     f1d:	74 0c                	je     f2b <strlen+0x1b>
     f1f:	90                   	nop
     f20:	83 c2 01             	add    $0x1,%edx
     f23:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     f27:	89 d0                	mov    %edx,%eax
     f29:	75 f5                	jne    f20 <strlen+0x10>
    ;
  return n;
}
     f2b:	5d                   	pop    %ebp
     f2c:	c3                   	ret    
     f2d:	8d 76 00             	lea    0x0(%esi),%esi

00000f30 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f36:	53                   	push   %ebx
     f37:	8b 45 08             	mov    0x8(%ebp),%eax
  char *d;
  
  d = dst;
  while(n-- > 0)
     f3a:	85 c9                	test   %ecx,%ecx
     f3c:	74 14                	je     f52 <memset+0x22>
     f3e:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx
     f42:	31 d2                	xor    %edx,%edx
     f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *d++ = c;
     f48:	88 1c 10             	mov    %bl,(%eax,%edx,1)
     f4b:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;
  
  d = dst;
  while(n-- > 0)
     f4e:	39 ca                	cmp    %ecx,%edx
     f50:	75 f6                	jne    f48 <memset+0x18>
    *d++ = c;
  return dst;
}
     f52:	5b                   	pop    %ebx
     f53:	5d                   	pop    %ebp
     f54:	c3                   	ret    
     f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f60 <strchr>:

char*
strchr(const char *s, char c)
{
     f60:	55                   	push   %ebp
     f61:	89 e5                	mov    %esp,%ebp
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     f6a:	0f b6 10             	movzbl (%eax),%edx
     f6d:	84 d2                	test   %dl,%dl
     f6f:	75 11                	jne    f82 <strchr+0x22>
     f71:	eb 15                	jmp    f88 <strchr+0x28>
     f73:	90                   	nop
     f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f78:	83 c0 01             	add    $0x1,%eax
     f7b:	0f b6 10             	movzbl (%eax),%edx
     f7e:	84 d2                	test   %dl,%dl
     f80:	74 06                	je     f88 <strchr+0x28>
    if(*s == c)
     f82:	38 ca                	cmp    %cl,%dl
     f84:	75 f2                	jne    f78 <strchr+0x18>
      return (char*) s;
  return 0;
}
     f86:	5d                   	pop    %ebp
     f87:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     f88:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
     f8a:	5d                   	pop    %ebp
     f8b:	90                   	nop
     f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f90:	c3                   	ret    
     f91:	eb 0d                	jmp    fa0 <atoi>
     f93:	90                   	nop
     f94:	90                   	nop
     f95:	90                   	nop
     f96:	90                   	nop
     f97:	90                   	nop
     f98:	90                   	nop
     f99:	90                   	nop
     f9a:	90                   	nop
     f9b:	90                   	nop
     f9c:	90                   	nop
     f9d:	90                   	nop
     f9e:	90                   	nop
     f9f:	90                   	nop

00000fa0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     fa0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fa1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
     fa3:	89 e5                	mov    %esp,%ebp
     fa5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     fa8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fa9:	0f b6 11             	movzbl (%ecx),%edx
     fac:	8d 5a d0             	lea    -0x30(%edx),%ebx
     faf:	80 fb 09             	cmp    $0x9,%bl
     fb2:	77 1c                	ja     fd0 <atoi+0x30>
     fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
     fb8:	0f be d2             	movsbl %dl,%edx
     fbb:	83 c1 01             	add    $0x1,%ecx
     fbe:	8d 04 80             	lea    (%eax,%eax,4),%eax
     fc1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fc5:	0f b6 11             	movzbl (%ecx),%edx
     fc8:	8d 5a d0             	lea    -0x30(%edx),%ebx
     fcb:	80 fb 09             	cmp    $0x9,%bl
     fce:	76 e8                	jbe    fb8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
     fd0:	5b                   	pop    %ebx
     fd1:	5d                   	pop    %ebp
     fd2:	c3                   	ret    
     fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000fe0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     fe0:	55                   	push   %ebp
     fe1:	89 e5                	mov    %esp,%ebp
     fe3:	56                   	push   %esi
     fe4:	8b 45 08             	mov    0x8(%ebp),%eax
     fe7:	53                   	push   %ebx
     fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
     feb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     fee:	85 db                	test   %ebx,%ebx
     ff0:	7e 14                	jle    1006 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
     ff2:	31 d2                	xor    %edx,%edx
     ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
     ff8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     ffc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     fff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1002:	39 da                	cmp    %ebx,%edx
    1004:	75 f2                	jne    ff8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1006:	5b                   	pop    %ebx
    1007:	5e                   	pop    %esi
    1008:	5d                   	pop    %ebp
    1009:	c3                   	ret    
    100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001010 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1016:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1019:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    101c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    101f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1024:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    102b:	00 
    102c:	89 04 24             	mov    %eax,(%esp)
    102f:	e8 d4 00 00 00       	call   1108 <open>
  if(fd < 0)
    1034:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1036:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    1038:	78 19                	js     1053 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    103a:	8b 45 0c             	mov    0xc(%ebp),%eax
    103d:	89 1c 24             	mov    %ebx,(%esp)
    1040:	89 44 24 04          	mov    %eax,0x4(%esp)
    1044:	e8 d7 00 00 00       	call   1120 <fstat>
  close(fd);
    1049:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    104c:	89 c6                	mov    %eax,%esi
  close(fd);
    104e:	e8 9d 00 00 00       	call   10f0 <close>
  return r;
}
    1053:	89 f0                	mov    %esi,%eax
    1055:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    1058:	8b 75 fc             	mov    -0x4(%ebp),%esi
    105b:	89 ec                	mov    %ebp,%esp
    105d:	5d                   	pop    %ebp
    105e:	c3                   	ret    
    105f:	90                   	nop

00001060 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	57                   	push   %edi
    1064:	56                   	push   %esi
    1065:	31 f6                	xor    %esi,%esi
    1067:	53                   	push   %ebx
    1068:	83 ec 2c             	sub    $0x2c,%esp
    106b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    106e:	eb 06                	jmp    1076 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1070:	3c 0a                	cmp    $0xa,%al
    1072:	74 39                	je     10ad <gets+0x4d>
    1074:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1076:	8d 5e 01             	lea    0x1(%esi),%ebx
    1079:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    107c:	7d 31                	jge    10af <gets+0x4f>
    cc = read(0, &c, 1);
    107e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1081:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1088:	00 
    1089:	89 44 24 04          	mov    %eax,0x4(%esp)
    108d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1094:	e8 47 00 00 00       	call   10e0 <read>
    if(cc < 1)
    1099:	85 c0                	test   %eax,%eax
    109b:	7e 12                	jle    10af <gets+0x4f>
      break;
    buf[i++] = c;
    109d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10a1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    10a5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10a9:	3c 0d                	cmp    $0xd,%al
    10ab:	75 c3                	jne    1070 <gets+0x10>
    10ad:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    10af:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    10b3:	89 f8                	mov    %edi,%eax
    10b5:	83 c4 2c             	add    $0x2c,%esp
    10b8:	5b                   	pop    %ebx
    10b9:	5e                   	pop    %esi
    10ba:	5f                   	pop    %edi
    10bb:	5d                   	pop    %ebp
    10bc:	c3                   	ret    
    10bd:	90                   	nop
    10be:	90                   	nop
    10bf:	90                   	nop

000010c0 <fork>:
    10c0:	b8 01 00 00 00       	mov    $0x1,%eax
    10c5:	cd 30                	int    $0x30
    10c7:	c3                   	ret    

000010c8 <exit>:
    10c8:	b8 02 00 00 00       	mov    $0x2,%eax
    10cd:	cd 30                	int    $0x30
    10cf:	c3                   	ret    

000010d0 <wait>:
    10d0:	b8 03 00 00 00       	mov    $0x3,%eax
    10d5:	cd 30                	int    $0x30
    10d7:	c3                   	ret    

000010d8 <pipe>:
    10d8:	b8 04 00 00 00       	mov    $0x4,%eax
    10dd:	cd 30                	int    $0x30
    10df:	c3                   	ret    

000010e0 <read>:
    10e0:	b8 06 00 00 00       	mov    $0x6,%eax
    10e5:	cd 30                	int    $0x30
    10e7:	c3                   	ret    

000010e8 <write>:
    10e8:	b8 05 00 00 00       	mov    $0x5,%eax
    10ed:	cd 30                	int    $0x30
    10ef:	c3                   	ret    

000010f0 <close>:
    10f0:	b8 07 00 00 00       	mov    $0x7,%eax
    10f5:	cd 30                	int    $0x30
    10f7:	c3                   	ret    

000010f8 <kill>:
    10f8:	b8 08 00 00 00       	mov    $0x8,%eax
    10fd:	cd 30                	int    $0x30
    10ff:	c3                   	ret    

00001100 <exec>:
    1100:	b8 09 00 00 00       	mov    $0x9,%eax
    1105:	cd 30                	int    $0x30
    1107:	c3                   	ret    

00001108 <open>:
    1108:	b8 0a 00 00 00       	mov    $0xa,%eax
    110d:	cd 30                	int    $0x30
    110f:	c3                   	ret    

00001110 <mknod>:
    1110:	b8 0b 00 00 00       	mov    $0xb,%eax
    1115:	cd 30                	int    $0x30
    1117:	c3                   	ret    

00001118 <unlink>:
    1118:	b8 0c 00 00 00       	mov    $0xc,%eax
    111d:	cd 30                	int    $0x30
    111f:	c3                   	ret    

00001120 <fstat>:
    1120:	b8 0d 00 00 00       	mov    $0xd,%eax
    1125:	cd 30                	int    $0x30
    1127:	c3                   	ret    

00001128 <link>:
    1128:	b8 0e 00 00 00       	mov    $0xe,%eax
    112d:	cd 30                	int    $0x30
    112f:	c3                   	ret    

00001130 <mkdir>:
    1130:	b8 0f 00 00 00       	mov    $0xf,%eax
    1135:	cd 30                	int    $0x30
    1137:	c3                   	ret    

00001138 <chdir>:
    1138:	b8 10 00 00 00       	mov    $0x10,%eax
    113d:	cd 30                	int    $0x30
    113f:	c3                   	ret    

00001140 <dup>:
    1140:	b8 11 00 00 00       	mov    $0x11,%eax
    1145:	cd 30                	int    $0x30
    1147:	c3                   	ret    

00001148 <getpid>:
    1148:	b8 12 00 00 00       	mov    $0x12,%eax
    114d:	cd 30                	int    $0x30
    114f:	c3                   	ret    

00001150 <sbrk>:
    1150:	b8 13 00 00 00       	mov    $0x13,%eax
    1155:	cd 30                	int    $0x30
    1157:	c3                   	ret    

00001158 <sleep>:
    1158:	b8 14 00 00 00       	mov    $0x14,%eax
    115d:	cd 30                	int    $0x30
    115f:	c3                   	ret    

00001160 <tick>:
    1160:	b8 15 00 00 00       	mov    $0x15,%eax
    1165:	cd 30                	int    $0x30
    1167:	c3                   	ret    

00001168 <fork_tickets>:
    1168:	b8 16 00 00 00       	mov    $0x16,%eax
    116d:	cd 30                	int    $0x30
    116f:	c3                   	ret    

00001170 <fork_thread>:
    1170:	b8 17 00 00 00       	mov    $0x17,%eax
    1175:	cd 30                	int    $0x30
    1177:	c3                   	ret    

00001178 <wait_thread>:
    1178:	b8 18 00 00 00       	mov    $0x18,%eax
    117d:	cd 30                	int    $0x30
    117f:	c3                   	ret    

00001180 <putc>:

//struct mutex_t plock;

static void
putc(int fd, char c)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	83 ec 28             	sub    $0x28,%esp
    1186:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    1189:	8d 55 f4             	lea    -0xc(%ebp),%edx
    118c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1193:	00 
    1194:	89 54 24 04          	mov    %edx,0x4(%esp)
    1198:	89 04 24             	mov    %eax,(%esp)
    119b:	e8 48 ff ff ff       	call   10e8 <write>
}
    11a0:	c9                   	leave  
    11a1:	c3                   	ret    
    11a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	57                   	push   %edi
    11b4:	89 c7                	mov    %eax,%edi
    11b6:	56                   	push   %esi
    11b7:	89 ce                	mov    %ecx,%esi
    11b9:	53                   	push   %ebx
    11ba:	83 ec 2c             	sub    $0x2c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    11bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11c0:	85 c9                	test   %ecx,%ecx
    11c2:	74 04                	je     11c8 <printint+0x18>
    11c4:	85 d2                	test   %edx,%edx
    11c6:	78 5d                	js     1225 <printint+0x75>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    11c8:	89 d0                	mov    %edx,%eax
    11ca:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    11d1:	31 c9                	xor    %ecx,%ecx
    11d3:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    11d6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    11d8:	31 d2                	xor    %edx,%edx
    11da:	f7 f6                	div    %esi
    11dc:	0f b6 92 8f 16 00 00 	movzbl 0x168f(%edx),%edx
    11e3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    11e6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    11e9:	85 c0                	test   %eax,%eax
    11eb:	75 eb                	jne    11d8 <printint+0x28>
  if(neg)
    11ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    11f0:	85 c0                	test   %eax,%eax
    11f2:	74 08                	je     11fc <printint+0x4c>
    buf[i++] = '-';
    11f4:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
    11f9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    11fc:	8d 71 ff             	lea    -0x1(%ecx),%esi
    11ff:	01 f3                	add    %esi,%ebx
    1201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
    1208:	0f be 13             	movsbl (%ebx),%edx
    120b:	89 f8                	mov    %edi,%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    120d:	83 ee 01             	sub    $0x1,%esi
    1210:	83 eb 01             	sub    $0x1,%ebx
    putc(fd, buf[i]);
    1213:	e8 68 ff ff ff       	call   1180 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1218:	83 fe ff             	cmp    $0xffffffff,%esi
    121b:	75 eb                	jne    1208 <printint+0x58>
    putc(fd, buf[i]);
}
    121d:	83 c4 2c             	add    $0x2c,%esp
    1220:	5b                   	pop    %ebx
    1221:	5e                   	pop    %esi
    1222:	5f                   	pop    %edi
    1223:	5d                   	pop    %ebp
    1224:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1225:	89 d0                	mov    %edx,%eax
    1227:	f7 d8                	neg    %eax
    1229:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    1230:	eb 9f                	jmp    11d1 <printint+0x21>
    1232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001240 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	57                   	push   %edi
    1244:	56                   	push   %esi
    1245:	53                   	push   %ebx
    1246:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1249:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    124c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    124f:	0f b6 08             	movzbl (%eax),%ecx
    1252:	84 c9                	test   %cl,%cl
    1254:	0f 84 96 00 00 00    	je     12f0 <printf+0xb0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    125a:	8d 55 10             	lea    0x10(%ebp),%edx
    125d:	31 f6                	xor    %esi,%esi
    125f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    1262:	31 db                	xor    %ebx,%ebx
    1264:	eb 1a                	jmp    1280 <printf+0x40>
    1266:	66 90                	xchg   %ax,%ax
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1268:	83 f9 25             	cmp    $0x25,%ecx
    126b:	0f 85 87 00 00 00    	jne    12f8 <printf+0xb8>
    1271:	66 be 25 00          	mov    $0x25,%si
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1275:	83 c3 01             	add    $0x1,%ebx
    1278:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
    127c:	84 c9                	test   %cl,%cl
    127e:	74 70                	je     12f0 <printf+0xb0>
    c = fmt[i] & 0xff;
    if(state == 0){
    1280:	85 f6                	test   %esi,%esi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1282:	0f b6 c9             	movzbl %cl,%ecx
    if(state == 0){
    1285:	74 e1                	je     1268 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1287:	83 fe 25             	cmp    $0x25,%esi
    128a:	75 e9                	jne    1275 <printf+0x35>
      if(c == 'd'){
    128c:	83 f9 64             	cmp    $0x64,%ecx
    128f:	90                   	nop
    1290:	0f 84 fa 00 00 00    	je     1390 <printf+0x150>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1296:	83 f9 70             	cmp    $0x70,%ecx
    1299:	74 75                	je     1310 <printf+0xd0>
    129b:	83 f9 78             	cmp    $0x78,%ecx
    129e:	66 90                	xchg   %ax,%ax
    12a0:	74 6e                	je     1310 <printf+0xd0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    12a2:	83 f9 73             	cmp    $0x73,%ecx
    12a5:	0f 84 8d 00 00 00    	je     1338 <printf+0xf8>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12ab:	83 f9 63             	cmp    $0x63,%ecx
    12ae:	66 90                	xchg   %ax,%ax
    12b0:	0f 84 fe 00 00 00    	je     13b4 <printf+0x174>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    12b6:	83 f9 25             	cmp    $0x25,%ecx
    12b9:	0f 84 b9 00 00 00    	je     1378 <printf+0x138>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    12bf:	ba 25 00 00 00       	mov    $0x25,%edx
    12c4:	89 f8                	mov    %edi,%eax
    12c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12c9:	83 c3 01             	add    $0x1,%ebx
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    12cc:	31 f6                	xor    %esi,%esi
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    12ce:	e8 ad fe ff ff       	call   1180 <putc>
        putc(fd, c);
    12d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    12d6:	89 f8                	mov    %edi,%eax
    12d8:	0f be d1             	movsbl %cl,%edx
    12db:	e8 a0 fe ff ff       	call   1180 <putc>
    12e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12e3:	0f b6 0c 18          	movzbl (%eax,%ebx,1),%ecx
    12e7:	84 c9                	test   %cl,%cl
    12e9:	75 95                	jne    1280 <printf+0x40>
    12eb:	90                   	nop
    12ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
      state = 0;
    }
  }
 // mutex_unlock(&plock);
}
    12f0:	83 c4 2c             	add    $0x2c,%esp
    12f3:	5b                   	pop    %ebx
    12f4:	5e                   	pop    %esi
    12f5:	5f                   	pop    %edi
    12f6:	5d                   	pop    %ebp
    12f7:	c3                   	ret    
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    12f8:	89 f8                	mov    %edi,%eax
    12fa:	0f be d1             	movsbl %cl,%edx
    12fd:	e8 7e fe ff ff       	call   1180 <putc>
    1302:	8b 45 0c             	mov    0xc(%ebp),%eax
    1305:	e9 6b ff ff ff       	jmp    1275 <printf+0x35>
    130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1313:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    1318:	31 f6                	xor    %esi,%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    131a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1321:	8b 10                	mov    (%eax),%edx
    1323:	89 f8                	mov    %edi,%eax
    1325:	e8 86 fe ff ff       	call   11b0 <printint>
    132a:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    132d:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    1331:	e9 3f ff ff ff       	jmp    1275 <printf+0x35>
    1336:	66 90                	xchg   %ax,%ax
      } else if(c == 's'){
        s = (char*)*ap;
    1338:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    133b:	8b 32                	mov    (%edx),%esi
        ap++;
    133d:	83 c2 04             	add    $0x4,%edx
    1340:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        if(s == 0)
    1343:	85 f6                	test   %esi,%esi
    1345:	0f 84 84 00 00 00    	je     13cf <printf+0x18f>
          s = "(null)";
        while(*s != 0){
    134b:	0f b6 16             	movzbl (%esi),%edx
    134e:	84 d2                	test   %dl,%dl
    1350:	74 1d                	je     136f <printf+0x12f>
    1352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          putc(fd, *s);
    1358:	0f be d2             	movsbl %dl,%edx
          s++;
    135b:	83 c6 01             	add    $0x1,%esi
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
    135e:	89 f8                	mov    %edi,%eax
    1360:	e8 1b fe ff ff       	call   1180 <putc>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1365:	0f b6 16             	movzbl (%esi),%edx
    1368:	84 d2                	test   %dl,%dl
    136a:	75 ec                	jne    1358 <printf+0x118>
    136c:	8b 45 0c             	mov    0xc(%ebp),%eax
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    136f:	31 f6                	xor    %esi,%esi
    1371:	e9 ff fe ff ff       	jmp    1275 <printf+0x35>
    1376:	66 90                	xchg   %ax,%ax
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
        putc(fd, c);
    1378:	89 f8                	mov    %edi,%eax
    137a:	ba 25 00 00 00       	mov    $0x25,%edx
    137f:	e8 fc fd ff ff       	call   1180 <putc>
    1384:	31 f6                	xor    %esi,%esi
    1386:	8b 45 0c             	mov    0xc(%ebp),%eax
    1389:	e9 e7 fe ff ff       	jmp    1275 <printf+0x35>
    138e:	66 90                	xchg   %ax,%ax
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1393:	b1 0a                	mov    $0xa,%cl
        ap++;
    1395:	66 31 f6             	xor    %si,%si
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1398:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    139f:	8b 10                	mov    (%eax),%edx
    13a1:	89 f8                	mov    %edi,%eax
    13a3:	e8 08 fe ff ff       	call   11b0 <printint>
    13a8:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    13ab:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    13af:	e9 c1 fe ff ff       	jmp    1275 <printf+0x35>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    13b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        ap++;
    13b7:	31 f6                	xor    %esi,%esi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    13b9:	0f be 10             	movsbl (%eax),%edx
    13bc:	89 f8                	mov    %edi,%eax
    13be:	e8 bd fd ff ff       	call   1180 <putc>
    13c3:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    13c6:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
    13ca:	e9 a6 fe ff ff       	jmp    1275 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
    13cf:	be 88 16 00 00       	mov    $0x1688,%esi
    13d4:	e9 72 ff ff ff       	jmp    134b <printf+0x10b>
    13d9:	90                   	nop
    13da:	90                   	nop
    13db:	90                   	nop
    13dc:	90                   	nop
    13dd:	90                   	nop
    13de:	90                   	nop
    13df:	90                   	nop

000013e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    13e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13e1:	a1 2c 17 00 00       	mov    0x172c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    13e6:	89 e5                	mov    %esp,%ebp
    13e8:	57                   	push   %edi
    13e9:	56                   	push   %esi
    13ea:	53                   	push   %ebx
    13eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    13ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13f1:	39 c8                	cmp    %ecx,%eax
    13f3:	73 1d                	jae    1412 <free+0x32>
    13f5:	8d 76 00             	lea    0x0(%esi),%esi
    13f8:	8b 10                	mov    (%eax),%edx
    13fa:	39 d1                	cmp    %edx,%ecx
    13fc:	72 1a                	jb     1418 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13fe:	39 d0                	cmp    %edx,%eax
    1400:	72 08                	jb     140a <free+0x2a>
    1402:	39 c8                	cmp    %ecx,%eax
    1404:	72 12                	jb     1418 <free+0x38>
    1406:	39 d1                	cmp    %edx,%ecx
    1408:	72 0e                	jb     1418 <free+0x38>
    140a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    140c:	39 c8                	cmp    %ecx,%eax
    140e:	66 90                	xchg   %ax,%ax
    1410:	72 e6                	jb     13f8 <free+0x18>
    1412:	8b 10                	mov    (%eax),%edx
    1414:	eb e8                	jmp    13fe <free+0x1e>
    1416:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1418:	8b 71 04             	mov    0x4(%ecx),%esi
    141b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    141e:	39 d7                	cmp    %edx,%edi
    1420:	74 19                	je     143b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1422:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1425:	8b 50 04             	mov    0x4(%eax),%edx
    1428:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    142b:	39 ce                	cmp    %ecx,%esi
    142d:	74 21                	je     1450 <free+0x70>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    142f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1431:	a3 2c 17 00 00       	mov    %eax,0x172c
}
    1436:	5b                   	pop    %ebx
    1437:	5e                   	pop    %esi
    1438:	5f                   	pop    %edi
    1439:	5d                   	pop    %ebp
    143a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    143b:	03 72 04             	add    0x4(%edx),%esi
    bp->s.ptr = p->s.ptr->s.ptr;
    143e:	8b 12                	mov    (%edx),%edx
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1440:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1443:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1446:	8b 50 04             	mov    0x4(%eax),%edx
    1449:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    144c:	39 ce                	cmp    %ecx,%esi
    144e:	75 df                	jne    142f <free+0x4f>
    p->s.size += bp->s.size;
    1450:	03 51 04             	add    0x4(%ecx),%edx
    1453:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1456:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1459:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    145b:	a3 2c 17 00 00       	mov    %eax,0x172c
}
    1460:	5b                   	pop    %ebx
    1461:	5e                   	pop    %esi
    1462:	5f                   	pop    %edi
    1463:	5d                   	pop    %ebp
    1464:	c3                   	ret    
    1465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001470 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1470:	55                   	push   %ebp
    1471:	89 e5                	mov    %esp,%ebp
    1473:	57                   	push   %edi
    1474:	56                   	push   %esi
    1475:	53                   	push   %ebx
    1476:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    147c:	8b 0d 2c 17 00 00    	mov    0x172c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1482:	83 c3 07             	add    $0x7,%ebx
    1485:	c1 eb 03             	shr    $0x3,%ebx
    1488:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    148b:	85 c9                	test   %ecx,%ecx
    148d:	0f 84 93 00 00 00    	je     1526 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1493:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    1495:	8b 50 04             	mov    0x4(%eax),%edx
    1498:	39 d3                	cmp    %edx,%ebx
    149a:	76 1f                	jbe    14bb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    149c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    14a3:	90                   	nop
    14a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
    14a8:	3b 05 2c 17 00 00    	cmp    0x172c,%eax
    14ae:	74 30                	je     14e0 <malloc+0x70>
    14b0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14b2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    14b4:	8b 50 04             	mov    0x4(%eax),%edx
    14b7:	39 d3                	cmp    %edx,%ebx
    14b9:	77 ed                	ja     14a8 <malloc+0x38>
      if(p->s.size == nunits)
    14bb:	39 d3                	cmp    %edx,%ebx
    14bd:	74 61                	je     1520 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    14bf:	29 da                	sub    %ebx,%edx
    14c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    14c4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    14c7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    14ca:	89 0d 2c 17 00 00    	mov    %ecx,0x172c
      return (void*) (p + 1);
    14d0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    14d3:	83 c4 1c             	add    $0x1c,%esp
    14d6:	5b                   	pop    %ebx
    14d7:	5e                   	pop    %esi
    14d8:	5f                   	pop    %edi
    14d9:	5d                   	pop    %ebp
    14da:	c3                   	ret    
    14db:	90                   	nop
    14dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < PAGE)
    14e0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    14e6:	b8 00 80 00 00       	mov    $0x8000,%eax
    14eb:	bf 00 10 00 00       	mov    $0x1000,%edi
    14f0:	76 04                	jbe    14f6 <malloc+0x86>
    14f2:	89 f0                	mov    %esi,%eax
    14f4:	89 df                	mov    %ebx,%edi
    nu = PAGE;
  p = sbrk(nu * sizeof(Header));
    14f6:	89 04 24             	mov    %eax,(%esp)
    14f9:	e8 52 fc ff ff       	call   1150 <sbrk>
  if(p == (char*) -1)
    14fe:	83 f8 ff             	cmp    $0xffffffff,%eax
    1501:	74 18                	je     151b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1503:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1506:	83 c0 08             	add    $0x8,%eax
    1509:	89 04 24             	mov    %eax,(%esp)
    150c:	e8 cf fe ff ff       	call   13e0 <free>
  return freep;
    1511:	8b 0d 2c 17 00 00    	mov    0x172c,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1517:	85 c9                	test   %ecx,%ecx
    1519:	75 97                	jne    14b2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    151b:	31 c0                	xor    %eax,%eax
    151d:	eb b4                	jmp    14d3 <malloc+0x63>
    151f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1520:	8b 10                	mov    (%eax),%edx
    1522:	89 11                	mov    %edx,(%ecx)
    1524:	eb a4                	jmp    14ca <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1526:	c7 05 2c 17 00 00 24 	movl   $0x1724,0x172c
    152d:	17 00 00 
    base.s.size = 0;
    1530:	b9 24 17 00 00       	mov    $0x1724,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1535:	c7 05 24 17 00 00 24 	movl   $0x1724,0x1724
    153c:	17 00 00 
    base.s.size = 0;
    153f:	c7 05 28 17 00 00 00 	movl   $0x0,0x1728
    1546:	00 00 00 
    1549:	e9 45 ff ff ff       	jmp    1493 <malloc+0x23>
