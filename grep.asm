
_grep：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
   c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
   f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  13:	0f 8e 8b 00 00 00    	jle    a4 <main+0xa4>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  19:	8b 43 04             	mov    0x4(%ebx),%eax
  1c:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
  1f:	be 02 00 00 00       	mov    $0x2,%esi
  24:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  pattern = argv[1];
  28:	89 44 24 0c          	mov    %eax,0xc(%esp)
  if(argc <= 2){
  2c:	74 61                	je     8f <main+0x8f>
  2e:	66 90                	xchg   %ax,%ax
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  37:	00 
  38:	8b 03                	mov    (%ebx),%eax
  3a:	89 04 24             	mov    %eax,(%esp)
  3d:	e8 30 05 00 00       	call   572 <open>
  42:	85 c0                	test   %eax,%eax
  44:	89 c7                	mov    %eax,%edi
  46:	78 28                	js     70 <main+0x70>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  48:	89 44 24 04          	mov    %eax,0x4(%esp)
  4c:	8b 44 24 0c          	mov    0xc(%esp),%eax
  for(i = 2; i < argc; i++){
  50:	83 c6 01             	add    $0x1,%esi
  53:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
  56:	89 04 24             	mov    %eax,(%esp)
  59:	e8 a2 01 00 00       	call   200 <grep>
    close(fd);
  5e:	89 3c 24             	mov    %edi,(%esp)
  61:	e8 f4 04 00 00       	call   55a <close>
  for(i = 2; i < argc; i++){
  66:	39 75 08             	cmp    %esi,0x8(%ebp)
  69:	7f c5                	jg     30 <main+0x30>
  }
  exit();
  6b:	e8 c2 04 00 00       	call   532 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
  70:	8b 03                	mov    (%ebx),%eax
  72:	c7 44 24 04 d0 0a 00 	movl   $0xad0,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	e8 16 06 00 00       	call   6a0 <printf>
      exit();
  8a:	e8 a3 04 00 00       	call   532 <exit>
    grep(pattern, 0);
  8f:	89 04 24             	mov    %eax,(%esp)
  92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  99:	00 
  9a:	e8 61 01 00 00       	call   200 <grep>
    exit();
  9f:	e8 8e 04 00 00       	call   532 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  a4:	c7 44 24 04 b0 0a 00 	movl   $0xab0,0x4(%esp)
  ab:	00 
  ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  b3:	e8 e8 05 00 00       	call   6a0 <printf>
    exit();
  b8:	e8 75 04 00 00       	call   532 <exit>
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 1c             	sub    $0x1c,%esp
  c9:	8b 75 08             	mov    0x8(%ebp),%esi
  cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  dc:	89 3c 24             	mov    %edi,(%esp)
  df:	e8 3c 00 00 00       	call   120 <matchhere>
  e4:	85 c0                	test   %eax,%eax
  e6:	75 20                	jne    108 <matchstar+0x48>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  e8:	0f be 13             	movsbl (%ebx),%edx
  eb:	84 d2                	test   %dl,%dl
  ed:	74 0c                	je     fb <matchstar+0x3b>
  ef:	83 c3 01             	add    $0x1,%ebx
  f2:	39 f2                	cmp    %esi,%edx
  f4:	74 e2                	je     d8 <matchstar+0x18>
  f6:	83 fe 2e             	cmp    $0x2e,%esi
  f9:	74 dd                	je     d8 <matchstar+0x18>
  return 0;
}
  fb:	83 c4 1c             	add    $0x1c,%esp
  fe:	5b                   	pop    %ebx
  ff:	5e                   	pop    %esi
 100:	5f                   	pop    %edi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	90                   	nop
 104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 108:	83 c4 1c             	add    $0x1c,%esp
      return 1;
 10b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 110:	5b                   	pop    %ebx
 111:	5e                   	pop    %esi
 112:	5f                   	pop    %edi
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
 115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <matchhere>:
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	83 ec 14             	sub    $0x14,%esp
 127:	8b 55 08             	mov    0x8(%ebp),%edx
 12a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(re[0] == '\0')
 12d:	0f be 02             	movsbl (%edx),%eax
 130:	84 c0                	test   %al,%al
 132:	75 20                	jne    154 <matchhere+0x34>
 134:	eb 42                	jmp    178 <matchhere+0x58>
 136:	66 90                	xchg   %ax,%ax
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 138:	0f b6 19             	movzbl (%ecx),%ebx
 13b:	84 db                	test   %bl,%bl
 13d:	74 31                	je     170 <matchhere+0x50>
 13f:	3c 2e                	cmp    $0x2e,%al
 141:	74 04                	je     147 <matchhere+0x27>
 143:	38 d8                	cmp    %bl,%al
 145:	75 29                	jne    170 <matchhere+0x50>
    return matchhere(re+1, text+1);
 147:	83 c2 01             	add    $0x1,%edx
  if(re[0] == '\0')
 14a:	0f be 02             	movsbl (%edx),%eax
    return matchhere(re+1, text+1);
 14d:	83 c1 01             	add    $0x1,%ecx
  if(re[0] == '\0')
 150:	84 c0                	test   %al,%al
 152:	74 24                	je     178 <matchhere+0x58>
  if(re[1] == '*')
 154:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
 158:	80 fb 2a             	cmp    $0x2a,%bl
 15b:	74 2b                	je     188 <matchhere+0x68>
  if(re[0] == '$' && re[1] == '\0')
 15d:	3c 24                	cmp    $0x24,%al
 15f:	75 d7                	jne    138 <matchhere+0x18>
 161:	84 db                	test   %bl,%bl
 163:	74 3c                	je     1a1 <matchhere+0x81>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 165:	0f b6 19             	movzbl (%ecx),%ebx
 168:	84 db                	test   %bl,%bl
 16a:	75 d7                	jne    143 <matchhere+0x23>
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	83 c4 14             	add    $0x14,%esp
 175:	5b                   	pop    %ebx
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
 178:	83 c4 14             	add    $0x14,%esp
    return 1;
 17b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 180:	5b                   	pop    %ebx
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    
 183:	90                   	nop
 184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return matchstar(re[0], re+2, text);
 188:	83 c2 02             	add    $0x2,%edx
 18b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 18f:	89 54 24 04          	mov    %edx,0x4(%esp)
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 25 ff ff ff       	call   c0 <matchstar>
}
 19b:	83 c4 14             	add    $0x14,%esp
 19e:	5b                   	pop    %ebx
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
    return *text == '\0';
 1a1:	31 c0                	xor    %eax,%eax
 1a3:	80 39 00             	cmpb   $0x0,(%ecx)
 1a6:	0f 94 c0             	sete   %al
 1a9:	eb c7                	jmp    172 <matchhere+0x52>
 1ab:	90                   	nop
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <match>:
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
 1b5:	83 ec 10             	sub    $0x10,%esp
 1b8:	8b 75 08             	mov    0x8(%ebp),%esi
 1bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
 1be:	80 3e 5e             	cmpb   $0x5e,(%esi)
 1c1:	75 0e                	jne    1d1 <match+0x21>
 1c3:	eb 28                	jmp    1ed <match+0x3d>
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
 1c8:	83 c3 01             	add    $0x1,%ebx
 1cb:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
 1cf:	74 15                	je     1e6 <match+0x36>
    if(matchhere(re, text))
 1d1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 1d5:	89 34 24             	mov    %esi,(%esp)
 1d8:	e8 43 ff ff ff       	call   120 <matchhere>
 1dd:	85 c0                	test   %eax,%eax
 1df:	74 e7                	je     1c8 <match+0x18>
      return 1;
 1e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
    return matchhere(re+1, text);
 1ed:	83 c6 01             	add    $0x1,%esi
 1f0:	89 75 08             	mov    %esi,0x8(%ebp)
}
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	5b                   	pop    %ebx
 1f7:	5e                   	pop    %esi
 1f8:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1f9:	e9 22 ff ff ff       	jmp    120 <matchhere>
 1fe:	66 90                	xchg   %ax,%ax

