
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ = 2000 };

  for (int i = 1; i < argc; i++) {
   0:	4785                	li	a5,1
   2:	0ea7df63          	bge	a5,a0,100 <main+0x100>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	0080                	addi	s0,sp,64
  14:	892a                	mv	s2,a0
  16:	89ae                	mv	s3,a1
  for (int i = 1; i < argc; i++) {
  18:	4485                	li	s1,1
  1a:	a011                	j	1e <main+0x1e>
  1c:	84be                	mv	s1,a5
    int pid1 = fork();
  1e:	372000ef          	jal	390 <fork>
    if (pid1 < 0) {
  22:	00054963          	bltz	a0,34 <main+0x34>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if (pid1 == 0) {
  26:	c11d                	beqz	a0,4c <main+0x4c>
  for (int i = 1; i < argc; i++) {
  28:	0014879b          	addiw	a5,s1,1
  2c:	fef918e3          	bne	s2,a5,1c <main+0x1c>
      }
      exit(0);
    }
  }
  int xstatus;
  for (int i = 1; i < argc; i++) {
  30:	4905                	li	s2,1
  32:	a04d                	j	d4 <main+0xd4>
  34:	e852                	sd	s4,16(sp)
      printf("%s: fork failed\n", argv[0]);
  36:	0009b583          	ld	a1,0(s3)
  3a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  3e:	9d650513          	addi	a0,a0,-1578 # a10 <malloc+0xfc>
  42:	01f000ef          	jal	860 <printf>
=======
  3e:	9f650513          	addi	a0,a0,-1546 # a30 <malloc+0xfe>
  42:	03d000ef          	jal	87e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
      exit(1);
  46:	4505                	li	a0,1
  48:	350000ef          	jal	398 <exit>
  4c:	e852                	sd	s4,16(sp)
      fd = open(argv[i], O_CREATE | O_RDWR);
  4e:	00349a13          	slli	s4,s1,0x3
  52:	9a4e                	add	s4,s4,s3
  54:	20200593          	li	a1,514
  58:	000a3503          	ld	a0,0(s4)
  5c:	37c000ef          	jal	3d8 <open>
  60:	892a                	mv	s2,a0
      if (fd < 0) {
  62:	04054163          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0' + i, SZ);
  66:	7d000613          	li	a2,2000
  6a:	0304859b          	addiw	a1,s1,48
  6e:	00001517          	auipc	a0,0x1
  72:	fa250513          	addi	a0,a0,-94 # 1010 <buf>
  76:	110000ef          	jal	186 <memset>
  7a:	0fa00493          	li	s1,250
        if ((n = write(fd, buf, SZ)) != SZ) {
  7e:	00001997          	auipc	s3,0x1
  82:	f9298993          	addi	s3,s3,-110 # 1010 <buf>
  86:	7d000613          	li	a2,2000
  8a:	85ce                	mv	a1,s3
  8c:	854a                	mv	a0,s2
  8e:	32a000ef          	jal	3b8 <write>
  92:	7d000793          	li	a5,2000
  96:	02f51463          	bne	a0,a5,be <main+0xbe>
      for (i = 0; i < N; i++) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f4ed                	bnez	s1,86 <main+0x86>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	2f8000ef          	jal	398 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	000a3603          	ld	a2,0(s4)
  a8:	0009b583          	ld	a1,0(s3)
  ac:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  b0:	97c50513          	addi	a0,a0,-1668 # a28 <malloc+0x114>
  b4:	7ac000ef          	jal	860 <printf>
=======
  b0:	99c50513          	addi	a0,a0,-1636 # a48 <malloc+0x116>
  b4:	7ca000ef          	jal	87e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2de000ef          	jal	398 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  c4:	98050513          	addi	a0,a0,-1664 # a40 <malloc+0x12c>
  c8:	798000ef          	jal	860 <printf>
=======
  c4:	9a050513          	addi	a0,a0,-1632 # a60 <malloc+0x12e>
  c8:	7b6000ef          	jal	87e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ca000ef          	jal	398 <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	fcc40513          	addi	a0,s0,-52
  d8:	2c8000ef          	jal	3a0 <wait>
    if (xstatus != 0)
  dc:	fcc42503          	lw	a0,-52(s0)
  e0:	ed09                	bnez	a0,fa <main+0xfa>
  for (int i = 1; i < argc; i++) {
  e2:	0019079b          	addiw	a5,s2,1
  e6:	ff2496e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  ea:	4501                	li	a0,0
  ec:	70e2                	ld	ra,56(sp)
  ee:	7442                	ld	s0,48(sp)
  f0:	74a2                	ld	s1,40(sp)
  f2:	7902                	ld	s2,32(sp)
  f4:	69e2                	ld	s3,24(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
  fa:	e852                	sd	s4,16(sp)
      exit(xstatus);
  fc:	29c000ef          	jal	398 <exit>
}
 100:	4501                	li	a0,0
 102:	8082                	ret

0000000000000104 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10c:	ef5ff0ef          	jal	0 <main>
  exit(r);
 110:	288000ef          	jal	398 <exit>

0000000000000114 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0x8>
    ;
  return os;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb91                	beqz	a5,14e <strcmp+0x1e>
 13c:	0005c703          	lbu	a4,0(a1)
 140:	00f71763          	bne	a4,a5,14e <strcmp+0x1e>
    p++, q++;
 144:	0505                	addi	a0,a0,1
 146:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbe5                	bnez	a5,13c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14e:	0005c503          	lbu	a0,0(a1)
}
 152:	40a7853b          	subw	a0,a5,a0
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf91                	beqz	a5,182 <strlen+0x26>
 168:	0505                	addi	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	86be                	mv	a3,a5
 16e:	0785                	addi	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	ff65                	bnez	a4,16c <strlen+0x10>
 176:	40a6853b          	subw	a0,a3,a0
 17a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  for (n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strlen+0x20>

0000000000000186 <memset>:

void *
memset(void *dst, int c, uint n)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18c:	ca19                	beqz	a2,1a2 <memset+0x1c>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x12>
  }
  return dst;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char *
strchr(const char *s, char c)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb99                	beqz	a5,1c8 <strchr+0x20>
    if (*s == c)
 1b4:	00f58763          	beq	a1,a5,1c2 <strchr+0x1a>
  for (; *s; s++)
 1b8:	0505                	addi	a0,a0,1
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbfd                	bnez	a5,1b4 <strchr+0xc>
      return (char *)s;
  return 0;
 1c0:	4501                	li	a0,0
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfe5                	j	1c2 <strchr+0x1a>

00000000000001cc <gets>:

char *
gets(char *buf, int max)
{
 1cc:	711d                	addi	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	1080                	addi	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1ea:	4aa9                	li	s5,10
 1ec:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1ee:	89a6                	mv	s3,s1
 1f0:	2485                	addiw	s1,s1,1
 1f2:	0344d663          	bge	s1,s4,21e <gets+0x52>
    cc = read(0, &c, 1);
 1f6:	4605                	li	a2,1
 1f8:	faf40593          	addi	a1,s0,-81
 1fc:	4501                	li	a0,0
 1fe:	1b2000ef          	jal	3b0 <read>
    if (cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x52>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x50>
 212:	0905                	addi	s2,s2,1
 214:	fd679de3          	bne	a5,s6,1ee <gets+0x22>
    buf[i++] = c;
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x52>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e04a                	sd	s2,0(sp)
 244:	1000                	addi	s0,sp,32
 246:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	4581                	li	a1,0
 24a:	18e000ef          	jal	3d8 <open>
  if (fd < 0)
 24e:	02054263          	bltz	a0,272 <stat+0x36>
 252:	e426                	sd	s1,8(sp)
 254:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 256:	85ca                	mv	a1,s2
 258:	198000ef          	jal	3f0 <fstat>
 25c:	892a                	mv	s2,a0
  close(fd);
 25e:	8526                	mv	a0,s1
 260:	160000ef          	jal	3c0 <close>
  return r;
 264:	64a2                	ld	s1,8(sp)
}
 266:	854a                	mv	a0,s2
 268:	60e2                	ld	ra,24(sp)
 26a:	6442                	ld	s0,16(sp)
 26c:	6902                	ld	s2,0(sp)
 26e:	6105                	addi	sp,sp,32
 270:	8082                	ret
    return -1;
 272:	597d                	li	s2,-1
 274:	bfcd                	j	266 <stat+0x2a>

0000000000000276 <atoi>:

int
atoi(const char *s)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 27c:	00054683          	lbu	a3,0(a0)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	4625                	li	a2,9
 28a:	02f66863          	bltu	a2,a5,2ba <atoi+0x44>
 28e:	872a                	mv	a4,a0
  n = 0;
 290:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 292:	0705                	addi	a4,a4,1
 294:	0025179b          	slliw	a5,a0,0x2
 298:	9fa9                	addw	a5,a5,a0
 29a:	0017979b          	slliw	a5,a5,0x1
 29e:	9fb5                	addw	a5,a5,a3
 2a0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2a4:	00074683          	lbu	a3,0(a4)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	fef671e3          	bgeu	a2,a5,292 <atoi+0x1c>
  return n;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
  n = 0;
 2ba:	4501                	li	a0,0
 2bc:	bfe5                	j	2b4 <atoi+0x3e>

00000000000002be <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c4:	02b57463          	bgeu	a0,a1,2ec <memmove+0x2e>
    while (n-- > 0)
 2c8:	00c05f63          	blez	a2,2e6 <memmove+0x28>
 2cc:	1602                	slli	a2,a2,0x20
 2ce:	9201                	srli	a2,a2,0x20
 2d0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d6:	0585                	addi	a1,a1,1
 2d8:	0705                	addi	a4,a4,1
 2da:	fff5c683          	lbu	a3,-1(a1)
 2de:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2e2:	fef71ae3          	bne	a4,a5,2d6 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
    dst += n;
 2ec:	00c50733          	add	a4,a0,a2
    src += n;
 2f0:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2f2:	fec05ae3          	blez	a2,2e6 <memmove+0x28>
 2f6:	fff6079b          	addiw	a5,a2,-1
 2fa:	1782                	slli	a5,a5,0x20
 2fc:	9381                	srli	a5,a5,0x20
 2fe:	fff7c793          	not	a5,a5
 302:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 304:	15fd                	addi	a1,a1,-1
 306:	177d                	addi	a4,a4,-1
 308:	0005c683          	lbu	a3,0(a1)
 30c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 310:	fee79ae3          	bne	a5,a4,304 <memmove+0x46>
 314:	bfc9                	j	2e6 <memmove+0x28>

0000000000000316 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31c:	ca05                	beqz	a2,34c <memcmp+0x36>
 31e:	fff6069b          	addiw	a3,a2,-1
 322:	1682                	slli	a3,a3,0x20
 324:	9281                	srli	a3,a3,0x20
 326:	0685                	addi	a3,a3,1
 328:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32a:	00054783          	lbu	a5,0(a0)
 32e:	0005c703          	lbu	a4,0(a1)
 332:	00e79863          	bne	a5,a4,342 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 336:	0505                	addi	a0,a0,1
    p2++;
 338:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33a:	fed518e3          	bne	a0,a3,32a <memcmp+0x14>
  }
  return 0;
 33e:	4501                	li	a0,0
 340:	a019                	j	346 <memcmp+0x30>
      return *p1 - *p2;
 342:	40e7853b          	subw	a0,a5,a4
}
 346:	6422                	ld	s0,8(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
  return 0;
 34c:	4501                	li	a0,0
 34e:	bfe5                	j	346 <memcmp+0x30>

0000000000000350 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 358:	f67ff0ef          	jal	2be <memmove>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <sbrk>:

char *
sbrk(int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 36c:	4585                	li	a1,1
 36e:	0b2000ef          	jal	420 <sys_sbrk>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <sbrklazy>:

char *
sbrklazy(int n)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e406                	sd	ra,8(sp)
 37e:	e022                	sd	s0,0(sp)
 380:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 382:	4589                	li	a1,2
 384:	09c000ef          	jal	420 <sys_sbrk>
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 390:	4885                	li	a7,1
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exit>:
.global exit
exit:
 li a7, SYS_exit
 398:	4889                	li	a7,2
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a0:	488d                	li	a7,3
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a8:	4891                	li	a7,4
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <read>:
.global read
read:
 li a7, SYS_read
 3b0:	4895                	li	a7,5
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48d5                	li	a7,21
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c8:	4899                	li	a7,6
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d0:	489d                	li	a7,7
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <open>:
.global open
open:
 li a7, SYS_open
 3d8:	48bd                	li	a7,15
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e0:	48c5                	li	a7,17
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e8:	48c9                	li	a7,18
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <link>:
.global link
link:
 li a7, SYS_link
 3f8:	48cd                	li	a7,19
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 400:	48d1                	li	a7,20
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 408:	48a5                	li	a7,9
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <dup>:
.global dup
dup:
 li a7, SYS_dup
 410:	48a9                	li	a7,10
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 418:	48ad                	li	a7,11
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 420:	48b1                	li	a7,12
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <pause>:
.global pause
pause:
 li a7, SYS_pause
 428:	48b5                	li	a7,13
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 430:	48b9                	li	a7,14
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sync>:
.global sync
sync:
 li a7, SYS_sync
 438:	48d9                	li	a7,22
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <ps>:
.global ps
ps:
 li a7, SYS_ps
 440:	48dd                	li	a7,23
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 448:	48e1                	li	a7,24
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 450:	48e5                	li	a7,25
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 458:	48e9                	li	a7,26
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <trace>:
.global trace
trace:
 li a7, SYS_trace
 460:	48ed                	li	a7,27
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 468:	48f1                	li	a7,28
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 470:	48f5                	li	a7,29
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 478:	48f9                	li	a7,30
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 480:	48fd                	li	a7,31
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 488:	02000893          	li	a7,32
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <halt>:
.global halt
halt:
 li a7, SYS_halt
 492:	02100893          	li	a7,33
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 49c:	02200893          	li	a7,34
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 4a6:	02300893          	li	a7,35
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 4b0:	02400893          	li	a7,36
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 4ba:	02500893          	li	a7,37
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 4c4:	02600893          	li	a7,38
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 4ce:	02700893          	li	a7,39
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

<<<<<<< HEAD
00000000000004d8 <putc>:
=======
00000000000004d8 <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 4d8:	02800893          	li	a7,40
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 4e2:	02900893          	li	a7,41
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 4ec:	02a00893          	li	a7,42
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d8:	1101                	addi	sp,sp,-32
 4da:	ec06                	sd	ra,24(sp)
 4dc:	e822                	sd	s0,16(sp)
 4de:	1000                	addi	s0,sp,32
 4e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
<<<<<<< HEAD
 4e4:	4605                	li	a2,1
 4e6:	fef40593          	addi	a1,s0,-17
 4ea:	ecfff0ef          	jal	3b8 <write>
=======
 502:	4605                	li	a2,1
 504:	fef40593          	addi	a1,s0,-17
 508:	eb1ff0ef          	jal	3b8 <write>
>>>>>>> e18456e (Updated xv6-riscv)
}
 4ee:	60e2                	ld	ra,24(sp)
 4f0:	6442                	ld	s0,16(sp)
 4f2:	6105                	addi	sp,sp,32
 4f4:	8082                	ret

00000000000004f6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 4f6:	715d                	addi	sp,sp,-80
 4f8:	e486                	sd	ra,72(sp)
 4fa:	e0a2                	sd	s0,64(sp)
 4fc:	f84a                	sd	s2,48(sp)
 4fe:	0880                	addi	s0,sp,80
 500:	892a                	mv	s2,a0
=======
 514:	715d                	addi	sp,sp,-80
 516:	e486                	sd	ra,72(sp)
 518:	e0a2                	sd	s0,64(sp)
 51a:	f84a                	sd	s2,48(sp)
 51c:	0880                	addi	s0,sp,80
 51e:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 502:	c299                	beqz	a3,508 <printint+0x12>
 504:	0805c363          	bltz	a1,58a <printint+0x94>
  neg = 0;
 508:	4881                	li	a7,0
 50a:	fb840693          	addi	a3,s0,-72
=======
 520:	c299                	beqz	a3,526 <printint+0x12>
 522:	0805c363          	bltz	a1,5a8 <printint+0x94>
  neg = 0;
 526:	4881                	li	a7,0
 528:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 50e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 510:	00000517          	auipc	a0,0x0
 514:	55050513          	addi	a0,a0,1360 # a60 <digits>
 518:	883e                	mv	a6,a5
 51a:	2785                	addiw	a5,a5,1
 51c:	02c5f733          	remu	a4,a1,a2
 520:	972a                	add	a4,a4,a0
 522:	00074703          	lbu	a4,0(a4)
 526:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 52a:	872e                	mv	a4,a1
 52c:	02c5d5b3          	divu	a1,a1,a2
 530:	0685                	addi	a3,a3,1
 532:	fec773e3          	bgeu	a4,a2,518 <printint+0x22>
  if (neg)
 536:	00088b63          	beqz	a7,54c <printint+0x56>
    buf[i++] = '-';
 53a:	fd078793          	addi	a5,a5,-48
 53e:	97a2                	add	a5,a5,s0
 540:	02d00713          	li	a4,45
 544:	fee78423          	sb	a4,-24(a5)
 548:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 54c:	02f05a63          	blez	a5,580 <printint+0x8a>
 550:	fc26                	sd	s1,56(sp)
 552:	f44e                	sd	s3,40(sp)
 554:	fb840713          	addi	a4,s0,-72
 558:	00f704b3          	add	s1,a4,a5
 55c:	fff70993          	addi	s3,a4,-1
 560:	99be                	add	s3,s3,a5
 562:	37fd                	addiw	a5,a5,-1
 564:	1782                	slli	a5,a5,0x20
 566:	9381                	srli	a5,a5,0x20
 568:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 56c:	fff4c583          	lbu	a1,-1(s1)
 570:	854a                	mv	a0,s2
 572:	f67ff0ef          	jal	4d8 <putc>
  while (--i >= 0)
 576:	14fd                	addi	s1,s1,-1
 578:	ff349ae3          	bne	s1,s3,56c <printint+0x76>
 57c:	74e2                	ld	s1,56(sp)
 57e:	79a2                	ld	s3,40(sp)
}
 580:	60a6                	ld	ra,72(sp)
 582:	6406                	ld	s0,64(sp)
 584:	7942                	ld	s2,48(sp)
 586:	6161                	addi	sp,sp,80
 588:	8082                	ret
    x = -xx;
 58a:	40b005b3          	neg	a1,a1
    neg = 1;
 58e:	4885                	li	a7,1
    x = -xx;
 590:	bfad                	j	50a <printint+0x14>

0000000000000592 <vprintf>:
=======
 52c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 52e:	00000517          	auipc	a0,0x0
 532:	55250513          	addi	a0,a0,1362 # a80 <digits>
 536:	883e                	mv	a6,a5
 538:	2785                	addiw	a5,a5,1
 53a:	02c5f733          	remu	a4,a1,a2
 53e:	972a                	add	a4,a4,a0
 540:	00074703          	lbu	a4,0(a4)
 544:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 548:	872e                	mv	a4,a1
 54a:	02c5d5b3          	divu	a1,a1,a2
 54e:	0685                	addi	a3,a3,1
 550:	fec773e3          	bgeu	a4,a2,536 <printint+0x22>
  if (neg)
 554:	00088b63          	beqz	a7,56a <printint+0x56>
    buf[i++] = '-';
 558:	fd078793          	addi	a5,a5,-48
 55c:	97a2                	add	a5,a5,s0
 55e:	02d00713          	li	a4,45
 562:	fee78423          	sb	a4,-24(a5)
 566:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 56a:	02f05a63          	blez	a5,59e <printint+0x8a>
 56e:	fc26                	sd	s1,56(sp)
 570:	f44e                	sd	s3,40(sp)
 572:	fb840713          	addi	a4,s0,-72
 576:	00f704b3          	add	s1,a4,a5
 57a:	fff70993          	addi	s3,a4,-1
 57e:	99be                	add	s3,s3,a5
 580:	37fd                	addiw	a5,a5,-1
 582:	1782                	slli	a5,a5,0x20
 584:	9381                	srli	a5,a5,0x20
 586:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 58a:	fff4c583          	lbu	a1,-1(s1)
 58e:	854a                	mv	a0,s2
 590:	f67ff0ef          	jal	4f6 <putc>
  while (--i >= 0)
 594:	14fd                	addi	s1,s1,-1
 596:	ff349ae3          	bne	s1,s3,58a <printint+0x76>
 59a:	74e2                	ld	s1,56(sp)
 59c:	79a2                	ld	s3,40(sp)
}
 59e:	60a6                	ld	ra,72(sp)
 5a0:	6406                	ld	s0,64(sp)
 5a2:	7942                	ld	s2,48(sp)
 5a4:	6161                	addi	sp,sp,80
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005b3          	neg	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bfad                	j	528 <printint+0x14>

00000000000005b0 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 592:	711d                	addi	sp,sp,-96
 594:	ec86                	sd	ra,88(sp)
 596:	e8a2                	sd	s0,80(sp)
 598:	e0ca                	sd	s2,64(sp)
 59a:	1080                	addi	s0,sp,96
=======
 5b0:	711d                	addi	sp,sp,-96
 5b2:	ec86                	sd	ra,88(sp)
 5b4:	e8a2                	sd	s0,80(sp)
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 59c:	0005c903          	lbu	s2,0(a1)
 5a0:	28090663          	beqz	s2,82c <vprintf+0x29a>
 5a4:	e4a6                	sd	s1,72(sp)
 5a6:	fc4e                	sd	s3,56(sp)
 5a8:	f852                	sd	s4,48(sp)
 5aa:	f456                	sd	s5,40(sp)
 5ac:	f05a                	sd	s6,32(sp)
 5ae:	ec5e                	sd	s7,24(sp)
 5b0:	e862                	sd	s8,16(sp)
 5b2:	e466                	sd	s9,8(sp)
 5b4:	8b2a                	mv	s6,a0
 5b6:	8a2e                	mv	s4,a1
 5b8:	8bb2                	mv	s7,a2
  state = 0;
 5ba:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5bc:	4481                	li	s1,0
 5be:	4701                	li	a4,0
=======
 5ba:	0005c903          	lbu	s2,0(a1)
 5be:	28090663          	beqz	s2,84a <vprintf+0x29a>
 5c2:	e4a6                	sd	s1,72(sp)
 5c4:	fc4e                	sd	s3,56(sp)
 5c6:	f852                	sd	s4,48(sp)
 5c8:	f456                	sd	s5,40(sp)
 5ca:	f05a                	sd	s6,32(sp)
 5cc:	ec5e                	sd	s7,24(sp)
 5ce:	e862                	sd	s8,16(sp)
 5d0:	e466                	sd	s9,8(sp)
 5d2:	8b2a                	mv	s6,a0
 5d4:	8a2e                	mv	s4,a1
 5d6:	8bb2                	mv	s7,a2
  state = 0;
 5d8:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5da:	4481                	li	s1,0
 5dc:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 5c0:	02500a93          	li	s5,37
=======
 5de:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 5c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5c8:	06c00c93          	li	s9,108
 5cc:	a005                	j	5ec <vprintf+0x5a>
        putc(fd, c0);
 5ce:	85ca                	mv	a1,s2
 5d0:	855a                	mv	a0,s6
 5d2:	f07ff0ef          	jal	4d8 <putc>
 5d6:	a019                	j	5dc <vprintf+0x4a>
    } else if (state == '%') {
 5d8:	03598263          	beq	s3,s5,5fc <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5dc:	2485                	addiw	s1,s1,1
 5de:	8726                	mv	a4,s1
 5e0:	009a07b3          	add	a5,s4,s1
 5e4:	0007c903          	lbu	s2,0(a5)
 5e8:	22090a63          	beqz	s2,81c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5ec:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5f0:	fe0994e3          	bnez	s3,5d8 <vprintf+0x46>
      if (c0 == '%') {
 5f4:	fd579de3          	bne	a5,s5,5ce <vprintf+0x3c>
        state = '%';
 5f8:	89be                	mv	s3,a5
 5fa:	b7cd                	j	5dc <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5fc:	00ea06b3          	add	a3,s4,a4
 600:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 604:	8636                	mv	a2,a3
      if (c1)
 606:	c681                	beqz	a3,60e <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 608:	9752                	add	a4,a4,s4
 60a:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 60e:	05878363          	beq	a5,s8,654 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 612:	05978d63          	beq	a5,s9,66c <vprintf+0xda>
=======
 5e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5e6:	06c00c93          	li	s9,108
 5ea:	a005                	j	60a <vprintf+0x5a>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	f07ff0ef          	jal	4f6 <putc>
 5f4:	a019                	j	5fa <vprintf+0x4a>
    } else if (state == '%') {
 5f6:	03598263          	beq	s3,s5,61a <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5fa:	2485                	addiw	s1,s1,1
 5fc:	8726                	mv	a4,s1
 5fe:	009a07b3          	add	a5,s4,s1
 602:	0007c903          	lbu	s2,0(a5)
 606:	22090a63          	beqz	s2,83a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 60a:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 60e:	fe0994e3          	bnez	s3,5f6 <vprintf+0x46>
      if (c0 == '%') {
 612:	fd579de3          	bne	a5,s5,5ec <vprintf+0x3c>
        state = '%';
 616:	89be                	mv	s3,a5
 618:	b7cd                	j	5fa <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 61a:	00ea06b3          	add	a3,s4,a4
 61e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 622:	8636                	mv	a2,a3
      if (c1)
 624:	c681                	beqz	a3,62c <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 626:	9752                	add	a4,a4,s4
 628:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 62c:	05878363          	beq	a5,s8,672 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 630:	05978d63          	beq	a5,s9,68a <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 616:	07500713          	li	a4,117
 61a:	0ee78763          	beq	a5,a4,708 <vprintf+0x176>
=======
 634:	07500713          	li	a4,117
 638:	0ee78763          	beq	a5,a4,726 <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 61e:	07800713          	li	a4,120
 622:	12e78963          	beq	a5,a4,754 <vprintf+0x1c2>
=======
 63c:	07800713          	li	a4,120
 640:	12e78963          	beq	a5,a4,772 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 626:	07000713          	li	a4,112
 62a:	14e78e63          	beq	a5,a4,786 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 62e:	06300713          	li	a4,99
 632:	18e78e63          	beq	a5,a4,7ce <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 636:	07300713          	li	a4,115
 63a:	1ae78463          	beq	a5,a4,7e2 <vprintf+0x250>
=======
 644:	07000713          	li	a4,112
 648:	14e78e63          	beq	a5,a4,7a4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 64c:	06300713          	li	a4,99
 650:	18e78e63          	beq	a5,a4,7ec <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 654:	07300713          	li	a4,115
 658:	1ae78463          	beq	a5,a4,800 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 63e:	02500713          	li	a4,37
 642:	04e79563          	bne	a5,a4,68c <vprintf+0xfa>
        putc(fd, '%');
 646:	02500593          	li	a1,37
 64a:	855a                	mv	a0,s6
 64c:	e8dff0ef          	jal	4d8 <putc>
=======
 65c:	02500713          	li	a4,37
 660:	04e79563          	bne	a5,a4,6aa <vprintf+0xfa>
        putc(fd, '%');
 664:	02500593          	li	a1,37
 668:	855a                	mv	a0,s6
 66a:	e8dff0ef          	jal	4f6 <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 650:	4981                	li	s3,0
 652:	b769                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 654:	008b8913          	addi	s2,s7,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000ba583          	lw	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e95ff0ef          	jal	4f6 <printint>
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
 66a:	bf8d                	j	5dc <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 66c:	06400793          	li	a5,100
 670:	02f68963          	beq	a3,a5,6a2 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 674:	06c00793          	li	a5,108
 678:	04f68263          	beq	a3,a5,6bc <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 67c:	07500793          	li	a5,117
 680:	0af68063          	beq	a3,a5,720 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 684:	07800793          	li	a5,120
 688:	0ef68263          	beq	a3,a5,76c <vprintf+0x1da>
        putc(fd, '%');
 68c:	02500593          	li	a1,37
 690:	855a                	mv	a0,s6
 692:	e47ff0ef          	jal	4d8 <putc>
        putc(fd, c0);
 696:	85ca                	mv	a1,s2
 698:	855a                	mv	a0,s6
 69a:	e3fff0ef          	jal	4d8 <putc>
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bf35                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4685                	li	a3,1
 6a8:	4629                	li	a2,10
 6aa:	000bb583          	ld	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	e47ff0ef          	jal	4f6 <printint>
        i += 1;
 6b4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
        i += 1;
 6ba:	b70d                	j	5dc <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6bc:	06400793          	li	a5,100
 6c0:	02f60763          	beq	a2,a5,6ee <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6c4:	07500793          	li	a5,117
 6c8:	06f60963          	beq	a2,a5,73a <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6cc:	07800793          	li	a5,120
 6d0:	faf61ee3          	bne	a2,a5,68c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	e15ff0ef          	jal	4f6 <printint>
        i += 2;
 6e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	bdc5                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000bb583          	ld	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	dfbff0ef          	jal	4f6 <printint>
        i += 2;
 700:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
        i += 2;
 706:	bdd9                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 708:	008b8913          	addi	s2,s7,8
 70c:	4681                	li	a3,0
 70e:	4629                	li	a2,10
 710:	000be583          	lwu	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	de1ff0ef          	jal	4f6 <printint>
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bd7d                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000bb583          	ld	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	dc9ff0ef          	jal	4f6 <printint>
        i += 1;
 732:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 1;
 738:	b555                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000bb583          	ld	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	dafff0ef          	jal	4f6 <printint>
        i += 2;
 74c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
        i += 2;
 752:	b569                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 754:	008b8913          	addi	s2,s7,8
 758:	4681                	li	a3,0
 75a:	4641                	li	a2,16
 75c:	000be583          	lwu	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	d95ff0ef          	jal	4f6 <printint>
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bd8d                	j	5dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 76c:	008b8913          	addi	s2,s7,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000bb583          	ld	a1,0(s7)
 778:	855a                	mv	a0,s6
 77a:	d7dff0ef          	jal	4f6 <printint>
        i += 1;
 77e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 1;
 784:	bda1                	j	5dc <vprintf+0x4a>
 786:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 788:	008b8d13          	addi	s10,s7,8
 78c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 790:	03000593          	li	a1,48
 794:	855a                	mv	a0,s6
 796:	d43ff0ef          	jal	4d8 <putc>
  putc(fd, 'x');
 79a:	07800593          	li	a1,120
 79e:	855a                	mv	a0,s6
 7a0:	d39ff0ef          	jal	4d8 <putc>
 7a4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a6:	00000b97          	auipc	s7,0x0
 7aa:	2bab8b93          	addi	s7,s7,698 # a60 <digits>
 7ae:	03c9d793          	srli	a5,s3,0x3c
 7b2:	97de                	add	a5,a5,s7
 7b4:	0007c583          	lbu	a1,0(a5)
 7b8:	855a                	mv	a0,s6
 7ba:	d1fff0ef          	jal	4d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7be:	0992                	slli	s3,s3,0x4
 7c0:	397d                	addiw	s2,s2,-1
 7c2:	fe0916e3          	bnez	s2,7ae <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7c6:	8bea                	mv	s7,s10
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	6d02                	ld	s10,0(sp)
 7cc:	bd01                	j	5dc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	000bc583          	lbu	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	d01ff0ef          	jal	4d8 <putc>
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bbf5                	j	5dc <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7e2:	008b8993          	addi	s3,s7,8
 7e6:	000bb903          	ld	s2,0(s7)
 7ea:	00090f63          	beqz	s2,808 <vprintf+0x276>
        for (; *s; s++)
 7ee:	00094583          	lbu	a1,0(s2)
 7f2:	c195                	beqz	a1,816 <vprintf+0x284>
          putc(fd, *s);
 7f4:	855a                	mv	a0,s6
 7f6:	ce3ff0ef          	jal	4d8 <putc>
        for (; *s; s++)
 7fa:	0905                	addi	s2,s2,1
 7fc:	00094583          	lbu	a1,0(s2)
 800:	f9f5                	bnez	a1,7f4 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 802:	8bce                	mv	s7,s3
      state = 0;
 804:	4981                	li	s3,0
 806:	bbd9                	j	5dc <vprintf+0x4a>
          s = "(null)";
 808:	00000917          	auipc	s2,0x0
 80c:	25090913          	addi	s2,s2,592 # a58 <malloc+0x144>
        for (; *s; s++)
 810:	02800593          	li	a1,40
 814:	b7c5                	j	7f4 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	b3c9                	j	5dc <vprintf+0x4a>
 81c:	64a6                	ld	s1,72(sp)
 81e:	79e2                	ld	s3,56(sp)
 820:	7a42                	ld	s4,48(sp)
 822:	7aa2                	ld	s5,40(sp)
 824:	7b02                	ld	s6,32(sp)
 826:	6be2                	ld	s7,24(sp)
 828:	6c42                	ld	s8,16(sp)
 82a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 82c:	60e6                	ld	ra,88(sp)
 82e:	6446                	ld	s0,80(sp)
 830:	6906                	ld	s2,64(sp)
 832:	6125                	addi	sp,sp,96
 834:	8082                	ret

0000000000000836 <fprintf>:
=======
 66e:	4981                	li	s3,0
 670:	b769                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 672:	008b8913          	addi	s2,s7,8
 676:	4685                	li	a3,1
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e95ff0ef          	jal	514 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bf8d                	j	5fa <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 68a:	06400793          	li	a5,100
 68e:	02f68963          	beq	a3,a5,6c0 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 692:	06c00793          	li	a5,108
 696:	04f68263          	beq	a3,a5,6da <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 69a:	07500793          	li	a5,117
 69e:	0af68063          	beq	a3,a5,73e <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 6a2:	07800793          	li	a5,120
 6a6:	0ef68263          	beq	a3,a5,78a <vprintf+0x1da>
        putc(fd, '%');
 6aa:	02500593          	li	a1,37
 6ae:	855a                	mv	a0,s6
 6b0:	e47ff0ef          	jal	4f6 <putc>
        putc(fd, c0);
 6b4:	85ca                	mv	a1,s2
 6b6:	855a                	mv	a0,s6
 6b8:	e3fff0ef          	jal	4f6 <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bf35                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	e47ff0ef          	jal	514 <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	b70d                	j	5fa <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6da:	06400793          	li	a5,100
 6de:	02f60763          	beq	a2,a5,70c <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6e2:	07500793          	li	a5,117
 6e6:	06f60963          	beq	a2,a5,758 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6ea:	07800793          	li	a5,120
 6ee:	faf61ee3          	bne	a2,a5,6aa <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e15ff0ef          	jal	514 <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	bdc5                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	008b8913          	addi	s2,s7,8
 710:	4685                	li	a3,1
 712:	4629                	li	a2,10
 714:	000bb583          	ld	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	dfbff0ef          	jal	514 <printint>
        i += 2;
 71e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	bdd9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4629                	li	a2,10
 72e:	000be583          	lwu	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	de1ff0ef          	jal	514 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bd7d                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000bb583          	ld	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	dc9ff0ef          	jal	514 <printint>
        i += 1;
 750:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 1;
 756:	b555                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000bb583          	ld	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	dafff0ef          	jal	514 <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	b569                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000be583          	lwu	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	d95ff0ef          	jal	514 <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	bd8d                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000bb583          	ld	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d7dff0ef          	jal	514 <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	bda1                	j	5fa <vprintf+0x4a>
 7a4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a6:	008b8d13          	addi	s10,s7,8
 7aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ae:	03000593          	li	a1,48
 7b2:	855a                	mv	a0,s6
 7b4:	d43ff0ef          	jal	4f6 <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	855a                	mv	a0,s6
 7be:	d39ff0ef          	jal	4f6 <putc>
 7c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c4:	00000b97          	auipc	s7,0x0
 7c8:	2bcb8b93          	addi	s7,s7,700 # a80 <digits>
 7cc:	03c9d793          	srli	a5,s3,0x3c
 7d0:	97de                	add	a5,a5,s7
 7d2:	0007c583          	lbu	a1,0(a5)
 7d6:	855a                	mv	a0,s6
 7d8:	d1fff0ef          	jal	4f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7dc:	0992                	slli	s3,s3,0x4
 7de:	397d                	addiw	s2,s2,-1
 7e0:	fe0916e3          	bnez	s2,7cc <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7e4:	8bea                	mv	s7,s10
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	6d02                	ld	s10,0(sp)
 7ea:	bd01                	j	5fa <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	000bc583          	lbu	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	d01ff0ef          	jal	4f6 <putc>
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bbf5                	j	5fa <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 800:	008b8993          	addi	s3,s7,8
 804:	000bb903          	ld	s2,0(s7)
 808:	00090f63          	beqz	s2,826 <vprintf+0x276>
        for (; *s; s++)
 80c:	00094583          	lbu	a1,0(s2)
 810:	c195                	beqz	a1,834 <vprintf+0x284>
          putc(fd, *s);
 812:	855a                	mv	a0,s6
 814:	ce3ff0ef          	jal	4f6 <putc>
        for (; *s; s++)
 818:	0905                	addi	s2,s2,1
 81a:	00094583          	lbu	a1,0(s2)
 81e:	f9f5                	bnez	a1,812 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 820:	8bce                	mv	s7,s3
      state = 0;
 822:	4981                	li	s3,0
 824:	bbd9                	j	5fa <vprintf+0x4a>
          s = "(null)";
 826:	00000917          	auipc	s2,0x0
 82a:	25290913          	addi	s2,s2,594 # a78 <malloc+0x146>
        for (; *s; s++)
 82e:	02800593          	li	a1,40
 832:	b7c5                	j	812 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 834:	8bce                	mv	s7,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b3c9                	j	5fa <vprintf+0x4a>
 83a:	64a6                	ld	s1,72(sp)
 83c:	79e2                	ld	s3,56(sp)
 83e:	7a42                	ld	s4,48(sp)
 840:	7aa2                	ld	s5,40(sp)
 842:	7b02                	ld	s6,32(sp)
 844:	6be2                	ld	s7,24(sp)
 846:	6c42                	ld	s8,16(sp)
 848:	6ca2                	ld	s9,8(sp)
    }
  }
}
 84a:	60e6                	ld	ra,88(sp)
 84c:	6446                	ld	s0,80(sp)
 84e:	6906                	ld	s2,64(sp)
 850:	6125                	addi	sp,sp,96
 852:	8082                	ret

0000000000000854 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 836:	715d                	addi	sp,sp,-80
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e010                	sd	a2,0(s0)
 840:	e414                	sd	a3,8(s0)
 842:	e818                	sd	a4,16(s0)
 844:	ec1c                	sd	a5,24(s0)
 846:	03043023          	sd	a6,32(s0)
 84a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 852:	8622                	mv	a2,s0
 854:	d3fff0ef          	jal	592 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:
=======
 854:	715d                	addi	sp,sp,-80
 856:	ec06                	sd	ra,24(sp)
 858:	e822                	sd	s0,16(sp)
 85a:	1000                	addi	s0,sp,32
 85c:	e010                	sd	a2,0(s0)
 85e:	e414                	sd	a3,8(s0)
 860:	e818                	sd	a4,16(s0)
 862:	ec1c                	sd	a5,24(s0)
 864:	03043023          	sd	a6,32(s0)
 868:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 870:	8622                	mv	a2,s0
 872:	d3fff0ef          	jal	5b0 <vprintf>
}
 876:	60e2                	ld	ra,24(sp)
 878:	6442                	ld	s0,16(sp)
 87a:	6161                	addi	sp,sp,80
 87c:	8082                	ret

000000000000087e <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	d0dff0ef          	jal	592 <vprintf>
}
 88a:	60e2                	ld	ra,24(sp)
 88c:	6442                	ld	s0,16(sp)
 88e:	6125                	addi	sp,sp,96
 890:	8082                	ret

