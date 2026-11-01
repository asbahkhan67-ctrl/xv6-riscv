
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ = 2000 };

  for (int i = 1; i < argc; i++) {
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++) {
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	3a2000ef          	jal	3c2 <fork>
    if (pid1 < 0) {
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if (pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++) {
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for (int i = 1; i < argc; i++) {
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	9e250513          	addi	a0,a0,-1566 # a20 <malloc+0xf8>
  46:	02b000ef          	jal	870 <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	37e000ef          	jal	3ca <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	3ac000ef          	jal	40a <open>
  62:	89aa                	mv	s3,a0
      if (fd < 0) {
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0' + i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	118000ef          	jal	190 <memset>
  7c:	0fa00493          	li	s1,250
        if ((n = write(fd, buf, SZ)) != SZ) {
  80:	00001a17          	auipc	s4,0x1
  84:	f90a0a13          	addi	s4,s4,-112 # 1010 <buf>
  88:	7d000913          	li	s2,2000
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	358000ef          	jal	3ea <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for (i = 0; i < N; i++) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	32a000ef          	jal	3ca <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	98c50513          	addi	a0,a0,-1652 # a38 <malloc+0x110>
  b4:	7bc000ef          	jal	870 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	310000ef          	jal	3ca <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	99050513          	addi	a0,a0,-1648 # a50 <malloc+0x128>
  c8:	7a8000ef          	jal	870 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2fc000ef          	jal	3ca <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	2fc000ef          	jal	3d2 <wait>
    if (xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for (int i = 1; i < argc; i++) {
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2d0000ef          	jal	3ca <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	2bc000ef          	jal	3ca <exit>

0000000000000112 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf99                	beqz	a5,18c <strlen+0x2a>
 170:	0505                	addi	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for (n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strlen+0x22>

0000000000000190 <memset>:

void *
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 198:	ca19                	beqz	a2,1ae <memset+0x1e>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x14>
  }
  return dst;
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char *
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf81                	beqz	a5,1da <strchr+0x24>
    if (*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1c>
  for (; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xe>
      return (char *)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfdd                	j	1d2 <strchr+0x1c>

00000000000001de <gets>:

char *
gets(char *buf, int max)
{
 1de:	7159                	addi	sp,sp,-112
 1e0:	f486                	sd	ra,104(sp)
 1e2:	f0a2                	sd	s0,96(sp)
 1e4:	eca6                	sd	s1,88(sp)
 1e6:	e8ca                	sd	s2,80(sp)
 1e8:	e4ce                	sd	s3,72(sp)
 1ea:	e0d2                	sd	s4,64(sp)
 1ec:	fc56                	sd	s5,56(sp)
 1ee:	f85a                	sd	s6,48(sp)
 1f0:	f45e                	sd	s7,40(sp)
 1f2:	f062                	sd	s8,32(sp)
 1f4:	ec66                	sd	s9,24(sp)
 1f6:	e86a                	sd	s10,16(sp)
 1f8:	1880                	addi	s0,sp,112
 1fa:	8caa                	mv	s9,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1fe:	892a                	mv	s2,a0
 200:	4481                	li	s1,0
    cc = read(0, &c, 1);
 202:	f9f40b13          	addi	s6,s0,-97
 206:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 208:	4ba9                	li	s7,10
 20a:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 20c:	8d26                	mv	s10,s1
 20e:	0014899b          	addiw	s3,s1,1
 212:	84ce                	mv	s1,s3
 214:	0349d563          	bge	s3,s4,23e <gets+0x60>
    cc = read(0, &c, 1);
 218:	8656                	mv	a2,s5
 21a:	85da                	mv	a1,s6
 21c:	4501                	li	a0,0
 21e:	1c4000ef          	jal	3e2 <read>
    if (cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x60>
    buf[i++] = c;
 226:	f9f44783          	lbu	a5,-97(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 22e:	01778763          	beq	a5,s7,23c <gets+0x5e>
 232:	0905                	addi	s2,s2,1
 234:	fd879ce3          	bne	a5,s8,20c <gets+0x2e>
    buf[i++] = c;
 238:	8d4e                	mv	s10,s3
 23a:	a011                	j	23e <gets+0x60>
 23c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 23e:	9d66                	add	s10,s10,s9
 240:	000d0023          	sb	zero,0(s10)
  return buf;
}
 244:	8566                	mv	a0,s9
 246:	70a6                	ld	ra,104(sp)
 248:	7406                	ld	s0,96(sp)
 24a:	64e6                	ld	s1,88(sp)
 24c:	6946                	ld	s2,80(sp)
 24e:	69a6                	ld	s3,72(sp)
 250:	6a06                	ld	s4,64(sp)
 252:	7ae2                	ld	s5,56(sp)
 254:	7b42                	ld	s6,48(sp)
 256:	7ba2                	ld	s7,40(sp)
 258:	7c02                	ld	s8,32(sp)
 25a:	6ce2                	ld	s9,24(sp)
 25c:	6d42                	ld	s10,16(sp)
 25e:	6165                	addi	sp,sp,112
 260:	8082                	ret

0000000000000262 <stat>:

int
stat(const char *n, struct stat *st)
{
 262:	1101                	addi	sp,sp,-32
 264:	ec06                	sd	ra,24(sp)
 266:	e822                	sd	s0,16(sp)
 268:	e04a                	sd	s2,0(sp)
 26a:	1000                	addi	s0,sp,32
 26c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26e:	4581                	li	a1,0
 270:	19a000ef          	jal	40a <open>
  if (fd < 0)
 274:	02054263          	bltz	a0,298 <stat+0x36>
 278:	e426                	sd	s1,8(sp)
 27a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27c:	85ca                	mv	a1,s2
 27e:	1a4000ef          	jal	422 <fstat>
 282:	892a                	mv	s2,a0
  close(fd);
 284:	8526                	mv	a0,s1
 286:	16c000ef          	jal	3f2 <close>
  return r;
 28a:	64a2                	ld	s1,8(sp)
}
 28c:	854a                	mv	a0,s2
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	6902                	ld	s2,0(sp)
 294:	6105                	addi	sp,sp,32
 296:	8082                	ret
    return -1;
 298:	597d                	li	s2,-1
 29a:	bfcd                	j	28c <stat+0x2a>

000000000000029c <atoi>:

int
atoi(const char *s)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 2a4:	00054683          	lbu	a3,0(a0)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	4625                	li	a2,9
 2b2:	02f66963          	bltu	a2,a5,2e4 <atoi+0x48>
 2b6:	872a                	mv	a4,a0
  n = 0;
 2b8:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2ba:	0705                	addi	a4,a4,1
 2bc:	0025179b          	slliw	a5,a0,0x2
 2c0:	9fa9                	addw	a5,a5,a0
 2c2:	0017979b          	slliw	a5,a5,0x1
 2c6:	9fb5                	addw	a5,a5,a3
 2c8:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2cc:	00074683          	lbu	a3,0(a4)
 2d0:	fd06879b          	addiw	a5,a3,-48
 2d4:	0ff7f793          	zext.b	a5,a5
 2d8:	fef671e3          	bgeu	a2,a5,2ba <atoi+0x1e>
  return n;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  n = 0;
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <atoi+0x40>

00000000000002e8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f0:	02b57563          	bgeu	a0,a1,31a <memmove+0x32>
    while (n-- > 0)
 2f4:	00c05f63          	blez	a2,312 <memmove+0x2a>
 2f8:	1602                	slli	a2,a2,0x20
 2fa:	9201                	srli	a2,a2,0x20
 2fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 300:	872a                	mv	a4,a0
      *dst++ = *src++;
 302:	0585                	addi	a1,a1,1
 304:	0705                	addi	a4,a4,1
 306:	fff5c683          	lbu	a3,-1(a1)
 30a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
    dst += n;
 31a:	00c50733          	add	a4,a0,a2
    src += n;
 31e:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 320:	fec059e3          	blez	a2,312 <memmove+0x2a>
 324:	fff6079b          	addiw	a5,a2,-1
 328:	1782                	slli	a5,a5,0x20
 32a:	9381                	srli	a5,a5,0x20
 32c:	fff7c793          	not	a5,a5
 330:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 332:	15fd                	addi	a1,a1,-1
 334:	177d                	addi	a4,a4,-1
 336:	0005c683          	lbu	a3,0(a1)
 33a:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 33e:	fef71ae3          	bne	a4,a5,332 <memmove+0x4a>
 342:	bfc1                	j	312 <memmove+0x2a>

0000000000000344 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34c:	ca0d                	beqz	a2,37e <memcmp+0x3a>
 34e:	fff6069b          	addiw	a3,a2,-1
 352:	1682                	slli	a3,a3,0x20
 354:	9281                	srli	a3,a3,0x20
 356:	0685                	addi	a3,a3,1
 358:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35a:	00054783          	lbu	a5,0(a0)
 35e:	0005c703          	lbu	a4,0(a1)
 362:	00e79863          	bne	a5,a4,372 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 366:	0505                	addi	a0,a0,1
    p2++;
 368:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36a:	fed518e3          	bne	a0,a3,35a <memcmp+0x16>
  }
  return 0;
 36e:	4501                	li	a0,0
 370:	a019                	j	376 <memcmp+0x32>
      return *p1 - *p2;
 372:	40e7853b          	subw	a0,a5,a4
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  return 0;
 37e:	4501                	li	a0,0
 380:	bfdd                	j	376 <memcmp+0x32>

0000000000000382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38a:	f5fff0ef          	jal	2e8 <memmove>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <sbrk>:

char *
sbrk(int n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 39e:	4585                	li	a1,1
 3a0:	0b2000ef          	jal	452 <sys_sbrk>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <sbrklazy>:

char *
sbrklazy(int n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3b4:	4589                	li	a1,2
 3b6:	09c000ef          	jal	452 <sys_sbrk>
}
 3ba:	60a2                	ld	ra,8(sp)
 3bc:	6402                	ld	s0,0(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret

00000000000003c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c2:	4885                	li	a7,1
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ca:	4889                	li	a7,2
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d2:	488d                	li	a7,3
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3da:	4891                	li	a7,4
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <read>:
.global read
read:
 li a7, SYS_read
 3e2:	4895                	li	a7,5
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <write>:
.global write
write:
 li a7, SYS_write
 3ea:	48c1                	li	a7,16
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <close>:
.global close
close:
 li a7, SYS_close
 3f2:	48d5                	li	a7,21
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fa:	4899                	li	a7,6
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <exec>:
.global exec
exec:
 li a7, SYS_exec
 402:	489d                	li	a7,7
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <open>:
.global open
open:
 li a7, SYS_open
 40a:	48bd                	li	a7,15
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 412:	48c5                	li	a7,17
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41a:	48c9                	li	a7,18
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 422:	48a1                	li	a7,8
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <link>:
.global link
link:
 li a7, SYS_link
 42a:	48cd                	li	a7,19
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 432:	48d1                	li	a7,20
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43a:	48a5                	li	a7,9
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <dup>:
.global dup
dup:
 li a7, SYS_dup
 442:	48a9                	li	a7,10
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44a:	48ad                	li	a7,11
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 452:	48b1                	li	a7,12
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pause>:
.global pause
pause:
 li a7, SYS_pause
 45a:	48b5                	li	a7,13
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 462:	48b9                	li	a7,14
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sync>:
.global sync
sync:
 li a7, SYS_sync
 46a:	48d9                	li	a7,22
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <ps>:
.global ps
ps:
 li a7, SYS_ps
 472:	48dd                	li	a7,23
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 47a:	48e1                	li	a7,24
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 482:	48e5                	li	a7,25
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 48a:	48e9                	li	a7,26
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <trace>:
.global trace
trace:
 li a7, SYS_trace
 492:	48ed                	li	a7,27
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 49a:	48f1                	li	a7,28
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 4a2:	48f5                	li	a7,29
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 4aa:	48f9                	li	a7,30
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 4b2:	48fd                	li	a7,31
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 4ba:	02000893          	li	a7,32
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <halt>:
.global halt
halt:
 li a7, SYS_halt
 4c4:	02100893          	li	a7,33
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 4ce:	02200893          	li	a7,34
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 4d8:	02300893          	li	a7,35
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 4e2:	02400893          	li	a7,36
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 4ec:	02500893          	li	a7,37
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f6:	1101                	addi	sp,sp,-32
 4f8:	ec06                	sd	ra,24(sp)
 4fa:	e822                	sd	s0,16(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 502:	4605                	li	a2,1
 504:	fef40593          	addi	a1,s0,-17
 508:	ee3ff0ef          	jal	3ea <write>
}
 50c:	60e2                	ld	ra,24(sp)
 50e:	6442                	ld	s0,16(sp)
 510:	6105                	addi	sp,sp,32
 512:	8082                	ret

0000000000000514 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 514:	715d                	addi	sp,sp,-80
 516:	e486                	sd	ra,72(sp)
 518:	e0a2                	sd	s0,64(sp)
 51a:	fc26                	sd	s1,56(sp)
 51c:	f84a                	sd	s2,48(sp)
 51e:	f44e                	sd	s3,40(sp)
 520:	0880                	addi	s0,sp,80
 522:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 524:	c299                	beqz	a3,52a <printint+0x16>
 526:	0605cc63          	bltz	a1,59e <printint+0x8a>
  neg = 0;
 52a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 52c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 530:	869a                	mv	a3,t1
  i = 0;
 532:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 534:	00000817          	auipc	a6,0x0
 538:	53c80813          	addi	a6,a6,1340 # a70 <digits>
 53c:	88be                	mv	a7,a5
 53e:	0017851b          	addiw	a0,a5,1
 542:	87aa                	mv	a5,a0
 544:	02c5f733          	remu	a4,a1,a2
 548:	9742                	add	a4,a4,a6
 54a:	00074703          	lbu	a4,0(a4)
 54e:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 552:	872e                	mv	a4,a1
 554:	02c5d5b3          	divu	a1,a1,a2
 558:	0685                	addi	a3,a3,1
 55a:	fec771e3          	bgeu	a4,a2,53c <printint+0x28>
  if (neg)
 55e:	000e0c63          	beqz	t3,576 <printint+0x62>
    buf[i++] = '-';
 562:	fd050793          	addi	a5,a0,-48
 566:	00878533          	add	a0,a5,s0
 56a:	02d00793          	li	a5,45
 56e:	fef50423          	sb	a5,-24(a0)
 572:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 576:	fff7899b          	addiw	s3,a5,-1
 57a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 57e:	fff4c583          	lbu	a1,-1(s1)
 582:	854a                	mv	a0,s2
 584:	f73ff0ef          	jal	4f6 <putc>
  while (--i >= 0)
 588:	39fd                	addiw	s3,s3,-1
 58a:	14fd                	addi	s1,s1,-1
 58c:	fe09d9e3          	bgez	s3,57e <printint+0x6a>
}
 590:	60a6                	ld	ra,72(sp)
 592:	6406                	ld	s0,64(sp)
 594:	74e2                	ld	s1,56(sp)
 596:	7942                	ld	s2,48(sp)
 598:	79a2                	ld	s3,40(sp)
 59a:	6161                	addi	sp,sp,80
 59c:	8082                	ret
    x = -xx;
 59e:	40b005b3          	neg	a1,a1
    neg = 1;
 5a2:	4e05                	li	t3,1
    x = -xx;
 5a4:	b761                	j	52c <printint+0x18>

00000000000005a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a6:	711d                	addi	sp,sp,-96
 5a8:	ec86                	sd	ra,88(sp)
 5aa:	e8a2                	sd	s0,80(sp)
 5ac:	e4a6                	sd	s1,72(sp)
 5ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5b0:	0005c483          	lbu	s1,0(a1)
 5b4:	28048463          	beqz	s1,83c <vprintf+0x296>
 5b8:	e0ca                	sd	s2,64(sp)
 5ba:	fc4e                	sd	s3,56(sp)
 5bc:	f852                	sd	s4,48(sp)
 5be:	f456                	sd	s5,40(sp)
 5c0:	f05a                	sd	s6,32(sp)
 5c2:	ec5e                	sd	s7,24(sp)
 5c4:	e862                	sd	s8,16(sp)
 5c6:	e466                	sd	s9,8(sp)
 5c8:	8b2a                	mv	s6,a0
 5ca:	8a2e                	mv	s4,a1
 5cc:	8bb2                	mv	s7,a2
  state = 0;
 5ce:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5d0:	4901                	li	s2,0
 5d2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5dc:	06c00c93          	li	s9,108
 5e0:	a00d                	j	602 <vprintf+0x5c>
        putc(fd, c0);
 5e2:	85a6                	mv	a1,s1
 5e4:	855a                	mv	a0,s6
 5e6:	f11ff0ef          	jal	4f6 <putc>
 5ea:	a019                	j	5f0 <vprintf+0x4a>
    } else if (state == '%') {
 5ec:	03598363          	beq	s3,s5,612 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 5f0:	0019079b          	addiw	a5,s2,1
 5f4:	893e                	mv	s2,a5
 5f6:	873e                	mv	a4,a5
 5f8:	97d2                	add	a5,a5,s4
 5fa:	0007c483          	lbu	s1,0(a5)
 5fe:	22048763          	beqz	s1,82c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 602:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 606:	fe0993e3          	bnez	s3,5ec <vprintf+0x46>
      if (c0 == '%') {
 60a:	fd579ce3          	bne	a5,s5,5e2 <vprintf+0x3c>
        state = '%';
 60e:	89be                	mv	s3,a5
 610:	b7c5                	j	5f0 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 612:	00ea06b3          	add	a3,s4,a4
 616:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 61a:	8636                	mv	a2,a3
      if (c1)
 61c:	c681                	beqz	a3,624 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 61e:	9752                	add	a4,a4,s4
 620:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 624:	05878263          	beq	a5,s8,668 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 628:	05978c63          	beq	a5,s9,680 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 62c:	07500713          	li	a4,117
 630:	0ee78663          	beq	a5,a4,71c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 634:	07800713          	li	a4,120
 638:	12e78863          	beq	a5,a4,768 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 63c:	07000713          	li	a4,112
 640:	14e78d63          	beq	a5,a4,79a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 644:	06300713          	li	a4,99
 648:	18e78c63          	beq	a5,a4,7e0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 64c:	07300713          	li	a4,115
 650:	1ae78263          	beq	a5,a4,7f4 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 654:	02500713          	li	a4,37
 658:	04e79463          	bne	a5,a4,6a0 <vprintf+0xfa>
        putc(fd, '%');
 65c:	85ba                	mv	a1,a4
 65e:	855a                	mv	a0,s6
 660:	e97ff0ef          	jal	4f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 664:	4981                	li	s3,0
 666:	b769                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 668:	008b8493          	addi	s1,s7,8
 66c:	4685                	li	a3,1
 66e:	4629                	li	a2,10
 670:	000ba583          	lw	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e9fff0ef          	jal	514 <printint>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bf8d                	j	5f0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 680:	06400793          	li	a5,100
 684:	02f68963          	beq	a3,a5,6b6 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 688:	06c00793          	li	a5,108
 68c:	04f68263          	beq	a3,a5,6d0 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 690:	07500793          	li	a5,117
 694:	0af68063          	beq	a3,a5,734 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 698:	07800793          	li	a5,120
 69c:	0ef68263          	beq	a3,a5,780 <vprintf+0x1da>
        putc(fd, '%');
 6a0:	02500593          	li	a1,37
 6a4:	855a                	mv	a0,s6
 6a6:	e51ff0ef          	jal	4f6 <putc>
        putc(fd, c0);
 6aa:	85a6                	mv	a1,s1
 6ac:	855a                	mv	a0,s6
 6ae:	e49ff0ef          	jal	4f6 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bf35                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	008b8493          	addi	s1,s7,8
 6ba:	4685                	li	a3,1
 6bc:	4629                	li	a2,10
 6be:	000bb583          	ld	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	e51ff0ef          	jal	514 <printint>
        i += 1;
 6c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ca:	8ba6                	mv	s7,s1
      state = 0;
 6cc:	4981                	li	s3,0
        i += 1;
 6ce:	b70d                	j	5f0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6d0:	06400793          	li	a5,100
 6d4:	02f60763          	beq	a2,a5,702 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6d8:	07500793          	li	a5,117
 6dc:	06f60963          	beq	a2,a5,74e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6e0:	07800793          	li	a5,120
 6e4:	faf61ee3          	bne	a2,a5,6a0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e1fff0ef          	jal	514 <printint>
        i += 2;
 6fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bdc5                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 702:	008b8493          	addi	s1,s7,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000bb583          	ld	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	e05ff0ef          	jal	514 <printint>
        i += 2;
 714:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 716:	8ba6                	mv	s7,s1
      state = 0;
 718:	4981                	li	s3,0
        i += 2;
 71a:	bdd9                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 71c:	008b8493          	addi	s1,s7,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000be583          	lwu	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	debff0ef          	jal	514 <printint>
 72e:	8ba6                	mv	s7,s1
      state = 0;
 730:	4981                	li	s3,0
 732:	bd7d                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8493          	addi	s1,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000bb583          	ld	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	dd3ff0ef          	jal	514 <printint>
        i += 1;
 746:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
        i += 1;
 74c:	b555                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	008b8493          	addi	s1,s7,8
 752:	4681                	li	a3,0
 754:	4629                	li	a2,10
 756:	000bb583          	ld	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	db9ff0ef          	jal	514 <printint>
        i += 2;
 760:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 762:	8ba6                	mv	s7,s1
      state = 0;
 764:	4981                	li	s3,0
        i += 2;
 766:	b569                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 768:	008b8493          	addi	s1,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000be583          	lwu	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	d9fff0ef          	jal	514 <printint>
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bd8d                	j	5f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	008b8493          	addi	s1,s7,8
 784:	4681                	li	a3,0
 786:	4641                	li	a2,16
 788:	000bb583          	ld	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	d87ff0ef          	jal	514 <printint>
        i += 1;
 792:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
        i += 1;
 798:	bda1                	j	5f0 <vprintf+0x4a>
 79a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 79c:	008b8d13          	addi	s10,s7,8
 7a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a4:	03000593          	li	a1,48
 7a8:	855a                	mv	a0,s6
 7aa:	d4dff0ef          	jal	4f6 <putc>
  putc(fd, 'x');
 7ae:	07800593          	li	a1,120
 7b2:	855a                	mv	a0,s6
 7b4:	d43ff0ef          	jal	4f6 <putc>
 7b8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ba:	00000b97          	auipc	s7,0x0
 7be:	2b6b8b93          	addi	s7,s7,694 # a70 <digits>
 7c2:	03c9d793          	srli	a5,s3,0x3c
 7c6:	97de                	add	a5,a5,s7
 7c8:	0007c583          	lbu	a1,0(a5)
 7cc:	855a                	mv	a0,s6
 7ce:	d29ff0ef          	jal	4f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d2:	0992                	slli	s3,s3,0x4
 7d4:	34fd                	addiw	s1,s1,-1
 7d6:	f4f5                	bnez	s1,7c2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7d8:	8bea                	mv	s7,s10
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	6d02                	ld	s10,0(sp)
 7de:	bd09                	j	5f0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7e0:	008b8493          	addi	s1,s7,8
 7e4:	000bc583          	lbu	a1,0(s7)
 7e8:	855a                	mv	a0,s6
 7ea:	d0dff0ef          	jal	4f6 <putc>
 7ee:	8ba6                	mv	s7,s1
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bbfd                	j	5f0 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7f4:	008b8993          	addi	s3,s7,8
 7f8:	000bb483          	ld	s1,0(s7)
 7fc:	cc91                	beqz	s1,818 <vprintf+0x272>
        for (; *s; s++)
 7fe:	0004c583          	lbu	a1,0(s1)
 802:	c195                	beqz	a1,826 <vprintf+0x280>
          putc(fd, *s);
 804:	855a                	mv	a0,s6
 806:	cf1ff0ef          	jal	4f6 <putc>
        for (; *s; s++)
 80a:	0485                	addi	s1,s1,1
 80c:	0004c583          	lbu	a1,0(s1)
 810:	f9f5                	bnez	a1,804 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 812:	8bce                	mv	s7,s3
      state = 0;
 814:	4981                	li	s3,0
 816:	bbe9                	j	5f0 <vprintf+0x4a>
          s = "(null)";
 818:	00000497          	auipc	s1,0x0
 81c:	25048493          	addi	s1,s1,592 # a68 <malloc+0x140>
        for (; *s; s++)
 820:	02800593          	li	a1,40
 824:	b7c5                	j	804 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 826:	8bce                	mv	s7,s3
      state = 0;
 828:	4981                	li	s3,0
 82a:	b3d9                	j	5f0 <vprintf+0x4a>
 82c:	6906                	ld	s2,64(sp)
 82e:	79e2                	ld	s3,56(sp)
 830:	7a42                	ld	s4,48(sp)
 832:	7aa2                	ld	s5,40(sp)
 834:	7b02                	ld	s6,32(sp)
 836:	6be2                	ld	s7,24(sp)
 838:	6c42                	ld	s8,16(sp)
 83a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 83c:	60e6                	ld	ra,88(sp)
 83e:	6446                	ld	s0,80(sp)
 840:	64a6                	ld	s1,72(sp)
 842:	6125                	addi	sp,sp,96
 844:	8082                	ret

0000000000000846 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 846:	715d                	addi	sp,sp,-80
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e010                	sd	a2,0(s0)
 850:	e414                	sd	a3,8(s0)
 852:	e818                	sd	a4,16(s0)
 854:	ec1c                	sd	a5,24(s0)
 856:	03043023          	sd	a6,32(s0)
 85a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 85e:	8622                	mv	a2,s0
 860:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 864:	d43ff0ef          	jal	5a6 <vprintf>
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	6161                	addi	sp,sp,80
 86e:	8082                	ret

0000000000000870 <printf>:

void
printf(const char *fmt, ...)
{
 870:	711d                	addi	sp,sp,-96
 872:	ec06                	sd	ra,24(sp)
 874:	e822                	sd	s0,16(sp)
 876:	1000                	addi	s0,sp,32
 878:	e40c                	sd	a1,8(s0)
 87a:	e810                	sd	a2,16(s0)
 87c:	ec14                	sd	a3,24(s0)
 87e:	f018                	sd	a4,32(s0)
 880:	f41c                	sd	a5,40(s0)
 882:	03043823          	sd	a6,48(s0)
 886:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 88a:	00840613          	addi	a2,s0,8
 88e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 892:	85aa                	mv	a1,a0
 894:	4505                	li	a0,1
 896:	d11ff0ef          	jal	5a6 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6125                	addi	sp,sp,96
 8a0:	8082                	ret

00000000000008a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a2:	1141                	addi	sp,sp,-16
 8a4:	e406                	sd	ra,8(sp)
 8a6:	e022                	sd	s0,0(sp)
 8a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8aa:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	00000797          	auipc	a5,0x0
 8b2:	7527b783          	ld	a5,1874(a5) # 1000 <freep>
 8b6:	a02d                	j	8e0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 8b8:	4618                	lw	a4,8(a2)
 8ba:	9f2d                	addw	a4,a4,a1
 8bc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c0:	6398                	ld	a4,0(a5)
 8c2:	6310                	ld	a2,0(a4)
 8c4:	a83d                	j	902 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8c6:	ff852703          	lw	a4,-8(a0)
 8ca:	9f31                	addw	a4,a4,a2
 8cc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ce:	ff053683          	ld	a3,-16(a0)
 8d2:	a091                	j	916 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	6398                	ld	a4,0(a5)
 8d6:	00e7e463          	bltu	a5,a4,8de <free+0x3c>
 8da:	00e6ea63          	bltu	a3,a4,8ee <free+0x4c>
{
 8de:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	fed7fae3          	bgeu	a5,a3,8d4 <free+0x32>
 8e4:	6398                	ld	a4,0(a5)
 8e6:	00e6e463          	bltu	a3,a4,8ee <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ea:	fee7eae3          	bltu	a5,a4,8de <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 8ee:	ff852583          	lw	a1,-8(a0)
 8f2:	6390                	ld	a2,0(a5)
 8f4:	02059813          	slli	a6,a1,0x20
 8f8:	01c85713          	srli	a4,a6,0x1c
 8fc:	9736                	add	a4,a4,a3
 8fe:	fae60de3          	beq	a2,a4,8b8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 902:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 906:	4790                	lw	a2,8(a5)
 908:	02061593          	slli	a1,a2,0x20
 90c:	01c5d713          	srli	a4,a1,0x1c
 910:	973e                	add	a4,a4,a5
 912:	fae68ae3          	beq	a3,a4,8c6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 916:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 918:	00000717          	auipc	a4,0x0
 91c:	6ef73423          	sd	a5,1768(a4) # 1000 <freep>
}
 920:	60a2                	ld	ra,8(sp)
 922:	6402                	ld	s0,0(sp)
 924:	0141                	addi	sp,sp,16
 926:	8082                	ret

0000000000000928 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 928:	7139                	addi	sp,sp,-64
 92a:	fc06                	sd	ra,56(sp)
 92c:	f822                	sd	s0,48(sp)
 92e:	f04a                	sd	s2,32(sp)
 930:	ec4e                	sd	s3,24(sp)
 932:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 934:	02051993          	slli	s3,a0,0x20
 938:	0209d993          	srli	s3,s3,0x20
 93c:	09bd                	addi	s3,s3,15
 93e:	0049d993          	srli	s3,s3,0x4
 942:	2985                	addiw	s3,s3,1
 944:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 946:	00000517          	auipc	a0,0x0
 94a:	6ba53503          	ld	a0,1722(a0) # 1000 <freep>
 94e:	c905                	beqz	a0,97e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 950:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 952:	4798                	lw	a4,8(a5)
 954:	09377663          	bgeu	a4,s3,9e0 <malloc+0xb8>
 958:	f426                	sd	s1,40(sp)
 95a:	e852                	sd	s4,16(sp)
 95c:	e456                	sd	s5,8(sp)
 95e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 960:	8a4e                	mv	s4,s3
 962:	6705                	lui	a4,0x1
 964:	00e9f363          	bgeu	s3,a4,96a <malloc+0x42>
 968:	6a05                	lui	s4,0x1
 96a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 96e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 972:	00000497          	auipc	s1,0x0
 976:	68e48493          	addi	s1,s1,1678 # 1000 <freep>
  if (p == SBRK_ERROR)
 97a:	5afd                	li	s5,-1
 97c:	a83d                	j	9ba <malloc+0x92>
 97e:	f426                	sd	s1,40(sp)
 980:	e852                	sd	s4,16(sp)
 982:	e456                	sd	s5,8(sp)
 984:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 986:	00001797          	auipc	a5,0x1
 98a:	88278793          	addi	a5,a5,-1918 # 1208 <base>
 98e:	00000717          	auipc	a4,0x0
 992:	66f73923          	sd	a5,1650(a4) # 1000 <freep>
 996:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 998:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 99c:	b7d1                	j	960 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 99e:	6398                	ld	a4,0(a5)
 9a0:	e118                	sd	a4,0(a0)
 9a2:	a899                	j	9f8 <malloc+0xd0>
  hp->s.size = nu;
 9a4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9a8:	0541                	addi	a0,a0,16
 9aa:	ef9ff0ef          	jal	8a2 <free>
  return freep;
 9ae:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 9b0:	c125                	beqz	a0,a10 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9b2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9b4:	4798                	lw	a4,8(a5)
 9b6:	03277163          	bgeu	a4,s2,9d8 <malloc+0xb0>
    if (p == freep)
 9ba:	6098                	ld	a4,0(s1)
 9bc:	853e                	mv	a0,a5
 9be:	fef71ae3          	bne	a4,a5,9b2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9c2:	8552                	mv	a0,s4
 9c4:	9d3ff0ef          	jal	396 <sbrk>
  if (p == SBRK_ERROR)
 9c8:	fd551ee3          	bne	a0,s5,9a4 <malloc+0x7c>
        return 0;
 9cc:	4501                	li	a0,0
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
 9d6:	a03d                	j	a04 <malloc+0xdc>
 9d8:	74a2                	ld	s1,40(sp)
 9da:	6a42                	ld	s4,16(sp)
 9dc:	6aa2                	ld	s5,8(sp)
 9de:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9e0:	fae90fe3          	beq	s2,a4,99e <malloc+0x76>
        p->s.size -= nunits;
 9e4:	4137073b          	subw	a4,a4,s3
 9e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ea:	02071693          	slli	a3,a4,0x20
 9ee:	01c6d713          	srli	a4,a3,0x1c
 9f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f8:	00000717          	auipc	a4,0x0
 9fc:	60a73423          	sd	a0,1544(a4) # 1000 <freep>
      return (void *)(p + 1);
 a00:	01078513          	addi	a0,a5,16
  }
}
 a04:	70e2                	ld	ra,56(sp)
 a06:	7442                	ld	s0,48(sp)
 a08:	7902                	ld	s2,32(sp)
 a0a:	69e2                	ld	s3,24(sp)
 a0c:	6121                	addi	sp,sp,64
 a0e:	8082                	ret
 a10:	74a2                	ld	s1,40(sp)
 a12:	6a42                	ld	s4,16(sp)
 a14:	6aa2                	ld	s5,8(sp)
 a16:	6b02                	ld	s6,0(sp)
 a18:	b7f5                	j	a04 <malloc+0xdc>
