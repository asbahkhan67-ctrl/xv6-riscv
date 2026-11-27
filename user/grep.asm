
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
}

// matchstar: search for c*re at beginning of text
int
matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do { // a * matches zero or more instances
    if (matchhere(re, text))
      return 1;
  } while (*text != '\0' && (*text++ == c || c == '.'));
  16:	02e00a13          	li	s4,46
    if (matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	02c000ef          	jal	4a <matchhere>
  22:	e919                	bnez	a0,38 <matchstar+0x38>
  } while (*text != '\0' && (*text++ == c || c == '.'));
  24:	0004c783          	lbu	a5,0(s1)
  28:	cb89                	beqz	a5,3a <matchstar+0x3a>
  2a:	0485                	addi	s1,s1,1
  2c:	2781                	sext.w	a5,a5
  2e:	ff2786e3          	beq	a5,s2,1a <matchstar+0x1a>
  32:	ff4904e3          	beq	s2,s4,1a <matchstar+0x1a>
  36:	a011                	j	3a <matchstar+0x3a>
      return 1;
  38:	4505                	li	a0,1
  return 0;
}
  3a:	70a2                	ld	ra,40(sp)
  3c:	7402                	ld	s0,32(sp)
  3e:	64e2                	ld	s1,24(sp)
  40:	6942                	ld	s2,16(sp)
  42:	69a2                	ld	s3,8(sp)
  44:	6a02                	ld	s4,0(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret

000000000000004a <matchhere>:
  if (re[0] == '\0')
  4a:	00054703          	lbu	a4,0(a0)
  4e:	c73d                	beqz	a4,bc <matchhere+0x72>
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  58:	87aa                	mv	a5,a0
  if (re[1] == '*')
  5a:	00154683          	lbu	a3,1(a0)
  5e:	02a00613          	li	a2,42
  62:	02c68563          	beq	a3,a2,8c <matchhere+0x42>
  if (re[0] == '$' && re[1] == '\0')
  66:	02400613          	li	a2,36
  6a:	02c70863          	beq	a4,a2,9a <matchhere+0x50>
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  6e:	0005c683          	lbu	a3,0(a1)
  return 0;
  72:	4501                	li	a0,0
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  74:	ca81                	beqz	a3,84 <matchhere+0x3a>
  76:	02e00613          	li	a2,46
  7a:	02c70b63          	beq	a4,a2,b0 <matchhere+0x66>
  return 0;
  7e:	4501                	li	a0,0
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  80:	02d70863          	beq	a4,a3,b0 <matchhere+0x66>
}
  84:	60a2                	ld	ra,8(sp)
  86:	6402                	ld	s0,0(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret
    return matchstar(re[0], re + 2, text);
  8c:	862e                	mv	a2,a1
  8e:	00250593          	addi	a1,a0,2
  92:	853a                	mv	a0,a4
  94:	f6dff0ef          	jal	0 <matchstar>
  98:	b7f5                	j	84 <matchhere+0x3a>
  if (re[0] == '$' && re[1] == '\0')
  9a:	c691                	beqz	a3,a6 <matchhere+0x5c>
  if (*text != '\0' && (re[0] == '.' || re[0] == *text))
  9c:	0005c683          	lbu	a3,0(a1)
  a0:	fef9                	bnez	a3,7e <matchhere+0x34>
  return 0;
  a2:	4501                	li	a0,0
  a4:	b7c5                	j	84 <matchhere+0x3a>
    return *text == '\0';
  a6:	0005c503          	lbu	a0,0(a1)
  aa:	00153513          	seqz	a0,a0
  ae:	bfd9                	j	84 <matchhere+0x3a>
    return matchhere(re + 1, text + 1);
  b0:	0585                	addi	a1,a1,1
  b2:	00178513          	addi	a0,a5,1
  b6:	f95ff0ef          	jal	4a <matchhere>
  ba:	b7e9                	j	84 <matchhere+0x3a>
    return 1;
  bc:	4505                	li	a0,1
}
  be:	8082                	ret

00000000000000c0 <match>:
{
  c0:	1101                	addi	sp,sp,-32
  c2:	ec06                	sd	ra,24(sp)
  c4:	e822                	sd	s0,16(sp)
  c6:	e426                	sd	s1,8(sp)
  c8:	e04a                	sd	s2,0(sp)
  ca:	1000                	addi	s0,sp,32
  cc:	892a                	mv	s2,a0
  ce:	84ae                	mv	s1,a1
  if (re[0] == '^')
  d0:	00054703          	lbu	a4,0(a0)
  d4:	05e00793          	li	a5,94
  d8:	00f70c63          	beq	a4,a5,f0 <match+0x30>
    if (matchhere(re, text))
  dc:	85a6                	mv	a1,s1
  de:	854a                	mv	a0,s2
  e0:	f6bff0ef          	jal	4a <matchhere>
  e4:	e911                	bnez	a0,f8 <match+0x38>
  } while (*text++ != '\0');
  e6:	0485                	addi	s1,s1,1
  e8:	fff4c783          	lbu	a5,-1(s1)
  ec:	fbe5                	bnez	a5,dc <match+0x1c>
  ee:	a031                	j	fa <match+0x3a>
    return matchhere(re + 1, text);
  f0:	0505                	addi	a0,a0,1
  f2:	f59ff0ef          	jal	4a <matchhere>
  f6:	a011                	j	fa <match+0x3a>
      return 1;
  f8:	4505                	li	a0,1
}
  fa:	60e2                	ld	ra,24(sp)
  fc:	6442                	ld	s0,16(sp)
  fe:	64a2                	ld	s1,8(sp)
 100:	6902                	ld	s2,0(sp)
 102:	6105                	addi	sp,sp,32
 104:	8082                	ret