0000000000000892 <free>:
=======
 87e:	711d                	addi	sp,sp,-96
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	addi	s0,sp,32
 886:	e40c                	sd	a1,8(s0)
 888:	e810                	sd	a2,16(s0)
 88a:	ec14                	sd	a3,24(s0)
 88c:	f018                	sd	a4,32(s0)
 88e:	f41c                	sd	a5,40(s0)
 890:	03043823          	sd	a6,48(s0)
 894:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	00840613          	addi	a2,s0,8
 89c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a0:	85aa                	mv	a1,a0
 8a2:	4505                	li	a0,1
 8a4:	d0dff0ef          	jal	5b0 <vprintf>
}
 8a8:	60e2                	ld	ra,24(sp)
 8aa:	6442                	ld	s0,16(sp)
 8ac:	6125                	addi	sp,sp,96
 8ae:	8082                	ret

00000000000008b0 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 898:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	00000797          	auipc	a5,0x0
 8a0:	7647b783          	ld	a5,1892(a5) # 1000 <freep>
 8a4:	a02d                	j	8ce <free+0x3c>
=======
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e422                	sd	s0,8(sp)
 8b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8b6:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	00000797          	auipc	a5,0x0
 8be:	7467b783          	ld	a5,1862(a5) # 1000 <freep>
 8c2:	a02d                	j	8ec <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 8a6:	4618                	lw	a4,8(a2)
 8a8:	9f2d                	addw	a4,a4,a1
 8aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	6310                	ld	a2,0(a4)
 8b2:	a83d                	j	8f0 <free+0x5e>
=======
 8c4:	4618                	lw	a4,8(a2)
 8c6:	9f2d                	addw	a4,a4,a1
 8c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	6310                	ld	a2,0(a4)
 8d0:	a83d                	j	90e <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 8b4:	ff852703          	lw	a4,-8(a0)
 8b8:	9f31                	addw	a4,a4,a2
 8ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8bc:	ff053683          	ld	a3,-16(a0)
 8c0:	a091                	j	904 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	6398                	ld	a4,0(a5)
 8c4:	00e7e463          	bltu	a5,a4,8cc <free+0x3a>
 8c8:	00e6ea63          	bltu	a3,a4,8dc <free+0x4a>
{
 8cc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	fed7fae3          	bgeu	a5,a3,8c2 <free+0x30>
 8d2:	6398                	ld	a4,0(a5)
 8d4:	00e6e463          	bltu	a3,a4,8dc <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	fee7eae3          	bltu	a5,a4,8cc <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8dc:	ff852583          	lw	a1,-8(a0)
 8e0:	6390                	ld	a2,0(a5)
 8e2:	02059813          	slli	a6,a1,0x20
 8e6:	01c85713          	srli	a4,a6,0x1c
 8ea:	9736                	add	a4,a4,a3
 8ec:	fae60de3          	beq	a2,a4,8a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8f4:	4790                	lw	a2,8(a5)
 8f6:	02061593          	slli	a1,a2,0x20
 8fa:	01c5d713          	srli	a4,a1,0x1c
 8fe:	973e                	add	a4,a4,a5
 900:	fae68ae3          	beq	a3,a4,8b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 904:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
}
 90e:	6422                	ld	s0,8(sp)
 910:	0141                	addi	sp,sp,16
 912:	8082                	ret

