
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
<<<<<<< HEAD
  14:	9c050513          	addi	a0,a0,-1600 # 9d0 <malloc+0xfc>
=======
  14:	9e050513          	addi	a0,a0,-1568 # 9f0 <malloc+0xfe>
>>>>>>> e18456e (Updated xv6-riscv)
  18:	380000ef          	jal	398 <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if (fstat(fd, &st) < 0) {
  20:	fc840593          	addi	a1,s0,-56
  24:	38c000ef          	jal	3b0 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  30:	9a450513          	addi	a0,a0,-1628 # 9d0 <malloc+0xfc>
=======
  30:	9c450513          	addi	a0,a0,-1596 # 9f0 <malloc+0xfe>
>>>>>>> e18456e (Updated xv6-riscv)
  34:	374000ef          	jal	3a8 <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  42:	99250513          	addi	a0,a0,-1646 # 9d0 <malloc+0xfc>
=======
  42:	9b250513          	addi	a0,a0,-1614 # 9f0 <malloc+0xfe>
>>>>>>> e18456e (Updated xv6-riscv)
  46:	352000ef          	jal	398 <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  56:	9de50513          	addi	a0,a0,-1570 # a30 <malloc+0x15c>
  5a:	7c6000ef          	jal	820 <printf>
=======
  56:	9fe50513          	addi	a0,a0,-1538 # a50 <malloc+0x15e>
  5a:	7e4000ef          	jal	83e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  5e:	4505                	li	a0,1
  60:	2f8000ef          	jal	358 <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  6a:	97a50513          	addi	a0,a0,-1670 # 9e0 <malloc+0x10c>
  6e:	7b2000ef          	jal	820 <printf>
=======
  6a:	99a50513          	addi	a0,a0,-1638 # a00 <malloc+0x10e>
  6e:	7d0000ef          	jal	83e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  72:	4505                	li	a0,1
  74:	2e4000ef          	jal	358 <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
<<<<<<< HEAD
  7c:	98068693          	addi	a3,a3,-1664 # 9f8 <malloc+0x124>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	97e58593          	addi	a1,a1,-1666 # a00 <malloc+0x12c>
  8a:	4509                	li	a0,2
  8c:	76a000ef          	jal	7f6 <fprintf>
=======
  7c:	9a068693          	addi	a3,a3,-1632 # a18 <malloc+0x126>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	99e58593          	addi	a1,a1,-1634 # a20 <malloc+0x12e>
  8a:	4509                	li	a0,2
  8c:	788000ef          	jal	814 <fprintf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  90:	4505                	li	a0,1
  92:	2c6000ef          	jal	358 <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  9c:	98050513          	addi	a0,a0,-1664 # a18 <malloc+0x144>
  a0:	780000ef          	jal	820 <printf>
=======
  9c:	9a050513          	addi	a0,a0,-1632 # a38 <malloc+0x146>
  a0:	79e000ef          	jal	83e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2b2000ef          	jal	358 <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  b2:	99a50513          	addi	a0,a0,-1638 # a48 <malloc+0x174>
  b6:	76a000ef          	jal	820 <printf>
=======
  b2:	9ba50513          	addi	a0,a0,-1606 # a68 <malloc+0x176>
  b6:	788000ef          	jal	83e <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  // sit around until killed
  for (;;)
    pause(1000);
  ba:	3e800513          	li	a0,1000
  be:	32a000ef          	jal	3e8 <pause>
  for (;;)
  c2:	bfe5                	j	ba <main+0xba>

00000000000000c4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  cc:	f35ff0ef          	jal	0 <main>
  exit(r);
  d0:	288000ef          	jal	358 <exit>

00000000000000d4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0x8>
    ;
  return os;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	1141                	addi	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x1e>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x1e>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf91                	beqz	a5,142 <strlen+0x26>
 128:	0505                	addi	a0,a0,1
 12a:	87aa                	mv	a5,a0
 12c:	86be                	mv	a3,a5
 12e:	0785                	addi	a5,a5,1
 130:	fff7c703          	lbu	a4,-1(a5)
 134:	ff65                	bnez	a4,12c <strlen+0x10>
 136:	40a6853b          	subw	a0,a3,a0
 13a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  for (n = 0; s[n]; n++)
 142:	4501                	li	a0,0
 144:	bfe5                	j	13c <strlen+0x20>

0000000000000146 <memset>:

void *
memset(void *dst, int c, uint n)
{
 146:	1141                	addi	sp,sp,-16
 148:	e422                	sd	s0,8(sp)
 14a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 14c:	ca19                	beqz	a2,162 <memset+0x1c>
 14e:	87aa                	mv	a5,a0
 150:	1602                	slli	a2,a2,0x20
 152:	9201                	srli	a2,a2,0x20
 154:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 158:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 15c:	0785                	addi	a5,a5,1
 15e:	fee79de3          	bne	a5,a4,158 <memset+0x12>
  }
  return dst;
}
 162:	6422                	ld	s0,8(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strchr>:

char *
strchr(const char *s, char c)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 16e:	00054783          	lbu	a5,0(a0)
 172:	cb99                	beqz	a5,188 <strchr+0x20>
    if (*s == c)
 174:	00f58763          	beq	a1,a5,182 <strchr+0x1a>
  for (; *s; s++)
 178:	0505                	addi	a0,a0,1
 17a:	00054783          	lbu	a5,0(a0)
 17e:	fbfd                	bnez	a5,174 <strchr+0xc>
      return (char *)s;
  return 0;
 180:	4501                	li	a0,0
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret
  return 0;
 188:	4501                	li	a0,0
 18a:	bfe5                	j	182 <strchr+0x1a>

000000000000018c <gets>:

char *
gets(char *buf, int max)
{
 18c:	711d                	addi	sp,sp,-96
 18e:	ec86                	sd	ra,88(sp)
 190:	e8a2                	sd	s0,80(sp)
 192:	e4a6                	sd	s1,72(sp)
 194:	e0ca                	sd	s2,64(sp)
 196:	fc4e                	sd	s3,56(sp)
 198:	f852                	sd	s4,48(sp)
 19a:	f456                	sd	s5,40(sp)
 19c:	f05a                	sd	s6,32(sp)
 19e:	ec5e                	sd	s7,24(sp)
 1a0:	1080                	addi	s0,sp,96
 1a2:	8baa                	mv	s7,a0
 1a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1a6:	892a                	mv	s2,a0
 1a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1aa:	4aa9                	li	s5,10
 1ac:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1ae:	89a6                	mv	s3,s1
 1b0:	2485                	addiw	s1,s1,1
 1b2:	0344d663          	bge	s1,s4,1de <gets+0x52>
    cc = read(0, &c, 1);
 1b6:	4605                	li	a2,1
 1b8:	faf40593          	addi	a1,s0,-81
 1bc:	4501                	li	a0,0
 1be:	1b2000ef          	jal	370 <read>
    if (cc < 1)
 1c2:	00a05e63          	blez	a0,1de <gets+0x52>
    buf[i++] = c;
 1c6:	faf44783          	lbu	a5,-81(s0)
 1ca:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1ce:	01578763          	beq	a5,s5,1dc <gets+0x50>
 1d2:	0905                	addi	s2,s2,1
 1d4:	fd679de3          	bne	a5,s6,1ae <gets+0x22>
    buf[i++] = c;
 1d8:	89a6                	mv	s3,s1
 1da:	a011                	j	1de <gets+0x52>
 1dc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1de:	99de                	add	s3,s3,s7
 1e0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e4:	855e                	mv	a0,s7
 1e6:	60e6                	ld	ra,88(sp)
 1e8:	6446                	ld	s0,80(sp)
 1ea:	64a6                	ld	s1,72(sp)
 1ec:	6906                	ld	s2,64(sp)
 1ee:	79e2                	ld	s3,56(sp)
 1f0:	7a42                	ld	s4,48(sp)
 1f2:	7aa2                	ld	s5,40(sp)
 1f4:	7b02                	ld	s6,32(sp)
 1f6:	6be2                	ld	s7,24(sp)
 1f8:	6125                	addi	sp,sp,96
 1fa:	8082                	ret

00000000000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	1101                	addi	sp,sp,-32
 1fe:	ec06                	sd	ra,24(sp)
 200:	e822                	sd	s0,16(sp)
 202:	e04a                	sd	s2,0(sp)
 204:	1000                	addi	s0,sp,32
 206:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 208:	4581                	li	a1,0
 20a:	18e000ef          	jal	398 <open>
  if (fd < 0)
 20e:	02054263          	bltz	a0,232 <stat+0x36>
 212:	e426                	sd	s1,8(sp)
 214:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 216:	85ca                	mv	a1,s2
 218:	198000ef          	jal	3b0 <fstat>
 21c:	892a                	mv	s2,a0
  close(fd);
 21e:	8526                	mv	a0,s1
 220:	160000ef          	jal	380 <close>
  return r;
 224:	64a2                	ld	s1,8(sp)
}
 226:	854a                	mv	a0,s2
 228:	60e2                	ld	ra,24(sp)
 22a:	6442                	ld	s0,16(sp)
 22c:	6902                	ld	s2,0(sp)
 22e:	6105                	addi	sp,sp,32
 230:	8082                	ret
    return -1;
 232:	597d                	li	s2,-1
 234:	bfcd                	j	226 <stat+0x2a>

0000000000000236 <atoi>:

int
atoi(const char *s)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 23c:	00054683          	lbu	a3,0(a0)
 240:	fd06879b          	addiw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	4625                	li	a2,9
 24a:	02f66863          	bltu	a2,a5,27a <atoi+0x44>
 24e:	872a                	mv	a4,a0
  n = 0;
 250:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 252:	0705                	addi	a4,a4,1
 254:	0025179b          	slliw	a5,a0,0x2
 258:	9fa9                	addw	a5,a5,a0
 25a:	0017979b          	slliw	a5,a5,0x1
 25e:	9fb5                	addw	a5,a5,a3
 260:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 264:	00074683          	lbu	a3,0(a4)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	fef671e3          	bgeu	a2,a5,252 <atoi+0x1c>
  return n;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  n = 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <atoi+0x3e>

000000000000027e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 284:	02b57463          	bgeu	a0,a1,2ac <memmove+0x2e>
    while (n-- > 0)
 288:	00c05f63          	blez	a2,2a6 <memmove+0x28>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 294:	872a                	mv	a4,a0
      *dst++ = *src++;
 296:	0585                	addi	a1,a1,1
 298:	0705                	addi	a4,a4,1
 29a:	fff5c683          	lbu	a3,-1(a1)
 29e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
    dst += n;
 2ac:	00c50733          	add	a4,a0,a2
    src += n;
 2b0:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2b2:	fec05ae3          	blez	a2,2a6 <memmove+0x28>
 2b6:	fff6079b          	addiw	a5,a2,-1
 2ba:	1782                	slli	a5,a5,0x20
 2bc:	9381                	srli	a5,a5,0x20
 2be:	fff7c793          	not	a5,a5
 2c2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c4:	15fd                	addi	a1,a1,-1
 2c6:	177d                	addi	a4,a4,-1
 2c8:	0005c683          	lbu	a3,0(a1)
 2cc:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2d0:	fee79ae3          	bne	a5,a4,2c4 <memmove+0x46>
 2d4:	bfc9                	j	2a6 <memmove+0x28>

00000000000002d6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e422                	sd	s0,8(sp)
 2da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2dc:	ca05                	beqz	a2,30c <memcmp+0x36>
 2de:	fff6069b          	addiw	a3,a2,-1
 2e2:	1682                	slli	a3,a3,0x20
 2e4:	9281                	srli	a3,a3,0x20
 2e6:	0685                	addi	a3,a3,1
 2e8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ea:	00054783          	lbu	a5,0(a0)
 2ee:	0005c703          	lbu	a4,0(a1)
 2f2:	00e79863          	bne	a5,a4,302 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f6:	0505                	addi	a0,a0,1
    p2++;
 2f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fa:	fed518e3          	bne	a0,a3,2ea <memcmp+0x14>
  }
  return 0;
 2fe:	4501                	li	a0,0
 300:	a019                	j	306 <memcmp+0x30>
      return *p1 - *p2;
 302:	40e7853b          	subw	a0,a5,a4
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  return 0;
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <memcmp+0x30>