0000000000000106 <grep>:
{
 106:	715d                	addi	sp,sp,-80
 108:	e486                	sd	ra,72(sp)
 10a:	e0a2                	sd	s0,64(sp)
 10c:	fc26                	sd	s1,56(sp)
 10e:	f84a                	sd	s2,48(sp)
 110:	f44e                	sd	s3,40(sp)
 112:	f052                	sd	s4,32(sp)
 114:	ec56                	sd	s5,24(sp)
 116:	e85a                	sd	s6,16(sp)
 118:	e45e                	sd	s7,8(sp)
 11a:	e062                	sd	s8,0(sp)
 11c:	0880                	addi	s0,sp,80
 11e:	89aa                	mv	s3,a0
 120:	8b2e                	mv	s6,a1
  m = 0;
 122:	4a01                	li	s4,0
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 124:	3ff00b93          	li	s7,1023
 128:	00001a97          	auipc	s5,0x1
 12c:	ee8a8a93          	addi	s5,s5,-280 # 1010 <buf>
 130:	a835                	j	16c <grep+0x66>
      p = q + 1;
 132:	00148913          	addi	s2,s1,1
    while ((q = strchr(p, '\n')) != 0) {
 136:	45a9                	li	a1,10
 138:	854a                	mv	a0,s2
 13a:	1c4000ef          	jal	2fe <strchr>
 13e:	84aa                	mv	s1,a0
 140:	c505                	beqz	a0,168 <grep+0x62>
      *q = 0;
 142:	00048023          	sb	zero,0(s1)
      if (match(pattern, p)) {
 146:	85ca                	mv	a1,s2
 148:	854e                	mv	a0,s3
 14a:	f77ff0ef          	jal	c0 <match>
 14e:	d175                	beqz	a0,132 <grep+0x2c>
        *q = '\n';
 150:	47a9                	li	a5,10
 152:	00f48023          	sb	a5,0(s1)
        write(1, p, q + 1 - p);
 156:	00148613          	addi	a2,s1,1
 15a:	4126063b          	subw	a2,a2,s2
 15e:	85ca                	mv	a1,s2
 160:	4505                	li	a0,1
 162:	3ac000ef          	jal	50e <write>
 166:	b7f1                	j	132 <grep+0x2c>
    if (m > 0) {
 168:	03404563          	bgtz	s4,192 <grep+0x8c>
  while ((n = read(fd, buf + m, sizeof(buf) - m - 1)) > 0) {
 16c:	414b863b          	subw	a2,s7,s4
 170:	014a85b3          	add	a1,s5,s4
 174:	855a                	mv	a0,s6
 176:	390000ef          	jal	506 <read>
 17a:	02a05963          	blez	a0,1ac <grep+0xa6>
    m += n;
 17e:	00aa0c3b          	addw	s8,s4,a0
 182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 186:	014a87b3          	add	a5,s5,s4
 18a:	00078023          	sb	zero,0(a5)
    p = buf;
 18e:	8956                	mv	s2,s5
    while ((q = strchr(p, '\n')) != 0) {
 190:	b75d                	j	136 <grep+0x30>
      m -= p - buf;
 192:	00001517          	auipc	a0,0x1
 196:	e7e50513          	addi	a0,a0,-386 # 1010 <buf>
 19a:	40a90a33          	sub	s4,s2,a0
 19e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1a2:	8652                	mv	a2,s4
 1a4:	85ca                	mv	a1,s2
 1a6:	26e000ef          	jal	414 <memmove>
 1aa:	b7c9                	j	16c <grep+0x66>
}
 1ac:	60a6                	ld	ra,72(sp)
 1ae:	6406                	ld	s0,64(sp)
 1b0:	74e2                	ld	s1,56(sp)
 1b2:	7942                	ld	s2,48(sp)
 1b4:	79a2                	ld	s3,40(sp)
 1b6:	7a02                	ld	s4,32(sp)
 1b8:	6ae2                	ld	s5,24(sp)
 1ba:	6b42                	ld	s6,16(sp)
 1bc:	6ba2                	ld	s7,8(sp)
 1be:	6c02                	ld	s8,0(sp)
 1c0:	6161                	addi	sp,sp,80
 1c2:	8082                	ret

00000000000001c4 <main>:
{
 1c4:	7179                	addi	sp,sp,-48
 1c6:	f406                	sd	ra,40(sp)
 1c8:	f022                	sd	s0,32(sp)
 1ca:	ec26                	sd	s1,24(sp)
 1cc:	e84a                	sd	s2,16(sp)
 1ce:	e44e                	sd	s3,8(sp)
 1d0:	e052                	sd	s4,0(sp)
 1d2:	1800                	addi	s0,sp,48
  if (argc <= 1) {
 1d4:	4785                	li	a5,1
 1d6:	04a7d663          	bge	a5,a0,222 <main+0x5e>
  pattern = argv[1];
 1da:	0085ba03          	ld	s4,8(a1)
  if (argc <= 2) {
 1de:	4789                	li	a5,2
 1e0:	04a7db63          	bge	a5,a0,236 <main+0x72>
 1e4:	01058913          	addi	s2,a1,16
 1e8:	ffd5099b          	addiw	s3,a0,-3
 1ec:	02099793          	slli	a5,s3,0x20
 1f0:	01d7d993          	srli	s3,a5,0x1d
 1f4:	05e1                	addi	a1,a1,24
 1f6:	99ae                	add	s3,s3,a1
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 1f8:	4581                	li	a1,0
 1fa:	00093503          	ld	a0,0(s2)
 1fe:	330000ef          	jal	52e <open>
 202:	84aa                	mv	s1,a0
 204:	04054063          	bltz	a0,244 <main+0x80>
    grep(pattern, fd);
 208:	85aa                	mv	a1,a0
 20a:	8552                	mv	a0,s4
 20c:	efbff0ef          	jal	106 <grep>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	304000ef          	jal	516 <close>
  for (i = 2; i < argc; i++) {
 216:	0921                	addi	s2,s2,8
 218:	ff3910e3          	bne	s2,s3,1f8 <main+0x34>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	2d0000ef          	jal	4ee <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 222:	00001597          	auipc	a1,0x1
<<<<<<< HEAD
 226:	94e58593          	addi	a1,a1,-1714 # b70 <malloc+0x106>
 22a:	4509                	li	a0,2
 22c:	760000ef          	jal	98c <fprintf>
=======
 226:	95e58593          	addi	a1,a1,-1698 # b80 <malloc+0xf8>
 22a:	4509                	li	a0,2
 22c:	77e000ef          	jal	9aa <fprintf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
 230:	4505                	li	a0,1
 232:	2bc000ef          	jal	4ee <exit>
    grep(pattern, 0);
 236:	4581                	li	a1,0
 238:	8552                	mv	a0,s4
 23a:	ecdff0ef          	jal	106 <grep>
    exit(0);
 23e:	4501                	li	a0,0
 240:	2ae000ef          	jal	4ee <exit>
      printf("grep: cannot open %s\n", argv[i]);
 244:	00093583          	ld	a1,0(s2)
 248:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 24c:	94850513          	addi	a0,a0,-1720 # b90 <malloc+0x126>
 250:	766000ef          	jal	9b6 <printf>
=======
 24c:	95850513          	addi	a0,a0,-1704 # ba0 <malloc+0x118>
 250:	784000ef          	jal	9d4 <printf>
>>>>>>> e18456e (Updated xv6-riscv)
      exit(1);
 254:	4505                	li	a0,1
 256:	298000ef          	jal	4ee <exit>

000000000000025a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 262:	f63ff0ef          	jal	1c4 <main>
  exit(r);
 266:	288000ef          	jal	4ee <exit>

000000000000026a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0x8>
    ;
  return os;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 28c:	00054783          	lbu	a5,0(a0)
 290:	cb91                	beqz	a5,2a4 <strcmp+0x1e>
 292:	0005c703          	lbu	a4,0(a1)
 296:	00f71763          	bne	a4,a5,2a4 <strcmp+0x1e>
    p++, q++;
 29a:	0505                	addi	a0,a0,1
 29c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 29e:	00054783          	lbu	a5,0(a0)
 2a2:	fbe5                	bnez	a5,292 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2a4:	0005c503          	lbu	a0,0(a1)
}
 2a8:	40a7853b          	subw	a0,a5,a0
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <strlen>:

uint
strlen(const char *s)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e422                	sd	s0,8(sp)
 2b6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	cf91                	beqz	a5,2d8 <strlen+0x26>
 2be:	0505                	addi	a0,a0,1
 2c0:	87aa                	mv	a5,a0
 2c2:	86be                	mv	a3,a5
 2c4:	0785                	addi	a5,a5,1
 2c6:	fff7c703          	lbu	a4,-1(a5)
 2ca:	ff65                	bnez	a4,2c2 <strlen+0x10>
 2cc:	40a6853b          	subw	a0,a3,a0
 2d0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  for (n = 0; s[n]; n++)
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <strlen+0x20>

00000000000002dc <memset>:

void *
memset(void *dst, int c, uint n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2e2:	ca19                	beqz	a2,2f8 <memset+0x1c>
 2e4:	87aa                	mv	a5,a0
 2e6:	1602                	slli	a2,a2,0x20
 2e8:	9201                	srli	a2,a2,0x20
 2ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ee:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2f2:	0785                	addi	a5,a5,1
 2f4:	fee79de3          	bne	a5,a4,2ee <memset+0x12>
  }
  return dst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <strchr>:

char *
strchr(const char *s, char c)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  for (; *s; s++)
 304:	00054783          	lbu	a5,0(a0)
 308:	cb99                	beqz	a5,31e <strchr+0x20>
    if (*s == c)
 30a:	00f58763          	beq	a1,a5,318 <strchr+0x1a>
  for (; *s; s++)
 30e:	0505                	addi	a0,a0,1
 310:	00054783          	lbu	a5,0(a0)
 314:	fbfd                	bnez	a5,30a <strchr+0xc>
      return (char *)s;
  return 0;
 316:	4501                	li	a0,0
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
  return 0;
 31e:	4501                	li	a0,0
 320:	bfe5                	j	318 <strchr+0x1a>

0000000000000322 <gets>:

char *
gets(char *buf, int max)
{
 322:	711d                	addi	sp,sp,-96
 324:	ec86                	sd	ra,88(sp)
 326:	e8a2                	sd	s0,80(sp)
 328:	e4a6                	sd	s1,72(sp)
 32a:	e0ca                	sd	s2,64(sp)
 32c:	fc4e                	sd	s3,56(sp)
 32e:	f852                	sd	s4,48(sp)
 330:	f456                	sd	s5,40(sp)
 332:	f05a                	sd	s6,32(sp)
 334:	ec5e                	sd	s7,24(sp)
 336:	1080                	addi	s0,sp,96
 338:	8baa                	mv	s7,a0
 33a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 33c:	892a                	mv	s2,a0
 33e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 340:	4aa9                	li	s5,10
 342:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 344:	89a6                	mv	s3,s1
 346:	2485                	addiw	s1,s1,1
 348:	0344d663          	bge	s1,s4,374 <gets+0x52>
    cc = read(0, &c, 1);
 34c:	4605                	li	a2,1
 34e:	faf40593          	addi	a1,s0,-81
 352:	4501                	li	a0,0
 354:	1b2000ef          	jal	506 <read>
    if (cc < 1)
 358:	00a05e63          	blez	a0,374 <gets+0x52>
    buf[i++] = c;
 35c:	faf44783          	lbu	a5,-81(s0)
 360:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 364:	01578763          	beq	a5,s5,372 <gets+0x50>
 368:	0905                	addi	s2,s2,1
 36a:	fd679de3          	bne	a5,s6,344 <gets+0x22>
    buf[i++] = c;
 36e:	89a6                	mv	s3,s1
 370:	a011                	j	374 <gets+0x52>
 372:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 374:	99de                	add	s3,s3,s7
 376:	00098023          	sb	zero,0(s3)
  return buf;
}
 37a:	855e                	mv	a0,s7
 37c:	60e6                	ld	ra,88(sp)
 37e:	6446                	ld	s0,80(sp)
 380:	64a6                	ld	s1,72(sp)
 382:	6906                	ld	s2,64(sp)
 384:	79e2                	ld	s3,56(sp)
 386:	7a42                	ld	s4,48(sp)
 388:	7aa2                	ld	s5,40(sp)
 38a:	7b02                	ld	s6,32(sp)
 38c:	6be2                	ld	s7,24(sp)
 38e:	6125                	addi	sp,sp,96
 390:	8082                	ret

0000000000000392 <stat>:

int
stat(const char *n, struct stat *st)
{
 392:	1101                	addi	sp,sp,-32
 394:	ec06                	sd	ra,24(sp)
 396:	e822                	sd	s0,16(sp)
 398:	e04a                	sd	s2,0(sp)
 39a:	1000                	addi	s0,sp,32
 39c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39e:	4581                	li	a1,0
 3a0:	18e000ef          	jal	52e <open>
  if (fd < 0)
 3a4:	02054263          	bltz	a0,3c8 <stat+0x36>
 3a8:	e426                	sd	s1,8(sp)
 3aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ac:	85ca                	mv	a1,s2
 3ae:	198000ef          	jal	546 <fstat>
 3b2:	892a                	mv	s2,a0
  close(fd);
 3b4:	8526                	mv	a0,s1
 3b6:	160000ef          	jal	516 <close>
  return r;
 3ba:	64a2                	ld	s1,8(sp)
}
 3bc:	854a                	mv	a0,s2
 3be:	60e2                	ld	ra,24(sp)
 3c0:	6442                	ld	s0,16(sp)
 3c2:	6902                	ld	s2,0(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret
    return -1;
 3c8:	597d                	li	s2,-1
 3ca:	bfcd                	j	3bc <stat+0x2a>

00000000000003cc <atoi>:

int
atoi(const char *s)
{
 3cc:	1141                	addi	sp,sp,-16
 3ce:	e422                	sd	s0,8(sp)
 3d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3d2:	00054683          	lbu	a3,0(a0)
 3d6:	fd06879b          	addiw	a5,a3,-48
 3da:	0ff7f793          	zext.b	a5,a5
 3de:	4625                	li	a2,9
 3e0:	02f66863          	bltu	a2,a5,410 <atoi+0x44>
 3e4:	872a                	mv	a4,a0
  n = 0;
 3e6:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 3e8:	0705                	addi	a4,a4,1
 3ea:	0025179b          	slliw	a5,a0,0x2
 3ee:	9fa9                	addw	a5,a5,a0
 3f0:	0017979b          	slliw	a5,a5,0x1
 3f4:	9fb5                	addw	a5,a5,a3
 3f6:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 3fa:	00074683          	lbu	a3,0(a4)
 3fe:	fd06879b          	addiw	a5,a3,-48
 402:	0ff7f793          	zext.b	a5,a5
 406:	fef671e3          	bgeu	a2,a5,3e8 <atoi+0x1c>
  return n;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
  n = 0;
 410:	4501                	li	a0,0
 412:	bfe5                	j	40a <atoi+0x3e>

0000000000000414 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e422                	sd	s0,8(sp)
 418:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 41a:	02b57463          	bgeu	a0,a1,442 <memmove+0x2e>
    while (n-- > 0)
 41e:	00c05f63          	blez	a2,43c <memmove+0x28>
 422:	1602                	slli	a2,a2,0x20
 424:	9201                	srli	a2,a2,0x20
 426:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 42a:	872a                	mv	a4,a0
      *dst++ = *src++;
 42c:	0585                	addi	a1,a1,1
 42e:	0705                	addi	a4,a4,1
 430:	fff5c683          	lbu	a3,-1(a1)
 434:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 438:	fef71ae3          	bne	a4,a5,42c <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
    dst += n;
 442:	00c50733          	add	a4,a0,a2
    src += n;
 446:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 448:	fec05ae3          	blez	a2,43c <memmove+0x28>
 44c:	fff6079b          	addiw	a5,a2,-1
 450:	1782                	slli	a5,a5,0x20
 452:	9381                	srli	a5,a5,0x20
 454:	fff7c793          	not	a5,a5
 458:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 45a:	15fd                	addi	a1,a1,-1
 45c:	177d                	addi	a4,a4,-1
 45e:	0005c683          	lbu	a3,0(a1)
 462:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x46>
 46a:	bfc9                	j	43c <memmove+0x28>

000000000000046c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 472:	ca05                	beqz	a2,4a2 <memcmp+0x36>
 474:	fff6069b          	addiw	a3,a2,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	0685                	addi	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 48c:	0505                	addi	a0,a0,1
    p2++;
 48e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x14>
  }
  return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x30>
      return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	bfe5                	j	49c <memcmp+0x30>

00000000000004a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ae:	f67ff0ef          	jal	414 <memmove>
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <sbrk>:

char *
sbrk(int n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4c2:	4585                	li	a1,1
 4c4:	0b2000ef          	jal	576 <sys_sbrk>
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret

00000000000004d0 <sbrklazy>:

char *
sbrklazy(int n)
{
 4d0:	1141                	addi	sp,sp,-16
 4d2:	e406                	sd	ra,8(sp)
 4d4:	e022                	sd	s0,0(sp)
 4d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4d8:	4589                	li	a1,2
 4da:	09c000ef          	jal	576 <sys_sbrk>
}
 4de:	60a2                	ld	ra,8(sp)
 4e0:	6402                	ld	s0,0(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret

00000000000004e6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e6:	4885                	li	a7,1
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exit>:
.global exit
exit:
 li a7, SYS_exit
 4ee:	4889                	li	a7,2
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f6:	488d                	li	a7,3
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4fe:	4891                	li	a7,4
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <read>:
.global read
read:
 li a7, SYS_read
 506:	4895                	li	a7,5
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <write>:
.global write
write:
 li a7, SYS_write
 50e:	48c1                	li	a7,16
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <close>:
.global close
close:
 li a7, SYS_close
 516:	48d5                	li	a7,21
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <kill>:
.global kill
kill:
 li a7, SYS_kill
 51e:	4899                	li	a7,6
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <exec>:
.global exec
exec:
 li a7, SYS_exec
 526:	489d                	li	a7,7
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <open>:
.global open
open:
 li a7, SYS_open
 52e:	48bd                	li	a7,15
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 536:	48c5                	li	a7,17
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 53e:	48c9                	li	a7,18
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 546:	48a1                	li	a7,8
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <link>:
.global link
link:
 li a7, SYS_link
 54e:	48cd                	li	a7,19
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 556:	48d1                	li	a7,20
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 55e:	48a5                	li	a7,9
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <dup>:
.global dup
dup:
 li a7, SYS_dup
 566:	48a9                	li	a7,10
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 56e:	48ad                	li	a7,11
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 576:	48b1                	li	a7,12
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <pause>:
.global pause
pause:
 li a7, SYS_pause
 57e:	48b5                	li	a7,13
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 586:	48b9                	li	a7,14
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sync>:
.global sync
sync:
 li a7, SYS_sync
 58e:	48d9                	li	a7,22
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <ps>:
.global ps
ps:
 li a7, SYS_ps
 596:	48dd                	li	a7,23
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 59e:	48e1                	li	a7,24
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5a6:	48e5                	li	a7,25
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5ae:	48e9                	li	a7,26
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5b6:	48ed                	li	a7,27
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5be:	48f1                	li	a7,28
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 5c6:	48f5                	li	a7,29
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 5ce:	48f9                	li	a7,30
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 5d6:	48fd                	li	a7,31
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 5de:	02000893          	li	a7,32
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <halt>:
.global halt
halt:
 li a7, SYS_halt
 5e8:	02100893          	li	a7,33
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 5f2:	02200893          	li	a7,34
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 5fc:	02300893          	li	a7,35
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 606:	02400893          	li	a7,36
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 610:	02500893          	li	a7,37
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 61a:	02600893          	li	a7,38
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 624:	02700893          	li	a7,39
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

<<<<<<< HEAD
000000000000062e <putc>:
=======
000000000000062e <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 62e:	02800893          	li	a7,40
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 638:	02900893          	li	a7,41
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 642:	02a00893          	li	a7,42
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 62e:	1101                	addi	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63a:	4605                	li	a2,1
 63c:	fef40593          	addi	a1,s0,-17
 640:	ecfff0ef          	jal	50e <write>
}
 644:	60e2                	ld	ra,24(sp)
 646:	6442                	ld	s0,16(sp)
 648:	6105                	addi	sp,sp,32
 64a:	8082                	ret

000000000000064c <printint>:
=======
 64c:	1101                	addi	sp,sp,-32
 64e:	ec06                	sd	ra,24(sp)
 650:	e822                	sd	s0,16(sp)
 652:	1000                	addi	s0,sp,32
 654:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 658:	4605                	li	a2,1
 65a:	fef40593          	addi	a1,s0,-17
 65e:	eb1ff0ef          	jal	50e <write>
}
 662:	60e2                	ld	ra,24(sp)
 664:	6442                	ld	s0,16(sp)
 666:	6105                	addi	sp,sp,32
 668:	8082                	ret

000000000000066a <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 64c:	715d                	addi	sp,sp,-80
 64e:	e486                	sd	ra,72(sp)
 650:	e0a2                	sd	s0,64(sp)
 652:	f84a                	sd	s2,48(sp)
 654:	0880                	addi	s0,sp,80
 656:	892a                	mv	s2,a0
=======
 66a:	715d                	addi	sp,sp,-80
 66c:	e486                	sd	ra,72(sp)
 66e:	e0a2                	sd	s0,64(sp)
 670:	f84a                	sd	s2,48(sp)
 672:	0880                	addi	s0,sp,80
 674:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 658:	c299                	beqz	a3,65e <printint+0x12>
 65a:	0805c363          	bltz	a1,6e0 <printint+0x94>
  neg = 0;
 65e:	4881                	li	a7,0
 660:	fb840693          	addi	a3,s0,-72
=======
 676:	c299                	beqz	a3,67c <printint+0x12>
 678:	0805c363          	bltz	a1,6fe <printint+0x94>
  neg = 0;
 67c:	4881                	li	a7,0
 67e:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 664:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 666:	00000517          	auipc	a0,0x0
 66a:	54a50513          	addi	a0,a0,1354 # bb0 <digits>
 66e:	883e                	mv	a6,a5
 670:	2785                	addiw	a5,a5,1
 672:	02c5f733          	remu	a4,a1,a2
 676:	972a                	add	a4,a4,a0
 678:	00074703          	lbu	a4,0(a4)
 67c:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 680:	872e                	mv	a4,a1
 682:	02c5d5b3          	divu	a1,a1,a2
 686:	0685                	addi	a3,a3,1
 688:	fec773e3          	bgeu	a4,a2,66e <printint+0x22>
  if (neg)
 68c:	00088b63          	beqz	a7,6a2 <printint+0x56>
    buf[i++] = '-';
 690:	fd078793          	addi	a5,a5,-48
 694:	97a2                	add	a5,a5,s0
 696:	02d00713          	li	a4,45
 69a:	fee78423          	sb	a4,-24(a5)
 69e:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 6a2:	02f05a63          	blez	a5,6d6 <printint+0x8a>
 6a6:	fc26                	sd	s1,56(sp)
 6a8:	f44e                	sd	s3,40(sp)
 6aa:	fb840713          	addi	a4,s0,-72
 6ae:	00f704b3          	add	s1,a4,a5
 6b2:	fff70993          	addi	s3,a4,-1
 6b6:	99be                	add	s3,s3,a5
 6b8:	37fd                	addiw	a5,a5,-1
 6ba:	1782                	slli	a5,a5,0x20
 6bc:	9381                	srli	a5,a5,0x20
 6be:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 6c2:	fff4c583          	lbu	a1,-1(s1)
 6c6:	854a                	mv	a0,s2
 6c8:	f67ff0ef          	jal	62e <putc>
  while (--i >= 0)
 6cc:	14fd                	addi	s1,s1,-1
 6ce:	ff349ae3          	bne	s1,s3,6c2 <printint+0x76>
 6d2:	74e2                	ld	s1,56(sp)
 6d4:	79a2                	ld	s3,40(sp)
}
 6d6:	60a6                	ld	ra,72(sp)
 6d8:	6406                	ld	s0,64(sp)
 6da:	7942                	ld	s2,48(sp)
 6dc:	6161                	addi	sp,sp,80
 6de:	8082                	ret
=======
 682:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 684:	00000517          	auipc	a0,0x0
 688:	53c50513          	addi	a0,a0,1340 # bc0 <digits>
 68c:	883e                	mv	a6,a5
 68e:	2785                	addiw	a5,a5,1
 690:	02c5f733          	remu	a4,a1,a2
 694:	972a                	add	a4,a4,a0
 696:	00074703          	lbu	a4,0(a4)
 69a:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 69e:	872e                	mv	a4,a1
 6a0:	02c5d5b3          	divu	a1,a1,a2
 6a4:	0685                	addi	a3,a3,1
 6a6:	fec773e3          	bgeu	a4,a2,68c <printint+0x22>
  if (neg)
 6aa:	00088b63          	beqz	a7,6c0 <printint+0x56>
    buf[i++] = '-';
 6ae:	fd078793          	addi	a5,a5,-48
 6b2:	97a2                	add	a5,a5,s0
 6b4:	02d00713          	li	a4,45
 6b8:	fee78423          	sb	a4,-24(a5)
 6bc:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 6c0:	02f05a63          	blez	a5,6f4 <printint+0x8a>
 6c4:	fc26                	sd	s1,56(sp)
 6c6:	f44e                	sd	s3,40(sp)
 6c8:	fb840713          	addi	a4,s0,-72
 6cc:	00f704b3          	add	s1,a4,a5
 6d0:	fff70993          	addi	s3,a4,-1
 6d4:	99be                	add	s3,s3,a5
 6d6:	37fd                	addiw	a5,a5,-1
 6d8:	1782                	slli	a5,a5,0x20
 6da:	9381                	srli	a5,a5,0x20
 6dc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 6e0:	fff4c583          	lbu	a1,-1(s1)
 6e4:	854a                	mv	a0,s2
 6e6:	f67ff0ef          	jal	64c <putc>
  while (--i >= 0)
 6ea:	14fd                	addi	s1,s1,-1
 6ec:	ff349ae3          	bne	s1,s3,6e0 <printint+0x76>
 6f0:	74e2                	ld	s1,56(sp)
 6f2:	79a2                	ld	s3,40(sp)
}
 6f4:	60a6                	ld	ra,72(sp)
 6f6:	6406                	ld	s0,64(sp)
 6f8:	7942                	ld	s2,48(sp)
 6fa:	6161                	addi	sp,sp,80
 6fc:	8082                	ret
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
 6e0:	40b005b3          	neg	a1,a1
    neg = 1;
<<<<<<< HEAD
 6e4:	4885                	li	a7,1
    x = -xx;
 6e6:	bfad                	j	660 <printint+0x14>
=======
 702:	4885                	li	a7,1
    x = -xx;
 704:	bfad                	j	67e <printint+0x14>
>>>>>>> e18456e (Updated xv6-riscv)

00000000000006e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 6e8:	711d                	addi	sp,sp,-96
 6ea:	ec86                	sd	ra,88(sp)
 6ec:	e8a2                	sd	s0,80(sp)
 6ee:	e0ca                	sd	s2,64(sp)
 6f0:	1080                	addi	s0,sp,96
=======
 706:	711d                	addi	sp,sp,-96
 708:	ec86                	sd	ra,88(sp)
 70a:	e8a2                	sd	s0,80(sp)
 70c:	e0ca                	sd	s2,64(sp)
 70e:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 6f2:	0005c903          	lbu	s2,0(a1)
 6f6:	28090663          	beqz	s2,982 <vprintf+0x29a>
 6fa:	e4a6                	sd	s1,72(sp)
 6fc:	fc4e                	sd	s3,56(sp)
 6fe:	f852                	sd	s4,48(sp)
 700:	f456                	sd	s5,40(sp)
 702:	f05a                	sd	s6,32(sp)
 704:	ec5e                	sd	s7,24(sp)
 706:	e862                	sd	s8,16(sp)
 708:	e466                	sd	s9,8(sp)
 70a:	8b2a                	mv	s6,a0
 70c:	8a2e                	mv	s4,a1
 70e:	8bb2                	mv	s7,a2
=======
 710:	0005c903          	lbu	s2,0(a1)
 714:	28090663          	beqz	s2,9a0 <vprintf+0x29a>
 718:	e4a6                	sd	s1,72(sp)
 71a:	fc4e                	sd	s3,56(sp)
 71c:	f852                	sd	s4,48(sp)
 71e:	f456                	sd	s5,40(sp)
 720:	f05a                	sd	s6,32(sp)
 722:	ec5e                	sd	s7,24(sp)
 724:	e862                	sd	s8,16(sp)
 726:	e466                	sd	s9,8(sp)
 728:	8b2a                	mv	s6,a0
 72a:	8a2e                	mv	s4,a1
 72c:	8bb2                	mv	s7,a2
>>>>>>> e18456e (Updated xv6-riscv)
  state = 0;
 710:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 712:	4481                	li	s1,0
 714:	4701                	li	a4,0
=======
 730:	4481                	li	s1,0
 732:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 716:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 71a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
<<<<<<< HEAD
 71e:	06c00c93          	li	s9,108
 722:	a005                	j	742 <vprintf+0x5a>
        putc(fd, c0);
 724:	85ca                	mv	a1,s2
 726:	855a                	mv	a0,s6
 728:	f07ff0ef          	jal	62e <putc>
 72c:	a019                	j	732 <vprintf+0x4a>
    } else if (state == '%') {
 72e:	03598263          	beq	s3,s5,752 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 732:	2485                	addiw	s1,s1,1
 734:	8726                	mv	a4,s1
 736:	009a07b3          	add	a5,s4,s1
 73a:	0007c903          	lbu	s2,0(a5)
 73e:	22090a63          	beqz	s2,972 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 742:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 746:	fe0994e3          	bnez	s3,72e <vprintf+0x46>
      if (c0 == '%') {
 74a:	fd579de3          	bne	a5,s5,724 <vprintf+0x3c>
        state = '%';
 74e:	89be                	mv	s3,a5
 750:	b7cd                	j	732 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 752:	00ea06b3          	add	a3,s4,a4
 756:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 75a:	8636                	mv	a2,a3
      if (c1)
 75c:	c681                	beqz	a3,764 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 75e:	9752                	add	a4,a4,s4
 760:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 764:	05878363          	beq	a5,s8,7aa <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 768:	05978d63          	beq	a5,s9,7c2 <vprintf+0xda>
=======
 73c:	06c00c93          	li	s9,108
 740:	a005                	j	760 <vprintf+0x5a>
        putc(fd, c0);
 742:	85ca                	mv	a1,s2
 744:	855a                	mv	a0,s6
 746:	f07ff0ef          	jal	64c <putc>
 74a:	a019                	j	750 <vprintf+0x4a>
    } else if (state == '%') {
 74c:	03598263          	beq	s3,s5,770 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 750:	2485                	addiw	s1,s1,1
 752:	8726                	mv	a4,s1
 754:	009a07b3          	add	a5,s4,s1
 758:	0007c903          	lbu	s2,0(a5)
 75c:	22090a63          	beqz	s2,990 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 760:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 764:	fe0994e3          	bnez	s3,74c <vprintf+0x46>
      if (c0 == '%') {
 768:	fd579de3          	bne	a5,s5,742 <vprintf+0x3c>
        state = '%';
 76c:	89be                	mv	s3,a5
 76e:	b7cd                	j	750 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 770:	00ea06b3          	add	a3,s4,a4
 774:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 778:	8636                	mv	a2,a3
      if (c1)
 77a:	c681                	beqz	a3,782 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 77c:	9752                	add	a4,a4,s4
 77e:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 782:	05878363          	beq	a5,s8,7c8 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 786:	05978d63          	beq	a5,s9,7e0 <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 76c:	07500713          	li	a4,117
 770:	0ee78763          	beq	a5,a4,85e <vprintf+0x176>
=======
 78a:	07500713          	li	a4,117
 78e:	0ee78763          	beq	a5,a4,87c <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 774:	07800713          	li	a4,120
 778:	12e78963          	beq	a5,a4,8aa <vprintf+0x1c2>
=======
 792:	07800713          	li	a4,120
 796:	12e78963          	beq	a5,a4,8c8 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 77c:	07000713          	li	a4,112
 780:	14e78e63          	beq	a5,a4,8dc <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 784:	06300713          	li	a4,99
 788:	18e78e63          	beq	a5,a4,924 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 78c:	07300713          	li	a4,115
 790:	1ae78463          	beq	a5,a4,938 <vprintf+0x250>
=======
 79a:	07000713          	li	a4,112
 79e:	14e78e63          	beq	a5,a4,8fa <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 7a2:	06300713          	li	a4,99
 7a6:	18e78e63          	beq	a5,a4,942 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 7aa:	07300713          	li	a4,115
 7ae:	1ae78463          	beq	a5,a4,956 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 794:	02500713          	li	a4,37
 798:	04e79563          	bne	a5,a4,7e2 <vprintf+0xfa>
        putc(fd, '%');
 79c:	02500593          	li	a1,37
 7a0:	855a                	mv	a0,s6
 7a2:	e8dff0ef          	jal	62e <putc>
=======
 7b2:	02500713          	li	a4,37
 7b6:	04e79563          	bne	a5,a4,800 <vprintf+0xfa>
        putc(fd, '%');
 7ba:	02500593          	li	a1,37
 7be:	855a                	mv	a0,s6
 7c0:	e8dff0ef          	jal	64c <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b769                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
<<<<<<< HEAD
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4685                	li	a3,1
 7b0:	4629                	li	a2,10
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	e95ff0ef          	jal	64c <printint>
 7bc:	8bca                	mv	s7,s2
=======
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4685                	li	a3,1
 7ce:	4629                	li	a2,10
 7d0:	000ba583          	lw	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	e95ff0ef          	jal	66a <printint>
 7da:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bf8d                	j	732 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 7c2:	06400793          	li	a5,100
 7c6:	02f68963          	beq	a3,a5,7f8 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7ca:	06c00793          	li	a5,108
 7ce:	04f68263          	beq	a3,a5,812 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 7d2:	07500793          	li	a5,117
 7d6:	0af68063          	beq	a3,a5,876 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 7da:	07800793          	li	a5,120
 7de:	0ef68263          	beq	a3,a5,8c2 <vprintf+0x1da>
        putc(fd, '%');
<<<<<<< HEAD
 7e2:	02500593          	li	a1,37
 7e6:	855a                	mv	a0,s6
 7e8:	e47ff0ef          	jal	62e <putc>
        putc(fd, c0);
 7ec:	85ca                	mv	a1,s2
 7ee:	855a                	mv	a0,s6
 7f0:	e3fff0ef          	jal	62e <putc>
=======
 800:	02500593          	li	a1,37
 804:	855a                	mv	a0,s6
 806:	e47ff0ef          	jal	64c <putc>
        putc(fd, c0);
 80a:	85ca                	mv	a1,s2
 80c:	855a                	mv	a0,s6
 80e:	e3fff0ef          	jal	64c <putc>
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bf35                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
<<<<<<< HEAD
 7f8:	008b8913          	addi	s2,s7,8
 7fc:	4685                	li	a3,1
 7fe:	4629                	li	a2,10
 800:	000bb583          	ld	a1,0(s7)
 804:	855a                	mv	a0,s6
 806:	e47ff0ef          	jal	64c <printint>
        i += 1;
 80a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 80c:	8bca                	mv	s7,s2
=======
 816:	008b8913          	addi	s2,s7,8
 81a:	4685                	li	a3,1
 81c:	4629                	li	a2,10
 81e:	000bb583          	ld	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	e47ff0ef          	jal	66a <printint>
        i += 1;
 828:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 82a:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 80e:	4981                	li	s3,0
        i += 1;
 810:	b70d                	j	732 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 812:	06400793          	li	a5,100
 816:	02f60763          	beq	a2,a5,844 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 81a:	07500793          	li	a5,117
 81e:	06f60963          	beq	a2,a5,890 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 822:	07800793          	li	a5,120
 826:	faf61ee3          	bne	a2,a5,7e2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
<<<<<<< HEAD
 82a:	008b8913          	addi	s2,s7,8
 82e:	4681                	li	a3,0
 830:	4641                	li	a2,16
 832:	000bb583          	ld	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	e15ff0ef          	jal	64c <printint>
        i += 2;
 83c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 83e:	8bca                	mv	s7,s2
=======
 848:	008b8913          	addi	s2,s7,8
 84c:	4681                	li	a3,0
 84e:	4641                	li	a2,16
 850:	000bb583          	ld	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	e15ff0ef          	jal	66a <printint>
        i += 2;
 85a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 85c:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 840:	4981                	li	s3,0
        i += 2;
 842:	bdc5                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
<<<<<<< HEAD
 844:	008b8913          	addi	s2,s7,8
 848:	4685                	li	a3,1
 84a:	4629                	li	a2,10
 84c:	000bb583          	ld	a1,0(s7)
 850:	855a                	mv	a0,s6
 852:	dfbff0ef          	jal	64c <printint>
        i += 2;
 856:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 858:	8bca                	mv	s7,s2
=======
 862:	008b8913          	addi	s2,s7,8
 866:	4685                	li	a3,1
 868:	4629                	li	a2,10
 86a:	000bb583          	ld	a1,0(s7)
 86e:	855a                	mv	a0,s6
 870:	dfbff0ef          	jal	66a <printint>
        i += 2;
 874:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 876:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 85a:	4981                	li	s3,0
        i += 2;
 85c:	bdd9                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
<<<<<<< HEAD
 85e:	008b8913          	addi	s2,s7,8
 862:	4681                	li	a3,0
 864:	4629                	li	a2,10
 866:	000be583          	lwu	a1,0(s7)
 86a:	855a                	mv	a0,s6
 86c:	de1ff0ef          	jal	64c <printint>
 870:	8bca                	mv	s7,s2
=======
 87c:	008b8913          	addi	s2,s7,8
 880:	4681                	li	a3,0
 882:	4629                	li	a2,10
 884:	000be583          	lwu	a1,0(s7)
 888:	855a                	mv	a0,s6
 88a:	de1ff0ef          	jal	66a <printint>
 88e:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 872:	4981                	li	s3,0
 874:	bd7d                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
<<<<<<< HEAD
 876:	008b8913          	addi	s2,s7,8
 87a:	4681                	li	a3,0
 87c:	4629                	li	a2,10
 87e:	000bb583          	ld	a1,0(s7)
 882:	855a                	mv	a0,s6
 884:	dc9ff0ef          	jal	64c <printint>
        i += 1;
 888:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 88a:	8bca                	mv	s7,s2
=======
 894:	008b8913          	addi	s2,s7,8
 898:	4681                	li	a3,0
 89a:	4629                	li	a2,10
 89c:	000bb583          	ld	a1,0(s7)
 8a0:	855a                	mv	a0,s6
 8a2:	dc9ff0ef          	jal	66a <printint>
        i += 1;
 8a6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a8:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 88c:	4981                	li	s3,0
        i += 1;
 88e:	b555                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
<<<<<<< HEAD
 890:	008b8913          	addi	s2,s7,8
 894:	4681                	li	a3,0
 896:	4629                	li	a2,10
 898:	000bb583          	ld	a1,0(s7)
 89c:	855a                	mv	a0,s6
 89e:	dafff0ef          	jal	64c <printint>
        i += 2;
 8a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8a4:	8bca                	mv	s7,s2
=======
 8ae:	008b8913          	addi	s2,s7,8
 8b2:	4681                	li	a3,0
 8b4:	4629                	li	a2,10
 8b6:	000bb583          	ld	a1,0(s7)
 8ba:	855a                	mv	a0,s6
 8bc:	dafff0ef          	jal	66a <printint>
        i += 2;
 8c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c2:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 8a6:	4981                	li	s3,0
        i += 2;
 8a8:	b569                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
<<<<<<< HEAD
 8aa:	008b8913          	addi	s2,s7,8
 8ae:	4681                	li	a3,0
 8b0:	4641                	li	a2,16
 8b2:	000be583          	lwu	a1,0(s7)
 8b6:	855a                	mv	a0,s6
 8b8:	d95ff0ef          	jal	64c <printint>
 8bc:	8bca                	mv	s7,s2
=======
 8c8:	008b8913          	addi	s2,s7,8
 8cc:	4681                	li	a3,0
 8ce:	4641                	li	a2,16
 8d0:	000be583          	lwu	a1,0(s7)
 8d4:	855a                	mv	a0,s6
 8d6:	d95ff0ef          	jal	66a <printint>
 8da:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	bd8d                	j	732 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
<<<<<<< HEAD
 8c2:	008b8913          	addi	s2,s7,8
 8c6:	4681                	li	a3,0
 8c8:	4641                	li	a2,16
 8ca:	000bb583          	ld	a1,0(s7)
 8ce:	855a                	mv	a0,s6
 8d0:	d7dff0ef          	jal	64c <printint>
        i += 1;
 8d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8d6:	8bca                	mv	s7,s2
=======
 8e0:	008b8913          	addi	s2,s7,8
 8e4:	4681                	li	a3,0
 8e6:	4641                	li	a2,16
 8e8:	000bb583          	ld	a1,0(s7)
 8ec:	855a                	mv	a0,s6
 8ee:	d7dff0ef          	jal	66a <printint>
        i += 1;
 8f2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 8f4:	8bca                	mv	s7,s2
>>>>>>> e18456e (Updated xv6-riscv)
      state = 0;
 8d8:	4981                	li	s3,0
        i += 1;
 8da:	bda1                	j	732 <vprintf+0x4a>
 8dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8de:	008b8d13          	addi	s10,s7,8
 8e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
<<<<<<< HEAD
 8e6:	03000593          	li	a1,48
 8ea:	855a                	mv	a0,s6
 8ec:	d43ff0ef          	jal	62e <putc>
  putc(fd, 'x');
 8f0:	07800593          	li	a1,120
 8f4:	855a                	mv	a0,s6
 8f6:	d39ff0ef          	jal	62e <putc>
 8fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8fc:	00000b97          	auipc	s7,0x0
 900:	2b4b8b93          	addi	s7,s7,692 # bb0 <digits>
 904:	03c9d793          	srli	a5,s3,0x3c
 908:	97de                	add	a5,a5,s7
 90a:	0007c583          	lbu	a1,0(a5)
 90e:	855a                	mv	a0,s6
 910:	d1fff0ef          	jal	62e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 914:	0992                	slli	s3,s3,0x4
 916:	397d                	addiw	s2,s2,-1
 918:	fe0916e3          	bnez	s2,904 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 91c:	8bea                	mv	s7,s10
      state = 0;
 91e:	4981                	li	s3,0
 920:	6d02                	ld	s10,0(sp)
 922:	bd01                	j	732 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 924:	008b8913          	addi	s2,s7,8
 928:	000bc583          	lbu	a1,0(s7)
 92c:	855a                	mv	a0,s6
 92e:	d01ff0ef          	jal	62e <putc>
 932:	8bca                	mv	s7,s2
      state = 0;
 934:	4981                	li	s3,0
 936:	bbf5                	j	732 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 938:	008b8993          	addi	s3,s7,8
 93c:	000bb903          	ld	s2,0(s7)
 940:	00090f63          	beqz	s2,95e <vprintf+0x276>
        for (; *s; s++)
 944:	00094583          	lbu	a1,0(s2)
 948:	c195                	beqz	a1,96c <vprintf+0x284>
          putc(fd, *s);
 94a:	855a                	mv	a0,s6
 94c:	ce3ff0ef          	jal	62e <putc>
        for (; *s; s++)
 950:	0905                	addi	s2,s2,1
 952:	00094583          	lbu	a1,0(s2)
 956:	f9f5                	bnez	a1,94a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 958:	8bce                	mv	s7,s3
      state = 0;
 95a:	4981                	li	s3,0
 95c:	bbd9                	j	732 <vprintf+0x4a>
          s = "(null)";
 95e:	00000917          	auipc	s2,0x0
 962:	24a90913          	addi	s2,s2,586 # ba8 <malloc+0x13e>
        for (; *s; s++)
 966:	02800593          	li	a1,40
 96a:	b7c5                	j	94a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 96c:	8bce                	mv	s7,s3
      state = 0;
 96e:	4981                	li	s3,0
 970:	b3c9                	j	732 <vprintf+0x4a>
 972:	64a6                	ld	s1,72(sp)
 974:	79e2                	ld	s3,56(sp)
 976:	7a42                	ld	s4,48(sp)
 978:	7aa2                	ld	s5,40(sp)
 97a:	7b02                	ld	s6,32(sp)
 97c:	6be2                	ld	s7,24(sp)
 97e:	6c42                	ld	s8,16(sp)
 980:	6ca2                	ld	s9,8(sp)
    }
  }
}
 982:	60e6                	ld	ra,88(sp)
 984:	6446                	ld	s0,80(sp)
 986:	6906                	ld	s2,64(sp)
 988:	6125                	addi	sp,sp,96
 98a:	8082                	ret

000000000000098c <fprintf>:
=======
 904:	03000593          	li	a1,48
 908:	855a                	mv	a0,s6
 90a:	d43ff0ef          	jal	64c <putc>
  putc(fd, 'x');
 90e:	07800593          	li	a1,120
 912:	855a                	mv	a0,s6
 914:	d39ff0ef          	jal	64c <putc>
 918:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 91a:	00000b97          	auipc	s7,0x0
 91e:	2a6b8b93          	addi	s7,s7,678 # bc0 <digits>
 922:	03c9d793          	srli	a5,s3,0x3c
 926:	97de                	add	a5,a5,s7
 928:	0007c583          	lbu	a1,0(a5)
 92c:	855a                	mv	a0,s6
 92e:	d1fff0ef          	jal	64c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 932:	0992                	slli	s3,s3,0x4
 934:	397d                	addiw	s2,s2,-1
 936:	fe0916e3          	bnez	s2,922 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 93a:	8bea                	mv	s7,s10
      state = 0;
 93c:	4981                	li	s3,0
 93e:	6d02                	ld	s10,0(sp)
 940:	bd01                	j	750 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 942:	008b8913          	addi	s2,s7,8
 946:	000bc583          	lbu	a1,0(s7)
 94a:	855a                	mv	a0,s6
 94c:	d01ff0ef          	jal	64c <putc>
 950:	8bca                	mv	s7,s2
      state = 0;
 952:	4981                	li	s3,0
 954:	bbf5                	j	750 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 956:	008b8993          	addi	s3,s7,8
 95a:	000bb903          	ld	s2,0(s7)
 95e:	00090f63          	beqz	s2,97c <vprintf+0x276>
        for (; *s; s++)
 962:	00094583          	lbu	a1,0(s2)
 966:	c195                	beqz	a1,98a <vprintf+0x284>
          putc(fd, *s);
 968:	855a                	mv	a0,s6
 96a:	ce3ff0ef          	jal	64c <putc>
        for (; *s; s++)
 96e:	0905                	addi	s2,s2,1
 970:	00094583          	lbu	a1,0(s2)
 974:	f9f5                	bnez	a1,968 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 976:	8bce                	mv	s7,s3
      state = 0;
 978:	4981                	li	s3,0
 97a:	bbd9                	j	750 <vprintf+0x4a>
          s = "(null)";
 97c:	00000917          	auipc	s2,0x0
 980:	23c90913          	addi	s2,s2,572 # bb8 <malloc+0x130>
        for (; *s; s++)
 984:	02800593          	li	a1,40
 988:	b7c5                	j	968 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 98a:	8bce                	mv	s7,s3
      state = 0;
 98c:	4981                	li	s3,0
 98e:	b3c9                	j	750 <vprintf+0x4a>
 990:	64a6                	ld	s1,72(sp)
 992:	79e2                	ld	s3,56(sp)
 994:	7a42                	ld	s4,48(sp)
 996:	7aa2                	ld	s5,40(sp)
 998:	7b02                	ld	s6,32(sp)
 99a:	6be2                	ld	s7,24(sp)
 99c:	6c42                	ld	s8,16(sp)
 99e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9a0:	60e6                	ld	ra,88(sp)
 9a2:	6446                	ld	s0,80(sp)
 9a4:	6906                	ld	s2,64(sp)
 9a6:	6125                	addi	sp,sp,96
 9a8:	8082                	ret

00000000000009aa <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 98c:	715d                	addi	sp,sp,-80
 98e:	ec06                	sd	ra,24(sp)
 990:	e822                	sd	s0,16(sp)
 992:	1000                	addi	s0,sp,32
 994:	e010                	sd	a2,0(s0)
 996:	e414                	sd	a3,8(s0)
 998:	e818                	sd	a4,16(s0)
 99a:	ec1c                	sd	a5,24(s0)
 99c:	03043023          	sd	a6,32(s0)
 9a0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9a8:	8622                	mv	a2,s0
 9aa:	d3fff0ef          	jal	6e8 <vprintf>
}
 9ae:	60e2                	ld	ra,24(sp)
 9b0:	6442                	ld	s0,16(sp)
 9b2:	6161                	addi	sp,sp,80
 9b4:	8082                	ret

00000000000009b6 <printf>:
=======
 9aa:	715d                	addi	sp,sp,-80
 9ac:	ec06                	sd	ra,24(sp)
 9ae:	e822                	sd	s0,16(sp)
 9b0:	1000                	addi	s0,sp,32
 9b2:	e010                	sd	a2,0(s0)
 9b4:	e414                	sd	a3,8(s0)
 9b6:	e818                	sd	a4,16(s0)
 9b8:	ec1c                	sd	a5,24(s0)
 9ba:	03043023          	sd	a6,32(s0)
 9be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9c6:	8622                	mv	a2,s0
 9c8:	d3fff0ef          	jal	706 <vprintf>
}
 9cc:	60e2                	ld	ra,24(sp)
 9ce:	6442                	ld	s0,16(sp)
 9d0:	6161                	addi	sp,sp,80
 9d2:	8082                	ret

00000000000009d4 <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 9b6:	711d                	addi	sp,sp,-96
 9b8:	ec06                	sd	ra,24(sp)
 9ba:	e822                	sd	s0,16(sp)
 9bc:	1000                	addi	s0,sp,32
 9be:	e40c                	sd	a1,8(s0)
 9c0:	e810                	sd	a2,16(s0)
 9c2:	ec14                	sd	a3,24(s0)
 9c4:	f018                	sd	a4,32(s0)
 9c6:	f41c                	sd	a5,40(s0)
 9c8:	03043823          	sd	a6,48(s0)
 9cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d0:	00840613          	addi	a2,s0,8
 9d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9d8:	85aa                	mv	a1,a0
 9da:	4505                	li	a0,1
 9dc:	d0dff0ef          	jal	6e8 <vprintf>
}
 9e0:	60e2                	ld	ra,24(sp)
 9e2:	6442                	ld	s0,16(sp)
 9e4:	6125                	addi	sp,sp,96
 9e6:	8082                	ret

00000000000009e8 <free>:
=======
 9d4:	711d                	addi	sp,sp,-96
 9d6:	ec06                	sd	ra,24(sp)
 9d8:	e822                	sd	s0,16(sp)
 9da:	1000                	addi	s0,sp,32
 9dc:	e40c                	sd	a1,8(s0)
 9de:	e810                	sd	a2,16(s0)
 9e0:	ec14                	sd	a3,24(s0)
 9e2:	f018                	sd	a4,32(s0)
 9e4:	f41c                	sd	a5,40(s0)
 9e6:	03043823          	sd	a6,48(s0)
 9ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ee:	00840613          	addi	a2,s0,8
 9f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9f6:	85aa                	mv	a1,a0
 9f8:	4505                	li	a0,1
 9fa:	d0dff0ef          	jal	706 <vprintf>
}
 9fe:	60e2                	ld	ra,24(sp)
 a00:	6442                	ld	s0,16(sp)
 a02:	6125                	addi	sp,sp,96
 a04:	8082                	ret

0000000000000a06 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 9e8:	1141                	addi	sp,sp,-16
 9ea:	e422                	sd	s0,8(sp)
 9ec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 9ee:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f2:	00000797          	auipc	a5,0x0
 9f6:	60e7b783          	ld	a5,1550(a5) # 1000 <freep>
 9fa:	a02d                	j	a24 <free+0x3c>
=======
 a06:	1141                	addi	sp,sp,-16
 a08:	e422                	sd	s0,8(sp)
 a0a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a0c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a10:	00000797          	auipc	a5,0x0
 a14:	5f07b783          	ld	a5,1520(a5) # 1000 <freep>
 a18:	a02d                	j	a42 <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 9fc:	4618                	lw	a4,8(a2)
 9fe:	9f2d                	addw	a4,a4,a1
 a00:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a04:	6398                	ld	a4,0(a5)
 a06:	6310                	ld	a2,0(a4)
 a08:	a83d                	j	a46 <free+0x5e>
=======
 a1a:	4618                	lw	a4,8(a2)
 a1c:	9f2d                	addw	a4,a4,a1
 a1e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a22:	6398                	ld	a4,0(a5)
 a24:	6310                	ld	a2,0(a4)
 a26:	a83d                	j	a64 <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 a0a:	ff852703          	lw	a4,-8(a0)
 a0e:	9f31                	addw	a4,a4,a2
 a10:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a12:	ff053683          	ld	a3,-16(a0)
 a16:	a091                	j	a5a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a18:	6398                	ld	a4,0(a5)
 a1a:	00e7e463          	bltu	a5,a4,a22 <free+0x3a>
 a1e:	00e6ea63          	bltu	a3,a4,a32 <free+0x4a>
{
 a22:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a24:	fed7fae3          	bgeu	a5,a3,a18 <free+0x30>
 a28:	6398                	ld	a4,0(a5)
 a2a:	00e6e463          	bltu	a3,a4,a32 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2e:	fee7eae3          	bltu	a5,a4,a22 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 a32:	ff852583          	lw	a1,-8(a0)
 a36:	6390                	ld	a2,0(a5)
 a38:	02059813          	slli	a6,a1,0x20
 a3c:	01c85713          	srli	a4,a6,0x1c
 a40:	9736                	add	a4,a4,a3
 a42:	fae60de3          	beq	a2,a4,9fc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a46:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 a4a:	4790                	lw	a2,8(a5)
 a4c:	02061593          	slli	a1,a2,0x20
 a50:	01c5d713          	srli	a4,a1,0x1c
 a54:	973e                	add	a4,a4,a5
 a56:	fae68ae3          	beq	a3,a4,a0a <free+0x22>
    p->s.ptr = bp->s.ptr;
 a5a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a5c:	00000717          	auipc	a4,0x0
 a60:	5af73223          	sd	a5,1444(a4) # 1000 <freep>
}
 a64:	6422                	ld	s0,8(sp)
 a66:	0141                	addi	sp,sp,16
 a68:	8082                	ret
=======
 a28:	ff852703          	lw	a4,-8(a0)
 a2c:	9f31                	addw	a4,a4,a2
 a2e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a30:	ff053683          	ld	a3,-16(a0)
 a34:	a091                	j	a78 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a36:	6398                	ld	a4,0(a5)
 a38:	00e7e463          	bltu	a5,a4,a40 <free+0x3a>
 a3c:	00e6ea63          	bltu	a3,a4,a50 <free+0x4a>
{
 a40:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a42:	fed7fae3          	bgeu	a5,a3,a36 <free+0x30>
 a46:	6398                	ld	a4,0(a5)
 a48:	00e6e463          	bltu	a3,a4,a50 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a4c:	fee7eae3          	bltu	a5,a4,a40 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 a50:	ff852583          	lw	a1,-8(a0)
 a54:	6390                	ld	a2,0(a5)
 a56:	02059813          	slli	a6,a1,0x20
 a5a:	01c85713          	srli	a4,a6,0x1c
 a5e:	9736                	add	a4,a4,a3
 a60:	fae60de3          	beq	a2,a4,a1a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a64:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 a68:	4790                	lw	a2,8(a5)
 a6a:	02061593          	slli	a1,a2,0x20
 a6e:	01c5d713          	srli	a4,a1,0x1c
 a72:	973e                	add	a4,a4,a5
 a74:	fae68ae3          	beq	a3,a4,a28 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a78:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a7a:	00000717          	auipc	a4,0x0
 a7e:	58f73323          	sd	a5,1414(a4) # 1000 <freep>
}
 a82:	6422                	ld	s0,8(sp)
 a84:	0141                	addi	sp,sp,16
 a86:	8082                	ret
>>>>>>> e18456e (Updated xv6-riscv)

0000000000000a6a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 a6a:	7139                	addi	sp,sp,-64
 a6c:	fc06                	sd	ra,56(sp)
 a6e:	f822                	sd	s0,48(sp)
 a70:	f426                	sd	s1,40(sp)
 a72:	ec4e                	sd	s3,24(sp)
 a74:	0080                	addi	s0,sp,64
=======
 a88:	7139                	addi	sp,sp,-64
 a8a:	fc06                	sd	ra,56(sp)
 a8c:	f822                	sd	s0,48(sp)
 a8e:	f426                	sd	s1,40(sp)
 a90:	ec4e                	sd	s3,24(sp)
 a92:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 a76:	02051493          	slli	s1,a0,0x20
 a7a:	9081                	srli	s1,s1,0x20
 a7c:	04bd                	addi	s1,s1,15
 a7e:	8091                	srli	s1,s1,0x4
 a80:	0014899b          	addiw	s3,s1,1
 a84:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 a86:	00000517          	auipc	a0,0x0
 a8a:	57a53503          	ld	a0,1402(a0) # 1000 <freep>
 a8e:	c915                	beqz	a0,ac2 <malloc+0x58>
=======
 a94:	02051493          	slli	s1,a0,0x20
 a98:	9081                	srli	s1,s1,0x20
 a9a:	04bd                	addi	s1,s1,15
 a9c:	8091                	srli	s1,s1,0x4
 a9e:	0014899b          	addiw	s3,s1,1
 aa2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 aa4:	00000517          	auipc	a0,0x0
 aa8:	55c53503          	ld	a0,1372(a0) # 1000 <freep>
 aac:	c915                	beqz	a0,ae0 <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 a90:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a92:	4798                	lw	a4,8(a5)
 a94:	08977a63          	bgeu	a4,s1,b28 <malloc+0xbe>
 a98:	f04a                	sd	s2,32(sp)
 a9a:	e852                	sd	s4,16(sp)
 a9c:	e456                	sd	s5,8(sp)
 a9e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 aa0:	8a4e                	mv	s4,s3
 aa2:	0009871b          	sext.w	a4,s3
 aa6:	6685                	lui	a3,0x1
 aa8:	00d77363          	bgeu	a4,a3,aae <malloc+0x44>
 aac:	6a05                	lui	s4,0x1
 aae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ab2:	004a1a1b          	slliw	s4,s4,0x4
=======
 aae:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ab0:	4798                	lw	a4,8(a5)
 ab2:	08977a63          	bgeu	a4,s1,b46 <malloc+0xbe>
 ab6:	f04a                	sd	s2,32(sp)
 ab8:	e852                	sd	s4,16(sp)
 aba:	e456                	sd	s5,8(sp)
 abc:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 abe:	8a4e                	mv	s4,s3
 ac0:	0009871b          	sext.w	a4,s3
 ac4:	6685                	lui	a3,0x1
 ac6:	00d77363          	bgeu	a4,a3,acc <malloc+0x44>
 aca:	6a05                	lui	s4,0x1
 acc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ad0:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 ab6:	00000917          	auipc	s2,0x0
 aba:	54a90913          	addi	s2,s2,1354 # 1000 <freep>
  if (p == SBRK_ERROR)
 abe:	5afd                	li	s5,-1
 ac0:	a081                	j	b00 <malloc+0x96>
 ac2:	f04a                	sd	s2,32(sp)
 ac4:	e852                	sd	s4,16(sp)
 ac6:	e456                	sd	s5,8(sp)
 ac8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aca:	00001797          	auipc	a5,0x1
 ace:	94678793          	addi	a5,a5,-1722 # 1410 <base>
 ad2:	00000717          	auipc	a4,0x0
 ad6:	52f73723          	sd	a5,1326(a4) # 1000 <freep>
 ada:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 adc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 ae0:	b7c1                	j	aa0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 ae2:	6398                	ld	a4,0(a5)
 ae4:	e118                	sd	a4,0(a0)
 ae6:	a8a9                	j	b40 <malloc+0xd6>
  hp->s.size = nu;
 ae8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 aec:	0541                	addi	a0,a0,16
 aee:	efbff0ef          	jal	9e8 <free>
  return freep;
 af2:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 af6:	c12d                	beqz	a0,b58 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 af8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 afa:	4798                	lw	a4,8(a5)
 afc:	02977263          	bgeu	a4,s1,b20 <malloc+0xb6>
    if (p == freep)
 b00:	00093703          	ld	a4,0(s2)
 b04:	853e                	mv	a0,a5
 b06:	fef719e3          	bne	a4,a5,af8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b0a:	8552                	mv	a0,s4
 b0c:	9afff0ef          	jal	4ba <sbrk>
  if (p == SBRK_ERROR)
 b10:	fd551ce3          	bne	a0,s5,ae8 <malloc+0x7e>
        return 0;
 b14:	4501                	li	a0,0
 b16:	7902                	ld	s2,32(sp)
 b18:	6a42                	ld	s4,16(sp)
 b1a:	6aa2                	ld	s5,8(sp)
 b1c:	6b02                	ld	s6,0(sp)
 b1e:	a03d                	j	b4c <malloc+0xe2>
 b20:	7902                	ld	s2,32(sp)
 b22:	6a42                	ld	s4,16(sp)
 b24:	6aa2                	ld	s5,8(sp)
 b26:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b28:	fae48de3          	beq	s1,a4,ae2 <malloc+0x78>
        p->s.size -= nunits;
 b2c:	4137073b          	subw	a4,a4,s3
 b30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b32:	02071693          	slli	a3,a4,0x20
 b36:	01c6d713          	srli	a4,a3,0x1c
 b3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b40:	00000717          	auipc	a4,0x0
 b44:	4ca73023          	sd	a0,1216(a4) # 1000 <freep>
      return (void *)(p + 1);
 b48:	01078513          	addi	a0,a5,16
  }
}
 b4c:	70e2                	ld	ra,56(sp)
 b4e:	7442                	ld	s0,48(sp)
 b50:	74a2                	ld	s1,40(sp)
 b52:	69e2                	ld	s3,24(sp)
 b54:	6121                	addi	sp,sp,64
 b56:	8082                	ret
 b58:	7902                	ld	s2,32(sp)
 b5a:	6a42                	ld	s4,16(sp)
 b5c:	6aa2                	ld	s5,8(sp)
 b5e:	6b02                	ld	s6,0(sp)
 b60:	b7f5                	j	b4c <malloc+0xe2>