0000000000000914 <malloc>:
=======
 8d2:	ff852703          	lw	a4,-8(a0)
 8d6:	9f31                	addw	a4,a4,a2
 8d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8da:	ff053683          	ld	a3,-16(a0)
 8de:	a091                	j	922 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	6398                	ld	a4,0(a5)
 8e2:	00e7e463          	bltu	a5,a4,8ea <free+0x3a>
 8e6:	00e6ea63          	bltu	a3,a4,8fa <free+0x4a>
{
 8ea:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ec:	fed7fae3          	bgeu	a5,a3,8e0 <free+0x30>
 8f0:	6398                	ld	a4,0(a5)
 8f2:	00e6e463          	bltu	a3,a4,8fa <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f6:	fee7eae3          	bltu	a5,a4,8ea <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8fa:	ff852583          	lw	a1,-8(a0)
 8fe:	6390                	ld	a2,0(a5)
 900:	02059813          	slli	a6,a1,0x20
 904:	01c85713          	srli	a4,a6,0x1c
 908:	9736                	add	a4,a4,a3
 90a:	fae60de3          	beq	a2,a4,8c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 912:	4790                	lw	a2,8(a5)
 914:	02061593          	slli	a1,a2,0x20
 918:	01c5d713          	srli	a4,a1,0x1c
 91c:	973e                	add	a4,a4,a5
 91e:	fae68ae3          	beq	a3,a4,8d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 922:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
}
 92c:	6422                	ld	s0,8(sp)
 92e:	0141                	addi	sp,sp,16
 930:	8082                	ret