0000000000000310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 318:	f67ff0ef          	jal	27e <memmove>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrk>:

char *
sbrk(int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 32c:	4585                	li	a1,1
 32e:	0b2000ef          	jal	3e0 <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <sbrklazy>:

char *
sbrklazy(int n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 342:	4589                	li	a1,2
 344:	09c000ef          	jal	3e0 <sys_sbrk>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 350:	4885                	li	a7,1
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exit>:
.global exit
exit:
 li a7, SYS_exit
 358:	4889                	li	a7,2
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <wait>:
.global wait
wait:
 li a7, SYS_wait
 360:	488d                	li	a7,3
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 368:	4891                	li	a7,4
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <read>:
.global read
read:
 li a7, SYS_read
 370:	4895                	li	a7,5
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <write>:
.global write
write:
 li a7, SYS_write
 378:	48c1                	li	a7,16
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <close>:
.global close
close:
 li a7, SYS_close
 380:	48d5                	li	a7,21
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <kill>:
.global kill
kill:
 li a7, SYS_kill
 388:	4899                	li	a7,6
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exec>:
.global exec
exec:
 li a7, SYS_exec
 390:	489d                	li	a7,7
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <open>:
.global open
open:
 li a7, SYS_open
 398:	48bd                	li	a7,15
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a0:	48c5                	li	a7,17
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a8:	48c9                	li	a7,18
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b0:	48a1                	li	a7,8
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <link>:
.global link
link:
 li a7, SYS_link
 3b8:	48cd                	li	a7,19
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c0:	48d1                	li	a7,20
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c8:	48a5                	li	a7,9
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d0:	48a9                	li	a7,10
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d8:	48ad                	li	a7,11
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3e0:	48b1                	li	a7,12
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e8:	48b5                	li	a7,13
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f0:	48b9                	li	a7,14
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3f8:	48d9                	li	a7,22
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <ps>:
.global ps
ps:
 li a7, SYS_ps
 400:	48dd                	li	a7,23
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 408:	48e1                	li	a7,24
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 410:	48e5                	li	a7,25
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 418:	48e9                	li	a7,26
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <trace>:
.global trace
trace:
 li a7, SYS_trace
 420:	48ed                	li	a7,27
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 428:	48f1                	li	a7,28
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 430:	48f5                	li	a7,29
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 438:	48f9                	li	a7,30
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 440:	48fd                	li	a7,31
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 448:	02000893          	li	a7,32
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <halt>:
.global halt
halt:
 li a7, SYS_halt
 452:	02100893          	li	a7,33
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 45c:	02200893          	li	a7,34
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 466:	02300893          	li	a7,35
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 470:	02400893          	li	a7,36
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 47a:	02500893          	li	a7,37
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 484:	02600893          	li	a7,38
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 48e:	02700893          	li	a7,39
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

<<<<<<< HEAD
0000000000000498 <putc>:
=======
0000000000000498 <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 498:	02800893          	li	a7,40
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 4a2:	02900893          	li	a7,41
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 4ac:	02a00893          	li	a7,42
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 498:	1101                	addi	sp,sp,-32
 49a:	ec06                	sd	ra,24(sp)
 49c:	e822                	sd	s0,16(sp)
 49e:	1000                	addi	s0,sp,32
 4a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a4:	4605                	li	a2,1
 4a6:	fef40593          	addi	a1,s0,-17
 4aa:	ecfff0ef          	jal	378 <write>
}
 4ae:	60e2                	ld	ra,24(sp)
 4b0:	6442                	ld	s0,16(sp)
 4b2:	6105                	addi	sp,sp,32
 4b4:	8082                	ret

00000000000004b6 <printint>:
=======
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	1000                	addi	s0,sp,32
 4be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c2:	4605                	li	a2,1
 4c4:	fef40593          	addi	a1,s0,-17
 4c8:	eb1ff0ef          	jal	378 <write>
}
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6442                	ld	s0,16(sp)
 4d0:	6105                	addi	sp,sp,32
 4d2:	8082                	ret

