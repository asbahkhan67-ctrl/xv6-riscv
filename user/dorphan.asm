
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
  10:	99450513          	addi	a0,a0,-1644 # 9a0 <malloc+0x106>
  14:	372000ef          	jal	386 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	98c50513          	addi	a0,a0,-1652 # 9a8 <malloc+0x10e>
  24:	7c2000ef          	jal	7e6 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	2f4000ef          	jal	31e <exit>
  }

  if (chdir("dd") != 0) {
  2e:	00001517          	auipc	a0,0x1
  32:	97250513          	addi	a0,a0,-1678 # 9a0 <malloc+0x106>
  36:	358000ef          	jal	38e <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	98250513          	addi	a0,a0,-1662 # 9c0 <malloc+0x126>
  46:	7a0000ef          	jal	7e6 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2d2000ef          	jal	31e <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	98850513          	addi	a0,a0,-1656 # 9d8 <malloc+0x13e>
  58:	316000ef          	jal	36e <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	99850513          	addi	a0,a0,-1640 # 9f8 <malloc+0x15e>
  68:	77e000ef          	jal	7e6 <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	33e000ef          	jal	3ae <pause>
  for (;;)
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	96850513          	addi	a0,a0,-1688 # 9e0 <malloc+0x146>
  80:	766000ef          	jal	7e6 <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	298000ef          	jal	31e <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  92:	f6fff0ef          	jal	0 <main>
  exit(r);
  96:	288000ef          	jal	31e <exit>

000000000000009a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  a0:	87aa                	mv	a5,a0
  a2:	0585                	addi	a1,a1,1
  a4:	0785                	addi	a5,a5,1
  a6:	fff5c703          	lbu	a4,-1(a1)
  aa:	fee78fa3          	sb	a4,-1(a5)
  ae:	fb75                	bnez	a4,a2 <strcpy+0x8>
    ;
  return os;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cb91                	beqz	a5,d4 <strcmp+0x1e>
  c2:	0005c703          	lbu	a4,0(a1)
  c6:	00f71763          	bne	a4,a5,d4 <strcmp+0x1e>
    p++, q++;
  ca:	0505                	addi	a0,a0,1
  cc:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	fbe5                	bnez	a5,c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d4:	0005c503          	lbu	a0,0(a1)
}
  d8:	40a7853b          	subw	a0,a5,a0
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  e8:	00054783          	lbu	a5,0(a0)
  ec:	cf91                	beqz	a5,108 <strlen+0x26>
  ee:	0505                	addi	a0,a0,1
  f0:	87aa                	mv	a5,a0
  f2:	86be                	mv	a3,a5
  f4:	0785                	addi	a5,a5,1
  f6:	fff7c703          	lbu	a4,-1(a5)
  fa:	ff65                	bnez	a4,f2 <strlen+0x10>
  fc:	40a6853b          	subw	a0,a3,a0
 100:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 102:	6422                	ld	s0,8(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  for (n = 0; s[n]; n++)
 108:	4501                	li	a0,0
 10a:	bfe5                	j	102 <strlen+0x20>

000000000000010c <memset>:

void *
memset(void *dst, int c, uint n)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 112:	ca19                	beqz	a2,128 <memset+0x1c>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x12>
  }
  return dst;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char *
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  for (; *s; s++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb99                	beqz	a5,14e <strchr+0x20>
    if (*s == c)
 13a:	00f58763          	beq	a1,a5,148 <strchr+0x1a>
  for (; *s; s++)
 13e:	0505                	addi	a0,a0,1
 140:	00054783          	lbu	a5,0(a0)
 144:	fbfd                	bnez	a5,13a <strchr+0xc>
      return (char *)s;
  return 0;
 146:	4501                	li	a0,0
}
 148:	6422                	ld	s0,8(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  return 0;
 14e:	4501                	li	a0,0
 150:	bfe5                	j	148 <strchr+0x1a>

0000000000000152 <gets>:

char *
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	1080                	addi	s0,sp,96
 168:	8baa                	mv	s7,a0
 16a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 16c:	892a                	mv	s2,a0
 16e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 170:	4aa9                	li	s5,10
 172:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 174:	89a6                	mv	s3,s1
 176:	2485                	addiw	s1,s1,1
 178:	0344d663          	bge	s1,s4,1a4 <gets+0x52>
    cc = read(0, &c, 1);
 17c:	4605                	li	a2,1
 17e:	faf40593          	addi	a1,s0,-81
 182:	4501                	li	a0,0
 184:	1b2000ef          	jal	336 <read>
    if (cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x52>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x50>
 198:	0905                	addi	s2,s2,1
 19a:	fd679de3          	bne	a5,s6,174 <gets+0x22>
    buf[i++] = c;
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x52>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e04a                	sd	s2,0(sp)
 1ca:	1000                	addi	s0,sp,32
 1cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ce:	4581                	li	a1,0
 1d0:	18e000ef          	jal	35e <open>
  if (fd < 0)
 1d4:	02054263          	bltz	a0,1f8 <stat+0x36>
 1d8:	e426                	sd	s1,8(sp)
 1da:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1dc:	85ca                	mv	a1,s2
 1de:	198000ef          	jal	376 <fstat>
 1e2:	892a                	mv	s2,a0
  close(fd);
 1e4:	8526                	mv	a0,s1
 1e6:	160000ef          	jal	346 <close>
  return r;
 1ea:	64a2                	ld	s1,8(sp)
}
 1ec:	854a                	mv	a0,s2
 1ee:	60e2                	ld	ra,24(sp)
 1f0:	6442                	ld	s0,16(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    return -1;
 1f8:	597d                	li	s2,-1
 1fa:	bfcd                	j	1ec <stat+0x2a>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	4625                	li	a2,9
 210:	02f66863          	bltu	a2,a5,240 <atoi+0x44>
 214:	872a                	mv	a4,a0
  n = 0;
 216:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 218:	0705                	addi	a4,a4,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb5                	addw	a5,a5,a3
 226:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 22a:	00074683          	lbu	a3,0(a4)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x1c>
  return n;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  n = 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <atoi+0x3e>

0000000000000244 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57463          	bgeu	a0,a1,272 <memmove+0x2e>
    while (n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x28>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 268:	fef71ae3          	bne	a4,a5,25c <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
    dst += n;
 272:	00c50733          	add	a4,a0,a2
    src += n;
 276:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 278:	fec05ae3          	blez	a2,26c <memmove+0x28>
 27c:	fff6079b          	addiw	a5,a2,-1
 280:	1782                	slli	a5,a5,0x20
 282:	9381                	srli	a5,a5,0x20
 284:	fff7c793          	not	a5,a5
 288:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28a:	15fd                	addi	a1,a1,-1
 28c:	177d                	addi	a4,a4,-1
 28e:	0005c683          	lbu	a3,0(a1)
 292:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 296:	fee79ae3          	bne	a5,a4,28a <memmove+0x46>
 29a:	bfc9                	j	26c <memmove+0x28>

000000000000029c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a2:	ca05                	beqz	a2,2d2 <memcmp+0x36>
 2a4:	fff6069b          	addiw	a3,a2,-1
 2a8:	1682                	slli	a3,a3,0x20
 2aa:	9281                	srli	a3,a3,0x20
 2ac:	0685                	addi	a3,a3,1
 2ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79863          	bne	a5,a4,2c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x14>
  }
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	a019                	j	2cc <memcmp+0x30>
      return *p1 - *p2;
 2c8:	40e7853b          	subw	a0,a5,a4
}
 2cc:	6422                	ld	s0,8(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	bfe5                	j	2cc <memcmp+0x30>

00000000000002d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d6:	1141                	addi	sp,sp,-16
 2d8:	e406                	sd	ra,8(sp)
 2da:	e022                	sd	s0,0(sp)
 2dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2de:	f67ff0ef          	jal	244 <memmove>
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <sbrk>:

char *
sbrk(int n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f2:	4585                	li	a1,1
 2f4:	0b2000ef          	jal	3a6 <sys_sbrk>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrklazy>:

char *
sbrklazy(int n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 308:	4589                	li	a1,2
 30a:	09c000ef          	jal	3a6 <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 316:	4885                	li	a7,1
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exit>:
.global exit
exit:
 li a7, SYS_exit
 31e:	4889                	li	a7,2
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <wait>:
.global wait
wait:
 li a7, SYS_wait
 326:	488d                	li	a7,3
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32e:	4891                	li	a7,4
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <read>:
.global read
read:
 li a7, SYS_read
 336:	4895                	li	a7,5
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <write>:
.global write
write:
 li a7, SYS_write
 33e:	48c1                	li	a7,16
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <close>:
.global close
close:
 li a7, SYS_close
 346:	48d5                	li	a7,21
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <kill>:
.global kill
kill:
 li a7, SYS_kill
 34e:	4899                	li	a7,6
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exec>:
.global exec
exec:
 li a7, SYS_exec
 356:	489d                	li	a7,7
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <open>:
.global open
open:
 li a7, SYS_open
 35e:	48bd                	li	a7,15
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 366:	48c5                	li	a7,17
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36e:	48c9                	li	a7,18
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 376:	48a1                	li	a7,8
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <link>:
.global link
link:
 li a7, SYS_link
 37e:	48cd                	li	a7,19
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 386:	48d1                	li	a7,20
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38e:	48a5                	li	a7,9
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <dup>:
.global dup
dup:
 li a7, SYS_dup
 396:	48a9                	li	a7,10
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39e:	48ad                	li	a7,11
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a6:	48b1                	li	a7,12
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ae:	48b5                	li	a7,13
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b6:	48b9                	li	a7,14
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sync>:
.global sync
sync:
 li a7, SYS_sync
 3be:	48d9                	li	a7,22
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3c6:	48dd                	li	a7,23
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3ce:	48e1                	li	a7,24
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3d6:	48e5                	li	a7,25
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3de:	48e9                	li	a7,26
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3e6:	48ed                	li	a7,27
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3ee:	48f1                	li	a7,28
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3f6:	48f5                	li	a7,29
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3fe:	48f9                	li	a7,30
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 406:	48fd                	li	a7,31
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 40e:	02000893          	li	a7,32
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <halt>:
.global halt
halt:
 li a7, SYS_halt
 418:	02100893          	li	a7,33
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 422:	02200893          	li	a7,34
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 42c:	02300893          	li	a7,35
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 436:	02400893          	li	a7,36
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 440:	02500893          	li	a7,37
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 44a:	02600893          	li	a7,38
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 454:	02700893          	li	a7,39
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45e:	1101                	addi	sp,sp,-32
 460:	ec06                	sd	ra,24(sp)
 462:	e822                	sd	s0,16(sp)
 464:	1000                	addi	s0,sp,32
 466:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46a:	4605                	li	a2,1
 46c:	fef40593          	addi	a1,s0,-17
 470:	ecfff0ef          	jal	33e <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 47c:	715d                	addi	sp,sp,-80
 47e:	e486                	sd	ra,72(sp)
 480:	e0a2                	sd	s0,64(sp)
 482:	f84a                	sd	s2,48(sp)
 484:	0880                	addi	s0,sp,80
 486:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 488:	c299                	beqz	a3,48e <printint+0x12>
 48a:	0805c363          	bltz	a1,510 <printint+0x94>
  neg = 0;
 48e:	4881                	li	a7,0
 490:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 494:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 496:	00000517          	auipc	a0,0x0
 49a:	58a50513          	addi	a0,a0,1418 # a20 <digits>
 49e:	883e                	mv	a6,a5
 4a0:	2785                	addiw	a5,a5,1
 4a2:	02c5f733          	remu	a4,a1,a2
 4a6:	972a                	add	a4,a4,a0
 4a8:	00074703          	lbu	a4,0(a4)
 4ac:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4b0:	872e                	mv	a4,a1
 4b2:	02c5d5b3          	divu	a1,a1,a2
 4b6:	0685                	addi	a3,a3,1
 4b8:	fec773e3          	bgeu	a4,a2,49e <printint+0x22>
  if (neg)
 4bc:	00088b63          	beqz	a7,4d2 <printint+0x56>
    buf[i++] = '-';
 4c0:	fd078793          	addi	a5,a5,-48
 4c4:	97a2                	add	a5,a5,s0
 4c6:	02d00713          	li	a4,45
 4ca:	fee78423          	sb	a4,-24(a5)
 4ce:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4d2:	02f05a63          	blez	a5,506 <printint+0x8a>
 4d6:	fc26                	sd	s1,56(sp)
 4d8:	f44e                	sd	s3,40(sp)
 4da:	fb840713          	addi	a4,s0,-72
 4de:	00f704b3          	add	s1,a4,a5
 4e2:	fff70993          	addi	s3,a4,-1
 4e6:	99be                	add	s3,s3,a5
 4e8:	37fd                	addiw	a5,a5,-1
 4ea:	1782                	slli	a5,a5,0x20
 4ec:	9381                	srli	a5,a5,0x20
 4ee:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4f2:	fff4c583          	lbu	a1,-1(s1)
 4f6:	854a                	mv	a0,s2
 4f8:	f67ff0ef          	jal	45e <putc>
  while (--i >= 0)
 4fc:	14fd                	addi	s1,s1,-1
 4fe:	ff349ae3          	bne	s1,s3,4f2 <printint+0x76>
 502:	74e2                	ld	s1,56(sp)
 504:	79a2                	ld	s3,40(sp)
}
 506:	60a6                	ld	ra,72(sp)
 508:	6406                	ld	s0,64(sp)
 50a:	7942                	ld	s2,48(sp)
 50c:	6161                	addi	sp,sp,80
 50e:	8082                	ret
    x = -xx;
 510:	40b005b3          	neg	a1,a1
    neg = 1;
 514:	4885                	li	a7,1
    x = -xx;
 516:	bfad                	j	490 <printint+0x14>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	711d                	addi	sp,sp,-96
 51a:	ec86                	sd	ra,88(sp)
 51c:	e8a2                	sd	s0,80(sp)
 51e:	e0ca                	sd	s2,64(sp)
 520:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 522:	0005c903          	lbu	s2,0(a1)
 526:	28090663          	beqz	s2,7b2 <vprintf+0x29a>
 52a:	e4a6                	sd	s1,72(sp)
 52c:	fc4e                	sd	s3,56(sp)
 52e:	f852                	sd	s4,48(sp)
 530:	f456                	sd	s5,40(sp)
 532:	f05a                	sd	s6,32(sp)
 534:	ec5e                	sd	s7,24(sp)
 536:	e862                	sd	s8,16(sp)
 538:	e466                	sd	s9,8(sp)
 53a:	8b2a                	mv	s6,a0
 53c:	8a2e                	mv	s4,a1
 53e:	8bb2                	mv	s7,a2
  state = 0;
 540:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 542:	4481                	li	s1,0
 544:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 546:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 54a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 54e:	06c00c93          	li	s9,108
 552:	a005                	j	572 <vprintf+0x5a>
        putc(fd, c0);
 554:	85ca                	mv	a1,s2
 556:	855a                	mv	a0,s6
 558:	f07ff0ef          	jal	45e <putc>
 55c:	a019                	j	562 <vprintf+0x4a>
    } else if (state == '%') {
 55e:	03598263          	beq	s3,s5,582 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 562:	2485                	addiw	s1,s1,1
 564:	8726                	mv	a4,s1
 566:	009a07b3          	add	a5,s4,s1
 56a:	0007c903          	lbu	s2,0(a5)
 56e:	22090a63          	beqz	s2,7a2 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 572:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 576:	fe0994e3          	bnez	s3,55e <vprintf+0x46>
      if (c0 == '%') {
 57a:	fd579de3          	bne	a5,s5,554 <vprintf+0x3c>
        state = '%';
 57e:	89be                	mv	s3,a5
 580:	b7cd                	j	562 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 58a:	8636                	mv	a2,a3
      if (c1)
 58c:	c681                	beqz	a3,594 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 58e:	9752                	add	a4,a4,s4
 590:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 594:	05878363          	beq	a5,s8,5da <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 598:	05978d63          	beq	a5,s9,5f2 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 59c:	07500713          	li	a4,117
 5a0:	0ee78763          	beq	a5,a4,68e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5a4:	07800713          	li	a4,120
 5a8:	12e78963          	beq	a5,a4,6da <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5ac:	07000713          	li	a4,112
 5b0:	14e78e63          	beq	a5,a4,70c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5b4:	06300713          	li	a4,99
 5b8:	18e78e63          	beq	a5,a4,754 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5bc:	07300713          	li	a4,115
 5c0:	1ae78463          	beq	a5,a4,768 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5c4:	02500713          	li	a4,37
 5c8:	04e79563          	bne	a5,a4,612 <vprintf+0xfa>
        putc(fd, '%');
 5cc:	02500593          	li	a1,37
 5d0:	855a                	mv	a0,s6
 5d2:	e8dff0ef          	jal	45e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b769                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e95ff0ef          	jal	47c <printint>
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf8d                	j	562 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5f2:	06400793          	li	a5,100
 5f6:	02f68963          	beq	a3,a5,628 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5fa:	06c00793          	li	a5,108
 5fe:	04f68263          	beq	a3,a5,642 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 602:	07500793          	li	a5,117
 606:	0af68063          	beq	a3,a5,6a6 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 60a:	07800793          	li	a5,120
 60e:	0ef68263          	beq	a3,a5,6f2 <vprintf+0x1da>
        putc(fd, '%');
 612:	02500593          	li	a1,37
 616:	855a                	mv	a0,s6
 618:	e47ff0ef          	jal	45e <putc>
        putc(fd, c0);
 61c:	85ca                	mv	a1,s2
 61e:	855a                	mv	a0,s6
 620:	e3fff0ef          	jal	45e <putc>
      state = 0;
 624:	4981                	li	s3,0
 626:	bf35                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8913          	addi	s2,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e47ff0ef          	jal	47c <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	b70d                	j	562 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 642:	06400793          	li	a5,100
 646:	02f60763          	beq	a2,a5,674 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 64a:	07500793          	li	a5,117
 64e:	06f60963          	beq	a2,a5,6c0 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 652:	07800793          	li	a5,120
 656:	faf61ee3          	bne	a2,a5,612 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e15ff0ef          	jal	47c <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bdc5                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	addi	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dfbff0ef          	jal	47c <printint>
        i += 2;
 686:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	bdd9                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000be583          	lwu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	de1ff0ef          	jal	47c <printint>
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bd7d                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dc9ff0ef          	jal	47c <printint>
        i += 1;
 6b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	b555                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4629                	li	a2,10
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	dafff0ef          	jal	47c <printint>
        i += 2;
 6d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	b569                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6da:	008b8913          	addi	s2,s7,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000be583          	lwu	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	d95ff0ef          	jal	47c <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bd8d                	j	562 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d7dff0ef          	jal	47c <printint>
        i += 1;
 704:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 1;
 70a:	bda1                	j	562 <vprintf+0x4a>
 70c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 70e:	008b8d13          	addi	s10,s7,8
 712:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 716:	03000593          	li	a1,48
 71a:	855a                	mv	a0,s6
 71c:	d43ff0ef          	jal	45e <putc>
  putc(fd, 'x');
 720:	07800593          	li	a1,120
 724:	855a                	mv	a0,s6
 726:	d39ff0ef          	jal	45e <putc>
 72a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72c:	00000b97          	auipc	s7,0x0
 730:	2f4b8b93          	addi	s7,s7,756 # a20 <digits>
 734:	03c9d793          	srli	a5,s3,0x3c
 738:	97de                	add	a5,a5,s7
 73a:	0007c583          	lbu	a1,0(a5)
 73e:	855a                	mv	a0,s6
 740:	d1fff0ef          	jal	45e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	397d                	addiw	s2,s2,-1
 748:	fe0916e3          	bnez	s2,734 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 74c:	8bea                	mv	s7,s10
      state = 0;
 74e:	4981                	li	s3,0
 750:	6d02                	ld	s10,0(sp)
 752:	bd01                	j	562 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 754:	008b8913          	addi	s2,s7,8
 758:	000bc583          	lbu	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	d01ff0ef          	jal	45e <putc>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	bbf5                	j	562 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 768:	008b8993          	addi	s3,s7,8
 76c:	000bb903          	ld	s2,0(s7)
 770:	00090f63          	beqz	s2,78e <vprintf+0x276>
        for (; *s; s++)
 774:	00094583          	lbu	a1,0(s2)
 778:	c195                	beqz	a1,79c <vprintf+0x284>
          putc(fd, *s);
 77a:	855a                	mv	a0,s6
 77c:	ce3ff0ef          	jal	45e <putc>
        for (; *s; s++)
 780:	0905                	addi	s2,s2,1
 782:	00094583          	lbu	a1,0(s2)
 786:	f9f5                	bnez	a1,77a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 788:	8bce                	mv	s7,s3
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bbd9                	j	562 <vprintf+0x4a>
          s = "(null)";
 78e:	00000917          	auipc	s2,0x0
 792:	28a90913          	addi	s2,s2,650 # a18 <malloc+0x17e>
        for (; *s; s++)
 796:	02800593          	li	a1,40
 79a:	b7c5                	j	77a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b3c9                	j	562 <vprintf+0x4a>
 7a2:	64a6                	ld	s1,72(sp)
 7a4:	79e2                	ld	s3,56(sp)
 7a6:	7a42                	ld	s4,48(sp)
 7a8:	7aa2                	ld	s5,40(sp)
 7aa:	7b02                	ld	s6,32(sp)
 7ac:	6be2                	ld	s7,24(sp)
 7ae:	6c42                	ld	s8,16(sp)
 7b0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b2:	60e6                	ld	ra,88(sp)
 7b4:	6446                	ld	s0,80(sp)
 7b6:	6906                	ld	s2,64(sp)
 7b8:	6125                	addi	sp,sp,96
 7ba:	8082                	ret

00000000000007bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7bc:	715d                	addi	sp,sp,-80
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e010                	sd	a2,0(s0)
 7c6:	e414                	sd	a3,8(s0)
 7c8:	e818                	sd	a4,16(s0)
 7ca:	ec1c                	sd	a5,24(s0)
 7cc:	03043023          	sd	a6,32(s0)
 7d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d8:	8622                	mv	a2,s0
 7da:	d3fff0ef          	jal	518 <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6161                	addi	sp,sp,80
 7e4:	8082                	ret

00000000000007e6 <printf>:

void
printf(const char *fmt, ...)
{
 7e6:	711d                	addi	sp,sp,-96
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	1000                	addi	s0,sp,32
 7ee:	e40c                	sd	a1,8(s0)
 7f0:	e810                	sd	a2,16(s0)
 7f2:	ec14                	sd	a3,24(s0)
 7f4:	f018                	sd	a4,32(s0)
 7f6:	f41c                	sd	a5,40(s0)
 7f8:	03043823          	sd	a6,48(s0)
 7fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 800:	00840613          	addi	a2,s0,8
 804:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 808:	85aa                	mv	a1,a0
 80a:	4505                	li	a0,1
 80c:	d0dff0ef          	jal	518 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6125                	addi	sp,sp,96
 816:	8082                	ret

0000000000000818 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 818:	1141                	addi	sp,sp,-16
 81a:	e422                	sd	s0,8(sp)
 81c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 81e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	7de7b783          	ld	a5,2014(a5) # 1000 <freep>
 82a:	a02d                	j	854 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9f2d                	addw	a4,a4,a1
 830:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6310                	ld	a2,0(a4)
 838:	a83d                	j	876 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9f31                	addw	a4,a4,a2
 840:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053683          	ld	a3,-16(a0)
 846:	a091                	j	88a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	6398                	ld	a4,0(a5)
 84a:	00e7e463          	bltu	a5,a4,852 <free+0x3a>
 84e:	00e6ea63          	bltu	a3,a4,862 <free+0x4a>
{
 852:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	fed7fae3          	bgeu	a5,a3,848 <free+0x30>
 858:	6398                	ld	a4,0(a5)
 85a:	00e6e463          	bltu	a3,a4,862 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	fee7eae3          	bltu	a5,a4,852 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 862:	ff852583          	lw	a1,-8(a0)
 866:	6390                	ld	a2,0(a5)
 868:	02059813          	slli	a6,a1,0x20
 86c:	01c85713          	srli	a4,a6,0x1c
 870:	9736                	add	a4,a4,a3
 872:	fae60de3          	beq	a2,a4,82c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 87a:	4790                	lw	a2,8(a5)
 87c:	02061593          	slli	a1,a2,0x20
 880:	01c5d713          	srli	a4,a1,0x1c
 884:	973e                	add	a4,a4,a5
 886:	fae68ae3          	beq	a3,a4,83a <free+0x22>
    p->s.ptr = bp->s.ptr;
 88a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88c:	00000717          	auipc	a4,0x0
 890:	76f73a23          	sd	a5,1908(a4) # 1000 <freep>
}
 894:	6422                	ld	s0,8(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret

000000000000089a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 89a:	7139                	addi	sp,sp,-64
 89c:	fc06                	sd	ra,56(sp)
 89e:	f822                	sd	s0,48(sp)
 8a0:	f426                	sd	s1,40(sp)
 8a2:	ec4e                	sd	s3,24(sp)
 8a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8a6:	02051493          	slli	s1,a0,0x20
 8aa:	9081                	srli	s1,s1,0x20
 8ac:	04bd                	addi	s1,s1,15
 8ae:	8091                	srli	s1,s1,0x4
 8b0:	0014899b          	addiw	s3,s1,1
 8b4:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8b6:	00000517          	auipc	a0,0x0
 8ba:	74a53503          	ld	a0,1866(a0) # 1000 <freep>
 8be:	c915                	beqz	a0,8f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c2:	4798                	lw	a4,8(a5)
 8c4:	08977a63          	bgeu	a4,s1,958 <malloc+0xbe>
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8d0:	8a4e                	mv	s4,s3
 8d2:	0009871b          	sext.w	a4,s3
 8d6:	6685                	lui	a3,0x1
 8d8:	00d77363          	bgeu	a4,a3,8de <malloc+0x44>
 8dc:	6a05                	lui	s4,0x1
 8de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8e6:	00000917          	auipc	s2,0x0
 8ea:	71a90913          	addi	s2,s2,1818 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ee:	5afd                	li	s5,-1
 8f0:	a081                	j	930 <malloc+0x96>
 8f2:	f04a                	sd	s2,32(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fa:	00001797          	auipc	a5,0x1
 8fe:	90e78793          	addi	a5,a5,-1778 # 1208 <base>
 902:	00000717          	auipc	a4,0x0
 906:	6ef73f23          	sd	a5,1790(a4) # 1000 <freep>
 90a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 910:	b7c1                	j	8d0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	a8a9                	j	970 <malloc+0xd6>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 91c:	0541                	addi	a0,a0,16
 91e:	efbff0ef          	jal	818 <free>
  return freep;
 922:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 926:	c12d                	beqz	a0,988 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 928:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 92a:	4798                	lw	a4,8(a5)
 92c:	02977263          	bgeu	a4,s1,950 <malloc+0xb6>
    if (p == freep)
 930:	00093703          	ld	a4,0(s2)
 934:	853e                	mv	a0,a5
 936:	fef719e3          	bne	a4,a5,928 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 93a:	8552                	mv	a0,s4
 93c:	9afff0ef          	jal	2ea <sbrk>
  if (p == SBRK_ERROR)
 940:	fd551ce3          	bne	a0,s5,918 <malloc+0x7e>
        return 0;
 944:	4501                	li	a0,0
 946:	7902                	ld	s2,32(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
 94e:	a03d                	j	97c <malloc+0xe2>
 950:	7902                	ld	s2,32(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 958:	fae48de3          	beq	s1,a4,912 <malloc+0x78>
        p->s.size -= nunits;
 95c:	4137073b          	subw	a4,a4,s3
 960:	c798                	sw	a4,8(a5)
        p += p->s.size;
 962:	02071693          	slli	a3,a4,0x20
 966:	01c6d713          	srli	a4,a3,0x1c
 96a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 970:	00000717          	auipc	a4,0x0
 974:	68a73823          	sd	a0,1680(a4) # 1000 <freep>
      return (void *)(p + 1);
 978:	01078513          	addi	a0,a5,16
  }
}
 97c:	70e2                	ld	ra,56(sp)
 97e:	7442                	ld	s0,48(sp)
 980:	74a2                	ld	s1,40(sp)
 982:	69e2                	ld	s3,24(sp)
 984:	6121                	addi	sp,sp,64
 986:	8082                	ret
 988:	7902                	ld	s2,32(sp)
 98a:	6a42                	ld	s4,16(sp)
 98c:	6aa2                	ld	s5,8(sp)
 98e:	6b02                	ld	s6,0(sp)
 990:	b7f5                	j	97c <malloc+0xe2>
