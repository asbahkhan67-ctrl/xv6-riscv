
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if (mkdir("dd") != 0) {
   c:	00001517          	auipc	a0,0x1
  10:	93450513          	addi	a0,a0,-1740 # 940 <malloc+0xf2>
  14:	3a8000ef          	jal	3bc <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	92c50513          	addi	a0,a0,-1748 # 948 <malloc+0xfa>
  24:	772000ef          	jal	796 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	32a000ef          	jal	354 <exit>
  }

  if (chdir("dd") != 0) {
  2e:	00001517          	auipc	a0,0x1
  32:	91250513          	addi	a0,a0,-1774 # 940 <malloc+0xf2>
  36:	38e000ef          	jal	3c4 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	92250513          	addi	a0,a0,-1758 # 960 <malloc+0x112>
  46:	750000ef          	jal	796 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	308000ef          	jal	354 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	92850513          	addi	a0,a0,-1752 # 978 <malloc+0x12a>
  58:	34c000ef          	jal	3a4 <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	93850513          	addi	a0,a0,-1736 # 998 <malloc+0x14a>
  68:	72e000ef          	jal	796 <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	372000ef          	jal	3e4 <pause>
  for (;;)
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	90650513          	addi	a0,a0,-1786 # 980 <malloc+0x132>
  82:	714000ef          	jal	796 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	2cc000ef          	jal	354 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	2bc000ef          	jal	354 <exit>

000000000000009c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf99                	beqz	a5,116 <strlen+0x2a>
  fa:	0505                	addi	a0,a0,1
  fc:	87aa                	mv	a5,a0
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
 10c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  for (n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfdd                	j	10e <strlen+0x22>

000000000000011a <memset>:

void *
memset(void *dst, int c, uint n)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 122:	ca19                	beqz	a2,138 <memset+0x1e>
 124:	87aa                	mv	a5,a0
 126:	1602                	slli	a2,a2,0x20
 128:	9201                	srli	a2,a2,0x20
 12a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 132:	0785                	addi	a5,a5,1
 134:	fee79de3          	bne	a5,a4,12e <memset+0x14>
  }
  return dst;
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strchr>:

char *
strchr(const char *s, char c)
{
 140:	1141                	addi	sp,sp,-16
 142:	e406                	sd	ra,8(sp)
 144:	e022                	sd	s0,0(sp)
 146:	0800                	addi	s0,sp,16
  for (; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cf81                	beqz	a5,164 <strchr+0x24>
    if (*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1c>
  for (; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xe>
      return (char *)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret
  return 0;
 164:	4501                	li	a0,0
 166:	bfdd                	j	15c <strchr+0x1c>

0000000000000168 <gets>:

char *
gets(char *buf, int max)
{
 168:	7159                	addi	sp,sp,-112
 16a:	f486                	sd	ra,104(sp)
 16c:	f0a2                	sd	s0,96(sp)
 16e:	eca6                	sd	s1,88(sp)
 170:	e8ca                	sd	s2,80(sp)
 172:	e4ce                	sd	s3,72(sp)
 174:	e0d2                	sd	s4,64(sp)
 176:	fc56                	sd	s5,56(sp)
 178:	f85a                	sd	s6,48(sp)
 17a:	f45e                	sd	s7,40(sp)
 17c:	f062                	sd	s8,32(sp)
 17e:	ec66                	sd	s9,24(sp)
 180:	e86a                	sd	s10,16(sp)
 182:	1880                	addi	s0,sp,112
 184:	8caa                	mv	s9,a0
 186:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 188:	892a                	mv	s2,a0
 18a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 18c:	f9f40b13          	addi	s6,s0,-97
 190:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 192:	4ba9                	li	s7,10
 194:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 196:	8d26                	mv	s10,s1
 198:	0014899b          	addiw	s3,s1,1
 19c:	84ce                	mv	s1,s3
 19e:	0349d563          	bge	s3,s4,1c8 <gets+0x60>
    cc = read(0, &c, 1);
 1a2:	8656                	mv	a2,s5
 1a4:	85da                	mv	a1,s6
 1a6:	4501                	li	a0,0
 1a8:	1c4000ef          	jal	36c <read>
    if (cc < 1)
 1ac:	00a05e63          	blez	a0,1c8 <gets+0x60>
    buf[i++] = c;
 1b0:	f9f44783          	lbu	a5,-97(s0)
 1b4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1b8:	01778763          	beq	a5,s7,1c6 <gets+0x5e>
 1bc:	0905                	addi	s2,s2,1
 1be:	fd879ce3          	bne	a5,s8,196 <gets+0x2e>
    buf[i++] = c;
 1c2:	8d4e                	mv	s10,s3
 1c4:	a011                	j	1c8 <gets+0x60>
 1c6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1c8:	9d66                	add	s10,s10,s9
 1ca:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1ce:	8566                	mv	a0,s9
 1d0:	70a6                	ld	ra,104(sp)
 1d2:	7406                	ld	s0,96(sp)
 1d4:	64e6                	ld	s1,88(sp)
 1d6:	6946                	ld	s2,80(sp)
 1d8:	69a6                	ld	s3,72(sp)
 1da:	6a06                	ld	s4,64(sp)
 1dc:	7ae2                	ld	s5,56(sp)
 1de:	7b42                	ld	s6,48(sp)
 1e0:	7ba2                	ld	s7,40(sp)
 1e2:	7c02                	ld	s8,32(sp)
 1e4:	6ce2                	ld	s9,24(sp)
 1e6:	6d42                	ld	s10,16(sp)
 1e8:	6165                	addi	sp,sp,112
 1ea:	8082                	ret

00000000000001ec <stat>:

int
stat(const char *n, struct stat *st)
{
 1ec:	1101                	addi	sp,sp,-32
 1ee:	ec06                	sd	ra,24(sp)
 1f0:	e822                	sd	s0,16(sp)
 1f2:	e04a                	sd	s2,0(sp)
 1f4:	1000                	addi	s0,sp,32
 1f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f8:	4581                	li	a1,0
 1fa:	19a000ef          	jal	394 <open>
  if (fd < 0)
 1fe:	02054263          	bltz	a0,222 <stat+0x36>
 202:	e426                	sd	s1,8(sp)
 204:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 206:	85ca                	mv	a1,s2
 208:	1a4000ef          	jal	3ac <fstat>
 20c:	892a                	mv	s2,a0
  close(fd);
 20e:	8526                	mv	a0,s1
 210:	16c000ef          	jal	37c <close>
  return r;
 214:	64a2                	ld	s1,8(sp)
}
 216:	854a                	mv	a0,s2
 218:	60e2                	ld	ra,24(sp)
 21a:	6442                	ld	s0,16(sp)
 21c:	6902                	ld	s2,0(sp)
 21e:	6105                	addi	sp,sp,32
 220:	8082                	ret
    return -1;
 222:	597d                	li	s2,-1
 224:	bfcd                	j	216 <stat+0x2a>

0000000000000226 <atoi>:

int
atoi(const char *s)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 22e:	00054683          	lbu	a3,0(a0)
 232:	fd06879b          	addiw	a5,a3,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	4625                	li	a2,9
 23c:	02f66963          	bltu	a2,a5,26e <atoi+0x48>
 240:	872a                	mv	a4,a0
  n = 0;
 242:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 244:	0705                	addi	a4,a4,1
 246:	0025179b          	slliw	a5,a0,0x2
 24a:	9fa9                	addw	a5,a5,a0
 24c:	0017979b          	slliw	a5,a5,0x1
 250:	9fb5                	addw	a5,a5,a3
 252:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 256:	00074683          	lbu	a3,0(a4)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	fef671e3          	bgeu	a2,a5,244 <atoi+0x1e>
  return n;
}
 266:	60a2                	ld	ra,8(sp)
 268:	6402                	ld	s0,0(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret
  n = 0;
 26e:	4501                	li	a0,0
 270:	bfdd                	j	266 <atoi+0x40>

0000000000000272 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27a:	02b57563          	bgeu	a0,a1,2a4 <memmove+0x32>
    while (n-- > 0)
 27e:	00c05f63          	blez	a2,29c <memmove+0x2a>
 282:	1602                	slli	a2,a2,0x20
 284:	9201                	srli	a2,a2,0x20
 286:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28a:	872a                	mv	a4,a0
      *dst++ = *src++;
 28c:	0585                	addi	a1,a1,1
 28e:	0705                	addi	a4,a4,1
 290:	fff5c683          	lbu	a3,-1(a1)
 294:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
    dst += n;
 2a4:	00c50733          	add	a4,a0,a2
    src += n;
 2a8:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2aa:	fec059e3          	blez	a2,29c <memmove+0x2a>
 2ae:	fff6079b          	addiw	a5,a2,-1
 2b2:	1782                	slli	a5,a5,0x20
 2b4:	9381                	srli	a5,a5,0x20
 2b6:	fff7c793          	not	a5,a5
 2ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2bc:	15fd                	addi	a1,a1,-1
 2be:	177d                	addi	a4,a4,-1
 2c0:	0005c683          	lbu	a3,0(a1)
 2c4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2c8:	fef71ae3          	bne	a4,a5,2bc <memmove+0x4a>
 2cc:	bfc1                	j	29c <memmove+0x2a>

00000000000002ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d6:	ca0d                	beqz	a2,308 <memcmp+0x3a>
 2d8:	fff6069b          	addiw	a3,a2,-1
 2dc:	1682                	slli	a3,a3,0x20
 2de:	9281                	srli	a3,a3,0x20
 2e0:	0685                	addi	a3,a3,1
 2e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	0005c703          	lbu	a4,0(a1)
 2ec:	00e79863          	bne	a5,a4,2fc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2f0:	0505                	addi	a0,a0,1
    p2++;
 2f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f4:	fed518e3          	bne	a0,a3,2e4 <memcmp+0x16>
  }
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	a019                	j	300 <memcmp+0x32>
      return *p1 - *p2;
 2fc:	40e7853b          	subw	a0,a5,a4
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfdd                	j	300 <memcmp+0x32>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 314:	f5fff0ef          	jal	272 <memmove>
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <sbrk>:

char *
sbrk(int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 328:	4585                	li	a1,1
 32a:	0b2000ef          	jal	3dc <sys_sbrk>
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <sbrklazy>:

char *
sbrklazy(int n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 33e:	4589                	li	a1,2
 340:	09c000ef          	jal	3dc <sys_sbrk>
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34c:	4885                	li	a7,1
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exit>:
.global exit
exit:
 li a7, SYS_exit
 354:	4889                	li	a7,2
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <wait>:
.global wait
wait:
 li a7, SYS_wait
 35c:	488d                	li	a7,3
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 364:	4891                	li	a7,4
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <read>:
.global read
read:
 li a7, SYS_read
 36c:	4895                	li	a7,5
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <write>:
.global write
write:
 li a7, SYS_write
 374:	48c1                	li	a7,16
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <close>:
.global close
close:
 li a7, SYS_close
 37c:	48d5                	li	a7,21
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <kill>:
.global kill
kill:
 li a7, SYS_kill
 384:	4899                	li	a7,6
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <exec>:
.global exec
exec:
 li a7, SYS_exec
 38c:	489d                	li	a7,7
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <open>:
.global open
open:
 li a7, SYS_open
 394:	48bd                	li	a7,15
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39c:	48c5                	li	a7,17
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a4:	48c9                	li	a7,18
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ac:	48a1                	li	a7,8
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <link>:
.global link
link:
 li a7, SYS_link
 3b4:	48cd                	li	a7,19
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3bc:	48d1                	li	a7,20
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c4:	48a5                	li	a7,9
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3cc:	48a9                	li	a7,10
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d4:	48ad                	li	a7,11
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3dc:	48b1                	li	a7,12
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e4:	48b5                	li	a7,13
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ec:	48b9                	li	a7,14
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3f4:	48d9                	li	a7,22
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <ps>:
.global ps
ps:
 li a7, SYS_ps
 3fc:	48dd                	li	a7,23
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 404:	48e1                	li	a7,24
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 40c:	48e5                	li	a7,25
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 414:	48e9                	li	a7,26
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41c:	1101                	addi	sp,sp,-32
 41e:	ec06                	sd	ra,24(sp)
 420:	e822                	sd	s0,16(sp)
 422:	1000                	addi	s0,sp,32
 424:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 428:	4605                	li	a2,1
 42a:	fef40593          	addi	a1,s0,-17
 42e:	f47ff0ef          	jal	374 <write>
}
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6105                	addi	sp,sp,32
 438:	8082                	ret

000000000000043a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 43a:	715d                	addi	sp,sp,-80
 43c:	e486                	sd	ra,72(sp)
 43e:	e0a2                	sd	s0,64(sp)
 440:	fc26                	sd	s1,56(sp)
 442:	f84a                	sd	s2,48(sp)
 444:	f44e                	sd	s3,40(sp)
 446:	0880                	addi	s0,sp,80
 448:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 44a:	c299                	beqz	a3,450 <printint+0x16>
 44c:	0605cc63          	bltz	a1,4c4 <printint+0x8a>
  neg = 0;
 450:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 452:	fb840313          	addi	t1,s0,-72
  neg = 0;
 456:	869a                	mv	a3,t1
  i = 0;
 458:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 45a:	00000817          	auipc	a6,0x0
 45e:	56680813          	addi	a6,a6,1382 # 9c0 <digits>
 462:	88be                	mv	a7,a5
 464:	0017851b          	addiw	a0,a5,1
 468:	87aa                	mv	a5,a0
 46a:	02c5f733          	remu	a4,a1,a2
 46e:	9742                	add	a4,a4,a6
 470:	00074703          	lbu	a4,0(a4)
 474:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 478:	872e                	mv	a4,a1
 47a:	02c5d5b3          	divu	a1,a1,a2
 47e:	0685                	addi	a3,a3,1
 480:	fec771e3          	bgeu	a4,a2,462 <printint+0x28>
  if (neg)
 484:	000e0c63          	beqz	t3,49c <printint+0x62>
    buf[i++] = '-';
 488:	fd050793          	addi	a5,a0,-48
 48c:	00878533          	add	a0,a5,s0
 490:	02d00793          	li	a5,45
 494:	fef50423          	sb	a5,-24(a0)
 498:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 49c:	fff7899b          	addiw	s3,a5,-1
 4a0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4a4:	fff4c583          	lbu	a1,-1(s1)
 4a8:	854a                	mv	a0,s2
 4aa:	f73ff0ef          	jal	41c <putc>
  while (--i >= 0)
 4ae:	39fd                	addiw	s3,s3,-1
 4b0:	14fd                	addi	s1,s1,-1
 4b2:	fe09d9e3          	bgez	s3,4a4 <printint+0x6a>
}
 4b6:	60a6                	ld	ra,72(sp)
 4b8:	6406                	ld	s0,64(sp)
 4ba:	74e2                	ld	s1,56(sp)
 4bc:	7942                	ld	s2,48(sp)
 4be:	79a2                	ld	s3,40(sp)
 4c0:	6161                	addi	sp,sp,80
 4c2:	8082                	ret
    x = -xx;
 4c4:	40b005b3          	neg	a1,a1
    neg = 1;
 4c8:	4e05                	li	t3,1
    x = -xx;
 4ca:	b761                	j	452 <printint+0x18>

00000000000004cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4cc:	711d                	addi	sp,sp,-96
 4ce:	ec86                	sd	ra,88(sp)
 4d0:	e8a2                	sd	s0,80(sp)
 4d2:	e4a6                	sd	s1,72(sp)
 4d4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4d6:	0005c483          	lbu	s1,0(a1)
 4da:	28048463          	beqz	s1,762 <vprintf+0x296>
 4de:	e0ca                	sd	s2,64(sp)
 4e0:	fc4e                	sd	s3,56(sp)
 4e2:	f852                	sd	s4,48(sp)
 4e4:	f456                	sd	s5,40(sp)
 4e6:	f05a                	sd	s6,32(sp)
 4e8:	ec5e                	sd	s7,24(sp)
 4ea:	e862                	sd	s8,16(sp)
 4ec:	e466                	sd	s9,8(sp)
 4ee:	8b2a                	mv	s6,a0
 4f0:	8a2e                	mv	s4,a1
 4f2:	8bb2                	mv	s7,a2
  state = 0;
 4f4:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4f6:	4901                	li	s2,0
 4f8:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 502:	06c00c93          	li	s9,108
 506:	a00d                	j	528 <vprintf+0x5c>
        putc(fd, c0);
 508:	85a6                	mv	a1,s1
 50a:	855a                	mv	a0,s6
 50c:	f11ff0ef          	jal	41c <putc>
 510:	a019                	j	516 <vprintf+0x4a>
    } else if (state == '%') {
 512:	03598363          	beq	s3,s5,538 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 516:	0019079b          	addiw	a5,s2,1
 51a:	893e                	mv	s2,a5
 51c:	873e                	mv	a4,a5
 51e:	97d2                	add	a5,a5,s4
 520:	0007c483          	lbu	s1,0(a5)
 524:	22048763          	beqz	s1,752 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 528:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 52c:	fe0993e3          	bnez	s3,512 <vprintf+0x46>
      if (c0 == '%') {
 530:	fd579ce3          	bne	a5,s5,508 <vprintf+0x3c>
        state = '%';
 534:	89be                	mv	s3,a5
 536:	b7c5                	j	516 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 538:	00ea06b3          	add	a3,s4,a4
 53c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 540:	8636                	mv	a2,a3
      if (c1)
 542:	c681                	beqz	a3,54a <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 544:	9752                	add	a4,a4,s4
 546:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 54a:	05878263          	beq	a5,s8,58e <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 54e:	05978c63          	beq	a5,s9,5a6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 552:	07500713          	li	a4,117
 556:	0ee78663          	beq	a5,a4,642 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 55a:	07800713          	li	a4,120
 55e:	12e78863          	beq	a5,a4,68e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 562:	07000713          	li	a4,112
 566:	14e78d63          	beq	a5,a4,6c0 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 56a:	06300713          	li	a4,99
 56e:	18e78c63          	beq	a5,a4,706 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 572:	07300713          	li	a4,115
 576:	1ae78263          	beq	a5,a4,71a <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 57a:	02500713          	li	a4,37
 57e:	04e79463          	bne	a5,a4,5c6 <vprintf+0xfa>
        putc(fd, '%');
 582:	85ba                	mv	a1,a4
 584:	855a                	mv	a0,s6
 586:	e97ff0ef          	jal	41c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58a:	4981                	li	s3,0
 58c:	b769                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 58e:	008b8493          	addi	s1,s7,8
 592:	4685                	li	a3,1
 594:	4629                	li	a2,10
 596:	000ba583          	lw	a1,0(s7)
 59a:	855a                	mv	a0,s6
 59c:	e9fff0ef          	jal	43a <printint>
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bf8d                	j	516 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5a6:	06400793          	li	a5,100
 5aa:	02f68963          	beq	a3,a5,5dc <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ae:	06c00793          	li	a5,108
 5b2:	04f68263          	beq	a3,a5,5f6 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5b6:	07500793          	li	a5,117
 5ba:	0af68063          	beq	a3,a5,65a <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5be:	07800793          	li	a5,120
 5c2:	0ef68263          	beq	a3,a5,6a6 <vprintf+0x1da>
        putc(fd, '%');
 5c6:	02500593          	li	a1,37
 5ca:	855a                	mv	a0,s6
 5cc:	e51ff0ef          	jal	41c <putc>
        putc(fd, c0);
 5d0:	85a6                	mv	a1,s1
 5d2:	855a                	mv	a0,s6
 5d4:	e49ff0ef          	jal	41c <putc>
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf35                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e51ff0ef          	jal	43a <printint>
        i += 1;
 5ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b70d                	j	516 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5f6:	06400793          	li	a5,100
 5fa:	02f60763          	beq	a2,a5,628 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5fe:	07500793          	li	a5,117
 602:	06f60963          	beq	a2,a5,674 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 606:	07800793          	li	a5,120
 60a:	faf61ee3          	bne	a2,a5,5c6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e1fff0ef          	jal	43a <printint>
        i += 2;
 620:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	bdc5                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8493          	addi	s1,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e05ff0ef          	jal	43a <printint>
        i += 2;
 63a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bdd9                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000be583          	lwu	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	debff0ef          	jal	43a <printint>
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
 658:	bd7d                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	dd3ff0ef          	jal	43a <printint>
        i += 1;
 66c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
        i += 1;
 672:	b555                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	db9ff0ef          	jal	43a <printint>
        i += 2;
 686:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	b569                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4641                	li	a2,16
 696:	000be583          	lwu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d9fff0ef          	jal	43a <printint>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bd8d                	j	516 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	d87ff0ef          	jal	43a <printint>
        i += 1;
 6b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	bda1                	j	516 <vprintf+0x4a>
 6c0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c2:	008b8d13          	addi	s10,s7,8
 6c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ca:	03000593          	li	a1,48
 6ce:	855a                	mv	a0,s6
 6d0:	d4dff0ef          	jal	41c <putc>
  putc(fd, 'x');
 6d4:	07800593          	li	a1,120
 6d8:	855a                	mv	a0,s6
 6da:	d43ff0ef          	jal	41c <putc>
 6de:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e0:	00000b97          	auipc	s7,0x0
 6e4:	2e0b8b93          	addi	s7,s7,736 # 9c0 <digits>
 6e8:	03c9d793          	srli	a5,s3,0x3c
 6ec:	97de                	add	a5,a5,s7
 6ee:	0007c583          	lbu	a1,0(a5)
 6f2:	855a                	mv	a0,s6
 6f4:	d29ff0ef          	jal	41c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f8:	0992                	slli	s3,s3,0x4
 6fa:	34fd                	addiw	s1,s1,-1
 6fc:	f4f5                	bnez	s1,6e8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6fe:	8bea                	mv	s7,s10
      state = 0;
 700:	4981                	li	s3,0
 702:	6d02                	ld	s10,0(sp)
 704:	bd09                	j	516 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 706:	008b8493          	addi	s1,s7,8
 70a:	000bc583          	lbu	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	d0dff0ef          	jal	41c <putc>
 714:	8ba6                	mv	s7,s1
      state = 0;
 716:	4981                	li	s3,0
 718:	bbfd                	j	516 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 71a:	008b8993          	addi	s3,s7,8
 71e:	000bb483          	ld	s1,0(s7)
 722:	cc91                	beqz	s1,73e <vprintf+0x272>
        for (; *s; s++)
 724:	0004c583          	lbu	a1,0(s1)
 728:	c195                	beqz	a1,74c <vprintf+0x280>
          putc(fd, *s);
 72a:	855a                	mv	a0,s6
 72c:	cf1ff0ef          	jal	41c <putc>
        for (; *s; s++)
 730:	0485                	addi	s1,s1,1
 732:	0004c583          	lbu	a1,0(s1)
 736:	f9f5                	bnez	a1,72a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 738:	8bce                	mv	s7,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bbe9                	j	516 <vprintf+0x4a>
          s = "(null)";
 73e:	00000497          	auipc	s1,0x0
 742:	27a48493          	addi	s1,s1,634 # 9b8 <malloc+0x16a>
        for (; *s; s++)
 746:	02800593          	li	a1,40
 74a:	b7c5                	j	72a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 74c:	8bce                	mv	s7,s3
      state = 0;
 74e:	4981                	li	s3,0
 750:	b3d9                	j	516 <vprintf+0x4a>
 752:	6906                	ld	s2,64(sp)
 754:	79e2                	ld	s3,56(sp)
 756:	7a42                	ld	s4,48(sp)
 758:	7aa2                	ld	s5,40(sp)
 75a:	7b02                	ld	s6,32(sp)
 75c:	6be2                	ld	s7,24(sp)
 75e:	6c42                	ld	s8,16(sp)
 760:	6ca2                	ld	s9,8(sp)
    }
  }
}
 762:	60e6                	ld	ra,88(sp)
 764:	6446                	ld	s0,80(sp)
 766:	64a6                	ld	s1,72(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 76c:	715d                	addi	sp,sp,-80
 76e:	ec06                	sd	ra,24(sp)
 770:	e822                	sd	s0,16(sp)
 772:	1000                	addi	s0,sp,32
 774:	e010                	sd	a2,0(s0)
 776:	e414                	sd	a3,8(s0)
 778:	e818                	sd	a4,16(s0)
 77a:	ec1c                	sd	a5,24(s0)
 77c:	03043023          	sd	a6,32(s0)
 780:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 784:	8622                	mv	a2,s0
 786:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78a:	d43ff0ef          	jal	4cc <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6161                	addi	sp,sp,80
 794:	8082                	ret

0000000000000796 <printf>:

void
printf(const char *fmt, ...)
{
 796:	711d                	addi	sp,sp,-96
 798:	ec06                	sd	ra,24(sp)
 79a:	e822                	sd	s0,16(sp)
 79c:	1000                	addi	s0,sp,32
 79e:	e40c                	sd	a1,8(s0)
 7a0:	e810                	sd	a2,16(s0)
 7a2:	ec14                	sd	a3,24(s0)
 7a4:	f018                	sd	a4,32(s0)
 7a6:	f41c                	sd	a5,40(s0)
 7a8:	03043823          	sd	a6,48(s0)
 7ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b0:	00840613          	addi	a2,s0,8
 7b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b8:	85aa                	mv	a1,a0
 7ba:	4505                	li	a0,1
 7bc:	d11ff0ef          	jal	4cc <vprintf>
}
 7c0:	60e2                	ld	ra,24(sp)
 7c2:	6442                	ld	s0,16(sp)
 7c4:	6125                	addi	sp,sp,96
 7c6:	8082                	ret

00000000000007c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c8:	1141                	addi	sp,sp,-16
 7ca:	e406                	sd	ra,8(sp)
 7cc:	e022                	sd	s0,0(sp)
 7ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	00001797          	auipc	a5,0x1
 7d8:	82c7b783          	ld	a5,-2004(a5) # 1000 <freep>
 7dc:	a02d                	j	806 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7de:	4618                	lw	a4,8(a2)
 7e0:	9f2d                	addw	a4,a4,a1
 7e2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	6398                	ld	a4,0(a5)
 7e8:	6310                	ld	a2,0(a4)
 7ea:	a83d                	j	828 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9f31                	addw	a4,a4,a2
 7f2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f4:	ff053683          	ld	a3,-16(a0)
 7f8:	a091                	j	83c <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e7e463          	bltu	a5,a4,804 <free+0x3c>
 800:	00e6ea63          	bltu	a3,a4,814 <free+0x4c>
{
 804:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 806:	fed7fae3          	bgeu	a5,a3,7fa <free+0x32>
 80a:	6398                	ld	a4,0(a5)
 80c:	00e6e463          	bltu	a3,a4,814 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	fee7eae3          	bltu	a5,a4,804 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 814:	ff852583          	lw	a1,-8(a0)
 818:	6390                	ld	a2,0(a5)
 81a:	02059813          	slli	a6,a1,0x20
 81e:	01c85713          	srli	a4,a6,0x1c
 822:	9736                	add	a4,a4,a3
 824:	fae60de3          	beq	a2,a4,7de <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 82c:	4790                	lw	a2,8(a5)
 82e:	02061593          	slli	a1,a2,0x20
 832:	01c5d713          	srli	a4,a1,0x1c
 836:	973e                	add	a4,a4,a5
 838:	fae68ae3          	beq	a3,a4,7ec <free+0x24>
    p->s.ptr = bp->s.ptr;
 83c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
}
 846:	60a2                	ld	ra,8(sp)
 848:	6402                	ld	s0,0(sp)
 84a:	0141                	addi	sp,sp,16
 84c:	8082                	ret

000000000000084e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 84e:	7139                	addi	sp,sp,-64
 850:	fc06                	sd	ra,56(sp)
 852:	f822                	sd	s0,48(sp)
 854:	f04a                	sd	s2,32(sp)
 856:	ec4e                	sd	s3,24(sp)
 858:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 85a:	02051993          	slli	s3,a0,0x20
 85e:	0209d993          	srli	s3,s3,0x20
 862:	09bd                	addi	s3,s3,15
 864:	0049d993          	srli	s3,s3,0x4
 868:	2985                	addiw	s3,s3,1
 86a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 86c:	00000517          	auipc	a0,0x0
 870:	79453503          	ld	a0,1940(a0) # 1000 <freep>
 874:	c905                	beqz	a0,8a4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 876:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 878:	4798                	lw	a4,8(a5)
 87a:	09377663          	bgeu	a4,s3,906 <malloc+0xb8>
 87e:	f426                	sd	s1,40(sp)
 880:	e852                	sd	s4,16(sp)
 882:	e456                	sd	s5,8(sp)
 884:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 886:	8a4e                	mv	s4,s3
 888:	6705                	lui	a4,0x1
 88a:	00e9f363          	bgeu	s3,a4,890 <malloc+0x42>
 88e:	6a05                	lui	s4,0x1
 890:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 894:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 898:	00000497          	auipc	s1,0x0
 89c:	76848493          	addi	s1,s1,1896 # 1000 <freep>
  if (p == SBRK_ERROR)
 8a0:	5afd                	li	s5,-1
 8a2:	a83d                	j	8e0 <malloc+0x92>
 8a4:	f426                	sd	s1,40(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ac:	00001797          	auipc	a5,0x1
 8b0:	95c78793          	addi	a5,a5,-1700 # 1208 <base>
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
 8bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8be:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8c2:	b7d1                	j	886 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	e118                	sd	a4,0(a0)
 8c8:	a899                	j	91e <malloc+0xd0>
  hp->s.size = nu;
 8ca:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8ce:	0541                	addi	a0,a0,16
 8d0:	ef9ff0ef          	jal	7c8 <free>
  return freep;
 8d4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8d6:	c125                	beqz	a0,936 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8d8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8da:	4798                	lw	a4,8(a5)
 8dc:	03277163          	bgeu	a4,s2,8fe <malloc+0xb0>
    if (p == freep)
 8e0:	6098                	ld	a4,0(s1)
 8e2:	853e                	mv	a0,a5
 8e4:	fef71ae3          	bne	a4,a5,8d8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8e8:	8552                	mv	a0,s4
 8ea:	a37ff0ef          	jal	320 <sbrk>
  if (p == SBRK_ERROR)
 8ee:	fd551ee3          	bne	a0,s5,8ca <malloc+0x7c>
        return 0;
 8f2:	4501                	li	a0,0
 8f4:	74a2                	ld	s1,40(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
 8fc:	a03d                	j	92a <malloc+0xdc>
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 906:	fae90fe3          	beq	s2,a4,8c4 <malloc+0x76>
        p->s.size -= nunits;
 90a:	4137073b          	subw	a4,a4,s3
 90e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 910:	02071693          	slli	a3,a4,0x20
 914:	01c6d713          	srli	a4,a3,0x1c
 918:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 91e:	00000717          	auipc	a4,0x0
 922:	6ea73123          	sd	a0,1762(a4) # 1000 <freep>
      return (void *)(p + 1);
 926:	01078513          	addi	a0,a5,16
  }
}
 92a:	70e2                	ld	ra,56(sp)
 92c:	7442                	ld	s0,48(sp)
 92e:	7902                	ld	s2,32(sp)
 930:	69e2                	ld	s3,24(sp)
 932:	6121                	addi	sp,sp,64
 934:	8082                	ret
 936:	74a2                	ld	s1,40(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
 93e:	b7f5                	j	92a <malloc+0xdc>