00000000000004d4 <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 4b6:	715d                	addi	sp,sp,-80
 4b8:	e486                	sd	ra,72(sp)
 4ba:	e0a2                	sd	s0,64(sp)
 4bc:	f84a                	sd	s2,48(sp)
 4be:	0880                	addi	s0,sp,80
 4c0:	892a                	mv	s2,a0
=======
 4d4:	715d                	addi	sp,sp,-80
 4d6:	e486                	sd	ra,72(sp)
 4d8:	e0a2                	sd	s0,64(sp)
 4da:	f84a                	sd	s2,48(sp)
 4dc:	0880                	addi	s0,sp,80
 4de:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 4c2:	c299                	beqz	a3,4c8 <printint+0x12>
 4c4:	0805c363          	bltz	a1,54a <printint+0x94>
  neg = 0;
 4c8:	4881                	li	a7,0
 4ca:	fb840693          	addi	a3,s0,-72
=======
 4e0:	c299                	beqz	a3,4e6 <printint+0x12>
 4e2:	0805c363          	bltz	a1,568 <printint+0x94>
  neg = 0;
 4e6:	4881                	li	a7,0
 4e8:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 4ce:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4d0:	00000517          	auipc	a0,0x0
 4d4:	5a050513          	addi	a0,a0,1440 # a70 <digits>
 4d8:	883e                	mv	a6,a5
 4da:	2785                	addiw	a5,a5,1
 4dc:	02c5f733          	remu	a4,a1,a2
 4e0:	972a                	add	a4,a4,a0
 4e2:	00074703          	lbu	a4,0(a4)
 4e6:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4ea:	872e                	mv	a4,a1
 4ec:	02c5d5b3          	divu	a1,a1,a2
 4f0:	0685                	addi	a3,a3,1
 4f2:	fec773e3          	bgeu	a4,a2,4d8 <printint+0x22>
  if (neg)
 4f6:	00088b63          	beqz	a7,50c <printint+0x56>
    buf[i++] = '-';
 4fa:	fd078793          	addi	a5,a5,-48
 4fe:	97a2                	add	a5,a5,s0
 500:	02d00713          	li	a4,45
 504:	fee78423          	sb	a4,-24(a5)
 508:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 50c:	02f05a63          	blez	a5,540 <printint+0x8a>
 510:	fc26                	sd	s1,56(sp)
 512:	f44e                	sd	s3,40(sp)
 514:	fb840713          	addi	a4,s0,-72
 518:	00f704b3          	add	s1,a4,a5
 51c:	fff70993          	addi	s3,a4,-1
 520:	99be                	add	s3,s3,a5
 522:	37fd                	addiw	a5,a5,-1
 524:	1782                	slli	a5,a5,0x20
 526:	9381                	srli	a5,a5,0x20
 528:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 52c:	fff4c583          	lbu	a1,-1(s1)
 530:	854a                	mv	a0,s2
 532:	f67ff0ef          	jal	498 <putc>
  while (--i >= 0)
 536:	14fd                	addi	s1,s1,-1
 538:	ff349ae3          	bne	s1,s3,52c <printint+0x76>
 53c:	74e2                	ld	s1,56(sp)
 53e:	79a2                	ld	s3,40(sp)
}
 540:	60a6                	ld	ra,72(sp)
 542:	6406                	ld	s0,64(sp)
 544:	7942                	ld	s2,48(sp)
 546:	6161                	addi	sp,sp,80
 548:	8082                	ret
    x = -xx;
 54a:	40b005b3          	neg	a1,a1
    neg = 1;
 54e:	4885                	li	a7,1
    x = -xx;
 550:	bfad                	j	4ca <printint+0x14>

0000000000000552 <vprintf>:
=======
 4ec:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4ee:	00000517          	auipc	a0,0x0
 4f2:	5a250513          	addi	a0,a0,1442 # a90 <digits>
 4f6:	883e                	mv	a6,a5
 4f8:	2785                	addiw	a5,a5,1
 4fa:	02c5f733          	remu	a4,a1,a2
 4fe:	972a                	add	a4,a4,a0
 500:	00074703          	lbu	a4,0(a4)
 504:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 508:	872e                	mv	a4,a1
 50a:	02c5d5b3          	divu	a1,a1,a2
 50e:	0685                	addi	a3,a3,1
 510:	fec773e3          	bgeu	a4,a2,4f6 <printint+0x22>
  if (neg)
 514:	00088b63          	beqz	a7,52a <printint+0x56>
    buf[i++] = '-';
 518:	fd078793          	addi	a5,a5,-48
 51c:	97a2                	add	a5,a5,s0
 51e:	02d00713          	li	a4,45
 522:	fee78423          	sb	a4,-24(a5)
 526:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 52a:	02f05a63          	blez	a5,55e <printint+0x8a>
 52e:	fc26                	sd	s1,56(sp)
 530:	f44e                	sd	s3,40(sp)
 532:	fb840713          	addi	a4,s0,-72
 536:	00f704b3          	add	s1,a4,a5
 53a:	fff70993          	addi	s3,a4,-1
 53e:	99be                	add	s3,s3,a5
 540:	37fd                	addiw	a5,a5,-1
 542:	1782                	slli	a5,a5,0x20
 544:	9381                	srli	a5,a5,0x20
 546:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 54a:	fff4c583          	lbu	a1,-1(s1)
 54e:	854a                	mv	a0,s2
 550:	f67ff0ef          	jal	4b6 <putc>
  while (--i >= 0)
 554:	14fd                	addi	s1,s1,-1
 556:	ff349ae3          	bne	s1,s3,54a <printint+0x76>
 55a:	74e2                	ld	s1,56(sp)
 55c:	79a2                	ld	s3,40(sp)
}
 55e:	60a6                	ld	ra,72(sp)
 560:	6406                	ld	s0,64(sp)
 562:	7942                	ld	s2,48(sp)
 564:	6161                	addi	sp,sp,80
 566:	8082                	ret
    x = -xx;
 568:	40b005b3          	neg	a1,a1
    neg = 1;
 56c:	4885                	li	a7,1
    x = -xx;
 56e:	bfad                	j	4e8 <printint+0x14>