00000200 <grep>:
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
 206:	83 ec 1c             	sub    $0x1c,%esp
 209:	8b 75 08             	mov    0x8(%ebp),%esi
  m = 0;
 20c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 213:	90                   	nop
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 218:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 21b:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 220:	29 d0                	sub    %edx,%eax
 222:	89 44 24 08          	mov    %eax,0x8(%esp)
 226:	89 d0                	mov    %edx,%eax
 228:	05 00 0f 00 00       	add    $0xf00,%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 0e 03 00 00       	call   54a <read>
 23c:	85 c0                	test   %eax,%eax
 23e:	0f 8e b8 00 00 00    	jle    2fc <grep+0xfc>
    m += n;
 244:	01 45 e4             	add    %eax,-0x1c(%ebp)
    p = buf;
 247:	bb 00 0f 00 00       	mov    $0xf00,%ebx
    buf[m] = '\0';
 24c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 24f:	c6 80 00 0f 00 00 00 	movb   $0x0,0xf00(%eax)
 256:	66 90                	xchg   %ax,%ax
    while((q = strchr(p, '\n')) != 0){
 258:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 25f:	00 
 260:	89 1c 24             	mov    %ebx,(%esp)
 263:	e8 78 01 00 00       	call   3e0 <strchr>
 268:	85 c0                	test   %eax,%eax
 26a:	89 c7                	mov    %eax,%edi
 26c:	74 42                	je     2b0 <grep+0xb0>
      *q = 0;
 26e:	c6 07 00             	movb   $0x0,(%edi)
      if(match(pattern, p)){
 271:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 275:	89 34 24             	mov    %esi,(%esp)
 278:	e8 33 ff ff ff       	call   1b0 <match>
 27d:	85 c0                	test   %eax,%eax
 27f:	75 07                	jne    288 <grep+0x88>
 281:	8d 5f 01             	lea    0x1(%edi),%ebx
 284:	eb d2                	jmp    258 <grep+0x58>
 286:	66 90                	xchg   %ax,%ax
        *q = '\n';
 288:	c6 07 0a             	movb   $0xa,(%edi)
        write(1, p, q+1 - p);
 28b:	83 c7 01             	add    $0x1,%edi
 28e:	89 f8                	mov    %edi,%eax
 290:	29 d8                	sub    %ebx,%eax
 292:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 296:	89 fb                	mov    %edi,%ebx
 298:	89 44 24 08          	mov    %eax,0x8(%esp)
 29c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a3:	e8 aa 02 00 00       	call   552 <write>
 2a8:	eb ae                	jmp    258 <grep+0x58>
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p == buf)
 2b0:	81 fb 00 0f 00 00    	cmp    $0xf00,%ebx
 2b6:	74 38                	je     2f0 <grep+0xf0>
    if(m > 0){
 2b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2bb:	85 c0                	test   %eax,%eax
 2bd:	0f 8e 55 ff ff ff    	jle    218 <grep+0x18>
      m -= p - buf;
 2c3:	b8 00 0f 00 00       	mov    $0xf00,%eax
 2c8:	29 d8                	sub    %ebx,%eax
 2ca:	01 45 e4             	add    %eax,-0x1c(%ebp)
      memmove(buf, p, m);
 2cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 2d4:	c7 04 24 00 0f 00 00 	movl   $0xf00,(%esp)
 2db:	89 44 24 08          	mov    %eax,0x8(%esp)
 2df:	e8 1c 02 00 00       	call   500 <memmove>
 2e4:	e9 2f ff ff ff       	jmp    218 <grep+0x18>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      m = 0;
 2f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 2f7:	e9 1c ff ff ff       	jmp    218 <grep+0x18>
}
 2fc:	83 c4 1c             	add    $0x1c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    
 304:	66 90                	xchg   %ax,%ax
 306:	66 90                	xchg   %ax,%ax
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 319:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 320:	83 c1 01             	add    $0x1,%ecx
 323:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 327:	83 c2 01             	add    $0x1,%edx
 32a:	84 db                	test   %bl,%bl
 32c:	88 5a ff             	mov    %bl,-0x1(%edx)
 32f:	75 ef                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 331:	5b                   	pop    %ebx
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 55 08             	mov    0x8(%ebp),%edx
 346:	53                   	push   %ebx
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 34a:	0f b6 02             	movzbl (%edx),%eax
 34d:	84 c0                	test   %al,%al
 34f:	74 2d                	je     37e <strcmp+0x3e>
 351:	0f b6 19             	movzbl (%ecx),%ebx
 354:	38 d8                	cmp    %bl,%al
 356:	74 0e                	je     366 <strcmp+0x26>
 358:	eb 2b                	jmp    385 <strcmp+0x45>
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 360:	38 c8                	cmp    %cl,%al
 362:	75 15                	jne    379 <strcmp+0x39>
    p++, q++;
 364:	89 d9                	mov    %ebx,%ecx
 366:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 369:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 36c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 36f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 373:	84 c0                	test   %al,%al
 375:	75 e9                	jne    360 <strcmp+0x20>
 377:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 379:	29 c8                	sub    %ecx,%eax
}
 37b:	5b                   	pop    %ebx
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    
 37e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 381:	31 c0                	xor    %eax,%eax
 383:	eb f4                	jmp    379 <strcmp+0x39>
 385:	0f b6 cb             	movzbl %bl,%ecx
 388:	eb ef                	jmp    379 <strcmp+0x39>
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <strlen>:

uint
strlen(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 396:	80 39 00             	cmpb   $0x0,(%ecx)
 399:	74 12                	je     3ad <strlen+0x1d>
 39b:	31 d2                	xor    %edx,%edx
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	83 c2 01             	add    $0x1,%edx
 3a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	75 f5                	jne    3a0 <strlen+0x10>
    ;
  return n;
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
  for(n = 0; s[n]; n++)
 3ad:	31 c0                	xor    %eax,%eax
}
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	eb 0d                	jmp    3c0 <memset>
 3b3:	90                   	nop
 3b4:	90                   	nop
 3b5:	90                   	nop
 3b6:	90                   	nop
 3b7:	90                   	nop
 3b8:	90                   	nop
 3b9:	90                   	nop
 3ba:	90                   	nop
 3bb:	90                   	nop
 3bc:	90                   	nop
 3bd:	90                   	nop
 3be:	90                   	nop
 3bf:	90                   	nop

000003c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 55 08             	mov    0x8(%ebp),%edx
 3c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 d7                	mov    %edx,%edi
 3cf:	fc                   	cld    
 3d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strchr>:

char*
strchr(const char *s, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	53                   	push   %ebx
 3e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 3ea:	0f b6 18             	movzbl (%eax),%ebx
 3ed:	84 db                	test   %bl,%bl
 3ef:	74 1d                	je     40e <strchr+0x2e>
    if(*s == c)
 3f1:	38 d3                	cmp    %dl,%bl
 3f3:	89 d1                	mov    %edx,%ecx
 3f5:	75 0d                	jne    404 <strchr+0x24>
 3f7:	eb 17                	jmp    410 <strchr+0x30>
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 400:	38 ca                	cmp    %cl,%dl
 402:	74 0c                	je     410 <strchr+0x30>
  for(; *s; s++)
 404:	83 c0 01             	add    $0x1,%eax
 407:	0f b6 10             	movzbl (%eax),%edx
 40a:	84 d2                	test   %dl,%dl
 40c:	75 f2                	jne    400 <strchr+0x20>
      return (char*)s;
  return 0;
 40e:	31 c0                	xor    %eax,%eax
}
 410:	5b                   	pop    %ebx
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    
 413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <gets>:

char*
gets(char *buf, int max)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 425:	31 f6                	xor    %esi,%esi
{
 427:	53                   	push   %ebx
 428:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 42b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 42e:	eb 31                	jmp    461 <gets+0x41>
    cc = read(0, &c, 1);
 430:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 437:	00 
 438:	89 7c 24 04          	mov    %edi,0x4(%esp)
 43c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 443:	e8 02 01 00 00       	call   54a <read>
    if(cc < 1)
 448:	85 c0                	test   %eax,%eax
 44a:	7e 1d                	jle    469 <gets+0x49>
      break;
    buf[i++] = c;
 44c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 450:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 452:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 455:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 457:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 45b:	74 0c                	je     469 <gets+0x49>
 45d:	3c 0a                	cmp    $0xa,%al
 45f:	74 08                	je     469 <gets+0x49>
  for(i=0; i+1 < max; ){
 461:	8d 5e 01             	lea    0x1(%esi),%ebx
 464:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 467:	7c c7                	jl     430 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 470:	83 c4 2c             	add    $0x2c,%esp
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
 475:	5f                   	pop    %edi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret    
 478:	90                   	nop
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <stat>:

int
stat(const char *n, struct stat *st)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	56                   	push   %esi
 484:	53                   	push   %ebx
 485:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 492:	00 
 493:	89 04 24             	mov    %eax,(%esp)
 496:	e8 d7 00 00 00       	call   572 <open>
  if(fd < 0)
 49b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 49d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 49f:	78 27                	js     4c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a4:	89 1c 24             	mov    %ebx,(%esp)
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	e8 da 00 00 00       	call   58a <fstat>
  close(fd);
 4b0:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4b3:	89 c6                	mov    %eax,%esi
  close(fd);
 4b5:	e8 a0 00 00 00       	call   55a <close>
  return r;
 4ba:	89 f0                	mov    %esi,%eax
}
 4bc:	83 c4 10             	add    $0x10,%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5e                   	pop    %esi
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
 4c3:	90                   	nop
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 4c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4cd:	eb ed                	jmp    4bc <stat+0x3c>
 4cf:	90                   	nop

000004d0 <atoi>:

int
atoi(const char *s)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4d6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4d7:	0f be 11             	movsbl (%ecx),%edx
 4da:	8d 42 d0             	lea    -0x30(%edx),%eax
 4dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 4df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 4e4:	77 17                	ja     4fd <atoi+0x2d>
 4e6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4e8:	83 c1 01             	add    $0x1,%ecx
 4eb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4ee:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4f2:	0f be 11             	movsbl (%ecx),%edx
 4f5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4f8:	80 fb 09             	cmp    $0x9,%bl
 4fb:	76 eb                	jbe    4e8 <atoi+0x18>
  return n;
}
 4fd:	5b                   	pop    %ebx
 4fe:	5d                   	pop    %ebp
 4ff:	c3                   	ret    

00000500 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 500:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 501:	31 d2                	xor    %edx,%edx
{
 503:	89 e5                	mov    %esp,%ebp
 505:	56                   	push   %esi
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	53                   	push   %ebx
 50a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 510:	85 db                	test   %ebx,%ebx
 512:	7e 12                	jle    526 <memmove+0x26>
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 518:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 51c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 51f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 522:	39 da                	cmp    %ebx,%edx
 524:	75 f2                	jne    518 <memmove+0x18>
  return vdst;
}
 526:	5b                   	pop    %ebx
 527:	5e                   	pop    %esi
 528:	5d                   	pop    %ebp
 529:	c3                   	ret    

0000052a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 52a:	b8 01 00 00 00       	mov    $0x1,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <exit>:
SYSCALL(exit)
 532:	b8 02 00 00 00       	mov    $0x2,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <wait>:
SYSCALL(wait)
 53a:	b8 03 00 00 00       	mov    $0x3,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <pipe>:
SYSCALL(pipe)
 542:	b8 04 00 00 00       	mov    $0x4,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <read>:
SYSCALL(read)
 54a:	b8 05 00 00 00       	mov    $0x5,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <write>:
SYSCALL(write)
 552:	b8 10 00 00 00       	mov    $0x10,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <close>:
SYSCALL(close)
 55a:	b8 15 00 00 00       	mov    $0x15,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <kill>:
SYSCALL(kill)
 562:	b8 06 00 00 00       	mov    $0x6,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <exec>:
SYSCALL(exec)
 56a:	b8 07 00 00 00       	mov    $0x7,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <open>:
SYSCALL(open)
 572:	b8 0f 00 00 00       	mov    $0xf,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <mknod>:
SYSCALL(mknod)
 57a:	b8 11 00 00 00       	mov    $0x11,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <unlink>:
SYSCALL(unlink)
 582:	b8 12 00 00 00       	mov    $0x12,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <fstat>:
SYSCALL(fstat)
 58a:	b8 08 00 00 00       	mov    $0x8,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <link>:
SYSCALL(link)
 592:	b8 13 00 00 00       	mov    $0x13,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <mkdir>:
SYSCALL(mkdir)
 59a:	b8 14 00 00 00       	mov    $0x14,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <chdir>:
SYSCALL(chdir)
 5a2:	b8 09 00 00 00       	mov    $0x9,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <dup>:
SYSCALL(dup)
 5aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <getpid>:
SYSCALL(getpid)
 5b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <sbrk>:
SYSCALL(sbrk)
 5ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <sleep>:
SYSCALL(sleep)
 5c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <uptime>:
SYSCALL(uptime)
 5ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <info>:
SYSCALL(info)
 5d2:	b8 16 00 00 00       	mov    $0x16,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <settick>:
SYSCALL(settick)
 5da:	b8 17 00 00 00       	mov    $0x17,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <tickprintf>:
SYSCALL(tickprintf)
 5e2:	b8 18 00 00 00       	mov    $0x18,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <clone>:
SYSCALL(clone)
 5ea:	b8 19 00 00 00       	mov    $0x19,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    
 5f2:	66 90                	xchg   %ax,%ax
 5f4:	66 90                	xchg   %ax,%ax
 5f6:	66 90                	xchg   %ax,%ax
 5f8:	66 90                	xchg   %ax,%ax
 5fa:	66 90                	xchg   %ax,%ax
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	89 c6                	mov    %eax,%esi
 607:	53                   	push   %ebx
 608:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 60e:	85 db                	test   %ebx,%ebx
 610:	74 09                	je     61b <printint+0x1b>
 612:	89 d0                	mov    %edx,%eax
 614:	c1 e8 1f             	shr    $0x1f,%eax
 617:	84 c0                	test   %al,%al
 619:	75 75                	jne    690 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 61b:	89 d0                	mov    %edx,%eax
  neg = 0;
 61d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 624:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 627:	31 ff                	xor    %edi,%edi
 629:	89 ce                	mov    %ecx,%esi
 62b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 62e:	eb 02                	jmp    632 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 630:	89 cf                	mov    %ecx,%edi
 632:	31 d2                	xor    %edx,%edx
 634:	f7 f6                	div    %esi
 636:	8d 4f 01             	lea    0x1(%edi),%ecx
 639:	0f b6 92 ed 0a 00 00 	movzbl 0xaed(%edx),%edx
  }while((x /= base) != 0);
 640:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 642:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 645:	75 e9                	jne    630 <printint+0x30>
  if(neg)
 647:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 64a:	89 c8                	mov    %ecx,%eax
 64c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 64f:	85 d2                	test   %edx,%edx
 651:	74 08                	je     65b <printint+0x5b>
    buf[i++] = '-';
 653:	8d 4f 02             	lea    0x2(%edi),%ecx
 656:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 65b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 65e:	66 90                	xchg   %ax,%ax
 660:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 665:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 668:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 66f:	00 
 670:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 674:	89 34 24             	mov    %esi,(%esp)
 677:	88 45 d7             	mov    %al,-0x29(%ebp)
 67a:	e8 d3 fe ff ff       	call   552 <write>
  while(--i >= 0)
 67f:	83 ff ff             	cmp    $0xffffffff,%edi
 682:	75 dc                	jne    660 <printint+0x60>
    putc(fd, buf[i]);
}
 684:	83 c4 4c             	add    $0x4c,%esp
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 690:	89 d0                	mov    %edx,%eax
 692:	f7 d8                	neg    %eax
    neg = 1;
 694:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 69b:	eb 87                	jmp    624 <printint+0x24>
 69d:	8d 76 00             	lea    0x0(%esi),%esi