=======
 ad4:	00000917          	auipc	s2,0x0
 ad8:	52c90913          	addi	s2,s2,1324 # 1000 <freep>
  if (p == SBRK_ERROR)
 adc:	5afd                	li	s5,-1
 ade:	a081                	j	b1e <malloc+0x96>
 ae0:	f04a                	sd	s2,32(sp)
 ae2:	e852                	sd	s4,16(sp)
 ae4:	e456                	sd	s5,8(sp)
 ae6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ae8:	00001797          	auipc	a5,0x1
 aec:	92878793          	addi	a5,a5,-1752 # 1410 <base>
 af0:	00000717          	auipc	a4,0x0
 af4:	50f73823          	sd	a5,1296(a4) # 1000 <freep>
 af8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 afa:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 afe:	b7c1                	j	abe <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b00:	6398                	ld	a4,0(a5)
 b02:	e118                	sd	a4,0(a0)
 b04:	a8a9                	j	b5e <malloc+0xd6>
  hp->s.size = nu;
 b06:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 b0a:	0541                	addi	a0,a0,16
 b0c:	efbff0ef          	jal	a06 <free>
  return freep;
 b10:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 b14:	c12d                	beqz	a0,b76 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b16:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b18:	4798                	lw	a4,8(a5)
 b1a:	02977263          	bgeu	a4,s1,b3e <malloc+0xb6>
    if (p == freep)
 b1e:	00093703          	ld	a4,0(s2)
 b22:	853e                	mv	a0,a5
 b24:	fef719e3          	bne	a4,a5,b16 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b28:	8552                	mv	a0,s4
 b2a:	991ff0ef          	jal	4ba <sbrk>
  if (p == SBRK_ERROR)
 b2e:	fd551ce3          	bne	a0,s5,b06 <malloc+0x7e>
        return 0;
 b32:	4501                	li	a0,0
 b34:	7902                	ld	s2,32(sp)
 b36:	6a42                	ld	s4,16(sp)
 b38:	6aa2                	ld	s5,8(sp)
 b3a:	6b02                	ld	s6,0(sp)
 b3c:	a03d                	j	b6a <malloc+0xe2>
 b3e:	7902                	ld	s2,32(sp)
 b40:	6a42                	ld	s4,16(sp)
 b42:	6aa2                	ld	s5,8(sp)
 b44:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b46:	fae48de3          	beq	s1,a4,b00 <malloc+0x78>
        p->s.size -= nunits;
 b4a:	4137073b          	subw	a4,a4,s3
 b4e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b50:	02071693          	slli	a3,a4,0x20
 b54:	01c6d713          	srli	a4,a3,0x1c
 b58:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b5a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b5e:	00000717          	auipc	a4,0x0
 b62:	4aa73123          	sd	a0,1186(a4) # 1000 <freep>
      return (void *)(p + 1);
 b66:	01078513          	addi	a0,a5,16
  }
}
 b6a:	70e2                	ld	ra,56(sp)
 b6c:	7442                	ld	s0,48(sp)
 b6e:	74a2                	ld	s1,40(sp)
 b70:	69e2                	ld	s3,24(sp)
 b72:	6121                	addi	sp,sp,64
 b74:	8082                	ret
 b76:	7902                	ld	s2,32(sp)
 b78:	6a42                	ld	s4,16(sp)
 b7a:	6aa2                	ld	s5,8(sp)
 b7c:	6b02                	ld	s6,0(sp)
 b7e:	b7f5                	j	b6a <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