0000000000000570 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 552:	711d                	addi	sp,sp,-96
 554:	ec86                	sd	ra,88(sp)
 556:	e8a2                	sd	s0,80(sp)
 558:	e0ca                	sd	s2,64(sp)
 55a:	1080                	addi	s0,sp,96
=======
 570:	711d                	addi	sp,sp,-96
 572:	ec86                	sd	ra,88(sp)
 574:	e8a2                	sd	s0,80(sp)
 576:	e0ca                	sd	s2,64(sp)
 578:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 55c:	0005c903          	lbu	s2,0(a1)
 560:	28090663          	beqz	s2,7ec <vprintf+0x29a>
 564:	e4a6                	sd	s1,72(sp)
 566:	fc4e                	sd	s3,56(sp)
 568:	f852                	sd	s4,48(sp)
 56a:	f456                	sd	s5,40(sp)
 56c:	f05a                	sd	s6,32(sp)
 56e:	ec5e                	sd	s7,24(sp)
 570:	e862                	sd	s8,16(sp)
 572:	e466                	sd	s9,8(sp)
 574:	8b2a                	mv	s6,a0
 576:	8a2e                	mv	s4,a1
 578:	8bb2                	mv	s7,a2
  state = 0;
 57a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 57c:	4481                	li	s1,0
 57e:	4701                	li	a4,0
=======
 57a:	0005c903          	lbu	s2,0(a1)
 57e:	28090663          	beqz	s2,80a <vprintf+0x29a>
 582:	e4a6                	sd	s1,72(sp)
 584:	fc4e                	sd	s3,56(sp)
 586:	f852                	sd	s4,48(sp)
 588:	f456                	sd	s5,40(sp)
 58a:	f05a                	sd	s6,32(sp)
 58c:	ec5e                	sd	s7,24(sp)
 58e:	e862                	sd	s8,16(sp)
 590:	e466                	sd	s9,8(sp)
 592:	8b2a                	mv	s6,a0
 594:	8a2e                	mv	s4,a1
 596:	8bb2                	mv	s7,a2
  state = 0;
 598:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 59a:	4481                	li	s1,0
 59c:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 580:	02500a93          	li	s5,37