000006a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6a4:	31 ff                	xor    %edi,%edi
{
 6a6:	56                   	push   %esi
 6a7:	53                   	push   %ebx
 6a8:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 6ae:	8d 45 10             	lea    0x10(%ebp),%eax
{
 6b1:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 6b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 6b7:	0f b6 13             	movzbl (%ebx),%edx
 6ba:	83 c3 01             	add    $0x1,%ebx
 6bd:	84 d2                	test   %dl,%dl
 6bf:	75 39                	jne    6fa <printf+0x5a>
 6c1:	e9 c2 00 00 00       	jmp    788 <printf+0xe8>
 6c6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6c8:	83 fa 25             	cmp    $0x25,%edx
 6cb:	0f 84 bf 00 00 00    	je     790 <printf+0xf0>
  write(fd, &c, 1);
 6d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6db:	00 
 6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e0:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 6e3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 6e6:	e8 67 fe ff ff       	call   552 <write>
 6eb:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 6ee:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 6f2:	84 d2                	test   %dl,%dl
 6f4:	0f 84 8e 00 00 00    	je     788 <printf+0xe8>
    if(state == 0){
 6fa:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 6fc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 6ff:	74 c7                	je     6c8 <printf+0x28>
      }
    } else if(state == '%'){
 701:	83 ff 25             	cmp    $0x25,%edi
 704:	75 e5                	jne    6eb <printf+0x4b>
      if(c == 'd'){
 706:	83 fa 64             	cmp    $0x64,%edx
 709:	0f 84 31 01 00 00    	je     840 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 70f:	25 f7 00 00 00       	and    $0xf7,%eax
 714:	83 f8 70             	cmp    $0x70,%eax
 717:	0f 84 83 00 00 00    	je     7a0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 71d:	83 fa 73             	cmp    $0x73,%edx
 720:	0f 84 a2 00 00 00    	je     7c8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 726:	83 fa 63             	cmp    $0x63,%edx
 729:	0f 84 35 01 00 00    	je     864 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 72f:	83 fa 25             	cmp    $0x25,%edx
 732:	0f 84 e0 00 00 00    	je     818 <printf+0x178>
  write(fd, &c, 1);
 738:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 73b:	83 c3 01             	add    $0x1,%ebx
 73e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 745:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 746:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 748:	89 44 24 04          	mov    %eax,0x4(%esp)
 74c:	89 34 24             	mov    %esi,(%esp)
 74f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 752:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 756:	e8 f7 fd ff ff       	call   552 <write>
        putc(fd, c);
 75b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 75e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 761:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 768:	00 
 769:	89 44 24 04          	mov    %eax,0x4(%esp)
 76d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 770:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 773:	e8 da fd ff ff       	call   552 <write>
  for(i = 0; fmt[i]; i++){
 778:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 77c:	84 d2                	test   %dl,%dl
 77e:	0f 85 76 ff ff ff    	jne    6fa <printf+0x5a>
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 788:	83 c4 3c             	add    $0x3c,%esp
 78b:	5b                   	pop    %ebx
 78c:	5e                   	pop    %esi
 78d:	5f                   	pop    %edi
 78e:	5d                   	pop    %ebp
 78f:	c3                   	ret    
        state = '%';
 790:	bf 25 00 00 00       	mov    $0x25,%edi
 795:	e9 51 ff ff ff       	jmp    6eb <printf+0x4b>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7a3:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 7a8:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 7aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7b1:	8b 10                	mov    (%eax),%edx
 7b3:	89 f0                	mov    %esi,%eax
 7b5:	e8 46 fe ff ff       	call   600 <printint>
        ap++;
 7ba:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7be:	e9 28 ff ff ff       	jmp    6eb <printf+0x4b>
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 7cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 7cf:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 7d1:	b8 e6 0a 00 00       	mov    $0xae6,%eax
 7d6:	85 ff                	test   %edi,%edi
 7d8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 7db:	0f b6 07             	movzbl (%edi),%eax
 7de:	84 c0                	test   %al,%al
 7e0:	74 2a                	je     80c <printf+0x16c>
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7e8:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 7eb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 7ee:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 7f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7f8:	00 
 7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fd:	89 34 24             	mov    %esi,(%esp)
 800:	e8 4d fd ff ff       	call   552 <write>
        while(*s != 0){
 805:	0f b6 07             	movzbl (%edi),%eax
 808:	84 c0                	test   %al,%al
 80a:	75 dc                	jne    7e8 <printf+0x148>
      state = 0;
 80c:	31 ff                	xor    %edi,%edi
 80e:	e9 d8 fe ff ff       	jmp    6eb <printf+0x4b>
 813:	90                   	nop
 814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 818:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 81b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 81d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 824:	00 
 825:	89 44 24 04          	mov    %eax,0x4(%esp)
 829:	89 34 24             	mov    %esi,(%esp)
 82c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 830:	e8 1d fd ff ff       	call   552 <write>
 835:	e9 b1 fe ff ff       	jmp    6eb <printf+0x4b>
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 843:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 848:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 84b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 852:	8b 10                	mov    (%eax),%edx
 854:	89 f0                	mov    %esi,%eax
 856:	e8 a5 fd ff ff       	call   600 <printint>
        ap++;
 85b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 85f:	e9 87 fe ff ff       	jmp    6eb <printf+0x4b>
        putc(fd, *ap);
 864:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 867:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 869:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 86b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 872:	00 
 873:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 876:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 879:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 87c:	89 44 24 04          	mov    %eax,0x4(%esp)
 880:	e8 cd fc ff ff       	call   552 <write>
        ap++;
 885:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 889:	e9 5d fe ff ff       	jmp    6eb <printf+0x4b>
 88e:	66 90                	xchg   %ax,%ax

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	a1 e0 0e 00 00       	mov    0xee0,%eax
{
 896:	89 e5                	mov    %esp,%ebp
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	53                   	push   %ebx
 89b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 8a0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a3:	39 d0                	cmp    %edx,%eax
 8a5:	72 11                	jb     8b8 <free+0x28>
 8a7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	39 c8                	cmp    %ecx,%eax
 8aa:	72 04                	jb     8b0 <free+0x20>
 8ac:	39 ca                	cmp    %ecx,%edx
 8ae:	72 10                	jb     8c0 <free+0x30>
 8b0:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	73 f0                	jae    8a8 <free+0x18>
 8b8:	39 ca                	cmp    %ecx,%edx
 8ba:	72 04                	jb     8c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8bc:	39 c8                	cmp    %ecx,%eax
 8be:	72 f0                	jb     8b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8c3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 8c6:	39 cf                	cmp    %ecx,%edi
 8c8:	74 1e                	je     8e8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8ca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8cd:	8b 48 04             	mov    0x4(%eax),%ecx
 8d0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 8d3:	39 f2                	cmp    %esi,%edx
 8d5:	74 28                	je     8ff <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d9:	a3 e0 0e 00 00       	mov    %eax,0xee0
}
 8de:	5b                   	pop    %ebx
 8df:	5e                   	pop    %esi
 8e0:	5f                   	pop    %edi
 8e1:	5d                   	pop    %ebp
 8e2:	c3                   	ret    
 8e3:	90                   	nop
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 8e8:	03 71 04             	add    0x4(%ecx),%esi
 8eb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ee:	8b 08                	mov    (%eax),%ecx
 8f0:	8b 09                	mov    (%ecx),%ecx
 8f2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8f5:	8b 48 04             	mov    0x4(%eax),%ecx
 8f8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 8fb:	39 f2                	cmp    %esi,%edx
 8fd:	75 d8                	jne    8d7 <free+0x47>
    p->s.size += bp->s.size;
 8ff:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 902:	a3 e0 0e 00 00       	mov    %eax,0xee0
    p->s.size += bp->s.size;
 907:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 90a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 90d:	89 10                	mov    %edx,(%eax)
}
 90f:	5b                   	pop    %ebx
 910:	5e                   	pop    %esi
 911:	5f                   	pop    %edi
 912:	5d                   	pop    %ebp
 913:	c3                   	ret    
 914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 91a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	57                   	push   %edi
 924:	56                   	push   %esi
 925:	53                   	push   %ebx
 926:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 92c:	8b 1d e0 0e 00 00    	mov    0xee0,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 932:	8d 48 07             	lea    0x7(%eax),%ecx
 935:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 938:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 93d:	0f 84 9b 00 00 00    	je     9de <malloc+0xbe>
 943:	8b 13                	mov    (%ebx),%edx
 945:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 948:	39 fe                	cmp    %edi,%esi
 94a:	76 64                	jbe    9b0 <malloc+0x90>
 94c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 953:	bb 00 80 00 00       	mov    $0x8000,%ebx
 958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 95b:	eb 0e                	jmp    96b <malloc+0x4b>
 95d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 962:	8b 78 04             	mov    0x4(%eax),%edi
 965:	39 fe                	cmp    %edi,%esi
 967:	76 4f                	jbe    9b8 <malloc+0x98>
 969:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96b:	3b 15 e0 0e 00 00    	cmp    0xee0,%edx
 971:	75 ed                	jne    960 <malloc+0x40>
  if(nu < 4096)
 973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 976:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 97c:	bf 00 10 00 00       	mov    $0x1000,%edi
 981:	0f 43 fe             	cmovae %esi,%edi
 984:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 987:	89 04 24             	mov    %eax,(%esp)
 98a:	e8 2b fc ff ff       	call   5ba <sbrk>
  if(p == (char*)-1)
 98f:	83 f8 ff             	cmp    $0xffffffff,%eax
 992:	74 18                	je     9ac <malloc+0x8c>
  hp->s.size = nu;
 994:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 997:	83 c0 08             	add    $0x8,%eax
 99a:	89 04 24             	mov    %eax,(%esp)
 99d:	e8 ee fe ff ff       	call   890 <free>
  return freep;
 9a2:	8b 15 e0 0e 00 00    	mov    0xee0,%edx
      if((p = morecore(nunits)) == 0)
 9a8:	85 d2                	test   %edx,%edx
 9aa:	75 b4                	jne    960 <malloc+0x40>
        return 0;
 9ac:	31 c0                	xor    %eax,%eax
 9ae:	eb 20                	jmp    9d0 <malloc+0xb0>
    if(p->s.size >= nunits){
 9b0:	89 d0                	mov    %edx,%eax
 9b2:	89 da                	mov    %ebx,%edx
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9b8:	39 fe                	cmp    %edi,%esi
 9ba:	74 1c                	je     9d8 <malloc+0xb8>
        p->s.size -= nunits;
 9bc:	29 f7                	sub    %esi,%edi
 9be:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 9c1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 9c4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 9c7:	89 15 e0 0e 00 00    	mov    %edx,0xee0
      return (void*)(p + 1);
 9cd:	83 c0 08             	add    $0x8,%eax
  }
}
 9d0:	83 c4 1c             	add    $0x1c,%esp
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 9d8:	8b 08                	mov    (%eax),%ecx
 9da:	89 0a                	mov    %ecx,(%edx)
 9dc:	eb e9                	jmp    9c7 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 9de:	c7 05 e0 0e 00 00 e4 	movl   $0xee4,0xee0
 9e5:	0e 00 00 
    base.s.size = 0;
 9e8:	ba e4 0e 00 00       	mov    $0xee4,%edx
    base.s.ptr = freep = prevp = &base;
 9ed:	c7 05 e4 0e 00 00 e4 	movl   $0xee4,0xee4
 9f4:	0e 00 00 
    base.s.size = 0;
 9f7:	c7 05 e8 0e 00 00 00 	movl   $0x0,0xee8
 9fe:	00 00 00 
 a01:	e9 46 ff ff ff       	jmp    94c <malloc+0x2c>
 a06:	66 90                	xchg   %ax,%ax
 a08:	66 90                	xchg   %ax,%ax
 a0a:	66 90                	xchg   %ax,%ax
 a0c:	66 90                	xchg   %ax,%ax
 a0e:	66 90                	xchg   %ax,%ax

00000a10 <thread_create>:
#include "mmu.h"
#include "spinlock.h"

struct lock_t lock;

void thread_create(void *(*start_routine)(void*), void *arg){
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	53                   	push   %ebx
 a14:	83 ec 14             	sub    $0x14,%esp

  void *stack = malloc(PGSIZE*2);//allocate a block of memory for stack of thread
 a17:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
 a1e:	e8 fd fe ff ff       	call   920 <malloc>
 a23:	89 c3                	mov    %eax,%ebx
  if((uint)stack % PGSIZE)
 a25:	25 ff 0f 00 00       	and    $0xfff,%eax
 a2a:	74 08                	je     a34 <thread_create+0x24>
      stack = stack + (PGSIZE - (uint)stack % PGSIZE);
 a2c:	29 c3                	sub    %eax,%ebx
 a2e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  int id;
  id = clone(stack, PGSIZE*2);
 a34:	c7 44 24 04 00 20 00 	movl   $0x2000,0x4(%esp)
 a3b:	00 
 a3c:	89 1c 24             	mov    %ebx,(%esp)
 a3f:	e8 a6 fb ff ff       	call   5ea <clone>
  // id == 0 means this process is a thread
  if(id == 0){
 a44:	85 c0                	test   %eax,%eax
 a46:	74 06                	je     a4e <thread_create+0x3e>
    (*start_routine)(arg);
    free(stack);
    exit();
  }

}
 a48:	83 c4 14             	add    $0x14,%esp
 a4b:	5b                   	pop    %ebx
 a4c:	5d                   	pop    %ebp
 a4d:	c3                   	ret    
    (*start_routine)(arg);
 a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
 a51:	89 04 24             	mov    %eax,(%esp)
 a54:	ff 55 08             	call   *0x8(%ebp)
    free(stack);
 a57:	89 1c 24             	mov    %ebx,(%esp)
 a5a:	e8 31 fe ff ff       	call   890 <free>
    exit();
 a5f:	e8 ce fa ff ff       	call   532 <exit>
 a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a70 <lock_init>:

// initiate a lock
void lock_init(struct lock_t *lk){
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
    lk->locked = 0;
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
 a76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
 a7c:	5d                   	pop    %ebp
 a7d:	c3                   	ret    
 a7e:	66 90                	xchg   %ax,%ax

00000a80 <lock_acquire>:

void lock_acquire(struct lock_t *lk){
 a80:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
 a81:	b9 01 00 00 00       	mov    $0x1,%ecx
 a86:	89 e5                	mov    %esp,%ebp
 a88:	8b 55 08             	mov    0x8(%ebp),%edx
 a8b:	90                   	nop
 a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a90:	89 c8                	mov    %ecx,%eax
 a92:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0);//atmoic language
 a95:	85 c0                	test   %eax,%eax
 a97:	75 f7                	jne    a90 <lock_acquire+0x10>
}
 a99:	5d                   	pop    %ebp
 a9a:	c3                   	ret    
 a9b:	90                   	nop
 a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000aa0 <lock_release>:

void lock_release(struct lock_t *lk){
 aa0:	55                   	push   %ebp
 aa1:	31 c0                	xor    %eax,%eax
 aa3:	89 e5                	mov    %esp,%ebp
 aa5:	8b 55 08             	mov    0x8(%ebp),%edx
 aa8:	f0 87 02             	lock xchg %eax,(%edx)
  xchg(&lk->locked, 0);
 aab:	5d                   	pop    %ebp
 aac:	c3                   	ret    