0000000000000932 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 914:	7139                	addi	sp,sp,-64
 916:	fc06                	sd	ra,56(sp)
 918:	f822                	sd	s0,48(sp)
 91a:	f426                	sd	s1,40(sp)
 91c:	ec4e                	sd	s3,24(sp)
 91e:	0080                	addi	s0,sp,64
=======
 932:	7139                	addi	sp,sp,-64
 934:	fc06                	sd	ra,56(sp)
 936:	f822                	sd	s0,48(sp)
 938:	f426                	sd	s1,40(sp)
 93a:	ec4e                	sd	s3,24(sp)
 93c:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 920:	02051493          	slli	s1,a0,0x20
 924:	9081                	srli	s1,s1,0x20
 926:	04bd                	addi	s1,s1,15
 928:	8091                	srli	s1,s1,0x4
 92a:	0014899b          	addiw	s3,s1,1
 92e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 930:	00000517          	auipc	a0,0x0
 934:	6d053503          	ld	a0,1744(a0) # 1000 <freep>
 938:	c915                	beqz	a0,96c <malloc+0x58>
=======
 93e:	02051493          	slli	s1,a0,0x20
 942:	9081                	srli	s1,s1,0x20
 944:	04bd                	addi	s1,s1,15
 946:	8091                	srli	s1,s1,0x4
 948:	0014899b          	addiw	s3,s1,1
 94c:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 94e:	00000517          	auipc	a0,0x0
 952:	6b253503          	ld	a0,1714(a0) # 1000 <freep>
 956:	c915                	beqz	a0,98a <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 93a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 93c:	4798                	lw	a4,8(a5)
 93e:	08977a63          	bgeu	a4,s1,9d2 <malloc+0xbe>
 942:	f04a                	sd	s2,32(sp)
 944:	e852                	sd	s4,16(sp)
 946:	e456                	sd	s5,8(sp)
 948:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 94a:	8a4e                	mv	s4,s3
 94c:	0009871b          	sext.w	a4,s3
 950:	6685                	lui	a3,0x1
 952:	00d77363          	bgeu	a4,a3,958 <malloc+0x44>
 956:	6a05                	lui	s4,0x1
 958:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95c:	004a1a1b          	slliw	s4,s4,0x4