=======
 59e:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 584:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 588:	06c00c93          	li	s9,108
 58c:	a005                	j	5ac <vprintf+0x5a>
        putc(fd, c0);
 58e:	85ca                	mv	a1,s2
 590:	855a                	mv	a0,s6
 592:	f07ff0ef          	jal	498 <putc>
 596:	a019                	j	59c <vprintf+0x4a>
    } else if (state == '%') {
 598:	03598263          	beq	s3,s5,5bc <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 59c:	2485                	addiw	s1,s1,1
 59e:	8726                	mv	a4,s1
 5a0:	009a07b3          	add	a5,s4,s1
 5a4:	0007c903          	lbu	s2,0(a5)
 5a8:	22090a63          	beqz	s2,7dc <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5ac:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5b0:	fe0994e3          	bnez	s3,598 <vprintf+0x46>
      if (c0 == '%') {
 5b4:	fd579de3          	bne	a5,s5,58e <vprintf+0x3c>
        state = '%';
 5b8:	89be                	mv	s3,a5
 5ba:	b7cd                	j	59c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5bc:	00ea06b3          	add	a3,s4,a4
 5c0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5c4:	8636                	mv	a2,a3
      if (c1)
 5c6:	c681                	beqz	a3,5ce <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5c8:	9752                	add	a4,a4,s4
 5ca:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5ce:	05878363          	beq	a5,s8,614 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5d2:	05978d63          	beq	a5,s9,62c <vprintf+0xda>
=======
 5a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5a6:	06c00c93          	li	s9,108
 5aa:	a005                	j	5ca <vprintf+0x5a>
        putc(fd, c0);
 5ac:	85ca                	mv	a1,s2
 5ae:	855a                	mv	a0,s6
 5b0:	f07ff0ef          	jal	4b6 <putc>
 5b4:	a019                	j	5ba <vprintf+0x4a>
    } else if (state == '%') {
 5b6:	03598263          	beq	s3,s5,5da <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5ba:	2485                	addiw	s1,s1,1
 5bc:	8726                	mv	a4,s1
 5be:	009a07b3          	add	a5,s4,s1
 5c2:	0007c903          	lbu	s2,0(a5)
 5c6:	22090a63          	beqz	s2,7fa <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5ca:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5ce:	fe0994e3          	bnez	s3,5b6 <vprintf+0x46>
      if (c0 == '%') {
 5d2:	fd579de3          	bne	a5,s5,5ac <vprintf+0x3c>
        state = '%';
 5d6:	89be                	mv	s3,a5
 5d8:	b7cd                	j	5ba <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5da:	00ea06b3          	add	a3,s4,a4
 5de:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5e2:	8636                	mv	a2,a3
      if (c1)
 5e4:	c681                	beqz	a3,5ec <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5e6:	9752                	add	a4,a4,s4
 5e8:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5ec:	05878363          	beq	a5,s8,632 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5f0:	05978d63          	beq	a5,s9,64a <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 5d6:	07500713          	li	a4,117
 5da:	0ee78763          	beq	a5,a4,6c8 <vprintf+0x176>
=======
 5f4:	07500713          	li	a4,117
 5f8:	0ee78763          	beq	a5,a4,6e6 <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 5de:	07800713          	li	a4,120
 5e2:	12e78963          	beq	a5,a4,714 <vprintf+0x1c2>
=======
 5fc:	07800713          	li	a4,120
 600:	12e78963          	beq	a5,a4,732 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 5e6:	07000713          	li	a4,112
 5ea:	14e78e63          	beq	a5,a4,746 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5ee:	06300713          	li	a4,99
 5f2:	18e78e63          	beq	a5,a4,78e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5f6:	07300713          	li	a4,115
 5fa:	1ae78463          	beq	a5,a4,7a2 <vprintf+0x250>
=======
 604:	07000713          	li	a4,112
 608:	14e78e63          	beq	a5,a4,764 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 60c:	06300713          	li	a4,99
 610:	18e78e63          	beq	a5,a4,7ac <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 614:	07300713          	li	a4,115
 618:	1ae78463          	beq	a5,a4,7c0 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 5fe:	02500713          	li	a4,37
 602:	04e79563          	bne	a5,a4,64c <vprintf+0xfa>
        putc(fd, '%');
 606:	02500593          	li	a1,37
 60a:	855a                	mv	a0,s6
 60c:	e8dff0ef          	jal	498 <putc>
=======
 61c:	02500713          	li	a4,37
 620:	04e79563          	bne	a5,a4,66a <vprintf+0xfa>
        putc(fd, '%');
 624:	02500593          	li	a1,37
 628:	855a                	mv	a0,s6
 62a:	e8dff0ef          	jal	4b6 <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 610:	4981                	li	s3,0
 612:	b769                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 614:	008b8913          	addi	s2,s7,8
 618:	4685                	li	a3,1
 61a:	4629                	li	a2,10
 61c:	000ba583          	lw	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e95ff0ef          	jal	4b6 <printint>
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
 62a:	bf8d                	j	59c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 62c:	06400793          	li	a5,100
 630:	02f68963          	beq	a3,a5,662 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 634:	06c00793          	li	a5,108
 638:	04f68263          	beq	a3,a5,67c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 63c:	07500793          	li	a5,117
 640:	0af68063          	beq	a3,a5,6e0 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 644:	07800793          	li	a5,120
 648:	0ef68263          	beq	a3,a5,72c <vprintf+0x1da>
        putc(fd, '%');
 64c:	02500593          	li	a1,37
 650:	855a                	mv	a0,s6
 652:	e47ff0ef          	jal	498 <putc>
        putc(fd, c0);
 656:	85ca                	mv	a1,s2
 658:	855a                	mv	a0,s6
 65a:	e3fff0ef          	jal	498 <putc>
      state = 0;
 65e:	4981                	li	s3,0
 660:	bf35                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 662:	008b8913          	addi	s2,s7,8
 666:	4685                	li	a3,1
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e47ff0ef          	jal	4b6 <printint>
        i += 1;
 674:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	b70d                	j	59c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 67c:	06400793          	li	a5,100
 680:	02f60763          	beq	a2,a5,6ae <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 684:	07500793          	li	a5,117
 688:	06f60963          	beq	a2,a5,6fa <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 68c:	07800793          	li	a5,120
 690:	faf61ee3          	bne	a2,a5,64c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8913          	addi	s2,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	e15ff0ef          	jal	4b6 <printint>
        i += 2;
 6a6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
        i += 2;
 6ac:	bdc5                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ae:	008b8913          	addi	s2,s7,8
 6b2:	4685                	li	a3,1
 6b4:	4629                	li	a2,10
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	dfbff0ef          	jal	4b6 <printint>
        i += 2;
 6c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	bdd9                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000be583          	lwu	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	de1ff0ef          	jal	4b6 <printint>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bd7d                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4629                	li	a2,10
 6e8:	000bb583          	ld	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	dc9ff0ef          	jal	4b6 <printint>
        i += 1;
 6f2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
        i += 1;
 6f8:	b555                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	dafff0ef          	jal	4b6 <printint>
        i += 2;
 70c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	8bca                	mv	s7,s2
      state = 0;
 710:	4981                	li	s3,0
        i += 2;
 712:	b569                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 714:	008b8913          	addi	s2,s7,8
 718:	4681                	li	a3,0
 71a:	4641                	li	a2,16
 71c:	000be583          	lwu	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	d95ff0ef          	jal	4b6 <printint>
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
 72a:	bd8d                	j	59c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4641                	li	a2,16
 734:	000bb583          	ld	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	d7dff0ef          	jal	4b6 <printint>
        i += 1;
 73e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
        i += 1;
 744:	bda1                	j	59c <vprintf+0x4a>
 746:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 748:	008b8d13          	addi	s10,s7,8
 74c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 750:	03000593          	li	a1,48
 754:	855a                	mv	a0,s6
 756:	d43ff0ef          	jal	498 <putc>
  putc(fd, 'x');
 75a:	07800593          	li	a1,120
 75e:	855a                	mv	a0,s6
 760:	d39ff0ef          	jal	498 <putc>
 764:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 766:	00000b97          	auipc	s7,0x0
 76a:	30ab8b93          	addi	s7,s7,778 # a70 <digits>
 76e:	03c9d793          	srli	a5,s3,0x3c
 772:	97de                	add	a5,a5,s7
 774:	0007c583          	lbu	a1,0(a5)
 778:	855a                	mv	a0,s6
 77a:	d1fff0ef          	jal	498 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77e:	0992                	slli	s3,s3,0x4
 780:	397d                	addiw	s2,s2,-1
 782:	fe0916e3          	bnez	s2,76e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 786:	8bea                	mv	s7,s10
      state = 0;
 788:	4981                	li	s3,0
 78a:	6d02                	ld	s10,0(sp)
 78c:	bd01                	j	59c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 78e:	008b8913          	addi	s2,s7,8
 792:	000bc583          	lbu	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d01ff0ef          	jal	498 <putc>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bbf5                	j	59c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7a2:	008b8993          	addi	s3,s7,8
 7a6:	000bb903          	ld	s2,0(s7)
 7aa:	00090f63          	beqz	s2,7c8 <vprintf+0x276>
        for (; *s; s++)
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	c195                	beqz	a1,7d6 <vprintf+0x284>
          putc(fd, *s);
 7b4:	855a                	mv	a0,s6
 7b6:	ce3ff0ef          	jal	498 <putc>
        for (; *s; s++)
 7ba:	0905                	addi	s2,s2,1
 7bc:	00094583          	lbu	a1,0(s2)
 7c0:	f9f5                	bnez	a1,7b4 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7c2:	8bce                	mv	s7,s3
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbd9                	j	59c <vprintf+0x4a>
          s = "(null)";
 7c8:	00000917          	auipc	s2,0x0
 7cc:	2a090913          	addi	s2,s2,672 # a68 <malloc+0x194>
        for (; *s; s++)
 7d0:	02800593          	li	a1,40
 7d4:	b7c5                	j	7b4 <vprintf+0x262>
=======
 62e:	4981                	li	s3,0
 630:	b769                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 632:	008b8913          	addi	s2,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000ba583          	lw	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e95ff0ef          	jal	4d4 <printint>
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bf8d                	j	5ba <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 64a:	06400793          	li	a5,100
 64e:	02f68963          	beq	a3,a5,680 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 652:	06c00793          	li	a5,108
 656:	04f68263          	beq	a3,a5,69a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 65a:	07500793          	li	a5,117
 65e:	0af68063          	beq	a3,a5,6fe <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 662:	07800793          	li	a5,120
 666:	0ef68263          	beq	a3,a5,74a <vprintf+0x1da>
        putc(fd, '%');
 66a:	02500593          	li	a1,37
 66e:	855a                	mv	a0,s6
 670:	e47ff0ef          	jal	4b6 <putc>
        putc(fd, c0);
 674:	85ca                	mv	a1,s2
 676:	855a                	mv	a0,s6
 678:	e3fff0ef          	jal	4b6 <putc>
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bf35                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	008b8913          	addi	s2,s7,8
 684:	4685                	li	a3,1
 686:	4629                	li	a2,10
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	e47ff0ef          	jal	4d4 <printint>
        i += 1;
 692:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
        i += 1;
 698:	b70d                	j	5ba <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 69a:	06400793          	li	a5,100
 69e:	02f60763          	beq	a2,a5,6cc <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6a2:	07500793          	li	a5,117
 6a6:	06f60963          	beq	a2,a5,718 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6aa:	07800793          	li	a5,120
 6ae:	faf61ee3          	bne	a2,a5,66a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000bb583          	ld	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	e15ff0ef          	jal	4d4 <printint>
        i += 2;
 6c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
        i += 2;
 6ca:	bdc5                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4685                	li	a3,1
 6d2:	4629                	li	a2,10
 6d4:	000bb583          	ld	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	dfbff0ef          	jal	4d4 <printint>
        i += 2;
 6de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
        i += 2;
 6e4:	bdd9                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000be583          	lwu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	de1ff0ef          	jal	4d4 <printint>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bd7d                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b8913          	addi	s2,s7,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000bb583          	ld	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	dc9ff0ef          	jal	4d4 <printint>
        i += 1;
 710:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
        i += 1;
 716:	b555                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 718:	008b8913          	addi	s2,s7,8
 71c:	4681                	li	a3,0
 71e:	4629                	li	a2,10
 720:	000bb583          	ld	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	dafff0ef          	jal	4d4 <printint>
        i += 2;
 72a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
        i += 2;
 730:	b569                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 732:	008b8913          	addi	s2,s7,8
 736:	4681                	li	a3,0
 738:	4641                	li	a2,16
 73a:	000be583          	lwu	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	d95ff0ef          	jal	4d4 <printint>
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	bd8d                	j	5ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 74a:	008b8913          	addi	s2,s7,8
 74e:	4681                	li	a3,0
 750:	4641                	li	a2,16
 752:	000bb583          	ld	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	d7dff0ef          	jal	4d4 <printint>
        i += 1;
 75c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 75e:	8bca                	mv	s7,s2
      state = 0;
 760:	4981                	li	s3,0
        i += 1;
 762:	bda1                	j	5ba <vprintf+0x4a>
 764:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 766:	008b8d13          	addi	s10,s7,8
 76a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76e:	03000593          	li	a1,48
 772:	855a                	mv	a0,s6
 774:	d43ff0ef          	jal	4b6 <putc>
  putc(fd, 'x');
 778:	07800593          	li	a1,120
 77c:	855a                	mv	a0,s6
 77e:	d39ff0ef          	jal	4b6 <putc>
 782:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 784:	00000b97          	auipc	s7,0x0
 788:	30cb8b93          	addi	s7,s7,780 # a90 <digits>
 78c:	03c9d793          	srli	a5,s3,0x3c
 790:	97de                	add	a5,a5,s7
 792:	0007c583          	lbu	a1,0(a5)
 796:	855a                	mv	a0,s6
 798:	d1fff0ef          	jal	4b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 79c:	0992                	slli	s3,s3,0x4
 79e:	397d                	addiw	s2,s2,-1
 7a0:	fe0916e3          	bnez	s2,78c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7a4:	8bea                	mv	s7,s10
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	6d02                	ld	s10,0(sp)
 7aa:	bd01                	j	5ba <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	000bc583          	lbu	a1,0(s7)
 7b4:	855a                	mv	a0,s6
 7b6:	d01ff0ef          	jal	4b6 <putc>
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bbf5                	j	5ba <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7c0:	008b8993          	addi	s3,s7,8
 7c4:	000bb903          	ld	s2,0(s7)
 7c8:	00090f63          	beqz	s2,7e6 <vprintf+0x276>
        for (; *s; s++)
 7cc:	00094583          	lbu	a1,0(s2)
 7d0:	c195                	beqz	a1,7f4 <vprintf+0x284>
          putc(fd, *s);
 7d2:	855a                	mv	a0,s6
 7d4:	ce3ff0ef          	jal	4b6 <putc>
        for (; *s; s++)
 7d8:	0905                	addi	s2,s2,1
 7da:	00094583          	lbu	a1,0(s2)
 7de:	f9f5                	bnez	a1,7d2 <vprintf+0x262>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
 7e0:	8bce                	mv	s7,s3
      state = 0;
<<<<<<< HEAD
 7d8:	4981                	li	s3,0
 7da:	b3c9                	j	59c <vprintf+0x4a>
 7dc:	64a6                	ld	s1,72(sp)
 7de:	79e2                	ld	s3,56(sp)
 7e0:	7a42                	ld	s4,48(sp)
 7e2:	7aa2                	ld	s5,40(sp)
 7e4:	7b02                	ld	s6,32(sp)
 7e6:	6be2                	ld	s7,24(sp)
 7e8:	6c42                	ld	s8,16(sp)
 7ea:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ec:	60e6                	ld	ra,88(sp)
 7ee:	6446                	ld	s0,80(sp)
 7f0:	6906                	ld	s2,64(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret

00000000000007f6 <fprintf>:
=======
 7e2:	4981                	li	s3,0
 7e4:	bbd9                	j	5ba <vprintf+0x4a>
          s = "(null)";
 7e6:	00000917          	auipc	s2,0x0
 7ea:	2a290913          	addi	s2,s2,674 # a88 <malloc+0x196>
        for (; *s; s++)
 7ee:	02800593          	li	a1,40
 7f2:	b7c5                	j	7d2 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7f4:	8bce                	mv	s7,s3
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b3c9                	j	5ba <vprintf+0x4a>
 7fa:	64a6                	ld	s1,72(sp)
 7fc:	79e2                	ld	s3,56(sp)
 7fe:	7a42                	ld	s4,48(sp)
 800:	7aa2                	ld	s5,40(sp)
 802:	7b02                	ld	s6,32(sp)
 804:	6be2                	ld	s7,24(sp)
 806:	6c42                	ld	s8,16(sp)
 808:	6ca2                	ld	s9,8(sp)
    }
  }
}
 80a:	60e6                	ld	ra,88(sp)
 80c:	6446                	ld	s0,80(sp)
 80e:	6906                	ld	s2,64(sp)
 810:	6125                	addi	sp,sp,96
 812:	8082                	ret

0000000000000814 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 7f6:	715d                	addi	sp,sp,-80
 7f8:	ec06                	sd	ra,24(sp)
 7fa:	e822                	sd	s0,16(sp)
 7fc:	1000                	addi	s0,sp,32
 7fe:	e010                	sd	a2,0(s0)
 800:	e414                	sd	a3,8(s0)
 802:	e818                	sd	a4,16(s0)
 804:	ec1c                	sd	a5,24(s0)
 806:	03043023          	sd	a6,32(s0)
 80a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 812:	8622                	mv	a2,s0
 814:	d3fff0ef          	jal	552 <vprintf>
}
 818:	60e2                	ld	ra,24(sp)
 81a:	6442                	ld	s0,16(sp)
 81c:	6161                	addi	sp,sp,80
 81e:	8082                	ret

