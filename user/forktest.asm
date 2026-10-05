
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N 1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	128000ef          	jal	134 <strlen>
  10:	862a                	mv	a2,a0
  12:	85a6                	mv	a1,s1
  14:	4505                	li	a0,1
  16:	3a6000ef          	jal	3bc <write>
}
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret

0000000000000024 <forktest>:

void
forktest(void)
{
  24:	1101                	addi	sp,sp,-32
  26:	ec06                	sd	ra,24(sp)
  28:	e822                	sd	s0,16(sp)
  2a:	e426                	sd	s1,8(sp)
  2c:	e04a                	sd	s2,0(sp)
  2e:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  30:	00000517          	auipc	a0,0x0
  34:	43850513          	addi	a0,a0,1080 # 468 <munmap+0xc>
  38:	fc9ff0ef          	jal	0 <print>

  for (n = 0; n < N; n++) {
  3c:	4481                	li	s1,0
  3e:	3e800913          	li	s2,1000
    pid = fork();
  42:	352000ef          	jal	394 <fork>
    if (pid < 0)
  46:	04054363          	bltz	a0,8c <forktest+0x68>
      break;
    if (pid == 0)
  4a:	cd09                	beqz	a0,64 <forktest+0x40>
  for (n = 0; n < N; n++) {
  4c:	2485                	addiw	s1,s1,1
  4e:	ff249ae3          	bne	s1,s2,42 <forktest+0x1e>
      exit(0);
  }

  if (n == N) {
    print("fork claimed to work N times!\n");
  52:	00000517          	auipc	a0,0x0
  56:	46650513          	addi	a0,a0,1126 # 4b8 <munmap+0x5c>
  5a:	fa7ff0ef          	jal	0 <print>
    exit(1);
  5e:	4505                	li	a0,1
  60:	33c000ef          	jal	39c <exit>
      exit(0);
  64:	338000ef          	jal	39c <exit>
  }

  for (; n > 0; n--) {
    if (wait(0) < 0) {
      print("wait stopped early\n");
  68:	00000517          	auipc	a0,0x0
  6c:	41050513          	addi	a0,a0,1040 # 478 <munmap+0x1c>
  70:	f91ff0ef          	jal	0 <print>
      exit(1);
  74:	4505                	li	a0,1
  76:	326000ef          	jal	39c <exit>
    }
  }

  if (wait(0) != -1) {
    print("wait got too many\n");
  7a:	00000517          	auipc	a0,0x0
  7e:	41650513          	addi	a0,a0,1046 # 490 <munmap+0x34>
  82:	f7fff0ef          	jal	0 <print>
    exit(1);
  86:	4505                	li	a0,1
  88:	314000ef          	jal	39c <exit>
  for (; n > 0; n--) {
  8c:	00905963          	blez	s1,9e <forktest+0x7a>
    if (wait(0) < 0) {
  90:	4501                	li	a0,0
  92:	312000ef          	jal	3a4 <wait>
  96:	fc0549e3          	bltz	a0,68 <forktest+0x44>
  for (; n > 0; n--) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8f5                	bnez	s1,90 <forktest+0x6c>
  if (wait(0) != -1) {
  9e:	4501                	li	a0,0
  a0:	304000ef          	jal	3a4 <wait>
  a4:	57fd                	li	a5,-1
  a6:	fcf51ae3          	bne	a0,a5,7a <forktest+0x56>
  }

  print("fork test OK\n");
  aa:	00000517          	auipc	a0,0x0
  ae:	3fe50513          	addi	a0,a0,1022 # 4a8 <munmap+0x4c>
  b2:	f4fff0ef          	jal	0 <print>
}
  b6:	60e2                	ld	ra,24(sp)
  b8:	6442                	ld	s0,16(sp)
  ba:	64a2                	ld	s1,8(sp)
  bc:	6902                	ld	s2,0(sp)
  be:	6105                	addi	sp,sp,32
  c0:	8082                	ret

00000000000000c2 <main>:

int
main(void)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  forktest();
  ca:	f5bff0ef          	jal	24 <forktest>
  exit(0);
  ce:	4501                	li	a0,0
  d0:	2cc000ef          	jal	39c <exit>

00000000000000d4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  dc:	fe7ff0ef          	jal	c2 <main>
  exit(r);
  e0:	2bc000ef          	jal	39c <exit>

00000000000000e4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  ec:	87aa                	mv	a5,a0
  ee:	0585                	addi	a1,a1,1
  f0:	0785                	addi	a5,a5,1
  f2:	fff5c703          	lbu	a4,-1(a1)
  f6:	fee78fa3          	sb	a4,-1(a5)
  fa:	fb75                	bnez	a4,ee <strcpy+0xa>
    ;
  return os;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x20>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x20>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf99                	beqz	a5,15e <strlen+0x2a>
 142:	0505                	addi	a0,a0,1
 144:	87aa                	mv	a5,a0
 146:	86be                	mv	a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	ff65                	bnez	a4,146 <strlen+0x12>
 150:	40a6853b          	subw	a0,a3,a0
 154:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 156:	60a2                	ld	ra,8(sp)
 158:	6402                	ld	s0,0(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret
  for (n = 0; s[n]; n++)
 15e:	4501                	li	a0,0
 160:	bfdd                	j	156 <strlen+0x22>

0000000000000162 <memset>:

void *
memset(void *dst, int c, uint n)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 16a:	ca19                	beqz	a2,180 <memset+0x1e>
 16c:	87aa                	mv	a5,a0
 16e:	1602                	slli	a2,a2,0x20
 170:	9201                	srli	a2,a2,0x20
 172:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 176:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 17a:	0785                	addi	a5,a5,1
 17c:	fee79de3          	bne	a5,a4,176 <memset+0x14>
  }
  return dst;
}
 180:	60a2                	ld	ra,8(sp)
 182:	6402                	ld	s0,0(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strchr>:

char *
strchr(const char *s, char c)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cf81                	beqz	a5,1ac <strchr+0x24>
    if (*s == c)
 196:	00f58763          	beq	a1,a5,1a4 <strchr+0x1c>
  for (; *s; s++)
 19a:	0505                	addi	a0,a0,1
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbfd                	bnez	a5,196 <strchr+0xe>
      return (char *)s;
  return 0;
 1a2:	4501                	li	a0,0
}
 1a4:	60a2                	ld	ra,8(sp)
 1a6:	6402                	ld	s0,0(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfdd                	j	1a4 <strchr+0x1c>

00000000000001b0 <gets>:

char *
gets(char *buf, int max)
{
 1b0:	7159                	addi	sp,sp,-112
 1b2:	f486                	sd	ra,104(sp)
 1b4:	f0a2                	sd	s0,96(sp)
 1b6:	eca6                	sd	s1,88(sp)
 1b8:	e8ca                	sd	s2,80(sp)
 1ba:	e4ce                	sd	s3,72(sp)
 1bc:	e0d2                	sd	s4,64(sp)
 1be:	fc56                	sd	s5,56(sp)
 1c0:	f85a                	sd	s6,48(sp)
 1c2:	f45e                	sd	s7,40(sp)
 1c4:	f062                	sd	s8,32(sp)
 1c6:	ec66                	sd	s9,24(sp)
 1c8:	e86a                	sd	s10,16(sp)
 1ca:	1880                	addi	s0,sp,112
 1cc:	8caa                	mv	s9,a0
 1ce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1d0:	892a                	mv	s2,a0
 1d2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1d4:	f9f40b13          	addi	s6,s0,-97
 1d8:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1da:	4ba9                	li	s7,10
 1dc:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 1de:	8d26                	mv	s10,s1
 1e0:	0014899b          	addiw	s3,s1,1
 1e4:	84ce                	mv	s1,s3
 1e6:	0349d563          	bge	s3,s4,210 <gets+0x60>
    cc = read(0, &c, 1);
 1ea:	8656                	mv	a2,s5
 1ec:	85da                	mv	a1,s6
 1ee:	4501                	li	a0,0
 1f0:	1c4000ef          	jal	3b4 <read>
    if (cc < 1)
 1f4:	00a05e63          	blez	a0,210 <gets+0x60>
    buf[i++] = c;
 1f8:	f9f44783          	lbu	a5,-97(s0)
 1fc:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 200:	01778763          	beq	a5,s7,20e <gets+0x5e>
 204:	0905                	addi	s2,s2,1
 206:	fd879ce3          	bne	a5,s8,1de <gets+0x2e>
    buf[i++] = c;
 20a:	8d4e                	mv	s10,s3
 20c:	a011                	j	210 <gets+0x60>
 20e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 210:	9d66                	add	s10,s10,s9
 212:	000d0023          	sb	zero,0(s10)
  return buf;
}
 216:	8566                	mv	a0,s9
 218:	70a6                	ld	ra,104(sp)
 21a:	7406                	ld	s0,96(sp)
 21c:	64e6                	ld	s1,88(sp)
 21e:	6946                	ld	s2,80(sp)
 220:	69a6                	ld	s3,72(sp)
 222:	6a06                	ld	s4,64(sp)
 224:	7ae2                	ld	s5,56(sp)
 226:	7b42                	ld	s6,48(sp)
 228:	7ba2                	ld	s7,40(sp)
 22a:	7c02                	ld	s8,32(sp)
 22c:	6ce2                	ld	s9,24(sp)
 22e:	6d42                	ld	s10,16(sp)
 230:	6165                	addi	sp,sp,112
 232:	8082                	ret

0000000000000234 <stat>:

int
stat(const char *n, struct stat *st)
{
 234:	1101                	addi	sp,sp,-32
 236:	ec06                	sd	ra,24(sp)
 238:	e822                	sd	s0,16(sp)
 23a:	e04a                	sd	s2,0(sp)
 23c:	1000                	addi	s0,sp,32
 23e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	4581                	li	a1,0
 242:	19a000ef          	jal	3dc <open>
  if (fd < 0)
 246:	02054263          	bltz	a0,26a <stat+0x36>
 24a:	e426                	sd	s1,8(sp)
 24c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 24e:	85ca                	mv	a1,s2
 250:	1a4000ef          	jal	3f4 <fstat>
 254:	892a                	mv	s2,a0
  close(fd);
 256:	8526                	mv	a0,s1
 258:	16c000ef          	jal	3c4 <close>
  return r;
 25c:	64a2                	ld	s1,8(sp)
}
 25e:	854a                	mv	a0,s2
 260:	60e2                	ld	ra,24(sp)
 262:	6442                	ld	s0,16(sp)
 264:	6902                	ld	s2,0(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret
    return -1;
 26a:	597d                	li	s2,-1
 26c:	bfcd                	j	25e <stat+0x2a>

000000000000026e <atoi>:

int
atoi(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 276:	00054683          	lbu	a3,0(a0)
 27a:	fd06879b          	addiw	a5,a3,-48
 27e:	0ff7f793          	zext.b	a5,a5
 282:	4625                	li	a2,9
 284:	02f66963          	bltu	a2,a5,2b6 <atoi+0x48>
 288:	872a                	mv	a4,a0
  n = 0;
 28a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 28c:	0705                	addi	a4,a4,1
 28e:	0025179b          	slliw	a5,a0,0x2
 292:	9fa9                	addw	a5,a5,a0
 294:	0017979b          	slliw	a5,a5,0x1
 298:	9fb5                	addw	a5,a5,a3
 29a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 29e:	00074683          	lbu	a3,0(a4)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	fef671e3          	bgeu	a2,a5,28c <atoi+0x1e>
  return n;
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  n = 0;
 2b6:	4501                	li	a0,0
 2b8:	bfdd                	j	2ae <atoi+0x40>

00000000000002ba <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e406                	sd	ra,8(sp)
 2be:	e022                	sd	s0,0(sp)
 2c0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c2:	02b57563          	bgeu	a0,a1,2ec <memmove+0x32>
    while (n-- > 0)
 2c6:	00c05f63          	blez	a2,2e4 <memmove+0x2a>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d4:	0585                	addi	a1,a1,1
 2d6:	0705                	addi	a4,a4,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
    dst += n;
 2ec:	00c50733          	add	a4,a0,a2
    src += n;
 2f0:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2f2:	fec059e3          	blez	a2,2e4 <memmove+0x2a>
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
 310:	fef71ae3          	bne	a4,a5,304 <memmove+0x4a>
 314:	bfc1                	j	2e4 <memmove+0x2a>

0000000000000316 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31e:	ca0d                	beqz	a2,350 <memcmp+0x3a>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 338:	0505                	addi	a0,a0,1
    p2++;
 33a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x16>
  }
  return 0;
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x32>
      return *p1 - *p2;
 344:	40e7853b          	subw	a0,a5,a4
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  return 0;
 350:	4501                	li	a0,0
 352:	bfdd                	j	348 <memcmp+0x32>

0000000000000354 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35c:	f5fff0ef          	jal	2ba <memmove>
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <sbrk>:

char *
sbrk(int n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 370:	4585                	li	a1,1
 372:	0b2000ef          	jal	424 <sys_sbrk>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <sbrklazy>:

char *
sbrklazy(int n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 386:	4589                	li	a1,2
 388:	09c000ef          	jal	424 <sys_sbrk>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 394:	4885                	li	a7,1
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exit>:
.global exit
exit:
 li a7, SYS_exit
 39c:	4889                	li	a7,2
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a4:	488d                	li	a7,3
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ac:	4891                	li	a7,4
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <read>:
.global read
read:
 li a7, SYS_read
 3b4:	4895                	li	a7,5
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <write>:
.global write
write:
 li a7, SYS_write
 3bc:	48c1                	li	a7,16
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <close>:
.global close
close:
 li a7, SYS_close
 3c4:	48d5                	li	a7,21
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3cc:	4899                	li	a7,6
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d4:	489d                	li	a7,7
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <open>:
.global open
open:
 li a7, SYS_open
 3dc:	48bd                	li	a7,15
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e4:	48c5                	li	a7,17
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ec:	48c9                	li	a7,18
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f4:	48a1                	li	a7,8
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <link>:
.global link
link:
 li a7, SYS_link
 3fc:	48cd                	li	a7,19
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 404:	48d1                	li	a7,20
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40c:	48a5                	li	a7,9
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <dup>:
.global dup
dup:
 li a7, SYS_dup
 414:	48a9                	li	a7,10
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41c:	48ad                	li	a7,11
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 424:	48b1                	li	a7,12
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <pause>:
.global pause
pause:
 li a7, SYS_pause
 42c:	48b5                	li	a7,13
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 434:	48b9                	li	a7,14
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sync>:
.global sync
sync:
 li a7, SYS_sync
 43c:	48d9                	li	a7,22
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <ps>:
.global ps
ps:
 li a7, SYS_ps
 444:	48dd                	li	a7,23
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 44c:	48e1                	li	a7,24
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 454:	48e5                	li	a7,25
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 45c:	48e9                	li	a7,26
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret
