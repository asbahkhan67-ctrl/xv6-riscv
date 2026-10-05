
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";

  if ((fd = open(ff, O_CREATE | O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	97050513          	addi	a0,a0,-1680 # 980 <malloc+0xf8>
  18:	3b6000ef          	jal	3ce <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if (fstat(fd, &st) < 0) {
  20:	fc840593          	addi	a1,s0,-56
  24:	3c2000ef          	jal	3e6 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	95450513          	addi	a0,a0,-1708 # 980 <malloc+0xf8>
  34:	3aa000ef          	jal	3de <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	94250513          	addi	a0,a0,-1726 # 980 <malloc+0xf8>
  46:	388000ef          	jal	3ce <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	98e50513          	addi	a0,a0,-1650 # 9e0 <malloc+0x158>
  5a:	776000ef          	jal	7d0 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	32e000ef          	jal	38e <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	92a50513          	addi	a0,a0,-1750 # 990 <malloc+0x108>
  6e:	762000ef          	jal	7d0 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	31a000ef          	jal	38e <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	93068693          	addi	a3,a3,-1744 # 9a8 <malloc+0x120>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	92e58593          	addi	a1,a1,-1746 # 9b0 <malloc+0x128>
  8a:	4509                	li	a0,2
  8c:	71a000ef          	jal	7a6 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2fc000ef          	jal	38e <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	93050513          	addi	a0,a0,-1744 # 9c8 <malloc+0x140>
  a0:	730000ef          	jal	7d0 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2e8000ef          	jal	38e <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	94a50513          	addi	a0,a0,-1718 # 9f8 <malloc+0x170>
  b6:	71a000ef          	jal	7d0 <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	35e000ef          	jal	41e <pause>
  for (;;)
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	f33ff0ef          	jal	0 <main>
  exit(r);
  d2:	2bc000ef          	jal	38e <exit>

00000000000000d6 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0xa>
    ;
  return os;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb91                	beqz	a5,116 <strcmp+0x20>
 104:	0005c703          	lbu	a4,0(a1)
 108:	00f71763          	bne	a4,a5,116 <strcmp+0x20>
    p++, q++;
 10c:	0505                	addi	a0,a0,1
 10e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fbe5                	bnez	a5,104 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 116:	0005c503          	lbu	a0,0(a1)
}
 11a:	40a7853b          	subw	a0,a5,a0
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:

uint
strlen(const char *s)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf99                	beqz	a5,150 <strlen+0x2a>
 134:	0505                	addi	a0,a0,1
 136:	87aa                	mv	a5,a0
 138:	86be                	mv	a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	ff65                	bnez	a4,138 <strlen+0x12>
 142:	40a6853b          	subw	a0,a3,a0
 146:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 148:	60a2                	ld	ra,8(sp)
 14a:	6402                	ld	s0,0(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for (n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfdd                	j	148 <strlen+0x22>

0000000000000154 <memset>:

void *
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e406                	sd	ra,8(sp)
 158:	e022                	sd	s0,0(sp)
 15a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 15c:	ca19                	beqz	a2,172 <memset+0x1e>
 15e:	87aa                	mv	a5,a0
 160:	1602                	slli	a2,a2,0x20
 162:	9201                	srli	a2,a2,0x20
 164:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 168:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 16c:	0785                	addi	a5,a5,1
 16e:	fee79de3          	bne	a5,a4,168 <memset+0x14>
  }
  return dst;
}
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strchr>:

char *
strchr(const char *s, char c)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  for (; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf81                	beqz	a5,19e <strchr+0x24>
    if (*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1c>
  for (; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xe>
      return (char *)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	60a2                	ld	ra,8(sp)
 198:	6402                	ld	s0,0(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfdd                	j	196 <strchr+0x1c>

00000000000001a2 <gets>:

char *
gets(char *buf, int max)
{
 1a2:	7159                	addi	sp,sp,-112
 1a4:	f486                	sd	ra,104(sp)
 1a6:	f0a2                	sd	s0,96(sp)
 1a8:	eca6                	sd	s1,88(sp)
 1aa:	e8ca                	sd	s2,80(sp)
 1ac:	e4ce                	sd	s3,72(sp)
 1ae:	e0d2                	sd	s4,64(sp)
 1b0:	fc56                	sd	s5,56(sp)
 1b2:	f85a                	sd	s6,48(sp)
 1b4:	f45e                	sd	s7,40(sp)
 1b6:	f062                	sd	s8,32(sp)
 1b8:	ec66                	sd	s9,24(sp)
 1ba:	e86a                	sd	s10,16(sp)
 1bc:	1880                	addi	s0,sp,112
 1be:	8caa                	mv	s9,a0
 1c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c6:	f9f40b13          	addi	s6,s0,-97
 1ca:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1cc:	4ba9                	li	s7,10
 1ce:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 1d0:	8d26                	mv	s10,s1
 1d2:	0014899b          	addiw	s3,s1,1
 1d6:	84ce                	mv	s1,s3
 1d8:	0349d563          	bge	s3,s4,202 <gets+0x60>
    cc = read(0, &c, 1);
 1dc:	8656                	mv	a2,s5
 1de:	85da                	mv	a1,s6
 1e0:	4501                	li	a0,0
 1e2:	1c4000ef          	jal	3a6 <read>
    if (cc < 1)
 1e6:	00a05e63          	blez	a0,202 <gets+0x60>
    buf[i++] = c;
 1ea:	f9f44783          	lbu	a5,-97(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f2:	01778763          	beq	a5,s7,200 <gets+0x5e>
 1f6:	0905                	addi	s2,s2,1
 1f8:	fd879ce3          	bne	a5,s8,1d0 <gets+0x2e>
    buf[i++] = c;
 1fc:	8d4e                	mv	s10,s3
 1fe:	a011                	j	202 <gets+0x60>
 200:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 202:	9d66                	add	s10,s10,s9
 204:	000d0023          	sb	zero,0(s10)
  return buf;
}
 208:	8566                	mv	a0,s9
 20a:	70a6                	ld	ra,104(sp)
 20c:	7406                	ld	s0,96(sp)
 20e:	64e6                	ld	s1,88(sp)
 210:	6946                	ld	s2,80(sp)
 212:	69a6                	ld	s3,72(sp)
 214:	6a06                	ld	s4,64(sp)
 216:	7ae2                	ld	s5,56(sp)
 218:	7b42                	ld	s6,48(sp)
 21a:	7ba2                	ld	s7,40(sp)
 21c:	7c02                	ld	s8,32(sp)
 21e:	6ce2                	ld	s9,24(sp)
 220:	6d42                	ld	s10,16(sp)
 222:	6165                	addi	sp,sp,112
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	addi	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	19a000ef          	jal	3ce <open>
  if (fd < 0)
 238:	02054263          	bltz	a0,25c <stat+0x36>
 23c:	e426                	sd	s1,8(sp)
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	1a4000ef          	jal	3e6 <fstat>
 246:	892a                	mv	s2,a0
  close(fd);
 248:	8526                	mv	a0,s1
 24a:	16c000ef          	jal	3b6 <close>
  return r;
 24e:	64a2                	ld	s1,8(sp)
}
 250:	854a                	mv	a0,s2
 252:	60e2                	ld	ra,24(sp)
 254:	6442                	ld	s0,16(sp)
 256:	6902                	ld	s2,0(sp)
 258:	6105                	addi	sp,sp,32
 25a:	8082                	ret
    return -1;
 25c:	597d                	li	s2,-1
 25e:	bfcd                	j	250 <stat+0x2a>

0000000000000260 <atoi>:

int
atoi(const char *s)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66963          	bltu	a2,a5,2a8 <atoi+0x48>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1e>
  return n;
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  n = 0;
 2a8:	4501                	li	a0,0
 2aa:	bfdd                	j	2a0 <atoi+0x40>

00000000000002ac <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b4:	02b57563          	bgeu	a0,a1,2de <memmove+0x32>
    while (n-- > 0)
 2b8:	00c05f63          	blez	a2,2d6 <memmove+0x2a>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c6:	0585                	addi	a1,a1,1
 2c8:	0705                	addi	a4,a4,1
 2ca:	fff5c683          	lbu	a3,-1(a1)
 2ce:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
    dst += n;
 2de:	00c50733          	add	a4,a0,a2
    src += n;
 2e2:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2e4:	fec059e3          	blez	a2,2d6 <memmove+0x2a>
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	fff7c793          	not	a5,a5
 2f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f6:	15fd                	addi	a1,a1,-1
 2f8:	177d                	addi	a4,a4,-1
 2fa:	0005c683          	lbu	a3,0(a1)
 2fe:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x4a>
 306:	bfc1                	j	2d6 <memmove+0x2a>

0000000000000308 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	ca0d                	beqz	a2,342 <memcmp+0x3a>
 312:	fff6069b          	addiw	a3,a2,-1
 316:	1682                	slli	a3,a3,0x20
 318:	9281                	srli	a3,a3,0x20
 31a:	0685                	addi	a3,a3,1
 31c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x16>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x32>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfdd                	j	33a <memcmp+0x32>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	f5fff0ef          	jal	2ac <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrk>:

char *
sbrk(int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 362:	4585                	li	a1,1
 364:	0b2000ef          	jal	416 <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <sbrklazy>:

char *
sbrklazy(int n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 378:	4589                	li	a1,2
 37a:	09c000ef          	jal	416 <sys_sbrk>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <pause>:
.global pause
pause:
 li a7, SYS_pause
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sync>:
.global sync
sync:
 li a7, SYS_sync
 42e:	48d9                	li	a7,22
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <ps>:
.global ps
ps:
 li a7, SYS_ps
 436:	48dd                	li	a7,23
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 43e:	48e1                	li	a7,24
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 446:	48e5                	li	a7,25
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 44e:	48e9                	li	a7,26
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 456:	1101                	addi	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	1000                	addi	s0,sp,32
 45e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 462:	4605                	li	a2,1
 464:	fef40593          	addi	a1,s0,-17
 468:	f47ff0ef          	jal	3ae <write>
}
 46c:	60e2                	ld	ra,24(sp)
 46e:	6442                	ld	s0,16(sp)
 470:	6105                	addi	sp,sp,32
 472:	8082                	ret

0000000000000474 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 474:	715d                	addi	sp,sp,-80
 476:	e486                	sd	ra,72(sp)
 478:	e0a2                	sd	s0,64(sp)
 47a:	fc26                	sd	s1,56(sp)
 47c:	f84a                	sd	s2,48(sp)
 47e:	f44e                	sd	s3,40(sp)
 480:	0880                	addi	s0,sp,80
 482:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 484:	c299                	beqz	a3,48a <printint+0x16>
 486:	0605cc63          	bltz	a1,4fe <printint+0x8a>
  neg = 0;
 48a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 48c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 490:	869a                	mv	a3,t1
  i = 0;
 492:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 494:	00000817          	auipc	a6,0x0
 498:	58c80813          	addi	a6,a6,1420 # a20 <digits>
 49c:	88be                	mv	a7,a5
 49e:	0017851b          	addiw	a0,a5,1
 4a2:	87aa                	mv	a5,a0
 4a4:	02c5f733          	remu	a4,a1,a2
 4a8:	9742                	add	a4,a4,a6
 4aa:	00074703          	lbu	a4,0(a4)
 4ae:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4b2:	872e                	mv	a4,a1
 4b4:	02c5d5b3          	divu	a1,a1,a2
 4b8:	0685                	addi	a3,a3,1
 4ba:	fec771e3          	bgeu	a4,a2,49c <printint+0x28>
  if (neg)
 4be:	000e0c63          	beqz	t3,4d6 <printint+0x62>
    buf[i++] = '-';
 4c2:	fd050793          	addi	a5,a0,-48
 4c6:	00878533          	add	a0,a5,s0
 4ca:	02d00793          	li	a5,45
 4ce:	fef50423          	sb	a5,-24(a0)
 4d2:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4d6:	fff7899b          	addiw	s3,a5,-1
 4da:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4de:	fff4c583          	lbu	a1,-1(s1)
 4e2:	854a                	mv	a0,s2
 4e4:	f73ff0ef          	jal	456 <putc>
  while (--i >= 0)
 4e8:	39fd                	addiw	s3,s3,-1
 4ea:	14fd                	addi	s1,s1,-1
 4ec:	fe09d9e3          	bgez	s3,4de <printint+0x6a>
}
 4f0:	60a6                	ld	ra,72(sp)
 4f2:	6406                	ld	s0,64(sp)
 4f4:	74e2                	ld	s1,56(sp)
 4f6:	7942                	ld	s2,48(sp)
 4f8:	79a2                	ld	s3,40(sp)
 4fa:	6161                	addi	sp,sp,80
 4fc:	8082                	ret
    x = -xx;
 4fe:	40b005b3          	neg	a1,a1
    neg = 1;
 502:	4e05                	li	t3,1
    x = -xx;
 504:	b761                	j	48c <printint+0x18>

0000000000000506 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 506:	711d                	addi	sp,sp,-96
 508:	ec86                	sd	ra,88(sp)
 50a:	e8a2                	sd	s0,80(sp)
 50c:	e4a6                	sd	s1,72(sp)
 50e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 510:	0005c483          	lbu	s1,0(a1)
 514:	28048463          	beqz	s1,79c <vprintf+0x296>
 518:	e0ca                	sd	s2,64(sp)
 51a:	fc4e                	sd	s3,56(sp)
 51c:	f852                	sd	s4,48(sp)
 51e:	f456                	sd	s5,40(sp)
 520:	f05a                	sd	s6,32(sp)
 522:	ec5e                	sd	s7,24(sp)
 524:	e862                	sd	s8,16(sp)
 526:	e466                	sd	s9,8(sp)
 528:	8b2a                	mv	s6,a0
 52a:	8a2e                	mv	s4,a1
 52c:	8bb2                	mv	s7,a2
  state = 0;
 52e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 530:	4901                	li	s2,0
 532:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 534:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 538:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 53c:	06c00c93          	li	s9,108
 540:	a00d                	j	562 <vprintf+0x5c>
        putc(fd, c0);
 542:	85a6                	mv	a1,s1
 544:	855a                	mv	a0,s6
 546:	f11ff0ef          	jal	456 <putc>
 54a:	a019                	j	550 <vprintf+0x4a>
    } else if (state == '%') {
 54c:	03598363          	beq	s3,s5,572 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 550:	0019079b          	addiw	a5,s2,1
 554:	893e                	mv	s2,a5
 556:	873e                	mv	a4,a5
 558:	97d2                	add	a5,a5,s4
 55a:	0007c483          	lbu	s1,0(a5)
 55e:	22048763          	beqz	s1,78c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 562:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 566:	fe0993e3          	bnez	s3,54c <vprintf+0x46>
      if (c0 == '%') {
 56a:	fd579ce3          	bne	a5,s5,542 <vprintf+0x3c>
        state = '%';
 56e:	89be                	mv	s3,a5
 570:	b7c5                	j	550 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 572:	00ea06b3          	add	a3,s4,a4
 576:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57a:	8636                	mv	a2,a3
      if (c1)
 57c:	c681                	beqz	a3,584 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 57e:	9752                	add	a4,a4,s4
 580:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 584:	05878263          	beq	a5,s8,5c8 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 588:	05978c63          	beq	a5,s9,5e0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 58c:	07500713          	li	a4,117
 590:	0ee78663          	beq	a5,a4,67c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 594:	07800713          	li	a4,120
 598:	12e78863          	beq	a5,a4,6c8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 59c:	07000713          	li	a4,112
 5a0:	14e78d63          	beq	a5,a4,6fa <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5a4:	06300713          	li	a4,99
 5a8:	18e78c63          	beq	a5,a4,740 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ac:	07300713          	li	a4,115
 5b0:	1ae78263          	beq	a5,a4,754 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5b4:	02500713          	li	a4,37
 5b8:	04e79463          	bne	a5,a4,600 <vprintf+0xfa>
        putc(fd, '%');
 5bc:	85ba                	mv	a1,a4
 5be:	855a                	mv	a0,s6
 5c0:	e97ff0ef          	jal	456 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b769                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e9fff0ef          	jal	474 <printint>
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bf8d                	j	550 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5e0:	06400793          	li	a5,100
 5e4:	02f68963          	beq	a3,a5,616 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5e8:	06c00793          	li	a5,108
 5ec:	04f68263          	beq	a3,a5,630 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5f0:	07500793          	li	a5,117
 5f4:	0af68063          	beq	a3,a5,694 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5f8:	07800793          	li	a5,120
 5fc:	0ef68263          	beq	a3,a5,6e0 <vprintf+0x1da>
        putc(fd, '%');
 600:	02500593          	li	a1,37
 604:	855a                	mv	a0,s6
 606:	e51ff0ef          	jal	456 <putc>
        putc(fd, c0);
 60a:	85a6                	mv	a1,s1
 60c:	855a                	mv	a0,s6
 60e:	e49ff0ef          	jal	456 <putc>
      state = 0;
 612:	4981                	li	s3,0
 614:	bf35                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	008b8493          	addi	s1,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e51ff0ef          	jal	474 <printint>
        i += 1;
 628:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
        i += 1;
 62e:	b70d                	j	550 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 630:	06400793          	li	a5,100
 634:	02f60763          	beq	a2,a5,662 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 638:	07500793          	li	a5,117
 63c:	06f60963          	beq	a2,a5,6ae <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 640:	07800793          	li	a5,120
 644:	faf61ee3          	bne	a2,a5,600 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e1fff0ef          	jal	474 <printint>
        i += 2;
 65a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
        i += 2;
 660:	bdc5                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 662:	008b8493          	addi	s1,s7,8
 666:	4685                	li	a3,1
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e05ff0ef          	jal	474 <printint>
        i += 2;
 674:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	bdd9                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000be583          	lwu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	debff0ef          	jal	474 <printint>
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	bd7d                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4629                	li	a2,10
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	dd3ff0ef          	jal	474 <printint>
        i += 1;
 6a6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
        i += 1;
 6ac:	b555                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	db9ff0ef          	jal	474 <printint>
        i += 2;
 6c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	b569                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000be583          	lwu	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	d9fff0ef          	jal	474 <printint>
 6da:	8ba6                	mv	s7,s1
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bd8d                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e0:	008b8493          	addi	s1,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4641                	li	a2,16
 6e8:	000bb583          	ld	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	d87ff0ef          	jal	474 <printint>
        i += 1;
 6f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f4:	8ba6                	mv	s7,s1
      state = 0;
 6f6:	4981                	li	s3,0
        i += 1;
 6f8:	bda1                	j	550 <vprintf+0x4a>
 6fa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6fc:	008b8d13          	addi	s10,s7,8
 700:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 704:	03000593          	li	a1,48
 708:	855a                	mv	a0,s6
 70a:	d4dff0ef          	jal	456 <putc>
  putc(fd, 'x');
 70e:	07800593          	li	a1,120
 712:	855a                	mv	a0,s6
 714:	d43ff0ef          	jal	456 <putc>
 718:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71a:	00000b97          	auipc	s7,0x0
 71e:	306b8b93          	addi	s7,s7,774 # a20 <digits>
 722:	03c9d793          	srli	a5,s3,0x3c
 726:	97de                	add	a5,a5,s7
 728:	0007c583          	lbu	a1,0(a5)
 72c:	855a                	mv	a0,s6
 72e:	d29ff0ef          	jal	456 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	0992                	slli	s3,s3,0x4
 734:	34fd                	addiw	s1,s1,-1
 736:	f4f5                	bnez	s1,722 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 738:	8bea                	mv	s7,s10
      state = 0;
 73a:	4981                	li	s3,0
 73c:	6d02                	ld	s10,0(sp)
 73e:	bd09                	j	550 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 740:	008b8493          	addi	s1,s7,8
 744:	000bc583          	lbu	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	d0dff0ef          	jal	456 <putc>
 74e:	8ba6                	mv	s7,s1
      state = 0;
 750:	4981                	li	s3,0
 752:	bbfd                	j	550 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 754:	008b8993          	addi	s3,s7,8
 758:	000bb483          	ld	s1,0(s7)
 75c:	cc91                	beqz	s1,778 <vprintf+0x272>
        for (; *s; s++)
 75e:	0004c583          	lbu	a1,0(s1)
 762:	c195                	beqz	a1,786 <vprintf+0x280>
          putc(fd, *s);
 764:	855a                	mv	a0,s6
 766:	cf1ff0ef          	jal	456 <putc>
        for (; *s; s++)
 76a:	0485                	addi	s1,s1,1
 76c:	0004c583          	lbu	a1,0(s1)
 770:	f9f5                	bnez	a1,764 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 772:	8bce                	mv	s7,s3
      state = 0;
 774:	4981                	li	s3,0
 776:	bbe9                	j	550 <vprintf+0x4a>
          s = "(null)";
 778:	00000497          	auipc	s1,0x0
 77c:	2a048493          	addi	s1,s1,672 # a18 <malloc+0x190>
        for (; *s; s++)
 780:	02800593          	li	a1,40
 784:	b7c5                	j	764 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 786:	8bce                	mv	s7,s3
      state = 0;
 788:	4981                	li	s3,0
 78a:	b3d9                	j	550 <vprintf+0x4a>
 78c:	6906                	ld	s2,64(sp)
 78e:	79e2                	ld	s3,56(sp)
 790:	7a42                	ld	s4,48(sp)
 792:	7aa2                	ld	s5,40(sp)
 794:	7b02                	ld	s6,32(sp)
 796:	6be2                	ld	s7,24(sp)
 798:	6c42                	ld	s8,16(sp)
 79a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 79c:	60e6                	ld	ra,88(sp)
 79e:	6446                	ld	s0,80(sp)
 7a0:	64a6                	ld	s1,72(sp)
 7a2:	6125                	addi	sp,sp,96
 7a4:	8082                	ret

00000000000007a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a6:	715d                	addi	sp,sp,-80
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e010                	sd	a2,0(s0)
 7b0:	e414                	sd	a3,8(s0)
 7b2:	e818                	sd	a4,16(s0)
 7b4:	ec1c                	sd	a5,24(s0)
 7b6:	03043023          	sd	a6,32(s0)
 7ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	8622                	mv	a2,s0
 7c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c4:	d43ff0ef          	jal	506 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6161                	addi	sp,sp,80
 7ce:	8082                	ret

00000000000007d0 <printf>:

void
printf(const char *fmt, ...)
{
 7d0:	711d                	addi	sp,sp,-96
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e40c                	sd	a1,8(s0)
 7da:	e810                	sd	a2,16(s0)
 7dc:	ec14                	sd	a3,24(s0)
 7de:	f018                	sd	a4,32(s0)
 7e0:	f41c                	sd	a5,40(s0)
 7e2:	03043823          	sd	a6,48(s0)
 7e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	00840613          	addi	a2,s0,8
 7ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f2:	85aa                	mv	a1,a0
 7f4:	4505                	li	a0,1
 7f6:	d11ff0ef          	jal	506 <vprintf>
}
 7fa:	60e2                	ld	ra,24(sp)
 7fc:	6442                	ld	s0,16(sp)
 7fe:	6125                	addi	sp,sp,96
 800:	8082                	ret

0000000000000802 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 802:	1141                	addi	sp,sp,-16
 804:	e406                	sd	ra,8(sp)
 806:	e022                	sd	s0,0(sp)
 808:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 80a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	00000797          	auipc	a5,0x0
 812:	7f27b783          	ld	a5,2034(a5) # 1000 <freep>
 816:	a02d                	j	840 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 818:	4618                	lw	a4,8(a2)
 81a:	9f2d                	addw	a4,a4,a1
 81c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	6310                	ld	a2,0(a4)
 824:	a83d                	j	862 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9f31                	addw	a4,a4,a2
 82c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053683          	ld	a3,-16(a0)
 832:	a091                	j	876 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	6398                	ld	a4,0(a5)
 836:	00e7e463          	bltu	a5,a4,83e <free+0x3c>
 83a:	00e6ea63          	bltu	a3,a4,84e <free+0x4c>
{
 83e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	fed7fae3          	bgeu	a5,a3,834 <free+0x32>
 844:	6398                	ld	a4,0(a5)
 846:	00e6e463          	bltu	a3,a4,84e <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	fee7eae3          	bltu	a5,a4,83e <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	slli	a6,a1,0x20
 858:	01c85713          	srli	a4,a6,0x1c
 85c:	9736                	add	a4,a4,a3
 85e:	fae60de3          	beq	a2,a4,818 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	slli	a1,a2,0x20
 86c:	01c5d713          	srli	a4,a1,0x1c
 870:	973e                	add	a4,a4,a5
 872:	fae68ae3          	beq	a3,a4,826 <free+0x24>
    p->s.ptr = bp->s.ptr;
 876:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
}
 880:	60a2                	ld	ra,8(sp)
 882:	6402                	ld	s0,0(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f04a                	sd	s2,32(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 894:	02051993          	slli	s3,a0,0x20
 898:	0209d993          	srli	s3,s3,0x20
 89c:	09bd                	addi	s3,s3,15
 89e:	0049d993          	srli	s3,s3,0x4
 8a2:	2985                	addiw	s3,s3,1
 8a4:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8a6:	00000517          	auipc	a0,0x0
 8aa:	75a53503          	ld	a0,1882(a0) # 1000 <freep>
 8ae:	c905                	beqz	a0,8de <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b2:	4798                	lw	a4,8(a5)
 8b4:	09377663          	bgeu	a4,s3,940 <malloc+0xb8>
 8b8:	f426                	sd	s1,40(sp)
 8ba:	e852                	sd	s4,16(sp)
 8bc:	e456                	sd	s5,8(sp)
 8be:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8c0:	8a4e                	mv	s4,s3
 8c2:	6705                	lui	a4,0x1
 8c4:	00e9f363          	bgeu	s3,a4,8ca <malloc+0x42>
 8c8:	6a05                	lui	s4,0x1
 8ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8d2:	00000497          	auipc	s1,0x0
 8d6:	72e48493          	addi	s1,s1,1838 # 1000 <freep>
  if (p == SBRK_ERROR)
 8da:	5afd                	li	s5,-1
 8dc:	a83d                	j	91a <malloc+0x92>
 8de:	f426                	sd	s1,40(sp)
 8e0:	e852                	sd	s4,16(sp)
 8e2:	e456                	sd	s5,8(sp)
 8e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e6:	00001797          	auipc	a5,0x1
 8ea:	92278793          	addi	a5,a5,-1758 # 1208 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8fc:	b7d1                	j	8c0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	e118                	sd	a4,0(a0)
 902:	a899                	j	958 <malloc+0xd0>
  hp->s.size = nu;
 904:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 908:	0541                	addi	a0,a0,16
 90a:	ef9ff0ef          	jal	802 <free>
  return freep;
 90e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 910:	c125                	beqz	a0,970 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 912:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 914:	4798                	lw	a4,8(a5)
 916:	03277163          	bgeu	a4,s2,938 <malloc+0xb0>
    if (p == freep)
 91a:	6098                	ld	a4,0(s1)
 91c:	853e                	mv	a0,a5
 91e:	fef71ae3          	bne	a4,a5,912 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 922:	8552                	mv	a0,s4
 924:	a37ff0ef          	jal	35a <sbrk>
  if (p == SBRK_ERROR)
 928:	fd551ee3          	bne	a0,s5,904 <malloc+0x7c>
        return 0;
 92c:	4501                	li	a0,0
 92e:	74a2                	ld	s1,40(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	a03d                	j	964 <malloc+0xdc>
 938:	74a2                	ld	s1,40(sp)
 93a:	6a42                	ld	s4,16(sp)
 93c:	6aa2                	ld	s5,8(sp)
 93e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 940:	fae90fe3          	beq	s2,a4,8fe <malloc+0x76>
        p->s.size -= nunits;
 944:	4137073b          	subw	a4,a4,s3
 948:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94a:	02071693          	slli	a3,a4,0x20
 94e:	01c6d713          	srli	a4,a3,0x1c
 952:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 954:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 958:	00000717          	auipc	a4,0x0
 95c:	6aa73423          	sd	a0,1704(a4) # 1000 <freep>
      return (void *)(p + 1);
 960:	01078513          	addi	a0,a5,16
  }
}
 964:	70e2                	ld	ra,56(sp)
 966:	7442                	ld	s0,48(sp)
 968:	7902                	ld	s2,32(sp)
 96a:	69e2                	ld	s3,24(sp)
 96c:	6121                	addi	sp,sp,64
 96e:	8082                	ret
 970:	74a2                	ld	s1,40(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
 978:	b7f5                	j	964 <malloc+0xdc>