0000000000000820 <printf>:
=======
 814:	715d                	addi	sp,sp,-80
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	e010                	sd	a2,0(s0)
 81e:	e414                	sd	a3,8(s0)
 820:	e818                	sd	a4,16(s0)
 822:	ec1c                	sd	a5,24(s0)
 824:	03043023          	sd	a6,32(s0)
 828:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 830:	8622                	mv	a2,s0
 832:	d3fff0ef          	jal	570 <vprintf>
}
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	6161                	addi	sp,sp,80
 83c:	8082                	ret

000000000000083e <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 820:	711d                	addi	sp,sp,-96
 822:	ec06                	sd	ra,24(sp)
 824:	e822                	sd	s0,16(sp)
 826:	1000                	addi	s0,sp,32
 828:	e40c                	sd	a1,8(s0)
 82a:	e810                	sd	a2,16(s0)
 82c:	ec14                	sd	a3,24(s0)
 82e:	f018                	sd	a4,32(s0)
 830:	f41c                	sd	a5,40(s0)
 832:	03043823          	sd	a6,48(s0)
 836:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83a:	00840613          	addi	a2,s0,8
 83e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 842:	85aa                	mv	a1,a0
 844:	4505                	li	a0,1
 846:	d0dff0ef          	jal	552 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret

0000000000000852 <free>:
=======
 83e:	711d                	addi	sp,sp,-96
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e40c                	sd	a1,8(s0)
 848:	e810                	sd	a2,16(s0)
 84a:	ec14                	sd	a3,24(s0)
 84c:	f018                	sd	a4,32(s0)
 84e:	f41c                	sd	a5,40(s0)
 850:	03043823          	sd	a6,48(s0)
 854:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 858:	00840613          	addi	a2,s0,8
 85c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 860:	85aa                	mv	a1,a0
 862:	4505                	li	a0,1
 864:	d0dff0ef          	jal	570 <vprintf>
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	6125                	addi	sp,sp,96
 86e:	8082                	ret

0000000000000870 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 852:	1141                	addi	sp,sp,-16
 854:	e422                	sd	s0,8(sp)
 856:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 858:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	00000797          	auipc	a5,0x0
 860:	7a47b783          	ld	a5,1956(a5) # 1000 <freep>
 864:	a02d                	j	88e <free+0x3c>
=======
 870:	1141                	addi	sp,sp,-16
 872:	e422                	sd	s0,8(sp)
 874:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 876:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	00000797          	auipc	a5,0x0
 87e:	7867b783          	ld	a5,1926(a5) # 1000 <freep>
 882:	a02d                	j	8ac <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	a83d                	j	8b0 <free+0x5e>
=======
 884:	4618                	lw	a4,8(a2)
 886:	9f2d                	addw	a4,a4,a1
 888:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	6310                	ld	a2,0(a4)
 890:	a83d                	j	8ce <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	a091                	j	8c4 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 882:	6398                	ld	a4,0(a5)
 884:	00e7e463          	bltu	a5,a4,88c <free+0x3a>
 888:	00e6ea63          	bltu	a3,a4,89c <free+0x4a>
{
 88c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	fed7fae3          	bgeu	a5,a3,882 <free+0x30>
 892:	6398                	ld	a4,0(a5)
 894:	00e6e463          	bltu	a3,a4,89c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	fee7eae3          	bltu	a5,a4,88c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 89c:	ff852583          	lw	a1,-8(a0)
 8a0:	6390                	ld	a2,0(a5)
 8a2:	02059813          	slli	a6,a1,0x20
 8a6:	01c85713          	srli	a4,a6,0x1c
 8aa:	9736                	add	a4,a4,a3
 8ac:	fae60de3          	beq	a2,a4,866 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8b4:	4790                	lw	a2,8(a5)
 8b6:	02061593          	slli	a1,a2,0x20
 8ba:	01c5d713          	srli	a4,a1,0x1c
 8be:	973e                	add	a4,a4,a5
 8c0:	fae68ae3          	beq	a3,a4,874 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72f73d23          	sd	a5,1850(a4) # 1000 <freep>
}
 8ce:	6422                	ld	s0,8(sp)
 8d0:	0141                	addi	sp,sp,16
 8d2:	8082                	ret

00000000000008d4 <malloc>:
=======
 892:	ff852703          	lw	a4,-8(a0)
 896:	9f31                	addw	a4,a4,a2
 898:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89a:	ff053683          	ld	a3,-16(a0)
 89e:	a091                	j	8e2 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e7e463          	bltu	a5,a4,8aa <free+0x3a>
 8a6:	00e6ea63          	bltu	a3,a4,8ba <free+0x4a>
{
 8aa:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ac:	fed7fae3          	bgeu	a5,a3,8a0 <free+0x30>
 8b0:	6398                	ld	a4,0(a5)
 8b2:	00e6e463          	bltu	a3,a4,8ba <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b6:	fee7eae3          	bltu	a5,a4,8aa <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8ba:	ff852583          	lw	a1,-8(a0)
 8be:	6390                	ld	a2,0(a5)
 8c0:	02059813          	slli	a6,a1,0x20
 8c4:	01c85713          	srli	a4,a6,0x1c
 8c8:	9736                	add	a4,a4,a3
 8ca:	fae60de3          	beq	a2,a4,884 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ce:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8d2:	4790                	lw	a2,8(a5)
 8d4:	02061593          	slli	a1,a2,0x20
 8d8:	01c5d713          	srli	a4,a1,0x1c
 8dc:	973e                	add	a4,a4,a5
 8de:	fae68ae3          	beq	a3,a4,892 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e4:	00000717          	auipc	a4,0x0
 8e8:	70f73e23          	sd	a5,1820(a4) # 1000 <freep>
}
 8ec:	6422                	ld	s0,8(sp)
 8ee:	0141                	addi	sp,sp,16
 8f0:	8082                	ret

00000000000008f2 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 8d4:	7139                	addi	sp,sp,-64
 8d6:	fc06                	sd	ra,56(sp)
 8d8:	f822                	sd	s0,48(sp)
 8da:	f426                	sd	s1,40(sp)
 8dc:	ec4e                	sd	s3,24(sp)
 8de:	0080                	addi	s0,sp,64
=======
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f426                	sd	s1,40(sp)
 8fa:	ec4e                	sd	s3,24(sp)
 8fc:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 8e0:	02051493          	slli	s1,a0,0x20
 8e4:	9081                	srli	s1,s1,0x20
 8e6:	04bd                	addi	s1,s1,15
 8e8:	8091                	srli	s1,s1,0x4
 8ea:	0014899b          	addiw	s3,s1,1
 8ee:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8f0:	00000517          	auipc	a0,0x0
 8f4:	71053503          	ld	a0,1808(a0) # 1000 <freep>
 8f8:	c915                	beqz	a0,92c <malloc+0x58>