=======
 958:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 95a:	4798                	lw	a4,8(a5)
 95c:	08977a63          	bgeu	a4,s1,9f0 <malloc+0xbe>
 960:	f04a                	sd	s2,32(sp)
 962:	e852                	sd	s4,16(sp)
 964:	e456                	sd	s5,8(sp)
 966:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 968:	8a4e                	mv	s4,s3
 96a:	0009871b          	sext.w	a4,s3
 96e:	6685                	lui	a3,0x1
 970:	00d77363          	bgeu	a4,a3,976 <malloc+0x44>
 974:	6a05                	lui	s4,0x1
 976:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97a:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 960:	00000917          	auipc	s2,0x0
 964:	6a090913          	addi	s2,s2,1696 # 1000 <freep>
  if (p == SBRK_ERROR)
 968:	5afd                	li	s5,-1
 96a:	a081                	j	9aa <malloc+0x96>
 96c:	f04a                	sd	s2,32(sp)
 96e:	e852                	sd	s4,16(sp)
 970:	e456                	sd	s5,8(sp)
 972:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 974:	00001797          	auipc	a5,0x1
 978:	89478793          	addi	a5,a5,-1900 # 1208 <base>
 97c:	00000717          	auipc	a4,0x0
 980:	68f73223          	sd	a5,1668(a4) # 1000 <freep>
 984:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 986:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 98a:	b7c1                	j	94a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 98c:	6398                	ld	a4,0(a5)
 98e:	e118                	sd	a4,0(a0)
 990:	a8a9                	j	9ea <malloc+0xd6>
  hp->s.size = nu;
 992:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 996:	0541                	addi	a0,a0,16
 998:	efbff0ef          	jal	892 <free>
  return freep;
 99c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 9a0:	c12d                	beqz	a0,a02 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9a2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9a4:	4798                	lw	a4,8(a5)
 9a6:	02977263          	bgeu	a4,s1,9ca <malloc+0xb6>
    if (p == freep)
 9aa:	00093703          	ld	a4,0(s2)
 9ae:	853e                	mv	a0,a5
 9b0:	fef719e3          	bne	a4,a5,9a2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9b4:	8552                	mv	a0,s4
 9b6:	9afff0ef          	jal	364 <sbrk>
  if (p == SBRK_ERROR)
 9ba:	fd551ce3          	bne	a0,s5,992 <malloc+0x7e>
        return 0;
 9be:	4501                	li	a0,0
 9c0:	7902                	ld	s2,32(sp)
 9c2:	6a42                	ld	s4,16(sp)
 9c4:	6aa2                	ld	s5,8(sp)
 9c6:	6b02                	ld	s6,0(sp)
 9c8:	a03d                	j	9f6 <malloc+0xe2>
 9ca:	7902                	ld	s2,32(sp)
 9cc:	6a42                	ld	s4,16(sp)
 9ce:	6aa2                	ld	s5,8(sp)
 9d0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9d2:	fae48de3          	beq	s1,a4,98c <malloc+0x78>
        p->s.size -= nunits;
 9d6:	4137073b          	subw	a4,a4,s3
 9da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9dc:	02071693          	slli	a3,a4,0x20
 9e0:	01c6d713          	srli	a4,a3,0x1c
 9e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ea:	00000717          	auipc	a4,0x0
 9ee:	60a73b23          	sd	a0,1558(a4) # 1000 <freep>
      return (void *)(p + 1);
 9f2:	01078513          	addi	a0,a5,16
  }
}
 9f6:	70e2                	ld	ra,56(sp)
 9f8:	7442                	ld	s0,48(sp)
 9fa:	74a2                	ld	s1,40(sp)
 9fc:	69e2                	ld	s3,24(sp)
 9fe:	6121                	addi	sp,sp,64
 a00:	8082                	ret
 a02:	7902                	ld	s2,32(sp)
 a04:	6a42                	ld	s4,16(sp)
 a06:	6aa2                	ld	s5,8(sp)
 a08:	6b02                	ld	s6,0(sp)
 a0a:	b7f5                	j	9f6 <malloc+0xe2>
