
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for (i = 1; i < argc; i++) {
  12:	4785                	li	a5,1
  14:	06a7d063          	bge	a5,a0,74 <main+0x74>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if (i + 1 < argc) {
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
<<<<<<< HEAD
  34:	960a8a93          	addi	s5,s5,-1696 # 990 <malloc+0x106>
=======
  34:	970a8a93          	addi	s5,s5,-1680 # 9a0 <malloc+0xf8>
>>>>>>> e18456e (Updated xv6-riscv)
  38:	a809                	j	4a <main+0x4a>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	2ee000ef          	jal	32e <write>
  for (i = 1; i < argc; i++) {
  44:	04a1                	addi	s1,s1,8
  46:	03348763          	beq	s1,s3,74 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
  4a:	0004b903          	ld	s2,0(s1)
  4e:	854a                	mv	a0,s2
  50:	082000ef          	jal	d2 <strlen>
  54:	0005061b          	sext.w	a2,a0
  58:	85ca                	mv	a1,s2
  5a:	4505                	li	a0,1
  5c:	2d2000ef          	jal	32e <write>
    if (i + 1 < argc) {
  60:	fd449de3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
<<<<<<< HEAD
  6a:	93258593          	addi	a1,a1,-1742 # 998 <malloc+0x10e>
=======
  6a:	94258593          	addi	a1,a1,-1726 # 9a8 <malloc+0x100>
>>>>>>> e18456e (Updated xv6-riscv)
  6e:	4505                	li	a0,1
  70:	2be000ef          	jal	32e <write>
    }
  }
  exit(0);
  74:	4501                	li	a0,0
  76:	298000ef          	jal	30e <exit>

000000000000007a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  82:	f7fff0ef          	jal	0 <main>
  exit(r);
  86:	288000ef          	jal	30e <exit>

000000000000008a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  90:	87aa                	mv	a5,a0
  92:	0585                	addi	a1,a1,1
  94:	0785                	addi	a5,a5,1
  96:	fff5c703          	lbu	a4,-1(a1)
  9a:	fee78fa3          	sb	a4,-1(a5)
  9e:	fb75                	bnez	a4,92 <strcpy+0x8>
    ;
  return os;
}
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb91                	beqz	a5,c4 <strcmp+0x1e>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71763          	bne	a4,a5,c4 <strcmp+0x1e>
    p++, q++;
  ba:	0505                	addi	a0,a0,1
  bc:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	fbe5                	bnez	a5,b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c4:	0005c503          	lbu	a0,0(a1)
}
  c8:	40a7853b          	subw	a0,a5,a0
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cf91                	beqz	a5,f8 <strlen+0x26>
  de:	0505                	addi	a0,a0,1
  e0:	87aa                	mv	a5,a0
  e2:	86be                	mv	a3,a5
  e4:	0785                	addi	a5,a5,1
  e6:	fff7c703          	lbu	a4,-1(a5)
  ea:	ff65                	bnez	a4,e2 <strlen+0x10>
  ec:	40a6853b          	subw	a0,a3,a0
  f0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  for (n = 0; s[n]; n++)
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strlen+0x20>

00000000000000fc <memset>:

void *
memset(void *dst, int c, uint n)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 102:	ca19                	beqz	a2,118 <memset+0x1c>
 104:	87aa                	mv	a5,a0
 106:	1602                	slli	a2,a2,0x20
 108:	9201                	srli	a2,a2,0x20
 10a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 112:	0785                	addi	a5,a5,1
 114:	fee79de3          	bne	a5,a4,10e <memset+0x12>
  }
  return dst;
}
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char *
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  for (; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cb99                	beqz	a5,13e <strchr+0x20>
    if (*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1a>
  for (; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xc>
      return (char *)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfe5                	j	138 <strchr+0x1a>

0000000000000142 <gets>:

char *
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 15c:	892a                	mv	s2,a0
 15e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 160:	4aa9                	li	s5,10
 162:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 164:	89a6                	mv	s3,s1
 166:	2485                	addiw	s1,s1,1
 168:	0344d663          	bge	s1,s4,194 <gets+0x52>
    cc = read(0, &c, 1);
 16c:	4605                	li	a2,1
 16e:	faf40593          	addi	a1,s0,-81
 172:	4501                	li	a0,0
 174:	1b2000ef          	jal	326 <read>
    if (cc < 1)
 178:	00a05e63          	blez	a0,194 <gets+0x52>
    buf[i++] = c;
 17c:	faf44783          	lbu	a5,-81(s0)
 180:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 184:	01578763          	beq	a5,s5,192 <gets+0x50>
 188:	0905                	addi	s2,s2,1
 18a:	fd679de3          	bne	a5,s6,164 <gets+0x22>
    buf[i++] = c;
 18e:	89a6                	mv	s3,s1
 190:	a011                	j	194 <gets+0x52>
 192:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 194:	99de                	add	s3,s3,s7
 196:	00098023          	sb	zero,0(s3)
  return buf;
}
 19a:	855e                	mv	a0,s7
 19c:	60e6                	ld	ra,88(sp)
 19e:	6446                	ld	s0,80(sp)
 1a0:	64a6                	ld	s1,72(sp)
 1a2:	6906                	ld	s2,64(sp)
 1a4:	79e2                	ld	s3,56(sp)
 1a6:	7a42                	ld	s4,48(sp)
 1a8:	7aa2                	ld	s5,40(sp)
 1aa:	7b02                	ld	s6,32(sp)
 1ac:	6be2                	ld	s7,24(sp)
 1ae:	6125                	addi	sp,sp,96
 1b0:	8082                	ret

00000000000001b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	18e000ef          	jal	34e <open>
  if (fd < 0)
 1c4:	02054263          	bltz	a0,1e8 <stat+0x36>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	198000ef          	jal	366 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	160000ef          	jal	336 <close>
  return r;
 1da:	64a2                	ld	s1,8(sp)
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	597d                	li	s2,-1
 1ea:	bfcd                	j	1dc <stat+0x2a>

00000000000001ec <atoi>:

int
atoi(const char *s)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66863          	bltu	a2,a5,230 <atoi+0x44>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1c>
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <atoi+0x3e>

0000000000000234 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57463          	bgeu	a0,a1,262 <memmove+0x2e>
    while (n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x28>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 258:	fef71ae3          	bne	a4,a5,24c <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	6422                	ld	s0,8(sp)
 25e:	0141                	addi	sp,sp,16
 260:	8082                	ret
    dst += n;
 262:	00c50733          	add	a4,a0,a2
    src += n;
 266:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 268:	fec05ae3          	blez	a2,25c <memmove+0x28>
 26c:	fff6079b          	addiw	a5,a2,-1
 270:	1782                	slli	a5,a5,0x20
 272:	9381                	srli	a5,a5,0x20
 274:	fff7c793          	not	a5,a5
 278:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27a:	15fd                	addi	a1,a1,-1
 27c:	177d                	addi	a4,a4,-1
 27e:	0005c683          	lbu	a3,0(a1)
 282:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 286:	fee79ae3          	bne	a5,a4,27a <memmove+0x46>
 28a:	bfc9                	j	25c <memmove+0x28>

000000000000028c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 292:	ca05                	beqz	a2,2c2 <memcmp+0x36>
 294:	fff6069b          	addiw	a3,a2,-1
 298:	1682                	slli	a3,a3,0x20
 29a:	9281                	srli	a3,a3,0x20
 29c:	0685                	addi	a3,a3,1
 29e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x14>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x30>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  return 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <memcmp+0x30>

00000000000002c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ce:	f67ff0ef          	jal	234 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrk>:

char *
sbrk(int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e2:	4585                	li	a1,1
 2e4:	0b2000ef          	jal	396 <sys_sbrk>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <sbrklazy>:

char *
sbrklazy(int n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2f8:	4589                	li	a1,2
 2fa:	09c000ef          	jal	396 <sys_sbrk>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pause>:
.global pause
pause:
 li a7, SYS_pause
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <sync>:
.global sync
sync:
 li a7, SYS_sync
 3ae:	48d9                	li	a7,22
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3b6:	48dd                	li	a7,23
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3be:	48e1                	li	a7,24
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3c6:	48e5                	li	a7,25
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3ce:	48e9                	li	a7,26
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3d6:	48ed                	li	a7,27
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3de:	48f1                	li	a7,28
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3e6:	48f5                	li	a7,29
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3ee:	48f9                	li	a7,30
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3f6:	48fd                	li	a7,31
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3fe:	02000893          	li	a7,32
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <halt>:
.global halt
halt:
 li a7, SYS_halt
 408:	02100893          	li	a7,33
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 412:	02200893          	li	a7,34
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 41c:	02300893          	li	a7,35
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 426:	02400893          	li	a7,36
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 430:	02500893          	li	a7,37
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 43a:	02600893          	li	a7,38
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 444:	02700893          	li	a7,39
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

<<<<<<< HEAD
000000000000044e <putc>:
=======
000000000000044e <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 44e:	02800893          	li	a7,40
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 458:	02900893          	li	a7,41
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 462:	02a00893          	li	a7,42
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 44e:	1101                	addi	sp,sp,-32
 450:	ec06                	sd	ra,24(sp)
 452:	e822                	sd	s0,16(sp)
 454:	1000                	addi	s0,sp,32
 456:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45a:	4605                	li	a2,1
 45c:	fef40593          	addi	a1,s0,-17
 460:	ecfff0ef          	jal	32e <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:
=======
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	eb1ff0ef          	jal	32e <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 46c:	715d                	addi	sp,sp,-80
 46e:	e486                	sd	ra,72(sp)
 470:	e0a2                	sd	s0,64(sp)
 472:	f84a                	sd	s2,48(sp)
 474:	0880                	addi	s0,sp,80
 476:	892a                	mv	s2,a0
=======
 48a:	715d                	addi	sp,sp,-80
 48c:	e486                	sd	ra,72(sp)
 48e:	e0a2                	sd	s0,64(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	0880                	addi	s0,sp,80
 494:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 478:	c299                	beqz	a3,47e <printint+0x12>
 47a:	0805c363          	bltz	a1,500 <printint+0x94>
  neg = 0;
 47e:	4881                	li	a7,0
 480:	fb840693          	addi	a3,s0,-72
=======
 496:	c299                	beqz	a3,49c <printint+0x12>
 498:	0805c363          	bltz	a1,51e <printint+0x94>
  neg = 0;
 49c:	4881                	li	a7,0
 49e:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 484:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 486:	00000517          	auipc	a0,0x0
 48a:	52250513          	addi	a0,a0,1314 # 9a8 <digits>
 48e:	883e                	mv	a6,a5
 490:	2785                	addiw	a5,a5,1
 492:	02c5f733          	remu	a4,a1,a2
 496:	972a                	add	a4,a4,a0
 498:	00074703          	lbu	a4,0(a4)
 49c:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4a0:	872e                	mv	a4,a1
 4a2:	02c5d5b3          	divu	a1,a1,a2
 4a6:	0685                	addi	a3,a3,1
 4a8:	fec773e3          	bgeu	a4,a2,48e <printint+0x22>
  if (neg)
 4ac:	00088b63          	beqz	a7,4c2 <printint+0x56>
    buf[i++] = '-';
 4b0:	fd078793          	addi	a5,a5,-48
 4b4:	97a2                	add	a5,a5,s0
 4b6:	02d00713          	li	a4,45
 4ba:	fee78423          	sb	a4,-24(a5)
 4be:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4c2:	02f05a63          	blez	a5,4f6 <printint+0x8a>
 4c6:	fc26                	sd	s1,56(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	fb840713          	addi	a4,s0,-72
 4ce:	00f704b3          	add	s1,a4,a5
 4d2:	fff70993          	addi	s3,a4,-1
 4d6:	99be                	add	s3,s3,a5
 4d8:	37fd                	addiw	a5,a5,-1
 4da:	1782                	slli	a5,a5,0x20
 4dc:	9381                	srli	a5,a5,0x20
 4de:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4e2:	fff4c583          	lbu	a1,-1(s1)
 4e6:	854a                	mv	a0,s2
 4e8:	f67ff0ef          	jal	44e <putc>
  while (--i >= 0)
 4ec:	14fd                	addi	s1,s1,-1
 4ee:	ff349ae3          	bne	s1,s3,4e2 <printint+0x76>
 4f2:	74e2                	ld	s1,56(sp)
 4f4:	79a2                	ld	s3,40(sp)
}
 4f6:	60a6                	ld	ra,72(sp)
 4f8:	6406                	ld	s0,64(sp)
 4fa:	7942                	ld	s2,48(sp)
 4fc:	6161                	addi	sp,sp,80
 4fe:	8082                	ret
    x = -xx;
 500:	40b005b3          	neg	a1,a1
    neg = 1;
 504:	4885                	li	a7,1
    x = -xx;
 506:	bfad                	j	480 <printint+0x14>

0000000000000508 <vprintf>:
=======
 4a2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4a4:	00000517          	auipc	a0,0x0
 4a8:	51450513          	addi	a0,a0,1300 # 9b8 <digits>
 4ac:	883e                	mv	a6,a5
 4ae:	2785                	addiw	a5,a5,1
 4b0:	02c5f733          	remu	a4,a1,a2
 4b4:	972a                	add	a4,a4,a0
 4b6:	00074703          	lbu	a4,0(a4)
 4ba:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4be:	872e                	mv	a4,a1
 4c0:	02c5d5b3          	divu	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec773e3          	bgeu	a4,a2,4ac <printint+0x22>
  if (neg)
 4ca:	00088b63          	beqz	a7,4e0 <printint+0x56>
    buf[i++] = '-';
 4ce:	fd078793          	addi	a5,a5,-48
 4d2:	97a2                	add	a5,a5,s0
 4d4:	02d00713          	li	a4,45
 4d8:	fee78423          	sb	a4,-24(a5)
 4dc:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4e0:	02f05a63          	blez	a5,514 <printint+0x8a>
 4e4:	fc26                	sd	s1,56(sp)
 4e6:	f44e                	sd	s3,40(sp)
 4e8:	fb840713          	addi	a4,s0,-72
 4ec:	00f704b3          	add	s1,a4,a5
 4f0:	fff70993          	addi	s3,a4,-1
 4f4:	99be                	add	s3,s3,a5
 4f6:	37fd                	addiw	a5,a5,-1
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 500:	fff4c583          	lbu	a1,-1(s1)
 504:	854a                	mv	a0,s2
 506:	f67ff0ef          	jal	46c <putc>
  while (--i >= 0)
 50a:	14fd                	addi	s1,s1,-1
 50c:	ff349ae3          	bne	s1,s3,500 <printint+0x76>
 510:	74e2                	ld	s1,56(sp)
 512:	79a2                	ld	s3,40(sp)
}
 514:	60a6                	ld	ra,72(sp)
 516:	6406                	ld	s0,64(sp)
 518:	7942                	ld	s2,48(sp)
 51a:	6161                	addi	sp,sp,80
 51c:	8082                	ret
    x = -xx;
 51e:	40b005b3          	neg	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bfad                	j	49e <printint+0x14>

0000000000000526 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 508:	711d                	addi	sp,sp,-96
 50a:	ec86                	sd	ra,88(sp)
 50c:	e8a2                	sd	s0,80(sp)
 50e:	e0ca                	sd	s2,64(sp)
 510:	1080                	addi	s0,sp,96
=======
 526:	711d                	addi	sp,sp,-96
 528:	ec86                	sd	ra,88(sp)
 52a:	e8a2                	sd	s0,80(sp)
 52c:	e0ca                	sd	s2,64(sp)
 52e:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 512:	0005c903          	lbu	s2,0(a1)
 516:	28090663          	beqz	s2,7a2 <vprintf+0x29a>
 51a:	e4a6                	sd	s1,72(sp)
 51c:	fc4e                	sd	s3,56(sp)
 51e:	f852                	sd	s4,48(sp)
 520:	f456                	sd	s5,40(sp)
 522:	f05a                	sd	s6,32(sp)
 524:	ec5e                	sd	s7,24(sp)
 526:	e862                	sd	s8,16(sp)
 528:	e466                	sd	s9,8(sp)
 52a:	8b2a                	mv	s6,a0
 52c:	8a2e                	mv	s4,a1
 52e:	8bb2                	mv	s7,a2
  state = 0;
 530:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 532:	4481                	li	s1,0
 534:	4701                	li	a4,0
=======
 530:	0005c903          	lbu	s2,0(a1)
 534:	28090663          	beqz	s2,7c0 <vprintf+0x29a>
 538:	e4a6                	sd	s1,72(sp)
 53a:	fc4e                	sd	s3,56(sp)
 53c:	f852                	sd	s4,48(sp)
 53e:	f456                	sd	s5,40(sp)
 540:	f05a                	sd	s6,32(sp)
 542:	ec5e                	sd	s7,24(sp)
 544:	e862                	sd	s8,16(sp)
 546:	e466                	sd	s9,8(sp)
 548:	8b2a                	mv	s6,a0
 54a:	8a2e                	mv	s4,a1
 54c:	8bb2                	mv	s7,a2
  state = 0;
 54e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 550:	4481                	li	s1,0
 552:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 536:	02500a93          	li	s5,37
=======
 554:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 53a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 53e:	06c00c93          	li	s9,108
 542:	a005                	j	562 <vprintf+0x5a>
        putc(fd, c0);
 544:	85ca                	mv	a1,s2
 546:	855a                	mv	a0,s6
 548:	f07ff0ef          	jal	44e <putc>
 54c:	a019                	j	552 <vprintf+0x4a>
    } else if (state == '%') {
 54e:	03598263          	beq	s3,s5,572 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 552:	2485                	addiw	s1,s1,1
 554:	8726                	mv	a4,s1
 556:	009a07b3          	add	a5,s4,s1
 55a:	0007c903          	lbu	s2,0(a5)
 55e:	22090a63          	beqz	s2,792 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 562:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 566:	fe0994e3          	bnez	s3,54e <vprintf+0x46>
      if (c0 == '%') {
 56a:	fd579de3          	bne	a5,s5,544 <vprintf+0x3c>
        state = '%';
 56e:	89be                	mv	s3,a5
 570:	b7cd                	j	552 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 572:	00ea06b3          	add	a3,s4,a4
 576:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 57a:	8636                	mv	a2,a3
      if (c1)
 57c:	c681                	beqz	a3,584 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 57e:	9752                	add	a4,a4,s4
 580:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 584:	05878363          	beq	a5,s8,5ca <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 588:	05978d63          	beq	a5,s9,5e2 <vprintf+0xda>
=======
 558:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 55c:	06c00c93          	li	s9,108
 560:	a005                	j	580 <vprintf+0x5a>
        putc(fd, c0);
 562:	85ca                	mv	a1,s2
 564:	855a                	mv	a0,s6
 566:	f07ff0ef          	jal	46c <putc>
 56a:	a019                	j	570 <vprintf+0x4a>
    } else if (state == '%') {
 56c:	03598263          	beq	s3,s5,590 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 570:	2485                	addiw	s1,s1,1
 572:	8726                	mv	a4,s1
 574:	009a07b3          	add	a5,s4,s1
 578:	0007c903          	lbu	s2,0(a5)
 57c:	22090a63          	beqz	s2,7b0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 580:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 584:	fe0994e3          	bnez	s3,56c <vprintf+0x46>
      if (c0 == '%') {
 588:	fd579de3          	bne	a5,s5,562 <vprintf+0x3c>
        state = '%';
 58c:	89be                	mv	s3,a5
 58e:	b7cd                	j	570 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 590:	00ea06b3          	add	a3,s4,a4
 594:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 598:	8636                	mv	a2,a3
      if (c1)
 59a:	c681                	beqz	a3,5a2 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 59c:	9752                	add	a4,a4,s4
 59e:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5a2:	05878363          	beq	a5,s8,5e8 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5a6:	05978d63          	beq	a5,s9,600 <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 58c:	07500713          	li	a4,117
 590:	0ee78763          	beq	a5,a4,67e <vprintf+0x176>
=======
 5aa:	07500713          	li	a4,117
 5ae:	0ee78763          	beq	a5,a4,69c <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 594:	07800713          	li	a4,120
 598:	12e78963          	beq	a5,a4,6ca <vprintf+0x1c2>
=======
 5b2:	07800713          	li	a4,120
 5b6:	12e78963          	beq	a5,a4,6e8 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 59c:	07000713          	li	a4,112
 5a0:	14e78e63          	beq	a5,a4,6fc <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5a4:	06300713          	li	a4,99
 5a8:	18e78e63          	beq	a5,a4,744 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ac:	07300713          	li	a4,115
 5b0:	1ae78463          	beq	a5,a4,758 <vprintf+0x250>
=======
 5ba:	07000713          	li	a4,112
 5be:	14e78e63          	beq	a5,a4,71a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5c2:	06300713          	li	a4,99
 5c6:	18e78e63          	beq	a5,a4,762 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ca:	07300713          	li	a4,115
 5ce:	1ae78463          	beq	a5,a4,776 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 5b4:	02500713          	li	a4,37
 5b8:	04e79563          	bne	a5,a4,602 <vprintf+0xfa>
        putc(fd, '%');
 5bc:	02500593          	li	a1,37
 5c0:	855a                	mv	a0,s6
 5c2:	e8dff0ef          	jal	44e <putc>
=======
 5d2:	02500713          	li	a4,37
 5d6:	04e79563          	bne	a5,a4,620 <vprintf+0xfa>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	855a                	mv	a0,s6
 5e0:	e8dff0ef          	jal	46c <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 5c6:	4981                	li	s3,0
 5c8:	b769                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e95ff0ef          	jal	46c <printint>
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bf8d                	j	552 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5e2:	06400793          	li	a5,100
 5e6:	02f68963          	beq	a3,a5,618 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ea:	06c00793          	li	a5,108
 5ee:	04f68263          	beq	a3,a5,632 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5f2:	07500793          	li	a5,117
 5f6:	0af68063          	beq	a3,a5,696 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5fa:	07800793          	li	a5,120
 5fe:	0ef68263          	beq	a3,a5,6e2 <vprintf+0x1da>
        putc(fd, '%');
 602:	02500593          	li	a1,37
 606:	855a                	mv	a0,s6
 608:	e47ff0ef          	jal	44e <putc>
        putc(fd, c0);
 60c:	85ca                	mv	a1,s2
 60e:	855a                	mv	a0,s6
 610:	e3fff0ef          	jal	44e <putc>
      state = 0;
 614:	4981                	li	s3,0
 616:	bf35                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	008b8913          	addi	s2,s7,8
 61c:	4685                	li	a3,1
 61e:	4629                	li	a2,10
 620:	000bb583          	ld	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	e47ff0ef          	jal	46c <printint>
        i += 1;
 62a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	8bca                	mv	s7,s2
      state = 0;
 62e:	4981                	li	s3,0
        i += 1;
 630:	b70d                	j	552 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 632:	06400793          	li	a5,100
 636:	02f60763          	beq	a2,a5,664 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 63a:	07500793          	li	a5,117
 63e:	06f60963          	beq	a2,a5,6b0 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 642:	07800793          	li	a5,120
 646:	faf61ee3          	bne	a2,a5,602 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e15ff0ef          	jal	46c <printint>
        i += 2;
 65c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bdc5                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	008b8913          	addi	s2,s7,8
 668:	4685                	li	a3,1
 66a:	4629                	li	a2,10
 66c:	000bb583          	ld	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	dfbff0ef          	jal	46c <printint>
        i += 2;
 676:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	bdd9                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 67e:	008b8913          	addi	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000be583          	lwu	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	de1ff0ef          	jal	46c <printint>
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
 694:	bd7d                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	008b8913          	addi	s2,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	dc9ff0ef          	jal	46c <printint>
        i += 1;
 6a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
        i += 1;
 6ae:	b555                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b8913          	addi	s2,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000bb583          	ld	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	dafff0ef          	jal	46c <printint>
        i += 2;
 6c2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	b569                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000be583          	lwu	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d95ff0ef          	jal	46c <printint>
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bd8d                	j	552 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000bb583          	ld	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d7dff0ef          	jal	46c <printint>
        i += 1;
 6f4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
        i += 1;
 6fa:	bda1                	j	552 <vprintf+0x4a>
 6fc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6fe:	008b8d13          	addi	s10,s7,8
 702:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 706:	03000593          	li	a1,48
 70a:	855a                	mv	a0,s6
 70c:	d43ff0ef          	jal	44e <putc>
  putc(fd, 'x');
 710:	07800593          	li	a1,120
 714:	855a                	mv	a0,s6
 716:	d39ff0ef          	jal	44e <putc>
 71a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71c:	00000b97          	auipc	s7,0x0
 720:	28cb8b93          	addi	s7,s7,652 # 9a8 <digits>
 724:	03c9d793          	srli	a5,s3,0x3c
 728:	97de                	add	a5,a5,s7
 72a:	0007c583          	lbu	a1,0(a5)
 72e:	855a                	mv	a0,s6
 730:	d1fff0ef          	jal	44e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 734:	0992                	slli	s3,s3,0x4
 736:	397d                	addiw	s2,s2,-1
 738:	fe0916e3          	bnez	s2,724 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 73c:	8bea                	mv	s7,s10
      state = 0;
 73e:	4981                	li	s3,0
 740:	6d02                	ld	s10,0(sp)
 742:	bd01                	j	552 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 744:	008b8913          	addi	s2,s7,8
 748:	000bc583          	lbu	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d01ff0ef          	jal	44e <putc>
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	bbf5                	j	552 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 758:	008b8993          	addi	s3,s7,8
 75c:	000bb903          	ld	s2,0(s7)
 760:	00090f63          	beqz	s2,77e <vprintf+0x276>
        for (; *s; s++)
 764:	00094583          	lbu	a1,0(s2)
 768:	c195                	beqz	a1,78c <vprintf+0x284>
          putc(fd, *s);
 76a:	855a                	mv	a0,s6
 76c:	ce3ff0ef          	jal	44e <putc>
        for (; *s; s++)
 770:	0905                	addi	s2,s2,1
 772:	00094583          	lbu	a1,0(s2)
 776:	f9f5                	bnez	a1,76a <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	bbd9                	j	552 <vprintf+0x4a>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	22290913          	addi	s2,s2,546 # 9a0 <malloc+0x116>
        for (; *s; s++)
 786:	02800593          	li	a1,40
 78a:	b7c5                	j	76a <vprintf+0x262>
=======
 5e4:	4981                	li	s3,0
 5e6:	b769                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e95ff0ef          	jal	48a <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bf8d                	j	570 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 600:	06400793          	li	a5,100
 604:	02f68963          	beq	a3,a5,636 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 608:	06c00793          	li	a5,108
 60c:	04f68263          	beq	a3,a5,650 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 610:	07500793          	li	a5,117
 614:	0af68063          	beq	a3,a5,6b4 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 618:	07800793          	li	a5,120
 61c:	0ef68263          	beq	a3,a5,700 <vprintf+0x1da>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	855a                	mv	a0,s6
 626:	e47ff0ef          	jal	46c <putc>
        putc(fd, c0);
 62a:	85ca                	mv	a1,s2
 62c:	855a                	mv	a0,s6
 62e:	e3fff0ef          	jal	46c <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bf35                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8913          	addi	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e47ff0ef          	jal	48a <printint>
        i += 1;
 648:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 1;
 64e:	b70d                	j	570 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 650:	06400793          	li	a5,100
 654:	02f60763          	beq	a2,a5,682 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 658:	07500793          	li	a5,117
 65c:	06f60963          	beq	a2,a5,6ce <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 660:	07800793          	li	a5,120
 664:	faf61ee3          	bne	a2,a5,620 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e15ff0ef          	jal	48a <printint>
        i += 2;
 67a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bdc5                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dfbff0ef          	jal	48a <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bdd9                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000be583          	lwu	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	de1ff0ef          	jal	48a <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd7d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dc9ff0ef          	jal	48a <printint>
        i += 1;
 6c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 1;
 6cc:	b555                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	dafff0ef          	jal	48a <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	b569                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000be583          	lwu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d95ff0ef          	jal	48a <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd8d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	d7dff0ef          	jal	48a <printint>
        i += 1;
 712:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 1;
 718:	bda1                	j	570 <vprintf+0x4a>
 71a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 71c:	008b8d13          	addi	s10,s7,8
 720:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 724:	03000593          	li	a1,48
 728:	855a                	mv	a0,s6
 72a:	d43ff0ef          	jal	46c <putc>
  putc(fd, 'x');
 72e:	07800593          	li	a1,120
 732:	855a                	mv	a0,s6
 734:	d39ff0ef          	jal	46c <putc>
 738:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73a:	00000b97          	auipc	s7,0x0
 73e:	27eb8b93          	addi	s7,s7,638 # 9b8 <digits>
 742:	03c9d793          	srli	a5,s3,0x3c
 746:	97de                	add	a5,a5,s7
 748:	0007c583          	lbu	a1,0(a5)
 74c:	855a                	mv	a0,s6
 74e:	d1fff0ef          	jal	46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	slli	s3,s3,0x4
 754:	397d                	addiw	s2,s2,-1
 756:	fe0916e3          	bnez	s2,742 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 75a:	8bea                	mv	s7,s10
      state = 0;
 75c:	4981                	li	s3,0
 75e:	6d02                	ld	s10,0(sp)
 760:	bd01                	j	570 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 762:	008b8913          	addi	s2,s7,8
 766:	000bc583          	lbu	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	d01ff0ef          	jal	46c <putc>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	bbf5                	j	570 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 776:	008b8993          	addi	s3,s7,8
 77a:	000bb903          	ld	s2,0(s7)
 77e:	00090f63          	beqz	s2,79c <vprintf+0x276>
        for (; *s; s++)
 782:	00094583          	lbu	a1,0(s2)
 786:	c195                	beqz	a1,7aa <vprintf+0x284>
          putc(fd, *s);
 788:	855a                	mv	a0,s6
 78a:	ce3ff0ef          	jal	46c <putc>
        for (; *s; s++)
 78e:	0905                	addi	s2,s2,1
 790:	00094583          	lbu	a1,0(s2)
 794:	f9f5                	bnez	a1,788 <vprintf+0x262>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
<<<<<<< HEAD
 78e:	4981                	li	s3,0
 790:	b3c9                	j	552 <vprintf+0x4a>
 792:	64a6                	ld	s1,72(sp)
 794:	79e2                	ld	s3,56(sp)
 796:	7a42                	ld	s4,48(sp)
 798:	7aa2                	ld	s5,40(sp)
 79a:	7b02                	ld	s6,32(sp)
 79c:	6be2                	ld	s7,24(sp)
 79e:	6c42                	ld	s8,16(sp)
 7a0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a2:	60e6                	ld	ra,88(sp)
 7a4:	6446                	ld	s0,80(sp)
 7a6:	6906                	ld	s2,64(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <fprintf>:
=======
 798:	4981                	li	s3,0
 79a:	bbd9                	j	570 <vprintf+0x4a>
          s = "(null)";
 79c:	00000917          	auipc	s2,0x0
 7a0:	21490913          	addi	s2,s2,532 # 9b0 <malloc+0x108>
        for (; *s; s++)
 7a4:	02800593          	li	a1,40
 7a8:	b7c5                	j	788 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b3c9                	j	570 <vprintf+0x4a>
 7b0:	64a6                	ld	s1,72(sp)
 7b2:	79e2                	ld	s3,56(sp)
 7b4:	7a42                	ld	s4,48(sp)
 7b6:	7aa2                	ld	s5,40(sp)
 7b8:	7b02                	ld	s6,32(sp)
 7ba:	6be2                	ld	s7,24(sp)
 7bc:	6c42                	ld	s8,16(sp)
 7be:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c0:	60e6                	ld	ra,88(sp)
 7c2:	6446                	ld	s0,80(sp)
 7c4:	6906                	ld	s2,64(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 7ac:	715d                	addi	sp,sp,-80
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e010                	sd	a2,0(s0)
 7b6:	e414                	sd	a3,8(s0)
 7b8:	e818                	sd	a4,16(s0)
 7ba:	ec1c                	sd	a5,24(s0)
 7bc:	03043023          	sd	a6,32(s0)
 7c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c8:	8622                	mv	a2,s0
 7ca:	d3fff0ef          	jal	508 <vprintf>
}
 7ce:	60e2                	ld	ra,24(sp)
 7d0:	6442                	ld	s0,16(sp)
 7d2:	6161                	addi	sp,sp,80
 7d4:	8082                	ret

00000000000007d6 <printf>:
=======
 7ca:	715d                	addi	sp,sp,-80
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e010                	sd	a2,0(s0)
 7d4:	e414                	sd	a3,8(s0)
 7d6:	e818                	sd	a4,16(s0)
 7d8:	ec1c                	sd	a5,24(s0)
 7da:	03043023          	sd	a6,32(s0)
 7de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e6:	8622                	mv	a2,s0
 7e8:	d3fff0ef          	jal	526 <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6161                	addi	sp,sp,80
 7f2:	8082                	ret

00000000000007f4 <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 7d6:	711d                	addi	sp,sp,-96
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	e40c                	sd	a1,8(s0)
 7e0:	e810                	sd	a2,16(s0)
 7e2:	ec14                	sd	a3,24(s0)
 7e4:	f018                	sd	a4,32(s0)
 7e6:	f41c                	sd	a5,40(s0)
 7e8:	03043823          	sd	a6,48(s0)
 7ec:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	00840613          	addi	a2,s0,8
 7f4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f8:	85aa                	mv	a1,a0
 7fa:	4505                	li	a0,1
 7fc:	d0dff0ef          	jal	508 <vprintf>
}
 800:	60e2                	ld	ra,24(sp)
 802:	6442                	ld	s0,16(sp)
 804:	6125                	addi	sp,sp,96
 806:	8082                	ret

0000000000000808 <free>:
=======
 7f4:	711d                	addi	sp,sp,-96
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	e40c                	sd	a1,8(s0)
 7fe:	e810                	sd	a2,16(s0)
 800:	ec14                	sd	a3,24(s0)
 802:	f018                	sd	a4,32(s0)
 804:	f41c                	sd	a5,40(s0)
 806:	03043823          	sd	a6,48(s0)
 80a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	00840613          	addi	a2,s0,8
 812:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 816:	85aa                	mv	a1,a0
 818:	4505                	li	a0,1
 81a:	d0dff0ef          	jal	526 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6125                	addi	sp,sp,96
 824:	8082                	ret

0000000000000826 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 808:	1141                	addi	sp,sp,-16
 80a:	e422                	sd	s0,8(sp)
 80c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 80e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	00000797          	auipc	a5,0x0
 816:	7ee7b783          	ld	a5,2030(a5) # 1000 <freep>
 81a:	a02d                	j	844 <free+0x3c>
=======
 826:	1141                	addi	sp,sp,-16
 828:	e422                	sd	s0,8(sp)
 82a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 82c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	00000797          	auipc	a5,0x0
 834:	7d07b783          	ld	a5,2000(a5) # 1000 <freep>
 838:	a02d                	j	862 <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 81c:	4618                	lw	a4,8(a2)
 81e:	9f2d                	addw	a4,a4,a1
 820:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	6310                	ld	a2,0(a4)
 828:	a83d                	j	866 <free+0x5e>
=======
 83a:	4618                	lw	a4,8(a2)
 83c:	9f2d                	addw	a4,a4,a1
 83e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	6310                	ld	a2,0(a4)
 846:	a83d                	j	884 <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 82a:	ff852703          	lw	a4,-8(a0)
 82e:	9f31                	addw	a4,a4,a2
 830:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 832:	ff053683          	ld	a3,-16(a0)
 836:	a091                	j	87a <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	6398                	ld	a4,0(a5)
 83a:	00e7e463          	bltu	a5,a4,842 <free+0x3a>
 83e:	00e6ea63          	bltu	a3,a4,852 <free+0x4a>
{
 842:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	fed7fae3          	bgeu	a5,a3,838 <free+0x30>
 848:	6398                	ld	a4,0(a5)
 84a:	00e6e463          	bltu	a3,a4,852 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	fee7eae3          	bltu	a5,a4,842 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 852:	ff852583          	lw	a1,-8(a0)
 856:	6390                	ld	a2,0(a5)
 858:	02059813          	slli	a6,a1,0x20
 85c:	01c85713          	srli	a4,a6,0x1c
 860:	9736                	add	a4,a4,a3
 862:	fae60de3          	beq	a2,a4,81c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 86a:	4790                	lw	a2,8(a5)
 86c:	02061593          	slli	a1,a2,0x20
 870:	01c5d713          	srli	a4,a1,0x1c
 874:	973e                	add	a4,a4,a5
 876:	fae68ae3          	beq	a3,a4,82a <free+0x22>
    p->s.ptr = bp->s.ptr;
 87a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
}
 884:	6422                	ld	s0,8(sp)
 886:	0141                	addi	sp,sp,16
 888:	8082                	ret

000000000000088a <malloc>:
=======
 848:	ff852703          	lw	a4,-8(a0)
 84c:	9f31                	addw	a4,a4,a2
 84e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 850:	ff053683          	ld	a3,-16(a0)
 854:	a091                	j	898 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x3a>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x4a>
{
 860:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x30>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059813          	slli	a6,a1,0x20
 87a:	01c85713          	srli	a4,a6,0x1c
 87e:	9736                	add	a4,a4,a3
 880:	fae60de3          	beq	a2,a4,83a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 888:	4790                	lw	a2,8(a5)
 88a:	02061593          	slli	a1,a2,0x20
 88e:	01c5d713          	srli	a4,a1,0x1c
 892:	973e                	add	a4,a4,a5
 894:	fae68ae3          	beq	a3,a4,848 <free+0x22>
    p->s.ptr = bp->s.ptr;
 898:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
}
 8a2:	6422                	ld	s0,8(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 88a:	7139                	addi	sp,sp,-64
 88c:	fc06                	sd	ra,56(sp)
 88e:	f822                	sd	s0,48(sp)
 890:	f426                	sd	s1,40(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	0080                	addi	s0,sp,64
=======
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 896:	02051493          	slli	s1,a0,0x20
 89a:	9081                	srli	s1,s1,0x20
 89c:	04bd                	addi	s1,s1,15
 89e:	8091                	srli	s1,s1,0x4
 8a0:	0014899b          	addiw	s3,s1,1
 8a4:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8a6:	00000517          	auipc	a0,0x0
 8aa:	75a53503          	ld	a0,1882(a0) # 1000 <freep>
 8ae:	c915                	beqz	a0,8e2 <malloc+0x58>
=======
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8c4:	00000517          	auipc	a0,0x0
 8c8:	73c53503          	ld	a0,1852(a0) # 1000 <freep>
 8cc:	c915                	beqz	a0,900 <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 8b0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b2:	4798                	lw	a4,8(a5)
 8b4:	08977a63          	bgeu	a4,s1,948 <malloc+0xbe>
 8b8:	f04a                	sd	s2,32(sp)
 8ba:	e852                	sd	s4,16(sp)
 8bc:	e456                	sd	s5,8(sp)
 8be:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8c0:	8a4e                	mv	s4,s3
 8c2:	0009871b          	sext.w	a4,s3
 8c6:	6685                	lui	a3,0x1
 8c8:	00d77363          	bgeu	a4,a3,8ce <malloc+0x44>
 8cc:	6a05                	lui	s4,0x1
 8ce:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d2:	004a1a1b          	slliw	s4,s4,0x4
=======
 8ce:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8d0:	4798                	lw	a4,8(a5)
 8d2:	08977a63          	bgeu	a4,s1,966 <malloc+0xbe>
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8de:	8a4e                	mv	s4,s3
 8e0:	0009871b          	sext.w	a4,s3
 8e4:	6685                	lui	a3,0x1
 8e6:	00d77363          	bgeu	a4,a3,8ec <malloc+0x44>
 8ea:	6a05                	lui	s4,0x1
 8ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f0:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 8d6:	00000917          	auipc	s2,0x0
 8da:	72a90913          	addi	s2,s2,1834 # 1000 <freep>
  if (p == SBRK_ERROR)
 8de:	5afd                	li	s5,-1
 8e0:	a081                	j	920 <malloc+0x96>
 8e2:	f04a                	sd	s2,32(sp)
 8e4:	e852                	sd	s4,16(sp)
 8e6:	e456                	sd	s5,8(sp)
 8e8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ea:	00000797          	auipc	a5,0x0
 8ee:	72678793          	addi	a5,a5,1830 # 1010 <base>
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73723          	sd	a5,1806(a4) # 1000 <freep>
 8fa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 900:	b7c1                	j	8c0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 902:	6398                	ld	a4,0(a5)
 904:	e118                	sd	a4,0(a0)
 906:	a8a9                	j	960 <malloc+0xd6>
  hp->s.size = nu;
 908:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 90c:	0541                	addi	a0,a0,16
 90e:	efbff0ef          	jal	808 <free>
  return freep;
 912:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 916:	c12d                	beqz	a0,978 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 918:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 91a:	4798                	lw	a4,8(a5)
 91c:	02977263          	bgeu	a4,s1,940 <malloc+0xb6>
    if (p == freep)
 920:	00093703          	ld	a4,0(s2)
 924:	853e                	mv	a0,a5
 926:	fef719e3          	bne	a4,a5,918 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 92a:	8552                	mv	a0,s4
 92c:	9afff0ef          	jal	2da <sbrk>
  if (p == SBRK_ERROR)
 930:	fd551ce3          	bne	a0,s5,908 <malloc+0x7e>
        return 0;
 934:	4501                	li	a0,0
 936:	7902                	ld	s2,32(sp)
 938:	6a42                	ld	s4,16(sp)
 93a:	6aa2                	ld	s5,8(sp)
 93c:	6b02                	ld	s6,0(sp)
 93e:	a03d                	j	96c <malloc+0xe2>
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 948:	fae48de3          	beq	s1,a4,902 <malloc+0x78>
        p->s.size -= nunits;
 94c:	4137073b          	subw	a4,a4,s3
 950:	c798                	sw	a4,8(a5)
        p += p->s.size;
 952:	02071693          	slli	a3,a4,0x20
 956:	01c6d713          	srli	a4,a3,0x1c
 95a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 960:	00000717          	auipc	a4,0x0
 964:	6aa73023          	sd	a0,1696(a4) # 1000 <freep>
      return (void *)(p + 1);
 968:	01078513          	addi	a0,a5,16
  }
}
 96c:	70e2                	ld	ra,56(sp)
 96e:	7442                	ld	s0,48(sp)
 970:	74a2                	ld	s1,40(sp)
 972:	69e2                	ld	s3,24(sp)
 974:	6121                	addi	sp,sp,64
 976:	8082                	ret
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	b7f5                	j	96c <malloc+0xe2>
=======
 8f4:	00000917          	auipc	s2,0x0
 8f8:	70c90913          	addi	s2,s2,1804 # 1000 <freep>
  if (p == SBRK_ERROR)
 8fc:	5afd                	li	s5,-1
 8fe:	a081                	j	93e <malloc+0x96>
 900:	f04a                	sd	s2,32(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 908:	00000797          	auipc	a5,0x0
 90c:	70878793          	addi	a5,a5,1800 # 1010 <base>
 910:	00000717          	auipc	a4,0x0
 914:	6ef73823          	sd	a5,1776(a4) # 1000 <freep>
 918:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 91e:	b7c1                	j	8de <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	e118                	sd	a4,0(a0)
 924:	a8a9                	j	97e <malloc+0xd6>
  hp->s.size = nu;
 926:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 92a:	0541                	addi	a0,a0,16
 92c:	efbff0ef          	jal	826 <free>
  return freep;
 930:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 934:	c12d                	beqz	a0,996 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 936:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 938:	4798                	lw	a4,8(a5)
 93a:	02977263          	bgeu	a4,s1,95e <malloc+0xb6>
    if (p == freep)
 93e:	00093703          	ld	a4,0(s2)
 942:	853e                	mv	a0,a5
 944:	fef719e3          	bne	a4,a5,936 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	991ff0ef          	jal	2da <sbrk>
  if (p == SBRK_ERROR)
 94e:	fd551ce3          	bne	a0,s5,926 <malloc+0x7e>
        return 0;
 952:	4501                	li	a0,0
 954:	7902                	ld	s2,32(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	a03d                	j	98a <malloc+0xe2>
 95e:	7902                	ld	s2,32(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 966:	fae48de3          	beq	s1,a4,920 <malloc+0x78>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	68a73123          	sd	a0,1666(a4) # 1000 <freep>
      return (void *)(p + 1);
 986:	01078513          	addi	a0,a5,16
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	74a2                	ld	s1,40(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
 996:	7902                	ld	s2,32(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
 99e:	b7f5                	j	98a <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