=======
 8fe:	02051493          	slli	s1,a0,0x20
 902:	9081                	srli	s1,s1,0x20
 904:	04bd                	addi	s1,s1,15
 906:	8091                	srli	s1,s1,0x4
 908:	0014899b          	addiw	s3,s1,1
 90c:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 90e:	00000517          	auipc	a0,0x0
 912:	6f253503          	ld	a0,1778(a0) # 1000 <freep>
 916:	c915                	beqz	a0,94a <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 8fa:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8fc:	4798                	lw	a4,8(a5)
 8fe:	08977a63          	bgeu	a4,s1,992 <malloc+0xbe>
 902:	f04a                	sd	s2,32(sp)
 904:	e852                	sd	s4,16(sp)
 906:	e456                	sd	s5,8(sp)
 908:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 90a:	8a4e                	mv	s4,s3
 90c:	0009871b          	sext.w	a4,s3
 910:	6685                	lui	a3,0x1
 912:	00d77363          	bgeu	a4,a3,918 <malloc+0x44>
 916:	6a05                	lui	s4,0x1
 918:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 91c:	004a1a1b          	slliw	s4,s4,0x4
=======
 918:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 91a:	4798                	lw	a4,8(a5)
 91c:	08977a63          	bgeu	a4,s1,9b0 <malloc+0xbe>
 920:	f04a                	sd	s2,32(sp)
 922:	e852                	sd	s4,16(sp)
 924:	e456                	sd	s5,8(sp)
 926:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 928:	8a4e                	mv	s4,s3
 92a:	0009871b          	sext.w	a4,s3
 92e:	6685                	lui	a3,0x1
 930:	00d77363          	bgeu	a4,a3,936 <malloc+0x44>
 934:	6a05                	lui	s4,0x1
 936:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93a:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 920:	00000917          	auipc	s2,0x0
 924:	6e090913          	addi	s2,s2,1760 # 1000 <freep>
  if (p == SBRK_ERROR)
 928:	5afd                	li	s5,-1
 92a:	a081                	j	96a <malloc+0x96>
 92c:	f04a                	sd	s2,32(sp)
 92e:	e852                	sd	s4,16(sp)
 930:	e456                	sd	s5,8(sp)
 932:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 934:	00001797          	auipc	a5,0x1
 938:	8d478793          	addi	a5,a5,-1836 # 1208 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	6cf73223          	sd	a5,1732(a4) # 1000 <freep>
 944:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 94a:	b7c1                	j	90a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	e118                	sd	a4,0(a0)
 950:	a8a9                	j	9aa <malloc+0xd6>
  hp->s.size = nu;
 952:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 956:	0541                	addi	a0,a0,16
 958:	efbff0ef          	jal	852 <free>
  return freep;
 95c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 960:	c12d                	beqz	a0,9c2 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 962:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 964:	4798                	lw	a4,8(a5)
 966:	02977263          	bgeu	a4,s1,98a <malloc+0xb6>
    if (p == freep)
 96a:	00093703          	ld	a4,0(s2)
 96e:	853e                	mv	a0,a5
 970:	fef719e3          	bne	a4,a5,962 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 974:	8552                	mv	a0,s4
 976:	9afff0ef          	jal	324 <sbrk>
  if (p == SBRK_ERROR)
 97a:	fd551ce3          	bne	a0,s5,952 <malloc+0x7e>
        return 0;
 97e:	4501                	li	a0,0
 980:	7902                	ld	s2,32(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
 988:	a03d                	j	9b6 <malloc+0xe2>
 98a:	7902                	ld	s2,32(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 992:	fae48de3          	beq	s1,a4,94c <malloc+0x78>
        p->s.size -= nunits;
 996:	4137073b          	subw	a4,a4,s3
 99a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99c:	02071693          	slli	a3,a4,0x20
 9a0:	01c6d713          	srli	a4,a3,0x1c
 9a4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9aa:	00000717          	auipc	a4,0x0
 9ae:	64a73b23          	sd	a0,1622(a4) # 1000 <freep>
      return (void *)(p + 1);
 9b2:	01078513          	addi	a0,a5,16
  }
}
 9b6:	70e2                	ld	ra,56(sp)
 9b8:	7442                	ld	s0,48(sp)
 9ba:	74a2                	ld	s1,40(sp)
 9bc:	69e2                	ld	s3,24(sp)
 9be:	6121                	addi	sp,sp,64
 9c0:	8082                	ret
 9c2:	7902                	ld	s2,32(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	b7f5                	j	9b6 <malloc+0xe2>
=======
 93e:	00000917          	auipc	s2,0x0
 942:	6c290913          	addi	s2,s2,1730 # 1000 <freep>
  if (p == SBRK_ERROR)
 946:	5afd                	li	s5,-1
 948:	a081                	j	988 <malloc+0x96>
 94a:	f04a                	sd	s2,32(sp)
 94c:	e852                	sd	s4,16(sp)
 94e:	e456                	sd	s5,8(sp)
 950:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 952:	00001797          	auipc	a5,0x1
 956:	8b678793          	addi	a5,a5,-1866 # 1208 <base>
 95a:	00000717          	auipc	a4,0x0
 95e:	6af73323          	sd	a5,1702(a4) # 1000 <freep>
 962:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 964:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 968:	b7c1                	j	928 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	a8a9                	j	9c8 <malloc+0xd6>
  hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	efbff0ef          	jal	870 <free>
  return freep;
 97a:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 97e:	c12d                	beqz	a0,9e0 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 980:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 982:	4798                	lw	a4,8(a5)
 984:	02977263          	bgeu	a4,s1,9a8 <malloc+0xb6>
    if (p == freep)
 988:	00093703          	ld	a4,0(s2)
 98c:	853e                	mv	a0,a5
 98e:	fef719e3          	bne	a4,a5,980 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 992:	8552                	mv	a0,s4
 994:	991ff0ef          	jal	324 <sbrk>
  if (p == SBRK_ERROR)
 998:	fd551ce3          	bne	a0,s5,970 <malloc+0x7e>
        return 0;
 99c:	4501                	li	a0,0
 99e:	7902                	ld	s2,32(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
 9a6:	a03d                	j	9d4 <malloc+0xe2>
 9a8:	7902                	ld	s2,32(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9b0:	fae48de3          	beq	s1,a4,96a <malloc+0x78>
        p->s.size -= nunits;
 9b4:	4137073b          	subw	a4,a4,s3
 9b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ba:	02071693          	slli	a3,a4,0x20
 9be:	01c6d713          	srli	a4,a3,0x1c
 9c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c8:	00000717          	auipc	a4,0x0
 9cc:	62a73c23          	sd	a0,1592(a4) # 1000 <freep>
      return (void *)(p + 1);
 9d0:	01078513          	addi	a0,a5,16
  }
}
 9d4:	70e2                	ld	ra,56(sp)
 9d6:	7442                	ld	s0,48(sp)
 9d8:	74a2                	ld	s1,40(sp)
 9da:	69e2                	ld	s3,24(sp)
 9dc:	6121                	addi	sp,sp,64
 9de:	8082                	ret
 9e0:	7902                	ld	s2,32(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
 9e8:	b7f5                	j	9d4 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