=======
 97e:	00000917          	auipc	s2,0x0
 982:	68290913          	addi	s2,s2,1666 # 1000 <freep>
  if (p == SBRK_ERROR)
 986:	5afd                	li	s5,-1
 988:	a081                	j	9c8 <malloc+0x96>
 98a:	f04a                	sd	s2,32(sp)
 98c:	e852                	sd	s4,16(sp)
 98e:	e456                	sd	s5,8(sp)
 990:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 992:	00001797          	auipc	a5,0x1
 996:	87678793          	addi	a5,a5,-1930 # 1208 <base>
 99a:	00000717          	auipc	a4,0x0
 99e:	66f73323          	sd	a5,1638(a4) # 1000 <freep>
 9a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 9a8:	b7c1                	j	968 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9aa:	6398                	ld	a4,0(a5)
 9ac:	e118                	sd	a4,0(a0)
 9ae:	a8a9                	j	a08 <malloc+0xd6>
  hp->s.size = nu;
 9b0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9b4:	0541                	addi	a0,a0,16
 9b6:	efbff0ef          	jal	8b0 <free>
  return freep;
 9ba:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 9be:	c12d                	beqz	a0,a20 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9c0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9c2:	4798                	lw	a4,8(a5)
 9c4:	02977263          	bgeu	a4,s1,9e8 <malloc+0xb6>
    if (p == freep)
 9c8:	00093703          	ld	a4,0(s2)
 9cc:	853e                	mv	a0,a5
 9ce:	fef719e3          	bne	a4,a5,9c0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9d2:	8552                	mv	a0,s4
 9d4:	991ff0ef          	jal	364 <sbrk>
  if (p == SBRK_ERROR)
 9d8:	fd551ce3          	bne	a0,s5,9b0 <malloc+0x7e>
        return 0;
 9dc:	4501                	li	a0,0
 9de:	7902                	ld	s2,32(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	a03d                	j	a14 <malloc+0xe2>
 9e8:	7902                	ld	s2,32(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9f0:	fae48de3          	beq	s1,a4,9aa <malloc+0x78>
        p->s.size -= nunits;
 9f4:	4137073b          	subw	a4,a4,s3
 9f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fa:	02071693          	slli	a3,a4,0x20
 9fe:	01c6d713          	srli	a4,a3,0x1c
 a02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a08:	00000717          	auipc	a4,0x0
 a0c:	5ea73c23          	sd	a0,1528(a4) # 1000 <freep>
      return (void *)(p + 1);
 a10:	01078513          	addi	a0,a5,16
  }
}
 a14:	70e2                	ld	ra,56(sp)
 a16:	7442                	ld	s0,48(sp)
 a18:	74a2                	ld	s1,40(sp)
 a1a:	69e2                	ld	s3,24(sp)
 a1c:	6121                	addi	sp,sp,64
 a1e:	8082                	ret
 a20:	7902                	ld	s2,32(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
 a28:	b7f5                	j	a14 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
