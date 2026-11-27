
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
<<<<<<< HEAD
  1a:	9fa78793          	addi	a5,a5,-1542 # a10 <malloc+0x128>
=======
  1a:	a1a78793          	addi	a5,a5,-1510 # a30 <malloc+0x12a>
>>>>>>> e18456e (Updated xv6-riscv)
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  30:	9b450513          	addi	a0,a0,-1612 # 9e0 <malloc+0xf8>
  34:	001000ef          	jal	834 <printf>
=======
  30:	9d450513          	addi	a0,a0,-1580 # a00 <malloc+0xfa>
  34:	01f000ef          	jal	852 <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	116000ef          	jal	15a <memset>

  for (i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if (fork() > 0)
  4c:	318000ef          	jal	364 <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for (i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  60:	99c50513          	addi	a0,a0,-1636 # 9f8 <malloc+0x110>
  64:	7d0000ef          	jal	834 <printf>
=======
  60:	9bc50513          	addi	a0,a0,-1604 # a18 <malloc+0x112>
  64:	7ee000ef          	jal	852 <printf>
>>>>>>> e18456e (Updated xv6-riscv)

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	332000ef          	jal	3ac <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) {
    // printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	300000ef          	jal	38c <write>
  for (i = 0; i < 20; i++) {
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  }
  close(fd);
  94:	854a                	mv	a0,s2
  96:	2fe000ef          	jal	394 <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  9e:	96e50513          	addi	a0,a0,-1682 # a08 <malloc+0x120>
  a2:	792000ef          	jal	834 <printf>
=======
  9e:	98e50513          	addi	a0,a0,-1650 # a28 <malloc+0x122>
  a2:	7b0000ef          	jal	852 <printf>
>>>>>>> e18456e (Updated xv6-riscv)

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	300000ef          	jal	3ac <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	2c6000ef          	jal	384 <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	2cc000ef          	jal	394 <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	2a6000ef          	jal	374 <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	298000ef          	jal	36c <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  e0:	f21ff0ef          	jal	0 <main>
  exit(r);
  e4:	288000ef          	jal	36c <exit>

00000000000000e8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  ee:	87aa                	mv	a5,a0
  f0:	0585                	addi	a1,a1,1
  f2:	0785                	addi	a5,a5,1
  f4:	fff5c703          	lbu	a4,-1(a1)
  f8:	fee78fa3          	sb	a4,-1(a5)
  fc:	fb75                	bnez	a4,f0 <strcpy+0x8>
    ;
  return os;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x1e>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x1e>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cf91                	beqz	a5,156 <strlen+0x26>
 13c:	0505                	addi	a0,a0,1
 13e:	87aa                	mv	a5,a0
 140:	86be                	mv	a3,a5
 142:	0785                	addi	a5,a5,1
 144:	fff7c703          	lbu	a4,-1(a5)
 148:	ff65                	bnez	a4,140 <strlen+0x10>
 14a:	40a6853b          	subw	a0,a3,a0
 14e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 150:	6422                	ld	s0,8(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret
  for (n = 0; s[n]; n++)
 156:	4501                	li	a0,0
 158:	bfe5                	j	150 <strlen+0x20>

000000000000015a <memset>:

void *
memset(void *dst, int c, uint n)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 160:	ca19                	beqz	a2,176 <memset+0x1c>
 162:	87aa                	mv	a5,a0
 164:	1602                	slli	a2,a2,0x20
 166:	9201                	srli	a2,a2,0x20
 168:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 170:	0785                	addi	a5,a5,1
 172:	fee79de3          	bne	a5,a4,16c <memset+0x12>
  }
  return dst;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strchr>:

char *
strchr(const char *s, char c)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  for (; *s; s++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb99                	beqz	a5,19c <strchr+0x20>
    if (*s == c)
 188:	00f58763          	beq	a1,a5,196 <strchr+0x1a>
  for (; *s; s++)
 18c:	0505                	addi	a0,a0,1
 18e:	00054783          	lbu	a5,0(a0)
 192:	fbfd                	bnez	a5,188 <strchr+0xc>
      return (char *)s;
  return 0;
 194:	4501                	li	a0,0
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  return 0;
 19c:	4501                	li	a0,0
 19e:	bfe5                	j	196 <strchr+0x1a>

00000000000001a0 <gets>:

char *
gets(char *buf, int max)
{
 1a0:	711d                	addi	sp,sp,-96
 1a2:	ec86                	sd	ra,88(sp)
 1a4:	e8a2                	sd	s0,80(sp)
 1a6:	e4a6                	sd	s1,72(sp)
 1a8:	e0ca                	sd	s2,64(sp)
 1aa:	fc4e                	sd	s3,56(sp)
 1ac:	f852                	sd	s4,48(sp)
 1ae:	f456                	sd	s5,40(sp)
 1b0:	f05a                	sd	s6,32(sp)
 1b2:	ec5e                	sd	s7,24(sp)
 1b4:	1080                	addi	s0,sp,96
 1b6:	8baa                	mv	s7,a0
 1b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ba:	892a                	mv	s2,a0
 1bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1be:	4aa9                	li	s5,10
 1c0:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1c2:	89a6                	mv	s3,s1
 1c4:	2485                	addiw	s1,s1,1
 1c6:	0344d663          	bge	s1,s4,1f2 <gets+0x52>
    cc = read(0, &c, 1);
 1ca:	4605                	li	a2,1
 1cc:	faf40593          	addi	a1,s0,-81
 1d0:	4501                	li	a0,0
 1d2:	1b2000ef          	jal	384 <read>
    if (cc < 1)
 1d6:	00a05e63          	blez	a0,1f2 <gets+0x52>
    buf[i++] = c;
 1da:	faf44783          	lbu	a5,-81(s0)
 1de:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1e2:	01578763          	beq	a5,s5,1f0 <gets+0x50>
 1e6:	0905                	addi	s2,s2,1
 1e8:	fd679de3          	bne	a5,s6,1c2 <gets+0x22>
    buf[i++] = c;
 1ec:	89a6                	mv	s3,s1
 1ee:	a011                	j	1f2 <gets+0x52>
 1f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f2:	99de                	add	s3,s3,s7
 1f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f8:	855e                	mv	a0,s7
 1fa:	60e6                	ld	ra,88(sp)
 1fc:	6446                	ld	s0,80(sp)
 1fe:	64a6                	ld	s1,72(sp)
 200:	6906                	ld	s2,64(sp)
 202:	79e2                	ld	s3,56(sp)
 204:	7a42                	ld	s4,48(sp)
 206:	7aa2                	ld	s5,40(sp)
 208:	7b02                	ld	s6,32(sp)
 20a:	6be2                	ld	s7,24(sp)
 20c:	6125                	addi	sp,sp,96
 20e:	8082                	ret

0000000000000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	1101                	addi	sp,sp,-32
 212:	ec06                	sd	ra,24(sp)
 214:	e822                	sd	s0,16(sp)
 216:	e04a                	sd	s2,0(sp)
 218:	1000                	addi	s0,sp,32
 21a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	4581                	li	a1,0
 21e:	18e000ef          	jal	3ac <open>
  if (fd < 0)
 222:	02054263          	bltz	a0,246 <stat+0x36>
 226:	e426                	sd	s1,8(sp)
 228:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22a:	85ca                	mv	a1,s2
 22c:	198000ef          	jal	3c4 <fstat>
 230:	892a                	mv	s2,a0
  close(fd);
 232:	8526                	mv	a0,s1
 234:	160000ef          	jal	394 <close>
  return r;
 238:	64a2                	ld	s1,8(sp)
}
 23a:	854a                	mv	a0,s2
 23c:	60e2                	ld	ra,24(sp)
 23e:	6442                	ld	s0,16(sp)
 240:	6902                	ld	s2,0(sp)
 242:	6105                	addi	sp,sp,32
 244:	8082                	ret
    return -1;
 246:	597d                	li	s2,-1
 248:	bfcd                	j	23a <stat+0x2a>

000000000000024a <atoi>:

int
atoi(const char *s)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 250:	00054683          	lbu	a3,0(a0)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	4625                	li	a2,9
 25e:	02f66863          	bltu	a2,a5,28e <atoi+0x44>
 262:	872a                	mv	a4,a0
  n = 0;
 264:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 266:	0705                	addi	a4,a4,1
 268:	0025179b          	slliw	a5,a0,0x2
 26c:	9fa9                	addw	a5,a5,a0
 26e:	0017979b          	slliw	a5,a5,0x1
 272:	9fb5                	addw	a5,a5,a3
 274:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 278:	00074683          	lbu	a3,0(a4)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	fef671e3          	bgeu	a2,a5,266 <atoi+0x1c>
  return n;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  n = 0;
 28e:	4501                	li	a0,0
 290:	bfe5                	j	288 <atoi+0x3e>

0000000000000292 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57463          	bgeu	a0,a1,2c0 <memmove+0x2e>
    while (n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x28>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2b6:	fef71ae3          	bne	a4,a5,2aa <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	6422                	ld	s0,8(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
    dst += n;
 2c0:	00c50733          	add	a4,a0,a2
    src += n;
 2c4:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2c6:	fec05ae3          	blez	a2,2ba <memmove+0x28>
 2ca:	fff6079b          	addiw	a5,a2,-1
 2ce:	1782                	slli	a5,a5,0x20
 2d0:	9381                	srli	a5,a5,0x20
 2d2:	fff7c793          	not	a5,a5
 2d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d8:	15fd                	addi	a1,a1,-1
 2da:	177d                	addi	a4,a4,-1
 2dc:	0005c683          	lbu	a3,0(a1)
 2e0:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2e4:	fee79ae3          	bne	a5,a4,2d8 <memmove+0x46>
 2e8:	bfc9                	j	2ba <memmove+0x28>

00000000000002ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f0:	ca05                	beqz	a2,320 <memcmp+0x36>
 2f2:	fff6069b          	addiw	a3,a2,-1
 2f6:	1682                	slli	a3,a3,0x20
 2f8:	9281                	srli	a3,a3,0x20
 2fa:	0685                	addi	a3,a3,1
 2fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2fe:	00054783          	lbu	a5,0(a0)
 302:	0005c703          	lbu	a4,0(a1)
 306:	00e79863          	bne	a5,a4,316 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30a:	0505                	addi	a0,a0,1
    p2++;
 30c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30e:	fed518e3          	bne	a0,a3,2fe <memcmp+0x14>
  }
  return 0;
 312:	4501                	li	a0,0
 314:	a019                	j	31a <memcmp+0x30>
      return *p1 - *p2;
 316:	40e7853b          	subw	a0,a5,a4
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <memcmp+0x30>

0000000000000324 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32c:	f67ff0ef          	jal	292 <memmove>
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <sbrk>:

char *
sbrk(int n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 340:	4585                	li	a1,1
 342:	0b2000ef          	jal	3f4 <sys_sbrk>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <sbrklazy>:

char *
sbrklazy(int n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 356:	4589                	li	a1,2
 358:	09c000ef          	jal	3f4 <sys_sbrk>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 364:	4885                	li	a7,1
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exit>:
.global exit
exit:
 li a7, SYS_exit
 36c:	4889                	li	a7,2
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <wait>:
.global wait
wait:
 li a7, SYS_wait
 374:	488d                	li	a7,3
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37c:	4891                	li	a7,4
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <read>:
.global read
read:
 li a7, SYS_read
 384:	4895                	li	a7,5
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <write>:
.global write
write:
 li a7, SYS_write
 38c:	48c1                	li	a7,16
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <close>:
.global close
close:
 li a7, SYS_close
 394:	48d5                	li	a7,21
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <kill>:
.global kill
kill:
 li a7, SYS_kill
 39c:	4899                	li	a7,6
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a4:	489d                	li	a7,7
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <open>:
.global open
open:
 li a7, SYS_open
 3ac:	48bd                	li	a7,15
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b4:	48c5                	li	a7,17
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3bc:	48c9                	li	a7,18
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c4:	48a1                	li	a7,8
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <link>:
.global link
link:
 li a7, SYS_link
 3cc:	48cd                	li	a7,19
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d4:	48d1                	li	a7,20
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3dc:	48a5                	li	a7,9
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e4:	48a9                	li	a7,10
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ec:	48ad                	li	a7,11
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f4:	48b1                	li	a7,12
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pause>:
.global pause
pause:
 li a7, SYS_pause
 3fc:	48b5                	li	a7,13
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 404:	48b9                	li	a7,14
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sync>:
.global sync
sync:
 li a7, SYS_sync
 40c:	48d9                	li	a7,22
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <ps>:
.global ps
ps:
 li a7, SYS_ps
 414:	48dd                	li	a7,23
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 41c:	48e1                	li	a7,24
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 424:	48e5                	li	a7,25
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 42c:	48e9                	li	a7,26
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <trace>:
.global trace
trace:
 li a7, SYS_trace
 434:	48ed                	li	a7,27
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 43c:	48f1                	li	a7,28
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 444:	48f5                	li	a7,29
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 44c:	48f9                	li	a7,30
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 454:	48fd                	li	a7,31
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 45c:	02000893          	li	a7,32
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <halt>:
.global halt
halt:
 li a7, SYS_halt
 466:	02100893          	li	a7,33
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 470:	02200893          	li	a7,34
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 47a:	02300893          	li	a7,35
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 484:	02400893          	li	a7,36
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 48e:	02500893          	li	a7,37
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 498:	02600893          	li	a7,38
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 4a2:	02700893          	li	a7,39
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

<<<<<<< HEAD
00000000000004ac <putc>:
=======
00000000000004ac <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 4ac:	02800893          	li	a7,40
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 4b6:	02900893          	li	a7,41
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 4c0:	02a00893          	li	a7,42
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 4ac:	1101                	addi	sp,sp,-32
 4ae:	ec06                	sd	ra,24(sp)
 4b0:	e822                	sd	s0,16(sp)
 4b2:	1000                	addi	s0,sp,32
 4b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b8:	4605                	li	a2,1
 4ba:	fef40593          	addi	a1,s0,-17
 4be:	ecfff0ef          	jal	38c <write>
}
 4c2:	60e2                	ld	ra,24(sp)
 4c4:	6442                	ld	s0,16(sp)
 4c6:	6105                	addi	sp,sp,32
 4c8:	8082                	ret

00000000000004ca <printint>:
=======
 4ca:	1101                	addi	sp,sp,-32
 4cc:	ec06                	sd	ra,24(sp)
 4ce:	e822                	sd	s0,16(sp)
 4d0:	1000                	addi	s0,sp,32
 4d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4d6:	4605                	li	a2,1
 4d8:	fef40593          	addi	a1,s0,-17
 4dc:	eb1ff0ef          	jal	38c <write>
}
 4e0:	60e2                	ld	ra,24(sp)
 4e2:	6442                	ld	s0,16(sp)
 4e4:	6105                	addi	sp,sp,32
 4e6:	8082                	ret

00000000000004e8 <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 4ca:	715d                	addi	sp,sp,-80
 4cc:	e486                	sd	ra,72(sp)
 4ce:	e0a2                	sd	s0,64(sp)
 4d0:	f84a                	sd	s2,48(sp)
 4d2:	0880                	addi	s0,sp,80
 4d4:	892a                	mv	s2,a0
=======
 4e8:	715d                	addi	sp,sp,-80
 4ea:	e486                	sd	ra,72(sp)
 4ec:	e0a2                	sd	s0,64(sp)
 4ee:	f84a                	sd	s2,48(sp)
 4f0:	0880                	addi	s0,sp,80
 4f2:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 4d6:	c299                	beqz	a3,4dc <printint+0x12>
 4d8:	0805c363          	bltz	a1,55e <printint+0x94>
  neg = 0;
 4dc:	4881                	li	a7,0
 4de:	fb840693          	addi	a3,s0,-72
=======
 4f4:	c299                	beqz	a3,4fa <printint+0x12>
 4f6:	0805c363          	bltz	a1,57c <printint+0x94>
  neg = 0;
 4fa:	4881                	li	a7,0
 4fc:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 4e2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4e4:	00000517          	auipc	a0,0x0
 4e8:	54450513          	addi	a0,a0,1348 # a28 <digits>
 4ec:	883e                	mv	a6,a5
 4ee:	2785                	addiw	a5,a5,1
 4f0:	02c5f733          	remu	a4,a1,a2
 4f4:	972a                	add	a4,a4,a0
 4f6:	00074703          	lbu	a4,0(a4)
 4fa:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4fe:	872e                	mv	a4,a1
 500:	02c5d5b3          	divu	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fec773e3          	bgeu	a4,a2,4ec <printint+0x22>
  if (neg)
 50a:	00088b63          	beqz	a7,520 <printint+0x56>
    buf[i++] = '-';
 50e:	fd078793          	addi	a5,a5,-48
 512:	97a2                	add	a5,a5,s0
 514:	02d00713          	li	a4,45
 518:	fee78423          	sb	a4,-24(a5)
 51c:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 520:	02f05a63          	blez	a5,554 <printint+0x8a>
 524:	fc26                	sd	s1,56(sp)
 526:	f44e                	sd	s3,40(sp)
 528:	fb840713          	addi	a4,s0,-72
 52c:	00f704b3          	add	s1,a4,a5
 530:	fff70993          	addi	s3,a4,-1
 534:	99be                	add	s3,s3,a5
 536:	37fd                	addiw	a5,a5,-1
 538:	1782                	slli	a5,a5,0x20
 53a:	9381                	srli	a5,a5,0x20
 53c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 540:	fff4c583          	lbu	a1,-1(s1)
 544:	854a                	mv	a0,s2
 546:	f67ff0ef          	jal	4ac <putc>
  while (--i >= 0)
 54a:	14fd                	addi	s1,s1,-1
 54c:	ff349ae3          	bne	s1,s3,540 <printint+0x76>
 550:	74e2                	ld	s1,56(sp)
 552:	79a2                	ld	s3,40(sp)
}
 554:	60a6                	ld	ra,72(sp)
 556:	6406                	ld	s0,64(sp)
 558:	7942                	ld	s2,48(sp)
 55a:	6161                	addi	sp,sp,80
 55c:	8082                	ret
    x = -xx;
 55e:	40b005b3          	neg	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bfad                	j	4de <printint+0x14>

0000000000000566 <vprintf>:
=======
 500:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 502:	00000517          	auipc	a0,0x0
 506:	54650513          	addi	a0,a0,1350 # a48 <digits>
 50a:	883e                	mv	a6,a5
 50c:	2785                	addiw	a5,a5,1
 50e:	02c5f733          	remu	a4,a1,a2
 512:	972a                	add	a4,a4,a0
 514:	00074703          	lbu	a4,0(a4)
 518:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 51c:	872e                	mv	a4,a1
 51e:	02c5d5b3          	divu	a1,a1,a2
 522:	0685                	addi	a3,a3,1
 524:	fec773e3          	bgeu	a4,a2,50a <printint+0x22>
  if (neg)
 528:	00088b63          	beqz	a7,53e <printint+0x56>
    buf[i++] = '-';
 52c:	fd078793          	addi	a5,a5,-48
 530:	97a2                	add	a5,a5,s0
 532:	02d00713          	li	a4,45
 536:	fee78423          	sb	a4,-24(a5)
 53a:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 53e:	02f05a63          	blez	a5,572 <printint+0x8a>
 542:	fc26                	sd	s1,56(sp)
 544:	f44e                	sd	s3,40(sp)
 546:	fb840713          	addi	a4,s0,-72
 54a:	00f704b3          	add	s1,a4,a5
 54e:	fff70993          	addi	s3,a4,-1
 552:	99be                	add	s3,s3,a5
 554:	37fd                	addiw	a5,a5,-1
 556:	1782                	slli	a5,a5,0x20
 558:	9381                	srli	a5,a5,0x20
 55a:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 55e:	fff4c583          	lbu	a1,-1(s1)
 562:	854a                	mv	a0,s2
 564:	f67ff0ef          	jal	4ca <putc>
  while (--i >= 0)
 568:	14fd                	addi	s1,s1,-1
 56a:	ff349ae3          	bne	s1,s3,55e <printint+0x76>
 56e:	74e2                	ld	s1,56(sp)
 570:	79a2                	ld	s3,40(sp)
}
 572:	60a6                	ld	ra,72(sp)
 574:	6406                	ld	s0,64(sp)
 576:	7942                	ld	s2,48(sp)
 578:	6161                	addi	sp,sp,80
 57a:	8082                	ret
    x = -xx;
 57c:	40b005b3          	neg	a1,a1
    neg = 1;
 580:	4885                	li	a7,1
    x = -xx;
 582:	bfad                	j	4fc <printint+0x14>

0000000000000584 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 566:	711d                	addi	sp,sp,-96
 568:	ec86                	sd	ra,88(sp)
 56a:	e8a2                	sd	s0,80(sp)
 56c:	e0ca                	sd	s2,64(sp)
 56e:	1080                	addi	s0,sp,96
=======
 584:	711d                	addi	sp,sp,-96
 586:	ec86                	sd	ra,88(sp)
 588:	e8a2                	sd	s0,80(sp)
 58a:	e0ca                	sd	s2,64(sp)
 58c:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 570:	0005c903          	lbu	s2,0(a1)
 574:	28090663          	beqz	s2,800 <vprintf+0x29a>
 578:	e4a6                	sd	s1,72(sp)
 57a:	fc4e                	sd	s3,56(sp)
 57c:	f852                	sd	s4,48(sp)
 57e:	f456                	sd	s5,40(sp)
 580:	f05a                	sd	s6,32(sp)
 582:	ec5e                	sd	s7,24(sp)
 584:	e862                	sd	s8,16(sp)
 586:	e466                	sd	s9,8(sp)
 588:	8b2a                	mv	s6,a0
 58a:	8a2e                	mv	s4,a1
 58c:	8bb2                	mv	s7,a2
  state = 0;
 58e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 590:	4481                	li	s1,0
 592:	4701                	li	a4,0
=======
 58e:	0005c903          	lbu	s2,0(a1)
 592:	28090663          	beqz	s2,81e <vprintf+0x29a>
 596:	e4a6                	sd	s1,72(sp)
 598:	fc4e                	sd	s3,56(sp)
 59a:	f852                	sd	s4,48(sp)
 59c:	f456                	sd	s5,40(sp)
 59e:	f05a                	sd	s6,32(sp)
 5a0:	ec5e                	sd	s7,24(sp)
 5a2:	e862                	sd	s8,16(sp)
 5a4:	e466                	sd	s9,8(sp)
 5a6:	8b2a                	mv	s6,a0
 5a8:	8a2e                	mv	s4,a1
 5aa:	8bb2                	mv	s7,a2
  state = 0;
 5ac:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5ae:	4481                	li	s1,0
 5b0:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 594:	02500a93          	li	s5,37
=======
 5b2:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 598:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 59c:	06c00c93          	li	s9,108
 5a0:	a005                	j	5c0 <vprintf+0x5a>
        putc(fd, c0);
 5a2:	85ca                	mv	a1,s2
 5a4:	855a                	mv	a0,s6
 5a6:	f07ff0ef          	jal	4ac <putc>
 5aa:	a019                	j	5b0 <vprintf+0x4a>
    } else if (state == '%') {
 5ac:	03598263          	beq	s3,s5,5d0 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5b0:	2485                	addiw	s1,s1,1
 5b2:	8726                	mv	a4,s1
 5b4:	009a07b3          	add	a5,s4,s1
 5b8:	0007c903          	lbu	s2,0(a5)
 5bc:	22090a63          	beqz	s2,7f0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5c0:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5c4:	fe0994e3          	bnez	s3,5ac <vprintf+0x46>
      if (c0 == '%') {
 5c8:	fd579de3          	bne	a5,s5,5a2 <vprintf+0x3c>
        state = '%';
 5cc:	89be                	mv	s3,a5
 5ce:	b7cd                	j	5b0 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5d0:	00ea06b3          	add	a3,s4,a4
 5d4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5d8:	8636                	mv	a2,a3
      if (c1)
 5da:	c681                	beqz	a3,5e2 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5dc:	9752                	add	a4,a4,s4
 5de:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5e2:	05878363          	beq	a5,s8,628 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5e6:	05978d63          	beq	a5,s9,640 <vprintf+0xda>
=======
 5b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5ba:	06c00c93          	li	s9,108
 5be:	a005                	j	5de <vprintf+0x5a>
        putc(fd, c0);
 5c0:	85ca                	mv	a1,s2
 5c2:	855a                	mv	a0,s6
 5c4:	f07ff0ef          	jal	4ca <putc>
 5c8:	a019                	j	5ce <vprintf+0x4a>
    } else if (state == '%') {
 5ca:	03598263          	beq	s3,s5,5ee <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5ce:	2485                	addiw	s1,s1,1
 5d0:	8726                	mv	a4,s1
 5d2:	009a07b3          	add	a5,s4,s1
 5d6:	0007c903          	lbu	s2,0(a5)
 5da:	22090a63          	beqz	s2,80e <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5de:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5e2:	fe0994e3          	bnez	s3,5ca <vprintf+0x46>
      if (c0 == '%') {
 5e6:	fd579de3          	bne	a5,s5,5c0 <vprintf+0x3c>
        state = '%';
 5ea:	89be                	mv	s3,a5
 5ec:	b7cd                	j	5ce <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5ee:	00ea06b3          	add	a3,s4,a4
 5f2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5f6:	8636                	mv	a2,a3
      if (c1)
 5f8:	c681                	beqz	a3,600 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5fa:	9752                	add	a4,a4,s4
 5fc:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 600:	05878363          	beq	a5,s8,646 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 604:	05978d63          	beq	a5,s9,65e <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 5ea:	07500713          	li	a4,117
 5ee:	0ee78763          	beq	a5,a4,6dc <vprintf+0x176>
=======
 608:	07500713          	li	a4,117
 60c:	0ee78763          	beq	a5,a4,6fa <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 5f2:	07800713          	li	a4,120
 5f6:	12e78963          	beq	a5,a4,728 <vprintf+0x1c2>
=======
 610:	07800713          	li	a4,120
 614:	12e78963          	beq	a5,a4,746 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 5fa:	07000713          	li	a4,112
 5fe:	14e78e63          	beq	a5,a4,75a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 602:	06300713          	li	a4,99
 606:	18e78e63          	beq	a5,a4,7a2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 60a:	07300713          	li	a4,115
 60e:	1ae78463          	beq	a5,a4,7b6 <vprintf+0x250>
=======
 618:	07000713          	li	a4,112
 61c:	14e78e63          	beq	a5,a4,778 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 620:	06300713          	li	a4,99
 624:	18e78e63          	beq	a5,a4,7c0 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 628:	07300713          	li	a4,115
 62c:	1ae78463          	beq	a5,a4,7d4 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 612:	02500713          	li	a4,37
 616:	04e79563          	bne	a5,a4,660 <vprintf+0xfa>
        putc(fd, '%');
 61a:	02500593          	li	a1,37
 61e:	855a                	mv	a0,s6
 620:	e8dff0ef          	jal	4ac <putc>
=======
 630:	02500713          	li	a4,37
 634:	04e79563          	bne	a5,a4,67e <vprintf+0xfa>
        putc(fd, '%');
 638:	02500593          	li	a1,37
 63c:	855a                	mv	a0,s6
 63e:	e8dff0ef          	jal	4ca <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 624:	4981                	li	s3,0
 626:	b769                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e95ff0ef          	jal	4ca <printint>
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf8d                	j	5b0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 640:	06400793          	li	a5,100
 644:	02f68963          	beq	a3,a5,676 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 648:	06c00793          	li	a5,108
 64c:	04f68263          	beq	a3,a5,690 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 650:	07500793          	li	a5,117
 654:	0af68063          	beq	a3,a5,6f4 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 658:	07800793          	li	a5,120
 65c:	0ef68263          	beq	a3,a5,740 <vprintf+0x1da>
        putc(fd, '%');
 660:	02500593          	li	a1,37
 664:	855a                	mv	a0,s6
 666:	e47ff0ef          	jal	4ac <putc>
        putc(fd, c0);
 66a:	85ca                	mv	a1,s2
 66c:	855a                	mv	a0,s6
 66e:	e3fff0ef          	jal	4ac <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bf35                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8913          	addi	s2,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	e47ff0ef          	jal	4ca <printint>
        i += 1;
 688:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b70d                	j	5b0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 690:	06400793          	li	a5,100
 694:	02f60763          	beq	a2,a5,6c2 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 698:	07500793          	li	a5,117
 69c:	06f60963          	beq	a2,a5,70e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6a0:	07800793          	li	a5,120
 6a4:	faf61ee3          	bne	a2,a5,660 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	e15ff0ef          	jal	4ca <printint>
        i += 2;
 6ba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 2;
 6c0:	bdc5                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4685                	li	a3,1
 6c8:	4629                	li	a2,10
 6ca:	000bb583          	ld	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	dfbff0ef          	jal	4ca <printint>
        i += 2;
 6d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bdd9                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000be583          	lwu	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	de1ff0ef          	jal	4ca <printint>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bd7d                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4629                	li	a2,10
 6fc:	000bb583          	ld	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	dc9ff0ef          	jal	4ca <printint>
        i += 1;
 706:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b555                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	008b8913          	addi	s2,s7,8
 712:	4681                	li	a3,0
 714:	4629                	li	a2,10
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	dafff0ef          	jal	4ca <printint>
        i += 2;
 720:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	8bca                	mv	s7,s2
      state = 0;
 724:	4981                	li	s3,0
        i += 2;
 726:	b569                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 728:	008b8913          	addi	s2,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000be583          	lwu	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d95ff0ef          	jal	4ca <printint>
 73a:	8bca                	mv	s7,s2
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bd8d                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	008b8913          	addi	s2,s7,8
 744:	4681                	li	a3,0
 746:	4641                	li	a2,16
 748:	000bb583          	ld	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d7dff0ef          	jal	4ca <printint>
        i += 1;
 752:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
        i += 1;
 758:	bda1                	j	5b0 <vprintf+0x4a>
 75a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 75c:	008b8d13          	addi	s10,s7,8
 760:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	855a                	mv	a0,s6
 76a:	d43ff0ef          	jal	4ac <putc>
  putc(fd, 'x');
 76e:	07800593          	li	a1,120
 772:	855a                	mv	a0,s6
 774:	d39ff0ef          	jal	4ac <putc>
 778:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77a:	00000b97          	auipc	s7,0x0
 77e:	2aeb8b93          	addi	s7,s7,686 # a28 <digits>
 782:	03c9d793          	srli	a5,s3,0x3c
 786:	97de                	add	a5,a5,s7
 788:	0007c583          	lbu	a1,0(a5)
 78c:	855a                	mv	a0,s6
 78e:	d1fff0ef          	jal	4ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 792:	0992                	slli	s3,s3,0x4
 794:	397d                	addiw	s2,s2,-1
 796:	fe0916e3          	bnez	s2,782 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 79a:	8bea                	mv	s7,s10
      state = 0;
 79c:	4981                	li	s3,0
 79e:	6d02                	ld	s10,0(sp)
 7a0:	bd01                	j	5b0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7a2:	008b8913          	addi	s2,s7,8
 7a6:	000bc583          	lbu	a1,0(s7)
 7aa:	855a                	mv	a0,s6
 7ac:	d01ff0ef          	jal	4ac <putc>
 7b0:	8bca                	mv	s7,s2
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bbf5                	j	5b0 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7b6:	008b8993          	addi	s3,s7,8
 7ba:	000bb903          	ld	s2,0(s7)
 7be:	00090f63          	beqz	s2,7dc <vprintf+0x276>
        for (; *s; s++)
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	c195                	beqz	a1,7ea <vprintf+0x284>
          putc(fd, *s);
 7c8:	855a                	mv	a0,s6
 7ca:	ce3ff0ef          	jal	4ac <putc>
        for (; *s; s++)
 7ce:	0905                	addi	s2,s2,1
 7d0:	00094583          	lbu	a1,0(s2)
 7d4:	f9f5                	bnez	a1,7c8 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	bbd9                	j	5b0 <vprintf+0x4a>
          s = "(null)";
 7dc:	00000917          	auipc	s2,0x0
 7e0:	24490913          	addi	s2,s2,580 # a20 <malloc+0x138>
        for (; *s; s++)
 7e4:	02800593          	li	a1,40
 7e8:	b7c5                	j	7c8 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7ea:	8bce                	mv	s7,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b3c9                	j	5b0 <vprintf+0x4a>
 7f0:	64a6                	ld	s1,72(sp)
 7f2:	79e2                	ld	s3,56(sp)
 7f4:	7a42                	ld	s4,48(sp)
 7f6:	7aa2                	ld	s5,40(sp)
 7f8:	7b02                	ld	s6,32(sp)
 7fa:	6be2                	ld	s7,24(sp)
 7fc:	6c42                	ld	s8,16(sp)
 7fe:	6ca2                	ld	s9,8(sp)
    }
  }
}
 800:	60e6                	ld	ra,88(sp)
 802:	6446                	ld	s0,80(sp)
 804:	6906                	ld	s2,64(sp)
 806:	6125                	addi	sp,sp,96
 808:	8082                	ret

000000000000080a <fprintf>:
=======
 642:	4981                	li	s3,0
 644:	b769                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 646:	008b8913          	addi	s2,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000ba583          	lw	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e95ff0ef          	jal	4e8 <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bf8d                	j	5ce <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 65e:	06400793          	li	a5,100
 662:	02f68963          	beq	a3,a5,694 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 666:	06c00793          	li	a5,108
 66a:	04f68263          	beq	a3,a5,6ae <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 66e:	07500793          	li	a5,117
 672:	0af68063          	beq	a3,a5,712 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 676:	07800793          	li	a5,120
 67a:	0ef68263          	beq	a3,a5,75e <vprintf+0x1da>
        putc(fd, '%');
 67e:	02500593          	li	a1,37
 682:	855a                	mv	a0,s6
 684:	e47ff0ef          	jal	4ca <putc>
        putc(fd, c0);
 688:	85ca                	mv	a1,s2
 68a:	855a                	mv	a0,s6
 68c:	e3fff0ef          	jal	4ca <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	bf35                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 694:	008b8913          	addi	s2,s7,8
 698:	4685                	li	a3,1
 69a:	4629                	li	a2,10
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	e47ff0ef          	jal	4e8 <printint>
        i += 1;
 6a6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
        i += 1;
 6ac:	b70d                	j	5ce <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6ae:	06400793          	li	a5,100
 6b2:	02f60763          	beq	a2,a5,6e0 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6b6:	07500793          	li	a5,117
 6ba:	06f60963          	beq	a2,a5,72c <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6be:	07800793          	li	a5,120
 6c2:	faf61ee3          	bne	a2,a5,67e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000bb583          	ld	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e15ff0ef          	jal	4e8 <printint>
        i += 2;
 6d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
        i += 2;
 6de:	bdc5                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e0:	008b8913          	addi	s2,s7,8
 6e4:	4685                	li	a3,1
 6e6:	4629                	li	a2,10
 6e8:	000bb583          	ld	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	dfbff0ef          	jal	4e8 <printint>
        i += 2;
 6f2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
        i += 2;
 6f8:	bdd9                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4629                	li	a2,10
 702:	000be583          	lwu	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	de1ff0ef          	jal	4e8 <printint>
 70c:	8bca                	mv	s7,s2
      state = 0;
 70e:	4981                	li	s3,0
 710:	bd7d                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	008b8913          	addi	s2,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000bb583          	ld	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	dc9ff0ef          	jal	4e8 <printint>
        i += 1;
 724:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 726:	8bca                	mv	s7,s2
      state = 0;
 728:	4981                	li	s3,0
        i += 1;
 72a:	b555                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72c:	008b8913          	addi	s2,s7,8
 730:	4681                	li	a3,0
 732:	4629                	li	a2,10
 734:	000bb583          	ld	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	dafff0ef          	jal	4e8 <printint>
        i += 2;
 73e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
        i += 2;
 744:	b569                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 746:	008b8913          	addi	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000be583          	lwu	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	d95ff0ef          	jal	4e8 <printint>
 758:	8bca                	mv	s7,s2
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bd8d                	j	5ce <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75e:	008b8913          	addi	s2,s7,8
 762:	4681                	li	a3,0
 764:	4641                	li	a2,16
 766:	000bb583          	ld	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	d7dff0ef          	jal	4e8 <printint>
        i += 1;
 770:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
        i += 1;
 776:	bda1                	j	5ce <vprintf+0x4a>
 778:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 77a:	008b8d13          	addi	s10,s7,8
 77e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 782:	03000593          	li	a1,48
 786:	855a                	mv	a0,s6
 788:	d43ff0ef          	jal	4ca <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	855a                	mv	a0,s6
 792:	d39ff0ef          	jal	4ca <putc>
 796:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 798:	00000b97          	auipc	s7,0x0
 79c:	2b0b8b93          	addi	s7,s7,688 # a48 <digits>
 7a0:	03c9d793          	srli	a5,s3,0x3c
 7a4:	97de                	add	a5,a5,s7
 7a6:	0007c583          	lbu	a1,0(a5)
 7aa:	855a                	mv	a0,s6
 7ac:	d1fff0ef          	jal	4ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	0992                	slli	s3,s3,0x4
 7b2:	397d                	addiw	s2,s2,-1
 7b4:	fe0916e3          	bnez	s2,7a0 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7b8:	8bea                	mv	s7,s10
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	6d02                	ld	s10,0(sp)
 7be:	bd01                	j	5ce <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	000bc583          	lbu	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	d01ff0ef          	jal	4ca <putc>
 7ce:	8bca                	mv	s7,s2
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bbf5                	j	5ce <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7d4:	008b8993          	addi	s3,s7,8
 7d8:	000bb903          	ld	s2,0(s7)
 7dc:	00090f63          	beqz	s2,7fa <vprintf+0x276>
        for (; *s; s++)
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	c195                	beqz	a1,808 <vprintf+0x284>
          putc(fd, *s);
 7e6:	855a                	mv	a0,s6
 7e8:	ce3ff0ef          	jal	4ca <putc>
        for (; *s; s++)
 7ec:	0905                	addi	s2,s2,1
 7ee:	00094583          	lbu	a1,0(s2)
 7f2:	f9f5                	bnez	a1,7e6 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7f4:	8bce                	mv	s7,s3
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bbd9                	j	5ce <vprintf+0x4a>
          s = "(null)";
 7fa:	00000917          	auipc	s2,0x0
 7fe:	24690913          	addi	s2,s2,582 # a40 <malloc+0x13a>
        for (; *s; s++)
 802:	02800593          	li	a1,40
 806:	b7c5                	j	7e6 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 808:	8bce                	mv	s7,s3
      state = 0;
 80a:	4981                	li	s3,0
 80c:	b3c9                	j	5ce <vprintf+0x4a>
 80e:	64a6                	ld	s1,72(sp)
 810:	79e2                	ld	s3,56(sp)
 812:	7a42                	ld	s4,48(sp)
 814:	7aa2                	ld	s5,40(sp)
 816:	7b02                	ld	s6,32(sp)
 818:	6be2                	ld	s7,24(sp)
 81a:	6c42                	ld	s8,16(sp)
 81c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 81e:	60e6                	ld	ra,88(sp)
 820:	6446                	ld	s0,80(sp)
 822:	6906                	ld	s2,64(sp)
 824:	6125                	addi	sp,sp,96
 826:	8082                	ret

0000000000000828 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 80a:	715d                	addi	sp,sp,-80
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e010                	sd	a2,0(s0)
 814:	e414                	sd	a3,8(s0)
 816:	e818                	sd	a4,16(s0)
 818:	ec1c                	sd	a5,24(s0)
 81a:	03043023          	sd	a6,32(s0)
 81e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 826:	8622                	mv	a2,s0
 828:	d3fff0ef          	jal	566 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:
=======
 828:	715d                	addi	sp,sp,-80
 82a:	ec06                	sd	ra,24(sp)
 82c:	e822                	sd	s0,16(sp)
 82e:	1000                	addi	s0,sp,32
 830:	e010                	sd	a2,0(s0)
 832:	e414                	sd	a3,8(s0)
 834:	e818                	sd	a4,16(s0)
 836:	ec1c                	sd	a5,24(s0)
 838:	03043023          	sd	a6,32(s0)
 83c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 840:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 844:	8622                	mv	a2,s0
 846:	d3fff0ef          	jal	584 <vprintf>
}
 84a:	60e2                	ld	ra,24(sp)
 84c:	6442                	ld	s0,16(sp)
 84e:	6161                	addi	sp,sp,80
 850:	8082                	ret

0000000000000852 <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	d0dff0ef          	jal	566 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6125                	addi	sp,sp,96
 864:	8082                	ret

0000000000000866 <free>:
=======
 852:	711d                	addi	sp,sp,-96
 854:	ec06                	sd	ra,24(sp)
 856:	e822                	sd	s0,16(sp)
 858:	1000                	addi	s0,sp,32
 85a:	e40c                	sd	a1,8(s0)
 85c:	e810                	sd	a2,16(s0)
 85e:	ec14                	sd	a3,24(s0)
 860:	f018                	sd	a4,32(s0)
 862:	f41c                	sd	a5,40(s0)
 864:	03043823          	sd	a6,48(s0)
 868:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	00840613          	addi	a2,s0,8
 870:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 874:	85aa                	mv	a1,a0
 876:	4505                	li	a0,1
 878:	d0dff0ef          	jal	584 <vprintf>
}
 87c:	60e2                	ld	ra,24(sp)
 87e:	6442                	ld	s0,16(sp)
 880:	6125                	addi	sp,sp,96
 882:	8082                	ret

0000000000000884 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 866:	1141                	addi	sp,sp,-16
 868:	e422                	sd	s0,8(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	7907b783          	ld	a5,1936(a5) # 1000 <freep>
 878:	a02d                	j	8a2 <free+0x3c>
=======
 884:	1141                	addi	sp,sp,-16
 886:	e422                	sd	s0,8(sp)
 888:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 88a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	00000797          	auipc	a5,0x0
 892:	7727b783          	ld	a5,1906(a5) # 1000 <freep>
 896:	a02d                	j	8c0 <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 87a:	4618                	lw	a4,8(a2)
 87c:	9f2d                	addw	a4,a4,a1
 87e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6310                	ld	a2,0(a4)
 886:	a83d                	j	8c4 <free+0x5e>
=======
 898:	4618                	lw	a4,8(a2)
 89a:	9f2d                	addw	a4,a4,a1
 89c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	6310                	ld	a2,0(a4)
 8a4:	a83d                	j	8e2 <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 888:	ff852703          	lw	a4,-8(a0)
 88c:	9f31                	addw	a4,a4,a2
 88e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 890:	ff053683          	ld	a3,-16(a0)
 894:	a091                	j	8d8 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 896:	6398                	ld	a4,0(a5)
 898:	00e7e463          	bltu	a5,a4,8a0 <free+0x3a>
 89c:	00e6ea63          	bltu	a3,a4,8b0 <free+0x4a>
{
 8a0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	fed7fae3          	bgeu	a5,a3,896 <free+0x30>
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e6e463          	bltu	a3,a4,8b0 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	fee7eae3          	bltu	a5,a4,8a0 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8b0:	ff852583          	lw	a1,-8(a0)
 8b4:	6390                	ld	a2,0(a5)
 8b6:	02059813          	slli	a6,a1,0x20
 8ba:	01c85713          	srli	a4,a6,0x1c
 8be:	9736                	add	a4,a4,a3
 8c0:	fae60de3          	beq	a2,a4,87a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8c8:	4790                	lw	a2,8(a5)
 8ca:	02061593          	slli	a1,a2,0x20
 8ce:	01c5d713          	srli	a4,a1,0x1c
 8d2:	973e                	add	a4,a4,a5
 8d4:	fae68ae3          	beq	a3,a4,888 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
}
 8e2:	6422                	ld	s0,8(sp)
 8e4:	0141                	addi	sp,sp,16
 8e6:	8082                	ret

00000000000008e8 <malloc>:
=======
 8a6:	ff852703          	lw	a4,-8(a0)
 8aa:	9f31                	addw	a4,a4,a2
 8ac:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ae:	ff053683          	ld	a3,-16(a0)
 8b2:	a091                	j	8f6 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	6398                	ld	a4,0(a5)
 8b6:	00e7e463          	bltu	a5,a4,8be <free+0x3a>
 8ba:	00e6ea63          	bltu	a3,a4,8ce <free+0x4a>
{
 8be:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c0:	fed7fae3          	bgeu	a5,a3,8b4 <free+0x30>
 8c4:	6398                	ld	a4,0(a5)
 8c6:	00e6e463          	bltu	a3,a4,8ce <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ca:	fee7eae3          	bltu	a5,a4,8be <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8ce:	ff852583          	lw	a1,-8(a0)
 8d2:	6390                	ld	a2,0(a5)
 8d4:	02059813          	slli	a6,a1,0x20
 8d8:	01c85713          	srli	a4,a6,0x1c
 8dc:	9736                	add	a4,a4,a3
 8de:	fae60de3          	beq	a2,a4,898 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e2:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8e6:	4790                	lw	a2,8(a5)
 8e8:	02061593          	slli	a1,a2,0x20
 8ec:	01c5d713          	srli	a4,a1,0x1c
 8f0:	973e                	add	a4,a4,a5
 8f2:	fae68ae3          	beq	a3,a4,8a6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8f6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70f73423          	sd	a5,1800(a4) # 1000 <freep>
}
 900:	6422                	ld	s0,8(sp)
 902:	0141                	addi	sp,sp,16
 904:	8082                	ret

0000000000000906 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 8e8:	7139                	addi	sp,sp,-64
 8ea:	fc06                	sd	ra,56(sp)
 8ec:	f822                	sd	s0,48(sp)
 8ee:	f426                	sd	s1,40(sp)
 8f0:	ec4e                	sd	s3,24(sp)
 8f2:	0080                	addi	s0,sp,64
=======
 906:	7139                	addi	sp,sp,-64
 908:	fc06                	sd	ra,56(sp)
 90a:	f822                	sd	s0,48(sp)
 90c:	f426                	sd	s1,40(sp)
 90e:	ec4e                	sd	s3,24(sp)
 910:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 8f4:	02051493          	slli	s1,a0,0x20
 8f8:	9081                	srli	s1,s1,0x20
 8fa:	04bd                	addi	s1,s1,15
 8fc:	8091                	srli	s1,s1,0x4
 8fe:	0014899b          	addiw	s3,s1,1
 902:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 904:	00000517          	auipc	a0,0x0
 908:	6fc53503          	ld	a0,1788(a0) # 1000 <freep>
 90c:	c915                	beqz	a0,940 <malloc+0x58>
=======
 912:	02051493          	slli	s1,a0,0x20
 916:	9081                	srli	s1,s1,0x20
 918:	04bd                	addi	s1,s1,15
 91a:	8091                	srli	s1,s1,0x4
 91c:	0014899b          	addiw	s3,s1,1
 920:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 922:	00000517          	auipc	a0,0x0
 926:	6de53503          	ld	a0,1758(a0) # 1000 <freep>
 92a:	c915                	beqz	a0,95e <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 90e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 910:	4798                	lw	a4,8(a5)
 912:	08977a63          	bgeu	a4,s1,9a6 <malloc+0xbe>
 916:	f04a                	sd	s2,32(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 91e:	8a4e                	mv	s4,s3
 920:	0009871b          	sext.w	a4,s3
 924:	6685                	lui	a3,0x1
 926:	00d77363          	bgeu	a4,a3,92c <malloc+0x44>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
=======
 92c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 92e:	4798                	lw	a4,8(a5)
 930:	08977a63          	bgeu	a4,s1,9c4 <malloc+0xbe>
 934:	f04a                	sd	s2,32(sp)
 936:	e852                	sd	s4,16(sp)
 938:	e456                	sd	s5,8(sp)
 93a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 93c:	8a4e                	mv	s4,s3
 93e:	0009871b          	sext.w	a4,s3
 942:	6685                	lui	a3,0x1
 944:	00d77363          	bgeu	a4,a3,94a <malloc+0x44>
 948:	6a05                	lui	s4,0x1
 94a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 94e:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 934:	00000917          	auipc	s2,0x0
 938:	6cc90913          	addi	s2,s2,1740 # 1000 <freep>
  if (p == SBRK_ERROR)
 93c:	5afd                	li	s5,-1
 93e:	a081                	j	97e <malloc+0x96>
 940:	f04a                	sd	s2,32(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 948:	00000797          	auipc	a5,0x0
 94c:	6c878793          	addi	a5,a5,1736 # 1010 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6af73823          	sd	a5,1712(a4) # 1000 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 95e:	b7c1                	j	91e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	a8a9                	j	9be <malloc+0xd6>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	efbff0ef          	jal	866 <free>
  return freep;
 970:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 974:	c12d                	beqz	a0,9d6 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 976:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 978:	4798                	lw	a4,8(a5)
 97a:	02977263          	bgeu	a4,s1,99e <malloc+0xb6>
    if (p == freep)
 97e:	00093703          	ld	a4,0(s2)
 982:	853e                	mv	a0,a5
 984:	fef719e3          	bne	a4,a5,976 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 988:	8552                	mv	a0,s4
 98a:	9afff0ef          	jal	338 <sbrk>
  if (p == SBRK_ERROR)
 98e:	fd551ce3          	bne	a0,s5,966 <malloc+0x7e>
        return 0;
 992:	4501                	li	a0,0
 994:	7902                	ld	s2,32(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	a03d                	j	9ca <malloc+0xe2>
 99e:	7902                	ld	s2,32(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9a6:	fae48de3          	beq	s1,a4,960 <malloc+0x78>
        p->s.size -= nunits;
 9aa:	4137073b          	subw	a4,a4,s3
 9ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b0:	02071693          	slli	a3,a4,0x20
 9b4:	01c6d713          	srli	a4,a3,0x1c
 9b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9be:	00000717          	auipc	a4,0x0
 9c2:	64a73123          	sd	a0,1602(a4) # 1000 <freep>
      return (void *)(p + 1);
 9c6:	01078513          	addi	a0,a5,16
  }
}
 9ca:	70e2                	ld	ra,56(sp)
 9cc:	7442                	ld	s0,48(sp)
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	69e2                	ld	s3,24(sp)
 9d2:	6121                	addi	sp,sp,64
 9d4:	8082                	ret
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	b7f5                	j	9ca <malloc+0xe2>
=======
 952:	00000917          	auipc	s2,0x0
 956:	6ae90913          	addi	s2,s2,1710 # 1000 <freep>
  if (p == SBRK_ERROR)
 95a:	5afd                	li	s5,-1
 95c:	a081                	j	99c <malloc+0x96>
 95e:	f04a                	sd	s2,32(sp)
 960:	e852                	sd	s4,16(sp)
 962:	e456                	sd	s5,8(sp)
 964:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 966:	00000797          	auipc	a5,0x0
 96a:	6aa78793          	addi	a5,a5,1706 # 1010 <base>
 96e:	00000717          	auipc	a4,0x0
 972:	68f73923          	sd	a5,1682(a4) # 1000 <freep>
 976:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 978:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 97c:	b7c1                	j	93c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 97e:	6398                	ld	a4,0(a5)
 980:	e118                	sd	a4,0(a0)
 982:	a8a9                	j	9dc <malloc+0xd6>
  hp->s.size = nu;
 984:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 988:	0541                	addi	a0,a0,16
 98a:	efbff0ef          	jal	884 <free>
  return freep;
 98e:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 992:	c12d                	beqz	a0,9f4 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 994:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 996:	4798                	lw	a4,8(a5)
 998:	02977263          	bgeu	a4,s1,9bc <malloc+0xb6>
    if (p == freep)
 99c:	00093703          	ld	a4,0(s2)
 9a0:	853e                	mv	a0,a5
 9a2:	fef719e3          	bne	a4,a5,994 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9a6:	8552                	mv	a0,s4
 9a8:	991ff0ef          	jal	338 <sbrk>
  if (p == SBRK_ERROR)
 9ac:	fd551ce3          	bne	a0,s5,984 <malloc+0x7e>
        return 0;
 9b0:	4501                	li	a0,0
 9b2:	7902                	ld	s2,32(sp)
 9b4:	6a42                	ld	s4,16(sp)
 9b6:	6aa2                	ld	s5,8(sp)
 9b8:	6b02                	ld	s6,0(sp)
 9ba:	a03d                	j	9e8 <malloc+0xe2>
 9bc:	7902                	ld	s2,32(sp)
 9be:	6a42                	ld	s4,16(sp)
 9c0:	6aa2                	ld	s5,8(sp)
 9c2:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9c4:	fae48de3          	beq	s1,a4,97e <malloc+0x78>
        p->s.size -= nunits;
 9c8:	4137073b          	subw	a4,a4,s3
 9cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ce:	02071693          	slli	a3,a4,0x20
 9d2:	01c6d713          	srli	a4,a3,0x1c
 9d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9dc:	00000717          	auipc	a4,0x0
 9e0:	62a73223          	sd	a0,1572(a4) # 1000 <freep>
      return (void *)(p + 1);
 9e4:	01078513          	addi	a0,a5,16
  }
}
 9e8:	70e2                	ld	ra,56(sp)
 9ea:	7442                	ld	s0,48(sp)
 9ec:	74a2                	ld	s1,40(sp)
 9ee:	69e2                	ld	s3,24(sp)
 9f0:	6121                	addi	sp,sp,64
 9f2:	8082                	ret
 9f4:	7902                	ld	s2,32(sp)
 9f6:	6a42                	ld	s4,16(sp)
 9f8:	6aa2                	ld	s5,8(sp)
 9fa:	6b02                	ld	s6,0(sp)
 9fc:	b7f5                	j	9e8 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
